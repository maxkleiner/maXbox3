//************************************************************************
Program ZoomPanel_Component;
//shows the work of Component Thinking in building a component, loc's=245

type
  TZoomStyles   = (zsCenter,zsWipeRight,zsWipeLeft,zsWipeDown,zsWipeUp);
  TZoomStates   = (stClosed,stOpen);
  
  //TZoomPanel    = class(TCustomPanel)
  //private
  var 
    myPanel     : TPanel;
    FTimer      : TTimer;
    FZoomSpeed  : Integer;
    FZoomSteps  : Integer;
    FZoomStyle  : TZoomStyles;
    FZoomState  : TZoomStates;
    OpenRect, crect   : TRect;
    {Left, top, width & height when open}
    {Left, top, width & height when closed}
    //CL,CT,CW,CH : Integer;
    CurrStep    : Integer;
    ZoomDir     : Integer;
    
    {procedure SetZoomSpeed(Value: Integer);
    procedure SetZoomSteps(Value: Integer);
    procedure SetZoomStyle(Value: TZoomStyles);
    procedure SetZoomState(Value: TZoomStates);
  protected
    procedure TimerTick(Sender: TObject);
    procedure ZoomThePanel;
    procedure RestartTimer;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetOpenCrects(L,T,W,H: Integer);
    procedure OpenOrClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenIt;
    procedure CloseIt;
  published}
 

procedure TZoomPanelFree;
begin
  {When the panel is destroyed, kill the timer}
  FTimer.Free;
  //inherited Destroy;
end;

procedure CloseClick(Sender: TObject; var action: TCloseAction);
begin
  TZoomPanelFree;
end;


procedure SetZoomSpeed(Value: Integer);
begin
  {ZoomSpeed must be at least 1 (slowest) and no greater than 1000 (top speed)}
  if FZoomSpeed <> Value then begin
      if Value > 1000 then FZoomSpeed:= 1000
      else
        if Value < 1 then FZoomSpeed:= 1
        else FZoomSpeed := Value;
      {Set the rate at which the panel opens or closes}
      If FTimer <> NIL then FTimer.Interval:= 1000 div FZoomSpeed;
    end;
end;

procedure SetZoomSteps(Value: Integer);
begin
  {ZoomSteps must be at least 1 and no greater than 100}
  if FZoomSteps <> Value then
    if Value < 1 then FZoomSteps:= 1
    else
      if Value > 100 then FZoomSteps:= 100
      else FZoomSteps:= Value;
end;

procedure SetZoomState(Value: TZoomStates);
begin
  if FZoomState <> Value then FZoomState:= Value;
end;

procedure ZoomThePanel;
var
  OW,OH,CW,CH : Integer;
begin
  If FZoomState = stOpen then Inc(CurrStep) else Dec(CurrStep);
  OW:= OpenRect.Right-OpenRect.Left; {open width}
  writeln(inttostr(openrect.right))
  OH:= OpenRect.Bottom-OpenRect.Top; {open height}
  CW:= Trunc(OW/FZoomSteps*CurrStep); {current width}
  CH:= Trunc(OH/FZoomSteps*CurrStep); {current height}
  writeln(inttostr(cw))
  mypanel.font.size:= CW/5;
  Case FZoomStyle of
    zsCenter    : with crect do
             mypanel.SetBounds(crect.Left-CW div 2,crect.Top-CH div 2,CW,CH);
    zsWipeRight : with crect do
                    mypanel.SetBounds(crect.Left,crect.Top,CW,OH);
    zsWipeLeft  : with crect do
                    mypanel.SetBounds(crect.Right-CW,crect.Top,CW,OH);
    zsWipeUp    : with crect do
                    mypanel.SetBounds(crect.Left,crect.Top-CH,OW,CH);
    zsWipeDown  : with crect do
                    mypanel.SetBounds(crect.Left,crect.Top,OW,CH);
  end;
   writeln('zoomtick')
  {Disable the timer if we have done our last zoom step}
  If (CurrStep >= FZoomSteps) or (CurrStep <= 0) Then
    begin
      FTimer.Enabled:= False;
      CurrStep:= -1;
    end;
end;

procedure SetOpenClosedRects(L,T,W,H: Integer);
begin
  {Save the size that the panel should be when open. I had to do this in
  the CreateParams method because the size of the control is not set until
  after the Create is complete - so that users could override the size.}
  OpenRect:= Rect(L,T,L+W,T+H);
  {Save the size that the panel should be when closed.}
  Case FZoomStyle of
      {This is the default zooming behavior. It picks a spot in the exact
      center of the control as the center of the zoom effect. The panel
      will open from and close into this point.}
    zsCenter    : crect:= Rect(L+W div 2,T+H div 2,L+W div 2,T+H div 2);
      {The panel will open like a "screen door" to the right}
    zsWipeRight : crect:= Rect(L,T,L,T+H);
      {The panel will open like a "screen door" to the left}
    zsWipeLeft  : crect:= Rect(L+W,T,L+W,T+H);
      {The panel will open like a "window shade" going up}
    zsWipeUp    : crect:= Rect(L,T+H,L+W,T+H);
      {The panel will open like a "window shade" going down}
    zsWipeDown  : crect:= Rect(L,T,L+W,T);
  end;
end;


procedure SetZoomStyle(Value: TZoomStyles);
begin
  if FZoomStyle <> Value then 
    FZoomStyle:= Value;
      {Go set the sizes of the open and closed states of the panel}
    with mypanel do
      SetOpenClosedRects(mypanel.Left,mypanel.Top,mypanel.Width,mypanel.Height);
      {Do a Zoom in design mode so we can see the effect}
      //If (csDesigning in ComponentState) and (CurrStep=-1) then OpenOrClose;
end;


procedure RestartTimer;
begin
  If FZoomState = stOpen then CurrStep:= 0 else CurrStep:= FZoomSteps;
  {Turn the timer on}
  FTimer.Enabled:= True;
end;

procedure OpenIt;
begin
  FZoomState:= stOpen;
  RestartTimer;
end;

procedure CloseIt;
begin
  FZoomState:= stClosed;
  RestartTimer;
end;

Procedure OpenOrClose;
begin
  if (FZoomState = stOpen) then OpenIt else CloseIt;
end;

procedure TimerTick(Sender: TObject);
begin
  {Go and do a single zoom step}
  ZoomThePanel;
end;

procedure  ZoomPanelCreate(AOwner: TComponent);
begin
  {ZoomSpeed controls the Speed at which the panel steps through its
  zooming. The actual millisecond delay used is 1000 divided by ZoomSpeed.
  Therefore setting ZoomSpeed to a higher number will result in less
  of a delay between steps and hence a faster zoom.}
  FZoomSpeed:= 40;
  //SetZoomSpeed(10);
  {This defines the total number of steps that the panel will take to get
  to its final size and location}
  FZoomSteps := 20;
  //SetZoomSteps(5);
  CurrStep := 1;
  {ZoomStyle defines the effect used when zooming.}
  FZoomStyle := zsCenter;
  //FZoomStyle := zswipeup;
  {Set the panel as Open}
  FZoomState := stOpen;
  {First, we need to create a timer that will control the pacing of the
  panel's Zoom effect.}
  FTimer := TTimer.Create(Self);
  {Set the procedure that will handle the timer. Every time the timer expires
  it will transfer control to this procedure. The procedure moves the panel a
  single step and then the timer starts over.}
  FTimer.OnTimer := @TimerTick;
  {Set the timer as initially off. CreateParams turns it on}
  FTimer.Enabled := false;
  {Set the rate at which the panel opens or closes}
  FTimer.Interval := 1000 div FZoomSpeed;
end;

var frm: TForm;
begin
  frm:= TForm.create(self);
  {timeLbl:= TLabel.create(frm);}
  with frm do begin
      caption:= '*************Compenent Panel**************';  
      height:= 530;
      width:= 580;
      color:= clpurple;
      Position:= poScreenCenter;
      onClose:= @CloseClick;
      show;
    end
  myPanel:= TPanel.create(self);
  with mypanel do begin
    parent:= frm;
    font.color:= clRed;
    Caption:= 'EUROBOX';
    SetBounds(110,80,350,350)
  end;  
    zoomPanelCreate(mypanel)
    //SetZoomStyle(zsCenter)
    //sleep(2000)
    SetZoomStyle(zsWipeUp) 
    OpenIt;
    //SetZoomStyle(zsCenter) 
    //OpenIt;
    //OpenorClose;
   //TZoomPanelFree;
end.

//-----------------------component members--------------------------------
   property Align;
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BorderStyle;
    property BorderWidth;
    property Caption;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property ZoomSpeed : Integer read FZoomSpeed write SetZoomSpeed default 10;
    property ZoomSteps : Integer read FZoomSteps write SetZoomSteps default 20;
    property ZoomStyle : TZoomStyles read FZoomStyle 
                                     write SetZoomStyle default zsCenter;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;


