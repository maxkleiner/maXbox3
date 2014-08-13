   
///////////////////////////////////////////////////////////////////////////
//  #sign:0 PM max: MAXBOX8: 7/19/2014 11:53:18 PM PM 
//  Purpose: Redirect a shell to outputmemo as memo2
//  #path>C:\maXbook\maxbox3\mX3999\maxbox3\examples\
//  Lines of Code #locs:124
///////////////////////////////////////////////////////////////////////////

//TODO: Save the PipeCode to SyntaxChecker_file, #locs:124
   
program ShellHell;

//INTERFACE
//USES
  //Windows, Messages, Classes, SysUtils, ExtCtrls, Serial;

TYPE
  (* State of DCF-Compoent *)
  TDCFStatus = (NotOpened,        (* serielle Intf not opened *)
                NoSignal,         (* no DCF-Signal            *)
                Synchronizing,    (* wait on Minutebeginnng   *)
                ReceiveData,      (* Datanbits are on         *)
                TimeAvailable);   (* DCF-Time available       *)
  (* DCF-COM *)

procedure TFormMain_btCompileClick(Sender: TObject);
var aprocess: TProcess;
    AStringList: TStringList;
begin
  AProcess:= TProcess.Create(Nil);
  try
    //AProcess.CommandLine := 'gcc.exe "' + OpenDialog1.FileName + '"'
      //+ ' -o "' + OpenDialog2.FileName + '"';
    //AProcess.CommandLine:= 'cmd.exe /c "dir *.*"';
    AProcess.CommandLine:= 'cmd.exe /c "dir /s c:\windows\"';
   
    //AProcess.CommandLine := 'calc.exe';
    // AProcess.Executable:= 'ppc386';
    // Pass -h together with ppc386 (so we're executing ppc386 -h):
     //+ OpenDialog1.FileName + '"' + ' -o "' + OpenDialog2.FileName + '"';
    AStringList:= TStringList.Create;
    AProcess.Options:= AProcess.Options +[poWaitOnExit, poUsePipes];
    //AProcess.Options:= AProcess.Options +[poNoConsole, poUsePipes];
 
    AProcess.Execute;
    Memo2.Lines.BeginUpdate;
    //Memo2.Lines.Clear;
    Memo2.Lines.LoadFromStream(AProcess.Output);
    Memo2.Lines.EndUpdate;
    {AStringList.LoadFromStream(AProcess.Output);
    // Save the output to a file.
    AStringList.SaveToFile(ExePath+'pipeoutput.txt');
    openDoc(ExePath+'pipeoutput.txt');
    writeln('Test Pipe Size '+inttostr(filesize(ExePath+'pipeoutput.txt')));}
  finally
    AProcess.Free;
    AStringList.Free;
  end;
end;

function Split(Input: string; Deliminator: string; Index: integer): string;
var
  StringLoop, StringCount: integer;
  Buffer: string;
begin
  StringCount := 0;
  for StringLoop := 1 to Length(Input) do begin
    if (Copy(Input, StringLoop, 1) = Deliminator) then
    begin
      Inc(StringCount);
      if StringCount = Index then begin
        Result := Buffer;
        Exit;
      end
      else begin
        Buffer := '';
      end;
    end
    else begin
      Buffer := Buffer + Copy(Input, StringLoop, 1);
    end;
  end;
  Result := Buffer;
end;

 
procedure FlushMessages;
var lpMsg : TMsg;
begin
// Flush the message queue for the calling thread
 while PeekMessage(lpMsg, 0, 0, 0, PM_REMOVE) do begin
   // Translate the message
   TranslateMessage(lpMsg);
   // Dispatch the message
   DispatchMessage(lpMsg);
   // Allow other threads to run
   Sleep(0);
 end;
end;
 
function IsHandle(Handle: THandle): Boolean;
begin
// Determine if a valid handle (only by value)
 result:= Not ((Handle = 0) Or (Handle = INVALID_HANDLE_VALUE));
end;
 
{I assume you're referring to the TProcess component that comes with Lazarus. To make a console program start without a console, include the poNoConsole flag in the Options property. AProcess.Options := AProcess.Options + [poNoConsole];
The options available in that property map very closely to the process creation flags for the CreateProcess API function, where flag to use is CREATE_NO_WINDOW.}

 var CommandLine: string;
  //MAIN
  begin
    GetEnvironmentVar('COMSPEC', CommandLine,true);
    writeln(CommandLine +' is found�!');
    if not {JclSysInfo.}GetEnvironmentVar('COMSPEC', CommandLine,true) or
        (Length(CommandLine) = 0) then  begin
      { Paranoid }
      CommandLine := 'COMMAND.EXE';
      writeln('CommandLine on EnvVar found�!');
    end;
    
    TFormMain_btCompileClick(self);

 End.
    
    
 http://wiki.freepascal.org/Executing_External_Programs#A_Simple_Example   
 http://www.freepascal.org/docs-html/fcl/process/tprocess.commandline.html   
 http://www.schoolfreeware.com/Free_Pascal_Lazarus_Program_Tutorial_28.html
   
  #include <stdio.h>
  #include <stdlib.h>

int main(int argc, char *argv[])
{
  int i=0;
  printf("testausgabe\n");
  scanf("%d", i);
  print("Zeichen eingelesen");
  return 0;
} 


procedure TForm1.StartCommandProcessor;
begin
  { Retrieve the command processor name }
  if not JclSysInfo.GetEnvironmentVar('COMSPEC', CommandLine) or (Length(CommandLine) = 0) then
    { Paranoid }
    CommandLine := 'COMMAND.EXE';
  JvCreateProcess1.CommandLine := CommandLine;
  { Redirect console output, we'll receive the output via the OnRead event }
  JvCreateProcess1.ConsoleOptions := JvCreateProcess1.ConsoleOptions + [coRedirect];
  { Hide the console window }
  JvCreateProcess1.StartupInfo.ShowWindow := swHide;
  JvCreateProcess1.StartupInfo.DefaultWindowState := False;
  { And start the console }
  JvCreateProcess1.Run;

end;

procedure TForm1.JvCreateProcess1Read(Sender: TObject; const S: String;
  const StartsOnNewLine: Boolean);
begin
  memo1.Lines.Add(s);
end;


procedure TFormMain.btCompileClick(Sender: TObject);
begin
  AProcess := TProcess.Create(nil);
  try
    AProcess.CommandLine := 'gcc.exe "' + OpenDialog1.FileName + '"'
      + ' -o "' + OpenDialog2.FileName + '"';
    AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
    AProcess.Execute;
    OutputMemo.Lines.BeginUpdate;
    OutputMemo.Lines.Clear;
    OutputMemo.Lines.LoadFromStream(AProcess.Output);
    OutputMemo.Lines.EndUpdate;
  finally
    AProcess.Free;
  end;
end;
Sta

procedure SIRegister_TProcess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TProcess') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TProcess') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Function Resume : Integer');
    RegisterMethod('Function Suspend : Integer');
    RegisterMethod('Function Terminate( AExitCode : Integer) : Boolean');
    RegisterMethod('Function WaitOnExit : DWord');
    RegisterProperty('WindowRect', 'Trect', iptrw);
    RegisterProperty('StartupInfo', 'TStartupInfo', iptr);
    RegisterProperty('ProcessAttributes', 'TSecurityAttributes', iptrw);
    RegisterProperty('ProcessInformation', 'TProcessInformation', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('ThreadHandle', 'THandle', iptr);
    RegisterProperty('Input', 'TOutPutPipeStream', iptr);
    RegisterProperty('OutPut', 'TInputPipeStream', iptr);
    RegisterProperty('StdErr', 'TinputPipeStream', iptr);
    RegisterProperty('ExitStatus', 'Integer', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ApplicationName', 'String', iptrw);
    RegisterProperty('CommandLine', 'String', iptrw);
    RegisterProperty('ConsoleTitle', 'String', iptrw);
    RegisterProperty('CurrentDirectory', 'String', iptrw);
    RegisterProperty('DeskTop', 'String', iptrw);
    RegisterProperty('Environment', 'TStrings', iptrw);
    RegisterProperty('FillAttribute', 'Cardinal', iptrw);
    RegisterProperty('InheritHandles', 'LongBool', iptrw);
    RegisterProperty('Options', 'TProcessOptions', iptrw);
    RegisterProperty('Priority', 'TProcessPriority', iptrw);
    RegisterProperty('StartUpOptions', 'TStartUpOptions', iptrw);
    RegisterProperty('Running', 'Boolean', iptr);
    RegisterProperty('ShowWindow', 'TShowWindowOptions', iptrw);
    RegisterProperty('ThreadAttributes', 'TSecurityAttributes', iptrw);
    RegisterProperty('WindowColumns', 'Cardinal', iptrw);
    RegisterProperty('WindowHeight', 'Cardinal', iptrw);
    RegisterProperty('WindowLeft', 'Cardinal', iptrw);
    RegisterProperty('WindowRows', 'Cardinal', iptrw);
    RegisterProperty('WindowTop', 'Cardinal', iptrw);
    RegisterProperty('WindowWidth', 'Cardinal', iptrw);
  end;
end;

ShellExecute is a standard MS Windows function (ShellApi.h) with good documentation on MSDN (note their remarks about initialising COM if you find the function unreliable).

uses ..., ShellApi;
 
// Simple one-liner (ignoring error returns) :
if ShellExecute(0,nil, PChar('"C:\my dir\prog.exe"'),PChar('"C:\somepath\some_doc.ext"'),nil,1) =0 then;
 
// Execute a Batch File :
if ShellExecute(0,nil, PChar('cmd'),PChar('/c mybatch.bat'),nil,1) =0 then;
 
// Open a command window in a given folder :
if ShellExecute(0,nil, PChar('cmd'),PChar('/k cd \path'),nil,1) =0 then;
 
// Open a webpage URL in the default browser using 'start' command (via a brief hidden cmd window) :
if ShellExecute(0,nil, PChar('cmd'),PChar('/c start www.lazarus.freepascal.org/'),nil,0) =0 then;
 
// or a useful procedure:
procedure RunShellExecute(const prog,params:string);
begin
  //  ( Handle, nil/'open'/'edit'/'find'/'explore'/'print',   // 'open' isn't always needed 
  //      path+prog, params, working folder,
  // 0=hide / 1=SW_SHOWNORMAL / 3=max / 7=min)   // for SW_ constants : uses ... Windows ...
  if ShellExecute(0,'open',PChar(prog),PChar(params),PChar(extractfilepath(prog)),1) >32 then; //success
  // return values 0..32 are errors
end;

There is also ShellExecuteExW as a WideChar version, and ShellExecuteExA is AnsiChar.



    
    
    