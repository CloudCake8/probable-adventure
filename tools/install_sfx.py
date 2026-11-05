"""Install the corrected game sound effects (research/sfx_correct/wav, rendered by the bank-mapping analysis in research/sound_banks.md)
into public/sfx with a manifest the host page uses.   usage: py -3 tools/install_sfx.py"""
import wave, array, os, json
HERE = os.path.dirname(__file__)
SRC = os.path.join(HERE, '..', 'research', 'sfx_correct', 'wav')
OUT = os.path.join(HERE, '..', 'public', 'sfx')
def load(n):
    w = wave.open(os.path.join(SRC, f'SE_PNG_{n}.wav')); a = array.array('h'); a.frombytes(w.readframes(w.getnframes()))
    return list(a), w.getframerate()
def put(n, dst, target):
    x, r = load(n); pk = max(abs(v) for v in x) or 1; g = target / pk
    y = array.array('h', [int(v * g) for v in x]); k = int(r * 0.003)
    for i in range(min(k, len(y))): y[len(y) - 1 - i] = int(y[len(y) - 1 - i] * i / k)
    w = wave.open(os.path.join(OUT, dst + '.wav'), 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(r); w.writeframes(y.tobytes()); w.close()
    print(dst, f'{len(x) / r:.2f}s'); return dst
m = {
  'hit':      [put('BALL_HIT_NORMAL', 'g_hit', 24000)],
  'drive':    [put('BALL_HIT_DRIVE', 'g_drive', 24000)],
  'cut':      [put('BALL_HIT_CUT', 'g_cut', 24000)],
  'smashhit': [put('BALL_HIT_SMASH', 'g_smashhit', 28000)],
  'face':     [put('BALL_HIT_FACE', 'g_face', 22000)],
  'bounce':   [put('BALL_BOUND_NORMAL', 'g_bounce', 18000), put('BALL_BOUND_WOOD', 'g_bounce_wood', 18000)],
  'net':      [put('BALL_BOUND_NET', 'g_net', 20000)],
  'smashbounce': [put('BALL_BOUND_SMASH', 'g_smashbounce', 22000)],
  'smashshot':[put('SMASH_SHOT', 'g_smashshot', 22000)],
  'swing_s':  [put('SWING_S', 'g_swing_s', 16000)],
  'swing_l':  [put('SWING_L', 'g_swing_l', 16000)],
  'toss':     [put('THROW_UP', 'g_toss', 20000)],
  'whistle_start': [put('WHISTLE_START', 'g_whistle_start', 20000)],
  'whistle_miss':  [put('WHISTLE_MISS', 'g_whistle_miss', 20000)],
  'whistle_end':   [put('WHISTLE_END', 'g_whistle_end', 20000)],
}
json.dump(m, open(os.path.join(OUT, 'manifest.json'), 'w'))
