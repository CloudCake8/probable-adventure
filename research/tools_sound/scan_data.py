import sys,struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
vals=set(int(x,0) for x in sys.argv[1:])
for a,o,z,k in P.SECS:
    if k=='text': continue
    for off in range(0,z-3,4):
        v=struct.unpack_from('>I',P.DATA,o+off)[0]
        if v in vals: print(k,hex(a+off),v)
