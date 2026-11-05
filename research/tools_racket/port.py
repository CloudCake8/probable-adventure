"""JS-friendly Python port of the racket pose generator (adapter update 0x80467b4c + pivot 0x80466cf8).
Covers the tracking path (no intercept assist 0x1e8/0x1f0, no table push-out 0x80465244).
verify.py compares it against the interpreted original."""
import math
D2R=math.pi/180; R2D=180/math.pi
def dot(a,b): return a[0]*b[0]+a[1]*b[1]+a[2]*b[2]
def cross(a,b): return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]]
def clamp(x,lo,hi): return lo if x<lo else hi if x>hi else x
def ease(t): return 0.5-0.5*math.cos(math.pi*t)             # 0x80326180(t,1)
def soft_pitch(x):                                           # 0x80325228(x,60,90,70)
    if x<=60: return x
    u=min(1.0,(x-60)/30.0)
    return 60+10*(0.1*u+2.8*u*u-1.9*u**3)
def vm(v,M): return [v[0]*M[0][j]+v[1]*M[1][j]+v[2]*M[2][j] for j in range(3)]
def mmul(A,B): return [[sum(A[i][k]*B[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def shortest_arc(a,b):
    """0x80326274: rotation matrix (row-vector convention, a*M=b)."""
    c=cross(a,b); l=math.sqrt(dot(c,c))
    if l<=1e-6: return [[1,0,0],[0,1,0],[0,0,1]]
    k=[x/l for x in c]; cs=dot(a,b); sn=l
    # Rodrigues, then transpose for row-vector use
    K=[[0,-k[2],k[1]],[k[2],0,-k[0]],[-k[1],k[0],0]]
    R=[[ (1 if i==j else 0)+sn*K[i][j]+(1-cs)*sum(K[i][m]*K[m][j] for m in range(3)) for j in range(3)] for i in range(3)]
    return [[R[j][i] for j in range(3)] for i in range(3)]
def twist_deg(prev,cur):
    """0x80466bc0: roll of the remote about its pointing row (row2) between two ticks, degrees."""
    A=shortest_arc(prev[2],cur[2]); P=mmul(prev,A)           # prev frame carried to cur pointing
    # angle from predicted row1 to cur row1 about predicted row2 (see 0x8032656c)
    r1p=P[1]; r0p=P[0]
    x=dot(cur[1],r1p); y=-dot(cur[1],r0p)
    return math.atan2(y,x)*R2D
class Racket:
    ANCH_A=(-1.0,1.1,4.0)      # 0x807d3608  (yaw frac f=1)
    ANCH_B=(-0.5,1.4,0.3)      # 0x807d3614  (yaw frac f=0)
    SHOULDER=(0.0,4.6,0.0)     # 0x807d3620
    def __init__(s, lefty=False):
        s.lefty=lefty
        s.prev=[[1,0,0],[0,1,0],[0,0,1]]
        s.acc=[0.0,0.0,0.0]
        s.yaw=0.0; s.y17c=0.0; s.y178=0.0; s.y16c=0.0; s.y180=1.0
        s.a188=0.0; s.a184=0.0; s.a18c=0.0; s.a194=0.0
        s.swing=0; s.hand=0; s.lim=0.0; s.cnt=0
    def bounds(s):
        return (-130.0,145.0) if s.lefty else (-145.0,130.0)
    def tick(s, M, headingRate, active, pose_rows=None, pose_pos=(0,0,0), chest=None, assist=0.0):
        """M: 3x3 remote orientation (rows r0,r1,r2=pointing). headingRate: adapter+0xc4 (smoothed remote heading deg).
        active: Participant.counter>=0 (ball live/swing countdown). Returns (pivot, grip, rows)."""
        lo,hi=s.bounds(); cur=M
        # angular-velocity vector of the pointing direction (deg/tick), low-passed 0.5
        c=cross(s.prev[2],cur[2]); L=math.sqrt(dot(c,c))
        if L>0:
            Lc=min(1.0,L); k=math.asin(Lc)*R2D/Lc   # code divides by clamped len
            rv=[x*k for x in c]
        else: rv=c
        s.acc=[a+0.5*(r-a) for a,r in zip(s.acc,rv)]
        f31=twist_deg(s.prev,cur)
        f30=math.sqrt(rv[0]**2+rv[2]**2)
        if cross([s.acc[0],0,s.acc[2]],cur[2])[1]<0: f30=-f30
        yaw0=s.yaw
        if s.swing==0:
            if active:
                s.y17c+=s.acc[1]*1.3; s.yaw=clamp(s.y17c,lo,hi)
                s.y16c=s.yaw-yaw0; s.y178=s.yaw; s.y180=0.0
            else:
                tgt=clamp(headingRate*1.3,lo,hi)
                if s.y16c>=0:
                    s.y16c-=0.4
                    if s.y16c<0: s.y16c=0.0
                else:
                    s.y16c+=0.4
                    if s.y16c>0: s.y16c=0.0
                s.y178=clamp(s.y178+s.y16c,lo,hi)
                s.y180=clamp(s.y180+0.015,0.0,1.0)
                s.yaw=s.y178+ease(s.y180)*(tgt-s.y178); s.y17c=s.yaw
            s.a18c*=0.99
            s.a194=clamp(0.015*f31+0.996*s.a194,-1.0,1.0)
        else:
            s.yaw+=s.acc[1]*1.05
            if s.hand==0: s.yaw=clamp(s.yaw,s.lim,hi)       # 0x168==0: lower bound = 0x1f4
            else: s.yaw=clamp(s.yaw,lo,s.lim)
            s.y17c=s.yaw; s.y16c=s.yaw-yaw0; s.y178=s.yaw; s.y180=0.0
            s.a188+=f31; s.a184+=f30
            s.a18c=s.a18c+0.1*(s.a188-s.a18c)
            s.a194*=0.98
            s.cnt-=1
            if s.cnt<=0: s.swing=0
        pitch=soft_pitch(math.asin(clamp(cur[2][1],-1,1))*R2D)
        A=s.yaw*D2R; B=pitch*D2R
        s1,c1,s2,c2=math.sin(A),math.cos(A),math.sin(B),math.cos(B)
        Mrow=[[s1*s2,-c2,c1*s2],[c1,0.0,-s1],[s1*c2,s2,c1*c2]]            # 0x80466f5c
        th=(s.a194*45.0+s.a18c)*D2R
        ct,st=math.cos(th),math.sin(th)
        # Rz(th)^T * Mrow  (0x80327664)
        R=[[ct*Mrow[0][j]+st*Mrow[1][j] for j in range(3)],[-st*Mrow[0][j]+ct*Mrow[1][j] for j in range(3)],Mrow[2][:]]
        # pivot 0x80466cf8
        f=clamp((90.0+s.yaw)/180.0,0.0,1.0)
        if s.lefty: f=1.0-f
        Bv=[Racket.ANCH_B[i]+(Racket.ANCH_A[i]-Racket.ANCH_B[i])*f for i in range(3)]
        if s.lefty: Bv[0]=-Bv[0]
        sh=list(Racket.SHOULDER)
        if chest is not None:
            k=0.5*(1.0-assist)
            sh=[sh[i]+(chest[i]-sh[i])*k for i in range(3)]
        grip=[sh[i]+Bv[i] for i in range(3)]
        ext=6.2+f*(3.8-6.2)
        pv=[grip[i]+R[2][i]*ext for i in range(3)]
        if pose_rows is None: pose_rows=[[1,0,0],[0,1,0],[0,0,1]]
        gripW=[a+b for a,b in zip(vm(grip,pose_rows),pose_pos)]
        pivW=[a+b for a,b in zip(vm(pv,pose_rows),pose_pos)]
        rowsW=mmul(R,pose_rows)
        s.prev=[r[:] for r in cur]
        return pivW,gripW,rowsW
