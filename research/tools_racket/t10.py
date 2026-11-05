from ppcemu import *
import math
e=Emu()
print("ease")
for t in (0,0.1,0.25,0.4,0.5,0.6,0.75,0.9,1.0):
    e=Emu(); _,r=e.call(0x80326180,(),(t,1.0)); print(t,r)
print('soft')
xs=[60,62,65,70,75,80,85,88,90]
for x in xs:
    e=Emu(); _,r=e.call(0x80325228,(),(float(x),60.0,90.0,70.0))
    u=(x-60)/30; print(x,r, 60+10*(1-(1-u)**2), 60+10*math.sin(u*math.pi/2))
