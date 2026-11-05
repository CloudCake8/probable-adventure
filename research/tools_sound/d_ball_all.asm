80469b00: c0040008  lfs        f0, 8(r4)
80469b04: d0430008  stfs       f2, 8(r3)
80469b08: d023000c  stfs       f1, 0xc(r3)
80469b0c: d0030010  stfs       f0, 0x10(r3)
80469b10: 4bed4cd8  b          0x8033e7e8
80469b14: c02d9fd0  lfs        f1, -0x6030(r13) ; [806f20f0] 3f90a3d7 f32=1.13
80469b18: 4e800020  blr        
80469b1c: 80030194  lwz        r0, 0x194(r3)
80469b20: 2c000000  cmpwi      r0, 0
80469b24: 4082000c  bne        0x80469b30
80469b28: 38600000  li         r3, 0
80469b2c: 4e800020  blr        
80469b30: 80030250  lwz        r0, 0x250(r3)
80469b34: 540007fe  clrlwi     r0, r0, 0x1f
80469b38: 7c000034  cntlzw     r0, r0
80469b3c: 5403d97e  srwi       r3, r0, 5
80469b40: 4e800020  blr        
80469b44: 9421ffe0  stwu       r1, -0x20(r1)
80469b48: 7c0802a6  mflr       r0
80469b4c: c042103c  lfs        f2, 0x103c(r2) ; [806ff0bc] 3e4ccccc f32=0.199999988
80469b50: 38a00000  li         r5, 0
80469b54: 90010024  stw        r0, 0x24(r1)
80469b58: 38810008  addi       r4, r1, 8
80469b5c: c0021038  lfs        f0, 0x1038(r2) ; [806ff0b8] 3e19999a f32=0.150000006
80469b60: 93e1001c  stw        r31, 0x1c(r1)
80469b64: 7c7f1b78  mr         r31, r3
80469b68: c0621034  lfs        f3, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
80469b6c: ec02007a  fmadds     f0, f2, f1, f0
80469b70: d0610010  stfs       f3, 0x10(r1)
80469b74: d0610008  stfs       f3, 8(r1)
80469b78: d001000c  stfs       f0, 0xc(r1)
80469b7c: 480002fd  bl         0x80469e78
80469b80: 807f00f8  lwz        r3, 0xf8(r31)
80469b84: 38800000  li         r4, 0
80469b88: 48005dc5  bl         0x8046f94c
80469b8c: 80010024  lwz        r0, 0x24(r1)
80469b90: 83e1001c  lwz        r31, 0x1c(r1)
80469b94: 7c0803a6  mtlr       r0
80469b98: 38210020  addi       r1, r1, 0x20
80469b9c: 4e800020  blr        
80469ba0: 9421fff0  stwu       r1, -0x10(r1)
80469ba4: 7c0802a6  mflr       r0
80469ba8: 3880039a  li         r4, 0x39a
80469bac: 90010014  stw        r0, 0x14(r1)
80469bb0: 93e1000c  stw        r31, 0xc(r1)
80469bb4: 7c7f1b78  mr         r31, r3
80469bb8: 80630004  lwz        r3, 4(r3)
80469bbc: 4be4d721  bl         0x802b72dc
80469bc0: 38000002  li         r0, 2
80469bc4: 901f0194  stw        r0, 0x194(r31)
80469bc8: 3c60807d  lis        r3, -0x7f83
80469bcc: c0030318  lfs        f0, 0x318(r3)
80469bd0: 38630318  addi       r3, r3, 0x318
80469bd4: d01f0014  stfs       f0, 0x14(r31)
80469bd8: c0030004  lfs        f0, 4(r3)
80469bdc: d01f0018  stfs       f0, 0x18(r31)
80469be0: c0030008  lfs        f0, 8(r3)
80469be4: d01f001c  stfs       f0, 0x1c(r31)
80469be8: c00dd6b0  lfs        f0, -0x2950(r13)
80469bec: d01f000c  stfs       f0, 0xc(r31)
80469bf0: 83e1000c  lwz        r31, 0xc(r1)
80469bf4: 80010014  lwz        r0, 0x14(r1)
80469bf8: 7c0803a6  mtlr       r0
80469bfc: 38210010  addi       r1, r1, 0x10
80469c00: 4e800020  blr        
80469c04: 9421ffd0  stwu       r1, -0x30(r1)
80469c08: 7c0802a6  mflr       r0
80469c0c: c0650000  lfs        f3, 0(r5)
80469c10: 38c00001  li         r6, 1
80469c14: 90010034  stw        r0, 0x34(r1)
80469c18: 38000000  li         r0, 0
80469c1c: c0450004  lfs        f2, 4(r5)
80469c20: dbe10020  stfd       f31, 0x20(r1)
80469c24: c0050008  lfs        f0, 8(r5)
80469c28: f3e10028  psq_st     f31, 40(r1), W=0, I=0
80469c2c: ffe00890  fmr        f31, f1
80469c30: 93e1001c  stw        r31, 0x1c(r1)
80469c34: 7c7f1b78  mr         r31, r3
80469c38: 90c30194  stw        r6, 0x194(r3)
80469c3c: 90030198  stw        r0, 0x198(r3)
80469c40: 9083019c  stw        r4, 0x19c(r3)
80469c44: d0630008  stfs       f3, 8(r3)
80469c48: d043000c  stfs       f2, 0xc(r3)
80469c4c: d0030010  stfs       f0, 0x10(r3)
80469c50: d06301a0  stfs       f3, 0x1a0(r3)
80469c54: d04301a4  stfs       f2, 0x1a4(r3)
80469c58: d00301a8  stfs       f0, 0x1a8(r3)
80469c5c: 806dd678  lwz        r3, -0x2988(r13)
80469c60: 8063017c  lwz        r3, 0x17c(r3)
80469c64: 81830000  lwz        r12, 0(r3)
80469c68: 818c0050  lwz        r12, 0x50(r12)
80469c6c: 7d8903a6  mtctr      r12
80469c70: 4e800421  bctrl      
80469c74: c042103c  lfs        f2, 0x103c(r2) ; [806ff0bc] 3e4ccccc f32=0.199999988
80469c78: 3ca0807d  lis        r5, -0x7f83
80469c7c: c0021038  lfs        f0, 0x1038(r2) ; [806ff0b8] 3e19999a f32=0.150000006
80469c80: 7fe3fb78  mr         r3, r31
80469c84: d03f021c  stfs       f1, 0x21c(r31)
80469c88: 38810008  addi       r4, r1, 8
80469c8c: c0221034  lfs        f1, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
80469c90: ec0207fa  fmadds     f0, f2, f31, f0
80469c94: d0210010  stfs       f1, 0x10(r1)
80469c98: 38a50318  addi       r5, r5, 0x318
80469c9c: 38c00000  li         r6, 0
80469ca0: d0210008  stfs       f1, 8(r1)
80469ca4: d001000c  stfs       f0, 0xc(r1)
80469ca8: 48000305  bl         0x80469fac
80469cac: 807f00f8  lwz        r3, 0xf8(r31)
80469cb0: 38800000  li         r4, 0
80469cb4: 48005c99  bl         0x8046f94c
80469cb8: 80010034  lwz        r0, 0x34(r1)
80469cbc: e3e10028  psq_l      f31, 40(r1), W=0, I=0
80469cc0: cbe10020  lfd        f31, 0x20(r1)
80469cc4: 83e1001c  lwz        r31, 0x1c(r1)
80469cc8: 7c0803a6  mtlr       r0
80469ccc: 38210030  addi       r1, r1, 0x30
80469cd0: 4e800020  blr        
80469cd4: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
80469cd8: 4e800020  blr        
80469cdc: 9421ffe0  stwu       r1, -0x20(r1)
80469ce0: 7c0802a6  mflr       r0
80469ce4: 90010024  stw        r0, 0x24(r1)
80469ce8: 38000003  li         r0, 3
80469cec: bfa10014  stmw       r29, 0x14(r1)
80469cf0: 7c7d1b78  mr         r29, r3
80469cf4: 7cbe2b78  mr         r30, r5
80469cf8: 7cdf3378  mr         r31, r6
80469cfc: 90030194  stw        r0, 0x194(r3)
80469d00: 90830198  stw        r4, 0x198(r3)
80469d04: d0230224  stfs       f1, 0x224(r3)
80469d08: 806dd678  lwz        r3, -0x2988(r13)
80469d0c: 8063017c  lwz        r3, 0x17c(r3)
80469d10: 81830000  lwz        r12, 0(r3)
80469d14: 818c0054  lwz        r12, 0x54(r12)
80469d18: 7d8903a6  mtctr      r12
80469d1c: 4e800421  bctrl      
80469d20: d03d021c  stfs       f1, 0x21c(r29)
80469d24: 7fa3eb78  mr         r3, r29
80469d28: 7fc4f378  mr         r4, r30
80469d2c: 7fe5fb78  mr         r5, r31
80469d30: 38c0ffff  li         r6, -1
80469d34: 48000279  bl         0x80469fac
80469d38: 807d00f8  lwz        r3, 0xf8(r29)
80469d3c: 38800000  li         r4, 0
80469d40: 48005c0d  bl         0x8046f94c
80469d44: 806dd678  lwz        r3, -0x2988(r13)
80469d48: 7fa4eb78  mr         r4, r29
80469d4c: 38a00004  li         r5, 4
80469d50: 8063017c  lwz        r3, 0x17c(r3)
80469d54: 48017e29  bl         0x80481b7c
80469d58: bba10014  lmw        r29, 0x14(r1)
80469d5c: 80010024  lwz        r0, 0x24(r1)
80469d60: 7c0803a6  mtlr       r0
80469d64: 38210020  addi       r1, r1, 0x20
80469d68: 4e800020  blr        
80469d6c: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
80469d70: 4e800020  blr        
80469d74: 9421ffe0  stwu       r1, -0x20(r1)
80469d78: 7c0802a6  mflr       r0
80469d7c: 90010024  stw        r0, 0x24(r1)
80469d80: 39610020  addi       r11, r1, 0x20
80469d84: 4bb9dadd  bl         0x80007860
80469d88: 2c070000  cmpwi      r7, 0
80469d8c: 38000004  li         r0, 4
80469d90: 90030194  stw        r0, 0x194(r3)
80469d94: 7c7d1b78  mr         r29, r3
80469d98: 7cbe2b78  mr         r30, r5
80469d9c: 7cdf3378  mr         r31, r6
80469da0: 90830198  stw        r4, 0x198(r3)
80469da4: d0230224  stfs       f1, 0x224(r3)
80469da8: 41820014  beq        0x80469dbc
80469dac: 80030250  lwz        r0, 0x250(r3)
80469db0: 60000002  ori        r0, r0, 2
80469db4: 90030250  stw        r0, 0x250(r3)
80469db8: 48000010  b          0x80469dc8
80469dbc: 80030250  lwz        r0, 0x250(r3)
80469dc0: 540007fa  rlwinm     r0, r0, 0, 0x1f, 0x1d
80469dc4: 90030250  stw        r0, 0x250(r3)
80469dc8: 80830250  lwz        r4, 0x250(r3)
80469dcc: 548006b5  rlwinm.    r0, r4, 0, 0x1a, 0x1a
80469dd0: 5480003c  rlwinm     r0, r4, 0, 0, 0x1e
80469dd4: 90030250  stw        r0, 0x250(r3)
80469dd8: 41820014  beq        0x80469dec
80469ddc: 60000040  ori        r0, r0, 0x40
80469de0: 540006f2  rlwinm     r0, r0, 0, 0x1b, 0x19
80469de4: 90030250  stw        r0, 0x250(r3)
80469de8: 4800000c  b          0x80469df4
80469dec: 540006b0  rlwinm     r0, r0, 0, 0x1a, 0x18
80469df0: 90030250  stw        r0, 0x250(r3)
80469df4: 801d0178  lwz        r0, 0x178(r29)
80469df8: 7fa4eb78  mr         r4, r29
80469dfc: 806dd678  lwz        r3, -0x2988(r13)
80469e00: 38a00005  li         r5, 5
80469e04: 2c000000  cmpwi      r0, 0
80469e08: 8063017c  lwz        r3, 0x17c(r3)
80469e0c: 41810008  bgt        0x80469e14
80469e10: 38a00006  li         r5, 6
80469e14: 48017d69  bl         0x80481b7c
80469e18: 806dd678  lwz        r3, -0x2988(r13)
80469e1c: c03d021c  lfs        f1, 0x21c(r29)
80469e20: 8063017c  lwz        r3, 0x17c(r3)
80469e24: 81830000  lwz        r12, 0(r3)
80469e28: 818c0058  lwz        r12, 0x58(r12)
80469e2c: 7d8903a6  mtctr      r12
80469e30: 4e800421  bctrl      
80469e34: d03d021c  stfs       f1, 0x21c(r29)
80469e38: 7fa3eb78  mr         r3, r29
80469e3c: 7fc4f378  mr         r4, r30
80469e40: 7fe5fb78  mr         r5, r31
80469e44: 38c00000  li         r6, 0
80469e48: 48000165  bl         0x80469fac
80469e4c: 807d00f8  lwz        r3, 0xf8(r29)
80469e50: 38800000  li         r4, 0
80469e54: 48005af9  bl         0x8046f94c
80469e58: 39610020  addi       r11, r1, 0x20
80469e5c: 4bb9da51  bl         0x800078ac
80469e60: 80010024  lwz        r0, 0x24(r1)
80469e64: 7c0803a6  mtlr       r0
80469e68: 38210020  addi       r1, r1, 0x20
80469e6c: 4e800020  blr        
80469e70: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
80469e74: 4e800020  blr        
80469e78: 9421ffe0  stwu       r1, -0x20(r1)
80469e7c: 7c0802a6  mflr       r0
80469e80: 90010024  stw        r0, 0x24(r1)
80469e84: 39610020  addi       r11, r1, 0x20
80469e88: 4bb9d9d1  bl         0x80007858
80469e8c: 7c7b1b78  mr         r27, r3
80469e90: 80630108  lwz        r3, 0x108(r3)
80469e94: 7c9c2378  mr         r28, r4
80469e98: 7cbd2b78  mr         r29, r5
80469e9c: 7f64db78  mr         r4, r27
80469ea0: 480031d9  bl         0x8046d078
80469ea4: 83fb0178  lwz        r31, 0x178(r27)
80469ea8: 7f63db78  mr         r3, r27
80469eac: 83db0180  lwz        r30, 0x180(r27)
80469eb0: 809b00fc  lwz        r4, 0xfc(r27)
80469eb4: 480031c5  bl         0x8046d078
80469eb8: 2c1c0000  cmpwi      r28, 0
80469ebc: 4182001c  beq        0x80469ed8
80469ec0: c01c0000  lfs        f0, 0(r28)
80469ec4: d01b0014  stfs       f0, 0x14(r27)
80469ec8: c01c0004  lfs        f0, 4(r28)
80469ecc: d01b0018  stfs       f0, 0x18(r27)
80469ed0: c01c0008  lfs        f0, 8(r28)
80469ed4: d01b001c  stfs       f0, 0x1c(r27)
80469ed8: 2c1d0000  cmpwi      r29, 0
80469edc: 41820040  beq        0x80469f1c
80469ee0: c01d0000  lfs        f0, 0(r29)
80469ee4: d01b0044  stfs       f0, 0x44(r27)
80469ee8: c01d0004  lfs        f0, 4(r29)
80469eec: d01b0048  stfs       f0, 0x48(r27)
80469ef0: c01d0008  lfs        f0, 8(r29)
80469ef4: d01b004c  stfs       f0, 0x4c(r27)
80469ef8: 48000024  b          0x80469f1c
80469efc: 7f63db78  mr         r3, r27
80469f00: 48001935  bl         0x8046b834
80469f04: 801b0178  lwz        r0, 0x178(r27)
80469f08: 7c00f800  cmpw       r0, r31
80469f0c: 40810010  ble        0x80469f1c
80469f10: 7f63db78  mr         r3, r27
80469f14: 48002791  bl         0x8046c6a4
80469f18: 83fb0178  lwz        r31, 0x178(r27)
80469f1c: 801b0180  lwz        r0, 0x180(r27)
80469f20: 7c00f000  cmpw       r0, r30
80469f24: 4180ffd8  blt        0x80469efc
80469f28: 801b0178  lwz        r0, 0x178(r27)
80469f2c: 7c00f800  cmpw       r0, r31
80469f30: 40800014  bge        0x80469f44
80469f34: 809b0108  lwz        r4, 0x108(r27)
80469f38: 7f63db78  mr         r3, r27
80469f3c: 4800313d  bl         0x8046d078
80469f40: 48000054  b          0x80469f94
80469f44: 2c1c0000  cmpwi      r28, 0
80469f48: 41820020  beq        0x80469f68
80469f4c: 807b00fc  lwz        r3, 0xfc(r27)
80469f50: c01c0000  lfs        f0, 0(r28)
80469f54: d0030014  stfs       f0, 0x14(r3)
80469f58: c01c0004  lfs        f0, 4(r28)
80469f5c: d0030018  stfs       f0, 0x18(r3)
80469f60: c01c0008  lfs        f0, 8(r28)
80469f64: d003001c  stfs       f0, 0x1c(r3)
80469f68: 2c1d0000  cmpwi      r29, 0
80469f6c: 41820020  beq        0x80469f8c
80469f70: 807b00fc  lwz        r3, 0xfc(r27)
80469f74: c01d0000  lfs        f0, 0(r29)
80469f78: d0030044  stfs       f0, 0x44(r3)
80469f7c: c01d0004  lfs        f0, 4(r29)
80469f80: d0030048  stfs       f0, 0x48(r3)
80469f84: c01d0008  lfs        f0, 8(r29)
80469f88: d003004c  stfs       f0, 0x4c(r3)
80469f8c: 38000001  li         r0, 1
80469f90: 901b01b8  stw        r0, 0x1b8(r27)
80469f94: 39610020  addi       r11, r1, 0x20
80469f98: 4bb9d90d  bl         0x800078a4
80469f9c: 80010024  lwz        r0, 0x24(r1)
80469fa0: 7c0803a6  mtlr       r0
80469fa4: 38210020  addi       r1, r1, 0x20
80469fa8: 4e800020  blr        
80469fac: 9421fff0  stwu       r1, -0x10(r1)
80469fb0: 7c0802a6  mflr       r0
80469fb4: c0a40000  lfs        f5, 0(r4)
80469fb8: 90010014  stw        r0, 0x14(r1)
80469fbc: 3800270f  li         r0, 0x270f
80469fc0: c0840004  lfs        f4, 4(r4)
80469fc4: 93e1000c  stw        r31, 0xc(r1)
80469fc8: 3be00000  li         r31, 0
80469fcc: c0640008  lfs        f3, 8(r4)
80469fd0: 93c10008  stw        r30, 8(r1)
80469fd4: 7c7e1b78  mr         r30, r3
80469fd8: c0450000  lfs        f2, 0(r5)
80469fdc: 7fc4f378  mr         r4, r30
80469fe0: c0250004  lfs        f1, 4(r5)
80469fe4: c0050008  lfs        f0, 8(r5)
80469fe8: 9003017c  stw        r0, 0x17c(r3)
80469fec: 93e30180  stw        r31, 0x180(r3)
80469ff0: 93e30184  stw        r31, 0x184(r3)
80469ff4: 90c30178  stw        r6, 0x178(r3)
80469ff8: 93e3018c  stw        r31, 0x18c(r3)
80469ffc: d0a30014  stfs       f5, 0x14(r3)
8046a000: d0830018  stfs       f4, 0x18(r3)
8046a004: d063001c  stfs       f3, 0x1c(r3)
8046a008: d0430044  stfs       f2, 0x44(r3)
8046a00c: d0230048  stfs       f1, 0x48(r3)
8046a010: d003004c  stfs       f0, 0x4c(r3)
8046a014: 806300fc  lwz        r3, 0xfc(r3)
8046a018: 48003061  bl         0x8046d078
8046a01c: c03e0224  lfs        f1, 0x224(r30)
8046a020: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a024: fc010040  fcmpo      cr0, f1, f0
8046a028: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046a02c: 4082000c  bne        0x8046a038
8046a030: 3be00001  li         r31, 1
8046a034: 48000014  b          0x8046a048
8046a038: 801e0250  lwz        r0, 0x250(r30)
8046a03c: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8046a040: 41820008  beq        0x8046a048
8046a044: 3be00002  li         r31, 2
8046a048: 807e0150  lwz        r3, 0x150(r30)
8046a04c: 7fe4fb78  mr         r4, r31
8046a050: 480034f1  bl         0x8046d540
8046a054: 80010014  lwz        r0, 0x14(r1)
8046a058: 83e1000c  lwz        r31, 0xc(r1)
8046a05c: 83c10008  lwz        r30, 8(r1)
8046a060: 7c0803a6  mtlr       r0
8046a064: 38210010  addi       r1, r1, 0x10
8046a068: 4e800020  blr        
8046a06c: 80030250  lwz        r0, 0x250(r3)
8046a070: 60000010  ori        r0, r0, 0x10
8046a074: 90030250  stw        r0, 0x250(r3)
8046a078: 4e800020  blr        
8046a07c: 9421fe40  stwu       r1, -0x1c0(r1)
8046a080: 7c0802a6  mflr       r0
8046a084: 900101c4  stw        r0, 0x1c4(r1)
8046a088: 396101b0  addi       r11, r1, 0x1b0
8046a08c: dbe101b0  stfd       f31, 0x1b0(r1)
8046a090: f3e101b8  psq_st     f31, 440(r1), W=0, I=0
8046a094: 4bb9d7c9  bl         0x8000785c
8046a098: e0050000  psq_l      f0, 0(r5), W=0, I=0
8046a09c: 38e1002c  addi       r7, r1, 0x2c
8046a0a0: e0630008  psq_l      f3, 8(r3), W=0, I=0
8046a0a4: 7c7f1b78  mr         r31, r3
8046a0a8: 10400058  ps_muls0   f2, f0, f1
8046a0ac: e0058008  psq_l      f0, 8(r5), W=1, I=0
8046a0b0: c0a50008  lfs        f5, 8(r5)
8046a0b4: 7c9c2378  mr         r28, r4
8046a0b8: f0470000  psq_st     f2, 0(r7), W=0, I=0
8046a0bc: 10400058  ps_muls0   f2, f0, f1
8046a0c0: e0070000  psq_l      f0, 0(r7), W=0, I=0
8046a0c4: 7cdd3378  mr         r29, r6
8046a0c8: c0850000  lfs        f4, 0(r5)
8046a0cc: 1023002a  ps_add     f1, f3, f0
8046a0d0: e0638010  psq_l      f3, 16(r3), W=1, I=0
8046a0d4: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a0d8: f0230008  psq_st     f1, 8(r3), W=0, I=0
8046a0dc: 1023102a  ps_add     f1, f3, f2
8046a0e0: f0238010  psq_st     f1, 16(r3), W=1, I=0
8046a0e4: 38610044  addi       r3, r1, 0x44
8046a0e8: 7c641b78  mr         r4, r3
8046a0ec: f0478008  psq_st     f2, 8(r7), W=1, I=0
8046a0f0: d0810044  stfs       f4, 0x44(r1)
8046a0f4: d0010048  stfs       f0, 0x48(r1)
8046a0f8: d0a1004c  stfs       f5, 0x4c(r1)
8046a0fc: 4bebdf31  bl         0x8032802c
8046a100: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a104: fc010000  fcmpu      cr0, f1, f0
8046a108: 40820024  bne        0x8046a12c
8046a10c: 3c80807d  lis        r4, -0x7f83
8046a110: 38640318  addi       r3, r4, 0x318
8046a114: c0440318  lfs        f2, 0x318(r4)
8046a118: c0230004  lfs        f1, 4(r3)
8046a11c: c0030008  lfs        f0, 8(r3)
8046a120: d0410044  stfs       f2, 0x44(r1)
8046a124: d0210048  stfs       f1, 0x48(r1)
8046a128: d001004c  stfs       f0, 0x4c(r1)
8046a12c: c0210048  lfs        f1, 0x48(r1)
8046a130: c0021044  lfs        f0, 0x1044(r2) ; [806ff0c4] 3f000000 f32=0.5
8046a134: fc010040  fcmpo      cr0, f1, f0
8046a138: 40800034  bge        0x8046a16c
8046a13c: d0010048  stfs       f0, 0x48(r1)
8046a140: 38610044  addi       r3, r1, 0x44
8046a144: 4bbd566d  bl         0x8003f7b0
8046a148: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a14c: 38610044  addi       r3, r1, 0x44
8046a150: e0430000  psq_l      f2, 0(r3), W=0, I=0
8046a154: ec200824  fdivs      f1, f0, f1
8046a158: 10020058  ps_muls0   f0, f2, f1
8046a15c: e0438008  psq_l      f2, 8(r3), W=1, I=0
8046a160: f0030000  psq_st     f0, 0(r3), W=0, I=0
8046a164: 10020058  ps_muls0   f0, f2, f1
8046a168: f0038008  psq_st     f0, 8(r3), W=1, I=0
8046a16c: 38610044  addi       r3, r1, 0x44
8046a170: e05f0018  psq_l      f2, 24(r31), W=0, I=0
8046a174: e0630004  psq_l      f3, 4(r3), W=0, I=0
8046a178: e0238000  psq_l      f1, 0(r3), W=1, I=0
8046a17c: 106300b2  ps_mul     f3, f3, f2
8046a180: e05f8014  psq_l      f2, 20(r31), W=1, I=0
8046a184: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a188: 104118ba  ps_madd    f2, f1, f2, f3
8046a18c: 102218d4  ps_sum0    f1, f2, f3, f3
8046a190: ffe00850  fneg       f31, f1
8046a194: fc1f0040  fcmpo      cr0, f31, f0
8046a198: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046a19c: 4182017c  beq        0x8046a318
8046a1a0: e0230000  psq_l      f1, 0(r3), W=0, I=0
8046a1a4: 38810020  addi       r4, r1, 0x20
8046a1a8: e05f0014  psq_l      f2, 20(r31), W=0, I=0
8046a1ac: 3bc10038  addi       r30, r1, 0x38
8046a1b0: 100107d8  ps_muls0   f0, f1, f31
8046a1b4: e0238008  psq_l      f1, 8(r3), W=1, I=0
8046a1b8: 7fc3f378  mr         r3, r30
8046a1bc: f0040000  psq_st     f0, 0(r4), W=0, I=0
8046a1c0: 100107d8  ps_muls0   f0, f1, f31
8046a1c4: e0240000  psq_l      f1, 0(r4), W=0, I=0
8046a1c8: f0048008  psq_st     f0, 8(r4), W=1, I=0
8046a1cc: 1022082a  ps_add     f1, f2, f1
8046a1d0: f03e0000  psq_st     f1, 0(r30), W=0, I=0
8046a1d4: e05f801c  psq_l      f2, 28(r31), W=1, I=0
8046a1d8: 1022002a  ps_add     f1, f2, f0
8046a1dc: f03e8008  psq_st     f1, 8(r30), W=1, I=0
8046a1e0: 4bbd55d1  bl         0x8003f7b0
8046a1e4: c0021044  lfs        f0, 0x1044(r2) ; [806ff0c4] 3f000000 f32=0.5
8046a1e8: ec0007f2  fmuls      f0, f0, f31
8046a1ec: fc010040  fcmpo      cr0, f1, f0
8046a1f0: 40810020  ble        0x8046a210
8046a1f4: ec400824  fdivs      f2, f0, f1
8046a1f8: e03e0000  psq_l      f1, 0(r30), W=0, I=0
8046a1fc: 10010098  ps_muls0   f0, f1, f2
8046a200: e03e8008  psq_l      f1, 8(r30), W=1, I=0
8046a204: f01e0000  psq_st     f0, 0(r30), W=0, I=0
8046a208: 10010098  ps_muls0   f0, f1, f2
8046a20c: f01e8008  psq_st     f0, 8(r30), W=1, I=0
8046a210: c0021048  lfs        f0, 0x1048(r2) ; [806ff0c8] 3fd9999a f32=1.70000005
8046a214: 38810044  addi       r4, r1, 0x44
8046a218: 38c10038  addi       r6, r1, 0x38
8046a21c: 801f0250  lwz        r0, 0x250(r31)
8046a220: ec8007f2  fmuls      f4, f0, f31
8046a224: e0240000  psq_l      f1, 0(r4), W=0, I=0
8046a228: 38610008  addi       r3, r1, 8
8046a22c: e0460000  psq_l      f2, 0(r6), W=0, I=0
8046a230: 38a10014  addi       r5, r1, 0x14
8046a234: e07f0014  psq_l      f3, 20(r31), W=0, I=0
8046a238: 10010118  ps_muls0   f0, f1, f4
8046a23c: e0248008  psq_l      f1, 8(r4), W=1, I=0
8046a240: 2c1d0000  cmpwi      r29, 0
8046a244: 60000001  ori        r0, r0, 1
8046a248: f0030000  psq_st     f0, 0(r3), W=0, I=0
8046a24c: 10010118  ps_muls0   f0, f1, f4
8046a250: e0230000  psq_l      f1, 0(r3), W=0, I=0
8046a254: f0038008  psq_st     f0, 8(r3), W=1, I=0
8046a258: 10211028  ps_sub     f1, f1, f2
8046a25c: e0468008  psq_l      f2, 8(r6), W=1, I=0
8046a260: f0250000  psq_st     f1, 0(r5), W=0, I=0
8046a264: 10201028  ps_sub     f1, f0, f2
8046a268: e0050000  psq_l      f0, 0(r5), W=0, I=0
8046a26c: f0258008  psq_st     f1, 8(r5), W=1, I=0
8046a270: 1003002a  ps_add     f0, f3, f0
8046a274: e07f801c  psq_l      f3, 28(r31), W=1, I=0
8046a278: 901f0250  stw        r0, 0x250(r31)
8046a27c: f01f0014  psq_st     f0, 20(r31), W=0, I=0
8046a280: 1003082a  ps_add     f0, f3, f1
8046a284: f01f801c  psq_st     f0, 28(r31), W=1, I=0
8046a288: 41820090  beq        0x8046a318
8046a28c: 3ca0807d  lis        r5, -0x7f83
8046a290: 7f84e378  mr         r4, r28
8046a294: 38610050  addi       r3, r1, 0x50
8046a298: 38a50354  addi       r5, r5, 0x354
8046a29c: 4bebdcc5  bl         0x80327f60
8046a2a0: 3c808068  lis        r4, -0x7f98
8046a2a4: 38610080  addi       r3, r1, 0x80
8046a2a8: 3884f688  addi       r4, r4, -0x978
8046a2ac: 38a00000  li         r5, 0
8046a2b0: 388400d2  addi       r4, r4, 0xd2
8046a2b4: 4bdd47e5  bl         0x8023ea98
8046a2b8: 38610080  addi       r3, r1, 0x80
8046a2bc: 4bdd4661  bl         0x8023e91c
8046a2c0: 38610080  addi       r3, r1, 0x80
8046a2c4: 38810050  addi       r4, r1, 0x50
8046a2c8: 4bdd41b5  bl         0x8023e47c
8046a2cc: 38610080  addi       r3, r1, 0x80
8046a2d0: 4bdd3fbd  bl         0x8023e28c
8046a2d4: 807f0004  lwz        r3, 4(r31)
8046a2d8: 388003a3  li         r4, 0x3a3
8046a2dc: 4be4d001  bl         0x802b72dc
8046a2e0: 806dd678  lwz        r3, -0x2988(r13)
8046a2e4: 38a10050  addi       r5, r1, 0x50
8046a2e8: 3880000a  li         r4, 0xa
8046a2ec: 38c00000  li         r6, 0
8046a2f0: 80630188  lwz        r3, 0x188(r3)
8046a2f4: 4befd2b5  bl         0x803675a8
8046a2f8: 806dd678  lwz        r3, -0x2988(r13)
8046a2fc: 7fe4fb78  mr         r4, r31
8046a300: 38a00007  li         r5, 7
8046a304: 8063017c  lwz        r3, 0x17c(r3)
8046a308: 48017875  bl         0x80481b7c
8046a30c: 38610080  addi       r3, r1, 0x80
8046a310: 3880ffff  li         r4, -1
8046a314: 4bdd46b5  bl         0x8023e9c8
8046a318: 396101b0  addi       r11, r1, 0x1b0
8046a31c: e3e101b8  psq_l      f31, 440(r1), W=0, I=0
8046a320: cbe101b0  lfd        f31, 0x1b0(r1)
8046a324: 4bb9d585  bl         0x800078a8
8046a328: 800101c4  lwz        r0, 0x1c4(r1)
8046a32c: 7c0803a6  mtlr       r0
8046a330: 382101c0  addi       r1, r1, 0x1c0
8046a334: 4e800020  blr        
8046a338: 9421ffe0  stwu       r1, -0x20(r1)
8046a33c: 2c040000  cmpwi      r4, 0
8046a340: 90830258  stw        r4, 0x258(r3)
8046a344: 41820010  beq        0x8046a354
8046a348: 2c040001  cmpwi      r4, 1
8046a34c: 41820054  beq        0x8046a3a0
8046a350: 48000098  b          0x8046a3e8
8046a354: 388d9fac  addi       r4, r13, -0x6054
8046a358: 38cd9fb0  addi       r6, r13, -0x6050
8046a35c: 896d9fac  lbz        r11, -0x6054(r13) ; [806f20cc] ffffffff f32=nan
8046a360: 89440001  lbz        r10, 1(r4)
8046a364: 89240002  lbz        r9, 2(r4)
8046a368: 89040003  lbz        r8, 3(r4)
8046a36c: 88ed9fb0  lbz        r7, -0x6050(r13) ; [806f20d0] 0052e6ff f32=7.61337647e-39
8046a370: 88a60001  lbz        r5, 1(r6)
8046a374: 88860002  lbz        r4, 2(r6)
8046a378: 88060003  lbz        r0, 3(r6)
8046a37c: 99610014  stb        r11, 0x14(r1)
8046a380: 99410015  stb        r10, 0x15(r1)
8046a384: 99210016  stb        r9, 0x16(r1)
8046a388: 99010017  stb        r8, 0x17(r1)
8046a38c: 98e10010  stb        r7, 0x10(r1)
8046a390: 98a10011  stb        r5, 0x11(r1)
8046a394: 98810012  stb        r4, 0x12(r1)
8046a398: 98010013  stb        r0, 0x13(r1)
8046a39c: 4800004c  b          0x8046a3e8
8046a3a0: 388d9fb4  addi       r4, r13, -0x604c
8046a3a4: 38cd9fb8  addi       r6, r13, -0x6048
8046a3a8: 896d9fb4  lbz        r11, -0x604c(r13) ; [806f20d4] ffa040ff f32=nan
8046a3ac: 89440001  lbz        r10, 1(r4)
8046a3b0: 89240002  lbz        r9, 2(r4)
8046a3b4: 89040003  lbz        r8, 3(r4)
8046a3b8: 88ed9fb8  lbz        r7, -0x6048(r13) ; [806f20d8] 0052e6ff f32=7.61337647e-39
8046a3bc: 88a60001  lbz        r5, 1(r6)
8046a3c0: 88860002  lbz        r4, 2(r6)
8046a3c4: 88060003  lbz        r0, 3(r6)
8046a3c8: 99610014  stb        r11, 0x14(r1)
8046a3cc: 99410015  stb        r10, 0x15(r1)
8046a3d0: 99210016  stb        r9, 0x16(r1)
8046a3d4: 99010017  stb        r8, 0x17(r1)
8046a3d8: 98e10010  stb        r7, 0x10(r1)
8046a3dc: 98a10011  stb        r5, 0x11(r1)
8046a3e0: 98810012  stb        r4, 0x12(r1)
8046a3e4: 98010013  stb        r0, 0x13(r1)
8046a3e8: 80010010  lwz        r0, 0x10(r1)
8046a3ec: 90010008  stw        r0, 8(r1)
8046a3f0: 80010014  lwz        r0, 0x14(r1)
8046a3f4: 9001000c  stw        r0, 0xc(r1)
8046a3f8: 88c10008  lbz        r6, 8(r1)
8046a3fc: 8941000c  lbz        r10, 0xc(r1)
8046a400: 8921000d  lbz        r9, 0xd(r1)
8046a404: 8901000e  lbz        r8, 0xe(r1)
8046a408: 88e1000f  lbz        r7, 0xf(r1)
8046a40c: 88a10009  lbz        r5, 9(r1)
8046a410: 8881000a  lbz        r4, 0xa(r1)
8046a414: 8801000b  lbz        r0, 0xb(r1)
8046a418: 99430144  stb        r10, 0x144(r3)
8046a41c: 99230145  stb        r9, 0x145(r3)
8046a420: 99030146  stb        r8, 0x146(r3)
8046a424: 98e30147  stb        r7, 0x147(r3)
8046a428: 98c30148  stb        r6, 0x148(r3)
8046a42c: 98a30149  stb        r5, 0x149(r3)
8046a430: 9883014a  stb        r4, 0x14a(r3)
8046a434: 9803014b  stb        r0, 0x14b(r3)
8046a438: 38210020  addi       r1, r1, 0x20
8046a43c: 4e800020  blr        
8046a440: c02d9fd8  lfs        f1, -0x6028(r13) ; [806f20f8] 3ee147ae f32=0.439999998
8046a444: 4e800020  blr        
8046a448: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046a44c: 4e800020  blr        
8046a450: 806300f8  lwz        r3, 0xf8(r3)
8046a454: 48005300  b          0x8046f754
8046a458: 2c040000  cmpwi      r4, 0
8046a45c: 4082000c  bne        0x8046a468
8046a460: 38600000  li         r3, 0
8046a464: 4e800020  blr        
8046a468: 80030180  lwz        r0, 0x180(r3)
8046a46c: 806300f8  lwz        r3, 0xf8(r3)
8046a470: 7c802214  add        r4, r0, r4
8046a474: 4800542c  b          0x8046f8a0
8046a478: 4e800020  blr        
8046a47c: 2c040000  cmpwi      r4, 0
8046a480: 4082000c  bne        0x8046a48c
8046a484: 38630008  addi       r3, r3, 8
8046a488: 4e800020  blr        
8046a48c: 80c300f8  lwz        r6, 0xf8(r3)
8046a490: 3ca60001  addis      r5, r6, 1
8046a494: 38060008  addi       r0, r6, 8
8046a498: 80a55188  lwz        r5, 0x5188(r5)
8046a49c: 7c050040  cmplw      r5, r0
8046a4a0: 4082000c  bne        0x8046a4ac
8046a4a4: 38630008  addi       r3, r3, 8
8046a4a8: 4e800020  blr        
8046a4ac: 80030180  lwz        r0, 0x180(r3)
8046a4b0: 7cc33378  mr         r3, r6
8046a4b4: 7c802214  add        r4, r0, r4
8046a4b8: 4800543c  b          0x8046f8f4
8046a4bc: 4e800020  blr        
8046a4c0: 9421ffd0  stwu       r1, -0x30(r1)
8046a4c4: 7c0802a6  mflr       r0
8046a4c8: 3c80807d  lis        r4, -0x7f83
8046a4cc: 90010034  stw        r0, 0x34(r1)
8046a4d0: 3884eef0  addi       r4, r4, -0x1110
8046a4d4: dbe10020  stfd       f31, 0x20(r1)
8046a4d8: f3e10028  psq_st     f31, 40(r1), W=0, I=0
8046a4dc: 93e1001c  stw        r31, 0x1c(r1)
8046a4e0: 7c7f1b78  mr         r31, r3
8046a4e4: 80a40038  lwz        r5, 0x38(r4)
8046a4e8: c0030208  lfs        f0, 0x208(r3)
8046a4ec: c025004c  lfs        f1, 0x4c(r5)
8046a4f0: 8084003c  lwz        r4, 0x3c(r4)
8046a4f4: eca10028  fsubs      f5, f1, f0
8046a4f8: c0430204  lfs        f2, 0x204(r3)
8046a4fc: c065003c  lfs        f3, 0x3c(r5)
8046a500: c0250048  lfs        f1, 0x48(r5)
8046a504: ecc31028  fsubs      f6, f3, f2
8046a508: c0840010  lfs        f4, 0x10(r4)
8046a50c: c0021044  lfs        f0, 0x1044(r2) ; [806ff0c4] 3f000000 f32=0.5
8046a510: ec650072  fmuls      f3, f5, f1
8046a514: c0450038  lfs        f2, 0x38(r5)
8046a518: ec200132  fmuls      f1, f0, f4
8046a51c: c0021050  lfs        f0, 0x1050(r2) ; [806ff0d0] 3f360b61 f32=0.711111128
8046a520: ec6618ba  fmadds     f3, f6, f2, f3
8046a524: c085005c  lfs        f4, 0x5c(r5)
8046a528: c043020c  lfs        f2, 0x20c(r3)
8046a52c: ec200072  fmuls      f1, f0, f1
8046a530: c002104c  lfs        f0, 0x104c(r2) ; [806ff0cc] 3cc90fdb f32=0.0245436933
8046a534: ec841028  fsubs      f4, f4, f2
8046a538: c0450058  lfs        f2, 0x58(r5)
8046a53c: ec200072  fmuls      f1, f0, f1
8046a540: d0c10008  stfs       f6, 8(r1)
8046a544: efe418ba  fmadds     f31, f4, f2, f3
8046a548: d0a1000c  stfs       f5, 0xc(r1)
8046a54c: d0810010  stfs       f4, 0x10(r1)
8046a550: 4bbac831  bl         0x80016d80
8046a554: fc200818  frsp       f1, f1
8046a558: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a55c: ec5f0072  fmuls      f2, f31, f1
8046a560: fc020040  fcmpo      cr0, f2, f0
8046a564: 40810024  ble        0x8046a588
8046a568: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046a56c: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a570: ec211024  fdivs      f1, f1, f2
8046a574: d03f0140  stfs       f1, 0x140(r31)
8046a578: fc010040  fcmpo      cr0, f1, f0
8046a57c: 40810010  ble        0x8046a58c
8046a580: d01f0140  stfs       f0, 0x140(r31)
8046a584: 48000008  b          0x8046a58c
8046a588: d01f0140  stfs       f0, 0x140(r31)
8046a58c: 80010034  lwz        r0, 0x34(r1)
8046a590: e3e10028  psq_l      f31, 40(r1), W=0, I=0
8046a594: cbe10020  lfd        f31, 0x20(r1)
8046a598: 83e1001c  lwz        r31, 0x1c(r1)
8046a59c: 7c0803a6  mtlr       r0
8046a5a0: 38210030  addi       r1, r1, 0x30
8046a5a4: 4e800020  blr        
8046a5a8: 9421ffc0  stwu       r1, -0x40(r1)
8046a5ac: 7c0802a6  mflr       r0
8046a5b0: 90010044  stw        r0, 0x44(r1)
8046a5b4: dbe10030  stfd       f31, 0x30(r1)
8046a5b8: f3e10038  psq_st     f31, 56(r1), W=0, I=0
8046a5bc: 93e1002c  stw        r31, 0x2c(r1)
8046a5c0: 7c7f1b78  mr         r31, r3
8046a5c4: 4bfefe75  bl         0x8045a438
8046a5c8: c01f0208  lfs        f0, 0x208(r31)
8046a5cc: c06d9fbc  lfs        f3, -0x6044(r13) ; [806f20dc] 41a00000 f32=20
8046a5d0: ec800828  fsubs      f4, f0, f1
8046a5d4: c00dd6a8  lfs        f0, -0x2958(r13)
8046a5d8: c05f025c  lfs        f2, 0x25c(r31)
8046a5dc: ec201828  fsubs      f1, f0, f3
8046a5e0: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a5e4: ec641828  fsubs      f3, f4, f3
8046a5e8: ec4200f2  fmuls      f2, f2, f3
8046a5ec: efe20824  fdivs      f31, f2, f1
8046a5f0: fc1f0040  fcmpo      cr0, f31, f0
8046a5f4: 418000a4  blt        0x8046a698
8046a5f8: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a5fc: fc1f0040  fcmpo      cr0, f31, f0
8046a600: 40810008  ble        0x8046a608
8046a604: ffe00090  fmr        f31, f0
8046a608: 801f0268  lwz        r0, 0x268(r31)
8046a60c: 2c000000  cmpwi      r0, 0
8046a610: 41820014  beq        0x8046a624
8046a614: 7fe3fb78  mr         r3, r31
8046a618: 4800009d  bl         0x8046a6b4
8046a61c: 38000000  li         r0, 0
8046a620: 901f0268  stw        r0, 0x268(r31)
8046a624: 806d9fa8  lwz        r3, -0x6058(r13) ; [806f20c8] 000020a0 f32=1.17036448e-41
8046a628: 3c004330  lis        r0, 0x4330
8046a62c: 9061000c  stw        r3, 0xc(r1)
8046a630: 38810008  addi       r4, r1, 8
8046a634: c8221058  lfd        f1, 0x1058(r2) ; [806ff0d8] 43300000 f32=176
8046a638: 38600000  li         r3, 0
8046a63c: 88a1000f  lbz        r5, 0xf(r1)
8046a640: 90a10014  stw        r5, 0x14(r1)
8046a644: 90010010  stw        r0, 0x10(r1)
8046a648: c8010010  lfd        f0, 0x10(r1)
8046a64c: ec000828  fsubs      f0, f0, f1
8046a650: ec0007f2  fmuls      f0, f0, f31
8046a654: fc00001e  fctiwz     f0, f0
8046a658: d8010018  stfd       f0, 0x18(r1)
8046a65c: 8001001c  lwz        r0, 0x1c(r1)
8046a660: 9801000f  stb        r0, 0xf(r1)
8046a664: 8001000c  lwz        r0, 0xc(r1)
8046a668: 90010008  stw        r0, 8(r1)
8046a66c: 4bbce1c5  bl         0x80038830
8046a670: 806dd678  lwz        r3, -0x2988(r13)
8046a674: 389f0204  addi       r4, r31, 0x204
8046a678: 80630164  lwz        r3, 0x164(r3)
8046a67c: 4bfeefa9  bl         0x80459624
8046a680: 807f014c  lwz        r3, 0x14c(r31)
8046a684: 4be41681  bl         0x802abd04
8046a688: 807f014c  lwz        r3, 0x14c(r31)
8046a68c: 4be413b9  bl         0x802aba44
8046a690: 807f014c  lwz        r3, 0x14c(r31)
8046a694: 4be4128d  bl         0x802ab920
8046a698: 80010044  lwz        r0, 0x44(r1)
8046a69c: e3e10038  psq_l      f31, 56(r1), W=0, I=0
8046a6a0: cbe10030  lfd        f31, 0x30(r1)
8046a6a4: 83e1002c  lwz        r31, 0x2c(r1)
8046a6a8: 7c0803a6  mtlr       r0
8046a6ac: 38210040  addi       r1, r1, 0x40
8046a6b0: 4e800020  blr        
8046a6b4: 9421ffc0  stwu       r1, -0x40(r1)
8046a6b8: 7c0802a6  mflr       r0
8046a6bc: c0021060  lfs        f0, 0x1060(r2) ; [806ff0e0] 3c23d70b f32=0.0100000007
8046a6c0: 90010044  stw        r0, 0x44(r1)
8046a6c4: 38810014  addi       r4, r1, 0x14
8046a6c8: dbe10030  stfd       f31, 0x30(r1)
8046a6cc: f3e10038  psq_st     f31, 56(r1), W=0, I=0
8046a6d0: 93e1002c  stw        r31, 0x2c(r1)
8046a6d4: 7c7f1b78  mr         r31, r3
8046a6d8: e0430204  psq_l      f2, 516(r3), W=0, I=0
8046a6dc: e0230210  psq_l      f1, 528(r3), W=0, I=0
8046a6e0: 10620828  ps_sub     f3, f2, f1
8046a6e4: c04d9fd4  lfs        f2, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046a6e8: c02da000  lfs        f1, -0x6000(r13) ; [806f2120] 3fb33333 f32=1.39999998
8046a6ec: f0640000  psq_st     f3, 0(r4), W=0, I=0
8046a6f0: efe20072  fmuls      f31, f2, f1
8046a6f4: 10801890  ps_mr      f4, f3
8046a6f8: e043820c  psq_l      f2, 524(r3), W=1, I=0
8046a6fc: e0238218  psq_l      f1, 536(r3), W=1, I=0
8046a700: 10620828  ps_sub     f3, f2, f1
8046a704: 10840132  ps_mul     f4, f4, f4
8046a708: f0648008  psq_st     f3, 8(r4), W=1, I=0
8046a70c: c021001c  lfs        f1, 0x1c(r1)
8046a710: 1021207a  ps_madd    f1, f1, f1, f4
8046a714: 10212114  ps_sum0    f1, f1, f4, f4
8046a718: fc010040  fcmpo      cr0, f1, f0
8046a71c: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046a720: 40820018  bne        0x8046a738
8046a724: fc20f890  fmr        f1, f31
8046a728: 8063014c  lwz        r3, 0x14c(r3)
8046a72c: fc40f890  fmr        f2, f31
8046a730: 4be415e5  bl         0x802abd14
8046a734: 48000070  b          0x8046a7a4
8046a738: c0230208  lfs        f1, 0x208(r3)
8046a73c: c003020c  lfs        f0, 0x20c(r3)
8046a740: c0430204  lfs        f2, 0x204(r3)
8046a744: d0030218  stfs       f0, 0x218(r3)
8046a748: 8083014c  lwz        r4, 0x14c(r3)
8046a74c: d0230214  stfs       f1, 0x214(r3)
8046a750: c0021064  lfs        f0, 0x1064(r2) ; [806ff0e4] 3dcccccd f32=0.100000001
8046a754: d0430210  stfs       f2, 0x210(r3)
8046a758: ec20f82a  fadds      f1, f0, f31
8046a75c: d0440064  stfs       f2, 0x64(r4)
8046a760: c0030214  lfs        f0, 0x214(r3)
8046a764: d0040068  stfs       f0, 0x68(r4)
8046a768: c0030218  lfs        f0, 0x218(r3)
8046a76c: d004006c  stfs       f0, 0x6c(r4)
8046a770: 8083014c  lwz        r4, 0x14c(r3)
8046a774: d0240070  stfs       f1, 0x70(r4)
8046a778: 8063014c  lwz        r3, 0x14c(r3)
8046a77c: 4be41ad9  bl         0x802ac254
8046a780: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a784: fc20f890  fmr        f1, f31
8046a788: d0010008  stfs       f0, 8(r1)
8046a78c: fc40f890  fmr        f2, f31
8046a790: 38810008  addi       r4, r1, 8
8046a794: d001000c  stfs       f0, 0xc(r1)
8046a798: d0010010  stfs       f0, 0x10(r1)
8046a79c: 807f014c  lwz        r3, 0x14c(r31)
8046a7a0: 4be41575  bl         0x802abd14
8046a7a4: 80010044  lwz        r0, 0x44(r1)
8046a7a8: e3e10038  psq_l      f31, 56(r1), W=0, I=0
8046a7ac: cbe10030  lfd        f31, 0x30(r1)
8046a7b0: 83e1002c  lwz        r31, 0x2c(r1)
8046a7b4: 7c0803a6  mtlr       r0
8046a7b8: 38210040  addi       r1, r1, 0x40
8046a7bc: 4e800020  blr        
8046a7c0: 9421ff90  stwu       r1, -0x70(r1)
8046a7c4: 7c0802a6  mflr       r0
8046a7c8: c0821034  lfs        f4, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a7cc: 90010074  stw        r0, 0x74(r1)
8046a7d0: 93e1006c  stw        r31, 0x6c(r1)
8046a7d4: 7c7f1b78  mr         r31, r3
8046a7d8: c0230208  lfs        f1, 0x208(r3)
8046a7dc: fc012040  fcmpo      cr0, f1, f4
8046a7e0: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046a7e4: 418201b0  beq        0x8046a994
8046a7e8: c06d9fbc  lfs        f3, -0x6044(r13) ; [806f20dc] 41a00000 f32=20
8046a7ec: c00dd6a8  lfs        f0, -0x2958(r13)
8046a7f0: ec411828  fsubs      f2, f1, f3
8046a7f4: c023025c  lfs        f1, 0x25c(r3)
8046a7f8: ec001828  fsubs      f0, f0, f3
8046a7fc: ec2100b2  fmuls      f1, f1, f2
8046a800: ec410024  fdivs      f2, f1, f0
8046a804: fc022040  fcmpo      cr0, f2, f4
8046a808: 4180018c  blt        0x8046a994
8046a80c: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a810: fc020040  fcmpo      cr0, f2, f0
8046a814: 40810008  ble        0x8046a81c
8046a818: fc400090  fmr        f2, f0
8046a81c: 80621030  lwz        r3, 0x1030(r2) ; [806ff0b0] 000000ff f32=3.57331108e-43
8046a820: 3c004330  lis        r0, 0x4330
8046a824: 9061000c  stw        r3, 0xc(r1)
8046a828: 38810008  addi       r4, r1, 8
8046a82c: c8221058  lfd        f1, 0x1058(r2) ; [806ff0d8] 43300000 f32=176
8046a830: 38600000  li         r3, 0
8046a834: 88a1000f  lbz        r5, 0xf(r1)
8046a838: 90a1005c  stw        r5, 0x5c(r1)
8046a83c: 90010058  stw        r0, 0x58(r1)
8046a840: c8010058  lfd        f0, 0x58(r1)
8046a844: ec000828  fsubs      f0, f0, f1
8046a848: ec0000b2  fmuls      f0, f0, f2
8046a84c: fc00001e  fctiwz     f0, f0
8046a850: d8010060  stfd       f0, 0x60(r1)
8046a854: 80010064  lwz        r0, 0x64(r1)
8046a858: 9801000f  stb        r0, 0xf(r1)
8046a85c: 8001000c  lwz        r0, 0xc(r1)
8046a860: 90010008  stw        r0, 8(r1)
8046a864: 4bbcdfcd  bl         0x80038830
8046a868: 7fe3fb78  mr         r3, r31
8046a86c: 4800013d  bl         0x8046a9a8
8046a870: 389f0154  addi       r4, r31, 0x154
8046a874: 3860000d  li         r3, 0xd
8046a878: 38a00008  li         r5, 8
8046a87c: 4bbca085  bl         0x80034900
8046a880: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046a884: 3ca0807d  lis        r5, -0x7f83
8046a888: c00da000  lfs        f0, -0x6000(r13) ; [806f2120] 3fb33333 f32=1.39999998
8046a88c: 38610028  addi       r3, r1, 0x28
8046a890: c07f020c  lfs        f3, 0x20c(r31)
8046a894: 3881001c  addi       r4, r1, 0x1c
8046a898: c05f0204  lfs        f2, 0x204(r31)
8046a89c: ec810032  fmuls      f4, f1, f0
8046a8a0: c0221068  lfs        f1, 0x1068(r2) ; [806ff0e8] 3ba3d70a f32=0.00499999989
8046a8a4: 38a50354  addi       r5, r5, 0x354
8046a8a8: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a8ac: 38c10010  addi       r6, r1, 0x10
8046a8b0: d041001c  stfs       f2, 0x1c(r1)
8046a8b4: d0210020  stfs       f1, 0x20(r1)
8046a8b8: d0610024  stfs       f3, 0x24(r1)
8046a8bc: d0810010  stfs       f4, 0x10(r1)
8046a8c0: d0010014  stfs       f0, 0x14(r1)
8046a8c4: d0810018  stfs       f4, 0x18(r1)
8046a8c8: 4bebd581  bl         0x80327e48
8046a8cc: 3c60807d  lis        r3, -0x7f83
8046a8d0: 38810028  addi       r4, r1, 0x28
8046a8d4: 3863eef0  addi       r3, r3, -0x1110
8046a8d8: 7c852378  mr         r5, r4
8046a8dc: 38630008  addi       r3, r3, 8
8046a8e0: 4bbd3ec1  bl         0x8003e7a0
8046a8e4: 38610028  addi       r3, r1, 0x28
8046a8e8: 38800000  li         r4, 0
8046a8ec: 4bbcf1f5  bl         0x80039ae0
8046a8f0: 38600080  li         r3, 0x80
8046a8f4: 38800000  li         r4, 0
8046a8f8: 38a00004  li         r5, 4
8046a8fc: 4bbcaed5  bl         0x800357d0
8046a900: 3cc0cc01  lis        r6, -0x33ff
8046a904: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a908: d0068000  stfs       f0, -0x8000(r6)
8046a90c: 38a00000  li         r5, 0
8046a910: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a914: 38800001  li         r4, 1
8046a918: d0068000  stfs       f0, -0x8000(r6)
8046a91c: 38600002  li         r3, 2
8046a920: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a924: 38000003  li         r0, 3
8046a928: d0068000  stfs       f0, -0x8000(r6)
8046a92c: 98a68000  stb        r5, -0x8000(r6)
8046a930: 98a68000  stb        r5, -0x8000(r6)
8046a934: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046a938: d0068000  stfs       f0, -0x8000(r6)
8046a93c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a940: d0068000  stfs       f0, -0x8000(r6)
8046a944: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a948: d0068000  stfs       f0, -0x8000(r6)
8046a94c: 98868000  stb        r4, -0x8000(r6)
8046a950: 98868000  stb        r4, -0x8000(r6)
8046a954: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046a958: d0068000  stfs       f0, -0x8000(r6)
8046a95c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a960: d0068000  stfs       f0, -0x8000(r6)
8046a964: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046a968: d0068000  stfs       f0, -0x8000(r6)
8046a96c: 98668000  stb        r3, -0x8000(r6)
8046a970: 98668000  stb        r3, -0x8000(r6)
8046a974: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046a978: d0068000  stfs       f0, -0x8000(r6)
8046a97c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046a980: d0068000  stfs       f0, -0x8000(r6)
8046a984: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046a988: d0068000  stfs       f0, -0x8000(r6)
8046a98c: 98068000  stb        r0, -0x8000(r6)
8046a990: 98068000  stb        r0, -0x8000(r6)
8046a994: 80010074  lwz        r0, 0x74(r1)
8046a998: 83e1006c  lwz        r31, 0x6c(r1)
8046a99c: 7c0803a6  mtlr       r0
8046a9a0: 38210070  addi       r1, r1, 0x70
8046a9a4: 4e800020  blr        
8046a9a8: 9421ffe0  stwu       r1, -0x20(r1)
8046a9ac: 7c0802a6  mflr       r0
8046a9b0: 90010024  stw        r0, 0x24(r1)
8046a9b4: dbe10010  stfd       f31, 0x10(r1)
8046a9b8: f3e10018  psq_st     f31, 24(r1), W=0, I=0
8046a9bc: 93e1000c  stw        r31, 0xc(r1)
8046a9c0: 7c7f1b78  mr         r31, r3
8046a9c4: 4bfefa6d  bl         0x8045a430
8046a9c8: c0021044  lfs        f0, 0x1044(r2) ; [806ff0c4] 3f000000 f32=0.5
8046a9cc: efe00824  fdivs      f31, f0, f1
8046a9d0: 4bfefa59  bl         0x8045a428
8046a9d4: c0821044  lfs        f4, 0x1044(r2) ; [806ff0c4] 3f000000 f32=0.5
8046a9d8: 387f0154  addi       r3, r31, 0x154
8046a9dc: c06d9fd4  lfs        f3, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046a9e0: 38800020  li         r4, 0x20
8046a9e4: eca40824  fdivs      f5, f4, f1
8046a9e8: c04da000  lfs        f2, -0x6000(r13) ; [806f2120] 3fb33333 f32=1.39999998
8046a9ec: c01f0204  lfs        f0, 0x204(r31)
8046a9f0: c03f020c  lfs        f1, 0x20c(r31)
8046a9f4: ecc300b2  fmuls      f6, f3, f2
8046a9f8: ec60302a  fadds      f3, f0, f6
8046a9fc: ec403028  fsubs      f2, f0, f6
8046aa00: ec01302a  fadds      f0, f1, f6
8046aa04: ec7f20fa  fmadds     f3, f31, f3, f4
8046aa08: ec5f20ba  fmadds     f2, f31, f2, f4
8046aa0c: ece5203a  fmadds     f7, f5, f0, f4
8046aa10: d07f0154  stfs       f3, 0x154(r31)
8046aa14: ec013028  fsubs      f0, f1, f6
8046aa18: d0ff0158  stfs       f7, 0x158(r31)
8046aa1c: ec05203a  fmadds     f0, f5, f0, f4
8046aa20: d05f015c  stfs       f2, 0x15c(r31)
8046aa24: d0ff0160  stfs       f7, 0x160(r31)
8046aa28: d05f0164  stfs       f2, 0x164(r31)
8046aa2c: d01f0168  stfs       f0, 0x168(r31)
8046aa30: d07f016c  stfs       f3, 0x16c(r31)
8046aa34: d01f0170  stfs       f0, 0x170(r31)
8046aa38: 4bbdb6d9  bl         0x80046110
8046aa3c: 80010024  lwz        r0, 0x24(r1)
8046aa40: e3e10018  psq_l      f31, 24(r1), W=0, I=0
8046aa44: cbe10010  lfd        f31, 0x10(r1)
8046aa48: 83e1000c  lwz        r31, 0xc(r1)
8046aa4c: 7c0803a6  mtlr       r0
8046aa50: 38210020  addi       r1, r1, 0x20
8046aa54: 4e800020  blr        
8046aa58: 80630150  lwz        r3, 0x150(r3)
8046aa5c: 48002cdc  b          0x8046d738
8046aa60: 9421fef0  stwu       r1, -0x110(r1)
8046aa64: 7c0802a6  mflr       r0
8046aa68: 90010114  stw        r0, 0x114(r1)
8046aa6c: dbe10100  stfd       f31, 0x100(r1)
8046aa70: f3e10108  psq_st     f31, 264(r1), W=0, I=0
8046aa74: 93e100fc  stw        r31, 0xfc(r1)
8046aa78: 7c7f1b78  mr         r31, r3
8046aa7c: 93c100f8  stw        r30, 0xf8(r1)
8046aa80: 800301b8  lwz        r0, 0x1b8(r3)
8046aa84: 2c000000  cmpwi      r0, 0
8046aa88: 41820024  beq        0x8046aaac
8046aa8c: 808300f8  lwz        r4, 0xf8(r3)
8046aa90: 38000000  li         r0, 0
8046aa94: 900301b8  stw        r0, 0x1b8(r3)
8046aa98: 2c040000  cmpwi      r4, 0
8046aa9c: 41820010  beq        0x8046aaac
8046aaa0: 7c832378  mr         r3, r4
8046aaa4: 38800000  li         r4, 0
8046aaa8: 48004ea5  bl         0x8046f94c
8046aaac: 801f0194  lwz        r0, 0x194(r31)
8046aab0: 2c000001  cmpwi      r0, 1
8046aab4: 40820030  bne        0x8046aae4
8046aab8: c03f0018  lfs        f1, 0x18(r31)
8046aabc: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046aac0: fc010040  fcmpo      cr0, f1, f0
8046aac4: 40800020  bge        0x8046aae4
8046aac8: c03f000c  lfs        f1, 0xc(r31)
8046aacc: c00dd6b0  lfs        f0, -0x2950(r13)
8046aad0: fc010040  fcmpo      cr0, f1, f0
8046aad4: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046aad8: 4082000c  bne        0x8046aae4
8046aadc: 7fe3fb78  mr         r3, r31
8046aae0: 4bfff0c1  bl         0x80469ba0
8046aae4: 801f0194  lwz        r0, 0x194(r31)
8046aae8: 2c000002  cmpwi      r0, 2
8046aaec: 40820024  bne        0x8046ab10
8046aaf0: 807f019c  lwz        r3, 0x19c(r31)
8046aaf4: 4bff3d0d  bl         0x8045e800
8046aaf8: 2c030000  cmpwi      r3, 0
8046aafc: 40820014  bne        0x8046ab10
8046ab00: 38000000  li         r0, 0
8046ab04: 901f0194  stw        r0, 0x194(r31)
8046ab08: 807f0150  lwz        r3, 0x150(r31)
8046ab0c: 48002bb5  bl         0x8046d6c0
8046ab10: c02da004  lfs        f1, -0x5ffc(r13) ; [806f2124] 42a00000 f32=80
8046ab14: 387f0044  addi       r3, r31, 0x44
8046ab18: c002d30c  lfs        f0, -0x2cf4(r2) ; [806fb38c] 3c8efa35 f32=0.0174532924
8046ab1c: 808dd678  lwz        r4, -0x2988(r13)
8046ab20: efe10032  fmuls      f31, f1, f0
8046ab24: 83c40148  lwz        r30, 0x148(r4)
8046ab28: 4bbd4c89  bl         0x8003f7b0
8046ab2c: 6fc38000  xoris      r3, r30, 0x8000
8046ab30: 3c004330  lis        r0, 0x4330
8046ab34: 906100f4  stw        r3, 0xf4(r1)
8046ab38: c8421080  lfd        f2, 0x1080(r2) ; [806ff100] 43300000 f32=176
8046ab3c: 900100f0  stw        r0, 0xf0(r1)
8046ab40: c80100f0  lfd        f0, 0xf0(r1)
8046ab44: ec001028  fsubs      f0, f0, f2
8046ab48: ec210032  fmuls      f1, f1, f0
8046ab4c: fc01f840  fcmpo      cr0, f1, f31
8046ab50: 40810008  ble        0x8046ab58
8046ab54: fc20f890  fmr        f1, f31
8046ab58: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ab5c: fc010040  fcmpo      cr0, f1, f0
8046ab60: 40810034  ble        0x8046ab94
8046ab64: c0021070  lfs        f0, 0x1070(r2) ; [806ff0f0] 4222f983 f32=40.7436638
8046ab68: 386100c0  addi       r3, r1, 0xc0
8046ab6c: 389f0044  addi       r4, r31, 0x44
8046ab70: ec200072  fmuls      f1, f0, f1
8046ab74: 4bcd173d  bl         0x8013c2b0
8046ab78: 387f01bc  addi       r3, r31, 0x1bc
8046ab7c: 38a100c0  addi       r5, r1, 0xc0
8046ab80: 7c641b78  mr         r4, r3
8046ab84: 4bebc945  bl         0x803274c8
8046ab88: 387f01bc  addi       r3, r31, 0x1bc
8046ab8c: 7c641b78  mr         r4, r3
8046ab90: 4bebc11d  bl         0x80326cac
8046ab94: c01f0008  lfs        f0, 8(r31)
8046ab98: 38610040  addi       r3, r1, 0x40
8046ab9c: d0010050  stfs       f0, 0x50(r1)
8046aba0: 389f01bc  addi       r4, r31, 0x1bc
8046aba4: c01f000c  lfs        f0, 0xc(r31)
8046aba8: d0010054  stfs       f0, 0x54(r1)
8046abac: c01f0010  lfs        f0, 0x10(r31)
8046abb0: d0010058  stfs       f0, 0x58(r1)
8046abb4: 4bebbf25  bl         0x80326ad8
8046abb8: c0210040  lfs        f1, 0x40(r1)
8046abbc: 3860000e  li         r3, 0xe
8046abc0: 4be40acd  bl         0x802ab68c
8046abc4: b061005c  sth        r3, 0x5c(r1)
8046abc8: 3860000e  li         r3, 0xe
8046abcc: c0210044  lfs        f1, 0x44(r1)
8046abd0: 4be40abd  bl         0x802ab68c
8046abd4: b061005e  sth        r3, 0x5e(r1)
8046abd8: 3860000e  li         r3, 0xe
8046abdc: c0210048  lfs        f1, 0x48(r1)
8046abe0: 4be40aad  bl         0x802ab68c
8046abe4: b0610060  sth        r3, 0x60(r1)
8046abe8: 3860000e  li         r3, 0xe
8046abec: c021004c  lfs        f1, 0x4c(r1)
8046abf0: 4be40a9d  bl         0x802ab68c
8046abf4: b0610062  sth        r3, 0x62(r1)
8046abf8: 387f0014  addi       r3, r31, 0x14
8046abfc: 4bbd4bb5  bl         0x8003f7b0
8046ac00: c0021074  lfs        f0, 0x1074(r2) ; [806ff0f4] 46800000 f32=16384
8046ac04: ec010032  fmuls      f0, f1, f0
8046ac08: fc00001e  fctiwz     f0, f0
8046ac0c: d80100f0  stfd       f0, 0xf0(r1)
8046ac10: 800100f4  lwz        r0, 0xf4(r1)
8046ac14: b0010064  sth        r0, 0x64(r1)
8046ac18: 807f0174  lwz        r3, 0x174(r31)
8046ac1c: 2c030000  cmpwi      r3, 0
8046ac20: 4182000c  beq        0x8046ac2c
8046ac24: 38810050  addi       r4, r1, 0x50
8046ac28: 48002f9d  bl         0x8046dbc4
8046ac2c: 807f0204  lwz        r3, 0x204(r31)
8046ac30: 3880000e  li         r4, 0xe
8046ac34: c0010050  lfs        f0, 0x50(r1)
8046ac38: d01f0204  stfs       f0, 0x204(r31)
8046ac3c: 80bf0208  lwz        r5, 0x208(r31)
8046ac40: c0010054  lfs        f0, 0x54(r1)
8046ac44: d01f0208  stfs       f0, 0x208(r31)
8046ac48: 801f020c  lwz        r0, 0x20c(r31)
8046ac4c: c0010058  lfs        f0, 0x58(r1)
8046ac50: d01f020c  stfs       f0, 0x20c(r31)
8046ac54: 90610034  stw        r3, 0x34(r1)
8046ac58: a861005c  lha        r3, 0x5c(r1)
8046ac5c: 90a10038  stw        r5, 0x38(r1)
8046ac60: 9001003c  stw        r0, 0x3c(r1)
8046ac64: 4be40725  bl         0x802ab388
8046ac68: d0210040  stfs       f1, 0x40(r1)
8046ac6c: 3880000e  li         r4, 0xe
8046ac70: a861005e  lha        r3, 0x5e(r1)
8046ac74: 4be40715  bl         0x802ab388
8046ac78: d0210044  stfs       f1, 0x44(r1)
8046ac7c: 3880000e  li         r4, 0xe
8046ac80: a8610060  lha        r3, 0x60(r1)
8046ac84: 4be40705  bl         0x802ab388
8046ac88: d0210048  stfs       f1, 0x48(r1)
8046ac8c: 3880000e  li         r4, 0xe
8046ac90: a8610062  lha        r3, 0x62(r1)
8046ac94: 4be406f5  bl         0x802ab388
8046ac98: d021004c  stfs       f1, 0x4c(r1)
8046ac9c: 387f01e0  addi       r3, r31, 0x1e0
8046aca0: 38810040  addi       r4, r1, 0x40
8046aca4: 4bebbd81  bl         0x80326a24
8046aca8: a8810064  lha        r4, 0x64(r1)
8046acac: 3c604330  lis        r3, 0x4330
8046acb0: 801f0250  lwz        r0, 0x250(r31)
8046acb4: 6c848000  xoris      r4, r4, 0x8000
8046acb8: 908100f4  stw        r4, 0xf4(r1)
8046acbc: c8421080  lfd        f2, 0x1080(r2) ; [806ff100] 43300000 f32=176
8046acc0: 54000739  rlwinm.    r0, r0, 0, 0x1c, 0x1c
8046acc4: 906100f0  stw        r3, 0xf0(r1)
8046acc8: c0021074  lfs        f0, 0x1074(r2) ; [806ff0f4] 46800000 f32=16384
8046accc: c82100f0  lfd        f1, 0xf0(r1)
8046acd0: ec211028  fsubs      f1, f1, f2
8046acd4: efe10024  fdivs      f31, f1, f0
8046acd8: 41820030  beq        0x8046ad08
8046acdc: c05f025c  lfs        f2, 0x25c(r31)
8046ace0: c02da018  lfs        f1, -0x5fe8(r13) ; [806f2138] 3be56042 f32=0.00700000022
8046ace4: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ace8: ec220828  fsubs      f1, f2, f1
8046acec: d03f025c  stfs       f1, 0x25c(r31)
8046acf0: fc010040  fcmpo      cr0, f1, f0
8046acf4: 40800014  bge        0x8046ad08
8046acf8: 801f0250  lwz        r0, 0x250(r31)
8046acfc: d01f025c  stfs       f0, 0x25c(r31)
8046ad00: 540007b8  rlwinm     r0, r0, 0, 0x1e, 0x1c
8046ad04: 901f0250  stw        r0, 0x250(r31)
8046ad08: c00d9fd0  lfs        f0, -0x6030(r13) ; [806f20f0] 3f90a3d7 f32=1.13
8046ad0c: 387f0110  addi       r3, r31, 0x110
8046ad10: d0010028  stfs       f0, 0x28(r1)
8046ad14: 389f0204  addi       r4, r31, 0x204
8046ad18: 38bf01e0  addi       r5, r31, 0x1e0
8046ad1c: 38c10028  addi       r6, r1, 0x28
8046ad20: d001002c  stfs       f0, 0x2c(r1)
8046ad24: d0010030  stfs       f0, 0x30(r1)
8046ad28: 4bebd121  bl         0x80327e48
8046ad2c: c07f020c  lfs        f3, 0x20c(r31)
8046ad30: 387f0240  addi       r3, r31, 0x240
8046ad34: c001003c  lfs        f0, 0x3c(r1)
8046ad38: 3881001c  addi       r4, r1, 0x1c
8046ad3c: c05f0204  lfs        f2, 0x204(r31)
8046ad40: ec630028  fsubs      f3, f3, f0
8046ad44: c0210034  lfs        f1, 0x34(r1)
8046ad48: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ad4c: ec220828  fsubs      f1, f2, f1
8046ad50: d0010020  stfs       f0, 0x20(r1)
8046ad54: d021001c  stfs       f1, 0x1c(r1)
8046ad58: d0610024  stfs       f3, 0x24(r1)
8046ad5c: 4bebd2d1  bl         0x8032802c
8046ad60: 387f0240  addi       r3, r31, 0x240
8046ad64: 389f0044  addi       r4, r31, 0x44
8046ad68: 38a1001c  addi       r5, r1, 0x1c
8046ad6c: 4bbd4ab5  bl         0x8003f820
8046ad70: c0410020  lfs        f2, 0x20(r1)
8046ad74: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ad78: fc020040  fcmpo      cr0, f2, f0
8046ad7c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046ad80: 40820024  bne        0x8046ada4
8046ad84: c0221078  lfs        f1, 0x1078(r2) ; [806ff0f8] 3c1eecc0 f32=0.00970000029
8046ad88: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046ad8c: ec2100b2  fmuls      f1, f1, f2
8046ad90: d03f024c  stfs       f1, 0x24c(r31)
8046ad94: fc010040  fcmpo      cr0, f1, f0
8046ad98: 40810028  ble        0x8046adc0
8046ad9c: d01f024c  stfs       f0, 0x24c(r31)
8046ada0: 48000020  b          0x8046adc0
8046ada4: c022107c  lfs        f1, 0x107c(r2) ; [806ff0fc] 3b5ed289 f32=0.00340000005
8046ada8: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046adac: ec2100b2  fmuls      f1, f1, f2
8046adb0: d03f024c  stfs       f1, 0x24c(r31)
8046adb4: fc010040  fcmpo      cr0, f1, f0
8046adb8: 40800008  bge        0x8046adc0
8046adbc: d01f024c  stfs       f0, 0x24c(r31)
8046adc0: 807f00f4  lwz        r3, 0xf4(r31)
8046adc4: 809f0254  lwz        r4, 0x254(r31)
8046adc8: 8003001c  lwz        r0, 0x1c(r3)
8046adcc: 7c040050  subf       r0, r4, r0
8046add0: 2c000005  cmpwi      r0, 5
8046add4: 418101f0  bgt        0x8046afc4
8046add8: 38c10034  addi       r6, r1, 0x34
8046addc: 386100b0  addi       r3, r1, 0xb0
8046ade0: e05f0204  psq_l      f2, 516(r31), W=0, I=0
8046ade4: 38a10010  addi       r5, r1, 0x10
8046ade8: e0260000  psq_l      f1, 0(r6), W=0, I=0
8046adec: 7c641b78  mr         r4, r3
8046adf0: 10020828  ps_sub     f0, f2, f1
8046adf4: e05f820c  psq_l      f2, 524(r31), W=1, I=0
8046adf8: e0268008  psq_l      f1, 8(r6), W=1, I=0
8046adfc: f0050000  psq_st     f0, 0(r5), W=0, I=0
8046ae00: 10020828  ps_sub     f0, f2, f1
8046ae04: c0410010  lfs        f2, 0x10(r1)
8046ae08: f0058008  psq_st     f0, 8(r5), W=1, I=0
8046ae0c: c0210014  lfs        f1, 0x14(r1)
8046ae10: c0010018  lfs        f0, 0x18(r1)
8046ae14: d04100b0  stfs       f2, 0xb0(r1)
8046ae18: d02100b4  stfs       f1, 0xb4(r1)
8046ae1c: d00100b8  stfs       f0, 0xb8(r1)
8046ae20: 4bebd20d  bl         0x8032802c
8046ae24: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ae28: fc010000  fcmpu      cr0, f1, f0
8046ae2c: 40820024  bne        0x8046ae50
8046ae30: 3c80807d  lis        r4, -0x7f83
8046ae34: 3864033c  addi       r3, r4, 0x33c
8046ae38: c044033c  lfs        f2, 0x33c(r4)
8046ae3c: c0230004  lfs        f1, 4(r3)
8046ae40: c0030008  lfs        f0, 8(r3)
8046ae44: d04100b0  stfs       f2, 0xb0(r1)
8046ae48: d02100b4  stfs       f1, 0xb4(r1)
8046ae4c: d00100b8  stfs       f0, 0xb8(r1)
8046ae50: 3c80807d  lis        r4, -0x7f83
8046ae54: 386100a4  addi       r3, r1, 0xa4
8046ae58: 38a40330  addi       r5, r4, 0x330
8046ae5c: c0440330  lfs        f2, 0x330(r4)
8046ae60: c0250004  lfs        f1, 4(r5)
8046ae64: 388100b0  addi       r4, r1, 0xb0
8046ae68: c0050008  lfs        f0, 8(r5)
8046ae6c: 38a10098  addi       r5, r1, 0x98
8046ae70: d04100a4  stfs       f2, 0xa4(r1)
8046ae74: d02100a8  stfs       f1, 0xa8(r1)
8046ae78: d00100ac  stfs       f0, 0xac(r1)
8046ae7c: 4bbd49a5  bl         0x8003f820
8046ae80: 38610098  addi       r3, r1, 0x98
8046ae84: 7c641b78  mr         r4, r3
8046ae88: 4bebd1a5  bl         0x8032802c
8046ae8c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ae90: fc010000  fcmpu      cr0, f1, f0
8046ae94: 40820024  bne        0x8046aeb8
8046ae98: 3c80807d  lis        r4, -0x7f83
8046ae9c: 38640324  addi       r3, r4, 0x324
8046aea0: c0440324  lfs        f2, 0x324(r4)
8046aea4: c0230004  lfs        f1, 4(r3)
8046aea8: c0030008  lfs        f0, 8(r3)
8046aeac: d0410098  stfs       f2, 0x98(r1)
8046aeb0: d021009c  stfs       f1, 0x9c(r1)
8046aeb4: d00100a0  stfs       f0, 0xa0(r1)
8046aeb8: 386100b0  addi       r3, r1, 0xb0
8046aebc: 38810098  addi       r4, r1, 0x98
8046aec0: 38a100a4  addi       r5, r1, 0xa4
8046aec4: 4bbd495d  bl         0x8003f820
8046aec8: 38610068  addi       r3, r1, 0x68
8046aecc: 389f0204  addi       r4, r31, 0x204
8046aed0: 38a10098  addi       r5, r1, 0x98
8046aed4: 4bebd08d  bl         0x80327f60
8046aed8: c06d9fc0  lfs        f3, -0x6040(r13) ; [806f20e0] 3d4ccccd f32=0.0500000007
8046aedc: c02d9fc4  lfs        f1, -0x603c(r13) ; [806f20e4] 3e4ccccd f32=0.200000003
8046aee0: ec5f1828  fsubs      f2, f31, f3
8046aee4: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046aee8: ec211828  fsubs      f1, f1, f3
8046aeec: ec820824  fdivs      f4, f2, f1
8046aef0: fc040040  fcmpo      cr0, f4, f0
8046aef4: 4081000c  ble        0x8046af00
8046aef8: fc800090  fmr        f4, f0
8046aefc: 48000014  b          0x8046af10
8046af00: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046af04: fc040040  fcmpo      cr0, f4, f0
8046af08: 40800008  bge        0x8046af10
8046af0c: fc800090  fmr        f4, f0
8046af10: c00d9fc8  lfs        f0, -0x6038(r13) ; [806f20e8] 3f800000 f32=1
8046af14: c04dd6ac  lfs        f2, -0x2954(r13)
8046af18: c03f025c  lfs        f1, 0x25c(r31)
8046af1c: ec001028  fsubs      f0, f0, f2
8046af20: c0621040  lfs        f3, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046af24: fc011840  fcmpo      cr0, f1, f3
8046af28: ec44103a  fmadds     f2, f4, f0, f2
8046af2c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046af30: 40820008  bne        0x8046af38
8046af34: 4800000c  b          0x8046af40
8046af38: c00d9fcc  lfs        f0, -0x6034(r13) ; [806f20ec] 3f000000 f32=0.5
8046af3c: ec610032  fmuls      f3, f1, f0
8046af40: 801f0258  lwz        r0, 0x258(r31)
8046af44: ec2200f2  fmuls      f1, f2, f3
8046af48: 2c000000  cmpwi      r0, 0
8046af4c: 41820010  beq        0x8046af5c
8046af50: 2c000001  cmpwi      r0, 1
8046af54: 41820030  beq        0x8046af84
8046af58: 48000050  b          0x8046afa8
8046af5c: 38ad9fac  addi       r5, r13, -0x6054
8046af60: 88cd9fac  lbz        r6, -0x6054(r13) ; [806f20cc] ffffffff f32=nan
8046af64: 88850001  lbz        r4, 1(r5)
8046af68: 88650002  lbz        r3, 2(r5)
8046af6c: 88050003  lbz        r0, 3(r5)
8046af70: 98c1000c  stb        r6, 0xc(r1)
8046af74: 9881000d  stb        r4, 0xd(r1)
8046af78: 9861000e  stb        r3, 0xe(r1)
8046af7c: 9801000f  stb        r0, 0xf(r1)
8046af80: 48000028  b          0x8046afa8
8046af84: 38ad9fb4  addi       r5, r13, -0x604c
8046af88: 88cd9fb4  lbz        r6, -0x604c(r13) ; [806f20d4] ffa040ff f32=nan
8046af8c: 88850001  lbz        r4, 1(r5)
8046af90: 88650002  lbz        r3, 2(r5)
8046af94: 88050003  lbz        r0, 3(r5)
8046af98: 98c1000c  stb        r6, 0xc(r1)
8046af9c: 9881000d  stb        r4, 0xd(r1)
8046afa0: 9861000e  stb        r3, 0xe(r1)
8046afa4: 9801000f  stb        r0, 0xf(r1)
8046afa8: 8001000c  lwz        r0, 0xc(r1)
8046afac: 38810068  addi       r4, r1, 0x68
8046afb0: 90010008  stw        r0, 8(r1)
8046afb4: 38a10008  addi       r5, r1, 8
8046afb8: 807f0150  lwz        r3, 0x150(r31)
8046afbc: 48002619  bl         0x8046d5d4
8046afc0: 4800000c  b          0x8046afcc
8046afc4: 807f0150  lwz        r3, 0x150(r31)
8046afc8: 48002771  bl         0x8046d738
8046afcc: 806dd678  lwz        r3, -0x2988(r13)
8046afd0: 38bf0204  addi       r5, r31, 0x204
8046afd4: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046afd8: 80630158  lwz        r3, 0x158(r3)
8046afdc: 80830044  lwz        r4, 0x44(r3)
8046afe0: 8064005c  lwz        r3, 0x5c(r4)
8046afe4: 38840060  addi       r4, r4, 0x60
8046afe8: 4bef3f31  bl         0x8035ef18
8046afec: 2c030000  cmpwi      r3, 0
8046aff0: 4182002c  beq        0x8046b01c
8046aff4: 800da014  lwz        r0, -0x5fec(r13) ; [806f2134] 00000078 f32=1.68155816e-43
8046aff8: 901f0260  stw        r0, 0x260(r31)
8046affc: 806dd678  lwz        r3, -0x2988(r13)
8046b000: 80630158  lwz        r3, 0x158(r3)
8046b004: 80630044  lwz        r3, 0x44(r3)
8046b008: 8063005c  lwz        r3, 0x5c(r3)
8046b00c: c003004c  lfs        f0, 0x4c(r3)
8046b010: fc000050  fneg       f0, f0
8046b014: d01f0264  stfs       f0, 0x264(r31)
8046b018: 48000018  b          0x8046b030
8046b01c: 807f0260  lwz        r3, 0x260(r31)
8046b020: 2c030000  cmpwi      r3, 0
8046b024: 4081000c  ble        0x8046b030
8046b028: 3803ffff  addi       r0, r3, -1
8046b02c: 901f0260  stw        r0, 0x260(r31)
8046b030: 7fe3fb78  mr         r3, r31
8046b034: 4be24d59  bl         0x8028fd8c
8046b038: 80010114  lwz        r0, 0x114(r1)
8046b03c: e3e10108  psq_l      f31, 264(r1), W=0, I=0
8046b040: cbe10100  lfd        f31, 0x100(r1)
8046b044: 83e100fc  lwz        r31, 0xfc(r1)
8046b048: 83c100f8  lwz        r30, 0xf8(r1)
8046b04c: 7c0803a6  mtlr       r0
8046b050: 38210110  addi       r1, r1, 0x110
8046b054: 4e800020  blr        
8046b058: 9421ffa0  stwu       r1, -0x60(r1)
8046b05c: 7c0802a6  mflr       r0
8046b060: 90010064  stw        r0, 0x64(r1)
8046b064: 39610060  addi       r11, r1, 0x60
8046b068: 4bb9c7f9  bl         0x80007860
8046b06c: e0240000  psq_l      f1, 0(r4), W=0, I=0
8046b070: 3be1002c  addi       r31, r1, 0x2c
8046b074: e003005c  psq_l      f0, 92(r3), W=0, I=0
8046b078: 7ca82b78  mr         r8, r5
8046b07c: 80e50000  lwz        r7, 0(r5)
8046b080: 7c7d1b78  mr         r29, r3
8046b084: 10010028  ps_sub     f0, f1, f0
8046b088: 80c50004  lwz        r6, 4(r5)
8046b08c: 80050008  lwz        r0, 8(r5)
8046b090: 38a10020  addi       r5, r1, 0x20
8046b094: e0248008  psq_l      f1, 8(r4), W=1, I=0
8046b098: 7d044378  mr         r4, r8
8046b09c: f01f0000  psq_st     f0, 0(r31), W=0, I=0
8046b0a0: e0038064  psq_l      f0, 100(r3), W=1, I=0
8046b0a4: 7fe3fb78  mr         r3, r31
8046b0a8: 90e10038  stw        r7, 0x38(r1)
8046b0ac: 10010028  ps_sub     f0, f1, f0
8046b0b0: 90c1003c  stw        r6, 0x3c(r1)
8046b0b4: 90010040  stw        r0, 0x40(r1)
8046b0b8: f01f8008  psq_st     f0, 8(r31), W=1, I=0
8046b0bc: 4bbd4765  bl         0x8003f820
8046b0c0: 3bc10020  addi       r30, r1, 0x20
8046b0c4: c01d00dc  lfs        f0, 0xdc(r29)
8046b0c8: e05e0000  psq_l      f2, 0(r30), W=0, I=0
8046b0cc: 7fc3f378  mr         r3, r30
8046b0d0: 7fe4fb78  mr         r4, r31
8046b0d4: 38a10014  addi       r5, r1, 0x14
8046b0d8: 10220018  ps_muls0   f1, f2, f0
8046b0dc: e05e8008  psq_l      f2, 8(r30), W=1, I=0
8046b0e0: f03e0000  psq_st     f1, 0(r30), W=0, I=0
8046b0e4: 10220018  ps_muls0   f1, f2, f0
8046b0e8: f03e8008  psq_st     f1, 8(r30), W=1, I=0
8046b0ec: 4bbd4735  bl         0x8003f820
8046b0f0: 38610014  addi       r3, r1, 0x14
8046b0f4: 4bbd46bd  bl         0x8003f7b0
8046b0f8: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046b0fc: fc010040  fcmpo      cr0, f1, f0
8046b100: 40810068  ble        0x8046b168
8046b104: 38610014  addi       r3, r1, 0x14
8046b108: 38810038  addi       r4, r1, 0x38
8046b10c: e0630004  psq_l      f3, 4(r3), W=0, I=0
8046b110: e0440004  psq_l      f2, 4(r4), W=0, I=0
8046b114: e0038000  psq_l      f0, 0(r3), W=1, I=0
8046b118: 106300b2  ps_mul     f3, f3, f2
8046b11c: e0448000  psq_l      f2, 0(r4), W=1, I=0
8046b120: 104018ba  ps_madd    f2, f0, f2, f3
8046b124: 100218d4  ps_sum0    f0, f2, f3, f3
8046b128: ec000824  fdivs      f0, f0, f1
8046b12c: fc010040  fcmpo      cr0, f1, f0
8046b130: 40810038  ble        0x8046b168
8046b134: ec800824  fdivs      f4, f0, f1
8046b138: e03e0000  psq_l      f1, 0(r30), W=0, I=0
8046b13c: e0630000  psq_l      f3, 0(r3), W=0, I=0
8046b140: 10010118  ps_muls0   f0, f1, f4
8046b144: e03e8008  psq_l      f1, 8(r30), W=1, I=0
8046b148: 10430118  ps_muls0   f2, f3, f4
8046b14c: e0638008  psq_l      f3, 8(r3), W=1, I=0
8046b150: f01e0000  psq_st     f0, 0(r30), W=0, I=0
8046b154: 10010118  ps_muls0   f0, f1, f4
8046b158: f0430000  psq_st     f2, 0(r3), W=0, I=0
8046b15c: 10430118  ps_muls0   f2, f3, f4
8046b160: f01e8008  psq_st     f0, 8(r30), W=1, I=0
8046b164: f0438008  psq_st     f2, 8(r3), W=1, I=0
8046b168: 7fa3eb78  mr         r3, r29
8046b16c: 38810020  addi       r4, r1, 0x20
8046b170: 4bed3111  bl         0x8033e280
8046b174: 38a10014  addi       r5, r1, 0x14
8046b178: 38810038  addi       r4, r1, 0x38
8046b17c: e0640000  psq_l      f3, 0(r4), W=0, I=0
8046b180: 38610008  addi       r3, r1, 8
8046b184: e0250000  psq_l      f1, 0(r5), W=0, I=0
8046b188: c01d0080  lfs        f0, 0x80(r29)
8046b18c: 10430828  ps_sub     f2, f3, f1
8046b190: e0648008  psq_l      f3, 8(r4), W=1, I=0
8046b194: e0258008  psq_l      f1, 8(r5), W=1, I=0
8046b198: f0430000  psq_st     f2, 0(r3), W=0, I=0
8046b19c: 10430828  ps_sub     f2, f3, f1
8046b1a0: c0210008  lfs        f1, 8(r1)
8046b1a4: f0438008  psq_st     f2, 8(r3), W=1, I=0
8046b1a8: fc010040  fcmpo      cr0, f1, f0
8046b1ac: 4080000c  bge        0x8046b1b8
8046b1b0: d03d0080  stfs       f1, 0x80(r29)
8046b1b4: 48000014  b          0x8046b1c8
8046b1b8: c01d008c  lfs        f0, 0x8c(r29)
8046b1bc: fc010040  fcmpo      cr0, f1, f0
8046b1c0: 40810008  ble        0x8046b1c8
8046b1c4: d03d008c  stfs       f1, 0x8c(r29)
8046b1c8: c021000c  lfs        f1, 0xc(r1)
8046b1cc: c01d0084  lfs        f0, 0x84(r29)
8046b1d0: fc010040  fcmpo      cr0, f1, f0
8046b1d4: 4080000c  bge        0x8046b1e0
8046b1d8: d03d0084  stfs       f1, 0x84(r29)
8046b1dc: 48000014  b          0x8046b1f0
8046b1e0: c01d0090  lfs        f0, 0x90(r29)
8046b1e4: fc010040  fcmpo      cr0, f1, f0
8046b1e8: 40810008  ble        0x8046b1f0
8046b1ec: d03d0090  stfs       f1, 0x90(r29)
8046b1f0: c0210010  lfs        f1, 0x10(r1)
8046b1f4: c01d0088  lfs        f0, 0x88(r29)
8046b1f8: fc010040  fcmpo      cr0, f1, f0
8046b1fc: 4080000c  bge        0x8046b208
8046b200: d03d0088  stfs       f1, 0x88(r29)
8046b204: 48000014  b          0x8046b218
8046b208: c01d0094  lfs        f0, 0x94(r29)
8046b20c: fc010040  fcmpo      cr0, f1, f0
8046b210: 40810008  ble        0x8046b218
8046b214: d03d0094  stfs       f1, 0x94(r29)
8046b218: 39610060  addi       r11, r1, 0x60
8046b21c: 4bb9c691  bl         0x800078ac
8046b220: 80010064  lwz        r0, 0x64(r1)
8046b224: 7c0803a6  mtlr       r0
8046b228: 38210060  addi       r1, r1, 0x60
8046b22c: 4e800020  blr        
8046b230: 9421ff00  stwu       r1, -0x100(r1)
8046b234: 7c0802a6  mflr       r0
8046b238: 90010104  stw        r0, 0x104(r1)
8046b23c: 396100d0  addi       r11, r1, 0xd0
8046b240: dbe100f0  stfd       f31, 0xf0(r1)
8046b244: f3e100f8  psq_st     f31, 248(r1), W=0, I=0
8046b248: dbc100e0  stfd       f30, 0xe0(r1)
8046b24c: f3c100e8  psq_st     f30, 232(r1), W=0, I=0
8046b250: dba100d0  stfd       f29, 0xd0(r1)
8046b254: f3a100d8  psq_st     f29, 216(r1), W=0, I=0
8046b258: 4bb9c605  bl         0x8000785c
8046b25c: ffa01090  fmr        f29, f2
8046b260: c0450004  lfs        f2, 4(r5)
8046b264: c0050008  lfs        f0, 8(r5)
8046b268: ffc01890  fmr        f30, f3
8046b26c: c0850000  lfs        f4, 0(r5)
8046b270: ec420072  fmuls      f2, f2, f1
8046b274: ec640072  fmuls      f3, f4, f1
8046b278: d04100b4  stfs       f2, 0xb4(r1)
8046b27c: ec000072  fmuls      f0, f0, f1
8046b280: 7c7f1b78  mr         r31, r3
8046b284: d06100b0  stfs       f3, 0xb0(r1)
8046b288: 7c9c2378  mr         r28, r4
8046b28c: d00100b8  stfs       f0, 0xb8(r1)
8046b290: 7cbd2b78  mr         r29, r5
8046b294: 7cde3378  mr         r30, r6
8046b298: c0030068  lfs        f0, 0x68(r3)
8046b29c: fc030040  fcmpo      cr0, f3, f0
8046b2a0: 4080000c  bge        0x8046b2ac
8046b2a4: d0630068  stfs       f3, 0x68(r3)
8046b2a8: 48000014  b          0x8046b2bc
8046b2ac: c0030074  lfs        f0, 0x74(r3)
8046b2b0: fc030040  fcmpo      cr0, f3, f0
8046b2b4: 40810008  ble        0x8046b2bc
8046b2b8: d0630074  stfs       f3, 0x74(r3)
8046b2bc: c02100b4  lfs        f1, 0xb4(r1)
8046b2c0: c003006c  lfs        f0, 0x6c(r3)
8046b2c4: fc010040  fcmpo      cr0, f1, f0
8046b2c8: 4080000c  bge        0x8046b2d4
8046b2cc: d023006c  stfs       f1, 0x6c(r3)
8046b2d0: 48000014  b          0x8046b2e4
8046b2d4: c0030078  lfs        f0, 0x78(r3)
8046b2d8: fc010040  fcmpo      cr0, f1, f0
8046b2dc: 40810008  ble        0x8046b2e4
8046b2e0: d0230078  stfs       f1, 0x78(r3)
8046b2e4: c02100b8  lfs        f1, 0xb8(r1)
8046b2e8: c0030070  lfs        f0, 0x70(r3)
8046b2ec: fc010040  fcmpo      cr0, f1, f0
8046b2f0: 4080000c  bge        0x8046b2fc
8046b2f4: d0230070  stfs       f1, 0x70(r3)
8046b2f8: 48000014  b          0x8046b30c
8046b2fc: c003007c  lfs        f0, 0x7c(r3)
8046b300: fc010040  fcmpo      cr0, f1, f0
8046b304: 40810008  ble        0x8046b30c
8046b308: d023007c  stfs       f1, 0x7c(r3)
8046b30c: 80030178  lwz        r0, 0x178(r3)
8046b310: 2c000000  cmpwi      r0, 0
8046b314: 40800028  bge        0x8046b33c
8046b318: 3c80807d  lis        r4, -0x7f83
8046b31c: 38640318  addi       r3, r4, 0x318
8046b320: c0440318  lfs        f2, 0x318(r4)
8046b324: c0230004  lfs        f1, 4(r3)
8046b328: c0030008  lfs        f0, 8(r3)
8046b32c: d04100a4  stfs       f2, 0xa4(r1)
8046b330: d02100a8  stfs       f1, 0xa8(r1)
8046b334: d00100ac  stfs       f0, 0xac(r1)
8046b338: 48000014  b          0x8046b34c
8046b33c: 7fe3fb78  mr         r3, r31
8046b340: 7f85e378  mr         r5, r28
8046b344: 388100a4  addi       r4, r1, 0xa4
8046b348: 4bed2865  bl         0x8033dbac
8046b34c: 386100a4  addi       r3, r1, 0xa4
8046b350: c0fd0000  lfs        f7, 0(r29)
8046b354: e0430000  psq_l      f2, 0(r3), W=0, I=0
8046b358: e03f0014  psq_l      f1, 20(r31), W=0, I=0
8046b35c: fc603850  fneg       f3, f7
8046b360: c0dd0004  lfs        f6, 4(r29)
8046b364: 1102082a  ps_add     f8, f2, f1
8046b368: e0438008  psq_l      f2, 8(r3), W=1, I=0
8046b36c: c09d0008  lfs        f4, 8(r29)
8046b370: f1030000  psq_st     f8, 0(r3), W=0, I=0
8046b374: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046b378: e03f801c  psq_l      f1, 28(r31), W=1, I=0
8046b37c: c0a100a8  lfs        f5, 0xa8(r1)
8046b380: 1102082a  ps_add     f8, f2, f1
8046b384: c04100a4  lfs        f2, 0xa4(r1)
8046b388: ec260172  fmuls      f1, f6, f5
8046b38c: f1038008  psq_st     f8, 8(r3), W=1, I=0
8046b390: ec2308b8  fmsubs     f1, f3, f2, f1
8046b394: c06100ac  lfs        f3, 0xac(r1)
8046b398: efe408fc  fnmsubs    f31, f4, f3, f1
8046b39c: fc1f0040  fcmpo      cr0, f31, f0
8046b3a0: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046b3a4: 41820328  beq        0x8046b6cc
8046b3a8: ec4717fa  fmadds     f2, f7, f31, f2
8046b3ac: 38610098  addi       r3, r1, 0x98
8046b3b0: ec262ffa  fmadds     f1, f6, f31, f5
8046b3b4: ec041ffa  fmadds     f0, f4, f31, f3
8046b3b8: d0410098  stfs       f2, 0x98(r1)
8046b3bc: d021009c  stfs       f1, 0x9c(r1)
8046b3c0: d00100a0  stfs       f0, 0xa0(r1)
8046b3c4: 4bbd43ed  bl         0x8003f7b0
8046b3c8: ec7f07b2  fmuls      f3, f31, f30
8046b3cc: fc011840  fcmpo      cr0, f1, f3
8046b3d0: 40810074  ble        0x8046b444
8046b3d4: 2c1e0000  cmpwi      r30, 0
8046b3d8: 41820020  beq        0x8046b3f8
8046b3dc: ec41f828  fsubs      f2, f1, f31
8046b3e0: c0021038  lfs        f0, 0x1038(r2) ; [806ff0b8] 3e19999a f32=0.150000006
8046b3e4: ec5f00b2  fmuls      f2, f31, f2
8046b3e8: ec5f00b2  fmuls      f2, f31, f2
8046b3ec: ec0018ba  fmadds     f0, f0, f2, f3
8046b3f0: ec600824  fdivs      f3, f0, f1
8046b3f4: 48000008  b          0x8046b3fc
8046b3f8: ec630824  fdivs      f3, f3, f1
8046b3fc: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046b400: fc030040  fcmpo      cr0, f3, f0
8046b404: 4081000c  ble        0x8046b410
8046b408: fc600090  fmr        f3, f0
8046b40c: 48000014  b          0x8046b420
8046b410: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046b414: fc030040  fcmpo      cr0, f3, f0
8046b418: 40800008  bge        0x8046b420
8046b41c: fc600090  fmr        f3, f0
8046b420: c0410098  lfs        f2, 0x98(r1)
8046b424: c021009c  lfs        f1, 0x9c(r1)
8046b428: c00100a0  lfs        f0, 0xa0(r1)
8046b42c: ec4200f2  fmuls      f2, f2, f3
8046b430: ec2100f2  fmuls      f1, f1, f3
8046b434: ec0000f2  fmuls      f0, f0, f3
8046b438: d0410098  stfs       f2, 0x98(r1)
8046b43c: d021009c  stfs       f1, 0x9c(r1)
8046b440: d00100a0  stfs       f0, 0xa0(r1)
8046b444: c0210098  lfs        f1, 0x98(r1)
8046b448: 38610074  addi       r3, r1, 0x74
8046b44c: c041009c  lfs        f2, 0x9c(r1)
8046b450: c00100a0  lfs        f0, 0xa0(r1)
8046b454: fc200850  fneg       f1, f1
8046b458: fc401050  fneg       f2, f2
8046b45c: fc600050  fneg       f3, f0
8046b460: 4bcc58b1  bl         0x80130d10
8046b464: c0010074  lfs        f0, 0x74(r1)
8046b468: 7fe3fb78  mr         r3, r31
8046b46c: d01f0234  stfs       f0, 0x234(r31)
8046b470: 7f84e378  mr         r4, r28
8046b474: 38bf0234  addi       r5, r31, 0x234
8046b478: c0010078  lfs        f0, 0x78(r1)
8046b47c: d01f0238  stfs       f0, 0x238(r31)
8046b480: c001007c  lfs        f0, 0x7c(r1)
8046b484: d01f023c  stfs       f0, 0x23c(r31)
8046b488: 4bfffbd1  bl         0x8046b058
8046b48c: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046b490: 38a10068  addi       r5, r1, 0x68
8046b494: e03d0000  psq_l      f1, 0(r29), W=0, I=0
8046b498: 7fe3fb78  mr         r3, r31
8046b49c: ec00e82a  fadds      f0, f0, f29
8046b4a0: 388100b0  addi       r4, r1, 0xb0
8046b4a4: ec5f0032  fmuls      f2, f31, f0
8046b4a8: 10010098  ps_muls0   f0, f1, f2
8046b4ac: e03d8008  psq_l      f1, 8(r29), W=1, I=0
8046b4b0: f0050000  psq_st     f0, 0(r5), W=0, I=0
8046b4b4: 10010098  ps_muls0   f0, f1, f2
8046b4b8: f0058008  psq_st     f0, 8(r5), W=1, I=0
8046b4bc: c0410068  lfs        f2, 0x68(r1)
8046b4c0: c021006c  lfs        f1, 0x6c(r1)
8046b4c4: c0010070  lfs        f0, 0x70(r1)
8046b4c8: d04100b0  stfs       f2, 0xb0(r1)
8046b4cc: d02100b4  stfs       f1, 0xb4(r1)
8046b4d0: d00100b8  stfs       f0, 0xb8(r1)
8046b4d4: 4bed2e65  bl         0x8033e338
8046b4d8: e07f0048  psq_l      f3, 72(r31), W=0, I=0
8046b4dc: 38a1008c  addi       r5, r1, 0x8c
8046b4e0: e05d0004  psq_l      f2, 4(r29), W=0, I=0
8046b4e4: 38c10080  addi       r6, r1, 0x80
8046b4e8: e0ff0044  psq_l      f7, 68(r31), W=0, I=0
8046b4ec: 39010050  addi       r8, r1, 0x50
8046b4f0: 106300b2  ps_mul     f3, f3, f2
8046b4f4: e01f8044  psq_l      f0, 68(r31), W=1, I=0
8046b4f8: e03d8000  psq_l      f1, 0(r29), W=1, I=0
8046b4fc: 11203890  ps_mr      f9, f7
8046b500: e09d0000  psq_l      f4, 0(r29), W=0, I=0
8046b504: 38e1005c  addi       r7, r1, 0x5c
8046b508: 1040187a  ps_madd    f2, f0, f1, f3
8046b50c: c02d9fec  lfs        f1, -0x6014(r13) ; [806f210c] 3f7d70a4 f32=0.99000001
8046b510: c00d9ff0  lfs        f0, -0x6010(r13) ; [806f2110] 3f7c28f6 f32=0.985000014
8046b514: 39210038  addi       r9, r1, 0x38
8046b518: 39410044  addi       r10, r1, 0x44
8046b51c: 7fe3fb78  mr         r3, r31
8046b520: 104218d4  ps_sum0    f2, f2, f3, f3
8046b524: 388100b0  addi       r4, r1, 0xb0
8046b528: 10640098  ps_muls0   f3, f4, f2
8046b52c: e09d8008  psq_l      f4, 8(r29), W=1, I=0
8046b530: f0650000  psq_st     f3, 0(r5), W=0, I=0
8046b534: 10640098  ps_muls0   f3, f4, f2
8046b538: e0450000  psq_l      f2, 0(r5), W=0, I=0
8046b53c: f0658008  psq_st     f3, 8(r5), W=1, I=0
8046b540: 10c71028  ps_sub     f6, f7, f2
8046b544: e0ff804c  psq_l      f7, 76(r31), W=1, I=0
8046b548: 11020058  ps_muls0   f8, f2, f1
8046b54c: f0c60000  psq_st     f6, 0(r6), W=0, I=0
8046b550: 10c71828  ps_sub     f6, f7, f3
8046b554: f1080000  psq_st     f8, 0(r8), W=0, I=0
8046b558: 11030058  ps_muls0   f8, f3, f1
8046b55c: e0460000  psq_l      f2, 0(r6), W=0, I=0
8046b560: c0210054  lfs        f1, 0x54(r1)
8046b564: 10620018  ps_muls0   f3, f2, f0
8046b568: c0410050  lfs        f2, 0x50(r1)
8046b56c: d041008c  stfs       f2, 0x8c(r1)
8046b570: f0670000  psq_st     f3, 0(r7), W=0, I=0
8046b574: 10660018  ps_muls0   f3, f6, f0
8046b578: c0a1005c  lfs        f5, 0x5c(r1)
8046b57c: c0810060  lfs        f4, 0x60(r1)
8046b580: d0210090  stfs       f1, 0x90(r1)
8046b584: f0678008  psq_st     f3, 8(r7), W=1, I=0
8046b588: e0450000  psq_l      f2, 0(r5), W=0, I=0
8046b58c: f1088008  psq_st     f8, 8(r8), W=1, I=0
8046b590: c0610064  lfs        f3, 0x64(r1)
8046b594: f0c68008  psq_st     f6, 8(r6), W=1, I=0
8046b598: c0010058  lfs        f0, 0x58(r1)
8046b59c: d0a10080  stfs       f5, 0x80(r1)
8046b5a0: d0810084  stfs       f4, 0x84(r1)
8046b5a4: e0860000  psq_l      f4, 0(r6), W=0, I=0
8046b5a8: d0610088  stfs       f3, 0x88(r1)
8046b5ac: 1024102a  ps_add     f1, f4, f2
8046b5b0: d0010094  stfs       f0, 0x94(r1)
8046b5b4: e0868008  psq_l      f4, 8(r6), W=1, I=0
8046b5b8: 10000890  ps_mr      f0, f1
8046b5bc: e0458008  psq_l      f2, 8(r5), W=1, I=0
8046b5c0: f0290000  psq_st     f1, 0(r9), W=0, I=0
8046b5c4: 1024102a  ps_add     f1, f4, f2
8046b5c8: 10004828  ps_sub     f0, f0, f9
8046b5cc: f0298008  psq_st     f1, 8(r9), W=1, I=0
8046b5d0: f00a0000  psq_st     f0, 0(r10), W=0, I=0
8046b5d4: 10013828  ps_sub     f0, f1, f7
8046b5d8: f00a8008  psq_st     f0, 8(r10), W=1, I=0
8046b5dc: c0410044  lfs        f2, 0x44(r1)
8046b5e0: c0210048  lfs        f1, 0x48(r1)
8046b5e4: c001004c  lfs        f0, 0x4c(r1)
8046b5e8: d04100b0  stfs       f2, 0xb0(r1)
8046b5ec: d02100b4  stfs       f1, 0xb4(r1)
8046b5f0: d00100b8  stfs       f0, 0xb8(r1)
8046b5f4: 4bed2c8d  bl         0x8033e280
8046b5f8: e07f0018  psq_l      f3, 24(r31), W=0, I=0
8046b5fc: 38810020  addi       r4, r1, 0x20
8046b600: e05d0004  psq_l      f2, 4(r29), W=0, I=0
8046b604: 38a1002c  addi       r5, r1, 0x2c
8046b608: e01f8014  psq_l      f0, 20(r31), W=1, I=0
8046b60c: 38610008  addi       r3, r1, 8
8046b610: 106300b2  ps_mul     f3, f3, f2
8046b614: e03d8000  psq_l      f1, 0(r29), W=1, I=0
8046b618: e09d0000  psq_l      f4, 0(r29), W=0, I=0
8046b61c: e0bf0014  psq_l      f5, 20(r31), W=0, I=0
8046b620: 1040187a  ps_madd    f2, f0, f1, f3
8046b624: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046b628: c00d9fe8  lfs        f0, -0x6018(r13) ; [806f2108] 3f7fa440 f32=0.998600006
8046b62c: 104218d4  ps_sum0    f2, f2, f3, f3
8046b630: efa10028  fsubs      f29, f1, f0
8046b634: 10040098  ps_muls0   f0, f4, f2
8046b638: e09d8008  psq_l      f4, 8(r29), W=1, I=0
8046b63c: f0040000  psq_st     f0, 0(r4), W=0, I=0
8046b640: 10040098  ps_muls0   f0, f4, f2
8046b644: e0240000  psq_l      f1, 0(r4), W=0, I=0
8046b648: f0048008  psq_st     f0, 8(r4), W=1, I=0
8046b64c: 10250828  ps_sub     f1, f5, f1
8046b650: e0bf801c  psq_l      f5, 28(r31), W=1, I=0
8046b654: f0250000  psq_st     f1, 0(r5), W=0, I=0
8046b658: 10250028  ps_sub     f1, f5, f0
8046b65c: f0258008  psq_st     f1, 8(r5), W=1, I=0
8046b660: c061002c  lfs        f3, 0x2c(r1)
8046b664: c0810030  lfs        f4, 0x30(r1)
8046b668: c0010034  lfs        f0, 0x34(r1)
8046b66c: fc201850  fneg       f1, f3
8046b670: d0610098  stfs       f3, 0x98(r1)
8046b674: fc402050  fneg       f2, f4
8046b678: fc600050  fneg       f3, f0
8046b67c: d081009c  stfs       f4, 0x9c(r1)
8046b680: d00100a0  stfs       f0, 0xa0(r1)
8046b684: 4bcc568d  bl         0x80130d10
8046b688: 38a10008  addi       r5, r1, 8
8046b68c: 38c10014  addi       r6, r1, 0x14
8046b690: e0250000  psq_l      f1, 0(r5), W=0, I=0
8046b694: 7fe3fb78  mr         r3, r31
8046b698: 38810098  addi       r4, r1, 0x98
8046b69c: 10010758  ps_muls0   f0, f1, f29
8046b6a0: e0258008  psq_l      f1, 8(r5), W=1, I=0
8046b6a4: f0060000  psq_st     f0, 0(r6), W=0, I=0
8046b6a8: 10010758  ps_muls0   f0, f1, f29
8046b6ac: f0068008  psq_st     f0, 8(r6), W=1, I=0
8046b6b0: c0410014  lfs        f2, 0x14(r1)
8046b6b4: c0210018  lfs        f1, 0x18(r1)
8046b6b8: c001001c  lfs        f0, 0x1c(r1)
8046b6bc: d0410098  stfs       f2, 0x98(r1)
8046b6c0: d021009c  stfs       f1, 0x9c(r1)
8046b6c4: d00100a0  stfs       f0, 0xa0(r1)
8046b6c8: 4bed2c71  bl         0x8033e338
8046b6cc: 396100d0  addi       r11, r1, 0xd0
8046b6d0: e3e100f8  psq_l      f31, 248(r1), W=0, I=0
8046b6d4: cbe100f0  lfd        f31, 0xf0(r1)
8046b6d8: e3c100e8  psq_l      f30, 232(r1), W=0, I=0
8046b6dc: cbc100e0  lfd        f30, 0xe0(r1)
8046b6e0: e3a100d8  psq_l      f29, 216(r1), W=0, I=0
8046b6e4: cba100d0  lfd        f29, 0xd0(r1)
8046b6e8: 4bb9c1c1  bl         0x800078a8
8046b6ec: 80010104  lwz        r0, 0x104(r1)
8046b6f0: 7c0803a6  mtlr       r0
8046b6f4: 38210100  addi       r1, r1, 0x100
8046b6f8: 4e800020  blr        
8046b6fc: 80830104  lwz        r4, 0x104(r3)
8046b700: 48001978  b          0x8046d078
8046b704: 7c641b78  mr         r4, r3
8046b708: 80630104  lwz        r3, 0x104(r3)
8046b70c: 4800196c  b          0x8046d078
8046b710: 8003017c  lwz        r0, 0x17c(r3)
8046b714: 2c000002  cmpwi      r0, 2
8046b718: 4c810020  blelr      
8046b71c: 80830178  lwz        r4, 0x178(r3)
8046b720: 38000000  li         r0, 0
8046b724: 9003017c  stw        r0, 0x17c(r3)
8046b728: 38040001  addi       r0, r4, 1
8046b72c: 2c00270f  cmpwi      r0, 0x270f
8046b730: 90030178  stw        r0, 0x178(r3)
8046b734: 4081000c  ble        0x8046b740
8046b738: 3800270f  li         r0, 0x270f
8046b73c: 90030178  stw        r0, 0x178(r3)
8046b740: 80030188  lwz        r0, 0x188(r3)
8046b744: 540007bd  rlwinm.    r0, r0, 0, 0x1e, 0x1e
8046b748: 41820014  beq        0x8046b75c
8046b74c: 80030250  lwz        r0, 0x250(r3)
8046b750: 60000020  ori        r0, r0, 0x20
8046b754: 90030250  stw        r0, 0x250(r3)
8046b758: 4e800020  blr        
8046b75c: 80030250  lwz        r0, 0x250(r3)
8046b760: 540006f2  rlwinm     r0, r0, 0, 0x1b, 0x19
8046b764: 90030250  stw        r0, 0x250(r3)
8046b768: 4e800020  blr        
8046b76c: c0621034  lfs        f3, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046b770: c0040000  lfs        f0, 0(r4)
8046b774: fc030000  fcmpu      cr0, f3, f0
8046b778: 4c820020  bnelr      
8046b77c: fc000850  fneg       f0, f1
8046b780: c0640008  lfs        f3, 8(r4)
8046b784: fc001840  fcmpo      cr0, f0, f3
8046b788: 4c800020  bgelr      
8046b78c: fc030840  fcmpo      cr0, f3, f1
8046b790: 4c800020  bgelr      
8046b794: c002d314  lfs        f0, -0x2cec(r2) ; [806fb394] 358637bd f32=9.99999997e-07
8046b798: fc030040  fcmpo      cr0, f3, f0
8046b79c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046b7a0: 4082000c  bne        0x8046b7ac
8046b7a4: d0440008  stfs       f2, 8(r4)
8046b7a8: 48000080  b          0x8046b828
8046b7ac: fc000050  fneg       f0, f0
8046b7b0: fc030040  fcmpo      cr0, f3, f0
8046b7b4: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046b7b8: 40820010  bne        0x8046b7c8
8046b7bc: fc001050  fneg       f0, f2
8046b7c0: d0040008  stfs       f0, 8(r4)
8046b7c4: 48000064  b          0x8046b828
8046b7c8: 3c6041c6  lis        r3, 0x41c6
8046b7cc: 80cdcff0  lwz        r6, -0x3010(r13)
8046b7d0: 38034e6d  addi       r0, r3, 0x4e6d
8046b7d4: 38adcff0  addi       r5, r13, -0x3010
8046b7d8: 7cc601d6  mullw      r6, r6, r0
8046b7dc: 80650004  lwz        r3, 4(r5)
8046b7e0: 546007ff  clrlwi.    r0, r3, 0x1f
8046b7e4: 38063039  addi       r0, r6, 0x3039
8046b7e8: 900dcff0  stw        r0, -0x3010(r13)
8046b7ec: 41820010  beq        0x8046b7fc
8046b7f0: 6c600001  xoris      r0, r3, 1
8046b7f4: 68001020  xori       r0, r0, 0x1020
8046b7f8: 90050004  stw        r0, 4(r5)
8046b7fc: 38adcff0  addi       r5, r13, -0x3010
8046b800: 800dcff0  lwz        r0, -0x3010(r13)
8046b804: 80650004  lwz        r3, 4(r5)
8046b808: 5463f87e  srwi       r3, r3, 1
8046b80c: 90650004  stw        r3, 4(r5)
8046b810: 7c001a78  xor        r0, r0, r3
8046b814: 5400ffff  rlwinm.    r0, r0, 0x1f, 0x1f, 0x1f
8046b818: 41820008  beq        0x8046b820
8046b81c: 48000008  b          0x8046b824
8046b820: fc401050  fneg       f2, f2
8046b824: d0440008  stfs       f2, 8(r4)
8046b828: 7c832378  mr         r3, r4
8046b82c: 4bbd3f34  b          0x8003f760
8046b830: 4e800020  blr        
8046b834: 9421fea0  stwu       r1, -0x160(r1)
8046b838: 7c0802a6  mflr       r0
8046b83c: 90010164  stw        r0, 0x164(r1)
8046b840: 39610140  addi       r11, r1, 0x140
8046b844: dbe10150  stfd       f31, 0x150(r1)
8046b848: f3e10158  psq_st     f31, 344(r1), W=0, I=0
8046b84c: dbc10140  stfd       f30, 0x140(r1)
8046b850: f3c10148  psq_st     f30, 328(r1), W=0, I=0
8046b854: 4bb9c001  bl         0x80007854
8046b858: 80030178  lwz        r0, 0x178(r3)
8046b85c: 7c7b1b78  mr         r27, r3
8046b860: 80a3017c  lwz        r5, 0x17c(r3)
8046b864: 2c000001  cmpwi      r0, 1
8046b868: 80830180  lwz        r4, 0x180(r3)
8046b86c: 38050001  addi       r0, r5, 1
8046b870: 9003017c  stw        r0, 0x17c(r3)
8046b874: 38040001  addi       r0, r4, 1
8046b878: 90030180  stw        r0, 0x180(r3)
8046b87c: 41800010  blt        0x8046b88c
8046b880: 80830184  lwz        r4, 0x184(r3)
8046b884: 38040001  addi       r0, r4, 1
8046b888: 90030184  stw        r0, 0x184(r3)
8046b88c: c023021c  lfs        f1, 0x21c(r3)
8046b890: c0030220  lfs        f0, 0x220(r3)
8046b894: c0c30008  lfs        f6, 8(r3)
8046b898: efe10032  fmuls      f31, f1, f0
8046b89c: c0a3000c  lfs        f5, 0xc(r3)
8046b8a0: c0830010  lfs        f4, 0x10(r3)
8046b8a4: c0630014  lfs        f3, 0x14(r3)
8046b8a8: c0430018  lfs        f2, 0x18(r3)
8046b8ac: c003001c  lfs        f0, 0x1c(r3)
8046b8b0: d0c301a0  stfs       f6, 0x1a0(r3)
8046b8b4: c0221088  lfs        f1, 0x1088(r2) ; [806ff108] 3f7fa440 f32=0.998600006
8046b8b8: d0a301a4  stfs       f5, 0x1a4(r3)
8046b8bc: d08301a8  stfs       f4, 0x1a8(r3)
8046b8c0: d06301ac  stfs       f3, 0x1ac(r3)
8046b8c4: d04301b0  stfs       f2, 0x1b0(r3)
8046b8c8: d00301b4  stfs       f0, 0x1b4(r3)
8046b8cc: 4bcd00e5  bl         0x8013b9b0
8046b8d0: ec3f0072  fmuls      f1, f31, f1
8046b8d4: 4bcd003d  bl         0x8013b910
8046b8d8: e05b0014  psq_l      f2, 20(r27), W=0, I=0
8046b8dc: 10020058  ps_muls0   f0, f2, f1
8046b8e0: e05b801c  psq_l      f2, 28(r27), W=1, I=0
8046b8e4: f01b0014  psq_st     f0, 20(r27), W=0, I=0
8046b8e8: 10020058  ps_muls0   f0, f2, f1
8046b8ec: c0221088  lfs        f1, 0x1088(r2) ; [806ff108] 3f7fa440 f32=0.998600006
8046b8f0: f01b801c  psq_st     f0, 28(r27), W=1, I=0
8046b8f4: 4bcd00bd  bl         0x8013b9b0
8046b8f8: ec3f0072  fmuls      f1, f31, f1
8046b8fc: 4bcd0015  bl         0x8013b910
8046b900: 387b0044  addi       r3, r27, 0x44
8046b904: c042108c  lfs        f2, 0x108c(r2) ; [806ff10c] bb10f404 f32=-0.00221181009
8046b908: e0830000  psq_l      f4, 0(r3), W=0, I=0
8046b90c: 389b0014  addi       r4, r27, 0x14
8046b910: c01b0018  lfs        f0, 0x18(r27)
8046b914: 38a1005c  addi       r5, r1, 0x5c
8046b918: 10640058  ps_muls0   f3, f4, f1
8046b91c: e0838008  psq_l      f4, 8(r3), W=1, I=0
8046b920: ec0207fa  fmadds     f0, f2, f31, f0
8046b924: f0630000  psq_st     f3, 0(r3), W=0, I=0
8046b928: 10640058  ps_muls0   f3, f4, f1
8046b92c: f0638008  psq_st     f3, 8(r3), W=1, I=0
8046b930: d01b0018  stfs       f0, 0x18(r27)
8046b934: 4bbd3eed  bl         0x8003f820
8046b938: 3881005c  addi       r4, r1, 0x5c
8046b93c: c0021040  lfs        f0, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046b940: e0240000  psq_l      f1, 0(r4), W=0, I=0
8046b944: 38610020  addi       r3, r1, 0x20
8046b948: c0621090  lfs        f3, 0x1090(r2) ; [806ff110] 38d1b717 f32=9.99999975e-05
8046b94c: 38a1002c  addi       r5, r1, 0x2c
8046b950: 10410018  ps_muls0   f2, f1, f0
8046b954: e0248008  psq_l      f1, 8(r4), W=1, I=0
8046b958: 38810038  addi       r4, r1, 0x38
8046b95c: e09b0014  psq_l      f4, 20(r27), W=0, I=0
8046b960: f0430000  psq_st     f2, 0(r3), W=0, I=0
8046b964: 10410018  ps_muls0   f2, f1, f0
8046b968: e0030000  psq_l      f0, 0(r3), W=0, I=0
8046b96c: fc20f890  fmr        f1, f31
8046b970: f0438008  psq_st     f2, 8(r3), W=1, I=0
8046b974: 7f63db78  mr         r3, r27
8046b978: 100000d8  ps_muls0   f0, f0, f3
8046b97c: f0050000  psq_st     f0, 0(r5), W=0, I=0
8046b980: 100200d8  ps_muls0   f0, f2, f3
8046b984: e0450000  psq_l      f2, 0(r5), W=0, I=0
8046b988: f0058008  psq_st     f0, 8(r5), W=1, I=0
8046b98c: 104207d8  ps_muls0   f2, f2, f31
8046b990: f0440000  psq_st     f2, 0(r4), W=0, I=0
8046b994: 104007d8  ps_muls0   f2, f0, f31
8046b998: e0040000  psq_l      f0, 0(r4), W=0, I=0
8046b99c: f0448008  psq_st     f2, 8(r4), W=1, I=0
8046b9a0: 1004002a  ps_add     f0, f4, f0
8046b9a4: e09b801c  psq_l      f4, 28(r27), W=1, I=0
8046b9a8: f01b0014  psq_st     f0, 20(r27), W=0, I=0
8046b9ac: 1004102a  ps_add     f0, f4, f2
8046b9b0: f01b801c  psq_st     f0, 28(r27), W=1, I=0
8046b9b4: 4bed2e8d  bl         0x8033e840
8046b9b8: 7f63db78  mr         r3, r27
8046b9bc: 4bed2d8d  bl         0x8033e748
8046b9c0: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046b9c4: 3ba00000  li         r29, 0
8046b9c8: d00100a0  stfs       f0, 0xa0(r1)
8046b9cc: 3f80807d  lis        r28, -0x7f83
8046b9d0: 386100b8  addi       r3, r1, 0xb8
8046b9d4: d00100a4  stfs       f0, 0xa4(r1)
8046b9d8: 389c0318  addi       r4, r28, 0x318
8046b9dc: d00100a8  stfs       f0, 0xa8(r1)
8046b9e0: d00100ac  stfs       f0, 0xac(r1)
8046b9e4: 93a100b0  stw        r29, 0xb0(r1)
8046b9e8: 93bb0188  stw        r29, 0x188(r27)
8046b9ec: 4bd9877d  bl         0x80204168
8046b9f0: 3f40807d  lis        r26, -0x7f83
8046b9f4: 386100c4  addi       r3, r1, 0xc4
8046b9f8: 389a0354  addi       r4, r26, 0x354
8046b9fc: 4be1be91  bl         0x8028788c
8046ba00: 386100e8  addi       r3, r1, 0xe8
8046ba04: 389c0318  addi       r4, r28, 0x318
8046ba08: 4bd98761  bl         0x80204168
8046ba0c: 386100f4  addi       r3, r1, 0xf4
8046ba10: 389a0354  addi       r4, r26, 0x354
8046ba14: 4be1be79  bl         0x8028788c
8046ba18: c00d9fd4  lfs        f0, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046ba1c: 7f64db78  mr         r4, r27
8046ba20: 93a10118  stw        r29, 0x118(r1)
8046ba24: 38a10080  addi       r5, r1, 0x80
8046ba28: 806dd678  lwz        r3, -0x2988(r13)
8046ba2c: d001011c  stfs       f0, 0x11c(r1)
8046ba30: c01b0008  lfs        f0, 8(r27)
8046ba34: d00100b8  stfs       f0, 0xb8(r1)
8046ba38: c01b000c  lfs        f0, 0xc(r27)
8046ba3c: d00100bc  stfs       f0, 0xbc(r1)
8046ba40: c01b0010  lfs        f0, 0x10(r27)
8046ba44: d00100c0  stfs       f0, 0xc0(r1)
8046ba48: 80630164  lwz        r3, 0x164(r3)
8046ba4c: 4bfee711  bl         0x8045a15c
8046ba50: 2c030000  cmpwi      r3, 0
8046ba54: 418200cc  beq        0x8046bb20
8046ba58: c021008c  lfs        f1, 0x8c(r1)
8046ba5c: 7f63db78  mr         r3, r27
8046ba60: c0421094  lfs        f2, 0x1094(r2) ; [806ff114] 3f51eb85 f32=0.819999993
8046ba64: 38810090  addi       r4, r1, 0x90
8046ba68: c0621098  lfs        f3, 0x1098(r2) ; [806ff118] 3e4ccccd f32=0.200000003
8046ba6c: 38a10080  addi       r5, r1, 0x80
8046ba70: 38c00001  li         r6, 1
8046ba74: 4bfff7bd  bl         0x8046b230
8046ba78: c0210084  lfs        f1, 0x84(r1)
8046ba7c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ba80: fc010040  fcmpo      cr0, f1, f0
8046ba84: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046ba88: 40820014  bne        0x8046ba9c
8046ba8c: 801b0188  lwz        r0, 0x188(r27)
8046ba90: 60000004  ori        r0, r0, 4
8046ba94: 901b0188  stw        r0, 0x188(r27)
8046ba98: 48000030  b          0x8046bac8
8046ba9c: c002d318  lfs        f0, -0x2ce8(r2) ; [806fb398] 3f7fffef f32=0.999998987
8046baa0: fc010040  fcmpo      cr0, f1, f0
8046baa4: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046baa8: 40820014  bne        0x8046babc
8046baac: 801b0188  lwz        r0, 0x188(r27)
8046bab0: 60000002  ori        r0, r0, 2
8046bab4: 901b0188  stw        r0, 0x188(r27)
8046bab8: 48000010  b          0x8046bac8
8046babc: 801b0188  lwz        r0, 0x188(r27)
8046bac0: 60000001  ori        r0, r0, 1
8046bac4: 901b0188  stw        r0, 0x188(r27)
8046bac8: c02100a0  lfs        f1, 0xa0(r1)
8046bacc: 38610080  addi       r3, r1, 0x80
8046bad0: c0010080  lfs        f0, 0x80(r1)
8046bad4: c06100a4  lfs        f3, 0xa4(r1)
8046bad8: ec81002a  fadds      f4, f1, f0
8046badc: c0410084  lfs        f2, 0x84(r1)
8046bae0: c02100a8  lfs        f1, 0xa8(r1)
8046bae4: c0010088  lfs        f0, 0x88(r1)
8046bae8: ec43102a  fadds      f2, f3, f2
8046baec: d08100a0  stfs       f4, 0xa0(r1)
8046baf0: ec01002a  fadds      f0, f1, f0
8046baf4: d04100a4  stfs       f2, 0xa4(r1)
8046baf8: d00100a8  stfs       f0, 0xa8(r1)
8046bafc: 4bd994f1  bl         0x80204fec
8046bb00: c00100ac  lfs        f0, 0xac(r1)
8046bb04: 7f63db78  mr         r3, r27
8046bb08: 808100b0  lwz        r4, 0xb0(r1)
8046bb0c: ec00082a  fadds      f0, f0, f1
8046bb10: 38040001  addi       r0, r4, 1
8046bb14: 900100b0  stw        r0, 0xb0(r1)
8046bb18: d00100ac  stfs       f0, 0xac(r1)
8046bb1c: 4bfffbf5  bl         0x8046b710
8046bb20: 38000000  li         r0, 0
8046bb24: b01b0190  sth        r0, 0x190(r27)
8046bb28: 389b0008  addi       r4, r27, 8
8046bb2c: 806dd678  lwz        r3, -0x2988(r13)
8046bb30: 80630164  lwz        r3, 0x164(r3)
8046bb34: 83830028  lwz        r28, 0x28(r3)
8046bb38: 7f83e378  mr         r3, r28
8046bb3c: 4bedb769  bl         0x803472a4
8046bb40: 2c030000  cmpwi      r3, 0
8046bb44: 41820140  beq        0x8046bc84
8046bb48: 3f408068  lis        r26, -0x7f98
8046bb4c: 3bc10068  addi       r30, r1, 0x68
8046bb50: 3be10014  addi       r31, r1, 0x14
8046bb54: 3ba10050  addi       r29, r1, 0x50
8046bb58: 3b5af300  addi       r26, r26, -0xd00
8046bb5c: 48000118  b          0x8046bc74
8046bb60: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046bb64: 389b0008  addi       r4, r27, 8
8046bb68: 38a10068  addi       r5, r1, 0x68
8046bb6c: 4bedba55  bl         0x803475c0
8046bb70: 2c030000  cmpwi      r3, 0
8046bb74: 41820100  beq        0x8046bc74
8046bb78: 801b0188  lwz        r0, 0x188(r27)
8046bb7c: 38610068  addi       r3, r1, 0x68
8046bb80: 60000010  ori        r0, r0, 0x10
8046bb84: 901b0188  stw        r0, 0x188(r27)
8046bb88: c02100a0  lfs        f1, 0xa0(r1)
8046bb8c: c0010068  lfs        f0, 0x68(r1)
8046bb90: c06100a4  lfs        f3, 0xa4(r1)
8046bb94: ec81002a  fadds      f4, f1, f0
8046bb98: c041006c  lfs        f2, 0x6c(r1)
8046bb9c: c02100a8  lfs        f1, 0xa8(r1)
8046bba0: c0010070  lfs        f0, 0x70(r1)
8046bba4: ec43102a  fadds      f2, f3, f2
8046bba8: d08100a0  stfs       f4, 0xa0(r1)
8046bbac: ec01002a  fadds      f0, f1, f0
8046bbb0: d04100a4  stfs       f2, 0xa4(r1)
8046bbb4: d00100a8  stfs       f0, 0xa8(r1)
8046bbb8: 4bd99435  bl         0x80204fec
8046bbbc: c00100ac  lfs        f0, 0xac(r1)
8046bbc0: a0010078  lhz        r0, 0x78(r1)
8046bbc4: 806100b0  lwz        r3, 0xb0(r1)
8046bbc8: ec00082a  fadds      f0, f0, f1
8046bbcc: 54000efc  rlwinm     r0, r0, 1, 0x1b, 0x1e
8046bbd0: 38830001  addi       r4, r3, 1
8046bbd4: 7c7a022e  lhzx       r3, r26, r0
8046bbd8: d00100ac  stfs       f0, 0xac(r1)
8046bbdc: 5460077b  rlwinm.    r0, r3, 0, 0x1d, 0x1d
8046bbe0: 908100b0  stw        r4, 0xb0(r1)
8046bbe4: a01b0190  lhz        r0, 0x190(r27)
8046bbe8: 7c001b78  or         r0, r0, r3
8046bbec: b01b0190  sth        r0, 0x190(r27)
8046bbf0: 40820084  bne        0x8046bc74
8046bbf4: 546007ff  clrlwi.    r0, r3, 0x1f
8046bbf8: 41820010  beq        0x8046bc08
8046bbfc: c042109c  lfs        f2, 0x109c(r2) ; [806ff11c] 3f266666 f32=0.649999976
8046bc00: c0621064  lfs        f3, 0x1064(r2) ; [806ff0e4] 3dcccccd f32=0.100000001
8046bc04: 48000020  b          0x8046bc24
8046bc08: 546007bd  rlwinm.    r0, r3, 0, 0x1e, 0x1e
8046bc0c: 41820010  beq        0x8046bc1c
8046bc10: c04210a0  lfs        f2, 0x10a0(r2) ; [806ff120] 3f733333 f32=0.949999988
8046bc14: c06210a4  lfs        f3, 0x10a4(r2) ; [806ff124] 3e99999a f32=0.300000012
8046bc18: 4800000c  b          0x8046bc24
8046bc1c: c04d9ff4  lfs        f2, -0x600c(r13) ; [806f2114] 3ecccccd f32=0.400000006
8046bc20: c06d9ff8  lfs        f3, -0x6008(r13) ; [806f2118] 3dcccccd f32=0.100000001
8046bc24: c00d9fd4  lfs        f0, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046bc28: 7f63db78  mr         r3, r27
8046bc2c: e03e0000  psq_l      f1, 0(r30), W=0, I=0
8046bc30: 7fa4eb78  mr         r4, r29
8046bc34: e0bb0008  psq_l      f5, 8(r27), W=0, I=0
8046bc38: 7fc5f378  mr         r5, r30
8046bc3c: 10810018  ps_muls0   f4, f1, f0
8046bc40: e03e8008  psq_l      f1, 8(r30), W=1, I=0
8046bc44: 38c00000  li         r6, 0
8046bc48: f09f0000  psq_st     f4, 0(r31), W=0, I=0
8046bc4c: 10810018  ps_muls0   f4, f1, f0
8046bc50: c0210074  lfs        f1, 0x74(r1)
8046bc54: e01f0000  psq_l      f0, 0(r31), W=0, I=0
8046bc58: f09f8008  psq_st     f4, 8(r31), W=1, I=0
8046bc5c: 10050028  ps_sub     f0, f5, f0
8046bc60: f01d0000  psq_st     f0, 0(r29), W=0, I=0
8046bc64: e0bb8010  psq_l      f5, 16(r27), W=1, I=0
8046bc68: 10052028  ps_sub     f0, f5, f4
8046bc6c: f01d8008  psq_st     f0, 8(r29), W=1, I=0
8046bc70: 4bfff5c1  bl         0x8046b230
8046bc74: 7f83e378  mr         r3, r28
8046bc78: 4bedb591  bl         0x80347208
8046bc7c: 2c030000  cmpwi      r3, 0
8046bc80: 4082fee0  bne        0x8046bb60
8046bc84: 806dd678  lwz        r3, -0x2988(r13)
8046bc88: 389b0008  addi       r4, r27, 8
8046bc8c: 80630164  lwz        r3, 0x164(r3)
8046bc90: 8383002c  lwz        r28, 0x2c(r3)
8046bc94: 7f83e378  mr         r3, r28
8046bc98: 4bedb60d  bl         0x803472a4
8046bc9c: 2c030000  cmpwi      r3, 0
8046bca0: 41820184  beq        0x8046be24
8046bca4: 3f408068  lis        r26, -0x7f98
8046bca8: c3e21034  lfs        f31, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046bcac: 3bc10068  addi       r30, r1, 0x68
8046bcb0: 3ba10008  addi       r29, r1, 8
8046bcb4: 3be10044  addi       r31, r1, 0x44
8046bcb8: 3b5af320  addi       r26, r26, -0xce0
8046bcbc: 48000158  b          0x8046be14
8046bcc0: c02d9fd4  lfs        f1, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046bcc4: 389b0008  addi       r4, r27, 8
8046bcc8: 38a10068  addi       r5, r1, 0x68
8046bccc: 4bedb8f5  bl         0x803475c0
8046bcd0: 2c030000  cmpwi      r3, 0
8046bcd4: 41820140  beq        0x8046be14
8046bcd8: a0010078  lhz        r0, 0x78(r1)
8046bcdc: a07b0190  lhz        r3, 0x190(r27)
8046bce0: 54000efc  rlwinm     r0, r0, 1, 0x1b, 0x1e
8046bce4: 7c9a022e  lhzx       r4, r26, r0
8046bce8: 548006b5  rlwinm.    r0, r4, 0, 0x1a, 0x1a
8046bcec: 7c602378  or         r0, r3, r4
8046bcf0: b01b0190  sth        r0, 0x190(r27)
8046bcf4: 40820120  bne        0x8046be14
8046bcf8: c00d9fd4  lfs        f0, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046bcfc: e03e0000  psq_l      f1, 0(r30), W=0, I=0
8046bd00: e09b0008  psq_l      f4, 8(r27), W=0, I=0
8046bd04: 10610018  ps_muls0   f3, f1, f0
8046bd08: e03e8008  psq_l      f1, 8(r30), W=1, I=0
8046bd0c: c041006c  lfs        f2, 0x6c(r1)
8046bd10: f07d0000  psq_st     f3, 0(r29), W=0, I=0
8046bd14: 10610018  ps_muls0   f3, f1, f0
8046bd18: c0210074  lfs        f1, 0x74(r1)
8046bd1c: e01d0000  psq_l      f0, 0(r29), W=0, I=0
8046bd20: f07d8008  psq_st     f3, 8(r29), W=1, I=0
8046bd24: 10840028  ps_sub     f4, f4, f0
8046bd28: f09f0000  psq_st     f4, 0(r31), W=0, I=0
8046bd2c: c0010048  lfs        f0, 0x48(r1)
8046bd30: e09b8010  psq_l      f4, 16(r27), W=1, I=0
8046bd34: ec02007a  fmadds     f0, f2, f1, f0
8046bd38: 10841828  ps_sub     f4, f4, f3
8046bd3c: fc00f840  fcmpo      cr0, f0, f31
8046bd40: f09f8008  psq_st     f4, 8(r31), W=1, I=0
8046bd44: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046bd48: 40820014  bne        0x8046bd5c
8046bd4c: 801b0188  lwz        r0, 0x188(r27)
8046bd50: 60000020  ori        r0, r0, 0x20
8046bd54: 901b0188  stw        r0, 0x188(r27)
8046bd58: 48000010  b          0x8046bd68
8046bd5c: 801b0188  lwz        r0, 0x188(r27)
8046bd60: 60000010  ori        r0, r0, 0x10
8046bd64: 901b0188  stw        r0, 0x188(r27)
8046bd68: e05b0014  psq_l      f2, 20(r27), W=0, I=0
8046bd6c: c00d9fe4  lfs        f0, -0x601c(r13) ; [806f2104] 3ba3d70a f32=0.00499999989
8046bd70: 104200b2  ps_mul     f2, f2, f2
8046bd74: c03b001c  lfs        f1, 0x1c(r27)
8046bd78: ec000032  fmuls      f0, f0, f0
8046bd7c: 1021107a  ps_madd    f1, f1, f1, f2
8046bd80: 10211094  ps_sum0    f1, f1, f2, f2
8046bd84: fc010040  fcmpo      cr0, f1, f0
8046bd88: 4c401382  cror       cr0eq, cr0lt, cr0eq
8046bd8c: 40820018  bne        0x8046bda4
8046bd90: c02d9fdc  lfs        f1, -0x6024(r13) ; [806f20fc] 3ca3d70a f32=0.0199999996
8046bd94: 7f63db78  mr         r3, r27
8046bd98: c04d9fe0  lfs        f2, -0x6020(r13) ; [806f2100] 3f800000 f32=1
8046bd9c: 38810068  addi       r4, r1, 0x68
8046bda0: 4bfff9cd  bl         0x8046b76c
8046bda4: c0210074  lfs        f1, 0x74(r1)
8046bda8: 7f63db78  mr         r3, r27
8046bdac: c04210a0  lfs        f2, 0x10a0(r2) ; [806ff120] 3f733333 f32=0.949999988
8046bdb0: 38810044  addi       r4, r1, 0x44
8046bdb4: c06210a4  lfs        f3, 0x10a4(r2) ; [806ff124] 3e99999a f32=0.300000012
8046bdb8: 38a10068  addi       r5, r1, 0x68
8046bdbc: 38c00000  li         r6, 0
8046bdc0: 4bfff471  bl         0x8046b230
8046bdc4: c02100a0  lfs        f1, 0xa0(r1)
8046bdc8: 38610068  addi       r3, r1, 0x68
8046bdcc: c0010068  lfs        f0, 0x68(r1)
8046bdd0: c06100a4  lfs        f3, 0xa4(r1)
8046bdd4: ec81002a  fadds      f4, f1, f0
8046bdd8: c041006c  lfs        f2, 0x6c(r1)
8046bddc: c02100a8  lfs        f1, 0xa8(r1)
8046bde0: c0010070  lfs        f0, 0x70(r1)
8046bde4: ec43102a  fadds      f2, f3, f2
8046bde8: d08100a0  stfs       f4, 0xa0(r1)
8046bdec: ec01002a  fadds      f0, f1, f0
8046bdf0: d04100a4  stfs       f2, 0xa4(r1)
8046bdf4: d00100a8  stfs       f0, 0xa8(r1)
8046bdf8: 4bd991f5  bl         0x80204fec
8046bdfc: c00100ac  lfs        f0, 0xac(r1)
8046be00: 806100b0  lwz        r3, 0xb0(r1)
8046be04: ec00082a  fadds      f0, f0, f1
8046be08: 38030001  addi       r0, r3, 1
8046be0c: 900100b0  stw        r0, 0xb0(r1)
8046be10: d00100ac  stfs       f0, 0xac(r1)
8046be14: 7f83e378  mr         r3, r28
8046be18: 4bedb3f1  bl         0x80347208
8046be1c: 2c030000  cmpwi      r3, 0
8046be20: 4082fea0  bne        0x8046bcc0
8046be24: 801b0188  lwz        r0, 0x188(r27)
8046be28: 540006f7  rlwinm.    r0, r0, 0, 0x1b, 0x1b
8046be2c: 4182000c  beq        0x8046be38
8046be30: 7f63db78  mr         r3, r27
8046be34: 4bfff8dd  bl         0x8046b710
8046be38: 806dd678  lwz        r3, -0x2988(r13)
8046be3c: 7f64db78  mr         r4, r27
8046be40: 38a10080  addi       r5, r1, 0x80
8046be44: 80630164  lwz        r3, 0x164(r3)
8046be48: 4bfedba9  bl         0x804599f0
8046be4c: 2c030000  cmpwi      r3, 0
8046be50: 418200b8  beq        0x8046bf08
8046be54: c0210084  lfs        f1, 0x84(r1)
8046be58: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046be5c: fc010040  fcmpo      cr0, f1, f0
8046be60: 40810010  ble        0x8046be70
8046be64: c3e21098  lfs        f31, 0x1098(r2) ; [806ff118] 3e4ccccd f32=0.200000003
8046be68: ffc0f890  fmr        f30, f31
8046be6c: 4800000c  b          0x8046be78
8046be70: c3e21064  lfs        f31, 0x1064(r2) ; [806ff0e4] 3dcccccd f32=0.100000001
8046be74: c3c21098  lfs        f30, 0x1098(r2) ; [806ff118] 3e4ccccd f32=0.200000003
8046be78: c02d9fdc  lfs        f1, -0x6024(r13) ; [806f20fc] 3ca3d70a f32=0.0199999996
8046be7c: 7f63db78  mr         r3, r27
8046be80: 38810080  addi       r4, r1, 0x80
8046be84: fc400890  fmr        f2, f1
8046be88: 4bfff8e5  bl         0x8046b76c
8046be8c: fc40f890  fmr        f2, f31
8046be90: c021008c  lfs        f1, 0x8c(r1)
8046be94: fc60f090  fmr        f3, f30
8046be98: 7f63db78  mr         r3, r27
8046be9c: 38810090  addi       r4, r1, 0x90
8046bea0: 38a10080  addi       r5, r1, 0x80
8046bea4: 38c00000  li         r6, 0
8046bea8: 4bfff389  bl         0x8046b230
8046beac: 801b0188  lwz        r0, 0x188(r27)
8046beb0: 38610080  addi       r3, r1, 0x80
8046beb4: 60000008  ori        r0, r0, 8
8046beb8: 901b0188  stw        r0, 0x188(r27)
8046bebc: c02100a0  lfs        f1, 0xa0(r1)
8046bec0: c0010080  lfs        f0, 0x80(r1)
8046bec4: c06100a4  lfs        f3, 0xa4(r1)
8046bec8: ec81002a  fadds      f4, f1, f0
8046becc: c0410084  lfs        f2, 0x84(r1)
8046bed0: c02100a8  lfs        f1, 0xa8(r1)
8046bed4: c0010088  lfs        f0, 0x88(r1)
8046bed8: ec43102a  fadds      f2, f3, f2
8046bedc: d08100a0  stfs       f4, 0xa0(r1)
8046bee0: ec01002a  fadds      f0, f1, f0
8046bee4: d04100a4  stfs       f2, 0xa4(r1)
8046bee8: d00100a8  stfs       f0, 0xa8(r1)
8046beec: 4bd99101  bl         0x80204fec
8046bef0: c00100ac  lfs        f0, 0xac(r1)
8046bef4: 806100b0  lwz        r3, 0xb0(r1)
8046bef8: ec00082a  fadds      f0, f0, f1
8046befc: 38030001  addi       r0, r3, 1
8046bf00: 900100b0  stw        r0, 0xb0(r1)
8046bf04: d00100ac  stfs       f0, 0xac(r1)
8046bf08: 7f63db78  mr         r3, r27
8046bf0c: 4bed25f5  bl         0x8033e500
8046bf10: 80bb0188  lwz        r5, 0x188(r27)
8046bf14: 3c80807d  lis        r4, -0x7f83
8046bf18: 801b018c  lwz        r0, 0x18c(r27)
8046bf1c: 38640318  addi       r3, r4, 0x318
8046bf20: 7ca00378  or         r0, r5, r0
8046bf24: 901b018c  stw        r0, 0x18c(r27)
8046bf28: c0040318  lfs        f0, 0x318(r4)
8046bf2c: d01b0228  stfs       f0, 0x228(r27)
8046bf30: c0030004  lfs        f0, 4(r3)
8046bf34: d01b022c  stfs       f0, 0x22c(r27)
8046bf38: c0030008  lfs        f0, 8(r3)
8046bf3c: d01b0230  stfs       f0, 0x230(r27)
8046bf40: 800100b0  lwz        r0, 0xb0(r1)
8046bf44: 2c000000  cmpwi      r0, 0
8046bf48: 41820074  beq        0x8046bfbc
8046bf4c: 386100a0  addi       r3, r1, 0xa0
8046bf50: 4bd9909d  bl         0x80204fec
8046bf54: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046bf58: fc000800  fcmpu      cr0, f0, f1
8046bf5c: 41820060  beq        0x8046bfbc
8046bf60: 806100b0  lwz        r3, 0xb0(r1)
8046bf64: 3c004330  lis        r0, 0x4330
8046bf68: 90010120  stw        r0, 0x120(r1)
8046bf6c: 6c608000  xoris      r0, r3, 0x8000
8046bf70: c8421080  lfd        f2, 0x1080(r2) ; [806ff100] 43300000 f32=176
8046bf74: 90010124  stw        r0, 0x124(r1)
8046bf78: c0a100ac  lfs        f5, 0xac(r1)
8046bf7c: c8010120  lfd        f0, 0x120(r1)
8046bf80: c08100a0  lfs        f4, 0xa0(r1)
8046bf84: ecc01028  fsubs      f6, f0, f2
8046bf88: c07b0228  lfs        f3, 0x228(r27)
8046bf8c: c05b022c  lfs        f2, 0x22c(r27)
8046bf90: c01b0230  lfs        f0, 0x230(r27)
8046bf94: ec260072  fmuls      f1, f6, f1
8046bf98: eca50824  fdivs      f5, f5, f1
8046bf9c: ec24197a  fmadds     f1, f4, f5, f3
8046bfa0: d03b0228  stfs       f1, 0x228(r27)
8046bfa4: c02100a4  lfs        f1, 0xa4(r1)
8046bfa8: ec21117a  fmadds     f1, f1, f5, f2
8046bfac: d03b022c  stfs       f1, 0x22c(r27)
8046bfb0: c02100a8  lfs        f1, 0xa8(r1)
8046bfb4: ec01017a  fmadds     f0, f1, f5, f0
8046bfb8: d01b0230  stfs       f0, 0x230(r27)
8046bfbc: 387b0228  addi       r3, r27, 0x228
8046bfc0: 7c641b78  mr         r4, r3
8046bfc4: 4bebc069  bl         0x8032802c
8046bfc8: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046bfcc: fc010000  fcmpu      cr0, f1, f0
8046bfd0: 40820024  bne        0x8046bff4
8046bfd4: 3c60807d  lis        r3, -0x7f83
8046bfd8: c0030330  lfs        f0, 0x330(r3)
8046bfdc: 38630330  addi       r3, r3, 0x330
8046bfe0: d01b0228  stfs       f0, 0x228(r27)
8046bfe4: c0030004  lfs        f0, 4(r3)
8046bfe8: d01b022c  stfs       f0, 0x22c(r27)
8046bfec: c0030008  lfs        f0, 8(r3)
8046bff0: d01b0230  stfs       f0, 0x230(r27)
8046bff4: 801b0194  lwz        r0, 0x194(r27)
8046bff8: 2c000001  cmpwi      r0, 1
8046bffc: 40820018  bne        0x8046c014
8046c000: 801b0188  lwz        r0, 0x188(r27)
8046c004: 540006f7  rlwinm.    r0, r0, 0, 0x1b, 0x1b
8046c008: 4182000c  beq        0x8046c014
8046c00c: 38000002  li         r0, 2
8046c010: 901b0178  stw        r0, 0x178(r27)
8046c014: 39610140  addi       r11, r1, 0x140
8046c018: e3e10158  psq_l      f31, 344(r1), W=0, I=0
8046c01c: cbe10150  lfd        f31, 0x150(r1)
8046c020: e3c10148  psq_l      f30, 328(r1), W=0, I=0
8046c024: cbc10140  lfd        f30, 0x140(r1)
8046c028: 4bb9b879  bl         0x800078a0
8046c02c: 80010164  lwz        r0, 0x164(r1)
8046c030: 7c0803a6  mtlr       r0
8046c034: 38210160  addi       r1, r1, 0x160
8046c038: 4e800020  blr        
8046c03c: 80030194  lwz        r0, 0x194(r3)
8046c040: 2c000000  cmpwi      r0, 0
8046c044: 4d820020  beqlr      
8046c048: 4bfff7ec  b          0x8046b834
8046c04c: 4e800020  blr        
8046c050: 9421fed0  stwu       r1, -0x130(r1)
8046c054: 7c0802a6  mflr       r0
8046c058: 38ada028  addi       r5, r13, -0x5fd8
8046c05c: 90010134  stw        r0, 0x134(r1)
8046c060: 5460103a  slwi       r0, r3, 2
8046c064: 38610008  addi       r3, r1, 8
8046c068: 93e1012c  stw        r31, 0x12c(r1)
8046c06c: 7c9f2378  mr         r31, r4
8046c070: 7c85002e  lwzx       r4, r5, r0
8046c074: 38a00000  li         r5, 0
8046c078: 4bdd2a21  bl         0x8023ea98
8046c07c: 38610008  addi       r3, r1, 8
8046c080: 4bdd289d  bl         0x8023e91c
8046c084: 7fe4fb78  mr         r4, r31
8046c088: 38610008  addi       r3, r1, 8
8046c08c: 4bdd23f1  bl         0x8023e47c
8046c090: 38610008  addi       r3, r1, 8
8046c094: 4bdd21f9  bl         0x8023e28c
8046c098: 38610008  addi       r3, r1, 8
8046c09c: 3880ffff  li         r4, -1
8046c0a0: 4bdd2929  bl         0x8023e9c8
8046c0a4: 80010134  lwz        r0, 0x134(r1)
8046c0a8: 83e1012c  lwz        r31, 0x12c(r1)
8046c0ac: 7c0803a6  mtlr       r0
8046c0b0: 38210130  addi       r1, r1, 0x130
8046c0b4: 4e800020  blr        
8046c0b8: 9421fed0  stwu       r1, -0x130(r1)
8046c0bc: 7c0802a6  mflr       r0
8046c0c0: 3ca0806e  lis        r5, -0x7f92
8046c0c4: 90010134  stw        r0, 0x134(r1)
8046c0c8: 5460103a  slwi       r0, r3, 2
8046c0cc: 38a5a014  addi       r5, r5, -0x5fec
8046c0d0: 38610008  addi       r3, r1, 8
8046c0d4: 93e1012c  stw        r31, 0x12c(r1)
8046c0d8: 7c9f2378  mr         r31, r4
8046c0dc: 7c85002e  lwzx       r4, r5, r0
8046c0e0: 38a00000  li         r5, 0
8046c0e4: 4bdd29b5  bl         0x8023ea98
8046c0e8: 38610008  addi       r3, r1, 8
8046c0ec: 4bdd2831  bl         0x8023e91c
8046c0f0: 7fe4fb78  mr         r4, r31
8046c0f4: 38610008  addi       r3, r1, 8
8046c0f8: 4bdd2385  bl         0x8023e47c
8046c0fc: 38610008  addi       r3, r1, 8
8046c100: 4bdd218d  bl         0x8023e28c
8046c104: 38610008  addi       r3, r1, 8
8046c108: 3880ffff  li         r4, -1
8046c10c: 4bdd28bd  bl         0x8023e9c8
8046c110: 80010134  lwz        r0, 0x134(r1)
8046c114: 83e1012c  lwz        r31, 0x12c(r1)
8046c118: 7c0803a6  mtlr       r0
8046c11c: 38210130  addi       r1, r1, 0x130
8046c120: 4e800020  blr        
8046c124: 9421ff80  stwu       r1, -0x80(r1)
8046c128: 7c0802a6  mflr       r0
8046c12c: 3ca0807d  lis        r5, -0x7f83
8046c130: 90010084  stw        r0, 0x84(r1)
8046c134: 39010008  addi       r8, r1, 8
8046c138: 38c5033c  addi       r6, r5, 0x33c
8046c13c: 93e1007c  stw        r31, 0x7c(r1)
8046c140: 7c9f2378  mr         r31, r4
8046c144: 38810068  addi       r4, r1, 0x68
8046c148: 93c10078  stw        r30, 0x78(r1)
8046c14c: 7c7e1b78  mr         r30, r3
8046c150: 80e30008  lwz        r7, 8(r3)
8046c154: 8003000c  lwz        r0, 0xc(r3)
8046c158: 90010018  stw        r0, 0x18(r1)
8046c15c: c045033c  lfs        f2, 0x33c(r5)
8046c160: 38a10050  addi       r5, r1, 0x50
8046c164: 90e10014  stw        r7, 0x14(r1)
8046c168: 38e10014  addi       r7, r1, 0x14
8046c16c: c0cd9fd4  lfs        f6, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046c170: 80030010  lwz        r0, 0x10(r3)
8046c174: 9001001c  stw        r0, 0x1c(r1)
8046c178: e0a70000  psq_l      f5, 0(r7), W=0, I=0
8046c17c: e0830228  psq_l      f4, 552(r3), W=0, I=0
8046c180: c0260004  lfs        f1, 4(r6)
8046c184: 10640198  ps_muls0   f3, f4, f6
8046c188: e0838230  psq_l      f4, 560(r3), W=1, I=0
8046c18c: c0060008  lfs        f0, 8(r6)
8046c190: f0680000  psq_st     f3, 0(r8), W=0, I=0
8046c194: 10640198  ps_muls0   f3, f4, f6
8046c198: e0880000  psq_l      f4, 0(r8), W=0, I=0
8046c19c: f0688008  psq_st     f3, 8(r8), W=1, I=0
8046c1a0: 10852028  ps_sub     f4, f5, f4
8046c1a4: e0a78008  psq_l      f5, 8(r7), W=1, I=0
8046c1a8: f0870000  psq_st     f4, 0(r7), W=0, I=0
8046c1ac: 10851828  ps_sub     f4, f5, f3
8046c1b0: f0878008  psq_st     f4, 8(r7), W=1, I=0
8046c1b4: c0630228  lfs        f3, 0x228(r3)
8046c1b8: d061005c  stfs       f3, 0x5c(r1)
8046c1bc: c063022c  lfs        f3, 0x22c(r3)
8046c1c0: d0610060  stfs       f3, 0x60(r1)
8046c1c4: c0630230  lfs        f3, 0x230(r3)
8046c1c8: 3861005c  addi       r3, r1, 0x5c
8046c1cc: d0610064  stfs       f3, 0x64(r1)
8046c1d0: d0410068  stfs       f2, 0x68(r1)
8046c1d4: d021006c  stfs       f1, 0x6c(r1)
8046c1d8: d0010070  stfs       f0, 0x70(r1)
8046c1dc: 4bbd3645  bl         0x8003f820
8046c1e0: 38610050  addi       r3, r1, 0x50
8046c1e4: 7c641b78  mr         r4, r3
8046c1e8: 4bebbe45  bl         0x8032802c
8046c1ec: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c1f0: fc010000  fcmpu      cr0, f1, f0
8046c1f4: 40820024  bne        0x8046c218
8046c1f8: 3c80807d  lis        r4, -0x7f83
8046c1fc: 38640324  addi       r3, r4, 0x324
8046c200: c0440324  lfs        f2, 0x324(r4)
8046c204: c0230004  lfs        f1, 4(r3)
8046c208: c0030008  lfs        f0, 8(r3)
8046c20c: d0410050  stfs       f2, 0x50(r1)
8046c210: d0210054  stfs       f1, 0x54(r1)
8046c214: d0010058  stfs       f0, 0x58(r1)
8046c218: 38610050  addi       r3, r1, 0x50
8046c21c: 3881005c  addi       r4, r1, 0x5c
8046c220: 38a10068  addi       r5, r1, 0x68
8046c224: 4bbd35fd  bl         0x8003f820
8046c228: 38610020  addi       r3, r1, 0x20
8046c22c: 38810014  addi       r4, r1, 0x14
8046c230: 38a10050  addi       r5, r1, 0x50
8046c234: 4bebbd2d  bl         0x80327f60
8046c238: 2c1f0000  cmpwi      r31, 0
8046c23c: 4082013c  bne        0x8046c378
8046c240: c03e024c  lfs        f1, 0x24c(r30)
8046c244: c0021098  lfs        f0, 0x1098(r2) ; [806ff118] 3e4ccccd f32=0.200000003
8046c248: fc200a10  fabs       f1, f1
8046c24c: fc010040  fcmpo      cr0, f1, f0
8046c250: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c254: 40820124  bne        0x8046c378
8046c258: c01e0234  lfs        f0, 0x234(r30)
8046c25c: 38610068  addi       r3, r1, 0x68
8046c260: d0010068  stfs       f0, 0x68(r1)
8046c264: 7c641b78  mr         r4, r3
8046c268: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c26c: c03e0238  lfs        f1, 0x238(r30)
8046c270: d021006c  stfs       f1, 0x6c(r1)
8046c274: c03e023c  lfs        f1, 0x23c(r30)
8046c278: d0210070  stfs       f1, 0x70(r1)
8046c27c: d001006c  stfs       f0, 0x6c(r1)
8046c280: 4bebbdad  bl         0x8032802c
8046c284: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c288: fc010000  fcmpu      cr0, f1, f0
8046c28c: 40820024  bne        0x8046c2b0
8046c290: 3c80807d  lis        r4, -0x7f83
8046c294: 3864033c  addi       r3, r4, 0x33c
8046c298: c044033c  lfs        f2, 0x33c(r4)
8046c29c: c0230004  lfs        f1, 4(r3)
8046c2a0: c0030008  lfs        f0, 8(r3)
8046c2a4: d0410068  stfs       f2, 0x68(r1)
8046c2a8: d021006c  stfs       f1, 0x6c(r1)
8046c2ac: d0010070  stfs       f0, 0x70(r1)
8046c2b0: c01e0228  lfs        f0, 0x228(r30)
8046c2b4: 3861005c  addi       r3, r1, 0x5c
8046c2b8: d001005c  stfs       f0, 0x5c(r1)
8046c2bc: 38810068  addi       r4, r1, 0x68
8046c2c0: 38a10050  addi       r5, r1, 0x50
8046c2c4: c01e022c  lfs        f0, 0x22c(r30)
8046c2c8: d0010060  stfs       f0, 0x60(r1)
8046c2cc: c01e0230  lfs        f0, 0x230(r30)
8046c2d0: d0010064  stfs       f0, 0x64(r1)
8046c2d4: 4bbd354d  bl         0x8003f820
8046c2d8: 38610050  addi       r3, r1, 0x50
8046c2dc: 7c641b78  mr         r4, r3
8046c2e0: 4bebbd4d  bl         0x8032802c
8046c2e4: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c2e8: fc010000  fcmpu      cr0, f1, f0
8046c2ec: 40820024  bne        0x8046c310
8046c2f0: 3c80807d  lis        r4, -0x7f83
8046c2f4: 38640324  addi       r3, r4, 0x324
8046c2f8: c0440324  lfs        f2, 0x324(r4)
8046c2fc: c0230004  lfs        f1, 4(r3)
8046c300: c0030008  lfs        f0, 8(r3)
8046c304: d0410050  stfs       f2, 0x50(r1)
8046c308: d0210054  stfs       f1, 0x54(r1)
8046c30c: d0010058  stfs       f0, 0x58(r1)
8046c310: 38610050  addi       r3, r1, 0x50
8046c314: 3881005c  addi       r4, r1, 0x5c
8046c318: 38a10068  addi       r5, r1, 0x68
8046c31c: 4bbd3505  bl         0x8003f820
8046c320: 38610020  addi       r3, r1, 0x20
8046c324: 38810014  addi       r4, r1, 0x14
8046c328: 38a10050  addi       r5, r1, 0x50
8046c32c: 4bebbc35  bl         0x80327f60
8046c330: c03e024c  lfs        f1, 0x24c(r30)
8046c334: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c338: fc010040  fcmpo      cr0, f1, f0
8046c33c: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c340: 4082000c  bne        0x8046c34c
8046c344: 3be00000  li         r31, 0
8046c348: 48000008  b          0x8046c350
8046c34c: 3be00001  li         r31, 1
8046c350: 7fe3fb78  mr         r3, r31
8046c354: 38810020  addi       r4, r1, 0x20
8046c358: 4bfffcf9  bl         0x8046c050
8046c35c: 806dd678  lwz        r3, -0x2988(r13)
8046c360: 7fe6fb78  mr         r6, r31
8046c364: 38a10020  addi       r5, r1, 0x20
8046c368: 38800002  li         r4, 2
8046c36c: 80630188  lwz        r3, 0x188(r3)
8046c370: 4befb239  bl         0x803675a8
8046c374: 48000028  b          0x8046c39c
8046c378: 7fe3fb78  mr         r3, r31
8046c37c: 38810020  addi       r4, r1, 0x20
8046c380: 4bfffd39  bl         0x8046c0b8
8046c384: 806dd678  lwz        r3, -0x2988(r13)
8046c388: 7fe6fb78  mr         r6, r31
8046c38c: 38a10020  addi       r5, r1, 0x20
8046c390: 38800001  li         r4, 1
8046c394: 80630188  lwz        r3, 0x188(r3)
8046c398: 4befb211  bl         0x803675a8
8046c39c: 80010084  lwz        r0, 0x84(r1)
8046c3a0: 83e1007c  lwz        r31, 0x7c(r1)
8046c3a4: 83c10078  lwz        r30, 0x78(r1)
8046c3a8: 7c0803a6  mtlr       r0
8046c3ac: 38210080  addi       r1, r1, 0x80
8046c3b0: 4e800020  blr        
8046c3b4: 9421ff80  stwu       r1, -0x80(r1)
8046c3b8: 7c0802a6  mflr       r0
8046c3bc: 90010084  stw        r0, 0x84(r1)
8046c3c0: 38a10008  addi       r5, r1, 8
8046c3c4: 38c10014  addi       r6, r1, 0x14
8046c3c8: 93e1007c  stw        r31, 0x7c(r1)
8046c3cc: 7c7f1b78  mr         r31, r3
8046c3d0: 80830008  lwz        r4, 8(r3)
8046c3d4: 8003000c  lwz        r0, 0xc(r3)
8046c3d8: 90010018  stw        r0, 0x18(r1)
8046c3dc: c06d9fd4  lfs        f3, -0x602c(r13) ; [806f20f4] 3ee76c8b f32=0.451999992
8046c3e0: 90810014  stw        r4, 0x14(r1)
8046c3e4: 80030010  lwz        r0, 0x10(r3)
8046c3e8: 9001001c  stw        r0, 0x1c(r1)
8046c3ec: e0460000  psq_l      f2, 0(r6), W=0, I=0
8046c3f0: e0230228  psq_l      f1, 552(r3), W=0, I=0
8046c3f4: 100100d8  ps_muls0   f0, f1, f3
8046c3f8: e0238230  psq_l      f1, 560(r3), W=1, I=0
8046c3fc: f0050000  psq_st     f0, 0(r5), W=0, I=0
8046c400: 100100d8  ps_muls0   f0, f1, f3
8046c404: e0250000  psq_l      f1, 0(r5), W=0, I=0
8046c408: f0058008  psq_st     f0, 8(r5), W=1, I=0
8046c40c: 10220828  ps_sub     f1, f2, f1
8046c410: e0468008  psq_l      f2, 8(r6), W=1, I=0
8046c414: f0260000  psq_st     f1, 0(r6), W=0, I=0
8046c418: 10220028  ps_sub     f1, f2, f0
8046c41c: f0268008  psq_st     f1, 8(r6), W=1, I=0
8046c420: c0030014  lfs        f0, 0x14(r3)
8046c424: d0010068  stfs       f0, 0x68(r1)
8046c428: c0030018  lfs        f0, 0x18(r3)
8046c42c: d001006c  stfs       f0, 0x6c(r1)
8046c430: c003001c  lfs        f0, 0x1c(r3)
8046c434: 38610068  addi       r3, r1, 0x68
8046c438: d0010070  stfs       f0, 0x70(r1)
8046c43c: 7c641b78  mr         r4, r3
8046c440: 4bebbbed  bl         0x8032802c
8046c444: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c448: fc010000  fcmpu      cr0, f1, f0
8046c44c: 4082001c  bne        0x8046c468
8046c450: c01f0228  lfs        f0, 0x228(r31)
8046c454: d0010068  stfs       f0, 0x68(r1)
8046c458: c01f022c  lfs        f0, 0x22c(r31)
8046c45c: d001006c  stfs       f0, 0x6c(r1)
8046c460: c01f0230  lfs        f0, 0x230(r31)
8046c464: d0010070  stfs       f0, 0x70(r1)
8046c468: 3c80807d  lis        r4, -0x7f83
8046c46c: 3861005c  addi       r3, r1, 0x5c
8046c470: 38a40330  addi       r5, r4, 0x330
8046c474: c0440330  lfs        f2, 0x330(r4)
8046c478: c0250004  lfs        f1, 4(r5)
8046c47c: 38810068  addi       r4, r1, 0x68
8046c480: c0050008  lfs        f0, 8(r5)
8046c484: 38a10050  addi       r5, r1, 0x50
8046c488: d041005c  stfs       f2, 0x5c(r1)
8046c48c: d0210060  stfs       f1, 0x60(r1)
8046c490: d0010064  stfs       f0, 0x64(r1)
8046c494: 4bbd338d  bl         0x8003f820
8046c498: 38610050  addi       r3, r1, 0x50
8046c49c: 7c641b78  mr         r4, r3
8046c4a0: 4bebbb8d  bl         0x8032802c
8046c4a4: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c4a8: fc010000  fcmpu      cr0, f1, f0
8046c4ac: 40820024  bne        0x8046c4d0
8046c4b0: 3c80807d  lis        r4, -0x7f83
8046c4b4: 38640324  addi       r3, r4, 0x324
8046c4b8: c0440324  lfs        f2, 0x324(r4)
8046c4bc: c0230004  lfs        f1, 4(r3)
8046c4c0: c0030008  lfs        f0, 8(r3)
8046c4c4: d0410050  stfs       f2, 0x50(r1)
8046c4c8: d0210054  stfs       f1, 0x54(r1)
8046c4cc: d0010058  stfs       f0, 0x58(r1)
8046c4d0: 38610050  addi       r3, r1, 0x50
8046c4d4: 3881005c  addi       r4, r1, 0x5c
8046c4d8: 38a10068  addi       r5, r1, 0x68
8046c4dc: 4bbd3345  bl         0x8003f820
8046c4e0: 38610020  addi       r3, r1, 0x20
8046c4e4: 38810014  addi       r4, r1, 0x14
8046c4e8: 38a10050  addi       r5, r1, 0x50
8046c4ec: 4bebba75  bl         0x80327f60
8046c4f0: 38810020  addi       r4, r1, 0x20
8046c4f4: 38600006  li         r3, 6
8046c4f8: 4bfffbc1  bl         0x8046c0b8
8046c4fc: 806dd678  lwz        r3, -0x2988(r13)
8046c500: 38a10020  addi       r5, r1, 0x20
8046c504: 38800001  li         r4, 1
8046c508: 38c00006  li         r6, 6
8046c50c: 80630188  lwz        r3, 0x188(r3)
8046c510: 4befb099  bl         0x803675a8
8046c514: 80010084  lwz        r0, 0x84(r1)
8046c518: 83e1007c  lwz        r31, 0x7c(r1)
8046c51c: 7c0803a6  mtlr       r0
8046c520: 38210080  addi       r1, r1, 0x80
8046c524: 4e800020  blr        
8046c528: 9421ffe0  stwu       r1, -0x20(r1)
8046c52c: 7c0802a6  mflr       r0
8046c530: 90010024  stw        r0, 0x24(r1)
8046c534: 93e1001c  stw        r31, 0x1c(r1)
8046c538: 7c7f1b78  mr         r31, r3
8046c53c: 80030178  lwz        r0, 0x178(r3)
8046c540: 2c000001  cmpwi      r0, 1
8046c544: 408200b4  bne        0x8046c5f8
8046c548: 80030198  lwz        r0, 0x198(r3)
8046c54c: 2c000000  cmpwi      r0, 0
8046c550: 41820018  beq        0x8046c568
8046c554: 7c030378  mr         r3, r0
8046c558: 38810008  addi       r4, r1, 8
8046c55c: 38bf0008  addi       r5, r31, 8
8046c560: 4bff2229  bl         0x8045e788
8046c564: 4800001c  b          0x8046c580
8046c568: c0030008  lfs        f0, 8(r3)
8046c56c: d0010008  stfs       f0, 8(r1)
8046c570: c003000c  lfs        f0, 0xc(r3)
8046c574: d001000c  stfs       f0, 0xc(r1)
8046c578: c0030010  lfs        f0, 0x10(r3)
8046c57c: d0010010  stfs       f0, 0x10(r1)
8046c580: 801f0188  lwz        r0, 0x188(r31)
8046c584: 540007bf  clrlwi.    r0, r0, 0x1e
8046c588: 41820030  beq        0x8046c5b8
8046c58c: c0210010  lfs        f1, 0x10(r1)
8046c590: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c594: fc010040  fcmpo      cr0, f1, f0
8046c598: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c59c: 4082001c  bne        0x8046c5b8
8046c5a0: 806dd678  lwz        r3, -0x2988(r13)
8046c5a4: 7fe4fb78  mr         r4, r31
8046c5a8: 38a00002  li         r5, 2
8046c5ac: 8063017c  lwz        r3, 0x17c(r3)
8046c5b0: 480155cd  bl         0x80481b7c
8046c5b4: 48000044  b          0x8046c5f8
8046c5b8: c0210010  lfs        f1, 0x10(r1)
8046c5bc: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046c5c0: fc010040  fcmpo      cr0, f1, f0
8046c5c4: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046c5c8: 4082001c  bne        0x8046c5e4
8046c5cc: 806dd678  lwz        r3, -0x2988(r13)
8046c5d0: 7fe4fb78  mr         r4, r31
8046c5d4: 38a00000  li         r5, 0
8046c5d8: 8063017c  lwz        r3, 0x17c(r3)
8046c5dc: 480155a1  bl         0x80481b7c
8046c5e0: 48000018  b          0x8046c5f8
8046c5e4: 806dd678  lwz        r3, -0x2988(r13)
8046c5e8: 7fe4fb78  mr         r4, r31
8046c5ec: 38a00001  li         r5, 1
8046c5f0: 8063017c  lwz        r3, 0x17c(r3)
8046c5f4: 48015589  bl         0x80481b7c
8046c5f8: 801f0178  lwz        r0, 0x178(r31)
8046c5fc: 2c000002  cmpwi      r0, 2
8046c600: 40820018  bne        0x8046c618
8046c604: 806dd678  lwz        r3, -0x2988(r13)
8046c608: 7fe4fb78  mr         r4, r31
8046c60c: 38a00003  li         r5, 3
8046c610: 8063017c  lwz        r3, 0x17c(r3)
8046c614: 48015569  bl         0x80481b7c
8046c618: 80010024  lwz        r0, 0x24(r1)
8046c61c: 83e1001c  lwz        r31, 0x1c(r1)
8046c620: 7c0803a6  mtlr       r0
8046c624: 38210020  addi       r1, r1, 0x20
8046c628: 4e800020  blr        
8046c62c: 80030194  lwz        r0, 0x194(r3)
8046c630: 2c000000  cmpwi      r0, 0
8046c634: 4182000c  beq        0x8046c640
8046c638: 2c000002  cmpwi      r0, 2
8046c63c: 4c820020  bnelr      
8046c640: c0440000  lfs        f2, 0(r4)
8046c644: 3cc0807d  lis        r6, -0x7f83
8046c648: c0240004  lfs        f1, 4(r4)
8046c64c: 38a60318  addi       r5, r6, 0x318
8046c650: c0040008  lfs        f0, 8(r4)
8046c654: d0430008  stfs       f2, 8(r3)
8046c658: d023000c  stfs       f1, 0xc(r3)
8046c65c: d0030010  stfs       f0, 0x10(r3)
8046c660: c0060318  lfs        f0, 0x318(r6)
8046c664: d0030014  stfs       f0, 0x14(r3)
8046c668: c0050004  lfs        f0, 4(r5)
8046c66c: d0030018  stfs       f0, 0x18(r3)
8046c670: c0050008  lfs        f0, 8(r5)
8046c674: d003001c  stfs       f0, 0x1c(r3)
8046c678: 4bed2170  b          0x8033e7e8
8046c67c: 4e800020  blr        
8046c680: 4bed1e80  b          0x8033e500
8046c684: 80add678  lwz        r5, -0x2988(r13)
8046c688: 7c641b78  mr         r4, r3
8046c68c: 8065019c  lwz        r3, 0x19c(r5)
8046c690: 2c030000  cmpwi      r3, 0
8046c694: 4d820020  beqlr      
8046c698: 4801b0bc  b          0x80487754
8046c69c: 4e800020  blr        
8046c6a0: 4bed20a8  b          0x8033e748
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
8046ca20: 9001001c  stw        r0, 0x1c(r1)
8046ca24: 10430028  ps_sub     f2, f3, f0
8046ca28: e0658008  psq_l      f3, 8(r5), W=1, I=0
8046ca2c: f0450000  psq_st     f2, 0(r5), W=0, I=0
8046ca30: 10430828  ps_sub     f2, f3, f1
8046ca34: c0010018  lfs        f0, 0x18(r1)
8046ca38: f0248008  psq_st     f1, 8(r4), W=1, I=0
8046ca3c: fc002040  fcmpo      cr0, f0, f4
8046ca40: f0458008  psq_st     f2, 8(r5), W=1, I=0
8046ca44: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046ca48: 4082003c  bne        0x8046ca84
8046ca4c: 806dd678  lwz        r3, -0x2988(r13)
8046ca50: c0221040  lfs        f1, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046ca54: 80630164  lwz        r3, 0x164(r3)
8046ca58: 4bfece69  bl         0x804598c0
8046ca5c: 7fe3fb78  mr         r3, r31
8046ca60: 4bfff955  bl         0x8046c3b4
8046ca64: 48000020  b          0x8046ca84
8046ca68: c00da008  lfs        f0, -0x5ff8(r13) ; [806f2128] 3cf5c28f f32=0.0299999993
8046ca6c: fc1f0040  fcmpo      cr0, f31, f0
8046ca70: 4c411382  cror       cr0eq, cr0gt, cr0eq
8046ca74: 40820010  bne        0x8046ca84
8046ca78: 7fe3fb78  mr         r3, r31
8046ca7c: 38800003  li         r4, 3
8046ca80: 4bfff6a5  bl         0x8046c124
8046ca84: 80010054  lwz        r0, 0x54(r1)
8046ca88: e3e10048  psq_l      f31, 72(r1), W=0, I=0
8046ca8c: cbe10040  lfd        f31, 0x40(r1)
8046ca90: e3c10038  psq_l      f30, 56(r1), W=0, I=0
8046ca94: cbc10030  lfd        f30, 0x30(r1)
8046ca98: 83e1002c  lwz        r31, 0x2c(r1)
8046ca9c: 7c0803a6  mtlr       r0
8046caa0: 38210050  addi       r1, r1, 0x50
8046caa4: 4e800020  blr        
8046caa8: 9421fff0  stwu       r1, -0x10(r1)
8046caac: 7c0802a6  mflr       r0
8046cab0: 90010014  stw        r0, 0x14(r1)
8046cab4: 93e1000c  stw        r31, 0xc(r1)
8046cab8: 7c7f1b78  mr         r31, r3
8046cabc: 808dd678  lwz        r4, -0x2988(r13)
8046cac0: 80840188  lwz        r4, 0x188(r4)
8046cac4: 80040024  lwz        r0, 0x24(r4)
8046cac8: 2c000002  cmpwi      r0, 2
8046cacc: 4182001c  beq        0x8046cae8
8046cad0: 80030250  lwz        r0, 0x250(r3)
8046cad4: 5400077b  rlwinm.    r0, r0, 0, 0x1d, 0x1d
8046cad8: 41820010  beq        0x8046cae8
8046cadc: 4bfff561  bl         0x8046c03c
8046cae0: 7fe3fb78  mr         r3, r31
8046cae4: 4bfffbc1  bl         0x8046c6a4
8046cae8: 80010014  lwz        r0, 0x14(r1)
8046caec: 83e1000c  lwz        r31, 0xc(r1)
8046caf0: 7c0803a6  mtlr       r0
8046caf4: 38210010  addi       r1, r1, 0x10
8046caf8: 4e800020  blr        
8046cafc: 38000000  li         r0, 0
8046cb00: 900301b8  stw        r0, 0x1b8(r3)
8046cb04: 4e800020  blr        
8046cb08: 7c601b78  mr         r0, r3
8046cb0c: 908300f8  stw        r4, 0xf8(r3)
8046cb10: 7c832378  mr         r3, r4
8046cb14: 7c040378  mr         r4, r0
8046cb18: 48003200  b          0x8046fd18
8046cb1c: 9421ffa0  stwu       r1, -0x60(r1)
8046cb20: 7c0802a6  mflr       r0
8046cb24: 90010064  stw        r0, 0x64(r1)
8046cb28: 39610060  addi       r11, r1, 0x60
8046cb2c: 4bb9ad31  bl         0x8000785c
8046cb30: 7c7e1b78  mr         r30, r3
8046cb34: 7c9f2378  mr         r31, r4
8046cb38: 4bed1e15  bl         0x8033e94c
8046cb3c: c02d9ffc  lfs        f1, -0x6004(r13) ; [806f211c] 3f800000 f32=1
8046cb40: 7fc3f378  mr         r3, r30
8046cb44: 4bed0be5  bl         0x8033d728
8046cb48: 3c6041c6  lis        r3, 0x41c6
8046cb4c: 80adcff0  lwz        r5, -0x3010(r13)
8046cb50: 38034e6d  addi       r0, r3, 0x4e6d
8046cb54: 388dcff0  addi       r4, r13, -0x3010
8046cb58: 7ca501d6  mullw      r5, r5, r0
8046cb5c: 80640004  lwz        r3, 4(r4)
8046cb60: 546007ff  clrlwi.    r0, r3, 0x1f
8046cb64: 38053039  addi       r0, r5, 0x3039
8046cb68: 900dcff0  stw        r0, -0x3010(r13)
8046cb6c: 41820010  beq        0x8046cb7c
8046cb70: 6c600001  xoris      r0, r3, 1
8046cb74: 68001020  xori       r0, r0, 0x1020
8046cb78: 90040004  stw        r0, 4(r4)
8046cb7c: 3c6041c6  lis        r3, 0x41c6
8046cb80: 808dcff0  lwz        r4, -0x3010(r13)
8046cb84: 38034e6d  addi       r0, r3, 0x4e6d
8046cb88: 38cdcff0  addi       r6, r13, -0x3010
8046cb8c: 7c6401d6  mullw      r3, r4, r0
8046cb90: 80060004  lwz        r0, 4(r6)
8046cb94: 5405f87e  srwi       r5, r0, 1
8046cb98: 90a60004  stw        r5, 4(r6)
8046cb9c: 5400ffff  rlwinm.    r0, r0, 0x1f, 0x1f, 0x1f
8046cba0: 7c842a78  xor        r4, r4, r5
8046cba4: 38033039  addi       r0, r3, 0x3039
8046cba8: 900dcff0  stw        r0, -0x3010(r13)
8046cbac: 5487f87e  srwi       r7, r4, 1
8046cbb0: 41820010  beq        0x8046cbc0
8046cbb4: 6ca00001  xoris      r0, r5, 1
8046cbb8: 68001020  xori       r0, r0, 0x1020
8046cbbc: 90060004  stw        r0, 4(r6)
8046cbc0: 3c6041c6  lis        r3, 0x41c6
8046cbc4: 808dcff0  lwz        r4, -0x3010(r13)
8046cbc8: 38034e6d  addi       r0, r3, 0x4e6d
8046cbcc: 38cdcff0  addi       r6, r13, -0x3010
8046cbd0: 7c6401d6  mullw      r3, r4, r0
8046cbd4: 80060004  lwz        r0, 4(r6)
8046cbd8: 5405f87e  srwi       r5, r0, 1
8046cbdc: 90a60004  stw        r5, 4(r6)
8046cbe0: 5400ffff  rlwinm.    r0, r0, 0x1f, 0x1f, 0x1f
8046cbe4: 7c842a78  xor        r4, r4, r5
8046cbe8: 38033039  addi       r0, r3, 0x3039
8046cbec: 900dcff0  stw        r0, -0x3010(r13)
8046cbf0: 5483f87e  srwi       r3, r4, 1
8046cbf4: 41820010  beq        0x8046cc04
8046cbf8: 6ca00001  xoris      r0, r5, 1
8046cbfc: 68001020  xori       r0, r0, 0x1020
8046cc00: 90060004  stw        r0, 4(r6)
8046cc04: 390dcff0  addi       r8, r13, -0x3010
8046cc08: 3ca04330  lis        r5, 0x4330
8046cc0c: 80c80004  lwz        r6, 4(r8)
8046cc10: 5464033e  clrlwi     r4, r3, 0xc
8046cc14: 800dcff0  lwz        r0, -0x3010(r13)
8046cc18: 54e3033e  clrlwi     r3, r7, 0xc
8046cc1c: 54c7f87e  srwi       r7, r6, 1
8046cc20: 3c84fff8  addis      r4, r4, -8
8046cc24: 7c063a78  xor        r6, r0, r7
8046cc28: 3c03fff8  addis      r0, r3, -8
8046cc2c: 54c3fb3e  rlwinm     r3, r6, 0x1f, 0xc, 0x1f
8046cc30: 6c848000  xoris      r4, r4, 0x8000
8046cc34: 3c63fff8  addis      r3, r3, -8
8046cc38: 6c008000  xoris      r0, r0, 0x8000
8046cc3c: 6c638000  xoris      r3, r3, 0x8000
8046cc40: 9061003c  stw        r3, 0x3c(r1)
8046cc44: c8a21080  lfd        f5, 0x1080(r2) ; [806ff100] 43300000 f32=176
8046cc48: 38610008  addi       r3, r1, 8
8046cc4c: 90a10038  stw        r5, 0x38(r1)
8046cc50: c08210b8  lfs        f4, 0x10b8(r2) ; [806ff138] 48ffffe0 f32=524287
8046cc54: c8010038  lfd        f0, 0x38(r1)
8046cc58: 90810044  stw        r4, 0x44(r1)
8046cc5c: ec202828  fsubs      f1, f0, f5
8046cc60: c06210bc  lfs        f3, 0x10bc(r2) ; [806ff13c] 40490fdb f32=3.14159274
8046cc64: 90a10040  stw        r5, 0x40(r1)
8046cc68: c0021070  lfs        f0, 0x1070(r2) ; [806ff0f0] 4222f983 f32=40.7436638
8046cc6c: c8410040  lfd        f2, 0x40(r1)
8046cc70: ecc12024  fdivs      f6, f1, f4
8046cc74: 9001004c  stw        r0, 0x4c(r1)
8046cc78: 90a10048  stw        r5, 0x48(r1)
8046cc7c: c8210048  lfd        f1, 0x48(r1)
8046cc80: 90e80004  stw        r7, 4(r8)
8046cc84: ec422828  fsubs      f2, f2, f5
8046cc88: ec212828  fsubs      f1, f1, f5
8046cc8c: eca301b2  fmuls      f5, f3, f6
8046cc90: ec422024  fdivs      f2, f2, f4
8046cc94: ec212024  fdivs      f1, f1, f4
8046cc98: ec4300b2  fmuls      f2, f3, f2
8046cc9c: ec230072  fmuls      f1, f3, f1
8046cca0: ec600172  fmuls      f3, f0, f5
8046cca4: ec4000b2  fmuls      f2, f0, f2
8046cca8: ec200072  fmuls      f1, f0, f1
8046ccac: 4bccf645  bl         0x8013c2f0
8046ccb0: 387e0020  addi       r3, r30, 0x20
8046ccb4: 38810008  addi       r4, r1, 8
8046ccb8: 4bebb225  bl         0x80327edc
8046ccbc: 3c60807d  lis        r3, -0x7f83
8046ccc0: 38000006  li         r0, 6
8046ccc4: 38630378  addi       r3, r3, 0x378
8046ccc8: 38be010c  addi       r5, r30, 0x10c
8046cccc: 3883fffc  addi       r4, r3, -4
8046ccd0: 7c0903a6  mtctr      r0
8046ccd4: 80640004  lwz        r3, 4(r4)
8046ccd8: 84040008  lwzu       r0, 8(r4)
8046ccdc: 90650004  stw        r3, 4(r5)
8046cce0: 94050008  stwu       r0, 8(r5)
8046cce4: 4200fff0  bdnz       0x8046ccd4
8046cce8: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ccec: 7fc3f378  mr         r3, r30
8046ccf0: d01e0140  stfs       f0, 0x140(r30)
8046ccf4: 38800000  li         r4, 0
8046ccf8: 4bffd641  bl         0x8046a338
8046ccfc: 3b800000  li         r28, 0
8046cd00: 939e0178  stw        r28, 0x178(r30)
8046cd04: 3fa0807d  lis        r29, -0x7f83
8046cd08: 817e0020  lwz        r11, 0x20(r30)
8046cd0c: 939e017c  stw        r28, 0x17c(r30)
8046cd10: 399d0318  addi       r12, r29, 0x318
8046cd14: 815e0024  lwz        r10, 0x24(r30)
8046cd18: 3c60807d  lis        r3, -0x7f83
8046cd1c: 939e0180  stw        r28, 0x180(r30)
8046cd20: 813e0028  lwz        r9, 0x28(r30)
8046cd24: 939e0184  stw        r28, 0x184(r30)
8046cd28: 811e002c  lwz        r8, 0x2c(r30)
8046cd2c: 939e0188  stw        r28, 0x188(r30)
8046cd30: 80fe0030  lwz        r7, 0x30(r30)
8046cd34: 939e018c  stw        r28, 0x18c(r30)
8046cd38: 80de0034  lwz        r6, 0x34(r30)
8046cd3c: b39e0190  sth        r28, 0x190(r30)
8046cd40: 80be0038  lwz        r5, 0x38(r30)
8046cd44: 939e0194  stw        r28, 0x194(r30)
8046cd48: 809e003c  lwz        r4, 0x3c(r30)
8046cd4c: 939e0198  stw        r28, 0x198(r30)
8046cd50: 801e0040  lwz        r0, 0x40(r30)
8046cd54: 939e019c  stw        r28, 0x19c(r30)
8046cd58: c09e0008  lfs        f4, 8(r30)
8046cd5c: c01d0318  lfs        f0, 0x318(r29)
8046cd60: d01e01a0  stfs       f0, 0x1a0(r30)
8046cd64: c07e000c  lfs        f3, 0xc(r30)
8046cd68: c00c0004  lfs        f0, 4(r12)
8046cd6c: d01e01a4  stfs       f0, 0x1a4(r30)
8046cd70: c03e0010  lfs        f1, 0x10(r30)
8046cd74: c00c0008  lfs        f0, 8(r12)
8046cd78: d01e01a8  stfs       f0, 0x1a8(r30)
8046cd7c: c0421040  lfs        f2, 0x1040(r2) ; [806ff0c0] 3f800000 f32=1
8046cd80: c01d0318  lfs        f0, 0x318(r29)
8046cd84: d01e01ac  stfs       f0, 0x1ac(r30)
8046cd88: c002106c  lfs        f0, 0x106c(r2) ; [806ff0ec] bf800000 f32=-1
8046cd8c: c0ac0004  lfs        f5, 4(r12)
8046cd90: d0be01b0  stfs       f5, 0x1b0(r30)
8046cd94: c0ac0008  lfs        f5, 8(r12)
8046cd98: d0be01b4  stfs       f5, 0x1b4(r30)
8046cd9c: 939e01b8  stw        r28, 0x1b8(r30)
8046cda0: 917e01bc  stw        r11, 0x1bc(r30)
8046cda4: 915e01c0  stw        r10, 0x1c0(r30)
8046cda8: 913e01c4  stw        r9, 0x1c4(r30)
8046cdac: 911e01c8  stw        r8, 0x1c8(r30)
8046cdb0: 90fe01cc  stw        r7, 0x1cc(r30)
8046cdb4: 90de01d0  stw        r6, 0x1d0(r30)
8046cdb8: 90be01d4  stw        r5, 0x1d4(r30)
8046cdbc: 909e01d8  stw        r4, 0x1d8(r30)
8046cdc0: 901e01dc  stw        r0, 0x1dc(r30)
8046cdc4: 917e01e0  stw        r11, 0x1e0(r30)
8046cdc8: 915e01e4  stw        r10, 0x1e4(r30)
8046cdcc: 913e01e8  stw        r9, 0x1e8(r30)
8046cdd0: 911e01ec  stw        r8, 0x1ec(r30)
8046cdd4: 90fe01f0  stw        r7, 0x1f0(r30)
8046cdd8: 90de01f4  stw        r6, 0x1f4(r30)
8046cddc: 90be01f8  stw        r5, 0x1f8(r30)
8046cde0: 909e01fc  stw        r4, 0x1fc(r30)
8046cde4: 901e0200  stw        r0, 0x200(r30)
8046cde8: d09e0204  stfs       f4, 0x204(r30)
8046cdec: d07e0208  stfs       f3, 0x208(r30)
8046cdf0: d03e020c  stfs       f1, 0x20c(r30)
8046cdf4: d09e0210  stfs       f4, 0x210(r30)
8046cdf8: d07e0214  stfs       f3, 0x214(r30)
8046cdfc: d03e0218  stfs       f1, 0x218(r30)
8046ce00: d05e021c  stfs       f2, 0x21c(r30)
8046ce04: d05e0220  stfs       f2, 0x220(r30)
8046ce08: d01e0224  stfs       f0, 0x224(r30)
8046ce0c: c0030330  lfs        f0, 0x330(r3)
8046ce10: d01e0228  stfs       f0, 0x228(r30)
8046ce14: 38630330  addi       r3, r3, 0x330
8046ce18: 3ca0807d  lis        r5, -0x7f83
8046ce1c: c0030004  lfs        f0, 4(r3)
8046ce20: 3885033c  addi       r4, r5, 0x33c
8046ce24: d01e022c  stfs       f0, 0x22c(r30)
8046ce28: 38000004  li         r0, 4
8046ce2c: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046ce30: c0230008  lfs        f1, 8(r3)
8046ce34: d03e0230  stfs       f1, 0x230(r30)
8046ce38: 807e0150  lwz        r3, 0x150(r30)
8046ce3c: c03d0318  lfs        f1, 0x318(r29)
8046ce40: d03e0234  stfs       f1, 0x234(r30)
8046ce44: c02c0004  lfs        f1, 4(r12)
8046ce48: d03e0238  stfs       f1, 0x238(r30)
8046ce4c: c02c0008  lfs        f1, 8(r12)
8046ce50: d03e023c  stfs       f1, 0x23c(r30)
8046ce54: c025033c  lfs        f1, 0x33c(r5)
8046ce58: d03e0240  stfs       f1, 0x240(r30)
8046ce5c: c0240004  lfs        f1, 4(r4)
8046ce60: d03e0244  stfs       f1, 0x244(r30)
8046ce64: c0240008  lfs        f1, 8(r4)
8046ce68: d03e0248  stfs       f1, 0x248(r30)
8046ce6c: d01e024c  stfs       f0, 0x24c(r30)
8046ce70: 901e0250  stw        r0, 0x250(r30)
8046ce74: 93fe0254  stw        r31, 0x254(r30)
8046ce78: d05e025c  stfs       f2, 0x25c(r30)
8046ce7c: 800da014  lwz        r0, -0x5fec(r13) ; [806f2134] 00000078 f32=1.68155816e-43
8046ce80: 901e0260  stw        r0, 0x260(r30)
8046ce84: d01e0264  stfs       f0, 0x264(r30)
8046ce88: 939e0268  stw        r28, 0x268(r30)
8046ce8c: 480008ad  bl         0x8046d738
8046ce90: 39610060  addi       r11, r1, 0x60
8046ce94: 4bb9aa15  bl         0x800078a8
8046ce98: 80010064  lwz        r0, 0x64(r1)
8046ce9c: 7c0803a6  mtlr       r0
8046cea0: 38210060  addi       r1, r1, 0x60
8046cea4: 4e800020  blr        
8046cea8: 9421ffe0  stwu       r1, -0x20(r1)
8046ceac: 7c0802a6  mflr       r0
8046ceb0: 38800008  li         r4, 8
8046ceb4: 38a00000  li         r5, 0
8046ceb8: 90010024  stw        r0, 0x24(r1)
8046cebc: 93e1001c  stw        r31, 0x1c(r1)
8046cec0: 93c10018  stw        r30, 0x18(r1)
8046cec4: 7c7e1b78  mr         r30, r3
8046cec8: 4be22f1d  bl         0x8028fde4
8046cecc: 3860026c  li         r3, 0x26c
8046ced0: 4bd54d79  bl         0x801c1c48
8046ced4: 2c030000  cmpwi      r3, 0
8046ced8: 41820008  beq        0x8046cee0
8046cedc: 48000581  bl         0x8046d45c
8046cee0: 907e00fc  stw        r3, 0xfc(r30)
8046cee4: 3860026c  li         r3, 0x26c
8046cee8: 4bd54d61  bl         0x801c1c48
8046ceec: 2c030000  cmpwi      r3, 0
8046cef0: 41820008  beq        0x8046cef8
8046cef4: 48000569  bl         0x8046d45c
8046cef8: 907e0100  stw        r3, 0x100(r30)
8046cefc: 3860026c  li         r3, 0x26c
8046cf00: 4bd54d49  bl         0x801c1c48
8046cf04: 2c030000  cmpwi      r3, 0
8046cf08: 41820008  beq        0x8046cf10
8046cf0c: 48000551  bl         0x8046d45c
8046cf10: 907e0104  stw        r3, 0x104(r30)
8046cf14: 3860026c  li         r3, 0x26c
8046cf18: 4bd54d31  bl         0x801c1c48
8046cf1c: 2c030000  cmpwi      r3, 0
8046cf20: 7c601b78  mr         r0, r3
8046cf24: 4182000c  beq        0x8046cf30
8046cf28: 48000535  bl         0x8046d45c
8046cf2c: 7c601b78  mr         r0, r3
8046cf30: 809e0104  lwz        r4, 0x104(r30)
8046cf34: 3860026c  li         r3, 0x26c
8046cf38: 900400fc  stw        r0, 0xfc(r4)
8046cf3c: 4bd54d0d  bl         0x801c1c48
8046cf40: 2c030000  cmpwi      r3, 0
8046cf44: 41820008  beq        0x8046cf4c
8046cf48: 48000515  bl         0x8046d45c
8046cf4c: 907e0108  stw        r3, 0x108(r30)
8046cf50: 3860026c  li         r3, 0x26c
8046cf54: 4bd54cf5  bl         0x801c1c48
8046cf58: 2c030000  cmpwi      r3, 0
8046cf5c: 41820008  beq        0x8046cf64
8046cf60: 480004fd  bl         0x8046d45c
8046cf64: 809e0108  lwz        r4, 0x108(r30)
8046cf68: 3fe08068  lis        r31, -0x7f98
8046cf6c: 3bfff688  addi       r31, r31, -0x978
8046cf70: 38a00000  li         r5, 0
8046cf74: 906400fc  stw        r3, 0xfc(r4)
8046cf78: 389f00e4  addi       r4, r31, 0xe4
8046cf7c: 806dd678  lwz        r3, -0x2988(r13)
8046cf80: 4bebb9f1  bl         0x80328970
8046cf84: 7c651b78  mr         r5, r3
8046cf88: 806dccd0  lwz        r3, -0x3330(r13)
8046cf8c: 3880000c  li         r4, 0xc
8046cf90: 38c00000  li         r6, 0
8046cf94: 38e00000  li         r7, 0
8046cf98: 4bde68ad  bl         0x80253844
8046cf9c: 7c601b78  mr         r0, r3
8046cfa0: 806dccd0  lwz        r3, -0x3330(r13)
8046cfa4: 5404043e  clrlwi     r4, r0, 0x10
8046cfa8: 38bf00fb  addi       r5, r31, 0xfb
8046cfac: 4bde5f21  bl         0x80252ecc
8046cfb0: 907e010c  stw        r3, 0x10c(r30)
8046cfb4: 38600028  li         r3, 0x28
8046cfb8: 4bd54c91  bl         0x801c1c48
8046cfbc: 2c030000  cmpwi      r3, 0
8046cfc0: 41820008  beq        0x8046cfc8
8046cfc4: 480007f5  bl         0x8046d7b8
8046cfc8: 907e0150  stw        r3, 0x150(r30)
8046cfcc: 38800000  li         r4, 0
8046cfd0: 38a00000  li         r5, 0
8046cfd4: 806dd678  lwz        r3, -0x2988(r13)
8046cfd8: 80630164  lwz        r3, 0x164(r3)
8046cfdc: 80630020  lwz        r3, 0x20(r3)
8046cfe0: 4be3fea5  bl         0x802ace84
8046cfe4: 907e014c  stw        r3, 0x14c(r30)
8046cfe8: 3ca0807d  lis        r5, -0x7f83
8046cfec: c0021034  lfs        f0, 0x1034(r2) ; [806ff0b4] 00000000 f32=0
8046cff0: 38850330  addi       r4, r5, 0x330
8046cff4: d0030094  stfs       f0, 0x94(r3)
8046cff8: 38610008  addi       r3, r1, 8
8046cffc: 80de014c  lwz        r6, 0x14c(r30)
8046d000: d0060098  stfs       f0, 0x98(r6)
8046d004: c0250330  lfs        f1, 0x330(r5)
8046d008: c0440004  lfs        f2, 4(r4)
8046d00c: c0040008  lfs        f0, 8(r4)
8046d010: fc200850  fneg       f1, f1
8046d014: fc401050  fneg       f2, f2
8046d018: fc600050  fneg       f3, f0
8046d01c: 4bcc3cf5  bl         0x80130d10
8046d020: 807e014c  lwz        r3, 0x14c(r30)
8046d024: 38810008  addi       r4, r1, 8
8046d028: 4be3f9d5  bl         0x802ac9fc
8046d02c: 38000000  li         r0, 0
8046d030: 901e0174  stw        r0, 0x174(r30)
8046d034: 806dd678  lwz        r3, -0x2988(r13)
8046d038: 80630160  lwz        r3, 0x160(r3)
8046d03c: 80030008  lwz        r0, 8(r3)
8046d040: 2c000000  cmpwi      r0, 0
8046d044: 4082001c  bne        0x8046d060
8046d048: 38600010  li         r3, 0x10
8046d04c: 4bd54bfd  bl         0x801c1c48
8046d050: 2c030000  cmpwi      r3, 0
8046d054: 41820008  beq        0x8046d05c
8046d058: 480009dd  bl         0x8046da34
8046d05c: 907e0174  stw        r3, 0x174(r30)
8046d060: 80010024  lwz        r0, 0x24(r1)
8046d064: 83e1001c  lwz        r31, 0x1c(r1)
8046d068: 83c10018  lwz        r30, 0x18(r1)
8046d06c: 7c0803a6  mtlr       r0
8046d070: 38210020  addi       r1, r1, 0x20
8046d074: 4e800020  blr        
8046d078: 9421fff0  stwu       r1, -0x10(r1)
8046d07c: 7c0802a6  mflr       r0
8046d080: 90010014  stw        r0, 0x14(r1)
8046d084: 93e1000c  stw        r31, 0xc(r1)
8046d088: 7c9f2378  mr         r31, r4
8046d08c: 93c10008  stw        r30, 8(r1)
8046d090: 7c7e1b78  mr         r30, r3
8046d094: 800300fc  lwz        r0, 0xfc(r3)
8046d098: 2c000000  cmpwi      r0, 0
8046d09c: 41820018  beq        0x8046d0b4
8046d0a0: 808400fc  lwz        r4, 0xfc(r4)
8046d0a4: 2c040000  cmpwi      r4, 0
8046d0a8: 4182000c  beq        0x8046d0b4
8046d0ac: 7c030378  mr         r3, r0
8046d0b0: 4bffffc9  bl         0x8046d078
8046d0b4: c01f0008  lfs        f0, 8(r31)
8046d0b8: d01e0008  stfs       f0, 8(r30)
8046d0bc: c01f000c  lfs        f0, 0xc(r31)
8046d0c0: d01e000c  stfs       f0, 0xc(r30)
8046d0c4: c01f0010  lfs        f0, 0x10(r31)
8046d0c8: d01e0010  stfs       f0, 0x10(r30)
8046d0cc: c01f0014  lfs        f0, 0x14(r31)
8046d0d0: d01e0014  stfs       f0, 0x14(r30)
8046d0d4: c01f0018  lfs        f0, 0x18(r31)
8046d0d8: d01e0018  stfs       f0, 0x18(r30)
8046d0dc: c01f001c  lfs        f0, 0x1c(r31)
8046d0e0: d01e001c  stfs       f0, 0x1c(r30)
8046d0e4: 807f0020  lwz        r3, 0x20(r31)
8046d0e8: 801f0024  lwz        r0, 0x24(r31)
8046d0ec: 901e0024  stw        r0, 0x24(r30)
8046d0f0: 907e0020  stw        r3, 0x20(r30)
8046d0f4: 801f0028  lwz        r0, 0x28(r31)
8046d0f8: 901e0028  stw        r0, 0x28(r30)
8046d0fc: 807f002c  lwz        r3, 0x2c(r31)
8046d100: 801f0030  lwz        r0, 0x30(r31)
8046d104: 901e0030  stw        r0, 0x30(r30)
8046d108: 907e002c  stw        r3, 0x2c(r30)
8046d10c: 801f0034  lwz        r0, 0x34(r31)
8046d110: 901e0034  stw        r0, 0x34(r30)
8046d114: 807f0038  lwz        r3, 0x38(r31)
8046d118: 801f003c  lwz        r0, 0x3c(r31)
8046d11c: 901e003c  stw        r0, 0x3c(r30)
8046d120: 907e0038  stw        r3, 0x38(r30)
8046d124: 801f0040  lwz        r0, 0x40(r31)
8046d128: 901e0040  stw        r0, 0x40(r30)
8046d12c: c01f0044  lfs        f0, 0x44(r31)
8046d130: d01e0044  stfs       f0, 0x44(r30)
8046d134: c01f0048  lfs        f0, 0x48(r31)
8046d138: d01e0048  stfs       f0, 0x48(r30)
8046d13c: c01f004c  lfs        f0, 0x4c(r31)
8046d140: d01e004c  stfs       f0, 0x4c(r30)
8046d144: c01f0050  lfs        f0, 0x50(r31)
8046d148: d01e0050  stfs       f0, 0x50(r30)
8046d14c: c01f0054  lfs        f0, 0x54(r31)
8046d150: d01e0054  stfs       f0, 0x54(r30)
8046d154: c01f0058  lfs        f0, 0x58(r31)
8046d158: d01e0058  stfs       f0, 0x58(r30)
8046d15c: c01f005c  lfs        f0, 0x5c(r31)
8046d160: d01e005c  stfs       f0, 0x5c(r30)
8046d164: c01f0060  lfs        f0, 0x60(r31)
8046d168: d01e0060  stfs       f0, 0x60(r30)
8046d16c: c01f0064  lfs        f0, 0x64(r31)
8046d170: d01e0064  stfs       f0, 0x64(r30)
8046d174: 807f0068  lwz        r3, 0x68(r31)
8046d178: 801f006c  lwz        r0, 0x6c(r31)
8046d17c: 901e006c  stw        r0, 0x6c(r30)
8046d180: 907e0068  stw        r3, 0x68(r30)
8046d184: 801f0070  lwz        r0, 0x70(r31)
8046d188: 901e0070  stw        r0, 0x70(r30)
8046d18c: 807f0074  lwz        r3, 0x74(r31)
8046d190: 801f0078  lwz        r0, 0x78(r31)
8046d194: 901e0078  stw        r0, 0x78(r30)
8046d198: 907e0074  stw        r3, 0x74(r30)
8046d19c: 801f007c  lwz        r0, 0x7c(r31)
8046d1a0: 901e007c  stw        r0, 0x7c(r30)
8046d1a4: 807f0080  lwz        r3, 0x80(r31)
8046d1a8: 801f0084  lwz        r0, 0x84(r31)
8046d1ac: 901e0084  stw        r0, 0x84(r30)
8046d1b0: 907e0080  stw        r3, 0x80(r30)
8046d1b4: 801f0088  lwz        r0, 0x88(r31)
8046d1b8: 901e0088  stw        r0, 0x88(r30)
8046d1bc: 807f008c  lwz        r3, 0x8c(r31)
8046d1c0: 801f0090  lwz        r0, 0x90(r31)
8046d1c4: 901e0090  stw        r0, 0x90(r30)
8046d1c8: 907e008c  stw        r3, 0x8c(r30)
8046d1cc: 801f0094  lwz        r0, 0x94(r31)
8046d1d0: 901e0094  stw        r0, 0x94(r30)
8046d1d4: 807f0098  lwz        r3, 0x98(r31)
8046d1d8: 801f009c  lwz        r0, 0x9c(r31)
8046d1dc: 901e009c  stw        r0, 0x9c(r30)
8046d1e0: 907e0098  stw        r3, 0x98(r30)
8046d1e4: 801f00a0  lwz        r0, 0xa0(r31)
8046d1e8: 901e00a0  stw        r0, 0xa0(r30)
8046d1ec: c01f00a4  lfs        f0, 0xa4(r31)
8046d1f0: d01e00a4  stfs       f0, 0xa4(r30)
8046d1f4: 801f00a8  lwz        r0, 0xa8(r31)
8046d1f8: 901e00a8  stw        r0, 0xa8(r30)
8046d1fc: c01f00ac  lfs        f0, 0xac(r31)
8046d200: d01e00ac  stfs       f0, 0xac(r30)
8046d204: c01f00b0  lfs        f0, 0xb0(r31)
8046d208: d01e00b0  stfs       f0, 0xb0(r30)
8046d20c: c01f00b4  lfs        f0, 0xb4(r31)
8046d210: d01e00b4  stfs       f0, 0xb4(r30)
8046d214: c01f00b8  lfs        f0, 0xb8(r31)
8046d218: d01e00b8  stfs       f0, 0xb8(r30)
8046d21c: c01f00bc  lfs        f0, 0xbc(r31)
8046d220: d01e00bc  stfs       f0, 0xbc(r30)
8046d224: c01f00c0  lfs        f0, 0xc0(r31)
8046d228: d01e00c0  stfs       f0, 0xc0(r30)
8046d22c: c01f00dc  lfs        f0, 0xdc(r31)
8046d230: d01e00dc  stfs       f0, 0xdc(r30)
8046d234: c01f00e0  lfs        f0, 0xe0(r31)
8046d238: d01e00e0  stfs       f0, 0xe0(r30)
8046d23c: c01f00e4  lfs        f0, 0xe4(r31)
8046d240: d01e00e4  stfs       f0, 0xe4(r30)
8046d244: c01f00e8  lfs        f0, 0xe8(r31)
8046d248: d01e00e8  stfs       f0, 0xe8(r30)
8046d24c: c01f00ec  lfs        f0, 0xec(r31)
8046d250: d01e00ec  stfs       f0, 0xec(r30)
8046d254: 801f00f0  lwz        r0, 0xf0(r31)
8046d258: 901e00f0  stw        r0, 0xf0(r30)
8046d25c: 801f0178  lwz        r0, 0x178(r31)
8046d260: 901e0178  stw        r0, 0x178(r30)
8046d264: 801f017c  lwz        r0, 0x17c(r31)
8046d268: 901e017c  stw        r0, 0x17c(r30)
8046d26c: 801f0180  lwz        r0, 0x180(r31)
8046d270: 901e0180  stw        r0, 0x180(r30)
8046d274: 801f0184  lwz        r0, 0x184(r31)
8046d278: 901e0184  stw        r0, 0x184(r30)
8046d27c: 801f0188  lwz        r0, 0x188(r31)
8046d280: 901e0188  stw        r0, 0x188(r30)
8046d284: 801f018c  lwz        r0, 0x18c(r31)
8046d288: 901e018c  stw        r0, 0x18c(r30)
8046d28c: a01f0190  lhz        r0, 0x190(r31)
8046d290: b01e0190  sth        r0, 0x190(r30)
8046d294: 801f0194  lwz        r0, 0x194(r31)
8046d298: 901e0194  stw        r0, 0x194(r30)
8046d29c: 801f0198  lwz        r0, 0x198(r31)
8046d2a0: 901e0198  stw        r0, 0x198(r30)
8046d2a4: 801f019c  lwz        r0, 0x19c(r31)
8046d2a8: 901e019c  stw        r0, 0x19c(r30)
8046d2ac: c01f01a0  lfs        f0, 0x1a0(r31)
8046d2b0: d01e01a0  stfs       f0, 0x1a0(r30)
8046d2b4: c01f01a4  lfs        f0, 0x1a4(r31)
8046d2b8: d01e01a4  stfs       f0, 0x1a4(r30)
8046d2bc: c01f01a8  lfs        f0, 0x1a8(r31)
8046d2c0: d01e01a8  stfs       f0, 0x1a8(r30)
8046d2c4: c01f01ac  lfs        f0, 0x1ac(r31)
8046d2c8: d01e01ac  stfs       f0, 0x1ac(r30)
8046d2cc: c01f01b0  lfs        f0, 0x1b0(r31)
8046d2d0: d01e01b0  stfs       f0, 0x1b0(r30)
8046d2d4: c01f01b4  lfs        f0, 0x1b4(r31)
8046d2d8: d01e01b4  stfs       f0, 0x1b4(r30)
8046d2dc: 801f01b8  lwz        r0, 0x1b8(r31)
8046d2e0: 901e01b8  stw        r0, 0x1b8(r30)
8046d2e4: 807f01bc  lwz        r3, 0x1bc(r31)
8046d2e8: 801f01c0  lwz        r0, 0x1c0(r31)
8046d2ec: 901e01c0  stw        r0, 0x1c0(r30)
8046d2f0: 907e01bc  stw        r3, 0x1bc(r30)
8046d2f4: 801f01c4  lwz        r0, 0x1c4(r31)
8046d2f8: 901e01c4  stw        r0, 0x1c4(r30)
8046d2fc: 807f01c8  lwz        r3, 0x1c8(r31)
8046d300: 801f01cc  lwz        r0, 0x1cc(r31)
8046d304: 901e01cc  stw        r0, 0x1cc(r30)
8046d308: 907e01c8  stw        r3, 0x1c8(r30)
8046d30c: 801f01d0  lwz        r0, 0x1d0(r31)
8046d310: 901e01d0  stw        r0, 0x1d0(r30)
8046d314: 807f01d4  lwz        r3, 0x1d4(r31)
8046d318: 801f01d8  lwz        r0, 0x1d8(r31)
8046d31c: 901e01d8  stw        r0, 0x1d8(r30)
8046d320: 907e01d4  stw        r3, 0x1d4(r30)
8046d324: 801f01dc  lwz        r0, 0x1dc(r31)
8046d328: 901e01dc  stw        r0, 0x1dc(r30)
8046d32c: 807f01e0  lwz        r3, 0x1e0(r31)
8046d330: 801f01e4  lwz        r0, 0x1e4(r31)
8046d334: 901e01e4  stw        r0, 0x1e4(r30)
8046d338: 907e01e0  stw        r3, 0x1e0(r30)
8046d33c: 801f01e8  lwz        r0, 0x1e8(r31)
8046d340: 901e01e8  stw        r0, 0x1e8(r30)
8046d344: 807f01ec  lwz        r3, 0x1ec(r31)
8046d348: 801f01f0  lwz        r0, 0x1f0(r31)
8046d34c: 901e01f0  stw        r0, 0x1f0(r30)
8046d350: 907e01ec  stw        r3, 0x1ec(r30)
8046d354: 801f01f4  lwz        r0, 0x1f4(r31)
8046d358: 901e01f4  stw        r0, 0x1f4(r30)
8046d35c: 807f01f8  lwz        r3, 0x1f8(r31)
8046d360: 801f01fc  lwz        r0, 0x1fc(r31)
8046d364: 901e01fc  stw        r0, 0x1fc(r30)
8046d368: 907e01f8  stw        r3, 0x1f8(r30)
8046d36c: 801f0200  lwz        r0, 0x200(r31)
8046d370: 901e0200  stw        r0, 0x200(r30)
8046d374: c01f0204  lfs        f0, 0x204(r31)
8046d378: d01e0204  stfs       f0, 0x204(r30)
8046d37c: c01f0208  lfs        f0, 0x208(r31)
8046d380: d01e0208  stfs       f0, 0x208(r30)
8046d384: c01f020c  lfs        f0, 0x20c(r31)
8046d388: d01e020c  stfs       f0, 0x20c(r30)
8046d38c: c01f0210  lfs        f0, 0x210(r31)
8046d390: d01e0210  stfs       f0, 0x210(r30)
8046d394: c01f0214  lfs        f0, 0x214(r31)
8046d398: d01e0214  stfs       f0, 0x214(r30)
8046d39c: c01f0218  lfs        f0, 0x218(r31)
8046d3a0: d01e0218  stfs       f0, 0x218(r30)
8046d3a4: c01f021c  lfs        f0, 0x21c(r31)
8046d3a8: d01e021c  stfs       f0, 0x21c(r30)
8046d3ac: c01f0220  lfs        f0, 0x220(r31)
8046d3b0: d01e0220  stfs       f0, 0x220(r30)
8046d3b4: c01f0224  lfs        f0, 0x224(r31)
8046d3b8: d01e0224  stfs       f0, 0x224(r30)
8046d3bc: c01f0228  lfs        f0, 0x228(r31)
8046d3c0: d01e0228  stfs       f0, 0x228(r30)
8046d3c4: c01f022c  lfs        f0, 0x22c(r31)
8046d3c8: d01e022c  stfs       f0, 0x22c(r30)
8046d3cc: c01f0230  lfs        f0, 0x230(r31)
8046d3d0: d01e0230  stfs       f0, 0x230(r30)
8046d3d4: c01f0234  lfs        f0, 0x234(r31)
8046d3d8: d01e0234  stfs       f0, 0x234(r30)
8046d3dc: c01f0238  lfs        f0, 0x238(r31)
8046d3e0: d01e0238  stfs       f0, 0x238(r30)
8046d3e4: c01f023c  lfs        f0, 0x23c(r31)
8046d3e8: d01e023c  stfs       f0, 0x23c(r30)
8046d3ec: c01f0240  lfs        f0, 0x240(r31)
8046d3f0: d01e0240  stfs       f0, 0x240(r30)
8046d3f4: c01f0244  lfs        f0, 0x244(r31)
8046d3f8: d01e0244  stfs       f0, 0x244(r30)
8046d3fc: c01f0248  lfs        f0, 0x248(r31)
8046d400: d01e0248  stfs       f0, 0x248(r30)
8046d404: c01f024c  lfs        f0, 0x24c(r31)
8046d408: d01e024c  stfs       f0, 0x24c(r30)
8046d40c: 801f0250  lwz        r0, 0x250(r31)
8046d410: 901e0250  stw        r0, 0x250(r30)
8046d414: 801f0254  lwz        r0, 0x254(r31)
8046d418: 901e0254  stw        r0, 0x254(r30)
8046d41c: 801f0258  lwz        r0, 0x258(r31)
8046d420: 901e0258  stw        r0, 0x258(r30)
8046d424: c01f025c  lfs        f0, 0x25c(r31)
8046d428: d01e025c  stfs       f0, 0x25c(r30)
8046d42c: 801f0260  lwz        r0, 0x260(r31)
8046d430: 901e0260  stw        r0, 0x260(r30)
8046d434: c01f0264  lfs        f0, 0x264(r31)
8046d438: d01e0264  stfs       f0, 0x264(r30)
8046d43c: 801f0268  lwz        r0, 0x268(r31)
8046d440: 901e0268  stw        r0, 0x268(r30)
8046d444: 83e1000c  lwz        r31, 0xc(r1)
8046d448: 83c10008  lwz        r30, 8(r1)
8046d44c: 80010014  lwz        r0, 0x14(r1)
8046d450: 7c0803a6  mtlr       r0
8046d454: 38210010  addi       r1, r1, 0x10
8046d458: 4e800020  blr        
8046d45c: 9421fff0  stwu       r1, -0x10(r1)
8046d460: 7c0802a6  mflr       r0
8046d464: 90010014  stw        r0, 0x14(r1)
8046d468: 93e1000c  stw        r31, 0xc(r1)
8046d46c: 93c10008  stw        r30, 8(r1)
8046d470: 7c7e1b78  mr         r30, r3
8046d474: 4bed1691  bl         0x8033eb04
8046d478: 3c60806e  lis        r3, -0x7f92
8046d47c: 3be00000  li         r31, 0
8046d480: 3863a030  addi       r3, r3, -0x5fd0
8046d484: 907e0000  stw        r3, 0(r30)
8046d488: 387e01bc  addi       r3, r30, 0x1bc
8046d48c: 93fe010c  stw        r31, 0x10c(r30)
8046d490: 93fe0188  stw        r31, 0x188(r30)
8046d494: 93fe018c  stw        r31, 0x18c(r30)
8046d498: 4bcc25c9  bl         0x8012fa60
8046d49c: 387e01c8  addi       r3, r30, 0x1c8
8046d4a0: 4bcc25c1  bl         0x8012fa60
8046d4a4: 387e01d4  addi       r3, r30, 0x1d4
8046d4a8: 4bcc25b9  bl         0x8012fa60
8046d4ac: 387e01e0  addi       r3, r30, 0x1e0
8046d4b0: 4bcc25b1  bl         0x8012fa60
8046d4b4: 387e01ec  addi       r3, r30, 0x1ec
8046d4b8: 4bcc25a9  bl         0x8012fa60
8046d4bc: 387e01f8  addi       r3, r30, 0x1f8
8046d4c0: 4bcc25a1  bl         0x8012fa60
8046d4c4: 93fe0250  stw        r31, 0x250(r30)
8046d4c8: 38a00000  li         r5, 0
8046d4cc: 386dcfe8  addi       r3, r13, -0x3018
8046d4d0: 93fe00f4  stw        r31, 0xf4(r30)
8046d4d4: 93fe00fc  stw        r31, 0xfc(r30)
8046d4d8: 93fe0100  stw        r31, 0x100(r30)
8046d4dc: 93fe0104  stw        r31, 0x104(r30)
8046d4e0: 93fe0108  stw        r31, 0x108(r30)
8046d4e4: 93fe00f8  stw        r31, 0xf8(r30)
8046d4e8: 93fe010c  stw        r31, 0x10c(r30)
8046d4ec: 93fe0150  stw        r31, 0x150(r30)
8046d4f0: 93fe014c  stw        r31, 0x14c(r30)
8046d4f4: 7c9efa14  add        r4, r30, r31
8046d4f8: c00dcfe8  lfs        f0, -0x3018(r13)
8046d4fc: d0040154  stfs       f0, 0x154(r4)
8046d500: 38a50001  addi       r5, r5, 1
8046d504: 2c050004  cmpwi      r5, 4
8046d508: 3bff0008  addi       r31, r31, 8
8046d50c: c0030004  lfs        f0, 4(r3)
8046d510: d0040158  stfs       f0, 0x158(r4)
8046d514: 4180ffe0  blt        0x8046d4f4
8046d518: 387e0154  addi       r3, r30, 0x154
8046d51c: 38800020  li         r4, 0x20
8046d520: 4bbd8bf1  bl         0x80046110
8046d524: 7fc3f378  mr         r3, r30
8046d528: 83e1000c  lwz        r31, 0xc(r1)
8046d52c: 83c10008  lwz        r30, 8(r1)
8046d530: 80010014  lwz        r0, 0x14(r1)
8046d534: 7c0803a6  mtlr       r0
8046d538: 38210010  addi       r1, r1, 0x10
8046d53c: 4e800020  blr        
8046d540: 9421fff0  stwu       r1, -0x10(r1)
8046d544: 7c0802a6  mflr       r0
8046d548: 90010014  stw        r0, 0x14(r1)
8046d54c: bfc10008  stmw       r30, 8(r1)
8046d550: 7c9e2378  mr         r30, r4
8046d554: 7c7f1b78  mr         r31, r3
8046d558: 80a30024  lwz        r5, 0x24(r3)
8046d55c: 54a0103a  slwi       r0, r5, 2
8046d560: 54a51838  slwi       r5, r5, 3
8046d564: 7c830214  add        r4, r3, r0
8046d568: 80840018  lwz        r4, 0x18(r4)
8046d56c: 7c032a14  add        r0, r3, r5
8046d570: 5483103a  slwi       r3, r4, 2
8046d574: 7c63002e  lwzx       r3, r3, r0
8046d578: 4bdd1355  bl         0x8023e8cc
8046d57c: 57c0103a  slwi       r0, r30, 2
8046d580: 93df0024  stw        r30, 0x24(r31)
8046d584: 7c9f0214  add        r4, r31, r0
8046d588: 80640018  lwz        r3, 0x18(r4)
8046d58c: 38030001  addi       r0, r3, 1
8046d590: 90040018  stw        r0, 0x18(r4)
8046d594: 2c000002  cmpwi      r0, 2
8046d598: 4180000c  blt        0x8046d5a4
8046d59c: 38000000  li         r0, 0
8046d5a0: 90040018  stw        r0, 0x18(r4)
8046d5a4: 807f0024  lwz        r3, 0x24(r31)
8046d5a8: 80040018  lwz        r0, 0x18(r4)
8046d5ac: 54641838  slwi       r4, r3, 3
8046d5b0: 5403103a  slwi       r3, r0, 2
8046d5b4: 7c1f2214  add        r0, r31, r4
8046d5b8: 7c63002e  lwzx       r3, r3, r0
8046d5bc: 4bdd1271  bl         0x8023e82c
8046d5c0: bbc10008  lmw        r30, 8(r1)
8046d5c4: 80010014  lwz        r0, 0x14(r1)
8046d5c8: 7c0803a6  mtlr       r0
8046d5cc: 38210010  addi       r1, r1, 0x10
8046d5d0: 4e800020  blr        
8046d5d4: 9421ffd0  stwu       r1, -0x30(r1)
8046d5d8: 7c0802a6  mflr       r0
8046d5dc: 90010034  stw        r0, 0x34(r1)
8046d5e0: 39610020  addi       r11, r1, 0x20
8046d5e4: dbe10020  stfd       f31, 0x20(r1)
8046d5e8: f3e10028  psq_st     f31, 40(r1), W=0, I=0
8046d5ec: 4bb9a271  bl         0x8000785c
8046d5f0: 80c30024  lwz        r6, 0x24(r3)
8046d5f4: 7c9d2378  mr         r29, r4
8046d5f8: 7c7c1b78  mr         r28, r3
8046d5fc: ffe00890  fmr        f31, f1
8046d600: 54c0103a  slwi       r0, r6, 2
8046d604: 54c61838  slwi       r6, r6, 3
8046d608: 7c830214  add        r4, r3, r0
8046d60c: 7cbe2b78  mr         r30, r5
8046d610: 80840018  lwz        r4, 0x18(r4)
8046d614: 7c033214  add        r0, r3, r6
8046d618: 5483103a  slwi       r3, r4, 2
8046d61c: 7fe3002e  lwzx       r31, r3, r0
8046d620: 7fe3fb78  mr         r3, r31
8046d624: 4bdd12f9  bl         0x8023e91c
8046d628: 7fe3fb78  mr         r3, r31
8046d62c: 7fa4eb78  mr         r4, r29
8046d630: 4bdd0e4d  bl         0x8023e47c
8046d634: 801c0024  lwz        r0, 0x24(r28)
8046d638: 2c000000  cmpwi      r0, 0
8046d63c: 41820028  beq        0x8046d664
8046d640: 38a29aa4  addi       r5, r2, -0x655c
8046d644: 88c29aa4  lbz        r6, -0x655c(r2) ; [806f7b24] ffffffff f32=nan
8046d648: 88850001  lbz        r4, 1(r5)
8046d64c: 88650002  lbz        r3, 2(r5)
8046d650: 88050003  lbz        r0, 3(r5)
8046d654: 98de0000  stb        r6, 0(r30)
8046d658: 989e0001  stb        r4, 1(r30)
8046d65c: 987e0002  stb        r3, 2(r30)
8046d660: 981e0003  stb        r0, 3(r30)
8046d664: c00210c0  lfs        f0, 0x10c0(r2) ; [806ff140] 437f0000 f32=255
8046d668: 7fe3fb78  mr         r3, r31
8046d66c: 889e0000  lbz        r4, 0(r30)
8046d670: 39000003  li         r8, 3
8046d674: ec0007f2  fmuls      f0, f0, f31
8046d678: 88be0001  lbz        r5, 1(r30)
8046d67c: 88de0002  lbz        r6, 2(r30)
8046d680: fc00001e  fctiwz     f0, f0
8046d684: d8010008  stfd       f0, 8(r1)
8046d688: 8001000c  lwz        r0, 0xc(r1)
8046d68c: 981e0003  stb        r0, 3(r30)
8046d690: 5407063e  clrlwi     r7, r0, 0x18
8046d694: 4bdd0f4d  bl         0x8023e5e0
8046d698: 7fe3fb78  mr         r3, r31
8046d69c: 4bdd0bf1  bl         0x8023e28c
8046d6a0: 39610020  addi       r11, r1, 0x20
8046d6a4: e3e10028  psq_l      f31, 40(r1), W=0, I=0
8046d6a8: cbe10020  lfd        f31, 0x20(r1)
8046d6ac: 4bb9a1fd  bl         0x800078a8
8046d6b0: 80010034  lwz        r0, 0x34(r1)
8046d6b4: 7c0803a6  mtlr       r0
8046d6b8: 38210030  addi       r1, r1, 0x30
8046d6bc: 4e800020  blr        
8046d6c0: 9421ffd0  stwu       r1, -0x30(r1)
8046d6c4: 7c0802a6  mflr       r0
8046d6c8: 90010034  stw        r0, 0x34(r1)
8046d6cc: bf010010  stmw       r24, 0x10(r1)
8046d6d0: 7c781b78  mr         r24, r3
8046d6d4: 3b400000  li         r26, 0
8046d6d8: 3be00000  li         r31, 0
8046d6dc: 3bc00000  li         r30, 0
8046d6e0: 3b800000  li         r28, 0
8046d6e4: 7f78fa14  add        r27, r24, r31
8046d6e8: 3b200000  li         r25, 0
8046d6ec: 3ba00000  li         r29, 0
8046d6f0: 7c7be82e  lwzx       r3, r27, r29
8046d6f4: 4bdd11d9  bl         0x8023e8cc
8046d6f8: 3b390001  addi       r25, r25, 1
8046d6fc: 3bbd0004  addi       r29, r29, 4
8046d700: 2c190002  cmpwi      r25, 2
8046d704: 4180ffec  blt        0x8046d6f0
8046d708: 3b5a0001  addi       r26, r26, 1
8046d70c: 7c78f214  add        r3, r24, r30
8046d710: 2c1a0003  cmpwi      r26, 3
8046d714: 93830018  stw        r28, 0x18(r3)
8046d718: 3bff0008  addi       r31, r31, 8
8046d71c: 3bde0004  addi       r30, r30, 4
8046d720: 4180ffc4  blt        0x8046d6e4
8046d724: bb010010  lmw        r24, 0x10(r1)
8046d728: 80010034  lwz        r0, 0x34(r1)
8046d72c: 7c0803a6  mtlr       r0
8046d730: 38210030  addi       r1, r1, 0x30
8046d734: 4e800020  blr        
8046d738: 9421ffd0  stwu       r1, -0x30(r1)
8046d73c: 7c0802a6  mflr       r0
8046d740: 90010034  stw        r0, 0x34(r1)
8046d744: bf010010  stmw       r24, 0x10(r1)
8046d748: 7c781b78  mr         r24, r3
8046d74c: 3b400000  li         r26, 0
8046d750: 3be00000  li         r31, 0
8046d754: 3bc00000  li         r30, 0
8046d758: 3b800000  li         r28, 0
8046d75c: 7f78fa14  add        r27, r24, r31
8046d760: 3b200000  li         r25, 0
8046d764: 3ba00000  li         r29, 0
8046d768: 7c7be82e  lwzx       r3, r27, r29
8046d76c: 4bdd10c1  bl         0x8023e82c
8046d770: 3b390001  addi       r25, r25, 1
8046d774: 3bbd0004  addi       r29, r29, 4
8046d778: 2c190002  cmpwi      r25, 2
8046d77c: 4180ffec  blt        0x8046d768
8046d780: 3b5a0001  addi       r26, r26, 1
8046d784: 7c78f214  add        r3, r24, r30
8046d788: 2c1a0003  cmpwi      r26, 3
8046d78c: 93830018  stw        r28, 0x18(r3)
8046d790: 3bff0008  addi       r31, r31, 8
8046d794: 3bde0004  addi       r30, r30, 4
8046d798: 4180ffc4  blt        0x8046d75c
8046d79c: 38000000  li         r0, 0
8046d7a0: 90180024  stw        r0, 0x24(r24)
8046d7a4: bb010010  lmw        r24, 0x10(r1)
8046d7a8: 80010034  lwz        r0, 0x34(r1)
8046d7ac: 7c0803a6  mtlr       r0
8046d7b0: 38210030  addi       r1, r1, 0x30
8046d7b4: 4e800020  blr        
8046d7b8: 9421ffd0  stwu       r1, -0x30(r1)
8046d7bc: 7c0802a6  mflr       r0
8046d7c0: 90010034  stw        r0, 0x34(r1)
8046d7c4: bf010010  stmw       r24, 0x10(r1)
8046d7c8: 3f80806e  lis        r28, -0x7f92
8046d7cc: 7c781b78  mr         r24, r3
8046d7d0: 3b400000  li         r26, 0
8046d7d4: 3b9ca008  addi       r28, r28, -0x5ff8
8046d7d8: 3be00000  li         r31, 0
8046d7dc: 3bc00000  li         r30, 0
8046d7e0: 7f78fa14  add        r27, r24, r31
8046d7e4: 3b200000  li         r25, 0
8046d7e8: 3ba00000  li         r29, 0
8046d7ec: 38600118  li         r3, 0x118
8046d7f0: 4bd54459  bl         0x801c1c48
8046d7f4: 2c030000  cmpwi      r3, 0
8046d7f8: 41820010  beq        0x8046d808
8046d7fc: 7c9cf02e  lwzx       r4, r28, r30
