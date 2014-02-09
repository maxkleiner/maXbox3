{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Lists;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System;

type
  TListAddedEvent   TListAddedEventder: TObjectTObject);
  TListDeletedEvent TListDeletedEventr: TObjectTObject);
  TListClearEvent   TListClearEventder: TObjectTObject);

  { TStringList }
  TStringList = class(TObject)
  private
    FData: TStrArray;
    FOnAdded: TListAddedEvent;
    FOnDeleted: TListDeletedEvent;
    FOnClear: TListClearEvent;
    function GetCount: Integer;
    function GetItem(index: Integer): String;
    procedure SetItem(index: Integer; Value: String);
    function GetText: String;
    procedure SetText(value: String);
  public
    property Items[index: Integer]: String read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    property Text: String read GetText write SetText;
    function Add(value: String): Integer;
    procedure Remove(index: Integer);
    function IndexOf(Value: String): Integer;
    procedure Insert(Index: Integer; Value: String);
    procedure Clear;
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property OnListCleared: TListClearEvent read FOnClear write FOnClear;
    property OnItemAdded: TListAddedEvent read FOnAdded write FOnAdded;
    property OnItemDeleted: TListDeletedEvent read FOnDeleted write FOnDeleted;
  end;

  { TObjectList }
  TObjectList = class(TObject)
  private
    FData: TObjArray;
    FOnAdded: TListAddedEvent;
    FOnDeleted: TListDeletedEvent;
    FOnClear: TListClearEvent;
    function GetItem(index$1: Integer): TObject;
    procedure SetItem(index$2: Integer; value$3: TObjectTObject);
    function GetCount: Integer;
  public
    property Items[index: Integer]: TObject read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    function Add(Value$5: TObjectTObject): Integer;
    procedure Remove(ondex: Integer);
    function IndexOf(Value$6: TObjectTObject): Integer;
    procedure Insert$1(Index: Integer; Value$7: TObjectTObject);
    procedure Clear;
    procedure Swap$1(aFirst, aSecond: Integer);
    constructor Create$17; virtual;
    destructor Destroy; override;
  published
    property OnListCleared: TListClearEvent read FOnClear write FOnClear;
    property OnItemAdded: TListAddedEvent read FOnAdded write FOnAdded;
    property OnItemDeleted: TListDeletedEvent read FOnDeleted write FOnDeleted;
  end;



implementation



{ **************************************************************************** }
{ TObjectList                                                                 }
{ **************************************************************************** }

constructor TObjectList.Create$17;
begin
  inherited Create;
end;

destructor TObjectList.Destroy;
begin
  FData.Clear;
  inherited Destroy;
end;

procedure TObjectList.Remove(ondex: Integer);
begin
  FData.delete(ondex);
  if Assigned(FOnDeleted) then
     FOnDeleted(Self);
end;

function TObjectList.IndexOf(Value$6:TObjectTObject): Integer;
begin
  Result := FData.IndexOf(Value$6);
end;

procedure TObjectList.Swap$1(aFirst,aSecond: Integer);
begin
  FData.Swap(aFirst, aSecond);
end;

procedure TObjectList.Clear;
begin
  FData.Clear;
  if Assigned(FOnClear) then
    FOnClear(Self);
end;

function TObjectList.GetCount: Integer;
begin
  Result := FData.length;
end;

function TObjectList.GetItem(index$1: Integer):TObject;
begin
  Result := FData[index$1];
end;

procedure TObjectList.SetItem(index$2: Integer;value$3:TObjectTObject);
begin
  FData[index$2] := value$3;
end;

function TObjectList.Add(Value$5:TObjectTObject): Integer;
begin
  Result := FData.length;
  FData.add(Value$5);
  if Assigned(FOnAdded) then
    FOnAdded(Self);
end;

procedure TObjectList.Insert$1(Index: Integer; Value$7: TObjectTObject);
begin
  FData.Insert(Index, Value$7);
end;

{ **************************************************************************** }
{ TStringList                                                                  }
{ **************************************************************************** }

constructor TStringlist.Create;
begin
  inherited Create;
end;

destructor TStringList.Destroy;
begin
  FData.Clear;
  inherited Destroy;
end;

procedure TStringList.Remove(index: Integer);
begin
  FData.delete(index);
  if Assigned(FOnDeleted) then
  FOnDeleted(Self);
end;

function TStringList.IndexOf(Value: String): Integer;
begin
  Result := FData.IndexOf(Value);
end;

procedure TStringList.SetText(value: String);
var
  xpos: Integer;
  mTemp: String;
begin
  FData.Clear;
  xpos := Pos(#13,value);
  if xpos>0 then
  begin
    repeat
      xpos := Pos(#13,value);
      if xpos>0 then
      begin
        mTemp := Copy(value,1,xpos-1);
        Delete(value,1,xpos);
        if Length(value)>0 then
        begin
          if value[1]=#10 then
            Delete(value,1,1);
        end;
        FData.add(mTemp);
      end;
    until xpos<1;

    if Length(value)>0 then
      FData.Add(value);

  end else
  FData.add(value);
end;

function TStringList.GetText: String;
begin
  Result := StrJoin(FData, #13)+#13;
end;

procedure TStringList.Clear;
begin
  FData.Clear;
  if Assigned(FOnClear) then
  FOnClear(Self);
end;

function TStringList.GetCount: Integer;
begin
  Result := FData.length;
end;

function TStringList.GetItem(index: Integer): String;
begin
  Result := FData[index];
end;

procedure TStringList.SetItem(index: Integer;Value: String);
begin
  FData[index] := Value;
end;

function TStringList.Add(value: String): Integer;
begin
  Result := FData.length;
  FData.Add(value);
  if Assigned(FOnAdded) then
    FOnAdded(Self);
end;

procedure TStringList.Insert(Index: Integer; Value: String);
begin
  FData.Insert(Index, Value);
end;

end.
