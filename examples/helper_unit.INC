unit Helper;    //for use in mX3

interface

//uses SysUtils, Math;

type
  TArByte = Array[0..255] of Byte;
  TArByteInt = Array[0..255] of Integer;
  TCharBuffer = Array[1..4096] of Char;

  function SortInt(Ar: TArByteInt; Count: Byte): TArByteInt;
  function AddSortInt(const Value: Integer; var Ar: TArByteInt; const Count: Byte): Integer;
  function BinToChar(var St: String): Char;
  function GFileSize(FName: String): Integer;
  function CharToBin(C: Char): String;
  function ByteToBin(C: Byte): String;
  function IntToSize(A: Integer): String;
  function CheckDir(NewDir: String): Integer;
  function CopyFromBuf(Count: Integer; const Buf: String; var Posit: Integer; const ToSymb: Char): String;
  function FromBuf(const Buf: String; var Posit: Integer; const ToSymb: Char): String;
  function FromBufCount(const Buf: String; var Posit: Integer; const Count: Integer): String;
  function ReplaceSymbs(Text, Find, Ins: String): String;
  function CopyCount(C: Char; Count: Integer): String;
  function CoddingInt(K: Integer): String;
  function UnCoddingInt(S: String): Integer;

const
  //My program
  PermitName='arc';
  Permit='.'+PermitName;  //From "Archive" word
  PermitTemp='.ar_';  
  //Archivate results
  ArchResultText: Array[-1..2]of String=('InOutFile','InProgramming','Archivated','Copied');
  ar_inout = -01; //Bad InOutFile result
  ar_noend = 00; //Function break without work (very bad programming result)
  ar_arch = 01; //File was archived
  ar_copy = 02; //File was copyed cause <archive file size> bigger than <real file size>
  un_inout = -01;
  un_noend = 00;
  un_unpack = 01;

implementation

uses UMain;

function SortInt(Ar: TArByteInt; Count: Byte): TArByteInt;
var
  I, J, K: Integer;
label Sort;
begin
  K:=1;
  Sort:
  For I:=K to Count do
    For J:=0 to I-1 do
      If(Ar[I]>Ar[J])then
        begin
          K:=Ar[I];  Ar[I]:=Ar[J];  Ar[J]:=K;
          K:=I;
          goto Sort;
        end;
  Result:=Ar;
end;

function AddSortInt(const Value: Integer; var Ar: TArByteInt; const Count: Byte): Integer;
// Add value in array and return his index in sorted
//Example AddSortInt(3, [4,3,2,1,...], 4)=2
// 4  > Value=3 > 4
// 3              3
// 2              3  > Return Index 2
// 1              2
//                1
var
  I, K: Integer;
begin
  K:=-1;  //Bad result (unreal)
  For I:=0 to Count-1 do
    if Ar[I]<Value then begin K:=I; Break;end;
  if K=-1 then begin K:=Count;Ar[Count]:=Value;end else
    For I:=Count downto K+1 do Ar[I]:=Ar[I-1];
  Ar[K]:=Value;
  Result:=K;
end;

function BinToChar(var St: String): Char;
const
  Ste: Array[1..8]of Integer=(128, 64, 32, 16, 8, 4, 2, 1);
var
  S: String;
  C, I: Byte;
begin
  S:=Copy(St,1,8);Delete(St,1,8);
  C:=0;
  For I:=1 to 8 do
    C:=C+Ste[I]*StrToInt(S[I]);
  Result:=Chr(C);
end;

function CharToBin(C: Char): String;
var
  S: String;
  D: Byte;
begin
  D:=Ord(C);
  S:='';
  while D>1 do
    begin
      S:=IntToStr(D mod 2)+S;
      D:=D div 2;
    end;
  S:=IntToStr(D)+S;
  while(Length(S)<8)do S:='0'+S;
  Result:=S;
end;

function ByteToBin(C: Byte): String;
var
  S: String;
begin
  S:='';
  while C>1 do
    begin
      S:=IntToStr(C mod 2)+S;
      C:=C div 2;
    end;
  S:=IntToStr(C)+S;
  while(Length(S)<8)do S:='0'+S;
  Result:=S;
end;

function GFileSize(FName: String): Integer;
var
  F: File of Char;
begin
  AssignFile(F, FName);
  {$I-}Reset(F);if IoResult<>0 then Result:=-1 else
    begin Result:=FileSize(F);CloseFile(F);end;
end;

function IntToSize(A: Integer): String;
const
  FS: Array[1..5]of String=(' b',' Kb',' Mb',' Gb',' Tb');
var
  S: String;
  I: Integer;
begin
  For I:=Low(FS)to High(FS)do
    if Power(1024,I)>A then
      begin
        S:=FloatToStr(round(A/Power(1024,I-1)*100)/100)+FS[I];
        Break;
      end;
  Result:=S;
end;

// ???????? ???????????? ???????? ----------------------------------------------
// ???? ??????? ??????????, ?????????? 1,
// ???? ??????? ?? ??????????, ?? ??????? ? ?????????? 0,
// ???? ??????? ?? ???????, ?????????? ?????? -1
function CheckDir(NewDir: String): Integer;
var
  S,D: String;
  K: Integer;
begin
  if DirectoryExists(NewDir) then Result:=1 else
    try
      S:=NewDir;
      D:='';
      K:=Pos('\',S);
      while K>0 do
        begin
          D:=D+Copy(S,1,K);
          Delete(S,1,K);
          K:=Pos('\',S);
          if DirectoryExists(D)=false then MkDir(D);
        end;
      Result:=0;
    except
      //AddAlert('Create folder','Can''t create folder "'+NewDir+'"',alError);
      Result:=-1;
    end;
end;

// ???????? ?? TChatBuffer ? String --------------------------------------------
function CopyFromBuf(Count: Integer; const Buf: String; var Posit: Integer; const ToSymb: Char): String;
var
  S: String;
begin
  S:='';
  Inc(Posit);

  while(Buf[Posit]<>ToSymb)and(Count<>0)do
    begin
      S:=S+Buf[Posit];
      Inc(Posit);
      Dec(Count);
    end;
  Result:=S;
end;

function FromBuf(const Buf: String; var Posit: Integer; const ToSymb: Char): String;
begin
  Result:=CopyFromBuf(-1, Buf, Posit, ToSymb);
end;

function FromBufCount(const Buf: String; var Posit: Integer; const Count: Integer): String;
begin
  Result:=CopyFromBuf(Count, Buf, Posit, #0);
end;

// ???????? ??? ????????? Find ? ?????? Text ?? ????????? Ins ------------------
function ReplaceSymbs(Text, Find, Ins: String): String;
var
  K: Integer;
begin
  K:=Pos(Find,Text);
  while K>0 do
    begin
      Delete(Text,K,Length(Find));
      Insert(Ins,Text,K);
      K:=Pos(Find,Text);
    end;
  Result:=Text;
end;

// ?????????? ????? ???????? C ?????? Count ------------------------------------
function CopyCount(C: Char; Count: Integer): String;
var
  I: Integer;
  S: String;
begin
  S:='';
  For I:=1 to Count do S:=S+C;
  Result:=S;
end;

function CoddingInt(K: Integer): String;
var
  S: String;
  Z: Integer;
begin
  S:='';
  while K>255 do
    begin
      Z:=K div 256; if Z>255 then Z:=255;
      S:=Chr(Z)+S;
      K:=K-Z*256;
    end;
  S:=Chr(K)+S;
  Result:=S;
end;

function UnCoddingInt(S: String): Integer;
var
  I, K, Z: Integer;
begin
  Result:=-1; if(S='')then Exit;
  K:=0;
  K:=Ord(S[1]); Delete(S,1,1);
  For I:=1 to Length(S)do
    begin
      if(Ord(S[I])=0)and(I>1)then Z:=256 else Z:=Ord(S[I]);
      K:=K+256*Z;
    end;
  Result:=K;
end;

end.


----code_cleared_checked----