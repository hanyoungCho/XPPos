(* ******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 영수증 조회
  Author      : 이선우
  Description :
  History     :
  Version   Date         Remark
  --------  ----------   -----------------------------------------------------
  1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

  ****************************************************************************** *)
unit uXGReceiptView;

interface

uses
  {Native}
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  DB, Menus,
  {Plugin System}
  uPluginManager, uPluginModule, uPluginMessages,
  {DevExpress}
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer,
  cxEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  dxDateRanges,
  cxClasses, dxScrollbarAnnotations, cxDBData, cxLabel, cxCurrencyEdit,
  cxButtons, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid,
  cxGridCustomView, cxMemo, cxDBEdit, cxTextEdit, cxButtonEdit,
  {TMS}
  AdvShapeButton,
  {Solbi VCL}
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGReceiptViewForm = class(TPluginModule)
    panToolbar: TPanel;
    btnSaleDate: TAdvShapeButton;
    Label1: TLabel;
    btnPriorDay: TAdvShapeButton;
    btnNextDay: TAdvShapeButton;
    panHeader: TPanel;
    lblPluginVersion: TLabel;
    panRightSide: TPanel;
    Panel1: TPanel;
    edtSerchName: TcxTextEdit;
    edtSearchReceiptNo: TcxTextEdit;
    Image1: TImage;
    Image2: TImage;
    panSaleItemList: TPanel;
    panCouponList: TPanel;
    panPaymentList: TPanel;
    panLeftSide: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1calc_receipt_no: TcxGridDBBandedColumn;
    V1calc_sale_root_div: TcxGridDBBandedColumn;
    V1sale_time: TcxGridDBBandedColumn;
    V1member_nm: TcxGridDBBandedColumn;
    V1total_amt: TcxGridDBBandedColumn;
    V1sale_amt: TcxGridDBBandedColumn;
    V1coupon_dc_amt: TcxGridDBBandedColumn;
    V1calc_more_dc_amt: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    panReceiptList: TPanel;
    Panel7: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    Panel8: TPanel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    V2calc_product_div: TcxGridDBBandedColumn;
    V2product_nm: TcxGridDBBandedColumn;
    V2keep_amt: TcxGridDBBandedColumn;
    V2product_amt: TcxGridDBBandedColumn;
    V2order_qty: TcxGridDBBandedColumn;
    V2dc_amt: TcxGridDBBandedColumn;
    V2calc_charge_amt: TcxGridDBBandedColumn;
    L2: TcxGridLevel;
    Panel9: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    Panel10: TPanel;
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
    L3: TcxGridLevel;
    Panel11: TPanel;
    btnV3Up: TcxButton;
    btnV3Down: TcxButton;
    Panel12: TPanel;
    G4: TcxGrid;
    V4: TcxGridDBBandedTableView;
    V4calc_pay_method: TcxGridDBBandedColumn;
    V4credit_card_no: TcxGridDBBandedColumn;
    V4inst_mon: TcxGridDBBandedColumn;
    V4approve_no: TcxGridDBBandedColumn;
    V4issuer_nm: TcxGridDBBandedColumn;
    V4approve_amt: TcxGridDBBandedColumn;
    L4: TcxGridLevel;
    Panel13: TPanel;
    btnV4Up: TcxButton;
    btnV4Down: TcxButton;
    V4calc_cancel_count: TcxGridDBBandedColumn;
    V1calc_cancel_yn: TcxGridDBBandedColumn;
    V1receipt_no: TcxGridDBBandedColumn;
    V1cancel_yn: TcxGridDBBandedColumn;
    Label3: TLabel;
    V2teebox_list: TcxGridDBBandedColumn;
    btnCancelReceipt: TcyAdvSpeedButton;
    tmrRunOnce: TTimer;
    V4apply_dc_amt: TcxGridDBBandedColumn;
    V4calc_approval_yn: TcxGridDBBandedColumn;
    panHeaderTools: TPanel;
    btnClose: TAdvShapeButton;
    btnQuery: TcyAdvSpeedButton;
    btnReprint: TcyAdvSpeedButton;
    btnCashReceipt: TcyAdvSpeedButton;
    V4calc_cancel_button: TcxGridDBBandedColumn;
    Label4: TLabel;
    Label2: TLabel;
    mmoSaleMemo: TcxMemo;
    V1paid_cnt: TcxGridDBBandedColumn;
    V1cancel_cnt: TcxGridDBBandedColumn;
    btnBarcodeTest: TcxButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPriorDayClick(Sender: TObject);
    procedure btnNextDayClick(Sender: TObject);
    procedure btnCancelReceiptClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btnSaleDateClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV4UpClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure btnV4DownClick(Sender: TObject);
    procedure OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo;
      var ADone: Boolean);
    procedure btnReprintClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure btnCashReceiptClick(Sender: TObject);
    procedure PluginModuleShow(Sender: TObject);
    procedure V4CancelButtonPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure V4DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure V4calc_approval_ynCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure edtSerchNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSearchReceiptNoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBarcodeTestClick(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
  private
    { Private declarations }
    FTargetID: Integer;
    FBaseDate: string; // yyyy-mm-dd
    FApproveNo: string;
    FWorking: Boolean;
    FCancelCount: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoQuery;
    procedure DoCancelPayment;
    procedure DoCancelReceipt;
    procedure DoReIssueReceipt;
    procedure SetBaseDate(const AValue: string);
    procedure RefreshSaleDetail;
    // function GetCancelCount(const AReceiptNo: string): Integer;

    property BaseDate: string read FBaseDate write SetBaseDate;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage = nil);
      override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Graphics, Variants,
  { DevExpress }
  dxCore, cxGridCommon,
  { SolbiLib }
  XQuery,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGCalendar, uXGWaitMsg,
  uXGCashReceiptPopup, uLayeredForm;

{$R *.dfm}

{ TXGReceiptViewForm }

constructor TXGReceiptViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  FTargetID := -1;
  FCancelCount := 0;

  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;
  panLeftSide.Width := (Self.Width div 2) + 23;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrRunOnce.Interval := 100;
  tmrRunOnce.Enabled := True;
end;

procedure TXGReceiptViewForm.btnBarcodeTestClick(Sender: TObject);
const
  LCS_TEST_VALUE = 'A8001006210627101623';
begin
  ShowMessage('[테스트] 영수증번호: ' + LCS_TEST_VALUE);
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SEND_RECEIPT_NO;
    AddParams(CPP_RECEIPT_NO, LCS_TEST_VALUE);
    PluginMessageToID(Self.PluginID);
  finally
    Free;
  end;
end;

destructor TXGReceiptViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGReceiptViewForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
end;

procedure TXGReceiptViewForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := 0;
end;

procedure TXGReceiptViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TXGReceiptViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGReceiptViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FTargetID := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_CASH_CANCEL) or
     (AMsg.Command = CPC_CARD_CANCEL) or
     (AMsg.Command = CPC_PAYCO_CANCEL) then
    FApproveNo := AMsg.ParamByString(CPP_APPROVAL_NO);

  if (AMsg.Command = CPC_SEND_RECEIPT_NO) then
  begin
    var sValue := AMsg.ParamByString(CPP_RECEIPT_NO);
    // edtSearchReceiptNoFull.Text := sValue;
    V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('receipt_no').Index];
    V1.Controller.IncSearchingText := sValue;
  end;
end;

procedure TXGReceiptViewForm.PluginModuleShow(Sender: TObject);
begin
  btnV1PageUp.Height := (G1.Height div 4);
  btnV1Up.Height := btnV1PageUp.Height;
  btnV1Down.Height := btnV1PageUp.Height;
  btnV2Up.Height := (G2.Height div 2);
  btnV3Up.Height := (G3.Height div 2);
  btnV4Up.Height := (G4.Height div 2);
end;

procedure TXGReceiptViewForm.SetBaseDate(const AValue: string);
begin
  if (SaleManager.StoreInfo.ReceiptViewDate <> AValue) then
  begin
    FBaseDate := AValue;
    SaleManager.StoreInfo.ReceiptViewDate := FBaseDate;
    btnSaleDate.Text := FBaseDate;
    DoQuery;
  end;
end;

procedure TXGReceiptViewForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
    try
      Enabled := False;

      if SaleManager.StoreInfo.ReceiptViewDate.IsEmpty then
        SaleManager.StoreInfo.ReceiptViewDate := FormatDateTime('yyyy-mm-dd', Now);

      FBaseDate := SaleManager.StoreInfo.ReceiptViewDate;
      btnSaleDate.Text := FBaseDate;
      DoQuery;
    finally
      Free;
    end;
end;

procedure TXGReceiptViewForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
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
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); // $00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for var I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[i]).Bounds, AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[i].Bounds, GridCellStateToButtonState(AViewInfo.AreaViewInfos[i].State),
        TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;

  ADone := True;
end;

procedure TXGReceiptViewForm.V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  ARect: TRect;
  nCancelCount: Integer;
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('cancel_yn').Index] = CRC_YES) then
    ACanvas.Font.Color := $00544ED6
  else
  begin
    // nPaidCount := AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('paid_cnt').Index];
    nCancelCount := AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('cancel_cnt').Index];
    if (nCancelCount > 0) then
    begin
      ACanvas.Font.Color := $00FF8000;
      if not AViewInfo.GridRecord.Focused then
        ACanvas.FillRect(ARect, $0080FFFF); // ACanvas.Brush.Color := clYellow;
    end;
  end;
end;

procedure TXGReceiptViewForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  RefreshSaleDetail;
end;

procedure TXGReceiptViewForm.V4calc_approval_ynCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (VarToStr(AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('calc_cancel_count').Index]) = '1') then
    ACanvas.Font.Color := $00544ED6;
end;

procedure TXGReceiptViewForm.V4CancelButtonPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  DoCancelPayment;
end;

procedure TXGReceiptViewForm.V4DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V4.DataController.Summary do
    FCancelCount := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V4calc_cancel_button)]), 0);
end;

procedure TXGReceiptViewForm.btnCashReceiptClick(Sender: TObject);
var
  sReceiptNo: string;
begin
  with ClientDM.MDPaymentList do
    if (RecordCount = 0) or
       (FieldByName('pay_method').AsString <> CPM_CASH) or
       (not FieldByName('credit_card_no').AsString.IsEmpty) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '현금결제가 아니거나 이미 현금영수증을 발행한 거래입니다!', ['확인'], 5);
      Exit;
    end;

  sReceiptNo := ClientDM.MDReceiptList.FieldByName('receipt_no').AsString;
  try
    if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '현금영수증을 발행하시겠습니까?', ['예', '아니오']) <> mrOK) then
      Exit;

    with TXGCashReceiptPopup.Create(nil) do
    try
      CashAmount := ClientDM.MDPaymentList.FieldByName('approve_amt').AsInteger;
      if (ShowModal = mrOK) then
      begin
        if (not ClientDM.PostProdCashSaleChange(sReceiptNo, CreditCardNo, ApproveNo)) then
          raise Exception.Create('장애가 발생하여 현금영수증 발행을 완료할 수 없습니다!');

        // BaseDate := Now;
        V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('calc_receipt_no').Index];
        V1.Controller.IncSearchingText := Copy(sReceiptNo, 11, 10);
        DoReIssueReceipt;
        RefreshSaleDetail;
      end;
    finally
      Free;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGReceiptViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGReceiptViewForm.btnNextDayClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  BaseDate := FormatDateTime('yyyy-mm-dd', (StrToDateTime(Format('%s 12:00:00', [BaseDate]), Global.FS) + 1));
end;

procedure TXGReceiptViewForm.btnPriorDayClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  BaseDate := FormatDateTime('yyyy-mm-dd', (StrToDateTime(Format('%s 12:00:00', [BaseDate]), Global.FS) - 1));
end;

procedure TXGReceiptViewForm.btnQueryClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    DoQuery;
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.btnReprintClick(Sender: TObject);
begin
  if (ClientDM.MDReceiptList.RecordCount > 0) then
    DoReIssueReceipt;
end;

procedure TXGReceiptViewForm.btnCancelReceiptClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  DoCancelReceipt;
end;

procedure TXGReceiptViewForm.btnSaleDateClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  with TXGCalendarForm.Create(nil) do
  try
    if (ShowModal = mrOK) then
      BaseDate := FormatDateTime('yyyy-mm-dd', Date);
  finally
    Free;
  end;
end;

procedure TXGReceiptViewForm.btnV1DownClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    GridScrollDown(V1);
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.btnV1PageDownClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    GridScrollPageDown(V1);
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.btnV1PageUpClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    GridScrollPageUp(V1);
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.btnV1UpClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    GridScrollUp(V1);
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGReceiptViewForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGReceiptViewForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V3);
end;

procedure TXGReceiptViewForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;

procedure TXGReceiptViewForm.btnV4DownClick(Sender: TObject);
begin
  GridScrollDown(V4);
end;

procedure TXGReceiptViewForm.btnV4UpClick(Sender: TObject);
begin
  GridScrollUp(V4);
end;

procedure TXGReceiptViewForm.DoCancelPayment;
var
  PM: TPluginMessage;
  sCardNo, sReceiptNo, sPayMethod, sApproveNo, sApproveDate, sReceiptJson, sErrMsg: string;
  bApprovalYN, bManualApprove: Boolean;
  nPaymentCount, nApproveAmt: Integer;
begin
  if FWorking or
     (ClientDM.MDPaymentList.RecordCount = 0) then
    Exit;

  FWorking := True;
  sErrMsg := '';
  try
    try
      with ClientDM.MDReceiptList do
        sReceiptNo := FieldByName('receipt_no').AsString;

      with ClientDM.MDPaymentList do
      begin
        nPaymentCount := RecordCount;
        bApprovalYN := (FieldByName('approval_yn').AsString = CRC_YES);
        sPayMethod := FieldByName('pay_method').AsString;
        sCardNo := FieldByName('credit_card_no').AsString;
        sApproveNo := FieldByName('approve_no').AsString;
        sApproveDate := FieldByName('trade_date').AsString;
        nApproveAmt := FieldByName('approve_amt').AsInteger;
        bManualApprove := (not sApproveNo.IsEmpty) and (FieldByName('internet_yn').AsString <> CRC_YES);
      end;

      if not bApprovalYN then
      begin
        XGMsgBox(Self.Handle, mtWarning, '알림', '이미 환불이 완료된 결제내역 입니다!', ['확인'], 5);
        Exit;
      end;

      { 현금 결제 취소 }
      if (sPayMethod = CPM_CASH) then
      begin
        if sApproveNo.IsEmpty then
        begin
          if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '선택한 현금 거래내역을 취소하시겠습니까?', ['예', '아니오']) <> mrOK) then
            Exit;

          FApproveNo := '';
        end
        else
        begin
          if not bManualApprove then
          begin
            // 현금영수증 발행 결제 취소
            PM := TPluginMessage.Create(nil);
            try
              PM.Command := CPC_INIT;
              PM.AddParams(CPP_OWNER_ID, Self.PluginID);
              PM.AddParams(CPP_APPROVAL_YN, False);
              PM.AddParams(CPP_SALEMODE_YN, False);
              PM.AddParams(CPP_RECEIPT_NO, sReceiptNo);
              PM.AddParams(CPP_APPROVAL_NO, sApproveNo);
              PM.AddParams(CPP_APPROVAL_DATE, sApproveDate);
              PM.AddParams(CPP_APPROVAL_AMT, nApproveAmt);
              if (PluginManager.OpenModal('XGCashApprove' + CPL_EXTENSION, PM) <> mrOK) then
                Exit;
            finally
              FreeAndNil(PM);
            end;
          end;
        end;
      end
      { 신용카드 결제 취소 }
      else if (sPayMethod = CPM_CARD) then
      begin
        if not bManualApprove then
        begin
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            PM.AddParams(CPP_APPROVAL_YN, False);
            PM.AddParams(CPP_SALEMODE_YN, False);
            PM.AddParams(CPP_RECEIPT_NO, sReceiptNo);
            PM.AddParams(CPP_APPROVAL_NO, sApproveNo);
            PM.AddParams(CPP_APPROVAL_DATE, sApproveDate);
            PM.AddParams(CPP_APPROVAL_AMT, nApproveAmt);
            if (PluginManager.OpenModal('XGCardApprove' + CPL_EXTENSION, PM) <> mrOK) then
              Exit;
          finally
            FreeAndNil(PM);
          end;
        end;
      end
      { PAYCO 신용카드 결제 취소 }
      else if (sPayMethod = CPM_PAYCO_CARD) then
      begin
        if not ClientDM.DoPaymentPAYCO(False, False, sErrMsg) then
          raise Exception.Create('PAYCO 환불이 완료되지 못하였습니다!' + _CRLF + sErrMsg);

        XGMsgBox(0, mtInformation, '알림', 'PAYCO 환불이 완료되었습니다!', ['확인'], 5);
      end
      { WELFARE 복지포인트 결제 취소 }
      else if (sPayMethod = CPM_WELFARE) then
      begin
        if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '선택한 포인트 결제내역을 환불하시겠습니까?', ['예', '아니오']) <> mrOK) then
          Exit;

        SaleManager.PayLog(False, bManualApprove, CPM_WELFARE, '', '', nApproveAmt, sReceiptNo);
        FApproveNo := '';
      end
      else
      begin
        XGMsgBox(0, mtWarning, '알림', '환불할 수 없는 거래내역입니다!', ['확인'], 5);
        Exit;
      end;

      { 거래수단별 취소 처리 }
      if not ClientDM.CancelProdSalePartial(sReceiptNo, sPayMethod, sCardNo, FApproveNo, sApproveNo, sErrMsg) then
        raise Exception.Create('환불 작업이 완료되지 못하였습니다!' + _CRLF + sErrMsg);

      if bManualApprove then
      begin
        SaleManager.PayLog(False, bManualApprove, sPayMethod, sCardNo, sApproveNo, nApproveAmt, sReceiptNo);
        XGMsgBox(0, mtConfirmation, '주의', '임의 등록 결제 건을 취소 처리하였습니다!' + _CRLF +
          '원거래 단말기에서도 반드시 취소를 진행하여 주십시오.', ['확인']);
      end;

      ClientDM.PaymentCancelUpdate(sPayMethod, sApproveNo, sApproveDate, FApproveNo);
      if (nPaymentCount = FCancelCount) then
      begin
        FWorking := False;
        DoQuery;
        if not ClientDM.MDReceiptList.Locate('receipt_no', sReceiptNo, [])
        then
          raise Exception.Create('매출 취소 등록을 완료되지 못했습니다!' + _CRLF +
            '거래내역을 새로 고침한 후 다시 시도하여 주십시오.' + _CRLF + '영수증번호: ' + sReceiptNo);

        DoCancelReceipt;
      end
      else
      begin
        sReceiptJson := ClientDM.MakeCancelReceiptJson(ClientDM.MDPaymentList, sErrMsg);
        if not Global.ReceiptPrint.PaymentSlipPrint(sPayMethod, sReceiptJson, sErrMsg) then
          XGMsgBox(0, mtWarning, '알림', '환불 영수증을 출력할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);

        if (nPaymentCount > 1) then
          XGMsgBox(Self.Handle, mtWarning, '주의',
            '모든 분할 결제 건을 취소하지 않으면 매출 내역에 반영되지 않습니다!' + _CRLF +
            '반드시 모든 분할결제 건을 취소하여 주십시오.', ['확인']);

        XGMsgBox(Self.Handle, mtInformation, '알림', '환불 처리가 완료되었습니다.', ['확인'], 5);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.DoCancelReceipt;
var
  PM: TPluginMessage;
  sOrgReceiptNo, sNewReceiptNo, sAffiliateCode, sPartnerName, sMemo, sErrMsg: string;
  nTeeBoxCount: Integer;
  bIsParkingError: Boolean;
begin
  if FWorking then
    Exit;

  FWorking := True;
  bIsParkingError := False;
  sErrMsg := '';
  try
    try
      with ClientDM.MDReceiptList do
      begin
        if (FieldByName('sale_root_div').AsString = CCT_MOBILE) then
          raise Exception.Create('모바일에서 결제한 내역은 취소 처리가 불가합니다!');

        if (FieldByName('cancel_yn').AsString = CRC_YES) then
          raise Exception.Create('이미 취소된 거래입니다!');

        if (FieldByName('paid_cnt').AsInteger <> FieldByName('cancel_cnt').AsInteger) then
          raise Exception.Create('거래내역에 대한 환불 처리가 완료되지 않았습니다!');

        sOrgReceiptNo := FieldByName('receipt_no').AsString;
        sAffiliateCode := FieldByName('affiliate_cd').AsString;
      end;

      with TXQuery.Create(nil) do
      try
        AddDataSet(ClientDM.MDSaleItemList, 'S');
        SQL.Add('SELECT COUNT(*) AS teebox_count FROM S');
        SQL.Add('WHERE S.receipt_no = :receipt_no');
        SQL.Add('AND S.teebox_list <> ' + QuotedStr(''));
        Params.ParamValues['receipt_no'] := sOrgReceiptNo;
        Open;
        nTeeBoxCount := FieldByName('teebox_count').AsInteger;
      finally
        Close;
        Free;
      end;

      { 제휴사(웰빙클럽,리프레쉬클럽,아이코젠 등) 회원 할인 취소 }
      if not sAffiliateCode.IsEmpty then
      begin
        if AffiliateRec.Applied or (not SaleManager.ReceiptInfo.AffiliateAmt > 0)
        then
          raise Exception.Create('현재 등록 중인 제휴사 할인 내역이 있습니다!' + _CRLF +
            '진행 중인 거래를 완료하거나 제휴사 할인을 취소하여 주십시오.');

        sPartnerName := GetAffiliateName(sAffiliateCode, '제휴사');
        PM := TPluginMessage.Create(nil);
        try
          PM.Command := CPC_INIT;
          PM.AddParams(CPP_OWNER_ID, Self.PluginID);
          PM.AddParams(CPP_APPROVAL_YN, False);
          PM.AddParams(CPP_AFFILIATE_CODE, sAffiliateCode);
          if (PluginManager.OpenModal('XGAffiliate' + CPL_EXTENSION, PM) <> mrOK)
          then
            Exit;

          if (AffiliateRec.PartnerCode = GCD_WBCLUB_CODE) then
          begin
            // 웰빙클럽
            if not ClientDM.ApplyWelbeingClub(False, AffiliateRec.MemberCode, AffiliateRec.MemberName, AffiliateRec.MemberTelNo, sErrMsg) then
              XGMsgBox(0, mtError, '알림', sPartnerName + ' 회원 할인 취소 처리에 실패하였습니다!' + _CRLF +
                '[회원번호] ' + AffiliateRec.MemberCode + _CRLF + sErrMsg, ['확인']);
          end
          else
          begin
            // 리프레쉬클럽,리프레쉬골프,아이코젠 등
            XGMsgBox(0, mtWarning, '알림', sPartnerName + ' 회원 할인 취소는 지원되지 않습니다!'
              + _CRLF + '[회원번호] ' + AffiliateRec.MemberCode + _CRLF +
              sErrMsg, ['확인']);
          end;
        finally
          FreeAndNil(PM);
        end;
      end;

      sNewReceiptNo := SaleManager.GetNewReceiptNo;
      sMemo := mmoSaleMemo.Text;
      if sMemo.IsEmpty then
        sMemo := '반품/환불';

      if not ClientDM.CancelProdSale(sNewReceiptNo, sOrgReceiptNo, AffiliateRec.PartnerCode, AffiliateRec.MemberCode, sMemo, bIsParkingError, sErrMsg) then
        raise Exception.Create('매출취소 등록 작업이 완료되지 못하였습니다!' + _CRLF + sErrMsg);

      if bIsParkingError then
        XGMsgBox(0, mtError, '알림', '장애가 발생하여 주차권 정보 삭제에 실패하였습니다!' + _CRLF + sErrMsg, ['확인'], 5);

      if Global.TeeBoxADInfo.Enabled and (nTeeBoxCount > 0) then
        if not ClientDM.CancelTeeBoxReserve('', sOrgReceiptNo, sErrMsg) then
          raise Exception.Create(sErrMsg);

      V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('calc_receipt_no').Index];
      V1.Controller.IncSearchingText := Copy(sNewReceiptNo, 11, 10);
      DoReIssueReceipt;
      DoQuery;

      XGMsgBox(Self.Handle, mtInformation, '알림', '거래취소 작업이 완료되었습니다.', ['확인'], 5);
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    AffiliateRec.Clear;
    FWorking := False;
  end;
end;

procedure TXGReceiptViewForm.DoQuery;
var
  LF: TLayeredForm;
  sErrMsg: string;
begin
  try
    LF := TLayeredForm.Create(nil);
    LF.Show;
    ShowWaitMessage('거래내역 조회 중입니다...');
    try
      V1.OnFocusedRecordChanged := nil;
      if not ClientDM.GetProdSaleNew(BaseDate, BaseDate, sErrMsg) then
        raise Exception.Create(sErrMsg);

      RefreshSaleDetail;
    finally
      V1.OnFocusedRecordChanged := V1FocusedRecordChanged;
      HideWaitMessage;
      LF.Close;
      LF.Free;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGReceiptViewForm.DoReIssueReceipt;
var
  bIsCancel: Boolean;
  sReceiptJson, sErrMsg: string;
begin
  bIsCancel := (ClientDM.MDReceiptList.FieldByName('cancel_yn').AsString = CRC_YES);
  sReceiptJson := ClientDM.MakeReIssueReceiptJson(sErrMsg);
  try
    if not sErrMsg.IsEmpty then
      raise Exception.Create(sErrMsg);

    Global.ReceiptPrint.IsReturn := bIsCancel;
    if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, True, False, sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '영수증 출력에 장애가 발생했습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGReceiptViewForm.edtSearchReceiptNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('calc_receipt_no').Index];
    V1.Controller.IncSearchingText := TcxTextEdit(Sender).Text;
  end;
end;

procedure TXGReceiptViewForm.edtSerchNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('member_nm').Index];
    V1.Controller.IncSearchingText := TcxTextEdit(Sender).Text;
  end;
end;

procedure TXGReceiptViewForm.RefreshSaleDetail;
var
  sErrMsg: string;
begin
  FWorking := True;
  try
    with ClientDM.MDReceiptList do
    begin
      mmoSaleMemo.Text := FieldByName('memo').AsString;
      mmoSaleMemo.Properties.ReadOnly := (FieldByName('cancel_yn').AsString = CRC_YES);
      mmoSaleMemo.Style.Color := IIF(mmoSaleMemo.Properties.ReadOnly, $00F0F0F0, $00E8FFFF);
    end;

    with ClientDM.MDReceiptList do
    try
      ShowWaitMessage('상세 거래내역 조회 중입니다...');
      G1.Enabled := False;
      btnCancelReceipt.Enabled := False;
      if (RecordCount > 0) then
      begin
        if not ClientDM.GetProdSaleDetailNew(FieldByName('receipt_no').AsString, sErrMsg) then
          raise Exception.Create(sErrMsg);

        btnCancelReceipt.Enabled := (FieldByName('cancel_yn').AsString <> CRC_YES);
      end;
    finally
      G1.Enabled := True;
      HideWaitMessage;
      FWorking := False;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

(*
  function TXGReceiptViewForm.GetCancelCount(const AReceiptNo: string): Integer;
  begin
  with TXQuery.Create(nil) do
  try
  AddDataSet(ClientDM.MDPaymentList, 'P');
  SQL.Add('SELECT COUNT(1) AS cancel_count FROM P');
  SQL.Add('WHERE P.receipt_no = :receipt_no AND P.approval_yn = :approval_yn');
  Params.ParamValues['receipt_no'] := AReceiptNo;
  Params.ParamValues['approval_yn'] := CRC_NO;
  Open;
  Result := FieldByName('cancel_count').AsInteger;
  finally
  Close;
  Free;
  end;
  end;
*)

/// /////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage = nil): TPluginModule;
begin
  Result := TXGReceiptViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
