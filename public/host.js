import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import * as SkeletonUtils from 'three/addons/utils/SkeletonUtils.js';
import { RacketPose, RemoteHeading, mat3ToQuat } from '/racket_pose.js';

// ---- constants shared with the simulation (server/sim.js) --------------------------------
const HW = 9.15, HL = 16.398, R = 0.452, NET_H = 1.87, FLOOR = -6.06, PLANE = 20.5;
const MII_SCALE = 1.0;   // rig is 11 units tall, same units as the 32.8-unit table
const COLORS = [0xe0463d, 0x2f6fe0];

// ---- renderer / scene ----------------------------------------------------------------------
const canvas = document.getElementById('view');
const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x7fd0ff);
scene.fog = new THREE.Fog(0xcdf1ff, 110, 420);
const camera = new THREE.PerspectiveCamera(42, 1, 0.5, 600);

scene.add(new THREE.HemisphereLight(0xeaf8ff, 0x8fe06a, 1.05));
const sun = new THREE.DirectionalLight(0xfff6dc, 2.1);
sun.position.set(-30, 60, 25);
sun.castShadow = true;
sun.shadow.mapSize.set(2048, 2048);
Object.assign(sun.shadow.camera, { left: -45, right: 45, top: 45, bottom: -45, near: 5, far: 160 });
sun.shadow.bias = -0.0004;
scene.add(sun);

// placeholder textures drawn on canvases
function canvasTex(w, h, draw, repeat) {
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  draw(c.getContext('2d'), w, h);
  const t = new THREE.CanvasTexture(c); t.colorSpace = THREE.SRGBColorSpace; t.anisotropy = 8;
  if (repeat) { t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(...repeat); }
  return t;
}
// ---- Frutiger Aero surroundings: sunny sky, lush grass, glossy aqua platform, hills, clouds, floating bubbles ----
const floorTex = canvasTex(256, 256, (g, w, h) => {
  g.fillStyle = '#6fd04a'; g.fillRect(0, 0, w, h);
  for (let i = 0; i < 8; i++) { g.fillStyle = i % 2 ? '#7bdc52' : '#62c640'; g.fillRect(0, i * h / 8, w, h / 8); }
  for (let i = 0; i < 700; i++) { g.fillStyle = `rgba(${200 + Math.random() * 40 | 0},255,${120 + Math.random() * 60 | 0},.18)`; g.fillRect(Math.random() * w, Math.random() * h, 1.5, 4); }
}, [30, 30]);
const floor = new THREE.Mesh(new THREE.PlaneGeometry(1200, 1200), new THREE.MeshStandardMaterial({ map: floorTex, roughness: 0.9 }));
floor.rotation.x = -Math.PI / 2; floor.position.y = FLOOR - 0.05; floor.receiveShadow = true;
scene.add(floor);
// glossy aqua glass court platform with a bright rim
const platTex = canvasTex(512, 512, (g, w, h) => {
  const gr = g.createRadialGradient(w / 2, h * 0.4, 20, w / 2, h / 2, w * 0.7); gr.addColorStop(0, '#d9fbff'); gr.addColorStop(0.5, '#5fd6f0'); gr.addColorStop(1, '#1c9ccf');
  g.fillStyle = gr; g.fillRect(0, 0, w, h);
  g.strokeStyle = 'rgba(255,255,255,.35)'; g.lineWidth = 2;
  for (let i = 1; i < 12; i++) { g.beginPath(); g.arc(w / 2, h / 2, i * w / 24, 0, Math.PI * 2); g.stroke(); }
  g.fillStyle = 'rgba(255,255,255,.18)'; g.beginPath(); g.ellipse(w / 2, h * 0.22, w * 0.42, h * 0.16, 0, 0, Math.PI * 2); g.fill();
});
const plat = new THREE.Mesh(new THREE.CircleGeometry(78, 96), new THREE.MeshStandardMaterial({ map: platTex, roughness: 0.12, metalness: 0.15, emissive: 0x0a4a66, emissiveIntensity: 0.35 }));
plat.rotation.x = -Math.PI / 2; plat.position.y = FLOOR; plat.receiveShadow = true; scene.add(plat);
const rim = new THREE.Mesh(new THREE.RingGeometry(78, 82, 96), new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.9 }));
rim.rotation.x = -Math.PI / 2; rim.position.y = FLOOR + 0.02; scene.add(rim);
// sky dome: deep sky blue -> aqua -> white haze at the horizon
const skyTex = canvasTex(16, 256, (g, w, h) => { const gr = g.createLinearGradient(0, 0, 0, h); gr.addColorStop(0, '#1b8fe8'); gr.addColorStop(0.45, '#5cc6ff'); gr.addColorStop(0.5, '#bff0ff'); gr.addColorStop(0.55, '#e9fbff'); gr.addColorStop(1, '#e9fbff'); g.fillStyle = gr; g.fillRect(0, 0, w, h); });
const sky = new THREE.Mesh(new THREE.SphereGeometry(520, 24, 16), new THREE.MeshBasicMaterial({ map: skyTex, side: THREE.BackSide, fog: false, depthWrite: false }));
sky.renderOrder = -10; scene.add(sky);
// soft rolling hills ringing the court
const hillCols = [0x58c83c, 0x6fdc4a, 0x49b832, 0x7fe85a];
for (let i = 0; i < 18; i++) {
  const ang = (i / 18) * Math.PI * 2 + Math.random() * 0.2, r = 230 + Math.random() * 110, sz = 55 + Math.random() * 70;
  const hill = new THREE.Mesh(new THREE.SphereGeometry(1, 24, 14, 0, Math.PI * 2, 0, Math.PI / 2), new THREE.MeshStandardMaterial({ color: hillCols[i % 4], roughness: 0.9 }));
  hill.scale.set(sz * 1.6, sz * 0.5, sz); hill.position.set(Math.cos(ang) * r, FLOOR - 0.1, Math.sin(ang) * r); hill.rotation.y = -ang; scene.add(hill);
}
// puffy clouds and a sun glow (sprites) + floating glossy bubbles
const cloudTex = canvasTex(128, 64, (g, w, h) => {
  for (const [x, y, r] of [[40, 38, 24], [64, 30, 28], [90, 38, 22], [64, 42, 26], [22, 44, 16], [108, 44, 16]]) {
    const gr = g.createRadialGradient(x, y, 2, x, y, r); gr.addColorStop(0, 'rgba(255,255,255,.95)'); gr.addColorStop(1, 'rgba(255,255,255,0)'); g.fillStyle = gr; g.beginPath(); g.arc(x, y, r, 0, Math.PI * 2); g.fill();
  }
});
const clouds = [];
for (let i = 0; i < 16; i++) {
  const c = new THREE.Sprite(new THREE.SpriteMaterial({ map: cloudTex, transparent: true, depthWrite: false, fog: false, opacity: 0.95 }));
  const ang = Math.random() * Math.PI * 2, r = 250 + Math.random() * 200;
  c.position.set(Math.cos(ang) * r, 60 + Math.random() * 110, Math.sin(ang) * r); const sc = 110 + Math.random() * 120; c.scale.set(sc, sc * 0.5, 1); c.userData = { ang, r, sp: 0.002 + Math.random() * 0.004 };
  scene.add(c); clouds.push(c);
}
const glowTex = canvasTex(128, 128, (g, w, h) => { const gr = g.createRadialGradient(64, 64, 2, 64, 64, 64); gr.addColorStop(0, 'rgba(255,255,230,1)'); gr.addColorStop(0.25, 'rgba(255,245,180,.55)'); gr.addColorStop(1, 'rgba(255,240,160,0)'); g.fillStyle = gr; g.fillRect(0, 0, w, h); });
const sunGlow = new THREE.Sprite(new THREE.SpriteMaterial({ map: glowTex, transparent: true, depthWrite: false, fog: false, blending: THREE.AdditiveBlending }));
sunGlow.position.set(-220, 190, -260); sunGlow.scale.set(260, 260, 1); scene.add(sunGlow);
const bubbleTex = canvasTex(128, 128, (g, w, h) => {
  const gr = g.createRadialGradient(64, 70, 30, 64, 64, 60); gr.addColorStop(0, 'rgba(180,240,255,.06)'); gr.addColorStop(0.8, 'rgba(150,230,255,.22)'); gr.addColorStop(1, 'rgba(255,255,255,.85)');
  g.fillStyle = gr; g.beginPath(); g.arc(64, 64, 60, 0, Math.PI * 2); g.fill();
  g.fillStyle = 'rgba(255,255,255,.9)'; g.beginPath(); g.ellipse(44, 40, 16, 9, -0.6, 0, Math.PI * 2); g.fill();
  g.fillStyle = 'rgba(160,255,200,.35)'; g.beginPath(); g.ellipse(84, 92, 14, 6, -0.6, 0, Math.PI * 2); g.fill();
});
const bubbles = [];
for (let i = 0; i < 46; i++) {
  const b = new THREE.Sprite(new THREE.SpriteMaterial({ map: bubbleTex, transparent: true, depthWrite: false, fog: false, opacity: 0.85 }));
  const ang = Math.random() * Math.PI * 2, r = 36 + Math.random() * 90, sc = 2.5 + Math.random() * 9;
  b.position.set(Math.cos(ang) * r, FLOOR + Math.random() * 70, Math.sin(ang) * r); b.scale.setScalar(sc);
  b.userData = { base: b.position.clone(), ph: Math.random() * 6.28, sp: 0.15 + Math.random() * 0.35, rise: 1.5 + Math.random() * 3 };
  scene.add(b); bubbles.push(b);
}
function updateScenery(t, dt) {
  for (const c of clouds) { c.userData.ang += c.userData.sp * dt * 0.1; c.position.x = Math.cos(c.userData.ang) * c.userData.r; c.position.z = Math.sin(c.userData.ang) * c.userData.r; }
  for (const b of bubbles) { const u = b.userData; u.base.y += u.rise * dt; if (u.base.y > FLOOR + 75) u.base.y = FLOOR - 2; b.position.set(u.base.x + Math.sin(t * u.sp + u.ph) * 2.2, u.base.y, u.base.z + Math.cos(t * u.sp * 0.8 + u.ph) * 2.2); }
}

// table
const tableTex = canvasTex(512, 1024, (g, w, h) => {
  const tg = g.createLinearGradient(0, 0, w, h); tg.addColorStop(0, '#25c25a'); tg.addColorStop(0.5, '#1fa84a'); tg.addColorStop(1, '#1a9a44'); g.fillStyle = tg; g.fillRect(0, 0, w, h);
  g.strokeStyle = '#f4f7fb'; g.lineWidth = 8;
  g.strokeRect(4, 4, w - 8, h - 8);
  g.lineWidth = 5; g.beginPath(); g.moveTo(w / 2, 4); g.lineTo(w / 2, h - 4); g.stroke();
  g.fillStyle = 'rgba(255,255,255,.06)';
  for (let i = 0; i < 40; i++) g.fillRect(0, i * 26, w, 13);
  const sh = g.createLinearGradient(0, 0, w, 0); sh.addColorStop(0, 'rgba(255,255,255,.22)'); sh.addColorStop(0.4, 'rgba(255,255,255,0)'); g.fillStyle = sh; g.fillRect(0, 0, w, h);
});
const table = new THREE.Group();
const top = new THREE.Mesh(new THREE.BoxGeometry(HW * 2, 0.96, HL * 2), [
  new THREE.MeshStandardMaterial({ color: 0x0c6b34 }), new THREE.MeshStandardMaterial({ color: 0x0c6b34 }),
  new THREE.MeshStandardMaterial({ map: tableTex, roughness: 0.18, metalness: 0.08 }),
  new THREE.MeshStandardMaterial({ color: 0x0c6b34 }), new THREE.MeshStandardMaterial({ color: 0x0c6b34 }), new THREE.MeshStandardMaterial({ color: 0x0c6b34 }),
]);
top.position.y = -0.48; top.castShadow = true; top.receiveShadow = true; table.add(top);
for (const sx of [-1, 1]) for (const sz of [-1, 1]) {
  const leg = new THREE.Mesh(new THREE.BoxGeometry(0.9, -FLOOR - 0.96, 0.9), new THREE.MeshStandardMaterial({ color: 0xeafcff, metalness: 0.5, roughness: 0.15 }));
  leg.position.set(sx * (HW - 1.5), (FLOOR - 0.96) / 2, sz * (HL - 3)); leg.castShadow = true; table.add(leg);
}
const netTex = canvasTex(256, 32, (g, w, h) => {
  g.clearRect(0, 0, w, h); g.fillStyle = 'rgba(20,20,20,.55)'; g.fillRect(0, 0, w, h);
  g.strokeStyle = 'rgba(235,235,235,.8)'; g.lineWidth = 1;
  for (let x = 0; x < w; x += 6) { g.beginPath(); g.moveTo(x, 0); g.lineTo(x, h); g.stroke(); }
  for (let y = 0; y < h; y += 6) { g.beginPath(); g.moveTo(0, y); g.lineTo(w, y); g.stroke(); }
  g.fillStyle = '#f2f2f2'; g.fillRect(0, 0, w, 5);
});
const net = new THREE.Mesh(new THREE.PlaneGeometry(HW * 2 + 2, NET_H), new THREE.MeshStandardMaterial({ map: netTex, transparent: true, side: THREE.DoubleSide }));
net.position.y = NET_H / 2; table.add(net);
for (const sx of [-1, 1]) {
  const post = new THREE.Mesh(new THREE.CylinderGeometry(0.16, 0.16, NET_H + 0.3, 10), new THREE.MeshStandardMaterial({ color: 0x3cc8f0, metalness: 0.4, roughness: 0.2 }));
  post.position.set(sx * (HW + 1), (NET_H + 0.3) / 2 - 0.15, 0); table.add(post);
}
scene.add(table);

// two billboards, one on each side of the court (images in public/assets)
function makeBillboard(url, side) {
  const g = new THREE.Group(), H = 24, frameC = new THREE.MeshStandardMaterial({ color: 0xeafcff, metalness: 0.5, roughness: 0.15, emissive: 0x2a9bd0, emissiveIntensity: 0.25 });
  const mat = new THREE.MeshBasicMaterial({ color: 0x9fd8ee });
  const board = new THREE.Mesh(new THREE.PlaneGeometry(1, 1), mat);
  const frame = new THREE.Mesh(new THREE.BoxGeometry(1, 1, 0.8), frameC);
  const posts = [];
  const place = (w) => {
    for (const q of posts) g.remove(q); posts.length = 0;
    board.scale.set(w, H, 1); board.position.z = 0.45; frame.scale.set(w + 2.4, H + 2.4, 1); frame.position.z = 0;
    for (const sx of [-1, 1]) { const post = new THREE.Mesh(new THREE.CylinderGeometry(0.45, 0.6, 12, 12), frameC); post.position.set(sx * w * 0.32, -H / 2 - 3, -0.2); post.castShadow = true; g.add(post); posts.push(post); }
    g.position.set(0, FLOOR + 4 + H / 2, side * 58); g.rotation.y = side > 0 ? Math.PI : 0;   // behind each end of the court, facing the table
  };
  place(H * 0.85);
  new THREE.TextureLoader().load(url, (t) => { t.colorSpace = THREE.SRGBColorSpace; t.anisotropy = 8; mat.map = t; mat.color.set(0xffffff); mat.needsUpdate = true; const w = H * t.image.width / t.image.height; place(w); });
  g.add(frame, board); frame.castShadow = true;
  scene.add(g);
}
makeBillboard('/assets/billboard_left.webp', -1);
makeBillboard('/assets/billboard_right.webp', 1);

// ball + shadow blob
const ballTex = canvasTex(128, 64, (g, w, h) => {
  g.fillStyle = '#fbfbf5'; g.fillRect(0, 0, w, h);
  g.fillStyle = '#ff8a3d'; g.fillRect(0, h * 0.42, w, h * 0.16);
  g.fillStyle = '#c9c9c0'; g.fillRect(w * 0.24, 0, w * 0.04, h);
});
const toonGrad = new THREE.DataTexture(new Uint8Array([90, 90, 90, 255, 170, 170, 170, 255, 255, 255, 255, 255]), 3, 1, THREE.RGBAFormat);
toonGrad.minFilter = toonGrad.magFilter = THREE.NearestFilter; toonGrad.needsUpdate = true;
const ball = new THREE.Mesh(new THREE.SphereGeometry(R * 1.1, 28, 20), new THREE.MeshToonMaterial({ map: ballTex, gradientMap: toonGrad }));
ball.castShadow = true; scene.add(ball);
// thick black outline: a slightly larger back-face shell
const ballOutline = new THREE.Mesh(new THREE.SphereGeometry(R * 1.1 * 1.2, 28, 20), new THREE.MeshBasicMaterial({ color: 0x0b0b12, side: THREE.BackSide }));
ball.add(ballOutline);
const BALL_WHITE = new THREE.Color(0xffffff), BALL_WOB = new THREE.Color(0xff6a2a), BALL_SMASH = new THREE.Color(0xff2a3a);
// trail of recent positions (a slight tail; wobbles with the ball when it is wobbly)
// smooth camera-facing ribbon trail built from per-frame samples (last ~0.26 s); wobbles when the ball is wobbly
const TRAIL_MAX = 48, TRAIL_LIFE = 0.26;
const trailGeo = new THREE.BufferGeometry();
const trailPos = new Float32Array(TRAIL_MAX * 2 * 3), trailCol = new Float32Array(TRAIL_MAX * 2 * 4);
trailGeo.setAttribute('position', new THREE.BufferAttribute(trailPos, 3).setUsage(THREE.DynamicDrawUsage));
trailGeo.setAttribute('color', new THREE.BufferAttribute(trailCol, 4).setUsage(THREE.DynamicDrawUsage));
const trailIdx = [];
for (let i = 0; i < TRAIL_MAX - 1; i++) { const a = 2 * i, b = a + 1, c = a + 2, d = a + 3; trailIdx.push(a, b, c, b, d, c); }
trailGeo.setIndex(trailIdx);
const trailMesh = new THREE.Mesh(trailGeo, new THREE.MeshBasicMaterial({ vertexColors: true, transparent: true, depthWrite: false, side: THREE.DoubleSide }));
trailMesh.frustumCulled = false; scene.add(trailMesh);
const trailPts = [];   // {p: Vector3, t: seconds}, newest first

const blobTex = (() => { const c = document.createElement('canvas'); c.width = c.height = 64; const x = c.getContext('2d'); const g = x.createRadialGradient(32, 32, 4, 32, 32, 31); g.addColorStop(0, 'rgba(0,0,0,1)'); g.addColorStop(0.55, 'rgba(0,0,0,.85)'); g.addColorStop(1, 'rgba(0,0,0,0)'); x.fillStyle = g; x.fillRect(0, 0, 64, 64); return new THREE.CanvasTexture(c); })();
const blob = new THREE.Mesh(new THREE.CircleGeometry(1, 24), new THREE.MeshBasicMaterial({ map: blobTex, transparent: true, opacity: 0.7, depthWrite: false, polygonOffset: true, polygonOffsetFactor: -2, polygonOffsetUnits: -2 }));
blob.renderOrder = 2;
blob.rotation.x = -Math.PI / 2; scene.add(blob);
const bounceMarks = [];
function addBounceMark(x, z) {
  const m = new THREE.Mesh(new THREE.RingGeometry(0.3, 0.9, 20), new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.8, depthWrite: false }));
  m.rotation.x = -Math.PI / 2; m.position.set(x, 0.03, z); m.userData.age = 0; scene.add(m); bounceMarks.push(m);
}

// ---- Mii actors ------------------------------------------------------------------------------
function stripArms(mesh) {
  // The game's Miis have no arms: drop every triangle driven by arm/hand bones and use floating hands instead.
  const g = mesh.geometry.clone();
  const names = mesh.skeleton.bones.map((b) => b.name);
  const arm = new Set(); names.forEach((n, i) => { if (/^(arm|wrist|finger|thumb)_/.test(n) || /^head/.test(n)) arm.add(i); });   // also drops the neck (head bones) so no neck shows through the ghost
  const si = g.attributes.skinIndex, sw = g.attributes.skinWeight;
  const dom = (v) => { let best = 0, bw = -1; for (let k = 0; k < 4; k++) { const w = sw.getComponent(v, k); if (w > bw) { bw = w; best = si.getComponent(v, k); } } return best; };
  const idx = g.index ? Array.from(g.index.array) : [...Array(g.attributes.position.count).keys()];
  const out = [];
  for (let i = 0; i < idx.length; i += 3) {
    let c = 0; for (let j = 0; j < 3; j++) if (arm.has(dom(idx[i + j]))) c++;
    if (c < 2) out.push(idx[i], idx[i + 1], idx[i + 2]);
  }
  g.setIndex(out); mesh.geometry = g;
}

const clamp1 = (v, m) => Math.max(-m, Math.min(m, v));
class Actor {
  constructor(gltf, color, seat) {
    this.seat = seat;
    this.root = new THREE.Group();
    this.model = SkeletonUtils.clone(gltf.scene);
    this.model.scale.setScalar(MII_SCALE);
    this.fade = [];   // [material, baseOpacity, ghostOpacity]
    const mk = (opts, ghost) => { const m = new THREE.MeshStandardMaterial({ roughness: 0.7, side: THREE.DoubleSide, ...opts }); this.fade.push([m, 1, ghost]); return m; };
    this.mat = mk({ color }, 0.2);
    this.model.traverse((o) => { if (o.isMesh) { o.material = this.mat; o.castShadow = true; o.frustumCulled = false; if (o.isSkinnedMesh) stripArms(o); } });
    this.root.add(this.model);
    this.bones = {};
    this.model.traverse((o) => { if (o.isBone) this.bones[o.name] = o; });
    // placeholder head (the animation rig has no head mesh) with face dots
    const head = new THREE.Mesh(new THREE.SphereGeometry(1.8, 20, 16), mk({ color: 0xf2c9a0, roughness: 0.6 }, 0.2));
    head.scale.setScalar(1.5); head.position.set(2.3, 0, 0); head.castShadow = true;
    this.headPivot = new THREE.Group(); this.headPivot.add(head); this.bones.head.add(this.headPivot);   // bobble head: the pivot springs around the neck joint
    this.bob = { ay: 0, az: 0, vy: 0, vz: 0, prev: null, pv: new THREE.Vector3(), t: Math.random() * 6 };
    const eyeM = new THREE.MeshBasicMaterial({ color: 0x1a1a1a, transparent: true });
    this.fade.push([eyeM, 1, 0.2]);
    for (const z of [-0.8, 0.8]) { const e = new THREE.Mesh(new THREE.SphereGeometry(0.2, 8, 6), eyeM); e.position.set(0.4, 1.6, z * 0.9); head.add(e); }
    // floating ball hands (like the game) and a placeholder paddle in the right one
    const handM = mk({ color: 0xffffff, roughness: 0.5 }, 0.3);
    for (const side of ['l', 'r']) {
      const h = new THREE.Mesh(new THREE.SphereGeometry(0.95, 16, 12), handM);
      h.position.set(0.9, 0, 0); h.castShadow = true;
      this.bones['wrist_' + side].add(h);
      if (side === 'r') this.handR = h;
    }
    // placeholder racket in the game's mesh frame: thin axis X, blade width Y, handle along -Z, blade centre 2.4 ahead of the origin.
    // It is a free object (not parented to the hand): its pose comes from the controller via RacketPose (recovered game logic).
    const pad = new THREE.Group();
    const handle = new THREE.Mesh(new THREE.BoxGeometry(0.3, 0.4, 1.95), mk({ color: 0xc89b5b }, 0.35));
    handle.position.z = -0.225;
    const rubber = mk({ color: 0xcc2b2b, roughness: 0.5 }, 0.4), black = mk({ color: 0x1b1b1b }, 0.4);
    const blade = new THREE.Mesh(new THREE.CylinderGeometry(1.7, 1.7, 0.1, 28), rubber);
    blade.rotation.z = Math.PI / 2; blade.position.set(0.07, 0, 2.4);
    const back = new THREE.Mesh(new THREE.CylinderGeometry(1.7, 1.7, 0.1, 28), black);
    back.rotation.z = Math.PI / 2; back.position.set(-0.07, 0, 2.4);
    pad.add(handle, blade, back);
    pad.traverse((o) => { if (o.isMesh) o.castShadow = true; });
    scene.add(pad);
    this.rp = new RacketPose(false); this.rh = new RemoteHeading(); this.tickAcc = 0; this.prevTheta = null; this.syn = null;
    this.paddle = pad;
    this.ghost = false; this._init = false; this.setGhost(false);

    this.mixer = new THREE.AnimationMixer(this.model);
    this.clips = {};
    for (const c of gltf.animations) this.clips[c.name.replace('WS2_png_ava_', '')] = c;
    this.cur = null; this.base = 'wait';
    this.mixer.addEventListener('finished', () => { this.cur = null; this.loop(this.base); });
    this.contact = {}; this.peak = {};
  }
  setGhost(on) {
    if (this.ghost === on && this._init) return;
    this.ghost = on; this._init = true;
    for (const [m, base, g] of this.fade) { m.transparent = on || base < 1; m.opacity = on ? g : base; m.depthWrite = !on; m.needsUpdate = true; }
  }
  // find the frame of fastest paddle-hand motion in each swing clip so the hit lines up with the animation
  analyse() {
    const p = new THREE.Vector3(), prev = new THREE.Vector3();
    for (const name of Object.keys(this.clips)) {
      if (!/^(fore|back)/.test(name)) continue;
      const clip = this.clips[name]; const act = this.mixer.clipAction(clip); act.play();
      let best = 0, bt = 0.1, first = true;
      for (let t = 0; t <= clip.duration; t += 1 / 60) {
        this.mixer.setTime(t); this.root.updateMatrixWorld(true);
        this.handR.getWorldPosition(p); this.root.worldToLocal(p);
        if (!first) { const v = p.distanceTo(prev) * 60; if (v > best) { best = v; bt = t; } }
        prev.copy(p); first = false;
      }
      act.stop(); this.contact[name] = bt; this.peak[name] = best;
    }
    this.mixer.stopAllAction(); this.mixer.setTime(0);
    this.loop('wait');
  }
  act(name, loop) {
    const clip = this.clips[name]; if (!clip) return null;
    const a = this.mixer.clipAction(clip);
    a.reset(); a.enabled = true;
    a.setLoop(loop ? THREE.LoopRepeat : THREE.LoopOnce, Infinity); a.clampWhenFinished = !loop;
    return a;
  }
  // serve-wait pose: servewait_F and servewait_B cross-weighted by the remote yaw (recovered from the game)
  serveWait(u) {
    if (!this.sw) {
      const f = this.act('servewait_F', true), b = this.act('servewait_B', true);
      if (!f || !b) return;
      f.play(); b.play(); this.sw = { f, b };
      if (this.active) this.active.fadeOut(0.1);
      this.active = null; this.cur = null; this.base = 'servewait';
    }
    this.sw.f.setEffectiveWeight(u); this.sw.b.setEffectiveWeight(1 - u);
  }
  endServeWait() { if (this.sw) { this.sw.f.stop(); this.sw.b.stop(); this.sw = null; this.base = 'wait'; this.loop('wait'); } }
  loop(name) {
    this.base = name;
    if (name === 'servewait') return;
    if (this.cur) return;
    this.fadeTo(this.act(name, true));
  }
  setBase(name) { if (name !== this.base) { this.base = name; if (!this.cur) this.fadeTo(this.act(name, true)); } }
  once(name, speed = 1) {
    if (this.sw) { this.sw.f.stop(); this.sw.b.stop(); this.sw = null; }
    const a = this.act(name, false); if (!a) return;
    a.timeScale = speed;
    if (this.contact[name] !== undefined) a.time = Math.max(0, this.contact[name] - 0.13);   // contact lands on the hit
    this.cur = a; this.fadeTo(a, 0.05);
  }
  fadeTo(next, t = 0.12) {
    if (!next) return;
    if (this.active && this.active !== next) { this.active.fadeOut(t); next.fadeIn(t); }
    next.play(); this.active = next;
  }
  // Racket pose from the controller orientation, ticked at 60 Hz with the recovered game filters (research/racket.md).
  // tilt = {y: phone top edge, z: screen normal} in the player's frame (x right, y forward, z up); null for CPU / mouse players.
  swingStart(side, power, hand) {
    this.rp.startSwing(side === 1 ? 1 : 0, power > 0.7 ? 75 : 45);
    // without a phone, fake the controller sweep (the game drives the CPU through a synthetic swing the same way)
    this.syn = { t: 0, dir: side * hand };
  }
  // The server computes the racket pose (the same pose it uses for contact with the ball): free object in world space.
  // The hand ball is moved onto the handle so the character visibly holds it.
  applyRk(rk) {
    if (!rk) { this.paddle.visible = false; return; }
    this.paddle.visible = this.root.visible;
    const X = new THREE.Vector3(...rk.X), Y = new THREE.Vector3(...rk.Y), Z = new THREE.Vector3(...rk.Z);
    this.paddle.quaternion.setFromRotationMatrix(new THREE.Matrix4().makeBasis(X, Y, Z));
    this.paddle.position.set(...rk.pos);
    this.model.updateMatrixWorld(true);
    const hand = new THREE.Vector3(...rk.pos).addScaledVector(Z, -0.35);
    this.handR.position.copy(this.bones.wrist_r.worldToLocal(hand));
  }
  driveRacket(tilt, hand, dt, live) {
    this.rp.lefty = hand === -1;
    this.tickAcc += dt;
    let steps = 0;
    while (this.tickAcc >= 1 / 60 && steps < 6) {
      this.tickAcc -= 1 / 60; steps++;
      let p, twist = 0;
      if (tilt) {
        p = [-tilt.y[0], tilt.y[2], tilt.y[1]];                                // calibrated frame -> game frame (x = player's left)
        const n = [-tilt.z[0], tilt.z[2], tilt.z[1]];
        const len = Math.hypot(...p) || 1; p = p.map((v) => v / len);
        // roll of the screen normal about the pointing axis, measured against world up; its change per tick is the controller twist
        let r = [-p[1] * p[0], 1 - p[1] * p[1], -p[1] * p[2]]; const rl = Math.hypot(...r);
        if (rl < 0.2) r = [0, 0, 1]; else r = r.map((v) => v / rl);
        const pr = [p[1] * r[2] - p[2] * r[1], p[2] * r[0] - p[0] * r[2], p[0] * r[1] - p[1] * r[0]];
        const th = Math.atan2(n[0] * pr[0] + n[1] * pr[1] + n[2] * pr[2], n[0] * r[0] + n[1] * r[1] + n[2] * r[2]) * 180 / Math.PI;
        if (this.prevTheta !== null) { let d = th - this.prevTheta; if (d > 180) d -= 360; if (d < -180) d += 360; twist = d; }
        this.prevTheta = th; this.syn = null;
      } else {
        let psi = 0;
        if (this.syn) {
          this.syn.t += 1 / 60; const u = Math.min(1, this.syn.t / 0.32);
          psi = this.syn.dir * 55 * (1 - 2 * (0.5 - 0.5 * Math.cos(Math.PI * u)));      // sweeps +55 -> -55 degrees across the body
          if (u >= 1) this.syn = null;
        }
        const a = psi * Math.PI / 180, ph = 0.2;
        p = [-Math.sin(a) * Math.cos(ph), Math.sin(ph), Math.cos(a) * Math.cos(ph)];
        this.prevTheta = null;
      }
      const hs = this.rh.update(p);
      this.root.updateMatrixWorld(true);
      const cw = this.bones.chest.getWorldPosition(new THREE.Vector3());
      const cl = this.root.worldToLocal(cw);
      this.out = this.rp.tick(p, twist, hs, live, [cl.x, cl.y, cl.z], null);
    }
    if (!this.out) return;
    const m = this.rp.model(this.out);
    const [X, Y, Z] = m.cols;
    const q = new THREE.Quaternion().setFromRotationMatrix(new THREE.Matrix4().makeBasis(new THREE.Vector3(...X), new THREE.Vector3(...Y), new THREE.Vector3(...Z)));
    this.paddle.quaternion.copy(this.root.quaternion).multiply(q);
    this.paddle.position.copy(this.root.localToWorld(new THREE.Vector3(...m.pos)));
    this.paddle.visible = this.root.visible;
  }
  place(x, z, facing, lefty) {
    this.root.position.set(x, FLOOR, z);
    this.root.rotation.y = facing;
    this.model.scale.x = (lefty ? -1 : 1) * MII_SCALE;
  }
  update(dt) {
    this.mixer.update(dt);
    // bobble head: damped spring driven by the head's own acceleration (in neck-local axes) plus a little idle bob
    const B = this.bob, hp = this.headPivot; if (!hp || dt <= 0) return;
    this.root.updateMatrixWorld(true);
    const w = new THREE.Vector3(); hp.parent.getWorldPosition(w);
    if (B.prev) {
      const v = w.clone().sub(B.prev).divideScalar(dt), acc = v.clone().sub(B.pv).divideScalar(dt);
      B.pv.copy(v);
      const inv = hp.parent.matrixWorld.clone().invert(); acc.transformDirection(inv).multiplyScalar(acc.length());
      const g = 0.012;
      B.vy += clamp1(-acc.z * g, 8) * 1; B.vz += clamp1(acc.y * g, 8) * 1;
    }
    B.prev = w;
    B.t += dt;
    const k = 70, c = 1.4;
    B.vy += (-k * B.ay - c * B.vy) * dt; B.vz += (-k * B.az - c * B.vz) * dt;
    B.ay += B.vy * dt; B.az += B.vz * dt;
    B.ay = Math.max(-1.0, Math.min(1.0, B.ay)); B.az = Math.max(-1.0, Math.min(1.0, B.az));
    hp.rotation.set(0, B.ay + Math.sin(B.t * 3.1) * 0.03, B.az + Math.sin(B.t * 2.3) * 0.03);
  }
  kickHead(a) { if (this.bob) { this.bob.vy += a * (Math.random() < 0.5 ? -1 : 1); this.bob.vz += a * (Math.random() * 2 - 1); } }
}

const actors = [];
const loader = new GLTFLoader();
const gltf = await loader.loadAsync('/assets/mii_pingpong.glb');
for (let i = 0; i < 2; i++) {
  const a = new Actor(gltf, COLORS[i], i);
  scene.add(a.root); actors.push(a);
}
for (const a of actors) a.analyse();
document.getElementById('loading').remove();

// facing: seat 0 stands at +z and faces -z
const FACE_OFFSET = Math.PI / 2;   // rig forward axis -> -z; tuned visually
function seatZ(i) { return (i === 0 ? 1 : -1) * (PLANE + 1.8); }

// ---- cameras -----------------------------------------------------------------------------------
let camMode = 0;
const camPos = new THREE.Vector3(), camLook = new THREE.Vector3();
const ballV = new THREE.Vector3(0, 0, 0);
const seatPos = [{ x: 0, z: 22.3 }, { x: 0, z: -22.3 }];
const ballVel = new THREE.Vector3();
let ballLive = false;

// ===== Main gameplay camera, recovered from the game executable (research/camera.md, USA Rev 1) =====
// Everything is computed in the game seat-local frame (the player stands at z < 0 looking toward +z, y up, table top y = 0);
// seat 0 is our +z end, so its local frame is our world rotated 180 degrees about Y.
const CAM = { FOV: 33, NEAR: 10, FAR: 5000, RAMP: 0.008, FOLLOW: 0.1, SLERP: 0.05, DIST: 40, FLOOR: -6, PASSES: 451 };
const V3 = (x, y, z) => new THREE.Vector3(x, y, z);
function frustumPlanes(fov, aspect, mL, mR) {
  const tn = Math.tan(fov * Math.PI / 360), tx = tn * aspect;
  const C1 = V3(tx * mR, -tn, -1), C2 = V3(tx * mR, tn * 0.7, -1), C3 = V3(-tx * mL, tn * 0.7, -1), C4 = V3(-tx * mL, -tn, -1);
  const mk = (a, b) => { const n = new THREE.Vector3().crossVectors(a, b).normalize(); if (n.dot(V3(0, 0, -10)) > 0) n.negate(); return n; };
  return { left: mk(C3, C4), right: mk(C1, C2), top: mk(C2, C3), bottom: mk(C4, C1) };
}
class GameCam {
  constructor(seat) { this.seat = seat; this.orb = 0; this.ramp = 0; this.pos = new THREE.Vector3(); this.b = [V3(-1, 0, 0), V3(0, 1, 0), V3(0, 0, 1)]; this.ready = false; }
  toLocal(v) { return this.seat === 0 ? V3(-v.x, v.y, -v.z) : v.clone(); }
  toWorld(v) { return this.seat === 0 ? V3(-v.x, v.y, -v.z) : v.clone(); }
  target(T, B, aspect, fov) {
    const e = 0.5 * (1 - Math.cos(Math.PI * this.ramp));
    const pitch = (-20 + 15 * e) * Math.PI / 180, cp = Math.cos(pitch), sp = Math.sin(pitch);
    const M = [V3(-1, 0, 0), V3(0, cp, -sp), V3(0, -sp, -cp)];           // rows: right, up, back (camera looks along -row2)
    const O = V3(0, 14, 0).lerp(V3(0, 10, -8), e);
    const P = T.clone().add(O).addScaledVector(M[2], CAM.DIST);
    const Q = T.clone().add(V3(0, 10, 0));
    const lo = aspect < 1.5 ? 0.8 : 0.85, hi = aspect < 1.5 ? 0.9 : 0.95;
    const pl = frustumPlanes(fov, aspect, this.seat === 0 ? lo : hi, this.seat === 0 ? hi : lo);
    const out = (n, p) => n.dot(p) + 0.5 > 0;
    let f30 = 0, last = -1;
    for (let pass = 0; pass < CAM.PASSES; pass++) {
      const view = (p) => { const d = p.clone().sub(P); return V3(M[0].dot(d), M[1].dot(d), M[2].dot(d)); };
      const pb = view(B), pq = view(Q);
      const top = out(pl.top, pb), bottom = out(pl.bottom, pb);
      const r23 = out(pl.left, pb) ? 0 : out(pl.right, pb) ? 1 : -1;
      const r20 = out(pl.left, pq) ? 0 : out(pl.right, pq) ? 1 : -1;
      if (!top && !bottom && r23 < 0 && r20 < 0) break;
      if (top) {
        f30 += 0.01; const a = f30 * Math.PI / 180, c = Math.cos(a), s = Math.sin(a);
        const n1 = M[1].clone().multiplyScalar(c).addScaledVector(M[2], s), n2 = M[2].clone().multiplyScalar(c).addScaledVector(M[1], -s);
        M[1] = n1; M[2] = n2;
        if (!bottom && r23 < 0 && r20 < 0) continue;
      }
      let dolly = bottom, dir = 0;
      if (!dolly) {
        if (r23 >= 0) { dir = r23; if (r20 >= 0 && r20 === (r23 ^ 1)) dolly = true; } else if (r20 >= 0) dir = r20;
      }
      if (!dolly && (dir ^ 1) === last) dolly = true;
      if (dolly) P.addScaledVector(M[2], 0.05); else { last = dir; P.addScaledVector(M[0], dir ? 0.2 : -0.2); }
    }
    return { P, M };
  }
  // dt in seconds; the game rates are per 60 Hz frame
  update(dt, serving, aspect, fov) {
    const fr = dt * 60;
    this.ramp = Math.min(1, Math.max(0, this.ramp + (serving ? 1 : -1) * CAM.RAMP * fr));
    const sp = seatPos[this.seat];
    const T = this.toLocal(V3(sp.x, 0, sp.z)); T.y = CAM.FLOOR;
    let B = V3(0, 0, 0);
    if (ballLive) B = this.toLocal(ballV.clone().addScaledVector(ballVel, 20 / 240));   // ~20 ball sub-steps ahead
    const { P, M } = this.target(T, B, aspect, fov);
    // the broadcast view swings around the table toward the ball's side (the table is not seen square-on)
    const orbT = ballLive ? -Math.max(-0.32, Math.min(0.32, B.x * 0.035)) : 0;
    this.orb += (orbT - this.orb) * (1 - Math.pow(0.94, fr));
    if (!this.ready) { this.pos.copy(P); this.b = M; this.ready = true; }
    else {
      const b0 = M[0].clone();
      let b2 = new THREE.Vector3().crossVectors(b0, this.b[1]); if (b2.lengthSq() < 1e-9) b2 = M[2].clone(); b2.normalize();
      const b1 = new THREE.Vector3().crossVectors(b2, b0);
      const q1 = new THREE.Quaternion().setFromRotationMatrix(new THREE.Matrix4().makeBasis(b0, b1, b2));
      const q2 = new THREE.Quaternion().setFromRotationMatrix(new THREE.Matrix4().makeBasis(M[0], M[1], M[2]));
      q1.slerp(q2, 1 - Math.pow(1 - CAM.SLERP, fr));
      const m = new THREE.Matrix4().makeRotationFromQuaternion(q1);
      this.b = [V3(0, 0, 0), V3(0, 0, 0), V3(0, 0, 0)]; m.extractBasis(this.b[0], this.b[1], this.b[2]);
      this.pos.lerp(P, 1 - Math.pow(1 - CAM.FOLLOW, fr));
    }
  }
  apply(cam) {
    const co = Math.cos(this.orb), so = Math.sin(this.orb);
    const rot = (v) => V3(v.x * co + v.z * so, v.y, -v.x * so + v.z * co);
    const p = this.toWorld(rot(this.pos)), r = this.b.map((v) => this.toWorld(rot(v)));
    cam.position.copy(p);
    cam.quaternion.setFromRotationMatrix(new THREE.Matrix4().makeBasis(r[0], r[1], r[2]));
    cam.updateMatrixWorld(true);
  }
}
const gameCams = [new GameCam(0), new GameCam(1)];
function gameFov(aw, ah) { const a = aw / ah; return CAM.FOV * (a < 1.3 ? (1.3 / a) ** 0.6 : 1); }   // browser-window fallback for narrow views
function mainSeat() { const s = latest; if (!s) return 0; return s.seats[0].kind === 'human' ? 0 : s.seats[1].kind === 'human' ? 1 : 0; }

const camTargets = [
  null,                                      // 0: the game camera (behind the human player)
  () => [[-44, 15, 2], [0, 1, 0]],          // 1: side
  null,                                      // 2: the game camera for the other seat
  () => [[0, 56, 16], [0, 0, -2]],          // 3: overhead
];
function applyCam(dt) {
  const w = innerWidth, h = innerHeight;
  if (camMode === 0 || camMode === 2) {
    const seat = camMode === 0 ? mainSeat() : 1 - mainSeat();
    const fov = gameFov(w, h);
    const gc = gameCams[seat];
    gc.update(dt, !!latest && latest.phase === 'serve' && latest.server === seat, w / h, fov);
    gc.apply(camera);
    camera.aspect = w / h; camera.fov = fov; camera.near = CAM.NEAR; camera.far = CAM.FAR; camera.updateProjectionMatrix();
    return;
  }
  const [p, l] = camTargets[camMode]();
  const k = 1 - Math.exp(-dt * 4.5);
  camPos.lerp(new THREE.Vector3(...p), k); camLook.lerp(new THREE.Vector3(...l), k);
  camera.aspect = w / h; camera.fov = w / h < 1.4 ? 42 * (1.4 / (w / h)) ** 0.6 : 42; camera.near = 0.5; camera.far = 600; camera.updateProjectionMatrix();
  camera.position.copy(camPos); camera.lookAt(camLook);
}
camPos.set(0, 19, 52); camLook.set(0, -1.5, -4);

function resize() {
  const w = innerWidth, h = innerHeight;
  renderer.setSize(w, h, false);
  camera.aspect = w / h;
  // widen FOV on narrow windows so the whole table fits
  camera.fov = w / h < 1.4 ? 42 * (1.4 / (w / h)) ** 0.6 : 42;
  camera.updateProjectionMatrix();
}
addEventListener('resize', resize); resize();

// ---- audio (synthesised placeholders) ---------------------------------------------------------
let actx = null, muted = false;
// browsers keep audio suspended until the page gets a click or key press: unlock on the first one, and show a hint until then
for (const ev of ['pointerdown', 'keydown']) addEventListener(ev, () => { audio(); if (actx && actx.state !== 'running') actx.resume(); }, { capture: true });
function audio() { if (!actx) { try { actx = new (window.AudioContext || window.webkitAudioContext)(); loadSfx(); } catch { } } return actx; }
// ripped game sound effects (public/sfx, cut from the SE_PNG_* renders by tools/extract_sfx.py)
const sfxBuf = {}; let sfxList = null;
async function loadSfx() {
  try {
    sfxList = await (await fetch('/sfx/manifest.json')).json();
    for (const names of Object.values(sfxList)) for (const n of names) {
      const ab = await (await fetch('/sfx/' + n + '.wav')).arrayBuffer();
      sfxBuf[n] = await actx.decodeAudioData(ab);
    }
  } catch (e) { console.warn('sfx load failed', e); }
}
function play(group, vol = 1, rate = 1) {
  const c = audio(); const list = sfxList && sfxList[group];
  if (!c || muted || !list) return false;
  const buf = sfxBuf[list[(Math.random() * list.length) | 0]]; if (!buf) return false;
  const src = c.createBufferSource(), g = c.createGain();
  src.buffer = buf; src.playbackRate.value = rate * Math.pow(2, (Math.random() * 2 - 0.5) / 12); g.gain.value = vol * (0.85 + Math.random() * 0.15);
  src.connect(g).connect(c.destination); src.start();
  return true;
}
function blip(freq, dur, type = 'sine', vol = 0.2, slide = 0) {
  const c = audio(); if (!c || muted) return;
  const o = c.createOscillator(), g = c.createGain();
  o.type = type; o.frequency.value = freq; if (slide) o.frequency.exponentialRampToValueAtTime(Math.max(freq + slide, 30), c.currentTime + dur);
  g.gain.setValueAtTime(vol, c.currentTime); g.gain.exponentialRampToValueAtTime(0.0001, c.currentTime + dur);
  o.connect(g).connect(c.destination); o.start(); o.stop(c.currentTime + dur);
}
const sfx = {
  hit: (speed, tw = 0) => { if (!play(tw >= 0.4 ? 'drive' : tw <= -0.4 ? 'cut' : 'hit', 0.9)) { blip(1500 + Math.min(speed, 200) * 4, 0.07, 'square', 0.12, -900); blip(260, 0.09, 'triangle', 0.15); } },
  smash: () => { if (!play('smashhit', 1)) blip(200, 0.2, 'sawtooth', 0.2, -100); play('smashshot', 0.7); },
  bounce: (speed) => { if (!play('bounce', Math.min(1, Math.max(0.4, (speed / 240 - 0.01) * 6)))) blip(700 + Math.min(speed, 60) * 6, 0.05, 'triangle', Math.min(0.18, 0.04 + speed / 300)); },
  net: () => { if (!play('net', 0.9)) blip(180, 0.12, 'sawtooth', 0.12, -60); },
  swing: (power) => play(power > 0.6 ? 'swing_l' : 'swing_s', 0.5),
  point: () => { if (!play('whistle_miss', 0.8)) { blip(660, 0.14, 'sine', 0.18); setTimeout(() => blip(880, 0.2, 'sine', 0.18), 120); } },
  over: () => { if (!play('whistle_end', 0.9)) [523, 659, 784, 1046].forEach((f, i) => setTimeout(() => blip(f, 0.3, 'sine', 0.2), i * 140)); },
  toss: () => { if (!play('toss', 0.8)) blip(500, 0.12, 'sine', 0.1, 400); },
};

// ---- network ---------------------------------------------------------------------------------
const buf = [];      // snapshots with arrival time
let latest = null;
let ws;
function connect() {
  ws = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws');
  ws.onopen = () => ws.send(JSON.stringify({ t: 'hello', role: 'host' }));
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.t === 's') onSnap(m); };
  ws.onclose = () => setTimeout(connect, 1000);
}
connect();
const send = (o) => ws && ws.readyState === 1 && ws.send(JSON.stringify(o));

function onSnap(s) {
  s.at = performance.now();
  buf.push(s); if (buf.length > 12) buf.shift();
  latest = s;
  for (const e of s.ev) handleEvent(e, s);
  updateHud(s);
}

function swingAnim(side, power, hand) {
  // right-hander: forehand uses 'fore'; the model is mirrored for left-handers so the same clips apply
  const base = side === 1 ? 'fore' : 'back';
  const suf = power > 0.95 ? '_SP3' : power > 0.85 ? '_SP2' : power > 0.72 ? '_SP' : '';
  return base + suf;
}

const lastSide = [1, 1];
function b0hand(seat) { const s = latest; return s && s.seats[seat].hand === -1 ? -1 : 1; }
let flashT = 0;
let scoredUntil = 0;
function showScored(name) { const el = $('scored'); el.textContent = name.toUpperCase() + ' SCORED!'; el.classList.remove('show'); void el.offsetWidth; el.classList.add('show'); $('dim').classList.add('on'); scoredUntil = performance.now() + 2300; setTimeout(() => { if (performance.now() >= scoredUntil - 50) { el.classList.remove('show'); $('dim').classList.remove('on'); } }, 2300); }
function flashMsg(t) { $('msg').textContent = t; flashT = performance.now() + 900; }
function handleEvent(e, s) {
  switch (e.type) {
    case 'swing': {
      lastSide[e.seat] = e.side; sfx.swing(e.power); actors[e.seat].kickHead(6);
      const a = actors[e.seat];
      if (s.phase === 'serve' && s.server === e.seat && s.serveStage === 'toss') a.once(e.side === 1 ? 'serve_F' : 'serve_B', 1);
      else a.once(e.side === 1 ? 'fore' : 'back', 1);   // reach-based variant is chosen on the hit event
      break;
    }
    case 'toss': sfx.toss(); break;   // the game never plays the toss clips in table tennis; the serve-wait pose simply continues
    case 'hit': {
      sfx.hit(e.speed, e.tw); if (actors[e.seat]) actors[e.seat].kickHead(10);
      if (!e.serve && e.reachX !== undefined) {
        // clip variant from the reach at contact (recovered thresholds): lateral >=13 SP3, >=9 SP2, >=6 SP; forward >=8 front
        const f1 = e.reachX, f2 = e.reachF, suf = f1 >= 13 ? '_SP3' : f1 >= 9 ? '_SP2' : f1 >= 6 ? '_SP' : '';
        if (suf) actors[e.seat].once((e.side === 1 ? 'fore' : 'back') + suf);
        else if (f2 >= 8) actors[e.seat].once('front');
      }
      break;
    }
    case 'smash': {
      sfx.smash(); flashMsg('SMASH!'); break;
    }
    case 'bounce': sfx.bounce(e.speed); addBounceMark(e.x, e.z); break;
    case 'bounce2': sfx.bounce(e.speed); break;
    case 'netTouch': sfx.net(); break;
    case 'point': sfx.point(); actors[1 - e.winner].once('waitLose'); { const bp = ball.position.clone(); bp.y = Math.max(bp.y, FLOOR + 1); goalExplosion(bp, e.winner === 0 ? 0xe0463d : 0x2f6fe0); showScored(seatNames[e.winner] || 'Player ' + (e.winner + 1), e.winner); for (const a of actors) a.kickHead(8); } break;
    case 'over': sfx.over(); break;
  }
}

// ---- goal explosion (Rocket League style): particle burst, shockwave rings, flash --------------------------------
const booms = [];
function goalExplosion(pos, color) {
  const N = 220, g = new THREE.BufferGeometry();
  const P = new Float32Array(N * 3), V = [], C = new Float32Array(N * 3);
  const base = new THREE.Color(color), white = new THREE.Color(0xffffff), gold = new THREE.Color(0xffc23d);
  for (let i = 0; i < N; i++) {
    P[i * 3] = pos.x; P[i * 3 + 1] = pos.y; P[i * 3 + 2] = pos.z;
    const th = Math.random() * Math.PI * 2, ph = Math.acos(1 - Math.random() * 1.7), sp = 14 + Math.random() * 34;
    V.push(new THREE.Vector3(Math.sin(ph) * Math.cos(th), Math.cos(ph) * 0.9 + 0.25, Math.sin(ph) * Math.sin(th)).multiplyScalar(sp));
    const c = (i % 3 === 0 ? white : i % 3 === 1 ? base : gold); C[i * 3] = c.r; C[i * 3 + 1] = c.g; C[i * 3 + 2] = c.b;
  }
  g.setAttribute('position', new THREE.BufferAttribute(P, 3)); g.setAttribute('color', new THREE.BufferAttribute(C, 3));
  const pts = new THREE.Points(g, new THREE.PointsMaterial({ size: 1.1, vertexColors: true, transparent: true, opacity: 1, depthWrite: false, blending: THREE.AdditiveBlending, sizeAttenuation: true }));
  pts.frustumCulled = false; scene.add(pts);
  const mkRing = (col, w) => { const m = new THREE.Mesh(new THREE.RingGeometry(0.85, 1, 48), new THREE.MeshBasicMaterial({ color: col, transparent: true, opacity: 0.95, side: THREE.DoubleSide, depthWrite: false, blending: THREE.AdditiveBlending })); m.position.copy(pos); scene.add(m); return m; };
  const ringH = mkRing(color), ringV = mkRing(0xffffff); ringH.rotation.x = -Math.PI / 2;
  const flash = new THREE.Mesh(new THREE.SphereGeometry(1, 20, 14), new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.95, depthWrite: false, blending: THREE.AdditiveBlending }));
  flash.position.copy(pos); scene.add(flash);
  booms.push({ t: 0, pts, V, ringH, ringV, flash, pos: pos.clone() });
  shake = 1;
}
let shake = 0;
function shakeCam() { if (shake <= 0) return; const a = shake * shake * 2.4; camera.position.x += (Math.random() - 0.5) * a; camera.position.y += (Math.random() - 0.5) * a; camera.position.z += (Math.random() - 0.5) * a; camera.rotateZ((Math.random() - 0.5) * a * 0.03); }
function updateBooms(dt) {
  for (let i = booms.length - 1; i >= 0; i--) {
    const b = booms[i]; b.t += dt; const t = b.t, L = 1.6;
    const P = b.pts.geometry.attributes.position;
    for (let k = 0; k < b.V.length; k++) {
      const v = b.V[k]; v.y -= 30 * dt; v.multiplyScalar(1 - 1.4 * dt);
      P.array[k * 3] += v.x * dt; P.array[k * 3 + 1] += v.y * dt; P.array[k * 3 + 2] += v.z * dt;
    }
    P.needsUpdate = true; b.pts.material.opacity = Math.max(0, 1 - t / L); b.pts.material.size = 1.1 * (1 - 0.5 * t / L);
    const r = 1 + t * 38; b.ringH.scale.setScalar(r); b.ringH.material.opacity = Math.max(0, 0.95 - t / 0.9);
    b.ringV.scale.setScalar(1 + t * 26); b.ringV.material.opacity = Math.max(0, 0.9 - t / 0.7); b.ringV.lookAt(camera ? camera.position : b.pos);
    b.flash.scale.setScalar(1 + t * 40); b.flash.material.opacity = Math.max(0, 0.9 - t / 0.35);
    if (t > L) { scene.remove(b.pts, b.ringH, b.ringV, b.flash); b.pts.geometry.dispose(); booms.splice(i, 1); }
  }
  shake = Math.max(0, shake - dt * 1.4);
}

// ---- HUD ---------------------------------------------------------------------------------------
const $ = (id) => document.getElementById(id);
const seatNames = ['Player 1', 'Player 2'];
function updateHud(s) {
  const inMatch = s.phase !== 'lobby';
  $('score').hidden = !inMatch;
  $('lobby').classList.toggle('hidden', inMatch && s.phase !== 'over' ? true : s.phase !== 'lobby');
  for (let i = 0; i < 2; i++) {
    const n = s.seats[i].name || (s.seats[i].kind === 'cpu' ? 'CPU' : 'Player ' + (i + 1));
    seatNames[i] = n;
    $('n' + i).textContent = n; $('v' + i).textContent = s.score[i];
    $('s' + i).classList.toggle('serving', inMatch && s.server === i);
  }
  if (performance.now() < scoredUntil) $('msg').textContent = '';
  else if (performance.now() > flashT) $('msg').textContent = s.msg || '';
  $('rally').textContent = s.phase === 'rally' && s.rally >= 4 ? `Rally ${s.rally}` : '';
  // lobby seats
  if (s.phase === 'lobby') {
    $('seats').innerHTML = s.seats.map((q, i) => {
      const label = q.kind === 'human' ? (q.online ? 'connected' : 'offline') : q.kind === 'cpu' ? 'CPU' : 'waiting for phone...';
      return `<div class="seat"><i style="background:#${COLORS[i].toString(16).padStart(6, '0')}"></i>${q.name || 'Player ' + (i + 1)}<span class="k">${label}</span></div>`;
    }).join('');
  }
}

async function pollInfo() {
  try {
    const r = await fetch('/api/info'); const j = await r.json();
    $('qr').src = j.qr;
    $('joinurl').textContent = j.joinUrl;
    const hu = (j.publicUrl || location.origin) + '/'; $('hosturl').textContent = hu; $('hosturl').onclick = (ev) => { ev.preventDefault(); try { navigator.clipboard.writeText(hu); $('hostcopied').textContent = 'copied!'; } catch { } };
    const b = $('tbadge'); b.textContent = j.https ? 'HTTPS ready' : 'local only - waiting for tunnel...'; b.classList.toggle('ok', j.https);
  } catch { }
  setTimeout(pollInfo, 2500);
}
pollInfo();

$('start').onclick = () => { audio(); send({ t: 'start', skill: Number($('skill').value), toWin: Number($('towin').value) }); };
let kbdSeated = false;
$('kbd').onclick = () => {
  audio();
  if (kbdSeated) { send({ t: 'kbdleave' }); kbdSeated = false; $('kbdhelp').hidden = true; $('kbd').textContent = 'Play with mouse on this PC'; }
  else { send({ t: 'kbdjoin' }); kbdSeated = true; $('kbdhelp').hidden = false; $('kbd').textContent = 'Stop playing with the mouse'; }
};

// ---- mouse / keyboard player (testing & solo play) -----------------------------------------------
let mouseAim = 0, shift = false;
addEventListener('mousemove', (e) => { mouseAim = (e.clientX / innerWidth - 0.5) * 2; });
addEventListener('contextmenu', (e) => e.preventDefault());
addEventListener('keydown', (e) => {
  if (e.key === 'Shift') shift = true;
  if (e.key === 'c' || e.key === 'C') camMode = (camMode + 1) % camTargets.length;
  if (e.key === 'm' || e.key === 'M') muted = !muted;
  if (e.key === 'v' || e.key === 'V') { splitMode = splitMode === 'auto' ? 'on' : splitMode === 'on' ? 'off' : 'auto'; flashMsg('Split screen: ' + splitMode); }
  if (e.key === 'Escape') send({ t: 'reset' });
  if (e.code === 'Space' && kbdSeated) { e.preventDefault(); send({ t: 'ktoss' }); }
});
addEventListener('keyup', (e) => { if (e.key === 'Shift') shift = false; });
addEventListener('mousedown', (e) => {
  audio();
  if (!kbdSeated || e.target.closest('#lobby')) return;
  send({ t: 'kswing', side: e.button === 2 ? -1 : 1, power: shift ? 0.95 : 0.55, aim: mouseAim, spin: 0.2 });
});

// ---- phone-orientation gizmo (what the server believes the phone's angle is) --------------------
const wScene = new THREE.Scene();
wScene.add(new THREE.AmbientLight(0xffffff, 1.4));
const wLight = new THREE.DirectionalLight(0xffffff, 2.2); wLight.position.set(2, 4, 5); wScene.add(wLight);
const wCam = new THREE.PerspectiveCamera(34, 190 / 210, 0.1, 50); wCam.position.set(2.2, 2.4, 6.4); wCam.lookAt(0, -0.2, 0);
const phone = new THREE.Group();
phone.add(new THREE.Mesh(new THREE.BoxGeometry(1, 2, 0.12), new THREE.MeshStandardMaterial({ color: 0x27313d })));
const scr = new THREE.Mesh(new THREE.PlaneGeometry(0.88, 1.8), new THREE.MeshBasicMaterial({ color: 0x3aa0ff })); scr.position.z = 0.063; phone.add(scr);
const topMark = new THREE.Mesh(new THREE.BoxGeometry(0.46, 0.09, 0.15), new THREE.MeshBasicMaterial({ color: 0xffa23a })); topMark.position.y = 0.96; phone.add(topMark);
// clear racket drawn over the phone: blade toward the phone's top edge, handle toward the bottom, face = screen side
const rkMat = new THREE.MeshBasicMaterial({ color: 0xff4b4b, transparent: true, opacity: 0.42, depthWrite: false });
const blade = new THREE.Mesh(new THREE.CylinderGeometry(0.98, 0.98, 0.05, 40), rkMat);
blade.rotation.x = Math.PI / 2; blade.position.set(0, 0.52, 0.16);
const rkHandle = new THREE.Mesh(new THREE.BoxGeometry(0.2, 1.0, 0.07), new THREE.MeshBasicMaterial({ color: 0xffd28a, transparent: true, opacity: 0.6, depthWrite: false }));
rkHandle.position.set(0, -0.62, 0.16);
const edge = new THREE.LineSegments(new THREE.EdgesGeometry(new THREE.CylinderGeometry(0.98, 0.98, 0.05, 40), 20), new THREE.LineBasicMaterial({ color: 0xffffff }));
edge.rotation.x = Math.PI / 2; edge.position.copy(blade.position);
phone.add(blade, rkHandle, edge);
wScene.add(phone);
const ring = new THREE.Mesh(new THREE.RingGeometry(1.5, 1.56, 48), new THREE.MeshBasicMaterial({ color: 0x9db4cb, side: THREE.DoubleSide }));
ring.rotation.x = -Math.PI / 2; ring.position.y = -1.45; wScene.add(ring);
const tvCone = new THREE.Mesh(new THREE.ConeGeometry(0.22, 0.6, 16), new THREE.MeshBasicMaterial({ color: 0x3ddc84 }));
tvCone.rotation.x = -Math.PI / 2; tvCone.position.set(0, -1.45, -1.9); wScene.add(tvCone);
const phoneQ = [null, null];
function renderTilts(s) {
  if (!s) return;
  const sz = new THREE.Vector2(); renderer.getSize(sz);
  renderer.autoClear = false; renderer.setScissorTest(true);
  for (let i = 0; i < 2; i++) {
    const tile = document.getElementById('tile' + i), tilt = s.seats[i].tilt;
    tile.classList.toggle('on', !!tilt && s.phase !== 'lobby');
    if (!tilt || s.phase === 'lobby') { if (!tilt) phoneQ[i] = null; continue; }
    const r = tile.getBoundingClientRect(); const cr = canvas.getBoundingClientRect();
    const vx = r.left - cr.left, vy = cr.bottom - r.bottom;
    // player frame (x right, y forward, z up) -> view frame (x right, y up, z toward the viewer behind the player)
    const w = (v) => new THREE.Vector3(v[0], v[2], -v[1]);
    const Y = w(tilt.y).normalize(), Z = w(tilt.z).normalize();
    Z.addScaledVector(Y, -Z.dot(Y)).normalize();
    const X = new THREE.Vector3().crossVectors(Y, Z);
    const q = new THREE.Quaternion().setFromRotationMatrix(new THREE.Matrix4().makeBasis(X, Y, Z));
    if (!phoneQ[i]) phoneQ[i] = q.clone(); else phoneQ[i].slerp(q, 0.4);
    phone.quaternion.copy(phoneQ[i]);
    renderer.setViewport(vx, vy, r.width, r.height); renderer.setScissor(vx, vy, r.width, r.height);
    renderer.setClearColor(0x16314d, 1); renderer.clear(true, true, false);
    renderer.render(wScene, wCam);
  }
  renderer.setScissorTest(false); renderer.setViewport(0, 0, sz.x, sz.y); renderer.autoClear = true;
}

// ---- split screen: each human player gets their own game camera, behind their own end of the table -----------
let splitMode = 'auto';   // 'auto' = split when both seats are human, 'on', 'off'  (V toggles)
function isSplit() {
  const s = latest; if (!s || s.phase === 'lobby') return false;
  if (splitMode === 'off') return false;
  return splitMode === 'on' || (s.seats[0].kind === 'human' && s.seats[1].kind === 'human');
}
let wasSplit = false;
function renderViews(dt) {
  const w = innerWidth, h = innerHeight;
  const split = isSplit();
  document.getElementById('divider').style.display = split ? 'block' : 'none';
  document.getElementById('tilts').classList.toggle('split', split);
  if (!split) {
    if (wasSplit) { wasSplit = false; resize(); }
    applyCam(dt); shakeCam();
    renderer.render(scene, camera);
    return;
  }
  wasSplit = true;
  renderer.autoClear = false; renderer.setScissorTest(true);
  for (let i = 0; i < 2; i++) {
    const x = Math.round(i * w / 2), vw = Math.round(w / 2) - (i === 0 ? 1 : 0);
    renderer.setViewport(x, 0, vw, h); renderer.setScissor(x, 0, vw, h); renderer.clear(true, true, false);
    // split-screen on a 4:3 display widens the lens by 7/6 in the game; applied here to the (narrow) halves
    const fov = gameFov(vw, h) * (vw / h < 1.5 ? 7 / 6 : 1);
    gameCams[i].update(dt, latest.phase === 'serve' && latest.server === i, vw / h, fov);
    gameCams[i].apply(camera); shakeCam();
    camera.aspect = vw / h; camera.fov = fov; camera.near = CAM.NEAR; camera.far = CAM.FAR; camera.updateProjectionMatrix();
    actors[i].setGhost(true); actors[1 - i].setGhost(false);   // own character see-through, opponent solid
    renderer.render(scene, camera);
  }
  renderer.setScissorTest(false); renderer.setViewport(0, 0, w, h); renderer.autoClear = true;
}

// ---- render loop -------------------------------------------------------------------------------
const clock = new THREE.Clock();
function interp() {
  if (!buf.length) return null;
  const now = performance.now() - 22;
  let a = buf[0], b = buf[buf.length - 1];
  for (let i = buf.length - 1; i > 0; i--) if (buf[i - 1].at <= now) { a = buf[i - 1]; b = buf[i]; break; }
  const k = b.at === a.at ? 1 : Math.min(1, Math.max(0, (now - a.at) / (b.at - a.at)));
  return { a, b, k };
}
function frame() {
  const hint = document.getElementById('soundhint'); if (hint) hint.style.display = (!actx || actx.state !== 'running') && !muted ? 'block' : 'none';
  const dt = Math.min(clock.getDelta(), 0.05);
  const it = interp();
  if (it) {
    const { a, b, k } = it;
    const jump = Math.hypot(b.ball.p[0] - a.ball.p[0], b.ball.p[1] - a.ball.p[1], b.ball.p[2] - a.ball.p[2]) > 8;
    const kk = jump ? 1 : k;
    for (let i = 0; i < 3; i++) ball.position.setComponent(i, a.ball.p[i] + (b.ball.p[i] - a.ball.p[i]) * kk);
    ballV.copy(ball.position); ballVel.set(b.ball.v[0], b.ball.v[1], b.ball.v[2]); ballLive = b.phase === 'rally' || (b.phase === 'serve' && b.serveStage === 'toss');
    ball.rotation.set(b.ball.q[0], b.ball.q[1], b.ball.q[2]);
    const tNow = performance.now() / 1000;
    const wob = !!b.ball.wob && b.phase === 'rally';
    // colour tells the state: white normally, orange when wobbly (smashable), red after a smash
    const tint = wob ? BALL_WOB : b.ball.sm ? BALL_SMASH : BALL_WHITE;
    ball.material.color.lerp(tint, 1 - Math.exp(-dt * 14));
    if (wob) { ball.position.x += Math.sin(tNow * 38) * 0.07; ball.position.y += Math.cos(tNow * 31) * 0.07; }
    ball.scale.setScalar(b.ball.sm ? 1.15 : 1);
    // trail ribbon
    if (b.phase === 'lobby' || jump) trailPts.length = 0;
    trailPts.unshift({ p: ball.position.clone(), t: tNow });
    while (trailPts.length > TRAIL_MAX || (trailPts.length > 2 && tNow - trailPts[trailPts.length - 1].t > TRAIL_LIFE)) trailPts.pop();
    const nT = b.phase === 'lobby' ? 0 : trailPts.length;
    const tc = wob ? BALL_WOB : b.ball.sm ? BALL_SMASH : BALL_WHITE;
    const camP = camera.position, tmpT = new THREE.Vector3(), tmpS = new THREE.Vector3(), tmpC = new THREE.Vector3();
    for (let i = 0; i < nT; i++) {
      const f = Math.min(1, (tNow - trailPts[i].t) / TRAIL_LIFE);
      const prev = trailPts[Math.max(0, i - 1)].p, next = trailPts[Math.min(nT - 1, i + 1)].p;
      tmpT.copy(prev).sub(next); if (tmpT.lengthSq() < 1e-8) tmpT.set(0, 0, 1);
      tmpC.copy(trailPts[i].p).sub(camP);
      tmpS.crossVectors(tmpT, tmpC); if (tmpS.lengthSq() < 1e-10) tmpS.set(1, 0, 0); tmpS.normalize();
      const ctr = trailPts[i].p.clone();
      if (wob) { ctr.addScaledVector(tmpS, Math.sin(tNow * 24 + i * 0.5) * 0.55 * f); ctr.y += Math.cos(tNow * 21 + i * 0.45) * 0.35 * f; }
      const w = R * 1.0 * Math.pow(1 - f, 0.8);
      const j = i * 2;
      trailPos[j * 3] = ctr.x + tmpS.x * w; trailPos[j * 3 + 1] = ctr.y + tmpS.y * w; trailPos[j * 3 + 2] = ctr.z + tmpS.z * w;
      trailPos[j * 3 + 3] = ctr.x - tmpS.x * w; trailPos[j * 3 + 4] = ctr.y - tmpS.y * w; trailPos[j * 3 + 5] = ctr.z - tmpS.z * w;
      const al = 0.55 * Math.pow(1 - f, 1.3);
      for (let k = 0; k < 2; k++) { const c = (j + k) * 4; trailCol[c] = tc.r; trailCol[c + 1] = tc.g; trailCol[c + 2] = tc.b; trailCol[c + 3] = al; }
    }
    trailGeo.setDrawRange(0, Math.max(0, nT - 1) * 6);
    trailGeo.attributes.position.needsUpdate = true; trailGeo.attributes.color.needsUpdate = true;
    const onTable = Math.abs(ball.position.x) < HW && Math.abs(ball.position.z) < HL && ball.position.y > -0.5;
    blob.position.set(ball.position.x, onTable ? 0.025 : FLOOR + 0.03, ball.position.z);
    const hgt = Math.max(ball.position.y - (onTable ? 0 : FLOOR), 0);
    blob.scale.setScalar(Math.max(1.0, 2.1 - hgt * 0.07)); blob.material.opacity = Math.max(0.4, 0.8 - hgt * 0.02);
    blob.visible = b.phase !== 'lobby';
    ball.visible = b.phase !== 'lobby';
    for (let i = 0; i < 2; i++) {
      const sx = a.seats[i].x + (b.seats[i].x - a.seats[i].x) * k;
      const act = actors[i];
      const sg = i === 0 ? 1 : -1;
      act.root.visible = b.phase !== 'lobby' || b.seats[i].kind !== 'empty';
      const sz = a.seats[i].z + (b.seats[i].z - a.seats[i].z) * k;
      const vx = b.seats[i].vx, vz = b.seats[i].vz, spd = Math.hypot(vx, vz);
      // facing (recovered): toward the point (0, 8) on the opponent half, blended slowly (0.01 per update)
      const wantYaw = Math.atan2(0 - sx, -sg * 8 - sz);
      act.yaw = act.yaw === undefined ? wantYaw : act.yaw + Math.atan2(Math.sin(wantYaw - act.yaw), Math.cos(wantYaw - act.yaw)) * (1 - Math.pow(0.99, 240 * dt));
      act.place(sx, sz, act.yaw, b.seats[i].hand === -1); seatPos[i].x = sx; seatPos[i].z = sz;
      // animation state (recovered): serve-wait blend for the server before the hit; walk when displacement per update >= 0.006
      // (back to idle at <= 0.004; 240 updates/s assumed), walk clip rate = 35 * displacement per update
      const serving = b.phase === 'serve' && b.server === i;
      if (serving) {
        const tl = b.seats[i].tilt;
        const yawDeg = tl ? Math.max(-130, Math.min(145, Math.atan2(tl.y[0], tl.y[1]) * 180 / Math.PI)) : 0;
        const uT = Math.min(1, Math.max(0, (yawDeg + 100) / 200));
        act.swU = (act.swU ?? 0.5) + (uT - (act.swU ?? 0.5)) * (1 - Math.pow(0.95, 60 * dt));
        if (!act.cur) act.serveWait(act.swU);
      } else {
        if (act.sw) act.endServeWait();
        if (!act.walking && spd >= 1.44) act.walking = true; else if (act.walking && spd <= 0.96) act.walking = false;
        let base = act.walking ? 'walk' : 'wait';
        if (b.phase === 'lobby' || b.phase === 'over') base = 'wait';
        if (act.base !== base && !act.cur) act.setBase(base); else if (act.base !== base) act.base = base;
        if (act.base === 'walk' && act.active && !act.cur) act.active.timeScale = Math.min(3, Math.max(0.5, 35 * spd / 240));
      }
      if (!isSplit()) act.setGhost((camMode === 0 && i === mainSeat()) || (camMode === 2 && i !== mainSeat()));
      act.update(dt);
      act.applyRk(b.seats[i].rk);
    }
    // camera easing toward the active side in auto mode is intentionally off - fixed cameras
  }
  for (let i = bounceMarks.length - 1; i >= 0; i--) {
    const m = bounceMarks[i]; m.userData.age += dt;
    const t = m.userData.age / 0.6; m.scale.setScalar(1 + t); m.material.opacity = 0.8 * (1 - t);
    if (t >= 1) { scene.remove(m); bounceMarks.splice(i, 1); }
  }
  updateScenery(performance.now() / 1000, dt);
  updateBooms(dt);
  renderViews(dt);
  renderTilts(latest);
  requestAnimationFrame(frame);
}
frame();

window.__dbg = { sfxBuf, audioCtx: () => actx, actors, camera, scene, setCam: (m) => { camMode = m; }, get latest() { return latest; } };
