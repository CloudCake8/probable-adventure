from ppcemu import *
import math
for ang in (0.1,-0.1):
    e=Emu()
    cur1=[-math.sin(ang),math.cos(ang),0]  # cur row1
    pred1=[0,1,0]; pred0=[1,0,0]
    e.putv(0x81000000,cur1); e.putv(0x81000100,pred1); e.putv(0x81000200,pred0)
    _,r=e.call(0x8032656c,(0x81000000,0x81000100,0x81000200))
    print(ang,r)
