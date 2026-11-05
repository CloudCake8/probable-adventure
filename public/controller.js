(() => {
  const $ = (id) => document.getElementById(id);
  const store = {
    get(k, d) { try { return localStorage.getItem(k) ?? d; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch { } },
  };
  const pid = store.get('pid', null) || (store.set('pid', Math.random().toString(36).slice(2) + Date.now().toString(36)), store.get('pid'));
  let hand = Number(store.get('hand', '1')) === -1 ? -1 : 1;
  $('name').value = store.get('name', '');

  let ws = null, seat = -1, open = false;
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
    ws.onopen = () => { open = true; send({ t: 'hello', role: 'pad', pid, name: $('name').value.trim(), hand }); setPill('connected', 'ok'); setFlip(aimFlip); };
    ws.onclose = () => { open = false; setPill('reconnecting...', 'bad'); setTimeout(connect, 1000); };
    ws.onmessage = (e) => onMsg(JSON.parse(e.data));
  }
  function setPill(t, c) { const p = $('pill'); p.textContent = t; p.className = c || ''; }

  let last = null;
  function onMsg(m) {
    if (m.t === 'seat') { seat = m.seat; updateSeat(); }
    else if (m.t === 'st') { last = m; if (m.seat !== seat) { seat = m.seat; } render(m); }
    else if (m.t === 'fb') feedback(m);
    else if (m.t === 'swung') { $('meter').firstElementChild.style.width = Math.round(m.power * 100) + '%'; $('pad').classList.add('flash'); setTimeout(() => $('pad').classList.remove('flash'), 140); }
  }
  function updateSeat() { $('seatlabel').textContent = seat >= 0 ? 'Player ' + (seat + 1) : 'Spectating'; }

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
    if (me < 0) txt = 'Both seats are taken - you are watching';
    else if (m.phase === 'lobby') txt = 'Waiting for the match to start';
    else if (myServe && m.serveStage === 'hold') txt = 'Your serve!\nFlick the phone to toss the ball';
    else if (myServe && m.serveStage === 'toss') txt = 'Swing to hit it!';
    else if (m.phase === 'serve') txt = 'Opponent is serving';
    else if (m.phase === 'rally') txt = 'Rally! Swing as the ball reaches you';
    else if (m.phase === 'over') txt = m.win === me ? 'You win!' : 'Match over';
    st.textContent = txt; st.style.whiteSpace = 'pre-line';
    $('startbtn').style.display = (m.phase === 'lobby' || m.phase === 'over') && me >= 0 ? '' : 'none';
    $('toss').style.display = myServe && m.serveStage === 'hold' ? '' : 'none';
  }

  let fbTimer = 0;
  function buzz(ms) { try { if (navigator.vibrate) navigator.vibrate(ms); } catch { } }
  function feedback(m) {
    let t = '';
    if (m.kind === 'hit' || m.kind === 'smash' || m.kind === 'weak') {
      t = m.kind === 'smash' ? 'SMASH!' : Math.abs(m.timing) < 0.25 ? 'PERFECT!' : m.timing < 0 ? 'EARLY' : 'LATE';
      buzz(m.kind === 'smash' ? 40 : 22);   // a short tick when the ball meets the paddle
    } else if (m.kind === 'miss') t = (m.why === 'whiff' || m.why === 'tired') ? '' : 'Out of reach!';
    else if (m.kind === 'serve') { t = 'Serve!'; buzz(22); }
    else if (m.kind === 'toss') { t = 'Now swing!'; if (navigator.vibrate) navigator.vibrate(25); }
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
    if (navigator.vibrate) navigator.vibrate(20);
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
          if (navigator.vibrate) navigator.vibrate(40);
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
    if (withMotion && !ok) { $('pad').innerHTML = '<span class="warn">Motion access was not granted (needs HTTPS + permission). Swipe mode is on:<br>left/right = forehand/backhand, up = toss.</span>'; }
    connect();
    if (withMotion && ok) showCalib(1);
  }
  $('joinbtn').onclick = () => go(true);
  $('nomotion').onclick = () => go(false);
  $('recenter').onclick = () => showCalib(1);
  $('toss').onclick = () => send({ t: 'toss' });
  $('startbtn').onclick = () => send({ t: 'start' });
  document.addEventListener('visibilitychange', () => { if (!document.hidden) keepAwake(); });

  // ---- swipe fallback ------------------------------------------------------------------------
  let tp = null;
  const pad = $('pad');
  pad.addEventListener('pointerdown', (e) => { tp = { x: e.clientX, y: e.clientY, t: performance.now() }; });
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
