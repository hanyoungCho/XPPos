(*******************************************************************************

  �� ���� ���

  TVanModul (�ܺ� ���� ���α׷��� �������̽� �ϴ� Ŭ����)
    - ī��,����,��ǥ,ĳ���� �� ����ó��
    - ����/���αݾ��� ó��
    - ����/��Ʈ�ʽ� ���� ������ ó��
    - ����/�׽�Ʈ ���� ���� ȯ�� ������ ����

  TVanApprove (�� ���� ���� �߻� Ŭ���� �������� ����)
    - �� ��纰 ���� ����/���� ���� ó�� ���� �ۼ��� �� Ŭ������ ��� �޾� �����Ѵ�.
    - TVanModul ���� �� Ŭ������ �߻� �޼ҵ带 ȣ���ϰ� �ȴ�.

             �ſ����,����,��ǥ��ȸ,���е�,����,����,��Ʈ�ʽ�,����(X),Ƽ�Ӵ�,ĳ�ú�,IC��������,CAT����,��������
  KFTC(�ݰ��)   O      O      O       O     X    X      X       X       X      X      O         O
  Kicc           O      O      O       O                                                         O
  Kis            O      O      O       O     O    O      O       X       X      X      O         O
  FDIK(KMPS)     O      O      O       O                                                         O
  Koces          O      O      O       O                                                         O
  KSNET          O      O      O       O     O    X      X       X       X      X      O         O
  JT-NET(NC)     O      O      O       O     O    X      X       X       X      O      O         O        O
  Nice           O      O      O       O     X    X      X       O       O      O      X         O
  Smartro        O      O      O       O     O    O      O       O       X      X      X         O
  KCP            O      O      O       O                                                         O
  �ٿ�(StarVan)  O      O      O       O     O    O      O       X       X      X      O         O
  KOVAN          O      O      O       O                                                         O
  SPC(AWP)       O      O      O       O                                                         O

  - ��Ƽ�� ��� ���� ����.

*******************************************************************************)

unit uSBVanApprove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils,
  IdTCPClient, CPort, IdGlobal;

type
  // ���
  TVanCompType = (vctNone, vctKFTC, vctKICC, vctKIS, vctFDIK, vctKOCES, vctKSNET,
                  vctJTNet, vctNICE, vctSmartro, vctKCP, vctStarVAN, vctKOVAN, vctSPC);
  // ����/��Ʈ�ʽ� ���� (������, KB����, BC��Ʈ�ʽ�)
  TPartnerShipType = (pstNone, pstOgood, pstPartners);

  TKocesDevice = (kdKSP9000, kdKSP9020, kdSign1000);

  // ����� ���� (BC ������Ʈ, BC �׸�ī��, SK T �����, �Ｚ U ����Ʈ, �Ⱑ����Ʈ, Syrup�����, īī������)
  TMembershipType = (mtBCPoint, mtGreeanCard, mtSKT, mtUPoint, mtGiga, mtSyrup, mtKakao, mtWipoint, mtGalaxia);

  // ����� �ŷ����� (��ȸ, ����, ����, ����, ���)
  TMembershipTradeType = (mttInquiry, mttSave, mttDiscount, mttAuth, mttUse);

  // �÷� �ڵ� ����  (ssa, ok cashbag, ����, syrup order, syrup mileage, syrup stamp, syrup ����)
  TSyrupCode = (scSSA, scOCB, scCoupon, scOrder, scMileage, scStamp, scSyrup);

  // �÷� ���� Ÿ��  (ȣ��, ����, ���, ����, ���, �ֹ�, �����, ����, ����, ��ȸ)
  TSyrupType = (stCommon, stSave, stUse, stDiscount, stCancel, stOrder, stReprint, stpay, stMix, stQuery);

  // ���ݿ����� ��������
  TCashSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    SaleAmt: Currency;                 // �����ݾ�
    SvcAmt: Currency;                  // �����
    VatAmt: Currency;                  // �ΰ���
    FreeAmt: Currency;                 // �鼼
    CardNo: AnsiString;                // ī���ȣ
    Person: Boolean;                   // ����/����� ����
    KeyInput: Boolean;                 // Ű�ο���
    MSRTrans: Boolean;                 // MSR�ŷ�(IC�����϶��� ���)
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
    CancelReason: Integer;             // ��һ����ڵ� (1:�ŷ����, 2:�����߱�, 3:��Ÿ)
    CashRcpAutoEnable: Boolean;        // ���ݿ����� �����߱� ����
  end;

  // ���ݿ����� ��������
  TCashRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    ICCardNo: AnsiString;              // ICī���ȣ
  end;

  // ī�� ��������
  TCardSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    SaleAmt: Currency;                 // �����ݾ�
    SvcAmt: Currency;                  // �����
    VatAmt: Currency;                  // �ΰ���
    FreeAmt: Currency;                 // �鼼
    CardNo: AnsiString;                // ī���ȣ(Ʈ��2����)
    VaildThru: AnsiString;             // ��ȿ�Ⱓ
    HalbuMonth: Integer;               // �Һΰ���
    KeyInput: Boolean;                 // Ű�ο���
    MSRTrans: Boolean;                 // MSR�ŷ�(IC�����϶��� ���)
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
    PointCardNo: AnsiString;           // ����Ʈī���ȣ(Ʈ��2����)
    CouponNo: AnsiString;              // ��������(����/��Ʈ�ʽ�)
    RcpPrint: AnsiString;              // ��������¿���(Paperless)
    SignData: AnsiString;              // ���� ���ε�����
    SignLength: Integer;               // ���� ���ε����� ����
    PosEntryMode: AnsiString;          // WCC (���̽�, �ٿ쵥��Ÿ)
    SamsungPay: Boolean;               // �Ｚ���� ����(KCP PG)
  end;

  // ī�� ��������
  TCardRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    TransNo: AnsiString;               // �ŷ���ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    BalgupsaCode: AnsiString;          // �߱޻��ڵ�
    BalgupsaName: AnsiString;          // �߱޻��
    CompCode: AnsiString;              // ���Ի��ڵ�
    CompName: AnsiString;              // ���Ի��
    KamaengNo: AnsiString;             // ��������ȣ
    IsSignOK: Boolean;                 // ���� ���� ����
    AgreeAmt: Integer;                 // ���αݾ�
    DCAmt: Integer;                    // ���αݾ�
    ICCardNo: AnsiString;              // ICī���ȣ
    PointCardNo: AnsiString;           // ����Ʈī���ȣ
    CustName: AnsiString;              // ����
    PointAgreeNo: AnsiString;          // ����Ʈ���ι�ȣ
    PointOccur: Integer;               // �߻�����Ʈ
    PointAvail: Integer;               // ��������Ʈ
    PointTotal: Integer;               // ��������Ʈ
    PrintMsg: AnsiString;              // ����,��Ʈ�ʽ� ��� �޼���
    SignData: AnsiString;              // ���� ���ε�����
    SignLength: Integer;               // ���� ���ε����� ����
  end;

  // ��ǥ��ȸ ��������
  TCheckSendInfo = record
    CheckNo: AnsiString;               // ��ǥ��ȣ
    BankCode: AnsiString;              // ���������ڵ�
    BranchCode: AnsiString;            // �������� �������ڵ�
    KindCode: AnsiString;              // �����ڵ�
    CheckAmt: Currency;                // ��ǥ�ݾ�
    RegDate: AnsiString;               // ��ǥ������
    AccountNo: AnsiString;             // �����Ϸù�ȣ(��������/������ ���)
  end;

  // ��ǥ��ȸ ��������
  TCheckRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransDateTime: AnsiString;         // �ŷ�����
  end;

  // ���ðŷ� ��������
  TPosDownloadRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
  end;

  // ��ٿ� ��������
  TRuleDownRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    FileName: AnsiString;              // �����ϸ�
    FileCount: Integer;                // ������ ����
    DataLen: Integer;                  // �굥��Ÿ ����
    DataInfo: AnsiString;              // �굥��Ÿ ����
  end;

  // ����� ��������
  TMembershipSendInfo = record
    Approval: Boolean;                 // ����/���
    MembershipType: TMembershipType;   // ����� ����
    TradeType: TMembershipTradeType;   // ����� �ŷ�����
    SaleAmt: Integer;                  // �����ݾ�
    CardNo: AnsiString;                // ī���ȣ
    TrackTwo: AnsiString;              // 2Track Data
    KeyInput: Boolean;                 // Ű�ο���
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
    GoodsCode: AnsiString;             // SKT�����ī�� �ŷ��� ��ǰ�ڵ�
    PinBlock: AnsiString;              // ����� ī�� ��й�ȣ (plain text)
    ServiceCode : TSyrupCode;          // Syrup ���� Code  20150810 L.S.K �߰�
    ServiceType : AnsiString;          // Syrup ���� Ÿ��  20150810 L.S.K �߰�
  end;

  // Ƽ�Ӵ� ��������
  TTMoneyRecvInfo = record
    Result: Boolean;                   // ��������
    Code: Integer;                     // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    PSamID: AnsiString;                // PSAM ID
    PSamTransNo: AnsiString;           // PSAM �ŷ��Ϸù�ȣ
    CardID: AnsiString;                // ī�� ID
    CardTransNo: AnsiString;           // ī�� �ŷ��Ϸù�ȣ
    BeforeAmt: Integer;                // �ŷ��� �ܾ�
    PayAmt: Integer;                   // �ŷ� �ݾ�
    AfterAmt: Integer;                 // �ŷ��� �ܾ�
    TransDateTime: AnsiString;         // �ŷ��Ͻ�
    AgreeDate: AnsiString;             // �����Ͻ�
    AgreeNo: AnsiString;               // ���ι�ȣ
    AgreeSign: AnsiString;             // ����
  end;

  // Cashbee ��������
  TCashbeeSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    IsPay: Boolean;                    // ����/���� ����
    PayAmt: Currency;                  // �����ݾ�
    OrgTransDateTime: AnsiString;      // ���ŷ� �Ͻ� (yyyymmddhhnnss)
    OrgTransNo: AnsiString;            // ���ŷ� �Ϸù�ȣ
    OrgSamID: AnsiString;              // ���ŷ� SAM ID
  end;

  // Cashbee ��������
  TCashbeeRecvInfo = record
    Result: Boolean;                   // ��������
    Code: Integer;                     // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransNo: AnsiString;               // �Ϸù�ȣ
    SamID: AnsiString;                 // SAM ID
    CardID: AnsiString;                // ī�� ID
    CardTransNo: AnsiString;           // ī�� �ŷ��Ϸù�ȣ
    SamTransNo: AnsiString;            // SAM �ŷ��Ϸù�ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�
    BeforeAmt: Integer;                // �ŷ��� �ܾ�
    PayAmt: Integer;                   // �ŷ� �ݾ�
    AfterAmt: Integer;                 // �ŷ��� �ܾ�
    AgreeNo: AnsiString;               // ���ι�ȣ
    AgreeSign: AnsiString;             // ����
    OrgTransDateTime: AnsiString;      // ���ŷ� �Ͻ� (yyyymmddhhnnss)
    OrgTransNo: AnsiString;            // ���ŷ� �Ϸù�ȣ
    OrgSamID: AnsiString;              // ���ŷ� SAM ID
  end;
  // ����� ��������
  TMembershipRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransDateTime: AnsiString;         // �ŷ�����
    AgreeNo: AnsiString;               // ���ι�ȣ
    BalgupsaCode: AnsiString;          // �߱޻��ڵ�
    BalgupsaName: AnsiString;          // �߱޻��
    CompCode: AnsiString;              // ���Ի��ڵ�
    CompName: AnsiString;              // ���Ի��
    KamaengNo: AnsiString;             // ��������ȣ
    ApplyAmt: Integer;                 // ���� �� �ݾ� / �ܾ�
    OccurPoint: Integer;               // �߻� ����Ʈ
    AblePoint: Integer;                // ���� ����Ʈ
    AccruePoint: Integer;              // ���� ����Ʈ
    DcAmt: Integer;                    // ���� �ݾ�
    SyrupAmt: Integer;                 // Syrup  ���ݾ�
    DeviceTrKey : AnsiString;          // �������񽺿� ������ �ŷ���ȣ 20150810 L.S.K �߰�
    ServiceTrKey : AnsiString;         // �������񽺿� ������ �ŷ���ȣ 20150810 L.S.K �߰�
    ServiceCD : TSyrupCode;            // Syrup ���� Code  20150810 L.S.K �߰�
    ServiceTP : AnsiString;            // Syrup ���� Ÿ��  20150810 L.S.K �߰�
  end;
  // TRS �� ��ǰ
  TTRSDetailGoods = record
    GoodsCode: AnsiString;             // ��ǰ�ڵ�
    GoodsName: AnsiString;             // ��ǰ��
    SaleQty: Integer;                  // ����
    SalePrice: Currency;               // �ܰ�
    SaleAmt: Currency;                 // �ݾ�
    SaleVat: Currency;                 // �ΰ���
  end;
  // GlobalTaxFree �� ��ǰ
  TGlobalTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // �Ϸù�ȣ
    DetailGVatGbn: AnsiString;         // �����Һ񼼱���
    DetailGoodsGbn: AnsiString;        // ��ǰ�ڵ�
    DetailGoodsNm: AnsiString;         // ��ǰ����
    DetailQty: Integer;                // ����
    DetailDanga: Currency;             // �ܰ�
    DetailSaleAmt: Currency;           // �ǸŰ���
    DetailVat: Currency;               // �ΰ���ġ��
    DetailGVat: Currency;              // �����Һ�
    DetailGEdVat: Currency;            // ������
    DetailGFmVat: Currency;            // �����Ư����
    DetailBigo: AnsiString;            // ���
  end;
  // KTISTaxFree �� ��ǰ
  TKTISTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // �Ϸù�ȣ
    DetailGVatGbn: AnsiString;         // �����Һ񼼱���
    DetailGoodsGbn: AnsiString;        // ��ǰ�ڵ�
//    DetailGoodsNm: AnsiString;         // ��ǰ����
    DetailGoodsNm: AnsiString;             // ��ǰ����
    DetailQty: Integer;                // ����
    DetailDanga: Currency;             // �ܰ�
    DetailSaleAmt: Currency;           // �ǸŰ���
    DetailVat: Currency;               // �ΰ���ġ��
    DetailGVat: Currency;              // �����Һ�
    DetailGEdVat: Currency;            // ������
    DetailGFmVat: Currency;            // �����Ư����
    DetailBigo: AnsiString;            // ���
  end;
  // KICCTaxFree �� ��ǰ
  TKICCTaxFreeDetailGoods = record
    DetailSNo: AnsiString;             // �Ϸù�ȣ
    DetailGVatGbn: AnsiString;         // �����Һ񼼱���
    DetailGoodsGbn: AnsiString;        // ��ǰ�ڵ�
//    DetailGoodsNm: AnsiString;         // ��ǰ����
    DetailGoodsNm: AnsiString;             // ��ǰ����
    DetailQty: Integer;                // ����
    DetailDanga: Currency;             // �ܰ�
    DetailSaleAmt: Currency;           // �ǸŰ���
    DetailVat: Currency;               // �ΰ���ġ��
    DetailGVat: Currency;              // �����Һ�
    DetailGEdVat: Currency;            // ������
    DetailGFmVat: Currency;            // �����Ư����
    DetailBigo: AnsiString;            // ���
  end;
  // TRS(�ΰ���ȯ��) ��������
  TTRSSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    SumSaleAmt: Currency;              // �Ǹűݾ�
    SumSaleVat: Currency;              // �ΰ���
    SumSaleQty: Integer;               // �Ǹż���
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
    TranKind: AnsiString;              // �ŷ����� (�ſ�ī��:C ����:M ����:X)
    DetailGoodsList: array of TTRSDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // TRS(�ΰ���ȯ��) ��������
  TTRSRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransNo: AnsiString;               // �ŷ��Ϸù�ȣ
    AgreeNo: AnsiString;               // ���ι�ȣ
    PurcNo: AnsiString;                // �����Ϸù�ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    AgreeAmt: Currency;                // ���αݾ�
    NetRefuncAmt: Currency;            // ȯ�޾�
  end;
  // CubeRefund ��������
  TCubeRefundSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    IsRefund: Boolean;                 // True - ���ȯ�� , False - ����ȯ��
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
    PassportKeyin: Boolean;            // �����Է� ���� (True:Key-in, False: swipe)
    PassportInfo: AnsiString;          // ���ǹ�ȣ
    ReceiptNo: AnsiString;             // ��������ȣ
    PayGubun: AnsiString;              // ��������(0:���� 1:�ſ� 9:��Ÿ)
    RefundAgreeNo: AnsiString;         // �ŷ�������ȣ
    Nationality: AnsiString;           // ����
    GuestName: AnsiString;             // �̸�
    SaleAmt: Currency;
    DetailGoodsList: array of TTRSDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // CubeRefund ��������
  TCubeRefundRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransNo: AnsiString;               // �ŷ�������ȣ
    TransNoStore: AnsiString;          // ������ �ŷ�������ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    AgreeNo: AnsiString;               // ȯ����ǥ �����ȣ
    PassportNo: AnsiString;            // ���ǹ�ȣ
    BuyersName: AnsiString;            // ������ ����
    BuyersNationality: AnsiString;     // ������ ����
    NetRefuncAmt: Currency;            // ȯ�޾�
    ToTalLimit: Currency;              // �����ѵ��ݾ�
    RemainingLimit: Currency;          // �������ѵ�
  end;
  // GlobalTaxFree ��������
  TGlobalTaxFreeSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    GtGbn: AnsiString;                 // ��������
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // GlobalTaxFree ��������
  TGlobalTaxFreeRecvInfo = record
    Result: Boolean;                   // ��������
    GtGbn: AnsiString;                 // ��������
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // KICCTaxFree ��������
  TKICCTaxFreeSendInfo = Record
    Approval: Boolean;                 // ����/��� ����
    IsRefund: Boolean;                 // ���ȯ�� : True, ����ȯ�� : False
    KeyIn: Boolean;                    // KeyIn ����
    GtGbn: AnsiString;                 // �������� S: ��ȸ, A: ����
    ReaderInfo: Boolean;               // ���������� T: ������ ���� ����, F: ���� ����
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtOrgApprovalNo: AnsiString;       // �ŷ������ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtPosNo: AnsiString;               // �ܸ��� POS ��ȣ
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    GtOrgSellTime: AnsiString;         // �Ǹų���Ͻ�
    GtRcpTradeNo: AnsiString;          // �ŷ� ���� ��ȣ
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotSumVat: Currency;               // �ΰ��� �հ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    TotCardAmt: Currency;              // ī���ѱݾ�
    TotCashAmt: Currency;              // �����ѱݾ�
    TotECashAmt: Currency;             // ����ȭ���ѱݾ�
    TotFreeAmt: Currency;              // �鼼�ѱݾ�
    TotCntSale: Integer;               // �Ǹ��ѰǼ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    ShopCd: AnsiString;                // �����ڵ�
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    RefundAmt: Currency;               // ���ȯ�ޱݾ�
    Port: Integer;                     // �����Ʈ
    SellerName: AnsiString;            // �Ǹ��ڸ�
    SellerAddr: AnsiString;            // �Ǹ��� �ּ�
    SellerTelNo: AnsiString;           // �Ǹ��� ��ȭ
    DetailGoodsList: array of TKICCTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // KICCTaxFree ��������
  TKICCTaxFreeRecvInfo = Record
    Result: Boolean;                   // ��������
    GtGbn: AnsiString;                 // ��������
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    ErrorCd: AnsiString;               // �����ڵ�
    RefundAmt: Currency;               // ���ȯ�ޱݾ�
    BeforeRefundAmt: Currency;         // �������ȯ�ޱݾ�
    AfterRefundAmt: Currency;          // �������ȯ�ޱݾ�
    DetailGoodsList: TKICCTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
    GtRcpTradeNo: AnsiString;

    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    TransNo: AnsiString;               // �ŷ��Ϸù�ȣ
    PurcNo: AnsiString;                // �����Ϸù�ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    AgreeAmt: Currency;                // ���αݾ�
  end;
  // KTISTaxFree ��������
  TKTISTaxFreeSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    IsRefund: Boolean;                 // ���ȯ�� : True, ����ȯ�� : False
    KeyIn: Boolean;                    // KeyIn ����
    GtGbn: AnsiString;                 // �������� S: ��ȸ, A: ����
    ReaderInfo: Boolean;               // ���������� T: ������ ���� ����, F: ���� ����
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtOrgApprovalNo: AnsiString;       // �ŷ������ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtPosNo: AnsiString;               // �ܸ��� POS ��ȣ
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    GtOrgSellTime: AnsiString;         // �Ǹų���Ͻ�
    GtRcpTradeNo: AnsiString;          // �ŷ� ���� ��ȣ
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotSumVat: Currency;               // �ΰ��� �հ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    TotCardAmt: Currency;              // ī���ѱݾ�
    TotCashAmt: Currency;              // �����ѱݾ�
    TotECashAmt: Currency;             // ����ȭ���ѱݾ�
    TotFreeAmt: Currency;              // �鼼�ѱݾ�
    TotCntSale: Integer;               // �Ǹ��ѰǼ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    ShopCd: AnsiString;                // �����ڵ�
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    RefundAmt: Currency;               // ���ȯ�ޱݾ�
    Port: Integer;                     // �����Ʈ
    DetailGoodsList: array of TKTISTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
  end;
  // KTISTaxFree ��������
  TKTISTaxFreeRecvInfo = record
    Result: Boolean;                   // ��������
    GtGbn: AnsiString;                 // ��������
    GtVersion: AnsiString;             // ��������
    GtDocCd: AnsiString;               // �����ڵ�
    GtSno: AnsiString;                 // �����Ϸù�ȣ
    GtCancel: AnsiString;              // ������ҿ���
    GtApprovalNo: AnsiString;          // �ŷ����ι�ȣ
    GtBizNo: AnsiString;               // �Ǹ��ڻ���ڹ�ȣ
    GtTerminalId: AnsiString;          // �ܸ���ID
    GtSellTime: AnsiString;            // �Ǹų���Ͻ�
    TotQty: Integer;                   // �Ǹ��Ѽ���
    TotSaleAmt: Currency;              // �Ǹ��ѱݾ�
    TotRefundAmt: Currency;            // ȯ���Ѿ�
    PayGbn: AnsiString;                // ��������
    CardNo: AnsiString;                // �ſ�ī���ȣ
    ChCardGbn: AnsiString;             // ����ī�忩��
    JuminNo: AnsiString;               // �ֹε�Ϲ�ȣ
    PassportNm: AnsiString;            // ���ǿ����̸�
    PassportNo: AnsiString;            // ���ǹ�ȣ
    PassportNationCd: AnsiString;      // ���Ǳ����ڵ�
    PassportSex: AnsiString;           // ���Ǽ���
    PassportBirth: AnsiString;         // ���ǻ������
    PassportExpireDt: AnsiString;      // ���Ǹ�����
    ResponseCd: AnsiString;            // �����ڵ�
    ResponseMsg: AnsiString;           // ����޼���
    ShopNm: AnsiString;                // �����
    DetailCnt: Integer;                // ��ǰ�ιݺ�Ƚ��
    ExportExpirtDt: AnsiString;        // ������ȿ�Ⱓ
    RctNo: AnsiString;                 // ��������ȣ
    Bigo: AnsiString;                  // ���
    ErrorCd: AnsiString;               // �����ڵ�
    RefundAmt: Currency;               // ���ȯ�ޱݾ�
    BeforeRefundAmt: Currency;         // �������ȯ�ޱݾ�
    AfterRefundAmt: Currency;          // �������ȯ�ޱݾ�
    DetailGoodsList: TGlobalTaxFreeDetailGoods; // �� ��ǰ ����Ʈ
    GtRcpTradeNo: AnsiString;
  end;

  TKTISTaxFreePass = record
    PassportNo : AnsiString;                       // ��������(��ȣȭ)
    PassportNationCd : AnsiString;                 // �����ڵ�(3)
    PassportNm : AnsiString;                       // �̸�
    PassportExpireDt : AnsiString;                 // ���Ǹ�����
    PassportBirth : AnsiString;                    // ���ǻ���
    PassportSex : AnsiString;                      // ����
    RcpTradeNo: AnsiString;                        // �ŷ�������ȣ
    TaxRefundBool : Boolean;
  end;

  TKICCTaxFreePass = record
    PassportNo : AnsiString;                       // ��������(��ȣȭ)
    PassportNationCd : AnsiString;                 // �����ڵ�(3)
    PassportNm : AnsiString;                       // �̸�
    PassportExpireDt : AnsiString;                 // ���Ǹ�����
    PassportBirth : AnsiString;                    // ���ǻ���
    PassportSex : AnsiString;                      // ����
    RcpTradeNo: AnsiString;                        // �ŷ�������ȣ
    TaxRefundBool : Boolean;
  end;

  // MTIC ��������
  TMTICSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    VanCode: AnsiString;               // �������ڵ�
    SvcID: AnsiString;                 // ������ID
    TransNo: AnsiString;               // �ŷ���ȣ(20Byte)
    GoodsAmt: Currency;                // ��ǰ�ݾ�
    BarCode: AnsiString;               // ���ڵ�
    OrgAgreeNo: AnsiString;            // �����ι�ȣ(��ҽ�)
  end;
  // MTIC ��������
  TMTICRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    RemainAmt: Currency;               // �ܿ��ѵ�
  end;
  // ��������Ʈ ��������
  TBagxenSendInfo = record
    ServerIP: AnsiString;              // ���� IP
    ServerPort: Integer;               // ���� PORT
    TerminalID: AnsiString;            // �ܸ���ID (����ڹ�ȣ)
    KeyIn: Boolean;                    // WCC
    TrackTwo: AnsiString;              // 2Track Data
    Password: AnsiString;              // ��й�ȣ
    SaleAmt: Currency;                 // �ŷ��ݾ�
    OrgAgreeNo: AnsiString;            // �����ι�ȣ
    OrgAgreeDate: AnsiString;          // ����������
  end;
  // ��������Ʈ ��������
  TBagxenRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    AgreeNo: AnsiString;               // ���ι�ȣ
    Msg1: AnsiString;                  // ����޼���1
    Msg2: AnsiString;                  // ����޼���2
    Msg3: AnsiString;                  // ����޼���3
    OccurPoint: Integer;               // �߻� ����Ʈ
    AblePoint: Integer;                // ���� ����Ʈ
    AccruePoint: Integer;              // ���� ����Ʈ
  end;
  // �� ���� ����
  TVanConfigInfo = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    HostIP: AnsiString;                // ȣ��Ʈ IP
    HostPort: Integer;                 // ȣ��Ʈ Port
    TerminalID: AnsiString;            // �ܸ����ȣ TID
    SignPad: Boolean;                  // �����е� ��뿩��
    SignPort: Integer;                 // �����е� Port
    SignRate: Integer;                 // �����е� �ӵ�
    BizNo: AnsiString;                 // ����ڹ�ȣ
    StrName: AnsiString;               // �����
    SerialNo: AnsiString;              // �Ϸù�ȣ
    Password: AnsiString;              // ��й�ȣ
    AreaCode: AnsiString;              // �����ڵ�
    TerminalSerialNo: AnsiString;      // �ܸ��� �Ϸù�ȣ
    PartnerShipType: TPartnerShipType; // ����/��Ʈ�ʽ� ����
    PosDownload: Boolean;              // PosDownload(����)�� �������ϰ� ���� ����
    SecureMode: Boolean;               // IC�������� ��� ��뿩��
    CatTerminal: Boolean;              // IC�������� CAT �ܸ��� ��������
    PaymentGateway:Boolean;            // PG(payment gateway) ��� ��뿩��
    HWSecure: Boolean;                 // MSR HW ���� ��뿩��(Kis) / �ݰ�� �ܸ��� ����
    MSRPort: Integer;                  // MSRPort(Kis) / �ݰ�� �ܸ��� ��Ʈ
    KocesDevice: TKocesDevice;         // KOCES SIGN DEVICE TYPE
    CashBeeID: AnsiString;             // ĳ���� TID
    ProgramCode: AnsiString;           // ���α׷� ���� (�ݰ����)
    ProgramVersion: AnsiString;        // ���α׷� ���� (�ݰ����)
    DebugLog: Boolean;                 // ����� �α� ���� ����
    NoSignUse5M: Boolean;              // 5���� �̸� ���� ��� ����
    SecureModeInit: Boolean;           // �ʱⰪ ����
    CatPrintUse: Boolean;              // Cat�ܸ��� ����Ʈ ��� ����
    CatPrintPort: Integer;             // Cat�ܸ��� ����Ʈ ��Ʈ
  end;
  // TRS ���� ����
  TTRSConfigInfo = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    HostIP: AnsiString;                // ȣ��Ʈ IP
    HostPort: Integer;                 // ȣ��Ʈ Port
    TerminalID: AnsiString;            // �ܸ����ȣ TID
    BizNo: AnsiString;                 // ����ڹ�ȣ
    StrName: AnsiString;               // �����
    SellerName: AnsiString;            // �Ǹ��ڸ�
    SellerAddr: AnsiString;            // �Ǹ��� �ּ�
    SellerTelNo: AnsiString;           // �Ǹ��� ��ȭ
  end;
  // CubeRefund ���� ����
  TCubeRefundConfigInfo = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    TerminalID: AnsiString;            // ��������ȣ
    BizNo: AnsiString;                 // ����ڹ�ȣ
  end;
  TGlobalTaxFreeConfigInfo = record
    TaxFreeIp: AnsiString;
    TaxFreePort: Integer;
    Gubun: AnsiString;                 // T: �ý���������, S: ����
  end;
  TKTISTaxFreeConfigInfo = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    TaxFreeIp: AnsiString;
    TaxFreePort: Integer;
    TerminalID: AnsiString;            // ��������ȣ
    Gubun: AnsiString;                 // T: �ý���������, S: ����
  end;
  TKICCTaxFreeConfigInfo = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    HostIP: AnsiString;                // ȣ��Ʈ IP
    HostPort: Integer;                 // ȣ��Ʈ Port
    TerminalID: AnsiString;            // �ܸ����ȣ TID
    BizNo: AnsiString;                 // ����ڹ�ȣ
    StrName: AnsiString;               // �����
    SellerName: AnsiString;            // �Ǹ��ڸ�
    SellerAddr: AnsiString;            // �Ǹ��� �ּ�
    SellerTelNo: AnsiString;           // �Ǹ��� ��ȭ
  end;

  // KIS ������ ���� ��������
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

  // ���� ��������
  TWxPaySendInfo = record
    JunmunType: AnsiString;            // ����Ÿ��     ���ο�û:52, ���ΰ����ȸ��û:53, ��ҿ�û:54, ��Ұ����ȸ��û: 55
    VanId: AnsiString;                 // ����Ƽ�ݿ��� �ο��� ID
    PosNo: AnsiString;                 // ������ȣ
    ScanCd: AnsiString;                // ���ڵ� scan ��
    SendDt: AnsiString;                // ������������ yyyymmddhhnnss
    AgreeNo: AnsiString;               // ���ι�ȣ
    OrgSendDt: AnsiString;             // ���ŷ������Ͻ�
    OrgAgreeNo: AnsiString;            // ���ŷ����ι�ȣ
    CurrencyType: AnsiString;          // ������ȭ
    AgreeAmt: Currency;                // �����ݾ�
    GoodsCd: AnsiString;               // ��ǰ�ڵ�
    GoodsNm: AnsiString;               // ��ǰ��
    GoodsExp: AnsiString;              // ��ǰ����
    CloseTime: AnsiString;             // �ŷ������ð�
    GoodsTag: AnsiString;              // ��ǰ Tag  �̻��
    Reserved: AnsiString;              // Reserved; �̻��
  end;

  // ���� ��������
  TWxPayRcvInfo = record
    JunmunType: AnsiString;            // ����Ÿ��     ���ο�û:52, ���ΰ����ȸ��û:53, ��ҿ�û:54, ��Ұ����ȸ��û: 55
    VanId: AnsiString;                 // ����Ƽ�ݿ��� �ο��� ID
    PosNo: AnsiString;                 // ������ȣ
    RtnNo: AnsiString;                 // �����ڵ� 0000:��������, 0001:�����ȸ, 0002:ȸ�����
    RtnMsg: AnsiString;                // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    AgreeState: AnsiString;            // ��������
    AgreeTime: AnsiString;             // �����ð�  yyyymmddhhnnss
    GoodsNm: AnsiString;               // ��ǰ��
    CurrencyType: AnsiString;          // ������ȭ
    AgreeAmt: Currency;                // �����ݾ�
    DeviceId: AnsiString;              // �����ܸ����ȣ
    WeChatNo: AnsiString;              // ���°�����ȣ
    GateWayNo: AnsiString;             // ����Ʈ���̰�����ȣ
    Reserved: AnsiString;              // Reserved  �̻��
  end;


  //��ê ��������
  TWeChatPaySendInfo = record
    Approval: Boolean;                 // ����/��� ����
    VanId: AnsiString;                 // PG ID
    StoreId: AnsiString;               // ���� ID
    StorePw: AnsiString;               // Key PassWord
    GoodsNm: AnsiString;               // ��ǰ��
    AgreeAmt: Currency;                // �����ݾ�
    OrderNum: AnsiString;              // �ֹ���ȣ
    BuyerName: AnsiString;             // ������ �̸�
    BuyerEmail: AnsiString;            // ������ �̸���
    BuyerTel: AnsiString;              // ������ ��ȭ��ȣ
    PayCurrency: AnsiString;           // ��ȭ����
    PayMethod: AnsiString;             // ��������(CARD, CASH, VBank, TPAY)
    URL: AnsiString;                   // ������ Ȩ������
    ServiceCode: AnsiString;           // ���� �ڵ� W ����
    WechAuthCode: AnsiString;          // ���ڵ� ������ȣ
    WechCompanyBizNo: AnsiString;      // ���갡���� ����ڹ�ȣ
    Tid: AnsiString;                   // ��ҽ� �ʿ��� TID
    MKey: Boolean;                     // ��ǥŰ ���� ����
    MergyLog: Boolean;                 // ��ǥŰ ���� �α� ���� ����
    Merchantreserved1: AnsiString;     // �����ʵ�1
    Merchantreserved2: AnsiString;     // �����ʵ�2
    Merchantreserved3: AnsiString;     // �����ʵ�3
    Debug: Boolean;                    // �α� ��� True(�� �α�)
  end;

  //��ê ��������
  TWeChatPayRcvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    Tid: AnsiString;                   // �ŷ���ҽ� �ʿ��� tid
    AgreeAmt: Currency;                // �����ݾ�
    AgreeNo: AnsiString;               // ���ι�ȣ
    TransDate: AnsiString;             // ���γ�¥
    TransDateTime: AnsiString;         // ���νð�
    TransactionID: AnsiString;         // �ֹ���ȣ
    ReqCurrency: AnsiString;           // ��û��ȭ�ڵ�
    RateExchange: AnsiString;          // ȯ��
    ReqPrice: AnsiString;              // ȯ�����ݾ�
    State: AnsiString;                 // ��ȸ ���   0: ����, 1: ���, 2: ����������, 9: �ŷ�����
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

  // �� ���
  TVanModul = class
  private
    FVanType: TVanCompType;
    FConfig: TVanConfigInfo;
    // �� ���αݾ� (����,��Ʈ�ʽ��϶� ���)
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
    // �⺻��
    MainVan: TVanApprove;
    // KTIS TaxFree
    KTISTaxFree: TKTISTaxFree;
    // KICC TaxFree
    KICCTaxFree: TKICCTaxFree;
    constructor Create; virtual;
    destructor Destroy; override;
    // ���� �̹��� ��
    function SignImageName: AnsiString;
    // ���ȸ�⼭�񽺰� ����Ǿ� �ִ��� ã�´�.
    //function FindSecureService: Boolean;
    // ���ðŷ�
    function CallPosDownload : TPosDownloadRecvInfo;
    // �ſ�ī�� ����
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
    // ���ݿ����� ����
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
    // ��ǥ��ȸ
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
    // �����е� �����Է�
    function CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean;
    // ���е� �Է�
    function CallPinPad(out ARetSignData: AnsiString): Boolean;
    // ���е� �Է� ���
    procedure CallPinCancel;
    // ���� ī�� ����
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
    // �ο�Ƽ ���� ��ȸ �� ���
    function CallCoupon(AInfo: TCardSendInfo): TCardRecvInfo;
    // �ο�Ƽ ���� ���
    function CallCouponUse(AInfo: TCardSendInfo): TCardRecvInfo;
    // �� �ٿ�ε�
    function CallRuleDownload: TRuleDownRecvInfo;
    // ����� ī�� ����
    function CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo;
    // ����IC ����
    function CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo;
    // PayOn
    function CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean;
    function CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo;
    // ��ȭ���� ��û
    function CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetCurrencyData: AnsiString): Boolean;
    // IC ������ ���� (IC ������)
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
    // MS Swipe ��û (IC ������)
    function CallMSR(AGubun: AnsiString; out ACardNo,ADecrypt, AEncData: AnsiString): Boolean;
    // MS Swipe ��û (�ݰ�� �ܸ���)
    function CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean;
    // IC �Է� ��û (�ݰ�� �ܸ���)
    function CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo: AnsiString; out AEmvInfo: AnsiString): Boolean;
    // �ܸ��� �񵿱� ��� ��û
    function SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString): Boolean;
    // ������ ���
    function PrintOut(APrintData: AnsiString): Boolean;
    // ���� ����
    function CashDrawOpen: Boolean;
    // �������� ����
    function WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo;

    // ��ü ȯ�� ���� ���� ó��
    procedure ApplyConfigAll;
    // VAN��
    property VanType: TVanCompType read FVanType  write SetVanType default vctNone;
    property VanName: string read GetCurrVanName;
    // ����/��Ʈ�ʽ� ����
    property PartnerShipType: TPartnerShipType read FConfig.PartnerShipType  write SetPartnerShipType default pstNone;
    // �Ǹ��/�׽�Ʈ���
    property RealMode: Boolean read FConfig.RealMode write SetRealMode;
    // ȣ��Ʈ IP
    property HostIP: AnsiString read FConfig.HostIP write SetHostIP;
    // ȣ��Ʈ Port
    property HostPort: Integer read FConfig.HostPort write SetHostPort;
    // �ܸ����ȣ TID
    property TerminalID: AnsiString read FConfig.TerminalID write SetTerminalID;
    // �����е� ��뿩��
    property SignPad: Boolean read FConfig.SignPad write SetSignPad;
    // �����е� Port
    property SignPort: Integer read FConfig.SignPort write SetSignPort;
    // �����е� �ӵ�
    property SignRate: Integer read FConfig.SignRate write SetSignRate;
    // ����ڹ�ȣ
    property BizNo: AnsiString read FConfig.BizNo write SetBizNo;
    // �����
    property StrName: AnsiString read FConfig.StrName write SetStrName;
    // �Ϸù�ȣ
    property SerialNo: AnsiString read FConfig.SerialNo write SetSerialNo;
    // ��й�ȣ
    property Password: AnsiString read FConfig.Password write SetPassword;
    // �����ڵ�
    property AreaCode: AnsiString read FConfig.AreaCode write SetAreaCode;
    // �ܸ��� �Ϸù�ȣ
    property TerminalSerialNo: AnsiString read FConfig.TerminalSerialNo write SetTerminalSerialNo;
    // PosDownload(����)
    property PosDownload: Boolean read FConfig.PosDownload write SetPosDownload;
    // IC�������� ��� ��뿩��
    property SecureMode: Boolean read FConfig.SecureMode write SetSecureMode;
    // IC�������� CAT�ܸ��� ��������
    property CatTerminal: Boolean read FConfig.CatTerminal write SetCatTerminal;
    // PG ��� ��뿩��
    property PaymentGateway: Boolean read FConfig.PaymentGateway write SetPaymentGateway;
    // MSR HW ���� ��뿩��
    property HWSecure: Boolean read FConfig.HWSecure write SetHWSecure;
    // MSRPort
    property MSRPort: Integer read FConfig.MSRPort write SetMSRPort;
    // KOCES SIGN PAD DEVICE
    property KocesDevice: TKocesDevice read FConfig.KocesDevice write SetKocesDevice;
    // ĳ���� TID
    property CashBeeID: AnsiString read FConfig.CashBeeID write SetCashBeeID;
    // ���α׷� ���� (�ݰ����)
    property ProgramCode: AnsiString read FConfig.ProgramCode write SetProgramCode;
    // ���α׷� ���� (�ݰ����)
    property ProgramVersion: AnsiString read FConfig.ProgramVersion write SetProgramVersion;
    // ����� �α� ���� ����
    property DebugLog: Boolean read FConfig.DebugLog write SetDebugLog;
    // 5���� �̸� ��������
    property NoSignUse5M: Boolean read FConfig.NoSignUse5M write SetNoSignUse5M;
    // IC���� �ʱⰪ ȣ�� ��� ����
    property SecureModeInit: Boolean read FConfig.SecureModeInit write SetSecureModeInit;
    // Cat�ܸ��� ����Ʈ ��� ����
    property CatPrintUse: Boolean read FConfig.CatPrintUse write SetCatPrintUse;
    // Cat�ܸ��� ����Ʈ ��Ʈ
    property CatPrintPort: Integer read FConfig.CatPrintPort write SetCatPrintPort;
    // ȯ�漳��
    property VanConfig: TVanConfigInfo read FConfig;
    // �ݰ�� �ݹ� �̺�Ʈ
    property OnMSCallBackEvent: TMSCallbackEvent read FMSCallbackEvent write FMSCallbackEvent;
    property OnICCallBackEvent: TICCallBackEvent read FICCallBackEvent write FICCallBackEvent;
  end;

  // �� ���� ���� ���
  TVanApprove = class
  private
    FMessageForm: TForm;
  protected
    procedure ShowMessageForm(AMsg: string; AButtonHide: Boolean = False; ATimeOutSeconds: integer=0);
    procedure HideMessageForm;
    function ShowAIDSelectForm(AAIDCount: Integer; AAIDList: AnsiString; out ASelectAIDIndex: Integer): Boolean;
    // �޼��� ������ ��� ��ư�� �������� �߻��ϴ� �̺�Ʈ
    procedure EventMessageFormCancelClick(Sender: TObject); virtual;
  public
    Config: TVanConfigInfo;
    Log: TLog;
    procedure DoMessageFormCancelClick;
    // ���� ó�� (������ �ٿ�ε�)
    function CallPosDownload: TPosDownloadRecvInfo; virtual;
    // �ſ�ī�� ����
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // ���ݿ����� ����
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo; virtual; abstract;
    // ��ǥ��ȸ
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo; virtual; abstract;
    // �����е� �����Է� ȣ��
    function CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean; virtual; abstract;
    // ���е� �Է� ȣ��
    function CallPinPad(out ARetData: AnsiString): Boolean; virtual; abstract;
    // ���е� �ʱ�ȭ
    procedure CallPinCancel; virtual; abstract;
    // ���� ī�� ����
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // ������ȸ,��� (AUse:��ȸ,��뿩��)
    function CallCoupon(AUse: Boolean; AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // ������ �ٿ�ε�
    function CallRuleDownload: TRuleDownRecvInfo; virtual; abstract;
    // ����� ī�� ����
    function CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo; virtual; abstract;
    // ����IC ī��
    function CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // PayOn
    function CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean; virtual; abstract;
    function CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
    // ��ȭ���� ��û
    function CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetData: AnsiString): Boolean; virtual; abstract;
    // IC ������ ���� (IC ������)
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // MS Swipe ��û (IC ������)
    function CallMSR(AGubun: AnsiString; out ACardNo, ADecrypt, AEncData: AnsiString): Boolean; virtual; abstract;
    // MS Swipe ��û
    function CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean; virtual; abstract;
    // IC �Է� ��û
    function CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo: AnsiString; out AEmvInfo: AnsiString): Boolean; virtual; abstract;
    // �ܸ��� �񵿱� ��� ��û
    function SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString; ACallbackMS, ACallbackIC: Pointer): Boolean; virtual; abstract;
    // ������ ���
    function PrintOut(APrintData: AnsiString): Boolean; virtual; abstract;
    // �������� ����
    function WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo; virtual; abstract;
  end;

  // IC���� ������ CAT �ܸ��� ���� ���� ���
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

  // T-Money ���� ���
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
    // �⺻���� ���� LogOn
    function ExecInit(out AInfo: AnsiString): Boolean; virtual;
    // �ܾ� ��ȸ (�ܾ�, ī��ID)
    function ExecGetMoney(out AAmt: Integer; out ACardID: AnsiString): Boolean; virtual;
    // ����ó�� (���ұݾ�, �������)
    function ExecPayProc(APayAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // ��ǰ���� (���ұݾ�, ���ŷ�����Ÿ, �������)
    function ExecCancelProc(APayAmt: Integer; AOrgPayData: TTMoneyRecvInfo; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // ���� �ŷ� (�����ݾ�, �������)
    function ExecChargeProc(AChargeAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // ���� ��� (�����ݾ�, �������)
    function ExecChargeCancelProc(AChargeAmt: Integer; out APayRecvInfo: TTMoneyRecvInfo): Boolean; virtual;
    // Host ������
    procedure HostReSendData; virtual;
    // �꼳�� ����
    property Config: TVanConfigInfo read FConfig write SetCofig;
  end;

  // TRS ���� ���
  TTRS = class
  protected
    Log: TLog;
  public
    Config: TTRSConfigInfo;
    constructor Create; virtual;
    destructor Destroy; override;
    // ����
    function CallExec(AInfo: TTRSSendInfo): TTRSRecvInfo; virtual;
  end;

  // CubeRefund
  TCubeRefund = class
  private
    FConfig: TCubeRefundConfigInfo;
    function GetErrorMsg(ACode: Integer): AnsiString;
    procedure SetConfig(AValue: TCubeRefundConfigInfo);
    // ���� �������� ó��
    function MakeSendData(AInfo: TCubeRefundSendInfo): AnsiString;
    // ���� ������� ó��
    function MakeSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
    function MakeRefuncSendCancelData(AInfo: TCubeRefundSendInfo): AnsiString;
    // ���� �������� ó��
    function MakeRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
    function MakeRefundRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
    // ���� ������� ó��
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
    // ����
    function CallExec(AInfo: TCubeRefundSendInfo): TCubeRefundRecvInfo;
    property Config: TCubeRefundConfigInfo read FConfig write SetConfig;
  end;

  TGlobalTaxFree = class
  private
    FConfig: TGlobalTaxFreeConfigInfo;
    function GetErrorMsg(ACode: AnsiString): AnsiString;
    procedure SetConfig(AValue: TGlobalTaxFreeConfigInfo);
    // ���� �������� ó��
    function MakeSendData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
    // ���� �������� ó��
    function MakeSendStartData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
    // ���� �������� ó��
    function MakeRecvData(ARecvData: AnsiString): TGlobalTaxFreeRecvInfo;
    // ���� �������� ó��
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
    // ���� �������� ó��
    function MakeSendData(AInfo: TKTISTaxFreeSendInfo): AnsiString;
    // ���� �������� ó��
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

  // MTIC ���
  TMtic = class
  private
    class function GetErrorMsg(ACode: Integer): AnsiString;
  public
    // MTIC ������ ó���Ѵ�.
    class function ExecPayProc(ASendInfo: TMTICSendInfo): TMTICRecvInfo;
  end;

  // ĳ�ú� ���� ���
  TCashbee = class
  private
  protected
    Log: TLog;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // ī�� �ܾ� ��ȸ (ī���ܾ�, ī��ID)
    function GetCardMoney(out ACardAmt: Integer; out ACardID: AnsiString): Boolean; virtual;
    // LSAM �ܾ� ��ȸ (SAM�ܾ�, SAM ID)
    function GetSamMoney(out ASamAmt: Integer; out ASamID: AnsiString): Boolean; virtual;
    // �⺻���� ����
    function ExecInit: Boolean; virtual;
    // ����ó�� (��������, �������Ÿ)
    function ExecPayProc(ASendInfo: TCashbeeSendInfo): TCashbeeRecvInfo; virtual;
    // ��ġ�� ����
    function ExecSamSaveAuth: TCashbeeRecvInfo; virtual;
  end;

  // ��ê ���� ���
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

  // �������� ���� ���
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

  // �ŷ�����
  TBagxenType = (btSave, btSaveCancel, btUse, btUseCancel, btInquiry);
  // ��������Ʈ ���
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
    // ������ ���� ������ �����´�.
    class function ExecRcpCoupon(ARealMode: Boolean; ACatID, ATranCode, AAuthNo: AnsiString; ATranAmt: Currency): TKisRcpCouponRecvInfo;
  end;

  // �α� ���� ���� (������, ����, ����׿�, ����, ��)
  TLogType = (ltInfo, ltError, ltDebug, ltBegin, ltEnd);
  // �α� ó��
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
  MSG_ERR_DLL_LOAD   = ' ������ �ҷ��� �� �����ϴ�.';
  MSG_ERR_TRANS      = '������ �ۼ��� �� �� �����ϴ�.';
  MSG_SOLBIPOS       = 'Solbipos POS System';
  MSG_SOLBIPOS_SHORT = 'SOLBIPOS';
  LOG_DIRECTORY      = 'VanLog';

  KICC_TRS_DLL_NAME = 'Kicc.dll';


  SERVICE_GUBUN_KB = 'M';
  SERVICE_GUBUN_BC = 'B';

  IC_READER_WORK_INIT        = 0; // IC ������ �ʱ�ȭ
  IC_READER_WORK_STATUS      = 1; // IC ������ ���� Ȯ�� (���� ����)
  IC_READER_WORK_VERIFY      = 2; // IC ������ ���Ἲ üũ
  IC_READER_WORK_EVENT_START = 3; // IC ������ �̺�Ʈ ���� ����
  IC_READER_WORK_EVENT_STOP  = 4; // IC ������ �̺�Ʈ ���� ����
  IC_READER_WORK_AUTH_KEY_HW = 5; // IC ������ ����Ű H/W
  IC_READER_WORK_AUTH_KEY_SW = 6; // IC ������ ����Ű S/W

  STX              = #2;   // Start of Text
  ETX              = #3;   // End of Text
  EOT              = #4;   // End of Transmission
  ENQ              = #5;   // ENQuiry
  ACK              = #6;   // ACKnowledge
  NAK              = #$15; // Negative Acknowledge (#21)
  FS               = #$1C; // Field Separator (#28)
  CR               = #13;  // Carriage Return

  Cash_50000 = 50000;      // 5����

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
    vctKFTC : Result := '�����̹���.bmp';
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

  //  FLog.Write(ltBegin, ['��������', ['']]);
  try
    if MainVan = nil then
    begin
      Result.Result := False;
      Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, ['���� ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', IntToStr(Result.AgreeAmt)]);
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
  // ����Ʈ ����
  if ServiceGetStatus('', 'POS Security') = 4 then
  begin
    Result := True;
    Exit;
  end;
  // ����Ʈķ��
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
  FLog.Write(ltBegin, ['���ðŷ�', VanName, '�Ǹ��', FConfig.RealMode, '���ȸ��', FConfig.SecureMode,
                       'HostIP', FConfig.HostIP, 'HostPort', FConfig.HostPort, 'SignPad', FConfig.SignPad, 'SignPort', FConfig.SignPort, 'MSRPort', FConfig.MSRPort]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, ['���ðŷ�', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanModul.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['�ſ����', VanName, '�Ǹ��', FConfig.RealMode, '����/���', AInfo.Approval, '���ȸ��', FConfig.SecureMode, 'KeyIn', AInfo.KeyInput, 'MSRTrans', AInfo. MSRTrans,
                       'HostIP', FConfig.HostIP, 'HostPort', FConfig.HostPort, 'SignPad', FConfig.SignPad, 'SignPort', FConfig.SignPort, 'MSRPort', FConfig.MSRPort,
                       '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt, '�����ι�ȣ', AInfo.OrgAgreeNo, '����������', AInfo.OrgAgreeDate]);
  FPreDCAmt := 0;

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;

//  if not FConfig.RealMode then
//    MessageBox(0, '�׽�Ʈ ��� �����Դϴ�. ���� ������ �ƴմϴ�.', 'VanModul', MB_ICONWARNING or MB_OK);

  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  if MainVan.Config.SignPad then
  begin
    // TODO: OCX ��� ó�� ���� �߰�
    // �ش� ����� OCX ������ �ִ��� üũ�Ѵ�.
    // �ش� OCX�� ��ϵǾ��ִ��� üũ�Ѵ�.
    // ��ϵǾ����� ���� ��� ����Ѵ�.
  end;

  try
    // ����/��Ʈ�ʽ� �� ó��
    BeforePartnerShipProc(AInfo);
    // �� ���� ��� ȣ��
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

    // ����/��Ʈ�ʽ� �� ó��
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
  FLog.Write(ltEnd, ['�ſ� ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', IntToStr(Result.AgreeAmt)]);
end;

function TVanModul.CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['���ݽ���', VanName, '����/���', AInfo.Approval, '���ȸ��', FConfig.SecureMode, 'KeyIn', AInfo.KeyInput, 'MSRTrans', AInfo. MSRTrans,
                       '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt, '�����ι�ȣ', AInfo.OrgAgreeNo, '����������', AInfo.OrgAgreeDate]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
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

  FLog.Write(ltEnd, ['���� ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanModul.CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['��ǥ��ȸ', VanName, '���ȸ��', FConfig.SecureMode, '�ŷ��ݾ�', AInfo.CheckAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, '��ǥ��ȸ');
end;

function TVanModul.CallSignPad(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetSignData: AnsiString; out ARetEtcData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['�����е�(�������)', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetSignData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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

  FLog.Write(ltEnd, ['�����е�(��������)', ARetSignData]);
end;

function TVanModul.CallPinPad(out ARetSignData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['���е�', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetSignData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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

  FLog.Write(ltEnd, ['���е�', ARetSignData]);
end;

procedure TVanModul.CallPinCancel;
begin
  FLog.Write(ltBegin, ['���е� ���', VanName]);

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

  FLog.Write(ltEnd, ['���е� ���']);
end;

function TVanModul.CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['����ī��', VanName, '����/���', AInfo.Approval, '���ȸ��', FConfig.SecureMode, '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�!';
    Exit;
  end;
  // ��ȣ �����
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
 // FLog.Write(ltEnd, ['����ī�� ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
  FLog.Write(ltEnd, ['����ī�� ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', IntToStr(Result.AgreeAmt)]);
end;

function TVanModul.CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo,
  AEmvInfo: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['IC �Է� ��û', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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

  FLog.Write(ltEnd, ['IC �Է� ��û', ACardNo]);
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
  FLog.Write(ltBegin, ['�ܸ��� �񵿱� ��û', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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

  FLog.Write(ltEnd, ['�ܸ��� �񵿱� ��û']);
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
  FLog.Write(ltInfo, ['��ü ���� ����', VanName]);
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
  FLog.Write(ltBegin, ['�����ī�����', VanName, '���ȸ��', FConfig.SecureMode, '�ŷ��ݾ�', AInfo.SaleAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;

  AInfo.SaleAmt := ABS(AInfo.SaleAmt);

  Result := MainVan.CallMembership(AInfo);
  FLog.Write(ltEnd, '�����ī�����');
end;

function TVanModul.CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['IC ������ ����', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, ['IC ������ ����', ARecvData]);
end;

function TVanModul.CallMSR(AGubun: AnsiString; out ACardNo, ADecrypt, AEncData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['MSR �Է� ��û', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, ['MSR �Է� ��û', ACardNo]);
end;

function TVanModul.CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['MS �Է� ��û', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ACardNo := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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
  FLog.Write(ltEnd, ['MS �Է� ��û', ACardNo]);
end;

function TVanModul.CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['����IC����', VanName, '����/���', AInfo.Approval, '���ȸ��', FConfig.SecureMode, '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    if VanType = vctKFTC then
      Result := MainVan.CallCashIC(AInfo)
    else
      Result.Msg := '����� �������� ���� Van�� �Դϴ�.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallCashIC', E.Message]);
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['����IC ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanModul.CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['PayOn Ready', VanName, '�ŷ��ݾ�', APayAmt]);

  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;

  try
    if VanType = vctKFTC then
      Result := MainVan.CallPayOnReady(APayAmt, ARecvData)
    else
      ARecvData := '����� �������� ���� Van�� �Դϴ�.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPayOnReady', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['PayOn ���', Result, '�޼���', ARecvData]);
end;

function TVanModul.CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['PayOn', VanName, '����/���', AInfo.Approval, '���ȸ��', FConfig.SecureMode, '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt]);

  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  try
    if VanType = vctKFTC then
      Result := MainVan.CallPayOn(AInfo)
    else
      Result.Msg := '����� �������� ���� Van�� �Դϴ�.';
  except on E: Exception do
    begin
      FLog.Write(ltError, ['MainVan.CallPayOn', E.Message]);
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['PayOn ���', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanModul.CallChoiceCurrency(Msg1, Msg2, Msg3, Msg4, Msg5: AnsiString; out ARetCurrencyData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['��ȭ����', VanName]);

  if MainVan = nil then
  begin
    Result := False;
    ARetCurrencyData := 'Van�簡 �����Ǿ� ���� �ʽ��ϴ�.';
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

  FLog.Write(ltEnd, ['��ȭ����', ARetCurrencyData]);
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
  if Config.ProgramCode = '0301' then // ���콺
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
  Result.Msg := '�ش� ����� �������� �ʴ� Van�� �Դϴ�. ';
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
     0: Result := '����ó�� �Ǿ����ϴ�.';
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
                  // ��ǰ�ڵ�
                  RPadB(AInfo.DetailGoodsList[Index].GoodsCode, 15) +
                  // ��ǰ��
                  RPadB(AInfo.DetailGoodsList[Index].GoodsName, 40) +
                  // ����
                  FormatFloat('0000', AInfo.DetailGoodsList[Index].SaleQty) +
                  // �ܰ�
                  FormatFloat('0000000000', AInfo.DetailGoodsList[Index].SalePrice) +
                  // �ǸŰ�
                  FormatFloat('0000000000', AInfo.DetailGoodsList[Index].SaleAmt) +
                  // �ΰ���ġ��
                  FormatFloat('00000000', AInfo.DetailGoodsList[Index].SaleVat) +
                  // �����Һ�
                  FormatFloat('00000000', 0) +
                  // ������
                  FormatFloat('00000000', 0) +
                  // �����Ư����
                  FormatFloat('00000000', 0);
    ASum := ASum + AInfo.DetailGoodsList[Index].SaleAmt;
    ASumVat := ASumVat + AInfo.DetailGoodsList[Index].SaleVat;
    if Index >= 69 then Break; // �� ��� ������ �ִ� 70��
  end;
  SeqNo := GetSeqNo(CUBEREFUND_INI, True, 999);
  ApplyCode := IfThen(AInfo.IsRefund, '5308', '5302');
            // ���� Type
  Result := ApplyCode +
            // �ŷ�������ȣ
            RPadB('', 12) +
            // ���� flag
            'P' +
            // ������ ����ڹ�ȣ
            RPadB(FConfig.BizNo, 10) +
            // ������ü����
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // ������ ��ȣ
            RPadB(FConfig.TerminalID, 10) +
            // POS �Ϸù�ȣ
            FormatFloat('000', SeqNo) +
            // ������ �ŷ�������ȣ
            RPadB(FormatDateTime('yyyymmdd', Now) + FormatFloat('000', SeqNo), 20) +
            // �����Է� ���� (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // ���ǹ�ȣ
            IfThen(AInfo.IsRefund, RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150), RPadB(AInfo.PassportInfo, 150));
            // ��û�Ǽ�
  if Length(AInfo.DetailGoodsList) < 70 then
    Result := Result + FormatFloat('00', Length(AInfo.DetailGoodsList))
  else
    Result := Result + FormatFloat('00', 70);
            // ������ �Ǹ���ǥ��ȣ
  Result := Result + RPadB(AInfo.ReceiptNo, 30) +
            // ���׸�
            DetailInfo +
            // ��ǰ���� ����
            RPadB(AInfo.PayGubun, 1, '0') +
            // ���� �ʵ�
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
            // ���� Type
  Result := '5303' +
            // �ŷ�������ȣ
            RPadB('', 12) +
            // ���� flag
            'P' +
            // ������ ����ڹ�ȣ
            RPadB(FConfig.BizNo, 10) +
            // ������ü����
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // ������ ��ȣ
            RPadB(FConfig.TerminalID, 10) +
            // POS �Ϸù�ȣ
            FormatFloat('000', SeqNo) +
            // ��ұ��� (0:�ܸ���� 1:����� 2:�ڵ����)
            '0' +
            // �� �ŷ�����
            RPadB(OrgAgreeDate, 6) +
            // �� ȯ����ǥ�����ȣ
            RPadB(AInfo.OrgAgreeNo, 12) +
            // �����Է� ���� (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // ���ǹ�ȣ
            RPadB(AInfo.PassportInfo, 150);
            // �� ������ �ŷ�������ȣ
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
            // ���� Type
  Result := '5304' +
            // �ŷ�������ȣ
            RPadB('', 12) +
            // ���� flag
            'P' +
            // ������ ����ڹ�ȣ
            RPadB(FConfig.BizNo, 10) +
            // ������ü����
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // ������ ��ȣ
            RPadB(FConfig.TerminalID, 10) +
            // POS �Ϸù�ȣ
            FormatFloat('000', SeqNo) +
            // ��ұ��� (0:�ܸ���� 1:����� 2:�ڵ����)
            '0' +
            // �� �ŷ�����
            RPadB(OrgAgreeDate, 6) +
            // �� ȯ����ǥ�����ȣ
            RPadB(AInfo.OrgAgreeNo, 12) +
            // �����Է� ���� (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // ���ǹ�ȣ
            IfThen(AInfo.IsRefund, RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150), RPadB(AInfo.PassportInfo, 150)) +
            // �� ������ �ŷ�������ȣ
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
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 124, 200));
  // �ŷ�������ȣ
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // ������ �ŷ�������ȣ
  Result.TransNoStore := Trim(Copy(ARecvData, 32, 20));
  // �ŷ��Ͻ�
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // ȯ����ǥ �����ȣ
  Result.AgreeNo := Trim(Copy(ARecvData, 52, 12));
  // ���ǹ�ȣ
  Result.PassportNo := Trim(Copy(ARecvData, 64, 9));
  // ������ ����
  Result.BuyersName := Trim(Copy(ARecvData, 73, 40));
  // ������ ����
  Result.BuyersNationality := Trim(Copy(ARecvData, 113, 3));
  // ȯ�޾�
  TryStrToCurr(Trim(Copy(ARecvData, 116, 8)), Result.NetRefuncAmt);
  // ��������
  Result.Result := Result.Code = '0000';
end;

function TCubeRefund.MakeRefundRecvData(ARecvData: AnsiString): TCubeRefundRecvInfo;
var
  AResult: AnsiString;
begin
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 193, 100));
  // �ŷ�������ȣ
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // ������ �ŷ�������ȣ
  Result.TransNoStore := Trim(Copy(ARecvData, 32, 20));
  // �ŷ��Ͻ�
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // ȯ����ǥ �����ȣ
  Result.AgreeNo := Trim(Copy(ARecvData, 52, 12));
  // ���ǹ�ȣ
  Result.PassportNo := Trim(Copy(ARecvData, 78, 24));
  // ������ ����
  Result.BuyersName := Trim(Copy(ARecvData, 102, 40));
  // ������ ����
  Result.BuyersNationality := Trim(Copy(ARecvData, 142, 3));
  // ȯ�޾�
  TryStrToCurr(Trim(Copy(ARecvData, 145, 8)), Result.NetRefuncAmt);
  // �����ѵ�
  TryStrToCurr(Trim(Copy(ARecvData, 293, 10)), Result.ToTalLimit);
  // �������ѵ�
  TryStrToCurr(Trim(Copy(ARecvData, 313, 10)), Result.RemainingLimit);
  // ��������
  Result.Result := Result.Code = '0000';
end;

function TCubeRefund.MakeRecvCancelData(ARecvData: AnsiString): TCubeRefundRecvInfo;
begin
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 17, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 32, 100));
  // �ŷ�������ȣ
  Result.TransNo := Trim(Copy(ARecvData, 5, 12));
  // �ŷ��Ͻ�
  Result.TransDateTime := FormatDateTime('yyyymmddhhnnss', Now);
  // ��������
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
        Log.Write(ltDebug, ['���ȯ�� �ѵ� �ݾ� �ʰ�']);
        Result.Result := False;
        Result.Msg := '���ȯ�� �ѵ� �ݾ� �ʰ�';
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

  Log.Write(ltDebug, ['��������', SendData]);
  Result.Result := DLLExec(SendData, RecvData, AInfo.IsRefund);
  Log.Write(ltDebug, ['��������', RecvData]);
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
      AResult := CUBE_REFUND_DLL + '�� �����ϴ�.';
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
    if Index >= 69 then Break; // �� ��� ������ �ִ� 70��
  end;
  ASaleInfo := '5311' +
            // �ŷ�������ȣ
            RPadB('', 12) +
            // ���� flag
            'P' +
            // ������ ����ڹ�ȣ
            RPadB(FConfig.BizNo, 10) +
            // ������ü����
            RPadB(MSG_SOLBIPOS_SHORT, 20) +
            // ������ ��ȣ
            RPadB(FConfig.TerminalID, 10) +
            // POS �Ϸù�ȣ
            FormatFloat('000', SeqNo) +
            // ������ �ŷ�������ȣ
            RPadB(FormatDateTime('yyyymmdd', Now) + FormatFloat('000', SeqNo), 20) +
            // �����Է� ���� (K:Key-in, S; swipe)
            IfThen(AInfo.PassportKeyin, 'K', 'S') +
            // ���ǹ�ȣ
            RPadB(AInfo.PassportInfo + AInfo.Nationality + AInfo.GuestName, 150) +
            // �Ǹűݾ�
            CurrToStr(ASum) +
            // �ΰ���ġ��
            CurrToStr(ASumVat) +
            // ��Ÿ���� ��
            RPadB('', 8) +
            // �����ʵ� 34
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

      TLog.Write('MTIC ����:' + IfThen(ASendInfo.Approval, 'True', 'False') + ' �ݾ�:' + CurrToStr(ASendInfo.GoodsAmt) + ' ���ڵ�:' + ASendInfo.BarCode);
  	  nRet := Exec(PAnsiChar(Mode), PAnsiChar(ASendInfo.VanCode), PAnsiChar(ASendInfo.SvcID), PAnsiChar(ASendInfo.TransNo),
                   PAnsiChar(PrdtPrice), '', '', PAnsiChar(ASendInfo.BarCode), '1', '',
                   ResultCd, ResultMsg, ActDate, ApprNo, RemainAmt);

      Result.Result := ResultCd = '0000';
      Result.Code := ResultCd;
      Result.Msg := ResultMsg + GetErrorMsg(nRet);
      Result.AgreeNo := ApprNo;
      Result.TransDateTime := ActDate;
      TryStrToCurr(RemainAmt, Result.RemainAmt);

      TLog.Write('MTIC ' + '�ڵ�:' + Result.Code + ' �޼���:' + Result.Msg + ' ���ι�ȣ:' + Result.AgreeNo + ' �����Ͻ�:' + Result.TransDateTime);
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
     0 : Result := '����ó�� �Ǿ����ϴ�.';
     5 : Result := '������ ������ �����ϴ�.';
    10 : Result := '�ش� ���ڵ忡 ���� �������� ã�� �� �����ϴ�.';
    11 : Result := '�̵���Ż翡 ��ϵ��� ���� ���Դϴ�.';
    12 : Result := '������ �ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.';
    13 : Result := '��������� ���Դϴ�.';
    14 : Result := '������ ��ȭ��ȣ �Դϴ�.';
    15 : Result := '����ڸ��� �޴���(������)�� ����Ͻ� �� �����ϴ�.';
    16 : Result := '��ſ�ݹ̳����� �Ҿװ��� ����� �Ұ��մϴ�.';
    17 : Result := '��ſ�� �����ڴ� �Ҿװ��� ����� �Ұ��մϴ�.';
    19 : Result := '�����븮�� ���ǰ� �Ϸ���� �ʾҽ��ϴ�. Ȯ���� �ٽ� �õ��� �ּ���.';
    20 : Result := '������������ ��ġ���� �ʽ��ϴ�.';
    21 : Result := '�̵���Ż� �����ѵ��� �ʰ� �Ǿ����ϴ�.';
    31 : Result := '�̹��� ���� �ѵ��� �ʰ��Ǿ����ϴ�. ������(1600-0527)�� �����Ͻʽÿ�.';
    32 : Result := '�̼���(14������)������ �޴����� ������ �̿��ϽǼ� �����ϴ�.';
    33 : Result := 'TTL School ����� �����ڴ� ���񽺰� �Ұ��մϴ�.';
    34 : Result := 'DUAL NUMBER �Ǵ� 080 NUMBER�� �Ҿװ����� �̿��Ͻ� �� �����ϴ�.';
    36 : Result := '�̵���Ż翡 �Ҿװ��������� ��û�Ͻ� ��ȣ�Դϴ�. �ش� �̵���Ż�� �����Ͻʽÿ�.';
    38 : Result := '���� ��å�� �ش����� ������ �Ұ��Ͽ��� Ÿ���������� �̿��Ͻñ� �ٶ��ϴ�.(1600-0527)';
    39 : Result := '��ȿ�ð� ���� ���������� �ֽ��ϴ�. ��� �� ����Ͻʽÿ�.';
    41 : Result := '�� �ŷ������� �����ϴ�.';
    42 : Result := '������� �Ⱓ�� ����Ǿ� ������Ҹ� �� �� �����ϴ�.';
    44 : Result := '�̹� ��ҵ� �ŷ��Դϴ�.';
    48 : Result := '������ ������ �ܸ����̹Ƿ� ��Ż翡�� ����Ȯ�� �� ������ �����մϴ�.(1544-0010)';
    54 : Result := '����(���Ǻ���)�� 3�� �̳����� ������ ���ѵ˴ϴ�. �ٸ� ���������� �̿��� �ֽñ� �ٶ��ϴ�.';
    58 : Result := '���� ��å�� �ش����� ������ �Ұ��Ͽ��� Ÿ���������� �̿��Ͻñ� �ٶ��ϴ�.(1600-0527)';
    59 : Result := '���� ��å�� �ش����� ������ �Ұ��Ͽ��� Ÿ���������� �̿��Ͻñ� �ٶ��ϴ�.(1600-0527)';
    60 : Result := '�ܱ��θ����� �޴����� ������ ����Ͻ� �� �����ϴ�.';
    71 : Result := '��ϵ��� ���� �����Դϴ�. �ش� ���񽺾�ü�� �����Ͻʽÿ�.';
    96 : Result := '�ŷ� ������ Ȯ���� �����ǰ� �ֽ��ϴ�. ������(1600-0527)�� �����Ͻʽÿ�.';
    97 : Result := '��û�ڷῡ ������ �ֽ��ϴ�. �ش� ���񽺾�ü�� �����Ͻʽÿ�.';
    98 : Result := '�ŷ� ������ Ȯ���� �����ǰ� �ֽ��ϴ�. ����� �ٽ� ����Ͻʽÿ�..';
    99 : Result := '���� ����ڰ� ���Ƽ� ���񽺰� �����ǰ� �ֽ��ϴ�. ����� ����� �ֽʽÿ�.';
    9002 : Result := '�α� ������ ������ �� �����ϴ�.';
    9003 : Result := 'Mtic.ini ���Ͽ��� �Դϴ�.';
    9100 : Result := '��������(Mode)�� ��ȿ���� �ʽ��ϴ�.';
    9101 : Result := '�������ڵ�(VanCode)�� ��ȿ���� �ʽ��ϴ�.';
    9102 : Result := '������ID(SvcId)�� ��ȿ���� �ʽ��ϴ�.';
    9103 : Result := '�ŷ���ȣ(TrxNo)�� ��ȿ���� �ʽ��ϴ�.';
    9104 : Result := '��ǰ����(PrdtPrice)�� ��ȿ���� �ʽ��ϴ�.';
    9105 : Result := '��ǰ��(PrdtNm)�� ��ȿ���� �ʽ��ϴ�.';
    9106 : Result := '�����ڵ�(DeviceId)�� ��ȿ���� �ʽ��ϴ�.';
    9108 : Result := '���ڵ尪(BarCode)�� ��ȿ���� �ʽ��ϴ�.';
    9109 : Result := '���ι�ȣ(ApprNo)�� ��ȿ���� �ʽ��ϴ�.';
    9110 : Result := '����Ÿ��(AuthType)�� ��ȿ���� �ʽ��ϴ�.';
    9111 : Result := '�޴�����ȣ(PhoneNo)�� ��ȿ���� �ʽ��ϴ�.';
    9901 : Result := '��Ÿ�� �ʱ�ȭ�� ������ �߻��Ͽ����ϴ�.';
    9902 : Result := 'MTic������ ������ �� �����ϴ�.';
    9903 : Result := 'MTic������ ���������͸� ������ �� �����ϴ�.';
    9904 : Result := 'MTic�����κ��� ������ ���� ������ �ֽ��ϴ�.';
    9905 : Result := 'MTic������ ����ð��� �ʰ��Ǿ����ϴ�.';
    9999 : Result := '�� �� ���� �����Դϴ�. ����ڿ� �����ϼ���.';
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
  // ���ȸ���� ����Ҷ��� ����� ����϶��� �α׸� �����.
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
    11 : Result := '����Ʈ ���� �Ұ�';
    12 : Result := '����Ʈ ��� �Ұ�';
    13 : Result := '����Ʈ ������� �Ұ�';
    14 : Result := '����Ʈ ������ �Ұ�';
    15 : Result := 'ī���ȣ ����';
    16 : Result := '�̵�� ������';
    17 : Result := '����Ʈ �����Ұ� ������';
    18 : Result := '����Ʈ ���Ұ� ������';
  else
    Result := '��Ÿ ����';
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
  // ���� ��ȣ
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

                   // ���۱�� �ڵ�
  Result := Result + 'SOLB'
                   // ���� ����
                   + FormatDateTime('yyyymmdd', Now)
                   // ���� �ð�
                   + FormatDateTime('hhnnss', Now)
                   // �������� ��ȣ
                   + FormatFloat('000000000000', GetSeqNo)
                   // ���� �ڵ�
                   + '  '
                   // ������ ��ȣ
                   + Format('%-15.15s', [ASendInfo.TerminalID])
                   // �ŷ� ����
                   + FormatDateTime('yyyymmdd', Now)
                   // �ŷ� �ð�
                   + FormatDateTime('hhnnss', Now)
                   // �ŷ� ����
                   + TradeType
                   // WCC
                   + IfThen(ASendInfo.KeyIn, '2', '0')
                   // Track II
                   + Format('%-37.37s', [ASendInfo.TrackTwo])
                   // ��й�ȣ
                   + Format('%-16.16s', [ASendInfo.Password])
                   // �ŷ��ݾ� (Filler)
                   + FormatFloat('0000000000', ASendInfo.SaleAmt)
                   // ���ι�ȣ (Filler)
                   + '            '
                   // �� ���� ���� (Filler)
                   + Format('%-8.8s', [ASendInfo.OrgAgreeDate])
                   // �� ���� ��ȣ (Filler)
                   + Format('%-12.12s', [ASendInfo.OrgAgreeNo])
                   // �߻� POINT
                   + FormatFloat('000000000', 0)
                   // ���� POINT
                   + FormatFloat('000000000', 0)
                   // ���� POINT
                   + FormatFloat('000000000', 0)
                   // ��� ����
                   + IfThen(AType in [btSave, btUse, btInquiry], '0', '3')
                   // �޼��� 1
                   + '                        '
                   // �޼��� 2
                   + '                        '
                   // �޼��� 3
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
    // ���� ��û�� �Ѵ�
    Index := Exec(PAnsiChar(ACatID), PAnsiChar(ATranCode), PAnsiChar(AAuthNo), PAnsiChar(TranAmt), @ARecvData[1]);
//    Index := Exec(PAnsiChar('90100546'), PAnsiChar('D1'), PAnsiChar('77657510'), PAnsiChar('1000'), @ARecvData[1]);

    // ������ ó���Ѵ�.
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
          Result.Msg := '��Ʈ��ũ ���� KIS ���� ���� ����.';
        end
    else
      Result.Msg := '�� �� ���� �����Դϴ�. �����ڵ�:' + IntToStr(Index);
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
  if FConfig.Gubun = 'T' then   // T: �ý���������, S: ����
    SendData := MakeSendData(AInfo)
  else
    SendData := MakeSendStartData(AInfo);

  Log.Write(ltDebug, ['��������', SendData]);
  Result.Result := DLLExec(FConfig.Gubun, SendData, RecvData);
  Log.Write(ltDebug, ['��������', RecvData]);

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
    Result := '����ó�� �Ǿ����ϴ�.'
  else if ACode = '200' then
    Result := '�����ְ� �߻��߽��ϴ�.'
  else if ACode = '300' then
    Result := '���������� �ֽ��ϴ�.'
  else if ACode = '400' then
    Result := '�������� �ʿ��մϴ�.'
  else
    Result := '���ν��� �߽��ϴ�.';
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
  Result.GtGbn              := Copy(ARecvData, 1, 2);                                     // ��������
  Result.GtVersion          := Copy(ARecvData, 3, 10);                                    // ��������
  Result.GtDocCd            := Copy(ARecvData, 13, 3);                                    // �����ڵ�
  Result.GtSno              := Copy(ARecvData, 16, 20);                                   // �����Ϸù�ȣ
  Result.GtCancel           := Copy(ARecvData, 36, 1);                                    // ������ҿ���
  Result.GtApprovalNo       := Copy(ARecvData, 37, 10);                                   // �ŷ����ι�ȣ
  Result.GtBizNo            := Copy(ARecvData, 47, 10);                                   // �Ǹ��ڻ���ڹ�ȣ
  Result.GtTerminalId       := Copy(ARecvData, 57, 10);                                   // �ܸ���ID
  Result.GtSellTime         := Copy(ARecvData, 67, 14);                                   // �Ǹų���Ͻ�
  Result.TotQty             := StrToIntDef(Copy(ARecvData, 81, 4), 0);                    // �Ǹ��Ѽ���
  Result.TotSaleAmt         := StrToFloatDef(Copy(ARecvData, 85, 9), 0);                  // �Ǹ��ѱݾ�
  Result.TotRefundAmt       := StrToFloatDef(Copy(ARecvData, 94, 8), 0);                  // ȯ���Ѿ�
  Result.PayGbn             := Copy(ARecvData, 102, 1);                                   // ��������
  Result.CardNo             := Copy(ARecvData, 103, 21);                                  // �ſ�ī���ȣ
  Result.ChCardGbn          := Copy(ARecvData, 124, 1);                                   // ����ī�忩��
  Result.JuminNo            := Copy(ARecvData, 125, 13);                                  // �ֹε�Ϲ�ȣ
  Result.PassportNm         := Copy(ARecvData, 138, 40);                                  // ���ǿ����̸�
  Result.PassportNo         := Copy(ARecvData, 178, 9);                                   // ���ǹ�ȣ
  Result.PassportNationCd   := Copy(ARecvData, 187, 3);                                   // ���Ǳ����ڵ�
  Result.PassportSex        := Copy(ARecvData, 190, 1);                                   // ���Ǽ���
  Result.PassportBirth      := Copy(ARecvData, 191, 6);                                   // ���ǻ������
  Result.PassportExpireDt   := Copy(ARecvData, 197, 6);                                   // ���Ǹ�����
  Result.ResponseCd         := Copy(ARecvData, 203, 3);                                   // �����ڵ�
  Result.ResponseMsg        := Copy(ARecvData, 206, 60);                                  // ����޼���
  Result.ShopNm             := Copy(ARecvData, 266, 40);                                  // �����
  Result.DetailCnt          := StrToIntDef(Copy(ARecvData, 306, 4), 0);                   // ��ǰ�ιݺ�Ƚ��
  Result.ExportExpirtDt     := Copy(ARecvData, 310, 8);                                   // ������ȿ�Ⱓ
  Result.RctNo              := Copy(ARecvData, 318, 30);                                  // ��������ȣ
  Result.Bigo               := Copy(ARecvData, 348, 15);                                  // ���
  Result.DetailGoodsList.DetailSNo          := Copy(ARecvData, 363, 3);                   // �Ϸù�ȣ
  Result.DetailGoodsList.DetailGVatGbn      := Copy(ARecvData, 366, 1);                   // �����Һ񼼱���
  Result.DetailGoodsList.DetailGoodsGbn     := Copy(ARecvData, 367, 2);                   // ��ǰ�ڵ�
  Result.DetailGoodsList.DetailGoodsNm      := Copy(ARecvData, 369, 50);                  // ��ǰ����
  Result.DetailGoodsList.DetailQty          := StrToIntDef(Copy(ARecvData, 419, 4), 0);   // ����
  Result.DetailGoodsList.DetailDanga        := StrToFloatDef(Copy(ARecvData, 423, 9), 0); // �ܰ�
  Result.DetailGoodsList.DetailSaleAmt      := StrToFloatDef(Copy(ARecvData, 432, 9), 0); // �ǸŰ���
  Result.DetailGoodsList.DetailVat          := StrToFloatDef(Copy(ARecvData, 441, 8), 0); // �ΰ���ġ��
  Result.DetailGoodsList.DetailGVat         := StrToFloatDef(Copy(ARecvData, 449, 8), 0); // �����Һ�
  Result.DetailGoodsList.DetailGEdVat       := StrToFloatDef(Copy(ARecvData, 457, 8), 0); // ������
  Result.DetailGoodsList.DetailGFmVat       := StrToFloatDef(Copy(ARecvData, 465, 8), 0); // �����Ư����
  Result.DetailGoodsList.DetailBigo         := Copy(ARecvData, 473, 16);                  // ���
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
  // ���� Type
  Result := RPadB(AInfo.GtGbn, 2) +                              // ��������(2)
            RPadB(AInfo.GtVersion, 10) +                         // ��������(10)
            '901' +                                              // �����ڵ�(3) ��û:101, ���:301, 901: ����
            RPadB(AInfo.GtBizNo, 10) +                           // �Ǹ��ڻ���ڹ�ȣ(10)
            RPadB(AInfo.GtTerminalId, 10) +                      // �ܸ���ID (10)
            RPadB(AInfo.GtSellTime, 14) +                        // �Ǹų����(14)
            RPadB(AInfo.ResponseCd, 3) +                         // �����ڵ�(3)
            RPadB(AInfo.ResponseMsg, 60) +                       // ����޽���(60)
            RPadB(AInfo.ShopNm, 40);                             // �����(40)
end;

procedure TGlobalTaxFree.SetConfig(AValue: TGlobalTaxFreeConfigInfo);
begin
  FConfig := AValue;
end;

function TGlobalTaxFree.MakeSendData(AInfo: TGlobalTaxFreeSendInfo): AnsiString;
begin
  // ���� Type
  Result := RPadB(AInfo.GtGbn, 2) +                              // ��������(2)
            RPadB(AInfo.GtVersion, 10);                          // ��������(10)

  if AInfo.Approval then
    Result := Result + '101'                                     // �����ڵ�(3) ��û:101, ���:301, 901: ����
  else
    Result := Result + '301';                                    // �����ڵ�(3) ��û:101, ���:301, 901: ����

  Result:= Result + RPadB(AInfo.GtSno, 20);                      // �����Ϸù�ȣ(20)

  if AInfo.Approval then
    Result:= Result + 'N'                                        // ������ҿ���(1) �Ǹ�: N, ���: Y
  else
    Result:= Result + 'Y';

  Result:= Result + RPadB(AInfo.GtApprovalNo, 10) +                               // �ŷ����ι�ȣ(10)
            RPadB(AInfo.GtBizNo, 10) +                                            // �Ǹ��ڻ���ڹ�ȣ(10)
            RPadB(AInfo.GtTerminalId, 10) +                                       // �ܸ���ID (10)
            RPadB(AInfo.GtSellTime, 14) +                                         // �Ǹų����(14)
            FormatFloat('0000', Abs(AInfo.TotQty)) +                              // �Ǹ��Ѽ���(4)
            FormatFloat('000000000', Abs(AInfo.TotSaleAmt)) +                     // �Ǹ��ѱݾ�(9)
            FormatFloat('00000000', Abs(AInfo.TotRefundAmt)) +                    // ȯ���Ѿ�(8)
            RPadB(AInfo.PayGbn, 1) +                                              // ��������(1)
            RPadB(AInfo.CardNo, 21) +                                             // �����ſ�ī���ȣ(21)
            RPadB(AInfo.ChCardGbn, 1) +                                           // ����ī�忩��(1)
            RPadB(AInfo.JuminNo, 13) +                                            // �ֹι�ȣ(13)
            RPadB(AInfo.PassportNm, 40) +                                         // ���ǿ����̸�(40)
            RPadB(AInfo.PassportNo, 9) +                                          // ���ǹ�ȣ(9)
            RPadB(AInfo.PassportNationCd, 3) +                                    // ���Ǳ����ڵ�(3)
            RPadB(AInfo.PassportSex, 1) +                                         // ���Ǽ���(1)
            RPadB(AInfo.PassportBirth, 6) +                                       // ���ǻ������(6)
            RPadB(AInfo.PassportExpireDt, 6) +                                    // ���Ǹ�����(6)
            RPadB(AInfo.ResponseCd, 3) +                                          // �����ڵ�(3)
            RPadB(AInfo.ResponseMsg, 60) +                                        // ����޽���(60)
            RPadB(AInfo.ShopNm, 40) +                                             // �����(40)
            FormatFloat('0000', 1) +                                              // ��ǰ�ιݺ�Ƚ��(4)
            RPadB(AInfo.ExportExpirtDt, 8) +                                      // ������ȿ�Ⱓ(8)
            RPadB(AInfo.RctNo, 30) +                                              // ��������ȣ(30)
            RPadB(AInfo.Bigo, 15) +                                               // ���(15)
            RPadB(AInfo.DetailGoodsList.DetailSNo, 3) +                           // ��ǰ�Ϸù�ȣ(3)
            RPadB(AInfo.DetailGoodsList.DetailGVatGbn, 1) +                       // �����Һ񼼱���(1)
            RPadB(AInfo.DetailGoodsList.DetailGoodsGbn, 2) +                      // ��ǰ�ڵ�(2)
            RPadB(AInfo.DetailGoodsList.DetailGoodsNm, 50) +                      // ��ǰ��(50)
            FormatFloat('0000', Abs(AInfo.DetailGoodsList.DetailQty)) +           // ����(4)
            FormatFloat('000000000', Abs(AInfo.DetailGoodsList.DetailDanga)) +    // �ܰ�(9)
            FormatFloat('000000000', Abs(AInfo.DetailGoodsList.DetailSaleAmt)) +  // �ǸŰ���(9)
            FormatFloat('00000000', Abs(AInfo.DetailGoodsList.DetailVat)) +       // �ΰ���ġ��(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGVat) +           // �����Һ�(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGEdVat) +         // ������(8)
            FormatFloat('00000000', AInfo.DetailGoodsList.DetailGFmVat) +         // �����Ư����(8)
            RPadB(AInfo.DetailGoodsList.DetailBigo, 16);                          // ���(16)
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
  PassPortKeyData: array[0..31] of AnsiChar;         // ���ǹ�ȣ ��ȣȭ ������ ����(32)
  PassPortReadData: array[0..299] of AnsiChar;       // ���Ǹ������ ���� ������ ����(300)
  Index: Integer;
begin
  AInfo.KeyIn := Length(AInfo.PassportNo) >= 9 ;
  // ��ȣŰ
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
            ShowMessageForm('�����νı⿡ ������ �±��Ͽ� �ֽʽÿ�.' + #13#10#13#10 + '��ø� ��ٷ� �ֽñ� �ٶ��ϴ�.', True);
            Exec := GetProcAddress(DLLHandle, 'ScanPassportEncrypt');
            if Assigned(@Exec) then
            begin
              APort := 'COM' + IntToStr(AInfo.Port);
              Index := Exec(PAnsiChar(APort), 10000, PassPortReadData, 300, 1, PAnsiChar(AInfo.GtRcpTradeNo));
              AInfo.PassportNo := PassPortReadData;
              Log.Write(ltInfo, ['�������� �������� : ', AInfo.PassportNo]);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          Log.Write(ltInfo, ['�������� ���� ����', E.Message]);
        end;
      end;
    finally
      HideMessageForm;
      FreeLibrary(DLLHandle);
    end;
  end;

  // ��������
  SendData := MakeSendData(AInfo);
  Index := Length(SendData);

  RecvData := EmptyStr;
  Result.Result := DLLExec(FConfig.Gubun, SendData, RecvData);
  Result.GtRcpTradeNo := AInfo.GtRcpTradeNo;
  // ����ó��
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
//    Log.Write('���� : ' + Length(ASendData));

    //���� �ÿ��� ���̸�ŭ ���� �� ������ ���������� ���� �߸��Ǿ�
    //���з� ������ ��� ���̷� ������ ���ϰ��� ���� �ʴ´�.
    ARecvData := IdTaxClient.IOHandler.ReadString(Length(ASendData));
    if (Copy(ARecvData, 9, 1) = '0') then
      Result := True;

    IdTaxClient.Disconnect;
  except
    on E: Exception do
    begin
      ARecvData := IdTaxClient.IOHandler.ReadString(300);
      Log.Write(ltInfo, ['ȯ�޽���', ARecvData]);
      ARecvData := 'Error Code=' + Copy(ARecvData, 10, 3) + #13#10 + Trim(Copy(ARecvData, 13, 120));
    end;
  end;
end;

function TKTISTaxFree.GetErrorMsg(ACode: AnsiString): AnsiString;
begin
  if ACode = '001' then
    Result := '���ǵ��� ���� �޽��� ��ȣ'
  else if ACode = '002' then
    Result := '���ǵ��� ���� �޽��� ����'
  else if ACode = '003' then
    Result := '��Ȯ�� ������ü�ڵ�'
  else if ACode = '004' then
    Result := '��Ȯ�� ����Ÿ���ڵ�'
  else if ACode = '005' then
    Result := '��������������'
  else if ACode = '006' then
    Result := '�����������'
  else if ACode = '007' then
    Result := '�ʼ������ͺ���'
  else if ACode = '008' then
    Result := '���� ������ ������ ����'
  else if ACode = '099' then
    Result := '�����ǿ���'
  else if ACode = '101' then
    Result := '���Ź�ȣ����'
  else if ACode = '102' then
    Result := '��ǥ��ȿ�Ⱓ���'
  else if ACode = '103' then
    Result := '�����ջ�ݾ׺���ġ'
  else if ACode = '104' then
    Result := '3�����̸�'
  else if ACode = '105' then
    Result := '�̹� ���� ������ �����Ϸù�ȣ'
  else if ACode = '106' then
    Result := '��ǰ�ڵ����'
  else if ACode = '107' then
    Result := '�ջ�Ұ���ǥ����'
  else if ACode = '108' then
    Result := '����ȱ��Ź�ȣ'
  else if ACode = '109' then
    Result := 'ȯ�޵ȱ��Ź�ȣ'
  else if ACode = '110' then
    Result := '����ȯ�޵ȱ��Ź�ȣ'
  else if ACode = '111' then
    Result := '�ΰ��� ���� ����'
  else if ACode = '112' then
    Result := '�ջ���� ����ġ'
  else
    Result := '���ν��� �߽��ϴ�.';
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
    Result.GtApprovalNo     := Copy(ARecvData, 301, 20);            //���ι�ȣ
    Result.PassportNo       := Copy(ARecvData, 324, 32);            //���ǹ�ȣ ��ȣȭ
    Result.PassportNationCd := Copy(ARecvData, 356, 3);             //����
    Result.PassportNm       := Copy(ARecvData, 359, 40);            //�����̸�
    Result.PassportSex      := Copy(ARecvData, 411, 1);             //���Ǽ���
    Result.PassportExpireDt := Copy(ARecvData, 399, 6);             //���Ǹ�����
    Result.PassportBirth    := Copy(ARecvData, 405, 6);             //���ǻ������
    Result.RefundAmt        := StrToCurr(Copy(ARecvData, 482, 10)); //���ȯ�� �ݾ�
    Result.BeforeRefundAmt  := StrToCurr(Copy(ARecvData, 452, 10)); //�������ȯ�� �ݾ�
    Result.AfterRefundAmt   := StrToCurr(Copy(ARecvData, 462, 10)); //�������ȯ�� �ݾ�
  end;
end;

function TKTISTaxFree.MakeSendData(
  AInfo: TKTISTaxFreeSendInfo): AnsiString;
var
  sBody, vQty, sGubun: AnsiString;
  TmpAmt, nLen: Integer;

  function MakeApprovalBodySave(ADateTime: AnsiString): AnsiString; // ȯ����ǥ�߱� Body  ( ���ν� )
  var
    sPayGubun: AnsiString;
    Index: Integer;
    cCashAmtSum, cCardAmtSum, cTaxFreeAmtSum, cRefundAmt: Currency;
  begin
    //AInfo.RefundAmt := 1500;                             // �������� �� �̹� ȯ�޿��θ� Ȯ���ϰ� ���� ��
    cTaxFreeAmtSum  := AInfo.TotFreeAmt;                                        // �鼼�ݾ� �հ�
    cCashAmtSum     := AInfo.TotCashAmt;                                        // ���ݸ���
    cCardAmtSum     := AInfo.TotCardAmt;                                        // ī�����
    cRefundAmt      := AInfo.RefundAmt;                                         // ���ȯ�� �ݾ�
    if cTaxFreeAmtSum > 0 then                                                  // �鼼 �ݾ��� �������
    begin
      if cCashAmtSum  >= cTaxFreeAmtSum then                                    // ���ݾ��� �鼼�ݾ׺��� ������� ���� - �鼼
        cCashAmtSum := cCashAmtSum - cTaxFreeAmtSum
      else                                                                      // ī�� - �鼼 - ����
      begin
        cCashAmtSum := 0;
        cCardAmtSum := cCardAmtSum - cTaxFreeAmtSum  - cCashAmtSum;
      end;
    end;

    if (cCashAmtSum = 0) and (cCardAmtSum <> 0) then
      sPayGubun := 'C' // ī��
    else if (cCardAmtSum = 0) and (cCashAmtSum <> 0) then
      sPayGubun := 'M'// ����
    else
      sPayGubun := 'A'; // ���� + ī�� + ����ȭ��
//    else
//      sPayGubun := 'E'; // ����ȭ��

    nLen  := ByteLen(AInfo.ShopNm);
    Result := Result + AInfo.ShopNm + RPadB('', 50 - nLen, ' '); // shop_nm(50)

    Result := Result + IfThen(AInfo.IsRefund, 'D', 'A');                        // T: ���, F: ����

    // 0: �ѵ���ȸ, 1: ���ȯ�� ������, 2: ����
    // 0: ������������, 1: ��������(��ȣȭ AES-256), 2: ���Ǹ����� ����
    if AInfo.IsRefund then
    begin
      if AInfo.GtGbn = 'S' then
        Result := Result + '02'   // ��ȸ
      else
      begin
        if AInfo.KeyIn then
          Result := Result + '21'  // ����
        else
          Result := Result + '22';  // ����
      end;
    end
    else
    begin
      if AInfo.GtGbn = 'S' then
        Result := Result + '00'            // ��ȸ
      else
      begin
        if AInfo.ReaderInfo then
          Result := Result + '22'          // ����(������������)
        else
          Result := Result + '20';         // ����(������������)
      end;
    end;

    if AInfo.KeyIn and AInfo.IsRefund then
    begin   // ���ǿ� �ִ� ������
      Result := Result + RPadB(AInfo.PassportNo, 32, ' ');                      // ��������(��ȣȭ)
      Result := Result + AInfo.PassportNationCd;                                // �����ڵ�(3)
      Result := Result + RPadB(AInfo.PassportNm, 40, ' ');                      // �̸�
      Result := Result + AInfo.PassportBirth;                                   // ���Ǹ�����
      Result := Result + AInfo.PassportExpireDt;                                // ���ǻ���
      Result := Result + AInfo.PassportSex;                                     // ����
    end
    else  // ����ȯ�� ��������
      Result := Result + RPadB('', 88, ' ');

    // �⺻�� 0 ���ȯ���� ����
//    Result := Result + IfThen(AInfo.GtGbn = 'K', ' ', '0');                     // �������� DLL , Cube ���Ǹ����� , 3M CR100
    Result := Result + IfThen(AInfo.IsRefund, '0', ' ');                     // �������� DLL , Cube ���Ǹ����� , 3M CR100
    // �⺻�� 0128 ���� ���ȯ���� ����
//    Result := Result + IfThen(AInfo.GtGbn = 'K', '    ', '0128');               // ���ǵ����� ���� 0: 0128, 1: 0128, 2: 0152
    Result := Result + IfThen(AInfo.IsRefund, '0128', '0000');               // ���ǵ����� ���� 0: 0128, 1: 0128, 2: 0152

    if (not AInfo.IsRefund) or AInfo.KeyIn then
      Result := Result + RPadB('', 300, ' ') // ���ǵ�����
    else
      Result := Result + RPadB(AInfo.PassportNo, 300, ' '); // ���ǵ�����
//      Result := Result + RPadB(IfThen(AInfo.GtGbn = 'K', '', AInfo.PassportNo), 300, ' '); // ���ǵ�����
    Result := Result + RPadB('', 51, ' ');                                                 // �����ʵ� ����ó��
                      Log.Write(ltInfo, ['AInfo.GtSno', AInfo.GtSno]);
    Result := Result + FormatFloat('000', 1);                                                              // ����Ʈ ������
    Result := Result + RPadB(AInfo.GtSno , 50, ' ');                                                       // merch_buy_no(50)  POS�����Ϸù�ȣ
    Result := Result + LPadB(FloatToStr(cCashAmtSum), 10, '0');                                            // sale_cash_amt(10) ���ݰ����ݾ�
    Result := Result + LPadB(FloatToStr(cCardAmtSum), 10, '0');                                            // sale_card_amt(10) ī������ݾ�
    Result := Result + LPadB(FloatToStr(AInfo.TotECashAmt), 10, '0');                                      // sale_etc_amt(10) ����ȭ��ݾ�
    Result := Result + LPadB('', 42, ' ');                                                                 // filler(42)
    Result := Result + ADateTime;                                                                          // sale_dttm(14)  �Ǹ��Ͻ�
    Result := Result + sPayGubun;                                                                          // setl_typ_cd(1) C:ī��, M:����, A:����+ī��
    Result := Result + LPadB(IntToStr(Abs(AInfo.TotQty)), 10, '0');                                        // sale_tot_qty(10)  �Ǹ��Ѽ���
    Result := Result + LPadB(FloatToStr(Abs(AInfo.TotSaleAmt)), 10, '0');                                  // sale_tot_amt(10)  �Ǹ��ѱݾ�
    Result := Result + LPadB(FloatToStr(Abs(AInfo.TotSumVat)), 10, '0');                                   // vat_sum(10)  �ΰ���ġ���հ�
    Result := Result + LPadB('', 10, '0');                                                                 // ic_tax_sum(10) �����Һ��հ�
    Result := Result + LPadB('', 10, '0');                                                                 // ed_tax_sum(10) �������հ�
    Result := Result + LPadB('', 10, '0');                                                                 // ffvs_tax_sum(10) �����Ư�����հ�
    Result := Result + FormatFloat('000', AInfo.TotCntSale);
//    Result := Result + LPadB(IntToStr(Length(AInfo.DetailGoodsList)), 3, '0');                                          // item_arr_size(3) ���Ź�ǰ��������

    Log.Write('�����Ϸù�ȣ: ' + AInfo.GtSno);

    for Index := Low(AInfo.DetailGoodsList) to High(AInfo.DetailGoodsList) do
    begin
      nLen  := ByteLen(AInfo.DetailGoodsList[Index].DetailGoodsNm);
      Result := Result + AInfo.DetailGoodsList[Index].DetailGoodsNm + RPadB('', 200 - nLen, ' '); // prod_cts(200) ��ǰ��
//      Result := Result + AInfo.DetailGoodsList[Index].DetailGoodsNm + RPadB('', 200 - nLen, ' '); // prod_cts(200) ��ǰ��
//      Log.Write(Format('��ǰ������: Bytes=%d, Length=%d, Product=%s', [nByte, nLen, AInfo.DetailGoodsList[Index].DetailGoodsNm]));

      Result := Result + RPadB(AInfo.DetailGoodsList[Index].DetailGoodsGbn, 30, ' ');                      // prod_cd(30)   ��ǰ�ڵ�
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailQty);                // qty(10) ����
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailDanga);              // uprice(10) �ܰ�
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailSaleAmt);            // sale_price(10) �ǸŰ���
      Result := Result + FormatFloat('0000000000', AInfo.DetailGoodsList[Index].DetailVat);                // vat(10) �ΰ���ġ��
      Result := Result + LPadB('', 10, '0');                                                               // ic_tax(10) �����Һ�
      Result := Result + LPadB('', 10, '0');                                                               // ed_tax(10) ������
      Result := Result + LPadB('', 10, '0');                                                               // ffvs_tax(10) �����Ư����
      Result := Result + LPadB('', 100, ' ');                                                              // ������ǰ�����ڵ� + ����
    end;
  end;
  function MakeApprovalBodyCancel(AKisNo: AnsiString): AnsiString;                      // ȯ����ǥ�߱� Body  ( ��ҽ� )
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
  Result := Result + RPadB(AInfo.GtRcpTradeNo, 30, ' ');  // tr_no(30) �ŷ�������ȣ
  Result := Result + LPadB('', 54, ' ');                  // resv_header(54)

  //sTmp + sTime (�Ǹ��Ͻ�): �� �κ� �°� ������ ��
  if AInfo.Approval then
    sBody := MakeApprovalBodySave(AInfo.GtSellTime)
  else
    sBody := MakeApprovalBodyCancel(AInfo.GtApprovalNo);

  Result := Result + LPadB(IntToStr(Length(sBody)), 6, '0');  // body_len(6)  body��Ʈ�� ����
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
    AInfo.PassportNm := StringReplace(sCutData, '<', ' ', [rfReplaceAll]); // ���ǿ����̸�
    AInfo.PassportNo := Copy(sLine2, 1, 9);            // ���ǹ�ȣ
    AInfo.PassportNationCd := Copy(sLine2, 11, 3);      // ���Ǳ����ڵ�
  end;
var
  AGubun, SendData, RecvData, ScanData, sErrMsg: AnsiString;
begin
  // ������ �����.
  if (AInfo.IsRefund) and (AInfo.PassportNo = EmptyStr)  then
  begin
    if not ShowQuestionForm2('�����νı⿡ ������ �±��Ͽ� �ֽʽÿ�.', ScanData, sErrMsg) then
    begin
      Result.Result := False;
      if (sErrMsg <> '') then
        Result.ResponseMsg := sErrMsg
      else
        Result.ResponseMsg := '���� �ν��� ����Ͽ����ϴ�.';

      Exit;
    end;
    MakeScanData(ScanData);
  end;

  SendData := MakeSendData(AInfo);
  AGubun := IntToStr(GetSeqNo);
  if DLLExec(AGubun, SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
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
    -1 : Result := '��� ����';
    -2000 : Result := '��� ����';
    -3000 : Result := '���������� ����';
  else
    Result := '�˼� ���� ����';
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
  cCashAmtSum     := AInfo.TotCashAmt;                                        // ���ݸ���
  cCardAmtSum     := AInfo.TotCardAmt;                                        // ī�����
  nLen            := 0;

  if (cCashAmtSum = 0) and (cCardAmtSum <> 0) then
    sPayGubun := 'C' // ī��
  else if (cCardAmtSum = 0) and (cCashAmtSum <> 0) then
    sPayGubun := 'M'// ����
  else
    sPayGubun := 'X'; // ���� + ī�� + ����ȭ��

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
      Result := Result + AInfo.DetailGoodsList[nIndex].DetailGoodsNm + '^'; // prod_cts(200) ��ǰ��
      Result := Result + FormatFloat('000000', AInfo.DetailGoodsList[nIndex].DetailQty) + '^';                // qty(10) ����
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailDanga) + '^';              // uprice(10) �ܰ�
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailSaleAmt) + '^';            // sale_price(10) �ǸŰ���
      Result := Result + FormatFloat('000000000000', AInfo.DetailGoodsList[nIndex].DetailVat) + '^';                // vat(10) �ΰ���ġ��
      Result := Result + '0^';
      Result := Result + '0^';
      Result := Result + '0#';
    end
    else
    begin
      nLen := nLen + 1;
      sDetailGoodsNm := '��Ÿ';
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
  // �����ڵ�
  Result.Code := GetParsingValue('R02', ARecvData);
  // ����޼���
  Result.Msg := Trim(GetParsingValue('R20', ARecvData));
  Result.ResponseMsg := Trim(GetParsingValue('R20', ARecvData));
  // ���ι�ȣ
  Result.GtApprovalNo := GetParsingValue('R12', ARecvData);
  // �����Ϸù�ȣ
  Result.GtSno := GetParsingValue('R11', ARecvData);
  // �ŷ��Ͻ�
  Result.TransDateTime := GetParsingValue('R10', ARecvData);
  // ���ǹ�ȣ
  Result.PassportNo := GetParsingValue('R25', ARecvData);
  // �����ڵ�
  Result.PassportNationCd := Copy(Result.PassportNo, 1, 3);
  Result.PassportNo := Copy(Result.PassportNo, 4, Length(Result.PassportNo));
  // �����̸�
  Result.PassportNm := GetParsingValue('R23', ARecvData);

  // ���αݾ�
  TryStrToCurr(GetParsingValue('R13', ARecvData), Result.AgreeAmt);
  // ȯ�޾�
  TryStrToCurr(GetParsingValue('R14', ARecvData), Result.RefundAmt);
  // ��������
  Result.Result := GetParsingValue('R07', ARecvData) = '0000';
end;

end.
