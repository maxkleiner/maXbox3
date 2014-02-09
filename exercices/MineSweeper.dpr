{todo :
 - enrigstrer config dans .INI
}

program MineSweeper;

uses
  Forms,
  MineForm in 'MineForm.pas' {MinesweeperForm},
  MineGame in 'MineGame.pas',
  CustomGame in 'CustomGame.pas' {CustomGameForm},
  BestTimes in 'BestTimes.pas' {BestTimesForm},
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Minesweeper';
  Application.CreateForm(TMinesweeperForm, MinesweeperForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
