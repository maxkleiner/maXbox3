unit uPSI_PsAPI;
{
   for process information
}
interface
 
uses
   SysUtils
  ,Classes, types, windows
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler, psAPI;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_PsAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_PsAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PsAPI_Routines(S: TPSExec);

//function getProcessAllMemory(ProcessID : longWORD): TProcessMemoryCounters;

function GetProcessMemoryInfoInt(Process: THandle; var MemoryCounters: TProcessMemoryCounters;
                                    cb: DWORD): BOOL; //stdcall;
  //   external 'psapi.dll' name 'GetProcessMemoryInfo';
// psapi.dll;

//function GetProcessMemoryInfo2(Process: THandle;var MemoryCounters:TProcessMemoryCounters;
  //                                  cb: DWORD): BOOL; //stdcall;;
    // external 'psapi.dll' name 'GetProcessMemoryInfo';

  //   External 'GetProcessMemoryInfo@psapi.dll stdcall';


procedure Register;

implementation

  uses forms, svcmgr, winsvc, servicemgr, ShlObj, ActiveX, idHTTP, ComObj, variants;
//uses
   //Windows
  //,PsAPI      Classes,
  //ComObj,
  //Variants,
  //IdHTTP,
  //;

 type
 TGeoInfo   = record
  Status        : string;
  CountryCode   : string;
  CountryName   : string;
  RegionCode    : string;
  City          : string;
  ZipPostalCode : string;
  Latitude      : string;
  Longitude     : string;
  TimezoneName  : string;
  Gmtoffset     : string;
  Isdst         : string;
 end;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PsAPI]);
end;

function GetProcessMemoryInfoInt(Process: THandle; var MemoryCounters: TProcessMemoryCounters;
                                    cb: DWORD): BOOL; //stdcall;
begin
  result:= GetProcessMemoryInfo(Process,
                            //PPROCESS_MEMORY_COUNTERS(MemCounters),
                            //TProcessMemoryCounters(PPROCESS_MEMORY_COUNTERS((@memoryCounters))),
                            PsAPI.PPROCESS_MEMORY_COUNTERS(@memoryCounters),
                            //memoryCounters,
                            sizeof(MemoryCounters));
    //result:= true;//@memoryCounters;  //t
end;



function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;
var ProcessHandle : THandle;
    MemCounters   : TProcessMemoryCounters;
    //ppsmemCounters: PPROCESS_MEMORY_COUNTERS;
    //MemCounters: PPROCESS_MEMORY_COUNTERS;
begin
  //Result:= NULL;
  ProcessHandle:= OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                               false, ProcessID);
  try
    if GetProcessMemoryInfoInt(ProcessHandle,
                            //PPROCESS_MEMORY_COUNTERS(MemCounters),
                            memCounters,
                            sizeof(MemCounters))
    //then Result:= TProcessMemoryCounters(MemCounters^);
    then Result:= MemCounters;

  finally
    CloseHandle(ProcessHandle);
  end;
end;

function ConsoleCapture(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;
var
  start: TStartupInfo;
  procInfo: TProcessInformation;
  tmpName: string;
  tmp: Windows.THandle;
  tmpSec: TSecurityAttributes;
  res: TStringList;
  return: Cardinal;
begin
  Result := False;
  try
    { Setze ein Temporäres File }
    { Set a temporary file }
    tmpName := 'Test.tmp';
    FillChar(tmpSec, SizeOf(tmpSec), #0);
    tmpSec.nLength := SizeOf(tmpSec);
    tmpSec.bInheritHandle := True;
    tmp := Windows.CreateFile(PChar(tmpName),
           Generic_Write, File_Share_Write,
           @tmpSec, Create_Always, File_Attribute_Normal, 0);
    try
      FillChar(start, SizeOf(start), #0);
      start.cb          := SizeOf(start);
      start.hStdOutput  := tmp;
      start.dwFlags     := StartF_UseStdHandles or StartF_UseShowWindow;
      start.wShowWindow := SW_Minimize;
      { Starte das Programm }
      { Start the program }
      if CreateProcess(nil, PChar(_exeName + ' ' + _cmdLine), nil, nil, True,
                       0, nil, PChar(_dirName), start, procInfo) then
      begin
        SetPriorityClass(procInfo.hProcess, Idle_Priority_Class);
        WaitForSingleObject(procInfo.hProcess, Infinite);
        GetExitCodeProcess(procInfo.hProcess, return);
        Result := (return = 0);
        CloseHandle(procInfo.hThread);
        CloseHandle(procInfo.hProcess);
        Windows.CloseHandle(tmp);
        { Die Ausgaben hinzufügen }
        { Add the output }
        //res := TStringList.Create;
        try
          //res.LoadFromFile(tmpName);
          amemo.LoadFromFile(tmpName);
                 //Memo1.Lines.AddStrings(res);
        finally
          //res.Free;
        end;
        Windows.DeleteFile(PChar(tmpName));
      end
      else
      begin
        {Application.}MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'RunDOSCaptured Error', MB_OK);
      end;
    except
      Windows.CloseHandle(tmp);
      Windows.DeleteFile(PChar(tmpName));
      raise;
    end;
  finally
  end;
end;

function ConsoleCaptureDOS(const _dirName, _exeName, _cmdLine: string; amemo: TStrings): Boolean;
var
  start: TStartupInfo;
  procInfo: TProcessInformation;
  tmpName: string;
  tmp: Windows.THandle;
  tmpSec: TSecurityAttributes;
  res: TStringList;
  return: Cardinal;
begin
  Result:= False;
  try
    tmpName:= 'Test.tmp';
    FillChar(tmpSec, SizeOf(tmpSec), #0);
    tmpSec.nLength:= SizeOf(tmpSec);
    tmpSec.bInheritHandle:= True;
    tmp:= Windows.CreateFile(PChar(tmpName),
           Generic_Write, File_Share_Write,
           @tmpSec, Create_Always, File_Attribute_Normal, 0);
    try
      FillChar(start, SizeOf(start), #0);
      start.cb          := SizeOf(start);
      start.hStdOutput  := tmp;
      start.dwFlags     := StartF_UseStdHandles or StartF_UseShowWindow;
      start.wShowWindow := SW_Minimize;
      { Starte das Programm }
      { Start the program }
      if CreateProcess(nil, PChar(_exeName + ' ' + _cmdLine), nil, nil, True,
                       0, nil, PChar(_dirName), start, procInfo) then
      begin
        SetPriorityClass(procInfo.hProcess, Idle_Priority_Class);
        WaitForSingleObject(procInfo.hProcess, Infinite);
        GetExitCodeProcess(procInfo.hProcess, return);
        Result:= (return = 0);
        CloseHandle(procInfo.hThread);
        CloseHandle(procInfo.hProcess);
        Windows.CloseHandle(tmp);
         amemo.LoadFromFile(tmpName);
        Windows.DeleteFile(PChar(tmpName));
      end
      else
      begin
        {Application.}MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'RunDOSCaptured2 Error', MB_OK);
      end;
    except
      Windows.CloseHandle(tmp);
      Windows.DeleteFile(PChar(tmpName));
      raise;
    end;
  finally
  end;
end;


procedure PerformanceDelayMS(ams: integer);
var
  hrRes, hrT1, hrT2, dif: Int64;
begin
  if QueryPerformanceFrequency(hrRes) then
  begin
    QueryPerformanceCounter(hrT1);
    repeat
      QueryPerformanceCounter(hrT2);
      dif := (hrT2 - hrT1) * 10000000 div hrRes;
    until dif > ams;
  end;
end;

function ExecuteProcess(FileName: string; Visibility: Integer; BitMask: Integer; Synch: Boolean): Longword;
//valori di Visibility:
{
Value                Meaning
SW_HIDE            :Hides the window and activates another window.
SW_MAXIMIZE        :Maximizes the specified window.
SW_MINIMIZE        :Minimizes the specified window and activates the next top-level window in the Z order.
SW_RESTORE        :Activates and displays the window. If the window is minimized or maximized,
                    Windows restores it to its original size and position. An application should
                    specify this flag when restoring a minimized window.
SW_SHOW                :Activates the window and displays it in its current size and position.
SW_SHOWDEFAULT        :Sets the show state based on the SW_ flag specified in the STARTUPINFO
                        structure passed to the CreateProcess function by the program that started the application.
SW_SHOWMAXIMIZED       :Activates the window and displays it as a maximized window.
SW_SHOWMINIMIZED       :Activates the window and displays it as a minimized window.
SW_SHOWMINNOACTIVE     :Displays the window as a minimized window. The active window remains active.
SW_SHOWNA              :Displays the window in its current state. The active window remains active.
SW_SHOWNOACTIVATE      :Displays a window in its most recent size and position. The active window remains active.
SW_SHOWNORMAL          :Activates and displays a window. If the window is minimized or maximized,
                      Windows restores it to its original size and position. An application should specify this
                      flag when displaying the window for the first time.
}
//FileName: the name of the program I want to launch
//Bitmask:   specifies the set of CPUs on wich I want to run the program
    //the BitMask is built in the following manner:
    //I have a bit sequence: every bit is associated to a CPU (from right to left)
    //I set the bit to 1 if I want to use the corrisponding CPU, 0 otherwise
    //for example: I have 4 processor and I want to run the specified process on the CPU 2 and 4:
    //the corresponding bitmask will be     1010 -->2^0 * 0 + 2^1 * 1 + 2^2 * 0 + 2^3 * 1 = 2 + 8 = 10
    //hence BitMask = 10
//Synch: Boolean --> True if I want a Synchronous Execution (I cannot close
//my application before the launched process is terminated)

var
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Closed: Boolean;
begin
  Closed := True;
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    //running the process on the set of CPUs specified by BitMask
    SetProcessAffinityMask(ProcessInfo.hProcess, BitMask);
    /////
    if (Synch = True) then //if I want a Synchronous execution (I cannot close my
    // application before this process is terminated)
      begin
        Closed:= False;
        repeat
          case WaitForSingleObject(
            ProcessInfo.hProcess, 100) of
              WAIT_OBJECT_0 : Closed:= True;
              WAIT_FAILED : RaiseLastWin32Error;
          end;
          forms.Application.ProcessMessages;
        until (Closed);
        GetExitCodeProcess(ProcessInfo.hProcess, Result);
        //exit code of the launched process (0 if the process returned no error  )
        CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.hThread);
      end
    else
      begin
        Result := 0;
      end;
  end;
end; {ExecuteProcess}

procedure StartServiceAfterInstall(aserv: TService);
var
  sm: TServiceManager;
begin
  sm:= TServiceManager.Create;
  try
    if sm.Connect then
      if sm.OpenServiceConnection(Pansichar(aserv.ServiceStartName)) then
        sm.StartService;
  finally
    sm.Free;
  end;
end;

type
  PDLLVerInfo=^TDLLVersionInfo;
  TDLLVersionInfo=Record
    cbSize,   // Size of the structure, in bytes.
    dwMajorVersion, // Major version of the DLL
    dwMinorVersion, // Minor version of the DLL
    dwBuildNumber, // Build number of the DLL
    dwPlatformID: DWord; // Identifies the platform for which the DLL was built
end;

var
  DllGetVersion: function(dvi: PDLLVerInfo): PDLLVerInfo; stdcall;

function GetDllVersion2(DllName: string; var DLLVersionInfo: TDLLVersionInfo): Boolean;
var
  hInstDll: THandle;
  p: pDLLVerInfo;
begin
  Result := False;
  // Get a handle to the DLL module.
  // das Handle zum DLL Modul ermitteln.
  hInstDll := LoadLibrary(PChar(DllName));
  if (hInstDll = 0) then Exit;
  // Return the address of the specified exported (DLL) function.
  // Adresse der Dll-Funktion ermitteln
  @DllGetVersion := GetProcAddress(hInstDll, 'DllGetVersion');
  // If the handle is not valid, clean up an exit.
  // Wenn das Handle ungültig ist, wird die Funktion verlassen
  if (@DllGetVersion) = nil then
  begin
    FreeLibrary(hInstDll);
    Exit;
  end;
   new(p);
  try
    ZeroMemory(p, SizeOf(p^));
    p^.cbSize := SizeOf(p^);
     // Call the DllGetVersion function
    // Die DllGetVersion() Funktion aufrufen
    DllGetVersion(p);
    DLLVersionInfo.dwMajorVersion := p^.dwMajorVersion;
    DLLVersionInfo.dwMinorVersion := p^.dwMinorVersion;

    @DllGetVersion := nil;
    Result := True;
  finally
    dispose(P);
  end;
 // Free the DLL module.
 // Dll wieder freigeben.
 FreeLibrary(hInstDll);
end;

procedure SendCopyMessage(amess, astation: string);
var
  aCopyData: TCopyDataStruct;
  hTargetWnd: HWND;
begin
  with aCopyData do
  begin
    dwData := 0;
    cbData := StrLen(PChar(amess)) + 1;
    lpData := PChar(amess)
  end;
  // Search window by the window title
  // Fenster anhand des Titelzeilentext suchen
  if astation = '' then
    hTargetWnd := FindWindowEx(0, 0, nil, PChar('TMaxForm1'))
    else
     hTargetWnd := FindWindowEx(0, 0, nil, PChar(astation));
  if hTargetWnd <> 0 then
    SendMessage(hTargetWnd, $004A, Longint(hinstance), Longint(@aCopyData))
  else
    MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'No WMCopyData Recipient found! Error', MB_OK); //ShowMessage('No Recipient found!');
end;

function BrowseComputer2(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean;
  // bNewStyle: If True, this code will try to use the "new"
  // BrowseForFolders UI on Windows 2000/XP
const
  BIF_USENEWUI = 28;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ComputerName: array[0..MAX_PATH] of Char;
  Title: string;
  WindowList: Pointer;
  ShellMalloc: IMalloc;
begin
  if Failed(SHGetSpecialFolderLocation(forms.Application.Handle, CSIDL_NETWORK, ItemIDList)) then
    raise Exception.Create('Unable open browse computer dialog');
  try
    FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
    BrowseInfo.hwndOwner := Forms.Application.Handle;
    BrowseInfo.pidlRoot := ItemIDList;
    BrowseInfo.pszDisplayName := ComputerName;
    Title := DialogTitle;
    BrowseInfo.lpszTitle := PChar(Pointer(Title));
    if bNewStyle then
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER or BIF_USENEWUI
    else
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
    WindowList := DisableTaskWindows(0);
    try
      Result := SHBrowseForFolder(BrowseInfo) <> nil;
    finally
      EnableTaskWindows(WindowList);
    end;
    if Result then CompName := ComputerName;
  finally
    if Succeeded(SHGetMalloc(ShellMalloc)) then
      ShellMalloc.Free(ItemIDList);
  end;
end;


// Beispiel:
// Example:

(*procedure TForm1.Button1Click(Sender: TObject);
begin
  RunCaptured('C:\', 'cmd.exe', '/c dir');
end;*)

const
 UrlGeoLookupInfo  ='http://ipinfodb.com/ip_query.php?timezone=true&ip=%s';
 UrlGeoLookupInfo2 ='http://backup.ipinfodb.com/ip_query.php?timezone=true&ip=%s'; //backup

procedure GetGeoInfo(const IpAddress : string;var GeoInfo :TGeoInfo; const UrlGeoLookupInfo: string);
var
  lHTTP  : TIdHTTP;
  lStream: TStringStream;
  XMLDoc : OleVariant;
  ANode  : OleVariant;
begin
  lHTTP   := TIdHTTP.Create(nil);
  lStream := TStringStream.Create('');
  try
      try
        lHTTP.Get(Format(UrlGeoLookupInfo,[IpAddress]), lStream); //get the request
      except
        lHTTP.Get(Format(UrlGeoLookupInfo2,[IpAddress]), lStream); //if something is wrong try using the backup server.
      end;
      lStream.Seek(0,0);
      XMLDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
      XMLDoc.async := false;
      XMLDoc.LoadXML(lStream.ReadString(lStream.Size));
      XMLDoc.setProperty('SelectionLanguage','XPath');//use XPath to parse the xml result
      ANode:=XMLDoc.selectSingleNode('/Response/Status');
      if not VarIsNull(ANode) then GeoInfo.Status:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/CountryCode');
      if not VarIsNull(ANode) then GeoInfo.CountryCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/CountryName');
      if not VarIsNull(ANode) then GeoInfo.CountryName:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/RegionCode');
      if not VarIsNull(ANode) then GeoInfo.RegionCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/City');
      if not VarIsNull(ANode) then GeoInfo.City:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/ZipPostalCode');
      if not VarIsNull(ANode) then GeoInfo.ZipPostalCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Latitude');
      if not VarIsNull(ANode) then GeoInfo.Latitude:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Longitude');
      if not VarIsNull(ANode) then GeoInfo.Longitude:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/TimezoneName');
      if not VarIsNull(ANode) then GeoInfo.TimezoneName:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Gmtoffset');
      if not VarIsNull(ANode) then GeoInfo.Gmtoffset:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Isdst');
      if not VarIsNull(ANode) then GeoInfo.Isdst:=ANode.Text;
  finally
    lHTTP.Free;
    lStream.Free;
  end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_PsAPI(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PPointer', '^Pointer // will not work');
  CL.AddTypeS('_MODULEINFO', 'record lpBaseOfDll : ___Pointer; SizeOfImage : DWORD'
   +'; EntryPoint : ___Pointer; end');
  CL.AddTypeS('MODULEINFO', '_MODULEINFO');
  //CL.AddTypeS('LPMODULEINFO', '^_MODULEINFO // will not work');
  CL.AddTypeS('TModuleInfo', '_MODULEINFO');
 // CL.AddTypeS('PModuleInfo', 'LPMODULEINFO');
  //CL.AddTypeS('_PSAPI_WS_WATCH_INFORMATION', 'record FaultingPc : Pointer; Faul'
   //+'tingVa : Pointer; end');
  {CL.AddTypeS('PSAPI_WS_WATCH_INFORMATION', '_PSAPI_WS_WATCH_INFORMATION');
  CL.AddTypeS('TPSAPIWsWatchInformation', '_PSAPI_WS_WATCH_INFORMATION');
  CL.AddTypeS('PPSAPIWsWatchInformation', 'PPSAPI_WS_WATCH_INFORMATION');}
  CL.AddTypeS('_PROCESS_MEMORY_COUNTERS', 'record cb : DWORD; PageFaultCount : '
   +'DWORD; PeakWorkingSetSize : DWORD; WorkingSetSize : DWORD; QuotaPeakPagedP'
   +'oolUsage : DWORD; QuotaPagedPoolUsage : DWORD; QuotaPeakNonPagedPoolUsage '
   +': DWORD; QuotaNonPagedPoolUsage : DWORD; PagefileUsage : DWORD; PeakPagefileUsage : DWORD; end');
  CL.AddTypeS('PROCESS_MEMORY_COUNTERS', '_PROCESS_MEMORY_COUNTERS');
  CL.AddTypeS('TProcessMemoryCounters', '_PROCESS_MEMORY_COUNTERS');
  CL.AddTypeS('HCOLORSPACE', 'LongWord');
  CL.AddTypeS('TGeoInfo', 'record status: string; countrycode : '
   +'string; countryname : string; regioncode : string; city : string; zippostalcode : string; latitude '
   +': string; longitude : string; timezonename : string; gmtoffset: string; isdst: string; end');

 { TGeoInfo   = record
  Status        : string;
  CountryCode   : string;
  CountryName   : string;
  RegionCode    : string;
  City          : string;
  ZipPostalCode : string;
  Latitude      : string;
  Longitude     : string;
  TimezoneName  : string;
  Gmtoffset     : string;
  Isdst         : string;
 end; }


  CL.AddTypeS('TDLLVersionInfo', 'record cbsize, dwMajorVersion, dwMinorVersion, dwBuildNumber, dwPlatformID: DWord; end');

  //CL.AddTypeS('PProcessMemoryCounters', '^_PROCESS_MEMORY_COUNTERS // will not work');
 //CL.AddDelphiFunction('Function EnumProcesses( lpidProcess : LPDWORD; cb : DWORD; var cbNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumProcessModules( hProcess : THandle; lphModule : LPDWORD; cb : DWORD; var lpcbNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetModuleBaseName( hProcess : THandle; hModule : HMODULE; lpBaseName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleBaseNameA( hProcess : THandle; hModule : HMODULE; lpBaseName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleBaseNameW( hProcess : THandle; hModule : HMODULE; lpBaseName : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameEx( hProcess : THandle; hModule : HMODULE; lpFilename : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameExA( hProcess : THandle; hModule : HMODULE; lpFilename : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameExW( hProcess : THandle; hModule : HMODULE; lpFilename : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleInformation( hProcess : THandle; hModule : HMODULE; lpmodinfo : LPMODULEINFO; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EmptyWorkingSet( hProcess : THandle) : BOOL');
 CL.AddDelphiFunction('Function QueryWorkingSet( hProcess : THandle; pv : ___Pointer; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function InitializeProcessForWsWatch( hProcess : THandle) : BOOL');
 CL.AddDelphiFunction('Function GetMappedFileName( hProcess : THandle; lpv : ___Pointer; lpFilename : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetMappedFileNameA( hProcess : THandle; lpv : Pointer; lpFilename : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetMappedFileNameW( hProcess : THandle; lpv : Pointer; lpFilename : PWideChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetDeviceDriverBaseName( ImageBase : ___Pointer; lpBaseName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverBaseNameA( ImageBase : Pointer; lpBaseName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverBaseNameW( ImageBase : Pointer; lpBaseName : PWideChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetDeviceDriverFileName( ImageBase : ___Pointer; lpFileName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverFileNameA( ImageBase : Pointer; lpFileName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverFileNameW( ImageBase : Pointer; lpFileName : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function EnumDeviceDrivers( lpImageBase : PPointer; cb : DWORD; var lpcbNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetProcessMemoryInfo( Process : THandle; ppsmemCounters : PPROCESS_MEMORY_COUNTERS; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetProcessMemoryInfo(Process : THandle; ppsmemCounters: TProcessMemoryCounters; cb: DWORD): BOOL');

 CL.AddDelphiFunction('function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;');
 CL.AddDelphiFunction('function getProcessMemoryInfo2(ProcessID : DWORD): TProcessMemoryCounters;');
 CL.AddDelphiFunction('function getProcMemInfo(ProcessID : DWORD): TProcessMemoryCounters;');

 //CL.AddDelphiFunction('Function GetCurrentThread : THandle');
 //CL.AddDelphiFunction('Function GetCurrentThreadId : DWORD');
 CL.AddDelphiFunction('Function SetThreadAffinityMask( hThread : THandle; dwThreadAffinityMask : DWORD) : DWORD');
 CL.AddDelphiFunction('Function SetThreadIdealProcessor( hThread : THandle; dwIdealProcessor : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetProcessPriorityBoost( hThread : THandle; DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetProcessPriorityBoost( hThread : THandle; var DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function SetThreadPriority( hThread : THandle; nPriority : Integer) : BOOL');
 CL.AddDelphiFunction('Function GetThreadPriority( hThread : THandle) : Integer');
 CL.AddDelphiFunction('Function SetThreadPriorityBoost( hThread : THandle; DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetThreadPriorityBoost( hThread : THandle; var DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetThreadTimes( hThread : THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime : TFileTime) : BOOL');
 CL.AddDelphiFunction('Procedure ExitThread( dwExitCode : DWORD)');
 CL.AddDelphiFunction('Function TerminateThread( hThread : THandle; dwExitCode : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetExitCodeThread( hThread : THandle; var lpExitCode : DWORD) : BOOL');

 CL.AddDelphiFunction('Function GetTimeZoneInformation( var lpTimeZoneInformation : TTimeZoneInformation) : DWORD');
 CL.AddDelphiFunction('Function SetTimeZoneInformation( const lpTimeZoneInformation : TTimeZoneInformation) : BOOL');
 CL.AddDelphiFunction('Function IsProcessorFeaturePresent( ProcessorFeature : DWORD) : BOOL');
 CL.AddDelphiFunction('function RunCaptured(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;');
 CL.AddDelphiFunction('function ConsoleCapture(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;');
 CL.AddDelphiFunction('function ConsoleCaptureDOS(const _dirName, _exeName, _cmdLine: string; amemo: TStrings): Boolean;');
 CL.AddDelphiFunction('procedure PerformanceDelayMS(ams: integer);');
 CL.AddDelphiFunction('function ExecuteProcess(FileName:string;Visibility:Integer;BitMask:Integer;Synch:Boolean):Longword;');
 CL.AddDelphiFunction('function ExecuteMultiProcessor(FileName:string;Visibility:Integer;BitMask:Integer;Synch:Boolean):Longword;');

  //http://www.swissdelphicenter.ch/en/showcode.php?id=2179
   CL.AddClassN(CL.FindClass('TOBJECT'),'TService');
  CL.AddDelphiFunction('procedure StartServiceAfterInstall(aserv: TService);');
  CL.AddDelphiFunction('function GetDllVersion2(DllName: string; var DLLVersionInfo: TDLLVersionInfo): Boolean;');
  CL.AddDelphiFunction('procedure SendCopyMessage(amess, astation: string);');
  CL.AddDelphiFunction('function BrowseComputer2(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean;');
  CL.AddDelphiFunction('Function FindWindowEx( Parent, Child : HWND; ClassName, WindowName : PChar) : HWND');
  CL.AddDelphiFunction('Function SetWindowExtEx( DC : HDC; XExt, YExt : Integer; Size : integer) : BOOL');
  CL.AddDelphiFunction('Function SetWindowOrgEx( DC : HDC; X, Y : Integer; Point : TPoint) : BOOL');
  CL.AddDelphiFunction('Function GetTextFace( DC : HDC; Count : Integer; Buffer : PChar) : Integer');
 {CL.AddDelphiFunction('Function GetDCOrgEx( DC : HDC; var Origin : TPoint) : BOOL');
 CL.AddDelphiFunction('Function UnrealizeObject( hGDIObj : HGDIOBJ) : BOOL');
 CL.AddDelphiFunction('Function GdiFlush : BOOL');
 CL.AddDelphiFunction('Function GdiSetBatchLimit( Limit : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GdiGetBatchLimit : DWORD');}
  CL.AddDelphiFunction('Function SetICMMode( DC : HDC; Mode : Integer) : Integer');
 CL.AddDelphiFunction('Function CheckColorsInGamut( DC : HDC; var RGBQuads, Results, Count : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetColorSpace( DC : HDC) : THandle');
CL.AddDelphiFunction('Function SetColorSpace( DC : HDC; ColorSpace : HCOLORSPACE) : BOOL');
 CL.AddDelphiFunction('Function DeleteColorSpace( ColorSpace : HCOLORSPACE) : BOOL');
 CL.AddDelphiFunction('Function GetICMProfile( DC : HDC; var Size : DWORD; Name : PChar) : BOOL');
 CL.AddDelphiFunction('Function SetICMProfile( DC : HDC; Name : PChar) : BOOL');
 //CL.AddDelphiFunction('Function ColorMatchToTarget( DC : HDC; Target : HDC; Action : DWORD) : BOOL');
 CL.AddDelphiFunction('procedure GetGeoInfo(const IpAddress : string;var GeoInfo :TGeoInfo; const UrlGeoLookupInfo: string)');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_PsAPI_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@EnumProcesses, 'EnumProcesses', cdRegister);
 //S.RegisterDelphiFunction(@EnumProcessModules, 'EnumProcessModules', cdRegister);
 S.RegisterDelphiFunction(@GetModuleBaseName, 'GetModuleBaseName', cdRegister);
 S.RegisterDelphiFunction(@GetModuleInformation, 'GetModuleInformation', cdRegister);
 S.RegisterDelphiFunction(@EmptyWorkingSet, 'EmptyWorkingSet', cdRegister);
 S.RegisterDelphiFunction(@QueryWorkingSet, 'QueryWorkingSet', cdRegister);
 S.RegisterDelphiFunction(@InitializeProcessForWsWatch, 'InitializeProcessForWsWatch', cdRegister);
 S.RegisterDelphiFunction(@GetMappedFileName, 'GetMappedFileName', cdRegister);
 //S.RegisterDelphiFunction(@GetMappedFileNameA, 'GetMappedFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetMappedFileNameW, 'GetMappedFileNameW', cdRegister);
 S.RegisterDelphiFunction(@GetDeviceDriverBaseName, 'GetDeviceDriverBaseName', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverBaseNameA, 'GetDeviceDriverBaseNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverBaseNameW, 'GetDeviceDriverBaseNameW', cdRegister);
 S.RegisterDelphiFunction(@GetDeviceDriverFileName, 'GetDeviceDriverFileName', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverFileNameA, 'GetDeviceDriverFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverFileNameW, 'GetDeviceDriverFileNameW', cdRegister);
 S.RegisterDelphiFunction(@EnumDeviceDrivers, 'EnumDeviceDrivers', cdRegister);
 S.RegisterDelphiFunction(@GetProcessMemoryInfoInt, 'GetProcessMemoryInfo', cdRegister);
 S.RegisterDelphiFunction(@GetProcessAllMemory, 'GetProcessMemoryInfo2', cdRegister);
 S.RegisterDelphiFunction(@getProcessAllMemory, 'getProcessAllMemory', cdRegister);
 S.RegisterDelphiFunction(@getProcessAllMemory, 'getProcMemInfo', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCapture, 'ConsoleCapture', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCaptureDOS, 'ConsoleCaptureDOS', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCapture, 'RunCaptured', cdRegister);

//  S.RegisterDelphiFunction(@GetCurrentThread, 'GetCurrentThread', CdStdCall);
 //S.RegisterDelphiFunction(@GetCurrentThreadId, 'GetCurrentThreadId', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadAffinityMask, 'SetThreadAffinityMask', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadIdealProcessor, 'SetThreadIdealProcessor', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessPriorityBoost, 'SetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessPriorityBoost, 'GetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriority, 'SetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriority, 'GetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriorityBoost, 'SetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriorityBoost, 'GetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadTimes, 'GetThreadTimes', CdStdCall);
 S.RegisterDelphiFunction(@ExitThread, 'ExitThread', CdStdCall);
 S.RegisterDelphiFunction(@TerminateThread, 'TerminateThread', CdStdCall);
 S.RegisterDelphiFunction(@GetExitCodeThread, 'GetExitCodeThread', CdStdCall);
  S.RegisterDelphiFunction(@FindWindowEx, 'FindWindowEx', CdStdCall);

 S.RegisterDelphiFunction(@IsProcessorFeaturePresent, 'IsProcessorFeaturePresent', CdStdCall);
 S.RegisterDelphiFunction(@GetTimeZoneInformation, 'GetTimeZoneInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetTimeZoneInformation, 'SetTimeZoneInformation', CdStdCall);
 S.RegisterDelphiFunction(@CreateProcess, 'CreateProcess', CdStdCall);
 S.RegisterDelphiFunction(@PerformanceDelayMS, 'PerformanceDelayMS', CdRegister);
 S.RegisterDelphiFunction(@ExecuteProcess, 'ExecuteProcess', CdRegister);
 S.RegisterDelphiFunction(@ExecuteProcess, 'ExecuteMultiProcessor', CdRegister);  //Alias

 S.RegisterDelphiFunction(@StartServiceAfterInstall, 'StartServiceAfterInstall', CdRegister);
 S.RegisterDelphiFunction(@GetDllVersion2, 'GetDllVersion2', CdRegister);
 S.RegisterDelphiFunction(@SendCopyMessage, 'SendCopyMessage', CdRegister);
 S.RegisterDelphiFunction(@BrowseComputer2, 'BrowseComputer2', CdRegister);
 S.RegisterDelphiFunction(@SetWindowExtEx, 'SetWindowExtEx', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowOrgEx, 'SetWindowOrgEx', CdStdCall);
 S.RegisterDelphiFunction(@GetTextFace, 'GetTextFace', CdStdCall);

 S.RegisterDelphiFunction(@SetICMMode, 'SetICMMode', CdStdCall);
 S.RegisterDelphiFunction(@GetColorSpace, 'GetColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetLogColorSpace, 'GetLogColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@SetColorSpace, 'SetColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@DeleteColorSpace, 'DeleteColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetICMProfile, 'GetICMProfile', CdStdCall);
 S.RegisterDelphiFunction(@SetICMProfile, 'SetICMProfile', CdStdCall);
 //S.RegisterDelphiFunction(@ColorMatchToTarget, 'ColorMatchToTarget', CdStdCall);
 S.RegisterDelphiFunction(@GetGeoInfo, 'GetGeoInfo', CdRegister);


end;



{ TPSImport_PsAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PsAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PsAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PsAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PsAPI(ri);
  RIRegister_PsAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
