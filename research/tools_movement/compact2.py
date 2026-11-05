import sys,re
skip=re.compile(r'^(mflr|mtlr|psq_st f(2[89]|3[01]), \d+\(r1\)|psq_l f(2[89]|3[01]), \d+\(r1\)|stfd f(2[89]|3[01]), 0x[0-9a-f]+\(r1\)|lfd f(2[89]|3[01]), 0x[0-9a-f]+\(r1\)|stmw|lmw|blr|nop)')
for l in open(sys.argv[1]):
    m=re.match(r'([0-9a-f]{8}): [0-9a-f]{8}\s+(\S+)\s*(.*)',l.rstrip())
    if not m: continue
    a,mn,op=m.groups()
    s=f"{mn} {op}"
    if skip.match(s) : 
        if mn=='blr': print(f"{a[4:]} blr\n")
        continue
    if re.match(r'(stwu r1|stw r0, 0x\w+\(r1\)|lwz r0, 0x\w+\(r1\)|addi r1, r1|addi r11, r1|bl 0x800078|bl 0x8000783|bl 0x8000784|bl 0x8000785|bl 0x8000786|bl 0x8000788|bl 0x8000789|bl 0x800078[0-9a-f])',s): continue
    op=re.sub(r'; \[[0-9a-f]+\] [0-9a-f]{8} f32=',' ;=',op)
    print(f"{a[4:]} {mn} {op}")
