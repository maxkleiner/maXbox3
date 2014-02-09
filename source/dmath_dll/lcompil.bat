:: ************************************************
:: Compilation of DMath library for Lazarus/Windows
:: ************************************************

fpc dmath.dpr -O2 -Fu..\units -Mdelphi -dDELPHI
fpc dmath.pas -O2 -Fi..\units -Mdelphi -dDELPHI

del ..\units\*.o
del ..\units\*.ppu
