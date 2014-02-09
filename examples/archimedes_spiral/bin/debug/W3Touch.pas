{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Touch;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.25 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Lists, w3c.DOM;

type
  TW3TouchData = class;
  TW3GestureData = class;

  TTouchBeginEvent TTouchBeginEventer: TObjectTObject; Info: TW3TouchDataTW3TouchData);
  TTouchMoveEvent TTouchMoveEventder: TObjectTObject; Info: TW3TouchDataTW3TouchData);
  TTouchEndEvent TTouchEndEventnder: TObjectTObject; Info: TW3TouchDataTW3TouchData);

  TGestureStartEvent TGestureStartEvent: TObjectTObject; Info: TW3GestureDataTW3GestureData);
  TGestureChangeEvent TGestureChangeEvent TObjectTObject; Info: TW3GestureDataTW3GestureData);
  TGestureEndEvent TGestureEndEventer: TObjectTObject; Info: TW3GestureDataTW3GestureData);

  { TW3Touch }
  TW3Touch = class
  private
    FScreenX: Integer;
    FScreenY: Integer;
    FClientX: Integer;
    FClientY: Integer;
    FPageX: Integer;
    FPageY: Integer;
    FTarget: TObject;
    FIdent: Variant;
  public
    property Target: TObject read FTarget write FTarget;
    property Identifier: Variant read FIdent write FIdent;
    property ScreenX: Integer read FScreenX write FScreenX;
    property ScreenY: Integer read FScreenY write FScreenY;
    property ClientX: Integer read FClientX write FClientX;
    property ClientY: Integer read FClientY write FClientY;
    property PageX: Integer read FPageX write FPageX;
    property PageY: Integer read FPageY write FPageY;
    function ToString: String; virtual;
    procedure Consume$1(touch : TouchTouch);
  end;

  { TW3TouchList }
  TW3TouchList = class
  private
    FObjects: array of TW3Touch;
  public
    property Touches[index: Integer]: TW3Touch read a$3(FObjects[index$3]); default;
    property Count: Integer read (FObjects.Count);
    procedure Consume(refObj: TouchListTouchList);
    procedure Clear$2;
  end;

  { TW3TouchData }
  TW3TouchData = class
  private
    FTouches: TW3TouchList;
    FChanged: TW3TouchList;
    function getTouches: TW3TouchList;
    function getChanged: TW3TouchList;
  public
    property Touches: TW3TouchList read getTouches;
    property ChangedTouches: TW3TouchList read getChanged;
    procedure Update;
  end;

  { TW3GestureData }
  TW3GestureData = class
  private
    FRotation: float;
    FScale: float;
  protected
    procedure Consume$2(refObj$1: THandle);
  public
    procedure Update$1;
    function ToString: String; virtual;
    property Rotation: Float read FRotation write FRotation;
    property Scale: Float read FScale write FScale;
  end;

implementation



{ **************************************************************************** }
{ TW3Touch                                                                     }
{ **************************************************************************** }

procedure TW3Touch.Consume$1(touch : TouchTouch);
begin
  FScreenX := touch.screenX;
  FScreenY := touch.screenY;
  FClientX := touch.clientX;
  FClientY := touch.clientY;
  FPageX   := touch.pageX;
  FPageY   := touch.pageY;
  FIdent   := touch.identifier;
  FTarget  := TVariant.AsObject(touch.target);
end;

function TW3Touch.ToString: String;
begin
  Result := 'ScreenX = ' + IntToStr(FScreenX) + #13
          + 'ScreenY = ' + IntToStr(FScreenY) + #13
          + 'ClientX = ' + IntToStr(FClientX) + #13
          + 'ClientY = ' + IntToStr(FClientY) + #13
          + 'PageX = '   + IntToStr(FPageX)   + #13
          + 'PageY = '   + IntToStr(FPageY)   + #13
          + 'Identifier = ' + TVariant.AsString(FIdent) + #13;
end;

{ **************************************************************************** }
{ TW3TouchList                                                                 }
{ **************************************************************************** }

procedure TW3TouchList.Clear$2;
begin
  FObjects.Clear;
end;

procedure TW3TouchList.Consume(refObj: TouchListTouchList);
var
  mCount$1: Integer;
  x$16: Integer;
  mObj$17: TW3Touch;
begin
  mCount$1 := refObj.length;

  (* Same count? Update already existing elements *)
  if mCount$1 = FObjects.Count then
  begin
    for x$16 := 0 to mCount$1-1 do
      FObjects[x$16].Consume$1(refObj[x$16]);
  end
  else
  begin
    (* count is different, we have to rebuild the stack *)
    Clear$2;
    for x$16 := 0 to mCount$1-1 do
    begin
      mObj$17 := TW3Touch.Create;
      mObj$17.Consume$1(refObj[x$16]);
      FObjects.Add(mObj$17);
    end;
  end;
end;

{ **************************************************************************** }
{ TW3TouchData                                                                 }
{ **************************************************************************** }

procedure TW3TouchData.Update;
begin
  if Assigned(FTouches) then
    FTouches.Consume(TouchEvent(w3_event).touches);

  if Assigned(FChanged) then
    FChanged.Consume(TouchEvent(w3_event).changedTouches);
end;

function TW3TouchData.getTouches: TW3TouchList;
begin
  if not Assigned(FTouches) then
  begin
    FTouches := TW3TouchList.Create;
    FTouches.Consume(TouchEvent(w3_event).touches);
  end;

  Result := FTouches;
end;

function TW3TouchData.getChanged: TW3TouchList;
begin
  if not Assigned(FChanged) then
  begin
    FChanged := TW3TouchList.Create;
    FChanged.Consume(TouchEvent(w3_event).changedTouches);
  end;

  Result := FChanged;
end;


{ **************************************************************************** }
{ TW3GestureData                                                               }
{ **************************************************************************** }

procedure TW3GestureData.Consume$2(refObj$1: THandle);
begin
  (* consume ->into local variables *)
  FRotation := refObj$1.rotation;
  FScale := refObj$1.scale;
end;

procedure TW3GestureData.Update$1;
begin
  Consume$2(w3_event);
end;

function TW3GestureData.ToString: String;
begin
  Result := Format('Rotation = %f'#13+'Scale = %f', [FRotation, FScale]);
end;

end.
