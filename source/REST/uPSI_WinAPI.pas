unit uPSI_WinAPI;
{
   first Spring
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
  TPSImport_WinAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WinAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WinAPI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,WinSvc
  ,Spring_Utils_WinAPI
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WinAPI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WinAPI(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('VER_NT_WORKSTATION','LongWord').SetUInt( $0000001);
 CL.AddConstantN('VER_NT_DOMAIN_CONTROLLER','LongWord').SetUInt( $0000002);
 CL.AddConstantN('VER_NT_SERVER','LongWord').SetUInt( $0000003);
 CL.AddConstantN('VER_SERVER_NT','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('VER_WORKSTATION_NT','LongWord').SetUInt( $40000000);
 CL.AddConstantN('VER_SUITE_SMALLBUSINESS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('VER_SUITE_ENTERPRISE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('VER_SUITE_BACKOFFICE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('VER_SUITE_COMMUNICATIONS','LongWord').SetUInt( $00000008);
 CL.AddConstantN('VER_SUITE_TERMINAL','LongWord').SetUInt( $00000010);
 CL.AddConstantN('VER_SUITE_SMALLBUSINESS_RESTRICTED','LongWord').SetUInt( $00000020);
 CL.AddConstantN('VER_SUITE_EMBEDDEDNT','LongWord').SetUInt( $00000040);
 CL.AddConstantN('VER_SUITE_DATACENTER','LongWord').SetUInt( $00000080);
 CL.AddConstantN('VER_SUITE_SINGLEUSERTS','LongWord').SetUInt( $00000100);
 CL.AddConstantN('VER_SUITE_PERSONAL','LongWord').SetUInt( $00000200);
 CL.AddConstantN('VER_SUITE_BLADE','LongWord').SetUInt( $00000400);
 CL.AddConstantN('VER_SUITE_EMBEDDED_RESTRICTED','LongWord').SetUInt( $00000800);
 CL.AddConstantN('VER_SUITE_SECURITY_APPLIANCE','LongWord').SetUInt( $00001000);
 CL.AddConstantN('VER_SUITE_STORAGE_SERVER','LongWord').SetUInt( $00002000);
 CL.AddConstantN('VER_SUITE_COMPUTE_SERVER','LongWord').SetUInt( $00004000);
 CL.AddConstantN('iphlpapilib','String').SetString( 'iphlpapi.dll');
 CL.AddConstantN('MAX_ADAPTER_DESCRIPTION_LENGTH','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_ADAPTER_NAME_LENGTH','LongInt').SetInt( 256);
 CL.AddConstantN('MAX_ADAPTER_ADDRESS_LENGTH','LongInt').SetInt( 8);
 CL.AddConstantN('DEFAULT_MINIMUM_ENTITIES','LongInt').SetInt( 32);
 CL.AddConstantN('MAX_HOSTNAME_LEN','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_DOMAIN_NAME_LEN','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_SCOPE_ID_LEN','LongInt').SetInt( 256);
  CL.AddTypeS('time_t', 'Longint');
 // CL.AddTypeS('PIP_MASK_STRING', '^IP_MASK_STRING // will not work');
  //CL.AddTypeS('PIP_ADDRESS_STRING', '^IP_ADDRESS_STRING // will not work');
  //CL.AddTypeS('IP_MASK_STRING', 'IP_ADDRESS_STRING');
  //CL.AddTypeS('TIpAddressString', 'IP_ADDRESS_STRING');
  //CL.AddTypeS('PIpAddressString', 'PIP_MASK_STRING');
 // CL.AddTypeS('PIP_ADDR_STRING', '^IP_ADDR_STRING // will not work');
  //CL.AddTypeS('_IP_ADDR_STRING', 'record Next : PIP_ADDR_STRING; IpAddress : IP'
  // +'_ADDRESS_STRING; IpMask : IP_MASK_STRING; Context : DWORD; end');
  //CL.AddTypeS('IP_ADDR_STRING', '_IP_ADDR_STRING');
  //CL.AddTypeS('TIpAddrString', 'IP_ADDR_STRING');
  //CL.AddTypeS('PIpAddrString', 'PIP_ADDR_STRING');
  //CL.AddTypeS('PIP_ADAPTER_INFO', '^IP_ADAPTER_INFO // will not work');
  //CL.AddTypeS('IP_ADAPTER_INFO', '_IP_ADAPTER_INFO');
  //CL.AddTypeS('TIpAdapterInfo', 'IP_ADAPTER_INFO');
  //CL.AddTypeS('PIpAdapterInfo', 'PIP_ADAPTER_INFO');
 //CL.AddDelphiFunction('Function GetAdaptersInfo( pAdapterInfo : PIP_ADAPTER_INFO; var pOutBufLen : ULONG) : DWORD');
 CL.AddConstantN('SERVICE_RUNS_IN_SYSTEM_PROCESS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_CONFIG_DESCRIPTION','LongInt').SetInt( 1);
 CL.AddConstantN('SERVICE_CONFIG_FAILURE_ACTIONS','LongInt').SetInt( 2);
  //CL.AddTypeS('LPSERVICE_DESCRIPTIONA', '^SERVICE_DESCRIPTIONA // will not work');
  CL.AddTypeS('_SERVICE_DESCRIPTIONA', 'record lpDescription : string; end');
  CL.AddTypeS('SERVICE_DESCRIPTIONA', '_SERVICE_DESCRIPTIONA');
  CL.AddTypeS('TServiceDescriptionA', 'SERVICE_DESCRIPTIONA');
  //CL.AddTypeS('PServiceDescriptionA', 'LPSERVICE_DESCRIPTIONA');
  //CL.AddTypeS('LPSERVICE_DESCRIPTIONW', '^SERVICE_DESCRIPTIONW // will not work');
  {CL.AddTypeS('_SERVICE_DESCRIPTIONW', 'record lpDescription : LPWSTR; end');
  CL.AddTypeS('SERVICE_DESCRIPTIONW', '_SERVICE_DESCRIPTIONW');
  CL.AddTypeS('TServiceDescriptionW', 'SERVICE_DESCRIPTIONW');
  CL.AddTypeS('PServiceDescriptionW', 'LPSERVICE_DESCRIPTIONW');
  CL.AddTypeS('SERVICE_DESCRIPTION', 'SERVICE_DESCRIPTIONW');
  CL.AddTypeS('LPSERVICE_DESCRIPTION', 'LPSERVICE_DESCRIPTIONW');
  CL.AddTypeS('TServiceDescription', 'TServiceDescriptionW');
  CL.AddTypeS('PServiceDescription', 'PServiceDescriptionW');
  CL.AddTypeS('SERVICE_DESCRIPTION', 'SERVICE_DESCRIPTIONA');
  CL.AddTypeS('LPSERVICE_DESCRIPTION', 'LPSERVICE_DESCRIPTIONA');
  CL.AddTypeS('TServiceDescription', 'TServiceDescriptionA');
  CL.AddTypeS('PServiceDescription', 'PServiceDescriptionA');}
  //CL.AddTypeS('LPSERVICE_STATUS_PROCESS', '^SERVICE_STATUS_PROCESS // will not '
  // +'work');
  CL.AddTypeS('_SERVICE_STATUS_PROCESS', 'record dwServiceType : DWORD; dwCurre'
   +'ntState : DWORD; dwControlsAccepted : DWORD; dwWin32ExitCode : DWORD; dwSe'
   +'rviceSpecificExitCode : DWORD; dwCheckPoint : DWORD; dwWaitHint : DWORD; d'
   +'wProcessId : DWORD; dwServiceFlags : DWORD; end');
  CL.AddTypeS('SERVICE_STATUS_PROCESS', '_SERVICE_STATUS_PROCESS');
  CL.AddTypeS('TServiceStatusProcess', 'SERVICE_STATUS_PROCESS');
  //CL.AddTypeS('PServiceStatusProcess', 'LPSERVICE_STATUS_PROCESS');
  CL.AddTypeS('_SC_ENUM_TYPE', '( SC_ENUM_PROCESS_INFO )');
  CL.AddTypeS('SC_ENUM_TYPE', '_SC_ENUM_TYPE');
  CL.AddTypeS('SC_HANDLE', 'THandle');
 (*CL.AddTypeS('_ENUM_SERVICE_STATUS_PROCESSA', 'record lpServiceName : LPSTR; l'
   +'pDisplayName : LPSTR; ServiceStatusProcess : SERVICE_STATUS_PROCESS; end');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESSA', '_ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('TEnumServiceStatusProcessA', 'ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('PEnumServiceStatusProcessA', 'LPENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('_ENUM_SERVICE_STATUS_PROCESSW', 'record lpServiceName : LPWSTR; '
   +'lpDisplayName : LPWSTR; ServiceStatusProcess : SERVICE_STATUS_PROCESS; end');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESSW', '_ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('TEnumServiceStatusProcessW', 'ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('PEnumServiceStatusProcessW', 'LPENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESS', 'ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('LPENUM_SERVICE_STATUS_PROCESS', 'LPENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('TEnumServiceStatusProcess', 'TEnumServiceStatusProcessW');
  CL.AddTypeS('PEnumServiceStatusProcess', 'PEnumServiceStatusProcessW');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESS', 'ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('LPENUM_SERVICE_STATUS_PROCESS', 'LPENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('TEnumServiceStatusProcess', 'TEnumServiceStatusProcessA');
  CL.AddTypeS('PEnumServiceStatusProcess', 'PEnumServiceStatusProcessA'); *)
 CL.AddDelphiFunction('Function QueryServiceConfig2A( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceConfig2W( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceConfig2( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusExA(hSCManager: SC_HANDLE; InfoLevel: DWord; dwServiceType: DWORD; dwServiceState: DWORD;'+
                      ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusExW( hSCManager : SC_HANDLE; InfoLevel : DWord; dwServiceType : DWORD; dwServiceState : DWORD;'+
                     ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusEx( hSCManager : SC_HANDLE; InfoLevel : Dword; dwServiceType : DWORD; dwServiceState : DWORD;'+
                     ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function ConvertSidToStringSid( sid : Dword; var stringSid : string) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WinAPI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetAdaptersInfo, 'GetAdaptersInfo', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2A, 'QueryServiceConfig2A', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2W, 'QueryServiceConfig2W', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2, 'QueryServiceConfig2', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusExA, 'EnumServicesStatusExA', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusExW, 'EnumServicesStatusExW', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusEx, 'EnumServicesStatusEx', CdStdCall);
 S.RegisterDelphiFunction(@ConvertSidToStringSid, 'ConvertSidToStringSid', CdStdCall);
end;

 
 
{ TPSImport_WinAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WinAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WinAPI(ri);
  RIRegister_WinAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
