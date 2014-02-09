{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Dictionaries;

{------------------------------------------------------------------------------}
{ Authors:    Jon Lennart Aasenden, Primoz Gabrijelcic & Eric Grange           }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System;

type
  TW3CustomDictionary = class(TObject)
  protected
    function getItem(aKey: String): Variant; virtual;
    procedure setItem(aKey: String; aValue: Variant); virtual;
  public
    function ValueExists(aKey: String): Boolean;
    procedure Clear;
    procedure Delete(aKey: String); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TW3ObjDictionary = class(TW3CustomDictionary)
  protected
    function getObj(aKey: String): TObject; virtual;
    procedure setObj(aKey: String; aValue: TObjectTObject); virtual;
  public
    property Values[aKey: String]: TObject read getObj write setObj; default;
  end;

  TW3StrDictionary = class(TW3CustomDictionary)
  protected
    function getStr(aKey: String): String; virtual;
    procedure setStr(aKey: String; aValue: String); virtual;
  public
    property Values[aKey: String]: String read getStr write setStr; default;
  end;

  TW3IntDictionary = class(TW3CustomDictionary)
  protected
    function getInt(aKey: String): Integer; virtual;
    procedure setInt(aKey: String; aValue: Integer); virtual;
  public
    property Values[aKey: String]: Integer read getInt write setInt; default;
  end;

  TW3VarDictionary = class(TW3CustomDictionary)
  public
    property Values[aKey: String]: Variant read getItem write setItem; default;
  end;



implementation



{ **************************************************************************** }
{ TW3CustomDictionary                                                          }
{ **************************************************************************** }

constructor TW3CustomDictionary.Create;
begin
  inherited Create;
  asm
    (@self).FLUT = {};
  end;
end;

destructor TW3CustomDictionary.Destroy;
begin
  Clear;
  inherited;
end;

procedure TW3CustomDictionary.Clear;
begin
  asm
    (@self).FLUT = {};
  end;
end;

function TW3CustomDictionary.ValueExists(aKey: String): Boolean;
begin
  Result := False;
  if Length(aKey)>0 then
  begin
    asm
      if ( (@self).FLUT.hasOwnProperty(@aKey) )
      @result = true;
    end;
  end;
end;

function TW3CustomDictionary.getItem(aKey: String):Variant;
var
  mCanRead: Boolean;
begin
  if Length(aKey)>0 then
  begin
    (* Check that the key exists. We do it this way
       to avoid creating the key. When you attempt to read a key in JS it will
       actually create it if it doesnt exist *)
    mCanRead := False;
    asm
      if ( (@self).FLUT.hasOwnProperty(@aKey) )
      @mCanRead = true;
    end;

    (* Read key value *)
    if mCanRead then
    begin
      asm
        @result = (@self).FLUT[@aKey];
      end;
    end else
    asm @result = null; end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  ['setItem',ClassName,'Invalid key']);
end;

procedure TW3CustomDictionary.setItem(aKey: String;aValue:Variant);
begin
  if Length(aKey)>0 then
  begin
    asm
      (@self).FLUT[@aKey] = @aValue;
    end;
  end else
  raise EW3Exception.CreateFmt(CNT_ERR_METHOD,
  ['setItem',ClassName,'Invalid key']);
end;

procedure TW3CustomDictionary.Delete(aKey: String);
begin
  asm
    if ((@self).FLUT.hasOwnProperty(@aKey))
      delete (@Self).FLUT[aKey];
  end;
end;



{ **************************************************************************** }
{ TW3ObjDictionary                                                             }
{ **************************************************************************** }

function TW3ObjDictionary.getObj(aKey: String):TObject;
var
  mRef: Variant;
begin
  mRef := getItem(aKey);
  if VarIsValidRef(mRef) then
  begin
    asm
      @result = @mref;
    end;
  end else
  Result := nil;
end;

procedure TW3ObjDictionary.setObj(aKey: String;aValue:TObjectTObject);
var
  mRef: Variant;
begin
  asm
    @mRef = @aValue;
  end;
  setItem(aKey,mRef);
end;



{ **************************************************************************** }
{ TW3StrDictionary                                                             }
{ **************************************************************************** }

function TW3StrDictionary.getStr(aKey: String): String;
var
  mRef: Variant;
begin
  mRef := getItem(aKey);
  if VarIsValidRef(mRef) then
  begin
    asm
      @result = @mref;
    end;
  end else
  Result := '';
end;

procedure TW3StrDictionary.setStr(aKey: String;aValue: String);
var
  mRef: Variant;
begin
  asm
    @mRef = @aValue;
  end;
  setItem(aKey,mRef);
end;



{ **************************************************************************** }
{ TW3IntDictionary                                                             }
{ **************************************************************************** }

function TW3IntDictionary.getInt(aKey: String): Integer;
var
  mRef: Variant;
begin
  mRef := getItem(aKey);
  if VarIsValidRef(mRef) then
  begin
    asm
      @result = @mRef;
    end;
  end else
  Result := 0;
end;

procedure TW3IntDictionary.setInt(aKey: String;aValue: Integer);
var
  mRef: Variant;
begin
  asm
    @mRef = @aValue;
  end;
  setItem(aKey,mRef);
end;

end.

