object RegFuncDlg: TRegFuncDlg
  Left = 363
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Regression model'
  ClientHeight = 243
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object TabbedNotebook1: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 427
    Height = 243
    Align = alClient
    TabsPerRow = 4
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -12
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    OnClick = TabbedNotebook1Click
    object TTabPage
      Left = 4
      Top = 27
      Caption = '&Lin./Pol./Frac.'
      object RadioGroup1: TRadioGroup
        Left = 8
        Top = 8
        Width = 145
        Height = 105
        Caption = 'Function'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Li&near'
          '&Multiple linear'
          '&Polynomial'
          'Rational &fraction')
        ParentFont = False
        TabOrder = 0
        OnClick = RadioGroup1Click
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 120
        Width = 393
        Height = 81
        Caption = 'Formula'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LabelFunc1: TLabel
          Left = 8
          Top = 16
          Width = 377
          Height = 57
          AutoSize = False
          Caption = 'y = a + b.x'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
      object GroupBoxFrac: TGroupBox
        Left = 160
        Top = 8
        Width = 145
        Height = 105
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Visible = False
        object LabelFrac1: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'Deg. numerat.'
        end
        object LabelFrac2: TLabel
          Left = 8
          Top = 56
          Width = 83
          Height = 13
          Caption = 'Deg. denomin.'
        end
        object SpinEditFrac1: TSpinEdit
          Left = 96
          Top = 16
          Width = 41
          Height = 22
          EditorEnabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 10
          MinValue = 1
          ParentFont = False
          TabOrder = 0
          Value = 1
          OnChange = SpinEditFrac1Change
        end
        object SpinEditFrac2: TSpinEdit
          Left = 96
          Top = 48
          Width = 41
          Height = 22
          EditorEnabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 10
          MinValue = 1
          ParentFont = False
          TabOrder = 1
          Value = 1
          OnChange = SpinEditFrac2Change
        end
        object CheckBoxFrac: TCheckBox
          Left = 8
          Top = 80
          Width = 129
          Height = 17
          Caption = 'Constant term p0'
          TabOrder = 2
          OnClick = CheckBoxFracClick
        end
      end
      object GroupBoxPol: TGroupBox
        Left = 160
        Top = 9
        Width = 145
        Height = 104
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Visible = False
        object LabelPol: TLabel
          Left = 8
          Top = 24
          Width = 42
          Height = 13
          Caption = 'Degree'
        end
        object SpinEditPol: TSpinEdit
          Left = 96
          Top = 16
          Width = 41
          Height = 22
          EditorEnabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 20
          MinValue = 2
          ParentFont = False
          TabOrder = 0
          Value = 2
          OnChange = SpinEditPolChange
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 27
      Caption = '&Expo. etc'
      object RadioGroup2: TRadioGroup
        Left = 8
        Top = 8
        Width = 169
        Height = 121
        Caption = 'Function'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          '&Sum of exponentials'
          'Increasing e&xponential'
          'Exp&onential + linear'
          '&Power function'
          'Logis&tic function'
          '&Gamma distribution')
        ParentFont = False
        TabOrder = 0
        OnClick = RadioGroup2Click
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 136
        Width = 393
        Height = 57
        Caption = 'Formula'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LabelFunc2: TLabel
          Left = 8
          Top = 16
          Width = 377
          Height = 33
          AutoSize = False
          Caption = 'y = A1.exp(- a1.x)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
      object GroupBoxExpo: TGroupBox
        Left = 184
        Top = 8
        Width = 129
        Height = 121
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object LabelExpo: TLabel
          Left = 8
          Top = 24
          Width = 67
          Height = 13
          Caption = 'Nb of expo.'
        end
        object SpinEditExpo: TSpinEdit
          Left = 80
          Top = 16
          Width = 41
          Height = 22
          EditorEnabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 5
          MinValue = 1
          ParentFont = False
          TabOrder = 0
          Value = 1
          OnChange = SpinEditExpoChange
        end
        object CheckBoxExpo: TCheckBox
          Left = 8
          Top = 48
          Width = 113
          Height = 25
          Caption = 'Constant term'
          TabOrder = 1
          OnClick = CheckBoxExpoClick
        end
      end
      object GroupBoxIExpo: TGroupBox
        Left = 184
        Top = 9
        Width = 129
        Height = 120
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Visible = False
        object CheckBoxIExpo: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 25
          Caption = 'Constant term'
          TabOrder = 0
          OnClick = CheckBoxIExpoClick
        end
      end
      object GroupBoxLogis: TGroupBox
        Left = 184
        Top = 8
        Width = 129
        Height = 121
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
        object CheckBoxLogis1: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 25
          Caption = 'Constant term'
          TabOrder = 0
          OnClick = CheckBoxLogis1Click
        end
        object CheckBoxLogis2: TCheckBox
          Left = 8
          Top = 40
          Width = 113
          Height = 25
          Caption = 'Exponent'
          TabOrder = 1
          OnClick = CheckBoxLogis2Click
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 27
      Caption = 'En&zymology'
      object RadioGroup3: TRadioGroup
        Left = 8
        Top = 8
        Width = 225
        Height = 113
        Caption = 'Function'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          '&Michaelis equation'
          'Integrated Michaelis &1 : y = f(t)'
          'Integrated Michaelis &2 : y = f(s0)'
          'Integrated Michaelis &3 : y = f(e0)'
          '&Hill equation')
        ParentFont = False
        TabOrder = 0
        OnClick = RadioGroup3Click
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 128
        Width = 337
        Height = 41
        Caption = 'Formula'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LabelFunc3: TLabel
          Left = 8
          Top = 16
          Width = 313
          Height = 17
          AutoSize = False
          Caption = 'y = Ymax x / (Km + x)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
      object GroupBoxMint: TGroupBox
        Left = 240
        Top = 8
        Width = 73
        Height = 113
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Visible = False
        object LabelS0: TLabel
          Left = 8
          Top = 64
          Width = 14
          Height = 13
          Caption = 's0'
          Visible = False
        end
        object CheckBoxMint: TCheckBox
          Left = 8
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Fit s0'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBoxMintClick
        end
        object EditS0: TEdit
          Left = 32
          Top = 60
          Width = 33
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = '1'
          Visible = False
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 27
      Caption = '&Chemistry'
      object RadioGroup4: TRadioGroup
        Left = 8
        Top = 8
        Width = 209
        Height = 49
        Caption = 'Function'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          '&Acid-base titration')
        ParentFont = False
        TabOrder = 0
        OnClick = RadioGroup4Click
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 64
        Width = 297
        Height = 41
        Caption = 'Formula'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LabelFunc4: TLabel
          Left = 8
          Top = 16
          Width = 281
          Height = 17
          AutoSize = False
          Caption = 'y = A + (B - A) / [1 + 10^(pKa - x)]'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
    end
  end
  object OKBtn: TBitBtn
    Left = 328
    Top = 50
    Width = 77
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = OKBtnClick
    Kind = bkOK
    Margin = 2
    Spacing = -1
  end
  object CancelBtn: TBitBtn
    Left = 328
    Top = 82
    Width = 77
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Kind = bkCancel
    Margin = 2
    Spacing = -1
  end
  object HelpBtn: TBitBtn
    Left = 328
    Top = 114
    Width = 77
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Kind = bkHelp
    Margin = 2
    Spacing = -1
  end
end
