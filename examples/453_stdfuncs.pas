(*
 * StdFuncs -
 *   A file chock full of functions that should exist in Delphi, but
 *   don't, like "Max", "GetTempFile", "Soundex", etc...
 *)
program StdFuncs;

{interface
uses
  Windows, Classes, SysUtils;}

//type
  //EParserError = class(Exception);
  //TCharSet = set of Char;
  
const
  // Stupid character constants
  //CRLF = #13 + #10;
  //CR   = #13;
  //LF   = #10;
  //TAB  = #9;
  //NULL_TERMINATOR = #0;
  WHITE_SPACE = CR + LF + TAB + ' ';
  // Standard DOS filename 8 + . + 3 + #0 = 13
  EIGHT_PLUS_THREE = 13;
  // Easily convert Boolean to 'Y', 'N'
  //BoolYesNo: array[Boolean] of Char = ('N', 'Y');
  

function FindTokenStartingAt(st: String; var i: Integer;
         TokenChars: TCharSet; TokenCharsInToken: Boolean): String; forward;
function GetTempFile(FilePrefix: String): String; forward;
function Max(n1, n2: Integer): Integer; forward;
function Min(n1, n2: Integer): Integer; forward;
function Soundex(st: String): String; forward;
function StripString(st: String; CharsToStrip: String): String; forward;
function Year(d: TDateTime): Integer; forward;

var
  TempPath: PChar;
  TempPathLength: Integer;

//const
  WordChars: TCharSet; // = ['0'..'9', 'A'..'Z', 'a'..'z'];


//implementation
//uses
  //StdConsts;

function FindTokenStartingAt(st: String; var i: Integer;
  TokenChars: TCharSet; TokenCharsInToken: Boolean): String;
var
  Len, j: Integer;
begin
  if (i < 1) then i:= 1;
  j := i; Len := Length(st);
  while (j <= Len) and
        ((TokenCharsInToken and (not (st[j] in TokenChars))) or
         ((not TokenCharsInToken) and (st[j] in TokenChars))) do Inc(j);
  i := j;
  while (j <= Len) and
        (((not TokenCharsInToken) and (not (st[j] in TokenChars))) or
         (TokenCharsInToken and (st[j] in TokenChars))) do Inc(j);
  if (i > Len) then
    result:= ''
  else
    result:= Copy(st, i, j - i);
  i := j;
end;

function GetTempFile(FilePrefix: String): String;
var
  sz: PChar;
begin
  //GetMem(sz, TempPathLength + EIGHT_PLUS_THREE+ 3);
  try
    GetTempFileName(TempPath, PChar(FilePrefix),0, sz);
    result:= String(sz);
  finally
    //FreeMem(sz,length(sz));
  end;
end;

function Max(n1, n2: Integer): Integer;
begin
  if (n1 > n2) then
    result:= n1
  else
    result:= n2;
end;

function Min(n1, n2: Integer): Integer;
begin
  if (n1 < n2) then
    result:= n1
  else
    result:= n2;
end;

function Soundex(st: String): String;
var
  code: Char;
  i, j, len: Integer;
begin
  result:= ' 0000';
  if (st = '') then exit;
  result[1]:= UpCase(st[1]);
  j:= 2;                   
  i:= 2;
  len := Length(st);
  while (i <= len) and (j < 6) do begin
    case st[i] of
      'B', 'F', 'P', 'V', 'b', 'f', 'p', 'v' : code := '1';
      'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z',
      'c', 'g', 'j', 'k', 'q', 's', 'x', 'z' : code := '2';
      'D', 'T', 'd', 't' :                     code := '3';
      'L', 'l' :                               code := '4';
      'M', 'N', 'm', 'n' :                     code := '5';
      'R', 'r' :                               code := '6';
    else
      code := '0';
    end; {case}
    if (code <> '0') and (code <> result[j - 1]) then begin
      result[j]:= code;
      inc(j);
    end;
    inc(i);
  end;
end;

function StripString(st: String; CharsToStrip: String): String;
var
  i: Integer;
begin
  result := '';
  for i:= 1 to Length(st) do begin
    if Pos(st[i], CharsToStrip) = 0 then
      result:= result + st[i];
  end;
end;

function Year(d: TDateTime): Integer;
var
  y, m, day: Word;
begin
  DecodeDate(d, y, m, day);
  result := y;
end;

function FindNthWord(sz: PChar; var i: Integer): PChar;
var
  j, Len: Integer;
  str, res: String;
begin
  str := String(sz);
  res := '';
  Len := Length(str);
  j := 1;
  while (j <= Len) and
        (i > 0) do begin
    res := FindTokenStartingAt(String(sz), i, WordChars, True);
    Dec(i);
  end;
  //result := MakeResultString(PChar(res), nil, 0);
end;

function FindWord(sz: PChar; var i: Integer): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('FindWord() - Enter');
  {$endif}
  Inc(i);
  //result:= MakeResultString(
    //PChar(FindTokenStartingAt(String(sz), i, WordChars, True)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('FindWord() - Exit');
  {$endif}
end;

function FindWordIndex(sz: string; var i: Integer): Integer;
var
  Len, j: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('FindWordIndex() - Enter');
  {$endif}
  j := i; Len := StrLen(sz);
  while (j < Len) and
        (not (sz[j] in WordChars)) do Inc(j);
  if (j = Len) then
    result := -1
  else
    result := j;
  {$ifdef FULDebug}
  WriteDebug('FindWordIndex() - Exit');
  {$endif}
end;


(*function AgeInDays(ib_date, ib_date_reference: PISC_QUAD): integer; cdecl; export;
var
  tm_date, tm_date_reference: tm;
  d_date, d_date_reference: TDateTime;
begin
  {$ifdef FULDebug}
  WriteDebug('AgeInDays() - Enter');
  {$endif}
  isc_decode_date(ib_date, @tm_date);
  isc_decode_date(ib_date_reference, @tm_date_reference);
  d_date := EncodeDate(tm_date.tm_year + cYearOffset,
                       tm_date.tm_mon + 1,
                       tm_date.tm_mday);
  d_date_reference := EncodeDate(tm_date_reference.tm_year + cYearOffset,
                                 tm_date_reference.tm_mon + 1,
                                 tm_date_reference.tm_mday);
  result := Trunc(d_date_reference - d_date);
  {$ifdef FULDebug}
  WriteDebug('AgeInDays() - Exit');
  {$endif}
end;*)


function LineWrap(sz: string; var Start, ColWidth: Integer): PChar;
var
  i, j, len: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('LineWrap() - Enter');
  {$endif}
  (*
   * 1. Get the length of the string.
   * 2. If "The rest" of the string is smaller than ColWidth, just return
   *    it.
   * 3. Otherwise, let 'j' be the end of the column, and decrement j to
   *    a word boundary.
   *    a. Find a word boundary.
   *    b. If j = i (meaning the word is too long), then the word has
   *       has to be chopped.
   *)
  len := StrLen(sz);                                                // (1)
  i := Start;
  if (len - i) <= ColWidth then                                     // (2)
    j := len - i
  else begin                                                        // (3)
    j := ColWidth + i - 1;
    while (j > i) and not (sz[j] in [' ', #9, #10, #13]) do Dec(j); // (a)
    if (j = i) then
      j := ColWidth                                                 // (b)
    else
      j := j - i + 1;
  end;
  //result := MakeResultString(PChar(Copy(String(sz), i + 1, j)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('LineWrap() - Exit');
  {$endif}
end;




begin
//initialization
    //TSymbol

  {TempPathLength:= GetTempPath(0, NIL)+1;
  GetMem(TempPath, TempPathLength);
  GetTempPath(TempPathLength, TempPath);}

//finalization

  //FreeMem(TempPath, TempPathLength);

end.