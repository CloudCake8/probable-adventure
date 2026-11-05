"""Cut the ripped table-tennis sound-effect renders into individual hits for the web port.
usage: py -3 tools/extract_sfx.py   (reads ../assets/audio/sounds/Sp2Snd, writes public/sfx/*.wav)"""
import wave, array, os, json, sys
SRC = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'audio', 'sounds', 'Sp2Snd')
OUT = os.path.join(os.path.dirname(__file__), '..', 'public', 'sfx')
os.makedirs(OUT, exist_ok=True)

def load(name):
    w = wave.open(os.path.join(SRC, f'SE_PNG_{name}.wav'))
    ch, rate = w.getnchannels(), w.getframerate()
    a = array.array('h'); a.frombytes(w.readframes(w.getnframes()))
    mono = [sum(a[i:i + ch]) // ch for i in range(0, len(a), ch)]
    return mono, rate

def segments(x, rate, max_n, max_len=0.6, gap=0.12, thr_ratio=0.06):
    peak = max(abs(v) for v in x) or 1
    win = int(rate * 0.004)
    env = [max(abs(v) for v in x[i:i + win]) for i in range(0, len(x), win)]
    thr = peak * thr_ratio
    segs = []; quiet = 10 ** 9; i = 0
    while i < len(env) and len(segs) < max_n:
        if env[i] > thr and quiet * win / rate >= gap:
            start = i
            # extend to the decay end (env under thr for 40 ms) or max_len
            j = i; q = 0
            while j < len(env) and (j - start) * win / rate < max_len:
                q = q + 1 if env[j] < thr else 0
                if q * win / rate > 0.04: break
                j += 1
            segs.append((max(0, start * win - win), min(len(x), (j + 1) * win)))
            i = j; quiet = 0; continue
        quiet = quiet + 1 if env[i] < thr else 0
        i += 1
    return segs

def write(name, x, rate, fade=0.004):
    n = int(rate * fade)
    y = array.array('h', x)
    for k in range(min(n, len(y))): y[len(y) - 1 - k] = int(y[len(y) - 1 - k] * k / n)
    w = wave.open(os.path.join(OUT, name + '.wav'), 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(rate); w.writeframes(y.tobytes()); w.close()

manifest = {}

def norm(x, target):
    pk = max(abs(v) for v in x) or 1
    g = target / pk
    return [int(v * g) for v in x]

def best(src, dst, n, max_len, target=24000, thr_ratio=0.15, gap=0.03):
    """Cut every hit out of a long sequence render and keep the n loudest (the renders also contain many soft variants)."""
    x, rate = load(src)
    segs = segments(x, rate, 400, max_len=max_len, gap=gap, thr_ratio=thr_ratio)
    segs = sorted(segs, key=lambda s: -max(abs(v) for v in x[s[0]:s[1]]))[:n]
    out = []
    for k, (a, b) in enumerate(segs):
        nm = f'{dst}_{k}'; write(nm, norm(x[a:b], target), rate); out.append(nm)
        print(f'{nm}: {(b - a) / rate:.2f}s peak {max(abs(v) for v in x[a:b])}')
    manifest[dst] = out

def whole(src, dst, max_len=None, target=None):
    x, rate = load(src)
    if max_len: x = x[:int(rate * max_len)]
    if target: x = norm(x, target)
    write(dst, x, rate); manifest[dst] = [dst]; print(f'{dst}: {len(x) / rate:.2f}s')

# The ready-made renders (SE_PNG_BALL_HIT_*/BOUND_*) play one short click sample (rwar006/wave021 etc.) transposed by
# 2^((key - base_note)/12) with base_note 110, i.e. down to ~1/32 speed: deep slow thuds that do not sound like the game.
# So use the raw click samples of the SE_PNG bank at natural pitch instead (all are 0.2-0.3 s bright impacts).
RAW = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'audio', 'Sound', 'Static', 'Sp2Snd', 'rwar006')
def raw(wave_no, dst, target=24000):
    w = wave.open(os.path.join(RAW, f'wave{wave_no:03d}.wav')); ch, rate = w.getnchannels(), w.getframerate()
    a = array.array('h'); a.frombytes(w.readframes(w.getnframes()))
    x = [sum(a[i:i + ch]) // ch for i in range(0, len(a), ch)]
    write(dst, norm(x, target), rate); print(f'{dst} <- wave{wave_no:03d}: {len(x) / rate:.2f}s')
    return dst
manifest['hit'] = [raw(n, f'hit_{n}', 24000) for n in (4, 7, 10, 13)]
manifest['drive'] = [raw(16, 'drive_16', 26000)]
manifest['cut'] = [raw(0, 'cut_0', 24000)]
manifest['smashhit'] = [raw(21, 'smashhit_21', 30000)]
manifest['bounce'] = [raw(n, f'bounce_{n}', 20000) for n in (10, 13)]   # played slower by the page so it sounds like a table "tok"
whole('BALL_BOUND_NET', 'net', 0.6, 20000)
whole('BALL_BOUND_SMASH', 'smashbounce', 0.9)
whole('SMASH_SHOT', 'smashshot')
whole('SWING_S', 'swing_s', None, 20000); whole('SWING_L', 'swing_l', None, 20000)
whole('THROW_UP', 'toss')
whole('WHISTLE_START', 'whistle_start'); whole('WHISTLE_MISS', 'whistle_miss'); whole('WHISTLE_END', 'whistle_end')
json.dump(manifest, open(os.path.join(OUT, 'manifest.json'), 'w'))
