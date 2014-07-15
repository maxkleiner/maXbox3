unit uPSI_D2_VistaHelperU;
{
   a mixed function block
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
  TPSImport_D2_VistaHelperU = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_D2_VistaHelperU(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_D2_VistaHelperU_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Forms
  ,Graphics
  ,Windows
  //,D2_VistaHelperU
  ,XPVistaHelperU
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_D2_VistaHelperU]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_D2_VistaHelperU(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PRODUCT_UNDEFINED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('PRODUCT_ULTIMATE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PRODUCT_HOME_BASIC','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PRODUCT_HOME_PREMIUM','LongWord').SetUInt( $00000003);
 CL.AddConstantN('PRODUCT_ENTERPRISE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PRODUCT_HOME_BASIC_N','LongWord').SetUInt( $00000005);
 CL.AddConstantN('PRODUCT_BUSINESS','LongWord').SetUInt( $00000006);
 CL.AddConstantN('PRODUCT_STANDARD_SERVER','LongWord').SetUInt( $00000007);
 CL.AddConstantN('PRODUCT_DATACENTER_SERVER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('PRODUCT_SMALLBUSINESS_SERVER','LongWord').SetUInt( $00000009);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('PRODUCT_STARTER','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('PRODUCT_DATACENTER_SERVER_CORE','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('PRODUCT_STANDARD_SERVER_CORE','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER_CORE','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER_IA64','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('PRODUCT_BUSINESS_N','LongWord').SetUInt( $00000010);
 CL.AddConstantN('PRODUCT_WEB_SERVER','LongWord').SetUInt( $00000011);
 CL.AddConstantN('PRODUCT_CLUSTER_SERVER','LongWord').SetUInt( $00000012);
 CL.AddConstantN('PRODUCT_HOME_SERVER','LongWord').SetUInt( $00000013);
 CL.AddConstantN('PRODUCT_STORAGE_EXPRESS_SERVER','LongWord').SetUInt( $00000014);
 CL.AddConstantN('PRODUCT_STORAGE_STANDARD_SERVER','LongWord').SetUInt( $00000015);
 CL.AddConstantN('PRODUCT_STORAGE_WORKGROUP_SERVER','LongWord').SetUInt( $00000016);
 CL.AddConstantN('PRODUCT_STORAGE_ENTERPRISE_SERVER','LongWord').SetUInt( $00000017);
 CL.AddConstantN('PRODUCT_SERVER_FOR_SMALLBUSINESS','LongWord').SetUInt( $00000018);
 CL.AddConstantN('PRODUCT_SMALLBUSINESS_SERVER_PREMIUM','LongWord').SetUInt( $00000019);
 CL.AddConstantN('PRODUCT_UNLICENSED','LongWord').SetUInt( $ABCDABCD);
  //CL.AddTypeS('OSVERSIONINFOEXA', '_OSVERSIONINFOEXA');
  //CL.AddTypeS('TOSVersionInfoExA', '_OSVERSIONINFOEXA');
  CL.AddTypeS('TOSVersionInfoEx', 'TOSVersionInfo');
  CL.AddTypeS('TDrivesProperty', 'array[1..26] of boolean;');

  //TDrivesProperty = array['A'..'Z'] of boolean;
 CL.AddDelphiFunction('Function TBSetSystemTime( DateTime : TDateTime; DOW : word) : boolean');
 CL.AddDelphiFunction('Function IsElevated : Boolean');
 CL.AddDelphiFunction('Procedure CoCreateInstanceAsAdmin( aHWnd : HWND; const aClassID : TGUID; const aIID : TGUID; out aObj: TObject)');
  CL.AddTypeS('TPasswordUsage', '( pu_None, pu_Default, pu_Defined )');
 CL.AddDelphiFunction('Function TrimNetResource( UNC : string) : string');
 CL.AddDelphiFunction('Procedure GetFreeDrives( var FreeDrives : TDrivesProperty)');
 CL.AddDelphiFunction('Procedure GetMappedDrives( var MappedDrives : TDrivesProperty)');
 CL.AddDelphiFunction('Function MapDrive( UNCPath : string; Drive : char; PasswordUsage : TPasswordUsage; Password : string; UserUsage : TPasswordUsage; User : string; Comment : string) : boolean');
 CL.AddDelphiFunction('Function UnmapDrive( Drive : char; Force : boolean) : boolean');
 CL.AddDelphiFunction('Function TBIsWindowsVista : Boolean');
 CL.AddDelphiFunction('Procedure SetVistaFonts( const AForm : TForm)');
 CL.AddDelphiFunction('Procedure SetVistaContentFonts( const AFont : TFont)');
 CL.AddDelphiFunction('Function GetProductType( var sType : String) : Boolean');
  CL.AddDelphiFunction('Function lstrcmp( lpString1, lpString2 : PChar) : Integer');
 CL.AddDelphiFunction('Function lstrcmpi( lpString1, lpString2 : PChar) : Integer');
 CL.AddDelphiFunction('Function lstrcpyn( lpString1, lpString2 : PChar; iMaxLength : Integer) : PChar');
 CL.AddDelphiFunction('Function lstrcpy( lpString1, lpString2 : PChar) : PChar');
 CL.AddDelphiFunction('Function lstrcat( lpString1, lpString2 : PChar) : PChar');
 CL.AddDelphiFunction('Function lstrlen( lpString : PChar) : Integer');
 CL.AddDelphiFunction('Function GetTokenInformation( TokenHandle : THandle; TokenInformationClass : TTokenInformationClass; TokenInformation : ___Pointer; TokenInformationLength : DWORD; var ReturnLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetTokenInformation( TokenHandle : THandle; TokenInformationClass : TTokenInformationClass; TokenInformation : ___Pointer; TokenInformationLength : DWORD) : BOOL');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_D2_VistaHelperU_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetSystemTime, 'TBSetSystemTime', cdRegister);
 S.RegisterDelphiFunction(@IsElevated, 'IsElevated', cdRegister);
 S.RegisterDelphiFunction(@CoCreateInstanceAsAdmin, 'CoCreateInstanceAsAdmin', cdRegister);
 S.RegisterDelphiFunction(@TrimNetResource, 'TrimNetResource', cdRegister);
 S.RegisterDelphiFunction(@GetFreeDrives, 'GetFreeDrives', cdRegister);
 S.RegisterDelphiFunction(@GetMappedDrives, 'GetMappedDrives', cdRegister);
 S.RegisterDelphiFunction(@MapDrive, 'MapDrive', cdRegister);
 S.RegisterDelphiFunction(@UnmapDrive, 'UnmapDrive', cdRegister);
 S.RegisterDelphiFunction(@IsWindowsVista, 'TBIsWindowsVista', cdRegister);
 S.RegisterDelphiFunction(@SetVistaFonts, 'SetVistaFonts', cdRegister);
 S.RegisterDelphiFunction(@SetVistaContentFonts, 'SetVistaContentFonts', cdRegister);
 S.RegisterDelphiFunction(@GetProductType, 'GetProductType', cdRegister);
  S.RegisterDelphiFunction(@lstrcmp, 'lstrcmp', CdStdCall);
 S.RegisterDelphiFunction(@lstrcmpi, 'lstrcmpi', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpyn, 'lstrcpyn', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpy, 'lstrcpy', CdStdCall);
 S.RegisterDelphiFunction(@lstrcat, 'lstrcat', CdStdCall);
 S.RegisterDelphiFunction(@lstrlen, 'lstrlen', CdStdCall);
 S.RegisterDelphiFunction(@GetTokenInformation, 'GetTokenInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetTokenInformation, 'SetTokenInformation', CdStdCall);


end;



{ TPSImport_D2_VistaHelperU }
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2_VistaHelperU.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_D2_VistaHelperU(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2_VistaHelperU.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_D2_VistaHelperU(ri);
  RIRegister_D2_VistaHelperU_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
