import sys,struct
from ppcemu import P
lo=int(sys.argv[1],0);hi=int(sys.argv[2],0);disp=int(sys.argv[3],0)
for a,o,z,k in P.SECS:
    if k!='text': continue
    for off in range(0,z,4):
        ad=a+off
        if not(lo<=ad<hi): continue
        w=struct.unpack_from('>I',P.DATA,o+off)[0]
        op=w>>26
        if op in (36,37,52,53,32,48,34,38,40,44) and (w&0xffff)==disp:
            print(hex(ad),{36:'stw',37:'stwu',52:'stfs',53:'stfsu',32:'lwz',48:'lfs',34:'lbz',38:'stb',40:'lhz',44:'sth'}[op],'r%d'%((w>>21)&31),'r%d'%((w>>16)&31))
