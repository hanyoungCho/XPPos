(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 보류 내역 조회
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGPendingView;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB, Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxGrid, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxClasses, cxDBData, cxLabel,
  dxScrollbarAnnotations, cxCurrencyEdit, cxGridCustomView, cxGridTableView, cxGridBandedTableView,
  cxButtons, cxGridLevel, cxGridCustomTableView, cxGridDBBandedTableView,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGPendingViewForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    panToolbar: TPanel;
    Panel1: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1receipt_no: TcxGridDBBandedColumn;
    V1pos_no: TcxGridDBBandedColumn;
    V1sale_time: TcxGridDBBandedColumn;
    V1member_nm: TcxGridDBBandedColumn;
    V1hp_no: TcxGridDBBandedColumn;
    V1total_amt: TcxGridDBBandedColumn;
    V1sale_amt: TcxGridDBBandedColumn;
    V1dc_amt: TcxGridDBBandedColumn;
    V1direct_dc_amt: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    V2calc_product_div: TcxGridDBBandedColumn;
    V2product_nm: TcxGridDBBandedColumn;
    V2purchase_month: TcxGridDBBandedColumn;
    V2coupon_cnt: TcxGridDBBandedColumn;
    V2locker_no: TcxGridDBBandedColumn;
    V2keep_amt: TcxGridDBBandedColumn;
    V2product_amt: TcxGridDBBandedColumn;
    V2order_qty: TcxGridDBBandedColumn;
    V2coupon_dc_amt: TcxGridDBBandedColumn;
    V2dc_amt: TcxGridDBBandedColumn;
    V2calc_charge_amt: TcxGridDBBandedColumn;
    L2: TcxGridLevel;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3coupon_nm: TcxGridDBBandedColumn;
    V3calc_dc_div: TcxGridDBBandedColumn;
    V3calc_dc_cnt: TcxGridDBBandedColumn;
    V3start_day: TcxGridDBBandedColumn;
    V3expire_day: TcxGridDBBandedColumn;
    V3use_cnt: TcxGridDBBandedColumn;
    V3used_cnt: TcxGridDBBandedColumn;
    V3calc_product_div: TcxGridDBBandedColumn;
    V3calc_teebox_product_div: TcxGridDBBandedColumn;
    V3calc_use_yn: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    G4: TcxGrid;
    V4: TcxGridDBBandedTableView;
    V4calc_approval_yn: TcxGridDBBandedColumn;
    V4calc_pay_method: TcxGridDBBandedColumn;
    V4credit_card_no: TcxGridDBBandedColumn;
    V4inst_mon: TcxGridDBBandedColumn;
    V4approve_no: TcxGridDBBandedColumn;
    V4issuer_nm: TcxGridDBBandedColumn;
    V4buyer_nm: TcxGridDBBandedColumn;
    V4approve_amt: TcxGridDBBandedColumn;
    V4calc_cancel_count: TcxGridDBBandedColumn;
    L4: TcxGridLevel;
    Panel5: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    Panel6: TPanel;
    btnV3Up: TcxButton;
    btnV3Down: TcxButton;
    Panel7: TPanel;
    btnV4Up: TcxButton;
    btnV4Down: TcxButton;
    Panel8: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnImport: TcyAdvSpeedButton;
    btnDelete: TcyAdvSpeedButton;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    procedure OnGridCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV4UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure btnV4DownClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FTargetID: Integer;
    FBaseDate: TDateTime;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshDetail;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, dxCore, cxGridCommon,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGCalendar, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGPendingViewForm }

constructor TXGPendingViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FTargetID := -1;
  FBaseDate := Now;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  RefreshDataSet(ClientDM.QRReceiptPend);
  RefreshDetail;
  V1.OnFocusedRecordChanged := V1FocusedRecordChanged;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGPendingViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGPendingViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGPendingViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnImport.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGPendingViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGPendingViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FTargetID  := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TXGPendingViewForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo;
  var ADone: Boolean);
var
  i: Integer;
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
  for i := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[i]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[i].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[i].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[i]).Active);
  end;
  ADone := True;
end;

procedure TXGPendingViewForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  RefreshDetail;
end;

procedure TXGPendingViewForm.RefreshDetail;
var
  sReceiptNo: string;
begin
  sReceiptNo := ClientDM.QRReceiptPend.FieldByName('receipt_no').AsString;
  with ClientDM.QRSaleItemPend do
  try
    DisableControls;
    Close;
    Params.ParamValues['RECEIPT_NO'] := sReceiptNo;
    Open;
  finally
    EnableControls;
  end;

  with ClientDM.QRCouponPend do
  try
    DisableControls;
    Close;
    Params.ParamValues['RECEIPT_NO'] := sReceiptNo;
    Open;
  finally
    EnableControls;
  end;

  with ClientDM.QRPaymentPend do
  try
    DisableControls;
    Close;
    Params.ParamValues['RECEIPT_NO'] := sReceiptNo;
    Open;
  finally
    EnableControls;
  end;
end;

procedure TXGPendingViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGPendingViewForm.btnDeleteClick(Sender: TObject);
var
  sReceiptNo, sErrMsg: string;
begin
  if (ClientDM.QRReceiptPend.RecordCount = 0) then
    Exit;

  sReceiptNo := ClientDM.QRReceiptPend.FieldByName('receipt_no').AsString;
  if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
      '선택한 보류내역(영수증No.: ' + sReceiptNo + ')을 삭제하시겠습니까?' + _CRLF +
      '삭제한 내역은 복구할 수 없습니다.', ['예', '아니오']) = mrOK) then
  begin
    if not ClientDM.DeletePending(sReceiptNo, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtError, '알림', '보류내역을 삭제할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
      Exit;
    end;

    RefreshDataSet(ClientDM.QRReceiptPend);
    RefreshDetail;
    XGMsgBox(Self.Handle, mtInformation, '알림', '선택한 보류내역이 삭제 되었습니다!', ['확인'], 5);
  end;
end;

procedure TXGPendingViewForm.btnImportClick(Sender: TObject);
var
  PM: TPluginMessage;
  sReceiptNo, sMemberNo, sPayMethod, sErrMsg: string;
  nPayAmt: Integer;
begin
  with ClientDM.QRReceiptPend do
  begin
    if (RecordCount = 0) then
      Exit;

    sReceiptNo := FieldByName('receipt_no').AsString;
    sMemberNo := FieldByName('member_no').AsString;
  end;

  ClientDM.ClearSaleTables(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
  if ClientDM.LoadPending(sReceiptNo, sErrMsg) then
  begin
    ClientDM.RefreshSaleTables(Global.TableInfo.ActiveTableNo);
    SaleManager.ReceiptInfo.CashPayAmt := 0;
    SaleManager.ReceiptInfo.CardPayAmt := 0;
    SaleManager.ReceiptInfo.WelfarePayAmt := 0;
    SaleManager.ReceiptInfo.PendReceiptNo := sReceiptNo;

    ClientDM.ClearMemberInfo(Global.SaleFormId);
    ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
    if not sMemberNo.IsEmpty and
       ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg) then
    begin
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_SEND_MEMBER_NO;
        PM.AddParams(CPP_MEMBER_NO, sMemberNo);
        PM.PluginMessageToID(Global.SaleFormId);
        PM.PluginMessageToID(Global.TeeBoxViewId);
      finally
        FreeAndNil(PM);
      end;
    end;

    with ClientDM.QRPayment do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        sPayMethod := FieldByName('pay_method').AsString;
        nPayAmt    := FieldByName('approve_amt').AsInteger;
        if ((sPayMethod = CPM_CARD) or
            (sPayMethod = CPM_PAYCO_CARD) or
            (sPayMethod = CPM_PAYCO_COUPON) or
            (sPayMethod = CPM_PAYCO_POINT)) then
          SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt + nPayAmt)
        else if (sPayMethod = CPM_WELFARE) then
          SaleManager.ReceiptInfo.WelfarePayAmt := (SaleManager.ReceiptInfo.WelfarePayAmt + nPayAmt)
        else
          SaleManager.ReceiptInfo.CashPayAmt := (SaleManager.ReceiptInfo.CashPayAmt + nPayAmt);

        Next;
      end;
    finally
      EnableControls;
    end;

    ModalResult := mrOK;
  end
  else
    XGMsgBox(Self.Handle, mtError, '알림',
      '보류내역을 불러올 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
end;

procedure TXGPendingViewForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGPendingViewForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGPendingViewForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGPendingViewForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGPendingViewForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V3);
end;

procedure TXGPendingViewForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;

procedure TXGPendingViewForm.btnV4DownClick(Sender: TObject);
begin
  GridScrollDown(V4);
end;

procedure TXGPendingViewForm.btnV4UpClick(Sender: TObject);
begin
  GridScrollUp(V4);
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGPendingViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.