# Sp2Snd sound system: table-tennis SFX (NW4R brsar / rseq / rbnk / rwar)

Tools: `sfx_correct/render.py`, `run_all.py` (renders + manifest.json), `rseq_dis.py` (rseq disassembler), `rbnk2.py` (correct 2-level rbnk parser), `wavedec.py`. Output: `sfx_correct/wav/*.wav`, `sfx_correct/manifest.json`.

## Chain (RECOVERED from Sp2Snd.brsar bytes)
1. brsar SoundInfo (tools/brsar.py layout): volume u8 @0x14 (e.g. HIT_NORMAL 120, BOUND_NORMAL 115, SWING_S 90, THROW_UP 60). Sequence detail = (label offset into the rseq DATA, bank id). No pitch/pan in sequence sounds.
2. All SE_PNG_* sequences share one RSEQ (file @12236256, cmd base 12236300) and bank 13 = SP2_SND_BANK_SE_PNG (rbnk @12241056, rwar @12277344, 141 waves). `assets/audio/Sound/Static/Sp2Snd/rwar006` IS this archive: waveNNN.wav is sample-exact equal to my decode of wave NNN (maxdiff 0), but those files are the nibble-correct length; waveNNN rate is the RWAV rate.
3. rseq per sound (opcodes disassembled): `a0 f0 80 v lo hi` (var = rand), `88` open track, `81` program, `c3` transpose (semitones, here var/rand 0..2 or 0..1), `c1` track volume (rand 100..120 / 110..120), `c4` pitch bend s8 (bend range default 2 st, so +-64 = +-1.0 st), `d8` (MAT only, value 30, unknown effect), then ONE note: key, vel, len 0. Randomisation is real: transpose and volume are random per play; SMASH/NET/LAWN/swing bend is random +-64.
4. rbnk: program -> key level -> velocity level -> InstParam. InstParam: wave s32, A,D,S,R,hold, orig_key @+12, volume @+13, pan @+14, tune f32 @+16 (all fields were extracted correctly).
5. Pitch ratio = 2^((key + transpose - orig_key + bend*2/127)/12) * tune; played from the wave at its own RWAV rate. Gain (INFERRED, standard NW4R/SDAT squares): sound_vol/127 * inst_vol/127 * (vel/127)^2 * (track_vol/127)^2.
6. Envelope: A=127 D=127 S=127 for all PNG instruments (instant, full), R 80..123. len=0 is NOT an immediate note-off (INFERRED: WHISTLE_START is one len-0 note that must ring the full 0.87 s wave). Waves used are non-looping, so voice ends with the sample.

## The bug (RECOVERED)
The extractor (tools/sound_index.py `rbnk()`) treats a type-3 (index table: u8 min,u8 max,u16 pad, refs) at the program level as a VELOCITY table. In the real format the first level is the KEY level, so index = KEY. Program 0 (all ball hit/bound sounds) is a 128-entry key-indexed table: key 24 -> wave 4, 26 -> 6, 36 -> 7, 48 -> wave 10, 50 -> 12, 60 -> 13, 72 -> 16, 84 -> 17, 96 -> 18, 108 -> 19; orig_key equals the note keys used by the sequences (12,24,36,...,108), i.e. unity pitch. `assets/audio/banks/*.json` therefore list `velocity_splits` that are really key splits; `base_note` is correct (field @+12 = orig key; not a mixup). sequences.mjs then looked up velocity 120 -> index 120 -> wave 21 (orig 110): -60..-62 semitones, giving the 4-30 s thuds. Programs where the key level is a range table (type 2: whistle 3, swing 7/8, slipper 26, smash-shot 21) were already correct: new SWING_L / WHISTLE_END envelopes match old files to within 1 dB.
Same bug exists for index-table programs in other banks: BGM_BIC p0, SE_ARC p25, SE_BSK p5, SE_CAN p3, SE_PNG p0,10,14,15, SE_SWF p8, SE_SWF_KUMITE p8-13 (rendered sounds using them are wrong; re-render after fixing `rbnk()` / the lookup in sequences.mjs: index by key, then velocity range, not the reverse).

## Two tracks (RECOVERED structure, effect INFERRED)
Most hit/bound sounds do `opentrack 1 @X` where X is the code the root track continues into (HIT/BOUND_NORMAL/DRIVE/CUT/SMASH, slippers, BOUND_SMASH has two identical copies), so two identical voices start together = +6 dB coherent. The manifest keeps both voices and bakes the sum. Single-voice: NET, WOOD, MAT, GROUND, LAWN, WATER, swings.

## Wave sounds (RWSD, RECOVERED)
THROW_UP / _CSPK = wave 0 and BALL_HIT_FACE = wave 8 of RWAR @15106880: wsd pitch 1.0, note orig key 60, vol 127, pan 64, release 110/90 -> native-rate playback; gain = brsar volume/127 (60 / 90).

## Mapping used (canonical = transpose 0, bend 0, track vol mid)
HIT_NORMAL: key48 -> wave10 (32 kHz), x1.0, 2 layers. DRIVE: key60 -> wave13. CUT: key60 -> wave13, bend +64 => x1.060. SMASH: key72 -> wave16, bend rand +-64. SLIPPER (prog 26): NORMAL w22, DRIVE/CUT w25 (CUT x1.06), SMASH key74 -> w28 orig 72 (x1.122, 28 kHz). CSPK = same sequence labels as non-CSPK (identical audio; presumably only the output route differs, UNKNOWN). FACE = wave8.
BOUND: NORMAL key24 -> w4; WOOD key24 w4 bend 224=-32 (x0.971); MAT w4 bend -64 (x0.943) + d8 30; NET key96 -> w18 bend rand; SMASH key84 -> w17; GROUND key36 -> w7; LAWN key108 -> w19; WATER key12 -> w0 (22.05 kHz).
SWING_S key36 -> w40; SWING_L key60 -> w42; JUMP_SWING_L: w45 (key82 vs orig 84, x0.891) + w32 at +0.25 s; SMASH_SHOT: w116 at 0 + w117 at +0.0625 s. WHISTLE_START w34 (0.87 s); MISS w33 (0.28 s); END w33 then w34 at +0.333 s. (Tempo/timebase assumed NW4R default 120 BPM x 48 ppqn, no tempo command in these sequences: INFERRED.)

## Unknowns
- Exact NW4R volume law (squares vs. linear), release/len-0 handling; `d8` (MAT, probably LPF cutoff); output scale. Relative gains in manifest are INFERRED.
- Per-play randomisation is not baked; apply 2^(x/12) playback-rate jitter per `in_game_random`.
- Whether the doubled voice really sums (assumed yes).
