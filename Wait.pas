unit Wait;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmWait = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWait: TfrmWait;

implementation

{$R *.DFM}

end.
