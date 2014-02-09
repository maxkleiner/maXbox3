unit Misc;

interface

uses
  Windows, SysUtils, Classes, ibase;

function CloseDebuggerOutput: Integer; cdecl; export;
function Debug(szDebuggerOutput: PChar): Integer; cdecl; export;
(* Return what IB THINKS is the temp path *)
function IBTempPath: PChar; cdecl; export;
function SetDebuggerOutput(szOutputFile: PChar): Integer; cdecl; export;
function ValidateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer): Integer; cdecl; export;
function EvaluateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer; OldDate, NewDate: PISC_QUAD;
  var Amount: Double): Integer; cdecl; export;
function EvaluateExpression(szExpr: PChar;
  szSymbols: PChar): PChar; cdecl; export;

const
  WhiteSpace = [' ', #9, #10, #13];

var
  hDebugger: THandle;
  csDebugger: TRTLCriticalSection;

implementation

uses
  udf_glob, StrFncs, TimeFncs, StdFuncs, VariantSymbolTable,
  Symbols, ExprParser;

function CloseDebuggerOutput: Integer; cdecl; export;
begin
  {$ifdef FULDebug}
  WriteDebug('CloseDebuggerOutput - Enter');
  {$endif}
  EnterCriticalSection(csDebugger);
  try
    // Default to failure.
    result := UDF_FAILURE;
    // if I've indicated an actual handle, then close it
    try
      if hDebugger > 0 then
        CloseHandle(hDebugger)
      // if I've indicated STDOUT, then Free the console
      else if hDebugger = $FFFFFFFF then
        FreeConsole;
    finally
      // Ensure that the debugger handle is 0.
      hDebugger := 0;
    end;
    // Indicate success.
    result := UDF_SUCCESS;
  finally
    LeaveCriticalSection(csDebugger);
    {$ifdef FULDebug}
    WriteDebug('CloseDebuggerOutput - Exit');
    {$endif}
  end;
end;

const
  szConsoleMsg = 'FreeUDFLib Debugger Console:' + #13 + #10 +
                 '  Press Ctrl-Enter to switch between full-screen and window.' +
                 #13 + #10 + #13 + #10;

{* Important notes regarding Debug:
   This function is meant only for its intended purpose.
   As you will note, I did not include mechanisms for many users
   to be cleanly dumping data to the debug window. Don't expect this
   function to perform as you might like if you have multiple users
   calling it! *}
function Debug(szDebuggerOutput: PChar): Integer; cdecl; export;
var
  hOutput: THandle;
  BytesWritten: DWORD;
  sOutput: String;
begin
  {$ifdef FULDebug}
  WriteDebug('Debug(' + String(szDebuggerOutput) + ') - Enter');
  {$endif}
  EnterCriticalSection(csDebugger);
  try
    // Default to failure.
    result := UDF_FAILURE;
    if hDebugger = 0 then exit;
    // -1 indicates STDOUT, so let's do just that
    if hDebugger = $FFFFFFFF then begin
      // Try to get STDOUT's handle.
      hOutput := GetStdHandle(STD_OUTPUT_HANDLE);
      // if I couldn't get STDOUT's handle, then AllocConsole probably needs
      // to be called.
      if hOutput = INVALID_HANDLE_VALUE then begin
        // Allocate a console.
        AllocConsole;
        // Just check that everything went right, and put a friendly
        // message at the top of the console window.
        hOutput := GetStdHandle(STD_OUTPUT_HANDLE);
        if hOutput = INVALID_HANDLE_VALUE then exit;
        WriteFile(hOutput, szConsoleMsg, StrLen(szConsoleMsg), BytesWritten, nil);
      end;
    end else
      hOutput := hDebugger;
    // Now, I can write my debugging stuff! whew.
    sOutput := String(szDebuggerOutput) + #13 + #10;
    WriteFile(hOutput, sOutput[1], Length(sOutput), BytesWritten, nil);
    result := UDF_SUCCESS;
  finally
    LeaveCriticalSection(csDebugger);
    {$ifdef FULDebug}
    WriteDebug('Debug(' + String(szDebuggerOutput) + ') - Exit');
    {$endif}
  end;
end;

function IBTempPath: PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('IBTempPath() - Enter');
  {$endif}
  result := MakeResultString(StdFuncs.TempPath, nil, 0);
  {$ifdef FULDebug}
  WriteDebug('IBTempPath() - Exit');
  {$endif}
end;

function SetDebuggerOutput(szOutputFile: PChar): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('SetDebuggerOutput(' + String(szOutputFile) + ') - Enter');
  {$endif}
  EnterCriticalSection(csDebugger);
  try
    // Default to failure.
    result := UDF_FAILURE;
    // If the user asked for STDOUT, then set the "new" handle to -1.
    if lstrcmpi(szOutputFile, 'STDOUT') = 0 then begin
      if (hDebugger > 0) then
        CloseDebuggerOutput;
      hDebugger := $FFFFFFFF;
    end else begin
      CloseDebuggerOutput;
      hDebugger := CreateFile(szOutputFile, GENERIC_WRITE, 0, nil,
                                 CREATE_ALWAYS,
                                 FILE_ATTRIBUTE_NORMAL + FILE_FLAG_WRITE_THROUGH,
                                 0);
      if hDebugger = INVALID_HANDLE_VALUE then
        hDebugger := 0;
    end;
    result := UDF_SUCCESS;
  finally
    LeaveCriticalSection(csDebugger);
    {$ifdef FULDebug}
    WriteDebug('SetDebuggerOutput(' + String(szOutputFile) + ') - Exit');
    {$endif}
  end;
end;

function ValidateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer): Integer;
var
   strToken: String;
begin
  {$ifdef FULDebug}
  WriteDebug('ValidateCycleExpression - Enter');
  {$endif}
  result := 1;
  strToken := FindTokenStartingAt(String(szCycleExpression), ExprStart,
                                  WhiteSpace, False);
  if (Length(strToken) > 0) then begin
    case strToken[1] of
      '0'..'9': begin
        try
          StrToInt(strToken);
        except
          result := 0;
        end;
      end;
      '>': begin
        if (strToken[2] = '=') then begin
          Delete(strToken, 1, 2);
          try
            StrToInt(strToken);
          except
            result := 0;
          end;
        end else
          result := 0;
      end;  // '>'
      '$': begin
        Delete(strToken, 1, 1);
        try
          StrToFloat(strToken);
        except
          result := 0;
        end;
      end;  // '$'
      'A','a': begin
        if (Length(strToken) = 3) and
           ((strToken[2] = 'N') or (strToken[2] = 'n')) and
           ((strToken[3] = 'D') or (strToken[3] = 'd')) then
          Result := ValidateCycleExpression(szCycleExpression, ExprStart) and
                    ValidateCycleExpression(szCycleExpression, ExprStart)
        else
          result := 0;
      end; // and
      'O','o': begin
        if (Length(strToken) = 2) and
           ((strToken[2] = 'R') or (strToken[2] = 'r')) then
          Result := ValidateCycleExpression(szCycleExpression, ExprStart) and
                    ValidateCycleExpression(szCycleExpression, ExprStart)
        else
          result := 0;
      end; // or
      'N','n': begin
        if (Length(strToken) = 3) and
           ((strToken[2] = 'O') or (strToken[2] = 'o')) and
           ((strToken[3] = 'T') or (strToken[3] = 't')) then
          result := ValidateCycleExpression(szCycleExpression, ExprStart);
      end; // not
      else
        result := 0;
    end; // case szCycleExpression[ExprStart] of
  end else
     result := 0;
  {$ifdef FULDebug}
  WriteDebug('ValidateCycleExpression - Exit');
  {$endif}
end; // boolValidateCycleExpression


function EvaluateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer; OldDate, NewDate: PISC_QUAD;
  var Amount: Double): Integer;
var
   AmountD: double;
   DateInt, AgeInt: integer;
   strToken, amountStr, dateStr: String;
begin
  {$ifdef FULDebug}
  WriteDebug('EvaluateCycleExpression - Enter');
  {$endif}
  if (szCycleExpression[0] = #0) then begin
    result := 0;
    exit;
  end;
  result := 1;
  amountStr := '';
  dateStr := '';
  strToken := FindTokenStartingAt(String(szCycleExpression), ExprStart,
                                  WhiteSpace, False);
  case strToken[1] of
    '0'..'9': begin
      DateInt := StrToInt(strToken);
      AgeInt := AgeInMonths(OldDate, NewDate);
      if ((ageInt mod dateInt) <> 0) then
        result := 0;
    end;  // '0'..'9'
    '>': begin
      Delete(strToken, 1, 2);
      dateInt := StrToInt(strToken);
      ageInt := AgeInMonths(OldDate, NewDate);
      if (ageInt < dateInt) then
        result := 0;
    end;  // '>'
    '$': begin
      Delete(strToken, 1, 1);
      amountD := StrToFloat(strToken);
      if (Amount < amountD) then
        result := 0;
    end;  // '$'
    'a','A': begin
      if (EvaluateCycleExpression(szCycleExpression, ExprStart,
                OldDate, NewDate, Amount) = 1) and
         (EvaluateCycleExpression(szCycleExpression, ExprStart,
                OldDate, NewDate, Amount) = 1) then
        Result := 1
      else
        Result := 0;
    end; // and
    'o','O': begin
      if (EvaluateCycleExpression(szCycleExpression, ExprStart,
                OldDate, NewDate, Amount) = 1) or
         (EvaluateCycleExpression(szCycleExpression, ExprStart,
                OldDate, NewDate, Amount) = 1) then
        Result := 1
      else
        Result := 0;
    end; // or
    'n','N': begin
      result := 1 and EvaluateCycleExpression(szCycleExpression, ExprStart,
                        OldDate, NewDate, Amount);
    end; // not
    else
      result := 0;
  end; // case strToken[1] of
  {$ifdef FULDebug}
  WriteDebug('EvaluateCycleExpression - Exit');
  {$endif}
end; // EvaluateCycleExpression

function ValidateBillingExpression(szCycleExpression: PChar;
  var ExprStart: Integer): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('ValidateBillingExpression - Enter');
  {$endif}
  result := 1;
  {$ifdef FULDebug}
  WriteDebug('ValidateBillingExpression - Exit');
  {$endif}
end;

function EvaluateExpression(szExpr: PChar; szSymbols: PChar): PChar;
var
  slExpr, slErrors, slSymbols: TStrings;
  SymTab: TVariantSymbolTable;
begin
  {$ifdef FULDebug}
  WriteDebug('EvaluateExpression - Enter');
  {$endif}
  slExpr := TStringList.Create;
  slErrors := TStringList.Create;
  slSymbols := TStringList.Create;
  SymTab := TVariantSymbolTable.Create;
  try
    slSymbols.Text := String(szSymbols);
    (* Load the symbol table *)
    Symbols.LoadSymbols(slSymbols, SymTab, slErrors);
    (* Parse and evalute the expression *)
    slExpr.Text := String(szExpr);
    if ExprParser.EvaluateExpression(slExpr, SymTab, slErrors) then
      result := MakeResultString('TRUE', nil, 0)
    else
      result := MakeResultString('FALSE', nil, 0);
  finally
    if slErrors.Count > 0 then
      result := MakeResultString(PChar(slErrors.Text), nil, 0);
    SymTab.Free;
    slExpr.Free;
    slErrors.Free;
    slSymbols.Free;
  end;
  {$ifdef FULDebug}
  WriteDebug('EvaluateExpression - Exit');
  {$endif}
end;


initialization

  InitializeCriticalSection(csDebugger);

finalization

  DeleteCriticalSection(csDebugger);

end.
