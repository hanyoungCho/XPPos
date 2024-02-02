unit uPaycoNewModule;

interface

uses
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, System.StrUtils, System.IniFiles,
  Vcl.Forms, Vcl.Controls, Vcl.Dialogs, System.Math, uVanFunctions, uVanDaemonModule;

const
  CASH_50000 = 50000;

type
  TVanConfig = record
    TerminalID: string;
    BizNo: string;
    SerialNo: string;
    VanName: string;
    SignPad: Boolean;
  end;

  // Payco ȯ�漳��
  TPaycoNewConfig = record
    RealMode: Boolean;                 // �Ǹ��/�׽�Ʈ���
    BizNo: AnsiString;                 // ����ڹ�ȣ
    VanPosID: AnsiString;              // Van Pos ID
    VanSerialID: AnsiString;           // Van Serial ID
    VanCode: AnsiString;               // Van Code
 //   UseMode   : Integer;               // 0: ���� / 1: PG ��� ����
  end;

  // Payco ��������
  TPaycoNewSendInfo = record
    Approval: Boolean;                 // ����/��� ����
    PayAmt: Currency;                  // ���αݾ�
    DutyAmt: Currency;                 // ���αݾ� ( ���ް� )
    TaxAmt: Currency;                  // ���αݾ� ( �ΰ��� )
    FreeAmt: Currency;                 // ���αݾ� ( �鼼�ݾ� )
    TipAmt: Currency;                  // ���αݾ� ( ����� )
    ApprovalAmount: Currency;          // ����Ʈ �� ���� �ݾ��� ���� �� ���� �ݾ�
    PointAmt: Currency;                // ����Ʈ�ݾ�
    CouponAmt: Currency;               // �����ݾ�
    PaymentMethodCode: AnsiString;     // �������� �ڵ带 ����  Example : PAYCO, PAYON : 00 Ƽ�Ӵ� : 01
    TradeNo: AnsiString;               // �ŷ���ȣ
    HalbuMonth: AnsiString;            // �Һΰ���
    OrgAgreeNo: AnsiString;            // �����ι�ȣ(��ҽ�)
    OrgAgreeDate: AnsiString;          // ����������(��ҽ�)
    ApprovalCompanyCode: AnsiString;   // ���λ��ڵ�
    ApprovalCompanyName: AnsiString;   // ���λ��
    ServiceType: AnsiString;           // ����Ÿ��
    FieldCount: Currency;              // ��ǰ �Ӽ� ����

    TerminalID: string;
    BizNo: string;
    SerialNo: string;
    VanName: string;
    SignPad: Boolean;
  end;

  // Payco ��������
  TPaycoNewRecvInfo = record
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    TradeNo: AnsiString;               // �ŷ���ȣ
    TransDateTime: AnsiString;         // �ŷ��Ͻ�(yyyymmddhhnnss)
    PaymentMethodCode: AnsiString;     // �������� �ڵ带 ����  Example : PAYCO, PAYON : 00 Ƽ�Ӵ� : 01
    PaymentMethodName: AnsiString;     // �������ܸ�
    AgreeAmt: Currency;                // ���αݾ�
    ApprovalAmount: Currency;          // ����Ʈ �� ���� �ݾ��� ���� �� ���� �ݾ�
    PointAmt: Currency;                // ����Ʈ�ݾ�
    CouponAmt: Currency;               // �����ݾ�
    ServiceType: AnsiString;           // ���� Ÿ�� �� (��PAYCO�� / ��PAYON�� / ��TMONEY��)
    HalbuMonth: AnsiString;            // �Һΰ���
    ApprovalCompanyName: AnsiString;   // ���λ��
    ApprovalCompanyCode: AnsiString;   // ���λ��ڵ�
    MerchantKey: AnsiString;           // ������Ű
    MerchantName: AnsiString;          // ��������
    CouponName: AnsiString;            // ������
    PointName: AnsiString;             // ����Ʈ��
    PayonCardOtc: AnsiString;          // PAYON ���� VAN ��� �϶� OTC ��
    RevCardNo: AnsiString;             // ī���ȣ
    BuyCompanyName: AnsiString;        // VAN ���ν� ���Ի��
    BuyCompanyCode: AnsiString;        // VAN ���ν� ���Ի��
    BuyTypeName: AnsiString;          // KCP VAN ���ν� ���Թ����
    OneCardType: AnsiString;           // ��ī��Ÿ��
    OneCardTypeName: AnsiString;       // ��ī��Ÿ�Ը�
    AcmPoint: Currency;                // ��������Ʈ
    AcmUsablePoint: Currency;          // ��밡�� ��������Ʈ
    AcmCumulationPoint: Currency;      // ���� ��������Ʈ
    TradeBeforeAmount: Currency;       // �������ܾ�
    TradeAfterAmount: Currency;        // �������ܾ�
  end;

  TPaycoNewModule = class
  private
//    Log: TLog;
    DLLHandle: THandle;
    Config: TPaycoNewConfig;
    TotPayAmt: Currency;
    function ReadINIFirstKey: Boolean;
    procedure WriteINIFirstKey;
    procedure PaycoRevOpen();
    procedure PaycoRevClose();
    function  PaycoRevCheck: Boolean;
    function MakeSendDataPayco(AInfo: TPaycoNewSendInfo) : AnsiString;
    function MakeRecvDataPayco(Amt: Currency; Approval: Boolean): TPaycoNewRecvInfo;
  public
    VanModul: TVanConfig;
    GoodsName: AnsiString;             // ��ǰ��
    GoodsList: AnsiString;             // ��ǰ����Ʈ
    ICHWSerial: AnsiString;            // IC������ �ϵ���� �ø���
    TestMode: Boolean;                 // TEST / REAL ����
    UseMode: Integer;                  // 0: ���� / 1: PG ��� ����
    constructor Create; virtual;
    destructor Destroy; override;
    // ����۾�
    function SetCofig(const Value: TPaycoNewConfig) : Boolean;
    // �����۾� ( ���� 1ȸ )
    function SetOpen: Boolean;
    // �����۾�
    function SetClose : Boolean;
    // ������۾�
    function SetCancel : Boolean;
    // Payco ����ó��
    function ExecPayProc(AInfo: TPaycoNewSendInfo): TPaycoNewRecvInfo;
    // Barcode���� �Է�
    procedure SetBarcode(ABarcode: AnsiString);
    // VanCode
    function GetVanCode(ACode: string): string;
  end;

var
  PaycoNewMan: TPaycoNewModule;

implementation

uses
  uPaycoRevForm;

type
//1.�ʱ�ȭ
TPAYCO_NfcInit = procedure; stdCall;
//2.�ڵ带 ����
TPAYCO_SetPaycoData = procedure(Gubun, Code: AnsiString); stdCall;
//3.����
TPAYCO_NfcASyncRun = procedure(hwnd: THandle); stdCall;
//4.�����۾� ( ���� 1ȸ )
TPAYCO_NfcDailyRun = procedure; stdCall;
//5.����
TPAYCO_NfcSendASyncEnd = procedure; stdCall;
//6.������� �޽��ϴ�.
TPAYCO_GetPaycoData = function(Code: AnsiString): PAnsiChar; stdCall;
//7.������� �޽��ϴ�.
TPAYCO_GetPaycoListCount = function(Code: AnsiString): PAnsiChar; stdCall;
//8.������� �޽��ϴ�.
TPAYCO_GetPaycoListData = function(Code: AnsiString): PAnsiChar; stdCall;
//9.����� �۾��� �����մϴ�.
TPAYCO_NfcSendNetworkCancel = procedure; stdCall;
//10.�����е� �����̹������� ó���մϴ�.
TPAYCO_NfcSendSignData = function(Code , aLen , aData , aPath , aEtc  : AnsiString): PAnsiChar; stdCall;
// 11. ���ڵ� ������ �����մϴ�.
TPAYCO_NfcSendBarcode = procedure(ABarcode: AnsiString); stdcall;
const
  filPAYCO_DLL = 'PaycoNfc.dll';
  _INI_PAYCO = 'SolbiPayco.ini';

{ TPaycoModul }

constructor TPaycoNewModule.Create;
begin
  DLLHandle := LoadLibrary(filPAYCO_DLL);
//  Log := TLog.Create;
  GoodsName := EmptyStr;             // ��ǰ��
  GoodsList := EmptyStr;             // ��ǰ����Ʈ
  ICHWSerial := EmptyStr;            // IC������ �ϵ���� �ø���
  TestMode := False;                 // TEST / REAL ����
  UseMode := 0;                      // 0: ���� / 1: PG ��� ����
end;

destructor TPaycoNewModule.Destroy;
begin
  FreeLibrary(DLLHandle);
//  Log.Free;
  inherited;
end;

function TPaycoNewModule.ExecPayProc(AInfo: TPaycoNewSendInfo): TPaycoNewRecvInfo;
begin
  try
//    Log.Write(ltInfo, ['TPaycoNewModule', 'ExecPayProc']);
    TotPayAmt := 0;
    //001.���� �۾��� �����մϴ�. ( ������ 1ȸ )
    //if ReadINIFirstKey = False then
    // SetOpen;
    //002.���ſ� ���� ����
    PaycoRevOpen;
    TotPayAmt := AInfo.PayAmt;
    //003.�����۾��� �����մϴ�.
    MakeSendDataPayco(AInfo);
    //004.�����۾��� �����մϴ�.
    if PaycoRevCheck then
      Result := MakeRecvDataPayco(AInfo.PayAmt, AInfo.Approval);
  finally
    //005.�����۾��� �����մϴ�.
    PaycoRevClose;
  end;
end;

function TPaycoNewModule.GetVanCode(ACode: string): string;
begin
  if ACode = VAN_CODE_KFTC then
    Result := '����������'
  else if ACode = VAN_CODE_KICC then
    Result := 'KICC'
  else if ACode = VAN_CODE_KIS then
    Result := 'KIS'
  else if ACode = VAN_CODE_FDIK then
    Result := 'FDIK'
  else if ACode = VAN_CODE_KOCES then
    Result := 'KOCES'
  else if ACode = VAN_CODE_KSNET then
    Result := 'KSNET'
  else if ACode = VAN_CODE_JTNET then
    Result := 'JTNET'
  else if ACode = VAN_CODE_NICE then
    Result := 'NICE'
  else if ACode = VAN_CODE_SMARTRO then
    Result := 'Smartro'
  else if ACode = VAN_CODE_KCP then
    Result := 'KCP'
  else if ACode = VAN_CODE_DAOU then
    Result := '�ٿ쵥��Ÿ'
  else if ACode = VAN_CODE_KOVAN then
    Result := 'KOVAN'
  else if ACode = VAN_CODE_SPC then
    Result := 'SPC��Ʈ����';
end;

function TPaycoNewModule.MakeSendDataPayco(AInfo: TPaycoNewSendInfo): AnsiString;
var
  SetPaycoData: TPAYCO_SetPaycoData;
  NfcASyncRun : TPAYCO_NfcASyncRun;
begin
  inherited;
//  Log.Write(ltInfo, ['TPaycoNewModule', 'MakeSendDataPayco']);
  Result := EmptyStr;
  try
//    Log.Write(ltInfo, ['MakeSendDataPayco ' , '���󱸺� :'+ IfThen(TestMode, '�׽�Ʈ', '����') + ' ���α���  : ' + IfThen(AInfo.Approval, '����', '���')  ] );

    @SetPaycoData := GetProcAddress(DLLHandle, 'SetPaycoData');
    @NfcASyncRun  := GetProcAddress(DLLHandle, 'NfcASyncRun');

    if not Assigned(@SetPaycoData) and not Assigned(@NfcASyncRun) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['MakeSendDataPayco :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // �ʱ⼼���� ��������
    if TestMode = False then
     begin
      // ����ڹ�ȣ ����
      Config.BizNo := StringReplace(AInfo.BizNo, '-', '', [rfReplaceAll]);
      // VAN POSID ����
      Config.VanPosID := AInfo.TerminalID;
      // VAN VanSerialID ����
      Config.VanSerialID := AInfo.SerialNo;
     end;
    // VAN �ڵ� ����
    if AInfo.VanName = 'JT-NET' then
      Config.VanCode := 'JTNET'
    else if AInfo.VanName = 'Smartro' then
      Config.VanCode := 'SMTR'
    else if AInfo.VanName = 'StarVAN' then
      Config.VanCode := 'DAU'
    else if AInfo.VanName = 'SPC Networks' then
      Config.VanCode := 'SPC'
    else
      Config.VanCode := AInfo.VanName;

   // Config.UseMode := 0;       // PG ���� VAN ���� ���� �ɼ� ���� JKH 20170117

    // ���� ȯ�漳�� �۾� ����
    SetCofig(Config);

    // �������� ������� �ݵ�� ���� ���� : ��APPROVAL�� / ��� : ��CANCEL��
    if AInfo.Approval then     // ������ ���
    begin
      //������� ����
      SetPaycoData('TradeMethod', 'APPROVAL');
    end
    else
    begin
      //������� ����
      SetPaycoData('TradeMethod', 'CANCEL');
      //�����Ͻ�
    //  if VanModul.VanName = 'FDIK' then
    //    SetPaycoData('ApprovalDatetime', Copy(AInfo.OrgAgreeDate,3,Length(AInfo.OrgAgreeDate)-2))
    //  else
        SetPaycoData('ApprovalDatetime', AInfo.OrgAgreeDate);
      //���ι�ȣ
      SetPaycoData('ApprovalNo', AInfo.OrgAgreeNo);
      //����Ʈ �� �����ݾ��� ������ ���αݾ�
      SetPaycoData('ApprovalAmount', CurrToStr(AInfo.ApprovalAmount));
      //����Ÿ��
      SetPaycoData('ServiceType', AInfo.ServiceType);
    end;
    //�����ݾ� ����
    SetPaycoData('TotalAmount', CurrToStr(AInfo.PayAmt));
    // �����ݾ�(������ǰ�� ���ް��� ��)
    SetPaycoData('TotalTaxableAmount', CurrToStr(AInfo.DutyAmt));
    // �ΰ���(������ǰ�� �ΰ��� ��)
    SetPaycoData('TotalVatAmount', CurrToStr(AInfo.TaxAmt));
    // �鼼�ݾ�(�鼼��ǰ�� ���ް��� ��)
    SetPaycoData('TotalTaxfreeAmount', CurrToStr(AInfo.FreeAmt));
    // �����(���񽺿��)
    SetPaycoData('TotalServiceAmount', CurrToStr(AInfo.TipAmt));
    // ��ǰ�� ����
    SetPaycoData('ProductName', GoodsName);
    // ��ǰ����Ʈ ����
    SetPaycoData('ProductList', GoodsList);
    // ��ǰ����Ʈ �Ӽ� ����
    SetPaycoData('ProductListFieldCount', CurrToStr(AInfo.FieldCount));

//    Log.Write(ltInfo, ['MakeSendDataPayco(ProductName)' , GoodsName] );
//    Log.Write(ltInfo, ['MakeSendDataPayco(ProductList)' , GoodsList] );

    //KTC�ܸ�������ȣ ����
    SetPaycoData('KtcCertNo', ICHWSerial);
    //SetPaycoData('KtcCertNo', '####KCPOKPOS1001');
    //��ġ���
    //SetPaycoData('TouchMode', '');
    //�񵿱� �̺�Ʈ ID
    SetPaycoData('ASyncEndEventID', '1000');
    // 5���� ������ (�ʰ� : N, ����: Y)
    SetPaycoData('NocvmYN', IfThen(AInfo.PayAmt > CASH_50000, 'N', 'Y'));
    //����
//    NfcASyncRun(PaycoRevForm.Handle);
    NfcASyncRun(PaycoRevForm.Handle);
//    Sleep(500);
//    SetBarcode('20193813272949769592');
  finally
  end;
end;

function TPaycoNewModule.MakeRecvDataPayco(
  Amt: Currency; Approval: Boolean): TPaycoNewRecvInfo;
var
  Index : integer;
  resCd , resMsg ,  aServiceType , aTradeMethod ,
  aTradeNo , aPaymentMethodCode ,
  aApprovalNo , aTradeDatetime , aApprovalAmount , aQuota ,
  aPointAmt , aCouponAmt , aApprovalCompanyCode ,
  aPaymentMethodName , aApprovalCompanyName , aMerchantKey , aMerchantName ,
  aPayonCardOtc , aCouponName , aPointName , aCardNo ,
  aCardMerchantNo ,  aBuyCompanyName,  aBuyCompanyCode, aBuyTypeName,  aOneCardType ,
  aOneCardTypeName , aAcmPoint , aAcmUsablePoint , aAcmCumulationPoint ,
  aTradeBeforeAmount , aTradeAfterAmount ,
  aNocvmYN : PAnsiChar;

  // ��������� �ʿ��Ѱ�
  GetPaycoData     : TPAYCO_GetPaycoData;
  GetPaycoListCount: TPAYCO_GetPaycoListCount;
  GetPaycoListData : TPAYCO_GetPaycoListData;
begin
  Result.Result := False;
  try
    @GetPaycoData      := GetProcAddress(DLLHandle, 'GetPaycoData');
    @GetPaycoListCount := GetProcAddress(DLLHandle, 'GetPaycoListCount');
    @GetPaycoListData  := GetProcAddress(DLLHandle, 'GetPaycoListData');

    if not Assigned(@GetPaycoData) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['MakeRecvDataCard :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD]);
      Exit;
    end;

    GetMem(resCd, 1 + 1);
    GetMem(resMsg, 100 + 1);
    GetMem(aTradeMethod, 3 + 1);
    GetMem(aServiceType, 6 + 1);
    GetMem(aTradeNo, 20 + 1);
    GetMem(aPaymentMethodCode, 2 + 1);
    GetMem(aTradeDatetime, 14 + 1);
    GetMem(aApprovalAmount, 8 + 1);
    GetMem(aQuota, 2 + 1);
    GetMem(aPointAmt, 8 + 1);
    GetMem(aCouponAmt, 8 + 1);
    GetMem(aApprovalCompanyCode, 6 + 1);
    GetMem(aPaymentMethodName, 60 + 1);
    GetMem(aApprovalCompanyName, 60 + 1);
    GetMem(aMerchantKey, 6 + 1);
    GetMem(aMerchantName, 60 + 1);
    GetMem(aPayonCardOtc, 6 + 1);
    GetMem(aCouponName, 60 + 1);
    GetMem(aPointName, 60 + 1);
    GetMem(aCardNo, 30 + 1);
    GetMem(aCardMerchantNo, 100 + 1);
    GetMem(aBuyCompanyName, 100 + 1);
    GetMem(aBuyCompanyCode, 100 + 1);
    GetMem(aBuyTypeName, 100 + 1);
    GetMem(aOneCardType, 100 + 1);
    GetMem(aOneCardTypeName, 100 + 1);
    GetMem(aAcmPoint, 100 + 1);
    GetMem(aAcmUsablePoint, 100 + 1);
    GetMem(aAcmCumulationPoint, 100 + 1);
    GetMem(aNocvmYN, 100 + 1);
    GetMem(aTradeBeforeAmount, 100 + 1);
    GetMem(aTradeAfterAmount, 100 + 1);

    Zeromemory(resCd, 1 + 1);
    Zeromemory(resMsg, 100 + 1);
    Zeromemory(aTradeMethod, 3 + 1);
    Zeromemory(aServiceType, 6 + 1);
    Zeromemory(aTradeNo, 20 + 1);
    Zeromemory(aPaymentMethodCode, 2 + 1);
    Zeromemory(aTradeDatetime, 14 + 1);
    Zeromemory(aApprovalAmount, 8 + 1);
    Zeromemory(aQuota, 2 + 1);
    Zeromemory(aPointAmt, 8 + 1);
    Zeromemory(aCouponAmt, 8 + 1);
    Zeromemory(aApprovalCompanyCode, 6 + 1);
    Zeromemory(aPaymentMethodName, 60 + 1);
    Zeromemory(aApprovalCompanyName, 60 + 1);
    Zeromemory(aMerchantKey, 6 + 1);
    Zeromemory(aMerchantName, 60 + 1);
    Zeromemory(aPayonCardOtc, 6 + 1);
    Zeromemory(aCouponName, 60 + 1);
    Zeromemory(aPointName, 60 + 1);
    Zeromemory(aCardNo, 30 + 1);
    Zeromemory(aCardMerchantNo, 100 + 1);
    Zeromemory(aBuyCompanyName, 100 + 1);
    Zeromemory(aBuyCompanyCode, 100 + 1);
    Zeromemory(aBuyTypeName, 100 + 1);
    Zeromemory(aOneCardType, 100 + 1);
    Zeromemory(aOneCardTypeName, 100 + 1);
    Zeromemory(aAcmPoint, 100 + 1);
    Zeromemory(aAcmUsablePoint, 100 + 1);
    Zeromemory(aAcmCumulationPoint, 100 + 1);
    Zeromemory(aNocvmYN, 100 + 1);
    Zeromemory(aTradeBeforeAmount, 100 + 1);
    Zeromemory(aTradeAfterAmount, 100 + 1);

    aApprovalAmount := 0;
    aPointAmt := 0;
    aCouponAmt := 0;

    // ���� �� ��� ��� ���� �޴´�  ��0�� : ����
    resCd   := GetPaycoData('ResCd');//�ŷ�����ڵ�
    resMsg  := GetPaycoData('ResMsg');//�ŷ�����޼���

//    Log.Write(ltInfo, ['MakeRecvDataPayco ���� :'+ IntToStr(Index) , ' ����޼���  : ' + resMsg]);
    // ���� �� ��� ��� ��  '0' : ���� �ϰ��
    if resCd = '0' then
    begin
        Result.Result := True;                  // ��������
        Result.Code   := resCd;                 // �����ڵ�

        //�ŷ� ��� �� ->  ('VAN' / 'PG')
        aTradeMethod  := GetPaycoData('TradeMethod');
        //���� Ÿ�� ���� �޴� �Լ� (��PAYCO�� / ��PAYON�� / ��TMONEY��)
        aServiceType  := GetPaycoData('ServiceType');

        //�ŷ���ȣ�� �޴� �Լ� ��ҽ� ���
        aTradeNo                    :=  GetPaycoData('TradeNo');
        //�ŷ� �Ͻø� �޴� �Լ� ��ҽ� ���
        if Approval = True then
          aTradeDatetime              := GetPaycoData('ApprovalDatetime')
        else
          aTradeDatetime              := GetPaycoData('CancelDatetime');

        //���� ���� �ڵ带 �޴� �Լ� ��ҽ� ���
        aPaymentMethodCode          :=  GetPaycoData('PaymentMethodCode');
        //���� ���ܸ��� �޴� �Լ�
        aPaymentMethodName          :=  GetPaycoData('PaymentMethodName');
        //���� ��ȣ�� �޴� �Լ� ��ҽ� ���
        aApprovalNo                 :=  GetPaycoData('ApprovalNo');
        //���� �ݾ��� �޴� �Լ�  ��ҽ� ���
        aApprovalAmount             :=  GetPaycoData('ApprovalAmount');
        //�Һ� �Ⱓ�� �޴� �Լ� ��ҽ� ���
        aQuota                      := GetPaycoData('InstallmentPeriod');
        //���λ���� �޴� �Լ� ��ҽ� ���
        aApprovalCompanyName        :=  GetPaycoData('ApprovalCompanyName');
        //���λ� �ڵ带 �޴� �Լ�  ��ҽ� ���
        aApprovalCompanyCode        := GetPaycoData('ApprovalCompanyCode');
        //������ Ű
        aMerchantKey                :=  GetPaycoData('MerchantKey');
        //��������
        aMerchantName               :=  GetPaycoData('MerchantName');
        //ī���ȣ
        aCardNo                     :=  GetPaycoData('CardNo');

        //  �ŷ� ��� 'VAN' Ÿ���� ���
        if aTradeMethod = 'VAN' then
        begin
           // ī�� ��������ȣ
           aCardMerchantNo      := GetPaycoData('CardMerchantNo');
           // ���Ի��
           aBuyCompanyName      := GetPaycoData('BuyCompanyName');
           // ���Ի��ڵ�
           aBuyCompanyCode      := GetPaycoData('BuyCompanyCode');
           // ���Թ����
           aBuyTypeName         := GetPaycoData('BuyTypeName');
           // ��ī��Ÿ��
           aOneCardType         := GetPaycoData('OneCardType');
           // ��ī��Ÿ�Ը�
           aOneCardTypeName     := GetPaycoData('OneCardTypeName');
           // ��������Ʈ
           aAcmPoint            := GetPaycoData('AcmPoint');
           // ��밡�� ��������Ʈ
           aAcmUsablePoint      := GetPaycoData('AcmUsablePoint');
           // ���� ��������Ʈ
           aAcmCumulationPoint  := GetPaycoData('AcmCumulationPoint');
           // NoCVM �ŷ� ����
           aNocvmYN             := GetPaycoData('NocvmYN');
        end;

        if aServiceType = 'PAYCO' then       // 25. PAYCO ������
        begin
          if Approval  then     // ������ ���
          begin
            //��� ���� �ݾ�
            aCouponAmt          := GetPaycoData('CouponAmt');
            //��� ����Ʈ �ݾ�
            aPointAmt           := GetPaycoData('PointAmt');
            //��� ������
            aCouponName         := GetPaycoData('CouponName');
            //��� ����Ʈ��
            aPointName          := GetPaycoData('PointName');
          end
          else
          begin
            //��������
            aMerchantName       := GetPaycoData('MerchantName');
          end;
        end
        else if aServiceType = 'TMONEY' then     // 26. TMONEY ������
        begin
          //�������ܾ�
          aTradeBeforeAmount      := GetPaycoData('TradeBeforeAmount');
          //�������ܾ�
          aTradeAfterAmount       := GetPaycoData('TradeAfterAmount');
        end;

        // Payco ��������
        Result.Msg                   := resMsg;                              // ����޼���
        Result.AgreeNo               := aApprovalNo;                         // ���ι�ȣ
        Result.TradeNo               := aTradeNo;                            // �ŷ���ȣ

        if Copy(aTradeDatetime, 1, 2) <> '20' then
          Result.TransDateTime         := '20' + aTradeDatetime            // �ŷ��Ͻ�(yyyymmddhhnnss)
        else
          Result.TransDateTime       := aTradeDatetime;                      // �ŷ��Ͻ�(yyyymmddhhnnss)

        Result.PaymentMethodCode     := aPaymentMethodCode;                  // �������� �ڵ带 ����  Example : PAYCO, PAYON : 00 Ƽ�Ӵ� : 01
        Result.AgreeAmt              := Amt;                                 // ���αݾ�

        if Trim(aApprovalAmount) <> '' then
          Result.ApprovalAmount      := StrToInt(aApprovalAmount)            // ����Ʈ �� ���� �ݾ��� ���� �� ���� �ݾ�
        else
          Result.ApprovalAmount      := 0;

        if Trim(aPointAmt) <> '' then
          Result.PointAmt            := StrToInt(aPointAmt)                  // ����Ʈ�ݾ�
        else
          Result.PointAmt            := 0;

        if Trim(aCouponAmt) <> '' then
          Result.CouponAmt           := StrToInt(aCouponAmt)                 // �����ݾ�
        else
          Result.CouponAmt           := 0;

        Result.ServiceType           := aServiceType;                        // ���� Ÿ�� �� (��PAYCO�� / ��PAYON�� / ��TMONEY��)
        Result.HalbuMonth            := aQuota;                              // �Һΰ���
        Result.ApprovalCompanyName   := aApprovalCompanyName;                // ���λ��
        Result.ApprovalCompanyCode   := aApprovalCompanyCode;                // ���λ��ڵ�
        Result.MerchantKey           := aCardMerchantNo; //  aMerchantKey;   // ������Ű
        Result.MerchantName          := aMerchantName;                       // ��������
        Result.CouponName            := aCouponName;                         // ������
        Result.PointName             := aPointName;                          // ����Ʈ��
        Result.PayonCardOtc          := aPayonCardOtc;                       // PAYON ���� VAN ����� �� OTC ��
        Result.RevCardNo             := aCardNo;                             // ī���ȣ
        Result.BuyCompanyName        := aBuyCompanyName;                     // ���Ի��
        Result.BuyCompanyCode        := aBuyCompanyCode;                     // ���Ի��ڵ�
        Result.BuyTypeName           := aBuyTypeName;                        // ���Թ����
        Result.OneCardType           := aOneCardType;                        // ��ī��Ÿ��
        Result.OneCardTypeName       := aOneCardTypeName;                    // ��ī��Ÿ�Ը�

        if Trim(aAcmPoint) <> '' then
          Result.AcmPoint              := StrToInt(aAcmPoint)                // ��������Ʈ
        else
          Result.AcmPoint              := 0;                                 // ��������Ʈ

        if Trim(aAcmUsablePoint) <> '' then
           Result.AcmUsablePoint        := StrToInt(aAcmUsablePoint)         // ��밡�� ��������Ʈ
        else
           Result.AcmUsablePoint        := 0;                                // ��밡�� ��������Ʈ

        if Trim(aAcmCumulationPoint) <> '' then
           Result.AcmCumulationPoint    := StrToInt(aAcmCumulationPoint)     // ���� ��������Ʈ
        else
           Result.AcmCumulationPoint    := 0;                                // ���� ��������Ʈ

        if Trim(aTradeBeforeAmount) <> '' then
           Result.TradeBeforeAmount    := StrToInt(aTradeBeforeAmount)       // �������ܾ�
        else
           Result.TradeBeforeAmount    := 0;                                 // �������ܾ�

        if Trim(aTradeAfterAmount) <> '' then
           Result.TradeAfterAmount    := StrToInt(aTradeAfterAmount)         // �������ܾ�
        else
           Result.TradeAfterAmount    := 0;                                  // �������ܾ�
//        Log.Write(ltInfo, ['MakeRecvDataPayco �����ڵ� :'+ IntToStr(Index) , ' ����޼���  : ' + resMsg +
//                         ' ���ι�ȣ : ' + aApprovalNo + ' �ŷ���ȣ : ' + aTradeNo + ' ī���ȣ : ' + aCardNo]);
    end
    else
      Result.Msg := resMsg;
  finally
  end;
end;

function TPaycoNewModule.SetCofig(const Value: TPaycoNewConfig): Boolean;
var
  // ȯ�漳��
  NfcInit     : TPAYCO_NfcInit;
  SetPaycoData: TPAYCO_SetPaycoData;
begin
  try
    Result := False;
    @NfcInit      := GetProcAddress(DLLHandle, 'NfcInit');
    @SetPaycoData := GetProcAddress(DLLHandle, 'SetPaycoData');

    if not Assigned(@NfcInit) and not Assigned(@SetPaycoData) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['SetCofig :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD]);
      Exit;
    end;

    // �ʱ�ȭ��
    NfcInit;
    if UseMode = 0 then                                       // VAN MODE
    begin
      // VAN �ڵ� ����
      SetPaycoData('VanCode', Value.VanCode);
      // �ڵ���Ͽ���
      if TestMode = False then
      begin
        // ����ڹ�ȣ ����
        SetPaycoData('RegistrationNumber', Value.BizNo);
        // VAN POSID ����
        SetPaycoData('VanPosId', Value.VanPosID);
      end;
      if Value.VanCode = 'SMTR' then
      begin
        // VAN MerchantCode ����
        SetPaycoData('MerchantCode', 'SPOS');
        // VAN PosEntryMode ����
        SetPaycoData('PosEntryMode', '00');
      end
      else if Value.VanCode = 'FDIK' then
      begin
        // VAN MerchantPosNo ����
        SetPaycoData('MerchantPosNo', Value.VanSerialID);
      end;
      // �ڵ���Ͽ���
      // PAYCO ��û���� SetAutoPosRegisterYN > AutoPosRegisterYN���� ����
      if TestMode = True then
        SetPaycoData('AutoPosRegisterYN', 'N')
      else
        SetPaycoData('AutoPosRegisterYN', 'Y');

      // ������ ����â�� �ֻ������
      // SetPaycoData('WindowTopMostYN', 'Y');
      // �����̰� �����е尡 �������� �Ǵ�

//      if VanModul.SignPad then
//        SetPaycoData('SignpadYN', 'Y')
//      else
        SetPaycoData('SignpadYN', 'N');

      // �����̰� �����е� �̺�Ʈ POS ���� ó������ �ƴ� PAYCO���� ó������ ����
      SetPaycoData('SignEventUseYN', 'Y');
      // ����� ��û��� ��뿩��
      SetPaycoData('SendNetworkCancelYN', 'Y');
      // TopMost ����
      SetPaycoData('WindowTopMostYN', 'Y');
     end
    else                                                      // PG MODE
    begin
      // VAN �ڵ� ����
      SetPaycoData('VanCode', 'KCP');
      // �����̰� �����е� �̺�Ʈ POS ���� ó������ �ƴ� PAYCO���� ó������ ����
      SetPaycoData('SignEventUseYN', 'Y');
      // ����� ��û��� ��뿩��
      SetPaycoData('SendNetworkCancelYN', 'Y');
    end;
    Result := True;
  finally
  end;
end;

function TPaycoNewModule.ReadINIFirstKey: Boolean;
var
  AppPath: string;
begin
  Result := False;
  AppPath := ExtractFilePath(Application.ExeName);
  with TIniFile.Create(AppPath + _INI_PAYCO) do
  begin
    try
      Result := ReadBool('KEY', FormatDateTime('yyyymmdd', Now), False);
    finally
      Free;
    end;
  end;
end;

procedure TPaycoNewModule.WriteINIFirstKey;
var
  AppPath: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  with TIniFile.Create(AppPath + _INI_PAYCO) do
  begin
    try
      WriteBool('KEY', FormatDateTime('yyyymmdd', Now), True);
    finally
      Free;
    end;
  end;
end;

function TPaycoNewModule.SetClose: Boolean;
var
  // ��������� �ʿ��Ѱ�
  NfcSendASyncEnd: TPAYCO_NfcSendASyncEnd;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule.SetClose ����'] );
  try
    @NfcSendASyncEnd := GetProcAddress(DLLHandle, 'NfcSendASyncEnd');
    if not Assigned(@NfcSendASyncEnd) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['SetClose :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // �����������
    NfcSendASyncEnd;
  finally
  end;
end;

procedure TPaycoNewModule.PaycoRevClose;
begin
  if PaycoRevForm <> nil then
  begin
    PaycoRevForm.Close;
    FreeAndNil(PaycoRevForm);
  end;
end;

procedure TPaycoNewModule.PaycoRevOpen;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevOpen']);
  if PaycoRevForm  = nil then
  begin
//    Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevForm = nil']);
//    PaycoRevForm := TPaycoRevForm.Create(Application);
    PaycoRevForm := TPaycoRevForm.Create(nil);
    PaycoRevForm.Show;
    PaycoRevForm.Update;
  end;
end;

function TPaycoNewModule.PaycoRevCheck: Boolean;
var
  GetTime: Cardinal;
  aSignData, aSignEtcData, AppPath, aRevMsg, aResultMsg: AnsiString;
  // �����е� �����̹������� ó���մϴ�
  NfcSendSignData: TPAYCO_NfcSendSignData;
  aGubun: Integer;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevCheck Start']);
  Result       := False;
  aSignData    := EmptyStr;
  aSignEtcData := EmptyStr;
  aRevMsg      := EmptyStr;
  AppPath      := ExtractFilePath(Application.ExeName);

  // ���� ó��
  GetTime := GetTickCount;
  // ���� ���ð��� 5�е� ��������� ���� ó���� �ʿ��ϴ�.
  while GetTime + (600 * 1000) > GetTickCount do
  begin
    Application.ProcessMessages;
   // if PaycoRevForm.RevState <> 0 then
   // Log.Write(ltInfo, ['PaycoRevCheck :' , 'PaycoRevForm.RevState : ' + IntToStr(PaycoRevForm.RevState) ] );
    if PaycoRevForm.RevState = 1 then            // �����Ϸ��ϰ��
    begin
      Result := True;
      SetClose;
      PaycoRevForm.RevState := 0;
      Exit;
    end
    else if PaycoRevForm.RevState = 9 then       // ���������ϰ��
    begin
      SetClose;
      Exit;
    end
    else if PaycoRevForm.RevState = 2 then       // �����û�ϰ��
    begin
      try
//        Log.Write(ltInfo, ['PaycoRevCheck : ', PaycoRevForm.RevMsg]);
        aRevMsg :=  PaycoRevForm.RevMsg;    // ��������� FDIK������ ����մϴ�.

        @NfcSendSignData := GetProcAddress(DLLHandle, 'NfcSendSignData');
        if not Assigned(@NfcSendSignData) then
        begin
          ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//          Log.Write(ltInfo, ['PaycoRevCheck :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ]);
          Exit;
        end;

        // ���αݾ� | �ҺαⰣ | ����1 | ����2 | ����3
        {if VanModul.CallSignPad(FloatToStr(TotPayAmt), '00', '', '', aRevMsg, aSignData, aSignEtcData, aGubun)then
        begin
          if aGubun = CODE_ONE then
            aResultMsg := 'SUCCESS'
          else if aGubun = CODE_TWO then
            aResultMsg := 'EXCEPTION';
          NfcSendSignData(aResultMsg, IntToStr(Length(aSignData)), aSignData,AppPath + VanModul.SignImageName, aSignEtcData);
          PaycoRevForm.RevState := 0;
        end
        else
        begin
          if aGubun = CODE_TWO then
            aResultMsg := 'EXCEPTION'
          else if aGubun = CODE_THREE then
            aResultMsg := 'SIGN_CANCEL';
          NfcSendSignData(aResultMsg, IntToStr(Length(aSignData)), aSignData,AppPath + VanModul.SignImageName, aSignEtcData);
          PaycoRevForm.RevState := 0;
        end; }
      finally
      end;
    end
  end;
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevCheck End']);
end;

function TPaycoNewModule.SetOpen: Boolean;
var
  // ���������� �ʿ��Ѱ�  ( ���� �����Ҷ����� ���� 1ȸ )
  NfcDailyRun: TPAYCO_NfcDailyRun;
begin
  try
    Result := False;
//    ini ������ ���� �ʰ� ���� ����� ������ ȣ��
//    if ReadINIFirstKey = True then Exit;

    @NfcDailyRun := GetProcAddress(DLLHandle, 'NfcDailyRun');
    if not Assigned(@NfcDailyRun) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['SetOpen :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // ������������
    NfcDailyRun;
//    ini ������ ���� �ʰ� ���� ����� ������ ȣ��
//    WriteINIFirstKey;
    Result := True;
  finally
  end;
end;

procedure TPaycoNewModule.SetBarcode(ABarcode: AnsiString);
var
  NfcSendBarcode: TPAYCO_NfcSendBarcode;
begin
  try
    @NfcSendBarcode := GetProcAddress(DLLHandle, 'NfcSendBarcode');

    if not Assigned(@NfcSendBarcode) then
    begin
      ShowMessage('SendBarcode ����');
    end;
    Delay(1500);
    NfcSendBarcode(ABarcode);
  finally

  end;
end;

function TPaycoNewModule.SetCancel: Boolean;
var
  // ������۾�
  NfcSendNetworkCancel: TPAYCO_NfcSendNetworkCancel;
begin
  try
    Result := False;
    @NfcSendNetworkCancel := GetProcAddress(DLLHandle, 'NfcSendNetworkCancel');

    if not Assigned(@NfcSendNetworkCancel) then
    begin
      ShowMessage(filPAYCO_DLL + ' �ε� ���� ');
//      Log.Write(ltInfo, ['SetCancel :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // ����� ��û��� ���
    NfcSendNetworkCancel;
    Result := True;
  finally
  end;
end;

end.
