"""List function boundaries (stwu r1 prologue .. blr) in a range, with sizes, bl callees, and r2/r13 float const count."""
import sys, struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo=int(sys.argv[1],0); hi=int(sys.argv[2],0)
starts=[]
for a in range(lo,hi,4):
    w=P.u32(a)
    if w>>16==0x9421 : starts.append(a)   # stwu r1,-N(r1)
# include functions without frame: skip
for i,s in enumerate(starts):
    e=starts[i+1] if i+1<len(starts) else hi
    # find last blr before e
    last=s
    for a in range(s,e,4):
        if P.u32(a)==0x4e800020: last=a
    callees=set()
    for a in range(s,last+4,4):
        w=P.u32(a)
        if w>>26==18 and w&1:
            d=w&0x03fffffc
            if d&0x02000000: d-=0x04000000
            callees.add((a+d)&0xffffffff)
    print(f"{s:08x} size={last+4-s:5x} calls={len(callees)} "+" ".join(f"{c:08x}" for c in sorted(callees))[:200])
