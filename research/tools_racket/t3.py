from ppcemu import *
from t2 import mm,tr,rnd,flat,unflat
import random
A=rnd();B=rnd()
# variants for dest layout: 9 packed or 12
for amode in ('p9','p12'):
  for bmode in ('p9','p12'):
    e=Emu()
    def put(addr,M,mode):
        if mode=='p9': e.putv(addr,flat(M))
        else: e.putv(addr,[x for r in M for x in (r+[0.0])])
    put(0x81000000,A,amode); put(0x81000100,B,bmode)
    e.call(0x80327664,(0x81000200,0x81000000,0x81000100))
    raw=e.getv(0x81000200,12)
    out9=unflat(raw[:9]); out12=[raw[0:3],raw[4:7],raw[8:11]]
    for dn,C in (('d9',out9),('d12',out12)):
      for name,ref in (('A*B',mm(A,B)),('B*A',mm(B,A)),('At*B',mm(tr(A),B)),('A*Bt',mm(A,tr(B))),('Bt*At',mm(tr(B),tr(A))),('B*At',mm(B,tr(A))),('Bt*A',mm(tr(B),A)),('At*Bt',mm(tr(A),tr(B)))):
        err=max(abs(C[i][j]-ref[i][j]) for i in range(3) for j in range(3))
        if err<1e-4: print(amode,bmode,dn,name,err)
