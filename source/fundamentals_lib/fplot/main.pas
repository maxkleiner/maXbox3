unit Main;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Spin;

type
  TForm1 = class(TForm)
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    ColorDialog1: TColorDialog;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    Edit7: TEdit;
    Label10: TLabel;
    Edit8: TEdit;
    Label11: TLabel;
    Edit9: TEdit;
    GroupBox3: TGroupBox;
    Shape1: TShape;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    RadioGroup2: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  utypes, umath, utrigo, uhyper, ugamma, uigamma,
  ubeta, uibeta, ulambert, uwinplot;

{$IFDEF _16BIT}const{$ELSE}var{$ENDIF}
  UBranch : Boolean = True;  { Use upper branch of Lambert's function }

var
  A, B, Y : Float;    { Function parameters }

function Func(X : Float) : Float;
{ Function to be plotted }
begin
  case Form1.RadioGroup1.ItemIndex of
    0 : Func := Expo(X);
    1 : Func := Exp2(X);
    2 : Func := Exp10(X);
    3 : Func := Power(X, Y);
    4 : Func := Log(X);
    5 : Func := Log2(X);
    6 : Func := Log10(X);
    7 : Func := Sin(X);
    8 : Func := Cos(X);
    9 : Func := Tan(X);
   10 : Func := ArcSin(X);
   11 : Func := ArcCos(X);
   12 : Func := ArcTan(X);
   13 : Func := Sinh(X);
   14 : Func := Cosh(X);
   15 : Func := Tanh(X);
   16 : Func := ArcSinh(X);
   17 : Func := ArcCosh(X);
   18 : Func := ArcTanh(X);
   19 : Func := Gamma(X);
   20 : Func := IGamma(A, X);
   21 : Func := Beta(X, Y);
   22 : Func := IBeta(A, B, X);
   23 : Func := Erf(X);
   24 : Func := LambertW(X, UBranch, False);
  else
    Func := 0.0
  end;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  with Form1 do
    begin
      Edit7.Visible := (RadioGroup1.ItemIndex in [3, 21]);
      Edit8.Visible := (RadioGroup1.ItemIndex in [20, 22]);
      Edit9.Visible := (RadioGroup1.ItemIndex = 22);

      Label9.Visible  := Edit7.Visible;
      Label10.Visible := Edit8.Visible;
      Label11.Visible := Edit9.Visible;

      GroupBox4.Visible := (RadioGroup1.ItemIndex in [3, 20, 21, 22]);

      RadioGroup2.Visible := (RadioGroup1.ItemIndex = 24);
    end;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
  UBranch := (RadioGroup2.ItemIndex = 0);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Shape1.Brush.Color := ColorDialog1.Color;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  X1, X2, Y1, Y2, D, Temp : Float;
  Npts, Width             : Integer;
  Color                   : TColor;
begin
  if not InitGraphics(Image1.Width, Image1.Height) then Exit;

  SetWindow(Image1.Canvas, 10, 95, 10, 90, True);

  X1 := StrToFloat(Edit1.Text);
  X2 := StrToFloat(Edit2.Text);
  D  := StrToFloat(Edit3.Text);

  if (X1 < X2) and (D > 0.0) and (D <= X2 - X1) then
    SetOxScale(LinScale, X1, X2, D);

  Y1 := StrToFloat(Edit4.Text);
  Y2 := StrToFloat(Edit5.Text);
  D  := StrToFloat(Edit6.Text);

  if (Y1 < Y2) and (D > 0.0) and (D <= Y2 - Y1) then
    SetOyScale(LinScale, Y1, Y2, D);

  PlotOxAxis(Image1.Canvas);
  PlotOyAxis(Image1.Canvas);
  PlotGrid(Image1.Canvas, BothGrid);

  Width := SpinEdit1.Value;
  Npts  := SpinEdit2.Value;
  Color := Shape1.Brush.Color;

  SetLineParam(1, psSolid, Width, Color);

  Temp := StrToFloat(Edit7.Text); if Temp > 0.0 then Y := Temp;
  Temp := StrToFloat(Edit8.Text); if Temp > 0.0 then A := Temp;
  Temp := StrToFloat(Edit9.Text); if Temp > 0.0 then B := Temp;

  PlotFunc(Image1.Canvas, Func, X1, X2, Npts, 1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with Image1 do
    Canvas.FillRect(Rect(0, 0, Width, Height));
end;

end.
