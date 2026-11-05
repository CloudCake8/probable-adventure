import sys,re
for l in open(sys.argv[1]):
    m=re.match(r'([0-9a-f]{8}): [0-9a-f]{8}\s+(\S+)\s*(.*)',l.rstrip())
    if not m: continue
    a,mn,op=m.groups()
    op=re.sub(r'; \[[0-9a-f]+\] [0-9a-f]{8} f32=',' ;=',op)
    print(f"{a[4:]} {mn} {op}")
