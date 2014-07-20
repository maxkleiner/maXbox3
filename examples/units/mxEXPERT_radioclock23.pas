(******************************************************************************)
(*                                                                            *)
(*   Komponente zur Auswertung eines DCF77-Signals                            *)
(*   empfangen mit einer "Expert Mouse Clock" an der seriellen Schnittstelle  *)
(*                                                                            *)
(*   (c) 1999 Rainer Reusch & Toolbox                                         *)
(*   (c) 1999 Rainer Reusch & Computer- und Literaturverlag                   *)
(*                                                                            *)
(*   Borland Delphi 2, 3, 4                                                   *)
(*   for maXbox 2014                                                          *)
(****V1.0**********************************************************************)

{
Diese Komponente ist für das Funkuhrenmodul "Expert Mouse Clock" von GUDE
Analog- und Digitalsysteme GmbH, Köln ausgelegt. Der Anschluß an die serielle
Schnittstelle erfolgt wie vorgesehen. Anschlußbelegung:
DTR: positive Versorgungsspannung
RTS: negative Versorgungsspannung
RxD: Signaleingang (50 Baud, 8n1 muß eingestellt sein)
Die serielle Schnittstelle muß einen Interrupt auslösen können.
Hinweis: Diese Komponente erfordert die Komponenten-Unit "Serial" V3.2 (!)
oder höher.

RECHTLICHES:
DIESE KOMPONENTE IST URHEBERRECHTLICH GESCHÜTZT! DIE WEITERGABE UND DER VERKAUF
DES QUELLTEXTES IST UNTERSAGT. DIESER QUELLTEXT WIRD LEDIGLICH LESERN DER
ZEITSCHRIFT TOOLBOX UND LESERN DES COMPUTER- UND LITERATURVERLAGES ZUM EIGENEN
GEBRAUCH ZUR VERFÜGUNG GESTELLT. EINE LIZENZGEBÜHR IST VON DIESEN ANWENDERN
NICHT ZU ENTRICHTEN.
DER GEBRAUCH DER KOMPONENTE UND DER DAZUGEHÖRIGEN BEISPIELPROGRAMME ERFOLGT AUF
EIGENE GEFAHR. FÜR BESCHÄDIGUNGEN AN GERÄTEN ODER DATENVERLUSTE ÜBERNEHMEN
WEDER DER AUTOR NOCH DER VERLAG JEGLICHE HAFTUNG.

Für Hinweise auf Probleme und Fehler, sowie Kommentare sind wir dankbar.
Richten Sie Ihre Anfrage bitte an folgende Adresse:
  Redaktion Toolbox
  10, Rue des Hauts Champs
  F-88110 Luvigny
  FAX: 0033-329-4240-03
  E-Mail: jb@toolbox-mag.de
}

program Expert;

//INTERFACE

//USES
  //Windows, Messages, Classes, SysUtils, ExtCtrls, Serial;

TYPE
  (* Status der DCF-Komponente *)
  TDCFStatus = (NotOpened,        (* serielle Schnittstelle ist nicht geöffnet *)
                NoSignal,         (* kein DCF-Signal            *)
                Synchronizing,    (* warten auf Minutenanfang   *)
                ReceiveData,      (* Datenbits werden aufgenommen *)
                TimeAvailable);   (* DCF-Zeit steht zur Verfügung *)
  (* DCF-Komponente *)
  //TExpertClock = CLASS (TComponent)
  //PRIVATE
    var 
    FStatus : TDCFStatus;              (* Empfangsstatus           *)
    FReserveTransmitter,               (* Reservesender in Betrieb *)
    FSummerTime : BOOLEAN;             (* Sommerzeit               *)
    FSwitchSecond : BOOLEAN;           (* Schaltsekunde;           *) 
    FHour, FMinute, FSecond : WORD;    (* Funkuhrzeit              *)
    FDay, FMonth : WORD;               (* Funk-Datum               *)
    FYear : WORD;
    FDayOfWeek : BYTE;                 (* Funk-Wochentag                *)
    FQuality,                          (* aktuelle Empfangsqualität     *)
    FQualityLimit : INTEGER;           (* Qualitätsvorgabe für Ereignis OnQualityAttained *)
    FOnDCFClock : TNotifyEvent;        (* DCF-Datenbit trifft ein       *)
    FOnStatusChanged : TNotifyEvent;   (* der Status hat sich geändert  *)
    FOnTimeChanged : TNotifyEvent;     (* Die Uhrzeit hat sich geändert *)
    FOnQualityAttained : TNotifyEvent; (* vorgegebene Qualität wurde erreicht *)
    LSummerTime : BOOLEAN;             (* letzte Zeitdaten für Qualitätsermittlung *)
    LHour, LMinute : WORD;
    LDay, LMonth : WORD;
    LYear : WORD;
    LDayOfWeek : BYTE;
    BitCount : INTEGER;                (* Bitzähler für Daten in einer Minute *)
    QualityEvent : BOOLEAN;
  //PROTECTED
    SerPort : TSerial;   (* Zugang zu serieller Schnittstelle   *)
    Timer59,             (* Timer generiert 59. Sekunde         *)
    TimerOut : TTimer;   (* TimeOut-Timer (Erkennung eines fehlenden Signals) *)
    LastHi : DWord;      (* Zeitpunkt der letzten High-Flanke DCF-Signal *)
    Data : ARRAY[0..59] OF BOOLEAN;  (* empfangene Datenbits    *)
    PROCEDURE TExpertClock_SerPort1Cts(Sender: TObject);  forward;
    PROCEDURE TExpertClock_Timer59Timer(Sender: TObject);  forward;
    PROCEDURE TExpertClock_TimerOutTimer(Sender: TObject); forward;
  //PUBLIC
    //CONSTRUCTOR Create(AOwner: TComponent); Override;                (* Konstruktor   *)
    //DESTRUCTOR  Destroy; Override;                              (* Destruktor     *)
  
  { PROPERTY Status : TDCFStatus Read FStatus;                       (* Empfangsstatus *)
    PROPERTY ReserveTransmitter : BOOLEAN Read FReserveTransmitter;  (* Reservesender  *)
    PROPERTY SummerTime : BOOLEAN Read FSummerTime;                  (* Sommerzeit     *)
    PROPERTY SwitchSecond : BOOLEAN Read FSwitchSecond;              (* Schaltsekunde  *)
    PROPERTY Hour : WORD Read FHour;                                 (* DCF-Stunde     *)
    PROPERTY Minute : WORD Read FMinute;                             (* DCF-Minute     *)
    PROPERTY Second : WORD Read FSecond;                             (* DCF-Sekunde    *)
    PROPERTY Day : WORD Read FDay;                                   (* DCF-Tag        *)
    PROPERTY Month : WORD Read FMonth;                               (* DCF-Monat      *)
    PROPERTY Year : WORD Read FYear;                                 (* DCF-Jahr (19xx, 20xx)   *)
    PROPERTY Now : TDateTime Read GetNow;                            (* aktuelle Zeit           *)
    PROPERTY DayOfWeek : INTEGER Read GetDayOfWeek;                  (* Wochentag (1=Sonntag, Delphi-konform) *)
    PROPERTY Quality : INTEGER Read FQuality;                        (* Empfangsqualität (-1..) *)
  PUBLISHED
    PROPERTY COMPort : INTEGER Read GetCOMPort Write SetCOMPort;     (* serielle Schnittstelle  *)     }

    procedure TExpertClock_Create(AOwner: TComponent);
(* Initialisierungen *)
BEGIN
  //Inherited Create(AOwner);
  FStatus          := NoSignal;
  //ErrorTime;  (* versch. Eigenschaften initialisieren *)
  FOnDCFClock      := NIL;
  FOnStatusChanged := NIL;
  FQuality         := -1;
  FQualityLimit    := 1;
  QualityEvent     := FALSE;
  (* serielle Schnittstelle *)
  SerPort          := TSerial.Create(Self);
  WITH SerPort DO BEGIN
    Baudrate       := br_000050;
    DTRActive      := TRUE;
    ThreadPriority := tpHighest;
    OnRxChar       := @TExpertClock_SerPort1Cts; (* RxD bildet den Dateneingang *)
    (* weitere Initialisierungen *)
    COMPort        := 0;
    AbortOnError   := FALSE;
    Active         := FALSE;
    BufSizeRec     := 2048;
    BufSizeTrm     := 2048;
    COMPort        := 0;
    ContinueOnXOff := FALSE;
    DataBits       := db_8;
    EliminateNullChar := FALSE;
    EofChar           := #26;
    ErrorChar         := '?';
    HandshakeDtrDsr   := FALSE;
    HandshakeRtsCts   := FALSE;
    HandshakeXOnXOff  := FALSE;
    ParityBit         := none;
    RecTimeOut        := 0;
    RTSActive         := FALSE;
    StopBits          := sb_1;
    TrmTimeOut        := 0;
    UseErrorChar      := FALSE;
    XOffChar          := #19;
    XOffLimit         := 1600;
    XOnChar           := #17;
    XOnLimit          := 400;
  END;
  (* Timer für 59. Sekunde *)
  Timer59 := TTimer.Create(Self);
  WITH Timer59 DO BEGIN
    Enabled   := FALSE;
    Interval  := 1000;
    OnTimer   := @TExpertClock_Timer59Timer;
  END;
  (* Timeout-Timer *)
  TimerOut := TTimer.Create(Self);
  WITH TimerOut DO BEGIN
    Enabled  := FALSE;
    Interval := 3000;
    OnTimer  := @TExpertClock_TimerOutTimer;
  END;
END;


  FUNCTION GetBit : BOOLEAN;
  (* Bit einlesen *)
  VAR
    d : BYTE;
    d1: TByteArray;
  BEGIN
    //WHILE SerPort.BufRec > 1 DO SerPort.ReceiveData(d, 1); (* Puffer leeren *)
    SerPort.SendSerialData(d1, 1);
 
    //SerPort.ReceiveSerialData(d1, 1);
    Result := (d AND $F0) <> $F0;
  END;
  
//      RegisterMethod('Function SendSerialData(Data: TByteArray; DataSize: cardinal): cardinal');
  //  RegisterMethod('Function ReceiveSerialData(var Data: TByteArray; DataSize: cardinal): cardinal');



PROCEDURE TExpertClock_SerPort1Cts(Sender: TObject);
(* Ein "Datenbyte" wurde empfangen (DCF-Signal) *)
VAR
  t : DWord;
  
  {FUNCTION GetBit : BOOLEAN;
  (* Bit einlesen *)
  VAR
    d : BYTE;
  BEGIN
    WHILE SerPort.BufRec > 1 DO SerPort.ReceiveData(d, 1); (* Puffer leeren *)
    SerPort.ReceiveData(d, 1);
    Result := (d AND $F0) <> $F0;
  END;}

BEGIN
  t := GetTickCount;  (* Zeitpunkt der Flanke erfassen *)
  //IF Assigned(FOnDCFClock) THEN OnDCFClock(Self);
  CASE FStatus OF
    NoSignal      : BEGIN  (* Signal wurde jetzt erkannt *)
                      LastHi   := t;
                      FStatus  := Synchronizing;  (* neuer Status *)
                      BitCount := 0;
                      //IF Assigned(FOnStatusChanged) THEN 
                        //OnStatusChanged(Self);
                    END;
    Synchronizing : BEGIN  (* warten auf Minutenanfang *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF (t - LastHi > 1500) AND (t - LastHi < 2500) THEN BEGIN
                        (* Minutenanfang wurde erkannt *)
                        BitCount       := 0;
                        Data[BitCount] := GetBit;
                        Inc(BitCount);
                        FStatus := ReceiveData;  (* neuer Status *)
                        //IF Assigned(FOnStatusChanged) THEN 
                          //OnStatusChanged(Self);
                      END;
                      LastHi           := t;
                      TimerOut.Enabled := FALSE; (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
    ReceiveData   : BEGIN  (* Datenbits einlesen *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF t-LastHi > 1500 THEN BitCount := 0; (* Minutenanfang wurde erkannt *)
                      Data[BitCount] := GetBit;
                      Inc(BitCount);
                      LastHi := t;
                      IF BitCount = 59 THEN Timer59.Enabled := TRUE;
                      TimerOut.Enabled := FALSE;  (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
    TimeAvailable : BEGIN  (* Datenbits einlesen, Zeitinformationen aktualisieren *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF t - LastHi > 1500 THEN BitCount := 0;  (* Minutenanfang wurde erkannt *)
                      Data[BitCount] := GetBit;
                      Inc(BitCount);
                      FSecond := BitCount;
                      LastHi  := t;
                      IF BitCount = 59 THEN Timer59.Enabled := TRUE;  (* künstlicher Takt für 59. Sek. *)
                      //IF Assigned(FOnTimeChanged) THEN OnTimeChanged(Self);
                      IF QualityEvent THEN BEGIN
                        //OnQualityAttained(Self);
                        QualityEvent := FALSE;
                      END;
                      TimerOut.Enabled := FALSE;  (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
  END;
END;

  FUNCTION CheckParity(FirstBit, LastBit : INTEGER) : BOOLEAN; //Register;
  (* Liefert true, wenn Anzahl gesetzter Bits gerade ist *)
  (* FirstBit : erstes Bit in Data                       *)
  (* LastBit : letztes Bit in Data                       *)
  VAR
    ii, nn : INTEGER;
  BEGIN
    nn := 0;
    FOR ii := FirstBit TO LastBit DO 
       //Inc(nn, Ord(Data[ii]));
       nn:= nn + Ord(Data[ii]);

    Result := NOT Odd(nn);
  END;


FUNCTION TExpertClock_SetTimeParameters : BOOLEAN; //Register;
(* Konvertiert in Data gesammelte Info in Zeit- und Datumsangaben *)
(* Ergebnis true, wenn Infos korrekt sind                         *)
VAR
  b  : BOOLEAN;
  dt : TDateTime;
  w  : WORD;

BEGIN
  (* Datenauswertung  *)
  FReserveTransmitter := Data[15];
  FSummerTime         := Data[17];
  FSwitchSecond       := Data[19];
  FHour         := Ord(Data[29])         + (Ord(Data[30]) SHL 1) + 
                   (Ord(Data[31]) SHL 2) + (Ord(Data[32]) SHL 3) +
                   10 * (Ord(Data[33])   + (Ord(Data[34]) SHL 1));
  FMinute       := Ord(Data[21])         + (Ord(Data[22]) SHL 1) + 
                   (Ord(Data[23]) SHL 2) + (Ord(Data[24]) SHL 3) +
                   10 * (Ord(Data[25])   + (Ord(Data[26]) SHL 1) +
                   (Ord(Data[27]) SHL 2));
  FDay          := Ord(Data[36])         + (Ord(Data[37]) SHL 1) + 
                   (Ord(Data[38]) SHL 2) + (Ord(Data[39]) SHL 3) +
                   10 * (Ord(Data[40])   + (Ord(Data[41]) SHL 1));
  FMonth        := Ord(Data[45])         + (Ord(Data[46]) SHL 1) + 
                   (Ord(Data[47]) SHL 2) + (Ord(Data[48]) SHL 3) +
                   10 * (Ord(Data[49]));
  FYear         := Ord(Data[50])         + (Ord(Data[51]) SHL 1) +
                   (Ord(Data[52]) SHL 2) + (Ord(Data[53]) SHL 3) +
                   10 * (Ord(Data[54])   + (Ord(Data[55]) SHL 1) + 
                   (Ord(Data[56]) SHL 2) + (Ord(Data[57]) SHL 3));
  FDayOfWeek    := Ord(Data[42])         + (Ord(Data[43]) SHL 1) + 
                   (Ord(Data[44]) SHL 2);
  (* Paritätsprüfung *)
  Result := CheckParity(21, 28);                   (* Minute *)
  Result := Result AND CheckParity(29, 35);        (* Stunde *)
  Result := Result AND CheckParity(36, 58);        (* Datum  *)
  Result := Result AND (NOT Data[0]) AND Data[20]; (* Bit 0 muß 0 und Bit 20 muß 1 sein *)
  (* Jahrkorrektur (Y2K-konform) *)
  IF FYear > 79 THEN FYear := FYear + 1900
                ELSE FYear := FYear + 2000;
  (* Qualitätsprüfung *)
  IF Result THEN Inc(FQuality)
            ELSE FQuality := -1;
  IF FQuality > 0 THEN BEGIN  (* Vergleichswert ist vorhanden *)
    b := LSummerTime = FSummerTime;
    b := b AND (LHour = FHour) AND (LMinute + 1 = FMinute);
    b := b AND (LDay = FDay) AND (LMonth = FMonth) AND (LYear = FYear);
    b := b AND (LDayOfWeek = FDayOfWeek);
    IF NOT b THEN FQuality := 0;
  END;
  IF Result THEN BEGIN
    LSummerTime := FSummerTime;
    LHour       := FHour;
    LMinute     := FMinute;
    LDay        := FDay;
    LMonth      := FMonth;
    LYear       := FYear;
    LDayOfWeek  := FDayOfWeek;
  END;
  //IF (FQuality = FQualityLimit) AND Assigned(FOnQualityAttained) THEN 
    //QualityEvent := TRUE;
END;

PROCEDURE TExpertClock_ErrorTime;
(* Interne Zeitvariablen auf Fehlerzeit (1.1.1980 0:0:0) setzen *)
BEGIN
  FReserveTransmitter := FALSE;
  FSummerTime         := FALSE;
  FHour               := 0;
  FMinute             := 0;
  FSecond             := 0;
  FDay                := 1;
  FMonth              := 1;
  FYear               := 1980;
  FDayOfWeek          := 2;  (* ist ein Dienstag *)
  LSummerTime         := FALSE;
  LHour               := 0;
  LMinute             := 0;
  LDay                := 1;
  LMonth              := 1;
  LYear               := 1980;
  LDayOfWeek          := 2;  (* ist ein Dienstag *)
END;



  PROCEDURE TExpertClock_Timer59Timer(Sender: TObject);
(* Künstliche Generierung der 59. Sekunde *)
VAR
  s : TDCFStatus;
BEGIN
  Timer59.Enabled := FALSE;
  FSecond         := 0;
  (* die neuen Daten auswerten *)
  s := FStatus;
  IF TExpertClock_SetTimeParameters THEN FStatus := TimeAvailable
                       ELSE FStatus := NoSignal;
  //IF Assigned(FOnTimeChanged) THEN OnTimeChanged(Self);
  //IF FStatus < TimeAvailable THEN BEGIN  
    (* Zeitinformationen sind fehlerhaft *)
    FQuality := -1;
    TExpertClock_ErrorTime;
  //END;
  //IF (s<>FStatus) AND Assigned(FOnStatusChanged) THEN 
    //OnStatusChanged(Self);  (* über neuen Status informieren *)
  Inc(BitCount);
END;

PROCEDURE TExpertClock_TimerOutTimer(Sender: TObject);
(* Tritt dieses Timer-Ereignis ein, wird seit 3 Sek. kein *)
(* Signal mehr empfangen                                  *)
BEGIN
  TimerOut.Enabled := FALSE;
  FStatus          := NoSignal; (* neuer Status                 *)
  FQuality         := -1;       (* die Qualität ist beim Teufel *)
  TExpertClock_ErrorTime;
  //IF Assigned(FOnStatusChanged) THEN OnStatusChanged(Self);
END;

procedure TFormMain_btCompileClick(Sender: TObject);
var aprocess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  try
    //AProcess.CommandLine := 'gcc.exe "' + OpenDialog1.FileName + '"'
      //+ ' -o "' + OpenDialog2.FileName + '"';
    AProcess.CommandLine := 'cmd.exe /dir *.*';
    //AProcess.CommandLine := 'calc.exe';
    
    //AProcess.Executable:= 'ppc386';
  // Pass -h together with ppc386 (so we're executing ppc386 -h):
     //AProcess.Parameters.Add('-h');
     //+ OpenDialog1.FileName + '"'
      //+ ' -o "' + OpenDialog2.FileName + '"';
   
    AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
    AProcess.Execute;
    Memo2.Lines.BeginUpdate;
    //Memo2.Lines.Clear;
    Memo2.Lines.LoadFromStream(AProcess.Output);
    Memo2.Lines.EndUpdate;
  finally
    AProcess.Free;
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

 //var mtp: TProcessManager;
 
 //const PM_REMOVE = 234;
 
 procedure FlushMessages;
var
 lpMsg : TMsg;
begin
 
// Flush the message queue for the calling thread
 while PeekMessage(lpMsg, 0, 0, 0, PM_REMOVE) do
 begin
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
 result := not ((Handle = 0) or (Handle = INVALID_HANDLE_VALUE));
 
end;
 
function ComputerName: string;
var
 dwSize : DWORD;
begin
 
// Set max size
 dwSize := Succ(MAX_PATH);
 
// Resource protection
 try
 // Set string length
 SetLength(result, dwSize);
 // Attempt to get the computer name
 //if not (GetComputerName(@result[1], dwSize)) then
 //if not (GetComputerName(result[1], dwSize)) then

 dwSize := 0;
 finally
 // Truncate string
 SetLength(result, dwSize);
 end;
 
end;




{I assume you're referring to the TProcess component that comes with Lazarus. To make a console program start without a console, include the poNoConsole flag in the Options property.
AProcess.Options := AProcess.Options + [poNoConsole];
The options available in that property map very closely to the process creation flags for the CreateProcess API function, where the flag to use is CREATE_NO_WINDOW.}


  var CommandLine: string;

    begin
    
    GetEnvironmentVar('COMSPEC', CommandLine,true);
    writeln(CommandLine +' is found¨!');
    
      if not {JclSysInfo.}GetEnvironmentVar('COMSPEC', CommandLine,true) or (Length(CommandLine) = 0) then  begin
    { Paranoid }
    CommandLine := 'COMMAND.EXE';
    writeln('CommandLine found¨!');
    end;
    
    TFormMain_btCompileClick(self);

    End.
    
    
 http://wiki.freepascal.org/Executing_External_Programs#A_Simple_Example   
    
    
    
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
  //        0=hide / 1=SW_SHOWNORMAL / 3=max / 7=min)   // for SW_ constants : uses ... Windows ...
  if ShellExecute(0,'open',PChar(prog),PChar(params),PChar(extractfilepath(prog)),1) >32 then; //success
  // return values 0..32 are errors
end;

There is also ShellExecuteExW as a WideChar version, and ShellExecuteExA is AnsiChar.



    
    
    