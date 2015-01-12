object Form1: TForm1
  Left = 228
  Top = 208
  Width = 733
  Height = 480
  Caption = 'DB Compare'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 337
    Top = 25
    Width = 3
    Height = 428
    Cursor = crHSplit
    OnMoved = Splitter1Moved
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 337
    Height = 428
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1Labels: TPanel
      Left = 0
      Top = 0
      Width = 337
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 2
      TabOrder = 0
      object Label1: TLabel
        Left = 1
        Top = 33
        Width = 27
        Height = 13
        Caption = 'Table'
      end
      object Label3: TLabel
        Left = 13
        Top = 11
        Width = 15
        Height = 13
        Caption = 'DB'
      end
      object Label7: TLabel
        Left = 64
        Top = 32
        Width = 32
        Height = 13
        Caption = 'Label7'
      end
      object cb1: TComboBox
        Left = 32
        Top = 29
        Width = 297
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
        OnChange = cb1Change
      end
      object btnDataLink1: TButton
        Left = 32
        Top = 7
        Width = 295
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Open Data Link File'
        TabOrder = 1
        OnClick = btnDataLink1Click
      end
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 409
      Width = 337
      Height = 19
      Panels = <
        item
          Width = 100
        end
        item
          Width = 80
        end
        item
          Width = 50
        end>
      SimplePanel = False
    end
    object Grid1: TStringGrid
      Left = 0
      Top = 57
      Width = 337
      Height = 352
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 17
      DefaultDrawing = False
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      PopupMenu = PopupMenu1
      TabOrder = 2
      OnClick = Grid1Click
      OnDrawCell = Grid1DrawCell
      OnSelectCell = Grid1SelectCell
      OnTopLeftChanged = Grid1TopLeftChanged
      RowHeights = (
        17
        17)
    end
  end
  object Panel2: TPanel
    Left = 340
    Top = 25
    Width = 385
    Height = 428
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2Labels: TPanel
      Left = 0
      Top = 0
      Width = 385
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 2
      TabOrder = 0
      object Label2: TLabel
        Left = 2
        Top = 33
        Width = 27
        Height = 13
        Caption = 'Table'
      end
      object Label4: TLabel
        Left = 14
        Top = 11
        Width = 15
        Height = 13
        Caption = 'DB'
      end
      object cb2: TComboBox
        Left = 32
        Top = 29
        Width = 346
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
        OnChange = cb2Change
      end
      object btnDataLink2: TButton
        Left = 32
        Top = 7
        Width = 342
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Open Data Link File'
        TabOrder = 1
        OnClick = btnDataLink2Click
      end
    end
    object StatusBar2: TStatusBar
      Left = 0
      Top = 409
      Width = 385
      Height = 19
      Panels = <
        item
          Width = 100
        end
        item
          Width = 80
        end
        item
          Width = 50
        end>
      SimplePanel = False
    end
    object Grid2: TStringGrid
      Left = 0
      Top = 57
      Width = 385
      Height = 352
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 17
      DefaultDrawing = False
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      PopupMenu = PopupMenu1
      TabOrder = 2
      OnClick = Grid1Click
      OnDrawCell = Grid2DrawCell
      OnSelectCell = Grid2SelectCell
      OnTopLeftChanged = Grid2TopLeftChanged
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 725
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnNext: TSpeedButton
      Left = 339
      Top = 1
      Width = 23
      Height = 22
      Hint = 'Next Difference'
      Glyph.Data = {
        B6000000424DB600000000000000760000002800000009000000080000000100
        04000000000040000000230B0000230B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0077770777704D
        03BB7770007772CC5602770000077C01E55F70000000766600FE0000000001FF
        7519777000777F2AFE84777000777D8D43FD7770007777FB9E60}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnNextClick
    end
    object btnPrev: TSpeedButton
      Left = 315
      Top = 1
      Width = 23
      Height = 22
      Hint = 'Previous Difference'
      Glyph.Data = {
        B6000000424DB600000000000000760000002800000009000000080000000100
        04000000000040000000230B0000230B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777000777B2C
        14B1777000777C7068697770007770310000000000000C1D9810700000007A65
        6374770000077000000077700077700000007777077770011300}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnPrevClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 300
    Top = 80
    object ShowLegend1: TMenuItem
      Caption = 'Show Legend'
      OnClick = ShowLegend1Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.udl'
    Filter = 
      'Microsoft Data Link Files (*.udl)|*.udl|ODBC DSNs (*.dsn)|*.dsn|' +
      'All Files (*.*)|*.*'
    Left = 328
    Top = 24
  end
end
