# Wii Sports Resort Table Tennis - player animation state machine (USA Rev 1 main.dol)

Binary: `assets/code/original/main.dol` (USA Rev 1). All addresses are virtual. Evidence = PPC disassembly via
`pingpong/tools/ppc_probe.py` (read-only) plus helper scripts in `resortcompiled/research/tools_animation/`
(`d.sh` compact dump, `memop.py` field load/store finder, `funcs.py`, `calltargets.py`, `chr0_analyze.py`, `hand_speed.py`,
`chr0_summary.json`). Labels: **RECOVERED** = directly read in instructions/data; **INFERRED** = reasoned from structure;
**UNKNOWN** = not resolved. The PAL/MKW `MAP.txt` only names MKW engine functions, it was not useful for game classes.

## 1. Object model (RECOVERED)

| Object | Ctor / vtable | Notes |
|---|---|---|
| Scene (match) | ctor 0x80460fe8, vtbl 0x806d9d98 | owns 2 Participants (+0x10,+0x14) and up to 5 avatars (+0x18..) |
| Participant | ctor 0x80460724, vtbl 0x806d9d64 | +0x80 racket/body object (0x480 B, ctor 0x80474760), +0x84 avatar, +0x88 input adapter (0x6d4 B, ctor 0x80468cc0), +0xbc current mode, +0xc0 mode index, +0xc4/+0xc8 mode objects, +0xd4 controller (human 0x80469a20 / CPU 0x8047d634 / 3rd 0x8048329c) |
| Avatar ("png_ava") | ctor 0x8045d650, vtbl 0x806d9d30 (no virtual API), per-model setup 0x8045d17c | +8 Participant, +0x1c AnimPlayer (0x208 B, ctor 0x8036d850), +0x2ec AnimSet, +0x184 STATE, +0x188.. 8 blend layers of 0x2c bytes, +0x2f4 left-handed flag, +0x2f0 effect "WS2_png_rollcatch" |
| Mode A (serve/play) | ctor 0x80464fd8, vtbl 0x806d9e70 | base class ctor 0x80461c48. +0xc pos, +0x18 per-tick displacement (vel), +0x24 basis, +0x4c/+0x50 reach, +0x54 flag, +0x88 F/B pose weight, +0x330 hit countdown |
| Mode B | ctor 0x8047bc34, vtbl 0x806daac8 | swing virtuals are `blr` stubs; chosen by scene state machine (callers 0x8047fa64, 0x80480dcc, 0x804815c4, 0x80481954) |

Participant+0x18 ("rally flag", set in `0x804601b0` StartPoint): 0 if this participant is the server (`scene+0x17c`->+0x10 == participant id) and the
serve is not yet hit; 1 otherwise; `OnBallHit` 0x8045e3f8 sets 0 -> 1 when the server's serve is hit. The same flag selects serve vs rally clips and the
swing window (see section 8).

## 2. Clip table (RECOVERED)

Prefix string `WS2_png_ava_` at 0x8067f4c8 (pointer at 0x806f1ed0 = r13-0x6250). Name pointer table at **0x806d9c20** (20 entries, read in the
avatar setup 0x8045d17c at 0x8045d238; each is formatted `"%s%s"` = prefix+suffix at 0x8045d268 and registered by 0x8036e2dc into the AnimSet, index = table index):

| id | suffix | CHR0 frames / loop | blend-in rate (fade += rate per tick) |
|---|---|---|---|
| 0 | wait | 40 / loop | 0.08 (806f1ed4) -> 12.5 ticks |
| 1 | fore | 21 / once | 0.10 (806f1ed8) |
| 2 | back | 21 / once | 0.10 |
| 3 | fore_SP | 36 / once | 0.10 (806f1edc) |
| 4 | back_SP | 36 / once | 0.10 |
| 5 | front | 31 / once | 0.10 (806f1ee0) |
| 6 | fore_SP2 | 46 / once | 0.10 |
| 7 | back_SP2 | 46 / once | 0.10 |
| 8 | fore_SP3 | 61 / once | 0.10 |
| 9 | back_SP3 | 61 / once | 0.10 |
| 10 | walk | 30 / loop | 0.10 (806f1ee4) |
| 11/12 | servewait_F/_B | 40 / loop | 0.10 (806f1ee8), **1.0 (instant) if SetState sub!=0** |
| 13/14 | toss_F/_B | 14 / once | 0.25 (806f1eec) |
| 15/16 | tosswait_F/_B | 40 / loop | 1.0 (806f1ef0) |
| 17/18 | serve_F/_B | 21 / once | 0.10 (806f1ef4) |
| 19 | waitLose | 60 / loop | 1.0 (806f1ef8) |

Blend rate function: **0x8045bdb0(this, newAnimId, prevAnimId, sub)** (jump table 0x806d9c98). Frame counts/loop flags are read from the
AnimSet resource (`0x8036e1e8` -> res+0 frame count, `0x8036e1fc` -> res+8 loop flag) and match the CHR0 JSONs.

Left-handers (`avatar+0x2f4`, set in the ctor from `0x8027b258(player,0)`==2 or the caller arg): `0x8045be2c` swaps fore<->back ids
(1<->2, 3<->4, 6<->7, 8<->9; ids >9 and 0/5 unchanged, jump table 0x806d9ce8) and the whole model/racket/hand matrices are mirrored
(negations in 0x8045c800). Same clips are used, mirrored.

## 3. STATE machine (avatar+0x184) (RECOVERED)

States: 0 idle, 1 forehand swing, 2 backhand swing, 3 walk, 4 toss, 5 tosswait, 6 toss-reverse, 7 lose.
`SetState(this, state, sub)` = **0x8045c0a8**. State -> clips (`0x8045be9c`, jump table 0x806d9d10):

| state | participant+0x18 == 0 (server, pre-serve/serve) | participant+0x18 != 0 (rally/receiver) |
|---|---|---|
| 0 | layer A = servewait_B(12), layer B = servewait_F(11), weight w (see s5) | wait(0) only |
| 1 (fore) | serve_F(17) (sub ignored) | sub0 fore(1); sub1 fore_SP(3); sub2 front(5); sub3 fore_SP2(6); sub4 fore_SP3(8) |
| 2 (back) | serve_B(18) | sub0 back(2); sub1 back_SP(4); sub2 front(5); sub3 back_SP2(7); sub4 back_SP3(9) |
| 3 walk | walk(10) | walk(10) |
| 4 toss | A=toss_B(14), B=toss_F(13) | same |
| 5 tosswait | A=tosswait_B(16), B=tosswait_F(15) | same |
| 6 | as 4 but plays reversed (start=length, rate -1 each tick) | same |
| 7 lose | waitLose(19) | same |

"A/B" pairs are two clips cross-weighted with `w` (layer +8): clip A=_B gets weight w, clip B=_F gets 1-w. For pairs `w` is refreshed every
tick from `Participant.mode+0x88` (0x8045eaa8) - see section 5. For everything else w=1.

SetState details (0x8045c0a8): shifts the 8 layers down (layer k copies layer k-1; 0x2c bytes: animA +0, animB +4, w +8, Timer +0xc..+0x1f, fade +0x20, fadeRate +0x24),
writes the new layer 0: timer = `Timer{cur=start, len=frameCount, rate=1.0, loop=resLoopFlag}` (init 0x803467d4; start = len for state 6, else 0),
fade = 0, fadeRate = bdb0(...), `avatar+0x2e8` (tick counter) is reset in the update. For sub==4 (SP3) it additionally starts the
`WS2_png_rollcatch` effect (`0x8023e91c(avatar+0x2f0)`) + a sound event (`0x803675a8`). Gate `avatar+0x190`=1.0 default.

Per-tick update (**0x8045c37c**, called from avatar Update 0x8045cd80; speed = |(vx,vz)| of `mode+0x18` via 0x8045f3a4 = displacement per tick):
```
tick counter++
if state==1 or 2: if Timer.isDone() -> SetState(0, 0)
if state==0: if participant.rallyFlag!=0 and speed >= 0.006 -> SetState(3,0)           # 3b c4 9b a6 = 0.006 (806fee90)
if state==3: if speed <= 0.004 -> SetState(0,0); else timer.rate = 35.0*speed           # 3b83126e = 0.004 (806fee94), 35.0 (806fee98)
if state==4: if done -> SetState(5,0)
if state==6: timer.rate = -1.0; if done -> SetState(0,0)
(state 5 and 7 persist)
```
`Timer.isDone()` (0x803466e8): non-looping: `cur >= len-1` (rate>=0) or `cur==0` (rate<0). Timer tick (0x80346748): `cur += rate`; non-loop clamps to
[0, len-1]; loop: if `cur > len` -> `cur -= len` (wraps at len, not len-1), if `cur<0` -> `cur += len`. **One tick = one clip frame at rate 1**,
so fore/back last 20 ticks (frames 0..20), SP 35, SP2 45, SP3 60, serve 20; blend-out to idle then takes 10-12.5 ticks.
Only layer 0's timer advances; older layers keep their last frame while fading out (only layer 0 timer is ticked at 0x8045c610).

Layer weights (0x8045c250, per tick): `remaining=1; for k in 0..7: fade_k=min(1,fade_k+rate_k); wk=remaining*fade_k; remaining-=wk;
apply(animA_k, frame_k, wk*w_k); if (1-w_k)>0: apply(animB_k, frame_k, wk*(1-w_k)); if remaining<=0 break`. Weights go to the AnimSet via `0x8036dce0`.
`SetState` is invoked again for every new swing even if the same clip is already playing (restarts from frame 0).

Static xref result (calls scan of the whole DOL + data pointer scan): the only direct callers of SetState are the six internal sites above, the
swing starter 0x8045af3c (states 1/2), the thunk 0x8045cde4 (state 0, called by Participant StartPoint 0x804601b0) and 0x8045aedc (state 7).
**No code enters states 4/6 (and therefore 5)**: toss/tosswait clips appear unused in Table Tennis in this build (INFERRED: dead data; no
dynamic call found, but a computed call cannot be fully excluded). Serve = servewait -> (swing) -> serve_F/serve_B clip directly.

## 4. Swing clip selection (RECOVERED)

Participant tick `0x8045fdb4`: when a swing is queued and counter `Participant+0x6c` (frames since trigger, starts 0 when the controller's swing flag
fires while the ball is live and the avatar `canSwing`) is **> 10** (const 806f1f54 = 10), it calls `OnSwing` **0x8045e554(this, hand)** with
`hand = controller.vfunc0x28()` (human: remote-class +0x9c: 1 -> 0 (backhand), 2 -> 1 (forehand), else 1; `0x804692bc`). `OnSwing` evaluates the swing record
(0x80465ab8), runs the mode swing virtual (A: 0x80462d48 zeroes mode+0x4c/+0x50/+0x54 then fills them), then calls **StartSwing 0x8045af3c(avatar, hand, mode+0x54, f1, f2)**:
f1 = `mode+0x4c * ctrl.scale`, f2 = `mode+0x50 * ctrl.scale` (ctrl.scale = vfunc 0x68 = 1.0 for human 0x8045e64c).
Mode A's swing virtual (0x80462d48) first calls the base reach evaluator `0x80461eac` (call at 0x80462d80), which computes
from predicted ball position (frame +40: `0x8046a47c(ball,0x28)`) relative to the player basis: `+0x4c = |lateral reach|`, `+0x50 = forward reach`, `+0x54 = result of 0x80461d08`.

```
sub = 0
if +0x54 == 0 and f1 >= 13.0:  sub = 4            # SP3  (806f1efc)
elif +0x54 == 0 and f1 >=  9.0: sub = 3            # SP2  (806f1f00)
elif f1 >= 6.0:                  sub = 1            # SP   (806f1f04)
elif f2 >= 8.0:                  sub = 2            # front (806f1f08)
SetState(hand==1 ? 1 : 2, sub)
if sub==4: voice/effort sound events 0x3d7, 0x3e1, plus 0x3e9/0x3ef by player gender
```
Meaning (INFERRED from the reach quantity): **SP / SP2 / SP3 = progressively wider lateral stretch/lunge returns (6 / 9 / 13 world units off the
player's default line), `front` = ball far in front (>=8 forward)**; SP3 plays the rollcatch effect (dive). `+0x54` (0x80461d08) blocks SP2/SP3 when non-zero (exact meaning UNKNOWN).
During the swing mode A also moves the player toward the ball (`+0x2c4/+0x2c8/+0x2cc` lunge vector, 0.25/0.08/0.13/0.12 factors); movement during
swings is not animation root motion (all CHR0 roots are in place, skl_root drift <= 0.5 units).

SP hold (RECOVERED structure): in the update 0x8045c538..: if layer0 animA in 3..7 (fore_SP, back_SP, front, fore_SP2, back_SP2) the clip rate ramps
`rate -= 0.25` (floor 0) while `mode.vfunc0x40()` is true and `cur >= 12.0` (806fee a0), else `rate += 0.25` (cap 1.0). For mode A vfunc0x40 =
`mode+0x330 == 0` (0x804650f0); `+0x330` is set to 10 at the contact handler (0x80463364) and counts down 1/tick (0x80463d8c).
=> the stretch swing **freezes at frame >= 12 until a ball-contact event, then resumes** (INFERRED link to ball contact; fore/back/SP3 do not hold).

Cooldown (RECOVERED): a new swing may start only if `!(Participant+0x1c & 2)` and avatar `state==0` and `tickCounter >= int(1/0.1)+1 = 11` (0x8045aef0, 0x8045e814/0x8045e858).
So the avatar must be idle ≥ 11 ticks after the last SetState (a walking avatar, state 3, cannot trigger a swing).

## 5. F/B (forehand/backhand side) pose blend while waiting to serve (RECOVERED)

Avatar update refreshes `layer.w = Participant.mode+0x88` (0x8045eaa8) for animA in 11..16. In mode A (serve update, 0x80464954 init; per-tick body near 0x80464150..0x80464300),
when `Participant+0x18==0`:
```
yaw = adapter+0x170                                  # accumulated Wii Remote yaw/orientation degrees, clamp [-130,145] (lefty swapped) (0x80467e24..)
if lefty: yaw = -yaw
target = clamp((yaw + 100)/200, 0, 1)                # constants -100/100 (806f1fc0/806f1fbc)
slew += 0.0004; slew = min(slew, 0.005)              # 806f1fb0, 806f1fb4
d = 0.05*(target - w); d = clamp(d, -slew, +slew); w += d      # 806f1fb8 = 0.05; |d| is also stored back to slew when not clamped
mode+0x88 = w
```
w=0 -> servewait_F (forehand-side pose), w=1 -> servewait_B. So **while waiting to serve, the body pose follows the Wii Remote's horizontal yaw**
by cross-fading between the F and B variants (never a swing needed). For the receiver there is no such blend (wait clip only).

## 6. Procedural overlay: racket / hand following the remote (RECOVERED data flow, INFERRED blending)

1. Remote sample -> orientation matrix: `0x804589e8` loops over buffered samples (`0x8037c0dc(ctr,i)`, count at ctr+0x93c) and copies each sample's 3x3
   orientation (sample+0x50..0x70) into remote+0x30..0x50 and position into +0xc. This is the SDK/MotionPlus-fused orientation: no IK.
2. Human controller `0x8046933c` copies remote+0x30..0x50 to controller+0xc..0x2c (called every tick), computes two scalars +0x1c4/+0x1c8 (swing readiness for
   forehand/backhand; in serve phase from yaw: `(yaw+60)/120`, with 0.8/-1 limits).
3. Participant sync `0x8045f498`: copies controller/adapter vectors into the racket object (+0x80): pivot (+0x40), orientation basis (+0x4c..+0x6c), player pose (+0x10,+0x1c..),
   feeds 7 animated bone matrices (table at 0x8067f438 = bones [19 head, 2 chest, 21 hip, 6 wrist_l, 14 wrist_r, 24 ankle_l, 27 ankle_r], via 0x8045c644),
   and copies avatar gates `avatar+0xd0..0xe4` into `racket+0x374..0x388` (0x8045f818..0x8045f86c); `racket+0x464 = adapter+0x170` (yaw). Then runs the racket tick `0x804732d8`.
4. At the end of the sync (0x8045f990..0x8045f9fc): `avatar+0x6c = racket+0x40` (racket pivot), `avatar+0x78/0x84/0x90 = racket+0x4c/0x58/0x64` (basis rows).
   Avatar PostUpdate **0x8045c800** builds the racket model (`avatar+0x28`) from those: translation = pivot + basis*const (0,0,-2.4) (806835 50 constants set by 0x8045d954;
   second constant (0.9,0.1,0.5)), rotation from the basis rows. Hand models (`+0x20` left, `+0x24` right) and head attachment (`+0x14`) take bone matrices 6, 14, 19 from the
   AnimPlayer (`0x8036d140`) with a 0.15*/-0.3* offset for the head. Lefty mirroring = negating X components of these.
   => **The visible racket is a rigid body whose orientation is the remote orientation matrix every tick (idle, walking, waiting, swinging); the animated arm only supplies hand/arm bones and blends in via the gates.**
5. Gates (avatar+0xd0..0xe4, computed in 0x8045bc5c, bb84, ba5c, b96c, b894, b7ac every tick from layer0 animA and its timer; initial values d8=1.0, others 0):

| gate | fn | rise/fall per tick | active condition (animA = layer0 animA, f = timer.cur) |
|---|---|---|---|
| d0 | 0x8045bc5c | +0.2 / -0.2 | animA in {6,7}: f >= 10; animA in {8,9}: 10 <= f <= 45 |
| d4 | 0x8045bb84 | +0.2 / -0.2 | animA in {8,9} and 10 <= f <= 45 |
| d8 | 0x8045ba5c | +0.05 / -0.10 | `Participant.modeIndex==1`: held 1.0. Else target 1 if: animA<0 or animA>=19; animA 3,4,5 and f<26; 6,7 and f<40; 8,9 and f<44. Target 0 for animA 0,1,2 and 10..18 |
| dc | 0x8045b96c | +0.2 / -0.2 | animA in {8,9}, 10<=f<=45; animA==19 -> forced 1.0 |
| e0 | 0x8045b894 | +0.2 / -0.2 | animA in {8,9}, 10<=f<=45 |
| e4 | 0x8045b7ac | +0.2 / -0.2 | animA in {8,9}, 10<=f<=45; animA==19 -> forced 1.0 |

   Consumers in the racket tick (INFERRED from use as lerp factors `ps_madds0 (b-a)*g+a`, `(1-g)*...`): d0 (0x374) scales a z-offset term `(1-g)*mode+0x48`; d4 (0x378)
   `(1-(1-0x42c)*(1-g))` factor for a position blend; d8 (0x37c) used in racket pose weight (x0.5*(1-g)); dc (0x380) lerp of a vector; e0 (0x384) lerp factor (only when `racket+0x3a0`!=0);
   e4 (0x388) scales a rotation angle `(1-g)*0.15*...`. They blend the racket pose between the remote-driven pose and the clip-driven (bone) pose around the
   hit portion of SP2/SP3 and the SP clips; plain fore/back/idle/walk use the remote pose (g = 0 except d8).
6. Racket tick also adds a tilt/sway overlay: rotation about the horizontal movement axis by `4*s`, `2*s`, `6*s` "turns/256" (0x3f360b61) with `s` low-passed 0.15 per tick towards |lateral vector| (0x804738f4..0x80473980).
7. In clips without right-arm animation tracks the right arm is a constant pose: `wait, walk, front, servewait_F/B, toss*, tosswait*` (arm_r1/arm_r2/wrist_r are `const` in the CHR0). Right arm is
   animated in `fore, back, *_SP*, serve_F/B, waitLose`.

## 7. CHR0 analysis (scripts: chr0_analyze.py, hand_speed.py; raw: chr0_summary.json)

Skeleton (GLB `models_animated/Stage/PngScene/Common/G3D/WS2_png_ava__WS2_avaA1.glb`, 28 bones, indices = code bone ids): 0 all_root, 1 skl_root, 2 chest, 3-10 left arm
(clavicle, arm_l1/2, wrist_l=6, fingers), 11-18 right arm (wrist_r = **14**), 19 head, 20 head_set, 21 hip, 22-24 left leg (ankle_l 24), 25-27 right leg (ankle_r 27).
CHR0 values are absolute locals (Euler degrees, R = Rz*Ry*Rx), hermite keys `[frame,value,tangent]`, `per_frame` arrays, or consts.

Driven (non-const) bones: every swing/serve clip drives skl_root(rot XY, trans XYZ), chest, both arms, wrists, head, hip, both legs (leg_*1 XYZ, leg_*2 Z, ankle XYZ).
`wait`, `walk`, `front`, `servewait_*`, `toss_*`, `tosswait_*`: left arm + head + hip + legs + chest, **no right arm** (constant). `waitLose`: both arms.
No clip contains finger/thumb motion (const) or root travel (skl_root t only +-0.5 units; walk is in place), so locomotion distance is purely code-driven.

Legs/walk: `walk` (30 frames, loop) animates leg_l1/r1 (XYZ), leg_l2/r2 (Z), ankles (XYZ), hip X/Z, chest XYZ, head XYZ; playback rate = 35 * (per-tick displacement) => one 30-frame
stride cycle per ~0.86 world units of travel (RECOVERED rule). Idle thresholds: walk starts at displacement >= 0.006/tick (only when rallyFlag!=0), stops at <= 0.004.

Paddle-hand (wrist_r, FK world speed in model units/frame; "pair a->b" = movement from frame a to b), peak frames:

| clip | frames | wrist_r peak (a->b, speed) | finger_r2 peak | note |
|---|---|---|---|---|
| fore | 21 | 7->8, 1.74 | 7->8, 2.07 | speed ramps 0.7..2.0 over f0-f7, drops to 0.05 by f12 |
| back | 21 | 1->2, 0.59 | 1->2, 0.66 | weak, monotone decay (backhand is a small slap in this clip) |
| fore_SP | 36 | 2->3, 0.98 | 2->3, 1.04 | |
| back_SP | 36 | 6->7, 0.84 | 7->8, 0.93 | |
| front | 31 | 16->17, 0.36 | 16->17, 0.37 | right arm constant -> speeds are body only |
| fore_SP2 | 46 | 2->3, 1.16 | 2->3, 1.23 | second bump f14-15 |
| back_SP2 | 46 | 0->1, 1.48 | 0->1, 1.49 | |
| fore_SP3 | 61 | 22->23, 1.32 | 23->24, 1.76 | two lobes: f15-17 and f21-26 |
| back_SP3 | 61 | 0->1, 1.41 | 23->24, 1.46 | |
| serve_F | 21 | 1->2, 1.22 | 0->1, 1.79 | |
| serve_B | 21 | 8->9, 0.78 | 8->9, 1.04 | |

Event frames in code (0x8045b3ac, SFX/effect triggers by animA/timer crossing `0x80346690`): fore_SP/back_SP/front: frames 0, 14, 27; fore_SP2/back_SP2: 0, 14, 28, 40;
fore_SP3/back_SP3: 0, 14. Gate windows: 10..45 (SP3), >=10 (SP2), <26 / <40 / <44 (d8). fore/back/serve clips have no frame-keyed events and no gates.
These frame numbers (14, 26-28, 40-45) are the code's own markers; they do not coincide with the wrist speed peaks (SP peaks at f2-3 / f6-7), consistent with the clips being
started ~11 ticks after the swing trigger when the real swing is already in progress.

## 8. Ball-strike timing and recognition coupling (partly RECOVERED)

* Swing trigger -> `Participant+0x6c` counts 0.. while ball live; during counter 0..10 the controller's peak power `ctrl.vfunc0x4c()` is max-tracked into `+0x68` and sent to the ball
  (`0x80469b44`); at counter > 10 `OnSwing` runs and the avatar clip starts (frame 0 of fore/back/SP*). The adapter counter 45/75 (HANDOFF) is the separate recognizer window (parent+0x18==0 -> 45, else 75).
* The shot itself (rally launch 0x8046fdf0 / serve 0x80474998) is computed from the swing record and is **not** read from the clip; contact is physical (racket body vs ball, mode A contact handler
  0x80463034/0x80463364 sets `mode+0x330 = 10`). A clip's hit moment is therefore approximately the clip's SP hold point (frame ~12-14, event 1) for SP/front/SP2 and the hand-speed peak
  (frame 7-8) for `fore`; no hard-coded "strike frame" constant exists in the animation code (UNKNOWN beyond these indicators).
* Serve: Participant counter source is the same; the resulting clip is serve_F/serve_B (20 ticks). Miss path: if the counter exceeds 10 and the predicted ball height at `13*frames` is below `[r13-0x2968]`, `0x8047270c` + no-op avatar hook are called (no animation).

## 9. Ready-to-implement pseudocode (web port)

```js
// per participant per tick (60 Hz logic, 1 tick = 1 clip frame at rate 1)
const FADE = {wait:.08, servewait:(sub)=>sub?1:.1, toss:.25, tosswait:1, waitLose:1}; // all other clips .1
function setState(av, state, sub){
  av.layers.unshift(newLayer()); av.layers.length = Math.min(av.layers.length, 8);
  const [A,B] = pickClips(av, state, sub);          // table in section 3, lefty swaps 1<->2,3<->4,6<->7,8<->9
  L = av.layers[0]; L.animA=A; L.animB=B; L.w=1; L.timer={cur:state==6?len(A):0, len:len(A), rate:1, loop:isLoop(A)};
  L.fade=0; L.fadeRate = fadeRate(A, sub); av.state=state; av.tick=0;
}
function avatarTick(av, P, speed /*|disp xz| this tick*/){
  av.tick++;
  switch(av.state){
    case 1: case 2: if(done(L.timer)) setState(av,0,0); break;
    case 0: if(P.rally!=0 && speed>=0.006) setState(av,3,0); break;
    case 3: if(speed<=0.004) setState(av,0,0); else L.timer.rate = 35*speed; break;
    case 4: if(done) setState(av,5,0); break;                    // unreachable in TT
    case 6: L.timer.rate=-1; if(done) setState(av,0,0); break;
  }
  if([3,4,5,6,7].includes(L.animA)){ // SP stretch hold
    if(P.mode.hitCountdown==0 && L.timer.cur>=12) L.timer.rate=Math.max(0,L.timer.rate-.25);
    else L.timer.rate=Math.min(1,L.timer.rate+.25);
  }
  if(L.animA>=11 && L.animA<=16) L.w = P.mode.fbWeight;
  updateGates(av);                      // section 6 table
  tickTimer(L.timer);                   // only layer 0 advances
  // blend: rem=1; for each layer k: fade=min(1,fade+rate); wk=rem*fade; rem-=wk; weight A=wk*w, B=wk*(1-w)
}
function startSwing(av, hand/*1 fore,0 back*/, reachLat, reachFwd, blocked){
  let sub=0;
  if(!blocked && reachLat>=13) sub=4; else if(!blocked && reachLat>=9) sub=3; else if(reachLat>=6) sub=1; else if(reachFwd>=8) sub=2;
  setState(av, hand?1:2, sub);
}
function canStartSwing(av,P){ return !(P.flags&2) && av.state==0 && av.tick>=11; }
// swing is delayed 10 ticks after trigger: OnSwing at P.counter>10
// serve-wait F/B blend: target=clamp((yaw*(lefty?-1:1)+100)/200,0,1); slew=min(slew+.0004,.005); w+=clamp(.05*(target-w),-slew,slew)
// racket model each tick: orientation = remote orientation matrix (lefty mirrored); pivot = racket obj; attach hands from bones 6/14 of the animated skeleton
```

## 10. Confidence / unknowns

* HIGH: clip name table and ids, F/B swap for lefties, state->clip table, blend rates, timer semantics, walk start/stop thresholds and 35*speed rate, swing sub-variant thresholds (6/9/13/8) and
  their precedence, 11-tick idle cooldown, 10-tick swing delay, F/B serve-wait yaw blend constants, gate windows/rates, event frames, CHR0 bone coverage, remote orientation matrix source.
* MEDIUM: semantics of SP tiers as lateral reach (derived from `0x80461eac` dot products), SP hold-until-contact, toss/tosswait dead code claim, gate consumers (blend remote vs bone pose).
* UNKNOWN: exact meaning of `mode+0x54` (0x80461d08 result), `ctrl.vfunc0x68` for CPU, the rest of the racket tick (0x804732d8) geometry (what position the racket pivot takes relative to hand bones),
  the exact world speed range of walking (movement code in mode update not traced), footstep SFX events (0x8045e8ac/0x8045e8a4 flags), CPU skill effects on swings, mode B behaviour.
