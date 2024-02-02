unit uXGSaleTableContainer;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Graphics,
  Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls, Data.DB,
  { Container }
  ccBoxes,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxDBData, cxLabel, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid, cxTextEdit,
  cxMaskEdit, cxSpinEdit;

const
  STC_COLOR_ACTIVE  = $00FFB76F;
  STC_COLOR_INACTIVE= clSilver;
  STC_COLOR_FOCUSED = $000080FF;
  STC_COLOR_GROUP   = $006FB7FF;

type
  TTableFocusedCallbackProc = reference to procedure(Sender: TObject);
  TTableMsgCallbackProc = reference to procedure(Sender: TObject; const AMsg: string);

  TXGSaleTableContainer = class(TBox)
    DataSource: TDataSource;
    Timer: TTimer;
    TitlePanel: TPanel;
    panTableInfo: TPanel;
    TableNameLabel: TLabel;
    GroupNoLabel: TLabel;
    TableInfoPanel: TPanel;
    ElapsedTimeLabel: TLabel;
    EnteredTimeLabel: TLabel;
    TableNoPanel: TPanel;
    MemoControl: TMemo;
    Grid: TcxGrid;
    GridView: TcxGridDBBandedTableView;
    GridViewproduct_nm: TcxGridDBBandedColumn;
    GridVieworder_qty: TcxGridDBBandedColumn;
    GridViewcalc_charge_amt: TcxGridDBBandedColumn;
    GridLevel: TcxGridLevel;
    GuestCountEdit: TcxSpinEdit;

    procedure TimerTimer(Sender: TObject);
    procedure OnBaseClick(Sender: TObject);
    procedure GuestCountEditPropertiesChange(Sender: TObject);
    procedure GridViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MemoControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FTableFocused: Boolean;
    FTableNo: Integer;
    FGroupNo: Integer;
    FTableIndex: Integer;
    FGuestCount: Integer;
    FActiveColor: TColor;
    FInactiveColor: TColor;
    FFocusedColor: TColor;
    FGroupColor: TColor;
    FLastGroupColor: TColor;
    FTableFocusedCallbackProc: TTableFocusedCallbackProc;
    FTableMsgCallbackProc: TTableMsgCallbackProc;

    procedure SetTableFocused(const AValue: Boolean);
    procedure SetTableNo(const ATableNo: Integer);
    procedure SetTableIndex(const ATableIndex: Integer);
    procedure SetTableName(const ATableName: string);
    procedure SetGroupNo(const AGroupNo: Integer);
    procedure SetGroupColor(const AColor: TColor);
    procedure SetEnteredTime(const AEnteredTime: TDateTime);
    procedure SetElapsedMinutes(const AValue: Integer);
    procedure SetGuestCount(const ACount: Integer);
    procedure SetOrderMemo(const AMemoText: string);
    procedure SetReceiveAmt(const AValue: Integer);

    procedure OnBaseEnter(Sender: TObject);
    procedure OnBaseExit(Sender: TObject);

    procedure DoFocusedEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TableFocused: Boolean read FTableFocused write SetTableFocused default False;
    property TableIndex: Integer read FTableIndex write SetTableIndex;
    property TableNo: Integer read FTableNo write SetTableNo;
    property GroupNo: Integer read FGroupNo write SetGroupNo;
    property TableName: string write SetTableName;
    property EnteredTime: TDateTime write SetEnteredTime;
    property ElapsedMinutes: Integer write SetElapsedMinutes;
    property GuestCount: Integer read FGuestCount write SetGuestCount;
    property OrderMemo: string write SetOrderMemo;
    property ReceiveAmt: Integer write SetReceiveAmt;

    property ActiveColor: TColor read FActiveColor write FActiveColor;
    property InactiveColor: TColor read FInactiveColor write FInactiveColor;
    property FocusedColor: TColor read FFocusedColor write FFocusedColor;
    property GroupColor: TColor read FGroupColor write SetGroupColor;

    property TableFocusedCallbackProc: TTableFocusedCallbackProc read FTableFocusedCallbackProc write FTableFocusedCallbackProc;
    property TableMsgCallbackProc: TTableMsgCallbackProc read FTableMsgCallbackProc write FTableMsgCallbackProc;
  end;

implementation

uses
  { Native }
  DateUtils, Variants,
  { Project }
  uXGGlobal, uXGCommonLib;

{$R *.DFM}

{ TXGSaleTableContainer }

constructor TXGSaleTableContainer.Create(AOwner: TComponent);
begin
  inherited;

  FTableFocused := False;
  FTableNo := 0;
  FGroupNo := 0;
  FActiveColor := STC_COLOR_ACTIVE;
  FInactiveColor := STC_COLOR_INACTIVE;
  FFocusedColor := STC_COLOR_FOCUSED;
  FGroupColor := STC_COLOR_INACTIVE;
  FLastGroupColor := STC_COLOR_INACTIVE;

  Self.Color := InactiveColor;
  TableNoPanel.Color := InactiveColor;
  GroupNoLabel.Color := InactiveColor;
  TableNameLabel.Caption := '';
  EnteredTimeLabel.Caption := '';
  ElapsedTimeLabel.Caption := '';
  GroupNoLabel.Visible := False;
  GuestCountEdit.Visible := False;

  TitlePanel.OnClick := OnBaseClick;
  TableNoPanel.OnClick := OnBaseClick;
  TableNameLabel.OnClick := OnBaseClick;
  EnteredTimeLabel.OnClick := OnBaseClick;
  ElapsedTimeLabel.OnClick := OnBaseClick;
  GroupNoLabel.OnClick := OnBaseClick;

  Self.OnEnter := OnBaseEnter;
  Self.OnExit := OnBaseExit;
end;

destructor TXGSaleTableContainer.Destroy;
begin

  inherited;
end;

procedure TXGSaleTableContainer.TimerTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    ElapsedMinutes := MinutesBetween(Now, Global.TableInfo.Items[TableIndex].EnteredTime);
  finally
    Enabled := True;
  end;
end;

procedure TXGSaleTableContainer.OnBaseEnter(Sender: TObject);
begin
  TableFocused := True;
end;

procedure TXGSaleTableContainer.OnBaseExit(Sender: TObject);
begin
  TableFocused := False;
end;

procedure TXGSaleTableContainer.OnBaseClick(Sender: TObject);
begin
  if not TableFocused then
    Self.SetFocus;
  TableFocused := True;
end;

procedure TXGSaleTableContainer.GridViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not TableFocused then
    Self.SetFocus;
  TableFocused := True;
end;

procedure TXGSaleTableContainer.MemoControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not TableFocused then
    Self.SetFocus;
  TableFocused := True;
end;

procedure TXGSaleTableContainer.DoFocusedEvent(Sender: TObject);
begin
  (Sender as TWinControl).SetFocus;
  Self.SetFocus;
end;

procedure TXGSaleTableContainer.GuestCountEditPropertiesChange(Sender: TObject);
begin
  with TcxSpinEdit(Sender) do
  begin
    if (Value <> Global.TableInfo.Items[TableIndex].GuestCount) then
      GuestCount := Value;
  end;
end;

procedure TXGSaleTableContainer.SetTableFocused(const AValue: Boolean);
begin
  FTableFocused := AValue;
  if FTableFocused then
  begin
    Self.Color := FocusedColor;
    TableNoPanel.Color := FocusedColor;
  end
  else
  begin
    if (DataSource.DataSet.RecordCount > 0) then
    begin
      Self.Color := ActiveColor;
      TableNoPanel.Color := ActiveColor;
    end
    else
    begin
      Self.Color := InactiveColor;
      TableNoPanel.Color := InactiveColor;
    end;
  end;

  if Assigned(FTableFocusedCallbackProc) then
    FTableFocusedCallbackProc(Self);
end;

procedure TXGSaleTableContainer.SetTableNo(const ATableNo: Integer);
begin
  FTableNo := ATableNo;
  TableNoPanel.Caption := IntToStr(FTableNo);
  Global.TableInfo.Items[TableIndex].TableNo := FTableNo;
end;

procedure TXGSaleTableContainer.SetTableIndex(const ATableIndex: Integer);
begin
  FTableIndex := ATableIndex;
  TableNoPanel.Tag := FTableIndex;
  GridView.Tag := FTableIndex;
end;

procedure TXGSaleTableContainer.SetTableName(const ATableName: string);
begin
  TableNameLabel.Caption := ATableName;
end;

procedure TXGSaleTableContainer.SetGroupColor(const AColor: TColor);
begin
  if (FGroupColor <> AColor) then
  begin
    FGroupColor := AColor;
    GroupNoLabel.Color := FGroupColor;
    GroupNoLabel.Font.Color := InvertColor2(FGroupColor);
  end;
end;

procedure TXGSaleTableContainer.SetGroupNo(const AGroupNo: Integer);
begin
  FGroupNo := AGroupNo;
  GroupNoLabel.Visible := (FGroupNo > 0);
  GroupNoLabel.Caption := Format('G-%d', [FGroupNo]);
  Global.TableInfo.Items[TableIndex].GroupNo := FGroupNo;
end;

procedure TXGSaleTableContainer.SetEnteredTime(const AEnteredTime: TDateTime);
begin
  if (Global.TableInfo.Items[TableIndex].EnteredTime = 0) then
  begin
    EnteredTimeLabel.Caption := '';
    ElapsedTimeLabel.Caption := '';
    Timer.Enabled := False;
  end
  else
  begin
    EnteredTimeLabel.Caption := FormatDateTime('hh:nn', Global.TableInfo.Items[TableIndex].EnteredTime);
    Timer.Enabled := True;
  end;
end;

procedure TXGSaleTableContainer.SetElapsedMinutes(const AValue: Integer);
begin
//  nHour := (Global.TableInfo.Items[TableIndex].ElapsedMinutes div 60);
//  nMin := (Global.TableInfo.Items[TableIndex].ElapsedMinutes mod 3600);
  if (Global.TableInfo.Items[TableIndex].ElapsedMinutes > 0) then
    ElapsedTimeLabel.Caption := Format('(%d분)', [Global.TableInfo.Items[TableIndex].ElapsedMinutes]);
end;

procedure TXGSaleTableContainer.SetGuestCount(const ACount: Integer);
begin
  GuestCountEdit.Value := ACount;
  GuestCountEdit.Visible := (ACount > 0);
end;

procedure TXGSaleTableContainer.SetOrderMemo(const AMemoText: string);
begin
  MemoControl.Lines.Text := AMemoText;
end;

procedure TXGSaleTableContainer.SetReceiveAmt(const AValue: Integer);
begin
  GridView.Bands[0].Caption := FormatCurr('받은 금액: ,0', AValue);
  GridView.OptionsView.BandHeaders := (AValue <> 0);
end;

end.
