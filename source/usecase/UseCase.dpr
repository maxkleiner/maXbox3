program UseCase;

uses
  Forms,
  UCMainForm in 'UCMainForm.pas' {UCMainDlg},
  JimShape in 'JimShape.pas',
  CaptionEditForm in 'CaptionEditForm.pas' {CaptionEditDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TUCMainDlg, UCMainDlg);
  Application.Run;
end.
