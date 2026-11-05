"""Run the real adapter update 0x80467b4c from main.dol in the PPC interpreter with synthetic memory."""
from ppcemu import *
import math
AD=0x81100000; PART=0x81200000; AVA=0x81300000
class Rig:
    def __init__(s, lefty=False, active=False, chest=None, side=0):
        e=s.e=Emu()
        e.lefty=lefty; e.active=active
        e.call(0x80468e0c); e.call(0x8045d954)
        e.putv(AD+0x1c,[1,0,0,0,1,0,0,0,1]); e.putv(AD+0x10,[0,0,0])
        e.wr(AD+8,PART,4); e.wr(PART+0x84,AVA,4); e.wr(PART+0x28,side,4)
        e.putf(AD+0x180,1.0)
        e.putv(AD+0x40,[1,0,0,0,1,0,0,0,1]); e.putv(AD+0x64,[1,0,0,0,1,0,0,0,1]); e.putv(AD+0x88,[1,0,0,0,1,0,0,0,1])
        e.putf(AD+0xac,0.5)
        # ring pointer
        e.wr(AD+0x6d0,AD+0x220,4)
        if chest is not None:
            e.wr(AVA+0x34,1,4); e.putv(AVA+0xf4,[chest[0]]); e.putf(AVA+0x104,chest[1]); e.putf(AVA+0x114,chest[2])
        def h_lefty(em): em.r[3]=1 if em.lefty else 0
        def h_active(em): em.r[3]=1 if em.active else 0
        def h_zero(em): em.r[3]=0
        def h_acos(em): em.f[1]=math.acos(max(-1,min(1,em.f[1])))
        def h_asin(em): em.f[1]=math.asin(max(-1,min(1,em.f[1])))
        e.hooks[0x8045e938]=h_lefty; e.hooks[0x8045e8b4]=h_active
        e.hooks[0x80465764]=h_zero; e.hooks[0x80465244]=h_zero
        e.hooks[0x80016df8]=h_acos; e.hooks[0x80016dfc]=h_asin
    def set_remote(s, M, ctrl_yaw=None):
        e=s.e
        old=e.getv(AD+0x40,9)
        e.putv(AD+0x64,old); e.putv(AD+0x40,[x for r in M for x in r])
    def tick(s, t=1.0):
        e=s.e
        e.call(0x80467b4c,(AD,),(t,))
        return dict(yaw=e.getf(AD+0x170), pivot=e.getv(AD+0xfc,3), grip=e.getv(AD+0x12c,3), R=e.getv(AD+0x108,9), twist=(e.getf(AD+0x194),e.getf(AD+0x18c)), M88=e.getv(AD+0x88,9))
def rotz_rows(p, ang):
    pass
def remote_matrix(heading_deg, pitch_deg, roll_deg=0.0):
    """rows: r2 = pointing dir (sin h cos p, sin p, cos h cos p), r0/r1 by roll about r2; r1 up-ish."""
    h=math.radians(heading_deg); p=math.radians(pitch_deg); r=math.radians(roll_deg)
    f=[math.sin(h)*math.cos(p), math.sin(p), math.cos(h)*math.cos(p)]
    up0=[-math.sin(h)*math.sin(p), math.cos(p), -math.cos(h)*math.sin(p)]   # up perpendicular
    right=[math.cos(h),0.0,-math.sin(h)]
    # rows (r0,r1,r2) = (right', up', f) with roll
    r0=[math.cos(r)*right[i]+math.sin(r)*up0[i] for i in range(3)]
    r1=[-math.sin(r)*right[i]+math.cos(r)*up0[i] for i in range(3)]
    return [r0,r1,f]
if __name__=='__main__':
    rig=Rig()
    for i in range(5):
        rig.set_remote(remote_matrix(0,0))
        print(rig.tick())
