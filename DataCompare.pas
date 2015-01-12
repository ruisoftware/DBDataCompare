unit DataCompare;

{$B-  Short-circuit Boolean expression}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ADOdb, DB, ComCtrls, Menus,
  Legend, Buttons, Wait, ExtCtrls, Math;

const
  ORPHANCOLOR = $00EFEFEF;
  MINIMUMCOLUMNSIZE = 15;

type
  TForm1 = class(TForm)
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel1Labels: TPanel;
    Panel2: TPanel;
    Panel2Labels: TPanel;
    cb1: TComboBox;
    cb2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    PopupMenu1: TPopupMenu;
    ShowLegend1: TMenuItem;
    Panel3: TPanel;
    btnNext: TSpeedButton;
    btnPrev: TSpeedButton;
    btnDataLink1: TButton;
    OpenDialog: TOpenDialog;
    Label3: TLabel;
    Label7: TLabel;
    btnDataLink2: TButton;
    Grid1: TStringGrid;
    Grid2: TStringGrid;
    procedure cb1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cb2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ShowLegend1Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnDataLink1Click(Sender: TObject);
    procedure btnDataLink2Click(Sender: TObject);
    procedure Grid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Grid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Grid1Click(Sender: TObject);
    procedure Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Grid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Grid1TopLeftChanged(Sender: TObject);
    procedure Grid2TopLeftChanged(Sender: TObject);
  private
    FfrmLegend: TfrmLegend;
    FRows1, FRows2: integer;
    FGrid1ColSelOutOfRange,
    FGrid2ColSelOutOfRange: boolean;
    procedure InitGrids;
    procedure UpdateGrid(Table: TADOTable; TableName: string; Status: TStatusBar);
    procedure UpdateDatabase(Connection: TADOConnection; PathFileName: string; Tables: TStrings);
    procedure UpdateStatusBar;
    function Justify(Rect: TRect; FieldValue: string; AlignTo: TAlignment; Canvas: TCanvas): integer;  public
  end;

var
  Form1: TForm1;

implementation

uses dmDataCompare;

{$R *.DFM}

procedure TForm1.UpdateGrid(Table: TADOTable; TableName: string; Status: TStatusBar);
var
  SavedCursor: TCursor;
begin
  if TableName = '' then exit;
  Table.Close;
  Table.TableName := TableName;
  SavedCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    Status.Panels[0].Text := 'Opening...';
    Table.Open;
    Status.Panels[0].Text := '';
    InitGrids;
  finally
    Screen.Cursor := SavedCursor;
  end;
end;

procedure TForm1.InitGrids;
var
  SavedCursor: TCursor;
  SavedSelectEvent1,
  SavedSelectEvent2: TSelectCellEvent;
  Row, TotalMismatches: Integer;
  frmWait: TfrmWait;

  procedure InitializeFieldNames(Table: TADOTable; Grid: TStringGrid);
  var Col, Len: Integer;
  begin
    for Col := 1 to Table.Fields.Count do
    begin
      Grid.ColWidths[Col] := MINIMUMCOLUMNSIZE;
      Grid.Cells[Col, 0] := IntToStr(Ord(Table.Fields[Col - 1].Alignment)) +
                            Table.Fields[Col - 1].FieldName;
      { Set Column width }
      Len := 2 + Grid.Canvas.TextWidth(Table.Fields[Col - 1].FieldName) + 2;
      if Len > Grid.ColWidths[Col] then
        Grid.ColWidths[Col] := Len;
    end;
  end;

  procedure InitializeFieldCols(Table: TADOTable; Grid: TStringGrid; Row: Integer);
  var Col, Len: Integer;
  begin
    for Col := 1 to Table.Fields.Count do
    begin
      Grid.Cells[Col, Row] := Table.Fields[Col - 1].DisplayText;
      { Set Column width }
      Len := 2 + Grid.Canvas.TextWidth(Trim(Grid.Cells[Col, Row])) + 2;
      if Len > Grid.ColWidths[Col] then
        Grid.ColWidths[Col] := Len;
    end;
  end;

  procedure InitializeFieldColsEmpties(Table: TADOTable; Grid: TStringGrid; Row: Integer);
  var Col: Integer;
  begin
    for Col := 1 to Table.Fields.Count do
      Grid.Cells[Col, Row] := '';
  end;

  function DiffsInLastTwoRows(Cols1, Cols2, Row: Integer): integer;
  var Col, MinCol, MaxCol: Integer;
  begin
    Result := 0;
    if Cols1 > Cols2 then MinCol := Cols2 else MinCol := Cols1;
    if Cols1 > Cols2 then MaxCol := Cols1 else MaxCol := Cols2;
    for Col := 1 to MaxCol - 1 do
    begin
      if Col < MinCol then
        if Grid1.Cells[Col, Row] <> Grid2.Cells[Col, Row] then
          Inc(Result) { one difference found }
        else { no differences }
      else
        Inc(Result);  { one difference found - non existent field on the other table}
    end;
  end;

  procedure SetCellToBeginning;
  begin
    if FRows1 > 0 then
    begin
      Grid1.Row := 1;
      Grid1.Col := 1;
    end;
    if FRows2 > 0 then
    begin
      Grid2.Row := 1;
      Grid2.Col := 1;
    end;
  end;

begin
  TotalMismatches := 0;
  btnPrev.Enabled := False;
  btnNext.Enabled := False;
  with dm do
  begin
    if tbl1.Active then FRows1 := tbl1.RecordCount;
    if tbl2.Active then FRows2 := tbl2.RecordCount;

    if (FRows1 = -1) or (FRows2 = -1) then exit;
    if not tbl1.Active then tbl1.Open;
    if not tbl2.Active then tbl2.Open;
    FRows1 := tbl1.RecordCount;
    FRows2 := tbl2.RecordCount;
    SavedSelectEvent1 := Grid1.OnSelectCell;
    SavedSelectEvent2 := Grid2.OnSelectCell;
    Grid1.OnSelectCell := nil;
    Grid2.OnSelectCell := nil;
    frmWait := TfrmWait.Create(nil);
    try
      Grid1.ColCount := tbl1.Fields.Count + 1;
      Grid2.ColCount := tbl2.Fields.Count + 1;
      SavedCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      Grid1.Enabled := False;
      Grid2.Enabled := False;
      frmWait.ProgressBar1.Max := Max(FRows1, FRows2);
      frmWait.ProgressBar1.Position := 0;
      frmWait.Visible := (frmWait.ProgressBar1.Max > 40);
      if frmWait.Visible then
        frmWait.panel1.Repaint;
      try
        InitializeFieldNames(tbl1, Grid1);
        InitializeFieldNames(tbl2, Grid2);
        if Max(FRows1, FRows2) = 0 then
        begin
          Grid1.RowCount := 2; { 1 fixed row + 1 empty data row }
          Grid2.RowCount := 2; { 1 fixed row + 1 empty data row }
          exit; { both tables are empty (both will have same RowCount) }
        end;

        tbl1.First;
        tbl2.First;
        Row := 1;
        while not(tbl1.Eof) or not(tbl2.Eof) do { loop until both tables are eof }
        begin
          if tbl1.Eof then InitializeFieldColsEmpties(tbl1, Grid1, Row)
          else InitializeFieldCols(tbl1, Grid1, Row);

          if tbl2.Eof then InitializeFieldColsEmpties(tbl2, Grid2, Row)
          else InitializeFieldCols(tbl2, Grid2, Row);

          TotalMismatches := TotalMismatches +
            DiffsInLastTwoRows(Grid1.ColCount, Grid2.ColCount, Row);

          if not(tbl1.Eof) then tbl1.Next;
          if not(tbl2.Eof) then tbl2.Next;
          Row := Row + 1;
          frmWait.ProgressBar1.Position := Row;
        end;

        { finally "show the data" by setting RowCount }
        if FRows1 > FRows2 then
        begin
          Grid1.RowCount := FRows1 + 1;
          Grid2.RowCount := Grid1.RowCount;
        end
        else
        begin
          Grid1.RowCount := FRows2 + 1;
          Grid2.RowCount := Grid1.RowCount;
        end;
        SetCellToBeginning;

        { that's the beauty of string grids: Don't need to waist resources with open tables }
        tbl1.Close;
        tbl2.Close;
      finally
        Grid1.Enabled := True;
        Grid2.Enabled := True;
        Screen.Cursor := SavedCursor;
      end;
    finally
      frmWait.Free;
      Grid1.OnSelectCell := SavedSelectEvent1;
      Grid2.OnSelectCell := SavedSelectEvent2;
    end;
  end;
  btnPrev.Enabled := (TotalMismatches > 0);
  btnNext.Enabled := (TotalMismatches > 0);
  if TotalMismatches > 0 then
    MessageDlg('A total of ' + IntToStr(TotalMismatches) + ' mismatches were found!', mtWarning, [mbOk], 0);
end;

procedure TForm1.UpdateDatabase(Connection: TADOConnection; PathFileName: string; Tables: TStrings);
var
  SavedCursor: TCursor;
begin
  Connection.Close;
  Connection.ConnectionString := 'FILE NAME=' + PathFileName;
  SavedCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    Connection.Open;
    Connection.GetTableNames(Tables);
  finally
    Screen.Cursor := SavedCursor;
  end;
end;

procedure TForm1.cb1Change(Sender: TObject);
begin
  if cb1.ItemIndex = -1 then exit;
  UpdateGrid(dm.tbl1, cb1.Items[cb1.ItemIndex], StatusBar1);
  UpdateStatusBar;
  if FRows2 = -1 then
    StatusBar2.Panels[2].Text := 'Open this other table';
  Grid1.SetFocus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FRows1 := -1;
  FRows2 := -1;
  FfrmLegend := TfrmLegend.Create(nil);
  Grid1.ColWidths[0] := 10;
  Grid1.ColWidths[1] := Grid1.Parent.Width - 20;
  Grid2.ColWidths[0] := 10;
  Grid2.ColWidths[1] := Grid2.Parent.Width - 20;
  FGrid1ColSelOutOfRange := False;
  FGrid2ColSelOutOfRange := False;
end;

procedure TForm1.cb2Change(Sender: TObject);
begin
  if cb2.ItemIndex = -1 then exit;
  UpdateGrid(dm.tbl2, cb2.Items[cb2.ItemIndex], StatusBar2);
  UpdateStatusBar;
  if FRows1 = -1 then
    StatusBar1.Panels[2].Text := 'Open this other table';
  Grid2.SetFocus;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FfrmLegend.Free;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  if FfrmLegend.Visible then
    PopupMenu1.Items[0].Caption := 'Hide Legend'
  else
    PopupMenu1.Items[0].Caption := 'Show Legend';
end;

procedure TForm1.ShowLegend1Click(Sender: TObject);
begin
  FfrmLegend.Visible := not FfrmLegend.Visible;
end;

procedure TForm1.UpdateStatusBar;
begin
  if (FRows1 = -1) or (FRows2 = -1) then exit;
  with dm do
  begin
    if FRows1 = 0 then
      Statusbar1.Panels[0].Text := '[Empty]'
    else
      if Grid1.Row > FRows1 then
        Statusbar1.Panels[0].Text := '[Eof] ' + IntToStr(FRows1) + ' rows'
      else
        Statusbar1.Panels[0].Text :=
          IntToStr(Grid1.Row) + ' of ' + IntToStr(FRows1) + ' rows';

    if FRows2 = 0 then
      Statusbar2.Panels[0].Text := '[Empty]'
    else
      if Grid2.Row > FRows2 then
        Statusbar2.Panels[0].Text := '[Eof] ' + IntToStr(FRows2) + ' rows'
      else
        Statusbar2.Panels[0].Text :=
          IntToStr(Grid2.Row) + ' of ' + IntToStr(FRows2) + ' rows'
  end;

  if Grid2.Col > Grid1.ColCount - 1 then
    Statusbar1.Panels[1].Text := '[Eol] ' + IntToStr(Grid1.ColCount - 1) + ' cols'
  else
    Statusbar1.Panels[1].Text := IntToStr(Grid1.Col) + ' of ' + IntToStr(Grid1.ColCount - 1) + ' cols';

  if Grid1.Col > Grid2.ColCount - 1 then
    Statusbar2.Panels[1].Text := '[Eol] ' + IntToStr(Grid2.ColCount - 1) + ' cols'
  else
    Statusbar2.Panels[1].Text := IntToStr(Grid2.Col) + ' of ' + IntToStr(Grid2.ColCount - 1) + ' cols';

  if FGrid1ColSelOutOfRange then Statusbar1.Panels[2].Text := ''
  else Statusbar1.Panels[2].Text := Grid1.Cells[Grid1.Col, Grid1.Row];

  if FGrid2ColSelOutOfRange then Statusbar2.Panels[2].Text := ''
  else Statusbar2.Panels[2].Text := Grid2.Cells[Grid2.Col, Grid2.Row];
end;

procedure TForm1.Splitter1Moved(Sender: TObject);
begin
  btnPrev.Left := Splitter1.Left - btnPrev.Width + 1;
  btnNext.Left := Splitter1.Left + 2;
end;

procedure TForm1.btnPrevClick(Sender: TObject);
var
  Row, Col: integer;
  GridWithMoreCols,
  GridWithLessCols: TStringGrid; { they both have same rows }
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if Grid2.ColCount > Grid1.ColCount then GridWithMoreCols := Grid2
    else GridWithMoreCols := Grid1;

    if GridWithMoreCols = Grid1 then GridWithLessCols := Grid2
    else GridWithLessCols := Grid1;

    Row := GridWithMoreCols.Row;
    Col := GridWithMoreCols.Col;
    repeat
      if Col > 1 then
        Dec(Col)
      else
        if Row > 1 then
        begin
          Col := GridWithMoreCols.ColCount - 1;
          Dec(Row);
        end
        else
        begin
          MessageDlg('Top of the Tables', mtInformation, [mbOk], 0);
          exit;
        end;
    until (Col > GridWithLessCols.ColCount - 1) or
          (GridWithMoreCols.Cells[Col, Row] <> GridWithLessCols.Cells[Col, Row]);
    GridWithMoreCols.Col := Col;
    GridWithMoreCols.Row := Row;
  finally
    Screen.Cursor := SavedCursor;
  end;
end;

procedure TForm1.btnNextClick(Sender: TObject);
var
  Row, Col: integer;
  GridWithMoreCols,
  GridWithLessCols: TStringGrid; { they both have same rows }
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if Grid2.ColCount > Grid1.ColCount then GridWithMoreCols := Grid2
    else GridWithMoreCols := Grid1;

    if GridWithMoreCols = Grid1 then GridWithLessCols := Grid2
    else GridWithLessCols := Grid1;

    Row := GridWithMoreCols.Row;
    Col := GridWithMoreCols.Col;
    repeat
      if Col < GridWithMoreCols.ColCount - 1 then
        Inc(Col)
      else
        if Row < GridWithMoreCols.RowCount - 1 then
        begin
          Col := 1;
          Inc(Row);
        end
        else
        begin
          MessageDlg('End of the Tables', mtInformation, [mbOk], 0);
          exit;
        end;
    until (Col > GridWithLessCols.ColCount - 1) or
          (GridWithMoreCols.Cells[Col, Row] <> GridWithLessCols.Cells[Col, Row]);
    GridWithMoreCols.Col := Col;
    GridWithMoreCols.Row := Row;
  finally
    Screen.Cursor := SavedCursor;
  end;
end;

procedure TForm1.btnDataLink1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    btnDataLink1.Caption := ExtractFileName(OpenDialog.FileName);
    UpdateDatabase(dm.connect1, OpenDialog.FileName, cb1.Items);
    cb1.Enabled := True;
  end;
end;

procedure TForm1.btnDataLink2Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    btnDataLink2.Caption := ExtractFileName(OpenDialog.FileName);
    UpdateDatabase(dm.connect2, OpenDialog.FileName, cb2.Items);
    cb2.Enabled := True;
  end;
end;


procedure TForm1.Grid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  SelectEvent: TSelectCellEvent;
begin
  SelectEvent := Grid2.OnSelectCell;
  Grid2.OnSelectCell := nil;
  try
    if ACol < Grid2.ColCount then
    begin
      FGrid2ColSelOutOfRange := False;
      Grid2.Col := ACol;
    end
    else
      FGrid2ColSelOutOfRange := True;

    Grid2.Row := ARow;
    Grid2.TopRow := Grid1.TopRow;
  finally
    Grid2.OnSelectCell := SelectEvent;
  end;
end;

procedure TForm1.Grid2SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  SelectEvent: TSelectCellEvent;
begin
  SelectEvent := Grid1.OnSelectCell;
  Grid1.OnSelectCell := nil;
  try
    if ACol < Grid1.ColCount then
    begin
      FGrid1ColSelOutOfRange := False;
      Grid1.Col := ACol;
    end
    else
      FGrid1ColSelOutOfRange := True;

    Grid1.Row := ARow;
    Grid1.TopRow := Grid2.TopRow;
  finally
    Grid1.OnSelectCell := SelectEvent;
  end;
end;

procedure TForm1.Grid1Click(Sender: TObject);
begin
  UpdateStatusBar;
  Grid1.Invalidate;
  Grid2.Invalidate;
end;

{ Returns the X position to draw FieldValue relatively to Rect }
function TForm1.Justify(Rect: TRect; FieldValue: string; AlignTo: TAlignment; Canvas: TCanvas): integer;
begin
  case AlignTo of
    taLeftJustify: Result := Rect.Left + 2;
    taRightJustify: Result := Rect.Right - 2 - Canvas.TextWidth(FieldValue);
    taCenter: Result := (Rect.Left + Rect.Right) div 2 - Canvas.TextWidth(FieldValue) div 2;
  end;
end;

procedure TForm1.Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  FieldValue: string;
  X: integer;
  FieldAlignment: TAlignment;
begin
  { Remember: Both grids have same number of rows }

  if (ACol = Grid1.Col) and (ARow = Grid1.Row) then   { Needed to focused a cell on a Grid without focus }
    State := State + [gdFocused];

  if FGrid1ColSelOutOfRange then                { Grid2 has a selection that for Grid1 is out of range }
    State := State - [gdFocused];

  with Grid1.Canvas do
  begin
    if gdFixed in State then                    { This cell belongs to fixed zone }
    begin
      Brush.Color := clBtnFace;
      Font.Style := Grid1.Canvas.Font.Style - [fsStrikeOut];
      Font.Color := clWindowText;
    end
    else
    begin
      if Grid1.Cells[ACol, ARow] =
        Grid2.Cells[ACol, ARow] then            { Both cells match }
      begin
        Brush.Color := clWindow;
        Font.Style := Grid1.Canvas.Font.Style - [fsStrikeOut];
        Font.Color := clGreen;
      end
      else                                      { Both cells dont't match }
      begin
        Brush.Color := clWindow;
        Font.Style := Grid1.Canvas.Font.Style + [fsStrikeOut];
        Font.Color := clMaroon;
      end;

      if (ACol >= Grid2.ColCount) or            { This column doesn't exist in Grid2 }
         (ARow > FRows1) or                     { This row has no data in Grid1 [Eof] }
         (ARow > FRows2) then                   { This row has no data in Grid2 [Eof] }
        Brush.Color := ORPHANCOLOR;

      if gdFocused in State then                { This cell is selected }
      begin
        Brush.Color := clHighlight;
        Font.Color := clHighlightText;
      end;
    end;

    FieldValue := Grid1.Cells[ACol, ARow];
    if Grid1.Cells[ACol, 0] = '' then
      X := Rect.Left
    else
    begin
      { The first char in field name is the alignment (0 - Left, 1 - Right, 2 - Center ) }
      FieldAlignment := TAlignment(StrToInt(Grid1.Cells[ACol, 0][1]));
      if gdFixed in State then
        Delete(FieldValue, 1, 1); { delete the first character (the alignment information) }
      X := Justify(Rect, FieldValue, FieldAlignment, Grid1.Canvas);
    end;

    FillRect(Rect);

    if FieldValue <> '' then
      TextRect(Rect,
               X,
               (Rect.Top + Rect.Bottom) div 2 - TextHeight('W') div 2 + 1,
               FieldValue);

    if gdFixed in State then
      DrawEdge(Grid1.Canvas.Handle, Rect, BDR_RAISEDINNER, BF_RECT);

    if gdFocused in State then
      DrawFocusRect(Rect);

    if not(gdFixed in State) then
      if ARow = Grid1.Row then
      begin
        Pen.Color := clBlack;
        Grid1.Canvas.MoveTo(Rect.Left, Rect.Top);
        Grid1.Canvas.LineTo(Rect.Right, Rect.Top);
        Grid1.Canvas.MoveTo(Rect.Left, Rect.Bottom);
        Grid1.Canvas.LineTo(Rect.Right, Rect.Bottom);
      end;
  end;
end;

procedure TForm1.Grid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  FieldValue: string;
  X: integer;
  FieldAlignment: TAlignment;
begin
  { Remember: Both grids have same number of rows }

  if (ACol = Grid2.Col) and (ARow = Grid2.Row) then   { Needed to focused a cell on a Grid without focus }
    State := State + [gdFocused];

  if FGrid2ColSelOutOfRange then                { Grid1 has a selection that for Grid2 is out of range }
    State := State - [gdFocused];

  with Grid2.Canvas do
  begin
    if gdFixed in State then                    { This cell belongs to fixed zone }
    begin
      Brush.Color := clBtnFace;
      Font.Style := Grid2.Canvas.Font.Style - [fsStrikeOut];
      Font.Color := clWindowText;
    end
    else
    begin
      if Grid2.Cells[ACol, ARow] =
        Grid1.Cells[ACol, ARow] then            { Both cells match }
      begin
        Brush.Color := clWindow;
        Font.Style := Grid2.Canvas.Font.Style - [fsStrikeOut];
        Font.Color := clGreen;
      end
      else                                      { Both cells dont't match }
      begin
        Brush.Color := clWindow;
        Font.Style := Grid2.Canvas.Font.Style + [fsStrikeOut];
        Font.Color := clMaroon;
      end;

      if (ACol >= Grid1.ColCount) or            { This column doesn't exist in Grid1 }
         (ARow > FRows2) or                     { This row has no data in Grid2 [Eof] }
         (ARow > FRows1) then                   { This row has no data in Grid1 [Eof] }
        Brush.Color := ORPHANCOLOR;

      if gdFocused in State then                { This cell is selected }
      begin
        Brush.Color := clHighlight;
        Font.Color := clHighlightText;
      end;
    end;

    FieldValue := Grid2.Cells[ACol, ARow];
    if Grid2.Cells[ACol, 0] = '' then
      X := Rect.Left
    else
    begin
      { The first char in field name is the alignment (0 - Left, 1 - Right, 2 - Center ) }
      FieldAlignment := TAlignment(StrToInt(Grid2.Cells[ACol, 0][1]));
      if gdFixed in State then
        Delete(FieldValue, 1, 1); { delete the first character (the alignment information) }
      X := Justify(Rect, FieldValue, FieldAlignment, Grid2.Canvas);
    end;

    FillRect(Rect);

    if FieldValue <> '' then
      TextRect(Rect,
               X,
               (Rect.Top + Rect.Bottom) div 2 - TextHeight('W') div 2 + 1,
               FieldValue);

    if gdFixed in State then
      DrawEdge(Grid2.Canvas.Handle, Rect, BDR_RAISEDINNER, BF_RECT);

    if gdFocused in State then
      DrawFocusRect(Rect);

    if not(gdFixed in State) then
      if ARow = Grid2.Row then
      begin
        Pen.Color := clBlack;
        Grid2.Canvas.MoveTo(Rect.Left, Rect.Top);
        Grid2.Canvas.LineTo(Rect.Right, Rect.Top);
        Grid2.Canvas.MoveTo(Rect.Left, Rect.Bottom);
        Grid2.Canvas.LineTo(Rect.Right, Rect.Bottom);
      end;
  end;
end;

procedure TForm1.Grid1TopLeftChanged(Sender: TObject);
var
  Event: TNotifyEvent;
begin
  Event := Grid2.OnTopLeftChanged;
  Grid2.OnTopLeftChanged := nil;
  try
    Grid2.TopRow := Grid1.TopRow;
  finally
    Grid2.OnTopLeftChanged := Event;
  end;
end;

procedure TForm1.Grid2TopLeftChanged(Sender: TObject);
var
  Event: TNotifyEvent;
begin
  Event := Grid1.OnTopLeftChanged;
  Grid1.OnTopLeftChanged := nil;
  try
    Grid1.TopRow := Grid2.TopRow;
  finally
    Grid1.OnTopLeftChanged := Event;
  end;
end;

end.
