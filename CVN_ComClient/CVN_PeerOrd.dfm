object fPeerOrd: TfPeerOrd
  Left = 259
  Top = 138
  BorderStyle = bsToolWindow
  Caption = #30003#35831#30830#35748
  ClientHeight = 166
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object msgTxt: TRzLabel
    Left = 8
    Top = 48
    Width = 417
    Height = 65
    Align = alCustom
    AutoSize = False
    Caption = #28040#24687#20869#23481
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object luserNickname: TRzLabel
    Left = 8
    Top = 16
    Width = 417
    Height = 17
    Align = alCustom
    AutoSize = False
    Caption = #29992#25143#21517#31216#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object bSureAdd: TRzBitBtn
    Left = 72
    Top = 128
    Width = 105
    FrameColor = 7617536
    Caption = #21516#24847#21152#20837
    Color = 15791348
    HotTrack = True
    TabOrder = 0
    OnClick = bSureAddClick
  end
  object bRefusejoin: TRzBitBtn
    Left = 248
    Top = 128
    Width = 99
    Cancel = True
    FrameColor = 7617536
    Caption = #25298#32477#35831#27714
    Color = 15791348
    HotTrack = True
    TabOrder = 1
    OnClick = bRefusejoinClick
  end
end
