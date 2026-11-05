from ppcemu import *
for x in (-90,-60,-30,0,30,50,59,60,61,65,70,75,80,85,89,90,95):
    e=Emu()
    _,r=e.call(0x80325228,(),(float(x),60.0,90.0,70.0))
    print(x, r)
