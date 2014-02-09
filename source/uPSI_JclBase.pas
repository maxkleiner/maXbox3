unit uPSI_JclBase;
{

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
  TPSImport_JclBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
//procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
procedure SIRegister_EJclWin32Error(CL: TPSPascalCompiler);
procedure SIRegister_EJclError(CL: TPSPascalCompiler);
procedure SIRegister_JclBase(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_TObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_EJclWin32Error(CL: TPSRuntimeClassImporter);
procedure RIRegister_EJclError(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclBase_Routines(S: TPSExec);
procedure RIRegister_JclBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,JclBase
  ,contnrs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TObjectList') do
  with CL.AddClassN(CL.FindClass('TList'),'TObjectListJ') do begin
    RegisterMethod('Constructor Create( AOwnsObjects : Boolean)');
    RegisterProperty('Items', 'TObject Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclWin32Error(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclError', 'EJclWin32Error') do
  with CL.AddClassN(CL.FindClass('EJclError'),'EJclWin32Error') do begin
    RegisterMethod('Constructor Create( const Msg : string)');
    RegisterMethod('Constructor CreateFmt( const Msg : string; const Args : array of const)');
    RegisterMethod('Constructor CreateRes( Ident : Integer)');
    RegisterMethod('Constructor CreateResRec( ResStringRec : PResStringRec)');
    RegisterProperty('LastError', 'DWORD', iptr);
    RegisterProperty('LastErrorMsg', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EJclError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EJclError') do begin
    RegisterMethod('Constructor CreateResRec( ResStringRec : PResStringRec)');
    RegisterMethod('Constructor CreateResRecFmt( ResStringRec : PResStringRec; const Args : array of const)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclBase(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JclVersionMajor','LongInt').SetInt( 1);
 CL.AddConstantN('JclVersionMinor','LongInt').SetInt( 22);
 CL.AddConstantN('JclVersionRelease','LongInt').SetInt( 1);
 CL.AddConstantN('JclVersionBuild','LongInt').SetInt( 965);
 CL.AddDelphiFunction('Function SysErrorMessage( ErrNo : Integer) : string');
 CL.AddDelphiFunction('Procedure RaiseLastWin32Error');
 CL.AddDelphiFunction('Procedure QueryPerformanceCounter( var C : Int64)');
 CL.AddDelphiFunction('Function QueryPerformanceFrequency( var Frequency : Int64) : Boolean');
  SIRegister_EJclError(CL);
  SIRegister_EJclWin32Error(CL);
  //RIRegister_EJclError(CL);
  //RIRegister_EJclWin32Error(CL);

  //CL.AddTypeS('Float', 'Extended');
  //CL.AddTypeS('Float', 'Double');
  //CL.AddTypeS('Float', 'Single');
  //CL.AddTypeS('LongWord', 'Cardinal');
  //CL.AddTypeS('TSysCharSet', 'set of Char');
 CL.AddDelphiFunction('Procedure I64ToCardinals( I : Int64; var LowPart, HighPart : Cardinal)');
 CL.AddDelphiFunction('Procedure CardinalsToI64( var I : Int64; const LowPart, HighPart : Cardinal)');
  CL.AddTypeS('TDynByteArray', 'array of Byte');
  CL.AddTypeS('TDynShortintArray', 'array of Shortint');
  CL.AddTypeS('TDynSmallintArray', 'array of Smallint');
  CL.AddTypeS('TDynWordArray', 'array of Word');
  CL.AddTypeS('TDynIntegerArray', 'array of Integer');
  CL.AddTypeS('TDynLongintArray', 'array of Longint');
  CL.AddTypeS('TDynCardinalArray', 'array of Cardinal');
  CL.AddTypeS('TDynInt64Array', 'array of Int64');
  CL.AddTypeS('TDynExtendedArray', 'array of Extended');
  CL.AddTypeS('TDynDoubleArray', 'array of Double');
  CL.AddTypeS('TDynSingleArray', 'array of Single');
  CL.AddTypeS('TDynFloatArray', 'array of Float');
  //CL.AddTypeS('TDynPointerArray', 'array of ___Pointer');
  CL.AddTypeS('TDynStringArray', 'array of string');
  //SIRegister_TObjectList(CL);
 CL.AddDelphiFunction('Procedure RaiseLastOSError');
 // CL.AddTypeS('IInterface', 'IUnknown');    bugfix in 3.9.71
 //CL.AddDelphiFunction('Procedure StringListCustomSort( StringList : TStringList; SortFunc : TStringListCustomSortCompare)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TObjectListOwnsObjects_W(Self: TObjectList; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListOwnsObjects_R(Self: TObjectList; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListItems_W(Self: TObjectList; const T: TObject; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListItems_R(Self: TObjectList; var T: TObject; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure EJclWin32ErrorLastErrorMsg_R(Self: EJclWin32Error; var T: string);
begin T := Self.LastErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure EJclWin32ErrorLastError_R(Self: EJclWin32Error; var T: DWORD);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TObjectList) do begin
    RegisterConstructor(@TObjectList.Create, 'Create');
    RegisterPropertyHelper(@TObjectListItems_R,@TObjectListItems_W,'Items');
    RegisterPropertyHelper(@TObjectListOwnsObjects_R,@TObjectListOwnsObjects_W,'OwnsObjects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclWin32Error(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclWin32Error) do begin
    RegisterConstructor(@EJclWin32Error.Create, 'Create');
    RegisterConstructor(@EJclWin32Error.CreateFmt, 'CreateFmt');
    RegisterConstructor(@EJclWin32Error.CreateRes, 'CreateRes');
    RegisterConstructor(@EJclWin32Error.CreateResRec, 'CreateResRec');
    RegisterPropertyHelper(@EJclWin32ErrorLastError_R,nil,'LastError');
    RegisterPropertyHelper(@EJclWin32ErrorLastErrorMsg_R,nil,'LastErrorMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclError) do begin
    RegisterConstructor(@EJclError.CreateResRec, 'CreateResRec');
    RegisterConstructor(@EJclError.CreateResRecFmt, 'CreateResRecFmt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclBase_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin32Error, 'RaiseLastWin32Error', cdRegister);
 S.RegisterDelphiFunction(@QueryPerformanceCounter, 'QueryPerformanceCounter', cdRegister);
 S.RegisterDelphiFunction(@QueryPerformanceFrequency, 'QueryPerformanceFrequency', cdRegister);
 // RIRegister_EJclError(CL);
 // RIRegister_EJclWin32Error(CL);
 S.RegisterDelphiFunction(@I64ToCardinals, 'I64ToCardinals', cdRegister);
 S.RegisterDelphiFunction(@CardinalsToI64, 'CardinalsToI64', cdRegister);
 // RIRegister_TObjectList(CL);
 S.RegisterDelphiFunction(@RaiseLastOSError, 'RaiseLastOSError', cdRegister);
 //S.RegisterDelphiFunction(@StringListCustomSort, 'StringListCustomSort', cdRegister);
end;


procedure RIRegister_JclBase(CL: TPSRuntimeClassImporter);
begin
//  RIRegister_JvVCLUtils(ri);
  //RIRegister_TJvScreenCanvas(CL);
  //RIRegister_TBits(CL);
  //RIRegister_TMetafileCanvas(CL);
  //RIRegister_TResourceStream(CL);
   RIRegister_EJclError(CL);
   RIRegister_EJclWin32Error(CL);

end;


{ TPSImport_JclBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclBase(ri);
  RIRegister_JclBase_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
