8045c800: 9421fed0  stwu       r1, -0x130(r1)
8045c804: 7c0802a6  mflr       r0
8045c808: 38800013  li         r4, 0x13
8045c80c: 90010134  stw        r0, 0x134(r1)
8045c810: 93e1012c  stw        r31, 0x12c(r1)
8045c814: 7c7f1b78  mr         r31, r3
8045c818: 93c10128  stw        r30, 0x128(r1)
8045c81c: 8063001c  lwz        r3, 0x1c(r3)
8045c820: 4bf10921  bl         0x8036d140
8045c824: 38000006  li         r0, 6
8045c828: 38a100ec  addi       r5, r1, 0xec
8045c82c: 3883fffc  addi       r4, r3, -4
8045c830: 7c0903a6  mtctr      r0
8045c834: 80640004  lwz        r3, 4(r4)
8045c838: 84040008  lwzu       r0, 8(r4)
8045c83c: 90650004  stw        r3, 4(r5)
8045c840: 94050008  stwu       r0, 8(r5)
8045c844: 4200fff0  bdnz       0x8045c834
8045c848: c0e20e2c  lfs        f7, 0xe2c(r2) ; [806feeac] 3e19999a f32=0.150000006
8045c84c: c04100f4  lfs        f2, 0xf4(r1)
8045c850: c0210104  lfs        f1, 0x104(r1)
8045c854: eca201f2  fmuls      f5, f2, f7
8045c858: c0010114  lfs        f0, 0x114(r1)
8045c85c: ec6101f2  fmuls      f3, f1, f7
8045c860: c0c20e28  lfs        f6, 0xe28(r2) ; [806feea8] be99999a f32=-0.300000012
8045c864: ec2001f2  fmuls      f1, f0, f7
8045c868: c08100f0  lfs        f4, 0xf0(r1)
8045c86c: c0410100  lfs        f2, 0x100(r1)
8045c870: eca429ba  fmadds     f5, f4, f6, f5
8045c874: c0010110  lfs        f0, 0x110(r1)
8045c878: ec6219ba  fmadds     f3, f2, f6, f3
8045c87c: c08100fc  lfs        f4, 0xfc(r1)
8045c880: ec2009ba  fmadds     f1, f0, f6, f1
8045c884: c041010c  lfs        f2, 0x10c(r1)
8045c888: c001011c  lfs        f0, 0x11c(r1)
8045c88c: ec84282a  fadds      f4, f4, f5
8045c890: ec42182a  fadds      f2, f2, f3
8045c894: d08100fc  stfs       f4, 0xfc(r1)
8045c898: ec00082a  fadds      f0, f0, f1
8045c89c: d041010c  stfs       f2, 0x10c(r1)
8045c8a0: d001011c  stfs       f0, 0x11c(r1)
8045c8a4: 801f02f4  lwz        r0, 0x2f4(r31)
8045c8a8: 2c000000  cmpwi      r0, 0
8045c8ac: 41820028  beq        0x8045c8d4
8045c8b0: c04100f8  lfs        f2, 0xf8(r1)
8045c8b4: c0210108  lfs        f1, 0x108(r1)
8045c8b8: c0010118  lfs        f0, 0x118(r1)
8045c8bc: fc401050  fneg       f2, f2
8045c8c0: fc200850  fneg       f1, f1
8045c8c4: fc000050  fneg       f0, f0
8045c8c8: d04100f8  stfs       f2, 0xf8(r1)
8045c8cc: d0210108  stfs       f1, 0x108(r1)
8045c8d0: d0010118  stfs       f0, 0x118(r1)
8045c8d4: 807f0014  lwz        r3, 0x14(r31)
8045c8d8: 388100f0  addi       r4, r1, 0xf0
8045c8dc: 4bd89425  bl         0x801e5d00
8045c8e0: 807f0014  lwz        r3, 0x14(r31)
8045c8e4: 4bdf17a9  bl         0x8024e08c
8045c8e8: 807f0014  lwz        r3, 0x14(r31)
8045c8ec: 4bdf1769  bl         0x8024e054
8045c8f0: 807f001c  lwz        r3, 0x1c(r31)
8045c8f4: 38800006  li         r4, 6
8045c8f8: 4bf10849  bl         0x8036d140
8045c8fc: 80bf0020  lwz        r5, 0x20(r31)
8045c900: 7c641b78  mr         r4, r3
8045c904: c003000c  lfs        f0, 0xc(r3)
8045c908: d005000c  stfs       f0, 0xc(r5)
8045c90c: c003001c  lfs        f0, 0x1c(r3)
8045c910: d0050010  stfs       f0, 0x10(r5)
8045c914: c003002c  lfs        f0, 0x2c(r3)
8045c918: d0050014  stfs       f0, 0x14(r5)
8045c91c: 807f0020  lwz        r3, 0x20(r31)
8045c920: 38630018  addi       r3, r3, 0x18
8045c924: 4becb5b9  bl         0x80327edc
8045c928: 807f001c  lwz        r3, 0x1c(r31)
8045c92c: 3880000e  li         r4, 0xe
8045c930: 4bf10811  bl         0x8036d140
8045c934: 80bf0024  lwz        r5, 0x24(r31)
8045c938: 7c641b78  mr         r4, r3
8045c93c: c003000c  lfs        f0, 0xc(r3)
8045c940: d005000c  stfs       f0, 0xc(r5)
8045c944: c003001c  lfs        f0, 0x1c(r3)
8045c948: d0050010  stfs       f0, 0x10(r5)
8045c94c: c003002c  lfs        f0, 0x2c(r3)
8045c950: d0050014  stfs       f0, 0x14(r5)
8045c954: 807f0024  lwz        r3, 0x24(r31)
8045c958: 38630018  addi       r3, r3, 0x18
8045c95c: 4becb581  bl         0x80327edc
8045c960: 801f02f4  lwz        r0, 0x2f4(r31)
8045c964: 2c000000  cmpwi      r0, 0
8045c968: 41820084  beq        0x8045c9ec
8045c96c: 809f0020  lwz        r4, 0x20(r31)
8045c970: 38610044  addi       r3, r1, 0x44
8045c974: c0240018  lfs        f1, 0x18(r4)
8045c978: c044001c  lfs        f2, 0x1c(r4)
8045c97c: c0040020  lfs        f0, 0x20(r4)
8045c980: fc200850  fneg       f1, f1
8045c984: fc401050  fneg       f2, f2
8045c988: fc600050  fneg       f3, f0
8045c98c: 4bcd4385  bl         0x80130d10
8045c990: 809f0020  lwz        r4, 0x20(r31)
8045c994: 38610038  addi       r3, r1, 0x38
8045c998: c0010044  lfs        f0, 0x44(r1)
8045c99c: d0040018  stfs       f0, 0x18(r4)
8045c9a0: c0010048  lfs        f0, 0x48(r1)
8045c9a4: d004001c  stfs       f0, 0x1c(r4)
8045c9a8: c001004c  lfs        f0, 0x4c(r1)
8045c9ac: d0040020  stfs       f0, 0x20(r4)
8045c9b0: 809f0024  lwz        r4, 0x24(r31)
8045c9b4: c0240018  lfs        f1, 0x18(r4)
8045c9b8: c044001c  lfs        f2, 0x1c(r4)
8045c9bc: c0040020  lfs        f0, 0x20(r4)
8045c9c0: fc200850  fneg       f1, f1
8045c9c4: fc401050  fneg       f2, f2
8045c9c8: fc600050  fneg       f3, f0
8045c9cc: 4bcd4345  bl         0x80130d10
8045c9d0: 807f0024  lwz        r3, 0x24(r31)
8045c9d4: c0010038  lfs        f0, 0x38(r1)
8045c9d8: d0030018  stfs       f0, 0x18(r3)
8045c9dc: c001003c  lfs        f0, 0x3c(r1)
8045c9e0: d003001c  stfs       f0, 0x1c(r3)
8045c9e4: c0010040  lfs        f0, 0x40(r1)
8045c9e8: d0030020  stfs       f0, 0x20(r3)
8045c9ec: 807f0020  lwz        r3, 0x20(r31)
8045c9f0: 4becb859  bl         0x80328248
8045c9f4: 807f0024  lwz        r3, 0x24(r31)
8045c9f8: 4becb851  bl         0x80328248
8045c9fc: 807f0020  lwz        r3, 0x20(r31)
8045ca00: 4becb841  bl         0x80328240
8045ca04: 807f0024  lwz        r3, 0x24(r31)
8045ca08: 4becb839  bl         0x80328240
8045ca0c: 801f02f4  lwz        r0, 0x2f4(r31)
8045ca10: 2c000000  cmpwi      r0, 0
8045ca14: 41820074  beq        0x8045ca88
8045ca18: c03f0078  lfs        f1, 0x78(r31)
8045ca1c: 3861002c  addi       r3, r1, 0x2c
8045ca20: c05f007c  lfs        f2, 0x7c(r31)
8045ca24: c01f0080  lfs        f0, 0x80(r31)
8045ca28: fc200850  fneg       f1, f1
8045ca2c: fc401050  fneg       f2, f2
8045ca30: fc600050  fneg       f3, f0
8045ca34: 4bcd42dd  bl         0x80130d10
8045ca38: c001002c  lfs        f0, 0x2c(r1)
8045ca3c: 38610020  addi       r3, r1, 0x20
8045ca40: d01f0078  stfs       f0, 0x78(r31)
8045ca44: c01f0084  lfs        f0, 0x84(r31)
8045ca48: c0210030  lfs        f1, 0x30(r1)
8045ca4c: d03f007c  stfs       f1, 0x7c(r31)
8045ca50: fc200050  fneg       f1, f0
8045ca54: c05f0088  lfs        f2, 0x88(r31)
8045ca58: c01f008c  lfs        f0, 0x8c(r31)
8045ca5c: c0810034  lfs        f4, 0x34(r1)
8045ca60: fc401050  fneg       f2, f2
8045ca64: fc600050  fneg       f3, f0
8045ca68: d09f0080  stfs       f4, 0x80(r31)
8045ca6c: 4bcd42a5  bl         0x80130d10
8045ca70: c0010020  lfs        f0, 0x20(r1)
8045ca74: d01f0084  stfs       f0, 0x84(r31)
8045ca78: c0010024  lfs        f0, 0x24(r1)
8045ca7c: d01f0088  stfs       f0, 0x88(r31)
8045ca80: c0010028  lfs        f0, 0x28(r1)
8045ca84: d01f008c  stfs       f0, 0x8c(r31)
8045ca88: 809f0028  lwz        r4, 0x28(r31)
8045ca8c: 38610014  addi       r3, r1, 0x14
8045ca90: c01f0084  lfs        f0, 0x84(r31)
8045ca94: d0040018  stfs       f0, 0x18(r4)
8045ca98: c01f0088  lfs        f0, 0x88(r31)
8045ca9c: d004001c  stfs       f0, 0x1c(r4)
8045caa0: c01f008c  lfs        f0, 0x8c(r31)
8045caa4: d0040020  stfs       f0, 0x20(r4)
8045caa8: c03f0078  lfs        f1, 0x78(r31)
8045caac: c05f007c  lfs        f2, 0x7c(r31)
8045cab0: c01f0080  lfs        f0, 0x80(r31)
8045cab4: fc200850  fneg       f1, f1
8045cab8: fc401050  fneg       f2, f2
8045cabc: fc600050  fneg       f3, f0
8045cac0: 4bcd4251  bl         0x80130d10
8045cac4: 80df0028  lwz        r6, 0x28(r31)
8045cac8: 3ca0807d  lis        r5, -0x7f83
8045cacc: c0010014  lfs        f0, 0x14(r1)
8045cad0: 38610050  addi       r3, r1, 0x50
8045cad4: d0060024  stfs       f0, 0x24(r6)
8045cad8: 389f0078  addi       r4, r31, 0x78
8045cadc: 38a53550  addi       r5, r5, 0x3550
8045cae0: c0010018  lfs        f0, 0x18(r1)
8045cae4: d0060028  stfs       f0, 0x28(r6)
8045cae8: c001001c  lfs        f0, 0x1c(r1)
8045caec: d006002c  stfs       f0, 0x2c(r6)
8045caf0: 80df0028  lwz        r6, 0x28(r31)
8045caf4: c01f0090  lfs        f0, 0x90(r31)
8045caf8: d0060030  stfs       f0, 0x30(r6)
8045cafc: c01f0094  lfs        f0, 0x94(r31)
