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

console.log(fails ? `\n${fails} FAILED` : '\nall passed');
process.exit(fails ? 1 : 0);
