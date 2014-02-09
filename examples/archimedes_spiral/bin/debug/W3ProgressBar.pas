{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3ProgressBar;

interface

uses
  W3System, W3Components;

type
  TW3ProgressMeter = class(TW3CustomControl)
  end;

  TW3ProgressBar = class(TW3CustomControl)
  private
    FMeter: TW3ProgressMeter;
    FTotal: Integer;
    FValue: Integer;
    FActive: Boolean = True;
  protected
    procedure SetTotal(aValue: Integer);
    procedure SetPos(aValue: Integer);
    procedure SetActive(aValue: Boolean);

    procedure InitializeObject; override;
    procedure FinalizeObject; override;
    procedure Resize; override;
  public
    class function supportAdjustment: Boolean; override;

    property Total: Integer read FTotal write setTotal;
    property Value: Integer read FValue write setpos;
    property Active: Boolean read FActive write SetActive;
  end;

implementation

{ **************************************************************************** }
{ TW3ProgressBar                                                             }
{ **************************************************************************** }

class function TW3ProgressBar.supportAdjustment:Boolean;
begin
  Result := False;
end;

procedure TW3ProgressBar.InitializeObject;
begin
  inherited;
  FMeter := TW3ProgressMeter.Create$4(Self);
end;

procedure TW3ProgressBar.FinalizeObject;
begin
  FMeter.Free;
  FMeter := nil;
  inherited;
end;

procedure TW3ProgressBar.Resize;
var
  mPixels: Integer;
  wd, hd: Integer;
begin
  inherited;

  if FTotal > 0 then
  begin
    mPixels := TInteger.PercentOfValue(FValue, FTotal);
    wd := (mPixels * ClientWidth) div 100;
    hd := ClientHeight;
    FMeter.SetBounds(4, 4, wd - 8, hd - 8);
  end else
    FMeter.SetBounds(0, 0, 0, 0);
end;

procedure TW3ProgressBar.SetTotal(aValue: Integer);
begin
  aValue := TInteger.EnsureRange(aValue, 0, MAX_INT);
  if aValue <> FTotal then
  begin
    BeginUpdate;
    FTotal := aValue;
    if FTotal > FValue then
      FValue := FTotal;
    SetWasSized;
    EndUpdate;
  end;
end;

procedure TW3ProgressBar.SetPos(aValue: Integer);
begin
  aValue := TInteger.EnsureRange(aValue, 0, FTotal);
  if aValue <> FValue then
  begin
    BeginUpdate;
    FValue := aValue;
    SetWasSized;
    EndUpdate;
  end;
end;

procedure TW3ProgressBar.SetActive(aValue: Boolean);
begin
  FActive := aValue;
  if Assigned(FMeter) and (FMeter.Handle) then
    FMeter.Handle.style[w3_CSSPrefix('AnimationPlayState')] :=
      if aValue then 'running' else 'paused';
end;

end.
