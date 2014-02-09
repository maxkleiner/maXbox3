program curfit;

uses
  uwinplot,
  Forms,
  Main in 'main.pas' {Form1},
  GraphOpt in '..\dialogs\graphopt.pas' {GraphOptDlg},
  RegFunc in '..\dialogs\regfunc.pas' {RegFuncDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TGraphOptDlg, GraphOptDlg);
  Application.CreateForm(TRegFuncDlg, RegFuncDlg);

  SetMaxCurv(1);                            { A single curve will be plotted }
  GraphOptDlg.ReadConfigFile('graph.gcf');  { Read graphic configuration }

  Application.Run;
end.
