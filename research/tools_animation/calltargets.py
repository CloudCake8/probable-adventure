"""Histogram of bl targets from range lo..hi falling in tlo..thi, with call sites. usage: calltargets.py lo hi tlo thi"""
import sys; sys.path.insert(0,r"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as p, collections
lo,hi,tlo,thi=[int(x,0) for x in sys.argv[1:5]]
d=collections.defaultdict(list)
for a in range(lo,hi,4):
    w=p.u32(a)
    if w>>26==18 and w&1:
        off=w&0x3fffffc
        if off&0x2000000: off-=0x4000000
        t=(a+off)&0xffffffff
        if tlo<=t<thi: d[t].append(a)
for t in sorted(d): print(f'{t:08x} x{len(d[t])}: '+' '.join(f'{a:x}' for a in d[t][:12]))
