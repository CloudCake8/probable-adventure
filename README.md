# ResortCompiled – Table Tennis (web port)

Wii Sports Resort Table Tennis in the browser. The PC shows the game; each player's **phone is the paddle**
(gyro/accelerometer over WebSocket). Served over HTTPS through a Cloudflare quick tunnel so phones allow motion access.

## Run

```
start.bat            (or: npm install && npm start)
```

1. The host screen opens at <http://localhost:47831> and shows a QR code once the tunnel is up
   (the console also prints the `https://….trycloudflare.com/pad` link; it changes every start).
2. Phones scan the QR, tap **Join & enable motion** (iOS asks for permission), then hold the phone **like a Wii
   Remote pointed at the screen**. Tap *Recenter* if aim drifts.
3. Press **Start match**. Empty seats are played by the CPU. Host-side keys: `C` camera, `M` mute, `Esc` lobby.
   "Play with mouse on this PC" gives a keyboard/mouse player (Space toss, left/right click fore/backhand, Shift hard).

Needs Node 18+ and `cloudflared` on PATH (set `CLOUDFLARED=path` if elsewhere; `NO_TUNNEL=1` to skip the tunnel;
`PORT=…` to change the port). The server binds to localhost only; the tunnel is the only way in, and anyone with the
random URL can join, so close it when you are done.

## Controls (phone)

- **Serve:** flick the phone up to toss (or tap *Toss*), then swing as the ball falls.
- **Rally:** swing as the ball reaches you. Right-to-left = forehand (mirrored for left-handers; use the hand
  toggle if forehand/backhand feel swapped). Harder swing = more power, upward brush = topspin, downward = backspin.
- **Timing steers the ball:** early/late swings angle the shot; the phone shows PERFECT / EARLY / LATE.
- No motion sensor? Swipe the pad area (left/right = fore/backhand, up = toss).

## Layout

```
server/sim.js      authoritative game: ball physics, table/net, rules, scoring, CPU
server/swing.js    swing recognition from phone acceleration
server/index.js    HTTP + WebSocket + 60 Hz loop + cloudflared launcher
public/host.js     three.js host renderer (Mii rig + original table-tennis animations)
public/controller.* phone controller
public/assets/mii_pingpong.glb   Mii rig with the original Table Tennis animations (textures are replaced)
server/test.js     headless checks (CPU matches, planner, detector);  server/simphone.js  simulated phone
```

## Fidelity notes

- Recovered from the game (see `../pingpong/research/FINDINGS.md`): table/ball/net collider sizes, restitution
  0.82, friction 0.2, drag base 0.9986, structure of the flight integrator (drag → gravity → Magnus → move),
  spin handling at bounces, the serve rule flow.
- **Not** recovered/ported: the original course tables, MotionPlus swing recognition, AI, camera. The shot
  generator (`planRally`/`planServe`) is a trajectory solver, not the game's table lookup, and the
  per-second constants (gravity, Magnus) are hand-tuned. The ResortCompiled repo is a static recompilation, so it
  contains no readable table-tennis logic to copy.
- All art is placeholder (primitive table, paddle, head; flat Mii colours); only the skeleton animations are original.

## Recovered game logic (from the executable, see `research/`)

Static analysis of the USA Rev 1 `main.dol` (no emulator, not validated against a capture) produced `research/camera.md`,
`research/movement.md` and `research/animation.md`. Used in the port:

- **Camera** (`public/host.js`, `GameCam`): the main gameplay camera as recovered: FOV 33, near 10, orbit distance 40, pitch -20..-5 deg
  with the serve ramp, position lerp 0.1 / orientation slerp 0.05 per 60 Hz frame, and the 451-pass framing solver that keeps the
  predicted ball and the player's upper body inside the frame. Seat 1 is the 180-degree mirror. Split screen uses one camera per seat.
- **Movement** (`server/sim.js`, `moveSeat`): stance-offset targeting, ramped chase speeds, near-ball boost, post-stroke lock, home depth by
  skill. Adapted: our own ball prediction picks the contact point, and the pose update is assumed to run 240x/s (unverified); `K.SPEED_SCALE`
  (1.6) speeds players up from the recovered values for playability.
- **Animation**: walk/idle thresholds and walk-clip rate, serve-wait cross-blend by remote yaw, swing clip variants (SP/SP2/SP3/front) by
  reach, facing toward (0, 8). Not implemented: the CPU data records (`Sp2PngCpuData.exbin`), replay/result cameras, racket gate blending.
