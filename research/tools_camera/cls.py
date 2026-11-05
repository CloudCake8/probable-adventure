import sys; sys.path.insert(0,'.')
from cam import *
import struct,re
def fn_end(a):
    s,e=func_bounds(a); return e
def vt_in(ctor):
    # search first 0x200 bytes for lis/addi making 0x806dxxxx and stw 0(r)
    regs={}
    out=[]
    for a in range(ctor,ctor+0x300,4):
        w=u32(a); op=w>>26; rt=(w>>21)&31; ra=(w>>16)&31
        if op==15 and ra==0: regs[rt]=(P.s16(w)<<16)&0xffffffff
        elif op==14 and ra in regs:
            v=(regs[ra]+P.s16(w))&0xffffffff
            if 0x806c0000<=v<0x806f0000: out.append(v)
    return out
import ppc_probe as P
for c in sys.argv[1:]:
    c=int(c,16)
    v=vt_in(c)
    print(hex(c),[hex(x) for x in v][:6])
    for vt in dict.fromkeys(v):
        ents=[u32(vt+4*i) for i in range(0,16)]
        print('   ',hex(vt),' '.join(f'{e:08x}' for e in ents))
