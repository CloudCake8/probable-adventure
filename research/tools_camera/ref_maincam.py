"""Reference (host-float) re-implementation of the recovered main gameplay camera (see ../camera.md).
Conventions: Mat33 stored as 3 row-Vec3 (basis rows = camera local x/y/z axes in world). World matrix W = basis^T,
camera looks along -row2. Y up. Angles in degrees."""
import math, sys
def v_add(a,b): return [a[0]+b[0],a[1]+b[1],a[2]+b[2]]
def v_sub(a,b): return [a[0]-b[0],a[1]-b[1],a[2]-b[2]]
def v_mul(a,s): return [a[0]*s,a[1]*s,a[2]*s]
def dot(a,b): return a[0]*b[0]+a[1]*b[1]+a[2]*b[2]
def cross(a,b): return [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
def norm(a):
    l=math.sqrt(dot(a,a)); return (None,0.0) if l==0 else ([x/l for x in a],l)
def mm(a,b): return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def tr(a): return [[a[j][i] for j in range(3)] for i in range(3)]
def rotx(d): c,s=math.cos(math.radians(d)),math.sin(math.radians(d)); return [[1,0,0],[0,c,-s],[0,s,c]]
def roty(d): c,s=math.cos(math.radians(d)),math.sin(math.radians(d)); return [[c,0,s],[0,1,0],[-s,0,c]]
def rotz(d): c,s=math.cos(math.radians(d)),math.sin(math.radians(d)); return [[c,-s,0],[s,c,0],[0,0,1]]
def rot_xyz(x,y,z): return mm(rotz(z),mm(roty(y),rotx(x)))   # nw4r MTX34RotXYZ: Rz*Ry*Rx (assumed)
def vecmat(v,M): return [v[0]*M[0][j]+v[1]*M[1][j]+v[2]*M[2][j] for j in range(3)]  # v.x*row0+v.y*row1+v.z*row2
def ease(t): return 0.5*(1-math.cos(math.pi*t))
MIRROR=lambda seat,v: v if seat==0 else [-v[0],v[1],-v[2]]
MIRROR33=lambda seat,M: [MIRROR(seat,r) for r in M]
def make_frustum(w,h,fov,mL,mR,top=0.7,bot=1.0):
    t=math.tan(math.radians(fov/2)); tx=t*w/h
    C1=[tx*mR,-t*bot,-1.];C2=[tx*mR,t*top,-1.];C3=[-tx*mL,t*top,-1.];C4=[-tx*mL,-t*bot,-1.]
    N=lambda a,b: norm(cross(a,b))[0]
    return {'L':N(C3,C4),'R':N(C1,C2),'T':N(C2,C3),'B':N(C4,C1)}
def view_point(pos,basis,p):          # world->camera: V = inverse([basis^T|pos])
    d=v_sub(p,pos); return [dot(d,basis[0]),dot(d,basis[1]),dot(d,basis[2])]
def outside(fr,k,pv): return dot(fr[k],pv)+0.5>0
def solve(Ppos,M,B,Q,fr):
    f30=0.0; last=-1
    for it in range(451):
        pv=view_point(Ppos,M,B); r22=outside(fr,'T',pv); r21=outside(fr,'B',pv)
        r23=-1
        if outside(fr,'L',pv): r23=0
        if outside(fr,'R',pv): r23=1
        qv=view_point(Ppos,M,Q); r20=-1
        if outside(fr,'L',qv): r20=0
        if outside(fr,'R',qv): r20=1
        if not r22 and not r21 and r23<0 and r20<0: break
        if r22:
            f30+=0.01; M=mm(tr(rotx(f30)),M)       # out = Rx^T * M  (0x80327664: B^T*A)
            if not r21 and r23<0 and r20<0: continue
        dolly=r21; d=0
        if not dolly:
            if r23>=0:
                d=r23
                if r20>=0 and r20==(r23^1): dolly=True
            else: d=r20 if r20>=0 else 0
        if not dolly and (d^1)==last: dolly=True
        if dolly: Ppos=v_add(Ppos,v_mul(M[2],0.05))
        else:
            last=d; Ppos=v_add(Ppos,v_mul(M[0],0.2 if d else -0.2))
    return Ppos,M,it
def target(ramp,seat,T,Pbasis,B,fov=33.0,w=832,h=456,wide=True):
    e=ease(ramp); pitch=-20+15*e
    R=rot_xyz(pitch,180.0,0.0)
    Mdes=mm(tr(R),Pbasis)                                  # R^T x P
    O0=[0,14,0]; O1=[0,10,-8]
    O=[O0[i]+(O1[i]-O0[i])*e for i in range(3)]
    Op=vecmat(O,Pbasis)
    Ppos=v_add(v_add(T,Op),v_mul(Mdes[2],40.0))
    Q=v_add(T,[0,10,0])
    lo,hi=(0.85,0.95) if wide else (0.8,0.9)
    mL,mR=(lo,hi) if seat==0 else (hi,lo)
    fr=make_frustum(w,h,fov,mL,mR)
    return solve(Ppos,Mdes,B,Q,fr)
if __name__=='__main__':
    ident=[[1,0,0],[0,1,0],[0,0,1]]
    for seat in (0,1):
        px,pz=2.0,-26.0
        T=MIRROR(seat,[px,-6.0,pz]); P=MIRROR33(seat,ident)
        B=[3.0,3.0,5.0]                                    # some predicted ball point (world); seat-1 would mirror in practice
        for ramp in (0.0,1.0):
            pos,M,it=target(ramp,seat,T,P,B)
            look=[-x for x in M[2]]
            print(f'seat{seat} ramp{ramp}: pos=({pos[0]:.2f},{pos[1]:.2f},{pos[2]:.2f}) look=({look[0]:.3f},{look[1]:.3f},{look[2]:.3f}) iters={it}')
