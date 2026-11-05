804732d8: 9421fc80  stwu       r1, -0x380(r1)
804732dc: 7c0802a6  mflr       r0
804732e0: 90010384  stw        r0, 0x384(r1)
804732e4: 39610340  addi       r11, r1, 0x340
804732e8: dbe10370  stfd       f31, 0x370(r1)
804732ec: f3e10378  psq_st     f31, 888(r1), W=0, I=0
804732f0: dbc10360  stfd       f30, 0x360(r1)
804732f4: f3c10368  psq_st     f30, 872(r1), W=0, I=0
804732f8: dba10350  stfd       f29, 0x350(r1)
804732fc: f3a10358  psq_st     f29, 856(r1), W=0, I=0
80473300: db810340  stfd       f28, 0x340(r1)
80473304: f3810348  psq_st     f28, 840(r1), W=0, I=0
80473308: 4bb94555  bl         0x8000785c
8047330c: c02211d8  lfs        f1, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473310: 7c7f1b78  mr         r31, r3
80473314: c0030374  lfs        f0, 0x374(r3)
80473318: 389f00d4  addi       r4, r31, 0xd4
8047331c: c04300e0  lfs        f2, 0xe0(r3)
80473320: ec810028  fsubs      f4, f1, f0
80473324: c0630430  lfs        f3, 0x430(r3)
80473328: c0230100  lfs        f1, 0x100(r3)
8047332c: c00300f0  lfs        f0, 0xf0(r3)
80473330: 386102fc  addi       r3, r1, 0x2fc
80473334: ec630132  fmuls      f3, f3, f4
80473338: d0410158  stfs       f2, 0x158(r1)
8047333c: ec00182a  fadds      f0, f0, f3
80473340: d0210160  stfs       f1, 0x160(r1)
80473344: d001015c  stfs       f0, 0x15c(r1)
80473348: 4beb4b95  bl         0x80327edc
8047334c: 386102d8  addi       r3, r1, 0x2d8
80473350: 389f0104  addi       r4, r31, 0x104
80473354: 4beb4b89  bl         0x80327edc
80473358: 386102b4  addi       r3, r1, 0x2b4
8047335c: 389f0134  addi       r4, r31, 0x134
80473360: 4beb4b7d  bl         0x80327edc
80473364: c05f01d0  lfs        f2, 0x1d0(r31)
80473368: 38610290  addi       r3, r1, 0x290
8047336c: c03f01e0  lfs        f1, 0x1e0(r31)
80473370: 389f01c4  addi       r4, r31, 0x1c4
80473374: c01f01f0  lfs        f0, 0x1f0(r31)
80473378: d041014c  stfs       f2, 0x14c(r1)
8047337c: d0210024  stfs       f1, 0x24(r1)
80473380: d0010034  stfs       f0, 0x34(r1)
80473384: 4beb4b59  bl         0x80327edc
80473388: c05f0200  lfs        f2, 0x200(r31)
8047338c: 3861026c  addi       r3, r1, 0x26c
80473390: c03f0210  lfs        f1, 0x210(r31)
80473394: 389f01f4  addi       r4, r31, 0x1f4
80473398: c01f0220  lfs        f0, 0x220(r31)
8047339c: d0410140  stfs       f2, 0x140(r1)
804733a0: d021000c  stfs       f1, 0xc(r1)
804733a4: d001001c  stfs       f0, 0x1c(r1)
804733a8: 4beb4b35  bl         0x80327edc
804733ac: 807f000c  lwz        r3, 0xc(r31)
804733b0: c01f0010  lfs        f0, 0x10(r31)
804733b4: d003000c  stfs       f0, 0xc(r3)
804733b8: c01f0014  lfs        f0, 0x14(r31)
804733bc: d0030010  stfs       f0, 0x10(r3)
804733c0: c01f0018  lfs        f0, 0x18(r31)
804733c4: d0030014  stfs       f0, 0x14(r3)
804733c8: 809f000c  lwz        r4, 0xc(r31)
804733cc: 801f0020  lwz        r0, 0x20(r31)
804733d0: 807f001c  lwz        r3, 0x1c(r31)
804733d4: 90640024  stw        r3, 0x24(r4)
804733d8: 90040028  stw        r0, 0x28(r4)
804733dc: 801f0024  lwz        r0, 0x24(r31)
804733e0: 9004002c  stw        r0, 0x2c(r4)
804733e4: 801f002c  lwz        r0, 0x2c(r31)
804733e8: 807f0028  lwz        r3, 0x28(r31)
804733ec: 90640030  stw        r3, 0x30(r4)
804733f0: 90040034  stw        r0, 0x34(r4)
804733f4: 801f0030  lwz        r0, 0x30(r31)
804733f8: 90040038  stw        r0, 0x38(r4)
804733fc: 801f0038  lwz        r0, 0x38(r31)
80473400: 807f0034  lwz        r3, 0x34(r31)
80473404: 9064003c  stw        r3, 0x3c(r4)
80473408: 90040040  stw        r0, 0x40(r4)
8047340c: 801f003c  lwz        r0, 0x3c(r31)
80473410: 90040044  stw        r0, 0x44(r4)
80473414: 807f0008  lwz        r3, 8(r31)
80473418: 4bfebf8d  bl         0x8045f3a4
8047341c: 7c651b78  mr         r5, r3
80473420: 807f0008  lwz        r3, 8(r31)
80473424: 38810134  addi       r4, r1, 0x134
80473428: 4bfeb361  bl         0x8045e788
8047342c: 806dd678  lwz        r3, -0x2988(r13)
80473430: 3c004330  lis        r0, 0x4330
80473434: 90010320  stw        r0, 0x320(r1)
80473438: 38a10134  addi       r5, r1, 0x134
8047343c: 8063014c  lwz        r3, 0x14c(r3)
80473440: 389f01c4  addi       r4, r31, 0x1c4
80473444: c8221208  lfd        f1, 0x1208(r2) ; [806ff288] 43300000 f32=176
80473448: 381f01f4  addi       r0, r31, 0x1f4
8047344c: 6c638000  xoris      r3, r3, 0x8000
80473450: 90610324  stw        r3, 0x324(r1)
80473454: e0450000  psq_l      f2, 0(r5), W=0, I=0
80473458: c8010320  lfd        f0, 0x320(r1)
8047345c: ec000828  fsubs      f0, f0, f1
80473460: 10220018  ps_muls0   f1, f2, f0
80473464: e0458008  psq_l      f2, 8(r5), W=1, I=0
80473468: f0250000  psq_st     f1, 0(r5), W=0, I=0
8047346c: 10220018  ps_muls0   f1, f2, f0
80473470: f0258008  psq_st     f1, 8(r5), W=1, I=0
80473474: 807f000c  lwz        r3, 0xc(r31)
80473478: 90830048  stw        r4, 0x48(r3)
8047347c: 807f000c  lwz        r3, 0xc(r31)
80473480: 9003004c  stw        r0, 0x4c(r3)
80473484: 807f000c  lwz        r3, 0xc(r31)
80473488: c01f037c  lfs        f0, 0x37c(r31)
8047348c: d003025c  stfs       f0, 0x25c(r3)
80473490: 807f0008  lwz        r3, 8(r31)
80473494: 4bfeb285  bl         0x8045e718
80473498: 2c030001  cmpwi      r3, 1
8047349c: 40820020  bne        0x804734bc
804734a0: 807f0008  lwz        r3, 8(r31)
804734a4: 4bfeb495  bl         0x8045e938
804734a8: 809f000c  lwz        r4, 0xc(r31)
804734ac: 3003ffff  addic      r0, r3, -1
804734b0: 7c001910  subfe      r0, r0, r3
804734b4: 90040254  stw        r0, 0x254(r4)
804734b8: 4800002c  b          0x804734e4
804734bc: 807f0008  lwz        r3, 8(r31)
804734c0: 4bfeb259  bl         0x8045e718
804734c4: 2c030000  cmpwi      r3, 0
804734c8: 4082001c  bne        0x804734e4
804734cc: 807f0008  lwz        r3, 8(r31)
804734d0: 4bfeb469  bl         0x8045e938
804734d4: 809f000c  lwz        r4, 0xc(r31)
804734d8: 7c600034  cntlzw     r0, r3
804734dc: 5400d97e  srwi       r0, r0, 5
804734e0: 90040254  stw        r0, 0x254(r4)
804734e4: 807f000c  lwz        r3, 0xc(r31)
804734e8: 48007065  bl         0x8047a54c
804734ec: 839f000c  lwz        r28, 0xc(r31)
804734f0: 389f0314  addi       r4, r31, 0x314
804734f4: c01c00b4  lfs        f0, 0xb4(r28)
804734f8: 387c00cc  addi       r3, r28, 0xcc
804734fc: d01f0320  stfs       f0, 0x320(r31)
80473500: c01c00b8  lfs        f0, 0xb8(r28)
80473504: d01f0330  stfs       f0, 0x330(r31)
80473508: c01c00bc  lfs        f0, 0xbc(r28)
8047350c: d01f0340  stfs       f0, 0x340(r31)
80473510: 4beb4a11  bl         0x80327f20
80473514: c01c00c0  lfs        f0, 0xc0(r28)
80473518: 389f0344  addi       r4, r31, 0x344
8047351c: d01f0350  stfs       f0, 0x350(r31)
80473520: 807f000c  lwz        r3, 0xc(r31)
80473524: c01c00c4  lfs        f0, 0xc4(r28)
80473528: d01f0360  stfs       f0, 0x360(r31)
8047352c: 386300f0  addi       r3, r3, 0xf0
80473530: c01c00c8  lfs        f0, 0xc8(r28)
80473534: d01f0370  stfs       f0, 0x370(r31)
80473538: 4beb49e9  bl         0x80327f20
8047353c: c05c00b4  lfs        f2, 0xb4(r28)
80473540: c01c00c0  lfs        f0, 0xc0(r28)
80473544: c0221210  lfs        f1, 0x1210(r2) ; [806ff290] 3f000000 f32=0.5
80473548: ec42002a  fadds      f2, f2, f0
8047354c: c0010158  lfs        f0, 0x158(r1)
80473550: 807f000c  lwz        r3, 0xc(r31)
80473554: ec0100b8  fmsubs     f0, f1, f2, f0
80473558: d0010128  stfs       f0, 0x128(r1)
8047355c: 48006fd1  bl         0x8047a52c
80473560: c06211d8  lfs        f3, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473564: fc000818  frsp       f0, f1
80473568: c05f037c  lfs        f2, 0x37c(r31)
8047356c: 38e10128  addi       r7, r1, 0x128
80473570: c0821210  lfs        f4, 0x1210(r2) ; [806ff290] 3f000000 f32=0.5
80473574: 38c10098  addi       r6, r1, 0x98
80473578: ec631028  fsubs      f3, f3, f2
8047357c: c0210128  lfs        f1, 0x128(r1)
80473580: 390100a4  addi       r8, r1, 0xa4
80473584: c0dc00bc  lfs        f6, 0xbc(r28)
80473588: 39210158  addi       r9, r1, 0x158
8047358c: ec4400f2  fmuls      f2, f4, f3
80473590: c0bc00c8  lfs        f5, 0xc8(r28)
80473594: ec0000f2  fmuls      f0, f0, f3
80473598: c0610160  lfs        f3, 0x160(r1)
8047359c: 3861011c  addi       r3, r1, 0x11c
804735a0: ec2100b2  fmuls      f1, f1, f2
804735a4: eca6282a  fadds      f5, f6, f5
804735a8: d001012c  stfs       f0, 0x12c(r1)
804735ac: e0ff046c  psq_l      f7, 1132(r31), W=0, I=0
804735b0: 389f001c  addi       r4, r31, 0x1c
804735b4: d0210128  stfs       f1, 0x128(r1)
804735b8: ec041978  fmsubs     f0, f4, f5, f3
804735bc: e0870000  psq_l      f4, 0(r7), W=0, I=0
804735c0: 10a03890  ps_mr      f5, f7
804735c4: c06da068  lfs        f3, -0x5f98(r13) ; [806f2188] 3dcccccd f32=0.100000001
804735c8: 38bf03d4  addi       r5, r31, 0x3d4
804735cc: 10243828  ps_sub     f1, f4, f7
804735d0: ec0000b2  fmuls      f0, f0, f2
804735d4: e0ff8474  psq_l      f7, 1140(r31), W=1, I=0
804735d8: f0260000  psq_st     f1, 0(r6), W=0, I=0
804735dc: e0490000  psq_l      f2, 0(r9), W=0, I=0
804735e0: d0010130  stfs       f0, 0x130(r1)
804735e4: 10000890  ps_mr      f0, f1
804735e8: e0878008  psq_l      f4, 8(r7), W=1, I=0
804735ec: 100000d8  ps_muls0   f0, f0, f3
804735f0: 10243828  ps_sub     f1, f4, f7
804735f4: f0080000  psq_st     f0, 0(r8), W=0, I=0
804735f8: 100100d8  ps_muls0   f0, f1, f3
804735fc: f0268008  psq_st     f1, 8(r6), W=1, I=0
80473600: e0280000  psq_l      f1, 0(r8), W=0, I=0
80473604: f0088008  psq_st     f0, 8(r8), W=1, I=0
80473608: 1025082a  ps_add     f1, f5, f1
8047360c: f03f046c  psq_st     f1, 1132(r31), W=0, I=0
80473610: 1027002a  ps_add     f1, f7, f0
80473614: e01f046c  psq_l      f0, 1132(r31), W=0, I=0
80473618: f03f8474  psq_st     f1, 1140(r31), W=1, I=0
8047361c: 1002002a  ps_add     f0, f2, f0
80473620: e0498008  psq_l      f2, 8(r9), W=1, I=0
80473624: f0090000  psq_st     f0, 0(r9), W=0, I=0
80473628: 1002082a  ps_add     f0, f2, f1
8047362c: f0098008  psq_st     f0, 8(r9), W=1, I=0
80473630: 4beb3ae5  bl         0x80327114
80473634: 3b81011c  addi       r28, r1, 0x11c
80473638: e01f0010  psq_l      f0, 16(r31), W=0, I=0
8047363c: e03c0000  psq_l      f1, 0(r28), W=0, I=0
80473640: 38610248  addi       r3, r1, 0x248
80473644: 389f001c  addi       r4, r31, 0x1c
80473648: 38bf03e0  addi       r5, r31, 0x3e0
8047364c: 1001002a  ps_add     f0, f1, f0
80473650: e03c8008  psq_l      f1, 8(r28), W=1, I=0
80473654: f01c0000  psq_st     f0, 0(r28), W=0, I=0
80473658: e01f8018  psq_l      f0, 24(r31), W=1, I=0
8047365c: 1001002a  ps_add     f0, f1, f0
80473660: f01c8008  psq_st     f0, 8(r28), W=1, I=0
80473664: 4beb3c95  bl         0x803272f8
80473668: 38610110  addi       r3, r1, 0x110
8047366c: 389f001c  addi       r4, r31, 0x1c
80473670: 38bf0404  addi       r5, r31, 0x404
80473674: 4beb3aa1  bl         0x80327114
80473678: 3ba10110  addi       r29, r1, 0x110
8047367c: 3ca0807d  lis        r5, -0x7f83
80473680: e03d0000  psq_l      f1, 0(r29), W=0, I=0
80473684: 387f0410  addi       r3, r31, 0x410
80473688: e01f0010  psq_l      f0, 16(r31), W=0, I=0
8047368c: 389f004c  addi       r4, r31, 0x4c
80473690: 38a5369c  addi       r5, r5, 0x369c
80473694: 1001002a  ps_add     f0, f1, f0
80473698: e03d8008  psq_l      f1, 8(r29), W=1, I=0
8047369c: f01d0000  psq_st     f0, 0(r29), W=0, I=0
804736a0: e01f8018  psq_l      f0, 24(r31), W=1, I=0
804736a4: 1001002a  ps_add     f0, f1, f0
804736a8: f01d8008  psq_st     f0, 8(r29), W=1, I=0
804736ac: 4beb3a69  bl         0x80327114
804736b0: e03f0410  psq_l      f1, 1040(r31), W=0, I=0
804736b4: 38c1008c  addi       r6, r1, 0x8c
804736b8: e01f0040  psq_l      f0, 64(r31), W=0, I=0
804736bc: 38e10104  addi       r7, r1, 0x104
804736c0: e05f0010  psq_l      f2, 16(r31), W=0, I=0
804736c4: 387f03bc  addi       r3, r31, 0x3bc
804736c8: 1061002a  ps_add     f3, f1, f0
804736cc: e03f8418  psq_l      f1, 1048(r31), W=1, I=0
804736d0: e01f8048  psq_l      f0, 72(r31), W=1, I=0
804736d4: 389f03c8  addi       r4, r31, 0x3c8
804736d8: f07f0410  psq_st     f3, 1040(r31), W=0, I=0
804736dc: 38bf03b0  addi       r5, r31, 0x3b0
804736e0: 1061002a  ps_add     f3, f1, f0
804736e4: e01f0410  psq_l      f0, 1040(r31), W=0, I=0
804736e8: f07f8418  psq_st     f3, 1048(r31), W=1, I=0
804736ec: e0dc0000  psq_l      f6, 0(r28), W=0, I=0
804736f0: e0bd0000  psq_l      f5, 0(r29), W=0, I=0
804736f4: 10261028  ps_sub     f1, f6, f2
804736f8: e0dc8008  psq_l      f6, 8(r28), W=1, I=0
804736fc: e05f8018  psq_l      f2, 24(r31), W=1, I=0
80473700: 10802828  ps_sub     f4, f0, f5
80473704: f0260000  psq_st     f1, 0(r6), W=0, I=0
80473708: 10261028  ps_sub     f1, f6, f2
8047370c: e0bd8008  psq_l      f5, 8(r29), W=1, I=0
80473710: f0268008  psq_st     f1, 8(r6), W=1, I=0
80473714: c041008c  lfs        f2, 0x8c(r1)
80473718: c0210090  lfs        f1, 0x90(r1)
8047371c: c0010094  lfs        f0, 0x94(r1)
80473720: d05f03a4  stfs       f2, 0x3a4(r31)
80473724: d03f03a8  stfs       f1, 0x3a8(r31)
80473728: d01f03ac  stfs       f0, 0x3ac(r31)
8047372c: 80c102fc  lwz        r6, 0x2fc(r1)
80473730: 80010300  lwz        r0, 0x300(r1)
80473734: 901f03b4  stw        r0, 0x3b4(r31)
80473738: 90df03b0  stw        r6, 0x3b0(r31)
8047373c: 80010304  lwz        r0, 0x304(r1)
80473740: 901f03b8  stw        r0, 0x3b8(r31)
80473744: 80c10308  lwz        r6, 0x308(r1)
80473748: 8001030c  lwz        r0, 0x30c(r1)
8047374c: 901f03c0  stw        r0, 0x3c0(r31)
80473750: 90df03bc  stw        r6, 0x3bc(r31)
80473754: 80010310  lwz        r0, 0x310(r1)
80473758: 901f03c4  stw        r0, 0x3c4(r31)
8047375c: f0870000  psq_st     f4, 0(r7), W=0, I=0
80473760: 10832828  ps_sub     f4, f3, f5
80473764: 80c10314  lwz        r6, 0x314(r1)
80473768: 80010318  lwz        r0, 0x318(r1)
8047376c: 901f03cc  stw        r0, 0x3cc(r31)
80473770: 90df03c8  stw        r6, 0x3c8(r31)
80473774: 8001031c  lwz        r0, 0x31c(r1)
80473778: 901f03d0  stw        r0, 0x3d0(r31)
8047377c: c0010254  lfs        f0, 0x254(r1)
80473780: d01f03bc  stfs       f0, 0x3bc(r31)
80473784: c0010258  lfs        f0, 0x258(r1)
80473788: d01f03c0  stfs       f0, 0x3c0(r31)
8047378c: c001025c  lfs        f0, 0x25c(r1)
80473790: f0878008  psq_st     f4, 8(r7), W=1, I=0
80473794: d01f03c4  stfs       f0, 0x3c4(r31)
80473798: 4bbcc089  bl         0x8003f820
8047379c: 387f03b0  addi       r3, r31, 0x3b0
804737a0: 7c641b78  mr         r4, r3
804737a4: 4beb4889  bl         0x8032802c
804737a8: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
804737ac: fc010000  fcmpu      cr0, f1, f0
804737b0: 40820024  bne        0x804737d4
804737b4: 3c60807d  lis        r3, -0x7f83
804737b8: c0030324  lfs        f0, 0x324(r3)
804737bc: 38630324  addi       r3, r3, 0x324
804737c0: d01f03b0  stfs       f0, 0x3b0(r31)
804737c4: c0030004  lfs        f0, 4(r3)
804737c8: d01f03b4  stfs       f0, 0x3b4(r31)
804737cc: c0030008  lfs        f0, 8(r3)
804737d0: d01f03b8  stfs       f0, 0x3b8(r31)
804737d4: 387f03b0  addi       r3, r31, 0x3b0
804737d8: 389f03bc  addi       r4, r31, 0x3bc
804737dc: 38bf03c8  addi       r5, r31, 0x3c8
804737e0: 4bbcc041  bl         0x8003f820
804737e4: 38810110  addi       r4, r1, 0x110
804737e8: 801f0428  lwz        r0, 0x428(r31)
804737ec: e0440000  psq_l      f2, 0(r4), W=0, I=0
804737f0: 38610080  addi       r3, r1, 0x80
804737f4: e03f0010  psq_l      f1, 16(r31), W=0, I=0
804737f8: 2c000000  cmpwi      r0, 0
804737fc: 10020828  ps_sub     f0, f2, f1
80473800: e0448008  psq_l      f2, 8(r4), W=1, I=0
80473804: e03f8018  psq_l      f1, 24(r31), W=1, I=0
80473808: f0030000  psq_st     f0, 0(r3), W=0, I=0
8047380c: 10020828  ps_sub     f0, f2, f1
80473810: c0410080  lfs        f2, 0x80(r1)
80473814: f0038008  psq_st     f0, 8(r3), W=1, I=0
80473818: c0210084  lfs        f1, 0x84(r1)
8047381c: c0010088  lfs        f0, 0x88(r1)
80473820: d05f041c  stfs       f2, 0x41c(r31)
80473824: d03f0420  stfs       f1, 0x420(r31)
80473828: d01f0424  stfs       f0, 0x424(r31)
8047382c: 418200c8  beq        0x804738f4
80473830: c021010c  lfs        f1, 0x10c(r1)
80473834: c0010104  lfs        f0, 0x104(r1)
80473838: ec210072  fmuls      f1, f1, f1
8047383c: c38211c8  lfs        f28, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473840: efa0083a  fmadds     f29, f0, f0, f1
80473844: fc1de040  fcmpo      cr0, f29, f28
80473848: 4c401382  cror       cr0eq, cr0lt, cr0eq
8047384c: 40820008  bne        0x80473854
80473850: 48000010  b          0x80473860
80473854: fc20e890  fmr        f1, f29
80473858: 4bcc81f9  bl         0x8013ba50
8047385c: ef9d0072  fmuls      f28, f29, f1
80473860: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473864: fc1c0040  fcmpo      cr0, f28, f0
80473868: 40810074  ble        0x804738dc
8047386c: 807f0008  lwz        r3, 8(r31)
80473870: 4bfeb055  bl         0x8045e8c4
80473874: 2c030000  cmpwi      r3, 0
80473878: 41820064  beq        0x804738dc
8047387c: 801f0434  lwz        r0, 0x434(r31)
80473880: 2c00fff8  cmpwi      r0, -8
80473884: 40810058  ble        0x804738dc
80473888: c00211d8  lfs        f0, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
8047388c: 388100f8  addi       r4, r1, 0xf8
80473890: 3c60807d  lis        r3, -0x7f83
80473894: c041010c  lfs        f2, 0x10c(r1)
80473898: ec60e024  fdivs      f3, f0, f28
8047389c: c0210104  lfs        f1, 0x104(r1)
804738a0: d39f043c  stfs       f28, 0x43c(r31)
804738a4: 7c852378  mr         r5, r4
804738a8: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
804738ac: 38630330  addi       r3, r3, 0x330
804738b0: ec4200f2  fmuls      f2, f2, f3
804738b4: d00100fc  stfs       f0, 0xfc(r1)
804738b8: ec0100f2  fmuls      f0, f1, f3
804738bc: d0410100  stfs       f2, 0x100(r1)
804738c0: d00100f8  stfs       f0, 0xf8(r1)
804738c4: 4bbcbf5d  bl         0x8003f820
804738c8: 387f0440  addi       r3, r31, 0x440
804738cc: c02211d0  lfs        f1, 0x11d0(r2) ; [806ff250] 3e99999a f32=0.300000012
804738d0: 7c641b78  mr         r4, r3
804738d4: 38a100f8  addi       r5, r1, 0xf8
804738d8: 4beb2651  bl         0x80325f28
804738dc: c03f043c  lfs        f1, 0x43c(r31)
804738e0: c05f0438  lfs        f2, 0x438(r31)
804738e4: c0021214  lfs        f0, 0x1214(r2) ; [806ff294] 3e19999a f32=0.150000006
804738e8: ec211028  fsubs      f1, f1, f2
804738ec: ec00107a  fmadds     f0, f0, f1, f2
804738f0: d01f0438  stfs       f0, 0x438(r31)
804738f4: c0421218  lfs        f2, 0x1218(r2) ; [806ff298] 40800000 f32=4
804738f8: 38610218  addi       r3, r1, 0x218
804738fc: c03f0438  lfs        f1, 0x438(r31)
80473900: 389f0440  addi       r4, r31, 0x440
80473904: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473908: ec220072  fmuls      f1, f2, f1
8047390c: ec200072  fmuls      f1, f0, f1
80473910: 4bcc89a1  bl         0x8013c2b0
80473914: 389f03a4  addi       r4, r31, 0x3a4
80473918: 38610218  addi       r3, r1, 0x218
8047391c: 7c852378  mr         r5, r4
80473920: 4bbcbaf1  bl         0x8003f410
80473924: c042121c  lfs        f2, 0x121c(r2) ; [806ff29c] 40000000 f32=2
80473928: 38610218  addi       r3, r1, 0x218
8047392c: c03f0438  lfs        f1, 0x438(r31)
80473930: 389f0440  addi       r4, r31, 0x440
80473934: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473938: ec220072  fmuls      f1, f2, f1
8047393c: ec200072  fmuls      f1, f0, f1
80473940: 4bcc8971  bl         0x8013c2b0
80473944: 387f03b0  addi       r3, r31, 0x3b0
80473948: 38a10218  addi       r5, r1, 0x218
8047394c: 7c641b78  mr         r4, r3
80473950: 4beb3b79  bl         0x803274c8
80473954: c0421220  lfs        f2, 0x1220(r2) ; [806ff2a0] 40c00000 f32=6
80473958: 38610218  addi       r3, r1, 0x218
8047395c: c03f0438  lfs        f1, 0x438(r31)
80473960: 389f0440  addi       r4, r31, 0x440
80473964: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473968: ec220072  fmuls      f1, f2, f1
8047396c: ec200072  fmuls      f1, f0, f1
80473970: 4bcc8941  bl         0x8013c2b0
80473974: 389f041c  addi       r4, r31, 0x41c
80473978: 38610218  addi       r3, r1, 0x218
8047397c: 7c852378  mr         r5, r4
80473980: 4bbcba91  bl         0x8003f410
80473984: e05f03a4  psq_l      f2, 932(r31), W=0, I=0
80473988: 38610200  addi       r3, r1, 0x200
8047398c: e03f0010  psq_l      f1, 16(r31), W=0, I=0
80473990: 3b810074  addi       r28, r1, 0x74
80473994: e09f041c  psq_l      f4, 1052(r31), W=0, I=0
80473998: 7c641b78  mr         r4, r3
8047399c: 1002082a  ps_add     f0, f2, f1
804739a0: e05f83ac  psq_l      f2, 940(r31), W=1, I=0
804739a4: 1064082a  ps_add     f3, f4, f1
804739a8: e03f8018  psq_l      f1, 24(r31), W=1, I=0
804739ac: f01f03a4  psq_st     f0, 932(r31), W=0, I=0
804739b0: 1002082a  ps_add     f0, f2, f1
804739b4: e09f8424  psq_l      f4, 1060(r31), W=1, I=0
804739b8: f07f041c  psq_st     f3, 1052(r31), W=0, I=0
804739bc: 1064082a  ps_add     f3, f4, f1
804739c0: f01f83ac  psq_st     f0, 940(r31), W=1, I=0
804739c4: f07f8424  psq_st     f3, 1060(r31), W=1, I=0
804739c8: 818102d8  lwz        r12, 0x2d8(r1)
804739cc: 816102dc  lwz        r11, 0x2dc(r1)
804739d0: 814102e0  lwz        r10, 0x2e0(r1)
804739d4: 812102e4  lwz        r9, 0x2e4(r1)
804739d8: 810102e8  lwz        r8, 0x2e8(r1)
804739dc: 80e102ec  lwz        r7, 0x2ec(r1)
804739e0: 80c102f0  lwz        r6, 0x2f0(r1)
804739e4: 80a102f4  lwz        r5, 0x2f4(r1)
804739e8: 800102f8  lwz        r0, 0x2f8(r1)
804739ec: 918101f4  stw        r12, 0x1f4(r1)
804739f0: 916101f8  stw        r11, 0x1f8(r1)
804739f4: 914101fc  stw        r10, 0x1fc(r1)
804739f8: 91210200  stw        r9, 0x200(r1)
804739fc: 91010204  stw        r8, 0x204(r1)
80473a00: 90e10208  stw        r7, 0x208(r1)
80473a04: 90c1020c  stw        r6, 0x20c(r1)
80473a08: 90a10210  stw        r5, 0x210(r1)
80473a0c: 90010214  stw        r0, 0x214(r1)
80473a10: e05f041c  psq_l      f2, 1052(r31), W=0, I=0
80473a14: e03f03a4  psq_l      f1, 932(r31), W=0, I=0
80473a18: 10220828  ps_sub     f1, f2, f1
80473a1c: f03c0000  psq_st     f1, 0(r28), W=0, I=0
80473a20: 10230028  ps_sub     f1, f3, f0
80473a24: f03c8008  psq_st     f1, 8(r28), W=1, I=0
80473a28: c0410074  lfs        f2, 0x74(r1)
80473a2c: c0210078  lfs        f1, 0x78(r1)
80473a30: c001007c  lfs        f0, 0x7c(r1)
80473a34: d0410200  stfs       f2, 0x200(r1)
80473a38: d0210204  stfs       f1, 0x204(r1)
80473a3c: d0010208  stfs       f0, 0x208(r1)
80473a40: 4beb45ed  bl         0x8032802c
80473a44: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473a48: fc010000  fcmpu      cr0, f1, f0
80473a4c: 4082001c  bne        0x80473a68
80473a50: c04102e4  lfs        f2, 0x2e4(r1)
80473a54: c02102e8  lfs        f1, 0x2e8(r1)
80473a58: c00102ec  lfs        f0, 0x2ec(r1)
80473a5c: d0410200  stfs       f2, 0x200(r1)
80473a60: d0210204  stfs       f1, 0x204(r1)
80473a64: d0010208  stfs       f0, 0x208(r1)
80473a68: 38610200  addi       r3, r1, 0x200
80473a6c: 3881020c  addi       r4, r1, 0x20c
80473a70: 38a101f4  addi       r5, r1, 0x1f4
80473a74: 4bbcbdad  bl         0x8003f820
80473a78: 386101f4  addi       r3, r1, 0x1f4
80473a7c: 7c641b78  mr         r4, r3
80473a80: 4beb45ad  bl         0x8032802c
80473a84: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473a88: fc010000  fcmpu      cr0, f1, f0
80473a8c: 40820024  bne        0x80473ab0
80473a90: 3c80807d  lis        r4, -0x7f83
80473a94: 38640324  addi       r3, r4, 0x324
80473a98: c0440324  lfs        f2, 0x324(r4)
80473a9c: c0230004  lfs        f1, 4(r3)
80473aa0: c0030008  lfs        f0, 8(r3)
80473aa4: d04101f4  stfs       f2, 0x1f4(r1)
80473aa8: d02101f8  stfs       f1, 0x1f8(r1)
80473aac: d00101fc  stfs       f0, 0x1fc(r1)
80473ab0: 386101f4  addi       r3, r1, 0x1f4
80473ab4: 38810200  addi       r4, r1, 0x200
80473ab8: 38a1020c  addi       r5, r1, 0x20c
80473abc: 4bbcbd65  bl         0x8003f820
80473ac0: 801f0428  lwz        r0, 0x428(r31)
80473ac4: 2c000000  cmpwi      r0, 0
80473ac8: 41820044  beq        0x80473b0c
80473acc: 807f0008  lwz        r3, 8(r31)
80473ad0: 4bfeadf5  bl         0x8045e8c4
80473ad4: 2c030000  cmpwi      r3, 0
80473ad8: 41820034  beq        0x80473b0c
80473adc: 801f0434  lwz        r0, 0x434(r31)
80473ae0: 2c00fff8  cmpwi      r0, -8
80473ae4: 40810028  ble        0x80473b0c
80473ae8: c05f042c  lfs        f2, 0x42c(r31)
80473aec: c0221224  lfs        f1, 0x1224(r2) ; [806ff2a4] 3e800000 f32=0.25
80473af0: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473af4: ec220828  fsubs      f1, f2, f1
80473af8: d03f042c  stfs       f1, 0x42c(r31)
80473afc: fc010040  fcmpo      cr0, f1, f0
80473b00: 4080002c  bge        0x80473b2c
80473b04: d01f042c  stfs       f0, 0x42c(r31)
80473b08: 48000024  b          0x80473b2c
80473b0c: c05f042c  lfs        f2, 0x42c(r31)
80473b10: c0221228  lfs        f1, 0x1228(r2) ; [806ff2a8] 3d0f5c29 f32=0.0350000001
80473b14: c00211d8  lfs        f0, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473b18: ec22082a  fadds      f1, f2, f1
80473b1c: d03f042c  stfs       f1, 0x42c(r31)
80473b20: fc010040  fcmpo      cr0, f1, f0
80473b24: 40810008  ble        0x80473b2c
80473b28: d01f042c  stfs       f0, 0x42c(r31)
80473b2c: c04211d8  lfs        f2, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473b30: c03f042c  lfs        f1, 0x42c(r31)
80473b34: c01f0378  lfs        f0, 0x378(r31)
80473b38: ec220828  fsubs      f1, f2, f1
80473b3c: ec020028  fsubs      f0, f2, f0
80473b40: ec010032  fmuls      f0, f1, f0
80473b44: ec220028  fsubs      f1, f2, f0
80473b48: 4beb2639  bl         0x80326180
80473b4c: 38810158  addi       r4, r1, 0x158
80473b50: e07f03a4  psq_l      f3, 932(r31), W=0, I=0
80473b54: e0440000  psq_l      f2, 0(r4), W=0, I=0
80473b58: 38c100ec  addi       r6, r1, 0xec
80473b5c: ff800890  fmr        f28, f1
80473b60: 386101d0  addi       r3, r1, 0x1d0
80473b64: 10021828  ps_sub     f0, f2, f3
80473b68: e0448008  psq_l      f2, 8(r4), W=1, I=0
80473b6c: 389f03b0  addi       r4, r31, 0x3b0
80473b70: 38a102fc  addi       r5, r1, 0x2fc
80473b74: 1000185c  ps_madds0  f0, f0, f1, f3
80473b78: f0060000  psq_st     f0, 0(r6), W=0, I=0
80473b7c: e07f83ac  psq_l      f3, 940(r31), W=1, I=0
80473b80: 10021828  ps_sub     f0, f2, f3
80473b84: 1000185c  ps_madds0  f0, f0, f1, f3
80473b88: f0068008  psq_st     f0, 8(r6), W=1, I=0
80473b8c: 4beb3185  bl         0x80326d10
80473b90: fc20e090  fmr        f1, f28
80473b94: 386101f4  addi       r3, r1, 0x1f4
80473b98: 7c641b78  mr         r4, r3
80473b9c: 38a102d8  addi       r5, r1, 0x2d8
80473ba0: 4beb3171  bl         0x80326d10
80473ba4: 807f0008  lwz        r3, 8(r31)
80473ba8: 80030018  lwz        r0, 0x18(r3)
80473bac: 2c000000  cmpwi      r0, 0
80473bb0: 40820010  bne        0x80473bc0
80473bb4: c00211d8  lfs        f0, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473bb8: d01f044c  stfs       f0, 0x44c(r31)
80473bbc: 48000024  b          0x80473be0
80473bc0: c05f044c  lfs        f2, 0x44c(r31)
80473bc4: c02da08c  lfs        f1, -0x5f74(r13) ; [806f21ac] 3dcccccd f32=0.100000001
80473bc8: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473bcc: ec220828  fsubs      f1, f2, f1
80473bd0: fc010040  fcmpo      cr0, f1, f0
80473bd4: 40800008  bge        0x80473bdc
80473bd8: fc200090  fmr        f1, f0
80473bdc: d03f044c  stfs       f1, 0x44c(r31)
80473be0: c03f0464  lfs        f1, 0x464(r31)
80473be4: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473be8: ec200072  fmuls      f1, f0, f1
80473bec: 4bcc7fb5  bl         0x8013bba0
80473bf0: fc400890  fmr        f2, f1
80473bf4: e09f0034  psq_l      f4, 52(r31), W=0, I=0
80473bf8: 3b81005c  addi       r28, r1, 0x5c
80473bfc: c03f0464  lfs        f1, 0x464(r31)
80473c00: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473c04: 10640098  ps_muls0   f3, f4, f2
80473c08: e09f803c  psq_l      f4, 60(r31), W=1, I=0
80473c0c: ec200072  fmuls      f1, f0, f1
80473c10: f07c0000  psq_st     f3, 0(r28), W=0, I=0
80473c14: 10640098  ps_muls0   f3, f4, f2
80473c18: f07c8008  psq_st     f3, 8(r28), W=1, I=0
80473c1c: 4bcc7ff5  bl         0x8013bc10
80473c20: fc200850  fneg       f1, f1
80473c24: e07f001c  psq_l      f3, 28(r31), W=0, I=0
80473c28: 38610068  addi       r3, r1, 0x68
80473c2c: e09c0000  psq_l      f4, 0(r28), W=0, I=0
80473c30: 388100e0  addi       r4, r1, 0xe0
80473c34: c00211d8  lfs        f0, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473c38: 10430058  ps_muls0   f2, f3, f1
80473c3c: e07f8024  psq_l      f3, 36(r31), W=1, I=0
80473c40: f0430000  psq_st     f2, 0(r3), W=0, I=0
80473c44: 10430058  ps_muls0   f2, f3, f1
80473c48: e0230000  psq_l      f1, 0(r3), W=0, I=0
80473c4c: f0438008  psq_st     f2, 8(r3), W=1, I=0
80473c50: 1021202a  ps_add     f1, f1, f4
80473c54: e09c8008  psq_l      f4, 8(r28), W=1, I=0
80473c58: f0240000  psq_st     f1, 0(r4), W=0, I=0
80473c5c: 1022202a  ps_add     f1, f2, f4
80473c60: f0248008  psq_st     f1, 8(r4), W=1, I=0
80473c64: 807f0008  lwz        r3, 8(r31)
80473c68: 806300d4  lwz        r3, 0xd4(r3)
80473c6c: c0230028  lfs        f1, 0x28(r3)
80473c70: fc010040  fcmpo      cr0, f1, f0
80473c74: 4081000c  ble        0x80473c80
80473c78: fc200090  fmr        f1, f0
80473c7c: 48000014  b          0x80473c90
80473c80: c00211e0  lfs        f0, 0x11e0(r2) ; [806ff260] bf800000 f32=-1
80473c84: fc010040  fcmpo      cr0, f1, f0
80473c88: 40800008  bge        0x80473c90
80473c8c: fc200090  fmr        f1, f0
80473c90: 4bba316d  bl         0x80016dfc
80473c94: fc400818  frsp       f2, f1
80473c98: c00211e4  lfs        f0, 0x11e4(r2) ; [806ff264] 42652ee1 f32=57.2957802
80473c9c: c02da0c4  lfs        f1, -0x5f3c(r13) ; [806f21e4] 3f000000 f32=0.5
80473ca0: c0a211d8  lfs        f5, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473ca4: ec4000b2  fmuls      f2, f0, f2
80473ca8: c00da0b8  lfs        f0, -0x5f48(r13) ; [806f21d8] c1f00000 f32=-30
80473cac: ec212828  fsubs      f1, f1, f5
80473cb0: c0df044c  lfs        f6, 0x44c(r31)
80473cb4: c07f0468  lfs        f3, 0x468(r31)
80473cb8: ec80102a  fadds      f4, f0, f2
80473cbc: ece6287a  fmadds     f7, f6, f1, f5
80473cc0: c03f0398  lfs        f1, 0x398(r31)
80473cc4: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473cc8: c04da0c8  lfs        f2, -0x5f38(r13) ; [806f21e8] 3dcccccd f32=0.100000001
80473ccc: ec8401f2  fmuls      f4, f4, f7
80473cd0: fc010040  fcmpo      cr0, f1, f0
80473cd4: ec041828  fsubs      f0, f4, f3
80473cd8: ec02183a  fmadds     f0, f2, f0, f3
80473cdc: d01f0468  stfs       f0, 0x468(r31)
80473ce0: 4c411382  cror       cr0eq, cr0gt, cr0eq
80473ce4: 40820014  bne        0x80473cf8
80473ce8: c00dd6c0  lfs        f0, -0x2940(r13)
80473cec: ec002828  fsubs      f0, f0, f5
80473cf0: efa6283a  fmadds     f29, f6, f0, f5
80473cf4: 48000010  b          0x80473d04
80473cf8: c00da084  lfs        f0, -0x5f7c(r13) ; [806f21a4] 3f800000 f32=1
80473cfc: ec002828  fsubs      f0, f0, f5
80473d00: efa6283a  fmadds     f29, f6, f0, f5
80473d04: c06211d8  lfs        f3, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473d08: 38610218  addi       r3, r1, 0x218
80473d0c: c05f0388  lfs        f2, 0x388(r31)
80473d10: 388100e0  addi       r4, r1, 0xe0
80473d14: c03f0468  lfs        f1, 0x468(r31)
80473d18: c00da0c0  lfs        f0, -0x5f40(r13) ; [806f21e0] 3e19999a f32=0.150000006
80473d1c: ef831028  fsubs      f28, f3, f2
80473d20: c04da088  lfs        f2, -0x5f78(r13) ; [806f21a8] 3f000000 f32=0.5
80473d24: ec010032  fmuls      f0, f1, f0
80473d28: c0df0464  lfs        f6, 0x464(r31)
80473d2c: c02211c8  lfs        f1, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473d30: ec421828  fsubs      f2, f2, f3
80473d34: c09f044c  lfs        f4, 0x44c(r31)
80473d38: ec213028  fsubs      f1, f1, f6
80473d3c: ecbc0032  fmuls      f5, f28, f0
80473d40: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473d44: efe418ba  fmadds     f31, f4, f2, f3
80473d48: efc4307a  fmadds     f30, f4, f1, f6
80473d4c: ec200172  fmuls      f1, f0, f5
80473d50: 4bcc8561  bl         0x8013c2b0
80473d54: 386101d0  addi       r3, r1, 0x1d0
80473d58: 38a10218  addi       r5, r1, 0x218
80473d5c: 7c641b78  mr         r4, r3
80473d60: 4beb3769  bl         0x803274c8
80473d64: c00da0a0  lfs        f0, -0x5f60(r13) ; [806f21c0] 3e19999a f32=0.150000006
80473d68: 38610218  addi       r3, r1, 0x218
80473d6c: c0bf0398  lfs        f5, 0x398(r31)
80473d70: c08da07c  lfs        f4, -0x5f84(r13) ; [806f219c] 3dcccccd f32=0.100000001
80473d74: ec3e0032  fmuls      f1, f30, f0
80473d78: c07f039c  lfs        f3, 0x39c(r31)
80473d7c: c04da080  lfs        f2, -0x5f80(r13) ; [806f21a0] 3dcccccd f32=0.100000001
80473d80: ec850132  fmuls      f4, f5, f4
80473d84: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473d88: ec4300b2  fmuls      f2, f3, f2
80473d8c: c06211c8  lfs        f3, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473d90: ec9d0132  fmuls      f4, f29, f4
80473d94: ec3f08ba  fmadds     f1, f31, f2, f1
80473d98: ec5c0132  fmuls      f2, f28, f4
80473d9c: ec9c0072  fmuls      f4, f28, f1
80473da0: ec2000b2  fmuls      f1, f0, f2
80473da4: ec400132  fmuls      f2, f0, f4
80473da8: 4bcc8549  bl         0x8013c2f0
80473dac: 386101d0  addi       r3, r1, 0x1d0
80473db0: 38a10218  addi       r5, r1, 0x218
80473db4: 7c641b78  mr         r4, r3
80473db8: 4beb38ad  bl         0x80327664
80473dbc: 80c100ec  lwz        r6, 0xec(r1)
80473dc0: 38610218  addi       r3, r1, 0x218
80473dc4: 80a100f0  lwz        r5, 0xf0(r1)
80473dc8: 388100e0  addi       r4, r1, 0xe0
80473dcc: 800100f4  lwz        r0, 0xf4(r1)
80473dd0: 90c100d4  stw        r6, 0xd4(r1)
80473dd4: c02da0bc  lfs        f1, -0x5f44(r13) ; [806f21dc] 3e4ccccd f32=0.200000003
80473dd8: 90a100d8  stw        r5, 0xd8(r1)
80473ddc: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473de0: 900100dc  stw        r0, 0xdc(r1)
80473de4: c05f0468  lfs        f2, 0x468(r31)
80473de8: ec220072  fmuls      f1, f2, f1
80473dec: ec3c0072  fmuls      f1, f28, f1
80473df0: ec200072  fmuls      f1, f0, f1
80473df4: 4bcc84bd  bl         0x8013c2b0
80473df8: 386101f4  addi       r3, r1, 0x1f4
80473dfc: 38a10218  addi       r5, r1, 0x218
80473e00: 7c641b78  mr         r4, r3
80473e04: 4beb36c5  bl         0x803274c8
80473e08: c00da0a4  lfs        f0, -0x5f5c(r13) ; [806f21c4] 3eb33333 f32=0.349999994
80473e0c: 38610218  addi       r3, r1, 0x218
80473e10: c0bf0398  lfs        f5, 0x398(r31)
80473e14: c08da074  lfs        f4, -0x5f8c(r13) ; [806f2194] 3ecccccd f32=0.400000006
80473e18: ec3e0032  fmuls      f1, f30, f0
80473e1c: c07f039c  lfs        f3, 0x39c(r31)
80473e20: c04da078  lfs        f2, -0x5f88(r13) ; [806f2198] 3f000000 f32=0.5
80473e24: ec850132  fmuls      f4, f5, f4
80473e28: c0021200  lfs        f0, 0x1200(r2) ; [806ff280] 3f360b61 f32=0.711111128
80473e2c: ec4300b2  fmuls      f2, f3, f2
80473e30: c06211c8  lfs        f3, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80473e34: ec9d0132  fmuls      f4, f29, f4
80473e38: ec3f08ba  fmadds     f1, f31, f2, f1
80473e3c: ec5c0132  fmuls      f2, f28, f4
80473e40: ec9c0072  fmuls      f4, f28, f1
80473e44: ec2000b2  fmuls      f1, f0, f2
80473e48: ec400132  fmuls      f2, f0, f4
80473e4c: 4bcc84a5  bl         0x8013c2f0
80473e50: 386101f4  addi       r3, r1, 0x1f4
80473e54: 38a10218  addi       r5, r1, 0x218
80473e58: 7c641b78  mr         r4, r3
80473e5c: 4beb3809  bl         0x80327664
80473e60: 838101f4  lwz        r28, 0x1f4(r1)
80473e64: 7fe3fb78  mr         r3, r31
80473e68: 83a101f8  lwz        r29, 0x1f8(r1)
80473e6c: 388100ec  addi       r4, r1, 0xec
80473e70: 83c101fc  lwz        r30, 0x1fc(r1)
80473e74: 38a101d0  addi       r5, r1, 0x1d0
80473e78: 81810200  lwz        r12, 0x200(r1)
80473e7c: 38c100d4  addi       r6, r1, 0xd4
80473e80: 81610204  lwz        r11, 0x204(r1)
80473e84: 38e101f4  addi       r7, r1, 0x1f4
80473e88: 81410208  lwz        r10, 0x208(r1)
80473e8c: 8121020c  lwz        r9, 0x20c(r1)
80473e90: 81010210  lwz        r8, 0x210(r1)
80473e94: 80010214  lwz        r0, 0x214(r1)
80473e98: 938101ac  stw        r28, 0x1ac(r1)
80473e9c: 93a101b0  stw        r29, 0x1b0(r1)
80473ea0: 93c101b4  stw        r30, 0x1b4(r1)
80473ea4: 918101b8  stw        r12, 0x1b8(r1)
80473ea8: 916101bc  stw        r11, 0x1bc(r1)
80473eac: 914101c0  stw        r10, 0x1c0(r1)
80473eb0: 912101c4  stw        r9, 0x1c4(r1)
80473eb4: 910101c8  stw        r8, 0x1c8(r1)
80473eb8: 900101cc  stw        r0, 0x1cc(r1)
80473ebc: 4bffdced  bl         0x80471ba8
80473ec0: 38810200  addi       r4, r1, 0x200
80473ec4: 390100d4  addi       r8, r1, 0xd4
80473ec8: c002122c  lfs        f0, 0x122c(r2) ; [806ff2ac] 40900000 f32=4.5
80473ecc: 38c10044  addi       r6, r1, 0x44
80473ed0: e0640000  psq_l      f3, 0(r4), W=0, I=0
80473ed4: 38e10050  addi       r7, r1, 0x50
80473ed8: e0880000  psq_l      f4, 0(r8), W=0, I=0
80473edc: 38610164  addi       r3, r1, 0x164
80473ee0: 10430018  ps_muls0   f2, f3, f0
80473ee4: e0648008  psq_l      f3, 8(r4), W=1, I=0
80473ee8: c0221230  lfs        f1, 0x1230(r2) ; [806ff2b0] 3f333333 f32=0.699999988
80473eec: 388101ac  addi       r4, r1, 0x1ac
80473ef0: f0460000  psq_st     f2, 0(r6), W=0, I=0
80473ef4: 10430018  ps_muls0   f2, f3, f0
80473ef8: e0060000  psq_l      f0, 0(r6), W=0, I=0
80473efc: 38a102b4  addi       r5, r1, 0x2b4
80473f00: f0468008  psq_st     f2, 8(r6), W=1, I=0
80473f04: 1004002a  ps_add     f0, f4, f0
80473f08: e0888008  psq_l      f4, 8(r8), W=1, I=0
80473f0c: f0070000  psq_st     f0, 0(r7), W=0, I=0
80473f10: 1004102a  ps_add     f0, f4, f2
80473f14: f0078008  psq_st     f0, 8(r7), W=1, I=0
80473f18: c0610050  lfs        f3, 0x50(r1)
80473f1c: c0410054  lfs        f2, 0x54(r1)
80473f20: c0010058  lfs        f0, 0x58(r1)
80473f24: d06100c8  stfs       f3, 0xc8(r1)
80473f28: d04100cc  stfs       f2, 0xcc(r1)
80473f2c: d00100d0  stfs       f0, 0xd0(r1)
80473f30: 4beb2de1  bl         0x80326d10
80473f34: 38810170  addi       r4, r1, 0x170
80473f38: 38c100c8  addi       r6, r1, 0xc8
80473f3c: c0021234  lfs        f0, 0x1234(r2) ; [806ff2b4] 40266666 f32=2.5999999
80473f40: 38610038  addi       r3, r1, 0x38
80473f44: e0440000  psq_l      f2, 0(r4), W=0, I=0
80473f48: 38a100bc  addi       r5, r1, 0xbc
80473f4c: e0660000  psq_l      f3, 0(r6), W=0, I=0
80473f50: 38e100b0  addi       r7, r1, 0xb0
80473f54: 10220018  ps_muls0   f1, f2, f0
80473f58: e0448008  psq_l      f2, 8(r4), W=1, I=0
80473f5c: e09f038c  psq_l      f4, 908(r31), W=0, I=0
80473f60: f0230000  psq_st     f1, 0(r3), W=0, I=0
80473f64: 10220018  ps_muls0   f1, f2, f0
80473f68: e0030000  psq_l      f0, 0(r3), W=0, I=0
80473f6c: f0238008  psq_st     f1, 8(r3), W=1, I=0
80473f70: 1003002a  ps_add     f0, f3, f0
80473f74: e0668008  psq_l      f3, 8(r6), W=1, I=0
80473f78: f0050000  psq_st     f0, 0(r5), W=0, I=0
80473f7c: 1003082a  ps_add     f0, f3, f1
80473f80: e0250000  psq_l      f1, 0(r5), W=0, I=0
80473f84: f0058008  psq_st     f0, 8(r5), W=1, I=0
80473f88: 10240828  ps_sub     f1, f4, f1
80473f8c: f0270000  psq_st     f1, 0(r7), W=0, I=0
80473f90: e09f8394  psq_l      f4, 916(r31), W=1, I=0
80473f94: 10240028  ps_sub     f1, f4, f0
80473f98: f0278008  psq_st     f1, 8(r7), W=1, I=0
80473f9c: 801f03a0  lwz        r0, 0x3a0(r31)
80473fa0: 2c000000  cmpwi      r0, 0
80473fa4: 4182000c  beq        0x80473fb0
80473fa8: c03f0384  lfs        f1, 0x384(r31)
80473fac: 48000008  b          0x80473fb4
80473fb0: c02211d8  lfs        f1, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80473fb4: 386100b0  addi       r3, r1, 0xb0
80473fb8: 38a1017c  addi       r5, r1, 0x17c
80473fbc: 7c641b78  mr         r4, r3
80473fc0: 4beb1f69  bl         0x80325f28
80473fc4: 7fe3fb78  mr         r3, r31
80473fc8: 38810188  addi       r4, r1, 0x188
80473fcc: 38a100b0  addi       r5, r1, 0xb0
80473fd0: 38c10164  addi       r6, r1, 0x164
80473fd4: 4bffe3d9  bl         0x804723ac
80473fd8: 7fe3fb78  mr         r3, r31
80473fdc: 4bffec9d  bl         0x80472c78
80473fe0: 7fe3fb78  mr         r3, r31
80473fe4: 388100d4  addi       r4, r1, 0xd4
80473fe8: 38a101f4  addi       r5, r1, 0x1f4
80473fec: 4bffe739  bl         0x80472724
80473ff0: 387f0224  addi       r3, r31, 0x224
80473ff4: 388100ec  addi       r4, r1, 0xec
80473ff8: 38a101d0  addi       r5, r1, 0x1d0
80473ffc: 4beb3f65  bl         0x80327f60
80474000: 387f0254  addi       r3, r31, 0x254
80474004: 388100d4  addi       r4, r1, 0xd4
80474008: 38a101f4  addi       r5, r1, 0x1f4
8047400c: 4beb3f55  bl         0x80327f60
80474010: 387f0284  addi       r3, r31, 0x284
80474014: 388100c8  addi       r4, r1, 0xc8
80474018: 38a10188  addi       r5, r1, 0x188
8047401c: 4beb3f45  bl         0x80327f60
80474020: 7fe3fb78  mr         r3, r31
80474024: 4bffeff1  bl         0x80473014
80474028: 801f00a0  lwz        r0, 0xa0(r31)
8047402c: 2c000000  cmpwi      r0, 0
80474030: 4182006c  beq        0x8047409c
80474034: c05f0040  lfs        f2, 0x40(r31)
80474038: 38000000  li         r0, 0
8047403c: c03f0044  lfs        f1, 0x44(r31)
80474040: c01f0048  lfs        f0, 0x48(r31)
80474044: 817f004c  lwz        r11, 0x4c(r31)
80474048: 815f0050  lwz        r10, 0x50(r31)
8047404c: 813f0054  lwz        r9, 0x54(r31)
80474050: 811f0058  lwz        r8, 0x58(r31)
80474054: 80ff005c  lwz        r7, 0x5c(r31)
80474058: 80df0060  lwz        r6, 0x60(r31)
8047405c: 80bf0064  lwz        r5, 0x64(r31)
80474060: 809f0068  lwz        r4, 0x68(r31)
80474064: 807f006c  lwz        r3, 0x6c(r31)
80474068: d05f0070  stfs       f2, 0x70(r31)
8047406c: d03f0074  stfs       f1, 0x74(r31)
80474070: d01f0078  stfs       f0, 0x78(r31)
80474074: 917f007c  stw        r11, 0x7c(r31)
80474078: 915f0080  stw        r10, 0x80(r31)
8047407c: 913f0084  stw        r9, 0x84(r31)
80474080: 911f0088  stw        r8, 0x88(r31)
80474084: 90ff008c  stw        r7, 0x8c(r31)
80474088: 90df0090  stw        r6, 0x90(r31)
8047408c: 90bf0094  stw        r5, 0x94(r31)
80474090: 909f0098  stw        r4, 0x98(r31)
80474094: 907f009c  stw        r3, 0x9c(r31)
80474098: 901f00a0  stw        r0, 0xa0(r31)
8047409c: 7fe3fb78  mr         r3, r31
804740a0: 4bffed21  bl         0x80472dc0
804740a4: c05f0040  lfs        f2, 0x40(r31)
804740a8: c03f0044  lfs        f1, 0x44(r31)
804740ac: c01f0048  lfs        f0, 0x48(r31)
804740b0: 815f004c  lwz        r10, 0x4c(r31)
804740b4: 813f0050  lwz        r9, 0x50(r31)
804740b8: 811f0054  lwz        r8, 0x54(r31)
804740bc: 80ff0058  lwz        r7, 0x58(r31)
804740c0: 80df005c  lwz        r6, 0x5c(r31)
804740c4: 80bf0060  lwz        r5, 0x60(r31)
804740c8: 809f0064  lwz        r4, 0x64(r31)
804740cc: 807f0068  lwz        r3, 0x68(r31)
804740d0: 801f006c  lwz        r0, 0x6c(r31)
804740d4: d05f0070  stfs       f2, 0x70(r31)
804740d8: d03f0074  stfs       f1, 0x74(r31)
804740dc: d01f0078  stfs       f0, 0x78(r31)
804740e0: 915f007c  stw        r10, 0x7c(r31)
804740e4: 913f0080  stw        r9, 0x80(r31)
804740e8: 911f0084  stw        r8, 0x84(r31)
804740ec: 90ff0088  stw        r7, 0x88(r31)
804740f0: 90df008c  stw        r6, 0x8c(r31)
804740f4: 90bf0090  stw        r5, 0x90(r31)
804740f8: 909f0094  stw        r4, 0x94(r31)
804740fc: 907f0098  stw        r3, 0x98(r31)
80474100: 901f009c  stw        r0, 0x9c(r31)
80474104: e3e10378  psq_l      f31, 888(r1), W=0, I=0
80474108: cbe10370  lfd        f31, 0x370(r1)
8047410c: e3c10368  psq_l      f30, 872(r1), W=0, I=0
80474110: cbc10360  lfd        f30, 0x360(r1)
80474114: e3a10358  psq_l      f29, 856(r1), W=0, I=0
80474118: cba10350  lfd        f29, 0x350(r1)
8047411c: e3810348  psq_l      f28, 840(r1), W=0, I=0
80474120: cb810340  lfd        f28, 0x340(r1)
80474124: 39610340  addi       r11, r1, 0x340
80474128: 4bb93781  bl         0x800078a8
8047412c: 80010384  lwz        r0, 0x384(r1)
80474130: 7c0803a6  mtlr       r0
80474134: 38210380  addi       r1, r1, 0x380
80474138: 4e800020  blr        
8047413c: c00211c8  lfs        f0, 0x11c8(r2) ; [806ff248] 00000000 f32=0
80474140: 38000000  li         r0, 0
80474144: d0030450  stfs       f0, 0x450(r3)
80474148: 90030460  stw        r0, 0x460(r3)
8047414c: 4e800020  blr        
80474150: 9421fff0  stwu       r1, -0x10(r1)
80474154: 7c0802a6  mflr       r0
80474158: 90010014  stw        r0, 0x14(r1)
8047415c: 93e1000c  stw        r31, 0xc(r1)
80474160: 7c7f1b78  mr         r31, r3
80474164: 8063000c  lwz        r3, 0xc(r3)
80474168: 48007281  bl         0x8047b3e8
8047416c: 3ca0807d  lis        r5, -0x7f83
80474170: 3c60807d  lis        r3, -0x7f83
80474174: c0050318  lfs        f0, 0x318(r5)
80474178: 38850318  addi       r4, r5, 0x318
8047417c: d01f0010  stfs       f0, 0x10(r31)
80474180: c0040004  lfs        f0, 4(r4)
80474184: d01f0014  stfs       f0, 0x14(r31)
80474188: c0040008  lfs        f0, 8(r4)
8047418c: d01f0018  stfs       f0, 0x18(r31)
80474190: 84c30354  lwzu       r6, 0x354(r3)
80474194: 80030004  lwz        r0, 4(r3)
80474198: 901f0020  stw        r0, 0x20(r31)
8047419c: 90df001c  stw        r6, 0x1c(r31)
804741a0: 80030008  lwz        r0, 8(r3)
804741a4: 901f0024  stw        r0, 0x24(r31)
804741a8: 80c3000c  lwz        r6, 0xc(r3)
804741ac: 80030010  lwz        r0, 0x10(r3)
804741b0: 901f002c  stw        r0, 0x2c(r31)
804741b4: 90df0028  stw        r6, 0x28(r31)
804741b8: 80030014  lwz        r0, 0x14(r3)
804741bc: 901f0030  stw        r0, 0x30(r31)
804741c0: 80c30018  lwz        r6, 0x18(r3)
804741c4: 8003001c  lwz        r0, 0x1c(r3)
804741c8: 901f0038  stw        r0, 0x38(r31)
804741cc: 90df0034  stw        r6, 0x34(r31)
804741d0: 80030020  lwz        r0, 0x20(r3)
804741d4: 901f003c  stw        r0, 0x3c(r31)
804741d8: c0050318  lfs        f0, 0x318(r5)
804741dc: d01f0040  stfs       f0, 0x40(r31)
804741e0: c0040004  lfs        f0, 4(r4)
804741e4: d01f0044  stfs       f0, 0x44(r31)
804741e8: c0040008  lfs        f0, 8(r4)
804741ec: d01f0048  stfs       f0, 0x48(r31)
804741f0: 80c30000  lwz        r6, 0(r3)
804741f4: 80030004  lwz        r0, 4(r3)
804741f8: 901f0050  stw        r0, 0x50(r31)
804741fc: 90df004c  stw        r6, 0x4c(r31)
80474200: 80030008  lwz        r0, 8(r3)
80474204: 901f0054  stw        r0, 0x54(r31)
80474208: 80c3000c  lwz        r6, 0xc(r3)
8047420c: 80030010  lwz        r0, 0x10(r3)
80474210: 901f005c  stw        r0, 0x5c(r31)
80474214: 90df0058  stw        r6, 0x58(r31)
80474218: 80030014  lwz        r0, 0x14(r3)
8047421c: 901f0060  stw        r0, 0x60(r31)
80474220: 80c30018  lwz        r6, 0x18(r3)
80474224: 8003001c  lwz        r0, 0x1c(r3)
80474228: 901f0068  stw        r0, 0x68(r31)
8047422c: 90df0064  stw        r6, 0x64(r31)
80474230: 80030020  lwz        r0, 0x20(r3)
80474234: 901f006c  stw        r0, 0x6c(r31)
80474238: c0050318  lfs        f0, 0x318(r5)
8047423c: d01f0070  stfs       f0, 0x70(r31)
80474240: c0040004  lfs        f0, 4(r4)
80474244: d01f0074  stfs       f0, 0x74(r31)
80474248: c0040008  lfs        f0, 8(r4)
8047424c: d01f0078  stfs       f0, 0x78(r31)
80474250: 80c30000  lwz        r6, 0(r3)
80474254: 80030004  lwz        r0, 4(r3)
80474258: 901f0080  stw        r0, 0x80(r31)
8047425c: 90df007c  stw        r6, 0x7c(r31)
80474260: 80030008  lwz        r0, 8(r3)
80474264: 901f0084  stw        r0, 0x84(r31)
80474268: 80c3000c  lwz        r6, 0xc(r3)
8047426c: 80030010  lwz        r0, 0x10(r3)
80474270: 901f008c  stw        r0, 0x8c(r31)
80474274: 90df0088  stw        r6, 0x88(r31)
80474278: 80030014  lwz        r0, 0x14(r3)
8047427c: 901f0090  stw        r0, 0x90(r31)
80474280: 80c30018  lwz        r6, 0x18(r3)
80474284: 8003001c  lwz        r0, 0x1c(r3)
80474288: 901f0098  stw        r0, 0x98(r31)
8047428c: 90df0094  stw        r6, 0x94(r31)
80474290: 80030020  lwz        r0, 0x20(r3)
80474294: 901f009c  stw        r0, 0x9c(r31)
80474298: 38000000  li         r0, 0
8047429c: 901f00a0  stw        r0, 0xa0(r31)
804742a0: 3cc0807d  lis        r6, -0x7f83
804742a4: 38ff00d0  addi       r7, r31, 0xd0
804742a8: c0050318  lfs        f0, 0x318(r5)
804742ac: 38c60378  addi       r6, r6, 0x378
804742b0: d01f00a4  stfs       f0, 0xa4(r31)
804742b4: 38a6fffc  addi       r5, r6, -4
804742b8: 38000006  li         r0, 6
804742bc: c0040004  lfs        f0, 4(r4)
804742c0: d01f00a8  stfs       f0, 0xa8(r31)
804742c4: c0040008  lfs        f0, 8(r4)
804742c8: d01f00ac  stfs       f0, 0xac(r31)
804742cc: 80c30000  lwz        r6, 0(r3)
804742d0: 80830004  lwz        r4, 4(r3)
804742d4: 909f00b4  stw        r4, 0xb4(r31)
804742d8: 90df00b0  stw        r6, 0xb0(r31)
804742dc: 80830008  lwz        r4, 8(r3)
804742e0: 909f00b8  stw        r4, 0xb8(r31)
804742e4: 80c3000c  lwz        r6, 0xc(r3)
804742e8: 80830010  lwz        r4, 0x10(r3)
804742ec: 909f00c0  stw        r4, 0xc0(r31)
804742f0: 90df00bc  stw        r6, 0xbc(r31)
804742f4: 80830014  lwz        r4, 0x14(r3)
804742f8: 909f00c4  stw        r4, 0xc4(r31)
804742fc: 80c30018  lwz        r6, 0x18(r3)
80474300: 8083001c  lwz        r4, 0x1c(r3)
80474304: 909f00cc  stw        r4, 0xcc(r31)
80474308: 90df00c8  stw        r6, 0xc8(r31)
8047430c: 80630020  lwz        r3, 0x20(r3)
80474310: 907f00d0  stw        r3, 0xd0(r31)
80474314: 7c0903a6  mtctr      r0
80474318: 80650004  lwz        r3, 4(r5)
8047431c: 84050008  lwzu       r0, 8(r5)
80474320: 90670004  stw        r3, 4(r7)
80474324: 94070008  stwu       r0, 8(r7)
80474328: 4200fff0  bdnz       0x80474318
8047432c: 3c60807d  lis        r3, -0x7f83
80474330: 38000006  li         r0, 6
80474334: 38630378  addi       r3, r3, 0x378
80474338: 38bf0100  addi       r5, r31, 0x100
8047433c: 3883fffc  addi       r4, r3, -4
80474340: 7c0903a6  mtctr      r0
80474344: 80640004  lwz        r3, 4(r4)
80474348: 84040008  lwzu       r0, 8(r4)
8047434c: 90650004  stw        r3, 4(r5)
80474350: 94050008  stwu       r0, 8(r5)
80474354: 4200fff0  bdnz       0x80474344
80474358: 3c60807d  lis        r3, -0x7f83
8047435c: 38000006  li         r0, 6
80474360: 38630378  addi       r3, r3, 0x378
80474364: 38bf0130  addi       r5, r31, 0x130
80474368: 3883fffc  addi       r4, r3, -4
8047436c: 7c0903a6  mtctr      r0
80474370: 80640004  lwz        r3, 4(r4)
80474374: 84040008  lwzu       r0, 8(r4)
80474378: 90650004  stw        r3, 4(r5)
8047437c: 94050008  stwu       r0, 8(r5)
80474380: 4200fff0  bdnz       0x80474370
80474384: 3c60807d  lis        r3, -0x7f83
80474388: 38000006  li         r0, 6
8047438c: 38630378  addi       r3, r3, 0x378
80474390: 38bf0160  addi       r5, r31, 0x160
80474394: 3883fffc  addi       r4, r3, -4
80474398: 7c0903a6  mtctr      r0
8047439c: 80640004  lwz        r3, 4(r4)
804743a0: 84040008  lwzu       r0, 8(r4)
804743a4: 90650004  stw        r3, 4(r5)
804743a8: 94050008  stwu       r0, 8(r5)
804743ac: 4200fff0  bdnz       0x8047439c
804743b0: 3c60807d  lis        r3, -0x7f83
804743b4: 38000006  li         r0, 6
804743b8: 38630378  addi       r3, r3, 0x378
804743bc: 38bf0190  addi       r5, r31, 0x190
804743c0: 3883fffc  addi       r4, r3, -4
804743c4: 7c0903a6  mtctr      r0
804743c8: 80640004  lwz        r3, 4(r4)
804743cc: 84040008  lwzu       r0, 8(r4)
804743d0: 90650004  stw        r3, 4(r5)
804743d4: 94050008  stwu       r0, 8(r5)
804743d8: 4200fff0  bdnz       0x804743c8
804743dc: 3c60807d  lis        r3, -0x7f83
804743e0: 38000006  li         r0, 6
804743e4: 38630378  addi       r3, r3, 0x378
804743e8: 38bf01c0  addi       r5, r31, 0x1c0
804743ec: 3883fffc  addi       r4, r3, -4
804743f0: 7c0903a6  mtctr      r0
804743f4: 80640004  lwz        r3, 4(r4)
804743f8: 84040008  lwzu       r0, 8(r4)
804743fc: 90650004  stw        r3, 4(r5)
80474400: 94050008  stwu       r0, 8(r5)
80474404: 4200fff0  bdnz       0x804743f4
80474408: 3c60807d  lis        r3, -0x7f83
8047440c: 38000006  li         r0, 6
80474410: 38630378  addi       r3, r3, 0x378
80474414: 38bf01f0  addi       r5, r31, 0x1f0
80474418: 3883fffc  addi       r4, r3, -4
8047441c: 7c0903a6  mtctr      r0
80474420: 80640004  lwz        r3, 4(r4)
80474424: 84040008  lwzu       r0, 8(r4)
80474428: 90650004  stw        r3, 4(r5)
8047442c: 94050008  stwu       r0, 8(r5)
80474430: 4200fff0  bdnz       0x80474420
80474434: 3c60807d  lis        r3, -0x7f83
80474438: 38000006  li         r0, 6
8047443c: 38630378  addi       r3, r3, 0x378
80474440: 38bf0220  addi       r5, r31, 0x220
80474444: 3883fffc  addi       r4, r3, -4
80474448: 7c0903a6  mtctr      r0
8047444c: 80640004  lwz        r3, 4(r4)
80474450: 84040008  lwzu       r0, 8(r4)
80474454: 90650004  stw        r3, 4(r5)
80474458: 94050008  stwu       r0, 8(r5)
8047445c: 4200fff0  bdnz       0x8047444c
80474460: 3c60807d  lis        r3, -0x7f83
80474464: 38000006  li         r0, 6
80474468: 38630378  addi       r3, r3, 0x378
8047446c: 38bf0250  addi       r5, r31, 0x250
80474470: 3883fffc  addi       r4, r3, -4
80474474: 7c0903a6  mtctr      r0
80474478: 80640004  lwz        r3, 4(r4)
8047447c: 84040008  lwzu       r0, 8(r4)
80474480: 90650004  stw        r3, 4(r5)
80474484: 94050008  stwu       r0, 8(r5)
80474488: 4200fff0  bdnz       0x80474478
8047448c: 3c60807d  lis        r3, -0x7f83
80474490: 38000006  li         r0, 6
80474494: 38630378  addi       r3, r3, 0x378
80474498: 38bf0280  addi       r5, r31, 0x280
8047449c: 3883fffc  addi       r4, r3, -4
804744a0: 7c0903a6  mtctr      r0
804744a4: 80640004  lwz        r3, 4(r4)
804744a8: 84040008  lwzu       r0, 8(r4)
804744ac: 90650004  stw        r3, 4(r5)
804744b0: 94050008  stwu       r0, 8(r5)
804744b4: 4200fff0  bdnz       0x804744a4
804744b8: 3c60807d  lis        r3, -0x7f83
804744bc: 38000006  li         r0, 6
804744c0: 38630378  addi       r3, r3, 0x378
804744c4: 38bf02b0  addi       r5, r31, 0x2b0
804744c8: 3883fffc  addi       r4, r3, -4
804744cc: 7c0903a6  mtctr      r0
804744d0: 80640004  lwz        r3, 4(r4)
804744d4: 84040008  lwzu       r0, 8(r4)
804744d8: 90650004  stw        r3, 4(r5)
804744dc: 94050008  stwu       r0, 8(r5)
804744e0: 4200fff0  bdnz       0x804744d0
804744e4: 3c60807d  lis        r3, -0x7f83
804744e8: 38000006  li         r0, 6
804744ec: 38630378  addi       r3, r3, 0x378
804744f0: 38bf02e0  addi       r5, r31, 0x2e0
804744f4: 3883fffc  addi       r4, r3, -4
804744f8: 7c0903a6  mtctr      r0
804744fc: 80640004  lwz        r3, 4(r4)
80474500: 84040008  lwzu       r0, 8(r4)
80474504: 90650004  stw        r3, 4(r5)
80474508: 94050008  stwu       r0, 8(r5)
8047450c: 4200fff0  bdnz       0x804744fc
80474510: 3c60807d  lis        r3, -0x7f83
80474514: 38000006  li         r0, 6
80474518: 38630378  addi       r3, r3, 0x378
8047451c: 38bf0310  addi       r5, r31, 0x310
80474520: 3883fffc  addi       r4, r3, -4
80474524: 7c0903a6  mtctr      r0
80474528: 80640004  lwz        r3, 4(r4)
8047452c: 84040008  lwzu       r0, 8(r4)
80474530: 90650004  stw        r3, 4(r5)
80474534: 94050008  stwu       r0, 8(r5)
80474538: 4200fff0  bdnz       0x80474528
8047453c: 3c60807d  lis        r3, -0x7f83
80474540: 38000006  li         r0, 6
80474544: 38630378  addi       r3, r3, 0x378
80474548: 38bf0340  addi       r5, r31, 0x340
8047454c: 3883fffc  addi       r4, r3, -4
80474550: 7c0903a6  mtctr      r0
80474554: 80640004  lwz        r3, 4(r4)
80474558: 84040008  lwzu       r0, 8(r4)
8047455c: 90650004  stw        r3, 4(r5)
80474560: 94050008  stwu       r0, 8(r5)
80474564: 4200fff0  bdnz       0x80474554
80474568: c04211c8  lfs        f2, 0x11c8(r2) ; [806ff248] 00000000 f32=0
8047456c: 3cc0807d  lis        r6, -0x7f83
80474570: d05f0374  stfs       f2, 0x374(r31)
80474574: 38a60318  addi       r5, r6, 0x318
80474578: 38000001  li         r0, 1
8047457c: 3c80807d  lis        r4, -0x7f83
80474580: d05f0378  stfs       f2, 0x378(r31)
80474584: d05f037c  stfs       f2, 0x37c(r31)
80474588: d05f0380  stfs       f2, 0x380(r31)
8047458c: d05f0384  stfs       f2, 0x384(r31)
80474590: d05f0388  stfs       f2, 0x388(r31)
80474594: c0060318  lfs        f0, 0x318(r6)
80474598: d01f038c  stfs       f0, 0x38c(r31)
8047459c: c0050004  lfs        f0, 4(r5)
804745a0: d01f0390  stfs       f0, 0x390(r31)
804745a4: c0050008  lfs        f0, 8(r5)
804745a8: d01f0394  stfs       f0, 0x394(r31)
804745ac: d05f0398  stfs       f2, 0x398(r31)
804745b0: d05f039c  stfs       f2, 0x39c(r31)
804745b4: 901f03a0  stw        r0, 0x3a0(r31)
804745b8: c0060318  lfs        f0, 0x318(r6)
804745bc: d01f03a4  stfs       f0, 0x3a4(r31)
804745c0: c0050004  lfs        f0, 4(r5)
804745c4: d01f03a8  stfs       f0, 0x3a8(r31)
804745c8: c0050008  lfs        f0, 8(r5)
804745cc: d01f03ac  stfs       f0, 0x3ac(r31)
804745d0: 84640354  lwzu       r3, 0x354(r4)
804745d4: 80040004  lwz        r0, 4(r4)
804745d8: 901f03b4  stw        r0, 0x3b4(r31)
804745dc: 907f03b0  stw        r3, 0x3b0(r31)
804745e0: 80040008  lwz        r0, 8(r4)
804745e4: 901f03b8  stw        r0, 0x3b8(r31)
804745e8: 8064000c  lwz        r3, 0xc(r4)
804745ec: 80040010  lwz        r0, 0x10(r4)
804745f0: 901f03c0  stw        r0, 0x3c0(r31)
804745f4: 907f03bc  stw        r3, 0x3bc(r31)
804745f8: 80040014  lwz        r0, 0x14(r4)
804745fc: 901f03c4  stw        r0, 0x3c4(r31)
80474600: 80640018  lwz        r3, 0x18(r4)
80474604: 8004001c  lwz        r0, 0x1c(r4)
80474608: 901f03cc  stw        r0, 0x3cc(r31)
8047460c: 907f03c8  stw        r3, 0x3c8(r31)
80474610: 80040020  lwz        r0, 0x20(r4)
80474614: 901f03d0  stw        r0, 0x3d0(r31)
80474618: c0060318  lfs        f0, 0x318(r6)
8047461c: d01f03d4  stfs       f0, 0x3d4(r31)
80474620: c0050004  lfs        f0, 4(r5)
80474624: d01f03d8  stfs       f0, 0x3d8(r31)
80474628: c0050008  lfs        f0, 8(r5)
8047462c: d01f03dc  stfs       f0, 0x3dc(r31)
80474630: 80640000  lwz        r3, 0(r4)
80474634: 80040004  lwz        r0, 4(r4)
80474638: 901f03e4  stw        r0, 0x3e4(r31)
8047463c: 907f03e0  stw        r3, 0x3e0(r31)
80474640: 80040008  lwz        r0, 8(r4)
80474644: 901f03e8  stw        r0, 0x3e8(r31)
80474648: 8064000c  lwz        r3, 0xc(r4)
8047464c: 80040010  lwz        r0, 0x10(r4)
80474650: 901f03f0  stw        r0, 0x3f0(r31)
80474654: 907f03ec  stw        r3, 0x3ec(r31)
80474658: 80040014  lwz        r0, 0x14(r4)
8047465c: 901f03f4  stw        r0, 0x3f4(r31)
80474660: 80640018  lwz        r3, 0x18(r4)
80474664: 8004001c  lwz        r0, 0x1c(r4)
80474668: 901f03fc  stw        r0, 0x3fc(r31)
8047466c: 907f03f8  stw        r3, 0x3f8(r31)
80474670: 80040020  lwz        r0, 0x20(r4)
80474674: 901f0400  stw        r0, 0x400(r31)
80474678: c0060318  lfs        f0, 0x318(r6)
8047467c: d01f0404  stfs       f0, 0x404(r31)
80474680: c0050004  lfs        f0, 4(r5)
80474684: 3c80807d  lis        r4, -0x7f83
80474688: d01f0408  stfs       f0, 0x408(r31)
8047468c: 38000000  li         r0, 0
80474690: c00211d8  lfs        f0, 0x11d8(r2) ; [806ff258] 3f800000 f32=1
80474694: 38640324  addi       r3, r4, 0x324
80474698: c0250008  lfs        f1, 8(r5)
8047469c: d03f040c  stfs       f1, 0x40c(r31)
804746a0: c0260318  lfs        f1, 0x318(r6)
804746a4: d03f0410  stfs       f1, 0x410(r31)
804746a8: c0250004  lfs        f1, 4(r5)
804746ac: d03f0414  stfs       f1, 0x414(r31)
804746b0: c0250008  lfs        f1, 8(r5)
804746b4: d03f0418  stfs       f1, 0x418(r31)
804746b8: c0260318  lfs        f1, 0x318(r6)
804746bc: d03f041c  stfs       f1, 0x41c(r31)
804746c0: c0250004  lfs        f1, 4(r5)
804746c4: d03f0420  stfs       f1, 0x420(r31)
804746c8: c0250008  lfs        f1, 8(r5)
804746cc: d03f0424  stfs       f1, 0x424(r31)
804746d0: 901f0428  stw        r0, 0x428(r31)
804746d4: d01f042c  stfs       f0, 0x42c(r31)
804746d8: d05f0430  stfs       f2, 0x430(r31)
804746dc: 901f0434  stw        r0, 0x434(r31)
804746e0: d05f0438  stfs       f2, 0x438(r31)
804746e4: d05f043c  stfs       f2, 0x43c(r31)
804746e8: c0040324  lfs        f0, 0x324(r4)
804746ec: d01f0440  stfs       f0, 0x440(r31)
804746f0: c0030004  lfs        f0, 4(r3)
804746f4: d01f0444  stfs       f0, 0x444(r31)
804746f8: c0030008  lfs        f0, 8(r3)
804746fc: d01f0448  stfs       f0, 0x448(r31)
80474700: d05f044c  stfs       f2, 0x44c(r31)
80474704: d05f0450  stfs       f2, 0x450(r31)
80474708: c0060318  lfs        f0, 0x318(r6)
8047470c: d01f0454  stfs       f0, 0x454(r31)
80474710: c0050004  lfs        f0, 4(r5)
80474714: d01f0458  stfs       f0, 0x458(r31)
80474718: c0050008  lfs        f0, 8(r5)
8047471c: d01f045c  stfs       f0, 0x45c(r31)
80474720: 901f0460  stw        r0, 0x460(r31)
80474724: d05f0464  stfs       f2, 0x464(r31)
80474728: d05f0468  stfs       f2, 0x468(r31)
8047472c: c0060318  lfs        f0, 0x318(r6)
80474730: d01f046c  stfs       f0, 0x46c(r31)
80474734: c0050004  lfs        f0, 4(r5)
80474738: d01f0470  stfs       f0, 0x470(r31)
8047473c: c0050008  lfs        f0, 8(r5)
80474740: d01f0474  stfs       f0, 0x474(r31)
80474744: d05f0478  stfs       f2, 0x478(r31)
80474748: d05f047c  stfs       f2, 0x47c(r31)
8047474c: 83e1000c  lwz        r31, 0xc(r1)
80474750: 80010014  lwz        r0, 0x14(r1)
80474754: 7c0803a6  mtlr       r0
80474758: 38210010  addi       r1, r1, 0x10
8047475c: 4e800020  blr        
