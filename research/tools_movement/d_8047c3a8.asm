8047c3a8: 9421fff0  stwu       r1, -0x10(r1)
8047c3ac: 7c0802a6  mflr       r0
8047c3b0: 90010014  stw        r0, 0x14(r1)
8047c3b4: 93e1000c  stw        r31, 0xc(r1)
8047c3b8: 7c7f1b78  mr         r31, r3
8047c3bc: 80630008  lwz        r3, 8(r3)
8047c3c0: 4bfe27d9  bl         0x8045eb98
8047c3c4: 3880000a  li         r4, 0xa
8047c3c8: 4bfee091  bl         0x8046a458
8047c3cc: c0230010  lfs        f1, 0x10(r3)
8047c3d0: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047c3d4: fc010040  fcmpo      cr0, f1, f0
8047c3d8: 4080004c  bge        0x8047c424
8047c3dc: c0230004  lfs        f1, 4(r3)
8047c3e0: c00213ec  lfs        f0, 0x13ec(r2) ; [806ff46c] 40800000 f32=4
8047c3e4: fc010040  fcmpo      cr0, f1, f0
8047c3e8: 4080003c  bge        0x8047c424
8047c3ec: 807f0008  lwz        r3, 8(r31)
8047c3f0: 4bfe2329  bl         0x8045e718
8047c3f4: 38000001  li         r0, 1
8047c3f8: 907f01dc  stw        r3, 0x1dc(r31)
8047c3fc: 7c641b78  mr         r4, r3
8047c400: 807f0048  lwz        r3, 0x48(r31)
8047c404: 901f01c8  stw        r0, 0x1c8(r31)
8047c408: c03f01cc  lfs        f1, 0x1cc(r31)
8047c40c: c05f01d0  lfs        f2, 0x1d0(r31)
8047c410: c06da190  lfs        f3, -0x5e70(r13) ; [806f22b0] 42f00000 f32=120
8047c414: 4800144d  bl         0x8047d860
8047c418: 7fe3fb78  mr         r3, r31
8047c41c: 38800002  li         r4, 2
8047c420: 480004c5  bl         0x8047c8e4
8047c424: 80010014  lwz        r0, 0x14(r1)
8047c428: 83e1000c  lwz        r31, 0xc(r1)
8047c42c: 7c0803a6  mtlr       r0
8047c430: 38210010  addi       r1, r1, 0x10
8047c434: 4e800020  blr        
8047c438: 9421fff0  stwu       r1, -0x10(r1)
8047c43c: 7c0802a6  mflr       r0
8047c440: 90010014  stw        r0, 0x14(r1)
8047c444: 808301a4  lwz        r4, 0x1a4(r3)
8047c448: 3404ffff  addic.     r0, r4, -1
8047c44c: 900301a4  stw        r0, 0x1a4(r3)
8047c450: 4181008c  bgt        0x8047c4dc
8047c454: 38000001  li         r0, 1
8047c458: 900301d4  stw        r0, 0x1d4(r3)
8047c45c: 3c8041c6  lis        r4, 0x41c6
8047c460: 38adcff0  addi       r5, r13, -0x3010
8047c464: 80cdcff0  lwz        r6, -0x3010(r13)
8047c468: 38044e6d  addi       r0, r4, 0x4e6d
8047c46c: 80850004  lwz        r4, 4(r5)
8047c470: 7cc601d6  mullw      r6, r6, r0
8047c474: 548007ff  clrlwi.    r0, r4, 0x1f
8047c478: 38063039  addi       r0, r6, 0x3039
8047c47c: 900dcff0  stw        r0, -0x3010(r13)
8047c480: 41820010  beq        0x8047c490
8047c484: 6c800001  xoris      r0, r4, 1
8047c488: 68001020  xori       r0, r0, 0x1020
8047c48c: 90050004  stw        r0, 4(r5)
8047c490: 38edcff0  addi       r7, r13, -0x3010
8047c494: 3c004330  lis        r0, 0x4330
8047c498: 80c70004  lwz        r6, 4(r7)
8047c49c: 38800004  li         r4, 4
8047c4a0: 80adcff0  lwz        r5, -0x3010(r13)
8047c4a4: 54c6f87e  srwi       r6, r6, 1
8047c4a8: 90010008  stw        r0, 8(r1)
8047c4ac: 7ca03278  xor        r0, r5, r6
8047c4b0: c84213f8  lfd        f2, 0x13f8(r2) ; [806ff478] 43300000 f32=176
8047c4b4: 5400fb3e  rlwinm     r0, r0, 0x1f, 0xc, 0x1f
8047c4b8: c00213f0  lfs        f0, 0x13f0(r2) ; [806ff470] 497ffff0 f32=1048575
8047c4bc: 6c008000  xoris      r0, r0, 0x8000
8047c4c0: 9001000c  stw        r0, 0xc(r1)
8047c4c4: c8210008  lfd        f1, 8(r1)
8047c4c8: 90c70004  stw        r6, 4(r7)
8047c4cc: ec211028  fsubs      f1, f1, f2
8047c4d0: ec010024  fdivs      f0, f1, f0
8047c4d4: d00301d8  stfs       f0, 0x1d8(r3)
8047c4d8: 4800040d  bl         0x8047c8e4
8047c4dc: 80010014  lwz        r0, 0x14(r1)
8047c4e0: 7c0803a6  mtlr       r0
8047c4e4: 38210010  addi       r1, r1, 0x10
8047c4e8: 4e800020  blr        
8047c4ec: 9421fff0  stwu       r1, -0x10(r1)
8047c4f0: 7c0802a6  mflr       r0
8047c4f4: 90010014  stw        r0, 0x14(r1)
8047c4f8: 93e1000c  stw        r31, 0xc(r1)
8047c4fc: 7c7f1b78  mr         r31, r3
8047c500: 80830008  lwz        r4, 8(r3)
8047c504: 80040018  lwz        r0, 0x18(r4)
8047c508: 2c000000  cmpwi      r0, 0
8047c50c: 40820044  bne        0x8047c550
8047c510: 7c832378  mr         r3, r4
8047c514: 4bfe2685  bl         0x8045eb98
8047c518: 2c030000  cmpwi      r3, 0
8047c51c: 41820034  beq        0x8047c550
8047c520: 80630194  lwz        r3, 0x194(r3)
8047c524: 38000001  li         r0, 1
8047c528: 2c030001  cmpwi      r3, 1
8047c52c: 41820010  beq        0x8047c53c
8047c530: 2c030002  cmpwi      r3, 2
8047c534: 41820008  beq        0x8047c53c
8047c538: 38000000  li         r0, 0
8047c53c: 2c000000  cmpwi      r0, 0
8047c540: 40820010  bne        0x8047c550
8047c544: 7fe3fb78  mr         r3, r31
8047c548: 38800000  li         r4, 0
8047c54c: 48000399  bl         0x8047c8e4
8047c550: 80010014  lwz        r0, 0x14(r1)
8047c554: 83e1000c  lwz        r31, 0xc(r1)
8047c558: 7c0803a6  mtlr       r0
8047c55c: 38210010  addi       r1, r1, 0x10
8047c560: 4e800020  blr        
8047c564: 808301c4  lwz        r4, 0x1c4(r3)
8047c568: 3404ffff  addic.     r0, r4, -1
8047c56c: 900301c4  stw        r0, 0x1c4(r3)
8047c570: 4d810020  bgtlr      
8047c574: 4800031c  b          0x8047c890
8047c578: 4e800020  blr        
8047c57c: 9421ffa0  stwu       r1, -0x60(r1)
8047c580: 7c0802a6  mflr       r0
8047c584: 90010064  stw        r0, 0x64(r1)
8047c588: 39610060  addi       r11, r1, 0x60
8047c58c: 4bb8b2c9  bl         0x80007854
8047c590: 80a30008  lwz        r5, 8(r3)
8047c594: 7c7f1b78  mr         r31, r3
8047c598: 7c9a2378  mr         r26, r4
8047c59c: 80050018  lwz        r0, 0x18(r5)
8047c5a0: 2c000000  cmpwi      r0, 0
8047c5a4: 40820010  bne        0x8047c5b4
8047c5a8: 38800003  li         r4, 3
8047c5ac: 48000339  bl         0x8047c8e4
8047c5b0: 480002c8  b          0x8047c878
8047c5b4: 806dd678  lwz        r3, -0x2988(r13)
8047c5b8: 8063017c  lwz        r3, 0x17c(r3)
8047c5bc: 81830000  lwz        r12, 0(r3)
8047c5c0: 818c004c  lwz        r12, 0x4c(r12)
8047c5c4: 7d8903a6  mtctr      r12
8047c5c8: 4e800421  bctrl      
8047c5cc: 2c030000  cmpwi      r3, 0
8047c5d0: 41820010  beq        0x8047c5e0
8047c5d4: 801f01b8  lwz        r0, 0x1b8(r31)
8047c5d8: 2c000000  cmpwi      r0, 0
8047c5dc: 4182029c  beq        0x8047c878
8047c5e0: 837f01dc  lwz        r27, 0x1dc(r31)
8047c5e4: 807f0008  lwz        r3, 8(r31)
8047c5e8: 4bfe2131  bl         0x8045e718
8047c5ec: 907f01dc  stw        r3, 0x1dc(r31)
8047c5f0: 807f0008  lwz        r3, 8(r31)
8047c5f4: 4bfe25a5  bl         0x8045eb98
8047c5f8: 2c030000  cmpwi      r3, 0
8047c5fc: 7c7c1b78  mr         r28, r3
8047c600: 41820278  beq        0x8047c878
8047c604: 807f0008  lwz        r3, 8(r31)
8047c608: 3881002c  addi       r4, r1, 0x2c
8047c60c: 38bc0008  addi       r5, r28, 8
8047c610: 4bfe2179  bl         0x8045e788
8047c614: 801f01bc  lwz        r0, 0x1bc(r31)
8047c618: 2c000000  cmpwi      r0, 0
8047c61c: 4082002c  bne        0x8047c648
8047c620: c0210034  lfs        f1, 0x34(r1)
8047c624: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047c628: fc010040  fcmpo      cr0, f1, f0
8047c62c: 4080001c  bge        0x8047c648
8047c630: 807f0048  lwz        r3, 0x48(r31)
8047c634: 809f01dc  lwz        r4, 0x1dc(r31)
8047c638: c03f01c0  lfs        f1, 0x1c0(r31)
8047c63c: 480012b9  bl         0x8047d8f4
8047c640: 38000001  li         r0, 1
8047c644: 901f01bc  stw        r0, 0x1bc(r31)
8047c648: 2c1a0000  cmpwi      r26, 0
8047c64c: 4082022c  bne        0x8047c878
8047c650: 4bfdddd9  bl         0x8045a428
8047c654: c0421400  lfs        f2, 0x1400(r2) ; [806ff480] 3f000000 f32=0.5
8047c658: c0010034  lfs        f0, 0x34(r1)
8047c65c: ec220072  fmuls      f1, f2, f1
8047c660: fc000840  fcmpo      cr0, f0, f1
8047c664: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047c668: 41820210  beq        0x8047c878
8047c66c: 7fe3fb78  mr         r3, r31
8047c670: 389f0188  addi       r4, r31, 0x188
8047c674: 480002cd  bl         0x8047c940
8047c678: 801f01dc  lwz        r0, 0x1dc(r31)
8047c67c: 7c00d800  cmpw       r0, r27
8047c680: 41820040  beq        0x8047c6c0
8047c684: 3b400000  li         r26, 0
8047c688: 3bc00000  li         r30, 0
8047c68c: 3fa0807d  lis        r29, -0x7f83
8047c690: 7c7ff214  add        r3, r31, r30
8047c694: 389d0318  addi       r4, r29, 0x318
8047c698: 3b630050  addi       r27, r3, 0x50
8047c69c: 7f63db78  mr         r3, r27
8047c6a0: 4bcb4651  bl         0x80130cf0
8047c6a4: 387b000c  addi       r3, r27, 0xc
8047c6a8: 389d0318  addi       r4, r29, 0x318
8047c6ac: 4bcb4645  bl         0x80130cf0
8047c6b0: 3b5a0001  addi       r26, r26, 1
8047c6b4: 3bde0018  addi       r30, r30, 0x18
8047c6b8: 2c1a000c  cmpwi      r26, 0xc
8047c6bc: 4180ffd4  blt        0x8047c690
8047c6c0: 7fe3fb78  mr         r3, r31
8047c6c4: 480003b9  bl         0x8047ca7c
8047c6c8: 2c030002  cmpwi      r3, 2
8047c6cc: 41820018  beq        0x8047c6e4
8047c6d0: 2c030000  cmpwi      r3, 0
8047c6d4: 418200dc  beq        0x8047c7b0
8047c6d8: 2c030001  cmpwi      r3, 1
8047c6dc: 4182019c  beq        0x8047c878
8047c6e0: 48000134  b          0x8047c814
8047c6e4: 807f0008  lwz        r3, 8(r31)
8047c6e8: 4bfe24b1  bl         0x8045eb98
8047c6ec: 2c030000  cmpwi      r3, 0
8047c6f0: 41820188  beq        0x8047c878
8047c6f4: 3880001e  li         r4, 0x1e
8047c6f8: 4bfedd61  bl         0x8046a458
8047c6fc: 2c030000  cmpwi      r3, 0
8047c700: 7c7a1b78  mr         r26, r3
8047c704: 41820174  beq        0x8047c878
8047c708: 80030020  lwz        r0, 0x20(r3)
8047c70c: 2c000001  cmpwi      r0, 1
8047c710: 41800168  blt        0x8047c878
8047c714: 807f0008  lwz        r3, 8(r31)
8047c718: 7f45d378  mr         r5, r26
8047c71c: 38810020  addi       r4, r1, 0x20
8047c720: 4bfe2069  bl         0x8045e788
8047c724: 807f0008  lwz        r3, 8(r31)
8047c728: 4bfe2ca5  bl         0x8045f3cc
8047c72c: 38810020  addi       r4, r1, 0x20
8047c730: e0030000  psq_l      f0, 0(r3), W=0, I=0
8047c734: e0240000  psq_l      f1, 0(r4), W=0, I=0
8047c738: 3ba10014  addi       r29, r1, 0x14
8047c73c: 10010028  ps_sub     f0, f1, f0
8047c740: e0248008  psq_l      f1, 8(r4), W=1, I=0
8047c744: f01d0000  psq_st     f0, 0(r29), W=0, I=0
8047c748: e0038008  psq_l      f0, 8(r3), W=1, I=0
8047c74c: 7fa3eb78  mr         r3, r29
8047c750: 10010028  ps_sub     f0, f1, f0
8047c754: f01d8008  psq_st     f0, 8(r29), W=1, I=0
8047c758: 4bbc3059  bl         0x8003f7b0
8047c75c: c0021404  lfs        f0, 0x1404(r2) ; [806ff484] 41f00000 f32=30
8047c760: fc010040  fcmpo      cr0, f1, f0
8047c764: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047c768: 41820110  beq        0x8047c878
8047c76c: 801a0020  lwz        r0, 0x20(r26)
8047c770: 2c000002  cmpwi      r0, 2
8047c774: 408000a0  bge        0x8047c814
8047c778: 807f0008  lwz        r3, 8(r31)
8047c77c: 4bfe2c1d  bl         0x8045f398
8047c780: e07d0004  psq_l      f3, 4(r29), W=0, I=0
8047c784: e043001c  psq_l      f2, 28(r3), W=0, I=0
8047c788: e03d8000  psq_l      f1, 0(r29), W=1, I=0
8047c78c: 106300b2  ps_mul     f3, f3, f2
8047c790: e0438018  psq_l      f2, 24(r3), W=1, I=0
8047c794: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047c798: 104118ba  ps_madd    f2, f1, f2, f3
8047c79c: 102218d4  ps_sum0    f1, f2, f3, f3
8047c7a0: fc010040  fcmpo      cr0, f1, f0
8047c7a4: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047c7a8: 4082006c  bne        0x8047c814
8047c7ac: 480000cc  b          0x8047c878
8047c7b0: 807f0008  lwz        r3, 8(r31)
8047c7b4: 4bfe2c19  bl         0x8045f3cc
8047c7b8: e03f0050  psq_l      f1, 80(r31), W=0, I=0
8047c7bc: 38810008  addi       r4, r1, 8
8047c7c0: e0030000  psq_l      f0, 0(r3), W=0, I=0
8047c7c4: 10010028  ps_sub     f0, f1, f0
8047c7c8: f0040000  psq_st     f0, 0(r4), W=0, I=0
8047c7cc: e0038008  psq_l      f0, 8(r3), W=1, I=0
8047c7d0: 7c832378  mr         r3, r4
8047c7d4: e03f8058  psq_l      f1, 88(r31), W=1, I=0
8047c7d8: 10010028  ps_sub     f0, f1, f0
8047c7dc: f0048008  psq_st     f0, 8(r4), W=1, I=0
8047c7e0: 4bbc2fd1  bl         0x8003f7b0
8047c7e4: c0021404  lfs        f0, 0x1404(r2) ; [806ff484] 41f00000 f32=30
8047c7e8: fc010040  fcmpo      cr0, f1, f0
8047c7ec: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047c7f0: 41820088  beq        0x8047c878
8047c7f4: 387f0170  addi       r3, r31, 0x170
8047c7f8: 389f0050  addi       r4, r31, 0x50
8047c7fc: 4bcb44f5  bl         0x80130cf0
8047c800: 387f017c  addi       r3, r31, 0x17c
8047c804: 389f005c  addi       r4, r31, 0x5c
8047c808: 4bcb44e9  bl         0x80130cf0
8047c80c: 48000008  b          0x8047c814
8047c810: 48000068  b          0x8047c878
8047c814: 801c0250  lwz        r0, 0x250(r28)
8047c818: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8047c81c: 41820054  beq        0x8047c870
8047c820: 807f0044  lwz        r3, 0x44(r31)
8047c824: c022140c  lfs        f1, 0x140c(r2) ; [806ff48c] 3f800000 f32=1
8047c828: 80630008  lwz        r3, 8(r3)
8047c82c: c0021408  lfs        f0, 0x1408(r2) ; [806ff488] 41000000 f32=8
8047c830: c0430034  lfs        f2, 0x34(r3)
8047c834: ec211028  fsubs      f1, f1, f2
8047c838: ec000072  fmuls      f0, f0, f1
8047c83c: fc00001e  fctiwz     f0, f0
8047c840: d8010038  stfd       f0, 0x38(r1)
8047c844: 8001003c  lwz        r0, 0x3c(r1)
8047c848: 901f01c4  stw        r0, 0x1c4(r31)
8047c84c: 2c000000  cmpwi      r0, 0
8047c850: 41810010  bgt        0x8047c860
8047c854: 7fe3fb78  mr         r3, r31
8047c858: 48000039  bl         0x8047c890
8047c85c: 4800001c  b          0x8047c878
8047c860: 7fe3fb78  mr         r3, r31
8047c864: 38800001  li         r4, 1
8047c868: 4800007d  bl         0x8047c8e4
8047c86c: 4800000c  b          0x8047c878
8047c870: 7fe3fb78  mr         r3, r31
8047c874: 4800001d  bl         0x8047c890
8047c878: 39610060  addi       r11, r1, 0x60
8047c87c: 4bb8b025  bl         0x800078a0
8047c880: 80010064  lwz        r0, 0x64(r1)
8047c884: 7c0803a6  mtlr       r0
8047c888: 38210060  addi       r1, r1, 0x60
8047c88c: 4e800020  blr        
8047c890: 9421fff0  stwu       r1, -0x10(r1)
8047c894: 7c0802a6  mflr       r0
8047c898: 90010014  stw        r0, 0x14(r1)
8047c89c: 38000001  li         r0, 1
8047c8a0: 93e1000c  stw        r31, 0xc(r1)
8047c8a4: 7c7f1b78  mr         r31, r3
8047c8a8: 900301c8  stw        r0, 0x1c8(r3)
8047c8ac: 80630048  lwz        r3, 0x48(r3)
8047c8b0: 809f01dc  lwz        r4, 0x1dc(r31)
8047c8b4: c03f01cc  lfs        f1, 0x1cc(r31)
8047c8b8: c05f01d0  lfs        f2, 0x1d0(r31)
8047c8bc: c06da18c  lfs        f3, -0x5e74(r13) ; [806f22ac] 42f00000 f32=120
8047c8c0: 48000fa1  bl         0x8047d860
8047c8c4: 7fe3fb78  mr         r3, r31
8047c8c8: 38800002  li         r4, 2
8047c8cc: 48000019  bl         0x8047c8e4
8047c8d0: 80010014  lwz        r0, 0x14(r1)
8047c8d4: 83e1000c  lwz        r31, 0xc(r1)
8047c8d8: 7c0803a6  mtlr       r0
8047c8dc: 38210010  addi       r1, r1, 0x10
8047c8e0: 4e800020  blr        
8047c8e4: 2c040003  cmpwi      r4, 3
8047c8e8: 40820050  bne        0x8047c938
8047c8ec: 3ca041c6  lis        r5, 0x41c6
8047c8f0: 80edcff0  lwz        r7, -0x3010(r13)
8047c8f4: 38054e6d  addi       r0, r5, 0x4e6d
8047c8f8: 38cdcff0  addi       r6, r13, -0x3010
8047c8fc: 7ce701d6  mullw      r7, r7, r0
8047c900: 80a60004  lwz        r5, 4(r6)
8047c904: 54a007ff  clrlwi.    r0, r5, 0x1f
8047c908: 38073039  addi       r0, r7, 0x3039
8047c90c: 900dcff0  stw        r0, -0x3010(r13)
8047c910: 41820010  beq        0x8047c920
8047c914: 6ca00001  xoris      r0, r5, 1
8047c918: 68001020  xori       r0, r0, 0x1020
8047c91c: 90060004  stw        r0, 4(r6)
8047c920: 38cdcff0  addi       r6, r13, -0x3010
8047c924: 38000078  li         r0, 0x78
8047c928: 80a60004  lwz        r5, 4(r6)
8047c92c: 54a5f87e  srwi       r5, r5, 1
8047c930: 90a60004  stw        r5, 4(r6)
8047c934: 900301a4  stw        r0, 0x1a4(r3)
8047c938: 9083004c  stw        r4, 0x4c(r3)
8047c93c: 4e800020  blr        
8047c940: 9421ffd0  stwu       r1, -0x30(r1)
8047c944: 7c0802a6  mflr       r0
8047c948: 90010034  stw        r0, 0x34(r1)
8047c94c: dbe10020  stfd       f31, 0x20(r1)
8047c950: f3e10028  psq_st     f31, 40(r1), W=0, I=0
8047c954: dbc10010  stfd       f30, 0x10(r1)
8047c958: f3c10018  psq_st     f30, 24(r1), W=0, I=0
8047c95c: 93e1000c  stw        r31, 0xc(r1)
8047c960: 7c9f2378  mr         r31, r4
8047c964: 93c10008  stw        r30, 8(r1)
8047c968: 7c7e1b78  mr         r30, r3
8047c96c: 4bfddac5  bl         0x8045a430
8047c970: c0021400  lfs        f0, 0x1400(r2) ; [806ff480] 3f000000 f32=0.5
8047c974: 801e01b0  lwz        r0, 0x1b0(r30)
8047c978: ec400072  fmuls      f2, f0, f1
8047c97c: c022140c  lfs        f1, 0x140c(r2) ; [806ff48c] 3f800000 f32=1
8047c980: c0021410  lfs        f0, 0x1410(r2) ; [806ff490] 40a00000 f32=5
8047c984: 2c000000  cmpwi      r0, 0
8047c988: efe20828  fsubs      f31, f2, f1
8047c98c: efdf0028  fsubs      f30, f31, f0
8047c990: 4182001c  beq        0x8047c9ac
8047c994: fc20f850  fneg       f1, f31
8047c998: c05e01a8  lfs        f2, 0x1a8(r30)
8047c99c: ec1f0828  fsubs      f0, f31, f1
8047c9a0: ec02083a  fmadds     f0, f2, f0, f1
8047c9a4: d01f0000  stfs       f0, 0(r31)
8047c9a8: 4800008c  b          0x8047ca34
8047c9ac: 807e0008  lwz        r3, 8(r30)
8047c9b0: 4bfe2559  bl         0x8045ef08
8047c9b4: 4bfe2a19  bl         0x8045f3cc
8047c9b8: c0230000  lfs        f1, 0(r3)
8047c9bc: c0021410  lfs        f0, 0x1410(r2) ; [806ff490] 40a00000 f32=5
8047c9c0: fc200850  fneg       f1, f1
8047c9c4: fc010040  fcmpo      cr0, f1, f0
8047c9c8: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047c9cc: 40820020  bne        0x8047c9ec
8047c9d0: fc00f850  fneg       f0, f31
8047c9d4: c05e01a8  lfs        f2, 0x1a8(r30)
8047c9d8: fc20f050  fneg       f1, f30
8047c9dc: ec000828  fsubs      f0, f0, f1
8047c9e0: ec02083a  fmadds     f0, f2, f0, f1
8047c9e4: d01f0000  stfs       f0, 0(r31)
8047c9e8: 4800004c  b          0x8047ca34
8047c9ec: c0021414  lfs        f0, 0x1414(r2) ; [806ff494] c0a00000 f32=-5
8047c9f0: fc010040  fcmpo      cr0, f1, f0
8047c9f4: 4c401382  cror       cr0eq, cr0lt, cr0eq
8047c9f8: 40820018  bne        0x8047ca10
8047c9fc: ec1ff028  fsubs      f0, f31, f30
8047ca00: c03e01a8  lfs        f1, 0x1a8(r30)
8047ca04: ec01f03a  fmadds     f0, f1, f0, f30
8047ca08: d01f0000  stfs       f0, 0(r31)
8047ca0c: 48000028  b          0x8047ca34
8047ca10: ec1ff028  fsubs      f0, f31, f30
8047ca14: c03e01a8  lfs        f1, 0x1a8(r30)
8047ca18: ec01f03a  fmadds     f0, f1, f0, f30
8047ca1c: d01f0000  stfs       f0, 0(r31)
8047ca20: 801e01ac  lwz        r0, 0x1ac(r30)
8047ca24: 540007ff  clrlwi.    r0, r0, 0x1f
8047ca28: 4182000c  beq        0x8047ca34
8047ca2c: fc000050  fneg       f0, f0
8047ca30: d01f0000  stfs       f0, 0(r31)
8047ca34: c05f0000  lfs        f2, 0(r31)
8047ca38: c01e0194  lfs        f0, 0x194(r30)
8047ca3c: c02213e8  lfs        f1, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047ca40: ec42002a  fadds      f2, f2, f0
8047ca44: c0021418  lfs        f0, 0x1418(r2) ; [806ff498] 41100000 f32=9
8047ca48: d03f0004  stfs       f1, 4(r31)
8047ca4c: d05f0000  stfs       f2, 0(r31)
8047ca50: d01f0008  stfs       f0, 8(r31)
8047ca54: e3e10028  psq_l      f31, 40(r1), W=0, I=0
8047ca58: cbe10020  lfd        f31, 0x20(r1)
8047ca5c: e3c10018  psq_l      f30, 24(r1), W=0, I=0
8047ca60: cbc10010  lfd        f30, 0x10(r1)
8047ca64: 83e1000c  lwz        r31, 0xc(r1)
8047ca68: 83c10008  lwz        r30, 8(r1)
8047ca6c: 80010034  lwz        r0, 0x34(r1)
8047ca70: 7c0803a6  mtlr       r0
8047ca74: 38210030  addi       r1, r1, 0x30
8047ca78: 4e800020  blr        
8047ca7c: 9421ffa0  stwu       r1, -0x60(r1)
8047ca80: 7c0802a6  mflr       r0
8047ca84: 90010064  stw        r0, 0x64(r1)
8047ca88: 39610050  addi       r11, r1, 0x50
8047ca8c: dbe10050  stfd       f31, 0x50(r1)
8047ca90: f3e10058  psq_st     f31, 88(r1), W=0, I=0
8047ca94: 4bb8adc5  bl         0x80007858
8047ca98: 7c7f1b78  mr         r31, r3
8047ca9c: 3b600000  li         r27, 0
8047caa0: 3bc00000  li         r30, 0
8047caa4: 381b0001  addi       r0, r27, 1
8047caa8: 7c7ff214  add        r3, r31, r30
8047caac: 1c000018  mulli      r0, r0, 0x18
8047cab0: 3b830050  addi       r28, r3, 0x50
8047cab4: 7c9f0214  add        r4, r31, r0
8047cab8: 7f83e378  mr         r3, r28
8047cabc: 3ba40050  addi       r29, r4, 0x50
8047cac0: 7fa4eb78  mr         r4, r29
8047cac4: 4bcb422d  bl         0x80130cf0
8047cac8: 387c000c  addi       r3, r28, 0xc
8047cacc: 389d000c  addi       r4, r29, 0xc
8047cad0: 4bcb4221  bl         0x80130cf0
8047cad4: 3b7b0001  addi       r27, r27, 1
8047cad8: 3bde0018  addi       r30, r30, 0x18
8047cadc: 2c1b000b  cmpwi      r27, 0xb
8047cae0: 4180ffc4  blt        0x8047caa4
8047cae4: c02213e8  lfs        f1, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cae8: c01f0070  lfs        f0, 0x70(r31)
8047caec: fc010000  fcmpu      cr0, f1, f0
8047caf0: 41820018  beq        0x8047cb08
8047caf4: c01f007c  lfs        f0, 0x7c(r31)
8047caf8: fc010000  fcmpu      cr0, f1, f0
8047cafc: 4082000c  bne        0x8047cb08
8047cb00: 38600000  li         r3, 0
8047cb04: 48000250  b          0x8047cd54
8047cb08: c05f0188  lfs        f2, 0x188(r31)
8047cb0c: 38610020  addi       r3, r1, 0x20
8047cb10: c03f0050  lfs        f1, 0x50(r31)
8047cb14: 7c641b78  mr         r4, r3
8047cb18: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cb1c: ec220828  fsubs      f1, f2, f1
8047cb20: d0010024  stfs       f0, 0x24(r1)
8047cb24: d0210020  stfs       f1, 0x20(r1)
8047cb28: c03f0190  lfs        f1, 0x190(r31)
8047cb2c: c01f0058  lfs        f0, 0x58(r31)
8047cb30: ec010028  fsubs      f0, f1, f0
8047cb34: d0010028  stfs       f0, 0x28(r1)
8047cb38: 4beab4f5  bl         0x8032802c
8047cb3c: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cb40: fc010000  fcmpu      cr0, f1, f0
8047cb44: 40820024  bne        0x8047cb68
8047cb48: 3c80807d  lis        r4, -0x7f83
8047cb4c: 3864033c  addi       r3, r4, 0x33c
8047cb50: c044033c  lfs        f2, 0x33c(r4)
8047cb54: c0230004  lfs        f1, 4(r3)
8047cb58: c0030008  lfs        f0, 8(r3)
8047cb5c: d0410020  stfs       f2, 0x20(r1)
8047cb60: d0210024  stfs       f1, 0x24(r1)
8047cb64: d0010028  stfs       f0, 0x28(r1)
8047cb68: 3d00807d  lis        r8, -0x7f83
8047cb6c: 807f0008  lwz        r3, 8(r31)
8047cb70: c0080318  lfs        f0, 0x318(r8)
8047cb74: 38e80318  addi       r7, r8, 0x318
8047cb78: d01f0158  stfs       f0, 0x158(r31)
8047cb7c: 38a10014  addi       r5, r1, 0x14
8047cb80: 38c10008  addi       r6, r1, 8
8047cb84: 3880000b  li         r4, 0xb
8047cb88: c0070004  lfs        f0, 4(r7)
8047cb8c: d01f015c  stfs       f0, 0x15c(r31)
8047cb90: c0070008  lfs        f0, 8(r7)
8047cb94: d01f0160  stfs       f0, 0x160(r31)
8047cb98: c0080318  lfs        f0, 0x318(r8)
8047cb9c: d01f0164  stfs       f0, 0x164(r31)
8047cba0: c0070004  lfs        f0, 4(r7)
8047cba4: d01f0168  stfs       f0, 0x168(r31)
8047cba8: c0070008  lfs        f0, 8(r7)
8047cbac: d01f016c  stfs       f0, 0x16c(r31)
8047cbb0: 4bfe0de5  bl         0x8045d994
8047cbb4: 2c030000  cmpwi      r3, 0
8047cbb8: 41820034  beq        0x8047cbec
8047cbbc: c0010008  lfs        f0, 8(r1)
8047cbc0: d01f0158  stfs       f0, 0x158(r31)
8047cbc4: c001000c  lfs        f0, 0xc(r1)
8047cbc8: d01f015c  stfs       f0, 0x15c(r31)
8047cbcc: c0010010  lfs        f0, 0x10(r1)
8047cbd0: d01f0160  stfs       f0, 0x160(r31)
8047cbd4: c0010014  lfs        f0, 0x14(r1)
8047cbd8: d01f0164  stfs       f0, 0x164(r31)
8047cbdc: c0010018  lfs        f0, 0x18(r1)
8047cbe0: d01f0168  stfs       f0, 0x168(r31)
8047cbe4: c001001c  lfs        f0, 0x1c(r1)
8047cbe8: d01f016c  stfs       f0, 0x16c(r31)
8047cbec: 801f01b4  lwz        r0, 0x1b4(r31)
8047cbf0: 2c000000  cmpwi      r0, 0
8047cbf4: 418200d0  beq        0x8047ccc4
8047cbf8: 807f0008  lwz        r3, 8(r31)
8047cbfc: 4bfe1f9d  bl         0x8045eb98
8047cc00: 2c030000  cmpwi      r3, 0
8047cc04: 7c7e1b78  mr         r30, r3
8047cc08: 418200b4  beq        0x8047ccbc
8047cc0c: 806300f8  lwz        r3, 0xf8(r3)
8047cc10: 4bff2ad5  bl         0x8046f6e4
8047cc14: c042140c  lfs        f2, 0x140c(r2) ; [806ff48c] 3f800000 f32=1
8047cc18: c01f0054  lfs        f0, 0x54(r31)
8047cc1c: ec211028  fsubs      f1, f1, f2
8047cc20: fc000840  fcmpo      cr0, f0, f1
8047cc24: 4080002c  bge        0x8047cc50
8047cc28: 801e0178  lwz        r0, 0x178(r30)
8047cc2c: 2c000001  cmpwi      r0, 1
8047cc30: 4180008c  blt        0x8047ccbc
8047cc34: c03e0018  lfs        f1, 0x18(r30)
8047cc38: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cc3c: fc010040  fcmpo      cr0, f1, f0
8047cc40: 4080007c  bge        0x8047ccbc
8047cc44: 38000000  li         r0, 0
8047cc48: 901f01b4  stw        r0, 0x1b4(r31)
8047cc4c: 48000070  b          0x8047ccbc
8047cc50: c05f0064  lfs        f2, 0x64(r31)
8047cc54: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cc58: c0621418  lfs        f3, 0x1418(r2) ; [806ff498] 41100000 f32=9
8047cc5c: c03f0058  lfs        f1, 0x58(r31)
8047cc60: fc020040  fcmpo      cr0, f2, f0
8047cc64: ec630828  fsubs      f3, f3, f1
8047cc68: 4c401382  cror       cr0eq, cr0lt, cr0eq
8047cc6c: 41820050  beq        0x8047ccbc
8047cc70: c03f005c  lfs        f1, 0x5c(r31)
8047cc74: c01f0050  lfs        f0, 0x50(r31)
8047cc78: ec2100f2  fmuls      f1, f1, f3
8047cc7c: ec211024  fdivs      f1, f1, f2
8047cc80: efe0082a  fadds      f31, f0, f1
8047cc84: 4bfdd7ad  bl         0x8045a430
8047cc88: c0421400  lfs        f2, 0x1400(r2) ; [806ff480] 3f000000 f32=0.5
8047cc8c: c002140c  lfs        f0, 0x140c(r2) ; [806ff48c] 3f800000 f32=1
8047cc90: ec220072  fmuls      f1, f2, f1
8047cc94: ec210028  fsubs      f1, f1, f0
8047cc98: fc000850  fneg       f0, f1
8047cc9c: fc00f840  fcmpo      cr0, f0, f31
8047cca0: 4c401382  cror       cr0eq, cr0lt, cr0eq
8047cca4: 40820018  bne        0x8047ccbc
8047cca8: fc1f0840  fcmpo      cr0, f31, f1
8047ccac: 4c401382  cror       cr0eq, cr0lt, cr0eq
8047ccb0: 4082000c  bne        0x8047ccbc
8047ccb4: 38600000  li         r3, 0
8047ccb8: 4800009c  b          0x8047cd54
8047ccbc: 38600002  li         r3, 2
8047ccc0: 48000094  b          0x8047cd54
8047ccc4: 38a10020  addi       r5, r1, 0x20
8047ccc8: e07f0060  psq_l      f3, 96(r31), W=0, I=0
8047cccc: e0450004  psq_l      f2, 4(r5), W=0, I=0
8047ccd0: 38c00001  li         r6, 1
8047ccd4: e01f805c  psq_l      f0, 92(r31), W=1, I=0
8047ccd8: 38600018  li         r3, 0x18
8047ccdc: 106300b2  ps_mul     f3, f3, f2
8047cce0: e0258000  psq_l      f1, 0(r5), W=1, I=0
8047cce4: c0a213e8  lfs        f5, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cce8: 1040187a  ps_madd    f2, f0, f1, f3
8047ccec: 104218d4  ps_sum0    f2, f2, f3, f3
8047ccf0: 7c9f1a14  add        r4, r31, r3
8047ccf4: e0650004  psq_l      f3, 4(r5), W=0, I=0
8047ccf8: e0840060  psq_l      f4, 96(r4), W=0, I=0
8047ccfc: e004805c  psq_l      f0, 92(r4), W=1, I=0
8047cd00: 108400f2  ps_mul     f4, f4, f3
8047cd04: 1060207a  ps_madd    f3, f0, f1, f4
8047cd08: 10032114  ps_sum0    f0, f3, f4, f4
8047cd0c: fc002840  fcmpo      cr0, f0, f5
8047cd10: 40810008  ble        0x8047cd18
8047cd14: fca00090  fmr        f5, f0
8047cd18: 38c60001  addi       r6, r6, 1
8047cd1c: 38630018  addi       r3, r3, 0x18
8047cd20: 2c06000c  cmpwi      r6, 0xc
8047cd24: 4180ffcc  blt        0x8047ccf0
8047cd28: fc022840  fcmpo      cr0, f2, f5
8047cd2c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047cd30: 40820020  bne        0x8047cd50
8047cd34: c00213e8  lfs        f0, 0x13e8(r2) ; [806ff468] 00000000 f32=0
8047cd38: fc020040  fcmpo      cr0, f2, f0
8047cd3c: 4081000c  ble        0x8047cd48
8047cd40: 38600000  li         r3, 0
8047cd44: 48000010  b          0x8047cd54
8047cd48: 38600002  li         r3, 2
8047cd4c: 48000008  b          0x8047cd54
8047cd50: 38600001  li         r3, 1
8047cd54: 39610050  addi       r11, r1, 0x50
8047cd58: e3e10058  psq_l      f31, 88(r1), W=0, I=0
8047cd5c: cbe10050  lfd        f31, 0x50(r1)
8047cd60: 4bb8ab45  bl         0x800078a4
8047cd64: 80010064  lwz        r0, 0x64(r1)
8047cd68: 7c0803a6  mtlr       r0
8047cd6c: 38210060  addi       r1, r1, 0x60
8047cd70: 4e800020  blr        
8047cd74: 80630048  lwz        r3, 0x48(r3)
8047cd78: c0230024  lfs        f1, 0x24(r3)
8047cd7c: 4e800020  blr        
8047cd80: 80630044  lwz        r3, 0x44(r3)
8047cd84: 80630008  lwz        r3, 8(r3)
8047cd88: 80630030  lwz        r3, 0x30(r3)
8047cd8c: 4e800020  blr        
8047cd90: 80030040  lwz        r0, 0x40(r3)
8047cd94: 2c000060  cmpwi      r0, 0x60
8047cd98: 4180000c  blt        0x8047cda4
8047cd9c: c02da188  lfs        f1, -0x5e78(r13) ; [806f22a8] 3f19999a f32=0.600000024
8047cda0: 4e800020  blr        
8047cda4: c022140c  lfs        f1, 0x140c(r2) ; [806ff48c] 3f800000 f32=1
8047cda8: 4e800020  blr        
8047cdac: 8003003c  lwz        r0, 0x3c(r3)
8047cdb0: 2c000000  cmpwi      r0, 0
8047cdb4: 40800028  bge        0x8047cddc
8047cdb8: 80630044  lwz        r3, 0x44(r3)
8047cdbc: c022141c  lfs        f1, 0x141c(r2) ; [806ff49c] 3fd33333 f32=1.64999998
8047cdc0: 80630008  lwz        r3, 8(r3)
8047cdc4: c0030010  lfs        f0, 0x10(r3)
8047cdc8: fc010040  fcmpo      cr0, f1, f0
8047cdcc: 4c411382  cror       cr0eq, cr0gt, cr0eq
8047cdd0: 4d820020  beqlr      
8047cdd4: fc200090  fmr        f1, f0
8047cdd8: 4e800020  blr        
8047cddc: 80630044  lwz        r3, 0x44(r3)
8047cde0: 80630008  lwz        r3, 8(r3)
8047cde4: c0230010  lfs        f1, 0x10(r3)
8047cde8: 4e800020  blr        
8047cdec: 9421fff0  stwu       r1, -0x10(r1)
8047cdf0: 7c0802a6  mflr       r0
8047cdf4: 38a001e0  li         r5, 0x1e0
8047cdf8: 90010014  stw        r0, 0x14(r1)
8047cdfc: 93e1000c  stw        r31, 0xc(r1)
8047ce00: 7c7f1b78  mr         r31, r3
8047ce04: 80830038  lwz        r4, 0x38(r3)
8047ce08: 4bb871f9  bl         0x80004000
8047ce0c: 807f0048  lwz        r3, 0x48(r31)
8047ce10: 4800099d  bl         0x8047d7ac
8047ce14: 80010014  lwz        r0, 0x14(r1)
8047ce18: 83e1000c  lwz        r31, 0xc(r1)
8047ce1c: 7c0803a6  mtlr       r0
8047ce20: 38210010  addi       r1, r1, 0x10
8047ce24: 4e800020  blr        
8047ce28: 9421fff0  stwu       r1, -0x10(r1)
8047ce2c: 7c0802a6  mflr       r0
8047ce30: 38a001e0  li         r5, 0x1e0
8047ce34: 90010014  stw        r0, 0x14(r1)
8047ce38: 93e1000c  stw        r31, 0xc(r1)
8047ce3c: 7c7f1b78  mr         r31, r3
8047ce40: 7fe4fb78  mr         r4, r31
8047ce44: 80630038  lwz        r3, 0x38(r3)
8047ce48: 4bb871b9  bl         0x80004000
8047ce4c: 807f0048  lwz        r3, 0x48(r31)
8047ce50: 480009b5  bl         0x8047d804
8047ce54: 80010014  lwz        r0, 0x14(r1)
8047ce58: 83e1000c  lwz        r31, 0xc(r1)
8047ce5c: 7c0803a6  mtlr       r0
8047ce60: 38210010  addi       r1, r1, 0x10
8047ce64: 4e800020  blr        
