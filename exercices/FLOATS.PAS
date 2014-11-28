{ ******************************************************************* }
{ Turbo Pascal Version 4.0 -> 7.0   64-Bit IEEE Double conversions    }
{ ------------------------------------------------------------------- }
{ Copyright 1992 Roger E. Donais              <rdonais@southeast.net> }
{ ------------------------------------------------------------------- }

UNIT floats;
{ ******************************************************************* }
{ This unit is designed to convert 64-Bit IEEE Doubles to and from    }
{ strings without the use of a numeric coprocessor or floating point  }
{ library.  Its original use was for a CD-ROM application that needed }
{ FP support only to read numbers and dates from Lotus sptread sheets }
{ and to build Lotus spread sheets from columnar text data.  The 700  }
{ bytes required by this unit is substantially less than the 10-12k   }
{ needed for full blown software emulation.                   ...red  }
{ ******************************************************************* }

INTERFACE

type  Float = array[0.. 7] of byte;   { 64-Bit IEEE Double }

Function  Str2Float(var Number: Float; const Str: String): Boolean;
{ =================================================================== }
{ Converts an integer or decimal string in the form of 123, or 123.45 }
{ to a 64-Bit ieee double. Does not handle exponent notation (123E4)  }
{ Returns TRUE if conversion was successful                           }
{ =================================================================== }

Function  Float2Str(var Number: Float; Precision : integer ) : string;
{ =================================================================== }
{ Converts a 64-Bit ieee double to an ascii string with the specified }
{ number of edcimal places.                                           }
{ =================================================================== }

FUNCTION Trunc(Number: Float): Longint;
{ =================================================================== }
{ Returns the whole number, drops fraction from a 64-Bit ieee double  }
{ =================================================================== }

{ ******************************************************************* }
IMPLEMENTATION
USES UTIL;

FUNCTION Trunc{ (Number: Float): Longint };
{ =================================================================== }
BEGIN
    Trunc := Binary(Float2Str(Number, 0));
END;

{$L FLOATP }
Function Float2Str(VAR Number: Float; Precision: integer): String; EXTERNAL;
Function Str2Float(VAR Number: Float; const Str: String): Boolean; EXTERNAL;

END.

{ ------------------------------------------------------------------- }
{ The following and UNITS were build with $N+ option, and was used to }
{ test float conversions.                                             }
{ ------------------------------------------------------------------- }

{$X+}
USES UTIL, FLOATS;

VAR r,x: Double;
    i,j: Integer;
    s,t: String;
BEGIN
    RandSeed := SYSTEM.Trunc(PI*1E6);
    For i := 1 to 32000 Do Begin
        r := Random;
        j := Random(12);
        s := Real2Str(r, j);
        r := Str2Real(s);
        t := Float2Str(Float(r), j);
        If s <> t Then
           Writeln('S: ', s, ' # ', t);
        Str2Float(Float(x), s);
        If r - x > 1E16 Then
           Writeln('X: ', r:22:8, ' # ', x:22:8, ' : ', r-x);
        twiddle;
    End;
END.

