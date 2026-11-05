import struct
ROOT="D:/projects/claude's wii sports plan/"
d=open(ROOT+'unpacked/Sound/Static/Sp2Snd.brsar','rb').read()
RBNK=12241056; RWAR=12277344
data_off=struct.unpack_from('>I',d,RBNK+0x10)[0]
D=RBNK+data_off+8
def ref(o): return d[o],d[o+1],struct.unpack_from('>I',d,o+4)[0]
def inst(p):
    o=D+p
    f=struct.unpack_from('>BBBBBBBBBBBB',d,o+4)
    return dict(wave=struct.unpack_from('>i',d,o)[0],A=f[0],D=f[1],S=f[2],R=f[3],hold=f[4],loc=f[5],noteoff=f[6],alt=f[7],orig_key=f[8],vol=f[9],pan=f[10],tune=struct.unpack_from('>f',d,o+16)[0])
def table(r,lo=0,hi=127):
    """yield (min,max,ref) for range/index tables, or direct"""
    _,typ,p=r
    if typ==1: return [(lo,hi,r)]
    if typ==2:
        n=d[D+p]; mx=list(d[D+p+1:D+p+1+n]); q=(p+1+n+3)&~3; out=[];l=0
        for i in range(n):
            out.append((l,mx[i],ref(D+q+i*8)));l=mx[i]+1
        return out
    if typ==3:
        a,b=d[D+p],d[D+p+1]
        return [(k,k,ref(D+p+4+(k-a)*8)) for k in range(a,b+1)]
    return []
def regions(prog):
    n=struct.unpack_from('>I',d,D)[0]
    r=ref(D+4+prog*8)
    out=[]
    for klo,khi,kr in table(r):
        for vlo,vhi,vr in table(kr):
            if vr[1]==1: out.append((klo,khi,vlo,vhi,inst(vr[2])))
            else: out.append((klo,khi,vlo,vhi,('nested',vr)))
    return out
def lookup(prog,key,vel):
    for klo,khi,vlo,vhi,i in regions(prog):
        if klo<=key<=khi and vlo<=vel<=vhi: return i
nprog=struct.unpack_from('>I',d,D)[0]
if __name__=='__main__':
    print('nprog',nprog)
    for p in range(nprog):
        r=ref(D+4+p*8)
        print(p,'topref type',r[1],[ (k[1]) for k in table(r)][:3])
    import collections
    for p in (0,26,3,7,8,21):
        rs=regions(p)
        print('prog',p,len(rs))
        last=None
        for klo,khi,vlo,vhi,i in rs:
            key=(i['wave'],i['orig_key'],i['vol'],vlo,vhi) if isinstance(i,dict) else str(i)
            if key!=last: print('  keys',klo,khi,'vel',vlo,vhi,i); last=key
