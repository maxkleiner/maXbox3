:: ***********************************************
:: Compilation of DMath library for Delphi/Windows
:: ***********************************************

dcc32 dmath.dpr -$O+ -U..\units -DDELPHI 
dcc32 dmath.pas -$O+ -I..\units -DDELPHI

