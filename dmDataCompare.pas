unit dmDataCompare;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADODB, Db, DBTables;

type
  Tdm = class(TDataModule)
    tbl2: TADOTable;
    connect2: TADOConnection;
    tbl1: TADOTable;
    connect1: TADOConnection;
  private
  public
  end;

var
  dm: Tdm;

implementation

{$R *.DFM}

end.
