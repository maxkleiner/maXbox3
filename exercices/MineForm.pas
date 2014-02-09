unit MineForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, GR32, GR32_Image, Menus, ImgList, ExtCtrls, Buttons, Math,
  IniFiles, MineGame, CustomGame, BestTimes, About;

type
  TMinesweeperForm = class(TForm)
    MainPnl: TPanel;
    TitlePnl: TPanel;
    Timer: TTimer;
    MainMenu: TMainMenu;
    GameMi: TMenuItem;
    NewMenuItem: TMenuItem;
    N1: TMenuItem;
    BeginnerMenuItem: TMenuItem;
    IntermediateMenuItem: TMenuItem;
    ExpertMenuItem: TMenuItem;
    CustomMenuItem: TMenuItem;
    N2: TMenuItem;
    MarksMenuItem: TMenuItem;
    N3: TMenuItem;
    BestTimesMenuItem: TMenuItem;
    N4: TMenuItem;
    ExitMenuItem: TMenuItem;
    OptionsMi: TMenuItem;
    ContentMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    GamePnl: TPanel;
    GamePb: TPaintBox32;
    CasesIl: TBitmap32List;
    ActionList1: TActionList;
    GameNew: TAction;
    GameBeginner: TAction;
    GameIntermediate: TAction;
    GameExpert: TAction;
    GameCustom: TAction;
    GameMarks: TAction;
    GameBestTimes: TAction;
    GameExit: TAction;
    HelpContent: TAction;
    HelpAbout: TAction;
    CaseTimer: TTimer;
    TitlePb: TPaintBox32;
    Num7SegIl: TBitmap32List;
    SunIl: TBitmap32List;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GamePbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GamePbMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GameNewExecute(Sender: TObject);
    procedure GameBeginnerExecute(Sender: TObject);
    procedure GameIntermediateExecute(Sender: TObject);
    procedure GameExpertExecute(Sender: TObject);
    procedure GameCustomExecute(Sender: TObject);
    procedure GameMarksExecute(Sender: TObject);
    procedure GameBestTimesExecute(Sender: TObject);
    procedure GameExitExecute(Sender: TObject);
    procedure HelpContentExecute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure CaseTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FMineSweeper: TMineSweeper;
    FMouseDown: Boolean;
    procedure SetSize(AWidth, AHeight, AMineCount: Integer);
    procedure DrawTitle;
    procedure DrawCase(X, Y: Integer; ACase: TCase);
    procedure DrawGame;
    procedure ReadIniFile;
    procedure WriteIniFile;
  public
    { Public declarations }
  end;

const
  TITLE_WIDTH_MIN = 205;
  UNCLICKED_BMP = 0;
  CLICKED_BMP = 1;
  MINED_BMP = 2;
  MARKED_BMP = 3;
  MINE1_BMP = 4;
  RED_BMP = 12;
  FLAG_BMP = 13;
  CROSS_BMP = 14;
  SUN_BMP_WIDTH = 55;
  SUN_BMP_HEIGHT = 45;
  SUN_WAIT_BMP = 0;
  SUN_OOO_BMP = 1;
  SUN_WON_BMP = 2;
  SUN_LOST_BMP = 3;

var
  MinesweeperForm: TMinesweeperForm;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------

procedure TMinesweeperForm.SetSize(AWidth, AHeight, AMineCount: Integer);
begin
  FMineSweeper.SetSize(AWidth, AHeight, AMineCount);
  GamePnl.Width := AWidth * CASE_WIDTH + 2 * GamePnl.BevelWidth;
  GamePnl.Height := AHeight * CASE_HEIGHT + 2 * GamePnl.BevelWidth;
  GamePb.Buffer.SetSize(AWidth * CASE_WIDTH, AHeight * CASE_HEIGHT);
  TitlePnl.Width := Max(TITLE_WIDTH_MIN, GamePnl.Width);
  GamePnl.Left := TitlePnl.Left + (TitlePnl.Width - GamePnl.Width) div 2;
  TitlePb.Buffer.SetSize(Max(TITLE_WIDTH_MIN, GamePnl.Width) - 2 * TitlePnl.BorderWidth,
    TitlePnl.Height - 2 * TitlePnl.BorderWidth);
  MainPnl.Width := 2 * TitlePnl.Left + TitlePnl.Width;
  MainPnl.Height := GamePnl.Top + GamePnl.Height + TitlePnl.Top;
  Position := poDesktopCenter;
  GameBeginner.Checked := False;
  GameIntermediate.Checked := False;
  GameExpert.Checked := False;
  GameCustom.Checked := False;
  if (AWidth = 9) and (AHeight = 9) and (AMineCount = 10) then
    GameBeginner.Checked := True
  else if (AWidth = 16) and (AHeight = 16) and (AMineCount = 40) then
    GameIntermediate.Checked := True
  else if (AWidth = 30) and (AHeight = 16) and (AMineCount = 99) then
    GameExpert.Checked := True
  else GameCustom.Checked := True;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.DrawTitle;
begin
  TitlePb.Buffer.BeginUpdate;
  TitlePb.Buffer.Clear(Color32(Color));
  if FMineSweeper.RemainingMineCount > 99 then
  begin
    if FMineSweeper.RemainingMineCount div 100 > 0 then
      TitlePb.Buffer.Draw(3, 8, Num7SegIl[FMineSweeper.RemainingMineCount div 100]);
    TitlePb.Buffer.Draw(27, 8, Num7SegIl[(FMineSweeper.RemainingMineCount mod 100) div 10]);
    TitlePb.Buffer.Draw(51, 8, Num7SegIl[FMineSweeper.RemainingMineCount mod 10]);
  end
  else
  begin
    if FMineSweeper.RemainingMineCount div 10 > 0 then
      TitlePb.Buffer.Draw(3, 8, Num7SegIl[FMineSweeper.RemainingMineCount div 10]);
    TitlePb.Buffer.Draw(27, 8, Num7SegIl[FMineSweeper.RemainingMineCount mod 10]);
  end;
  case FMineSweeper.GameState of
    gsBeginning: TitlePb.Buffer.Draw((TitlePnl.Width - SUN_BMP_WIDTH) div 2,
        (TitlePnl.Height - SUN_BMP_HEIGHT) div 2,
        SunIl[SUN_WAIT_BMP]);
    gsPlaying:
      if FMouseDown then
        TitlePb.Buffer.Draw((TitlePnl.Width - SUN_BMP_WIDTH) div 2,
          (TitlePnl.Height - SUN_BMP_HEIGHT) div 2,
          SunIl[SUN_OOO_BMP])
      else
        TitlePb.Buffer.Draw((TitlePnl.Width - SUN_BMP_WIDTH) div 2,
          (TitlePnl.Height - SUN_BMP_HEIGHT) div 2,
          SunIl[SUN_WAIT_BMP]);
    gsLost: TitlePb.Buffer.Draw((TitlePnl.Width - SUN_BMP_WIDTH) div 2,
        (TitlePnl.Height - SUN_BMP_HEIGHT) div 2,
        SunIl[SUN_LOST_BMP]);
    gsWon: TitlePb.Buffer.Draw((TitlePnl.Width - SUN_BMP_WIDTH) div 2,
        (TitlePnl.Height - SUN_BMP_HEIGHT) div 2,
        SunIl[SUN_WON_BMP]);
  end;
  if FMineSweeper.Time < 1000 then
  begin
    if FMineSweeper.Time div 100 > 0 then
      TitlePb.Buffer.Draw(TitlePb.Buffer.Width - 75, 8, Num7SegIl[FMineSweeper.Time div 100]);
    if (FMineSweeper.Time mod 100) div 10 > 0 then
      TitlePb.Buffer.Draw(TitlePb.Buffer.Width - 51, 8, Num7SegIl[(FMineSweeper.Time mod 100) div
        10])
    else if FMineSweeper.Time div 100 > 0 then
      TitlePb.Buffer.Draw(TitlePb.Buffer.Width - 51, 8, Num7SegIl[0]);
    TitlePb.Buffer.Draw(TitlePb.Buffer.Width - 27, 8, Num7SegIl[FMineSweeper.Time mod 10]);
  end
  else
    with TitlePb.Buffer do
      TextOut(TitlePb.Buffer.Width - TextWidth(IntToStr(FMineSweeper.Time)),
        (TitlePb.Height - TextHeight('1')) div 2,
        IntToStr(FMineSweeper.Time));
  TitlePb.Buffer.EndUpdate;
  TitlePb.Buffer.Changed;
  TitlePb.Repaint;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.DrawCase(X, Y: Integer; ACase: TCase);
begin
  with ACase do
    case State of
      csUnclicked:
        if (FMineSweeper.GameState in [gsWon, gslost]) and (Mined) then
        begin
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[CLICKED_BMP]);
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[MINED_BMP]);
        end
        else
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[UNCLICKED_BMP]);
      csclicked, csClicking:
        if (State = csClicking) and (ClickingStep >= NB_STEP_MAX) then
        begin
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[UNCLICKED_BMP]);
        end
        else
        begin
          if Mined then
          begin
            GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[RED_BMP]);
            GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[MINED_BMP]);
          end
          else if NearbyMines >= 0 then
          begin
            GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[CLICKED_BMP]);
            if NearbyMines > 0 then
              GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[MINE1_BMP +
                NearbyMines - 1]);
          end;
        end;
      csMined:
        if (FMineSweeper.GameState in [gsWon, gslost]) and not Mined then
        begin
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[CLICKED_BMP]);
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[MINED_BMP]);
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[CROSS_BMP]);
        end
        else
        begin
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[UNCLICKED_BMP]);
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[FLAG_BMP]);
        end;
      csMarked:
        begin
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[UNCLICKED_BMP]);
          GamePb.Buffer.Draw(X * CASE_WIDTH, Y * CASE_HEIGHT, CasesIl.Bitmap[MARKED_BMP]);
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.DrawGame;
var
  I, J: Integer;
begin
  GamePb.Buffer.BeginUpdate;
  GamePb.Buffer.DrawMode := dmBlend;
  for I := 0 to FMineSweeper.Width - 1 do
    for J := 0 to FMineSweeper.Height - 1 do
      DrawCase(I, J, FMineSweeper.Game[I, J]);
  GamePb.Buffer.EndUpdate;
  GamePb.Buffer.Changed;
  GamePb.Repaint;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.ReadIniFile;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Minesweeper.ini') do
  try
    SetSize(ReadInteger('Main', 'Width', 9),
      ReadInteger('Main', 'Height', 9),
      ReadInteger('Main', 'Mines', 10));
    GameMarks.Checked := ReadBool('Main', 'Marks', False);
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.WriteIniFile;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Minesweeper.ini') do
  try
    WriteInteger('Main', 'Width', FMineSweeper.Width);
    WriteInteger('Main', 'Height', FMineSweeper.Height);
    WriteInteger('Main', 'Mines', FMineSweeper.MineCount);
    WriteBool('Main', 'Marks', GameMarks.Checked);
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.FormCreate(Sender: TObject);
begin
  Randomize;
  FMineSweeper := TMineSweeper.Create;
  ReadIniFile;
  GameNewExecute(nil);
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WriteIniFile;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GamePbMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PtInt: PTimes;
begin
  if FMineSweeper.GameState in [gsBeginning, gsPlaying] then
  begin
    case Button of
      mbLeft:
        if FMineSweeper.Game[X div CASE_WIDTH, Y div CASE_HEIGHT].State = csUnclicked then
        begin
          FMineSweeper.SetState(X div CASE_WIDTH, Y div CASE_HEIGHT, csClicking);
          CaseTimer.Enabled := True;
        end;
      mbRight: case FMineSweeper.Game[X div CASE_WIDTH, Y div CASE_HEIGHT].State of
          csUnclicked: FMineSweeper.SetState(X div CASE_WIDTH, Y div CASE_HEIGHT, csMined);
          csMined:
            if GameMarks.Checked then
              FMineSweeper.SetState(X div CASE_WIDTH, Y div CASE_HEIGHT, csMarked)
            else
              FMineSweeper.SetState(X div CASE_WIDTH, Y div CASE_HEIGHT, csUnclicked);
          csMarked: FMineSweeper.SetState(X div CASE_WIDTH, Y div CASE_HEIGHT, csUnclicked);
        end;
    end;
    if FMineSweeper.GameState = gsWon then
    begin
      LoadTimes;
      Ptint := GetTimes(FMineSweeper.Width, FMineSweeper.Height, FMineSweeper.MineCount, True);
      with PtInt.BestTimes[NB_BEST_TIMES] do
        if (FMineSweeper.Time <= Time) or (Time = -1) then
        begin
          InsertTime(PtInt, InputBox('Best times', 'Name :', 'Anonymous'), DateToStr(SysUtils.Date),
            FMineSweeper.Time);
          with TBestTimesForm.Create(Self) do
          try
            RefreshCategories;
            CategoryCb.ItemIndex := Times.IndexOf(PtInt);
            CategoryCbChange(nil);
            ShowModal;
          finally
            Free;
          end;
        end;
      SaveTimes;
    end;
    FMouseDown := True;
    DrawTitle;
    DrawGame;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GamePbMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FMineSweeper.GameState = gsPlaying then
  begin
    FMouseDown := False;
    DrawTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameNewExecute(Sender: TObject);
begin
  FMineSweeper.NewGame;
  DrawTitle;
  DrawGame;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameBeginnerExecute(Sender: TObject);
begin
  SetSize(9, 9, 10);
  GameNewExecute(nil);
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameIntermediateExecute(Sender: TObject);
begin
  SetSize(16, 16, 40);
  GameNewExecute(nil);
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameExpertExecute(Sender: TObject);
begin
  SetSize(30, 16, 99);
  GameNewExecute(nil);
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameCustomExecute(Sender: TObject);
begin
  with TCustomGameForm.Create(Self) do
  try
    WidthUd.Position := FMineSweeper.Width;
    HeightUd.Position := FMineSweeper.height;
    MinesUd.Position := FMineSweeper.MineCount;
    if ShowModal = mrOk then
    begin
      SetSize(WidthUd.Position, heightUd.Position, MinesUd.Position);
      GameNewExecute(nil);
    end;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameMarksExecute(Sender: TObject);
begin
  GameMarks.Checked := not (GameMarks.Checked);
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameBestTimesExecute(Sender: TObject);
var
  PtInt: PTimes;
begin
  with TBestTimesForm.Create(Self) do
  try
    LoadTimes;
    Ptint := GetTimes(FMineSweeper.Width, FMineSweeper.Height, FMineSweeper.MineCount);
    RefreshCategories;
    if PtInt <> nil then
      CategoryCb.ItemIndex := Times.IndexOf(PtInt)
    else if CategoryCb.Items.Count > 0 then
      CategoryCb.ItemIndex := 0
    else
      CategoryCb.ItemIndex := -1;
    CategoryCbChange(nil);
    ShowModal;
    SaveTimes;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.GameExitExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.HelpContentExecute(Sender: TObject);
begin
  ShowMessage('Do you really need help ?');
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.HelpAboutExecute(Sender: TObject);
begin
  with TAboutForm.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.CaseTimerTimer(Sender: TObject);
var
  I: Integer;
  X1, Y1: Integer;
  Suppr: Boolean;
  RefreshNeeded: Boolean;
  Delta: Integer;
begin
  I := 0;
  RefreshNeeded := False;
  while (I < FMineSweeper.ClickingCaseList.Count) do
    with PPoint(FMineSweeper.ClickingCaseList[I])^ do
    begin
      Suppr := False;
      X1 := X * CASE_WIDTH;
      Y1 := Y * CASE_HEIGHT;
      with GamePb.Buffer do
      begin
        DrawCase(X, Y, FMineSweeper.Game[X, Y]);
        if FMineSweeper.Game[X, Y].ClickingStep in [1..NB_STEP_MAX - 1] then
        begin
          Delta := (NB_STEP_MAX - FMineSweeper.Game[X, Y].ClickingStep) * (CASE_WIDTH div
            NB_STEP_MAX) div 2;
          Draw(Rect(X1 + DELTA, Y1 + DELTA, X1 + CASE_WIDTH - DELTA, Y1 + CASE_HEIGHT - DELTA),
            Rect(0, 0, CASE_WIDTH, CASE_HEIGHT), CasesIl.Bitmap[UNCLICKED_BMP]);
        end
        else if FMineSweeper.Game[X, Y].ClickingStep = 0 then
        begin
          Draw(X1, Y1, CasesIl.Bitmap[CLICKED_BMP]);
          FMineSweeper.SetState(X, Y, csClicked);
          Suppr := True;
        end;
      end;
      FMineSweeper.DecClickingStep(X, Y);
      if Suppr then
      begin
        Dispose(FMineSweeper.ClickingCaseList[I]);
        FMineSweeper.ClickingCaseList.Delete(I);
        CaseTimer.Enabled := FMineSweeper.ClickingCaseList.Count > 0;
        RefreshNeeded := True;
      end
      else
        Inc(I);
    end;
  if RefreshNeeded then
    DrawGame
  else
  begin
    GamePb.Buffer.Changed;
    GamePb.Repaint;
  end;
end;

//------------------------------------------------------------------------------

procedure TMinesweeperForm.TimerTimer(Sender: TObject);
begin
  if FMineSweeper.GameState = gsPlaying then
  begin
    FMineSweeper.Time := FMineSweeper.Time + 1;
    DrawTitle;
  end;
end;

//------------------------------------------------------------------------------

end.

