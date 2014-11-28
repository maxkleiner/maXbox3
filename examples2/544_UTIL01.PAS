{ ******************************************************************* }
{ Turbo Pascal Version 4.0 -> 7.0 Utility Functions and Procedures    }
{ ------------------------------------------------------------------- }
{ Copyright 1988, 1995 Roger E. Donais        <rdonais@southeast.net> }
{ ------------------------------------------------------------------- }

Program TPUtils;

{ INCLUDE FOR UTIL.PAS }
{ IMPLEMENTATION       }

FUNCTION Real2Str(Value: Real; Precision: Byte): String;
{ =================================================================== }
VAR aResult  : String;
BEGIN
    //Str(Value:1:Precision,aResult);
    result:= aResult;
END;


FUNCTION Str2Str(const Source: String; Precision: Integer): String;
{ =================================================================== }
VAR  Number : Real;
BEGIN{Str2Str}
    Number := Str2Real(Source);
    //PushFlag(Okay, TRUE);
    result:= Real2Str(Number, Precision);
    //PopFlag;
END{Str2Str};


FUNCTION Comma(const Number: String): String;
{ =================================================================== }
VAR i: Integer;
    s: String;
BEGIN
    s := Trim(Number);
    i := pos('.', s) -3;
    While i > 1 Do Begin
       Insert(',', s, i);
       Dec1(i,3);
    End;
    result:= s;
END;


FUNCTION LongFormat(Value: Longint; Width: Byte): String;
{ =================================================================== }
BEGIN{RealFormat}
    //result:= Rset(Comma(Ascii(Value, 1)), Width);
END{RealFormat};


FUNCTION RealFormat(Value: Real; Width, Precision: Byte): String;
{ =================================================================== }
BEGIN{RealFormat}
    //RealFormat := Rset(Comma(Real2Str(Value, Precision)), Width);
END{RealFormat};

var okay: boolean;


FUNCTION Str2Real2(const Source: String): Real;
{ =================================================================== }
VAR  aResult : Real;
     aError,i: Integer;
     s: String;
BEGIN{Str2Real}

    s := StripString(',',Trim(Source));
    If StripString(' .-', s) <> '' Then Begin
       Insert('0', S, Succ(Pos('-', S)));
       //Val(S, Result, aError);
       If aError = 0 Then Begin
          result:= aResult;
          //Okay := TRUE;
       End Else Begin
          result:= 0.0;
          //Okay := FALSE;
       End;
    End Else Begin
       result:= 0.0;
       //Okay := FALSE;
    End;

END{Str2Real};


FUNCTION DistFormat(Dist : Real): String;
{ =================================================================== }
VAR miles, feet : Longint;

BEGIN{DistFormat};

   If Abs(Dist) < 0.0003 Then Dist := 0.0;

   miles := Trunc(Dist/5280.0);
   feet  := Trunc(Dist - Miles * 5280.0);
   //result:=  Ascii(Miles,1) + ':' + ZFill(Ascii(Feet,4));

END{DistFormat};


FUNCTION Str2Dist(const Source: String): Real;
{ =================================================================== }
VAR   i,j: Integer;
        r: Real;

BEGIN{Str2Dist}

    i := Pos(':',Source);
    If i = 0 Then Begin
       result:= Str2Real(Source);
    End Else Begin
       r := 5280 * Str2Real(Copy(Source,1,Pred(i)));
       If Okay Then Begin
          r := r + Str2Real(Copy(Source,Succ(i),255));
       End;
       result:= r;
    End;

END{Str2Dist};


FUNCTION TimeFormat(Time: Real): String;
{ =================================================================== }
VAR x,y: LongInt;

BEGIN{TimeFormat}

    x := Trunc(Time / 3600); Time := Time - 3600 * x;
    y := Trunc(Time / 60);   Time := Time - 60 * y;
  //TimeFormat:= Zfill(Ascii(x,1) + ':' + Ascii(y,2) + ':' + Ascii(SYSTEM.Trunc(Time),2));

END{TimeFormat};


FUNCTION Str2Time(const Source: String): Real;
{ =================================================================== }
VAR   i,j: Integer;
   Time,r: Real;

BEGIN{Str2Time}

    i := Pos(':',Source);
    If i = 0 Then Begin
       result:= Str2Real(Source);
    End Else Begin
       Time := 3600.0 * Str2Real(Copy(Source,1,Pred(i)));
       If Okay Then Begin
          //j := Lpos(':',Source);
          If i = j Then
             Time := Time + 60.0 * Str2Real(Copy(Source,Succ(i),255))
          Else Begin
             Time := Time + 60.0 * Str2Real(Copy(Source,Succ(i),Pred(j)));
             If OKay Then Begin
                Time := Time + Str2Real(Copy(Source,Succ(j),255));
             End;
          End;
       End;
       result:= Time;
    End;

END{Str2Time};


FUNCTION Power(Number, Exponent: Real): Real;
{ =================================================================== }
BEGIN
    If Number = 0.0 Then
       If Exponent = 0.0 Then
          result:= 1.0
       Else result:= 0.0
    Else
       result:= Exp(Exponent * Ln(Abs(Number)));
END;

(*
FUNCTION  Maximum{ (i,j: Real): Real };
{ =================================================================== }
BEGIN
    If i > j Then
       Maximum := i
    Else Maximum := j
END;


FUNCTION  Minimum{ (i,j: Real): Real };
{ =================================================================== }
BEGIN
    If i < j Then
       Minimum := i
    Else Minimum := j
END;

(*
{$L HEX.OBJ      }  FUNCTION  Hex;                          External;
{$L BIN2STR.OBJ  }  FUNCTION  Bin;                          External;
{$L UPCASE.OBJ   }  FUNCTION  UpperCase;                    External;
                    FUNCTION  LowerCase;                    External;
{$L STRINGOF.OBJ }  FUNCTION  StringOf;                     External;
                    FUNCTION  Spaces;                       External;
                    FUNCTION  Lset;                         External;
{$L ZFILL.OBJ    }  FUNCTION  Zfill;                        External;
{$L TRIM.OBJ     }  FUNCTION  Trim;                         External;
                    FUNCTION  Trimmed;                      External;
                    FUNCTION  Strim;                        External;
                    FUNCTION  Ctrim;                        External;
                    FUNCTION  Ltrim;                        External;
                    FUNCTION  Rtrim;                        External;
                    FUNCTION  Ftrim;                        External;
                    FUNCTION  StrOf;                        External;
                    FUNCTION  TrimStrOf;                    External;
                    PROCEDURE Compress;                     External;
{$L APOS.OBJ     }  FUNCTION  Apos;                         External;
{$L NPOS.OBJ     }  FUNCTION  Npos;                         External;
{$L COUNT.OBJ    }  FUNCTION  Count;                        External;
                    FUNCTION  Dcount;                       External;
{$L PUSH&POP.OBJ }  PROCEDURE PushChar;                     External;
                    PROCEDURE PopChar;                      External;
                    PROCEDURE PushByte;                     External;
                    PROCEDURE PopByte;                      External;
                    PROCEDURE PushFlag;                     External;
                    PROCEDURE PopFlag;                      External;
                    PROCEDURE PushWord;                     External;
                    PROCEDURE PopWord;                      External;
                    PROCEDURE PushInteger;                  External;
                    PROCEDURE PopInteger;                   External;
                    PROCEDURE PushLong;                     External;
                    PROCEDURE PopLong;                      External;
                    PROCEDURE PushPtr;                      External;
                    PROCEDURE PopPtr;                       External;
{$L MINMAX.OBJ   }  FUNCTION  Min;                          External;
                    FUNCTION  Max;                          External;
                    FUNCTION  AbsMin;                       External;
{$L IMINMAX.OBJ  }  FUNCTION  iMin;                         External;
                    FUNCTION  iMax;                         External;
                    FUNCTION  iLimit;                       External;
{$L ISBLANK.OBJ  }  FUNCTION  IsBlank;                      External;
{$L LPOS.OBJ     }  FUNCTION  Lpos;                         External;
{$L BLAST.OBJ    }  FUNCTION  BeforeLast;                   External;
{$L REVERSE.OBJ  }  PROCEDURE Reverse;                      External;
{$L EXCHANGE.OBJ }  PROCEDURE Exchange;                     External;
{$L SCOMP.OBJ    }  FUNCTION  Scomp;                        External;
{$L MEMCOMP.OBJ  }  FUNCTION  MemComp;                      External;
{$L ISIGN.OBJ    }  FUNCTION  iSign;                        External;
{$L SIGNOF.OBJ   }  FUNCTION  SignOf;                       External;
{$L CHARAT.OBJ   }  FUNCTION  IdxAt;                        External;
                    FUNCTION  CharAt;                       External;
                    FUNCTION  LChar;                        External;
{$L ISINT.OBJ    }  FUNCTION  IsInteger;                    External;
{$L HASNUM.OBJ   }  FUNCTION  HasNumber;                    External;

{$IFNDEF DPMI}
{$L FARPTR.OBJ   }  PROCEDURE Normalize;                    External;
                    FUNCTION  FarPtr;                       External;
{$ENDIF}
 *)


FUNCTION Boundary(i, j: Longint): Longint;
{ =================================================================== }
BEGIN
    j := Max(1, j);
    result:= (i div j) * j;
END;


FUNCTION Limit(Low, Number, High: LongInt): Longint;
{ =================================================================== }
BEGIN
    result:= Max(Low, Min(Number, High));
END;


(*
FUNCTION Fields{ (const MainString,Delimiter: String; Skip,Number: Integer): String };
{ =================================================================== }
VAR i,j: Integer;
BEGIN{Fields}

    If Hi(Skip) = 0 Then Begin
       i := Npos(Delimiter,MainString,Skip);
       j := Npos(Delimiter,MainString,Skip+Number);
       If i > 0 Then Begin
          Inc(i,Ord(Delimiter[0]));
          Fields := Copy(MainString,i,j-i);
       End Else Fields := Copy(MainString,1,Pred(j))
    End Else Fields := '';

END{Fields};


FUNCTION Field{ (const MainString,Delimiter: String; Occurrence: Integer): String };
{ =================================================================== }
VAR i,j: Integer;

BEGIN{Field}

    If Occurrence > 0 Then
       Field := Fields(MainString,Delimiter,Pred(Occurrence),1)
    Else Field := '';

END{Field};


FUNCTION BeforeFirst{ (const SubStr,MainStr: String): String };
{ =================================================================== }
{ Returns the portion of "MainStr" to the left of the first Occurrence}
{ of "SubSTr", or all of "MainStr" if "SubStr" does not occur         }
{ =================================================================== }
VAR i: Integer;

BEGIN{BeforeFirst}

    BeforeFirst := Copy(MainStr,1,Pred(Apos(SubStr,MainStr)));

END{BeforeFirst};


FUNCTION AfterFirst{ const SubStr,MainStr: String): String };
{ =================================================================== }
VAR i: Integer;

BEGIN{AfterFirst}

    i := Apos(SubStr,MainStr) + Ord(SubStr[0]);
    If i <= Ord(MainStr[0]) Then
       AfterFirst := Copy(MainStr,i,255)
    Else AfterFirst := ''

END{AfterFirst};


FUNCTION AfterLast{ (const SubStr,MainStr: String): String };
{ =================================================================== }
VAR i: Integer;

BEGIN{AfterLast}

    i := Lpos(SubStr,MainStr);
    If i = 0 Then AfterLast := '' Else AfterLast := Copy(MainStr,Succ(i),255);

END{AfterLast};


FUNCTION Rset{ (const s: String; Width: Integer): String };
{ =================================================================== }
BEGIN
    If Hi(Width) <> 0 Then Rset := ''
    Else If Ord(s[0]) > Width Then
       Rset := Copy(s,Succ(Ord(s[0])-Width),Width)
    Else Rset := Spaces(Width-Ord(s[0])) + s;
END;


FUNCTION Ascii{ (Number: LongInt; Width: Integer): String };
{ ================================================================== }
VAR S: String;

BEGIN
    Str(Number:width,s);
    Ascii := s;
END;


FUNCTION Binary{ (const S: String): LongInt };
{ ================================================================== }
VAR i: LongInt;
    j: Integer;

BEGIN
    Val(Strip(',',Change('O','0',Change('l','1',Trim(s)))),i,j);
    If j = 0 Then Begin
       Binary := i;
       Okay := TRUE;
    End Else Begin
       Binary := 0;
       Okay := FALSE;
    End;
END;


FUNCTION CodeCase{ (const s: String): String };
{ ===================================================================}
VAR i: Integer;
    t: String;
BEGIN
    t := LowerCase(s);
    t[1] := UpCase(t[1]);
    For i := 2 to Ord(t[0]) Do
       If NOT( t[i-1] in Alpha) Then
          t[i] := UpCase(t[i]);
    CodeCase := t;
END;


FUNCTION WordCase{ const S: String): String };
{ ================================================================== }
{ Returns "S" with individual words uppercased                       }
{ ================================================================== }
VAR  i: Integer;
     t: String;
BEGIN
    t := LowerCase(s);
    t[1] := UpCase(t[1]);
    For i := 2 to Ord(t[0]) Do
       If NOT(t[i-1] in Alpha) Then
          t[i] := UpCase(t[i]);
    WordCase := t;
END;


FUNCTION LineCase{ const S: String): String };
{ ================================================================== }
{ Returns "S" with individual words uppercased                       }
{ ================================================================== }
VAR  i: Integer;
     t: String;
LABEL Break;
BEGIN
    t := LowerCase(s);
    For i := 1 to Ord(t[0]) Do
       If (t[i] > ' ') Then Begin
          t[i] := UpCase(t[i]);
          goto Break;
       End;
       Break:

    LineCase := t;
END;

FUNCTION Roman{ (No: Word): String };
{ =================================================================== }
{ i 1
  v 5
  x 10
  l 50
  c 100
  d 500
  m 1000
{ Good for Numbers  1..3999 }
VAR s: String;

      Procedure Rom({$IFDEF C}const{$ENDIF} t: String; Tic: Word);
      { ------------------------------------------------------------- }
      VAR i: Word;
      Begin
          If No >= Tic Then
             Rom(Copy(t, 3, 80), Tic*10);

          i := (No * 10) div Tic;

          If (i = 9) {and ModernRoman} Then
             s := s + t[1]+t[3] {'ix'}
          Else
          If (i = 4) {and ModernRoman} Then
             s := s + t[1]+t[2] {'iv'}
          Else Begin
             if i >= 5 Then Begin
                s := s + t[2];  {'v'}
                Dec(i, 5);
             End;
             s := s + Stringof(t[1]{'i'}, i);
          End;
          No := No mod (Tic div 10);
      End;

BEGIN
//{$IFOPT R+}
    If No >= 4000 Then RunError(201);
//{$ENDIF}

    If No >= 4000 Then
       Roman := Ascii(No,1)
    Else Begin
       s := '';
       Rom('ivxlcdm', 10);
       Roman := s;
    End;
END;


FUNCTION OrdNum{ (No: Word): String };
{ =================================================================== }
CONST Suffix: Array[0..9] of Array [1..2] of Char =
              ('th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th');
BEGIN
    If (No > 10) and (No < 20) Then
       OrdNum := Ascii(No,1)+'th'
    Else
       OrdNum := Ascii(No,1)+Suffix[No Mod 10];
END;


FUNCTION Ordinal{ (No: Integer): String };
{ =================================================================== }
CONST Lo: Array[1..19] of String[11] =
          ( 'first',     'second',     'third',     'fourth',    'fifth',
            'sixth',     'seventh',    'eighth',    'ninth',     'tenth',
            'eleventh',  'twelfth',    'thirteenth','fourteenth','fifteenth',
            'sixteenth', 'seventeenth','eighteenth','nineteenth');

      Ten: Array[2..9] of String[5] =
          ( 'twen', 'thir',  'for',  'fif',
            'six',  'seven', 'eigh', 'nine');

BEGIN
    If (No < 1) or (No > 99) Then
       Ordinal := OrdNum(No)
    Else
    If No < 20 Then
       Ordinal := Lo[No]
    Else
    If No mod 10 = 0 Then
      Ordinal := Ten[No div 10] + 'tieth'
    Else Ordinal := Ten[No div No] + 'ty-' + Lo[No mod 10];
END;


FUNCTION Number{ (No: Word): String };
{ =================================================================== }

    Function Num(No: Word): String;
    { --------------------------------------------------------------- }
    CONST Lo: Array[1..19] of String[ 9] =
              ( 'one',     'two',      'three',   'four',    'five',
                'six',     'seven',    'eight',   'nine',    'ten',
                'eleven',  'twelve',   'thirteen','fourteen','fifteen',
                'sixteen', 'seventeen','eighteen','nineteen');

          Ten: Array[2..9] of String[5] =
              ( 'twen', 'thir',  'for',  'fif',
                'six',  'seven', 'eigh', 'nine');
    Begin
        If No < 20 Then Begin
          If No <> 0 Then
             Num := Lo[No]
        End Else
        If No mod 10 = 0 Then
          Num := Ten[No div 10] + 'ty'
        Else Num := Ten[No div 10] + 'ty-' + Lo[No mod 10];
    End;

VAR s: String;
BEGIN
    If No = 0 Then
       Number := 'zero'
    Else Begin
       s := '';
       If No >= 2000 Then Begin
          s := Num(No div 1000)+ ' thousand ';
          No := No mod 1000;
       End;
       If No >= 100 Then Begin
          s := s + Num(No div 100) + ' hundred ';
          No := No mod 100;
       End;
       If No <> 0 Then
          s := Ftrim(s + Num(No));
    End;
    Number := s;
END;


{$IFDEF GETENV}
FUNCTION DosVersion: Integer;
{ =================================================================== }
{ Returns DosVersion Hi:Minor, Lo:Major                               }
{ =================================================================== }
VAR Reg: Registers;
BEGIN
    Reg.AX := $3000;
    MsDos(Reg);
    DosVersion := Reg.AX;
END;


FUNCTION GetEnv(s: String): String;
{ =================================================================== }
TYPE CharPointer = ^CharArray;
     CharArray   = Array [1..255] of Char;

VAR   p : CharPointer;
    i,j : Integer;

BEGIN{GetEnv}

    p := Ptr(MemW[PrefixSeg:$002C],0);             { Get start of environment }
    If (s = #0) Then Begin
       If Lo(DosVersion) >= 3 Then Begin
          While p^[1] <> #0 Do Begin               { While more strings       }
             {i := Pos('=',p^);}
             j := Pos(#0,p^);                      {    setup indicies        }
             {\p := Addr(p^[Succ(j)]);             {    step to next entry    } {}
             IncPtr(p, Succ(j));
          End;                                     { endwhile                 }
          {p := Addr(p^[4]);}                      { Skip nul and word count  }
          IncPtr(p, 4);
          GetEnv := Copy(p^,1,Pos(#0,p^)-1);       { return the value         }
          Exit;
       End;
    End Else Begin
       While p^[1] <> #0 Do Begin                  { While more strings       }
           i := Pos('=',p^); j := Pos(#0,p^);      {    setup indicies        }
           If Copy(p^,1,Pred(i)) = s Then Begin    {    if matching parameter }
              GetEnv := Trim(Copy(p^,Succ(i),j-i));{       return the value   }
              Exit;
           End;                                    {    endif                 }
           {p := Addr(p^[Succ(j)]);}               {    step to next entry    }
           IncPtr(p, Succ(j));
       End;                                        { endwhile                 }
    End;
    GetEnv := '';                                  { return nul value         }

END{GetEnv};
{$ENDIF}

FUNCTION SetupString{ (s: String): String };
{ =================================================================== }
VAR i: Integer;
    t: String;
    c: Char;
BEGIN{Change}

    t := '';
    i := Pos('\', s);
    While i <> 0 Do Begin
       c := Char(Binary(Copy(s, i+1, 3)));
       If Okay Then Begin
          t := t + Copy(s, 1, i-1) + c;
          Delete(s, 1, i+3);
       End Else Begin
          t := t + Copy(s, 1, i-1) + '\';
          Delete(s, 1, i);
       End;
       i := Pos('\', s);
    End;
    SetupString := t + s;

END{Change};


FUNCTION Change{ (const OldTxt,NewTxt: String; MainStr: String): String };
{ =================================================================== }
VAR i,j: Integer;

BEGIN{Change}

    i := 0;
    j := Pos(OldTxt,Copy(MainStr,Succ(i),255));
    While j <> 0 Do Begin
       Delete(MainStr,i + j,Ord(OldTxt[0]));
       Insert(NewTxt,MainStr,i + j);
       i := Pred(i + j + Ord(NewTxt[0]));
       j := Pos(OldTxt,Copy(MainStr,Succ(i),255));
    End;
    Change := MainStr;

END{Change};


FUNCTION Strip{ (const SubString: String; MainString: String): String };
{ =================================================================== }
VAR i,j: Integer;

BEGIN{Strip}

    j := Ord(SubString[0]);
    If j <> 0 Then Begin
       i := Pos(SubString,MainString);
       While i <> 0 Do Begin
           Delete(MainString, i, j);
           i := Pos(SubString,MainString);
       End;
   End;
   Strip := MainString;

END{Strip};

{$IFNDEF STRINGS}
{ =================================================================== }
{ Following C-String functions are provided to make this nnit         }
{ compatibility with Turbo 4.0 through 6.0                     ...red }
{ =================================================================== }

function StrEnd(Str: PChar): pChar;
{ =================================================================== }
Begin
   INLINE ($FC             { CLD             }
          /$C4 /<Str       { LES   DI,S      }
          /$B9 /$FFFF      { MOV   CX,-1     }
          /$32 /$C0        { XOR   AL,AL     }
          /$F2 /$AE        { REPNE SCASB     }
          /$8C /$C2        { mov   DX,ES     }
          /$8D /$45 /$FF   { lea   AX,[DI-1] }
   );
END;


FUNCTION StrLen(Str: pChar): Word;
{ =================================================================== }
VAR p: pChar;
Begin
    p := StrEnd(Str);
    StrLen := Ofs(p^) - Ofs(Str^);
end;


FUNCTION StrPas(p: pChar): String;
{ =================================================================== }
VAR s: String;
BEGIN
    s := StrOf(p^, 255);
    s[0] := Char(Apos(#0, s));
    StrPas := s;
END;


PROCEDURE StrPCopy(Target: pChar; Source: String);
{ =================================================================== }
BEGIN
    Move(Source, Target^, Ord(Source[0]));
    Byte( Ptr(Seg(Target^), Ofs(Target^)+Ord(Source[0]))^ ) := 0;
    {\Byte( AddPtr(Target, Ord(Source[0]))^ ) := 0; {}
END;
{$ENDIF}

FUNCTION StrPECopy(Target: pChar; {const} Source: String): pChar;
{ =================================================================== }
BEGIN
    Move(Source, Target^, Ord(Source[0]));
    {\Target := Ptr(Seg(Target^), Ofs(Target^)+Ord(Source[0])); {}
    IncPtr(Target, Ord(Source[0]));
    Target^ := #0;
    StrPECopy := Target;
END;



FUNCTION StrLPas(P: Pchar; MaxLen: Integer): String;
{ =================================================================== }
VAR Temp: String;
BEGIN
    If Hi(MaxLen) <> 0 Then
       StrLPas := ''
    Else Begin
       StrLPas := Copy(StrPas(p), 1, MaxLen);
    End;
END;


PROCEDURE WrapLines(VAR a, b: String; len: Integer);
{ =========================================================== }
VAR Temp: Array[0..514] of Char;
    i, j, k: Integer;

    PROCEDURE BreakLine(i: Integer);
    { ------------------------------------------------------- }
    VAR p: PChar;
    BEGIN{BreakLine}
        p := @Temp[i];
        b := StrPas(p);
        p^ := #0;
        a := StrPas(@Temp);
    END{BreakLine};

BEGIN{WrapLines}

    k := Length(a) + Length(b);
    If Len < k Then Begin

       StrPCopy(@Temp, a);
       StrPCopy(@Temp[Length(a)], b);
       i := Len;

       { locate Space before current word }
       While (i > 1) and (Temp[i] <> ' ') Do Dec(i);
       j := i;

       { locate space at end of previous word }
       While (i > 1) and (Temp[i] = ' ') Do Dec(i);

       If i > 1 Then Begin
          While (j <= k) and (Temp[j] = ' ') Do Inc(j);
          BreakLine(j)
       End Else Begin
          i := Len;

          { Before punctuation }
          While (i > 1) and NOT(Temp[i] in AlphaN) Do Dec(i);

          { Beginning of current word }
          While (i > 1) and (Temp[i] in AlphaN) Do Dec(i);

          If i > 1 Then
             BreakLine(i+1)
          Else BreakLine(Len);
       End;
    End Else Begin
       { combine & clear overflow if len <= combined length }
       a := a + b;
       b := '';
    End;

END{WrapLines};


FUNCTION PreviousCopy: Boolean;
{ ==================================================================== }
TYPE CharArray = Array[1..255] Of Char;
     MCBrecord = RECORD
       Case integer of
         1: (id    : Byte;
             Owner : Word;
             Length: Word);
         2: (Size  : Array[1..16] Of Byte);
     END;

CONST    MidMcb = $4D;
         LstMcb = $5A;

VAR  MCB: ^MCBrecord;
     Lst: Word;
     s,t: ^CharArray;
     reg: Registers;

BEGIN
      PreviousCopy := TRUE;        { Assume previous copy exists }
{\    Reg.AH := $52; MsDos(Reg);   { Get the first MCB segment } {}
     MCB := Ptr( MemW[Reg.ES:(Reg.BX-2)], 0);
      Lst := MCB^.Owner;  { Skip initial DOS allocation }
      t := Ptr(PrefixSeg,$100);
      REPEAT
(*--
         If mcb^.Owner = Lst Then Begin
            { Skip blocks belonging to previously checked owner }
            mcb := Ptr(Succ(Seg(mcb^) + mcb^.Length),0);
         End Else
--*) (*
   If mcb^.Id = MidMcb Then Begin
            Lst := mcb^.Owner;
            s := Ptr(Lst,$100);
            If s^ = t^ Then Exit;
            mcb := Ptr(Succ(Seg(mcb^) + mcb^.Length), 0);
         End;
      UNTIL (mcb^.Owner = PrefixSeg);
      PreviousCopy := FALSE;
END;   *)


FUNCTION StripAny (const SubString: String; MainString: String): String;
{ =================================================================== }
VAR i,j: Integer;
      s: char;

BEGIN{Strip}
    j := Ord(SubString[0]);
    While j > 0 Do Begin
       s := SubString[j];
       i := Pos(s,MainString);
       While i <> 0 Do Begin
           Delete(MainString,i,1);
           i := Pos(s,MainString);
       End;
       Dec(j);
   End;
   result:= MainString;
END{Strip};


FUNCTION Center(const S: String; Width: Integer): String;
{ =================================================================== }
VAR Temp: String;
BEGIN
    If Ord(s[0]) < Width Then Begin
       Temp := Spaces(Width);
       //Move(s[1], Temp[(Width-Ord(s[0])+1) div 2], Ord(s[0]));
       result:= Temp;
    End Else
       result:= Copy(s, 1, Width);
END;


FUNCTION isNumber(const s: String): Boolean;
{ =================================================================== }
{ Returns TRUE if string is a valid number                            }
{ ------------------------------------------------------------------- }
VAR x: Real;
    i: Integer;
BEGIN
    //Val(s, x, i);
    //IsNumber := (i = 0);
END;

(*
FUNCTION Atrim{ (const s: String): String };
{ =================================================================== }
{ Trims non-alphanumeric characters from the a string                 }
{ ------------------------------------------------------------------- }
VAR i, j: Integer;
    t: String;
BEGIN
     j := 0;
     For i := 1 to Ord(s[0]) Do
        If (s[i] in AlphaN) Then Begin
           Inc(j);
           t[j] := s[i];
        End;
     t[0] := Char(j);
     Atrim := t;
END;

Function Htrim{ (C: Char; s: String): String };
{ ------------------------------------------------------------------- }
VAR i: Integer;
Begin
    i := 1;
    If c <> #0 Then
       While (s[0] > #0) and (s[i] = C) Do
          Inc(i);

    Htrim := Copy(s, 1, 255);
End;

Function Ttrim{ (C: Char; s: String): String };
{ ------------------------------------------------------------------- }
Begin
    If c <> #0 Then
       While LChar(s) = C Do
          Dec(s[0]);
    Ttrim := s;
End;


Function Etrim{ (C: Char; s: String): String };
{ ------------------------------------------------------------------- }
Begin
    If c <> #0 Then
       While LChar(s) = C Do
          Dec(s[0]);
       While (s[0] > #0) and (s[1] = C) Do
          SYSTEM.Delete(s, 1, 1);
    Etrim := s;
End;

Function RwTag{ (FieldNo: Integer): String };
{ ------------------------------------------------------------------- }
Begin
    If FieldNo = 0 Then
       RwTag := ''
    Else RwTag := '<' + Zfill(Ascii(FieldNo, 3)) + '>';
End;

VAR Timer: ^Integer;
FUNCTION Twiddle{ : Boolean };
{ ------------------------------------------------------------------- }
CONST s: Array[0..3] of Char = '|/Ä\';
    Tic: Integer = 0;
    i: Integer = 0;
BEGIN
    If Abs(Tic - Timer^) > 2 Then Begin
       i := (i+1) and 3;
       Write(s[i],#8);
       Tic := Timer^;
       Twiddle := TRUE;
    End Else Twiddle := FALSE;
END; *)

begin

 writeln(Comma('1343456677.865.567.7'))

end.
