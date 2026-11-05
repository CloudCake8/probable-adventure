import sys,io,contextlib
sys.path.insert(0,"D:/projects/claude's wii sports plan/pingpong/tools")
import ppc_probe as P
for s in sys.argv[1:]:
    a=int(s,0)
    print('=====',hex(a))
    buf=io.StringIO()
    with contextlib.redirect_stdout(buf): P.dump(a-0x50,a+0x10)
    for l in buf.getvalue().splitlines(): print(l[:112])
