{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  21154: ElizaWeb.dpr 
{
{   Rev 1.0    2003.06.30 1:28:36 PM  czhower
{ Initial Checkin
}
{
{   Rev 1.0    2003.05.19 2:59:34 PM  czhower
}
program ElizaWeb;

uses
  Forms,
  EZBillClinton,
  EZPersonality,
  EZEliza,
  EZMSTechSupport,
  Main in 'Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
