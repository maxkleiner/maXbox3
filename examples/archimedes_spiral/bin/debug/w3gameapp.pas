{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Optimale Systemer AS. All rights are reserved.                 }
{                                                                              }
{ **************************************************************************** }

unit W3GameApp;

{------------------------------------------------------------------------------}
{ Author:    Jon Lennart Aasenden                                              }
{ Updated:   2012.04.24 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

uses
  W3System, W3Application, W3Graphics, W3Game;

type

  { TW3CustomGameApplication }
  TW3CustomGameApplication = class(TW3CustomApplication)
  private
    FViewer: TW3GameView;
    procedure HandlePaintEvent(Sender$2: TObjectTObject; Canvas$1: TW3CanvasTW3Canvas);
  protected
    procedure PaintView(Canvas: TW3CanvasTW3Canvas); virtual; abstract;
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
  public
    property GameView: TW3GameView read FViewer;
  end;


implementation


{ **************************************************************************** }
{ TW3CustomGameApplication                                                     }
{ **************************************************************************** }

procedure TW3CustomGameApplication.ApplicationStarting;
begin
  FViewer := TW3GameView.Create$4(Display.View);
  inherited;
  FViewer.OnPaint := HandlePaintEvent;
end;

procedure TW3CustomGameApplication.ApplicationClosing;
begin
  if FViewer.Active$3 then
    FViewer.EndSession;
  FViewer.Free;
  inherited;
end;

procedure TW3CustomGameApplication.HandlePaintEvent(Sender$2: TObjectTObject; Canvas$1: TW3CanvasTW3Canvas);
begin
  PaintView(Canvas$1);
end;

end.
