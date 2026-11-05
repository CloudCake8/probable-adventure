import pickle,bisect,sys
callers=pickle.load(open('callers.pkl','rb'))
MAP="C:/Users/khangai/AppData/Local/Temp/claude/b2b187eac693e308/3ea1bec7-8c4c-4679-a8d3-c1a57740f3fc/scratchpad/rc/repo/projects/wsr/MAP.txt"
starts=sorted(int(l.split()[0],16) for l in open(MAP) if l.strip())
def fn(a): 
    i=bisect.bisect_right(starts,a)-1; return starts[i]
seeds=[int(x,16) for x in sys.argv[2:]]; depth=int(sys.argv[1])
seen={s:0 for s in seeds}; front=list(seeds)
for d in range(1,depth+1):
    nf=[]
    for t in front:
        for c in callers.get(t,[]):
            f=fn(c)
            if f not in seen: seen[f]=d; nf.append(f)
    front=nf
for f,d in sorted(seen.items()):
    if 0x80450000<=f<0x8047c000: print(f'{f:08x} depth={d}')
