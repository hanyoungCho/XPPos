unit uXGSaleManager;

interface

uses
  System.Classes;

{$I XGPOS.inc}


type
  { POS�޴� Callback �Լ� }
  TCategoryPageChangeCB = reference to procedure(const ACategoryPage: Integer);
  TItemPageChangeCB = reference to procedure(const ACategoryIndex, AItemPage: Integer);
  TFunctionPageChangeCB = reference to procedure(const ANewPageIndex: Integer);

  { ����� ���� }
  TUserInfo = class
  private
    FUserId: string;
    FTerminalPwd: string;
    FUserName: string;
    FHpNo: string;
    FSaveInfo: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    property UserId: string read FUserId write FUserId;
    property TerminalPwd: string read FTerminalPwd write FTerminalPwd;
    property UserName: string read FUserName write FUserName;
    property HpNo: string read FHpNo write FHpNo;
    property SaveInfo: Boolean read FSaveInfo write FSaveInfo;
  end;

  { ȸ�� ���� }
  TMemberInfo = class
  private
    FMemberNo: string;
    FMemberSeq: Integer;
    FMemberQRCode: string;
    FMemberName: string;
    FCustomerCode: string;
    FHpNo: string;
    FCarNo: string;
    FLockerNo: Integer;
    FLockerName: string;
    FLockerList: string; // �̿����� ��Ŀ ����
    FSexDiv: Integer;
    FXGolfMemberNo: string;
    FPurchaseCode: string;
    FMemo: string;
    FExpireLocker: string;
    FVIPTeeBoxCount: Integer;
    FMemberCardUID: string;
    FSpecialYN: Boolean; // Ư��ȸ�� ����
    FSpectrumIntfYN: Boolean; // ����Ʈ�� �������̽� ����
    FSpectrumCustId: string; // ����Ʈ�� ȸ����ȣ
    FWelfareCode: string; // ����ī���ȣ
    FWelfarePoint: Integer; // ����ī�� ����Ʈ �ܾ�
    FWelfareRate: Integer; // ����ī�� ������
    FPhotoStream: TMemoryStream; // ���� �̹���
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function GetSexDivDesc: string;

    property MemberNo: string read FMemberNo write FMemberNo;
    property MemberSeq: Integer read FMemberSeq write FMemberSeq default 0;
    property MemberQRCode: string read FMemberQRCode write FMemberQRCode;
    property MemberName: string read FMemberName write FMemberName;
    property CustomerCode: string read FCustomerCode write FCustomerCode;
    property HpNo: string read FHpNo write FHpNo;
    property CarNo: string read FCarNo write FCarNo;
    property LockerNo: Integer read FLockerNo write FLockerNo;
    property LockerName: string read FLockerName write FLockerName;
    property LockerList: string read FLockerList write FLockerList;
    property SexDiv: Integer read FSexDiv write FSexDiv default 3;
    property XGolfMemberNo: string read FXGolfMemberNo write FXGolfMemberNo;
    property PurchaseCode: string read FPurchaseCode write FPurchaseCode;
    property Memo: string read FMemo write FMemo;
    property ExpireLocker: string read FExpireLocker write FExpireLocker;
    property VIPTeeBoxCount: Integer read FVIPTeeBoxCount write FVIPTeeBoxCount default 0;
    property MemberCardUID: string read FMemberCardUID write FMemberCardUID;
    property SpecialYN: Boolean read FSpecialYN write FSpecialYN;
    property SpectrumIntfYN: Boolean read FSpectrumIntfYN write FSpectrumIntfYN default False;
    property SpectrumCustId: string read FSpectrumCustId write FSpectrumCustId;
    property WelfareCode: string read FWelfareCode write FWelfareCode;
    property WelfarePoint: Integer read FWelfarePoint write FWelfarePoint default 0;
    property WelfareRate: Integer read FWelfareRate write FWelfareRate default 0;
    property PhotoStream: TMemoryStream read FPhotoStream write FPhotoStream;
  end;

  { �ü���ǰ �̿�� ���� }
  TFacilityItem = record
    ProdDiv: string;
    ProdName: string;
    AccessBarcode: string;
    AccessControlName: string;
    UseStartDate: string;
    UseEndDate: string;
    RemainCount: Integer;
  end;

  { ��ǰ ī�װ� ���� }
  PSaleCategory = ^TSaleCategory;

  TSaleCategory = record
    CategoryCode: string;
    CategoryName: string;
    SaleItemList: TList;
  end;

  { ��ǰ �� ���� }
  PSaleItem = ^TSaleItem;

  TSaleItem = record
    CategoryCode: string; // Ÿ��(D:����, R:�Ⱓ, C:����, F:����), ��Ŀ(L), �Ϲ�(00002, 00003 ��)
    ProductDiv: string; // S:Ÿ��, L:��Ŀ, G:�Ϲݻ�ǰ
    ChildProdDiv: string;
    // �Ϲݻ�ǰ
    Barcode: string;
    TaxType: Integer;
    // Ÿ�� ��ǰ
    ProductCode: string;
    ProductName: string;
    ZoneCode: string;
    UseDiv: string;
    UseMonth: Integer;
    UseCount: Integer;
    SexDiv: Integer;
    OneUseTime: Integer;
    OneUseCount: Integer;
    ProdStartTime: string;
    ProdEndTime: string;
    ExpireDay: Integer;
    ProductAmt: Integer;
    XGolfProdAmt: Integer;
    XGolfDCAmt: Integer;
    Memo: string;
    // ��Ŀ ��ǰ
    KeepAmt: Integer;
    UseRefund: Boolean;
    // ���޻�
    AffiliateYN: Boolean;
    AffiliateCode: string;
    AffiliateItemCode: string; // ����(�����ڵ�)
  end;

  { ��ǰ �޴� ���� }
  TSaleMenuManager = class
  private
    FCategoryItems: TList; // ī�װ� + ��ǰ ����
    FCategoryPerPage: Integer; // �������� ī�װ� ���� ��
    FCurrentCategoryIndex: Integer; // ���õ� ī�װ� ������ ��ȣ
    FItemPerPage: Integer; // �������� ������ ���� ��
    FCurrentItemIndex: Integer; // ���õ� ��ǰ ������ ��ȣ
    FActiveCategoryPage: Integer; // ���� ī�װ� ������
    FActiveItemPage: Integer; // ���� ��ǰ ������

    procedure SetCategory(const ACategoryIndex: Integer; APointer: PSaleCategory);
    function GetCategory(const ACategoryIndex: Integer): PSaleCategory;
    procedure SetItem(const ACategoryIndex, AItemIndex: Integer; APointer: PSaleItem);
    function GetItem(const ACategoryIndex, AItemIndex: Integer): PSaleItem;
    function GetCategoryPageCount: Integer;
    function GetItemPageCount(const ACategoryIndex: Integer): Integer;
    function IndexOfCategoryCode(const ACategoryCode: string): Integer;
    function IndexOfProductCode(const ACategoryCode, AProductCode: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function GetCategoryCount: Integer;
    function GetItemCount(const ACategoryIndex: Integer): Integer;
    procedure AddCategory(const ACategoryCode, ACategoryName: string);
    procedure AddItem(const ACategoryCode, AProductDiv, AProductCode: string); overload;
    procedure ClearCategories;
    procedure ClearItems(const ACategoryIndex: Integer);
    procedure SetCategoryPage(const ANewCategoryPage: Integer; ACB: TCategoryPageChangeCB);
    procedure SetItemPage(const ACategoryIndex, ANewItemPage: Integer; ACB: TItemPageChangeCB);
    function GetItemOfBarcode(const AProdBarcode: string): PSaleItem;

    property Categories[const ACategoryIndex: Integer]: PSaleCategory read GetCategory write SetCategory;
    property SaleItems[const ACategoryIndex, AItemIndex: Integer]: PSaleItem read GetItem write SetItem;
    property CategoryPerPage: Integer read FCategoryPerPage write FCategoryPerPage default 0;
    property ItemPerPage: Integer read FItemPerPage write FItemPerPage default 0;
    property CurrentCategoryIndex: Integer read FCurrentCategoryIndex write FCurrentCategoryIndex default -1;
    property CurrentItemIndex: Integer read FCurrentItemIndex write FCurrentItemIndex default -1;
    property ActiveCategoryPage: Integer read FActiveCategoryPage write FActiveCategoryPage default -1;
    property ActiveItemPage: Integer read FActiveItemPage write FActiveItemPage default -1;
    property CategoryPageCount: Integer read GetCategoryPageCount;
    property ItemPageCount[const ACategoryIndex: Integer]: Integer read GetItemPageCount;
  end;

  { ���� ���� }
  TStoreInfo = class
  private
    FActive: Boolean; // ��밡�ɿ���
    FFirstSale: Boolean; // �����Ǹſ���(0:�ƴ�, 1:�����Ǹ�)
    FSaleZoneCode: string; // �Ǹ�ó �����ڵ�
    FStoreCode: string; // �����ڵ�
    FStoreName: string; // �����
    FOutdoorDiv: Integer; // ����������(1:�ǿܿ�����, 2:�ǳ�������)
    FPOSNo: string; // POS��ȣ
    FPOSType: Integer; // POS����(0:Ÿ������, 1:ī��, 2:���̺�)
    FPOSName: string; // POS��

    FBizNo: string; // ����ڵ�Ϲ�ȣ
    FCompany: string; // ������
    FCEO: string; // ��ǥ��
    FAddress: string; // ������ּ�
    FTelNo: string; // ��ǥ��ȭ
    FFaxNo: string; // FAX��ȣ

    FStoreStartTime: string; // ����ð�(hh:nn)
    FStoreEndTime: string; // ����ð�(hh:nn)
    FShutdownTimeout: Integer; // �˴ٿ� Ÿ�Ӿƿ�(��)
    FEndTimeIgnoreYN: Boolean; // ���� ����ð� üũ ���� ����
    FCloseStartTime: string; // ���� ���۽ð�
    FCloseEndTime: string; // ���� ����ð�
    FUseRewardYN: Boolean; // �̿�ð� ���󿩺�
    FEndYN: Boolean; // ��������
    FUseAcsYN: Boolean; // ACS ��뿩��
    FFacilityProdYN: Boolean; // �δ�ü���ǰ ��� ����
    FLockerListOrder: ShortInt; //��Ŀ��� ���� ����(1:��/�����ڵ�/��Ŀ��ȣ��, 2:��/��Ŀ��ȣ/�����ڵ��)
    FStampYN: Boolean; // ������ ��� ����

    FVANCode: string; // VAN�� �ڵ�
    FCreditTID: string; // ī��ܸ��� TID
    FPaycoTID: string; // PAYCO TID

    FCashierCode: string; // �ǸŻ���ڵ�
    FCashierName: string; // �ǸŻ����
    FSaleDate: string; // ��������(yyyymmdd)
    FLastSaleDate: string; // ������������(yyyymmdd)
    FStoreUpdated: string; // �������� ���� �����Ͻ�(yyyymmddhhnnss)
    FMemberUpdated: string; // ȸ������ ���� �����Ͻ�(yyyymmddhhnnss)
    FTeeBoxProdUpdated: string; // ��ǰ���� ���� �����Ͻ�(yyyymmddhhnnss)
    FLessonProdUpdated: string; // ������ǰ ���� �����Ͻ�(yyyymmddhhnnss)
    FReserveProdUpdated: string; // �����ǰ ���� �����Ͻ�(yyyymmddhhnnss)
    FFacilityProdUpdated: string; // �δ�ü���ǰ ���� �����Ͻ�(yyyymmddhhnnss)
    FSelectedTeeBoxNo: Integer; // ������ Ÿ����ȣ
    FStoreMemo: string; // �޸�

    FMealCode: string; // �����Ļ�� ��ǰ�ڵ�
    FMealName: string; // �����Ļ�� ��ǰ��
    FMealPrice: Integer; // �����Ļ�� ��ǰ�ܰ�

    FPendingCount: Integer; // �����Ǽ�
    FTableCount: Integer; // ���̺� ��
    FReceiptViewDate: string; // �ŷ����� ��ȸ����(yyyy-mm-dd)
    FSpectrumYN: Boolean; // ����Ʈ�� �����м��� ��뿩��
    FSpectrumHistUrl: string; // ����Ʈ�� ����Ȯ�� �������� URL

    function GetStoreStartDateTime: TDateTime;
    function GetStoreEndDateTime: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; // ��ü �ʱ�ȭ
    function IsNextDay(const ACheckTime: string): Boolean; // hh:nn

    property Active: Boolean read FActive write FActive;
    property FirstSale: Boolean read FFirstSale write FFirstSale;
    property SaleZoneCode: string read FSaleZoneCode write FSaleZoneCode;
    property StoreCode: string read FStoreCode write FStoreCode;
    property StoreName: string read FStoreName write FStoreName;
    property OutdoorDiv: Integer read FOutdoorDiv write FOutdoorDiv default 0;
    property POSNo: string read FPOSNo write FPOSNo;
    property POSType: Integer read FPOSType write FPOSType default 0;
    property POSName: string read FPOSName write FPOSName;

    property BizNo: string read FBizNo write FBizNo;
    property Company: string read FCompany write FCompany;
    property CEO: string read FCEO write FCEO;
    property Address: string read FAddress write FAddress;
    property TelNo: string read FTelNo write FTelNo;
    property FaxNo: string read FFaxNo write FFaxNo;

    property StoreStartTime: string read FStoreStartTime write FStoreStartTime;
    property StoreEndTime: string read FStoreEndTime write FStoreEndTime;
    property ShutdownTimeout: Integer read FShutdownTimeout write FShutdownTimeout default 0;
    property EndTimeIgnoreYN: Boolean read FEndTimeIgnoreYN write FEndTimeIgnoreYN default False;
    property StoreStartDateTime: TDateTime read GetStoreStartDateTime;
    property StoreEndDateTime: TDateTime read GetStoreEndDateTime;
    property CloseStartTime: string read FCloseStartTime write FCloseStartTime;
    property CloseEndTime: string read FCloseEndTime write FCloseEndTime;
    property UseRewardYN: Boolean read FUseRewardYN write FUseRewardYN default False;
    property EndYN: Boolean read FEndYN write FEndYN default False;
    property UseAcsYN: Boolean read FUseAcsYN write FUseAcsYN default False;
    property FacilityProdYN: Boolean read FFacilityProdYN write FFacilityProdYN default False;
    property LockerListOrder: ShortInt read FLockerListOrder write FLockerListOrder default 1;
    property StampYN: Boolean read FStampYN write FStampYN default False;

    property VANCode: string read FVANCode write FVANCode;
    property CreditTID: string read FCreditTID write FCreditTID;
    property PaycoTID: string read FPaycoTID write FPaycoTID;

    property CashierCode: string read FCashierCode write FCashierCode;
    property CashierName: string read FCashierName write FCashierName;
    property SaleDate: string read FSaleDate write FSaleDate;
    property LastSaleDate: string read FLastSaleDate write FLastSaleDate;
    property StoreUpdated: string read FStoreUpdated write FStoreUpdated;
    property MemberUpdated: string read FMemberUpdated write FMemberUpdated;
    property TeeBoxProdUpdated: string read FTeeBoxProdUpdated write FTeeBoxProdUpdated;
    property LessonProdUpdated: string read FLessonProdUpdated write FLessonProdUpdated;
    property ReserveProdUpdated: string read FReserveProdUpdated write FReserveProdUpdated;
    property FacilityProdUpdated: string read FFacilityProdUpdated write FFacilityProdUpdated;
    property StoreMemo: string read FStoreMemo write FStoreMemo;
    property SelectedTeeBoxNo: Integer read FSelectedTeeBoxNo write FSelectedTeeBoxNo default 0;

    property MealCode: string read FMealCode write FMealCode;
    property MealName: string read FMealName write FMealName;
    property MealPrice: Integer read FMealPrice write FMealPrice default 0;

    property PendingCount: Integer read FPendingCount write FPendingCount;
    property TableCount: Integer read FTableCount write FTableCount default 0;
    property ReceiptViewDate: string read FReceiptViewDate write FReceiptViewDate;
    property SpectrumYN: Boolean read FSpectrumYN write FSpectrumYN default False;
    property SpectrumHistUrl: string read FSpectrumHistUrl write FSpectrumHistUrl;
  end;

  { ������ ���� }
  TReceiptInfo = class
  private
    FReceiptNo: string; // �������ڵ�
    FProdChangeSale: Boolean; // ��ȯ��ǰ ����
    FSellTotal: Integer; // �Ǹűݾ�(�ΰ�������) �հ�
    FVatTotal: Integer; // �ΰ��� �հ�
    FDirectDCTotal: Integer; // ���� ���αݾ� �հ�
    FCouponFixedDCTotal: Integer; // ���� ���� ���αݾ� �հ�
    FCouponRateDCTotal: Integer; // ���� ���� ���αݾ� �հ�
    FXGolfDCTotal: Integer; // �������� ȸ�� ���αݾ� �հ�
    FPromoDCTotal: Integer; // ���θ�� ������αݾ� �հ�(ī��纰 ��� ���� ��)
    FCashPayAmt: Integer; // ���� �����ݾ�
    FCashChangePayAmt: Integer; // ���� �Ž����� ���޾�
    FCardPayAmt: Integer; // ī�� �����ݾ�
    FWelfarePayAmt: Integer; // ����ī�� �����ݾ�
    FAffiliateAmt: Integer; // ���޻� ���αݾ�
    FUnPaidAmt: Integer; // �̼��� ó���ݾ�
    FPaycoReady: Boolean; // PAYCO ���� ��� ����
    FKeepAmt: Integer; // ��Ŀ ������
    FFacilityCount: ShortInt; // �ü���ǰ�Ǽ�
    FFacilityError: Boolean; // �ü��̿�� ���Թ��ڵ� ���� ���� ����
    FFacilityErrorMessage: string; // �ü��̿�� ���Թ��ڵ� ���� ���� �޽���
    FParkingError: Boolean; // ������ ���� ���� ����
    FParkingErrorMessage: string; // ������ ���� ���� �޽���
    FSignImage: TMemoryStream; // ���� �̹���
    FReciptSaleDate: string; // �Ǹ�����
    FSaleMemo: string; // ������ �޸�
    FPendReceiptNo: string; // ������������ȣ

    function GetVatTotal: Integer; // �ΰ���
    function GetReceiveTotal: Integer; // �����ݾ� = (���ݰ����ݾ� + ī������ݾ�)
    function GetUnPaidTotal: Integer; // �̰����ݾ� = (û���ݾ� - (���ݰ����ݾ� + ī������ݾ� + ���ȯ�ޱݾ�))
    function GetChargeTotal: Integer; // û���ݾ�
    function GetChangeTotal: Integer;
    function GetDiscountTotal: Integer; // �����ؾ��� �Ž����� = ((�����ݾ� + ���ȯ�ޱݾ�) - û���ݾ�)
  public
    FacilityList: TArray<TFacilityItem>; //�δ�ü� ��ǰ �̿�� ���� ����

    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    property ReceiptNo: string read FReceiptNo write FReceiptNo;
//    property TableNo: Integer read FTableNo write FTableNo;
    property ProdChangeSale: Boolean read FProdChangeSale write FProdChangeSale default False;

    property SellTotal: Integer read FSellTotal write FSellTotal;
    property VatTotal: Integer read GetVatTotal write FVatTotal;
    property ReceiveTotal: Integer read GetReceiveTotal;
    property UnPaidTotal: Integer read GetUnPaidTotal;
    property DirectDCTotal: Integer read FDirectDCTotal write FDirectDCTotal;
    property CouponFixedDCTotal: Integer read FCouponFixedDCTotal write FCouponFixedDCTotal;
    property CouponRateDCTotal: Integer read FCouponRateDCTotal write FCouponRateDCTotal;
    property XGolfDCTotal: Integer read FXGolfDCTotal write FXGolfDCTotal;
    property PromoDCTotal: Integer read FPromoDCTotal write FPromoDCTotal;
    property DiscountTotal: Integer read GetDiscountTotal;
    property ChargeTotal: Integer read GetChargeTotal;
    property ChangeTotal: Integer read GetChangeTotal;

    property CashPayAmt: Integer read FCashPayAmt write FCashPayAmt default 0;
    property CashChangePayAmt: Integer read FCashChangePayAmt write FCashChangePayAmt default 0;
    property CardPayAmt: Integer read FCardPayAmt write FCardPayAmt default 0;
    property PaycoReady: Boolean read FPaycoReady write FPaycoReady default False;
    property WelfarePayAmt: Integer read FWelfarePayAmt write FWelfarePayAmt default 0;
    property AffiliateAmt: Integer read FAffiliateAmt write FAffiliateAmt default 0;
    property UnPaidAmt: Integer read FUnPaidAmt write FUnPaidAmt default 0;
    property KeepAmt: Integer read FKeepAmt write FKeepAmt default 0;
    property FacilityCount: ShortInt read FFacilityCount write FFacilityCount default 0;
    property FacilityError: Boolean read FFacilityError write FFacilityError default False;
    property FacilityErrorMessage: string read FFacilityErrorMessage write FFacilityErrorMessage;
    property ParkingError: Boolean read FParkingError write FParkingError default False;
    property ParkingErrorMessage: string read FParkingErrorMessage write FParkingErrorMessage;

    property SignImage: TMemoryStream read FSignImage write FSignImage;

    property ReciptSaleDate: string read FReciptSaleDate write FReciptSaleDate;
    property SaleMemo: string read FSaleMemo write FSaleMemo;
    property PendReceiptNo: string read FPendReceiptNo write FPendReceiptNo;
  end;

  TSaleManager = class
  private
    FUserInfo: TUserInfo; // ����� ����
    FStoreInfo: TStoreInfo; // ���� ����
    FMemberInfo: TMemberInfo; // �Ǹ��� ����
    FReceiptInfo: TReceiptInfo; // ������ ����
    FSaleMenuManager: TSaleMenuManager;
  public
    constructor Create;
    destructor Destroy; override;

    function GetNewReceiptNo: string;
    procedure PayLog(const AIsApproval, AManualApprove: Boolean; const APayMethod, ACreditCardNo, AApprovalNo: string; const APayAmt: Integer; const AReceiptNo: string = '');

    property UserInfo: TUserInfo read FUserInfo write FUserInfo;
    property StoreInfo: TStoreInfo read FStoreInfo write FStoreInfo;
    property MemberInfo: TMemberInfo read FMemberInfo write FMemberInfo;
    property ReceiptInfo: TReceiptInfo read FReceiptInfo write FReceiptInfo;
    property SaleMenuManager: TSaleMenuManager read FSaleMenuManager write FSaleMenuManager;
  end;

var
  SaleManager: TSaleManager;

implementation

uses
  {Native}
  Data.DB, System.Math, System.Variants, System.SysUtils,
  {Project}
  uXGGlobal, uXGClientDM, uXGCommonLib;

{ TUserInfo }

constructor TUserInfo.Create;
begin
  Clear;
end;

destructor TUserInfo.Destroy;
begin
  inherited;
end;

procedure TUserInfo.Clear;
begin
  FUserId := '';
  FTerminalPwd := '';
  FUserName := '';
  FHpNo := '';
  FSaveInfo := False;
end;

{ TMemberInfo }

constructor TMemberInfo.Create;
begin
  FPhotoStream := TMemoryStream.Create;
  Clear;
end;

destructor TMemberInfo.Destroy;
begin
  FPhotoStream.Free;

  inherited;
end;

procedure TMemberInfo.Clear;
begin
  FMemberNo := '';
  FMemberSeq := 0;
  FMemberQRCode := '';
  FMemberName := '';
  FCustomerCode := '';
  FHpNo := '';
  FCarNo := '';
  FLockerNo := 0;
  FLockerName := '';
  FLockerList := '';
  FSexDiv := 0; // 1:��, 2:��, 0:����
  FXGolfMemberNo := '';
  FPurchaseCode := '';
  FMemo := '';
  FExpireLocker := '';
  FVIPTeeBoxCount := 0;
  FMemberCardUID := '';
  FSpecialYN := False;
  FSpectrumIntfYN := False;
  FSpectrumCustId := '';
  FWelfareCode := '';
  FWelfarePoint := 0;
  FWelfareRate := 0;
  FPhotoStream.Clear;
end;

function TMemberInfo.GetSexDivDesc: string;
begin
  case FSexDiv of
    CSD_SEX_MALE:
      Result := '��';
    CSD_SEX_FEMALE:
      Result := '��';
    CSD_SEX_ALL:
      Result := '����';
  else
    Result := '';
  end;
end;

{ TStoreInfo }

constructor TStoreInfo.Create;
begin
  inherited;

  FActive := False;
  Clear;
end;

destructor TStoreInfo.Destroy;
begin

  inherited;
end;

function TStoreInfo.GetStoreStartDateTime: TDateTime;
var
  sCurrTime: string;
begin
  sCurrTime := FormatDateTime('hh:nn', Now);
  if (StoreStartTime < StoreEndTime) then
    Result := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, StoreStartTime]), Global.FS)
  else
  begin
    if (sCurrTime >= '00:00') and
      (sCurrTime < StoreStartTime) then
      Result := StrToDateTime(Format('%s %s:00', [Global.FormattedLastDate, StoreStartTime]), Global.FS)
    else
      Result := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, StoreStartTime]), Global.FS);
  end;
end;

function TStoreInfo.GetStoreEndDateTime: TDateTime;
var
  sCurrTime: string;
begin
  sCurrTime := FormatDateTime('hh:nn', Now);
  if (StoreStartTime < StoreEndTime) then
    Result := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, StoreEndTime]), Global.FS)
  else
  begin
    if (sCurrTime >= '00:00') and
      (sCurrTime < StoreStartTime) then
      Result := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, StoreEndTime]), Global.FS)
    else
      Result := StrToDateTime(Format('%s %s:00', [Global.FormattedNextDate, StoreEndTime]), Global.FS);
  end;
end;

function TStoreInfo.IsNextDay(const ACheckTime: string): Boolean; // nn:ss
begin
  Result := (StoreStartTime > StoreEndTime) and
    (ACheckTime >= '00:00') and
    (ACheckTime < StoreStartTime);
end;

procedure TStoreInfo.Clear;
begin
  FSaleZoneCode := '';
  FStoreCode := '';
  FStoreName := '';
  FCashierCode := '';
  FCashierName := '';
  FPOSNo := '';
  FPOSType := CPO_SALE_TEEBOX;
  FPOSName := '';

  FBizNo := '';
  FCompany := '';
  FCEO := '';
  FAddress := '';
  FTelNo := '';
  FFaxNo := '';
  FShutdownTimeout := 0;

  FVANCode := VanModule.VANCode;
  FCreditTID := '';
  FPaycoTID := '';
  FStoreMemo := '';
  FMealCode := '';
  FMealName := '';
  FMealPrice := 0;
  FPendingCount := 0;

  FStoreUpdated := '';
  FMemberUpdated := '';
  FTeeBoxProdUpdated := '';
  FLessonProdUpdated := '';
  FReserveProdUpdated := '';
  FFacilityProdUpdated := '';

  FacilityProdYN := False;
  FLockerListOrder := 1;
  FSpectrumYN := False;
  FSpectrumHistUrl := '';
end;

constructor TSaleMenuManager.Create;
begin
  FCategoryItems := TList.Create;
end;

destructor TSaleMenuManager.Destroy;
begin
  ClearCategories;

  inherited;
end;

function TSaleMenuManager.GetCategory(const ACategoryIndex: Integer): PSaleCategory;
begin
  Result := FCategoryItems.Items[ACategoryIndex];
end;

function TSaleMenuManager.GetItem(const ACategoryIndex, AItemIndex: Integer): PSaleItem;
begin
  Result := PSaleCategory(FCategoryItems.Items[ACategoryIndex]).SaleItemList.Items[AItemIndex];
end;

function TSaleMenuManager.GetCategoryPageCount: Integer;
begin
  Result := Ceil(FCategoryItems.Count / FCategoryPerPage);
end;

function TSaleMenuManager.GetItemPageCount(const ACategoryIndex: Integer): Integer;
begin
  Result := Ceil(PSaleCategory(FCategoryItems.Items[ACategoryIndex]).SaleItemList.Count / FItemPerPage);
end;

procedure TSaleMenuManager.SetCategory(const ACategoryIndex: Integer; APointer: PSaleCategory);
var
  P: PSaleCategory;
begin
  P := GetCategory(ACategoryIndex);
  if (P <> APointer) then
  begin
    if (P <> nil) then
      Dispose(P);

    FCategoryItems.Items[ACategoryIndex] := APointer;
  end;
end;

procedure TSaleMenuManager.SetItem(const ACategoryIndex, AItemIndex: Integer; APointer: PSaleItem);
var
  P: PSaleItem;
begin
  P := GetItem(ACategoryIndex, AItemIndex);
  if (P <> APointer) then
  begin
    if (P <> nil) then
      Dispose(P);

    PSaleCategory(FCategoryItems.Items[ACategoryIndex]).SaleItemList.Items[AItemIndex] := APointer;
  end;
end;

procedure TSaleMenuManager.AddCategory(const ACategoryCode, ACategoryName: string);
var
  P: PSaleCategory;
begin
  New(P);
  with P^ do
    try
      if (IndexOfCategoryCode(ACategoryCode) < 0) then
      begin
        CategoryCode := ACategoryCode;
        CategoryName := ACategoryName;
        SaleItemList := TList.Create;
        FCategoryItems.Add(P);
      end
      else
        Dispose(P);
    except
      Dispose(P);
    end;
end;

procedure TSaleMenuManager.AddItem(const ACategoryCode, AProductDiv, AProductCode: string);
var
  DataSet: TDataSet;
  sBarcode: string;
  nTaxType: Integer;
  sProductCode: string;
  sProductName: string;
  sZoneCode: string;
  sChildProdDiv: string;
  sUseDiv: string;
  nUseMonth: Integer;
  nUseCount: Integer;
  nSexDiv: Integer;
  nOneUseTime: Integer;
  nOneUseCount: Integer;
  sProdStartTime: string;
  sProdEndTime: string;
  nExpireDay: Integer;
  nProductAmt: Integer;
  nXGolfProdAmt: Integer;
  nXGolfDCAmt: Integer;
  sMemo: string;
  nKeepAmt: Integer;
  bUseRefund: Boolean;
  bAffiliateYN: Boolean;
  sAffiliateCode: string;
  sAffiliateItemCode: string;
  nIndex: Integer;
  P: PSaleItem;
begin
  if (AProductDiv = CPD_TEEBOX) or
    (AProductDiv = CPD_LESSON) or
    (AProductDiv = CPD_RESERVE) then
    DataSet := ClientDM.MDProdTeeBox
  else if (AProductDiv = CPD_LOCKER) then
    DataSet := ClientDM.MDProdLocker
  else if (AProductDiv = CPD_FACILITY) then
    DataSet := ClientDM.MDProdFacility
  else
    DataSet := ClientDM.MDProdGeneral;

  with DataSet do
  begin
    if (AProductDiv = CPD_TEEBOX) or
      (AProductDiv = CPD_LESSON) or
      (AProductDiv = CPD_RESERVE) then
    begin
      if not Locate('product_div;product_cd', VarArrayOf([ACategoryCode, AProductCode]), []) then
        Exit;
    end
    else
    begin
      if not Locate('product_cd', AProductCode, []) then
        Exit;
    end;

    bAffiliateYN := False;
    sAffiliateCode := '';
    sAffiliateItemCode := '';

    if (AProductDiv = CPD_TEEBOX) or
      (AProductDiv = CPD_LESSON) or
      (AProductDiv = CPD_RESERVE) then
    begin
      sProductName := FieldByName('product_nm').AsString;
      sZoneCode := FieldByName('zone_cd').AsString;
      sChildProdDiv := FieldByName('product_div').AsString; // teebox_prod_div(����,�Ⱓ,���� ��)
      sUseDiv := FieldByName('use_div').AsString;
      nUseMonth := FieldByName('use_month').AsInteger;
      nUseCount := FieldByName('use_cnt').AsInteger;
      nSexDiv := FieldByName('sex_div').AsInteger;
      nOneUseTime := FieldByName('one_use_time').AsInteger;
      nOneUseCount := FieldByName('one_use_cnt').AsInteger;
      sProdStartTime := FieldByName('start_time').AsString;
      sProdEndTime := FieldByName('end_time').AsString;
      nExpireDay := FieldByName('expire_day').AsInteger;
      nProductAmt := FieldByName('product_amt').AsInteger;
      nXGolfDCAmt := FieldByName('xgolf_dc_amt').AsInteger;
      nXGolfProdAmt := (nProductAmt - nXGolfDCAmt);
      sMemo := FieldByName('memo').AsString;
      nKeepAmt := 0;
      sBarcode := '';
      nTaxType := 1;
      bUseRefund := FieldByName('refund_yn').AsBoolean;
      bAffiliateYN := FieldByName('affiliate_yn').AsBoolean;
      sAffiliateCode := FieldByName('affiliate_cd').AsString;
      sAffiliateItemCode := FieldByName('affiliate_item_cd').AsString;
    end
    else if (AProductDiv = CPD_LOCKER) or
      (AProductDiv = CPD_KEEP_AMT) then
    begin
      sProductName := FieldByName('product_nm').AsString;
      sZoneCode := FieldByName('zone_cd').AsString;
      sChildProdDiv := '';
      sUseDiv := '';
      nUseMonth := FieldByName('use_month').AsInteger;
      nUseCount := 0;
      nSexDiv := IIF(AProductDiv = CPD_LOCKER, FieldByName('sex_div').AsInteger, CSD_SEX_ALL);
      nOneUseTime := 0;
      nOneUseCount := 0;
      sProdStartTime := '';
      sProdEndTime := '';
      nExpireDay := 0;
      nProductAmt := FieldByName('product_amt').AsInteger;
      nXGolfDCAmt := 0;
      nXGolfProdAmt := nProductAmt;
      sMemo := FieldByName('memo').AsString;
      nKeepAmt := FieldByName('keep_amt').AsInteger;
      sBarcode := '';
      nTaxType := 1;
      bUseRefund := FieldByName('refund_yn').AsBoolean;
    end
    else if (AProductDiv = CPD_FACILITY) then
    begin
      sProductName := FieldByName('product_nm').AsString;
      sZoneCode := '';
      sChildProdDiv := FieldByName('facility_div').AsString;
      sUseDiv := '';
      nUseMonth := FieldByName('use_month').AsInteger;
      nUseCount := FieldByName('use_cnt').AsInteger;
      nSexDiv := CSD_SEX_ALL;
      nOneUseTime := 0;
      nOneUseCount := 0;
      sProdStartTime := '';
      sProdEndTime := '';
      nExpireDay := 0;
      nProductAmt := FieldByName('product_amt').AsInteger;
      nXGolfDCAmt := 0;
      nXGolfProdAmt := nProductAmt;
      sMemo := FieldByName('memo').AsString;
      nKeepAmt := 0;
      sBarcode := '';
      nTaxType := 1;
      bUseRefund := False;
    end
    else
    begin
      sProductCode := FieldByName('product_cd').AsString;
      sProductName := FieldByName('product_nm').AsString;
      sZoneCode := '';
      sChildProdDiv := '';
      sUseDiv := '';
      nUseMonth := 0;
      nUseCount := 0;
      nSexDiv := CSD_SEX_ALL;
      nOneUseTime := 0;
      nOneUseCount := 0;
      sProdStartTime := '';
      sProdEndTime := '';
      nExpireDay := 0;
      nProductAmt := FieldByName('product_amt').AsInteger;
      nXGolfDCAmt := 0;
      nXGolfProdAmt := nProductAmt;
      sMemo := FieldByName('memo').AsString;
      nKeepAmt := 0;
      sBarcode := FieldByName('barcode').AsString;
      nTaxType := FieldByName('tax_type').AsInteger;
      bUseRefund := FieldByName('refund_yn').AsBoolean;
    end;
  end;

  nIndex := IndexOfCategoryCode(ACategoryCode);
  if (nIndex >= 0) and
    (IndexOfProductCode(ACategoryCode, AProductCode) < 0) then
  begin
    New(P);
    with P^ do
      try
        CategoryCode := ACategoryCode;
        ProductDiv := AProductDiv;
        ProductCode := AProductCode;
        ProductName := sProductName;
        ZoneCode := sZoneCode;
        ChildProdDiv := sChildProdDiv;
        UseDiv := sUseDiv;
        UseMonth := nUseMonth;
        UseCount := nUseCount;
        SexDiv := nSexDiv;
        OneUseTime := nOneUseTime;
        OneUseCount := nOneUseCount;
        ProdStartTime := sProdStartTime;
        ProdEndTime := sProdEndTime;
        ExpireDay := nExpireDay;
        ProductAmt := nProductAmt;
        XGolfDCAmt := nXGolfDCAmt;
        XGolfProdAmt := nXGolfProdAmt;
        Memo := sMemo;
        KeepAmt := nKeepAmt;
        Barcode := sBarcode;
        TaxType := nTaxType;
        UseRefund := bUseRefund;
        AffiliateYN := bAffiliateYN;

        GetCategory(nIndex).SaleItemList.Add(P);
      except
        Dispose(P);
      end;
  end;
end;

procedure TSaleMenuManager.ClearCategories;
var
  PC: PSaleCategory;
  PI: PSaleItem;
  nCategory, nItem: Integer;
begin
  for nCategory := 0 to Pred(FCategoryItems.Count) do
  begin
    PC := GetCategory(nCategory);
    if (PC <> nil) then
    begin
      for nItem := 0 to Pred(PC.SaleItemList.Count) do
      begin
        PI := GetItem(nCategory, nItem);
        if (PI <> nil) then
          Dispose(PI);
      end;

      PC.SaleItemList.Clear;
      Dispose(PC);
    end;
  end;
  FCategoryItems.Clear;
end;

procedure TSaleMenuManager.ClearItems(const ACategoryIndex: Integer);
var
  P: PSaleItem;
  nItem: Integer;
begin
  for nItem := 0 to Pred(GetCategory(ACategoryIndex).SaleItemList.Count) do
  begin
    P := GetItem(ACategoryIndex, nItem);
    if (P <> nil) then
      Dispose(P);
  end;
  GetCategory(ACategoryIndex).SaleItemList.Clear;
end;

function TSaleMenuManager.IndexOfCategoryCode(const ACategoryCode: string): Integer;
var
  nIndex: Integer;
begin
  Result := -1;
  for nIndex := 0 to Pred(FCategoryItems.Count) do
    if (GetCategory(nIndex).CategoryCode = ACategoryCode) then
    begin
      Result := nIndex;
      Break;
    end;
end;

function TSaleMenuManager.IndexOfProductCode(const ACategoryCode, AProductCode: string): Integer;
var
  nCategory, nItem: Integer;
begin
  Result := -1;
  for nCategory := 0 to Pred(FCategoryItems.Count) do
    if (GetCategory(nCategory).CategoryCode = ACategoryCode) then
      for nItem := 0 to Pred(GetCategory(nCategory).SaleItemList.Count) do
        if (CompareText(GetItem(nCategory, nItem).ProductCode, AProductCode) = 0) then
        begin
          Result := nItem;
          Break;
        end;
end;

function TSaleMenuManager.GetCategoryCount: Integer;
begin
  Result := FCategoryItems.Count;
end;

function TSaleMenuManager.GetItemCount(const ACategoryIndex: Integer): Integer;
begin
  Result := GetCategory(ACategoryIndex).SaleItemList.Count;
end;

procedure TSaleMenuManager.SetCategoryPage(const ANewCategoryPage: Integer; ACB: TCategoryPageChangeCB);
begin
  FActiveCategoryPage := ANewCategoryPage;

  if Assigned(ACB) then
    ACB(FActiveCategoryPage);
end;

procedure TSaleMenuManager.SetItemPage(const ACategoryIndex, ANewItemPage: Integer; ACB: TItemPageChangeCB);
begin
  FActiveItemPage := ANewItemPage;

  if Assigned(ACB) then
    ACB(ACategoryIndex, FActiveItemPage);
end;

{ TSaleManager }

constructor TSaleManager.Create;
begin
  inherited;

  FUserInfo := TUserInfo.Create;
  FStoreInfo := TStoreInfo.Create;
  FMemberInfo := TMemberInfo.Create;
  FReceiptInfo := TReceiptInfo.Create;
  FSaleMenuManager := TSaleMenuManager.Create;
  FStoreInfo.POSType := Global.Config.ReadInteger('StoreInfo', 'POSType', CPO_SALE_TEEBOX);
  with Global.ConfigLocal do
  begin
    FUserInfo.SaveInfo := ReadBool('UserInfo', 'SaveInfo', False);
    FUserInfo.UserId := ReadString('UserInfo', 'UserId', '');
    FStoreInfo.MealCode := ReadString('MealInfo', 'MealCode', '');
    FStoreInfo.MealName := ReadString('MealInfo', 'MealName', '');
    FStoreInfo.MealPrice := ReadInteger('MealInfo', 'MealPrice', 0);
  end;
end;

destructor TSaleManager.Destroy;
begin
  FUserInfo.Free;
  FStoreInfo.Free;
  FReceiptInfo.Free;
  FSaleMenuManager.Free;

  inherited Destroy;
end;

function TSaleManager.GetNewReceiptNo: string;
begin
  Result := SaleManager.StoreInfo.StoreCode +
    LeftPad(Copy(Global.ClientConfig.ClientId, 8, 3), '0', 3) +
    Copy(Global.CurrentDate, 3, 6) +
    Global.CurrentTime; // hhmiss
end;

procedure TSaleManager.PayLog(const AIsApproval, AManualApprove: Boolean; const APayMethod, ACreditCardNo, AApprovalNo: string; const APayAmt: Integer; const AReceiptNo: string = '');
var
  sPayMethod: string;
begin
  sPayMethod := APayMethod;
  if (APayMethod = CPM_CASH) and (not AApprovalNo.IsEmpty) then
    sPayMethod := APayMethod + ' (���ݿ�����)';
  if AManualApprove then
    sPayMethod := APayMethod + ' (���ǵ��)';

  UpdateLog(Global.PayLogFile, '----------------------------------------');
  UpdateLog(Global.PayLogFile, Format('[%s ��ȣ] %s', [IIF(AIsApproval, '������', '���ŷ�'),
    IIF(AReceiptNo.IsEmpty, SaleManager.ReceiptInfo.ReceiptNo, AReceiptNo)]));
  UpdateLog(Global.PayLogFile, Format('[�� �� �� ��] %s', [IIF(AIsApproval, '����', '���')]));
  UpdateLog(Global.PayLogFile, Format('[�� �� �� ��] %s', [sPayMethod]));
  UpdateLog(Global.PayLogFile, Format('[ī �� �� ȣ] %s', [ACreditCardNo]));
  UpdateLog(Global.PayLogFile, Format('[�� �� �� ȣ] %s', [AApprovalNo]));
  UpdateLog(Global.PayLogFile, Format('[�� �� �� ��] %d', [APayAmt]));
end;

function TSaleMenuManager.GetItemOfBarcode(const AProdBarcode: string): PSaleItem;
var
  nCategory, nItem: Integer;
begin
  Result := nil;
  for nCategory := 0 to Pred(FCategoryItems.Count) do
  begin
    for nItem := 0 to Pred(GetCategory(nCategory).SaleItemList.Count) do
      if (CompareText(GetItem(nCategory, nItem).Barcode, AProdBarcode) = 0) then
      begin
        Result := PSaleCategory(FCategoryItems.Items[nCategory]).SaleItemList.Items[nItem];
        Break;
      end;
  end;
end;

{ TReceiptInfo }

constructor TReceiptInfo.Create;
begin
  FSignImage := TMemoryStream.Create;
  Clear;
end;

destructor TReceiptInfo.Destroy;
begin
  FSignImage.Free;

  inherited;
end;

procedure TReceiptInfo.Clear;
begin
  ReceiptNo := '';
  // TableNo := 0;
  ProdChangeSale := False;

  SellTotal := 0;
  VatTotal := 0;
  DirectDCTotal := 0;
  CouponFixedDCTotal := 0;
  CouponRateDCTotal := 0;
  XGolfDCTotal := 0;
  PromoDCTotal := 0;

  CashPayAmt := 0;
  CashChangePayAmt := 0;
  CardPayAmt := 0;
  WelfarePayAmt := 0;
  UnPaidAmt := 0;
  KeepAmt := 0;
  AffiliateAmt := 0;
  FacilityCount := 0;
  FacilityError := False;
  FacilityErrorMessage := '';
  ParkingError := False;
  ParkingErrorMessage := '';
  ReciptSaleDate := '';
  SaleMemo := '';
  PendReceiptNo := '';

  SetLength(FacilityList, 0);
end;

// �����ݾ� = (���ݰ����ݾ� + ī������ݾ�)
function TReceiptInfo.GetReceiveTotal: Integer;
begin
  Result := (CashPayAmt + CardPayAmt + WelfarePayAmt);
end;

// �̰����ݾ� = (û���ݾ� - (���ݰ����ݾ� + ī������ݾ�))
function TReceiptInfo.GetUnPaidTotal: Integer;
begin
  Result := (SellTotal - (DiscountTotal + ReceiveTotal));
  if (Result < 0) then
    Result := 0;
end;

// �ΰ���
function TReceiptInfo.GetVatTotal: Integer;
begin
  // Result := Ceil(ChargeTotal / 10);
  Result := (ChargeTotal - Trunc(ChargeTotal / 1.1));
  if (Result < 0) then
    Result := 0;
end;

// ������ �Ž����� = ((���ݰ����ݾ� + ī������ݾ�) - û���ݾ�)
function TReceiptInfo.GetChangeTotal: Integer;
begin
  Result := ((CashPayAmt + CardPayAmt + WelfarePayAmt) - ChargeTotal);
  if (Result < 0) then
    Result := 0;
end;

// û���ݾ�
function TReceiptInfo.GetChargeTotal: Integer;
begin
  Result := (SellTotal - DiscountTotal);
end;

// ���αݾ� �հ�
function TReceiptInfo.GetDiscountTotal: Integer;
begin
  Result := (DirectDCTotal + CouponFixedDCTotal + CouponRateDCTotal + XGolfDCTotal + PromoDCTotal + AffiliateAmt);
end;

end.
