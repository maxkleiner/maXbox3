unit uPSI_BlockSocket;
{
   blocks for externals
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
  TPSImport_BlockSocket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_BlockSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_BlockSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SocketsDelphi
  ,BlockSocket
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BlockSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBlockSocket') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBlockSocket') do begin
    RegisterMethod('Constructor Create( S : integer)');
    RegisterMethod('Procedure Bind( pPort, BackLog : word)');
    RegisterMethod('Function Accept( Timeout : integer) : integer');
    RegisterMethod('Procedure Connect( Host : string; pPort : word)');
    RegisterMethod('Procedure Purge');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function RecvPacket : AnsiString');
    RegisterMethod('Function RecvString( Timeout : integer) : AnsiString');
    RegisterMethod('Procedure SendString( const Data : AnsiString)');
    RegisterMethod('Function WaitingData : cardinal');
    RegisterMethod('Function CanRead( Timeout : Integer) : Boolean');
    RegisterMethod('Function Error : integer');
    RegisterMethod('Function GetHostAddress : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BlockSocket(CL: TPSPascalCompiler);
begin
  SIRegister_TBlockSocket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockSocket) do begin
    RegisterConstructor(@TBlockSocket.Create, 'Create');
    RegisterMethod(@TBlockSocket.Bind, 'Bind');
    RegisterMethod(@TBlockSocket.Accept, 'Accept');
    RegisterMethod(@TBlockSocket.Connect, 'Connect');
    RegisterMethod(@TBlockSocket.Purge, 'Purge');
    RegisterMethod(@TBlockSocket.Close, 'Close');
    RegisterMethod(@TBlockSocket.RecvPacket, 'RecvPacket');
    RegisterMethod(@TBlockSocket.RecvString, 'RecvString');
    RegisterMethod(@TBlockSocket.SendString, 'SendString');
    RegisterMethod(@TBlockSocket.WaitingData, 'WaitingData');
    RegisterMethod(@TBlockSocket.CanRead, 'CanRead');
    RegisterMethod(@TBlockSocket.Error, 'Error');
    RegisterMethod(@TBlockSocket.GetHostAddress, 'GetHostAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BlockSocket(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlockSocket(CL);
end;

 
 
{ TPSImport_BlockSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlockSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BlockSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlockSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BlockSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
