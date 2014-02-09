{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Fonts;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System;

type
  EW3FontError = class(EW3Exception);

  { TW3CustomFont }
  TW3CustomFont = class(TObject)
  private
    FOnChange: TNotifyEvent;
  protected
    function  GetHandle$1: THandle; virtual; abstract;
    function  getName: String;
    procedure setName(aNewName: String);
    function  getSize: Integer;
    procedure setSize(aNewSize: Integer);
    function  getColor$1: TColor;
    procedure setColor$2(aNewColor: TColor);
    function  getWeight: String;
    procedure setWeight(aNewWeight: String);
  public
    property Name$4: String read getName write setName;
    property Size: Integer read getSize write setSize;
    property Color$1: TColor read getColor$1 write setColor$2;
    property Weight: String read getWeight write setWeight;
    function  toCssStyle:String;virtual;
  published
    property OnChanged$1: TNotifyEvent read FOnChange write FOnChange;
  end;



implementation



{ **************************************************************************** }
{ TW3CustomFont                                                                }
{ **************************************************************************** }

function TW3CustomFont.toCssStyle:String;
Begin
  Result:=IntToStr(getSize) + 'px ' + getName;
  if Length(getName)<=0 then
    Result:=w3_getStyleAsStr(GetHandle$1,'font');
end;

function TW3CustomFont.getName: String;
var
  mHandle:  THandle;
begin
  mHandle := GetHandle$1;
  if (mHandle) then
  Result := w3_getStyleAsStr(mHandle,'fontFamily') else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

procedure TW3CustomFont.setName(aNewName: String);
var
  mHandle$1:  THandle;
begin
  mHandle$1 := GetHandle$1;
  if (mHandle$1) then
  begin
    w3_setStyle(mHandle$1,'fontFamily',aNewName);
    if Assigned(FOnChange) then
      FOnChange(Self);
  end else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

function TW3CustomFont.getSize: Integer;
var
  mRef$7:   THandle;
begin
  mRef$7 := GetHandle$1;
  if (mRef$7) then
  //if varIsValidRef(mRef) then
  Result := w3_getStyleAsInt(mRef$7,'fontSize') else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

procedure TW3CustomFont.setSize(aNewSize: Integer);
var
  mRef$10: THandle;
begin
  mRef$10 := GetHandle$1;
  if (mRef$10) then
  begin
    w3_setStyle(mRef$10,'fontSize',TInteger.toPxStr(aNewSize));
    if Assigned(FOnChange) then
      FOnChange(Self);
  end else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

function TW3CustomFont.getColor$1:TColor;
var
  mRef$6:   THandle;
  mText$2:  String;
begin
  mRef$6 := GetHandle$1;
  if (mRef$6) then
  begin
    mText$2 := w3_getStyleAsStr(mRef$6,'color');
    Result := StrToColor(mText$2);
  end else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

procedure TW3CustomFont.setColor$2(aNewColor:TColor);
var
  mRef$9: THandle;
begin
  mRef$9 := GetHandle$1;
  if (mRef$9) then
  begin
    w3_setStyle(mRef$9,'color',ColorToWebStr(aNewColor));
    if Assigned(FOnChange) then
    FOnChange(Self);
  end else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

function TW3CustomFont.getWeight: String;
var
  mRef$8: THandle;
begin
  mRef$8 := GetHandle$1;
  if (mRef$8) then
    Result := w3_getStyleAsStr(mRef$8,'fontWeight')
  else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

procedure TW3CustomFont.setWeight(aNewWeight: String);
var
  mRef$11: THandle;
begin
  mRef$11 := GetHandle$1;
  if (mRef$11) then
  begin
    w3_setStyle(mRef$11, 'fontWeight', aNewWeight);
    if Assigned(FOnChange) then
      FOnChange(Self);
  end else
  raise EW3FontError.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'Invalid tag handle error']);
end;

end.

