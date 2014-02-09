{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Components;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.25 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

{$I 'vjl.inc'}

{.$DEFINE USE_NEW_MOUSECORDS}

interface

const
USE_DISPLAY_MODE  = 'inline-block';

uses
  W3System, W3Lists, W3Fonts, W3Graphics, W3CssNames, W3Touch, W3Borders,
  w3c.DOM;

type
  EW3TagObj = class(EW3Exception)
    public
      class procedure RaiseCntErrMethod(methName : String; instance : TObjectTObject; msg : String); static;
  end;
  EW3CustomControl = class(EW3Exception);

  (* custom types *)

  TMouseButton = (mbLeft, mbMiddle, mbRight);

  TShiftStateEnum = (ssShift, ssAlt, ssCtrl, ssMeta,
                     // these require a browser with DOM level 3 support to work
                     ssLeft, ssRight, ssMiddle);

  // currently a class to workaround a compiler limitation on declaring class operators
  // on external classes and helpers, so don't trust it remaining a class!!!
  TShiftState = class
  private
    FEvent : JKeyStateEvent;
    FMouseEvent : MouseEvent;
    FMouseButtons : Integer;
    class var vCurrent : TShiftState;
    function CheckShiftStateEnum(value$2 : TShiftStateEnumTShiftStateEnum) : Boolean;
    procedure SetKeyStateEvent(evt$8 : JKeyStateEventJKeyStateEvent);
    procedure SetMouseEvent(evt$9 : MouseEventMouseEvent);
  public
    property Event : JKeyStateEvent read FEvent write SetKeyStateEvent;
    property MouseEvent : MouseEvent read FMouseEvent write SetMouseEvent;
    property MouseButtons : Integer read FMouseButtons write FMouseButtons;
    class operator in TShiftStateEnum uses CheckShiftStateEnum;
    class function Current : TShiftState; static;
  end;

  (* Event handlers *)
  TMouseButtonEvent TMouseButtonEventr: TObjectTObject; Button: TMouseButtonTMouseButton;
                                Shift: TShiftStateTShiftState; X, Y: Integer);
  TMouseDownEvent = TMouseButtonEvent;
  TMouseUpEvent = TMouseButtonEvent;
  TMouseEvent TMouseEvent(Sender: TObjectTObject; Shift: TShiftStateTShiftState; X, Y: Integer);
  TMouseMoveEvent = TMouseEvent;
  TMouseEnterEvent = TMouseEvent;
  TMouseExitEvent = TMouseEvent;
  TMouseDblClickEvent = TNotifyEvent;
  TMouseClickEvent = TNotifyEvent;
  TMouseWheelEvent TMouseWheelEventer: TObjectTObject; shift: TShiftStateTShiftState;
                               wheelDelta: Integer; const mousePos : TPointTPoint;
                               var handled : Boolean);

  TTransitionEndEvent = TNotifyEvent;

  TKeyDownEvent TKeyDownEventender: TObjectTObject; aKeyCode: Integer);
  TKeyUpEvent TKeyUpEvent(Sender: TObjectTObject; aKeyCode: Integer);
  TKeyPressEvent TKeyPressEventnder: TObjectTObject; aChar: String);
  TGotFocusEvent = TNotifyEvent;
  TLostFocusEvent = TNotifyEvent;
  TReSizeEvent = TNotifyEvent;
  TAnimationBeginsEvent = TNotifyEvent;
  TAnimationEndsEvent = TNotifyEvent;
  TChangedEvent = TNotifyEvent;
  TPaintEvent TPaintEvent(Sender: TObjectTObject; Canvas: TW3CanvasTW3Canvas);
  TContextPopupEvent TContextPopupEvent: TObjectTObject; const mousePos: TPointTPoint; var handled: Boolean);

  (* Forward declarations *)
  TW3TagObj = class;
  TW3Component = class;
  TW3CustomControl = partial class;
  TW3ControlFont = class;
  TW3ControlBackground = class;

  TW3ComponentArray = array of TW3Component;
  TW3ControlArray = array of TW3CustomControl;

  (* Information about a tag size.
    TW3CurstomControl.getSizeInfo() returns this record. It is very
    helpful when trying to locate size discrepancies. These discrepancies
    usually occur when your CSS makes use of padding/margin or borders. *)
  TW3ControlSizeInfo = record
    siWidth: Integer;
    siHeight: Integer;
    siClientWidth: Integer;
    siClientHeight: Integer;
    siOffsetWidth: Integer;
    siOffsetHeight: Integer;
    siScrollWidth: Integer;
    siScrollHeight: Integer;
    function ToString: String;
  end;

  TW3TagObj = class(TObject)
  private
    FOwner: THandle;
    FTagId: String;
    FObjReady: Boolean;
    FTagValue: Integer;
    FUpdating: Integer;
    FHandle: THandle;
    function getAttached: Boolean;
    function getUpdating: Boolean;
  protected
    function getInnerHTML: String;
    procedure setInnerHTML(aValue$14: String);
    function getInnerText: String;
    procedure setInnerText(aValue: String);
    function makeElementTagId: String; virtual;
    function makeElementTagObj: THandle; virtual;
    procedure StyleTagObject; virtual;
    procedure AfterUpdate; virtual;
    (* We override these rather than the constructor,
      this allows us to avoid some side-effects like calls to
      ReSize() before the decendants are ready *)
    procedure InitializeObject; virtual;
    procedure FinalizeObject; virtual;
    procedure UnHookEvents; virtual;
  public
    property InnerHTML: String read getInnerHTML write setInnerHTML;
    property InnerText: String read getInnerText write setInnerText;
    property ObjectReady: Boolean read FObjReady;
    property Owner: THandle read FOwner;
    property TagId: String read FTagId write FTagId;
    property Handle: THandle read FHandle;
    property Attached: Boolean read getAttached;
    property Updating: Boolean read getUpdating;
    procedure BeginUpdate;
    procedure EndUpdate; virtual;
    procedure InsertInto(const OwnerHandle: THandle);
    procedure RemoveFrom;
    constructor Create$3; virtual;
    destructor Destroy; override;
  published
    property TagValue: Integer read FTagValue write FTagValue;
  end;

  TW3Component = class(TW3TagObj)
  private
    FParent: TW3Component;
    FChildren: array of TW3Component;
    FName: String;
    procedure FreeChildren;
  protected
    procedure SetName(Value$4: String);
    procedure CBNoBehavior; virtual;
    function  GetChildCount: Integer;
    function  GetChildObject(index: Integer): TW3Component;
    procedure RegisterChild(aChild$2: TW3ComponentTW3Component);
    procedure UnRegisterChild(aChild$3: TW3ComponentTW3Component);
    procedure ChildAdded(aChild:TW3ComponentTW3Component);virtual;
    Procedure ChildRemoved(aChild$1:TW3ComponentTW3Component);virtual;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    constructor Create$4(AOwner$1: TW3ComponentTW3Component); reintroduce; virtual;
    function    ChildByName(const compName: String): TW3Component;
    function    ChildByHandle(const aHandle:THandle):TW3Component;
    procedure EnumChildren(childProc: procedure (child: TW3ComponentTW3Component));
    property Parent: TW3Component read FParent;
    function TopLevelParent : TW3Component;
  published
    property Name$3: String read FName write SetName;
  end;

  //Baseclass for custom application target containers
  TCustomAppContainer = Class(TW3Component)
  End;

  //DIV based application target
  TDIVAppContainer = Class(TCustomAppContainer)
  End;

  //Document Body container
  TDocumentBody = class(TCustomAppContainer)
  private
    FOnReSize: TReSizeEvent;
    function getWidth$5: Integer;
    function getHeight$4: Integer;
    function getClientLeft: Integer;
    function getClientTop: Integer;
    function getClientWidth: Integer;
    function getClientHeight: Integer;
    function getClientRect: TRect;
  protected
    procedure CBResize;
    procedure _setOnResize(aValue: TNotifyEventTNotifyEvent);
    function makeElementTagId: String; override;
    function makeElementTagObj: THandle; override;
    procedure StyleTagObject; override;
  public
    property ClientLeft: Integer read getClientLeft;deprecated;
    property ClientTop: Integer read getClientTop;deprecated;
    property ClientWidth: Integer read getClientWidth;
    property ClientHeight: Integer read getClientHeight;
    property ClientRect: TRect read getClientRect;deprecated;
    property Width$8: Integer read getWidth$5;
    property Height$6: Integer read getHeight$4;
    property OnReSize: TNotifyEvent read FOnReSize write _setOnResize;
  end;

  TW3ControlFont = class(TW3CustomFont)
  private
    FOwner$4: TW3CustomControl;
  protected
    function GetHandle$1: THandle; override;
  public
    property Parent: TW3CustomControl read FOwner;
    constructor Create$37(AOwner$2: TW3CustomControlTW3CustomControl); virtual;
  end;

  TW3ControlBackground = class(TW3OwnedObject)
  protected
    function AcceptParent(aObject$2: TObjectTObject): Boolean; override;
  public
    procedure FromColor(const aValue: TColor);
    procedure FromURL(const aURL: String);
    procedure FromImageData(const aImgStr: String);
    function ToColor: TColor;
    function ToURL: String;
  end;

  TW3Constraints = class(TW3OwnedObject)
  protected
    function  AcceptParent(aObject$3: TObjectTObject): Boolean; override;
    function  GetMaxWidth: Integer;
    function  GetMaxHeight: Integer;
    procedure setMaxWidth(aValue$54: Integer);
    procedure setMaxHeight(aValue$53: Integer);

    function  GetMinWidth: Integer;
    function  GetMinHeight: Integer;
    procedure setMinWidth(aValue$56: Integer);
    procedure setMinHeight(aValue$55: Integer);

  published
    property  MinWidth: Integer read GetMinWidth write setMinWidth;
    property  MinHeight:Integer read GetMinHeight write setMinHeight;
    property  MaxWidth: Integer read GetMaxWidth write setMaxWidth;
    property  MaxHeight: Integer read GetMaxHeight write setMaxHeight;
  end;

  TW3ScrollInfo = class(TW3OwnedObject)
  private
    function getScrollLeft: Integer;
    function getScrollTop: Integer;
    function getScrollWidth: Integer;
    function getScrollHeight: Integer;
  protected
    function AcceptParent(aObject$1: TObjectTObject): Boolean; override;
  public
    property OffsetX: Integer read getScrollLeft;
    property OffsetY: Integer read getScrollTop;
    procedure ScrollTo(aLeft$1, aTop$1: Integer);
    procedure ScrollX(aLeft: Integer);
    procedure ScrollY(aTop: Integer);
    property ScrollWidth: Integer read getScrollWidth;
    property ScrollHeight: Integer read getScrollHeight;
    function ToString: String; virtual;
  end;

  TW3MovableControl = class(TW3Component)
  private
    FWasMoved: Boolean;
    FWasSized: Boolean;
    FAlpha: Integer;
    FUseAlpha: Boolean;
    FTransparent: Boolean;
    FColor: TColor;
    FBorders: TW3Borders;
    FConstraints: TW3Constraints;
    FBackground: TW3ControlBackground;
    FAdjusted:  Boolean;
  protected
    function getBorder: TW3Borders;
    function getConstraints: TW3Constraints;
    function GetWidth: Integer; virtual;
    function GetHeight: Integer; virtual;
    function GetLeft: Integer; virtual;
    function GetTop: Integer; virtual;
    function getVisible: Boolean; virtual;
    procedure setLeft(const aValue$18: Integer); virtual;
    procedure setTop(const aValue$19: Integer); virtual;
    procedure SetWidth(aValue$23: Integer); virtual;
    procedure setHeight(aValue$17: Integer); virtual;
    procedure SetVisible(const aValue$22: Boolean); virtual;
    function getBoundsRect: TRect; virtual;
    procedure setTransparent(const aValue$20: Boolean);
    procedure setAlpha(const aValue$15: Integer);
    procedure setUseAlpha(const aValue$21: Boolean);
    procedure setColor(const aValue$16: TColor);
    function GetBackGround: TW3ControlBackground;
    procedure AfterUpdate; override;
    function GetWasMoved: Boolean;
    function GetWasSized: Boolean;
    procedure SetWasMoved;
    procedure SetWasSized;
    procedure Moved; virtual;
    procedure Resize; virtual;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    property Constraints: TW3Constraints read getConstraints;
    property BoundsRect: TRect read getBoundsRect;
    property Background: TW3ControlBackground read GetBackGround;
    property Border: TW3Borders read getBorder;
    procedure AdjustToParentBox; virtual;
    function ClientWidth: Integer;
    function ClientHeight: Integer;
    function ClientRect: TRect;
    function ScreenRect: TRect;
    function ClientToScreen(pt: TPointTPoint): TPoint;
    function ScreenToClient(pt: TPointTPoint): TPoint;
    procedure MoveTo(aLeft$2, aTop$2: Integer); virtual;
    procedure SetSize(aWidth$1, aHeight$1: Integer); virtual;
    procedure SetBounds(aLeft$3, aTop$3, aWidth, aHeight: Integer); overload; virtual;
    procedure SetBounds(aRect: TRectTRect); overload; virtual;
    class function DisplayMode : String; virtual;

    function  ControlAtPoint(x,y:Integer;
              Const Recursive:Boolean):TW3Component;overload;

    function  ControlAtPoint(Const aPoint:TPointTPoint;
              Const Recursive:Boolean):TW3Component;overload;

    class function supportAdjustment:Boolean;virtual;

  published
    property Color: TColor read FColor write setColor;
    property Visible: Boolean read getVisible write SetVisible;
    property Left: Integer read GetLeft write setLeft;
    property Top: Integer read GetTop write setTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write setHeight;
    property Opacity: Integer read FAlpha write setAlpha;
    property AlphaBlend: Boolean read FUseAlpha write setUseAlpha;
    property Transparent: Boolean read FTransparent write setTransparent;
  end;

  TW3CustomControl = partial class(TW3MovableControl)
  private
    FAngle: Float;
    FScrollInfo: TW3ScrollInfo;
    FClassNames: TW3CSSClassStyleNames;
    FFont: TW3ControlFont;
    FTouchData: TW3TouchData;
    FGestureData: TW3GestureData;
    function getClassNames: TW3CSSClassStyleNames;
    function getScrollInfo: TW3ScrollInfo;
    function getFont: TW3ControlFont;
    FOnMouseDown: TMouseButtonEvent
    FOnMouseUp: TMouseButtonEvent
    FOnMouseMove: TMouseEventvent;
    FOnMouseEnter: TMouseEventEvent;
    FOnMouseExit: TMouseEventvent;
    FOnMouseWheel: TMouseWheelEvent;
    FOnClick: TNotifyEventvent;
    FOnDblClick: TNotifyEventckEvent;
    FOnKeyDown: TKeyDownEvent;
    FOnKeyUp: TKeyUpEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnGotFocus: TNotifyEventnt;
    FOnLostFocus: TNotifyEventent;
    FOnAnimationBegins: TNotifyEventginsEvent;
    FOnAnimationEnds: TNotifyEventdsEvent;
    FOnChanged: TNotifyEventt;
    FOnTouchBegins: TTouchBeginEvent;
    FOnTouchMoves: TTouchMoveEvent;
    FOnTouchEnds: TTouchEndEvent;
    FOnGestureStart: TGestureStartEvent;
    FOnGestureChange: TGestureChangeEvent;
    FOnGestureEnd: TGestureEndEvent;
    FOnResize: TNotifyEvent;
    FOnContextPopup : TContextPopupEvent;
    FNoBehavior: TProcedureRef;
    procedure _setMouseDown(const aValue$41: TMouseButtonEventTMouseButtonEvent
    procedure _setMouseUp(const aValue$45: TMouseButtonEventTMouseButtonEvent
    procedure _setMouseMove(const aValue$44: TMouseEventTMouseEventvent); 
    procedure _setMouseEnter(const aValue$42: TMouseEventTMouseEventEvent); 
    procedure _setMouseExit(const aValue$43: TMouseEventTMouseEventvent); 
    procedure _setMouseClick(const aValue$39: TNotifyEventTNotifyEventvent); 
    procedure _setMouseWheel(const aValue$46: TMouseWheelEventTMouseWheelEvent);
    procedure _setMouseDblClick(const aValue$40: TNotifyEventTNotifyEventckEvent); 
    procedure _setKeyDown(const aValue$35: TKeyDownEventTKeyDownEvent); 
    procedure _setKeyUp(const aValue$37: TKeyUpEventTKeyUpEvent); 
    procedure _setKeyPress(const aValue$36: TKeyPressEventTKeyPressEvent); 
    procedure _setGotFocus(const aValue$34: TNotifyEventTNotifyEventnt); 
    procedure _setLostFocus(const aValue$38: TNotifyEventTNotifyEventent); 
    procedure _setAnimationBegins(const aValue$27: TNotifyEventTNotifyEventginsEvent); 
    procedure _setAnimationEnds(const aValue$28: TNotifyEventTNotifyEventdsEvent); 
    procedure _setChanged(const aValue$29: TNotifyEventTNotifyEventt); 
    procedure _setTouchBegins(const aValue$48: TTouchBeginEventTTouchBeginEvent); 
    procedure _setTouchMoves(const aValue$50: TTouchMoveEventTTouchMoveEvent); 
    procedure _setTouchEnds(const aValue$49: TTouchEndEventTTouchEndEvent); 
    procedure _setGestureStart(aValue$33:TGestureStartEventTGestureStartEvent); 
    procedure _setGestureChange(aValue$31:TGestureChangeEventTGestureChangeEvent); 
    procedure _setGestureEnd(aValue$32:TGestureEndEventTGestureEndEvent); 
    procedure _setResize(const aValue$47: TNotifyEventTNotifyEvent); 
    procedure _setContextPopup(const aValue$30: TContextPopupEventTContextPopupEvent);
  protected
    procedure CBChanged(const eventObj$2: Variant); virtual;
    procedure CBMouseDown(eventObj$8: MouseEventMouseEvent); virtual;
    procedure CBMouseUp(eventObj$12: MouseEventMouseEvent); virtual;
    procedure CBMouseMove(eventObj$11 : MouseEventMouseEvent); virtual;
    procedure CBMouseEnter(eventObj$9 : MouseEventMouseEvent); virtual;
    procedure CBMouseExit(eventObj$10 : MouseEventMouseEvent); virtual;
    procedure CBMouseWheel(eventObj$13 : MouseWheelEventMouseWheelEvent); virtual;
    procedure CBClick(const eventObj$3: Variant); virtual;
    procedure CBDblClick(const eventObj$4: Variant); virtual;
    procedure CBKeyDown(const eventObj$5: Variant); virtual;
    procedure CBKeyUp(const eventObj$7: Variant); virtual;
    procedure CBKeyPress(const eventObj$6: Variant); virtual;
    procedure CMTouchBegins; virtual;
    procedure CMTouchMove; virtual;
    procedure CMTouchEnds; virtual;
    procedure CMGestureStart; virtual;
    procedure CMGestureChange; virtual;
    procedure CMGestureEnd; virtual;
    procedure CBFocused; virtual;
    procedure CBLostFocus; virtual;
    procedure CBAnimationBegins(const eventObj: Variant); virtual;
    procedure CBAnimationEnds(const eventObj$1: Variant); virtual;
    function  CBContextPopup(event : MouseEventMouseEvent) : Boolean; virtual;

    procedure MouseDown(button$1 : TMouseButtonTMouseButton; shiftState$6 : TShiftStateTShiftState; x$8, y$1 : Integer); virtual;
    procedure MouseUp(button$2 : TMouseButtonTMouseButton; shiftState$10 : TShiftStateTShiftState; x$12, y$5 : Integer); virtual;
    procedure MouseMove(shiftState$9 : TShiftStateTShiftState; x$11, y$4 : Integer); virtual;
    procedure MouseEnter(shiftState$7 : TShiftStateTShiftState; x$9, y$2 : Integer); virtual;
    procedure MouseExit(shiftState$8 : TShiftStateTShiftState; x$10, y$3 : Integer); virtual;
    procedure MouseWheel(shift: TShiftStateTShiftState; wheelDelta$2: Integer; const mousePos$2 : TPointTPoint;
                         var handled$3 : Boolean); virtual;

    procedure ContextPopup(const mousePos$1: TPointTPoint; var handled$2: Boolean);
    function  getBorderRadius: Integer;
    procedure setBorderRadius(aNewRadius: Integer);
    function  getZoom: Float;
    procedure setZoom(aValue$26: Float);
    procedure setAngle(aValue$24: Float);
    function  getStyleClass: String;
    procedure setStyleClass(aStyle: String);
    function  getEnabled: Boolean; virtual;
    procedure setEnabled(aValue$25: Boolean); virtual;
    function  gethasFocus: Boolean;
    function  GetZIndexAsInt(default$1: integer = 0): integer;
    procedure StyleTagObject; override;
    procedure AfterUpdate; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;

  public
    property CSSClasses: TW3CSSClassStyleNames read getClassNames;
    property ScrollInfo: TW3ScrollInfo read getScrollInfo;
    property Font: TW3ControlFont read getFont;
    property BoundsRect$1: TRect read getBoundsRect;
    function  GetMaxZIndex: integer;
    procedure SendToBack;
    procedure BringToFront;
    procedure SetFocus;
    // Added: 8 march 2012
    // Composite controls sometimes requires a full resize to be post emited.
    procedure LayoutChildren; virtual;
    function GetSizeInfo: TW3ControlSizeInfo; virtual;
    function GetChildrenSortedByYPos: TW3ComponentArray; virtual;
    procedure Invalidate; virtual;

  published
    property OnResize: TNotifyEvent read FOnResize write _setResize;
    property OnMouseDown: TMouseButtonEventead FOnMouseDown write _setMouseDown;
    property OnMouseUp: TMouseButtonEventd FOnMouseUp write _setMouseUp;
    property OnMouseMove: TMouseEventvent read FOnMouseMove write _setMouseMove;
    property OnMouseEnter: TMouseEventEvent read FOnMouseEnter write _setMouseEnter;
    property OnMouseExit: TMouseEventvent read FOnMouseExit write _setMouseExit;
    property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write _setMouseWheel;
    property OnClick: TNotifyEventvent read FOnClick write _setMouseClick;
    property OnDblClick: TNotifyEventckEvent read FOnDblClick write _setMouseDblClick;
    property OnContextPopup : TContextPopupEvent read FOnContextPopup write _setContextPopup;
    property OnKeyDown: TKeyDownEvent read FOnKeyDown write _setKeyDown;
    property OnKeyUp: TKeyUpEvent read FOnKeyUp write _setKeyUp;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write _setKeyPress;
    property OnAnimationBegins: TNotifyEventginsEvent read FOnAnimationBegins write _setAnimationBegins;
    property OnAnimationEnds: TNotifyEventdsEvent read FOnAnimationEnds write _setAnimationEnds;
    property OnChanged: TNotifyEventt read FOnChanged write _setChanged;
    property OnGotFocus: TNotifyEventnt read FOnGotFocus write _setGotFocus;
    property OnLostFocus: TNotifyEventent read FOnLostFocus write _setLostFocus;
    property OnTouchBegin: TTouchBeginEvent read FOnTouchBegins write _setTouchBegins;
    property OnTouchMove: TTouchMoveEvent read FOnTouchMoves write _setTouchMoves;
    property OnTouchEnd: TTouchEndEvent read FOnTouchEnds write _setTouchEnds;
    property OnGestureStart:TGestureStartEvent read FOnGestureStart write _setGestureStart;
    property OnGestureChange:TGestureChangeEvent read FOnGestureChange write _setGestureChange;
    property OnGestureEnd:TGestureEndEvent read FOnGestureEnd write _setGestureEnd;

    property Enabled: Boolean read getEnabled write setEnabled;
    property Angle: Float read FAngle write setAngle;
    property Zoom: Float read getZoom write setZoom;
    property BorderRadius: Integer read getBorderRadius write setBorderRadius;
    property StyleClass: String read getStyleClass write setStyleClass;
    property Visible$1: Boolean read getVisible write SetVisible;
    property Left$1: Integer read GetLeft write setLeft;
    property Top$1: Integer read GetTop write setTop;
    property Width$1: Integer read GetWidth write SetWidth;
    property Height$1: Integer read GetHeight write setHeight;
    property Focused: Boolean read gethasFocus;
  end;

  TW3GraphicControl = class(TW3CustomControl)
  private
    FContext$2 : TW3CustomGraphicContext;
    FCanvas : TW3Canvas;
    FOnPaint : TPaintEvent;
    FDirty : Boolean;
    function GetDC: THandle;
  protected
    function makeElementTagObj: THandle; override;
    procedure SetWidth(aValue$52: Integer); override;
    procedure setHeight(aValue$51: Integer); override;
    procedure Paint; virtual;
    procedure Resize; override;
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    property Canvas: TW3Canvas read FCanvas;
    property Context: TW3CustomGraphicContext read FContext;
    property DC: THandle read GetDC;
    procedure Invalidate; override;
    procedure Refresh;
  published
    property OnPaint: TPaintEvent read FOnPaint write FOnPaint;
  end;

  TW3AnimationFrame = class static
    private
      class var vScheduledControls : array of TW3GraphicControl;
      class var vScheduledCallbacks : TProcedureRefArray;
      class var vOnPerform : TProcedureRefArray;
      class var vPending : Boolean;

    protected
      class procedure Perform; static;

    public
      class procedure ScheduleRefresh(control : TW3GraphicControlTW3GraphicControl); static;
      class procedure ScheduleCallback(callback : TProcedureRefTProcedureRef); static;

      property OnPerform : TProcedureRefArray read vOnPerform;
  end;

implementation

{ **************************************************************************** }
{ EW3TagObj                                                                    }
{ **************************************************************************** }

class procedure EW3TagObj.RaiseCntErrMethod(methName: String; instance: TObjectTObject; msg: String);
begin
   raise EW3TagObj.CreateFmt(CNT_ERR_METHOD,
                             [methName,
                              if instance<>nil then instance.ClassName else 'nil',
                              msg]);
end;

{ **************************************************************************** }
{ TShiftState                                                           }
{ **************************************************************************** }

function TShiftState.CheckShiftStateEnum(value$2: TShiftStateEnumTShiftStateEnum): Boolean;
begin
   if FEvent=nil then
      Result:=False
   else case value$2 of
      ssShift : Result:=FEvent.shiftKey;
      ssAlt : Result:=FEvent.altKey;
      ssCtrl : Result:=FEvent.ctrlKey;
      ssMeta : Result:=FEvent.metaKey;
      ssLeft : Result:=((FMouseButtons and 1)<>0);
      ssRight : Result:=((FMouseButtons and 4)<>0);
      ssMiddle : Result:=((FMouseButtons and 2)<>0);
   end;
end;

procedure TShiftState.SetKeyStateEvent(evt$8 : JKeyStateEventJKeyStateEvent);
begin
   FEvent:=evt$8;
   FMouseEvent:=nil;
end;

procedure TShiftState.SetMouseEvent(evt$9 : MouseEventMouseEvent);
begin
   FEvent:=evt$9;
   FMouseEvent:=evt$9;
end;

class function TShiftState.Current : TShiftState;
begin
   if vCurrent=nil then
      vCurrent:=TShiftState.Create;
   Result:=vCurrent;
end;

{ **************************************************************************** }
{ TW3ControlSizeInfo                                                           }
{ **************************************************************************** }

function TW3ControlSizeInfo.ToString: String;
begin
  Result := 'Width:' +   IntToStr(Self.siWidth) + #13
        +'Height:' +  IntToStr(Self.siHeight) + #13
        +'ClientWidth:' +  IntToStr(Self.siClientWidth) + #13
        +'ClientHeight:' +  IntToStr(Self.siClientHeight) + #13
        +'OffsetWidth:' +  IntToStr(Self.siOffsetWidth) + #13
        +'OffsetHeight:' +  IntToStr(Self.siOffsetHeight) + #13;
end;

{ **************************************************************************** }
{ TW3AnimationFrame                                                            }
{ **************************************************************************** }

class procedure TW3AnimationFrame.ScheduleRefresh(control : TW3GraphicControlTW3GraphicControl);
begin
   vScheduledControls.Add(control);
   if not vPending then
      w3_RequestAnimationFrame(Perform);
end;

class procedure TW3AnimationFrame.ScheduleCallback(callback : TProcedureRefTProcedureRef);
begin
   vScheduledCallbacks.Add(callback);
   if not vPending then
      w3_RequestAnimationFrame(Perform);
end;

class procedure TW3AnimationFrame.Perform;
var
   i$2 : Integer;
begin
   if vScheduledCallbacks.Count>0 then begin
      var callbacks := vScheduledCallbacks;
      vScheduledCallbacks := [];
      for i$2:=0 to High(callbacks) do
         callbacks[i$2]();
   end;
   if vScheduledControls.Count>0 then begin
      var controls := vScheduledControls;
      vScheduledControls := [];
      for i$2:=0 to High(controls) do
         controls[i$2].Refresh;
   end;
   for i$2:=0 to High(vOnPerform) do
      vOnPerform[i$2]();
end;

{ **************************************************************************** }
{ TW3Constraints                                                               }
{ **************************************************************************** }

function  TW3Constraints.AcceptParent(aObject$3:TObjectTObject): Boolean;
begin
  Result := Assigned(aObject$3) and (aObject$3 is TW3TagObj);
end;

function  TW3Constraints.GetMinWidth: Integer;
var
  mRef$15: THandle;
begin
  mRef$15 := TW3MovableControl(Owner$1).Handle;
  if (mRef$15) then
    Result := w3_getStyleAsInt(mRef$15,'min-width');
end;

function  TW3Constraints.GetMinHeight: Integer;
var
  mRef$14: THandle;
begin
  mRef$14 := TW3MovableControl(Owner$1).Handle;
  if (mRef$14) then
    Result := w3_getStyleAsInt(mRef$14,'min-height');
end;

procedure TW3Constraints.setMinWidth(aValue$56: Integer);
var
  mRef$19: THandle;
begin
  mRef$19 := TW3MovableControl(Owner$1).Handle;
  if (mRef$19) then
    mRef$19.style['min-width'] := TInteger.toPxStr(aValue$56);
end;

procedure TW3Constraints.setMinHeight(aValue$55: Integer);
var
  mRef$18: THandle;
begin
  mRef$18 := TW3MovableControl(Owner$1).Handle;
  if (mRef$18) then
    mRef$18.style['min-height'] := TInteger.toPxStr(aValue$55);
end;

function  TW3Constraints.GetMaxWidth: Integer;
var
  mRef$13: THandle;
begin
  mRef$13 := TW3MovableControl(Owner$1).Handle;
  if (mRef$13) then
    Result := w3_getStyleAsInt(mRef$13,'max-width');
end;

function  TW3Constraints.GetMaxHeight: Integer;
var
  mRef$12: THandle;
begin
  mRef$12 := TW3MovableControl(Owner$1).Handle;
  if (mRef$12) then
    Result := w3_getStyleAsInt(mRef$12,'max-height');
end;

procedure TW3Constraints.setMaxWidth(aValue$54: Integer);
var
  mRef$17: THandle;
begin
  mRef$17 := TW3MovableControl(Owner$1).Handle;
  if (mRef$17) then
    mRef$17.style['max-width'] := TInteger.toPxStr(aValue$54);
end;

procedure TW3Constraints.setMaxHeight(aValue$53: Integer);
var
  mRef$16: THandle;
begin
  mRef$16 := TW3MovableControl(Owner$1).Handle;
  if (mRef$16) then
    mRef$16.style['max-width'] := TInteger.toPxStr(aValue$53);
end;

{ **************************************************************************** }
{ TW3ControlBackground                                                         }
{ **************************************************************************** }

function TW3ControlBackground.AcceptParent(aObject$2:TObjectTObject): Boolean;
begin
  Result := Assigned(aObject$2)
  and (aObject$2 is TW3MovableControl);
end;

procedure TW3ControlBackground.FromImageData(const aImgStr: String);
var
  mRef: THandle;
begin
  mRef := TW3MovableControl(Owner$1).Handle;
  mRef.style['backgroundImage'] := aImgStr;
  mRef.style['backgroundSize'] := 'auto auto';
end;

procedure TW3ControlBackground.FromURL(const aURL: String);
var
  mRef: THandle;
begin
  mRef := TW3MovableControl(Owner$1).Handle;
  mRef.style['backgroundImage'] := w3_NameToUrlStr(aURL);
  mRef.style['backgroundSize'] := 'auto auto';
end;

procedure TW3ControlBackground.FromColor(const aValue:TColor);
var
  mRef: THandle;
begin
  mRef := TW3MovableControl(Owner$1).Handle;
  mRef.style['backgroundColor'] := ColorToWebStr(aValue);
end;

function TW3ControlBackground.ToColor:TColor;
var
  mRef: THandle;
begin
  mRef := TW3MovableControl(Owner$1).Handle;
  Result := StrToColor(w3_getStyleAsStr(mRef,'backgroundColor'));
end;

function TW3ControlBackground.ToURL: String;
var
  mRef: THandle;
begin
  mRef := TW3MovableControl(Owner$1).Handle;
  Result := w3_getStyleAsStr(mRef,'backgroundImage');
end;



{ **************************************************************************** }
{ TW3TagObj                                                                    }
{ **************************************************************************** }

constructor TW3TagObj.Create$3;
begin
  inherited Create;
  FObjReady := False;

  try
    FTagId := makeElementTagId;
    FHandle := makeElementTagObj;
  except
    on e: Exception do
      EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,e$2.Message);
  end;

  (* Avoid affecting window->document->body *)
  if TVariant.AsObject(FHandle)<>TVariant.AsObject(BrowserAPI.GetBody) then
  begin
    (* apply tag-id *)
    if Length(FTagId)>0 then
      w3_setAttrib(FHandle,'id',FTagId);
  end;

  (* setup initial styles, if any *)
  StyleTagObject;

  (* setup decendant instances *)
  BeginUpdate;
  try
    InitializeObject;
  finally
    EndUpdate;
  end;

  FObjReady := True;
end;

destructor TW3TagObj.Destroy;
begin
  {$IFDEF DEBUG}
  writeln(ClassName + ' destroying');
  {$ENDIF}
  if (Handle) then
  //if varIsValidRef(FHandle) then
  begin
    try
      UnHookEvents;
      RemoveFrom;
    finally
      FinalizeObject;
      FTagId := '';
      FHandle := Null;
    end;
  end;
  inherited Destroy;
end;

function TW3TagObj.getUpdating: Boolean;
begin
  Result := FUpdating>0;
end;

procedure TW3TagObj.BeginUpdate;
begin
  Inc(FUpdating);
end;

procedure TW3TagObj.EndUpdate;
begin
  if FUpdating>0 then
  begin
    Dec(FUpdating);
    if FUpdating=0 then
      AfterUpdate;
  end;
end;

procedure TW3TagObj.AfterUpdate;
begin
end;

procedure TW3TagObj.UnHookEvents;
begin
  if (FHandle) then
  begin
    FHandle.onresize := Null;
    FHandle.onselectstart := Null;
    FHandle.onfocus := Null;
    FHandle.onblur := Null;
    FHandle.onchange := Null;
    FHandle.onmousedown := Null;
    FHandle.onmouseup := Null;
    FHandle.onmousemove := Null;
    FHandle.onmouseover := Null;
    FHandle.onmouseout := Null;
    FHandle.onclick := Null;
    FHandle.ondblclick := Null;
    FHandle.onkeydown := Null;
    FHandle.onkeyup := Null;
    FHandle.onkeypress := Null;
    FHandle.webkitAnimationStart := Null;
    FHandle.webkitAnimationEnd := Null;
  end;
end;

function TW3TagObj.getInnerHTML: String;
begin
  if (FHandle) then
    Result := TVariant.AsString(FHandle.innerHTML);
end;

procedure TW3TagObj.setInnerHTML(aValue$14: String);
begin
  if (FHandle) then
    FHandle.innerHTML := aValue$14;
end;

function TW3TagObj.getInnerText: String;
begin
  if (FHandle) then
    Result := TVariant.AsString(FHandle.innerText);
end;

procedure TW3TagObj.setInnerText(aValue: String);
begin
  if (FHandle) then
    FHandle.innerText := aValue;
end;

procedure TW3TagObj.InitializeObject;
begin
end;

procedure TW3TagObj.FinalizeObject;
begin
end;

procedure TW3TagObj.StyleTagObject;
begin
  (* This is the same as setting: Visible := False.
     The reason we set this here, is because javascript
     is not "bool" with its values. All values are of
     type variant, so they can be set, but also unassigned.
     So we set the negative value here, and then call
     "visible := True" further up the chain *)

  if (FHandle) then
  begin
    FHandle.style['visibility'] := 'hidden';
    FHandle.style['display'] := 'none';

    FHandle.style['position'] := 'absolute';
    FHandle.style['overflow'] := 'hidden';

    FHandle.style['left'] := '0px';
    FHandle.style['top'] := '0px';
  end;
end;

function TW3TagObj.makeElementTagId: String;
begin
  Result := w3_getUniqueObjId;
end;

function TW3TagObj.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('div');
end;

function TW3TagObj.getAttached: Boolean;
begin
  Result := VarIsValidRef(FOwner);
end;

procedure TW3TagObj.InsertInto(const OwnerHandle:THandle);
begin
  //if varIsValidRef(OwnerHandle) then
  if (OwnerHandle) then
  begin
    //if varIsValidRef(FHandle) then
    if (FHandle) then
    begin
      try
        //if varIsValidRef(FOwner) then
        if (FOwner) then
        RemoveFrom;
        w3_setElementParentByRef(FHandle,OwnerHandle);

        FOwner := OwnerHandle;

      except
        on e: Exception do
          EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,e$3.Message);
      end;
    end else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,CNT_ERR_TAGREF_ISNIL);
  end else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'owner is NIL error');
end;

procedure TW3TagObj.RemoveFrom;
begin
  if (FOwner) then begin
    if (FHandle) then begin

      try
        w3_RemoveElementByRef(FHandle,FOwner);
      except
        on e: Exception do
          EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,e$4.Message);
      end;

      FOwner := Unassigned; //was null

    end else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,CNT_ERR_TAGREF_ISNIL);
  end;
end;

{ **************************************************************************** }
{ TW3Component                                                                 }
{ **************************************************************************** }

constructor TW3Component.Create$4(AOwner$1: TW3ComponentTW3Component);
begin
  (* Keep parent *)
  FParent := AOwner$1;

  (* We have to call this here, otherwise FParent will be NIL
     when InitiateObject is called *)
  inherited Create$3;

  (* register with parent if valid *)
  if FParent<>nil then
    FParent.RegisterChild(Self);
end;

procedure TW3Component.CBNoBehavior;
begin
  asm
    if (event.preventDefault) event.preventDefault();
    return false;
  end;
end;

function TW3Component.ChildByName(const compName: string): TW3Component;
begin
  var lcName := LowerCase(Trim$_String_(compName));
  for var i$1 := 0 to GetChildCount - 1 do begin
    Result := GetChildObject(i$1);
    if LowerCase(Result.Name$3) = lcName then
      exit;
  end;
  Result := nil;
end;

function TW3Component.ChildByHandle(Const aHandle:THandle):TW3Component;
var
  x:    Integer;
  mObj: TW3Component;
Begin
  Result:=NIL;
  for x:=0 to GetChildCount-1 do
  begin
    mObj:=GetChildObject(x);
    if mObj.Handle = aHandle then
    begin
      Result:=mObj;
      break;
    end;
  end;
end;

procedure TW3Component.EnumChildren(childProc: procedure (child: TW3ComponentTW3Component));
begin
  for var i := 0 to GetChildCount - 1 do
    childProc(GetChildObject(i));
  //replace with the following code to crash the compiler
//  for var child in FChildren do
//    childProc(child);
end;

function TW3Component.TopLevelParent : TW3Component;
begin
  Result:=Parent;
  while Result.Parent<>nil do
    Result:=Result.Parent;
end;

procedure TW3Component.InitializeObject;
begin
  inherited InitializeObject;
end;

procedure TW3Component.FinalizeObject;
begin
  (* Release our child objects. They will unregister by themselves *)
  FreeChildren;

  (* Unregister ourselves with parent *)
  if FParent<>nil then
    FParent.UnRegisterChild(Self);

  (* release our objectlist *)
  FChildren.clear;

  inherited FinalizeObject;
end;

function TW3Component.GetChildCount: Integer;
begin
  Result := FChildren.Length;
end;

function TW3Component.GetChildObject(index: Integer): TW3Component;
begin
  Result := FChildren[index];
end;

procedure TW3Component.SetName(Value$4: String);
begin
  FName := Value$4;
end;

procedure TW3Component.FreeChildren;
begin
  {$IFDEF DEBUG}
  writeln('Enter FreeChildren');
  try
  {$ENDIF}
    try
      while FChildren.Count > 0 do
      begin
        var oldCount := FChildren.Count;
        FChildren[0].Free;
        if oldCount = FChildren.Count then
          // if the child was not properly connected to the parent, it will
          // not remove itself from the list automatically
          FChildren.Delete(0);
      end;
    finally
      FChildren.clear;
    end;
  {$IFDEF DEBUG}
  finally
    writeln('Leave FreeChildren');
  end;
  {$ENDIF}
end;

procedure TW3Component.ChildAdded(aChild:TW3ComponentTW3Component);
Begin
end;

Procedure TW3Component.ChildRemoved(aChild$1:TW3ComponentTW3Component);
Begin
end;

procedure TW3Component.RegisterChild(aChild$2: TW3ComponentTW3Component);
begin
  if aChild$2<>nil then
  begin
    if FChildren.indexOf(aChild$2)<0 then
    begin
      FChildren.Add(aChild$2);
      aChild$2.InsertInto(Self.Handle);
      ChildAdded(aChild$2);
    end;
  end;
end;

procedure TW3Component.UnRegisterChild(aChild$3: TW3ComponentTW3Component);
var
  mIndex$1: Integer;
begin
  if aChild$3<>nil then
  begin
    mIndex$1 := FChildren.indexOf(aChild$3);
    if mIndex$1>=0 then
    Begin
      FChildren.delete(mIndex$1);
      ChildRemoved(aChild$3);
    end;
    aChild$3.RemoveFrom;
  end;
end;



{ **************************************************************************** }
{ TDocumentBody                                                                }
{ **************************************************************************** }

procedure TDocumentBody.StyleTagObject;
begin
//
end;

function TDocumentBody.makeElementTagId: String;
begin
  Result := '';
end;

procedure TDocumentBody.CBReSize;
begin
  if Assigned(FOnReSize) then
  FOnReSize(Self);
end;

procedure TDocumentBody._setOnResize(aValue:TNotifyEventTNotifyEvent);
var
  mRef: TProcedureRef;
begin
  if Assigned(aValue) then
    mRef := CBResize
  else mRef := CBNoBehavior;
  w3_bind2(Handle,'onresize',mRef);
  FOnReSize := aValue;
end;

function TDocumentBody.makeElementTagObj:THandle;
begin
  Result := BrowserAPI.GetBody;
end;

function TDocumentBody.getClientLeft: Integer;
begin
  Result := 0;
end;

function TDocumentBody.getClientTop: Integer;
begin
  Result := 0;
end;

function TDocumentBody.getClientWidth: Integer;
begin
  Result := w3_getStyleAsInt(BrowserAPI.GetBody,'width');
end;

function TDocumentBody.getClientHeight: Integer;
begin
  Result := w3_getStyleAsInt(BrowserAPI.GetBody,'height');
end;

function TDocumentBody.getClientRect:TRect;
begin
  Result.Left$3 := 0;
  Result.Top$3 := 0;
  Result.Right$1 := w3_getStyleAsInt(BrowserAPI.GetBody, 'width')-1;
  Result.Right$1 := w3_getStyleAsInt(BrowserAPI.GetBody, 'height')-1;
end;

function TDocumentBody.getWidth$5: Integer;
var
  mHandle$3:  THandle;
begin
  mHandle$3 := BrowserAPI.GetWindow;
  if (mHandle$3) then
    Result := TVariant.AsInteger(mHandle$3.innerWidth)
  else Result := 0;
end;

function TDocumentBody.getHeight$4: Integer;
var
  mHandle$2: THandle;
begin
  mHandle$2 := BrowserAPI.GetWindow;
  if (mHandle$2) then
    Result := TVariant.AsInteger(mHandle$2.innerHeight)
  else Result := 0;
end;



{ **************************************************************************** }
{ TW3ControlFont                                                               }
{ **************************************************************************** }

constructor TW3ControlFont.Create$37(AOwner$2: TW3CustomControlTW3CustomControl);
begin
  inherited Create;
  if Assigned(AOwner$2) then
    FOwner$4 := AOwner$2
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'Owner was NIL error');
end;

function TW3ControlFont.GetHandle$1:THandle;
begin
  Result := FOwner$4.Handle;
end;



{ **************************************************************************** }
{ TW3ScrollInfo                                                                }
{ **************************************************************************** }

function TW3ScrollInfo.AcceptParent(aObject$1:TObjectTObject): Boolean;
begin
  Result := Assigned(aObject$1)
  and (aObject$1 is TW3TagObj);
end;

function TW3ScrollInfo.ToString: String;
begin
  Result := Format(
      'OffsetX=%d' + #13
    + 'OffsetY=%d' + #13
    + 'ScrollWidth=%d' + #13
    + 'ScrollHeight=%d' + #13,
    [getScrollLeft,getScrollTop,getScrollWidth,getScrollHeight]);
end;

procedure TW3ScrollInfo.ScrollX(aLeft: Integer);
var
  mRef: THandle;
begin
  mRef := TW3TagObj(Owner$1).Handle;
  if (mRef) then
    mRef.scrollLeft := TInteger.toPxStr(aLeft)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

procedure TW3ScrollInfo.ScrollY(aTop: Integer);
var
  mRef: THandle;
begin
  mRef := TW3TagObj(Owner$1).Handle;
  if (mRef) then
    mRef.scrollTop := TInteger.toPxStr(aTop)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

function TW3ScrollInfo.getScrollWidth: Integer;
var
  mRef$4: THandle;
begin
  mRef$4 := TW3TagObj(Owner$1).Handle;
  if (mRef$4) then
    Result := TVariant.AsInteger(mRef$4.scrollWidth)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

function TW3ScrollInfo.getScrollHeight: Integer;
var
  mRef$1: THandle;
begin
  mRef$1 := TW3TagObj(Owner$1).Handle;
  if (mRef$1) then
    Result := TVariant.AsInteger(mRef$1.scrollHeight)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

function TW3ScrollInfo.getScrollLeft: Integer;
var
  mRef$2: THandle;
begin
  mRef$2 := TW3TagObj(Owner$1).Handle;
  if (mRef$2) then
    Result := TVariant.AsInteger(mRef$2.scrollLeft)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

function TW3ScrollInfo.getScrollTop: Integer;
var
  mRef$3: THandle;
begin
  mRef$3 := TW3TagObj(Owner$1).Handle;
  if (mRef$3) then
    Result := TVariant.AsInteger(mRef$3.scrollTop)
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

procedure TW3ScrollInfo.ScrollTo(aLeft$1,aTop$1: Integer);
var
  mRef$5: THandle;
begin
  mRef$5 := TW3TagObj(Owner$1).Handle;
  if (mRef$5) then
  begin
    mRef$5.scrollLeft := aLeft$1;
    mRef$5.scrollTop := aTop$1;
  end
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid owner handle error');
end;

{ **************************************************************************** }
{ TW3GraphicControl                                                            }
{ **************************************************************************** }

procedure TW3GraphicControl.InitializeObject;
begin
  inherited;
  FContext$2 := TW3ControlGraphicContext.Create$30(Handle);
  FCanvas := TW3Canvas.Create$32(FContext$2);
end;

procedure TW3GraphicControl.FinalizeObject;
begin
  FCanvas.Free;
  FContext$2.Free;
  inherited;
end;

function TW3GraphicControl.GetDC:THandle;
begin
  if (Handle) then
    Result := Handle.getContext('2d')
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid control handle error');
end;

procedure TW3GraphicControl.SetWidth(aValue$52: Integer);
begin
  inherited SetWidth(aValue$52);
  if (Handle) then
  w3_setAttrib(Handle,'width',TInteger.toPxStr(aValue$52))
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid control handle error');
end;

procedure TW3GraphicControl.setHeight(aValue$51: Integer);
begin
  inherited setHeight(aValue$51);
  if (Handle) then
  w3_setAttrib(Handle,'height',TInteger.toPxStr(aValue$51))
  else EW3TagObj.RaiseCntErrMethod({$I %FUNCTION%},Self,'invalid control handle error');
end;

function TW3GraphicControl.makeElementTagObj:THandle;
begin
  Result := w3_createHtmlElement('canvas');
end;

procedure TW3GraphicControl.Paint;
begin
   if Assigned(FOnPaint) then
      FOnPaint(Self,FCanvas);
end;

procedure TW3GraphicControl.Resize;
begin
  inherited Resize;
  (* Canvas requires attributes to match element bounds *)
  w3_setAttrib(Handle,'width',w3_getStyle(Handle,'width'));
  w3_setAttrib(Handle,'height',w3_getStyle(Handle,'height'));
end;

procedure TW3GraphicControl.Invalidate;
begin
   if not FDirty then begin
      FDirty:=True;
      TW3AnimationFrame.ScheduleRefresh(Self);
   end;
end;

procedure TW3GraphicControl.Refresh;
begin
   FDirty:=False;
   if (not Updating) and (FCanvas<>nil) and (FContext$2<>nil) and (Self.Visible$1) then
      Paint;
end;

{ **************************************************************************** }
{ TW3MovableControl                                                            }
{ **************************************************************************** }

procedure TW3MovableControl.InitializeObject;
begin
  inherited;
  (* set some default values *)
  FAlpha := 255;
  FColor := clNone;
  FTransparent := False;
end;


function TW3MovableControl.ControlAtPoint(x,y:Integer;
         Const Recursive:Boolean):TW3Component;
var
  mPos:     TPoint;
  mTarget:  THandle;
  mIndex:   Integer;
  mControl: TW3Component;
Begin
  Result:=NIL;
  mPos:=ClientToScreen(TPoint.Create$16(x,y));
  asm
    @mTarget = document.elementFromPoint(@mPos.X$1, @mPos.Y$1);
  end;
  if (mTarget) then
  Begin
    Result:=ChildByHandle(mTarget);
    if Result=NIL then
    Begin
      for mIndex:=0 to GetChildCount-1 do
      Begin
        mControl:=GetChildObject(mIndex);
        Result:=mControl.ChildByHandle(mTarget);
        if Result<>NIl then
        Break;
      end;
    end;
  end;
end;

function TW3MovableControl.ControlAtPoint(Const aPoint:TPointTPoint;
         Const Recursive:Boolean):TW3Component;
var
  mPos:     TPoint;
  mTarget:  THandle;
  mIndex:   Integer;
  mControl: TW3Component;
Begin
  Result:=NIL;
  mPos:=ClientToScreen(aPoint);
  asm
    @mTarget = document.elementFromPoint(@mPos.X$1, @mPos.Y$1);
  end;
  if (mTarget) then
  Begin
    Result:=ChildByHandle(mTarget);
    if Result=NIL then
    Begin
      for mIndex:=0 to GetChildCount-1 do
      Begin
        mControl:=GetChildObject(mIndex);
        Result:=mControl.ChildByHandle(mTarget);
        if Result<>NIl then
        Break;
      end;
    end;
  end;
end;


class function TW3MovableControl.supportAdjustment:Boolean;
begin
  Result:=True;
end;

procedure TW3MovableControl.AdjustToParentBox;
var
  x$4:      Integer;
  dx,dy:  Integer;
  mChild: TW3Component;
  mCtrl:  TW3MovableControl;
begin
  if (Handle) then
  begin
    if not FAdjusted then
    begin
      FAdjusted := true;
      dx := Border.getHSpace;
      dy := Border.getVSpace;
      for x$4 := 0 to GetChildCount-1 do
      begin
        mChild := GetChildObject(x$4);
        if (mChild is TW3MovableControl) then
        begin
          mCtrl := TW3MovableControl(mChild);
          if mCtrl.supportAdjustment then
          begin
            if (dx>0) or (dy>0) then
            mCtrl.SetSize(mCtrl.Width-dx,mCtrl.Height-dy);
            w3_Callback(mCtrl.AdjustToParentBox,1);
          end;
        end;
      end;
    end;
  end;
end;

function TW3MovableControl.ClientWidth: Integer;
begin
  if (Handle) then
  begin
    if VarIsValidRef(Handle.clientWidth) then
    begin
      Result := TVariant.AsInteger(Handle.clientWidth);
      if TVariant.IsNAN(Result) or (Result=0) then
        Result := Width;
    end else Result := Width;
  end;
end;

function TW3MovableControl.ClientHeight: Integer;
begin
  if (Handle) then
  begin
    if VarIsValidRef(Handle.clientHeight) then
    begin
      Result := TVariant.AsInteger(Handle.clientHeight);
      if TVariant.IsNAN(Result) or (Result=0) then
        Result := Width;
    end else Result := Width;
  end;
end;

function TW3MovableControl.ClientRect : TRect;
begin
   Result.Right$1 := ClientWidth;
   Result.Bottom$1 := ClientHeight;
end;

function TW3MovableControl.ScreenRect : TRect;
begin
   if (Handle) then begin
      var elem := Handle;
      while True do begin
         Result.Left$3 += elem.offsetLeft;
         Result.Top$3  += elem.offsetTop;
         elem := elem.offsetParent;
         if elem then begin
            Result.Left$3 -= elem.scrollLeft;
            Result.Top$3  -= elem.scrollTop;
         end else break;
      end;
      Result.Right$1 := Result.Left$3 + Handle.offsetWidth;
      Result.Bottom$1 := Result.Top$3 + Handle.offsetHeight;
   end;
end;

function TW3MovableControl.ClientToScreen(pt: TPointTPoint): TPoint;
begin
  var sr := ScreenRect;
  Result := TPoint.Create$16(pt.X$1 + sr.Left$3, pt.Y$1 + sr.Top$3);
end;

function TW3MovableControl.ScreenToClient(pt: TPointTPoint): TPoint;
begin
  var sr := ScreenRect;
  Result := TPoint.Create$16(pt.X$1 - sr.Left$3, pt.Y$1 - sr.Top$3);
end;

procedure TW3MovableControl.FinalizeObject;
begin
  if Assigned(FBackground) then
    FBackground.Free;

  if Assigned(FBorders) then
    FBorders.Free;

  if Assigned(FConstraints) then
    FConstraints.Free;

  inherited;
end;

function TW3MovableControl.getConstraints: TW3Constraints;
begin
  if FConstraints=nil then
     FConstraints := TW3Constraints.Create$7(Self);
  Result := FConstraints;
end;

function TW3MovableControl.getBorder: TW3Borders;
begin
  if FBorders=nil then
  FBorders := TW3Borders.Create$7(Self);
  Result := FBorders;
end;

procedure TW3MovableControl.AfterUpdate;
begin
  FWasMoved := False;
  FWasSized := False;
end;

function TW3MovableControl.GetBackGround: TW3ControlBackground;
begin
  if FBackground=nil then
  FBackground := TW3ControlBackground.Create$7(Self);
  Result := FBackground;
end;

function TW3MovableControl.getVisible: Boolean;
var
  mValue$2: String;
begin
  mValue$2 := w3_getStyleAsStr(Handle,'visibility');
  Result := LowerCase(mValue$2)='visible';
end;

class function TW3MovableControl.DisplayMode : String;
begin
   Result := USE_DISPLAY_MODE;
end;

procedure TW3MovableControl.SetVisible(const aValue$22:Boolean);
begin
  BeginUpdate;
  case aValue$22 of
  true:
    begin
      Handle.style['display'] := DisplayMode;
      Handle.style['visibility'] := 'visible';
      //Note: Not sure I need the call below anymore.
      //      This was added to defeat a bug in Safari where
      //      visibility did not work while creating a control
      //      until you actually alter the object
      SetWasSized;
    end;
  false:
    begin
      Handle.style['display'] := 'none';
      Handle.style['visibility'] := 'hidden';
    end;
  end;
  EndUpdate;
end;

function TW3MovableControl.getBoundsRect:TRect;
begin
  Result.Left$3 := GetLeft;
  Result.Top$3 := GetTop;
  Result.Right$1 := Result.Left$3 + GetWidth;
  Result.Bottom$1 := Result.Top$3 + GetHeight;
end;

function TW3MovableControl.GetLeft: Integer;
begin
  Result := w3_getStyleAsInt(Handle,'left');
end;

procedure TW3MovableControl.setLeft(const aValue$18: Integer);
begin
  BeginUpdate;
  Handle.style['left'] := TInteger.toPxStr(aValue$18);
  SetWasMoved;
  EndUpdate;
end;

function TW3MovableControl.GetTop: Integer;
begin
  Result := w3_getStyleAsInt(Handle,'top');
end;

procedure TW3MovableControl.setTop(const aValue$19: Integer);
begin
  BeginUpdate;
  Handle.style['top'] := TInteger.toPxStr(aValue$19);
  SetWasMoved;
  EndUpdate;
end;

function TW3MovableControl.GetWidth: Integer;
begin
  //Result := w3_getStyleAsInt(Handle,'width');
  if (Handle) then
     Result:=TVariant.AsInteger(Handle.offsetWidth)
  else Result:=0;
end;

procedure TW3MovableControl.SetWidth(aValue$23: Integer);
begin
  aValue$23:=TInteger.EnsureRange(aValue$23,0,MAX_INT);
  if aValue$23<>GetWidth then
  begin
    BeginUpdate;
    Handle.style['width'] := TInteger.toPxStr(aValue$23);
    SetWasSized;
    EndUpdate;
  end;
end;

function TW3MovableControl.GetHeight: Integer;
begin
  //Result := w3_getStyleAsInt(Handle,'height');
  if (Handle) then
     Result:=TVariant.AsInteger(Handle.offsetHeight)
  else Result:=0;
end;

procedure TW3MovableControl.setHeight(aValue$17: Integer);
begin
  aValue$17:=TInteger.EnsureRange(aValue$17,0,MAX_INT);
  if aValue$17<>GetHeight then
  begin
    BeginUpdate;
    Handle.style['height'] := TInteger.toPxStr(aValue$17);
    SetWasSized;
    EndUpdate;
  end;
end;

function TW3MovableControl.GetWasMoved: Boolean;
begin
  Result := FWasMoved;
end;

function TW3MovableControl.GetWasSized: Boolean;
begin
  Result := FWasSized;
end;

procedure TW3MovableControl.SetWasMoved;
begin
  FWasMoved := true;
end;

procedure TW3MovableControl.SetWasSized;
begin
  FWasSized := true;
end;

procedure TW3MovableControl.Moved;
begin
end;

procedure TW3MovableControl.Resize;
begin
end;

procedure TW3MovableControl.MoveTo(aLeft$2,aTop$2: Integer);
begin
  aLeft$2 := TInteger.EnsureRange(aLeft$2,0,MAX_INT);
  aTop$2 := TInteger.EnsureRange(aTop$2,0,MAX_INT);
  BeginUpdate;
  Handle.style['left'] := TInteger.toPxStr(aLeft$2);
  Handle.style['top'] := TInteger.toPxStr(aTop$2);
  SetWasMoved;
  EndUpdate;
end;

procedure TW3MovableControl.SetBounds(aLeft$3,aTop$3,aWidth,aHeight: Integer);
var
  mSized: Boolean;
  mMoved: Boolean;
begin
  aWidth := TInteger.EnsureRange(aWidth,0,MAX_INT);
  aHeight := TInteger.EnsureRange(aHeight,0,MAX_INT);

  (* check if this results in a move call *)
  mMoved := (aLeft$3<>GetLeft) or (aTop$3<>GetTop);

  (* check if this results in a resize call *)
  mSized := (aWidth<>GetWidth) or (aHeight<>GetHeight);

  BeginUpdate;
  Handle.style['left'] := TInteger.toPxStr(aLeft$3);
  Handle.style['top'] := TInteger.toPxStr(aTop$3);
  Handle.style['width'] := TInteger.toPxStr(aWidth);
  Handle.style['height'] := TInteger.toPxStr(aHeight);
  if mMoved then SetWasMoved;
  if mSized then SetWasSized;
  EndUpdate;
end;

procedure TW3MovableControl.SetBounds(aRect: TRectTRect); 
begin
  SetBounds(aRect.Left$3, aRect.Top$3, aRect.Width$3, aRect.Height$3);
end;

procedure TW3MovableControl.SetSize(aWidth$1,aHeight$1: Integer);
begin
  aWidth$1 := TInteger.EnsureRange(aWidth$1,0,MAX_INT);
  aHeight$1 := TInteger.EnsureRange(aHeight$1,0,MAX_INT);
  if (aWidth$1<>Width)
  or (aHeight$1<>Height) then
  begin
    BeginUpdate;
    Handle.style['width'] := TInteger.toPxStr(aWidth$1);
    Handle.style['height'] := TInteger.toPxStr(aHeight$1);
    SetWasSized;
    EndUpdate;
  end;
end;

procedure TW3MovableControl.setUseAlpha(const aValue$21:Boolean);
var
  mBlend$1: Float;
begin
  if aValue$21<>FUseAlpha then
  begin
    FUseAlpha := aValue$21;
    case aValue$21 of
    true:   mBlend$1 := TInteger.EnsureRange(FAlpha,0,255) / 100;
    false:  mBlend$1 := 0.0;
    end;
    if FUseAlpha then
    Handle.style['opacity'] := mBlend$1 else
    Handle.style['opacity'] := 1.0;
  end;
end;

procedure TW3MovableControl.setAlpha(const aValue$15: Integer);
var
  mBlend: Float;
  {$IFDEF USE_NEW_ALPHA}
  x$5:  Integer;
  mChild$1: TW3Component;
  {$ENDIF}
begin
  //make sure alpha-range is OK
  FAlpha := TInteger.EnsureRange(aValue$15,0,255);

  // create blend if possible
  if FAlpha>0 then
    mBlend := (FAlpha / 100)
  else mBlend := 0.0;

  // apply alpha
  if FUseAlpha then
    Handle.style['opacity'] := mBlend;

  {$IFDEF USE_NEW_ALPHA}
  // Now apply alpha recursively to child objects
  for x$5 := 0 to GetChildCount-1 do
  begin
    mChild$1 := GetChildObject(x$5);
    if (mChild$1 is TW3CustomControl) then
      TW3CustomControl(mChild$1).Opacity := aValue$15;
  end;
  {$ENDIF}
end;

procedure TW3MovableControl.setTransparent(const aValue$20:Boolean);
var
  mText$1:  String;
begin
  if aValue$20<>FTransparent then
  begin
    BeginUpdate;
    FTransparent := aValue$20;
    if aValue$20 then
      mText$1 := ColorToStrA(FColor,0)
    else mText$1 := ColorToWebStr(FColor);
    Handle.style['backgroundColor'] := mText$1;
    SetWasMoved;
    EndUpdate;
  end;
end;

procedure TW3MovableControl.setColor(const aValue$16:TColor);
var
  mText: String;
begin
  if aValue$16<>FColor then
  begin
    FColor := aValue$16;
    if FTransparent then
      mText := ColorToStrA(FColor,0)
    else mText := ColorToWebStr(FColor);
    Handle.style['backgroundColor'] := mText;
  end;
end;



{ **************************************************************************** }
{ TW3CustomControl                                                             }
{ **************************************************************************** }

procedure TW3CustomControl.InitializeObject;
begin
  inherited InitializeObject;

  (* Keep Lookup PTR to internal function *)
  FNoBehavior := CBNoBehavior;

  //if Assigned(tagRef) then
  //begin
  w3_bind2(Handle,'onselectstart',CBNoBehavior);
  w3_bind2(Handle,'onfocus',CBFocused);
  w3_bind2(Handle,'onblur',CBLostFocus);
  //end;
end;

procedure TW3CustomControl.FinalizeObject;
begin
  if Assigned(FFont) then
  FFont.Free;

  if Assigned(FClassNames) then
  FClassNames.Free;

  if Assigned(FScrollInfo) then
  FScrollInfo.Free;

  if Assigned(FTouchData) then
  FTouchData.Free;

  if Assigned(FGestureData) then
  FGestureData.Free;

  inherited;
end;

function TW3CustomControl.GetSizeInfo: TW3ControlSizeInfo;
begin
  Result.siWidth := GetWidth;
  Result.siHeight := GetHeight;
  Result.siClientWidth := w3_getPropertyAsInt(Handle,'clientWidth');
  Result.siClientHeight := w3_getPropertyAsInt(Handle,'clientHeight');
  Result.siOffsetWidth := w3_getPropertyAsInt(Handle,'offsetWidth');
  Result.siOffsetHeight := w3_getPropertyAsInt(Handle,'offsetHeight');
end;

procedure TW3CustomControl.StyleTagObject;
begin
  inherited;
  setStyleClass(ClassName);
  Visible$1 := True;
end;

function TW3CustomControl.getFont: TW3ControlFont;
begin
  if FFont=nil then
  FFont := TW3ControlFont.Create$37(Self);
  Result := FFont;
end;

function TW3CustomControl.getZoom:Float;
begin
  Result := w3_getStyleAsFloat(Handle,'zoom');
end;

procedure TW3CustomControl.setZoom(aValue$26:Float);
begin
  w3_setStyle(Handle,'zoom',aValue$26);
end;

function TW3CustomControl.getClassNames: TW3CSSClassStyleNames;
begin
  if FClassNames=nil then
  FClassNames := TW3CSSClassStyleNames.Create$7(Self);
  Result := FClassNames;
end;

function TW3CustomControl.getScrollInfo: TW3ScrollInfo;
begin
  if FScrollInfo=nil then
  FScrollInfo := TW3ScrollInfo.Create$7(Self);
  Result := FScrollInfo;
end;

function TW3CustomControl.getEnabled: Boolean;
begin
  Result := Handle.disabled=false;
end;

procedure TW3CustomControl.setEnabled(aValue$25:Boolean);
  {$IFDEF USE_NEW_ENABLE}
  x:  Integer;
  mChild: TW3Component;
  {$ENDIF}
begin
  if aValue$25 then
  Handle.disabled := false else
  Handle.disabled := true;
  {$IFDEF USE_NEW_ENABLE}
  for x := 0 to getChildCount-1 do
  begin
    mChild := getChildObject(x);
    if (mChild is TW3CustomControl) then
    TW3CustomControl(mChild).enabled := aValue;
  end;
  {$ENDIF}
end;

procedure TW3CustomControl.CBFocused;
begin
  if Assigned(FOnGotFocus) then
  FOnGotFocus(Self);
end;

procedure TW3CustomControl.CBLostFocus;
begin
  if Assigned(FOnLostFocus) then
  FOnLostFocus(Self);
end;

function TW3CustomControl.GetZIndexAsInt(default$1: integer): integer;
begin
  Result := default$1;
  var mData$3: Variant = Handle.style['zIndex'];
  if (Handle) then begin
    if TVariant.IsNumber(mData$3) then
    begin
      asm
        @Result = Number(@mData$3);
      end;
    end else
    if TVariant.IsString(mData$3) then
    begin
      asm
        @Result = parseInt(@mData$3);
        if (isNaN(@Result)) @Result=@default$1;
      end;
    end;
  end;
end;

procedure TW3CustomControl.SendToBack;
var
  iChild$1: integer;
  obj$1: TW3Component;
  pushUp: integer;
  minZIndex: integer;
begin
  //if varisValidRef(Handle) then
  if (Handle) then begin
    minZIndex := 99999;
    if Assigned(Parent) and (Parent is TW3Component) then begin
      for iChild$1 := 0 to Parent.GetChildCount - 1 do begin
        obj$1 := Parent.GetChildObject(iChild$1);
        if Assigned(obj$1) and (obj$1 is TW3CustomControl) and (obj$1.Handle) then begin
          var objZIndex$1 := TW3CustomControl(obj$1).GetZIndexAsInt(99999);
          if objZIndex$1 < minZIndex then
            minZIndex := objZIndex$1;
        end;
      end;
    end;
    if minZIndex = 99999 then minZIndex := 0;
    // minZIndex must not be <0 as this makes controls disappear so push all other controls up
    if Assigned(Parent) and (Parent is TW3Component) then begin
      if minZIndex < 0 then pushUp := -minZIndex else pushUp := 1;
      for iChild$1 := 0 to Parent.GetChildCount - 1 do begin
        obj$1 := Parent.GetChildObject(iChild$1);
        if Assigned(obj$1) and (obj$1 <> Self) and (obj$1 is TW3CustomControl) and (obj$1.Handle) then begin
          var objZIndex$2 := TW3CustomControl(obj$1).GetZIndexAsInt(-1);
          if objZIndex$2 < 0 then
            obj$1.Handle.style.zIndex := minZIndex + pushUp + 1
          else
            obj$1.Handle.style.zIndex := objZIndex$2 + pushUp;
        end;
      end;
    end;
    Handle.style.zIndex := minZIndex + pushUp - 1;
  end;
end;

function TW3CustomControl.GetMaxZIndex: integer;
begin
  Result := 0;
  for var iChild := 0 to GetChildCount - 1 do begin
    var obj := GetChildObject(iChild);
    if Assigned(obj) and (obj is TW3CustomControl) and (obj.Handle) then begin
      var objZIndex := TW3CustomControl(obj).GetZIndexAsInt;
      if objZIndex > Result then
        Result := objZIndex;
      objZIndex := TW3CustomControl(obj).GetMaxZIndex;
      if objZIndex > Result then
        Result := objZIndex;
    end;
  end;
end;

procedure TW3CustomControl.BringToFront;
begin
  if (Handle) then 
    Handle.style.zIndex := (Parent as TW3CustomControl).GetMaxZIndex + 1;
end;

function TW3CustomControl.GetChildrenSortedByYPos: TW3ComponentArray;
var
  mCount: Integer;
  x$6:  Integer;
  mAltered: Boolean;
  mObj$1: TW3Component;
  mLast:  TW3CustomControl;
  mCurrent: TW3CustomControl;
begin
  Result.SetLength(0);
  mCount := GetChildCount;

  if mCount>0 then
  begin
    (* populate list *)
    for x$6 := 0 to mCount-1 do
    begin
      mObj$1 := GetChildObject(x$6);
      if (mObj$1 is TW3CustomControl) then
      Result.add(mObj$1);
    end;

    (* sort by Y-pos *)
    if Result.Count>1 then
    begin
      repeat
        mAltered := False;
        for x$6 := 1 to mCount-1 do
        begin
          mLast := TW3CustomControl(Result[x$6-1]);
          mCurrent := TW3CustomControl(Result[x$6]);
          if mCurrent.Top$1 < mLast.Top$1 then
          begin
            Result.Swap(x$6-1,x$6);
            mAltered := True;
          end;
        end;
      until mAltered=False;
    end;

  end;
end;

function TW3CustomControl.getStyleClass: String;
begin
  Result := w3_getAttribAsStr(Handle,'class');
end;

procedure TW3CustomControl.setStyleClass(aStyle: String);
begin
  w3_setAttrib(Handle,'class',aStyle);
end;

procedure TW3CustomControl.setAngle(aValue$24:Float);
var
  mStyle: String;
begin
  if aValue$24<>FAngle then
  begin
    FAngle := aValue$24;
    mStyle := 'rotate(' + FloatToStr(aValue$24,2) + 'deg)';
    w3_setStyle(Handle,w3_CSSPrefix('Transform'),mStyle);
  end;
end;

procedure TW3CustomControl.SetFocus;
begin
  //if varIsValidRef(handle) then
  if (Handle) then
  Handle.focus();
end;

function TW3CustomControl.gethasFocus: Boolean;
begin
  //if varIsValidRef(handle) then
  if (Handle) then
  Result := Handle.focused();
end;

procedure TW3CustomControl._setGotFocus(const aValue$34:TNotifyEventTNotifyEventnt);
begin
  (* NOTE: These are special implementations. In order to
     correctly deal with FOCUS() which is different from normal
     delphi, we have to hijack the ordinary binding, see
     StyleTagObject() for more information *)
  FOnGotFocus := aValue$34;
end;

procedure TW3CustomControl._setLostFocus(const aValue$38:TNotifyEventTNotifyEventent);
begin
  (* Note: Special function, see "_setGotFocus()" for more Information. *)
  FOnLostFocus := aValue$38;
end;

procedure TW3CustomControl._setMouseDown(const aValue$41 : TMouseButtonEventTMouseButtonEvent
var
  mObj$11: THandle;
begin
  mObj$11 := Handle;
  if Assigned(aValue$41) then
    mObj$11['onmousedown'] := @CBMouseDown
  else mObj$11['onmousedown'] := @FNoBehavior;
  FOnMouseDown := aValue$41;
end;

procedure TW3CustomControl.CBMouseDown(eventObj$8 : MouseEventMouseEvent);
begin
   var sr$1 := ScreenRect;
   var shiftState := TShiftState.Current;
   shiftState.MouseButtons := shiftState.MouseButtons or (1 shl eventObj$8.button);
   shiftState.MouseEvent := eventObj$8;
   MouseDown(eventObj$8.button, shiftState,
             eventObj$8.clientX-sr$1.Left$3, eventObj$8.clientY-sr$1.Top$3);

end;

procedure TW3CustomControl.MouseDown(button$1 : TMouseButtonTMouseButton; shiftState$6 : TShiftStateTShiftState; x$8, y$1 : Integer);
begin
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, button$1, shiftState$6, x$8, y$1);
end;

procedure TW3CustomControl._setMouseUp(const aValue$45:TMouseButtonEventTMouseButtonEvent
var
  mObj$15: Variant;
begin
  mObj$15 := Handle;
  if Assigned(aValue$45) then
    mObj$15['onmouseup'] := @CBMouseUp
  else mObj$15['onmouseup'] := @FNoBehavior;
  FOnMouseUp := aValue$45;
end;

procedure TW3CustomControl.CBMouseUp(eventObj$12 : MouseEventMouseEvent);
begin
   var sr$5 := ScreenRect;
   var shiftState$4 := TShiftState.Current;
   shiftState$4.MouseButtons := shiftState$4.MouseButtons and not (1 shl eventObj$12.button);
   shiftState$4.MouseEvent := eventObj$12;
   MouseUp(eventObj$12.button, shiftState$4,
           eventObj$12.clientX-sr$5.Left$3, eventObj$12.clientY-sr$5.Top$3);
end;

procedure TW3CustomControl.MouseUp(button$2 : TMouseButtonTMouseButton; shiftState$10 : TShiftStateTShiftState; x$12, y$5 : Integer);
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, button$2, shiftState$10, x$12, y$5);
end;

procedure TW3CustomControl._setMouseMove(const aValue$44: TMouseEventTMouseEventvent);
begin
  var mObj$14 := Handle;
  if Assigned(aValue$44) then
    mObj$14['onmousemove'] := @CBMouseMove
  else mObj$14['onmousemove'] := @FNoBehavior;
  FOnMouseMove := aValue$44;
end;

procedure TW3CustomControl.CBMouseMove(eventObj$11 : MouseEventMouseEvent);
begin
  var sr$4 := ScreenRect;
  var shiftState$3 := TShiftState.Current;
  shiftState$3.MouseEvent := eventObj$11;
  MouseMove(shiftState$3, eventObj$11.clientX-sr$4.Left$3, eventObj$11.clientY-sr$4.Top$3);
end;

procedure TW3CustomControl.MouseMove(shiftState$9 : TShiftStateTShiftState; x$11, y$4 : Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, shiftState$9, x$11, y$4);
end;

procedure TW3CustomControl._setMouseEnter(const aValue$42:TMouseEventTMouseEventEvent);
var
  mObj$12: Variant;
begin
  mObj$12 := Handle;
  if Assigned(aValue$42) then
    mObj$12['onmouseover'] := @CBMouseEnter
  else mObj$12['onmouseover'] := @FNoBehavior;
  FOnMouseEnter := aValue$42;
end;

procedure TW3CustomControl.CBMouseEnter(eventObj$9 : MouseEventMouseEvent);
begin
  var sr$2 := ScreenRect;
  var shiftState$1 := TShiftState.Current;
  shiftState$1.MouseEvent := eventObj$9;
  MouseEnter(shiftState$1, eventObj$9.clientX-sr$2.Left$3, eventObj$9.clientY-sr$2.Top$3);
end;

procedure TW3CustomControl.MouseEnter(shiftState$7 : TShiftStateTShiftState; x$9, y$2 : Integer);
begin
  if Assigned(FOnMouseEnter) then
     FOnMouseEnter(Self, shiftState$7, x$9, y$2);
end;

procedure TW3CustomControl._setMouseExit(const aValue$43:TMouseEventTMouseEventvent);
var
  mObj$13: Variant;
begin
  mObj$13 := Handle;
  if Assigned(aValue$43) then
    mObj$13['onmouseout'] := @CBMouseExit
  else mObj$13['onmouseout'] := @FNoBehavior;
  FOnMouseExit := aValue$43;
end;


procedure TW3CustomControl.CBMouseExit(eventObj$10 : MouseEventMouseEvent);
begin
  var sr$3 := ScreenRect;
  var shiftState$2 := TShiftState.Current;
  shiftState$2.MouseEvent := eventObj$10;
  MouseExit(shiftState$2, eventObj$10.clientX-sr$3.Left$3, eventObj$10.clientY-sr$3.Top$3);
end;

procedure TW3CustomControl.MouseExit(shiftState$8 : TShiftStateTShiftState; x$10, y$3 : Integer);
begin
  if Assigned(FOnMouseExit) then
     FOnMouseExit(Self, shiftState$8, x$10, y$3);
end;

procedure TW3CustomControl._setMouseWheel(const aValue$46: TMouseWheelEventTMouseWheelEvent);
var
   onEventSupported : Boolean;
begin
  var mObj$16 := Handle;
  asm
  @onEventSupported = 'onmousewheel' in @mObj$16;
  end;
  if onEventSupported then begin
    if Assigned(aValue$46) then
      mObj$16['onmousewheel'] := @CBMouseWheel
    else mObj$16['onmousewheel'] := @FNoBehavior;
  end else begin
    // FireFox
    if Assigned(aValue$46) then
      mObj$16.addEventListener('DOMMouseScroll', @CBMouseWheel, false)
    else mObj$16.removeEventListener('DOMMouseScroll', @CBMouseWheel, false);
  end;
  FOnMouseWheel := aValue$46;
end;

procedure TW3CustomControl.CBMouseWheel(eventObj$13 : MouseWheelEventMouseWheelEvent);
//data handling: http://www.switchonthecode.com/tutorials/javascript-tutorial-the-scroll-wheel
var
  wheelDelta$1 : Integer;
  handled$1 : Boolean;
begin
  if Assigned(FOnMouseWheel) then begin
    asm
    @wheelDelta$1 = @eventObj$13.detail ? -40*@eventObj$13.detail : @eventObj$13.wheelDelta;
    end;
    var sr$6 := ScreenRect;
    var shiftState$5 := TShiftState.Current;
    shiftState$5.MouseEvent := eventObj$13;
    var mousePos : TPoint;
    mousePos.X$1 := eventObj$13.clientX-sr$6.Left$3;
    mousePos.Y$1 := eventObj$13.clientY-sr$6.Top$3;
    MouseWheel(shiftState$5, wheelDelta$1, mousePos, handled$1);
    if handled$1 then begin
       eventObj$13.preventDefault();
       eventObj$13.stopPropagation();
    end;
  end;
end;

procedure TW3CustomControl.MouseWheel(shift: TShiftStateTShiftState; wheelDelta$2: Integer; const mousePos$2 : TPointTPoint;
                                      var handled$3 : Boolean);
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, shift, wheelDelta$2, mousePos$2, handled$3);
end;

procedure TW3CustomControl._setMouseClick(const aValue$39:TNotifyEventTNotifyEventvent);
var
  mObj$9: Variant;
begin
  mObj$9 := Handle;
  case Assigned(aValue$39) of
  true:   mObj$9['onclick'] := @CBClick;
  false:  mObj$9['onclick'] := @FNoBehavior;
  end;
  FOnClick := aValue$39;
end;

procedure TW3CustomControl.CBClick(const eventObj$3:Variant);
begin
  {$IFDEF USE_NEW_ENABLE}
  if  Enabled
  and Assigned(FOnClick) then
  FOnClick(Self);
  {$ELSE}
  if Assigned(FOnClick) then
  FOnClick(Self);
  {$ENDIF}
end;

procedure TW3CustomControl._setMouseDblClick(const aValue$40:TNotifyEventTNotifyEventckEvent);
var
  mObj$10: Variant;
begin
  mObj$10 := Handle;
  case Assigned(aValue$40) of
  true:   mObj$10['ondblclick'] := @CBDblClick;
  false:  mObj$10['ondblclick'] := @FNoBehavior;
  end;
  FOnDblClick := aValue$40;
end;

procedure TW3CustomControl.CBDblClick(const eventObj$4:Variant);
begin
  {$IFDEF USE_NEW_ENABLE}
  if  Enabled
  and Assigned(FOnDblClick) then
  FOnDblClick(Self);
  {$ELSE}
  if Assigned(FOnDblClick) then
  FOnDblClick(Self);
  {$ENDIF}
end;

procedure TW3CustomControl._setKeyDown(const aValue$35:TKeyDownEventTKeyDownEvent);
var
  mObj$6: Variant;
begin
  mObj$6 := Handle;
  case Assigned(aValue$35) of
  true:   mObj$6['onkeydown'] := @CBKeyDown;
  false:  mObj$6['onkeydown'] := @FNoBehavior;
  end;
  FOnKeyDown := aValue$35;
end;

procedure TW3CustomControl.CBKeyDown(const eventObj$5:Variant);
begin
  if Assigned(FOnKeyDown) then
  FOnKeyDown(Self,eventObj$5.keyCode);
end;

procedure TW3CustomControl._setKeyUp(const aValue$37:TKeyUpEventTKeyUpEvent);
var
  mObj$8: Variant;
begin
  mObj$8 := Handle;
  case Assigned(aValue$37) of
  true:   mObj$8['onkeyup'] := @CBKeyUp;
  false:  mObj$8['onkeyup'] := @FNoBehavior;
  end;
  FOnKeyUp := aValue$37;
end;

procedure TW3CustomControl.CBKeyUp(const eventObj$7:Variant);
begin
  if Assigned(FOnKeyUp) then
  FOnKeyUp(Self,eventObj$7.keyCode);
end;

procedure TW3CustomControl._setKeyPress(const aValue$36:TKeyPressEventTKeyPressEvent);
var
  mObj$7: Variant;
begin
  mObj$7 := Handle;
  case Assigned(aValue$36) of
  true:   mObj$7['onkeypress'] := @CBKeyPress;
  false:  mObj$7['onkeypress'] := @FNoBehavior;
  end;
  FOnKeyPress := aValue$36;
end;


procedure TW3CustomControl.CBKeyPress(const eventObj$6:Variant);
begin
  if Assigned(FOnKeyPress) then
  FOnKeyPress(Self,eventObj$6.charCode);
end;

procedure TW3CustomControl._setAnimationBegins
          (const aValue$27:TNotifyEventTNotifyEventginsEvent);
var
  mObj$2: Variant;
begin
  mObj$2 := Handle;
  case Assigned(aValue$27) of
  true:   mObj$2[w3_CSSPrefix('AnimationStart')] := @CBAnimationBegins;
  false:  mObj$2[w3_CSSPrefix('AnimationStart')] := @FNoBehavior;
  end;
  FOnAnimationBegins := aValue$27;
end;

procedure TW3CustomControl.CBAnimationBegins(const eventObj:Variant);
begin
  if Assigned(FOnAnimationBegins) then
  FOnAnimationBegins(Self);
end;

procedure TW3CustomControl._setAnimationEnds(const aValue$28:TNotifyEventTNotifyEventdsEvent);
var
  mObj$3: Variant;
begin
  mObj$3 := Handle;
  case Assigned(aValue$28) of
  true:   mObj$3[w3_CSSPrefix('AnimationEnd')] := @CBAnimationEnds;
  false:  mObj$3[w3_CSSPrefix('AnimationEnd')] := @FNoBehavior;
  end;
  FOnAnimationEnds := aValue$28;
end;

procedure TW3CustomControl.CBAnimationEnds(const eventObj$1:Variant);
begin
  if Assigned(FOnAnimationEnds) then
  FOnAnimationEnds(Self);
end;

procedure TW3CustomControl._setChanged(const aValue$29:TNotifyEventTNotifyEventt);
var
  mObj$4: Variant;
begin
  mObj$4 := Handle;
  case Assigned(aValue$29) of
  true:   mObj$4['onchange'] := @CBChanged;
  false:  mObj$4['onchange'] := @FNoBehavior;
  end;
  FOnChanged := aValue$29;
end;

procedure TW3CustomControl.CBChanged(const eventObj$2:Variant);
begin
  if Assigned(FOnChanged) then
  FOnChanged(Self);
end;

procedure TW3CustomControl._setTouchBegins(const aValue$48:TTouchBeginEventTTouchBeginEvent);
begin
  if Assigned(FOnTouchBegins) then
  begin
    w3_RemoveEvent(Handle,'touchstart',CMTouchBegins);
    FOnTouchBegins := nil;
  end;

  if Assigned(aValue$48) then
  begin
    FOnTouchBegins := aValue$48;
    w3_AddEvent(Handle,'touchstart',CMTouchBegins);
  end;
end;

procedure TW3CustomControl.CMTouchBegins;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnTouchBegins) then
  begin
    if not Assigned(FTouchData) then
    FTouchData := TW3TouchData.Create else
    FTouchData.Update;
    FOnTouchBegins(Self,FTouchData);
  end;
end;

procedure TW3CustomControl._setTouchMoves(const aValue$50:TTouchMoveEventTTouchMoveEvent);
begin
  if Assigned(FOnTouchMoves) then
  begin
    w3_RemoveEvent(Handle,'touchmove',CMTouchMove);
    FOnTouchMoves := nil;
  end;

  if Assigned(aValue$50) then
  begin
    FOnTouchMoves := aValue$50;
    w3_AddEvent(Handle,'touchmove',CMTouchMove);
  end;
end;

procedure TW3CustomControl.CMTouchMove;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnTouchMoves) then
  begin
    if not Assigned(FTouchData) then
    FTouchData := TW3TouchData.Create else
    FTouchData.Update;
    FOnTouchMoves(Self,FTouchData);
  end;
end;

procedure TW3CustomControl._setTouchEnds(const aValue$49:TTouchEndEventTTouchEndEvent);
begin
  if Assigned(FOnTouchEnds) then
  begin
    w3_RemoveEvent(Handle,'touchend',CMTouchEnds);
    FOnTouchEnds := nil;
  end;

  if Assigned(aValue$49) then
  begin
    FOnTouchEnds := aValue$49;
    w3_AddEvent(Handle,'touchend',CMTouchEnds);
  end;
end;

procedure TW3CustomControl.CMTouchEnds;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnTouchEnds) then
  begin
    if not Assigned(FTouchData) then
    FTouchData := TW3TouchData.Create else
    FTouchData.Update;
    FOnTouchEnds(Self,FTouchData);
  end;
end;

procedure TW3CustomControl._setGestureStart(aValue$33:TGestureStartEventTGestureStartEvent);
begin
  if Assigned(FOnGestureStart) then
  begin
    w3_RemoveEvent(Handle,'gesturestart',CMGestureStart);
    FOnGestureStart := nil;
  end;

  if Assigned(aValue$33) then
  begin
    FOnGestureStart := aValue$33;
    w3_AddEvent(Handle,'gesturestart',CMGestureStart);
  end;
end;

procedure TW3CustomControl.CMGestureStart;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnGestureStart) then
  begin
    if not Assigned(FGestureData) then
    FGestureData := TW3GestureData.Create else
    FGestureData.Update$1;
    FOnGestureStart(Self,FGestureData);
  end;
end;

procedure TW3CustomControl._setGestureChange(aValue$31:TGestureChangeEventTGestureChangeEvent);
begin
  if Assigned(FOnGestureChange) then
  begin
    w3_RemoveEvent(Handle,'gesturechange',CMGestureChange);
    FOnGestureChange := nil;
  end;

  if Assigned(aValue$31) then
  begin
    FOnGestureChange := aValue$31;
    w3_AddEvent(Handle,'gesturechange',CMGestureChange);
  end;
end;

procedure TW3CustomControl.CMGestureChange;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnGestureChange) then
  begin
    if not Assigned(FGestureData) then
    FGestureData := TW3GestureData.Create else
    FGestureData.Update$1;
    FOnGestureChange(Self,FGestureData);
  end;
end;

procedure TW3CustomControl._setGestureEnd(aValue$32:TGestureEndEventTGestureEndEvent);
begin
  if Assigned(FOnGestureEnd) then
  begin
    w3_RemoveEvent(Handle,'gesturestart',CMGestureEnd);
    FOnGestureEnd := nil;
  end;

  if Assigned(aValue$32) then
  begin
    FOnGestureEnd := aValue$32;
    w3_AddEvent(Handle,'gestureend',CMGestureEnd);
  end;
end;

procedure TW3CustomControl.CMGestureEnd;
begin
  asm
    event.preventDefault();
  end;
  if Assigned(FOnGestureEnd) then
  begin
    if not Assigned(FGestureData) then
    FGestureData := TW3GestureData.Create else
    FGestureData.Update$1;
    FOnGestureEnd(Self,FGestureData);
  end;
end;

// Note: Only IE support onResize events on ordinary HTML elements.
//       Webkit/moz/opera only support onResize on the window object.
//       We simply call resize() whenever the width or height of an
//       element has changed. And consequently invoke this event
procedure TW3CustomControl._setResize(const aValue$47:TNotifyEventTNotifyEvent);
begin
  FOnResize := aValue$47;
end;

procedure TW3CustomControl._setContextPopup(const aValue$30: TContextPopupEventTContextPopupEvent);
begin
  var mObj$5 := Handle;
  if Assigned(aValue$30) then
    mObj$5['oncontextmenu'] := @CBContextPopup
  else mObj$5['oncontextmenu'] := @FNoBehavior;
  FOnContextPopup := aValue$30;
end;

function TW3CustomControl.CBContextPopup(event : MouseEventMouseEvent) : Boolean;
begin
  var sr := ScreenRect;
  var mp : TPoint;
  mp.X$1 := event.clientX-sr.Left$3;
  mp.Y$1 := event.clientY-sr.Top$3;
  var handled := False;
  ContextPopup(mp, handled);
  Result := not handled; // expects false to cancel popup
end;

procedure TW3CustomControl.ContextPopup(const mousePos$1: TPointTPoint; var handled$2: Boolean);
begin
  if Assigned(FOnContextPopup) then
    FOnContextPopup(Self, mousePos$1, handled$2);
end;

procedure TW3CustomControl.Invalidate;
begin
//
end;

procedure TW3CustomControl.LayoutChildren;
var
  x$7:  Integer;
  mChild$2: TW3Component;
begin
  BeginUpdate;
  try
    for x$7 := 0 to GetChildCount-1 do
    begin
      mChild$2 := GetChildObject(x$7);
      if (mChild$2 is TW3CustomControl) then
        w3_Callback(TW3CustomControl(mChild$2).LayoutChildren,10);
    end;
  finally
    SetWasSized;
    EndUpdate;
  end;
end;

(* NOTE: Please see setBorderRadius regarding the webkit property
         we have set. It is write only and works as a proxy for the
         quad radius tags:
                border-top-left-radius: Xpx Xpx;
                border-top-right-radius: Xpx Xpx;
                border-bottom-left-radius: Xpx Xpx;
                border-bottom-right-radius: Xpx Xpx; *)
function TW3CustomControl.getBorderRadius: Integer;
begin
  Result := w3_getStyleAsInt(Handle,'bordertopleftRadius');
end;

(* NOTE: In setBorderRadius we use the webkit custom radius
   property "-webkit-border-radius". This is equiv. to setting all 4
   variations:  border-top-left-radius: Xpx Xpx;
                border-top-right-radius: Xpx Xpx;
                border-bottom-left-radius: Xpx Xpx;
                border-bottom-right-radius: Xpx Xpx; *)
procedure TW3CustomControl.setBorderRadius(aNewRadius: Integer);
begin
  BeginUpdate;
  w3_setStyle(Handle,'borderRadius',TInteger.toPxStr(aNewRadius));
  SetWasSized;
  EndUpdate;
end;

procedure TW3CustomControl.AfterUpdate;
begin
  (* was a resize issued? *)
  if GetWasSized then
  begin
    {$IFDEF USE_NEW_RESIZE}
    if  ObjectReady
    and (Width$1>0)
    and (Height$1>0) then
    begin
      Resize;
      if Assigned(FOnResize) then
      FOnResize(Self);
    end;
    {$ELSE}
    if ObjectReady then
    ReSize;
    {$ENDIF}

    (* do we need a re-draw? *)
    if not GetWasMoved then
    SetWasMoved;
  end;

  (* Only issue a redraw once *)
  if GetWasMoved then
  Invalidate;

  (* FWasMoved := False;
  FWasSized := False; *)
  inherited;
end;

end.


