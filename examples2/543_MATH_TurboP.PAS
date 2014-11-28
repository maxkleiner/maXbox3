unit TPMath;

interface

(* ---------------------- *)       (* --------------------------- *)
(* MATH FUNCTIONS TP-UNIT *)       (* LOGARITHM, POWERS AND ROOTS *)
(* ---------------------- *)       (* --------------------------- *)
function PowerP(x,y:real):real;    (* x to the power of y         *)
function Root (x,y:real):real;     (* the y'th root of x          *)
function Log (x:real):real;        (* Logarithm of x with base 10 *)
function Antilog (x:real):real;    (* 10^x                        *)
function LogBase (x,y:real):real;  (* Logarithm of x with base y  *)
                                   (* --------------------------- *)
                                   (* TRIGONOMETRIC FUNCTIONS     *)
                                   (* --------------------------- *)
function D2R (x:real):real;        (* Degrees to radians          *)
function R2D (x:real):real;        (* Radians to degrees          *)
function Tan (x:real):real;        (* Tangent of x                *)
function ArcSin (x:real):real;     (* Arc sine of x               *)
function ArcCos (x:real):real;     (* Arc cosine of x             *)
                                   (* --------------------------- *)
                                   (* HYPERBOLIC FUNCTIONS        *)
                                   (* --------------------------- *)
function Sinh (x:real):real;       (* Sine hyperbolic of x        *)
function Cosh (x:real):real;       (* Cosine hyperbolic of x      *)
function Tanh (x:real):real;       (* Tangent hyperbolic of x     *)
function ArSinh (x:real):real;     (* Ar sine hyperbolic of x     *)
function ArCosh (x:real):real;     (* Ar cosine hyperbolic of x   *)
function ArTanh (x:real):real;     (* Ar tangent hyperbolic of x  *)
                                   (* --------------------------- *)
                                   (* OTHER FUNCTIONS             *)
                                   (* --------------------------- *)
function Fac (n:integer):real;     (* Factorial of n  (n!)        *)
function Frac (x:real):real;       (* Fraction of x               *)
function Sgn (x:real):integer;     (* Sign of x  <0=-1  0=0  >0=1 *)

implementation

function PowerP(x,y:real):real;
begin
  if x=0.0 then
    result:=1.0
  else
    result:=exp(y*ln(abs(x)));
  if (x<0.0) and (frac(abs(y))=0.0) and (odd(round(y))) then result:=-exp(y*ln(-x));
end;

function Root(x,y:real):real;
begin
  result:=exp(1.0/y*ln(abs(x)));
end;

function Log(x:real):real;
begin
  result:=ln(x)/ln(10.0);
end;

function Antilog(x:real):real;
begin
  if x=0.0 then
    result:=1.0
  else
    result:=exp(x*ln(10.0));
end;

function LogBase(x,y:real):real;
begin
  result:=ln(x)/ln(y);
end;

function D2R(x:real):real;
begin
  result:=x*pi/180.0;
end;

function R2D(x:real):real;
begin
  result:=x*180.0/pi;
end;

function Tan(x:real):real;
begin
  result:=sin(x)/cos(x);
end;

function ArcSin(x:real):real;
begin
  if abs(x)=1.0 then
    result:=pi/2.0
  else
    result:=arctan(x/sqrt(1.0-x*x));
end;

function ArcCos(x:real):real;
begin
  if x=0.0 then result:=pi/2.0;
  if x>0.0 then result:=arctan(sqrt(1.0-x*x)/x);
  if x<0.0 then result:=arctan(sqrt(1.0-x*x)/x)+pi;
end;

function Sinh(x:real):real;
begin
  result:=(exp(x)-exp(-x))/2.0;
end;

function Cosh(x:real):real;
begin
  result:=(exp(x)+exp(-x))/2.0;
end;

function Tanh(x:real):real;
begin
  result:=(exp(x)-exp(-x))/(exp(x)+exp(-x));
end;

function ArSinh(x:real):real;
begin
  result:=ln(x+sqrt(x*x+1.0));
end;

function ArCosh(x:real):real;
begin
  result:=ln(x+sqrt(x*x-1.0));
end;

function ArTanh(x:real):real;
begin
  result:=ln((x+1.0)/(1.0-x))/2.0;
end;

function Fac(n:integer):real;
var
 hlpvar  : integer;
 hlpvarr : real;
begin
  hlpvarr:=1.0;
  for hlpvar:=2 to n do
    hlpvarr:=hlpvarr*hlpvar;
  result:=hlpvarr;
end;

function Frac(x:real):real;
begin
  result:=x-int(x);
end;

function Sgn(x:real):integer;
begin
  result:=0;
  if x>0.0 then result:=1;
  if x<0.0 then result:=-1;
end;

end.
