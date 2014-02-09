{   Much of this code has been copied from
      Oleg Kukarthev,
        extracted from his ib_pass.zip distribution located at
          http://www.demon.co.uk/dtuk/dtinterbaselinks.html
      It is used with his express permission.
      A copy of his copyright statement is at the
      bottom of this file. }
{********************************************************}
{       DES for Delphi 16 & 32,                          }
{       InterBase User password encoder                  }
{       Copyright (c) 1996,1997 Oleg Kukarthev           }
{                                                        }
{       Written by:                                      }
{         Oleg Kukarthev                                 }
{       E-mail: Please look at InterBase List Server     }
{               interbase@esunix1.emporia.edu            }
{                                                        }
{       InterBase User password encoder                  }
{         rewritten from Gérard Perreault C code         }
{                                                        }
{********************************************************}
unit Encrypt;

interface

uses SysUtils;

function IBPassword(pInStr: PChar): PChar; cdecl; export;

implementation

uses
  udf_glob;

const
  IP: array [0..63] of Byte =
  (57, 49, 41, 33, 25, 17,  9,  1, 59, 51, 43, 35, 27, 19, 11,  3,
   61, 53, 45, 37, 29, 21, 13,  5, 63, 55, 47, 39, 31, 23, 15,  7,
   56, 48, 40, 32, 24, 16,  8,  0, 58, 50, 42, 34, 26, 18, 10,  2,
   60, 52, 44, 36, 28, 20, 12,  4, 62, 54, 46, 38, 30, 22, 14,  6);

  InvIP: array [0..63] of Byte =
  (39,  7, 47, 15, 55, 23, 63, 31, 38,  6, 46, 14, 54, 22, 62, 30,
   37,  5, 45, 13, 53, 21, 61, 29, 36,  4, 44, 12, 52, 20, 60, 28,
   35,  3, 43, 11, 51, 19, 59, 27, 34,  2, 42, 10, 50, 18, 58, 26,
   33,  1, 41,  9, 49, 17, 57, 25, 32,  0, 40,  8, 48, 16, 56, 24);

  Swap: array [0..63] of Byte =
  (32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
   48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
   16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31);

  PC_1: array [0..55] of Byte =
  (56, 48, 40, 32, 24, 16,  8,  0, 57, 49, 41, 33, 25, 17,
    9,  1, 58, 50, 42, 34, 26, 18, 10,  2, 59, 51, 43, 35,
   62, 54, 46, 38, 30, 22, 14,  6, 61, 53, 45, 37, 29, 21,
   13,  5, 60, 52, 44, 36, 28, 20, 12,  4, 27, 19, 11,  3);

  PC_2 : array[0..47] of Byte =
  (13, 16, 10, 23,  0,  4,  2, 27, 14,  5, 20,  9,
   22, 18, 11,  3, 25,  7, 15,  6, 26, 19, 12,  1,
   40, 51, 30, 36, 46, 54, 29, 39, 50, 44, 32, 47,
   43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31);

  E: array [0..47] of Byte =
  (31,  0,  1,  2,  3,  4,  3,  4,  5,  6,  7,  8,
    7,  8,  9, 10, 11, 12, 11, 12, 13, 14, 15, 16,
   15, 16, 17, 18, 19, 20, 19, 20, 21, 22, 23, 24,
   23, 24, 25, 26, 27, 28, 27, 28, 29, 30, 31,  0);

  P: array [0..31] of Byte =
  (15, 6, 19, 20, 28, 11, 27, 16,  0, 14, 22, 25,  4, 17, 30,  9,
    1, 7, 23, 13, 31, 26,  2,  8, 18, 12, 29,  5, 21, 10,  3, 24);

  Boxes: array [0..7, 0..63] of Byte =
  ((14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
     0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
     4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
    15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13),
   (15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
     3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
     0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
    13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9),
   (10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
    13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
    13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
     1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12),
   ( 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
    13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
    10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
     3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14),
   ( 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
    14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
     4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
    11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3),
   (12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
    10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
     9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
     4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13),
   ( 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
    13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
     1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
     6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12),
   (13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
     1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
     7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
     2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6,  11));

  RotateArray: array[0..15] of Byte =
  (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);

procedure Transpose(var Data: array of byte; OrderData: array of Byte);
var
  TmpData: array[0..63] of Byte;
  i : Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('Transpose() - Enter');
  {$endif}
  StrMove(@TmpData, @Data, SizeOf(Data));
  for i := 0 to High(OrderData) do
    Data[i] := TmpData[OrderData[i]];
  {$ifdef FULDebug}
  WriteDebug('Transpose() - Exit');
  {$endif}
end;

{ Construct 11 bytes array from 64 bits array }
procedure IBBitsToBytes(Ptr: PChar; var Bits: array of Byte);
var
  i, j, k, b: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBBitsToBytes() - Enter');
  {$endif}
  for i := 0 to 10 do begin
    b := 0;
    for j := 0 to 5 do begin
      k := i * 6 + j;
      b := b shl 1;
      if k <= High(Bits) then
        b := b or Bits[k]
    end;

    Inc(b, Byte('.'));
    if b > Byte('9') then Inc(b, 7);
    if b > Byte('Z') then Inc(b, 6);

    Ptr[i] := Char(b);
  end;
  Ptr[11] := #0;
  {$ifdef FULDebug}
  WriteDebug('IBBitsToBytes() - Exit');
  {$endif}
end;

procedure IBBytesToBits(Ptr: PChar; var Bits: array of Byte);
var
  i, j, b: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBBytesToBits() - Enter');
  {$endif}
  FillChar(Bits, SizeOf(Bits), 0);
  for i := 0 to 7 do begin
    b := Byte(Ptr[i]);
    if b = 0 then break;

    for j := 0 to 6 do
      Bits[i * 8 + j] := b shr (6 - j) and 1;
    Bits[i * 8 + 7] := 0;
  end;
  {$ifdef FULDebug}
  WriteDebug('IBBytesToBits() - Exit');
  {$endif}
end;

{ Make key bit array from  key string }
procedure IBMakeKey(KeyPtr: PChar; var KeyBits: array of Byte);
var
  i, j, k, b, bx: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBMakeKey() - Enter');
  {$endif}
  StrMove(@KeyBits, @E, SizeOf(E));
  for i := 0 to 1 do begin
    b := Byte(KeyPtr[i]);

    if b > Byte('Z') then Dec(b, 6 + 7 + Byte('.'))
    else if b > Byte('9') then Dec(b, 7 + Byte('.'))
    else Dec(b, Byte('.'));

    for j := 0 to 5 do begin
      if b shr j and 1 > 0 then begin
        k := i * 6 + j;
        bx := KeyBits[k];
        KeyBits[k] := KeyBits[k + 24];
        KeyBits[k + 24] := bx;
      end;
    end;
  end;
  {$ifdef FULDebug}
  WriteDebug('IBMakeKey() - Exit');
  {$endif}
end;

procedure Rotate(var KeyBits: array of Byte);
var
  BitL, BitH : Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('Rotate() - Enter');
  {$endif}
  BitL := KeyBits[0]; BitH := KeyBits[28];
  StrMove(@KeyBits, @KeyBits[1], SizeOf(KeyBits) - 1);
  KeyBits[27] := BitL; KeyBits[55] := BitH;
  {$ifdef FULDebug}
  WriteDebug('Rotate() - Exit');
  {$endif}
end;

procedure IBGetBoxes(Round: Byte; var KeyBits, InBits, OutBits: array of Byte);
var
  HalfOutBits: array [0..31] of Byte;
  KeyBitsX: array [0..47] of Byte;
  i, j, b: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBGetBoxes() - Enter');
  {$endif}
  for i := 1 to Round do
    Rotate(InBits);

  for i := 0 to High(KeyBitsX) do
    KeyBitsX[i] := OutBits[KeyBits[i] + 32] xor InBits[PC_2[i]];

  for i := 0 to 7 do begin
    j := i * 6;
    j := KeyBitsX[j    ] * 32 + KeyBitsX[j + 1] * 8 + KeyBitsX[j + 2] * 4 +
         KeyBitsX[j + 3] *  2 + KeyBitsX[j + 4]     + KeyBitsX[j + 5] * 16;

    b := Boxes[i][j];

    j := i * 4;
    HalfOutBits[j    ] := b shr 3 and 1;
    HalfOutBits[j + 1] := b shr 2 and 1;
    HalfOutBits[j + 2] := b shr 1 and 1;
    HalfOutBits[j + 3] := b       and 1;
  end;

  for i := 0 to 31 do begin
    b := OutBits[i];
    OutBits[i] := OutBits[i + 32];
    OutBits[i + 32] := b xor HalfOutBits[P[i]];
  end;
  {$ifdef FULDebug}
  WriteDebug('IBGetBoxes() - Exit');
  {$endif}
end;

procedure IBEncrypt(var KeyBits, InBits, OutBits: array of Byte);
var
  i: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBEncrypt() - Enter');
  {$endif}
  Transpose(OutBits, IP);

  for i := 0 to 15 do
    IBGetBoxes(RotateArray[i], KeyBits, InBits, OutBits);

  Transpose(OutBits, Swap);
  Transpose(OutBits, InvIP);
  {$ifdef FULDebug}
  WriteDebug('IBEncrypt() - Exit');
  {$endif}
end;

procedure IBCrypt(KeyPtr, InPtr, OutPtr: PChar);
var
  InBits, OutBits: array[0..63] of Byte;
  KeyBits: array[0..47] of Byte;
  i: Byte;
begin
  {$ifdef FULDebug}
  WriteDebug('IBCrypt() - Enter');
  {$endif}
  { Make key bit array from  key string }
  IBMakeKey(KeyPtr, KeyBits);

  { Split input string to bit array }
  IBBytesToBits(InPtr, InBits);
  Transpose(InBits, PC_1);

  { Crypt input bit array to output bit array using key bit array }
  FillChar(OutBits, SizeOf(OutBits), 0);
  for i := 0 to 24 do
    IBEncrypt(KeyBits, InBits, OutBits);

  { Make output string from bit array }
  IBBitsToBytes(OutPtr, OutBits);
  {$ifdef FULDebug}
  WriteDebug('IBCrypt() - Exit');
  {$endif}
end;

function IBPassword(pInStr: PChar): PChar;
const
  Algorithm = 1; { Base64 }
  pKeyStr = '9z';
var
  pOutStr:  array[0..11] of Char;
  pResStr:  array[0..11] of Char;
begin
  {$ifdef FULDebug}
  WriteDebug('IBPassword() - Enter');
  {$endif}
  IBCrypt(PChar(pKeyStr), pInStr, pOutStr);
  IBCrypt(PChar(pKeyStr), pOutStr, pResStr);
  result := MakeResultString(pResStr, nil, 0);
  {$ifdef FULDebug}
  WriteDebug('IBPassword() - Exit');
  {$endif}
end;

end.
