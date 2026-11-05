import sys; sys.path.insert(0,'.')
from cam import *
import re,struct
fns=[int(l,16) for l in open('fnlist.txt')]
fns.append(0x8047c000)
# bl-call graph within region
calls={}
for i,f in enumerate(fns[:-1]):
    e=fns[i+1]; out=[]; fl=0
    for a in range(f,e,4):
        w=u32(a)
        if w>>26==18 and w&1:
            d=w&0x03fffffc
            if d&0x02000000: d-=0x04000000
            out.append((a+d)&0xffffffff)
        if w>>26==48: fl+=1  # lfs
    calls[f]=(e-f,fl,out)
import json
for f,(sz,fl,out) in calls.items():
    print(f'{f:08x} sz={sz:5x} lfs={fl:3d} calls={" ".join(f"{x:08x}" for x in dict.fromkeys(out))}')
