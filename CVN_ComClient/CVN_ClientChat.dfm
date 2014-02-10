object chatform: Tchatform
  Left = 380
  Top = 338
  BorderStyle = bsToolWindow
  Caption = 'chatform'
  ClientHeight = 287
  ClientWidth = 582
  Color = 16577775
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 268
    Width = 582
    Height = 19
    Color = 16112329
    Panels = <
      item
        Width = 50
      end>
  end
  object Edit1: TRzRichEdit
    Left = 3
    Top = 229
    Width = 512
    Height = 36
    Align = alCustom
    Color = 16444386
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = '??????? 2'
    ParentFont = False
    TabOrder = 1
    OnKeyPress = Edit1KeyPress
    DisabledColor = clActiveBorder
    FocusColor = 16444898
    FrameColor = 9786394
    FrameHotColor = clMedGray
    FrameHotStyle = fsFlat
    FrameVisible = True
    ReadOnlyColor = clInactiveCaptionText
  end
  object bSendChatText: TRzBitBtn
    Left = 517
    Top = 228
    Width = 63
    Height = 38
    FrameColor = 7617536
    Caption = '??'
    Color = clInactiveCaptionText
    HotTrack = True
    TabOrder = 2
    OnClick = bSendChatTextClick
  end
  object chattext: TRichEdit
    Left = 0
    Top = 0
    Width = 582
    Height = 224
    Align = alTop
    BorderStyle = bsNone
    Color = 16644082
    Ctl3D = True
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HideScrollBars = False
    ImeName = '??????? 2'
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 520
    Top = 72
  end
end
