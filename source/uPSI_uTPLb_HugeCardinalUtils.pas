unit uPSI_uTPLb_HugeCardinalUtils;
{
  TurboPower Crypto
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
  TPSImport_uTPLb_HugeCardinalUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uTPLb_HugeCardinalUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uTPLb_HugeCardinalUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uTPLb_HugeCardinal
  ,uTPLb_MemoryStreamPool
  ,uTPLb_HugeCardinalUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_HugeCardinalUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_HugeCardinalUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPrimalityTestNoticeProc', 'Procedure ( CountPrimalityTests : integer)');
 CL.AddDelphiFunction('Function gcd( a, b : THugeCardinal) : THugeCardinal');
 CL.AddDelphiFunction('Function lcm( a, b : THugeCardinal) : THugeCardinal');
 CL.AddDelphiFunction('Function isCoPrime( a, b : THugeCardinal) : boolean');
 CL.AddDelphiFunction('Function isProbablyPrime( p : THugeCardinal; OnProgress : TProgress; var wasAborted : boolean) : boolean');
 CL.AddDelphiFunction('Function hasSmallFactor( p : THugeCardinal) : boolean');
 //CL.AddDelphiFunction('Function GeneratePrime( NumBits : integer; OnProgress : TProgress; OnPrimalityTest: TPrimalityTestNoticeProc; PassCount: integer; Pool1: TMemoryStreamPool; var Prime : THugeCardinal; var NumbersTested : integer) : boolean');
 CL.AddDelphiFunction('Function Inverse( Prime, Modulus : THugeCardinal) : THugeCardinal');
 CL.AddConstantN('StandardExponent','LongInt').SetInt( 65537);
 //CL.AddDelphiFunction('Procedure Compute_RSA_Fundamentals_2Factors( RequiredBitLengthOfN : integer; Fixed_e : uint64; var N, e, d, Totient : THugeCardinal;'+
  //'OnProgress : TProgress; OnPrimalityTest : TPrimalityTestNoticeProc; GeneratePrimePassCount : integer; Pool1 : TMemoryStreamPool; var NumbersTested : integer; var wasAborted : boolean)');
 CL.AddDelphiFunction('Function Validate_RSA_Fundamentals( var N, e, d, Totient : THugeCardinal) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_HugeCardinalUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@gcd, 'gcd', cdRegister);
 S.RegisterDelphiFunction(@lcm, 'lcm', cdRegister);
 S.RegisterDelphiFunction(@isCoPrime, 'isCoPrime', cdRegister);
 S.RegisterDelphiFunction(@isProbablyPrime, 'isProbablyPrime', cdRegister);
 S.RegisterDelphiFunction(@hasSmallFactor, 'hasSmallFactor', cdRegister);
 S.RegisterDelphiFunction(@GeneratePrime, 'GeneratePrime', cdRegister);
 S.RegisterDelphiFunction(@Inverse, 'Inverse', cdRegister);
 S.RegisterDelphiFunction(@Compute_RSA_Fundamentals_2Factors, 'Compute_RSA_Fundamentals_2Factors', cdRegister);
 S.RegisterDelphiFunction(@Validate_RSA_Fundamentals, 'Validate_RSA_Fundamentals', cdRegister);
end;

 
 
{ TPSImport_uTPLb_HugeCardinalUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinalUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_HugeCardinalUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinalUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_uTPLb_HugeCardinalUtils(ri);
  RIRegister_uTPLb_HugeCardinalUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
