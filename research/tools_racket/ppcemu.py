"""Small Gekko (PowerPC 750CL) interpreter with paired singles, for running pure math helpers
and whole leaf-ish functions from main.dol with a synthetic memory image.
Read-only w.r.t. the project: DOL is read through pingpong/tools/ppc_probe.py helpers."""
import sys, struct, math
from pathlib import Path
ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'pingpong' / 'tools'))
import ppc_probe as P

def f2b(x):
    try:
        return struct.unpack('>I', struct.pack('>f', x))[0]
    except OverflowError:
        return 0x7f800000 if x > 0 else 0xff800000
def b2f(b): return struct.unpack('>f', struct.pack('>I', b & 0xffffffff))[0]
def rs(x):
    """round double to single"""
    try:
        return struct.unpack('>f', struct.pack('>f', x))[0]
    except OverflowError:
        return math.inf if x > 0 else -math.inf
M32 = 0xffffffff
def s32(x):
    x &= M32
    return x - (1 << 32) if x & 0x80000000 else x
def s16(x): return (x & 0xffff) - 0x10000 if x & 0x8000 else x & 0xffff

class Emu:
    def __init__(s):
        s.r = [0] * 32
        s.f = [0.0] * 32; s.p = [0.0] * 32
        s.cr = 0; s.lr = 0; s.ctr = 0; s.xer = 0
        s.mem = {}                       # byte overlay
        s.gqr = [0, 0, 0x40004, 0x50005, 0x60006, 0x70007, 0, 0]
        s.r[1] = 0x817f0000; s.r[2] = 0x806fe080; s.r[13] = 0x806f8120
        s.hooks = {}
        s.putv(0x807d0318,[0,0,0]); s.putv(0x807d0324,[1,0,0]); s.putv(0x807d0330,[0,1,0]); s.putv(0x807d033c,[0,0,1])
        s.putv(0x807d0354,[1,0,0,0,1,0,0,0,1])
        s.steps = 0
        s.trace = False
    # memory
    def rb(s, a):
        a &= M32
        v = s.mem.get(a)
        if v is not None: return v
        d = P.read(a, 1)
        return d[0] if d else 0
    def rd(s, a, n):
        return int.from_bytes(bytes(s.rb(a + i) for i in range(n)), 'big')
    def wr(s, a, v, n):
        v &= (1 << (8 * n)) - 1
        for i, b in enumerate(v.to_bytes(n, 'big')): s.mem[(a + i) & M32] = b
    def getf(s, a): return b2f(s.rd(a, 4))
    def putf(s, a, x): s.wr(a, f2b(x), 4)
    def putv(s, a, vals):
        for i, x in enumerate(vals): s.putf(a + 4 * i, x)
    def getv(s, a, n): return [s.getf(a + 4 * i) for i in range(n)]
    # cr helpers
    def crbit(s, b): return (s.cr >> (31 - b)) & 1
    def setcrbit(s, b, v):
        m = 1 << (31 - b)
        s.cr = (s.cr | m) if v else (s.cr & ~m)
    def setcr(s, f, lt, gt, eq, so=0):
        sh = 28 - 4 * f
        s.cr = (s.cr & ~(0xf << sh)) | (((lt << 3) | (gt << 2) | (eq << 1) | so) << sh)
    def cmp_int(s, f, a, b):
        s.setcr(f, int(a < b), int(a > b), int(a == b))
    def cmp_fp(s, f, a, b):
        if math.isnan(a) or math.isnan(b): s.setcr(f, 0, 0, 0, 1)
        else: s.setcr(f, int(a < b), int(a > b), int(a == b))
    # quantisation
    def q_load(s, ty, sc, a):
        if ty == 0: return b2f(s.rd(a, 4)), 4
        scale = 2.0 ** (-(sc - 64 if sc >= 32 else sc))
        if ty == 4: return s.rd(a, 1) * scale, 1
        if ty == 5: return s.rd(a, 2) * scale, 2
        if ty == 6:
            v = s.rd(a, 1); v = v - 256 if v & 0x80 else v; return v * scale, 1
        if ty == 7:
            v = s.rd(a, 2); v = v - 65536 if v & 0x8000 else v; return v * scale, 2
        raise Exception('gqr type')
    def q_store(s, ty, sc, a, x):
        if ty == 0: s.wr(a, f2b(x), 4); return 4
        scale = 2.0 ** ((sc - 64 if sc >= 32 else sc))
        v = x * scale
        lim = {4: (0, 255, 1), 5: (0, 65535, 2), 6: (-128, 127, 1), 7: (-32768, 32767, 2)}[ty]
        v = int(math.trunc(v)) if not (math.isnan(v)) else 0
        v = max(lim[0], min(lim[1], v))
        s.wr(a, v, lim[2]); return lim[2]
    def call(s, addr, args=(), fargs=(), maxsteps=2000000):
        for i, a in enumerate(args): s.r[3 + i] = a & M32
        for i, a in enumerate(fargs): s.f[1 + i] = a; s.p[1 + i] = a
        s.lr = 0xdeadbee0
        s.run(addr, maxsteps)
        return s.r[3], s.f[1]
    def run(s, pc, maxsteps=2000000):
        n = 0
        while True:
            if pc == 0xdeadbee0: return
            if pc in s.hooks:
                s.hooks[pc](s)
                pc = s.lr; continue
            n += 1
            if n > maxsteps: raise Exception('step limit at %08x' % pc)
            w = P.u32(pc)
            if s.trace: print('%08x %08x' % (pc, w))
            npc = s.step(pc, w)
            pc = npc if npc is not None else pc + 4
    def step(s, pc, w):
        r, f, p = s.r, s.f, s.p
        op = w >> 26; rt = (w >> 21) & 31; ra = (w >> 16) & 31; rb = (w >> 11) & 31; rc = (w >> 6) & 31
        xo = (w >> 1) & 1023; d = s16(w); rcbit = w & 1
        ea0 = lambda: ((r[ra] if ra else 0) + d) & M32
        if op == 14: r[rt] = ((r[ra] if ra else 0) + d) & M32
        elif op == 15: r[rt] = ((r[ra] if ra else 0) + (d << 16)) & M32
        elif op == 7: r[rt] = (s32(r[ra]) * d) & M32
        elif op == 8: r[rt] = (d - r[ra]) & M32
        elif op == 12 or op == 13:
            r[rt] = (r[ra] + d) & M32
            if op == 13: s.cmp_int(0, s32(r[rt]), 0)
        elif op == 10: s.cmp_int((w >> 23) & 7, r[ra], w & 0xffff)
        elif op == 11: s.cmp_int((w >> 23) & 7, s32(r[ra]), d)
        elif op == 24: r[ra] = r[rt] | (w & 0xffff)
        elif op == 25: r[ra] = r[rt] | ((w & 0xffff) << 16)
        elif op == 26: r[ra] = r[rt] ^ (w & 0xffff)
        elif op == 27: r[ra] = r[rt] ^ ((w & 0xffff) << 16)
        elif op == 28: r[ra] = r[rt] & (w & 0xffff); s.cmp_int(0, s32(r[ra]), 0)
        elif op == 29: r[ra] = r[rt] & ((w & 0xffff) << 16); s.cmp_int(0, s32(r[ra]), 0)
        elif op == 21 or op == 20 or op == 23:
            sh = rb if op != 23 else r[rb] & 31
            mb = (w >> 6) & 31; me = (w >> 1) & 31
            x = r[rt]; rot = ((x << sh) | (x >> (32 - sh))) & M32 if sh else x
            if mb <= me: mask = ((M32 >> mb) & (M32 << (31 - me))) & M32
            else: mask = ((M32 >> mb) | (M32 << (31 - me))) & M32
            if op == 20: r[ra] = (rot & mask) | (r[ra] & ~mask & M32)
            else: r[ra] = rot & mask
            if rcbit: s.cmp_int(0, s32(r[ra]), 0)
        elif op in (32, 33, 34, 35, 40, 41, 42, 43):
            ea = ea0() if op in (32, 34, 40, 42) else (r[ra] + d) & M32
            if op in (32, 33): r[rt] = s.rd(ea, 4)
            elif op in (34, 35): r[rt] = s.rd(ea, 1)
            elif op in (40, 41): r[rt] = s.rd(ea, 2)
            else: r[rt] = s16(s.rd(ea, 2)) & M32
            if op in (33, 35, 41, 43): r[ra] = ea
        elif op in (36, 37, 38, 39, 44, 45):
            ea = ea0() if op in (36, 38, 44) else (r[ra] + d) & M32
            n = {36: 4, 37: 4, 38: 1, 39: 1, 44: 2, 45: 2}[op]
            s.wr(ea, r[rt], n)
            if op in (37, 39, 45): r[ra] = ea
        elif op == 46:
            ea = ea0()
            for i in range(rt, 32): r[i] = s.rd(ea, 4); ea += 4
        elif op == 47:
            ea = ea0()
            for i in range(rt, 32): s.wr(ea, r[i], 4); ea += 4
        elif op in (48, 49):
            ea = ea0() if op == 48 else (r[ra] + d) & M32
            v = b2f(s.rd(ea, 4)); f[rt] = v; p[rt] = v
            if op == 49: r[ra] = ea
        elif op in (50, 51):
            ea = ea0() if op == 50 else (r[ra] + d) & M32
            f[rt] = struct.unpack('>d', s.rd(ea, 8).to_bytes(8, 'big'))[0]
            if op == 51: r[ra] = ea
        elif op in (52, 53):
            ea = ea0() if op == 52 else (r[ra] + d) & M32
            s.wr(ea, f2b(f[rt]), 4)
            if op == 53: r[ra] = ea
        elif op in (54, 55):
            ea = ea0() if op == 54 else (r[ra] + d) & M32
            s.wr(ea, int.from_bytes(struct.pack('>d', f[rt]), 'big'), 8)
            if op == 55: r[ra] = ea
        elif op in (56, 57, 60, 61):
            wbit = (w >> 15) & 1; ii = (w >> 12) & 7; dd = w & 0xfff
            dd = dd - 4096 if dd & 0x800 else dd
            ea = ((r[ra] if ra else 0) + dd) & M32 if op in (56, 60) else (r[ra] + dd) & M32
            g = s.gqr[ii]
            if op in (56, 57):
                ty = (g >> 16) & 7; sc = (g >> 24) & 63
                v0, sz = s.q_load(ty, sc, ea); f[rt] = v0
                if wbit: p[rt] = 1.0
                else: p[rt] = s.q_load(ty, sc, ea + sz)[0]
            else:
                ty = g & 7; sc = (g >> 8) & 63
                sz = s.q_store(ty, sc, ea, f[rt])
                if not wbit: s.q_store(ty, sc, ea + sz, p[rt])
            if op in (57, 61): r[ra] = ea
        elif op == 18:
            li = w & 0x03fffffc
            if li & 0x02000000: li -= 0x04000000
            tgt = li if (w & 2) else (pc + li) & M32
            if w & 1: s.lr = pc + 4
            return tgt & M32
        elif op == 16:
            bo = rt; bi = ra; bd = w & 0xfffc
            if bd & 0x8000: bd -= 0x10000
            if not (bo & 4): s.ctr = (s.ctr - 1) & M32
            ok = (bo & 4 or ((s.ctr != 0) ^ bool(bo & 2))) and (bo & 16 or (s.crbit(bi) == ((bo >> 3) & 1)))
            if w & 1: s.lr = pc + 4
            if ok: return ((bd if (w & 2) else pc + bd)) & M32
        elif op == 19:
            if xo in (16, 528):
                bo = rt; bi = ra
                if xo == 16 and not (bo & 4): s.ctr = (s.ctr - 1) & M32
                ok = (bo & 4 or ((s.ctr != 0) ^ bool(bo & 2))) and (bo & 16 or (s.crbit(bi) == ((bo >> 3) & 1)))
                tgt = s.lr if xo == 16 else s.ctr
                if w & 1: s.lr = pc + 4
                if ok: return tgt & M32
            elif xo in (449, 193, 257, 129, 225, 33, 289, 417):
                a = s.crbit(ra); b = s.crbit(rb)
                v = {449: a | b, 193: a ^ b, 257: a & b, 129: a & (1 - b), 225: 1 - (a & b), 33: 1 - (a | b), 289: 1 - (a ^ b), 417: a | (1 - b)}[xo]
                s.setcrbit(rt, v)
            else: raise Exception('op19 xo%d at %08x' % (xo, pc))
        elif op == 31: s.op31(w, pc)
        elif op == 59 or op == 63: s.fp(w, pc)
        elif op == 4: s.ps(w, pc)
        else: raise Exception('unhandled op %d at %08x (%08x)' % (op, pc, w))
        return None
    def op31(s, w, pc):
        r = s.r
        rt = (w >> 21) & 31; ra = (w >> 16) & 31; rb = (w >> 11) & 31; xo = (w >> 1) & 1023; rcb = w & 1
        A = r[ra]; B = r[rb]; S = r[rt]
        def setr(i, v):
            r[i] = v & M32
            if rcb: s.cmp_int(0, s32(r[i]), 0)
        if xo == 0: s.cmp_int((w >> 23) & 7, s32(A), s32(B))
        elif xo == 32: s.cmp_int((w >> 23) & 7, A, B)
        elif xo == 266: setr(rt, A + B)
        elif xo == 40: setr(rt, B - A)
        elif xo == 104: setr(rt, -A)
        elif xo == 235: setr(rt, s32(A) * s32(B))
        elif xo == 75: setr(rt, (s32(A) * s32(B)) >> 32)
        elif xo == 491: setr(rt, int(s32(A) / s32(B)) if s32(B) else 0)
        elif xo == 459: setr(rt, A // B if B else 0)
        elif xo == 444: setr(ra, S | B)
        elif xo == 28: setr(ra, S & B)
        elif xo == 60: setr(ra, S & ~B)
        elif xo == 316: setr(ra, S ^ B)
        elif xo == 124: setr(ra, ~(S | B))
        elif xo == 24: setr(ra, S << (B & 63) if not (B & 32) else 0)
        elif xo == 536: setr(ra, S >> (B & 63) if not (B & 32) else 0)
        elif xo == 824: sh = rb; setr(ra, s32(S) >> sh)
        elif xo == 792: setr(ra, s32(S) >> min(B & 63, 31))
        elif xo == 26: setr(ra, 32 - S.bit_length())
        elif xo == 922: setr(ra, s16(S))
        elif xo == 954: setr(ra, (S & 0xff) - 256 if S & 0x80 else S & 0xff)
        elif xo == 339:
            spr = ((w >> 16) & 31) | (((w >> 11) & 31) << 5)
            r[rt] = {8: s.lr, 9: s.ctr, 1: s.xer}.get(spr, 0)
        elif xo == 467:
            spr = ((w >> 16) & 31) | (((w >> 11) & 31) << 5)
            if spr == 8: s.lr = S
            elif spr == 9: s.ctr = S
            elif 912 <= spr <= 919: s.gqr[spr - 912] = S
        elif xo == 23: r[rt] = s.rd((A if ra else 0) + B, 4)
        elif xo == 87: r[rt] = s.rd((A if ra else 0) + B, 1)
        elif xo == 279: r[rt] = s.rd((A if ra else 0) + B, 2)
        elif xo == 151: s.wr((A if ra else 0) + B, S, 4)
        elif xo == 535:
            v = b2f(s.rd((A if ra else 0) + B, 4)); s.f[rt] = v; s.p[rt] = v
        elif xo == 663: s.wr((A if ra else 0) + B, f2b(s.f[rt]), 4)
        elif xo == 598 or xo == 854 or xo == 982: pass
        elif xo == 8: setr(rt, B - A)
        elif xo == 10: setr(rt, A + B)
        else: raise Exception('op31 xo%d at %08x' % (xo, pc))
    def fp(s, w, pc):
        f, p = s.f, s.p
        op = w >> 26; rt = (w >> 21) & 31; ra = (w >> 16) & 31; rb = (w >> 11) & 31; rc = (w >> 6) & 31
        xo = (w >> 1) & 1023; x = xo & 31
        a, b, c = f[ra], f[rb], f[rc]
        sing = op == 59
        R = rs if sing else (lambda v: v)
        if op == 63 and xo in (0, 32):
            s.cmp_fp((w >> 23) & 7, a, b); return
        if op == 63 and xo == 72: f[rt] = b; return
        if op == 63 and xo == 40: f[rt] = -b; return
        if op == 63 and xo == 264: f[rt] = abs(b); return
        if op == 63 and xo == 136: f[rt] = -abs(b); return
        if op == 63 and xo == 12: f[rt] = rs(b); return
        if op == 63 and xo == 15:
            f[rt] = float(int(math.trunc(b)))   # fctiwz result consumed only via stfd; keep numeric
            f[rt] = struct.unpack('>d', (int(math.trunc(b)) & M32).to_bytes(8, 'big'))[0]; return
        if op == 63 and xo == 14:
            f[rt] = struct.unpack('>d', (int(round(b)) & M32).to_bytes(8, 'big'))[0]; return
        try:
            if x == 21: v = a + b
            elif x == 20: v = a - b
            elif x == 25: v = a * c
            elif x == 18: v = a / b if b != 0 else (math.inf if a > 0 else -math.inf if a < 0 else math.nan)
            elif x == 29: v = a * c + b
            elif x == 28: v = a * c - b
            elif x == 31: v = -(a * c + b)
            elif x == 30: v = -(a * c - b)
            elif x == 23: v = c if a >= 0 else b
            elif x == 24: v = 1.0 / b
            elif x == 26: v = 1.0 / math.sqrt(b)
            else: raise Exception('fp xo%d op%d at %08x' % (xo, op, pc))
        except ZeroDivisionError:
            v = math.inf
        f[rt] = R(v)
        if sing: p[rt] = f[rt]
    def ps(s, w, pc):
        f, p = s.f, s.p
        rt = (w >> 21) & 31; ra = (w >> 16) & 31; rb = (w >> 11) & 31; rc = (w >> 6) & 31
        xo = (w >> 1) & 1023; x = xo & 31
        x6 = (w >> 1) & 63
        if x6 in (6, 7, 38, 39):
            wbit = (w >> 10) & 1; ii = (w >> 7) & 7
            ea = ((s.r[ra] if (ra and x6 < 38) else s.r[ra] if x6 >= 38 else 0) + s.r[rb]) & M32
            g = s.gqr[ii]
            if x6 in (6, 38):
                ty = (g >> 16) & 7; sc = (g >> 24) & 63
                v0, sz = s.q_load(ty, sc, ea); f[rt] = v0
                p[rt] = 1.0 if wbit else s.q_load(ty, sc, ea + sz)[0]
            else:
                ty = g & 7; sc = (g >> 8) & 63
                sz = s.q_store(ty, sc, ea, f[rt])
                if not wbit: s.q_store(ty, sc, ea + sz, p[rt])
            if x6 >= 38: s.r[ra] = ea
            return
        if xo in (0, 32, 64, 96):
            s.cmp_fp((w >> 23) & 7, f[ra] if xo < 64 else p[ra], f[rb] if xo < 64 else p[rb]); return
        if xo == 40: f[rt], p[rt] = -f[rb], -p[rb]; return
        if xo == 72: f[rt], p[rt] = f[rb], p[rb]; return
        if xo == 136: f[rt], p[rt] = -abs(f[rb]), -abs(p[rb]); return
        if xo == 264: f[rt], p[rt] = abs(f[rb]), abs(p[rb]); return
        if xo == 528: f[rt], p[rt] = f[ra], f[rb]; return
        if xo == 560: f[rt], p[rt] = f[ra], p[rb]; return
        if xo == 592: f[rt], p[rt] = p[ra], f[rb]; return
        if xo == 624: f[rt], p[rt] = p[ra], p[rb]; return
        a0, a1, b0, b1, c0, c1 = f[ra], p[ra], f[rb], p[rb], f[rc], p[rc]
        dv = lambda u, v: u / v if v != 0 else (math.inf if u > 0 else -math.inf)
        if x == 10: r0, r1 = a0 + b1, c1
        elif x == 11: r0, r1 = c0, a0 + b1
        elif x == 12: r0, r1 = a0 * c0, a1 * c0
        elif x == 13: r0, r1 = a0 * c1, a1 * c1
        elif x == 14: r0, r1 = a0 * c0 + b0, a1 * c0 + b1
        elif x == 15: r0, r1 = a0 * c1 + b0, a1 * c1 + b1
        elif x == 18: r0, r1 = dv(a0, b0), dv(a1, b1)
        elif x == 20: r0, r1 = a0 - b0, a1 - b1
        elif x == 21: r0, r1 = a0 + b0, a1 + b1
        elif x == 23: r0, r1 = (c0 if a0 >= 0 else b0), (c1 if a1 >= 0 else b1)
        elif x == 24: r0, r1 = dv(1.0, b0), dv(1.0, b1)
        elif x == 25: r0, r1 = a0 * c0, a1 * c1
        elif x == 26: r0, r1 = 1 / math.sqrt(b0), 1 / math.sqrt(b1)
        elif x == 28: r0, r1 = a0 * c0 - b0, a1 * c1 - b1
        elif x == 29: r0, r1 = a0 * c0 + b0, a1 * c1 + b1
        elif x == 30: r0, r1 = -(a0 * c0 - b0), -(a1 * c1 - b1)
        elif x == 31: r0, r1 = -(a0 * c0 + b0), -(a1 * c1 + b1)
        else: raise Exception('ps xo%d at %08x' % (xo, pc))
        f[rt], p[rt] = rs(r0), rs(r1)
