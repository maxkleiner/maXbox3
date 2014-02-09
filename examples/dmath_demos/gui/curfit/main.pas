unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Printers;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Memo1: TMemo;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  { DMath units }
  utypes, unlfit, umodels, uregtest, uinvbeta, uinterv, ustrings, uwinplot,
  { Dialogs }
  RegFunc, GraphOpt;

const
  MaxIter = 1000;      { Max. number of iterations }
  Tol     = 1.0E-10;   { Tolerance for nonlinear regression }
  SVDTol  = 1.0E-10;   { Tolerance for singular value decomposition }
  Alpha   = 0.05;      { Significance level for statistical tests }
  Npts    = 100;       { Nb of points in plotted curve }
  
var
  InFName  : String;   { Name of input file }
  OutFName : String;   { Name of output file }
  Title    : String;   { Title of study }
  XName    : String;   { Name of X variable }
  YName    : String;   { Name of Y variable }
  N        : Integer;  { Number of points }
  Model    : TModel;   { Regression model }
  X, Y     : TVector;  { Point coordinates }
  B        : TVector;  { Regression parameters }
  ErrCode  : Integer;  { Error code }

  function ReadInputFile(InFName   : String;
                         var Title,
                             XName,
                             YName : String;
                         var N     : Integer;
                         var X, Y  : TVector) : Integer;
{ ----------------------------------------------------------------------
  Reads an input file for linear or polynomial regression.
  The input file is an ASCII file with the following structure :

    Line 1 : Title of study
    Line 2 : Number of variables (must be 2 here !)
    Line 3 : Name of variable x
    Line 4 : Name of variable y
    Line 5 : Number of points (must be > number of fitted parameters !)

    The next lines contain the coordinates (x, y) of the points (1 point
    by line). The values of x and y must be separated by spaces or tabs.
  ---------------------------------------------------------------------- }
  var
    InF  : Text;     { Input file }
    Nvar : Integer;  { Number of variables }
    K    : Integer;  { Loop variable }
  begin
    Assign(InF, InFName);
    Reset(InF);

    ReadLn(InF, Title);
    ReadLn(InF, Nvar);

    if Nvar <> 2 then
      begin
        MessageDlg('Data file must contain 2 variables !', mtError, [mbOK], 0);
        ReadInputFile := - 1;
        Exit;
      end;

    ReadLn(InF, XName);
    ReadLn(InF, YName);
    ReadLn(InF, N);

    DimVector(X, N);
    DimVector(Y, N);

    for K := 1 to N do
      ReadLn(InF, X[K], Y[K]);

    Close(InF);
    ErrCode := -1;
    ReadInputFile := 0;
  end;

  procedure TForm1.Button1Click(Sender: TObject);
  { Read data file and initialize scales and titles }
  var
    XMin, XMax, XStep : Float;  { Ox scale }
    YMin, YMax, YStep : Float;  { Oy scale }
  begin
    if not OpenDialog1.Execute then Exit;

    InFName := OpenDialog1.FileName;

    if ReadInputFile(InFName, Title, XName, YName, N, X, Y) = 0 then
      begin
        AutoScale(X, 1, N, LinScale, XMin, XMax, XStep);
        AutoScale(Y, 1, N, LinScale, YMin, YMax, YStep);

        SetOxScale(LinScale, XMin, XMax, XStep);
        SetOyScale(LinScale, YMin, YMax, YStep);

        SetGraphTitle(Title);
        SetOxTitle(XName);
        SetOyTitle(YName);
      end;
  end;

  procedure TForm1.Button2Click(Sender: TObject);
  { Select regression model and retrieve parameters }
  begin
    RegFuncDlg.ShowModal;
    Model := RegFuncDlg.GetModel;
    B := RegFuncDlg.GetParam;
  end;

  procedure WriteResults(InFName  : String;
                         FuncName : String;
                         N        : Integer;
                         X, Y, S  : TVector;
                         Ycalc    : TVector;
                         B        : TVector;
                         V        : TMatrix;
                         FirstPar : Integer;
                         LastPar  : Integer;
                         Test     : TRegTest;
                         Alpha    : Float;
                         Tc, Fc   : Float);
{ ----------------------------------------------------------------------
  Writes the result of the regression to an output file
  ---------------------------------------------------------------------- }
  var
    OutF  : Text;     { Output file }
    Line1,
    Line2 : String;   { Separating lines }
    PName : String;   { Parameter name }
    Delta : Float;    { Residual }
    Sr    : Float;    { Residual standard deviation }
    SB    : Float;    { Standard deviations of parameters }
    I     : Integer;  { Loop variable }

  begin
    I := Pos('.', InFName);
    OutFName := Copy(InFName, 1, Pred(I)) + '.out';
    Assign(OutF, OutFName);
    Rewrite(OutF);

    Line1 := StrChar(73, '-');
    Line2 := StrChar(73, '=');

    Writeln(OutF, Line2);
    Writeln(OutF, 'Curve fit: ', FuncName);
    Writeln(OutF, Line1);

    Writeln(OutF, 'Parameter   Est.value         Std.dev.        ',
           (100 * (1 - Alpha)):2:0, '% Confidence Interval');

    Writeln(OutF, Line1);

    for I := FirstPar to LastPar do
      begin
        PName := ParamName(Model, I);
        SB := Sqrt(V[I,I]);
        Writeln(OutF, PName:4, B[I]:17:8, SB:17:8,
                (B[I] - Tc * SB):17:8, ';', (B[I] + Tc * SB):17:8);
      end;

    Writeln(OutF, Line1);

    Writeln(OutF, 'Number of observations            : n           = ', N:5);

    with Test do
      begin
        Sr := Sqrt(Vr);
        Writeln(OutF, 'Residual error                    : s           = ', Sr:10:4);

        if R2 <= 1.0 then
          begin
            Writeln(OutF, 'Coefficient of correlation        : r           = ', (Sqrt(R2)):10:4);
            Writeln(OutF, 'Coefficient of determination      : r2          = ', R2:10:4);
            Writeln(OutF, 'Adjusted coeff. of determination  : r2a         = ', R2a:10:4);
          end;

        Writeln(OutF, 'Variance ratio (explained/resid.) : F(', Nu1:3, ', ', Nu2:3, ') = ', F:10:4);
        Writeln(OutF, 'Critical variance ratio           : F(p = ', (1 - Alpha):4:2, ') = ', Fc:10:4);
      end;

    Writeln(OutF, Line1);
    Writeln(OutF, '  i        Y obs.       Y calc.      Residual      Std.dev.      Std.res.');
    Writeln(OutF, Line1);

    for I := 1 to N do
      begin
        Delta := Y[I] - Ycalc[I];
        Writeln(OutF, I:3, Y[I]:14:4, Ycalc[I]:14:4, Delta:14:4,
                S[I]:14:4, (Delta / S[I]):14:4);
      end;

    Writeln(OutF, Line2);
    Close(OutF);
  end;

  procedure TForm1.Button3Click(Sender: TObject);
  { Fit model }
  var
    Ycalc   : TVector;  { Expected Y values }
    S       : TVector;  { Standard deviations of Y values }
    V       : TMatrix;  { Variance-covariance matrix of parameters }
    Test    : TRegTest; { Regression tests }
    LastPar : Integer;  { Index of last parameter }
    I       : Integer;  { Loop variable }
    Sr      : Float;    { Residual standard deviation }
    Tc      : Float;    { Critical t value }
    Fc      : Float;    { Critical F value }

  begin
    if N = 0 then Exit;

    { Dimension arrays }
    LastPar := LastParam(Model);
    DimMatrix(V, LastPar, LastPar);
    DimVector(Ycalc, N);
    DimVector(S, N);

    { Perform regression }
    FitModel(Model, X, Y, Ycalc, nil, 1, N, MaxIter, Tol, N * SVDTol, B, V, Test);
    ErrCode := MathErr;

    case ErrCode of
      MatSing    : MessageDlg('Singular matrix', mtError, [mbOk], 0);
      MatNonConv : MessageDlg('Non-convergence', mtError, [mbOk], 0);
    end;

    if ErrCode <> MatOk then Exit;

    { Compute Student's t and Snedecor's F }
    Tc := InvStudent(Test.Nu2, 1 - 0.5 * Alpha);
    Fc := InvSnedecor(Test.Nu1, Test.Nu2, 1 - Alpha);

    { Update standard deviations }
    Sr := Sqrt(Test.Vr);
    for I := 1 to N do
      S[I] := Sr;

    { Write results }
    WriteResults(InFName, FuncName(Model), N, X, Y, S, Ycalc, B, V,
                 FirstParam(Model), LastParam(Model), Test,
                 Alpha, Tc, Fc);
    MessageDlg('Results written to file ' + OutFName,
               mtInformation, [mbOk], 0);
  end;

  procedure TForm1.Button4Click(Sender: TObject);
  { Display results }
  begin
    Form1.Image1.Visible := False;
    Form1.Memo1.Visible := True;

    if OutFName <> '' then
      Form1.Memo1.Lines.LoadFromFile(OutFName);
  end;

  procedure TForm1.Button5Click(Sender: TObject);
  { Select regression model }
  begin
    GraphOptDlg.ShowModal;
  end;

  procedure ClearGraphics;
  begin
    with Form1.Image1 do
      begin
        Canvas.Brush.Color := GraphOptDlg.BorderColorShape.Brush.Color;
        Canvas.FillRect(Rect(0, 0, Width, Height));
        Canvas.Brush.Color := GraphOptDlg.GraphColorShape.Brush.Color;
        Canvas.FillRect(Rect(GraphOptDlg.XminSpinEdit.Value * Width  div 100,
                             GraphOptDlg.YminSpinEdit.Value * Height div 100,
                             GraphOptDlg.XmaxSpinEdit.Value * Width  div 100,
                             GraphOptDlg.YmaxSpinEdit.Value * Height div 100));
      end;
  end;

  function Func(X : Float) : Float;
  { Function to be plotted }
  begin
    Func := umodels.RegFunc(Model, X, B);
  end;

  procedure PlotGraph(Canvas : TCanvas);
  var
    Style : TPenStyle;
    Width : Integer;
    Color : TColor;
    Scale : TScale;

    XMin, XMax, XStep : Float;

  begin
    Canvas.Brush.Color := GraphOptDlg.GraphColorShape.Brush.Color;
    Canvas.Pen.Color := GraphOptDlg.AxisColorShape.Brush.Color;
    Canvas.Pen.Width := GraphOptDlg.AxisWidthSpinEdit.Value;

    SetWindow(Canvas,
              GraphOptDlg.XminSpinEdit.Value,
              GraphOptDlg.XmaxSpinEdit.Value,
              GraphOptDlg.YminSpinEdit.Value,
              GraphOptDlg.YmaxSpinEdit.Value,
              True);

    Canvas.Brush.Color := GraphOptDlg.BorderColorShape.Brush.Color;
    Canvas.Font := GraphOptDlg.AxesFontDialog.Font;

    PlotOxAxis(Canvas);
    PlotOyAxis(Canvas);

    PlotGrid(Canvas, TGrid(GraphOptDlg.GridRadioGroup.ItemIndex));

    Canvas.Font := GraphOptDlg.TitleFontDialog.Font;

    WriteGraphTitle(Canvas);

    GetLineParam(1, Style, Width, Color);
    SetLineParam(1, psClear, Width, Color);  { Don't connect points }

    PlotCurve(Canvas, X, Y, 1, N, 1);

    SetLineParam(1, Style, Width, Color);

    if ErrCode <> 0 then Exit;  { No fitted curve }

    GetOxScale(Scale, XMin, XMax, XStep);
    PlotFunc(Canvas, Func, XMin, XMax, Npts, 1);
  end;

  procedure TForm1.Button6Click(Sender: TObject);
  { Plot graph }
  begin
    if N = 0 then Exit;

    Form1.Image1.Visible := True;
    Form1.Memo1.Visible := False;

    ClearGraphics;

    InitGraphics(Image1.Width, Image1.Height);

    PlotGraph(Image1.Canvas);
  end;

  procedure TForm1.Button7Click(Sender: TObject);
  { Print curve }
  begin
    if N = 0 then Exit;

    Printer.BeginDoc;

    InitGraphics(Printer.PageWidth, Printer.PageHeight);
    SetWindow(Printer.Canvas, 10, 90, 10, 90, True);

    PlotGraph(Printer.Canvas);
    Printer.EndDoc;
  end;

  procedure TForm1.Button8Click(Sender: TObject);
  { Quit program }
  begin
    Form1.Close;
  end;

begin
  N := 0;
  ErrCode := -1;
  Model.RegType := REG_LIN;  { Select linear regression by default }
end.
