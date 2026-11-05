import struct,numpy as np
from rbnk2 import d,RWAR
def nib2samp(n): return (n//16)*14+max(0,(n%16)-2)
def wave(i):
    tabl=RWAR+struct.unpack_from('>I',d,RWAR+0x10)[0]; data=RWAR+struct.unpack_from('>I',d,RWAR+0x18)[0]
    n=struct.unpack_from('>I',d,tabl+8)[0]
    wo=data+struct.unpack_from('>I',d,tabl+0xc+i*12+4)[0]
    assert d[wo:wo+4]==b'RWAV'
    info=wo+struct.unpack_from('>I',d,wo+0x10)[0]; dat=wo+struct.unpack_from('>I',d,wo+0x18)[0]
    W=info+8
    fmt,loop,ch=d[W],d[W+1],d[W+2]; rate=struct.unpack_from('>H',d,W+4)[0]
    ls=struct.unpack_from('>I',d,W+8)[0]; le=struct.unpack_from('>I',d,W+0xc)[0]
    if fmt==2: ls=nib2samp(ls)
    N=nib2samp(le)+1 if fmt==2 else le+1
    tbl=W+struct.unpack_from('>I',d,W+0x10)[0]
    chans=[]
    for c in range(ch):
        ci=W+struct.unpack_from('>I',d,tbl+c*4)[0]
        p=dat+8+struct.unpack_from('>I',d,ci)[0]
        ai=W+struct.unpack_from('>I',d,ci+4)[0]
        coef=struct.unpack_from('>16h',d,ai)
        out=np.zeros(N);h1=h2=0;s=0
        while s<N:
            ps=d[p];p+=1;sc=1<<(ps&15);ci_=(ps>>4)&7;c1,c2=coef[ci_*2],coef[ci_*2+1]
            for k in range(14):
                if s>=N:break
                b=d[p+(k>>1)];nb=(b&15) if k&1 else b>>4
                if nb>=8:nb-=16
                v=(((nb*sc)<<11)+1024+c1*h1+c2*h2)>>11
                v=max(-32768,min(32767,v));out[s]=v;h2=h1;h1=v;s+=1
            p+=7
        chans.append(out)
    return dict(rate=rate,loop=loop,loopstart=ls,n=N,ch=chans,fmt=fmt,gloss=None)
