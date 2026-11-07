import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import * as SkeletonUtils from 'three/addons/utils/SkeletonUtils.js';
import * as BufferGeometryUtils from 'three/addons/utils/BufferGeometryUtils.js';
import { RoundedBoxGeometry } from 'three/addons/geometries/RoundedBoxGeometry.js';
import { RacketPose, RemoteHeading, mat3ToQuat } from '/racket_pose.js';
import { createMusic } from '/music.js';

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
renderer.toneMapping = THREE.NeutralToneMapping;   // gentle highlight roll-off with the colours kept; the ball and its trail opt out
renderer.toneMappingExposure = 1.0;
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x4aa3f5);
scene.fog = new THREE.Fog(0xd8efff, 400, 3200);
const camera = new THREE.PerspectiveCamera(42, 1, 1, 4000);

// soft daylight: generous sky fill, a warm sun at a mid angle and a faint cool rim so the players still read against the hills
scene.add(new THREE.HemisphereLight(0xe6f5ff, 0x6f9c5c, 1.0));
const sun = new THREE.DirectionalLight(0xfff1d8, 2.3);
sun.position.set(-38, 60, 32);
sun.castShadow = true;
sun.shadow.mapSize.set(2048, 2048);
Object.assign(sun.shadow.camera, { left: -45, right: 45, top: 45, bottom: -45, near: 5, far: 160 });
sun.shadow.bias = -0.0004;
scene.add(sun);
const rimLight = new THREE.DirectionalLight(0xbfe3ff, 0.6);
rimLight.position.set(40, 28, -50); scene.add(rimLight);

// placeholder textures drawn on canvases
function canvasTex(w, h, draw, repeat) {
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  draw(c.getContext('2d'), w, h);
  const t = new THREE.CanvasTexture(c); t.colorSpace = THREE.SRGBColorSpace; t.anisotropy = 8;
  if (repeat) { t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(...repeat); }
  return t;
}
// ---- Frutiger Aero surroundings: rolling green hills, deep blue sky with cumulus, glossy aqua court, bubbles and flying fish ----
// hills: flat around the court, then smooth contoured swells and one big soft hill, like the classic green-hill desktop wallpaper
function hillHeight(x, z) {
  const r = Math.hypot(x, z), f = THREE.MathUtils.smoothstep(r, 150, 460), plain = THREE.MathUtils.smoothstep(r, 880, 1040);   // hills, then the city's plain
  const swell = 0.5 + 0.5 * Math.sin(x * 0.0072 + 0.8) * Math.cos(z * 0.0061 - 0.5);
  const roll = 0.5 + 0.5 * Math.sin(x * 0.0153 - z * 0.0121 + 2.0);
  const big = Math.exp(-((x - 160) ** 2 + (z + 640) ** 2) / (2 * 260 ** 2));
  return FLOOR - 0.3 + (1 - plain) * f * (46 * swell + 15 * roll + 90 * big) + plain * 4;
}
const terrGeo = new THREE.PlaneGeometry(3400, 3400, 220, 220); terrGeo.rotateX(-Math.PI / 2);
{
  const p = terrGeo.attributes.position, col = new Float32Array(p.count * 3), lo = new THREE.Color(0x2c8f34), hi = new THREE.Color(0x9ddc52), c = new THREE.Color();
  for (let i = 0; i < p.count; i++) {
    const x = p.getX(i), z = p.getZ(i), h = hillHeight(x, z);
    p.setY(i, h);
    c.copy(lo).lerp(hi, THREE.MathUtils.clamp((h - FLOOR) / 160 + 0.3 + 0.08 * Math.sin(x * 0.021) * Math.cos(z * 0.017), 0, 1));
    col[i * 3] = c.r; col[i * 3 + 1] = c.g; col[i * 3 + 2] = c.b;
  }
  terrGeo.setAttribute('color', new THREE.BufferAttribute(col, 3)); terrGeo.computeVertexNormals();
}
// mown-lawn look: a fine grass texture tiled every ~11 units, broad light / dark mower stripes and slow patches, all multiplied over the
// height colours. The stripes are anti-aliased and fade out where they would get finer than a pixel, so distant hills don't shimmer.
const grassTex = canvasTex(256, 256, (g, w, h) => {
  g.fillStyle = '#e9f2e2'; g.fillRect(0, 0, w, h);
  for (let i = 0; i < 2600; i++) {
    const x = Math.random() * w, y = Math.random() * h, l = 3 + Math.random() * 7, a = -0.35 + Math.random() * 0.7, c = Math.random();
    g.strokeStyle = c < 0.5 ? `rgba(120,160,95,${0.15 + Math.random() * 0.25})` : c < 0.85 ? `rgba(255,255,240,${0.2 + Math.random() * 0.3})` : `rgba(80,120,60,${0.2 + Math.random() * 0.2})`;
    g.lineWidth = 1 + Math.random(); g.beginPath(); g.moveTo(x, y); g.lineTo(x + Math.sin(a) * l, y - Math.cos(a) * l); g.stroke();   // short blades
  }
}, [300, 300]);
const terrMat = new THREE.MeshLambertMaterial({ vertexColors: true, map: grassTex });
terrMat.onBeforeCompile = (sh) => {
  sh.vertexShader = sh.vertexShader.replace('#include <common>', '#include <common>\nvarying vec3 vWPos;')
    .replace('#include <worldpos_vertex>', '#include <worldpos_vertex>\nvWPos = (modelMatrix * vec4(transformed, 1.0)).xyz;');
  sh.fragmentShader = sh.fragmentShader.replace('#include <common>', '#include <common>\nvarying vec3 vWPos;')
    .replace('#include <color_fragment>', `#include <color_fragment>
vec2 gp = vWPos.xz;
float s = dot(gp, vec2(0.8, 0.6)) / 26.0, fw = fwidth(s), f = fract(s);
float band = smoothstep(0.25 - fw, 0.25 + fw, f) - smoothstep(0.75 - fw, 0.75 + fw, f);                 // 13-unit mower stripes
float stripes = (band * 2.0 - 1.0) * (1.0 - smoothstep(0.12, 0.45, fw));
float patches = sin(gp.x * 0.013 + 2.0 * sin(gp.y * 0.011)) * sin(gp.y * 0.017 + 1.3);
diffuseColor.rgb *= 1.0 + 0.075 * stripes + 0.06 * patches;`);
};
const terrain = new THREE.Mesh(terrGeo, terrMat);
terrain.receiveShadow = true; scene.add(terrain);
// glossy aqua glass court platform with a bright rim
const platTex = canvasTex(512, 512, (g, w, h) => {
  const gr = g.createRadialGradient(w / 2, h * 0.4, 20, w / 2, h / 2, w * 0.7); gr.addColorStop(0, '#d9fbff'); gr.addColorStop(0.5, '#5fd6f0'); gr.addColorStop(1, '#1c9ccf');
  g.fillStyle = gr; g.fillRect(0, 0, w, h);
  g.fillStyle = 'rgba(255,255,255,.18)'; g.beginPath(); g.ellipse(w / 2, h * 0.22, w * 0.42, h * 0.16, 0, 0, Math.PI * 2); g.fill();
});
// The platform is a wave visualiser: soft rings drift outward with the music (bass near the middle, treble toward the rim, the ground
// under the table kept calm, everything calmer during rallies), and perfect hits, smashes and points send water-like ripples across it.
// Both glow a little and tilt the surface normal, so the sky's highlights shimmer with them. Driven from updateFloorViz.
const floorViz = { uTime: { value: 0 }, uLevel: { value: 0 }, uCalm: { value: 1 }, uBands: { value: new Float32Array(8) },
  uRip: { value: Array.from({ length: 8 }, () => new THREE.Vector4(0, 0, -99, 0)) }, uRipCol: { value: Array.from({ length: 8 }, () => new THREE.Color()) } };
const platMat = new THREE.MeshStandardMaterial({ map: platTex, roughness: 0.12, metalness: 0.15, emissive: 0x0a4a66, emissiveIntensity: 0.35 });
platMat.onBeforeCompile = (sh) => {
  Object.assign(sh.uniforms, floorViz);
  sh.vertexShader = sh.vertexShader.replace('#include <common>', '#include <common>\nvarying vec3 vWPos;')
    .replace('#include <worldpos_vertex>', '#include <worldpos_vertex>\nvWPos = (modelMatrix * vec4(transformed, 1.0)).xyz;');
  sh.fragmentShader = sh.fragmentShader.replace('#include <common>', `#include <common>
varying vec3 vWPos;
uniform float uTime, uLevel, uCalm; uniform float uBands[8]; uniform vec4 uRip[8]; uniform vec3 uRipCol[8];
float bandAt(float r) { float x = clamp(r / 78.0 * 7.0, 0.0, 6.999); int i = int(x); return mix(uBands[i], uBands[i + 1], fract(x)); }`)
    .replace('#include <normal_fragment_maps>', `#include <normal_fragment_maps>
vec2 wp = vWPos.xz; float wr = length(wp); vec2 wdir = wr > 0.001 ? wp / wr : vec2(0.0);
float edge = smoothstep(78.0, 70.0, wr), calm = mix(0.25, 1.0, smoothstep(14.0, 32.0, wr)) * uCalm;
float amp = (0.15 + bandAt(wr)) * calm * edge, ph = wr * 0.5 - uTime * (1.1 + 2.2 * uLevel);
vec2 grad = wdir * (0.05 * cos(ph) * amp);
float glow = pow(0.5 + 0.5 * sin(ph), 8.0) * amp * 0.5;
vec3 ripGlow = vec3(0.0);
for (int i = 0; i < 8; i++) {
  vec4 R = uRip[i]; float age = uTime - R.z; if (age < 0.0 || age > 3.2) continue;
  vec2 d2 = wp - R.xy; float d = length(d2), x = d - age * 36.0, env = R.w * exp(-1.4 * age) * edge;
  ripGlow += uRipCol[i] * (exp(-x * x / 10.0) + 0.45 * exp(-(x + 7.0) * (x + 7.0) / 14.0)) * env;   // the crest and a softer one behind it
  grad += (d > 0.001 ? d2 / d : vec2(0.0)) * (-x / 5.0 * exp(-x * x / 10.0)) * env * 0.16;
}
normal = normalize((viewMatrix * vec4(normalize(vec3(-grad.x, 1.0, -grad.y)), 0.0)).xyz);`)
    .replace('#include <emissivemap_fragment>', `#include <emissivemap_fragment>
totalEmissiveRadiance += vec3(0.35, 0.9, 1.0) * glow + ripGlow;`);
};
const plat = new THREE.Mesh(new THREE.CircleGeometry(78, 96), platMat);
plat.rotation.x = -Math.PI / 2; plat.position.y = FLOOR; plat.receiveShadow = true; scene.add(plat);
const rim = new THREE.Mesh(new THREE.RingGeometry(78, 82, 96), new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.9 }));
rim.rotation.x = -Math.PI / 2; rim.position.y = FLOOR + 0.02; scene.add(rim);
// sky dome: deep blue overhead -> bright blue -> pale haze at the horizon
const skyTex = canvasTex(16, 256, (g, w, h) => { const gr = g.createLinearGradient(0, 0, 0, h); gr.addColorStop(0, '#0b56c8'); gr.addColorStop(0.28, '#2a86ee'); gr.addColorStop(0.45, '#7cc4ff'); gr.addColorStop(0.5, '#dcf3ff'); gr.addColorStop(1, '#dcf3ff'); g.fillStyle = gr; g.fillRect(0, 0, w, h); });
const sky = new THREE.Mesh(new THREE.SphereGeometry(1800, 32, 20), new THREE.MeshBasicMaterial({ map: skyTex, side: THREE.BackSide, fog: false, depthWrite: false }));
sky.renderOrder = -10; scene.add(sky);
// ---- glass city on the plain beyond the hills (Frutiger Aero skyline); the towers hop in a wave whenever someone scores -----------
const envScene = new THREE.Scene();
envScene.add(new THREE.Mesh(new THREE.SphereGeometry(10, 32, 16), new THREE.MeshBasicMaterial({ map: skyTex, side: THREE.BackSide })));
{ const g = new THREE.Mesh(new THREE.CircleGeometry(9.9, 32), new THREE.MeshBasicMaterial({ color: 0x6fcf4a })); g.rotation.x = -Math.PI / 2; g.position.y = -1.5; envScene.add(g); }
const skyEnv = new THREE.PMREMGenerator(renderer).fromScene(envScene, 0.02).texture;   // sky and meadow reflections for the glass
const glassTex = canvasTex(64, 64, (g, w, h) => {
  const gr = g.createLinearGradient(0, 0, w * 0.4, h); gr.addColorStop(0, '#f6fcff'); gr.addColorStop(0.5, '#bfe0f4'); gr.addColorStop(1, '#86bce0'); g.fillStyle = gr; g.fillRect(0, 0, w, h);
  g.fillStyle = 'rgba(255,255,255,.9)'; g.fillRect(0, 0, w, 5);                                       // floor slab
  g.fillStyle = 'rgba(255,255,255,.6)'; g.fillRect(0, 0, 3, h); g.fillRect(w / 2 - 1, 5, 2, h - 5);   // mullions
  g.fillStyle = 'rgba(255,255,255,.3)'; g.fillRect(5, 9, w / 2 - 9, 9);                              // a glint on the pane
}, [1, 1]);
const cityMat = new THREE.MeshStandardMaterial({ map: glassTex, envMap: skyEnv, envMapIntensity: 1.15, metalness: 0.45, roughness: 0.14 });
function towerGeo(w, h, d, crown) {         // a box with panes sized in world units (8 x 10 each), plain roofs, and a crown
  const box = (bw, bh, bd, y) => {
    const g = new THREE.BoxGeometry(bw, bh, bd), uv = g.attributes.uv;
    for (let f = 0; f < 6; f++) for (let v = 0; v < 4; v++) {                                     // faces: +x -x +y -y +z -z
      const i = f * 4 + v, roof = f === 2 || f === 3, su = f < 2 ? bd / 8 : bw / 8;
      uv.setXY(i, roof ? 0.02 : uv.getX(i) * su, roof ? 0.98 : uv.getY(i) * bh / 10);
    }
    return g.translate(0, y + bh / 2, 0);
  };
  const parts = [box(w, h, d, 0)];
  if (crown === 1) parts.push(box(w * 0.7, h * 0.12, d * 0.7, h));
  if (crown === 2) parts.push(new THREE.CylinderGeometry(0.6, 1.4, h * 0.22, 8).translate(0, h * 1.11, 0));
  return BufferGeometryUtils.mergeGeometries(parts);
}
const TOWERS = [[30, 150, 30, 1], [42, 230, 36, 0], [24, 300, 24, 2], [56, 110, 44, 1], [36, 190, 30, 0], [20, 340, 20, 2], [48, 160, 48, 1], [28, 250, 34, 0]];
const TINTS = [0xffffff, 0xe8f4ff, 0xd2ebfa, 0xdaf5ee, 0xf3f7fb, 0xc4e2f6];
const cityMeshes = TOWERS.map(([w, h, d, crown]) => { const m = new THREE.InstancedMesh(towerGeo(w, h, d, crown), cityMat, 26); m.count = 0; m.frustumCulled = false; scene.add(m); return m; });
const towers = [], _tq = new THREE.Quaternion(), _tp = new THREE.Vector3(), _ts = new THREE.Vector3(), _tw = new THREE.Matrix4(), _up = new THREE.Vector3(0, 1, 0);
function placeTower(t, lift = 0, sy = 1) {
  _tq.setFromAxisAngle(_up, t.rot); _tp.set(t.x, t.y + lift, t.z); _ts.set(t.s / Math.sqrt(sy), t.s * sy, t.s / Math.sqrt(sy));
  t.m.setMatrixAt(t.i, _tw.compose(_tp, _tq, _ts)); t.m.instanceMatrix.needsUpdate = true;
}
{
  const near = (a, c) => Math.exp(-(Math.atan2(Math.sin(a - c), Math.cos(a - c)) ** 2) / 0.22), col = new THREE.Color();
  for (let tries = 0; tries < 3000 && towers.length < 170; tries++) {
    const a = Math.random() * Math.PI * 2; if (Math.random() > 0.18 + 0.82 * (near(a, -Math.PI / 2) + near(a, Math.PI / 2))) continue;   // downtowns beyond each end
    const r = 1080 + Math.random() * 380, x = Math.cos(a) * r, z = Math.sin(a) * r;
    if (towers.some((t) => Math.hypot(t.x - x, t.z - z) < 52)) continue;
    const m = cityMeshes[(Math.random() * TOWERS.length) | 0]; if (m.count >= 26) continue;
    const t = { m, i: m.count++, x, z, y: hillHeight(x, z) - 3, s: 0.75 + Math.random() * 0.6, rot: Math.random() * Math.PI, hop: null };
    m.setColorAt(t.i, col.set(TINTS[(Math.random() * TINTS.length) | 0])); placeTower(t); towers.push(t);
  }
}
let cityT0 = -1;
function cityCheer(scorer) {                // the wave starts across the city beyond the scorer's opponent and runs round the skyline
  cityT0 = performance.now() / 1000; const a0 = scorer === 0 ? -Math.PI / 2 : Math.PI / 2;
  for (const t of towers) {
    const a = Math.atan2(t.z, t.x), da = Math.abs(Math.atan2(Math.sin(a - a0), Math.cos(a - a0)));
    t.hop = { delay: da * 0.45 + Math.random() * 0.25, amp: (14 + Math.random() * 30) * (Math.random() < 0.25 ? -0.5 : 1), dur: 0.75 + Math.random() * 0.35 };
  }
}
function updateCity() {
  if (cityT0 < 0) return;
  const now = performance.now() / 1000 - cityT0; let busy = false;
  for (const t of towers) {
    const h = t.hop; if (!h) continue;
    const u = (now - h.delay) / h.dur;
    if (u < 0) { busy = true; continue; }
    if (u >= 1.6) { placeTower(t); t.hop = null; continue; }
    busy = true;
    placeTower(t, h.amp * (u < 1 ? Math.sin(Math.PI * u) : 0.35 * Math.sin(Math.PI * (u - 1) / 0.6)), 1 + 0.07 * Math.sin(2 * Math.PI * Math.min(u, 1)));   // a hop, a small hop, squash and stretch
  }
  if (!busy) cityT0 = -1;
}
// cumulus clouds high over the far hills (well clear of the court), and a sun glow
const cloudTex = canvasTex(128, 64, (g, w, h) => {
  for (const [x, y, r] of [[40, 38, 24], [64, 30, 28], [90, 38, 22], [64, 42, 26], [22, 44, 16], [108, 44, 16]]) {
    const gr = g.createRadialGradient(x, y, 2, x, y, r); gr.addColorStop(0, 'rgba(255,255,255,.95)'); gr.addColorStop(1, 'rgba(255,255,255,0)'); g.fillStyle = gr; g.beginPath(); g.arc(x, y, r, 0, Math.PI * 2); g.fill();
  }
});
const clouds = [];
for (let i = 0; i < 18; i++) {
  const c = new THREE.Sprite(new THREE.SpriteMaterial({ map: cloudTex, transparent: true, depthWrite: false, fog: false, opacity: 0.95 }));
  const ang = Math.random() * Math.PI * 2, r = 650 + Math.random() * 650, sc = 300 + Math.random() * 330;
  c.position.set(Math.cos(ang) * r, 180 + Math.random() * 260, Math.sin(ang) * r); c.scale.set(sc, sc * 0.5, 1);
  c.userData = { ang, r, sp: 0.002 + Math.random() * 0.004, op: 0.95, rad: sc * 0.4, vis: 1 };
  scene.add(c); clouds.push(c);
}
const glowTex = canvasTex(128, 128, (g, w, h) => { const gr = g.createRadialGradient(64, 64, 2, 64, 64, 64); gr.addColorStop(0, 'rgba(255,255,230,1)'); gr.addColorStop(0.25, 'rgba(255,245,180,.55)'); gr.addColorStop(1, 'rgba(255,240,160,0)'); g.fillStyle = gr; g.fillRect(0, 0, w, h); });
const sunGlow = new THREE.Sprite(new THREE.SpriteMaterial({ map: glowTex, transparent: true, depthWrite: false, fog: false, blending: THREE.AdditiveBlending }));
sunGlow.position.set(-800, 640, -1000); sunGlow.scale.set(780, 780, 1); scene.add(sunGlow);
const raysTex = canvasTex(256, 256, (g) => {      // a slowly turning sunburst, like the glossy wallpapers
  g.translate(128, 128);
  for (let i = 0; i < 18; i++) {
    g.rotate(Math.PI * 2 / 18); const len = 70 + (i % 3) * 30, gr = g.createLinearGradient(0, 0, len + 30, 0);
    gr.addColorStop(0, 'rgba(255,255,240,.5)'); gr.addColorStop(1, 'rgba(255,255,240,0)'); g.fillStyle = gr;
    g.beginPath(); g.moveTo(0, -3); g.lineTo(len + 30, -1); g.lineTo(len + 30, 1); g.lineTo(0, 3); g.fill();
  }
});
const sunRays = new THREE.Sprite(new THREE.SpriteMaterial({ map: raysTex, transparent: true, depthWrite: false, fog: false, blending: THREE.AdditiveBlending, opacity: 0.65 }));
sunRays.position.copy(sunGlow.position); sunRays.scale.set(1100, 1100, 1); scene.add(sunRays);
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
  b.userData = { base: b.position.clone(), ph: Math.random() * 6.28, sp: 0.15 + Math.random() * 0.35, rise: 1.5 + Math.random() * 3, op: 0.85, rad: sc * 0.5, vis: 1 };
  scene.add(b); bubbles.push(b);
}
// flying fish: glossy schools circling the court through the air (instanced: two draw calls per school)
const fishMat = new THREE.MeshPhysicalMaterial({ vertexColors: true, roughness: 0.3, clearcoat: 1, clearcoatRoughness: 0.08, iridescence: 0.5, iridescenceIOR: 1.35, side: THREE.DoubleSide });
const shapeGeo = (pts) => new THREE.ShapeGeometry(new THREE.Shape(pts.map(([x, y]) => new THREE.Vector2(x, y))));
function paint(g, fn) {
  const p = g.attributes.position, c = new Float32Array(p.count * 3), col = new THREE.Color();
  for (let i = 0; i < p.count; i++) { fn(col, p.getX(i), p.getY(i), p.getZ(i)); c[i * 3] = col.r; c[i * 3 + 1] = col.g; c[i * 3 + 2] = col.b; }
  g.setAttribute('color', new THREE.BufferAttribute(c, 3)); return g;
}
function fishGeos(back, belly, stripe) {     // head toward +x; the tail is a separate piece hinged at x = -1.95
  const B = new THREE.Color(back), W = new THREE.Color(belly), S = new THREE.Color(stripe), K = new THREE.Color(0x101418);
  const body = new THREE.SphereGeometry(1, 22, 14); body.scale(2.1, 0.95, 0.7);
  paint(body, (c, x, y) => { c.copy(W).lerp(B, THREE.MathUtils.smoothstep(y, -0.35, 0.15)); if (Math.abs(x - 0.35) < 0.16 || Math.abs(x + 0.75) < 0.13) c.lerp(S, 0.85); });
  const dorsal = paint(shapeGeo([[0.7, 0.72], [-0.6, 1.65], [-1.25, 0.7]]), (c) => c.copy(B).lerp(S, 0.3));
  const fins = [-1, 1].map((s) => { const g = new THREE.CircleGeometry(0.5, 12); g.scale(1.4, 0.55, 1); g.rotateX(Math.PI / 2 - s * 0.5); g.translate(0.45, -0.38, s * 0.55); return paint(g, (c) => c.copy(B).lerp(W, 0.4)); });
  const eyes = [-1, 1].map((s) => { const g = new THREE.SphereGeometry(0.17, 10, 8); g.translate(1.5, 0.22, s * 0.45); return paint(g, (c) => c.copy(K)); });
  const tail = paint(shapeGeo([[0, 0], [-1.5, 0.95], [-1.05, 0], [-1.5, -0.95]]), (c, x) => c.copy(B).lerp(S, Math.min(1, -x / 1.5)));
  return { body: BufferGeometryUtils.mergeGeometries([body, dorsal, ...fins, ...eyes]), tail };
}
const schools = [
  { back: 0x13b0ea, belly: 0xf2fdff, stripe: 0xffffff, n: 7, r: 96, h: 24, sp: 0.085, size: 1.5 },
  { back: 0xff8a2a, belly: 0xfff5e6, stripe: 0xffffff, n: 6, r: 142, h: 40, sp: -0.065, size: 1.9 },
  { back: 0x5fd23a, belly: 0xf3ffe8, stripe: 0x0e8f9a, n: 5, r: 196, h: 30, sp: 0.05, size: 2.5 },
  { back: 0xff5fa8, belly: 0xfff0f7, stripe: 0xfff27a, n: 6, r: 122, h: 58, sp: -0.095, size: 1.3 },
].map((sc) => {
  const g = fishGeos(sc.back, sc.belly, sc.stripe), body = new THREE.InstancedMesh(g.body, fishMat, sc.n), tail = new THREE.InstancedMesh(g.tail, fishMat, sc.n);
  body.frustumCulled = tail.frustumCulled = false; scene.add(body, tail);
  return { ...sc, body, tail, a: Math.random() * Math.PI * 2, fish: Array.from({ length: sc.n }, () => ({ da: (Math.random() - 0.5) * 0.08, dr: (Math.random() - 0.5) * 9, dy: (Math.random() - 0.5) * 6, ph: Math.random() * 6.28, vis: 1 })) };
});
const _fm = new THREE.Matrix4(), _tm = new THREE.Matrix4(), _hinge = new THREE.Matrix4(), _fq = new THREE.Quaternion(), _fp = new THREE.Vector3(), _fs = new THREE.Vector3(), _fe = new THREE.Euler(0, 0, 0, 'YZX');
function updateFish(t, dt) {
  const k = 1 - Math.exp(-dt * 6);
  for (const sc of schools) {
    sc.a += sc.sp * dt;
    const dir = Math.sign(sc.sp);
    sc.fish.forEach((f, i) => {
      const a = sc.a - dir * i * 0.05 + f.da, r = sc.r + f.dr + Math.sin(t * 0.3 + f.ph) * 5;
      _fp.set(Math.cos(a) * r, FLOOR + sc.h + f.dy + Math.sin(t * 0.8 + f.ph) * 2 + Math.sin(a * 2) * 9, Math.sin(a) * r * 0.82);
      const hx = -Math.sin(a) * dir, hz = Math.cos(a) * 0.82 * dir;                                // direction of travel along the loop
      _fe.set(0, Math.atan2(-hz, hx) + Math.sin(t * 7 + f.ph) * 0.07, Math.atan(18 * Math.cos(2 * a) * dir / r));   // yaw (+ swim wiggle), pitch with the swoops
      _fq.setFromEuler(_fe);
      f.vis += (decorVis(_fp, 3 * sc.size) - f.vis) * k;
      _fm.compose(_fp, _fq, _fs.setScalar(sc.size * Math.max(0.001, f.vis))); sc.body.setMatrixAt(i, _fm);
      _hinge.makeRotationY(Math.sin(t * 9 + f.ph) * 0.55).setPosition(-1.95, 0, 0);
      sc.tail.setMatrixAt(i, _tm.multiplyMatrices(_fm, _hinge));
    });
    sc.body.instanceMatrix.needsUpdate = sc.tail.instanceMatrix.needsUpdate = true;
  }
}
// decor fades out where it would block the action: right at the camera, or on screen in front of the play area
let viewCams = [camera];
const _dv = new THREE.Vector3();
function decorVis(pos, rad) {
  for (const cam of viewCams) {
    const d = cam.position.distanceTo(pos);
    if (d < 20 + rad) return 0;
    _dv.copy(pos).project(cam);
    if (_dv.z < 1 && Math.abs(_dv.x) < 0.9 && _dv.y > -1.2 && _dv.y < 0.6 && d < cam.position.length() + 32 + rad) return 0;
  }
  return 1;
}
function updateScenery(t, dt) {
  const k = 1 - Math.exp(-dt * 6);
  for (const c of clouds) { const u = c.userData; u.ang += u.sp * dt * 0.1; c.position.x = Math.cos(u.ang) * u.r; c.position.z = Math.sin(u.ang) * u.r; u.vis += (decorVis(c.position, u.rad) - u.vis) * k; c.material.opacity = u.op * u.vis; }
  for (const b of bubbles) {
    const u = b.userData; u.base.y += u.rise * dt; if (u.base.y > FLOOR + 75) u.base.y = FLOOR - 2;
    b.position.set(u.base.x + Math.sin(t * u.sp + u.ph) * 2.2, u.base.y, u.base.z + Math.cos(t * u.sp * 0.8 + u.ph) * 2.2);
    u.vis += (decorVis(b.position, u.rad) - u.vis) * k; b.material.opacity = u.op * u.vis;
  }
  updateFish(t, dt);
  updateCity(); sunRays.material.rotation = t * 0.02;
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
const ball = new THREE.Mesh(new THREE.SphereGeometry(R * 1.1, 28, 20), new THREE.MeshToonMaterial({ map: ballTex, gradientMap: toonGrad, toneMapped: false }));
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
const trailMesh = new THREE.Mesh(trailGeo, new THREE.MeshBasicMaterial({ vertexColors: true, transparent: true, depthWrite: false, side: THREE.DoubleSide, toneMapped: false }));
trailMesh.frustumCulled = false; scene.add(trailMesh);
const trailPts = [];   // {p: Vector3, t: seconds}, newest first

// ---- spin you can read: a coloured halo turning round the ball (orange arrows clockwise = topspin, blue anticlockwise = backspin) and a
// wake that drifts up off topspin and down off backspin (the Magnus wake), stronger the heavier the spin ---------------------------
const SPIN_TOP = new THREE.Color(0xff8a2a), SPIN_BACK = new THREE.Color(0x38c8ff), spinCol = new THREE.Color(), _tc = new THREE.Color();
let spinM = 0;
const haloTex = canvasTex(128, 128, (g) => {
  g.translate(64, 64); g.strokeStyle = g.fillStyle = '#fff'; g.lineWidth = 7; g.lineCap = 'round';
  for (let i = 0; i < 4; i++) {
    const a = 1.15, px = 46 * Math.cos(a), py = 46 * Math.sin(a), tx = -Math.sin(a), ty = Math.cos(a), nx = Math.cos(a), ny = Math.sin(a);
    g.beginPath(); g.arc(0, 0, 46, 0.2, a); g.stroke();
    g.beginPath(); g.moveTo(px + tx * 13, py + ty * 13); g.lineTo(px + nx * 8, py + ny * 8); g.lineTo(px - nx * 8, py - ny * 8); g.closePath(); g.fill();
    g.rotate(Math.PI / 2);
  }
});
const halo = new THREE.Sprite(new THREE.SpriteMaterial({ map: haloTex, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending, toneMapped: false, opacity: 0 }));
scene.add(halo);
const dotTex = canvasTex(32, 32, (g) => { const gr = g.createRadialGradient(16, 16, 0, 16, 16, 16); gr.addColorStop(0, 'rgba(255,255,255,1)'); gr.addColorStop(1, 'rgba(255,255,255,0)'); g.fillStyle = gr; g.fillRect(0, 0, 32, 32); });
const WAKE_N = 220, wakeGeo = new THREE.BufferGeometry(), wakePos = new Float32Array(WAKE_N * 3), wakeCol = new Float32Array(WAKE_N * 3), wakeBase = new Float32Array(WAKE_N * 3), wakeVel = new Float32Array(WAKE_N * 3), wakeLife = new Float32Array(WAKE_N);
wakeGeo.setAttribute('position', new THREE.BufferAttribute(wakePos, 3).setUsage(THREE.DynamicDrawUsage));
wakeGeo.setAttribute('color', new THREE.BufferAttribute(wakeCol, 3).setUsage(THREE.DynamicDrawUsage));
const wake = new THREE.Points(wakeGeo, new THREE.PointsMaterial({ size: 0.6, map: dotTex, vertexColors: true, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending, toneMapped: false }));
wake.frustumCulled = false; scene.add(wake);
let wakeNext = 0, wakeAcc = 0;
function updateSpin(dt, bs, live) {
  const w = bs.w || [0, 0, 0], sp = live ? Math.max(-1.5, Math.min(1.5, w[0] * Math.sign(bs.v[2] || 1) / 40)) : 0;   // + topspin, - backspin
  const m = Math.abs(sp) < 0.1 ? 0 : Math.min(1, (Math.abs(sp) - 0.05) / 0.5), up = sp >= 0 ? 1 : -1, hs = R * 1.1 * 4.4;   // typical spin at contact 0.4-0.7
  spinM += (m - spinM) * (1 - Math.exp(-dt * 10)); spinCol.copy(up > 0 ? SPIN_TOP : SPIN_BACK);
  halo.position.copy(ball.position); halo.material.color.copy(spinCol); halo.material.opacity = Math.min(1, 1.3 * spinM);
  halo.scale.set(up * hs, hs, 1); halo.material.rotation -= up * (2.5 + 9 * m) * dt;    // mirrored for backspin so the arrows lead the turn
  wakeAcc += dt * 120 * m;
  for (; wakeAcc >= 1; wakeAcc--) {
    const i = wakeNext++ % WAKE_N, j = i * 3, th = Math.random() * Math.PI * 2, ph = Math.acos(Math.random() * 2 - 1), r = R * 1.15;
    wakePos[j] = ball.position.x + r * Math.sin(ph) * Math.cos(th); wakePos[j + 1] = ball.position.y + r * Math.cos(ph); wakePos[j + 2] = ball.position.z + r * Math.sin(ph) * Math.sin(th);
    wakeVel[j] = -ballVel.x * 0.06 + (Math.random() - 0.5) * 1.2; wakeVel[j + 1] = up * (2.5 + 5 * m) + (Math.random() - 0.5) * 1.2; wakeVel[j + 2] = -ballVel.z * 0.06 + (Math.random() - 0.5) * 1.2;
    wakeBase[j] = spinCol.r; wakeBase[j + 1] = spinCol.g; wakeBase[j + 2] = spinCol.b; wakeLife[i] = 0.5;
  }
  const drag = Math.exp(-2.5 * dt);
  for (let i = 0; i < WAKE_N; i++) {
    const j = i * 3;
    if (wakeLife[i] > 0) { wakeLife[i] -= dt; for (let c = 0; c < 3; c++) { wakePos[j + c] += wakeVel[j + c] * dt; wakeVel[j + c] *= drag; } }
    const f = Math.max(0, wakeLife[i] / 0.5);
    wakeCol[j] = wakeBase[j] * f; wakeCol[j + 1] = wakeBase[j + 1] * f; wakeCol[j + 2] = wakeBase[j + 2] * f;
  }
  wakeGeo.attributes.position.needsUpdate = wakeGeo.attributes.color.needsUpdate = true;
}

// ---- an Aero glint on the ball near the top of its arc: a soft four-point sparkle with a faint aqua ring, plus pale lens-flare ghosts ----
const starTex = canvasTex(128, 128, (g) => {
  g.translate(64, 64);
  const glow = g.createRadialGradient(0, 0, 0, 0, 0, 30); glow.addColorStop(0, 'rgba(255,255,255,.9)'); glow.addColorStop(0.3, 'rgba(225,250,255,.35)'); glow.addColorStop(1, 'rgba(170,235,255,0)');
  g.fillStyle = glow; g.beginPath(); g.arc(0, 0, 30, 0, Math.PI * 2); g.fill();
  for (const [len, wid, rot] of [[60, 3, 0], [60, 3, Math.PI / 2], [30, 1.6, Math.PI / 4], [30, 1.6, -Math.PI / 4]]) {
    g.save(); g.rotate(rot); const gr = g.createLinearGradient(-len, 0, len, 0);
    gr.addColorStop(0, 'rgba(255,255,255,0)'); gr.addColorStop(0.5, 'rgba(255,255,255,.95)'); gr.addColorStop(1, 'rgba(255,255,255,0)');
    g.fillStyle = gr; g.beginPath(); g.ellipse(0, 0, len, wid, 0, 0, Math.PI * 2); g.fill(); g.restore();
  }
  g.strokeStyle = 'rgba(140,235,255,.4)'; g.lineWidth = 2; g.beginPath(); g.arc(0, 0, 21, 0, Math.PI * 2); g.stroke();
});
const glint = new THREE.Sprite(new THREE.SpriteMaterial({ map: starTex, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending, toneMapped: false, opacity: 0 }));
scene.add(glint);
const ghostTex = canvasTex(64, 64, (g) => { const gr = g.createRadialGradient(32, 32, 8, 32, 32, 31); gr.addColorStop(0, 'rgba(255,255,255,.05)'); gr.addColorStop(0.75, 'rgba(255,255,255,.3)'); gr.addColorStop(0.92, 'rgba(255,255,255,.55)'); gr.addColorStop(1, 'rgba(255,255,255,0)'); g.fillStyle = gr; g.fillRect(0, 0, 64, 64); });
const flareGhosts = [[0x8feaff, -0.35, 1.8], [0xb4ff9a, -0.75, 1.1], [0xd2b8ff, -1.15, 2.6]].map(([c, k, s]) => {
  const sp = new THREE.Sprite(new THREE.SpriteMaterial({ map: ghostTex, color: c, transparent: true, depthWrite: false, depthTest: false, blending: THREE.AdditiveBlending, toneMapped: false, opacity: 0 }));
  sp.userData = { k, s }; sp.renderOrder = 10; scene.add(sp); return sp;
});
let glintA = 0;
const _gl = new THREE.Vector3();
function updateGlint(dt, t, live) {
  glintA += ((live ? THREE.MathUtils.smoothstep(ball.position.y, 8, 14) : 0) - glintA) * (1 - Math.exp(-dt * 6));
  const tw = 0.8 + 0.2 * Math.sin(t * 9.3) * Math.sin(t * 5.7);                 // a gentle twinkle
  glint.visible = glintA > 0.01;
  glint.position.copy(ball.position).addScaledVector(_gl.copy(camera.position).sub(ball.position).normalize(), 0.7);
  glint.material.opacity = 0.7 * glintA * tw; glint.material.rotation = t * 0.35; glint.scale.setScalar(3 + 1.4 * glintA);
  _gl.copy(ball.position).project(camera);
  const on = glint.visible && !isSplit() && _gl.z < 1 && Math.abs(_gl.x) < 1 && Math.abs(_gl.y) < 1;
  for (const g of flareGhosts) {                                                // mirrored through the screen centre, 20 units in front of the lens
    g.visible = on; if (!on) continue;
    g.position.set(_gl.x * g.userData.k, _gl.y * g.userData.k, 0.9).unproject(camera); g.scale.setScalar(g.userData.s); g.material.opacity = 0.14 * glintA * tw;
  }
}

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
    // cartoon eye whites (with an ink outline) sit behind the pupils, hidden until someone scores (setEyes)
    const scleraM = new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true }), inkM = new THREE.MeshBasicMaterial({ color: 0x15151c, side: THREE.BackSide, transparent: true });
    this.fade.push([scleraM, 1, 0.2], [inkM, 1, 0.2]);
    this.eyes = []; this.eyeOn = false; this.eyeT = -1;
    for (const z of [-0.8, 0.8]) {
      const e = new THREE.Mesh(new THREE.SphereGeometry(0.2, 8, 6), eyeM); e.position.set(0.4, 1.6, z * 0.9); head.add(e);
      const n = e.position.clone().normalize(), sclera = new THREE.Mesh(new THREE.SphereGeometry(0.58, 18, 14), scleraM);
      sclera.add(new THREE.Mesh(new THREE.SphereGeometry(0.66, 18, 14), inkM));
      sclera.position.copy(e.position).addScaledVector(n, -0.3); sclera.visible = false; head.add(sclera);
      this.eyes.push({ pupil: e, base: e.position.clone(), n, sclera, ph: Math.random() * 6 });
    }
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
    this.rubber = rubber;
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
    this.updateEyes(dt);
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
  // cartoon eye whites pop in (with jittery pupils) when someone scores and shrink away when the next rally starts
  setEyes(on) { if (on !== this.eyeOn) { this.eyeOn = on; this.eyeT = 0; } }
  // phone players: the paddle glows green while the ball comes in if the face already matches its spin (fe = face error, null = no cue)
  setFaceCue(fe) {
    const m = this.rubber, good = fe !== null && fe !== undefined && Math.abs(fe) < 0.3;
    m.emissive.setHex(0x2bff5c); m.emissiveIntensity += ((good ? 0.9 : 0) - m.emissiveIntensity) * 0.35;
  }
  updateEyes(dt) {
    if (this.eyeT < 0) return;
    this.eyeT += dt;
    const u = this.eyeOn ? Math.min(1, this.eyeT / 0.22) : Math.max(0, 1 - this.eyeT / 0.15);
    const s = this.eyeOn ? 1 + 2.70158 * (u - 1) ** 3 + 1.70158 * (u - 1) ** 2 : u;      // ease-out-back pop in, quick shrink out
    for (const e of this.eyes) {
      e.sclera.visible = s > 0.01; e.sclera.scale.setScalar(Math.max(0.001, s));
      e.pupil.position.copy(e.base).addScaledVector(e.n, 0.18 * s);
      if (this.eyeOn) { e.pupil.position.x += Math.sin(this.eyeT * 31 + e.ph) * 0.05 * s; e.pupil.position.z += Math.cos(this.eyeT * 27 + e.ph) * 0.05 * s; }
      e.pupil.scale.setScalar(1 + 0.15 * s);
    }
    if (!this.eyeOn && u <= 0) this.eyeT = -1;
  }
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

// ---- spectators: Mii fans on sideline chairs; each one's hand follows their phone, heads follow the ball, everyone cheers a point --
// The sitting pose is found once, numerically: each thigh and shin turns about whichever of its own axes best points the next joint
// forward (thigh) or down (shin), so the rig's bone axes never need to be known.
const SIT = (() => {
  const m = SkeletonUtils.clone(gltf.scene), b = {}, V = THREE.Vector3, q = [];
  m.traverse((o) => { if (o.isBone) b[o.name] = o; }); m.updateMatrixWorld(true);
  const aim = (bone, child, dir) => {
    const q0 = bone.quaternion.clone(); let best = q0, score = -2;
    for (const ax of [new V(1, 0, 0), new V(0, 1, 0), new V(0, 0, 1)]) for (let a = -Math.PI; a < Math.PI; a += Math.PI / 90) {
      bone.quaternion.copy(q0).multiply(new THREE.Quaternion().setFromAxisAngle(ax, a)); m.updateMatrixWorld(true);
      const s = child.getWorldPosition(new V()).sub(bone.getWorldPosition(new V())).normalize().dot(dir);
      if (s > score) { score = s; best = bone.quaternion.clone(); }
    }
    bone.quaternion.copy(best); m.updateMatrixWorld(true); q.push([bone.name, best]);
  };
  for (const s of ['l', 'r']) { aim(b['leg_' + s + '1'], b['leg_' + s + '2'], new V(0, 0, 1)); aim(b['leg_' + s + '2'], b['ankle_' + s], new V(0, -1, 0)); }
  const at = (bn, x = 0) => { const o = new THREE.Object3D(); o.position.x = x; b[bn].add(o); m.updateMatrixWorld(true); const p = o.getWorldPosition(new V()); b[bn].remove(o); return p; };
  return { q, hip: at('hip'), ankle: at('ankle_l'), knee: at('leg_l2'), head: at('head', 2.3), chest: at('chest') };
})();
const FAN_Y = FLOOR + 0.45 - SIT.ankle.y, SEAT_TOP = FAN_Y + SIT.hip.y - 0.55 - FLOOR;   // feet on the floor, hips on the seat
const ROW = 6, PITCH = 5.2;                   // chairs per row on each sideline, and their spacing
// frog chairs: a glossy green octagonal seat with a lime cushion, chunky splayed legs, a big rounded backrest with domed eyes on top and
// a wide smile (front and back, so the frog still shows behind a fan). Built once, merged per colour, drawn as one instance per spectator.
const FROG_MATS = {
  green: new THREE.MeshStandardMaterial({ color: 0x2fb84b, roughness: 0.26, envMap: skyEnv, envMapIntensity: 0.6 }),
  lime: new THREE.MeshStandardMaterial({ color: 0xd8f07c, roughness: 0.45 }),
  blue: new THREE.MeshStandardMaterial({ color: 0x3f7fe6, roughness: 0.22 }),
  navy: new THREE.MeshStandardMaterial({ color: 0x1d2f78, roughness: 0.3 }),
  red: new THREE.MeshStandardMaterial({ color: 0xe5332b, roughness: 0.4, side: THREE.DoubleSide }),
  dark: new THREE.MeshBasicMaterial({ color: 0x1c4f24, side: THREE.DoubleSide }),
  riser: new THREE.MeshStandardMaterial({ color: 0xf6fbff, roughness: 0.16, envMap: skyEnv, envMapIntensity: 0.7 }),
};
const frogGeo = (() => {
  const top = SEAT_TOP, zc = (SIT.hip.z - 1.1 + SIT.knee.z + 0.2) / 2, zb = SIT.hip.z - 1.35, by = top + 2.3, parts = {};
  const add = (k, geo, x, y, z, rx = 0, ry = 0, rz = 0, sx = 1, sy = 1, sz = 1) => {   // RoundedBoxGeometry is non-indexed, so every part is merged that way
    const g = geo.index ? geo.toNonIndexed() : geo;
    (parts[k] ||= []).push(g.applyMatrix4(new THREE.Matrix4().compose(new THREE.Vector3(x, y, z), new THREE.Quaternion().setFromEuler(new THREE.Euler(rx, ry, rz)), new THREE.Vector3(sx, sy, sz))));
  };
  const smile = new THREE.Shape(); smile.moveTo(-1.5, 0); smile.lineTo(1.5, 0); smile.absarc(0, 0, 1.5, 0, Math.PI, true);
  add('green', new THREE.CylinderGeometry(2.6, 2.45, 0.75, 8), 0, top - 0.38, zc, 0, Math.PI / 8);                     // octagonal seat
  add('lime', new THREE.CylinderGeometry(2.05, 2.05, 0.14, 28), 0, top + 0.02, zc);                                     // cushion
  add('green', new RoundedBoxGeometry(4.9, 4.6, 0.72, 4, 0.34), 0, by, zb);                                             // backrest
  for (const sx of [-1, 1]) {
    add('green', new THREE.SphereGeometry(1.05, 20, 14), sx * 1.5, by + 2.25, zb);                                       // eye bumps on top
    for (const f of [1, -1]) {
      add('blue', new THREE.SphereGeometry(0.62, 16, 12), sx * 1.5, by + 2.3, zb + f * 0.52);                             // domed blue eyes, both faces
      add('navy', new THREE.SphereGeometry(0.3, 12, 8), sx * 1.5, by + 2.32, zb + f * 0.92);
      add('dark', new THREE.CircleGeometry(0.11, 10), sx * 0.3, by + 0.75, zb + f * 0.37, 0, f > 0 ? 0 : Math.PI);        // nostrils
    }
    for (const sz of [-1, 1]) {                                                                                        // chunky legs splayed out, little feet
      const lx = sx * 1.75, lz = zc + sz * 1.75, len = top - 1.1;
      add('green', new THREE.CapsuleGeometry(0.42, len, 4, 10), lx + sx * 0.25, len / 2 + 0.25, lz + sz * 0.25, -sz * 0.2, 0, sx * 0.2);   // tops lean in, feet out
      add('green', new THREE.SphereGeometry(0.55, 14, 10), lx + sx * 0.5, 0.22, lz + sz * 0.5, 0, 0, 0, 1.2, 0.5, 1.2);
    }
  }
  for (const f of [1, -1]) add('red', new THREE.ShapeGeometry(smile, 16), 0, by + 0.35, zb + f * 0.37, 0, f > 0 ? 0 : Math.PI, 0, 1, 0.72, 1);   // the smile
  add('riser', new THREE.BoxGeometry(5.6, 1.6, 7.4), 0, -0.8, zc - 0.4);                                                // second-row step (drawn 1.6 down from the chair)
  return Object.fromEntries(Object.entries(parts).map(([k, list]) => [k, BufferGeometryUtils.mergeGeometries(list)]));
})();
const frogMeshes = Object.entries(frogGeo).map(([k, geo]) => { const m = new THREE.InstancedMesh(geo, FROG_MATS[k], 24); m.count = 0; m.castShadow = k === 'green' || k === 'riser'; m.receiveShadow = true; m.frustumCulled = false; m.userData.riser = k === 'riser'; scene.add(m); return m; });
const _cm = new THREE.Matrix4(), _cq = new THREE.Quaternion(), _cs = new THREE.Vector3(), _c0 = new THREE.Matrix4().makeScale(0, 0, 0);
const FAN_SKIN = new THREE.MeshStandardMaterial({ color: 0xf2c9a0, roughness: 0.6 }), FAN_EYE = new THREE.MeshBasicMaterial({ color: 0x1a1a1a }), FAN_HAND = new THREE.MeshStandardMaterial({ color: 0xffffff, roughness: 0.5 });
const FAN_HEAD = new THREE.SphereGeometry(1.8, 20, 16), FAN_EYE_G = new THREE.SphereGeometry(0.2, 8, 6), FAN_HAND_G = new THREE.SphereGeometry(0.95, 16, 12);
const fans = new Map();                      // sid -> Fan
let fanCheer = 0;                            // until when everyone cheers (a point was scored)
class Fan {
  constructor(sp) {
    this.sid = sp.sid; this.chair = sp.chair; this.hand = sp.hand; this.arm = null; this.wave = 0; this.armT = -1e9; this.ph = Math.random() * 6; this.look = 0;
    this.pos = new THREE.Vector3(); this.to = new THREE.Vector3(); this.face = 0; this.row = 0; this.placed = false; this.born = performance.now(); this.leftAt = 0; this.s = 0;   // chair spot, pop-in
    this.root = new THREE.Group(); this.mat = new THREE.MeshStandardMaterial({ color: sp.color, roughness: 0.7, side: THREE.DoubleSide });
    this.model = SkeletonUtils.clone(gltf.scene);
    const bones = {}; this.model.traverse((o) => { if (o.isBone) bones[o.name] = o; if (o.isMesh) { o.material = this.mat; o.castShadow = true; o.frustumCulled = false; if (o.isSkinnedMesh) stripArms(o); } });
    for (const [n, q] of SIT.q) bones[n].quaternion.copy(q);
    this.root.add(this.model);
    // head on the body (so it can turn to follow the ball) and floating hands, like the players'
    this.head = new THREE.Group(); this.head.position.copy(SIT.head); this.root.add(this.head);
    const skin = new THREE.Mesh(FAN_HEAD, FAN_SKIN); skin.scale.setScalar(1.5); skin.castShadow = true; this.head.add(skin);
    for (const x of [-0.72, 0.72]) { const e = new THREE.Mesh(FAN_EYE_G, FAN_EYE); e.position.set(x, 0.4, 1.6); skin.add(e); }
    this.hands = [-1, 1].map((sx) => { const m = new THREE.Mesh(FAN_HAND_G, FAN_HAND); m.castShadow = true; this.root.add(m); return { m, sx, to: new THREE.Vector3() }; });
    this.update(1, 0, ball.position);
  }
  update(dt, t, target) {
    const phone = performance.now() - this.armT < 700, cheer = performance.now() < fanCheer && !phone;
    for (const h of this.hands) {
      const main = h.sx === (this.hand === -1 ? 1 : -1);   // facing +z, the right hand is on the -x side
      if (phone && main) {                   // the phone's top edge (right, toward the screen, up) -> the arm from the shoulder; shaking waves it
        const [px, py, pz] = this.arm;
        h.to.set(h.sx * 1.9 - px * 4.3 + Math.sin(t * 15 + this.ph) * 1.1 * this.wave, SIT.chest.y + 1.2 + pz * 4.3, SIT.chest.z + py * 4.3);
      } else if (cheer) h.to.set(h.sx * 2.4, SIT.chest.y + 4.8 + Math.abs(Math.sin(t * 9 + this.ph + h.sx)) * 0.9, SIT.chest.z + 0.4);
      else h.to.set(h.sx * 1.5, SIT.hip.y + 1.1 + Math.sin(t * 1.7 + this.ph + h.sx) * 0.05, (SIT.hip.z + SIT.knee.z) / 2 + 0.6);   // resting on the lap
      h.m.position.lerp(h.to, 1 - Math.exp(-dt * 14));
    }
    const lp = this.root.worldToLocal(target.clone()), want = Math.max(-1.1, Math.min(1.1, Math.atan2(lp.x, lp.z)));
    this.look += (want - this.look) * (1 - Math.exp(-dt * 6)); this.head.rotation.y = this.look;
    this.model.position.y = Math.sin(t * 1.3 + this.ph) * 0.04;
  }
  dispose() { scene.remove(this.root); this.model.traverse((o) => { if (o.isSkinnedMesh) o.geometry.dispose(); }); this.mat.dispose(); }
}
// No empty chairs: each spectator brings their own, which pops in with them and shrinks away when they leave. Each sideline's row stays
// centred on the table (6 a row, then a second row on a riser behind) and everyone slides over to make room or close a gap. Side and
// order come from the server's chair numbers, so nobody swaps sides when someone else comes or goes.
function syncFans(specs) {
  const live = new Set();
  for (const sp of specs) {
    if (sp.chair < 0) continue;
    live.add(sp.sid);
    let f = fans.get(sp.sid);
    if (!f || f.leftAt) { if (f) f.dispose(); f = new Fan(sp); fans.set(sp.sid, f); scene.add(f.root); }
    f.hand = sp.hand; f.chair = sp.chair; f.mat.color.setHex(sp.color);
  }
  for (const [sid, f] of fans) if (!live.has(sid) && !f.leftAt) { f.leftAt = performance.now(); const b = speech.get('s' + sid); if (b) { b.el.remove(); speech.delete('s' + sid); } }
  for (const side of [-1, 1]) {
    const list = [...fans.values()].filter((f) => !f.leftAt && (f.chair % 2 ? 1 : -1) === side).sort((a, b) => a.chair - b.chair);
    list.forEach((f, j) => {
      const row = Math.floor(j / ROW), inRow = Math.min(ROW, list.length - row * ROW);
      f.to.set(side * (30 + row * 7), FLOOR + row * 1.6, (j - row * ROW - (inRow - 1) / 2) * PITCH);
      f.row = row; f.face = side > 0 ? -Math.PI / 2 : Math.PI / 2;
      if (!f.placed) { f.pos.copy(f.to); f.placed = true; }   // a newcomer appears in place; the rest slide over
    });
  }
}
const backOut = (u) => 1 + 2.70158 * (u - 1) ** 3 + 1.70158 * (u - 1) ** 2;
function updateFans(dt) {
  const now = performance.now(), t = now / 1000, k = 1 - Math.exp(-dt * 5);
  let i = 0;
  for (const [sid, f] of fans) {
    f.s = f.leftAt ? Math.max(0, 1 - (now - f.leftAt) / 260) ** 2 : backOut(Math.min(1, (now - f.born) / 450));   // pop in with a bounce, shrink away
    if (f.leftAt && f.s <= 0) { f.dispose(); fans.delete(sid); continue; }
    f.pos.lerp(f.to, k);
    _cm.compose(f.pos, _cq.setFromAxisAngle(_up, f.face), _cs.setScalar(Math.max(f.s, 1e-4)));
    for (const m of frogMeshes) m.setMatrixAt(i, m.userData.riser && !f.row ? _c0 : _cm);
    f.root.position.set(f.pos.x, f.pos.y + (FAN_Y - FLOOR) * f.s, f.pos.z); f.root.rotation.y = f.face; f.root.scale.setScalar(Math.max(f.s, 1e-4));
    f.update(dt, t, ball.position);
    i++;
  }
  for (const m of frogMeshes) { m.count = i; m.instanceMatrix.needsUpdate = true; }
}

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
function mainSeat() {                       // a screen with one linked player follows that player's end of the table
  const mine = paired.filter((p) => p.seat >= 0); if (mine.length === 1) return mine[0].seat;
  const s = latest; if (!s) return 0; return s.seats[0].kind === 'human' ? 0 : s.seats[1].kind === 'human' ? 1 : 0;
}

// ---- freecam for spectators: F (or C) to enter; drag to look, WASD / arrows to fly, Q / E down / up, Shift faster, wheel = speed ----
const FREE = 5, free = { pos: new THREE.Vector3(), yaw: 0, pitch: 0, keys: new Set(), speed: 40, drag: null };
addEventListener('keydown', (e) => { if (!e.repeat && !typing(e)) free.keys.add(e.code); });
addEventListener('keyup', (e) => free.keys.delete(e.code));
addEventListener('blur', () => free.keys.clear());
canvas.addEventListener('pointerdown', (e) => { if (camMode === FREE) free.drag = { x: e.clientX, y: e.clientY }; });
addEventListener('pointermove', (e) => { if (!free.drag) return; free.yaw -= (e.clientX - free.drag.x) * 0.004; free.pitch = Math.max(-1.5, Math.min(1.5, free.pitch - (e.clientY - free.drag.y) * 0.004)); free.drag = { x: e.clientX, y: e.clientY }; });
addEventListener('pointerup', () => { free.drag = null; });
canvas.addEventListener('wheel', (e) => { if (camMode === FREE) free.speed = Math.max(5, Math.min(300, free.speed * (e.deltaY > 0 ? 0.85 : 1.18))); }, { passive: true });
function enterFree() { const d = camera.getWorldDirection(new THREE.Vector3()); free.pos.copy(camera.position); free.pitch = Math.asin(d.y); free.yaw = Math.atan2(-d.x, -d.z); }
function freeCam(dt) {
  const k = free.keys, cp = Math.cos(free.pitch), f = new THREE.Vector3(-Math.sin(free.yaw) * cp, Math.sin(free.pitch), -Math.cos(free.yaw) * cp);
  const r = new THREE.Vector3(Math.cos(free.yaw), 0, -Math.sin(free.yaw)), v = new THREE.Vector3();
  if (k.has('KeyW') || k.has('ArrowUp')) v.add(f); if (k.has('KeyS') || k.has('ArrowDown')) v.sub(f);
  if (k.has('KeyD') || k.has('ArrowRight')) v.add(r); if (k.has('KeyA') || k.has('ArrowLeft')) v.sub(r);
  if (k.has('KeyE')) v.y += 1; if (k.has('KeyQ')) v.y -= 1;
  if (v.lengthSq()) free.pos.addScaledVector(v.normalize(), free.speed * (k.has('ShiftLeft') || k.has('ShiftRight') ? 3 : 1) * dt);
  camera.position.copy(free.pos); camera.lookAt(free.pos.clone().add(f));
  camera.aspect = innerWidth / innerHeight; camera.fov = 55; camera.near = 1; camera.far = 4000; camera.updateProjectionMatrix();
}

// Practical play camera: high behind the seat's end so the whole table, both players and lobs stay in frame. It drifts gently with the
// player and toward the ball's side of the table (critically damped: no swinging, orbiting or jitter) and pushes in a little after a point.
class PlayCam {
  constructor(seat) { this.seat = seat; this.x = 0; this.lx = 0; this.push = 0; this.ready = false; }
  update(dt, s) {
    const me = s && s.seats[this.seat], live = !!s && (s.phase === 'rally' || (s.phase === 'serve' && s.serveStage === 'toss'));
    const tx = me ? THREE.MathUtils.clamp(me.x, -18, 18) * 0.35 : 0, tl = (live ? THREE.MathUtils.clamp(ballV.x, -16, 16) * 0.3 : 0) + tx * 0.4;
    const tp = s && (s.phase === 'point' || s.phase === 'over') ? 1 : 0, k = (tau) => 1 - Math.exp(-dt / tau);
    if (!this.ready) { this.x = tx; this.lx = tl; this.ready = true; }
    this.x += (tx - this.x) * k(0.7); this.lx += (tl - this.lx) * k(0.9); this.push += (tp - this.push) * k(1.2);
  }
  apply(cam, aspect) {
    const sg = this.seat === 0 ? 1 : -1, d = 1 - 0.12 * this.push;
    // looks past the far end so a band of sky and hills stays above the action: table and both players span ~12-40 deg below the horizon
    cam.position.set(this.x, FLOOR + 28 * d, sg * (28 + 27 * d)); cam.up.set(0, 1, 0); cam.lookAt(this.lx, 1, -sg * 20);
    cam.aspect = aspect; cam.fov = 48 * (aspect < 1.25 ? Math.sqrt(1.25 / aspect) : 1); cam.near = 1; cam.far = 4000; cam.updateProjectionMatrix();
  }
}
const playCams = [new PlayCam(0), new PlayCam(1)], splitCams = [new THREE.PerspectiveCamera(), new THREE.PerspectiveCamera()];
const CAM_NAMES = ['play', 'side', 'other end', 'overhead', 'classic', 'free (drag to look, WASD fly, Q/E down/up, Shift fast)'];
const camTargets = [
  null,                                      // 0: play camera behind the human player
  () => [[-44, 15, 2], [0, 1, 0]],          // 1: side
  null,                                      // 2: play camera for the other seat
  () => [[0, 56, 16], [0, 0, -2]],          // 3: overhead
  null,                                      // 4: classic: the original game camera (recovered framing solver)
  null,                                      // 5: freecam
];
function applyCam(dt) {
  const w = innerWidth, h = innerHeight;
  if (camMode === FREE) { freeCam(dt); return; }
  if (camMode === 0 || camMode === 2) {
    const pc = playCams[camMode === 0 ? mainSeat() : 1 - mainSeat()];
    pc.update(dt, latest); pc.apply(camera, w / h);
    return;
  }
  if (camMode === 4) {
    const seat = mainSeat(), fov = gameFov(w, h), gc = gameCams[seat];
    gc.update(dt, !!latest && latest.phase === 'serve' && latest.server === seat, w / h, fov);
    gc.apply(camera);
    camera.aspect = w / h; camera.fov = fov; camera.near = CAM.NEAR; camera.far = CAM.FAR; camera.updateProjectionMatrix();
    return;
  }
  const [p, l] = camTargets[camMode]();
  const k = 1 - Math.exp(-dt * 4.5);
  camPos.lerp(new THREE.Vector3(...p), k); camLook.lerp(new THREE.Vector3(...l), k);
  camera.aspect = w / h; camera.fov = w / h < 1.4 ? 42 * (1.4 / (w / h)) ** 0.6 : 42; camera.near = 1; camera.far = 4000; camera.updateProjectionMatrix();
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
let actx = null, muted = false, sfxBus = null, music = null, musicOn = true;
// browsers keep audio suspended until the page gets a click or key press: unlock on the first one, and show a hint until then
for (const ev of ['pointerdown', 'keydown']) addEventListener(ev, () => { audio(); if (actx && actx.state !== 'running') actx.resume(); }, { capture: true });
function audio() {
  if (!actx) {
    try {
      actx = new (window.AudioContext || window.webkitAudioContext)(); loadSfx();
      // softer effects: everything goes through a gentle low-pass and light compression, so hits and bounces stop clicking sharply
      const lp = actx.createBiquadFilter(), comp = actx.createDynamicsCompressor(), g = actx.createGain();
      lp.type = 'lowpass'; lp.frequency.value = 3800; lp.Q.value = 0.5; comp.threshold.value = -20; comp.ratio.value = 3; comp.attack.value = 0.004; g.gain.value = 0.85;
      lp.connect(comp).connect(g).connect(actx.destination); sfxBus = lp;
      music = createMusic(actx); music.setOn(musicOn && !muted);
    } catch (e) { console.warn('audio init failed', e); }
  }
  return actx;
}
// ---- floor visualiser driver: eight log-spaced music bands from the analyser (fast attack, slow release), calmer during rallies,
// ripples from events. ponytail: 8 ripple slots, the oldest is reused; more would only matter for a flurry of events.
const vizBins = new Uint8Array(512), vizAvg = new Float32Array(8); let ripNext = 0;
function ripple(x, z, strength, color, delay = 0) {
  const i = ripNext++ % 8; floorViz.uRip.value[i].set(x, z, floorViz.uTime.value + delay, strength); floorViz.uRipCol.value[i].set(color);
}
function updateFloorViz(dt, t, rally) {
  floorViz.uTime.value = t;
  const B = floorViz.uBands.value, an = music && music.analyser;
  if (an && actx.state === 'running' && musicOn && !muted) {
    an.getByteFrequencyData(vizBins);
    const binHz = actx.sampleRate / an.fftSize, slow = 1 - Math.exp(-dt / 1.0);
    let lv = 0;
    for (let b = 0; b < 8; b++) {
      const lo = 45 * 2 ** (b * 0.95), hi = lo * 1.93;                                       // ~45 Hz .. ~8.5 kHz
      let s = 0, n = 0; for (let i = Math.max(1, Math.floor(lo / binHz)); i <= Math.min(511, Math.ceil(hi / binHz)); i++, n++) s += vizBins[i];
      const raw = s / Math.max(1, n) / 255; lv += raw / 8;
      // each band against its own last second: it lights up when that band rises (drum hits, plucks, chord changes, licks) and
      // settles on held sounds, instead of showing the bass as always louder than the treble
      vizAvg[b] = vizAvg[b] ? vizAvg[b] + (raw - vizAvg[b]) * slow : raw;
      const v = Math.min(1, Math.max(0, (raw - vizAvg[b]) / (0.3 * vizAvg[b] + 0.025)));
      B[b] += (v - B[b]) * (v > B[b] ? 0.6 : 0.1);
    }
    floorViz.uLevel.value += (lv - floorViz.uLevel.value) * 0.1;
  } else { for (let b = 0; b < 8; b++) B[b] *= 0.95; floorViz.uLevel.value *= 0.97; }
  floorViz.uCalm.value += ((rally ? 0.55 : 1) - floorViz.uCalm.value) * (1 - Math.exp(-dt * 2));
  rim.material.opacity = 0.65 + 0.35 * Math.min(1, B[0] * 1.2);                               // the rim pulses with the bass
}
function setMusic(on) { musicOn = on; if (music) music.setOn(musicOn && !muted); const b = document.getElementById('musicbtn'); if (b) b.textContent = '♪ Music: ' + (on ? 'on' : 'off'); }
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
  src.buffer = buf; src.playbackRate.value = rate * Math.pow(2, (Math.random() * 2 - 0.5) / 12);
  g.gain.setValueAtTime(0, c.currentTime); g.gain.linearRampToValueAtTime(vol * (0.75 + Math.random() * 0.15), c.currentTime + 0.006);   // 6 ms fade-in takes the click off
  src.connect(g).connect(sfxBus); src.start();
  return true;
}
function blip(freq, dur, type = 'sine', vol = 0.2, slide = 0) {
  const c = audio(); if (!c || muted) return;
  const o = c.createOscillator(), g = c.createGain();
  o.type = type === 'square' || type === 'sawtooth' ? 'triangle' : type; o.frequency.value = freq; if (slide) o.frequency.exponentialRampToValueAtTime(Math.max(freq + slide, 30), c.currentTime + dur);
  g.gain.setValueAtTime(0.0001, c.currentTime); g.gain.exponentialRampToValueAtTime(vol, c.currentTime + 0.006); g.gain.exponentialRampToValueAtTime(0.0001, c.currentTime + dur);
  o.connect(g).connect(sfxBus); o.start(); o.stop(c.currentTime + dur);
}
// score explosion: a sub boom sweeping down, a noise blast through a closing low-pass, then a scatter of crackles
let noiseBuf = null;
function boom(vol = 1) {
  const c = audio(); if (!c || muted) return;
  const t = c.currentTime, out = c.createGain(), shape = c.createWaveShaper();
  if (!noiseBuf) { noiseBuf = c.createBuffer(1, c.sampleRate * 2, c.sampleRate); const d = noiseBuf.getChannelData(0); for (let i = 0; i < d.length; i++) d[i] = Math.random() * 2 - 1; }
  shape.curve = Float32Array.from({ length: 512 }, (_, i) => Math.tanh(1.8 * (i / 255.5 - 1))); out.gain.value = 0.9 * vol;
  shape.connect(out).connect(c.destination);
  const o = c.createOscillator(), og = c.createGain();
  o.frequency.setValueAtTime(115, t); o.frequency.exponentialRampToValueAtTime(36, t + 0.9);
  og.gain.setValueAtTime(0.0001, t); og.gain.exponentialRampToValueAtTime(0.85, t + 0.012); og.gain.exponentialRampToValueAtTime(0.0001, t + 1.4);
  o.connect(og).connect(shape); o.start(t); o.stop(t + 1.5);
  const n = c.createBufferSource(), f = c.createBiquadFilter(), ng = c.createGain();
  n.buffer = noiseBuf; f.type = 'lowpass'; f.frequency.setValueAtTime(5200, t); f.frequency.exponentialRampToValueAtTime(140, t + 1.6);
  ng.gain.setValueAtTime(0.0001, t); ng.gain.exponentialRampToValueAtTime(0.7, t + 0.008); ng.gain.exponentialRampToValueAtTime(0.0001, t + 1.9);
  n.connect(f).connect(ng).connect(shape); n.start(t); n.stop(t + 2);
  for (let i = 0; i < 9; i++) {
    const tt = t + 0.08 + Math.random() * 0.6, s = c.createBufferSource(), bp = c.createBiquadFilter(), sg = c.createGain();
    s.buffer = noiseBuf; bp.type = 'bandpass'; bp.frequency.value = 900 + Math.random() * 2600; bp.Q.value = 1.5;
    sg.gain.setValueAtTime(0.25 * Math.random() + 0.08, tt); sg.gain.exponentialRampToValueAtTime(0.0001, tt + 0.03 + Math.random() * 0.05);
    s.connect(bp).connect(sg).connect(shape); s.start(tt, Math.random(), 0.1);
  }
}
const sfx = {
  hit: (speed, tw = 0) => { if (!play(tw >= 0.4 ? 'drive' : tw <= -0.4 ? 'cut' : 'hit', 0.9)) { blip(1500 + Math.min(speed, 200) * 4, 0.07, 'square', 0.12, -900); blip(260, 0.09, 'triangle', 0.15); } },
  smash: () => { if (!play('smashhit', 1)) blip(200, 0.2, 'sawtooth', 0.2, -100); play('smashshot', 0.7); },
  bounce: (speed) => { if (!play('bounce', Math.min(1, Math.max(0.4, (speed / 240 - 0.01) * 6)))) blip(700 + Math.min(speed, 60) * 6, 0.05, 'triangle', Math.min(0.18, 0.04 + speed / 300)); },
  net: () => { if (!play('net', 0.9)) blip(180, 0.12, 'sawtooth', 0.12, -60); },
  swing: (power) => play(power > 0.6 ? 'swing_l' : 'swing_s', 0.5),
  point: () => { if (!play('whistle_miss', 0.08)) { blip(660, 0.14, 'sine', 0.04); setTimeout(() => blip(880, 0.2, 'sine', 0.04), 120); } },        // whistles kept well under the music
  over: () => { if (!play('whistle_end', 0.12)) [523, 659, 784, 1046].forEach((f, i) => setTimeout(() => blip(f, 0.3, 'sine', 0.05), i * 140)); },
  toss: () => { if (!play('toss', 0.8)) blip(500, 0.12, 'sine', 0.1, 400); },
};

// ---- network ---------------------------------------------------------------------------------
const buf = [];      // recent snapshots
let latest = null;
// Snapshots leave the server on a coarse timer (Windows wakes Node every ~15.6 ms for a 60 Hz sim), so they arrive 0-16 ms late and
// sometimes in pairs. Place them on the server's own clock instead of their arrival time: clockOff = smallest (arrival - sim time)
// seen, creeping up 0.6 ms/s to follow drift. On recorded snapshots this cut the render delay from ~30 to ~17 ms and speed jitter ~5x.
let clockOff = null;
const RENDER_DELAY = 0.017;   // one sim step behind the freshest possible state; less extrapolates more (visible pops at hits)
// this screen's code (kept for the tab's life): its QR carries it, so phones that scan it link here: one name for screen and phone,
// and the view follows the linked player's end of the table
const SCREEN = (() => {
  const A = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789', make = () => Array.from({ length: 4 }, () => A[(Math.random() * A.length) | 0]).join('');
  try { let s = sessionStorage.getItem('screen'); if (!s) sessionStorage.setItem('screen', (s = make())); return s; } catch { return make(); }
})();
let paired = [];                             // phones linked to this screen: [{sid, name, seat, color}]
let ws;
function connect() {
  ws = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws');
  ws.onopen = () => { clockOff = null; buf.length = 0; ws.send(JSON.stringify({ t: 'hello', role: 'host', screen: SCREEN })); };
  ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.t === 's') onSnap(m); else onRoom(m); };
  ws.onclose = () => setTimeout(connect, 1000);
}
connect();
const send = (o) => ws && ws.readyState === 1 && ws.send(JSON.stringify(o));

let lastPhase = null;
function onSnap(s) {
  if (s.phase !== lastPhase) { if (s.phase === 'serve' || s.phase === 'lobby') for (const a of actors) a.setEyes(false); lastPhase = s.phase; }   // eye whites go at the next rally
  if (music && s.phase === 'rally') music.setTension(Math.min(1, s.rally / 12));   // long rallies lift the music's energy
  const o = performance.now() / 1000 - s.time;
  clockOff = clockOff === null ? o : Math.min(o, clockOff + 1e-5);
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
      if (!e.fault && Math.abs(e.timing ?? 1) < 0.25) ripple(ball.position.x, ball.position.z, e.speed >= 54 ? 0.8 : 0.45, e.speed >= 54 ? 0xcff8ff : 0x7fe9ff);   // perfect (and hard)
      if (e.fault) flashMsg(e.fault === 'net' ? 'INTO THE NET!' : 'LONG!'); else if (e.pop) flashMsg('POPPED UP!');   // misread spin
      if (!e.serve && e.reachX !== undefined) {
        // clip variant from the reach at contact (recovered thresholds): lateral >=13 SP3, >=9 SP2, >=6 SP; forward >=8 front
        const f1 = e.reachX, f2 = e.reachF, suf = f1 >= 13 ? '_SP3' : f1 >= 9 ? '_SP2' : f1 >= 6 ? '_SP' : '';
        if (suf) actors[e.seat].once((e.side === 1 ? 'fore' : 'back') + suf);
        else if (f2 >= 8) actors[e.seat].once('front');
      }
      break;
    }
    case 'smash': {
      sfx.smash(); flashMsg('SMASH!'); ripple(ball.position.x, ball.position.z, 1.0, 0xffc04d); break;
    }
    case 'bounce': sfx.bounce(e.speed); addBounceMark(e.x, e.z); break;
    case 'bounce2': sfx.bounce(e.speed); break;
    case 'netTouch': sfx.net(); break;
    case 'point': boom(); setTimeout(sfx.point, 280); actors[1 - e.winner].once('waitLose'); for (const a of actors) a.setEyes(true); cityCheer(e.winner); fanCheer = performance.now() + 1500;
      ripple(ball.position.x, ball.position.z, 1.0, COLORS[e.winner]); ripple(0, 0, 0.5, 0xffffff, 0.25);   // scorer-coloured splash, then a white echo
      { const bp = ball.position.clone(); bp.y = Math.max(bp.y, FLOOR + 1); goalExplosion(bp, e.winner === 0 ? 0xe0463d : 0x2f6fe0); showScored(seatNames[e.winner] || 'Player ' + (e.winner + 1), e.winner); for (const a of actors) a.kickHead(8); } break;
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
function shakeCam(cam = camera) { if (shake <= 0) return; const a = shake * shake * 0.9; cam.position.x += (Math.random() - 0.5) * a; cam.position.y += (Math.random() - 0.5) * a; cam.position.z += (Math.random() - 0.5) * a; cam.rotateZ((Math.random() - 0.5) * a * 0.03); }
function updateBooms(dt) {
  for (let i = booms.length - 1; i >= 0; i--) {
    const b = booms[i]; b.t += dt; const t = b.t, L = 1.6;
    const P = b.pts.geometry.attributes.position;
    for (let k = 0; k < b.V.length; k++) {
      const v = b.V[k]; v.y -= 30 * dt; v.multiplyScalar(1 - 1.4 * dt);
      P.array[k * 3] += v.x * dt; P.array[k * 3 + 1] += v.y * dt; P.array[k * 3 + 2] += v.z * dt;
      const dx = P.array[k * 3] - camera.position.x, dy = P.array[k * 3 + 1] - camera.position.y, dz = P.array[k * 3 + 2] - camera.position.z;
      if (dx * dx + dy * dy + dz * dz < 196) { const C = b.pts.geometry.attributes.color; C.array.fill(0, k * 3, k * 3 + 3); C.needsUpdate = true; }   // nothing flies into the lens
    }
    P.needsUpdate = true; b.pts.material.opacity = Math.max(0, 1 - t / L); b.pts.material.size = 1.1 * (1 - 0.5 * t / L);
    const r = 1 + t * 38; b.ringH.scale.setScalar(r); b.ringH.material.opacity = Math.max(0, 0.95 - t / 0.9);
    b.ringV.scale.setScalar(Math.min(1 + t * 26, 16)); b.ringV.material.opacity = Math.max(0, 0.9 - t / 0.7); b.ringV.lookAt(camera ? camera.position : b.pos);
    b.flash.scale.setScalar(Math.min(1 + t * 40, 10)); b.flash.material.opacity = Math.max(0, 0.9 - t / 0.35);
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
  $('cornerqr').hidden = s.phase === 'lobby' || paired.length > 0 || kbdSeated || !$('qr2').src;   // mid-match the lobby's QR is hidden: a screen with no phone yet gets a small one
  showPause(s.pause);
  // lobby seats
  if (s.phase === 'lobby') {
    $('seats').innerHTML = s.seats.map((q, i) => {
      const label = q.kind === 'human' ? (q.online ? 'connected' : 'offline') : q.kind === 'cpu' ? 'CPU' : 'waiting for phone...';
      const name = String(q.name || 'Player ' + (i + 1)).replace(/[&<>"]/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[ch]));   // names come from phones
      return `<div class="seat"><span class="tile-label" style="box-shadow:inset 5px 0 0 #${COLORS[i].toString(16).padStart(6, '0')},inset 0 1px 0 rgba(255,255,255,.85)">${name}</span><span class="tile-value">${label}</span></div>`;
    }).join('');
  }
}

// ---- pause menu: Esc pauses (players only: the server checks), Esc again or Resume carries on after a 3 s countdown ----
let canCtl = false, myKbd = -1, pauseKey = '', pausedNow = null;
function showPause(p) {
  pausedNow = p || null;
  const counting = !!p && p.resumeIn !== null, key = p ? [p.by, counting ? Math.ceil(p.resumeIn) : '', canCtl].join('|') : '';
  if (key === pauseKey) return; pauseKey = key;
  $('pause').hidden = !p; if (!p) return;
  $('pausettl').textContent = counting ? `Resuming in ${Math.ceil(p.resumeIn)}…` : 'Paused';
  $('pauseinfo').textContent = counting ? 'Get ready!' : canCtl ? `${p.by} paused the game · Esc to resume` : `${p.by} paused the game · waiting for the players`;
  $('pausebtns').hidden = !canCtl || counting;
}
$('resumebtn').onclick = () => send({ t: 'resume' });
$('endbtn').onclick = () => { if (confirm('End the match and go back to the lobby?')) send({ t: 'end', name: $('aolname').value.trim() }); };
function escape() {
  const ph = latest && latest.phase;
  if (!ph || ph === 'lobby' || ph === 'over') return;
  if (!canCtl) { flashMsg('Only the players can pause'); return; }
  send({ t: pausedNow && pausedNow.resumeIn === null ? 'resume' : 'pause', name: $('aolname').value.trim() });   // pausing during the countdown stops it
}

// ---- chat room window, people list, speech bubbles ------------------------------------------------------------------------------
let roster = { players: [], specs: [], screens: 0 };
function typing(e) { return e.target instanceof Element && !!e.target.closest('input, textarea, select'); }
const hexc = (c) => '#' + Number(c || 0).toString(16).padStart(6, '0');
const nameColor = (m) => (m.sys ? '' : m.seat >= 0 ? hexc(COLORS[m.seat]) : hexc(m.color));
const kv = { get(k, d) { try { return localStorage.getItem(k) ?? d; } catch { return d; } }, set(k, v) { try { localStorage.setItem(k, v); } catch { } } };
let asSid = 0;                               // which linked phone this screen talks as (0 = the screen itself)
function showWho() {                         // linked: "You are [name]" (with a picker if two phones share this screen); otherwise the screen's own name
  const sel = $('aolas');
  if (!paired.some((p) => p.sid === asSid)) asSid = paired[0]?.sid || 0;
  $('aolwholbl').textContent = asSid ? 'You are' : 'Screen name';
  sel.hidden = paired.length < 2; sel.textContent = '';
  for (const p of paired) { const o = document.createElement('option'); o.value = p.sid; o.textContent = p.name; sel.append(o); }
  sel.value = String(asSid);
  if (document.activeElement !== $('aolname')) $('aolname').value = asSid ? paired.find((p) => p.sid === asSid).name : kv.get('hostName', 'Host');
}
showWho();
$('aolas').onchange = () => { asSid = +$('aolas').value; showWho(); };
$('aolname').addEventListener('change', () => { const v = $('aolname').value.trim(); if (asSid) { if (v) send({ t: 'name', sid: asSid, name: v }); } else kv.set('hostName', v || 'Host'); });   // renames the linked phone everywhere
if (kv.get('chatMin', '0') === '1') $('aol').classList.add('min');
$('aolmin').onclick = () => { $('aol').classList.toggle('min'); kv.set('chatMin', $('aol').classList.contains('min') ? '1' : '0'); };
try { const p = JSON.parse(kv.get('chatPos', 'null')); if (p) Object.assign($('aol').style, { left: Math.min(p[0], innerWidth - 120) + 'px', top: Math.min(p[1], innerHeight - 40) + 'px' }); } catch { }
$('aolttl').addEventListener('pointerdown', (e) => {   // drag the window by its title bar, like the real thing
  if (e.target.tagName === 'BUTTON') return;
  const w = $('aol'), x0 = e.clientX - w.offsetLeft, y0 = e.clientY - w.offsetTop, mv = (ev) => { w.style.left = Math.max(0, ev.clientX - x0) + 'px'; w.style.top = Math.max(0, ev.clientY - y0) + 'px'; };
  addEventListener('pointermove', mv); addEventListener('pointerup', () => { removeEventListener('pointermove', mv); kv.set('chatPos', JSON.stringify([w.offsetLeft, w.offsetTop])); }, { once: true });
});
function sendChat() { const t = $('aolin').value.trim(); if (t) { audio(); send({ t: 'chat', text: t, name: $('aolname').value.trim() || 'Host', as: asSid }); } $('aolin').value = ''; }
$('aolsend').onclick = sendChat;
$('aolin').addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); sendChat(); } else if (e.key === 'Escape') $('aolin').blur(); });
addEventListener('keydown', (e) => { if (e.key === 'Enter' && !typing(e)) { e.preventDefault(); $('aol').classList.remove('min'); $('aolin').focus(); } });
function addChat(m) {
  const d = document.createElement('div'), b = document.createElement('b'), log = $('aollog');
  b.textContent = m.name; b.style.color = nameColor(m); d.append(b, ': ' + m.text); if (m.sys) d.className = 'sys';
  const atEnd = log.scrollTop + log.clientHeight >= log.scrollHeight - 24;
  log.append(d); while (log.childElementCount > 80) log.firstElementChild.remove();
  if (atEnd) log.scrollTop = log.scrollHeight;
}
function showPeople() {
  const ul = $('aolul'), li = (txt, cls, color) => { const e = document.createElement('li'); e.textContent = txt; if (cls) e.className = cls; if (color) e.style.color = color; ul.append(e); };
  ul.textContent = '';
  $('aolcount').textContent = `People Here: ${roster.players.filter((p) => p.kind === 'human').length + roster.specs.length}`;
  const here = (seat, sid) => (paired.some((p) => (sid ? p.sid === sid : p.seat === seat)) ? ' 📺' : '');   // linked to this screen
  li('Playing', 'grp');
  for (const p of roster.players) {
    li(`🏓 ${p.name || (p.kind === 'cpu' ? 'CPU' : 'open seat')}${p.kind === 'human' ? here(p.seat) : ''}`, '', p.kind === 'empty' ? '#808080' : hexc(COLORS[p.seat]));
    if (p.kind !== 'human' || here(p.seat) || p.seat === myKbd) continue;   // not your own seat
    const b = document.createElement('button'); b.textContent = 'kick'; b.title = `Move ${p.name} to the sideline (for when they've gone AFK)`;
    b.onclick = () => { if (confirm(`Move ${p.name} to the sideline? ${latest && latest.phase !== 'lobby' ? 'The CPU takes their seat.' : 'Their seat opens up.'}`)) send({ t: 'kick', seat: p.seat, name: $('aolname').value.trim() }); };
    ul.lastElementChild.prepend(b);
  }
  li(`Spectating (${roster.specs.length})`, 'grp');
  for (const s of roster.specs) li(`${s.chair >= 0 ? '🐸' : '👀'} ${s.name}${here(-1, s.sid)}`, '', hexc(s.color));
  if (roster.screens > 1) li(`+ ${roster.screens - 1} more screen${roster.screens > 2 ? 's' : ''} watching`, 'grp');
}
function onRoom(m) {
  if (m.t === 'roster') { roster = m; showPeople(); syncFans(m.specs); }
  else if (m.t === 'chatlog') { $('aollog').textContent = ''; m.list.forEach(addChat); $('aollog').scrollTop = 1e9; }
  else if (m.t === 'chat') { addChat(m); say(m); }
  else if (m.t === 'paired') { paired = m.phones; showWho(); showPeople(); }
  else if (m.t === 'note') flashMsg(m.text);
  else if (m.t === 'ctl') { canCtl = m.can; myKbd = m.kbd; pauseKey = ''; showPause(pausedNow); showPeople(); }
  else if (m.t === 'kicked') { kbdSeated = false; $('kbdhelp').hidden = true; $('kbd').textContent = 'Play with mouse on this PC'; flashMsg('You were moved to the sideline'); }
  else if (m.t === 'arms') { const now = performance.now(); for (const [sid, x, y, z, w] of m.a) { const f = fans.get(sid); if (f) { f.arm = [x, y, z]; f.wave = w; f.armT = now; } } }
}
// a speech bubble over the speaker's head (players' Miis and seated fans) for a few seconds, then it pops into a little splash
const speech = new Map(), _bp = new THREE.Vector3(), _bq = new THREE.Vector3();
function say(m) {
  const key = m.seat >= 0 ? 'p' + m.seat : m.sid ? 's' + m.sid : null; if (!key) return;   // a screen's chat has no head to sit on
  const old = speech.get(key); if (old) popBubble(old.el, false);
  const el = document.createElement('div'), sm = document.createElement('small');
  el.className = 'bub'; el.style.visibility = 'hidden'; sm.textContent = m.name; sm.style.color = nameColor(m); el.append(sm, m.text);
  $('bubbles').append(el);
  speech.set(key, { el, until: performance.now() + Math.min(9000, 3000 + m.text.length * 70) });
}
function popBubble(el, sound = true) {
  const r = el.getBoundingClientRect(), cx = r.left + r.width / 2, cy = r.top + r.height / 2, seen = el.style.visibility !== 'hidden' && r.width > 0;
  el.classList.add('pop'); setTimeout(() => el.remove(), 220);
  if (!seen) return;
  for (let i = 0; i < 7; i++) {
    const d = document.createElement('i'), a = (i / 7) * Math.PI * 2 + Math.random() * 0.5, dist = 26 + Math.random() * 22;
    d.className = 'drop'; d.style.left = cx + 'px'; d.style.top = cy + 'px'; d.style.setProperty('--dx', Math.cos(a) * dist + 'px'); d.style.setProperty('--dy', Math.sin(a) * dist + 'px');
    $('bubbles').append(d); setTimeout(() => d.remove(), 400);
  }
  if (sound) blip(760, 0.08, 'sine', 0.03, -360);   // a soft pop, well under everything else
}
function anchorOf(key) {
  if (key[0] === 'p') { const a = actors[+key[1]]; if (!a.root.visible) return null; a.headPivot.children[0].getWorldPosition(_bp); _bp.y += 4.4; return _bp; }
  const f = fans.get(+key.slice(1)); if (!f) return null;
  f.head.getWorldPosition(_bp); _bp.y += 3.9; return _bp;
}
function updateBubbles() {
  const now = performance.now(), w = innerWidth, h = innerHeight, split = viewCams.length > 1;
  for (const [key, b] of speech) {
    if (now > b.until) { popBubble(b.el); speech.delete(key); continue; }
    const p = anchorOf(key); let shown = false;
    // in split screen a player's bubble shows in the other player's half (your own Mii is see-through in yours)
    if (p) for (const i of split ? (key === 'p0' ? [1, 0] : [0, 1]) : [0]) {
      const cam = viewCams[i], vw = split ? w / 2 : w, v = _bq.copy(p).project(cam);
      if (v.z > 1 || Math.abs(v.x) > 1.05 || Math.abs(v.y) > 1.05) continue;
      const s = Math.max(0.55, Math.min(1.15, 55 / cam.position.distanceTo(p)));
      b.el.style.transform = `translate(${(split ? i * vw : 0) + (v.x + 1) / 2 * vw}px, ${(1 - v.y) / 2 * h}px) translate(-50%, -100%) scale(${s.toFixed(3)})`;
      shown = true; break;
    }
    b.el.style.visibility = shown ? '' : 'hidden';
  }
}

async function pollInfo() {
  try {
    $('scrcode').textContent = SCREEN;
    const r = await fetch('/api/info?s=' + SCREEN); const j = await r.json();   // this screen's own QR
    $('qr').src = j.qr; $('qr2').src = j.qr;
    $('joinurl').textContent = j.joinUrl;
    const hu = (j.publicUrl || location.origin) + '/'; $('hosturl').textContent = hu; $('hosturl').onclick = (ev) => { ev.preventDefault(); try { navigator.clipboard.writeText(hu); $('hostcopied').textContent = 'copied!'; } catch { } };
    const b = $('tbadge'); b.textContent = j.https ? 'HTTPS ready' : 'local only - waiting for tunnel...'; b.classList.toggle('ok', j.https);
  } catch { }
  setTimeout(pollInfo, 2500);
}
pollInfo();

$('start').onclick = () => { audio(); send({ t: 'start', skill: Number($('skill').value), toWin: Number($('towin').value) }); };
let kbdSeated = false;
$('musicbtn').onclick = () => { audio(); setMusic(!musicOn); };
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
  if (typing(e)) return;                     // keys typed into the chat don't drive the game
  if (e.key === 'Shift') shift = true;
  if (e.key === 'c' || e.key === 'C') { camMode = (camMode + 1) % camTargets.length; if (camMode === FREE) enterFree(); flashMsg('Camera: ' + CAM_NAMES[camMode]); }
  if (e.key === 'f' || e.key === 'F') { if (camMode === FREE) camMode = 0; else { enterFree(); camMode = FREE; } flashMsg('Camera: ' + CAM_NAMES[camMode]); }
  if (e.key === 'm' || e.key === 'M') { muted = !muted; if (music) music.setOn(musicOn && !muted); }
  if (e.key === 'n' || e.key === 'N') { setMusic(!musicOn); flashMsg('Music: ' + (musicOn ? 'on' : 'off')); }
  if (e.key === 'v' || e.key === 'V') { splitMode = splitMode === 'auto' ? 'on' : splitMode === 'on' ? 'off' : 'auto'; flashMsg('Split screen: ' + splitMode); }
  if (e.key === 'Escape') escape();
  if (e.code === 'Space' && kbdSeated) { e.preventDefault(); send({ t: 'ktoss' }); }
});
addEventListener('keyup', (e) => { if (e.key === 'Shift') shift = false; });
addEventListener('mousedown', (e) => {
  audio();
  if (!kbdSeated || pausedNow || e.target.closest('#lobby, #aol, #pause, #cornerqr')) return;
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
  if (splitMode === 'auto' && paired.filter((p) => p.seat >= 0).length === 1) return false;   // one linked player here: just their view
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
    viewCams = [camera];
    applyCam(dt); shakeCam();
    renderer.render(scene, camera);
    return;
  }
  wasSplit = true;
  renderer.autoClear = false; renderer.setScissorTest(true);
  for (let i = 0; i < 2; i++) {
    const x = Math.round(i * w / 2), vw = Math.round(w / 2) - (i === 0 ? 1 : 0);
    renderer.setViewport(x, 0, vw, h); renderer.setScissor(x, 0, vw, h); renderer.clear(true, true, false);
    const cam = splitCams[i];
    playCams[i].update(dt, latest); playCams[i].apply(cam, vw / h); shakeCam(cam);
    actors[i].setGhost(true); actors[1 - i].setGhost(false);   // own character see-through, opponent solid
    renderer.render(scene, cam);
  }
  viewCams = splitCams;
  renderer.setScissorTest(false); renderer.setViewport(0, 0, w, h); renderer.autoClear = true;
}

// ---- render loop -------------------------------------------------------------------------------
const clock = new THREE.Clock();
function interp() {
  if (!buf.length) return null;
  const tq = performance.now() / 1000 - clockOff - RENDER_DELAY;      // server time to show
  let a = buf[0], b = buf[buf.length - 1];
  for (let i = buf.length - 1; i > 0; i--) if (buf[i - 1].time <= tq) { a = buf[i - 1]; b = buf[i]; break; }
  const k = b.time === a.time ? 1 : Math.max(0, (tq - a.time) / (b.time - a.time));
  return { a, b, k: Math.min(k, 1), ex: k > 1 ? Math.min(tq - b.time, 0.05) : 0 };   // ex: seconds to extrapolate the ball past b
}
function frame() {
  const hint = document.getElementById('soundhint'); if (hint) hint.style.display = (!actx || actx.state !== 'running') && !muted ? 'block' : 'none';
  const dt = Math.min(clock.getDelta(), 0.05);
  const it = interp();
  if (it) {
    const { a, b, k, ex } = it;
    const jump = Math.hypot(b.ball.p[0] - a.ball.p[0], b.ball.p[1] - a.ball.p[1], b.ball.p[2] - a.ball.p[2]) > 8;
    const kk = jump ? 1 : k;
    for (let i = 0; i < 3; i++) ball.position.setComponent(i, a.ball.p[i] + (b.ball.p[i] - a.ball.p[i]) * kk + b.ball.v[i] * ex);
    ballV.copy(ball.position); ballVel.set(b.ball.v[0], b.ball.v[1], b.ball.v[2]); ballLive = b.phase === 'rally' || (b.phase === 'serve' && b.serveStage === 'toss');
    ball.rotation.set(b.ball.q[0], b.ball.q[1], b.ball.q[2]);
    updateSpin(dt, b.ball, b.phase === 'rally');
    const tNow = performance.now() / 1000;
    updateGlint(dt, tNow, b.phase === 'rally');
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
    const tc = _tc.copy(wob ? BALL_WOB : b.ball.sm ? BALL_SMASH : BALL_WHITE).lerp(spinCol, 0.6 * spinM);   // the trail takes on the spin colour
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
      if (!isSplit()) act.setGhost(((camMode === 0 || camMode === 4) && i === mainSeat()) || (camMode === 2 && i !== mainSeat()));
      act.update(dt);
      act.applyRk((b.seats[i].rk?.phone ? latest : b).seats[i].rk);   // a phone-driven paddle shows the freshest pose: least lag from the hand
      act.setFaceCue(latest.seats[i].fe);
    }
    // camera easing toward the active side in auto mode is intentionally off - fixed cameras
  }
  for (let i = bounceMarks.length - 1; i >= 0; i--) {
    const m = bounceMarks[i]; m.userData.age += dt;
    const t = m.userData.age / 0.6; m.scale.setScalar(1 + t); m.material.opacity = 0.8 * (1 - t);
    if (t >= 1) { scene.remove(m); bounceMarks.splice(i, 1); }
  }
  updateScenery(performance.now() / 1000, dt);
  updateFloorViz(dt, performance.now() / 1000, !!latest && latest.phase === 'rally');
  updateBooms(dt);
  updateFans(dt);
  renderViews(dt);
  updateBubbles();
  renderTilts(latest);
  requestAnimationFrame(frame);
}
frame();

window.__dbg = { sfxBuf, audioCtx: () => actx, actors, fans, free, camera, scene, floorViz, setCam: (m) => { camMode = m; }, get latest() { return latest; } };
