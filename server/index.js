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
import { Room } from './room.js';

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
    const base = publicUrl || `http://localhost:${PORT}`, screen = (url.searchParams.get('s') || '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8);
    const joinUrl = `${base}/pad${screen ? '?s=' + screen : ''}`;   // each screen's QR carries its code, so a phone that scans it links to that screen
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
function send(ws, obj) { if (ws.readyState === 1) ws.send(JSON.stringify(obj)); }
// seats, spectators, chat and spectators' hands live in the Room; here it only gets delivery
const room = new Room(game, (to, msg) => {
  const str = JSON.stringify(msg);
  if (to === 'all' || to === 'hosts') for (const h of room.hosts) if (h.readyState === 1) h.send(str);
  if (to === 'all') for (const w of room.pads.keys()) if (w.readyState === 1) w.send(str);
  if (typeof to === 'object' && to.readyState === 1) to.send(str);
});

wss.on('connection', (ws) => {
  ws.on('message', (data) => {
    let m; try { m = JSON.parse(data); } catch { return; }
    if (m.t === 'hello') { room.hello(ws, m); return; }
    if (m.t === 'chat') { room.chat(ws, m.text, m.name, Number(m.as) || 0); return; }   // phones and screens alike
    if (m.t === 'pause') { room.pause(ws, m.name); return; }                  // only the players may (Room checks); anyone may kick
    if (m.t === 'resume') { room.resume(ws); return; }
    if (m.t === 'end') { if (game.phase !== 'lobby' && room.end(ws, m.name)) resetToLobby(); return; }
    if (m.t === 'kick') { room.kick(ws, Number(m.seat), m.name); return; }
    if (room.paused && ['m', 'swing', 'toss', 'kswing', 'ktoss'].includes(m.t) && room.pads.get(ws)?.seat !== -1) return;   // no swings while paused (spectators still wave)
    if (ws.isHost) {
      if (m.t === 'start') startFrom(m);
      else if (m.t === 'name') room.renameFrom(ws, Number(m.sid), m.name);        // a screen renames a phone linked to it
      else if (m.t === 'kbdjoin') room.kbdJoin(ws);
      else if (m.t === 'kbdleave') room.kbdLeave(ws);
      else if (m.t === 'kswing' && ws.kbdSeat !== undefined) game.registerSwing(ws.kbdSeat, m);
      else if (m.t === 'ktoss' && ws.kbdSeat !== undefined) game.toss(ws.kbdSeat);
      return;
    }
    const pad = room.pads.get(ws);
    if (!pad) return;
    if (m.t === 'm') {
      if (pad.seat < 0) { room.motion(pad, m); return; }               // a spectator's phone moves their hand on the sideline
      pad.lastM = Date.now();
      // phone clock -> server clock: the smallest (arrival - phone timestamp) seen is the clock offset plus the fastest trip.
      // It creeps up 0.6 ms/s so a slower route (tunnel reconnect) is picked up.
      const d = performance.now() - m.ts;
      if (Number.isFinite(d)) pad.minDelta = Math.min(d, (pad.minDelta ?? d) + 0.01);
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
    } else if (m.t === 'role') room.setRole(pad, !!m.play);              // play <-> spectate without disconnecting
    else if (m.t === 'name') room.rename(pad, m.name);
    else if (m.t === 'wave') room.wave(pad);
    else if (m.t === 'ping') send(ws, { t: 'pong', c: m.c });
  });
  ws.on('close', () => room.bye(ws));
});

function handleAction(pad, r) {
  if (r.kind === 'toss') game.toss(pad.seat);
  else if (r.kind === 'swing') {
    // a swing also works as a toss request if the ball is still in hand and it was a big upward flick: handled in detector
    game.registerSwing(pad.seat, { ...r, ago: swingAgo(pad, r) });
    send(pad.ws, { t: 'swung', power: r.power, side: r.side, spin: r.spin, aim: r.aim });
  }
}
// Seconds between the swing's peak on the phone and the simulation's current time, for lag compensation (Game.registerSwing).
// Uses the phone's own timestamp of the peak mapped through the best-case clock offset, so network jitter drops out.
function swingAgo(pad, r) {
  if (pad.minDelta === undefined || !Number.isFinite(r.peakTs)) return undefined;
  const wallAgo = (performance.now() - (r.peakTs + pad.minDelta)) / 1000;
  return wallAgo - (acc + Number(process.hrtime.bigint() - last) / 1e9);   // minus wall time the simulation has not stepped through yet
}

function startFrom(m) {
  if (game.phase !== 'lobby' && game.phase !== 'over') return;
  game.startMatch({ skill: Number(m.skill ?? 0.6), pointsToWin: Number(m.toWin) === 7 ? 7 : 11 });
}
function resetToLobby() {
  room.paused = null; game.phase = 'lobby'; game.message = 'Waiting for players'; game.score = [0, 0]; game.winner = -1;
  for (let i = 0; i < 2; i++) { const s = game.seats[i]; if (s.kind === 'cpu') { s.kind = 'empty'; s.name = ''; } }
  game.parkBall();
}

// ---- game loop --------------------------------------------------------------------------------
const DT = 1 / 60;
let acc = 0, last = process.hrtime.bigint(), netT = 0;   // netT: the screens' clock, which keeps running while the game is paused
let padTick = 0;
setInterval(() => {
  const now = process.hrtime.bigint();
  acc += Number(now - last) / 1e9; last = now;
  if (acc > 0.25) acc = 0.25;
  while (acc >= DT) {
    if (!room.tickPause(Date.now())) game.step(DT);   // paused: the world holds still, screens keep drawing it
    acc -= DT; netT += DT;
    const snap = game.snapshot(); snap.time = netT; snap.pause = room.pauseInfo();
    const evPads = snap.ev.filter((e) => e.type === 'feedback');
    if (room.hosts.size) {
      const str = JSON.stringify({ ...snap, t: 's' });
      for (const h of room.hosts) if (h.readyState === 1) h.send(str);
    }
    for (const e of evPads) for (const [ws, pad] of room.pads) if (pad.seat === e.seat) send(ws, { ...e, t: 'fb' });
    if (++padTick % 4 === 0) room.arms();
    if (padTick % 6 === 0) {
      const st = { t: 'st', phase: snap.phase, msg: snap.msg, score: snap.score, server: snap.server, serveStage: snap.serveStage, pause: snap.pause, seats: game.seats.map((s) => ({ kind: s.kind, name: s.name, online: s.online })), win: snap.win };
      for (const [ws, pad] of room.pads) send(ws, { ...st, seat: pad.seat });
      room.syncRoster();
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
    const mt = s.match(/https:\/\/(?!api\.)[a-z0-9-]+\.trycloudflare\.com/);   // cloudflared's error lines name https://api.trycloudflare.com: not the tunnel
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
  tunnelProc.on('exit', (c) => {
    console.log('[tunnel] exited', c); tunnelProc = null;
    if (!process.env.PUBLIC_URL) publicUrl = null;      // stop advertising a dead link
    if (c === 1) setTimeout(startTunnel, 5000);          // cloudflared gave up (e.g. a network blip creating the tunnel): try again
  });
}
for (const sig of ['SIGINT', 'SIGTERM', 'exit']) process.on(sig, () => { if (tunnelProc) tunnelProc.kill(); if (sig !== 'exit') process.exit(0); });

server.listen(PORT, '127.0.0.1', () => {
  console.log(`ResortCompiled table tennis on http://localhost:${PORT}`);
  if (TUNNEL) startTunnel();
  else console.log('[tunnel] disabled (NO_TUNNEL=1)');
});
