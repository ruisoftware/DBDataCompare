object frmWait: TfrmWait
  Left = 424
  Top = 313
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Please Wait...'
  ClientHeight = 32
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 263
    Height = 32
    Align = alClient
    Alignment = taLeftJustify
    Caption = '  Please Wait...'
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 79
      Top = 13
      Width = 169
      Height = 9
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
end
