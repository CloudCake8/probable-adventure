"""Camera RE helper (read-only on inputs). Usage: py -3 -B cam.py <cmd> args
 fn ADDR            dump whole function containing ADDR (heuristic bounds)
 d START END        dump range with bl-target + float annotations
 xr LO HI           xrefs to data range
 callers ADDR       bl callers of function ADDR
 f32 ADDR [N]       print N floats at ADDR
"""
import sys, struct, re
sys.dont_write_bytecode = True
sys.path.insert(0, r"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
from ppc_probe import read, u32, MD, broadway, SECS, DATA

def f32(a): return struct.unpack('>f', read(a,4))[0]
def func_bounds(a):
    s=a
    while s>0x80004000:
        w=u32(s)
        if w==0x9421 << 16 | (w & 0xffff) and (w>>16)==0x9421: # stwu r1
            # check mflr nearby before
            break
        s-=4
    # back up over mflr just before? stwu is usually first; mflr may precede
    if u32(s-4)>>16==0x7c08 : s-=4
    e=a
    while True:
        e+=4
        if u32(e)==0x4e800020:
            # blr; end if next is not continued (accept first blr after a)
            # find last blr of function: next word begins new function (stwu or mflr) 
            nxt=u32(e+4)
            if (nxt>>16)==0x9421 or nxt==0x7c0802a6 or nxt==0: return s,e+4
        if e-a>0x4000: return s,e
def dump(start,end,labels=True):
    for a,z,m,op in MD.disasm_lite(read(start,end-start),start):
        w=u32(a); m,op=broadway(w,m,op); note=''
        mm=re.search(r'(-?(?:0x[0-9a-f]+|[0-9]+))\(r(2|13)\)',op)
        if mm:
            ad=({'2':0x806fe080,'13':0x806f8120}[mm[2]]+int(mm[1],0))&0xffffffff
            v=read(ad,4)
            if v: note=f' ; [{ad:08x}] {v.hex()} f={struct.unpack(">f",v)[0]:.9g} i={struct.unpack(">i",v)[0]}'
        print(f'{a:08x}: {w:08x}  {m:9} {op}{note}')
if __name__=='__main__':
    c=sys.argv[1]; ar=[int(x,0) for x in sys.argv[2:]]
    if c=='fn':
        s,e=func_bounds(ar[0]); print(f'; func {s:08x}..{e:08x}'); dump(s,e)
    elif c=='d': dump(ar[0],ar[1])
    elif c=='xr': P.xrefs(ar[0],ar[1])
    elif c=='callers': P.calls(ar[0],ar[0]+4)
    elif c=='f32':
        n=ar[1] if len(ar)>1 else 1
        for i in range(n): print(f'{ar[0]+4*i:08x} {f32(ar[0]+4*i):.9g}')
