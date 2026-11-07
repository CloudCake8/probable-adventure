// Swing recognition from phone motion samples.
//
// The phone converts its sensors into a calibrated frame before sending:
//   ax = to the player's right, ay = forward (toward the screen), az = up   (m/s^2, gravity removed)
//   yaw = how far the phone is pointing right of the calibrated forward direction (degrees)
//   ts  = sample time in ms (phone clock)
// Recognition is a small state machine: wait for a burst of acceleration, follow it until the
// burst peaks, then commit the swing immediately (so latency stays at ~1-3 samples after the
// peak) and ignore input for a short refractory time.

const START_A = 20;       // m/s^2 to begin a swing
const END_A = 9;
const TOSS_A = 10;        // much gentler threshold while the ball is waiting in hand
const COOLDOWN = 0.38;    // s
const MAX_SWING = 0.32;   // s

export class SwingDetector {
  constructor() { this.reset(); this.hand = 1; }

  reset() {
    this.state = 'idle';
    this.cool = 0;
    this.peak = 0; this.peakT = 0;
    this.sum = [0, 0, 0];
    this.t0 = 0; this.last = 0;
    this.yawAtPeak = 0;
    this.fallCount = 0;
    this.lowCount = 0;
  }

  // returns null | {kind:'swing', power, side, spin, aim, mag} | {kind:'toss'}
  push(s, mode) {
    const t = s.ts / 1000;
    const dt = this.last ? Math.min(Math.max(t - this.last, 0.001), 0.05) : 1 / 60;
    this.last = t;
    this.cool -= dt;
    const a = Math.hypot(s.ax, s.ay, s.az);

    if (this.state === 'idle') {
      if (this.cool > 0 || a < (mode === 'toss' ? TOSS_A : START_A)) return null;
      this.state = 'swing';
      this.t0 = t; this.peak = a; this.peakT = t;
      this.sum = [s.ax * dt, s.ay * dt, s.az * dt];
      this.yawAtPeak = s.yaw;
      this.fallCount = 0; this.lowCount = 0;
      return null;
    }

    // following a burst
    if (a >= this.peak) {
      this.peak = a; this.peakT = t; this.yawAtPeak = s.yaw;
      this.fallCount = 0;
      this.sum[0] += s.ax * dt; this.sum[1] += s.ay * dt; this.sum[2] += s.az * dt;
    } else {
      this.fallCount++;
      // keep integrating a little around the peak for direction stability
      if (this.fallCount <= 1) { this.sum[0] += s.ax * dt; this.sum[1] += s.ay * dt; this.sum[2] += s.az * dt; }
    }
    const peaked = this.fallCount >= 2 && a < this.peak * 0.8;
    this.lowCount = a < (mode === 'toss' ? 5 : END_A) ? this.lowCount + 1 : 0;
    if (peaked || this.lowCount >= 2 || t - this.t0 > MAX_SWING) {
      const res = this.finish(mode);
      this.state = 'idle';
      this.cool = COOLDOWN;
      return res;
    }
    return null;
  }

  finish(mode) {
    const [vx, vy, vz] = this.sum;
    const sp = Math.hypot(vx, vy, vz) || 1e-6;
    // While the ball is in hand any deliberate flick tosses it (up or down, so a flipped sensor axis cannot break serving)
    if (mode === 'toss') return this.peak >= TOSS_A ? { kind: 'toss' } : null;
    if (this.peak < START_A + 1) return null;
    const power = clamp(0.25 + (this.peak - START_A) / 30, 0.2, 1);
    // forehand for a right-hander is a right-to-left swing (negative x velocity)
    const side = (vx * this.hand) <= 0 ? 1 : -1;
    // brushing upward at contact = topspin, downward = backspin
    const spin = clamp((vz / sp) * 1.6 + 0.15, -1, 1);
    const aim = clamp(this.yawAtPeak / 30, -1, 1);
    return { kind: 'swing', power, side, spin, aim, lat: clamp(vx / sp, -1, 1), mag: this.peak, peakTs: this.peakT * 1000 };   // peakTs: phone clock (ms) of the peak, for lag compensation
  }
}

function clamp(v, a, b) { return Math.min(b, Math.max(a, v)); }
