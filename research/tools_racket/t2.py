from ppcemu import *
import random, math
def mm(a,b): return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def tr(a): return [[a[j][i] for j in range(3)] for i in range(3)]
def rotz(t): c,s=math.cos(t),math.sin(t); return [[c,s,0],[-s,c,0],[0,0,1]]
def rnd():
    # random rotation
    import itertools
    def rx(t): c,s=math.cos(t),math.sin(t); return [[1,0,0],[0,c,s],[0,-s,c]]
    def ry(t): c,s=math.cos(t),math.sin(t); return [[c,0,-s],[0,1,0],[s,0,c]]
    return mm(mm(rx(random.uniform(-3,3)),ry(random.uniform(-3,3))),rotz(random.uniform(-3,3)))
def flat(m): return [x for r in m for x in r]
def unflat(v): return [v[0:3],v[3:6],v[6:9]]
A=rnd();B=rnd()
for fn in (0x803272f8,):
    e=Emu()
    e.putv(0x81000000,flat(A)); e.putv(0x81000100,flat(B))
    e.call(fn,(0x81000200,0x81000000,0x81000100))
    C=unflat(e.getv(0x81000200,9))
    for name,ref in (('A*B',mm(A,B)),('B*A',mm(B,A)),('At*B',mm(tr(A),B)),('A*Bt',mm(A,tr(B))),('Bt*At',mm(tr(B),tr(A))),('B*At',mm(B,tr(A))),('Bt*A',mm(tr(B),A)),('At*Bt',mm(tr(A),tr(B)))):
        err=max(abs(C[i][j]-ref[i][j]) for i in range(3) for j in range(3))
        if err<1e-4: print(hex(fn),name,err)
# 0x8013c2f0 euler z
for ang in (0,30,60,-45):
    e=Emu()
    e.call(0x8013c2f0,(0x81000000,),(0.0,0.0,ang*256/360))
    print(ang,[round(x,4) for x in e.getv(0x81000000,12)])
