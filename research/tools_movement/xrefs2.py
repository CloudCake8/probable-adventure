"""Like ppc_probe.xrefs but any D-form load/store, any base reg tracked from lis; prints decoded op. usage: xrefs2.py lo hi [text_lo text_hi]"""
import sys, struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo=int(sys.argv[1],0); hi=int(sys.argv[2],0)
tlo=int(sys.argv[3],0) if len(sys.argv)>3 else 0
thi=int(sys.argv[4],0) if len(sys.argv)>4 else 1<<32
NAMES={14:'addi',24:'ori',32:'lwz',33:'lwzu',34:'lbz',36:'stw',37:'stwu',38:'stb',40:'lhz',44:'sth',48:'lfs',49:'lfsu',50:'lfd',52:'stfs',53:'stfsu',54:'stfd',56:'psq_l',60:'psq_st'}
for a,o,z,k in P.SECS:
    if k!='text': continue
    regs={}
    for off in range(0,z,4):
        pc=a+off
        w=struct.unpack_from('>I',P.DATA,o+off)[0]; op=w>>26; rt=w>>21&31; ra=w>>16&31
        if op==15 and ra==0: regs[rt]=(P.s16(w)<<16)&0xffffffff
        elif op in NAMES:
            base=ra if op not in (24,) else rt
            if base in regs:
                if op==24: val=regs[rt]|(w&65535)  # ori ra,rs
                else: val=(regs[ra]+P.s16(w))&0xffffffff
                if lo<=val<hi and tlo<=pc<thi: print(f"{pc:08x} {NAMES[op]:6s} r{rt} -> {val:08x}")
        if w==0x4e800020: regs={}
