"""Find loads/stores with given displacement in range. usage: memop.py lo hi disp [rA]"""
import sys; sys.path.insert(0,r"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as p
lo,hi,disp=int(sys.argv[1],0),int(sys.argv[2],0),int(sys.argv[3],0)
ra=int(sys.argv[4]) if len(sys.argv)>4 else None
names={32:'lwz',33:'lwzu',34:'lbz',36:'stw',37:'stwu',38:'stb',40:'lhz',44:'sth',48:'lfs',50:'lfd',52:'stfs',54:'stfd',14:'addi',42:'lha'}
for a in range(lo,hi,4):
    w=p.u32(a); op=w>>26
    if op in names and p.s16(w)==disp and (ra is None or (w>>16&31)==ra):
        print(f'{a:08x} {names[op]} r/f{(w>>21)&31}, {disp:#x}(r{(w>>16)&31})')
