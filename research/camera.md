# Wii Sports Resort Table Tennis - gameplay camera (USA Rev 1 main.dol)

Labels: **RECOVERED** = read from instructions/data at the cited address (static analysis only; no emulator run);
**INFERRED** = deduced from structure/plausibility; **UNKNOWN** = not resolved. Addresses are virtual (r2=0x806fe080, r13=0x806f8120).
Floats = big-endian IEEE754 read from the cited address. Nothing here was validated against a running game.

Reproduce: `py -3 -B research/tools_camera/cam.py fn|d|callers|xr|f32 ...` (wraps `pingpong/tools/ppc_probe.py`),
`emu.py` (scalar-FPU interpreter, used to prove the matrix helper 0x80327664), `ref_maincam.py` (host-float reference of the main
camera below), `survey.py/news.py/vtabs.py/sjis2.py` (discovery). Raw dumps: `dump_*.txt` (main target, main update, feed, intro,
result, replay a/b/c, base).

MAP.txt gives nothing useful for 0x8045xxxx (all anonymous). Class names come from Shift-JIS strings that follow each vtable
(0x806d9a98 "camera manager", "main camera", "demo loop", "camera base", "intro camera", "replay camera", "result-screen camera").

## 1. Structure (RECOVERED)

`scene = *(r13-0x2988)` (PngScene, built by 0x804564e8). `CM = scene[0x158]` camera manager (ctor 0x80456df0). `CM[0x44]` = camera set
for view/seat 0, `CM[0x48]` for seat 1 (0xBC-byte objects, ctor 0x80457004; arg stored at `+0x90` = **side flag 0/1**). Each set holds
five cameras selected with `0x80456f04(set, idx)` (instant switch: old->vt[0x20] (no-op), new->vt[0x1c] "OnEnter", 0x80322fdc):

| idx | obj field | role | vtable | OnEnter (+0x1c) | Update (+0x18) | Init/Reset (+0x14) |
|---|---|---|---|---|---|---|
| 0 | +0x94 | **main (serve+rally)** | 0x806d9ab0 | 0x804578c0 | 0x80457654 | 0x8045794c |
| 1 | +0x98 | demo loop (plays SCN0 WS2_png_cam_op/ed) | 0x806d9ae8 | - | 0x80457b64 | 0x80457bd8 |
| 2 | +0x9c | intro | 0x806da1c8 | - | 0x80471748 | 0x80471898 |
| 3 | +0xa0 | replay | 0x806da2b0 | - | 0x80475aa8 | 0x804763ac / 0x80476414 |
| 4 | +0xa4 | result screen | 0x806dab20 | - | 0x8047c0b0 | 0x8047c2ac |

Which state selects which (call sites of 0x80456f04): match start 0x80480bf0 -> idx0 for both seats; state 0x80480d2c -> idx2 (intro) for both seats
with `intro[0x50]=player` and `CM split flag = 1` (0x8037f024); state 0x8047ffc8 -> idx3 for seat 0 with `replay[0x50]=scene[0x170][0x18]`
(the ball); idx4 at 0x804815e4; idx1 at 0x8047ff30/0x80480fe8/0x804613d0. The *events* that trigger the replay and result states were
not decoded: UNKNOWN (so "point end" camera behaviour is UNKNOWN; during the normal match the main camera simply keeps running with
flag=0 after the serve - see below).

### Base class (0x80322e4c, getter 0x80322d40, reset 0x80322dac) - RECOVERED
```
+0x0c Vec3 pos | +0x18 Mat33 basis = rows right,up,back (camera looks along -row2) | +0x3c fovY deg (def 50) | +0x40 near (def 0.5)
+0x44 far (def 110000 = 0x47d6d800 @0x806fb358) | +0x48 fov scale (def 1.0)
```
Reset sets those defaults and then calls vt[+0x14] (subclass init). Per frame (0x80323048): `cam->vt[0x18]()` (update), `GetPose`, world matrix
`W=[basis^T|pos]` (0x80327f60: the three basis rows become the matrix COLUMNS), fovY=cam.fov, **if r13-0x37e8==0 (4:3) fovY *= cam.scale(+0x48)**,
near=+0x40, far=+0x44 (0x801be894 + stores to proj+0x18/+0x1c), aspect = viewport w/h.
r13-0x37e8 is the aspect mode (table @0x806b4ad8, u16 w,h per 12 bytes: 0:608x456 (4:3), 1:832x456 (16:9), 2:640x456); split-screen halves width
(0x8037f024 stores `CM[0x24]=CM[0x28]=splitFlag`). No dt anywhere: all rates below are **per update (60 Hz game frame)**.

## 2. Main camera constants (RECOVERED)

| value | where | meaning |
|---|---|---|
| fovY 33.0 | 0x8045795c `lfs [0x806feda0]`=0x42040000 | vertical FOV (deg), stored in cam+0x3c |
| near 10.0 | 0x80457954 `[0x806fed78]` | cam+0x40 |
| far 110000 | base default | cam+0x44 (never overridden by main cam) |
| fov scale | 0x80457920: `CM[0x24]!=0 ? 1.1666667 (0x3f955556 @0x806fed9c) : 1.0` | applied only when aspect mode 0 (4:3) => 38.5 deg for split 4:3, else 33 |
| ramp speed 0.008 | [0x806fed98] 0x80457678 | cam+0x94 changes 0.008 / frame toward 1 (flag) or 0 |
| O0 = (0,14,0) | static init 0x80457b14 -> BSS 0x807d3508 | offset at ramp 0 |
| O1 = (0,10,-8) | -> BSS 0x807d3514 | offset at ramp 1 |
| follow = (0.1,0.1,0.1) | -> BSS 0x807d3520 | per-camera-axis position lerp |
| pitch = -20 + 15*e (deg) | [0x806fed60]=-20, [0x806fed64]=15 (0x80457270..0x80457284) | -20 deg at ramp 0, -5 deg at ramp 1 |
| yaw 180 deg | 0x80457288 `lfs [0x806fed6c]`=128.0 (FIdx, 256/turn) | camera faces opposite the player's frame |
| orbit distance 40.0 | [0x806fed74] 0x804572f4 | camera = lookpoint + 40*basis.row2 |
| anchor floor y = -6.0 | 0x8045a438 returns [0x806fee04] | player floor (table top is y=0) |
| Q lift 10.0 | [0x806fed78] 0x80457348 | second framing point = T+(0,10,0) |
| orientation slerp 0.05 | [0x806fed88] 0x80457734 | per frame, Mat33->quat slerp (0x80326d10 / PSQUATSlerp 0x8003fc80) |
| sidestep 0.2, dolly 0.05, tilt step 0.01 deg | [0x806fed84],[0x806fed88],[0x806fed80] | framing solver |
| solver passes | `cmpwi r24,0x1c2; ble` 0x8045760c | 451 max |
| frustum margins lo/hi | 4:3: 0.8/0.9 ([0x806fed4c],[0x806fed48]); else 0.85/0.95 ([0x806fed54],[0x806fed50]) | |
| frustum top 0.7, bottom 1.0, inside bias 0.5 | f8=[0x806fed58], stack arg [0x806fed5c], z-bias -0.5 [0x806fed7c] | |
| ease e(t) | 0x80326180(t,1.0) = 0.5*(1-cos(pi*t)) | cosine ease-in-out |

## 3. Per-frame algorithm (RECOVERED; matrix conventions verified with emu.py)

Inputs refreshed every frame by the player update 0x8045fa18 (called for both players via 0x80460e1c):
```
T    = mirror(seat, (model.x, -6.0, model.z))   model = player[0xbc], x=[+0x58] z=[+0x60]; y forced to 0x8045a438() = -6
B    = player has a ball ? predictedBallPos[ball.cursor+20] : (0,0,0)   0x8045eb98 -> 0x8046a47c(ball,0x14)
       (record = pred+8+idx*0x24, idx clamped to the recorded range; (0,0,0) is the table centre)
P    = Mat33(mirror(seat, model[0x64]), mirror(seat, model[0x70]), mirror(seat, model[0x7c]))   (assumed identity before mirror: UNKNOWN if body ever rotates)
flag = (player[0x18] == 0)      // 0 = this player is the server and the serve has not been hit yet (set 0x804601e4: scene[0x17c][0x10]==player idx);
                                // becomes 1 when the serve is hit (0x8045e4bc), 2 at 0x8045e2d0
mirror(seat,v) = seat==0 ? v : (-v.x, v.y, -v.z)      // 0x8045e788, seat = player[0x28]
```
Serve-wait position of the model (0x80464b48..0x80464b6c): x = +-4.5 (sign from scene[0x180][0x1c]), y=-6, z = -17.0 ([0x806f21f0]) in seat-local space,
i.e. just behind the table end line (table half length 16.398). During rally model[0x58..0x60] = body pos + displacement vec at model+0x320 (0x80464c4c).

```
update():                                  // 0x80457654, once per game frame
  ramp = clamp(ramp + (flag ? +0.008 : -0.008), 0, 1)
  (Ppos, Mdes) = target()
  basis.row0 = Mdes.row0                              // immediate
  basis.row2 = normalize(basis.row0 x basis.row1)     // (len==0 -> Mdes.row2)
  basis.row1 = basis.row2 x basis.row0
  basis = slerp(basis, Mdes, 0.05)                    // rotation matrices <-> quaternions
  d = Ppos - pos
  pos += 0.1*dot(d,row0)*row0 + 0.1*dot(d,row1)*row1 + 0.1*dot(d,row2)*row2     // == pos += 0.1*d (orthonormal basis)
  // fovY etc. fixed (33 / 10 / 110000); scale rule in section 1

onEnter():  ramp = flag ? 1 : 0; (pos, basis) = target() directly (no smoothing); scale = CM[0x24]?7/6:1     // 0x804578c0

target():                                 // 0x80457164
  e     = 0.5*(1-cos(pi*ramp))
  pitch = -20 + 15*e                      // degrees; negative = looking down
  R     = RotXYZ(pitch, 180, 0)           // nw4r MTX34RotXYZ, column-vector, R = Rz*Ry*Rx  (convention INFERRED, see Confidence)
  Mdes  = transpose(R) * P                // stored 3x3 rows; world matrix W = P^T*R; look dir = -Mdes.row2
  O     = lerp((0,14,0),(0,10,-8), e)
  O'    = O.x*P.row0 + O.y*P.row1 + O.z*P.row2     // offset in the player's frame
  Ppos  = T + O' + 40*Mdes.row2           // camera looks at T+O' from 40 units away
  Q     = T + (0,10,0)
  frustum(fovY=33 (unscaled), aspect=w/h of this seat's viewport, mL,mR, top .7, bottom 1.0):
      lo,hi = (4:3) ? (0.8,0.9) : (0.85,0.95);  seat0: mL=lo,mR=hi ; seat1: mL=hi,mR=lo
      tan=tan(fov/2), tx=tan*w/h; corners (z=-1): C1=(tx*mR,-tan*1.0) C2=(tx*mR,tan*.7) C3=(-tx*mL,tan*.7) C4=(-tx*mL,-tan*1.0)
      planes (outward, normalised): left=C3xC4 right=C1xC2 top=C2xC3 bottom=C4xC1;  p outside plane n  <=>  dot(n,p_view)+0.5 > 0
      p_view = inverse([Mdes^T|Ppos]) * p        // camera space, -z forward
  f30=0; last=-1
  for pass in 0..450:
      V = view(Ppos, Mdes)
      pb = V*B: top->r22 ; bottom->r21 ; left->r23=0 ; right->r23=1      (r23=-1 if none)
      pq = V*Q: left->r20=0 ; right->r20=1                                (r20=-1 if none)
      if !r22 && !r21 && r23<0 && r20<0: break
      if r22: f30 += 0.01 ; Mdes = transpose(RotX(f30 deg)) * Mdes        // local pitch-up by the ACCUMULATED f30 each pass
              if !r21 && r23<0 && r20<0: continue
      dolly = r21 ; dir = 0
      if !dolly: if r23>=0 { dir=r23 ; if r20>=0 && r20==(r23^1) dolly=true } else if r20>=0 dir=r20
      if !dolly && (dir^1)==last: dolly = true
      if dolly: Ppos += 0.05*Mdes.row2
      else:     last=dir ; Ppos += (dir? +0.2 : -0.2)*Mdes.row0
  return (Ppos, Mdes)
```
(The plane tests inside 0x8035f048 are staged: near(1)/far(2) ignored; after a left failure right is skipped, after a top failure bottom
is skipped. Opposite planes cannot both fail so this has no practical effect.)

## 4. Serve vs rally vs seats (RECOVERED unless noted)
- **Serve** (flag=1, only for the server before the hit): ramp -> 1 over 125 frames (2.08 s at 60 Hz, cosine eased): pitch -5 deg, look point 4 units lower and 8 units
  toward the player's back; with the serve stand z=-17 the camera ends about 7.5 units above the table plane (y), ~48 units behind the table end line.
- **Rally / receiving / after serve** (flag=0): ramp -> 0 over 125 frames: pitch -20, look point 14 above T, camera ~21.7 high and 37.6 behind T.
  Lateral follow is 1:1 with the player's x (T), low-passed at 0.1/frame, plus solver nudges of up to 0.2/pass to keep the predicted ball (index+20) and the player's upper body Q inside the 80-90% frame.
- **Seats**: seat 1 is the seat-0 camera rotated 180 deg about Y via `mirror` (T, P and therefore O' are mirrored; the camera yaw comes out opposite automatically because Mdes=R^T*P). The only explicit asymmetry is the frustum side margin: seat 0 uses (mL,mR)=(lo,hi), seat 1 (hi,lo), i.e. the narrower 0.8/0.85 side is the camera-left for seat 0 and camera-right for seat 1.
- **Point end**: main camera has no dedicated point-end code; the player flag leaves 0 -> ramp relaxes to rally pose. B follows the next ball or (0,0,0). Replay/result cameras: sections 5-6.
- Sanity numbers (ref_maincam.py, player (2,-26) seat0, ball (3,3,5)): ramp0 pos=(2.0,21.7,-63.6) look=(0,-0.342,0.940); ramp1 pos=(2.0,7.5,-73.9) look=(0,-0.087,0.996); seat1 mirrors x,z.

## 5. Intro camera (idx2, 0x80471748) - RECOVERED
Per update, no smoothing. `Pp`=player pos (mirrored bc+0x0c, 0x8045f35c), `Pb`=player basis (mirrored bc+0x24, 0x8045f320), seat s=set[0x90].
```
R    = RotXYZ(pitch=-5 deg [idx -3.5556 @0x806ff220], yaw = s==0 ? -25 : +25 [0x806ff218/21c], 0)
basis= transpose(R)*Pb
off  = (s==1 ? -2 : 2, 8, 0) [static 0x807d3668 set by 0x8047192c: (2,8,0)] rotated into player frame (v.x*row0+v.y*row1+v.z*row2 of Pb)
pos  = Pp + off + 23.0 * basis.row2     [0x806ff22c]
fov  = base default 50 (not overridden), near 0.5, far 110000
```
Camera sits in front of the player (table side) looking back at the avatar, 23 units away.

## 6. Result camera (idx4, 0x8047c0b0) and replay camera (idx3, 0x80475aa8)
Result (RECOVERED): +0x60 flag selects mode. Mode 0: target pos/basis come from pointers +0x50/+0x58 (default zero/identity), pitch -0.52 deg
([0x806f22a0]), yaw = [r13-0x292c] (never written, i.e. 0), distance 21.0 ([0x806f22a4]). Mode 1: target = midpoint of *(+0x50) and *(+0x54), basis from
0x80326e44(*(+0x58),*(+0x5c)) (blend), pitch -3.0 ([0x806f2298]), yaw [r13-0x2930]=0, distance 23.0 ([0x806f229c]). Offset (0,7,0) both modes (static init 0x8047c374 -> BSS 0x807d37d0/0x807d37dc).
Same formulas: `basis=transpose(RotXYZ(pitch,yaw,0))*B`, `pos = target + offset(rotated by B) + dist*basis.row2`. fov = default 50. Which player/targets are bound: UNKNOWN.

Replay (PARTLY RECOVERED): fixed camera positions chosen at random from a table (static init 0x80476598, BSS 0x807d36f0):
P0=(60,20,0) P1=(50,20,50) P2=(50,20,-50) P3=(37,55,80) P4=(37,75,-80). Pick = glibc-style LCG seed r13-0x3010 (x*0x41c64e6d+0x3039) `%5` when cam+0xa4 is set (reset sets it), done by 0x804758d8.
Look-at: row2=normalize(pos-ball) with ball = target obj + 0x204 (Vec3), row0=normalize((0,1,0) x row2), row1=row2 x row0 (fallbacks (0,0,1),(1,0,0)).
fovY: target = clamp(30*(75/dist)^2, 5, 30) (consts 30 [0x806f221c], 75 [0x806f2218], 5 [0x806f2220], exp/ln trick at 0x80475c28..0x80475c64), fov += 0.1*(target-fov) (0.1 [0x806f222c]).
On top is a simulated "camera operator" that adds lagging aim offsets (yaw/pitch state at +0x78/+0x7c/+0x80/+0x84, clamp +-80 deg [0x806f2248], step limit lerp(1.5,0.25,|off|/80)
[0x806f224c/0x806f2250], 0.05 smoothing [0x806f2228], random re-aim every 10 frames [0x806f2240] using the same LCG, 0.5/0.2/0.002 constants) - exact formulas NOT decoded.

## 7. Demo camera (idx1) and SCN0 data
Demo camera (0x80457b64) = pose of the g3d SCN0 camera animation (pos=Mgr+0x24, rot=Mgr+0x30 filled by 0x80323048 from the scene-owned ResAnmScn; local offset +0x50 zero, rot identity). SCN0 (assets/animations/.../WS2_png_cam/*.scn0.json, aim-type, hermite):
op_00 loop 4000 frames: fovY 40, near .01, far 1e5, y=60.305 const, XZ orbit radius ~83.3 around origin, aim y=54.153 radius ~75.5; ed_00 961 frames: fov 40, pos (-141.3..-103, 110.8, 0..-96.7), aim (-133.4..-97.2, 104.7, 0..-91.3);
ed_01: fov 29.863, pos (-314.2..-355.2, 30.4, 450.6..324.0), aim (-307.4..-348.4, 29.9, 445.2..318.6).

## 8. Confidence
| item | status |
|---|---|
| class structure, camera indices, base layout, submit path | RECOVERED (high) |
| FOV 33 / near 10 / far 110000, 4:3 and split scaling, aspect table | RECOVERED (high); meaning of CM[0x24] = split-screen flag INFERRED (set by 0x8037f024 from player count) |
| ramp 0.008, ease cosine, pitch -20..-5, O0/O1, distance 40, lerp 0.1, slerp 0.05 | RECOVERED (high) |
| framing solver rules (margins, 0.2/0.05/0.01, 451 passes, oscillation guard) | RECOVERED (high); plane ordering/outward sign derived by hand from 0x8035f308 (medium-high) |
| Rz*Ry*Rx convention of 0x8013c2f0 | INFERRED (medium): chosen because it makes both seats look downward; the alternative order would look UP 20 deg. Not emulated (paired-single/GQR table code). |
| 0x80327664 = out = B3x3^T * A (R^T*P) | RECOVERED (verified by emulation) |
| mirror/seat handling, intro/result formulas | RECOVERED (high) |
| player model[0x58..]/[0x64..] semantics, whether P is ever non-identity | INFERRED |
| prediction record spacing for B (index+20) | UNKNOWN in seconds (assume one per sim tick) |
| triggers for replay/result/point-end cameras, replay operator wobble, flag value 2 meaning | UNKNOWN |
| all rates per 60 Hz game frame | INFERRED (no dt found) |
