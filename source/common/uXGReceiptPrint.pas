unit uXGReceiptPrint;

interface

uses
  System.Classes, System.SysUtils, System.Math, System.StrUtils, fx.Json,
  { DevExpress }
  cxRichEdit,
  { Project }
  uXGSaleManager;

{$I XGCommon.inc}
{$I XGPOS.inc}

const
  // 프린터 특수명령
  rptReceiptCharNormal    = '{N}';   // 일반 글자
  rptReceiptCharBold      = '{B}';   // 굵은 글자
  rptReceiptCharInverse   = '{I}';   // 역상 글자
  rptReceiptCharUnderline = '{U}';   // 밑줄 글자
  rptReceiptAlignLeft     = '{L}';   // 왼쪽 정렬
  rptReceiptAlignCenter   = '{C}';   // 가운데 정렬
  rptReceiptAlignRight    = '{R}';   // 오른쪽 정렬
  rptReceiptSizeNormal    = '{S}';   // 보통 크기
  rptReceiptSizeWidth     = '{X}';   // 가로확대 크기
  rptReceiptSizeHeight    = '{Y}';   // 세로확대 크기
  rptReceiptSizeBoth      = '{Z}';   // 가로세로확대 크기
  rptReceiptSize3Times    = '{3}';   // 가로세로3배확대 크기
  rptReceiptSize4Times    = '{4}';   // 가로세로4배확대 크기
  rptReceiptInit          = '{!}';   // 프린터 초기화
  rptReceiptCut           = '{/}';   // 용지커팅
  rptReceiptImage1        = '{*}';   // 그림 인쇄 1
  rptReceiptImage2        = '{@}';   // 그림 인쇄 2
  rptReceiptCashDrawerOpen= '{O}';   // 금전함 열기
  rptReceiptSpacingNormal = '{=}';   // 줄간격 보통
  rptReceiptSpacingNarrow = '{&}';   // 줄간격 좁음
  rptReceiptSpacingWide   = '{\}';   // 줄간격 넓음
  rptLF                   = '{-}';   // 줄바꿈
  rptBarCodeBegin128      = '{<}';   // 바코드 출력 시작 CODE128
  rptBarCodeBegin39       = '{[}';   // 바코드 출력 시작 CODE39
  rptBarCodeEnd           = '{>}';   // 바코드 출력 끝
  rptQRCodeBegin          = '{^}';   //QR코드 출력 시작
  rptQRCodeEnd            = '{~}';   //QR코드 출력 끝
  // 프린터 출력명령 (영수증 별도 출력에서 사용함)
  rptReceiptCharSaleDate  = '{D}';   // 판매일자
  rptReceiptCharPosNo     = '{P}';   // 포스번호
  rptReceiptCharPosName   = '{Q}';   // 포스명
  rptReceiptCharBillNo    = '{A}';   // 빌번호
  rptReceiptCharDateTime  = '{E}';   // 출력일시

  RECEIPT_TITLE1          = '상품명                      단가 수량       금액';
  RECEIPT_TITLE2          = '상품명                단가 수량       금액';
  RECEIPT_LINE1           = '------------------------------------------------';
  RECEIPT_LINE2           = '------------------------------------------';
  RECEIPT_LINE3           = '================================================';
  RECEIPT_LINE4           = '==========================================';

type
  TDeviceType = (dtNone, dtPos, dtKiosk);
  TPayType = (None, Cash, Card, Payco, Welfare, Void);

  TReceiptStoreInfo = class(TJson)
    StoreName: string;              // 매장명
    BizNo: string;                  // 사업자번호
    BossName: string;               // 업주명
    Tel: string;                    // 전화번호
    Addr: string;                   // 주소
    CashierName: string;            // 판매자명
  end;

  TOrderInfo = class(TJson)
    UseProductName: string;         // 타석배정표에 표시될 상품명
    TeeBox_Floor: string;           // 타석 배정 층
    TeeBox_No: string;              // 타석 배정 번호
    UseTime: string;                // 이용시간
    OneUseTime: string;             // 이용시간(타석상품)
    Coupon: Boolean;                // 쿠폰유무
    CouponQty: Integer;             // 잔여쿠폰수 - 쿠폰사용시 기본 0
    CouponUseDate: string;          // 쿠폰 사용일
    ExpireDate: string;             // 타석상품만기일자
    Reserve_No: string;             // 예약 번호
    Product_Div: string;            // 상품 코드
    ReserveMoveYN: string;          // 타석 이동 여부(Y/N)
    ReserveNoShowYN: string;        // 노쇼 타석 끼워넣기 여부
  end;

  TLockerInfo = class(TJson)
    LockerNo: Integer;              // 라커번호
    LockerName: string;             // 라커명
    FloorCode: string;              // 층
    PurchaseMonth: Integer;         // 사용 개월수
    UseStartDate: string;           // 사용시작일
    UseEndDate: string;             // 사용종료일
  end;

  TReceiptMemberInfo = class(TJson)
    Name: string;                   // 회원명
    Code: string;                   // 회원코드
    Tel: string;                    // 전화번호
    CarNo: string;                  // 차량번호
    CardNo: string;                 // 회원카드번호
    LockerList: string;             // 이용중인라커내역
    ExpireLocker: string;           // 라커만료일
  end;

  TProductInfo = class(TJson)
    Name: string;                   // 상품명
    Code: string;                   // 상품코드
    Price: Integer;                 // 판매금액(1EA 단가)
    Vat: Integer;                   // 부가세금액(1EA 부가세)
    Qty: Integer;                   // 총 수량
  end;

  TDiscountInfo = class(TJson)
    Name: string;                   // 할인명
    QRCode: string;                 // QR Code
    Value: string;                  // 할인금액
  end;

  TPayInfo = class(TJson)
    &PayCode: TPayType;             // 결제타입
    Approval: Boolean;              // 승인유무 T: 승인 F: 취소
    Internet: Boolean;              // 인터넷 승인 유무
    ApprovalAmt: Integer;           // 승인금액
    ApprovalNo: string;             // 승인번호
    OrgApproveNo: string;           // 원 승인번호
    CardNo: string;                 // 카드번호
    CashReceiptPerson: Integer;     // 소득공제 1: 개인, 2: 사업자
    HalbuMonth: string;             // 할부개월

    CompanyName: string;            // PAYCO 승인기관
    MerchantKey: string;            // 가맹번호
    TransDateTime: string;          // 승인일시
    BuyCompanyName: string;         // 매입사
    BuyTypeName: string;            // 매입처
  end;

  TReceiptEtc = class(TJson)
    RcpNo: Integer;
    SaleDate: string;               // 판매일자
    SaleTime: string;               // 판매일시
    ReturnDate: string;             // 반품일자 (반품시 원판매일자)
    RePrint: Boolean;               // 재발행 여부
    TotalAmt: Integer;              // 상품판매시 총 판매금액
    DCAmt: Integer;                 // 할인금액
    KeepAmt: Integer;               // 라커보증금
    ReceiptNo: string;              // 영수증번호(바코드)
    Top1: string;                   // 상단문구1
    Top2: string;                   // 상단문구2
    Top3: string;                   // 상단문구3
    Top4: string;                   // 상단문구4
    Bottom1: string;                // 하단문구1
    Bottom2: string;                // 하단문구2
    Bottom3: string;                // 하단문구3
    Bottom4: string;                // 하단문구4
    SaleUpload: string;
  end;

  TReceipt = class(TJson)
  private
  public
    StoreInfo: TReceiptStoreInfo;
    OrderItems: TArray<TOrderInfo>;
    LockerItems: TArray<TLockerInfo>;
    ReceiptMemberInfo: TReceiptMemberInfo;
    ProductInfo: TArray<TProductInfo>;
    PayInfo: TArray<TPayInfo>;
    DiscountInfo: TArray<TDiscountInfo>;
    ReceiptEtc: TReceiptEtc;

    constructor Create;
    destructor Destroy; override;

    procedure Load(AJsonText: string);
  end;

  { 강습료 간이영수증 설정 }
  TLessonReceiptInfo = record
    BuyerName: string;
    MemberNo: string;
    CoachName: string;
    LessonName: string;
    ProdName: string;
    LessonDateTime: string;
    StoreName: string;
    IssuerName: string;
    LessonFee: Integer;
  end;

  TReceiptPrint = class
  private
    FDeviceType: TDeviceType;
    FReceipt: TReceipt;
    FIsReturn: Boolean;
    FInt_37: Integer;
    FInt_11: Integer;
    FInt_48: Integer;
    FInt_33: Integer;
    FInt_15: Integer;

    function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function SCopy(S: AnsiString; F, L: Integer): string;
    function PadChar(ALength: Integer; APadChar: Char = ' '): string;
    function ByteLen(const AText: string): Integer;
    function GetCurrStr(AData: Currency): string;
    function DateTimeStrToString(const ADateTime: string): string;
  public
    constructor Create(ADeviceType: TDeviceType);
    destructor Destroy; override;

    function ReceiptPrint(AJsonText: string; const AIsReprint, AFacilityAssignTicket: Boolean; var AErrMsg: string): Boolean;
    function PaymentSlipPrint(const APayMethod, AJsonText: string; var AErrMsg: string): Boolean;
    function PaymentSlipForm(const APayMethod: string; const APayInfo: TPayInfo): string;

    function TeeBoxTicketPrint(const AJsonText: string; const AIsReprint, AWithParkingTicket: Boolean; var AErrMsg: string): Boolean;

    function KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
    function KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;

    function LessonReceiptPrint(const ALessonReceiptInfo: TLessonReceiptInfo; var AErrMsg: string): Boolean;
    function LessonReceiptForm(const ALessonReceiptInfo: TLessonReceiptInfo): string;

    function FacilityTicketPrint(const APrintWithAssignTicket: Boolean; var AErrMsg: string): Boolean;
    function FacilityTicketForm(const APrintWithAssignTicket: Boolean): string; overload;
    function FacilityTicketForm(const AFacilityItem: TFacilityItem): string; overload;

    function AddonTicketPrint(const AKind, ATitle, AMemberInfo: string; const AServiceHours: Integer; const AStartTime: string; var AErrMsg: string): Boolean;
    function AddonTicketForm(const AKind, ATitle, AMemberInfo: string; const AServiceHours: Integer; const AStartTime: string; const AIsTicketOnly: Boolean): string;

    function QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
    function QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;

    function SetReceiptPrint: Boolean;
    function SetTeeBoxPrint(const AIsRePrint, AWithParkingTicket: Boolean): Boolean;
    function Print(APrintData: string): Boolean;

    function ReceiptHeader: string;
    function ReceiptItemList: string;
    function ReceiptTotalAmt: string;
    function ReceiptPayList: string;
    function ReceiptPayListInfo: string;
    function ReceiptDiscountInfo: string;
    function ReceiptBottom: string;
    function MakeNewPayCoData(APayInfo: TPayInfo): string;  // NewPayCo정보

    function ConvertPrintData(AData: string): string;
    function ConvertBarCodeCMD(AData: string): string;
    function MakeQRCodeCMD(AQRCode: string): string;

    procedure ReceiptDataToRichEdit(const AReceiptData: string; ARichEdit: TcxRichEdit);

    property IsReturn: Boolean read FIsReturn write FIsReturn default False;
    property Int_11: Integer read FInt_11 write FInt_11;
    property Int_15: Integer read FInt_15 write FInt_15;
    property Int_33: Integer read FInt_33 write FInt_33;
    property Int_37: Integer read FInt_37 write FInt_37;
    property Int_48: Integer read FInt_48 write FInt_48;
  end;

implementation

uses
  { Native }
  Vcl.Controls, Vcl.Graphics,
  { Project }
  uXGGlobal, uXGReceiptPreview;

{ TReceiptPrint }

function TReceiptPrint.MakeQRCodeCMD(AQRCode: string): string;
begin
//  Result := Result + #27#64; //초기화
  Result := Result + #29#40#107#3#0#49#65#50#0; //QR코드 포맷
  Result := Result + #29#40#107#3#0#49#67#8; //사이즈
  Result := Result + #29#40#107 + Chr(length(AQRCode) + 3) + #0 + #49#80#48 + AQRCode; //QR데이터
  Result := Result + #29#40#107#3#0#49#81#48; //인코딩
//  Result := Result + #27#105;
end;

function TReceiptPrint.ConvertBarCodeCMD(AData: string): string;
const
  BAR_HEIGHT = #$50; // 바코드높이
  BAR_CODE39 = #69;
  BAR_ITF = #70;
  BAR_CODABAR = #71;
  BAR_CODE93 = #72;
  BAR_CODE128 = #$49; //#73;
var
  BeginPos128, BeginPos39, BeginPos, EndPos: Integer;
  ChkBarCode39: Boolean;
  ALen: Char;
  BarCodeOrg, BarCodeToStr: string;
begin
  while Pos(rptBarCodeEnd, AData) > 0 do
  begin
    BeginPos128 := Pos(rptBarCodeBegin128, AData);
    BeginPos39 := Pos(rptBarCodeBegin39, AData);
    BeginPos := Min(BeginPos128, BeginPos39);
    if BeginPos128 = 0 then
      BeginPos := BeginPos39;
    if BeginPos39 = 0 then
      BeginPos := BeginPos128;
    ChkBarCode39 := BeginPos = BeginPos39;
    EndPos := Pos(rptBarCodeEnd, AData);

    if BeginPos <= 0 then
      Break;
    if EndPos <= 0 then
      Break;
    if BeginPos >= EndPos then
      Break;

    BarCodeOrg := Copy(AData, BeginPos + 3, EndPos - BeginPos - 3);

    // CODE39 이면
    if ChkBarCode39 then
    begin
      ALen := Char(Length(BarCodeOrg));
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE39 + ALen + BarCodeOrg;
    end
    else
    // CODE128 이면
    begin
      ALen := Char(Length(BarCodeOrg) + 2); // 2 를 더해야 함
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE128 + ALen + #$7B#$42 + BarCodeOrg;
                    //#$1D#$68 +  #$30      + #$1D#$77#$01#$1B#$61#$01 + #$1D#$48#$02 + #$1D#$6B + BAR_CODE128 + #$10 + #$7B#$42 + BarCodeOrg;
    end;
    if ChkBarCode39 then
      AData := ReplaceStr(AData, rptBarCodeBegin39 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr)
    else
      AData := ReplaceStr(AData, rptBarCodeBegin128 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr);
  end;
  Result := AData;
end;

function TReceiptPrint.ConvertPrintData(AData: string): string;
begin
  Result := AData;
  Result := ReplaceStr(Result, rptReceiptCharBold,      #27#71#1);
  Result := ReplaceStr(Result, rptReceiptCharInverse,   #29#66#1);
  Result := ReplaceStr(Result, rptReceiptCharUnderline, #27#45#1);
  Result := ReplaceStr(Result, rptReceiptAlignLeft,     #27#97#0);
  Result := ReplaceStr(Result, rptReceiptAlignCenter,   #27#97#1);
  Result := ReplaceStr(Result, rptReceiptAlignRight,    #27#97#2);
  Result := ReplaceStr(Result, rptReceiptInit,          #27#64);
  Result := ReplaceStr(Result, rptReceiptCut,           #27#105);
  Result := ReplaceStr(Result, rptReceiptImage1,        #13#28#112#1#0);
  Result := ReplaceStr(Result, rptReceiptImage2,        #13#28#112#2#0);
  Result := ReplaceStr(Result, rptReceiptCashDrawerOpen,#27'p'#0#25#250#13#10);
  Result := ReplaceStr(Result, rptReceiptSpacingNormal, #27#51#60);
  Result := ReplaceStr(Result, rptReceiptSpacingNarrow, #27#51#50);
  Result := ReplaceStr(Result, rptReceiptSpacingWide,   #27#51#120);
  Result := ReplaceStr(Result, rptLF,                   #13#10);
  if FDeviceType = dtKiosk then
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#17);//#29#33#34);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#34);//#29#33#51);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #29#33#0);//#27#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #29#33#1);//#27#33#32);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #29#33#16);//#27#33#16);
  end
  else
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#34);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#51);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #27#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #27#33#32);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #27#33#16);
  end;
  Result := ReplaceStr(Result, rptReceiptSizeBoth,      #27#33#48);
  Result := ReplaceStr(Result, rptReceiptCharNormal,    #27#71#0#29#66#0#27#45#0);
  Result := ConvertBarCodeCMD(Result);
end;

constructor TReceiptPrint.Create(ADeviceType: TDeviceType);
begin
  FDeviceType := ADeviceType;
  if Global.DeviceConfig.ReceiptPrinter.Enabled and
     (not Global.DeviceConfig.ReceiptPrinter.ComDevice.Active) then
  begin
    Global.DeviceConfig.ReceiptPrinter.ComDevice.Open;
    Global.DeviceConfig.ReceiptPrinter.ComDevice.ClearInput;
    Global.DeviceConfig.ReceiptPrinter.ComDevice.ClearOutput;
  end;

  if (FDeviceType = dtPos) then
  begin
    Int_11 := 9;
    Int_15 := 13;
    Int_33 := 29;
    Int_37 := 33;
    Int_48 := 42;
  end
  else
  begin
    Int_11 := 11;
    Int_15 := 15;
    Int_33 := 33;
    Int_37 := 37;
    Int_48 := 48;
  end;
end;

destructor TReceiptPrint.Destroy;
begin
  inherited;
end;

function TReceiptPrint.MakeNewPayCoData(APayInfo: TPayInfo): string;
resourcestring
  STR_POINT = '페이코포인트';
  STR_COUPON = '페이코쿠폰';
  STR_CARD = '신용카드';
  STR1 = '***승인정보(고객용)***';
  STR2 = '승인기관     :';
  STR3 = '신용카드번호 :';
  STR4 = '할부개월     :';
  STR5 = '승인번호     :';
  STR6 = '승인일시     :';
  STR7 = '가맹번호     :';
  STR8 = '매입사       :';
  STR9 = '매입처       :';
  STR10 = '***OK 캐쉬백 포인트 내역***';
  STR11 = '적립포인트          :';
  STR12 = '사용가능 적립포인트 :';
  STR13 = '누적 적립포인트     :';
  STR14 = '일시불';
  STR15 = ' 개월';
  STR16 = '티머니카드번호 :';
  STR17 = '결제전잔액   :';
  STR18 = '결제금액     :';
  STR19 = '결제후잔액   :';
  STR20 = '- PAYCO 승인정보 -';
  STR21 = '- PAYCO 취소정보 -';
  STR22 = '***승인취소정보(고객용)***';
  STR23 = '쿠폰이름     :';
var
  ASaleSign: Integer;
begin
  Result := EmptyStr;
  if APayInfo.Approval then
    ASaleSign := 1
  else
    ASaleSign := -1;

  //Result := Result + System.StrUtils.IfThen(IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + System.StrUtils.IfThen(APayInfo.Approval, STR20, STR21) + rptLF;
  Result := Result + RPadB(STR_CARD, Int_33, ' ') + LPadB(GetCurrStr(ASaleSign * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + System.StrUtils.IfThen(APayInfo.Approval, STR1, STR22) + rptLF;
  Result := Result + rptReceiptAlignLeft + RPadB(STR2, Int_15, ' ') + LPadB(APayInfo.CompanyName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR3, Int_15, ' ') + LPadB(APayInfo.CardNo, Int_33, ' ') + rptLF;

  if StrToIntDef(APayInfo.HalbuMonth, 0) = 0 then
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(STR14, Int_33, ' ') + rptLF
  else
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(APayInfo.HalbuMonth + STR15, Int_33, ' ') + rptLF;

  Result := Result + RPadB(STR5, Int_15, ' ') + LPadB(APayInfo.ApprovalNo, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR6, Int_15, ' ') + LPadB(DateTimeStrToString(APayInfo.TransDateTime), Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR7, Int_15, ' ') + LPadB(APayInfo.MerchantKey, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR8, Int_15, ' ') + LPadB(APayInfo.BuyCompanyName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR9, Int_15, ' ') + LPadB(APayInfo.BuyTypeName, Int_33, ' ') + rptLF;
end;

function TReceiptPrint.ReceiptBottom: string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptBarCodeBegin128;
  Result := Result + FReceipt.ReceiptEtc.ReceiptNo;
  Result := Result+ rptBarCodeEnd + rptLF;

  if not FReceipt.ReceiptEtc.Bottom1.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Bottom1 + rptLF;
  if not FReceipt.ReceiptEtc.Bottom2.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Bottom2 + rptLF;
  if not FReceipt.ReceiptEtc.Bottom3.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Bottom3 + rptLF;
  if not FReceipt.ReceiptEtc.Bottom4.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Bottom4 + rptLF;

  if FReceipt.ReceiptEtc.SaleUpload = 'Y' then
  begin
    Result := Result + '매출 등록에 실패하였습니다.' + rptLF;
    Result := Result + '관리자에게 문의 바랍니다.' + rptLF;
  end;

  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  if FReceipt.ReceiptEtc.RePrint then
  begin
    Result := Result + rptReceiptAlignCenter + '※재발행 된 영수증 입니다※' + rptLF;
    Result := Result + rptReceiptAlignLeft;
    if (FDeviceType = dtKiosk) then
      Result := Result + RECEIPT_LINE3 + rptLF;
  end;
  Result := Result + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.PaymentSlipPrint(const APayMethod, AJsonText: string; var AErrMsg: string): Boolean;
var
  Index: Integer;
  APayInfo: TPayInfo;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
        FReceipt.Load(AJsonText);
        for Index := 0 to Pred(Length(FReceipt.PayInfo)) do
        begin
          APayInfo := FReceipt.PayInfo[Index];
          Result := Print(PaymentSlipForm(APayMethod, APayInfo));
        end;
        Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.PaymentSlipForm(const APayMethod: string; const APayInfo: TPayInfo): string;
var
  sPayMethod, sApprovalType: string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;

  if APayInfo.Approval then
    sApprovalType := '승인'
  else
    sApprovalType := '취소';

  sPayMethod := '거래';
  if (APayMethod = CPM_CASH) then
    sPayMethod := '현금결제'
  else if (APayMethod = CPM_CARD) then
    sPayMethod := '신용카드'
  else if (APayMethod = CPM_PAYCO_CARD) then
    sPayMethod := 'PAYCO';

  Result := Result + Format('%s %s 전표', [sPayMethod, sApprovalType]) + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + '매 장 명: ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '대표자명: ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '전화번호: ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '매장주소: ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '사업자번호: ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '판매자명: ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '출력시각: ' + Global.FormattedCurrentDateTime + rptLF;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptReceiptAlignCenter + '[ 고 객 용 ]' + rptLF;
  Result := Result + rptReceiptAlignLeft + RECEIPT_LINE2 + rptLF;
  Result := Result + '[결 제 금 액] ' + FormatFloat('#,##0.##', APayInfo.ApprovalAmt) + rptLF;
  Result := Result + '[부 가 세 액] ' + FormatFloat('#,##0', APayInfo.ApprovalAmt / 11) + rptLF;
  Result := Result + '[승 인 번 호] ' + APayInfo.ApprovalNo + rptLF;

  if (APayMethod = CPM_CARD) or
     (APayMethod = CPM_PAYCO_CARD) then
  begin
    Result := Result + rptReceiptAlignLeft + '[카 드 번 호] ' + APayInfo.CardNo + rptLF;
    if StrToIntDef(APayInfo.HalbuMonth, 0) = 0 then
      Result := Result + '[할 부 개 월] ' + '일시불' + rptLF
    else
      Result := Result + '[할 부 개 월] ' + APayInfo.HalbuMonth + rptLF;
    Result := Result + '[카 드 사 명] ' + APayInfo.BuyCompanyName + rptLF;
    Result := Result + '[매 입 사 명] ' + APayInfo.BuyCompanyName + rptLF;
    Result := Result + '[가 맹 번 호] ' + APayInfo.MerchantKey + rptLF;
  end;

  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.TeeBoxTicketPrint(const AJsonText: string; const AIsReprint, AWithParkingTicket: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := EmptyStr;
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      Result := SetTeeBoxPrint(AIsReprint, AWithParkingTicket);
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := EmptyStr;
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      if (Length(FReceipt.ProductInfo) > 0) then
        Result := Print(KitchenOrderForm(AReceiptNo, AMemberInfo));
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;
var
  AProductInfo: TProductInfo;
  I: Integer;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;
  Result := Result + '주방주문서' + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + RECEIPT_LINE2 + rptLF;
  for I := 0 to Pred(Length(FReceipt.ProductInfo)) do
  begin
    AProductInfo := FReceipt.ProductInfo[I];
//    Result := Result + Format('%s%5s', [
//                       RPadB(AProductInfo.Name, System.Math.IfThen(FDeviceType = dtKiosk, 22, 37), ' '),
//                       FormatFloat('#,##0.##', AProductInfo.Qty)
//                       ]) + rptLF;
    Result := Result + Format('%s%10s%5s%11s', [
                       RPadB(AProductInfo.Name, System.Math.IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                       FormatFloat('#,##0.##', AProductInfo.Price),
                       FormatFloat('#,##0.##', AProductInfo.Qty),
                       FormatFloat('#,##0.##', (AProductInfo.Price * AProductInfo.Qty))
                       ]) + rptLF;
  end;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + '주 문 고 객: ' + AMemberInfo + rptLF;
  Result := Result + '영수증 번호: ' + AReceiptNo + rptLF;
  Result := Result + '발 행 일 시: ' + Global.FormattedCurrentDateTime + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.LessonReceiptPrint(const ALessonReceiptInfo: TLessonReceiptInfo; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    try
      if not Print(LessonReceiptForm(ALessonReceiptInfo)) then
        raise Exception.Create('강습영수증 출력 에러');
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.LessonReceiptForm(const ALessonReceiptInfo: TLessonReceiptInfo): string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeBoth + rptReceiptCharBold;
  Result := Result + '강습영수증(고객용)' + rptLF + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '[성    명] ' + ALessonReceiptInfo.BuyerName + rptLF;
  Result := Result + '[회원번호] ' + ALessonReceiptInfo.MemberNo + rptLF;
  Result := Result + '[강습자명] ' + ALessonReceiptInfo.CoachName + rptLF;
  Result := Result + '[강습지도] ' + ALessonReceiptInfo.LessonName + rptLF;
  Result := Result + '[상품구분] ' + ALessonReceiptInfo.ProdName + rptLF;
  Result := Result + '[영업장명] ' + ALessonReceiptInfo.StoreName + rptLF;
  Result := Result + '[결제금액] ' + FormatFloat('#,##0.##', ALessonReceiptInfo.LessonFee) + '(원)' + rptLF + rptLF;
  Result := Result + '거래일시: ' + ALessonReceiptInfo.LessonDateTime + rptLF;
  Result := Result + '출력일시: ' + Global.FormattedCurrentDateTime + rptLF + rptLF;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + '이 영수증은 거래 증빙자료로' + rptLF;
  Result := Result + '사용할 수 없습니다.' + rptLF + rptLF;
  Result := Result + rptReceiptSizeHeight + ALessonReceiptInfo.IssuerName + rptReceiptSizeNormal + rptReceiptAlignLeft + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.FacilityTicketPrint(const APrintWithAssignTicket: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    if not Print(FacilityTicketForm(APrintWithAssignTicket)) then
      raise Exception.Create('시설이용권 출력 에러');
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TReceiptPrint.FacilityTicketForm(const APrintWithAssignTicket: Boolean): string;
var
  sCurrDate, sCurrTime, sProdDiv: string;
  nRemain: Integer;
begin
  sCurrDate := Global.FormattedCurrentDate;
  sCurrTime := Global.FormattedCurrentDateTime;
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  for var I: ShortInt := 0 to Pred(Length(SaleManager.ReceiptInfo.FacilityList)) do
  begin
    sProdDiv := SaleManager.ReceiptInfo.FacilityList[I].ProdDiv;
    if APrintWithAssignTicket and
       (not sProdDiv.IsEmpty) then
    begin
      Result := Result + rptLF + rptLF;
      Result := Result + rptReceiptSizeWidth + rptReceiptCharBold + rptReceiptAlignCenter + SaleManager.ReceiptInfo.FacilityList[I].ProdName + rptReceiptCharNormal + rptReceiptSizeNormal + rptLF;
      Result := Result + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
      Result := Result + '이용범위: ' + SaleManager.ReceiptInfo.FacilityList[I].AccessControlName + rptLF;
      Result := Result + '이용일자: ' + sCurrDate + rptLF;
      Result := Result + '발행일시: ' + sCurrTime + rptLF + rptLF;
      //배정표 출력
      if (sProdDiv = CTP_DAILY) then
        Result := Result + '상품구분: 일일입장' + rptLF
      else if (sProdDiv = CTP_COUPON) or
              (sProdDiv = CTP_TERM) then
      begin
        Result := Result + '이용시작: ' + SaleManager.ReceiptInfo.FacilityList[I].UseStartDate + rptLF;
        Result := Result + '이용종료: ' + SaleManager.ReceiptInfo.FacilityList[I].UseEndDate + rptLF;
        if (sProdDiv = CTP_COUPON) then
        begin
          nRemain := SaleManager.ReceiptInfo.FacilityList[I].RemainCount;
          Result := Result + '상품구분: 쿠폰제' + rptLF;
          Result := Result + '잔여회수: ' + IntToStr(nRemain) + rptLF;
        end
        else
          Result := Result + '상품구분: 기간제' + rptLF + rptLF;
      end;
      Result := Result + rptLF;
      Result := Result + rptReceiptAlignCenter + '이용해 주셔서 감사합니다.' + rptLF;
      Result := Result + FReceipt.StoreInfo.StoreName + rptLF;
      Result := Result + rptReceiptAlignLeft + rptLF + rptLF + rptReceiptCut;
    end;

    if not SaleManager.ReceiptInfo.FacilityList[I].AccessBarcode.IsEmpty then
    begin
      //출입용 바코드
      Result := Result + rptLF;
      Result := Result + rptReceiptSizeWidth + rptReceiptCharBold + rptReceiptAlignCenter + '부대시설 이용권' + rptReceiptCharNormal + rptReceiptSizeNormal + rptLF;
      Result := Result + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
      Result := Result + '이용범위: ' + SaleManager.ReceiptInfo.FacilityList[I].AccessControlName + rptLF;
      Result := Result + '발행일시: ' + sCurrTime + rptLF + rptLF;
      Result := Result + rptBarCodeBegin128 + SaleManager.ReceiptInfo.FacilityList[I].AccessBarcode + rptBarCodeEnd + rptLF;
      Result := Result + rptReceiptAlignCenter + '이용해 주셔서 감사합니다.' + rptLF;
      Result := Result + FReceipt.StoreInfo.StoreName + rptLF;
      Result := Result + rptReceiptAlignLeft + rptLF + rptLF + rptReceiptCut;
    end;
  end;
end;

function TReceiptPrint.FacilityTicketForm(const AFacilityItem: TFacilityItem): string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  for var I: ShortInt := 0 to Pred(Length(SaleManager.ReceiptInfo.FacilityList)) do
  begin
    Result := Result + rptLF;
    Result := Result + rptReceiptSizeWidth + rptReceiptCharBold + rptReceiptAlignCenter + '부대시설 이용권' + rptReceiptCharNormal + rptReceiptSizeNormal + rptLF;
    Result := Result + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
    Result := Result + '이용범위: ' + AFacilityItem.AccessControlName + rptLF;
    Result := Result + '발행일시: ' + Global.FormattedCurrentDateTime + rptLF + rptLF;
    Result := Result + rptBarCodeBegin128 + AFacilityItem.AccessBarcode + rptBarCodeEnd + rptLF;
    Result := Result + rptReceiptAlignCenter + '이용해 주셔서 감사합니다.' + rptLF;
    Result := Result + FReceipt.StoreInfo.StoreName + rptLF;
    Result := Result + rptReceiptAlignLeft + rptLF + rptLF + rptReceiptCut;
  end;
end;

function TReceiptPrint.AddonTicketPrint(const AKind, ATitle, AMemberInfo: string; const AServiceHours: Integer;
  const AStartTime: string; var AErrMsg: string): Boolean; //AStartTime: hhnnss
begin
  Result := False;
  AErrMsg := '';

  try
    Result := Print(AddonTicketForm(AKind, ATitle, AMemberInfo, AServiceHours, AStartTime, True));
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TReceiptPrint.AddonTicketForm(const AKind, ATitle, AMemberInfo: string; const AServiceHours: Integer; const AStartTime: string; const AIsTicketOnly: Boolean): string;
var
  sHours: string;
begin
  if (AServiceHours = 0) then
    sHours := System.StrUtils.IfThen(Global.AddOnTicket.PrintAlldayPass, '(종일)', '')
  else
    sHours := '(' + IntToStr(AServiceHours) + '시간)';

  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptLF + rptLF + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeWidth + Format('%s %s', [ATitle, sHours]) + rptReceiptAlignLeft + rptReceiptSizeNormal + rptLF;
  if True then
    Result := Result + rptReceiptAlignCenter + AMemberInfo + rptReceiptAlignLeft + rptLF;

  Result := Result + rptBarCodeBegin128;
  Result := Result + AKind + FormatFloat('00', AServiceHours) + Copy(Global.CurrentDate, 3, 6){yymmdd} + AStartTime;
  Result := Result + rptBarCodeEnd;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + FormatDateTime('yyyy년mm월dd일 hh시nn분', Now) + rptLF + rptLF + rptLF + rptLF + rptLF + rptLF;
  if AIsTicketOnly then
    Result := Result + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    Result := Print(QRCodePrintForm(AQRCode, ATitle, AStoreName, AMemberName));
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TReceiptPrint.QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;
begin
  Result := EmptyStr;
  Result := Result + rptLF + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeWidth + ATitle + rptReceiptSizeNormal + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF + rptLF + rptLF;
  Result := Result + MakeQRCodeCMD(AQRCode) + rptLF;
  Result := Result + AMemberName + rptLF;
  Result := Result + AStoreName + rptLF;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.ReceiptHeader: string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeBoth + rptReceiptCharBold;
  Result := Result + '영 수 증' + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '매 장 명 : ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '대표자명 : ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '전화번호 : ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '매장주소 : ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '사업자번호 : ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '판매자명 : ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '거래일시 : ' + FReceipt.ReceiptEtc.SaleDate + ' ' + FReceipt.ReceiptEtc.SaleTime + rptLF;
  Result := Result + '출력일시 : ' + Copy(Global.FormattedCurrentDateTime, 1, 16) {yyyy-mm-dd hh:nn} + rptLF;

  if not FReceipt.ReceiptEtc.Top1.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Top1 + rptLF;
  if not FReceipt.ReceiptEtc.Top2.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Top2 + rptLF;
  if not FReceipt.ReceiptEtc.Top3.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Top3 + rptLF;
  if not FReceipt.ReceiptEtc.Top4.IsEmpty then
    Result := Result + FReceipt.ReceiptEtc.Top4 + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_TITLE1, RECEIPT_TITLE2) + rptLF;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
end;

function TReceiptPrint.ReceiptItemList: string;
var
  Index: Integer;
  AProductInfo: TProductInfo;
begin
  Result := EmptyStr;
  for Index := 0 to Pred(Length(FReceipt.ProductInfo)) do
  begin
    AProductInfo := FReceipt.ProductInfo[Index];
    Result := Result + Format('%s%10s%5s%11s', [
                         RPadB(AProductInfo.Name, System.Math.IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                         FormatFloat('#,##0.##', AProductInfo.Price),
                         FormatFloat('#,##0.##', AProductInfo.Qty),
                         FormatFloat('#,##0.##', (AProductInfo.Price * AProductInfo.Qty))
                        ]) + rptLF;
  end;
end;

function TReceiptPrint.ReceiptPayList: string;
var
  Index: Integer;
  CashStr: string;
  APayInfo: TPayInfo;
begin
  Result := EmptyStr;
  for Index := 0 to Pred(Length(FReceipt.PayInfo)) do
  begin
    APayInfo := FReceipt.PayInfo[Index];
    if APayInfo.PayCode = Cash then
    begin
      if APayInfo.Internet and
         (not APayInfo.ApprovalNo.IsEmpty) then
      begin
        if Trim(APayInfo.OrgApproveNo).IsEmpty then
          Result := Result + LPadB('현금영수증(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('현금영수증(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (-1 * APayInfo.ApprovalAmt)), Int_15, ' ') + rptLF;
      end
      else
      begin
        CashStr := System.StrUtils.IfThen(APayInfo.Approval, '승인', '취소');
        Result := Result + LPadB('현금(' + CashStr + ')', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', System.Math.IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if APayInfo.PayCode = Card then
    begin
      if APayInfo.Internet then
      begin
        if APayInfo.Approval then
          Result := Result + LPadB('신용카드(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('신용카드(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', -1 * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end
      else
      begin
        Result := Result + LPadB('카드(수기등록)', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', System.Math.IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if APayInfo.PayCode = Payco then
    begin
      if APayInfo.Approval then
        Result := Result + LPadB('PAYCO(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('PAYCO(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
    end;

    if APayInfo.PayCode = Welfare then
    begin
      if APayInfo.Approval then
        Result := Result + LPadB('포인트(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('포인트(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
    end;
  end;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
end;

function TReceiptPrint.ReceiptPayListInfo: string;
var
  Index: Integer;
  CashMsg: string;
  APayInfo: TPayInfo;
begin
  Result := EmptyStr;
  with FReceipt do
  begin
    for Index := 0 to Pred(Length(PayInfo)) do
    begin
      APayInfo := PayInfo[Index];
      if APayInfo.PayCode = Cash then
      begin
        if not Trim(APayInfo.ApprovalNo).IsEmpty then
        begin
          CashMsg := System.StrUtils.IfThen(APayInfo.CashReceiptPerson = 1, '(소득공제)', '(지출증빙)');
          Result := Result + rptReceiptAlignCenter + '';
          Result := Result + System.StrUtils.IfThen(APayInfo.Approval, '<현금영수증' + CashMsg + ' 승인내역>', '<현금영수증' + CashMsg + ' 취소내역>') + rptLF;
          Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
          Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
          Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
          Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF;
          Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF;
        end;
      end;

      if (APayInfo.PayCode = Card) then
      begin
        Result := Result + rptReceiptAlignCenter;
        Result := Result + System.StrUtils.IfThen(APayInfo.Approval, '<신용카드 승인내역>', '<신용카드 취소내역>') + rptLF;
        Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
        Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
        Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;

        if APayInfo.HalbuMonth > '1' then
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB(APayInfo.HalbuMonth  + '개월', Int_15, ' ') + rptLF
        else
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB('일시불', Int_15, ' ') + rptLF;
        Result := Result + RPadB('발 급 사', Int_33, ' ') + LPadB(APayInfo.BuyCompanyName, Int_15, ' ') + rptLF;
        Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF;
        Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF;
      end;

      if APayInfo.PayCode = Payco then
        Result := Result + MakeNewPayCoData(APayInfo);
    end;

    if not Result.IsEmpty then
      Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  end;
end;

function TReceiptPrint.ReceiptDiscountInfo: string;
var
  Index: Integer;
begin
  Result := EmptyStr;
  if Length(FReceipt.DiscountInfo) > 0 then
  begin
    Result := Result + rptReceiptAlignCenter + '<할인내역>' + rptLF;
    Result := Result + rptReceiptAlignLeft;
    Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
    for Index := 0 to Pred(Length(FReceipt.DiscountInfo)) do
      Result := Result + RPadB(FReceipt.DiscountInfo[Index].Name, Int_33, ' ') + LPadB(FormatFloat('#,##0.##', StrToInt(FReceipt.DiscountInfo[Index].Value)), Int_15, ' ') + rptLF;
    Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  end;
end;

function TReceiptPrint.ReceiptPrint(AJsonText: string; const AIsReprint, AFacilityAssignTicket: Boolean; var AErrMsg: string): Boolean;
var
  bIsTeeBox, bIsReceipt: Boolean;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  bIsTeeBox := False;
  bIsReceipt := False;
  try
    try
      FReceipt.Load(AJsonText);
      if (FDeviceType = dtPos) then
      begin
        bIsTeeBox := (Length(FReceipt.OrderItems) > 0);
        if bIsTeeBox then
          SetTeeBoxPrint(AIsReprint, True);
      end else
      begin
        bIsTeeBox := (not FReceipt.OrderItems[0].Reserve_No.IsEmpty);
        if bIsTeeBox then
          SetTeeBoxPrint(AIsReprint, False);
      end;

      bIsReceipt := (not Global.TeeBoxEmergencyMode) and (Length(FReceipt.ProductInfo) > 0);
      if (Length(SaleManager.ReceiptInfo.FacilityList) > 0) then
        FacilityTicketPrint(AFacilityAssignTicket, AErrMsg);

      if bIsReceipt then
        SetReceiptPrint;

      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.ReceiptTotalAmt: string;
var
  AVat, Index: Integer;
begin
  AVat := (FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt) - Trunc((FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt) / 1.1);
  Result := EmptyStr;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptSizeWidth;                        // 16
  Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '판매금액%40s', '판매금액%13s'), [FormatFloat('#,##0.##', FReceipt.ReceiptEtc.TotalAmt)]) + rptLF;
  Result := Result + rptReceiptSizeNormal;
  if (FReceipt.ReceiptEtc.DCAmt <> 0) then
    Result := Result + LPadB('할인금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.ReceiptEtc.DCAmt), Int_11, ' ') + rptLF;
  Result := Result + LPadB('과세상품금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', ((FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt) - AVat)), Int_11, ' ') + rptLF;
  Result := Result + LPadB('부가세(VAT)금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', AVat), Int_11, ' ') + rptLF;
  Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  if (FReceipt.ReceiptEtc.KeepAmt <> 0) then
  begin
    Result := Result + LPadB('라커보증금', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.ReceiptEtc.KeepAmt), Int_11, ' ') + rptLF;
    for Index := 0 to Pred(Length(FReceipt.LockerItems)) do
      if (FReceipt.LockerItems[Index].LockerNo > 0) then
        Result := Result + LPadB(Format('%sF %s (%d개월) %s~%s', [
            FReceipt.LockerItems[Index].FloorCode, FReceipt.LockerItems[Index].LockerName,
            FReceipt.LockerItems[Index].PurchaseMonth, FReceipt.LockerItems[Index].UseStartDate, FReceipt.LockerItems[Index].UseEndDate
        ]), Int_48, ' ') + rptLF;
    Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  end;

  Result := Result + rptReceiptSizeWidth;
  if FIsReturn then
    Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '취소금액%40s', '취소금액%13s'), [FormatFloat('#,##0.##', -1 * (FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt))]) + rptLF
  else
    Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '결제금액%40s', '결제금액%13s'), [FormatFloat('#,##0.##', (FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt))]) + rptLF;

  Result := Result + rptReceiptSizeNormal;
end;

function TReceiptPrint.SetReceiptPrint: Boolean;
var
  PrintData: string;
  I: Integer;
begin
  Result := False;
  PrintData := EmptyStr;
  PrintData := PrintData + rptReceiptInit;
  PrintData := PrintData + ReceiptHeader;
  PrintData := PrintData + ReceiptItemList;
  PrintData := PrintData + ReceiptTotalAmt;
  PrintData := PrintData + ReceiptPayList;
  PrintData := PrintData + ReceiptPayListInfo;
  PrintData := PrintData + ReceiptDiscountInfo;
  PrintData := PrintData + ReceiptBottom;

  if Global.ReceiptPreview then
    with TXGReceiptPreviewForm.Create(nil) do
    try
      PreviewData := PrintData;
      if (ShowModal <> mrOK) then
        Exit(True);
    finally
      Free;
    end;

  for I := 1 to Global.ReceiptCopies do
    Result := Print(PrintData);
end;

function TReceiptPrint.SetTeeBoxPrint(const AIsRePrint, AWithParkingTicket: Boolean): Boolean;
var
  I, J: Integer;
  PrintData, sUseTime, sMemberInfo: string;
begin
  Result := False;
  with FReceipt do
    for I := 0 to Pred(Length(OrderItems)) do
    begin
      PrintData := rptReceiptInit;
      PrintData := PrintData + rptReceiptCharBold;
      PrintData := PrintData + rptReceiptAlignCenter + rptReceiptSizeBoth + rptReceiptCharBold + rptReceiptCharInverse;

      if (OrderItems[I].ReserveMoveYN = CRC_YES) then
        PrintData := PrintData + ' 타석배정표(이동) ' + rptLF
      else
        PrintData := PrintData + ' 타석배정표 ' + rptLF;

      PrintData := PrintData + rptReceiptCharNormal + rptReceiptAlignLeft + rptReceiptSizeNormal;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + '타석번호 : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s %s번', [OrderItems[I].TeeBox_Floor, OrderItems[I].TeeBox_No]) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + '이용시간 : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s', [OrderItems[I].UseTime]) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + '배정시간 : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s분', [OrderItems[I].OneUseTime]) + rptReceiptSizeNormal + rptLF;

      if not ReceiptMemberInfo.Name.IsEmpty then
      begin
        PrintData := PrintData + rptReceiptSizeHeight;
        PrintData := PrintData + '회 원 명 : ';
        PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth + ReceiptMemberInfo.Name + rptReceiptSizeNormal + rptLF + rptLF;
        PrintData := PrintData + '회원번호 : ' + ReceiptMemberInfo.Code + rptLF;
      end
      else
        PrintData := PrintData + rptLF;

      PrintData := PrintData + '이용일자 : ' + Global.FormattedCurrentDate + rptLF;
      PrintData := PrintData + '서비스명 : ' + OrderItems[I].UseProductName + rptLF;

      if not OrderItems[I].ExpireDate.IsEmpty then
        PrintData := PrintData + '만기일자 : ' + OrderItems[I].ExpireDate + rptLF;
      if not OrderItems[I].Reserve_No.IsEmpty then
        PrintData := PrintData + '예약번호 : ' + OrderItems[I].Reserve_No + rptLF
      else
        PrintData := PrintData + '예약번호 : 관리자에게 문의 바랍니다.' + rptLF;

      if OrderItems[I].Coupon then
        PrintData := PrintData + '잔여쿠폰 : ' + Format('%d 매', [OrderItems[I].CouponQty]) + rptLF;

      if not ReceiptMemberInfo.LockerList.IsEmpty then
      begin
        PrintData := PrintData + '라커이용 : ' + ReceiptMemberInfo.LockerList + rptLF;
        PrintData := PrintData + '라커만기 : ' + ReceiptMemberInfo.ExpireLocker + rptLF;
      end;

      PrintData := PrintData + '출력시각 : ' + FormatDateTime('yyyy-mm-dd hh:nn', Now) + rptLF;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
      PrintData := PrintData + rptReceiptAlignCenter;
      PrintData := PrintData + '취소 요청은 프런트에 문의해 주십시오.' + rptLF;
      PrintData := PrintData + '이용해 주셔서 감사합니다.' + rptLF;
      PrintData := PrintData + rptReceiptAlignCenter + FReceipt.StoreInfo.StoreName + rptReceiptAlignLeft + rptLF;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;

      if (OrderItems[I].ReserveNoShowYN = CRC_YES) then
        PrintData := PrintData + '※노쇼 예약을 재등록한 배정표 입니다.' + rptLF;

      if AIsRePrint then
        PrintData := PrintData + '※재발행 된 배정표 입니다.' + rptLF;

      if not ReceiptEtc.Bottom1.IsEmpty then
        PrintData := PrintData + ReceiptEtc.Bottom1 + rptLF;

      if not ReceiptEtc.Bottom2.IsEmpty then
        PrintData := PrintData + ReceiptEtc.Bottom2 + rptLF;

      if not ReceiptEtc.Bottom3.IsEmpty then
        PrintData := PrintData + ReceiptEtc.Bottom3 + rptLF;

      if not ReceiptEtc.Bottom4.IsEmpty then
        PrintData := PrintData + ReceiptEtc.Bottom4 + rptLF;

      PrintData := PrintData + rptReceiptAlignLeft + rptLF;
      if AWithParkingTicket then
      begin
        sMemberInfo := Format('회원명: %s (%s)', [ReceiptMemberInfo.Name, ReceiptMemberInfo.Code]);
        PrintData := PrintData + rptLF + rptLF + rptLF;

        if Global.AddOnTicket.ParkingTicket then
        begin
          if not (Global.ParkingServer.Enabled and
                 (OrderItems[I].Product_Div = CTP_TERM)) then
          begin
            if Global.ParkingServer.Enabled then
              sUseTime := Copy(StringReplace(OrderItems[I].UseTime, ':', '', [rfReplaceAll]), 1, 4) + '00'
            else
              sUseTime := Global.CurrentTime;

            PrintData := PrintData + rptLF + rptLF + rptReceiptCut;
            PrintData := PrintData + AddonTicketForm(CAT_PARKING_TICKET, '주 차 권', sMemberInfo, Global.ParkingServer.BaseHours, sUseTime, False);
          end;
        end;

        if Global.AddOnTicket.SaunaTicket then
        begin
          PrintData := PrintData + rptLF + rptLF + rptReceiptCut;
          PrintData := PrintData + AddonTicketForm(CAT_SAUNA_TICKET, System.StrUtils.IfThen(Global.AddOnTicket.SaunaTicketKind = 0, '사우나', '샤워실') + '이용권',
            sMemberInfo, 0, Global.CurrentTime, False);
        end;

        if Global.AddOnTicket.FitnessTicket then
        begin
          PrintData := PrintData + rptLF + rptLF + rptReceiptCut;
          PrintData := PrintData + AddonTicketForm(CAT_FITNESS_TICKET, '피트니스이용권', sMemberInfo, 0, Global.CurrentTime, False);
        end;
      end;

      PrintData := PrintData + rptLF + rptLF + rptLF + rptReceiptCut;
      if Global.ReceiptPreview then
        with TXGReceiptPreviewForm.Create(nil) do
        try
          PreviewData := PrintData;
          if (ShowModal <> mrOK) then
            Exit(True);
        finally
          Free;
        end;

      for J := 1 to Global.TeeBoxTicketCopies do
        Result := Print(PrintData);
    end;
end;

function TReceiptPrint.Print(APrintData: string): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  try
    SendData := ConvertPrintData(APrintData);
    Global.DeviceConfig.ReceiptPrinter.ComDevice.Write(PAnsiChar(SendData), Length(SendData), False);
    Result := True;
  except
    on E: Exception do
    begin
    end;
  end;
end;

function TReceiptPrint.LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), APadChar) + Result;
end;

function TReceiptPrint.RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), APadChar);
end;

function TReceiptPrint.SCopy(S: AnsiString; F, L: Integer): string;
var
  ST, ED: Integer;
begin
  ST := 0;
  ED := 0;
  if (F = 1) then
    ST := 1
  else
  begin
    case ByteType(S, F) of
      mbSingleByte : ST := F;
      mbLeadByte   : ST := F;
      mbTrailByte  : ST := (F - 1);
    end;
  end;

  case ByteType(S, ST + L - 1) of
    mbSingleByte : ED := L;
    mbLeadByte   : ED := (L - 1);
    mbTrailByte  : ED := L;
  end;

  Result := Copy(S, ST, ED);
end;

function TReceiptPrint.PadChar(ALength: Integer; APadChar: Char = ' '): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to ALength do
    Result := Result + APadChar;
end;

function TReceiptPrint.ByteLen(const AText: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 1 to Length(AText) do
    Result := Result + System.Math.IfThen(AText[Index] <= #$00FF, 1, 2);
end;

function TReceiptPrint.GetCurrStr(AData: Currency): string;
begin
  Result := FormatFloat('#,##0.###', AData);
end;

function TReceiptPrint.DateTimeStrToString(const ADateTime: string): string;
begin
  if (Length(ADateTime) = 14) then
    Result := Copy(ADateTime, 1, 4) + FormatSettings.DateSeparator + Copy(ADateTime, 5, 2) + FormatSettings.DateSeparator + Copy(ADateTime, 7, 2) + ' ' +
              Copy(ADateTime, 9, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 11, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 13, 2);
end;

procedure TReceiptPrint.ReceiptDataToRichEdit(const AReceiptData: string; ARichEdit: TcxRichEdit);
var
  nIndex: Integer;
  sReceiptData, sCmd: string;

  procedure NextToken;
  begin
    nIndex := Pos('{', sReceiptData);
    if (nIndex > 0) then
    begin
      ARichEdit.SelText := Copy(sReceiptData, 1, nIndex - 1);
      Delete(sReceiptData, 1, nIndex - 1);
      sCmd := Copy(sReceiptData, 1, 3);
      if (sCmd = rptReceiptCharNormal) then           //일반 글자
        ARichEdit.SelAttributes.Style := []
      else if (sCmd = rptReceiptCharBold) then        //굵은 글자
        ARichEdit.SelAttributes.Style := [fsBold]
      else if (sCmd = rptReceiptCharInverse) then     //역상 글자
        ARichEdit.SelAttributes.Color := clRed
      else if (sCmd = rptReceiptCharUnderline) then   //밑줄 글자
        ARichEdit.SelAttributes.Style := [fsUnderline]
      else if (sCmd = rptReceiptAlignLeft) then       //왼쪽 정렬
        ARichEdit.Paragraph.Alignment := taLeftJustify
      else if (sCmd = rptReceiptAlignCenter) then     //가운데 정렬
        ARichEdit.Paragraph.Alignment := taCenter
      else if (sCmd = rptReceiptAlignRight) then      //오른쪽 정렬
        ARichEdit.Paragraph.Alignment := taRightJustify
      else if (sCmd = rptReceiptSizeNormal) then      //보통 크기
        ARichEdit.SelAttributes.Size := 10
      else if (sCmd = rptReceiptSizeWidth) then       //가로확대 크기
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSizeHeight) then      //세로확대 크기
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSizeBoth) then        //가로세로확대 크기
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSize3Times) then      //가로세로3배확대 크기
        ARichEdit.SelAttributes.Size := 30
      else if (sCmd = rptReceiptSize4Times) then      //가로세로4배확대 크기
        ARichEdit.SelAttributes.Size := 40
      else if (sCmd = rptLF) then                     //줄바꿈
        ARichEdit.SelText := #13
      else if (sCmd = rptReceiptInit) then            //프린터 초기화
      else if (sCmd = rptReceiptCut) then             //용지커팅
      else if (sCmd = rptReceiptImage1) then          //그림 인쇄 1
      else if (sCmd = rptReceiptImage2) then          //그림 인쇄 2
      else if (sCmd = rptReceiptCashDrawerOpen) then  //금전함 열기
      else if (sCmd = rptReceiptSpacingNormal) then   //줄 간격 기본
      else if (sCmd = rptReceiptSpacingNarrow) then   //줄 간격 좁음
      else if (sCmd = rptReceiptSpacingWide) then     //줄 간격 넓음
      else if (sCmd = rptBarCodeBegin128) then        //바코드 출력 시작
      begin
        ARichEdit.SelAttributes.Height := 20;
        ARichEdit.SelText := '<';
      end
      else if (sCmd = rptBarCodeBegin39) then         //바코드 출력 시작
      begin
        ARichEdit.SelAttributes.Height := 20;
        ARichEdit.SelText := '<';
      end
      else if (sCmd = rptBarCodeEnd) then             //바코드 출력 끝
      begin
        ARichEdit.SelText := '>' + #13;
        ARichEdit.SelAttributes.Height := 10;
      end
      else
        ARichEdit.SelText := sCmd;

      Delete(sReceiptData, 1, 3);
    end
    else
    begin
      ARichEdit.SelText := sReceiptData;
      sReceiptData := '';
    end;
  end;
begin
  sReceiptData := AReceiptData;

  nIndex := Pos(#27#97#1#29#118#48, sReceiptData);    //서명 이미지가 있으면 삭제
  if (nIndex > 0) then
    Delete(sReceiptData, nIndex, 8);

  while (Length(sReceiptData) > 0) do
    NextToken;
end;

{ TReceipt }

constructor TReceipt.Create;
begin
  StoreInfo := TReceiptStoreInfo.Create;
  OrderItems := [];
  LockerItems := [];
  ReceiptMemberInfo := TReceiptMemberInfo.Create;
  DiscountInfo := [];
  ReceiptEtc := TReceiptEtc.Create;
  ProductInfo := [];
  PayInfo := [];
end;

destructor TReceipt.Destroy;
begin
  StoreInfo.Free;
  ReceiptMemberInfo.Free;
  ReceiptEtc.Free;
  OrderItems := [];
  LockerItems := [];
  DiscountInfo := [];
  ProductInfo := [];
  PayInfo := [];

  inherited;
end;

procedure TReceipt.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally

  end;
end;

end.
