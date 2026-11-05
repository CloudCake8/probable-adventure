import sys; sys.path.insert(0,'.')
from cam import *
lo,hi=0x806d8f00,0x806dc000
d=read(lo,hi-lo)
i=0;out=[]
while i<len(d):
    j=i
    while j<len(d) and d[j]!=0: j+=1
    s=d[i:j]
    if len(s)>=4 and any(b>=0x80 for b in s):
        try:
            t=s.decode('cp932')
            out.append((lo+i,t))
        except: pass
    i=j+1
for a,t in out: print(f'{a:08x} {t}')
