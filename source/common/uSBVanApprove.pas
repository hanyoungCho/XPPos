(*******************************************************************************

  밴 승인 모듈

  TVanModul (외부 응용 프로그램과 인터페이스 하는 클래스)
    - 카드,현금,수표,캐쉬백 등 승인처리
    - 승인/할인금액을 처리
    - 오굿/파트너스 관련 로직을 처리
    - 리얼/테스트 모드등 각종 환경 설정값 관리

  TVanApprove (밴 승인 상위 추상 클래스 구현로직 없음)
    - 각 밴사별 실제 승인/응답 전문 처리 로직 작성시 이 클래스를 상속 받아 구현한다.
    - TVanModul 에서 이 클래스의 추상 메소드를 호출하게 된다.

             신용승인,현금,수표조회,핀패드,은련,오굿,파트너스,보안(X),티머니,캐시비,IC보안인증,CAT연동,위쳇페이
  KFTC(금결원)   O      O      O       O     X    X      X       X       X      X      O         O
  Kicc           O      O      O       O                                                         O
  Kis            O      O      O       O     O    O      O       X       X      X      O         O
  FDIK(KMPS)     O      O      O       O                                                         O
  Koces          O      O      O       O                                                         O
  KSNET          O      O      O       O     O    X      X       X       X      X      O         O
  JT-NET(NC)     O      O      O       O     O    X      X       X       X      O      O         O        O
  Nice           O      O      O       O     X    X      X       O       O      O      X         O
  Smartro        O      O      O       O     O    O      O       O       X      X      X         O
  KCP            O      O      O       O                                                         O
  다우(StarVan)  O      O      O       O     O    O      O       X       X      X      O         O
  KOVAN          O      O      O       O                                                         O
  SPC(AWP)       O      O      O       O                                                         O

  - 멀티밴 기능 지원 안함.

*******************************************************************************)

unit uSBVanApprove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils,
  IdTCPClient, CPort, IdGlobal;

type
  // 밴사
  TVanCompType = (vctNone, vctKFTC, vctKICC, vctKIS, vctFDIK, vctKOCES, vctKSNET,
                  vctJTNet, vctNICE, vctSmartro, vctKCP, vctStarVAN, vctKOVAN, vctSPC);
  // 오굿/파트너스 구분 (사용안함, KB오굿, BC파트너스)
  TPartnerShipType = (pstNone, pstOgood, pstPartners);

  TKocesDevice = (kdKSP9000, kdKSP9020, kdSign1000);

  // 멤버십 구분 (BC 오포인트, BC 그린카드, SK T 멤버십, 삼성 U 포인트, 기가포인트, Syrup멤버쉽, 카카오쿠폰)
  TMembershipType = (mtBCPoint, mtGreeanCard, mtSKT, mtUPoint, mtGiga, mtSyrup, mtKakao, mtWipoint, mtGalaxia);

  // 멤버십 거래구분 (조회, 적립, 할인, 인증, 사용)
  TMembershipTradeType = (mttInquiry, mttSave, mttDiscount, mttAuth, mttUse);

  // 시럽 코드 구분  (ssa, ok cashbag, 쿠폰, syrup order, syrup mileage, syrup stamp, syrup 복합)
  TSyrupCode = (scSSA, scOCB, scCoupon, scOrder, scMileage, scStamp, scSyrup);

  // 시럽 서비스 타입  (호출, 적립, 사용, 할인, 취소, 주문, 재출력, 결제, 복합, 조회)
  TSyrupType = (stCommon, stSave, stUse, stDiscount, stCancel, stOrder, stReprint, stpay, stMix, stQuery);

  // 현금영수증 전송정보
  TCashSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    SaleAmt: Currency;                 // 결제금액
    SvcAmt: Currency;                  // 봉사료
    VatAmt: Currency;                  // 부가세
    FreeAmt: Currency;                 // 면세
    CardNo: AnsiString;                // 카드번호
    Person: Boolean;                   // 개인/사업자 구분
    KeyInput: Boolean;                 // 키인여부
    MSRTrans: Boolean;                 // MSR거래(IC보안일때만 사용)
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
    CancelReason: Integer;             // 취소사유코드 (1:거래취소, 2:오류발급, 3:기타)
    CashRcpAutoEnable: Boolean;        // 현금영수증 자진발급 여부
  end;

  // 현금영수증 응답정보
  TCashRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    ICCardNo: AnsiString;              // IC카드번호
  end;

  // 카드 전송정보
  TCardSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    SaleAmt: Currency;                 // 결제금액
    SvcAmt: Currency;                  // 봉사료
    VatAmt: Currency;                  // 부가세
    FreeAmt: Currency;                 // 면세
    CardNo: AnsiString;                // 카드번호(트랙2정보)
    VaildThru: AnsiString;             // 유효기간
    HalbuMonth: Integer;               // 할부개월
    KeyInput: Boolean;                 // 키인여부
    MSRTrans: Boolean;                 // MSR거래(IC보안일때만 사용)
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
    PointCardNo: AnsiString;           // 포인트카드번호(트랙2정보)
    CouponNo: AnsiString;              // 쿠폰정보(오굿/파트너스)
    RcpPrint: AnsiString;              // 영수증출력여부(Paperless)
    SignData: AnsiString;              // 보관 사인데이터
    SignLength: Integer;               // 보관 사인데이터 길이
    PosEntryMode: AnsiString;          // WCC (나이스, 다우데이타)
    SamsungPay: Boolean;               // 삼성페이 여부(KCP PG)
  end;

  // 카드 응답정보
  TCardRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    TransNo: AnsiString;               // 거래번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    BalgupsaCode: AnsiString;          // 발급사코드
    BalgupsaName: AnsiString;          // 발급사명
    CompCode: AnsiString;              // 매입사코드
    CompName: AnsiString;              // 매입사명
    KamaengNo: AnsiString;             // 가맹점번호
    IsSignOK: Boolean;                 // 정상 서명 여부
    AgreeAmt: Integer;                 // 승인금액
    DCAmt: Integer;                    // 할인금액
    ICCardNo: AnsiString;              // IC카드번호
    PointCardNo: AnsiString;           // 포인트카드번호
    CustName: AnsiString;              // 고객명
    PointAgreeNo: AnsiString;          // 포인트승인번호
    PointOccur: Integer;               // 발생포인트
    PointAvail: Integer;               // 가용포인트
    PointTotal: Integer;               // 누적포인트
    PrintMsg: AnsiString;              // 오굿,파트너스 출력 메세지
    SignData: AnsiString;              // 보관 사인데이터
    SignLength: Integer;               // 보관 사인데이터 길이
  end;

  // 수표조회 전송정보
  TCheckSendInfo = record
    CheckNo: AnsiString;               // 수표번호
    BankCode: AnsiString;              // 발행은행코드
    BranchCode: AnsiString;            // 발행은행 영업점코드
    KindCode: AnsiString;              // 권종코드
    CheckAmt: Currency;                // 수표금액
    RegDate: AnsiString;               // 수표발행일
    AccountNo: AnsiString;             // 계좌일련번호(단위농협/수협일 경우)
  end;

  // 수표조회 응답정보
  TCheckRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransDateTime: AnsiString;         // 거래일자
  end;

  // 개시거래 응답정보
  TPosDownloadRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
  end;

  // 룰다운 응답정보
  TRuleDownRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    FileName: AnsiString;              // 룰파일명
    FileCount: Integer;                // 룰파일 갯수
    DataLen: Integer;                  // 룰데이타 길이
    DataInfo: AnsiString;              // 룰데이타 정보
  end;

  // 멤버십 전송정보
  TMembershipSendInfo = record
    Approval: Boolean;                 // 승인/취소
    MembershipType: TMembershipType;   // 멤버십 종류
    TradeType: TMembershipTradeType;   // 멤버십 거래구분
    SaleAmt: Integer;                  // 결제금액
    CardNo: AnsiString;                // 카드번호
    TrackTwo: AnsiString;              // 2Track Data
    KeyInput: Boolean;                 // 키인여부
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
    GoodsCode: AnsiString;             // SKT멤버쉽카드 거래시 상품코드
    PinBlock: AnsiString;              // 멤버쉽 카드 비밀번호 (plain text)
    ServiceCode : TSyrupCode;          // Syrup 서비스 Code  20150810 L.S.K 추가
    ServiceType : AnsiString;          // Syrup 서비스 타입  20150810 L.S.K 추가
  end;

  // 티머니 응답정보
  TTMoneyRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: Integer;                     // 응답코드
    Msg: AnsiString;                   // 응답메세지
    PSamID: AnsiString;                // PSAM ID
    PSamTransNo: AnsiString;           // PSAM 거래일련번호
    CardID: AnsiString;                // 카드 ID
    CardTransNo: AnsiString;           // 카드 거래일련번호
    BeforeAmt: Integer;                // 거래전 잔액
    PayAmt: Integer;                   // 거래 금액
    AfterAmt: Integer;                 // 거래후 잔액
    TransDateTime: AnsiString;         // 거래일시
    AgreeDate: AnsiString;             // 승인일시
    AgreeNo: AnsiString;               // 승인번호
    AgreeSign: AnsiString;             // 서명
  end;

  // Cashbee 전송정보
  TCashbeeSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    IsPay: Boolean;                    // 지불/충전 여부
    PayAmt: Currency;                  // 결제금액
    OrgTransDateTime: AnsiString;      // 원거래 일시 (yyyymmddhhnnss)
    OrgTransNo: AnsiString;            // 원거래 일련번호
    OrgSamID: AnsiString;              // 원거래 SAM ID
  end;

  // Cashbee 응답정보
  TCashbeeRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: Integer;                     // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransNo: AnsiString;               // 일련번호
    SamID: AnsiString;                 // SAM ID
    CardID: AnsiString;                // 카드 ID
    CardTransNo: AnsiString;           // 카드 거래일련번호
    SamTransNo: AnsiString;            // SAM 거래일련번호
    TransDateTime: AnsiString;         // 거래일시
    BeforeAmt: Integer;                // 거래전 잔액
    PayAmt: Integer;                   // 거래 금액
    AfterAmt: Integer;                 // 거래후 잔액
    AgreeNo: AnsiString;               // 승인번호
    AgreeSign: AnsiString;             // 서명
    OrgTransDateTime: AnsiString;      // 원거래 일시 (yyyymmddhhnnss)
    OrgTransNo: AnsiString;            // 원거래 일련번호
    OrgSamID: AnsiString;              // 원거래 SAM ID
  end;
  // 멤버십 응답정보
  TMembershipRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransDateTime: AnsiString;         // 거래일자
    AgreeNo: AnsiString;               // 승인번호
    BalgupsaCode: AnsiString;          // 발급사코드
    BalgupsaName: AnsiString;          // 발급사명
    CompCode: AnsiString;              // 매입사코드
    CompName: AnsiString;              // 매입사명
    KamaengNo: AnsiString;             // 가맹점번호
    ApplyAmt: Integer;                 // 할인 후 금액 / 잔액
    OccurPoint: Integer;               // 발생 포인트
    AblePoint: Integer;                // 가용 포인트
    AccruePoint: Integer;              // 누적 포인트
    DcAmt: Integer;                    // 할인 금액
    SyrupAmt: Integer;                 // Syrup  원금액
    DeviceTrKey : AnsiString;          // 연동서비스에 생성된 거래번호 20150810 L.S.K 추가
    ServiceTrKey : AnsiString;         // 연동서비스에 생성된 거래번호 20150810 L.S.K 추가
    ServiceCD : TSyrupCode;            // Syrup 서비스 Code  20150810 L.S.K 추가
    ServiceTP : AnsiString;            // Syrup 서비스 타입  20150810 L.S.K 추가
  end;
  // TRS 상세 상품
  TTRSDetailGoods = record
    GoodsCode: AnsiString;             // 상품코드
    GoodsName: AnsiString;             // 물품명
    SaleQty: Integer;                  // 수량
    SalePrice: Currency;               // 단가
    SaleAmt: Currency;                 // 금액
    SaleVat: Currency;                 // 부가세
  end;
  // GlobalTaxFree 상세 상품
  TGlobalTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // 일련번호
    DetailGVatGbn: AnsiString;         // 개별소비세구분
    DetailGoodsGbn: AnsiString;        // 물품코드
    DetailGoodsNm: AnsiString;         // 물품내용
    DetailQty: Integer;                // 수량
    DetailDanga: Currency;             // 단가
    DetailSaleAmt: Currency;           // 판매가격
    DetailVat: Currency;               // 부가가치세
    DetailGVat: Currency;              // 개별소비세
    DetailGEdVat: Currency;            // 교육세
    DetailGFmVat: Currency;            // 농어촌특별세
    DetailBigo: AnsiString;            // 비고
  end;
  // KTISTaxFree 상세 상품
  TKTISTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // 일련번호
    DetailGVatGbn: AnsiString;         // 개별소비세구분
    DetailGoodsGbn: AnsiString;        // 물품코드
//    DetailGoodsNm: AnsiString;         // 물품내용
    DetailGoodsNm: AnsiString;             // 물품내용
    DetailQty: Integer;                // 수량
    DetailDanga: Currency;             // 단가
    DetailSaleAmt: Currency;           // 판매가격
    DetailVat: Currency;               // 부가가치세
    DetailGVat: Currency;              // 개별소비세
    DetailGEdVat: Currency;            // 교육세
    DetailGFmVat: Currency;            // 농어촌특별세
    DetailBigo: AnsiString;            // 비고
  end;
  // KICCTaxFree 상세 상품
  TKICCTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // 일련번호
    DetailGVatGbn: AnsiString;         // 개별소비세구분
    DetailGoodsGbn: AnsiString;        // 물품코드
//    DetailGoodsNm: AnsiString;         // 물품내용
    DetailGoodsNm: AnsiString;             // 물품내용
    DetailQty: Integer;                // 수량
    DetailDanga: Currency;             // 단가
    DetailSaleAmt: Currency;           // 판매가격
    DetailVat: Currency;               // 부가가치세
    DetailGVat: Currency;              // 개별소비세
    DetailGEdVat: Currency;            // 교육세
    DetailGFmVat: Currency;            // 농어촌특별세
    DetailBigo: AnsiString;            // 비고
  end;
  // TRS(부가세환급) 전송정보
  TTRSSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    SumSaleAmt: Currency;              // 판매금액
    SumSaleVat: Currency;              // 부가세
    SumSaleQty: Integer;               // 판매수량
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
    TranKind: AnsiString;              // 거래구분 (신용카드:C 현금:M 복합:X)
    DetailGoodsList: array of TTRSDetailGoods; // 상세 상품 리스트
  end;
  // TRS(부가세환급) 응답정보
  TTRSRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransNo: AnsiString;               // 거래일련번호
    AgreeNo: AnsiString;               // 승인번호
    PurcNo: AnsiString;                // 구매일련번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    AgreeAmt: Currency;                // 승인금액
    NetRefuncAmt: Currency;            // 환급액
  end;
  // CubeRefund 전송정보
  TCubeRefundSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    IsRefund: Boolean;                 // True - 즉시환급 , False - 사후환급
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
    PassportKeyin: Boolean;            // 여권입력 유형 (True:Key-in, False: swipe)
    PassportInfo: AnsiString;          // 여권번호
    ReceiptNo: AnsiString;             // 영수증번호
    PayGubun: AnsiString;              // 결제구분(0:현금 1:신용 9:기타)
    RefundAgreeNo: AnsiString;         // 거래고유번호
    Nationality: AnsiString;           // 국적
    GuestName: AnsiString;             // 이름
    SaleAmt: Currency;
    DetailGoodsList: array of TTRSDetailGoods; // 상세 상품 리스트
  end;
  // CubeRefund 응답정보
  TCubeRefundRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransNo: AnsiString;               // 거래고유번호
    TransNoStore: AnsiString;          // 가맹점 거래고유번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    AgreeNo: AnsiString;               // 환급전표 발행번호
    PassportNo: AnsiString;            // 여권번호
    BuyersName: AnsiString;            // 구매자 성명
    BuyersNationality: AnsiString;     // 구매자 국적
    NetRefuncAmt: Currency;            // 환급액
    ToTalLimit: Currency;              // 기준한도금액
    RemainingLimit: Currency;          // 차감후한도
  end;
  // GlobalTaxFree 전송정보
  TGlobalTaxFreeSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    GtGbn: AnsiString;                 // 업무구분
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtSellTime: AnsiString;            // 판매년월일시
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotRefundAmt: Currency;            // 환급총액
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // 상세 상품 리스트
  end;
  // GlobalTaxFree 응답정보
  TGlobalTaxFreeRecvInfo = record
    Result: Boolean;                   // 성공여부
    GtGbn: AnsiString;                 // 업무구분
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtSellTime: AnsiString;            // 판매년월일시
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotRefundAmt: Currency;            // 환급총액
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // 상세 상품 리스트
  end;
  // KICCTaxFree 전송정보
  TKICCTaxFreeSendInfo = Record
    Approval: Boolean;                 // 승인/취소 여부
    IsRefund: Boolean;                 // 즉시환급 : True, 사후환급 : False
    KeyIn: Boolean;                    // KeyIn 여부
    GtGbn: AnsiString;                 // 업무구분 S: 조회, A: 승인
    ReaderInfo: Boolean;               // 리더기정보 T: 리더기 정보 있음, F: 정보 없음
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtOrgApprovalNo: AnsiString;       // 거래원승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtPosNo: AnsiString;               // 단말기 POS 번호
    GtSellTime: AnsiString;            // 판매년월일시
    GtOrgSellTime: AnsiString;         // 판매년월일시
    GtRcpTradeNo: AnsiString;          // 거래 고유 번호
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotSumVat: Currency;               // 부가세 합계
    TotRefundAmt: Currency;            // 환급총액
    TotCardAmt: Currency;              // 카드총금액
    TotCashAmt: Currency;              // 현금총금액
    TotECashAmt: Currency;             // 전자화폐총금액
    TotFreeAmt: Currency;              // 면세총금액
    TotCntSale: Integer;               // 판매총건수
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    ShopCd: AnsiString;                // 매장코드
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    RefundAmt: Currency;               // 즉시환급금액
    Port: Integer;                     // 통신포트
    SellerName: AnsiString;            // 판매자명
    SellerAddr: AnsiString;            // 판매자 주소
    SellerTelNo: AnsiString;           // 판매자 전화
    DetailGoodsList: array of TKICCTaxFreeDetailGoods; // 상세 상품 리스트
  end;
  // KICCTaxFree 응답정보
  TKICCTaxFreeRecvInfo = Record
    Result: Boolean;                   // 성공여부
    GtGbn: AnsiString;                 // 업무구분
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtSellTime: AnsiString;            // 판매년월일시
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotRefundAmt: Currency;            // 환급총액
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    ErrorCd: AnsiString;               // 에러코드
    RefundAmt: Currency;               // 즉시환급금액
    BeforeRefundAmt: Currency;         // 이전즉시환급금액
    AfterRefundAmt: Currency;          // 이후즉시환급금액
    DetailGoodsList: TKICCTaxFreeDetailGoods; // 상세 상품 리스트
    GtRcpTradeNo: AnsiString;

    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    TransNo: AnsiString;               // 거래일련번호
    PurcNo: AnsiString;                // 구매일련번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    AgreeAmt: Currency;                // 승인금액
  end;
  // KTISTaxFree 전송정보
  TKTISTaxFreeSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    IsRefund: Boolean;                 // 즉시환급 : True, 사후환급 : False
    KeyIn: Boolean;                    // KeyIn 여부
    GtGbn: AnsiString;                 // 업무구분 S: 조회, A: 승인
    ReaderInfo: Boolean;               // 리더기정보 T: 리더기 정보 있음, F: 정보 없음
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtOrgApprovalNo: AnsiString;       // 거래원승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtPosNo: AnsiString;               // 단말기 POS 번호
    GtSellTime: AnsiString;            // 판매년월일시
    GtOrgSellTime: AnsiString;         // 판매년월일시
    GtRcpTradeNo: AnsiString;          // 거래 고유 번호
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotSumVat: Currency;               // 부가세 합계
    TotRefundAmt: Currency;            // 환급총액
    TotCardAmt: Currency;              // 카드총금액
    TotCashAmt: Currency;              // 현금총금액
    TotECashAmt: Currency;             // 전자화폐총금액
    TotFreeAmt: Currency;              // 면세총금액
    TotCntSale: Integer;               // 판매총건수
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    ShopCd: AnsiString;                // 매장코드
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    RefundAmt: Currency;               // 즉시환급금액
    Port: Integer;                     // 통신포트
    DetailGoodsList: array of TKTISTaxFreeDetailGoods; // 상세 상품 리스트
  end;
  // KTISTaxFree 응답정보
  TKTISTaxFreeRecvInfo = record
    Result: Boolean;                   // 성공여부
    GtGbn: AnsiString;                 // 업무구분
    GtVersion: AnsiString;             // 전문버전
    GtDocCd: AnsiString;               // 문서코드
    GtSno: AnsiString;                 // 구매일련번호
    GtCancel: AnsiString;              // 구매취소여부
    GtApprovalNo: AnsiString;          // 거래승인번호
    GtBizNo: AnsiString;               // 판매자사업자번호
    GtTerminalId: AnsiString;          // 단말기ID
    GtSellTime: AnsiString;            // 판매년월일시
    TotQty: Integer;                   // 판매총수량
    TotSaleAmt: Currency;              // 판매총금액
    TotRefundAmt: Currency;            // 환급총액
    PayGbn: AnsiString;                // 결제유형
    CardNo: AnsiString;                // 신용카드번호
    ChCardGbn: AnsiString;             // 은련카드여부
    JuminNo: AnsiString;               // 주민등록번호
    PassportNm: AnsiString;            // 여권영문이름
    PassportNo: AnsiString;            // 여권번호
    PassportNationCd: AnsiString;      // 여권국가코드
    PassportSex: AnsiString;           // 여권성별
    PassportBirth: AnsiString;         // 여권생년월일
    PassportExpireDt: AnsiString;      // 여권만료일
    ResponseCd: AnsiString;            // 응답코드
    ResponseMsg: AnsiString;           // 응답메세지
    ShopNm: AnsiString;                // 매장명
    DetailCnt: Integer;                // 물품부반복횟수
    ExportExpirtDt: AnsiString;        // 반출유효기간
    RctNo: AnsiString;                 // 영수증번호
    Bigo: AnsiString;                  // 비고
    ErrorCd: AnsiString;               // 에러코드
    RefundAmt: Currency;               // 즉시환급금액
    BeforeRefundAmt: Currency;         // 이전즉시환급금액
    AfterRefundAmt: Currency;          // 이후즉시환급금액
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // 상세 상품 리스트
    GtRcpTradeNo: AnsiString;
  end;

  TKTISTaxFreePass = record
    PassportNo : AnsiString;                       // 여권정보(암호화)
    PassportNationCd : AnsiString;                 // 국가코드(3)
    PassportNm : AnsiString;                       // 이름
    PassportExpireDt : AnsiString;                 // 여권만료일
    PassportBirth : AnsiString;                    // 여권생일
    PassportSex : AnsiString;                      // 성별
    RcpTradeNo: AnsiString;                        // 거래고유번호
    TaxRefundBool : Boolean;
  end;

  TKICCTaxFreePass = record
    PassportNo : AnsiString;                       // 여권정보(암호화)
    PassportNationCd : AnsiString;                 // 국가코드(3)
    PassportNm : AnsiString;                       // 이름
    PassportExpireDt : AnsiString;                 // 여권만료일
    PassportBirth : AnsiString;                    // 여권생일
    PassportSex : AnsiString;                      // 성별
    RcpTradeNo: AnsiString;                        // 거래고유번호
    TaxRefundBool : Boolean;
  end;

  // MTIC 전송정보
  TMTICSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    VanCode: AnsiString;               // 가맹점코드
    SvcID: AnsiString;                 // 가맹점ID
    TransNo: AnsiString;               // 거래번호(20Byte)
    GoodsAmt: Currency;                // 상품금액
    BarCode: AnsiString;               // 바코드
    OrgAgreeNo: AnsiString;            // 원승인번호(취소시)
  end;
  // MTIC 응답정보
  TMTICRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    RemainAmt: Currency;               // 잔여한도
  end;
  // 빡센포인트 전송정보
  TBagxenSendInfo = record
    ServerIP: AnsiString;              // 서버 IP
    ServerPort: Integer;               // 서버 PORT
    TerminalID: AnsiString;            // 단말기ID (사업자번호)
    KeyIn: Boolean;                    // WCC
    TrackTwo: AnsiString;              // 2Track Data
    Password: AnsiString;              // 비밀번호
    SaleAmt: Currency;                 // 거래금액
    OrgAgreeNo: AnsiString;            // 원승인번호
    OrgAgreeDate: AnsiString;          // 원승인일자
  end;
  // 빡센포인트 응답정보
  TBagxenRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    AgreeNo: AnsiString;               // 승인번호
    Msg1: AnsiString;                  // 응답메세지1
    Msg2: AnsiString;                  // 응답메세지2
    Msg3: AnsiString;                  // 응답메세지3
    OccurPoint: Integer;               // 발생 포인트
    AblePoint: Integer;                // 가용 포인트
    AccruePoint: Integer;              // 누적 포인트
  end;
  // 밴 설정 정보
  TVanConfigInfo = record
    RealMode: Boolean;                 // 실모드/테스트모드
    HostIP: AnsiString;                // 호스트 IP
    HostPort: Integer;                 // 호스트 Port
    TerminalID: AnsiString;            // 단말기번호 TID
    SignPad: Boolean;                  // 서명패드 사용여부
    SignPort: Integer;                 // 서명패드 Port
    SignRate: Integer;                 // 서명패드 속도
    BizNo: AnsiString;                 // 사업자번호
    StrName: AnsiString;               // 매장명
    SerialNo: AnsiString;              // 일련번호
    Password: AnsiString;              // 비밀번호
    AreaCode: AnsiString;              // 지역코드
    TerminalSerialNo: AnsiString;      // 단말기 일련번호
    PartnerShipType: TPartnerShipType; // 오굿/파트너스 구분
    PosDownload: Boolean;              // PosDownload(개시)를 무조건하게 할지 여부
    SecureMode: Boolean;               // IC보안인증 모듈 사용여부
    CatTerminal: Boolean;              // IC보안인증 CAT 단말기 연동여부
    PaymentGateway:Boolean;            // PG(payment gateway) 모듈 사용여부
    HWSecure: Boolean;                 // MSR HW 보안 사용여부(Kis) / 금결원 단말기 연동
    MSRPort: Integer;                  // MSRPort(Kis) / 금결원 단말기 포트
    KocesDevice: TKocesDevice;         // KOCES SIGN DEVICE TYPE
    CashBeeID: AnsiString;             // 캐쉬비 TID
    ProgramCode: AnsiString;           // 프로그램 구분 (금결원용)
    ProgramVersion: AnsiString;        // 프로그램 버전 (금결원용)
    DebugLog: Boolean;                 // 디버그 로그 쓰기 여부
    NoSignUse5M: Boolean;              // 5만원 미만 사인 사용 유무
    SecureModeInit: Boolean;           // 초기값 설정
    CatPrintUse: Boolean;              // Cat단말기 프린트 사용 유무
    CatPrintPort: Integer;             // Cat단말기 프린트 포트
  end;
  // TRS 설정 정보
  TTRSConfigInfo = record
    RealMode: Boolean;                 // 실모드/테스트모드
    HostIP: AnsiString;                // 호스트 IP
    HostPort: Integer;                 // 호스트 Port
    TerminalID: AnsiString;            // 단말기번호 TID
    BizNo: AnsiString;                 // 사업자번호
    StrName: AnsiString;               // 매장명
    SellerName: AnsiString;            // 판매자명
    SellerAddr: AnsiString;            // 판매자 주소
    SellerTelNo: AnsiString;           // 판매자 전화
  end;
  // CubeRefund 설정 정보
  TCubeRefundConfigInfo = record
    RealMode: Boolean;                 // 실모드/테스트모드
    TerminalID: AnsiString;            // 가맹점번호
    BizNo: AnsiString;                 // 사업자번호
  end;
  TGlobalTaxFreeConfigInfo = record
    TaxFreeIp: AnsiString;
    TaxFreePort: Integer;
    Gubun: AnsiString;                 // T: 택스프리승인, S: 개시
  end;
  TKTISTaxFreeConfigInfo = record
    RealMode: Boolean;                 // 실모드/테스트모드
    TaxFreeIp: AnsiString;
    TaxFreePort: Integer;
    TerminalID: AnsiString;            // 가맹점번호
    Gubun: AnsiString;                 // T: 택스프리승인, S: 개시
  end;
  TKICCTaxFreeConfigInfo = record
    RealMode: Boolean;                 // 실모드/테스트모드
    HostIP: AnsiString;                // 호스트 IP
    HostPort: Integer;                 // 호스트 Port
    TerminalID: AnsiString;            // 단말기번호 TID
    BizNo: AnsiString;                 // 사업자번호
    StrName: AnsiString;               // 매장명
    SellerName: AnsiString;            // 판매자명
    SellerAddr: AnsiString;            // 판매자 주소
    SellerTelNo: AnsiString;           // 판매자 전화
  end;

  // KIS 영수증 쿠폰 응답정보
  TKisRcpCouponRecvInfo = record
    Result: Boolean;
    Msg: string;
  //  AdImgEnable: Boolean;
    AdImgName: string;
//    AdTextEnable: Boolean;
    AdTextName: string;
//    EventImgEnable: Boolean;
    EventImgName: string;
//    EventTextEnable: Boolean;
    EventTextName: string;
  end;

  // 위쳇 전송정보
  TWxPaySendInfo = record
    JunmunType: AnsiString;            // 전문타입     승인요청:52, 승인결과조회요청:53, 취소요청:54, 취소결과조회요청: 55
    VanId: AnsiString;                 // 제이티넷에서 부여한 ID
    PosNo: AnsiString;                 // 포스번호
    ScanCd: AnsiString;                // 바코드 scan 값
    SendDt: AnsiString;                // 전문생성일자 yyyymmddhhnnss
    AgreeNo: AnsiString;               // 승인번호
    OrgSendDt: AnsiString;             // 원거래승인일시
    OrgAgreeNo: AnsiString;            // 원거래승인번호
    CurrencyType: AnsiString;          // 결제통화
    AgreeAmt: Currency;                // 결제금액
    GoodsCd: AnsiString;               // 상품코드
    GoodsNm: AnsiString;               // 상품명
    GoodsExp: AnsiString;              // 상품설명
    CloseTime: AnsiString;             // 거래마감시간
    GoodsTag: AnsiString;              // 상품 Tag  미사용
    Reserved: AnsiString;              // Reserved; 미사용
  end;

  // 위쳇 수신정보
  TWxPayRcvInfo = record
    JunmunType: AnsiString;            // 전문타입     승인요청:52, 승인결과조회요청:53, 취소요청:54, 취소결과조회요청: 55
    VanId: AnsiString;                 // 제이티넷에서 부여한 ID
    PosNo: AnsiString;                 // 포스번호
    RtnNo: AnsiString;                 // 응답코드 0000:승인응답, 0001:결과조회, 0002:회선장애
    RtnMsg: AnsiString;                // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    AgreeState: AnsiString;            // 결제상태
    AgreeTime: AnsiString;             // 결제시간  yyyymmddhhnnss
    GoodsNm: AnsiString;               // 상품명
    CurrencyType: AnsiString;          // 결제통화
    AgreeAmt: Currency;                // 결제금액
    DeviceId: AnsiString;              // 결제단말기번호
    WeChatNo: AnsiString;              // 위쳇고유번호
    GateWayNo: AnsiString;             // 게이트웨이고유번호
    Reserved: AnsiString;              // Reserved  미사용
  end;


  //위챗 전송정보
  TWeChatPaySendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    VanId: AnsiString;                 // PG ID
    StoreId: AnsiString;               // 상점 ID
    StorePw: AnsiString;               // Key PassWord
    GoodsNm: AnsiString;               // 상품명
    AgreeAmt: Currency;                // 결제금액
    OrderNum: AnsiString;              // 주문번호
    BuyerName: AnsiString;             // 구매자 이름
    BuyerEmail: AnsiString;            // 구매자 이메일
    BuyerTel: AnsiString;              // 구매자 전화번호
    PayCurrency: AnsiString;           // 통화단위
    PayMethod: AnsiString;             // 결제수단(CARD, CASH, VBank, TPAY)
    URL: AnsiString;                   // 가맹점 홈페이지
    ServiceCode: AnsiString;           // 서비스 코드 W 고정
    WechAuthCode: AnsiString;          // 바코드 인증번호
    WechCompanyBizNo: AnsiString;      // 서브가맹점 사업자번호
    Tid: AnsiString;                   // 취소시 필요한 TID
    MKey: Boolean;                     // 대표키 설정 여부
    MergyLog: Boolean;                 // 대표키 설정 로그 통합 여부
    Merchantreserved1: AnsiString;     // 예비필드1
    Merchantreserved2: AnsiString;     // 예비필드2
    Merchantreserved3: AnsiString;     // 예비필드3
    Debug: Boolean;                    // 로그 모드 True(상세 로그)
  end;

  //위챗 수신정보
  TWeChatPayRcvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 웅답코드
    Msg: AnsiString;                   // 응답메세지
    Tid: AnsiString;                   // 거래취소시 필요한 tid
    AgreeAmt: Currency;                // 결제금액
    AgreeNo: AnsiString;               // 승인번호
    TransDate: AnsiString;             // 승인날짜
    TransDateTime: AnsiString;         // 숭인시간
    TransactionID: AnsiString;         // 주문번호
    ReqCurrency: AnsiString;           // 요청통화코드
    RateExchange: AnsiString;          // 환율
    ReqPrice: AnsiString;              // 환율계산금액
    State: AnsiString;                 // 조회 결과   0: 승인, 1: 취소, 2: 결제진행중, 9: 거래없음
  end;

  TVanApprove = class;
  TLog = class;
  TTMoney = class;
  TTRS = class;
  TCubeRefund = class;
  TGlobalTaxFree = class;
  TKTISTaxFree = class;
  TKICCTaxFree = class;
  TCashbee = class;
  TWxPay = class;
  TWeChatPay = class;

  TMSCallbackEvent = procedure(ACardNo: string) of object;
  TICCallbackEvent = procedure(ACardNo, AEmvInfo: string) of object;

  // 밴 모듈
  TVanModul = class
  private
    FVanType: TVanCompType;
    FConfig: TVanConfigInfo;
    // 선 할인금액 (오굿,파트너스일때 사용)
    FPreDCAmt: Integer;
    FMSCallbackEvent: TMSCallbackEvent;
    FICCallbackEvent: TICCallbackEvent;
    procedure SetVanType(const Value: TVanCompType);
    function GetVanName(AVanType: TVanCompType): string;
    function GetCurrVanName: string;
    procedure SetPartnerShipType(const Value: TPartnerShipType);
    procedure SetRealMode(const Value: Boolean);
    procedure SetAreaCode(const Value: AnsiString);
    procedure SetTerminalSerialNo(const Value: AnsiString);
    procedure SetBizNo(const Value: AnsiString);
    procedure SetHostIP(const Value: AnsiString);
    procedure SetHostPort(const Value: Integer);
    procedure SetPassword(const Value: AnsiString);
    procedure SetSerialNo(const Value: AnsiString);
    procedure SetSignPad(const Value: Boolean);
    procedure SetSignPort(const Value: Integer);
    procedure SetSignRate(const Value: Integer);
    procedure SetStrName(const Value: AnsiString);
    procedure SetTerminalID(const Value: AnsiString);
    procedure SetPosDownload(const Value: Boolean);
    procedure SetSecureMode(const Value: Boolean);
    procedure SetCatTerminal(const Value: Boolean);
    procedure SetPaymentGateway(const Value: Boolean);
    procedure SetHWSecure(const Value: Boolean);
    procedure SetMSRPort(const Value: Integer);
    procedure SetKocesDevice(const Value: TKocesDevice);
    procedure BeforePartnerShipProc(var AInfo: TCardSendInfo);
    procedure AfterPartnerShipProc(AInfo: TCardSendInfo; var APrintMsg: AnsiString; var AAgreeAmt, ADCAmt: Integer);
    function CouponAfterProc(AUse:Boolean; ALoyaltyResult: AnsiString): AnsiString;
    procedure SetCashBeeID(const Value: AnsiString);
    procedure SetProgramCode(const Value: AnsiString);
    procedure SetProgramVersion(const Value: AnsiString);
    procedure SetDebugLog(const Value: Boolean);
    procedure SetNoSignUse5M(const Value: Boolean);
    procedure SetSecureModeInit(const Value: Boolean);
    procedure SetCatPrintUse(const Value: Boolean);
    procedure SetCatPrintPort(const Value: Integer);
  public
    FLog: TLog;
    // 기본밴
    MainVan: TVanApprove;
    // KTIS TaxFree
    KTISTaxFree: TKTISTaxFree;
    // KICC TaxFree
    KICCTaxFree: TKICCTaxFree;
    constructor Create; virtual;
    destructor Destroy; override;
    // 서명 이미지 명
    function SignImageName: AnsiString;
    // 보안모듈서비스가 실행되어 있는지 찾는다.
    //function FindSecureService: Boolean;
    // 개시거래
    function CallPosDownload : TPosDownloadRecvInfo;
    // 신용카드 승인
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
    // 현금영수증 승인
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
    // 수표조회
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
    // 서명패드 사인입력
    function CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean;
    // 핀패드 입력
    function CallPinPad(out ARetSignData: AnsiString): Boolean;
    // 핀패드 입력 취소
    procedure CallPinCancel;
    // 은련 카드 승인
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
    // 로열티 쿠폰 조회 및 사용
    function CallCoupon(AInfo: TCardSendInfo): TCardRecvInfo;
    // 로열티 쿠폰 사용
    function CallCouponUse(AInfo: TCardSendInfo): TCardRecvInfo;
    // 룰 다운로드
    function CallRuleDownload: TRuleDownRecvInfo;
    // 멤버십 카드 승인
    function CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo;
    // 현금IC 승인
    function CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo;
    // PayOn
    function CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean;
    function CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo;
    // 통화선택 요청
    function CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetCurrencyData: AnsiString): Boolean;
    // IC 리더기 제어 (IC 리더기)
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
    // MS Swipe 요청 (IC 리더기)
    function CallMSR(AGubun: AnsiString; out ACardNo,ADecrypt, AEncData: AnsiString): Boolean;
    // MS Swipe 요청 (금결원 단말기)
    function CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean;
    // IC 입력 요청 (금결원 단말기)
    function CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo: AnsiString; out AEmvInfo: AnsiString): Boolean;
    // 단말기 비동기 모드 요청
    function SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString): Boolean;
    // 프린터 출력
    function PrintOut(APrintData: AnsiString): Boolean;
    // 돈통 오픈
    function CashDrawOpen: Boolean;
    // 위쳇페이 승인
    function WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo;

    // 전체 환경 설정 적용 처리
    procedure ApplyConfigAll;
    // VAN사
    property VanType: TVanCompType read FVanType  write SetVanType default vctNone;
    property VanName: string read GetCurrVanName;
    // 오굿/파트너스 구분
    property PartnerShipType: TPartnerShipType read FConfig.PartnerShipType  write SetPartnerShipType default pstNone;
    // 실모드/테스트모드
    property RealMode: Boolean read FConfig.RealMode write SetRealMode;
    // 호스트 IP
    property HostIP: AnsiString read FConfig.HostIP write SetHostIP;
    // 호스트 Port
    property HostPort: Integer read FConfig.HostPort write SetHostPort;
    // 단말기번호 TID
    property TerminalID: AnsiString read FConfig.TerminalID write SetTerminalID;
    // 서명패드 사용여부
    property SignPad: Boolean read FConfig.SignPad write SetSignPad;
    // 서명패드 Port
    property SignPort: Integer read FConfig.SignPort write SetSignPort;
    // 서명패드 속도
    property SignRate: Integer read FConfig.SignRate write SetSignRate;
    // 사업자번호
    property BizNo: AnsiString read FConfig.BizNo write SetBizNo;
    // 매장명
    property StrName: AnsiString read FConfig.StrName write SetStrName;
    // 일련번호
    property SerialNo: AnsiString read FConfig.SerialNo write SetSerialNo;
    // 비밀번호
    property Password: AnsiString read FConfig.Password write SetPassword;
    // 지역코드
    property AreaCode: AnsiString read FConfig.AreaCode write SetAreaCode;
    // 단말기 일련번호
    property TerminalSerialNo: AnsiString read FConfig.TerminalSerialNo write SetTerminalSerialNo;
    // PosDownload(개시)
    property PosDownload: Boolean read FConfig.PosDownload write SetPosDownload;
    // IC보안인증 모듈 사용여부
    property SecureMode: Boolean read FConfig.SecureMode write SetSecureMode;
    // IC보안인증 CAT단말기 연동여부
    property CatTerminal: Boolean read FConfig.CatTerminal write SetCatTerminal;
    // PG 모듈 사용여부
    property PaymentGateway: Boolean read FConfig.PaymentGateway write SetPaymentGateway;
    // MSR HW 보안 사용여부
    property HWSecure: Boolean read FConfig.HWSecure write SetHWSecure;
    // MSRPort
    property MSRPort: Integer read FConfig.MSRPort write SetMSRPort;
    // KOCES SIGN PAD DEVICE
    property KocesDevice: TKocesDevice read FConfig.KocesDevice write SetKocesDevice;
    // 캐쉬비 TID
    property CashBeeID: AnsiString read FConfig.CashBeeID write SetCashBeeID;
    // 프로그램 구분 (금결원용)
    property ProgramCode: AnsiString read FConfig.ProgramCode write SetProgramCode;
    // 프로그램 버전 (금결원용)
    property ProgramVersion: AnsiString read FConfig.ProgramVersion write SetProgramVersion;
    // 디버깅 로그 쓰기 여부
    property DebugLog: Boolean read FConfig.DebugLog write SetDebugLog;
    // 5만원 미만 사인유무
    property NoSignUse5M: Boolean read FConfig.NoSignUse5M write SetNoSignUse5M;
    // IC보안 초기값 호출 사용 유무
    property SecureModeInit: Boolean read FConfig.SecureModeInit write SetSecureModeInit;
    // Cat단말기 프린트 사용 유무
    property CatPrintUse: Boolean read FConfig.CatPrintUse write SetCatPrintUse;
    // Cat단말기 프린트 포트
    property CatPrintPort: Integer read FConfig.CatPrintPort write SetCatPrintPort;
    // 환경설정
    property VanConfig: TVanConfigInfo read FConfig;
    // 금결원 콜백 이벤트
    property OnMSCallBackEvent: TMSCallbackEvent read FMSCallbackEvent write FMSCallbackEvent;
    property OnICCallBackEvent: TICCallBackEvent read FICCallBackEvent write FICCallBackEvent;
  end;

  // 밴 승인 상위 모듈
  TVanApprove = class
  private
    FMessageForm: TForm;
  protected
    procedure ShowMessageForm(AMsg: string; AButtonHide: Boolean = False; ATimeOutSeconds: integer=0);
    procedure HideMessageForm;
    function ShowAIDSelectForm(AAIDCount: Integer; AAIDList: AnsiString; out ASelectAIDIndex: Integer): Boolean;
    // 메세지 폼에서 취소 버튼을 눌렀을때 발생하는 이벤트
    procedure EventMessageFormCancelClick(Sender: TObject); virtual;
  public
    Config: TVanConfigInfo;
    Log: TLog;
    procedure DoMessageFormCancelClick;
    // 개시 처리 (가맹점 다운로드)
    function CallPosDownload: TPosDownloadRecvInfo; virtual;
    // 신용카드 승인
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // 현금영수증 승인
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo; virtual; abstract;
    // 수표조회
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo; virtual; abstract;
    // 사인패드 서명입력 호출
    function CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean; virtual; abstract;
    // 핀패드 입력 호출
    function CallPinPad(out ARetData: AnsiString): Boolean; virtual; abstract;
    // 핀패드 초기화
    procedure CallPinCancel; virtual; abstract;
    // 은련 카드 승인
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // 쿠폰조회,사용 (AUse:조회,사용여부)
    function CallCoupon(AUse: Boolean; AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // 룰파일 다운로드
    function CallRuleDownload: TRuleDownRecvInfo; virtual; abstract;
    // 멤버십 카드 승인
    function CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo; virtual; abstract;
    // 현금IC 카드
    function CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // PayOn
    function CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean; virtual; abstract;
    function CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // 통화선택 요청
    function CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetData: AnsiString): Boolean; virtual; abstract;
    // IC 리더기 제어 (IC 리더기)
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // MS Swipe 요청 (IC 리더기)
    function CallMSR(AGubun: AnsiString; out ACardNo, ADecrypt, AEncData: AnsiString): Boolean; virtual; abstract;
    // MS Swipe 요청
    function CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean; virtual; abstract;
    // IC 입력 요청
    function CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo: AnsiString; out AEmvInfo: AnsiString): Boolean; virtual; abstract;
    // 단말기 비동기 모드 요청
    function SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString; ACallbackMS, ACallbackIC: Pointer): Boolean; virtual; abstract;
    // 프린터 출력
    function PrintOut(APrintData: AnsiString): Boolean; virtual; abstract;
    // 위쳇페이 승인
    function WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
  end;

  // IC보안 인증용 CAT 단말기 연동 상위 모듈
  TVanCatApprove = class(TVanApprove)
  private
  protected
    FComPort: TComPort;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function PrintOut(APrintData: AnsiString): Boolean; virtual;
    function CashDrawOpen: Boolean; virtual;
  end;

  // T-Money 상위 모듈
  TTMoney = class
  private
    procedure SetCofig(const Value: TVanConfigInfo);
  protected
    Log: TLog;
    FConfig: TVanConfigInfo;
  published
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // 기본정보 설정 LogOn
    function ExecInit(out AInfo: AnsiString): Boolean; virtual;
    // 잔액 조회 (잔액, 카드ID)
    function ExecGetMoney(out AAmt: Integer; out ACardID: AnsiString): Boolean; virtual;
    // 지불처리 (지불금액, 결과정보)
    function ExecPayProc(APayAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // 반품충전 (지불금액, 원거래데이타, 결과정보)
    function ExecCancelProc(APayAmt: Integer; AOrgPayData: TTMoneyRecvInfo; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // 충전 거래 (충전금액, 결과정보)
    function ExecChargeProc(AChargeAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // 충전 취소 (충전금액, 결과정보)
    function ExecChargeCancelProc(AChargeAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // Host 재전송
    procedure HostReSendData; virtual;
    // 밴설정 정보
    property Config: TVanConfigInfo read FConfig write SetCofig;
  end;

  // TRS 상위 모듈
  TTRS = class
  protected
    Log: TLog;
  public
    Config: TTRSConfigInfo;
    constructor Create; virtual;
    destructor Destroy; override;
    // 승인
    function CallExec(AInfo: TTRSSendInfo): TTRSRecvInfo; virtual;
  end;

  // CubeRefund
  TCubeRefund = class
  private
    FConfig: TCubeRefundConfigInfo;
    function GetErrorMsg(ACode: Integer): AnsiString;
    procedure SetConfig(AValue: TCubeRefundConfigInfo);
    // 전송 승인전문 처리
    function MakeSendData(AInfo: TCubeRefundSendInfo): AnsiString;
    // 전송 취소전문 처리
    function MakeSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
    function MakeRefuncSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
    // 응답 승인전문 처리
    function MakeRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
    function MakeRefundRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
    // 응답 취소전문 처리
    function MakeRecvCancelData(ARecvData: AnsiString): TCubeRefundRecvInfo;
    function DLLExec(ASendData: AnsiString; out ARecvData: AnsiString; ARefund: Boolean = False): Boolean;
    function DLLMaxRefundExec(ASendData: AnsiString): Currency;
    function CubeAES(AData: AnsiString; AGubun: Boolean; out AResult: AnsiString): Boolean;
    function MakeMaxRefund(AInfo: TCubeRefundSendInfo): Boolean;
  protected
    Log: TLog;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // 승인
    function CallExec(AInfo: TCubeRefundSendInfo): TCubeRefundRecvInfo;
    property Config: TCubeRefundConfigInfo read FConfig write SetConfig;
  end;

  TGlobalTaxFree = class
  private
    FConfig: TGlobalTaxFreeConfigInfo;
    function GetErrorMsg(ACode: AnsiString): AnsiString;
    procedure SetConfig(AValue: TGlobalTaxFreeConfigInfo);
    // 전송 승인전문 처리
    function MakeSendData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
    // 전송 개시전문 처리
    function MakeSendStartData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
    // 응답 승인전문 처리
    function MakeRecvData(ARecvData: AnsiString): TGlobalTaxFreeRecvInfo;
    // 응답 개시전문 처리
    function MakeRecvStartData(ARecvData: AnsiString): TGlobalTaxFreeRecvInfo;
    function DLLExec(AGubun, ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
    Log: TLog;
  public
    ScanCancel: Boolean;
    constructor Create; virtual;
    destructor Destroy; override;
    function CallExec(AInfo: TGlobalTaxFreeSendInfo): TGlobalTaxFreeRecvInfo;
    function CallPassportScan(out AInfo: TGlobalTaxFreeSendInfo): AnsiString;
    property Config: TGlobalTaxFreeConfigInfo read FConfig write SetConfig;
  end;

  TKICCTaxFree = class(TVanApprove)
  private
    IdTaxClient: TIdTCPClient;
    FConfig: TKICCTaxFreeConfigInfo;
    procedure SetConfig(AValue: TKICCTaxFreeConfigInfo);
    function GetErrorMsg(ACode: Integer): AnsiString;
    function DLLExec(ATrNo, ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function MakeSendData(AInfo: TKICCTaxFreeSendInfo): AnsiString;
    function MakeRecvData(ARecvData: AnsiString; ARefund: Boolean = False): TKICCTaxFreeRecvInfo;
    function GetParsingValue(ACode, ARecvData: string): string;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function CallExec(AInfo: TKICCTaxFreeSendInfo): TKICCTaxFreeRecvInfo;
    property Config: TKICCTaxFreeConfigInfo read FConfig write SetConfig;
  end;

  TKTISTaxFree = class(TVanApprove)
  private
    IdTaxClient: TIdTCPClient;
    FConfig: TKTISTaxFreeConfigInfo;
    function GetErrorMsg(ACode: AnsiString): AnsiString;
    procedure SetConfig(AValue: TKTISTaxFreeConfigInfo);
    // 전송 승인전문 처리
    function MakeSendData(AInfo: TKTISTaxFreeSendInfo): AnsiString;
    // 응답 승인전문 처리
    function MakeRecvData(ARecvData: AnsiString; ARefund: Boolean = False): TKTISTaxFreeRecvInfo;
    function DLLExec(AGubun, ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
    Log: TLog;
  public
    ScanCancel: Boolean;
    constructor Create; virtual;
    destructor Destroy; override;
    function CallExec(AInfo: TKTISTaxFreeSendInfo): TKTISTaxFreeRecvInfo;
    property Config: TKTISTaxFreeConfigInfo read FConfig write SetConfig;
  end;

  // MTIC 모듈
  TMtic = class
  private
    class function GetErrorMsg(ACode: Integer): AnsiString;
  public
    // MTIC 결제를 처리한다.
    class function ExecPayProc(ASendInfo: TMTICSendInfo): TMTICRecvInfo;
  end;

  // 캐시비 상위 모듈
  TCashbee = class
  private
  protected
    Log: TLog;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // 카드 잔액 조회 (카드잔액, 카드ID)
    function GetCardMoney(out ACardAmt: Integer; out ACardID: AnsiString): Boolean; virtual;
    // LSAM 잔액 조회 (SAM잔액, SAM ID)
    function GetSamMoney(out ASamAmt: Integer; out ASamID: AnsiString): Boolean; virtual;
    // 기본정보 설정
    function ExecInit: Boolean; virtual;
    // 지불처리 (전송정보, 결과데이타)
    function ExecPayProc(ASendInfo: TCashbeeSendInfo): TCashbeeRecvInfo; virtual;
    // 예치금 충전
    function ExecSamSaveAuth: TCashbeeRecvInfo; virtual;
  end;

  // 위챗 상위 모듈
  TWxPay = class
  private
  protected
    Log: TLog;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function WeChatSetInfo(ATcpAddr: AnsiString; ATcpPortNo, ASerialPortNo, ASerialRate: Integer): Boolean; virtual;
    function WeChatQrBarCode(out ABarCd: string): Boolean; virtual;
    function WeChatApproval(AInfo: TWxPaySendInfo; out ARcvInfo: TWxPayRcvInfo): Boolean; virtual;
    function WeChatCancelApproval(AInfo: TWxPaySendInfo; out ARcvInfo: TWxPayRcvInfo): Boolean; virtual;
  end;

  // 위쳇페이 상위 모듈
  TWeChatPay = class(TVanApprove)
  private
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function CallWeChat(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean; virtual;
    function CallCancel(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean; virtual;
    function CallSearch(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean; virtual;
  end;

  // 거래구분
  TBagxenType = (btSave, btSaveCancel, btUse, btUseCancel, btInquiry);
  // 빡센포인트 모듈
  TBagxen = class
  private
    class function MakeSendData(AType: TBagxenType; ASendInfo: TBagxenSendInfo): AnsiString;
    class function MakeRecvData(ARecvData: AnsiString): TBagxenRecvInfo;
    class function ExecProc(AServerIP: AnsiString; AServerPort: Integer; ASendData: AnsiString): TBagxenRecvInfo;
    class function SendData(AServerIP: AnsiString; AServerPort: Integer; ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    class function GetErrorMsg(ACode: Integer): AnsiString;
  public
    class function PointSave(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
    class function PointSaveCancel(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
    class function PointUse(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
    class function PointUseCancel(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
    class function PointInquiry(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
  end;

  TKisRcpCoupon = class
  private

  public
    // 영수증 쿠폰 정보를 가져온다.
    class function ExecRcpCoupon(ARealMode: Boolean; ACatID, ATranCode, AAuthNo: AnsiString; ATranAmt: Currency): TKisRcpCouponRecvInfo;
  end;

  // 로그 정보 종류 (정보성, 오류, 디버그용, 시작, 끝)
  TLogType = (ltInfo, ltError, ltDebug, ltBegin, ltEnd);
  // 로그 처리
  TLog = class
  private
    FSecureMode: Boolean;

    class procedure WriteLogFile(AMessage: AnsiString);
  public
    DebugLog: Boolean;
    constructor Create; virtual;
    destructor Destroy; override;
    class procedure Write(AMessage: AnsiString); overload;
    procedure Write(ALogType: TLogType; AMessage: array of Variant); overload;
    procedure Write(ALogType: TLogType; AMessage: AnsiString); overload;
    property SecureMode: Boolean read FSecureMode write FSecureMode;
  end;

var
  FLogDir: string;

  function ShowQuestionForm(AMsg: string): Boolean;
  function ShowQuestionForm2(AMsg: string; out AReturnValue: AnsiString; out AErrMsg: Ansistring): Boolean;

const
  VAN_MODUL_VERSION  = '2016.1.22.1';
  MSG_ERR_DLL_LOAD   = ' 파일을 불러올 수 없습니다.';
  MSG_ERR_TRANS      = '전문을 송수신 할 수 없습니다.';
  MSG_SOLBIPOS       = 'Solbipos POS System';
  MSG_SOLBIPOS_SHORT = 'SOLBIPOS';
  LOG_DIRECTORY      = 'VanLog';

  KICC_TRS_DLL_NAME = 'Kicc.dll';


  SERVICE_GUBUN_KB = 'M';
  SERVICE_GUBUN_BC = 'B';

  IC_READER_WORK_INIT        = 0; // IC 리더기 초기화
  IC_READER_WORK_STATUS      = 1; // IC 리더기 상태 확인 (버전 정보)
  IC_READER_WORK_VERIFY      = 2; // IC 리더기 무결성 체크
  IC_READER_WORK_EVENT_START = 3; // IC 리더기 이벤트 감지 시작
  IC_READER_WORK_EVENT_STOP  = 4; // IC 리더기 이벤트 감지 중지
  IC_READER_WORK_AUTH_KEY_HW = 5; // IC 리더기 인증키 H/W
  IC_READER_WORK_AUTH_KEY_SW = 6; // IC 리더기 인증키 S/W

  STX              = #2;   // Start of Text
  ETX              = #3;   // End of Text
  EOT              = #4;   // End of Transmission
  ENQ              = #5;   // ENQuiry
  ACK              = #6;   // ACKnowledge
  NAK              = #$15; // Negative Acknowledge (#21)
  FS               = #$1C; // Field Separator (#28)
  CR               = #13;  // Carriage Return

  Cash_50000 = 50000;      // 5만원

  SERVER_IP_KT_TEST  = '220.95.216.243';
  SERVER_IP_KT_REAL  = '220.95.216.237';
  SERVER_PORT_KT     = 35403;
  SERVER_PORT_KT_TEST= 35404;

  SERVER_IP_KICC_TEST  = '203.233.72.55';
  SERVER_IP_KICC_REAL  = '203.233.72.21';
  SERVER_PORT_KICC_REAL= 15700;
  SERVER_PORT_KICC_TEST= 15200;

var
  VanModul: TVanModul;
  SelfVanModul: TVanModul;

implementation

uses
  WinSvc, IniFiles,
  uSBVanKFTC,
  uSBVanFunctions, uXGMessageForm, uXGQuestionForm, uXGQuestionForm2, Dialogs;

type
  TKicc_Approval = function (AReqType: Integer; AReqMsg: PAnsiChar; AReqMsgLen: Integer; ASign: PAnsiChar; AEmv: PAnsiChar;
         		                 AResType: Integer; AResMsg: PAnsiChar; AErrMsg: PAnsiChar; AKiccIP: PAnsiChar; AKiccPort: Integer; ASecure: Integer; ARID: PAnsiChar; ATrNo: PAnsiChar): Integer; stdcall;

{ TVanModul }

constructor TVanModul.Create;
begin
  FLog := TLog.Create;
  KTISTaxFree := TKTISTaxFree.Create;
  KICCTaxFree := TKICCTaxFree.Create;
  RealMode := True;
  PartnerShipType := pstNone;
  SecureMode := False;
  CatTerminal := False;
  FConfig.NoSignUse5M := False;
  FConfig.SecureModeInit := False;
  FConfig.CatPrintUse := True;

  {$IF DEFINED(DEBUG)}
  FLog.Write(ltInfo, ['VanModul Start', 'Debug', 'Version', VAN_MODUL_VERSION]);
  {$ELSE}
  FLog.Write(ltInfo, ['VanModul Start', 'Release', 'Version', VAN_MODUL_VERSION]);
  {$IFEND}
end;

destructor TVanModul.Destroy;
begin
  FLog.Write(ltInfo, ['VanModul End', '']);
  if MainVan <> nil then
    MainVan.Free;
  FLog.Free;
  KTISTaxFree.Free;
  KICCTaxFree.Free;

  inherited;
end;

function TVanModul.SignImageName: AnsiString;
begin
  case VanType of
    vctNICE : Result := 'NiceSign.bmp';
    vctStarVAN : Result := 'temp.bmp';
    vctSPC : Result := 'SignImg.bmp';
    vctKFTC : Result := '서명이미지.bmp';
    vctKOCES : Result := 'outfile.bmp';
    vctJTNet: Result := 'JTNET_SIGN.bmp';
    vctFDIK: Result := 'FDK_sign.bmp';
  else
    Result := 'sign.bmp';
  end;
end;

function TVanModul.WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;

  //  FLog.Write(ltBegin, ['위쳇페이', ['']]);
  try
    if MainVan = nil then
    begin
      Result.Result := False;
      Result.Msg := 'Van사가 설정되어 있지 않습니다.';
      Exit;
    end;

    Result := MainVan.WechatExecPayProc(AInfo);

  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.WechatExecPayProc', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['위쳇 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', IntToStr(Result.AgreeAmt)]);
end;

{function ServiceGetStatus(sMachine, sService: string): DWORD;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwStat: DWORD;
begin
  dwStat := DWORD(-1);
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);
  if schm > 0 then
  begin
    schs := OpenService(schm, PChar(sService), SERVICE_QUERY_STATUS);
    if schs > 0 then
    begin
      if QueryServiceStatus(schs, ss) then
      begin
        dwStat := ss.dwCurrentState;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := dwStat;
end;

function TVanModul.FindSecureService: Boolean;
begin
  // 소프트 포럼
  if ServiceGetStatus('', 'POS Security') = 4 then
  begin
    Result := True;
    Exit;
  end;
  // 소프트캠프
  if ServiceGetStatus('', 'Service For POS Security') = 4 then
    Result := True
  else
    Result := False;
end;}

procedure TVanModul.SetVanType(const Value: TVanCompType);
begin
  FVanType := Value;
end;

function TVanModul.GetVanName(AVanType: TVanCompType): string;
begin
  case AVanType of
    vctKFTC    : Result := 'KFTC';
    vctKICC    : Result := 'KICC';
    vctKIS     : Result := 'KIS';
    vctFDIK    : Result := 'FDIK';
    vctKOCES   : Result := 'KOCES';
    vctKSNET   : Result := 'KSNET';
    vctJTNet   : Result := 'JT-NET';
    vctNICE    : Result := 'NICE';
    vctSmartro : Result := 'Smartro';
    vctKCP     : Result := 'KCP';
    vctStarVAN : Result := 'StarVAN';
    vctKOVAN   : Result := 'KOVAN';
    vctSPC     : Result := 'SPC Networks';
  end;
end;

function TVanModul.GetCurrVanName: string;
begin
  Result := GetVanName(FVanType);
end;

procedure TVanModul.SetPartnerShipType(const Value: TPartnerShipType);
begin
  FConfig.PartnerShipType := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetRealMode(const Value: Boolean);
begin
  FConfig.RealMode := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetHostIP(const Value: AnsiString);
begin
  FConfig.HostIP := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetHostPort(const Value: Integer);
begin
  FConfig.HostPort := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetTerminalID(const Value: AnsiString);
begin
  FConfig.TerminalID := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSignPad(const Value: Boolean);
begin
  FConfig.SignPad := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSignPort(const Value: Integer);
begin
  FConfig.SignPort := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSignRate(const Value: Integer);
begin
  FConfig.SignRate := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetBizNo(const Value: AnsiString);
begin
  FConfig.BizNo := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetCashBeeID(const Value: AnsiString);
begin
  FConfig.CashBeeID := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetStrName(const Value: AnsiString);
begin
  FConfig.StrName := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSerialNo(const Value: AnsiString);
begin
  FConfig.SerialNo := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetPassword(const Value: AnsiString);
begin
  FConfig.Password := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetAreaCode(const Value: AnsiString);
begin
  FConfig.AreaCode := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetTerminalSerialNo(const Value: AnsiString);
begin
  FConfig.TerminalSerialNo := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetPosDownload(const Value: Boolean);
begin
  FConfig.PosDownload := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetProgramCode(const Value: AnsiString);
begin
  FConfig.ProgramCode := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetProgramVersion(const Value: AnsiString);
begin
  FConfig.ProgramVersion := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetDebugLog(const Value: Boolean);
begin
  FConfig.DebugLog := Value;
  FLog.DebugLog := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetNoSignUse5M(const Value: Boolean);
begin
  FConfig.NoSignUse5M := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSecureModeInit(const Value: Boolean);
begin
  FConfig.SecureModeInit := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetCatPrintUse(const Value: Boolean);
begin
  FConfig.CatPrintUse := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetCatPrintPort(const Value: Integer);
begin
  FConfig.CatPrintPort := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetSecureMode(const Value: Boolean);
begin
  FConfig.SecureMode := Value;
  FLog.SecureMode := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetCatTerminal(const Value: Boolean);
begin
  FConfig.CatTerminal := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetPaymentGateway(const Value: Boolean);
begin
  FConfig.PaymentGateway := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetHWSecure(const Value: Boolean);
begin
  FConfig.HWSecure := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetMSRPort(const Value: Integer);
begin
  FConfig.MSRPort := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

procedure TVanModul.SetKocesDevice(const Value: TKocesDevice);
begin
  FConfig.KocesDevice := Value;
  if MainVan <> nil then
    MainVan.Config := FConfig;
end;

function TVanModul.CallPosDownload: TPosDownloadRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['개시거래', VanName, '실모드', FConfig.RealMode, '보안모듈', FConfig.SecureMode,
                       'HostIP', FConfig.HostIP, 'HostPort', FConfig.HostPort, 'SignPad', FConfig.SignPad, 'SignPort', FConfig.SignPort, 'MSRPort', FConfig.MSRPort]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  try
    Result := MainVan.CallPosDownload;
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPosDownload', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['개시거래', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanModul.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['신용승인', VanName, '실모드', FConfig.RealMode, '승인/취소', AInfo.Approval, '보안모듈', FConfig.SecureMode, 'KeyIn', AInfo.KeyInput, 'MSRTrans', AInfo. MSRTrans,
                       'HostIP', FConfig.HostIP, 'HostPort', FConfig.HostPort, 'SignPad', FConfig.SignPad, 'SignPort', FConfig.SignPort, 'MSRPort', FConfig.MSRPort,
                       '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt, '원승인번호', AInfo.OrgAgreeNo, '원승인일자', AInfo.OrgAgreeDate]);
  FPreDCAmt := 0;

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;

//  if not FConfig.RealMode then
//    MessageBox(0, '테스트 모드 상태입니다. 실제 승인이 아닙니다.', 'VanModul', MB_ICONWARNING or MB_OK);

  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  if MainVan.Config.SignPad then
  begin
    // TODO: OCX 등록 처리 로직 추가
    // 해당 밴사의 OCX 파일이 있는지 체크한다.
    // 해당 OCX가 등록되어있는지 체크한다.
    // 등록되어있지 않을 경우 등록한다.
  end;

  try
    // 오굿/파트너스 전 처리
    BeforePartnerShipProc(AInfo);
    // 밴 승인 모듈 호출
    if VanModul.SignPad and (FConfig.NoSignUse5M and (AInfo.SaleAmt <= Cash_50000)) then
    begin
      VanModul.SignPad := False;
      Result := MainVan.CallCard(AInfo);
      Result.IsSignOK := True;
      Result.SignData := EmptyStr;
      Result.SignLength := 0;
      VanModul.SignPad := True;
    end
    else
      Result := MainVan.CallCard(AInfo);

    // 오굿/파트너스 후 처리
    if Result.Result then
      AfterPartnerShipProc(AInfo, Result.PrintMsg, Result.AgreeAmt, Result.DCAmt);

    Application.ProcessMessages;
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallCard', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['신용 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', IntToStr(Result.AgreeAmt)]);
end;

function TVanModul.CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['현금승인', VanName, '승인/취소', AInfo.Approval, '보안모듈', FConfig.SecureMode, 'KeyIn', AInfo.KeyInput, 'MSRTrans', AInfo. MSRTrans,
                       '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt, '원승인번호', AInfo.OrgAgreeNo, '원승인일자', AInfo.OrgAgreeDate]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    Result := MainVan.CallCash(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallCash', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['현금 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanModul.CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['수표조회', VanName, '보안모듈', FConfig.SecureMode, '거래금액', AInfo.CheckAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallCheck(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallCheck', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, '수표조회');
end;

function TVanModul.CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['사인패드(서명시작)', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetSignData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5, ARetSignData, ARetEtcData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallSignPad', E.Message]);
      ARetSignData := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['사인패드(서명응답)', ARetSignData]);
end;

function TVanModul.CallPinPad(out ARetSignData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['핀패드', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetSignData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallPinPad(ARetSignData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPinPad', E.Message]);
      ARetSignData := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['핀패드', ARetSignData]);
end;

procedure TVanModul.CallPinCancel;
begin
  FLog.Write(ltBegin, ['핀패드 취소', VanName]);

  if MainVan = nil then
    Exit;

  try
    if VanType = vctKFTC then
      MainVan.CallPinCancel
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPinPad', E.Message]);
    end;
  end;

  FLog.Write(ltEnd, ['핀패드 취소']);
end;

function TVanModul.CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['은련카드', VanName, '승인/취소', AInfo.Approval, '보안모듈', FConfig.SecureMode, '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다!';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    Result := MainVan.CallEyCard(AInfo);
    Application.ProcessMessages;
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallEyCard', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
 // FLog.Write(ltEnd, ['은련카드 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
  FLog.Write(ltEnd, ['은련카드 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', IntToStr(Result.AgreeAmt)]);
end;

function TVanModul.CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo,
  AEmvInfo: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['IC 입력 요청', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallIC(APayAmt, AApproval, ACardNo, AEmvInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallIC', E.Message]);
      ACardNo := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['IC 입력 요청', ACardNo]);
end;

procedure MSCallback(output_data: PAnsiChar); stdcall;
var
  CardNo: string;
begin
  CardNo := output_data;
  if Assigned(VanModul.FMSCallbackEvent) then
    VanModul.FMSCallbackEvent(CardNo);
end;

procedure ICCallback(output_data: PAnsiChar); stdcall;
var
  ARecvData, CardNo, EmvInfo: string;
begin
  ARecvData := output_data;
  CardNo := StringSearch(ARecvData, #28,  1);
  EmvInfo := StringSearch(ARecvData, #28,  0);

  if Assigned(VanModul.FICCallbackEvent) then
    VanModul.FICCallbackEvent(CardNo, EmvInfo);
end;

function TVanModul.SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['단말기 비동기 요청', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    if VanType = vctKFTC then
      Result := MainVan.SetTerminalAsync(AStart, ARetData, @MSCallback, @ICCallback);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.SetTerminalAsync', E.Message]);
      ARetData := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['단말기 비동기 요청']);
end;

function TVanModul.PrintOut(APrintData: AnsiString): Boolean;
begin
  Result := False;
  try
    if CatTerminal then
      Result := (MainVan as TVanCatApprove).PrintOut(APrintData)
    else
      Result := MainVan.PrintOut(APrintData);
  except on E: Exception do
      FLog.Write(ltError, ['MainVan.PrintOut', E.Message]);
  end;
end;

procedure TVanModul.ApplyConfigAll;
begin
  FLog.Write(ltInfo, ['전체 설정 적용', VanName]);
  if MainVan <> nil then
    FreeAndNil(MainVan);

  MainVan := TVanKFTC.Create;
//  MainVan := TVanKFTCDaemon.Create;

  if MainVan <> nil then
  begin
    MainVan.Config := FConfig;
    MainVan.Log := FLog;
  end;
end;

procedure TVanModul.BeforePartnerShipProc(var AInfo: TCardSendInfo);
begin
//
end;

procedure TVanModul.AfterPartnerShipProc(AInfo: TCardSendInfo; var APrintMsg: AnsiString; var AAgreeAmt, ADCAmt: Integer);
begin
//
end;

function TVanModul.CouponAfterProc(AUse:Boolean; ALoyaltyResult: AnsiString): AnsiString;
begin
//
end;

function TVanModul.CallCoupon(AInfo: TCardSendInfo): TCardRecvInfo;
begin
//
end;

function TVanModul.CallCouponUse(AInfo: TCardSendInfo): TCardRecvInfo;
begin
//
end;

function TVanModul.CallRuleDownload: TRuleDownRecvInfo;
begin
//
end;

function TVanModul.CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['멤버십카드승인', VanName, '보안모듈', FConfig.SecureMode, '거래금액', AInfo.SaleAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  AInfo.SaleAmt := ABS(AInfo.SaleAmt);

  Result := MainVan.CallMembership(AInfo);
  FLog.Write(ltEnd, '멤버십카드승인');
end;

function TVanModul.CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['IC 리더기 제어', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallICReader(AWorkGubun, ARecvData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallICReader', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['IC 리더기 제어', ARecvData]);
end;

function TVanModul.CallMSR(AGubun: AnsiString; out ACardNo, ADecrypt, AEncData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['MSR 입력 요청', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallMSR(AGubun, ACardNo, ADecrypt, AEncData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallMSR', E.Message]);
      ACardNo := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['MSR 입력 요청', ACardNo]);
end;

function TVanModul.CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['MS 입력 요청', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    if VanType = vctKFTC then
      Result := MainVan.CallMS(APayAmt, ACardNo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallMS', E.Message]);
      ACardNo := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['MS 입력 요청', ACardNo]);
end;

function TVanModul.CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['현금IC승인', VanName, '승인/취소', AInfo.Approval, '보안모듈', FConfig.SecureMode, '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    if VanType = vctKFTC then
      Result := MainVan.CallCashIC(AInfo)
    else
      Result.Msg := '기능이 구현되지 않은 Van사 입니다.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallCashIC', E.Message]);
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['현금IC 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanModul.CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['PayOn Ready', VanName, '거래금액', APayAmt]);

  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    if VanType = vctKFTC then
      Result := MainVan.CallPayOnReady(APayAmt, ARecvData)
    else
      ARecvData := '기능이 구현되지 않은 Van사 입니다.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPayOnReady', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['PayOn 결과', Result, '메세지', ARecvData]);
end;

function TVanModul.CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['PayOn', VanName, '승인/취소', AInfo.Approval, '보안모듈', FConfig.SecureMode, '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    if VanType = vctKFTC then
      Result := MainVan.CallPayOn(AInfo)
    else
      Result.Msg := '기능이 구현되지 않은 Van사 입니다.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPayOn', E.Message]);
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['PayOn 결과', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanModul.CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetCurrencyData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['통화선택', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetCurrencyData := 'Van사가 설정되어 있지 않습니다.';
    Exit;
  end;

  try
    Result := MainVan.CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5, ARetCurrencyData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallSelectCurrency', E.Message]);
      ARetCurrencyData := E.Message;
    end;
  end;

  FLog.Write(ltEnd, ['통화선택', ARetCurrencyData]);
end;

function TVanModul.CashDrawOpen: Boolean;
begin
  Result := False;
  try
    Result := (MainVan as TVanCatApprove).CashDrawOpen;
  except
    on E: Exception do
      FLog.Write(ltError, ['MainVan.CashDrawOpen', E.Message]);
  end;
end;

{ TVanApprove }

procedure TVanApprove.ShowMessageForm(AMsg: string; AButtonHide: Boolean; ATimeOutSeconds: integer);
begin
  TLog.Write('ShowMessageForm:' + AMsg);
  if FMessageForm = nil then
    FMessageForm := TVanMessageForm.Create(nil);

  (FMessageForm as TVanMessageForm).KeyPreview := True;
  (FMessageForm as TVanMessageForm).TimeOutSeconds := ATimeOutSeconds;
  (FMessageForm as TVanMessageForm).btnCancel.OnClick := EventMessageFormCancelClick;
  (FMessageForm as TVanMessageForm).lblMessage.Caption := AMsg;
  (FMessageForm as TVanMessageForm).btnCancel.Visible := not AButtonHide;
  if Config.ProgramCode = '0301' then // 제우스
  begin
    (FMessageForm as TVanMessageForm).Position := poScreenCenter;
  end
  else
  begin
    (FMessageForm as TVanMessageForm).Top := 50;
    (FMessageForm as TVanMessageForm).Left := 210;
    (FMessageForm as TVanMessageForm).Position := poDesigned;
  end;
  SetWindowPos(FMessageForm.Handle, HWND_TOPMOST, FMessageForm.Left, FMessageForm.Top, FMessageForm.Width, FMessageForm.Height, 0);
  FMessageForm.Show;
  FMessageForm.Update;
end;

procedure TVanApprove.HideMessageForm;
begin
  TLog.Write('HideMessageForm');
  if FMessageForm <> nil then
  begin
    FMessageForm.Close;
    FreeAndNil(FMessageForm);
  end;
end;

function ShowQuestionForm(AMsg: string): Boolean;
var
  AQuestionForm: TVanQuestionForm;
begin
  TLog.Write('ShowQuestionForm:' + AMsg);
  AQuestionForm := TVAnQuestionForm.Create(nil);
  try
    AQuestionForm.lblMessage.Caption := AMsg;
    SetWindowPos(AQuestionForm.Handle, HWND_TOPMOST, AQuestionForm.Left, AQuestionForm.Top, AQuestionForm.Width, AQuestionForm.Height, 0);
    Result := AQuestionForm.ShowModal = mrOk;
  finally
    AQuestionForm.Free;
  end;
end;

function ShowQuestionForm2(AMsg: string; out AReturnValue: AnsiString; out AErrMsg: Ansistring): Boolean;
var
  AQuestionForm: TVanQuestionForm2;
begin
  TLog.Write('ShowQuestionForm:' + AMsg);
  AQuestionForm := TVAnQuestionForm2.Create(nil);
  try
    AQuestionForm.lblMessage.Caption := AMsg;
    Result := AQuestionForm.ShowModal = mrOk;
    AReturnValue := AQuestionForm.ScanText;
    AErrMsg := AQuestionForm.ErrMsg;
  finally
    AQuestionForm.Free;
  end;
end;

procedure TVanApprove.EventMessageFormCancelClick(Sender: TObject);
begin
  FMessageForm.Close;
end;

procedure TVanApprove.DoMessageFormCancelClick;
begin
  EventMessageFormCancelClick(nil);
end;

function TVanApprove.CallPosDownload: TPosDownloadRecvInfo;
begin
  Result.Result := False;
end;

function TVanApprove.ShowAIDSelectForm(AAIDCount: Integer; AAIDList: AnsiString; out ASelectAIDIndex: Integer): Boolean;
begin
//
end;

{ TTMoney }

constructor TTMoney.Create;
begin
  Log := TLog.Create;
end;

destructor TTMoney.Destroy;
begin
  Log.Free;
  inherited;
end;

function TTMoney.ExecInit(out AInfo: AnsiString): Boolean;
begin
  Result := False;
end;

function TTMoney.ExecGetMoney(out AAmt: Integer;
  out ACardID: AnsiString): Boolean;
begin
  Result := False;
end;

function TTMoney.ExecCancelProc(APayAmt: Integer; AOrgPayData: TTMoneyRecvInfo;
  out APayRecvInfo: TTMoneyRecvInfo): Boolean;
begin
  Result := False;
end;

function TTMoney.ExecPayProc(APayAmt: Integer;
  out APayRecvInfo: TTMoneyRecvInfo): Boolean;
begin
  Result := False;
end;

function TTMoney.ExecChargeCancelProc(AChargeAmt: Integer;
  out APayRecvInfo: TTMoneyRecvInfo): Boolean;
begin
  Result := False;
end;

function TTMoney.ExecChargeProc(AChargeAmt: Integer;
  out APayRecvInfo: TTMoneyRecvInfo): Boolean;
begin
  Result := False;
end;

procedure TTMoney.HostReSendData;
begin

end;

procedure TTMoney.SetCofig(const Value: TVanConfigInfo);
begin
  FConfig := Value;
end;

{ TTRS }

constructor TTRS.Create;
begin
  Log := TLog.Create;
end;

destructor TTRS.Destroy;
begin
  Log.Free;
  inherited;
end;

function TTRS.CallExec(AInfo: TTRSSendInfo): TTRSRecvInfo;
begin
  Result.Result := False;
  Result.Msg := '해당 기능을 지원하지 않는 Van사 입니다. ';
end;

{ TCubeRefund }

constructor TCubeRefund.Create;
begin
  Log := TLog.Create;
end;

destructor TCubeRefund.Destroy;
begin
  Log.Free;
  inherited;
end;

function TCubeRefund.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
     0: Result := '정상처리 되었습니다.';
    -1: Result := 'Socket select error.';
    -2: Result := 'Recv Timeout.';
    -3: Result := 'Recv error.';
    -4: Result := 'Recv len error.';
    -5: Result := 'Socket create error.';
    -6: Result := 'Connect error.';
    -7: Result := 'Recv Msg Header error.';
    -8: Result := 'Connect Timeout. (2sec)';
    -9: Result := 'ioctlsocket error.';
    -11: Result := 'RSA padding error.';
    -12: Result := 'RSA enceypt error.';
    -88: Result := 'Client Msg Encryption error.';
    -99: Result := 'C2Soft Msg Decryption error.';
  end;
end;

function TCubeRefund.MakeSendData(AInfo: TCubeRefundSendInfo): AnsiString;
const
  CUBEREFUND_INI = 'CubeRefund.ini';
var
  Index, SeqNo: Integer;
  DetailInfo: AnsiString;
  ApplyCode: AnsiString;
  ASaleInfo: AnsiString;
  ASum, ASumVat: Currency;
begin
  DetailInfo := EmptyStr;
  ASum := 0;
  ASumVat := 0;

  for Index := Low(AInfo.DetailGoodsList) to High(AInfo.DetailGoodsList) do
  begin
    DetailInfo := DetailInfo +
                  // 상품코드
                  RPadB(AInfo.DetailGoodsList[Index].GoodsCode, 15) +
                  // 상품명
                  RPadB(AInfo.DetailGoodsList[Index].GoodsName, 40) +
                  // 수량
                  FormatFloat('0000', AInfo.DetailGoodsList[Index].SaleQty) +
                  // 단가
                  FormatFloat('0000000000', AInfo.DetailGoodsList[Index].SalePrice) +
                  // 판매가
                  FormatFloat('0000000000', AInfo.DetailGoodsList[Index].SaleAmt) +
                  // 부가가치세
                  FormatFloat('00000000', AInfo.DetailGoodsList[Index].SaleVat) +
                  // 개별소비세
                  FormatFloat('00000000', 0) +
                  // 교육세
                  FormatFloat('00000000', 0) +
                  // 농어촌특별세
                  FormatFloat('00000000', 0);
    ASum := ASum + AInfo.DetailGoodsList[Index].SaleAmt;
    ASumVat := ASumVat + AInfo.DetailGoodsList[Index].SaleVat;
    if Index >= 69 then Break; // 상세 목록 갯수는 최대 70개
  end;
  SeqNo := GetSeqNo(CUBEREFUND_INI, True, 999);
  ApplyCode := IfThen(AInfo.IsRefund, '5308', '5302');
            // 전문 Type
  Result := ApplyCode +
            // 거래고유번호
            RPadB('', 12) +
            // 전문 flag
            'P' +
            // 가맹점 사업자번호
            RPadB(FConfig.BizNo, 10) +
            // 포스업체정보
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // 가맹점 번호
            RPadB(FConfig.TerminalID, 10) +
            // POS 일련번호
            FormatFloat('000', SeqNo) +
            // 가맹점 거래고유번호
            RPadB(FormatDateTime('yyyymmdd', Now) + FormatFloat('000', SeqNo), 20) +
            // 여권입력 유형 (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // 여권번호
            IfThen(AInfo.IsRefund, RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150), RPadB(AInfo.PassportInfo, 150));
            // 요청건수
  if Length(AInfo.DetailGoodsList) < 70 then
    Result := Result + FormatFloat('00', Length(AInfo.DetailGoodsList))
  else
    Result := Result + FormatFloat('00', 70);
            // 가맹점 판매전표번호
  Result := Result + RPadB(AInfo.ReceiptNo, 30) +
            // 상세항목
            DetailInfo +
            // 상품결제 유형
            RPadB(AInfo.PayGubun, 1, '0') +
            // 여유 필드
            IfThen(AInfo.IsRefund, RPadB('', 30), EmptyStr);
end;

function TCubeRefund.MakeSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
const
  CUBEREFUND_INI = 'CubeRefund.ini';
var
  SeqNo: Integer;
  OrgAgreeDate: AnsiString;
begin
  SeqNo := GetSeqNo(CUBEREFUND_INI, True, 999);
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  OrgAgreeDate := Copy(AInfo.OrgAgreeDate, 3, 6);
            // 전문 Type
  Result := '5303' +
            // 거래고유번호
            RPadB('', 12) +
            // 전문 flag
            'P' +
            // 가맹점 사업자번호
            RPadB(FConfig.BizNo, 10) +
            // 포스업체정보
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // 가맹점 번호
            RPadB(FConfig.TerminalID, 10) +
            // POS 일련번호
            FormatFloat('000', SeqNo) +
            // 취소구분 (0:단말취소 1:망취소 2:자동취소)
            '0' +
            // 원 거래일자
            RPadB(OrgAgreeDate, 6) +
            // 원 환급전표발행번호
            RPadB(AInfo.OrgAgreeNo, 12) +
            // 여권입력 유형 (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // 여권번호
            RPadB(AInfo.PassportInfo, 150);
            // 원 가맹점 거래고유번호
            RPadB('', 20);
end;

function TCubeRefund.MakeRefuncSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
const
  CUBEREFUND_INI = 'CubeRefund.ini';
var
  SeqNo: Integer;
  OrgAgreeDate: AnsiString;
  AResult: Boolean;
begin
  SeqNo := 0;
  SeqNo := GetSeqNo(CUBEREFUND_INI, True, 999);
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  OrgAgreeDate := Copy(AInfo.OrgAgreeDate, 3, 6);
            // 전문 Type
  Result := '5304' +
            // 거래고유번호
            RPadB('', 12) +
            // 전문 flag
            'P' +
            // 가맹점 사업자번호
            RPadB(FConfig.BizNo, 10) +
            // 포스업체정보
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // 가맹점 번호
            RPadB(FConfig.TerminalID, 10) +
            // POS 일련번호
            FormatFloat('000', SeqNo) +
            // 취소구분 (0:단말취소 1:망취소 2:자동취소)
            '0' +
            // 원 거래일자
            RPadB(OrgAgreeDate, 6) +
            // 원 환급전표발행번호
            RPadB(AInfo.OrgAgreeNo, 12) +
            // 여권입력 유형 (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // 여권번호
            IfThen(AInfo.IsRefund, RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150), RPadB(AInfo.PassportInfo, 150)) +
            // 원 가맹점 거래고유번호
            RPadB('', 20) +
            RPadB(CurrToStr(AInfo.SaleAmt), 10) +
            RPadB('', 30);
end;

procedure TCubeRefund.SetConfig(AValue: TCubeRefundConfigInfo);
begin
  FConfig := AValue;
end;

function TCubeRefund.MakeRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
begin
  // 응답코드
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 124, 200));
  // 거래고유번호
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // 가맹점 거래고유번호
  Result.TransNoStore := Trim(Copy(ARecvData, 32, 20));
  // 거래일시
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // 환급전표 발행번호
  Result.AgreeNo := Trim(Copy(ARecvData, 52, 12));
  // 여권번호
  Result.PassportNo := Trim(Copy(ARecvData, 64, 9));
  // 구매자 성명
  Result.BuyersName := Trim(Copy(ARecvData, 73, 40));
  // 구매자 국적
  Result.BuyersNationality := Trim(Copy(ARecvData, 113, 3));
  // 환급액
  TryStrToCurr(Trim(Copy(ARecvData, 116, 8)), Result.NetRefuncAmt);
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TCubeRefund.MakeRefundRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
var
  AResult: AnsiString;
begin
  // 응답코드
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 193, 100));
  // 거래고유번호
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // 가맹점 거래고유번호
  Result.TransNoStore := Trim(Copy(ARecvData, 32, 20));
  // 거래일시
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // 환급전표 발행번호
  Result.AgreeNo := Trim(Copy(ARecvData, 52, 12));
  // 여권번호
  Result.PassportNo := Trim(Copy(ARecvData, 78, 24));
  // 구매자 성명
  Result.BuyersName := Trim(Copy(ARecvData, 102, 40));
  // 구매자 국적
  Result.BuyersNationality := Trim(Copy(ARecvData, 142, 3));
  // 환급액
  TryStrToCurr(Trim(Copy(ARecvData, 145, 8)), Result.NetRefuncAmt);
  // 기준한도
  TryStrToCurr(Trim(Copy(ARecvData, 293, 10)), Result.ToTalLimit);
  // 차감후한도
  TryStrToCurr(Trim(Copy(ARecvData, 313, 10)), Result.RemainingLimit);
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TCubeRefund.MakeRecvCancelData(ARecvData: AnsiString): TCubeRefundRecvInfo;
begin
  // 응답코드
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 32, 100));
  // 거래고유번호
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // 거래일시
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TCubeRefund.DLLExec(ASendData: AnsiString;
  out ARecvData: AnsiString; ARefund: Boolean): Boolean;
const
  CUBE_POS_DLL = 'CubePos.dll';
type
  TExchangeExec = function(AServerIP: PAnsiChar; AServerPort, ATimeout: Integer; ASendData: PAnsiChar; ARecvData: PAnsiChar): Integer; stdcall;
var
  DLLHandle: THandle;
  Exec: TExchangeExec;
  ServerIP: AnsiString;
  ServerPort, Index: Integer;
  RecvData: array[0..2048] of AnsiChar;
begin
  Result := False;

  if FConfig.RealMode then
  begin
    ServerIP := '203.233.72.21';
    ServerPort := 15700;
  end
  else
  begin
    ServerIP := '203.233.72.55';
    ServerPort := 15200;
  end;
  try
    DLLHandle := LoadLibrary(CUBE_POS_DLL);
    @Exec := GetProcAddress(DLLHandle, 'Exchange');
    if Assigned(@Exec) then
    begin
      Index := Exec(PAnsiChar(ServerIP), ServerPort, 5, PAnsiChar(ASendData), RecvData);
      if Index >= 0 then
      begin
        ARecvData := RecvData;
        Result := True;
      end
      else
        ARecvData := GetErrorMsg(Index);
    end
    else
      ARecvData := CUBE_POS_DLL + MSG_ERR_DLL_LOAD;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function TCubeRefund.CallExec(AInfo: TCubeRefundSendInfo): TCubeRefundRecvInfo;
var
  SendData, RecvData: AnsiString;
  AResult: AnsiString;
begin
  if AInfo.IsRefund then
  begin
    if AInfo.PassportKeyin then
    begin
      if CubeAES(AInfo.PassportInfo, True, AResult) then
        AInfo.PassportInfo := Copy(AResult, 1, 24)
      else
      begin
        Log.Write(ltDebug, ['CubeAES.dll', AInfo.PassportInfo]);
        Result.Result := False;
        Result.Msg := AInfo.PassportInfo;
        Exit;
      end;
    end;
  end;

  if AInfo.Approval then
  begin
    if AInfo.IsRefund then
      if not MakeMaxRefund(AInfo) then
      begin
        Log.Write(ltDebug, ['즉시환급 한도 금액 초과']);
        Result.Result := False;
        Result.Msg := '즉시환급 한도 금액 초과';
        Exit;
      end;
    SendData := MakeSendData(AInfo);
  end
  else
  begin
    if AInfo.IsRefund then
      SendData := MakeRefuncSendCancelData(AInfo)
    else
      SendData := MakeSendCancelData(AInfo);
  end;

  Log.Write(ltDebug, ['전송전문', SendData]);
  Result.Result := DLLExec(SendData, RecvData, AInfo.IsRefund);
  Log.Write(ltDebug, ['응답전문', RecvData]);
  if Result.Result then
  begin
    if AInfo.Approval then
    begin
      if AInfo.IsRefund then
      begin
        Result := MakeRefundRecvData(RecvData);
        if CubeAES(Result.PassportNo, False, AResult) then
          Result.PassportNo := Copy(AResult, 1, 9);
      end
      else
        Result := MakeRecvData(RecvData);
    end
    else
      Result := MakeRecvCancelData(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TCubeRefund.DLLMaxRefundExec(ASendData: AnsiString): Currency;
const
  CUBE_POS_DLL = 'CubePos.dll';
type
  TExchangeExec = function(AServerIP: PAnsiChar; AServerPort, ATimeout: Integer; ASendData: PAnsiChar; ARecvData: PAnsiChar): Integer; stdcall;
var
  Exec: TExchangeExec;
  DLLHandle: THandle;
  Index, ServerPort: Integer;
  RecvData: array[0..2048] of AnsiChar;
  ServerIP: AnsiString;
begin
  if FConfig.RealMode then
  begin
    ServerIP := '210.112.111.129';
    ServerPort := 30031;
  end
  else
  begin
    ServerIP := '210.112.111.147';
    ServerPort := 30031;
  end;
  try
    DLLHandle := LoadLibrary(CUBE_POS_DLL);
    @Exec := GetProcAddress(DLLHandle, 'Exchange');
    if Assigned(@Exec) then
    begin
      Index := Exec(PAnsiChar(ServerIP), ServerPort, 5, PAnsiChar(ASendData), RecvData);
      if Index >= 0 then
      begin
        Result := StrToCurrDef(Trim(Copy(RecvData, 162, 10)), 0);
      end
      else
        Result := -1;
    end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function TCubeRefund.CubeAES(AData: AnsiString; AGubun: Boolean; out AResult: AnsiString): Boolean;
const
  CUBE_REFUND_DLL = 'CubeAES.dll';
type
  TCubeAESExec = function(AInput: PAnsiChar; AOutput: PAnsiChar; AMode: Integer): Integer; cdecl;
var
  RefundExec: TCubeAESExec;
  DLLHandle: THandle;
  ARecvData: array[0..1023] of AnsiChar;
begin
  try
    DLLHandle := LoadLibrary(CUBE_REFUND_DLL);
    @RefundExec := GetProcAddress(DLLHandle, 'CubeAES');
    if Assigned(@RefundExec) then
    begin
      if AGubun then
      begin
        Result := RefundExec(PAnsiChar(AData), ARecvData, 1) = 0;
        AResult := Trim(ARecvData);
      end
      else
      begin
        Result := RefundExec(PAnsiChar(AData), ARecvData, 0) = 0;
        AResult := Trim(ARecvData)
      end;
    end
    else
    begin
      Result := False;
      AResult := CUBE_REFUND_DLL + '이 없습니다.';
    end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function TCubeRefund.MakeMaxRefund(AInfo: TCubeRefundSendInfo): Boolean;
var
  Index, SeqNo: Integer;
  ASaleInfo: AnsiString;
  ASum, ASumVat: Currency;
begin
  ASaleInfo := EmptyStr;
  for Index := Low(AInfo.DetailGoodsList) to High(AInfo.DetailGoodsList) do
  begin
    ASum := ASum + AInfo.DetailGoodsList[Index].SaleAmt;
    ASumVat := ASumVat + AInfo.DetailGoodsList[Index].SaleVat;
    if Index >= 69 then Break; // 상세 목록 갯수는 최대 70개
  end;
  ASaleInfo := '5311' +
            // 거래고유번호
            RPadB('', 12) +
            // 전문 flag
            'P' +
            // 가맹점 사업자번호
            RPadB(FConfig.BizNo, 10) +
            // 포스업체정보
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // 가맹점 번호
            RPadB(FConfig.TerminalID, 10) +
            // POS 일련번호
            FormatFloat('000', SeqNo) +
            // 가맹점 거래고유번호
            RPadB(FormatDateTime('yyyymmdd', Now) + FormatFloat('000', SeqNo), 20) +
            // 여권입력 유형 (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // 여권번호
            RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150) +
            // 판매금액
            CurrToStr(ASum) +
            // 부가가치세
            CurrToStr(ASumVat) +
            // 기타세액 합
            RPadB('', 8) +
            // 여분필드 34
            RPadB('', 34);
  if (DLLMaxRefundExec(ASaleInfo) - ASum) < 0 then
  begin
    Result := False;
  end;
  Result := True;
end;

{ TMtic }

class function TMtic.ExecPayProc(ASendInfo: TMTICSendInfo): TMTICRecvInfo;
const
  DLL_NAME = 'Mtic.dll';
type
  TApiMticComm = function (Mode: PAnsiChar; VanCode: PAnsiChar; SvcId: PAnsiChar; TrxNo: PAnsiChar;
                           PrdtPrice: PAnsiChar; PrdtNm:PAnsiChar; DeviceId: PAnsiChar; BarCode: PAnsiChar;
                           AuthType: PAnsiChar; PhoneNo: PAnsiChar; ResultCd: PAnsiChar; ResultMsg: PAnsiChar;
                           ActDate: PAnsiChar; ApprNo: PAnsiChar; RemainAmt: PAnsiChar): Integer; stdcall;
var
  DLLHandle: THandle;
  Exec: TApiMticComm;
  Mode, PrdtPrice: AnsiString;
  ResultCd: array[0..3] of AnsiChar;
  ResultMsg: array[0..99] of AnsiChar;
  ActDate: array[0..13] of AnsiChar;
  ApprNo: array[0..19] of AnsiChar;
  RemainAmt: array[0..9] of AnsiChar;
  nRet: Integer;
begin
  Result.Result := False;
  DLLHandle := LoadLibrary(DLL_NAME);
  try
    @Exec := GetProcAddress(DLLHandle, 'API_MTIC_COMM');
    if Assigned(@Exec) then
    begin
      Mode := IfThen(ASendInfo.Approval, 'pay', 'cancel');
      ASendInfo.GoodsAmt := ABS(ASendInfo.GoodsAmt);
      PrdtPrice := CurrToStr(ASendInfo.GoodsAmt);
      if not ASendInfo.Approval then
      begin
        FillChar(ApprNo, Length(ApprNo), 0);
        Move(ASendInfo.OrgAgreeNo[1], ApprNo, Length(ASendInfo.OrgAgreeNo));
      end;

      TLog.Write('MTIC 승인:' + IfThen(ASendInfo.Approval, 'True', 'False') + ' 금액:' + CurrToStr(ASendInfo.GoodsAmt) + ' 바코드:' + ASendInfo.BarCode);
  	  nRet := Exec(PAnsiChar(Mode), PAnsiChar(ASendInfo.VanCode), PAnsiChar(ASendInfo.SvcID), PAnsiChar(ASendInfo.TransNo),
                   PAnsiChar(PrdtPrice), '', '', PAnsiChar(ASendInfo.BarCode), '1', '',
                   ResultCd, ResultMsg, ActDate, ApprNo, RemainAmt);

      Result.Result := ResultCd = '0000';
      Result.Code := ResultCd;
      Result.Msg := ResultMsg + GetErrorMsg(nRet);
      Result.AgreeNo := ApprNo;
      Result.TransDateTime := ActDate;
      TryStrToCurr(RemainAmt, Result.RemainAmt);

      TLog.Write('MTIC ' + '코드:' + Result.Code + ' 메세지:' + Result.Msg + ' 승인번호:' + Result.AgreeNo + ' 승인일시:' + Result.TransDateTime);
    end
    else
      Result.Msg := DLL_NAME + MSG_ERR_DLL_LOAD;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

class function TMtic.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
     0 : Result := '정상처리 되었습니다.';
     5 : Result := '가입자 정보가 없습니다.';
    10 : Result := '해당 바코드에 대한 고객정보를 찾을 수 없습니다.';
    11 : Result := '이동통신사에 등록되지 않은 고객입니다.';
    12 : Result := '명의자 주민번호가 일치하지 않습니다.';
    13 : Result := '사용정지된 폰입니다.';
    14 : Result := '해지된 전화번호 입니다.';
    15 : Result := '사업자명의 휴대폰(법인폰)은 사용하실 수 없습니다.';
    16 : Result := '통신요금미납으로 소액결제 사용이 불가합니다.';
    17 : Result := '통신요금 선납자는 소액결제 사용이 불가합니다.';
    19 : Result := '법정대리인 동의가 완료되지 않았습니다. 확인후 다시 시도해 주세요.';
    20 : Result := '고객관리정보가 일치하지 않습니다.';
    21 : Result := '이동통신사 결제한도가 초과 되었습니다.';
    31 : Result := '이번달 결제 한도가 초과되었습니다. 고객센터(1600-0527)로 문의하십시오.';
    32 : Result := '미성년(14세이전)명의의 휴대폰은 결제를 이용하실수 없습니다.';
    33 : Result := 'TTL School 요금제 가입자는 서비스가 불가합니다.';
    34 : Result := 'DUAL NUMBER 또는 080 NUMBER는 소액결제를 이용하실 수 없습니다.';
    36 : Result := '이동통신사에 소액결제차단을 요청하신 번호입니다. 해당 이동통신사로 문의하십시오.';
    38 : Result := '결제 정책상 해당폰은 결제가 불가하오니 타결제수단을 이용하시기 바랍니다.(1600-0527)';
    39 : Result := '유효시간 내에 결제내역이 있습니다. 잠시 후 사용하십시오.';
    41 : Result := '기 거래내역이 없습니다.';
    42 : Result := '구매취소 기간이 경과되어 구매취소를 할 수 없습니다.';
    44 : Result := '이미 취소된 거래입니다.';
    48 : Result := '복제가 가능한 단말기이므로 통신사에서 본인확인 후 결제가 가능합니다.(1544-0010)';
    54 : Result := '가입(명의변경)후 3일 이내에는 결제가 제한됩니다. 다른 결제수단을 이용해 주시기 바랍니다.';
    58 : Result := '결제 정책상 해당폰은 결제가 불가하오니 타결제수단을 이용하시기 바랍니다.(1600-0527)';
    59 : Result := '결제 정책상 해당폰은 결제가 불가하오니 타결제수단을 이용하시기 바랍니다.(1600-0527)';
    60 : Result := '외국인명의의 휴대폰은 결제를 사용하실 수 없습니다.';
    71 : Result := '등록되지 않은 서비스입니다. 해당 서비스업체에 문의하십시오.';
    96 : Result := '거래 데이터 확인이 지연되고 있습니다. 고객센터(1600-0527)로 문의하십시오.';
    97 : Result := '요청자료에 문제가 있습니다. 해당 서비스업체에 문의하십시오.';
    98 : Result := '거래 데이터 확인이 지연되고 있습니다. 잠시후 다시 사용하십시오..';
    99 : Result := '현재 사용자가 많아서 서비스가 지연되고 있습니다. 잠시후 사용해 주십시오.';
    9002 : Result := '로그 파일을 생성할 수 없습니다.';
    9003 : Result := 'Mtic.ini 파일오류 입니다.';
    9100 : Result := '전문구분(Mode)이 유효하지 않습니다.';
    9101 : Result := '가맹점코드(VanCode)가 유효하지 않습니다.';
    9102 : Result := '가맹점ID(SvcId)가 유효하지 않습니다.';
    9103 : Result := '거래번호(TrxNo)가 유효하지 않습니다.';
    9104 : Result := '상품가격(PrdtPrice)이 유효하지 않습니다.';
    9105 : Result := '상품명(PrdtNm)이 유효하지 않습니다.';
    9106 : Result := '점포코드(DeviceId)가 유효하지 않습니다.';
    9108 : Result := '바코드값(BarCode)이 유효하지 않습니다.';
    9109 : Result := '승인번호(ApprNo)가 유효하지 않습니다.';
    9110 : Result := '인증타입(AuthType)이 유효하지 않습니다.';
    9111 : Result := '휴대폰번호(PhoneNo)가 유효하지 않습니다.';
    9901 : Result := '통신모듈 초기화시 오류가 발생하였습니다.';
    9902 : Result := 'MTic서버와 연결할 수 없습니다.';
    9903 : Result := 'MTic서버로 결제데이터를 전송할 수 없습니다.';
    9904 : Result := 'MTic서버로부터 데이터 수신 오류가 있습니다.';
    9905 : Result := 'MTic서버와 연결시간이 초과되었습니다.';
    9999 : Result := '알 수 없는 오류입니다. 담당자에 문의하세요.';
  else
    Result := '';
  end;
end;

{ TCashbee }

constructor TCashbee.Create;
begin
  Log := TLog.Create;
end;

destructor TCashbee.Destroy;
begin
  Log.Free;
  inherited;
end;

function TCashbee.ExecInit: Boolean;
begin
  Result := False;
end;

function TCashbee.GetCardMoney(out ACardAmt: Integer; out ACardID: AnsiString): Boolean;
begin
  Result := False;
end;

function TCashbee.GetSamMoney(out ASamAmt: Integer; out ASamID: AnsiString): Boolean;
begin
  Result := False;
end;

function TCashbee.ExecPayProc(ASendInfo: TCashbeeSendInfo): TCashbeeRecvInfo;
begin
  Result.Result := False;
end;

function TCashbee.ExecSamSaveAuth: TCashbeeRecvInfo;
begin
  Result.Result := False;
end;

{ TLog }

constructor TLog.Create;
begin
  FLogDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Log\';
  ForceDirectories(FLogDir);

  FSecureMode := False;
  DebugLog := False;
end;

destructor TLog.Destroy;
begin

  inherited;
end;

class procedure TLog.WriteLogFile(AMessage: AnsiString);
var
  LogFile: TextFile;
  AFileName: string;
begin
  ForceDirectories(FLogDir);

  try
    AFileName := FLogDir + FormatDateTime('yyyymmdd', Date) + '.log';
    {$i-}
    AssignFile(LogFile, AFileName);
    if FileExists(AFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);
    Writeln(LogFile, AMessage);
  finally
    CloseFile(LogFile);
    {$i+}
  end;
end;

class procedure TLog.Write(AMessage: AnsiString);
var
  LogText: AnsiString;
begin
  LogText := '[' + FormatDateTime('hh:nn:ss.zzz', Time) + ']';
  LogText := LogText + '[     ]' + '[' + AMessage + ']';
  WriteLogFile(LogText);
end;

procedure TLog.Write(ALogType: TLogType; AMessage: array of Variant);
var
  ATitle, AText, Temp: AnsiString;
  Index: Integer;
begin
  // 보안모듈을 사용할때는 디버그 모드일때만 로그를 남긴다.
  {$IF DEFINED(DEBUG)}
    //
  {$ELSE}
    if (ALogType = ltDebug) and SecureMode and not DebugLog then Exit;
  {$IFEND}
//  if (ALogType = ltDebug) and SecureMode and (DebugHook = 0) then Exit;

  case ALogType of
    ltInfo  : ATitle := '[     ]';
    ltError : ATitle := '[ERROR]';
    ltDebug : ATitle := '[  *  ]';
    ltBegin : ATitle := '[BEGIN]';
    ltEnd   : ATitle := '[ END ]';
  end;
  for Index := Low(AMessage) to High(AMessage) do
  begin
    if ALogType = ltDebug then
      Temp := VarToStr(AMessage[Index])
    else
      Temp := Trim(VarToStr(AMessage[Index]));
    if (Index mod 2) = 0 then
      AText := AText + Temp + '='
    else
      AText := AText + '<' + Temp + '> ';
  end;
  ATitle := '[' + FormatDateTime('hh:nn:ss.zzz', Time) + ']' + ATitle;
  WriteLogFile(ATitle + '[' + AText + ']');
end;

procedure TLog.Write(ALogType: TLogType; AMessage: AnsiString);
begin
  Write(ALogType, [AMessage]);
end;

{ TBagxen }

class function TBagxen.ExecProc(AServerIP: AnsiString; AServerPort: Integer; ASendData: AnsiString): TBagxenRecvInfo;
var
  RecvData: AnsiString;
begin
  if SendData(AServerIP, AServerPort, ASendData, RecvData) then
  begin
    Result := MakeRecvData(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg1 := RecvData;
  end;
end;

class function TBagxen.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    11 : Result := '포인트 적립 불가';
    12 : Result := '포인트 사용 불가';
    13 : Result := '포인트 적립취소 불가';
    14 : Result := '포인트 사용취소 불가';
    15 : Result := '카드번호 오류';
    16 : Result := '미등록 가맹점';
    17 : Result := '포인트 적립불가 가맹점';
    18 : Result := '포인트 사용불가 가맹점';
  else
    Result := '기타 에러';
  end;
end;

class function TBagxen.MakeRecvData(ARecvData: AnsiString): TBagxenRecvInfo;
var
  Temp: AnsiString;
begin
{
0710SOLB20131022115531000000000003001198624431     201310221155312104499145255720008                                               000000000003                    0000000000000000000000000000
0310SOLB20131022134851000000000009181198624431     201310221348510104499145255720008                                     0000002000000000000009                    0000000000000000000000000000
}
  ARecvData := Copy(ARecvData, 5, Length(ARecvData) - 4);
  Result.Code := Copy(ARecvData, 35, 2);
  Result.Result := Result.Code = '00';
  Result.AgreeNo := Copy(ARecvData, 132, 12);
  Temp := Copy(ARecvData, 164, 9);
  TryStrToInt(Temp, Result.OccurPoint);
  Temp := Copy(ARecvData, 173, 9);
  TryStrToInt(Temp, Result.AblePoint);
  Temp := Copy(ARecvData, 182, 9);
  TryStrToInt(Temp, Result.AccruePoint);
  Result.Msg1 := Copy(ARecvData, 192, 24);
  Result.Msg2 := Copy(ARecvData, 216, 24);
  Result.Msg3 := Copy(ARecvData, 240, 24);

//  if not Result.Result then
//    Result.Msg1 := GetErrorMsg(StrToIntDef(Result.Code, -1));
end;

class function TBagxen.MakeSendData(AType: TBagxenType; ASendInfo: TBagxenSendInfo): AnsiString;
var
  TradeType: AnsiString;
begin
  // 전문 번호
  case AType of
    btSave:
    begin
      Result := '0300';
      TradeType := '01';
    end;
    btSaveCancel:
    begin
      Result := '0400';
      TradeType := '31';
    end;
    btUse:
    begin
      Result := '0500';
      TradeType := '11';
    end;
    btUseCancel:
    begin
      Result := '0600';
      TradeType := '11';
    end;
    btInquiry:
    begin
      Result := '0700';
      TradeType := '21';
    end;
  end;

                   // 전송기관 코드
  Result := Result + 'SOLB'
                   // 전송 일자
                   + FormatDateTime('yyyymmdd', Now)
                   // 전송 시간
                   + FormatDateTime('hhnnss', Now)
                   // 전문추적 번호
                   + FormatFloat('000000000000', GetSeqNo)
                   // 응답 코드
                   + '  '
                   // 가맹점 번호
                   + Format('%-15.15s', [ASendInfo.TerminalID])
                   // 거래 일자
                   + FormatDateTime('yyyymmdd', Now)
                   // 거래 시간
                   + FormatDateTime('hhnnss', Now)
                   // 거래 구분
                   + TradeType
                   // WCC
                   + IfThen(ASendInfo.KeyIn, '2', '0')
                   // Track II
                   + Format('%-37.37s', [ASendInfo.TrackTwo])
                   // 비밀번호
                   + Format('%-16.16s', [ASendInfo.Password])
                   // 거래금액 (Filler)
                   + FormatFloat('0000000000', ASendInfo.SaleAmt)
                   // 승인번호 (Filler)
                   + '            '
                   // 원 승인 일자 (Filler)
                   + Format('%-8.8s', [ASendInfo.OrgAgreeDate])
                   // 원 승인 번호 (Filler)
                   + Format('%-12.12s', [ASendInfo.OrgAgreeNo])
                   // 발생 POINT
                   + FormatFloat('000000000', 0)
                   // 가용 POINT
                   + FormatFloat('000000000', 0)
                   // 누적 POINT
                   + FormatFloat('000000000', 0)
                   // 취소 사유
                   + IfThen(AType in [btSave, btUse, btInquiry], '0', '3')
                   // 메세지 1
                   + '                        '
                   // 메세지 2
                   + '                        '
                   // 메세지 3
                   + '                        ';

  Result := FormatFloat('0000', Length(Result)) + Result;
end;

class function TBagxen.PointInquiry(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
var
  SendData: AnsiString;
begin
  SendData := MakeSendData(btInquiry, ASendInfo);
  Result := ExecProc(ASendInfo.ServerIP, ASendInfo.ServerPort, SendData);
end;

class function TBagxen.PointSave(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
var
  SendData: AnsiString;
begin
  SendData := MakeSendData(btSave, ASendInfo);
  Result := ExecProc(ASendInfo.ServerIP, ASendInfo.ServerPort, SendData);
end;

class function TBagxen.PointSaveCancel(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
var
  SendData: AnsiString;
begin
  SendData := MakeSendData(btSaveCancel, ASendInfo);
  Result := ExecProc(ASendInfo.ServerIP, ASendInfo.ServerPort, SendData);
end;

class function TBagxen.PointUse(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
var
  SendData: AnsiString;
begin
  SendData := MakeSendData(btUse, ASendInfo);
  Result := ExecProc(ASendInfo.ServerIP, ASendInfo.ServerPort, SendData);
end;

class function TBagxen.PointUseCancel(ASendInfo: TBagxenSendInfo): TBagxenRecvInfo;
var
  SendData: AnsiString;
begin
  SendData := MakeSendData(btUseCancel, ASendInfo);
  Result := ExecProc(ASendInfo.ServerIP, ASendInfo.ServerPort, SendData);
end;

class function TBagxen.SendData(AServerIP: AnsiString; AServerPort: Integer; ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
const
  DLL_NAME = 'Bagxen.dll';
  SERVER_IP = '222.231.24.232';
  SERVER_PORT_TEST = 8652;
  SERVER_PORT_REAL = 7652;
type
  TBagxenSend = function(AHost: PAnsiChar; APort: Integer; ASendData: PAnsiChar; ARecvData: PAnsiChar): Integer; stdcall;
var
  DLLHandle: THandle;
  Exec: TBagxenSend;
  nRet: Integer;
  RecvData: array[0..266] of AnsiChar;
begin
  Result := False;
  DLLHandle := LoadLibrary(DLL_NAME);

  try
    @Exec := GetProcAddress(DLLHandle, 'BagxenSend');
    if Assigned(@Exec) then
    begin
  	  nRet := Exec(PAnsiChar(AServerIP), AServerPort, PAnsiChar(ASendData), RecvData);
      ARecvData := RecvData;
      Result := nRet = 1;
    end
    else
      ARecvData := DLL_NAME + MSG_ERR_DLL_LOAD;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

{ TKisRcpCoupon }

class function TKisRcpCoupon.ExecRcpCoupon(ARealMode: Boolean; ACatID, ATranCode, AAuthNo: AnsiString; ATranAmt: Currency): TKisRcpCouponRecvInfo;
const
  KIS_COUPON_DLL = 'KisRcpCop.dll';
  KIS_COUPON_TEST_DLL = 'testKisRcpCop.dll';
type
  TKis_Coupon = function(CatID, TranCode, AuthNo, TransAmt, RecvBuf: PAnsiChar): Integer; stdcall;
var
  DLLHandle: THandle;
  Exec: TKis_Coupon;
  Index: Integer;
  TranAmt, ARecvData: AnsiString;
begin
  Result.Result := False;
  SetLenAndFill(ARecvData, 100);

  if ARealMode then
    DLLHandle := LoadLibrary(KIS_COUPON_DLL)
  else
    DLLHandle := LoadLibrary(KIS_COUPON_TEST_DLL);

  try
    @Exec := GetProcAddress(DLLHandle, 'VB_ReqKisCoupon');
    if not Assigned(@Exec) then
    begin
      Result.Msg := IfThen(ARealMode, KIS_COUPON_DLL, KIS_COUPON_TEST_DLL) + MSG_ERR_DLL_LOAD;
      Exit;
    end;
    TranAmt := CurrToStr(ATranAmt);
    // 승인 요청을 한다
    Index := Exec(PAnsiChar(ACatID), PAnsiChar(ATranCode), PAnsiChar(AAuthNo), PAnsiChar(TranAmt), @ARecvData[1]);
//    Index := Exec(PAnsiChar('90100546'), PAnsiChar('D1'), PAnsiChar('77657510'), PAnsiChar('1000'), @ARecvData[1]);

    // 응답을 처리한다.
    case Index of
      0 :
        begin
          Result.Result := True;
//          Result.AdImgEnable := Copy(ARecvData, 1, 1) = 'Y';
          if Copy(ARecvData, 1, 1) = 'Y' then
            Result.AdImgName := Copy(ARecvData, 2, 20);
//          Result.AdTextEnable := Copy(ARecvData, 22, 1) = 'Y';
          if Copy(ARecvData, 22, 1) = 'Y' then
            Result.AdTextName := Copy(ARecvData, 23, 20);
//          Result.EventImgEnable := Copy(ARecvData, 43, 1) = 'Y';
          if Copy(ARecvData, 43, 1) = 'Y' then
            Result.EventImgName := Copy(ARecvData, 44, 20);
//          Result.EventTextEnable := Copy(ARecvData, 64, 1) = 'Y';
          if Copy(ARecvData, 64, 1) = 'Y' then
            Result.EventTextName := Copy(ARecvData, 65, 20);
        end;
      -21, -23 :
        begin
          Result.Msg := '네트워크 오류 KIS 서버 접속 실패.';
        end
    else
      Result.Msg := '알 수 없는 에러입니다. 에러코드:' + IntToStr(Index);
    end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

{ TWxPay }

constructor TWxPay.Create;
begin
  Log := TLog.Create;
end;

destructor TWxPay.Destroy;
begin
  Log.Free;
  inherited;
end;

function TWxPay.WeChatApproval(AInfo: TWxPaySendInfo; out ARcvInfo: TWxPayRcvInfo): Boolean;
begin
  Result := False;
end;

function TWxPay.WeChatCancelApproval(AInfo: TWxPaySendInfo; out ARcvInfo: TWxPayRcvInfo): Boolean;
begin
  Result := False;
end;

function TWxPay.WeChatQrBarCode(out ABarCd: string): Boolean;
begin
  Result := False;
end;

function TWxPay.WeChatSetInfo(ATcpAddr: AnsiString; ATcpPortNo, ASerialPortNo,
  ASerialRate: Integer): Boolean;
begin
  Result := False;
end;

{ TWeChatPay }

constructor TWeChatPay.Create;
begin
  //
end;

destructor TWeChatPay.Destroy;
begin
  //
  inherited;
end;

function TWeChatPay.CallWeChat(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean;
begin
  Result := False;
end;

function TWeChatPay.CallCancel(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean;
begin
  Result := False;
end;

function TWeChatPay.CallSearch(AInfo: TWeChatPaySendInfo; out ARecvInfo: TWeChatPayRcvInfo): Boolean;
begin
  Result := False;
end;

{ TGlobalTaxFree }

function TGlobalTaxFree.CallExec(
  AInfo: TGlobalTaxFreeSendInfo): TGlobalTaxFreeRecvInfo;
var
  SendData, RecvData: AnsiString;
begin
  if FConfig.Gubun = 'T' then   // T: 택스프리승인, S: 개시
    SendData := MakeSendData(AInfo)
  else
    SendData := MakeSendStartData(AInfo);

  Log.Write(ltDebug, ['전송전문', SendData]);
  Result.Result := DLLExec(FConfig.Gubun, SendData, RecvData);
  Log.Write(ltDebug, ['응답전문', RecvData]);

  if Result.Result then
  begin
    if FConfig.Gubun = 'T' then
      Result := MakeRecvData(RecvData)
    else
      Result := MakeRecvStartData(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.ResponseMsg := RecvData;
  end;
end;

constructor TGlobalTaxFree.Create;
begin
  Log := TLog.Create;
end;

destructor TGlobalTaxFree.Destroy;
begin
  Log.Free;
  inherited;
end;

function TGlobalTaxFree.DLLExec(AGubun, ASendData: AnsiString;
  out ARecvData: AnsiString): Boolean;
const
  TAXFREE_POS_DLL = 'GTF_COMM_DLL32.dll';
type
  TGTF_RequestApprovalExec = function(P_Addr: PAnsiChar; P_Port: Integer; RequestMsg: PAnsiChar; RequestLen: Integer; RecvMsg: PAnsiChar; ReadTimeOut: Integer): Integer; stdcall;
var
  DLLHandle: THandle;
  Exec: TGTF_RequestApprovalExec;
  sndBuf: array [0..4096] of AnsiChar;
  rcvBuf: array [0..4096] of AnsiChar;
  rtnBuf: PAnsiChar;
  Index: Integer;
  sRtnCd: AnsiString;
begin
  Result := False;
  DLLHandle := LoadLibrary(TAXFREE_POS_DLL);
  try
    @Exec := GetProcAddress(DLLHandle, 'GTF_RequestApproval');
    if Assigned(@Exec) then
    begin
      StrCopy(sndBuf,PAnsiChar(ASendData));
      Index := Exec(PAnsiChar(FConfig.TaxFreeIp), FConfig.TaxFreePort, sndBuf, strlen(sndBuf), rcvBuf, 10);
      if Index > 0 then
      begin
        ARecvData := rcvBuf;
        if AGubun = 'T' then
        begin
          sRtnCd := Copy(ARecvData,203,3);
          if sRtnCd <> '100' then
            ARecvData := GetErrorMsg(sRtnCd)
          else
            Result := True;
        end
        else
          Result := True;
      end
      else
        ARecvData := GetErrorMsg('XXX');
    end
    else
      ARecvData := TAXFREE_POS_DLL + MSG_ERR_DLL_LOAD;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function TGlobalTaxFree.CallPassportScan(out AInfo: TGlobalTaxFreeSendInfo): AnsiString;
const
  TAXFREE_POS_DLL = 'GTF_PASSPORT_COMM.dll';
type
  TOpenPort         = function(): Integer; stdcall;
  TClosePort        = function(): Integer; stdcall;
  TScan             = function(): Integer; stdcall;
  TScanCancel       = function(): Integer; stdcall;
  TReceiveData      = function(TimeOut: Integer): Integer; stdcall;
  TGetPassportInfo  = function(refPassInfo: PAnsiChar): Integer; stdcall;
  TCheckReceiveData = function(): Integer; stdcall;
var
  DLLHandle: THandle;
  OpenPortExec: TOpenPort;
  ClosePortExec: TClosePort;
  ScanExec: TScan;
  ScanCancelExec: TScanCancel;
  ReceiveDataExec: TReceiveData;
  GetPassportInfoExec: TGetPassportInfo;
  CheckReceiveDataExec: TCheckReceiveData;
  nRet: Integer;
  PassportInfo : array [0..65] of AnsiChar;
  rValue: PAnsiChar;
  ErrCk: Boolean;
  nRetry: Integer;
begin
  Result := ''; ErrCk := False; ScanCancel := False;
  DLLHandle := LoadLibrary(TAXFREE_POS_DLL);
  try
    @OpenPortExec := GetProcAddress(DLLHandle, 'OpenPort');
    if Not Assigned(@OpenPortExec) then ErrCk := True;
    @ClosePortExec := GetProcAddress(DLLHandle, 'ClosePort');
    if Not Assigned(@ClosePortExec) then ErrCk := True;
    @ScanExec := GetProcAddress(DLLHandle, 'Scan');
    if Not Assigned(@ScanExec) then ErrCk := True;
    @ScanCancelExec := GetProcAddress(DLLHandle, 'ScanCancel');
    if Not Assigned(@ScanCancelExec) then ErrCk := True;
    @ReceiveDataExec := GetProcAddress(DLLHandle, 'ReceiveData');
    if Not Assigned(@ReceiveDataExec) then ErrCk := True;
    @GetPassportInfoExec := GetProcAddress(DLLHandle, 'GetPassportInfo');
    if Not Assigned(@GetPassportInfoExec) then ErrCk := True;
    @CheckReceiveDataExec := GetProcAddress(DLLHandle, 'CheckReceiveData');
    if Not Assigned(@CheckReceiveDataExec) then ErrCk := True;
    if ErrCk then
    begin
      Result := TAXFREE_POS_DLL + MSG_ERR_DLL_LOAD;
      Exit;
    end;

    nRet := OpenPortExec();
    if(nRet > 0) then
    begin
      nRet := ScanExec();
      if(nRet > 0)then
      begin
        nRetry := 0;
        while True do
        begin
          if ScanCancel = True then
          begin
            Result := 'Scan Cancel';
            Break;
          end;
          Application.ProcessMessages;
          nRet := CheckReceiveDataExec();
          if(nRet > 0) then
          begin
             GetPassportInfoExec(PassportInfo);
             rValue := PassportInfo;
             AInfo.PassportNm := Trim(Copy(rValue,1,40));
             AInfo.PassportNo := Trim(Copy(rValue,41,9));
             AInfo.PassportNationCd := Trim(Copy(rValue,50,3));
             AInfo.PassportSex := Trim(Copy(rValue,53,1));
             AInfo.PassportBirth  := Trim(Copy(rValue,54,6));
             AInfo.PassportExpireDt := Trim(Copy(rValue,60,6));
             Break;
          end
          else if(nRet < 0) then
          begin
            Result := 'Passport Info Error';
            Break;
          end;
          if(nRetry < 120) then Delay(1000);
          Inc(nRetry);
          if(nRetry >= 120) then
          begin
            Result := 'Scan Time Out';
            ScanCancelExec();
            Break;
          end;
        end;
      end;
    end
    else
    begin
      Result := 'COM Port Open Error!';
    end;
  finally
    ClosePortExec();
    FreeLibrary(DLLHandle);
  end;
end;

function TGlobalTaxFree.GetErrorMsg(ACode: AnsiString): AnsiString;
begin
  if ACode = '100' then
    Result := '정상처리 되었습니다.'
  else if ACode = '200' then
    Result := '통신장애가 발생했습니다.'
  else if ACode = '300' then
    Result := '정보오류가 있습니다.'
  else if ACode = '400' then
    Result := '재전송이 필요합니다.'
  else
    Result := '승인실패 했습니다.';
end;

function TGlobalTaxFree.MakeRecvData(
  ARecvData: AnsiString): TGlobalTaxFreeRecvInfo;
begin
  {
  if Copy(ARecvData, 203,3) = '100' then
    Result.Result := True
  else
  begin
    Result.Result := False;
    Exit;
  end;
  }
  Result.GtGbn              := Copy(ARecvData, 1, 2);                                     // 업무구분
  Result.GtVersion          := Copy(ARecvData, 3, 10);                                    // 전문버전
  Result.GtDocCd            := Copy(ARecvData, 13, 3);                                    // 문서코드
  Result.GtSno              := Copy(ARecvData, 16, 20);                                   // 구매일련번호
  Result.GtCancel           := Copy(ARecvData, 36, 1);                                    // 구매취소여부
  Result.GtApprovalNo       := Copy(ARecvData, 37, 10);                                   // 거래승인번호
  Result.GtBizNo            := Copy(ARecvData, 47, 10);                                   // 판매자사업자번호
  Result.GtTerminalId       := Copy(ARecvData, 57, 10);                                   // 단말기ID
  Result.GtSellTime         := Copy(ARecvData, 67, 14);                                   // 판매년월일시
  Result.TotQty             := StrToIntDef(Copy(ARecvData, 81, 4), 0);                    // 판매총수량
  Result.TotSaleAmt         := StrToFloatDef(Copy(ARecvData, 85, 9), 0);                  // 판매총금액
  Result.TotRefundAmt       := StrToFloatDef(Copy(ARecvData, 94, 8), 0);                  // 환급총액
  Result.PayGbn             := Copy(ARecvData, 102, 1);                                   // 결제유형
  Result.CardNo             := Copy(ARecvData, 103, 21);                                  // 신용카드번호
  Result.ChCardGbn          := Copy(ARecvData, 124, 1);                                   // 은련카드여부
  Result.JuminNo            := Copy(ARecvData, 125, 13);                                  // 주민등록번호
  Result.PassportNm         := Copy(ARecvData, 138, 40);                                  // 여권영문이름
  Result.PassportNo         := Copy(ARecvData, 178, 9);                                   // 여권번호
  Result.PassportNationCd   := Copy(ARecvData, 187, 3);                                   // 여권국가코드
  Result.PassportSex        := Copy(ARecvData, 190, 1);                                   // 여권성별
  Result.PassportBirth      := Copy(ARecvData, 191, 6);                                   // 여권생년월일
  Result.PassportExpireDt   := Copy(ARecvData, 197, 6);                                   // 여권만료일
  Result.ResponseCd         := Copy(ARecvData, 203, 3);                                   // 응답코드
  Result.ResponseMsg        := Copy(ARecvData, 206, 60);                                  // 응답메세지
  Result.ShopNm             := Copy(ARecvData, 266, 40);                                  // 매장명
  Result.DetailCnt          := StrToIntDef(Copy(ARecvData, 306, 4), 0);                   // 물품부반복횟수
  Result.ExportExpirtDt     := Copy(ARecvData, 310, 8);                                   // 반출유효기간
  Result.RctNo              := Copy(ARecvData, 318, 30);                                  // 영수증번호
  Result.Bigo               := Copy(ARecvData, 348, 15);                                  // 비고
  Result.DetailGoodsList.DetailSNo          := Copy(ARecvData, 363, 3);                   // 일련번호
  Result.DetailGoodsList.DetailGVatGbn      := Copy(ARecvData, 366, 1);                   // 개별소비세구분
  Result.DetailGoodsList.DetailGoodsGbn     := Copy(ARecvData, 367, 2);                   // 물품코드
  Result.DetailGoodsList.DetailGoodsNm      := Copy(ARecvData, 369, 50);                  // 물품내용
  Result.DetailGoodsList.DetailQty          := StrToIntDef(Copy(ARecvData, 419, 4), 0);   // 수량
  Result.DetailGoodsList.DetailDanga        := StrToFloatDef(Copy(ARecvData, 423, 9), 0); // 단가
  Result.DetailGoodsList.DetailSaleAmt      := StrToFloatDef(Copy(ARecvData, 432, 9), 0); // 판매가격
  Result.DetailGoodsList.DetailVat          := StrToFloatDef(Copy(ARecvData, 441, 8), 0); // 부가가치세
  Result.DetailGoodsList.DetailGVat         := StrToFloatDef(Copy(ARecvData, 449, 8), 0); // 개별소비세
  Result.DetailGoodsList.DetailGEdVat       := StrToFloatDef(Copy(ARecvData, 457, 8), 0); // 교육세
  Result.DetailGoodsList.DetailGFmVat       := StrToFloatDef(Copy(ARecvData, 465, 8), 0); // 농어촌특별세
  Result.DetailGoodsList.DetailBigo         := Copy(ARecvData, 473, 16);                  // 비고
end;

function TGlobalTaxFree.MakeRecvStartData(
  ARecvData: AnsiString): TGlobalTaxFreeRecvInfo;
begin
  Result.GtTerminalId := Trim(Copy(ARecvData,26,10));
end;

function TGlobalTaxFree.MakeSendStartData(
  AInfo: TGlobalTaxFreeSendInfo): AnsiString;
var
  Index, SeqNo: Integer;
begin
  // 전문 Type
  Result := RPadB(AInfo.GtGbn, 2) +                              // 업무구분(2)
            RPadB(AInfo.GtVersion, 10) +                         // 전문버전(10)
            '901' +                                              // 문서코드(3) 요청:101, 취소:301, 901: 개시
            RPadB(AInfo.GtBizNo, 10) +                           // 판매자사업자번호(10)
            RPadB(AInfo.GtTerminalId, 10) +                      // 단말기ID (10)
            RPadB(AInfo.GtSellTime, 14) +                        // 판매년월시(14)
            RPadB(AInfo.ResponseCd, 3) +                         // 응답코드(3)
            RPadB(AInfo.ResponseMsg, 60) +                       // 응답메시지(60)
            RPadB(AInfo.ShopNm, 40);                             // 매장명(40)
end;

procedure TGlobalTaxFree.SetConfig(AValue: TGlobalTaxFreeConfigInfo);
begin
  FConfig := AValue;
end;

function TGlobalTaxFree.MakeSendData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
begin
  // 전문 Type
  Result := RPadB(AInfo.GtGbn, 2) +                              // 업무구분(2)
            RPadB(AInfo.GtVersion, 10);                          // 전문버전(10)

  if AInfo.Approval then
    Result := Result + '101'                                     // 문서코드(3) 요청:101, 취소:301, 901: 개시
  else
    Result := Result + '301';                                    // 문서코드(3) 요청:101, 취소:301, 901: 개시

  Result:= Result + RPadB(AInfo.GtSno, 20);                      // 구매일련번호(20)

  if AInfo.Approval then
    Result:= Result + 'N'                                        // 구매취소여부(1) 판매: N, 취소: Y
  else
    Result:= Result + 'Y';

  Result:= Result + RPadB(AInfo.GtApprovalNo, 10) +                               // 거래승인번호(10)
            RPadB(AInfo.GtBizNo, 10) +                                            // 판매자사업자번호(10)
            RPadB(AInfo.GtTerminalId, 10) +                                       // 단말기ID (10)
            RPadB(AInfo.GtSellTime, 14) +                                         // 판매년월시(14)
            FormatFloat('0000', Abs(AInfo.TotQty)) +                              // 판매총수량(4)
            FormatFloat('000000000', Abs(AInfo.TotSaleAmt)) +                     // 판매총금액(9)
            FormatFloat('00000000', Abs(AInfo.TotRefundAmt)) +                    // 환급총액(8)
            RPadB(AInfo.PayGbn, 1) +                                              // 결제유형(1)
            RPadB(AInfo.CardNo, 21) +                                             // 결제신용카드번호(21)
            RPadB(AInfo.ChCardGbn, 1) +                                           // 은련카드여부(1)
            RPadB(AInfo.JuminNo, 13) +                                            // 주민번호(13)
            RPadB(AInfo.PassportNm, 40) +                                         // 여권영문이름(40)
            RPadB(AInfo.PassportNo, 9) +                                          // 여권번호(9)
            RPadB(AInfo.PassportNationCd, 3) +                                    // 여권국가코드(3)
            RPadB(AInfo.PassportSex, 1) +                                         // 여권성별(1)
            RPadB(AInfo.PassportBirth, 6) +                                       // 여권생년월일(6)
            RPadB(AInfo.PassportExpireDt, 6) +                                    // 여권만료일(6)
            RPadB(AInfo.ResponseCd, 3) +                                          // 응답코드(3)
            RPadB(AInfo.ResponseMsg, 60) +                                        // 응답메시지(60)
            RPadB(AInfo.ShopNm, 40) +                                             // 매장명(40)
            FormatFloat('0000', 1) +                                              // 물품부반복횟수(4)
            RPadB(AInfo.ExportExpirtDt, 8) +                                      // 반출유효기간(8)
            RPadB(AInfo.RctNo, 30) +                                              // 영수증번호(30)
            RPadB(AInfo.Bigo, 15) +                                               // 비고(15)
            RPadB(AInfo.DetailGoodsList.DetailSNo, 3) +                           // 물품일련번호(3)
            RPadB(AInfo.DetailGoodsList.DetailGVatGbn, 1) +                       // 개별소비세구분(1)
            RPadB(AInfo.DetailGoodsList.DetailGoodsGbn, 2) +                      // 물품코드(2)
            RPadB(AInfo.DetailGoodsList.DetailGoodsNm, 50) +                      // 물품명(50)
            FormatFloat('0000', Abs(AInfo.DetailGoodsList.DetailQty)) +           // 수량(4)
            FormatFloat('000000000', Abs(AInfo.DetailGoodsList.DetailDanga)) +    // 단가(9)
            FormatFloat('000000000', Abs(AInfo.DetailGoodsList.DetailSaleAmt)) +  // 판매가격(9)
            FormatFloat('00000000', Abs(AInfo.DetailGoodsList.DetailVat)) +       // 부가가치세(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGVat) +           // 개별소비세(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGEdVat) +         // 교육세(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGFmVat) +         // 농어촌특별세(8)
            RPadB(AInfo.DetailGoodsList.DetailBigo, 16);                          // 비고(16)
end;

{ TVanCatApprove }

function TVanCatApprove.CashDrawOpen: Boolean;
begin
  Result := False;
end;

constructor TVanCatApprove.Create;
begin
  FComPort := TComPort.Create(nil);
end;

destructor TVanCatApprove.Destroy;
begin
  FComPort.Free;
  inherited;
end;

function TVanCatApprove.PrintOut(APrintData: AnsiString): Boolean;
begin
  Result := False;
end;


{ TKTISTaxFree }

function TKTISTaxFree.CallExec(AInfo: TKTISTaxFreeSendInfo): TKTISTaxFreeRecvInfo;
const
  KTIS_POS_DLL = 'KTIS_PassScan.dll';
type  //cdecl
  TScanPassportEncrypt = function(APort: PAnsiChar; AMilliSec: Integer; ABufData: PAnsiChar; ABufSize: Integer; AScannerType: Integer; AKeyText: PAnsiChar): Integer; stdcall;
  TSetDcKey = function(AKey: PAnsiChar): Integer; stdcall;
  TEncrypt = function(OrgData: PAnsiChar; OrgSize: Integer; BufData: PAnsiChar; BufSize: Integer): Integer; stdcall;
  TDncrypt = function(OrgData: PAnsiChar; OrgSize: Integer; BufData: PAnsiChar; BufSize: Integer): Integer; stdcall;
var
  SendData, RecvData, APort: AnsiString;
  DLLHandle: THandle;
  Exec: TScanPassportEncrypt;
  ExecSetKey: TSetDcKey;
  ExecEncrypt: TEncrypt;
  ExecDncrypt: TDncrypt;
  PassPortKeyData: array[0..31] of AnsiChar;         // 여권번호 암호화 데이터 길이(32)
  PassPortReadData: array[0..299] of AnsiChar;       // 여권리더기로 받은 데이터 길이(300)
  Index: Integer;
begin
  AInfo.KeyIn := Length(AInfo.PassportNo) >= 9 ;
  // 암호키
  if not AInfo.KeyIn then
    AInfo.GtRcpTradeNo := AInfo.GtBizNo + AInfo.GtPosNo + AInfo.GtSellTime;
  if AInfo.IsRefund then
  begin
    Index := 0;
    try
      try
        DLLHandle := LoadLibrary(KTIS_POS_DLL);
//        if False then
//        begin
//          ExecSetKey := GetProcAddress(DLLHandle, 'SetDcKey');
//          if Assigned(@ExecSetKey) then
//          begin
//            ExecSetKey(PAnsiChar(AInfo.GtRcpTradeNo));
//
//            ExecEncrypt := GetProcAddress(DLLHandle, 'Encrypt');
//            if Assigned(@ExecEncrypt) then
//            begin
//              ExecEncrypt(PAnsiChar(AInfo.PassportNo), 9, PassPortKeyData, 32);
//            end;
//          end;
//          AInfo.PassportNo := PassPortKeyData;
//        end;
        if AInfo.ReaderInfo then
        begin
          if AInfo.PassportNo = EmptyStr then
          begin
            ShowMessageForm('여권인식기에 여권을 태그하여 주십시오.' + #13#10#13#10 + '잠시만 기다려 주시기 바랍니다.', True);
            Exec := GetProcAddress(DLLHandle, 'ScanPassportEncrypt');
            if Assigned(@Exec) then
            begin
              APort := 'COM' + IntToStr(AInfo.Port);
              Index := Exec(PAnsiChar(APort), 10000, PassPortReadData, 300, 1, PAnsiChar(AInfo.GtRcpTradeNo));
              AInfo.PassportNo := PassPortReadData;
              Log.Write(ltInfo, ['여권정보 리딩정보 : ', AInfo.PassportNo]);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          Log.Write(ltInfo, ['여권정보 리딩 실패', E.Message]);
        end;
      end;
    finally
      HideMessageForm;
      FreeLibrary(DLLHandle);
    end;
  end;

  // 전송전문
  SendData := MakeSendData(AInfo);
  Index := Length(SendData);

  RecvData := EmptyStr;
  Result.Result := DLLExec(FConfig.Gubun, SendData, RecvData);
  Result.GtRcpTradeNo := AInfo.GtRcpTradeNo;
  // 응답처리
  if Result.Result then
  begin
    if AInfo.IsRefund then
      Result := MakeRecvData(RecvData, True)
    else
      Result := MakeRecvData(RecvData, False);
    Result.Bigo := AInfo.PassportNo;
  end
  else
  begin
    Result.Result := False;
    Result.ErrorCd := Copy(RecvData, 12, 3);
    Result.ResponseMsg := RecvData;
  end;
end;

constructor TKTISTaxFree.Create;
begin
  Log         := TLog.Create;
  IdTaxClient := TIdTCPClient.Create(nil);
end;

destructor TKTISTaxFree.Destroy;
begin
  Log.Free;
  IdTaxClient.Free;
  inherited;
end;

function TKTISTaxFree.DLLExec(AGubun, ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
begin
  try
    Result      := False;
    IdTaxClient := TIdTCPClient.Create(nil);
    IdTaxClient.Disconnect;

    IdTaxClient.Port := SERVER_PORT_KT_TEST;
    if VanModul.RealMode then
      IdTaxClient.Host := SERVER_IP_KT_REAL
    else
      IdTaxClient.Host := SERVER_IP_KT_TEST;

    IdTaxClient.ConnectTimeout := 10000;
    IdTaxClient.ReadTimeout := 10000;
    IdTaxClient.Connect();

    IdTaxClient.IOHandler.DefStringEncoding := IndyTextEncoding(20949);
    IdTaxClient.IOHandler.Write(ASendData);
    Sleep(1000);
//    Log.Write('길이 : ' + Length(ASendData));

    //성공 시에는 길이만큼 받을 수 있지만 전문오류나 값이 잘못되어
    //실패로 떨어질 경우 길이로 받으면 리턴값이 오지 않는다.
    ARecvData := IdTaxClient.IOHandler.ReadString(Length(ASendData));
    if (Copy(ARecvData, 9, 1) = '0') then
      Result := True;

    IdTaxClient.Disconnect;
  except
    on E: Exception do
    begin
      ARecvData := IdTaxClient.IOHandler.ReadString(300);
      Log.Write(ltInfo, ['환급실패', ARecvData]);
      ARecvData := 'Error Code=' + Copy(ARecvData, 10, 3) + #13#10 + Trim(Copy(ARecvData, 13, 120));
    end;
  end;
end;

function TKTISTaxFree.GetErrorMsg(ACode: AnsiString): AnsiString;
begin
  if ACode = '001' then
    Result := '정의되지 않은 메시지 번호'
  else if ACode = '002' then
    Result := '정의되지 않은 메시지 버전'
  else if ACode = '003' then
    Result := '미확인 연동주체코드'
  else if ACode = '004' then
    Result := '미확인 연동타입코드'
  else if ACode = '005' then
    Result := '가맹점정보없음'
  else if ACode = '006' then
    Result := '장비정보없음'
  else if ACode = '007' then
    Result := '필수데이터부족'
  else if ACode = '008' then
    Result := '전문 데이터 부적합 오류'
  else if ACode = '099' then
    Result := '미정의오류'
  else if ACode = '101' then
    Result := '구매번호없음'
  else if ACode = '102' then
    Result := '전표유효기간경과'
  else if ACode = '103' then
    Result := '구매합산금액불일치'
  else if ACode = '104' then
    Result := '3만원미만'
  else if ACode = '105' then
    Result := '이미 사용된 가맹점 구매일련번호'
  else if ACode = '106' then
    Result := '물품코드오류'
  else if ACode = '107' then
    Result := '합산불가전표포함'
  else if ACode = '108' then
    Result := '반출된구매번호'
  else if ACode = '109' then
    Result := '환급된구매번호'
  else if ACode = '110' then
    Result := '도심환급된구매번호'
  else if ACode = '111' then
    Result := '부가세 오차 오류'
  else if ACode = '112' then
    Result := '합산수량 불일치'
  else
    Result := '승인실패 했습니다.';
end;

function TKTISTaxFree.MakeRecvData(ARecvData: AnsiString; ARefund: Boolean): TKTISTaxFreeRecvInfo;
begin
  Result.Result := Copy(ARecvData, 9, 1) = '0';
  Result.ErrorCd := Copy(ARecvData, 10, 3);
  Result.GtVersion := Copy(ARecvData, 5, 4);
  Result.GtSno := Copy(ARecvData, 211, 30);

  Result.ResponseCd := Copy(ARecvData, 10, 3);
  Result.ResponseMsg := Copy(ARecvData, 13, 120);

  if Result.Result then
  begin
    Result.GtApprovalNo     := Copy(ARecvData, 301, 20);            //승인번호
    Result.PassportNo       := Copy(ARecvData, 324, 32);            //여권번호 암호화
    Result.PassportNationCd := Copy(ARecvData, 356, 3);             //국적
    Result.PassportNm       := Copy(ARecvData, 359, 40);            //여권이름
    Result.PassportSex      := Copy(ARecvData, 411, 1);             //여권성별
    Result.PassportExpireDt := Copy(ARecvData, 399, 6);             //여권만료일
    Result.PassportBirth    := Copy(ARecvData, 405, 6);             //여권생년월일
    Result.RefundAmt        := StrToCurr(Copy(ARecvData, 482, 10)); //즉시환급 금액
    Result.BeforeRefundAmt  := StrToCurr(Copy(ARecvData, 452, 10)); //이전즉시환급 금액
    Result.AfterRefundAmt   := StrToCurr(Copy(ARecvData, 462, 10)); //이후즉시환급 금액
  end;
end;

function TKTISTaxFree.MakeSendData(
  AInfo: TKTISTaxFreeSendInfo): AnsiString;
var
  sBody, vQty, sGubun: AnsiString;
  TmpAmt, nLen: Integer;

  function MakeApprovalBodySave(ADateTime: AnsiString): AnsiString; // 환급전표발급 Body  ( 승인시 )
  var
    sPayGubun: AnsiString;
    Index: Integer;
    cCashAmtSum, cCardAmtSum, cTaxFreeAmtSum, cRefundAmt: Currency;
  begin
    //AInfo.RefundAmt := 1500;                             // 지워야할 값 이미 환급여부를 확인하고 받은 값
    cTaxFreeAmtSum  := AInfo.TotFreeAmt;                                        // 면세금액 합계
    cCashAmtSum     := AInfo.TotCashAmt;                                        // 현금매출
    cCardAmtSum     := AInfo.TotCardAmt;                                        // 카드매출
    cRefundAmt      := AInfo.RefundAmt;                                         // 즉시환급 금액
    if cTaxFreeAmtSum > 0 then                                                  // 면세 금액이 있을경우
    begin
      if cCashAmtSum  >= cTaxFreeAmtSum then                                    // 현금액이 면세금액보다 많을경우 현금 - 면세
        cCashAmtSum := cCashAmtSum - cTaxFreeAmtSum
      else                                                                      // 카드 - 면세 - 현금
      begin
        cCashAmtSum := 0;
        cCardAmtSum := cCardAmtSum - cTaxFreeAmtSum  - cCashAmtSum;
      end;
    end;

    if (cCashAmtSum = 0) and (cCardAmtSum <> 0) then
      sPayGubun := 'C' // 카드
    else if (cCardAmtSum = 0) and (cCashAmtSum <> 0) then
      sPayGubun := 'M'// 현금
    else
      sPayGubun := 'A'; // 현금 + 카드 + 전자화폐
//    else
//      sPayGubun := 'E'; // 전자화폐

    nLen  := ByteLen(AInfo.ShopNm);
    Result := Result + AInfo.ShopNm + RPadB('', 50 - nLen, ' '); // shop_nm(50)

    Result := Result + IfThen(AInfo.IsRefund, 'D', 'A');                        // T: 즉시, F: 사후

    // 0: 한도조회, 1: 즉시환급 가승인, 2: 승인
    // 0: 여권정보없음, 1: 여권정보(암호화 AES-256), 2: 여권리더기 정보
    if AInfo.IsRefund then
    begin
      if AInfo.GtGbn = 'S' then
        Result := Result + '02'   // 조회
      else
      begin
        if AInfo.KeyIn then
          Result := Result + '21'  // 승인
        else
          Result := Result + '22';  // 승인
      end;
    end
    else
    begin
      if AInfo.GtGbn = 'S' then
        Result := Result + '00'            // 조회
      else
      begin
        if AInfo.ReaderInfo then
          Result := Result + '22'          // 승인(여권정보있음)
        else
          Result := Result + '20';         // 승인(여권정보없음)
      end;
    end;

    if AInfo.KeyIn and AInfo.IsRefund then
    begin   // 여권에 있는 데이터
      Result := Result + RPadB(AInfo.PassportNo, 32, ' ');                      // 여권정보(암호화)
      Result := Result + AInfo.PassportNationCd;                                // 국가코드(3)
      Result := Result + RPadB(AInfo.PassportNm, 40, ' ');                      // 이름
      Result := Result + AInfo.PassportBirth;                                   // 여권만료일
      Result := Result + AInfo.PassportExpireDt;                                // 여권생일
      Result := Result + AInfo.PassportSex;                                     // 성별
    end
    else  // 사후환급 여권정보
      Result := Result + RPadB('', 88, ' ');

    // 기본값 0 즉시환급은 공백
//    Result := Result + IfThen(AInfo.GtGbn = 'K', ' ', '0');                     // 통합포스 DLL , Cube 여권리더기 , 3M CR100
    Result := Result + IfThen(AInfo.IsRefund, '0', ' ');                     // 통합포스 DLL , Cube 여권리더기 , 3M CR100
    // 기본값 0128 고정 즉시환급은 공백
//    Result := Result + IfThen(AInfo.GtGbn = 'K', '    ', '0128');               // 여권데이터 길이 0: 0128, 1: 0128, 2: 0152
    Result := Result + IfThen(AInfo.IsRefund, '0128', '0000');               // 여권데이터 길이 0: 0128, 1: 0128, 2: 0152

    if (not AInfo.IsRefund) or AInfo.KeyIn then
      Result := Result + RPadB('', 300, ' ') // 여권데이터
    else
      Result := Result + RPadB(AInfo.PassportNo, 300, ' '); // 여권데이터
//      Result := Result + RPadB(IfThen(AInfo.GtGbn = 'K', '', AInfo.PassportNo), 300, ' '); // 여권데이터
    Result := Result + RPadB('', 51, ' ');                                                 // 예약필드 공백처리
                      Log.Write(ltInfo, ['AInfo.GtSno', AInfo.GtSno]);
    Result := Result + FormatFloat('000', 1);                                                              // 리스트 사이즈
    Result := Result + RPadB(AInfo.GtSno , 50, ' ');                                                       // merch_buy_no(50)  POS구매일련번호
    Result := Result + LPadB(FloatToStr(cCashAmtSum), 10, '0');                                            // sale_cash_amt(10) 현금결제금액
    Result := Result + LPadB(FloatToStr(cCardAmtSum), 10, '0');                                            // sale_card_amt(10) 카드결제금액
    Result := Result + LPadB(FloatToStr(AInfo.TotECashAmt), 10, '0');                                      // sale_etc_amt(10) 전자화폐금액
    Result := Result + LPadB('', 42, ' ');                                                                 // filler(42)
    Result := Result + ADateTime;                                                                          // sale_dttm(14)  판매일시
    Result := Result + sPayGubun;                                                                          // setl_typ_cd(1) C:카드, M:현금, A:현금+카드
    Result := Result + LPadB(IntToStr(Abs(AInfo.TotQty)), 10, '0');                                        // sale_tot_qty(10)  판매총수량
    Result := Result + LPadB(FloatToStr(Abs(AInfo.TotSaleAmt)), 10, '0');                                  // sale_tot_amt(10)  판매총금액
    Result := Result + LPadB(FloatToStr(Abs(AInfo.TotSumVat)), 10, '0');                                   // vat_sum(10)  부가가치세합계
    Result := Result + LPadB('', 10, '0');                                                                 // ic_tax_sum(10) 개별소비세합계
    Result := Result + LPadB('', 10, '0');                                                                 // ed_tax_sum(10) 교육세합계
    Result := Result + LPadB('', 10, '0');                                                                 // ffvs_tax_sum(10) 농어촌특별세합계
    Result := Result + FormatFloat('000', AInfo.TotCntSale);
//    Result := Result + LPadB(IntToStr(Length(AInfo.DetailGoodsList)), 3, '0');                                          // item_arr_size(3) 구매물품정보개수

    Log.Write('구매일련번호: ' + AInfo.GtSno);

    for Index := Low(AInfo.DetailGoodsList) to High(AInfo.DetailGoodsList) do
    begin
      nLen  := ByteLen(AInfo.DetailGoodsList[Index].DetailGoodsNm);
      Result := Result + AInfo.DetailGoodsList[Index].DetailGoodsNm + RPadB('', 200 - nLen, ' '); // prod_cts(200) 상품명
//      Result := Result + AInfo.DetailGoodsList[Index].DetailGoodsNm + RPadB('', 200 - nLen, ' '); // prod_cts(200) 상품명
//      Log.Write(Format('상품명정보: Bytes=%d, Length=%d, Product=%s', [nByte, nLen, AInfo.DetailGoodsList[Index].DetailGoodsNm]));

      Result := Result + RPadB(AInfo.DetailGoodsList[Index].DetailGoodsGbn, 30, ' ');                      // prod_cd(30)   상품코드
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailQty);                // qty(10) 수량
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailDanga);              // uprice(10) 단가
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailSaleAmt);            // sale_price(10) 판매가격
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailVat);                // vat(10) 부가가치세
      Result := Result + LPadB('', 10, '0');                                                               // ic_tax(10) 개별소비세
      Result := Result + LPadB('', 10, '0');                                                               // ed_tax(10) 교육세
      Result := Result + LPadB('', 10, '0');                                                               // ffvs_tax(10) 농어촌특별세
      Result := Result + LPadB('', 100, ' ');                                                              // 세관물품관리코드 + 공백
    end;
  end;
  function MakeApprovalBodyCancel(AKisNo: AnsiString): AnsiString;                      // 환급전표발급 Body  ( 취소시 )
  begin
    Result := RPadB(AKisNo, 20, ' ');
    Result := Result + IfThen(AInfo.IsRefund, 'D', 'A');
    Result := Result + LPadB('', 179, ' ');
  end;
begin
  if AInfo.Approval then
    sGubun := 'B107'
  else
    sGubun := 'C107';

  Result := sGubun;                                       // msg_type(4)
  Result := Result + 'V001';                              // version(4)
  Result := Result + ' ';                                 // result(1)
  Result := Result + '   ';                               // err_cd(3)
  Result := Result + LPadB('', 120, ' ');                 // err_msg(120)
  Result := Result + Copy(AInfo.GtSellTime, 3,6);         // msg_send_ymd(6)
  Result := Result + Copy(AInfo.GtSellTime, 9,6);         // msg_send_hms(6)
  Result := Result + AInfo.GtTerminalId;                  // link_gb_cd(4)
  Result := Result + '01';                                // link_typ_cd(2) 01:POS, 02:CAT
  Result := Result + AInfo.GtBizNo;                       // buss_no(10)
  Result := Result + RPadB(AInfo.ShopCd, 20, ' ');        // shop_no(20)
  Result := Result + RPadB(AInfo.GtPosNo, 30, ' ');       // device_id(30)
  Result := Result + RPadB(AInfo.GtRcpTradeNo, 30, ' ');  // tr_no(30) 거래고유번호
  Result := Result + LPadB('', 54, ' ');                  // resv_header(54)

  //sTmp + sTime (판매일시): 이 부분 맞게 수정할 것
  if AInfo.Approval then
    sBody := MakeApprovalBodySave(AInfo.GtSellTime)
  else
    sBody := MakeApprovalBodyCancel(AInfo.GtApprovalNo);

  Result := Result + LPadB(IntToStr(Length(sBody)), 6, '0');  // body_len(6)  body파트의 길이
  Result := Result + sBody;
end;

procedure TKTISTaxFree.SetConfig(AValue: TKTISTaxFreeConfigInfo);
begin
  FConfig := AValue;
end;

{ TKICCTaxFree }

function TKICCTaxFree.CallExec(AInfo: TKICCTaxFreeSendInfo): TKICCTaxFreeRecvInfo;
  procedure MakeScanData(AScanData: Ansistring);
  var
    sLine1, sLine2, sCutData: Ansistring;
  begin
    sLine1 := Copy(AScanData, 18, 44);
    sLine2 := Copy(AScanData, 74, 44);
    sCutData := Copy(sLine1, 6, 39);
    AInfo.PassportNm := StringReplace(sCutData, '<', ' ', [rfReplaceAll]); // 여권영문이름
    AInfo.PassportNo := Copy(sLine2, 1, 9);            // 여권번호
    AInfo.PassportNationCd := Copy(sLine2, 11, 3);      // 여권국가코드
  end;
var
  AGubun, SendData, RecvData, ScanData, sErrMsg: AnsiString;
begin
  // 전문을 만든다.
  if (AInfo.IsRefund) and (AInfo.PassportNo = EmptyStr)  then
  begin
    if not ShowQuestionForm2('여권인식기에 여권을 태그하여 주십시오.', ScanData, sErrMsg) then
    begin
      Result.Result := False;
      if (sErrMsg <> '') then
        Result.ResponseMsg := sErrMsg
      else
        Result.ResponseMsg := '여권 인식을 취소하였습니다.';

      Exit;
    end;
    MakeScanData(ScanData);
  end;

  SendData := MakeSendData(AInfo);
  AGubun := IntToStr(GetSeqNo);
  if DLLExec(AGubun, SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvData(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.ResponseMsg := RecvData;
  end;
end;

constructor TKICCTaxFree.Create;
begin
  Log         := TLog.Create;
  IdTaxClient := TIdTCPClient.Create(nil);
end;

destructor TKICCTaxFree.Destroy;
begin
  Log.Free;
  IdTaxClient.Free;
  inherited;
end;

function TKICCTaxFree.DLLExec(ATrNo, ASendData: AnsiString;
  out ARecvData: AnsiString): Boolean;
var
  DLLHandle: THandle;
  Exec: TKicc_Approval;
  RecvData: array[0..4096] of AnsiChar;
  ErrMsg: array[0..4096] of AnsiChar;
  RetCode: Integer;
  AInfo: TKICCTaxFreeConfigInfo;
begin
  Result := False;
  DLLHandle := LoadLibrary(KICC_TRS_DLL_NAME);

  if VanModul.RealMode then
  begin
    AInfo.HostIP := SERVER_IP_KICC_REAL;
    AInfo.HostPort := SERVER_PORT_KICC_REAL;
  end
  else
  begin
    AInfo.HostIP := SERVER_IP_KICC_TEST;
    AInfo.HostPort := SERVER_PORT_KICC_TEST;
  end;

  Config := AInfo;

  try
    @Exec := GetProcAddress(DLLHandle, 'Kicc_Approval');
    if Assigned(@Exec) then
    begin
  	  RetCode := Exec(3, PAnsiChar(ASendData), Length(ASendData),	'', '', 3, RecvData, ErrMsg, PAnsiChar(Config.HostIP), Config.HostPort, 0, 'KICC', PAnsiChar(ATrNo));
      ARecvData := RecvData;
      if RetCode >= 0 then
        Result := True
      else
        ARecvData := GetErrorMsg(RetCode);
    end
    else
      ARecvData := KICC_TRS_DLL_NAME + MSG_ERR_DLL_LOAD;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function TKICCTaxFree.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    -1 : Result := '통신 실패';
    -2000 : Result := '통신 실패';
    -3000 : Result := '가맹점수신 오류';
  else
    Result := '알수 없는 에러';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TKICCTaxFree.GetParsingValue(ACode, ARecvData: string): string;
var
  Index, Count: Integer;
begin
  Result := '';
  Index := Pos(ACode + '=', ARecvData);
  if Index > 0 then
  begin
    ARecvData := Copy(ARecvData, Index + Length(ACode) + 1, Length(ARecvData));
    Count := Pos(';', ARecvData) - 1;
    Result := LeftStr(ARecvData, Count);
  end;
end;

function TKICCTaxFree.MakeSendData(AInfo: TKICCTaxFreeSendInfo): AnsiString;
var
  sPayGubun, sDetailGoodsNm: AnsiString;
  cCashAmtSum, cCardAmtSum, cDetailDanga, cDetailSaleAmt, cDetailVat: Currency;
  nIndex, nLen, nDetailQty: integer;
begin
  cCashAmtSum     := AInfo.TotCashAmt;                                        // 현금매출
  cCardAmtSum     := AInfo.TotCardAmt;                                        // 카드매출
  nLen            := 0;

  if (cCashAmtSum = 0) and (cCardAmtSum <> 0) then
    sPayGubun := 'C' // 카드
  else if (cCardAmtSum = 0) and (cCashAmtSum <> 0) then
    sPayGubun := 'M'// 현금
  else
    sPayGubun := 'X'; // 현금 + 카드 + 전자화폐

  Result := 'S01=EX;';
  Result := Result + 'S02=' + AInfo.GtGbn + ';';
  Result := Result + 'S03=' + ';';
  Result := Result + 'S04=' + IfThen(AInfo.IsRefund, 'PR', '40') + ';';
  Result := Result + 'S05=' + AInfo.GtTerminalId + ';';
  Result := Result + 'S08=' + IfThen(AInfo.KeyIn, '@', '') + ';';
  Result := Result + 'S09=' + AInfo.PassportNo + ';';
  Result := Result + 'S11=' + '00' + ';';
  Result := Result + 'S12=' + StrToAnsiStr(CurrToStr(AInfo.TotSaleAmt)) + ';';
  Result := Result + 'S13=' + FormatDateTime('yymmdd', Now) + ';';
  Result := Result + 'S14=' + AInfo.GtApprovalNo + ';';
  if AInfo.GtGbn <> 'T2' then
    Result := Result + 'S15=' + Copy(AInfo.GtSellTime, 3,6) + ';'
  else
    Result := Result + 'S15=' + Copy(AInfo.GtSno, 3,6) + ';';
  if (not AInfo.KeyIn) and (AInfo.IsRefund) then
    Result := Result + 'S16=' + AInfo.PassportNm + '#' + AInfo.PassportNo + '#' + AInfo.PassportNationCd + '#' + '' + ';'
  else
    Result := Result + 'S16=' + '' + '#' + '' + '#' + '' + '#' + '' + ';';
  Result := Result + 'S17=' + AInfo.GtBizNo + '#' + AInfo.ShopNm + '#' + AInfo.SellerName + '#' + AInfo.SellerAddr + '#' + AInfo.SellerTelNo + ';';
  Result := Result + 'S18=' + StrToAnsiStr(CurrToStr(AInfo.TotSumVat)) + '#' + '' + '#' + '' + '#' + '' + ';';
  Result := Result + 'S19=' + StrToAnsiStr(CurrToStr(AInfo.TotQty)) + ';';
  Result := Result + 'S23=' + IfThen(AInfo.IsRefund, '0', '1') + sPayGubun + ';';
  if (High(AInfo.DetailGoodsList) < 9) then
    Result := Result + 'S26=' + FormatFloat('000', AInfo.TotCntSale)
  else
    Result := Result + 'S26=' + FormatFloat('000', 10);

  for nIndex := Low(AInfo.DetailGoodsList) to High(AInfo.DetailGoodsList) do
  begin
    if nLen < 9 then
    begin
      nLen := nLen + 1;
//      Result := Result + AInfo.DetailGoodsList[Index].DetailSNo + '^';
      Result := Result + FormatFloat('000', nLen) + '^';
      Result := Result + AInfo.DetailGoodsList[nIndex].DetailGoodsNm + '^'; // prod_cts(200) 상품명
      Result := Result + FormatFloat('000000', AInfo.DetailGoodsList[nIndex].DetailQty) + '^';                // qty(10) 수량
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailDanga) + '^';              // uprice(10) 단가
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailSaleAmt) + '^';            // sale_price(10) 판매가격
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailVat) + '^';                // vat(10) 부가가치세
      Result := Result + '0^';
      Result := Result + '0^';
      Result := Result + '0#';
    end
    else
    begin
      nLen := nLen + 1;
      sDetailGoodsNm := '기타';
      nDetailQty     := nDetailQty + AInfo.DetailGoodsList[nIndex].DetailQty;
      cDetailDanga   := cDetailDanga + AInfo.DetailGoodsList[nIndex].DetailDanga;
      cDetailSaleAmt := cDetailSaleAmt + AInfo.DetailGoodsList[nIndex].DetailSaleAmt;
      cDetailVat     := cDetailVat + AInfo.DetailGoodsList[nIndex].DetailVat;
      if nLen = AInfo.TotCntSale then
      begin
        Result := Result + FormatFloat('000', 10) + '^';
        Result := Result + sDetailGoodsNm + '^';
        Result := Result + FormatFloat('000000', nDetailQty) + '^';
        Result := Result + FormatFloat('000000000000', cDetailDanga) + '^';
        Result := Result + FormatFloat('000000000000', cDetailSaleAmt) + '^';
        Result := Result + FormatFloat('000000000000', cDetailVat) + '^';
        Result := Result + '0^';
        Result := Result + '0^';
        Result := Result + '0#';
      end;
    end;
  end;
end;

procedure TKICCTaxFree.SetConfig(AValue: TKICCTaxFreeConfigInfo);
begin
  FConfig := AValue;
end;

function TKICCTaxFree.MakeRecvData(ARecvData: AnsiString; ARefund: Boolean = False): TKICCTaxFreeRecvInfo;
begin
  // 에러코드
  Result.Code := GetParsingValue('R02', ARecvData);
  // 응답메세지
  Result.Msg := Trim(GetParsingValue('R20', ARecvData));
  Result.ResponseMsg := Trim(GetParsingValue('R20', ARecvData));
  // 승인번호
  Result.GtApprovalNo := GetParsingValue('R12', ARecvData);
  // 구매일련번호
  Result.GtSno := GetParsingValue('R11', ARecvData);
  // 거래일시
  Result.TransDateTime := GetParsingValue('R10', ARecvData);
  // 여권번호
  Result.PassportNo := GetParsingValue('R25', ARecvData);
  // 국적코드
  Result.PassportNationCd := Copy(Result.PassportNo, 1, 3);
  Result.PassportNo := Copy(Result.PassportNo, 4, Length(Result.PassportNo));
  // 여권이름
  Result.PassportNm := GetParsingValue('R23', ARecvData);

  // 승인금액
  TryStrToCurr(GetParsingValue('R13', ARecvData), Result.AgreeAmt);
  // 환급액
  TryStrToCurr(GetParsingValue('R14', ARecvData), Result.RefundAmt);
  // 성공여부
  Result.Result := GetParsingValue('R07', ARecvData) = '0000';
end;

end.
