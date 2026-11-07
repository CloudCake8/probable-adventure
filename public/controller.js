(() => {
  const $ = (id) => document.getElementById(id);
  const store = {
    get(k, d) { try { return localStorage.getItem(k) ?? d; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch { } },
  };
  const pid = store.get('pid', null) || (store.set('pid', Math.random().toString(36).slice(2) + Date.now().toString(36)), store.get('pid'));
  let hand = Number(store.get('hand', '1')) === -1 ? -1 : 1;
  $('name').value = store.get('name', '');
  // the screen whose QR this phone scanned: linked to it (kept until another screen's QR is scanned)
  const qsScreen = (new URLSearchParams(location.search).get('s') || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8);
  if (qsScreen) store.set('screen', qsScreen);
  const screen = store.get('screen', '');
  if (screen) $('linkinfo').textContent = `📺 Links to screen ${screen}: your name shows in its chat, and it shows your end of the table.`;

  let ws = null, seat = -1, open = false, motionDenied = false;
  const secure = window.isSecureContext;
  $('sensorinfo').innerHTML = secure ? '' : '<span class="warn">This page is not HTTPS, so the browser will not give motion data. Open the https:// link.</span>';

  let aimFlip = store.get('aimflip', '1') === '1';
  function setFlip(v) { aimFlip = v; store.set('aimflip', v ? '1' : '0'); const el = $('flip'); if (el) el.textContent = 'Aim direction: ' + (v ? 'flipped' : 'normal') + ' (tap to switch)'; send({ t: 'aimflip', v }); }
  function setHand(h) {
    hand = h; store.set('hand', String(h));
    document.querySelectorAll('.seg button').forEach((b) => b.classList.toggle('on', Number(b.dataset.h) === h));
    send({ t: 'hand', hand: h });
  }
  document.querySelectorAll('.seg button').forEach((b) => b.addEventListener('click', () => setHand(Number(b.dataset.h))));
  setHand(hand);
  if ($('flip')) $('flip').addEventListener('click', () => setFlip(!aimFlip));

  // ---- socket --------------------------------------------------------------------------------
  function send(o) { if (ws && ws.readyState === 1) ws.send(JSON.stringify(o)); }
  function connect() {
    ws = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws');
    ws.onopen = () => { open = true; send({ t: 'hello', role: 'pad', pid, name: $('name').value.trim(), hand, screen }); setPill('connected', 'ok'); setFlip(aimFlip); };
    ws.onclose = () => { open = false; setPill('reconnecting...', 'bad'); setTimeout(connect, 1000); };
    ws.onmessage = (e) => onMsg(JSON.parse(e.data));
  }
  function setPill(t, c) { const p = $('pill'); p.textContent = t; p.className = c || ''; }

  let last = null, roster = null, mySid = 0;
  function onMsg(m) {
    if (m.t === 'seat') { seat = m.seat; mySid = m.sid || mySid; updateSeat(); }
    else if (m.t === 'st') { last = m; if (m.seat !== seat) { seat = m.seat; updateSeat(); } render(m); }
    else if (m.t === 'fb') feedback(m);
    else if (m.t === 'swung') { $('meter').firstElementChild.style.width = Math.round(m.power * 100) + '%'; $('pad').classList.add('flash'); setTimeout(() => $('pad').classList.remove('flash'), 140); }
    else if (m.t === 'roster') { roster = m; updateSeat(); }
    else if (m.t === 'chatlog') { $('clog').textContent = ''; m.list.forEach((x) => addChat(x, true)); }
    else if (m.t === 'chat') addChat(m);
    else if (m.t === 'name') { $('name').value = m.name; $('myname').value = m.name; store.set('name', m.name); }   // renamed (here or on the linked screen)
    else if (m.t === 'link') { const b = $('linkbadge'); b.style.display = m.screen ? '' : 'none'; b.textContent = '📺 ' + m.screen + (m.on ? '' : ' (off)'); b.title = m.on ? 'Linked to this screen' : 'Your screen is not connected'; }
    else if (m.t === 'note') { $('fb').textContent = m.text; clearTimeout(fbTimer); fbTimer = setTimeout(() => { $('fb').textContent = ''; }, 1600); }
  }
  // playing or watching: the switch button, and the pad becomes a wave button for spectators
  const PAD_PLAY = $('padtext').innerHTML;
  function updateSeat() {
    $('seatlabel').textContent = seat >= 0 ? 'Player ' + (seat + 1) : 'Spectating';
    const open = !!roster && roster.players.some((p) => p.kind !== 'human'), b = $('rolebtn');
    if (seat >= 0) { b.textContent = 'Spectate'; b.disabled = false; } else { b.textContent = open ? 'Play' : 'Seats full'; b.disabled = !open; }
    $('pad').classList.toggle('spec', seat < 0);
    if (!motionDenied) $('padtext').innerHTML = seat < 0 ? '👋 Tap to wave<br><small style="font-size:14px;font-weight:600;color:var(--dim)">or just move your phone: your hand on the sideline follows it</small>' : PAD_PLAY;
    const key = roster && JSON.stringify([roster.players, roster.specs.length, seat]);
    if (key && key !== pplKey) {             // rebuilt only on change, so a tap on a kick button isn't lost
      pplKey = key; const ppl = $('ppl');
      ppl.textContent = `Playing: ${roster.players.map((p) => p.name || (p.kind === 'cpu' ? 'CPU' : 'open seat')).join(' vs ')} · ${roster.specs.length} spectating`;
      for (const p of roster.players) if (p.kind === 'human' && p.seat !== seat) {   // anyone can move an AFK player to the sideline
        const b = document.createElement('button'); b.textContent = 'Kick ' + p.name;
        b.onclick = () => { if (confirm(`Move ${p.name} to the sideline?`)) send({ t: 'kick', seat: p.seat }); };
        ppl.append(b);
      }
    }
  }
  let pplKey = '';
  $('rolebtn').onclick = () => {
    if (seat >= 0 && last && last.phase !== 'lobby' && last.phase !== 'over' && !confirm('Leave your seat? The CPU takes over your side.')) return;
    send({ t: 'role', play: seat < 0 });
  };

  // ---- chat --------------------------------------------------------------------------------------
  let unread = 0;
  const hex = (c) => '#' + Number(c || 0).toString(16).padStart(6, '0');
  function addChat(m, old) {
    const d = document.createElement('div'), b = document.createElement('b');
    b.textContent = m.name; b.style.color = m.sys ? '' : m.seat === 0 ? '#c7322a' : m.seat === 1 ? '#2160cf' : hex(m.color);
    d.append(b, ': ' + m.text); if (m.sys) d.className = 'sys';
    const log = $('clog'), atEnd = log.scrollTop + log.clientHeight >= log.scrollHeight - 30;
    log.append(d); while (log.childElementCount > 60) log.firstElementChild.remove();
    if (atEnd || old) log.scrollTop = log.scrollHeight;
    if (!old && !m.sys && !$('chat').classList.contains('on') && !(m.sid && m.sid === mySid) && !(seat >= 0 && m.seat === seat)) { unread++; showUnread(); }
  }
  function showUnread() { const u = $('unread'); u.textContent = unread > 9 ? '9+' : unread; u.style.display = unread ? 'block' : 'none'; }
  function sendChat(text) { text = String(text || '').trim(); if (!text) return; send({ t: 'chat', text }); $('cin').value = ''; }
  $('chatbtn').onclick = () => { $('chat').classList.add('on'); unread = 0; showUnread(); $('clog').scrollTop = $('clog').scrollHeight; };
  $('cclose').onclick = () => { $('chat').classList.remove('on'); $('cin').blur(); };
  $('csend').onclick = () => sendChat($('cin').value);
  $('cin').addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); sendChat($('cin').value); } });
  $('chips').addEventListener('click', (e) => { if (e.target.tagName === 'BUTTON') sendChat(e.target.textContent); });
  $('myname').value = store.get('name', '');
  $('myname').addEventListener('change', () => { const v = $('myname').value.trim(); if (v) { store.set('name', v); $('name').value = v; send({ t: 'name', name: v }); } });   // and on the linked screen too

  function render(m) {
    updateSeat();
    const me = seat;
    const them = me === 0 ? 1 : 0;
    if (me >= 0) {
      $('v0').textContent = m.score[me]; $('v1').textContent = m.score[them];
      $('nm0').textContent = 'You'; $('nm1').textContent = m.seats[them].name || 'Opponent';
    } else { $('v0').textContent = m.score[0]; $('v1').textContent = m.score[1]; $('nm0').textContent = m.seats[0].name || 'P1'; $('nm1').textContent = m.seats[1].name || 'P2'; }
    const st = $('status'); let txt = m.msg || '';
    const myServe = m.phase === 'serve' && m.server === me;
    if (me < 0) txt = roster && roster.players.some((p) => p.kind !== 'human') ? 'You are watching from the sideline\n(a seat is open - tap Play)' : 'You are watching from the sideline';
    else if (m.phase === 'lobby') txt = 'Waiting for the match to start';
    else if (myServe && m.serveStage === 'hold') txt = 'Your serve!\nFlick the phone to toss the ball';
    else if (myServe && m.serveStage === 'toss') txt = 'Swing to hit it!';
    else if (m.phase === 'serve') txt = 'Opponent is serving';
    else if (m.phase === 'rally') txt = 'Rally! Swing as the ball reaches you';
    else if (m.phase === 'over') txt = m.win === me ? 'You win!' : 'Match over';
    const p = m.pause, live = m.phase !== 'lobby' && m.phase !== 'over';
    if (p) txt = p.resumeIn !== null ? `Resuming in ${Math.ceil(p.resumeIn)}…` : `⏸ ${p.by} paused the game`;
    st.textContent = txt; st.style.whiteSpace = 'pre-line';
    $('startbtn').style.display = (m.phase === 'lobby' || m.phase === 'over') && me >= 0 ? '' : 'none';
    $('toss').style.display = myServe && m.serveStage === 'hold' && !p ? '' : 'none';
    $('pausebtn').style.display = me >= 0 && live && !p ? '' : 'none';
    $('resumebtn').style.display = $('endbtn').style.display = me >= 0 && p && p.resumeIn === null ? '' : 'none';
  }

  let fbTimer = 0;
  // Haptics. Android: navigator.vibrate. iOS Safari has no vibrate, but toggling a native switch control (<input type=checkbox switch>,
  // Safari 17.4+) plays the system haptic: the trick behind the ios-haptics / web-haptics libraries.
  // ponytail: script-triggered only. iOS 26.5+ plays it just for a real finger tap on the switch, so on current iPhones hits are silent;
  // upgrade path if taps ever become a control: lay a transparent switch label over the button so the tap itself buzzes.
  function iosTick() {
    const l = document.createElement('label'), i = document.createElement('input');
    i.type = 'checkbox'; i.setAttribute('switch', ''); l.style.display = 'none'; l.ariaHidden = 'true'; l.append(i);
    document.head.append(l); l.click(); l.remove();
  }
  function buzz(ms, times = 1) {
    try {
      if (navigator.vibrate) { navigator.vibrate(times > 1 ? [ms, 60, ms] : ms); return; }
      for (let k = 0; k < times; k++) setTimeout(iosTick, k * 90);
    } catch { }
  }
  function feedback(m) {
    let t = '';
    if (m.kind === 'hit' || m.kind === 'smash' || m.kind === 'weak') {
      const perfect = Math.abs(m.timing) < 0.25;    // same threshold as K.PERFECT on the server
      t = m.kind === 'smash' ? 'SMASH!' : perfect ? 'PERFECT!' : m.timing < 0 ? 'EARLY' : 'LATE';
      // spin read: the face against the incoming spin (topspin wants it closed, backspin open)
      if (m.fault) t = m.fault === 'net' ? 'NET! Open the face vs backspin' : 'LONG! Close the face vs topspin';
      else if (m.pop) t += ' · POPPED UP (close vs topspin)';
      else if (m.kind === 'hit' && Math.abs(m.spinIn) > 0.35 && Math.abs(m.err) < 0.3) t += ' · READ IT';
      else if (m.kind === 'hit' && m.err > 0.4) t += ' · LIFT'; else if (m.kind === 'hit' && m.err < -0.4) t += ' · DRIVE';
      buzz(m.kind === 'smash' ? 40 : 22, perfect || m.kind === 'smash' ? 2 : 1);   // a tick when the ball meets the paddle, double for PERFECT
    } else if (m.kind === 'miss') t = (m.why === 'whiff' || m.why === 'tired') ? '' : 'Out of reach!';
    else if (m.kind === 'serve') { t = 'Serve!'; buzz(22); }
    else if (m.kind === 'toss') { t = 'Now swing!'; buzz(25); }
    else if (m.kind === 'tossMiss') t = 'Missed the toss - flick up again';
    $('fb').textContent = t; clearTimeout(fbTimer); fbTimer = setTimeout(() => { $('fb').textContent = ''; }, 900);
  }

  // ---- motion --------------------------------------------------------------------------------
  let R = null;                       // device -> earth rotation (from deviceorientation)
  let f0 = null, r0 = null;           // calibrated forward / right (earth horizontal)
  let gravLP = [0, 0, 0];
  let motionOn = false, lastSend = 0;
  let accSign = 1, calibDone = false, gzLP = 0;
  let sens = Number(store.get('sens', '1')) || 1;
  $('sens').value = sens;
  $('sens').addEventListener('input', () => { sens = Number($('sens').value); store.set('sens', String(sens)); });
  // calibration: step 1 = point at the screen (sets "forward"), step 2 = flick up (fixes the sensor sign on this phone)
  let calib = 0, flick = null;
  function showCalib(step) {
    calib = step; flick = null;
    $('calib').classList.add('on');
    if (step === 1) { $('ctitle').textContent = 'Point at the screen'; $('ctext').textContent = 'Hold the phone like a Wii Remote, top edge aimed at the TV, then tap the button.'; $('cart').textContent = '📡'; $('cnext').style.display = ''; }
    else { $('ctitle').textContent = 'Flick UP'; $('ctext').textContent = 'Now flick the phone straight up once, like tossing a serve.'; $('cart').textContent = '⬆️'; $('cnext').style.display = 'none'; }
  }
  function endCalib() { calib = 0; $('calib').classList.remove('on'); }
  $('cnext').onclick = () => { if (!R) { $('ctext').textContent = 'No motion data yet - move the phone a little and try again.'; return; } recenter(); showCalib(2); };
  $('cskip').onclick = endCalib;

  function rotMatrix(a, b, g) {
    const d = Math.PI / 180, ca = Math.cos(a * d), sa = Math.sin(a * d), cb = Math.cos(b * d), sb = Math.sin(b * d), cg = Math.cos(g * d), sg = Math.sin(g * d);
    return [
      [ca * cg - sa * sb * sg, -cb * sa, cg * sa * sb + ca * sg],
      [cg * sa + ca * sb * sg, ca * cb, sa * sg - ca * cg * sb],
      [-cb * sg, sb, cb * cg],
    ];
  }
  function headingNow() {
    if (!R) return null;
    let x = R[0][1], y = R[1][1];            // device top (+y axis) in earth frame
    let n = Math.hypot(x, y);
    if (n < 0.55) { x = -R[0][2]; y = -R[1][2]; n = Math.hypot(x, y); }   // phone upright: use the back of the phone
    return n > 1e-3 ? [x / n, y / n] : null;
  }
  function recenter() {
    const h = headingNow(); if (!h) return;
    f0 = h; r0 = [h[1], -h[0]];
    buzz(20);
  }
  window.addEventListener('deviceorientation', (e) => {
    if (e.alpha == null && e.beta == null) return;
    R = rotMatrix(e.alpha || 0, e.beta || 0, e.gamma || 0);
    if (!f0) recenter();
  });
  window.addEventListener('devicemotion', (e) => {
    if (!motionOn || !R || !f0) return;
    let a = e.acceleration;
    let dev;
    const gi = e.accelerationIncludingGravity;
    if (gi && gi.x != null) {          // at rest the world-up component must read about +9.8; if negative this phone reports inverted axes
      const gz = R[2][0] * gi.x + R[2][1] * gi.y + R[2][2] * gi.z;
      gzLP = gzLP * 0.95 + gz * 0.05;
      if (!calibDone && Math.abs(gzLP) > 6) accSign = gzLP > 0 ? 1 : -1;
    }
    if (a && a.x != null) dev = [a.x, a.y, a.z];
    else if (e.accelerationIncludingGravity && e.accelerationIncludingGravity.x != null) {
      const g = e.accelerationIncludingGravity;
      gravLP = gravLP.map((v, i) => v * 0.9 + [g.x, g.y, g.z][i] * 0.1);
      dev = [g.x - gravLP[0], g.y - gravLP[1], g.z - gravLP[2]];
    } else return;
    dev = [dev[0] * accSign * sens, dev[1] * accSign * sens, dev[2] * accSign * sens];
    const wx = R[0][0] * dev[0] + R[0][1] * dev[1] + R[0][2] * dev[2];
    const wy = R[1][0] * dev[0] + R[1][1] * dev[1] + R[1][2] * dev[2];
    const wz = R[2][0] * dev[0] + R[2][1] * dev[1] + R[2][2] * dev[2];
    const ax = wx * r0[0] + wy * r0[1];
    const ay = wx * f0[0] + wy * f0[1];
    const h = headingNow();
    const yaw = h ? Math.atan2(h[0] * r0[0] + h[1] * r0[1], h[0] * f0[0] + h[1] * f0[1]) * 180 / Math.PI : 0;
    const mag = Math.hypot(ax, ay, wz);
    if (calib === 2) {                    // detect the up-flick and fix the sign from its direction
      const m0 = mag / sens;
      if (!flick && m0 > 12) flick = { sum: 0, t0: performance.now() };
      if (flick) {
        flick.sum += wz / sens;
        if (m0 < 5 || performance.now() - flick.t0 > 300) {
          accSign = (flick.sum >= 0 ? 1 : -1) * accSign; calibDone = true;
          $('ctitle').textContent = 'Got it!'; $('ctext').textContent = accSign === 1 ? 'Calibrated.' : 'Calibrated (axes flipped for this phone).';
          buzz(40);
          flick = null; calib = 3; setTimeout(endCalib, 900);
        }
      }
    }
    $('meter').firstElementChild.style.width = Math.min(100, mag * 2.2) + '%';
    // phone orientation in the calibrated frame (x = right, y = forward, z = up): its top edge and its screen normal
    const cal = (wx_, wy_, wz_) => [+(wx_ * r0[0] + wy_ * r0[1]).toFixed(2), +(wx_ * f0[0] + wy_ * f0[1]).toFixed(2), +wz_.toFixed(2)];
    const yv = cal(R[0][1], R[1][1], R[2][1]), zv = cal(R[0][2], R[1][2], R[2][2]);
    send({ t: 'm', ax: +ax.toFixed(2), ay: +ay.toFixed(2), az: +wz.toFixed(2), yaw: +yaw.toFixed(1), yv, zv, ts: Math.round(performance.now()) });
  });

  async function enableMotion() {
    try {
      if (typeof DeviceMotionEvent !== 'undefined' && typeof DeviceMotionEvent.requestPermission === 'function') {
        const r = await DeviceMotionEvent.requestPermission();
        if (r !== 'granted') throw new Error('denied');
        if (typeof DeviceOrientationEvent !== 'undefined' && DeviceOrientationEvent.requestPermission) await DeviceOrientationEvent.requestPermission();
      }
      motionOn = true;
      return true;
    } catch (e) { return false; }
  }
  async function keepAwake() { try { if (navigator.wakeLock) await navigator.wakeLock.request('screen'); } catch { } }

  async function go(withMotion) {
    store.set('name', $('name').value.trim());
    let ok = true;
    if (withMotion) ok = await enableMotion();
    $('join').classList.remove('on'); $('play').classList.add('on');
    keepAwake();
    if (withMotion && !ok) { motionDenied = true; $('padtext').innerHTML = '<span class="warn">Motion access was not granted (needs HTTPS + permission). Swipe mode is on:<br>left/right = forehand/backhand, up = toss. Spectating: tap to wave.</span>'; }
    connect();
    if (withMotion && ok) showCalib(1);
  }
  $('joinbtn').onclick = () => go(true);
  $('nomotion').onclick = () => go(false);
  $('recenter').onclick = () => showCalib(1);
  $('toss').onclick = () => send({ t: 'toss' });
  $('startbtn').onclick = () => send({ t: 'start' });
  $('pausebtn').onclick = () => send({ t: 'pause' });
  $('resumebtn').onclick = () => send({ t: 'resume' });
  $('endbtn').onclick = () => { if (confirm('End the match and go back to the lobby?')) send({ t: 'end' }); };
  document.addEventListener('visibilitychange', () => { if (!document.hidden) keepAwake(); });

  // ---- swipe fallback ------------------------------------------------------------------------
  let tp = null;
  const pad = $('pad');
  pad.addEventListener('pointerdown', (e) => {
    if (seat < 0) { send({ t: 'wave' }); pad.classList.add('wave'); setTimeout(() => pad.classList.remove('wave'), 400); buzz(15); return; }   // spectators: tap to wave
    tp = { x: e.clientX, y: e.clientY, t: performance.now() };
  });
  pad.addEventListener('pointerup', (e) => {
    if (!tp) return;
    const dx = e.clientX - tp.x, dy = e.clientY - tp.y, dt = Math.max(performance.now() - tp.t, 30);
    const len = Math.hypot(dx, dy); tp = null;
    if (len < 30) return;
    const speed = len / dt; // px/ms
    if (-dy > Math.abs(dx) * 1.2) { send({ t: 'toss' }); return; }
    send({ t: 'swing', power: Math.min(1, 0.25 + speed / 3), side: (dx * hand) <= 0 ? 1 : -1, spin: -dy / len * 0.8, aim: 0 });
  });
})();
