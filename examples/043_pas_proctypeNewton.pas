program newton_solver;
//shows use of procedure types

type
  TFunction = function(x: Double): Double;


function f1(x: Double): Double;
begin
  Result:= x*x + 4;
end;

//------------------------------------------------------------------------------

function f2(x: Double): Double;
begin
  Result:= -(x*x) + 3;
end;

//------------------------------------------------------------------------------

function Solve2(leftside: TFunction; rightside: TFunction; x1: Double): Double;
var
  x2: double;
  Solved: boolean;
  Iterations: integer;
begin
  Solved:= false;
  Iterations:= 0;
  while not(Solved) do begin
    x2:= x1 - ((leftside(x1) - rightside(x1)) / (((leftside(x1+0.0001) -
            rightside(x1+0.0001)) - (leftside(x1) - rightside(x1))) / 0.0001));
    x1:= x2;
    //if SameValue(leftside(x1),rightside(x1),1E-5) then begin
    if leftside(x1) = rightside(x1) then begin
      solved:= True;
      Result:= x1;  
      Exit;
    end;
    if Iterations = 1000 then begin
      Solved:= True;
      Result:= NaN;
      Exit;
    end;
    inc(Iterations);
  end;
end;

//------------------------------------------------------------------------------

var 
  fct1x, fct2x: TFunction;
begin
 //calls the proc with a function var
    fct1x:= @f1
    fct2x:= @f2
    writeln(FloatToStr(Solve2(fct1x,fct2x,3.5)));
end.

