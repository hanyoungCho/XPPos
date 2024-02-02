unit uXGTeeBoxMoveDragDrop;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxLabel, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid, cxTextEdit,
  cxMaskEdit, cxSpinEdit,
  { TMS }
  AdvShapeButton;

type
  TXGTeeBoxMoveDragDropForm = class(TForm)
    panBody: TPanel;
    lblFormTitle: TLabel;
    lblTeeBoxTitle: TcxLabel;
    lblOldTeeBox: TcxLabel;
    lblNewTeeBox: TcxLabel;
    lblPrepareTitle: TcxLabel;
    lblOldPrepareMin: TcxLabel;
    edtNewPrepareMin: TcxSpinEdit;
    lblRemainTitle: TcxLabel;
    lblOldRemainMin: TcxLabel;
    Label1: TLabel;
    edtAdjustAssignMin: TcxSpinEdit;
    edtNewAssignMin: TcxSpinEdit;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    Image1: TImage;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1calc_play_yn: TcxGridDBBandedColumn;
    V1member_nm: TcxGridDBBandedColumn;
    V1floor_cd: TcxGridDBBandedColumn;
    V1teebox_nm: TcxGridDBBandedColumn;
    V1calc_reserve_time: TcxGridDBBandedColumn;
    V1calc_start_time: TcxGridDBBandedColumn;
    V1calc_end_time: TcxGridDBBandedColumn;
    V1prepare_min: TcxGridDBBandedColumn;
    V1assign_min: TcxGridDBBandedColumn;
    V1calc_remain_min: TcxGridDBBandedColumn;
    V1reserve_move_yn: TcxGridDBBandedColumn;
    V1teebox_no: TcxGridDBBandedColumn;
    V1play_yn: TcxGridDBBandedColumn;
    V1receipt_no: TcxGridDBBandedColumn;
    V1Bunker: TcxGridDBBandedTableView;
    V1BunkerColumn1: TcxGridDBBandedColumn;
    V1BunkerColumn2: TcxGridDBBandedColumn;
    V1BunkerColumn3: TcxGridDBBandedColumn;
    V1BunkerColumn4: TcxGridDBBandedColumn;
    V1BunkerColumn5: TcxGridDBBandedColumn;
    V1BunkerColumn6: TcxGridDBBandedColumn;
    V1BunkerColumn7: TcxGridDBBandedColumn;
    V1BunkerColumn8: TcxGridDBBandedColumn;
    V1BunkerColumn9: TcxGridDBBandedColumn;
    V1BunkerColumn10: TcxGridDBBandedColumn;
    V1BunkerColumn11: TcxGridDBBandedColumn;
    V1NoShow: TcxGridDBBandedTableView;
    V1NoShowcalc_reserve_div: TcxGridDBBandedColumn;
    V1NoShowcalc_reserve_root_div: TcxGridDBBandedColumn;
    V1NoShowfloor_cd: TcxGridDBBandedColumn;
    V1NoShowteebox_nm: TcxGridDBBandedColumn;
    V1NoShowproduct_nm: TcxGridDBBandedColumn;
    V1NoShowprepare_min: TcxGridDBBandedColumn;
    V1NoShowassign_min: TcxGridDBBandedColumn;
    V1NoShowcalc_reserve_time: TcxGridDBBandedColumn;
    V1NoShowcalc_start_time: TcxGridDBBandedColumn;
    V1NoShowcalc_end_time: TcxGridDBBandedColumn;
    V1NoShowmember_nm: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    btnClose: TAdvShapeButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure V1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure edtAdjustAssignMinPropertiesChange(Sender: TObject);
    procedure edtNewAssignMinPropertiesChange(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    FWorking: Boolean;
    FReserveNo: string;
    FMemberNo: string;
    FRemainMin: Integer;
    FPrepareMin: Integer;

    procedure SelectRecord;
    procedure DoTeeBoxMove;
    procedure SetTargetTeeBoxName(const AValue: string);
  public
    { Public declarations }
    property TargetTeeBoxName: string write SetTargetTeeBoxName;
    property ReserveNo: string read FReserveNo write FReserveNo;
    property MemberNo: string read FMemberNo write FMemberNo;
    property RemainMin: Integer read FRemainMin write FRemainMin;
    property PrepareMin: Integer read FPrepareMin write FPrepareMin;
  end;

var
  XGTeeBoxMoveDragDropForm: TXGTeeBoxMoveDragDropForm;

implementation

uses
  { DevExpress }
  dxCore, cxGridCommon,
  { Project }
  uXGClientDM, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxMoveDragDropForm }

procedure TXGTeeBoxMoveDragDropForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  ReserveNo := '';
  MemberNo := '';
  PrepareMin := 0;
  RemainMin := 0;

  SelectRecord;
end;

procedure TXGTeeBoxMoveDragDropForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGTeeBoxMoveDragDropForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      ModalResult := mrCancel;
    VK_RETURN:
      btnOK.Click;
  end;
end;

procedure TXGTeeBoxMoveDragDropForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxMoveDragDropForm.btnOKClick(Sender: TObject);
begin
  with V1.DataController.DataSource.DataSet do
  begin
    if (RecordCount = 0) then
      Exit;

    ReserveNo := FieldByName('reserve_no').AsString;
    MemberNo := FieldByName('member_no').AsString;
    PrepareMin := Trunc(edtNewPrepareMin.Value);
    RemainMin := Trunc(edtNewAssignMin.Value);
  end;
  DoTeeBoxMove;
end;

procedure TXGTeeBoxMoveDragDropForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxMoveDragDropForm.V1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  DoTeeBoxMove;
end;

procedure TXGTeeBoxMoveDragDropForm.V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('play_yn').Index] <> True) then
    ACanvas.Font.Color := $00B6752E;
end;

procedure TXGTeeBoxMoveDragDropForm.V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
begin
  AViewInfo.Borders := [];

  if AViewInfo.IsPressed then
  begin
    ACanvas.FillRect(AViewInfo.Bounds, clGreen);
    ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
    ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);

    ACanvas.ExcludeClipRect(AViewInfo.Bounds);
  end
  else
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); //$00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[I]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

procedure TXGTeeBoxMoveDragDropForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  SelectRecord;
end;

procedure TXGTeeBoxMoveDragDropForm.edtAdjustAssignMinPropertiesChange(Sender: TObject);
begin
  edtNewAssignMin.Value := (FRemainMin + TcxSpinEdit(Sender).Value);
end;

procedure TXGTeeBoxMoveDragDropForm.edtNewAssignMinPropertiesChange(Sender: TObject);
begin
  edtAdjustAssignMin.Value := (TcxSpinEdit(Sender).Value - FRemainMin);
end;

procedure TXGTeeBoxMoveDragDropForm.SelectRecord;
var
  nPrepareMin, nRemainMin: Integer;
begin
  with V1.DataController.DataSource.DataSet do
    if (RecordCount = 0) then
    begin
      lblOldTeeBox.Caption := '';
      lblOldPrepareMin.Caption := '';
      lblOldRemainMin.Caption := '';
      edtNewPrepareMin.Value := 0;
      edtAdjustAssignMin.Value := 0;
      edtNewAssignMin.Value := 0;
    end
    else
    begin
      lblOldTeeBox.Caption := Format('%s층 %s', [StringReplace(FieldByName('floor_nm').AsString, '층', '', [rfReplaceAll]), FieldByName('teebox_nm').AsString]);
      nPrepareMin := FieldByName('prepare_min').AsInteger;
      nRemainMin := FieldByName('calc_remain_min').AsInteger;
      lblOldPrepareMin.Caption := IntToStr(nPrepareMin);
      lblOldRemainMin.Caption := IntToStr(nRemainMin);
      edtNewPrepareMin.Value := nPrepareMin;
      edtAdjustAssignMin.Value := 0;
      edtNewAssignMin.Value := nRemainMin;
    end;
end;

procedure TXGTeeBoxMoveDragDropForm.DoTeeBoxMove;
var
  sErrMsg: string;
begin
  if FWorking or
     (V1.DataController.RowCount = 0) then
    Exit;

  FWorking := True;
  btnOK.Enabled := False;
  try
    PrepareMin := Trunc(edtNewPrepareMin.Value);
    RemainMin := Trunc(edtNewAssignMin.Value);
    if (RemainMin < 5) then
    begin
      XGMsgBox(Self.Handle, mtInformation, '알림', '배정 시간은 5분 이상 입력되어야 합니다!' + _CRLF + sErrMsg, ['확인'], 5);
      Exit;
    end;

    if (XGMsgBox(Self.Handle, mtConfirmation, '확인', Format('선택된 예약 내역을 %s(번) 타석으로 이동하시겠습니까?', [lblNewTeeBox.Caption]), ['예', '아니오']) = mrOK) then
      ModalResult := mrOK;
  finally
    btnOK.Enabled := True;
    FWorking := False;
  end;
end;

procedure TXGTeeBoxMoveDragDropForm.SetTargetTeeBoxName(const AValue: string);
begin
  lblNewTeeBox.Caption := AValue;
end;

end.
