unit uSettings;

interface
  uses IniFiles,Graphics,forms;

  procedure SaveSettings;
  procedure GetSettings;

implementation

uses Windows, SysUtils, dialogs, U_Oscilloscope4,ufrmOscilloscope4;

const
  SETTINGS_FILE = 'osc.ini';

procedure SaveSettings;
var
  IniFile:TIniFile;
  Ts:integer;
  filename:string;
  attrs:integer;
begin

  filename:=ExtractFilePath(Application.ExeName)+ SETTINGS_FILE;

  if fileexists(filename)then  attrs:=filegetattr(filename)
  else attrs:=2;{dummy attributes just so next test will not fail}
  if (getdrivetype(Pchar(filename))=Drive_CDRom) or ((attrs and faReadOnly) =0) then
  begin  {not readonly, so we can create or update this file}
    IniFile := TIniFile.Create(filename);
    try
      IniFile.WriteBool('Mode','Dual',frmMain.btnDual.Down);
      IniFile.WriteInteger('Channel1','Gain',frmMain.upGainCh1.Position);
      IniFile.WriteInteger('Channel1','ofset',frmMain.trOfsCh1.Position);
      IniFile.WriteBool('Channel1','Gnd',frmMain.btnCH1Gnd.Down);
      IniFile.WriteBool('Channel1','On',frmMain.OnCh1Box.checked);
      IniFile.WriteInteger('Channel2','Gain',frmMain.upGainCh2.Position);
      IniFile.WriteInteger('Channel2','ofset',frmMain.trOfsCh2.Position);
      IniFile.WriteBool('Channel2','Gnd',frmMain.OnCh2Box.Checked);
      IniFile.WriteBool('Channel2','On',frmMain.btnCh2Gnd.down);
      IniFile.WriteInteger('Trigger','Level',frmMain.TrigLevelBar.Position);

      Ts:=0;
      if frmMain.sp11025Sample.Down then
        Ts:=11
      else if frmMain.sp22050Sample.Down then
        Ts:=22
      else if frmMain.sp44100Sample.Down then
        Ts:=44;

      IniFile.WriteInteger('Time','Scale',Ts);
      IniFile.WriteInteger('Time','Gain',frmMain.SweepUD.Position);

      IniFile.WriteInteger('Screen','Scale',frmMain.UpScaleLight.Position);
      IniFile.WriteInteger('Screen','Beam',frmMain.upBeamLight.Position);
      IniFile.WriteInteger('Screen','focus',frmMain.upFocus.Position);
      IniFile.WriteString('Screen','color',  ColorToString(frmMain.frmOscilloscope1.ScreenColor));

      IniFile.WriteBool('ScreenData','Time',frmMain.menuData_Time.checked);
    except
    end;
    FreeAndNil(IniFile);
  end
  else showMessage('Oscilloscope is in a read Only folder and settings cannot be saved'
              +#13+'Move program to a writable file to allow settings to be saved '
              +#13+'for next run.');

end;

procedure GetSettings;
var
  IniFile:TIniFile;
  Ts:integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);
  try
    //frmMain.btnDual.Down := IniFile.ReadBool('Mode','Dual',False);
    frmMain.upGainCh1.Position := IniFile.ReadInteger('Channel1','Gain',3);
    frmMain.trOfsCh1.Position  := IniFile.ReadInteger('Channel1','ofset',0);
    frmMain.btnCH1Gnd.Down     := IniFile.ReadBool('Channel1','Gnd',False);
    frmMain.OnCh1Box.checked      := IniFile.ReadBool('Channel1','On',True);
    frmMain.upGainCh2.Position := IniFile.ReadInteger('Channel2','Gain',3);
    frmMain.trOfsCh2.Position  := IniFile.ReadInteger('Channel2','ofset',0);
    frmMain.btnCH2Gnd.Down     := IniFile.ReadBool('Channel2','Gnd',False);
    frmMain.OnCh2Box.checked      := IniFile.ReadBool('Channel2','On',True);
    frmMain.TrigLevelBar.Position := IniFile.ReadInteger('Trigger','Level',0);
    Ts := IniFile.ReadInteger('Time','Scale',11);

    if Ts= 11 then
      frmMain.sp11025Sample.Down := True
    else if Ts= 22 then
      frmMain.sp22050Sample.Down := True
    else if Ts= 44 then
      frmMain.sp44100Sample.Down := True;

    frmMain.SweepUD.Position      := IniFile.ReadInteger('Time','Gain',1);
    frmMain.UpScaleLight.Position := IniFile.ReadInteger('Screen','Scale',70);
    frmMain.upBeamLight.Position  := IniFile.ReadInteger('Screen','Beam',1);
    frmMain.upFocus.Position      := IniFile.ReadInteger('Screen','focus',1);

    frmMain.frmOscilloscope1.ScreenColor :=
                StringToColor(IniFile.ReadString('Screen','color','clBlack'));

    frmMain.menuData_Time.checked := IniFile.ReadBool('ScreenData','Time',True);

    frmMain.SetOscState;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
