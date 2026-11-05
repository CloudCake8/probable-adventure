from ppcemu import *
import math
e=Emu()
for deg in (0,30,90,135,-45,200):
    idx=deg*256/360
    e.call(0x8013bc70,(0x81000000,0x81000010),(idx,))
    print(deg, e.getf(0x81000000), e.getf(0x81000010), math.sin(math.radians(deg)), math.cos(math.radians(deg)))
# 0x80327114 test
e=Emu()
M=[1,2,3,4,5,6,7,8,9]; v=[1,10,100]
e.putv(0x81000000,M); e.putv(0x81000100,v)
e.call(0x80327114,(0x81000200,0x81000000,0x81000100))
print(e.getv(0x81000200,3))
