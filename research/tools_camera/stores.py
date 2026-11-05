import sys; sys.path.insert(0,'.')
from cam import *
import ppc_probe as P
import struct
lo,hi=int(sys.argv[1],16),int(sys.argv[2],16)
rng=(0x80004000,0x80650000)
for a,o,z,k in SECS:
    if k!='text': continue
    regs={}
    for off in range(0,z,4):
        w=struct.unpack_from('>I',DATA,o+off)[0]; op=w>>26; rt=w>>21&31; ra=w>>16&31
        if op==15 and ra==0: regs[rt]=(P.s16(w)<<16)&0xffffffff
        elif op==14 and ra in regs: regs[rt]=(regs[ra]+P.s16(w))&0xffffffff
        elif op in (36,52,38,44) and ra in regs:
            ad=(regs[ra]+P.s16(w))&0xffffffff
            if lo<=ad<hi: print(f'{a+off:08x} store op{op} -> {ad:08x}')
        if w==0x4e800020: regs={}
