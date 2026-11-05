from harness import *
import port, random, math
def cmp(a,b): return max(abs(x-y) for x,y in zip(a,b))
def seq(frames, lefty=False, active=False, seed=1):
    rig=Rig(lefty=lefty, active=active)
    rk=port.Racket(lefty=lefty)
    random.seed(seed)
    worst=0
    h=0.0;p=0.0;r=0.0; hs=0.0
    for i in range(frames):
        h+= random.uniform(-4,5)*(1 if i<frames//2 else -1)+ (3*math.sin(i*0.07)); p=20*math.sin(i*0.031)+random.uniform(-0.5,0.5); r+=random.uniform(-3,3)
        M=remote_matrix(h,p,r)
        # emulate remote heading filter (adapter+0xc4): use heading of row2 smoothed trivially
        hd=math.degrees(math.atan2(M[2][0],M[2][2]))
        hs+= max(-20,min(20,0.5*(hd-hs)))
        rig.e.putf(AD+0xc4,hs)
        rig.set_remote(M)
        o=rig.tick()
        pv,gr,rows=rk.tick(M,hs,active)
        d=max(cmp(o['pivot'],pv),cmp(o['R'],[x for r_ in rows for x in r_]),abs(o['yaw']-rk.yaw))
        worst=max(worst,d)
        if i%40==0 or d>1e-2: print(i,'yaw',round(o['yaw'],3),round(rk.yaw,3),'d',round(d,5))
    print('worst',worst)
for lefty in (False,True):
  for active in (False,True):
    print('lefty',lefty,'active',active); seq(200,lefty,active)
