"""Analyse WS2_png_ava CHR0 JSON clips: bones driven, FK hand speed peaks, root motion.
Usage: py -3 chr0_analyze.py [--json out.json]
Skeleton hierarchy from models_animated/.../WS2_png_ava__WS2_avaA1.glb (read-only)."""
import json, struct, math, sys, glob, os
ROOT = r"D:/projects/claude's wii sports plan/assets"
ANIM = ROOT + "/animations/Stage/PngScene/Common/G3D/WS2_png_ava"
GLB = ROOT + "/models_animated/Stage/PngScene/Common/G3D/WS2_png_ava__WS2_avaA1.glb"

def load_skel():
    b = open(GLB, 'rb').read()
    l = struct.unpack('<I', b[12:16])[0]
    j = json.loads(b[20:20+l])
    nodes = j['nodes'][:28]
    parent = {}
    for i, n in enumerate(nodes):
        for c in n.get('children', []):
            if c < 28: parent[c] = i
    return [n['name'] for n in nodes], parent, nodes

def hermite(keys, f):
    # keys: [frame, value, tangent]; BRRES style cubic hermite with tangent as slope per frame
    if f <= keys[0][0]: return keys[0][1]
    if f >= keys[-1][0]: return keys[-1][1]
    for a, b in zip(keys, keys[1:]):
        if a[0] <= f <= b[0]:
            dt = b[0]-a[0]
            t = (f-a[0])/dt
            t2, t3 = t*t, t*t*t
            return ((2*t3-3*t2+1)*a[1] + (t3-2*t2+t)*dt*a[2] + (-2*t3+3*t2)*b[1] + (t3-t2)*dt*b[2])

def eval_track(tr, f):
    if 'const' in tr: return tr['const']
    if 'per_frame' in tr:
        pf = tr['per_frame']; i = max(0, min(len(pf)-1, int(round(f)))); return pf[i]
    return hermite(tr['keys'], f)

def rotmat(rx, ry, rz):
    rx, ry, rz = map(math.radians, (rx, ry, rz))
    cx, sx, cy, sy, cz, sz = math.cos(rx), math.sin(rx), math.cos(ry), math.sin(ry), math.cos(rz), math.sin(rz)
    # R = Rz * Ry * Rx
    return [[cz*cy, cz*sy*sx - sz*cx, cz*sy*cx + sz*sx],
            [sz*cy, sz*sy*sx + cz*cx, sz*sy*cx - cz*sx],
            [-sy,   cy*sx,            cy*cx]]

def mm(a, b):
    return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def mv(a, v):
    return [sum(a[i][k]*v[k] for k in range(3)) for i in range(3)]

def pose(names, parent, nodes, clip, f):
    local = {}
    for i, n in enumerate(names):
        bd = clip['bones'].get(n, {})
        rest_t = nodes[i].get('translation', [0, 0, 0])
        t = [eval_track(bd['t'][k], f) if 't' in bd else rest_t[k] for k in range(3)]
        if 'r' in bd:
            r = [eval_track(bd['r'][k], f) for k in range(3)]
        else:
            r = None
        local[i] = (t, r)
    world = {}
    for i in range(len(names)):
        t, r = local[i]
        if r is None:
            q = nodes[i].get('rotation', [0, 0, 0, 1])
            x, y, z, w = q
            R = [[1-2*(y*y+z*z), 2*(x*y-z*w), 2*(x*z+y*w)],
                 [2*(x*y+z*w), 1-2*(x*x+z*z), 2*(y*z-x*w)],
                 [2*(x*z-y*w), 2*(y*z+x*w), 1-2*(x*x+y*y)]]
        else:
            R = rotmat(*r)
        if i in parent:
            pR, pT = world[parent[i]]
            world[i] = (mm(pR, R), [pT[k]+mv(pR, t)[k] for k in range(3)])
        else:
            world[i] = (R, t)
    return world

def bone_summary(clip):
    out = {}
    for n, bd in clip['bones'].items():
        d = {}
        for ch in ('r', 't'):
            if ch in bd:
                moving = [('const' not in tr) for tr in bd[ch]]
                if any(moving): d[ch] = ''.join('XYZ'[k] if moving[k] else '-' for k in range(3))
        if d: out[n] = d
    return out

def main():
    names, parent, nodes = load_skel()
    res = {}
    for p in sorted(glob.glob(ANIM + '/*.chr0.json')):
        clip = json.load(open(p))
        nm = os.path.basename(p).replace('WS2_png_ava_', '').replace('.chr0.json', '')
        N = clip['frames']
        hands = {}
        for hn in ('wrist_l', 'wrist_r'):
            idx = names.index(hn)
            pts = [pose(names, parent, nodes, clip, f)[idx][1] for f in range(N)]
            # also "hand tip": wrist + 1.5 units along local x (finger direction) approx
            sp = [math.dist(pts[i], pts[i-1]) for i in range(1, N)]
            pk = max(range(len(sp)), key=lambda i: sp[i]) if sp else 0
            hands[hn] = {'peak_speed_frame_pair': [pk, pk+1] if sp else None,
                         'peak_speed_units_per_frame': round(max(sp), 3) if sp else 0,
                         'speed': [round(s, 3) for s in sp]}
        rootmove = {}
        for rn in ('all_root', 'skl_root'):
            bd = clip['bones'].get(rn, {})
            if 't' in bd:
                rootmove[rn] = [[round(eval_track(bd['t'][k], f), 3) for f in (0, N-1)] for k in range(3)]
        res[nm] = {'frames': N, 'loop': clip['loop'], 'driven': bone_summary(clip), 'hands': hands, 'root_t_first_last': rootmove}
    if '--json' in sys.argv:
        json.dump(res, open(sys.argv[sys.argv.index('--json')+1], 'w'), indent=1)
    for nm, r in res.items():
        print(f"{nm:12s} frames={r['frames']:3d} loop={r['loop']}  wrist_r peak f{r['hands']['wrist_r']['peak_speed_frame_pair']} {r['hands']['wrist_r']['peak_speed_units_per_frame']}  wrist_l peak f{r['hands']['wrist_l']['peak_speed_frame_pair']} {r['hands']['wrist_l']['peak_speed_units_per_frame']}")
        print('    driven bones:', ', '.join(f"{b}[{''.join(v.get('r','')[:0])}r:{v.get('r','')} t:{v.get('t','')}]" for b, v in r['driven'].items()))
if __name__ == '__main__':
    main()
