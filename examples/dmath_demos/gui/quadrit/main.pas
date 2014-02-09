{ **********************************************************************
  This program demonstrates the behavior of a dynamical system: the
  quadratic iterator (also known as the logistic sequence).

  The system is defined by the relationship:

                       x(n+1) = a.x(n).[1 - x(n)]

  According to the value of a the sequence may be:

    * periodic (e.g. for a = 3.5 the period is 4)
    * chaotic (e.g. a = 4)
    * presenting an alternance of periodic and chaotic phases,
       a phenomenon known as intermittency (e.g. a = 3.82812)

  The program can plot two types of diagrams:

    * an "orbit" diagram, in which the value of x(n) is plotted vs. n
    * a "bifurcation" diagram, in which the values of x(n) are plotted
      for each value of a (after an initial run of 200 iterations). The
      bifurcation diagram shows the progressive transition from order to
      chaos via a period-doubling route as a increases. It also shows the
      existence of periodic regions inside the chaotic domain. Magnifying
      these regions reveals a structure similar to the whole plot (i.e.
      the fractal nature of the bifurcation diagram).

  For more information about the quadratic iterator and other chaotic
  systems, see "The Chaos Hypertextbook" (http://hypertextbook.com/chaos/)
  by Glenn Elert.
  ********************************************************************** }


unit Main;  { Main unit of QUADRIT.DPR }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  utypes, uwinplot;

const
  X0 = 0.5;  { Starting point }

procedure TForm1.Button1Click(Sender: TObject);
{ Orbit diagram }
var
  A    : Float;
  I, N : Integer;
  T, X : TVector;
begin
  N := 100;
  A := 3.5;

  DimVector(T, N);
  DimVector(X, N);

  T[0] := 0;
  X[0] := X0;

  A := StrToFloat(InputBox('x'' = a.x.(1-x)', 'Value of a (1..4)',
                  FloatToStr(A)));

  for I := 1 to N do
    begin
      T[I] := I;
      X[I] := A * X[I-1] * (1.0 - X[I-1]);
    end;

  if not InitGraphics(Image1.Width, Image1.Height) then Exit;

  SetWindow(Image1.Canvas, 15, 85, 20, 75, False);

  SetOxScale(LinScale, 0, N, N / 5);
  SetOyScale(LinScale, 0, 1, 0.2);

  SetOxTitle('n');
  SetOyTitle('x(n)');

  SetLineParam(1, psSolid, 1, clRed);
  SetPointParam(1, 1, 4, clYellow);

  PlotOxAxis(Image1.Canvas);
  PlotOyAxis(Image1.Canvas);

  PlotCurve(Image1.Canvas, T, X, 0, N, 1);
end;

procedure TForm1.Button2Click(Sender: TObject);
{ Bifurcation diagram }
const
  N_tot  = 500;  { Total number of points  }
  N_hide = 200;  { Number of hidden points }
var
  A1   : Float;    { Initial value of a (>= 1) }
  A2   : Float;    { Final value of a (<= 4) }
  I, J : Integer;
  A, X : Float;
begin
  A1 := 3.0;
  A2 := 4.0;

  A1 := StrToFloat(InputBox('x'' = a.x.(1-x)', 'Initial value of a (>=1)',
                   FloatToStr(A1)));

  A2 := StrToFloat(InputBox('x'' = a.x.(1-x)', 'Final value of a (<=4)',
                   FloatToStr(A2)));

  if not InitGraphics(Image1.Width, Image1.Height) then Exit;

  SetWindow(Image1.Canvas, 15, 85, 20, 75, False);

  SetOxScale(LinScale, A1, A2, (A2 - A1) / 5);
  SetOyScale(LinScale, 0, 1, 0.2);

  SetOxTitle('a');
  SetOyTitle('x');

  SetPointParam(1, 0, 1, clBlue);

  PlotOxAxis(Image1.Canvas);
  PlotOyAxis(Image1.Canvas);

  for I := Xpixel(A1) to Xpixel(A2) do
    begin
      X := X0;
      A := Xuser(I);
      for J := 1 to N_hide do
        X := A * X * (1.0 - X);
      for J := Succ(N_hide) to N_tot do
        begin
          X := A * X * (1.0 - X);
          PlotPoint(Image1.Canvas, A, X, 1);
        end;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form1.Close;
end;

end.
