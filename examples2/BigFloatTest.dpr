program BigFloatTest;
{Copyright  © 2003-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_BigFloatTest in 'U_BigFloatTest.pas' {OpBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TOpBox, OpBox);
  Application.Run;
end.
