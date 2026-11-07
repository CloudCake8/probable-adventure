// Who is in the room: the two seats (phones, the PC mouse player or the CPU), spectators on the sideline chairs, the chat, and the
// spectators' waving hands. No networking here so it can be tested: out(to, msg) delivers, to = a socket, 'hosts' or 'all'.
import { SwingDetector } from './swing.js';

const CHAIRS = 24, HISTORY = 40;
const COLORS = [0xf29b2c, 0x3fbf5a, 0x9b5de5, 0xf15bb5, 0x00b8b8, 0xe9c46a, 0x8d6e63, 0x5aa9e6];   // spectators' shirts (seats are red and blue)
export const cleanName = (s, n = 14) => String(s ?? '').replace(/[\u0000-\u001f\u007f<>]/g, '').trim().slice(0, n);
const cleanId = (s) => String(s ?? '').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 8) || null;   // a screen's code, from its QR
const cleanText = (s) => String(s ?? '').replace(/[\u0000-\u001f\u007f]/g, ' ').replace(/\s+/g, ' ').trim().slice(0, 140);

export class Room {
  constructor(game, out) {
    Object.assign(this, { game, out, hosts: new Set(), pads: new Map(), seatOwner: [null, null], sids: new Map(), nextSid: 1, log: [], nextId: 1, leaving: new Map(), sent: '', armsWere: false, paused: null });
  }
  name(p) { return p.name || `Guest ${p.sid}`; }

  // ---- arriving and leaving ----
  hello(ws, m) {
    if (m.role === 'host') { this.hosts.add(ws); ws.isHost = true; ws.screen = cleanId(m.screen); ws.pairedSent = ''; this.out(ws, { t: 'welcome' }); this.greet(ws); return null; }
    const pid = String(m.pid || Math.random()).slice(0, 40);
    for (const [w, q] of this.pads) if (q.pid === pid && w !== ws) { this.pads.delete(w); q.chair = -1; }   // the same phone reconnecting replaces its old socket
    let sid = this.sids.get(pid); if (!sid) this.sids.set(pid, (sid = this.nextSid++));   // a small public id: phone ids (pid) can reclaim seats, so they stay private
    const pad = { pid, sid, ws, name: cleanName(m.name), screen: cleanId(m.screen), seat: -1, chair: -1, det: new SwingDetector(), color: COLORS[(sid - 1) % COLORS.length], arm: null, armT: 0, shake: 0, waveUntil: 0 };
    pad.det.hand = m.hand === -1 ? -1 : 1;
    this.pads.set(ws, pad);
    const owned = this.seatOwner.indexOf(pid);
    if (owned >= 0) {                        // a reconnect takes its seat back from the CPU that covered it
      const s = this.game.seats[owned];
      if (s.kind === 'cpu' || s.kind === 'human') { s.kind = 'human'; s.online = true; s.name = pad.name || s.name.replace(' (CPU)', ''); s.hand = pad.det.hand; }
      pad.seat = owned;
    } else pad.seat = this.assignSeat(pad, false);   // arriving takes an empty seat (the lobby); mid-match you sit on the sideline and can press Play
    if (pad.seat < 0) pad.chair = this.freeChair();
    this.out(ws, { t: 'seat', seat: pad.seat, sid });
    this.greet(ws);
    if (this.leaving.has(pid)) { clearTimeout(this.leaving.get(pid)); this.leaving.delete(pid); }   // back within a few seconds: no announcement
    else this.sys(`${this.name(pad)} has entered the room`);
    return pad;
  }
  greet(ws) { this.out(ws, { t: 'chatlog', list: this.log }); this.out(ws, this.roster()); }
  bye(ws) {
    this.hosts.delete(ws);
    if (ws.kbdSeat !== undefined) this.kbdLeave(ws);
    const pad = this.pads.get(ws); if (!pad) return;
    this.pads.delete(ws); this.releaseSeat(pad, false);
    const nm = this.name(pad), t = setTimeout(() => { this.leaving.delete(pad.pid); this.sys(`${nm} has left the room`); }, 8000);   // phones blip: only announce if they stay gone
    t.unref?.(); this.leaving.set(pad.pid, t);
  }

  // ---- seats: playing and watching ----
  assignSeat(pad, takeCpu = true) {          // an empty seat first, then (when asked to play) one the CPU is covering
    for (let i = 0; i < 2; i++) if (this.game.seats[i].kind === 'empty') return this.claim(pad, i);
    if (takeCpu) for (let i = 0; i < 2; i++) if (this.game.seats[i].kind === 'cpu') return this.claim(pad, i);
    return -1;
  }
  claim(pad, i) { this.seatOwner[i] = pad.pid; Object.assign(this.game.seats[i], { kind: 'human', name: pad.name || `Player ${i + 1}`, online: true, hand: pad.det.hand }); return i; }
  releaseSeat(pad, voluntary) {              // a dropped phone keeps its seat (the CPU covers until it reconnects); stepping out to watch gives it up
    const i = this.seatOwner.indexOf(pad.pid); if (i < 0) return;
    const s = this.game.seats[i]; s.online = false;
    if (this.game.phase === 'lobby') { s.kind = 'empty'; s.name = ''; this.seatOwner[i] = null; }
    else { s.kind = 'cpu'; s.skill = 0.5; s.name = voluntary ? 'CPU' : s.name + ' (CPU)'; if (voluntary) this.seatOwner[i] = null; }
  }
  setRole(pad, play) {                       // switch between playing and watching without disconnecting
    if (play && pad.seat < 0) {
      const i = this.assignSeat(pad);
      if (i < 0) { this.out(pad.ws, { t: 'note', text: 'Both seats are taken' }); return; }
      pad.seat = i; pad.chair = -1; this.sys(`${this.name(pad)} is now playing`);
    } else if (!play && pad.seat >= 0) {
      this.releaseSeat(pad, true); pad.seat = -1; pad.chair = this.freeChair(); this.sys(`${this.name(pad)} is now spectating`);
    } else return;
    this.out(pad.ws, { t: 'seat', seat: pad.seat, sid: pad.sid });
  }
  freeChair() { const used = new Set([...this.pads.values()].map((p) => p.chair)); for (let c = 0; c < CHAIRS; c++) if (!used.has(c)) return c; return -1; }
  kbdJoin(ws) {
    for (let i = 0; i < 2; i++) if (this.game.seats[i].kind === 'empty') { Object.assign(this.game.seats[i], { kind: 'human', name: 'Keyboard', online: true }); ws.kbdSeat = i; this.seatOwner[i] = 'kbd'; return; }
  }
  kbdLeave(ws) {
    const i = ws.kbdSeat; if (i === undefined) return;
    const s = this.game.seats[i]; s.online = false;
    if (this.game.phase === 'lobby') { s.kind = 'empty'; s.name = ''; } else s.kind = 'cpu';
    this.seatOwner[i] = null; ws.kbdSeat = undefined;
  }

  // ---- names: a phone and the screen it was linked to (by scanning that screen's QR) share one name, renamed from either side ----
  rename(pad, raw) {
    const name = cleanName(raw); if (!name || name === pad.name) return;
    const old = this.name(pad); pad.name = name;
    if (pad.seat >= 0) this.game.seats[pad.seat].name = name;
    this.out(pad.ws, { t: 'name', name });
    this.sys(`${old} is now known as ${name}`);
  }
  linked(ws, sid) { return [...this.pads.values()].find((p) => p.sid === sid && p.screen && p.screen === ws.screen); }   // only a phone linked to this screen
  renameFrom(ws, sid, raw) { const pad = this.linked(ws, sid); if (pad) this.rename(pad, raw); }

  // ---- pausing and ending: only the players (a seated phone, a screen linked to one, the mouse player's screen); anyone if no
  // human is playing. Resuming counts down 3 seconds so nobody is caught out. ----
  canControl(ws) {
    if (!this.game.seats.some((s) => s.kind === 'human')) return true;
    const pad = this.pads.get(ws); if (pad) return pad.seat >= 0;
    return ws.kbdSeat !== undefined || [...this.pads.values()].some((p) => p.seat >= 0 && p.screen && p.screen === ws.screen);
  }
  who(ws, fallback) {                        // a name for whoever pressed something: the phone, the screen's seated phone, or the screen's name
    const pad = this.pads.get(ws) || [...this.pads.values()].find((p) => p.seat >= 0 && p.screen && p.screen === ws.screen);
    return pad ? this.name(pad) : ws.kbdSeat !== undefined ? this.game.seats[ws.kbdSeat].name : cleanName(fallback, 16) || 'Someone';
  }
  pause(ws, name) {
    if (this.game.phase === 'lobby' || this.game.phase === 'over') return;
    if (!this.canControl(ws)) { this.out(ws, { t: 'note', text: 'Only the players can pause' }); return; }
    if (!this.paused) { this.paused = { by: this.who(ws, name), until: 0 }; this.sys(`${this.paused.by} paused the game`); }
    else this.paused.until = 0;              // pausing again stops a resume countdown
  }
  resume(ws) { if (this.paused && !this.paused.until && this.canControl(ws)) this.paused.until = Date.now() + 3000; }
  end(ws, name) {                            // true: the caller resets to the lobby
    if (!this.canControl(ws)) { this.out(ws, { t: 'note', text: 'Only the players can end the game' }); return false; }
    this.paused = null; this.sys(`${this.who(ws, name)} ended the game`); return true;
  }
  tickPause(now) { if (this.paused?.until && now >= this.paused.until) this.paused = null; return !!this.paused; }
  pauseInfo() { const p = this.paused; return p ? { by: p.by, resumeIn: p.until ? Math.max(0, p.until - Date.now()) / 1000 : null } : null; }

  // ---- kick: anyone can move an idle player to the sideline (their seat goes to the CPU mid-match), once every 10 seconds each ----
  kick(ws, seat, name) {
    const s = this.game.seats[seat], owner = this.seatOwner[seat]; if (!s || s.kind !== 'human' || !owner) return;
    const by = this.pads.get(ws); if (by && by.seat === seat) return;    // that's just Spectate
    const now = Date.now(); if (now - (ws.kickT || 0) < 10000) { this.out(ws, { t: 'note', text: 'Wait a few seconds before kicking again' }); return; }
    ws.kickT = now;
    const who = s.name, byName = this.who(ws, name);
    if (owner === 'kbd') { const h = [...this.hosts].find((x) => x.kbdSeat === seat); if (h) { this.kbdLeave(h); this.out(h, { t: 'kicked' }); } }
    else {
      const pad = [...this.pads.values()].find((p) => p.pid === owner); if (!pad) return;
      this.releaseSeat(pad, true); pad.seat = -1; pad.chair = this.freeChair();
      this.out(pad.ws, { t: 'seat', seat: -1, sid: pad.sid }); this.out(pad.ws, { t: 'note', text: `${byName} moved you to the sideline` });
    }
    this.sys(`${who} was moved to the sideline by ${byName}`);
  }

  // ---- chat ----
  chat(ws, raw, hostName, as) {             // as: a screen talks as one of its linked phones (their name, colour and bubble)
    const text = cleanText(raw); if (!text) return;
    const now = Date.now(), q = (ws.chatTimes ||= []);
    while (q.length && now - q[0] > 6000) q.shift();
    if (q.length >= 5) { this.out(ws, { t: 'note', text: 'Slow down a little' }); return; }
    q.push(now);
    const pad = this.pads.get(ws) || (ws.isHost && as ? this.linked(ws, as) : null);
    this.post({ name: pad ? this.name(pad) : cleanName(hostName, 16) || 'Host', text, seat: pad ? pad.seat : ws.kbdSeat ?? -1, sid: pad && pad.seat < 0 ? pad.sid : 0, color: pad ? pad.color : 0x2e9d3a });
  }
  sys(text) { this.post({ sys: true, name: 'OnlineHost', text: `*** ${text} ***` }); }
  post(m) { const msg = { t: 'chat', id: this.nextId++, ts: Date.now(), ...m }; this.log.push(msg); if (this.log.length > HISTORY) this.log.shift(); this.out('all', msg); }

  // ---- spectators' hands: where the phone's top edge points (x right, y toward the screen, z up) and how hard it shakes ----
  motion(pad, m) {
    if (Array.isArray(m.yv) && m.yv.length === 3) { pad.arm = m.yv.map((v) => Math.max(-1, Math.min(1, Number(v) || 0))); pad.armT = Date.now(); }
    pad.shake += (Math.min(1, Math.hypot(Number(m.ax) || 0, Number(m.az) || 0) / 20) - pad.shake) * 0.15;
  }
  wave(pad) { pad.waveUntil = Date.now() + 2500; }
  arms() {                                   // [sid, x, y, z, wave 0..1] per moving spectator, ~15 times a second, to the screens
    const now = Date.now(), a = [];
    for (const p of this.pads.values()) {
      if (p.seat >= 0 || p.chair < 0) continue;
      const live = p.arm && now - p.armT < 1500, waving = now < p.waveUntil;
      if (live || waving) a.push([p.sid, ...(live ? p.arm : [0, 0, 1]), +Math.max(live ? p.shake : 0, waving ? 1 : 0).toFixed(2)]);
    }
    if (a.length || this.armsWere) this.out('hosts', { t: 'arms', a });
    this.armsWere = a.length > 0;
  }

  // ---- who is here ----
  roster() {
    return {
      t: 'roster', screens: this.hosts.size,
      players: this.game.seats.map((s, i) => ({ seat: i, name: s.name, kind: s.kind, online: s.online })),
      specs: [...this.pads.values()].filter((p) => p.seat < 0).map((p) => ({ sid: p.sid, name: this.name(p), chair: p.chair, hand: p.det.hand, color: p.color })),
    };
  }
  syncRoster() {
    const r = this.roster(), s = JSON.stringify(r); if (s !== this.sent) { this.sent = s; this.out('all', r); }
    for (const h of this.hosts) {            // each screen hears only about its own phones, so screen codes stay private
      const phones = [...this.pads.values()].filter((p) => p.screen && p.screen === h.screen).map((p) => ({ sid: p.sid, name: this.name(p), seat: p.seat, color: p.color }));
      const j = JSON.stringify(phones); if (j !== h.pairedSent) { h.pairedSent = j; this.out(h, { t: 'paired', phones }); }
      const c = { t: 'ctl', can: this.canControl(h), kbd: h.kbdSeat ?? -1 }, cj = JSON.stringify(c);   // may this screen pause / end, and its mouse player's seat
      if (cj !== h.ctlSent) { h.ctlSent = cj; this.out(h, c); }
    }
    for (const p of this.pads.values()) {    // and each phone whether its screen is there
      const on = !!p.screen && [...this.hosts].some((h) => h.screen === p.screen);
      if (on !== p.linkOn) { p.linkOn = on; this.out(p.ws, { t: 'link', screen: p.screen, on }); }
    }
  }
}
