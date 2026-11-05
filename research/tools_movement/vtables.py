import sys
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
LO,HI=0x80450000,0x80490000
for a,o,z,k in P.SECS:
    if k=='text': continue
    run=[];start=None
    for off in range(0,z,4):
        v=P.u32(a+off)
        if LO<=v<HI and v%4==0:
            if start is None: start=a+off
            run.append(v)
        else:
            if len(run)>=2: print(f"{start:08x} n={len(run)} rtti/typeinfo_prev={P.u32(start-8) if P.read(start-8) else 0:08x},{P.u32(start-4):08x} :: "+" ".join(f"{x:08x}" for x in run[:40]))
            run=[];start=None
