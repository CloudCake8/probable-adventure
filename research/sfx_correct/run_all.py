import os,json,wave,shutil
import numpy as np
from render import *
NAMES=[]
for suf in ['','_CSPK','_SLIPPER','_SLIPPER_CSPK']:
    for k in ['NORMAL','DRIVE','CUT','SMASH']: NAMES.append(f'SE_PNG_BALL_HIT_{k}{suf}')
NAMES+=['SE_PNG_BALL_HIT_FACE']
NAMES+=[f'SE_PNG_BALL_BOUND_{k}' for k in ['NORMAL','WOOD','NET','SMASH','GROUND','MAT','LAWN','WATER']]
NAMES+=['SE_PNG_SWING_S','SE_PNG_SWING_L','SE_PNG_SMASH_SHOT','SE_PNG_JUMP_SWING_L','SE_PNG_THROW_UP','SE_PNG_THROW_UP_CSPK','SE_PNG_WHISTLE_START','SE_PNG_WHISTLE_MISS','SE_PNG_WHISTLE_END']
res={}
for n in NAMES:
    v=sound_voices(n); x,rate=mix(v)
    res[n]=(v,x,rate)
# common scale: loudest effect peaks at 0.95 (keeps relative game levels)
pk=max(np.abs(x).max() for v,x,r in res.values())
K=0.95/pk
print('common scale',K,'peak',pk)
os.makedirs(OUT+'/wav',exist_ok=True)
man={'format':'mono 16-bit PCM, native wave rate; pitch/bend baked into waveform (resampled), gain baked incl. common_scale','common_scale':K,'effects':{}}
def stats(x,rate):
    X=np.abs(np.fft.rfft(x*np.hanning(len(x))));f=np.fft.rfftfreq(len(x),1/rate)
    cen=(X*f).sum()/X.sum()
    env=np.abs(x);pk=env.max();sm=np.convolve(env,np.ones(int(0.002*rate))/int(0.002*rate),'same')
    t40=np.nonzero(sm>pk*0.01)[0][-1]/rate
    return {'duration_s':round(len(x)/rate,4),'spectral_centroid_hz':round(float(cen)),'t_above_-40dB_s':round(float(t40),4),'peak':round(float(np.abs(x).max()*K),3)}
done={}
for n,(v,x,rate) in res.items():
    y,lead=trim(x,rate)
    save(f'{OUT}/wav/{n}.wav',y,rate,K)
    man['effects'][n]=dict(file=f'wav/{n}.wav',sample_rate=rate,
        voices=[{k:(round(val,5) if isinstance(val,float) else val) for k,val in vv.items() if k not in('rwar',)} | {'playback_rate_ratio':round(vv['ratio'],5),'gain_rel':round(vv['gain'],4),'gain_in_file':round(vv['gain']*K,4)} for vv in v],
        **stats(y,rate))
    for vv in man['effects'][n]['voices']: vv.pop('ratio',None); vv.pop('gain',None)
# random ranges from the sequences (sounds' in-game variation not baked in)
from render import run_seq
for n in NAMES:
    s=SND[n]
    if s['type']!='sequence':continue
    rr=set()
    for nt in run_seq(s['seq_label_offset']):
        for k in('transpose','bend','trackvol'):
            if isinstance(nt[k],Rand): rr.add((k,nt[k].lo,nt[k].hi))
    man['effects'][n]['in_game_random']=[dict(param={'transpose':'semitones (c3)','bend':'pitch bend s8, x2/127 semitones (c4)','trackvol':'track volume c1'}[k],lo=lo,hi=hi) for k,lo,hi in sorted(rr)]
json.dump(man,open(OUT+'/manifest.json','w'),indent=1)
for n,e in man['effects'].items():
    print(n.ljust(38),[ (vv['wave'],vv['playback_rate_ratio'],vv['gain_in_file']) for vv in e['voices']],e['sample_rate'],e['duration_s'],e['spectral_centroid_hz'],e['t_above_-40dB_s'])
