# find loads/stores with a given displacement in a range: scan_off.py lo hi disp
import sys,struct
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
lo,hi,disp=int(sys.argv[1],0),int(sys.argv[2],0),int(sys.argv[3],0)
names={32:'lwz',33:'lwzu',34:'lbz',36:'stw',37:'stwu',38:'stb',40:'lhz',44:'sth',48:'lfs',50:'lfd',52:'stfs',54:'stfd',42:'lha',46:'lmw',47:'stmw'}
for a in range(lo,hi,4):
    w=P.u32(a); op=w>>26
    if op in names and P.s16(w)==disp:
        print(f'{a:08x} {names[op]} r{w>>21&31}, {disp:#x}(r{w>>16&31})')
