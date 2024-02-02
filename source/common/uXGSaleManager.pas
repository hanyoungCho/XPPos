unit uXGSaleManager;

interface

uses
  System.Classes;

{$I XGPOS.inc}


type
  { POS메뉴 Callback 함수 }
  TCategoryPageChangeCB = reference to procedure(const ACategoryPage: Integer);
  TItemPageChangeCB = reference to procedure(const ACategoryIndex, AItemPage: Integer);
  TFunctionPageChangeCB = reference to procedure(const ANewPageIndex: Integer);

  { 사용자 정보 }
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

  { 회원 정보 }
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
    FLockerList: string; // 이용중인 라커 내역
    FSexDiv: Integer;
    FXGolfMemberNo: string;
    FPurchaseCode: string;
    FMemo: string;
    FExpireLocker: string;
    FVIPTeeBoxCount: Integer;
    FMemberCardUID: string;
    FSpecialYN: Boolean; // 특별회원 여부
    FSpectrumIntfYN: Boolean; // 스펙트럼 인터페이스 여부
    FSpectrumCustId: string; // 스펙트럼 회원번호
    FWelfareCode: string; // 복지카드번호
    FWelfarePoint: Integer; // 복지카드 포인트 잔액
    FWelfareRate: Integer; // 복지카드 할인율
    FPhotoStream: TMemoryStream; // 사진 이미지
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

  { 시설상품 이용권 정보 }
  TFacilityItem = record
    ProdDiv: string;
    ProdName: string;
    AccessBarcode: string;
    AccessControlName: string;
    UseStartDate: string;
    UseEndDate: string;
    RemainCount: Integer;
  end;

  { 상품 카테고리 정보 }
  PSaleCategory = ^TSaleCategory;

  TSaleCategory = record
    CategoryCode: string;
    CategoryName: string;
    SaleItemList: TList;
  end;

  { 상품 상세 정보 }
  PSaleItem = ^TSaleItem;

  TSaleItem = record
    CategoryCode: string; // 타석(D:일일, R:기간, C:쿠폰, F:무료), 라커(L), 일반(00002, 00003 등)
    ProductDiv: string; // S:타석, L:라커, G:일반상품
    ChildProdDiv: string;
    // 일반상품
    Barcode: string;
    TaxType: Integer;
    // 타석 상품
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
    // 라커 상품
    KeepAmt: Integer;
    UseRefund: Boolean;
    // 제휴사
    AffiliateYN: Boolean;
    AffiliateCode: string;
    AffiliateItemCode: string; // 웰빙(종목코드)
  end;

  { 상품 메뉴 정보 }
  TSaleMenuManager = class
  private
    FCategoryItems: TList; // 카테고리 + 상품 정보
    FCategoryPerPage: Integer; // 페이지당 카테고리 노출 수
    FCurrentCategoryIndex: Integer; // 선택된 카테고리 아이템 번호
    FItemPerPage: Integer; // 페이지당 아이템 노출 수
    FCurrentItemIndex: Integer; // 선택된 상품 아이템 번호
    FActiveCategoryPage: Integer; // 현재 카테고리 페이지
    FActiveItemPage: Integer; // 현재 상품 페이지

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

  { 매장 정보 }
  TStoreInfo = class
  private
    FActive: Boolean; // 사용가능여부
    FFirstSale: Boolean; // 최초판매여부(0:아님, 1:최초판매)
    FSaleZoneCode: string; // 판매처 구분코드
    FStoreCode: string; // 매장코드
    FStoreName: string; // 매장명
    FOutdoorDiv: Integer; // 게임장형태(1:실외연습장, 2:실내연습장)
    FPOSNo: string; // POS번호
    FPOSType: Integer; // POS유형(0:타석예약, 1:카페, 2:테이블)
    FPOSName: string; // POS명

    FBizNo: string; // 사업자등록번호
    FCompany: string; // 사업장명
    FCEO: string; // 대표자
    FAddress: string; // 사업장주소
    FTelNo: string; // 대표전화
    FFaxNo: string; // FAX번호

    FStoreStartTime: string; // 개장시각(hh:nn)
    FStoreEndTime: string; // 폐장시각(hh:nn)
    FShutdownTimeout: Integer; // 셧다운 타임아웃(분)
    FEndTimeIgnoreYN: Boolean; // 영업 종료시각 체크 무시 여부
    FCloseStartTime: string; // 휴장 시작시각
    FCloseEndTime: string; // 휴장 종료시각
    FUseRewardYN: Boolean; // 이용시간 보상여부
    FEndYN: Boolean; // 해지여부
    FUseAcsYN: Boolean; // ACS 사용여부
    FFacilityProdYN: Boolean; // 부대시설상품 사용 여부
    FLockerListOrder: ShortInt; //라커목록 정렬 순서(1:층/구역코드/라커번호순, 2:층/라커번호/구역코드순)
    FStampYN: Boolean; // 스템프 사용 여부

    FVANCode: string; // VAN사 코드
    FCreditTID: string; // 카드단말기 TID
    FPaycoTID: string; // PAYCO TID

    FCashierCode: string; // 판매사원코드
    FCashierName: string; // 판매사원명
    FSaleDate: string; // 개점일자(yyyymmdd)
    FLastSaleDate: string; // 최종영업일자(yyyymmdd)
    FStoreUpdated: string; // 매장정보 최종 갱신일시(yyyymmddhhnnss)
    FMemberUpdated: string; // 회원정보 최종 갱신일시(yyyymmddhhnnss)
    FTeeBoxProdUpdated: string; // 상품정보 최종 갱신일시(yyyymmddhhnnss)
    FLessonProdUpdated: string; // 레슨상품 최종 갱신일시(yyyymmddhhnnss)
    FReserveProdUpdated: string; // 예약상품 최종 갱신일시(yyyymmddhhnnss)
    FFacilityProdUpdated: string; // 부대시설상품 최종 갱신일시(yyyymmddhhnnss)
    FSelectedTeeBoxNo: Integer; // 선택한 타석번호
    FStoreMemo: string; // 메모

    FMealCode: string; // 직원식사용 상품코드
    FMealName: string; // 직원식사용 상품명
    FMealPrice: Integer; // 직원식사용 상품단가

    FPendingCount: Integer; // 보류건수
    FTableCount: Integer; // 테이블 수
    FReceiptViewDate: string; // 거래내역 조회일자(yyyy-mm-dd)
    FSpectrumYN: Boolean; // 스펙트럼 스윙분석기 사용여부
    FSpectrumHistUrl: string; // 스펙트럼 연동확인 웹페이지 URL

    function GetStoreStartDateTime: TDateTime;
    function GetStoreEndDateTime: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; // 전체 초기화
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

  { 영수증 정보 }
  TReceiptInfo = class
  private
    FReceiptNo: string; // 영수증코드
    FProdChangeSale: Boolean; // 전환상품 여부
    FSellTotal: Integer; // 판매금액(부가세포함) 합계
    FVatTotal: Integer; // 부가세 합계
    FDirectDCTotal: Integer; // 직접 할인금액 합계
    FCouponFixedDCTotal: Integer; // 쿠폰 정액 할인금액 합계
    FCouponRateDCTotal: Integer; // 쿠폰 정율 할인금액 합계
    FXGolfDCTotal: Integer; // 엑스골프 회원 할인금액 합계
    FPromoDCTotal: Integer; // 프로모션 즉시할인금액 합계(카드사별 즉시 할인 등)
    FCashPayAmt: Integer; // 현금 결제금액
    FCashChangePayAmt: Integer; // 현금 거스름돈 지급액
    FCardPayAmt: Integer; // 카드 결제금액
    FWelfarePayAmt: Integer; // 복지카드 결제금액
    FAffiliateAmt: Integer; // 제휴사 승인금액
    FUnPaidAmt: Integer; // 미수금 처리금액
    FPaycoReady: Boolean; // PAYCO 결제 대기 상태
    FKeepAmt: Integer; // 라커 보증금
    FFacilityCount: ShortInt; // 시설상품건수
    FFacilityError: Boolean; // 시설이용권 출입바코드 발행 실패 여부
    FFacilityErrorMessage: string; // 시설이용권 출입바코드 발행 실패 메시지
    FParkingError: Boolean; // 주차권 발행 실패 여부
    FParkingErrorMessage: string; // 주차권 발행 실패 메시지
    FSignImage: TMemoryStream; // 서명 이미지
    FReciptSaleDate: string; // 판매일자
    FSaleMemo: string; // 영수증 메모
    FPendReceiptNo: string; // 보류영수증번호

    function GetVatTotal: Integer; // 부가세
    function GetReceiveTotal: Integer; // 받은금액 = (현금결제금액 + 카드결제금액)
    function GetUnPaidTotal: Integer; // 미결제금액 = (청구금액 - (현금결제금액 + 카드결제금액 + 즉시환급금액))
    function GetChargeTotal: Integer; // 청구금액
    function GetChangeTotal: Integer;
    function GetDiscountTotal: Integer; // 지급해야할 거스름돈 = ((받은금액 + 즉시환급금액) - 청구금액)
  public
    FacilityList: TArray<TFacilityItem>; //부대시설 상품 이용권 발행 정보

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
    FUserInfo: TUserInfo; // 사용자 정보
    FStoreInfo: TStoreInfo; // 매장 정보
    FMemberInfo: TMemberInfo; // 판매자 정보
    FReceiptInfo: TReceiptInfo; // 영수증 정보
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
  FSexDiv := 0; // 1:남, 2:여, 0:공용
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
      Result := '남';
    CSD_SEX_FEMALE:
      Result := '여';
    CSD_SEX_ALL:
      Result := '공용';
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
      sChildProdDiv := FieldByName('product_div').AsString; // teebox_prod_div(일일,기간,쿠폰 등)
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
    sPayMethod := APayMethod + ' (현금영수증)';
  if AManualApprove then
    sPayMethod := APayMethod + ' (임의등록)';

  UpdateLog(Global.PayLogFile, '----------------------------------------');
  UpdateLog(Global.PayLogFile, Format('[%s 번호] %s', [IIF(AIsApproval, '영수증', '원거래'),
    IIF(AReceiptNo.IsEmpty, SaleManager.ReceiptInfo.ReceiptNo, AReceiptNo)]));
  UpdateLog(Global.PayLogFile, Format('[승 인 여 부] %s', [IIF(AIsApproval, '승인', '취소')]));
  UpdateLog(Global.PayLogFile, Format('[결 제 수 단] %s', [sPayMethod]));
  UpdateLog(Global.PayLogFile, Format('[카 드 번 호] %s', [ACreditCardNo]));
  UpdateLog(Global.PayLogFile, Format('[승 인 번 호] %s', [AApprovalNo]));
  UpdateLog(Global.PayLogFile, Format('[결 제 금 액] %d', [APayAmt]));
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

// 받은금액 = (현금결제금액 + 카드결제금액)
function TReceiptInfo.GetReceiveTotal: Integer;
begin
  Result := (CashPayAmt + CardPayAmt + WelfarePayAmt);
end;

// 미결제금액 = (청구금액 - (현금결제금액 + 카드결제금액))
function TReceiptInfo.GetUnPaidTotal: Integer;
begin
  Result := (SellTotal - (DiscountTotal + ReceiveTotal));
  if (Result < 0) then
    Result := 0;
end;

// 부가세
function TReceiptInfo.GetVatTotal: Integer;
begin
  // Result := Ceil(ChargeTotal / 10);
  Result := (ChargeTotal - Trunc(ChargeTotal / 1.1));
  if (Result < 0) then
    Result := 0;
end;

// 지급할 거스름돈 = ((현금결제금액 + 카드결제금액) - 청구금액)
function TReceiptInfo.GetChangeTotal: Integer;
begin
  Result := ((CashPayAmt + CardPayAmt + WelfarePayAmt) - ChargeTotal);
  if (Result < 0) then
    Result := 0;
end;

// 청구금액
function TReceiptInfo.GetChargeTotal: Integer;
begin
  Result := (SellTotal - DiscountTotal);
end;

// 할인금액 합계
function TReceiptInfo.GetDiscountTotal: Integer;
begin
  Result := (DirectDCTotal + CouponFixedDCTotal + CouponRateDCTotal + XGolfDCTotal + PromoDCTotal + AffiliateAmt);
end;

end.
