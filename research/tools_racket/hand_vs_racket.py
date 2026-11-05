import sys, json, math
sys.path.insert(0, r"D:/projects/claude's wii sports plan/resortcompiled/research/tools_animation")
from chr0_analyze import *
names, parent, nodes = load_skel()
iw=names.index('wrist_r'); ic=names.index('chest'); iwl=names.index('wrist_l'); ih=names.index('head')
for nm in ['wait','walk','fore','back','fore_SP','serve_F','servewait_F']:
    try: clip=json.load(open(f"{ANIM}/WS2_png_ava_{nm}.chr0.json"))
    except Exception as ex: print(nm,'missing'); continue
    N=clip['frames']
    ps=[pose(names,parent,nodes,clip,f) for f in (0,N//4,N//2,N-1)]
    print(nm,N)
    for p in ps: print('  wrist_r',[round(x,2) for x in p[iw][1]],'chest',[round(x,2) for x in p[ic][1]],'wrist_l',[round(x,2) for x in p[iwl][1]],'head',[round(x,2) for x in p[ih][1]])
