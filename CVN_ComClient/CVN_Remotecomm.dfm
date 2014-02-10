object RmComm: TRmComm
  Left = 256
  Top = 306
  Width = 224
  Height = 170
  Caption = 'RmComm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Timer3: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = Timer3Timer
    Left = 112
    Top = 32
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 48
    Top = 32
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 30
    OnTimer = Timer2Timer
    Left = 80
    Top = 32
  end
  object Timer4: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer4Timer
    Left = 144
    Top = 32
  end
end
