object OpBox: TOpBox
  Left = 129
  Top = 114
  Width = 1415
  Height = 939
  Caption = 'BigFloat (Version 2.0)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBtnText
  Font.Height = -17
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 20
  object Label1: TLabel
    Left = 37
    Top = 74
    Width = 54
    Height = 20
    Caption = 'Normal'
  end
  object Label2: TLabel
    Left = 37
    Top = 98
    Width = 69
    Height = 20
    Caption = 'Scientific'
  end
  object Label3: TLabel
    Left = 37
    Top = 209
    Width = 54
    Height = 20
    Caption = 'Normal'
  end
  object Label4: TLabel
    Left = 37
    Top = 246
    Width = 69
    Height = 20
    Caption = 'Scientific'
  end
  object Label5: TLabel
    Left = 25
    Top = 443
    Width = 54
    Height = 20
    Caption = 'Normal'
  end
  object Label6: TLabel
    Left = 12
    Top = 554
    Width = 69
    Height = 20
    Caption = 'Scientific'
  end
  object Result: TLabel
    Left = 25
    Top = 406
    Width = 75
    Height = 29
    Caption = 'Result'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 12
    Top = 37
    Width = 19
    Height = 29
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 12
    Top = 172
    Width = 18
    Height = 29
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 287
    Top = 332
    Width = 223
    Height = 39
    AutoSize = False
    Caption = 'Max digits to display'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label10: TLabel
    Left = 751
    Top = 37
    Width = 117
    Height = 29
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StopBtn: TButton
    Left = 25
    Top = 332
    Width = 137
    Height = 39
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    Visible = False
    OnClick = StopBtnClick
  end
  object Edit1: TEdit
    Left = 37
    Top = 37
    Width = 666
    Height = 28
    TabOrder = 0
    Text = '4.91234567891e-5'
  end
  object Edit2: TEdit
    Left = 37
    Top = 172
    Width = 666
    Height = 28
    TabOrder = 1
    Text = '41'
  end
  object TestBtn: TButton
    Left = 25
    Top = 320
    Width = 137
    Height = 38
    Caption = 'Do it'
    TabOrder = 2
    OnClick = TestBtnClick
  end
  object N1NormLbl: TStaticText
    Left = 123
    Top = 74
    Width = 31
    Height = 24
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
  end
  object N1SciLbl: TStaticText
    Left = 123
    Top = 98
    Width = 31
    Height = 24
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
  end
  object N2NormLbl: TStaticText
    Left = 135
    Top = 209
    Width = 31
    Height = 24
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
  end
  object N2SciLbl: TStaticText
    Left = 135
    Top = 246
    Width = 31
    Height = 24
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
  end
  object Maxdigits: TSpinEdit
    Left = 517
    Top = 332
    Width = 88
    Height = 40
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 1000
    MinValue = 2
    ParentFont = False
    TabOrder = 7
    Value = 30
  end
  object Memo1: TMemo
    Left = 751
    Top = 517
    Width = 490
    Height = 297
    Color = 14548991
    Lines.Strings = (
      'This is an investigaton of algorithms to manipulate  large '
      'floating point numbers.   '
      ''
      'Internally,  additions and subtractions shift number to align '
      'virtual decimal points and the use "big integer" arithmetic to '
      'perform the  operation.'
      ''
      'Multiplications simply multiply the numbers as if they were big '
      'integers and then add the exponent values.'
      ''
      'Divide makes successive  guesses for quotient and compares '
      
        'quotient X divisor to the input dividend. until the difference i' +
        's '
      'less than the number of significant digits to be displayed .   ')
    TabOrder = 8
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 851
    Width = 1393
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2003-2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
  object OpList: TListBox
    Left = 738
    Top = 74
    Width = 507
    Height = 420
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 25
    Items.Strings = (
      'X + Y'
      'X - Y'
      'X * Y'
      'X / Y'
      'X^2'
      'Sqrt(X)'
      '1/X {Reciprocal}'
      'Yth Power X^Y   {Y integer}'
      'Yth Root  (X^1/Y)  {Y integer}'
      'Compare X to Y'
      'X^Y {Y floating point}'
      'Log(X) {Natural log}'
      'Log10(X)'
      'Exp(X)'
      'Pi'
      'X RoundToPrec(Y) {Y= signif. digits}'
      'X Round(Y) {Y = pos relative to dec. pt.}'
      'X Trunc(Y) {Y = pos relative to dec. pt.}'
      'X Floor(Y) {Y = pos relative to dec. pt.}'
      'X Ceiling(Y){Y = pos relative to dec. pt.}'
      ' ')
    ParentFont = False
    TabOrder = 11
    OnDblClick = OpListDblClick
  end
  object ResultN: TMemo
    Left = 86
    Top = 443
    Width = 619
    Height = 100
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object ResultS: TMemo
    Left = 86
    Top = 554
    Width = 619
    Height = 100
    ScrollBars = ssVertical
    TabOrder = 13
  end
  object MoveBtn: TButton
    Left = 86
    Top = 677
    Width = 162
    Height = 38
    Caption = 'Move result to X'
    Enabled = False
    TabOrder = 14
    OnClick = MoveBtnClick
  end
end
