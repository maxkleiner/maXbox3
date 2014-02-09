unit MineGame;

interface

uses Classes, Math, Types;

const
  GAME_WIDTH_MAX = 50;
  GAME_HEIGHT_MAX = 50;
  CASE_WIDTH = 20;
  CASE_HEIGHT = 20;
  CLIKING_STEP_MAX = 5;
  NB_STEP_MAX = 5;

type
  PPoint = ^TPoint;

  TCaseState = (csUnclicked, csClicking, csClicked, csMined, csMarked);
  TGameState = (gsBeginning, gsPlaying, gsLost, gsWon);

  TCase = record
    Mined: Boolean;
    NearbyMines: Integer;
    ClickingStep: Integer;
    State: TCaseState;
  end;

  TGame = array[0..GAME_WIDTH_MAX - 1, 0..GAME_HEIGHT_MAX - 1] of TCase;

  TMineSweeper = class(TObject)
  private
    FClickingCaseList: TList;
    FRemainingMineCount: Integer;
    FGame: TGame;
    FGameState: TGameState;
    FHeight: Integer;
    FWidth: Integer;
    FMineCount: Integer;
    FTime: Integer;
    procedure AddClickingCase(X, Y: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DecClickingStep(X, Y: Integer);
    procedure NewGame;
    procedure SetSize(AWidth, AHeight, AMineCount: Integer);
    procedure SetState(X, Y: Integer; Value: TCaseState);
    property ClickingCaseList: TList read FClickingCaseList;
    property Game: TGame read FGame;
    property GameState: TGameState read FGameState;
    property Height: Integer read FHeight;
    property MineCount: Integer read FMineCount;
    property RemainingMineCount: Integer read FRemainingMineCount;
    property Time: Integer read FTime write FTime;
    property Width: Integer read FWidth;
  end;

implementation

//------------------------------------------------------------------------------

procedure TMineSweeper.AddClickingCase(X, Y: Integer);
var
  Point: PPoint;
begin
  New(Point);
  Point.X := X;
  Point.Y := Y;
  FClickingCaseList.Add(Point)
end;

//------------------------------------------------------------------------------

constructor TMineSweeper.Create;
begin
  FClickingCaseList := TList.Create;
end;

//------------------------------------------------------------------------------

destructor TMineSweeper.Destroy;
begin
  FClickingCaseList.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TMineSweeper.DecClickingStep(X, Y: Integer);
begin
  Dec(FGame[X, Y].ClickingStep);
end;

//------------------------------------------------------------------------------

procedure TMineSweeper.NewGame;
var
  I, J, K, L, X, Y: Integer;
begin
  for I := 0 to FWidth - 1 do
    for J := 0 to FHeight - 1 do
      with FGame[I, J] do
      begin
        Mined := False;
        NearbyMines := 0;
        State := csUnclicked;
      end;
  for I := 0 to FMineCount - 1 do
  begin
    repeat
      X := Random(Width);
      Y := Random(Height);
    until not FGame[X, Y].Mined;
    FGame[X, Y].Mined := True;
  end;
  for I := 0 to FWidth - 1 do
    for J := 0 to FHeight - 1 do
      for K := I - 1 to I + 1 do
        for L := J - 1 to J + 1 do
          if (K >= 0) and (K < FWidth) and (L >= 0) and (L < FHeight) and FGame[K, L].Mined then
            Inc(FGame[I, J].NearbyMines);
  FRemainingMineCount := FMineCount;
  FGameState := gsBeginning;
  FTime := 0;
end;

//------------------------------------------------------------------------------

procedure TMineSweeper.SetSize(AWidth, AHeight, AMineCount: Integer);
begin
  FWidth := Min(AWidth, GAME_WIDTH_MAX);
  FHeight := Min(AHeight, GAME_HEIGHT_MAX);
  FMineCount := Min(AMineCount, Min(999, (FHeight * FWidth) div 2));
end;

//------------------------------------------------------------------------------

procedure TMineSweeper.SetState(X, Y: Integer; Value: TCaseState);

  procedure ClearZone(X, Y, X0, Y0: Integer);
  var
    I, J: Integer;
  begin
    FGame[X, Y].State := csClicking;
    FGame[X, Y].ClickingStep := NB_STEP_MAX +
      abs(round(sqrt((X - X0) * (X - X0) + (Y - Y0) * (Y - Y0))));
    AddClickingCase(X, Y);
    if FGame[X, Y].NearbyMines = 0 then
      for I := -1 to 1 do
        for J := -1 to 1 do
          if ((I <> 0) or (J <> 0))
            and (X + I >= 0) and (X + I < FWidth)
            and (Y + J >= 0) and (Y + J < FHeight)
            and (FGame[X + I, Y + J].State = csUnclicked) then
            ClearZone(X + I, Y + J, X0, Y0);
  end;

  procedure CheckEndedGame;
  var
    I, J: Integer;
    Won: boolean;
  begin
    Won := True;
    for I := 0 to FWidth - 1 do
      for J := 0 to FHeight - 1 do
        if (FGame[I, J].State = csMined) and not FGame[I, J].Mined then
          Won := False;
    if Won then
      FGameState := gsWon
    else
      FGameState := gsLost;
  end;

begin
  if (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight) then
  begin
    if FGameState = gsBeginning then
      FGameState := gsPlaying;

    if Value = csMined then
    begin
      Dec(FRemainingMineCount);
      if FRemainingMineCount = 0 then
        CheckEndedGame;
    end
    else if ((value = csUnclicked) and (FGame[X, Y].State = csMined)) or (Value = csMarked) then
      Inc(FRemainingMineCount);

    if (Value = csClicking) and (FGame[X, Y].NearbyMines = 0) then
      ClearZone(X, Y, X, Y)
    else
    begin
      FGame[X, Y].State := Value;
      if Value = csClicking then
      begin
        FGame[X, Y].ClickingStep := NB_STEP_MAX;
        AddClickingCase(X, Y);
      end;
      if (Value in [csClicked, csClicking]) and FGame[X, Y].Mined then
        FGameState := gsLost;
    end;
  end;
end;

//------------------------------------------------------------------------------

end.

