// ResortCompiled table tennis server: static files + WebSocket rooms + game loop + Cloudflare tunnel.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';
import { spawn } from 'node:child_process';
import { WebSocketServer } from 'ws';
import QRCode from 'qrcode';
import { Game } from './sim.js';
import { SwingDetector } from './swing.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const PUBLIC = path.join(ROOT, 'public');
const PORT = Number(process.env.PORT || 47831);
const TUNNEL = process.env.NO_TUNNEL !== '1';

const MIME = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8', '.json': 'application/json', '.glb': 'model/gltf-binary',
  '.png': 'image/png', '.webp': 'image/webp', '.jpg': 'image/jpeg', '.svg': 'image/svg+xml', '.ico': 'image/x-icon', '.webmanifest': 'application/manifest+json',
};

let publicUrl = process.env.PUBLIC_URL || null;
const game = new Game();

// ---- HTTP ------------------------------------------------------------------------------------
function serveFile(res, file) {
  fs.readFile(file, (err, buf) => {
    if (err) { res.writeHead(404); res.end('not found'); return; }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-cache' });
    res.end(buf);
  });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://x');
  let p = decodeURIComponent(url.pathname);
  if (p === '/api/info') {
    const base = publicUrl || `http://localhost:${PORT}`;
    const joinUrl = `${base}/pad`;
    const qr = await QRCode.toDataURL(joinUrl, { margin: 1, width: 280, color: { dark: '#10243a', light: '#ffffff' } });
    res.writeHead(200, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' });
    res.end(JSON.stringify({ publicUrl, joinUrl, qr, https: !!publicUrl }));
    return;
  }
  if (p === '/pad') p = '/controller.html';
  if (p === '/') p = '/index.html';
  if (p.startsWith('/vendor/three/')) {
    const f = path.join(ROOT, 'node_modules', 'three', p.slice('/vendor/three/'.length));
    if (!f.startsWith(path.join(ROOT, 'node_modules', 'three'))) { res.writeHead(403); res.end(); return; }
    return serveFile(res, f);
  }
  const f = path.join(PUBLIC, p);
  if (!f.startsWith(PUBLIC)) { res.writeHead(403); res.end(); return; }
  serveFile(res, f);
});

// ---- WebSocket --------------------------------------------------------------------------------
const wss = new WebSocketServer({ server, path: '/ws' });
const hosts = new Set();
const pads = new Map();      // ws -> {pid, seat, det, name}
const seatOwner = [null, null];   // pid per seat

function send(ws, obj) { if (ws.readyState === 1) ws.send(JSON.stringify(obj)); }
function seatInfo(i) { const s = game.seats[i]; return { kind: s.kind, name: s.name, online: s.online, hand: s.hand }; }

function assignSeat(pad) {
  for (let i = 0; i < 2; i++) if (seatOwner[i] === pad.pid) return i;
  // prefer an empty seat, then take over a CPU
  for (let i = 0; i < 2; i++) if (game.seats[i].kind === 'empty') return claim(pad, i);
  for (let i = 0; i < 2; i++) if (game.seats[i].kind === 'cpu') return claim(pad, i);
  return -1;
}
function claim(pad, i) {
  seatOwner[i] = pad.pid;
  const s = game.seats[i];
  s.kind = 'human'; s.name = pad.name || `Player ${i + 1}`; s.online = true; s.hand = pad.det.hand;
  return i;
}
function releaseSeat(pad) {
  const i = seatOwner.indexOf(pad.pid);
  if (i < 0) return;
  const s = game.seats[i];
  s.online = false;
  if (game.phase === 'lobby') { s.kind = 'empty'; s.name = ''; seatOwner[i] = null; }
  else { s.kind = 'cpu'; s.name = s.name + ' (CPU)'; s.skill = 0.5; } // AI covers a dropped phone; same pid can reclaim
}

wss.on('connection', (ws) => {
  ws.on('message', (data) => {
    let m; try { m = JSON.parse(data); } catch { return; }
    if (m.t === 'hello') {
      if (m.role === 'host') { hosts.add(ws); ws.isHost = true; send(ws, { t: 'welcome' }); return; }
      const pad = { pid: String(m.pid || Math.random()).slice(0, 40), name: String(m.name || '').slice(0, 14), seat: -1, det: new SwingDetector(), ws };
      pad.det.hand = m.hand === -1 ? -1 : 1;
      pads.set(ws, pad);
      // if this pid already owns a seat (reconnect), reclaim it
      const owned = seatOwner.indexOf(pad.pid);
      if (owned >= 0) {
        const s = game.seats[owned];
        if (s.kind === 'cpu' || s.kind === 'human') { s.kind = 'human'; s.online = true; s.name = pad.name || s.name.replace(' (CPU)', ''); s.hand = pad.det.hand; }
        pad.seat = owned;
      } else pad.seat = assignSeat(pad);
      send(ws, { t: 'seat', seat: pad.seat });
      return;
    }
    if (ws.isHost) {
      if (m.t === 'start') startFrom(m);
      else if (m.t === 'kbdjoin') {
        for (let i = 0; i < 2; i++) if (game.seats[i].kind === 'empty') { game.seats[i].kind = 'human'; game.seats[i].name = 'Keyboard'; game.seats[i].online = true; ws.kbdSeat = i; seatOwner[i] = 'kbd'; break; }
      } else if (m.t === 'kbdleave' && ws.kbdSeat !== undefined) {
        const i = ws.kbdSeat; game.seats[i].online = false; if (game.phase === 'lobby') { game.seats[i].kind = 'empty'; game.seats[i].name = ''; } else { game.seats[i].kind = 'cpu'; }
        seatOwner[i] = null; ws.kbdSeat = undefined;
      } else if (m.t === 'kswing' && ws.kbdSeat !== undefined) game.registerSwing(ws.kbdSeat, m);
      else if (m.t === 'ktoss' && ws.kbdSeat !== undefined) game.toss(ws.kbdSeat);
      else if (m.t === 'reset') resetToLobby();
      return;
    }
    const pad = pads.get(ws);
    if (!pad) return;
    if (m.t === 'm') {
      if (pad.seat < 0) return;
      pad.lastM = Date.now();
      if (Array.isArray(m.yv) && Array.isArray(m.zv)) { const s = game.seats[pad.seat]; s.tilt = { y: m.yv, z: m.zv }; s.tiltT = game.t; }
      const mode = (game.phase === 'serve' && game.server === pad.seat && game.serveStage === 'hold') ? 'toss' : 'swing';
      const r = pad.det.push(m, mode);
      if (r) handleAction(pad, r);
    } else if (m.t === 'swing') {
      if (pad.seat >= 0) game.registerSwing(pad.seat, m);
    } else if (m.t === 'toss') {
      if (pad.seat >= 0) game.toss(pad.seat);
    } else if (m.t === 'aimflip') {
      pad.aimFlip = !!m.v; if (pad.seat >= 0) game.seats[pad.seat].aimFlip = pad.aimFlip;
    } else if (m.t === 'hand') {
      pad.det.hand = m.hand === -1 ? -1 : 1;
      if (pad.seat >= 0) game.seats[pad.seat].hand = pad.det.hand;
    } else if (m.t === 'start') {
      if (pad.seat >= 0) startFrom(m);
    } else if (m.t === 'ping') send(ws, { t: 'pong', c: m.c });
  });
  ws.on('close', () => {
    hosts.delete(ws);
    if (ws.kbdSeat !== undefined) { const s = game.seats[ws.kbdSeat]; s.online = false; if (game.phase === 'lobby') { s.kind = 'empty'; s.name = ''; } else s.kind = 'cpu'; seatOwner[ws.kbdSeat] = null; }
    const pad = pads.get(ws);
    if (pad) { pads.delete(ws); releaseSeat(pad); }
  });
});

function handleAction(pad, r) {
  if (r.kind === 'toss') game.toss(pad.seat);
  else if (r.kind === 'swing') {
    // a swing also works as a toss request if the ball is still in hand and it was a big upward flick: handled in detector
    game.registerSwing(pad.seat, r);
    send(pad.ws, { t: 'swung', power: r.power, side: r.side, spin: r.spin, aim: r.aim });
  }
}

function startFrom(m) {
  if (game.phase !== 'lobby' && game.phase !== 'over') return;
  game.startMatch({ skill: Number(m.skill ?? 0.6), pointsToWin: Number(m.toWin) === 7 ? 7 : 11 });
}
function resetToLobby() {
  game.phase = 'lobby'; game.message = 'Waiting for players'; game.score = [0, 0]; game.winner = -1;
  for (let i = 0; i < 2; i++) { const s = game.seats[i]; if (s.kind === 'cpu') { s.kind = 'empty'; s.name = ''; } }
  game.parkBall();
}

// ---- game loop --------------------------------------------------------------------------------
const DT = 1 / 60;
let acc = 0, last = process.hrtime.bigint();
let padTick = 0;
setInterval(() => {
  const now = process.hrtime.bigint();
  acc += Number(now - last) / 1e9; last = now;
  if (acc > 0.25) acc = 0.25;
  while (acc >= DT) {
    game.step(DT); acc -= DT;
    const snap = game.snapshot();
    const evPads = snap.ev.filter((e) => e.type === 'feedback');
    if (hosts.size) {
      const str = JSON.stringify({ ...snap, t: 's' });
      for (const h of hosts) if (h.readyState === 1) h.send(str);
    }
    for (const e of evPads) for (const [ws, pad] of pads) if (pad.seat === e.seat) send(ws, { ...e, t: 'fb' });
    if (++padTick % 6 === 0) {
      const st = { t: 'st', phase: snap.phase, msg: snap.msg, score: snap.score, server: snap.server, serveStage: snap.serveStage, seats: game.seats.map((s) => ({ kind: s.kind, name: s.name, online: s.online })), win: snap.win };
      for (const [ws, pad] of pads) send(ws, { ...st, seat: pad.seat });
    }
  }
}, 8);

// ---- Cloudflare quick tunnel -------------------------------------------------------------------
let tunnelProc = null;
function startTunnel() {
  const exe = process.env.CLOUDFLARED || 'cloudflared';
  console.log('[tunnel] starting Cloudflare quick tunnel ...');
  try {
    tunnelProc = spawn(exe, ['tunnel', '--no-autoupdate', '--url', `http://127.0.0.1:${PORT}`], { stdio: ['ignore', 'pipe', 'pipe'], windowsHide: true });
  } catch (e) { console.log('[tunnel] could not start cloudflared:', e.message); return; }
  const onData = (d) => {
    const s = d.toString();
    const mt = s.match(/https:\/\/[a-z0-9-]+\.trycloudflare\.com/);
    if (mt && publicUrl !== mt[0]) {
      publicUrl = mt[0];
      console.log('\n=====================================================');
      console.log(' HTTPS URL (open on your phone):');
      console.log('   ' + publicUrl + '/pad');
      console.log(' Host screen (on this PC):  http://localhost:' + PORT);
      console.log('=====================================================\n');
    }
    if (/ERR|error/i.test(s) && !mt) process.stdout.write('[tunnel] ' + s);
  };
  tunnelProc.stdout.on('data', onData);
  tunnelProc.stderr.on('data', onData);
  tunnelProc.on('error', (e) => console.log('[tunnel] failed:', e.message, '- install cloudflared or set CLOUDFLARED=path'));
  tunnelProc.on('exit', (c) => { console.log('[tunnel] exited', c); tunnelProc = null; });
}
for (const sig of ['SIGINT', 'SIGTERM', 'exit']) process.on(sig, () => { if (tunnelProc) tunnelProc.kill(); if (sig !== 'exit') process.exit(0); });

server.listen(PORT, '127.0.0.1', () => {
  console.log(`ResortCompiled table tennis on http://localhost:${PORT}`);
  if (TUNNEL) startTunnel();
  else console.log('[tunnel] disabled (NO_TUNNEL=1)');
});
