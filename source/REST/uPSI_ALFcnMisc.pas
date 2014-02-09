unit uPSI_ALFcnMisc;
{
  base func functor
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
  TPSImport_ALFcnMisc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnMisc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnMisc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ALFcnMisc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnMisc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnMisc(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AlBoolToInt( Value : Boolean) : Integer');
 CL.AddDelphiFunction('Function ALMediumPos( LTotal, LBorder, LObject : integer) : Integer');
 CL.AddDelphiFunction('Function AlIsValidEmail( const Value : AnsiString) : boolean');
 CL.AddDelphiFunction('Function AlLocalDateTimeToGMTDateTime( const aLocalDateTime : TDateTime) : TdateTime');
 CL.AddDelphiFunction('Function ALInc( var x : integer; Count : integer) : Integer');
 CL.AddDelphiFunction('function ALCopyStr(const aSourceString: AnsiString; aStart, aLength: Integer): AnsiString');
 CL.AddDelphiFunction('function ALGetStringFromFile(filename: AnsiString; const ShareMode: Word): AnsiString;');
 CL.AddDelphiFunction('Function ALIsInteger(const S: AnsiString): Boolean;');
 CL.AddDelphiFunction('function ALIsDecimal(const S: AnsiString): boolean;');
 CL.AddDelphiFunction('Function ALStringToWideString(const S: AnsiString; const aCodePage: Word): WideString;');
 CL.AddDelphiFunction('function AlWideStringToString(const WS: WideString; const aCodePage: Word): AnsiString;');

 CL.AddDelphiFunction('function ALGUIDToString(const Guid: TGUID): Ansistring;');
 CL.AddDelphiFunction('Function ALMakeKeyStrByGUID: AnsiString;');
 CL.AddDelphiFunction('Function ALGetCodePageFromCharSetName(Acharset:AnsiString): Word;');
 CL.AddDelphiFunction('Function ALUTF8Encode(const S: AnsiString; const aCodePage: Word): AnsiString;');
 CL.AddDelphiFunction('Function ALUTF8decode(const S: AnsiString; const aCodePage: Word): AnsiString;');
 CL.AddDelphiFunction('function ALQuotedStr(const S: AnsiString; const Quote: Char): AnsiString;');
 CL.AddDelphiFunction('function ALDequotedStr(const S: AnsiString; AQuote: Char): AnsiString;');
 CL.AddDelphiFunction('function  AlUTF8removeBOM(const S: AnsiString): AnsiString;');

  end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnMisc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlBoolToInt, 'AlBoolToInt', cdRegister);
 S.RegisterDelphiFunction(@ALMediumPos, 'ALMediumPos', cdRegister);
 S.RegisterDelphiFunction(@AlIsValidEmail, 'AlIsValidEmail', cdRegister);
 S.RegisterDelphiFunction(@AlLocalDateTimeToGMTDateTime, 'AlLocalDateTimeToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALInc, 'ALInc', cdRegister);
 S.RegisterDelphiFunction(@ALCopyStr, 'ALCopyStr', cdRegister);
 S.RegisterDelphiFunction(@ALGetStringFromFile, 'ALGetStringFromFile', cdRegister);
 S.RegisterDelphiFunction(@ALSaveStringtoFile, 'ALSaveStringtoFile', cdRegister);
 S.RegisterDelphiFunction(@ALIsInteger, 'ALIsInteger', cdRegister);
 S.RegisterDelphiFunction(@ALIsDecimal, 'ALIsDecimal', cdRegister);
 S.RegisterDelphiFunction(@ALStringToWideString, 'ALStringToWideString', cdRegister);
 S.RegisterDelphiFunction(@AlWideStringToString, 'AlWideStringToString', cdRegister);

 S.RegisterDelphiFunction(@ALGUIDToString, 'ALGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@ALMakeKeyStrByGUID, 'ALMakeKeyStrByGUID', cdRegister);
 S.RegisterDelphiFunction(@ALGetCodePageFromCharSetName, 'ALGetCodePageFromCharSetName', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8Encode, 'ALUTF8Encode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8decode, 'ALUTF8decode', cdRegister);
 S.RegisterDelphiFunction(@ALQuotedStr, 'ALQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@ALDequotedStr, 'ALDequotedStr', cdRegister);

//function  ALQuotedStr(const S: AnsiString; const Quote: AnsiChar = ''''): AnsiString;
//function  ALDequotedStr(const S: AnsiString; AQuote: AnsiChar): AnsiString;

 end;

 
 
{ TPSImport_ALFcnMisc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMisc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnMisc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMisc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnMisc(ri);
  RIRegister_ALFcnMisc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
