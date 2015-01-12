object dm: Tdm
  OldCreateOrder = False
  Left = 254
  Top = 146
  Height = 454
  Width = 579
  object tbl2: TADOTable
    Connection = connect2
    LockType = ltReadOnly
    Left = 112
    Top = 64
  end
  object connect2: TADOConnection
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 112
    Top = 16
  end
  object tbl1: TADOTable
    Connection = connect1
    CursorType = ctStatic
    LockType = ltReadOnly
    Left = 24
    Top = 64
  end
  object connect1: TADOConnection
    LoginPrompt = False
    Provider = 
      'C:\Program Files\Common Files\System\Ole DB\Data Links\FASS_ACH.' +
      'udl'
    Left = 24
    Top = 16
  end
end
