# Table Tennis racket: attachment and remote -> pose mapping (Wii Sports Resort, USA Rev 1 main.dol)

Labels: **RECOVERED** = addresses + instruction evidence (and, where stated, numerically verified by running the real DOL code in `tools_racket/ppcemu.py`);
**INFERRED** = deduced, not proven; **UNKNOWN**. Builds on `animation.md` section 6 and `movement.md`; corrects one claim there (see section 8).

Tools (all under `research/tools_racket/`): `ppcemu.py` (Gekko interpreter incl. paired singles, runs DOL functions), `harness.py` (synthetic adapter memory),
`port.py` (Python port), `verify.py` / `verify2.py` (port vs. interpreted original: tracking, active, swing, lefty; max error 9e-4, table interpolation noise),
`racket_pose.js` (ESM JS port) + `verify_js.py` / `js_check.mjs` (JS vs. Python 1e-13), `hand_vs_racket.py` (FK of wrist_r vs racket grip), `*.asm` dumps.

## 0. One-paragraph answer

The racket is **not parented to the hand bone and not a copy of the remote matrix**. It is a free model (`avatar+0x28`) placed in the player's frame from a
*synthesised* pose: three scalars derived from the Wii Remote orientation matrix (pointing yaw `A`, pointing pitch `B`, roll/twist `theta`) build a basis, which is
rotated by the body pose basis and anchored on a body-relative point (chest bone + fixed offset). The Mii's hands come straight from the animated wrist bones (6/14) and
are **not** moved to the handle (floating hands, no IK). Forehand/backhand differ only through the yaw angle (the opposite blade face ends up facing the ball); lefties get a
mirrored anchor, mirrored yaw limits, and a 180 deg flip of the model about its own handle axis.

## 1. Data flow (RECOVERED)

1. Remote sample -> `remote+0x30..0x50` (3x3 orientation, `0x804589e8`). Per sample `0x804588ac` computes the unwrapped heading of **row 2** of that matrix:
   `hd = atan2(m20, m22)` in degrees (`acos(m22/len)` signed by `m20`, len = hypot(m20,m22)), `H += wrap180(hd-H)`, H wrapped to +-240, then per tick
   `Hs += clamp(0.5*(H-Hs), -20, +20)` (`remote+0x1c0`, `remote+0x1bc`=H). `Hs` reaches the adapter as `adapter+0xc4` (controller vfunc 0x74 = `0x80469190`).
2. `0x8045fdb4` (participant tick): `adapter+0x64 <- adapter+0x40; adapter+0x40 <- controller+0xc` (the raw remote 3x3 `0x8045debc`, 9 floats, no mirroring), also
   `adapter+0xac/0xb0/0xb4/0xc0/0xc4` from controller vfuncs. `0x8045fd0c..0x8045fd90`: `adapter+0x10 = pose+0xc` (body position), `adapter+0x1c..0x3c = pose+0x24..0x44` (body basis, rows = body axes),
   then adapter tick `0x80468410(adapter, f1 = scene[0x150])`.
3. `0x80468410` calls the pose generator **`0x80467b4c`** (this document), then the swept contact test `0x80466100`, then commits `adapter+0xc8 <- 0xfc` (pivot) and `adapter+0xd4..0xf4 <- 0x108` (3x3 basis rows).
4. Participant sync `0x8045f498` mirrors both through `0x8045e788` (`(x,y,z) -> (-x,y,-z)` when `Participant+0x28` (side index) = 1) into `racket_obj+0x40` / `+0x4c..+0x6c`, then copies to
   `avatar+0x6c` (pivot) and `avatar+0x78/0x84/0x90` (basis rows B0,B1,B2) at `0x8045f990..0x8045f9fc`.
5. PostUpdate `0x8045c800` builds the model node `avatar+0x28` (details section 5).
6. The visible racket and the contact box use the *same* `0xfc`/`0x108` (section 6), so they match.

`0x8045e788(participant, dst, src)`: copies a vec3, negating x and z if `participant+0x28 != 0`. This is a 180 deg rotation about Y (far-side player), not a lefty mirror.

## 2. Frame conventions (RECOVERED from anchors + FK, INFERRED for remote hardware axes)

Canonical player frame (used by pose/anchors/bones): **+x = player's left, +y = up, +z = toward the net/opponent** (right-handed). Evidence: right-hand wrist_r FK in
`wait` = (-1.27, 7.72, 3.49) (`hand_vs_racket.py`); righty anchors have x < 0; lefty negates x. Far-side player = canonical result rotated 180 deg about world Y.
Body pose basis `adapter+0x1c` has rows = body axes; `v_world = v_local . P + pose_pos` (`0x80327114` is row-vector * matrix: `dst = x*row0 + y*row1 + z*row2`, emulator-verified).

Remote matrix `M = adapter+0x40/0x88` (rows r0,r1,r2): **r2 is the remote's pointing direction in the same frame** (heading = atan2(m20,m22), pitch = asin(m21)); r0/r1 matter only through
*relative roll about r2* (section 3.5). Which physical Wii Remote axis is r2 and the exact SDK frame are INFERRED (must be the long axis toward the tip; the game only needs it consistent with its own world).

## 3. Pose generator `0x80467b4c` (RECOVERED; port.py == original within 1e-3 for tracking/active/swing/lefty)

Constants: `0x806f2028`=145, `0x806f202c`=130, `0x806f2030`=1.3, `0x806f2034`=0.4, `0x806f2038`=0.99, `0x806f203c`=0.1, `0x806f2040`=0.5, `0x806f2044`=0.996, `0x806f2048`=0.98,
`0x806f204c`=45, `0x806f2050`=`0x806ff03c`=0.015, `0x806f201c`=1.05.

Per tick, `t = f1` (= scene[0x150], blend factor for the remote sample interpolation `M88 = slerp(M64, M40, t)`, `0x80326e44`; t=1 -> latest matrix; real value UNKNOWN, use 1):

1. **Pointing angular velocity** `rv = cross(prevRow2, curRow2)`, scaled so |rv| = asin(|cross|) in degrees (`0x80467c34..0x80467c98`). Low-pass: `acc += 0.5*(rv-acc)` (`adapter+0x198/0x19c/0x1a0`). `acc.y` is the vertical-axis (yaw) rate in deg/tick.
2. **Twist** `f31` (`0x80466bc0`): carry prev frame to cur pointing by the shortest arc (`0x80326274`), signed angle of cur r1 vs carried r1 about r2, degrees. Equals the gyro rate about the pointing axis (right-handed positive: `r0' = cos r0 + sin r1`). Emulator-verified: +5 deg for that rotation, 0 for rotations about r0/r1.
3. `f30 = +-hypot(rv.x, rv.z)`, sign from `(acc.x,0,acc.z) x curRow2 . y < 0` (only used for the swing accumulator `0x184`).
4. **Yaw `A` (`adapter+0x170`)**, limits `[lo,hi]` = righty `[-145, +130]`, lefty `[-130, +145]` (`0x80467df4/0x80467e08`); `0x190` = swing-active, `0x168` = swing hand (1 forehand / 0 backhand), `0x1f4` = +-30:
   * not swinging, **ball live** (`0x8045e8b4` = Participant+0x6c >= 0): `y17c += 1.3*acc.y; A = clamp(y17c)`; `y178 = A; y16c = A - Aprev; y180 = 0`.
   * not swinging, idle: `tgt = clamp(1.3*Hs, lo, hi)`; `y16c` decays toward 0 by 0.4/tick; `y178 = clamp(y178 + y16c)`; `y180 = clamp(y180 + 0.015, 0, 1)`; `A = y178 + ease(y180)*(tgt - y178)`, `ease(t) = (1-cos(pi t))/2` (`0x80326180`, emulator-fit). So yaw glides to the remote heading over ~67 ticks.
   * swinging (`0x190 != 0`, `0x1a8` ticks left, 45 or 75 from the recogniser): `A += 1.05*acc.y`, clamp `[0x1f4, hi]` if backhand (0x168==0, 0x1f4=-30) or `[lo, 0x1f4]` if forehand (0x1f4=+30); ends when `0x1a8` (decremented every tick) <= 0.
   Set at swing start by `0x80465ab8` (OnSwing): `0x168=hand`, `0x190=2`, `0x1f4 = hand==1 ? +30 : -30`, `0x184=0x188=0`.
5. **Twist state**: tracking: `a18c *= 0.99; a194 = clamp(0.015*f31 + 0.996*a194, -1, 1)`; swinging: `a188 += f31; a184 += f30; a18c += 0.1*(a188 - a18c); a194 *= 0.98`.
   `theta = 45*a194 + a18c` degrees. **Absolute remote roll is ignored**; only roll *rate* (leaky integral, saturating at +-45 deg plus the swing accumulator) tilts the blade.
6. **Pitch** `B = soft(asin(clamp(M88[2][1],-1,1)) in deg)` (`0x80466c94` -> `0x80325228(x,60,90,70)`): identity for x <= 60, else `60 + 10*(0.1u + 2.8u^2 - 1.9u^3)`, `u=(x-60)/30` (max 70 at 90).
7. **Basis** (`0x80466f5c`, units 256/360 per degree table sin/cos `0x8013bc70`; use exact sin/cos): with `s1=sin A, c1=cos A, s2=sin B, c2=cos B`
   `Mrow0 = (s1 s2, -c2, c1 s2)`, `Mrow1 = (c1, 0, -s1)`, `Mrow2 = (s1 c2, s2, c1 c2)` (orthonormal rows; row2 = blade/handle axis "forward", row1 = blade face normal, row0 = -blade-up).
   Roll: `R = Rz^T(theta) . M` i.e. `R0 = cos th*M0 + sin th*M1`, `R1 = -sin th*M0 + cos th*M1`, `R2 = M2` (`0x8013c2f0` Euler(0,0,theta) then `0x80327664` = Bt*A, emulator-verified).
8. **Pivot** (`0x80466cf8`, runs between steps 7 and 9 on the unposed rows): `f = clamp((90 + A)/180, 0, 1)`; lefty `f = 1 - f`.
   `Bv = lerp((-0.5,1.4,0.3) [0x807d3614], (-1,1.1,4) [0x807d3608], f)`, lefty: `Bv.x = -Bv.x`.
   `Sh = (0,4.6,0) [0x807d3620]`; if `avatar+0x34 & 1` (set after the first PostUpdate, i.e. always): `Sh = lerp(Sh, chestPos, 0.5*(1-adapter[0x1e8]))` where `chestPos = avatar+0xf4/0x104/0x114` = chest bone (bone 2) translation in the avatar-root frame (PostUpdate `0x8045cc2c..` via `0x8003e7a0`).
   `grip = Sh + Bv` (`adapter+0x12c` after posing), `pivot = grip + R2 * (6.2 + f*(3.8-6.2))`, then `P_world = v.Pose + pose_pos` for both (`adapter+0x12c`, `adapter+0xfc`); `rows_world = R . Pose` (`0x803272f8` computes B*A, emulator-verified).
   Constants `6.2/3.8` = `0x806f2018`/`0x806f2014`.
9. Then (not ported, INFERRED): `0x80465878(max 45 deg)` limits the angle between the racket axis and the hand->handle vector (no-op while pivot = grip + k*R2), and `0x80465244` pushes the racket out of the table collider (uses `0x80459d90` on the table box, margins 1.75 / 2.6, re-orthonormalises rows). Intercept assist (`adapter+0x1d8..0x1f8`, set by OnSwing `0x80465ab8`: target `0x1dc = (+-3,8,3).Pose + pose_pos`, countdown `0x1ec/0x1f0`, weight `0x1e8 = (0x1ec-0x1f0)/0x1ec` eased) lerps the pivot (and the chest term above) toward a ball-intercept path during an accepted swing (`0x80468248..0x80468300`, 0.9 factor, 0.08 gain in `0x80465764`) - semantics INFERRED, constants RECOVERED.

Initial/neutral result (yaw 0, pitch 0, no roll, canonical frame): grip = (-0.75, 5.85+, 2.15), pivot = grip + 5.0 z; rows = [(0,-1,0),(1,0,0),(0,0,1)] (emulator output).

## 4. Rest of the "racket object" is not the racket (RECOVERED, corrects animation.md section 6.5)

`racket_obj` (0x480 B, ctor `0x80474760`, tick `0x804732d8`) never writes `+0x40/+0x4c..` after construction (only the ctor does; grep of the tick). Its tick outputs are two body points
(`racket+0x320/0x330/0x340`, `+0x350/0x360/0x370`, copied from sub-object `+0xb4..+0xc8`), turned into surface codes by `0x8045e654` (table collider lookup) stored at `Participant+0x20/+0x22`, consumed by the footstep SFX
function `0x8045b070` (`lhz 0x20/0x22(participant)`), plus event flags read by `0x8045e8a4/0x8045e8ac/0x8045ea64`. The seven animated bones (19,2,21,6,14,24,27) and the six gates (`avatar+0xd0..0xe4`,
animation.md table) are inputs of this body/foot solver (it also receives `adapter+0x170` yaw as `racket+0x464`); **they do not blend the racket pose**. So: no clip/remote blend of the racket exists; the racket
is always the pose of section 3 (idle, walking, waiting, swinging). During swings the only "blend" is the swing branch of step 4/5 (angular accumulation instead of heading tracking) and the optional intercept assist.

## 5. PostUpdate model placement `0x8045c800` (RECOVERED)

Model node `avatar+0x28`: rotation matrix columns `X' = B1`, `Y' = -B0`, `Z' = B2` (`avatar+0x84`, `-avatar+0x78` via `0x80130d10`, `avatar+0x90`; `0x8045ca88..0x8045cb08`), translation
`pivot + (0,0,-2.4) . [B0;B1;B2]` = `pivot - 2.4*B2` (`0x80327114` with const `0x807d3550` = (0,0,-2.4), set by `0x8045d954`; stored `model+0xc`). Lefty (`avatar+0x2f4`): `B0 = -B0`, `B1 = -B1` first (`0x8045ca0c..0x8045ca88`) = 180 deg about the handle axis (other face, mirrored
width side; the blade is symmetric in its width axis). Glb mesh `WS2_png_racket`: thin axis x, blade width y (+-1.65), handle/length axis z, blade z 0.67..4.11 (centre 2.4), handle toward -z. So **mesh origin = 2.4 behind the blade centre; pivot = blade centre**. Identity rotation at yaw=pitch=roll=0 (X'=(1,0,0) player's left = face normal, Y' up, Z' forward).
Hands: models `avatar+0x20` / `+0x24` take bone 6 / bone 14 world matrix (position = column 3 `0xc/0x1c/0x2c`, rotation `0x80327edc`), lefty negates their x axis; head attachment `+0x14` = bone 19 matrix, translation `+= 0.15*col1 - 0.3*col0`.

## 6. Contact box (RECOVERED / INFERRED)

`0x80466100` (requires `adapter[0x1a4] != 0` and swing flag `0x190`/arg): 8-step sweep between `0x138/0x144` (previous pivot/rows) and `0xfc/0x108` (current), box half extents `(1.65, 0.16, 1.73)` (`0x807d3638`), ball radius 0.452.
Box local axes = the rows (x = row0, y = thin = row1, z = row2), centre = pivot (INFERRED from layout; consistent with the mesh: face normal X'=B1, blade width Y'=-B0, length Z'=B2, centre 2.4 from mesh origin, blade z-extent 2.4+-1.73 matches the glb). Same buffers as the visible racket.

## 7. Questions from the brief

1. **Attachment**: free model, world/frame placed from `pivot - 2.4*B2` and basis columns `(B1,-B0,B2)`; anchor chain: body pose (pos + basis) -> chest bone (blend 0.5) -> (0,4.6,0) -> yaw-dependent offset `Bv` -> `6.2..3.8` along the blade axis. `avatar+0x6c` = pivot, `+0x78/+0x84/+0x90` = basis rows. Bones 19/2/21/6/14/24/27 are only body/foot-solver inputs; only the chest bone (2) feeds the racket (via `avatar+0xf4`). Wrist bones feed the hand models only. No scale (1.0).
2. **Mapping**: section 3 (heading x1.3 -> yaw clamp [-145,130]/[-130,145]; pitch = asin(r2.y) soft-clamped at 70; roll = leaky integral of gyro-about-pointing-axis, +-45 deg + swing term). Remote pointing forward (heading 0, pitch 0) = racket pointing forward, blade vertical, face normal to the player's left (x+); pointing 90 deg to the player's right -> face normal forward. Remote roll offset is not a fixed rotation; no calibration step exists in this code (zeroing is whatever the SDK/home-screen heading gives; heading 0 = +z).
3. **Position**: not remote position; body-anchored (chest + offset) with the yaw-dependent offset and blade-axis extension (pivot slides 6.2 -> 3.8 behind/ahead as yaw goes from -90 to +90 [for righty: right side to left side]); pitch/yaw rotate the extension, so the blade centre swings on a sphere around the grip. Hand vs. handle: wrist_r (`wait`) = (-1.27,7.72,3.49) vs grip (-0.75,~5.95,~2.0) and handle end ~(-0.75, 6, 4.2): the hand floats ~1.8 above/forward of the handle; nothing reconciles them (RECOVERED absence of IK in PostUpdate).
4. **Clip blending**: none (section 4). Gates are footstep/body inputs.
5. **Forehand/backhand, lefty**: no grip flip code. Yaw sign decides the side (forehand righty = negative yaw = right of body; swing limits `A <= +30` for forehand, `A >= -30` for backhand). The other blade face ends up toward the ball on the other side of the body automatically. Lefty: `f -> 1-f`, anchor x negated, yaw limits swapped, rows B0,B1 negated in PostUpdate (face/width flip), mirrored avatar root.

## 8. Confidence

HIGH: sections 3 (1-8), 5, frame signs of yaw/limits, the formulas verified against the executed game code. MEDIUM-HIGH: section 4 (racket obj = body/foot solver), box axes. MEDIUM: remote matrix hardware axes.

## 9. Unknowns / not ported

* Intercept assist details (`0x80465764`, `0x80465e88`, `0x80466900`) and table push-out `0x80465244` (affect pivot near the table or during accepted swings).
* `scene[0x150]` value (slerp factor), sample count per frame (WPAD loops all buffered samples; heading filter assumes 1 per tick).
* CPU players use the synthetic generator `0x8047e148` (movement.md); same downstream code, so the same racket pipeline.
* Right-handed convention of the remote matrix and any home-screen calibration offset (SDK side, not in main.dol).
* Serve-phase differences: the same generator runs (active flag false while waiting, true when `Participant+0x6c >= 0`); no separate serve racket pose was found.
