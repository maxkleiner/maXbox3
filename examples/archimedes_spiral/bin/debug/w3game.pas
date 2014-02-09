{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3Game;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Components, W3Graphics, W3Fonts, W3Time;

type
  EW3GameException = class(EW3Exception);

  { TW3GameView }
  TW3GameView = class(TW3GraphicControl)
  private 
    FDelay$2: Integer;
    FActive$1: Boolean;
    FFrameCount: Integer;
    FFrameRate: Integer;
    FTimer: TW3EventRepeater;
    FFrameTimer: TW3EventRepeater;
    function HandleCallBack(Sender$7: TObjectTObject): Boolean;
    function HandleFrameRateCallback(Sender$8: TObjectTObject): Boolean;
    procedure SetDelay(Value$12: Integer);
  protected
    procedure InitializeObject; override;
    procedure FinalizeObject; override;
  public
    property FrameRate: Integer read FFrameRate;
    property Active$3: Boolean read FActive$1;
    property Delay$2: Integer read FDelay$2 write SetDelay;
    procedure StartSession(WithFrameCounter: Boolean);virtual;
    procedure EndSession;
  end;


implementation


{ **************************************************************************** }
{ TW3GameView                                                                  }
{ **************************************************************************** }

procedure TW3GameView.InitializeObject;
begin
  inherited;
  FDelay$2 := 1;
end;

procedure TW3GameView.FinalizeObject;
begin
  if FActive$1 then
  EndSession;
  inherited;
end;

function TW3GameView.HandleCallBack(Sender$7: TObjectTObject): Boolean;
begin
  Inc(FFrameCount);
  Invalidate;
  Result := False;;
end;

function TW3GameView.HandleFrameRateCallback(Sender$8: TObjectTObject): Boolean;
begin
  FFrameRate := FFrameCount;
  FFrameCount := 0;
  Result := False;
end;

procedure TW3GameView.StartSession(WithFrameCounter:Boolean);
begin
  if not FActive$1 then
  begin
    FActive$1 := True;

    try
      FTimer := TW3EventRepeater.Create$39(HandleCallBack,FDelay$2);
    except
      on E: Exception do
      begin
        FActive$1 := False;
        FTimer := nil;
        raise EW3GameException.CreateFmt(CNT_ERR_METHOD, ['StartSession', 
          ClassName, E$2.Message]);
      end;
    end;

    if WithFrameCounter then
    begin
      try
        FFrameTimer := TW3EventRepeater.Create$39(HandleFrameRateCallback, 1000);
      except
        on E: Exception do
        begin
          FActive$1 := False;
          FTimer.Free;
          FTimer := nil;
          FFrameTimer := nil;
          raise EW3GameException.CreateFmt(CNT_ERR_METHOD, ['StartSession',
            ClassName, E$3.Message]);
        end;
      end;
    end else
    FFrameTimer := nil;

  end else
    raise EW3GameException.CreateFmt(CNT_ERR_METHOD, ['StartSession', ClassName,
      'A session is active error']);
end;

procedure TW3GameView.EndSession;
begin
  if FActive$1 then
  begin
    try
      if Assigned(FTimer) then
      FTimer.Free;

      if Assigned(FFrameTimer) then
      FFrameTimer.Free;
    finally
      FTimer := nil;
      FFrameTimer := nil;
      FActive$1 := False;
    end;
  end else
    raise EW3GameException.CreateFmt(CNT_ERR_METHOD, ['EndSession', ClassName,
      'A session is not active error']);
end;

procedure TW3GameView.SetDelay(Value$12: Integer);
begin
  if not FActive$1 then
  begin
    if Value$12 > 0 then
      FDelay$2 := Value$12 
    else
      raise EW3GameException.CreateFmt(CNT_ERR_METHOD, ['setDelay', ClassName,
        'Property cannot be altered while active error']);
  end;
end;
 
end.
