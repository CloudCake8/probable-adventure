8046c6a4: 9421ffb0  stwu       r1, -0x50(r1)
8046c6a8: 7c0802a6  mflr       r0
8046c6ac: c04210a8  lfs        f2, 0x10a8(r2) ; [806ff128] 3c23d70a f32=0.00999999978
8046c6b0: 90010054  stw        r0, 0x54(r1)
8046c6b4: c02210ac  lfs        f1, 0x10ac(r2) ; [806ff12c] 40c00000 f32=6
8046c6b8: dbe10040  stfd       f31, 0x40(r1)
8046c6bc: f3e10048  psq_st     f31, 72(r1), W=0, I=0
8046c6c0: dbc10030  stfd       f30, 0x30(r1)
8046c6c4: f3c10038  psq_st     f30, 56(r1), W=0, I=0
8046c6c8: 93e1002c  stw        r31, 0x2c(r1)
8046c6cc: 7c7f1b78  mr         r31, r3
8046c6d0: e083022c  psq_l      f4, 556(r3), W=0, I=0
8046c6d4: e06301b0  psq_l      f3, 432(r3), W=0, I=0
8046c6d8: e0038228  psq_l      f0, 552(r3), W=1, I=0
8046c6dc: 108400f2  ps_mul     f4, f4, f3
8046c6e0: e06381ac  psq_l      f3, 428(r3), W=1, I=0
8046c6e4: 106020fa  ps_madd    f3, f0, f3, f4
8046c6e8: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c6ec: 10632114  ps_sum0    f3, f3, f4, f4
8046c6f0: ffe01850  fneg       f31, f3
8046c6f4: efdf1028  fsubs      f30, f31, f2
8046c6f8: efde0072  fmuls      f30, f30, f1
8046c6fc: fc1e0040  fcmpo      cr0, f30, f0
8046c700: 40800008  bge        0x8046c708
8046c704: ffc00090  fmr        f30, f0
8046c708: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046c70c: fc1e0040  fcmpo      cr0, f30, f0
8046c710: 40810008  ble        0x8046c718
8046c714: ffc00090  fmr        f30, f0
8046c718: 80030188  lwz        r0, 0x188(r3)
8046c71c: 5400077f  clrlwi.    r0, r0, 0x1d
8046c720: 418200dc  beq        0x8046c7fc
8046c724: 80030178  lwz        r0, 0x178(r3)
8046c728: 2c000002  cmpwi      r0, 2
8046c72c: 41810014  bgt        0x8046c740
8046c730: c00210b0  lfs        f0, 0x10b0(r2) ; [806ff130] 3ecccccd f32=0.400000006
8046c734: fc1e0040  fcmpo      cr0, f30, f0
8046c738: 40800008  bge        0x8046c740
8046c73c: ffc00090  fmr        f30, f0
8046c740: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c744: fc1e1040  fcmpo      cr0, f30, f2
8046c748: 40810038  ble        0x8046c780
8046c74c: fc20f090  fmr        f1, f30
8046c750: 80630004  lwz        r3, 4(r3)
8046c754: 388003ae  li         r4, 0x3ae
8046c758: 4be4ab81  bl         0x802b72d8
8046c75c: 801f0250  lwz        r0, 0x250(r31)
8046c760: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8046c764: 4182001c  beq        0x8046c780
8046c768: 801f0178  lwz        r0, 0x178(r31)
8046c76c: 2c000001  cmpwi      r0, 1
8046c770: 40820010  bne        0x8046c780
8046c774: 807f0004  lwz        r3, 4(r31)
8046c778: 388003b5  li         r4, 0x3b5
8046c77c: 4be4ab61  bl         0x802b72dc
8046c780: 807f0188  lwz        r3, 0x188(r31)
8046c784: 546007bf  clrlwi.    r0, r3, 0x1e
8046c788: 4182006c  beq        0x8046c7f4
8046c78c: 801f0178  lwz        r0, 0x178(r31)
8046c790: 2c000001  cmpwi      r0, 1
8046c794: 41810024  bgt        0x8046c7b8
8046c798: 546007bd  rlwinm.    r0, r3, 0, 0x1e, 0x1e
8046c79c: 4182000c  beq        0x8046c7a8
8046c7a0: 7fe3fb78  mr         r3, r31
8046c7a4: 4bfffc11  bl         0x8046c3b4
8046c7a8: 7fe3fb78  mr         r3, r31
8046c7ac: 38800004  li         r4, 4
8046c7b0: 4bfff975  bl         0x8046c124
8046c7b4: 48000024  b          0x8046c7d8
8046c7b8: 546007bd  rlwinm.    r0, r3, 0, 0x1e, 0x1e
8046c7bc: 4182001c  beq        0x8046c7d8
8046c7c0: c00da00c  lfs        f0, -0x5ff4(r13) ; [806f212c] 3dcccccd f32=0.100000001
8046c7c4: fc1f0040  fcmpo      cr0, f31, f0
8046c7c8: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c7cc: 4082000c  bne        0x8046c7d8
8046c7d0: 7fe3fb78  mr         r3, r31
8046c7d4: 4bfffbe1  bl         0x8046c3b4
8046c7d8: c00da008  lfs        f0, -0x5ff8(r13) ; [806f2128] 3cf5c28f f32=0.0299999993
8046c7dc: fc1f0040  fcmpo      cr0, f31, f0
8046c7e0: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c7e4: 40820010  bne        0x8046c7f4
8046c7e8: 7fe3fb78  mr         r3, r31
8046c7ec: 38800000  li         r4, 0
8046c7f0: 4bfff935  bl         0x8046c124
8046c7f4: 7fe3fb78  mr         r3, r31
8046c7f8: 4bfffd31  bl         0x8046c528
8046c7fc: 807f0188  lwz        r3, 0x188(r31)
8046c800: 54600739  rlwinm.    r0, r3, 0, 0x1c, 0x1c
8046c804: 41820070  beq        0x8046c874
8046c808: 7c6018f8  nor        r0, r3, r3
8046c80c: 540006b5  rlwinm.    r0, r0, 0, 0x1a, 0x1a
8046c810: 41820064  beq        0x8046c874
8046c814: c0021068  lfs        f0, 0x1068(r2) ; [806ff0e8] 3ba3d70a f32=0.00499999989
8046c818: c04210b4  lfs        f2, 0x10b4(r2) ; [806ff134] 41c80000 f32=25
8046c81c: ec3f0028  fsubs      f1, f31, f0
8046c820: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c824: ec2100b2  fmuls      f1, f1, f2
8046c828: fc010040  fcmpo      cr0, f1, f0
8046c82c: 40800008  bge        0x8046c834
8046c830: fc200090  fmr        f1, f0
8046c834: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046c838: fc010040  fcmpo      cr0, f1, f0
8046c83c: 40810008  ble        0x8046c844
8046c840: fc200090  fmr        f1, f0
8046c844: 807f0004  lwz        r3, 4(r31)
8046c848: 388003b0  li         r4, 0x3b0
8046c84c: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c850: 4be4aa89  bl         0x802b72d8
8046c854: c00da010  lfs        f0, -0x5ff0(r13) ; [806f2130] 3c23d70a f32=0.00999999978
8046c858: fc1f0040  fcmpo      cr0, f31, f0
8046c85c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c860: 40820014  bne        0x8046c874
8046c864: 806dd678  lwz        r3, -0x2988(r13)
8046c868: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046c86c: 80630164  lwz        r3, 0x164(r3)
8046c870: 4bfed051  bl         0x804598c0
8046c874: 801f0188  lwz        r0, 0x188(r31)
8046c878: 540006b7  rlwinm.    r0, r0, 0, 0x1a, 0x1b
8046c87c: 41820208  beq        0x8046ca84
8046c880: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c884: fc1e1040  fcmpo      cr0, f30, f2
8046c888: 408100cc  ble        0x8046c954
8046c88c: a01f0190  lhz        r0, 0x190(r31)
8046c890: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8046c894: 41820014  beq        0x8046c8a8
8046c898: fc20f090  fmr        f1, f30
8046c89c: 807f0004  lwz        r3, 4(r31)
8046c8a0: 388003af  li         r4, 0x3af
8046c8a4: 4be4aa35  bl         0x802b72d8
8046c8a8: a01f0190  lhz        r0, 0x190(r31)
8046c8ac: 540007ff  clrlwi.    r0, r0, 0x1f
8046c8b0: 41820018  beq        0x8046c8c8
8046c8b4: fc20f090  fmr        f1, f30
8046c8b8: 807f0004  lwz        r3, 4(r31)
8046c8bc: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c8c0: 388003b1  li         r4, 0x3b1
8046c8c4: 4be4aa15  bl         0x802b72d8
8046c8c8: a01f0190  lhz        r0, 0x190(r31)
8046c8cc: 5400077b  rlwinm.    r0, r0, 0, 0x1d, 0x1d
8046c8d0: 41820018  beq        0x8046c8e8
8046c8d4: fc20f090  fmr        f1, f30
8046c8d8: 807f0004  lwz        r3, 4(r31)
8046c8dc: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c8e0: 388003b2  li         r4, 0x3b2
8046c8e4: 4be4a9f5  bl         0x802b72d8
8046c8e8: a01f0190  lhz        r0, 0x190(r31)
8046c8ec: 54000739  rlwinm.    r0, r0, 0, 0x1c, 0x1c
8046c8f0: 41820018  beq        0x8046c908
8046c8f4: fc20f090  fmr        f1, f30
8046c8f8: 807f0004  lwz        r3, 4(r31)
8046c8fc: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c900: 388003b3  li         r4, 0x3b3
8046c904: 4be4a9d5  bl         0x802b72d8
8046c908: a07f0190  lhz        r3, 0x190(r31)
8046c90c: 546006f7  rlwinm.    r0, r3, 0, 0x1b, 0x1b
8046c910: 40820014  bne        0x8046c924
8046c914: 54600673  rlwinm.    r0, r3, 0, 0x19, 0x19
8046c918: 4082000c  bne        0x8046c924
8046c91c: 54600631  rlwinm.    r0, r3, 0, 0x18, 0x18
8046c920: 41820034  beq        0x8046c954
8046c924: 801f0188  lwz        r0, 0x188(r31)
8046c928: 540006b5  rlwinm.    r0, r0, 0, 0x1a, 0x1a
8046c92c: 41820014  beq        0x8046c940
8046c930: c00210a4  lfs        f0, 0x10a4(r2) ; [806ff124] 3e99999a f32=0.300000012
8046c934: fc1e0040  fcmpo      cr0, f30, f0
8046c938: 40800008  bge        0x8046c940
8046c93c: ffc00090  fmr        f30, f0
8046c940: fc20f090  fmr        f1, f30
8046c944: 807f0004  lwz        r3, 4(r31)
8046c948: c0421034  lfs        f2, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c94c: 388003b4  li         r4, 0x3b4
8046c950: 4be4a989  bl         0x802b72d8
8046c954: 801f0188  lwz        r0, 0x188(r31)
8046c958: 540006f7  rlwinm.    r0, r0, 0, 0x1b, 0x1b
8046c95c: 4182006c  beq        0x8046c9c8
8046c960: c00da008  lfs        f0, -0x5ff8(r13) ; [806f2128] 3cf5c28f f32=0.0299999993
8046c964: fc1f0040  fcmpo      cr0, f31, f0
8046c968: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c96c: 40820050  bne        0x8046c9bc
8046c970: a07f0190  lhz        r3, 0x190(r31)
8046c974: 546007ff  clrlwi.    r0, r3, 0x1f
8046c978: 41820014  beq        0x8046c98c
8046c97c: 7fe3fb78  mr         r3, r31
8046c980: 38800001  li         r4, 1
8046c984: 4bfff7a1  bl         0x8046c124
8046c988: 48000034  b          0x8046c9bc
8046c98c: 5460077b  rlwinm.    r0, r3, 0, 0x1d, 0x1d
8046c990: 41820020  beq        0x8046c9b0
8046c994: 7fe3fb78  mr         r3, r31
8046c998: 38800002  li         r4, 2
8046c99c: 4bfff789  bl         0x8046c124
8046c9a0: 801f0250  lwz        r0, 0x250(r31)
8046c9a4: 540007b8  rlwinm     r0, r0, 0, 0x1e, 0x1c
8046c9a8: 901f0250  stw        r0, 0x250(r31)
8046c9ac: 48000010  b          0x8046c9bc
8046c9b0: 7fe3fb78  mr         r3, r31
8046c9b4: 38800003  li         r4, 3
8046c9b8: 4bfff76d  bl         0x8046c124
8046c9bc: 7fe3fb78  mr         r3, r31
8046c9c0: 4bfffb69  bl         0x8046c528
8046c9c4: 480000c0  b          0x8046ca84
8046c9c8: 801f0178  lwz        r0, 0x178(r31)
8046c9cc: 2c000001  cmpwi      r0, 1
8046c9d0: 40810014  ble        0x8046c9e4
8046c9d4: c00da00c  lfs        f0, -0x5ff4(r13) ; [806f212c] 3dcccccd f32=0.100000001
8046c9d8: fc1f0040  fcmpo      cr0, f31, f0
8046c9dc: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c9e0: 40820088  bne        0x8046ca68
8046c9e4: c08d9fd4  lfs        f4, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046c9e8: 38810008  addi       r4, r1, 8
8046c9ec: e01f0228  psq_l      f0, 552(r31), W=0, I=0
8046c9f0: 38a10014  addi       r5, r1, 0x14
8046c9f4: 801f0008  lwz        r0, 8(r31)
8046c9f8: 10200118  ps_muls0   f1, f0, f4
8046c9fc: 807f000c  lwz        r3, 0xc(r31)
8046ca00: 90010014  stw        r0, 0x14(r1)
8046ca04: e01f8230  psq_l      f0, 560(r31), W=1, I=0
8046ca08: 90610018  stw        r3, 0x18(r1)
8046ca0c: 801f0010  lwz        r0, 0x10(r31)
8046ca10: f0240000  psq_st     f1, 0(r4), W=0, I=0
8046ca14: 10200118  ps_muls0   f1, f0, f4
8046ca18: e0650000  psq_l      f3, 0(r5), W=0, I=0
8046ca1c: e0040000  psq_l      f0, 0(r4), W=0, I=0
