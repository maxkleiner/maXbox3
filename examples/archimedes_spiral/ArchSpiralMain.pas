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
    procedure HandleClick(Sender:TObject);
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas: TW3Canvas); override;
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
  GameView.Delay := 10;
 
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

procedure TApplication.HandleClick(Sender: TObject);
begin
  FWait := not FWait;
end;

// Note: In a real live game you would try to cache as much
// info as you can. Typical tricks are: 
//   1: Only get the width/height when resized
//   2: Pre-calculate strings, especially RGB/RGBA values
//   3: Only redraw what has changed, avoid a full repaint
// The code below is just to get you started

procedure TApplication.PaintView(Canvas: TW3Canvas);
var
  cx, cy: Integer;
  i: Integer;
  angle: Float;
  x, y: Float;
begin
  if FWait then
    exit;

  FValueB := FValueB + 0.001;

  // Clear background
  Canvas.FillStyle := 'rgba(0,0,99,0.08)';
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);

  // Draw our framerate on the screen
//  Canvas.font := '10pt verdana';
//  Canvas.FillStyle := 'rgb(255,255,255)';
//  Canvas.FillTextF('FPS:' + IntToStr(GameView.FrameRate) + ' / ' + floatToStr(FbValue) ,10,20,MAX_INT);

  cx := GameView.width div 2;
  cy := GameView.Height div 2;
  Canvas.BeginPath;

  for i := 42 downto 0 do
  begin
    angle := FValueB * i;
    x := cx + (FValueA + FValueB * angle) * cos(angle);
    y := cy + (FValueA + FValueB * angle) * sin(angle);
    if i = 42 then Canvas.MoveToF(x, y) else Canvas.LineToF(x,y);
  end;

  Canvas.StrokeStyle := '#FFF';
  Canvas.Stroke;
end;


end.
