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
    // 기본값 설정 실행 여부
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
    // 한글 조합형 <-> 완성형변환(0:조합형 -> 완성형, 1:완성형 -> 조합형)
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

  // 한글 조합형 <-> 완성형변환(조합형 -> 완성형 : 0, 완성형 -> 조합형 : 1)
  TCodeConv = function(ConvType: Integer; SrcString: PAnsiChar; DestString: PAnsiChar): Integer; stdcall;

const
  KFTC_SIGN_DLL = 'kftcpos.dll';
  KFTC_INI      = 'ktfcpos.ini';
  KFTC_CONV_DLL = 'KsUnion.dll';

  CRYPT_KEY     = 'KFTC_L_KEY_001'; // ini파일에 저장되는 WorkingKey를 암호화 하기 위한 Key
  //KTC_KEY_ZEUS  = 'DUALPAY_633CP101#####ZEUSPOS1001'; // IC보안 KTC 인증키 (제우스용)
  KTC_KEY_ZEUS  = '#####ZEUSPOS1001'; // IC보안 KTC 인증키 (제우스용)

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
    2 : Result := '전용선 연결 안 됨';
    3 : Result := '통신 에러(데이터 오류)';
    4 : Result := '회선 장애 (TCP/IP)';
    5 : Result := 'EOT 미 수신 ( 일반적으로 발생하지 않음 )';
    6 : Result := '부가 장비 사용 여부 확인';
    7 : Result := 'Pinpad 입력 및 수표 조회기 Reading Time out';
    8 : Result := '회선 장애(PORT Open Error)';
    9 : Result := '장치 연결 안됨';
    10: Result := '장치 데이터 오류';
    11: Result := '데이터 포맷 에러';
    12: Result := '응답전문수신Error(DLE수신)';
    13: Result := '서명패드에서 종료버튼을 누름';
    15: Result := '일반 가맹점에서 캐쉬백 거래 요청 시 에러';
    19: Result := '싸인데이타 Error';
    20: Result := '싸인패드 com port open 실패';
    21: Result := '핀패드 초기화 성공';
    23: Result := '이차 검증 실패';
  else
    Result := '알수 없는 에러';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanKFTC.GetErrorMsgIC(ACode: Integer): AnsiString;
begin
  case ACode of
    0 : Result := '리더기 상태 정상';
    1 : Result := '리더기 무결성 오류(Integrity Check Error)';
    2 : Result := 'Reader Error(IC카드를 넣어주세요)';
    3 : Result := 'IC Error';
    4 : Result := '금액 요청 Reader';
    5 : Result := '금액 요청 IC';
    6 : Result := 'IC 거래 불가';
    7 : Result := 'Fallback';
    8 : Result := 'IC 카드 삽입되어 있음';
    9 : Result := '상황에 맞지 않는 명령';
    10: Result := '상호인증오류';
    11: Result := '암호화/복호화 오류';
    12: Result := 'MS거래 불가 IC카드로 진행 바랍니다. IC 카드를 넣어주세요(2xx, 6xx)';
    13: Result := '리더기 KEY 다운로드 요망';
  else
    Result := '알수 없는 에러';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanKFTC.GetErrorMsgFallBack(ACode: string): AnsiString;
begin
  case StrToIntDef(ACode, -1) of
    1 : Result := 'Chip 전원을 넣었으나 응답이 없는 경우';
    2 : Result := '상호지원 application이 없는 경우';
    3 : Result := '칩 데이터 읽기 실패 (중간에 제거)';
    4 : Result := '필수 데이터 미포함';
    5 : Result := 'CVM 커맨드 응답 실패';
    6 : Result := '잘못된 EMV 커맨드';
    7 : Result := '터미널 오작동';
  else
    Result := '알수 없는 에러';
  end;
  Result := Result + ' [' + ACode + ']';
end;

function TVanKFTC.GetFuncName(AFCode: Integer): string;
begin
  case AFCode of
    $F0 : Result := '기본값설정';
    $F1 : Result := '가맹점다운로드';
    $E8 : Result := '서명처리';
    $90 : Result := '리더기초기화';
    $91 : Result := '리더기상태확인';
    $92 : Result := '무결성체크';
    $93 : Result := 'IC거래승인';
    $94 : Result := 'IC거래취소';
    $95 : Result := 'Fallback거래';
    $96 : Result := 'MS거래';
    $97 : Result := 'KeyIn거래';
    $98 : Result := 'PIN블록요청';
    $99 : Result := '카드감지이벤트시작';
    $9A : Result := '카드감지이벤트중단';
    $9B : Result := 'KeyDownload요청';
    $AA : Result := '밴거래승인';
    $AB : Result := '밴거래취소';
    $AE : Result := '밴은련승인';
    $AF : Result := '밴은련취소';
  else
    Result := '';
  end;
end;

function TVanKFTC.GetSeqNo: AnsiString;
var
  SeqNo: Integer;
begin
  // 일련번호 (10자리, 무조건 전문 보낼 때마다 증가해야 함)
  with TIniFile.Create(Global.HomeDir + 'KFTCSeq.ini') do
    try
      SeqNo := ReadInteger('SEQ', 'SeqNo', 10010010);
      // 다음 번호를 저장
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

      // 응답코드가 999이면 3~5초마다 계속 조회요청
      // 다시요청한 코드가 999이면 반복 진행
      // 999코드가 아니면 결과를 리턴한다.
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
  // 에러코드
  Result.Code := StringSearch(ARecvData, FS, 1);
  // 응답메세지
  Result.Msg := Trim(StringSearch(ARecvData, FS, 18)) + ' ' + StringSearch(ARecvData, FS, 10);
  if Result.Code = '000' then
    Result.Msg := Copy(Trim(Result.Msg), 1, 12);
  // 승인번호
  Result.AgreeNo := StringSearch(ARecvData, FS,  8);
  // 거래번호
  Result.TransNo := StringSearch(ARecvData, FS,  11);
  // 거래일시
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // 발급사코드
  Result.BalgupsaCode := '';
  // 발급사명
  Result.BalgupsaName := Trim(StringSearch(ARecvData, FS, 12));
  // 매입사코드
  Result.CompCode := StringSearch(ARecvData, FS, 13);
  // 매입사명
  Result.CompName := Trim(StringSearch(ARecvData, FS, 14));
  // 가맹점번호
  Result.KamaengNo := StringSearch(ARecvData, FS,  9);
  // 위쳇페이용
  Result.PointAgreeNo := StringSearch(ARecvData, FS,  18);
  Result.PrintMsg := StringSearch(ARecvData, FS,  19);
  // 승인금액 (응답전문에 없음)
//  Result.AgreeAmt := 0;
  // 할인금액 (응답전문에 없음)
  Result.DCAmt := 0;
  // 성공여부
  Result.Result := Result.Code = '000';
end;

function TVanKFTC.MakeRecvDataCardIC(ARecvData: AnsiString; out AAIDCount: Integer; out AAIDList, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
begin
  // 뒷부분의 널문자를 없앤다.
  ARecvData := StringSearch(ARecvData, #255, 0);
  // 에러코드
  Result.Code := StringSearch(ARecvData, FS, 0);
  // AID 갯수
  AAIDCount := StrToIntDef(StringSearch(ARecvData, FS, 1), 0);
  // AID 리스트
  AAIDList := StringSearch(ARecvData, FS, 2);
  // 복호화 정보
  ADecrypt := StringSearch(ARecvData, FS, 3);
  // 승인금액
  Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 4), 0);
  // 카드번호
//  Result.ICCardNo := StringSearch(ARecvData, FS, 5);
  Result.ICCardNo := StringSearch(StringSearch(StringSearch(ARecvData, FS, 5), '=', 0), 'D', 0);
  // 암호화 데이타
  AEncData := StringSearch(ARecvData, FS, 6);
  // EMV 데이타
  AEmvData := StringSearch(ARecvData, FS, 7);
  // 듀얼아이 인증키
  FDualPayKey := StringSearch(ARecvData, FS, 8);
  // 할인금액 (응답전문에 없음)
  Result.DCAmt := 0;
  // 성공여부
  Result.Result := Result.Code = '00';
  if not Result.Result then
    Result.Msg := GetErrorMsgIC(StrToIntDef(Result.Code, -1));
end;

function TVanKFTC.MakeRecvDataCardICFallBack(ARecvData: AnsiString; out AFallBack, ADecrypt, AEncData, AEmvData: AnsiString): TCardRecvInfo;
begin
  // 뒷부분의 널문자를 없앤다.
  ARecvData := StringSearch(ARecvData, #255, 0);
  // 에러코드
  Result.Code := StringSearch(ARecvData, FS, 0);
  // 복호화 정보
  ADecrypt := StringSearch(ARecvData, FS, 1);
  // FallBack 코드
  AFallBack := StringSearch(ARecvData, FS, 2);
  // 카드번호
//  Result.ICCardNo := StringSearch(ARecvData, FS, 3);
  Result.ICCardNo := StringSearch(StringSearch(ARecvData, FS, 3), '=', 0);
  // 암호화 데이타
  AEncData := StringSearch(ARecvData, FS, 4);
  // EMV 데이타
  AEmvData := StringSearch(ARecvData, FS, 5);
  // 듀얼아이 인증키
  FDualPayKey := StringSearch(ARecvData, FS, 6);
  // 승인금액 (응답전문에 없음)
  Result.AgreeAmt := 0;
  // 할인금액 (응답전문에 없음)
  Result.DCAmt := 0;
  // 성공여부
  Result.Result := Result.Code = '00';
  if not Result.Result then
    Result.Msg := GetErrorMsgIC(StrToIntDef(Result.Code, -1));
end;

function TVanKFTC.MakeRecvDataCash(ARecvData: AnsiString): TCashRecvInfo;
begin
  // 에러코드
  Result.Code := StringSearch(ARecvData, FS, 1);
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 10) + ' ' + StringSearch(ARecvData, FS, 18) + ' ' + StringSearch(ARecvData, FS, 19);
  // 승인번호
  Result.AgreeNo := StringSearch(ARecvData, FS,  8);
  // 거래일시
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // 성공여부
  Result.Result := Result.Code = '000';
end;

function TVanKFTC.MakeRecvDataCheck(ARecvData: AnsiString): TCheckRecvInfo;
begin
  // 에러코드
  Result.Code := StringSearch(ARecvData, FS, 1);
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 5);
  // 거래일시
  Result.TransDateTime := '20' + StringSearch(ARecvData, FS,  0);
  // 성공여부
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
            // 처음거래이면 초기설정에서 가맹점정보를 다운받는다
  Result := Result + IfThen(Config.TerminalID = EmptyStr, Config.SerialNo, Config.TerminalID) + FS +
            '0000' + FS +       // 세금(#50:사용, #51:사용안함)
            '1200' + FS +       // 봉사료
            '15'   + FS +       // 응답대기(15초)
            '05'   + FS +       // ENQ 대기시간
            '03'   + FS +       // EOT 대기시간
            IfThen(Config.SignPad, IntToStr(Config.SignPort) + SignPadRate, '00000000000000') + FS + // 부가장비구분 Pinpad 포트(1)
            '0' + FS +          // OCB 유무(가맹점구분)
            '0' + FS +          // 포인트요율
            IfThen(Config.HWSecure, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +     // 단말기포트 및 속도 설정
            Config.ProgramCode + FS + // 프로그램 구분자
            Config.ProgramVersion + FS + // 프로그램 버전
            '8002' + FS +  // LAN IP
            'www.kftcvan.or.kr' + FS + // LAN PORT
            IfThen(Config.SecureMode, FormatFloat('00', Config.MSRPort) + '115200', '00000000') + FS +   // IC리더기 포트 및 속도
            KTC_KEY_ZEUS + // 단말기 인증번호
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
            // 카드번호
  Result := AEncData + FS
            // 거래금액   (
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.FreeAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // 부가세
            + CurrToStr(AInfo.VatAmt)+ FS
            // 봉사료
            + CurrToStr(AInfo.SvcAmt)+ FS
            // 할부개월
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // 일련번호 (10자리)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // 원거래일
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // 원승인번호
            + IfThen(AInfo.OrgAgreeNo <> EmptyStr, AInfo.OrgAgreeNo, '00000000') + FS
            + FS  // 원거래일련번호 (사용X)
            + FS  // PIN(비밀번호)
            + FS  // Cust_id
            + FS // 서명데이터
            + FS // 할인정보
            + FS // 쿠폰번호
            + FS // 내국세 전자환급
            + CurrToStr(AInfo.FreeAmt) + FS // 비과세 금액
            + FS // 취소사유코드
            + FS // 현금카드 관련 정보
            + FS // 결제간소화정보
            + FS // EMV카드 정보
            + FS // fallback
            + FS  // 복호화 정보
            + FDualPayKey + KTC_KEY_ZEUS + FS // KTC 인증키
            + 'KRW'
            + #255;
end;

function TVanKFTC.MakeSendDataCard(AInfo: TCardSendInfo;
  ASignData: AnsiString; AGubun: Integer): AnsiString;
var
  CardNo: AnsiString;
  SeqNo: AnsiString;
begin
  // AGubun 0: 신용승인 1:현금IC 2:PayOn
  case AGubun of
    1: CardNo := Copy(AInfo.CardNo, 4, 16);
    2: CardNo := Trim(AInfo.CardNo);
  else
    CardNo := Format('%-37.37s', [AInfo.CardNo]);
  end;
  // KeyIn (PayOn 이면 P)
  if AGubun = 2 then
    Result := 'P'
  else
    Result := IfThen(AInfo.KeyInput, #$30, #$31);
            // 카드번호
  Result := Result + CardNo + FS
            // 거래금액
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // 부가세
            + CurrToStr(AInfo.VatAmt)+ FS
            // 봉사료
            + CurrToStr(AInfo.SvcAmt)+ FS
            // 할부개월
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // 일련번호 (10자리)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // 원거래일
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // 원승인번호
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // 원거래일련번호 (사용X)
            + FS  // PIN
            + '0' + FS;  // Cust_id
  // 서명데이터
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
            // 카드번호
  Result := AEncData + FS
            // 거래금액
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // 부가세
            + CurrToStr(AInfo.VatAmt)+ FS
            // 봉사료
            + CurrToStr(AInfo.SvcAmt)+ FS
            // 할부개월
            + FormatFloat('00', AInfo.HalbuMonth) + FS;
            // 일련번호 (10자리)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // 원거래일
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // 원승인번호
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // 원거래일련번호 (사용X)
            + APinData + FS  // PIN(비밀번호)
            + FS  // Cust_id
            + ASignData + FS // 서명데이터
            + FS // 할인정보
            + FS // 쿠폰번호
            + FS // 내국세 전자환급
            + FS // 비과세 금액
            + FS // 취소사유코드
            + FS // 현금카드 관련 정보
            + FS // 결제간소화정보
            + AEmvData + FS // EMV카드 정보
            + AFallBack + FS // fallback
            + ADecrypt + FS  // 복호화 정보
            + FDualPayKey + KTC_KEY_ZEUS // KTC 인증키
            + #255;
end;

function TVanKFTC.MakeSendDataCash(AInfo: TCashSendInfo): AnsiString;
var
  SeqNo: AnsiString;
begin
            // 카드번호
  Result := IfThen(AInfo.KeyInput, #$30, #$31) + Format('%-37.37s', [AInfo.CardNo]) + FS
            // 거래금액
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // 부가세
            + CurrToStr(AInfo.VatAmt)+ FS
            // 봉사료
            + CurrToStr(AInfo.SvcAmt)+ FS
            + FS;
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // 원거래일
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // 원승인번호
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            // 원거래일련번호 (사용안함)
            + FS
            // 비밀번호
            + FS
            // 개인/사업자
            + IfThen(AInfo.Person, '0', '1') + FS
            + FS
            + FS
            + FS
            + FS
            + FS
            // 취소사유코드
            + IfThen(AInfo.CancelReason in [1, 2, 3], IntToStr(AInfo.CancelReason), '0')
            + #255;
end;

function TVanKFTC.MakeSendDataCashSecure(AInfo: TCashSendInfo; ADecrypt, AEncData: AnsiString): AnsiString;
var
  SeqNo: AnsiString;
begin
            // 카드번호
  Result := IfThen(AEncData <> '', AEncData, AInfo.CardNo) + FS
            // 거래금액
            + IfThen(AInfo.Approval, CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt), CurrToStr(AInfo.SaleAmt)) + FS
            // 부가세
            + CurrToStr(AInfo.VatAmt)+ FS
            // 봉사료
            + CurrToStr(AInfo.SvcAmt)+ FS
            + FS;
            // 일련번호 (10자리)
  SeqNo := GetSeqNo;
  Result := Result + SeqNo + FS;
            // 원거래일
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS
            // 원승인번호
            + IfThen(AInfo.Approval, '00000000', AInfo.OrgAgreeNo) + FS
            + FS  // 원거래일련번호 (사용X)
            + FS  // PIN(비밀번호)
            + IfThen(AInfo.Person, '0', '1') + FS // Cust_id
            + FS // 서명데이터
            + FS // 할인정보
            + FS // 쿠폰번호
            + FS // 내국세 전자환급
            + FS // 비과세 금액
            + IfThen(AInfo.CancelReason in [1, 2, 3], IntToStr(AInfo.CancelReason), '0') + FS // 취소사유코드
            + FS // 현금카드 관련 정보
            + FS // 결제간소화정보
            + FS // EMV카드 정보
            + FS // fallback
            + ADecrypt // 복호화 정보
            + #255;// 복호화 정보
end;

function TVanKFTC.MakeSendDataCheck(AInfo: TCheckSendInfo): AnsiString;
var
  SeqNo: AnsiString;
begin
            // 수표금액
  Result := CurrToStr(AInfo.CheckAmt) + FS
            // 자기앞 수표
            + '4' + FS
            // 수표번호(8)+은행코드(2)+지점코드(4)+권종코드(2)+발행일자(6)+계좌일련번호(14)
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
            // 카드번호
            CardNo + FS +
            // 금액
            FloatToStr(AInfo.SaleAmt) + FS +
            FS +
            FS +
            // 할부
            '00' + FS +
            // SEQ
            SeqNo + FS +
            // 원거래일
            IfThen(AInfo.Approval, '0000', Copy(AInfo.OrgAgreeDate, 5, 4)) + FS +
            // 원거래승인번호
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
            // 서명데이타
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

  // DLL 파일에서 승인 요청 함수를 불러온다
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ARecvData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltInfo, [KFTC_SIGN_DLL, '호출', IntToHex(FCode, 2), GetFuncName(FCode)]);
  Log.Write(ltInfo, ['전송전문', ASendData]);

  // 승인 요청을 한다
  ARetCode := Exec(FCode, PAnsiChar(ASendData), @ARecvData[1]);
  Result := ARetCode = 0;

  Log.Write(ltInfo, ['응답전문 Code(0:정상, 그외숫자:에러)', ARetCode]);
  Log.Write(ltInfo, ['응답전문 RecvData', ARecvData]);
end;

function TVanKFTC.DLLExecSign: Boolean;
var
  CallPosSetPath: TKFTC_CallPosSetPath;
  CallSetKey: TKFTC_CallSetKey;
begin
  Result := False;

  // DLL 파일에서 승인 요청 함수를 불러온다
  @CallPosSetPath := GetProcAddress(DLLHandle, 'CallPosSetPath');
  @CallSetKey     := GetProcAddress(DLLHandle, 'CallPosSetKey');
  if not Assigned(@CallPosSetPath) or not Assigned(@CallSetKey) then
  begin
    Log.Write(ltInfo, ['DLLExecSign 함수 없음']);
    Exit;
  end;

  CallSetKey(13, 27, 8);
  CallPosSetPath(Global.HomeDir);
  Result := True;
end;

function TVanKFTC.DoStartProc(out AMsg: AnsiString): Boolean;
begin
  // 기본값 설정이 되어 있지 않으면 실행한다.
//  if (not FInitRun) or Config.SecureModeInit then
//  begin
    ReadIni;
    Result := DoPosInit;
    if not Result then Exit;
    if Config.TerminalID = EmptyStr then
      Config.PosDownload := True;
    FInitRun := True;
//  end;
  // 가맹점 다운로드를 처리한다.
  if Config.PosDownload then
  begin
    Result := DoPosDownload;
    if Result then
    begin
      WriteIni;
      // 보안모듈 사용이면 KeyDownload
      if Config.SecureMode then
      begin
        Result := DoKeyDownload;
        Exit;
      end;
    end
    else
    begin
      AMsg := '가맹점 정보를 다운받지 못했습니다. 잠시 후에 다시 시도하세요';
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
  // 전문을 만든다.
  SendData := MakeSendDataInit;

  Log.Write(ltInfo, ['기본값 설정 전송', SendData]);
  Result := DLLExec($F0, SendData, RetCode, RecvData);

  if Result then
    Log.Write(ltInfo, ['기본값 설정 성공', RecvData])
  else
    Log.Write(ltError, ['기본값 설정 실패', GetErrorMsg(RetCode)]);
end;

function TVanKFTC.DoPosDownload: Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
  CardTID: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataPosDownload;

  Log.Write(ltInfo, ['가맹점 다운로드 전송', SendData]);
  Result := DLLExec($F1, SendData, RetCode, RecvData);

  if Result then
  begin
    Log.Write(ltInfo, ['가맹점 다운로드 성공', RetCode]);
    // 응답을 처리한다.
    CardTID := StringSearch(RecvData, FS, 0);
    CardTID := StringReplace(CardTID, #255, '', [rfReplaceAll]);
    FWorkingKey := StringSearch(RecvData, FS, 1);
    Config.TerminalID := CardTID;
    //가맹점 다운로드를 못받았을때
    if CardTID = EmptyStr then
      Result := False;
  end
  else
  begin
    Result := False;
    Log.Write(ltInfo, ['가맹점 다운로드 실패', GetErrorMsg(RetCode)]);
  end;
end;

function TVanKFTC.DoKeyDownload: Boolean;
var
  RetCode: Integer;
  RecvData: AnsiString;
  ResultCode, ModulID: AnsiString;
begin
  Log.Write(ltInfo, ['Key 다운로드 전송', '']);
  Result := DLLExec($9B, '', RetCode, RecvData);

  if Result then
  begin
    Log.Write(ltInfo, ['Key 다운로드 성공', RetCode]);
    // 응답을 처리한다.
    ResultCode := StringSearch(RecvData, FS, 0);
    ResultCode := StringReplace(ResultCode, #255, '', [rfReplaceAll]);
    ModulID := StringSearch(RecvData, FS, 1);
    Result := ResultCode = '00';
  end
  else
  begin
    Result := False;
    Log.Write(ltInfo, ['Key 다운로드 실패', RetCode]);
  end;
end;

function TVanKFTC.DoCardSign(ASaleAmt: Integer; out ASignData: AnsiString): Boolean;
var
  RetCode: Integer;
  SendData, RecvData: AnsiString;
begin
  Result := False;
  SendData := IntToStr(ASaleAmt) + #28 + #28 + #255; // 금액(9) + 메세지(64) + 기능표시(16)

  if not DLLExecSign then Exit;

  Log.Write(ltInfo, ['서명정보 전송', SendData]);
  Result := DLLExec($E8, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['서명정보 응답', RetCode]);

  if Result then
  begin
    if StrToIntDef(Copy(RecvData, 23, 4), 0) > 0 then
      ASignData := Trim(RecvData)
    else
    begin
      Result := False;
      ASignData := '서명정보를 입력 받지 못했습니다.'#13#10 + 'Error=' + GetErrorMsg(RetCode);
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

  Log.Write(ltInfo, ['PinPad 전송', '']);
  Result := DLLExec($E7, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad 응답', RetCode]);

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
      APinDataIC := '처리 실패';
  end
  else
    APinDataIC := '처리 실패';
end;

function TVanKFTC.CallPosDownload: TPosDownloadRecvInfo;
begin
  Result.Result := False;
  ShowMessageForm('가맹점 정보와 Key 다운로드 중입니다.'#13#10 + '잠시만 기다려 주십시오.');
  try
    // 기본값 설정이 되어 있지 않으면 실행한다.
//    if (not FInitRun) or Config.SecureModeInit then
//    begin
      ReadIni;
      Result.Result := DoPosInit;
      if not Result.Result then Exit;
      FInitRun := True;
//    end;

    // 가맹점 다운로드를 처리한다.
    Result.Result := DoPosDownload;
    if Result.Result then
    begin
      WriteIni;
      // 보안모듈 사용이면 KeyDownload를 시행한다.
      if Config.SecureMode then
      begin
        Result.Result := DoKeyDownload;
        if not Result.Result then
          Result.Msg := 'Key 다운로드를 실패 하였습니다.';
      end;
    end
    else
      Result.Msg := '가맹점 정보를 다운받지 못했습니다. 잠시 후에 다시 시도하세요';
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
  // 사인을 받는다
  if Config.SignPad then
  begin
    Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
    if not Result.IsSignOK then
    begin
      Result.Result := False;
      Result.Msg := SignData;
      //if Application.MessageBox('수기 서명으로 처리하시겠습니까?', '확인', MB_YESNO) = ID_NO then
      if not ShowQuestionForm('수기 서명으로 처리하시겠습니까?') then
        Exit;
    end;
  end;
  // 전문을 만든다.
  SendData := MakeSendDataCard(AInfo, SignData, 0);
  FCode := IfThen(AInfo.Approval, $F2, $F3);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // 응답을 처리한다.
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

  // 1. 초기설정, 가맹점 다운로드, 키다운로드를 처리한다.
  try
    //수기 서명 요청 후 결제 처리가 안되는 문제 해결을 위해 단말기 초기화
    //DoCallICReader(IC_READER_WORK_INIT, RecvData);

    ShowMessageForm('초기설정을 처리하는 중입니다.'#13#10 + '(가맹점 정보 및 Key 다운로드)');
    if not DoStartProc(RecvData) then
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;

    HideMessageForm;

    //청하고려인삼 요청으로 타임아웃 1분으로 설정함.
    ShowMessageForm('카드를 IC 슬롯에 삽입한 후' + #13+#10 + '거래완료 시까지 기다려 주십시오.', False, 60);
    AID_Re_Try:
    // 2. IC 리더기를 호출한다.
    SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // 거래일시
                FormatFloat('000000000000000000', AInfo.SaleAmt) + FS + // 거래금액
                IntToStr(SelectAIDIndex) + // AID 인덱스
                IfThen(AInfo.Approval, '', FS + IfThen(AEyCard, '1', '0')) + // PIN블록 입력여부
                #255;
    FCode := IfThen(AInfo.Approval, $93, $94);
    if not DLLExec(FCode, SendData, RetCode, RecvData) then
    begin
      Result.Result := False;
      Result.Msg := '처리 실패';
      Exit;
    end;
    // 리더기 응답을 처리한다.
    Result := MakeRecvDataCardIC(RecvData, AIDCount, AIDList, Decrypt, EncData, EmvData);

    HideMessageForm;

    // 2.1 FallBack 처리를 한다.
    if Result.Code = '07' then
    begin
      if not ShowQuestionForm('[FallBack] IC 카드를 인식하지 못했습니다. MSR 방식으로 처리하시겠습니까?'#13#10 + '(카드를 제거한 후 [예]를 누르십시오.)') then
      begin
        Result.Result := False;
        Exit;
      end;

      ShowMessageForm('MSR에 카드를 인식시켜 주십시오.');
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // 거래일시
                  IfThen(AEyCard, '1', '0') + // PIN블록 입력여부
                  #255;
      if not DLLExec($95, SendData, RetCode, RecvData) then
      begin
        Result.Result := False;
        Result.Msg := '처리 실패';
        Exit;
      end;
      // 리더기 응답을 처리한다.
      Result := MakeRecvDataCardICFallBack(RecvData, FallBackCode, Decrypt, EncData, EmvData);
      Log.Write(ltInfo, ['FallBackCode', FallBackCode, 'Msg', GetErrorMsgFallBack(FallBackCode)]);
      Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    end
    else
      if not Result.Result then
        Exit;

    // 2.2 AID 프로세스 처리
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

    // 3. 은련카드인경우 PIN 입력 처리
    if AEyCard then
    begin
      ShowMessageForm('핀패드에 비밀번호를 입력하십시오.');
      CardNo := StringReplace(Result.ICCardNo, '*', 'F', [rfReplaceAll]);

      // 서명패드에서 암호를 입력 받는다.
      if not DoPinPad(CardNo, PinData) then
      begin
        Result.Result := False;
        Result.Msg := PinData;
        Exit;
      end;

      // IC리더기에 PinData요청한다.
      if not DoPinPadIC(PinData, PinDataIC) then
      begin
        Result.Result := False;
        Result.Msg := PinDataIC;
        Exit;
      end;
    end;

    HideMessageForm;

    // 4. 사인을 받는다.
//    if Config.SignPad and not AEyCard then
    if Config.SignPad then
    begin
      Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
      if not Result.IsSignOK then
      begin
        Result.Result := False;
        Result.Msg := SignData;
        //if Application.MessageBox('수기 서명으로 처리하시겠습니까?', '확인', MB_YESNO) = ID_NO then
        if not ShowQuestionForm('수기 서명으로 처리하시겠습니까?') then
          Exit;
      end;
    end;

    // 5. VAN서버에 승인/취소 전문을 보낸다.
    ShowMessageForm('전문 송수신 중입니다. 잠시만 기다려 주십시오.', False, 30);
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

    // 전송전문과 응답전문을 초기화 한다.
    if (Length(SendData) > 0) then EraseMemory(SendData);
    if (Length(RecvData) > 0) then EraseMemory(RecvData);
    if (Length(EncData) > 0) then EraseMemory(EncData);

    // 비정상 종료시 리더기 초기화
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

  // 1. 초기설정, 가맹점 다운로드, 키다운로드를 처리한다.
  ShowMessageForm('초기설정을 처리하는 중입니다.'#13#10 + '(가맹점 정보 및 Key 다운로드)');
  try
    if not DoStartProc(RecvData) then
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;

    if AInfo.KeyInput then
      ShowMessageForm('처리 중입니다. 거래완료 시까지 기다려 주십시오.')
    else
      ShowMessageForm('MSR에 카드를 인식시킨 후' + #13+#10 + '거래완료 시까지 기다려 주십시오.');

    // 2. MSR 리더기를 호출한다.
    if AInfo.KeyInput then
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // 거래일시
                  AInfo.CardNo + #255                          // 카드번호
    else
      SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // 거래일시
                  '1' + FS +                                   // 암호화 여부 (0:암호화안함 1: 암호화함)
                  IfThen(AEyCard, '1', '0') +                  // PIN블록 입력여부
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
      Result.Msg := '처리 실패';
      Exit
    end;

    // 3. 은련카드인경우 PIN 입력 처리
    if AEyCard then
    begin
      ShowMessageForm('핀패드에 비밀번호를 입력하십시오.');
      CardNo := StringReplace(CardNo, '*', 'F', [rfReplaceAll]);

      // 서명패드에서 암호를 입력 받는다.
      if not DoPinPad(CardNo, PinData) then
      begin
        Result.Result := False;
        Result.Msg := PinData;
        Exit;
      end;
      // IC리더기에 PinData요청한다.
      if not DoPinPadIC(PinData, PinDataIC) then
      begin
        Result.Result := False;
        Result.Msg := PinDataIC;
        Exit;
      end;
    end;

    // 4. 사인을 받는다.
    if Config.SignPad then
    begin
      Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
      if not Result.IsSignOK then
      begin
        Result.Result := False;
        Result.Msg := SignData;
        //if Application.MessageBox('수기 서명으로 처리하시겠습니까?', '확인', MB_YESNO) = ID_NO then
        if not ShowQuestionForm('수기 서명으로 처리하시겠습니까?') then
          Exit;
      end;
    end;

    ShowMessageForm('전문 송수신 중입니다. 잠시만 기다려 주십시오.', False, 30);
    // 4. VAN서버에 승인/취소 전문을 보낸다.
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
    // 전송전문과 응답전문을 초기화 한다.
    FillChar(SendData[1], Length(SendData), 0);
    FillChar(RecvData[1], Length(RecvData), 0);
    // 비정상 종료시 리더기 초기화
    if not Result.Result then
      DoCallICReader(IC_READER_WORK_INIT, RecvData);
    HideMessageForm;
  end;
end;

function TVanKFTC.CallCard(AInfo: TCardSendInfo): TCardRecvInfo;
begin
  if Config.SecureMode then
  begin
    // MSR거래와 키인거래 일때와 IC거래일때 구분하여 처리한다.
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
      Result.Msg := 'MSR 리딩 실패 !!!';
      Exit;
    end;
  end;

  // 전문을 만든다.
  if Config.SecureMode and (EncData <> '') then
    SendData := MakeSendDataCashSecure(AInfo, Decrypt, EncData)
  else
    SendData := MakeSendDataCash(AInfo);
  FCode := IfThen(AInfo.Approval, $E5, $E6);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // 응답을 처리한다.
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

  // 전문을 만든다.
  SendData := MakeSendDataCheck(AInfo);

  if DLLExec($F8, SendData, RetCode, RecvData) then
  begin
    // 응답을 처리한다.
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

  Log.Write(ltInfo, ['PinPad 전송', '']);
  Result := DLLExec($E9, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad 응답', RetCode]);

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
    // MSR거래와 키인거래 일때와 IC거래일때 구분하여 처리한다.
    if AInfo.MSRTrans or AInfo.KeyInput then
      Result := DoCallCardMSRSecure(True, AInfo)
    else
      Result := DoCallCardICSecure(True, AInfo);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := '해당 기능 구현되어 있지 않음';
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
  // DLL 파일에서 승인 요청 함수를 불러온다
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ACardNo := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := FormatFloat('000000000', APayAmt) + #255;

  Log.Write(ltDebug, ['CallIC 전송전문', ASendData]);

  // 승인 요청을 한다
  Index := Exec(IfThen(AApproval, $d3, $d4), PAnsiChar(ASendData), @ACardNo[1]);
  if Index = 0 then
  begin
    AEmvInfo := StringSearch(ACardNo, #28, 0);
    ACardNo := StringSearch(ACardNo, #28, 1);
    if Length(AEmvInfo) < 3 then
      ACardNo := 'FALLBACK 발생'
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
  // DLL 파일에서 승인 요청 함수를 불러온다
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  @SetMSCallback  := GetProcAddress(DLLHandle, 'SetMSCallback');
  @SetICCallback  := GetProcAddress(DLLHandle, 'SetICCallback');
  if not Assigned(@Exec) then
  begin
    ARetData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := EmptyStr;

  Log.Write(ltDebug, ['SetTerminalAsync 전송전문', ASendData]);

  // 승인 요청을 한다
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
    ShowMessageForm('IC카드 단말기 무결성 검사 중입니다.');

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
          ARecvData := '단말기 명칭: ' + StringSearch(RecvData, FS, 1) + #13+#10 +
                       '단말기 버전: ' + StringSearch(RecvData, FS, 2) + #13+#10 +
                       '모듈 ID: ' + StringSearch(RecvData, FS, 3);
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
      ARecvData := '처리 실패';
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
    Log.Write(ltDebug, ['감지 이벤트 등록 실패', 'SET_IC_DETECT를 찾을수 없습니다.']);
    Exit;
  end;

  RetCode := Exec(@ICDetectEvnet);
  if RetCode <> 1 then
  begin
    Log.Write(ltDebug, ['감지 이벤트 등록 실패', '콜백 함수 등록 실패']);
    Exit;
  end;

  SendData := '';
  if DLLExec($99, SendData, RetCode, RecvData) then
    Result := Copy(RecvData, 1, 2) = '00';

  if Result then
    Log.Write(ltDebug, ['감지 이벤트 등록 성공', ''])
  else
    Log.Write(ltDebug, ['감지 이벤트 등록 실패', '']);
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
    Log.Write(ltDebug, ['감지 이벤트 등록 성공', ''])
  else
    Log.Write(ltDebug, ['감지 이벤트 등록 실패', '']);
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
          ARecvData := 'IC 리더기 감지 이벤트 등록 실패';
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

  ShowMessageForm('MSR에 카드를 인식시켜 주십시오.');
  try
    SendData := FormatDateTime('yyyymmddhhnnss', Now) + FS + // 거래일시
                AGubun + FS +                                // 암호화 여부 (0:암호화안함 1: 암호화함(신용카드결제화면), 2:현금영수증결제화면)
                '0' +                                        // PIN블록 입력여부
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
      ACardNo := '처리 실패';
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
  // DLL 파일에서 승인 요청 함수를 불러온다
  @Exec := GetProcAddress(DLLHandle, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ACardNo := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  ASendData := FormatFloat('000000000', APayAmt) + #255;

  Log.Write(ltDebug, ['CallMS 전송전문', ASendData]);

  // 승인 요청을 한다
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
  // 문구4줄 각줄당 16Byte로 맞출것
  SendData := '0' + '카드를삽입하세요'
                  + '금액            '
                  + FormatFloat('##############', AInfo.SaleAmt) + '원'
                  + '                ';
  if not DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    Result.Result := False;
    Result.Msg := GetErrorMsg(RetCode);
    Exit;
  end;
  AInfo.CardNo := Trim(RecvData);

  // 전문을 만든다.
  FCode := IfThen(AInfo.Approval, $A0, $A1);
  SendData := MakeSendDataCard(AInfo, SignData, 1);
  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // 응답을 처리한다.
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
  // 문구4줄 각줄당 16Byte로 맞출것
  SendData := '4' + '카드를 대주세요 '
                  + '금액            '
                  + FormatFloat('##############', APayAmt) + '원'
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
  // 사인을 받는다
  if Config.SignPad then
  begin
    Result.IsSignOK := DoCardSign(Trunc(AInfo.SaleAmt), SignData);
    if not Result.IsSignOK then
    begin
      Result.Result := False;
      Result.Msg := SignData;
      //if Application.MessageBox('수기 서명으로 처리하시겠습니까?', '확인', MB_YESNO) = ID_NO then
      if not ShowQuestionForm('수기 서명으로 처리하시겠습니까?') then
        Exit;
    end;
  end;

  // 전문을 만든다.
  SendData := MakeSendDataCard(AInfo, SignData, 2);
  FCode := IfThen(AInfo.Approval, $F2, $F3);

  if DLLExec(FCode, SendData, RetCode, RecvData) then
  begin
    // 응답을 처리한다.
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
    Log.Write(ltInfo, ['한글 코드 변환', KFTC_CONV_DLL + MSG_ERR_DLL_LOAD]);
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
  Log.Write(ltDebug, ['수신 메세지', Buff, 'ReadBuff', FReadBuff]);

  if Copy(FReadBuff, 1, 1) = ENQ then
  begin
    FReadBuff := '';
    FComPort.WriteStr(ACK);
    Log.Write(ltDebug, ['ACK 전송', '']);
  end
  else if Copy(FReadBuff, 1, 1) = ACK then
  begin
    FReadBuff := '';
//    FComPort.WriteStr(EOT);  // EOT 삭제 (2016.1.19)
    Log.Write(ltDebug, ['ACK 수신', '']);
  end
  else if Copy(FReadBuff, 1, 1) = NAK then
  begin
    FReadBuff := '';
    FComPort.WriteStr(EOT);
    Log.Write(ltDebug, ['EOT 전송', '']);
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
    Log.Write(ltDebug, ['ACK 전송', ACK]);
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
  Log.Write(ltDebug, ['전송전문', ASendData]);
  FComPort.Write(ASendData[1], Length(ASendData));
  // 응답 처리
  GetTime := GetTickCount;
  while GetTime + (60 * 1000) > GetTickCount do // 응답대기 60초
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
    Result.Msg := 'ComPort Open 실패! [' + FComPort.Port + ']';
    Exit;
  end;

  ShowMessageForm('카드를 단말기 IC슬롯에 삽입한 후' + #13+#10 + '거래완료 시까지 기다려 주십시오.', True);
  try
    // 전문을 만든다.
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
    Log.Write(ltDebug, ['응답 데이타', FRecvData]);
    // 응답전문을 만든다.
    // 에러코드
    Result.Code := StringSearch(FRecvData, FS, 0);
    Result.Code := Copy(Result.Code, 16, 3);
    // 응답메세지
    Result.Msg := Copy(Trim(StringSearch(FRecvData, FS, 7)), 2, MAXBYTE);
    Result.Msg := DoCodeConv(0, Result.Msg);
    // 승인번호
    Result.AgreeNo := Copy(StringSearch(FRecvData, FS, 5), 2, MAXBYTE);
    // 거래번호
    Result.TransNo := Copy(StringSearch(FRecvData, FS, 8), 2, MAXBYTE);
    // 거래일시
    Result.TransDateTime := '20' + Copy(StringSearch(FRecvData, FS, 0), 4, 12);
    // 발급사코드
    Result.BalgupsaCode := '';
    if AInfo.Approval then
    begin
      // 발급사명
      Result.BalgupsaName := Copy(StringSearch(FRecvData, FS, 10), 2, MAXBYTE);
      Result.BalgupsaName := DoCodeConv(0, Result.BalgupsaName);
      // 카드번호
      Result.ICCardNo := StringReplace(Copy(Trim(StringSearch(FRecvData, FS, 11)), 2, MAXBYTE), ';', '', [rfReplaceAll]);
      // 매입사코드
      Result.CompCode := Copy(StringSearch(FRecvData, FS, 12), 2, MAXBYTE);
      // 매입사명
      Result.CompName := Copy(Trim(StringSearch(FRecvData, FS, 13)), 2, MAXBYTE);
      Result.CompName := DoCodeConv(0, Result.CompName);
    end
    else
    begin
      // 발급사명
      Result.BalgupsaName := Copy(StringSearch(FRecvData, FS, 9), 2, MAXBYTE);
      Result.BalgupsaName := DoCodeConv(0, Result.BalgupsaName);
      // 카드번호
      Result.ICCardNo := StringReplace(Copy(Trim(StringSearch(FRecvData, FS, 10)), 2, MAXBYTE), ';', '', [rfReplaceAll]);
      // 매입사코드
      Result.CompCode := Copy(StringSearch(FRecvData, FS, 11), 2, MAXBYTE);
      // 매입사명
      Result.CompName := Copy(Trim(StringSearch(FRecvData, FS, 12)), 2, MAXBYTE);
      Result.CompName := DoCodeConv(0, Result.CompName);
    end;
    // 가맹점번호
    Result.KamaengNo := Copy(StringSearch(FRecvData, FS, 6), 2, MAXBYTE);
    // 승인금액
    Result.AgreeAmt := StrToIntDef(Copy(StringSearch(FRecvData, FS, 1), 2, MAXBYTE), 0);
    // 할인금액 (응답전문에 없음)
    Result.DCAmt := 0;
    // 성공여부
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
    Result.Msg := 'ComPort Open 실패! [' + FComPort.Port + ']';
    Exit;
  end;

  ShowMessageForm('단말기에 휴대폰/주민번호를 입력하거나, 카드를 인식시켜 주십시오!', True);
  try
    // 전문을 만든다.
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
    Log.Write(ltDebug, ['응답 데이타', FRecvData]);
    // 응답전문을 만든다.
    // 에러코드
    Result.Code := StringSearch(FRecvData, FS, 0);
    Result.Code := Copy(Result.Code, 16, 3);
    // 응답메세지
    Result.Msg := Copy(Trim(StringSearch(FRecvData, FS, 7)), 2, MAXBYTE);
    Result.Msg := DoCodeConv(0, Result.Msg);
    // 승인번호
    Result. AgreeNo := Copy(StringSearch(FRecvData, FS, 5), 2, MAXBYTE);
    // 거래일시
    Result.TransDateTime := '20' + Copy(StringSearch(FRecvData, FS, 0), 4, 12);
    // 카드번호
    Result.ICCardNo := Copy(Trim(StringSearch(FRecvData, FS, 11)), 2, MAXBYTE);
    // 성공여부
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
    Log.Write(ltInfo, ['ComPort Open 실패!', FComPort.Port]);
    Exit;
  end;
  try
    // 전문을 만든다.
    APrintData := ReceiptReplaceString(vctKFTC, APrintData);
    APrintData := StringReplace(APrintData, #13#10, #10, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, #13, #10, [rfReplaceAll]);
//    SendData := '64' + FS + APrintData;
    APrintData := APrintData + ETX;
//    APrintData := STX + APrintData + GetLRC(APrintData);
    Log.Write(ltDebug, ['전송전문', APrintData]);
    FComPort.Write(APrintData[1], Length(APrintData));
//    ExecSendData(SendData);
    Log.Write(ltDebug, ['응답 데이타', FRecvData]);
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
        Log.Write(ltInfo, ['TVanCatKFTC.CashDrawOpen ComPort Open 실패!', FComPort.Port]);
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

  Log.Write(ltInfo, ['PinPad 전송', '']);
  Result := DLLExec($E9, SendData, RetCode, RecvData);
  Log.Write(ltInfo, ['PinPad 응답', RetCode]);

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
  // DLL 파일에서 승인 요청 함수를 불러온다
  @Exec := GetProcAddress(DLLHandle_Sign, 'KFTC_POS_TRANS');
  if not Assigned(@Exec) then
  begin
    ARecvData := KFTC_SIGN_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // 승인 요청을 한다
  ARetCode := Exec(FCode, PAnsiChar(ASendData), @ARecvData[1]);
  Result := ARetCode = 0;

  Log.Write(ltInfo, ['응답전문 Code(0:정상, 그외숫자:에러)', ARetCode]);
  Log.Write(ltDebug, ['응답전문 RecvData', ARecvData]);
end;

function TVanCatKFTC.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    1 : Result := 'Transaction Time out';
    2 : Result := '전용선 연결 안 됨';
    3 : Result := '통신 에러(데이터 오류)';
    4 : Result := '회선 장애 (TCP/IP)';
    5 : Result := 'EOT 미 수신 ( 일반적으로 발생하지 않음 )';
    6 : Result := '부가 장비 사용 여부 확인';
    7 : Result := 'Pinpad 입력 및 수표 조회기 Reading Time out';
    8 : Result := '회선 장애(PORT Open Error)';
    9 : Result := '장치 연결 안됨';
    10: Result := '장치 데이터 오류';
    11: Result := '데이터 포맷 에러';
    12: Result := '응답전문수신Error(DLE수신)';
    13: Result := '서명패드에서 종료버튼을 누름';
    15: Result := '일반 가맹점에서 캐쉬백 거래 요청 시 에러';
    19: Result := '싸인데이타 Error';
    20: Result := '싸인패드 com port open 실패';
    21: Result := '핀패드 초기화 성공';
    23: Result := '이차 검증 실패';
  else
    Result := '알수 없는 에러';
  end;
  Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanCatKFTC.DoStartProc(out AMsg: AnsiString): Boolean;
begin
  // 기본값 설정이 되어 있지 않으면 실행한다.
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
  // 전문을 만든다.
  SendData := MakeSendDataInit;

  Log.Write(ltInfo, ['기본값 설정 전송', SendData]);
  Result := DLLExec($F0, SendData, RetCode, RecvData);

  if Result then
    Log.Write(ltInfo, ['기본값 설정 성공', RecvData])
  else
    Log.Write(ltError, ['기본값 설정 실패', GetErrorMsg(RetCode)]);
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
            // 처음거래이면 초기설정에서 가맹점정보를 다운받는다
  Result := Result + IfThen(Config.TerminalID = EmptyStr, Config.SerialNo, Config.TerminalID) + FS +
            '0000' + FS +       // 세금(#50:사용, #51:사용안함)
            '1200' + FS +       // 봉사료
            '15'   + FS +       // 응답대기(15초)
            '05'   + FS +       // ENQ 대기시간
            '03'   + FS +       // EOT 대기시간
            IfThen(Config.SignPad, IntToStr(Config.SignPort) + SignPadRate, '00000000000000') + FS + // 부가장비구분 Pinpad 포트(1)
            '0' + FS +          // OCB 유무(가맹점구분)
            '0' + FS +          // 포인트요율
            IfThen(Config.HWSecure, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +     // 단말기포트 및 속도 설정
            Config.ProgramCode + FS + // 프로그램 구분자
            Config.ProgramVersion + FS + // 프로그램 버전
            IfThen(Config.RealMode, '8002', IntToStr(Config.HostPort)) + FS +  // LAN IP
            IfThen(Config.RealMode, 'www.kftcvan.or.kr', Config.HostIP) + FS + // LAN PORT
            IfThen(Config.SecureMode, FormatFloat('00', Config.MSRPort) + '057600', '00000000') + FS +   // IC리더기 포트 및 속도
            KTC_KEY_ZEUS + // 단말기 인증번호
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
        Log.Write(ltDebug, ['전송전문', ASendData]);
        IdTCPClient.IOHandler.WriteLn(ASendData, IndyTextEncoding_OSDefault);
        ARecvData := IdTCPClient.IOHandler.ReadLn(ETX, IndyTextEncoding_OSDefault);
        Log.Write(ltDebug, ['응답전문', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '모듈과 연결 실패!!!';
    except on E: Exception do
      ARecvData := '모듈과의 통신중 에러 발생 ' + E.Message;
    end;
    {$ELSE}
    try
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 8002;
      IdTCPClient.Connect(3000);
      if IdTCPClient.Connected then
      begin
        Log.Write(ltDebug, ['전송전문', ASendData]);
        IdTCPClient.WriteLn(ASendData);
        ARecvData := IdTCPClient.ReadLn(ETX);
        Log.Write(ltDebug, ['응답전문', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '모듈과 연결 실패!!!';
    except on E: Exception do
      ARecvData := '모듈과의 통신중 에러 발생 ' + E.Message;
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
  // 맨 뒤에 FS가 없기 때문에 추가한다.
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

  // 전송 데이타를 만든다.
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
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // 부가세
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // 봉사료
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // 할부개월
                'k' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x'
  else
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // 원승인일자
                'R' + FS + 'Y' + FS +
                'a' + AInfo.OrgAgreeNo + FS + // 원승인번호
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // 할부개월
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x';

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 거래일시
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // 승인번호
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // 거래번호
  Result.TransNo := GetStringSearch('h', RecvData);
  // 발급사코드
  Result.BalgupsaCode := GetStringSearch('u', RecvData);
  // 발급사명
  Result.BalgupsaName := GetStringSearch('p', RecvData);
  // 매입사코드
  Result.CompCode := GetStringSearch('t', RecvData);
  // 매입사명
  Result.CompName := GetStringSearch('v', RecvData);
  // 카드번호
  Result.ICCardNo := GetStringSearch('q', RecvData);
  Result.ICCardNo := Copy(Result.ICCardNo, 1, 6); //카드 앞 Bin 부분만 리턴한다.
  // 가맹점번호
  Result.KamaengNo := GetStringSearch('d', RecvData);
  // 승인금액
  Result.AgreeAmt := StrToIntDef(GetStringSearch('B', RecvData), 0);
  // 할인금액 (응답전문에 없음)
  Result.DCAmt := 0;
  // 서명 데이타
  Result.SignData := GetStringSearch('z', RecvData);
  Result.SignLength := Length(Result.SignData);
  Result.IsSignOK := Result.SignLength > 0;
  // 성공여부
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

  // 전송 데이타를 만든다.
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
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // 부가세
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // 봉사료
                'b' + FS + 'h' + FS + 'j' + FS + 'k' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x'
  else
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // 원승인일자
                'R' + FS +
                'Y' + IntToStr(AInfo.CancelReason) + FS + // 현금영수증 취소사유
                'a' + AInfo.OrgAgreeNo + FS + // 원승인번호
                'b' + FS + 'h' + FS + 'j' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x';

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 거래일시
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // 승인번호
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // 카드번호
  Result.ICCardNo := GetStringSearch('q', RecvData);
  Result.ICCardNo := Copy(Result.ICCardNo, 1, 6); //카드 앞 Bin 부분만 리턴한다.
  // 성공여부
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCheck(AInfo: TCheckSendInfo): TCheckRecvInfo;
var
  SendData, RecvData, TempStr: string;
begin
  Result.Result := False;
  // 전송 데이타를 만든다.
  SendData := 'I0' + FS + // 전문구분
              'B' + CurrToStr(AInfo.CheckAmt) + FS + // 수표금액
              'L' + '4' + FS + // 수표종류 (4:자기앞수표 5: 가계수표)
              // 수표번호(8)+은행코드(2)+지점코드(4)+권종코드(2)+발행일자(6)+계좌일련번호(6)
              'N' + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + AInfo.KindCode + AInfo.RegDate + AInfo.AccountNo + FS +
              'h' + '' ; // 일련번호

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 거래일시
  Result.TransDateTime := '20' + Copy(TempStr, 4, 12);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData);
  // 성공여부
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
        // 응답 데이타를 만든다.
        TempStr := StringSearch(RecvData, FS, 0);
        // 성공여부
        Result := Copy(TempStr, 16, 3) = 'S00';
        // 응답메세지
        ARecvData := GetStringSearch('g', RecvData);
      end;
  end;
end;

function TVanKFTCDaemon.CallPinPad(out ARetData: AnsiString): Boolean;
begin
  Result := False;
  ARetData := '해당 기능 제공하지 않음';
end;

end.
