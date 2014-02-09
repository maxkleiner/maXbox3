#!/bin/sh

# ************************************************
# Compilation of DMath library for Lazarus / Linux
# ************************************************

fpc dmath.dpr -O2 -Fu../units -Mdelphi -dDELPHI
fpc dmath.pas -O2 -Fi../units -Mdelphi -dDELPHI

rm -f ../units/*.o
rm -f ../units/*.ppu
