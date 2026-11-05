from ppcemu import *
import math
from t5 import I, rot_rows, flat
d=math.radians(5)
prev=I; cur=rot_rows(I,0,1,d)
e=Emu()
e.putv(0x81000000,flat(prev)); e.putv(0x81000100,flat(cur))
e.call(0x80466bc0,(0x81002000,0x81000000,0x81000100))
sp=e.r[1]
print(hex(sp))
# stack frame of callee is below; the frame of 0x80466bc0 was sp0-0x90
base=0x817f0000-0x90
for off in (0x5c,0x38,0x14,0x20,0x2c,0x44,0x50,8):
    print(hex(off), e.getv(base+off,3))
