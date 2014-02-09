:: *********************************************
:: Compilation of DMath library for FPC/Windows
:: *********************************************

fpc dmath.dpr -O2 -Fu..\units -Mdelphi
fpc dmath.pas -O2 -Fi..\units -Mdelphi

del ..\units\*.o
del ..\units\*.ppu
