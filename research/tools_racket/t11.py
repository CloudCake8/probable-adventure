from ppcemu import *
import numpy as np
us=[];ss=[]
for x in range(60,91):
    e=Emu(); _,r=e.call(0x80325228,(),(float(x),60.0,90.0,70.0)); us.append((x-60)/30); ss.append((r-60)/10)
us=np.array(us);ss=np.array(ss)
for deg in (2,3,4):
    c=np.polyfit(us,ss,deg); print(deg,c, np.max(np.abs(np.polyval(c,us)-ss)))
