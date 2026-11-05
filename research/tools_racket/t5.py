from ppcemu import *
import math
def flat(m): return [x for r in m for x in r]
def run_twist(prev,cur):
    e=Emu()
    e.putv(0x81000000,flat(prev)); e.putv(0x81000100,flat(cur))
    _,r=e.call(0x80466bc0,(0x81002000,0x81000000,0x81000100))
    return r
I=[[1,0,0],[0,1,0],[0,0,1]]
def rot_rows(m,i,j,ang):
    c,s=math.cos(ang),math.sin(ang)
    m=[r[:] for r in m]
    a=m[i];b=m[j]
    m[i]=[c*x+s*y for x,y in zip(a,b)]
    m[j]=[-s*x+c*y for x,y in zip(a,b)]
    return m
d=math.radians(5)
print('twist about row2 (rows0,1 rotate):', run_twist(I,rot_rows(I,0,1,d)), run_twist(I,rot_rows(I,0,1,-d)))
print('rows1,2 rotate (about row0):', run_twist(I,rot_rows(I,1,2,d)))
print('rows0,2 rotate (about row1):', run_twist(I,rot_rows(I,0,2,d)))
# with 30deg pitch background
base=rot_rows(I,1,2,math.radians(30))
print('base pitched; twist about row2:', run_twist(base,rot_rows(base,0,1,d)))
