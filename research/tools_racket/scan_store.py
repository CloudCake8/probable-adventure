import sys,struct
from ppcemu import P
# find stores (stw/stfs/psq_st) with disp 0x40..0x84 on same base reg within 60 instrs: report windows with >=4 distinct offsets
res=[]
for a,o,z,k in P.SECS:
    if k!='text': continue
    ws=[struct.unpack_from('>I',P.DATA,o+off)[0] for off in range(0,z,4)]
    for i,w in enumerate(ws):
        op=w>>26
        if op in (36,37,52,53,60):
            base=(w>>16)&31
            offs=set()
            for j in range(i,min(i+40,len(ws))):
                w2=ws[j]
                if (w2>>26) in (36,37,52,53,60) and ((w2>>16)&31)==base:
                    d=w2&0xffff if (w2>>26)!=60 else w2&0xfff
                    offs.add(d)
            need={0x40,0x44,0x48,0x4c}
            if need<=offs and 0x50 in offs and 0x54 in offs:
                res.append(a+i*4)
last=-100
for r in res:
    if r-last>0x100: print(hex(r))
    last=r
