unit RegFunc;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TabNotBk, StdCtrls, Buttons, Spin, ExtCtrls, ComCtrls,
  { DMath units }
  utypes, umodels;

type
  TRegFuncDlg = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    LabelFunc1: TLabel;
    GroupBoxFrac: TGroupBox;
    LabelFrac1: TLabel;
    LabelFrac2: TLabel;
    SpinEditFrac1: TSpinEdit;
    SpinEditFrac2: TSpinEdit;
    CheckBoxFrac: TCheckBox;
    GroupBoxPol: TGroupBox;
    LabelPol: TLabel;
    SpinEditPol: TSpinEdit;
    RadioGroup2: TRadioGroup;
    GroupBox2: TGroupBox;
    LabelFunc2: TLabel;
    RadioGroup3: TRadioGroup;
    GroupBox3: TGroupBox;
    LabelFunc3: TLabel;
    RadioGroup4: TRadioGroup;
    GroupBox4: TGroupBox;
    LabelFunc4: TLabel;
    GroupBoxExpo: TGroupBox;
    LabelExpo: TLabel;
    SpinEditExpo: TSpinEdit;
    CheckBoxExpo: TCheckBox;
    GroupBoxIExpo: TGroupBox;
    CheckBoxIExpo: TCheckBox;
    GroupBoxLogis: TGroupBox;
    CheckBoxLogis1: TCheckBox;
    CheckBoxLogis2: TCheckBox;
    GroupBoxMint: TGroupBox;
    CheckBoxMint: TCheckBox;
    LabelS0: TLabel;
    EditS0: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure TabbedNotebook1Click(Sender: TObject);
    procedure RadioGroup4Click(Sender: TObject);
    procedure SpinEditPolChange(Sender: TObject);
    procedure SpinEditFrac1Change(Sender: TObject);
    procedure SpinEditFrac2Change(Sender: TObject);
    procedure CheckBoxFracClick(Sender: TObject);
    procedure SpinEditExpoChange(Sender: TObject);
    procedure CheckBoxExpoClick(Sender: TObject);
    procedure CheckBoxIExpoClick(Sender: TObject);
    procedure CheckBoxLogis1Click(Sender: TObject);
    procedure CheckBoxLogis2Click(Sender: TObject);
    procedure CheckBoxMintClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SetRegMult(RegMult : Boolean);
    function  GetModel: TModel;
    function  GetParam: TVector;
    procedure SetParam(I : Integer; B : Float);
  private
    procedure SetModel;
  end;

var
  RegFuncDlg : TRegFuncDlg;

implementation

{$R *.DFM}

uses
  unlfit, uwinstr;

var
  AllowRegMult : Boolean;
  Model        : TModel;
  Param        : TVector;

procedure TRegFuncDlg.SetRegMult(RegMult : Boolean);
begin
  AllowRegMult := RegMult;
end;

function TRegFuncDlg.GetModel: TModel;
begin
  GetModel := Model;
end;

function TRegFuncDlg.GetParam: TVector;
begin
  GetParam := Param;
end;

procedure TRegFuncDlg.SetParam(I : Integer; B : Float);
begin
  if (I >= FirstParam(Model)) and (I <= LastParam(Model)) then
    Param[I] := B;
end;

procedure TRegFuncDlg.FormCreate(Sender: TObject);
begin
  if not AllowRegMult then
    RadioGroup1.Items.Delete(1);
end;

procedure TRegFuncDlg.SetModel;
{ Define model and write formula }
var
  Index : Integer;
begin
  with Model do
  case TabbedNotebook1.PageIndex of
    0 : begin
          Index := RadioGroup1.ItemIndex;
          if (not AllowRegMult) and (Index > 0) then Inc(Index);
          case Index of
          0 : RegType := REG_LIN;
          1 : begin
                RegType := REG_MULT;
                Mult_ConsTerm := True;
                { Nvar :=  }
              end;
          2 : begin
                RegType := REG_POL;
                Deg := SpinEditPol.Value;
              end;
          3 : begin
                RegType := REG_FRAC;
                Frac_ConsTerm := CheckBoxFrac.Checked;
                Deg1 := SpinEditFrac1.Value;
                Deg2 := SpinEditFrac2.Value;
              end;
          end;
        end;
    1 : case RadioGroup2.ItemIndex of
          0 : begin
                RegType := REG_EXPO;
                Expo_ConsTerm := CheckBoxExpo.Checked;
                Nexp := SpinEditExpo.Value;
              end;
          1 : begin
                RegType := REG_IEXPO;
                IExpo_ConsTerm := CheckBoxIExpo.Checked;
              end;
          2 : RegType := REG_EXLIN;
          3 : RegType := REG_POWER;
          4 : begin
                RegType := REG_LOGIS;
                Logis_ConsTerm := CheckBoxLogis1.Checked;
                Logis_General := CheckBoxLogis2.Checked;
              end;
          5 : RegType := REG_GAMMA;
        end;
    2 : case RadioGroup3.ItemIndex of
          0 : RegType := REG_MICH;
          1 : begin
                RegType := REG_MINT;
                MintVar := Var_T;
                Fit_S0  := CheckBoxMint.Checked;
              end;
          2 : begin
                RegType := REG_MINT;
                MintVar := Var_S;
              end;
          3 : begin
                RegType := REG_MINT;
                MintVar := Var_E;
                Fit_S0  := CheckBoxMint.Checked;
              end;
          4 : RegType := REG_HILL;
        end;
    3 : case RadioGroup4.ItemIndex of
          0 : RegType := REG_PK ;
        end;
  end;

  case TabbedNotebook1.PageIndex of
    0 : LabelFunc1.Caption := FuncName(Model);
    1 : LabelFunc2.Caption := FuncName(Model);
    2 : LabelFunc3.Caption := FuncName(Model);
    3 : LabelFunc4.Caption := FuncName(Model);
  end;
end;

procedure TRegFuncDlg.TabbedNotebook1Click(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.RadioGroup1Click(Sender: TObject);
var
  Index : Integer;
begin
  Index := RadioGroup1.ItemIndex;
  if (not AllowRegMult) and (Index > 0) then Inc(Index);

  GroupBoxPol.Visible  := (Index = 2);
  GroupBoxFrac.Visible := (Index = 3);
  SetModel;
end;

procedure TRegFuncDlg.RadioGroup2Click(Sender: TObject);
begin
  GroupBoxExpo.Visible  := (RadioGroup2.ItemIndex = 0);
  GroupBoxIExpo.Visible := (RadioGroup2.ItemIndex = 1);
  GroupBoxLogis.Visible := (RadioGroup2.ItemIndex = 4);
  SetModel;
end;

procedure TRegFuncDlg.RadioGroup3Click(Sender: TObject);
begin
  GroupBoxMint.Visible := (RadioGroup3.ItemIndex in [1,3]);
  SetModel;
end;

procedure TRegFuncDlg.RadioGroup4Click(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.SpinEditPolChange(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.SpinEditFrac1Change(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.SpinEditFrac2Change(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxFracClick(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.SpinEditExpoChange(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxExpoClick(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxIExpoClick(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxLogis1Click(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxLogis2Click(Sender: TObject);
begin
  SetModel;
end;

procedure TRegFuncDlg.CheckBoxMintClick(Sender: TObject);
begin
  LabelS0.Visible := not CheckBoxMint.Checked;
  EditS0.Visible := LabelS0.Visible;
  SetModel;
end;

procedure TRegFuncDlg.OKBtnClick(Sender: TObject);
var
  I, LastPar : Integer;
begin
  SetModel;

  LastPar := LastParam(Model);
  SetMaxParam(LastPar);

  { Initialize parameters and bounds }
  DimVector(Param, LastPar);
  for I := 0 to LastPar do
    begin
      Param[I] := 0.0;
      SetParamBounds(I, -1.0E+6, 1.0E+6);
    end;

  { Integrated Michaelis function: Set S0 if not fitted }
  if (Model.RegType = REG_MINT) and (Model.Fit_S0 = False) then
    Param[0] := ReadNumFromEdit(EditS0);
end;

begin
  Model.RegType := REG_LIN;
end.
