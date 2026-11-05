"""Per-frame world speed of right-hand points for swing clips (FK from CHR0 + GLB rest). Units = model units/frame."""
import sys, math
sys.path.insert(0, r"D:/projects/claude's wii sports plan/resortcompiled/research/tools_animation")
from chr0_analyze import *
names, parent, nodes = load_skel()
import json
clips = sys.argv[1:] or ['fore','back','fore_SP','back_SP','front','fore_SP2','back_SP2','fore_SP3','back_SP3','serve_F','serve_B']
for nm in clips:
    clip = json.load(open(f"{ANIM}/WS2_png_ava_{nm}.chr0.json"))
    N = clip['frames']
    idxs = {k: names.index(k) for k in ('wrist_r','finger_r2','arm_r2')}
    poses = [pose(names, parent, nodes, clip, f) for f in range(N)]
    print(f"== {nm} ({N} frames)")
    for k, i in idxs.items():
        pts = [p[i][1] for p in poses]
        sp = [math.dist(pts[j], pts[j-1]) for j in range(1, N)]   # sp[j-1] = movement from frame j-1 -> j
        top = sorted(range(len(sp)), key=lambda j: -sp[j])[:3]
        print(f"  {k:9s} peak f{top[0]}->f{top[0]+1}={sp[top[0]]:.3f} ; top3 pairs {[(t, round(sp[t],2)) for t in top]}")
        if k == 'finger_r2': print('   speeds:', ' '.join(f'{s:.2f}' for s in sp))
