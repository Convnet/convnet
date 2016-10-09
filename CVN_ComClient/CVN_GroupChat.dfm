object groupChatForm: TgroupChatForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'groupChatForm'
  ClientHeight = 289
  ClientWidth = 580
  Color = 16577775
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object chattext: TRichEdit
    Left = 0
    Top = 0
    Width = 580
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
    Zoom = 100
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
    Zoom = 100
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
    Caption = #21457#36865
    Color = clInactiveCaptionText
    HotTrack = True
    TabOrder = 2
    OnClick = bSendChatTextClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 270
    Width = 580
    Height = 19
    Color = 16112329
    Panels = <
      item
        Width = 50
      end>
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 520
    Top = 72
  end
end
