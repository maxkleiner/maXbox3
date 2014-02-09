{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Graphics;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}
{ Resources: http://bit.ly/Jxauk5                                              }
{            http://bit.ly/i1ksiT                                              }
{------------------------------------------------------------------------------}

interface

uses
  W3System, w3c.DOM, w3c.Canvas2DContext;


const clNone                 = TColor($1FFFFFFF);
const clWhite                = TColor($FFFFFF);
const clAliceBlue            = TColor($F0F8FF);
const clAntiqueWhite         = TColor($FAEBD7);
const clAqua                 = TColor($00FFFF);
const clAquamarine           = TColor($7FFFD4);
const clAzure                = TColor($F0FFFF);
const clBeige                = TColor($F5F5DC);
const clBisque               = TColor($FFE4C4);
const clBlack                = TColor($000000);
const clBlanchedAlmond       = TColor($FFEBCD);
const clBlue                 = TColor($0000FF);
const clBlueViolet           = TColor($8A2BE2);
const clBrown                = TColor($A52A2A);
const clBurlyWood            = TColor($DEB887);
const clCadetBlue            = TColor($5F9EA0);
const clChartreuse           = TColor($7FFF00);
const clChocolate            = TColor($D2691E);
const clCoral                = TColor($FF7F50);
const clCornflowerBlue       = TColor($6495ED);
const clCornsilk             = TColor($FFF8DC);
const clCrimson              = TColor($DC143C);
const clCyan                 = TColor($00FFFF);
const clDarkBlue             = TColor($00008B);
const clDarkCyan             = TColor($008B8B);
const clDarkGoldenRod        = TColor($B8860B);
const clDarkGray             = TColor($A9A9A9);
const clDarkGrey             = TColor($A9A9A9);
const clDarkGreen            = TColor($006400);
const clDarkKhaki            = TColor($BDB76B);
const clDarkMagenta          = TColor($8B008B);
const clDarkOliveGreen       = TColor($556B2F);
const clDarkorange           = TColor($FF8C00);
const clDarkOrchid           = TColor($9932CC);
const clDarkRed              = TColor($8B0000);
const clDarkSalmon           = TColor($E9967A);
const clDarkSeaGreen         = TColor($8FBC8F);
const clDarkSlateBlue        = TColor($483D8B);
const clDarkSlateGray        = TColor($2F4F4F);
const clDarkSlateGrey        = TColor($2F4F4F);
const clDarkTurquoise        = TColor($00CED1);
const clDarkViolet           = TColor($9400D3);
const clDeepPink             = TColor($FF1493);
const clDeepSkyBlue          = TColor($00BFFF);
const clDimGray              = TColor($696969);
const clDimGrey              = TColor($696969);
const clDodgerBlue           = TColor($1E90FF);
const clFireBrick            = TColor($B22222);
const clFloralWhite          = TColor($FFFAF0);
const clForestGreen          = TColor($228B22);
const clFuchsia              = TColor($FF00FF);
const clGainsboro            = TColor($DCDCDC);
const clGhostWhite           = TColor($F8F8FF);
const clGold                 = TColor($FFD700);
const clGoldenRod            = TColor($DAA520);
const clGray                 = TColor($808080);
const clGrey                 = TColor($808080);
const clGreen                = TColor($008000);
const clGreenYellow          = TColor($ADFF2F);
const clHoneyDew             = TColor($F0FFF0);
const clHotPink              = TColor($FF69B4);
const clIndianRed            = TColor($CD5C5C);
const clIndigo               = TColor($4B0082);
const clIvory                = TColor($FFFFF0);
const clKhaki                = TColor($F0E68C);
const clLavender             = TColor($E6E6FA);
const clLavenderBlush        = TColor($FFF0F5);
const clLawnGreen            = TColor($7CFC00);
const clLemonChiffon         = TColor($FFFACD);
const clLightBlue            = TColor($ADD8E6);
const clLightCoral           = TColor($F08080);
const clLightCyan            = TColor($E0FFFF);
const clLightGoldenRodYellow = TColor($FAFAD2);
const clLightGray            = TColor($D3D3D3);
const clLightGrey            = TColor($D3D3D3);
const clLightGreen           = TColor($90EE90);
const clLightPink            = TColor($FFB6C1);
const clLightSalmon          = TColor($FFA07A);
const clLightSeaGreen        = TColor($20B2AA);
const clLightSkyBlue         = TColor($87CEFA);
const clLightSlateGray       = TColor($778899);
const clLightSlateGrey       = TColor($778899);
const clLightSteelBlue       = TColor($B0C4DE);
const clLightYellow          = TColor($FFFFE0);
const clLime                 = TColor($00FF00);
const clLimeGreen            = TColor($32CD32);
const clLinen                = TColor($FAF0E6);
const clMagenta              = TColor($FF00FF);
const clMaroon               = TColor($800000);
const clMediumAquaMarine     = TColor($66CDAA);
const clMediumBlue           = TColor($0000CD);
const clMediumOrchid         = TColor($BA55D3);
const clMediumPurple         = TColor($9370D8);
const clMediumSeaGreen       = TColor($3CB371);
const clMediumSlateBlue      = TColor($7B68EE);
const clMediumSpringGreen    = TColor($00FA9A);
const clMediumTurquoise      = TColor($48D1CC);
const clMediumVioletRed      = TColor($C71585);
const clMidnightBlue         = TColor($191970);
const clMintCream            = TColor($F5FFFA);
const clMistyRose            = TColor($FFE4E1);
const clMoccasin             = TColor($FFE4B5);
const clNavajoWhite          = TColor($FFDEAD);
const clNavy                 = TColor($000080);
const clOldLace              = TColor($FDF5E6);
const clOlive                = TColor($808000);
const clOliveDrab            = TColor($6B8E23);
const clOrange               = TColor($FFA500);
const clOrangeRed            = TColor($FF4500);
const clOrchid               = TColor($DA70D6);
const clPaleGoldenRod        = TColor($EEE8AA);
const clPaleGreen            = TColor($98FB98);
const clPaleTurquoise        = TColor($AFEEEE);
const clPaleVioletRed        = TColor($D87093);
const clPapayaWhip           = TColor($FFEFD5);
const clPeachPuff            = TColor($FFDAB9);
const clPeru                 = TColor($CD853F);
const clPink                 = TColor($FFC0CB);
const clPlum                 = TColor($DDA0DD);
const clPowderBlue           = TColor($B0E0E6);
const clPurple               = TColor($800080);
const clRed                  = TColor($FF0000);
const clRosyBrown            = TColor($BC8F8F);
const clRoyalBlue            = TColor($4169E1);
const clSaddleBrown          = TColor($8B4513);
const clSalmon               = TColor($FA8072);
const clSandyBrown           = TColor($F4A460);
const clSeaGreen             = TColor($2E8B57);
const clSeaShell             = TColor($FFF5EE);
const clSienna               = TColor($A0522D);
const clSilver               = TColor($C0C0C0);
const clSkyBlue              = TColor($87CEEB);
const clSlateBlue            = TColor($6A5ACD);
const clSlateGray            = TColor($708090);
const clSlateGrey            = TColor($708090);
const clSnow                 = TColor($FFFAFA);
const clSpringGreen          = TColor($00FF7F);
const clSteelBlue            = TColor($4682B4);
const clTan                  = TColor($D2B48C);
const clTeal                 = TColor($008080);
const clThistle              = TColor($D8BFD8);
const clTomato               = TColor($FF6347);
const clTurquoise            = TColor($40E0D0);
const clViolet               = TColor($EE82EE);
const clWheat                = TColor($F5DEB3);
const clWhiteSmoke           = TColor($F5F5F5);
const clYellow               = TColor($FFFF00);
const clYellowGreen          = TColor($9ACD32);



type
  TW3Canvas = class;

  (* The basic graphics context ancestor *)
  TW3CustomGraphicContext = class(TObject)
  protected
    function GetDC: THandle; virtual; abstract;
    function GetHandle: THandle; virtual; abstract;
    function GetWidth$1: Integer; virtual; abstract;
    function GetHeight$1: Integer; virtual; abstract;
    function getOwnsReference: Boolean; virtual; abstract;
    procedure SetSize$1(aNewWidth, aNewHeight: Integer); virtual; abstract;
    procedure ReleaseDC; virtual; abstract;
  public
    (* <CANVAS> Tag handle *)
    property Handle: THandle read GetHandle;
    (* Handle to 2D graphics-context *)
    property DC: THandle read GetDC;
    property OwnsDC: Boolean read getOwnsReference;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    procedure Allocate(const aWidth$2, aHeight$2: Integer); virtual;
    procedure Release; virtual;
    function BackingStorePixelRatio : Float;
  end;

  (* This version is a basic wrapper for an already existing canvas tag.
    It allows you to access the context of a "known" canvas tag. if you have
    a reference to a canvas tag, then simply point this class to the handle. *)
  TW3ControlGraphicContext = class(TW3CustomGraphicContext)
  private
    FCtrlTag: THandle;
  protected
    function GetHandle: THandle; override;
    function GetDC: THandle; override;
    function GetWidth$1: Integer; override;
    function GetHeight$1: Integer; override;
    function getOwnsReference: Boolean; override;
    procedure SetSize$1(aNewWidth$1, aNewHeight$1: Integer); override;
    procedure ReleaseDC; override;
  public
    constructor Create$30(const aControlHandle: THandle); virtual;
  end;

  (* This version is a wrapper for an already existing graphics context.
    It can be used to hooking into the CSS background canvas (webkit only)
    of any HTML element. Please see: -webkit-canvas @ #2 *)
  TW3BackgroundGraphicContext = class(TW3CustomGraphicContext)
  private
    FName: String;
    FContext: THandle;
    FWidth: Integer;
    FHeight: Integer;
  protected
    function getHandle: THandle; override;
    function getDC: THandle; override;
    function getWidth: Integer; override;
    function getHeight: Integer; override;
    function getOwnsReference: Boolean; override;
    procedure SetSize(aNewWidth, aNewHeight: Integer); override;
    procedure ReleaseDC; override;
  public
    constructor Create(aName: String; aWidth: Integer; aHeight: Integer); virtual;

    class function IsSupported : Boolean; static;

    property CSSName: String read FName;
  end;

  TW3GraphicContext = class(TW3CustomGraphicContext)
  private
    FObjRef: THandle;
    FOwner$2: THandle;
    FObjId: String;
  protected
    function GetDC: THandle; override;
    function GetHandle: THandle; override;
    function GetWidth$1: Integer; override;
    function GetHeight$1: Integer; override;
    procedure SetSize$1(aNewWidth, aNewHeight: Integer); override;
    procedure ReleaseDC; override;
    function getOwnsReference: Boolean; override;
  public
    property Owner: THandle read FOwner;
    property Id: String read FObjId;
    constructor Create$29(const AOwner$3: THandle); virtual;
    destructor Destroy; override;
  end;

  TW3TextMetrics = record
    Width: Float;
  end;

  TW3CanvasGradient = class(TObject)
  private
    FHandle$3: THandle;
  public
    property Handle: THandle read FHandle;
    procedure AddColorStop(const offset: Float; const aColor: String); overload;
    procedure AddColorStop(const offset: Float; const aColor: TColor); overload;
    procedure AddColorStop(const offset: Float; const R, G, B: Integer); overload;
    procedure AddColorStop(const offset: Float; const R, G, B, A: Integer); overload;
    constructor Create$31(const aHandle: THandle);
  end;

  TW3CanvasPattern = class
  private
    FHandle: THandle;
  public
    property Handle: THandle read FHandle write FHandle;
  end;

  TW3ImageData = class(TObject)
  private
    FHandle$1: ImageData;
    function getWidth: Integer;
    function getHeight: Integer;
    function  getR(x, y: Integer): Integer;
    procedure setR(x, y: Integer; aValue: Integer);
    function  getG(x, y: Integer): Integer;
    procedure setG(x, y: Integer; aValue: Integer);
    function  getB(x, y: Integer): Integer;
    procedure setB(x, y: Integer; aValue: Integer);
    function  getA(x, y: Integer): Integer;
    procedure setA(x, y: Integer; aValue: Integer);
    function  getColor(const x, y: Integer): TColor;
    procedure setColor(const x, y: Integer; const aValue: TColor);
  public
    property Handle: ImageData read FHandle;
    property Width: Integer read getWidth;
    property Height: Integer read getHeight;
    property R[x, y: Integer]: Integer read getR write setR;
    property G[x, y: Integer]: Integer read getG write setG;
    property B[x, y: Integer]: Integer read getB write setB;
    property A[x, y: Integer]: Integer read getA write setA;
    property Colors[const x, y: Integer]: TColor read getColor write setColor;
    procedure setPixelC(x, y: Integer; aColor: TColor);
    procedure setPixel(x, y: Integer; aValue: TW3RGBATW3RGBA);
    procedure setPixelEx(x, y: Integer; R, G, B, A: Integer);
    function  getPixel(x, y: Integer): TW3RGBA;
    procedure getPixelEx(x, y: Integer; var R, G, B, A: Integer);
    procedure fromContextNew(const aContextRef: THandle; const aWidth, aHeight: Integer);
    procedure fromImageData(aImageDataRef: ImageDataImageData);
    function  toDataUrl: String;
  end;

  TW3DashList = array of Float;

  TW3Canvas = class(TObject)
  private
    FContext: TW3CustomGraphicContext;
    FDC: CanvasRenderingContext2D;
    function  getFillStyle: String;
    procedure setFillStyle(aValue$57: String);
    function  getLineCap: String;
    procedure setLineCap(aValue: String);
    function  getLineJoin: String;
    procedure setLineJoin(aValue: String);
    function  getLineWidth: Float;
    procedure setLineWidth(aValue: Float);
    function  GetLineDash : TW3DashList;
    procedure SetLineDash(aValue : TW3DashList);
    function  GetLineDashOffset : Float;
    procedure SetLineDashOffset(aValue : Float);
    function  getMiterLimit: Float;
    procedure setMiterLimit(aValue: Float);
    function  getStrokeStyle: String;
    procedure setStrokeStyle(aValue$59: String);
    function  getTextAlign: String;
    procedure setTextAlign(aValue: String);
    function  getTextBaseline: String;
    procedure setTextbaseLine(aValue: String);
    function  getGlobalAlpha: Float;
    procedure setGlobalAlpha(aValue$58: Float);
    function  getGlobalCompOp: String;
    procedure setGlobalCompOp(aValue: String);
    function  getShadowBlur: Float;
    procedure setShadowBlur(aValue: Float);
    function  getShadowColor: String;
    procedure setShadowColor(aValue: String);
    function  getshadowX: Float;
    procedure setShadowX(aValue: Float);
    function  getshadowY: Float;
    procedure setShadowY(aValue: Float);
    function  getFont: String;
    procedure setFont(aValue: String);

  public
    property Handle: CanvasRenderingContext2D read FDC;
    property Context: TW3CustomGraphicContext read FContext;

    procedure Save; virtual;
    procedure Restore; virtual;
    procedure Clear;
    procedure ClearRectF(aLeft, aTop, aWidth, aHeight: Float);
    procedure FillRectF(const aRect: TRectTRect); overload;
    procedure FillRectF(const aRect: TRectFTRectF); overload;
    procedure FillRectF$2(aLeft$4, aTop$4, aWidth$3, aHeight$3: Float); overload;
    procedure FillBounds(aLeft, aTop, aRight, aBottom: Float);
    procedure RectangleF(aLeft, aTop, aWidth, aHeight: Float);
    procedure StrokeRectF(const aRect: TRectFTRectF); overload;
    procedure StrokeRectF(aLeft, aTop, aWidth, aHeight: Float); overload;
    procedure ClearRect(const aRect: TRectTRect);
    procedure FillRect(const aRect: TRectTRect); overload;
    procedure FillRect(aLeft, aTop, aWidth, aHeight: Integer); overload;
    procedure Rectangle(const aRect: TRectTRect);
    procedure StrokeRect(const aRect: TRectTRect);
    procedure ArcF(x, y, radius, startAngle, endAngle: Float; anticlockwise: Boolean);
    procedure ArcToF(x1, y1, x2, y2, radius: Float);
    procedure BeginPath;
    procedure ClosePath;
    procedure BezierCurveToF(cp1x, cp1y, cp2x, cp2y, x, y: Float);
    procedure Clip;
    procedure ResetClip;
    function  IsPointInPathF(x, y: Float): Boolean; overload;
    function  IsPointInPathF(const p : TPointFTPointF): Boolean; overload;

    procedure LineToF(x$14, y$7: Float); overload;
    procedure LineTo(const aPoint : TPointFTPointF); overload;
    procedure MoveToF(x$15, y$8: Float); overload;
    procedure MoveTo(const aPoint : TPointFTPointF); overload;
    procedure LineF(x1, y1, x2, y2: Float);

    procedure HorzLine(x1, y, x2 : Float);
    procedure VertLine(x, y1, y2 : Float);

    procedure Ellipse(x1, y1, x2, y2 : Float); overload;
    procedure Ellipse(const aRect : TRectFTRectF); overload;

    procedure QuadraticCurveToF(cpx, cpy, x, y: Float);
    procedure Fill;
    procedure Stroke;
    procedure DrawImageF(imageHandle: THandle; x$13, y$6: Float); overload;
    procedure DrawImageF(imageHandle: THandle; x, y: Float; ow, oh: Float); overload;
    procedure DrawImageF(imageHandle: THandle; sx, sy, sw, sh, dx, dy, dw, dh: Float); overload;
    procedure DrawImage(image: ElementElement; x, y: Float); overload;
    procedure DrawImage(image: ElementElement; x, y: Float; ow, oh: Float); overload;
    procedure DrawImage(image: ElementElement; sx, sy, sw, sh, dx, dy, dw, dh: Float); overload;

    procedure FillTextF(text: String; x, y, maxWidth: Float);
    procedure FillText(text: String; x, y, maxWidth: Float); overload;
    procedure FillText(text: String; x, y : Float); overload;
    function  MeasureText(aText: String): TW3TextMetrics;
    procedure StrokeTextF(text: String; x, y, maxWidth: Float); overload;
    procedure StrokeTextF(text: String; x, y: Float); overload;

    procedure Rotate(angleRad: Float);
    procedure Scale(sx, sy: Float);
    procedure Transform(m11, m12, m21, m22, dx, dy: Float);
    procedure Translate(tx, ty: Float); overload;
    procedure Translate(const pt : TPointFTPointF); overload;

    function CreateLinearGradientF(x0, y0, x1, y1: Float): TW3CanvasGradient;
    function CreateVerticalGradient(y0, y1: Float): TW3CanvasGradient;
    function CreateHorizontalGradient(x0, x1: Float): TW3CanvasGradient;
    function CreateRadialGradientF(x0, y0, r0, x1, y1, r1: Float): TW3CanvasGradient;
    procedure UseGradient(aGradient: TW3CanvasGradientTW3CanvasGradient);

    function CreatePattern(image: THandle; aRepeat: String) : TW3CanvasPattern;
    procedure UsePattern(aPattern: TW3CanvasPatternTW3CanvasPattern);

    function CreateImageData(sw, sh: Float): TW3ImageData; overload;
    function CreateImageData(reference: TW3ImageDataTW3ImageData): TW3ImageData; overload;
    function GetImageData(sx, sy, sw, sh: Float): TW3ImageData;
    function ToImageData: TW3ImageData;
    function ToDataURL(aMimeType: String): String;
    procedure PutImageData(imageData: TW3ImageDataTW3ImageData; x, y: Float); overload;
    procedure PutImageData(imageData: TW3ImageDataTW3ImageData; x, y, dx, dy, dw, dh: Float); overload;
    procedure SetPixel(x, y: Integer);

    Procedure DrawTo(target : TW3CanvasTW3Canvas;
              Const dstX,dstY:Integer);overload;

    Procedure DrawTo(target : TW3CanvasTW3Canvas;
              const dstX,dstY:Integer;
              const rotation:Integer);overload;

    Procedure DrawTo(target : TW3CanvasTW3Canvas;
              const dstX,dstY:Integer;
              const rotation:Integer;
              const alpha:Integer);overload;

    Procedure DrawPart(target : TW3CanvasTW3Canvas;
              Const srcX,srcY:Integer;
              Const srcWidth,srcHeight:Integer;
              const dstX,dstY:Integer);overload;

    Procedure DrawPart(target : TW3CanvasTW3Canvas;
              const srcX,srcY:Integer;
              const srcWidth,srcHeight:Integer;
              const dstX,dstY:Integer;
              Const rotation:Integer);overload;

    Procedure DrawPart(target : TW3CanvasTW3Canvas;
              const srcX,srcY:Integer;
              const srcWidth,srcHeight:Integer;
              const dstX,dstY:Integer;
              Const rotation:Integer;
              const alpha:Integer);overload;

    Procedure DrawTile(target : TW3CanvasTW3Canvas;
              Const TileID:Integer;
              const TileSize:Integer;
              const dstX,dstY:Integer);overload;

    Procedure DrawTile(target : TW3CanvasTW3Canvas;
              Const TileID:Integer;
              const TileSize:Integer;
              const dstX,dstY:Integer;
              const rotation:Integer);overload;

    Procedure DrawTile(target : TW3CanvasTW3Canvas;
              const TileID:Integer;
              const TileSize:Integer;
              const dstX,dstY:Integer;
              const rotation:Integer;
              const alpha:Integer);overload;

    procedure ClearShadow; // webkit only

    property ShadowBlur: Float read getShadowBlur write setShadowBlur;
    property ShadowColor: String read getShadowColor write setShadowColor;
    property ShadowOffsetX: Float read getshadowX write setShadowX;
    property ShadowOffsetY: Float read getshadowY write setShadowY;
    property Font: String read getFont write setFont;
    property GlobalCompositeOperation : String read getGlobalCompOp write setGlobalCompOp;
    property GlobalAlpha: Float read getGlobalAlpha write setGlobalAlpha;
    property TextBaseLine: String read getTextBaseline write setTextbaseLine;
    property TextAlign: String read getTextAlign write setTextAlign;
    property StrokeStyle: String read getStrokeStyle write setStrokeStyle;
    property FillStyle: String read getFillStyle write setFillStyle;
    property LineCap: String read getLineCap write setLineCap;
    property LineJoin: String read getLineJoin write setLineJoin;
    property LineWidth: Float read getLineWidth write setLineWidth;
    property LineDash: TW3DashList read GetLineDash write SetLineDash;
    property LineDashOffset: Float read GetLineDashOffset write SetLineDashOffset;
    property MiterLimit: Float read getMiterLimit write setMiterLimit;

    constructor Create$32(Context$2: TW3CustomGraphicContextTW3CustomGraphicContext); virtual;
  end;

function GetStrideAlign(const Value, ElementSize: Integer; AlignSize: Integer): Integer;



implementation



function GetStrideAlign(const Value,ElementSize: Integer; AlignSize: Integer): Integer;
begin
  Result := Value * ElementSize;
  if (Result mod AlignSize)>0 then
    Result := ( (Result + AlignSize) - (Result mod AlignSize) );
end;


{ **************************************************************************** }
{  TW3ImageData                                                                }
{ **************************************************************************** }

function TW3ImageData.toDataUrl: String;
var
  mContext: TW3GraphicContext;
  mCanvas:  TW3Canvas;
begin
  mContext := TW3GraphicContext.Create$29(Null);
  try
    mContext.Allocate(getWidth,getHeight);
    mCanvas := TW3Canvas.Create$32(mContext);
    try
      mCanvas.PutImageData(Self,0,0);
      Result := mCanvas.ToDataURL('image/png');
      WriteLn(Result);
    finally
      mCanvas.Free;
    end;
  finally
    mContext.Free;
  end;
end;

procedure TW3ImageData.fromContextNew(const aContextRef: THandle; const aWidth, aHeight: Integer);
const
  CNT_ERR_STD = 'Failed to initialize from graphics-context: ';
var
  mRef: ImageData;
begin
  if (aContextRef) then
  //if varisValidRef(aContextRef) then
  begin
    if (aWidth>0) and (aHeight>0) then
    begin

      try
        mRef := ImageData(aContextRef.createImageData(aWidth, aHeight));
      except
        on e: Exception do
        raise Exception.Create(CNT_ERR_STD + 'createImageData() failed with "' + e.Message + '"');
      end;

      FHandle := mRef;
    end else
    raise Exception.Create(CNT_ERR_STD + 'invalid width or height error');
  end else
  raise Exception.Create(CNT_ERR_STD + 'reference was NIL error');
end;

procedure TW3ImageData.fromImageData(aImageDataRef: ImageDataImageData);
const
  CNT_ERR_STD = 'Failed to initialize from graphics-context: ';
begin
   Assert(Assigned(aImageDataRef), CNT_ERR_STD + 'reference was NIL error');
   FHandle$1 := aImageDataRef;
end;

function TW3ImageData.getWidth: Integer;
begin
  Result := FHandle.width;
end;

function TW3ImageData.getHeight: Integer;
begin
  Result := FHandle.height;
end;

procedure TW3ImageData.setPixelC(x,y: Integer;aColor:TColor);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex    ] := (aColor shr 16) and $FF;
  FHandle.data[mIndex + 1] := (aColor shr 8) and $FF;
  FHandle.data[mIndex + 2] := (aColor shr 0) and $FF;
  FHandle.data[mIndex + 3] := 255;
end;

procedure TW3ImageData.setPixel(x,y: Integer;aValue: TW3RGBATW3RGBA);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex    ] := aValue.R;
  FHandle.data[mIndex + 1] := aValue.G;
  FHandle.data[mIndex + 2] := aValue.B;
  FHandle.data[mIndex + 3] := aValue.A$1;
end;

procedure TW3ImageData.setPixelEx(x,y: Integer;R,G,B,A: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex    ] := R;
  FHandle.data[mIndex + 1] := G;
  FHandle.data[mIndex + 2] := B;
  FHandle.data[mIndex + 3] := A;
end;

function TW3ImageData.getPixel(x,y: Integer): TW3RGBA;
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  Result.R := FHandle.data[mIndex    ];
  Result.G := FHandle.data[mIndex + 1];
  Result.B := FHandle.data[mIndex + 2];
  Result.A$1 := FHandle.data[mIndex + 3];
end;

procedure TW3ImageData.getPixelEx(x,y: Integer;var R,G,B,A: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  R := FHandle.data[mIndex   ];
  G := FHandle.data[mIndex + 1];
  B := FHandle.data[mIndex + 2];
  A := FHandle.data[mIndex + 3];
end;

function TW3ImageData.getR(x,y: Integer): Integer;
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  Result := FHandle.data[mIndex];
end;

procedure TW3ImageData.setR(x,y: Integer;aValue: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex] := aValue;
end;

function TW3ImageData.getG(x,y: Integer): Integer;
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  Result := FHandle.data[mIndex+1];
end;

procedure TW3ImageData.setG(x,y: Integer;aValue: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex+1] := aValue;
end;

function TW3ImageData.getB(x,y: Integer): Integer;
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  Result := FHandle.data[mIndex+2];
end;

procedure TW3ImageData.setB(x,y: Integer;aValue: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex+2] := aValue;
end;

function TW3ImageData.getA(x,y: Integer): Integer;
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  Result := FHandle.data[mIndex+3];
end;

function TW3ImageData.getColor(const X,Y: Integer):TColor;
var
  mIndex: Integer;
begin
  if  (x>=0) and (x<FHandle.width)
  and (y>=0) and (y<FHandle.height) then
  begin
    mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
    Result := W3System.RGBToColor
    ( FHandle.data[mIndex    ],
      FHandle.data[mIndex + 1],
      FHandle.data[mIndex + 2]);
  end else
  Result := clNone;
end;

procedure TW3ImageData.setColor(const X,Y: Integer;const aValue:TColor);
var
  mIndex: Integer;
begin
  if  (x>=0) and (x<FHandle.width)
  and (y>=0) and (y<FHandle.height) then
  begin
    mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
    FHandle.data[mIndex    ] := (aValue shr 16) and $FF;
    FHandle.data[mIndex + 1] := (aValue shr 8) and $FF;
    FHandle.data[mIndex + 2] := (aValue shr 0) and $FF;
    FHandle.data[mIndex + 3] := 255;
  end;
end;

procedure TW3ImageData.setA(x,y: Integer;aValue: Integer);
var
  mIndex: Integer;
begin
  mIndex := ( ( FHandle.width * 4 ) * y ) + (x * 4);
  FHandle.data[mIndex+3] := aValue;
end;



{ **************************************************************************** }
{  TW3CanvasGradient                                                           }
{ **************************************************************************** }

constructor TW3CanvasGradient.Create$31(const aHandle:THandle);
begin
  inherited Create;
  FHandle$3 := aHandle;
end;

procedure TW3CanvasGradient.AddColorStop(const offset:Float; const aColor: String);
begin
  FHandle.addColorStop(offset, aColor);
end;

procedure TW3CanvasGradient.AddColorStop(const offset:Float; const aColor:TColor);
begin
  FHandle.addColorStop(offset,ColorToWebStr(aColor));
end;

procedure TW3CanvasGradient.AddColorStop(const offset:Float; const R,G,B: Integer);
begin
  FHandle.addColorStop(offset,ColorToWebStr(RGBToColor(R,G,B)));
end;

procedure TW3CanvasGradient.AddColorStop(const offset:Float; const R,G,B,A: Integer);
begin
  FHandle.addColorStop(offset,ColorToStrA(RGBToColor(R,G,B),A));
end;



{ **************************************************************************** }
{  TW3BackgroundGraphicContext                                                 }
{ **************************************************************************** }

constructor TW3BackgroundGraphicContext.Create(aName: String; aWidth: Integer;aHeight: Integer);
begin
  inherited Create;

  {Check name}
  aName := Trim$_String_(aName);
  if Length(aName)>0 then
  begin
    {Check bounds}
    if (aWidth>0) and (aHeight>0) then
    begin
      FName := aName;
      SetSize(aWidth,aHeight);
    end else
    raise EW3Exception.Create('Background-canvas size must be positive');
  end else
  raise EW3Exception.Create('Background-canvas name cannot be empty');
end;

class function TW3BackgroundGraphicContext.IsSupported : Boolean;
begin
   asm
      if (document.getCSSCanvasContext) @Result=true; else @Result=false;
   end;
end;

function TW3BackgroundGraphicContext.getDC:THandle;
begin
  Result := FContext;
end;

function TW3BackgroundGraphicContext.getWidth: Integer;
begin
  Result := FWidth;
end;

function TW3BackgroundGraphicContext.getHeight: Integer;
begin
  Result := FHeight;
end;

function TW3BackgroundGraphicContext.getOwnsReference: Boolean;
begin
  Result := true;
end;

procedure TW3BackgroundGraphicContext.SetSize(aNewWidth,aNewHeight: Integer);
var
  mRef:   THandle;
  mName:  String;
begin
  if (aNewWidth<>FWidth) or (aNewHeight<>FHeight) then
  begin

    if (aNewWidth>0) and (aNewHeight>0) then
    begin
      {Hook into the background context}
      mName := FName;
      try
        asm
        @mRef=document.getCSSCanvasContext("2d",@mName,@aNewWidth,@aNewHeight);
        end;

        //if not varisValidRef(mRef) then
        if not (mRef) then
        raise Exception.Create('Failed to hook CSS canvas');

        FContext := mRef;
        FWidth := aNewWidth;
        FHeight := aNewHeight;
      except
        on e: Exception do
        raise EW3Exception.CreateFmt('Background-canvas resize failed: %s',[e.Message]);
      end;
    end else
    raise EW3Exception.Create('Background-canvas size must be positive');
  end;
end;

function TW3BackgroundGraphicContext.getHandle:THandle;
begin
  Result := Null;
end;

procedure TW3BackgroundGraphicContext.ReleaseDC;
begin
  FContext := Null;
  FWidth := 0;
  FHeight := 0;
end;



{ **************************************************************************** }
{  TW3ControlGraphicContext                                                    }
{ **************************************************************************** }

constructor TW3ControlGraphicContext.Create$30(const aControlHandle:THandle);
begin
  inherited Create;
  //if varisValidRef(aControlHandle) then
  if (aControlHandle) then
  FCtrlTag := aControlHandle else
  raise Exception.Create('Control handle is invalid error');
end;

function TW3ControlGraphicContext.GetDC:THandle;
begin
  Result := FCtrlTag.getContext('2d');
end;

function TW3ControlGraphicContext.GetHandle:THandle;
begin
  Result := FCtrlTag;
end;

function TW3ControlGraphicContext.GetWidth$1: Integer;
begin
  Result := w3_getPropertyAsInt(FCtrlTag,'width');
end;

function TW3ControlGraphicContext.GetHeight$1: Integer;
begin
  Result := w3_getPropertyAsInt(FCtrlTag,'height');
end;

function TW3ControlGraphicContext.getOwnsReference: Boolean;
begin
  Result := False;
end;

procedure TW3ControlGraphicContext.SetSize$1(aNewWidth$1,aNewHeight$1: Integer);
begin
//
end;

procedure TW3ControlGraphicContext.ReleaseDC;
begin
//
end;

{ **************************************************************************** }
{  TW3CustomGraphicContext                                                     }
{ **************************************************************************** }

procedure TW3CustomGraphicContext.Allocate(const aWidth$2,aHeight$2: Integer);
begin
  if getOwnsReference then
  begin
    if VarIsValidRef(GetDC) then
       Release;
    SetSize$1(aWidth$2,aHeight$2);
  end else
  raise Exception.Create('Cannot modify current graphics context');
end;

procedure TW3CustomGraphicContext.Release;
begin
  if getOwnsReference then
  begin
    if VarIsValidRef(GetDC) then
    ReleaseDC;
  end else
  raise Exception.Create('Cannot modify current graphics context');
end;

function TW3CustomGraphicContext.BackingStorePixelRatio : Float;
begin
  var dc := GetDC;
  asm
     @result = (@dc).webkitBackingStorePixelRatio ||
                (@dc).mozBackingStorePixelRatio ||
                (@dc).msBackingStorePixelRatio ||
                (@dc).oBackingStorePixelRatio ||
                (@dc).backingStorePixelRatio || 1
  end;
end;


{ **************************************************************************** }
{  TW3GraphicContext                                                           }
{ **************************************************************************** }

constructor TW3GraphicContext.Create$29(const AOwner$3:THandle);
begin
  inherited Create;

  {Create our HTML canvas}
  FObjRef := w3_createHtmlElement('canvas');

  {Create a unique ID for our object}
  FObjId := w3_getUniqueObjId;
  FObjRef.id := FObjId;

  {Keep owner}
  FOwner$2 := AOwner$3;

  {Got an owner? Inject it}
  //if varIsValidRef(FOwner) then
  if (FOwner$2) then
  w3_setElementParentByRef(FObjRef,FOwner$2);
end;

destructor TW3GraphicContext.Destroy;
begin
  {Remove from parent}
  //if varIsValidRef(FOwner) then
  if (FOwner$2) then
  w3_RemoveElementByRef(FObjRef,FOwner$2);

  FOwner$2 := Null;
  FObjRef := Null;

  inherited;
end;

function TW3GraphicContext.GetHandle:THandle;
begin
  Result := FObjRef;
end;

function TW3GraphicContext.getOwnsReference: Boolean;
begin
  Result := True;
end;

function TW3GraphicContext.GetDC:THandle;
begin
  //if varIsValidRef(FObjRef) then
  if (FObjRef) then
  Result := FObjRef.getContext('2d') else
  Result := Null;
end;

procedure TW3GraphicContext.SetSize$1(aNewWidth,aNewHeight: Integer);
begin
  //if varIsValidRef(FObjRef) then
  if (FObjRef) then
  begin
    FObjRef.width := aNewWidth;
    FObjRef.height := aNewHeight;
  end;
end;

function TW3GraphicContext.GetWidth$1: Integer;
begin
  //if varIsValidRef(FObjRef) then
  if (FObjRef) then
  Result := FObjRef.width else
  Result := 0;
end;

function TW3GraphicContext.GetHeight$1: Integer;
begin
  if (FObjRef) then
  //if varIsValidRef(FObjRef) then
  Result := FObjRef.height else
  Result := 0;
end;

procedure TW3GraphicContext.ReleaseDC;
begin
  //if varIsValidRef(FObjRef) then
  if (FObjRef) then
  begin
    FObjRef.width := 0;
    FObjRef.height := 0;
  end;
end;

{ **************************************************************************** }
{  TW3Canvas                                                                   }
{ **************************************************************************** }

constructor TW3Canvas.Create$32(Context$2: TW3CustomGraphicContextTW3CustomGraphicContext);
begin
  inherited Create;
  //writeln(context);
  FContext := Context$2;
  if not Assigned(FContext) then
     raise Exception.Create('Invalid canvas context error')
  else FDC := CanvasRenderingContext2D(FContext.DC);
end;

Procedure TW3Canvas.DrawTo(target:TW3CanvasTW3Canvas;
          Const dstX,dstY:Integer);
Begin
  if target<>NIL then
  target.Handle.drawImage(Element(FContext.Handle),dstX,dstY);
end;

Procedure TW3Canvas.DrawTo(target:TW3CanvasTW3Canvas;
          const dstX,dstY:Integer;
          const rotation:Integer);
Begin
  if target<>NIL then
  Begin
    target.Handle.translate(dstX,dstY);
    target.Handle.rotate(DegToRad(rotation));
    target.Handle.drawImage(Element(FContext.Handle),0,0);
    target.Handle.setTransform(1, 0, 0, 1, 0, 0);
  end;
end;

Procedure TW3Canvas.DrawTo(target:TW3CanvasTW3Canvas;
          const dstX,dstY:Integer;
          const rotation:Integer;
          const alpha:Integer);
var
  mAlpha: Float;
Begin
  if target<>NIL then
  Begin
    mAlpha:=target.Handle.globalAlpha;
    target.GlobalAlpha:=(1 / 255) * alpha;
    target.Handle.translate(dstX,dstY);
    target.Handle.rotate(DegToRad(rotation));
    target.Handle.drawImage(Element(FContext.Handle),0,0);
    target.Handle.setTransform(1, 0, 0, 1, 0, 0);
    target.GlobalAlpha:=mAlpha;
  end;
end;

Procedure TW3Canvas.DrawPart(target:TW3CanvasTW3Canvas;
          Const srcX,srcY:Integer;
          Const srcWidth,srcHeight:Integer;
          const dstX,dstY:Integer);
Begin
  if target<>NIL then
  Begin
    target.Handle.translate(dstX,dstY);
    target.Handle.drawImage(Element(FContext.Handle),srcX,srcY,
    srcWidth,srcHeight,0,0,srcWidth,srcHeight);
    target.Handle.setTransform(1, 0, 0, 1, 0, 0);
  end;
end;

Procedure TW3Canvas.DrawPart(target:TW3CanvasTW3Canvas;
          const srcX,srcY:Integer;
          const srcWidth,srcHeight:Integer;
          const dstX,dstY:Integer;
          Const rotation:Integer);
Begin
  if target<>NIL then
  Begin
    target.Handle.translate(dstX,dstY);
    target.Handle.rotate(DegToRad(rotation));
    target.Handle.drawImage(Element(FContext.Handle),srcX,srcY,
    srcWidth,srcHeight,0,0,srcWidth,srcHeight);
    target.Handle.setTransform(1, 0, 0, 1, 0, 0);
  end;
end;

Procedure TW3Canvas.DrawPart(target:TW3CanvasTW3Canvas;
          const srcX,srcY:Integer;
          const srcWidth,srcHeight:Integer;
          const dstX,dstY:Integer;
          Const rotation:Integer;
          const alpha:Integer);
var
  mAlpha: Float;
Begin
  if target<>NIL then
  Begin
    mAlpha:=target.GlobalAlpha;
    target.GlobalAlpha:=(1 / 255) * alpha;
    target.Handle.translate(dstX,dstY);
    target.Handle.rotate(DegToRad(rotation));
    target.Handle.drawImage(Element(FContext.Handle),srcX,srcY,
                            srcWidth,srcHeight,0,0,srcWidth,srcHeight);
    target.Handle.setTransform(1, 0, 0, 1, 0, 0);
    target.GlobalAlpha:=mAlpha;
  end;
end;

Procedure TW3Canvas.DrawTile(target:TW3CanvasTW3Canvas;
          Const TileID:Integer;
          const TileSize:Integer;
          const dstX,dstY:Integer);
var
  srcX,srcY:Integer;
Begin
  if target<>NIL then
  Begin
    srcX:=TileID mod Floor(Context.Width / TileSize) * TileSize;
    srcY:=Floor(TileID / (Context.Width / TileSize)) * TileSize;
    DrawPart(target,srcX,srcY,TileSize,TileSize,dstX,dstY);
  end;
end;

Procedure TW3Canvas.DrawTile(target:TW3CanvasTW3Canvas;
          Const TileID:Integer;
          const TileSize:Integer;
          const dstX,dstY:Integer;
          const rotation:Integer);
var
  srcX,srcY:Integer;
Begin
  if target<>NIL then
  Begin
    srcX:=TileID mod Floor(Context.Width / TileSize) * TileSize;
    srcY:=Floor(TileID / (Context.Width / TileSize)) * TileSize;
    DrawPart(target,srcX,srcY,TileSize,TileSize,dstX,dstY,rotation);
  end;
end;

Procedure TW3Canvas.DrawTile(target:TW3CanvasTW3Canvas;
          const TileID:Integer;
          const TileSize:Integer;
          const dstX,dstY:Integer;
          const rotation:Integer;
          const alpha:Integer);
var
  srcX,srcY:Integer;
Begin
  if target<>NIL then
  Begin
    srcX:=TileID mod Floor(Context.Width / TileSize) * TileSize;
    srcY:=Floor(TileID / (Context.Width / TileSize)) * TileSize;
    DrawPart(target,srcX,srcY,TileSize,TileSize,dstX,dstY,rotation,alpha);
  end;
end;

procedure TW3Canvas.ClearRectF(aLeft,aTop,aWidth,aHeight:Float);
begin
  FDC.clearRect(aLeft,aTop,aWidth,aHeight);
end;

procedure TW3Canvas.StrokeTextF(text: String;x,y,maxwidth:Float);
begin
  FDC.strokeText(text,x,y,maxWidth);
end;

procedure TW3Canvas.StrokeTextF(text: String;x,y:Float);
begin
  FDC.strokeText(text,x,y);
end;

procedure TW3Canvas.FillRectF(const aRect: TRectTRect);
begin
  FDC.fillRect(aRect.Left$3,aRect.Top$3,aRect.Width$3,aRect.Height$3);
end;

procedure TW3Canvas.FillRectF(const aRect: TRectFTRectF);
begin
  FDC.fillRect(aRect.Left$2,aRect.Top$2,aRect.Width$2,aRect.Height$2);
end;

procedure TW3Canvas.FillRectF$2(aLeft$4,aTop$4,aWidth$3,aHeight$3:Float);
begin
  FDC.fillRect(aLeft$4,aTop$4,aWidth$3,aHeight$3);
end;

procedure TW3Canvas.FillBounds(aLeft, aTop, aRight, aBottom: Float);
begin
  FDC.fillRect(aLeft,aTop,aRight-aLeft,aBottom-aTop);
end;

procedure TW3Canvas.RectangleF(aLeft,aTop,aWidth,aHeight:Float);
begin
  FDC.rect(aLeft,aTop,aWidth,aHeight);
end;

procedure TW3Canvas.StrokeRectF(const aRect : TRectFTRectF);
begin
  FDC.strokeRect(aRect.Left$2, aRect.Top$2, aRect.Width$2, aRect.Height$2);
end;

procedure TW3Canvas.StrokeRectF(aLeft,aTop,awidth,aheight:Float);
begin
  FDC.strokeRect(aLeft,aTop,aWidth,aHeight);
end;

procedure TW3Canvas.ClearRect(const aRect : TRectTRect);
begin
  FDC.clearRect(aRect.Left$3, aRect.Top$3, aRect.Width$3, aRect.Height$3);
end;

procedure TW3Canvas.FillRect(const aRect : TRectTRect);
begin
  FDC.fillRect(aRect.Left$3, aRect.Top$3, aRect.Width$3, aRect.Height$3);
end;

procedure TW3Canvas.FillRect(aLeft, aTop, aWidth, aHeight: Integer);
begin
  FDC.fillRect(aLeft, aTop, aWidth, aHeight);
end;

procedure TW3Canvas.Rectangle(const aRect : TRectTRect);
begin
  FDC.rect(aRect.Left$3,aRect.Top$3,aRect.Width$3,aRect.Height$3);
end;

procedure TW3Canvas.StrokeRect(const aRect : TRectTRect);
begin
  FDC.strokeRect(aRect.Left$3,aRect.Top$3,aRect.Width$3,aRect.Height$3);
end;

procedure TW3Canvas.ArcF(x,y,radius,startAngle,endAngle:Float; anticlockwise:Boolean);
begin
  FDC.arc(x,y,radius,startAngle,endAngle,anticlockwise);
end;

procedure TW3Canvas.ArcToF(x1,y1,x2,y2,radius:Float);
begin
  FDC.arcTo(x1,y1,x2,y2,radius);
end;

procedure TW3Canvas.BeginPath;
begin
  FDC.beginPath();
end;

procedure TW3Canvas.ClosePath;
begin
  FDC.closePath();
end;

procedure TW3Canvas.BezierCurveToF(cp1x,cp1y,cp2x,cp2y,x,y:Float);
begin
  FDC.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y);
end;

procedure TW3Canvas.Clip;
begin
  FDC.clip();
end;

procedure TW3Canvas.ResetClip;
begin
  FDC.resetClip();
end;

function TW3Canvas.isPointInPathF(x,y:Float): Boolean;
begin
  Result := FDC.isPointInPath(x,y);
end;

function TW3Canvas.isPointInPathF(const p : TPointFTPointF): Boolean;
begin
  Result := FDC.isPointInPath(p.X,p.Y);
end;

procedure TW3Canvas.LineToF(x$14,y$7:Float);
begin
  FDC.lineTo(x$14,y$7);
end;

procedure TW3Canvas.LineTo(const aPoint : TPointFTPointF);
begin
  FDC.lineTo(aPoint.X, aPoint.Y);
end;

procedure TW3Canvas.Fill;
begin
  FDC.fill();
end;

function TW3Canvas.MeasureText(aText: String): TW3TextMetrics;
var
  metrics : Variant;
begin
  metrics := FDC.measureText(aText);
  Result.Width := metrics.width;
end;

procedure TW3Canvas.Stroke;
begin
  FDC.stroke();
end;

procedure TW3Canvas.DrawImageF(imageHandle:THandle;x$13,y$6:Float);
begin
  FDC.drawImage(Element(imageHandle),x$13,y$6);
end;

procedure TW3Canvas.DrawImageF(imageHandle:THandle;x,y:Float;ow,oh:Float);
begin
  FDC.drawImage(Element(imageHandle),x,y,ow,oh);
end;

procedure TW3Canvas.DrawImageF(imageHandle:THandle;sx,sy,sw,sh,dx,dy,dw,dh:Float);
begin
  FDC.drawImage(Element(imageHandle),sx,sy,sw,sh,dx,dy,dw,dh);
end;

procedure TW3Canvas.DrawImage(image: ElementElement; x,y :Float);
begin
  FDC.drawImage(image,x,y);
end;

procedure TW3Canvas.DrawImage(image: ElementElement; x,y: Float; ow,oh: Float);
begin
  FDC.drawImage(image,x,y,ow,oh);
end;

procedure TW3Canvas.DrawImage(image: ElementElement; sx,sy,sw,sh,dx,dy,dw,dh: Float);
begin
  FDC.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh);
end;

procedure TW3Canvas.FillTextF(text: String;x,y,maxWidth:Float);
begin
  FDC.fillText(text,x,y,maxWidth);
end;
     
procedure TW3Canvas.FillText(text: String;x,y,maxWidth:Float);
begin
  FDC.fillText(text,x,y,maxWidth);
end;

procedure TW3Canvas.FillText(text: String;x,y:Float);
begin
  FDC.fillText(text,x,y);
end;

procedure TW3Canvas.MoveToF(x$15,y$8:Float);
begin
  FDC.moveTo(x$15,y$8);
end;

procedure TW3Canvas.MoveTo(const aPoint : TPointFTPointF);
begin
  FDC.moveTo(aPoint.X, aPoint.Y);
end;

procedure TW3Canvas.QuadraticCurveToF(cpx,cpy,x,y:Float);
begin
  FDC.quadraticCurveTo(cpx,cpy,x,y);
end;

function TW3Canvas.CreateRadialGradientF(x0,y0,r0,x1,y1,r1:Float): TW3CanvasGradient;
var
  mTemp:  THandle;
begin
  try
    mTemp := FDC.createRadialGradient(x0,y0,r0,x1,y1,r1);
  except
    on e: Exception do
    raise Exception.Create('Failed to create gradient object:' + e.Message);
  end;
  Result := TW3CanvasGradient.Create(mTemp);
end;

procedure TW3Canvas.UseGradient(aGradient: TW3CanvasGradient);
begin
  if aGradient<>nil then
    FDC.fillStyle := aGradient.Handle
  else raise Exception.Create('Failed to use gradient, object was NIL error');
end;

function TW3Canvas.CreateLinearGradientF(x0,y0,x1,y1:Float): TW3CanvasGradient;
var
  mTemp:  Variant;
begin
  mTemp := FDC.createLinearGradient(x0,y0,x1,y1);
  if (mTemp) then
    Result := TW3CanvasGradient.Create(mTemp);
end;

function TW3Canvas.CreateVerticalGradient(y0: Float; y1: Float): TW3CanvasGradient;
begin
  Result := TW3CanvasGradient.Create(FDC.createLinearGradient(0, y0, 0, y1));
end;

function TW3Canvas.CreateHorizontalGradient(x0: Float; x1: Float): TW3CanvasGradient;
begin
  Result := TW3CanvasGradient.Create(FDC.createLinearGradient(x0, 0, x1, 0));
end;

function TW3Canvas.CreatePattern(image: THandle; aRepeat: String) : TW3CanvasPattern;
begin
  Result := TW3CanvasPattern.Create;
  Result.Handle := FDC.createPattern(Element(image), aRepeat);
end;

procedure TW3Canvas.UsePattern(aPattern: TW3CanvasPattern);
begin
  FDC.fillStyle := aPattern.Handle;
end;

function TW3Canvas.CreateImageData(sw, sh: Float): TW3ImageData;
begin
  var mTemp := FDC.createImageData(sw,sh);
  if Assigned(mTemp) then begin
    Result := TW3ImageData.Create;
    Result.fromImageData(mTemp);
  end;
end;

function TW3Canvas.CreateImageData(reference: TW3ImageDataTW3ImageData): TW3ImageData;
begin
  var mTemp := FDC.createImageData(reference.Handle);
  if Assigned(mTemp) then begin
    Result := TW3ImageData.Create;
    Result.fromImageData(mTemp);
  end;
end;

function TW3Canvas.ToDataURL(aMimeType: String): String;
begin
  Result := FDC.canvas.toDataURL(aMimeType);
end;

function TW3Canvas.ToImageData: TW3ImageData;
var
  mTemp$12:  ImageData;
  wd,hd:  Integer;
begin
  wd := FDC.canvas.width;
  hd := FDC.canvas.height;

  try
    mTemp$12 := FDC.getImageData(0,0,wd,hd);
  except
    on e: Exception do
       raise Exception.Create('Failed to extract data, browser threw exception: ' + e$5.Message);
  end;

  if Assigned(mTemp$12) then
  begin
    Result := TW3ImageData.Create;
    Result.fromImageData(mTemp$12);
  end;
end;

function TW3Canvas.GetImageData(sx,sy,sw,sh:Float): TW3ImageData;
begin
  var mTemp :=  FDC.getImageData(sx,sy,sw,sh);
  if Assigned(mTemp) then
  begin
    Result := TW3ImageData.Create;
    Result.fromImageData(mTemp);
  end;
end;

procedure TW3Canvas.PutImageData(imageData: TW3ImageDataTW3ImageData;x,y:Float);
begin
  if Assigned(imageData) then
  begin
    FDC.putImageData(imageData.Handle,x,y);
  end else
  raise Exception.Create('ImageData was NIL error');
end;

procedure TW3Canvas.PutImageData(imageData: TW3ImageDataTW3ImageData;
          x,y,dx,dy,dw,dh:Float);
begin
  if Assigned(imageData) then
  begin
    FDC.putImageData(imageData.Handle,x,y,dx,dy,dw,dh);
  end else
  raise Exception.Create('ImageData was NIL error');
end;

procedure TW3Canvas.ClearShadow;
begin
  FDC.clearShadow();
end;

procedure TW3Canvas.Rotate(angleRad:Float);
begin
  FDC.rotate(angleRad);
end;

procedure TW3Canvas.Scale(sx,sy:Float);
begin
  FDC.scale(sx,sy);
end;

procedure TW3Canvas.Transform(m11,m12,m21,m22,dx,dy:Float);
begin
  FDC.transform(m11,m12,m21,m22,dx,dy);
end;

procedure TW3Canvas.Translate(tx,ty:Float);
begin
  FDC.translate(tx,ty);
end;

procedure TW3Canvas.Translate(const pt : TPointFTPointF);
begin
  FDC.translate(pt.X, pt.Y);
end;

function TW3Canvas.getStrokeStyle: String;
begin
  Result := FDC.strokeStyle;
end;

procedure TW3Canvas.setStrokeStyle(aValue$59: String);
begin
  FDC.strokeStyle := aValue$59;
end;

function TW3Canvas.getMiterLimit:Float;
begin
  Result := FDC.miterLimit;
end;

procedure TW3Canvas.setMiterLimit(aValue:Float);
begin
  FDC.miterLimit := aValue;
end;

function TW3Canvas.getGlobalCompOp: String;
begin
  Result := FDC.globalCompositeOperation;
end;

procedure TW3Canvas.setGlobalCompOp(aValue: String);
begin
  FDC.globalCompositeOperation := aValue;
end;

function TW3Canvas.getGlobalAlpha:Float;
begin
  Result := FDC.globalAlpha;
end;

procedure TW3Canvas.setGlobalAlpha(aValue$58:Float);
begin
  FDC.globalAlpha := aValue$58;
end;

function TW3Canvas.getshadowX:Float;
begin
  Result := FDC.shadowOffsetX;
end;

procedure TW3Canvas.setShadowX(aValue:Float);
begin
  FDC.shadowOffsetX := aValue;
end;

function TW3Canvas.getshadowY:Float;
begin
  Result := FDC.shadowOffsetY;
end;

procedure TW3Canvas.setShadowY(aValue:Float);
begin
  FDC.shadowOffsetY := aValue;
end;

function TW3Canvas.getFont: String;
begin
  Result := FDC.font;
end;

procedure TW3Canvas.setFont(aValue: String);
begin
  FDC.font := aValue;
end;

function TW3Canvas.getTextBaseline: String;
begin
  Result := FDC.textBaseline;
end;

procedure TW3Canvas.setTextbaseLine(aValue: String);
begin
  FDC.textBaseline := aValue;
end;

function TW3Canvas.getShadowBlur:Float;
begin
  Result := FDC.shadowBlur;
end;

procedure TW3Canvas.setShadowBlur(aValue:Float);
begin
  FDC.shadowBlur := aValue;
end;

function TW3Canvas.getTextAlign: String;
begin
  Result := FDC.textAlign;
end;

procedure TW3Canvas.setTextAlign(aValue: String);
begin
  FDC.textAlign := aValue;
end;

function TW3Canvas.getLineWidth:Float;
begin
  Result := FDC.lineWidth;
end;

procedure TW3Canvas.setLineWidth(aValue:Float);
begin
  FDC.lineWidth := aValue;
end;

function TW3Canvas.getLineJoin: String;
begin
  Result := FDC.lineJoin;
end;

procedure TW3Canvas.setLineJoin(aValue: String);
begin
  FDC.lineJoin := aValue;
end;

function TW3Canvas.getLineCap: String;
begin
  Result := FDC.lineCap;
end;

procedure TW3Canvas.setLineCap(aValue: String);
begin
  FDC.lineCap := aValue;
end;

function  TW3Canvas.GetLineDash : TW3DashList;
begin
   asm
   @Result = (@FDC).lineDash;
   end;
end;

procedure TW3Canvas.SetLineDash(aValue : TW3DashList);
begin
   asm
   (@FDC).lineDash = @aValue;
   end;
end;

function  TW3Canvas.GetLineDashOffset : Float;
begin
   Result := FDC.lineDashOffset;
end;

procedure TW3Canvas.SetLineDashOffset(aValue : Float);
begin
   FDC.lineDashOffset := aValue;
end;

function TW3Canvas.getShadowColor: String;
begin
  Result := FDC.shadowColor;
end;

procedure TW3Canvas.setShadowColor(aValue: String);
begin
  FDC.shadowColor := aValue;
end;

function TW3Canvas.getFillStyle: String;
begin
  Result := FDC.fillStyle;
end;

procedure TW3Canvas.setFillStyle(aValue$57: String);
begin
  FDC.fillStyle := aValue$57;
end;

procedure TW3Canvas.Save;
begin
  if Assigned(FContext) then
  begin
    FDC.save();
  end;
end;

procedure TW3Canvas.Restore;
begin
  if Assigned(FContext) then
  begin
    FDC.restore();
  end;
end;

procedure TW3Canvas.setPixel(x,y: Integer);
begin
  FDC.fillRect(x,y,1,1);
end;

procedure TW3Canvas.Clear;
begin
  if Assigned(FContext) then
  begin
    FDC.clearRect(0,0,FContext.Width,FContext.Height);
  end;
end;

procedure TW3Canvas.LineF(x1,y1,x2,y2:Float);
begin
  FDC.moveTo(x1,y1);
  FDC.lineTo(x2,y2);
end;

procedure TW3Canvas.HorzLine(x1: Float; y: Float; x2: Float);
begin
   FDC.moveTo(x1, y);
   FDC.lineTo(x2, y);
end;

procedure TW3Canvas.VertLine(x: Float; y1: Float; y2: Float);
begin
   FDC.moveTo(x, y1);
   FDC.lineTo(x, y2);
end;

procedure TW3Canvas.Ellipse(x1, y1, x2, y2 : Float);
begin
   var r := TRectF.CreateBounded(x1, y1, x2, y2);
   Ellipse(r);
end;

procedure TW3Canvas.Ellipse(const aRect : TRectFTRectF);
begin
   FDC.save();
   FDC.translate((aRect.Right+aRect.Left$2)*0.5, (aRect.Top$2+aRect.Bottom)*0.5);
   FDC.scale((aRect.Right-aRect.Left$2)*0.5, (aRect.Top$2-aRect.Bottom)*0.5);
   FDC.moveTo(1, 0);
   FDC.arc(0, 0, 1, 0, 2*Pi, False);
   FDC.restore();
end;

end.


