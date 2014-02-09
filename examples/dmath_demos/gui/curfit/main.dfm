object Form1: TForm1
  Left = 161
  Top = 101
  Width = 761
  Height = 580
  Caption = 'Curve fit'
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 128
    Top = 0
    Width = 625
    Height = 553
  end
  object Button1: TButton
    Left = 8
    Top = 128
    Width = 105
    Height = 25
    Caption = '&Read data file'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 168
    Width = 105
    Height = 25
    Caption = '&Select model'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 208
    Width = 105
    Height = 25
    Caption = '&Fit model'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 248
    Width = 105
    Height = 25
    Caption = '&View Results'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 288
    Width = 105
    Height = 25
    Caption = 'Graph &options'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 328
    Width = 105
    Height = 25
    Caption = '&Plot Graph'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 8
    Top = 368
    Width = 105
    Height = 25
    Caption = 'P&rint Graph'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 8
    Top = 408
    Width = 105
    Height = 25
    Caption = '&Quit'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Memo1: TMemo
    Left = 128
    Top = 0
    Width = 625
    Height = 553
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Data files|*.dat'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 48
    Top = 512
  end
end
