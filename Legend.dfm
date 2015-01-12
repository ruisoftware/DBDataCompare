object frmLegend: TfrmLegend
  Left = 717
  Top = 348
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Legend'
  ClientHeight = 96
  ClientWidth = 122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel5: TPanel
    Left = 8
    Top = 11
    Width = 105
    Height = 20
    BevelOuter = bvLowered
    Caption = 'Both Fields Match'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Panel6: TPanel
    Left = 8
    Top = 40
    Width = 105
    Height = 20
    BevelOuter = bvLowered
    Caption = 'Fields Don'#39't Match'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsStrikeOut]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 69
    Width = 105
    Height = 20
    BevelOuter = bvLowered
    Caption = 'Orphan'
    Color = 15724527
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsStrikeOut]
    ParentFont = False
    TabOrder = 2
  end
end
