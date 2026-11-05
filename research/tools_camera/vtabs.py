import sys; sys.path.insert(0,'.')
from cam import *
import struct
res=[]
for a,o,z,k in SECS:
    if k!='data': continue
    i=0
    while i<z-4:
        run=[];j=i
        while j<z-4:
            w=struct.unpack_from('>I',DATA,o+j)[0]
            if 0x80004000<=w<0x80650000 and w%4==0 : run.append(w); j+=4
            else: break
        if len(run)>=4:
            res.append((a+i,run))
        i=j+4 if j>i else i+4
for s,r in res:
    inr=[x for x in r if 0x80450000<=x<0x8047c000]
    if len(inr)>=2: print(f'{s:08x} n={len(r)} inpng={len(inr)} ', ' '.join(f'{x:08x}' for x in r[:24]))
