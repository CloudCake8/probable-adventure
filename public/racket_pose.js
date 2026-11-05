// Wii Sports Resort Table Tennis: racket pose generator, JS port of the recovered game code.
// Frame (canonical player frame, same as the game's pose/anchor space): +x = player's LEFT, +y = up, +z = toward the opponent/net.
// Far-side player: rotate the final result 180 deg about world Y (the game mirrors (x,y,z)->(-x,y,-z), Participant+0x28).
// Source: adapter update 0x80467b4c, pivot 0x80466cf8, pitch remap 0x80325228, PostUpdate 0x8045c800.
// Verified against the interpreted original (tools_racket/verify*.py) to <1e-3.
const D2R = Math.PI / 180, R2D = 180 / Math.PI;
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const clamp = (x, lo, hi) => (x < lo ? lo : x > hi ? hi : x);
const ease = (t) => 0.5 - 0.5 * Math.cos(Math.PI * t);                 // 0x80326180(t,1)
function softPitch(x) {                                                 // 0x80325228(x,60,90,70): Hermite 60..70 above 60 deg
  if (x <= 60) return x;
  const u = Math.min(1, (x - 60) / 30);
  return 60 + 10 * (0.1 * u + 2.8 * u * u - 1.9 * u * u * u);
}
const vm = (v, M) => [0, 1, 2].map((j) => v[0] * M[0][j] + v[1] * M[1][j] + v[2] * M[2][j]); // row-vector * 3x3 (0x80327114)
const mmul = (A, B) => [0, 1, 2].map((i) => [0, 1, 2].map((j) => A[i][0] * B[0][j] + A[i][1] * B[1][j] + A[i][2] * B[2][j]));
const ID3 = () => [[1, 0, 0], [0, 1, 0], [0, 0, 1]];

// ---- Wii Remote heading filter (0x804588ac + 0x804589e8 tail): feeds adapter+0xc4 -------------------
class RemoteHeading {
  constructor() { this.H = 0; this.Hs = 0; }
  update(row2) {                    // row2 = remote pointing direction in the canonical frame (m20,m21,m22)
    const len = Math.hypot(row2[0], row2[2]);
    let hd = 0;
    if (len > 0) { hd = Math.acos(clamp(row2[2] / len, -1, 1)) * R2D; if (row2[0] < 0) hd = -hd; }
    let d = hd - this.H;
    if (d > 180) d -= 360; else if (d < -180) d += 360;
    this.H += d;
    if (this.H > 240) this.H -= 360; else if (this.H < -240) this.H += 360;
    this.Hs += clamp(0.5 * (this.H - this.Hs), -20, 20);               // 0x1c0 low-pass, +-20 deg/tick
    return this.Hs;
  }
}

class RacketPose {
  constructor(lefty = false) {
    this.lefty = lefty;
    this.prevRow2 = [0, 0, 1];
    this.acc = [0, 0, 0];                      // adapter+0x198..0x1a0
    this.yaw = 0; this.y17c = 0; this.y178 = 0; this.y16c = 0; this.y180 = 1;
    this.a188 = 0; this.a184 = 0; this.a18c = 0; this.a194 = 0;
    this.swing = 0; this.hand = 0; this.lim = 0; this.cnt = 0;
  }
  bounds() { return this.lefty ? [-130, 145] : [-145, 130]; }
  // hand: 1 = forehand, 0 = backhand (OnSwing arg, 0x80465ab8). cnt = 0x1a8 (45 or 75 ticks).
  startSwing(hand, cnt = 45) { this.swing = 2; this.hand = hand; this.lim = hand === 1 ? 30 : -30; this.cnt = cnt; this.a188 = 0; this.a184 = 0; }
  /**
   * row2: remote pointing direction (unit, canonical frame); twistDeg: roll of the remote about row2 since last tick (deg, right-handed);
   * hs: RemoteHeading.update() result; active: Participant.swingCounter >= 0 (ball live);
   * chest: animated chest-bone position relative to avatar root, or null; pose: {rows:3x3 body basis (rows = body axes), pos:[x,y,z]}.
   */
  tick(row2, twistDeg, hs, active, chest = null, pose = null) {
    const [lo, hi] = this.bounds();
    const c = cross(this.prevRow2, row2);
    const L = Math.hypot(c[0], c[1], c[2]);
    let rv = c;
    if (L > 0) { const Lc = Math.min(1, L); const k = Math.asin(Lc) * R2D / Lc; rv = c.map((x) => x * k); }
    this.acc = this.acc.map((a, i) => a + 0.5 * (rv[i] - a));
    const f31 = twistDeg;
    let f30 = Math.hypot(rv[0], rv[2]);
    if (cross([this.acc[0], 0, this.acc[2]], row2)[1] < 0) f30 = -f30;
    const yaw0 = this.yaw;
    if (this.swing === 0) {
      if (active) {
        this.y17c += this.acc[1] * 1.3; this.yaw = clamp(this.y17c, lo, hi);
        this.y16c = this.yaw - yaw0; this.y178 = this.yaw; this.y180 = 0;
      } else {
        const tgt = clamp(hs * 1.3, lo, hi);
        if (this.y16c >= 0) { this.y16c -= 0.4; if (this.y16c < 0) this.y16c = 0; }
        else { this.y16c += 0.4; if (this.y16c > 0) this.y16c = 0; }
        this.y178 = clamp(this.y178 + this.y16c, lo, hi);
        this.y180 = clamp(this.y180 + 0.015, 0, 1);
        this.yaw = this.y178 + ease(this.y180) * (tgt - this.y178); this.y17c = this.yaw;
      }
      this.a18c *= 0.99;
      this.a194 = clamp(0.015 * f31 + 0.996 * this.a194, -1, 1);
    } else {
      this.yaw += this.acc[1] * 1.05;
      this.yaw = this.hand === 0 ? clamp(this.yaw, this.lim, hi) : clamp(this.yaw, lo, this.lim);
      this.y17c = this.yaw; this.y16c = this.yaw - yaw0; this.y178 = this.yaw; this.y180 = 0;
      this.a188 += f31; this.a184 += f30;
      this.a18c = this.a18c + 0.1 * (this.a188 - this.a18c);
      this.a194 *= 0.98;
      if (--this.cnt <= 0) this.swing = 0;
    }
    this.prevRow2 = row2.slice();
    const pitch = softPitch(Math.asin(clamp(row2[1], -1, 1)) * R2D);
    const A = this.yaw * D2R, B = pitch * D2R;
    const s1 = Math.sin(A), c1 = Math.cos(A), s2 = Math.sin(B), c2 = Math.cos(B);
    const M = [[s1 * s2, -c2, c1 * s2], [c1, 0, -s1], [s1 * c2, s2, c1 * c2]];       // 0x80466f5c
    const th = (this.a194 * 45 + this.a18c) * D2R, ct = Math.cos(th), st = Math.sin(th);
    const R = [[0, 1, 2].map((j) => ct * M[0][j] + st * M[1][j]), [0, 1, 2].map((j) => -st * M[0][j] + ct * M[1][j]), M[2].slice()];
    // pivot 0x80466cf8
    let f = clamp((90 + this.yaw) / 180, 0, 1);
    if (this.lefty) f = 1 - f;
    const Av = [-1, 1.1, 4], Bv0 = [-0.5, 1.4, 0.3];
    const Bv = [0, 1, 2].map((i) => Bv0[i] + (Av[i] - Bv0[i]) * f);
    if (this.lefty) Bv[0] = -Bv[0];
    let sh = [0, 4.6, 0];
    if (chest) sh = sh.map((v, i) => v + (chest[i] - v) * 0.5);             // assist=0
    const grip = [0, 1, 2].map((i) => sh[i] + Bv[i]);
    const ext = 6.2 + f * (3.8 - 6.2);
    const pivot = [0, 1, 2].map((i) => grip[i] + R[2][i] * ext);
    const P = pose ? pose.rows : ID3(), pp = pose ? pose.pos : [0, 0, 0];
    const pivW = vm(pivot, P).map((v, i) => v + pp[i]);
    const gripW = vm(grip, P).map((v, i) => v + pp[i]);
    const rows = mmul(R, P);
    return { pivot: pivW, grip: gripW, rows, yaw: this.yaw, pitch };
  }
  // PostUpdate 0x8045c800: model node pose. cols = [X', Y', Z'] of the racket mesh (mesh: thin axis X, blade width Y, handle along +Z).
  model(out) {
    let [b0, b1, b2] = out.rows;
    if (this.lefty) { b0 = b0.map((v) => -v); b1 = b1.map((v) => -v); }     // 180 deg about Z': other face / mirrored side
    const X = b1, Y = b0.map((v) => -v), Z = b2;
    const pos = out.pivot.map((v, i) => v - 2.4 * b2[i]);                    // mesh origin 2.4 behind the blade centre
    return { pos, cols: [X, Y, Z] };            // rotation matrix with these as COLUMNS (mesh-local x,y,z -> canonical frame)
  }
}
function mat3ToQuat(cols) {                      // cols = [X,Y,Z] columns -> unit quaternion [x,y,z,w]
  const m00 = cols[0][0], m10 = cols[0][1], m20 = cols[0][2], m01 = cols[1][0], m11 = cols[1][1], m21 = cols[1][2], m02 = cols[2][0], m12 = cols[2][1], m22 = cols[2][2];
  const tr = m00 + m11 + m22; let x, y, z, w;
  if (tr > 0) { const s = Math.sqrt(tr + 1) * 2; w = s / 4; x = (m21 - m12) / s; y = (m02 - m20) / s; z = (m10 - m01) / s; }
  else if (m00 > m11 && m00 > m22) { const s = Math.sqrt(1 + m00 - m11 - m22) * 2; w = (m21 - m12) / s; x = s / 4; y = (m01 + m10) / s; z = (m02 + m20) / s; }
  else if (m11 > m22) { const s = Math.sqrt(1 + m11 - m00 - m22) * 2; w = (m02 - m20) / s; x = (m01 + m10) / s; y = s / 4; z = (m12 + m21) / s; }
  else { const s = Math.sqrt(1 + m22 - m00 - m11) * 2; w = (m10 - m01) / s; x = (m02 + m20) / s; y = (m12 + m21) / s; z = s / 4; }
  return [x, y, z, w];
}
export { RacketPose, RemoteHeading, mat3ToQuat, softPitch, ease };
