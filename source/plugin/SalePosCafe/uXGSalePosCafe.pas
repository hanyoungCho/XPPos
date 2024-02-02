(*******************************************************************************

  Title       : 판매관리 Main (카페/구내식당 POS용)
  Filename    : uXGSalePosCafe.pas
  Author      : 이선우
  Description :
    ...
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2016-10-25   Initial Release.
*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGSalePosCafe;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Menus, DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxStyles, cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu,
  cxControls, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxDBData, cxLabel, cxCurrencyEdit, cxContainer, cxClasses, cxTextEdit, cxMemo, cxCheckBox,
  cxButtons, cxListBox, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridCustomView, cxGrid, cxPC, cxCustomListBox, dxScrollbarAnnotations,
  { TMS }
  AdvShapeButton,
  { SolbiVCL}
  cyBaseSpeedButton, cyAdvSpeedButton, Solbi.TouchButton, WallPaper, LEDFontNum;

{$I ..\..\common\XGPOS.inc}

const
  LCN_CATEGORY_MAX  = 3;
  LCN_SALEITEM_MAX  = 15;

type
  TXGSalePosCafeForm = class(TPluginModule)
    panFooter: TPanel;
    panTopAdjust: TPanel;
    panRightSide: TPanel;
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
    panExtMenu: TPanel;
    btnPayCard: TcyAdvSpeedButton;
    btnPayCash: TcyAdvSpeedButton;
    btnPayPAYCO: TcyAdvSpeedButton;
    btnPayCancel: TcyAdvSpeedButton;
    btnOpenDrawer: TcyAdvSpeedButton;
    btnPayVoucher: TcyAdvSpeedButton;
    btnInputCoupon: TcyAdvSpeedButton;
    btnReceiptView: TcyAdvSpeedButton;
    btnWelfare: TcyAdvSpeedButton;
    btnReCalcCoupon: TcyAdvSpeedButton;
    btnCancelCoupon: TcyAdvSpeedButton;
    btnSaleTable: TcyAdvSpeedButton;
    btnSalePartnerCenter: TcyAdvSpeedButton;
    btnSaleComplete: TcyAdvSpeedButton;
    btnCoupon: TcyAdvSpeedButton;
    btnPayment: TcyAdvSpeedButton;
    btnSaleSearchProduct: TcyAdvSpeedButton;
    panHeader: TPanel;
    btnHome: TAdvShapeButton;
    btnPartnerCenter: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    panHeaderTools: TPanel;
    tmrClock: TTimer;
    btnCalculator: TAdvShapeButton;
    panBasePanel: TPanel;
    wppBack: TWallPaper;
    panScoreboard: TPanel;
    ledStoreEndTime: TLEDFontNum;
    Label15: TLabel;
    panNumButtons: TPanel;
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
    btnSaleItemClear: TcyAdvSpeedButton;
    btnSaleItemDelete: TcyAdvSpeedButton;
    btnSaleItemIncQty: TcyAdvSpeedButton;
    btnSaleItemDecQty: TcyAdvSpeedButton;
    btnSaleItemChangeQty: TcyAdvSpeedButton;
    edtInputCapture: TcxTextEdit;
    btnNum7: TcyAdvSpeedButton;
    btnNum8: TcyAdvSpeedButton;
    btnNum9: TcyAdvSpeedButton;
    btnNum6: TcyAdvSpeedButton;
    btnNum5: TcyAdvSpeedButton;
    btnNum4: TcyAdvSpeedButton;
    btnNum1: TcyAdvSpeedButton;
    btnNum2: TcyAdvSpeedButton;
    btnNum3: TcyAdvSpeedButton;
    btnNumClear: TcyAdvSpeedButton;
    btnNumBackSpace: TcyAdvSpeedButton;
    btnNum0: TcyAdvSpeedButton;
    btnItemDiscountAmout: TcyAdvSpeedButton;
    btnItemDiscountPercent: TcyAdvSpeedButton;
    btnItemDiscountCancel: TcyAdvSpeedButton;
    btnAddPending: TcyAdvSpeedButton;
    btnLoadPending: TcyAdvSpeedButton;
    panSaleList: TPanel;
    mmoSaleMemo: TcxMemo;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1calc_category_div: TcxGridDBBandedColumn;
    V1product_nm: TcxGridDBBandedColumn;
    V1product_amt: TcxGridDBBandedColumn;
    V1order_qty: TcxGridDBBandedColumn;
    V1keep_amt: TcxGridDBBandedColumn;
    V1calc_dc_amt: TcxGridDBBandedColumn;
    V1coupon_dc_fixed_amt: TcxGridDBBandedColumn;
    V1coupon_dc_rate_amt: TcxGridDBBandedColumn;
    V1calc_sell_subtotal: TcxGridDBBandedColumn;
    V1calc_charge_amt: TcxGridDBBandedColumn;
    V1calc_vat_subtotal: TcxGridDBBandedColumn;
    V1direct_dc_amt: TcxGridDBBandedColumn;
    V1xgolf_dc_amt: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    panSaleItemNavigator: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    panPluView: TPanel;
    btnCategory1: TcyAdvSpeedButton;
    btnCategory2: TcyAdvSpeedButton;
    btnCategory3: TcyAdvSpeedButton;
    btnCategoryPrev: TcyAdvSpeedButton;
    btnCategoryNext: TcyAdvSpeedButton;
    btnSaleItem1: TSolbiTouchButton;
    btnSaleItem2: TSolbiTouchButton;
    btnSaleItem3: TSolbiTouchButton;
    btnSaleItem4: TSolbiTouchButton;
    btnSaleItem5: TSolbiTouchButton;
    btnSaleItem6: TSolbiTouchButton;
    btnSaleItem7: TSolbiTouchButton;
    btnSaleItem8: TSolbiTouchButton;
    btnSaleItem9: TSolbiTouchButton;
    btnSaleItem10: TSolbiTouchButton;
    btnSaleItem11: TSolbiTouchButton;
    btnSaleItem12: TSolbiTouchButton;
    btnSaleItem13: TSolbiTouchButton;
    btnSaleItem14: TSolbiTouchButton;
    btnSaleItem15: TSolbiTouchButton;
    btnSaleItemPrev: TcyAdvSpeedButton;
    btnSaleItemNext: TcyAdvSpeedButton;
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
    L2: TcxGridLevel;
    panPaymentNavigator: TPanel;
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
    tabWelfare: TcxTabSheet;
    lbxWelfareLog: TcxListBox;
    panMealInfo: TPanel;
    Label7: TLabel;
    btnMealProdChange: TcxButton;
    lblWelfareMealInfo: TcxLabel;
    panEmpInfo: TPanel;
    Label8: TLabel;
    btnSearchEmp: TcxButton;
    edtEmpInfo: TcxTextEdit;
    btnWelfarePayTest: TcxButton;
    shpPluDivider: TShape;
    panSaleComplete: TPanel;
    btnAddonTicket: TcyAdvSpeedButton;

    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
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
    procedure btnDiscountAmoutClick(Sender: TObject);
    procedure edtInputCaptureEnter(Sender: TObject);
    procedure btnItemDiscountCancelClick(Sender: TObject);
    procedure V2DataControllerDataChanged(Sender: TObject);
    procedure btnCategoryPrevClick(Sender: TObject);
    procedure btnCategoryNextClick(Sender: TObject);
    procedure btnSaleItemPrevClick(Sender: TObject);
    procedure btnSaleItemNextClick(Sender: TObject);
    procedure btnPayCardClick(Sender: TObject);
    procedure btnPayCashClick(Sender: TObject);
    procedure btnPayPAYCOClick(Sender: TObject);
    procedure btnPayCancelClick(Sender: TObject);
    procedure btnOpenDrawerClick(Sender: TObject);
    procedure btnReceiptViewClick(Sender: TObject);
    procedure btnSaleCompleteClick(Sender: TObject);
    procedure btnAddPendingClick(Sender: TObject);
    procedure btnLoadPendingClick(Sender: TObject);
    procedure btnPartnerCenterClick(Sender: TObject);
    procedure btnSalePartnerCenterClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure btnCancelCouponClick(Sender: TObject);
    procedure pgcExtPageChange(Sender: TObject);
    procedure btnReCalcCouponClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPayVoucherClick(Sender: TObject);
    procedure btnMealProdChangeClick(Sender: TObject);
    procedure btnExtFuncClick(Sender: TObject);
    procedure btnSearchEmpClick(Sender: TObject);
    procedure btnSaleTableClick(Sender: TObject);
    procedure btnSaleSearchProductClick(Sender: TObject);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnWelfarePayTestClick(Sender: TObject);
    procedure btnCalculatorClick(Sender: TObject);
    procedure PluginModuleShow(Sender: TObject);
    procedure btnAddonTicketClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FInputBuffer: string; //숫자패드 입력버퍼
    FWelfareMealSelected: Boolean;
    FBaseTitle: string;
    FCategoryButtons: TArray<TcyAdvSpeedButton>;
    FSaleItemButtons: TArray<TSolbiTouchButton>;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure StartUp;
    procedure ShowHome;
    procedure CloseAction;
    procedure DoPayWelfare(const AWelfareCode: string);
    procedure DoPayWelfareByEmpName(const AEmpName: string);
    procedure DoPayMealCoupon(const AWelfareCode: string);
    procedure ClearSaleData;
    procedure DispSaleResult;
    function SetProductAmt: Integer;
    procedure SetInputBuffer(const AValue: string);
    procedure DispWelfareMealInfo;
    procedure WelfarePayTest;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    procedure CategoryMenuCallBack(const ACategoryIndex: integer);
    procedure SaleItemMenuCallback(const ACategoryIndex, AItemPage: integer);
    procedure SetTableTitle;

    property InputBuffer: string read FInputBuffer write SetInputBuffer;
  end;
var
  XGSalePosCafeForm: TXGSalePosCafeForm;

implementation

uses
  { Native }
  Graphics, Variants, dxCore, cxGridCommon, Math, MMSystem,
  { VAN }
  uVanDaemonModule, uPaycoNewModule,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGInputProdAmt, uXGMemberPopup,
  uXGCalc;

{$R *.dfm}

{ TXGSalePosCafeForm }

constructor TXGSalePosCafeForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  i: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FIsFirst := True;
  FBaseTitle := panHeader.Caption;

  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';
  ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
  panMealInfo.Visible := (SaleManager.StoreInfo.POSType = CPO_SALE_FOODCOURT);
  btnSaleTable.Visible := (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]);
  btnSaleTable.Caption := Global.TableInfo.UnitName + ' 관리' + _CRLF + '(F12)';
{$IFDEF DEBUG}
  btnWelfarePayTest.Visible := True;
{$ENDIF}
  panMealInfo.Visible := False;

  panBasePanel.Top := 0;
  panBasePanel.Left := (Self.Width div 2) - (panBasePanel.Width div 2);
  panBasePanel.Width := 1024; //고정값
  panBasePanel.Height := wppBack.Height;

  if (SaleManager.StoreInfo.POSType = CPO_SALE_FOODCOURT) then
  begin
    panMealInfo.Visible := True;
    DispWelfareMealInfo;
  end;

  with pgcExtPage do
  begin
    for i := 0 to Pred(PageCount) do
      Pages[i].TabVisible := False;
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

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

procedure TXGSalePosCafeForm.btnSaleSearchProductClick(Sender: TObject);
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

destructor TXGSalePosCafeForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGSalePosCafeForm.PluginModuleShow(Sender: TObject);
begin
  btnV1Up.Height := (G1.Height div 2);
  btnV2Up.Height := (pgcExtPage.Height div 2);
  btnV3Up.Height := (pgcExtPage.Height div 2);
end;

procedure TXGSalePosCafeForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TXGSalePosCafeForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
end;

procedure TXGSalePosCafeForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
  Global.DeviceConfig.WelfareCardReader.OwnerId := Self.PluginID;
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
end;

procedure TXGSalePosCafeForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := 0;
  Global.DeviceConfig.WelfareCardReader.OwnerId := 0;
end;

procedure TXGSalePosCafeForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGSalePosCafeForm.ProcessMessages(AMsg: TPluginMessage);
var
  nCount: Integer;
  sValue, sCondDiv, sErrMsg: string;
begin
  try
    if (AMsg.Command = CPC_INIT) then
    begin
      FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
      SetTableTitle;
    end;

    if (AMsg.Command = CPC_CLOSE) then
      CloseAction;

    if (AMsg.Command = CPC_SET_FOREGROUND) then
    begin
      SetTableTitle;
      sValue := AMsg.ParamByString(CPP_PRODUCT_CD);
      if not sValue.IsEmpty then
        ClientDM.QRSaleItem.Locate('product_cd', sValue, []);
      if (GetForegroundWindow <> Self.Handle) then
        SetForegroundWindow(Self.Handle);
    end;

    if (AMsg.Command = CPC_ACTIVE_TABLE) then
      SetTableTitle;

    //상품 검색
    if (AMsg.Command = CPC_SELECT_PROD_ITEM) then
      if not ClientDM.UpdateSaleListCafe(
          Global.TableInfo.ActiveTableNo,
          Global.TableInfo.DelimitedGroupTableList,
          AMsg.ParamByString(CPP_PRODUCT_DIV),
          '',
          AMsg.ParamByString(CPP_PRODUCT_CD),
          AMsg.ParamByString(CPP_PRODUCT_NAME),
          AMsg.ParamByInteger(CPP_PRODUCT_AMT),
          0, 1, 0, 0, sErrMsg) then
        raise Exception.Create('구매목록에 상품을 추가할 수 없습니다!' + _CRLF + sErrMsg);

    //할인쿠폰 스캔 결과(From Dashboard)
    if (AMsg.Command = CPC_SEND_QRCODE_COUPON) then
    begin
      sValue := AMsg.ParamByString(CPP_QRCODE);
      if (not ClientDM.GetCouponInfo(sValue, sErrMsg)) then
        raise Exception.Create('회원 정보가 인식되지 않았거나' + _CRLF +
          '사용 가능한 쿠폰 정보가 없습니다!' + _CRLF + sErrMsg);
    end;

    //스캔한 할인쿠폰의 사용 가능 여부 검사
    if (AMsg.Command = CPC_SEND_COUPON_INFO) then
    try
      (*
      if (CouponRec.MemberNo <> SaleManager.MemberInfo.MemberNo) then
        raise Exception.Create('이 회원은 사용할 수 없는 쿠폰입니다!');
      *)
      if ClientDM.QRCoupon.LocateRecord('qr_code', CouponRec.QrCode, []) then
        raise Exception.Create('이미 적용한 쿠폰입니다!');
      if (CouponRec.DcCondDiv <> CCU_REPEAT) and
         (ClientDM.QRCoupon.RecordCount > 0) then
        raise Exception.Create('중복할인을 적용할 수 없는 쿠폰입니다!');
      if (CouponRec.StartDay > Global.CurrentDate) or
         (CouponRec.ExpireDay < Global.CurrentDate) or
         (CouponRec.UseCnt = 0) or
         (CouponRec.UseYN = CRC_YES) then
        raise Exception.Create('사용할 수 없는 쿠폰입니다!');

      sCondDiv := IIF(CouponRec.DcCondDiv = CCU_REPEAT, '중복', IIF(CouponRec.DcCondDiv = CCU_EXCLUSIVE, '단독', '')) + '할인';
      nCount := ClientDM.ApplyCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg);
      if (nCount = 0) then
        raise Exception.Create(IIF(sErrMsg.IsEmpty, '사용할 수 없는 쿠폰입니다!', sErrMsg) + _CRLF +
          Format('쿠폰명 : [%s] %s', [sCondDiv, CouponRec.CouponName]) + _CRLF +
          Format('사용기간 : %s ~ %s', [CouponRec.StartDay, CouponRec.ExpireDay]) + _CRLF +
          Format('잔여횟수 : %d (%s)', [CouponRec.UseCnt, CouponRec.UseStatus]));

      ClientDM.AddDiscountCoupon(Global.TableInfo.ActiveTableNo);
      ClientDM.RefreshCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      ClientDM.ReCalcCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg);
      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    finally
      CouponRec.Clear;
    end;

    if (AMsg.Command = CPC_SEND_MEMBER_NO) then
    begin

    end;

    //복지카드 결제
    if (AMsg.Command = CPC_SEND_WELFARE_CODE) then
    begin
      sValue := AMsg.ParamByString(CPP_WELFARE_CODE);
      if (SaleManager.StoreInfo.POSType = CPO_SALE_FOODCOURT) then
        DoPayMealCoupon(sValue)
      else
        DoPayWelfare(sValue);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
        btnPayVoucher.Click;
      VK_F6:
        btnSaleSearchProduct.Click;
      VK_F7:
        btnWelfare.Click;
      VK_F8:
        btnPayment.Click;
      VK_F9:
        btnCoupon.Click;
      VK_F10:
        btnReceiptView.Click;
      VK_F11:
        btnPartnerCenter.Click;
      VK_F12:
        btnSaleTable.Click;
      VK_RETURN:
        btnSaleComplete.Click;
      VK_ADD:
        btnSaleItemIncQty.Click;
      VK_SUBTRACT:
        btnSaleItemDecQty.Click;
    end;
  end
  else
  begin
    if (ssAlt in Shift) and (Key = VK_F10) then
      btnCalculator.Click;
  end;
end;

procedure TXGSalePosCafeForm.StartUp;
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

procedure TXGSalePosCafeForm.tmrClockTimer(Sender: TObject);
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

procedure TXGSalePosCafeForm.btnPayCashClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
    Exit;

  try
    if (SaleManager.ReceiptInfo.WelfarePayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

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
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnReCalcCouponClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if ClientDM.ReCalcCouponDiscount(Global.TableInfo.ActiveTableNo, sErrMsg) then
    ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList)
  else
    XGMsgBox(Self.Handle, mtWarning, '알림', '할인쿠폰을 재계산할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
end;

procedure TXGSalePosCafeForm.btnReceiptViewClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('XGReceiptView' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGSalePosCafeForm.btnPayCardClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      Exit;

    if (SaleManager.ReceiptInfo.WelfarePayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

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
        pgcExtPage.ActivePage := tabPayment;
        if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
          btnSaleComplete.Click;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnCategoryPrevClick(Sender: TObject);
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

procedure TXGSalePosCafeForm.btnMealProdChangeClick(Sender: TObject);
begin
  if FWelfareMealSelected then
  begin
    if SaleManager.StoreInfo.MealCode.IsEmpty or
       (SaleManager.StoreInfo.MealPrice = 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '선택한 직원급식 상품이 없습니다!', ['확인'], 5);
      Exit;
    end;

    FWelfareMealSelected := False;
    TcxButton(Sender).Caption := '변경';
    DispWelfareMealInfo;

    with Global.ConfigLocal do
    begin
      WriteString('MealInfo', 'MealCode', SaleManager.StoreInfo.MealCode);
      WriteString('MealInfo', 'MealName', SaleManager.StoreInfo.MealName);
      WriteInteger('MealInfo', 'MealPrice', SaleManager.StoreInfo.MealPrice);
      UpdateFile;
    end;
    XGMsgBox(Self.Handle, mtInformation, '알림', '직원급식 상품이 변경되었습니다!', ['확인'], 5);
  end else
  begin
    FWelfareMealSelected := True;
    TcxButton(Sender).Caption := '적용';
    lblWelfareMealInfo.Caption := '직원급식 상품을 선택하여 주세요!';
  end;
end;

procedure TXGSalePosCafeForm.btnCloseClick(Sender: TObject);
begin
  CloseAction;
end;

procedure TXGSalePosCafeForm.ShowHome;
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SET_FOREGROUND;
    PluginMessageToID(Global.StartModuleId);
  finally
    Free;
  end;
end;

procedure TXGSalePosCafeForm.CloseAction;
begin
  if (XGMsgBox(Self.Handle, mtConfirmation, '프로그램 종료', '프로그램을 종료하시겠습니까?', ['확인', '취소']) <> mrOK) then
  begin
    Global.Closing := False;
    Exit;
  end;

  Global.Closing := True;
  try
    SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
  finally
    Close;
  end;
end;

procedure TXGSalePosCafeForm.DoPayWelfare(const AWelfareCode: string);
var
  nDcAmt, nRemainPoint, nUsePoint: Integer;
  sErrMsg: string;
begin
  try
    if (SaleManager.ReceiptInfo.CashPayAmt > 0) or
       (SaleManager.ReceiptInfo.CardPayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

    if not ClientDM.SearchMemberByCode(CMC_WELFARE_CODE, AWelfareCode, sErrMsg) then
      raise Exception.Create('일치하는 직원 정보가 없습니다!' + _CRLF + '(복지카드번호: ' + AWelfareCode + ')');

    if (ClientDM.QRSaleItem.RecordCount = 0) or
       (SaleManager.ReceiptInfo.UnpaidTotal = 0) then
      raise Exception.Create('판매할 상품이 등록되지 않았거나' + _CRLF + '결제할 금액이 없습니다!');

    btnWelfare.Click;
    SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo;
    nDcAmt := ClientDM.GetWelfareDiscountAmt(Global.TableInfo.ActiveTableNo);
    nUsePoint := (SaleManager.ReceiptInfo.ChargeTotal - nDcAmt);
    nRemainPoint := (SaleManager.MemberInfo.WelfarePoint - nUsePoint);
    if (nRemainPoint < 0) then
      raise Exception.Create('잔액이 부족하여 복지카드 결제요청을 처리할 수 없습니다!');

    if not ClientDM.UpdateWelfarePayment(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList, nUsePoint, sErrMsg) then
      raise Exception.Create(sErrMsg);

    SaleManager.ReceiptInfo.WelfarePayAmt := nUsePoint;
    //nMileage := SaleManager.MemberInfo.WelfarePoint;
    SaleManager.MemberInfo.WelfarePoint := nRemainPoint;
    sndPlaySound(PChar(Global.MediaDir + CMF_WAV_SUCCESS), SND_ASYNC);
    lbxWelfareLog.Items.Insert(0, SaleManager.MemberInfo.MemberName + '님 복지카드 결제 완료 (잔액: ' +
      FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint) + '원)');
//    UpdateLog(Global.LogFile, Format('DoPayWelfareByRFID() = EmpName: %s, WelfareCode: %s, Mileage: %d, Discount: %d, UsePoint: %d, Remain: %d',
//      [
//        SaleManager.MemberInfo.MemberName,
//        SaleManager.MemberInfo.WelfareCode,
//        nMileage,
//        nDcAmt,
//        nUsePoint,
//        nRemainPoint
//      ]));
    btnSaleComplete.Click;
  except
    on E: Exception do
    begin
      sndPlaySound(PChar(Global.MediaDir + CMF_WAV_FAIL), SND_ASYNC);
      XGMsgBox(Self.Handle, mtError, '복지포인트 결제', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGSalePosCafeForm.DoPayWelfareByEmpName(const AEmpName: string);
var
  nDcAmt, nRemainPoint, nUsePoint: Integer;
  sErrMsg: string;
begin
  try
    nDcAmt := 0;
    if (SaleManager.StoreInfo.POSType = CPO_SALE_FOODCOURT) then
    begin
      if (ClientDM.QRSaleItem.RecordCount > 0) or
         (ClientDM.QRPayment.RecordCount > 0) or
         (ClientDM.QRCoupon.RecordCount > 0) then
        raise Exception.Create('완료되지 않은 거래가 있으므로' + _CRLF + '복지카드 결제요청을 처리할 수 없습니다!');
    end else
    begin
      if (ClientDM.QRSaleItem.RecordCount = 0) or
         (SaleManager.ReceiptInfo.UnpaidTotal = 0) then
        raise Exception.Create('판매할 상품이 등록되지 않았거나' + _CRLF + '결제할 금액이 없습니다!');
    end;

    if (SaleManager.ReceiptInfo.CashPayAmt > 0) or
       (SaleManager.ReceiptInfo.CardPayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

    if not ClientDM.GetMemberSearch('', AEmpName, '', '', CRC_YES, False, 0, sErrMsg) then
      raise Exception.Create(sErrMsg);

    if (ClientDM.MDMemberSearch.RecordCount = 0) then
      raise Exception.Create('일치하는 직원 정보가 없습니다!' + _CRLF + '(검색직원: ' + AEmpName + ')');

    if (ClientDM.MDMemberSearch.RecordCount > 1) then
      with TXGMemberPopupForm.Create(nil) do
      try
        if (ShowModal <> mrOk) then
          Exit;
      finally
        Free;
      end;

    ClientDM.SetMemberInfo(TDataSet(ClientDM.MDMemberSearch));
    SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo;
    if (SaleManager.StoreInfo.POSType = CPO_SALE_FOODCOURT) then
      if not ClientDM.UpdateSaleListCafe(
          Global.TableInfo.ActiveTableNo,
          Global.TableInfo.DelimitedGroupTableList,
          CPD_GENERAL,
          '',
          SaleManager.StoreInfo.MealCode,
          SaleManager.StoreInfo.MealName,
          SaleManager.StoreInfo.MealPrice,
          0, 1, 0, 0, sErrMsg) then
        raise Exception.Create('구매목록에 상품을 추가할 수 없습니다!' + _CRLF + sErrMsg);

    if ClientDM.QRSaleItem.FieldByName('direct_dc_amt').AsInteger = 0 then
      nDcAmt := ClientDM.GetWelfareDiscountAmt(Global.TableInfo.ActiveTableNo);
    nUsePoint := (SaleManager.ReceiptInfo.ChargeTotal - nDcAmt);
    nRemainPoint := (SaleManager.MemberInfo.WelfarePoint - nUsePoint);
    if (nRemainPoint < 0) then
      raise Exception.Create('잔액이 부족하여 복지카드 결제요청을 처리할 수 없습니다!');

    if not ClientDM.UpdateWelfarePayment(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList, nUsePoint, sErrMsg) then
      raise Exception.Create(sErrMsg);

    SaleManager.ReceiptInfo.WelfarePayAmt := nUsePoint;
    //nMileage := SaleManager.MemberInfo.WelfarePoint;
    SaleManager.MemberInfo.WelfarePoint := nRemainPoint;
    sndPlaySound(PChar(Global.MediaDir + CMF_WAV_SUCCESS), SND_ASYNC);
    lbxWelfareLog.Items.Insert(0, SaleManager.MemberInfo.MemberName + '님 복지카드 결제 완료 (잔액: ' +
      FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint) + '원)');
//    UpdateLog(Global.LogFile, Format('DoPayWelfareByEmpName() = EmpName: %s, WelfareCode: %s, Mileage: %d, Discount: %d, UsePoint: %d, Remain: %d',
//      [
//        SaleManager.MemberInfo.MemberName,
//        SaleManager.MemberInfo.WelfareCode,
//        nMileage,
//        nDcAmt,
//        nUsePoint,
//        nRemainPoint
//      ]));
    btnSaleComplete.Click;
  except
    on E: Exception do
    begin
      sndPlaySound(PChar(Global.MediaDir + CMF_WAV_FAIL), SND_ASYNC);
      XGMsgBox(Self.Handle, mtError, '복지포인트 결제', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGSalePosCafeForm.DoPayMealCoupon(const AWelfareCode: string);
var
  nRemainPoint, nUsePoint: Integer;
  sErrMsg: string;
begin
  try
    if (ClientDM.QRSaleItem.RecordCount > 0) or
       (ClientDM.QRPayment.RecordCount > 0) or
       (ClientDM.QRCoupon.RecordCount > 0) then
      raise Exception.Create('완료되지 않은 거래가 있으므로' + _CRLF + '직원급식 결제요청을 처리할 수 없습니다!');

    if (SaleManager.ReceiptInfo.CashPayAmt > 0) or
       (SaleManager.ReceiptInfo.CardPayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

    if SaleManager.StoreInfo.MealCode.IsEmpty or
       (SaleManager.StoreInfo.MealPrice = 0) then
      raise Exception.Create('직원급식 상품이 설정되지 않았습니다');

    if not ClientDM.SearchMemberByCode(CMC_WELFARE_CODE, AWelfareCode, sErrMsg) then
      raise Exception.Create('일치하는 직원 정보가 없습니다!' + _CRLF + '(복지카드번호: ' + AWelfareCode + ')');

    nUsePoint := (SaleManager.StoreInfo.MealPrice - Floor(SaleManager.StoreInfo.MealPrice * (SaleManager.MemberInfo.WelfareRate / 100)));
    nRemainPoint := (SaleManager.MemberInfo.WelfarePoint - nUsePoint);
    if (nRemainPoint < 0) then
      raise Exception.Create('잔액이 부족하여 복지카드 결제요청을 처리할 수 없습니다!');

    btnWelfare.Click;
    SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo;
    if not ClientDM.UpdateSaleListCafe(
        Global.TableInfo.ActiveTableNo,
        Global.TableInfo.DelimitedGroupTableList,
        CPD_GENERAL,
        '',
        SaleManager.StoreInfo.MealCode,
        SaleManager.StoreInfo.MealName,
        SaleManager.StoreInfo.MealPrice,
        0, 1, 0, 0, sErrMsg) then
      raise Exception.Create('구매목록에 상품을 추가할 수 없습니다!' + _CRLF + sErrMsg);

    if not ClientDM.UpdateWelfarePayment(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList, nUsePoint, sErrMsg) then
      raise Exception.Create(sErrMsg);

    sndPlaySound(PChar(Global.MediaDir + CMF_WAV_SUCCESS), SND_ASYNC);
    SaleManager.ReceiptInfo.WelfarePayAmt := nUsePoint;
    SaleManager.MemberInfo.WelfarePoint := nRemainPoint;
    lbxWelfareLog.Items.Insert(0, SaleManager.MemberInfo.MemberName + '님 복지카드 결제 완료 (잔액: ' + FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint) + '원)');

    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      btnSaleComplete.Click;
  except
    on E: Exception do
    begin
      sndPlaySound(PChar(Global.MediaDir + CMF_WAV_FAIL), SND_ASYNC);
      XGMsgBox(Self.Handle, mtError, '복지포인트 결제', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGSalePosCafeForm.CategoryMenuCallBack(const ACategoryIndex: Integer);
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

procedure TXGSalePosCafeForm.SaleItemMenuCallback(const ACategoryIndex, AItemPage: Integer);
var
  nButton, nItem: integer;
begin
  try
    for nButton := 0 to Pred(SaleManager.SaleMenuManager.ItemPerPage) do
    begin
      nItem := (SaleManager.SaleMenuManager.ActiveItemPage * SaleManager.SaleMenuManager.ItemPerPage) + nButton;
      if (nItem <= Pred(SaleManager.SaleMenuManager.GetItemCount(ACategoryIndex))) then
      begin
        FSaleItemButtons[nButton].Visible := True;
        FSaleItemButtons[nButton].Caption.FirstCaption.Text := SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductName;
        FSaleItemButtons[nButton].Caption.SecondCaption.Text := '';
        FSaleItemButtons[nButton].Caption.ThirdCaption.Text := FormatCurr(',0', SaleManager.SaleMenuManager.SaleItems[ACategoryIndex, nItem].ProductAmt);
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
  finally
//    btnSaleItemPrev.Enabled := (SaleManager.SaleMenuManager.ActiveItemPage > 0);
//    btnSaleItemNext.Enabled := (SaleManager.SaleMenuManager.ActiveItemPage < Pred(SaleManager.SaleMenuManager.ItemPageCount[SaleManager.SaleMenuManager.ActiveItemPage]));
  end;
end;

procedure TXGSalePosCafeForm.btnPayVoucherClick(Sender: TObject);
begin
//
end;

procedure TXGSalePosCafeForm.btnAddonTicketClick(Sender: TObject);
begin
//
end;

procedure TXGSalePosCafeForm.btnAddPendingClick(Sender: TObject);
var
  sErrMsg: string;
begin
  try
    if (ClientDM.QRSaleItem.RecordCount = 0) and
       (ClientDM.QRPayment.RecordCount = 0) then
      raise Exception.Create('보류로 등록할 판매내역이 없습니다!');

    if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
          '현재 주문내역을 보류상태로 등록하시겠습니까?', ['보류등록', '취소']) = mrOK) then
    begin
      if not ClientDM.AddPending(Global.TableInfo.ActiveTableNo, sErrMsg) then
        raise Exception.Create(sErrMsg);

      //판매 초기화
      SaleManager.ReceiptInfo.Clear;
      ClearSaleData;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnCalculatorClick(Sender: TObject);
var
  dValue: Double;
begin
  ShowCalculator(dValue);
end;

procedure TXGSalePosCafeForm.btnCancelCouponClick(Sender: TObject);
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
      XGMsgBox(Self.Handle, mtError, '알림', '쿠폰 할인내역을 삭제할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnCategoryNextClick(Sender: TObject);
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

procedure TXGSalePosCafeForm.btnSaleItemPrevClick(Sender: TObject);
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

procedure TXGSalePosCafeForm.btnSalePartnerCenterClick(Sender: TObject);
begin
  btnPartnerCenter.Click;
end;

procedure TXGSalePosCafeForm.btnSaleTableClick(Sender: TObject);
begin
  ShowSalePosTable(Self.PluginID);
end;

procedure TXGSalePosCafeForm.btnSearchEmpClick(Sender: TObject);
var
  sEmpName: string;
begin
  sEmpName := Trim(edtEmpInfo.Text);
  if not sEmpName.IsEmpty then
    DoPayWelfareByEmpName(sEmpName);
end;

procedure TXGSalePosCafeForm.btnSaleItemNextClick(Sender: TObject);
var
  nNewPage: integer;
begin
  with SaleManager.SaleMenuManager do
  begin
    nNewPage := Succ(ActiveItemPage);
    if (nNewPage > Pred(ItemPageCount[CurrentCategoryIndex])) then
      nNewPage := 0;

    SetItemPage(CurrentCategoryIndex, nNewPage, SaleItemMenuCallback);
  end;
end;

procedure TXGSalePosCafeForm.btnSaleItemDeleteClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) then
    begin
      if not ExecuteABSQuery(
          Format('DELETE FROM TBSaleItem WHERE table_no = %d AND product_cd = %s', [
            Global.TableInfo.ActiveTableNo,
            QuotedStr(FieldByName('product_cd').AsString)]),
          sErrMsg) then
        raise Exception.Create(sErrMsg);

      ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
      if (RecordCount = 0) and
         (ClientDM.QRPayment.RecordCount = 0) then
        ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '주문 상품을 삭제할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnSaleItemClearClick(Sender: TObject);
begin
  if (ClientDM.QRSaleItem.RecordCount > 0) and
     (XGMsgBox(Self.Handle, mtConfirmation, '확인', '주문 내역을 모두 취소하시겠습니까?', ['예', '아니오']) = mrOK) then
  begin
    ClientDM.ClearSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    if (ClientDM.QRPayment.RecordCount = 0) then
      ClientDM.ClearCouponTable(Global.TableInfo.ActiveTableNo);
  end;
end;

procedure TXGSalePosCafeForm.btnSaleItemIncQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sErrMsg: string;
begin
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) then
    begin
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
      XGMsgBox(Self.Handle, mtError, '알림', '주문 상품의 수량을 변경할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnSaleItemDecQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sErrMsg: string;
begin
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
      XGMsgBox(Self.Handle, mtError, '알림', '주문 상품의 수량을 변경할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnSaleItemChangeQtyClick(Sender: TObject);
var
  nOrderQty: Integer;
  sErrMsg: string;
begin
  nOrderQty := StrToIntDef(InputBuffer, 0);
  with ClientDM.QRSaleItem do
  try
    if (RecordCount > 0) and
       (nOrderQty > 0) then
    begin
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
      XGMsgBox(Self.Handle, mtError, '알림', '주문 상품의 수량을 변경할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnHomeClick(Sender: TObject);
begin
  ShowHome;
end;

procedure TXGSalePosCafeForm.btnItemDiscountCancelClick(Sender: TObject);
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
      XGMsgBox(Self.Handle, mtError, '알림', '할인쿠폰 취소' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnLoadPendingClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    if (PluginManager.OpenModal('XGPendingView' + CPL_EXTENSION, PM) = mrOK) then
      DispSaleResult;
 finally
    FreeAndNil(PM);
  end;
end;

procedure TXGSalePosCafeForm.btnNumBSClick(Sender: TObject);
begin
  if not InputBuffer.IsEmpty then
    InputBuffer := Trim(Copy(InputBuffer, 1, Pred(Length(InputBuffer))));
end;

procedure TXGSalePosCafeForm.btnNumCLClick(Sender: TObject);
begin
  InputBuffer := '';
end;

procedure TXGSalePosCafeForm.btnOpenDrawerClick(Sender: TObject);
begin
  OpenCashDrawer;
end;

procedure TXGSalePosCafeForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGSalePosCafeForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGSalePosCafeForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGSalePosCafeForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;

procedure TXGSalePosCafeForm.btnWelfarePayTestClick(Sender: TObject);
begin
  WelfarePayTest;
end;

procedure TXGSalePosCafeForm.OnNumPadClick(Sender: TObject);
begin
  with TcyAdvSpeedButton(Sender) do
    InputBuffer := InputBuffer + StringOfChar(Chr(Tag), HelpContext);
end;

procedure TXGSalePosCafeForm.btnSaleCompleteClick(Sender: TObject);
var
  sErrMsg, sMemberInfo, sReceiptJson: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  TcyAdvSpeedButton(Sender).Enabled := False;
  try
    try
      if (SaleManager.ReceiptInfo.WelfarePayAmt = 0) then
      begin
        if (ClientDM.QRSaleItem.RecordCount = 0) then
          Exit; //raise Exception.Create('상품 판매 내역이 등록되지 않았습니다!');
        if (SaleManager.ReceiptInfo.ReceiveTotal > SaleManager.ReceiptInfo.ChargeTotal) then
          raise Exception.Create('결제한 금액이 받을 금액보다 더 많습니다!');
//        if (SaleManager.ReceiptInfo.CardPayAmt > SaleManager.ReceiptInfo.ChargeTotal) then
//          raise Exception.Create('신용카드로 결제한 금액이 받을 금액보다 더 많습니다!');
        if (SaleManager.ReceiptInfo.UnPaidTotal > 0) then
          raise Exception.Create('상품 금액의 결제가 완료되지 않았습니다!' + _CRLF +
            '미결제금액: ' + FormatCurr('#,##0', SaleManager.ReceiptInfo.UnPaidTotal));
      end;

      SaleManager.ReceiptInfo.SaleMemo := mmoSaleMemo.Text;
      if not ClientDM.PostProdSale(Global.TableInfo.ActiveTableNo, sErrMsg) then
        raise Exception.Create('장애가 발생하여 매출 등록을 완료할 수 없습니다!' + _CRLF + sErrMsg);

      if SaleManager.ReceiptInfo.ParkingError then
        XGMsgBox(0, mtError, '알림', '장애가 발생하여 주차권 정보를 등록할 수 없습니다!' + _CRLF +
          '주차관제 시스템에서 직접 등록하여 주십시오.' + _CRLF + SaleManager.ReceiptInfo.ParkingErrorMessage, ['확인'], 5);
      if SaleManager.ReceiptInfo.FacilityError then
        XGMsgBox(0, mtError, '알림', '장애가 발생하여 부대시설 이용권을 발행할 수 없습니다!' + _CRLF +
          SaleManager.ReceiptInfo.FacilityErrorMessage, ['확인'], 5);

      //영수증 출력용 전문 생성
      sReceiptJson := ClientDM.MakeReceiptJson(False, sErrMsg);
      if sReceiptJson.IsEmpty then
        raise Exception.Create('영수증 출력정보가 생성되지 않았습니다!' + _CRLF + sErrMsg);

      //카페POS는 주방주문서 출력
      if (SaleManager.StoreInfo.POSType = CPO_SALE_CAFE) then
      begin
        sMemberInfo := SaleManager.MemberInfo.MemberName;
        if (SaleManager.ReceiptInfo.WelfarePayAmt <> 0) then
          sMemberInfo := sMemberInfo + '님 (포인트사용: ' +
//            SaleManager.MemberInfo.MemberName + '님 (포인트사용: ' +
            FormatFloat('#,##0', SaleManager.ReceiptInfo.WelfarePayAmt) + '원 / 잔액: ' +
//            SaleManager.MemberInfo.MemberName + '원 / 잔액: ' +
            FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint) + '원)';

        try
          if not sErrMsg.IsEmpty then
            raise Exception.Create(sErrMsg);

          if Global.DeviceConfig.ReceiptPrinter.Enabled and
             not Global.ReceiptPrint.KitchenOrderPrint(sReceiptJson, SaleManager.ReceiptInfo.ReceiptNo, sMemberInfo, sErrMsg) then
            raise Exception.Create(sErrMsg);
        except
          on E: Exception do
            XGMsgBox(Self.Handle, mtError, '알림', '주방주문서 출력에 장애가 발생했습니다!' + _CRLF + E.Message, ['확인'], 5);
        end;
      end;

      //복지카드 결제는 영수증 출력 안함
      if (SaleManager.ReceiptInfo.WelfarePayAmt = 0) then
      begin
        try
          if not sErrMsg.IsEmpty then
            raise Exception.Create(sErrMsg);

          Global.ReceiptPrint.IsReturn := False;
          if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, False, False, sErrMsg) then
            raise Exception.Create(sErrMsg);
        except
          on E: Exception do
            XGMsgBox(Self.Handle, mtError, '알림', '영수증 출력에 장애가 발생했습니다!' + _CRLF + E.Message, ['확인'], 5);
        end;
      end;

      if (ClientDM.QRPayment.RecordCount <> 0) and
         (ClientDM.QRPayment.FieldByName('pay_method').AsString = CPM_CASH) then
        OpenCashDrawer;

      if (not SaleManager.ReceiptInfo.PendReceiptNo.IsEmpty) and
         (not ClientDM.DeletePending(SaleManager.ReceiptInfo.PendReceiptNo, sErrMsg)) then
        XGMsgBox(Self.Handle, mtError, '알림',
           '이전 보류내역을 삭제하지 못하였습니다!' + _CRLF +
           '보류내역 조회 화면에서 직접 삭제하여 주시기 바랍니다.' + _CRLF + sErrMsg, ['확인']);

      //판매 초기화
      SaleManager.ReceiptInfo.Clear;
      SaleManager.MemberInfo.Clear;
      ClearSaleData;

      //구내식당의 경우에는 거래완료 메시지 표출하지 않음
      if (SaleManager.StoreInfo.POSType <> CPO_SALE_FOODCOURT) then
        XGMsgBox(Self.Handle, mtInformation, '알림', '거래가 완료되었습니다!', ['확인'], 5);

      if (SaleManager.StoreInfo.POSType = CPO_SALE_SCREEN_ROOM) then
        btnSaleTable.Click;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    TcyAdvSpeedButton(Sender).Enabled := True;
    FWorking := False;
  end;
end;

procedure TXGSalePosCafeForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGSalePosCafeForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGSalePosCafeForm.OnCategoryButtonClick(Sender: TObject);
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

procedure TXGSalePosCafeForm.OnSaleItemButtonClick(Sender: TObject);
var
  nItem, nProdAmt, nXGolfDCAmt: Integer;
  sCategory, sProdDiv, sProdCode, sChildProdDiv, sProdName, sZoneCode, sErrMsg: string;
  bUseRefund: Boolean;
begin
  if FWorking then
    Exit;
  FWorking := True;
  with SaleManager do
  try
    try
      nItem := TSolbiTouchButton(Sender).Tag;
      if (nItem < 0) then
        Exit;

      if (ClientDM.QRSaleItem.RecordCount = 0) and
         (ClientDM.QRPayment.RecordCount = 0) and
         (ClientDM.QRCoupon.RecordCount = 0) then
        ClearSaleData; //판매 초기화

      SaleMenuManager.CurrentItemIndex := nItem;
      sCategory     := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].CategoryCode;
      sProdDiv      := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ProductDiv;
      sChildProdDiv := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ChildProdDiv;
      sProdCode     := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ProductCode;
      sProdName     := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ProductName;
      sZoneCode     := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ZoneCode;
      nProdAmt      := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].ProductAmt;
  //    nKeepAmt      := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].KeepAmt;
  //    nUseMonth     := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].UseMonth;
      bUseRefund    := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].UseRefund;
      nXGolfDCAmt   := 0;
      if not MemberInfo.XGolfMemberNo.IsEmpty then
        nXGolfDCAmt := SaleMenuManager.SaleItems[SaleMenuManager.CurrentCategoryIndex, nItem].XGolfDCAmt;

      if FWelfareMealSelected then
      begin
        SaleManager.StoreInfo.MealCode  := sProdCode;
        SaleManager.StoreInfo.MealName  := sProdName;
        SaleManager.StoreInfo.MealPrice := nProdAmt;
        btnMealProdChange.Click;
        Exit;
      end;

      if MemberInfo.MemberNo.IsEmpty and
         ((sProdDiv = CPD_LOCKER) or
          ((sProdDiv = CPD_TEEBOX) and (sChildProdDiv <> CTP_DAILY))) then
        raise Exception.Create('비회원은 구매할 수 없는 상품입니다!');

      //환불 처리 상품
      if bUseRefund then
      begin
        nProdAmt := SetProductAmt;
        if (nProdAmt = 0) then
          Exit;

        if not ClientDM.UpdateSaleListCafe(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList, sProdDiv, sChildProdDiv, sProdCode, sProdName, nProdAmt, 0, 1, 0, 0, sErrMsg) then
          raise Exception.Create('구매목록에 상품을 추가할 수 없습니다!' + _CRLF + sErrMsg);
      end
      else
        if not ClientDM.UpdateSaleListCafe(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList, sProdDiv, sChildProdDiv, sProdCode, sProdName, nProdAmt, nXGolfDCAmt, 1, 0, 0, sErrMsg) then
          raise Exception.Create('구매목록에 상품을 추가할 수 없습니다!' + _CRLF + sErrMsg);
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인']);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGSalePosCafeForm.pgcExtPageChange(Sender: TObject);
var
  nIdx: Integer;
begin
  nIdx := TcxPageControl(Sender).ActivePageIndex;
  btnPayCancel.Enabled := (nIdx = 0);
  btnCancelCoupon.Enabled := (nIdx = 1);
  btnReCalcCoupon.Enabled := (nIdx = 1);
end;

procedure TXGSalePosCafeForm.V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
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
  end;

  DispSaleResult;
end;

procedure TXGSalePosCafeForm.V2DataControllerDataChanged(Sender: TObject);
begin
  DispSaleResult;
end;

procedure TXGSalePosCafeForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
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

procedure TXGSalePosCafeForm.SetInputBuffer(const AValue: string);
begin
  FInputBuffer := AValue;
  with edtInputCapture do
  begin
    Text := FormatCurr('#,##0', StrToCurrDef(FInputBuffer, 0));
    SelStart := Length(Text) + 1;
  end;
end;

function TXGSalePosCafeForm.SetProductAmt: Integer;
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

procedure TXGSalePosCafeForm.ClearSaleData;
begin
  edtEmpInfo.Text := '';
  LockerRec.Clear;
  mmoSaleMemo.Lines.Clear;
  ClientDM.ClearSaleTables(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
  SendPluginCommand(CPC_REFRESH_GROUP_TABLE, Self.PluginID, Global.SaleTableFormId);
//  SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo;
//  V1.Bands[0].Caption := Format('[T%d] 주문 내역 (%s)', [Global.TableInfo.ActiveTableNo, SaleManager.ReceiptInfo.ReceiptNo]);
  DispSaleResult;
end;

procedure TXGSalePosCafeForm.DispSaleResult;
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

    if Global.SubMonitor.Enabled then
    begin
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_SALE_RESULT;
        if (ClientDM.QRSaleItem.RecordCount > 0) then
          PM.AddParams(CPP_PRODUCT_NAME, ClientDM.QRSaleItem.FieldByName('product_nm').AsString);
        PM.AddParams(CPP_SELL_AMT,     SellTotal);
        PM.AddParams(CPP_VAT_AMT,      VatTotal);
        PM.AddParams(CPP_CHARGE_AMT,   ChargeTotal);
        PM.AddParams(CPP_DISCOUNT_AMT, DiscountTotal);
        PM.AddParams(CPP_PAID_AMT,     ReceiveTotal);
        PM.AddParams(CPP_UNPAID_AMT,   UnPaidTotal);
        PM.AddParams(CPP_CHANGE_AMT,   ChangeTotal);
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

procedure TXGSalePosCafeForm.edtInputCaptureEnter(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGSalePosCafeForm.btnDiscountAmoutClick(Sender: TObject);
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
        XGMsgBox(Self.Handle, mtWarning, '알림', '선택 상품의 청구 금액보다 할인 금액이 더 큽니다!', ['확인'], 5);
      InputBuffer := '0';
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '품목 금액할인' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnDiscountPercentClick(Sender: TObject);
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
        XGMsgBox(Self.Handle, mtWarning, '알림', '선택 상품의 청구 금액보다 할인 금액이 더 큽니다!', ['확인'], 5);
      InputBuffer := '0';
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '품목 ％할인' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnExtFuncClick(Sender: TObject);
begin
  pgcExtPage.ActivePageIndex := TcyAdvSpeedButton(Sender).Tag;
end;

procedure TXGSalePosCafeForm.btnPartnerCenterClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'main');
end;

procedure TXGSalePosCafeForm.btnPayCancelClick(Sender: TObject);
var
  PM: TPluginMessage;
  sPayMethod, sApproveNo, sTradeDate, sCardNo, sReceiptJson, sErrMsg: string;
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
    if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
          IIF(bManualApprove, '임의 등록으로 추가한 결제 건입니다.' + _CRLF, '') +
          '결제내역을 취소하시겠습니까?' + _CRLF +
          FieldByName('calc_pay_method').AsString + ' : ' + FormatCurr('#,##0', nPayAmt) + ' 원', ['예', '아니오']) = mrOK) then
    begin
      { 현금 결제 취소 }
      if (sPayMethod = CPM_CASH) then
      begin
        if sApproveNo.IsEmpty then
        begin
          //현금영수증 미발행 결제 취소
          SaleManager.ReceiptInfo.CashPayAmt := (SaleManager.ReceiptInfo.CashPayAmt - nPayAmt);
          SaleManager.PayLog(False, bManualApprove, CPM_CASH, '', '', nPayAmt);
        end
        else
        begin
          //현금영수증 발행 결제 취소
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
      { 신용카드 결제 취소 }
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
      { PAYCO 신용카드 결제 취소 }
      else if (sPayMethod = CPM_PAYCO_CARD) then
      begin
        if not ClientDM.DoPaymentPAYCO(False, True, sErrMsg) then
        begin
          XGMsgBox(0, mtError, '알림', 'PAYCO 취소거래가 완료되지 못하였습니다!' + _CRLF + sErrMsg, ['확인'], 5);
          Exit;
        end;
        XGMsgBox(0, mtInformation, '알림', 'PAYCO 취소거래가 정상적으로 완료되었습니다!', ['확인'], 5);
      end
      { 복지카드 결제 취소 }
      else if (sPayMethod = CPM_WELFARE) then
      begin
        SaleManager.ReceiptInfo.WelfarePayAmt := (SaleManager.ReceiptInfo.WelfarePayAmt - nPayAmt);
        SaleManager.PayLog(False, bManualApprove, CPM_WELFARE, '', '', nPayAmt);
      end
      else
        raise Exception.Create('취소할 수 없는 거래내역입니다!');

      { 취소거래 영수증 출력 }
      sReceiptJson := ClientDM.MakeCancelReceiptJson(ClientDM.QRPayment, sErrMsg);
      if not Global.ReceiptPrint.PaymentSlipPrint(sPayMethod, sReceiptJson, sErrMsg) then
        XGMsgBox(0, mtWarning, '알림', '거래취소 영수증을 출력할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);

      if not ExecuteABSQuery(
            Format('DELETE FROM TBPayment WHERE table_no = %d AND pay_method = %s AND approve_no = %s', [
              Global.TableInfo.ActiveTableNo,
              QuotedStr(FieldByName('pay_method').AsString),
              QuotedStr(FieldByName('approve_no').AsString)]),
            sErrMsg) then
        XGMsgBox(0, mtWarning, '주의', '거래가 정상 취소되었으나 장애가 발생하였습니다!' + sErrMsg, ['확인']);

      ClientDM.RefreshPaymentTable(Global.TableInfo.ActiveTableNo);
      if bManualApprove then
      begin
        SaleManager.PayLog(False, True, sPayMethod, sCardNo, sApproveNo, nPayAmt);
        XGMsgBox(0, mtConfirmation, '주의',
          '임의 등록 결제 건을 취소 처리하였습니다!' + _CRLF +
          '원거래 단말기에서도 반드시 취소를 진행하여 주십시오.', ['확인']);
      end;

      if (RecordCount = 0) and
         (not SaleManager.ReceiptInfo.PendReceiptNo.IsEmpty) and
         (not ClientDM.DeletePending(SaleManager.ReceiptInfo.PendReceiptNo, sErrMsg)) then
        XGMsgBox(Self.Handle, mtWarning, '알림',
           '이전 보류내역을 삭제하지 못하였습니다!' + _CRLF +
           '보류내역 조회 화면에서 직접 삭제하여 주시기 바랍니다.' + _CRLF + sErrMsg, ['확인']);

      DispSaleResult;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.btnPayPAYCOClick(Sender: TObject);
var
  sErrMsg: string;
begin
  try
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      Exit;

    if (SaleManager.ReceiptInfo.WelfarePayAmt > 0) then
      raise Exception.Create('복지카드는 다른 결제수단과 같이 사용할 수 없습니다!');

    if not ClientDM.DoPaymentPAYCO(True, True, sErrMsg) then
      raise Exception.Create('PAYCO 승인거래가 완료되지 못하였습니다!' + _CRLF + sErrMsg);

    btnPayment.Click;
    if (SaleManager.ReceiptInfo.UnPaidTotal = 0) then
      btnSaleComplete.Click;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGSalePosCafeForm.DispWelfareMealInfo;
begin
  with SaleManager.StoreInfo do
    if MealCode.IsEmpty or (MealPrice = 0) then
      lblWelfareMealInfo.Caption := '선택된 직원급식 상품이 없습니다.'
    else
      lblWelfareMealInfo.Caption := MealName + ' (식단가 ' + FormatFloat('#,##0', MealPrice) + '원)';
end;

procedure TXGSalePosCafeForm.WelfarePayTest;
const
  LC_WELFARE_CODE = '4189C18A';
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SEND_WELFARE_CODE;
    AddParams(CPP_WELFARE_CODE, LC_WELFARE_CODE);
    PluginMessageToID(Self.PluginID);
  finally
    Free;
  end;
end;

procedure TXGSalePosCafeForm.SetTableTitle;
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) and // 후불POS(스크린, 식당 등)
     (Global.TableInfo.ActiveTableNo > 0) then
  begin
    panHeader.Font.Color := $000080FF;
    panHeader.Caption := Format('%s [T%d] %s %s', [
      FBaseTitle,
      Global.TableInfo.ActiveTableNo,
      Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].TableName,
      IIF(Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].GroupNo > 0, '(단체)', '')]);
  end
  else
  begin
    panHeader.Font.Color := clWhite;
    panHeader.Caption := FBaseTitle;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGSalePosCafeForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;

end.
