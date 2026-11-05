from harness import *
import port, random, math
def cmp(a,b): return max(abs(x-y) for x,y in zip(a,b))
def run(hand, lefty=False, frames=140, seed=3):
    rig=Rig(lefty=lefty, active=True); e=rig.e
    rk=port.Racket(lefty=lefty)
    random.seed(seed); h=-60.0 if hand==1 else 60.0; hs=0.0; worst=0
    for i in range(frames):
        if i==30:
            lim=30.0 if hand==1 else -30.0
            e.wr(AD+0x190,2,4); e.wr(AD+0x168,hand,4); e.putf(AD+0x1f4,lim); e.wr(AD+0x1a8,45,4)
            rk.swing=2; rk.hand=hand; rk.lim=lim; rk.cnt=45
        h+= (9 if hand==1 else -9)*(1 if 30<=i<70 else 0.2)+random.uniform(-1,1)
        M=remote_matrix(h,10*math.sin(i*0.1),0.5*i if 30<=i<70 else 0)
        hd=math.degrees(math.atan2(M[2][0],M[2][2])); hs+=max(-20,min(20,0.5*(hd-hs)))
        e.putf(AD+0xc4,hs)
        rig.set_remote(M); o=rig.tick()
        pv,gr,rows=rk.tick(M,hs,True)
        d=max(cmp(o['pivot'],pv),cmp(o['R'],[x for r_ in rows for x in r_]))
        worst=max(worst,d)
        if i in (29,31,50,69,75,76,100) : print(i,'yaw',round(o['yaw'],3),round(rk.yaw,3),'tw',[round(x,3) for x in o['twist']],'d',round(d,5))
    print('worst',worst)
run(1); run(0); run(1,True)
