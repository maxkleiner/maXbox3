{ ******************************************************************
  This program evaluates a mathematical expression at run time

  Try for instance:
  4 * arctan(1)              -->  3.1416
  sin(0.5)^2 + cos(0.5)^2    -->  1
  sinh(0.5)^2 - cosh^(0.5)^2 --> -1
  ****************************************************************** }

program eval1;

uses
  dmath;

var
  X : Float;
  S : String;

begin
  InitEval;

  repeat
    Write('Enter an expression : ');
    Readln(S);
    X := Eval(S);
    Writeln(S, ' = ', X:10:4);
  until S = '';
end.
