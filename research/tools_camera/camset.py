import sys; sys.path.insert(0,'.')
from cam import *
import ppc_probe as P
fns=[int(l,16) for l in open('fnlist.txt')]+[0x80490000]
fns=[f for f in fns]
# extend list beyond 8047c000 using MAP
MAP="C:/Users/khangai/AppData/Local/Temp/claude/b2b187eac693e308/3ea1bec7-8c4c-4679-a8d3-c1a57740f3fc/scratchpad/rc/repo/projects/wsr/MAP.txt"
fns=sorted(int(l.split()[0],16) for l in open(MAP) if l.strip() and 0x80450000<=int(l.split()[0],16)<0x80495000)
for i,f in enumerate(fns[:-1]):
    e=fns[i+1]
    camregs=set(); hits=[]
    for a in range(f,e,4):
        w=u32(a); op=w>>26; rt=w>>21&31; ra=w>>16&31; d=P.s16(w)
        if op==32 and d in (0x94,) : camregs.add(rt)       # lwz rt,0x94(ra)
        elif op==32 and rt in camregs: camregs.discard(rt)
        if op in (36,52,38) and ra in camregs and d in (0x54,0x58,0x5c,0x60,0x64,0x68,0x90,0x94,0x3c,0x40,0x44,0x48):
            hits.append((a,d))
    if hits: print(f'{f:08x}', [(hex(a),hex(d)) for a,d in hits])
