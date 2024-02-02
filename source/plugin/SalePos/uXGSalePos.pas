(*******************************************************************************
  Title       : �ǸŰ��� Main (����Ʈ POS��)
  Filename    : uXGSalePos.pas
  Author      : �̼���
  Description :
    ...
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2016-10-25   Initial Release.
*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGSalePos;
interface
uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Menus, DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxStyles, cxLookAndFeels, cxLookAndFeelPainters,
  dxBarBuiltInMenu, cxControls, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, dxDateRanges, cxDBData, cxLabel, cxCurrencyEdit,
  cxContainer, cxClasses, cxTextEdit, cxMemo, cxCheckBox, cxButtons,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridCustomView, cxGrid, cxPC, dxScrollbarAnnotations,
  { TMS }
  AdvShapeButton, WallPaper,
  { SolbiVCL}
  cyBaseSpeedButton, cyAdvSpeedButton, Solbi.TouchButton, LEDFontNum;
{$I ..\..\common\XGPOS.inc}
const
  LCN_CATEGORY_MAX  = 3;
  LCN_SALEITEM_MAX  = 11;
type
  TXGSalePosForm = class(TPluginModule)
    panHeader: TPanel;
    panFooter: TPanel;
    panLeftSide: TPanel;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    lblPOSInfo: TLabel;
    lblPluginVersion: TLabel;
    imcButtonFace: TcxImageCollection;
    imcButtonFace1Normal: TcxImageCollectionItem;
    imcButtonFace1Hover: TcxImageCollectionItem;
    imcButtonFace1Down: TcxImageCollectionItem;
    imcButtonFace1Disabled: TcxImageCollectionItem;
    imcButtonFace2Normal: TcxImageCollectionItem;
    imcButtonFace2Hover: TcxImageCollectionItem;
    imcButtonFace2Down: TcxImageCollectionItem;
    imcButtonFace2Disabled: TcxImageCollectionItem;
    imcButtonFace3Normal: TcxImageCollectionItem;
    imcButtonFace3Hover: TcxImageCollectionItem;
    imcButtonFace3Down: TcxImageCollectionItem;
    imcButtonFace3Disabled: TcxImageCollectionItem;
    imcButtonFace4Normal: TcxImageCollectionItem;
    imcButtonFace4Hover: TcxImageCollectionItem;
    imcButtonFace4Down: TcxImageCollectionItem;
    imcButtonFace4Disabled: TcxImageCollectionItem;
    panSaleList: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    panSaleItemNavigator: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    V1product_nm: TcxGridDBBandedColumn;
    V1product_amt: TcxGridDBBandedColumn;
    V1order_qty: TcxGridDBBandedColumn;
    V1calc_dc_amt: TcxGridDBBandedColumn;
    V1calc_category_div: TcxGridDBBandedColumn;
    V1calc_sell_subtotal: TcxGridDBBandedColumn;
    V1calc_charge_amt: TcxGridDBBandedColumn;
    V1calc_vat_subtotal: TcxGridDBBandedColumn;
    V1coupon_dc_fixed_amt: TcxGridDBBandedColumn;
    btnPayCard: TcyAdvSpeedButton;
    btnPayCash: TcyAdvSpeedButton;
    bntPayPAYCO: TcyAdvSpeedButton;
    btnSaleMemberClear: TcyAdvSpeedButton;
    btnPayCancel: TcyAdvSpeedButton;
    btnOpenDrawer: TcyAdvSpeedButton;
    bntPayVoucher: TcyAdvSpeedButton;
    btnSalePartnerCenter: TcyAdvSpeedButton;
    cyAdvSpeedButton2: TcyAdvSpeedButton;
    btnReceiptView: TcyAdvSpeedButton;
    btnMemberNew: TcyAdvSpeedButton;
    btnMemberSearch: TcyAdvSpeedButton;
    btnLockerView: TcyAdvSpeedButton;
    btnTeeBoxView: TcyAdvSpeedButton;
    btnAffiliate: TcyAdvSpeedButton;
    btnTeeBoxProdChange: TcyAdvSpeedButton;
    btnReCalcCoupon: TcyAdvSpeedButton;
    btnCancelCoupon: TcyAdvSpeedButton;
    btnAddonTicket: TcyAdvSpeedButton;
    btnPrintLessonReceipt: TcyAdvSpeedButton;
    btnSaleSearchProduct: TcyAdvSpeedButton;
    btnSaleComplete: TcyAdvSpeedButton;
    V1coupon_dc_rate_amt: TcxGridDBBandedColumn;
    V1keep_amt: TcxGridDBBandedColumn;
    V1direct_dc_amt: TcxGridDBBandedColumn;
    V1xgolf_dc_amt: TcxGridDBBandedColumn;
    panBasePanel: TPanel;
    panHeaderTools: TPanel;
    btnCalculator: TAdvShapeButton;
    btnHome: TAdvShapeButton;
    btnPartnerCenter: TAdvShapeButton;
    btnBack: TAdvShapeButton;
    panRightSide: TPanel;
    panMemberInfoDetail: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    ckbMemberXGolf: TcxCheckBox;
    lblMemberSex: TcxLabel;
    lblMemberLockerList: TcxLabel;
    mmoMemberMemo: TcxMemo;
    panExtMenu: TPanel;
    pgcExtPage: TcxPageControl;
    tabPayment: TcxTabSheet;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    V2calc_pay_method: TcxGridDBBandedColumn;
    V2credit_card_no: TcxGridDBBandedColumn;
    V2approve_no: TcxGridDBBandedColumn;
    V2issuer_nm: TcxGridDBBandedColumn;
    V2buyer_nm: TcxGridDBBandedColumn;
    V2approve_amt: TcxGridDBBandedColumn;
    V2apply_dc_amt: TcxGridDBBandedColumn;
    V2calc_cancel_count: TcxGridDBBandedColumn;
    L2: TcxGridLevel;
    panPayementNavigator: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    tabCoupon: TcxTabSheet;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3coupon_nm: TcxGridDBBandedColumn;
    V3calc_product_div: TcxGridDBBandedColumn;
    V3teebox_product_div: TcxGridDBBandedColumn;
    V3calc_dc_div: TcxGridDBBandedColumn;
    V3calc_dc_cnt: TcxGridDBBandedColumn;
    V3apply_dc_amt: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    panCouponNavigator: TPanel;
    btnV3Up: TcxButton;
    btnV3Down: TcxButton;
    panPluView: TPanel;
    btnSaleItem5: TSolbiTouchButton;
    btnSaleItem6: TSolbiTouchButton;
    btnSaleItem7: TSolbiTouchButton;
    btnSaleItem8: TSolbiTouchButton;
    btnSaleItem11: TSolbiTouchButton;
    btnSaleItem10: TSolbiTouchButton;
    btnSaleItem9: TSolbiTouchButton;
    btnSaleItem1: TSolbiTouchButton;
    btnSaleItem2: TSolbiTouchButton;
    btnSaleItem3: TSolbiTouchButton;
    btnSaleItem4: TSolbiTouchButton;
    btnCategory1: TcyAdvSpeedButton;
    btnCategory2: TcyAdvSpeedButton;
    btnCategory3: TcyAdvSpeedButton;
    btnCategoryPrev: TcyAdvSpeedButton;
    btnCategoryNext: TcyAdvSpeedButton;
    btnSaleItemPrev: TcyAdvSpeedButton;
    btnSaleItemNext: TcyAdvSpeedButton;
    shpPluDivider: TShape;
    panExtButtons: TPanel;
    btnPayment: TcyAdvSpeedButton;
    btnCoupon: TcyAdvSpeedButton;
    btnExtMenu: TcyAdvSpeedButton;
    panNumButtons: TPanel;
    btnSaleItemClear: TcyAdvSpeedButton;
    btnSaleItemDelete: TcyAdvSpeedButton;
    btnSaleItemIncQty: TcyAdvSpeedButton;
    btnSaleItemDecQty: TcyAdvSpeedButton;
    btnSaleItemChangeQty: TcyAdvSpeedButton;
    btnItemDiscountAmout: TcyAdvSpeedButton;
    btnItemDiscountPercent: TcyAdvSpeedButton;
    btnItemDiscountCancel: TcyAdvSpeedButton;
    btnAddPending: TcyAdvSpeedButton;
    btnLoadPending: TcyAdvSpeedButton;
    btnNum7: TcyAdvSpeedButton;
    btnNum8: TcyAdvSpeedButton;
    btnNum9: TcyAdvSpeedButton;
    btnNum4: TcyAdvSpeedButton;
    btnNum5: TcyAdvSpeedButton;
    btnNum6: TcyAdvSpeedButton;
    btnNum1: TcyAdvSpeedButton;
    btnNum2: TcyAdvSpeedButton;
    btnNum3: TcyAdvSpeedButton;
    btnNum0: TcyAdvSpeedButton;
    btnNumBackSpace: TcyAdvSpeedButton;
    btnNumClear: TcyAdvSpeedButton;
    panPaidResult: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblChargeTotal: TLabel;
    lblVatTotal: TLabel;
    lblReceiveTotal: TLabel;
    lblUnPaidTotal: TLabel;
    lblChangeTotal: TLabel;
    Label6: TLabel;
    lblDiscountTotal: TLabel;
    Label12: TLabel;
    lblKeepAmt: TLabel;
    Label13: TLabel;
    lblAffiliateAmt: TLabel;
    edtInputCapture: TcxTextEdit;
    mmoSaleMemo: TcxMemo;
    wppBack: TWallPaper;
    tmrClock: TTimer;
    panScoreboard: TPanel;
    ledPlayingCount: TLEDFontNum;
    ledWaitingCount: TLEDFontNum;
    ledReadyCount: TLEDFontNum;
    ledStoreEndTime: TLEDFontNum;
    Label15: TLabel;
    edtMemberName: TcxTextEdit;
    edtMemberCarNo: TcxTextEdit;
    edtMemberHpNo: TcxTextEdit;
    lblMemberLockerExpired: TcxLabel;
    Label16: TLabel;
    btnCouponCard: TcxButton;
    btnShowMemberInfo: TcxButton;
    V1calc_facility_count: TcxGridDBBandedColumn;
    mmoOrderMemo: TcxMemo;
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnHomeClick(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure OnCategoryButtonClick(Sender: TObject);
    procedure OnSaleItemButtonClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure OnNumPadClick(Sender: TObject);
    procedure btnNumCLClick(Sender: TObject);
    procedure btnNumBSClick(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure btnSaleItemClearClick(Sender: TObject);
    procedure btnSaleItemDeleteClick(Sender: TObject);
    procedure btnSaleItemIncQtyClick(Sender: TObject);
    procedure btnSaleItemDecQtyClick(Sender: TObject);
    procedure btnSaleItemChangeQtyClick(Sender: TObject);
    procedure btnDiscountPercentClick(Sender: TObject);
    procedure OnGridCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure btnBackClick(Sender: TObject);
    procedure btnDiscountAmoutClick(Sender: TObject);
    procedure edtInputCaptureEnter(Sender: TObject);
    procedure btnItemDiscountCancelClick(Sender: TObject);
    procedure V2DataControllerDataChanged(Sender: TObject);
    procedure btnCategoryPrevClick(Sender: TObject);
    procedure btnCategoryNextClick(Sender: TObject);
    procedure btnSaleItemPrevClick(Sender: TObject);
    procedure btnSaleItemNextClick(Sender: TObject);
    procedure btnExtFuncClick(Sender: TObject);
    procedure btnPayCardClick(Sender: TObject);
    procedure btnPayCashClick(Sender: TObject);
    procedure bntPayPAYCOClick(Sender: TObject);
    procedure btnSaleMemberClearClick(Sender: TObject);
    procedure btnPayCancelClick(Sender: TObject);
    procedure btnOpenDrawerClick(Sender: TObject);
    procedure btnReceiptViewClick(Sender: TObject);
    procedure btnMemberNewClick(Sender: TObject);
    procedure btnMemberSearchClick(Sender: TObject);
    procedure btnLockerViewClick(Sender: TObject);
    procedure btnTeeBoxViewClick(Sender: TObject);
    procedure btnSaleCompleteClick(Sender: TObject);
    procedure btnAddPendingClick(Sender: TObject);
    procedure btnLoadPendingClick(Sender: TObject);
    procedure btnPartnerCenterClick(Sender: TObject);
    procedure btnSaleSearchProductClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure btnCancelCouponClick(Sender: TObject);
    procedure pgcExtPageChange(Sender: TObject);
    procedure btnReCalcCouponClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bntPayVoucherClick(Sender: TObject);
    procedure btnCouponCardClick(Sender: TObject);
    procedure btnTeeBoxProdChangeClick(Sender: TObject);
    procedure V2DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure btnAffiliateClick(Sender: TObject);
    procedure btnAddonTicketClick(Sender: TObject);
    procedure btnSalePartnerCenterClick(Sender: TObject);
    procedure PluginModuleShow(Sender: TObject);
    procedure btnCalculatorClick(Sender: TObject);
    procedure btnShowMemberInfoClick(Sender: TObject);
    procedure edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberCarNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnMemberSearchEnter(Sender: TObject);
    procedure OnMemberSearchExit(Sender: TObject);
    procedure btnPrintLessonReceiptClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBaseTitle: string;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FInputBuffer: string; //�����е� �Է¹���
    FCategoryButtons: TArray<TcyAdvSpeedButton>;
    FSaleItemButtons: TArray<TSolbiTouchButton>;
    FMemberSearchMode: Boolean;
    FWorking: Boolean;
    FTeeBoxOrderMemo: string;
    FTeeBoxLessonOrderMemo: string;
    FLessonOrderMemo: string;
    FFacilityOrderMemo: string;
    FLockerOrderMemo: string;
    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure StartUp;
    procedure ShowHome;
    procedure DoAffiliateApproval;
    procedure DispAffiliateResult;
    procedure ClearSaleData;
    procedure DispSaleResult;
    procedure DoMemberSearchNew(const AMemberName, AHpNo, ACarNo: string);
    procedure DispMemberInfo;
    function SetProductAmt: Integer;
    procedure SetInputBuffer(const AValue: string);
    procedure ClearTeeBoxSelection;
    procedure ClearOrderMemo;
    procedure DeleteOrderMemo(const AProdDiv, AChildProdDiv: string);
    procedure RefreshOrderMemo;
    procedure PrintLessonReceipt;
    procedure SetTableTitle;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
    procedure CategoryMenuCallBack(const ACategoryIndex: Integer);
    procedure SaleItemMenuCallback(const ACategoryIndex, AItemPage: Integer);
    property InputBuffer: string read FInputBuffer write SetInputBuffer;
    property TeeBoxOrderMemo: string read FTeeBoxOrderMemo write FTeeBoxOrderMemo;
    property TeeBoxLessonOrderMemo: string read FTeeBoxLessonOrderMemo write FTeeBoxLessonOrderMemo;
    property LessonOrderMemo: string read FLessonOrderMemo write FLessonOrderMemo;
    property FacilityOrderMemo: string read FFacilityOrderMemo write FFacilityOrderMemo;
    property LockerOrderMemo: string read FLockerOrderMemo write FLockerOrderMemo;
  end;
var
  XGSalePosForm: TXGSalePosForm;
implementation
uses
  Graphics, Variants, dxCore, cxGridCommon, DateUtils, StrUtils, JSON,
  uVanDaemonModule, uPaycoNewModule,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGInputProdAmt, uXGInputStartLesson,
  uXGMsgBox, uXGInputStartDate, uXGCalc, uXGReceiptPrint, uXGLessonReceipt;
{$R *.dfm}
{ TXGSalePosForm }
constructor TXGSalePosForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I: Integer;
begin
  inherited Create(AOwner, AMsg);
  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FIsFirst := True;
  FBaseTitle := panHeader.Caption;
  FMemberSearchMode := False;
  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;
  btnTeeBoxView.Enabled := (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]);
  btnLockerView.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnBack.Visible := (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]);
  panBasePanel.Top := 0;
  panBasePanel.Left := (Self.Width div 2) - (panBasePanel.Width div 2);
  panBasePanel.Width := 1366; //������
  panBasePanel.Height := wppBack.Height;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';
  //���޻�(����Ŭ��,��������Ŭ��,��������) ȸ�� ����
  btnAffiliate.Enabled := (
    Global.WelbeingClub.Enabled or
    Global.RefreshClub.Enabled or
    Global.RefreshGolf.Enabled or
    Global.IKozen.Enabled or
    Global.Smartix.Enabled);
  //������ ������ ����
  btnPrintLessonReceipt.Enabled := Global.UseLessonReceipt;
  //�δ�ü� �̿�� ����
  btnAddonTicket.Enabled := (Global.AddOnTicket.ParkingTicket or Global.AddOnTicket.SaunaTicket or Global.AddOnTicket.FitnessTicket);
  ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
  DispAffiliateResult;
  with pgcExtPage do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;
  SetLength(FCategoryButtons, LCN_CATEGORY_MAX);
  for i := 0 to Pred(LCN_CATEGORY_MAX) do
  begin
    FCategoryButtons[i] := TcyAdvSpeedButton(FindComponent('btnCategory' + IntToStr(i + 1)));
    with FCategoryButtons[i] do
    begin
      Tag := i;
      Caption := '';
      OnClick := OnCategoryButtonClick;
    end;
  end;
  SetLength(FSaleItemButtons, LCN_SALEITEM_MAX);
  for i := 0 to Pred(LCN_SALEITEM_MAX) do
  begin
    FSaleItemButtons[i] := TSolbiTouchButton(FindComponent('btnSaleItem' + IntToStr(i + 1)));
    with TSolbiTouchButton(FSaleItemButtons[i]) do
    begin
      Tag := -1;
      Caption.FirstCaption.Text := '';
      Caption.SecondCaption.Text := '';
      Caption.ThirdCaption.Text := '';
      OnClick := OnSaleItemButtonClick;
    end;
  end;
  ClearSaleData;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;
procedure TXGSalePosForm.btnPayCashClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
    Exit;
  try
    if (SaleManager.ReceiptInfo.CashPayAmt > 0) then
      raise Exception.Create('�̹� �������� ������ ������ �ֽ��ϴ�!' + _CRLF +
        '�ٽ� �����Ϸ��� ����� ���ݰ��� ������ ����Ͽ� �ֽʽÿ�.');
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_APPROVAL_YN, True);
      PM.AddParams(CPP_SALEMODE_YN, True);
      PM.AddParams(CPP_RECEIPT_NO, SaleManager.ReceiptInfo.ReceiptNo);
      PM.AddParams(CPP_APPROVAL_NO, '');
      PM.AddParams(CPP_APPROVAL_DATE, '');
      PM.AddParams(CPP_APPROVAL_AMT, SaleManager.ReceiptInfo.UnpaidTotal);
      if (PluginManager.OpenModal('XGCashApprove' + CPL_EXTENSION, PM) = mrOK) then
      begin
        btnPayment.Click;
        if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
          btnSaleComplete.Click;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnReCalcCouponClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if ClientDM.ReCalcCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg) then
    ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList)
  else
    XGMsgBox(Self.Handle, mtWarning, '�˸�', '���������� ������ �� �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
end;
procedure TXGSalePosForm.btnReceiptViewClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  TcyAdvSpeedButton(Sender).Enabled := False;
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('XGReceiptView' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
    TcyAdvSpeedButton(Sender).Enabled := True;
  end;
end;
procedure TXGSalePosForm.btnPayCardClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      Exit;
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_APPROVAL_YN, True);
      PM.AddParams(CPP_SALEMODE_YN, True);
      PM.AddParams(CPP_RECEIPT_NO, SaleManager.ReceiptInfo.ReceiptNo);
      PM.AddParams(CPP_APPROVAL_NO, '');
      PM.AddParams(CPP_APPROVAL_DATE, '');
      PM.AddParams(CPP_APPROVAL_AMT, SaleManager.ReceiptInfo.UnpaidTotal);
      if (PluginManager.OpenModal('XGCardApprove' + CPL_EXTENSION, PM) = mrOK) then
      begin
        btnPayment.Click;
        if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
          btnSaleComplete.Click;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
destructor TXGSalePosForm.Destroy;
begin
  inherited Destroy;
end;
procedure TXGSalePosForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
  panBasePanel.SetFocus;
end;
procedure TXGSalePosForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := 0;
end;
procedure TXGSalePosForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
procedure TXGSalePosForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
end;
procedure TXGSalePosForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;
procedure TXGSalePosForm.PluginModuleShow(Sender: TObject);
begin
  btnV1Up.Height := (G1.Height div 2);
  btnV2Up.Height := (pgcExtPage.Height div 2);
  btnV3Up.Height := (pgcExtPage.Height div 2);
end;
procedure TXGSalePosForm.ProcessMessages(AMsg: TPluginMessage);
var
  nCount: Integer;
  sValue, sCondDiv, sErrMsg: string;
begin
  try
    if (AMsg.Command = CPC_INIT) then
    begin
      FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
      SetTableTitle;
      DispMemberInfo;
    end;
    if (AMsg.Command = CPC_CLOSE) or
       (AMsg.Command = CPC_TEEBOX_EMERGENCY) then
      Close;
    if (AMsg.Command = CPC_SET_FOREGROUND) then
    begin
      SetTableTitle;
      if (GetForegroundWindow <> Self.Handle) then
        SetForegroundWindow(Self.Handle);
    end;
    if (AMsg.Command = CPC_ACTIVE_TABLE) then
      SetTableTitle;
    if (AMsg.Command = CPC_TEEBOX_COUNTER) then
    begin
      ledReadyCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_READY_COUNT));
      ledPlayingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_PLAYING_COUNT));
      ledWaitingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_WAITING_COUNT));
      ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
    end;
    if (AMsg.Command = CPC_SEND_TEEBOX_PROD_CD) then
    begin
      if not ClientDM.UpdateSaleList(
          Global.TableInfo.ActiveTableNo,
          Global.TableInfo.DelimitedGroupTableList,
          CPD_TEEBOX,
          AMsg.ParamByString(CPP_TEEBOX_PROD_DIV),
          AMsg.ParamByString(CPP_PRODUCT_CD),
          AMsg.ParamByString(CPP_PRODUCT_NAME),
          '', //use_start_date
          '', //lesson_pro_cd
          AMsg.ParamByInteger(CPP_PRODUCT_AMT),
          AMsg.ParamByInteger(CPP_XGOLF_DC_AMT),
          AMsg.ParamByInteger(CPP_PRODUCT_QTY),
          0, 0, sErrMsg) then
        raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg);
      if AMsg.ParamByBoolean(CPP_AFFILIATE_YN) then
      begin
        AffiliateRec.Clear;
        AffiliateRec.PartnerCode := AMsg.ParamByString(CPP_AFFILIATE_CODE);
        AffiliateRec.ItemCode := AMsg.ParamByString(CPP_AFFILIATE_ITEM);
        DoAffiliateApproval;
      end;
    end;
    //�������� ��ĵ ���(From Dashboard)
    if (AMsg.Command = CPC_SEND_QRCODE_COUPON) then
    begin
      sValue := AMsg.ParamByString(CPP_QRCODE);
      if (not ClientDM.GetCouponInfo(sValue, sErrMsg)) then
        raise Exception.Create('ȸ�� ������ �νĵ��� �ʾҰų�' + _CRLF +
          '��� ������ ���� ������ �����ϴ�!' + _CRLF + sErrMsg);
    end;
    //��ĵ�� ���������� ��� ���� ���� �˻�
    if (AMsg.Command = CPC_SEND_COUPON_INFO) then
    try
      if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
         (CouponRec.MemberNo <> SaleManager.MemberInfo.MemberNo) then
        raise Exception.Create('�� ȸ���� ����� �� ���� �����Դϴ�!');
      if ClientDM.QRCoupon.LocateRecord('qr_code', CouponRec.QrCode, []) then
        raise Exception.Create('�̹� ������ �����Դϴ�!');
      if (CouponRec.DcCondDiv <> CCU_REPEAT) and
         (ClientDM.QRCoupon.RecordCount > 0) then
        raise Exception.Create('�ߺ������� ������ �� ���� �����Դϴ�!');
      if (CouponRec.StartDay > Global.CurrentDate) or
         (CouponRec.ExpireDay < Global.CurrentDate) or
         (CouponRec.UseCnt = 0) or
         (CouponRec.UseYN = CRC_YES) then
        raise Exception.Create('����� �� ���� �����Դϴ�!');
      if (CouponRec.ProductDiv = CPD_TEEBOX) then
      begin
        if not ClientDM.CheckAllowedTeeBoxCoupon(CouponRec.TeeBoxProdDiv, sErrMsg) then
          raise Exception.Create('����� �� ���� �����Դϴ�!' + _CRLF + sErrMsg);
      end;
      sCondDiv := IIF(CouponRec.DcCondDiv = CCU_REPEAT, '�ߺ�', IIF(CouponRec.DcCondDiv = CCU_EXCLUSIVE, '�ܵ�', '')) + '����';
      nCount := ClientDM.ApplyCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg);
      if (nCount = 0) then
        raise Exception.Create(IIF(sErrMsg.IsEmpty, '����� �� ���� �����Դϴ�!', sErrMsg) + _CRLF +
          Format('������ : [%s] %s', [sCondDiv, CouponRec.CouponName]) + _CRLF +
          Format('���Ⱓ : %s ~ %s', [CouponRec.StartDay, CouponRec.ExpireDay]) + _CRLF +
          Format('�ܿ�Ƚ�� : %d (%s)', [CouponRec.UseCnt, CouponRec.UseStatus]));
      ClientDM.AddDiscountCoupon(Global.TableInfo.ActiveTableNo);
      ClientDM.RefreshCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      ClientDM.ReCalcCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    finally
      CouponRec.Clear;
    end;
    //��ȯ��ǰ ���
    if (AMsg.Command = CPC_CHANGE_PROD_SALE) then
    begin
      SaleManager.ReceiptInfo.ProdChangeSale := True;
      mmoSaleMemo.Text := SaleManager.ReceiptInfo.SaleMemo;
      if not ClientDM.UpdateSaleList(
          Global.TableInfo.ActiveTableNo,
          Global.TableInfo.DelimitedGroupTableList,
          CPD_TEEBOX,
          CTP_CHANGE,
          ChangeProdRec.ProductCode,
          ChangeProdRec.ProductName,
          '', //use_start_date
          '', //lesson_pro_cd
          ChangeProdRec.SaleAmt,
          0, 1, 0, 0, sErrMsg) then
        raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg);
    end;
    //�������� ȸ�� QR�ڵ� ��ĵ
    if (AMsg.Command = CPC_SEND_QRCODE_XGOLF) then
    begin
      if (XGMsgBox(Self.Handle, mtConfirmation, 'XGOLF ȸ�� ����',
            'XGOLF QR�ڵ尡 �νĵǾ����ϴ�!' + _CRLF +
            'XGOLF ȸ�� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
        Exit;
      sValue := AMsg.ParamByString(CPP_QRCODE);
      if not ClientDM.CheckXGolfMemberNew(CVT_XGOLF_QRCODE, sValue, sErrMsg) then
        raise Exception.Create('XGOLF ȸ�� ������ �����Ͽ����ϴ�!');
      ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
      if not ClientDM.SearchMemberByCode(CMC_XGOLF_QRCODE, sValue, sErrMsg) then
      begin
        if (XGMsgBox(Self.Handle, mtConfirmation, '��ȸ�� XGOLF ����',
            '�νĵ� XGOLF QR�ڵ�� �츮 ������ ȸ���� �ƴմϴ�.' + _CRLF +
            'XGOLF ���� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
          Exit;
        SaleManager.MemberInfo.XGolfMemberNo := sValue;
      end;
      DispMemberInfo;
    end;
    //ȸ�� �˻�
    if (AMsg.Command = CPC_SEND_QRCODE_MEMBER) or
       (AMsg.Command = CPC_SEND_MSCARD_MEMBER) then
    begin
      if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
         (XGMsgBox(Self.Handle, mtConfirmation, 'ȸ�� �˻�',
            'ȸ�� QR�ڵ尡 �νĵǾ����ϴ�!' + _CRLF +
            'ȸ�� ������ ��˻��Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
        Exit;
      sValue := AMsg.ParamByString(CPP_QRCODE);
      if not ClientDM.SearchMemberByCode(CMC_MEMBER_QRCODE, sValue, sErrMsg) then
        raise Exception.Create('��ġ�ϴ� ȸ�� ������ �����ϴ�!' + _CRLF + sErrMsg);
      DispMemberInfo;
    end;
    //����� ī���ȣ�� ȸ�� �˻�
    if (AMsg.Command = CPC_SEND_RFID_DATA) then
    begin
      if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
         (XGMsgBox(Self.Handle, mtConfirmation, 'ȸ�� �˻�',
            '����� ī���ȣ�� �νĵǾ����ϴ�!' + _CRLF +
            'ȸ�� ������ ��˻��Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
        Exit;
      sValue := AMsg.ParamByString(CPP_MEMBER_CARD_UID);
      if not ClientDM.SearchMemberByCode(CMC_MEMBER_CARD_UID, sValue, sErrMsg) then
        raise Exception.Create('��ġ�ϴ� ȸ�� ������ �����ϴ�!' + _CRLF + sErrMsg);
      DispMemberInfo;
    end;
    //��ǰ �˻�
    if (AMsg.Command = CPC_SELECT_PROD_ITEM) then
      if not ClientDM.UpdateSaleList(
          Global.TableInfo.ActiveTableNo,
          Global.TableInfo.DelimitedGroupTableList,
          AMsg.ParamByString(CPP_PRODUCT_DIV),
          '', //teebox_prod_div
          AMsg.ParamByString(CPP_PRODUCT_CD),
          AMsg.ParamByString(CPP_PRODUCT_NAME),
          '', //use_start_date
          '', //lesson_pro_cd
          AMsg.ParamByInteger(CPP_PRODUCT_AMT),
          0, 1, 0, 0, sErrMsg) then
        raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg);
    //ȸ�� �˻� ���
    if (AMsg.Command = CPC_SEND_MEMBER_NO) or
       (AMsg.Command = CPC_SEND_MEMBER_CLEAR) then
      DispMemberInfo;
    //���޻� ���� ���
    if (AMsg.Command = CPC_AFFILIATE_REFRESH) then
      DispAffiliateResult;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('SalePos.ProcessMessages.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
    end;
  end;
end;
procedure TXGSalePosForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not ((ssAlt in Shift) or
          (ssCtrl in Shift) or
          (ssShift in Shift)) then
  begin
    case Key of
      VK_F1:
        btnPayCard.Click;
      VK_F2:
        btnPayCash.Click;
      VK_F3:
        btnReceiptView.Click;
      VK_F4:
        btnMemberNew.Click;
      VK_F5:
        btnMemberSearch.Click;
      VK_F6:
        btnSaleMemberClear.Click;
      VK_F7:
        btnLockerView.Click;
      VK_F8:
        btnPayment.Click;
      VK_F9:
        btnCoupon.Click;
      VK_F10:
        btnAffiliate.Click;
      VK_F11:
        btnSaleSearchProduct.Click;
      VK_F12:
        btnTeeBoxView.Click;
      VK_RETURN:
        if not FMemberSearchMode then
          btnSaleComplete.Click;
      VK_ADD:
        if (not mmoSaleMemo.Focused) then
          btnSaleItemIncQty.Click;
      VK_SUBTRACT:
        if (not mmoSaleMemo.Focused) then
          btnSaleItemDecQty.Click;
    end;
  end
  else
  begin
    if (ssAlt in Shift) and (Key = VK_F10) then
      btnCalculator.Click;
  end;
end;
procedure TXGSalePosForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    FTimeBlink := (not FTimeBlink);
    lblClockDate.Caption := Global.FormattedCurrentDate;
    lblClockWeekday.Caption := Format('(%s)', [Global.DayOfWeekKR]);
    lblClockHours.Caption := Copy(Global.CurrentTime, 1, 2);
    lblClockMins.Caption := Copy(Global.CurrentTime, 3, 2);
    lblClockSepa.Caption := IIF(FTimeBlink, '', ':');
    if FIsFirst then
    begin
      FIsFirst := False;
      Interval := 500;
      StartUp;
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;
procedure TXGSalePosForm.StartUp;
begin
  with SaleManager.SaleMenuManager do
  begin
    CategoryPerPage := LCN_CATEGORY_MAX;
    ItemPerPage := LCN_SALEITEM_MAX;
    btnCategoryPrev.Enabled := (ActiveCategoryPage > 0);
    btnCategoryNext.Enabled := (ActiveCategoryPage < Pred(CategoryPageCount));
    SetCategoryPage(0, CategoryMenuCallback);
  end;
  OnCategoryButtonClick(FCategoryButtons[0]);
  FCategoryButtons[0].Down := True;
end;
procedure TXGSalePosForm.ShowHome;
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SET_FOREGROUND;
    PluginMessageToID(Global.StartModuleId);
  finally
    Free;
  end;
end;
procedure TXGSalePosForm.CategoryMenuCallBack(const ACategoryIndex: Integer);
var
  nButton, nCategory: integer;
  sCategoryName: string;
begin
  for nButton := 0 to Pred(SaleManager.SaleMenuManager.CategoryPerPage) do
  begin
    nCategory := (SaleManager.SaleMenuManager.ActiveCategoryPage * SaleManager.SaleMenuManager.CategoryPerPage) + nButton;
    if (nCategory < SaleManager.SaleMenuManager.GetCategoryCount) then
    begin
      sCategoryName := SaleManager.SaleMenuManager.Categories[nCategory].CategoryName;
      FCategoryButtons[nButton].Caption := StringReplace(SaleManager.SaleMenuManager.Categories[nCategory].CategoryName, ' ', _CRLF, []);
      FCategoryButtons[nButton].Enabled := True;
      FCategoryButtons[nButton].Tag := nCategory;
    end else
    begin
      FCategoryButtons[nButton].Caption := '';
      FCategoryButtons[nButton].Enabled := False;
      FCategoryButtons[nButton].Tag := -1;
    end;
  end;
  btnCategoryPrev.Enabled := (SaleManager.SaleMenuManager.ActiveCategoryPage > 0);
  btnCategoryNext.Enabled := (SaleManager.SaleMenuManager.ActiveCategoryPage < Pred(SaleManager.SaleMenuManager.CategoryPageCount));
  OnCategoryButtonClick(FCategoryButtons[0]);
  FCategoryButtons[0].Down := True;
end;
procedure TXGSalePosForm.SaleItemMenuCallback(const ACategoryIndex, AItemPage: Integer);
var
  nButton, nItem: Integer;
  sProdDiv: string;
begin
  for nButton := 0 to Pred(SaleManager.SaleMenuManager.ItemPerPage) do
  begin
    nItem := (SaleManager.SaleMenuManager.ActiveItemPage * SaleManager.SaleMenuManager.ItemPerPage) + nButton;
    if (nItem <= Pred(SaleManager.SaleMenuManager.GetItemCount(ACategoryIndex))) then
    begin
      FSaleItemButtons[nButton].Visible := True;
      FSaleItemButtons[nButton].Caption.FirstCaption.Text := SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductName;
      sProdDiv := SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductDiv;
      if (sProdDiv = CPD_TEEBOX) then
      begin
        FSaleItemButtons[nButton].Caption.SecondCaption.Text := Format('[%s - %s]',
          [SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProdStartTime, SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProdEndTime]);
        FSaleItemButtons[nButton].Caption.ThirdCaption.Text := FormatCurr(',0', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductAmt) +
          ' (' + FormatCurr(',0', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].XGolfProdAmt) + ')';
      end
      else if (sProdDiv = CPD_LOCKER) then
      begin
        FSaleItemButtons[nButton].Caption.SecondCaption.Text :=
          FormatFloat('[������: #,##0]', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].KeepAmt);
        FSaleItemButtons[nButton].Caption.ThirdCaption.Text := FormatCurr(',0', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductAmt);
      end
      else
      begin
        FSaleItemButtons[nButton].Caption.SecondCaption.Text := '';
        FSaleItemButtons[nButton].Caption.ThirdCaption.Text := FormatCurr(',0', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductAmt);
      end;
      FSaleItemButtons[nButton].Tag := nItem;
    end else
    begin
      FSaleItemButtons[nButton].Visible := False;
      FSaleItemButtons[nButton].Caption.FirstCaption.Text := '';
      FSaleItemButtons[nButton].Caption.SecondCaption.Text := '';
      FSaleItemButtons[nButton].Caption.ThirdCaption.Text := '';
      FSaleItemButtons[nButton].Tag := -1;
    end;
  end;
//  btnSaleItemPrev.Enabled := (SaleManager.SaleMenuManager.ActiveItemPage > 0);
//  btnSaleItemNext.Enabled := (SaleManager.SaleMenuManager.ActiveItemPage < Pred(SaleManager.SaleMenuManager.ItemPageCount[SaleManager.SaleMenuManager.ActiveItemPage]));
end;
procedure TXGSalePosForm.bntPayVoucherClick(Sender: TObject);
begin
//
end;
procedure TXGSalePosForm.btnAddPendingClick(Sender: TObject);
var
  sErrMsg: string;
begin
  try
    if (ClientDM.QRSaleItem.RecordCount = 0) and
       (ClientDM.QRPayment.RecordCount = 0) then
      raise Exception.Create('������ ����� �Ǹų����� �����ϴ�!');
    (*
    if SaleManager.ReceiptInfo.ProdChangeSale then
      raise Exception.Create('ȸ���� ��ȯ ��ǰ�� ������ ����� ��  �����ϴ�!');
    *)
    if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          '���� �ֹ������� �������·� ����Ͻðڽ��ϱ�?', ['�������', '���']) = mrOK) then
    begin
      if not ClientDM.AddPending(Global.TableInfo.ActiveTableNo, sErrMsg) then
        raise Exception.Create(sErrMsg);
      //�Ǹ� �ʱ�ȭ
      ClearSaleData;
      ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
      DispMemberInfo;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnAffiliateClick(Sender: TObject);
begin
  DoAffiliateApproval;
end;
procedure TXGSalePosForm.btnBackClick(Sender: TObject);
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
  begin
    if (ClientDM.QRPayment.RecordCount = 0) and
       (ClientDM.QRSaleItem.RecordCount > 0) then
    begin
      if SaleManager.ReceiptInfo.ProdChangeSale then
        SaleManager.ReceiptInfo.ProdChangeSale := False;
      ClientDM.ClearSaleItemTable(Global.TableInfo.ActiveTableNo);
      ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo);
      ClearOrderMemo;
    end;
    ShowTeeBoxView(Self.PluginID);
  end;
end;
procedure TXGSalePosForm.btnCalculatorClick(Sender: TObject);
var
  dValue: Double;
begin
  ShowCalculator(dValue);
end;
procedure TXGSalePosForm.btnCancelCouponClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with ClientDM.QRCoupon do
  try
    if (RecordCount > 0) then
    begin
      if not ExecuteABSQuery(
          Format('DELETE FROM TBCoupon WHERE table_no = %d AND coupon_seq = %d AND qr_code = %s', [
            Global.TableInfo.ActiveTableNo,
            FieldByName('coupon_seq').AsInteger,
            QuotedStr(FieldByName('qr_code').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      if not ClientDM.ReCalcCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '���� ���γ����� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnCategoryPrevClick(Sender: TObject);
var
  nNewPage: Integer;
begin
  with SaleManager.SaleMenuManager do
  begin
    nNewPage := Pred(ActiveCategoryPage);
    if (nNewPage < 0) then
      nNewPage := Pred(CategoryPageCount);
    SetCategoryPage(nNewPage, CategoryMenuCallback);
  end;
end;
procedure TXGSalePosForm.btnCategoryNextClick(Sender: TObject);
var
  nNewPage: Integer;
begin
  with SaleManager.SaleMenuManager do
  begin
    nNewPage := Succ(ActiveCategoryPage);
    if (nNewPage > Pred(CategoryPageCount)) then
      nNewPage := 0;
    SetCategoryPage(nNewPage, CategoryMenuCallback);
  end;
end;
procedure TXGSalePosForm.btnSaleItemPrevClick(Sender: TObject);
var
  nNewPage: integer;
begin
  with SaleManager.SaleMenuManager do
  begin
    nNewPage := Pred(ActiveItemPage);
    if (nNewPage < 0) then
      nNewPage := Pred(ItemPageCount[CurrentCategoryIndex]);
    SetItemPage(CurrentCategoryIndex, nNewPage, SaleItemMenuCallback);
  end;
end;
procedure TXGSalePosForm.btnSaleMemberClearClick(Sender: TObject);
begin
  ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
  DispMemberInfo;
end;
procedure TXGSalePosForm.btnSaleSearchProductClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('XGProductList' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;
procedure TXGSalePosForm.btnShowMemberInfoClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_CLOSE;
    PM.PluginMessageToID(Global.WebViewId);
  finally
    FreeAndNil(PM);
  end;
  ShowPartnerCenter(Self.PluginID, Format('member/memberDetail?member_seq=%d', [SaleManager.MemberInfo.MemberSeq]));
end;
procedure TXGSalePosForm.btnSalePartnerCenterClick(Sender: TObject);
begin
  btnPartnerCenter.Click;
end;
procedure TXGSalePosForm.btnTeeBoxProdChangeClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    if SaleManager.ReceiptInfo.ProdChangeSale then
      Exit;
    if (ClientDM.QRSaleItem.RecordCount > 0) then
      raise Exception.Create('ȸ���� ��ȯ ��ǰ�� �ٸ� ��ǰ�� ���� �Ǹ��� �� �����ϴ�!');
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      if (PluginManager.OpenModal('XGTeeBoxProdChange' + CPL_EXTENSION, PM) = mrOK) then
      begin
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, 'ȸ���� ��ȯ', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnTeeBoxViewClick(Sender: TObject);
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
    btnBack.Click;
end;
procedure TXGSalePosForm.btnSaleItemNextClick(Sender: TObject);
var
  nNewPage: Integer;
begin
  with SaleManager.SaleMenuManager do
  begin
    nNewPage := Succ(ActiveItemPage);
    if (nNewPage > Pred(ItemPageCount[CurrentCategoryIndex])) then
      nNewPage := 0;
    SetItemPage(CurrentCategoryIndex, nNewPage, SaleItemMenuCallback);
  end;
end;
procedure TXGSalePosForm.btnSaleItemDeleteClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) then
    begin
      if SaleManager.ReceiptInfo.ProdChangeSale then
        SaleManager.ReceiptInfo.ProdChangeSale := False;
      if not ExecuteABSQuery(
          Format('DELETE FROM TBSaleItem WHERE table_no = %d AND product_cd = %s', [
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      DeleteOrderMemo(FieldByName('product_div').AsString, FieldByName('teebox_prod_div').AsString);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      if (RecordCount = 0) then
      begin
        ClearOrderMemo;
        if (ClientDM.QRPayment.RecordCount = 0) then
          ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      end;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ�� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnSaleItemClearClick(Sender: TObject);
begin
  if (ClientDM.QRSaleItem.RecordCount > 0) and
     (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '�ֹ� ������ ��� ����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK) then
  begin
    if SaleManager.ReceiptInfo.ProdChangeSale then
      SaleManager.ReceiptInfo.ProdChangeSale := False;
    ClientDM.ClearSaleItemTable(Global.TableInfo.ActiveTableNo);
    ClearOrderMemo;
    if (ClientDM.QRPayment.RecordCount = 0) then
      ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo);
 end;
end;
procedure TXGSalePosForm.btnSaleItemIncQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sProdDiv, sDetailDiv, sErrMsg: string;
begin
  if SaleManager.ReceiptInfo.ProdChangeSale then
    Exit;
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) then
    begin
      //��Ŀ �� �繰�Ժ�����, �������� ����/���� ��ǰ, ����Ÿ����ǰ�� ���� ���� �Ұ�
      //�ü���ǰ�� ����(20230323)
      sProdDiv := FieldByName('product_div').AsString;
      sDetailDiv := FieldByName('teebox_prod_div').AsString;
      if (sProdDiv = CPD_LOCKER) or
         (sProdDiv = CPD_LESSON) or
         (sProdDiv = CPD_RESERVE) or
         ((sProdDiv = CPD_TEEBOX) and (sDetailDiv = CTP_DAILY)) then
        Exit;
      nOrderQty := Succ(FieldByName('order_qty').AsInteger);
      if not ExecuteABSQuery(
          Format('UPDATE TBSaleItem SET order_qty = %d WHERE table_no = %d AND product_cd = %s', [
            nOrderQty,
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ�� ������ ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnSaleItemDecQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sErrMsg: string;
begin
  if SaleManager.ReceiptInfo.ProdChangeSale then
    Exit;
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) then
    begin
      nOrderQty := Pred(FieldByName('order_qty').AsInteger);
      if (nOrderQty = 0) then
      begin
        if not ExecuteABSQuery(
            Format('DELETE FROM TBSaleItem WHERE table_no = %d AND product_cd = %s', [
              Global.TableInfo.ActiveTableNo,
              QuotedStr(FieldByName('product_cd').AsString)]),
            sErrMsg) then
          raise Exception.Create(sErrMsg);
        DeleteOrderMemo(FieldByName('product_div').AsString, FieldByName('teebox_prod_div').AsString);
        ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
        if (RecordCount = 0) and
           (ClientDM.QRPayment.RecordCount = 0) then
          ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      end
      else
      begin
        if not ExecuteABSQuery(
            Format('UPDATE TBSaleItem SET order_qty = %d WHERE table_no = %d AND product_cd = %s', [
              nOrderQty,
              Global.TableInfo.ActiveTableNo,
              QuotedStr(FieldByName('product_cd').AsString)]),
            sErrMsg) then
          raise Exception.Create(sErrMsg);
        ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      end;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ�� ������ ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnSaleItemChangeQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sProdDiv, sDetailDiv, sErrMsg: string;
begin
  if SaleManager.ReceiptInfo.ProdChangeSale then
    Exit;
  nOrderQty := StrToIntDef(InputBuffer, 0);
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) and
       (nOrderQty > 0) then
    begin
      //��Ŀ �� �繰�Ժ�����, �������� ����/���� ��ǰ, ����Ÿ����ǰ ���� ���� �Ұ�
      //�ü���ǰ�� ����(20230323)
      sProdDiv := FieldByName('product_div').AsString;
      sDetailDiv := FieldByName('teebox_prod_div').AsString;
      if (nOrderQty > 1) and
         ((sProdDiv = CPD_LOCKER) or
          (sProdDiv = CPD_LESSON) or
          (sProdDiv = CPD_RESERVE) or
          ((sProdDiv = CPD_TEEBOX) and (sDetailDiv = CTP_DAILY))) then
        Exit;
      if not ExecuteABSQuery(
          Format('UPDATE TBSaleItem SET order_qty = %d WHERE table_no = %d AND product_cd = %s', [
            nOrderQty,
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      btnNumClear.Click;
      InputBuffer := '0';
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ�� ������ ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnCouponCardClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_SCAN_MODE, CMC_MEMBER_MSCARD);
      PluginManager.OpenModal('XGCouponCard' + CPL_EXTENSION, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '(��)ȸ�� MSī��� �˻�' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnHomeClick(Sender: TObject);
begin
  ShowHome;
end;
procedure TXGSalePosForm.btnItemDiscountCancelClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) and
       (FieldByName('direct_dc_amt').AsInteger > 0) then
    begin
      if not ExecuteABSQuery(
          Format('UPDATE TBSaleItem SET direct_dc_amt = 0 WHERE table_no = %d AND product_cd = %s', [
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�������� ���' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnPrintLessonReceiptClick(Sender: TObject);
begin
  PrintLessonReceipt;
end;
procedure TXGSalePosForm.btnLoadPendingClick(Sender: TObject);
var
  PM: TPluginMessage;
  sMemberNo, sErrMsg: string;
begin
  try
    if (ClientDM.QRSaleItem.RecordCount <> 0) or
       (ClientDM.QRPayment.RecordCount <> 0) then
      raise Exception.Create('�Ϸ���� ���� �ŷ��� �־ ���������� ������ �� �����ϴ�!');
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      if (PluginManager.OpenModal('XGPendingView' + CPL_EXTENSION, PM) = mrOK) then
      begin
        DispSaleResult;
        if (ClientDM.QRReceipt.RecordCount > 0) then
        begin
          sMemberNo := ClientDM.QRReceipt.FieldByName('member_no').AsString;
          if not sMemberNo.IsEmpty then
          begin
            ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
            DispMemberInfo;
            if not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg) then
              raise Exception.Create('���������� ���������� ����������' + _CRLF +
                '�ش� ������ ��ϵ� ȸ�� ������ ��ȿ���� �ʽ��ϴ�!');
            DispMemberInfo;
          end;
        end;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnLockerViewClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  TcyAdvSpeedButton(Sender).Enabled := False;
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_LOCKER_SELECT, False);
    PluginManager.OpenModal('XGLocker' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
    TcyAdvSpeedButton(Sender).Enabled := True;
  end;
end;
procedure TXGSalePosForm.btnNumBSClick(Sender: TObject);
begin
  if not InputBuffer.IsEmpty then
  begin
    InputBuffer := Trim(Copy(InputBuffer, 1, Pred(Length(InputBuffer))));
//    if (SaleManager.ReceiptInfo.ReceiptSaleType = CSP_RETURN_RECEIPT) then
//      edtInputCapture.Text := InputBuffer
  end;
end;
procedure TXGSalePosForm.btnNumCLClick(Sender: TObject);
begin
  InputBuffer := '';
end;
procedure TXGSalePosForm.btnOpenDrawerClick(Sender: TObject);
begin
  OpenCashDrawer;
end;
procedure TXGSalePosForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;
procedure TXGSalePosForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;
procedure TXGSalePosForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;
procedure TXGSalePosForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;
procedure TXGSalePosForm.OnNumPadClick(Sender: TObject);
begin
  with TcyAdvSpeedButton(Sender) do
    InputBuffer := InputBuffer + StringOfChar(Chr(Tag), HelpContext);
end;
procedure TXGSalePosForm.btnSaleCompleteClick(Sender: TObject);
var
  nDailyTeeBoxCount, nMemberOnlyCount, I: Integer;
  sErrMsg, sReceiptJson, sDelayMsg, sStampProdCd: string;
  bTeeBoxSuccess: Boolean;
  SL: TStringList;
  DataSet: TDataSet;
  bStampYn: Boolean;
  PM: TPluginMessage;
label
  GO_TEEBOX_RETRY;
begin
  if FWorking then
    Exit;
  FWorking := True;
  TcyAdvSpeedButton(Sender).Enabled := False;
  try
    try
      if (ClientDM.QRSaleItem.RecordCount = 0) then
        Exit; //raise Exception.Create('��ǰ �Ǹ� ������ ��ϵ��� �ʾҽ��ϴ�!');
      if (SaleManager.ReceiptInfo.ReceiveTotal > SaleManager.ReceiptInfo.ChargeTotal) then
        raise Exception.Create('������ �ݾ��� ���� �ݾ׺��� �� �����ϴ�!');
      SL := TStringList.Create;
      try
        if (ClientDM.MDTeeBoxSelected.RecordCount > 0) and
           (not (ClientDM.CheckTeeBoxHoldTime(SL, sErrMsg))) then
        begin
          sDelayMsg := 'Ÿ�� ���� �����ð��� ����Ǿ����ϴ�!' + _CRLF +
                       '����� �ð����� �����Ͻðڽ��ϱ�?' + _CRLF + _CRLF;
          for I := 0 to Pred(SL.Count) do
            sDelayMsg := sDelayMsg + SL.Strings[I] + _CRLF;
          if (XGMsgBox(Self.Handle, mtConfirmation, '�˸�', sDelayMsg, ['��', '�ƴϿ�']) <> mrOK) then
            raise Exception.Create('Ÿ�� ������ ��ҵǾ����ϴ�!');
        end;
      finally
        SL.Free;
      end;
      if (SaleManager.ReceiptInfo.UnPaidTotal > 0) then
      begin
        XGMsgBox(Self.Handle, mtWarning, '�˸�',
          '��ǰ �ݾ��� ������ �Ϸ���� �ʾҽ��ϴ�!' + _CRLF +
          '�̰����ݾ�: ' + FormatCurr('#,##0', SaleManager.ReceiptInfo.UnPaidTotal), ['Ȯ��']);
        Exit;
      end;
      if not ClientDM.CheckSaleItem(nDailyTeeBoxCount, nMemberOnlyCount, sErrMsg) then
        raise Exception.Create(sErrMsg);
      if SaleManager.MemberInfo.MemberNo.IsEmpty and
         (nMemberOnlyCount > 0) then
        raise Exception.Create('��ȸ������ �Ǹ��� �� ���� ��ǰ�� �Ǹų����� ���ԵǾ� �ֽ��ϴ�!');
      if (nDailyTeeBoxCount <> ClientDM.MDTeeBoxSelected.RecordCount) then
        raise Exception.Create('�ӽÿ��� Ÿ�� ���� ����Ÿ���� ��ǰ ���� ��ġ���� �ʽ��ϴ�!' + _CRLF +
          '����Ÿ�� �Ǵ� �ֹ���ǰ ������ �����Ͽ� �ֽʽÿ�.');
      if (mmoOrderMemo.Lines.Count > 0) then
        for I := 0 to Pred(mmoOrderMemo.Lines.Count) do
          mmoSaleMemo.Lines.Add(mmoOrderMemo.Lines[I]);
      SaleManager.ReceiptInfo.SaleMemo := mmoSaleMemo.Text;
      if SaleManager.ReceiptInfo.ProdChangeSale then
      begin
        if not ClientDM.PostProdSaleChange(Global.TableInfo.ActiveTableNo, sErrMsg) then
          raise Exception.Create('��ְ� �߻��Ͽ� ���� ����� �Ϸ��� �� �����ϴ�!' + _CRLF + sErrMsg);
      end
      else
      begin
        if not ClientDM.PostProdSale(Global.TableInfo.ActiveTableNo, sErrMsg) then
          raise Exception.Create('��ְ� �߻��Ͽ� ���� ����� �Ϸ��� �� �����ϴ�!' + _CRLF + sErrMsg);
      end;
      if SaleManager.ReceiptInfo.ParkingError then
        XGMsgBox(0, mtError, '�˸�', '��ְ� �߻��Ͽ� ������ ������ ����� �� �����ϴ�!' + _CRLF +
          '�������� �ý��ۿ��� ���� ����Ͽ� �ֽʽÿ�.' + _CRLF + SaleManager.ReceiptInfo.ParkingErrorMessage, ['Ȯ��'], 5);
      if SaleManager.ReceiptInfo.FacilityError then
        XGMsgBox(0, mtError, '�˸�', '�δ�ü� �̿�� ��Ͽ� ��ְ� �߻��Ͽ����ϴ�!' + _CRLF +
          SaleManager.ReceiptInfo.FacilityErrorMessage, ['Ȯ��'], 5);
      bTeeBoxSuccess := False;
      if (nDailyTeeBoxCount > 0) then
      begin
        if SaleManager.MemberInfo.MemberName.IsEmpty and
           (not AffiliateRec.MemberName.IsEmpty) then
          SaleManager.MemberInfo.MemberName := AffiliateRec.MemberName;
        //==============
        GO_TEEBOX_RETRY:
        //==============
        if Global.NoShowInfo.NoShowReserved then
          bTeeBoxSuccess := ClientDM.PostTeeBoxNoShowReserve(SaleManager.ReceiptInfo.ReceiptNo, AffiliateRec.PartnerCode, sErrMsg)
        else
          bTeeBoxSuccess := ClientDM.PostTeeBoxReserve(SaleManager.MemberInfo.MemberNo, SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.HpNo, SaleManager.ReceiptInfo.ReceiptNo, sErrMsg);
        if not bTeeBoxSuccess then
        begin
          if (XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
              '���� ����� �Ϸ��Ͽ����� Ÿ�� ������ ó������ ���Ͽ����ϴ�!' + _CRLF +
              '���� ��û�� ��õ� �Ͻðڽ��ϱ�?' + _CRLF + sErrMsg, ['��', '�ƴϿ�']) = mrOK) then
          goto GO_TEEBOX_RETRY;
          XGMsgBox(Self.Handle, mtWarning, 'Ÿ�� ���� ����', '�ŷ�������ȸ���� ������� �Ǵ� ���Ƿ� Ÿ���� �����Ͻʽÿ�!', ['Ȯ��']);
        end;
      end;
      try
        sReceiptJson := ClientDM.MakeReceiptJson(bTeeBoxSuccess and (nDailyTeeBoxCount > 0), sErrMsg);
        if not sErrMsg.IsEmpty then
          raise Exception.Create('������ ��������� �������� �ʾҽ��ϴ�!' + _CRLF + sErrMsg);
        Global.ReceiptPrint.IsReturn := False;
        if Global.DeviceConfig.ReceiptPrinter.Enabled then
          if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, False, Global.AddonTicket.PrintWithAssignTicket, sErrMsg) then
            raise Exception.Create(sErrMsg);
      except
        on E: Exception do
          XGMsgBox(Self.Handle, mtError, '�˸�', '������/����ǥ ��¿� ��ְ� �߻��߽��ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
      with TPluginMessage.Create(nil) do
      try
        Command := CPC_CLEAR_SALE;
        PluginMessageToId(Global.TeeBoxViewId);
      finally
        Free;
      end;
      //��Ŀ��ǰ ���ų����� �ִٸ� ȸ������ �ٽ� ��������
      with SaleManager.MemberInfo do
      if (not MemberNo.IsEmpty) and
         (SaleManager.ReceiptInfo.KeepAmt > 0) then
        ClientDM.GetMemberSearch(MemberNo, MemberName, HpNo, CarNo, '', True, 0, sErrMsg);
      if (not SaleManager.ReceiptInfo.PendReceiptNo.IsEmpty) and
         (not ClientDM.DeletePending(SaleManager.ReceiptInfo.PendReceiptNo, sErrMsg)) then
        XGMsgBox(Self.Handle, mtError, '�˸�',
           '���� ���������� �������� ���Ͽ����ϴ�!' + _CRLF +
           '�������� ��ȸ ȭ�鿡�� ���� �����Ͽ� �ֽñ� �ٶ��ϴ�.' + _CRLF + sErrMsg, ['Ȯ��']);

      sStampProdCd := ClientDM.QRSaleItem.FieldByName('product_cd').AsString;
      ClearSaleData; //�Ǹ� �ʱ�ȭ
      ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
      DispMemberInfo;
      if Global.NoShowInfo.NoShowReserved then
      try
        if not ClientDM.GetTeeBoxNoShowList(sErrMsg) then
          raise Exception.Create(sErrMsg);
      except
        on E: Exception do
          XGMsgBox(Self.Handle, mtError, '�˸�', '��� ��Ȳ�� ��ȸ�� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
      ClientDM.ReloadTeeBoxStatus;
      XGMsgBox(Self.Handle, mtInformation, '�˸�', '�ŷ��� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
      //chy test
      if (SaleManager.StoreInfo.FacilityProdYN = True) and (nDailyTeeBoxCount > 0) and (sStampProdCd <> '') then
      begin
        DataSet := ClientDM.MDProdTeeBox;
        bStampYn := False;
        with DataSet do
        begin
          if Locate('product_cd', VarArrayOf([sStampProdCd]), []) then
            bStampYn := FieldByName('stamp_yn').AsBoolean;
        end;
        if bStampYn = True then
        begin
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            PM.AddParams(CPP_PRODUCT_CD, sStampProdCd);
            PM.AddParams(CPP_PRODUCT_QTY, nDailyTeeBoxCount);
            if (PluginManager.OpenModal('XGStamp' + CPL_EXTENSION, PM) = mrOK) then
              XGMsgBox(Self.Handle, mtInformation, '�˸�', '�������� ���� �Ǿ����ϴ�!', ['Ȯ��'], 5);
          finally
            FreeAndNil(PM);
          end;
        end;
      end;
      case SaleManager.StoreInfo.POSType of
        CPO_SALE_TEEBOX,
        CPO_SALE_LESSON_ROOM:
          ShowTeeBoxView(Self.PluginID);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
    end;
  finally
    DispSaleResult;
    TcyAdvSpeedButton(Sender).Enabled := True;
    FWorking := False;
  end;
end;
procedure TXGSalePosForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;
procedure TXGSalePosForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;
procedure TXGSalePosForm.OnCategoryButtonClick(Sender: TObject);
var
  nCategory: Integer;
begin
  nCategory := TAdvShapeButton(Sender).Tag;
  if (nCategory < 0) then
    Exit;
  with SaleManager.SaleMenuManager do
  begin
    CurrentCategoryIndex := nCategory;
    SetItemPage(nCategory, 0, SaleItemMenuCallback);
  end;
end;
procedure TXGSalePosForm.OnSaleItemButtonClick(Sender: TObject);
var
  PM: TPluginMessage;
  nItem, nProdAmt, nXGolfDCAmt, nKeepAmt, nUseMonth, nSexDiv: Integer;
  sCategory, sProdDiv, sProdCode, sChildProdDiv, sProdName, sZoneCode, sUseStartDate,
  sLessonProCode, sLessonProName, sAffiliateCode, sAffiliateItemCode, sErrMsg: string;
  dStartDate: TDateTime;
  bUseRefund, bAffiliateYN: Boolean;
begin
  if FWorking then
    Exit;
  FWorking := True;
  with SaleManager do
  try
    try
      if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
        ClearTeeBoxSelection;
      nItem := TSolbiTouchButton(Sender).Tag;
      if (nItem < 0) or
         ReceiptInfo.ProdChangeSale then
        Exit;
      if (ClientDM.QRSaleItem.RecordCount = 0) and
         (ClientDM.QRPayment.RecordCount = 0) and
         (ClientDM.QRCoupon.RecordCount = 0) then
        ClearSaleData; //�Ǹ� �ʱ�ȭ
      with SaleMenuManager do
      begin
        CurrentItemIndex := nItem;
        sCategory := SaleItems[CurrentCategoryIndex, nItem].CategoryCode;
        sProdDiv := SaleItems[CurrentCategoryIndex, nItem].ProductDiv;
        sChildProdDiv := SaleItems[CurrentCategoryIndex, nItem].ChildProdDiv;
        sProdCode := SaleItems[CurrentCategoryIndex, nItem].ProductCode;
        sProdName := SaleItems[CurrentCategoryIndex, nItem].ProductName;
        sZoneCode := SaleItems[CurrentCategoryIndex, nItem].ZoneCode;
        nSexDiv := SaleItems[CurrentCategoryIndex, nItem].SexDiv;
        nProdAmt := SaleItems[CurrentCategoryIndex, nItem].ProductAmt;
        nKeepAmt := SaleItems[CurrentCategoryIndex, nItem].KeepAmt;
        nUseMonth  := SaleItems[CurrentCategoryIndex, nItem].UseMonth;
        bUseRefund := SaleItems[CurrentCategoryIndex, nItem].UseRefund;
        bAffiliateYN := SaleItems[CurrentCategoryIndex, nItem].AffiliateYN;
        sAffiliateCode := SaleItems[CurrentCategoryIndex, nItem].AffiliateCode;
        sAffiliateItemCode := SaleItems[CurrentCategoryIndex, nItem].AffiliateItemCode;
        sLessonProCode := '';
        sLessonProName := '';
        nXGolfDCAmt := 0;
        if not MemberInfo.XGolfMemberNo.IsEmpty then
          nXGolfDCAmt := SaleItems[CurrentCategoryIndex, nItem].XGolfDCAmt;
      end;
      (*
      //�δ�ü� �̿� ��ǰ ���� ����
      if (ReceiptInfo.FacilityCount > 0) or
         ((ClientDM.QRSaleItem.RecordCount > 0) and (sProdDiv = CPD_FACILITY)) then
      begin
        XGMsgBox(Self.Handle, mtWarning, '�˸�', '�δ�ü� �̿� ��ǰ�� �ٸ� ��ǰ�� �Բ� �Ǹ��� �� �����ϴ�!', ['Ȯ��'], 5);
        Exit;
      end;
      *)
      //��ȸ�� ���� ����
      if MemberInfo.MemberNo.IsEmpty and
         ((sProdDiv = CPD_LOCKER) or
          ((sProdDiv = CPD_TEEBOX) and (sChildProdDiv <> CTP_DAILY)) or
          ((sProdDiv = CPD_FACILITY) and (sChildProdDiv <> CTP_DAILY)) or
          (sProdDiv = CPD_LESSON) or
          (sProdDiv = CPD_RESERVE)) then
        raise Exception.Create('��ȸ���� ������ �� ���� ��ǰ�Դϴ�!');
      //ȯ�� ó�� ��ǰ
      if bUseRefund then
      begin
        nProdAmt := SetProductAmt;
        if (nProdAmt = 0) then
            Exit;
        if not ClientDM.UpdateSaleList(
            Global.TableInfo.ActiveTableNo,
            Global.TableInfo.DelimitedGroupTableList,
            sProdDiv,
            sChildProdDiv,
            sProdCode,
            sProdName,
            '', //use_start_date
            '', //lesson_pro_cd
            nProdAmt,
            0, 1, 0, 0, sErrMsg) then
          raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg);
      end
      else
      begin
        //���� ���� Ÿ�� ��ǰ�� ������ ���
        if (sProdDiv = CPD_TEEBOX) and
           (not MemberInfo.MemberNo.IsEmpty) and
           (not ((MemberInfo.SexDiv = CSD_SEX_ALL) or
                 (nSexDiv = CSD_SEX_ALL) or
                 ((nSexDiv = CSD_SEX_FEMALE) and (MemberInfo.SexDiv = CSD_SEX_FEMALE)) or
                 ((nSexDiv = CSD_SEX_MALE) and (MemberInfo.SexDiv = CSD_SEX_MALE)))) then
          raise Exception.Create('ȸ���� �����δ� ������ �� ���� ��ǰ�Դϴ�!');
        //�Ⱓ & ���� Ÿ����ǰ ���Ž� �������� �Է�
        if (sProdDiv = CPD_TEEBOX) and
           ((sChildProdDiv = CTP_TERM) or (sChildProdDiv = CTP_COUPON)) then
        begin
          with TXGInputStartDateForm.Create(nil) do
          try
            dStartDate := Now;
            ProdName := sProdName;
            try
              if ClientDM.GetTeeBoxProdMember(SaleManager.MemberInfo.MemberNo, sChildProdDiv, sErrMsg) and
                 (ClientDM.MDTeeBoxProdMember.RecordCount > 0) then
                dStartDate := StrToDateTime(Format('%s 00:00:00', [ClientDM.MDTeeBoxProdMember.FieldByName('end_day').AsString]), Global.FS) + 1;
            except
            end;
            StartYear := YearOf(dStartDate);
            StartMonth := MonthOf(dStartDate);
            StartDay := DayOf(dStartDate);
            if (ShowModal <> mrOk) then
              Exit;
            sUseStartDate := FormatDateTime('yyyymmdd', SelectedDate);
            TeeBoxOrderMemo := Format('Ÿ����ǰ: %s, ��������: %s', [sProdName, FormattedDateString(sUseStartDate)]);
            RefreshOrderMemo;
          finally
            Free;
          end;
        end;
        //�Ϲ� Ÿ�� - ���� ��ǰ�� ���
        if (sProdDiv = CPD_TEEBOX) and
           (sChildProdDiv = CTP_LESSON) then
        begin
          with TXGInputStartLessonForm.Create(nil) do
          try
            dStartDate := Now;
            ProdName := sProdName;
            try
              if ClientDM.GetTeeBoxProdMember(SaleManager.MemberInfo.MemberNo, CTP_LESSON, sErrMsg) and
                 (ClientDM.MDTeeBoxProdMember.RecordCount > 0) then
                dStartDate := StrToDateTime(Format('%s 00:00:00', [ClientDM.MDTeeBoxProdMember.FieldByName('end_day').AsString]), Global.FS) + 1;
            except
            end;
            StartYear := YearOf(dStartDate);
            StartMonth := MonthOf(dStartDate);
            StartDay := DayOf(dStartDate);
            if (ShowModal <> mrOk) then
              Exit;
            sUseStartDate := FormatDateTime('yyyymmdd', SelectedDate);
            sLessonProCode := LessonProCode;
            sLessonProName := LessonProName;
            TeeBoxLessonOrderMemo := Format('Ÿ������: %s, ��������: %s, ����: %s', [sProdName, FormatDateTime('yyyy-mm-dd', SelectedDate), sLessonProName]);
            RefreshOrderMemo;
          finally
            Free;
          end;
        end;
        //������ ���� ��ǰ�� ���
        if (sProdDiv = CPD_LESSON) then
        begin
          if not ClientDM.GetLessonProList(sProdCode, sErrMsg) then
            raise Exception.Create('���� ���θ� ������ �� �����ϴ�!');
          with TXGInputStartLessonForm.Create(nil) do
          try
            ProdName := sProdName;
            dStartDate := Now;
            StartYear := YearOf(dStartDate);
            StartMonth := MonthOf(dStartDate);
            StartDay := DayOf(dStartDate);
            if (ShowModal <> mrOk) then
              Exit;
            sUseStartDate := FormatDateTime('yyyymmdd', SelectedDate);
            sLessonProCode := LessonProCode;
            sLessonProName := LessonProName;
            LessonOrderMemo := Format('������ǰ: %s, ��������: %s, ����: %s', [sProdName, FormattedDateString(sUseStartDate), sLessonProName]);
            RefreshOrderMemo;
          finally
            Free;
          end;
        end;
        //�ü� �̿���� ���
        if (sProdDiv = CPD_FACILITY) and
           (sChildProdDiv <> CTP_DAILY) then
        begin
          with TXGInputStartDateForm.Create(nil) do
          try
            ProdName := sProdName;
            dStartDate := Now;
            StartYear := YearOf(dStartDate);
            StartMonth := MonthOf(dStartDate);
            StartDay := DayOf(dStartDate);
            if (ShowModal <> mrOk) then
              Exit;
            sUseStartDate := FormatDateTime('yyyymmdd', SelectedDate);
            FacilityOrderMemo := Format('�ü���ǰ: %s, ��������: %s', [sProdName, FormattedDateString(sUseStartDate)]);
            RefreshOrderMemo;
          finally
            Free;
          end;
        end;
        //���޻� ��ǰ(����, ��������Ŭ��, �������� ��) : �̹� ���޻� ������ �� �� ��쿡��
        if bAffiliateYN and
           (not AffiliateRec.Applied) and
           (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
        begin
          //����Ŭ�� ������ �������� ������ ��쿡�� �����ڵ� ����
          if (sAffiliateCode = GCD_WBCLUB_CODE) and
             Global.WelbeingClub.SelectEvent then
            AffiliateRec.ItemCode := sAffiliateItemCode;
          AffiliateRec.PartnerCode := sAffiliateCode;
          DoAffiliateApproval;
        end;
        //�繰�Ժ������� 1�� �̻� ��� �Ұ�
        if (sProdDiv = CPD_LOCKER) and
           (sCategory = CPD_KEEP_AMT) and
           (SaleManager.ReceiptInfo.KeepAmt > 0) then
          raise Exception.Create('�繰�� �������� �̹� ��ϵǾ� �ֽ��ϴ�!');
        //��Ŀ��ǰ ������ ���
        if (sProdDiv = CPD_LOCKER) and
           (sCategory = CPD_LOCKER) then
        begin
          if (not MemberInfo.MemberNo.IsEmpty) and
             (not ((MemberInfo.SexDiv = CSD_SEX_ALL) or
                   (nSexDiv = CSD_SEX_ALL) or
                   ((nSexDiv = CSD_SEX_FEMALE) and (MemberInfo.SexDiv = CSD_SEX_FEMALE)) or
                   ((nSexDiv = CSD_SEX_MALE) and (MemberInfo.SexDiv = CSD_SEX_MALE)))) then
            raise Exception.Create('ȸ���� �����δ� ������ �� ���� ��ǰ�Դϴ�!');
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            PM.AddParams(CPP_LOCKER_SELECT, True);
            PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
            PM.AddParams(CPP_LOCKER_INFO, Format('��Ŀȸ�� �� %s(%s)%s',
              [SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.MemberNo, StrUtils.IfThen(SaleManager.MemberInfo.LockerList.IsEmpty, '', ' : ' + SaleManager.MemberInfo.LockerList)]));
            PM.AddParams(CPP_ZONE_CODE, sZoneCode);
            if (PluginManager.OpenModal('XGLocker' + CPL_EXTENSION, PM) = mrOK) then
            begin
              if LockerRec.UseContinue then
                nKeepAmt := 0;
              LockerOrderMemo := Format('��Ŀ��ǰ: %s, ��Ŀ: %s, �̿����: %s, ������: %d, �ڵ�����: %s',
                [sProdName, LockerRec.LockerName, FormattedDateString(LockerRec.UseStartDate), nKeepAmt, IIF(LockerRec.UseContinue, '��', '�ƴϿ�')]);
              RefreshOrderMemo;
              if ClientDM.UpdateSaleList(
                  Global.TableInfo.ActiveTableNo,
                  Global.TableInfo.DelimitedGroupTableList,
                  sProdDiv,
                  '', //teebox_prod_div
                  sProdCode,
                  sProdName,
                  LockerRec.UseStartDate,
                  '', //lesson_pro_cd
                  nProdAmt,
                  nXGolfDCAmt,
                  1,
                  nUseMonth,
                  nKeepAmt,
                  sErrMsg) then
                LockerRec.Clear
              else
                raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg)
            end;
          finally
            FreeAndNil(PM);
          end;
        end
        else
        begin
          if not ClientDM.UpdateSaleList(
              Global.TableInfo.ActiveTableNo,
              Global.TableInfo.DelimitedGroupTableList,
              sProdDiv,
              sChildProdDiv,
              sProdCode,
              sProdName,
              sUseStartDate,
              sLessonProCode,
              nProdAmt,
              nXGolfDCAmt,
              1,
              0,
              nKeepAmt,
              sErrMsg) then
            raise Exception.Create('���Ÿ�Ͽ� ��ǰ�� �߰��� �� �����ϴ�!' + _CRLF + sErrMsg);
        end;
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtWarning, '�˸�', E.Message, ['Ȯ��'], 5);
    end;
  finally
    FWorking := False;
  end;
end;
procedure TXGSalePosForm.pgcExtPageChange(Sender: TObject);
var
  nIdx: Integer;
begin
  nIdx := TcxPageControl(Sender).ActivePageIndex;
  btnPayCancel.Enabled := (nIdx = 0);
  btnCancelCoupon.Enabled := (nIdx = 1);
  btnReCalcCoupon.Enabled := (nIdx = 1);
end;
procedure TXGSalePosForm.DoAffiliateApproval;
var
  sErrMsg: string;
begin
  try
    try
      if not ClientDM.DoAffiliateProcess(Self.PluginID, sErrMsg) then
        raise Exception.Create(sErrMsg);
      DispAffiliateResult;
      if AffiliateRec.Applied then
        XGMsgBox(Self.Handle, mtInformation, '�˸�', AffiliateRec.PartnerName + ' ȸ�� ������ ���εǾ����ϴ�!' + _CRLF +
          '����ݾ� : ' + FormatFloat('#,##0', AffiliateRec.ApprovalAmt), ['Ȯ��'], 5)
      else
        XGMsgBox(Self.Handle, mtInformation, '�˸�', AffiliateRec.PartnerName + ' ȸ�� ������ ��ҵǾ����ϴ�!', ['Ȯ��'], 5);
    finally
      DispSaleResult;
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('SalePos.DoAffiliateApproval.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
    end;
  end;
end;
procedure TXGSalePosForm.DispAffiliateResult;
begin
  if AffiliateRec.Applied then
    mmoSaleMemo.Text := Format('%s(%s) %s�� ����', [AffiliateRec.PartnerName, AffiliateRec.MemberCode, FormatFloat('#,##0', AffiliateRec.ApprovalAmt)])
  else
    mmoSaleMemo.Text := '';
end;
procedure TXGSalePosForm.V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V1.DataController.Summary do
  begin
    SaleManager.ReceiptInfo.SellTotal          := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1calc_sell_subtotal)]), 0);
    SaleManager.ReceiptInfo.DirectDCTotal      := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1direct_dc_amt)]), 0);
    SaleManager.ReceiptInfo.CouponFixedDCTotal := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1coupon_dc_fixed_amt)]), 0);
    SaleManager.ReceiptInfo.CouponRateDCTotal  := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1coupon_dc_rate_amt)]), 0);
    SaleManager.ReceiptInfo.XGolfDCTotal       := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1xgolf_dc_amt)]), 0);
    SaleManager.ReceiptInfo.VatTotal           := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1calc_vat_subtotal)]), 0);
    SaleManager.ReceiptInfo.KeepAmt            := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1keep_amt)]), 0);
    SaleManager.ReceiptInfo.FacilityCount      := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1calc_facility_count)]), 0);
  end;
  DispSaleResult;
end;
procedure TXGSalePosForm.V2DataControllerDataChanged(Sender: TObject);
begin
  DispSaleResult;
end;
procedure TXGSalePosForm.V2DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V2.DataController.Summary do
    SaleManager.ReceiptInfo.PromoDCTotal := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V2apply_dc_amt)]), 0);
  DispSaleResult;
end;
procedure TXGSalePosForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
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
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); // $00689F0E);
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
function TXGSalePosForm.SetProductAmt: Integer;
begin
  Result := 0;
  with TXGInputProdAmtForm.Create(nil) do
  try
    if (ShowModal = mrOK) then
      Result := InputAmt;
  finally
    Free;
  end;
end;
procedure TXGSalePosForm.SetInputBuffer(const AValue: string);
begin
  FInputBuffer := AValue;
  with edtInputCapture do
  begin
    Text := FormatCurr('#,##0', StrToCurrDef(FInputBuffer, 0));
    SelStart := Length(Text) + 1;
  end;
end;
procedure TXGSalePosForm.ClearOrderMemo;
begin
  TeeBoxOrderMemo := '';
  TeeBoxLessonOrderMemo := '';
  LessonOrderMemo := '';
  FacilityOrderMemo := '';
  LockerOrderMemo := '';
  mmoOrderMemo.Lines.Clear;
end;
procedure TXGSalePosForm.DeleteOrderMemo(const AProdDiv, AChildProdDiv: string);
begin
  if (AProdDiv = CPD_TEEBOX) then
  begin
    if (AChildProdDiv = CTP_COUPON) or (AChildProdDiv = CTP_TERM) then
      TeeBoxOrderMemo := ''
    else if (AChildProdDiv = CTP_LESSON) then
      TeeBoxLessonOrderMemo := '';
  end
  else if (AProdDiv = CPD_LESSON) then
    LessonOrderMemo := ''
  else if (AProdDiv = CPD_FACILITY) and (AChildProdDiv <> CTP_DAILY) then
    FacilityOrderMemo := ''
  else if (AProdDiv = CPD_LOCKER) then
    LockerOrderMemo := '';
  RefreshOrderMemo;
end;
procedure TXGSalePosForm.RefreshOrderMemo;
begin
  with mmoOrderMemo.Lines do
  try
    BeginUpdate;
    Clear;
    if not TeeBoxOrderMemo.IsEmpty then
      Add(TeeBoxOrderMemo);
    if not TeeBoxLessonOrderMemo.IsEmpty then
      Add(TeeBoxLessonOrderMemo);
    if not LessonOrderMemo.IsEmpty then
      Add(LessonOrderMemo);
    if not FacilityOrderMemo.IsEmpty then
      Add(FacilityOrderMemo);
    if not LockerOrderMemo.IsEmpty then
      Add(LockerOrderMemo);
  finally
    EndUpdate;
  end;
end;
procedure TXGSalePosForm.ClearSaleData;
begin
  LockerRec.Clear;
  AffiliateRec.Clear;
  ClearOrderMemo;
  mmoSaleMemo.Lines.Clear;
  ClientDM.ClearSaleTables(Global.TableInfo.ActiveTableNo);
  SaleManager.ReceiptInfo.Clear;
//  SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo;
//  V1.Bands[0].Caption := Format('[T%d] �ֹ� ���� (%s)', [Global.TableInfo.ActiveTableNo, SaleManager.ReceiptInfo.ReceiptNo]);
  DispSaleResult;
end;
procedure TXGSalePosForm.DispSaleResult;
var
  PM: TPluginMessage;
begin
  with SaleManager.ReceiptInfo do
  begin
    lblChargeTotal.Caption   := FormatCurr('#,##0', SellTotal);
    lblVatTotal.Caption      := FormatCurr('#,##0', VatTotal);
    lblReceiveTotal.Caption  := FormatCurr('#,##0', ReceiveTotal);
    lblDiscountTotal.Caption := FormatCurr('#,##0', DiscountTotal);
    lblUnPaidTotal.Caption   := FormatCurr('#,##0', UnPaidTotal);
    lblChangeTotal.Caption   := FormatCurr('#,##0', ChangeTotal);
    lblKeepAmt.Caption       := FormatCurr('#,##0', KeepAmt);
    lblAffiliateAmt.Caption  := FormatCurr('#,##0', AffiliateAmt);
    if Global.SubMonitor.Enabled then
    begin
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_SALE_RESULT;
        if (ClientDM.QRSaleItem.RecordCount > 0) then
          PM.AddParams(CPP_PRODUCT_NAME, ClientDM.QRSaleItem.FieldByName('product_nm').AsString);
        PM.AddParams(CPP_SELL_AMT, SellTotal);
        PM.AddParams(CPP_VAT_AMT, VatTotal);
        PM.AddParams(CPP_CHARGE_AMT, ChargeTotal);
        PM.AddParams(CPP_DISCOUNT_AMT, DiscountTotal);
        PM.AddParams(CPP_PAID_AMT, ReceiveTotal);
        PM.AddParams(CPP_UNPAID_AMT, UnPaidTotal);
        PM.AddParams(CPP_CHANGE_AMT, ChangeTotal);
        PM.PluginMessageToID(Global.SubMonitorID);
        PM.ClearParams;
        PM.Command := CPC_SET_SUBVIEW;
        PM.AddParams(CPP_IDLE_MODE, (ClientDM.QRSaleItem.RecordCount = 0) and (ClientDM.QRPayment.RecordCount = 0));
        PM.PluginMessageToID(Global.SubMonitorID);
      finally
        FreeAndNil(PM);
      end;
    end;
  end;
end;
procedure TXGSalePosForm.DoMemberSearchNew(const AMemberName, AHpNo, ACarNo: string);
var
  PM: TPluginMessage;
  sErrMsg: string;
begin
  if FWorking or
     (AMemberName.IsEmpty and AHpNo.IsEmpty and ACarNo.IsEmpty) then
    Exit;
  FWorking := True;
  PM := TPluginMessage.Create(nil);
  try
    try
      if not ClientDM.SearchMember('', AMemberName, AHpNo, ACarNo, True, sErrMsg) then
      begin
        ClientDM.ClearMemberInfo(Global.SaleFormId);
        DispMemberInfo;
        raise Exception.Create(sErrMsg);
      end;
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_MEMBER_NO, Format('ȸ����=%s*, ��ȭ��ȣ=%s*, ������ȣ=%s*', [AMemberName, AHpNo, ACarNo]));
      PM.AddParams(CPP_TEEBOX_RESERVED, False);
      PM.AddParams(CPP_TEEBOX_PROD_CHANGE, False);
      if (PluginManager.OpenModal('XGMemberSearchList' + CPL_EXTENSION, PM) <> mrOK) then
      begin
        ClientDM.ClearMemberInfo(Global.SaleFormId);
        DispMemberInfo;
        Exit;
      end;
      ClientDM.SetMemberInfo(TDataSet(ClientDM.MDMemberSearch));
      PM.ClearParams;
      PM.Command := CPC_SEND_MEMBER_NO;
      PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
      PM.PluginMessageToID(Global.SaleFormId);
      PM.ClearParams;
      PM.Command := CPC_SEND_MEMBER_NO;
      PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
      PM.PluginMessageToID(Global.TeeBoxViewId);
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('SalePos.DoMemberSearchNew.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FreeAndNil(PM);
    FWorking := False;
  end;
end;
procedure TXGSalePosForm.DispMemberInfo;
begin
  edtMemberName.Text             := SaleManager.MemberInfo.MemberName;
  edtMemberHpNo.Text             := SaleManager.MemberInfo.HpNo;
  edtMemberCarNo.Text            := SaleManager.MemberInfo.CarNo;
  lblMemberLockerList.Caption    := SaleManager.MemberInfo.LockerList;
  lblMemberLockerExpired.Caption := FormattedDateString(SaleManager.MemberInfo.ExpireLocker);
  lblMemberSex.Caption           := SaleManager.MemberInfo.GetSexDivDesc;
  lblMemberSex.Style.Font.Color  := IIF(SaleManager.MemberInfo.SexDiv = CSD_SEX_FEMALE, clRed, clBlack);
  ckbMemberXGolf.Checked         := not SaleManager.MemberInfo.XGolfMemberNo.IsEmpty;
  mmoMemberMemo.Lines.Text       := SaleManager.MemberInfo.Memo;
  btnShowMemberInfo.Enabled      := not SaleManager.MemberInfo.MemberNo.IsEmpty;
end;
procedure TXGSalePosForm.edtInputCaptureEnter(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    SelStart := Length(Text) + 1;
end;
procedure TXGSalePosForm.OnMemberSearchEnter(Sender: TObject);
begin
  FMemberSearchMode := True;
end;
procedure TXGSalePosForm.OnMemberSearchExit(Sender: TObject);
begin
  FMemberSearchMode := False;
end;
procedure TXGSalePosForm.edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew(edtMemberName.Text, '', '');
end;
procedure TXGSalePosForm.edtMemberHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew('', edtMemberHpNo.Text, '');
end;
procedure TXGSalePosForm.edtMemberCarNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew('', '', edtMemberCarNo.Text);
end;
procedure TXGSalePosForm.btnDiscountAmoutClick(Sender: TObject);
var
  nValue: Integer;
  sErrMsg: string;
begin
  nValue := StrToIntDef(InputBuffer, 0);
  with ClientDM.QRSaleItem do
  try
    if (nValue > 0) and
       (RecordCount > 0) then
    begin
      if not ExecuteABSQuery(
          Format('UPDATE TBSaleItem SET direct_dc_amt = %d WHERE table_no = %d AND product_cd = %s', [
            nValue,
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      if (FieldValues['calc_charge_amt'] < 0) then
        XGMsgBox(Self.Handle, mtWarning, '�˸�', '���� ��ǰ�� û�� �ݾ׺��� ���� �ݾ��� �� Ů�ϴ�!', ['Ȯ��'], 5);
      InputBuffer := '0';
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', 'ǰ�� �ݾ�����' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnDiscountPercentClick(Sender: TObject);
var
  nValue, nSubTotal: Integer;
  sErrMsg: string;
begin
  nValue := StrToIntDef(InputBuffer, 0);
  with ClientDM.QRSaleItem do
  try
    if (nValue > 0) and
       (RecordCount > 0) then
    begin
      nSubTotal := FieldByName('calc_sell_subtotal').AsInteger;
      nValue := Trunc(((nSubTotal / 100) * nValue) / 10) * 10;
      if not ExecuteABSQuery(
          Format('UPDATE TBSaleItem SET direct_dc_amt = %d WHERE table_no = %d AND product_cd = %s', [
            nValue,
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      if (FieldValues['calc_charge_amt'] < 0) then
        XGMsgBox(Self.Handle, mtWarning, '�˸�', '���� ��ǰ�� û�� �ݾ׺��� ���� �ݾ��� �� Ů�ϴ�!', ['Ȯ��'], 5);
      InputBuffer := '0';
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', 'ǰ�� ������' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnExtFuncClick(Sender: TObject);
begin
  pgcExtPage.ActivePageIndex := TcyAdvSpeedButton(Sender).Tag;
  DispMemberInfo;
end;
procedure TXGSalePosForm.btnAddonTicketClick(Sender: TObject);
var
  sMemberInfo, sErrMsg: string;
begin
  sMemberInfo := '';
  sErrMsg := '';
  try
    if not SaleManager.MemberInfo.MemberNo.IsEmpty then
      sMemberInfo := Format('ȸ����: %s (%s)', [SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.MemberNo]);
    if not ClientDM.PrintAddonTicket(sMemberInfo, sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      if not E.Message.IsEmpty then
        XGMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� �δ�ü� �����̿���� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnPartnerCenterClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'main');
end;
procedure TXGSalePosForm.btnPayCancelClick(Sender: TObject);
var
  PM: TPluginMessage;
  sPayMethod, sApproveNo, sCardNo, sTradeDate, sReceiptJson, sErrMsg: string;
  bManualApprove: Boolean;
  nPayAmt: Integer;
begin
  with ClientDM.QRPayment do
  try
    if (RecordCount = 0) then
      Exit;
    sPayMethod := FieldByName('pay_method').AsString;
    sApproveNo := FieldByName('approve_no').AsString;
    sCardNo := FieldByName('credit_card_no').AsString;
    nPayAmt := FieldByName('approve_amt').AsInteger;
    sTradeDate := FieldByName('trade_date').AsString;
    bManualApprove := (not sApproveNo.IsEmpty) and (FieldByName('internet_yn').AsString <> CRC_YES);
    if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          IIF(bManualApprove, '���� ������� �߰��� ���� ���Դϴ�.' + _CRLF, '') +
          '���������� ����Ͻðڽ��ϱ�?' + _CRLF +
          FieldByName('calc_pay_method').AsString + ' : ' + FormatCurr('#,##0', nPayAmt) + ' ��', ['��', '�ƴϿ�']) = mrOK) then
    begin
      { ���� ���� ��� }
      if (sPayMethod = CPM_CASH) then
      begin
        if sApproveNo.IsEmpty then
        begin
          //���ݿ����� �̹��� ���� ���
          SaleManager.ReceiptInfo.CashPayAmt := (SaleManager.ReceiptInfo.CashPayAmt - nPayAmt);
          SaleManager.PayLog(False, True, CPM_CASH, '', '', nPayAmt);
        end
        else
        begin
          //���ݿ����� ���� ���� ���
          if bManualApprove then
            SaleManager.ReceiptInfo.CashPayAmt := (SaleManager.ReceiptInfo.CashPayAmt - nPayAmt)
          else
          begin
            PM := TPluginMessage.Create(nil);
            try
              PM.Command := CPC_INIT;
              PM.AddParams(CPP_OWNER_ID, Self.PluginID);
              PM.AddParams(CPP_APPROVAL_YN, False);
              PM.AddParams(CPP_SALEMODE_YN, True);
              PM.AddParams(CPP_RECEIPT_NO, SaleManager.ReceiptInfo.ReceiptNo);
              PM.AddParams(CPP_APPROVAL_NO, sApproveNo);
              PM.AddParams(CPP_APPROVAL_DATE, sTradeDate);
              PM.AddParams(CPP_APPROVAL_AMT, nPayAmt);
              if (PluginManager.OpenModal('XGCashApprove' + CPL_EXTENSION, PM) <> mrOK) then
                Exit;
            finally
              FreeAndNil(PM);
            end;
          end;
        end;
      end
      { �ſ�ī�� ���� ��� }
      else if (sPayMethod = CPM_CARD) then
      begin
        bManualApprove := (FieldByName('internet_yn').AsString <> CRC_YES);
        if bManualApprove then
          SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt - nPayAmt)
        else
        begin
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            PM.AddParams(CPP_APPROVAL_YN, False);
            PM.AddParams(CPP_SALEMODE_YN, True);
            PM.AddParams(CPP_RECEIPT_NO, SaleManager.ReceiptInfo.ReceiptNo);
            PM.AddParams(CPP_APPROVAL_NO, sApproveNo);
            PM.AddParams(CPP_APPROVAL_DATE, sTradeDate);
            PM.AddParams(CPP_APPROVAL_AMT, nPayAmt);
            if (PluginManager.OpenModal('XGCardApprove' + CPL_EXTENSION, PM) <> mrOK) then
              Exit;
          finally
            FreeAndNil(PM);
          end;
        end;
      end
      { PAYCO �ſ�ī�� ���� ��� }
      else if (sPayMethod = CPM_PAYCO_CARD) then
      begin
        if not ClientDM.DoPaymentPAYCO(False, True, sErrMsg) then
          raise Exception.Create('PAYCO ��Ұŷ��� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + sErrMsg);
        XGMsgBox(0, mtInformation, '�˸�', 'PAYCO ��Ұŷ��� ���������� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
      end
      { ����ī�� ���� ��� }
      else if (sPayMethod = CPM_WELFARE) then
      begin
        SaleManager.ReceiptInfo.WelfarePayAmt := (SaleManager.ReceiptInfo.WelfarePayAmt - nPayAmt);
        SaleManager.PayLog(False, bManualApprove, CPM_WELFARE, '', '', nPayAmt);
      end
      else
        raise Exception.Create('����� �� ���� �ŷ������Դϴ�!');
      { ��Ұŷ� ������ ��� }
      sReceiptJson := ClientDM.MakeCancelReceiptJson(ClientDM.QRPayment, sErrMsg);
      if not Global.ReceiptPrint.PaymentSlipPrint(sPayMethod, sReceiptJson, sErrMsg) then
        XGMsgBox(0, mtWarning, '�˸�', '�ŷ���� �������� ����� �� �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      if not ExecuteABSQuery(
          Format('DELETE FROM TBPayment WHERE table_no = %d AND pay_method = %s AND approve_no = %s', [
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('pay_method').AsString),
            QuotedStr(FieldByName('approve_no').AsString)]),
          sErrMsg) then
        XGMsgBox(0, mtWarning, '����', '�ŷ��� ���� ��ҵǾ����� ��ְ� �߻��Ͽ����ϴ�!' + sErrMsg, ['Ȯ��']);
      ClientDM.RefreshPaymentTable(Global.TableInfo.ActiveTableNo);
      if bManualApprove then
      begin
        SaleManager.PayLog(False, True, sPayMethod, sCardNo, sApproveNo, nPayAmt);
        XGMsgBox(0, mtConfirmation, '����',
          '���� ��� ���� ���� ��� ó���Ͽ����ϴ�!' + _CRLF +
          '���ŷ� �ܸ��⿡���� �ݵ�� �ŷ��� ����Ͽ� �ֽʽÿ�.', ['Ȯ��']);
      end;
      if (RecordCount = 0) and
         (not SaleManager.ReceiptInfo.PendReceiptNo.IsEmpty) and
         (not ClientDM.DeletePending(SaleManager.ReceiptInfo.PendReceiptNo, sErrMsg)) then
        XGMsgBox(Self.Handle, mtWarning, '�˸�',
           '���� ���������� �������� ���Ͽ����ϴ�!' + _CRLF +
           '�������� ��ȸ ȭ�鿡�� ���� �����Ͽ� �ֽñ� �ٶ��ϴ�.' + _CRLF + sErrMsg, ['Ȯ��']);
      DispSaleResult;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.bntPayPAYCOClick(Sender: TObject);
var
  sErrMsg: string;
begin
  try
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      Exit;
    if not ClientDM.DoPaymentPAYCO(True, True, sErrMsg) then
      raise Exception.Create('PAYCO ���ΰŷ��� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + sErrMsg);
    btnPayment.Click;
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      btnSaleComplete.Click;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;
procedure TXGSalePosForm.btnMemberNewClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_DATA_MODE, CDM_NEW_DATA);
    if (PluginManager.OpenModal('XGMember' + CPL_EXTENSION, PM) = mrOK) then
      XGMsgBox(Self.Handle, mtInformation, '�˸�', 'ȸ�� ������ ��� �Ǿ����ϴ�!', ['Ȯ��'], 5);
  finally
    FreeAndNil(PM);
  end;
end;
procedure TXGSalePosForm.btnMemberSearchClick(Sender: TObject);
var
  PM: TPluginMessage;
  sErrMsg: string;
begin
  //ȸ�� ������ ����
  ClientDM.GetMemberList(sErrMsg);
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_DATA_MODE, CDM_VIEW_ONLY);
    PluginManager.OpenModal('XGMember' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;
procedure TXGSalePosForm.ClearTeeBoxSelection;
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_CLEAR_TEEBOX_SELECTED;
    PluginMessageToId(Global.TeeBoxViewId);
  finally
    Free;
  end;
end;
procedure TXGSalePosForm.PrintLessonReceipt;
var
  LR: TLessonReceiptInfo;
  sStoreName, sErrMsg: string;
begin
  try
    with TXGLessonReceiptForm.Create(nil) do
    try
      edtLessonBuyerName.Text := Global.ConfigLessonReceipt.ReadString('Config', 'BuyerName', '');
      edtLessonMemberNo.Text := SaleManager.MemberInfo.MemberNo;
      edtLessonCoachName.Text := Global.ConfigLessonReceipt.ReadString('Config', 'CoachName', '');
      edtLessonName.Text := Global.ConfigLessonReceipt.ReadString('Config', 'LessonName', '');
      edtLessonProdName.Text := Global.ConfigLessonReceipt.ReadString('Config', 'ProdName', '');
      edtLessonFee.Value := Global.ConfigLessonReceipt.ReadInteger('Config', 'LessonFee', 0);
      sStoreName := Global.ConfigLessonReceipt.ReadString('Config', 'StoreName', '');
      if sStoreName.IsEmpty then
        sStoreName := SaleManager.StoreInfo.StoreName;
      edtLessonStoreName.Text := sStoreName;
      dtpLessonDateTime.DateTime := Now;
      edtLessonIssuerName.Text := Global.ConfigLessonReceipt.ReadString('Config', 'IssuerName', '');
      if (ShowModal = mrOK) then
      begin
        LR.BuyerName := Trim(edtLessonBuyerName.Text);
        LR.MemberNo :=Trim(edtLessonMemberNo.Text);
        LR.CoachName := Trim(edtLessonCoachName.Text);
        LR.LessonName := Trim(edtLessonName.Text);
        LR.ProdName := Trim(edtLessonProdName.Text);
        LR.LessonDateTime := FormatDateTime('yyyy-mm-dd hh:nn', dtpLessonDateTime.DateTime);
        LR.LessonFee := Trunc(edtLessonFee.Value);
        LR.StoreName := Trim(edtLessonStoreName.Text);
        LR.IssuerName := Trim(edtLessonIssuerName.Text);
        Global.ConfigLessonReceipt.WriteString('Config', 'BuyerName', LR.BuyerName);
        Global.ConfigLessonReceipt.WriteString('Config', 'CoachName', LR.CoachName);
        Global.ConfigLessonReceipt.WriteString('Config', 'LessonName', LR.LessonName);
        Global.ConfigLessonReceipt.WriteString('Config', 'ProdName', LR.ProdName);
        Global.ConfigLessonReceipt.WriteInteger('Config', 'LessonFee', LR.LessonFee);
        Global.ConfigLessonReceipt.WriteString('Config', 'StoreName', LR.StoreName);
        Global.ConfigLessonReceipt.WriteString('Config', 'IssuerName', LR.IssuerName);
        if not Global.DeviceConfig.ReceiptPrinter.Enabled then
          raise Exception.Create('������ �����͸� ����� �� �����ϴ�.');
        if not Global.ReceiptPrint.LessonReceiptPrint(LR, sErrMsg) then
            raise Exception.Create(sErrMsg);
      end;
    finally
      Free;
    end;
  except
    on E: Exception do
  end;
end;
procedure TXGSalePosForm.SetTableTitle;
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) then // �ĺ�POS(��ũ��, �Ĵ� ��)
  begin
    if (Global.TableInfo.ActiveTableNo > 0) then
    begin
      panHeader.Font.Color := $0080FFFF;
      panHeader.Caption := Format('%s [T%d] %s', [FBaseTitle, Global.TableInfo.ActiveTableNo, Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].TableName]);
    end
    else
    begin
      panHeader.Font.Color := clWhite;
      panHeader.Caption := FBaseTitle;
    end;
  end
  else
  begin
    panHeader.Caption := FBaseTitle;
    panHeader.Font.Color := clWhite;
  end;
end;
////////////////////////////////////////////////////////////////////////////////
function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGSalePosForm.Create(Application, AMsg);
end;
exports
  OpenPlugin;
end.
