{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Borders;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System;

type
  TW3BorderEdge = (beLeft, beTop, beRight, beBottom);
  TW3BorderEdgeStyle = (besNone, besSolid, besDotted, besDouble, besGroove, besInset, besOutset);

  TW3Borders = class;

  TW3Border = class(TObject)
  private
    FOwner$3: TW3Borders;
    FEdge: TW3BorderEdge;
    FEdgeName: String;
    function EdgeStyleString(aValue: TW3BorderEdgeStyleTW3BorderEdgeStyle): String;
    function  getWidth$4: Integer;
    procedure setWidth(aValue$61: Integer);
    function  getPadding: Integer;
    procedure setPadding(aValue$60: Integer);
    function  getStyle: TW3BorderEdgeStyle;
    procedure setStyle(aValue: TW3BorderEdgeStyleTW3BorderEdgeStyle);
    function  getMargin: Integer;
    procedure setmargin(const aValue: Integer);
    function  getColor: TColor;
    procedure setColor(aValue: TColor);
  public
    property Edge$1: TW3BorderEdge read FEdge;
    property Margin: Integer read getMargin write setmargin;
    property Style: TW3BorderEdgeStyle read getStyle write setStyle;
    property Color: TColor read getColor write setColor;
    property Width$7: Integer read getWidth$4 write setWidth;
    property Padding: Integer read getPadding write setPadding;
    function ToString: String;
    constructor Create$36(AOwner$6: TW3BordersTW3Borders; AEdge: TW3BorderEdgeTW3BorderEdge);
  end;

  TW3Borders = class(TW3OwnedObject)
  private
    FLeft: TW3Border;
    FTop: TW3Border;
    FRight: TW3Border;
    FBottom: TW3Border;
    function getEdge(aKind: TW3BorderEdgeTW3BorderEdge): TW3Border;
  protected
    function AcceptParent(aObject$5: TObjectTObject): Boolean; override;
  public
    property Edge[aValue: TW3BorderEdge]: TW3Border read getEdge;
    property Left: TW3Border read FLeft;
    property Top: TW3Border read FTop;
    property Right: TW3Border read FRight;
    property Bottom: TW3Border read FBottom;
    function getVSpace: Integer;
    function getHSpace: Integer;
    procedure setStyle(const aValue: TW3BorderEdgeStyleTW3BorderEdgeStyle);
    function toString: String;
    constructor Create$7(AOwner$5: TObjectTObject); override;
    destructor Destroy; override;
  end;



implementation

uses
  W3Components;



{ **************************************************************************** }
{ TW3Borders                                                                   }
{ **************************************************************************** }

constructor TW3Borders.Create$7(AOwner$5:TObjectTObject);
begin
  inherited Create$7(AOwner$5);
  FLeft := TW3Border.Create$36(Self, beLeft);
  FTop := TW3Border.Create$36(Self, beTop);
  FRight := TW3Border.Create$36(Self, beRight);
  FBottom := TW3Border.Create$36(Self, beBottom);
end;

destructor TW3Borders.Destroy;
begin
  FLeft.Free;
  FTop.Free;
  FRight.Free;
  FBottom.Free;
  inherited;
end;

procedure TW3Borders.setStyle(const aValue: TW3BorderEdgeStyle);
begin
  FLeft.Style := aValue;
  FTop.Style := aValue;
  FRight.Style := aValue;
  FBottom.Style := aValue;
end;

function TW3Borders.toString: String;
var
  mText:  String;
begin
  mText := 'Borders:|'
    + 'HSpace =' + IntToStr(getHSpace) + '|'
    + 'VSpace =' + IntToStr(getVSpace) + '|'
    + FLeft.ToString + '|'
    + FTop.ToString + '|'
    + FRight.ToString + '|'
    + FBottom.ToString;
  Result := w3_StringReplace(mText,'|',#13#10);
end;

function TW3Borders.getVSpace: Integer;
begin
  Result := FTop.Width$7 + FTop.Padding + FBottom.Width$7 + FBottom.Padding;
end;

function TW3Borders.getHSpace: Integer;
begin
  Result :=  FLeft.Width$7 + FLeft.Padding + FRight.Width$7 + FRight.Padding;
end;

function TW3Borders.AcceptParent(aObject$5:TObjectTObject): Boolean;
begin
  Result := (aObject$5 is TW3TagObj);
end;

function TW3Borders.getEdge(aKind: TW3BorderEdge): TW3Border;
begin
  case aKind of
  beLeft:   Result := FLeft;
  beTop:    Result := FTop;
  beRight:  Result := FRight;
  beBottom: Result := FBottom;
  end;
end;



{ **************************************************************************** }
{ TW3Border                                                                    }
{ **************************************************************************** }

constructor TW3Border.Create$36(AOwner$6: TW3BordersTW3Borders;AEdge: TW3BorderEdgeTW3BorderEdge);
begin
  inherited Create;
  FOwner$3 := AOwner$6;
  FEdge := Edge$1;
  case AEdge of
  beLeft:   FEdgeName := 'Left';
  beTop:    FEdgeName := 'Top';
  beRight:  FEdgeName := 'Right';
  beBottom: FEdgeName := 'Bottom';
  end;
end;

function TW3Border.EdgeStyleString(aValue: TW3BorderEdgeStyle): String;
begin
  case aValue of
  besSolid:   Result := 'solid';
  besDotted:  Result := 'dotted';
  besDouble:  Result := 'double';
  besGroove:  Result := 'groove';
  besInset:   Result := 'inset';
  besOutset:  Result := 'outset';
  else        Result := 'none';
  end;
end;

function TW3Border.ToString: String;
var
  mText:  String;
begin
  mText := FEdgeName + ' = {|'
    + 'Width: '  + IntToStr(getWidth) + '|'
    + 'Style: ' + EdgeStyleString(getStyle) + '|'
    + 'Padding:' + IntToStr(getPadding) + '|'
    + 'Color: ' + ColorToStr(getColor) + '|'
    + 'Margin: ' + IntToStr(getMargin) + '|'
    + '}';
  Result := w3_StringReplace(mText,'|',#13#10);
end;

function TW3Border.getPadding: Integer;
var
  mRef$20: THandle;
  mKey: String;
begin
  Result := 0;
  mRef$20 := TW3TagObj(FOwner$3.Owner$1).Handle;
  if (mRef$20) then
  begin
    mKey := 'padding-' + FEdgeName;
    Result := w3_getStyleAsInt(mRef$20,mKey);
  end;
end;

procedure TW3Border.setPadding(aValue$60: Integer);
var
  mRef$22:   THandle;
  mKey$2:   String;
begin
  mRef$22 := TW3TagObj(FOwner$3.Owner$1).Handle;
  if (mRef$22) then
  begin
    mKey$2 := 'padding' + FEdgeName;
    mRef$22.style[mKey$2] := TInteger.toPxStr(aValue$60);
  end else
  raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%}, ClassName, 
    'invalid owner handle error']);
end;

function TW3Border.getMargin: Integer;
var
  mRef: THandle;
  mKey: String;
begin
  Result := 0;
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'margin-' + FEdgeName;
    Result := w3_getStyleAsInt(mRef,mKey);
  end;
end;

procedure TW3Border.setmargin(const aValue: Integer);
var
  mRef:   THandle;
  mKey:   String;
begin
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'margin-' + FEdgeName;
    mRef.style[mKey] := TInteger.toPxStr(aValue);
  end else
  raise EW3TagObj.CreateFmt(CNT_ERR_METHOD,
  [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
end;

function TW3Border.getWidth$4: Integer;
var
  mRef$21: THandle;
  mKey$1: String;
begin
  Result := 0;
  mRef$21 := TW3TagObj(FOwner$3.Owner$1).Handle;
  if (mRef$21) then
  begin
    mKey$1 := 'border-' + FEdgeName + '-Width';
    Result := w3_getStyleAsInt(mRef$21,mKey$1);
  end;
end;

procedure TW3Border.setWidth(aValue$61: Integer);
var
  mRef$23:   THandle;
  mKey$3:   String;
begin
  mRef$23 := TW3TagObj(FOwner$3.Owner$1).Handle;
  if (mRef$23) then
  begin
    mKey$3 := 'border-' + FEdgeName + '-Width';
    w3_setStyle(mRef$23,mKey$3,TInteger.toPxStr(aValue$61));
  end else
  raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
end;

function TW3Border.getStyle: TW3BorderEdgeStyle;
var
  mRef:   THandle;
  mKey:   String;
  mValue: String;
begin
  Result := besNone;
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'border-' + FEdgeName + '-Style';
    mValue := w3_getStyleAsStr(mRef,mKey);
    mValue := Trim$_String_(LowerCase(mValue));
    case mValue of
      'solid' : Result := besSolid;
      'dotted' : Result := besDotted;
      'double' : Result := besDouble;
      'groove' : Result := besGroove;
      'inset' : Result := besInset;
      'outset' : Result := besOutset;
    end;
  end;
end;

procedure TW3Border.setStyle(aValue: TW3BorderEdgeStyle);
var
  mRef:   THandle;
  mKey:   String;
begin
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'border-' + FEdgeName + '-Style';
    w3_setStyle(mRef,mKey,EdgeStyleString(aValue));
    //mRef.style[mKey] := EdgeStyleString(aValue);
  end else
    raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%}, ClassName,
      'invalid owner handle error']);
end;

function TW3Border.getColor:TColor;
var
  mRef:   THandle;
  mKey:   String;
  mText:  String;
begin
  Result := 0;
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'border-' + FEdgeName + '-Color';
    mText := w3_getStyleAsStr(mRef,mKey);
    Result := StrToColor(mText);
  end;
end;

procedure TW3Border.setColor(aValue:TColor);
var
  mRef:   THandle;
  mKey:   String;
begin
  mRef := TW3TagObj(FOwner.Owner$1).Handle;
  if (mRef) then
  begin
    mKey := 'border-' + FEdgeName + '-Color';
    mRef.style[mKey] := ColorToStr(aValue);
  end else
  raise EW3TagObj.CreateFmt(CNT_ERR_METHOD, [{$I %FUNCTION%},ClassName,'invalid owner handle error']);
end;

end.

