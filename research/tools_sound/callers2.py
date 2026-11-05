import sys
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
T=[int(x,0) for x in sys.argv[3:]]
lo,hi=int(sys.argv[1],0),int(sys.argv[2],0)
for a in range(lo,hi,4):
    w=P.u32(a)
    if w>>26!=18 or not w&1: continue
    d=w&0x03fffffc
    if d&0x02000000: d-=0x04000000
    t=(a+d)&0xffffffff
    if t in T:
        found={}
        for b in range(a-4,a-60,-4):
            x=P.u32(b)
            if x==0x4e800020 or x>>16==0x9421: break
            if x>>26==14 and (x>>16&31)==0 and (x>>21&31) in (3,4,5,6) and (x>>21&31) not in found: found[x>>21&31]=P.s16(x)
        print(f'{a:08x} -> {t:08x} '+' '.join(f'r{r}={v}' for r,v in sorted(found.items())))
