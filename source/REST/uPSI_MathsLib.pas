unit uPSI_MathsLib;
{
   just another big box
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
  TPSImport_MathsLib = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPrimes(CL: TPSPascalCompiler);
procedure SIRegister_MathsLib(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPrimes(CL: TPSRuntimeClassImporter);
procedure RIRegister_MathsLib_Routines(S: TPSExec);
//  RIRegister_TPrimes(CL);


procedure Register;

implementation


uses
   Windows
  ,Dialogs
 // ,UBigIntsV4
  ,MathsLib
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MathsLib]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPrimes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPrimes') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPrimes') do begin
    RegisterProperty('Prime', 'array of int64', iptrw);
    RegisterProperty('nbrprimes', 'integer', iptrw);
    RegisterProperty('nbrfactors', 'integer', iptrw);
    RegisterProperty('nbrcanonicalfactors', 'integer', iptrw);
    RegisterProperty('nbrdivisors', 'integer', iptrw);
    RegisterProperty('Factors', 'array of int64', iptrw);
    RegisterProperty('CanonicalFactors', 'array of TPoint64', iptrw);
    RegisterProperty('Divisors', 'array of int64', iptrw);
    RegisterMethod('Function GetNextPrime( n : int64) : int64');
    RegisterMethod('Function GetPrevPrime( n : int64) : int64');
    RegisterMethod('Function IsPrime( n : int64) : boolean');
    RegisterMethod('Procedure GetFactors( const n : int64)');
    RegisterMethod('Function MaxPrimeInTable : int64');
    RegisterMethod('Function GetNthPrime( const n : integer) : int64');
    RegisterMethod('Procedure GetCanonicalFactors( const n : int64)');
    RegisterMethod('Procedure GetDivisors( const n : int64)');
    RegisterMethod('Function Getnbrdivisors( n : int64) : integer');
    RegisterMethod('Function radical( n : int64) : int64');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MathsLib(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('intset', 'set of byte');
  CL.AddTypeS('TPoint64', 'record x : int64; y : int64; end');
 CL.AddDelphiFunction('Function GetNextPandigital( size : integer; var Digits : array of integer) : boolean');
 CL.AddDelphiFunction('Function IsPolygonal( T : int64; var rank : array of integer) : boolean');
 CL.AddDelphiFunction('Function GeneratePentagon( n : integer) : integer');
 CL.AddDelphiFunction('Function IsPentagon( p : integer) : boolean');
 CL.AddDelphiFunction('Function isSquare( const N : int64) : boolean');
 CL.AddDelphiFunction('Function isCube( const N : int64) : boolean');
 CL.AddDelphiFunction('Function isPalindrome( const n : int64) : boolean;');
 CL.AddDelphiFunction('Function isPalindrome1( const n : int64; var len : integer) : boolean;');
 CL.AddDelphiFunction('Function GetEulerPhi( n : int64) : int64');
 CL.AddDelphiFunction('Function dffIntPower( a, b : int64) : int64;');
 CL.AddDelphiFunction('Function IntPower1( a : extended; b : int64) : extended;');
 CL.AddDelphiFunction('Function gcd2( a, b : int64) : int64');
 CL.AddDelphiFunction('Function GCDMany( A : array of integer) : integer');
 CL.AddDelphiFunction('Function LCMMany( A : array of integer) : integer');
 CL.AddDelphiFunction('Procedure ContinuedFraction( A : array of int64; const wholepart : integer; var numerator, denominator : int64)');
 CL.AddDelphiFunction('Function dffFactorial( n : int64) : int64');
 CL.AddDelphiFunction('Function digitcount( n : int64) : integer');
 CL.AddDelphiFunction('Function nextpermute( var a : array of integer) : boolean');
 CL.AddDelphiFunction('Function convertfloattofractionstring( N : extended; maxdenom : integer; multipleof : boolean) : string');
 CL.AddDelphiFunction('Function convertStringToDecimal( s : string; var n : extended) : Boolean');
 CL.AddDelphiFunction('Function InttoBinaryStr( nn : integer) : string');
 CL.AddDelphiFunction('Function StrtoAngle( const s : string; var angle : extended) : boolean');
 CL.AddDelphiFunction('Function AngleToStr( angle : extended) : string');
 CL.AddDelphiFunction('Function deg2rad( deg : extended) : extended');
 CL.AddDelphiFunction('Function rad2deg( rad : extended) : extended');
 CL.AddDelphiFunction('Function GetLongToMercProjection( const long : extended) : extended');
 CL.AddDelphiFunction('Function GetLatToMercProjection( const Lat : Extended) : Extended');
 CL.AddDelphiFunction('Function GetMercProjectionToLong( const ProjLong : extended) : extended');
 CL.AddDelphiFunction('Function GetMercProjectionToLat( const ProjLat : extended) : extended');
  SIRegister_TPrimes(CL);
  //RIRegister_TPrimes(CL);

 //CL.AddConstantN('deg','LongInt').SetInt( char( 176));
 CL.AddConstantN('minmark','LongInt').SetInt(( 180));
 CL.AddDelphiFunction('Function Random64( const N : Int64) : Int64;');
 CL.AddDelphiFunction('Procedure Randomize64');
 CL.AddDelphiFunction('Function Random641 : extended;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Random641_P : extended;
Begin Result := MathsLib.Random64; END;

(*----------------------------------------------------------------------------*)
Function Random64_P( const N : Int64) : Int64;
Begin //Result := MathsLib.Random64(N);
END;

(*----------------------------------------------------------------------------*)
procedure TPrimesDivisors_W(Self: TPrimes; const T: array of int64);
Begin //Self.Divisors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesDivisors_R(Self: TPrimes; var T: array of int64);
Begin //T := Self.Divisors;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesCanonicalFactors_W(Self: TPrimes; const T: array of TPoint64);
Begin //Self.CanonicalFactors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesCanonicalFactors_R(Self: TPrimes; var T: array of TPoint64);
Begin //T := Self.CanonicalFactors;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesFactors_W(Self: TPrimes; const T: array of int64);
Begin //Self.Factors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesFactors_R(Self: TPrimes; var T: array of int64);
Begin //T := Self.Factors;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrdivisors_W(Self: TPrimes; const T: integer);
Begin Self.nbrdivisors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrdivisors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrdivisors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrcanonicalfactors_W(Self: TPrimes; const T: integer);
Begin Self.nbrcanonicalfactors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrcanonicalfactors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrcanonicalfactors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrfactors_W(Self: TPrimes; const T: integer);
Begin Self.nbrfactors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrfactors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrfactors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrprimes_W(Self: TPrimes; const T: integer);
Begin Self.nbrprimes := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrprimes_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrprimes; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesPrime_W(Self: TPrimes; const T: array of int64);
Begin //Self.Prime := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesPrime_R(Self: TPrimes; var T: array of int64);
Begin //T := Self.Prime;
end;

(*----------------------------------------------------------------------------*)
Function IntPower1_P( a : extended; b : int64) : extended;
Begin Result := MathsLib.IntPower(a, b); END;

(*----------------------------------------------------------------------------*)
Function IntPower_P( a, b : int64) : int64;
Begin Result := MathsLib.IntPower(a, b); END;

(*----------------------------------------------------------------------------*)
Function isPalindrome1_P( const n : int64; var len : integer) : boolean;
Begin Result := MathsLib.isPalindrome(n, len); END;

(*----------------------------------------------------------------------------*)
Function isPalindrome_P( const n : int64) : boolean;
Begin Result := MathsLib.isPalindrome(n); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPrimes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrimes) do begin
    RegisterPropertyHelper(@TPrimesPrime_R,@TPrimesPrime_W,'Prime');
    RegisterPropertyHelper(@TPrimesnbrprimes_R,@TPrimesnbrprimes_W,'nbrprimes');
    RegisterPropertyHelper(@TPrimesnbrfactors_R,@TPrimesnbrfactors_W,'nbrfactors');
    RegisterPropertyHelper(@TPrimesnbrcanonicalfactors_R,@TPrimesnbrcanonicalfactors_W,'nbrcanonicalfactors');
    RegisterPropertyHelper(@TPrimesnbrdivisors_R,@TPrimesnbrdivisors_W,'nbrdivisors');
    RegisterPropertyHelper(@TPrimesFactors_R,@TPrimesFactors_W,'Factors');
    RegisterPropertyHelper(@TPrimesCanonicalFactors_R,@TPrimesCanonicalFactors_W,'CanonicalFactors');
    RegisterPropertyHelper(@TPrimesDivisors_R,@TPrimesDivisors_W,'Divisors');
    RegisterMethod(@TPrimes.GetNextPrime, 'GetNextPrime');
    RegisterMethod(@TPrimes.GetPrevPrime, 'GetPrevPrime');
    RegisterMethod(@TPrimes.IsPrime, 'IsPrime');
    RegisterMethod(@TPrimes.GetFactors, 'GetFactors');
    RegisterMethod(@TPrimes.MaxPrimeInTable, 'MaxPrimeInTable');
    RegisterMethod(@TPrimes.GetNthPrime, 'GetNthPrime');
    RegisterMethod(@TPrimes.GetCanonicalFactors, 'GetCanonicalFactors');
    RegisterMethod(@TPrimes.GetDivisors, 'GetDivisors');
    RegisterMethod(@TPrimes.Getnbrdivisors, 'Getnbrdivisors');
    RegisterMethod(@TPrimes.radical, 'radical');
    RegisterConstructor(@TPrimes.Create, 'Create');
    RegisterMethod(@TPrimes.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MathsLib_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetNextPandigital, 'GetNextPandigital', cdRegister);
 S.RegisterDelphiFunction(@IsPolygonal, 'IsPolygonal', cdRegister);
 S.RegisterDelphiFunction(@GeneratePentagon, 'GeneratePentagon', cdRegister);
 S.RegisterDelphiFunction(@IsPentagon, 'IsPentagon', cdRegister);
 S.RegisterDelphiFunction(@isSquare, 'isSquare', cdRegister);
 S.RegisterDelphiFunction(@isCube, 'isCube', cdRegister);
 S.RegisterDelphiFunction(@isPalindrome, 'isPalindrome', cdRegister);
 S.RegisterDelphiFunction(@isPalindrome1_P, 'isPalindrome1', cdRegister);
 S.RegisterDelphiFunction(@GetEulerPhi, 'GetEulerPhi', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'dffIntPower', cdRegister);
 S.RegisterDelphiFunction(@IntPower1_P, 'IntPower1', cdRegister);
 S.RegisterDelphiFunction(@gcd2, 'gcd2', cdRegister);
 S.RegisterDelphiFunction(@GCDMany, 'GCDMany', cdRegister);
 S.RegisterDelphiFunction(@LCMMany, 'LCMMany', cdRegister);
 S.RegisterDelphiFunction(@ContinuedFraction, 'ContinuedFraction', cdRegister);
 S.RegisterDelphiFunction(@Factorial, 'dffFactorial', cdRegister);
 S.RegisterDelphiFunction(@digitcount, 'digitcount', cdRegister);
 S.RegisterDelphiFunction(@nextpermute, 'nextpermute', cdRegister);
 S.RegisterDelphiFunction(@convertfloattofractionstring, 'convertfloattofractionstring', cdRegister);
 S.RegisterDelphiFunction(@convertStringToDecimal, 'convertStringToDecimal', cdRegister);
 S.RegisterDelphiFunction(@InttoBinaryStr, 'InttoBinaryStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoAngle, 'StrtoAngle', cdRegister);
 S.RegisterDelphiFunction(@AngleToStr, 'AngleToStr', cdRegister);
 S.RegisterDelphiFunction(@deg2rad, 'deg2rad', cdRegister);
 S.RegisterDelphiFunction(@rad2deg, 'rad2deg', cdRegister);
 S.RegisterDelphiFunction(@GetLongToMercProjection, 'GetLongToMercProjection', cdRegister);
 S.RegisterDelphiFunction(@GetLatToMercProjection, 'GetLatToMercProjection', cdRegister);
 S.RegisterDelphiFunction(@GetMercProjectionToLong, 'GetMercProjectionToLong', cdRegister);
 S.RegisterDelphiFunction(@GetMercProjectionToLat, 'GetMercProjectionToLat', cdRegister);
//  RIRegister_TPrimes(CL);
 S.RegisterDelphiFunction(@Random64, 'Random64', cdRegister);
 S.RegisterDelphiFunction(@Randomize64, 'Randomize64', cdRegister);
 S.RegisterDelphiFunction(@Random641_P, 'Random641', cdRegister);
end;

 
 
{ TPSImport_MathsLib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathsLib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MathsLib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathsLib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MathsLib(ri);
  RIRegister_MathsLib_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
