from ppcemu import *
import math
d=0.1
e=Emu()
# matrix M at A: row1 = c = (0,0,-1) at A+0xc
A=0x81000000
e.putv(A,[1,0,0, 0,0,-1, 0,0,0])
cur1=[-math.sin(d),math.cos(d),0]; pred1=[0,1,0]
e.putv(0x81000100,cur1); e.putv(0x81000200,pred1)
_,r=e.call(0x8032656c,(0x81000100,0x81000200,A+0))
print(r)
e=Emu()
e.putv(A+0xc-0xc,[1,0,0, 0,0,-1, 0,0,0])
e.putv(0x81000100,cur1); e.putv(0x81000200,pred1)
# check 0x8032802c normalize
e.putv(0x81000300,[0,0,3.0])
_,r2=e.call(0x8032802c,(0x81000300,0x81000300))
print(r2, e.getv(0x81000300,3))
