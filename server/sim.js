// Table tennis simulation: authoritative game logic for the Resort web port.
//
// Units are the game's native units (table half-width 9.15, half-length 16.398,
// ball collision radius 0.452, restitution 0.82, friction 0.2 - all recovered from
// the Wii Sports Resort executable, see ../../pingpong/research/FINDINGS.md).
// Time is in seconds. The original runs a per-frame integrator; this uses a
// 240 Hz substepped equivalent with the same structure (drag -> gravity ->
// Magnus -> move -> collide). Constants that were only recovered per-frame are
// rescaled by hand (see CONSTANTS) and are NOT bit-exact.
//
// Coordinates: +x = screen right for the main camera, y up, table top at y = 0,
// net on the z = 0 plane. Seat 0 stands at +z (camera side), seat 1 at -z.

import { RacketPose, RemoteHeading } from '../public/racket_pose.js';

export const K = {
  HW: 9.15,          // table half width (recovered)
  HL: 16.398,        // table half length (recovered)
  R: 0.452,          // ball collision radius (recovered)
  E: 0.82,           // table restitution (recovered)
  MU: 0.2,           // table friction (recovered)
  NET_H: 1.87,       // net height from the table model (WS2_png_table)
  G: 70,             // 9.8 m/s^2 at 11.97 units / metre
  DRAG: 0.0845,      // -ln(0.9986) * 60 per second (recovered base, 60 Hz)
  MAGNUS: 0.008,     // hand-tuned: recovered 1e-4/frame scale is unit-ambiguous
  FLOOR: -6.06,      // floor height from the table model (WS2_png_table)
  HOME_Z: 22.3,      // ready position |z| behind the table end
  MOVE_SPEED2: 52,   // (legacy, used only for hit-effort checks)
  SPEED_SCALE: 1.6,  // multiplies the recovered running speeds (research/movement.md, assumes 240 pose updates per second)
  PLANE: 20.5,       // |z| of the ideal contact plane
  ZONE_MIN: 12,      // swing-able |z| range, incoming
  ZONE_MAX: 34,
  REACH: 7.2,        // lateral reach of the paddle
  SWING_WINDOW: 0.34,
  WHIFF_LOCK: 1.0,   // seconds a missed swing leaves you unable to swing again (anti swing-spam)
  SLOW: 1.75,         // flight-time multiplier: >1 = slower, floatier ball
  DIVE_REACH: 20,    // lateral distance (from the stance spot) a swinging player can still lunge for; hits beyond 6.5 are dives
  LATENCY: 0.07,     // seconds between the true swing peak and its registration (detector + network). Phone swings are now timed
                     // from their actual peak plus this nominal delay (lag compensation), so this is the timing calibration knob.
  FACE_ARC: 0.3,     // racket face tilt at contact: fully open (40 deg up) = 30% longer, higher flight; fully closed = 30% flatter, faster
  PERFECT: 0.25,     // |timing| under this is a PERFECT hit (12% faster shot); the phone shows PERFECT at the same threshold
  SPIN_READ: 0.6,    // face tilt the incoming spin asks for (1 = 40 deg). Spin at contact runs median 0.42, p90 0.71 (CPU rallies), so a
                     // typical ball wants the face ~10 deg closed vs topspin / opened vs backspin, and a heavy one ~17 deg
  SPIN_FAULT: 1.1,   // misjudging that by more than this (44 deg) puts the ball in the net (too closed) or long (too open); smaller misses
                     // only shape the shot, and from 0.6 (24 deg) too open the ball pops up for the opponent to smash
  MOVE_SPEED: 62,
  POINTS_TO_WIN: 11,
};

const sgn = (v) => (v < 0 ? -1 : 1);
const clamp = (v, a, b) => Math.min(b, Math.max(a, v));
const lerp = (a, b, t) => a + (b - a) * t;
export const topspin = (b) => clamp(b.w[0] * Math.sign(b.v[2]) / 40, -1.5, 1.5);   // spin relative to travel: + topspin, - backspin (1 = full brush)

export function newBall() {
  return { p: [0, 6, 0], v: [0, 0, 0], w: [0, 0, 0], qx: 0, qy: 0, qz: 0 };
}

// Advance the ball. Returns events: {type:'bounce',half,x,z,speed} | 'net' | 'floor'.
// half: 0 when z > 0 (seat 0's end), 1 when z < 0.
export function stepBall(b, dt, noEvents) {
  const ev = [];
  const n = 4;
  const h = dt / n;
  for (let i = 0; i < n; i++) {
    const d = Math.exp(-K.DRAG * h);
    b.v[0] *= d; b.v[1] *= d; b.v[2] *= d;
    const sd = Math.exp(-0.1 * h);
    b.w[0] *= sd; b.w[1] *= sd; b.w[2] *= sd;
    b.v[1] -= K.G * h;
    const cx = b.w[1] * b.v[2] - b.w[2] * b.v[1];
    const cy = b.w[2] * b.v[0] - b.w[0] * b.v[2];
    const cz = b.w[0] * b.v[1] - b.w[1] * b.v[0];
    b.v[0] += cx * K.MAGNUS * h;
    b.v[1] += cy * K.MAGNUS * h;
    b.v[2] += cz * K.MAGNUS * h;
    const py = b.p[1], pz = b.p[2];
    b.p[0] += b.v[0] * h; b.p[1] += b.v[1] * h; b.p[2] += b.v[2] * h;

    // net
    if ((pz > 0 && b.p[2] <= 0) || (pz < 0 && b.p[2] >= 0)) {
      if (Math.abs(b.p[0]) < K.HW + 1.0 && b.p[1] - K.R * 0.5 < K.NET_H && b.p[1] > -0.5) {
        b.v[2] = -b.v[2] * 0.18; b.v[0] *= 0.4; b.v[1] *= 0.5;
        b.p[2] = (pz > 0 ? 1 : -1) * 0.35;
        if (!noEvents) ev.push({ type: 'net', x: b.p[0], y: b.p[1] });
        else ev.push({ type: 'net' });
      }
    }
    // table top
    if (b.v[1] < 0 && b.p[1] < K.R && py >= K.R - 0.7 &&
        Math.abs(b.p[0]) < K.HW + K.R * 0.4 && Math.abs(b.p[2]) < K.HL + K.R * 0.4) {
      b.p[1] = K.R;
      bounceTable(b);
      ev.push({ type: 'bounce', half: b.p[2] > 0 ? 0 : 1, x: b.p[0], z: b.p[2], speed: Math.abs(b.v[1]) });
    }
    // floor
    if (b.p[1] < K.FLOOR + K.R && b.v[1] < 0) {
      b.p[1] = K.FLOOR + K.R;
      b.v[1] = -b.v[1] * 0.6; b.v[0] *= 0.8; b.v[2] *= 0.8;
      ev.push({ type: 'floor', x: b.p[0], z: b.p[2], speed: Math.abs(b.v[1]) });
    }
  }
  b.qx += b.w[0] * dt; b.qy += b.w[1] * dt; b.qz += b.w[2] * dt;
  return ev;
}

// Contact response with spin: normal restitution, capped Coulomb friction at the contact point,
// angular impulse with unit inverse inertia (as recovered), then the recovered spin damping.
function bounceTable(b) {
  const vn = b.v[1];                     // < 0
  const jn = -(1 + K.E) * vn;            // normal impulse (mass 1)
  b.v[1] = -vn * K.E;
  // contact point velocity: v + w x r, r = (0,-R,0)
  const rx = 0, ry = -K.R, rz = 0;
  const wxr = [b.w[1] * rz - b.w[2] * ry, b.w[2] * rx - b.w[0] * rz, b.w[0] * ry - b.w[1] * rx];
  let tx = b.v[0] + wxr[0], tz = b.v[2] + wxr[2];
  const L = Math.hypot(tx, tz);
  if (L > 1e-6) {
    const cap = jn * K.MU;
    // at most the 40% a hollow ball loses when it grips and starts rolling (the recovered model could cancel it all): steep, slow balls
    // landing short no longer stop dead and bob in place near the net, out of everyone's reach
    const j = Math.min(L * 0.4, cap);
    const dvx = -tx / L * j, dvz = -tz / L * j;
    b.v[0] += dvx; b.v[2] += dvz;
    // dw = r x dv  (inverse inertia 1)
    b.w[0] += ry * dvz - rz * 0;
    b.w[2] += rx * 0 - ry * dvx;
  }
  b.w[0] *= 0.985; b.w[1] *= 0.99; b.w[2] *= 0.985;
}

function cloneBall(b) { return { p: b.p.slice(), v: b.v.slice(), w: b.w.slice(), qx: 0, qy: 0, qz: 0 }; }

// Simulate a trajectory until its second table bounce or failure.
// Returns {bounces:[{half,x,z,t}], netClear:minimum clearance above net at crossing or null}
function trace(b0, maxT = 3.0) {
  const b = cloneBall(b0);
  const out = { bounces: [], netY: null, netHit: false, dead: false };
  const dt = 1 / 120;
  for (let t = 0; t < maxT; t += dt) {
    const pz = b.p[2];
    const ev = stepBall(b, dt, true);
    if ((pz > 0 && b.p[2] <= 0) || (pz < 0 && b.p[2] >= 0)) {
      if (out.netY === null) { out.netY = b.p[1]; out.netX = b.p[0]; }
    }
    for (const e of ev) {
      if (e.type === 'bounce') { out.bounces.push({ half: e.half, x: e.x, z: e.z, t }); }
      else if (e.type === 'net') out.netHit = true;
      else if (e.type === 'floor') { out.dead = true; return out; }
    }
    if (out.netHit) return out;
    if (out.bounces.length >= 2) return out;
  }
  return out;
}

// Plan a rally return: set v and w on `ball` so it (approximately) lands on (tx, tz).
export function planRally(ball, tx, tz, power, spinParam, sg, Tover, arc = 1) {
  let T = Math.max((Tover ?? lerp(0.95, 0.42, power)) * K.SLOW * arc, Tover !== undefined && Tover < 0.5 ? 0.34 : 0.62);   // smashes (small Tover) may be fast; normal shots never faster than a human can react to   // never faster than a human can react to
  let best = null;
  for (let attempt = 0; attempt < 6; attempt++) {
    const b = cloneBall(ball);
    b.w = [-sg * spinParam * 40, 0, 0];
    const v = [
      (tx - b.p[0]) / T,
      (K.R - b.p[1] + 0.5 * K.G * T * T) / T,
      (tz - b.p[2]) / T,
    ];
    // drag compensation of the vacuum solution
    const comp = Math.exp(K.DRAG * T * 0.5);
    v[0] *= comp; v[2] *= comp;
    let lastTr = null;
    for (let it = 0; it < 7; it++) {
      b.v = v.slice();
      const tr = trace(b, 2.5);
      lastTr = tr;
      const land = tr.bounces[0];
      if (!land) break;
      const ex = tx - land.x, ez = tz - land.z;
      if (Math.abs(ex) + Math.abs(ez) < 0.15) break;
      v[0] += ex / Math.max(land.t, 0.15) * 0.9;
      v[2] += ez / Math.max(land.t, 0.15) * 0.9;
    }
    best = { v, w: b.w, tr: lastTr };
    // a ball that goes around the outside of the net post needs no height clearance (legal in table tennis)
    const aroundPost = lastTr && lastTr.netX !== undefined && Math.abs(lastTr.netX) > K.HW + 1.4;
    const clear = aroundPost ? 99 : lastTr && lastTr.netY !== null ? lastTr.netY - K.R : 99;
    if (!(lastTr && lastTr.netHit) && clear > K.NET_H + 0.5) break;
    T *= 1.15;
  }
  ball.v = best.v; ball.w = best.w;
}

// Plan a serve: bounce on own half first, then land on the opponent half near (tx, tzDepth).
export function planServe(ball, tx, depth, power, spinParam, sg) {
  const target = [tx, -sg * depth];
  let best = null;
  // pass 0: comfortable margins on the table; pass 1: anything that is still a legal serve
  for (const margin of [[1.6, 1.2, 1.0, 0.8], [0.6, 0.4, 0.4, 0.3]]) {
    let bestScore = 1e9;
    for (let sp = 24; sp <= 80; sp += 3) {
      for (let vy = -48; vy <= 16; vy += 2) {
        const b = cloneBall(ball);
        b.w = [-sg * spinParam * 25, 0, 0];
        b.v = [(tx - b.p[0]) / 0.6 * 0.5, vy, -sg * sp];
        const tr = trace(b, 2.5);
        if (tr.netHit || tr.bounces.length < 2) continue;
        if (tr.bounces[0].half !== (sg > 0 ? 0 : 1)) continue;
        if (tr.bounces[1].half !== (sg > 0 ? 1 : 0)) continue;
        if (tr.netY === null || tr.netY - K.R < K.NET_H + 0.3) continue;
        const f = tr.bounces[0], q = tr.bounces[1];
        if (Math.abs(f.z) > K.HL - margin[0] || Math.abs(f.x) > K.HW - margin[1] || Math.abs(q.z) > K.HL - margin[2] || Math.abs(q.x) > K.HW - margin[3]) continue;
        const sc = Math.hypot(q.x - target[0], q.z - target[1]);
        if (sc < bestScore) { bestScore = sc; best = { v: b.v.slice(), w: b.w.slice() }; }
      }
    }
    if (best) break;
  }
  if (!best) best = { v: [0, -20, -sg * 55], w: [0, 0, 0] };
  ball.v = best.v; ball.w = best.w;
}

const SEAT_TEMPLATE = () => ({
  kind: 'empty',     // 'empty' | 'human' | 'cpu'
  name: '',
  hand: 1,           // +1 right-handed, -1 left-handed
  x: 0, z: 0, vx: 0, vz: 0,
  swing: null,       // last registered swing {t, power, side, spin, aim, used}
  swingT: -9,
  cpu: { planned: null, tossAt: 0 },
  skill: 0.6,
  online: false,
});

export class Game {
  constructor() {
    this.t = 0;
    this.phase = 'lobby';   // lobby | serve | rally | point | over
    this.seats = [SEAT_TEMPLATE(), SEAT_TEMPLATE()];
    this.score = [0, 0];
    this.initialServer = 0;
    this.server = 0;
    this.ball = newBall();
    this.serveStage = 'hold';  // hold | toss
    this.ballStage = 'dead';   // ownBounce | oppBounce | live | dead
    this.lastHitter = 0;
    this.events = [];
    this.timer = 0;
    this.message = 'Waiting for players';
    this.rallyLen = 0;
    this.lastPoint = null;
    this.winner = -1;
    this.pointsToWin = K.POINTS_TO_WIN;
    this.holdX = 0;
    this.tossT = 0;
    this.listeners = [];
    this.seats[0].z = K.HOME_Z; this.seats[1].z = -K.HOME_Z;
    this.parkBall();
  }

  emit(e) { e.t = this.t; this.events.push(e); }
  feedback(seat, e) { this.emit({ type: 'feedback', seat, ...e }); }

  sg(seat) { return seat === 0 ? 1 : -1; }
  occupied(i) { return this.seats[i].kind !== 'empty'; }

  parkBall() {
    this.ball.p = [0, 8, 0]; this.ball.v = [0, 0, 0]; this.ball.w = [0, 0, 0];
  }

  // ---- match flow ---------------------------------------------------------------------------
  startMatch(opts = {}) {
    for (let i = 0; i < 2; i++) {
      if (this.seats[i].kind === 'empty') {
        this.seats[i].kind = 'cpu';
        this.seats[i].name = 'CPU';
      }
      this.seats[i].x = 0; this.seats[i].z = this.sg(i) * 26; this.seats[i].vx = 0; this.seats[i].vz = 0; this.seats[i].mv = undefined;
      this.seats[i].swing = null;
      this.seats[i].cpu = { planned: null, tossAt: 0 };
      if (this.seats[i].kind === 'cpu') this.seats[i].skill = opts.skill ?? 0.6;
    }
    this.pointsToWin = opts.pointsToWin || K.POINTS_TO_WIN;
    this.score = [0, 0];
    this.initialServer = Math.random() < 0.5 ? 0 : 1;
    this.winner = -1;
    this.beginServe();
  }

  serverFor(total) {
    const idx = total < 2 * (this.pointsToWin - 1) ? Math.floor(total / 2) % 2 : total % 2;
    return idx ^ this.initialServer;
  }

  beginServe() {
    const total = this.score[0] + this.score[1];
    this.server = this.serverFor(total);
    this.phase = 'serve';
    this.serveStage = 'hold';
    this.ballStage = 'dead';
    this.rallyLen = 0;
    this.timer = 0;
    this.message = `${this.seats[this.server].name || 'Player ' + (this.server + 1)} to serve`;
    const s = this.seats[this.server];
    s.cpu.tossAt = this.t + 1.0 + Math.random() * 0.6;
    this.placeHeldBall();
  }

  placeHeldBall() {
    const s = this.seats[this.server];
    const sg = this.sg(this.server);
    this.ball.p = [s.x + s.hand * 1.6 * sg, 3.0, sg * (Math.abs(s.z) - 1.5)];
    this.ball.v = [0, 0, 0]; this.ball.w = [0, 0, 0];
  }

  endPoint(winner, reason) {
    if (this.phase !== 'rally') return;
    this.phase = 'point';
    this.timer = 2.4;
    this.score[winner]++;
    this.lastPoint = { winner, reason };
    this.message = `${this.seats[winner].name || 'Player ' + (winner + 1)} scores - ${reason}`;
    this.emit({ type: 'point', winner, reason, score: this.score.slice() });
    this.ballStage = 'dead';
    this.ball.wob = false;
    const [a, b] = this.score;
    if ((a >= this.pointsToWin || b >= this.pointsToWin) && Math.abs(a - b) >= 2) {
      this.winner = a > b ? 0 : 1;
    }
  }

  // ---- input ------------------------------------------------------------------------------
  toss(seatIdx) {
    if (this.phase !== 'serve' || this.server !== seatIdx || this.serveStage !== 'hold') return false;
    this.serveStage = 'toss';
    this.tossT = this.t;
    this.ball.v = [0, 40, 0];
    this.emit({ type: 'toss', seat: seatIdx });
    this.feedback(seatIdx, { kind: 'toss' });
    return true;
  }

  // sw: {power 0..1, side +1 fore / -1 back, spin -1..1, aim -1..1 (player's right positive)}
  registerSwing(seatIdx, sw) {
    const s = this.seats[seatIdx];
    if (!s || this.phase === 'lobby' || this.phase === 'over') return;
    if (this.t - s.swingT < 0.28) return;   // swing animation lockout
    if (s.kind !== 'cpu' && this.phase === 'rally' && (this.t < (s.missLock || 0) || (this.t - s.swingT < K.SWING_WINDOW + 0.06 && s.swing && !s.swing.used))) {   // still recovering / previous swing unresolved   // recovering from a whiff: swing spam is ignored
      if (this.t - (s.tiredFb || 0) > 0.4) { s.tiredFb = this.t; this.feedback(seatIdx, { kind: 'miss', why: 'tired' }); }
      return;
    }
    s.swingT = this.t;
    s.swing = { t: this.t, power: clamp(sw.power ?? 0.5, 0.1, 1), side: sw.side >= 0 ? 1 : -1, spin: clamp(sw.spin ?? 0, -1, 1), aim: clamp(sw.aim ?? 0, -1, 1), lat: sw.lat, used: false };
    // lag compensation: a phone swing is timed from when it actually peaked (sw.ago, from the phone's clock) plus the nominal delay the
    // timing was tuned with, so a packet that arrives late (network jitter) no longer turns into a late shot
    if (Number.isFinite(sw.ago)) s.swing.t = this.t - clamp(sw.ago - K.LATENCY, -0.05, 0.15);
    this.ensureRacket(s);
    s.rkp.startSwing(s.swing.side === 1 ? 1 : 0, s.swing.power > 0.7 ? 75 : 45);
    s.swingUsed = false; s.diveStart = 0;
    s.rkSyn = { t: 0, dir: s.swing.side * s.hand };   // used when no phone orientation is streaming (CPU, mouse, swipe)
    this.emit({ type: 'swing', seat: seatIdx, side: s.swing.side, power: s.swing.power });
  }

  // ---- tick -------------------------------------------------------------------------------
  step(dt) {
    this.t += dt;
    if (this.phase === 'lobby') return;
    for (let i = 0; i < 2; i++) this.moveSeat(i, dt);
    for (let i = 0; i < 2; i++) this.updateRacket(i);
    if (this.phase === 'rally') for (let i = 0; i < 2; i++) {      // a swing that connects with nothing costs recovery time
      const s = this.seats[i];
      if (s.kind !== 'cpu' && s.swing && !s.swing.used && !s.swingUsed && !s.swing.whiffed && this.t - s.swing.t > K.SWING_WINDOW) {
        s.swing.whiffed = true; s.missLock = this.t + K.WHIFF_LOCK; this.feedback(i, { kind: 'miss', why: 'whiff' });
      }
    }
    for (let i = 0; i < 2; i++) if (this.seats[i].kind === 'cpu') this.cpuTick(i);

    if (this.phase === 'serve') this.stepServe(dt);
    else if (this.phase === 'rally') this.stepRally(dt);
    else if (this.phase === 'point') {
      // keep the ball moving for visual effect
      this.fall(dt);
      this.timer -= dt;
      if (this.timer <= 0) {
        if (this.winner >= 0) { this.phase = 'over'; this.timer = 9; this.message = `${this.seats[this.winner].name} wins ${this.score[0]}-${this.score[1]}`; this.emit({ type: 'over', winner: this.winner }); }
        else this.beginServe();
      }
    }
    if (this.phase === 'over') {
      this.fall(dt);
      this.timer -= dt;
      if (this.timer <= 0) { this.phase = 'lobby'; this.message = 'Waiting for players'; for (const s of this.seats) if (s.kind === 'cpu') { s.kind = 'empty'; s.name = ''; } this.parkBall(); }
    }
  }

  fall(dt) {
    const ev = stepBall(this.ball, dt);
    for (const e of ev) if (e.type === 'bounce' || e.type === 'floor') this.emit({ type: e.type === 'floor' ? 'floor' : 'bounce2', x: e.x, z: e.z, speed: e.speed });
  }

  // ---- player movement -----------------------------------------------------------------------
  // Structure and constants follow the recovered game logic (research/movement.md): the body target is the ball's contact
  // point plus a stance offset (forehand / backhand / centre), a virtual position chases it with ramped speed (0.07 units per
  // update, 0.04 going home, boosted toward 1.8x when the ball is within 10 units) and the visible body follows at 5% per
  // update; after a stroke the player stops chasing for 90-200 updates, then walks home (z = -17/-28/-40 by skill).
  // Adapted: contact point from our own ball prediction, and 240 updates/s assumed (the scheduler was not found).
  stanceOffset(side, lefty) {
    const o = side === 1 ? [5.5, -3.0] : side === 0 ? [-4.0, -3.5] : [0, -2.0];
    return lefty ? [-o[0], o[1]] : o;
  }
  moveSeat(i, dt) {
    const s = this.seats[i], sg = this.sg(i), b = this.ball;
    const L = (x, z) => (sg > 0 ? [-x, -z] : [x, z]);        // world <-> seat-local (an involution)
    const clampLocal = (x, z) => { z = Math.min(z, -6); const lim = (s.mv && s.mv.over > 0) ? K.HL - 5 : K.HL + 1.2; if (Math.abs(x) < K.HW + 1.5 && z > -lim) z = -lim; return [x, z]; };   // a lunge may reach over the table edge
    if (!s.mv) { const [lx, lz] = L(s.x, s.z); s.mv = { Vx: lx, Vz: lz, Px: lx, Pz: lz, vmax: 0, lock: 0, home: true, T: 1, tgt: [lx, lz] }; s.fwd = 2; }
    const m = s.mv;
    const k = s.kind === 'cpu' ? clamp(1.05 - s.skill * 1.1, 0, 1) : 0.5;           // skill category: 0 strong ... 1 weak
    let f = s.kind === 'cpu' ? lerp(0.85, 1.6, s.skill) : 1.0;
    f *= K.SPEED_SCALE;
    let tgt, T = 1, inbound = false;
    if (this.phase === 'lobby') { tgt = [0, -26]; }
    else if (this.phase === 'serve' || this.phase === 'point' || this.phase === 'over') {
      const srv = this.phase === 'point' ? this.serverFor(this.score[0] + this.score[1]) : this.server;
      tgt = srv === i ? [4.5, -(K.HL + 1.2)] : [0, -26];               // server beside the table end, receiver back (recovered)
      m.home = false; s.fwd = 2;
    } else if (this.phase === 'rally' && this.ballStage === 'live' && this.lastHitter !== i && b.v[2] * sg > 0) {
      inbound = true; m.home = false;
      const pc = this.predictContact(sg);
      const bl = [sg > 0 ? -pc.x : pc.x, -pc.z];                      // ball contact point in local space
      let humanSide = 2;
      if (s.kind !== 'cpu' && s.rkp) { const A = s.rkp.yaw * (s.hand === -1 ? -1 : 1); humanSide = A < -25 ? 1 : A > 25 ? 0 : 2; }
      const cands = (s.kind === 'cpu' ? [1, 0] : [humanSide]).map((sd) => { const o = this.stanceOffset(sd, s.hand === -1); return { sd, p: [bl[0] + o[0], bl[1] + o[1]], fwd: -o[1] }; });
      cands.sort((p, q) => Math.hypot(p.p[0] - m.Vx, p.p[1] - m.Vz) - Math.hypot(q.p[0] - m.Vx, q.p[1] - m.Vz));
      tgt = cands[0].p; s.fwd = cands[0].fwd;
      T = Math.max(1, pc.t * 240 - 180);                               // arrive 180 updates before the ball
    } else {
      const d = k <= 0.5 ? 2 * k * 11 + 17 : 2 * (k - 0.5) * 12 + 28;  // home depth: 17 / 28 / 40
      tgt = [0, -d]; m.home = true;
    }
    const tz = Math.min(tgt[1], -6);
    // ball lead point (40 updates ahead) for the near-ball speed boost
    let ft = f;
    if (inbound || this.phase === 'rally') {
      const q = L(b.p[0] + b.v[0] * 40 / 240, b.p[2] + b.v[2] * 40 / 240);
      const dist = Math.hypot(q[0] - m.Px, q[1] - m.Pz);
      const t = clamp((10 - dist) / 5, 0, 1);
      if (f < 1.8) ft = f + (1.8 - f) * t * t;
    }
    const px0 = m.Px, pz0 = m.Pz;
    for (let n = 0; n < 4; n++) {                                      // 4 pose updates per 60 Hz step
      m.lock = Math.max(m.lock - 1, 0); if (m.over > 0) m.over--;
      const vcap = (m.lock > 0 ? 0 : (m.home ? 0.04 : 0.07)) * ft, acc = 0.0012 * ft;
      if (vcap > m.vmax) m.vmax = Math.min(m.vmax + acc, vcap); else m.vmax = vcap;
      const dx = tgt[0] - m.Vx, dz = tz - m.Vz, d = Math.hypot(dx, dz);
      let need = d / T;
      if (need > m.vmax) need = m.vmax; else m.vmax = need;
      if (d > 1e-9) { m.Vx += dx / d * need; m.Vz += dz / d * need; }
      [m.Vx, m.Vz] = clampLocal(m.Vx, m.Vz);
      m.Px += 0.05 * (m.Vx - m.Px); m.Pz += 0.05 * (m.Vz - m.Pz);
      [m.Px, m.Pz] = clampLocal(m.Px, m.Pz);
    }
    const [wx, wz] = L(m.Px, m.Pz);
    s.vx = (wx - s.x) / dt; s.vz = (wz - s.z) / dt;
    s.x = wx; s.z = wz;
  }

  // where (x, |z|) and when the ball will next be hittable on side sg: after its bounce, while descending below hand height
  // (reaching over the table for short balls), or just before it would bounce a second time.
  predictContact(sg) {
    const b = cloneBall(this.ball);
    let last = { t: 2.8, x: b.p[0], z: K.HL + 6 };
    for (let t = 0; t < 2.8; t += 1 / 120) {
      const ev = stepBall(b, 1 / 120, true);
      const dz = b.p[2] * sg;
      if (ev.some((q) => q.type === 'bounce')) break;          // must be hit before it bounces again
      last = { t, x: b.p[0], z: dz };
      if (dz > K.HL - 5 && b.v[1] < 0 && b.p[1] < 4.5) break;
      if (dz > K.HL + 12) break;
    }
    return { t: last.t, x: last.x, z: clamp(last.z, 6, K.HL + 12.2) };
  }

  // x where the ball will be at the contact plane of side sg
  predictX(sg) {
    const b = cloneBall(this.ball);
    for (let t = 0; t < 2.5; t += 1 / 60) {
      stepBall(b, 1 / 60, true);
      if (b.p[2] * sg >= K.PLANE) return b.p[0];
    }
    return b.p[0];
  }
  predictTime(sg) {
    const b = cloneBall(this.ball);
    for (let t = 0; t < 2.5; t += 1 / 120) {
      stepBall(b, 1 / 120, true);
      if (b.p[2] * sg >= K.PLANE) return { t, x: b.p[0], y: b.p[1] };
    }
    return null;
  }

  stepServe(dt) {
    const s = this.seats[this.server];
    const sg = this.sg(this.server);
    if (this.serveStage === 'hold') {
      this.placeHeldBall();
      return;
    }
    // toss in the air
    const b = this.ball;
    const ev = stepBall(b, dt);
    b.v[0] *= 0.99;
    // simple toss physics: only gravity (override drag to keep it straight)
    const sw = s.swing;
    if (sw && !sw.used && this.t - sw.t < K.SWING_WINDOW && b.p[1] < 8.5 && b.p[1] > 1.9 && b.v[1] < 6 && this.t - this.tossT > 0.25) {
      sw.used = true;
      this.serveHit(sw);
      return;
    }
    if (b.p[1] < 1.5 || this.t - this.tossT > 2.2) {
      // missed the toss: re-hold
      this.serveStage = 'hold';
      this.feedback(this.server, { kind: 'tossMiss' });
      s.cpu.tossAt = this.t + 0.8;
    }
  }

  serveHit(sw) {
    const sg = this.sg(this.server);
    const b = this.ball;
    const tx = sg * (sw.aim * (this.seats[this.server].hand === 1 ? 1 : 1)) * 6.5;
    const depth = lerp(5.5, 14, sw.power);
    planServe(b, clamp(tx, -8, 8), depth, sw.power, sw.spin, sg);
    this.phase = 'rally';
    this.ballStage = 'ownBounce';
    b.wob = false; b.smash = false;
    this.lastHitter = this.server;
    this.rallyLen = 1;
    this.message = '';
    this.seats[this.server].touch = { p: b.p.slice(), t: this.t };
    this.emit({ type: 'hit', seat: this.server, speed: Math.hypot(...b.v), serve: true, side: sw.side, spin: sw.spin, tw: this.seats[this.server].rkp ? this.seats[this.server].rkp.a194 : 0 });
    if (this.seats[this.server].mv) { this.seats[this.server].mv.lock = 60; this.seats[this.server].mv.home = true; }
    this.feedback(this.server, { kind: 'serve', power: sw.power });
  }

  // ---- racket (recovered game logic, research/racket.md): pose from the controller, free object in the world -----------------
  // racket face tilt of a phone player, as the on-screen paddle shows it: + open (facing up), - closed, 1 = 40 deg. 0 while the blade is
  // side-on, and tilts under 8 deg count as flat so orientation noise cannot change a shot. null for players without a phone.
  faceOpen(s, sg) {
    if (!s.rk || !s.rk.phone) return null;
    const n = s.rk.rows[1], f = -sg * n[2], k = f < 0 ? -1 : 1;          // blade normal, turned toward the opponent (forward = -sg z)
    const tilt = f * k > 0.35 ? Math.atan2(n[1] * k, f * k) / 0.7 : 0;
    return Math.sign(tilt) * clamp((Math.abs(tilt) - 0.2) / 0.8, 0, 1);
  }
  // how far a phone player's face is from what the incoming ball's spin asks for (+ too open, - too closed), while the ball is on its
  // way to them; the PC tints their paddle with it so the spin read can be learned. null otherwise.
  faceCue(s, i) {
    const b = this.ball, face = this.faceOpen(s, this.sg(i));
    if (face === null || this.phase !== 'rally' || this.lastHitter === i || b.v[2] * this.sg(i) <= 0) return null;
    return +(face + K.SPIN_READ * topspin(b)).toFixed(2);
  }
  ensureRacket(s) {
    if (s.rkp) return;
    s.rkp = new RacketPose(false); s.rkh = new RemoteHeading(); s.rkTheta = null; s.rkSyn = null; s.rk = null; s.rkPrevPivot = null; s.touch = null; s.swingUsed = true;
  }
  updateRacket(i) {
    const s = this.seats[i], sg = this.sg(i);
    this.ensureRacket(s);
    s.rkp.lefty = s.hand === -1;
    const phone = !!(s.tilt && this.t - s.tiltT < 0.3);
    let p, twist = 0, nrm = null;
    if (phone) {
      p = [-s.tilt.y[0], s.tilt.y[2], s.tilt.y[1]];                       // calibrated frame (x right, y fwd, z up) -> game frame (x left)
      const n = [-s.tilt.z[0], s.tilt.z[2], s.tilt.z[1]]; nrm = n;
      const len = Math.hypot(...p) || 1; p = p.map((v) => v / len);
      let r = [-p[1] * p[0], 1 - p[1] * p[1], -p[1] * p[2]]; const rl = Math.hypot(...r);
      r = rl < 0.2 ? [0, 0, 1] : r.map((v) => v / rl);
      const pr = [p[1] * r[2] - p[2] * r[1], p[2] * r[0] - p[0] * r[2], p[0] * r[1] - p[1] * r[0]];
      const th = Math.atan2(n[0] * pr[0] + n[1] * pr[1] + n[2] * pr[2], n[0] * r[0] + n[1] * r[1] + n[2] * r[2]) * 180 / Math.PI;
      if (s.rkTheta !== null) { let d = th - s.rkTheta; if (d > 180) d -= 360; if (d < -180) d += 360; twist = d; }
      s.rkTheta = th;
    } else {
      s.rkTheta = null;
      let psi = 0;
      if (s.rkSyn) { s.rkSyn.t += 1 / 60; const u = Math.min(1, s.rkSyn.t / 0.32); psi = s.rkSyn.dir * 55 * (1 - 2 * (0.5 - 0.5 * Math.cos(Math.PI * u))); if (u >= 1) s.rkSyn = null; }
      const a = psi * Math.PI / 180, ph = 0.2;
      p = [-Math.sin(a) * Math.cos(ph), Math.sin(ph), Math.cos(a) * Math.cos(ph)];
    }
    const live = this.phase === 'rally' || (this.phase === 'serve' && this.serveStage === 'toss');
    const hs = s.rkh.update(p);
    const out = s.rkp.tick(p, twist, hs, live, null, null);
    // facing (toward the opponent half point (0, 8)), blended slowly, as the game does
    const want = Math.atan2(0 - s.x, -sg * 8 - s.z);
    s.face = s.face === undefined ? want : s.face + Math.atan2(Math.sin(want - s.face), Math.cos(want - s.face)) * (1 - Math.pow(0.99, 4));
    const cf = Math.cos(s.face), sf = Math.sin(s.face);
    const Wd = (v) => [v[0] * cf + v[2] * sf, v[1], -v[0] * sf + v[2] * cf];
    const Pw = (v) => { const w = Wd(v); return [w[0] + s.x, w[1] + K.FLOOR, w[2] + s.z]; };
    let pivot = Pw(out.pivot), grip = Pw(out.grip);
    let rows = out.rows.map(Wd);
    let direct = null;
    if (phone && nrm) {
      // DIRECT MODE: the paddle copies the phone. Its long axis is the phone's top edge, its face normal is the phone's screen normal
      // (the recovered Wii bone/angle constraints are ignored). The hand sits at a shoulder-height anchor and follows where the phone points.
      let Z = p.slice(), nn = nrm.slice(); const d = nn[0] * Z[0] + nn[1] * Z[1] + nn[2] * Z[2];
      nn = nn.map((v, k) => v - Z[k] * d); const nl = Math.hypot(...nn);
      if (nl > 0.2) {
        const X = nn.map((v) => v / nl);
        const Y = [Z[1] * X[2] - Z[2] * X[1], Z[2] * X[0] - Z[0] * X[2], Z[0] * X[1] - Z[1] * X[0]];   // Z x X
        const hand = [-0.75 + 0.7 * Z[0], 5.9 + 0.8 * Z[1], 1.8 + 1.1 * Z[2]];
        const piv = hand.map((v, k) => v + 2.75 * Z[k]);
        const Xw = Wd(X), Yw = Wd(Y), Zw = Wd(Z);
        direct = { cols: [Xw, Yw, Zw] };
        rows = [Yw.map((v) => -v), Xw, Zw];
        pivot = Pw(piv); grip = Pw(hand);
      }
    }
    const b = this.ball;
    let delta = [0, 0, 0];
    // intercept assist (the game has one too): while a swing is active the racket reaches for a nearby incoming ball
    if (phone && s.rkp.swing > 0 && !s.swingUsed && this.phase === 'rally' && this.ballStage === 'live' && this.lastHitter !== i && b.v[2] * sg > 0) {
      const d = Math.hypot(b.p[0] - pivot[0], b.p[1] - pivot[1], b.p[2] - pivot[2]);
      const w = clamp((22 - d) / 12, 0, 1) * 0.95;
      delta = [(b.p[0] - pivot[0]) * w, (b.p[1] - pivot[1]) * w, (b.p[2] - pivot[2]) * w];
    }
    // after an abstract hit (CPU / mouse / swipe / serve) the racket visibly meets the ball
    if (s.touch && this.t - s.touch.t < 0.14) {
      const w = 0.85 * (1 - (this.t - s.touch.t) / 0.14);
      delta = [(s.touch.p[0] - pivot[0]) * w, (s.touch.p[1] - pivot[1]) * w, (s.touch.p[2] - pivot[2]) * w];
    }
    // DASH / DIVE: swinging at a ball that is out of normal reach makes the character lunge for it (fast burst toward the ball)
    if (phone && s.rkp.swing > 0 && !s.swingUsed && s.swing && this.t - s.swing.t < K.SWING_WINDOW && this.phase === 'rally' && this.ballStage === 'live' && this.lastHitter !== i && b.v[2] * sg > 0 && s.mv) {
      const gap = Math.abs(s.z) - Math.abs(b.p[2]);                      // how far the ball is in front of the body (depth)
      const dx = b.p[0] - s.x, dzw = b.p[2] - s.z, dist = Math.hypot(dx, dzw);
      if (gap > -5 && gap < 28 && dist > 5 && dist < 36) {
        const step = Math.min(dist - 4.0, 85 / 60);                      // dash speed 85 units/s
        const ux = dx / dist * step, uz = dzw / dist * step;
        const lx = sg > 0 ? -ux : ux, lz = sg > 0 ? -uz : uz;           // world -> seat-local
        s.mv.Px += lx; s.mv.Vx += lx; s.mv.Pz += lz; s.mv.Vz += lz;
        s.diveStart = Math.max(s.diveStart || 0, Math.abs(dx));
        s.mv.lock = Math.max(s.mv.lock, 20); s.mv.over = 60;
      }
    }
    pivot = pivot.map((v, k) => v + delta[k]); grip = grip.map((v, k) => v + delta[k]);
    const m = direct ? { pos: pivot.map((v, k) => v - 2.4 * direct.cols[2][k]), cols: direct.cols } : s.rkp.model({ rows, pivot });
    s.rkPrevPivot = s.rk ? s.rk.pivot : pivot;
    s.rk = { phone, pivot, grip, rows, pos: m.pos, cols: m.cols, speed: 0 };
    s.rk.vel = pivot.map((v, k) => (v - s.rkPrevPivot[k]) * 60);
  }
  rkContact(s, ballP) {                                               // sphere vs the racket blade box (half extents 1.65 x 0.16 x 1.73)
    const c = s.rk.pivot, r = s.rk.rows;
    const d = [ballP[0] - c[0], ballP[1] - c[1], ballP[2] - c[2]];
    const u = d[0] * r[0][0] + d[1] * r[0][1] + d[2] * r[0][2], v = d[0] * r[1][0] + d[1] * r[1][1] + d[2] * r[1][2], w = d[0] * r[2][0] + d[1] * r[2][1] + d[2] * r[2][2];
    return Math.abs(u) < 1.65 + K.R + 0.6 && Math.abs(v) < 0.16 + K.R + 0.7 && Math.abs(w) < 1.73 + K.R + 0.6;
  }
  // phone players hit by actually touching the ball with the racket during a swing
  tryPhysical(r, bp0) {
    const s = this.seats[r], sg = this.sg(r), b = this.ball;
    if (this.ballStage !== 'live' || s.swingUsed || !(s.rkp.swing > 0) || b.v[2] * sg <= 0) return;
    if (s.kind !== 'cpu' && !(s.swing && this.t - s.swing.t < K.SWING_WINDOW)) return;   // the blade is only live right after a swing
    let hit = false;
    for (let k = 0; k <= 4 && !hit; k++) {
      const t = k / 4, bp = [bp0[0] + (b.p[0] - bp0[0]) * t, bp0[1] + (b.p[1] - bp0[1]) * t, bp0[2] + (b.p[2] - bp0[2]) * t];
      hit = this.rkContact(s, bp);
    }
    if (!hit) return;
    s.swingUsed = true;
    const sw = s.swing || { power: 0.5, side: 1, spin: 0, aim: 0 };
    const rightW = [sg, 0, 0], fwdW = [0, 0, -sg];
    let n = s.rk.rows[1].slice();                                     // blade face normal (thin axis)
    if (n[0] * fwdW[0] + n[1] * fwdW[1] + n[2] * fwdW[2] < 0) n = n.map((v) => -v);
    const ang = Math.atan2(n[0] * rightW[0] + n[2] * rightW[2], n[0] * fwdW[0] + n[2] * fwdW[2]);
    const vel = s.rk.vel, vs = Math.hypot(...vel) || 1;
    const lat = (vel[0] * rightW[0] + vel[2] * rightW[2]) / vs;
    // Direction comes from the swing's sideways sweep as the phone measured it (calibrated accel, player-right positive): a rightward sweep
    // (backhand for a right-hander) sends the ball to the player's right, a leftward one to the left. (The racket's own velocity is not used: the
    // intercept assist drags the racket toward the ball and made it point at random.) The blade angle and wrist yaw only nudge it.
    const sl = (sw.lat !== undefined ? sw.lat : lat) * (s.aimFlip ? -1 : 1);
    const dirn = Math.sign(sl) * Math.min(1, Math.abs(sl) * 1.5);
    // ball depth when the swing counted (lag-compensated swing time), not when its packet happened to arrive
    const reachF0 = Math.abs(s.z) - Math.abs(b.p[2]) + (Number.isFinite(sw.t) ? clamp(this.t - sw.t, -0.05, 0.15) : 0) * Math.abs(b.v[2]);
    const tq = -clamp((reachF0 - 3) / 6, -1, 1);                         // contact well ahead of the body = early (-), behind = late (+)
    const aimLx = clamp(dirn * 1.05 + clamp(ang / 0.55, -1, 1) * 0.15 + sw.aim * 0.2 - tq * sw.side * s.hand * 0.3, -1.2, 1.2);
    const spin = clamp(vel[1] / vs * 1.2 + sw.spin * 0.5, -1, 1);
    this.completeReturn(r, sw, { q: tq, aimLx, spin, open: this.faceOpen(s, sg), power: sw.power, reachX: Math.abs(b.p[0] - s.x), reachF: Math.abs(s.z) - Math.abs(b.p[2]) });
  }

  stepRally(dt) {
    const b = this.ball;
    const bp0 = b.p.slice();
    const ev = stepBall(b, dt);
    const h = this.lastHitter;
    const opp = 1 - h;
    for (const e of ev) {
      if (this.phase !== 'rally') break;
      if (e.type === 'bounce') {
        this.emit({ type: 'bounce', x: e.x, z: e.z, speed: e.speed });
        const X = e.half;                // which seat's half
        if (this.ballStage === 'ownBounce') {
          if (X === h) this.ballStage = 'oppBounce';
          else this.endPoint(opp, 'bad serve');
        } else if (this.ballStage === 'oppBounce') {
          if (X === opp) this.ballStage = 'live';
          else this.endPoint(opp, 'own-side bounce');
        } else if (this.ballStage === 'live') {
          if (X === opp) this.endPoint(h, 'winner');
          else this.endPoint(opp, 'bad bounce');
        }
      } else if (e.type === 'net') {
        this.emit({ type: 'netTouch' });
        if (this.ballStage !== 'live') {
          this.endPoint(opp, 'net');
        }
      } else if (e.type === 'floor') {
        this.emit({ type: 'floor' });
        if (this.ballStage === 'live') this.endPoint(h, 'winner');
        else this.endPoint(opp, 'out');
      }
    }
    if (this.phase !== 'rally') return;
    // receiver swings: phone players must touch the ball with the racket, others use the abstract timing window
    if (this.seats[opp].rk && this.seats[opp].rk.phone) {
      this.tryPhysical(opp, bp0);
      // safety net: a fast ball that slips past the blade while the swing is still active (and timed inside the swing window) still counts
      const so = this.seats[opp];
      if (!so.swingUsed && this.ballStage === 'live') { this.tryReturn(opp); if (so.swing && so.swing.used) so.swingUsed = true; }
    } else this.tryReturn(opp);
  }

  tryReturn(r) {
    if (this.ballStage !== 'live') return;
    const s = this.seats[r];
    const sw = s.swing;
    if (!sw || sw.used) return;
    if (this.t - sw.t > K.SWING_WINDOW) return;
    const sg = this.sg(r);
    const b = this.ball;
    if (b.v[2] * sg <= 0) return;
    const dz = b.p[2] * sg;
    const plane = Math.abs(s.z) - (s.fwd ?? 2);
    if (dz < plane - 14 || dz > plane + 16) return;     // reaching over the table for short balls
    const stanceX = sw.side === 1 ? s.hand * sg * 5.5 : -s.hand * sg * 4.0;       // where the ball sits relative to the body for this stroke
    if (Math.abs(b.p[0] - (s.x + stanceX)) > K.DIVE_REACH) {   // beyond normal reach (6.5) a swing becomes a lunge/dive
      if (dz > plane) { sw.used = true; this.feedback(r, { kind: 'miss', why: 'reach' }); }
      return;
    }
    sw.used = true;
    const reachX = Math.abs(b.p[0] - s.x), reachF = Math.abs(s.z) - dz;   // lateral / forward reach from the body (clip variant picks use these)
    const speed = Math.abs(b.v[2]);
    const dtm = (dz - plane) / Math.max(speed, 20) - (this.t - sw.t) - K.LATENCY;   // + late, - early
    const q = clamp(dtm / 0.16, -1, 1);
    const latDir = sw.lat !== undefined ? clamp(sw.lat, -1, 1) : -sw.side * s.hand * 0.6;      // swing direction (player right positive): fore sweeps left, back sweeps right
    const aimLx = clamp(-q * sw.side * s.hand * 0.9 + sw.aim * 0.6 + latDir * 0.5, -1.2, 1.2);
    s.touch = { p: b.p.slice(), t: this.t };
    this.completeReturn(r, sw, { q, aimLx, spin: sw.spin, open: this.faceOpen(s, sg), power: sw.power, reachX, reachF });
  }

  completeReturn(r, sw, info) {
    const s = this.seats[r], sg = this.sg(r), b = this.ball;
    const { q, aimLx, reachF } = info;
    // SPIN READ (as in real table tennis): incoming topspin must be met with a closed face, backspin with an open one. Phone players set
    // the face with their hand; the CPU reads it with skill-dependent error; mouse / swipe players (no face input) read it perfectly.
    const spinIn = topspin(b), need = -K.SPIN_READ * spinIn;
    const face = info.open ?? (s.kind === 'cpu' ? need + (Math.random() + Math.random() + Math.random() - 1.5) * lerp(0.8, 0.25, s.skill) * Math.abs(spinIn) : need);
    const err = clamp(face - need, -1.5, 1.5);          // + too open (pops up, sails long), - too closed (dips into the net)
    const reachX = Math.max(info.reachX, s.diveStart || 0);                 // a dash counts as the reach it covered (dive clip, wobbly lob)
    s.diveStart = 0;
    let tx = 0;   // set below from the launch angle
    let power = info.power;
    let depth = Math.min(13.4, lerp(4.0, 11.6, power) + Math.abs(q) * 0.4);   // forgiving: hard or mistimed hits stay on the table
    let Tover;
    let kind = 'hit';
    if (b.wob && power >= 0.7) {
      // SMASH on a wobbly ball: very fast, steep, into a corner
      kind = 'smash';
      power = 1; depth = 13.5 + Math.random() * 1.5; Tover = 0.2;
      tx = sg * (Math.abs(aimLx) < 0.25 ? (Math.random() < 0.5 ? -1 : 1) * 0.8 : Math.sign(aimLx) * 0.95) * 7.6;
    } else if (reachX >= 9) {
      // had to dive/stretch for it: a floaty, wobbly lob the opponent can smash
      kind = 'weak';
      power = 0.12; depth = 5 + Math.random() * 4; Tover = 0.72;   // low wobbly float (not a high lob)
      tx *= 0.5;
    }
    const tz = -sg * depth;
    if (kind === 'hit') {
      // the shot leaves at an ANGLE set by aim (swing direction + timing); where it lands follows from the angle and the distance, so
      // moderate angles stay on the table and only extreme ones go wide
      const L = Math.min(Math.abs(tz - b.p[2]), 30);    // capped: a ball taken from deep behind the table no longer exaggerates the angle
      tx = b.p[0] * 0.4 + sg * Math.tan(aimLx * 20 * Math.PI / 180) * L;
    } else if (kind === 'weak') tx = sg * aimLx * 7.6 * 0.5;
    const fault = kind === 'hit' && Math.abs(err) > K.SPIN_FAULT ? (err > 0 ? 'long' : 'net') : null;
    const pop = kind === 'hit' && !fault && err > 0.6;  // face left too open against topspin: a high floater the opponent can smash
    const spinUse = kind === 'weak' || pop ? 0 : Math.max(info.spin, -0.7);   // lobs and pop-ups carry no spin; backspin capped so it stays playable
    // flight-time multiplier for normal hits: the face tilt left over after meeting the spin (open = higher/slower, closed = flatter/faster)
    // and timing (PERFECT = crisper, badly mistimed = floatier). planRally keeps its reaction-time floor, so drives never outpace a smash.
    const arc = kind !== 'hit' ? 1 : (1 + K.FACE_ARC * clamp(err, -1, 1)) * (Math.abs(q) < K.PERFECT ? 0.88 : 1 + Math.max(0, Math.abs(q) - 0.6) * 0.5);
    if (fault === 'net') {                              // dips into the net: aim at the middle of the net
      const T = 0.42;
      b.v = [-b.p[0] * 0.5 / T, (K.NET_H * 0.6 - b.p[1] + 0.5 * K.G * T * T) / T, -b.p[2] / T]; b.w = [0, 0, 0];
    } else planRally(b, kind === 'hit' ? clamp(tx, -(K.HW - 0.6), K.HW - 0.6) : clamp(tx, -14, 14), fault === 'long' ? -sg * (K.HL + 4 + Math.random() * 4) : tz, power, spinUse, sg, Tover, arc);
    b.wob = kind === 'weak' || pop;
    b.smash = kind === 'smash';
    this.lastHitter = r;
    this.ballStage = 'oppBounce';
    if (s.mv) {
      s.mv.lock = 145; s.mv.home = true;
      if (reachX >= 9) { const lx = (sg > 0 ? -1 : 1) * (b.p[0] - s.x) * 0.55; s.mv.Px += lx; s.mv.Vx += lx; }   // the dive: lunge toward the ball
    }                        // stop chasing for ~90-200 updates after a stroke
    this.rallyLen++;
    this.emit({ type: kind === 'smash' ? 'smash' : 'hit', seat: r, speed: Math.hypot(...b.v), timing: q, weak: kind === 'weak', reachX, reachF, side: sw.side, spin: info.spin, tw: s.rkp ? s.rkp.a194 : 0, fault, pop });
    if (kind === 'smash') this.emit({ type: 'hit', seat: r, speed: Math.hypot(...b.v), timing: q, reachX, reachF, side: sw.side, spin: info.spin, tw: s.rkp ? s.rkp.a194 : 0 });
    this.feedback(r, { kind, timing: q, power: sw.power, err, spinIn, fault, pop });
  }

  // ---- CPU ---------------------------------------------------------------------------------
  cpuTick(i) {
    const s = this.seats[i];
    const sg = this.sg(i);
    const c = s.cpu;
    const sigma = lerp(0.055, 0.022, s.skill);
    if (this.phase === 'serve' && this.server === i) {
      if (this.serveStage === 'hold' && this.t >= c.tossAt) this.toss(i);
      else if (this.serveStage === 'toss' && this.ball.v[1] < 0 && this.ball.p[1] < 3.0 + (Math.random() * 1.6 - .8) && !(s.swing && this.t - s.swing.t < 0.3)) {
        this.registerSwing(i, { power: 0.3 + Math.random() * 0.35, side: 1, spin: Math.random() * 0.4, aim: Math.random() * 1.2 - 0.6 });
      }
      return;
    }
    if (this.phase === 'rally' && this.ballStage === 'live' && this.lastHitter !== i && this.ball.v[2] * sg > 0) {
      if (!c.planned) {
        const pr = this.predictContact(sg);
        if (pr) {
          // gaussian-ish noise
          const n = (Math.random() + Math.random() + Math.random() - 1.5) * 1.6;
          const missRoll = Math.random() < (this.ball.smash ? 0.65 : lerp(0.32, 0.09, s.skill));
          c.planned = { at: this.t + pr.t + n * sigma + (missRoll ? 0.6 : 0), x: pr.x };   // a miss swings far too late (balls carry on after the bounce now, so 0.25 s still connected)
        }
      } else if (this.t >= c.planned.at) {
        const side = (c.planned.x - s.x) * sg > 0 ? 1 : -1;   // ball on player's right -> forehand
        this.registerSwing(i, {
          power: this.ball.wob ? (Math.random() < 0.4 + 0.5 * s.skill ? 0.95 : 0.4) : lerp(0.42, 0.7, Math.random()),
          side, spin: Math.random() < 0.3 ? -0.3 - Math.random() * 0.4 : 0.1 + Math.random() * 0.8, aim: (Math.random() - 0.5) * 1.4,   // chops and loops
        });
        c.planned = null;
      }
    } else if (c.planned && this.phase !== 'rally') c.planned = null;
    else if (this.phase === 'rally' && this.lastHitter === i) c.planned = null;
  }

  // ---- snapshot for clients -----------------------------------------------------------------
  snapshot() {
    const b = this.ball;
    const snap = {
      time: this.t,
      phase: this.phase,
      msg: this.message,
      score: this.score,
      server: this.server,
      serveStage: this.serveStage,
      ball: { wob: b.wob ? 1 : 0, sm: b.smash ? 1 : 0, p: b.p.map((v) => +v.toFixed(3)), v: b.v.map((v) => +v.toFixed(2)), w: b.w.map((v) => +v.toFixed(1)), q: [+b.qx.toFixed(3), +b.qy.toFixed(3), +b.qz.toFixed(3)] },
      seats: this.seats.map((s, i) => ({ rk: s.rk ? { phone: s.rk.phone, pos: s.rk.pos.map((v) => +v.toFixed(3)), X: s.rk.cols[0].map((v) => +v.toFixed(4)), Y: s.rk.cols[1].map((v) => +v.toFixed(4)), Z: s.rk.cols[2].map((v) => +v.toFixed(4)), grip: s.rk.grip.map((v) => +v.toFixed(3)) } : null, tilt: s.tilt && this.t - s.tiltT < 1 ? s.tilt : null, fe: this.faceCue(s, i), kind: s.kind, name: s.name, hand: s.hand, x: +s.x.toFixed(3), z: +s.z.toFixed(3), vx: +s.vx.toFixed(1), vz: +s.vz.toFixed(1), online: s.online })),
      win: this.winner,
      toWin: this.pointsToWin,
      ev: this.events,
      rally: this.rallyLen,
    };
    this.events = [];
    return snap;
  }
}
