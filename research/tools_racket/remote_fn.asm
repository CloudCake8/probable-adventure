804589e8: 9421ff10  stwu       r1, -0xf0(r1)
804589ec: 7c0802a6  mflr       r0
804589f0: 900100f4  stw        r0, 0xf4(r1)
804589f4: 396100e0  addi       r11, r1, 0xe0
804589f8: dbe100e0  stfd       f31, 0xe0(r1)
804589fc: f3e100e8  psq_st     f31, 232(r1), W=0, I=0
80458a00: 4bbaee2d  bl         0x8000782c
80458a04: 3ba00000  li         r29, 0
80458a08: 93a30060  stw        r29, 0x60(r3)
80458a0c: 80030008  lwz        r0, 8(r3)
80458a10: 3e20807d  lis        r17, -0x7f83
80458a14: 808dd678  lwz        r4, -0x2988(r13)
80458a18: 7c741b78  mr         r20, r3
80458a1c: 5400103a  slwi       r0, r0, 2
80458a20: 3be3019c  addi       r31, r3, 0x19c
80458a24: 80840154  lwz        r4, 0x154(r4)
80458a28: 3b810070  addi       r28, r1, 0x70
80458a2c: c3e20d38  lfs        f31, 0xd38(r2) ; [806fedb8] 00000000 f32=0
80458a30: 3b410064  addi       r26, r1, 0x64
80458a34: 7c640214  add        r3, r4, r0
80458a38: 3b610028  addi       r27, r1, 0x28
80458a3c: 82c30008  lwz        r22, 8(r3)
80458a40: 3b210034  addi       r25, r1, 0x34
80458a44: 3ae10058  addi       r23, r1, 0x58
80458a48: 3b01004c  addi       r24, r1, 0x4c
80458a4c: 82b6093c  lwz        r21, 0x93c(r22)
80458a50: 3a510318  addi       r18, r17, 0x318
80458a54: 3a0dcfe8  addi       r16, r13, -0x3018
80458a58: 3a600001  li         r19, 1
80458a5c: 480003f8  b          0x80458e54
80458a60: 3861007c  addi       r3, r1, 0x7c
80458a64: 38940030  addi       r4, r20, 0x30
80458a68: 4bdab701  bl         0x80204168
80458a6c: 38610088  addi       r3, r1, 0x88
80458a70: 3894003c  addi       r4, r20, 0x3c
80458a74: 4bdab6f5  bl         0x80204168
80458a78: 38610094  addi       r3, r1, 0x94
80458a7c: 38940048  addi       r4, r20, 0x48
80458a80: 4bdab6e9  bl         0x80204168
80458a84: 7ec3b378  mr         r3, r22
80458a88: 7ea4ab78  mr         r4, r21
80458a8c: 4bf23651  bl         0x8037c0dc
80458a90: c0030000  lfs        f0, 0(r3)
80458a94: 7c7e1b78  mr         r30, r3
80458a98: d014000c  stfs       f0, 0xc(r20)
80458a9c: e0340024  psq_l      f1, 36(r20), W=0, I=0
80458aa0: c0030004  lfs        f0, 4(r3)
80458aa4: d0140010  stfs       f0, 0x10(r20)
80458aa8: c0030008  lfs        f0, 8(r3)
80458aac: d0140014  stfs       f0, 0x14(r20)
80458ab0: 80830050  lwz        r4, 0x50(r3)
80458ab4: 80030054  lwz        r0, 0x54(r3)
80458ab8: 90140034  stw        r0, 0x34(r20)
80458abc: 90940030  stw        r4, 0x30(r20)
80458ac0: 80030058  lwz        r0, 0x58(r3)
80458ac4: 90140038  stw        r0, 0x38(r20)
80458ac8: 8083005c  lwz        r4, 0x5c(r3)
80458acc: 80030060  lwz        r0, 0x60(r3)
80458ad0: 90140040  stw        r0, 0x40(r20)
80458ad4: 9094003c  stw        r4, 0x3c(r20)
80458ad8: 80030064  lwz        r0, 0x64(r3)
80458adc: 90140044  stw        r0, 0x44(r20)
80458ae0: 80830068  lwz        r4, 0x68(r3)
80458ae4: 8003006c  lwz        r0, 0x6c(r3)
80458ae8: 9014004c  stw        r0, 0x4c(r20)
80458aec: 90940048  stw        r4, 0x48(r20)
80458af0: 80030070  lwz        r0, 0x70(r3)
80458af4: 90140050  stw        r0, 0x50(r20)
80458af8: e003000c  psq_l      f0, 12(r3), W=0, I=0
80458afc: 10000828  ps_sub     f0, f0, f1
80458b00: f01c0000  psq_st     f0, 0(r28), W=0, I=0
80458b04: e0038014  psq_l      f0, 20(r3), W=1, I=0
80458b08: 7f83e378  mr         r3, r28
80458b0c: e034802c  psq_l      f1, 44(r20), W=1, I=0
80458b10: 10000828  ps_sub     f0, f0, f1
80458b14: f01c8008  psq_st     f0, 8(r28), W=1, I=0
80458b18: 4bbe6c99  bl         0x8003f7b0
80458b1c: 807401a0  lwz        r3, 0x1a0(r20)
80458b20: d0230000  stfs       f1, 0(r3)
80458b24: 807401a0  lwz        r3, 0x1a0(r20)
80458b28: 38030004  addi       r0, r3, 4
80458b2c: 901401a0  stw        r0, 0x1a0(r20)
80458b30: 7c00f840  cmplw      r0, r31
80458b34: 4081000c  ble        0x80458b40
80458b38: 381400d8  addi       r0, r20, 0xd8
80458b3c: 901401a0  stw        r0, 0x1a0(r20)
80458b40: 38610094  addi       r3, r1, 0x94
80458b44: 38940048  addi       r4, r20, 0x48
80458b48: 38a10064  addi       r5, r1, 0x64
80458b4c: 4bbe6cd5  bl         0x8003f820
80458b50: e07a0000  psq_l      f3, 0(r26), W=0, I=0
80458b54: e0540054  psq_l      f2, 84(r20), W=0, I=0
80458b58: 807401a8  lwz        r3, 0x1a8(r20)
80458b5c: 10231028  ps_sub     f1, f3, f2
80458b60: c00d9d78  lfs        f0, -0x6288(r13) ; [806f1e98] 3f800000 f32=1
80458b64: e07a8008  psq_l      f3, 8(r26), W=1, I=0
80458b68: 2c030000  cmpwi      r3, 0
80458b6c: e054805c  psq_l      f2, 92(r20), W=1, I=0
80458b70: 10800890  ps_mr      f4, f1
80458b74: f03b0000  psq_st     f1, 0(r27), W=0, I=0
80458b78: 10231028  ps_sub     f1, f3, f2
80458b7c: e0b40054  psq_l      f5, 84(r20), W=0, I=0
80458b80: 10640018  ps_muls0   f3, f4, f0
80458b84: f03b8008  psq_st     f1, 8(r27), W=1, I=0
80458b88: f0790000  psq_st     f3, 0(r25), W=0, I=0
80458b8c: 10610018  ps_muls0   f3, f1, f0
80458b90: e0190000  psq_l      f0, 0(r25), W=0, I=0
80458b94: f0798008  psq_st     f3, 8(r25), W=1, I=0
80458b98: 1005002a  ps_add     f0, f5, f0
80458b9c: f0140054  psq_st     f0, 84(r20), W=0, I=0
80458ba0: 1002182a  ps_add     f0, f2, f3
80458ba4: f014805c  psq_st     f0, 92(r20), W=1, I=0
80458ba8: c01e000c  lfs        f0, 0xc(r30)
80458bac: d0140024  stfs       f0, 0x24(r20)
80458bb0: c01e0010  lfs        f0, 0x10(r30)
80458bb4: d0140028  stfs       f0, 0x28(r20)
80458bb8: c01e0014  lfs        f0, 0x14(r30)
80458bbc: d014002c  stfs       f0, 0x2c(r20)
80458bc0: 40810034  ble        0x80458bf4
80458bc4: 809401a0  lwz        r4, 0x1a0(r20)
80458bc8: 3863ffff  addi       r3, r3, -1
80458bcc: 381400d8  addi       r0, r20, 0xd8
80458bd0: 907401a8  stw        r3, 0x1a8(r20)
80458bd4: 3884fffc  addi       r4, r4, -4
80458bd8: 7c040040  cmplw      r4, r0
80458bdc: 40800008  bge        0x80458be4
80458be0: 3894019c  addi       r4, r20, 0x19c
80458be4: c03401a4  lfs        f1, 0x1a4(r20)
80458be8: c0040000  lfs        f0, 0(r4)
80458bec: ec01002a  fadds      f0, f1, f0
80458bf0: d01401a4  stfs       f0, 0x1a4(r20)
80458bf4: 7e83a378  mr         r3, r20
80458bf8: 38940030  addi       r4, r20, 0x30
80458bfc: 38be0050  addi       r5, r30, 0x50
80458c00: 4bfffcad  bl         0x804588ac
80458c04: c0140034  lfs        f0, 0x34(r20)
80458c08: 38610020  addi       r3, r1, 0x20
80458c0c: c0340040  lfs        f1, 0x40(r20)
80458c10: 7c641b78  mr         r4, r3
80458c14: fc400050  fneg       f2, f0
80458c18: c014004c  lfs        f0, 0x4c(r20)
80458c1c: fc200850  fneg       f1, f1
80458c20: e0740024  psq_l      f3, 36(r20), W=0, I=0
80458c24: d0410058  stfs       f2, 0x58(r1)
80458c28: fc000050  fneg       f0, f0
80458c2c: d021005c  stfs       f1, 0x5c(r1)
80458c30: e0370000  psq_l      f1, 0(r23), W=0, I=0
80458c34: d0010060  stfs       f0, 0x60(r1)
80458c38: 10030828  ps_sub     f0, f3, f1
80458c3c: e0378008  psq_l      f1, 8(r23), W=1, I=0
80458c40: f0180000  psq_st     f0, 0(r24), W=0, I=0
80458c44: e074802c  psq_l      f3, 44(r20), W=1, I=0
80458c48: c0410050  lfs        f2, 0x50(r1)
80458c4c: 10030828  ps_sub     f0, f3, f1
80458c50: c021004c  lfs        f1, 0x4c(r1)
80458c54: d0210020  stfs       f1, 0x20(r1)
80458c58: f0188008  psq_st     f0, 8(r24), W=1, I=0
80458c5c: d0410024  stfs       f2, 0x24(r1)
80458c60: 4becf351  bl         0x80327fb0
80458c64: fc01f800  fcmpu      cr0, f1, f31
80458c68: 40820014  bne        0x80458c7c
80458c6c: c02dcfe8  lfs        f1, -0x3018(r13)
80458c70: c0100004  lfs        f0, 4(r16)
80458c74: d0210020  stfs       f1, 0x20(r1)
80458c78: d0010024  stfs       f0, 0x24(r1)
80458c7c: c0140010  lfs        f0, 0x10(r20)
80458c80: 38610018  addi       r3, r1, 0x18
80458c84: c034000c  lfs        f1, 0xc(r20)
80458c88: 7c641b78  mr         r4, r3
80458c8c: fc000050  fneg       f0, f0
80458c90: d021001c  stfs       f1, 0x1c(r1)
80458c94: d0010018  stfs       f0, 0x18(r1)
80458c98: 4becf319  bl         0x80327fb0
80458c9c: fc01f800  fcmpu      cr0, f1, f31
80458ca0: 40820014  bne        0x80458cb4
80458ca4: c02dcfe8  lfs        f1, -0x3018(r13)
80458ca8: c0100004  lfs        f0, 4(r16)
80458cac: d0210018  stfs       f1, 0x18(r1)
80458cb0: d001001c  stfs       f0, 0x1c(r1)
80458cb4: c0340010  lfs        f1, 0x10(r20)
80458cb8: c054000c  lfs        f2, 0xc(r20)
80458cbc: c0010024  lfs        f0, 0x24(r1)
80458cc0: fc600850  fneg       f3, f1
80458cc4: c0210020  lfs        f1, 0x20(r1)
80458cc8: ec420032  fmuls      f2, f2, f0
80458ccc: c00d9d50  lfs        f0, -0x62b0(r13) ; [806f1e70] 3dcccccd f32=0.100000001
80458cd0: ec23107a  fmadds     f1, f3, f1, f2
80458cd4: fc010040  fcmpo      cr0, f1, f0
80458cd8: 40810034  ble        0x80458d0c
80458cdc: 3861004c  addi       r3, r1, 0x4c
80458ce0: 4bbe6ad1  bl         0x8003f7b0
80458ce4: c0010018  lfs        f0, 0x18(r1)
80458ce8: fc000050  fneg       f0, f0
80458cec: ec000072  fmuls      f0, f0, f1
80458cf0: d014006c  stfs       f0, 0x6c(r20)
80458cf4: c001001c  lfs        f0, 0x1c(r1)
80458cf8: fc000050  fneg       f0, f0
80458cfc: d3f40074  stfs       f31, 0x74(r20)
80458d00: ec000072  fmuls      f0, f0, f1
80458d04: d0140070  stfs       f0, 0x70(r20)
80458d08: 4800001c  b          0x80458d24
80458d0c: c0110318  lfs        f0, 0x318(r17)
80458d10: d014006c  stfs       f0, 0x6c(r20)
80458d14: c0120004  lfs        f0, 4(r18)
80458d18: d0140070  stfs       f0, 0x70(r20)
80458d1c: c0120008  lfs        f0, 8(r18)
80458d20: d0140074  stfs       f0, 0x74(r20)
80458d24: c0340040  lfs        f1, 0x40(r20)
80458d28: 38610008  addi       r3, r1, 8
80458d2c: c0140034  lfs        f0, 0x34(r20)
80458d30: 7c641b78  mr         r4, r3
80458d34: c0540070  lfs        f2, 0x70(r20)
80458d38: fc600850  fneg       f3, f1
80458d3c: c034006c  lfs        f1, 0x6c(r20)
80458d40: fc000050  fneg       f0, f0
80458d44: d0210010  stfs       f1, 0x10(r1)
80458d48: d0410014  stfs       f2, 0x14(r1)
80458d4c: d0010008  stfs       f0, 8(r1)
80458d50: d061000c  stfs       f3, 0xc(r1)
80458d54: 4becf25d  bl         0x80327fb0
80458d58: fc01f800  fcmpu      cr0, f1, f31
80458d5c: 41820080  beq        0x80458ddc
80458d60: c021000c  lfs        f1, 0xc(r1)
80458d64: c0010008  lfs        f0, 8(r1)
80458d68: c0c10014  lfs        f6, 0x14(r1)
80458d6c: fc400850  fneg       f2, f1
80458d70: c0a10010  lfs        f5, 0x10(r1)
80458d74: ec2001b2  fmuls      f1, f0, f6
80458d78: c0940010  lfs        f4, 0x10(r20)
80458d7c: c074000c  lfs        f3, 0xc(r20)
80458d80: c0140014  lfs        f0, 0x14(r20)
80458d84: ec22097a  fmadds     f1, f2, f5, f1
80458d88: d034006c  stfs       f1, 0x6c(r20)
80458d8c: c0410008  lfs        f2, 8(r1)
80458d90: c021000c  lfs        f1, 0xc(r1)
80458d94: fc401050  fneg       f2, f2
80458d98: ec2101b2  fmuls      f1, f1, f6
80458d9c: ec220978  fmsubs     f1, f2, f5, f1
80458da0: d0340070  stfs       f1, 0x70(r20)
80458da4: c041000c  lfs        f2, 0xc(r1)
80458da8: c0210008  lfs        f1, 8(r1)
80458dac: fc401050  fneg       f2, f2
80458db0: ec210132  fmuls      f1, f1, f4
80458db4: ec2208fa  fmadds     f1, f2, f3, f1
80458db8: d0340018  stfs       f1, 0x18(r20)
80458dbc: c0410008  lfs        f2, 8(r1)
80458dc0: c021000c  lfs        f1, 0xc(r1)
80458dc4: fc401050  fneg       f2, f2
80458dc8: ec210132  fmuls      f1, f1, f4
80458dcc: d0140020  stfs       f0, 0x20(r20)
80458dd0: ec0208f8  fmsubs     f0, f2, f3, f1
80458dd4: d014001c  stfs       f0, 0x1c(r20)
80458dd8: 4800001c  b          0x80458df4
80458ddc: c054000c  lfs        f2, 0xc(r20)
80458de0: c0340010  lfs        f1, 0x10(r20)
80458de4: c0140014  lfs        f0, 0x14(r20)
80458de8: d0540018  stfs       f2, 0x18(r20)
80458dec: d034001c  stfs       f1, 0x1c(r20)
80458df0: d0140020  stfs       f0, 0x20(r20)
80458df4: 7e83a378  mr         r3, r20
80458df8: 4bfff871  bl         0x80458668
80458dfc: 7e83a378  mr         r3, r20
80458e00: 4bfff99d  bl         0x8045879c
80458e04: 7e83a378  mr         r3, r20
80458e08: 4bfff7d1  bl         0x804585d8
80458e0c: 80140068  lwz        r0, 0x68(r20)
80458e10: 2c000000  cmpwi      r0, 0
80458e14: 41820024  beq        0x80458e38
80458e18: 2c030000  cmpwi      r3, 0
80458e1c: 40820010  bne        0x80458e2c
80458e20: 93b40068  stw        r29, 0x68(r20)
80458e24: d3f40080  stfs       f31, 0x80(r20)
80458e28: 4800002c  b          0x80458e54
80458e2c: 7e83a378  mr         r3, r20
80458e30: 4bfff351  bl         0x80458180
80458e34: 48000020  b          0x80458e54
80458e38: 2c030000  cmpwi      r3, 0
80458e3c: 41820018  beq        0x80458e54
80458e40: 92740068  stw        r19, 0x68(r20)
80458e44: 7e83a378  mr         r3, r20
80458e48: 4bfff2b5  bl         0x804580fc
80458e4c: 7e83a378  mr         r3, r20
80458e50: 4bfff331  bl         0x80458180
80458e54: 36b5ffff  addic.     r21, r21, -1
80458e58: 4080fc08  bge        0x80458a60
80458e5c: 80740008  lwz        r3, 8(r20)
80458e60: 4bf24071  bl         0x8037ced0
80458e64: 801401a8  lwz        r0, 0x1a8(r20)
80458e68: 2c000000  cmpwi      r0, 0
80458e6c: 41810060  bgt        0x80458ecc
80458e70: 8003001c  lwz        r0, 0x1c(r3)
80458e74: 54000529  rlwinm.    r0, r0, 0, 0x14, 0x14
80458e78: 41820054  beq        0x80458ecc
80458e7c: 80740060  lwz        r3, 0x60(r20)
80458e80: 381400d8  addi       r0, r20, 0xd8
80458e84: c0020d38  lfs        f0, 0xd38(r2) ; [806fedb8] 00000000 f32=0
80458e88: 38800008  li         r4, 8
80458e8c: 60630004  ori        r3, r3, 4
80458e90: 90740060  stw        r3, 0x60(r20)
80458e94: 807401a0  lwz        r3, 0x1a0(r20)
80458e98: d01401a4  stfs       f0, 0x1a4(r20)
80458e9c: 3863fffc  addi       r3, r3, -4
80458ea0: 7c030040  cmplw      r3, r0
80458ea4: 40800008  bge        0x80458eac
80458ea8: 3874019c  addi       r3, r20, 0x19c
80458eac: c03401a4  lfs        f1, 0x1a4(r20)
80458eb0: 3484ffff  addic.     r4, r4, -1
80458eb4: c0030000  lfs        f0, 0(r3)
80458eb8: ec01002a  fadds      f0, f1, f0
80458ebc: d01401a4  stfs       f0, 0x1a4(r20)
80458ec0: 4080ffdc  bge        0x80458e9c
80458ec4: 38000008  li         r0, 8
80458ec8: 901401a8  stw        r0, 0x1a8(r20)
80458ecc: c05401bc  lfs        f2, 0x1bc(r20)
80458ed0: c01401c0  lfs        f0, 0x1c0(r20)
80458ed4: c02d9d9c  lfs        f1, -0x6264(r13) ; [806f1ebc] 3f000000 f32=0.5
80458ed8: ec420028  fsubs      f2, f2, f0
80458edc: c00d9da0  lfs        f0, -0x6260(r13) ; [806f1ec0] 41a00000 f32=20
80458ee0: ec2100b2  fmuls      f1, f1, f2
80458ee4: fc010040  fcmpo      cr0, f1, f0
80458ee8: 4081000c  ble        0x80458ef4
80458eec: fc200090  fmr        f1, f0
80458ef0: 48000014  b          0x80458f04
80458ef4: fc000050  fneg       f0, f0
80458ef8: fc010040  fcmpo      cr0, f1, f0
80458efc: 40800008  bge        0x80458f04
80458f00: fc200090  fmr        f1, f0
80458f04: c01401c0  lfs        f0, 0x1c0(r20)
80458f08: 801401ac  lwz        r0, 0x1ac(r20)
80458f0c: ec60082a  fadds      f3, f0, f1
80458f10: 2c000001  cmpwi      r0, 1
80458f14: d07401c0  stfs       f3, 0x1c0(r20)
80458f18: 4082002c  bne        0x80458f44
80458f1c: c02d9d90  lfs        f1, -0x6270(r13) ; [806f1eb0] 41a00000 f32=20
80458f20: c00d9d94  lfs        f0, -0x626c(r13) ; [806f1eb4] 40a00000 f32=5
80458f24: fc200850  fneg       f1, f1
80458f28: ec01002a  fadds      f0, f1, f0
80458f2c: fc030040  fcmpo      cr0, f3, f0
80458f30: 4c411382  cror       cr0eq, cr0gt, cr0eq
80458f34: 4082007c  bne        0x80458fb0
80458f38: 38000002  li         r0, 2
80458f3c: 901401ac  stw        r0, 0x1ac(r20)
80458f40: 48000070  b          0x80458fb0
80458f44: 2c000000  cmpwi      r0, 0
80458f48: 40820028  bne        0x80458f70
80458f4c: c02d9d90  lfs        f1, -0x6270(r13) ; [806f1eb0] 41a00000 f32=20
80458f50: c00d9d94  lfs        f0, -0x626c(r13) ; [806f1eb4] 40a00000 f32=5
80458f54: ec010028  fsubs      f0, f1, f0
80458f58: fc030040  fcmpo      cr0, f3, f0
80458f5c: 4c401382  cror       cr0eq, cr0lt, cr0eq
80458f60: 40820050  bne        0x80458fb0
80458f64: 38000002  li         r0, 2
80458f68: 901401ac  stw        r0, 0x1ac(r20)
80458f6c: 48000044  b          0x80458fb0
80458f70: c04d9d90  lfs        f2, -0x6270(r13) ; [806f1eb0] 41a00000 f32=20
80458f74: c02d9d94  lfs        f1, -0x626c(r13) ; [806f1eb4] 40a00000 f32=5
80458f78: ec02082a  fadds      f0, f2, f1
80458f7c: fc030040  fcmpo      cr0, f3, f0
80458f80: 4c411382  cror       cr0eq, cr0gt, cr0eq
80458f84: 40820010  bne        0x80458f94
80458f88: 38000000  li         r0, 0
80458f8c: 901401ac  stw        r0, 0x1ac(r20)
80458f90: 48000020  b          0x80458fb0
80458f94: fc001050  fneg       f0, f2
80458f98: ec000828  fsubs      f0, f0, f1
80458f9c: fc030040  fcmpo      cr0, f3, f0
80458fa0: 4c401382  cror       cr0eq, cr0lt, cr0eq
80458fa4: 4082000c  bne        0x80458fb0
80458fa8: 38000001  li         r0, 1
80458fac: 901401ac  stw        r0, 0x1ac(r20)
80458fb0: 7ec3b378  mr         r3, r22
80458fb4: 38800000  li         r4, 0
80458fb8: 4bf23125  bl         0x8037c0dc
80458fbc: 8003004c  lwz        r0, 0x4c(r3)
80458fc0: 90010048  stw        r0, 0x48(r1)
80458fc4: 80030044  lwz        r0, 0x44(r3)
80458fc8: c0010048  lfs        f0, 0x48(r1)
80458fcc: 90010040  stw        r0, 0x40(r1)
80458fd0: ec200032  fmuls      f1, f0, f0
80458fd4: 80030048  lwz        r0, 0x48(r3)
80458fd8: c0010040  lfs        f0, 0x40(r1)
80458fdc: c0420d38  lfs        f2, 0xd38(r2) ; [806fedb8] 00000000 f32=0
80458fe0: efe0083a  fmadds     f31, f0, f0, f1
80458fe4: 90010044  stw        r0, 0x44(r1)
80458fe8: fc1f1040  fcmpo      cr0, f31, f2
80458fec: 4c401382  cror       cr0eq, cr0lt, cr0eq
80458ff0: 40820008  bne        0x80458ff8
80458ff4: 48000010  b          0x80459004
80458ff8: fc20f890  fmr        f1, f31
80458ffc: 4bce2a55  bl         0x8013ba50
80459000: ec5f0072  fmuls      f2, f31, f1
80459004: c002d314  lfs        f0, -0x2cec(r2) ; [806fb394] 358637bd f32=9.99999997e-07
80459008: fc020040  fcmpo      cr0, f2, f0
8045900c: 4c411382  cror       cr0eq, cr0gt, cr0eq
80459010: 40820048  bne        0x80459058
80459014: c0210048  lfs        f1, 0x48(r1)
80459018: c0020d30  lfs        f0, 0xd30(r2) ; [806fedb0] 3f800000 f32=1
8045901c: ec211024  fdivs      f1, f1, f2
80459020: d0210048  stfs       f1, 0x48(r1)
80459024: fc010040  fcmpo      cr0, f1, f0
80459028: 4081000c  ble        0x80459034
8045902c: d0010048  stfs       f0, 0x48(r1)
80459030: 48000014  b          0x80459044
80459034: c0020d44  lfs        f0, 0xd44(r2) ; [806fedc4] bf800000 f32=-1
80459038: fc010040  fcmpo      cr0, f1, f0
8045903c: 40800008  bge        0x80459044
80459040: d0010048  stfs       f0, 0x48(r1)
80459044: c0210048  lfs        f1, 0x48(r1)
80459048: 4bbbddb1  bl         0x80016df8
8045904c: c0210040  lfs        f1, 0x40(r1)
80459050: c0020d38  lfs        f0, 0xd38(r2) ; [806fedb8] 00000000 f32=0
80459054: fc010040  fcmpo      cr0, f1, f0
80459058: 396100e0  addi       r11, r1, 0xe0
8045905c: e3e100e8  psq_l      f31, 232(r1), W=0, I=0
80459060: cbe100e0  lfd        f31, 0xe0(r1)
80459064: 4bbae815  bl         0x80007878
80459068: 800100f4  lwz        r0, 0xf4(r1)
8045906c: 7c0803a6  mtlr       r0
80459070: 382100f0  addi       r1, r1, 0xf0
80459074: 4e800020  blr        
