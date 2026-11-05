"""Correct renderer for Sp2Snd table-tennis SFX. Run: py -3 render.py"""
import struct,json,wave,os,sys,math
import numpy as np
sys.path.insert(0,"D:/projects/claude's wii sports plan/tools")
import brsar
import rbnk2
from rbnk2 import d
import rseq_dis as R   # for BASE helpers
import wavedec
OUT=os.path.dirname(os.path.abspath(__file__))
B=brsar.BRSAR(d)
BANK_RWAR=12277344
FACE_RWAR=15106880
def getwave(i,rwar=BANK_RWAR):
    wavedec.RWAR=rwar
    return wavedec.wave(i)
class Rand:
    def __init__(s,lo,hi): s.lo,s.hi=lo,hi
def s8(v): return v-256 if v>=128 else v
def run_seq(start):
    """Deterministic NW4R rseq walk -> list of note events (time_ticks, prog, key, vel, transpose, bend, trackvol, expr)"""
    vars_={}; notes=[]; tracks=[dict(pc=start,t=0,prog=0,tr=Rand(0,0),bend=0,vol=127,expr=127,nw=True)]
    i=0
    def val(tr,p,pre,kind):
        # returns (value, newpc)
        if pre==0xa0:
            lo,hi=struct.unpack_from('>hh',d,R.BASE+p); return Rand(lo,hi),p+4
        if pre==0xa1:
            return vars_[R.u8(p)],p+1
        return None,p
    while i<len(tracks):
        T=tracks[i];i+=1;p=T['pc']
        while True:
            c=R.u8(p);p+=1;pre=None
            while 0xa0<=c<=0xa5: pre=c;c=R.u8(p);p+=1
            if c<0x80:
                vel=R.u8(p);p+=1
                v,p=val(T,p,pre,'len')
                if v is None: v,p=R.vlq(p)
                ln=v
                notes.append(dict(tick=T['t'],prog=T['prog'],key=c,vel=vel,len=ln,transpose=T['tr'],bend=T['bend'],trackvol=T['vol'],expr=T['expr']))
                if T['nw']: T['t']+=ln
            elif c in(0x80,0x81):
                v,p=val(T,p,pre,'')
                if v is None: v,p=R.vlq(p)
                if c==0x80: T['t']+=v
                else: T['prog']=v
            elif c==0x88:
                n=R.u8(p);o=(R.u8(p+1)<<16)|(R.u8(p+2)<<8)|R.u8(p+3);p+=4
                tracks.append(dict(pc=o,t=T['t'],prog=0,tr=Rand(0,0),bend=0,vol=127,expr=127,nw=True))
            elif c==0xf0:
                op=R.u8(p);vi=R.u8(p+1);p+=2
                v,p=val(T,p,pre,'')
                if v is None: v=struct.unpack_from('>h',d,R.BASE+p)[0];p+=2
                assert op==0x80,op
                vars_[vi]=v
            elif c in(0xc1,0xc3,0xc4,0xd8,0xc0,0xc5,0xd5):
                v,p=val(T,p,pre,'')
                if v is None: v=R.u8(p);p+=1
                if c==0xc3: T['tr']=v
                elif c==0xc4: T['bend']=v if isinstance(v,Rand) else s8(v)
                elif c==0xc1: T['vol']=v
                elif c==0xd5: T['expr']=v
                elif c==0xd8: T.setdefault('other',[]).append(('lpf?',v))
                else: T.setdefault('other',[]).append((hex(c),v))
            elif c==0xff: break
            else: raise Exception('unhandled cmd %x at %d'%(c,p))
    return notes
def mid(v,mode): 
    if isinstance(v,Rand): return {'canon':None,'lo':v.lo,'hi':v.hi,'mid':(v.lo+v.hi)//2}[mode]
    return v
def resolve(note,mode='canon'):
    tr=note['transpose']; bend=note['bend']; tv=note['trackvol']
    trs=tr.lo if isinstance(tr,Rand) else tr           # canonical: lowest transposition = native pitch
    bnd=0 if isinstance(bend,Rand) else bend            # canonical: random bend centred on 0
    tvv=(tv.lo+tv.hi)//2 if isinstance(tv,Rand) else tv
    return trs,bnd,tvv
# --- resampling (Catmull-Rom) from native rate by ratio => output at native rate
def play(x,ratio):
    if abs(ratio-1)<1e-9: return x.copy()
    n=int((len(x)-1)/ratio)
    t=np.arange(n)*ratio; i=np.floor(t).astype(int); f=t-i
    xp=np.concatenate([[x[0]],x,[x[-1],x[-1]]]); j=i+1
    p0,p1,p2,p3=xp[j-1],xp[j],xp[j+1],xp[j+2]
    return 0.5*((2*p1)+(-p0+p2)*f+(2*p0-5*p1+4*p2-p3)*f**2+(-p0+3*p1-3*p2+p3)*f**3)
def rate_conv(x,r_from,r_to):
    if r_from==r_to:return x
    return play(x,r_from/r_to)  # reading faster/slower
def sr(x): return x
SND={s['name']:s for s in B.sounds}
def sound_voices(name,mode='canon'):
    s=SND[name]; vols=s['volume']; v=[]
    if s['type']=='sequence':
        assert s['bank_id']==13
        for n in run_seq(s['seq_label_offset']):
            inst=rbnk2.lookup(n['prog'],n['key'],n['vel'])
            trs,bnd,tvol=resolve(n)
            semis=n['key']+trs-inst['orig_key']+bnd*2/127   # bend range default 2 semitones
            ratio=2**(semis/12)*inst['tune']
            g=(vols/127)*(inst['vol']/127)*(n['vel']/127)**2*(tvol/127)**2
            v.append(dict(src='bank',wave=inst['wave'],rwar=BANK_RWAR,key=n['key'],prog=n['prog'],vel=n['vel'],transpose=trs,bend=bnd,orig_key=inst['orig_key'],
                          ratio=ratio,gain=g,start_s=n['tick']/(120*48/60.0)/1.0 if False else n['tick']*60/(120*48),
                          inst_vol=inst['vol'],track_vol=tvol,sound_vol=vols,release=inst['R']))
    else:
        # wave sound: RWSD note info; pitch 1.0, orig key 60, note vol 127/..., pan center
        fd,_=B.file_bytes(s['file_id'])
        D=struct.unpack_from('>I',fd,0x10)[0]+8
        o=brsar.table(fd,D,D)[s['sub_index']]
        nt=brsar.ref(fd,o+0x10,D); no=brsar.table(fd,nt,D)[0]
        wv=struct.unpack_from('>i',fd,no)[0]
        pitch=struct.unpack_from('>f',fd,o+0x18)[0]
        nvol=fd[no+13]
        v.append(dict(src='rwsd',wave=wv,rwar=FACE_RWAR,ratio=pitch,gain=(vols/127)*(nvol/127),start_s=0.0,sound_vol=vols,note_vol=nvol,rwsd_pitch=pitch))
    return v
def mix(voices):
    rate=None;parts=[]
    for v in voices:
        w=getwave(v['wave'],v['rwar'])
        assert w['loop']==0 and len(w['ch'])==1,(v,w['loop'],len(w['ch']))
        v['native_rate']=w['rate']; v['native_len']=len(w['ch'][0])
    rate=max(v['native_rate'] for v in voices)
    # output rate: rate of earliest voice (keeps its native rate)
    rate=voices[0]['native_rate']
    total=0;sigs=[]
    for v in voices:
        w=getwave(v['wave'],v['rwar'])
        x=w['ch'][0]/32768.0
        # pitch ratio applies to playback speed in the native-rate domain, then convert to out rate
        y=play(x,v['ratio']*w['rate']/rate)
        off=int(round(v['start_s']*rate))
        sigs.append((off,y*v['gain'])); total=max(total,off+len(y))
    out=np.zeros(total)
    for off,y in sigs: out[off:off+len(y)]+=y
    return out,rate
def trim(x,rate,thr_db=-60):
    pk=np.abs(x).max()
    if pk==0:return x
    idx=np.nonzero(np.abs(x)>pk*10**(thr_db/20))[0]
    a=max(0,idx[0]-int(0.001*rate)); b=min(len(x),idx[-1]+int(0.005*rate))
    y=x[a:b].copy()
    f=int(0.004*rate)  # tiny fade-out
    if len(y)>f: y[-f:]*=np.linspace(1,0,f)
    return y,a/rate
def save(path,x,rate,scale):
    y=np.clip(x*scale,-1,1)
    pcm=np.round(y*32767).astype('<i2')
    with wave.open(path,'wb') as f:
        f.setnchannels(1);f.setsampwidth(2);f.setframerate(rate);f.writeframes(pcm.tobytes())
