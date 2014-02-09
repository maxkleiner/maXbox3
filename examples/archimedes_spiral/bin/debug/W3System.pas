{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3System;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

{$I 'vjl.inc'}

interface

{.$DEFINE EXP_GET_SET_Style}

const MAX_INT = 2147483647;

const CNT_ERR_METHOD = 'Method %s in class %s threw exception [%s]';
const CNT_ERR_PROC   = 'Procedure %s threw exception [%s]';

const CNT_ERR_TAGREF_ISNIL              = 'Internal tag-object is null error';
const CNT_ERR_TAGREF_CREATE             = 'Failed to create internal tag-object';
const CNT_ERR_TAGREF_INVALID_ATTRIBUTE  = 'Invalid attribute-name error';
const CNT_ERR_TAGREF_INVALID_PROPERTY   = 'Invalid property-name error';
const CNT_ERR_TAGREF_INVALID_STYLE      = 'Invalid style-name error';
const CNT_ERR_TAGREF_ATTACH_TO_PARENT   = 'Failed to attach element to owner';
const CNT_ERR_TAGREF_OWNER_ISNIL        = 'Owner tag-object is NIL error';

type
  TDateTime = Float;
  Real      = Float;
  Double    = Float;
  Extended  = Float;
  TColor    = Integer;
  THandle   = Variant;

  TProcedureRef TProcedureRef
  TNotifyEvent TNotifyEventSender: TObjectTObject);

  TObjArray   = array of TObject;
  TIntArray   = array of Integer;
  TStrArray   = array of String;
  TFloatArray = array of Float;

  TProcedureRefArray = array of TProcedureRef;

  TExposure = (esVisible, esPartly, esNone);

  (* mouse cursor types *)
  TCursor = (crAuto,crDefault,crInherited,
    crURL,crCrossHair,crHelp,crMove,
    crPointer,crProgress,crText,crWait,
    crNResize,crSResize,crEResize,crWResize,
    crNEResize,crNWReSize,crSEResize,crSWResize);

  { TPoint }
  TPoint = record
    X$1: Integer;
    Y$1: Integer;
    function ToString: String;
    function Compare(const aPoint: TPointTPoint): Boolean;
    class const NullPoint$1: TPoint = (X$1:0; Y$1:0);
    class function Create$16(const aCol$1, aRow$1: Integer): TPoint; static;
  end;
  TPointArray = array of TPoint;

  { TPointF }
  TPointF = record
    X: Float;
    Y: Float;
    function ToString: String;
    function Compare(const aPoint: TPointFTPointF): Boolean;
    class const NullPoint: TPointF = (X:0; Y:0);
    class function Create$15(const aCol, aRow: Float): TPointF; static;
  end;
  TPointArrayF = array of TPointF;

  { TRect }
  TRect = record
    Left$3:     Integer;
    Top$3:      Integer;
    Right$1:    Integer;
    Bottom$1:   Integer;
    function  Width$3: Integer;
    function  Height$3: Integer;
    function  ToString: String;
    function  TopLeft: TPoint;
    function  BottomRight: TPoint;
    function  CenterPoint$1 : TPoint;
    function  Clip(const RectToClip: TRectTRect): TRect;
    function  Empty: Boolean;
    function  Compare(const aRect: TRectTRect): Boolean;
    function  ContainsRow(const aRow: Integer): Boolean;
    function  ContainsCol(const aCol: Integer): Boolean;
    function  ContainsRect(const aRect: TRectTRect): Boolean;
    function  ContainsPos$1(const aLeft, aTop: Integer): Boolean;
    function  ContainsPoint(const aPoint: TPointTPoint): Boolean;
    function  Extend(x, y : Integer) : Boolean; overload;
    function  Extend(const aPoint : TPointTPoint) : Boolean; overload;
    function  Intersect(const aRect: TRectTRect; var intersection: TRectTRect): Boolean;
    function  Expose(const aChildRect: TRectTRect): TExposure;
    function  FitWithin(const aChildRect:TRectTRect):TRect;
    procedure Move(const aCol,aRow: Integer; const Center:Boolean);
    procedure MoveBy(dX, dY: Integer);
    function  ToPolygon : TPointArray;
    class const NullRect$1 : TRect = (Left$3:0; Top$3:0; Right$1: 0; Bottom$1: 0);
    class function CreateSized(const aLeft, aTop, aWidth, aHeight: Integer): TRect; overload;
    class function CreateSized(const aWidth, aHeight: Integer): TRect; overload;
    class function Create(const aLeft, aTop, aRight, aBottom: Integer): TRect; overload;
    class function Create(const topLeft, bottomRight: TPointTPointTPoint): TRect; overload;
  end;

  { TRectF }
  TRectF = record
    Left$2, Top$2, Right, Bottom: Float;
    function Width$2: Float;
    function Height$2: Float;
    function ToString: String;
    function TopLeft: TPointF;
    function BottomRight: TPointF;
    function CenterPoint : TPointF;
    function Clip(const RectToClip: TRectFTRectF): TRectF;
    function Empty: Boolean;
    function Compare(const aRect: TRectFTRectF): Boolean;
    function ContainsRow(const aRow: Float): Boolean;
    function ContainsCol(const aCol: Float): Boolean;
    function ContainsRect(const aRect: TRectFTRectF): Boolean;
    function ContainsPos(const aLeft, aTop: Float): Boolean;
    function ContainsPoint(const aPoint: TPointFTPointF): Boolean;
    function Intersect(const aRect: TRectFTRectF; var intersection: TRectFTRectF): Boolean;
    function Extend(const aPoint : TPointFTPointF) : Boolean; overload;
    function Extend(x, y : Float) : Boolean; overload;
    function Expose(const aChildRect: TRectFTRectF): TExposure;
    function FitWithin(const aChildRect:TRectFTRectF):TRectF;
    procedure Move(const aCol,aRow:Float;const Center:Boolean);
    procedure MoveBy(x,y : Float);
    function ToPolygon : TPointArrayF;
    class const NullRect : TRectF = (Left$2:0; Top$2:0; Right: 0; Bottom: 0);
    class function CreateSized(const aLeft, aTop, aWidth, aHeight: Float): TRectF; overload;
    class function CreateSized(const aWidth, aHeight: Float): TRectF; overload;
    class function Create(const aLeft, aTop, aRight, aBottom: Float): TRectF; overload;
    class function Create(const topLeft, bottomRight: TPointFTPointFTPointF): TRectF; overload;
    class function CreateBounded(x1, y1, x2, y2 : Float) : TRectF;
  end;

  { TW3RGBA }
  TW3RGBA = record
    R, G, B, A$1: Integer;
    function ToString: String;
    function ToColor: TColor;
    function getIntensity: Integer;
    class function getIntensityOf(const aValue: TW3RGBATW3RGBA): Integer; static;
    function Negative: TW3RGBA;
    class function NegativeOf(const aValue: TW3RGBATW3RGBA): TW3RGBA; static;
    function Darker(aPercent: Integer): TW3RGBA; overload;
    function Brighter(aPercent: Integer): TW3RGBA; overload;
    class function Create(const R, G, B, A: Integer): TW3RGBA; static;
  end;

  { TInteger }
  TInteger = class
    public
      class function toPxStr(const aValue$12: Integer): String;
      class function toHex(const aValue$11: Integer): String;
      class procedure Swap(var Primary, Secondary: Integer);
      class function Sum(const anArray: TIntArray): Integer;
      class function Average(const anArray: TIntArray): Integer;
      class function PercentOfValue(const Value$3, Total$2: Integer): Integer;
      class function Middle(const Primary, Secondary: Integer): Integer;
      class function Sign(const Value: Integer): Integer;
      class function Diff(const Primary, Secondary: Integer): Integer;
      class function ToNearestSigned(const Value, Factor: Integer): Integer;
      class function ToNearest(const Value, Factor: Integer): Integer;
      class function Largest(const Primary, Secondary: Integer): Integer; overload;
      class function Largest(const anArray: TIntArray): Integer; overload;
      class function Smallest(const Primary, Secondary: Integer): Integer; overload;
      class function Smallest(const anArray: TIntArray): Integer; overload;
      class function WrapRange(const aValue$13, aLowRange, aHighRange: Integer): Integer;
      class procedure Sort(var Domain: TIntArray);
      class function EnsureRange(const aValue$10, aMin, aMax: Integer): Integer;
      class procedure SetBit(index: Integer; aValue: Boolean; var buffer: Integer);
      class function GetBit(index: Integer; const buffer: Integer): Boolean;
  end;

  { TFloat }
  TFloat = class
    public
      class function PercentOfValue(const Value: Double; Total: Double): Double; static;
  end;

  { TVariant }
  TVariant = class
    public
      class function AsInteger(const aValue$4: Variant): Integer; static;
      class function AsString(const aValue$6: Variant): String; static;
      class function AsFloat(const aValue$3: Variant): Float; static;
      class function AsObject(const aValue$5: Variant): TObject; static;
      class function AsBool(const aValue: Variant): Boolean; static;
      class function IsNull(const aValue: Variant): Boolean; static;
      class function IsString(const aValue$9: Variant): Boolean; static;
      class function IsNumber(const aValue$8: Variant): Boolean; static;
      class function IsInteger(const aValue: Variant): Boolean; static;
      class function IsBool(const aValue: Variant): Boolean; static;
      class function IsNAN(const aValue$7: Variant): Boolean; static;
      class function Properties(const aValue: Variant): TStrArray; static;
      class function OwnProperties(const aValue: Variant): TStrArray; static;
      class function CreateObject : Variant; static;
      class function CreateArray : Variant; static;
  end;

  { EW3Exception }
  EW3Exception = class(Exception)
  public
    constructor CreateFmt(aText$1: String; const aValues: array of const);
  end;

  { EW3OwnedObject }
  EW3OwnedObject = class(EW3Exception);

  { TW3OwnedObject }
  TW3OwnedObject = class(TObject)
  private
    FOwner$1: TObject;
  protected
    function AcceptParent(aObject: TObjectTObject): Boolean; virtual;
  public
    property Owner$1: TObject read FOwner$1;
    constructor Create$7(AOwner: TObjectTObject); virtual;
  end;

  { TW3CustomBrowserAPI }
  TW3CustomBrowserAPI = class
  protected
    FCSSToken: String;
    FCSSBackgroundImage : String;
    FCSSBackgroundSize : String;
    FCSSBackgroundPos : String;
    FCSSBackgroundColor : String;
    FCSSTransform : String;
    FCSSAnimation : String;

  public
    //Prefix token: Moz, webkit, O, ms etc..
    property CSSToken: String read FCSSToken;

    property CSSBackgroundImage : String read FCSSBackgroundImage;
    property CSSBackgroundSize : String read FCSSBackgroundSize;
    property CSSBackgroundPos : String read FCSSBackgroundPos;
    property CSSBackgroundColor : String read FCSSBackgroundColor;
    property CSSTransform : String read FCSSTransform;
    property CSSAnimation : String read FCSSAnimation;

    class function GetDocument : THandle; static;
    class function GetBody : THandle; static;
    class function GetWindow : THandle; static;
    class function GetStyles : THandle; static;

    class function DevicePixelRatio : Float; static;
  end;

  { TW3WebkitBrowserAPI }
  TW3WebkitBrowserAPI = class(TW3CustomBrowserAPI)
  public
    constructor Create$5;
  end;

  { TW3FirefoxBrowserAPI }
  TW3FirefoxBrowserAPI = class(TW3CustomBrowserAPI)
  public
    constructor Create$10;
  end;

  TW3OperaBrowserAPI = class(TW3CustomBrowserAPI)
  public
    constructor Create$8;
  end;

  TW3IEBrowserAPI = Class(TW3CustomBrowserAPI)
  public
    constructor Create$9;
  End;

  JSON = class static sealed
    public
      class function Parse(jsonData : String) : Variant; static;
      class function Stringify(v : Variant) : String; overload; static;
  end;

{ Object management }
procedure w3_bind(obj_id: String; event_name: String; callback: TProcedureRefTProcedureRef);
procedure w3_bind2(obj_ref: THandle; event_name: String; callback: TProcedureRefTProcedureRef);
procedure w3_unbind(obj_ref: THandle; event_name: String);
procedure w3_AddEvent(a_tagRef$1: THandle; a_eventName$1: String; a_callback$1: TProcedureRefTProcedureRef; a_useCapture$1: boolean = true);
procedure w3_RemoveEvent(a_tagRef: THandle; a_eventName: String; a_callback: TProcedureRefTProcedureRef; a_useCapture: boolean = true);
procedure w3_setElementParentByName(aElement: THandle; aParentName: String);
procedure w3_setElementParentByRef(aElement: THandle; aParent: THandle);
procedure w3_RemoveElementByRef(aElement$1: THandle; aParent$1: THandle);
function w3_createHtmlElement(aTypeName: String): THandle;
function w3_getElementByName(aElementName: String): THandle;

{ property management }
function w3_getProperty(tagRef: THandle; aPropName: String): Variant;
procedure w3_setProperty(tagRef$1: THandle; aPropName: String; aValue$1: Variant);
function w3_getPropertyAsStr(tagRef$9: THandle; aPropName$1: String): String;
function w3_getPropertyAsInt(tagRef$10: THandle; aPropName$2: String): Integer;
function w3_getPropertyAsBool(tagRef$11: THandle; aPropName$3: String): Boolean;
function w3_getPropertyAsFloat(tagRef: THandle; aPropName: String): Float;

{ Attribute management }
function w3_getAttrib(tagRef$13: THandle; aAttribName$2: String): Variant;
procedure w3_setAttrib(tagRef$2: THandle; aAttribName: String; aValue$2: Variant);
function w3_getAttribAsStr(tagRef$12: THandle; aAttribName$1: String): String;
function w3_getAttribAsInt(tagRef: THandle; aAttribName: String): Integer;

{ Style management }
function w3_getCalcStyleFor(tagRef: THandle): Variant; deprecated;
function w3_getStyle(tagRef$8: THandle; aStyleName$4: String): Variant;
function w3_getStyleAsStr(tagRef$5: THandle; aStyleName$1: String): String;
function w3_getStyleAsInt(tagRef$6: THandle; aStyleName$2: String): Integer;
function w3_getStyleAsFloat(tagRef$7: THandle; aStyleName$3: String): Float;
procedure w3_setStyle(tagRef: THandle; aStyleName: String; aStyleValue: Variant);

{ Variant management }
function VarIsValidRef(const aRef: Variant): Boolean;
function ObjToVariant(value : TObjectTObject): Variant;
function VariantToObj(const Value: Variant): TObject;
function VariantExtend(target, prop : Variant) : Variant; overload;
function VariantExtend(target : JObject; prop : Variant) : JObject; overload;

{ Color management }
function StrToColor(aColorStr: String): TColor;
function ColorToStr(aColor$2: TColor): String;
function ColorToStrA(aColor$1: TColor; Alpha: Integer): String;
function ColorToWebStr(aColor: TColor): String;
function RGBToColor(aRed, aGreen, aBlue: Integer): TColor;

{ CSS management }
function w3_HasClass(tagRef$4: THandle; aClassName$1: String): Boolean;
procedure w3_AddClass(tagRef$14: THandle; aClassName$2: String);
procedure w3_RemoveClass(tagRef$3: THandle; aClassName: String);

{ DOM object references and helper functions }
function  w3_event: THandle;
function  w3_getInnerHtml(aRef: THandle): String;
procedure w3_setInnerHtml(aRef: THandle; aValue: String);

{ Unique identifier functions }
function w3_getUniqueObjId: String;
function w3_getUniqueNumber: Integer;

{ String functions }
function w3_StrLikeInArray(aLike: String; aArray: TStrArray): Integer;
function w3_StrToArray(aText: String; aDelimiter: String): TStrArray;
function w3_StringReplace(aValue: String; aToReplace: String; aNewValue: String): String;
function w3_NameToUrlStr(aUrl: String): String;

{ URI functions }
function encodeURIComponent(str : String) : String; external 'encodeURIComponent';
function decodeURIComponent(str : String) : String; external 'decodeURIComponent';
function encodeURI(str : String) : String; external 'encodeURI';
function decodeURI(str : String) : String; external 'decodeURI';

{ Misc utility functions }
procedure WriteLn(Value$2: Variant);
procedure w3_ShowMessage(aText: String);deprecated;
procedure ShowMessage$1(aText: String);
function w3_Prompt(aText : String; aDefault: String = '') : String;

{ Device detection }
function w3_getIsIPad: Boolean;
function w3_getIsIPhone: Boolean;
function w3_getIsIPod: Boolean;
function w3_getIsAndroid: Boolean;
function w3_getIsSafari: Boolean;
function w3_getIsFirefox: Boolean;
function w3_getIsChrome: Boolean;
function w3_getIsInternetExplorer: Boolean;
function w3_getIsOpera: Boolean;

function w3_getCursorCSSName(const aCursor:TCursor): String;

{ Base 64 }
function w3_base64encode(aValue: Variant): String;
function w3_base64decode(aValue: String): Variant;

{ System utility functions }
procedure w3_Callback(const aMethod$1: TProcedureRefTProcedureRef; const aDelay: Float);
function w3_RequestAnimationFrame(const aMethod: TProcedureRefTProcedureRef): THandle;
procedure w3_CancelAnimationFrame(handle: THandle);

{ Browser detection }
type
  TW3BrowserVendor = (
     bvUnknown,
     bviOS,
     bvAndroid,
     bvChrome,
     bvSafari,
     bvFirefox,
     bvOpera,
     bvIE
  );

function  W3_DOMReady:Boolean;
function  w3_GetBrowserName: String;
function  w3_BrowserVendor: TW3BrowserVendor;
function  w3_CSSPrefix(const aCSS$1: String): String; overload;
function  w3_CSSPrefixDef(const aCSS: String): String;
procedure InitVendorInfo;

procedure w3_RegisterBrowserAPI(aDriver: TW3CustomBrowserAPITW3CustomBrowserAPI);
function  BrowserAPI: TW3CustomBrowserAPI;

implementation

var _uniqueNumber: Integer;
//var VendorInfo: Array[TW3BrowserVendor] of TW3BrowserVendorInfo;
var Vendor: TW3BrowserVendor = bvUnknown;
var _driver: TW3CustomBrowserAPI;

procedure w3_RegisterBrowserAPI(aDriver: TW3CustomBrowserAPITW3CustomBrowserAPI);
begin
  _driver := aDriver;
end;

function BrowserAPI: TW3CustomBrowserAPI;
begin
  if _driver=nil then
  InitVendorInfo;
  Result := _driver;
end;


function w3_getCursorCSSName(const aCursor:TCursor): String;
begin
  case aCursor of
  crAuto:       Result := 'auto';
  crInherited:  Result := 'inherited';
  crURL:        Result := 'url';
  crCrossHair:  Result := 'crosshair';
  crHelp:       Result := 'help';
  crMove:       Result := 'move';
  crPointer:    Result := 'pointer';
  crProgress:   Result := 'progress';
  crText:       Result := 'text';
  crWait:       Result := 'wait';
  crNResize:    Result := 'n-resize';
  crSResize:    Result := 's-resize';
  crEResize:    Result := 'e-resize';
  crWResize:    Result := 'w-resize';
  crNEResize:   Result := 'ne-resize';
  crNWReSize:   Result := 'nw-resize';
  crSEResize:   Result := 'se-resize';
  crSWResize:   Result := 'sw-resize';
  else
    Result := 'default';
  end;
end;

  function W3_DOMReady:Boolean;
  var
    mState: String;
  begin
    asm @mState = document.readyState; end;
    Result:=LowerCase(mState)='complete';
  end;

{ **************************************************************************** }
{ Unique identifier functions                                                  }
{ **************************************************************************** }

{$HINTS OFF}
function w3_getUniqueObjId: String;
begin
  inc(_uniqueNumber);
  Result := 'OBJ' + IntToStr(_uniqueNumber);
end;
{$HINTS ON}

{$HINTS OFF}
function w3_getUniqueNumber: Integer;
begin
  inc(_uniqueNumber);
  Result := _uniqueNumber;
end;
{$HINTS ON}

{ **************************************************************************** }
{ Browser detection                                                            }
{ **************************************************************************** }

function  w3_GetBrowserName: String;
begin
  case Vendor of
  bvUnknown:  Result := 'Unknown browser';
  bviOS:      Result := 'Safari mobile';
  bvAndroid:  Result := 'Chrome mobile';
  bvChrome:   Result := 'Chrome';
  bvSafari:   Result := 'Safari';
  bvFirefox:  Result := 'FireFox';
  bvOpera:    Result := 'Opera';
  bvIE:       Result := 'Internet explorer';
  end;
end;

function  w3_BrowserVendor: TW3BrowserVendor;
begin
  Result := Vendor;
end;

function  w3_CSSPrefix(const aCSS$1: String): String;
begin
  Result := BrowserAPI.CSSToken + aCSS$1;
end;

function w3_CSSPrefixDef(const aCSS: String): String;
begin
  Result := '-' + BrowserAPI.CSSToken + '-' + aCSS;
end;

procedure InitVendorInfo;
begin
  if w3_getIsAndroid then Vendor := bvAndroid
  else if w3_getIsSafari then Vendor := bvSafari
  else if w3_getIsFirefox then Vendor := bvFirefox
  else if w3_getIsChrome then Vendor := bvChrome
  else if w3_getIsInternetExplorer then Vendor := bvIE
  else if w3_getIsOpera then Vendor := bvOpera;

  if Vendor=bvUnknown then
  begin
    (* None of the normal types, check for sub-types *)
    if w3_getIsIPhone or w3_getIsIPad or w3_getIsIPod then
      Vendor := bviOS;
  end;

  case Vendor of
  (* Webkit browsers *)
  bviOS, bvSafari, bvChrome, bvAndroid:
    w3_RegisterBrowserAPI(TW3WebkitBrowserAPI.Create$5);

  (* Moz browsers *)
  bvFirefox:  w3_RegisterBrowserAPI(TW3FirefoxBrowserAPI.Create$10);

  bvIE: w3_RegisterBrowserAPI(TW3IEBrowserAPI.Create$9);

  (* Opera browsers *)
  bvOpera:    w3_RegisterBrowserAPI(TW3OperaBrowserAPI.Create$8);
  else
    begin
      // Could not find a driver, default back to firefox.
      // Webkit browsers can typically handle firefox code better
      // than firefox can handle webkit. Opera tries to handle
      // as much as possible, while IE lives in a galaxy of its own.
      w3_RegisterBrowserAPI(TW3FirefoxBrowserAPI.Create$10);
    end;
  end;
end;

{ **************************************************************************** }
{ TW3CustomBrowserAPI                                                          }
{ **************************************************************************** }

class function TW3CustomBrowserAPI.GetDocument:THandle;
begin
  asm
    @Result=window.document;
  end;
end;

class function TW3CustomBrowserAPI.GetBody:THandle;
begin
  asm
    @Result=window.document.body;
  end;
end;

class function TW3CustomBrowserAPI.GetWindow:THandle;
begin
  asm
    @Result=window;
  end;
end;

class function TW3CustomBrowserAPI.GetStyles:THandle;
begin
  asm
    @result=window.style;
  end;
end;

class function TW3CustomBrowserAPI.DevicePixelRatio : Float;
begin
  asm
    @result=window.devicePixelRatio || 1;
  end;
end;


{ **************************************************************************** }
{ TW3IEBrowserAPI                                                          }
{ **************************************************************************** }

constructor TW3IEBrowserAPI.Create$9;
begin
  FCSSToken := 'ms';
  FCSSBackgroundImage := 'msBackgroundImage';
  FCSSBackgroundSize := 'msBackgroundSize';
  FCSSBackgroundPos := 'msBackgroundPosition';
  FCSSBackgroundColor := 'backgroundColor';
  FCSSTransform := 'msTransform';
  FCSSAnimation := 'msAnimation'
end;

{ **************************************************************************** }
{ TW3OperaBrowserAPI                                                          }
{ **************************************************************************** }

constructor TW3OperaBrowserAPI.Create$8;
begin
  FCSSToken := 'O';
  FCSSBackgroundImage := 'OBackgroundImage';
  FCSSBackgroundSize := 'OBackgroundSize';
  FCSSBackgroundPos := 'OBackgroundPosition';
  FCSSBackgroundColor := 'backgroundColor';
  FCSSTransform := 'OTransform';
  FCSSAnimation := 'OAnimation'
end;

{ **************************************************************************** }
{ TW3WebkitBrowserAPI                                                          }
{ **************************************************************************** }

constructor TW3WebkitBrowserAPI.Create$5;
begin
  FCSSToken := 'webkit';
  FCSSBackgroundImage := 'background-image';
  FCSSBackgroundSize := 'webkitbackgroundSize';
  FCSSBackgroundPos := 'webkitbackgroundPosition';
  FCSSBackgroundColor := 'webkitbackgroundColor';
  FCSSTransform := 'webkitTransform';
  FCSSAnimation := 'webkitAnimation'
end;

{ **************************************************************************** }
{ TW3FirefoxBrowserAPI                                                         }
{ **************************************************************************** }

constructor TW3FirefoxBrowserAPI.Create$10;
begin
  FCSSToken := 'Moz';
  FCSSBackgroundImage := 'backgroundImage';
  FCSSBackgroundSize := 'backgroundSize';
  FCSSBackgroundPos := 'backgroundPosition';
  FCSSBackgroundColor := 'backgroundColor';
  FCSSTransform := 'MozTransform';
  FCSSAnimation := 'MozAnimation'
end;

{ **************************************************************************** }
{  TW3RGBA                                                                     }
{ **************************************************************************** }

class function TW3RGBA.Create(const R,G,B,A: Integer): TW3RGBA;
begin
  Result.R := R;
  Result.G := G;
  Result.B := B;
  Result.A$1 := A;
end;

function TW3RGBA.ToString: String;
begin
  Result := ColorToStrA(RGBToColor(R,G,B),A$1);
end;

function TW3RGBA.ToColor:TColor;
begin
  Result := RGBToColor(R,G,B);
end;

function TW3RGBA.getIntensity: Integer;
begin
  Result := R + G + B;

  if Result>0 then
    Result := Result div 3;
end;

class function TW3RGBA.getIntensityOf(const aValue: TW3RGBATW3RGBA): Integer;
begin
  Result := aValue.R + aValue.G + aValue.B;

  if Result>0 then
    Result := Result div 3;
end;

function TW3RGBA.Negative: TW3RGBA;
begin
  Result.R := 255 - R;
  Result.G := 255 - G;
  Result.B := 255 - B;
  Result.A$1 := A$1;
end;

class function TW3RGBA.NegativeOf(const aValue: TW3RGBATW3RGBA): TW3RGBA;
begin
  Result.R := 255 - aValue.R;
  Result.G := 255 - aValue.G;
  Result.B := 255 - aValue.B;
  Result.A$1 := aValue.A$1;
end;

function TW3RGBA.Darker(aPercent: Integer): TW3RGBA;
begin
  var f := ClampInt(aPercent, 0, 99)/100;

  Result.R := ClampInt(R - Round(R*f),0,255);
  Result.G := ClampInt(G - Round(G*f),0,255);
  Result.B := ClampInt(B - Round(B*f),0,255);
  Result.A$1 := A$1;
end;

function TW3RGBA.Brighter(aPercent: Integer): TW3RGBA;
begin
  var f := ClampInt(aPercent, 0, 99)/100;

  Result.R := Round(R*f) + Round(255 - f*255);
  Result.G := Round(G*f) + Round(255 - f*255);
  Result.B := Round(B*f) + Round(255 - f*255);
  Result.A$1 := A$1;
end;


{ **************************************************************************** }
{ TPoint                                                                       }
{ **************************************************************************** }

function  TPoint.ToString: String;
begin
  Result := Format('%d,%d',[X$1,Y$1]);
end;

function TPoint.Compare(const aPoint:TPointTPoint): Boolean;
begin
  Result := (aPoint.X$1=X$1) and (aPoint.Y$1=Y$1);
end;

class function TPoint.Create$16(const aCol$1,aRow$1: Integer):TPoint;
begin
  Result.X$1 := aCol$1;
  Result.Y$1 := aRow$1;
end;


{ **************************************************************************** }
{ TPointF                                                                      }
{ **************************************************************************** }

function  TPointF.ToString: String;
begin
  Result := Format('%d,%d',[X,Y]);
end;

function TPointF.Compare(const aPoint:TPointFTPointF): Boolean;
begin
  Result := (aPoint.X=X) and (aPoint.Y=Y);
end;

class function TPointF.Create$15(const aCol,aRow:Float):TPointF;
begin
  Result.X := aCol;
  Result.Y := aRow;
end;

{ **************************************************************************** }
{ TRect                                                                        }
{ **************************************************************************** }

class function TRect.Create(const aLeft,aTop,aRight,aBottom: Integer):TRect;
begin
  Result.Left$3 := aLeft;
  Result.Top$3 := aTop;
  Result.Right$1 := aRight;
  Result.Bottom$1 := aBottom;
end;

class function TRect.Create(const topLeft, bottomRight:TPointTPointTPoint):TRect;
begin
  Result.Left$3 := topLeft.X$1;
  Result.Top$3 := topLeft.Y$1;
  Result.Right$1 := bottomRight.X$1;
  Result.Bottom$1 := bottomRight.Y$1;
end;

class function TRect.CreateSized(const aLeft,aTop,aWidth,aHeight: Integer):TRect;
begin
  Result.Left$3 := aLeft;
  Result.Top$3 := aTop;
  Result.Right$1 := aLeft + aWidth;
  Result.Bottom$1 := aTop + aHeight;
end;

class function TRect.CreateSized(const aWidth,aHeight: Integer):TRect;
begin
  Result.Left$3 := 0;
  Result.Top$3 := 0;
  Result.Right$1 := aWidth;
  Result.Bottom$1 := aHeight;
end;

function TRect.TopLeft:TPoint;
begin
  Result.X$1 := Left$3;
  Result.Y$1 := Top$3;
end;

function TRect.BottomRight:TPoint;
begin
  Result.X$1 := Right$1;
  Result.Y$1 := Bottom$1;
end;

function TRect.CenterPoint$1 : TPoint;
begin
   Result.X$1 := (Right$1+Left$3) div 2;
   Result.Y$1 := (Top$3+Bottom$1) div 2;
end;

function TRect.Width$3: Integer;
begin
   Result := Right$1-Left$3;
end;

function TRect.Height$3: Integer;
begin
   Result := Bottom$1-Top$3;
end;

function TRect.ToString: String;
begin
  Result := Format('%d,%d,%d,%d',[Left$3,Top$3,Right$1,Bottom$1]);
end;

function TRect.Clip(const RectToClip:TRectTRect):TRect;
begin
  if RectToClip.Left$3 < Left$3 then
    Result.Left$3 := Left$3
  else
    Result.Left$3 := RectToClip.Left$3;

  if RectToClip.Top$3 < Top$3 then
    Result.Top$3 := Top$3
  else
    Result.Top$3 := RectToClip.Top$3;

  if RectToClip.Right$1 > Right$1 then
    Result.Right$1 := Right$1
  else
    Result.Right$1 := RectToClip.Right$1;

  if RectToClip.Bottom$1 > Bottom$1 then
    Result.Bottom$1 := Bottom$1
  else
    Result.Bottom$1 := RectToClip.Bottom$1;
end;

function TRect.Empty: Boolean;
begin
  Result := (Left$3=Right$1) and (Top$3=Bottom$1);
end;

function TRect.Compare(const aRect:TRectTRect): Boolean;
begin
  Result := (Left$3=aRect.Left$3) and (Top$3=aRect.Top$3) and (Right$1=aRect.Right$1) and (Bottom$1=aRect.Bottom$1);
end;

function TRect.ContainsRow(const aRow: Integer): Boolean;
begin
  Result := (aRow>=Top$3) and (aRow<=Bottom$1);
end;

function TRect.ContainsCol(const aCol: Integer): Boolean;
begin
  Result := (aCol>=Left$3) and (aCol<=Right$1);
end;

function TRect.ContainsRect(const aRect:TRectTRect): Boolean;
begin
  Result := Expose(aRect)<>esNone;
end;

procedure TRect.MoveBy(dX, dY : Integer);
begin
  Inc(Left$3,dX);
  Inc(Right$1,dX);
  Inc(Top$3,dY);
  Inc(Bottom$1,dY);
end;

function TRect.ToPolygon : TPointArray;
begin
  Result := [ TPoint.Create$16(Left$3,Top$3), TPoint.Create$16(Right$1,Top$3),
              TPoint.Create$16(Right$1,Bottom$1), TPoint.Create$16(Left$3,Bottom$1) ];
end;

procedure TRect.Move(const aCol,aRow: Integer;const Center:Boolean);
var
  wd,hd:  Integer;
begin
  wd := Width$3;
  hd := Height$3;
  if Center then
  begin
    Left$3 := aCol - (wd div 2);
    Top$3 := aRow - (hd div 2);
    Right$1 := aCol + (wd div 2);
    Bottom$1 := aCol + (hd div 2);
  end
  else
  begin
    Left$3 := aCol;
    Top$3 := aRow;
    Right$1 := aCol + wd;
    Bottom$1 := aRow + hd;
  end;
end;

function TRect.FitWithin(const aChildRect:TRectTRect):TRect;
var
  x1,y1:  Double;
  x,y:    Integer;
  wd,hd:  Integer;
begin
  wd := aChildRect.Width$3;
  hd := aChildRect.Height$3;

  (* check if we can do anything *)
  if (wd<1) or (hd<1) then
  begin
    Result := TRect.NullRect;
    exit;
  end;

  (* Check if objRect will fit as it is *)
  if (Width$3>wd) and (Height$3>hd) then
  begin
    Result := Self;
    x := (Width$3 - wd) div 2;
    y := (Height$3 - hd) div 2;
    Result := TRect.Create(Result.Left$3 + x, Result.Top$3 + y,
                           Result.Left$3 + wd, Result.Top$3 + hd);
  end else
  begin
    x1 := Width$3 / wd;
    y1 := Height$3 / hd;
    if x1 > y1 then
    begin
      x := Trunc(wd*y1);
      Result := TRect.Create((Width$3-x) shr 1,0,aChildRect.Left$3+x,Height$3);
    end else
    begin
      y := Trunc(hd*x1);
      Result := TRect.Create(0,(Height$3-y) shr 1,Width$3,aChildRect.Top$3+y);
    end;
    Result.MoveBy(Left$3,Top$3);
  end;
end;

function TRect.Expose(const aChildRect:TRectTRect):TExposure;
begin
  if (aChildRect.Left$3>=Right$1)
  or (aChildRect.Top$3>=Bottom$1)
  or (aChildRect.Right$1<=Left$3)
  or (aChildRect.Bottom$1<=Top$3) then
  Result := esNone else
  begin
    if (aChildRect.Left$3<Left$3)
    or (aChildRect.Top$3<Top$3)
    or (aChildRect.Right$1>Right$1-1)
    or (aChildRect.Bottom$1>Bottom$1-1) then
    Result := esPartly else
    Result := esVisible;
  end;
end;

function TRect.ContainsPos$1(const aLeft,aTop: Integer): Boolean;
begin
  Result := (aLeft>=Left$3) and (aLeft<=Right$1) and (aTop>=Top$3) and (aTop<=Bottom$1);
end;

function TRect.ContainsPoint(const aPoint:TPointTPoint): Boolean;
begin
  Result := (aPoint.X$1>=Left$3) and (aPoint.X$1<=Right$1) and (aPoint.Y$1>=Top$3) and (aPoint.Y$1<=Bottom$1);
end;

function TRect.Extend(x, y : Integer) : Boolean;
begin
  if x<Left$3 then begin
    Left$3 := x;
    Result := True;
  end else if x>Right$1 then begin
    Right$1 := x;
    Result := True;
  end;
  if y<Top$3 then begin
    Top$3 := y;
    Result := True;
  end else if y>Bottom$1 then begin
    Bottom$1 := y;
    Result := True;
  end;
end;

function TRect.Extend(const aPoint : TPointTPoint) : Boolean;
begin
  Result := Extend(aPoint.X$1, aPoint.Y$1);
end;

function TRect.Intersect(const aRect:TRectTRect; var intersection:TRectTRect): Boolean;
begin
  intersection := Self;

  if aRect.Left$3>Left$3 then
    intersection.Left$3 := aRect.Left$3;

  if aRect.Top$3>Top$3 then
    intersection.Top$3 := aRect.Top$3;

  if aRect.Right$1<Right$1 then
    intersection.Right$1 := aRect.Right$1;

  if aRect.Bottom$1<Bottom$1 then
    intersection.Bottom$1 := aRect.Bottom$1;

  Result := (intersection.Right$1>intersection.Left$3) and (intersection.Bottom$1>intersection.Top$3);

  if not Result then
    intersection := NullRect;
end;

{ **************************************************************************** }
{ TRectF                                                                       }
{ **************************************************************************** }

class function TRectF.Create(const aLeft,aTop,aRight,aBottom: Float):TRectF;
begin
  Result.Left$2   := aLeft;
  Result.Top$2    := aTop;
  Result.Right  := aRight;
  Result.Bottom := aBottom;
end;

class function TRectF.Create(const topLeft, bottomRight:TPointFTPointFTPointF):TRectF;
begin
  Result.Left$2   := topLeft.X;
  Result.Top$2    := topLeft.Y;
  Result.Right  := bottomRight.X;
  Result.Bottom := bottomRight.Y;
end;

class function TRectF.CreateBounded(x1, y1, x2, y2 : Float) : TRectF;
begin
   if x1<x2 then begin
      Result.Left$2:=x1;
      Result.Right:=x2;
   end else begin
      Result.Left$2:=x2;
      Result.Right:=x1;
   end;
   if y1<y2 then begin
      Result.Top$2:=y1;
      Result.Bottom:=y2;
   end else begin
      Result.Top$2:=y2;
      Result.Bottom:=y1;
   end;
end;

class function TRectF.CreateSized(const aLeft,aTop,aWidth,aHeight: Float):TRectF;
begin
  Result.Left$2   := aLeft;
  Result.Top$2    := aTop;
  Result.Right  := aLeft + aWidth;
  Result.Bottom := aTop + aHeight;
end;

class function TRectF.CreateSized(const aWidth,aHeight: Float):TRectF;
begin
  Result.Left$2   := 0;
  Result.Top$2    := 0;
  Result.Right  := aWidth;
  Result.Bottom := aHeight;
end;

function TRectF.ToPolygon:TPointArrayF;
begin
  Result.setLength(4);
  Result[0] := TPointF.Create$15(Left$2,Top$2);
  Result[1] := TPointF.Create$15(Right,Top$2);
  Result[2] := TPointF.Create$15(Right,Bottom);
  Result[3] := TPointF.Create$15(Left$2,Bottom);
end;

procedure TRectF.MoveBy(x, y:Float);
begin
  Left$2 := Left$2 + x;
  Right := Right + x;
  Top$2 := Top$2 + y;
  Bottom := Bottom + y;
end;

procedure TRectF.Move(const aCol,aRow:Float;const Center:Boolean);
var
  wd,hd:  Float;
begin
  wd := Width$2;
  hd := Height$2;
  case Center of
  false:
    begin
      Left$2 := aCol;
      Top$2 := aRow;
      Right := aCol + wd;
      Bottom := aRow + hd;
    end;
  true:
    begin
      Left$2 := aCol - (wd / 2);
      Top$2 := aRow - (hd / 2);
      Right := aCol + (wd / 2);
      Bottom := aCol + (hd / 2);
    end;
  end;
end;

function TRectF.FitWithin(const aChildRect:TRectFTRectF):TRectF;
var
  x1,y1:  Float;
  rc:     TRectF;
  x,y:    Float;
  wd,hd:  Float;
begin
  wd := aChildRect.Width$2;
  hd := aChildRect.Height$2;

  (* check if we can do anything *)
  if (wd<1) or (hd<1) then
  begin
    Result := TRectF.NullRect;
    exit;
  end;

  (* Check if objRect will fit as it is *)
  if (Width$2>wd) and (Height$2>hd) then
  begin
    Result := Self;
    x := (Width$2 - wd) / 2;
    y := (Height$2 - hd) / 2;
    Result := TRectF.Create(Result.Left$2 + x,Result.Top$2 + y,
                            Result.Left$2 + wd,Result.Top$2 + hd);
  end else
  begin
    x1 := Width$2 / wd;
    y1 := Height$2 / hd;
    if x1 > y1 then
    begin
      x := Trunc(wd*y1);
      rc := TRectF.Create((Width$2-x)/2,0,rc.Left$2+x,Height$2);
    end else
    begin
      y := Trunc(hd*x1);
      rc := TRectF.Create(0,(Height$2-y)/2,Width$2,rc.Top$2+y);
    end;
    Result := TRectF.Create(rc.Left$2 + Left$2, rc.Top$2 + Top$2,
                            rc.Right + Left$2, rc.Bottom + Top$2);
  end;
end;

function TRectF.Width$2:Float;
begin
  Result := Right-Left$2;
end;

function TRectF.Height$2:Float;
begin
  Result := Bottom-Top$2;
end;

function TRectF.ToString: String;
begin
  Result := Format('%d,%d,%d,%d',[Left$2,Top$2,Right,Bottom]);
end;

function TRectF.TopLeft:TPointF;
begin
  Result.X := Left$2;
  Result.Y := Top$2;
end;

function TRectF.BottomRight:TPointF;
begin
  Result.X := Right;
  Result.Y := Bottom;
end;

function TRectF.CenterPoint : TPointF;
begin
  Result.X := (Right+Left$2)*0.5;
  Result.Y := (Bottom+Top$2)*0.5;
end;

function TRectF.Clip(const RectToClip:TRectFTRectF):TRectF;
begin
  if RectToClip.Left$2 < Left$2 then
    Result.Left$2 := Left$2
  else
    Result.Left$2 := RectToClip.Left$2;

  if RectToClip.Top$2 < Top$2 then
    Result.Top$2 := Top$2
  else
    Result.Top$2 := RectToClip.Top$2;

  if RectToClip.Right > Right then
    Result.Right := Right
  else
    Result.Right := RectToClip.Right;

  if RectToClip.Bottom > Bottom then
    Result.Bottom := Bottom
  else
    Result.Bottom := RectToClip.Bottom;
end;

function TRectF.Empty: Boolean;
begin
  Result := (Left$2=Right) and (Top$2=Bottom);
end;

function TRectF.Compare(const aRect:TRectFTRectF): Boolean;
begin
  Result := (Left$2=aRect.Left$2) and (Top$2=aRect.Top$2) and (Right=aRect.Right) and (Bottom=aRect.Bottom);
end;

function TRectF.ContainsRow(const aRow:Float): Boolean;
begin
  Result := (aRow>=Top$2) and (aRow<=Bottom);
end;

function TRectF.ContainsCol(const aCol:Float): Boolean;
begin
  Result := (aCol>=Left$2) and (aCol<=Right);
end;

function TRectF.ContainsRect(const aRect:TRectFTRectF): Boolean;
begin
  Result := Expose(aRect)<>esNone;
end;

function TRectF.Expose(const aChildRect:TRectFTRectF):TExposure;
begin
  if (aChildRect.Left$2>=Right) or (aChildRect.Top$2>=Bottom) or (aChildRect.Right<=Left$2) or (aChildRect.Bottom<=Top$2) then
    Result := esNone
  else begin
    if (aChildRect.Left$2<Left$2) or (aChildRect.Top$2<Top$2) or (aChildRect.Right>Right-1) or (aChildRect.Bottom>Bottom-1) then
      Result := esPartly
    else
      Result := esVisible;
  end;
end;

function TRectF.ContainsPos(const aLeft,aTop:Float): Boolean;
begin
  Result := (aLeft>=Left$2) and (aLeft<=Right) and (aTop>=Top$2) and (aTop<=Bottom);
end;

function TRectF.ContainsPoint(const aPoint:TPointFTPointF): Boolean;
begin
  Result := (aPoint.X>=Left$2) and (aPoint.X<=Right) and (aPoint.Y>=Top$2) and (aPoint.Y<=Bottom);
end;

function TRectF.Extend(x, y : Float) : Boolean;
begin
  if x<Left$2 then begin
    Left$2 := x;
    Result := True;
  end else if x>Right then begin
    Right := x;
    Result := True;
  end;
  if y<Top$2 then begin
    Top$2 := y;
    Result := True;
  end else if y>Bottom then begin
    Bottom := y;
    Result := True;
  end;
end;

function TRectF.Extend(const aPoint : TPointFTPointF) : Boolean;
begin
  Result := Extend(aPoint.X, aPoint.Y);
end;

function TRectF.Intersect(const aRect:TRectFTRectF; var intersection:TRectFTRectF): Boolean;
begin
  intersection := Self;

  if aRect.Left$2>Left$2 then
    intersection.Left$2 := aRect.Left$2;

  if aRect.Top$2>Top$2 then
    intersection.Top$2 := aRect.Top$2;

  if aRect.Right<Right then
    intersection.Right := aRect.Right;

  if aRect.Bottom<Bottom then
    intersection.Bottom := aRect.Bottom;

  Result := (intersection.Right>intersection.Left$2) and (intersection.Bottom>intersection.Top$2);

  if not Result then
    intersection := NullRect;
end;



{ **************************************************************************** }
{ System utility functions                                                     }
{ **************************************************************************** }

procedure w3_Callback(const aMethod$1:TProcedureRefTProcedureRef;const aDelay:Float);
begin
  asm
    setTimeout(@aMethod$1,@aDelay);
  end;
end;

var vRequestAnimFrame: function (const meth : TProcedureRefTProcedureRef): THandle;
var vCancelAnimFrame : procedure (handle: THandle);

procedure InitAnimationFrameShim;
begin
  asm
    @vRequestAnimFrame = (function(){
      return  window.requestAnimationFrame       ||
              window.webkitRequestAnimationFrame ||
              window.mozRequestAnimationFrame    ||
              window.oRequestAnimationFrame      ||
              window.msRequestAnimationFrame     ||
              function( callback ){
                return window.setTimeout(callback, 1000 / 60);
              };
    })();
    @vCancelAnimFrame = (function(){
      return  window.cancelAnimationFrame       ||
              window.webkitCancelAnimationFrame ||
              window.mozCancelAnimationFrame    ||
              window.oCancelAnimationFrame      ||
              window.msCancelAnimationFrame     ||
              function( handle ){
                window.clearTimeout(handle);
              };
    })();
  end;
end;

function w3_RequestAnimationFrame(const aMethod: TProcedureRefTProcedureRef): THandle;
begin
  if not Assigned(vRequestAnimFrame) then
    InitAnimationFrameShim;
  Result :=  vRequestAnimFrame(aMethod);
end;

procedure w3_CancelAnimationFrame(handle: THandle);
begin
  if not Assigned(vCancelAnimFrame) then
    InitAnimationFrameShim;
  vCancelAnimFrame(handle);
end;

{ **************************************************************************** }
{ Variant management                                                           }
{ **************************************************************************** }

function VarIsValidRef(const aRef:Variant): Boolean;
begin
  asm
    @Result = !((@aRef == null) || (@aRef == undefined));
  end;
end;

function ObjToVariant(value : TObjectTObject):Variant;
begin
  asm
    @Result = @value;
  end;
end;

function VariantToObj(const Value:Variant):TObject;
begin
  asm
    @Result = @value;
  end;
end;

function VariantExtend(target, prop : Variant) : Variant;
var
   n : Variant;
begin
   asm
     for (@n in @prop) if ((@prop).hasOwnProperty(@n)) @target[@n]=@prop[n];
     @Result = @target;
   end;
end;

function VariantExtend(target : JObject; prop : Variant) : JObject;
var
   n : Variant;
begin
   asm
     for (@n in @prop) if ((@prop).hasOwnProperty(@n)) @target[@n]=@prop[n];
     @Result = @target;
   end;
end;

{ **************************************************************************** }
{ Base 64                                                                      }
{ **************************************************************************** }

function w3_base64encode(aValue:Variant): String;
begin
  if VarIsValidRef(aValue) then
  begin
    asm
      @Result = window.btoa(@aValue);
    end;
  end;
end;

function w3_base64decode(aValue: String):Variant;
begin
  if Length(aValue)>0 then
  begin
    asm
      @Result = window.atob(@aValue);
    end;
  end
  else begin
    asm
      @Result = undefined;
    end;
  end;
end;



{ **************************************************************************** }
{ Device detection                                                             }
{ **************************************************************************** }

{$HINTS OFF}
function w3_getIsIPad: Boolean;
var
  mTemp$5: Variant;
begin
  asm
    @mTemp$5 = navigator.userAgent.match(/iPad/i);
    if (@mTemp$5) @Result = true;
  end;
  //Result := Assigned(mTemp);
end;
{$HINTS ON}

{$HINTS OFF}
function  w3_getIsIPhone: Boolean;
var
  mTemp$4:  Variant;
begin
  asm
    @mTemp$4 = navigator.userAgent.match(/iPhone/i);
    if (@mTemp$4) @Result = true;
  end;
  //Result := Assigned(mTemp);
end;
{$HINTS ON}

{$HINTS OFF}
function w3_getIsIPod: Boolean;
var
  mTemp$3:  Variant;
begin
  asm
    @mTemp$3 = navigator.userAgent.match(/iPod/i);
    if (@mTemp$3) @Result = true;
  end;
  //Result := Assigned(mTemp);
end;
{$HINTS ON}

{$HINTS OFF}
function  w3_getIsAndroid: Boolean;
var
  mTemp$9: Variant;
begin
  asm
    @mTemp$9 = navigator.userAgent.match(/Android/i);
    if (@mTemp$9) @Result = true;
  end;
end;
{$HINTS ON}

function  w3_getIsSafari: Boolean;
var
  mTemp$1: Variant;
begin
  asm
    @mTemp$1 = navigator.userAgent.match(/Safari/i);
    if (@mTemp$1) @Result = true;
  end;
end;

function  w3_getIsFirefox: Boolean;
var
  mTemp$7:  Variant;
begin
  asm
    @mTemp$7 = navigator.userAgent.match(/Firefox/i);
    if (@mTemp$7) @Result = true;
  end;
end;

function  w3_getIsChrome: Boolean;
var
  mTemp$8:  Variant;
begin
  asm
    @mTemp$8 = navigator.userAgent.match(/Chrome/i);
    if (@mTemp$8) @Result = true;
  end;
end;

function  w3_getIsInternetExplorer: Boolean;
var
  mTemp$6:  Variant;
begin
  asm
    @mTemp$6 = navigator.userAgent.match(/MSIE/i);
    if (@mTemp$6) @Result = true;
  end;
end;

function  w3_getIsOpera: Boolean;
var
  mTemp$2:  Variant;
begin
  asm
    @mTemp$2 = navigator.userAgent.match(/Opera/i);
    if (@mTemp$2) @Result = true;
  end;
end;

{ **************************************************************************** }
{ String functions                                                             }
{ **************************************************************************** }

function w3_StrLikeInArray(aLike: String;aArray:TStrArray): Integer;
var
  x:  Integer;
  mLen1: Integer;
  mLen2: Integer;
begin
  Result := -1;
  mLen1 := Length(aLike);
  if (mLen1>0) and (aArray.length>0) then
  begin
    for x := 0 to aArray.length-1 do
    begin
      mLen2 := Length(aArray[x]);
      if mLen2>=mLen1 then
      begin
        if Copy(aArray[x],1,mLen1)=aLike then
        begin
          Result := x;
          break;
        end;
      end;
    end;
  end;
end;

{$HINTS OFF}
function  w3_StrToArray(aText: String;aDelimiter: String):TStrArray;
var
  mRef: Variant;
  mLen: Integer;
  x:  Integer;
begin
  Result := new String[0];
  if (length(aText)>0) and (length(aDelimiter)>0) then
  begin
    asm
      @mRef = (@aText).split(@aDelimiter);
      @mLen = (@mRef).length;
    end;
    for x := 0 to mLen-1 do
    begin
      asm
        (@Result).push((@mRef)[@x]);
      end;
    end;
  end;
end;
{$HINTS ON}

function w3_StringReplace(aValue: String;aToReplace: String; aNewValue: String): String;
var
  xpos: Integer;
  seg1,seg2:  String;
  mStride: Integer;
begin
  xpos := Pos(aToReplace,aValue);
  if xpos>0 then
  begin
    repeat
      mStride := xpos + Length(aNewValue);  //Keep stride
      if xpos>1 then
      seg1 := Copy(aValue,1,xpos-1) else
      seg1 := '';

      seg2 := Copy(aValue,xpos+Length(aToReplace), Length(aValue));

      aValue := seg1 + aNewValue + seg2;

      xpos := Pos(aToReplace,aValue);
    until (xpos<1) or (xpos<mStride); //check against offset to avoid recursive
  end;

  Result := aValue;
end;

function  w3_NameToUrlStr(aUrl: String): String;
begin
  Result := 'url(' + aUrl + ')';
end;



{ **************************************************************************** }
{ CSS management                                                               }
{ **************************************************************************** }

function w3_HasClass(tagRef$4:THandle;aClassName$1: String): Boolean;
begin
  asm
    @Result = (@tagRef$4).className.match(new RegExp("(\\s|^)"+@aClassName$1+"(\\s|$)"));
  end;
end;

procedure w3_AddClass(tagRef$14:THandle;aClassName$2: String);
begin
  if not w3_HasClass(tagRef$14,aClassName$2) then
  begin
    asm
      (@tagRef$14).className += " " + @aClassName$2;
    end;
  end;
end;

procedure w3_RemoveClass(tagRef$3:THandle;aClassName: String);
var
  reg:  Variant;
begin
  if w3_HasClass(tagRef$3,aClassName) then
  begin
    asm
      @reg = new RegExp("(\\s|^)" + @aClassName + "(\\s|$)");
      (@tagRef$3).className=(@tagRef$3).className.replace(@reg," ");
    end;
  end;
end;



{ **************************************************************************** }
{ TW3OwnedObject                                                               }
{ **************************************************************************** }

constructor TW3OwnedObject.Create$7(AOwner:TObjectTObject);
begin
  inherited Create;

  if AcceptParent(AOwner) then
    FOwner$1 := AOwner
  else
    raise EW3OwnedObject.CreateFmt(CNT_ERR_METHOD, ['constructor', ClassName,
      'Unsuitable owner object-type error']);
end;

function TW3OwnedObject.AcceptParent(aObject:TObjectTObject): Boolean;
begin
  Result := True;
end;



{ **************************************************************************** }
{ Style management                                                             }
{ **************************************************************************** }

function w3_getCalcStyleFor(tagRef:THandle):Variant;
begin
  asm
    @Result = document.defaultView.getComputedStyle(@tagRef,null);
  end;
end;

function  w3_getStyle(tagRef$8:THandle;aStyleName$4: String):Variant;
var
  mObj: THandle;
begin
  asm
    @mObj = document.defaultView.getComputedStyle(@tagRef$8,null);
    if (@mObj)
    @Result = (@mObj).getPropertyValue(@aStyleName$4);
  end;
end;

function  w3_getStyleAsStr(tagRef$5:Variant;aStyleName$1: String): String;
var
  mData:  Variant;
begin
  Result := '';
  mData := w3_getStyle(tagRef$5,aStyleName$1);
  if VarIsValidRef(mData) then
  begin
    if TVariant.IsString(mData) then
    Result := TVariant.AsString(mData) else
    if TVariant.IsNumber(mData) then
    Result := IntToStr(TVariant.AsInteger(mData));
  end;
end;

function w3_getStyleAsInt(tagRef$6:Variant;aStyleName$2: String): Integer;
var
  mData$1: Variant;
  {$IFDEF EXP_GET_SET_Style}
  mObj: Variant;
  {$ENDIF}
begin
  {$IFDEF EXP_GET_SET_Style}
  (* Replaces: w3_getStyle(tagRef,aStyleName); *)
  asm
    @mObj = document.defaultView.getComputedStyle(@tagRef,null);
    if (@mObj)
    @mData = (@mObj).getPropertyValue(@aStyleName);
  end;

  (* replaces: "if varIsValidRef(mData) then" *)
  asm
    if (!@mData) return 0;
  end;

  if TVariant.IsNumber(mData) then
  begin
    asm
      @Result = Number(@mData);
    end;
  end else
  if TVariant.IsString(mData) then
  begin
    asm
      @Result = parseInt(@mData);
      if (isNaN(@Result)) @Result=0;
    end;
  end;
  {$ELSE}
  mData$1 := w3_getStyle(tagRef$6,aStyleName$2);
  if VarIsValidRef(mData$1) then
  begin
    if TVariant.IsNumber(mData$1) then
    Result := TVariant.AsInteger(mData$1) else
    if TVariant.IsString(mData$1) then
    begin
      asm
        @Result = parseInt(@mData$1);
      end;
      if TVariant.IsNAN(Result) then
      Result := 0;
    end;
  end;
  {$ENDIF}
end;

function  w3_getStyleAsFloat(tagRef$7:Variant;aStyleName$3: String):Float;
var
  mData$2: Variant;
begin
  Result := 0.0;
  mData$2 := w3_getStyle(tagRef$7,aStyleName$3);
  if VarIsValidRef(mData$2) then
  begin
    try
      if TVariant.IsNumber(mData$2) then
      begin
        Result := TVariant.AsFloat(mData$2);
        if TVariant.IsNAN(Result) then
        Result := 0.0;
      end else
      if TVariant.IsString(mData$2) then
      begin
        asm
          @Result = parseFloat(@mData$2);
        end;
        if TVariant.IsNAN(Result) then
        Result := 0.0;
      end;
    except
      on e: Exception do;
    end;
  end;
end;

procedure w3_setStyle(tagRef:THandle;aStyleName: String;aStyleValue:Variant);
begin
  if (tagRef) then
    tagRef.style[aStyleName]:=aStyleValue;
end;



{ **************************************************************************** }
{ Attribute management                                                         }
{ **************************************************************************** }

function w3_getAttrib(tagRef$13:THandle;aAttribName$2: String):Variant;
begin
  asm
    if (@tagRef$13)
    @Result=(@tagRef$13).getAttribute(@aAttribName$2);
  end;
end;

procedure w3_setAttrib(tagRef$2:THandle;aAttribName: String;aValue$2:Variant);
begin
  asm
    if (@tagRef$2)
    (@tagRef$2).setAttribute(@aAttribName,@aValue$2);
  end;
end;

{$HINTS OFF}
function w3_getAttribAsStr(tagRef$12:THandle;aAttribName$1: String): String;
var
  mValue: TObject;
begin
  asm
    @mValue=(@tagRef$12).getAttribute(@aAttribName$1,0);
    if (@mValue)
    @Result = String(@mValue);
  end;
end;
{$HINTS ON}

{$HINTS OFF}
function w3_getAttribAsInt(tagRef:THandle;aAttribName: String): Integer;
var
  mValue: TObject;
begin
  asm
    @mValue=(@tagRef).getAttribute(@aAttribName,0);
    if (@mValue)
    @Result = parseInt(@mValue);
  end;
end;
{$HINTS ON}



{ **************************************************************************** }
{ property management                                                          }
{ **************************************************************************** }

function w3_getProperty(tagRef:THandle;aPropName: String):Variant;
begin
  asm
    @Result=(@tagRef)[@aPropName];
  end;
end;

procedure w3_setProperty(tagRef$1:THandle;aPropName: String;aValue$1:Variant);
begin
  asm
  (@tagRef$1)[@aPropName] = @aValue$1;
  end;
end;

function w3_getPropertyAsStr(tagRef$9:THandle;aPropName$1: String): String;
begin
  asm
    if (@tagRef$9)
    @Result = String( (@tagRef$9)[@aPropName$1] );
  end;
end;

function w3_getPropertyAsInt(tagRef$10:THandle;aPropName$2: String): Integer;
begin
  asm
    if (@tagRef$10)
    @Result = parseInt((@tagRef$10)[@aPropName$2]);
  end;
end;

function w3_getPropertyAsBool(tagRef$11:THandle;aPropName$3: String): Boolean;
begin
  asm
    if (@tagRef$11)
    @Result = Boolean( (@tagRef$11)[@aPropName$3] );
  end;
end;

function w3_getPropertyAsFloat(tagRef:THandle;aPropName: String):Float;
begin
  asm
    if (@tagRef)
    @Result = parseFloat( (@tagRef)[@aPropName] );
  end;
end;



{ **************************************************************************** }
{ Color management                                                             }
{ **************************************************************************** }

function StrToColor(aColorStr: String):TColor;
var
  mTemp$10:  String;
  xpos$1: Integer;
  r,g,b:  Integer;
begin
  aColorStr := Trim$_String_(LowerCase(aColorStr));
  if Length(aColorStr)>1 then
  begin
    if ( (aColorStr[1]='#')
    or   (aColorStr[1]='$') ) then
    begin
      Delete(aColorStr,1,1);
      Result := HexToInt('0x' + aColorStr);
    end else
    if Copy(aColorStr,1,2)='0x' then
      Result := HexToInt(aColorStr) else

    if Copy(aColorStr,1,4)='rgb(' then
    begin
      Delete(aColorStr,1,4);
      try
        xpos$1 := Pos(',',aColorStr);
        if xpos$1>1 then
        begin
          mTemp$10 := Copy(aColorStr,1,xpos$1-1);
          Delete(aColorStr,1,xpos$1);
          if mTemp$10[1]='$' then
          begin
            Delete(mTemp$10,1,1);
            mTemp$10 := ('0x' + mTemp$10);
          end;
          r := StrToInt(mTemp$10);
        end;

        xpos$1 := Pos(',',aColorStr);
        if xpos$1>1 then
        begin
          mTemp$10 := Copy(aColorStr,1,xpos$1-1);
          Delete(aColorStr,1,xpos$1);
          if mTemp$10[1]='$' then
          begin
            Delete(mTemp$10,1,1);
            mTemp$10 := ('0x' + mTemp$10);
          end;
          g := StrToInt(mTemp$10);
        end;

        xpos$1 := Pos(')',aColorStr);
        if xpos$1>1 then
        begin
          mTemp$10 := Copy(aColorStr,1,xpos$1-1);
          if mTemp$10[1]='$' then
          begin
            Delete(mTemp$10,1,1);
            mTemp$10 := ('0x' + mTemp$10);
          end;
          b := StrToInt(mTemp$10);
        end;

        Result := RGBToColor(r,g,b);
      except
        on e: Exception do
        exit;
      end;
    end;
  end else
  Result := 0;
end;

function ColorToStr(aColor$2:TColor): String;
var
  r$3,g$3,b$3: Integer;
begin
  r$3 := (aColor$2 shr 16) and $FF;
  g$3 := (aColor$2 shr 8) and $FF;
  b$3 := (aColor$2 shr 0) and $FF;
  Result := '0x' + TInteger.toHex(r$3) + TInteger.toHex(g$3) + TInteger.toHex(b$3);
end;

function ColorToStrA(aColor$1:TColor;Alpha: Integer): String;
var
  r$2,g$2,b$2: Integer;
  a: Float;
begin
  r$2 := (aColor$1 shr 16) and $FF;
  g$2 := (aColor$1 shr 8) and $FF;
  b$2 := (aColor$1 shr 0) and $FF;
  a := Alpha / 255;
  Result := 'rgba('
  + IntToStr(r$2) + ','
  + IntToStr(g$2) + ','
  + IntToStr(b$2) + ','
  + FloatToStr(a) + ')';
end;

function ColorToWebStr(aColor:TColor): String;
var
  r$1,g$1,b$1: Integer;
begin
  r$1 := (aColor shr 16) and $FF;
  g$1 := (aColor shr 8) and $FF;
  b$1 := (aColor shr 0) and $FF;
  Result := '#' + TInteger.toHex(r$1) + TInteger.toHex(g$1) + TInteger.toHex(b$1);
end;

function RGBToColor(aRed,aGreen,aBlue: Integer):TColor;
begin
  Result := aBlue or (aGreen shl 8) or (aRed shl 16);
end;



{ **************************************************************************** }
{ DOM object references and helper functions                                   }
{ **************************************************************************** }

(* function w3_getDocument:THandle;
begin
  asm
    @Result = window.document;
  end;
end;

function w3_getBody:THandle;
begin
  asm
    @Result = window.document.body;
  end;
end;

function w3_getWindow:THandle;
begin
  asm
    @Result = window;
  end;
end;

function w3_getStyles:THandle;
begin
  asm
    @Result = window.style;
  end;
end; *)


function w3_event:THandle;
begin
  asm
    @Result = event;
  end;
end;

function w3_getInnerHtml(aRef:THandle): String;
begin
  asm
    @Result = (@aRef).innerHTML;
  end;
end;

procedure w3_setInnerHtml(aRef:THandle;aValue: String);
begin
  asm
    (@aRef).innerHTML = @aValue;
  end;
end;



{ **************************************************************************** }
{ Misc utility functions                                                       }
{ **************************************************************************** }

procedure WriteLn(Value$2:Variant);
begin
  asm
    if (window.console)
    window.console.log(@Value$2);
  end;
end;

procedure w3_ShowMessage(aText: String);
begin
  asm
    alert(@aText);
  end;
end;

procedure ShowMessage$1(aText: String);
begin
  asm
    alert(@aText);
  end;
end;

function w3_Prompt(aText: String; aDefault: String = ''): String;
begin
   asm
      @Result=prompt(@aText, @aDefault);
   end;
end;

{ **************************************************************************** }
{ Object management                                                            }
{ **************************************************************************** }

procedure w3_bind(obj_id: String;event_name: String; callback:TProcedureRefTProcedureRef);deprecated;
begin
  asm
    document.getElementById(@obj_id)[@event_name] = @callback;
  end;
end;

procedure w3_bind2(obj_ref:THandle;event_name: String; callback:TProcedureRefTProcedureRef);
begin
  asm
    (@obj_ref)[@event_name] = @callback;
  end;
end;

procedure w3_unbind(obj_ref:THandle;event_name: String);
begin
  asm
    (@obj_ref)[@event_name] = null;
  end;
end;

procedure w3_AddEvent(a_tagRef$1:THandle;a_eventName$1: String; a_callback$1:TProcedureRefTProcedureRef;
  a_useCapture$1: boolean);
//mousewheel handling: http://www.switchonthecode.com/tutorials/javascript-tutorial-the-scroll-wheel
begin
  if a_eventName$1 = 'mousewheel' then asm
    (@a_tagRef$1).addEventListener('DOMMouseScroll',@a_callback$1,@a_useCapture$1);
  end;
  asm
    (@a_tagRef$1).addEventListener(@a_eventName$1,@a_callback$1,@a_useCapture$1);
  end;
end;

procedure w3_RemoveEvent(a_tagRef:THandle;a_eventName: String; a_callback:TProcedureRefTProcedureRef;
  a_useCapture: boolean);
//mousewheel handling: http://www.switchonthecode.com/tutorials/javascript-tutorial-the-scroll-wheel
begin
  if a_eventName = 'mousewheel' then asm
    (@a_tagRef).removeEventListener('DOMMouseScroll',@a_callback,@a_useCapture);
  end;
  asm
    (@a_tagRef).removeEventListener(@a_eventName,@a_callback,@a_useCapture)
  end;
end;

procedure w3_setElementParentByName(aElement:THandle; aParentName: String);deprecated;
var
  mTemp: THandle;
begin
  mTemp := w3_getElementByName(aParentName);
  if VarIsValidRef(mTemp) then
  begin
    asm
      (@mTemp).appendChild(@aElement);
    end;
  end;
end;

procedure w3_setElementParentByRef(aElement:THandle;aParent:THandle);
begin
  if VarIsValidRef(aParent) then
  begin
    if VarIsValidRef(aElement) then
    aParent.appendChild(aElement) else
    raise Exception.Create('Failed to add element to parent, element is null');
  end;
end;

procedure w3_RemoveElementByRef(aElement$1:THandle;aParent$1:THandle);
begin
  //if varIsValidRef(aParent) then
  if (aParent$1) then
  begin
    asm
      (@aParent$1).removeChild(@aElement$1);
    end;
  end;
end;

function w3_createHtmlElement(aTypeName: String):THandle;
begin
  asm
    @Result = document.createElement(@aTypeName);
  end;
end;

function w3_getElementByName(aElementName: String):THandle;
begin
  asm
    @Result = document.getElementById(@aElementName);
  end;
end;



{ **************************************************************************** }
{ TInteger                                                                     }
{ **************************************************************************** }

class procedure TInteger.SetBit(index: Integer;aValue: Boolean;var buffer: Integer);
begin
  if (index>=0) and (index<=31) then
  begin
    if aValue then
    (* setbit *)
    buffer := ( buffer or (1 shl index) ) else

    (* clear bit *)
    buffer := ( buffer and not (1 shl index) );
  end else
  raise Exception.Create('Invalid bit index, expected 0..31');
end;

class function TInteger.GetBit(index: Integer;const buffer: Integer): Boolean;
begin
  if (index>=0) and (index<=31) then
    Result := (buffer and (1 shl index)) <> 0
  else
  raise Exception.Create('Invalid bit index, expected 0..31');
end;

class function TInteger.toPxStr(const aValue$12: Integer): String;
begin
  Result := IntToStr(aValue$12) + 'px';
end;

class function  TInteger.toHex(const aValue$11: Integer): String;
begin
  Result := IntToHex(aValue$11,16);
  if Length(Result)<2 then
  begin
    repeat
      Result := ('0' + Result);
    until Length(Result)>=2;
  end;
  Result := Copy(Result,Length(Result)-1,2);
end;

class procedure TInteger.Sort(var Domain:TIntArray);
var
  x:          Integer;
  FComplete:  Boolean;
begin
  if Length(Domain)>1 then
  begin
    repeat
      FComplete := True;
      for x := Low(Domain)+1 to High(Domain) do
      begin
        if Domain[x-1]>Domain[x] then
        begin
          Domain.swap(x-1,x);
          FComplete := False;
        end;
      end;
    until FComplete;
  end;
end;

class function TInteger.EnsureRange(const aValue$10, aMin,aMax: Integer): Integer;
begin
  Result:=ClampInt(aValue$10, aMin, aMax);
end;

class procedure TInteger.Swap(var Primary,Secondary: Integer);
var
  temp: Integer;
begin
  temp := Primary;
  Primary := Secondary;
  Secondary := temp;
end;

class function TInteger.WrapRange(const aValue$13,aLowRange,aHighRange: Integer): Integer;
begin
  if aValue$13>aHighRange then
  begin
    Result := aLowRange + Diff(aHighRange,(aValue$13-1));
    if Result>aHighRange then
    Result := WrapRange(Result,aLowRange,aHighRange);
  end else
  if aValue$13<aLowRange then
  begin
    Result := aHighRange - Diff(aLowRange,aValue$13+1);
    if Result<aLowRange then
    Result := WrapRange(Result,aLowRange,aHighRange);
  end else
  Result := aValue$13;
end;

class function TInteger.ToNearest(const Value,Factor: Integer): Integer;
var
  FTemp: Integer;
begin
  Result := Value;
  FTemp := Value mod Factor;
  if FTemp>0 then
    Inc(Result,Factor - FTemp);
end;

class function TInteger.ToNearestSigned(const Value,Factor: Integer): Integer;
begin
  Result := (1 + (Value - 1) div Factor) * Factor;
end;

class function TInteger.Diff(const Primary,Secondary: Integer): Integer;
begin
  if Primary<>Secondary then
  begin
    if Primary>Secondary then
    Result := Primary-Secondary else
    Result := Secondary-Primary;

    if Result<0 then
    Result := Result-1 xor -1;
  end else
  Result := 0;
end;

class function TInteger.Sign(const Value: Integer): Integer;
begin
  if Value<0 then
  Result := Value-1 xor -1 else
  Result := Value;
end;

class function TInteger.Middle(const Primary,Secondary: Integer): Integer;
begin
  Result := (Primary div 2) + (Secondary div 2);
end;

class function TInteger.PercentOfValue(const Value$3,Total$2: Integer): Integer;
begin
  if (Value$3<=Total$2) then
  Result := Trunc( (Value$3 / Total$2) * 100 ) else
  Result := 0;
end;

class function TInteger.Average(const anArray:TIntArray): Integer;
var
  x:      Integer;
  mCount: Integer;
  mTemp:  Integer;
begin
  mCount := Length(anArray);
  if mCount>1 then
  begin
    mTemp := 0;
    for x := Low(anArray) to High(anArray) do
      Inc(mTemp,anArray[x]);
    Result := Integer(mTemp div mCount);
  end else
  if mCount>0 then
  Result := anArray[0] else
  Result := 0;
end;

class function TInteger.Sum(const anArray:TIntArray): Integer;
var
  x:  Integer;
begin
  Result := 0;
  if Length(anArray)>0 then
  begin
    for x := Low(anArray) to High(anArray) do
      Inc(Result,anArray[x]);
  end;
end;

class function TInteger.Largest(const Primary,Secondary: Integer): Integer;
begin
  if Primary>Secondary then
    Result := Primary
  else Result := Secondary;
end;

class function TInteger.Largest(const anArray:TIntArray): Integer;
var
  x:  Integer;
begin
  Result := Length(anArray);
  if Result>0 then
  begin
    Result := 0;
    for x := Low(anArray) to High(anArray) do
      if anArray[x]>Result then
        Result := anArray[x];
  end;
end;

class function TInteger.Smallest(const Primary,Secondary: Integer): Integer;
begin
  if Primary<Secondary then
    Result := Primary
  else Result := Secondary;
end;

class function TInteger.Smallest(const anArray:TIntArray): Integer;
var
  x:  Integer;
begin
  if Length(anArray)>1 then
  begin
    Result := MAX_INT;
    for x := Low(anArray) to High(anArray) do
    begin
      if anArray[x]<Result then
        Result := anArray[x];
    end;
  end else
  if Length(anArray)=1 then
    Result := anArray[Low(anArray)]
  else Result := 0;
end;



{ **************************************************************************** }
{ TFloat                                                                       }
{ **************************************************************************** }

class function TFloat.PercentOfValue(const Value:Double;Total:Double):Double;
begin
  if (Value<=Total) then
    Result := ( (Value / Total) * 100 )
  else Result := 0;
end;



{ **************************************************************************** }
{ TVariant                                                                     }
{ **************************************************************************** }

class function  TVariant.AsInteger(const aValue$4:Variant): Integer;
begin
  if VarIsValidRef(aValue$4) then
  begin
    asm
      @Result = Number(@aValue$4);
    end;
  end else
  Result := 0;
end;

class function  TVariant.AsString(const aValue$6:Variant): String;
begin
  if VarIsValidRef(aValue$6) then
  begin
    asm
      @Result = String(@aValue$6);
    end;
  end else
  Result := '';
end;

class function  TVariant.AsFloat(const aValue$3:Variant):Float;
begin
  if VarIsValidRef(aValue$3) then
  begin
    asm
      @Result = parseFloat(@aValue$3);
    end;
  end else
  Result := 0.0;
end;

class function  TVariant.AsObject(const aValue$5:Variant):TObject;
begin
  if VarIsValidRef(aValue$5) then
  begin
    asm
      @Result = @aValue$5;
    end;
  end else
  Result := nil;
end;

class function  TVariant.AsBool(const aValue:Variant): Boolean;
begin
  if VarIsValidRef(aValue) then
  begin
    asm
      @Result = Boolean(@aValue);
    end;
  end;
end;

{$HINTS OFF}

class function TVariant.CreateObject:Variant;
begin
  asm
    @result = {};
  end;
end;

class function TVariant.CreateArray:Variant;
begin
  asm
    @result = [];
  end;
end;

class function TVariant.IsNull(const aValue:Variant): Boolean;
begin
  asm
    @Result=(@aValue == null);
  end;
end;

class function TVariant.IsString(const aValue$9:Variant): Boolean;
begin
  asm
    if (@aValue$9 == null) return false;
    if (@aValue$9 == undefined) return false;
    if (typeof(@aValue$9) === "string")
    return true;
  end;
end;

class function TVariant.IsNumber(const aValue$8:Variant): Boolean;
begin
  asm
    if (@aValue$8 == null) return false;
    if (@aValue$8 == undefined) return false;
    if (typeof(@aValue$8) === "number")
    return true;
  end;
end;

class function TVariant.IsInteger(const aValue:Variant): Boolean;
begin
  asm
    if (@aValue == null) return false;
    if (@aValue == undefined) return false;
    if (typeof(@aValue) === "number")
    if (parseInt(@aValue) === @aValue)
    return true;
  end;
end;

class function TVariant.IsBool(const aValue:Variant): Boolean;
begin
  asm
    if (@aValue == null) return false;
    if (@aValue == undefined) return false;
    if (typeof(@aValue) === "boolean")
    return true;
  end;
end;

class function TVariant.IsNAN(const aValue$7:Variant): Boolean;
begin
  asm
    return isNaN(@aValue$7);
  end;
end;

class function TVariant.Properties(const aValue: Variant): TStrArray;
begin
  var buf : Variant;
  asm
    for (@buf in @aValue) (@result).push(@buf);
  end;
end;

class function TVariant.OwnProperties(const aValue: Variant): TStrArray;
begin
  var buf : Variant;
  asm
    for (@buf in @aValue) if ((@aValue).hasOwnProperty(@buf)) (@result).push(@buf);
  end;
end;

{$HINTS ON}

{ **************************************************************************** }
{ EW3Exception                                                                 }
{ **************************************************************************** }

constructor EW3Exception.CreateFmt(aText$1: String;const aValues:array of const);
begin
  inherited Create(Format(aText$1,aValues));
end;

{ **************************************************************************** }
{ JSON                                                                         }
{ **************************************************************************** }

class function JSON.Parse(jsonData: String): Variant;
begin
   asm
      @Result = JSON.parse(@jsonData);
   end;
end;

class function JSON.Stringify(v: Variant): String;
begin
   asm
      @Result = JSON.stringify(v);
   end;
end;

end.
