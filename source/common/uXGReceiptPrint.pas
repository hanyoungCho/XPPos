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
  // ������ Ư�����
  rptReceiptCharNormal    = '{N}';   // �Ϲ� ����
  rptReceiptCharBold      = '{B}';   // ���� ����
  rptReceiptCharInverse   = '{I}';   // ���� ����
  rptReceiptCharUnderline = '{U}';   // ���� ����
  rptReceiptAlignLeft     = '{L}';   // ���� ����
  rptReceiptAlignCenter   = '{C}';   // ��� ����
  rptReceiptAlignRight    = '{R}';   // ������ ����
  rptReceiptSizeNormal    = '{S}';   // ���� ũ��
  rptReceiptSizeWidth     = '{X}';   // ����Ȯ�� ũ��
  rptReceiptSizeHeight    = '{Y}';   // ����Ȯ�� ũ��
  rptReceiptSizeBoth      = '{Z}';   // ���μ���Ȯ�� ũ��
  rptReceiptSize3Times    = '{3}';   // ���μ���3��Ȯ�� ũ��
  rptReceiptSize4Times    = '{4}';   // ���μ���4��Ȯ�� ũ��
  rptReceiptInit          = '{!}';   // ������ �ʱ�ȭ
  rptReceiptCut           = '{/}';   // ����Ŀ��
  rptReceiptImage1        = '{*}';   // �׸� �μ� 1
  rptReceiptImage2        = '{@}';   // �׸� �μ� 2
  rptReceiptCashDrawerOpen= '{O}';   // ������ ����
  rptReceiptSpacingNormal = '{=}';   // �ٰ��� ����
  rptReceiptSpacingNarrow = '{&}';   // �ٰ��� ����
  rptReceiptSpacingWide   = '{\}';   // �ٰ��� ����
  rptLF                   = '{-}';   // �ٹٲ�
  rptBarCodeBegin128      = '{<}';   // ���ڵ� ��� ���� CODE128
  rptBarCodeBegin39       = '{[}';   // ���ڵ� ��� ���� CODE39
  rptBarCodeEnd           = '{>}';   // ���ڵ� ��� ��
  rptQRCodeBegin          = '{^}';   //QR�ڵ� ��� ����
  rptQRCodeEnd            = '{~}';   //QR�ڵ� ��� ��
  // ������ ��¸�� (������ ���� ��¿��� �����)
  rptReceiptCharSaleDate  = '{D}';   // �Ǹ�����
  rptReceiptCharPosNo     = '{P}';   // ������ȣ
  rptReceiptCharPosName   = '{Q}';   // ������
  rptReceiptCharBillNo    = '{A}';   // ����ȣ
  rptReceiptCharDateTime  = '{E}';   // ����Ͻ�

  RECEIPT_TITLE1          = '��ǰ��                      �ܰ� ����       �ݾ�';
  RECEIPT_TITLE2          = '��ǰ��                �ܰ� ����       �ݾ�';
  RECEIPT_LINE1           = '------------------------------------------------';
  RECEIPT_LINE2           = '------------------------------------------';
  RECEIPT_LINE3           = '================================================';
  RECEIPT_LINE4           = '==========================================';

type
  TDeviceType = (dtNone, dtPos, dtKiosk);
  TPayType = (None, Cash, Card, Payco, Welfare, Void);

  TReceiptStoreInfo = class(TJson)
    StoreName: string;              // �����
    BizNo: string;                  // ����ڹ�ȣ
    BossName: string;               // ���ָ�
    Tel: string;                    // ��ȭ��ȣ
    Addr: string;                   // �ּ�
    CashierName: string;            // �Ǹ��ڸ�
  end;

  TOrderInfo = class(TJson)
    UseProductName: string;         // Ÿ������ǥ�� ǥ�õ� ��ǰ��
    TeeBox_Floor: string;           // Ÿ�� ���� ��
    TeeBox_No: string;              // Ÿ�� ���� ��ȣ
    UseTime: string;                // �̿�ð�
    OneUseTime: string;             // �̿�ð�(Ÿ����ǰ)
    Coupon: Boolean;                // ��������
    CouponQty: Integer;             // �ܿ������� - �������� �⺻ 0
    CouponUseDate: string;          // ���� �����
    ExpireDate: string;             // Ÿ����ǰ��������
    Reserve_No: string;             // ���� ��ȣ
    Product_Div: string;            // ��ǰ �ڵ�
    ReserveMoveYN: string;          // Ÿ�� �̵� ����(Y/N)
    ReserveNoShowYN: string;        // ��� Ÿ�� �����ֱ� ����
  end;

  TLockerInfo = class(TJson)
    LockerNo: Integer;              // ��Ŀ��ȣ
    LockerName: string;             // ��Ŀ��
    FloorCode: string;              // ��
    PurchaseMonth: Integer;         // ��� ������
    UseStartDate: string;           // ��������
    UseEndDate: string;             // ���������
  end;

  TReceiptMemberInfo = class(TJson)
    Name: string;                   // ȸ����
    Code: string;                   // ȸ���ڵ�
    Tel: string;                    // ��ȭ��ȣ
    CarNo: string;                  // ������ȣ
    CardNo: string;                 // ȸ��ī���ȣ
    LockerList: string;             // �̿����ζ�Ŀ����
    ExpireLocker: string;           // ��Ŀ������
  end;

  TProductInfo = class(TJson)
    Name: string;                   // ��ǰ��
    Code: string;                   // ��ǰ�ڵ�
    Price: Integer;                 // �Ǹűݾ�(1EA �ܰ�)
    Vat: Integer;                   // �ΰ����ݾ�(1EA �ΰ���)
    Qty: Integer;                   // �� ����
  end;

  TDiscountInfo = class(TJson)
    Name: string;                   // ���θ�
    QRCode: string;                 // QR Code
    Value: string;                  // ���αݾ�
  end;

  TPayInfo = class(TJson)
    &PayCode: TPayType;             // ����Ÿ��
    Approval: Boolean;              // �������� T: ���� F: ���
    Internet: Boolean;              // ���ͳ� ���� ����
    ApprovalAmt: Integer;           // ���αݾ�
    ApprovalNo: string;             // ���ι�ȣ
    OrgApproveNo: string;           // �� ���ι�ȣ
    CardNo: string;                 // ī���ȣ
    CashReceiptPerson: Integer;     // �ҵ���� 1: ����, 2: �����
    HalbuMonth: string;             // �Һΰ���

    CompanyName: string;            // PAYCO ���α��
    MerchantKey: string;            // ���͹�ȣ
    TransDateTime: string;          // �����Ͻ�
    BuyCompanyName: string;         // ���Ի�
    BuyTypeName: string;            // ����ó
  end;

  TReceiptEtc = class(TJson)
    RcpNo: Integer;
    SaleDate: string;               // �Ǹ�����
    SaleTime: string;               // �Ǹ��Ͻ�
    ReturnDate: string;             // ��ǰ���� (��ǰ�� ���Ǹ�����)
    RePrint: Boolean;               // ����� ����
    TotalAmt: Integer;              // ��ǰ�ǸŽ� �� �Ǹűݾ�
    DCAmt: Integer;                 // ���αݾ�
    KeepAmt: Integer;               // ��Ŀ������
    ReceiptNo: string;              // ��������ȣ(���ڵ�)
    Top1: string;                   // ��ܹ���1
    Top2: string;                   // ��ܹ���2
    Top3: string;                   // ��ܹ���3
    Top4: string;                   // ��ܹ���4
    Bottom1: string;                // �ϴܹ���1
    Bottom2: string;                // �ϴܹ���2
    Bottom3: string;                // �ϴܹ���3
    Bottom4: string;                // �ϴܹ���4
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

  { ������ ���̿����� ���� }
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
    function MakeNewPayCoData(APayInfo: TPayInfo): string;  // NewPayCo����

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
//  Result := Result + #27#64; //�ʱ�ȭ
  Result := Result + #29#40#107#3#0#49#65#50#0; //QR�ڵ� ����
  Result := Result + #29#40#107#3#0#49#67#8; //������
  Result := Result + #29#40#107 + Chr(length(AQRCode) + 3) + #0 + #49#80#48 + AQRCode; //QR������
  Result := Result + #29#40#107#3#0#49#81#48; //���ڵ�
//  Result := Result + #27#105;
end;

function TReceiptPrint.ConvertBarCodeCMD(AData: string): string;
const
  BAR_HEIGHT = #$50; // ���ڵ����
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

    // CODE39 �̸�
    if ChkBarCode39 then
    begin
      ALen := Char(Length(BarCodeOrg));
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE39 + ALen + BarCodeOrg;
    end
    else
    // CODE128 �̸�
    begin
      ALen := Char(Length(BarCodeOrg) + 2); // 2 �� ���ؾ� ��
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
  STR_POINT = '����������Ʈ';
  STR_COUPON = '����������';
  STR_CARD = '�ſ�ī��';
  STR1 = '***��������(����)***';
  STR2 = '���α��     :';
  STR3 = '�ſ�ī���ȣ :';
  STR4 = '�Һΰ���     :';
  STR5 = '���ι�ȣ     :';
  STR6 = '�����Ͻ�     :';
  STR7 = '���͹�ȣ     :';
  STR8 = '���Ի�       :';
  STR9 = '����ó       :';
  STR10 = '***OK ĳ���� ����Ʈ ����***';
  STR11 = '��������Ʈ          :';
  STR12 = '��밡�� ��������Ʈ :';
  STR13 = '���� ��������Ʈ     :';
  STR14 = '�Ͻú�';
  STR15 = ' ����';
  STR16 = 'Ƽ�Ӵ�ī���ȣ :';
  STR17 = '�������ܾ�   :';
  STR18 = '�����ݾ�     :';
  STR19 = '�������ܾ�   :';
  STR20 = '- PAYCO �������� -';
  STR21 = '- PAYCO ������� -';
  STR22 = '***�����������(����)***';
  STR23 = '�����̸�     :';
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
    Result := Result + '���� ��Ͽ� �����Ͽ����ϴ�.' + rptLF;
    Result := Result + '�����ڿ��� ���� �ٶ��ϴ�.' + rptLF;
  end;

  Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  if FReceipt.ReceiptEtc.RePrint then
  begin
    Result := Result + rptReceiptAlignCenter + '������� �� ������ �Դϴ١�' + rptLF;
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
    sApprovalType := '����'
  else
    sApprovalType := '���';

  sPayMethod := '�ŷ�';
  if (APayMethod = CPM_CASH) then
    sPayMethod := '���ݰ���'
  else if (APayMethod = CPM_CARD) then
    sPayMethod := '�ſ�ī��'
  else if (APayMethod = CPM_PAYCO_CARD) then
    sPayMethod := 'PAYCO';

  Result := Result + Format('%s %s ��ǥ', [sPayMethod, sApprovalType]) + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + '�� �� ��: ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '��ǥ�ڸ�: ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '��ȭ��ȣ: ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '�����ּ�: ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '����ڹ�ȣ: ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '�Ǹ��ڸ�: ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '��½ð�: ' + Global.FormattedCurrentDateTime + rptLF;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptReceiptAlignCenter + '[ �� �� �� ]' + rptLF;
  Result := Result + rptReceiptAlignLeft + RECEIPT_LINE2 + rptLF;
  Result := Result + '[�� �� �� ��] ' + FormatFloat('#,##0.##', APayInfo.ApprovalAmt) + rptLF;
  Result := Result + '[�� �� �� ��] ' + FormatFloat('#,##0', APayInfo.ApprovalAmt / 11) + rptLF;
  Result := Result + '[�� �� �� ȣ] ' + APayInfo.ApprovalNo + rptLF;

  if (APayMethod = CPM_CARD) or
     (APayMethod = CPM_PAYCO_CARD) then
  begin
    Result := Result + rptReceiptAlignLeft + '[ī �� �� ȣ] ' + APayInfo.CardNo + rptLF;
    if StrToIntDef(APayInfo.HalbuMonth, 0) = 0 then
      Result := Result + '[�� �� �� ��] ' + '�Ͻú�' + rptLF
    else
      Result := Result + '[�� �� �� ��] ' + APayInfo.HalbuMonth + rptLF;
    Result := Result + '[ī �� �� ��] ' + APayInfo.BuyCompanyName + rptLF;
    Result := Result + '[�� �� �� ��] ' + APayInfo.BuyCompanyName + rptLF;
    Result := Result + '[�� �� �� ȣ] ' + APayInfo.MerchantKey + rptLF;
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
  Result := Result + '�ֹ��ֹ���' + rptLF + rptLF;
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
  Result := Result + '�� �� �� ��: ' + AMemberInfo + rptLF;
  Result := Result + '������ ��ȣ: ' + AReceiptNo + rptLF;
  Result := Result + '�� �� �� ��: ' + Global.FormattedCurrentDateTime + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.LessonReceiptPrint(const ALessonReceiptInfo: TLessonReceiptInfo; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    try
      if not Print(LessonReceiptForm(ALessonReceiptInfo)) then
        raise Exception.Create('���������� ��� ����');
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
  Result := Result + '����������(����)' + rptLF + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '[��    ��] ' + ALessonReceiptInfo.BuyerName + rptLF;
  Result := Result + '[ȸ����ȣ] ' + ALessonReceiptInfo.MemberNo + rptLF;
  Result := Result + '[�����ڸ�] ' + ALessonReceiptInfo.CoachName + rptLF;
  Result := Result + '[��������] ' + ALessonReceiptInfo.LessonName + rptLF;
  Result := Result + '[��ǰ����] ' + ALessonReceiptInfo.ProdName + rptLF;
  Result := Result + '[�������] ' + ALessonReceiptInfo.StoreName + rptLF;
  Result := Result + '[�����ݾ�] ' + FormatFloat('#,##0.##', ALessonReceiptInfo.LessonFee) + '(��)' + rptLF + rptLF;
  Result := Result + '�ŷ��Ͻ�: ' + ALessonReceiptInfo.LessonDateTime + rptLF;
  Result := Result + '����Ͻ�: ' + Global.FormattedCurrentDateTime + rptLF + rptLF;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + '�� �������� �ŷ� �����ڷ��' + rptLF;
  Result := Result + '����� �� �����ϴ�.' + rptLF + rptLF;
  Result := Result + rptReceiptSizeHeight + ALessonReceiptInfo.IssuerName + rptReceiptSizeNormal + rptReceiptAlignLeft + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.FacilityTicketPrint(const APrintWithAssignTicket: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    if not Print(FacilityTicketForm(APrintWithAssignTicket)) then
      raise Exception.Create('�ü��̿�� ��� ����');
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
      Result := Result + '�̿����: ' + SaleManager.ReceiptInfo.FacilityList[I].AccessControlName + rptLF;
      Result := Result + '�̿�����: ' + sCurrDate + rptLF;
      Result := Result + '�����Ͻ�: ' + sCurrTime + rptLF + rptLF;
      //����ǥ ���
      if (sProdDiv = CTP_DAILY) then
        Result := Result + '��ǰ����: ��������' + rptLF
      else if (sProdDiv = CTP_COUPON) or
              (sProdDiv = CTP_TERM) then
      begin
        Result := Result + '�̿����: ' + SaleManager.ReceiptInfo.FacilityList[I].UseStartDate + rptLF;
        Result := Result + '�̿�����: ' + SaleManager.ReceiptInfo.FacilityList[I].UseEndDate + rptLF;
        if (sProdDiv = CTP_COUPON) then
        begin
          nRemain := SaleManager.ReceiptInfo.FacilityList[I].RemainCount;
          Result := Result + '��ǰ����: ������' + rptLF;
          Result := Result + '�ܿ�ȸ��: ' + IntToStr(nRemain) + rptLF;
        end
        else
          Result := Result + '��ǰ����: �Ⱓ��' + rptLF + rptLF;
      end;
      Result := Result + rptLF;
      Result := Result + rptReceiptAlignCenter + '�̿��� �ּż� �����մϴ�.' + rptLF;
      Result := Result + FReceipt.StoreInfo.StoreName + rptLF;
      Result := Result + rptReceiptAlignLeft + rptLF + rptLF + rptReceiptCut;
    end;

    if not SaleManager.ReceiptInfo.FacilityList[I].AccessBarcode.IsEmpty then
    begin
      //���Կ� ���ڵ�
      Result := Result + rptLF;
      Result := Result + rptReceiptSizeWidth + rptReceiptCharBold + rptReceiptAlignCenter + '�δ�ü� �̿��' + rptReceiptCharNormal + rptReceiptSizeNormal + rptLF;
      Result := Result + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
      Result := Result + '�̿����: ' + SaleManager.ReceiptInfo.FacilityList[I].AccessControlName + rptLF;
      Result := Result + '�����Ͻ�: ' + sCurrTime + rptLF + rptLF;
      Result := Result + rptBarCodeBegin128 + SaleManager.ReceiptInfo.FacilityList[I].AccessBarcode + rptBarCodeEnd + rptLF;
      Result := Result + rptReceiptAlignCenter + '�̿��� �ּż� �����մϴ�.' + rptLF;
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
    Result := Result + rptReceiptSizeWidth + rptReceiptCharBold + rptReceiptAlignCenter + '�δ�ü� �̿��' + rptReceiptCharNormal + rptReceiptSizeNormal + rptLF;
    Result := Result + rptReceiptAlignLeft + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
    Result := Result + '�̿����: ' + AFacilityItem.AccessControlName + rptLF;
    Result := Result + '�����Ͻ�: ' + Global.FormattedCurrentDateTime + rptLF + rptLF;
    Result := Result + rptBarCodeBegin128 + AFacilityItem.AccessBarcode + rptBarCodeEnd + rptLF;
    Result := Result + rptReceiptAlignCenter + '�̿��� �ּż� �����մϴ�.' + rptLF;
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
    sHours := System.StrUtils.IfThen(Global.AddOnTicket.PrintAlldayPass, '(����)', '')
  else
    sHours := '(' + IntToStr(AServiceHours) + '�ð�)';

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
  Result := Result + FormatDateTime('yyyy��mm��dd�� hh��nn��', Now) + rptLF + rptLF + rptLF + rptLF + rptLF + rptLF;
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
  Result := Result + '�� �� ��' + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '�� �� �� : ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '��ǥ�ڸ� : ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '��ȭ��ȣ : ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '�����ּ� : ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '����ڹ�ȣ : ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '�Ǹ��ڸ� : ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '�ŷ��Ͻ� : ' + FReceipt.ReceiptEtc.SaleDate + ' ' + FReceipt.ReceiptEtc.SaleTime + rptLF;
  Result := Result + '����Ͻ� : ' + Copy(Global.FormattedCurrentDateTime, 1, 16) {yyyy-mm-dd hh:nn} + rptLF;

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
          Result := Result + LPadB('���ݿ�����(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('���ݿ�����(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (-1 * APayInfo.ApprovalAmt)), Int_15, ' ') + rptLF;
      end
      else
      begin
        CashStr := System.StrUtils.IfThen(APayInfo.Approval, '����', '���');
        Result := Result + LPadB('����(' + CashStr + ')', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', System.Math.IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if APayInfo.PayCode = Card then
    begin
      if APayInfo.Internet then
      begin
        if APayInfo.Approval then
          Result := Result + LPadB('�ſ�ī��(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('�ſ�ī��(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', -1 * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end
      else
      begin
        Result := Result + LPadB('ī��(������)', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', System.Math.IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if APayInfo.PayCode = Payco then
    begin
      if APayInfo.Approval then
        Result := Result + LPadB('PAYCO(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('PAYCO(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
    end;

    if APayInfo.PayCode = Welfare then
    begin
      if APayInfo.Approval then
        Result := Result + LPadB('����Ʈ(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('����Ʈ(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
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
          CashMsg := System.StrUtils.IfThen(APayInfo.CashReceiptPerson = 1, '(�ҵ����)', '(��������)');
          Result := Result + rptReceiptAlignCenter + '';
          Result := Result + System.StrUtils.IfThen(APayInfo.Approval, '<���ݿ�����' + CashMsg + ' ���γ���>', '<���ݿ�����' + CashMsg + ' ��ҳ���>') + rptLF;
          Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
          Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
          Result := Result + RPadB('���αݾ�', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;
          Result := Result + RPadB('���ι�ȣ', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF;
          Result := Result + RPadB('ī���ȣ', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF;
        end;
      end;

      if (APayInfo.PayCode = Card) then
      begin
        Result := Result + rptReceiptAlignCenter;
        Result := Result + System.StrUtils.IfThen(APayInfo.Approval, '<�ſ�ī�� ���γ���>', '<�ſ�ī�� ��ҳ���>') + rptLF;
        Result := Result + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
        Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
        Result := Result + RPadB('���αݾ�', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF;

        if APayInfo.HalbuMonth > '1' then
          Result := Result + RPadB('�Һΰ���', Int_33, ' ') + LPadB(APayInfo.HalbuMonth  + '����', Int_15, ' ') + rptLF
        else
          Result := Result + RPadB('�Һΰ���', Int_33, ' ') + LPadB('�Ͻú�', Int_15, ' ') + rptLF;
        Result := Result + RPadB('�� �� ��', Int_33, ' ') + LPadB(APayInfo.BuyCompanyName, Int_15, ' ') + rptLF;
        Result := Result + RPadB('���ι�ȣ', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF;
        Result := Result + RPadB('ī���ȣ', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF;
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
    Result := Result + rptReceiptAlignCenter + '<���γ���>' + rptLF;
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
  Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '�Ǹűݾ�%40s', '�Ǹűݾ�%13s'), [FormatFloat('#,##0.##', FReceipt.ReceiptEtc.TotalAmt)]) + rptLF;
  Result := Result + rptReceiptSizeNormal;
  if (FReceipt.ReceiptEtc.DCAmt <> 0) then
    Result := Result + LPadB('���αݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.ReceiptEtc.DCAmt), Int_11, ' ') + rptLF;
  Result := Result + LPadB('������ǰ�ݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', ((FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt) - AVat)), Int_11, ' ') + rptLF;
  Result := Result + LPadB('�ΰ���(VAT)�ݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', AVat), Int_11, ' ') + rptLF;
  Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  if (FReceipt.ReceiptEtc.KeepAmt <> 0) then
  begin
    Result := Result + LPadB('��Ŀ������', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.ReceiptEtc.KeepAmt), Int_11, ' ') + rptLF;
    for Index := 0 to Pred(Length(FReceipt.LockerItems)) do
      if (FReceipt.LockerItems[Index].LockerNo > 0) then
        Result := Result + LPadB(Format('%sF %s (%d����) %s~%s', [
            FReceipt.LockerItems[Index].FloorCode, FReceipt.LockerItems[Index].LockerName,
            FReceipt.LockerItems[Index].PurchaseMonth, FReceipt.LockerItems[Index].UseStartDate, FReceipt.LockerItems[Index].UseEndDate
        ]), Int_48, ' ') + rptLF;
    Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  end;

  Result := Result + rptReceiptSizeWidth;
  if FIsReturn then
    Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '��ұݾ�%40s', '��ұݾ�%13s'), [FormatFloat('#,##0.##', -1 * (FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt))]) + rptLF
  else
    Result := Result + Format(System.StrUtils.IfThen(FDeviceType = dtKiosk, '�����ݾ�%40s', '�����ݾ�%13s'), [FormatFloat('#,##0.##', (FReceipt.ReceiptEtc.TotalAmt - FReceipt.ReceiptEtc.DCAmt))]) + rptLF;

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
        PrintData := PrintData + ' Ÿ������ǥ(�̵�) ' + rptLF
      else
        PrintData := PrintData + ' Ÿ������ǥ ' + rptLF;

      PrintData := PrintData + rptReceiptCharNormal + rptReceiptAlignLeft + rptReceiptSizeNormal;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + 'Ÿ����ȣ : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s %s��', [OrderItems[I].TeeBox_Floor, OrderItems[I].TeeBox_No]) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + '�̿�ð� : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s', [OrderItems[I].UseTime]) + rptLF;
      PrintData := PrintData + rptReceiptSizeHeight;
      PrintData := PrintData + '�����ð� : ';
      PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth;
      PrintData := PrintData + Format('%s��', [OrderItems[I].OneUseTime]) + rptReceiptSizeNormal + rptLF;

      if not ReceiptMemberInfo.Name.IsEmpty then
      begin
        PrintData := PrintData + rptReceiptSizeHeight;
        PrintData := PrintData + 'ȸ �� �� : ';
        PrintData := PrintData + rptReceiptSizeNormal + rptReceiptSizeBoth + ReceiptMemberInfo.Name + rptReceiptSizeNormal + rptLF + rptLF;
        PrintData := PrintData + 'ȸ����ȣ : ' + ReceiptMemberInfo.Code + rptLF;
      end
      else
        PrintData := PrintData + rptLF;

      PrintData := PrintData + '�̿����� : ' + Global.FormattedCurrentDate + rptLF;
      PrintData := PrintData + '���񽺸� : ' + OrderItems[I].UseProductName + rptLF;

      if not OrderItems[I].ExpireDate.IsEmpty then
        PrintData := PrintData + '�������� : ' + OrderItems[I].ExpireDate + rptLF;
      if not OrderItems[I].Reserve_No.IsEmpty then
        PrintData := PrintData + '�����ȣ : ' + OrderItems[I].Reserve_No + rptLF
      else
        PrintData := PrintData + '�����ȣ : �����ڿ��� ���� �ٶ��ϴ�.' + rptLF;

      if OrderItems[I].Coupon then
        PrintData := PrintData + '�ܿ����� : ' + Format('%d ��', [OrderItems[I].CouponQty]) + rptLF;

      if not ReceiptMemberInfo.LockerList.IsEmpty then
      begin
        PrintData := PrintData + '��Ŀ�̿� : ' + ReceiptMemberInfo.LockerList + rptLF;
        PrintData := PrintData + '��Ŀ���� : ' + ReceiptMemberInfo.ExpireLocker + rptLF;
      end;

      PrintData := PrintData + '��½ð� : ' + FormatDateTime('yyyy-mm-dd hh:nn', Now) + rptLF;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
      PrintData := PrintData + rptReceiptAlignCenter;
      PrintData := PrintData + '��� ��û�� ����Ʈ�� ������ �ֽʽÿ�.' + rptLF;
      PrintData := PrintData + '�̿��� �ּż� �����մϴ�.' + rptLF;
      PrintData := PrintData + rptReceiptAlignCenter + FReceipt.StoreInfo.StoreName + rptReceiptAlignLeft + rptLF;
      PrintData := PrintData + System.StrUtils.IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;

      if (OrderItems[I].ReserveNoShowYN = CRC_YES) then
        PrintData := PrintData + '�س�� ������ ������ ����ǥ �Դϴ�.' + rptLF;

      if AIsRePrint then
        PrintData := PrintData + '������� �� ����ǥ �Դϴ�.' + rptLF;

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
        sMemberInfo := Format('ȸ����: %s (%s)', [ReceiptMemberInfo.Name, ReceiptMemberInfo.Code]);
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
            PrintData := PrintData + AddonTicketForm(CAT_PARKING_TICKET, '�� �� ��', sMemberInfo, Global.ParkingServer.BaseHours, sUseTime, False);
          end;
        end;

        if Global.AddOnTicket.SaunaTicket then
        begin
          PrintData := PrintData + rptLF + rptLF + rptReceiptCut;
          PrintData := PrintData + AddonTicketForm(CAT_SAUNA_TICKET, System.StrUtils.IfThen(Global.AddOnTicket.SaunaTicketKind = 0, '��쳪', '������') + '�̿��',
            sMemberInfo, 0, Global.CurrentTime, False);
        end;

        if Global.AddOnTicket.FitnessTicket then
        begin
          PrintData := PrintData + rptLF + rptLF + rptReceiptCut;
          PrintData := PrintData + AddonTicketForm(CAT_FITNESS_TICKET, '��Ʈ�Ͻ��̿��', sMemberInfo, 0, Global.CurrentTime, False);
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
      if (sCmd = rptReceiptCharNormal) then           //�Ϲ� ����
        ARichEdit.SelAttributes.Style := []
      else if (sCmd = rptReceiptCharBold) then        //���� ����
        ARichEdit.SelAttributes.Style := [fsBold]
      else if (sCmd = rptReceiptCharInverse) then     //���� ����
        ARichEdit.SelAttributes.Color := clRed
      else if (sCmd = rptReceiptCharUnderline) then   //���� ����
        ARichEdit.SelAttributes.Style := [fsUnderline]
      else if (sCmd = rptReceiptAlignLeft) then       //���� ����
        ARichEdit.Paragraph.Alignment := taLeftJustify
      else if (sCmd = rptReceiptAlignCenter) then     //��� ����
        ARichEdit.Paragraph.Alignment := taCenter
      else if (sCmd = rptReceiptAlignRight) then      //������ ����
        ARichEdit.Paragraph.Alignment := taRightJustify
      else if (sCmd = rptReceiptSizeNormal) then      //���� ũ��
        ARichEdit.SelAttributes.Size := 10
      else if (sCmd = rptReceiptSizeWidth) then       //����Ȯ�� ũ��
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSizeHeight) then      //����Ȯ�� ũ��
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSizeBoth) then        //���μ���Ȯ�� ũ��
        ARichEdit.SelAttributes.Size := 20
      else if (sCmd = rptReceiptSize3Times) then      //���μ���3��Ȯ�� ũ��
        ARichEdit.SelAttributes.Size := 30
      else if (sCmd = rptReceiptSize4Times) then      //���μ���4��Ȯ�� ũ��
        ARichEdit.SelAttributes.Size := 40
      else if (sCmd = rptLF) then                     //�ٹٲ�
        ARichEdit.SelText := #13
      else if (sCmd = rptReceiptInit) then            //������ �ʱ�ȭ
      else if (sCmd = rptReceiptCut) then             //����Ŀ��
      else if (sCmd = rptReceiptImage1) then          //�׸� �μ� 1
      else if (sCmd = rptReceiptImage2) then          //�׸� �μ� 2
      else if (sCmd = rptReceiptCashDrawerOpen) then  //������ ����
      else if (sCmd = rptReceiptSpacingNormal) then   //�� ���� �⺻
      else if (sCmd = rptReceiptSpacingNarrow) then   //�� ���� ����
      else if (sCmd = rptReceiptSpacingWide) then     //�� ���� ����
      else if (sCmd = rptBarCodeBegin128) then        //���ڵ� ��� ����
      begin
        ARichEdit.SelAttributes.Height := 20;
        ARichEdit.SelText := '<';
      end
      else if (sCmd = rptBarCodeBegin39) then         //���ڵ� ��� ����
      begin
        ARichEdit.SelAttributes.Height := 20;
        ARichEdit.SelText := '<';
      end
      else if (sCmd = rptBarCodeEnd) then             //���ڵ� ��� ��
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

  nIndex := Pos(#27#97#1#29#118#48, sReceiptData);    //���� �̹����� ������ ����
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
