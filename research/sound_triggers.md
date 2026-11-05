# Wii Sports Resort Table Tennis - sound triggers and parameters (game-code side)

Target: USA Rev 1 `assets/code/original/main.dol`. Virtual addresses; r2=0x806fe080, r13=0x806f8120.
Labels: **RECOVERED** = read directly from disassembly (address given), **INFERRED** = deduced, **UNKNOWN** = not resolved.
No emulator was used. Sound names/IDs come from `assets/manifest_sounds.json` (`sounds[]`, brsar index == the numeric ID the code passes;
verified: 0x398=920=SE_PNG_THROW_UP, 0x3d6=982=SE_PNG_SMASH_SHOT, 0x3b6=950=SE_PNG_BALL_HIT_NORMAL ... the numbers line up exactly).
`0x802b751c` (the logical-to-brsar ID translation) is a bare `blr` stub, so ID in code == brsar ID.

Reproduce: `py -3 pingpong/tools/ppc_probe.py dump A B`; helpers in `research/tools_sound/`:
`scan_li.py lo hi` (all `li rX,imm` in a range), `callers.py` / `callers2.py lo hi target...` (call sites of the sound wrappers with the preceding `li` args),
`scan_off.py lo hi disp` (loads/stores with a displacement), `scan_data.py`, `ctx.py addr...` (disasm context), `callers_png.txt` (output),
`d_80467600.asm` (hit sound function), `d_8046c6a4.asm` (bounce sound function), `d_ball_all.asm` (ball update/collision), `d_80467030.asm` (shot builder).

Companion notes: `movement.md` (object model, racket anchors), `animation.md` (avatar states/StartSwing), racket port `tools_racket/port.py`
(it already ports the racket `+0x194` low-pass used below as `a194`).

---------------------------------------------------------------------------------------------------

## 1. Sound engine facade (RECOVERED)

Global sound system `S = *(r13-0x3098)` (r13 = 0x806f8120). All game code calls thin wrappers at 0x802b72xx-0x802b73xx:

| wrapper | args | meaning |
|---|---|---|
| `0x802b72dc(emitter, id)` | plain start on an *emitter* (SoundActor-like object; table-tennis players/balls keep it at `obj+4`) | no volume/pitch/seq-variable applied |
| `0x802b72d8(emitter, id, f1, f2)` | start + apply params | -> `0x802ba2b8(..., r6=1)` then `0x802bf834(handle, f1, f2, id)` |
| `0x802b72c8(emitter, id)` | start non-held loop-capable (used for SEABREEZE) | `0x802ba170` |
| `0x802b73bc(id)` | global/2-D start with no emitter | `0x802baff0` -> `0x802bb404` |
| `0x802b735c(id, mask)` | global start **and route the voice to Wii Remote speakers in `mask`** (bit n = WPAD channel n) | `0x802bb2e4`: starts, then `0x802b941c(S+0x5f8, handle, mask)` |
| `0x802b732c(id, fadeFrames)` | **stop** all instances of `id` | `0x802bb0ec` -> `0x802b7c38` (used as stop WHISTLE_MISS before WHISTLE_END at 0x8048123c) |
| `0x802b7228(streamId)` | start a STREAM (BGM/jingle), STM_PNG_* are 33..42 | vtable +8 of `S+0x5ec` |
| `0x802b7208(streamId,...)` | stream variant (60 / 120 used at 0x80480308 / 0x80481aa0; meaning UNKNOWN, probably fade/stop) | vtable +0xc |
| `0x802b7298(id, a, b)` | narrator/voice start with 2 integer args (score digits) | `0x802b8fc8(S+0x60c, id, a, b)` |
| `0x802b6ec8(player, f)` / `0x802b6ed4(player, f)` | set per-SoundPlayer(group) parameter `+0x58[0]` / `+0x30` | see section 5.8 |

`0x802bf834(handle, f1, f2, id)` applies parameters according to the low byte of the sound's brsar *user param*
(`0x80154e90(S+0x114, id)` = `SoundArchive::GetSoundUserParam`):
bit0 -> `SetVolume(f1, 0 frames)` (0x80146360, clamped >=0), bit1 -> sequence variable 0 = (s16)f1 (0x80151a80), bit2 -> `SetPitch(f2)` (0x801463f0),
bit3 -> sequence variable 1 = (s16)f2. (RECOVERED code.) The per-sound user-param byte itself lives in the brsar, which is not in the supplied
assets (only the derived `manifest_sounds.json`), so **which bit each sound has is UNKNOWN**. For BALL_BOUND_NORMAL the converted MIDI is one note
(key 0x1a, vel 127, two identical tracks) with no variable logic, so f1 can only act as bit0 volume there (INFERRED).
Every game call passes **f2 = 0.0**; only f1 carries data (an intensity 0..1).

Emitter start (0x802ba2b8, RECOVERED): `if (cooldown_blocked(emitter,id)) return 0` (0x802b9bbc); handle = pool alloc (0x802b7e84);
`SoundActor::StartSound`-like 0x8015a880; if param flag -> 0x802bf834; then `SetFxSend(bus 0, emitter[0xa4])` (0x80146480; emitter[0xa4] defaults 0.0,
set by the emitter fade code 0x802ba4dc); if mask -> remote routing 0x802b941c.
`0x802b941c` reads the brsar user-param bytes 1..3 (`(p>>8)&0x7f`, `(p>>16)&0x7f`, `(p>>24)&0x7f`, each /127) as three remote-output send levels
(0x802b9248) and applies them to the voice for the remotes in the mask, only if `(p & 0xffffff00) != 0`.

Cooldown (0x802b9bbc, RECOVERED): a per-emitter table of 8 counters (`emitter+0xac+4*slot`, decremented once per emitter tick by 0x802ba4dc).
Among all ids that table tennis uses **only ids 0x3fd..0x401 (1021..1025 SE_PNG_CAN_BOUND_*) are throttled**: they share one slot with a 3-tick
cooldown (`[806f1188]=3`). SE_PNG_* ids 920..1020 have no throttling at all.

Replay note (RECOVERED): `scene[0x188]` is the replay/event recorder (`0x803675a8(rec, eventType, matrix, flags)` only records when `rec[0x24]==1`;
`rec[0x24]==2` = playback). Swing whooshes (both) and WHISTLE_MISS are skipped when `rec[0x24]==2` (0x80465c78, 0x80465dbc, 0x804792b4).
Whether the replay re-triggers hit/bounce sounds is UNKNOWN (events recorded: 3 = racket hit {flags 1 smash, 2}, 10 = face hit, 4 = fault, 0xb/0xc = point; effects only).

Sound players (manifest `player` field) give the logical groups: 7 = ball (hit/bound/smash/can), 5 = swing/steps/throw, 4 = whistles/prepare/serve-switch/rally score,
8 = audience, 12 = narrator.

---------------------------------------------------------------------------------------------------

## 2. Event -> sound table (summary; details and conditions in section 5)

Vol/pitch column: "none" = `0x802b72dc`/`73bc` (no params). "f1=" is the intensity passed to `0x802b72d8`; f2 is always 0.

| # | event | call site (function) | sound id(s) | params |
|---|---|---|---|---|
| 1 | Racket hits ball (blade face or rim), not smash | 0x80467968..0x8046798c (hit fn 0x80467500) | 950 HIT_NORMAL / 952 HIT_DRIVE / 951 HIT_CUT; SLIPPER variants 958 / 960 / 959; + CSPK 954/956/955 (slipper 962/964/963) | none; selection by `racket[0x194]` (>=0.4 DRIVE, <=-0.4 CUT) |
| 2 | Racket hit flagged smash | 0x8046771c, 0x8046773c..0x804677c8 | 982 SMASH_SHOT (always) + 953 HIT_SMASH (slipper 961) + CSPK 957 (slipper 965) + 992 AUDIENCE_SMASH + venue 1000 / 1006 | none |
| 3 | Table / ground / net bounce | 0x8046c754 etc. (ball fn 0x8046c6a4) | 942 BOUND_NORMAL (table), 949 BOUND_SMASH (layer on 1st bounce after smash), 944 BOUND_NET, 943 GROUND, 945 LAWN, 946 WATER, 947 MAT, 948 WOOD | f1 = impact intensity 0..1, f2 = 0 |
| 4 | Swing whoosh | OnSwing 0x8045e554 -> 0x80465ab8 | 981 SWING_L if swing predicts contact, else 980 SWING_S (+ none when replay) | none |
| 5 | Big lunge swing (SP3) | StartSwing 0x8045b008 | 983 JUMP_SWING_L + 993 AUDIENCE_SURPRISE + venue 1001/1007 | none |
| 6 | Serve toss start | 0x8045e334 (fn 0x8045e2ec, called from tick 0x8046007c) | 920 THROW_UP | none |
| 7 | Ball caught (state 2) | 0x80469bbc (fn 0x80469ba0) | 922 BALL_CATCH | none |
| 8 | Ball hits an avatar's body/face | 0x8046a2dc (fn 0x8046a07c) | 931 HIT_FACE | none |
| 9 | Footsteps / landings | 0x8045b070 (jump table) | 966/967/968/969/970 (normal) or 975/976/977/978/979 (stone) | f1 = clamp((speed+0.2)*3,0,1), JUMP none |
| 10 | Whistles | 0x80480b7c/0x80481714 start, 0x804792c4 miss, 0x80481244/0x8047f7a8 end | 971 / 972 / 973 | none |
| 11 | Audience during match | see 5.7 | 985..1009, 989..991, 996/997, 924..930 | none |
| 12 | Narrator / score jingles | 0x80477adc, 0x8047f394, 0x8047f634 | 1010 /1011 /1012..1018, streams 33..38 | narrator args = scores |
| 13 | Rally-mode score ticks | 0x80481fe0 | 932 / 933 / 934 / 935 (+ audience 994/995) | none |
| 14 | Return-challenge cans | 0x80486e50, 0x8048677c, 0x80487330, 0x80481ce4 | 1019..1025, 938 | CAN_BOUND f1 intensity |
| 15 | PREPARE prompt | 0x804693d4 | 984 PREPARE (CSPK routed) | none |
| 16 | Seabreeze ambience | 0x8045a554 | 974 SEABREEZE | none |
| 17 | Rally tension mixer | 0x80470a6c | player 8 LPF, players 7 and 5 param | see 5.8 |

IDs never referenced anywhere in the DOL (full scan of `li` immediates and data tables): **921 THROW_UP_CSPK, 923 SERVE_LR_SWITCH** (UNUSED / UNKNOWN trigger).
Also not referenced: 998..1009 far-variants are referenced; all 940/941 far-rank referenced (0x80485274/80).

---------------------------------------------------------------------------------------------------

## 3. Object model facts needed (RECOVERED unless noted)

* `racket` (= Player+0x88, ctor 0x80468cc0, size 0x6d4): `+8` Player, `+0x194` float "twist" low-pass (below), `+0x1b4` contact point (player-local), `+0x1b8` its y,
  `+0x20c/+0x210/+0x214` peak accumulators (FINDINGS), `+0x21c` swing "power" ratio (-1 none), `+0x218` = ball[0x224] copied at a hit.
* `Player[4]` = its sound emitter; `Player[0xd8]` = controller type (0 human remote, 1 CPU, 2 other/non-participating),
  `Player[0x84]` avatar, `Avatar[0x38]` slipper flag (below), `0x8045f2f0(Player)` = WPAD channel of the player's controller.
* `Ball[4]` = ball emitter, `Ball[0x178]` bounces since last racket hit, `Ball[0x17c]` steps since last counted bounce (9999 at reset),
  `Ball[0x188]` per-step collision bits, `Ball[0x190]` (u16) surface material bits, `Ball[0x228..0x230]` mean contact normal, `Ball[0x1ac]` previous velocity,
  `Ball[0x250]` flags (bit0 dead/after-face-hit, **bit1 smash-in-flight**, bit5 last bounce was an edge).
* `scene = *(r13-0x2988)`: `+0x160` match cfg (`+8` match mode: 0 normal, 1 rally challenge; `+0x28` game length selector), `+0x164` table/venue (`+0x7c` = venue size class: 1 mid, 0 large),
  `+0x180` rules (`+0x20/+0x24` score A/B, `+0x28` game state, `+0x30` rally hit count), `+0x184` rally-mode object (`+0x20` current side, `+0x24+4*side` rally score),
  `+0x188` replay recorder, `+0x18c` HUD.
* `0x80471048()` = target score by `scene[0x160][0x28]`: 0 -> 11, 1 -> 6, 2 -> 2 ("T" below).
* **Slipper racket** `0x8045ea8c(Player)` = `Avatar[0x38]`. Set in the avatar ctor (0x8045d850..0x8045d8e0): type 1 (CPU opponent): `n>20 && n%20==1` (n = ctor arg r7);
  type 0 (human): `0x8022f30c(scene,0x200,id)` && match mode==0 && `0x8027ae84(player,4)` (unlock/profile flag). Semantic names INFERRED.

---------------------------------------------------------------------------------------------------

## 4. Hit sound (RECOVERED) - function 0x80467500(racket, ballPrev, contact, pos, smash)

Called from the racket-contact step `0x80468410` (the per-sub-step racket update; `racket` = r29):

```
80468564 r28 = 0x80466100(racket, prevBallLocal, ballLocal, &0x1b4, &0x1c0, ..., 8 substeps)   ; 0 miss, 1 blade-face hit, 2 rim/edge hit
if r28 == 1:  0x80467030(...) builds+launches the shot (writes smash flag via r9 -> [r1+0x10])  ; then 0x80467500(racket, ..., smash=[r1+0x10])  (0x80468744)
else (2):     0x8046b230 physical response (restitution .6 / .2), smash = 0, then the same 0x80467500
```
So **edge hits play exactly the same hit sounds as face hits** (never SMASH). Order inside the same ball sub-step as the contact (no delay): all of 1 -> 2 -> 3 below, then effects.

Smash flag (0x80467030 stores 1 at 0x80467470) requires, in the rally branch (not a serve): `racket[0x21c] < 0`
(0x21c = swing-power ratio; it is set to `clamp((racket[0x1ac]-8)/(9-8),0,1)` only with probability `0.5+0.5*value` per swing via the global LCG at r13-0x3010, else -1 / `racket[0xc0]` for flag 4 of `racket[0xf8]`),
`racket[0x218] >= 0` (copy of `ball[0x224]`), `racket[0x1b8] >= 1.5` (contact height), and `ball[0x22c] >= 0.866` (the ball's last mean contact normal had y >= cos30, i.e. it just bounced on a flat surface).
(Those four sub-conditions RECOVERED at 0x80467388..0x80467468; physical meaning of 0x218/0x21c INFERRED.)

Pseudocode of 0x80467500 sound part:

```
emit = racket.player.emitter            // Player[4]
slip = avatar_slipper(racket.player)     // Avatar[0x38]==1
human = (racket.player[0xd8] == 0)
mask  = 1 << wpadChannel(racket.player)
if smash:
    play(emit, 982 SMASH_SHOT)                                   // 0x8046771c
    if slip: play(emit, 961 HIT_SMASH_SLIPPER); if human: cspk(965, mask)
    else:    play(emit, 953 HIT_SMASH);         if human: cspk(957, mask)
    play2D(992 AUDIENCE_SMASH)
    venue = scene.table[0x7c]; if venue==1 play2D(1000 SMASH_FAR_MID) elif venue==0 play2D(1006 SMASH_FAR_LARGE)
else:
    t = racket[0x194]
    kind = DRIVE if t >= 0.4 elif CUT if t <= -0.4 else NORMAL        // [806f2074]=0.4, compare fcmpo >= / <=
    ids  = slip ? {NORMAL:958, CUT:959, DRIVE:960, cspk:{962,963,964}} : {NORMAL:950, CUT:951, DRIVE:952, cspk:{954,955,956}}
    play(emit, ids[kind]); if human: cspk(ids.cspk[kind], mask)
// effect names used alongside (not sound): smash -> "WS2_png_hit_h", normal -> "WS2_png_hit" at the contact point
// after the sound: audience / tension (section 5.7/5.8)
```
`racket[0x194]` (0x80467f70..0x80467fb0, port in `tools_racket/port.py` as `a194`):
`a194 = clamp(0.015*twist_deg + 0.996*a194_prev, -1, 1)` each update while a swing is active, `*0.98` when idle; `twist_deg = 0x80466bc0(...)*57.2958`
(signed twist of the racket orientation between consecutive frames; same value also drives the racket visual roll `45*a194 + a18c`). The sound therefore
selects DRIVE/CUT from the *smoothed signed racket twist at the contact frame* (|a194|>=0.4). It is NOT the ball spin or ball speed (those never enter the sound choice).

Hit sounds have **no volume/pitch parameter** and the "who hits" only affects (a) emitter (hitter's emitter), (b) slipper set, (c) CSPK gating.

---------------------------------------------------------------------------------------------------

## 5. Details per event

### 5.1 Bounces (RECOVERED) - ball fn 0x8046c6a4(ball), called every ball sub-step right after the ball integration (0x8046caa8 -> 0x8046c03c then 0x8046c6a4)

Ball collision bits are rebuilt each sub-step in 0x8046b834 (cleared at 0x8046b9e8, `ball[0x188]`):

| bit | set by | meaning |
|---|---|---|
| 0x1 | table collider 0x8045a15c, contact normal.y > 0.999999 (0x8046bab8..) | flat table top |
| 0x2 | same collider, normal.y <= 0.999999 | table edge/side |
| 0x4 | same, normal.y <= 0 | underside |
| 0x8 | net collider 0x804599f0 (response 0x8046b230 with restitution/friction .2/.2 if hit-normal comp `[r1+0x84]>0`, else .1/.2) | net |
| 0x10 | field-collider list 1 hit (`table[0x28]` iterator), or list 2 hit with dot < 0 | ground/field |
| 0x20 | list 2 hit (`table[0x2c]`), dot >= 0 | second collider |

`ball[0x190]` (u16) ORs a material mask from the KCL triangle attribute (low 4 bits, `lhzx tbl[attr*2]`): list-1 table @0x8067f300 =
`attr1->0x01 (lawn), attr3->0x02 (ground), attr5->0x10, attr6->0x04 (water), attr8->0x80, attr9->0x08 (mat)`; list-2 table @0x8067f320 = `attr1->0x20, attr3->0x40` (0x40 = "no response" collider).
`0x8046b710` counts a bounce (`ball[0x178]++`) only if `ball[0x17c] > 2` steps passed since the previous one, sets `0x17c=0`, and sets/clears `ball[0x250]` bit5 from bit1 of 0x188.

Intensity: `n = -(ball[0x228..0x230] . ball[0x1ac..0x1b4])` (impact speed along the mean contact normal, world units per ball sub-step, previous-step velocity);
`vol = clamp((n - 0.01) * 6, 0, 1)` ([806ff128]=.01, [806ff12c]=6). Pseudocode:

```
n   = -dot(ball.normal, ball.prevVel);  vol = clamp((n-0.01)*6, 0, 1)
b   = ball[0x188]
if b & 7:                                     // table contact
    if ball[0x178] <= 2 and vol < 0.4: vol = 0.4      // first 3 table bounces never quieter than .4
    if vol > 0: play(ball.emitter, 942 BOUND_NORMAL, f1=vol, f2=0)
    if (ball[0x250] & 2) and ball[0x178] == 1: play(ball.emitter, 949 BOUND_SMASH)     // none: no params
if b & 8 and not (b & 0x20):                  // net
    vnet = clamp((n-0.005)*25, 0, 1); play(ball.emitter, 944 BOUND_NET, vnet, 0)
    if n >= 0.01: shake net (0x804598c0(table, 1.0))
if b & 0x30:                                  // field / ground
    if vol > 0:
        m = ball[0x190]
        if m&2: play(943 GROUND, vol);  if m&1: play(945 LAWN, vol);  if m&4: play(946 WATER, vol);  if m&8: play(947 MAT, vol)
        if m & (0x10|0x40|0x80): { if (b&0x20) vol = max(vol,0.3); play(948 WOOD, vol) }
```
(all with f2 = 0). Each present material bit plays; they are checked independently in that order (0x8046c88c..0x8046c950). WOOD uses the level after the 0.3 floor
(only when 0x188 bit 0x20). Particle effects (boundGrass / boundWater / dust, 0x8046c124/c3b4) and the replay recorder run alongside; they are not sounds.
Which of GROUND/LAWN/WATER/MAT/WOOD a given stage uses depends on the stage KCL attribute numbers (assets/collision). Table-top (list "table") never plays GROUND.
NOTE: the **table bounce uses id 942 even on edges** (bits 1/2/4 all go through `b & 7`), and the sound is emitted from the ball's emitter (Ball[4]).

### 5.2 Swing whoosh (RECOVERED) - OnSwing 0x8045e554 -> swing begin 0x80465ab8(racket, hand, playSound=1)

`0x80465ab8` stores the swing, then calls `0x80466900(racket,hand)` (swept prediction: returns 1 if a future ball position is inside the racket's reach, else 0;
needs a live ball, ball state < 3, and swing flags).
* result 0 -> `play(player.emitter, 980 SWING_S)` (0x80465c8c)
* result 1 -> `play(player.emitter, 981 SWING_L)` (0x80465dd4)
Both only when `playSound!=0` (OnSwing passes 1; the CPU lookahead 0x8045d994 calls it with 0 and so is silent) and `replay[0x24]!=2`. No volume/pitch, no CSPK variant.
SP3 (wide lunge, sub-state 4 in StartSwing 0x8045af3c, reach f1 >= 13 etc., see animation.md): `play(emit, 983 JUMP_SWING_L)`, `play2D(993 AUDIENCE_SURPRISE)`,
venue 1 -> `play2D(1001)`, venue 0 -> `play2D(1007)` (0x8045b008..0x8045b04c).

### 5.3 Serve and ball-handling sounds (RECOVERED)
* **THROW_UP (920)**: 0x8045e2ec(player, tossStrength) -> `play(player.emitter, 920)` at the end of the toss start (called from the participant tick at 0x8046007c when
  `0x8045e858` allows a toss and the controller's toss trigger fires, `+0x68 = tossStrength`). Ball is set to the held/tossed state in the same call (0x80469c04). No CSPK version is used (921 never referenced).
* **BALL_CATCH (922)**: 0x80469ba0 sets ball state 2 (caught) when state==1 (held) and `ball.vy < 0` and `ball.y <= [r13-0x2950]` (0x8046aab0..0x8046aae0): `play(ball.emitter, 922)`.
* **HIT_FACE (931)**: 0x8046a07c(ball, pos, normal, firstFlag, f1): when the ball overlaps an avatar body shape (0x8047ec84 tests two shapes with 0x8032478c / 0x8032438c; shape radii 1.4/3.4 `[806f22e4/e8]`),
  pushes the ball out, sets `ball[0x250] |= 1`, and if `firstFlag != 0` plays `play(ball.emitter, 931)` + effect "boundFace" + recorder event 10. No params.
* **SE_PNG_PREPARE (984)**: participant "ready" node 0x8046933c: once HUD query `0x804837c0(scene[0x18c], ...)` is true, `cspk(984, 1<<pad(player))` (TV + that player's remote), then node state 2 (0x804693d4). INFERRED meaning: the "get ready" cue.
* **SE_PNG_SERVE_LR_SWITCH (923)** - no trigger found in the executable.

### 5.4 Footsteps / landings (RECOVERED) - avatar event fn 0x8045b070(avatar, side, type), dispatcher 0x8045b3ac (frame-crossing via `0x80346690(timer, frame)`)

`f1 = clamp((|avatarVelXZ| + 0.2) * 3, 0, 1)` (`0x8045f3a4` = displacement per tick; consts [806fee70]=.2, [806fee74]=3). Ground bit `g = lhz(0x20 or 0x22 + Participant)&1` (side 0/1; 1 = soft/"normal" ground, 0 = stone, INFERRED).
Jump-table @0x806d9c70 maps `type`: {0,3,7} -> JUMP, {1,4,5,8} -> LANDING_1, {2,6} -> LANDING_2, 9 -> step L/R.
* JUMP: g ? 970 FOOTNOTE_JUMP : 979 STONE_JUMP (plain `72dc`, no f1)
* LANDING_1: g ? 966 : 975 STONE_LANDING_1 (f1) ; LANDING_2: g ? 967 : 976 (f1)
* step: side0 -> g ? 968 NORMAL_L : 977 STONE_L; side1 -> g ? 969 NORMAL_R : 978 STONE_R (f1)
Dispatcher is keyed on the avatar clip id `avatar[0x188]` (ids per animation.md) and clip frames (frame, side, type):
`3 fore_SP: 0(0,0) 14(1,1) 27(0,2)`; `4 back_SP: 0(1,0) 14(0,1) 27(1,2)`; `5 front: 0(0,0) 14(1,1) 27(0,2)`; `7 back_SP2: 0(1,3) 14(0,4) 28(0,4) 40(1,5)`;
`6 fore_SP2: 0(0,3) 14(1,4) 28(1,4) 40(0,5)`; `9 back_SP3: 0(1,7) 14(0,8)`; `8 fore_SP3: 0(0,7) 14(1,8)`; any other clip (walk/idle): step events (type 9) from
`0x8045e8ac` (left) -> (side0), else `0x8045e8a4` (right) -> (side1).

### 5.5 Whistles (RECOVERED call sites; state names INFERRED)
* **WHISTLE_START 971**: state handlers 0x804809e8 (event 0x12a, then `0x80483880(HUD,0,0)`, 0x80480b7c) and 0x804814f0 (event 0x131, 0x80481714), played with `73bc`.
* **WHISTLE_MISS 972**: `0x804791a8(this, reason, pos)` (0x804792c4), skipped in replay playback; called from `0x80470e60(reason 0..4, pos)` which is invoked by the point-resolution
  switch at 0x80471290 right after `pointScored(rules, winner)` 0x80471088 (reasons 2,3,4,0,1,4; 6 callers), and from the rally-mode end 0x80482284/0x8047555c.
* **WHISTLE_END 973**: match end handler 0x8047f76c (event 0x28e, 0x8047f7a8) and 0x804811f0 (event 0x16c: `stop(972)` via 0x802b732c(972,0) then `play2D(973)`).

### 5.6 Narration and score jingles (RECOVERED)
Score announcement 0x80477adc(this) (this+0x118/0x11c = score A/B, +0x12c = server side):
`7298(1016 NAR_PADDING_0)`, `7298(1010 NAR_SCORE_COUNT_0, scoreA)`, then `if A==B 7298(1015 NAR_ALL) else 7298(1011 NAR_SCORE_COUNT_1, scoreB)`;
if game over (`0x80470ff8`: rules[0x28]!=0): stream 35/36 (SCORE_P1_LAST/P2_LAST by server side), `7298(1018 NAR_PADDING_2)`, `7298(1013 NAR_GAMESET)`;
else if deuce (`0x80470f1c`): stream 37/38 (DEUCE); else stream 33/34 (SCORE_P1/P2). Match-point: 0x8047f394 `7298(1018)`,`7298(1014 NAR_MATCH_POINT)`; deuce: 0x8047f634 `7298(1018)`,`7298(1012 NAR_DEUCE)`.
Result streams (7228): 40 RESULT_LOSE / 39 RESULT_WIN at match end (0x8047f8b8/0x8047f900...): see 5.7. Rally mode: 41 RALLY_OPENING (0x804613ec, 0x80481810), 42 RALLY_PLAYER_CHANGE (0x80481404).
CMN prompt: 135 CONT_PROMPT (73bc) + `cspk(136 CONT_PROMPT_CSPK, 1<<pad)` for the human player at 0x80481a00/0x80481a40 and 0x80471604 (only if `Player[0xd8]==0`).

### 5.7 Audience reactions (RECOVERED)
Venue class `v = scene[0x164][0x7c]`: 1 -> use `_FAR_MID`, 0 -> `_FAR_LARGE`, other -> no far layer. All are `play2D`.
* **After every non-smash racket hit** (0x80467a00..0x80467a88, match mode 0): let `T = target score`, `A,B` scores, `L = rules[0x30]` rally hit count.
  Condition `A >= T-2 or B >= T-2 or L >= 10`: play 990 AUDIENCE_RECEIVE (if not smash); plus 991 RECEIVE_ADD when `L >= 15` (and not smash). Then always (in that same branch) run the tension mixer 5.8.
  Otherwise nothing at all. Smash hits instead play 992 (+1000/1006), see section 4.
* **Match mode 1 (rally challenge)** (0x80467a8c..0x80467b1c), if `Player[0xd8]!=2`: `s = scene[0x184] rally score of current side`; play 996 PRE_50 iff `s%50 > 40 or s >= 100`; play 997 PRE_50_ADD iff `s%50 > 46 or s >= 120`.
* **Serve phase** (0x80480988): on state event 0x199, if `A >= T-2 or B >= T-2` play 989 AUDIENCE_SERVE.
* **Point scored** (function 0x80471088 `pointScored(rules, winner)`, sounds at 0x804711d0..0x80471268): `long = rally L >= 21`;
  `if rules[0x28] != 0 (game ended): play 988 POINT_LAST_L if long else 986 POINT_LAST; far: v==1 -> 999, v==0 -> 1005`;
  `else: play 987 POINT_L if long else 985 POINT; far: v==1 -> 998, v==0 -> 1004`. It also zeroes the tension mixer (section 5.8) and records events 0xb/0xc.
* **Match end** (0x8047f8a8..0x8047fa5c): let w be the loser/winner branch on `player[0xd8]==1` (CPU controlled): human wins -> stream 39, `play2D(924 AUDIENCE_WIN)`, far 925 (v==1)/926 (v==0);
  CPU wins -> stream 40, `play2D(927 AUDIENCE_LOSE)`, far 928/929; draw/other branch (result code 2): stream 40 + 924 (+925/926). Exact "who is r31" INFERRED.
* **Rally mode end** (0x80482284..0x804823e8): final rally score `s`: `s < 10` -> 930 AUDIENCE_MISS only; `10 <= s < 50` -> 927 + far 928/929; `s >= 50` -> 924 + far 925/926.
* **Rally score ticks** (0x80481fe0(this, newScore), prev = this[0x58]): `if prev%100 > new%100: 935 RALLY_SCORE_100 + 995 AUD_SCORE_50 + far(1003 v==1 / 1009 v==0)`;
  `else if prev%50 > new%50: 934 RALLY_SCORE_50 + 995 + far`; and independently `if prev%10 > new%10: 933 RALLY_SCORE_10 + 994 AUD_SCORE_10 + far(1002/1008) else 932 RALLY_SCORE_1`.
  Rank result (0x80485240): top rank -> 937 RANK_TOP + 939 AUD_RANK_TOP + far 940/941; else 936 RANK_UP. Can scoring: 938 RALLY_SCORE_CAN (0x80481ce4).

### 5.8 Rally tension mixer (RECOVERED code; parameter identity INFERRED)
After each non-faulty hit in match mode 0 (inside the 5.7 condition) `0x80470a6c(rules)` runs (only if `rules.vfunc_0x4c()==0`):
```
n = rules[0x30]; K = 20 ([806f2180]); W = 6 ([806f2184])
f = 0 if n < K ; -(n-K)/W if K <= n < K+W ; -1 if n >= K+W
0x802b6ed4(player 8, f)            // SoundPlayer(audience)+0x30  = (INFERRED) low-pass cutoff, range [-1,0]
0x802b6ec8(player 7, -0.7*f)       // SoundPlayer(ball)+0x58[0]   = per-remote output parameter 0..0.7 (INFERRED: remote send)
0x802b6ec8(player 5, -0.7*f)       // SoundPlayer(swing/steps)+0x58[0]
```
At a point fault (0x80470e60) and at pointScored (0x80471180) all three are set to 0. So from the 20th consecutive hit the crowd is progressively muffled and the ball/step groups
are progressively sent harder to the (remote-0) output, fully after 26 hits.

### 5.9 Return-challenge cans (RECOVERED)
`0x80486e50(can)`: for contact with the table list (0x8045a09c): intensity `i = clamp((relSpeed - 0.0015)*150, 0, 1)` with `relSpeed = can.vy-like` (`0x14(r1)` from 0x8033dc00);
`i >= 0.7 -> 1021 CAN_BOUND_TABLE_L`, `i >= 0.4 -> 1022 _M`, `i > 0 -> 1023 _S` (all `72d8(can.emitter, id, f1=i, f2=0)`: the intensity both selects the size variant and is passed as f1).
For the lawn list (0x80459964): thresholds `i >= 0.5 -> 1024 CAN_BOUND_LAWN_L`, `i > 0 -> 1025 _S`.
CAN_PUT 1019 (0x80487330) on can placement, CAN_HIT_BALL 1020 (0x8048677c) on the first ball touch (also triggers 0x80481c0c -> 938 RALLY_SCORE_CAN). 3-tick throttle on 1021..1025 (5.1/section 1).

---------------------------------------------------------------------------------------------------

## 6. CSPK (Wii Remote speaker) rules (RECOVERED)

* `*_CSPK` sound entries share the sequence of their non-CSPK twins (same `start`) but have their own brsar entries (remote-only routing presumably; the supplied manifest does not carry send levels - UNKNOWN).
* Only the **hitting player's own remote** gets the racket-hit CSPK sound: played when `racket.player[0xd8] == 0` (human controller) via `cspk(id, 1 << wpadChannel(player))`; CPU hits and non-participating players never do.
  The TV version (non-CSPK id) is always played too. Smash: SMASH_SHOT (982) is TV-only; the `HIT_SMASH(_SLIPPER)` TV + CSPK pair is played. (0x80467760, 0x80467798, 0x8046783c.. etc.)
* Other remote-routed ids: 984 PREPARE (ready cue, mask of that player), 136 CMN_CONT_PROMPT_CSPK. THROW_UP_CSPK (921) is **never triggered**; swing whooshes, bounces and audience never use CSPK.
* In `0x802bb2e4`/`0x802b941c`, a mask is only effective for sounds whose brsar user-param upper 3 bytes are non-zero.

---------------------------------------------------------------------------------------------------

## 7. Complete pseudocode (JS-like) for a port

```js
// ---- hit (racket vs ball); call in the same sub-step the contact is detected (60 Hz frame has 4 sub-steps)
function onRacketHit(hitter, racket, smash, scene) {
  const e = hitter.emitter, slip = hitter.avatar.slipper, human = hitter.controllerType === 0, mask = 1 << hitter.wpadChannel;
  if (smash) {
    play(e, 982);
    play(e, slip ? 961 : 953); if (human) cspk(slip ? 965 : 957, mask);
    play2D(992); venueFar(scene, 1000, 1006);
  } else {
    const t = racket.twist;                       // a194, [-1,1]
    const k = t >= 0.4 ? 'drive' : t <= -0.4 ? 'cut' : 'normal';
    const id   = {normal: slip?958:950, cut: slip?959:951, drive: slip?960:952}[k];
    const cid  = {normal: slip?962:954, cut: slip?963:955, drive: slip?964:956}[k];
    play(e, id); if (human) cspk(cid, mask);
  }
  const T = targetScore(scene), L = scene.rules.rally;
  if (scene.mode === 0) {
    if (scene.rules.A >= T-2 || scene.rules.B >= T-2 || L >= 10) {
      if (!smash) { play2D(990); if (L >= 15) play2D(991); }
      tensionMixer(L);
    }
  } else if (scene.mode === 1 && hitter.controllerType !== 2) { /* 996/997 rule in 5.7 */ }
}
// ---- ball sub-step collisions
function onBallStep(ball) { /* section 5.1 pseudocode */ }
// ---- smash decision (needed to choose the hit sound)
function isSmash(racket, ball, serve) {
  return !serve && racket.power < 0 && racket.q218 >= 0 && racket.contactY >= 1.5 && ball.lastNormalY >= 0.866;
}
```

---------------------------------------------------------------------------------------------------

## 8. Confidence and unknowns

* RECOVERED with high confidence: all IDs listed and their call sites; hit-sound branch structure and thresholds (0.4); CSPK gating; bounce intensity formulas and material bit tables;
  volume floor 0.4 for the first three bounces; smash-bounce layering; swing S/L structure; audience/narrator branching; tension mixer arithmetic; cooldown rule for cans.
* INFERRED: semantic names of states/nodes (point-start, point-end), `racket[0x194]` physical meaning (smoothed signed racket twist), what fields +0x30 and +0x58 of the SoundPlayer are,
  exact player identity in the match-end branches, the "slipper" unlock semantics.
* UNKNOWN: the brsar user-param byte of each sound (whether f1 is volume or a sequence variable, per sound); remote send levels of the *_CSPK entries; where/how the player and ball
  emitters (`obj+4`) are created and positioned (3D pan/attenuation) - no position-setting call was found in the table-tennis code, only the scene ambience emitter (`scene+0x78`, `0x802ba4dc` per-frame update);
  replay re-triggering of sounds; trigger of 921 and 923 (apparently unused); streams 60/120 arguments (0x802b7208) and the extra arguments of stream 39/41 (0x80480f98, 0x80481810).
* Never validated against a live capture.
