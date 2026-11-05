import sys,struct,collections
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo,hi=int(sys.argv[1],0),int(sys.argv[2],0)
for a,o,z,k in P.SECS:
    if k!='text': continue
    for off in range(0,z,4):
        w=struct.unpack_from('>I',P.DATA,o+off)[0]
        op=w>>26
        if op==14 and (w>>16&31)==0:  # li
            v=P.s16(w)
            if lo<=v<=hi: print(f'{a+off:08x} li r{w>>21&31}, {v}')
