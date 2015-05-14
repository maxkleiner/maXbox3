program MTMainForm;

//////////////////////////////////////////////////////////////////////
//  #sign:Administrator: PC08: 13/05/2015 11:07:12 PM 
//  Purpose: shows a COM Terminal Setup Dialog                      //
//  #path>E:\maxbox3\mXGit39991\maxbox3\examples\
//  Lines of Code #locs:85
//////////////////////////////////////////////////////////////////////

 var  
    //ComTerminal: TComTerminal;
    aComTerminal: TCustomComTerminal;
    comPort: TComPort;
    machine: string;
    addresses:tstringlist;
    adapters, strKind:string;


procedure COMPortCreate(Sender: TObject);
//var Ini: TIniFile;
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
    //OnAfterOpen:= @ComPortAfterOpen
    //OnAfterClose:= @ComPortAfterClose
  end;
end;

   
begin

  //InitComPortForm;
  
 { with TvtMainForm.create(self) do begin
    //formshow(self)
    showmodal
    free
    end;
  }
  
    aComTerminal:= TCustomComTerminal.create(self);
    EditComTerminal(acomTerminal);  //TComTrmSetForm
    acomTerminal.Free;
    
    writeln('search_adapter_key_networkcard: '+search_adapter_key_networkcard);
    
    //function Get_MACAddress: string;

    writeln('function Get_MACAddress: '+Get_MACAddress);
    writeln('function GetMACAddress2: '+GetMACAddress2);
   
    addresses:=tstringlist.create;
    machine:= 'PC08';    //'10.0.0.5';
    GetMacAddresses2(machine,addresses);
    //showmessage('machine:='+machine+#13#10+'MACAddress:'+addresses[0]);
    writeln('machine:='+machine+#13#10+'MACAddresses2: '+addresses[0]);
    addresses.Free;

    //ConnectDrive('k:', '\\Servername\C', True, True);
    //DisconnectNetDrive('k:', True, True, True);
    
    if GetConnectionKind(strKind) then
                                  Writeln(strKind);

end.


ref:
http://www.swissdelphicenter.ch/en/showcode.php?id=1206


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

