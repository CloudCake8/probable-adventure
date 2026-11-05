"""Tiny scalar PPC FPU interpreter for straight-line helper functions (no calls/branches)."""
import sys,struct; sys.path.insert(0,'.')
from cam import *
import random
def f2b(x): return struct.unpack('>I',struct.pack('>f',x))[0]
def b2f(b): return struct.unpack('>f',struct.pack('>I',b))[0]
class Emu:
    def __init__(s): s.f=[0.0]*32; s.r=[0]*32; s.mem={}; s.r[1]=0x10000000
    def rd(s,a): return s.mem.get(a,0)
    def wr(s,a,v): s.mem[a]=v&0xffffffff
    def putf(s,a,x): s.wr(a,f2b(x))
    def getf(s,a): return b2f(s.rd(a))
    def run(s,start,end,maxn=2000):
        pc=start;n=0
        while pc<end and n<maxn:
            w=u32(pc);op=w>>26;rt=(w>>21)&31;ra=(w>>16)&31;rb=(w>>11)&31;rc=(w>>6)&31;xo=(w>>1)&1023;d=P.s16(w)
            ea=lambda:((s.r[ra] if ra else 0)+d)&0xffffffff
            R=lambda x:b2f(f2b(x))
            if op==14: s.r[rt]=((s.r[ra] if ra else 0)+d)&0xffffffff
            elif op==15: s.r[rt]=((s.r[ra] if ra else 0)+(d<<16))&0xffffffff
            elif op==37: s.r[ra]=ea(); s.wr(s.r[ra],s.r[rt])    # stwu
            elif op==36: s.wr(ea(),s.r[rt])
            elif op==32: s.r[rt]=s.rd(ea())
            elif op==48: s.f[rt]=b2f(s.rd(ea()))
            elif op==52: s.wr(ea(),f2b(s.f[rt]))
            elif op in (56,57,60,61,54,50,46,47,31 if False else -1): pass
            elif op==63 or op==59:
                a,b,c=s.f[ra],s.f[rb],s.f[rc]
                x=xo&31
                if op==59:
                    if x==25: v=a*c
                    elif x==29: v=a*c+b
                    elif x==28: v=a*c-b
                    elif x==30: v=-(a*c-b)
                    elif x==31: v=-(a*c+b)
                    elif x==21: v=a+b
                    elif x==20: v=a-b
                    elif x==18: v=a/b
                    else: raise Exception(f'op59 xo{xo} at {pc:x}')
                    s.f[rt]=R(v)
                else:
                    if xo==72: s.f[rt]=s.f[rb]
                    elif xo==40: s.f[rt]=-s.f[rb]
                    elif xo==264: s.f[rt]=abs(s.f[rb])
                    elif xo==12: s.f[rt]=R(s.f[rb])
                    else: raise Exception(f'op63 xo{xo} at {pc:x}')
            elif w==0x7c0802a6 or w==0x7c0803a6 or w==0x4e800020: 
                if w==0x4e800020: return
            elif op==47 or op==18 or op==16: raise Exception(f'branch at {pc:x}')
            elif op==31 and xo in (444,): s.r[ra]=s.r[rt]|s.r[rb]
            elif op==19: raise Exception('b')
            elif op in (45,44,40,41,42,43,34,35,33,38,39): pass
            else:
                pass
            pc+=4;n+=1
import ppc_probe as P
def mm(a,b): return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def tr(a): return [[a[j][i] for j in range(3)] for i in range(3)]
def mx(a,b): return max(abs(a[i][j]-b[i][j]) for i in range(3) for j in range(3))
if __name__=='__main__':
    e=Emu()
    A=[random.random() for _ in range(9)]; B=[random.random() for _ in range(12)]
    ra,rb,ro=0x20000000,0x20000100,0x20000200
    for i in range(9): e.putf(ra+4*i,A[i])
    for i in range(12): e.putf(rb+4*i,B[i])
    e.r[3]=ro;e.r[4]=ra;e.r[5]=rb
    e.run(0x80327664,0x80327800)
    out=[e.getf(ro+4*i) for i in range(9)]
    M=lambda v:[v[0:3],v[3:6],v[6:9]]
    Am,Om=M(A),M(out)
    Bm=[B[0:3],B[4:7],B[8:11]]
    for name,c in [('A@B',mm(Am,Bm)),('B@A',mm(Bm,Am)),('At@B',mm(tr(Am),Bm)),('B@At',mm(Bm,tr(Am))),('A@Bt',mm(Am,tr(Bm))),('Bt@A',mm(tr(Bm),Am)),('At@Bt',mm(tr(Am),tr(Bm))),('Bt@At',mm(tr(Bm),tr(Am)))]:
        print(name, mx(Om,c))
