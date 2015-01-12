program prjDataCompare;

uses
  Forms,
  DataCompare in 'DataCompare.pas' {Form1},
  dmDataCompare in 'dmDataCompare.pas' {dm: TDataModule},
  Legend in 'Legend.pas' {frmLegend},
  Wait in 'Wait.pas' {frmWait};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmLegend, frmLegend);
  Application.CreateForm(TfrmWait, frmWait);
  Application.Run;
end.
