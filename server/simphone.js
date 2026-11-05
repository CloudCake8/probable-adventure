// Simulated phone for end-to-end tests: joins as a pad, streams synthetic motion samples through the
// real WebSocket + swing detector path and plays a few points against the CPU.
// usage: node server/simphone.js [port] [seconds]
import { WebSocket } from 'ws';

const port = process.argv[2] || 47831;
const secs = Number(process.argv[3] || 60);
const url = `ws://127.0.0.1:${port}/ws`;
const host = new WebSocket(url), pad = new WebSocket(url);
let snap = null, seat = -1, st = null;
const log = (...a) => console.log(...a);
const fb = {};

host.on('open', () => host.send(JSON.stringify({ t: 'hello', role: 'host' })));
host.on('message', (d) => { const m = JSON.parse(d); if (m.t === 's') { snap = m; for (const e of m.ev) if (['point','swing','hit','toss','tossMiss'].includes(e.type)) log(m.time.toFixed(2), e.type, e.reason || '', e.score || '', e.seat ?? ''); } });
pad.on('open', () => pad.send(JSON.stringify({ t: 'hello', role: 'pad', pid: 'simphone', name: 'SimPhone', hand: 1 })));
pad.on('message', (d) => {
  const m = JSON.parse(d);
  if (m.t === 'seat') { seat = m.seat; log('seat', seat); }
  else if (m.t === 'st') st = m;
  else if (m.t === 'fb') { fb[m.kind] = (fb[m.kind] || 0) + 1; if (m.kind === 'hit') log('hit timing', m.timing.toFixed(2)); }
});

let ts = 0, busyUntil = 0;
function burst(dirx, dirz, peak, delayMs = 0) {
  busyUntil = Date.now() + delayMs + 16 * 16 + 20;
  // schedule samples at 60 Hz in real time; peak occurs ~110 ms after start
  for (let i = 0; i < 16; i++) {
    setTimeout(() => {
      const a = peak * Math.sin((i / 15) * Math.PI);
      ts += 16;
      pad.send(JSON.stringify({ t: 'm', ax: dirx * a, ay: 0.15 * a, az: dirz * a, yaw: 0, ts }));
    }, delayMs + i * 16);
  }
}
setInterval(() => { if (Date.now() < busyUntil) return; ts += 16; if (pad.readyState === 1) pad.send(JSON.stringify({ t: 'm', ax: 0, ay: 0, az: 0, yaw: 0, ts })); }, 16);

let lastAct = 0, swung = false;
setInterval(() => {
  if (!snap || seat < 0) return;
  const now = Date.now();
  if (snap.phase === 'lobby') { if (st && now - lastAct > 800) { pad.send(JSON.stringify({ t: 'start' })); lastAct = now; } return; }
  const sg = seat === 0 ? 1 : -1;
  if (snap.phase === 'serve' && snap.server === seat) {
    if (snap.serveStage === 'hold' && now - lastAct > 1200) { burst(0, 1, 36); lastAct = now; swung = false; }   // flick up = toss
    else if (snap.serveStage === 'toss' && !swung && snap.ball.v[1] < -12) { burst(-1, 0.2, 34 + Math.random() * 12, 0); swung = true; }
  } else if (snap.phase === 'rally') {
    const b = snap.ball;
    if (snap.seats && b.v[2] * sg > 0 && b.p[2] * sg > 13 && b.p[2] * sg < 21 && now - lastAct > 500) {
      // ball approaching: start burst so that its peak lands near the plane
      const tToPlane = (21 - b.p[2] * sg) / Math.abs(b.v[2]) * 1000;
      if (tToPlane < 130 && tToPlane > 20) { burst(Math.random() < 0.5 ? -1 : 1, 0.1, 30 + Math.random() * 16, Math.max(0, tToPlane - 112)); lastAct = now; }
    }
  }
}, 8);

setInterval(() => { if (snap) log('  state', snap.phase, snap.server, snap.serveStage, JSON.stringify(snap.seats.map(s=>s.kind)), 'ball', snap.ball.p.map(v=>v.toFixed(1)).join(',')); }, 3000);
setTimeout(() => {
  log('final', snap && snap.score, 'rally', snap && snap.rally, 'feedback', JSON.stringify(fb));
  process.exit(0);
}, secs * 1000);
