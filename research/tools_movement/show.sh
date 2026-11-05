#!/bin/bash
# usage: show.sh start end  -> compact disassembly of range (prologue noise removed)
cd "D:/projects/claude's wii sports plan"
py -3 pingpong/tools/ppc_probe.py dump $1 $2 > /tmp/_s.txt
py -3 resortcompiled/research/tools_movement/compact2.py /tmp/_s.txt
