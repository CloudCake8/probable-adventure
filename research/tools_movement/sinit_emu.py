"""Straight-line mini emulator for static-initializer (.ctors) functions. Recovers BSS statics (Vec3 constants etc).
usage: sinit_emu.py lo hi   -> prints all stored (addr, value) for ctor fns whose address in [lo,hi)"""
import sys, struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo=int(sys.argv[1],0); hi=int(sys.argv[2],0)
ctors=[P.u32(0x80653fa0+i) for i in range(0,0x5a0,4)]
ctors=[c for c in ctors if lo<=c<hi]
def f32(b): return struct.unpack('>f',struct.pack('>I',b))[0]
def run(entry):
    R=[0]*32; R[2]=0x806fe080; R[13]=0x806f8120; F=[0.0]*32
    mem={}; calls=[]
    pc=entry
    for _ in range(4000):
        w=P.u32(pc); op=w>>26; d=w>>21&31; a=w>>16&31; b=w>>11&31; imm=P.s16(w)
        def ea(): return ((R[a] if a else 0)+imm)&0xffffffff
        if w==0x4e800020: break
        if op==15: R[d]=((R[a] if a else 0)+(imm<<16))&0xffffffff
        elif op==14: R[d]=((R[a] if a else 0)+imm)&0xffffffff
        elif op==24: R[a]=R[d]|(w&0xffff)
        elif op==25: R[a]=R[d]|((w&0xffff)<<16)
        elif op==31 and (w>>1&0x3ff)==444: R[a]=R[d]|R[b]  # or/mr
        elif op==48: v=P.read(ea(),4); F[d]=struct.unpack('>f',v)[0] if v else float('nan')
        elif op==52: mem[ea()]=('f',F[d])
        elif op==36: mem[ea()]=('w',R[d])
        elif op==32:
            v=mem.get(ea()); 
            if v and v[0]=='w': R[d]=v[1]
            else:
                x=P.read(ea(),4); R[d]=struct.unpack('>I',x)[0] if x else 0
        elif op==63 and (w>>1&0x3ff)==72: F[d]=F[b]  # fmr
        elif op==18 and w&1:
            dd=w&0x03fffffc
            if dd&0x02000000: dd-=0x04000000
            calls.append(((pc+dd)&0xffffffff,pc,tuple(R[3:7])))
        pc+=4
    return mem,calls
for c in ctors:
    mem,calls=run(c)
    if not mem and not calls: continue
    print(f"== sinit {c:08x}")
    for ad in sorted(mem):
        k,v=mem[ad]
        print(f"   {ad:08x} {k} {v if k=='f' else hex(v)}")
    for tgt,pc,args in calls: print(f"   call {tgt:08x} from {pc:08x} r3..r6={[hex(x) for x in args]}")
