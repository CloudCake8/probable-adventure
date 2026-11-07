// Headless checks: CPU-vs-CPU matches (rules/scoring), shot planner, swing detector.
import { Game, K, newBall, planRally, planServe, stepBall } from './sim.js';
import { SwingDetector } from './swing.js';

let fails = 0;
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) fails++; };

// 1. full CPU-vs-CPU matches
for (const skill of [0.3, 0.6, 0.95]) {
  const g = new Game();
  g.startMatch({ skill });
  for (const s of g.seats) s.skill = skill;
  let steps = 0; const reasons = {}; let longest = 0, rallies = 0, sum = 0;
  while (g.phase !== 'lobby' && steps < 60 * 60 * 30) {
    g.step(1 / 60); steps++;
    for (const e of g.events) if (e.type === 'point') { reasons[e.reason] = (reasons[e.reason] || 0) + 1; longest = Math.max(longest, g.rallyLen); sum += g.rallyLen; rallies++; }
    g.events = [];
    if (g.phase === 'over') break;
  }
  ok(g.phase === 'over' || g.phase === 'lobby', `skill ${skill}: match finished ${g.score.join('-')} in ${(steps / 60).toFixed(0)}s`);
  ok(JSON.stringify(g.snapshot()).length > 100, `skill ${skill}: snapshot builds`);
  const [a, b] = g.score;
  ok((Math.max(a, b) >= 11) && Math.abs(a - b) >= 2, `skill ${skill}: valid final score`);
  console.log('   point reasons', JSON.stringify(reasons), 'avg rally', (sum / Math.max(rallies, 1)).toFixed(1), 'longest', longest);
}

// 2. planner lands where asked
{
  const b = newBall(); b.p = [2, 3.5, 21]; planRally(b, -3, -9, 0.5, 0, 1);
  const c = { p: b.p.slice(), v: b.v.slice(), w: b.w.slice(), qx: 0, qy: 0, qz: 0 };
  let land = null; for (let i = 0; i < 300 && !land; i++) for (const e of stepBall(c, 1 / 120)) if (e.type === 'bounce' && !land) land = e;
  ok(land && Math.hypot(land.x + 3, land.z + 9) < 1.0, `rally planner lands at (${land?.x.toFixed(2)}, ${land?.z.toFixed(2)}) vs (-3,-9)`);
}
{
  const b = newBall(); b.p = [0, 6, 19.5]; planServe(b, 1, 8, 0.5, 0, 1);
  const c = { p: b.p.slice(), v: b.v.slice(), w: b.w.slice(), qx: 0, qy: 0, qz: 0 };
  const L = []; for (let i = 0; i < 400 && L.length < 2; i++) for (const e of stepBall(c, 1 / 120)) if (e.type === 'bounce') L.push(e);
  ok(L.length === 2 && L[0].half === 0 && L[1].half === 1, `serve bounces own then opp half (${L.map((e) => e.half + '@' + e.z.toFixed(1))})`);
}

// 3. swing detector on synthetic data
function swingSamples(dirx, dirz, peak) {
  const out = []; let ts = 0;
  for (let i = 0; i < 20; i++) { out.push({ ax: 0, ay: 0, az: 0, yaw: 0, ts }); ts += 16; }
  for (let i = 0; i < 14; i++) {
    const a = peak * Math.sin((i / 13) * Math.PI);
    out.push({ ax: dirx * a, ay: 0.2 * a, az: dirz * a, yaw: 5, ts }); ts += 16;
  }
  for (let i = 0; i < 20; i++) { out.push({ ax: 0, ay: 0, az: 0, yaw: 0, ts }); ts += 16; }
  return out;
}
function run(samples, mode = 'swing', hand = 1) {
  const d = new SwingDetector(); d.hand = hand; const r = [];
  for (const s of samples) { const x = d.push(s, mode); if (x) r.push(x); }
  return r;
}
let r = run(swingSamples(-1, 0, 36));
ok(r.length === 1 && r[0].kind === 'swing' && r[0].side === 1, 'leftward swing (right-hander) = forehand');
r = run(swingSamples(1, 0, 36));
ok(r.length === 1 && r[0].side === -1, 'rightward swing = backhand');
r = run(swingSamples(1, 0, 36), 'swing', -1);
ok(r.length === 1 && r[0].side === 1, 'left-handed mirrors');
r = run(swingSamples(0, 1, 34), 'toss');
ok(r.length === 1 && r[0].kind === 'toss', 'upward flick = toss');
r = run(swingSamples(-1, 0, 14));
ok(r.length === 0, 'small wiggle ignored');
r = run(swingSamples(-1, 0, 55)); const lo = run(swingSamples(-1, 0, 24));
ok(r[0].power > lo[0].power, `harder swing = more power (${r[0].power.toFixed(2)} > ${lo[0].power.toFixed(2)})`);

// 4. lag compensation: one swing peak gets the same timing whether its packet arrives on time or 60 ms late
function timingFor(delay, comp) {
  const g = new Game(); g.startMatch({ skill: 0.6 }); g.seats[0].kind = 'human';
  g.phase = 'rally'; g.ballStage = 'live'; g.lastHitter = 1;
  g.ball.p = [0, 2, 12]; g.ball.v = [0, 12, 40]; g.ball.w = [0, 0, 0];   // just bounced on seat 0's half, heading for seat 0
  const s = g.seats[0];
  g.step(1 / 60); s.mv.lock = 1e9; s.mv.Px = s.mv.Vx; s.mv.Pz = s.mv.Vz;  // hold the player still: isolates network delay from auto-movement
  while (g.ball.p[2] < Math.abs(s.z) - (s.fwd ?? 2)) g.step(1 / 60);     // the perfect moment: ball reaches the contact plane...
  const peak = g.t;                                                       // ...and the phone's swing peaks right then
  while (g.t < peak + K.LATENCY + delay - 1e-9) g.step(1 / 60);          // its packet arrives the nominal delay (+ extra) later
  g.events = [];
  g.registerSwing(0, { power: 0.6, side: 1, spin: 0, aim: 0, ago: comp ? g.t - peak : undefined });
  for (let i = 0; i < 60; i++) { g.step(1 / 60); const h = g.events.find((e) => e.type === 'hit' && e.seat === 0); if (h) return h.timing; }
  return NaN;
}
{
  const onTime = timingFor(0, true), late = timingFor(0.06, true), rawOn = timingFor(0, false), rawLate = timingFor(0.06, false);
  ok(Math.abs(onTime - late) < 0.05 && Math.abs(rawOn - rawLate) > 0.2,
    `lag compensation: 60 ms late packet times the same (${onTime.toFixed(2)} vs ${late.toFixed(2)}; uncompensated ${rawOn.toFixed(2)} vs ${rawLate.toFixed(2)})`);
}

// 5. spin read: heavy backspin met with a closed face dips into the net; the open face it asks for puts it on the table
function spinReturn(face) {
  const g = new Game(); g.startMatch({ skill: 0.6 }); g.seats[0].kind = 'human'; g.step(1 / 60);
  g.phase = 'rally'; g.ballStage = 'live'; g.lastHitter = 1;
  g.ball.p = [0, 3, 20]; g.ball.v = [0, -2, 30]; g.ball.w = [-48, 0, 0];            // travelling +z toward seat 0 with backspin -1.2
  g.completeReturn(0, { power: 0.6, side: 1, spin: 0, aim: 0 }, { q: 0, aimLx: 0, spin: 0, open: face, power: 0.6, reachX: 0, reachF: 3 });
  for (let i = 0; i < 120; i++) { g.step(1 / 60); if (g.ballStage === 'live') return 'in'; if (g.phase !== 'rally') return g.lastPoint.reason; }
  return 'nothing';
}
{
  const closed = spinReturn(-0.6), open = spinReturn(-K.SPIN_READ * -1.2);
  ok(closed === 'net' && open === 'in', `spin read: closed face vs backspin -> ${closed}, the open face it asks for -> ${open}`);
}

// 6. music composer: 26 minutes of score through a stub AudioContext (a NaN, Infinity or bad ramp reaching Web Audio throws here)
{
  const { createMusic } = await import('../public/music.js');
  const fin = (...a) => { for (const x of a) if (x !== undefined && !Number.isFinite(x)) throw new Error('non-finite audio value ' + x); };
  const param = () => ({ set value(v) { fin(v); }, setValueAtTime: fin, linearRampToValueAtTime: fin, setTargetAtTime: fin,
    exponentialRampToValueAtTime: (v, t) => { fin(v, t); if (!(v > 0)) throw new Error('exponential ramp to ' + v); } });
  const node = () => new Proxy({}, { get: (o, k) => (k in o ? o[k] : k === 'connect' ? (x) => x : k === 'start' || k === 'stop' ? fin : k === 'setPeriodicWave' ? () => {} : (o[k] = param())) });
  const ctx = new Proxy({ sampleRate: 48000, currentTime: 0, state: 'suspended', destination: node(), createBuffer: (c, n) => ({ getChannelData: () => new Float32Array(n) }) }, { get: (o, k) => (k in o ? o[k] : () => node()) });
  const trace = [], m = createMusic(ctx, trace);
  let T = 0; for (const s of ['dawn', 'glide', 'liquid', 'groove', 'math', 'lift', 'mantra']) { m.jump(s); m.renderAhead(T += 60); }
  m.renderAhead(T + 1200);
  const L = m.log, hz = (s) => 73.42 * 2 ** (s / 31), R = {};
  for (const [v, , st, ...a] of trace) if (v !== 'hit') { const n = v === 'harp' && a[2] ? 'eharp' : v; for (const s of [].concat(st)) R[n] = [Math.min(R[n]?.[0] ?? 1e9, hz(s)), Math.max(R[n]?.[1] ?? 0, hz(s))]; }
  const rep = L.filter((x) => x.includes('REPRISE')), cross = rep.filter((x) => { const g = x.match(/lead (\w+) .*born on (\w+)/); return g && g[1] !== g[2]; });
  const orn = L.filter((x) => x.includes('ornaments')), ornKinds = new Set(orn.map((x) => x.trim())).size, forms = new Set(L.map((x) => x.match(/form (\w+)/)?.[1]).filter(Boolean));
  ok(new Set(L.filter((x) => x.startsWith('section')).map((x) => x.split(' ')[1])).size === 7 && forms.size >= 4, `music: all 7 section styles and ${forms.size} phrase forms played`);
  ok(rep.length > 3 && cross.length > 0, `music: ${rep.length} motif reprises, ${cross.length} of them on another instrument than the one the motif was born on`);
  ok(ornKinds > orn.length * 0.6, `music: ornament patterns vary (${ornKinds} distinct of ${orn.length})`);
  ok(Object.entries(R).every(([n, [lo, hi]]) => hi < 2400 && lo > (n === 'bass' ? 40 : 90)), 'music: voices in range: ' + Object.entries(R).map(([n, [lo, hi]]) => `${n} ${lo | 0}-${hi | 0} Hz`).join(', '));
  const MODES = { M: [0, 5, 10, 13, 18, 23, 28], m: [0, 5, 8, 13, 18, 21, 26], d: [0, 5, 8, 13, 18, 23, 26], r: [0, 5, 9, 13, 18, 23, 27], b: [0, 4, 8, 13, 18, 21, 26] };
  const keys = L.filter((x) => x.includes(' phrase ')).map((x) => { const km = x.match(/key (-?\d+) (\w)/); return [+x.match(/@([\d.]+)s/)[1], +km[1], new Set(MODES[km[2]])]; });
  let inKey = 0, leadN = 0;
  for (const [v, t, st] of trace) { const kk = v === 'lead' && keys.findLast(([t0]) => t0 <= t + 0.03); if (!kk) continue; leadN++; if (kk[2].has((((st - kk[1]) % 31) + 31) % 31)) inKey++; }
  ok(inKey / leadN > 0.88, `music: ${(100 * inKey / leadN).toFixed(0)}% of ${leadN} lead-synth notes are in the phrase's mode`);
  // melodies move mostly by step; tempos differ between sections; how hard notes are played varies
  const ld = trace.filter((e) => e[0] === 'lead').sort((a, b) => a[1] - b[1]); let steps = 0, pairs = 0;
  for (let i = 1; i < ld.length; i++) if (ld[i][1] - ld[i - 1][1] < 1.5) { pairs++; if (Math.abs(ld[i][2] - ld[i - 1][2]) <= 5) steps++; }
  ok(steps / pairs > 0.5, `music: ${(100 * steps / pairs).toFixed(0)}% of lead-synth moves are steps (a whole tone or less)`);
  const bpms = L.map((x) => +(x.match(/^section .* bpm (\d+)/)?.[1] ?? NaN)).filter((x) => x > 0);
  ok(new Set(bpms).size >= 4 && Math.max(...bpms) - Math.min(...bpms) >= 20, `music: section tempos vary (${Math.min(...bpms)}-${Math.max(...bpms)} BPM, ${new Set(bpms).size} different)`);
  const VI = { lead: 4, piano: 3, rhodes: 3, bass: 3, harp: 3 }, vels = {};
  for (const e of trace) if (e[0] in VI) (vels[e[0]] ||= []).push(e[VI[e[0]]]);
  const vs = Object.entries(vels).filter(([, a]) => a.length >= 30).map(([n, a]) => { a.sort((x, y) => x - y); const q = (f) => a[(a.length * f) | 0]; return [n, (q(0.9) - q(0.1)) / q(0.5)]; });
  ok(vs.every(([, r]) => r >= 0.35), 'music: dynamics vary within each instrument (p90-p10 over median): ' + vs.map(([n, r]) => `${n} ${r.toFixed(2)}`).join(', '));
  // the band keeps its part but plays it a little differently bar to bar; note lengths range from clipped to held
  const phs = []; let sty = '', sbpm = 86;
  for (const x of L) { const sm = x.match(/^section (\w+).* bpm (\d+)/); if (sm) { sty = sm[1]; sbpm = +sm[2]; } const pm = x.match(/phrase \d+ @([\d.]+)s/); if (pm) phs.push([+pm[1], sty, sbpm]); }
  let grooveN = 0, varied = 0, kept = 0;
  phs.forEach(([t0, sty2, bpm], i) => {
    const S16 = 60 / bpm / 4;
    if (sty2 !== 'groove') return;
    const t1 = phs[i + 1]?.[0] ?? Infinity, full = Array.from({ length: 7 }, () => new Set()), skel = Array.from({ length: 7 }, () => new Set());
    for (const e of trace) if (e[0] === 'hit' && e[1] >= t0 - 0.03 && e[1] < t1 - 0.03) { const q = Math.round((e[1] - t0) / S16), b = q >> 4; if (b >= 0 && b < 7) { full[b].add(e[2] + (q & 15)); if ((e[2] === 'k' || e[2] === 's') && e[3] >= 0.3) skel[b].add(e[2] + (q & 15)); } }
    if (skel.some((x) => !x.size)) return;    // a breakdown, or a phrase cut short by the forced section changes above
    grooveN++;
    if (new Set(full.map((x) => [...x].sort().join())).size > 1) varied++;
    let sum = 0, n = 0; for (let a = 0; a < 7; a++) for (let b = a + 1; b < 7; b++) { const A = skel[a], B = skel[b], both = [...A].filter((x) => B.has(x)).length; sum += both / (A.size + B.size - both || 1); n++; }
    if (sum / n > 0.6) kept++;
  });
  ok(grooveN > 0 && varied === grooveN && kept === grooveN, `music: groove drums vary bar to bar (${varied}/${grooveN} phrases) yet keep their kick/snare skeleton (${kept}/${grooveN})`);
  const DI = { lead: 3, piano: 4, rhodes: 4, bass: 4, harp: 7 }, lens = {};
  for (const e of trace) if (e[0] in DI) { const n = e[0] === 'harp' && e[5] ? 'eharp' : e[0], d = e[DI[e[0]]]; (lens[n] ||= []).push(d == null ? 3 : d); }
  const spread = Object.entries(lens).filter(([, a]) => a.length >= 30).map(([n, a]) => { a.sort((x, y) => x - y); return [n, a[(a.length * 0.9) | 0] / a[(a.length * 0.1) | 0]]; });
  ok(spread.length >= 4 && spread.every(([, r]) => r >= 3), 'music: note lengths range from clipped to held: ' + spread.map(([n, r]) => `${n} x${r.toFixed(1)}`).join(', '));
}

// 7. the room: seats, switching between playing and watching, sideline chairs, chat, spectators' hands
{
  const { Room } = await import('./room.js');
  const g = new Game(), sock = (n) => ({ n, readyState: 1, got: [] });
  const r = new Room(g, (to, msg) => { for (const w of typeof to === 'object' ? [to] : [...r.pads.keys(), ...r.hosts]) w.got.push(msg); });
  const [a, b, c, h] = ['a', 'b', 'c', 'h'].map(sock);
  r.hello(h, { role: 'host' });
  const pa = r.hello(a, { pid: 'A', name: 'Ann' }), pb = r.hello(b, { pid: 'B', name: 'Bo' }), pc = r.hello(c, { pid: 'C', name: 'Cy' });
  ok(pa.seat === 0 && pb.seat === 1 && pc.seat === -1 && pc.chair === 0, 'room: two phones take the seats, a third sits on the sideline');
  r.setRole(pc, true); const denied = pc.seat === -1 && c.got.some((x) => x.t === 'note');
  r.setRole(pa, false); r.setRole(pc, true);
  ok(denied && pc.seat === 0 && pa.seat === -1 && pa.chair >= 0 && g.seats[0].name === 'Cy', 'room: a spectator switches in once a player steps out to watch');
  g.startMatch({ skill: 0.5 }); r.setRole(pb, false);
  ok(g.seats[1].kind === 'cpu' && r.seatOwner[1] === null && pb.chair >= 0, 'room: stepping out mid-match hands the seat to the CPU');
  r.setRole(pa, true);
  ok(pa.seat === 1 && g.seats[1].kind === 'human' && g.seats[1].name === 'Ann', 'room: a spectator can take over from the CPU mid-match');
  for (let i = 0; i < 7; i++) r.chat(b, `hi\u0007 ${'x'.repeat(200)}`);
  const chats = h.got.filter((x) => x.t === 'chat' && !x.sys);
  ok(chats.length === 5 && chats[0].text.length === 140 && !/\u0007/.test(chats[0].text) && chats[0].sid === pb.sid && chats[0].seat === -1, 'room: chat is cleaned, capped, rate-limited and tagged with its speaker');
  r.motion(pb, { yv: [0.1, 0.2, 0.97], ax: 9, az: 0 }); r.wave(pb); h.got.length = 0; r.arms();
  const arm = h.got.find((x) => x.t === 'arms')?.a.find((x) => x[0] === pb.sid);
  ok(arm && arm[3] === 0.97 && arm[4] === 1, 'room: a spectator phone raises and waves their hand on the screens');
  const late = sock('late'); r.hello(late, { role: 'host' });
  const ro = late.got.find((x) => x.t === 'roster');
  ok(late.got.some((x) => x.t === 'chatlog' && x.list.length > 0) && ro?.specs.length === 1 && ro.screens === 2 && !JSON.stringify(ro).includes('"pid"'), 'room: a new screen gets the chat history and a roster without phone ids');
  // a phone that scanned a screen's QR is linked to it: one name for both, renamed from either side; the screen can chat as its phone
  const g2 = new Game(), r2 = new Room(g2, (to, msg) => { for (const w of typeof to === 'object' ? [to] : [...r2.pads.keys(), ...r2.hosts]) w.got.push(msg); });
  const scr = sock('scr'), ph = sock('ph'), other = sock('other');
  r2.hello(scr, { role: 'host', screen: 'k7qx' }); r2.hello(other, { role: 'host', screen: 'ZZZZ' });
  const pp = r2.hello(ph, { pid: 'P', name: 'Pat', screen: 'K7QX' }); r2.syncRoster();
  const paired = scr.got.find((x) => x.t === 'paired'), elsewhere = other.got.find((x) => x.t === 'paired');
  r2.renameFrom(other, pp.sid, 'Hacker'); r2.renameFrom(scr, pp.sid, 'Patty');
  ok(paired?.phones[0]?.name === 'Pat' && !elsewhere?.phones.length && ph.got.some((x) => x.t === 'link' && x.on) && pp.name === 'Patty' && g2.seats[0].name === 'Patty' && ph.got.some((x) => x.t === 'name' && x.name === 'Patty'),
    'room: a phone joined from a screen QR links to that screen only, and a rename there reaches the phone and its seat');
  r2.chat(scr, 'hi', 'Host', pp.sid); r2.chat(other, 'yo', 'Host', pp.sid); const said = scr.got.filter((x) => x.t === 'chat' && !x.sys);
  ok(said[0]?.name === 'Patty' && said[0].seat === 0 && said[1]?.name === 'Host', 'room: a linked screen chats as its phone (name, colour, bubble); another screen cannot');
  // pause and end are for the players (their phones and linked screens); kick is for anyone; a phone arriving mid-match sits down
  const g3 = new Game(), r3 = new Room(g3, (to, msg) => { for (const w of typeof to === 'object' ? [to] : [...r3.pads.keys(), ...r3.hosts]) w.got.push(msg); });
  const mine = sock('mine'), theirs = sock('theirs'), qp = sock('qp'), np = sock('np'), wp = sock('wp');
  r3.hello(mine, { role: 'host', screen: 'MINE' }); r3.hello(theirs, { role: 'host', screen: 'WTCH' });
  const q = r3.hello(qp, { pid: 'Q', name: 'Quin', screen: 'MINE' }); g3.startMatch({ skill: 0.5 });
  const nw = r3.hello(np, { pid: 'N', name: 'Nia', screen: 'WTCH' });
  ok(nw.seat === -1 && nw.chair >= 0 && g3.seats[1].kind === 'cpu', 'room: a phone arriving mid-match sits on the sideline instead of taking the CPU seat');
  r3.pause(theirs, 'Watcher'); r3.pause(np);
  const refused = !r3.paused && theirs.got.some((x) => x.t === 'note') && np.got.some((x) => x.t === 'note');
  r3.pause(mine, 'Screen'); const by = r3.paused?.by;
  r3.resume(theirs); const stillPaused = r3.paused && !r3.paused.until;
  r3.resume(qp); const t0 = Date.now();
  ok(refused && by === 'Quin' && stillPaused && r3.tickPause(t0 + 1000) && !r3.tickPause(t0 + 3100) && !r3.paused,
    'room: only the players pause (a spectator screen or phone is refused); resuming counts down 3 s');
  ok(!r3.end(theirs, 'Watcher') && r3.end(mine, 'Screen') && r3.log.some((x) => x.sys && x.text.includes('Quin ended the game')), 'room: only the players can end the game');
  r3.syncRoster(); const ctlMine = mine.got.find((x) => x.t === 'ctl'), ctlTheirs = theirs.got.find((x) => x.t === 'ctl');
  ok(ctlMine?.can === true && ctlTheirs?.can === false, 'room: each screen is told whether it may pause');
  r3.kick(np, 0); const kicked = q.seat === -1 && q.chair >= 0 && g3.seats[0].kind === 'cpu' && r3.seatOwner[0] === null && qp.got.some((x) => x.t === 'seat' && x.seat === -1);
  r3.setRole(nw, true); r3.kick(np, 0);
  const w = r3.hello(wp, { pid: 'W', name: 'Wes' }); r3.setRole(w, true); const wSeat = w.seat;
  r3.kick(theirs, 1, 'Watcher'); r3.kick(theirs, 0, 'Watcher');   // the second comes too soon
  ok(kicked && nw.seat === 0 && wSeat === 1 && w.seat === -1 && theirs.got.some((x) => x.t === 'note' && /Wait/.test(x.text)) && r3.log.some((x) => x.sys && x.text.includes('Quin was moved to the sideline by Nia')),
    'room: anyone can move a player to the sideline (the CPU takes over); not themselves; once every 10 s');
}

console.log(fails ? `\n${fails} FAILED` : '\nall passed');
process.exit(fails ? 1 : 0);
