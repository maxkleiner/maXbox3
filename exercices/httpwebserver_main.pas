{***************************************************************
 *
 * Project  : HTTPServer
 * Unit Name: Basic demo showing how to construct a HTTP server and handle basic input
 * Purpose  :  cipher & authenticate a web connection
 * Version  : 1.9
 * Date  : Wed 25 Apr 2001  -  01:21:56
 * Author  : <unknown>
 * History  :
 * Tested : Wed 25 Apr 2001  // Allen O'Neill <allen_oneill@hotmail.com>
 *  *     : 11.6.02 max@kleiner.com
          : 16.12.04 actuate port&ip in code
          : 05.06.08 strong changes in verify depth and integration SD PKI
          : 06.06.08 port to D7 with IOHandler instead of Interceptor
          : 09.06.08 ckecks and correct config for sslv3 protocol,
          : 25.10.08 migrate to d2007 with indy 10, idglobalProtocol new and so on...
          : 2.0 ; 22.11.08 extensins to ini-file and port bug corrected
 ****************************************************************}
// you need to install the win openssl suite
// you need to copy the msvcr71.dll ?
// copy 2 certificates and rsa key
// set a simple onVerifyPeer(), loc's = 663

unit Main;

interface

uses
{$IFDEF Linux}
   QGraphics,  QControls,  QForms,  QActnList,  QStdCtrls,  QButtons,
     QComCtrls,  QExtCtrls,
{$ELSE}
   Controls,  Forms,  ActnList,  StdCtrls,  Buttons,  ComCtrls, ExtCtrls,
{$ENDIF}
  windows, SysUtils,  Classes, IdComponent, IdHTTPServer,
    IdGlobal, IdBaseComponent, {IdThreadMgr,IdThreadMgrDefault,IdThreadMgrPool,} SyncObjs,
     IDContext, IdGlobalProtocols, IdSSLOpenSSL, halfminute, IdCustomHTTPServer,
      IdServerIOHandler, IdCustomTCPServer, IdSSL;

type
  TfmHTTPServerMain = class(TForm)
    HTTPServer: TIdHTTPServer;
    alGeneral: TActionList;
    acActivate: TAction;
    edPort: TEdit;
    cbActive: TCheckBox;
    StatusBar1: TStatusBar;
    LabelRoot: TLabel;
    cbAuthentication: TCheckBox;
    cbManageSessions: TCheckBox;
    cbEnableLog: TCheckBox;
    Label1: TLabel;
    Panel1: TPanel;
    lbLog: TListBox;
    lbSessionList: TListBox;
    Splitter1: TSplitter;
    //d6 IdServerInterceptOpenSSL: TIdServerInterceptOpenSSL;
    cbSSL: TCheckBox;
    cbtimeron: TCheckBox;
    //d7 IdServerIOHandlerSSL1: TIdServerIOHandlerSSL;
    edRoot: TEdit;
    cbsslMode: TCheckBox;
    IdServerIOHandlerSSL1: TIdserverIOHandlerSSLOpenSSL;
    lbldws: TLabel;
    procedure acActivateExecute(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edPortKeyPress(Sender: TObject; var Key: Char);
    procedure edPortExit(Sender: TObject);
    procedure HTTPServerCommandGet(AThread: TIdContext;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPServerSessionEnd(Sender: TIdHTTPSession);
    procedure HTTPServerSessionStart(Sender: TIdHTTPSession);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbSessionListDblClick(Sender: TObject);
    procedure cbSSLClick(Sender: TObject);
    procedure HTTPServerConnect(AThread: TIdContext);
    procedure HTTPServerDisconnect(AThread: TIdContext);
    procedure HTTPServerExecute(AThread: TIdContext);
    //procedure HTTPServerCommandOther(Thread: TIdContext;
      //                   const asCommand, asData, asVersion: string);
    procedure HTTPServerStatus(ASender: TObject;
              {thetime: TDateTime;} const AStatus: TIdStatus;
      const AStatusText: string);
    procedure cbtimeronClick(Sender: TObject);
    procedure cbsslModeClick(Sender: TObject);
    function IdServerIOHandlerSSL1VerifyPeer(
      Certificate: TIdX509; certok: boolean): Boolean;
    procedure HTTPServerException(AContext: TIdContext; AException: Exception);
    procedure HTTPServerCommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    UILock: TCriticalSection;
    myhalfminute: THalfminute;
    procedure HTTPServerStatus2(ASender: TObject;
              thetime: TDateTime);
    procedure ServeVirtualFolder(AThread: TIdContext;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure DisplayMessage(const Msg: string);
    procedure DisplaySessionChange(const session: string);
    procedure ManageUserSession(AThread: TIdContext;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    function GetMIMEType(sFile: TFileName): string;
    function GetOpenSSLVersion: string;
    { Private declarations }
  public
    { Public declarations }
    EnableLog: boolean;
    MIMEMap: TIdMIMETable;
    procedure MyInfoCallback(Msg: string);
    procedure GetKeyPassword(var Password: string);
  end;

var
  fmHTTPServerMain: TfmHTTPServerMain;

implementation

uses  FileCtrl, IdStack, iniFiles, IdSSLOpenSSLHeaders;

{$IFDEF MSWINDOWS}{$R *.dfm}{$ELSE}{$R *.xfm}{$ENDIF}

const
  CAUTHENTICATIONREALM = 'openSSL https server demo';


procedure TfmHTTPServerMain.acActivateExecute(Sender: TObject);
var
  AppDir: string;
 _IniFile: TIniFile;
begin
  acActivate.Checked := not acActivate.Checked;
  lbSessionList.Items.Clear;
  AppDir:= ExtractFilePath(Application.ExeName);
  _IniFile:= TIniFile.Create(AppDir + 'IP_A.INI');
  if not HTTPServer.Active then begin
    HTTPServer.Bindings.Clear;
    HTTPServer.DefaultPort:= StrToIntDef(edPort.text, 80);
    HTTPServer.Bindings.Add;
  end;
  edRoot.text:= AppDir + _IniFile.ReadString('SERVER', 'WEBROOT', '');
  if not DirectoryExists(edRoot.text) then begin
    DisplayMessage(Format('Web root folder (%s) not found.', [edRoot.text]));
    acActivate.Checked:= False;
  end else begin
    if acActivate.Checked then begin
     try
       EnableLog:= cbEnableLog.Checked;
       HTTPServer.SessionState := cbManageSessions.Checked;
       //HTTPServer.Bindings.Items[0].IP:= '192.168.133.15';
       HTTPServer.Bindings.Items[0].IP:=_IniFile.ReadString('SERVER', 'HOST', '');
       //HTTPServer.Bindings.Items[0].IP:= 'milo';
       HTTPServer.Bindings.Items[0].port:=
                         StrToInt(_IniFile.ReadString('SERVER', 'PORT', ''));
       edPort.Text:= _IniFile.ReadString('SERVER', 'PORT', '');
      //openSSL configuration
      if cbSSL.Checked then begin
       //d6 with IdServerInterceptOpenSSL.SSLOptions do begin
       with IdServerIOHandlerSSL1.SSLOptions do begin
         Mode:= sslmServer;
         Method:= sslvSSLv23;
         VerifyDepth:= 3;
         //sslvrfFailNoPeerCert, sslvrfPeer
         VerifyMode:= [sslvrfFailifNoPeerCert];
         //VerifyMode:= [sslvrfFailifNoPeerCert, sslvrfPeer]; eg. client!
         RootCertFile:= AppDir + _IniFile.ReadString('CERT', 'ROOTCERT', '');
         CertFile:= AppDir + _IniFile.ReadString('CERT', 'SCERT', '');
         KeyFile:= AppDir + _IniFile.ReadString('CERT', 'RSAKEY', '');
       end;
        HTTPServer.Bindings.Items[0].port:=
                         StrToInt(_IniFile.ReadString('SERVER', 'SSLPORT', ''));
        edPort.Text:= _IniFile.ReadString('SERVER', 'SSLPORT', '');
        IdServerIOHandlerSSL1.OnStatusInfo:= MyInfoCallback;
        IdServerIOHandlerSSL1.OnGetPassword:= GetKeyPassword;
        IdServerIOHandlerSSL1.OnVerifyPeer:= IdServerIOHandlerSSL1VerifyPeer;
        //d6HTTPServer.Intercept:= IdServerIOHandlerSSL1;
        HTTPServer.IOHandler:= IdServerIOHandlerSSL1;
        DisplayMessage(Format('OpenSSLVersion is: %s', [getOpenSSLVersion]));
      end; // END SSL stuff
        HTTPServer.Active:= true;
        if HTTPServer.Active then begin
          statusbar1.SimpleText:= 'http active on v1.9';
          //+ [IdServerInterceptOpenSSL.SSLOptions.Method]
          DisplayMessage(Format('OpenSSLVersion is: %s', [getOpenSSLVersion]))
        end else
          statusbar1.simpletext:= 'http inactive';
       DisplayMessage(format('Listening for HTTP connections on %s:%d.',
                 [HTTPServer.Bindings[0].IP, HTTPServer.Bindings[0].Port]));
     except
       on e: exception do begin
         acActivate.Checked:= False;
         DisplayMessage(format('Exception %s in Activate. Error is:"%s".',
                                      [e.ClassName, e.Message]));
       end;
     end;
    end else begin
      HTTPServer.Active:= false;
      //SSL to set back
      HTTPServer.Intercept:= NIL;
      HTTPServer.IOHandler:= NIL;
      DisplayMessage('Stop http listening.');
      statusbar1.SimpleText:= 'http server inactive';
    end; //if
  end;
  edPort.Enabled:= not acActivate.Checked;
  edRoot.Enabled:= not acActivate.Checked;
  cbAuthentication.Enabled:= not acActivate.Checked;
  cbEnableLog.Enabled:= not acActivate.Checked;
  cbManageSessions.Enabled:= not acActivate.Checked;
  cbsslMode.Enabled:= not acActivate.Checked;
  _IniFile.Free;
end;

procedure TfmHTTPServerMain.edPortChange(Sender: TObject);
var
  FinalLength, i: Integer;
  FinalText: string;
begin
  // Filter routine. Remove every char that is not a numeric (must that for cut'n paste)
  Setlength(FinalText, length(edPort.Text));
  FinalLength := 0;
  for i:= 1 to length(edPort.Text) do begin
    if edPort.text[i] in ['0'..'9'] then begin
      inc(FinalLength);
      FinalText[FinalLength]:= edPort.text[i];
    end;
  end;
  SetLength(FinalText, FinalLength);
  edPort.text:= FinalText;
end;

procedure TfmHTTPServerMain.edPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
    Key:= #0;
end;

procedure TfmHTTPServerMain.edPortExit(Sender: TObject);
begin
  if length(trim(edPort.text)) = 0 then
    edPort.text:= '80';
end;

procedure TfmHTTPServerMain.ManageUserSession(AThread: TIdContext;
    RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  NumberOfView: Integer;
begin
  // Manage session informations
  if assigned(RequestInfo.Session) or (HTTPServer.CreateSession(AThread,
      ResponseInfo, RequestInfo) <> NIL) then begin
    RequestInfo.Session.Lock;
    try
      NumberOfView:=
        StrToIntDef(RequestInfo.Session.Content.Values['NumViews'], 0);
      inc(NumberOfView);
      RequestInfo.Session.Content.Values['NumViews']:= IntToStr(NumberOfView);
      RequestInfo.Session.Content.Values['UserName']:=
                                   RequestInfo.AuthUsername;
      RequestInfo.Session.Content.Values['Password']:=
                                   RequestInfo.AuthPassword;
    finally
      RequestInfo.Session.Unlock;
    end;
  end;
end;

procedure TfmHTTPServerMain.ServeVirtualFolder(AThread: TIdContext;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  ResponseInfo.ContentType:= 'text/HTML';
  ResponseInfo.ContentText:=
    '<html><head><title>Virtual folder</title></head><body>';
  if AnsiSameText(RequestInfo.Params.Values['action'], 'close') then begin
    // Closing user session
    RequestInfo.Session.Free;
    ResponseInfo.ContentText:= ResponseInfo.ContentText +
      '<h1>Session cleared</h1><p><a href="/sessions">Back</a></p>';
  end else begin
    if assigned(RequestInfo.Session) then begin
      if Length(RequestInfo.Params.Values['ParamName']) > 0 then begin
        // Add a new parameter to the session
        ResponseInfo.Session.Content.Values[RequestInfo.Params.Values['ParamName']]
                            := RequestInfo.Params.Values['Param'];
      end;
      ResponseInfo.ContentText:= ResponseInfo.ContentText +
        '<h1>Session informations</h1>';
      RequestInfo.Session.Lock;
      try
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<table border=1>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<tr><td>SessionID</td><td>' + RequestInfo.Session.SessionID +
          '</td></tr>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<tr><td>Number of page requested during this session</td><td>' +
          RequestInfo.Session.Content.Values['NumViews'] + '</td></tr>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<tr><td>Session data (raw)</td><td><pre>' +
          RequestInfo.Session.Content.Text + '</pre></td></tr>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText + '</table>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<h1>Tools:</h1>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<h2>Add new parameter</h2>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<form method="POST">';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<p>Name: <input type="text" Name="ParamName"></p>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<p>value: <input type="text" Name="Param"></p>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<p><input type="Submit"><input type="reset"></p>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText + '</form>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText +
          '<h2>Other:</h2>';
        ResponseInfo.ContentText:= ResponseInfo.ContentText + '<p><a href="' +
          RequestInfo.Document + '?action=close">Close current session</a></p>';
      finally
        RequestInfo.Session.Unlock;
      end;
    end else begin
      ResponseInfo.ContentText := ResponseInfo.ContentText +
        '<p color=#FF000>No session</p>';
    end;
  end;
  ResponseInfo.ContentText:= ResponseInfo.ContentText + '</body></html>';
end;

procedure TfmHTTPServerMain.DisplaySessionChange(const Session: string);
var
  Index: integer;
begin
  if EnableLog then begin
    UILock.Acquire;
    try
      Index:= lbSessionList.Items.IndexOf(Session);
      if Index > -1 then
        lbSessionList.Items.Delete(Index)
      else
        lbSessionList.Items.Append(Session);
    finally
      UILock.Release;
    end;
  end;
end;

procedure TfmHTTPServerMain.DisplayMessage(const Msg: string);
begin
  if EnableLog then begin
    UILock.Acquire;
    try
      lbLog.ItemIndex:= lbLog.Items.Add(Msg);
    finally
      UILock.Release;
    end;
  end;
end;

procedure TfmHTTPServerMain.HTTPServerCommandGet(AThread: TIdContext;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);

  procedure AuthFailed;
  begin
    ResponseInfo.ContentText:=
      '<html><head><title>Error</title></head><body><h1>Authentication failed</h1>'#13 +
      'Check the file ip_a.ini to discover the demo password:<br><ul><li>Search for '#13 +
      '<b>AuthUsername</b> in <b>Main.pas</b>!</ul></body></html>';
    ResponseInfo.AuthRealm:= CAUTHENTICATIONREALM;
  end;

  procedure AccessDenied;
  begin
    ResponseInfo.ContentText:=
      '<html><head><title>Error</title></head><body><h1>Access denied</h1>'#13 +
      'You do not have sufficient priviligies to access this document.</body></html>';
    ResponseInfo.ResponseNo:= 403;
  end;

var
  LocalDoc: string;
  ByteSent: Cardinal;
  ResultFile: TFileStream;
begin
  // Log the request with time stamp
  DisplayMessage(Format('Command %s %s at %-10s received from %s:%d',
    [ RequestInfo.Command, RequestInfo.Document, DateTimeToStr(Now),
    //d6AThread.Connection.Binding.PeerIP, AThread.Connection.Binding.PeerPort]));
    AThread.Connection.Socket.Binding.PeerIP,
                          AThread.Connection.Socket.Binding.PeerPort]));
  if cbAuthentication.Checked and
    ((RequestInfo.AuthUsername <> 'Indy') or (RequestInfo.AuthPassword <>
      'rocks')) then begin
    AuthFailed;
    exit;
  end;
  if cbManageSessions.checked then
    ManageUserSession(AThread, RequestInfo, ResponseInfo);
  if (Pos('/session', LowerCase(RequestInfo.Document)) = 1) then begin
    ServeVirtualFolder(AThread, RequestInfo, ResponseInfo);
  end else begin
    // Interprete the command to it's final path (avoid sending files in parent folders)
    LocalDoc:= ExpandFilename(edRoot.text + RequestInfo.Document);
    // Default document (index.html) for folder
    if not FileExists(LocalDoc) and DirectoryExists(LocalDoc) and
      FileExists(ExpandFileName(LocalDoc + '/index.html')) then
       LocalDoc:= ExpandFileName(LocalDoc + '/index.html');
    if FileExists(LocalDoc) then begin// File exists
      if AnsiSameText(Copy(LocalDoc, 1, Length(edRoot.text)), edRoot.Text) then
        // File down in dir structure
      begin
        if AnsiSameText(RequestInfo.Command, 'HEAD') then begin
          // HEAD request, don't send the document but still send back it's size
          ResultFile:= TFileStream.create(LocalDoc, fmOpenRead or
            fmShareDenyWrite);
          try
            ResponseInfo.ResponseNo:= 200;
            ResponseInfo.ContentType:= GetMIMEType(LocalDoc);
            ResponseInfo.ContentLength:= ResultFile.Size;
          finally
            ResultFile.Free;
              // We must free this file since it won't be done by web server component
          end;
        end else begin
          // Normal document request
          // Send the document back
          //ByteSent := HTTPServer.ServeFile(AThread, ResponseInfo, LocalDoc);
          ByteSent:= ResponseInfo.ServeFile(AThread, LocalDoc);
          DisplayMessage(Format('Serving file %s (%d bytes / %d bytes sent) to %s:%d',
            [LocalDoc, ByteSent, FileSizeByName(LocalDoc),
            AThread.Connection.Socket.Binding.PeerIP,
              AThread.Connection.Socket.Binding.PeerPort]));
        end;
      end else
        AccessDenied;
    end else begin
      ResponseInfo.ResponseNo:= 404; // Not found
      ResponseInfo.ContentText:=
        '<html><head><title>Error</title></head><body><h1>' +
        ResponseInfo.ResponseText + '</h1></body></html>';
    end;
  end;
end;

procedure TfmHTTPServerMain.HTTPServerCommandOther(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  DisplayMessage('Command other: ' + AresponseInfo.ContentText);
end;

procedure TfmHTTPServerMain.FormCreate(Sender: TObject);
begin
  UILock:= TCriticalSection.Create;
  MIMEMap:= TIdMIMETable.Create(true);
  fmHTTPServerMain.Width:= 817;
  fmHTTPServerMain.Height:= 441;
  edPort.ReadOnly:= true;
  if HTTPServer.active then
    statusbar1.SimpleText:= 'server active on'
     //getOpenSSLVersion later
  else
    statusbar1.SimpleText:= 'server inactive';
end;

procedure TfmHTTPServerMain.FormDestroy(Sender: TObject);
begin
  MIMEMap.Free;
  UILock.Free;
end;

function TfmHTTPServerMain.GetMIMEType(sFile: TFileName): string;
begin
  result:= MIMEMap.GetFileMIMEType(sFile);
end;

procedure TfmHTTPServerMain.HTTPServerSessionEnd(Sender: TIdHTTPSession);
var
  dt: TDateTime;
  i: Integer;
  hour, min, s, ms: word;
begin
  DisplayMessage(Format('Ending session %s at %s', [Sender.SessionID,
    FormatDateTime(LongTimeFormat, now)]));
  dt:= (StrToDateTime(sender.Content.Values['StartTime']) - now);
  DecodeTime(dt, hour, min, s, ms);
  i:= ((Trunc(dt) * 24 + hour) * 60 + min) * 60 + s;
  DisplayMessage(Format('Session duration was: %d seconds', [i]));
  DisplaySessionChange(Sender.SessionID);
end;

procedure TfmHTTPServerMain.HTTPServerSessionStart(Sender: TIdHTTPSession);
begin
  sender.Content.Values['StartTime']:= DateTimeToStr(Now);
  DisplayMessage(Format('Starting session %s at %s', [Sender.SessionID,
                          FormatDateTime(LongTimeFormat, now)]));
  DisplaySessionChange(Sender.SessionID);
end;

procedure TfmHTTPServerMain.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
begin
  //deactivate the server
  if cbActive.Checked then
    acActivate.execute;
end;

procedure TfmHTTPServerMain.lbSessionListDblClick(Sender: TObject);
begin
  if lbSessionList.ItemIndex > -1 then
    HTTPServer.EndSession(lbSessionList.Items[lbSessionList.ItemIndex]);
end;

// SSL event handler mat
procedure TfmHTTPServerMain.MyInfoCallback(Msg: string);
begin
  DisplayMessage(Msg);
end;

procedure TfmHTTPServerMain.GetKeyPassword(var Password: string);
begin
  Password:= 'belplan02'; // this is a password for unlocking the server
  // key RSA. If you have your own key, then it would probably be different
end;

procedure TfmHTTPServerMain.cbSSLClick(Sender: TObject);
begin
  if cbSSL.Checked then
    DisplayMessage('https on')
  else
    DisplayMessage('http on')
end;

procedure TfmHTTPServerMain.cbsslModeClick(Sender: TObject);
begin
 if cbSSLmode.Checked then begin
    IdServerIOHandlerSSL1.SSLOptions.Method:= sslvSSLv3;
 end else begin
    IdServerIOHandlerSSL1.SSLOptions.Method:= sslvSSLv2;
  end;
end;

function TfmHTTPServerMain.GetOpenSSLVersion: string;
var
  v: cardinal;
  s: PChar;
begin
  try
    if (@IdSSLeay <> nil) and (@IdSSLeay_version <> nil) then begin
      v:= idSSLeay;
      s:= IdSSLeay_version(OPENSSL_SSLEAY_VERSION);
      Result:= s + ' (' + IntToHex(v, 9) + ')';
    end else
      Result:= 'no openSSL Lib Version available';
  except
    //if cDebugging then
     //MessageBox(0, 'Error in "function TfrmDWSServer.GetOpenSSLVersion:
      //string"', cMessageBoxTitelError, MB_OK);
  end;
end;


function TfmHTTPServerMain.IdServerIOHandlerSSL1VerifyPeer(
                                        Certificate: TIdX509; certok: boolean): Boolean;
const
  fingerprint_bel_cert: array[0..31] of char =
           ('7','1','6','2','A','C','3','1','A','D','3','4',
            '6','B','B','3','9','8','7','B','0','3','3',
            'B','7','F','B','8','6','2','6','0');
begin
  //doVerifyPeer; section is experimental for cross certificate security!
  if (Pos('SDTEST-CA1', UpperCase(Certificate.Issuer.OneLine)) > 0)
   and (Pos('WWW.BELPLAN02.CH', UpperCase(certificate.Subject.OneLine)) > 0) then
    begin
      displaymessage(Format('%-20s %s', [DateTimeToStr(Now),
                           certificate.FingerprintAsString+' fingerprint of cert']));
      displayMessage(Format('%-20s %s', [DateTimeToStr(Now),
                        Certificate.subject.HashAsString+' hash of subject_cert']));
      //certificate.notAfter
      if certOk then
      displayMessage(Format('%-20s %s', [DateTimeToStr(Now),
                        Certificate.subject.HashAsString+' Cert OK!']));
   end;
end;
//End SSL mat stuff

procedure TfmHTTPServerMain.HTTPServerConnect(AThread: TIdContext);
begin
  DisplayMessage(Format('%-20s %s', [DateTimeToStr(Now), 'User logged in']));
end;

procedure TfmHTTPServerMain.HTTPServerDisconnect(AThread: TIdContext);
begin
  DisplayMessage(Format('%-20s %s', [DateTimeToStr(Now), 'User logged out']));
end;

procedure TfmHTTPServerMain.HTTPServerException(AContext: TIdContext;
  AException: Exception);
begin
  // to return error code
end;

procedure TfmHTTPServerMain.HTTPServerExecute(AThread: TIdContext);
begin
  DisplayMessage('Execute Server Service');
end;

{procedure TfmHTTPServerMain.HTTPServerCommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  DisplayMessage('Command other: ' + AresponseInfo.ContentText);
end;}

procedure TfmHTTPServerMain.HTTPServerStatus(ASender: TObject;
                           {thetime: TDateTime;}
                 const AStatus: TIdStatus; const AStatusText: string);
begin
  DisplayMessage('Status max: ' + aStatusText);
end;

procedure TfmHTTPServerMain.cbtimeronClick(Sender: TObject);
//var myhalfminute: THalfminute;
begin
  if cbtimeron.Checked then begin
     myhalfminute:= THalfminute.create(self);
     myhalfminute.timeInterval:= quartminute;
     myhalfminute.onHalfMinute:= httpserverStatus2;
  end else begin
    if assigned(myhalfminute) then begin
      myhalfminute.Free;
      myhalfminute:= NIL
    end
  end;
end;

procedure TfmHTTPServerMain.HTTPServerStatus2(ASender: TObject; thetime: TDateTime);
begin
  DisplayMessage(FormatDateTime('dddd, d. mmmm yyyy, hh:mm:ss', + thetime));
end;

end.

{procedure TIdTCPConnection.DisconnectSocket;
var dt: TDateTime;
begin
   dt:= NOW;
  if Binding.HandleAllocated then begin
    DoStatus(hsDisconnecting, dt,[Binding.PeerIP]);
    Binding.CloseSocket;
    FClosedGracefully := True;
    DoStatus(hsDisconnected, dt,[Binding.PeerIP]);
    //Status(hsDisconnected, NOW); overloaded
    DoOnDisconnected;
  end;
  if InterceptEnabled then begin
    Intercept.Disconnect;
  end;
end;
  procedure DoStatus(axStatus: TIdStatus); overload;
  procedure DoStatus(axStatus: TIdStatus; thetime: TDateTime); overload;
  procedure DoStatus(axStatus: TIdStatus; thetime: TDateTime;
                const aaArgs: array of const); overload;
}
