unit uSBVanKFTC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, StrUtils, Math, uSBVanApprove;

type
  TMSCallbackEvent = procedure(ACardNo: string) of object;
  TICCallbackEvent = procedure(ACardNo, AEmvInfo: string) of object;

  TVanKFTC = class(TVanApprove)
  private
    // �⺻�� ���� ���� ����
    FInitRun: Boolean;
    FWorkingKey: AnsiString;
    FDualPayKey: AnsiString;
    DLLHandle: THandle;
    FMSCallbackEvent: TMSCallbackEvent;
    FICCallbackEvent: TICCallbackEvent;
    function GetErrorMsg(ACode: Integer): AnsiString;
    function GetErrorMsgIC(ACode: Integer): AnsiString;
    function GetErrorMsgFallBack(ACode: string): AnsiString;
    function GetFuncName(AFCode: Integer): string;
    function GetSeqNo: AnsiString;
    procedure ReadIni;
    procedure WriteIni;
    function MakeSendDataInit: AnsiString;
    function MakeSendDataPosDownload: AnsiString;
    function MakeSendDataCard(AInfo: TCardSendInfo; ASignData: AnsiString; AGubun: Integer): AnsiString;
    function MakeSendDataCardSecure(AInfo: TCardSendInfo; ASignData, ADecrypt, AEncData, AEmvData, AFallBack, APinData: AnsiString): AnsiString;
    function MakeSendDataCash(AInfo: TCashSendInfo): AnsiString;
    function MakeSendDataCashSecure(AInfo: TCashSendInfo; ADecrypt, AEncData: AnsiString): AnsiString;
    function MakeSendDataCheck(AInfo: TCheckSendInfo): AnsiString;
    function MakeSendDataCashIC(AInfo: TCardSendInfo; ARecvData: AnsiString; APayOn: Boolean): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfo;
    function MakeRecvDataCardIC(ARecvData: AnsiString; out AAIDCount: Integer; out AAIDList, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
    function MakeRecvDataCardICFallBack(ARecvData: AnsiString; out AFallBack, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
    function MakeRecvDataCash(ARecvData: AnsiString): TCashRecvInfo;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCheckRecvInfo;
    function MakeSendWeChatData(AInfo: TCardSendInfo): string;
    function DLLExec(FCode: Integer; ASendData: AnsiString; out ARetCode: Integer; out ARecvData: AnsiString): Boolean;
    function DLLExecSign: Boolean;
    function DoStartProc(out AMsg: AnsiString): Boolean;
    function DoPosInit: Boolean;
    function DoPosDownload: Boolean;
    function DoKeyDownload: Boolean;
    function DoCardSign(ASaleAmt: Integer; out ASignData: AnsiString): Boolean;
    function DoPinPad(ACardNo: AnsiString; out APinData: AnsiString): Boolean;
    function DoPinPadIC(APinData: AnsiString; out APinDataIC: AnsiString): Boolean;
    function DoCallCard(AInfo: TCardSendInfo): TCardRecvInfo;
    function DoCallCardICSecure(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
    function DoCallCardMSRSecure(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
    function DoCallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
    function DoEventICDetectStart: Boolean;
    function DoEventICDetectStop: Boolean;
  protected
    procedure EventMessageFormCancelClick(Sender: TObject); override;
  public
    constructor Create;
    destructor Destroy; override;
    function CallPosDownload: TPosDownloadRecvInfo; override;
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo; override;
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo; override;
    function CallPinPad(out ARetData: AnsiString): Boolean; override;
    procedure CallPinCancel; override;
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallCoupon(AUse: Boolean; AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallRuleDownload: TRuleDownRecvInfo; override;
    function CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo; override;
    function CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean; override;
    function CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean; override;
    function CallMSR(AGubun: AnsiString; out ACardNo,ADecrypt, AEncData: AnsiString): Boolean; override;
    function CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean; override;
    function CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo: AnsiString; out AEmvInfo: AnsiString): Boolean; override;
    function SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString; ACallbackMS, ACallbackIC: Pointer): Boolean; override;
    function WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo; override;
    property OnMSCallBackEvent: TMSCallbackEvent read FMSCallbackEvent write FMSCallbackEvent;
    property OnICCallBackEvent: TICCallBackEvent read FICCallBackEvent write FICCallBackEvent;
  end;

  TVanCatKFTC = class(TVanCatApprove)
  private
    DLLHandle: THandle;
    DLLHandle_Sign: THandle;
    FReadBuff,
    FRecvData: AnsiString;
    FUserCancel: Boolean;
    FWorkingKey: AnsiString;
    FInitRun: Boolean;
    // �ѱ� ������ <-> �ϼ�����ȯ(0:������ -> �ϼ���, 1:�ϼ��� -> ������)
    function DoCodeConv(AGubun: Integer; ASrc: AnsiString): AnsiString;
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    function ExecSendData(ASendData: AnsiString): Boolean;
    function ComPortOpen: Boolean;
    function GetErrorMsg(ACode: Integer): AnsiString;
    procedure ReadIni;
    function DoPosInit: Boolean;
    function MakeSendDataInit: AnsiString;
  protected
    procedure EventMessageFormCancelClick(Sender: TObject); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo; override;
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function PrintOut(APrintData: AnsiString): Boolean; override;
    function CashDrawOpen: Boolean; override;
    function CallPinPad(out ARetData: AnsiString): Boolean; override;
    function DLLExec(FCode: Integer; ASendData: AnsiString; out ARetCode: Integer; out ARecvData: AnsiString): Boolean;
    function DoStartProc(out AMsg: AnsiString): Boolean;
    procedure CallPinCancel; override;
  end;

  TVanKFTCDaemon = class(TVanApprove)
  private
    function GetStringSearch(AFID, AStr: string): string;
    function ExecTcpSendData(ASendData: string; out ARecvData: string): Boolean;
    function DoCallCard(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
  public
    constructor Create;
    destructor Destroy; override;
    function CallCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallCash(AInfo: TCashSendInfo): TCashRecvInfo; override;
    function CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo; override;
    function CallPinPad(out ARetData: AnsiString): Boolean; override;
    function CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo; override;
    function CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean; override;
  end;


implementation

uses
  uXGGlobal, uSBVanFunctions, cxAria, CPort,
  IdGlobal, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TKFTC_POS_TRANS      = function(FC: Integer; lpPOSInData, lpPOSOutData: PAnsiChar): Integer; stdcall;
  TKFTC_CallPosSetPath = procedure(caPath: AnsiString); stdcall;
  TKFTC_CallSetKey     = procedure(nSetEnterKey, nSetCancelKey, nSetCorrKey: ShortInt); stdcall;
  TKFTC_SetMSCallback  = procedure(AFunc: Pointer); stdcall;
  TKFTC_SetICCallback  = procedure(AFunc: Pointer); stdcall;
  TSET_IC_DETECT       = function(AFunc: Pointer): Integer; stdcall;

  // �ѱ� ������ <-> �ϼ�����ȯ(������ -> �ϼ��� : 0, �ϼ��� -> ������ : 1)
  TCodeConv = function(ConvType: Integer; SrcString: PAnsiChar; DestString: PAnsiChar): Integer; stdcall;

const
  KFTC_SIGN_DLL = 'kftcpos.dll';
  KFTC_INI      = 'ktfcpos.ini';
  KFTC_CONV_DLL = 'KsUnion.dll';

  CRYPT_KEY     = 'KFTC_L_KEY_001'; // ini���Ͽ� ����Ǵ� WorkingKey�� ��ȣȭ �ϱ� ���� Key
  //KTC_KEY_ZEUS  = 'DUALPAY_633CP101#####ZEUSPOS1001'; // IC���� KTC ����Ű (���콺��)
  KTC_KEY_ZEUS  = '#####ZEUSPOS1001'; // IC���� KTC ����Ű (���콺��)

{ TVanKFTC }

constructor TVanKFTC.Create;
begin
  FInitRun := False;
  DLLHandle := LoadLibrary(KFTC_SIGN_DLL);
end;

destructor TVanKFTC.Destroy;
begin
  FreeLibrary(DLLHandle);
  inherited;
end;

function TVanKFTC.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    1 : Result := 'Transaction Time out';
    2 : Result := '���뼱 ���� �� ��';
    3 : Result := '��� ����(������ ����)';
    4 : Result := 'ȸ�� ��� (TCP/IP)';
    5 : Result := 'EOT �� ���� ( �Ϲ������� �߻����� ���� )';
    6 : Result := '�ΰ� ��� ��� ���� Ȯ��';
    7 : Result := 'Pinpad �Է� �� ��ǥ ��ȸ�� Reading Time out';
    8 : Result := 'ȸ�� ���(PORT Open Error)';
    9 : Result := '��ġ ���� �ȵ�';
    10: Result := '��ġ ������ ����';
    11: Result := '������ ���� ����';
    12: Result := '������������Error(DLE����)';
    13: Result := '�����е忡�� �����ư�� ����';
    15: Result := '�Ϲ� ���������� ĳ���� �ŷ� ��û �� ����';
    19: Result := '���ε���Ÿ Error';
    20: Result := '�����е� com port open ����';
    21: Result := '���е� �ʱ�ȭ ����';
    23: Result := '���� ���� ����';
  else
    Result := '�˼� ���� ����';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanKFTC.GetErrorMsgIC(ACode: Integer): AnsiString;
begin
  case ACode of
    0 : Result := '������ ���� ����';
    1 : Result := '������ ���Ἲ ����(Integrity Check Error)';
    2 : Result := 'Reader Error(ICī�带 �־��ּ���)';
    3 : Result := 'IC Error';
    4 : Result := '�ݾ� ��û Reader';
    5 : Result := '�ݾ� ��û IC';
    6 : Result := 'IC �ŷ� �Ұ�';
    7 : Result := 'Fallback';
    8 : Result := 'IC ī�� ���ԵǾ� ����';
    9 : Result := '��Ȳ�� ���� �ʴ� ���';
    10: Result := '��ȣ��������';
    11: Result := '��ȣȭ/��ȣȭ ����';
    12: Result := 'MS�ŷ� �Ұ� ICī��� ���� �ٶ��ϴ�. IC ī�带 �־��ּ���(2xx, 6xx)';
    13: Result := '������ KEY �ٿ�ε� ���';
  else
    Result := '�˼� ���� ����';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanKFTC.GetErrorMsgFallBack(ACode: string): AnsiString;
begin
  case StrToIntDef(ACode, -1) of
    1 : Result := 'Chip ������ �־����� ������ ���� ���';
    2 : Result := '��ȣ���� application�� ���� ���';
    3 : Result := 'Ĩ ������ �б� ���� (�߰��� ����)';
    4 : Result := '�ʼ� ������ ������';
    5 : Result := 'CVM Ŀ�ǵ� ���� ����';
    6 : Result := '�߸��� EMV Ŀ�ǵ�';
    7 : Result := '�͹̳� ���۵�';
  else
    Result := '�˼� ���� ����';
  end;
  Result := Result + ' [' + ACode + ']';
end;

function TVanKFTC.GetFuncName(AFCode: Integer): string;
begin
  case AFCode of
    $F0 : Result := '�⺻������';
    $F1 : Result := '�������ٿ�ε�';
    $E8 : Result := '����ó��';
    $90 : Result := '�������ʱ�ȭ';
    $91 : Result := '���������Ȯ��';
    $92 : Result := '���Ἲüũ';
    $93 : Result := 'IC�ŷ�����';
    $94 : Result := 'IC�ŷ����';
    $95 : Result := 'Fallback�ŷ�';
    $96 : Result := 'MS�ŷ�';
    $97 : Result := 'KeyIn�ŷ�';
    $98 : Result := 'PIN��Ͽ�û';
    $99 : Result := 'ī�尨���̺�Ʈ����';
    $9A : Result := 'ī�尨���̺�Ʈ�ߴ�';
    $9B : Result := 'KeyDownload��û';
    $AA : Result := '��ŷ�����';
    $AB : Result := '��ŷ����';
    $AE : Result := '�����ý���';
    $AF : Result := '���������';
  else
    Result := '';
  end;
end;

function TVanKFTC.GetSeqNo: AnsiString;
var
  SeqNo: Integer;
begin
  // �Ϸù�ȣ (10�ڸ�, ������ ���� ���� ������ �����ؾ� ��)
  with TIniFile.Create(Global.HomeDir + 'KFTCSeq.ini') do
    try
      SeqNo := ReadInteger('SEQ', 'SeqNo', 10010010);
      // ���� ��ȣ�� ����
      WriteInteger('SEQ', 'SeqNo', SeqNo + 1);
    finally
      Free;
    end;
  Result := FormatFloat('0000000000', SeqNo);
end;

procedure TVanKFTC.ReadIni;
var
  AWKey: AnsiString;
begin
  with TIniFile.Create(Global.HomeDir + 'kftc.ini') do
    try
      Config.TerminalID := ReadString('POS', 'TerminalID', '');
      AWKey := ReadString('POS', 'WorkingKey', '');
      if Config.SecureMode and (AWKey <> '') then
        FWorkingKey := DecryptAria(CRYPT_KEY, AWKey)
      else
        FWorkingKey := AWKey;
    finally
      Free;
    end;
end;

function TVanKFTC.WechatExecPayProc(AInfo: TCardSendInfo): TCardRecvInfo;
var
  SendData, RecvData: AnsiString;
  FCode, RetCode: Integer;
begin
  try
    RetCode := 0;
    if not DoStartProc(RecvData) then
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;

    SendData := MakeSendWeChatData(AInfo);

    FCode := IfThen(AInfo.Approval, $C7, $C8);

    if DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      Result := MakeRecvDataCard(RecvData);

      if AInfo.Approval and (Result.Code = '999') then
      begin
        AInfo.OrgAgreeNo := Result.AgreeNo;
        AInfo.CardNo     := 'Q' + Trim(Result.PointAgreeNo);
        SendData := MakeSendWeChatData(AInfo);
      end;

      // �����ڵ尡 999�̸� 3~5�ʸ��� ��� ��ȸ��û
      // �ٽÿ�û�� �ڵ尡 999�̸� �ݺ� ����
      // 999�ڵ尡 �ƴϸ� ����� �����Ѵ�.
      while Result.Code = '999' do
      begin
        Delay(3000);
        FCode := $C9;
        if DLLExec(FCode, SendData, RetCode, RecvData) then
          Result := MakeRecvDataCard(RecvData);
      end;

      if not (Result.Code = '000') then
      begin
        Result.Result := False;
        Result.Msg := GetErrorMsg(RetCode);
      end;
    end
    else
    begin
      Result.Result := False;
      Result.Msg := GetErrorMsg(RetCode);
    end;
  finally
    Log.Write(ltInfo, ['WechatExecPayProc End', '']);
  end;
end;

procedure TVanKFTC.WriteIni;
var
  AWKey: AnsiString;
begin
  with TIniFile.Create(Global.HomeDir + 'kftc.ini') do
    try
      WriteString('POS', 'TerminalID', Config.TerminalID);
      if Config.SecureMode then
        AWKey := CryptAria(CRYPT_KEY, FWorkingKey)
      else
        AWKey := FWorkingKey;
      WriteString('POS', 'WorkingKey', AWKey);
    finally
      Free;
    end;
end;

function TVanKFTC.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfo;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 1);
  // ����޼���
  Result.Msg := Trim(StringSearch(ARecvData, FS, 18)) + ' ' + StringSearch(ARecvData, FS, 10);
  if Result.Code = '000' then
    Result.Msg := Copy(Trim(Result.Msg), 1, 12);
  // ���ι�ȣ
  Result.AgreeNo := StringSearch(ARecvData, FS,  8);
  // �ŷ���ȣ
  Result.TransNo := StringSearch(ARecvData, FS,  11);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // �߱޻��ڵ�
  Result.BalgupsaCode := '';
  // �߱޻��
  Result.BalgupsaName := Trim(StringSearch(ARecvData, FS, 12));
  // ���Ի��ڵ�
  Result.CompCode := StringSearch(ARecvData, FS, 13);
  // ���Ի��
  Result.CompName := Trim(StringSearch(ARecvData, FS, 14));
  // ��������ȣ
  Result.KamaengNo := StringSearch(ARecvData, FS,  9);
  // �������̿�
  Result.PointAgreeNo := StringSearch(ARecvData, FS,  18);
  Result.PrintMsg := StringSearch(ARecvData, FS,  19);
  // ���αݾ� (���������� ����)
//  Result.AgreeAmt := 0;
  // ���αݾ� (���������� ����)
  Result.DCAmt := 0;
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTC.MakeRecvDataCardIC(ARecvData: AnsiString; out AAIDCount: Integer; out AAIDList, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
begin
  // �޺κ��� �ι��ڸ� ���ش�.
  ARecvData := StringSearch(ARecvData, #255, 0);
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 0);
  // AID ����
  AAIDCount := StrToIntDef(StringSearch(ARecvData, FS, 1), 0);
  // AID ����Ʈ
  AAIDList := StringSearch(ARecvData, FS, 2);
  // ��ȣȭ ����
  ADecrypt := StringSearch(ARecvData, FS, 3);
  // ���αݾ�
  Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 4), 0);
  // ī���ȣ
//  Result.ICCardNo := StringSearch(ARecvData, FS, 5);
  Result.ICCardNo := StringSearch(StringSearch(StringSearch(ARecvData, FS, 5), '=', 0), 'D', 0);
  // ��ȣȭ ����Ÿ
  AEncData := StringSearch(ARecvData, FS, 6);
  // EMV ����Ÿ
  AEmvData := StringSearch(ARecvData, FS, 7);
  // ������ ����Ű
  FDualPayKey := StringSearch(ARecvData, FS, 8);
  // ���αݾ� (���������� ����)
  Result.DCAmt := 0;
  // ��������
  Result.Result := Result.Code = '00';
  if not Result.Result then
    Result.Msg := GetErrorMsgIC(StrToIntDef(Result.Code, -1));
end;

function TVanKFTC.MakeRecvDataCardICFallBack(ARecvData: AnsiString; out AFallBack, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
begin
  // �޺κ��� �ι��ڸ� ���ش�.
  ARecvData := StringSearch(ARecvData, #255, 0);
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 0);
  // ��ȣȭ ����
  ADecrypt := StringSearch(ARecvData, FS, 1);
  // FallBack �ڵ�
  AFallBack := StringSearch(ARecvData, FS, 2);
  // ī���ȣ
//  Result.ICCardNo := StringSearch(ARecvData, FS, 3);
  Result.ICCardNo := StringSearch(StringSearch(ARecvData, FS, 3), '=', 0);
  // ��ȣȭ ����Ÿ
  AEncData := StringSearch(ARecvData, FS, 4);
  // EMV ����Ÿ
  AEmvData := StringSearch(ARecvData, FS, 5);
  // ������ ����Ű
  FDualPayKey := StringSearch(ARecvData, FS, 6);
  // ���αݾ� (���������� ����)
  Result.AgreeAmt := 0;
  // ���αݾ� (���������� ����)
  Result.DCAmt := 0;
  // ��������
  Result.Result := Result.Code = '00';
  if not Result.Result then
    Result.Msg := GetErrorMsgIC(StrToIntDef(Result.Code, -1));
end;

function TVanKFTC.MakeRecvDataCash(ARecvData: AnsiString): TCashRecvInfo;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 1);
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 10) + ' ' + StringSearch(ARecvData, FS, 18) + ' ' + StringSearch(ARecvData, FS, 19);
  // ���ι�ȣ
  Result.AgreeNo := StringSearch(ARecvData, FS,  8);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTC.MakeRecvDataCheck(ARecvData: AnsiString): TCheckRecvInfo;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 1);
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 5);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTC.MakeSendDataInit: AnsiString;
var
  SignPadRate: string;
begin
  if Config.SignRate = 115200 then
    SignPadRate := '1152000000000'
  else
    SignPadRate := '0576000000000';
  Result := '0' + FS +      // Mode
            '0' + FS +      // TCP/IP
//            IfThen(Config.RealMode, '8002', IntToStr(Config.HostPort)) + FS +
//            IfThen(Config.RealMode, 'www.kftcvan.or.kr', Config.HostIP) + FS +
            '8002' + FS +
            'www.kftcvan.or.kr' + FS +
            'test01' + FS +
            'test01' + FS;
            // ó���ŷ��̸� �ʱ⼳������ ������������ �ٿ�޴´�
  Result := Result + IfThen(Config.TerminalID = EmptyStr, Config.SerialNo, Config.TerminalID) + FS +
            '0000' + FS +       // ����(#50:���, #51:������)
            '1200' + FS +       // �����
            '15'   + FS +       // ������(15��)
            '05'   + FS +       // ENQ ���ð�
            '03'   + FS +       // EOT ���ð�
            IfThen(Config.SignPad, IntToStr(Config.SignPort) + SignPadRate, '00000000000000') + FS + // �ΰ���񱸺� Pinpad ��Ʈ(1)
            '0' + FS +          // OCB ����(����������)
            '0' + FS +          // ����Ʈ����
            IfThen(Config.HWSecure, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +     // �ܸ�����Ʈ �� �ӵ� ����
            Config.ProgramCode + FS + // ���α׷� ������
            Config.ProgramVersion + FS + // ���α׷� ����
            '8002' + FS +  // LAN IP
            'www.kftcvan.or.kr' + FS + // LAN PORT
            IfThen(Config.SecureMode, FormatFloat('00', Config.MSRPort) + '115200', '00000000') + FS +   // IC������ ��Ʈ �� �ӵ�
            KTC_KEY_ZEUS + // �ܸ��� ������ȣ
            #255;
end;

function TVanKFTC.MakeSendDataPosDownload: AnsiString;
begin
  Result := Config.SerialNo + FS +
            Config.BizNo    + FS +
            Config.Password + #255;
end;

function TVanKFTC.MakeSendWeChatData(AInfo: TCardSendInfo): string;
var
  SeqNo, AEncData: AnsiString;
begin
  AEncData := AInfo.CardNo;
            // ī���ȣ
  Result := AEncData + FS
            // �ŷ��ݾ�   (
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.FreeAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // �ΰ���
            + CurrToStr(AInfo.VatAmt)+ FS
            // �����
            + CurrToStr(AInfo.SvcAmt)+ FS
            // �Һΰ���
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // �Ϸù�ȣ (10�ڸ�)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // ���ŷ���
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // �����ι�ȣ
            + IfThen(AInfo.OrgAgreeNo <> EmptyStr, AInfo.OrgAgreeNo, '00000000') + FS
            + FS  // ���ŷ��Ϸù�ȣ (���X)
            + FS  // PIN(��й�ȣ)
            + FS  // Cust_id
            + FS // ��������
            + FS // ��������
            + FS // ������ȣ
            + FS // ������ ����ȯ��
            + CurrToStr(AInfo.FreeAmt) + FS // ����� �ݾ�
            + FS // ��һ����ڵ�
            + FS // ����ī�� ���� ����
            + FS // ��������ȭ����
            + FS // EMVī�� ����
            + FS // fallback
            + FS  // ��ȣȭ ����
            + FDualPayKey + KTC_KEY_ZEUS + FS // KTC ����Ű
            + 'KRW'
            + #255;
end;

function TVanKFTC.MakeSendDataCard(AInfo: TCardSendInfo;
  ASignData: AnsiString; AGubun: Integer): AnsiString;
var
  CardNo: AnsiString;
  SeqNo: AnsiString;
begin
  // AGubun 0: �ſ���� 1:����IC 2:PayOn
  case AGubun of
    1: CardNo := Copy(AInfo.CardNo, 4, 16);
    2: CardNo := Trim(AInfo.CardNo);
  else
    CardNo := Format('%-37.37s', [AInfo.CardNo]);
  end;
  // KeyIn (PayOn �̸� P)
  if AGubun = 2 then
    Result := 'P'
  else
    Result := IfThen(AInfo.KeyInput, #$30, #$31);
            // ī���ȣ
  Result := Result + CardNo + FS
            // �ŷ��ݾ�
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // �ΰ���
            + CurrToStr(AInfo.VatAmt)+ FS
            // �����
            + CurrToStr(AInfo.SvcAmt)+ FS
            // �Һΰ���
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // �Ϸù�ȣ (10�ڸ�)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // ���ŷ���
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // �����ι�ȣ
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // ���ŷ��Ϸù�ȣ (���X)
            + FS  // PIN
            + '0' + FS;  // Cust_id
  // ��������
  if AGubun in [0, 2] then
    Result := Result + ASignData + #255
  else
    Result := Result + FS + FS + FS + FS + FS + FS + AInfo.CardNo + FS + 'YY00' + #255;
end;

function TVanKFTC.MakeSendDataCardSecure(AInfo: TCardSendInfo;
  ASignData, ADecrypt, AEncData, AEmvData, AFallBack, APinData: AnsiString): AnsiString;
var
  SeqNo: AnsiString;
begin
            // ī���ȣ
  Result := AEncData + FS
            // �ŷ��ݾ�
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // �ΰ���
            + CurrToStr(AInfo.VatAmt)+ FS
            // �����
            + CurrToStr(AInfo.SvcAmt)+ FS
            // �Һΰ���
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // �Ϸù�ȣ (10�ڸ�)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // ���ŷ���
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // �����ι�ȣ
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // ���ŷ��Ϸù�ȣ (���X)
            + APinData + FS  // PIN(��й�ȣ)
            + FS  // Cust_id
            + ASignData + FS // ��������
            + FS // ��������
            + FS // ������ȣ
            + FS // ������ ����ȯ��
            + FS // ����� �ݾ�
            + FS // ��һ����ڵ�
            + FS // ����ī�� ���� ����
            + FS // ��������ȭ����
            + AEmvData + FS // EMVī�� ����
            + AFallBack + FS // fallback
            + ADecrypt + FS  // ��ȣȭ ����
            + FDualPayKey + KTC_KEY_ZEUS // KTC ����Ű
            + #255;
end;

function TVanKFTC.MakeSendDataCash(AInfo: TCashSendInfo): AnsiString;
var
  SeqNo: AnsiString;
begin
            // ī���ȣ
  Result := IfThen(AInfo.KeyInput, #$30, #$31) + Format('%-37.37s', [AInfo.CardNo]) + FS
            // �ŷ��ݾ�
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // �ΰ���
            + CurrToStr(AInfo.VatAmt)+ FS
            // �����
            + CurrToStr(AInfo.SvcAmt)+ FS
            + FS;
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // ���ŷ���
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // �����ι�ȣ
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            // ���ŷ��Ϸù�ȣ (������)
            + FS
            // ��й�ȣ
            + FS
            // ����/�����
            + IfThen(AInfo.Person, '0', '1') + FS
            + FS
            + FS
            + FS
            + FS
            + FS
            // ��һ����ڵ�
            + IfThen(AInfo.CancelReason in [1, 2, 3], IntToStr(AInfo.CancelReason), '0')
            + #255;
end;

function TVanKFTC.MakeSendDataCashSecure(AInfo: TCashSendInfo; ADecrypt, AEncData: AnsiString): AnsiString;
var
  SeqNo: AnsiString;
begin
            // ī���ȣ
  Result := IfThen(AEncData <> '', AEncData, AInfo.CardNo) + FS
            // �ŷ��ݾ�
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // �ΰ���
            + CurrToStr(AInfo.VatAmt)+ FS
            // �����
            + CurrToStr(AInfo.SvcAmt)+ FS
            + FS;
            // �Ϸù�ȣ (10�ڸ�)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // ���ŷ���
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // �����ι�ȣ
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // ���ŷ��Ϸù�ȣ (���X)
            + FS  // PIN(��й�ȣ)
            + IfThen(AInfo.Person, '0', '1') + FS // Cust_id
            + FS // ��������
            + FS // ��������
            + FS // ������ȣ
            + FS // ������ ����ȯ��
            + FS // ����� �ݾ�
            + IfThen(AInfo.CancelReason in [1, 2, 3], IntToStr(AInfo.CancelReason), '0') + FS // ��һ����ڵ�
            + FS // ����ī�� ���� ����
            + FS // ��������ȭ����
            + FS // EMVī�� ����
            + FS // fallback
            + ADecrypt // ��ȣȭ ����
            + #255;// ��ȣȭ ����
end;

function TVanKFTC.MakeSendDataCheck(AInfo: TCheckSendInfo): AnsiString;
var
  SeqNo: AnsiString;
begin
            // ��ǥ�ݾ�
  Result := CurrToStr(AInfo.CheckAmt) + FS
            // �ڱ�� ��ǥ
            + '4' + FS
            // ��ǥ��ȣ(8)+�����ڵ�(2)+�����ڵ�(4)+�����ڵ�(2)+��������(6)+�����Ϸù�ȣ(14)
            + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + AInfo.KindCode + AInfo.RegDate + AInfo.AccountNo + FS;
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS + #255;
end;

function TVanKFTC.MakeSendDataCashIC(AInfo: TCardSendInfo; ARecvData: AnsiString; APayOn: Boolean): AnsiString;
var
  CardNo: AnsiString;
  SeqNo: AnsiString;
begin
  if APayOn then
    CardNo := Trim(ARecvData)
  else
    CardNo := Copy(ARecvData, 4, 16);
  SeqNo := GetSeqNo;
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;

  if APayOn then
    Result := 'P'
  else
    Result := '0';

  Result := Result +
            // ī���ȣ
            CardNo + FS +
            // �ݾ�
            FloatToStr(AInfo.SaleAmt) + FS +
            FS +
            FS +
            // �Һ�
            '00' + FS +
            // SEQ
            SeqNo + FS +
            // ���ŷ���
            IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS +
            // ���ŷ����ι�ȣ
            IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS +
            FS +
            FS +
            '0' + FS +
            FS +
            FS +
            FS +
            FS +
            FS +
            FS +
            // ������Ÿ
            ARecvData + FS +
            'YY00' +
            #255;
end;

function TVanKFTC.DLLExec(FCode: Integer; ASendData: AnsiString; out ARetCode: Integer; out ARecvData: AnsiString): Boolean;
var
  Exec: TKFTC_POS_TRANS;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ARecvData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltInfo, [KFTC_SIGN_DLL, 'ȣ��', IntToHex(FCode, 2), GetFuncName(FCode)]);
  Log.Write(ltInfo, ['��������', ASendData]);

  // ���� ��û�� �Ѵ�
  ARetCode := Exec(FCode, PAnsiChar(ASendData), @ARecvData[1]);
  Result := ARetCode = 0;

  Log.Write(ltInfo, ['�������� Code(0:����, �׿ܼ���:����)', ARetCode]);
  Log.Write(ltInfo, ['�������� RecvData', ARecvData]);
end;

function TVanKFTC.DLLExecSign: Boolean;
var
  CallPosSetPath: TKFTC_CallPosSetPath;
  CallSetKey: TKFTC_CallSetKey;
begin
  Result := False;

  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @CallPosSetPath := GetProcAddress(DLLHandle, 'CallPosSetPath');
  @CallSetKey     := GetProcAddress(DLLHandle, 'CallPosSetKey');
  if not Assigned(@CallPosSetPath) or not Assigned(@CallSetKey) then
  begin
    Log.Write(ltInfo, ['DLLExecSign �Լ� ����']);
    Exit;
  end;

  CallSetKey(13, 27, 8);
  CallPosSetPath(Global.HomeDir);
  Result := True;
end;

function TVanKFTC.DoStartProc(out AMsg: AnsiString): Boolean;
begin
  // �⺻�� ������ �Ǿ� ���� ������ �����Ѵ�.
//  if (not FInitRun) or Config.SecureModeInit then
//  begin
    ReadIni;
    Result := DoPosInit;
    if not Result then Exit;
    if Config.TerminalID = EmptyStr then
      Config.PosDownload := True;
    FInitRun := True;
//  end;
  // ������ �ٿ�ε带 ó���Ѵ�.
  if Config.PosDownload then
  begin
    Result := DoPosDownload;
    if Result then
    begin
      WriteIni;
      // ���ȸ�� ����̸� KeyDownload
      if Config.SecureMode then
      begin
        Result := DoKeyDownload;
        Exit;
      end;
    end
    else
    begin
      AMsg := '������ ������ �ٿ���� ���߽��ϴ�. ��� �Ŀ� �ٽ� �õ��ϼ���';
      Exit;
    end;
  end;
  Result := True;
end;

function TVanKFTC.DoPosInit: Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataInit;

  Log.Write(ltInfo, ['�⺻�� ���� ����', SendData]);
  Result := DLLExec($F0, SendData, RetCode, RecvData);

  if Result then
    Log.Write(ltInfo, ['�⺻�� ���� ����', RecvData])
  else
    Log.Write(ltError, ['�⺻�� ���� ����', GetErrorMsg(RetCode)]);
end;

function TVanKFTC.DoPosDownload: Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
  CardTID: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataPosDownload;

  Log.Write(ltInfo, ['������ �ٿ�ε� ����', SendData]);
  Result := DLLExec($F1, SendData, RetCode, RecvData);

  if Result then
  begin
    Log.Write(ltInfo, ['������ �ٿ�ε� ����', RetCode]);
    // ������ ó���Ѵ�.
    CardTID := StringSearch(RecvData, FS, 0);
    CardTID := StringReplace(CardTID, #255, '', [rfReplaceAll]);
    FWorkingKey := StringSearch(RecvData, FS, 1);
    Config.TerminalID := CardTID;
    //������ �ٿ�ε带 ���޾�����
    if CardTID = EmptyStr then
      Result := False;
  end
  else
  begin
    Result := False;
    Log.Write(ltInfo, ['������ �ٿ�ε� ����', GetErrorMsg(RetCode)]);
  end;
end;

function TVanKFTC.DoKeyDownload: Boolean;
var
  RetCode: Integer;
  RecvData: AnsiString;
  ResultCode, ModulID: AnsiString;
begin
  Log.Write(ltInfo, ['Key �ٿ�ε� ����', '']);
  Result := DLLExec($9B, '', RetCode, RecvData);

  if Result then
  begin
    Log.Write(ltInfo, ['Key �ٿ�ε� ����', RetCode]);
    // ������ ó���Ѵ�.
    ResultCode := StringSearch(RecvData, FS, 0);
    ResultCode := StringReplace(ResultCode, #255, '', [rfReplaceAll]);
    ModulID := StringSearch(RecvData, FS, 1);
    Result := ResultCode = '00';
  end
  else
  begin
    Result := False;
    Log.Write(ltInfo, ['Key �ٿ�ε� ����', RetCode]);
  end;
end;

function TVanKFTC.DoCardSign(ASaleAmt: Integer; out ASignData: AnsiString): Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  Result := False;
  SendData := IntToStr(ASaleAmt) + #28 + #28 + #255; // �ݾ�(9) + �޼���(64) + ���ǥ��(16)

  if not DLLExecSign then Exit;

  Log.Write(ltInfo, ['�������� ����', SendData]);
  Result := DLLExec($E8, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['�������� ����', RetCode]);

  if Result then
  begin
    if StrToIntDef(Copy(RecvData, 23, 4), 0) > 0 then
      ASignData := Trim(RecvData)
    else
    begin
      Result := False;
      ASignData := '���������� �Է� ���� ���߽��ϴ�.'#13#10 + 'Error=' + GetErrorMsg(RetCode);
    end;
  end;
end;

function TVanKFTC.DoPinPad(ACardNo: AnsiString; out APinData: AnsiString): Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  SendData := ACardNo + FS +
              FWorkingKey + #255;

  Log.Write(ltInfo, ['PinPad ����', '']);
  Result := DLLExec($E7, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad ����', RetCode]);

  if Result then
  begin
    APinData := Trim(RecvData);
  end
  else
    APinData := GetErrorMsg(RetCode);
end;

function TVanKFTC.DoPinPadIC(APinData: AnsiString; out APinDataIC: AnsiString): Boolean;
var
  RetCode: Integer;
  Code, SendData, RecvData: AnsiString;
begin
  Result := False;

  SendData := FWorkingKey + FS +
              APinData + #255;

  if DLLExec($98, SendData, RetCode, RecvData) then
  begin
    Code := StringSearch(RecvData, FS, 0);
    Result := Code = '00';
    if Result then
    begin
      APinDataIC := StringSearch(RecvData, FS, 1);
      APinDataIC := StringSearch(APinDataIC, #255, 0);
    end
    else
      APinDataIC := 'ó�� ����';
  end
  else
    APinDataIC := 'ó�� ����';
end;

function TVanKFTC.CallPosDownload: TPosDownloadRecvInfo;
begin
  Result.Result := False;
  ShowMessageForm('������ ������ Key �ٿ�ε� ���Դϴ�.'#13#10 + '��ø� ��ٷ� �ֽʽÿ�.');
  try
    // �⺻�� ������ �Ǿ� ���� ������ �����Ѵ�.
//    if (not FInitRun) or Config.SecureModeInit then
//    begin
      ReadIni;
      Result.Result := DoPosInit;
      if not Result.Result then Exit;
      FInitRun := True;
//    end;

    // ������ �ٿ�ε带 ó���Ѵ�.
    Result.Result := DoPosDownload;
    if Result.Result then
    begin
      WriteIni;
      // ���ȸ�� ����̸� KeyDownload�� �����Ѵ�.
      if Config.SecureMode then
      begin
        Result.Result := DoKeyDownload;
        if not Result.Result then
          Result.Msg := 'Key �ٿ�ε带 ���� �Ͽ����ϴ�.';
      end;
    end
    else
      Result.Msg := '������ ������ �ٿ���� ���߽��ϴ�. ��� �Ŀ� �ٽ� �õ��ϼ���';
  finally
    HideMessageForm;
  end;
end;

function TVanKFTC.DoCallCard(AInfo: TCardSendInfo): TCardRecvInfo;
var
  FCode: Integer;
  RetCode: Integer;
  SendData, RecvData: AnsiString;
  SignData: AnsiString;
begin
  if not DoStartProc(RecvData) then
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;
  // ������ �޴´�
  if Config.SignPad then
  begin
    Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
    if not Result.IsSignOK then
    begin
      Result.Result := False;
      Result.Msg := SignData;
      //if Application.MessageBox('���� �������� ó���Ͻðڽ��ϱ�?', 'Ȯ��', MB_YESNO) = ID_NO then
      if not ShowQuestionForm('���� �������� ó���Ͻðڽ��ϱ�?') then
        Exit;
    end;
  end;
  // ������ �����.
  SendData := MakeSendDataCard(AInfo, SignData, 0);
  FCode := IfThen(AInfo.Approval, $F2, $F3);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
  end;
end;

function TVanKFTC.DoCallCardICSecure(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
label
  AID_Re_Try;
var
  FCode, RetCode: Integer;
  SendData, RecvData: AnsiString;
  SignData, CardNo: AnsiString;
  AIDCount, SelectAIDIndex: Integer;
  AIDList, Decrypt, EncData, EmvData, FallBackCode, PinData, PinDataIC: AnsiString;
begin
  AIDCount := 0;
  SelectAIDIndex := 0;
  AIDList := '';
  Decrypt := '';
  SendData := '';
  RecvData := '';
  EncData := '';
  EmvData := '';
  FallBackCode := '';
  PinData := '';
  PinDataIC := '';

  // 1. �ʱ⼳��, ������ �ٿ�ε�, Ű�ٿ�ε带 ó���Ѵ�.
  try
    //���� ���� ��û �� ���� ó���� �ȵǴ� ���� �ذ��� ���� �ܸ��� �ʱ�ȭ
    //DoCallICReader(IC_READER_WORK_INIT, RecvData);

    ShowMessageForm('�ʱ⼳���� ó���ϴ� ���Դϴ�.'#13#10 + '(������ ���� �� Key �ٿ�ε�)');
    if not DoStartProc(RecvData) then
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;

    HideMessageForm;

    //û�ϰ���λ� ��û���� Ÿ�Ӿƿ� 1������ ������.
    ShowMessageForm('ī�带 IC ���Կ� ������ ��' + #13+#10 + '�ŷ��Ϸ� �ñ��� ��ٷ� �ֽʽÿ�.', False, 60);
    AID_Re_Try:
    // 2. IC �����⸦ ȣ���Ѵ�.
    SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // �ŷ��Ͻ�
                FormatFloat('000000000000000000', AInfo.SaleAmt) + FS + // �ŷ��ݾ�
                IntToStr(SelectAIDIndex) + // AID �ε���
                IfThen(AInfo.Approval, '', FS + IfThen(AEyCard, '1', '0')) + // PIN��� �Է¿���
                #255;
    FCode := IfThen(AInfo.Approval, $93, $94);
    if not DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      Result.Result := False;
      Result.Msg := 'ó�� ����';
      Exit;
    end;
    // ������ ������ ó���Ѵ�.
    Result := MakeRecvDataCardIC(RecvData, AIDCount, AIDList, Decrypt, EncData, EmvData);

    HideMessageForm;

    // 2.1 FallBack ó���� �Ѵ�.
    if Result.Code = '07' then
    begin
      if not ShowQuestionForm('[FallBack] IC ī�带 �ν����� ���߽��ϴ�. MSR ������� ó���Ͻðڽ��ϱ�?'#13#10 + '(ī�带 ������ �� [��]�� �����ʽÿ�.)') then
      begin
        Result.Result := False;
        Exit;
      end;

      ShowMessageForm('MSR�� ī�带 �νĽ��� �ֽʽÿ�.');
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // �ŷ��Ͻ�
                  IfThen(AEyCard, '1', '0') + // PIN��� �Է¿���
                  #255;
      if not DLLExec($95, SendData, RetCode, RecvData) then
      begin
        Result.Result := False;
        Result.Msg := 'ó�� ����';
        Exit;
      end;
      // ������ ������ ó���Ѵ�.
      Result := MakeRecvDataCardICFallBack(RecvData, FallBackCode, Decrypt, EncData, EmvData);
      Log.Write(ltInfo, ['FallBackCode', FallBackCode, 'Msg', GetErrorMsgFallBack(FallBackCode)]);
      Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    end
    else
      if not Result.Result then
        Exit;

    // 2.2 AID ���μ��� ó��
    if AIDCount > 1 then
    begin
      if not ShowAIDSelectForm(AIDCount, AIDList, SelectAIDIndex) then
      begin
        Result.Result := False;
        Exit;
      end;
      goto AID_Re_Try;
    end;

    HideMessageForm;

    // 3. ����ī���ΰ�� PIN �Է� ó��
    if AEyCard then
    begin
      ShowMessageForm('���е忡 ��й�ȣ�� �Է��Ͻʽÿ�.');
      CardNo := StringReplace(Result.ICCardNo, '*', 'F', [rfReplaceAll]);

      // �����е忡�� ��ȣ�� �Է� �޴´�.
      if not DoPinPad(CardNo, PinData) then
      begin
        Result.Result := False;
        Result.Msg := PinData;
        Exit;
      end;

      // IC�����⿡ PinData��û�Ѵ�.
      if not DoPinPadIC(PinData, PinDataIC) then
      begin
        Result.Result := False;
        Result.Msg := PinDataIC;
        Exit;
      end;
    end;

    HideMessageForm;

    // 4. ������ �޴´�.
//    if Config.SignPad and not AEyCard then
    if Config.SignPad then
    begin
      Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
      if not Result.IsSignOK then
      begin
        Result.Result := False;
        Result.Msg := SignData;
        //if Application.MessageBox('���� �������� ó���Ͻðڽ��ϱ�?', 'Ȯ��', MB_YESNO) = ID_NO then
        if not ShowQuestionForm('���� �������� ó���Ͻðڽ��ϱ�?') then
          Exit;
      end;
    end;

    // 5. VAN������ ����/��� ������ ������.
    ShowMessageForm('���� �ۼ��� ���Դϴ�. ��ø� ��ٷ� �ֽʽÿ�.', False, 30);
    SendData := MakeSendDataCardSecure(AInfo, IfThen(Result.IsSignOK, SignData, ''), Decrypt, EncData, EmvData, FallBackCode, PinDataIC);
    if AEyCard then
      FCode := IfThen(AInfo.Approval, $AE, $AF)
    else
      FCode := IfThen(AInfo.Approval, $AA, $AB);

    if DLLExec(FCode, SendData, RetCode, RecvData) then
      Result := MakeRecvDataCard(RecvData)
    else
    begin
      Result.Result := False;
      Result.Msg := GetErrorMsg(RetCode);
    end;
  finally
    HideMessageForm;

    // ���������� ���������� �ʱ�ȭ �Ѵ�.
    if (Length(SendData) > 0) then EraseMemory(SendData);
    if (Length(RecvData) > 0) then EraseMemory(RecvData);
    if (Length(EncData) > 0) then EraseMemory(EncData);

    // ������ ����� ������ �ʱ�ȭ
    //if not Result.Result then
    DoCallICReader(IC_READER_WORK_INIT, RecvData);
  end;
end;

function TVanKFTC.DoCallCardMSRSecure(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
var
  FCode, RetCode: Integer;
  SendData, RecvData: AnsiString;
  Code, SignData, CardNo: AnsiString;
  Decrypt, EncData, PinData, PinDataIC: AnsiString;
begin
  Decrypt := '';
  EncData := '';
  PinData := '';
  PinDataIC := '';

  // 1. �ʱ⼳��, ������ �ٿ�ε�, Ű�ٿ�ε带 ó���Ѵ�.
  ShowMessageForm('�ʱ⼳���� ó���ϴ� ���Դϴ�.'#13#10 + '(������ ���� �� Key �ٿ�ε�)');
  try
    if not DoStartProc(RecvData) then
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;

    if AInfo.KeyInput then
      ShowMessageForm('ó�� ���Դϴ�. �ŷ��Ϸ� �ñ��� ��ٷ� �ֽʽÿ�.')
    else
      ShowMessageForm('MSR�� ī�带 �νĽ�Ų ��' + #13+#10 + '�ŷ��Ϸ� �ñ��� ��ٷ� �ֽʽÿ�.');

    // 2. MSR �����⸦ ȣ���Ѵ�.
    if AInfo.KeyInput then
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // �ŷ��Ͻ�
                  AInfo.CardNo + #255                          // ī���ȣ
    else
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // �ŷ��Ͻ�
                  '1' + FS +                                   // ��ȣȭ ���� (0:��ȣȭ���� 1: ��ȣȭ��)
                  IfThen(AEyCard, '1', '0') +                  // PIN��� �Է¿���
                  #255;
    FCode := IfThen(AInfo.KeyInput, $97, $96);
    if DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      Code := StringSearch(RecvData, FS, 0);
      Result.Result := Code = '00';
      if Result.Result then
      begin
        RecvData := StringSearch(RecvData, #255, 0);
        Decrypt := StringSearch(RecvData, FS, 1);
        CardNo  := StringSearch(RecvData, FS, 2);
        Result.ICCardNo := StringSearch(CardNo, '=', 0);
        EncData := StringSearch(RecvData, FS, 3);
        FDualPayKey := StringSearch(RecvData, FS, 4);
      end
      else
      begin
        Result.Result := False;
        Result.Msg := GetErrorMsgIC(StrToIntDef(Code, -1));
        Exit;
      end;
    end
    else
    begin
      Result.Result := False;
      Result.Msg := 'ó�� ����';
      Exit
    end;

    // 3. ����ī���ΰ�� PIN �Է� ó��
    if AEyCard then
    begin
      ShowMessageForm('���е忡 ��й�ȣ�� �Է��Ͻʽÿ�.');
      CardNo := StringReplace(CardNo, '*', 'F', [rfReplaceAll]);

      // �����е忡�� ��ȣ�� �Է� �޴´�.
      if not DoPinPad(CardNo, PinData) then
      begin
        Result.Result := False;
        Result.Msg := PinData;
        Exit;
      end;
      // IC�����⿡ PinData��û�Ѵ�.
      if not DoPinPadIC(PinData, PinDataIC) then
      begin
        Result.Result := False;
        Result.Msg := PinDataIC;
        Exit;
      end;
    end;

    // 4. ������ �޴´�.
    if Config.SignPad then
    begin
      Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
      if not Result.IsSignOK then
      begin
        Result.Result := False;
        Result.Msg := SignData;
        //if Application.MessageBox('���� �������� ó���Ͻðڽ��ϱ�?', 'Ȯ��', MB_YESNO) = ID_NO then
        if not ShowQuestionForm('���� �������� ó���Ͻðڽ��ϱ�?') then
          Exit;
      end;
    end;

    ShowMessageForm('���� �ۼ��� ���Դϴ�. ��ø� ��ٷ� �ֽʽÿ�.', False, 30);
    // 4. VAN������ ����/��� ������ ������.
    SendData := MakeSendDataCardSecure(AInfo, IfThen(Result.IsSignOK, SignData, ''), Decrypt, EncData, '', '', PinDataIC);
    FCode := IfThen(AInfo.Approval, $AA, $AB);
    if DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      Result := MakeRecvDataCard(RecvData);
    end
    else
    begin
      Result.Result := False;
      Result.Msg := GetErrorMsg(RetCode);
    end;
  finally
    // ���������� ���������� �ʱ�ȭ �Ѵ�.
    FillChar(SendData[1], Length(SendData), 0);
    FillChar(RecvData[1], Length(RecvData), 0);
    // ������ ����� ������ �ʱ�ȭ
    if not Result.Result then
      DoCallICReader(IC_READER_WORK_INIT, RecvData);
    HideMessageForm;
  end;
end;

function TVanKFTC.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  if Config.SecureMode then
  begin
    // MSR�ŷ��� Ű�ΰŷ� �϶��� IC�ŷ��϶� �����Ͽ� ó���Ѵ�.
    if AInfo.MSRTrans or AInfo.KeyInput then
      Result := DoCallCardMSRSecure(False, AInfo)
    else
      Result := DoCallCardICSecure(False, AInfo);
  end
  else
    Result := DoCallCard(AInfo);
end;

function TVanKFTC.CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
var
  FCode, RetCode: Integer;
  SendData, RecvData: AnsiString;
  Decrypt, EncData: AnsiString;
begin
  Decrypt := '';
  EncData := '';
  if not DoStartProc(RecvData) then
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;

  if Config.SecureMode and AInfo.MSRTrans then
  begin
    if not CallMSR('2', AInfo.CardNo, Decrypt, EncData) then
    begin
      Result.Result := False;
      Result.Msg := 'MSR ���� ���� !!!';
      Exit;
    end;
  end;

  // ������ �����.
  if Config.SecureMode and (EncData <> '') then
    SendData := MakeSendDataCashSecure(AInfo, Decrypt, EncData)
  else
    SendData := MakeSendDataCash(AInfo);
  FCode := IfThen(AInfo.Approval, $E5, $E6);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCash(RecvData);
    if Config.SecureMode then
      Result.ICCardNo := StringSearch(AInfo.CardNo, '=', 0);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
  end;
end;

function TVanKFTC.CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  if not DoStartProc(RecvData) then
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;

  // ������ �����.
  SendData := MakeSendDataCheck(AInfo);

  if DLLExec($F8, SendData, RetCode, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
  end;
end;

function TVanKFTC.CallPinPad(out ARetData: AnsiString): Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  if not DoStartProc(RecvData) then
  begin
    Result := False;
    ARetData := RecvData;
    Exit;
  end;

  SendData := ''           + FS
              + FWorkingKey + FS
              + Char($32)  + FS
              + ''         + #255;

  Log.Write(ltInfo, ['PinPad ����', '']);
  Result := DLLExec($E9, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad ����', RetCode]);

  if Result then
    ARetData := StringSearch(RecvData, 'F', 0)
  else
    ARetData := GetErrorMsg(RetCode);
end;

procedure TVanKFTC.CallPinCancel;
var
  RetCode: Integer;
  RecvData: AnsiString;
begin
  DLLExec($B9, '', RetCode, RecvData);
end;

function TVanKFTC.CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  if Config.SecureMode then
  begin
    // MSR�ŷ��� Ű�ΰŷ� �϶��� IC�ŷ��϶� �����Ͽ� ó���Ѵ�.
    if AInfo.MSRTrans or AInfo.KeyInput then
      Result := DoCallCardMSRSecure(True, AInfo)
    else
      Result := DoCallCardICSecure(True, AInfo);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := '�ش� ��� �����Ǿ� ���� ����';
  end;
end;

function TVanKFTC.CallIC(APayAmt: Currency; AApproval: Boolean; out ACardNo,
  AEmvInfo: AnsiString): Boolean;
var
  Index: Integer;
  Exec: TKFTC_POS_TRANS;
  ASendData: AnsiString;
  DllHandle: THandle;
begin
  Result := False;

  if not DoStartProc(ACardNo) then
  begin
    Result := False;
    Exit;
  end;

  SetLenAndFill(ACardNo, 2048);

  DllHandle := LoadLibrary(KFTC_SIGN_DLL);
  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ACardNo := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := FormatFloat('000000000', APayAmt) + #255;

  Log.Write(ltDebug, ['CallIC ��������', ASendData]);

  // ���� ��û�� �Ѵ�
  Index := Exec(IfThen(AApproval, $d3, $d4), PAnsiChar(ASendData), @ACardNo[1]);
  if Index = 0 then
  begin
    AEmvInfo := StringSearch(ACardNo, #28, 0);
    ACardNo := StringSearch(ACardNo, #28, 1);
    if Length(AEmvInfo) < 3 then
      ACardNo := 'FALLBACK �߻�'
    else
      Result := True
  end
  else
    ACardNo := GetErrorMsg(Index);
end;

function TVanKFTC.SetTerminalAsync(AStart: Boolean; out ARetData: AnsiString; ACallbackMS, ACallbackIC: Pointer): Boolean;
var
  Index: Integer;
  Exec: TKFTC_POS_TRANS;
  SetMSCallback: TKFTC_SetMSCallback;
  SetICCallback: TKFTC_SetICCallback;
  ASendData: AnsiString;
  DllHandle: THandle;
begin
  Result := False;

  if not DoStartProc(ARetData) then
  begin
    Result := False;
    Exit;
  end;

  SetLenAndFill(ARetData, 2048);

  DllHandle := LoadLibrary(KFTC_SIGN_DLL);
  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  @SetMSCallback  := GetProcAddress(DLLHandle, 'SetMSCallback');
  @SetICCallback  := GetProcAddress(DLLHandle, 'SetICCallback');
  if not Assigned(@Exec) then
  begin
    ARetData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := EmptyStr;

  Log.Write(ltDebug, ['SetTerminalAsync ��������', ASendData]);

  // ���� ��û�� �Ѵ�
  Index := Exec(IfThen(AStart, $d5, $d6), PAnsiChar(ASendData), @ARetData[1]);
  if Index = 0 then
  begin
    if AStart then
    begin
      SetMSCallback(ACallbackMS);
      SetICCallback(ACallbackIC);
    end;
    Result := True;
  end;
end;

function TVanKFTC.CallCoupon(AUse: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
begin

end;

function TVanKFTC.CallRuleDownload: TRuleDownRecvInfo;
begin

end;

function TVanKFTC.CallMembership(AInfo: TMembershipSendInfo): TMembershipRecvInfo;
begin

end;

procedure TVanKFTC.EventMessageFormCancelClick(Sender: TObject);
var
  RecvData: AnsiString;
begin
  inherited;
  DoCallICReader(IC_READER_WORK_INIT, RecvData);
end;

function TVanKFTC.DoCallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
var
  FCode, RetCode: Integer;
  Code, SendData, RecvData: AnsiString;
begin
  Result := False;

  case AWorkGubun of
    IC_READER_WORK_INIT   : FCode := $90;
    IC_READER_WORK_STATUS, IC_READER_WORK_AUTH_KEY_HW : FCode := $91;
    IC_READER_WORK_VERIFY : FCode := $92;
    IC_READER_WORK_AUTH_KEY_SW :
      begin
        ARecvData := KTC_KEY_ZEUS;
        Result := True;
        Exit;
      end
  else
    FCode := 0;
  end;

  if AWorkGubun = IC_READER_WORK_VERIFY then
    ShowMessageForm('ICī�� �ܸ��� ���Ἲ �˻� ���Դϴ�.');

  try
    SendData := EmptyStr;
    if DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      if AWorkGubun = IC_READER_WORK_INIT then
        Code := StringSearch(RecvData, #255, 0)
      else
        Code := StringSearch(RecvData, FS, 0);
      Result := Code = '00';
      if Result then
      begin
        if AWorkGubun = IC_READER_WORK_STATUS then
        begin
          ARecvData := '�ܸ��� ��Ī: ' + StringSearch(RecvData, FS, 1) + #13+#10 +
                       '�ܸ��� ����: ' + StringSearch(RecvData, FS, 2) + #13+#10 +
                       '��� ID: ' + StringSearch(RecvData, FS, 3);
        end
        else if AWorkGubun = IC_READER_WORK_AUTH_KEY_HW then
          ARecvData := Trim(StringSearch(RecvData, FS, 1)) + Trim(StringSearch(RecvData, FS, 2))
        else if AWorkGubun = IC_READER_WORK_VERIFY then
        begin
          ARecvData := StringSearch(RecvData, FS, 1);
          ARecvData := StringSearch(ARecvData, #255, 0);
        end;
      end
      else
        ARecvData := GetErrorMsgIC(StrToIntDef(Code, -1));
    end
    else
      ARecvData := 'ó�� ����';
  finally
    HideMessageForm;
  end;
end;

procedure ICDetectEvnet(ARecvData: PAnsiChar); stdcall;
begin
  if Assigned(VanModul.OnICCallbackEvent) then
    VanModul.OnICCallbackEvent(ARecvData, '');
end;

function TVanKFTC.DoEventICDetectStart: Boolean;
var
  Exec: TSET_IC_DETECT;
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  Result := False;
  SetLenAndFill(RecvData, 2048);

  @Exec := GetProcAddress(DLLHandle, 'SET_IC_DETECT');
  if not Assigned(@Exec) then
  begin
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', 'SET_IC_DETECT�� ã���� �����ϴ�.']);
    Exit;
  end;

  RetCode := Exec(@ICDetectEvnet);
  if RetCode <> 1 then
  begin
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', '�ݹ� �Լ� ��� ����']);
    Exit;
  end;

  SendData := '';
  if DLLExec($99, SendData, RetCode, RecvData) then
    Result := Copy(RecvData, 1, 2) = '00';

  if Result then
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', ''])
  else
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', '']);
end;

function TVanKFTC.DoEventICDetectStop: Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  Result := False;
  SetLenAndFill(RecvData, 2048);
  SendData := '';
  if DLLExec($9A, SendData, RetCode, RecvData) then
    Result := Copy(RecvData, 1, 2) = '00';

  if Result then
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', ''])
  else
    Log.Write(ltDebug, ['���� �̺�Ʈ ��� ����', '']);
end;

function TVanKFTC.CallICReader(AWorkGubun: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;

  if not DoStartProc(ARecvData) then
    Exit;

  case AWorkGubun of
    IC_READER_WORK_EVENT_START :
      begin
        Result := DoEventICDetectStart;
        if not Result then
          ARecvData := 'IC ������ ���� �̺�Ʈ ��� ����';
      end;
    IC_READER_WORK_EVENT_STOP : Result := DoEventICDetectStop;
  else
    Result := DoCallICReader(AWorkGubun, ARecvData);
  end;
end;

function TVanKFTC.CallMSR(AGubun: AnsiString; out ACardNo, ADecrypt, AEncData: AnsiString): Boolean;
var
  RetCode: Integer;
  Code, SendData, RecvData: AnsiString;
begin
  Result := False;

  if not DoStartProc(ACardNo) then
  begin
    Result := False;
    Exit;
  end;

  ShowMessageForm('MSR�� ī�带 �νĽ��� �ֽʽÿ�.');
  try
    SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // �ŷ��Ͻ�
                AGubun + FS +                                // ��ȣȭ ���� (0:��ȣȭ���� 1: ��ȣȭ��(�ſ�ī�����ȭ��), 2:���ݿ���������ȭ��)
                '0' +                                        // PIN��� �Է¿���
                #255;
    if DLLExec($96, SendData, RetCode, RecvData) then
    begin
      Code := StringSearch(RecvData, FS, 0);
      Result := Code = '00';
      if Result then
      begin
        RecvData := StringSearch(RecvData, #255, 0);
        if AGubun = '2' then
        begin
          ADecrypt := StringSearch(RecvData, FS, 1);
          ACardNo  := StringSearch(RecvData, FS, 2);
          AEncData := StringSearch(RecvData, FS, 3);
        end
        else
          ACardNo := StringSearch(RecvData, FS, 2)
      end
      else
        ACardNo := GetErrorMsgIC(StrToIntDef(Code, -1));
    end
    else
      ACardNo := 'ó�� ����';
  finally
    HideMessageForm;
  end;
end;

function TVanKFTC.CallMS(APayAmt: Currency; out ACardNo: AnsiString): Boolean;
var
  Index: Integer;
  Exec: TKFTC_POS_TRANS;
  ASendData: AnsiString;
  DllHandle: THandle;
begin
  Result := False;

  if not DoStartProc(ACardNo) then
  begin
    Result := False;
    Exit;
  end;

  SetLenAndFill(ACardNo, 2048);

  DllHandle := LoadLibrary(KFTC_SIGN_DLL);
  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ACardNo := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := FormatFloat('000000000', APayAmt) + #255;

  Log.Write(ltDebug, ['CallMS ��������', ASendData]);

  // ���� ��û�� �Ѵ�
  Index := Exec($D1, PAnsiChar(ASendData), @ACardNo[1]);
  if Index = 0 then
    Result := True
  else
    ACardNo := GetErrorMsg(Index);
end;

function TVanKFTC.CallCashIC(AInfo: TCardSendInfo): TCardRecvInfo;
var
  FCode, RetCode: Integer;
  SendData, RecvData, SignData: AnsiString;
begin
  if not DoStartProc(RecvData) then
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;

  FCode := $A6;
  // ����4�� ���ٴ� 16Byte�� �����
  SendData := '0' + 'ī�带�����ϼ���'
                  + '�ݾ�            '
                  + FormatFloat('##############', AInfo.SaleAmt) + '��'
                  + '                ';
  if not DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
    Exit;
  end;
  AInfo.CardNo := Trim(RecvData);

  // ������ �����.
  FCode := IfThen(AInfo.Approval, $A0, $A1);
  SendData := MakeSendDataCard(AInfo, SignData, 1);
  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
  end;
end;

function TVanKFTC.CallPayOnReady(APayAmt: Currency; out ARecvData: AnsiString): Boolean;
var
  FCode, RetCode: Integer;
  SendData: AnsiString;
begin
  if not DoStartProc(ARecvData) then
  begin
    Result := False;
    Exit;
  end;

  FCode := $A6;
  // ����4�� ���ٴ� 16Byte�� �����
  SendData := '4' + 'ī�带 ���ּ��� '
                  + '�ݾ�            '
                  + FormatFloat('##############', APayAmt) + '��'
                  + '                ';
  Result := DLLExec(FCode, SendData, RetCode, ARecvData);
  if not Result then
    ARecvData := GetErrorMsg(RetCode);
end;

function TVanKFTC.CallPayOn(AInfo: TCardSendInfo): TCardRecvInfo;
var
  FCode, RetCode: Integer;
  SendData, RecvData, SignData: AnsiString;
begin
  // ������ �޴´�
  if Config.SignPad then
  begin
    Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
    if not Result.IsSignOK then
    begin
      Result.Result := False;
      Result.Msg := SignData;
      //if Application.MessageBox('���� �������� ó���Ͻðڽ��ϱ�?', 'Ȯ��', MB_YESNO) = ID_NO then
      if not ShowQuestionForm('���� �������� ó���Ͻðڽ��ϱ�?') then
        Exit;
    end;
  end;

  // ������ �����.
  SendData := MakeSendDataCard(AInfo, SignData, 2);
  FCode := IfThen(AInfo.Approval, $F2, $F3);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
  end;
end;

{ TVanCatKFTC }

constructor TVanCatKFTC.Create;
begin
  inherited;
  DLLHandle := LoadLibrary(KFTC_CONV_DLL);
  FComPort.OnRxChar := ComPort1RxChar;
  FUserCancel := False;

  if VanModul.SignPad then
  begin
    DLLHandle_Sign := LoadLibrary(KFTC_SIGN_DLL);
    FInitRun := False;
  end;
end;

destructor TVanCatKFTC.Destroy;
begin
  FreeLibrary(DLLHandle);
  if VanModul.SignPad then
    FreeLibrary(DLLHandle_Sign);
  inherited;
end;

function TVanCatKFTC.DoCodeConv(AGubun: Integer; ASrc: AnsiString): AnsiString;
var
  Exec: TCodeConv;
  ARecvData: AnsiString;
begin
  Result := ASrc;
  if ASrc = '' then Exit;

  SetLenAndFill(ARecvData, Length(ASrc));
  @Exec := GetProcAddress(DLLHandle, 'CodeConv');
  if not Assigned(@Exec) then
  begin
    Log.Write(ltInfo, ['�ѱ� �ڵ� ��ȯ', KFTC_CONV_DLL + MSG_ERR_DLL_LOAD]);
    Exit;
  end;
  Exec(AGubun, PAnsiChar(ASrc), @ARecvData[1]);
  Result := ARecvData;
end;

procedure TVanCatKFTC.ComPort1RxChar(Sender: TObject; Count: Integer);
var
  Index: Integer;
  Buff: AnsiString;
begin
  SetLength(Buff, Count);
  FComPort.Read(Buff[1], Count);

  FReadBuff := FReadBuff + Buff;
  Log.Write(ltDebug, ['���� �޼���', Buff, 'ReadBuff', FReadBuff]);

  if Copy(FReadBuff, 1, 1) = ENQ then
  begin
    FReadBuff := '';
    FComPort.WriteStr(ACK);
    Log.Write(ltDebug, ['ACK ����', '']);
  end
  else if Copy(FReadBuff, 1, 1) = ACK then
  begin
    FReadBuff := '';
//    FComPort.WriteStr(EOT);  // EOT ���� (2016.1.19)
    Log.Write(ltDebug, ['ACK ����', '']);
  end
  else if Copy(FReadBuff, 1, 1) = NAK then
  begin
    FReadBuff := '';
    FComPort.WriteStr(EOT);
    Log.Write(ltDebug, ['EOT ����', '']);
  end else if Copy(FReadBuff, 1, 1) = STX then
  begin
    Index := Pos(ETX, FReadBuff);
    if Index > 0 then
    begin
      FRecvData := FReadBuff;
      FReadBuff := '';
    end;
    Index := Pos(EOT, FReadBuff);
    if Index > 0 then
    begin
      FRecvData := FReadBuff;
      FReadBuff := '';
    end;
    FComPort.WriteStr(ACK);
    Log.Write(ltDebug, ['ACK ����', ACK]);
  end;
end;

procedure TVanCatKFTC.EventMessageFormCancelClick(Sender: TObject);
begin
  inherited;
  FUserCancel := True;
end;

function TVanCatKFTC.ExecSendData(ASendData: AnsiString): Boolean;
var
  Index: Integer;
  GetTime: Cardinal;
begin
  Result := False;
  FReadBuff := '';
  FRecvData := '';
  ASendData := ASendData + ETX;
  ASendData := STX + ASendData + GetLRC(ASendData);
  Log.Write(ltDebug, ['��������', ASendData]);
  FComPort.Write(ASendData[1], Length(ASendData));
  // ���� ó��
  GetTime := GetTickCount;
  while GetTime + (60 * 1000) > GetTickCount do // ������ 60��
  begin
    Application.ProcessMessages;
    if Length(FRecvData) > 0 then
    begin
      Result := True;
      Exit;
    end;
    if FUserCancel then
    begin
      FUserCancel := False;
      Exit;
    end;
  end;
end;

function TVanCatKFTC.ComPortOpen: Boolean;
begin
  Result := True;
  if not FComPort.Connected then
  begin
    FComPort.Port := 'COM' + IntToStr(Config.MSRPort);
    FComPort.BaudRate := br115200;
    FComPort.Open;
    Result := FComPort.Connected;
  end;
end;

function TVanCatKFTC.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
var
  SendData, RecvData: AnsiString;
  Gubun: AnsiString;
begin
  Result.Result := False;
  if not ComPortOpen then
  begin
    Result.Result := False;
    Result.Msg := 'ComPort Open ����! [' + FComPort.Port + ']';
    Exit;
  end;

  ShowMessageForm('ī�带 �ܸ��� IC���Կ� ������ ��' + #13+#10 + '�ŷ��Ϸ� �ñ��� ��ٷ� �ֽʽÿ�.', True);
  try
    // ������ �����.
    if Config.SignPad then
      Gubun := IfThen(AInfo.Approval, '11', '15')
    else
      Gubun := IfThen(AInfo.Approval, '10', '14');
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    if AInfo.Approval then
      SendData := Gubun + FS +
                  'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS +
                  'D' + FS + 'P' + FS + 'R' + FS +
                  'S' + CurrToStr(AInfo.VatAmt) + FS +
                  'T' + CurrToStr(AInfo.SvcAmt) + FS +
                  'b' + FS + 'h' + FS +
                  'j' + FormatFloat('00', AInfo.HalbuMonth) + FS +
                  'k' + FS + 'q' + FS + 'x'
    else
      SendData := Gubun + FS +
                  'B' + CurrToStr(AInfo.SaleAmt) + FS +
                  'D' + FS + 'P' + FS +
                  'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS +
                  'R' + FS +
                  'Y' + FS +
                  'a' + AInfo.OrgAgreeNo + FS +
                  'b' + FS + 'h' + FS +
                  'j' + FormatFloat('00', AInfo.HalbuMonth) + FS +
                  'q' + FS + 'x';

    ExecSendData(SendData);
    Log.Write(ltDebug, ['���� ����Ÿ', FRecvData]);
    // ���������� �����.
    // �����ڵ�
    Result.Code := StringSearch(FRecvData, FS, 0);
    Result.Code := Copy(Result.Code, 16, 3);
    // ����޼���
    Result.Msg := Copy(Trim(StringSearch(FRecvData, FS, 7)), 2, MAXBYTE);
    Result.Msg := DoCodeConv(0, Result.Msg);
    // ���ι�ȣ
    Result.AgreeNo := Copy(StringSearch(FRecvData, FS, 5), 2, MAXBYTE);
    // �ŷ���ȣ
    Result.TransNo := Copy(StringSearch(FRecvData, FS, 8), 2, MAXBYTE);
    // �ŷ��Ͻ�
    Result.TransDateTime := '20' + Copy(StringSearch(FRecvData, FS, 0), 4, 12);
    // �߱޻��ڵ�
    Result.BalgupsaCode := '';
    if AInfo.Approval then
    begin
      // �߱޻��
      Result.BalgupsaName := Copy(StringSearch(FRecvData, FS, 10), 2, MAXBYTE);
      Result.BalgupsaName := DoCodeConv(0, Result.BalgupsaName);
      // ī���ȣ
      Result.ICCardNo := StringReplace(Copy(Trim(StringSearch(FRecvData, FS, 11)), 2, MAXBYTE), ';', '', [rfReplaceAll]);
      // ���Ի��ڵ�
      Result.CompCode := Copy(StringSearch(FRecvData, FS, 12), 2, MAXBYTE);
      // ���Ի��
      Result.CompName := Copy(Trim(StringSearch(FRecvData, FS, 13)), 2, MAXBYTE);
      Result.CompName := DoCodeConv(0, Result.CompName);
    end
    else
    begin
      // �߱޻��
      Result.BalgupsaName := Copy(StringSearch(FRecvData, FS, 9), 2, MAXBYTE);
      Result.BalgupsaName := DoCodeConv(0, Result.BalgupsaName);
      // ī���ȣ
      Result.ICCardNo := StringReplace(Copy(Trim(StringSearch(FRecvData, FS, 10)), 2, MAXBYTE), ';', '', [rfReplaceAll]);
      // ���Ի��ڵ�
      Result.CompCode := Copy(StringSearch(FRecvData, FS, 11), 2, MAXBYTE);
      // ���Ի��
      Result.CompName := Copy(Trim(StringSearch(FRecvData, FS, 12)), 2, MAXBYTE);
      Result.CompName := DoCodeConv(0, Result.CompName);
    end;
    // ��������ȣ
    Result.KamaengNo := Copy(StringSearch(FRecvData, FS, 6), 2, MAXBYTE);
    // ���αݾ�
    Result.AgreeAmt := StrToIntDef(Copy(StringSearch(FRecvData, FS, 1), 2, MAXBYTE), 0);
    // ���αݾ� (���������� ����)
    Result.DCAmt := 0;
    // ��������
    Result.Result := Result.Code = '000';
    Delay(2000);
  finally
    HideMessageForm;
    FComPort.Close;
  end;
end;

function TVanCatKFTC.CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
var
  SendData, RecvData: AnsiString;
  Gubun: AnsiString;
begin
  Result.Result := False;
  if not ComPortOpen then
  begin
    Result.Result := False;
    Result.Msg := 'ComPort Open ����! [' + FComPort.Port + ']';
    Exit;
  end;

  ShowMessageForm('�ܸ��⿡ �޴���/�ֹι�ȣ�� �Է��ϰų�, ī�带 �νĽ��� �ֽʽÿ�!', True);
  try
    // ������ �����.
    if AInfo.Person then
      Gubun := IfThen(AInfo.Approval, '26', '28')
    else
      Gubun := IfThen(AInfo.Approval, '27', '29');
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    if AInfo.Approval then
      SendData := Gubun + FS +
                  'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS +
                  'D' + FS + 'P' + FS + 'R' + FS +
                  'S' + CurrToStr(AInfo.VatAmt) + FS +
                  'T' + CurrToStr(AInfo.SvcAmt) + FS +
                  'b' + FS + 'h' + FS +
                  'j' + FS +
                  'k' + FS + 'q' + FS + 'x'
    else
      SendData := Gubun + FS +
                  'B' + CurrToStr(AInfo.SaleAmt) + FS +
                  'D' + FS + 'P' + FS +
                  'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS +
                  'R' + FS +
                  'Y' + FS +
                  'a' + AInfo.OrgAgreeNo + FS +
                  'b' + FS + 'h' + FS +
                  'j' + FS +
                  'q' + FS + 'x';

    ExecSendData(SendData);
    Log.Write(ltDebug, ['���� ����Ÿ', FRecvData]);
    // ���������� �����.
    // �����ڵ�
    Result.Code := StringSearch(FRecvData, FS, 0);
    Result.Code := Copy(Result.Code, 16, 3);
    // ����޼���
    Result.Msg := Copy(Trim(StringSearch(FRecvData, FS, 7)), 2, MAXBYTE);
    Result.Msg := DoCodeConv(0, Result.Msg);
    // ���ι�ȣ
    Result. AgreeNo := Copy(StringSearch(FRecvData, FS, 5), 2, MAXBYTE);
    // �ŷ��Ͻ�
    Result.TransDateTime := '20' + Copy(StringSearch(FRecvData, FS, 0), 4, 12);
    // ī���ȣ
    Result.ICCardNo := Copy(Trim(StringSearch(FRecvData, FS, 11)), 2, MAXBYTE);
    // ��������
    Result.Result := Result.Code = '000';
    Delay(2000);
  finally
    HideMessageForm;
    FComPort.Close;
  end;
end;

function TVanCatKFTC.CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result.Result := False;
end;

function TVanCatKFTC.PrintOut(APrintData: AnsiString): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  if not ComPortOpen then
  begin
    Result := False;
    Log.Write(ltInfo, ['ComPort Open ����!', FComPort.Port]);
    Exit;
  end;
  try
    // ������ �����.
    APrintData := ReceiptReplaceString(vctKFTC, APrintData);
    APrintData := StringReplace(APrintData, #13#10, #10, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, #13, #10, [rfReplaceAll]);
//    SendData := '64' + FS + APrintData;
    APrintData := APrintData + ETX;
//    APrintData := STX + APrintData + GetLRC(APrintData);
    Log.Write(ltDebug, ['��������', APrintData]);
    FComPort.Write(APrintData[1], Length(APrintData));
//    ExecSendData(SendData);
    Log.Write(ltDebug, ['���� ����Ÿ', FRecvData]);
    Result := True;
  finally
    FComPort.Close;
  end;
end;

function TVanCatKFTC.CashDrawOpen: Boolean;
var
  ASendData: string;
begin
  try
    try
      if not ComPortOpen then
      begin
        Result := False;
        Log.Write(ltInfo, ['TVanCatKFTC.CashDrawOpen ComPort Open ����!', FComPort.Port]);
        Exit;
      end;
      ASendData := #27'p'#0#25#250#13#10;
      FComPort.WriteStr(ASendData);
    except
      on E: Exception do
      begin
        Log.Write(ltDebug, ['TVanCatKFTC.CashDrawOpen', e.Message]);
      end;
    end;
  finally
      FComPort.Close;
  end;
end;

function TVanCatKFTC.CallPinPad(out ARetData: AnsiString): Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  if not DoStartProc(RecvData) then
  begin
    Result := False;
    ARetData := RecvData;
    Exit;
  end;
  SendData := ''           + FS
              + FWorkingKey + FS
              + Char($32)  + FS
              + ''         + #255;

  Log.Write(ltInfo, ['PinPad ����', '']);
  Result := DLLExec($E9, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad ����', RetCode]);

  if Result then
    ARetData := StringSearch(RecvData, 'F', 0)
  else
    ARetData := GetErrorMsg(RetCode);
end;

function TVanCatKFTC.DLLExec(FCode: Integer; ASendData: AnsiString; out ARetCode: Integer; out ARecvData: AnsiString): Boolean;
var
  Exec: TKFTC_POS_TRANS;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);
  // DLL ���Ͽ��� ���� ��û �Լ��� �ҷ��´�
  @Exec := GetProcAddress(DLLHandle_Sign, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ARecvData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // ���� ��û�� �Ѵ�
  ARetCode := Exec(FCode, PAnsiChar(ASendData), @ARecvData[1]);
  Result := ARetCode = 0;

  Log.Write(ltInfo, ['�������� Code(0:����, �׿ܼ���:����)', ARetCode]);
  Log.Write(ltDebug, ['�������� RecvData', ARecvData]);
end;

function TVanCatKFTC.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    1 : Result := 'Transaction Time out';
    2 : Result := '���뼱 ���� �� ��';
    3 : Result := '��� ����(������ ����)';
    4 : Result := 'ȸ�� ��� (TCP/IP)';
    5 : Result := 'EOT �� ���� ( �Ϲ������� �߻����� ���� )';
    6 : Result := '�ΰ� ��� ��� ���� Ȯ��';
    7 : Result := 'Pinpad �Է� �� ��ǥ ��ȸ�� Reading Time out';
    8 : Result := 'ȸ�� ���(PORT Open Error)';
    9 : Result := '��ġ ���� �ȵ�';
    10: Result := '��ġ ������ ����';
    11: Result := '������ ���� ����';
    12: Result := '������������Error(DLE����)';
    13: Result := '�����е忡�� �����ư�� ����';
    15: Result := '�Ϲ� ���������� ĳ���� �ŷ� ��û �� ����';
    19: Result := '���ε���Ÿ Error';
    20: Result := '�����е� com port open ����';
    21: Result := '���е� �ʱ�ȭ ����';
    23: Result := '���� ���� ����';
  else
    Result := '�˼� ���� ����';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanCatKFTC.DoStartProc(out AMsg: AnsiString): Boolean;
begin
  // �⺻�� ������ �Ǿ� ���� ������ �����Ѵ�.
  if not FInitRun then
  begin
    ReadIni;
    Result := DoPosInit;
    if not Result then Exit;
    if Config.TerminalID = EmptyStr then
      Config.PosDownload := True;
    FInitRun := True;
  end;
  Result := True;
end;

procedure TVanCatKFTC.ReadIni;
var
  AWKey: AnsiString;
begin
  with TIniFile.Create(Global.HomeDir + 'kftc.ini') do
    try
      Config.TerminalID := ReadString('POS', 'TerminalID', '');
      AWKey := ReadString('POS', 'WorkingKey', '');
      if Config.SecureMode and (AWKey <> '') then
        FWorkingKey := DecryptAria(CRYPT_KEY, AWKey)
      else
        FWorkingKey := AWKey;
    finally
      Free;
    end;
end;

function TVanCatKFTC.DoPosInit: Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataInit;

  Log.Write(ltInfo, ['�⺻�� ���� ����', SendData]);
  Result := DLLExec($F0, SendData, RetCode, RecvData);

  if Result then
    Log.Write(ltInfo, ['�⺻�� ���� ����', RecvData])
  else
    Log.Write(ltError, ['�⺻�� ���� ����', GetErrorMsg(RetCode)]);
end;

function TVanCatKFTC.MakeSendDataInit: AnsiString;
var
  SignPadRate: string;
begin
  if Config.SignRate = 115200 then
    SignPadRate := '1152000000000'
  else
    SignPadRate := '0576000000000';
  Result := '0' + FS +      // Mode
            '0' + FS +      // TCP/IP
            IfThen(Config.RealMode, '8002', IntToStr(Config.HostPort)) + FS +
            IfThen(Config.RealMode, 'www.kftcvan.or.kr', Config.HostIP) + FS +
            'test01' + FS +
            'test01' + FS;
            // ó���ŷ��̸� �ʱ⼳������ ������������ �ٿ�޴´�
  Result := Result + IfThen(Config.TerminalID = EmptyStr, Config.SerialNo, Config.TerminalID) + FS +
            '0000' + FS +       // ����(#50:���, #51:������)
            '1200' + FS +       // �����
            '15'   + FS +       // ������(15��)
            '05'   + FS +       // ENQ ���ð�
            '03'   + FS +       // EOT ���ð�
            IfThen(Config.SignPad, IntToStr(Config.SignPort) + SignPadRate, '00000000000000') + FS + // �ΰ���񱸺� Pinpad ��Ʈ(1)
            '0' + FS +          // OCB ����(����������)
            '0' + FS +          // ����Ʈ����
            IfThen(Config.HWSecure, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +     // �ܸ�����Ʈ �� �ӵ� ����
            Config.ProgramCode + FS + // ���α׷� ������
            Config.ProgramVersion + FS + // ���α׷� ����
            IfThen(Config.RealMode, '8002', IntToStr(Config.HostPort)) + FS +  // LAN IP
            IfThen(Config.RealMode, 'www.kftcvan.or.kr', Config.HostIP) + FS + // LAN PORT
            IfThen(Config.SecureMode, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +   // IC������ ��Ʈ �� �ӵ�
            KTC_KEY_ZEUS + // �ܸ��� ������ȣ
            #255;
end;

procedure TVanCatKFTC.CallPinCancel;
var
  RetCode: Integer;
  RecvData: AnsiString;
begin
  if not DoStartProc(RecvData) then
    Exit;
  DLLExec($B9, '', RetCode, RecvData);
end;

{ TVanKFTCDaemon }

constructor TVanKFTCDaemon.Create;
begin

end;

destructor TVanKFTCDaemon.Destroy;
begin

  inherited;
end;

function TVanKFTCDaemon.ExecTcpSendData(ASendData: string; out ARecvData: string): Boolean;
var
  IdTCPClient: TIdTCPClient;
  ALrc: AnsiChar;
begin
  Result := False;
  IdTCPClient := TIdTCPClient.Create(nil);

  ALrc := GetLRC(ASendData + ETX);
  ASendData := STX + ASendData + ETX + ALrc;
  try
    {$IF RTLVersion > 19.00}
    try
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 8002;
      IdTCPClient.ConnectTimeout := 3000;
      IdTCPClient.Connect;
      if IdTCPClient.Connected then
      begin
        Log.Write(ltDebug, ['��������', ASendData]);
        IdTCPClient.IOHandler.WriteLn(ASendData, IndyTextEncoding_OSDefault);
        ARecvData := IdTCPClient.IOHandler.ReadLn(ETX, IndyTextEncoding_OSDefault);
        Log.Write(ltDebug, ['��������', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '���� ���� ����!!!';
    except on E: Exception do
      ARecvData := '������ ����� ���� �߻� ' + E.Message;
    end;
    {$ELSE}
    try
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 8002;
      IdTCPClient.Connect(3000);
      if IdTCPClient.Connected then
      begin
        Log.Write(ltDebug, ['��������', ASendData]);
        IdTCPClient.WriteLn(ASendData);
        ARecvData := IdTCPClient.ReadLn(ETX);
        Log.Write(ltDebug, ['��������', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '���� ���� ����!!!';
    except on E: Exception do
      ARecvData := '������ ����� ���� �߻� ' + E.Message;
    end;
    {$IFEND}
  finally
    IdTCPClient.Free;
  end;
end;

function TVanKFTCDaemon.GetStringSearch(AFID: string; AStr: string): string;
var
  Index: Integer;
begin
  Result := '';
  // �� �ڿ� FS�� ���� ������ �߰��Ѵ�.
  AStr := AStr + FS;
  Index := Pos(FS, AStr);
  while Index > 0 do
  begin
    if AFID = Copy(AStr, 1, 1) then
    begin
      Result := Copy(AStr, 2, Index - 2);
      Exit;
    end;
    AStr := Copy(AStr, Index + 1, MAXWORD);
    Index := Pos(FS, AStr);
  end;
end;

function TVanKFTCDaemon.DoCallCard(AEyCard: Boolean; AInfo: TCardSendInfo): TCardRecvInfo;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr: string;
begin
  Result.Result := False;

  // ���� ����Ÿ�� �����.
  if AEyCard then
    Gubun := IfThen(AInfo.Approval, 'C1', 'C2')
  else
  begin
    if Config.SignPad then
      Gubun := IfThen(AInfo.Approval, 'A1', 'A5')
    else
      Gubun := IfThen(AInfo.Approval, 'A0', 'A4');
  end;
  if AInfo.CardNo <> '' then
    CardNo := IfThen(AInfo.KeyInput, 'M', ';') + AInfo.CardNo
  else
    CardNo := '';

  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    SendData := Gubun + FS + // ��������
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // �ŷ��ݾ�
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // �ΰ���
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // �����
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // �Һΰ���
                'k' + FS +
                'q' + CardNo + FS + // �ſ�ī�� �Ǵ� ���ݿ����� ��ȣ
                'x'
  else
    SendData := Gubun + FS + // ��������
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // �ŷ��ݾ�
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // ����������
                'R' + FS + 'Y' + FS +
                'a' + AInfo.OrgAgreeNo + FS + // �����ι�ȣ
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // �Һΰ���
                'q' + CardNo + FS + // �ſ�ī�� �Ǵ� ���ݿ����� ��ȣ
                'x';

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // ���� ����Ÿ�� �����.
  TempStr := StringSearch(RecvData, FS, 0);
  // �����ڵ�
  Result.Code := Copy(TempStr, 16, 3);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // ����޼���
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // ���ι�ȣ
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // �ŷ���ȣ
  Result.TransNo := GetStringSearch('h', RecvData);
  // �߱޻��ڵ�
  Result.BalgupsaCode := GetStringSearch('u', RecvData);
  // �߱޻��
  Result.BalgupsaName := GetStringSearch('p', RecvData);
  // ���Ի��ڵ�
  Result.CompCode := GetStringSearch('t', RecvData);
  // ���Ի��
  Result.CompName := GetStringSearch('v', RecvData);
  // ī���ȣ
  Result.ICCardNo := GetStringSearch('q', RecvData);
  Result.ICCardNo := Copy(Result.ICCardNo, 1, 6); //ī�� �� Bin �κи� �����Ѵ�.
  // ��������ȣ
  Result.KamaengNo := GetStringSearch('d', RecvData);
  // ���αݾ�
  Result.AgreeAmt := StrToIntDef(GetStringSearch('B', RecvData), 0);
  // ���αݾ� (���������� ����)
  Result.DCAmt := 0;
  // ���� ����Ÿ
  Result.SignData := GetStringSearch('z', RecvData);
  Result.SignLength := Length(Result.SignData);
  Result.IsSignOK := Result.SignLength > 0;
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result := DoCallCard(False, AInfo);
end;

function TVanKFTCDaemon.CallCash(AInfo: TCashSendInfo): TCashRecvInfo;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr: string;
begin
  Result.Result := False;

  // ���� ����Ÿ�� �����.
  if AInfo.Person then
    Gubun := IfThen(AInfo.Approval, 'B6', 'B8')
  else
    Gubun := IfThen(AInfo.Approval, 'B7', 'B9');
  if AInfo.CardNo <> '' then
    CardNo := IfThen(AInfo.KeyInput, 'M', ';') + AInfo.CardNo
  else
    CardNo := '';

  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    SendData := Gubun + FS + // ��������
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // �ŷ��ݾ�
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // �ΰ���
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // �����
                'b' + FS + 'h' + FS + 'j' + FS + 'k' + FS +
                'q' + CardNo + FS + // �ſ�ī�� �Ǵ� ���ݿ����� ��ȣ
                'x'
  else
    SendData := Gubun + FS + // ��������
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // �ŷ��ݾ�
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // ����������
                'R' + FS +
                'Y' + IntToStr(AInfo.CancelReason) + FS + // ���ݿ����� ��һ���
                'a' + AInfo.OrgAgreeNo + FS + // �����ι�ȣ
                'b' + FS + 'h' + FS + 'j' + FS +
                'q' + CardNo + FS + // �ſ�ī�� �Ǵ� ���ݿ����� ��ȣ
                'x';

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // ���� ����Ÿ�� �����.
  TempStr := StringSearch(RecvData, FS, 0);
  // �����ڵ�
  Result.Code := Copy(TempStr, 16, 3);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // ����޼���
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // ���ι�ȣ
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // ī���ȣ
  Result.ICCardNo := GetStringSearch('q', RecvData);
  Result.ICCardNo := Copy(Result.ICCardNo, 1, 6); //ī�� �� Bin �κи� �����Ѵ�.
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
var
  SendData, RecvData, TempStr: string;
begin
  Result.Result := False;
  // ���� ����Ÿ�� �����.
  SendData := 'I0' + FS + // ��������
              'B' + CurrToStr(AInfo.CheckAmt) + FS + // ��ǥ�ݾ�
              'L' + '4' + FS + // ��ǥ���� (4:�ڱ�ռ�ǥ 5: �����ǥ)
              // ��ǥ��ȣ(8)+�����ڵ�(2)+�����ڵ�(4)+�����ڵ�(2)+��������(6)+�����Ϸù�ȣ(6)
              'N' + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + AInfo.KindCode + AInfo.RegDate + AInfo.AccountNo + FS +
              'h' + '' ; // �Ϸù�ȣ

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // ���� ����Ÿ�� �����.
  TempStr := StringSearch(RecvData, FS, 0);
  // �����ڵ�
  Result.Code := Copy(TempStr, 16, 3);
  // �ŷ��Ͻ�
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // ����޼���
  Result.Msg := GetStringSearch('g', RecvData);
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallEyCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  Result := DoCallCard(True, AInfo);
end;

function TVanKFTCDaemon.CallICReader(AWorkGubun: Integer;
  out ARecvData: AnsiString): Boolean;
var
  RecvData, TempStr: string;
begin
  Result := False;
  case AWorkGubun of
    IC_READER_WORK_STATUS :
      begin
        if not ExecTcpSendData('R1', RecvData) then
        begin
          ARecvData := RecvData;
          Exit;
        end;
        // ���� ����Ÿ�� �����.
        TempStr := StringSearch(RecvData, FS, 0);
        // ��������
        Result := Copy(TempStr, 16, 3) = 'S00';
        // ����޼���
        ARecvData := GetStringSearch('g', RecvData);
      end;
  end;
end;

function TVanKFTCDaemon.CallPinPad(out ARetData: AnsiString): Boolean;
begin
  Result := False;
  ARetData := '�ش� ��� �������� ����';
end;

end.
