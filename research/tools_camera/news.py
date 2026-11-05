import sys; sys.path.insert(0,'.')
from cam import *
import struct
def bltarget(a):
    w=u32(a)
    if w>>26==18 and w&1:
        d=w&0x03fffffc
        if d&0x02000000: d-=0x04000000
        return (a+d)&0xffffffff
for a in range(0x80450000,0x80482000,4):
    t=bltarget(a)
    if t in (0x801c1c48,0x801c1c60):
        # find li r3 before
        sz=None
        for b in range(a-4,a-40,-4):
            w=u32(b)
            if w>>16==0x3860: sz=w&0xffff; break
            if w>>16==0x3c60: sz=None
        # ctor: next bl within 6 insns
        ct=None
        for b in range(a+4,a+40,4):
            tt=bltarget(b)
            if tt: ct=tt;break
        print(f'{a:08x} size={sz if sz is None else hex(sz)} ctor={ct and hex(ct)}')
