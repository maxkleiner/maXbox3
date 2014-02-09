unit uPSI_Services;
{
  to more REST
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
  TPSImport_Services = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TService(CL: TPSPascalCompiler);
procedure SIRegister_Services(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TService(CL: TPSRuntimeClassImporter);
procedure RIRegister_Services(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinSvc
  ,Services
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Services]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TService(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TService') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TService') do begin
    RegisterMethod('Constructor Create( ServiceName : string; Description : string)');
    RegisterMethod('Function GetServiceError : integer');
    RegisterMethod('Function GetServiceErrorMessage : string');
    RegisterMethod('Function GetState : cardinal');
    RegisterMethod('Function Install : boolean');
    RegisterMethod('Function Uninstall : boolean');
    RegisterMethod('Procedure Insert( Exec : string)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Run( ServThreads : array of TThread; ServBegin : TFuncBool; ServEnd : TFuncBool) : boolean');
    RegisterMethod('Function Exists : boolean');
    RegisterMethod('Function Stop : integer');
    RegisterMethod('Function Start : integer');
    RegisterMethod('Function ReportStart : boolean');
    RegisterMethod('Function ReportStop : boolean');
    RegisterMethod('Procedure ReportEventLog( EventType : TEventType; EventCode : word; Message : string)');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Timeout', 'integer', iptrw);
    RegisterProperty('ExitCode', 'integer', iptrw);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('ParamStr', 'string', iptr);
    RegisterProperty('ParamCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Services(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEventType', '( EventError, EventWarning, EventInformation )');
  SIRegister_TService(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TServiceParamCount_R(Self: TService; var T: integer);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TServiceParamStr_R(Self: TService; var T: string);
begin T := Self.ParamStr; end;

(*----------------------------------------------------------------------------*)
procedure TServiceName_R(Self: TService; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TServiceExitCode_W(Self: TService; const T: integer);
begin Self.ExitCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceExitCode_R(Self: TService; var T: integer);
begin T := Self.ExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TServiceTimeout_W(Self: TService; const T: integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceTimeout_R(Self: TService; var T: integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TService(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TService) do begin
    RegisterConstructor(@TService.Create, 'Create');
    RegisterMethod(@TService.GetServiceError, 'GetServiceError');
    RegisterMethod(@TService.GetServiceErrorMessage, 'GetServiceErrorMessage');
    RegisterMethod(@TService.GetState, 'GetState');
    RegisterMethod(@TService.Install, 'Install');
    RegisterMethod(@TService.Uninstall, 'Uninstall');
    RegisterMethod(@TService.Insert, 'Insert');
    RegisterMethod(@TService.Delete, 'Delete');
    RegisterMethod(@TService.Run, 'Run');
    RegisterMethod(@TService.Exists, 'Exists');
    RegisterMethod(@TService.Stop, 'Stop');
    RegisterMethod(@TService.Start, 'Start');
    RegisterMethod(@TService.ReportStart, 'ReportStart');
    RegisterMethod(@TService.ReportStop, 'ReportStop');
    RegisterMethod(@TService.ReportEventLog, 'ReportEventLog');
    RegisterMethod(@TService.Reset, 'Reset');
    RegisterPropertyHelper(@TServiceTimeout_R,@TServiceTimeout_W,'Timeout');
    RegisterPropertyHelper(@TServiceExitCode_R,@TServiceExitCode_W,'ExitCode');
    RegisterPropertyHelper(@TServiceName_R,nil,'Name');
    RegisterPropertyHelper(@TServiceParamStr_R,nil,'ParamStr');
    RegisterPropertyHelper(@TServiceParamCount_R,nil,'ParamCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Services(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TService(CL);
end;

 
 
{ TPSImport_Services }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Services.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Services(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Services.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Services(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
