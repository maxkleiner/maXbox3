{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Effects;

{------------------------------------------------------------------------------}
{ Authors:    Jon Lennart Aasenden &  Eric Grange                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Components;

type
  TFxAnimationBeginsEvent TFxAnimationBeginsEventTObjectTObject);
  TFxAnimationEndsEvent   TFxAnimationEndsEventTObjectTObject);

  TW3CustomAnimation = class(TObject)
  private
    FOnBegins: TFxAnimationBeginsEvent;
    FOnEnds: TFxAnimationEndsEvent;
    FDuration: Float;
    FTarget$1: TW3TagObj;
    FBusy: Boolean;
    FInEvnCB: TProcedureRef;
    procedure SetDuration(Value$11: Float);
    procedure CBBegins;
    procedure CBEnds;

  protected
    procedure SetupTransition; virtual;
    procedure FinalizeTransition; virtual;

  public
    procedure Execute(TargetObj: TW3TagObjTW3TagObj);
    procedure ExecuteEx(TargetObj: TW3TagObjTW3TagObj; BeginHandler: TFxAnimationBeginsEventTFxAnimationBeginsEvent; EndHandler: TFxAnimationEndsEventTFxAnimationEndsEvent);
    property Active: Boolean read FBusy;
    property Target$1: TW3TagObj read FTarget$1;
    property Duration: Float read FDuration write SetDuration;
    constructor Create$40; virtual;
    destructor Destroy; override;
    class var DefaultDuration: Float := 2.0;

  published
    property OnAnimationBegins$1: TFxAnimationBeginsEvent read FOnBegins write FOnBegins;
    property OnAnimationEnds$1: TFxAnimationEndsEvent read FOnEnds write FOnEnds;
  end;

  TW3NamedAnimation = class(TW3CustomAnimation)
  private
    FName$2: String;
  protected
    procedure SetupTransition; override;
    procedure FinalizeTransition; override;
  public
    property AnimName: String read FName$2 write FName$2;
    procedure ExecuteNamed(TargetObj: TW3TagObjTW3TagObj; aAnimName: String);
  end;

  TW3RotateTransition = class(TW3CustomAnimation)
  private
    FDegree: Float;
    procedure setDegree(Value: Float);
  protected
    procedure SetupTransition; override;
    procedure FinalizeTransition; override;
  public
    property Degree: Float read FDegree write setDegree;
    constructor Create; override;
  end;

  TW3AnimationTiming = (atEase, atLinear, atEaseIn, atEaseOut, atEaseInOut);

  TW3TransitionAnimation = class(TW3CustomAnimation)
  private
    FStyleSetup: Boolean;
    FStyleDOM: Variant;
    FAnimationCmd: String;
    FTiming: TW3AnimationTiming;
    FSticky: Boolean;
  protected
    procedure SetupTransition; override;
    procedure FinalizeTransition; override;
    procedure SetupKeyFrames;
    procedure InvalidateKeyFrames;
    procedure SetSticky(val: Boolean);
    function KeyFramesCSS: String; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Timing: TW3AnimationTiming read FTiming write FTiming;
    property Sticky: Boolean read FSticky write FSticky;
  end;

  TW3WarpInTransition = class(TW3TransitionAnimation)
  protected
    function KeyFramesCSS: String; override;
  end;

  TW3WarpOutTransition = class(TW3TransitionAnimation)
  protected
    function KeyFramesCSS: String; override;
  end;

  TW3ZoomInTransition = class(TW3TransitionAnimation)
  protected
    function KeyFramesCSS: String; override;
  end;

  TW3ZoomOutTransition = class(TW3TransitionAnimation)
  protected
    function KeyFramesCSS: String; override;
  end;

const
  cW3AnimationTiming: array [TW3AnimationTiming] of String = ['ease', 'linear', 'ease-in', 'ease-out', 'ease-in-out'];



implementation



{ **************************************************************************** }
{ TW3TransitionAnimation                                                       }
{ **************************************************************************** }

constructor TW3TransitionAnimation.Create;
begin
   inherited Create$40;
   FTiming := atLinear;
end;

destructor TW3TransitionAnimation.Destroy;
begin
   InvalidateKeyFrames;
   inherited;
end;

procedure TW3TransitionAnimation.SetupKeyFrames;
begin
   FStyleSetup := True;

   var document := BrowserAPI.GetDocument;

   FStyleDOM := document.createElement('style');
   FStyleDOM.type := 'text/css';

   var css := 'keyframes '+ClassName+' {'+KeyFramesCSS+'}';

   FStyleDOM.appendChild(document.createTextNode('@-webkit-'+css));
   FStyleDOM.appendChild(document.createTextNode('@'+css));

   document.getElementsByTagName('head')[0].appendChild(FStyleDOM);
end;

procedure TW3TransitionAnimation.InvalidateKeyFrames;
begin
  if FStyleSetup then
  begin
    FStyleSetup := False;
    FStyleDOM.parent.removeChild(FStyleDOM);
    FStyleDOM := Null;
  end;
end;

procedure TW3TransitionAnimation.SetupTransition;
begin
  inherited SetupTransition;

  if not FStyleSetup then
    SetupKeyFrames;

  var style := Target.Handle.style;
  style.webkitAnimationFillMode := 'both';
  style.animationFillMode := 'both';

  FAnimationCmd := ClassName+' '+FloatToStr(Duration)+'s '+cW3AnimationTiming[Timing];
  style.webkitAnimation := FAnimationCmd;
  style.animation := FAnimationCmd;
end;

procedure TW3TransitionAnimation.FinalizeTransition;
begin
  if (not Sticky) then begin
    var style := Target.Handle.style;
    style.removeProperty("-webkit-animation");
    style.removeProperty("-webkit-animation-fill-mode");
    style.removeProperty("animation");
    style.removeProperty("animation-fill-mode");
    FAnimationCmd := '';
  end;
  inherited FinalizeTransition;
end;

procedure TW3TransitionAnimation.SetSticky(val : Boolean);
begin
   if FSticky<>val then begin
      FSticky := val;
      if (not val) and (FAnimationCmd<>'') then
         FinalizeTransition;
   end;
end;



{ **************************************************************************** }
{ TW3WarpInTransition                                                          }
{ **************************************************************************** }

function TW3WarpInTransition.KeyFramesCSS : String;
begin
   Result := #"
      0% {
         opacity: 0;
         -webkit-transform: scale(5);
         -webkit-transform-origin: 50% 50%;
         transform: scale(5);
         transform-origin: 50% 50%;
      }
      100% {
         opacity: 1.0;
         -webkit-transform: scale(1);
         transform: scale(1);
      }";
end;



{ **************************************************************************** }
{ TW3WarpOutTransition                                                         }
{ **************************************************************************** }

function TW3WarpOutTransition.KeyFramesCSS : String;
begin
   Result := #"
      0% {
         opacity: 1.0;
         -webkit-transform: scale(1);
         transform: scale(1);
      }
      100% {
         opacity: 0;
         -webkit-transform: scale(5);
         -webkit-transform-origin: 50% 50%;
         transform: scale(5);
         transform-origin: 50% 50%;
      }";
end;



{ **************************************************************************** }
{ TW3ZoomInTransition                                                          }
{ **************************************************************************** }

function TW3ZoomInTransition.KeyFramesCSS : String;
begin
   Result := #"
      0% {
         opacity: 0.0;
         -webkit-transform: scale(0);
         transform: scale(0);
      }
      50% {
         opacity: 0.3;
         -webkit-transform: scale(0.5);
         transform: scale(0.5);
      }
      100% {
         -webkit-transform: scale(1.0);
         -webkit-transform-origin: 50% 50%;
         transform: scale(1.0);
         transform-origin: 50% 50%;
      }";
end;



{ **************************************************************************** }
{ TW3ZoomOutTransition                                                         }
{ **************************************************************************** }

function TW3ZoomOutTransition.KeyFramesCSS : String;
begin
   Result := #"
      0% {
         -webkit-transform: scale(1.0);
         -webkit-transform-origin: 50% 50%;
         transform: scale(1.0);
         transform-origin: 50% 50%;
      }
      50% {
         opacity: 0.3;
         -webkit-transform: scale(0.5);
         transform: scale(0.5);
      }
      100% {
         opacity: 0.0;
         -webkit-transform: scale(0);
         transform: scale(0);
      }";
end;



{ **************************************************************************** }
{ TW3NamedAnimation                                                            }
{ **************************************************************************** }

procedure TW3NamedAnimation.SetupTransition;
var
  mCommand: String;
begin
  inherited SetupTransition;
  w3_setStyle(Target$1.Handle, w3_CSSPrefix('AnimationFillMode'),'both');
  mCommand := FName$2 + ' ' + FloatToStr(Duration) + 's linear';
  w3_setStyle(Target$1.Handle,w3_CSSPrefix('Animation'),mCommand);
end;

procedure TW3NamedAnimation.FinalizeTransition;
begin
  inherited FinalizeTransition;
  if Target$1<>nil then
  begin
    Target$1.Handle.style[w3_CSSPrefix('Animation')] := 'none';
    Target$1.Handle.style[w3_CSSPrefix('AnimationFillMode')] := 'none';
  end;
end;

procedure TW3NamedAnimation.ExecuteNamed(TargetObj: TW3TagObjTW3TagObj;
          aAnimName: String);
begin
  FName$2 := aAnimName;
  Execute(TargetObj);
end;



{ **************************************************************************** }
{ TW3RotateTransition                                                          }
{ **************************************************************************** }

constructor TW3RotateTransition.Create;
begin
  inherited Create$40;
  FDegree := 30;
end;

procedure TW3RotateTransition.setDegree(Value:Float);
begin
  if not Active then
  FDegree := Value else
  raise Exception.Create('Degree cannot be altered while the transition is active error');
end;

procedure TW3RotateTransition.SetupTransition;
begin
  inherited SetupTransition;

  w3_setStyle(Target.Handle,w3_CSSPrefix('AnimationFillMode'),'both');
  w3_setStyle(Target.Handle,
  w3_CSSPrefix('Animation'),'ROTATE-FOREVER ' + FloatToStr(Duration) + 's');
end;

procedure TW3RotateTransition.FinalizeTransition;
var
  mRef: THandle;
begin
  mRef := Target.Handle;
  Target.Handle.style[w3_CSSPrefix('Animation')] := 'none';
  Target.Handle.style[w3_CSSPrefix('AnimationFillMode')] := 'none';
  inherited FinalizeTransition;
end;



{ **************************************************************************** }
{ TW3CustomAnimation                                                           }
{ **************************************************************************** }

constructor TW3CustomAnimation.Create$40;
begin
  inherited Create;
  FDuration := DefaultDuration;
end;

procedure TW3CustomAnimation.SetDuration(Value$11:Float);
begin
  if not FBusy then
    FDuration := Value$11
  else raise Exception.Create('Duration cannot be altered while the transition is active error');
end;

destructor TW3CustomAnimation.Destroy;
begin
  (* still active? Force shutdown *)
  if FBusy and Assigned(FTarget$1) then
  begin
    try
      FinalizeTransition;
    except
      on e: Exception do;
    end;
  end;
  inherited Destroy;
end;

procedure TW3CustomAnimation.CBBegins;
begin
  if Assigned(FOnBegins) then
    FOnBegins(Self);
end;

procedure TW3CustomAnimation.CBEnds;
begin
  FinalizeTransition;
  if Assigned(FOnEnds) then
    FOnEnds(Self);
end;

procedure TW3CustomAnimation.SetupTransition;
begin
  FBusy := True;

  // to unbind we'll need the exact same event handler that was used to bind
  // so it is necessary to store it
  FInEvnCB := CBEnds;

  w3_AddEvent(FTarget$1.Handle, 'animationend', FInEvnCB);
  w3_AddEvent(FTarget$1.Handle, 'webkitAnimationEnd', FInEvnCB);

  CBBegins;
end;

procedure TW3CustomAnimation.FinalizeTransition;
begin
  w3_RemoveEvent(FTarget$1.Handle, 'animationend', FInEvnCB);
  w3_RemoveEvent(FTarget$1.Handle, 'webkitAnimationEnd', FInEvnCB);

  FBusy := False;
end;

procedure TW3CustomAnimation.Execute(TargetObj: TW3TagObjTW3TagObj);
begin
  if Assigned(TargetObj) then
  begin
    if not FBusy then
    begin
      FTarget := TargetObj;
      SetupTransition;
    end else
    raise Exception.Create('Transition is already in progress error');
  end else
  raise Exception.Create('Target-object was NIL error');
end;

procedure TW3CustomAnimation.ExecuteEx(TargetObj: TW3TagObjTW3TagObj; BeginHandler:TFxAnimationBeginsEventTFxAnimationBeginsEvent; EndHandler:TFxAnimationEndsEventTFxAnimationEndsEvent);
begin
  if Assigned(TargetObj) then
  begin
    if not FBusy then
    begin
      FTarget$1 := TargetObj;
      FOnBegins := BeginHandler;
      FOnEnds := EndHandler;
      SetupTransition;
    end else
    raise Exception.Create('Transition is already in progress error');
  end else
  raise Exception.Create('Target-object was NIL error');
end;

end.

