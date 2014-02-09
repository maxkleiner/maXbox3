unit ClntForm;

{ This program works in conjunction with the Monitor.dpr project to demonstrate
  advanced Win32 programming topics.  See Monform.pas for more information }

interface

uses
  Forms, Windows, Messages, SysUtils, StdCtrls, Classes, Controls,
  IPCThrd, Dialogs, ComCtrls, Graphics;

const
  WM_UPDATESTATUS = WM_USER + 2;

type
  TClientForm = class(TForm)
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    Flags: TClientFlags;
    IPCClient: TIPCClient;
//MC!    FStatusText: string;
    procedure OnConnect(Sender: TIPCThread; Connecting: Boolean);
    procedure OnSignal(Sender: TIPCThread; Data: TEventData);
    procedure UpdateStatusBar(var Msg: TMessage); message WM_UPDATESTATUS;
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.dfm}

procedure TClientForm.FormCreate(Sender: TObject);
var
  CNo, VCnt: Integer;
 //MC! C, T: Integer;
begin
  Caption := Format('%s (%X)', [Application.Title, GetCurrentProcessID]);
  try
    IPCClient := TIPCClient.Create(GetCurrentProcessID, Caption);
    IPCClient.OnConnect := OnConnect;
    IPCClient.OnSignal := OnSignal;
    IPCClient.Activate;
    if not (IPCClient.State = stConnected) then OnConnect(nil, False);
    VCnt := Screen.Height div (Height + 10);
    CNo := IPCClient.ClientCount - 1;
    Top := (CNo mod VCnt) * (Height + 10) + 10;
    Left := (Screen.Width div 2) + (CNo div VCnt) * (Width + 10);
  except
    Application.HandleException(ExceptObject);
    Application.Terminate;
  end;
end;

procedure TClientForm.FormDestroy(Sender: TObject);
begin
  IPCClient.Free;
end;

procedure TClientForm.OnConnect(Sender: TIPCThread; Connecting: Boolean);
begin
  PostMessage(Handle, WM_UPDATESTATUS, WPARAM(Connecting), 0);
end;

procedure TClientForm.OnSignal(Sender: TIPCThread; Data: TEventData);
begin
  Flags := Data.Flags;
end;

procedure TClientForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  EventData: TEventData;
begin
  if cfMouseMove in Flags then
  begin
    EventData.X := X;
    EventData.Y := Y;
    EventData.Flag := cfMouseMove;
    IPCClient.SignalMonitor(EventData);
  end;
end;

procedure TClientForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  EventData: TEventData;
begin
  if cfMouseDown in Flags then
  begin
    EventData.X := X;
    EventData.Y := Y;
    EventData.Flag := cfMouseDown;
    IPCClient.SignalMonitor(EventData);
  end;
end;

procedure TClientForm.FormResize(Sender: TObject);
var
  EventData: TEventData;
begin
  if cfResize in Flags then
  begin
    EventData.X := Width;
    EventData.Y := Height;
    EventData.Flag := cfResize;
    IPCClient.SignalMonitor(EventData);
  end;
end;

procedure TClientForm.FormClick(Sender: TObject);
begin
  if IPCClient.State <> stConnected then
    IPCClient.MakeCurrent;
end;

procedure TClientForm.UpdateStatusBar(var Msg: TMessage);
const
  ConnectStr: Array[Boolean] of PChar = ('Not Connected', 'Connected');
begin
  StatusBar.SimpleText := ConnectStr[Boolean(Msg.WParam)];
end;

end.
