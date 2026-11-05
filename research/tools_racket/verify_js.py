import json, math, random, subprocess
import port
from harness import remote_matrix
random.seed(7)
res={}
for lefty in (False,True):
    rk=port.Racket(lefty=lefty); frames=[]; prev=None
    h=0;p=0;r=0;hs=0;H=0
    for i in range(300):
        h+=random.uniform(-6,6)+4*math.sin(i*0.05); p=25*math.sin(i*0.03); r+=random.uniform(-4,4)
        M=remote_matrix(h,p,r)
        hd=math.degrees(math.atan2(M[2][0],M[2][2]))
        d=hd-H
        if d>180:d-=360
        elif d<-180:d+=360
        H+=d
        if H>240:H-=360
        elif H<-240:H+=360
        hs+=max(-20,min(20,0.5*(H-hs)))
        active= (60<i<120) or i>200
        if i==150: rk.swing=2;rk.hand=1;rk.lim=30;rk.cnt=45;sw=1
        else: sw=0
        chest=[0,4.8,-0.24]
        pv,gr,rows=rk.tick(M,hs,active,pose_rows=None,pose_pos=(0,-6,-26),chest=chest)
        tw=port.twist_deg(prev,M) if prev else 0.0
        frames.append(dict(row2=M[2],twist=port.twist_deg(rk_prev,M) if False else None,M=M,hs=hs,active=active,sw=sw,pivot=pv,rows=rows,yaw=rk.yaw))
        prev=M
    res['L' if lefty else 'R']=frames
json.dump(res,open('js_trace.json','w'))
