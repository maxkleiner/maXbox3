unit uPSI_uPSUtils;
{
  step to support byte code compile!
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
  TPSImport_uPSUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPSPascalParser(CL: TPSPascalCompiler);
procedure SIRegister_TPSUnitList(CL: TPSPascalCompiler);
procedure SIRegister_TPSUnit(CL: TPSPascalCompiler);
procedure SIRegister_TPSStringList(CL: TPSPascalCompiler);
procedure SIRegister_TPSList(CL: TPSPascalCompiler);
procedure SIRegister_uPSUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPSPascalParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSUnitList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSUnit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSList(CL: TPSRuntimeClassImporter);
procedure RIRegister_uPSUtils_Routines(S: TPSExec);
procedure RIRegister_uPSUtils(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   Windows
  ,uPSUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uPSUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSPascalParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSPascalParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSPascalParser') do begin
    RegisterProperty('EnableComments', 'Boolean', iptrw);
    RegisterProperty('EnableWhitespaces', 'Boolean', iptrw);
    RegisterMethod('Procedure Next');
    RegisterProperty('GetToken', 'TbtString', iptr);
    RegisterProperty('OriginalToken', 'TbtString', iptr);
    RegisterProperty('CurrTokenPos', 'Cardinal', iptr);
    RegisterProperty('CurrTokenID', 'TPSPasToken', iptr);
    RegisterProperty('Row', 'Cardinal', iptr);
    RegisterProperty('Col', 'Cardinal', iptr);
    RegisterMethod('Procedure SetText( const Data : TbtString)');
    //RegisterProperty('OnParserError', 'TPSParserErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSUnitList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPSUnitList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPSUnitList') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function GetUnit( UnitName : TbtString) : TPSUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSUnit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSUnit') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSUnit') do begin
    RegisterMethod('Constructor Create( List : TPSUnitList)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddUses( pUnitName : TbtString)');
    RegisterMethod('Function HasUses( pUnitName : TbtString) : Boolean');
    RegisterProperty('UnitName', 'TbtString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSStringList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSStringList') do begin
    RegisterMethod('Function Count : LongInt');
    RegisterProperty('Items', 'TbtString Longint', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Procedure Add( const P : TbtString)');
    RegisterMethod('Procedure Delete( NR : LongInt)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSList') do
  begin
    RegisterMethod('Procedure Recreate');
    RegisterProperty('Data', 'PPointerList', iptr);
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IndexOf( P : ___Pointer) : Longint');
    RegisterProperty('Count', 'Cardinal', iptr);
    RegisterProperty('Items', '___Pointer Cardinal', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Function Add( P : Pointer) : Longint');
    RegisterMethod('Procedure AddBlock( List : PPointerList; Count : Longint)');
    RegisterMethod('Procedure Remove( P : ___Pointer)');
    RegisterMethod('Procedure Delete( Nr : Cardinal)');
    RegisterMethod('Procedure DeleteLast');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uPSUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PSMainProcName','String').SetString( '!MAIN');
 CL.AddConstantN('PSMainProcNameOrg','String').SetString( 'Main Proc');
 CL.AddConstantN('PSLowBuildSupport','LongInt').SetInt( 12);
 CL.AddConstantN('PSCurrentBuildNo','LongInt').SetInt( 23);
 CL.AddConstantN('PSCurrentversion','String').SetString( '1.31');
 CL.AddConstantN('PSValidHeader','LongInt').SetInt( 1397769801);
 CL.AddConstantN('PSAddrStackStart','LongInt').SetInt( 1610612736);
 CL.AddConstantN('PSAddrNegativeStackStart','LongInt').SetInt( 1073741824);
 //CL.AddConstantN('TPSBaseType','').SetString( Byte);
 CL.AddConstantN('btReturnAddress','LongInt').SetInt( 0);
 CL.AddConstantN('btU8','LongInt').SetInt( 1);
 CL.AddConstantN('btS8','LongInt').SetInt( 2);
 CL.AddConstantN('btU16','LongInt').SetInt( 3);
 CL.AddConstantN('btS16','LongInt').SetInt( 4);
 CL.AddConstantN('btU32','LongInt').SetInt( 5);
 CL.AddConstantN('btS32','LongInt').SetInt( 6);
 CL.AddConstantN('btSingle','LongInt').SetInt( 7);
 CL.AddConstantN('btDouble','LongInt').SetInt( 8);
 CL.AddConstantN('btExtended','LongInt').SetInt( 9);
 CL.AddConstantN('btString','LongInt').SetInt( 10);
 CL.AddConstantN('btRecord','LongInt').SetInt( 11);
 CL.AddConstantN('btArray','LongInt').SetInt( 12);
 CL.AddConstantN('btPointer','LongInt').SetInt( 13);
 CL.AddConstantN('btPChar','LongInt').SetInt( 14);
 CL.AddConstantN('btResourcePointer','LongInt').SetInt( 15);
 CL.AddConstantN('btVariant','LongInt').SetInt( 16);
 CL.AddConstantN('btS64','LongInt').SetInt( 17);
 CL.AddConstantN('btU64','LongInt').SetInt( 30);
 CL.AddConstantN('btChar','LongInt').SetInt( 18);
 CL.AddConstantN('btWideString','LongInt').SetInt( 19);
 CL.AddConstantN('btWideChar','LongInt').SetInt( 20);
 CL.AddConstantN('btProcPtr','LongInt').SetInt( 21);
 CL.AddConstantN('btStaticArray','LongInt').SetInt( 22);
 CL.AddConstantN('btSet','LongInt').SetInt( 23);
 CL.AddConstantN('btCurrency','LongInt').SetInt( 24);
 CL.AddConstantN('btClass','LongInt').SetInt( 25);
 CL.AddConstantN('btInterface','LongInt').SetInt( 26);
 CL.AddConstantN('btNotificationVariant','LongInt').SetInt( 27);
 CL.AddConstantN('btUnicodeString','LongInt').SetInt( 28);
 CL.AddConstantN('btType','LongInt').SetInt( 130);
 CL.AddConstantN('btEnum','LongInt').SetInt( 129);
 CL.AddConstantN('btExtClass','LongInt').SetInt( 131);
// CL.AddDelphiFunction('Function MakeHash( const s : TbtString) : Longint');
 CL.AddConstantN('CM_A','LongInt').SetInt( 0);
 CL.AddConstantN('CM_CA','LongInt').SetInt( 1);
 CL.AddConstantN('CM_P','LongInt').SetInt( 2);
 CL.AddConstantN('CM_PV','LongInt').SetInt( 3);
 CL.AddConstantN('CM_PO','LongInt').SetInt( 4);
 CL.AddConstantN('Cm_C','LongInt').SetInt( 5);
 CL.AddConstantN('Cm_G','LongInt').SetInt( 6);
 CL.AddConstantN('Cm_CG','LongInt').SetInt( 7);
 CL.AddConstantN('Cm_CNG','LongInt').SetInt( 8);
 CL.AddConstantN('Cm_R','LongInt').SetInt( 9);
 CL.AddConstantN('Cm_ST','LongInt').SetInt( 10);
 CL.AddConstantN('Cm_Pt','LongInt').SetInt( 11);
 CL.AddConstantN('CM_CO','LongInt').SetInt( 12);
 CL.AddConstantN('Cm_cv','LongInt').SetInt( 13);
 CL.AddConstantN('cm_sp','LongInt').SetInt( 14);
 CL.AddConstantN('cm_bn','LongInt').SetInt( 15);
 CL.AddConstantN('cm_vm','LongInt').SetInt( 16);
 CL.AddConstantN('cm_sf','LongInt').SetInt( 17);
 CL.AddConstantN('cm_fg','LongInt').SetInt( 18);
 CL.AddConstantN('cm_puexh','LongInt').SetInt( 19);
 CL.AddConstantN('cm_poexh','LongInt').SetInt( 20);
 CL.AddConstantN('cm_in','LongInt').SetInt( 21);
 CL.AddConstantN('cm_spc','LongInt').SetInt( 22);
 CL.AddConstantN('cm_inc','LongInt').SetInt( 23);
 CL.AddConstantN('cm_dec','LongInt').SetInt( 24);
 CL.AddConstantN('cm_nop','LongInt').SetInt( 255);
 CL.AddConstantN('Cm_PG','LongInt').SetInt( 25);
 CL.AddConstantN('Cm_P2G','LongInt').SetInt( 26);
  CL.AddTypeS('TbtU8', 'Byte');
  CL.AddTypeS('TbtS8', 'ShortInt');
  CL.AddTypeS('TbtU16', 'Word');
  CL.AddTypeS('TbtS16', 'SmallInt');
  CL.AddTypeS('TbtU32', 'Cardinal');
  CL.AddTypeS('TbtS32', 'Longint');
  CL.AddTypeS('TbtSingle', 'Single');
  CL.AddTypeS('TbtDouble', 'double');
  CL.AddTypeS('TbtExtended', 'Extended');
  CL.AddTypeS('tbtCurrency', 'Currency');
  CL.AddTypeS('tbts64', 'int64');
  CL.AddTypeS('Tbtu64', 'uint64');
  CL.AddTypeS('TbtString', 'string');
   CL.AddDelphiFunction('Function MakeHash( const s : TbtString) : Longint');
//   TbtString = {$IFDEF DELPHI2009UP}AnsiString{$ELSE}String{$ENDIF};
   //CL.AddConstantN('PointerSize','LongInt').SetInt( IPointer ( 8 4 ));
 CL.AddConstantN('PSMaxListSize','LongInt').SetInt( Maxint div 16);
  //CL.AddTypeS('PPointerList', '^TPointerList // will not work');
  SIRegister_TPSList(CL);
  CL.AddTypeS('TIFList', 'TPSList');
  SIRegister_TPSStringList(CL);
  CL.AddTypeS('TIFStringList', 'TPsStringList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPSUnitList');
  SIRegister_TPSUnit(CL);
  SIRegister_TPSUnitList(CL);
  CL.AddTypeS('TPSParserErrorKind', '( iNoError, iCommentError, iStringError, iCharError, iSyntaxError )');
  CL.AddTypeS('TPSParserErrorEvent', 'Procedure ( Parser : TObject; Kind : TPSParserErrorKind)');
  SIRegister_TPSPascalParser(CL);
 CL.AddDelphiFunction('Function PSFloatToStr( E : Extended) : TbtString');
 CL.AddDelphiFunction('Function FastLowerCase( const s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function Fw( const S : TbtString) : TbtString');
 CL.AddDelphiFunction('Function FirstWord( const S : TbtString) : TbtString');
 CL.AddDelphiFunction('Function PSIntToStr( I : LongInt) : TbtString');
 CL.AddDelphiFunction('Function PSStrToIntDef( const S : TbtString; Def : LongInt) : LongInt');
 CL.AddDelphiFunction('Function PSStrToInt( const S : TbtString) : LongInt');
 CL.AddDelphiFunction('Function PSStrToFloat( const s : TbtString) : Extended');
 CL.AddDelphiFunction('Function FastUpperCase( const s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function GRFW( var s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function GRLW( var s : TbtString) : TbtString');
 CL.AddConstantN('FCapacityInc','LongInt').SetInt( 32);
 CL.AddDelphiFunction('Function PSWideUpperCase( const S : WideString) : WideString');
 CL.AddDelphiFunction('Function PSWideLowerCase( const S : WideString) : WideString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOnParserError_W(Self: TPSPascalParser; const T: TPSParserErrorEvent);
begin Self.OnParserError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOnParserError_R(Self: TPSPascalParser; var T: TPSParserErrorEvent);
begin T := Self.OnParserError; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCol_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.Col; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserRow_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.Row; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCurrTokenID_R(Self: TPSPascalParser; var T: TPSPasToken);
begin T := Self.CurrTokenID; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCurrTokenPos_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.CurrTokenPos; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOriginalToken_R(Self: TPSPascalParser; var T: TbtString);
begin T := Self.OriginalToken; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserGetToken_R(Self: TPSPascalParser; var T: TbtString);
begin T := Self.GetToken; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableWhitespaces_W(Self: TPSPascalParser; const T: Boolean);
begin Self.EnableWhitespaces := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableWhitespaces_R(Self: TPSPascalParser; var T: Boolean);
begin T := Self.EnableWhitespaces; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableComments_W(Self: TPSPascalParser; const T: Boolean);
begin Self.EnableComments := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableComments_R(Self: TPSPascalParser; var T: Boolean);
begin T := Self.EnableComments; end;

(*----------------------------------------------------------------------------*)
procedure TPSUnitUnitName_W(Self: TPSUnit; const T: TbtString);
begin Self.UnitName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSUnitUnitName_R(Self: TPSUnit; var T: TbtString);
begin T := Self.UnitName; end;

(*----------------------------------------------------------------------------*)
procedure TPSStringListItems_W(Self: TPSStringList; const T: TbtString; const t1: Longint);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSStringListItems_R(Self: TPSStringList; var T: TbtString; const t1: Longint);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPSListItems_W(Self: TPSList; const T: Pointer; const t1: Cardinal);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSListItems_R(Self: TPSList; var T: Pointer; const t1: Cardinal);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPSListCount_R(Self: TPSList; var T: Cardinal);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPSListData_R(Self: TPSList; var T: PPointerList);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSPascalParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSPascalParser) do begin
    RegisterPropertyHelper(@TPSPascalParserEnableComments_R,@TPSPascalParserEnableComments_W,'EnableComments');
    RegisterPropertyHelper(@TPSPascalParserEnableWhitespaces_R,@TPSPascalParserEnableWhitespaces_W,'EnableWhitespaces');
    RegisterVirtualMethod(@TPSPascalParser.Next, 'Next');
    RegisterPropertyHelper(@TPSPascalParserGetToken_R,nil,'GetToken');
    RegisterPropertyHelper(@TPSPascalParserOriginalToken_R,nil,'OriginalToken');
    RegisterPropertyHelper(@TPSPascalParserCurrTokenPos_R,nil,'CurrTokenPos');
    RegisterPropertyHelper(@TPSPascalParserCurrTokenID_R,nil,'CurrTokenID');
    RegisterPropertyHelper(@TPSPascalParserRow_R,nil,'Row');
    RegisterPropertyHelper(@TPSPascalParserCol_R,nil,'Col');
    RegisterVirtualMethod(@TPSPascalParser.SetText, 'SetText');
    RegisterPropertyHelper(@TPSPascalParserOnParserError_R,@TPSPascalParserOnParserError_W,'OnParserError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSUnitList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSUnitList) do begin
    RegisterConstructor(@TPSUnitList.Create, 'Create');
      RegisterMethod(@TPSUnitList.Destroy, 'Free');
     RegisterMethod(@TPSUnitList.GetUnit, 'GetUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSUnit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSUnit) do begin
    RegisterConstructor(@TPSUnit.Create, 'Create');
      RegisterMethod(@TPSUnit.Destroy, 'Free');
       RegisterMethod(@TPSUnit.AddUses, 'AddUses');
    RegisterMethod(@TPSUnit.HasUses, 'HasUses');
    RegisterPropertyHelper(@TPSUnitUnitName_R,@TPSUnitUnitName_W,'UnitName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSStringList) do begin
    RegisterMethod(@TPSStringList.Count, 'Count');
      RegisterMethod(@TPSStringList.Destroy, 'Free');
      RegisterPropertyHelper(@TPSStringListItems_R,@TPSStringListItems_W,'Items');
    RegisterMethod(@TPSStringList.Add, 'Add');
    RegisterMethod(@TPSStringList.Delete, 'Delete');
    RegisterMethod(@TPSStringList.Clear, 'Clear');
    RegisterConstructor(@TPSStringList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSList) do
  begin
    RegisterMethod(@TPSList.Recreate, 'Recreate');
    RegisterPropertyHelper(@TPSListData_R,nil,'Data');
    RegisterConstructor(@TPSList.Create, 'Create');
    RegisterMethod(@TPSList.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TPSListCount_R,nil,'Count');
    RegisterPropertyHelper(@TPSListItems_R,@TPSListItems_W,'Items');
    RegisterMethod(@TPSList.Add, 'Add');
    RegisterMethod(@TPSList.AddBlock, 'AddBlock');
    RegisterMethod(@TPSList.Remove, 'Remove');
    RegisterMethod(@TPSList.Delete, 'Delete');
    RegisterMethod(@TPSList.DeleteLast, 'DeleteLast');
    RegisterVirtualMethod(@TPSList.Clear, 'Clear');
  end;
end;

procedure RIRegister_uPSUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPSList(CL);
  RIRegister_TPSStringList(CL);
  with CL.Add(TPSUnitList) do
  RIRegister_TPSUnit(CL);
  RIRegister_TPSUnitList(CL);
  RIRegister_TPSPascalParser(CL);
 end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_uPSUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MakeHash, 'MakeHash', cdRegister);
 { RIRegister_TPSList(CL);
  RIRegister_TPSStringList(CL);
  with CL.Add(TPSUnitList) do
  RIRegister_TPSUnit(CL);
  RIRegister_TPSUnitList(CL);
  RIRegister_TPSPascalParser(CL);}
 S.RegisterDelphiFunction(@FloatToStr, 'PSFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@FastLowerCase, 'FastLowerCase', cdRegister);
 S.RegisterDelphiFunction(@Fw, 'Fw', cdRegister);
 S.RegisterDelphiFunction(@Fw, 'FirstWord', cdRegister);
 S.RegisterDelphiFunction(@IntToStr, 'PSIntToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDef, 'PSStrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'PSStrToInt', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat, 'PSStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@FastUpperCase, 'FastUpperCase', cdRegister);
 S.RegisterDelphiFunction(@GRFW, 'GRFW', cdRegister);
 S.RegisterDelphiFunction(@GRLW, 'GRLW', cdRegister);
 S.RegisterDelphiFunction(@WideUpperCase, 'PSWideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@WideLowerCase, 'PSWideLowerCase', cdRegister);
end;



{ TPSImport_uPSUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uPSUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uPSUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uPSUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uPSUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
