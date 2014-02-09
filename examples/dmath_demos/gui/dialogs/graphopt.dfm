object GraphOptDlg: TGraphOptDlg
  Left = 510
  Top = 310
  BorderStyle = bsDialog
  Caption = 'Graph options'
  ClientHeight = 274
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object TabbedNotebook1: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 427
    Height = 274
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    TabsPerRow = 4
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -12
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    object TTabPage
      Left = 4
      Top = 24
      Caption = '&Aspect'
      object LimitGroupBox: TGroupBox
        Left = 8
        Top = 8
        Width = 249
        Height = 81
        Caption = 'Graph &limits in % of maximum'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 24
          Width = 23
          Height = 13
          Caption = 'Xmin'
        end
        object Label2: TLabel
          Left = 8
          Top = 56
          Width = 26
          Height = 13
          Caption = 'Xmax'
        end
        object Label3: TLabel
          Left = 152
          Top = 24
          Width = 23
          Height = 13
          Caption = 'Ymin'
        end
        object Label4: TLabel
          Left = 152
          Top = 56
          Width = 26
          Height = 13
          Caption = 'Ymax'
        end
        object XminSpinEdit: TSpinEdit
          Left = 48
          Top = 19
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 0
          Value = 15
        end
        object XmaxSpinEdit: TSpinEdit
          Left = 48
          Top = 51
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 1
          Value = 85
        end
        object YminSpinEdit: TSpinEdit
          Left = 192
          Top = 19
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 15
        end
        object YmaxSpinEdit: TSpinEdit
          Left = 192
          Top = 51
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 3
          Value = 80
        end
      end
      object ColorGroupBox: TGroupBox
        Left = 8
        Top = 96
        Width = 249
        Height = 49
        Caption = 'Colors'
        TabOrder = 1
        object BorderColorShape: TShape
          Left = 88
          Top = 16
          Width = 25
          Height = 25
          Shape = stRoundRect
        end
        object GraphColorShape: TShape
          Left = 216
          Top = 16
          Width = 25
          Height = 25
          Shape = stRoundRect
        end
        object BorderColorBtn: TButton
          Left = 8
          Top = 16
          Width = 73
          Height = 25
          Caption = '&Border'
          TabOrder = 0
          OnClick = BorderColorBtnClick
        end
        object GraphColorBtn: TButton
          Left = 136
          Top = 16
          Width = 73
          Height = 25
          Caption = '&Graph'
          TabOrder = 1
          OnClick = GraphColorBtnClick
        end
      end
      object FrameGroupBox: TGroupBox
        Left = 8
        Top = 152
        Width = 121
        Height = 81
        Caption = 'Plot'
        TabOrder = 2
        object GraphBorderCheckBox: TCheckBox
          Left = 8
          Top = 24
          Width = 65
          Height = 17
          Caption = 'B&order'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object LgdBorderCheckBox: TCheckBox
          Left = 8
          Top = 48
          Width = 73
          Height = 17
          Caption = 'L&egend'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object GridRadioGroup: TRadioGroup
        Left = 136
        Top = 152
        Width = 121
        Height = 81
        Caption = 'Grid'
        ItemIndex = 3
        Items.Strings = (
          '&No grid'
          '&Horizontal'
          '&Vertical'
          'Both g&rids')
        TabOrder = 3
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'A&xes'
      object XAxisGroupBox: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 161
        Caption = '&Horizontal axis (Ox)'
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 80
          Width = 20
          Height = 13
          Caption = 'Min.'
        end
        object Label6: TLabel
          Left = 8
          Top = 104
          Width = 23
          Height = 13
          Caption = 'Max.'
        end
        object Label7: TLabel
          Left = 8
          Top = 128
          Width = 22
          Height = 13
          Caption = 'Step'
        end
        object Label19: TLabel
          Left = 48
          Top = 80
          Width = 18
          Height = 13
          Caption = '10^'
          Visible = False
        end
        object Label20: TLabel
          Left = 48
          Top = 104
          Width = 18
          Height = 13
          Caption = '10^'
          Visible = False
        end
        object XPlotCheckBox: TCheckBox
          Left = 8
          Top = 24
          Width = 89
          Height = 17
          Caption = 'Plot axis'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object XScaleCheckBox: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Log scale'
          TabOrder = 1
          OnClick = XScaleCheckBoxClick
        end
        object XMinEdit: TEdit
          Left = 48
          Top = 80
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          Text = '0'
        end
        object XMaxEdit: TEdit
          Left = 48
          Top = 104
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = '1'
        end
        object XStepEdit: TEdit
          Left = 48
          Top = 128
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = '0.2'
        end
        object XMinLogSpinEdit: TSpinEdit
          Left = 72
          Top = 75
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 50
          MinValue = -50
          ParentFont = False
          TabOrder = 5
          Value = 0
          Visible = False
        end
        object XMaxLogSpinEdit: TSpinEdit
          Left = 72
          Top = 99
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 50
          MinValue = -50
          ParentFont = False
          TabOrder = 6
          Value = 1
          Visible = False
        end
      end
      object YAxisGroupBox: TGroupBox
        Left = 152
        Top = 8
        Width = 129
        Height = 161
        Caption = '&Vertical axis (Oy)'
        TabOrder = 1
        object Label8: TLabel
          Left = 8
          Top = 80
          Width = 20
          Height = 13
          Caption = 'Min.'
        end
        object Label9: TLabel
          Left = 8
          Top = 104
          Width = 23
          Height = 13
          Caption = 'Max.'
        end
        object Label10: TLabel
          Left = 8
          Top = 128
          Width = 22
          Height = 13
          Caption = 'Step'
        end
        object Label21: TLabel
          Left = 48
          Top = 80
          Width = 18
          Height = 13
          Caption = '10^'
          Visible = False
        end
        object Label22: TLabel
          Left = 48
          Top = 104
          Width = 18
          Height = 13
          Caption = '10^'
          Visible = False
        end
        object YPlotCheckBox: TCheckBox
          Left = 8
          Top = 24
          Width = 89
          Height = 17
          Caption = 'Plot axis'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object YScaleCheckBox: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Log scale'
          TabOrder = 1
          OnClick = YScaleCheckBoxClick
        end
        object YMinEdit: TEdit
          Left = 48
          Top = 80
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          Text = '0'
        end
        object YMaxEdit: TEdit
          Left = 48
          Top = 104
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = '1'
        end
        object YStepEdit: TEdit
          Left = 48
          Top = 128
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = '0.2'
        end
        object YMinLogSpinEdit: TSpinEdit
          Left = 72
          Top = 75
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 50
          MinValue = -50
          ParentFont = False
          TabOrder = 5
          Value = 0
          Visible = False
        end
        object YMaxLogSpinEdit: TSpinEdit
          Left = 72
          Top = 99
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 50
          MinValue = -50
          ParentFont = False
          TabOrder = 6
          Value = 1
          Visible = False
        end
      end
      object AxisGroupBox: TGroupBox
        Left = 8
        Top = 176
        Width = 273
        Height = 57
        Caption = '&Line'
        TabOrder = 2
        object AxisColorShape: TShape
          Left = 88
          Top = 24
          Width = 25
          Height = 25
          Brush.Color = clBlack
          Shape = stRoundRect
        end
        object Label11: TLabel
          Left = 160
          Top = 32
          Width = 28
          Height = 13
          Caption = 'Width'
        end
        object AxisWidthSpinEdit: TSpinEdit
          Left = 224
          Top = 27
          Width = 41
          Height = 22
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
        end
        object AxisColorBtn: TButton
          Left = 8
          Top = 24
          Width = 73
          Height = 25
          Caption = 'Color'
          TabOrder = 0
          OnClick = AxisColorBtnClick
        end
      end
      object ForceOriginGroupBox: TGroupBox
        Left = 288
        Top = 176
        Width = 121
        Height = 57
        Caption = '&Force origin at'
        TabOrder = 3
        object ForceOriginCheckBox: TCheckBox
          Left = 8
          Top = 24
          Width = 57
          Height = 17
          Caption = ' (0,0)'
          TabOrder = 0
          OnClick = ForceOriginCheckBoxClick
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = '&Curves'
      object Label18: TLabel
        Left = 288
        Top = 192
        Width = 129
        Height = 49
        Alignment = taCenter
        AutoSize = False
        Caption = 'Click an '#39'Apply'#39' button to make the changes active!'
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
      object PointGroupBox: TGroupBox
        Left = 8
        Top = 64
        Width = 129
        Height = 121
        Caption = 'Sy&mbol'
        TabOrder = 2
        object PointColorShape: TShape
          Left = 96
          Top = 56
          Width = 25
          Height = 25
          Brush.Color = clRed
          Shape = stRoundSquare
        end
        object Label14: TLabel
          Left = 8
          Top = 92
          Width = 20
          Height = 13
          Caption = 'Size'
        end
        object PointComboBox: TComboBox
          Left = 8
          Top = 24
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'Point'
            'Full circle'
            'Open circle'
            'Full square'
            'Open square'
            'Full triangle'
            'Open triangle'
            'Plus (+)'
            'Cross (x)'
            'Star (*)')
        end
        object PointColorBtn: TButton
          Left = 8
          Top = 56
          Width = 81
          Height = 25
          Caption = 'Color'
          TabOrder = 1
          OnClick = PointColorBtnClick
        end
        object PointSizeSpinEdit: TSpinEdit
          Left = 72
          Top = 87
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 1
        end
      end
      object LineGroupBox: TGroupBox
        Left = 152
        Top = 64
        Width = 129
        Height = 121
        Caption = '&Line'
        TabOrder = 3
        object LineColorShape: TShape
          Left = 96
          Top = 56
          Width = 25
          Height = 25
          Brush.Color = clRed
          Shape = stRoundSquare
        end
        object Label15: TLabel
          Left = 9
          Top = 92
          Width = 28
          Height = 13
          Caption = 'Width'
        end
        object LineComboBox: TComboBox
          Left = 8
          Top = 24
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            '___________'
            '_ _ _ _ _ _ _'
            '...................'
            '_._._._._._._.'
            '_.._.._.._.._..'
            '(None)')
        end
        object LineColorBtn: TButton
          Left = 8
          Top = 56
          Width = 81
          Height = 25
          Caption = 'Color'
          TabOrder = 1
          OnClick = LineColorBtnClick
        end
        object LineWidthSpinEdit: TSpinEdit
          Left = 72
          Top = 87
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 1
        end
      end
      object StepGroupBox: TGroupBox
        Left = 152
        Top = 8
        Width = 129
        Height = 49
        Caption = '&Plot'
        TabOrder = 1
        object Label12: TLabel
          Left = 8
          Top = 24
          Width = 47
          Height = 13
          Caption = '1 pt every'
        end
        object StepSpinEdit: TSpinEdit
          Left = 80
          Top = 19
          Width = 41
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 100
          MinValue = 1
          ParentFont = False
          TabOrder = 0
          Value = 1
        end
      end
      object CurvGroupBox: TGroupBox
        Left = 8
        Top = 192
        Width = 273
        Height = 49
        Caption = 'Apply to'
        TabOrder = 4
        object ApplyBtn1: TButton
          Left = 8
          Top = 16
          Width = 121
          Height = 25
          Caption = 'the selected curve'
          TabOrder = 0
          OnClick = ApplyBtn1Click
        end
        object ApplyBtn2: TButton
          Left = 144
          Top = 16
          Width = 121
          Height = 25
          Caption = 'all curves'
          TabOrder = 1
          OnClick = ApplyBtn2Click
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 49
        Caption = '&Select curve'
        TabOrder = 0
        object CurvParamComboBox: TComboBox
          Left = 8
          Top = 21
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = CurvParamComboBoxChange
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = '&Titles etc.'
      object TitleGroupBox: TGroupBox
        Left = 8
        Top = 8
        Width = 265
        Height = 105
        Caption = 'T&itles'
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Graph'
        end
        object Label16: TLabel
          Left = 8
          Top = 48
          Width = 34
          Height = 13
          Caption = 'Ox axis'
        end
        object Label17: TLabel
          Left = 8
          Top = 72
          Width = 34
          Height = 13
          Caption = 'Oy axis'
        end
        object GraphTitleEdit: TEdit
          Left = 56
          Top = 24
          Width = 201
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object XTitleEdit: TEdit
          Left = 56
          Top = 48
          Width = 201
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = 'X'
        end
        object YTitleEdit: TEdit
          Left = 56
          Top = 72
          Width = 201
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          Text = 'Y'
        end
      end
      object FontGroupBox: TGroupBox
        Left = 8
        Top = 120
        Width = 129
        Height = 113
        Caption = 'Fonts'
        TabOrder = 1
        object TitleFontBtn: TButton
          Left = 16
          Top = 16
          Width = 97
          Height = 25
          Caption = '&Graph title'
          TabOrder = 0
          OnClick = TitleFontBtnClick
        end
        object AxesfontBtn: TButton
          Left = 16
          Top = 48
          Width = 97
          Height = 25
          Caption = 'Ax&es'
          TabOrder = 1
          OnClick = AxesfontBtnClick
        end
        object LgdFontBtn: TButton
          Left = 16
          Top = 80
          Width = 97
          Height = 25
          Caption = '&Legend'
          TabOrder = 2
          OnClick = LgdFontBtnClick
        end
      end
      object ConfigGroupBox: TGroupBox
        Left = 144
        Top = 120
        Width = 129
        Height = 113
        Caption = 'Configuration file'
        TabOrder = 2
        object ConfigReadBtn: TButton
          Left = 16
          Top = 16
          Width = 97
          Height = 25
          Caption = '&Open'
          TabOrder = 0
          OnClick = ConfigReadBtnClick
        end
        object ConfigSaveBtn: TButton
          Left = 16
          Top = 48
          Width = 97
          Height = 25
          Caption = '&Save'
          TabOrder = 1
          OnClick = ConfigSaveBtnClick
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
  object LgdFontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    Left = 357
    Top = 114
  end
  object AxesFontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    Left = 325
    Top = 114
  end
  object TitleFontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Left = 293
    Top = 114
  end
  object GraphColorDialog: TColorDialog
    Left = 325
    Top = 146
  end
  object PointColorDialog: TColorDialog
    Left = 389
    Top = 114
  end
  object LineColorDialog: TColorDialog
    Left = 389
    Top = 146
  end
  object BorderColorDialog: TColorDialog
    Left = 293
    Top = 146
  end
  object ConfigReadDialog: TOpenDialog
    Filter = 'Graph configuration|*.GCF|All files|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Left = 293
    Top = 50
  end
  object ConfigSaveDialog: TSaveDialog
    Filter = 'Graph configuration|*.GCF|All files|*.*'
    Options = [ofOverwritePrompt]
    Left = 293
    Top = 82
  end
  object AxisColorDialog: TColorDialog
    Left = 357
    Top = 146
  end
end
