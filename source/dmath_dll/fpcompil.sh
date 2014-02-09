#!/bin/sh

# ********************************************
# Compilation of DMath library for FPC / Linux
# ********************************************

fpc dmath.dpr -O2 -Fu../units -Mdelphi
fpc dmath.pas -O2 -Fi../units -Mdelphi

rm -f ../units/*.o
rm -f ../units/*.ppu
