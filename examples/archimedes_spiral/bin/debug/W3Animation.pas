{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Animation;

{------------------------------------------------------------------------------}
{ Author:    Primož Gabrijelèiè                                                }
{ Updated:   2012.11.09 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses 
  W3System, W3Components, W3Dictionaries, W3Lists, W3Time;

type
  TAnimation = class;

  AnimationStart = (Immediate, AfterPrevious);

  TAnimationNotify TAnimationNotify
  TAnimationNotifyAni TAnimationNotifyAniion: TAnimationTAnimation);
  TAnimationStep TAnimationSteprogress: float);
  TAnimationPath = array of integer;

  TAnimationConfig = class
  private
    FLoop: boolean;
    FNotifyAtEnd: TAnimationNotify;
    FStart: AnimationStart;
  public
    constructor Create$47;
    function SetLoop(ALoop: boolean): TAnimationConfig;
    function SetOnCompleted(AProc: TAnimationNotifyTAnimationNotify): TAnimationConfig;
    function SetStart(AStart: AnimationStartAnimationStart): TAnimationConfig;
    property OnCompleted: TAnimationNotify read FNotifyAtEnd write FNotifyAtEnd;
    property Loop: boolean read FLoop write FLoop;
    property Start: AnimationStart read FStart write FStart;
  end;

  TAnimation = class
  private
    FAnimationStep: TAnimationStep;
    FCompleted: boolean;
    FConfig: TAnimationConfig;
    FControl$1: TW3CustomControl;
    FNotifyAtEnd$1: TAnimationNotifyAni;
    FRepeater$1: TW3EventRepeater;
    FTime_ms: integer;
    FTimeStart: float;
  protected
    function AnimationTimer(Sender$4: TObjectTObject): boolean;
    procedure Initialize(var animationStep$1: TAnimationStepTAnimationStep); virtual;
  public
    constructor Create$48(control$1: TW3CustomControlTW3CustomControl; time_ms$2: integer;
      config$3: TAnimationConfigTAnimationConfig; animationStep: TAnimationStepTAnimationStep);
    destructor  Destroy; override;
    class function Interpolate(vStart, vStop: integer; progress$1: float): integer;
    class function InterpolateF(vStart, vStop: float; progress: float): float;
    function  IsActive$1: boolean;
    procedure Start$1(notifyAtEnd: TAnimationNotifyAniTAnimationNotifyAni);
    procedure Stop;
    property Completed: boolean read FCompleted;
    property Config$1: TAnimationConfig read FConfig;
    property Control$1: TW3CustomControl read FControl$1;
    property Time_ms: integer read FTime_ms;
  end;

  TControlAnimationList = class
  private
    FAnimationList: TObjectList;
    FControl: TW3CustomControl;
  protected
    procedure MoveToNext(animation: TAnimationTAnimation);
    procedure PrepareAnimation(animation$1: TAnimationTAnimation; config$2: TAnimationConfigTAnimationConfig);
  public
    constructor Create$46(ctrl: TW3CustomControlTW3CustomControl);
    procedure Animate(time_ms: integer; animateProc: TAnimationStepTAnimationStep; config: TAnimationConfigTAnimationConfig = nil);
    procedure Hide(time_ms: integer; config: TAnimationConfigTAnimationConfig = nil);
    function  IsActive: boolean;
    procedure Move$2(time_ms$1, X$2, Y$2: integer; config$1: TAnimationConfigTAnimationConfig = nil); overload;
    procedure Move(time_ms, XFrom, YFrom, XTo, YTo: integer; config: TAnimationConfigTAnimationConfig = nil); overload;
    procedure Move(time_ms: integer; path: TAnimationPath; config: TAnimationConfigTAnimationConfig = nil); overload;
    procedure Opacity(time_ms, startOpacity, endOpacity: integer; config: TAnimationConfigTAnimationConfig = nil); 
    procedure Rotate(time_ms: integer; startAngle, endAngle: float; config: TAnimationConfigTAnimationConfig = nil);
    procedure Show(time_ms: integer; config: TAnimationConfigTAnimationConfig = nil);
    procedure Stop;
  end;

  TAnimationManager = class
  protected
    function  HasAnimationList(ctrl$1: TW3CustomControlTW3CustomControl): boolean;
    function  GetAnimationList(ctrl$2: TW3CustomControlTW3CustomControl): TControlAnimationList;
  public
    class function AfterPrevious: TAnimationConfig;
    class function Config: TAnimationConfig;
    property Control[ctrl: TW3CustomControl]: TControlAnimationList
      read GetAnimationList; default;
  end;

  function Animation: TAnimationManager;

implementation

const
  CQuanta_ms = 20;

var
  GAnimationManager: TAnimationManager;

type
  TMoveAnimation = class(TAnimation)
  private
    FCachedIndex: integer;
    FRelativeMove: boolean;
    FToPoint: TPoint;
  protected
    procedure FindPathCoords(progress$4: float; path$1: TAnimationPath;
      lengths$1: array of float; totalLen$1: float; var x$18, y$10: integer);
    procedure Initialize(var animationStep$3: TAnimationStepTAnimationStep); override;
  public
    constructor Create$52(control$3: TW3CustomControlTW3CustomControl; time_ms$4: integer;
      config$5: TAnimationConfigTAnimationConfig; fromPoint, toPoint: TPointTPointTPoint); overload;
    constructor Create$51(control$4: TW3CustomControlTW3CustomControl; time_ms$5: integer;
      config$6: TAnimationConfigTAnimationConfig; toPoint$1: TPointTPoint); overload;
    constructor Create$53(control$2: TW3CustomControlTW3CustomControl; time_ms$3: integer;
      config$4: TAnimationConfigTAnimationConfig; path: TAnimationPath); overload;
  end;

  TOpacityAnimation = class(TAnimation)
  public
    constructor Create(control: TW3CustomControlTW3CustomControl; time_ms: integer;
      config: TAnimationConfig; fromOpacity, toOpacity: integer);
  end;

  TRotateAnimation = class(TAnimation)
  public
    constructor Create(control: TW3CustomControlTW3CustomControl; time_ms: integer;
      config: TAnimationConfig; fromAngle, toAngle: float);
  end;

{ exports }

function Animation: TAnimationManager;
begin
  if not Assigned(GAnimationManager) then
    GAnimationManager := TAnimationManager.Create;
  Result := GAnimationManager;
end;

constructor TAnimationConfig.Create$47;
begin
  inherited Create;
  FStart := AnimationStart.Immediate;
  FNotifyAtEnd := nil;
end;

function TAnimationConfig.SetLoop(ALoop: boolean): TAnimationConfig;
begin
  FLoop := ALoop;
  Result := Self;
end;

function TAnimationConfig.SetOnCompleted(AProc: TAnimationNotifyTAnimationNotify): TAnimationConfig;
begin
  FNotifyAtEnd := AProc;
  Result := Self;
end;

function TAnimationConfig.SetStart(AStart: AnimationStart): TAnimationConfig;
begin
  FStart := AStart;
  Result := Self;
end;

{ TAnimation }

constructor TAnimation.Create$48(control$1: TW3CustomControlTW3CustomControl; time_ms$2: integer;
  config$3: TAnimationConfigTAnimationConfig; animationStep: TAnimationStepTAnimationStep);
begin
  inherited Create;
  FAnimationStep := animationStep;
  FControl$1 := control$1;
  FTime_ms := time_ms$2;
  FConfig := config$3;
  FCompleted := false;
end;

function TAnimation.AnimationTimer(Sender$4: TObjectTObject): boolean;
begin
  Result := false;
  var progress := ((Now - FTimeStart) * (24*60*60*1000)) / FTime_ms;
  if progress > 1 then progress := 1;
  FAnimationStep(progress);
  if progress = 1 then
    if Assigned(Config$1) and Config$1.Loop then 
      FTimeStart := Now - CQuanta_ms/(24*60*60*1000)
    else begin
      FCompleted := true;
      FNotifyAtEnd$1(Self);
      Result := true;
    end;
end;

destructor TAnimation.Destroy;
begin
  if Assigned(FRepeater$1) then FRepeater$1.Free;
  FRepeater$1 := nil;
  inherited;
end;

procedure TAnimation.Initialize(var animationStep$1: TAnimationStepTAnimationStep); 
begin
  // animations may override this method to perform custom initialization
end;

class function TAnimation.Interpolate(vStart, vStop: integer; progress$1: float): integer;
begin
  Result := Round(vStart + (vStop - vStart) * progress$1);
end;

class function TAnimation.InterpolateF(vStart, vStop: float; progress: float): float;
begin
  Result := vStart + (vStop - vStart) * progress;
end;

function TAnimation.IsActive$1: boolean;
begin
  Result := Assigned(FRepeater$1);
end;

procedure TAnimation.Start$1(notifyAtEnd: TAnimationNotifyAniTAnimationNotifyAni);
begin
  var animationStep$2 := @FAnimationStep;
  Initialize(animationStep$2);
  FAnimationStep := animationStep$2;
  FTimeStart := Now;
  FNotifyAtEnd$1 := notifyAtEnd;
  FRepeater$1 := TW3EventRepeater.Create$39(AnimationTimer, CQuanta_ms);
end;

procedure TAnimation.Stop;
begin
  if Assigned(FRepeater) then begin
    FRepeater.Free;
    FRepeater := nil;
  end;
end;

{ TMoveAnimation }

constructor TMoveAnimation.Create$52(control$3: TW3CustomControlTW3CustomControl; time_ms$4: integer;
  config$5: TAnimationConfigTAnimationConfig; fromPoint, toPoint: TPointTPointTPoint);
begin
  inherited Create$48(control$3, time_ms$4, config$5,
    procedure (progress$3: float)
    begin
      control$3.BeginUpdate;
      control$3.Left$1 := Interpolate(fromPoint.X$1, toPoint.X$1, progress$3);
      control$3.Top$1 := Interpolate(fromPoint.Y$1, toPoint.Y$1, progress$3);
      control$3.EndUpdate;
    end);
  FRelativeMove := false;
end;

constructor TMoveAnimation.Create$51(control$3: TW3CustomControlTW3CustomControl; time_ms$4: integer;
  config$5: TAnimationConfigTAnimationConfig; toPoint$1: TPointTPoint); 
begin
  inherited Create$48(control$4, time_ms$5, config$6, nil);
  FRelativeMove := true;
  FToPoint := toPoint$1;
end;

constructor TMoveAnimation.Create$53(control$3: TW3CustomControlTW3CustomControl; time_ms$4: integer;
  config$5: TAnimationConfigTAnimationConfig; path: TAnimationPath);
var
  i$3: integer;
  lengths: array of float;
begin
  FRelativeMove := false;
  Assert(not Odd(path.Length), 'Path must contain even number of elements');
  Assert(path.Length >= 4, 'Path must contain at least four elements');
  var totalLen := 0.0;
  lengths.Push(totalLen);
  for i$3 := 0 to path.Length - 4 step 2 do begin
    totalLen := totalLen + Sqrt(Sqr$_Integer_(path[i$3+2]-path[i$3]) + Sqr$_Integer_(path[i$3+3]-path[i$3+1]));
    lengths.Push(totalLen);
  end;
  inherited Create$48(control$2, time_ms$3, config$4,
    procedure (progress$2: float)
    var
      x$17, y$9: integer;
    begin
      FindPathCoords(progress$2, path, lengths, totalLen, x$17, y$9);
      control$2.BeginUpdate;
      control$2.Left$1 := x$17;
      control$2.Top$1 := y$9;
      control$2.EndUpdate;
    end);
end;

procedure TMoveAnimation.FindPathCoords(progress$4: float; path$1: TAnimationPath;
  lengths$1: array of float; totalLen$1: float; var x$18, y$10: integer);
begin
  progress$4 := progress$4 * totalLen$1;
  if progress$4 >= lengths$1[FCachedIndex+1] then 
    while (FCachedIndex < (lengths$1.Length - 2)) and
          (progress$4 >= lengths$1[FCachedIndex+1])
    do Inc(FCachedIndex);
  var linePart := (progress$4 - lengths$1[FCachedIndex]) / (lengths$1[FCachedIndex+1] - lengths$1[FCachedIndex]);
  if linePart > 1 then linePart := 1;
  x$18 := Interpolate(path$1[FCachedIndex * 2],     path$1[FCachedIndex * 2 + 2], linePart);
  y$10 := Interpolate(path$1[FCachedIndex * 2 + 1], path$1[FCachedIndex * 2 + 3], linePart);
end;

procedure TMoveAnimation.Initialize(var animationStep$3: TAnimationStepTAnimationStep);
var
  fromPoint$1: TPoint;
begin
  if FRelativeMove then begin
    fromPoint$1 := TPoint.Create$16(Control$1.Left$1, Control$1.Top$1);
    animationStep$3  := 
      procedure (progress$5: float)
      begin
        Control$1.BeginUpdate;
        Control$1.Left$1 := Interpolate(fromPoint$1.X$1, FToPoint.X$1, progress$5);
        Control$1.Top$1 := Interpolate(fromPoint$1.Y$1, FToPoint.Y$1, progress$5);
        Control$1.EndUpdate;
      end;
  end;
end;

{ TOpacityAnimation }

constructor TOpacityAnimation.Create(control: TW3CustomControlTW3CustomControl; time_ms: integer;
  config: TAnimationConfig; fromOpacity, toOpacity: integer);
begin
  inherited Create(control, time_ms, config,
    procedure (progress: float)
    begin
      control.Opacity := Interpolate(fromOpacity, toOpacity, progress);
    end);
end;

{ TRotateAnimation }

constructor TRotateAnimation.Create(control: TW3CustomControlTW3CustomControl; time_ms: integer;
  config: TAnimationConfig; fromAngle, toAngle: float);
begin
  inherited Create(control, time_ms, config,
    procedure (progress: float)
    begin
      control.Angle := InterpolateF(fromAngle, toAngle, progress);
    end);
end;

{ TControlAnimationList }

constructor TControlAnimationList.Create$46(ctrl: TW3CustomControlTW3CustomControl);
begin
  inherited Create;
  FAnimationList := TObjectList.Create$17;
  FControl := ctrl;
end;

procedure TControlAnimationList.Animate(time_ms: integer; animateProc: TAnimationStepTAnimationStep;
  config: TAnimationConfigTAnimationConfig);
begin
  if Assigned(config) and (config.Start = AnimationStart.Immediate) then
    FAnimationList.Clear;
  FAnimationList.Add(TAnimation.Create$48(FControl, time_ms, config, animateProc));
  if FAnimationList.Count = 1 then
    TAnimation(FAnimationList[0]).Start$1(MoveToNext);
end;

procedure TControlAnimationList.Hide(time_ms: integer; config: TAnimationConfig);
begin
  Opacity(time_ms, FControl.Opacity, 0, config);
end;

function TControlAnimationList.IsActive: boolean;
begin
  Result := (FAnimationList.Count > 0) and (not TAnimation(FAnimationList[0]).Completed);
end;

procedure TControlAnimationList.Move$2(time_ms, Y$2, config$1eger;
  X$2onfig: TAnimationConfigTAnimationConfig);
begin
  PrepareAnimation(TMoveAnimation.Create$51(FControl, time_ms$1, config$1,
    TPoint.Create$16(X$2, Y$2)), config$1);
end;

procedure TControlAnimationList.Move(time_ms, XFrom, YFrom, XTo, YTo: integer;
  config: TAnimationConfig); 
begin
  PrepareAnimation(TMoveAnimation.Create(FControl, time_ms, config,
    TPoint.Create$16(XFrom, YFrom),
    TPoint.Create$16(XTo, YTo)), config);
end;

procedure TControlAnimationList.Move(time_ms: integer; path: TAnimationPath;
  config: TAnimationConfig = nil); 
begin
  PrepareAnimation(TMoveAnimation.Create(FControl, time_ms, config, path), config);
end;

procedure TControlAnimationList.MoveToNext(animation: TAnimationTAnimation);
begin
  var idx := FAnimationList.IndexOf(animation);
  FAnimationList.Remove(idx);
  if Assigned(animation.Config$1) and Assigned(animation.Config$1.OnCompleted) then begin
    var onCompleted := animation.Config$1.OnCompleted;
    onCompleted;
  end;
  animation.Free;
  if (FAnimationList.Count > 0) and (not TAnimation(FAnimationList[0]).IsActive$1) then
    TAnimation(FAnimationList[0]).Start$1(MoveToNext);
end;

procedure TControlAnimationList.Opacity(time_ms, startOpacity, endOpacity: integer;
  config: TAnimationConfig);
begin
  PrepareAnimation(TOpacityAnimation.Create(FControl, time_ms, config,
    startOpacity, endOpacity), config);
end;

procedure TControlAnimationList.Rotate(time_ms: integer; startAngle, endAngle: float;
  config: TAnimationConfig);
begin
  PrepareAnimation(TRotateAnimation.Create(FControl, time_ms, config,
    startAngle, endAngle), config);
end;

procedure TControlAnimationList.PrepareAnimation(animation$1: TAnimationTAnimation;
  config$2: TAnimationConfigTAnimationConfig);
begin
  var idx$1 := FAnimationList.Add(animation$1);
  if (not Assigned(config$2)) or (config$2.Start = Immediate) then
    TAnimation(FAnimationList[idx$1]).Start$1(MoveToNext);
end;

procedure TControlAnimationList.Show(time_ms: integer; config: TAnimationConfig);
begin
  Opacity(time_ms, FControl.Opacity, 255, config);
end;

procedure TControlAnimationList.Stop;
begin
  while (FAnimationList.Count > 0) and (TAnimation(FAnimationList[0]).IsActive) do begin
    var item := TAnimation(FAnimationList[0]);
    FAnimationList.Remove(0);
    item.Stop;
    item.Free;
  end;
  FAnimationList.Clear;
end;

{ TAnimationManager }

class function TAnimationManager.AfterPrevious: TAnimationConfig;
begin
  Result := Config;
  Result.Start := AnimationStart.AfterPrevious;
end;

class function TAnimationManager.Config: TAnimationConfig;
begin
  Result := TAnimationConfig.Create$47;
end;

function TAnimationManager.GetAnimationList(ctrl$2: TW3CustomControlTW3CustomControl): TControlAnimationList;
begin
  if HasAnimationList(ctrl$2) then asm
    @Result = (@ctrl$2).AM_AL;
  end
  else begin
    Result := TControlAnimationList.Create$46(ctrl$2);
    asm
      (@ctrl$2).AM_AL = @Result;
    end;
  end;
end;

function TAnimationManager.HasAnimationList(ctrl$1: TW3CustomControlTW3CustomControl): boolean;
begin
  asm
    @Result = (@ctrl$1).hasOwnProperty('AM_AL');
  end;
end;

end.
