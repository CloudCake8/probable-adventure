# Wii Sports Resort Table Tennis - player movement / positioning / CPU AI

Target: USA Rev 1 `assets/code/original/main.dol`. All addresses are virtual (r2=0x806fe080, r13=0x806f8120).
Labels: **RECOVERED** = read from disassembly (address given), **INFERRED** = deduced from recovered code but not
proven by a runtime trace, **UNKNOWN** = not resolved. No emulator was used; nothing here was validated against a capture.
The PAL `MAP.txt` has no symbols for this game code (only SDK/EGG/nw4r), so every name below is mine.

Reproduce: `py -3 pingpong/tools/ppc_probe.py dump A B`; helpers in `research/tools_movement/`:
`sinit_emu.py` (emulates the straight-line `.ctors` initialisers to recover the BSS Vec3 constants: output `sinit_png.txt`),
`xrefs2.py`, `vtables.py` (+`vtables.txt`), `funclist.txt`, `show.sh` (compact disasm), `cpu_records.csv` (the 100 CPU records).

## 1. Object model (RECOVERED)

Global scene = `*(r13-0x2988)`. Fields used: `+0x14c` = **4** (stored at 0x80456594: `li r31,4; stw r31,0x14c(r30)`; it is the number of
ball sub-steps per frame, used as `index*scene[0x14c]` when sampling the ball trajectory, 0x8045fff0, and as the inner loop count in the
hit simulator 0x8045d994), `+0x158` player-config table, `+0x160` match config, `+0x164` table collider (0x8045a368 = point/box test),
`+0x168` player manager (players at `+0x10`,`+0x14`), `+0x17c` rules/timing object, `+0x180` side config.

**Player** (ctor 0x80460724, vtable 0x806d9298-ish "PlayerManager" phases at 0x806d9db4: 0x80460f24, 0x80460ecc, 0x80460e74, 0x80460e1c):
`+0x0c` index (0/1), `+0x28` mirror flag (=index), `+0x18` **mode** (0 = pre-rally/serve stage, 1 = serve stroke in progress, 2 = rally; match phase 2
sets both players to 2: 0x80470e10 / 0x80482244 call 0x8045e2cc), `+0x5c` ball list, `+0x60` current ball, `+0x80` stats logger, `+0x84` avatar/anim,
`+0x88` racket+swing object (ctor 0x80468cc0, 0x6d4 bytes), `+0xbc` **current pose object** (array `+0xc4[0..1]`, selected by `0x8045e9cc`),
`+0xd4` **current controller** (array `+0xdc[0..2]`, selected by `0x8045e9b4`, index in `+0xd8`).
Controller choice at construction (0x8046081c..0x80460870): `scene[0x160]+0xc+idx*4 == 1` -> controller 1 (CPU) else 0 (human); controller 2 is used for `cfg[8]==1 && idx==1` (likely remote/demo; UNKNOWN).

Classes (vtable *object* pointer = table address - 0xc):
| Class | vptr | ctor | role |
|---|---|---|---|
| Pose base | 0x806d9e18 | 0x80461c48 | position/orientation holder (`+0x0c` pos, `+0x18` vel, `+0x24..0x44` 3x3 basis) |
| **PoseRally** | 0x806d9e70 | 0x80464fd8 | the movement model (all of section 4-6); pose[0] |
| Pose #2 | 0x806daac8 | 0x8047bc34 | second pose state (not analysed; UNKNOWN) |
| Controller 0 (human) | 0x806d9f70 | 0x80469a20 | wraps the Wii-remote swing recogniser `+0x38` |
| Controller 1 (CPU) | 0x806dab98 | 0x8047d634 | CPU brain (section 8) |
| Controller 2 | 0x806db220 | 0x8048329c | not analysed |

PoseRally vtable (0x806d9e7c = slot 0): 2 `0x80464d30` reset-to-home, 3 `0x80463c10` **main update**, 4 `0x80462efc` crouch param,
5 `0x80464954` begin-point stance (server/receiver), 7 `0x80462d48` on-stroke, 8 `0x80462d44` go-home (->0x804623ac), 9 `0x80462d38` clear-home flag,
10 `0x80462c70` returns side (`+0x2b0`).

### Coordinate frames (RECOVERED)
`0x8045e788(player,out,in)`: if `player[0x28] != 0` then out=(-x,y,-z) else out=in. So each player works in a **local frame in which its own side is z<0**;
player 1 is the 180-degree (x,z negate) mirror of player 0. Table collider (0x8045a1e8, FINDINGS): half-width 9.15, half-length 16.398;
`0x8045a428`=32.796 (table length), `0x8045a430`=18.3 (width), `0x8045a438`=**-6.0 = floor/root y**. Table top is y=0. Ball ground-plane is y=-6.
Scale: ~12-13 units/metre (gravity 0.00221/step^2 with 4 steps/frame is ~0.0354/frame^2).

## 2. Static vectors recovered from `.ctors` (RECOVERED, `sinit_png.txt`)
Initialisers at 0x80465100 (->0x807d3590) and 0x80468e0c (->0x807d35f0), 0x804609e8 (0x807d3568), 0x8045d954 (0x807d3550), 0x8047489c/0x8047192c.

PoseRally (0x807d3590..):
| addr | vec (x,y,z) | use |
|---|---|---|
| 807d3590 | (0, 0, -28) | home position of rally pose (0x80464d4c, 0x80464978; y forced to -6) |
| 807d359c | (4.5, 6.4, 5.0) | serve ball-hold anchor A (0x80464748 caller 0x804649d8) |
| 807d35a8 | (-0.3, 6.4, 7.0) | serve anchor B |
| 807d35b4 | (-5.0, 6.4, 4.0) | serve anchor C |
| 807d35c0 | (-4.0, 0, -3.5) | backhand stance offset (right hander) |
| 807d35cc | (5.5, 0, -3.0) | forehand stance offset (right hander) |
| 807d35d8 | (0, 0, -2.0) | centre stance offset |
| 807d35e4 | (-1, 0, 0) | lateral axis used by the hop/lean code (0x80461f4c) |
Racket / swing (0x807d35f0..): (9,7,5.5) forehand racket anchor, (-12,7,7) backhand racket anchor (0x8046605c/0x80466080, rotated by pose basis
+ added to pose pos, x negated for left hander), then (-1,1.1,4), (-0.5,1.4,0.3), (0,4.6,0), (3,8,3), **(1.65,0.16,1.73) racket collision-box half extents** (0x807d3638, used by the
8-step swept sphere/OBB racket-ball test 0x80466100 with ball radius 0.452), (0,5,0),(0,5,0),(0,0,-2.8).
Other: 0x807d3668 (2,8,0); 0x807d3678.. (0,4.7,0),(0,0,0),(0,3.3,0),(0,0,-2.8),(0,5,0),(0,.33,0),(0,7.8,0),(0,3,0),(.9,-.5,.1),(0,4.6,0) (serve/toss poses, not analysed);
0x807d36f0 (60,20,0),(50,20,50),(50,20,-50),(37,55,80),(37,75,-80) (camera, not analysed).

## 3. Ball trajectory prediction (RECOVERED structure)
Method is **exact pre-simulation, not an analytic formula**. The ball owns a long trajectory buffer (`ball[0xf8]`, accessors 0x8046f754/0x8046f8a0/0x8046f8f4) that is
filled by the real physics (air kernel 0x8046b834 + table collision) when the ball is launched. Player code reads it:
* `0x8046a47c(ball,k)` -> predicted position `k` ball-steps ahead (`ball[0x180]+k`); k=0 returns the live ball.
* `0x8046a450(ball,frac)` -> (pos,time) at fraction `frac` of the remaining recorded flight.
* `0x80462c78(pose,ball)` fills a **31-entry ring** (`pose+0x9c..0x28c`, stride 0x10 = x,0,z,time) with samples at `frac=i/31`, i=0..30 (`0x80462bf0` converts to player-local, y:=0, w:=absolute ball step). Called every update while the ball is inbound (condition below).
* A separate full simulate-forward hit finder 0x8045d994 (used by the CPU, called from 0x8047cbb0 with index 0xb) clones the ball (`0x8046c03c` steps the clone), loops 24 outer x `scene[0x14c]` inner steps and runs the racket-contact test 0x80466100 on each - this is how the CPU learns where/when its swing would meet the ball.
The only prediction constant seen in the movement path: lookahead sample index **40 steps** (`r13-0x6128`=0x28; also `0x8046a47c(ball,0x28)` at 0x80461f1c) and **30 steps** in the CPU swing gate.

## 4. Target (hit) position selection (RECOVERED)

Trigger (0x80463c10 @0x80463cb4-0x80463d1c): recompute target **only when** `pose[0x3c0] != 0 && ball != null && Player.isMyBall(0x8045e904) && ball[0x198] (last hitter) != me && ball[0x194] (ball state) in {3,4}` i.e. the ball is flying toward me after the opponent's stroke. Outputs: `pose[0x2a0..0x2a8]` target (local x,y=0,z), `pose[0x2ac]` hit time (absolute ball step), `pose[0x2b0]` side (0 backhand, 1 forehand, 2 centre/none).
Otherwise the old target persists.

Stance offsets (`0x804624e0(side, lefty, out)`; body position = ball point + offset, rotated by the facing basis via `0x80462430`):
```
right-hander: side1(forehand)=(+5.5,0,-3.0)  side0(backhand)=(-4.0,0,-3.5)  side2=(0,0,-2.0)
left-hander : side1=(+4.0,0,-3.5)  side0=(-5.5,0,-3.0)  side2=(0,0,-2.0) with x negated
```
(`lefty` = `0x8045e938` = `player[0x84][0x2f4]`.) Pure lateral variant used for the smoothed hand offset (`0x80463a68`, x only, z:=0):
right-hander side0=+4.0, side1=-5.5, side2=0; left-hander side0=+5.5, side1=-4.0.

Candidate search - human (`0x80462a14`, controller slot `[0x70]` != 2): side is fixed by the controller: human returns `swingRecogniser[0x1ac]` (0->0,1->1,2->2, else 1). CPU/side==2 -> `0x80462648` evaluates both stances.
```
for i = 30 downto 0:                         # newest (farthest future) first
    t = ring[i].time - ball.step              # ball steps remaining
    if t <= 0: continue
    cand = ring[i].xz + stanceOffset(side)    # rotated by facing
    if reachable(cand, t, s): target=cand; hitTime=ring[i].time; break
if none: use ring[0]
reachable: (t*s)^2 >= |cand.xz - pose.xz|^2     (0x804625b8)
s (0x80462604) = 0.334 > 0.5 ? 0.01 + 2*(k-0.5)*(-0.0099) : 0.03 + 2*k*(-0.02)     # k = pose[0x334]
CPU (0x80462648) uses s = 0.04 fixed for the first stance tried and the k-profile for the other; stance order chosen from sign of pose x.
```
`k = pose[0x334]` (0..1) comes from the controller skill category `ctrl[0x6c]`: CPU category(rec f12) 0->0, 1->0.5, 2->1.0; human = category 3 -> starts 0.5 (ctor) and is
nudged in the on-stroke slot (0x80462d48): if projected lead `f0>=2.5`: `k -= 0.3*min((f0-2.5)/5.5,1)` (floor 0); if `f0<=1`: `k += 0.3*min((f0-1)/-3,1)` (cap 1).

Depth clamp: target z is clamped to **z <= -6** before use (0x80463da4: `-(r13-0x6178)=-6`). No lateral clamp except the walk ellipse in section 5.

Go-home target (slot 8 -> 0x804623ac, sets `pose[0x2c0]=1`): `target=(0,0,-d)`, `d = 2*k*11+17` for k<=0.5, `d = 2*(k-0.5)*12+28` for k>0.5 -> stands at z=-17 (k=0), -28 (k=.5), -40 (k=1). While this flag is 1 the chase speed cap is 0.04 instead of 0.07. After the ball passes the player (ball[0x178]>=3 and mode==2, 0x80462288) the target is truncated to 5 units from the current position toward the old target and `pose[0x3c0]` is cleared (stop chasing).

Initial/begin-point stances (slot 5, 0x80464954):
* receiver: `pose = (0 - off.x, -6, -28 - off.z)` with off = centre offset (0,0,-2) -> **(0,-6,-26)**, `pose[0x32c]=1`, `k` as above.
* server: `O = (+/-4.5, 0, -17)` (`pose[0x8c]=4.5` sign flipped when `scene[0x180][0x1c]==0`; `pose[0x94] = -0x80474988() = -17`). The three serve stand positions are `O - R*A/B/C` where `R` rotates local forward toward the point `(0, 8)` (0x80464748: forward = normalise(-O.x, 0, 8 - O.z)); y=-6.
During mode 0 (serve stage) the server's position is a 3-point lerp: `u = clamp((twist + 100)/200, 0, 1)` (twist = controller slot `[0x74]`, +-100 deg range, negated for left hander) smoothed (below), `u>=0.5: lerp(B',A',2(u-.5))` else `lerp(C',B',2u)`, then `pos.xz += O.xz`.
Serve u smoothing: `rate += 0.0004` per update (cap 0.005, stored `pose[0x3c8]`); `delta = clamp(0.05*(u_target - u), -rate, +rate)`; `u += delta`.

## 5. Movement dynamics (RECOVERED constants, update cadence INFERRED)
Main update `0x80463c10`, per call (constants from `r13` table `0x806f1fa4..`, `r2` table):
```
state:  P=pose+0x0c (x,y,z)   V=pose+0x2b4 (virtual pos)   v=pose+0x2c4 (impulse vel)
        vmax=pose[0x31c]   lock=pose[0x318] (int)  lock2=pose[0x330]
pose[0x32c] += (mode==0 ? -0.01 : +0.01) clamp[0,1]       # serve->rally blend (also table-avoid margin 1.5+2.5*w)
lock = max(lock-1,0); lock2 = max(lock2-1,0)
zt = min(target.z, -6)
d  = ( target.x - V.x , 0 , zt - V.z )                    # optional wall-slide: remove component along n=(0x3b0..0x3b8) if pose[0x3bc]>0, keep if |slid|<=0.1
T  = max(1, (hitTime - ball.step) - 180)                  # arrive 180 steps (=45 frames) BEFORE the ball
f  = ctrl.speedFactor()                                   # human 1.0 (x scene factor 0x80481b74 = 1.0); CPU = rec.f4 (min(rec.f4,1.65) when ctrl[0x3c]<0)
if f < 1.8:                                               # panic boost when ball is near
    q = ballLocal(40 steps ahead) ; dist = |q.xz - P.xz| ; t = clamp((10 - dist)/5, 0, 1)
    f += (1.8 - f) * t^2                                  # t^2 = exp(2*ln t), 0 if t==0
vcap = (lock>0) ? 0 : ( (pose[0x2c0]) ? 0.04 : 0.07 ) * f
acc  = 0.0012 * f
if vcap > vmax: vmax = min(vmax + acc, vcap)  else vmax = vcap
need = |d| / T
if need > vmax: need = vmax  else vmax = need            # ratchet: vmax can drop to what is needed
a = (|d|==0) ? 0 : d/|d| * need
v.xz *= 0.995 ; v.y = 0.995*v.y - 0.0018                  # impulse velocity, gravity-like
V += a + v ;  if V.z > -6: V.z = -6, v.z = 0
collide(V,P)                                              # 0x804632bc, below
if mode != 0:                                             # rally
    P.x += 0.05*(V.x-P.x) ; P.z += 0.05*(V.z-P.z) ; P.y = V.y
    handOffset (0x320 vec) -> toward lateralStance(side) by <= 0.04 per update (0x80463a68)
    anchor(0x58) = P + R*handOffset
else:                                                      # mode 0: serve stage, animation/anchor driven (section 4)
```
Collision/bounds (0x804632bc): the table box (from 0x8045a368, half height extended by `1.5+2.5*pose[0x32c]`) is an obstacle (push-out accumulated per axis as min/max, applied to both V and P);
the walkable area is the ellipse **sqrt((1.26315784*x)^2 + z^2) <= 48** (x semi-axis ~38.0, z 48): outside it positions are scaled back by `(48-r)/r` and added to V,P.
`lock` (pose[0x318]) is set in the hop routine 0x80461eac to `int(110*t + 90)` (90..200 updates) with `t = clamp((q.y' - 7)/6, 0, 1)`, q'=ball(+40 steps) height above the body: after a stroke the player stops chasing for 90-200 updates (INFERRED purpose; value path RECOVERED).
Hop/lean impulse (0x80461eac): with `t1=clamp((q.y'-7)/(15-7),0,1)` in mode 0 -> `v.y = 0.13*t1`; in rally `|d|` ramps (3..15) give `v.xz = 0.25*f*t*dir(...)`, `v.y = 0.08*f*t`, and `v.y` also raised to `0.12*t2` (t2 over 7..13). Crouch parameter (slot 4): `c += 0.15*((2.3*clamp((ball60.y+5)/10,0,1) - 2) - c)` while `-200 < ball.step-hitTime < 10`.

**Cadence (INFERRED, strong):** `speed 0.07`, reach profile `s*t` (t in ball steps), `T` in ball steps, 0.995 damping and 90-200 lock counters are all consistent only if the pose update runs once per **ball sub-step (4 per 60 Hz frame)**. `scene[0x14c]=4` and `ball[0x180]+=1` per `0x8046b834` call are RECOVERED; the scheduler that calls the pose 4x per frame was not located. If it runs per frame all rates quoted here are per-frame instead.

## 6. Facing / yaw (RECOVERED)
`0x80463888(pose,basisA,basisB,pos,flag)`: forward = normalise(-pos.x, 0, 8 - pos.z) i.e. toward the table point **(0, z=8)** on the opponent half. With `flag=pose[0x3c4]!=0` forward = (ballLocal.x - pos.x, 0, ballLocal.z - pos.z) toward the ball. `pose[0x3c4]` is set to 1 when Player.mode==2 and `ball-owner state` (player[0x84][0x184]) is not 1/2, and cleared in reset.
Smoothing: moving (|vel.xz| >= 0.01) -> `dir (0x338) lerp toward heading by 0.5*|vel|` then `forward(0x3c) lerp toward dir by 0.01`; basis rows lerp toward target by **0.01 per update**; y flattened. Not moving: basis lerps toward the target at 0.01 and forward copies the stored `0x7c`. (Exact basis assembly via 0x8003f820 cross products - not re-derived.)

## 7. Hit zone / reach relative to the body (RECOVERED values, usage partly INFERRED)
* Body-to-contact offsets for target selection: section 4 (forehand 5.5 lateral / -3 depth for a right hander, backhand -4 / -3.5).
* Racket anchor used by the swept racket test: forehand (9, 7, 5.5), backhand (-12, 7, 7) in body-local axes (left hander x negated), added to pose pos; blade box half-extents (1.65, 0.16, 1.73); ball radius 0.452; swept in 8 substeps between previous and current frame (0x80466100, `r10=8`, requires swing-active flags at `racket[0x1a4]`/`[0x190]`).
* CPU swing gate: swing is considered when |ball(+30 steps) - hand anchor (0x8045f3cc)| < **30** units (0x8047c7e4 / 0x8047c75c), so effective reach is ~30 units around the body anchor, but the position logic of section 4 normally puts the contact 4-5.5 units to the side.
* The 45/75 "active counter" and swing window in FINDINGS stay as is (racket_swing_window.asm).

## 8. CPU controller / AI (RECOVERED unless noted)
**Data**: `cpu/Sp2PngCpuData.exbin`, header words (1010, 1000, 0x1910, -1), **100 records x 64 bytes** at `0x10 + 64*idx` (footer at 0x1910 is string data). Loader `0x8047e7e8(this, idx)`; ctor `0x8047d634(this, player, idx)`: `idx = -1` -> random `0..9` (`rand % 10`, 0x8047d6c0). CPU records ordering: f4 (speed) falls 1.65 -> 0.1 and f13 (accuracy) falls 1 -> 0 with idx, so **idx 0 = strongest, 99 = weakest (INFERRED)**. The mapping from CPU Mii / match-level to idx is **UNKNOWN** (CPUMii/*.json and RPSysStockedMiiParam are appearance only). Full table: `cpu_records.csv`.
Field semantics (word index in record):
| f | meaning | evidence |
|---|---|---|
| f4 | movement speed factor `f` (section 5) | slot 22 0x8047cdac |
| f12 | skill category 0..2 -> `k`=0/.5/1 (home depth -17/-28/-40, reach profile) | slot 24 0x8047cd80, pose reset 0x80464cd0 |
| f13 | accuracy: lateral aim error `+-5*(1-f13)`, swing delay `int(8*(1-f13))` updates | 0x8047d0f4, 0x8047c82c |
| f2 | ball time-scale multiplier written to `ball[0x220]` (0.9-1.25) | slot 17 0x8047d330 |
| f6 | serve style: 0/1, 2 = random bit | 0x8047d44c |
| f14,f5,f0 (normalised) | P(aim right / centre / left) | ctor 0x8047e8ec |
| f15 / f1 | right / left aim magnitude (aim in `[0.5f15,f15]` or `[-f1,-0.5f1]`, centre = 0.001) | 0x8047e300 |
| f9,f11,f10 (normalised) | P(strength tier high / mid / low) -> value in [2/3,1], [1/3,2/3], [0,1/3] uniform | ctor 0x8047e880, 0x8047e478 |
| f3 | P(focus): if `f3 < rand` the CPU aims at a uniform random point across the table width | 0x8047d1a8 -> `ctrl[0x1b0]` |
| f7,f8 | P(restrained shot) / strength-tier cap applied when `rand < f7` and `ball[0x224]>=0` | 0x8047d220-0x8047d27c |
| (rest) | no other record field read by the code paths traced; any other use is **UNKNOWN** |
RNG (global at `r13-0x3010`, two words s0,s1): `s0 = s0*0x41c64e6d + 0x3039; if (s1&1) s1 ^= 0x11020; s1 >>= 1; r = ((s0 ^ s1) >> 1) & 0xFFFFF; u = r/1048575.0`. Signed variant `(r - 0x80000)/524287`.
Per-point decision (reset `0x8047cf10`): `0x1a8 = u` (aim lerp), `0x1ac = raw` (bit0 = mirror), `0x1cc = tier` (0x8047e478), `0x1d0 = laneAim` (0x8047e300), `0x1c0 = -laneAim`, `0x194 = 5*(1-f13)*signed`, `0x1b0 = (f3 < u)`, `0x1b4/0x1c0/0x1cc` cap as above, `0x1b8 = (u < 0.1)`.
Landing target (0x8047c940, RECOVERED): `fx = 0.5*18.3 - 1 = 8.15`, `fl = fx - 5 = 3.15`, `a = ctrl[0x1a8]` (uniform draw).
```
if ctrl[0x1b0]:            x = -fx + a*(2*fx)                    # uniform across the width
else: xp = -(player local x)
      if xp >= 5:   x = -fl - a*(fx-fl)                           # [-8.15,-3.15]  (player far to its left -> same lane)
      elif xp <= -5: x =  fl + a*(fx-fl)                          # [ 3.15, 8.15]
      else:         x =  fl + a*(fx-fl); if (ctrl[0x1ac]&1) x = -x  # random lane
x += ctrl[0x194]           # +-5*(1-accuracy) error, unclamped
target = (x, 0, 9.0)       # local frame, opponent half
```
CPU state machine (PTMF table 0x806dab58, state in `ctrl[0x4c]`): 0 `0x8047c57c` evaluate/aim, 1 `0x8047c564` countdown `ctrl[0x1c4]` -> swing, 2 `0x8047c4ec` after swing (return to 0 when player not in mode 0 and ball state not 1/2), 3 `0x8047c438` pre-serve wait (`0x1a4 = 120` updates, then random `0x1d8`), 4 `0x8047c3a8` (when ball z<0 & |y|<4: grab side, set state 2).
State 0: if Player.mode==0 -> state 3. Takes ball in local space; on first inbound sample starts the react animation; ignores while `ball.local.z >= 0.5*32.796` (ball not past the net-side of its half). Computes `0x8047ca7c` = {0 swing now,1 wait,2 ...}: shifts a 12-entry history, checks the ball velocity direction against the aim direction from ball to landing target; for result 2 requires `|ball(+30) - hand| < 30`; when ball flag `[0x250]&2` is set it arms the swing with delay `int(8*(1 - f13))` (0 -> immediate `0x8047c890`: `ctrl[0x1c8]=1` then `0x8047d860(anim, side, tier, aim, 120)`).
CPU does **not** teleport a shot: it drives the same racket pipeline with a synthetic swing: virtual controller outputs `[0x2c]=tier(0x1cc)`, `[0x30]=aim(0x1d0)`, `[0x34]=1`, `[0x38]=zero vec`, `[0x40]=-1`, `[0x74]=anim.twist (0x8047e148 object +0x24)`; the synthetic orientation generator (`0x8047e148` object: 100-entry history, `0x8047dbf8`) uses swing speed `5 + tier*(15-5)`, start angle offset `+-(0x68 - 120)` clamped +-180 and lateral twist `+-20*aim`. Shot parameters then come from the shared shaping/launch code (FINDINGS section "Shot-input preprocessing").
Error model summary: (1) lateral aim noise `+-5*(1-f13)` table units; (2) random lane/tier draws; (3) with prob `(1-f3)` fully random lane; (4) swing delay up to 8 updates; (5) category `k` limits reach profile & home depth; (6) f4 limits chase speed; (7) 10% flag `0x1b8` (purpose UNKNOWN).

## 9. Human vs CPU, serve vs receive (RECOVERED)
* Same PoseRally chases the ball for both. Differences: `speedFactor` (human 1.0, CPU `rec.f4`), category (human 3 = dynamic `k`; CPU 0..2 fixed), stance side (human from swing recogniser type `[0x1ac]`; CPU evaluates both), home depth after a hit (`k`-dependent, so human depth moves with `k`).
* Mode 0 server: position driven by the serve anchors and the remote twist (section 4); non-server receiver stands at (0,-6,-26) until ball inbound (mode 2 + ball state 3/4).
* After the player's own swing: 90-200 updates lock (no chase), then go-home target (section 4) with speed cap 0.04.

## 10. Per-update pseudocode for the port
See sections 4-6 (all formulas are executable as written). Skeleton:
```
tick (4x/frame):
  if ball inbound toward me (state 3|4, lastHitter!=me, pose.chase): target,hitTime,side = pickTarget()   # sec 4
  mainUpdate()                                                                               # sec 5
  faceUpdate()                                                                               # sec 6
cpu per-point: draw (aim,tier,error) with RNG; cpu per tick: state machine sec 8
```

## 11. Unknowns / low confidence
* Scheduler cadence (4 pose updates per frame) - INFERRED, not proven.
* Mapping CPU Mii/level -> record idx; direction of "difficulty" ordering of records (INFERRED).
* Exact `0x80462648` stance-order tests, `0x8047ca7c` swing-gate geometry, `0x8047c940` lane branch, meaning of record f3/f7/f8 beyond what is written, 10% flag `0x1b8`.
* Pose #2 (0x806daac8) and controller 2; exact sign convention of the stance z offset (body = ball + R*offset assumed).
* Wall-slide normal (`pose[0x3b0..]`) source, 0x80462d48 lead vector `f0` exact definition, facing basis assembly.
* The seed/initialisation of the global RNG at `r13-0x3010`.
