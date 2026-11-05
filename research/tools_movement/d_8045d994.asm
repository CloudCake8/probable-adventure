8045d994: 9421ff20  stwu       r1, -0xe0(r1)
8045d998: 7c0802a6  mflr       r0
8045d99c: 900100e4  stw        r0, 0xe4(r1)
8045d9a0: 396100c0  addi       r11, r1, 0xc0
8045d9a4: dbe100d0  stfd       f31, 0xd0(r1)
8045d9a8: f3e100d8  psq_st     f31, 216(r1), W=0, I=0
8045d9ac: dbc100c0  stfd       f30, 0xc0(r1)
8045d9b0: f3c100c8  psq_st     f30, 200(r1), W=0, I=0
8045d9b4: 4bba9e85  bl         0x80007838
8045d9b8: 7c751b78  mr         r21, r3
8045d9bc: 7c962378  mr         r22, r4
8045d9c0: 7cb72b78  mr         r23, r5
8045d9c4: 7cd83378  mr         r24, r6
8045d9c8: 480011d1  bl         0x8045eb98
8045d9cc: 2c030000  cmpwi      r3, 0
8045d9d0: 7c7c1b78  mr         r28, r3
8045d9d4: 4082000c  bne        0x8045d9e0
8045d9d8: 38600000  li         r3, 0
8045d9dc: 48000468  b          0x8045de44
8045d9e0: 7ea3ab78  mr         r3, r21
8045d9e4: 48001a55  bl         0x8045f438
8045d9e8: 7f83e378  mr         r3, r28
8045d9ec: 4800dd19  bl         0x8046b704
8045d9f0: 80cdd678  lwz        r6, -0x2988(r13)
8045d9f4: 7ea3ab78  mr         r3, r21
8045d9f8: 3881001c  addi       r4, r1, 0x1c
8045d9fc: 38bc0008  addi       r5, r28, 8
8045da00: 83a6014c  lwz        r29, 0x14c(r6)
8045da04: 3b600000  li         r27, 0
8045da08: 48000d81  bl         0x8045e788
8045da0c: cbe20e40  lfd        f31, 0xe40(r2) ; [806feec0] 43300000 f32=176
8045da10: 6fbf8000  xoris      r31, r29, 0x8000
8045da14: 3b400000  li         r26, 0
8045da18: 3a800001  li         r20, 1
8045da1c: 3fc04330  lis        r30, 0x4330
8045da20: 7c1ab050  subf       r0, r26, r22
8045da24: 807500ec  lwz        r3, 0xec(r21)
8045da28: 7c000034  cntlzw     r0, r0
8045da2c: 38800001  li         r4, 1
8045da30: 5405d97e  srwi       r5, r0, 5
8045da34: 4801f941  bl         0x8047d374
8045da38: 83350088  lwz        r25, 0x88(r21)
8045da3c: 80b500ec  lwz        r5, 0xec(r21)
8045da40: 38790064  addi       r3, r25, 0x64
8045da44: 38990040  addi       r4, r25, 0x40
8045da48: 3a65000c  addi       r19, r5, 0xc
8045da4c: 48000471  bl         0x8045debc
8045da50: 7e649b78  mr         r4, r19
8045da54: 38790040  addi       r3, r25, 0x40
8045da58: 48000465  bl         0x8045debc
8045da5c: 807500ec  lwz        r3, 0xec(r21)
8045da60: 81830000  lwz        r12, 0(r3)
8045da64: 818c002c  lwz        r12, 0x2c(r12)
8045da68: 7d8903a6  mtctr      r12
8045da6c: 4e800421  bctrl      
8045da70: 80750088  lwz        r3, 0x88(r21)
8045da74: d02300ac  stfs       f1, 0xac(r3)
8045da78: 807500ec  lwz        r3, 0xec(r21)
8045da7c: 81830000  lwz        r12, 0(r3)
8045da80: 818c0030  lwz        r12, 0x30(r12)
8045da84: 7d8903a6  mtctr      r12
8045da88: 4e800421  bctrl      
8045da8c: 80750088  lwz        r3, 0x88(r21)
8045da90: d02300b0  stfs       f1, 0xb0(r3)
8045da94: 807500d4  lwz        r3, 0xd4(r21)
8045da98: 81830000  lwz        r12, 0(r3)
8045da9c: 818c0034  lwz        r12, 0x34(r12)
8045daa0: 7d8903a6  mtctr      r12
8045daa4: 4e800421  bctrl      
8045daa8: 2c030000  cmpwi      r3, 0
8045daac: 80750088  lwz        r3, 0x88(r21)
8045dab0: 41820014  beq        0x8045dac4
8045dab4: 800300f8  lwz        r0, 0xf8(r3)
8045dab8: 60000001  ori        r0, r0, 1
8045dabc: 900300f8  stw        r0, 0xf8(r3)
8045dac0: 48000010  b          0x8045dad0
8045dac4: 800300f8  lwz        r0, 0xf8(r3)
8045dac8: 5400003c  rlwinm     r0, r0, 0, 0, 0x1e
8045dacc: 900300f8  stw        r0, 0xf8(r3)
8045dad0: 807500d4  lwz        r3, 0xd4(r21)
8045dad4: 81830000  lwz        r12, 0(r3)
8045dad8: 818c0038  lwz        r12, 0x38(r12)
8045dadc: 7d8903a6  mtctr      r12
8045dae0: 4e800421  bctrl      
8045dae4: 80950088  lwz        r4, 0x88(r21)
8045dae8: c0030000  lfs        f0, 0(r3)
8045daec: d00400b4  stfs       f0, 0xb4(r4)
8045daf0: c0030004  lfs        f0, 4(r3)
8045daf4: d00400b8  stfs       f0, 0xb8(r4)
8045daf8: c0030008  lfs        f0, 8(r3)
8045dafc: d00400bc  stfs       f0, 0xbc(r4)
8045db00: 807500d4  lwz        r3, 0xd4(r21)
8045db04: 81830000  lwz        r12, 0(r3)
8045db08: 818c003c  lwz        r12, 0x3c(r12)
8045db0c: 7d8903a6  mtctr      r12
8045db10: 4e800421  bctrl      
8045db14: 2c030000  cmpwi      r3, 0
8045db18: 80750088  lwz        r3, 0x88(r21)
8045db1c: 41820014  beq        0x8045db30
8045db20: 800300f8  lwz        r0, 0xf8(r3)
8045db24: 60000002  ori        r0, r0, 2
8045db28: 900300f8  stw        r0, 0xf8(r3)
8045db2c: 48000010  b          0x8045db3c
8045db30: 800300f8  lwz        r0, 0xf8(r3)
8045db34: 540007fa  rlwinm     r0, r0, 0, 0x1f, 0x1d
8045db38: 900300f8  stw        r0, 0xf8(r3)
8045db3c: 807500d4  lwz        r3, 0xd4(r21)
8045db40: 81830000  lwz        r12, 0(r3)
8045db44: 818c0040  lwz        r12, 0x40(r12)
8045db48: 7d8903a6  mtctr      r12
8045db4c: 4e800421  bctrl      
8045db50: 80750088  lwz        r3, 0x88(r21)
8045db54: d02300c0  stfs       f1, 0xc0(r3)
8045db58: 807500d4  lwz        r3, 0xd4(r21)
8045db5c: 81830000  lwz        r12, 0(r3)
8045db60: 818c0044  lwz        r12, 0x44(r12)
8045db64: 7d8903a6  mtctr      r12
8045db68: 4e800421  bctrl      
8045db6c: 2c030000  cmpwi      r3, 0
8045db70: 80750088  lwz        r3, 0x88(r21)
8045db74: 41820014  beq        0x8045db88
8045db78: 800300f8  lwz        r0, 0xf8(r3)
8045db7c: 60000004  ori        r0, r0, 4
8045db80: 900300f8  stw        r0, 0xf8(r3)
8045db84: 48000010  b          0x8045db94
8045db88: 800300f8  lwz        r0, 0xf8(r3)
8045db8c: 540007b8  rlwinm     r0, r0, 0, 0x1e, 0x1c
8045db90: 900300f8  stw        r0, 0xf8(r3)
8045db94: 807500d4  lwz        r3, 0xd4(r21)
8045db98: 81830000  lwz        r12, 0(r3)
8045db9c: 818c0074  lwz        r12, 0x74(r12)
8045dba0: 7d8903a6  mtctr      r12
8045dba4: 4e800421  bctrl      
8045dba8: 80750088  lwz        r3, 0x88(r21)
8045dbac: d02300c4  stfs       f1, 0xc4(r3)
8045dbb0: 807500ec  lwz        r3, 0xec(r21)
8045dbb4: 4800b3b1  bl         0x80468f64
8045dbb8: 2c030000  cmpwi      r3, 0
8045dbbc: 41820074  beq        0x8045dc30
8045dbc0: 807500ec  lwz        r3, 0xec(r21)
8045dbc4: 81830000  lwz        r12, 0(r3)
8045dbc8: 818c0028  lwz        r12, 0x28(r12)
8045dbcc: 7d8903a6  mtctr      r12
8045dbd0: 4e800421  bctrl      
8045dbd4: 7c641b78  mr         r4, r3
8045dbd8: 80750088  lwz        r3, 0x88(r21)
8045dbdc: 38a00000  li         r5, 0
8045dbe0: 48007ed9  bl         0x80465ab8
8045dbe4: 7c731b78  mr         r19, r3
8045dbe8: 807500ec  lwz        r3, 0xec(r21)
8045dbec: 81830000  lwz        r12, 0(r3)
8045dbf0: 818c0028  lwz        r12, 0x28(r12)
8045dbf4: 7d8903a6  mtctr      r12
8045dbf8: 4e800421  bctrl      
8045dbfc: 7c651b78  mr         r5, r3
8045dc00: 807500bc  lwz        r3, 0xbc(r21)
8045dc04: 7e649b78  mr         r4, r19
8045dc08: 81830000  lwz        r12, 0(r3)
8045dc0c: 818c0028  lwz        r12, 0x28(r12)
8045dc10: 7d8903a6  mtctr      r12
8045dc14: 4e800421  bctrl      
8045dc18: 809500bc  lwz        r4, 0xbc(r21)
8045dc1c: 2c130000  cmpwi      r19, 0
8045dc20: 80750088  lwz        r3, 0x88(r21)
8045dc24: c004004c  lfs        f0, 0x4c(r4)
8045dc28: d00301ac  stfs       f0, 0x1ac(r3)
8045dc2c: 41820204  beq        0x8045de30
8045dc30: 3b200000  li         r25, 0
8045dc34: 38190001  addi       r0, r25, 1
8045dc38: c041001c  lfs        f2, 0x1c(r1)
8045dc3c: 6c008000  xoris      r0, r0, 0x8000
8045dc40: 90010074  stw        r0, 0x74(r1)
8045dc44: c0210020  lfs        f1, 0x20(r1)
8045dc48: 7f83e378  mr         r3, r28
8045dc4c: 93c10070  stw        r30, 0x70(r1)
8045dc50: c0010024  lfs        f0, 0x24(r1)
8045dc54: c8610070  lfd        f3, 0x70(r1)
8045dc58: 93e1007c  stw        r31, 0x7c(r1)
8045dc5c: ec83f828  fsubs      f4, f3, f31
8045dc60: 93c10078  stw        r30, 0x78(r1)
8045dc64: c8610078  lfd        f3, 0x78(r1)
8045dc68: d0410010  stfs       f2, 0x10(r1)
8045dc6c: ec43f828  fsubs      f2, f3, f31
8045dc70: d0210014  stfs       f1, 0x14(r1)
8045dc74: efc41024  fdivs      f30, f4, f2
8045dc78: d0010018  stfs       f0, 0x18(r1)
8045dc7c: 4800e3c1  bl         0x8046c03c
8045dc80: 801c0178  lwz        r0, 0x178(r28)
8045dc84: 2c000002  cmpwi      r0, 2
8045dc88: 408001a8  bge        0x8045de30
8045dc8c: 7ea3ab78  mr         r3, r21
8045dc90: 3881001c  addi       r4, r1, 0x1c
8045dc94: 38bc0008  addi       r5, r28, 8
8045dc98: 48000af1  bl         0x8045e788
8045dc9c: 807500bc  lwz        r3, 0xbc(r21)
8045dca0: 48003d61  bl         0x80461a00
8045dca4: 807500bc  lwz        r3, 0xbc(r21)
8045dca8: fc20f090  fmr        f1, f30
8045dcac: 80950088  lwz        r4, 0x88(r21)
8045dcb0: c003000c  lfs        f0, 0xc(r3)
8045dcb4: d0040010  stfs       f0, 0x10(r4)
8045dcb8: c0030010  lfs        f0, 0x10(r3)
8045dcbc: d0040014  stfs       f0, 0x14(r4)
8045dcc0: c0030014  lfs        f0, 0x14(r3)
8045dcc4: d0040018  stfs       f0, 0x18(r4)
8045dcc8: 809500bc  lwz        r4, 0xbc(r21)
8045dccc: 80b50088  lwz        r5, 0x88(r21)
8045dcd0: 80040028  lwz        r0, 0x28(r4)
8045dcd4: 80640024  lwz        r3, 0x24(r4)
8045dcd8: 9065001c  stw        r3, 0x1c(r5)
8045dcdc: 90050020  stw        r0, 0x20(r5)
8045dce0: 8004002c  lwz        r0, 0x2c(r4)
8045dce4: 90050024  stw        r0, 0x24(r5)
8045dce8: 80040034  lwz        r0, 0x34(r4)
8045dcec: 80640030  lwz        r3, 0x30(r4)
8045dcf0: 90650028  stw        r3, 0x28(r5)
8045dcf4: 9005002c  stw        r0, 0x2c(r5)
8045dcf8: 80040038  lwz        r0, 0x38(r4)
8045dcfc: 90050030  stw        r0, 0x30(r5)
8045dd00: 80040040  lwz        r0, 0x40(r4)
8045dd04: 8064003c  lwz        r3, 0x3c(r4)
8045dd08: 90650034  stw        r3, 0x34(r5)
8045dd0c: 90050038  stw        r0, 0x38(r5)
8045dd10: 80040044  lwz        r0, 0x44(r4)
8045dd14: 9005003c  stw        r0, 0x3c(r5)
8045dd18: 80750088  lwz        r3, 0x88(r21)
8045dd1c: 48009e31  bl         0x80467b4c
8045dd20: 92810008  stw        r20, 8(r1)
8045dd24: 38810010  addi       r4, r1, 0x10
8045dd28: 38a1001c  addi       r5, r1, 0x1c
8045dd2c: 38c10040  addi       r6, r1, 0x40
8045dd30: 80750088  lwz        r3, 0x88(r21)
8045dd34: 38e10034  addi       r7, r1, 0x34
8045dd38: 39010028  addi       r8, r1, 0x28
8045dd3c: 3921004c  addi       r9, r1, 0x4c
8045dd40: 39400008  li         r10, 8
8045dd44: 480083bd  bl         0x80466100
8045dd48: 2c030000  cmpwi      r3, 0
8045dd4c: 41820074  beq        0x8045ddc0
8045dd50: 2c030001  cmpwi      r3, 1
8045dd54: 4082002c  bne        0x8045dd80
8045dd58: 801c0184  lwz        r0, 0x184(r28)
8045dd5c: 2c000010  cmpwi      r0, 0x10
8045dd60: 418000d0  blt        0x8045de30
8045dd64: c0010034  lfs        f0, 0x34(r1)
8045dd68: d0170000  stfs       f0, 0(r23)
8045dd6c: c0010038  lfs        f0, 0x38(r1)
8045dd70: d0170004  stfs       f0, 4(r23)
8045dd74: c001003c  lfs        f0, 0x3c(r1)
8045dd78: d0170008  stfs       f0, 8(r23)
8045dd7c: 48000024  b          0x8045dda0
8045dd80: 3c60807d  lis        r3, -0x7f83
8045dd84: c0030318  lfs        f0, 0x318(r3)
8045dd88: 38630318  addi       r3, r3, 0x318
8045dd8c: d0170000  stfs       f0, 0(r23)
8045dd90: c0030004  lfs        f0, 4(r3)
8045dd94: d0170004  stfs       f0, 4(r23)
8045dd98: c0030008  lfs        f0, 8(r3)
8045dd9c: d0170008  stfs       f0, 8(r23)
8045dda0: c0010040  lfs        f0, 0x40(r1)
8045dda4: 7f9be378  mr         r27, r28
8045dda8: d0180000  stfs       f0, 0(r24)
8045ddac: c0010044  lfs        f0, 0x44(r1)
8045ddb0: d0180004  stfs       f0, 4(r24)
8045ddb4: c0010048  lfs        f0, 0x48(r1)
8045ddb8: d0180008  stfs       f0, 8(r24)
8045ddbc: 48000074  b          0x8045de30
8045ddc0: 8075008c  lwz        r3, 0x8c(r21)
8045ddc4: 38800000  li         r4, 0
8045ddc8: 48020fbd  bl         0x8047ed84
8045ddcc: 801c0250  lwz        r0, 0x250(r28)
8045ddd0: 540007ff  clrlwi.    r0, r0, 0x1f
8045ddd4: 41820044  beq        0x8045de18
8045ddd8: 3c60807d  lis        r3, -0x7f83
8045dddc: 7f9be378  mr         r27, r28
8045dde0: c0030318  lfs        f0, 0x318(r3)
8045dde4: 38630318  addi       r3, r3, 0x318
8045dde8: d0170000  stfs       f0, 0(r23)
8045ddec: c0030004  lfs        f0, 4(r3)
8045ddf0: d0170004  stfs       f0, 4(r23)
8045ddf4: c0030008  lfs        f0, 8(r3)
8045ddf8: d0170008  stfs       f0, 8(r23)
8045ddfc: c01c0008  lfs        f0, 8(r28)
8045de00: d0180000  stfs       f0, 0(r24)
8045de04: c01c000c  lfs        f0, 0xc(r28)
8045de08: d0180004  stfs       f0, 4(r24)
8045de0c: c01c0010  lfs        f0, 0x10(r28)
8045de10: d0180008  stfs       f0, 8(r24)
8045de14: 4800001c  b          0x8045de30
8045de18: 3b390001  addi       r25, r25, 1
8045de1c: 7c19e800  cmpw       r25, r29
8045de20: 4180fe14  blt        0x8045dc34
8045de24: 3b5a0001  addi       r26, r26, 1
8045de28: 2c1a0018  cmpwi      r26, 0x18
8045de2c: 4180fbf4  blt        0x8045da20
8045de30: 7ea3ab78  mr         r3, r21
8045de34: 480015a5  bl         0x8045f3d8
8045de38: 7f83e378  mr         r3, r28
8045de3c: 4800d8c1  bl         0x8046b6fc
8045de40: 7f63db78  mr         r3, r27
8045de44: 396100c0  addi       r11, r1, 0xc0
8045de48: e3e100d8  psq_l      f31, 216(r1), W=0, I=0
8045de4c: cbe100d0  lfd        f31, 0xd0(r1)
8045de50: e3c100c8  psq_l      f30, 200(r1), W=0, I=0
8045de54: cbc100c0  lfd        f30, 0xc0(r1)
8045de58: 4bba9a2d  bl         0x80007884
8045de5c: 800100e4  lwz        r0, 0xe4(r1)
8045de60: 7c0803a6  mtlr       r0
8045de64: 382100e0  addi       r1, r1, 0xe0
8045de68: 4e800020  blr        
8045de6c: 4e800020  blr        
8045de70: 38600000  li         r3, 0
8045de74: 4e800020  blr        
8045de78: c0220e48  lfs        f1, 0xe48(r2) ; [806feec8] 00000000 f32=0
8045de7c: 4e800020  blr        
8045de80: 38600000  li         r3, 0
8045de84: 4e800020  blr        
8045de88: c0220e4c  lfs        f1, 0xe4c(r2) ; [806feecc] bf800000 f32=-1
8045de8c: 4e800020  blr        
8045de90: 38600000  li         r3, 0
8045de94: 4e800020  blr        
8045de98: 3c60807d  lis        r3, -0x7f83
8045de9c: 3863033c  addi       r3, r3, 0x33c
8045dea0: 4e800020  blr        
8045dea4: 38600000  li         r3, 0
8045dea8: 4e800020  blr        
8045deac: c0220e48  lfs        f1, 0xe48(r2) ; [806feec8] 00000000 f32=0
8045deb0: 4e800020  blr        
8045deb4: c0220e48  lfs        f1, 0xe48(r2) ; [806feec8] 00000000 f32=0
8045deb8: 4e800020  blr        
8045debc: 81840000  lwz        r12, 0(r4)
8045dec0: 81640004  lwz        r11, 4(r4)
8045dec4: 81440008  lwz        r10, 8(r4)
8045dec8: 8124000c  lwz        r9, 0xc(r4)
8045decc: 81040010  lwz        r8, 0x10(r4)
8045ded0: 80e40014  lwz        r7, 0x14(r4)
8045ded4: 80c40018  lwz        r6, 0x18(r4)
8045ded8: 80a4001c  lwz        r5, 0x1c(r4)
8045dedc: 80040020  lwz        r0, 0x20(r4)
8045dee0: 91830000  stw        r12, 0(r3)
8045dee4: 91630004  stw        r11, 4(r3)
8045dee8: 91430008  stw        r10, 8(r3)
8045deec: 9123000c  stw        r9, 0xc(r3)
8045def0: 91030010  stw        r8, 0x10(r3)
8045def4: 90e30014  stw        r7, 0x14(r3)
8045def8: 90c30018  stw        r6, 0x18(r3)
8045defc: 90a3001c  stw        r5, 0x1c(r3)
8045df00: 90030020  stw        r0, 0x20(r3)
8045df04: 4e800020  blr        
