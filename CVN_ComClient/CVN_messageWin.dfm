object FCVNMSG: TFCVNMSG
  Left = 518
  Top = 376
  Width = 326
  Height = 117
  Caption = #28040#24687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 273
    Height = 13
    AutoSize = False
  end
  object bSure: TButton
    Left = 112
    Top = 46
    Width = 75
    Height = 23
    Cancel = True
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = bSureClick
  end
end
