// Generative background score, synthesised live with Web Audio and tuned in 31 equal steps per octave (31-EDO: nearly pure thirds, plus
// in-between steps for glides, scoops and neutral "quarter-tone-ish" intervals).
//
// How it composes (borrowing from adaptive game scoring and rule-based algorithmic composition):
//  * Horizontal re-sequencing + vertical layering: an energy arc (with the game's rally tension mixed in) picks each next section style
//    and how many layers play. Every section has its own tempo (72-118 BPM), a calm one breathes (rubato), sections can slow into their
//    ending or leave a breath before the next, and a phrase can drop to a half-time feel.
//  * Melodies stay singable most of the time: mostly stepwise, in the scale, chord tones on the beats, held notes
//    on the pentatonic, motifs that repeat with small improvised touches. Now and then a phrase gets one "spice": chromatic planing
//    stabs into a chord, an altered or tritone-substitute dominant, a unison band run, a microtonal scoop.
//  * A shared motif bank: ideas born on one instrument come back on others in later sections, developed (transposed, sequenced,
//    fragmented, augmented into a lead line, diminished into a riff), and retired before they wear out.
//  * Groove: each section has its own band part (an idiomatic kick / snare / ghost-note pattern, a bass riff of pentatonic sixteenths,
//    octaves or arpeggios, a comping rhythm, sometimes a muted electric-harp scratch) and a feel (swing that lightens as the tempo rises,
//    a slightly laid-back snare). Bar by bar the band improvises on that part.
//  * Dynamics: every note's strength follows the beat, the phrase's arc, the contour and a little human variation, and the voices
//    answer it: harder notes are brighter, barkier, buzzier; articulation runs from staccato to tenuto per instrument and phrase.
//  * A rare "mantra" section: an odd-metre riff in a neutral-interval mode, built up layer by layer.
// Voices: Karplus-Strong harp and electric harp, FM mallets and Rhodes, a three-string piano, a driven mono bass, analog pads, a singing
// lead, synth brass, soft drums with toms and a crash, into a hall reverb, a tempo-synced dotted-eighth delay and a softly saturated,
// gently wobbling tape bus.
const EDO = 31, ROOT = 73.42;                // D2
const hz = (step) => ROOT * 2 ** (step / EDO);
const pick = (a) => a[(Math.random() * a.length) | 0];
const chance = (p) => Math.random() < p;
const rnd = (a, b) => a + Math.random() * (b - a);
const clamp = (v, a, b) => Math.min(b, Math.max(a, v));
const mod7 = (d) => ((d % 7) + 7) % 7;
const wpick = (items, w) => { let s = 0; for (const x of w) s += x; let r = Math.random() * s; for (let i = 0; i < items.length; i++) { r -= w[i]; if (r <= 0) return items[i]; } return items[items.length - 1]; };
const euclid = (k, n, rot) => Array.from({ length: n }, (_, i) => (((i + rot) * k) % n) < k);   // k onsets spread as evenly as possible over n
const shuffle = (a) => { const r = a.slice(); for (let i = r.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; [r[i], r[j]] = [r[j], r[i]]; } return r; };
// 31-EDO modes: major, natural minor, dorian, and two maqam-like ones with neutral intervals (rast: neutral 3rd and 7th; bayati: neutral 2nd)
const SCALE = { M: [0, 5, 10, 13, 18, 23, 28], m: [0, 5, 8, 13, 18, 21, 26], d: [0, 5, 8, 13, 18, 23, 26], r: [0, 5, 9, 13, 18, 23, 27], b: [0, 4, 8, 13, 18, 21, 26] };
const PENTA = { M: [0, 1, 2, 4, 5], m: [0, 2, 3, 4, 6], d: [0, 2, 3, 4, 6], r: [0, 1, 2, 4, 6], b: [0, 1, 2, 3, 4] };   // where held notes like to sit

// chord qualities, 31-EDO steps above the root (8 = 6/5, 9 = neutral third, 10 = 5/4, 13 = 4/3, 16 = diminished fifth, 18 = 3/2, 23 = major
// sixth, 24 = diminished seventh, 25 = 7/4, 26 = minor seventh, 27 = neutral seventh, 28 = major seventh, +31 = next octave; 34 = flat
// nine, 38 = sharp nine (a 7/6), 46 = sharp eleven, 54 = thirteen)
const Q = {
  M7: [0, 10, 18, 28], M9: [0, 10, 18, 28, 36], add9: [0, 10, 18, 36], M6: [0, 10, 18, 23, 36], M7s11: [0, 10, 18, 28, 46], M9s11: [0, 10, 18, 28, 36, 46],
  m7: [0, 8, 18, 26], m9: [0, 8, 18, 26, 36], m11: [0, 8, 18, 26, 36, 44], m6: [0, 8, 18, 23, 36],
  d7: [0, 10, 18, 26], d9: [0, 10, 18, 26, 36], d13: [0, 10, 26, 36, 54], d9s11: [0, 10, 26, 36, 46], d7s9: [0, 10, 26, 38], d7b9: [0, 10, 26, 34],
  h7: [0, 10, 18, 25, 36], sus9: [0, 13, 18, 26, 36], sus13: [0, 13, 26, 36, 54], dim7: [0, 8, 16, 24],
  n7: [0, 9, 18, 27, 36], sm7: [0, 7, 18, 25, 36],
};
const SUB = { M9: ['M7', 'add9', 'M6'], M7: ['M9'], add9: ['M9'], M6: ['M9'], m9: ['m7', 'm11'], m7: ['m9'], m11: ['m9'], d9: ['d13'], d13: ['d9'], d7: ['d9'], sus13: ['sus9'], sus9: ['sus13'] };
// progressions: [degree (31-EDO steps above the key), quality, sixteenths, optional bass degree for slash chords]. Mostly diatonic, with
// at most one borrowed chord; the altered colours come in as an occasional phrase "spice" instead.
const CALM = [
  { mode: 'M', ch: [[0, 'M9', 32], [23, 'm9', 32], [5, 'm9', 32], [18, 'sus9', 16], [18, 'd9', 16]] },                                        // I vi ii Vsus V
  { mode: 'M', ch: [[13, 'M9', 16], [18, 'd9', 16], [10, 'm7', 16], [23, 'm9', 16], [5, 'm9', 16], [18, 'h7', 16], [0, 'M9', 32]] },          // IV V iii vi ii V7 I
  { mode: 'M', ch: [[0, 'M9', 32], [5, 'd9', 32], [23, 'm9', 32], [13, 'M9', 16], [18, 'sus9', 16]] },                                        // I II vi IV Vsus
  { mode: 'm', ch: [[0, 'm9', 32], [21, 'M9', 32], [26, 'd9', 32], [18, 'h7', 32]] },                                                         // i bVI bVII V7
  { mode: 'm', ch: [[0, 'm11', 16], [8, 'M9', 16], [13, 'm9', 16], [26, 'd9', 16], [21, 'M7', 16], [13, 'm7', 16], [18, 'sus9', 16], [18, 'd7', 16]] },
];
const BRIGHT = [
  { mode: 'M', ch: [[0, 'add9', 32], [23, 'm11', 32], [13, 'M9', 32], [18, 'sus9', 32]] },                                                     // I(add9) vi11 IV9 V(add11)
  { mode: 'M', ch: [[0, 'add9', 32], [3, 'd9', 16], [5, 'm7', 16], [8, 'M7', 32], [0, 'M6', 32]] },                                             // I bII9 ii7 bIII I6
  { mode: 'd', ch: [[0, 'm7', 32], [13, 'sus9', 16], [26, 'M6', 16], [18, 'm7', 32], [13, 'M6', 32]] },                                         // dorian i7 IVsus VII6 v7 IV6
  { mode: 'M', ch: [[13, 'M9', 32], [0, 'M7', 32], [5, 'sus9', 32], [0, 'd9', 32]] },                                                            // IV9 I ii7sus4 I7
  { mode: 'M', ch: [[0, 'M9', 32], [26, 'M9', 32], [21, 'M9', 32], [18, 'sus13', 16], [18, 'd9', 16]] },                                        // majors falling in whole steps
  { mode: 'M', ch: [[0, 'M9', 16], [0, 'd9', 16, 10], [13, 'M9', 16], [15, 'dim7', 16], [0, 'M9', 16, 18], [23, 'd9', 16], [5, 'm9', 16], [18, 'd13', 16]] },   // gospel walk-up
];
const SOUL = [
  { mode: 'm', ch: [[0, 'm9', 16], [18, 'm7', 16], [21, 'add9', 16], [18, 'm7', 16], [13, 'm9', 32], [0, 'm9', 32]] },                         // i7 v VI(add9) v7 iv7
  { mode: 'm', ch: [[21, 'M9', 16], [0, 'm9', 16], [21, 'M9', 16], [0, 'm9', 16], [0, 'm9', 16], [18, 'm7', 16], [13, 'm9', 16], [3, 'd9', 16]] },   // VI i ... iv bII9
  { mode: 'm', ch: [[8, 'M9', 16], [0, 'm9', 16], [21, 'M9', 16], [13, 'm9', 16], [8, 'M9', 16], [0, 'm9', 16], [13, 'm9', 16], [3, 'd9', 16]] },    // III9 i9 VI9 iv9 bII9
];
const FUNK = [
  { mode: 'M', ch: [[0, 'M9', 16], [13, 'd9', 16], [0, 'M9', 16], [13, 'd9', 16], [5, 'm9', 16], [18, 'd9', 16], [0, 'M9', 16], [23, 'm7', 16]] },   // I IV9 vamp, ii V I vi
  { mode: 'M', ch: [[0, 'd9', 32], [13, 'd9', 32], [0, 'd9', 16], [18, 'd13', 16], [13, 'd9', 16], [0, 'd9', 16]] },                                 // dominant-ninth blues funk
  { mode: 'd', ch: [[0, 'm9', 16], [13, 'd9', 16], [0, 'm9', 16], [13, 'd9', 16], [0, 'm9', 16], [13, 'd9', 16], [26, 'M9', 16], [18, 'm7', 16]] },   // dorian i9 IV9 vamp
];
const MANTRA = [
  { mode: 'r', ch: [[0, 'n7', 32], [0, 'n7', 32], [13, 'n7', 32], [0, 'n7', 32]] },
  { mode: 'b', ch: [[0, 'm7', 32], [0, 'm7', 32], [26, 'M7', 32], [0, 'm7', 32]] },
];
const POOLS = { CALM, BRIGHT, SOUL, FUNK, MANTRA };
// section styles: harmony pools, tempo range, drum / bass / comping styles, the instruments that may lead, comp and ornament, swing range
// (fraction of a sixteenth, lightened at faster tempos), how likely a muted-harp scratch part or a funk bass is, and the energy they suit
const STYLE = {
  dawn:   { pool: ['CALM'], bpm: [72, 82], e: [0.05, 0.45], drums: 'brush', bass: 'long', keys: ['piano'], lead: ['lead', 'piano', 'mallet', 'harp'], orn: ['harp', 'mallet', 'piano'], swing: [0.06, 0.1], comp: null, rubato: true },
  glide:  { pool: ['CALM', 'BRIGHT'], bpm: [80, 92], e: [0.28, 0.55], drums: 'brush', bass: 'walk', keys: ['piano'], flow: true, lead: ['lead', 'rhodes', 'eharp', 'mallet'], orn: ['mallet', 'harp', 'rhodes'], swing: [0.1, 0.16], comp: 'push' },
  liquid: { pool: ['BRIGHT', 'SOUL'], bpm: [84, 90], e: [0.4, 0.78], drums: 'half', bass: 'groove', keys: ['rhodes', 'piano'], lead: ['lead', 'eharp', 'brass', 'piano'], orn: ['eharp', 'harp', 'mallet'], swing: [0.08, 0.16], comp: 'stab', scratch: 0.3, funk: 0.35 },
  groove: { pool: ['FUNK', 'SOUL'], bpm: [96, 116], e: [0.55, 1], drums: 'funk', bass: 'funk', keys: ['rhodes'], lead: ['brass', 'lead', 'eharp'], orn: ['eharp', 'mallet'], swing: [0.1, 0.22], lift: 3, comp: 'stab', scratch: 0.85 },
  math:   { pool: ['BRIGHT'], bpm: [100, 118], e: [0.45, 0.8], meter: 14, drums: 'tight', bass: 'lock', keys: ['piano', 'rhodes'], tap: true, lead: ['lead', 'mallet', 'brass'], orn: ['mallet', 'harp'], swing: [0, 0], comp: 'math', w: 0.7 },
  lift:   { pool: ['BRIGHT', 'FUNK'], bpm: [88, 96], e: [0.62, 1], drums: 'step', bass: 'roll', keys: ['rhodes'], lead: ['lead', 'brass', 'eharp'], orn: ['eharp', 'harp', 'mallet'], swing: [0.05, 0.12], comp: 'stab', scratch: 0.4, funk: 0.3 },
  mantra: { pool: ['MANTRA'], bpm: [92, 108], e: [0.45, 0.85], meter: 14, drums: 'tight', bass: 'loop', keys: ['rhodes'], lead: ['eharp', 'lead', 'mallet'], orn: ['mallet'], swing: [0, 0.04], comp: null, loop: true, w: 0.45 },
};
const ARC = [0.32, 0.52, 0.68, 0.88, 0.48, 0.72, 0.95, 0.58];          // the long-range energy shape (jittered, plus game tension)
const LYRIC = new Set(['lead', 'brass', 'piano', 'rhodes']);          // instruments that can sing long notes

// ---- the band's parts: idiomatic one-bar patterns (16 sixteenths) that a section keeps and varies ----------------------------------
const KICKS = {                              // 'x' = kick; the funk ones keep off the backbeats (4, 12), the half-time ones off beat 3 (8)
  funk: ['x.........x.....', 'x......x..x.....', 'x..x......x..x..', 'x.....x...x.....', 'x.x.......x..x..', 'x......x.x......', 'x..x...x..x.....'],
  half: ['x.........x.....', 'x.....x...x.....', 'x......x..x.....', 'x.........x..x..', 'x..x......x.....', 'x.........xx....'],
};
const GHOSTS = { funk: [1, 3, 6, 7, 9, 11, 14, 15], half: [2, 3, 6, 11, 13, 14, 15] };   // where ghost snares like to sit
const HAT_ACC = [[1, 0.35, 0.7, 0.4], [1, 0.45, 0.75, 0.35], [0.9, 0.3, 1, 0.3], [1, 0.5, 0.6, 0.5]];
// bass riffs, "position role [length]": R root, O octave pop, G dead note, F fifth, S seventh, T the chord's third, Q fourth, W second,
// A approach into the next bar. The last funk ones are a disco octave line, an arpeggio line and a pentatonic sixteenth line.
const BASS_RIFFS = {
  funk: ['0R2 3G 6O 7R 10R 13O 14A', '0R3 6G 7O 10R 11F 14O', '0R1.5 3R 6O 10R 12G 13O 15A', '0R2 4G 6R 7O 10F 11R 14O 15A', '0R2 3O 6R 9G 10O 14R', '0R3 7O 10R 11G 13R 14O',
    '0R1 2O1 4R1 6O1 8R1 10O1 12R1 14O1', '0R2 3T 4F 6O 8R 10S 11O 13F 14R 15A', '0R1 2R 3T 5Q 6F 8R 10S 11F 13T 14Q 15A'],
  groove: ['0R4 6R1 7R2 10F2 14O1', '0R3 3G 6R2 10R2 14A', '0R6 10R2 13O 14A', '0R2 3R 6O2 10R4', '0R4 7R1 10O2 14R1 15A', '0R3 6F1 7R2 11O 14R', '0R3 4F2 6O1 8R3 12T2 14A', '0R2 3O 6R2 8F2 11T 14Q 15A'],
};
// comping rhythms for the keys, "position[-length][!]" (! = accented); 'push' parts lean into the next bar
const COMPS = {
  stab: ['2 6 10! 14', '3 6! 11 14', '2 3! 10 11', '6 7! 14 15', '1 6! 9 14', '3 7 11! 15', '0-2! 6 10 13'],
  push: ['0-4! 7 10 15', '0-3! 6 11 14!', '0-6! 10 14!'],
  math: ['0-2! 6 10', '0-3! 4 8 11'],
};
const SCRATCH = ['-x.xX.x.-x.xX.x.', '.xX..x.X.xX..xx.', 'X.x..xX.X.x..x.x', '-.X.-.X.-.X.-.Xx', 'x.X.-xX.x.X.-xXx'];   // X chord, x lighter, . muted, - rest
const HITS = [[[7, 14]], [[7, 10], [7, 14]], [[3, 14], [7, 14]], [[7, 11]], [[7, 6], [7, 10]], [[3, 10], [7, 6], [7, 10]]];   // [bar, sixteenth]
const parseBass = (s) => s.split(' ').map((t) => { const [, pos, role, len] = t.match(/^(\d+)([A-Z])([\d.]+)?$/); return { pos: +pos, role, len: len ? +len : 0 }; });
const parseComp = (s) => s.split(' ').map((t) => { const [, pos, len, acc] = t.match(/^(\d+)(?:-([\d.]+))?(!)?$/); return { pos: +pos, len: len ? +len : 0, acc: !!acc }; });
// articulation: the share of a written length that sounds; weights per style over [stacc, det, norm, leg, ten] (rhythm parts / melody)
const ART = { stacc: 0.38, det: 0.62, norm: 0.85, leg: 1, ten: 1.12 };
const ART_W = {
  dawn:   { rh: [0, 0.5, 2, 3, 1.5], mel: [0.2, 0.6, 2, 3, 1.5] },
  glide:  { rh: [0.3, 1, 2.5, 2, 1], mel: [0.3, 1, 2.5, 2.5, 1] },
  liquid: { rh: [1, 2, 2.5, 1, 0.3], mel: [0.5, 1.2, 2.5, 2, 0.8] },
  groove: { rh: [3, 2.5, 1, 0.3, 0.1], mel: [1.2, 2, 2, 1.2, 0.5] },
  math:   { rh: [2.5, 2.5, 1, 0.2, 0], mel: [1, 2, 2, 1, 0.3] },
  lift:   { rh: [1.5, 2.5, 2, 0.7, 0.2], mel: [0.8, 1.5, 2.5, 1.5, 0.5] },
  mantra: { rh: [1.5, 2.5, 2, 0.5, 0], mel: [0.5, 1.5, 2.5, 1.5, 0.5] },
};
const artPick = (w) => ART[wpick(Object.keys(ART), w)];
// how much each bar of an 8-bar phrase departs from the part: the 4th bar a little, odd bars sometimes, the last bar fills
const varLvl = (b, bars) => (b === bars - 1 ? 'fill' : b === 3 ? (chance(0.6) ? 'small' : 'tiny') : b % 2 ? (chance(0.55) ? 'tiny' : null) : b > 0 && chance(0.2) ? 'tiny' : null);

function impulse(ctx, secs, decay) {        // stereo hall: noise that darkens as it decays
  const sr = ctx.sampleRate, len = Math.floor(sr * secs), b = ctx.createBuffer(2, len, sr);
  for (let c = 0; c < 2; c++) {
    const d = b.getChannelData(c); let lp = 0;
    for (let i = 0; i < len; i++) { const x = i / sr; lp += (Math.random() * 2 - 1 - lp) * (0.6 - 0.45 * x / secs); d[i] = lp * Math.exp(-x / decay) * Math.min(1, i / (sr * 0.012)); }
  }
  return b;
}
const curve = (k) => Float32Array.from({ length: 1024 }, (_, i) => Math.tanh(k * (i / 511.5 - 1)) / Math.tanh(k));

// ---- motifs: notes are {o: onset, l: length (sixteenths), d: scale degree (0 = tonic, 7 = octave), a: accent, x: extra 31-EDO steps,
// bend: scoop from this many steps away} ---------------------------------------------------------------------------------------------
const span = (ns) => ns.reduce((m, n) => Math.max(m, n.o + n.l), 0);
const avgLen = (ns) => ns.reduce((s, n) => s + n.l, 0) / ns.length;
function genMotif(kind, mode = 'M') {        // kind: 'lyric' (long notes), 'riff' (rhythmic), 'lick' (fast). Mostly steps; a leap of a third
  const DUR = { lyric: [[4, 3], [6, 2], [8, 2], [2, 2], [3, 1], [12, 0.5]], riff: [[1, 2], [2, 4], [3, 2], [4, 2], [6, 0.5]], lick: [[0.5, 3], [1, 4], [1.5, 1], [2, 1]] }[kind];
  const total = kind === 'lick' ? 8 : kind === 'riff' ? 16 : pick([16, 32]), shape = pick(['arch', 'rise', 'fall', 'wave', 'arch']), P = PENTA[mode] || PENTA.M;
  const ns = []; let o = kind === 'riff' && chance(0.35) ? pick([1, 2, 3]) : 0, d = pick([0, 2, 4]), dir = shape === 'fall' ? -1 : 1, turn = 0;
  while (o < total) {
    const l = Math.min(wpick(DUR.map((x) => x[0]), DUR.map((x) => x[1])), total - o); if (l <= 0) break;
    if (l >= 2 && !P.includes(mod7(d))) d = clamp(d + dir, -3, 9);                  // held notes sit on the pentatonic
    ns.push({ o, l, d, a: o % 4 === 0 ? 1 : 0.6 });
    o += l + (kind === 'riff' && chance(0.2) ? 1 : 0);                               // riffs breathe between notes
    const prog = o / total;
    if (shape === 'arch') dir = prog < 0.5 ? 1 : -1; else if (shape === 'wave') dir = Math.sin(prog * 6.3) >= 0 ? 1 : -1;
    const step = turn || (chance(0.12) ? 0 : dir * (chance(0.86) ? 1 : 2));          // some repeated notes; a leap is answered by a step back
    turn = !turn && Math.abs(step) === 2 ? -Math.sign(step) : 0;
    d = clamp(d + step, -3, 9);
  }
  if (kind === 'riff' && chance(0.5) && ns.some((n) => n.o >= 8)) {                  // funk riffs often say it twice: a cell and its answer
    const cell = ns.filter((n) => n.o < 8 && n.o + n.l <= 8);
    if (cell.length >= 2) { ns.length = 0; ns.push(...cell, ...cell.map((n, i) => ({ ...n, o: n.o + 8, d: i === cell.length - 1 ? pick([0, 2, 4]) : n.d }))); }
  }
  if (ns.length) { const e = ns[ns.length - 1]; e.d = [-3, 0, 2, 4, 7].reduce((a, b) => (Math.abs(b - e.d) < Math.abs(a - e.d) ? b : a)); }   // land on something stable
  return ns;
}
const TF = {                                 // developmental transforms
  transpose: (ns) => { const k = pick([-2, -1, 1, 2, 3, 4]); return ns.map((n) => ({ ...n, d: n.d + k })); },
  invert: (ns) => { const ax = ns[0].d; return ns.map((n) => ({ ...n, d: 2 * ax - n.d })); },
  retrograde: (ns) => { const s = span(ns); return ns.map((n) => ({ ...n, o: s - n.o - n.l })).sort((a, b) => a.o - b.o); },
  augment: (ns) => ns.map((n) => ({ ...n, o: n.o * 2, l: n.l * 2 })),
  diminish: (ns) => ns.map((n) => ({ ...n, o: n.o / 2, l: Math.max(0.5, n.l / 2) })),
  fragment: (ns) => ns.slice(0, Math.max(2, Math.ceil(ns.length / 2))),
  sequence: (ns) => { const f = ns.slice(0, Math.max(2, Math.ceil(ns.length / 2))), s = span(f), k = pick([-1, 1, 2]); return f.concat(f.map((n) => ({ ...n, o: n.o + s, d: n.d + k }))); },
  ornament: (ns) => ns.flatMap((n, i) => { const nx = ns[i + 1]; return nx && n.l >= 2 && Math.abs(nx.d - n.d) >= 2 ? [{ ...n, l: n.l - 0.5 }, { o: n.o + n.l - 0.5, l: 0.5, d: (n.d + nx.d) >> 1, a: 0.4 }] : [n]; }),
  displace: (ns) => ns.map((n) => ({ ...n, o: n.o + 2 })),
  stretch: (ns) => { const b = ns[0].d; return ns.map((n) => ({ ...n, d: b + Math.round((n.d - b) * 1.5) })); },
};
// how often each is picked: sequences, transpositions and fragments keep a theme singable; the shape-bending ones are rare
const TFW = { transpose: 3, sequence: 2.2, fragment: 1.5, ornament: 1.2, displace: 1.2, invert: 0.5, retrograde: 0.3, stretch: 0.2 };
// small improvised changes for a motif's repeats: anticipate or lay back a note, a grace note, split a long note in two, leave one out,
// accent one, hold one into the next, a turn. With `spicy`, also a chromatic approach or a microtonal scoop. The shape stays recognisable.
function embellish(ns, amt, spicy = false) {
  if (!ns.length || amt <= 0) return ns;
  const out = ns.map((n) => ({ ...n }));
  for (let q = Math.round(amt * rnd(0.6, 1.6)); q > 0; q--) {
    const j = (Math.random() * out.length) | 0, n = out[j], pv = out[j - 1], nx = out[j + 1];
    const op = wpick(['push', 'lay', 'grace', 'approach', 'split', 'drop', 'accent', 'hold', 'turn', 'bend'], [2, 1.4, 1.2, spicy ? 1.5 : 0, 1.2, 0.7, 1.6, 1.2, 0.5, spicy ? 1.5 : 0]);
    if (op === 'push' && n.o >= 1 && (!pv || pv.o + 0.5 <= n.o - 1)) { n.o -= 1; n.l += 1; if (pv) pv.l = Math.min(pv.l, n.o - pv.o); }
    else if (op === 'lay' && n.l >= 2) { n.o += 1; n.l -= 1; }
    else if ((op === 'grace' || op === 'approach') && n.o >= 0.25 && (!pv || pv.o + 0.5 <= n.o - 0.25)) {
      if (pv) pv.l = Math.min(pv.l, n.o - 0.25 - pv.o);
      out.push({ o: n.o - 0.25, l: 0.25, d: op === 'grace' ? n.d + pick([1, -1]) : n.d, x: op === 'approach' ? pick([-3, 3]) : 0, a: 0.35 });
    } else if (op === 'split' && n.l >= 2) { const h = Math.floor(n.l / 2); out.push({ ...n, o: n.o + h, l: n.l - h, a: n.a * 0.75 }); n.l = h; }
    else if (op === 'drop' && out.length > 3 && j > 0 && j < out.length - 1) out.splice(j, 1);
    else if (op === 'accent') n.a = Math.min(1.35, n.a + 0.45);
    else if (op === 'hold') n.l = nx ? Math.max(n.l, nx.o - n.o) : n.l * 1.5;
    else if (op === 'turn' && n.l >= 3) { const e = n.o + n.l; n.l -= 1; out.push({ o: e - 1, l: 0.33, d: n.d + 1, a: 0.4 }, { o: e - 0.67, l: 0.33, d: n.d, a: 0.35 }, { o: e - 0.33, l: 0.33, d: n.d - 1, a: 0.35 }); }
    else if (op === 'bend' && n.l >= 2) n.bend = pick([-2, -1, 1]);
    out.sort((a, b) => a.o - b.o);
  }
  return out;
}

export function createMusic(ctx, trace = null) {   // trace: optional array that collects every note played (offline checks)
  const VOL = 0.3;
  let S16 = 60 / 86 / 4;                     // one sixteenth at the current section's tempo
  const master = ctx.createGain(); master.gain.value = 0;
  const comp = ctx.createDynamicsCompressor(); comp.threshold.value = -18; comp.ratio.value = 3; comp.attack.value = 0.01; comp.release.value = 0.25;
  const warm = ctx.createBiquadFilter(); warm.type = 'lowpass'; warm.frequency.value = 11000;
  master.connect(comp).connect(warm).connect(ctx.destination);
  const analyser = ctx.createAnalyser(); analyser.fftSize = 1024; analyser.smoothingTimeConstant = 0.55; analyser.minDecibels = -90; analyser.maxDecibels = -25;
  warm.connect(analyser);                    // for the floor visualiser (silent when the music is off: it taps after the master gain)
  // tape-style glue: gentle saturation, then a delay line swept very slowly (wow) and a little faster (flutter)
  const mix = ctx.createGain(), tape = ctx.createWaveShaper(), wow = ctx.createDelay(0.05);
  tape.curve = curve(1.3); tape.oversample = '2x'; wow.delayTime.value = 0.012;
  for (const [rate, depth] of [[0.37, 0.0005], [5.3, 0.00003]]) { const l = ctx.createOscillator(), g = ctx.createGain(); l.frequency.value = rate; g.gain.value = depth; l.connect(g).connect(wow.delayTime); l.start(); }
  mix.connect(tape).connect(wow).connect(master);
  const revIn = ctx.createGain(), rev = ctx.createConvolver(); rev.buffer = impulse(ctx, 3.4, 1.1); revIn.connect(rev).connect(mix);
  const dIn = ctx.createGain(), dly = ctx.createDelay(2), fb = ctx.createGain(), dlp = ctx.createBiquadFilter();
  dly.delayTime.value = S16 * 3; fb.gain.value = 0.33; dlp.type = 'lowpass'; dlp.frequency.value = 2600;
  dIn.connect(dly).connect(dlp).connect(fb).connect(dly); dlp.connect(mix); dlp.connect(revIn);
  const bus = (dry, wet, echo, lp) => {      // an instrument bus with fixed reverb / delay sends
    const b = ctx.createGain(); let out = b;
    if (lp) { out = ctx.createBiquadFilter(); out.type = 'lowpass'; out.frequency.value = lp; b.connect(out); }
    for (const [amt, dst] of [[dry, mix], [wet, revIn], [echo, dIn]]) if (amt) { const g = ctx.createGain(); g.gain.value = amt; out.connect(g).connect(dst); }
    return b;
  };
  const chorus = (target, amt = 0.55) => {   // stereo chorus: two short delays swept slowly, hard left and right, beside the dry signal
    const inp = ctx.createGain(); inp.connect(target);
    for (const [d, r, pan] of [[0.011, 0.27, -0.85], [0.017, 0.33, 0.85]]) {
      const dl = ctx.createDelay(0.05), l = ctx.createOscillator(), lg = ctx.createGain(), p = ctx.createStereoPanner(), g = ctx.createGain();
      dl.delayTime.value = d; l.frequency.value = r; lg.gain.value = 0.0028; l.connect(lg).connect(dl.delayTime); l.start();
      p.pan.value = pan; g.gain.value = amt; inp.connect(dl).connect(g).connect(p).connect(target);
    }
    return inp;
  };
  const pianoIn = ctx.createGain(); {        // piano body: low-mid warmth, presence, softened top
    let n = pianoIn;
    for (const [type, f, gain, q] of [['peaking', 240, 2.5, 0.8], ['peaking', 2800, 1.5, 1], ['highshelf', 7000, -4, 0.7]]) { const e = ctx.createBiquadFilter(); e.type = type; e.frequency.value = f; e.gain.value = gain; e.Q.value = q; n.connect(e); n = e; }
    n.connect(bus(0.8, 0.45, 0.12));
  }
  const harpBus = bus(0.7, 0.55, 0.22), padIn = chorus(bus(0.5, 0.85, 0, 1600), 0.6), bassIn = bus(0.9, 0.05, 0, 3200), drumBus = bus(1.1, 0.16, 0, 10000);
  const leadIn = chorus(bus(0.75, 0.55, 0.25), 0.35), malletIn = bus(0.7, 0.45, 0.28), brassIn = chorus(bus(0.7, 0.35, 0.15), 0.4);
  const rhodesIn = ctx.createGain(); {       // Rhodes: tremolo auto-pan, then chorus
    const trem = ctx.createStereoPanner(), l = ctx.createOscillator(), lg = ctx.createGain();
    l.frequency.value = 4.6; lg.gain.value = 0.35; l.connect(lg).connect(trem.pan); l.start();
    rhodesIn.connect(trem).connect(chorus(bus(0.75, 0.4, 0.12), 0.4));
  }
  const ehIn = ctx.createGain(), shaper = ctx.createWaveShaper(), ehTone = ctx.createBiquadFilter();   // electric harp: saturation + chorus
  shaper.curve = curve(2.2); shaper.oversample = '2x'; ehTone.type = 'lowpass'; ehTone.frequency.value = 3400; ehTone.Q.value = 0.9;
  ehIn.connect(shaper).connect(ehTone).connect(chorus(bus(0.55, 0.45, 0.35), 0.5));
  const noise = ctx.createBuffer(1, ctx.sampleRate, ctx.sampleRate); { const d = noise.getChannelData(0); for (let i = 0; i < d.length; i++) d[i] = Math.random() * 2 - 1; }
  const soft = curve(1.6), grit = curve(2.4);
  const noiseHit = (t, dest, type, freq, q, level, dec, offset = 0) => {     // a shaped burst of filtered noise
    const n = ctx.createBufferSource(), f = ctx.createBiquadFilter(), g = ctx.createGain();
    n.buffer = noise; n.loop = dec > 0.5; f.type = type; f.frequency.value = freq; f.Q.value = q;
    g.gain.setValueAtTime(level, t); g.gain.exponentialRampToValueAtTime(0.0001, t + dec);
    n.connect(f).connect(g).connect(dest); n.start(t, offset || Math.random() * 0.6, dec + 0.02);
  };

  // ---- voices: each answers how hard it is played, in level and in tone ---------------------------------------------------------
  const ks = new Map();                      // Karplus-Strong strings, rendered once per pitch and brightness, played with exact pitch correction
  function pluck(f, bright) {
    const SR = 24000, N = Math.max(4, Math.round(SR / f)), key = N * 3 + (bright > 0.7 ? 2 : bright > 0.4 ? 1 : 0);
    let buf = ks.get(key);
    if (!buf) {
      const T = Math.min(3.2, 3.6 * (220 / f) ** 0.4), len = Math.floor(SR * T), rho = 0.01 ** (1 / ((SR / N) * T));   // -40 dB after T
      buf = ctx.createBuffer(1, len, SR); const d = buf.getChannelData(0);
      let lp = 0; for (let i = 0; i < N; i++) { lp += (Math.random() * 2 - 1 - lp) * bright; d[i] = lp; }
      for (let i = N; i < len; i++) d[i] = rho * 0.5 * (d[i - N] + (d[i - N - 1] || 0));
      let pk = 0; for (let i = 0; i < len; i++) pk = Math.max(pk, Math.abs(d[i]));
      for (let i = 0; i < len; i++) d[i] *= 0.7 / (pk || 1) * Math.min(1, (len - i) / (SR * 0.05));
      if (ks.size > 200) ks.delete(ks.keys().next().value);
      ks.set(key, buf);
    }
    return { buf, rate: f * N / SR };
  }
  function harp(t, step, vel, pan = 0, electric = false, bright, dur = null, damp = 0.08) {   // dur: damp the string after this long (null = let it ring)
    const { buf, rate } = pluck(hz(step), bright ?? (electric ? 0.85 : 0.5)), s = ctx.createBufferSource(), g = ctx.createGain(), p = ctx.createStereoPanner();
    const t0 = t + rnd(0, 0.005), lv = vel * (electric ? 0.42 : 0.9) * rnd(0.9, 1.05);
    s.buffer = buf; s.playbackRate.value = rate * 2 ** (rnd(-2, 2) / 1200); g.gain.setValueAtTime(lv, t0); p.pan.value = pan;
    s.connect(g).connect(p).connect(electric ? ehIn : harpBus); s.start(t0);
    if (dur !== null) { g.gain.setValueAtTime(lv, t0 + dur); g.gain.setTargetAtTime(0, t0 + dur, damp); s.stop(t0 + dur + damp * 8); }
  }
  const pw = ctx.createPeriodicWave(new Float32Array(11), new Float32Array([0, 1, 0.55, 0.32, 0.22, 0.13, 0.1, 0.06, 0.05, 0.03, 0.02]));
  function piano(t, step, vel, dur = 1.4, pan = 0) {   // three slightly detuned strings, fast-then-slow decay, closing filter, felt hammer
    t += rnd(0, 0.006);
    const f = hz(step), lp = ctx.createBiquadFilter(), g = ctx.createGain(), p = ctx.createStereoPanner(), a = 0.12 * vel, d = Math.max(0.07, dur);
    lp.type = 'lowpass'; lp.Q.value = 0.4; lp.frequency.setValueAtTime(Math.min(9000, 700 + f * 9 * vel * vel), t); lp.frequency.setTargetAtTime(Math.max(300, f * (1.4 + 0.8 * vel)), t + 0.01, 0.5);   // harder = brighter
    g.gain.setValueAtTime(0, t); g.gain.linearRampToValueAtTime(a, t + 0.003); g.gain.setTargetAtTime(a * 0.42, t + 0.005, 0.12);
    if (d > 0.3) g.gain.setTargetAtTime(a * 0.15, t + 0.3, d * 0.5);
    g.gain.setTargetAtTime(0, t + d, d < 0.25 ? 0.06 : 0.3);    // short notes get the damper quickly
    for (const det of [-4, 0.5, 4.5]) { const o = ctx.createOscillator(); o.setPeriodicWave(pw); o.frequency.value = f; o.detune.value = det + rnd(-1, 1); o.connect(lp); o.start(t); o.stop(t + d + 1.5); }
    p.pan.value = pan; lp.connect(g).connect(p).connect(pianoIn);
    noiseHit(t, pianoIn, 'bandpass', Math.min(6000, f * 5), 1.1, 0.06 * vel * vel, 0.04);
  }
  function rhodes(t, step, vel, dur) {       // FM electric piano: 1:1 modulator fading as it rings + a 14:1 tine bark that only hard notes get
    t += rnd(0, 0.006);
    const f = hz(step), car = ctx.createOscillator(), mod = ctx.createOscillator(), mg = ctx.createGain(), bark = ctx.createOscillator(), bg = ctx.createGain(), g = ctx.createGain(), end = t + dur + 1.6;
    car.frequency.value = f; car.detune.value = rnd(-3, 3); mod.frequency.value = f; bark.frequency.value = f * 14;
    const idx = (0.6 + 2.4 * vel) * f;
    mg.gain.setValueAtTime(idx, t); mg.gain.setTargetAtTime(idx * 0.15, t + 0.01, 0.4);
    bg.gain.setValueAtTime(f * 3.2 * vel * vel, t); bg.gain.setTargetAtTime(0, t, 0.012);
    mod.connect(mg).connect(car.frequency); bark.connect(bg).connect(car.frequency);
    const a = 0.11 * vel; g.gain.setValueAtTime(0, t); g.gain.linearRampToValueAtTime(a, t + 0.003); g.gain.setTargetAtTime(a * 0.5, t + 0.01, 0.7); g.gain.setTargetAtTime(0, t + dur, dur < 0.25 ? 0.05 : 0.22);
    car.connect(g).connect(rhodesIn);
    for (const o of [car, mod, bark]) { o.start(t); o.stop(end); }
  }
  function mallet(t, step, vel, dur = 0.8) {  // FM mallet: a 1:4 modulator that dies fast gives the woody / bell strike, then a pure ring
    t += rnd(0, 0.004);
    const f = hz(step), car = ctx.createOscillator(), mod = ctx.createOscillator(), mg = ctx.createGain(), g = ctx.createGain(), end = t + Math.max(dur, 0.4) + 1.4;
    car.frequency.value = f; car.detune.value = rnd(-2, 2); mod.frequency.value = f * 4;
    mg.gain.setValueAtTime(f * 2.2 * vel * vel, t); mg.gain.setTargetAtTime(0, t, 0.045);
    mod.connect(mg).connect(car.frequency);
    const a = 0.13 * vel; g.gain.setValueAtTime(0, t); g.gain.linearRampToValueAtTime(a, t + 0.002); g.gain.setTargetAtTime(0, t + 0.004, (0.08 + Math.min(dur, 2) * 0.4) * Math.min(1, 600 / f));   // short notes are dead strokes; high bars ring shorter
    car.connect(g).connect(malletIn); car.start(t); mod.start(t); car.stop(end); mod.stop(end);
  }
  function bass(t, step, vel, dur, from = null, pop = false) {   // driven saw + square + sine body, four-pole filter envelope, pluck transient
    const f = hz(step), drv = ctx.createWaveShaper(), f1 = ctx.createBiquadFilter(), f2 = ctx.createBiquadFilter(), out = ctx.createGain(), end = t + dur + 0.5;
    drv.curve = grit;
    for (const [type, det, lvl] of [['sawtooth', -4, 0.45], ['square', 5, 0.3], ['sine', 0, 0.85]]) {
      const o = ctx.createOscillator(), g = ctx.createGain(); o.type = type; o.detune.value = det + rnd(-1.5, 1.5);
      o.frequency.setValueAtTime(from === null ? f : hz(from), t); if (from !== null) o.frequency.exponentialRampToValueAtTime(f, t + 0.07);
      g.gain.value = lvl; o.connect(g).connect(drv); o.start(t); o.stop(end);
    }
    f1.type = f2.type = 'lowpass'; f1.Q.value = pop ? 3.5 : 3; f2.Q.value = 0.7;
    const top = pop ? 1900 : 220 + 1100 * vel * vel, floor = pop ? 340 : 160 + 60 * vel;   // dig in = more growl
    for (const fl of [f1, f2]) { fl.frequency.setValueAtTime(top, t); fl.frequency.setTargetAtTime(floor, t + 0.005, pop ? 0.07 : 0.11); }
    out.gain.setValueAtTime(0, t); out.gain.linearRampToValueAtTime(0.24 * vel, t + 0.004); out.gain.setTargetAtTime(0.145 * vel, t + 0.02, 0.14);
    if (dur > 1) out.gain.setTargetAtTime(0.08 * vel, t + 0.35, 1.2);   // long notes bloom, then settle like a real string
    out.gain.setTargetAtTime(0, t + dur, 0.045);
    drv.connect(f1).connect(f2).connect(out).connect(bassIn);
    noiseHit(t, bassIn, 'bandpass', pop ? 2200 : 900, 1.2, (pop ? 0.16 : 0.08 * vel) * vel, 0.025);
  }
  function pad(t, steps, dur, vel = 1) {     // three detuned saws per note across the stereo field, a filter that opens as it swells, air
    const out = ctx.createGain(), lp = ctx.createBiquadFilter(), l = ctx.createOscillator(), lg = ctx.createGain(), a = 0.0145 * vel, d = Math.max(1.7, dur), end = t + d + 2.6;
    lp.type = 'lowpass'; lp.Q.value = 0.6;
    lp.frequency.setValueAtTime(320, t); lp.frequency.linearRampToValueAtTime(1150, t + 1.8); lp.frequency.setTargetAtTime(800, t + 2, 1.5);
    l.frequency.value = rnd(0.06, 0.12); lg.gain.value = 180; l.connect(lg).connect(lp.frequency);
    const pl = ctx.createStereoPanner(), pr = ctx.createStereoPanner(); pl.pan.value = -0.6; pr.pan.value = 0.6; pl.connect(lp); pr.connect(lp);
    for (const st of steps) for (const [det, dest] of [[-11, pl], [3, lp], [12, pr]]) {
      const o = ctx.createOscillator(); o.type = 'sawtooth'; o.frequency.value = hz(st); o.detune.value = det + rnd(-3, 3);
      o.connect(dest); o.start(t + rnd(0, 0.03)); o.stop(end);
    }
    const n = ctx.createBufferSource(), nf = ctx.createBiquadFilter(), ng = ctx.createGain();
    n.buffer = noise; n.loop = true; nf.type = 'highpass'; nf.frequency.value = 5000; ng.gain.value = 0.05; n.connect(nf).connect(ng).connect(out); n.start(t, Math.random()); n.stop(end);
    out.gain.setValueAtTime(0, t); out.gain.linearRampToValueAtTime(a, t + 1.5); out.gain.setValueAtTime(a, t + d); out.gain.linearRampToValueAtTime(0, t + d + 2.4);
    l.start(t); l.stop(end); lp.connect(out).connect(padIn);
  }
  function lead(t, step, dur, vel, from = null, bright = 0.4) {   // singing analog lead: detuned saws L/R + soft sub square, bloom, vibrato, breath
    const f = hz(step), drive = ctx.createWaveShaper(), lp = ctx.createBiquadFilter(), out = ctx.createGain(), a = 0.08 * vel, end = t + dur + 1.2, atk = Math.min(0.07, dur * 0.5);
    drive.curve = soft; lp.type = 'lowpass'; lp.Q.value = 1.3;
    const cut = Math.min(9000, f * (2.2 + 3 * bright));
    lp.frequency.setValueAtTime(cut * 0.45, t); lp.frequency.linearRampToValueAtTime(cut * (1 + 0.35 * vel), t + 0.07); lp.frequency.setTargetAtTime(cut, t + 0.08, 0.35);   // a harder note blooms more
    const vib = ctx.createOscillator(), vg = ctx.createGain(), dr = ctx.createOscillator(), dg = ctx.createGain();
    vib.frequency.value = rnd(4.8, 5.6); vg.gain.setValueAtTime(0, t); vg.gain.linearRampToValueAtTime(dur > 0.6 ? rnd(6, 10) : 4, t + Math.min(0.7, dur * 0.6)); vib.connect(vg);   // long notes get more vibrato
    dr.frequency.value = rnd(0.13, 0.31); dg.gain.value = rnd(2, 4); dr.connect(dg);
    const pl = ctx.createStereoPanner(), pr = ctx.createStereoPanner(); pl.pan.value = -0.35; pr.pan.value = 0.35; pl.connect(drive); pr.connect(drive);
    for (const [type, det, dest, lvl] of [['sawtooth', -7, pl, 0.5], ['sawtooth', 6, pr, 0.5], ['square', -1197, drive, 0.18]]) {
      const o = ctx.createOscillator(), g = ctx.createGain();
      o.type = type; o.detune.value = det + rnd(-2, 2);
      o.frequency.setValueAtTime(from === null ? f : hz(from), t); if (from !== null) o.frequency.exponentialRampToValueAtTime(f, t + 0.14);
      vg.connect(o.detune); dg.connect(o.detune);
      g.gain.value = lvl; o.connect(g).connect(dest); o.start(t + rnd(0, 0.004)); o.stop(end);
    }
    const n = ctx.createBufferSource(), nf = ctx.createBiquadFilter(), ng = ctx.createGain();
    n.buffer = noise; n.loop = true; nf.type = 'bandpass'; nf.frequency.value = Math.min(8000, f * 3.5); nf.Q.value = 0.9; ng.gain.value = 0.05 + 0.06 * bright;
    n.connect(nf).connect(ng).connect(lp); n.start(t, Math.random() * 0.8); n.stop(end);
    drive.connect(lp).connect(out);
    out.gain.setValueAtTime(0, t); out.gain.linearRampToValueAtTime(a, t + atk);
    if (dur > atk + 0.03) out.gain.setTargetAtTime(a * 0.8, t + atk + 0.02, 0.45);
    out.gain.setTargetAtTime(0, t + dur, dur < 0.2 ? 0.05 : 0.2);
    out.connect(leadIn);
    for (const o of [vib, dr]) { o.start(t); o.stop(end); }
  }
  function brass(t, steps, vel, dur, fall = false) {   // synth brass: detuned saw pairs, a lip scoop on hard notes, a filter that "bwahs" open
    t += rnd(0, 0.005);
    const lp = ctx.createBiquadFilter(), g = ctx.createGain(), a = 0.09 * vel / Math.sqrt(steps.length), end = t + dur + 0.6;
    lp.type = 'lowpass'; lp.Q.value = 1.6;
    lp.frequency.setValueAtTime(350, t); lp.frequency.linearRampToValueAtTime(700 + 3000 * vel, t + 0.06); lp.frequency.setTargetAtTime(600 + 1000 * vel, t + 0.07, 0.25);
    for (const st of steps) for (const det of [-6, 6]) {
      const o = ctx.createOscillator(), f = hz(st); o.type = 'sawtooth'; o.detune.value = det + rnd(-2, 2);
      o.frequency.setValueAtTime(vel > 0.5 && !fall ? f * 0.985 : f, t); o.frequency.exponentialRampToValueAtTime(f, t + 0.05);
      if (fall) { o.frequency.setValueAtTime(f, t + dur * 0.55); o.frequency.exponentialRampToValueAtTime(f * 0.9, t + dur + 0.08); }   // a brass fall-off
      o.connect(lp); o.start(t); o.stop(end);
    }
    g.gain.setValueAtTime(0, t); g.gain.linearRampToValueAtTime(a, t + 0.025); g.gain.setTargetAtTime(a * 0.75, t + 0.03, 0.2); g.gain.setTargetAtTime(0, t + dur, dur < 0.2 ? 0.05 : 0.09);
    lp.connect(g).connect(brassIn);
  }
  function hit(t, type, vel, x = 1) {        // soft drums with a little life: each hit varies in timing, level and tone (x: hat length, tom pitch)
    t += rnd(0, 0.004); vel *= rnd(0.88, 1.05);
    if (type === 'k') {
      const o = ctx.createOscillator(), g = ctx.createGain(); o.frequency.setValueAtTime(rnd(115, 130) + 20 * vel, t); o.frequency.exponentialRampToValueAtTime(44, t + 0.13);
      g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(1 * vel, t + 0.005); g.gain.exponentialRampToValueAtTime(0.0001, t + 0.34);
      o.connect(g).connect(drumBus); o.start(t); o.stop(t + 0.36);
      noiseHit(t, drumBus, 'highpass', 3000, 0.7, 0.06 * vel * vel, 0.006);
    } else if (type === 's') {               // a ghost is short and dull, a backbeat cracks and rings
      const o = ctx.createOscillator(), og = ctx.createGain(), p = rnd(180, 200); o.type = 'triangle'; o.frequency.setValueAtTime(p, t); o.frequency.exponentialRampToValueAtTime(p * 0.78, t + 0.08);
      og.gain.setValueAtTime(0.25 * vel, t); og.gain.exponentialRampToValueAtTime(0.0001, t + 0.1); o.connect(og).connect(drumBus); o.start(t); o.stop(t + 0.12);
      noiseHit(t, drumBus, 'bandpass', rnd(1400, 1700) + 500 * Math.min(1, vel), 0.7, 0.7 * vel, rnd(0.14, 0.19) * (0.6 + 0.45 * Math.min(1, vel)));
      noiseHit(t, drumBus, 'highpass', 5500, 0.7, 0.14 * vel * Math.min(1, vel * 1.4), 0.05);
    } else if (type === 't') {               // a soft tom, pitch x
      const o = ctx.createOscillator(), g = ctx.createGain(); o.frequency.setValueAtTime(x, t); o.frequency.exponentialRampToValueAtTime(x * 0.62, t + 0.18);
      g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(0.5 * vel, t + 0.004); g.gain.exponentialRampToValueAtTime(0.0001, t + 0.3);
      o.connect(g).connect(drumBus); o.start(t); o.stop(t + 0.32);
      noiseHit(t, drumBus, 'bandpass', x * 5, 1, 0.05 * vel, 0.025);
    } else if (type === 'h') noiseHit(t, drumBus, 'highpass', rnd(6900, 7700) + 900 * Math.min(1, vel * 2), 0.5, 0.32 * vel, rnd(0.028, 0.042) * x);
    else if (type === 'o') noiseHit(t, drumBus, 'highpass', 7000, 0.5, 0.16 * vel, rnd(0.17, 0.23) * x);
    else if (type === 'z') noiseHit(t, drumBus, 'bandpass', rnd(6000, 7000), 1.2, 0.12 * vel, 0.07);
    else if (type === 'r') noiseHit(t, drumBus, 'bandpass', 3000, 2, 0.28 * vel, 0.05);
    else if (type === 'c') { noiseHit(t, drumBus, 'highpass', 4500, 0.4, 0.07 * vel, 1.9); noiseHit(t, drumBus, 'bandpass', 8000, 0.8, 0.045 * vel, 1.2); }   // soft crash
  }
  function swell(t, dur) {                   // reversed-cymbal style rise into the next section
    const n = ctx.createBufferSource(), f = ctx.createBiquadFilter(), g = ctx.createGain();
    n.buffer = noise; n.loop = true; f.type = 'bandpass'; f.frequency.setValueAtTime(800, t); f.frequency.exponentialRampToValueAtTime(6000, t + dur);
    g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(0.05, t + dur); g.gain.linearRampToValueAtTime(0, t + dur + 0.05);
    n.connect(f).connect(g).connect(revIn); n.start(t); n.stop(t + dur + 0.1);
  }
  if (trace) {                               // offline checks: log [voice, time, pitch or drum type, ...args] for every note
    const w = (name, f) => (...a) => { trace.push([name, ...a]); if (trace.mute?.has(name)) a[name === 'pad' || name === 'lead' ? 3 : 2] = 1e-6; return f(...a); };   // mute = near-zero velocity, so every random draw (and the score) stays the same
    harp = w('harp', harp); piano = w('piano', piano); rhodes = w('rhodes', rhodes); mallet = w('mallet', mallet); bass = w('bass', bass);
    pad = w('pad', pad); lead = w('lead', lead); brass = w('brass', brass); hit = w('hit', hit);
  }
  // one melodic note on a named instrument (dur in sixteenths, already articulated); plucked strings are damped unless the note is long,
  // and pluck harder (brighter) when played harder
  const PLAY = {
    lead: (t, st, d, v, from, br) => lead(t, st, Math.max(0.05, d * S16 * 0.98), v, from, (br ?? 0.4) * (0.65 + 0.45 * Math.min(1.2, v))),
    brass: (t, st, d, v) => brass(t, [st], v, Math.max(0.06, d * S16 * 0.95)),
    piano: (t, st, d, v) => piano(t, st, v * 0.8, d * S16 * 1.1, rnd(-0.3, 0.3)),   // trims: every voice about equally loud as a melody
    rhodes: (t, st, d, v) => rhodes(t, st, v, d * S16),
    mallet: (t, st, d, v) => mallet(t, st, v, d * S16),
    harp: (t, st, d, v) => harp(t, st, v, rnd(-0.35, 0.35), false, clamp(0.28 + 0.35 * v, 0.28, 0.72), d >= 6 ? null : Math.max(0.06, d * S16 * 1.3), d < 0.7 ? 0.03 : 0.1),
    eharp: (t, st, d, v) => harp(t, st, v, rnd(-0.35, 0.35), true, clamp(0.5 + 0.38 * v, 0.5, 0.95), d >= 6 ? null : Math.max(0.05, d * S16 * 1.15), d < 0.7 ? 0.025 : 0.08),
  };
  const REG = { lead: 91, brass: 85, piano: 91, rhodes: 85, mallet: 93, harp: 101, eharp: 91 };   // where each instrument's melodies centre (31-EDO steps above D2)

  // ---- composition state ------------------------------------------------------------------------------------------------------
  let key = 0, sec = null, ph = null, k = 0, nextT = 0, on = false, tension = 0, arcPos = 0, phraseNo = 0, motifNo = 0, lastVoicing = null, lastLead = 'lead', lastBass = 0, force = null, secNo = 0;
  const bank = [], log = [], lastSec = {};
  const note = (s) => { log.push(s); if (log.length > 400) log.shift(); };
  const pc = (n) => ((n % 31) + 31) % 31;
  const chordAt = (p, pos) => { let c = p.chords[0]; for (const x of p.chords) if (x.at <= pos) c = x; return c; };
  const degStep = (p, d, reg) => reg + p.key + SCALE[p.mode][mod7(d)] + 31 * Math.floor(d / 7);
  function fit(st, c) {                     // nudge a strong / long note onto the nearest chord tone within a whole step
    let best = st, bd = 6;
    for (const x of c.q) { const p = c.root + x, d = ((pc(p) - pc(st) + 46) % 31) - 15; if (Math.abs(d) < Math.abs(bd)) { bd = d; best = st + d; } }
    return Math.abs(bd) <= 5 ? best : st;
  }
  function voiceLead(c, lo, hi) {            // colour tones placed as close as possible to the previous voicing (smooth voice leading)
    const centre = lastVoicing ? lastVoicing.reduce((a, b) => a + b, 0) / lastVoicing.length : (lo + hi) / 2;
    const v = [...new Set(c.q.slice(1).map((x) => { let p = pc(c.root + x); p += 31 * Math.round((centre - p) / 31); while (p < lo) p += 31; while (p > hi) p -= 31; return p; }))].sort((a, b) => a - b);
    lastVoicing = v; return v;
  }
  const chordTones = (c, lo, width) => {     // every chord tone in [lo, lo + width), low to high
    const out = []; for (const x of new Set(c.q.map((q) => pc(c.root + q)))) for (let v = x + 31 * Math.ceil((lo - x) / 31); v < lo + width; v += 31) out.push(v);
    return out.sort((a, b) => a - b);
  };
  const core = (c) => ({ ...c, q: c.q.filter((x) => x <= 28 || x === 36) });   // root, third, fifth, seventh, ninth: no 11ths / 13ths
  const spread = (v, n) => { const out = []; for (let i = v.length - 1; i >= 0 && out.length < n; i--) if (!out.length || out[out.length - 1] - v[i] >= 6) out.push(v[i]); return out.reverse(); };   // top notes, no seconds between them
  function takeMotif(kind, inst, type, mode) {   // reprise from the bank (preferring other instruments / sections, little-used) or invent one
    const old = bank.filter((m) => phraseNo - m.last > 1);
    if (old.length && chance(bank.length >= 3 ? 0.5 : 0.3)) {    // a theme returns more readily after a while away
      const m = wpick(old, old.map((m) => (m.inst !== inst ? 2.2 : 1) * (m.type !== type ? 1.6 : 1) * Math.min(3, (phraseNo - m.last) / 3) / (1 + m.uses)));
      m.uses++; m.last = phraseNo; if (m.uses >= 4) bank.splice(bank.indexOf(m), 1);   // retired after its fourth phrase
      return { m, reprise: true };
    }
    const m = { id: ++motifNo, notes: genMotif(kind, mode), inst, type, kind, uses: 1, last: phraseNo };
    bank.push(m); if (bank.length > 14) bank.splice(bank.indexOf(bank.reduce((a, b) => (b.uses > a.uses ? b : a))), 1);   // forget the most worn
    return { m, reprise: false };
  }
  function develop(ns, inst, extra) {        // fit a motif to its new instrument, then vary it
    const tf = [];
    let n = ns;
    if (!n.length) return { notes: n, tf };
    if (LYRIC.has(inst) && avgLen(n) < 2.5) { n = TF.augment(n); tf.push('augment'); }
    else if (!LYRIC.has(inst) && avgLen(n) > 3) { n = TF.diminish(n); tf.push('diminish'); }
    for (let i = 0; i < extra; i++) { const ns = Object.keys(TFW).filter((x) => x !== tf[tf.length - 1]), f = wpick(ns, ns.map((x) => TFW[x])); n = TF[f](n); tf.push(f); }   // never the same one twice running
    return { notes: n, tf };
  }
  function realise(p, notes, at0, slotEnd, inst, vel, opts = {}) {   // write motif notes into the phrase score
    if (!notes.length) return [];
    const raw = notes.map((n) => degStep(p, n.d, 0) + (n.x || 0)), cen = REG[inst] + (p.E > 0.75 ? 6 : 0);   // in key, then moved by whole octaves only
    const k = (p.oct[inst] ??= 31 * Math.round((cen - raw.reduce((a, b) => a + b, 0) / raw.length) / 31));   // one register per instrument per phrase
    const art = opts.art ?? 0.85, onsets = [];
    let prev = null;
    for (let i = 0; i < notes.length; i++) {
      const n = notes[i], at = at0 + n.o; if (at >= slotEnd || at >= p.len) break;
      let l = Math.min(n.l, slotEnd - at), st = raw[i] + k;
      if (st > cen + 30) st -= 31; else if (st < cen - 28) st += 31;   // melodies stay above the comping register
      if (!n.x && (l >= 2 || at % 4 === 0)) st = fit(st, chordAt(p, at));   // held notes and notes on the beat are chord tones
      const last = opts.last && i === notes.length - 1;
      if (last) { l = Math.max(l, slotEnd - at); st = fit(st, chordAt(p, Math.min(slotEnd, p.len) - 1)); }   // settle on the chord
      // articulation: short notes take it fully, long ones partly; a legato line's last note is held to the end of its slot
      const pl = last && art >= 0.85 ? l : l <= 2 ? l * art : l * (art + (1 - art) * 0.55);
      const from = inst !== 'lead' ? null : n.bend ? st + n.bend : prev !== null && art >= 0.85 && Math.abs(prev - st) <= 10 && chance(0.45) ? prev : l >= 6 && chance(0.15) ? st - 2 : null;
      // dynamics: the beat, the phrase's arc, the contour (higher a little louder), the motif's accents, and a human wobble
      const pos = Math.floor(at), metric = [1, 0.84, 0.93, 0.87][pos % 4] * (pos % p.M === 0 ? 1.07 : 1);
      const v = clamp(vel * (0.78 + 0.22 * n.a) * metric * (0.84 + 0.26 * Math.sin(Math.PI * at / p.len)) * (1 + 0.14 * (st - cen) / 31) * rnd(0.92, 1.07), 0.2, 1.3);
      const dt = p.pk.mel + (l >= 4 ? rnd(0, 0.012) : rnd(-0.004, 0.004));   // long notes sit back a touch
      put(p, at, (t) => PLAY[inst](t, st, pl, v, from, p.bright), dt);
      onsets.push(Math.floor(at)); prev = st;
    }
    return onsets;
  }
  const put = (p, at, fn, dt = 0) => { const i = Math.floor(at); if (i < 0 || i >= p.len) return; (p.ev[i] ||= []).push([at - i, fn, dt]); };   // dt: the part's pocket, in seconds

  // ---- the band's part for a section, and its bar-by-bar playing ----------------------------------------------------------------
  function makeGroove(type, st, bpm) {
    const sw = rnd(st.swing[0], st.swing[1]) * clamp(92 / bpm, 0.7, 1.15), tpl = st.meter ? 'straight' : wpick(['swing', 'drag', 'lilt'], [3, type === 'groove' || type === 'liquid' ? 2 : 0.5, 1]);   // faster = lighter swing
    const grid = tpl === 'straight' ? [0, 0, 0, 0] : tpl === 'swing' ? [0, sw, 0, sw] : tpl === 'drag' ? [0, sw * 1.2, sw * 0.25, sw * 0.9] : [0, sw * 0.7, sw * 0.15, sw * 1.1];
    const back = type === 'groove' ? rnd(0.004, 0.012) : st.meter ? rnd(0, 0.003) : rnd(0.002, 0.009), bassStyle = st.funk && chance(st.funk) ? 'funk' : st.bass;
    return {
      tpl, sw, grid, kit: {}, bassStyle,
      pk: { k: 0, s: back, h: rnd(-0.004, 0.003), b: rnd(0.002, 0.009), keys: back * rnd(0.5, 1.1), mel: rnd(0, 0.014), orn: rnd(-0.004, 0.004) },   // the pocket: snare, bass and keys a little behind the kick
      riff: BASS_RIFFS[bassStyle] ? parseBass(pick(BASS_RIFFS[bassStyle])) : null,
      loop: st.loop ? makeLoop(st.meter || 16) : null,
      comp: st.comp ? parseComp(pick(COMPS[st.comp])) : null,
      scratch: st.scratch && chance(st.scratch) ? pick(SCRATCH) : null,
      hits: ['groove', 'liquid', 'lift'].includes(type) && chance(0.7) ? pick(HITS) : [],
    };
  }
  function makeLoop(M) {                     // a one-bar mantra riff: notes on a grouping of the odd bar, around the tonic and the neutral step
    const groups = M === 14 ? pick([[4, 4, 6], [3, 4, 3, 4], [2, 2, 3, 2, 2, 3]]) : pick([[4, 4, 4, 4], [3, 3, 4, 3, 3]]), out = [];
    let pos = 0;
    for (const gl of groups) { const two = gl >= 4 && chance(0.6); out.push({ pos, d: pick([0, 0, 1, 2, 2, 4, -1, -2]), len: two ? 1.5 : gl - 0.5 }); if (two) out.push({ pos: pos + 2, d: pick([0, 1, 2, -1]), len: gl - 2.5 }); pos += gl; }
    out[0].d = 0;
    return out;
  }
  function makeDrums(style) {                // the drummer's part: kicks and backbeats with levels, ghost-note chances, hat accents and length
    const d = { style, kick: [], snare: [], ghost: [], hat: 'h', every: 1, open: -1, hd: rnd(0.85, 1.45) }, acc = pick(HAT_ACC);
    if (style === 'brush') Object.assign(d, { kick: [[0, 0.3], [10, 0.24]], snare: [[4, 0.35, 'r'], [12, 0.35, 'r']], ghost: [[7, 0.25], [15, 0.3]], hat: 'z', every: 2 });
    else if (style === 'funk' || style === 'half') {
      d.kick = [...pick(KICKS[style])].flatMap((c, i) => (c === 'x' ? [[i, i ? (style === 'funk' ? 0.8 : 0.6) : style === 'funk' ? 1 : 0.9]] : []));
      d.snare = style === 'funk' ? [[4, 0.85, 's'], [12, 0.85, 's']] : [[8, 0.7, 's']];
      d.ghost = shuffle(GHOSTS[style].filter((x) => !d.kick.some(([q]) => q === x))).slice(0, style === 'funk' ? pick([3, 4, 5]) : pick([2, 3, 4])).map((x) => [x, rnd(0.5, 0.95)]);
      d.open = pick([14, 14, 6, 10, -1]); d.every = style === 'funk' ? 1 : 2;
    } else if (style === 'step') Object.assign(d, { kick: [[0, 0.9], [5, 0.65], [8, 0.9], [13, 0.65]], snare: [[2, 0.55, 's'], [6, 0.55, 's'], [10, 0.55, 's'], [14, 0.55, 's']], ghost: [[3, 0.25], [7, 0.2], [11, 0.25], [15, 0.35]] });
    else if (style === 'tight') Object.assign(d, { kick: [[0, 0.95], [4, 0.7], [8, 0.7]], snare: [[6, 0.42, 's'], [12, 0.65, 's']], ghost: [[3, 0.2], [10, 0.3]], every: 2 });
    d.accM = Array.from({ length: 20 }, (_, i) => (style === 'brush' ? (i % 4 ? 0.72 : 1) : style === 'tight' ? ([0, 4, 8].includes(i) ? 1 : 0.62) : style === 'step' ? (i % 2 ? 0.57 : 1) : acc[i % 4]));
    return d;
  }
  function writeDrums(p, s, E, idx, breakdown) {
    const M = s.meter, bars = p.len / M, last = idx === s.phrases - 1, pk = p.pk;
    let dstyle = breakdown || E < 0.15 ? 'none' : E < 0.35 || (s.st.loop && idx === 0) ? 'brush' : s.st.drums === 'brush' && E > 0.5 ? 'half' : s.st.drums;
    if (idx > 0 && !breakdown && (dstyle === 'funk' || dstyle === 'step') && chance(0.18)) dstyle = 'half';   // the band drops to a half-time feel for a phrase...
    else if (idx > 0 && !breakdown && dstyle === 'half' && s.st.drums === 'half' && E > 0.55 && chance(0.15)) dstyle = 'funk';   // ...or doubles up
    if (dstyle === 'none') return dstyle;
    const d = (s.g.kit[dstyle] ||= makeDrums(dstyle)), soft = dstyle === 'brush' ? 0.5 : 1, fill = p.hitBar7 ? 'hits' : p.spice === 'unison' ? 'kicks' : pick(['roll', 'kicks', 'open', 'drop', 'flams', 'toms']);
    for (let b = 0; b < bars; b++) {
      // this bar's copy of the part, then a little improvising on it
      const o = b * M, lvl = p.lvl[b], K = new Map(d.kick), S = new Map(d.snare.map(([x, v, ty]) => [x, [v, ty]])), G = new Map(d.ghost), off = new Set(), acc = new Map(), fl = new Set(), dr = new Set();
      if (dstyle === 'brush' && E <= 0.3) K.delete(10);
      for (const x of [...K.keys(), ...S.keys(), ...G.keys()]) if (x >= M) { K.delete(x); S.delete(x); G.delete(x); }
      let open = d.open >= 0 && d.open < M && (b % 2 === 1 || chance(0.35)) ? d.open : -1;
      for (let q = lvl === 'tiny' ? 1 : lvl === 'small' ? 2 : 0; q > 0; q--) {
        const op = pick(['kickPush', 'kickAdd', 'ghostAdd', 'ghostDrop', 'open', 'hatDrop', 'flam', 'drag', 'accent']), odd = [1, 3, 5, 7, 9, 11, 13, 15].filter((x) => x < M);
        if (op === 'kickPush') { const c = [...K.keys()].filter((x) => x > 1 && !S.has(x - 1) && !K.has(x - 1)); if (c.length) { const x = pick(c), v = K.get(x); K.delete(x); K.set(x - 1, v); } }
        else if (op === 'kickAdd') { const c = [M - 1, M - 3, 3, 7].filter((x) => x < M && !S.has(x) && !K.has(x)); if (c.length) K.set(pick(c), 0.55); }
        else if (op === 'ghostAdd') { const c = odd.filter((x) => !S.has(x) && !G.has(x)); if (c.length) G.set(pick(c), 1); }
        else if (op === 'ghostDrop' && G.size) G.delete(pick([...G.keys()]));
        else if (op === 'open') open = pick([2, 6, 10, 14].filter((x) => x < M));
        else if (op === 'hatDrop') off.add(pick(odd));
        else if (op === 'flam' && S.size) fl.add(pick([...S.keys()]));
        else if (op === 'drag' && S.size) dr.add(pick([...S.keys()]));
        else if (op === 'accent') acc.set(pick([0, 2, 4, 6, 8, 10, 12, 14].filter((x) => x < M)), 1.45);
      }
      for (let i = 0; i < M; i++) {
        const pos = o + i, nf = last ? 4 : 2, fz = lvl === 'fill' && i >= M - nf, j = i - (M - nf);
        if (p.choke.has(pos)) continue;          // the beat of silence after a band hit
        if (p.hitSet.has(pos)) { put(p, pos, (t) => hit(t, 'k', 0.95), pk.k); put(p, pos, (t) => hit(t, 's', 0.5), pk.s); put(p, pos, (t) => (pos === p.lastHit ? hit(t, 'c', 0.55) : hit(t, 'o', 0.5, d.hd)), pk.h); continue; }
        if (fz && fill === 'drop') continue;
        if (fz && fill === 'roll') { put(p, pos, (t) => hit(t, 's', (0.2 + j * 0.12) * soft), pk.s); put(p, pos + 0.5, (t) => hit(t, 's', (0.15 + j * 0.1) * soft), pk.s); continue; }
        if (fz && fill === 'toms') { const f = [210, 175, 145, 120][(j + (last ? 0 : 2)) % 4]; put(p, pos, (t) => hit(t, 't', (0.6 + 0.05 * j) * soft, f), pk.s); if (j % 2) put(p, pos + 0.5, (t) => hit(t, 't', 0.45 * soft, f * 0.9), pk.s); continue; }
        if (fz && fill === 'flams') { put(p, pos, (t) => { hit(t - 0.02, 's', 0.22 * soft); hit(t, 's', (0.45 + j * 0.08) * soft); }, pk.s); continue; }
        if (K.has(i)) { const v = K.get(i) * rnd(0.92, 1.05); put(p, pos, (t) => hit(t, 'k', v), pk.k); }
        if (S.has(i)) {
          const [v0, ty] = S.get(i), flam = fl.has(i), v = v0 * (i % 8 === 4 ? rnd(0.9, 1) : rnd(0.96, 1.08));   // the second backbeat of a pair often lands a hair harder
          if (dr.has(i)) { put(p, pos - 0.5, (t) => hit(t, 's', 0.1), pk.s); put(p, pos - 0.25, (t) => hit(t, 's', 0.13), pk.s); }   // a drag into the backbeat
          put(p, pos, (t) => { if (flam) hit(t - 0.02, ty, v * 0.4); hit(t, ty, v); }, pk.s);
        } else if (G.has(i) && chance(G.get(i))) { const v = rnd(0.08, 0.17); put(p, pos, (t) => hit(t, 's', v), pk.s); }
        if ((d.every === 1 || i % 2 === 0) && !off.has(i)) {
          const ty = i === open ? 'o' : d.hat, v = (d.hat === 'z' ? 0.35 : 0.42) * d.accM[i] * (acc.get(i) || 1) * rnd(0.9, 1.08);
          put(p, pos, (t) => hit(t, ty, v, d.hd), pk.h);
        }
        if (fz && fill === 'kicks' && i % 2) put(p, pos, (t) => hit(t, 'k', 0.6 * soft), pk.k);
        if (fz && fill === 'open' && i === M - 2) put(p, pos, (t) => hit(t, 'o', 0.4, d.hd), pk.h);
      }
    }
    if (idx === 0 && E > 0.5) put(p, 0, (t) => hit(t, 'c', 0.8 + 0.4 * E));      // a crash to open energetic sections
    return dstyle;
  }
  function writeBass(p, s, E, idx) {
    const M = s.meter, bars = p.len / M, style = E < 0.22 ? 'long' : s.g.bassStyle, art = p.art.rh, pk = p.pk.b;
    let tied = false;                        // the previous bar anticipated this downbeat
    for (let b = 0; b < bars; b++) {
      const o = b * M, c = chordAt(p, o), cn = o + M < p.len ? chordAt(p, o + M) : p.chords[0], r = c.lo, nx = cn.lo, change = cn !== c || o + M >= p.len;
      const fifth = c.slash ? r + 31 : r + 18, sev = c.slash ? null : c.q.find((x) => x >= 23 && x <= 28), third = c.slash ? r + 31 : r + c.q[1], lvl = p.lvl[b], wasTied = tied, ends = c.at + c.len === o + M;
      tied = false;
      const play = (i, step, vel, len, from = null, pop = false, isHit = false) => { const pos = o + i; if (pos < p.len && !p.choke.has(pos) && (isHit || !p.hitSet.has(pos))) { const v = vel * (i % 4 ? 0.93 : 1.04) * rnd(0.9, 1.08); put(p, pos, (t) => bass(t, step, v, Math.max(0.05, len * S16), from, pop), pk); } };
      const appr = () => nx + pick([-3, 3, 5]);
      for (const h of p.hits) if (h >= o && h < o + M) play(h - o, r + (chance(0.5) ? 31 : 0), 0.9, 0.9 * art, null, true, true);
      if (style === 'long') {
        const pickup = lvl && ends && change;
        if (o === c.at) play(0, r, 0.6, (pickup ? c.len - 2 : c.len) * (art >= 0.85 ? 1 : 0.75));
        if (pickup) play(M - 2, appr(), 0.45, 1.6 * art);
      } else if (style === 'walk') {
        if (!wasTied) play(0, o === c.at ? r : pick([r, third, fifth]), 0.7, 7 * art);
        play(8, chance(0.6) ? fifth : r + 31, 0.55, 5 * art);
        if (lvl) play(6, pick([third, fifth]), 0.42, 1.5 * art);           // a skip note
        if (change && ends) play(M - 2, appr(), 0.5, 1.8 * art); else if (lvl) play(M - 2, r + pick([13, 23]), 0.45, 1.6 * art);
      } else if (style === 'lock') {
        const pts = lvl === 'fill' ? [0, 4, 8, 10, 12] : lvl ? [0, 4, 8, pick([11, 12, 13])] : [0, 4, 8, 11];
        for (const i of pts) if (i < M) play(i, i === 8 ? fifth : i >= 11 ? r + 31 : r, i ? 0.6 : 0.85, 1.2 * art);
      } else if (style === 'loop') {         // the mantra riff in the section's mode, on the chord's root
        if (idx === 0 && b === 0) note('    loop starts');
        for (const n of s.g.loop) if (n.pos < M) play(n.pos, r + SCALE[p.mode][mod7(n.d)] + 31 * Math.floor(n.d / 7), n.pos === 0 ? 0.85 : 0.66, n.len * art);
      } else if (style === 'roll') {
        for (let i = 0; i < M; i += 2) play(i, r + (i % 8 === 6 ? 31 : 0), i % 4 ? 0.45 : 0.75, 1.3 * art, chance(0.08) ? r - 2 : null);
        if (lvl === 'tiny') play(pick([3, 7, 11]), r, 0.25, 0.3);
        if (lvl === 'small' || lvl === 'fill') play(M - 1, change ? nx - 3 : r + 31, 0.5, 0.9 * art);
      } else {                               // 'funk' / 'groove': the section's riff, improvised on bar by bar
        let riff = s.g.riff.filter((n) => n.pos < M).map((n) => ({ ...n }));
        if (wasTied) riff = riff.filter((n) => n.pos !== 0);
        for (let q = lvl === 'tiny' ? 1 : lvl === 'small' ? 2 : 0; q > 0; q--) {
          const op = pick(['ghost', 'pop', 'drop', 'hold', 'slide', change && ends ? 'push' : 'ghost']), nz = riff.filter((n) => n.pos > 0);
          if (op === 'ghost') { const f = [1, 3, 5, 9, 11, 13, 15].filter((x) => x < M && !riff.some((n) => n.pos === x)); if (f.length) riff.push({ pos: pick(f), role: 'G', len: 0 }); }
          else if (op === 'pop' && nz.length) pick(nz).role = 'O';
          else if (op === 'drop' && nz.length > 2) riff.splice(riff.indexOf(pick(nz)), 1);
          else if (op === 'hold' && riff[0]?.pos === 0) { riff = riff.filter((n) => n.pos === 0 || n.pos >= 4); riff[0].len = 4; }   // draw the one out
          else if (op === 'slide' && nz.length) pick(nz).slide = true;
          else if (op === 'push' && !riff.some((n) => n.pos >= M - 1)) { riff = riff.filter((n) => n.pos < M - 2); riff.push({ pos: M - 1, role: 'N', len: 2 }); tied = true; }   // anticipate the next chord
        }
        if (lvl === 'fill' && chance(0.6)) { riff = riff.filter((n) => n.pos < M - 3); [-8, -5, -3].forEach((dx, q) => riff.push({ pos: M - 3 + q, role: 'X', len: 0.8, step: change ? nx + dx : r + [18, 13, 5][q] })); }   // a run into the next bar
        riff.sort((a, b) => a.pos - b.pos);
        for (const n of riff) {
          const i = n.pos, step = n.step ?? ({ O: r + 31, F: fifth, S: sev ? r + sev : r + 31, T: third, Q: r + 13, W: r + 5, N: nx }[n.role] ?? (n.role === 'A' ? (change ? appr() : r + pick([13, 18])) : r));
          const vel = n.role === 'G' ? 0.25 : i === 0 ? 0.88 : n.role === 'O' ? 0.72 : 0.62, len = n.role === 'G' ? 0.3 : (n.len || 1) * (i === 0 || n.role === 'N' ? Math.sqrt(art) : art);
          play(i, step, vel, len, n.slide ? step - 3 : null, n.role === 'O' && style === 'funk');
        }
      }
    }
  }
  function writeComp(p, s, E, keysInst) {   // the keys: voice-led chords on the changes, plus the section's stab rhythm, varied per bar
    const M = s.meter, art = p.art.rh, pk = p.pk.keys, pat = s.g.comp, pno = keysInst === 'piano';
    let skipOnset = false;
    for (const c of p.chords) {
      const v = voiceLead(c, 44, 80), roll = pno && E < 0.4, hold = S16 * (art >= 0.85 || !pat ? Math.min(c.len, 12) : 2 * art), onv = (pno ? 0.36 : 0.45) * rnd(0.85, 1.1);
      if (!skipOnset) put(p, c.at, (t) => v.forEach((s2, i) => (pno ? piano(t + (roll ? i * 0.07 : 0), s2, onv * (1 - i * 0.04), hold) : rhodes(t + i * 0.006, s2, onv * (1 - i * 0.03), hold))), pk);
      skipOnset = false;
      if (!pat || E < 0.3) continue;
      for (let o = c.at; o < c.at + c.len; o += M) {
        const lvl = p.lvl[o / M], nextC = o + M < p.len ? chordAt(p, o + M) : null;
        const stabs = pat.filter((x) => x.pos > 0 && x.pos < M && (E > 0.45 || x.acc)).map((x) => ({ ...x }));
        if (lvl === 'tiny' || lvl === 'small') {
          if (chance(0.5) && stabs.length > 1) stabs.splice((Math.random() * stabs.length) | 0, 1);
          else { const f = [3, 7, 11, 15].filter((x) => x < M && !stabs.some((y) => y.pos === x)); if (f.length) stabs.push({ pos: pick(f), len: 0, acc: false }); }
        }
        for (const h of p.hits) if (h >= o && h < o + M && !stabs.some((x) => x.pos === h - o)) stabs.push({ pos: h - o, len: 1, acc: true });
        for (const x of stabs) {
          const pos = o + x.pos; if (pos >= p.len || p.choke.has(pos)) continue;
          const ant = nextC && nextC !== c && x.pos >= M - 2, top = spread(ant ? voiceLead(nextC, 44, 80) : v, 3);   // late stabs anticipate the next chord
          if (ant && x.pos === M - 1) skipOnset = true;                                                           // ...and tie over its downbeat
          const len = S16 * (x.len || 1) * art, vel = (x.acc || p.hitSet.has(pos) ? 0.52 : 0.38) * (x.pos % 2 ? 1.06 : 0.96) * rnd(0.86, 1.1);
          put(p, pos, (t) => top.forEach((s2) => (pno ? piano(t, s2, vel * 0.85, len) : rhodes(t, s2, vel, len))), pk);
        }
      }
    }
  }
  function writeScratch(p, s) {             // muted electric-harp "chicken scratch": strummed shell voicings, damped hard, the muted ones dead
    const pat = s.g.scratch, M = s.meter, pk = p.pk.keys;
    for (let b = 0; b < p.len / M; b++) {
      const o = b * M, lvl = p.lvl[b], drop = lvl ? (Math.random() * M) | 0 : -1;
      for (let i = 0; i < M; i++) {
        const ch = pat[i % 16], pos = o + i; if (ch === '-' || i === drop || p.choke.has(pos)) continue;
        const tones = spread(chordTones(core(chordAt(p, pos)), 62, 26), 3), accent = ch === 'X' || p.hitSet.has(pos), mute = ch === '.' && !accent, up = i % 2 === 1;
        const v = (accent ? 0.48 : mute ? 0.16 : 0.3) * rnd(0.85, 1.12), br = mute ? 0.3 : accent ? 0.75 : 0.6, dur = mute ? 0.03 : 0.085, dmp = mute ? 0.01 : 0.025, order = up ? [...tones].reverse() : tones;
        put(p, pos, (t) => order.forEach((s2, q) => harp(t + q * 0.007, s2, v * (1 - q * 0.08), up ? 0.25 : -0.25, true, br, dur, dmp)), pk);
      }
    }
  }

  function newSection() {
    let target = clamp(ARC[arcPos++ % ARC.length] + rnd(-0.08, 0.08) + 0.2 * tension, 0.08, 1);
    const types = Object.keys(STYLE).filter((t) => (!sec || t !== sec.type) && target >= STYLE[t].e[0] - 0.08 && target <= STYLE[t].e[1] + 0.08);
    const type = force || (types.length ? wpick(types, types.map((t) => Math.min(4, secNo - (lastSec[t] ?? -9)) * (STYLE[t].w ?? 1))) : 'liquid'), st = STYLE[type];   // styles not heard for a while are likelier
    const prog = pick(st.pool.flatMap((n) => POOLS[n]));
    lastSec[type] = ++secNo;
    if (force) { target = (st.e[0] + st.e[1]) / 2; force = null; }
    key += st.lift ? pick([3, 8, -5]) : pick([0, 0, 18, -13, 8, -8, 5, -5]); if (key > 14) key -= 31; else if (key < -14) key += 31;
    const bpm = Math.round(rnd(st.bpm[0], st.bpm[1]));                  // each section its own tempo; the echo follows it
    S16 = 60 / bpm / 4; dly.delayTime.setTargetAtTime(S16 * 3, ctx.currentTime, 0.3);
    const n = st.loop ? 3 : target > 0.85 ? pick([1, 2]) : target < 0.3 ? 2 : pick([1, 2, 2, 3]), g = makeGroove(type, st, bpm);
    const rit = (st.rubato || type === 'glide' ? chance(0.6) : chance(0.2)) ? rnd(0.06, 0.16) : 0, breath = chance(0.25) ? S16 * pick([2, 4]) : 0;   // slow into the end; a breath before the next
    sec = { type, st, prog, mode: prog.mode, key: key + (type === 'dawn' && chance(0.15) ? pick([1, -1]) : 0), meter: st.meter || 16, energy: target, phrases: n, pi: 0, g, bpm, rit, breath };
    note(`section ${type} energy ${target.toFixed(2)} key ${sec.key} phrases ${n} bpm ${bpm} feel ${g.tpl} ${(g.sw * 100) | 0}% bass ${g.bassStyle}${g.scratch ? ' +scratch' : ''}${g.hits.length ? ' +hits' : ''}${rit ? ' +rit' : ''}${breath ? ' +breath' : ''}`);
  }
  function planPhrase() {
    const s = sec, st = s.st, M = s.meter, f = M / 16, idx = s.pi, breakdown = idx > 0 && idx === s.phrases - 1 && s.energy > 0.5 && !st.loop && chance(0.25);
    const E = clamp(s.energy + 0.07 * idx + 0.15 * tension - (breakdown ? 0.35 : 0), 0, 1), lift = st.lift && idx > 0 ? st.lift * idx : 0;
    tension *= 0.7;                            // a long rally lifts the next few phrases, then fades
    const p = { len: 0, ev: [], chords: [], E, bright: 0.25 + 0.4 * E, key: s.key + lift, mode: s.mode, oct: {} };
    // now and then a phrase gets one "spice": altered or tritone-substitute dominant, chromatic planing, a unison run, a microtonal scoop
    const prog = s.prog.ch, lastCh = prog[prog.length - 1];
    let spice = !st.loop && chance(0.08 + 0.3 * E) ? wpick(['alt', 'napol', 'plane', 'unison', 'slide'], [1.5, 1, 2, 1.5, 1.2]) : null;
    if (spice === 'alt' && !prog.some(([d, q]) => d === 18 && /^(d9|d13|d7|sus9|sus13|h7)$/.test(q))) spice = 'plane';
    if (spice === 'napol' && lastCh[0] !== 18 && lastCh[0] !== 5) spice = 'unison';
    p.spice = spice;
    let at = 0;
    prog.forEach(([deg, q, len, bassDeg], ci) => {
      let d2 = deg, q2 = q, bd = bassDeg;
      if (spice === 'alt' && deg === 18 && /^(d9|d13|d7|sus9|sus13|h7)$/.test(q)) q2 = pick(['d7s9', 'd7b9', 'd13']);
      if (spice === 'napol' && ci === prog.length - 1) { d2 = 3; q2 = 'd9'; bd = undefined; }   // a tritone-substitute (bII9) back home
      const L = Math.round(len * f), root = p.key + d2;
      let lo = bd === undefined ? root : p.key + bd;
      lo += 31 * Math.round((lastBass - lo) / 31); while (lo < -17) lo += 31; while (lo > 22) lo -= 31; lastBass = lo;   // bass: the nearest octave, in range
      p.chords.push({ at, len: L, root, lo, slash: bd !== undefined, q: Q[chance(0.18) && SUB[q2] ? pick(SUB[q2]) : q2] });
      at += L;
    });
    p.len = at; phraseNo++;
    const SL = M * 2, bars = p.len / M, g = s.g;
    // feel: the section's swing grid breathing a little bar to bar, its pocket, how far each bar strays from the part, articulation,
    // rubato in calm sections, a ritardando into the end of the section
    Object.assign(p, { M, grid: g.grid, pk: g.pk, barSw: Array.from({ length: bars }, () => rnd(0.88, 1.12)), lvl: Array.from({ length: bars }, (_, b) => varLvl(b, bars)), art: { rh: artPick(ART_W[s.type].rh), mel: artPick(ART_W[s.type].mel) }, rubato: !!st.rubato, rit: s.rit, ritFrom: idx === s.phrases - 1 && s.rit ? p.len - M : -1 });
    p.hits = E > 0.5 && g.hits.length && chance(0.65) ? g.hits.map(([b, i]) => b * M + i).filter((x) => x < p.len) : [];
    p.hitSet = new Set(p.hits); p.lastHit = p.hits[p.hits.length - 1]; p.hitBar7 = p.hits.some((h) => h >= (bars - 1) * M);
    p.choke = new Set(p.hits.flatMap((h) => [h + 1, h + 2]).filter((x) => x < p.len && !p.hitSet.has(x)));
    // --- melody: a form, a primary motif (new or reprised), developed, maybe answered by a second instrument ---
    const leadInst = wpick(st.lead, st.lead.map((x, i) => (x === lastLead ? 0.5 : 1) * (i === 0 ? 1.6 : 1))); lastLead = leadInst;
    const answerInst = pick([...st.orn, ...st.lead].filter((x) => x !== leadInst));
    const kind = LYRIC.has(leadInst) ? (E > 0.75 && chance(0.4) ? 'riff' : 'lyric') : chance(0.7) ? 'riff' : 'lick';
    const form = st.loop && idx === 0 ? 'loop' : wpick(['AABA', 'call', 'trade', 'line', 'sparse', 'tutti', 'canon'], [2.4, E > 0.4 ? 1.6 : 0.8, E > 0.6 ? 1.2 : 0.4, !LYRIC.has(leadInst) ? 0 : E < 0.5 ? 1.8 : 0.6, E < 0.45 ? 1.5 : 0.4, E > 0.72 ? 1.3 : 0, kind === 'lyric' && E > 0.3 && E < 0.8 ? 1 : 0]);
    const { m, reprise } = takeMotif(kind, leadInst, s.type, p.mode);
    const A = develop(m.notes, leadInst, reprise ? 1 + (chance(0.35) ? 1 : 0) : 0), A2 = develop(A.notes, leadInst, chance(0.6) ? 0 : 1), B = develop(A.notes, answerInst, 1);
    const avoid = new Set(), vel = 0.95, canon = form === 'canon' ? pick([4, 6, 8]) : 0;
    // a short idea gets a varied consequent in the same slot (likelier as the energy rises); tutti doubles the lead on the answering
    // instrument, and canon has that instrument imitate the lead a beat or two behind in the second and fourth statements. Every
    // statement after the first gets a few improvised touches, and its articulation may shift from the phrase's.
    const grown = new Map(), grow = (ns, inst) => {   // decided once per idea, so its repeats in this phrase share the same answer
      if (!grown.has(ns)) grown.set(ns, span(ns) <= SL / 2 && chance(0.25 + 0.6 * E) ? ns.concat(develop(ns, inst, 1).notes.map((n) => ({ ...n, o: n.o + Math.ceil(span(ns) / 4) * 4 }))) : ns);
      return grown.get(ns);
    };
    const slot = (i, notes, inst, last = false) => {
      let ns = embellish(form === 'sparse' ? notes : grow(notes, inst), i === 0 ? (chance(0.3) ? 0.6 : 0) : 0.4 + 0.7 * E, spice === 'slide' && i === 2);
      if (spice === 'slide' && i === 2 && ns.length) {   // the B statement's longest note scoops in from a microtone below
        const lng = ns.reduce((a, b) => (b.l > a.l ? b : a));
        ns = inst === 'lead' ? ns.map((n) => (n === lng ? { ...n, bend: pick([-2, -3]) } : n)) : [...ns, { o: Math.max(0, lng.o - 0.25), l: 0.25, d: lng.d, x: -2, a: 0.5 }].sort((a, b) => a.o - b.o);
      }
      const art = clamp(p.art.mel * (i === 0 ? 1 : pick([1, 1, 0.72, 1.18])), 0.35, 1.15), echo = inst === leadInst && (form === 'tutti' || (canon && i % 2));
      const end = (i + 1) * SL - (spice === 'unison' && (i + 1) * SL >= p.len ? 6 : 0);
      for (const o of realise(p, ns, i * SL, end, inst, vel, { last, art })) avoid.add(o);
      if (echo) for (const o of realise(p, ns.map((n) => ({ ...n, o: n.o + canon })), i * SL, end, answerInst, vel * (canon ? 0.55 : 0.6), { last, art })) avoid.add(o);
    };
    if (form === 'loop') { /* the mantra's first phrase is the riff alone */ }
    else if (form === 'AABA' || form === 'tutti' || form === 'canon') { slot(0, A.notes, leadInst); slot(1, A2.notes, leadInst); slot(2, develop(A.notes, leadInst, 1).notes, leadInst); slot(3, A2.notes, leadInst, true); }
    else if (form === 'call') { slot(0, A.notes, leadInst); slot(1, B.notes, answerInst); slot(2, A2.notes, leadInst); slot(3, develop(B.notes, answerInst, chance(0.5) ? 1 : 0).notes, answerInst, true); }
    else if (form === 'trade') { slot(0, A.notes, leadInst); slot(1, B.notes, answerInst); slot(2, develop(B.notes, leadInst, 0).notes, leadInst); slot(3, develop(A.notes, answerInst, 1).notes, answerInst, true); }
    else if (form === 'line') { const L = TF.augment(A.notes); slot(0, L, leadInst); slot(1, L.map((n) => ({ ...n, o: n.o - SL })).filter((n) => n.o >= 0), leadInst); slot(2, develop(L, leadInst, 1).notes, leadInst); slot(3, A2.notes, leadInst, true); }
    else { slot(0, A.notes, leadInst); slot(2, A2.notes, leadInst, true); }
    const artName = (a) => Object.keys(ART).find((x) => ART[x] === a);
    note(`  phrase ${idx} @${nextT.toFixed(3)}s key ${p.key} ${p.mode} E ${E.toFixed(2)} form ${form} lead ${leadInst} motif #${m.id} ${reprise ? `REPRISE (born on ${m.inst} in ${m.type}) via ${A.tf.join('+') || '-'}` : `new ${kind}`}${form === 'call' || form === 'trade' ? ` answered by ${answerInst} via ${B.tf.join('+')}` : form === 'tutti' || form === 'canon' ? ` with ${answerInst}` : ''} · art ${artName(p.art.mel)}/${artName(p.art.rh)}${p.hits.length ? ' · hits' : ''}${spice ? ` · spice ${spice}` : ''}${breakdown ? ' [breakdown]' : ''}`);
    // --- keys: flowing arpeggios, or chords on the changes plus the section's stab rhythm ---
    const keysInst = pick(st.keys), flow = st.flow && chance(0.65);
    if (flow) {
      const seqs = [[0, 1, 2, 3, 2, 1, 2, 3], [0, 2, 1, 3, 0, 2, 1, 3], [3, 2, 1, 0, 1, 2, 3, 2], [0, 1, 3, 2, 0, 1, 3, 2]], seq = pick(seqs), fl = S16 * (2 + 2 * p.art.rh);
      for (const c of p.chords) { const v = voiceLead(core(c), 46, 84); for (let i = 0; i < c.len; i += 2) { const s2 = i === 0 ? 31 + c.lo : v[seq[(i / 2) % 8] % v.length], vv = (i === 0 ? 0.4 : i % 8 === 4 ? 0.32 : 0.27) * rnd(0.88, 1.1); put(p, c.at + i, (t) => piano(t, s2, vv, fl, rnd(-0.4, 0.4)), p.pk.keys); } }
    } else writeComp(p, s, E, keysInst);
    // --- spice: chromatic planing stabs (the next chord's shape slid in from a whole and a half step below) / a unison band run ---
    if (spice === 'plane') {
      const b = pick([3, bars - 1]), o = b * M, target = o + M < p.len ? chordAt(p, o + M) : p.chords[0], v = spread(voiceLead(target, 50, 84), 3);
      for (const [i, sh] of [[M - 2, -6], [M - 1, -3]]) put(p, o + i, (t) => { v.forEach((s2) => rhodes(t, s2 + sh, 0.55, S16 * 0.8)); brass(t, v.map((x) => x + sh), 0.5, S16 * 0.8); }, p.pk.keys);
    }
    if (spice === 'unison') {                // the band plays one pentatonic run together into the next phrase
      const P = PENTA[p.mode] || PENTA.M, up = chance(0.5), degs = [];
      for (let d = up ? -6 : 13; degs.length < 6; d += up ? 1 : -1) if (P.includes(mod7(d))) degs.push(d);
      const run = degs.map((d, i) => ({ o: i, l: 1, d, a: i === 5 ? 1.3 : 0.85 }));
      realise(p, run, p.len - 6, p.len, LYRIC.has(leadInst) ? leadInst : 'brass', 0.9, { art: 0.62 });
      for (const n of run) { const at2 = p.len - 6 + n.o, c = chordAt(p, at2); let b2 = degStep(p, n.d, 0); b2 += 31 * Math.round((c.lo + 9 - b2) / 31); put(p, at2, (t) => bass(t, b2, 0.72, S16 * 0.8), p.pk.b); }
    }
    // --- the mantra's layers: the riff doubled an octave up on electric harp from the second phrase ---
    if (st.loop && idx >= 1) for (let b = 0; b < bars; b++) for (const n of g.loop) {
      const pos = b * M + n.pos, c = chordAt(p, pos), s2 = c.lo + 62 + SCALE[p.mode][mod7(n.d)] + 31 * Math.floor(n.d / 7), v = (n.pos === 0 ? 0.42 : 0.32) * rnd(0.88, 1.1);
      put(p, pos, (t) => harp(t, s2, v, 0.3, true, 0.7, n.len * S16 * 0.9, 0.04), p.pk.orn);
    }
    // --- muted electric-harp scratch, when the section has one ---
    const scratch = g.scratch && E > 0.45 && leadInst !== 'eharp' && answerInst !== 'eharp';
    if (scratch) writeScratch(p, s);
    // --- pads: under everything, quieter as the energy rises; brass swells or stabs on the downbeats of loud phrases and on band hits ---
    const padOn = !st.meter && (E < 0.7 || chance(0.4)), bl = p.art.rh < 0.7 ? 1.2 : 3;
    for (const c of p.chords) {
      if (padOn) { const v = voiceLead(c, 46, 78), lvl = 1.15 - 0.6 * E; put(p, c.at, (t) => pad(t, v.slice(0, 3), c.len * S16, lvl)); }
      if (E > 0.78 && leadInst !== 'brass' && chance(0.5) && c.at % (M * 2) === 0) { const v = spread(voiceLead(c, 55, 80), 3), fall = bl < 2 && chance(0.4); put(p, c.at, (t) => brass(t, v, 0.5, S16 * bl, fall), p.pk.keys); }
    }
    if (E > 0.65 && leadInst !== 'brass') for (const h of p.hits) { const v = spread(voiceLead(chordAt(p, h), 55, 80), 3), fall = h === p.lastHit && chance(0.5); put(p, h, (t) => brass(t, v, 0.55, S16 * 1.4, fall), p.pk.keys); }
    // --- a guide-tone counterline (thirds and sevenths, each moving to the nearest) under plucked melodies ---
    const gs = ['lead', 'rhodes', 'brass'].filter((x) => x !== answerInst && x !== keysInst && (x !== 'brass' || E > 0.6));
    if (!LYRIC.has(leadInst) && form !== 'loop' && E > 0.25 && gs.length && chance(0.6)) {
      const gi = pick(gs);
      let prev = REG[gi] - 16;
      for (const c of p.chords) {
        const gt = [c.q[1], c.q[Math.min(3, c.q.length - 1)]].map((x) => { const v = pc(c.root + x); return v + 31 * Math.round((prev - v) / 31); }).reduce((a, b) => (Math.abs(b - prev) < Math.abs(a - prev) ? b : a));
        prev = gt; put(p, c.at, (t) => PLAY[gi](t, gt, c.len * 0.95, 0.4), p.pk.keys);
      }
      note(`    guide tones on ${gi}`);
    }
    // --- ornaments: a Euclidean pulse (sometimes on a cycle that runs against the bar) with its own shape, register, length and
    // instrument, on plain chord tones, kept out of the melody's way; some phrases go without ---
    const tap = st.tap && (idx === 0 || chance(0.6)), oc = st.orn.filter((x) => x !== leadInst && x !== answerInst && !(scratch && x === 'eharp')), ornInst = oc.length ? pick(oc) : st.orn.find((x) => x !== leadInst);
    if (ornInst && E > 0.12 && !tap && !flow && form !== 'loop' && chance(0.75)) {
      const cyc = pick([M, M, 2 * M, 12, 10, 6]), kk = clamp(Math.round((1 + E * 3.2 + rnd(-1, 1)) * cyc / M), 1, cyc - 2), rot = (Math.random() * cyc) | 0, mask = euclid(kk, cyc, rot);
      const shape = pick(['up', 'down', 'updown', 'pedal', 'dyad', 'skip']), lo = REG[ornInst] - 20, rest = (Math.random() * 2) | 0, ol = pick(E < 0.45 ? [2, 3, 8, 8] : E < 0.7 ? [1, 2, 3, 8] : [0.6, 1, 2]);
      let j = 0;
      for (let pos = 0; pos < p.len; pos++) {
        if (!mask[pos % cyc] || avoid.has(pos) || avoid.has(pos - 1) || (E < 0.45 && ((pos / M) | 0) % 2 === rest)) continue;
        const tones = chordTones(core(chordAt(p, pos)), lo, 44), n = tones.length;
        const ti = shape === 'up' ? j % n : shape === 'down' ? n - 1 - (j % n) : shape === 'updown' ? Math.abs(((j + n - 1) % (2 * n - 2)) - (n - 1)) : shape === 'skip' ? (j * 2) % n : j % 2 ? j % n : n - 2;
        const s2 = tones[ti], s3 = shape === 'dyad' ? tones[Math.min(ti + 2, n - 1)] : null, v = (0.24 + 0.14 * Math.sin(Math.PI * pos / p.len)) * (pos % 4 ? 0.9 : 1.08) * rnd(0.85, 1.12);
        put(p, pos, (t) => { PLAY[ornInst](t, s2, ol, v); if (s3 !== null) PLAY[ornInst](t + 0.012, s3, ol, v * 0.8); }, p.pk.orn);
        j++;
      }
      note(`    ornaments ${ornInst} E(${kk},${cyc}) rot ${rot} ${shape} len ${ol}`);
    }
    if (tap) {                                // the 7/8 interlude's electric-harp tapping, rotating each bar
      const cell = [0, 2, 4, 1, 3, 4, 2];
      for (let pos = 0; pos < p.len; pos++) { const tones = chordTones(core(chordAt(p, pos)), 55, 40), b = (pos / M) | 0, i = pos % M, s2 = tones[Math.min(tones.length - 1, cell[(i + b) % 7] + (i >= 7 ? 1 : 0))], v = ([0, 4, 8].includes(i) ? 0.48 : 0.28) * rnd(0.88, 1.1); put(p, pos, (t) => harp(t, s2, v, i % 2 ? 0.35 : -0.35, true), p.pk.orn); }
    }
    writeBass(p, s, E, idx);
    const dstyle = writeDrums(p, s, E, idx, breakdown);
    if (scratch || dstyle !== st.drums) note(`    band: drums ${dstyle}${scratch ? ', scratch' : ''}`);
    // --- an occasional quick lick into the next phrase, from the bank when possible ---
    if (!s.lastLick && chance(0.2 + 0.25 * E) && !tap && spice !== 'unison' && form !== 'loop') {
      const inst = pick(['eharp', 'harp', 'mallet', 'piano'].filter((x) => x !== leadInst)), lk = takeMotif('lick', inst, s.type, p.mode), notes = TF.diminish(develop(lk.m.notes, 'eharp', 1).notes);
      realise(p, notes, p.len - 4, p.len, inst, 0.6, { art: 0.7 });
      s.lastLick = true; note(`    lick on ${inst} from motif #${lk.m.id}${lk.reprise ? ' (reprise)' : ''}`);
    } else s.lastLick = false;
    if (idx === s.phrases - 1) put(p, p.len - 6, (t) => swell(t, S16 * 6));
    return p;
  }
  function stepAt(t) {                       // play one sixteenth: swing grid (breathing per bar) + each part's pocket
    const ev = ph.ev[k]; if (!ev) return;
    const tt = t + ph.grid[k % 4] * ph.barSw[(k / ph.M) | 0] * S16;
    for (const [frac, fn, dt] of ev) fn(tt + frac * S16 + dt);
  }
  function stepDur() {                       // this sixteenth's length: the section's tempo, breathing in rubato styles, stretching in a ritardando
    let d = S16;
    if (ph.rubato) d *= 1 + 0.035 * Math.sin(Math.PI * k / ph.M);
    if (ph.ritFrom >= 0 && k >= ph.ritFrom) d *= 1 + ph.rit * ((k - ph.ritFrom) / (ph.len - ph.ritFrom)) ** 2;
    return d;
  }
  function schedule(until) {
    while (nextT < until) {
      if (!ph) {
        if (!sec || sec.pi >= sec.phrases) { if (sec) nextT += sec.breath; newSection(); }   // a breath between sections, sometimes
        ph = planPhrase(); k = 0;
      }
      stepAt(nextT); nextT += stepDur();
      if (++k >= ph.len) { ph = null; sec.pi++; }
    }
  }
  let manual = false;                        // offline checks drive the scheduler themselves
  setInterval(() => { if (on && !manual && ctx.state === 'running') schedule(ctx.currentTime + (document.hidden ? 1.6 : 0.4)); }, 80);
  return {
    analyser, log,
    setOn(v) { if (v && !on) nextT = Math.max(nextT, ctx.currentTime + 0.12); on = v; master.gain.setTargetAtTime(v ? VOL : 0, ctx.currentTime, 0.4); },
    setTension(v) { tension = Math.max(tension, clamp(v, 0, 1)); },                                                            // 0..1 from the game (rally length)
    jump(type) { force = type; ph = null; if (sec) sec.pi = sec.phrases; },   // checks: start a section of the given style now
    voices: PLAY,                              // checks: one note on a named instrument
    renderAhead(until) { manual = on = true; master.gain.value = VOL; nextT = Math.max(nextT, ctx.currentTime + 0.05); schedule(until); },   // offline checks
    get state() { return { section: sec && sec.type, bpm: sec && sec.bpm, phrase: sec && sec.pi, energy: ph ? +ph.E.toFixed(2) : null, motifs: bank.length }; },
  };
}
