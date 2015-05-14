unit MTMainForm;    //tester not yet finished!

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CPort, StdCtrls, CPortCtl, ExtCtrls, Menus,IniFiles, ComCtrls;
 }
 
//type
  //TMainForm = class(TForm)
  var  
    
    Panel: TPanel;
    ComTerminal: TComTerminal;
    ConnButton: TButton;
    ComPort: TComPort;
    PortButton: TButton;
    TermButton: TButton;
    FontButton: TButton;
    //agr: TWebServerRequest TXMLTransform; TButtonItemActionLink;// TCategoryButtons; //TButtonGroup;
    TerminalReady: TComLed;
    Label1: TLabel;
    Label2: TLabel;
    ComLed1: TComLed;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Button1: TButton;
    ComDataPacket1: TComDataPacket;
    StatusBar1: TStatusBar;
       procedure ConnButtonClick(Sender: TObject);
       procedure ComPortAfterOpen(Sender: TObject);
       procedure ComPortAfterClose(Sender: TObject);
       procedure PortButtonClick(Sender: TObject);
       procedure TermButtonClick(Sender: TObject);
       procedure FontButtonClick(Sender: TObject);
       procedure Paste1Click(Sender: TObject);
       procedure FormShow(Sender: TObject);
       procedure FormClose(Sender: TObject; var Action: TCloseAction);
       procedure Button1Click(Sender: TObject);
       procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
       procedure ComDataPacket1CustomStart(Sender: TObject; const Str: string;
         var Pos: Integer);
       procedure ComDataPacket1CustomStop(Sender: TObject; const Str: string;
         var Pos: Integer);
  //private
    { Private declarations }
    var
    FInitFlag:Boolean;
    FIni:TMemIniFile;
    iniPath: string;

  //public
    { Public declarations }
  //end;

//var
  comForm: TForm;

implementation

//{$R *.DFM}

//uses Clipbrd;
procedure ConnButtonClick(Sender: TObject);
begin
  ComTerminal.Connected:= not ComTerminal.Connected;
  //StrToXmlTime MapDateTime GetEncoding XmlTimeToStr
end;

procedure COMPortCreate(Sender: TObject);
//var
  //Ini: TIniFile;
  var  //inipath: string;
    cmon: TCustomControl; //2TCPortMonitor;
begin
  comPort:= TComPort.Create(self);
  //cmon.loaded;
  with comPort do begin
    BaudRate:= br9600;
    //Port:= 'COM'+InttoStr(ACOMPORT);
    Port:= 'COM4'; //, +InttoStr(ACOMPORT);
  
    Parity.Bits:= prNone;
    StopBits:= sbOneStopBit;
    DataBits:= dbEight;
    Events:= [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, 
                              evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow:= False
    FlowControl.OutDSRFlow:= False
    FlowControl.ControlDTR:= dtrDisable
    FlowControl.ControlRTS:= rtsDisable
    FlowControl.XonXoffOut:= False
    FlowControl.XonXoffIn:= False
    StoredProps:= [spBasic]
    name:= 'comterminal26ini';     //section name for ini file!
    TriggersOnRxChar:= False
    OnAfterOpen:= @ComPortAfterOpen
    OnAfterClose:= @ComPortAfterClose
  
  end;
  
  ComDataPacket1:= TComDataPacket.create(self);
  ComDataPacket1.ComPort:= ComPort;
  with ComDataPacket1 do begin
    CaseInsensitive:= True
    IncludeStrings:= True
    MaxBufferSize:= 50
    StartString:= '1'
    StopString:= '6'
    OnPacket:= @ComDataPacket1Packet
    OnCustomStart:= @ComDataPacket1CustomStart
    OnCustomStop:= @ComDataPacket1CustomStop
  end;
  ComLed1:= TCOMLed.create(self)
  with comLed1 do begin
    parent:= comform
    setbounds(300,22,25,25)
     ComPort:= ComPort
      LedSignal:= lsConn
      Kind:= lkRedLight
   end;  
   
   ComTerminal:= TComTerminal.create(self)
   with comTerminal do begin
    writeln(botostr(hasparent))
    ComTerminal.parent:= comform;
    writeln(botostr(hasparent))
  
    comTerminal.ComPort:= ComPort;
  
    //setbounds(0,0,600,450);
    Align:= alClient
    Color:= clBlack;
    Emulation:= teVT100orANSI
    Font.Charset:= OEM_CHARSET
    Font.Color:= clWhite
    Font.Height:= -16
    Font.Name:= 'Terminal'
    Font.Style:= []  
    //PopupMenu:= PopupMenu1
    ScrollBars:= ssBoth
    TabOrder:= 0
    Caret:= tcUnderline
  end;
   
    
 //BinVal:= 0;
 //Ini:= TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
 //FIni:= TIniFile.Create(iniPath);
 if FileExists(iniPath) then begin
   writeln('COM Inifile: '+iniPath)
   //cbAuto.Checked:= Ini.ReadBool('ComPort', 'Auto',  True);
   //acbClear.Checked:= Ini.ReadBool('ComPort', 'Clear', False);
    //ini.Free;
   try
   ComPort.LoadSettings(stIniFile, iniPath);
    //ComPort.LoadSettings(stIniFile, inipath);
    Comport.Port:= 'COM4';
    ComPort.Open;
   except
     Showmessage('Unable to open COM port' +#10+#13 + 'Check the Port settings');
   end;
  if ComPort.Connected then begin
    //PIN_Checker(true, false);
    ComLed1.Kind:= lkGreenLight
    writeln('connected')
  end else
   ComLed1.Kind:= lkRedLight;
  Statusbar1.SimpleText:= ComPort.Port;
 end;
end;


Procedure BtnFactory(a,b,c,d: smallint; title,apic: string;
                        var abtn: TBitBtn; anEvent: TNotifyEvent);
begin
  abtn:= TBitBtn.create(comform);
  with abtn do begin
    parent:= comform;
    setBounds(a,b,c,d)
    font.size:= 12;
    glyph.LoadFromResourceName(HINSTANCE, apic); 
    mXButton(5,5,width, height,12,12,handle);
    caption:= title;
    onClick:= anEvent As TNotifyEvent; 
  end;
end; 


procedure InitComPortForm;
var lbls: byte;
begin
 comForm:= TForm.create(self);
 with comForm do begin
   //FormStyle := fsStayOnTop;
   Position:= poScreenCenter;
   caption:='COM Port meets Arduino Pin PortB';
   width:= 700; height:= 560;
   //onCreate:= @TFrm_FormCreate;        
   onClose:= @FormClose;
   Show;
   //canvas.brush.bitmap:= getBitmapObject(Exepath+BACKMAP);
   //Canvas.FillRect(Rect(600,400,210,100));
 end;
  //Constructors & settings
  
  iniPath:= ChangeFileExt(maxform1.scriptname, '.ini');
{  BtnFactory(500,440,150,55,'&COM About','LEDbulbon',button1,@Button1click);
  BtnFactory(180,440,150,55,'&COM Setup','CL_MPNEXT',button2,@Button2click);
  BtnFactory(340,440,150,55,'&COM Send','CL_MPPLAY',button3,@Button3click);
  CheckBoxFactory(16,42,57,17, 'Led 1',acb0,@cb0click);
  CheckBoxFactory(16,66,57,17, 'Led 2',acb1,@cb1click);
  CheckBoxFactory(16,90,57,17, 'Led 3',acb2,@cb2click);
  CheckBoxFactory(16,114,57,17, 'Led 4',acb3,@cb3click);
  CheckBoxFactory(16,138,57,17, 'Led 5',acb4,@cb4click);
  CheckBoxFactory(16,160,57,17, 'Led 6',acb5,@cb5click);

  CheckBoxFactory(460,90,77,17, 'Send Now',cbauto,nil);
  CheckBoxFactory(460,114,77,17, 'Clear Ini',acbclear,nil);
  LabelFactory(302,70,39,13, 'Decimal:');
  

  with TLabel.create(self) do begin
    parent:= comfrm1;
     setBounds(16,12,69,13)
     Caption:= 'PIN Control';
     Font.Color:= clMaroon;
     Font.Size:= 13;
     Font.Style:= [fsBold];
  end;
  with TLabel.create(self) do begin
    parent:= comfrm1;
     setBounds(155,12,69,13)
     Caption:= 'Arduino PIN';
     Font.Color:= clNavy;
     Font.Size:= 13;
     Font.Style:= [fsBold];
  end;
  Edit1:= TEdit.create(comfrm1)
  with edit1 do begin
    parent:= comfrm1;
    setBounds(300,90,45,22)
    MaxLength:= 2
    TabOrder:= 0
    Text:= '0'
    OnKeyPress:= @Edit1KeyPress;
  end;
 
  lbls:= 42;
  for it:= 1 to 5 do begin
    LabelFactory(80,lbls,39,13, SIG);
    lbls:= lbls+24
  end;
  lbls:= 42;
  for it:= 1 to 6 do begin
    LabelFactory(156,lbls,38,13,'Digit '+inttoStr(it+7));
    lbls:= lbls+24
  end;
 
  with TDateTimePicker.Create(self) do begin
    parent:= comfrm1;
    Date;
    top:= 220; left:= 15;
    calAlignment:= albottom;
  end; }
  statusBar1:= TStatusBar.create(self);
  with statusBar1 do begin
    parent:= comForm;
    //simplepanel:= true;
    showhint:= true;
    hint:= 'this is LED BOX Terminal State';
     Panels.add;
     panels.items[0].width:= 200;
     Panels.add;
     panels.items[1].width:= 150;
  end;
  COMPortCreate(self); 
end;   //*********************End Form Build************************



procedure ComPortAfterOpen(Sender: TObject);
begin
  ConnButton.Caption:= 'Disconnect';
end;

procedure ComDataPacket1CustomStart(Sender: TObject;
                                          const Str: string; var Pos: Integer);
begin
  if pos >= 0 then
    StatusBar1.Panels[1].Text := 'Start @'+IntToSTr(pos);
end;

procedure ComDataPacket1CustomStop(Sender: TObject; const Str: string;
                                                            var Pos: Integer);
begin
  if Pos >=0 then
    StatusBar1.Panels[2].Text  := 'Stop @'+IntToSTr(pos);
end;

procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
begin
  StatusBar1.Panels[0].Text := 'FOUND: '+str+  '                                  '  ;
  ComDataPacket1.ResetBuffer;
end;

procedure ComPortAfterClose(Sender: TObject);
begin
  ConnButton.Caption := 'Connect';
end;

procedure Paste1Click(Sender: TObject);
var s:string;
begin
  s  := Clipboard.AsText;
  ComPort.WriteStr(s);
end;

procedure PortButtonClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;

procedure TermButtonClick(Sender: TObject);
begin
  ComTerminal.ShowSetupDialog;
end;

procedure FontButtonClick(Sender: TObject);
begin
   //(7self.selectFont;
  comterminal.SelectFont;
end;

procedure FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Assigned(FIni) then begin
     FIni.WriteString('ComPort', 'ComPort', ComPort.Port );
     FIni.WriteString('ComPort','BaudRate', BaudRateToStr( ComPort.BaudRate ) );
     FIni.WriteString('ComPort','FlowControl', FlowControlToStr(ComPort.FlowControl.FlowControl ));
     FIni.UpdateFile;
     FIni.Free;
   end;
   Comport.Free;
   ComTerminal.Free;
   action:= caFree;
end;

procedure FormShow(Sender: TObject);
begin
 if not FInitFlag then begin
   FInitFlag:= true;
   FIni:= TMemIniFile.Create( ExtractFilePath(Application.ExeName)+'terminal.ini');
   ComPort.Port:= FIni.ReadString('ComPort', 'ComPort',ComPort.Port);
   ComPort.BaudRate:= StrToBaudRate(FIni.ReadString('ComPort','BaudRate', '19200'));
   ComPort.FlowControl.FlowControl:= StrToFlowControl(FIni.ReadString('ComPort','FlowControl', 'Hardware'));
   ConnButton.Click;
 end;
end;

procedure Button1Click(Sender: TObject);
var  s:String;
begin
   ComPort.Connected := false;
   ComTerminal.Connected := false;
   Application.ProcessMessages;
   ComPort.Connected := true;
   ComPort.WriteStr('AT'+CHR(13));  {Send modem Command}
   Sleep(200);
   ComPort.ReadStr(S,80); {Get modem response.}
   if Pos('OK',s)>0 then
     Application.MessageBox( PChar('Modem is responding normally '+ComPort.Port), 'Test', MB_OK)
   else
    Application.MessageBox( PChar('No modem responding on '+ComPort.Port),'Test',MB_OK);
   ComPort.Connected:= false;
end;

begin

InitComPortForm;
ComPort.ShowSetupDialog;
ComTerminal.ShowSetupDialog;

end.


{
object MainForm: TMainForm
  Left = 372
  Top = 256
  Width = 977
  Height = 549
  Caption = 'Mini Terminal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 483
    Width = 969
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    object TerminalReady: TComLed
      Left = 8
      Top = 3
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsDSR
      Kind = lkRedLight
      RingDuration = 0
    end
    object Label1: TLabel
      Left = 33
      Top = 10
      Width = 69
      Height = 13
      Caption = 'Terminal ready'
    end
    object Label2: TLabel
      Left = 174
      Top = 10
      Width = 75
      Height = 13
      Caption = 'Carrier detected'
    end
    object ComLed1: TComLed
      Left = 143
      Top = 2
      Width = 25
      Height = 25
      ComPort = ComPort
      LedSignal = lsRLSD
      Kind = lkRedLight
      RingDuration = 0
    end
    object ConnButton: TButton
      Left = 288
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = ConnButtonClick
    end
    object PortButton: TButton
      Left = 376
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Serial Port'
      TabOrder = 1
      OnClick = PortButtonClick
    end
    object TermButton: TButton
      Left = 464
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Terminal'
      TabOrder = 2
      OnClick = TermButtonClick
    end
    object FontButton: TButton
      Left = 552
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Font'
      TabOrder = 3
      OnClick = FontButtonClick
    end
    object Button1: TButton
      Left = 756
      Top = 2
      Width = 153
      Height = 25
      Caption = 'Direct COM Check'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object ComTerminal: TComTerminal
    Left = 0
    Top = 0
    Width = 969
    Height = 464
    Align = alClient
    Color = clBlack
    ComPort = ComPort
    Emulation = teVT100orANSI
    Font.Charset = OEM_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = []
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 0
    Caret = tcUnderline
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 464
    Width = 969
    Height = 19
    Panels = <
      item
        Width = 500
      end
      item
        Width = 80
      end
      item
        Width = 80
      end
      item
        Width = 500
      end>
    SimpleText = '...'
  end
  object ComPort: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = True
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrEnable
    FlowControl.ControlRTS = rtsHandshake
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = False
    OnAfterOpen = ComPortAfterOpen
    OnAfterClose = ComPortAfterClose
    Left = 203
    Top = 222
  end
  object PopupMenu1: TPopupMenu
    Left = 204
    Top = 168
    object Copy1: TMenuItem
      Caption = 'Copy'
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
  end
  object ComDataPacket1: TComDataPacket
    ComPort = ComPort
    CaseInsensitive = True
    IncludeStrings = True
    MaxBufferSize = 50
    StartString = '1'
    StopString = '6'
    OnPacket = ComDataPacket1Packet
    OnCustomStart = ComDataPacket1CustomStart
    OnCustomStop = ComDataPacket1CustomStop
    Left = 192
    Top = 296
  end
end
}

