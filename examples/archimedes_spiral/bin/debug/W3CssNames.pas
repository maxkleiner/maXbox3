{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3CssNames;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Lists;

type
  EW3CSSClassStyleNames = class(EW3Exception);

  TW3CSSClassStyleNames = class(TW3OwnedObject)
  private
    FCache: TStrArray;
    FCheck: Integer;
    FToken: String;
    function getCount: Integer;
    function getItem(index: Integer): String;
    procedure setItem(index: Integer; aValue: String);
    procedure ParseToCache(aValue: String);
    procedure CacheToTag;
    procedure UpdateCache;
  protected
    function AcceptParent(aObject$4: TObjectTObject): Boolean; override;
  public
    property Count: Integer read getCount;
    property Items[index: Integer]: String read getItem write setItem;
    function Add(aCSSClassName: String): Integer;
    function Remove(index: Integer): String;
    function RemoveByName(aCSSClassName: String): String;
    function IndexOf(aCSSClassName: String): Integer;
    function toString: String;
    procedure Clear;
    constructor Create$7(AOwner$4: TObjectTObject); override;
    destructor Destroy; override;
  end;



implementation

uses
  W3Components;



{ **************************************************************************** }
{ TW3CSSClassStyleNames                                                        }
{ **************************************************************************** }

constructor TW3CSSClassStyleNames.Create$7(AOwner$4:TObjectTObject);
begin
  inherited Create$7(AOwner$4);
  FToken := 'class';
  FCache := new String[0];
end;

destructor TW3CSSClassStyleNames.Destroy;
begin
  FCache.setlength(0);
  inherited;
end;

function TW3CSSClassStyleNames.AcceptParent(aObject$4:TObjectTObject): Boolean;
begin
  Result := Assigned(aObject$4) and (aObject$4 is TW3CustomControl);
end;

procedure TW3CSSClassStyleNames.Clear;
var
  mRef: THandle;
begin
  FCache.setLength(0);
  FCheck := -1;
  if Assigned(Owner$1) then
  begin
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
      mRef.setAttribute(FToken,'')
    else
      raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},  ClassName,
        'invalid owner handle error']);
  end else
    raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},
      ClassName, CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

procedure TW3CSSClassStyleNames.ParseToCache(aValue: String);
var
  xpos:   Integer;
  mTemp:  String;
begin
  (* trim the value *)
  aValue := Trim$_String_(aValue);

  (* make a "dirty" checksum *)
  FCheck := Length(aValue);

  (* any difference from the previous cache? *)
  if FCheck>0 then
  begin
    (* flush local cache *)
    FCache.setLength(0);

    (* Ok, break it down *)
    xpos := Pos(' ',aValue);
    if xpos>0 then
    begin
      while xpos>0 do
      begin
        mTemp := Copy(aValue,1,xpos-1);
        FCache.add(mTemp);

        Delete(aValue,1,xpos);

        xpos := Pos(' ',aValue);
      end;
      if Length(aValue)>0 then
        FCache.add(aValue);
    end else if Length(aValue)>0 then
      FCache.add(aValue);
  end;
end;

procedure TW3CSSClassStyleNames.CacheToTag;
var
  mText:  String;
  mRef:   THandle;
  x:      Integer;
begin
  if Assigned(Owner$1) then
  begin
    (* build up string *)
    for x := 0 to FCache.length-1 do
    begin
      if x<(FCache.Length-1) then
      mText := mText + FCache[x] + ' ' else
      mText := mText + FCache[x];
    end;

    (* insert into tag *)
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
    //if varIsValidRef(mRef) then
    mRef.setAttribute(FToken,mText) else
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

function TW3CSSClassStyleNames.toString: String;
var
  mText:  String;
  x:  Integer;
begin
  if Assigned(Owner$1) then
  begin
    (* update internal cache *)
    UpdateCache;

    (* build up string *)
    for x := 0 to FCache.length-1 do
    begin
      if x<(FCache.Length-1) then
      mText := mText + FCache[x] + ' ' else
      mText := mText + FCache[x];
    end;
    Result := mText;
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

procedure TW3CSSClassStyleNames.UpdateCache;
var
  mRef:   THandle;
  mText:  String;
begin
  if Assigned(Owner$1) then
  begin
    (* get classname string *)
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
    begin
      mText := TVariant.AsString(mRef.getAttribute(FToken));
      if Length(mText)<>FCheck then
        ParseToCache(mText);
    end else
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

function TW3CSSClassStyleNames.IndexOf(aCSSClassName: String): Integer;
var
  x:  Integer;
begin
  Result := -1;
  if Assigned(Owner$1) then
  begin
    aCSSClassName := LowerCase(Trim$_String_(aCSSClassName));
    if Length(aCSSClassName)>0 then
    begin
      for x := 0 to FCache.length-1 do
      begin
        if LowerCase(FCache[x])=aCSSClassName then
        begin
          Result := x;
          break;
        end;
      end;
    end;
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

function TW3CSSClassStyleNames.getCount: Integer;
begin
  (* Update the local cache *)
  UpdateCache;

  (* return length of cache *)
  Result := FCache.length;
end;

function TW3CSSClassStyleNames.getItem(index: Integer): String;
begin
  (* Update the local cache *)
  UpdateCache;

  (* return cache item *)
  Result := FCache[index];
end;

procedure TW3CSSClassStyleNames.setItem(index: Integer;aValue: String);
begin
  (* Update the local cache *)
  UpdateCache;

  (* Alter value *)
  FCache[index] := aValue;

  (* push cache back to tag *)
  CacheToTag;
end;

function TW3CSSClassStyleNames.Add(aCSSClassName: String): Integer;
var
  mRef: THandle;
begin
  if Assigned(Owner$1) then
  begin
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
    //if varIsValidRef(mRef) then
    begin
      w3_AddClass(mRef,aCSSClassName);
      FCache.add(aCSSClassName);
      Result := FCache.Length-1;
    end else
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

function TW3CSSClassStyleNames.Remove(index: Integer): String;
var
  mRef: THandle;
begin
  if Assigned(Owner$1) then
  begin
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
    //if varIsValidRef(mRef) then
    begin
      w3_RemoveClass(mRef,FCache[index]);
      Result := FCache[index];
      FCache.delete(index,1);
    end else
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

function TW3CSSClassStyleNames.RemoveByName(aCSSClassName: String): String;
var
  mRef:   THandle;
  mIndex: Integer;
begin
  if Assigned(Owner$1) then
  begin
    mRef := TW3TagObj(Owner$1).Handle;
    if (mRef) then
    //if varIsValidRef(mRef) then
    begin
      w3_RemoveClass(mRef,aCSSClassName);
      mIndex := IndexOf(aCSSClassName);
      if mIndex>=0 then
      FCache.Delete(mIndex,1);
      Result := aCSSClassName;
    end;
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
  end else
  raise EW3CSSClassStyleNames.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,CNT_ERR_TAGREF_OWNER_ISNIL]);
end;

end.

