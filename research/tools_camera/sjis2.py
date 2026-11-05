import sys,re; sys.path.insert(0,'.')
from cam import *
lo,hi=0x806d8f00,0x806dc400
d=read(lo,hi-lo)
# find sequences of valid sjis double-byte chars or ascii of length>=4
pat=re.compile(rb'(?:[\x81-\x9f\xe0-\xea][\x40-\x7e\x80-\xfc]|[\x20-\x7e]){4,}')
for m in pat.finditer(d):
    s=m.group()
    try: t=s.decode('cp932')
    except: continue
    if any(ord(c)>0x3000 for c in t):
        print(f'{lo+m.start():08x} {t}')
