"""List function starts (stwu r1,-N(r1) prologue) in a range. usage: funcs.py lo hi"""
import sys; sys.path.insert(0,r"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as p, struct
lo=int(sys.argv[1],0); hi=int(sys.argv[2],0)
prev=None
starts=[]
for a in range(lo,hi,4):
    w=p.u32(a)
    if (w>>16)==0x9421 and (w&0x8000):
        starts.append(a)
for i,a in enumerate(starts):
    e=starts[i+1] if i+1<len(starts) else hi
    print(f'{a:08x} size {e-a:#x}')
