unit uXGTeeBoxEmergencyReserve;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Menus,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxButtons, cxMaskEdit, cxSpinEdit, cxDBEdit, cxLabel,
  { TMS }
  AdvShapeButton;

type
  TXGEmergencyReserveForm = class(TForm)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblRemainTitle: TcxLabel;
    lblPrepareTitle: TcxLabel;
    lblTeeBoxName: TcxLabel;
    lblReserveTimeLabel: TcxLabel;
    lblStartTime: TcxLabel;
    lblTeeBoxTitle: TcxLabel;
    lblEndTime: TcxLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    lblRecordInfo: TcxLabel;
    edtPrepareMin: TcxDBSpinEdit;
    edtAssignMin: TcxDBSpinEdit;
    btnPrior: TcxButton;
    btnNext: TcxButton;
    edtMemberName: TcxTextEdit;
    btnClose: TAdvShapeButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPriorClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
  private
    { Private declarations }
    FPrepareMin: Integer;
    FAssignMin: Integer;

    procedure RefreshAssignInfo;
    procedure SetMemberName(const AValue: string);
    function GetMemberName: string;
  public
    { Public declarations }
    property PrepareMin: Integer read FPrepareMin write FPrepareMin;
    property AssignMin: Integer read FAssignMin write FAssignMin;
    property MemberName: string read GetMemberName write SetMemberName;
  end;

var
  XGEmergencyReserveForm: TXGEmergencyReserveForm;

implementation

uses
  { Native }
  DateUtils, DB,
  { Project }
  uXGClientDM, uXGGlobal, uXGSaleManager, uXGCommonLib, uXGTeeBoxViewER, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGEmergencyReserveForm }

procedure TXGEmergencyReserveForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGEmergencyReserveForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGEmergencyReserveForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP:
      btnPrior.Click;
    VK_DOWN:
      btnNext.Click;
  end;
end;

procedure TXGEmergencyReserveForm.FormShow(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
  try
    DisableControls;
    First;
    while not Eof do
    begin
      Edit;
      FieldValues['teebox_div']   := CTP_DAILY;
      FieldValues['product_cd']   := '0'; //긴급배정은 상품코드가 없음
      FieldValues['purchase_cd']  := '0'; //긴급배정은 구매번호가 없음
      FieldValues['prepare_min']  := PrepareMin;
      FieldValues['assign_min']   := AssignMin;
      FieldValues['assign_balls'] := 9999;
      Post;
      Next;
    end;

    First;
    if (RecordCount > 0) then
      RefreshAssignInfo;
  finally
    EnableControls;
  end;

  edtAssignMin.SetFocus;
  edtAssignMin.SelStart := Length(edtAssignMin.Text) + 1;
end;

procedure TXGEmergencyReserveForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGEmergencyReserveForm.btnOKClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
    if State in [dsEdit] then
      Post;

  ModalResult := mrOK;
end;

procedure TXGEmergencyReserveForm.btnPriorClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
  begin
    Prior;
    if Bof then
      First;
    RefreshAssignInfo;
  end;
end;

procedure TXGEmergencyReserveForm.btnNextClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
  begin
    Next;
    if Eof then
      Last;
    RefreshAssignInfo;
  end;
end;

procedure TXGEmergencyReserveForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGEmergencyReserveForm.RefreshAssignInfo;
var
  nIndex, nPrepareMin, nAssignMin: Integer;
  dCurEndTime, dNewEndTime: TDateTime;
begin
  with ClientDM.MDTeeBoxSelected do
  begin
    nIndex := FieldByName('teebox_index').AsInteger;
    nPrepareMin := FieldByName('prepare_min').AsInteger;
    nAssignMin := FieldByName('assign_min').AsInteger;
    if not XGTeeBoxViewForm.TeeBoxPanels[nIndex].EndTime.IsEmpty then
      dCurEndTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, XGTeeBoxViewForm.TeeBoxPanels[nIndex].EndTime]), Global.FS)
    else
      dCurEndTime := Now;
    dNewEndTime := IncMinute(dCurEndTime, nPrepareMin + nAssignMin);

    lblRecordInfo.Caption := Format('%d / %d', [RecNo, RecordCount]);
    lblTeeBoxName.Caption := Format('%s층 %s', [StringReplace(FieldByName('floor_nm').AsString, '층', '', [rfReplaceAll]), XGTeeBoxViewForm.TeeBoxPanels[nIndex].TeeBoxName]);
    lblStartTime.Caption := FormatDateTime('hh:nn', IncMinute(dCurEndTime, 1));
    lblEndTime.Caption := FormatDateTime('hh:nn', dNewEndTime);
  end;
end;

function TXGEmergencyReserveForm.GetMemberName: string;
begin
  Result := edtMemberName.Text;
end;

procedure TXGEmergencyReserveForm.SetMemberName(const AValue: string);
begin
  edtMemberName.Text := AValue;
end;

end.
