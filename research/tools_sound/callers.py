import sys,struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo,hi=0x80450000,0x80490000
if len(sys.argv)>2: lo,hi=int(sys.argv[1],0),int(sys.argv[2],0)
W=[0x802b72dc,0x802b72e0,0x802b732c,0x802b7344,0x802b735c,0x802b7374,0x802b7384,0x802b7394,0x802b73ac,0x802b73bc,0x802ba2b8,0x802ba784,0x802baf1c,0x802baff0,0x802bb2e4,0x802bb404,0x802bb130,0x802bb26c,0x802bb3d4,0x802bb39c,0x802bb36c,0x802bb0ec,0x802bb1e4]
for a in range(lo,hi,4):
    w=P.u32(a)
    if w>>26!=18 or not w&1: continue
    d=w&0x03fffffc
    if d&0x02000000: d-=0x04000000
    t=(a+d)&0xffffffff
    if t in W:
        # scan back for li into r3-r6
        found={}
        for b in range(a-4,a-80,-4):
            x=P.u32(b)
            if x==0x4e800020 or x>>16==0x9421: break
            if x>>26==14 and (x>>16&31)==0 and (x>>21&31) in (3,4,5,6,7) and (x>>21&31) not in found: found[x>>21&31]=P.s16(x)
        print(f'{a:08x} -> {t:08x} '+' '.join(f'r{r}={v}' for r,v in sorted(found.items())))
