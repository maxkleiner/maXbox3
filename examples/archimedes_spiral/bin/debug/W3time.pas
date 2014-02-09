{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Time;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

{$I 'vjl.inc'}

interface

uses
  W3System;

type
  { Custom types }
  TW3RepeaterEvent TW3RepeaterEventr: TObjectTObject): Boolean;

  { Exceptions objects }
  EW3CustomRepeater = class(EW3Exception);
  EW3EventRepeater = class(EW3Exception);

  { TW3CustomRepeater }
  TW3CustomRepeater = class(TObject)
  private
    FHandle$4: Integer;
    FDelay$1: Integer;
    function getActive: Boolean;
  protected
    procedure setDelay$1(aValue$64: Integer);
    procedure setHandle(aValue: Integer);
    procedure CBHandleCallBack;
    procedure CBExecute; virtual; abstract;
    procedure AllocTimer;
    procedure ReleaseTimer;
  public
    property Active: Boolean read getActive;
    property Handle: Integer read FHandle;
    property Delay: Integer read FDelay write setDelay;
    destructor Destroy; override;
  end;

  { TW3EventRepeater }
  TW3EventRepeater = class(TW3CustomRepeater)
  private
    FCallBack: TW3RepeaterEvent;
  protected
    procedure setCallBack(aValue: TW3RepeaterEventTW3RepeaterEvent);
    procedure CBExecute; override;
  public
    property CallBack: TW3RepeaterEvent read FCallBack;
    constructor Create$39(aCallBack: TW3RepeaterEventTW3RepeaterEvent; aDelay$1: Integer); virtual;
    class procedure After(aDelay: Integer; aProc: TProcedureRefTProcedureRef); virtual;
  end;

  { TW3Timer }
  TW3Timer = class(TObject)
  private
    FDelay: Integer;
    FRepeater: TW3EventRepeater;
    FOnTime: TNotifyEvent;
    function HandleEventCallback(Sender: TObjectTObject): Boolean;
    procedure setOnTime(const aValue: TNotifyEventTNotifyEvent);
  protected
    function getEnabled: Boolean; virtual;
    procedure setEnabled(const aValue: Boolean); virtual;
    procedure setDelay(const aValue: Integer); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property Delay: Integer read FDelay write setDelay;
    property Enabled: Boolean read getEnabled write setEnabled;
    property OnTime: TNotifyEvent read FOnTime write setOnTime;
  end;



implementation

var
  GlobalRepeaterList: array of TObject;

{ **************************************************************************** }
{ TW3Timer                                                                     }
{ **************************************************************************** }

constructor TW3Timer.Create;
begin
  inherited Create;

  FDelay := 1000;
end;

destructor TW3Timer.Destroy;
begin
  if Assigned(FRepeater) then
    FRepeater.Free;

  inherited;
end;

procedure TW3Timer.setEnabled(const aValue: Boolean);
begin
  if aValue<>getEnabled then
  begin
    case aValue of
      false: begin
               FRepeater.Free;
               FRepeater := nil;
             end;
      true:  begin
               if Assigned(FOnTime) then
                 FRepeater := TW3EventRepeater.Create$39(HandleEventCallback, FDelay);
             end;
    end;
  end;
end;

function TW3Timer.getEnabled: Boolean;
begin
  Result := Assigned(FRepeater);
end;

procedure TW3Timer.setDelay(const aValue: Integer);
begin
  (* turn of current if active *)
  if Assigned(FRepeater) then
    setEnabled(false);

  FDelay := TInteger.EnsureRange(aValue, 1, MAX_INT);
  setEnabled(true);
end;

function TW3Timer.HandleEventCallback(Sender: TObjectTObject): Boolean;
begin
  Result := False;

  if Assigned(FOnTime) then
    FOnTime(Self);
end;

procedure TW3Timer.setOnTime(const aValue: TNotifyEventTNotifyEvent);
begin
  FOnTime := aValue;
end;



{ **************************************************************************** }
{ TW3EventRepeater                                                             }
{ **************************************************************************** }

constructor TW3EventRepeater.Create$39(aCallBack: TW3RepeaterEventTW3RepeaterEvent; aDelay$1: Integer);
begin
  inherited Create;

  FCallBack := aCallBack;
  setDelay$1(aDelay$1);

  if Assigned(aCallBack) and (aDelay$1>0) then
    AllocTimer;
end;

class procedure TW3EventRepeater.After(aDelay: Integer; aProc: TProcedureRefTProcedureRef);
begin
  GlobalRepeaterList.Add(TW3EventRepeater.Create$39(
    function (Sender: TObjectTObject): boolean
    begin
      aProc;
      GlobalRepeaterList.Delete(GlobalRepeaterList.IndexOf(Sender));
      Result := true;
    end,
    aDelay));
end;

procedure TW3EventRepeater.setCallBack(aValue: TW3RepeaterEvent);
begin
  FCallBack := aValue;
end;

procedure TW3EventRepeater.CBExecute;
begin
  if FCallBack(Self) then
    ReleaseTimer;
end;

{ **************************************************************************** }
{ TW3CustomRepeater                                                            }
{ **************************************************************************** }

destructor TW3CustomRepeater.Destroy;
begin
  if FHandle$4<>0 then
    ReleaseTimer;

  inherited;
end;

function TW3CustomRepeater.getActive: Boolean;
begin
  Result := FHandle<>0;
end;

procedure TW3CustomRepeater.setDelay$1(aValue$64: Integer);
begin
  (* Accept the new value *)
  FDelay$1 := TInteger.EnsureRange(aValue$64,1,MAX_INT);

  (* Are we active? if so, re-allocate the timer *)
  if FHandle$4<>0 then
  begin
    ReleaseTimer;
    AllocTimer;
  end;
end;

procedure TW3CustomRepeater.setHandle(aValue: Integer);
begin
  FHandle := aValue;
end;

procedure TW3CustomRepeater.CBHandleCallBack;
begin
  CBExecute;
end;

procedure TW3CustomRepeater.AllocTimer;
var
  mRef$24: TProcedureRef;
  mWait:  Integer;
begin
  (* release current timer if any *)
  if FHandle$4<>0 then
    ReleaseTimer;

  (* Attempt to allocate a new timer *)
  try
    mRef$24 := CBHandleCallBack;
    mWait := FDelay$1;
    asm
      @Self.FHandle$4 = setInterval(@mRef$24,@mWait);
    end;
  except
    on E: Exception do
      raise EW3CustomRepeater.Create(Format(CNT_ERR_METHOD,['AllocTimer',
        ClassName, E.Message]));
  end;
end;

procedure TW3CustomRepeater.ReleaseTimer;
begin
  (* check handle *)
  if FHandle$4<>0 then
  begin
    try
      try
        asm
          clearInterval(@Self.FHandle$4);
        end;
      except
        on E: Exception do
          raise EW3CustomRepeater.Create(Format(CNT_ERR_METHOD,['ReleaseTimer',
            ClassName, E$1.Message]));
      end;
    finally
      FHandle$4 := 0;
    end;
  end;
end;

end.

