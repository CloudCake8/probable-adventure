8045e2ec: 9421fff0  stwu       r1, -0x10(r1)
8045e2f0: 7c0802a6  mflr       r0
8045e2f4: 90010014  stw        r0, 0x14(r1)
8045e2f8: 93e1000c  stw        r31, 0xc(r1)
8045e2fc: 7c7f1b78  mr         r31, r3
8045e300: 7fe4fb78  mr         r4, r31
8045e304: 80a30060  lwz        r5, 0x60(r3)
8045e308: 7ca32b78  mr         r3, r5
8045e30c: 38a50008  addi       r5, r5, 8
8045e310: 4800b8f5  bl         0x80469c04
8045e314: 807f0088  lwz        r3, 0x88(r31)
8045e318: 48007b65  bl         0x80465e7c
8045e31c: 807f0084  lwz        r3, 0x84(r31)
8045e320: 4bffcbcd  bl         0x8045aeec
8045e324: 807f0080  lwz        r3, 0x80(r31)
8045e328: 480143f1  bl         0x80472718
8045e32c: 807f0004  lwz        r3, 4(r31)
8045e330: 38800398  li         r4, 0x398
8045e334: 4be58fa9  bl         0x802b72dc
8045e338: 80010014  lwz        r0, 0x14(r1)
8045e33c: 83e1000c  lwz        r31, 0xc(r1)
8045e340: 7c0803a6  mtlr       r0
8045e344: 38210010  addi       r1, r1, 0x10
8045e348: 4e800020  blr        
8045e34c: 4e800020  blr        
8045e350: 9421fff0  stwu       r1, -0x10(r1)
8045e354: 7c0802a6  mflr       r0
8045e358: 90010014  stw        r0, 0x14(r1)
8045e35c: bfc10008  stmw       r30, 8(r1)
8045e360: 7c7e1b78  mr         r30, r3
8045e364: 7c9f2378  mr         r31, r4
8045e368: 80630088  lwz        r3, 0x88(r3)
8045e36c: 48007729  bl         0x80465a94
8045e370: 807e00bc  lwz        r3, 0xbc(r30)
8045e374: 7fe4fb78  mr         r4, r31
8045e378: 81830000  lwz        r12, 0(r3)
8045e37c: 818c0030  lwz        r12, 0x30(r12)
8045e380: 7d8903a6  mtctr      r12
8045e384: 4e800421  bctrl      
8045e388: 807e00d4  lwz        r3, 0xd4(r30)
8045e38c: 81830000  lwz        r12, 0(r3)
8045e390: 818c0054  lwz        r12, 0x54(r12)
8045e394: 7d8903a6  mtctr      r12
8045e398: 4e800421  bctrl      
8045e39c: bbc10008  lmw        r30, 8(r1)
8045e3a0: 80010014  lwz        r0, 0x14(r1)
8045e3a4: 7c0803a6  mtlr       r0
8045e3a8: 38210010  addi       r1, r1, 0x10
8045e3ac: 4e800020  blr        
8045e3b0: 4e800020  blr        
8045e3b4: 4e800020  blr        
8045e3b8: 9421fff0  stwu       r1, -0x10(r1)
8045e3bc: 7c0802a6  mflr       r0
8045e3c0: 90010014  stw        r0, 0x14(r1)
8045e3c4: 80add678  lwz        r5, -0x2988(r13)
8045e3c8: 8083000c  lwz        r4, 0xc(r3)
8045e3cc: 80650168  lwz        r3, 0x168(r5)
8045e3d0: 480027f5  bl         0x80460bc4
8045e3d4: 806300d4  lwz        r3, 0xd4(r3)
8045e3d8: 81830000  lwz        r12, 0(r3)
8045e3dc: 818c0058  lwz        r12, 0x58(r12)
8045e3e0: 7d8903a6  mtctr      r12
8045e3e4: 4e800421  bctrl      
8045e3e8: 80010014  lwz        r0, 0x14(r1)
8045e3ec: 7c0803a6  mtlr       r0
8045e3f0: 38210010  addi       r1, r1, 0x10
8045e3f4: 4e800020  blr        
8045e3f8: 9421ffd0  stwu       r1, -0x30(r1)
8045e3fc: 7c0802a6  mflr       r0
8045e400: 90010034  stw        r0, 0x34(r1)
8045e404: dbe10028  stfd       f31, 0x28(r1)
8045e408: ffe00890  fmr        f31, f1
8045e40c: bf610014  stmw       r27, 0x14(r1)
8045e410: 7cbd2b78  mr         r29, r5
8045e414: 7c7b1b78  mr         r27, r3
8045e418: 7c9c2378  mr         r28, r4
8045e41c: 7cde3378  mr         r30, r6
8045e420: 7cff3b78  mr         r31, r7
8045e424: 38a00001  li         r5, 1
8045e428: 4800080d  bl         0x8045ec34
8045e42c: 807b00bc  lwz        r3, 0xbc(r27)
8045e430: 7f84e378  mr         r4, r28
8045e434: 80bb0088  lwz        r5, 0x88(r27)
8045e438: 81830000  lwz        r12, 0(r3)
8045e43c: 80a50168  lwz        r5, 0x168(r5)
8045e440: 818c002c  lwz        r12, 0x2c(r12)
8045e444: 7d8903a6  mtctr      r12
8045e448: 4e800421  bctrl      
8045e44c: 807b00d4  lwz        r3, 0xd4(r27)
8045e450: 7f84e378  mr         r4, r28
8045e454: 81830000  lwz        r12, 0(r3)
8045e458: 818c0050  lwz        r12, 0x50(r12)
8045e45c: 7d8903a6  mtctr      r12
8045e460: 4e800421  bctrl      
8045e464: 806dd678  lwz        r3, -0x2988(r13)
8045e468: 8063017c  lwz        r3, 0x17c(r3)
8045e46c: 81830000  lwz        r12, 0(r3)
8045e470: 818c004c  lwz        r12, 0x4c(r12)
8045e474: 7d8903a6  mtctr      r12
8045e478: 4e800421  bctrl      
8045e47c: 2c030000  cmpwi      r3, 0
8045e480: 40820020  bne        0x8045e4a0
8045e484: 806dd678  lwz        r3, -0x2988(r13)
8045e488: 3ca0807d  lis        r5, -0x7f83
8045e48c: 38a50378  addi       r5, r5, 0x378
8045e490: 38800000  li         r4, 0
8045e494: 80630188  lwz        r3, 0x188(r3)
8045e498: 38c00000  li         r6, 0
8045e49c: 4bf0910d  bl         0x803675a8
8045e4a0: 801b0018  lwz        r0, 0x18(r27)
8045e4a4: 2c000000  cmpwi      r0, 0
8045e4a8: 40820050  bne        0x8045e4f8
8045e4ac: fc20f890  fmr        f1, f31
8045e4b0: 38600001  li         r3, 1
8045e4b4: 38800000  li         r4, 0
8045e4b8: 3800ffff  li         r0, -1
8045e4bc: 907b0018  stw        r3, 0x18(r27)
8045e4c0: 7f83e378  mr         r3, r28
8045e4c4: 909b0060  stw        r4, 0x60(r27)
8045e4c8: 7f64db78  mr         r4, r27
8045e4cc: 7fa5eb78  mr         r5, r29
8045e4d0: 7fc6f378  mr         r6, r30
8045e4d4: 901b006c  stw        r0, 0x6c(r27)
8045e4d8: 4800b805  bl         0x80469cdc
8045e4dc: 806dd678  lwz        r3, -0x2988(r13)
8045e4e0: 809b000c  lwz        r4, 0xc(r27)
8045e4e4: 80630168  lwz        r3, 0x168(r3)
8045e4e8: 480026dd  bl         0x80460bc4
8045e4ec: 7f84e378  mr         r4, r28
8045e4f0: 4bfffe61  bl         0x8045e350
8045e4f4: 48000038  b          0x8045e52c
8045e4f8: fc20f890  fmr        f1, f31
8045e4fc: 7f83e378  mr         r3, r28
8045e500: 7f64db78  mr         r4, r27
8045e504: 7fa5eb78  mr         r5, r29
8045e508: 7fc6f378  mr         r6, r30
8045e50c: 7fe7fb78  mr         r7, r31
8045e510: 4800b865  bl         0x80469d74
8045e514: 806dd678  lwz        r3, -0x2988(r13)
8045e518: 809b000c  lwz        r4, 0xc(r27)
8045e51c: 80630168  lwz        r3, 0x168(r3)
8045e520: 480026a5  bl         0x80460bc4
8045e524: 7f84e378  mr         r4, r28
8045e528: 4bfffe29  bl         0x8045e350
8045e52c: cbe10028  lfd        f31, 0x28(r1)
8045e530: bb610014  lmw        r27, 0x14(r1)
8045e534: 80010034  lwz        r0, 0x34(r1)
8045e538: 7c0803a6  mtlr       r0
8045e53c: 38210030  addi       r1, r1, 0x30
8045e540: 4e800020  blr        
8045e544: 38600000  li         r3, 0
8045e548: 4e800020  blr        
8045e54c: 4e800020  blr        
8045e550: 4e800020  blr        
8045e554: 9421ffc0  stwu       r1, -0x40(r1)
8045e558: 7c0802a6  mflr       r0
8045e55c: 90010044  stw        r0, 0x44(r1)
8045e560: 39610020  addi       r11, r1, 0x20
8045e564: dbe10030  stfd       f31, 0x30(r1)
8045e568: f3e10038  psq_st     f31, 56(r1), W=0, I=0
8045e56c: dbc10020  stfd       f30, 0x20(r1)
8045e570: f3c10028  psq_st     f30, 40(r1), W=0, I=0
8045e574: 4bba92e9  bl         0x8000785c
8045e578: 7c7c1b78  mr         r28, r3
8045e57c: 80630088  lwz        r3, 0x88(r3)
8045e580: 7c9d2378  mr         r29, r4
8045e584: 38a00001  li         r5, 1
8045e588: 48007531  bl         0x80465ab8
8045e58c: 7c7e1b78  mr         r30, r3
8045e590: 807c00bc  lwz        r3, 0xbc(r28)
8045e594: 7fc4f378  mr         r4, r30
8045e598: 7fa5eb78  mr         r5, r29
8045e59c: 81830000  lwz        r12, 0(r3)
8045e5a0: 818c0028  lwz        r12, 0x28(r12)
8045e5a4: 7d8903a6  mtctr      r12
8045e5a8: 4e800421  bctrl      
8045e5ac: 807c00d4  lwz        r3, 0xd4(r28)
8045e5b0: 809c00bc  lwz        r4, 0xbc(r28)
8045e5b4: 81830000  lwz        r12, 0(r3)
8045e5b8: 83e40054  lwz        r31, 0x54(r4)
8045e5bc: 818c0068  lwz        r12, 0x68(r12)
8045e5c0: 7d8903a6  mtctr      r12
8045e5c4: 4e800421  bctrl      
8045e5c8: 807c00d4  lwz        r3, 0xd4(r28)
8045e5cc: ffe00890  fmr        f31, f1
8045e5d0: 809c00bc  lwz        r4, 0xbc(r28)
8045e5d4: 81830000  lwz        r12, 0(r3)
8045e5d8: c3c40050  lfs        f30, 0x50(r4)
8045e5dc: 818c0068  lwz        r12, 0x68(r12)
8045e5e0: 7d8903a6  mtctr      r12
8045e5e4: 4e800421  bctrl      
8045e5e8: 80bc00bc  lwz        r5, 0xbc(r28)
8045e5ec: ec5e07f2  fmuls      f2, f30, f31
8045e5f0: 807c0084  lwz        r3, 0x84(r28)
8045e5f4: 7fa4eb78  mr         r4, r29
8045e5f8: c005004c  lfs        f0, 0x4c(r5)
8045e5fc: 7fe5fb78  mr         r5, r31
8045e600: ec200072  fmuls      f1, f0, f1
8045e604: 4bffc939  bl         0x8045af3c
8045e608: 80bc00bc  lwz        r5, 0xbc(r28)
8045e60c: 7fc4f378  mr         r4, r30
8045e610: 807c0088  lwz        r3, 0x88(r28)
8045e614: c005004c  lfs        f0, 0x4c(r5)
8045e618: d00301ac  stfs       f0, 0x1ac(r3)
8045e61c: 807c0080  lwz        r3, 0x80(r28)
8045e620: 48013451  bl         0x80471a70
8045e624: 39610020  addi       r11, r1, 0x20
8045e628: e3e10038  psq_l      f31, 56(r1), W=0, I=0
8045e62c: cbe10030  lfd        f31, 0x30(r1)
8045e630: e3c10028  psq_l      f30, 40(r1), W=0, I=0
8045e634: cbc10020  lfd        f30, 0x20(r1)
8045e638: 4bba9271  bl         0x800078a8
8045e63c: 80010044  lwz        r0, 0x44(r1)
8045e640: 7c0803a6  mtlr       r0
8045e644: 38210040  addi       r1, r1, 0x40
8045e648: 4e800020  blr        
8045e64c: c0220e50  lfs        f1, 0xe50(r2) ; [806feed0] 3f800000 f32=1
8045e650: 4e800020  blr        
8045e654: 9421ffc0  stwu       r1, -0x40(r1)
8045e658: 7c0802a6  mflr       r0
8045e65c: 90010044  stw        r0, 0x44(r1)
8045e660: 39610040  addi       r11, r1, 0x40
8045e664: 4bba91fd  bl         0x80007860
8045e668: 80a40000  lwz        r5, 0(r4)
8045e66c: 80640004  lwz        r3, 4(r4)
8045e670: 80040008  lwz        r0, 8(r4)
8045e674: 90a10008  stw        r5, 8(r1)
8045e678: 9061000c  stw        r3, 0xc(r1)
8045e67c: 90010010  stw        r0, 0x10(r1)
8045e680: 4bffbdb9  bl         0x8045a438
8045e684: c0020e54  lfs        f0, 0xe54(r2) ; [806feed4] 3f000000 f32=0.5
8045e688: 38810008  addi       r4, r1, 8
8045e68c: 806dd678  lwz        r3, -0x2988(r13)
8045e690: 3ba00000  li         r29, 0
8045e694: ec00082a  fadds      f0, f0, f1
8045e698: d001000c  stfs       f0, 0xc(r1)
8045e69c: 80630164  lwz        r3, 0x164(r3)
8045e6a0: 83c30028  lwz        r30, 0x28(r3)
8045e6a4: 7fc3f378  mr         r3, r30
8045e6a8: 4bee8bfd  bl         0x803472a4
8045e6ac: 2c030000  cmpwi      r3, 0
8045e6b0: 4182004c  beq        0x8045e6fc
8045e6b4: 3fe08068  lis        r31, -0x7f98
8045e6b8: 3bfff300  addi       r31, r31, -0xd00
8045e6bc: 48000030  b          0x8045e6ec
8045e6c0: c0220e50  lfs        f1, 0xe50(r2) ; [806feed0] 3f800000 f32=1
8045e6c4: 38810008  addi       r4, r1, 8
8045e6c8: 38a10014  addi       r5, r1, 0x14
8045e6cc: 4bee8ef5  bl         0x803475c0
8045e6d0: 2c030000  cmpwi      r3, 0
8045e6d4: 41820018  beq        0x8045e6ec
8045e6d8: a0010024  lhz        r0, 0x24(r1)
8045e6dc: 54000efc  rlwinm     r0, r0, 1, 0x1b, 0x1e
8045e6e0: 7c1f022e  lhzx       r0, r31, r0
8045e6e4: 7fa00378  or         r0, r29, r0
8045e6e8: 541d043e  clrlwi     r29, r0, 0x10
8045e6ec: 7fc3f378  mr         r3, r30
8045e6f0: 4bee8b19  bl         0x80347208
8045e6f4: 2c030000  cmpwi      r3, 0
8045e6f8: 4082ffc8  bne        0x8045e6c0
8045e6fc: 39610040  addi       r11, r1, 0x40
8045e700: 7fa3eb78  mr         r3, r29
8045e704: 4bba91a9  bl         0x800078ac
8045e708: 80010044  lwz        r0, 0x44(r1)
8045e70c: 7c0803a6  mtlr       r0
8045e710: 38210040  addi       r1, r1, 0x40
8045e714: 4e800020  blr        
8045e718: 806300bc  lwz        r3, 0xbc(r3)
8045e71c: 81830000  lwz        r12, 0(r3)
8045e720: 818c0034  lwz        r12, 0x34(r12)
8045e724: 7d8903a6  mtctr      r12
8045e728: 4e800420  bctr       
8045e72c: 38600002  li         r3, 2
8045e730: 4e800020  blr        
8045e734: 9421ffe0  stwu       r1, -0x20(r1)
8045e738: 7c0802a6  mflr       r0
8045e73c: 90010024  stw        r0, 0x24(r1)
8045e740: bfa10014  stmw       r29, 0x14(r1)
8045e744: 7c7d1b78  mr         r29, r3
8045e748: 7c9e2378  mr         r30, r4
8045e74c: 7cbf2b78  mr         r31, r5
8045e750: 48000039  bl         0x8045e788
8045e754: 7fa3eb78  mr         r3, r29
8045e758: 389e000c  addi       r4, r30, 0xc
8045e75c: 38bf000c  addi       r5, r31, 0xc
8045e760: 48000029  bl         0x8045e788
8045e764: 7fa3eb78  mr         r3, r29
8045e768: 389e0018  addi       r4, r30, 0x18
8045e76c: 38bf0018  addi       r5, r31, 0x18
8045e770: 48000019  bl         0x8045e788
8045e774: bba10014  lmw        r29, 0x14(r1)
8045e778: 80010024  lwz        r0, 0x24(r1)
8045e77c: 7c0803a6  mtlr       r0
8045e780: 38210020  addi       r1, r1, 0x20
8045e784: 4e800020  blr        
8045e788: 80030028  lwz        r0, 0x28(r3)
8045e78c: 2c000000  cmpwi      r0, 0
8045e790: 41820028  beq        0x8045e7b8
8045e794: c0250000  lfs        f1, 0(r5)
8045e798: c0050008  lfs        f0, 8(r5)
8045e79c: fc400850  fneg       f2, f1
8045e7a0: c0250004  lfs        f1, 4(r5)
8045e7a4: fc000050  fneg       f0, f0
8045e7a8: d0240004  stfs       f1, 4(r4)
8045e7ac: d0440000  stfs       f2, 0(r4)
8045e7b0: d0040008  stfs       f0, 8(r4)
8045e7b4: 4e800020  blr        
8045e7b8: c0450000  lfs        f2, 0(r5)
8045e7bc: c0250004  lfs        f1, 4(r5)
8045e7c0: c0050008  lfs        f0, 8(r5)
8045e7c4: d0440000  stfs       f2, 0(r4)
8045e7c8: d0240004  stfs       f1, 4(r4)
8045e7cc: d0040008  stfs       f0, 8(r4)
8045e7d0: 4e800020  blr        
8045e7d4: 80030014  lwz        r0, 0x14(r3)
8045e7d8: 2c000000  cmpwi      r0, 0
8045e7dc: 4182001c  beq        0x8045e7f8
8045e7e0: 806300d4  lwz        r3, 0xd4(r3)
8045e7e4: 80630034  lwz        r3, 0x34(r3)
8045e7e8: 3803fffe  addi       r0, r3, -2
8045e7ec: 7c000034  cntlzw     r0, r0
8045e7f0: 5403d97e  srwi       r3, r0, 5
8045e7f4: 4e800020  blr        
8045e7f8: 38600001  li         r3, 1
8045e7fc: 4e800020  blr        
8045e800: 80630088  lwz        r3, 0x88(r3)
8045e804: 80630190  lwz        r3, 0x190(r3)
8045e808: 3003ffff  addic      r0, r3, -1
8045e80c: 7c601910  subfe      r3, r0, r3
8045e810: 4e800020  blr        
8045e814: 9421fff0  stwu       r1, -0x10(r1)
8045e818: 7c0802a6  mflr       r0
8045e81c: 90010014  stw        r0, 0x14(r1)
8045e820: 8003001c  lwz        r0, 0x1c(r3)
8045e824: 7c0000f8  nor        r0, r0, r0
8045e828: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8045e82c: 4182000c  beq        0x8045e838
8045e830: 38600000  li         r3, 0
8045e834: 48000014  b          0x8045e848
8045e838: 80630084  lwz        r3, 0x84(r3)
8045e83c: 4bffc6b5  bl         0x8045aef0
8045e840: 3003ffff  addic      r0, r3, -1
8045e844: 7c601910  subfe      r3, r0, r3
8045e848: 80010014  lwz        r0, 0x14(r1)
8045e84c: 7c0803a6  mtlr       r0
8045e850: 38210010  addi       r1, r1, 0x10
8045e854: 4e800020  blr        
8045e858: 9421fff0  stwu       r1, -0x10(r1)
8045e85c: 7c0802a6  mflr       r0
8045e860: 90010014  stw        r0, 0x14(r1)
8045e864: 4bffffb1  bl         0x8045e814
8045e868: 3003ffff  addic      r0, r3, -1
8045e86c: 7c601910  subfe      r3, r0, r3
8045e870: 80010014  lwz        r0, 0x14(r1)
8045e874: 7c0803a6  mtlr       r0
8045e878: 38210010  addi       r1, r1, 0x10
8045e87c: 4e800020  blr        
8045e880: 80630088  lwz        r3, 0x88(r3)
8045e884: 480075d0  b          0x80465e54
8045e888: 806300bc  lwz        r3, 0xbc(r3)
8045e88c: 81830000  lwz        r12, 0(r3)
8045e890: 818c0040  lwz        r12, 0x40(r12)
8045e894: 7d8903a6  mtctr      r12
8045e898: 4e800420  bctr       
8045e89c: 38600000  li         r3, 0
8045e8a0: 4e800020  blr        
8045e8a4: 80630080  lwz        r3, 0x80(r3)
8045e8a8: 480132f0  b          0x80471b98
8045e8ac: 80630080  lwz        r3, 0x80(r3)
8045e8b0: 480132f0  b          0x80471ba0
8045e8b4: 8003006c  lwz        r0, 0x6c(r3)
8045e8b8: 54000ffe  srwi       r0, r0, 0x1f
8045e8bc: 68030001  xori       r3, r0, 1
8045e8c0: 4e800020  blr        
8045e8c4: 800300c0  lwz        r0, 0xc0(r3)
8045e8c8: 2c000001  cmpwi      r0, 1
8045e8cc: 4082000c  bne        0x8045e8d8
8045e8d0: 38600000  li         r3, 0
8045e8d4: 4e800020  blr        
8045e8d8: 80630084  lwz        r3, 0x84(r3)
8045e8dc: 806300cc  lwz        r3, 0xcc(r3)
8045e8e0: 4e800020  blr        
8045e8e4: 808dd678  lwz        r4, -0x2988(r13)
8045e8e8: 8003000c  lwz        r0, 0xc(r3)
8045e8ec: 8064017c  lwz        r3, 0x17c(r4)
8045e8f0: 80630010  lwz        r3, 0x10(r3)
8045e8f4: 7c030050  subf       r0, r3, r0
8045e8f8: 7c000034  cntlzw     r0, r0
8045e8fc: 5403d97e  srwi       r3, r0, 5
8045e900: 4e800020  blr        
8045e904: 800300c0  lwz        r0, 0xc0(r3)
8045e908: 2c000001  cmpwi      r0, 1
8045e90c: 4082000c  bne        0x8045e918
8045e910: 38600000  li         r3, 0
8045e914: 4e800020  blr        
8045e918: 808dd678  lwz        r4, -0x2988(r13)
8045e91c: 8003000c  lwz        r0, 0xc(r3)
8045e920: 8064017c  lwz        r3, 0x17c(r4)
8045e924: 80630014  lwz        r3, 0x14(r3)
8045e928: 7c030050  subf       r0, r3, r0
8045e92c: 7c000034  cntlzw     r0, r0
8045e930: 5403d97e  srwi       r3, r0, 5
8045e934: 4e800020  blr        
8045e938: 80630084  lwz        r3, 0x84(r3)
8045e93c: 2c030000  cmpwi      r3, 0
8045e940: 4182000c  beq        0x8045e94c
8045e944: 806302f4  lwz        r3, 0x2f4(r3)
8045e948: 4e800020  blr        
8045e94c: 38600001  li         r3, 1
8045e950: 4e800020  blr        
8045e954: 9421fff0  stwu       r1, -0x10(r1)
8045e958: 7c0802a6  mflr       r0
8045e95c: 90010014  stw        r0, 0x14(r1)
8045e960: 93e1000c  stw        r31, 0xc(r1)
8045e964: 7c7f1b78  mr         r31, r3
8045e968: 90830010  stw        r4, 0x10(r3)
8045e96c: 806dd678  lwz        r3, -0x2988(r13)
8045e970: 80630160  lwz        r3, 0x160(r3)
8045e974: 4bff93c5  bl         0x80457d38
8045e978: 801f0010  lwz        r0, 0x10(r31)
8045e97c: 7c001800  cmpw       r0, r3
8045e980: 41800018  blt        0x8045e998
8045e984: 806dd678  lwz        r3, -0x2988(r13)
8045e988: 80630160  lwz        r3, 0x160(r3)
8045e98c: 4bff93ad  bl         0x80457d38
8045e990: 3803ffff  addi       r0, r3, -1
8045e994: 901f0010  stw        r0, 0x10(r31)
8045e998: 807f00e8  lwz        r3, 0xe8(r31)
8045e99c: 4800a5f5  bl         0x80468f90
8045e9a0: 80010014  lwz        r0, 0x14(r1)
8045e9a4: 83e1000c  lwz        r31, 0xc(r1)
8045e9a8: 7c0803a6  mtlr       r0
8045e9ac: 38210010  addi       r1, r1, 0x10
8045e9b0: 4e800020  blr        
8045e9b4: 5480103a  slwi       r0, r4, 2
8045e9b8: 908300d8  stw        r4, 0xd8(r3)
8045e9bc: 7c830214  add        r4, r3, r0
8045e9c0: 800400dc  lwz        r0, 0xdc(r4)
8045e9c4: 900300d4  stw        r0, 0xd4(r3)
8045e9c8: 4e800020  blr        
8045e9cc: 5480103a  slwi       r0, r4, 2
8045e9d0: 908300c0  stw        r4, 0xc0(r3)
8045e9d4: 7ca30214  add        r5, r3, r0
8045e9d8: 808300bc  lwz        r4, 0xbc(r3)
8045e9dc: 800500c4  lwz        r0, 0xc4(r5)
8045e9e0: 900300bc  stw        r0, 0xbc(r3)
8045e9e4: 7c030378  mr         r3, r0
8045e9e8: 48002f84  b          0x8046196c
8045e9ec: 9421fff0  stwu       r1, -0x10(r1)
8045e9f0: 7c0802a6  mflr       r0
8045e9f4: 90010014  stw        r0, 0x14(r1)
8045e9f8: 93e1000c  stw        r31, 0xc(r1)
8045e9fc: 7c7f1b78  mr         r31, r3
8045ea00: 90830084  stw        r4, 0x84(r3)
8045ea04: 7c832378  mr         r3, r4
8045ea08: 7fe4fb78  mr         r4, r31
8045ea0c: 4bffe3f9  bl         0x8045ce04
8045ea10: 807f0090  lwz        r3, 0x90(r31)
8045ea14: 81830000  lwz        r12, 0(r3)
8045ea18: 818c0010  lwz        r12, 0x10(r12)
8045ea1c: 7d8903a6  mtctr      r12
8045ea20: 4e800421  bctrl      
8045ea24: 807f0084  lwz        r3, 0x84(r31)
8045ea28: 809f0090  lwz        r4, 0x90(r31)
8045ea2c: 4bffe6c1  bl         0x8045d0ec
8045ea30: 807f0094  lwz        r3, 0x94(r31)
8045ea34: 81830000  lwz        r12, 0(r3)
8045ea38: 818c0010  lwz        r12, 0x10(r12)
8045ea3c: 7d8903a6  mtctr      r12
8045ea40: 4e800421  bctrl      
8045ea44: 807f0084  lwz        r3, 0x84(r31)
8045ea48: 809f0094  lwz        r4, 0x94(r31)
8045ea4c: 4bffe621  bl         0x8045d06c
8045ea50: 80010014  lwz        r0, 0x14(r1)
8045ea54: 83e1000c  lwz        r31, 0xc(r1)
8045ea58: 7c0803a6  mtlr       r0
8045ea5c: 38210010  addi       r1, r1, 0x10
8045ea60: 4e800020  blr        
8045ea64: 80630080  lwz        r3, 0x80(r3)
8045ea68: 908303a0  stw        r4, 0x3a0(r3)
8045ea6c: 4e800020  blr        
8045ea70: 80edd678  lwz        r7, -0x2988(r13)
8045ea74: 7c681b78  mr         r8, r3
8045ea78: 7ca62b78  mr         r6, r5
8045ea7c: 7c852378  mr         r5, r4
8045ea80: 80670158  lwz        r3, 0x158(r7)
8045ea84: 8088000c  lwz        r4, 0xc(r8)
8045ea88: 4bff81b4  b          0x80456c3c
8045ea8c: 80630084  lwz        r3, 0x84(r3)
8045ea90: 2c030000  cmpwi      r3, 0
8045ea94: 4182000c  beq        0x8045eaa0
8045ea98: 80630038  lwz        r3, 0x38(r3)
8045ea9c: 4e800020  blr        
8045eaa0: 38600000  li         r3, 0
8045eaa4: 4e800020  blr        
8045eaa8: 806300bc  lwz        r3, 0xbc(r3)
8045eaac: c0230088  lfs        f1, 0x88(r3)
8045eab0: 4e800020  blr        
8045eab4: 806300d4  lwz        r3, 0xd4(r3)
8045eab8: 80630030  lwz        r3, 0x30(r3)
8045eabc: 4e800020  blr        
8045eac0: 806300d4  lwz        r3, 0xd4(r3)
8045eac4: 81830000  lwz        r12, 0(r3)
8045eac8: 818c006c  lwz        r12, 0x6c(r12)
8045eacc: 7d8903a6  mtctr      r12
8045ead0: 4e800420  bctr       
8045ead4: 38600003  li         r3, 3
8045ead8: 4e800020  blr        
8045eadc: 9421ffe0  stwu       r1, -0x20(r1)
8045eae0: 7c0802a6  mflr       r0
8045eae4: 90010024  stw        r0, 0x24(r1)
8045eae8: dbe10010  stfd       f31, 0x10(r1)
8045eaec: f3e10018  psq_st     f31, 24(r1), W=0, I=0
8045eaf0: 93e1000c  stw        r31, 0xc(r1)
8045eaf4: 7c7f1b78  mr         r31, r3
8045eaf8: 806300d4  lwz        r3, 0xd4(r3)
8045eafc: 81830000  lwz        r12, 0(r3)
8045eb00: 818c0064  lwz        r12, 0x64(r12)
8045eb04: 7d8903a6  mtctr      r12
8045eb08: 4e800421  bctrl      
8045eb0c: 801f00d8  lwz        r0, 0xd8(r31)
8045eb10: ffe00890  fmr        f31, f1
8045eb14: 2c000000  cmpwi      r0, 0
8045eb18: 40820018  bne        0x8045eb30
8045eb1c: 806dd678  lwz        r3, -0x2988(r13)
8045eb20: 809f000c  lwz        r4, 0xc(r31)
8045eb24: 8063017c  lwz        r3, 0x17c(r3)
8045eb28: 4802303d  bl         0x80481b64
8045eb2c: ec3f0072  fmuls      f1, f31, f1
8045eb30: 80010024  lwz        r0, 0x24(r1)
8045eb34: e3e10018  psq_l      f31, 24(r1), W=0, I=0
8045eb38: cbe10010  lfd        f31, 0x10(r1)
8045eb3c: 83e1000c  lwz        r31, 0xc(r1)
8045eb40: 7c0803a6  mtlr       r0
8045eb44: 38210020  addi       r1, r1, 0x20
8045eb48: 4e800020  blr        
8045eb4c: c0220e50  lfs        f1, 0xe50(r2) ; [806feed0] 3f800000 f32=1
8045eb50: 4e800020  blr        
8045eb54: 80630084  lwz        r3, 0x84(r3)
8045eb58: 8063000c  lwz        r3, 0xc(r3)
8045eb5c: 4e800020  blr        
8045eb60: 9421fff0  stwu       r1, -0x10(r1)
8045eb64: 7c0802a6  mflr       r0
8045eb68: 90010014  stw        r0, 0x14(r1)
8045eb6c: 4800002d  bl         0x8045eb98
8045eb70: 2c030000  cmpwi      r3, 0
8045eb74: 4182000c  beq        0x8045eb80
8045eb78: 38630008  addi       r3, r3, 8
8045eb7c: 4800000c  b          0x8045eb88
8045eb80: 3c60807d  lis        r3, -0x7f83
8045eb84: 38630318  addi       r3, r3, 0x318
8045eb88: 80010014  lwz        r0, 0x14(r1)
8045eb8c: 7c0803a6  mtlr       r0
8045eb90: 38210010  addi       r1, r1, 0x10
8045eb94: 4e800020  blr        
8045eb98: 9421fff0  stwu       r1, -0x10(r1)
8045eb9c: 7c0802a6  mflr       r0
8045eba0: 90010014  stw        r0, 0x14(r1)
8045eba4: bfc10008  stmw       r30, 8(r1)
8045eba8: 7c7e1b78  mr         r30, r3
8045ebac: 80030060  lwz        r0, 0x60(r3)
8045ebb0: 2c000000  cmpwi      r0, 0
8045ebb4: 4182000c  beq        0x8045ebc0
8045ebb8: 7c030378  mr         r3, r0
8045ebbc: 4800004c  b          0x8045ec08
8045ebc0: 83e3005c  lwz        r31, 0x5c(r3)
8045ebc4: 7fe3fb78  mr         r3, r31
8045ebc8: 48000055  bl         0x8045ec1c
8045ebcc: 2c030000  cmpwi      r3, 0
8045ebd0: 4182000c  beq        0x8045ebdc
8045ebd4: 38000000  li         r0, 0
8045ebd8: 48000010  b          0x8045ebe8
8045ebdc: 807f0008  lwz        r3, 8(r31)
8045ebe0: 38000001  li         r0, 1
8045ebe4: 80630000  lwz        r3, 0(r3)
8045ebe8: 2c000000  cmpwi      r0, 0
8045ebec: 41820008  beq        0x8045ebf4
8045ebf0: 48000018  b          0x8045ec08
8045ebf4: 807e0064  lwz        r3, 0x64(r30)
8045ebf8: 2c030000  cmpwi      r3, 0
8045ebfc: 41820008  beq        0x8045ec04
8045ec00: 48000008  b          0x8045ec08
8045ec04: 38600000  li         r3, 0
8045ec08: bbc10008  lmw        r30, 8(r1)
8045ec0c: 80010014  lwz        r0, 0x14(r1)
8045ec10: 7c0803a6  mtlr       r0
8045ec14: 38210010  addi       r1, r1, 0x10
8045ec18: 4e800020  blr        
8045ec1c: 80830008  lwz        r4, 8(r3)
8045ec20: 8003000c  lwz        r0, 0xc(r3)
8045ec24: 7c040050  subf       r0, r4, r0
8045ec28: 7c000034  cntlzw     r0, r0
8045ec2c: 5403d97e  srwi       r3, r0, 5
8045ec30: 4e800020  blr        
8045ec34: 9421ffe0  stwu       r1, -0x20(r1)
8045ec38: 7c0802a6  mflr       r0
8045ec3c: 2c050000  cmpwi      r5, 0
8045ec40: 90010024  stw        r0, 0x24(r1)
8045ec44: bf810010  stmw       r28, 0x10(r1)
8045ec48: 7c7e1b78  mr         r30, r3
8045ec4c: 7c9f2378  mr         r31, r4
8045ec50: 418200a8  beq        0x8045ecf8
8045ec54: 83a3005c  lwz        r29, 0x5c(r3)
8045ec58: 839d0008  lwz        r28, 8(r29)
8045ec5c: 4800007c  b          0x8045ecd8
8045ec60: 801c0000  lwz        r0, 0(r28)
8045ec64: 7c1f0040  cmplw      r31, r0
8045ec68: 40820060  bne        0x8045ecc8
8045ec6c: 7fa3eb78  mr         r3, r29
8045ec70: 7f84e378  mr         r4, r28
8045ec74: 48000199  bl         0x8045ee0c
8045ec78: 7c641b78  mr         r4, r3
8045ec7c: 4800002c  b          0x8045eca8
8045ec80: 801d0010  lwz        r0, 0x10(r29)
8045ec84: 7c040040  cmplw      r4, r0
8045ec88: 40820008  bne        0x8045ec90
8045ec8c: 939d0010  stw        r28, 0x10(r29)
8045ec90: 80040000  lwz        r0, 0(r4)
8045ec94: 7fa3eb78  mr         r3, r29
8045ec98: 901c0000  stw        r0, 0(r28)
8045ec9c: 7c9c2378  mr         r28, r4
8045eca0: 4800016d  bl         0x8045ee0c
8045eca4: 7c641b78  mr         r4, r3
8045eca8: 801d000c  lwz        r0, 0xc(r29)
8045ecac: 7c040040  cmplw      r4, r0
8045ecb0: 4082ffd0  bne        0x8045ec80
8045ecb4: 7fa3eb78  mr         r3, r29
8045ecb8: 389d000c  addi       r4, r29, 0xc
8045ecbc: 48000105  bl         0x8045edc0
8045ecc0: 38000001  li         r0, 1
8045ecc4: 48000024  b          0x8045ece8
8045ecc8: 7fa3eb78  mr         r3, r29
8045eccc: 7f84e378  mr         r4, r28
8045ecd0: 4800013d  bl         0x8045ee0c
8045ecd4: 7c7c1b78  mr         r28, r3
8045ecd8: 801d000c  lwz        r0, 0xc(r29)
8045ecdc: 7c1c0040  cmplw      r28, r0
8045ece0: 4082ff80  bne        0x8045ec60
8045ece4: 38000000  li         r0, 0
8045ece8: 2c000000  cmpwi      r0, 0
8045ecec: 418200ac  beq        0x8045ed98
8045ecf0: 93fe0064  stw        r31, 0x64(r30)
8045ecf4: 480000a4  b          0x8045ed98
8045ecf8: 8383005c  lwz        r28, 0x5c(r3)
8045ecfc: 83bc0008  lwz        r29, 8(r28)
8045ed00: 48000078  b          0x8045ed78
8045ed04: 801d0000  lwz        r0, 0(r29)
8045ed08: 7c1f0040  cmplw      r31, r0
8045ed0c: 4082005c  bne        0x8045ed68
8045ed10: 7f83e378  mr         r3, r28
8045ed14: 7fa4eb78  mr         r4, r29
8045ed18: 480000f5  bl         0x8045ee0c
8045ed1c: 7c641b78  mr         r4, r3
8045ed20: 4800002c  b          0x8045ed4c
8045ed24: 801c0010  lwz        r0, 0x10(r28)
8045ed28: 7c040040  cmplw      r4, r0
8045ed2c: 40820008  bne        0x8045ed34
8045ed30: 93bc0010  stw        r29, 0x10(r28)
8045ed34: 80040000  lwz        r0, 0(r4)
8045ed38: 7f83e378  mr         r3, r28
8045ed3c: 901d0000  stw        r0, 0(r29)
8045ed40: 7c9d2378  mr         r29, r4
8045ed44: 480000c9  bl         0x8045ee0c
8045ed48: 7c641b78  mr         r4, r3
8045ed4c: 801c000c  lwz        r0, 0xc(r28)
8045ed50: 7c040040  cmplw      r4, r0
8045ed54: 4082ffd0  bne        0x8045ed24
8045ed58: 7f83e378  mr         r3, r28
8045ed5c: 389c000c  addi       r4, r28, 0xc
8045ed60: 48000061  bl         0x8045edc0
8045ed64: 48000020  b          0x8045ed84
8045ed68: 7f83e378  mr         r3, r28
8045ed6c: 7fa4eb78  mr         r4, r29
8045ed70: 4800009d  bl         0x8045ee0c
8045ed74: 7c7d1b78  mr         r29, r3
8045ed78: 801c000c  lwz        r0, 0xc(r28)
8045ed7c: 7c1d0040  cmplw      r29, r0
8045ed80: 4082ff84  bne        0x8045ed04
8045ed84: 801e0064  lwz        r0, 0x64(r30)
8045ed88: 7c00f840  cmplw      r0, r31
8045ed8c: 4082000c  bne        0x8045ed98
8045ed90: 38000000  li         r0, 0
8045ed94: 901e0064  stw        r0, 0x64(r30)
8045ed98: 801e0060  lwz        r0, 0x60(r30)
8045ed9c: 7c1f0040  cmplw      r31, r0
8045eda0: 4082000c  bne        0x8045edac
8045eda4: 38000000  li         r0, 0
8045eda8: 901e0060  stw        r0, 0x60(r30)
8045edac: bb810010  lmw        r28, 0x10(r1)
8045edb0: 80010024  lwz        r0, 0x24(r1)
8045edb4: 7c0803a6  mtlr       r0
8045edb8: 38210020  addi       r1, r1, 0x20
8045edbc: 4e800020  blr        
8045edc0: 80a40000  lwz        r5, 0(r4)
8045edc4: 80030010  lwz        r0, 0x10(r3)
8045edc8: 7c050040  cmplw      r5, r0
8045edcc: 40820024  bne        0x8045edf0
8045edd0: 80030000  lwz        r0, 0(r3)
8045edd4: 38a5fffc  addi       r5, r5, -4
8045edd8: 7c050040  cmplw      r5, r0
8045eddc: 40800008  bge        0x8045ede4
8045ede0: 80a30004  lwz        r5, 4(r3)
8045ede4: 90a40000  stw        r5, 0(r4)
8045ede8: 90a30010  stw        r5, 0x10(r3)
8045edec: 4e800020  blr        
8045edf0: 80030000  lwz        r0, 0(r3)
8045edf4: 38a5fffc  addi       r5, r5, -4
8045edf8: 7c050040  cmplw      r5, r0
8045edfc: 40800008  bge        0x8045ee04
8045ee00: 80a30004  lwz        r5, 4(r3)
8045ee04: 90a40000  stw        r5, 0(r4)
8045ee08: 4e800020  blr        
8045ee0c: 80030004  lwz        r0, 4(r3)
8045ee10: 38840004  addi       r4, r4, 4
8045ee14: 7c040040  cmplw      r4, r0
8045ee18: 40810008  ble        0x8045ee20
8045ee1c: 80830000  lwz        r4, 0(r3)
8045ee20: 7c832378  mr         r3, r4
8045ee24: 4e800020  blr        
8045ee28: 9421fff0  stwu       r1, -0x10(r1)
8045ee2c: 7c0802a6  mflr       r0
8045ee30: 90010014  stw        r0, 0x14(r1)
8045ee34: bfc10008  stmw       r30, 8(r1)
8045ee38: 7c9e2378  mr         r30, r4
8045ee3c: 83e3005c  lwz        r31, 0x5c(r3)
8045ee40: 7fe3fb78  mr         r3, r31
8045ee44: 48000081  bl         0x8045eec4
8045ee48: 2c030000  cmpwi      r3, 0
8045ee4c: 40820010  bne        0x8045ee5c
8045ee50: 7fe3fb78  mr         r3, r31
8045ee54: 7fc4f378  mr         r4, r30
8045ee58: 48000019  bl         0x8045ee70
8045ee5c: bbc10008  lmw        r30, 8(r1)
8045ee60: 80010014  lwz        r0, 0x14(r1)
8045ee64: 7c0803a6  mtlr       r0
8045ee68: 38210010  addi       r1, r1, 0x10
8045ee6c: 4e800020  blr        
8045ee70: 80c3000c  lwz        r6, 0xc(r3)
8045ee74: 80030004  lwz        r0, 4(r3)
8045ee78: 38a60004  addi       r5, r6, 4
8045ee7c: 7c050040  cmplw      r5, r0
8045ee80: 40810008  ble        0x8045ee88
8045ee84: 80a30000  lwz        r5, 0(r3)
8045ee88: 80030008  lwz        r0, 8(r3)
8045ee8c: 7c050040  cmplw      r5, r0
8045ee90: 4082000c  bne        0x8045ee9c
8045ee94: 38600000  li         r3, 0
8045ee98: 4e800020  blr        
8045ee9c: 90860000  stw        r4, 0(r6)
8045eea0: 8083000c  lwz        r4, 0xc(r3)
8045eea4: 80030004  lwz        r0, 4(r3)
8045eea8: 38840004  addi       r4, r4, 4
8045eeac: 7c040040  cmplw      r4, r0
8045eeb0: 40810008  ble        0x8045eeb8
8045eeb4: 80830000  lwz        r4, 0(r3)
8045eeb8: 9083000c  stw        r4, 0xc(r3)
8045eebc: 38600001  li         r3, 1
8045eec0: 4e800020  blr        
8045eec4: 80c30008  lwz        r6, 8(r3)
8045eec8: 80a3000c  lwz        r5, 0xc(r3)
8045eecc: 4800002c  b          0x8045eef8
8045eed0: 80060000  lwz        r0, 0(r6)
8045eed4: 7c040040  cmplw      r4, r0
8045eed8: 4082000c  bne        0x8045eee4
8045eedc: 38600001  li         r3, 1
8045eee0: 4e800020  blr        
8045eee4: 80030004  lwz        r0, 4(r3)
8045eee8: 38c60004  addi       r6, r6, 4
8045eeec: 7c060040  cmplw      r6, r0
8045eef0: 40810008  ble        0x8045eef8
8045eef4: 80c30000  lwz        r6, 0(r3)
8045eef8: 7c062840  cmplw      r6, r5
8045eefc: 4082ffd4  bne        0x8045eed0
8045ef00: 38600000  li         r3, 0
8045ef04: 4e800020  blr        
8045ef08: 80add678  lwz        r5, -0x2988(r13)
8045ef0c: 8083000c  lwz        r4, 0xc(r3)
8045ef10: 80650168  lwz        r3, 0x168(r5)
8045ef14: 48001cb0  b          0x80460bc4
8045ef18: 9421ff50  stwu       r1, -0xb0(r1)
8045ef1c: 7c0802a6  mflr       r0
8045ef20: 900100b4  stw        r0, 0xb4(r1)
8045ef24: dbe100a0  stfd       f31, 0xa0(r1)
8045ef28: f3e100a8  psq_st     f31, 168(r1), W=0, I=0
8045ef2c: 93e1009c  stw        r31, 0x9c(r1)
8045ef30: 7c7f1b78  mr         r31, r3
8045ef34: 93c10098  stw        r30, 0x98(r1)
8045ef38: 8003007c  lwz        r0, 0x7c(r3)
8045ef3c: 2c000000  cmpwi      r0, 0
8045ef40: 41820010  beq        0x8045ef50
8045ef44: 38000000  li         r0, 0
8045ef48: 9003007c  stw        r0, 0x7c(r3)
8045ef4c: 48000241  bl         0x8045f18c
8045ef50: 807f0094  lwz        r3, 0x94(r31)
8045ef54: 38000006  li         r0, 6
8045ef58: 38a10064  addi       r5, r1, 0x64
8045ef5c: 388300ac  addi       r4, r3, 0xac
8045ef60: 7c0903a6  mtctr      r0
8045ef64: 80640004  lwz        r3, 4(r4)
8045ef68: 84040008  lwzu       r0, 8(r4)
8045ef6c: 90650004  stw        r3, 4(r5)
8045ef70: 94050008  stwu       r0, 8(r5)
8045ef74: 4200fff0  bdnz       0x8045ef64
8045ef78: 83df009c  lwz        r30, 0x9c(r31)
8045ef7c: 38610068  addi       r3, r1, 0x68
8045ef80: c021006c  lfs        f1, 0x6c(r1)
8045ef84: 3880001e  li         r4, 0x1e
8045ef88: c01e0068  lfs        f0, 0x68(r30)
8045ef8c: 38a00000  li         r5, 0
8045ef90: c0610068  lfs        f3, 0x68(r1)
8045ef94: ec810032  fmuls      f4, f1, f0
8045ef98: c01e0064  lfs        f0, 0x64(r30)
8045ef9c: c0410070  lfs        f2, 0x70(r1)
8045efa0: c03e006c  lfs        f1, 0x6c(r30)
8045efa4: ec63203a  fmadds     f3, f3, f0, f4
8045efa8: c0010074  lfs        f0, 0x74(r1)
8045efac: c121007c  lfs        f9, 0x7c(r1)
8045efb0: c1010078  lfs        f8, 0x78(r1)
8045efb4: ec42187a  fmadds     f2, f2, f1, f3
8045efb8: c0c10080  lfs        f6, 0x80(r1)
8045efbc: c0210084  lfs        f1, 0x84(r1)
8045efc0: c0a1008c  lfs        f5, 0x8c(r1)
8045efc4: ec00102a  fadds      f0, f0, f2
8045efc8: c0810088  lfs        f4, 0x88(r1)
8045efcc: c0410090  lfs        f2, 0x90(r1)
8045efd0: d0010074  stfs       f0, 0x74(r1)
8045efd4: c0010094  lfs        f0, 0x94(r1)
8045efd8: c07e0068  lfs        f3, 0x68(r30)
8045efdc: c0fe0064  lfs        f7, 0x64(r30)
8045efe0: ed2900f2  fmuls      f9, f9, f3
8045efe4: c07e006c  lfs        f3, 0x6c(r30)
8045efe8: ece849fa  fmadds     f7, f8, f7, f9
8045efec: ec6638fa  fmadds     f3, f6, f3, f7
8045eff0: ec21182a  fadds      f1, f1, f3
8045eff4: d0210084  stfs       f1, 0x84(r1)
8045eff8: c03e0068  lfs        f1, 0x68(r30)
8045effc: c07e0064  lfs        f3, 0x64(r30)
8045f000: eca50072  fmuls      f5, f5, f1
8045f004: c03e006c  lfs        f1, 0x6c(r30)
8045f008: ec6428fa  fmadds     f3, f4, f3, f5
8045f00c: ec22187a  fmadds     f1, f2, f1, f3
8045f010: ec00082a  fadds      f0, f0, f1
8045f014: d0010094  stfs       f0, 0x94(r1)
8045f018: 4bbdac09  bl         0x80039c20
8045f01c: 807f0094  lwz        r3, 0x94(r31)
8045f020: 38810018  addi       r4, r1, 0x18
8045f024: 4bd46949  bl         0x801a596c
8045f028: 38610018  addi       r3, r1, 0x18
8045f02c: 38800000  li         r4, 0
8045f030: 4bbd8751  bl         0x80037780
8045f034: 807f009c  lwz        r3, 0x9c(r31)
8045f038: 4be4c951  bl         0x802ab988
8045f03c: 809f009c  lwz        r4, 0x9c(r31)
8045f040: ffe00890  fmr        f31, f1
8045f044: 38610008  addi       r3, r1, 8
8045f048: c0240028  lfs        f1, 0x28(r4)
8045f04c: c044002c  lfs        f2, 0x2c(r4)
8045f050: c0040030  lfs        f0, 0x30(r4)
8045f054: fc200850  fneg       f1, f1
8045f058: fc401050  fneg       f2, f2
8045f05c: fc600050  fneg       f3, f0
8045f060: 4bcd1cb1  bl         0x80130d10
8045f064: 3c60807d  lis        r3, -0x7f83
8045f068: 38000006  li         r0, 6
8045f06c: 38630378  addi       r3, r3, 0x378
8045f070: 38a10034  addi       r5, r1, 0x34
8045f074: 3883fffc  addi       r4, r3, -4
8045f078: 7c0903a6  mtctr      r0
8045f07c: 80640004  lwz        r3, 4(r4)
8045f080: 84040008  lwzu       r0, 8(r4)
8045f084: 90650004  stw        r3, 4(r5)
8045f088: 94050008  stwu       r0, 8(r5)
8045f08c: 4200fff0  bdnz       0x8045f07c
8045f090: 3c80807d  lis        r4, -0x7f83
8045f094: 3ce0807d  lis        r7, -0x7f83
8045f098: 38643568  addi       r3, r4, 0x3568
8045f09c: c0843568  lfs        f4, 0x3568(r4)
8045f0a0: c0630004  lfs        f3, 4(r3)
8045f0a4: 38c73574  addi       r6, r7, 0x3574
8045f0a8: c0430008  lfs        f2, 8(r3)
8045f0ac: 3c60807d  lis        r3, -0x7f83
8045f0b0: c0020e50  lfs        f0, 0xe50(r2) ; [806feed0] 3f800000 f32=1
8045f0b4: 3863eef0  addi       r3, r3, -0x1110
8045f0b8: d0810038  stfs       f4, 0x38(r1)
8045f0bc: 38810038  addi       r4, r1, 0x38
8045f0c0: ed002028  fsubs      f8, f0, f4
8045f0c4: c0273574  lfs        f1, 0x3574(r7)
8045f0c8: d061004c  stfs       f3, 0x4c(r1)
8045f0cc: ece01828  fsubs      f7, f0, f3
8045f0d0: eca01028  fsubs      f5, f0, f2
8045f0d4: c0c60004  lfs        f6, 4(r6)
8045f0d8: d0410060  stfs       f2, 0x60(r1)
8045f0dc: 7c852378  mr         r5, r4
8045f0e0: c0860008  lfs        f4, 8(r6)
8045f0e4: 38630008  addi       r3, r3, 8
8045f0e8: c01e0064  lfs        f0, 0x64(r30)
8045f0ec: c0610008  lfs        f3, 8(r1)
8045f0f0: ec010028  fsubs      f0, f1, f0
8045f0f4: c041000c  lfs        f2, 0xc(r1)
8045f0f8: c0210010  lfs        f1, 0x10(r1)
8045f0fc: ed080032  fmuls      f8, f8, f0
8045f100: d1010044  stfs       f8, 0x44(r1)
8045f104: c01e0068  lfs        f0, 0x68(r30)
8045f108: ec060028  fsubs      f0, f6, f0
8045f10c: ecc70032  fmuls      f6, f7, f0
8045f110: d0c10054  stfs       f6, 0x54(r1)
8045f114: c01e006c  lfs        f0, 0x6c(r30)
8045f118: ec040028  fsubs      f0, f4, f0
8045f11c: ec850032  fmuls      f4, f5, f0
8045f120: d0810064  stfs       f4, 0x64(r1)
8045f124: c01e0064  lfs        f0, 0x64(r30)
8045f128: ec0307fc  fnmsubs    f0, f3, f31, f0
8045f12c: ec08002a  fadds      f0, f8, f0
8045f130: d0010044  stfs       f0, 0x44(r1)
8045f134: c01e0068  lfs        f0, 0x68(r30)
8045f138: ec0207fc  fnmsubs    f0, f2, f31, f0
8045f13c: ec06002a  fadds      f0, f6, f0
8045f140: d0010054  stfs       f0, 0x54(r1)
8045f144: c01e006c  lfs        f0, 0x6c(r30)
8045f148: ec0107fc  fnmsubs    f0, f1, f31, f0
8045f14c: ec04002a  fadds      f0, f4, f0
8045f150: d0010064  stfs       f0, 0x64(r1)
8045f154: 4bbdf64d  bl         0x8003e7a0
8045f158: 38610038  addi       r3, r1, 0x38
8045f15c: 38800000  li         r4, 0
8045f160: 4bbda981  bl         0x80039ae0
8045f164: 807f009c  lwz        r3, 0x9c(r31)
8045f168: 4be4c7b9  bl         0x802ab920
8045f16c: 800100b4  lwz        r0, 0xb4(r1)
8045f170: e3e100a8  psq_l      f31, 168(r1), W=0, I=0
8045f174: cbe100a0  lfd        f31, 0xa0(r1)
8045f178: 83e1009c  lwz        r31, 0x9c(r1)
8045f17c: 83c10098  lwz        r30, 0x98(r1)
8045f180: 7c0803a6  mtlr       r0
8045f184: 382100b0  addi       r1, r1, 0xb0
8045f188: 4e800020  blr        
8045f18c: 9421ffe0  stwu       r1, -0x20(r1)
8045f190: 7c0802a6  mflr       r0
8045f194: 90010024  stw        r0, 0x24(r1)
8045f198: 93e1001c  stw        r31, 0x1c(r1)
8045f19c: 7c7f1b78  mr         r31, r3
8045f1a0: 80830094  lwz        r4, 0x94(r3)
8045f1a4: 80a3009c  lwz        r5, 0x9c(r3)
8045f1a8: c0240060  lfs        f1, 0x60(r4)
8045f1ac: c0040064  lfs        f0, 0x64(r4)
8045f1b0: c044005c  lfs        f2, 0x5c(r4)
8045f1b4: c0640068  lfs        f3, 0x68(r4)
8045f1b8: d0410008  stfs       f2, 8(r1)
8045f1bc: d0450064  stfs       f2, 0x64(r5)
8045f1c0: d0250068  stfs       f1, 0x68(r5)
8045f1c4: d005006c  stfs       f0, 0x6c(r5)
8045f1c8: 8083009c  lwz        r4, 0x9c(r3)
8045f1cc: d021000c  stfs       f1, 0xc(r1)
8045f1d0: d0640070  stfs       f3, 0x70(r4)
8045f1d4: 80830094  lwz        r4, 0x94(r3)
8045f1d8: d0010010  stfs       f0, 0x10(r1)
8045f1dc: 8063009c  lwz        r3, 0x9c(r3)
8045f1e0: 38840074  addi       r4, r4, 0x74
8045f1e4: 4be4d819  bl         0x802ac9fc
8045f1e8: 807f009c  lwz        r3, 0x9c(r31)
8045f1ec: 4be4d069  bl         0x802ac254
8045f1f0: 80010024  lwz        r0, 0x24(r1)
8045f1f4: 83e1001c  lwz        r31, 0x1c(r1)
8045f1f8: 7c0803a6  mtlr       r0
8045f1fc: 38210020  addi       r1, r1, 0x20
8045f200: 4e800020  blr        
8045f204: 9421ffe0  stwu       r1, -0x20(r1)
8045f208: 7c0802a6  mflr       r0
8045f20c: 90010024  stw        r0, 0x24(r1)
8045f210: 38810008  addi       r4, r1, 8
8045f214: 93e1001c  stw        r31, 0x1c(r1)
8045f218: 7c7f1b78  mr         r31, r3
8045f21c: 80a30090  lwz        r5, 0x90(r3)
8045f220: 806dd678  lwz        r3, -0x2988(r13)
8045f224: c005005c  lfs        f0, 0x5c(r5)
8045f228: d0010008  stfs       f0, 8(r1)
8045f22c: c0050060  lfs        f0, 0x60(r5)
8045f230: d001000c  stfs       f0, 0xc(r1)
8045f234: c0050064  lfs        f0, 0x64(r5)
8045f238: d0010010  stfs       f0, 0x10(r1)
8045f23c: 80630164  lwz        r3, 0x164(r3)
8045f240: 4bffa3e5  bl         0x80459624
8045f244: 807f0098  lwz        r3, 0x98(r31)
8045f248: 38800001  li         r4, 1
8045f24c: 4be4c911  bl         0x802abb5c
8045f250: 80010024  lwz        r0, 0x24(r1)
8045f254: 83e1001c  lwz        r31, 0x1c(r1)
8045f258: 7c0803a6  mtlr       r0
8045f25c: 38210020  addi       r1, r1, 0x20
8045f260: 4e800020  blr        
8045f264: 38000001  li         r0, 1
8045f268: 9003007c  stw        r0, 0x7c(r3)
8045f26c: 4e800020  blr        
8045f270: 4e800020  blr        
8045f274: 9421ffe0  stwu       r1, -0x20(r1)
8045f278: 7c0802a6  mflr       r0
8045f27c: 90010024  stw        r0, 0x24(r1)
8045f280: bf810010  stmw       r28, 0x10(r1)
8045f284: 7c7d1b78  mr         r29, r3
8045f288: 7c9c2378  mr         r28, r4
8045f28c: 80630084  lwz        r3, 0x84(r3)
8045f290: 4bffd4a9  bl         0x8045c738
8045f294: 6b800001  xori       r0, r28, 1
8045f298: 5783103a  slwi       r3, r28, 2
8045f29c: 5400103a  slwi       r0, r0, 2
8045f2a0: 3b800002  li         r28, 2
8045f2a4: 7fdd1a14  add        r30, r29, r3
8045f2a8: 3be00010  li         r31, 0x10
8045f2ac: 7fbd0214  add        r29, r29, r0
8045f2b0: 7c7efa14  add        r3, r30, r31
8045f2b4: 38800000  li         r4, 0
8045f2b8: 806300a0  lwz        r3, 0xa0(r3)
8045f2bc: 4bddf4a1  bl         0x8023e75c
8045f2c0: 7c7dfa14  add        r3, r29, r31
8045f2c4: 38800001  li         r4, 1
8045f2c8: 806300a0  lwz        r3, 0xa0(r3)
8045f2cc: 4bddf491  bl         0x8023e75c
8045f2d0: 379cffff  addic.     r28, r28, -1
8045f2d4: 3bfffff8  addi       r31, r31, -8
8045f2d8: 4080ffd8  bge        0x8045f2b0
8045f2dc: bb810010  lmw        r28, 0x10(r1)
8045f2e0: 80010024  lwz        r0, 0x24(r1)
8045f2e4: 7c0803a6  mtlr       r0
8045f2e8: 38210020  addi       r1, r1, 0x20
8045f2ec: 4e800020  blr        
8045f2f0: 9421fff0  stwu       r1, -0x10(r1)
8045f2f4: 7c0802a6  mflr       r0
8045f2f8: 7c641b78  mr         r4, r3
8045f2fc: 90010014  stw        r0, 0x14(r1)
8045f300: 806dcbb8  lwz        r3, -0x3448(r13)
8045f304: 80840010  lwz        r4, 0x10(r4)
8045f308: 4bdd6549  bl         0x80235850
8045f30c: 80010014  lwz        r0, 0x14(r1)
8045f310: 88630000  lbz        r3, 0(r3)
8045f314: 7c0803a6  mtlr       r0
8045f318: 38210010  addi       r1, r1, 0x10
8045f31c: 4e800020  blr        
8045f320: 9421fff0  stwu       r1, -0x10(r1)
8045f324: 7c0802a6  mflr       r0
8045f328: 38830038  addi       r4, r3, 0x38
8045f32c: 90010014  stw        r0, 0x14(r1)
8045f330: 93e1000c  stw        r31, 0xc(r1)
8045f334: 7c7f1b78  mr         r31, r3
8045f338: 80a300bc  lwz        r5, 0xbc(r3)
8045f33c: 38a50024  addi       r5, r5, 0x24
8045f340: 4bfff3f5  bl         0x8045e734
8045f344: 387f0038  addi       r3, r31, 0x38
8045f348: 83e1000c  lwz        r31, 0xc(r1)
8045f34c: 80010014  lwz        r0, 0x14(r1)
8045f350: 7c0803a6  mtlr       r0
8045f354: 38210010  addi       r1, r1, 0x10
8045f358: 4e800020  blr        
8045f35c: 9421fff0  stwu       r1, -0x10(r1)
8045f360: 7c0802a6  mflr       r0
8045f364: 3883002c  addi       r4, r3, 0x2c
8045f368: 90010014  stw        r0, 0x14(r1)
8045f36c: 93e1000c  stw        r31, 0xc(r1)
8045f370: 7c7f1b78  mr         r31, r3
8045f374: 80a300bc  lwz        r5, 0xbc(r3)
8045f378: 38a5000c  addi       r5, r5, 0xc
8045f37c: 4bfff40d  bl         0x8045e788
8045f380: 387f002c  addi       r3, r31, 0x2c
8045f384: 83e1000c  lwz        r31, 0xc(r1)
8045f388: 80010014  lwz        r0, 0x14(r1)
8045f38c: 7c0803a6  mtlr       r0
8045f390: 38210010  addi       r1, r1, 0x10
8045f394: 4e800020  blr        
8045f398: 806300bc  lwz        r3, 0xbc(r3)
8045f39c: 38630024  addi       r3, r3, 0x24
8045f3a0: 4e800020  blr        
8045f3a4: 806300bc  lwz        r3, 0xbc(r3)
8045f3a8: 38630018  addi       r3, r3, 0x18
8045f3ac: 4e800020  blr        
8045f3b0: 80c4002c  lwz        r6, 0x2c(r4)
8045f3b4: 80a40030  lwz        r5, 0x30(r4)
8045f3b8: 80040034  lwz        r0, 0x34(r4)
8045f3bc: 90c30000  stw        r6, 0(r3)
8045f3c0: 90a30004  stw        r5, 4(r3)
8045f3c4: 90030008  stw        r0, 8(r3)
8045f3c8: 4e800020  blr        
8045f3cc: 806300bc  lwz        r3, 0xbc(r3)
8045f3d0: 3863000c  addi       r3, r3, 0xc
8045f3d4: 4e800020  blr        
8045f3d8: 9421fff0  stwu       r1, -0x10(r1)
8045f3dc: 7c0802a6  mflr       r0
8045f3e0: 90010014  stw        r0, 0x14(r1)
8045f3e4: 93e1000c  stw        r31, 0xc(r1)
8045f3e8: 7c7f1b78  mr         r31, r3
8045f3ec: 80630088  lwz        r3, 0x88(r3)
8045f3f0: 480080f5  bl         0x804674e4
8045f3f4: 807f00bc  lwz        r3, 0xbc(r31)
8045f3f8: 81830000  lwz        r12, 0(r3)
8045f3fc: 818c003c  lwz        r12, 0x3c(r12)
8045f400: 7d8903a6  mtctr      r12
8045f404: 4e800421  bctrl      
8045f408: 807f00d4  lwz        r3, 0xd4(r31)
8045f40c: 81830000  lwz        r12, 0(r3)
8045f410: 818c0060  lwz        r12, 0x60(r12)
8045f414: 7d8903a6  mtctr      r12
8045f418: 4e800421  bctrl      
8045f41c: 80010014  lwz        r0, 0x14(r1)
8045f420: 83e1000c  lwz        r31, 0xc(r1)
8045f424: 7c0803a6  mtlr       r0
8045f428: 38210010  addi       r1, r1, 0x10
8045f42c: 4e800020  blr        
8045f430: 4e800020  blr        
8045f434: 4e800020  blr        
8045f438: 9421fff0  stwu       r1, -0x10(r1)
8045f43c: 7c0802a6  mflr       r0
8045f440: 90010014  stw        r0, 0x14(r1)
8045f444: 93e1000c  stw        r31, 0xc(r1)
8045f448: 7c7f1b78  mr         r31, r3
8045f44c: 80630088  lwz        r3, 0x88(r3)
8045f450: 480080a1  bl         0x804674f0
8045f454: 807f00bc  lwz        r3, 0xbc(r31)
8045f458: 81830000  lwz        r12, 0(r3)
8045f45c: 818c0038  lwz        r12, 0x38(r12)
8045f460: 7d8903a6  mtctr      r12
8045f464: 4e800421  bctrl      
8045f468: 807f00d4  lwz        r3, 0xd4(r31)
8045f46c: 81830000  lwz        r12, 0(r3)
8045f470: 818c005c  lwz        r12, 0x5c(r12)
8045f474: 7d8903a6  mtctr      r12
8045f478: 4e800421  bctrl      
8045f47c: 80010014  lwz        r0, 0x14(r1)
8045f480: 83e1000c  lwz        r31, 0xc(r1)
8045f484: 7c0803a6  mtlr       r0
8045f488: 38210010  addi       r1, r1, 0x10
8045f48c: 4e800020  blr        
8045f490: 4e800020  blr        
8045f494: 4e800020  blr        
8045f498: 9421ffa0  stwu       r1, -0x60(r1)
8045f49c: 7c0802a6  mflr       r0
8045f4a0: 90010064  stw        r0, 0x64(r1)
8045f4a4: 38810020  addi       r4, r1, 0x20
8045f4a8: 93e1005c  stw        r31, 0x5c(r1)
8045f4ac: 7c7f1b78  mr         r31, r3
8045f4b0: 93c10058  stw        r30, 0x58(r1)
8045f4b4: 80a30088  lwz        r5, 0x88(r3)
8045f4b8: 38a500c8  addi       r5, r5, 0xc8
8045f4bc: 4bfff2cd  bl         0x8045e788
8045f4c0: 80bf0088  lwz        r5, 0x88(r31)
8045f4c4: 7fe3fb78  mr         r3, r31
8045f4c8: 3881002c  addi       r4, r1, 0x2c
8045f4cc: 3bc500d4  addi       r30, r5, 0xd4
8045f4d0: 7fc5f378  mr         r5, r30
8045f4d4: 4bfff2b5  bl         0x8045e788
8045f4d8: 7fe3fb78  mr         r3, r31
8045f4dc: 38810038  addi       r4, r1, 0x38
8045f4e0: 38be000c  addi       r5, r30, 0xc
8045f4e4: 4bfff2a5  bl         0x8045e788
8045f4e8: 7fe3fb78  mr         r3, r31
8045f4ec: 38810044  addi       r4, r1, 0x44
8045f4f0: 38be0018  addi       r5, r30, 0x18
8045f4f4: 4bfff295  bl         0x8045e788
8045f4f8: 80bf00bc  lwz        r5, 0xbc(r31)
8045f4fc: 7fe3fb78  mr         r3, r31
