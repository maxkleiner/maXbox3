unit ArchSpiralMain;

interface

uses
  w3system, w3components, w3ctrls, w3application, w3game, w3gameapp,
  w3polygons, w3inet, w3graphics;

type
  TApplication = class(TW3CustomGameApplication)
  private
    FValueA: Float;
    FValueB: Float;
    FWait: Boolean;
    procedure HandleClick(Sender$3:TObjectTObject);
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas$2: TW3CanvasTW3Canvas); override;
  end;

implementation

//############################################################################
// TApplication
//############################################################################

procedure TApplication.ApplicationStarting;
begin
  inherited;

  FValueA := 3.0;
  FValueB := 1.4;

  GameView.OnClick := Self.HandleClick;

  // Initialize refresh interval, set this to 1 for optimal speed
  GameView.Delay$2 := 10;
 
  // Start the redraw-cycle with framecounter active
  // Note: the framecounter impacts rendering speed. Disable
  // the framerate for maximum speed (false)
  GameView.StartSession(true);
end;

procedure TApplication.ApplicationClosing;
begin
  GameView.EndSession;
  inherited;
end;

procedure TApplication.HandleClick(Sender$3: TObjectTObject);
begin
  FWait := not FWait;
end;

// Note: In a real live game you would try to cache as much
// info as you can. Typical tricks are: 
//   1: Only get the width/height when resized
//   2: Pre-calculate strings, especially RGB/RGBA values
//   3: Only redraw what has changed, avoid a full repaint
// The code below is just to get you started

procedure TApplication.PaintView(Canvas$2: TW3CanvasTW3Canvas);
var
  cx, cy: Integer;
  i: Integer;
  angle: Float;
  x$3, y: Float;
begin
  if FWait then
    exit;

  FValueB := FValueB + 0.001;

  // Clear background
  Canvas$2.FillStyle := 'rgba(0,0,99,0.08)';
  Canvas$2.FillRectF$2(0, 0, GameView.Width$1, GameView.Height$1);

  // Draw our framerate on the screen
//  Canvas.font := '10pt verdana';
//  Canvas.FillStyle := 'rgb(255,255,255)';
//  Canvas.FillTextF('FPS:' + IntToStr(GameView.FrameRate) + ' / ' + floatToStr(FbValue) ,10,20,MAX_INT);

  cx := GameView.Width$1 div 2;
  cy := GameView.Height$1 div 2;
  Canvas$2.BeginPath;

  for i := 42 downto 0 do
  begin
    angle := FValueB * i;
    x$3 := cx + (FValueA + FValueB * angle) * Cos(angle);
    y := cy + (FValueA + FValueB * angle) * Sin(angle);
    if i = 42 then Canvas$2.MoveToF(x$3, y) else Canvas$2.LineToF(x$3,y);
  end;

  Canvas$2.StrokeStyle := '#FFF';
  Canvas$2.Stroke;
end;


end.
