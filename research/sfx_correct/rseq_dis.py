import struct,json,sys
ROOT="D:/projects/claude's wii sports plan/"
d=open(ROOT+'unpacked/Sound/Static/Sp2Snd.brsar','rb').read()
BASE=12236300
END=12236256+4800
def u8(p): return d[BASE+p]
def vlq(p):
    v=0
    while True:
        b=u8(p);p+=1;v=(v<<7)|(b&0x7f)
        if not b&0x80:return v,p
def dis(p,maxn=80,seen=None):
    out=[];n=0
    while n<maxn:
        n+=1
        st=p;c=u8(p);p+=1;pre=None
        while 0xa0<=c<=0xa5:
            pre=c;c=u8(p);p+=1
        s=''
        def last():
            nonlocal p
            if pre==0xa0:
                lo,hi=struct.unpack_from('>hh',d,BASE+p);p+=4;return f'rand({lo},{hi})'
            if pre==0xa1:
                v=u8(p);p+=1;return f'var{v}'
            return None
        if c<0x80:
            k=u8(p);p+=1
            l=last()
            if l is None:
                l,p=vlq(p)
            s=f'NOTE key={c} vel={k} len={l}'
        elif c in(0x80,0x81):
            l=last()
            if l is None:l,p=vlq(p)
            s=f'{"WAIT" if c==0x80 else "PROG"} {l}'
        elif c==0x88:
            t=u8(p);o=(u8(p+1)<<16)|(u8(p+2)<<8)|u8(p+3);p+=4;s=f'OPEN_TRACK {t} @{o}'
        elif c in(0x89,0x8a):
            o=(u8(p)<<16)|(u8(p+1)<<8)|u8(p+2);p+=3;s=f'{"JUMP" if c==0x89 else "CALL"} @{o}'
        elif c in(0xe0,0xe1,0xe3,0xfe):
            l=last()
            if l is None:
                l=struct.unpack_from('>h',d,BASE+p)[0];p+=2
            s=f'{c:02x} {l}'
        elif c==0xf0:
            op=u8(p);vi=u8(p+1);p+=2
            l=last()
            if l is None:
                l=struct.unpack_from('>h',d,BASE+p)[0];p+=2
            s=f'VAR op={op:02x} var{vi} {l}'
        elif c in(0xfc,0xfd,0xff,0xfb):
            s={0xfc:'LOOP_END',0xfd:'RET',0xff:'FIN',0xfb:'ENV_RESET'}[c]
        else:
            l=last()
            if l is None:
                l=u8(p);p+=1
            s=f'{c:02x} {l}'
        if pre in(0xa2,0xa3,0xa4,0xa5): s+=f' [pre {pre:x}]'
        out.append((st,s))
        if c==0xff or c==0xfd or c==0x89: break
    return out,p
if __name__=='__main__':
    m=json.load(open(ROOT+'assets/manifest_sounds.json'))
    a=[x for x in m if 'Sp2Snd' in x['brsar']][0]
    want=sys.argv[1:]
    for s in a['sounds']:
        if s['type']=='sequence' and s['bank']==13 and s['name'] in want:
            print('==',s['name'],'start',s['start'],'vol',s['volume'])
            todo=[s['start']];done=set()
            while todo:
                st=todo.pop(0)
                if st in done:continue
                done.add(st)
                ins,_=dis(st)
                for pos,t in ins:
                    print(f'  {pos:5d} {t}')
                    if t.startswith('OPEN_TRACK'):todo.append(int(t.split('@')[1]))
                    if t.startswith(('JUMP','CALL')):todo.append(int(t.split('@')[1]))
