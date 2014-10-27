unit uPSI_NMEA;
{
  for GPS and David I
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_NMEA = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_NMEA(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NMEA_Routines(S: TPSExec);

procedure Register;

implementation


uses
   NMEA, Windows, Strutils, Tlhelp32, Forms, winsock, mmsystem, dialogs;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_NMEA]);
end;

const
  MaxTicks    = 39045157;   {Max ticks, 24.8 days}

  {Clock frequency of 1193180/65536 is reduced to 1675/92. This}
  {allows longint conversions of Ticks values upto TicksPerDay}
  TicksFreq = 1675;
  SecsFreq  = 92;
  MSecsFreq = 92000;

function Ticks2Secs(Ticks : LongInt) : LongInt;
    {-Returns seconds value for Ticks Ticks}
  begin
    Ticks2Secs := ((Ticks + 9) * SecsFreq) div TicksFreq;
  end;

  function Secs2Ticks(Secs : LongInt) : LongInt;
    {-Returns Ticks value for Secs seconds}
  begin
    Secs2Ticks := (Secs * TicksFreq) div SecsFreq;
  end;

  function MSecs2Ticks(MSecs : LongInt) : LongInt;
    {-Returns Ticks value for msecs}
  begin
    Result := (MSecs * TicksFreq) div MSecsFreq;
  end;

  function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar;
                            Visibility : Integer) : Integer;
 { returns -1 if the Exec failed, otherwise returns the process' exit }
 { code when the process terminates }
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:ShortString;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Temp : DWORD;
begin
  StrCopy(zAppName, FileName);
  if assigned(CommandLine) then                                        
    StrCat(zAppName, CommandLine);                                     
  GetDir(0, WorkDir);                                                  
  StrPCopy(zCurDir, WorkDir);                                          
  FillChar(StartupInfo, Sizeof(StartupInfo),#0);                       
  StartupInfo.cb := Sizeof(StartupInfo);                               
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;                         
  StartupInfo.wShowWindow := Visibility;                               
  if not CreateProcess(nil,                                            
      zAppName,              { pointer to command line string }        
      nil,                   { pointer to process security attributes }
      nil,                   { pointer to thread security attributes } 
      false,                 { handle inheritance flag }               
      CREATE_NEW_CONSOLE or  { creation flags }                        
      NORMAL_PRIORITY_CLASS,
      nil,                   { pointer to new environment block }
      nil,                   { pointer to current directory name }
      StartupInfo,           { pointer to STARTUPINFO }                
      ProcessInfo) then      { pointer to PROCESS_INF }                
        Result := -1                                                   
  else begin                                                           
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);                
    GetExitCodeProcess(ProcessInfo.hProcess,Temp);
    CloseHandle(ProcessInfo.hProcess);                                   {!!.02}
    CloseHandle(ProcessInfo.hThread);                                    {!!.02}
    Result := Integer(Temp);                                           
  end;                                                                 
end;


const CRLF = #13#10;
function getStringTickCount: string;
begin
  result:= 'cr:= GetTickCount();'+CRLF+ 
           'ia:= round(LinesCount(fn));'+CRLF+
           'f:= GetTickCount();'+CRLF+
           'a:= f -cr;'+CRLF+
           'PrintF(''Lines: %.n Ticks: %.n'',[ia *1.0, a *1.0]);'
end;


procedure DeleteLine(StrList: TStringList; SearchPattern: String);
var
  Index : Integer;
 begin
 for Index := 0 to StrList.Count-1 do
  begin
   if ContainsText(StrList[Index], SearchPattern) then
    begin
     StrList.Delete(Index);
     Break;
    end;
  end;
end;


function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

const WM_CLOSE =$0010;

procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);

  if isWindow(hWindowHandle) then begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
end;

function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;

function IPAddrToHostName(const IP: string): string;
var
  i: Integer;
  p: PHostEnt;
begin
  Result := '';
  i      := inet_addr(PChar(IP));
  if i <> u_long(INADDR_NONE) then
  begin
    p := GetHostByAddr(@i, SizeOf(Integer), PF_INET);
    if p <> nil then Result := p^.h_name;
  end
  else
    Result := 'Invalid IP address';
end;

procedure SendMCICommand(Cmd: string);
var
  RetVal: Integer;
  ErrMsg: array[0..254] of char;
begin
  RetVal := mciSendString(PChar(Cmd), nil, 0, 0);
  if RetVal <> 0 then begin
    {get message for returned value}
    mciGetErrorString(RetVal, ErrMsg, 255);
    MessageDlg(StrPas(ErrMsg), mtError, [mbOK], 0);
  end;
end;







(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_NMEA(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('NMEADataArray', 'array of string');
 CL.AddDelphiFunction('Procedure TrimNMEA( var S : string)');
 CL.AddDelphiFunction('Procedure ExpandNMEA( var S : string)');
 CL.AddDelphiFunction('Function ParseNMEA( S : string) : NMEADataArray');
 CL.AddDelphiFunction('Function ChkValidNMEA( S : string) : Boolean');
 CL.AddDelphiFunction('Function IdNMEA( S : string) : string');
 CL.AddDelphiFunction('Function ChkSumNMEA( const S : string) : string');
 CL.AddDelphiFunction('Function PosInDeg( const PosStr : string) : Double');
 CL.AddDelphiFunction('Function DateTimeNMEA( const StrD, StrT : string) : TDateTime');
 CL.AddDelphiFunction('Function SysClockSet( const StrD, StrT : string) : Boolean');
 CL.AddDelphiFunction('function Ticks2Secs(Ticks : LongInt) : LongInt;');
CL.AddDelphiFunction('function Secs2Ticks(Secs : LongInt) : LongInt;');
CL.AddDelphiFunction('function MSecs2Ticks(MSecs : LongInt) : LongInt;');
CL.AddDelphiFunction('function MSecs2Ticks(MSecs : LongInt) : LongInt;');
CL.AddDelphiFunction('function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar; Visibility:Integer):Integer;');
CL.AddDelphiFunction('function getStringTickCount: string;');
CL.AddDelphiFunction('procedure DeleteLine(StrList: TStringList; SearchPattern: String);');
CL.AddDelphiFunction('function KillTask(ExeFileName: string): Integer;');
CL.AddDelphiFunction('procedure KillProcess(hWindowHandle: HWND);');
CL.AddDelphiFunction('function FindWindowByTitle(WindowTitle: string): Hwnd;');
CL.AddDelphiFunction('function IPAddrToHostName(const IP: string): string;');
CL.AddDelphiFunction('function URLAddrToHostName(const IP: string): string;');
CL.AddDelphiFunction('procedure SendMCICommand(Cmd: string);');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_NMEA_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TrimNMEA, 'TrimNMEA', cdRegister);
 S.RegisterDelphiFunction(@ExpandNMEA, 'ExpandNMEA', cdRegister);
 S.RegisterDelphiFunction(@ParseNMEA, 'ParseNMEA', cdRegister);
 S.RegisterDelphiFunction(@ChkValidNMEA, 'ChkValidNMEA', cdRegister);
 S.RegisterDelphiFunction(@IdNMEA, 'IdNMEA', cdRegister);
 S.RegisterDelphiFunction(@ChkSumNMEA, 'ChkSumNMEA', cdRegister);
 S.RegisterDelphiFunction(@PosInDeg, 'PosInDeg', cdRegister);
 S.RegisterDelphiFunction(@DateTimeNMEA, 'DateTimeNMEA', cdRegister);
 S.RegisterDelphiFunction(@SysClockSet, 'SysClockSet', cdRegister);
 S.RegisterDelphiFunction(@Ticks2Secs, 'Ticks2Secs', cdRegister);
 S.RegisterDelphiFunction(@Secs2Ticks, 'Secs2Ticks', cdRegister);
 S.RegisterDelphiFunction(@MSecs2Ticks, 'MSecs2Ticks', cdRegister);
 S.RegisterDelphiFunction(@ApWinExecAndWait32, 'ApWinExecAndWait32', cdRegister);
 S.RegisterDelphiFunction(@getStringTickCount, 'getStringTickCount', cdRegister);
 S.RegisterDelphiFunction(@DeleteLine, 'DeleteLine', cdRegister);
 S.RegisterDelphiFunction(@KillTask, 'KillTask', cdRegister);
 S.RegisterDelphiFunction(@KillProcess, 'KillProcess', cdRegister);
 S.RegisterDelphiFunction(@FindWindowByTitle, 'FindWindowByTitle', cdRegister);
 S.RegisterDelphiFunction(@IPAddrToHostName, 'IPAddrToHostName', cdRegister);
 S.RegisterDelphiFunction(@IPAddrToHostName, 'URLAddrToHostName', cdRegister);
 S.RegisterDelphiFunction(@SendMCICommand, 'SendMCICommand', cdRegister);

//SendMCICommand
 //IPAddrToHostName
 //ApWinExecAndWait32

end;

 
 
{ TPSImport_NMEA }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NMEA.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NMEA(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NMEA.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_NMEA(ri);
  RIRegister_NMEA_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
