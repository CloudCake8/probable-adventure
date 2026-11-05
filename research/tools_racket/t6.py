from ppcemu import *
import math
for b in ([0,0,1],[0,math.sin(1e-4),math.cos(1e-4)],[0,0.3,0.95]):
    e=Emu()
    a=[0,0,1]
    e.putv(0x81000100,a); e.putv(0x81000200,b)
    e.call(0x80326274,(0x81000000,0x81000100,0x81000200))
    print([round(x,4) for x in e.getv(0x81000000,9)])
