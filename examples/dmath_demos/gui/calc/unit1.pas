unit Unit1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Button60: TButton;
    Button61: TButton;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button0: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button14: TButton;
    Button21: TButton;
    Button15: TButton;
    Button22: TButton;
    Button16: TButton;
    Button23: TButton;
    Button17: TButton;
    Button24: TButton;
    Button18: TButton;
    Button25: TButton;
    Button19: TButton;
    Button26: TButton;
    Button20: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button36: TButton;
    Button43: TButton;
    Button49: TButton;
    Button30: TButton;
    Button37: TButton;
    Button44: TButton;
    Button50: TButton;
    Button31: TButton;
    Button38: TButton;
    Button45: TButton;
    Button51: TButton;
    Button32: TButton;
    Button39: TButton;
    Button46: TButton;
    Button52: TButton;
    Button33: TButton;
    Button40: TButton;
    Button47: TButton;
    Button53: TButton;
    Button34: TButton;
    Button41: TButton;
    Button48: TButton;
    Button54: TButton;
    Button35: TButton;
    Button42: TButton;
    Button13: TButton;
    procedure Button60Click(Sender: TObject);
    procedure Button61Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button0Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
    procedure Button45Click(Sender: TObject);
    procedure Button46Click(Sender: TObject);
    procedure Button47Click(Sender: TObject);
    procedure Button48Click(Sender: TObject);
    procedure Button49Click(Sender: TObject);
    procedure Button50Click(Sender: TObject);
    procedure Button51Click(Sender: TObject);
    procedure Button52Click(Sender: TObject);
    procedure Button53Click(Sender: TObject);
    procedure Button54Click(Sender: TObject);
  private
    { Private-déclarations }
  public
    { Public-déclarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  utypes, ueval;

procedure TForm1.Button60Click(Sender: TObject);
begin
  InitEval;

  SetVariable('A', StrToFloat(Edit1.Text));
  SetVariable('B', StrToFloat(Edit2.Text));
  SetVariable('C', StrToFloat(Edit3.Text));
  SetVariable('D', StrToFloat(Edit4.Text));

  Edit6.Text := FloatToStr(Eval(Edit5.Text));
end;

procedure TForm1.Button61Click(Sender: TObject);
begin
  Edit5.Text := '';
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '7';
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '8';
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '9';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '4';
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '5';
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '6';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '1';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '2';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '3';
end;

procedure TForm1.Button0Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '0';
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '.';
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '(';
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + ')';
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Edit5.Text := Copy(Edit5.Text, 1, Length(Edit5.Text) - 1);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '+';
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '-';
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '*';
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '/';
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '\';
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '%';
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '^';
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '!';
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '&';
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '|';
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '$';
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '=';
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '@';
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '<';
end;

procedure TForm1.Button28Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + '>';
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'abs(';
end;

procedure TForm1.Button30Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'sgn(';
end;

procedure TForm1.Button31Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'int(';
end;

procedure TForm1.Button32Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'sqrt(';
end;

procedure TForm1.Button33Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'exp(';
end;

procedure TForm1.Button34Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'ln(';
end;

procedure TForm1.Button35Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'log10(';
end;

procedure TForm1.Button36Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'sin(';
end;

procedure TForm1.Button37Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'cos(';
end;

procedure TForm1.Button38Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'tan(';
end;

procedure TForm1.Button39Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arcsin(';
end;

procedure TForm1.Button40Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arccos(';
end;

procedure TForm1.Button41Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arctan(';
end;

procedure TForm1.Button42Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arctan2(';
end;

procedure TForm1.Button43Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'sinh(';
end;

procedure TForm1.Button44Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'cosh(';
end;

procedure TForm1.Button45Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'tanh(';
end;

procedure TForm1.Button46Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arcsinh(';
end;

procedure TForm1.Button47Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arccosh(';
end;

procedure TForm1.Button48Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'arctanh(';
end;

procedure TForm1.Button49Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'deg(';
end;

procedure TForm1.Button50Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'rad(';
end;

procedure TForm1.Button51Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'rnd()';
end;

procedure TForm1.Button52Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'fact(';
end;

procedure TForm1.Button53Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'gamma(';
end;

procedure TForm1.Button54Click(Sender: TObject);
begin
  Edit5.Text := Edit5.Text + 'erf(';
end;

end.
