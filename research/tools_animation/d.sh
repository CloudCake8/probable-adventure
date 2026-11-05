#!/bin/sh
# compact disassembly: d.sh lo hi
cd "D:/projects/claude's wii sports plan"
py -3 pingpong/tools/ppc_probe.py dump $1 $2 | awk '{ $2=""; print }' | sed -E 's/ f32=([0-9.e+-]+)/ =\1/' | cut -c1-110
