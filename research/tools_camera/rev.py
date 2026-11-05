import sys; sys.path.insert(0,'.')
from cam import *
import struct
# build global bl graph over text sections
text=[(a,o,z) for a,o,z,k in SECS if k=='text']
callers={}
for a,o,z in text:
    for off in range(0,z,4):
        w=struct.unpack_from('>I',DATA,o+off)[0]
        if w>>26==18 and w&1:
            d=w&0x03fffffc
            if d&0x02000000: d-=0x04000000
            t=(a+off+d)&0xffffffff
            callers.setdefault(t,[]).append(a+off)
import pickle; pickle.dump(callers,open('callers.pkl','wb'))
print(len(callers))
