(*******************************************************************************
  �� �������(Daemon or vCAT or Agent)����� �ſ�ī�� ���� ���

  TVanDaemonModule ���� Ŭ����: �ܺ� POS ���α׷��� �����Ǵ� ����Ŭ������ �� Ŭ������ �����Ͽ� ����Ѵ�.
  TVanDaemon ��纰 ���� Ŭ����: �߻� ���� Ŭ������ ���� ���� ���� �������̽��� ����. ����� ���� �� Ŭ������ ��� �޾� �����Ѵ�.

             ��Ī       ���߻����  ��������  ȭ�鼭��  ����IC  ���е�(����ȣ��)
  KFTC     KFTCOneCAP        O                                        X
  Kicc     EasyCardK         O         #         O         #
  Kis      KIS-AGENT         O                                        O
  FDIK     Win4POS           #                   O                    X
  Koces    KocesICPos        O         X         O         #          X
  KSNET    KSCAT             O         O         O                    X
  JTNET    JTtPayDaemon      O         O         O                    O
  Nice     NiceVirtualCAT    O                   O                    X
  Smartro  V-CAT             O         X         O         X          X
  KCP      NHNKCPSecurePOS   O                   O                    X
  DAOU     DaouVP            O         X         O         O          X
  KOVAN    VPOS              O         O                   #          X
  SPC      SpcnVirtualPos    O         O         O         O          X

  *** ���е� ���� ȣ���� �ſ���� �� ���ݽ��ν� ���е带 ����ϴ°��� �ƴ�
      �ŷ��� ������� ������ ���е� �Է� ��ɸ� ȣ�� �ϴ� ��츦 ����.
      O:�����Ϸ�  X:��ɾ���  #:��⿡���� ��� �����ϳ� �̰���

  << ����纰 ���� ����� ����ó >>

           �����             �μ�                   ��ȭ��ȣ          �̸���
  KFTC     ������ ����        e������� ��ǰ������   T) 02-531-3475    enaseok@kftc.or.kr
                                                     H) 010-8649-9089
  Kicc     �Ӽҿ� ����        ���������             T) 02-368-0844    soyeon0201@kicc.co.kr
  Kis      ����� �븮        ��������1��            T) 02-2101-1657   mtkim@kisvan.co.kr
                                                     H) 010-2323-5486
  FDIK     �ֺ��� �븮        IT���               T) 02-2287-3075   Dottore.choi@firstdata.com
           ������             IT ������              T) 02-2287-3105   bill.lee@firstdatacorp.co.kr
                                                     H) 010-8897-5467
  Koces    ������ �븮        ����������             T) 02-3415-3715   ksk3197@koces.com
  KSNET    ����ȣ ����        ����4��                T) 02-3420-6876   ultrajunho@ksnet.co.kr
  JTNET    �ڽ¹� �븮        VAN ������             T) 02-801-7886    seungmin@jtnet.co.kr
  Nice     �輱ȣ ����        ä�λ������           T) 02-2187-2843   sun@nicevan.co.kr
                                                     H) 010-2287-0565
  Smartro  �ɱԼ� ����        �ַ�ǰ��߽�           T) 02-2109-9046   ksshim@smartro.co.kr
                              POS������              H) 010-3014-1809
           �輼�� �븮        POS������              T) 02-2109-9881   seyoungkim@smartro.co.kr
                                                     H) 010-4125-6894
  KCP      ������ ����        �ַ�� ������          T) 070-7595-1221  jpjung@kcp.co.kr
           �ּ��� ���        �ַ�� ������          T) 070-7595-1225  sechoi@kcp.co.kr
           ����� ���        �����󺻺� VAN��       T) 070-7595-1219  mtkim@kcp.co.kr
                                                     H) 010-2323-5486
  DAOU     �ǿ�ȯ �븮        �¶��ΰ�����           T) 02-3410-5172   ohkwon@daoudata.co.kr
  KOVAN    �ڱⳲ å�ӿ�����  ClientSystem ������    T) 070-4000-9148  kinam@kovan.com
  SPC      ������ ����        ����������             T) 02-2276-6757   haji2101@spc.co.kr
                                                     H) 010-2970-8105
           ������ ���        ����������             T) 02-2276-6763   impact@spc.co.kr
                                                     H) 010-4880-5822
*******************************************************************************)
unit uVanDaemonModule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils, Math, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdGlobal, IdSync, IdURI, IdTCPClient, IdHTTP,
  {$IF RTLVersion < 19.00}
  ScktComp,
  {$IFEND}
  ShellApi, uVanFunctions, KisPosAgentLib_TLB, SmtSndRcvVCATLib_TLB;

const
  // ��� �ڵ�
  VAN_CODE_KFTC    = 'KFTC';
  VAN_CODE_KICC    = 'KICC';
  VAN_CODE_KIS     = 'KIS';
  VAN_CODE_FDIK    = 'FDIK';
  VAN_CODE_KOCES   = 'KOCES';
  VAN_CODE_KSNET   = 'KSNET';
  VAN_CODE_JTNET   = 'JTNET';
  VAN_CODE_NICE    = 'NICE';
  VAN_CODE_SMARTRO = 'SMARTRO';
  VAN_CODE_KCP     = 'KCP';
  VAN_CODE_DAOU    = 'DAOU';
  VAN_CODE_KOVAN   = 'KOVAN';
  VAN_CODE_SPC     = 'SPC';

type
  // ���� �������� (������)
  TCardSendInfoDM = record
    // ���� ���� ����
    Approval: Boolean;                 // ����/��� ����
    SaleAmt: Currency;                 // ����(����)�ݾ� (��ǥ�ݾ�)
    SvcAmt: Currency;                  // �����
    VatAmt: Currency;                  // �ΰ���
    FreeAmt: Currency;                 // �鼼�ݾ�
    CardNo: AnsiString;                // ī���ȣ(Key-in�ŷ��� -> ī���ȣ=��ȿ�Ⱓ)
    KeyInput: Boolean;                 // Ű�ο���
    TrsType: AnsiString;               // �ŷ�����('':�Ϲݽſ�, 'A':��ī��)
    OrgAgreeNo: AnsiString;            // �����ι�ȣ(��ҽ�)
    OrgAgreeDate: AnsiString;          // ����������(��ҽ�)
    // �ſ�ī�� ����
    HalbuMonth: Integer;               // �Һΰ���
    EyCard: Boolean;                   // ����ī�� �ŷ�

    // ���ݿ����� ����
    Person: Integer;                   // �ŷ�(����/�����)���� (1:�ҵ����, 2:��������, 3:�����߱�)
    CancelReason: Integer;             // ��һ����ڵ� (1:�ŷ����, 2:�����߱�, 3:��Ÿ)
    // ��ǥ��ȸ ����
    CheckNo: AnsiString;               // ��ǥ��ȣ
    BankCode: AnsiString;              // ���������ڵ�
    BranchCode: AnsiString;            // �������� �������ڵ�
    KindCode: AnsiString;              // �����ڵ� (13:10����, 14:30����, 15:50����, 16:100����, 19:��Ÿ)
    RegDate: AnsiString;               // ��ǥ������
    AccountNo: AnsiString;             // �����Ϸù�ȣ(��������/������ ���)
    // ���� ���� : ��纰�� ó�� ����� �ٸ� (�Ʒ� �ּ� ���� ����)
    TerminalID: AnsiString;            // ���� TID
    BizNo: AnsiString;                 // ����ڹ�ȣ
    SignOption: AnsiString;            // ����ŷ� �ɼ� (Y:������, N:������, R:����, T:ȭ�鼭��)
    Reserved1: AnsiString;             // �����׸�1
    Reserved2: AnsiString;             // �����׸�2
    Reserved3: AnsiString;             // �����׸�3
    OTCNo: AnsiString;                 // ��ī�� OTC��ȣ
    CardBinNo: AnsiString;             // ī�� Bin��ȣ
  end;

(*
  << TerminalID : ����TID >>

  KFTC    : ���� ����� �����ÿ��� ��� (���� ���� ����, ���Է½� ���� ������ ���)
  Kicc    : ���� ����� �����ÿ��� ��� (���� ���� ����)
  Kis     : ���� ����� �����ÿ��� ��� (���� ���� ����, ���Է½� ���� ������ ���)
  FDIK    : �ʼ� �Է� (�ܸ��� ��ȣ ��� ��ǰ �Ϸ� ��ȣ�� �Է���)
  Koces   : ���� ����� �����ÿ��� ��� (���� ���� ����, ȯ�漳�� ��й�ȣ: 3415)
  KSNET   : �ʼ� �Է� (���� ���� ����)
  JTNET   : �ʼ� �Է� (���� ���� ����)
  Nice    : ���� ����� �����ÿ��� ��� (���� ���� ����, ���Է½� ���� ������ ���)
  Smartro : ���� ����� �����ÿ��� ��� (���� ���� ����, ȯ�漳�� ��й�ȣ: 7279 ��Ÿ����->��Ÿ�����ǿ��� VCAT UI�� ǥ��, Ȱ��ȭ ��� �����Կ� üũ�Ұ�.)
  KCP     : ���� ȯ�漳���� ���� �ܸ��� ��뿡 üũ�� ��쿡�� ����
  DAOU    : �ʼ� �Է� (���� ���� ����)
  KOVAN   : (ȯ�漳�� ID:0000 PW:1234)
  SPC     : �ʼ� �Է� (���� ���� ����), �������ٿ�ε带 �������� �ؾ��� ���� ����

  << BizNo : ����ڹ�ȣ >>

  KFTC    : ������
  Kicc    : ������
  Kis     : ������
  FDIK    : ���� �ŷ��� �ʼ� �Է�
  Koces   : ���� ����� �����ÿ��� ���
  KSNET   : ������
  JTNET   : ������
  Nice    : ������
  Smartro : ������
  KCP     : ������
  DAOU    : ������
  KOVAN   : ���� ����� �����ÿ��� ���
  SPC     : ������ �ٿ�ε�� ����ڹ�ȣ �ʼ��Է�

  << SignOption : ���� �ŷ� �ɼ� >>
    Y : ������ �����е带 �����.(��ġ ��Ʈ �� �ӵ��� ���õǾ� �־�� ��)
    N : ���� ����. (�����е尡 �����Ǿ� ������ ���� ���� ���� ó�� �ϰ��� �Ҷ� ���)
    R : �������� ����(���� ����� �����϶� �� ��ǥ���� ���� ī��� �ι��� ������ �Ҷ� ���� �ŷ��� ������ ���� �ϰ��� �Ҷ� ���)
    T : ȭ�鼭�� ó�� (Ű����ũ�� ���� ������ �����е� ���� ȭ�� ��ġ������� ó����)

  KFTC    : ��밡�� �ɼ� -> Y, N  ������ ����� �̱���
  Kicc    : ��� ����. ���� ȯ�漳������ ��� ������.
  Kis     : ��밡�� �ɼ� -> Y, N, R ȭ�鼭���� ���������� �����е� Port�� -1���� �����Ѵ�.
  FDIK    : ��밡�� �ɼ� -> Y, N ȭ�鼭���� ȯ�漳�� INI ���Ͽ��� �����Ѵ�. CFG/Win4POS.ini -> VirtualSignpadUseYN=Y
  Koces   : ��� ����. ���� ȯ�漳������ ��� ������.
  KSNET   : ��밡�� �ɼ� -> Y, N, R, T
  JTNET   : ��밡�� �ɼ� -> Y, N, R ȭ�鼭���� ���������� �����е� Port�� 0���� �����Ѵ�.
  Nice    : ��� ����. ���� ȯ�漳������ ��� ������.
  Smartro : ��밡�� �ɼ� -> Y, N ȭ�鼭���� ���󿡼� ������.
  KCP     : ��� ����. ���� ȯ�漳������ ��� ������.
  DAOU    : ��밡�� �ɼ� -> T ���� �������� Ű����ũ ���� �����Ұ�. (INI���� IS_KIOSK=Y)
  KOVAN   : ��밡�� �ɼ� -> Y, R
  SPC     : ��밡�� �ɼ� -> Y, N, R ȭ�鼭���� ���������� �����е� Port�� �����Ѵ�.

  << Reserved1~3 : �����׸� >>

  KFTC    : ������
  Kicc    : ������
  Kis     : ������
  FDIK    : ������
  Koces   : ���� ����� ������ Reserved1�� �ø����ȣ�� �Է��Ѵ�.
  KSNET   : ������
  JTNET   : ������
  Nice    : ������
  Smartro : ������
  KCP     : �׽��� ������϶� Reserved1�� R/N��ȣ�� �ִ´�. (OFFPG�ŷ�)
  DAOU    : Reserved1�� �λ���� �ܸ����ȣ�� �ִ´�. (���߻���� ������ �λ���ڷ� ���� �޴� ��츸 ���)
            �ֻ���� �����ÿ��� ��ĭ���� �ִ´�. (ini ���Ͽ� ���߻���� ���� ������ �ؾ���.)
  KOVAN   :
  SPC     : Reserved1�� ���߻���� ������ 'Y'�� �ִ´�.
*)

  // ���� �������� (������)
  TCardRecvInfoDM = record
    // ���� ����
    Result: Boolean;                   // ��������
    Code: AnsiString;                  // �����ڵ�
    Msg: AnsiString;                   // ����޼���
    AgreeNo: AnsiString;               // ���ι�ȣ
    AgreeDateTime: AnsiString;         // �����Ͻ�(yyyymmddhhnnss)
    CardNo: AnsiString;                // ����ŷ ī���ȣ
    // �ſ�ī�� �����϶��� �Ʒ� ������ ���õ�.
    TransNo: AnsiString;               // �ŷ���ȣ
    BalgupsaCode: AnsiString;          // �߱޻��ڵ�
    BalgupsaName: AnsiString;          // �߱޻��
    CompCode: AnsiString;              // ���Ի��ڵ�
    CompName: AnsiString;              // ���Ի��
    KamaengNo: AnsiString;             // ��������ȣ
    AgreeAmt: Integer;                 // ���αݾ�
    DCAmt: Integer;                    // ���αݾ�
    // �ſ���� ������� (��翡 ���� ������. �ʼ� �׸��� �ƴϹǷ� ���� �Ұ�.)
    IsSignOK: Boolean;                 // ���� ���� ���� (���������� �ش� ���� ���� ��� True ������)
    CardBinNo: AnsiString;             // ī�� Bin��ȣ
  end;

  // �� ������ ���� ���
  TVanDaemon = class
  private
  public
    Log: TLog;
    constructor Create; virtual;
    destructor Destroy; override;
    // ���ðŷ� (������ �ٿ�ε�)
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; virtual; abstract;
    // �ſ�ī�� ����
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // ���ݿ����� ����
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // ����IC ����
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // ��ǥ��ȸ
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // ���е� �Է�
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // ī������ ��ȸ
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // ���Ἲ üũ
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // ī�� ���Կ��� üũ
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean; virtual; abstract;
  end;

  // �� ���� ���
  TVanDaemonModule = class
  private
    FLog: TLog;
    FVanCode: string;
    procedure SetVanCode(const Value: string);
  public
    // �⺻��
    MainVan: TVanDaemon;

    constructor Create; virtual;
    destructor Destroy; override;
    // ���ðŷ� (������ �ٿ�ε�)
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
    // �ſ�ī�� ����
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ���ݿ����� ����
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ����IC ����
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ��ǥ��ȸ
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ���е� �Է�
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
    // ī������ ��ȸ
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ���Ἲüũ
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
    // ī�� ���Կ��� üũ
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;

    // ��ü ȯ�� ���� ���� ó��
    function ApplyConfigAll: Boolean;
    // VAN��
    property VanCode: string read FVanCode write SetVanCode;
  end;

  // KFTC
  TVanKFTCDaemon = class(TVanDaemon)
  private
    function GetStringSearch(AFID, AStr: string): string;
    function ExecTcpSendData(ASendData: string; out ARecvData: string): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Kicc
  TVanKiccDaemon = class(TVanDaemon)
  private
    FIndy: TIdHTTP;
    function GetSeqNoKICC: AnsiString;
    function ExecHttpSendRecv(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function MakeSendData(ATranCode, ASignData: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvData(ARecvData: AnsiString): TCardRecvInfoDM;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Kis
  TVanKisDaemon = class(TVanDaemon)
  private
    KisPosAgent: TKisPosAgent;
    function ExecOcx(ATranCode: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // FDIK
  TVanFDIKDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    FDaemonRunCheck: Boolean;
    // ���� ���α׷� ���� ���� ���θ� üũ�Ͽ� ���� ���� �ش�.
    function CheckDaemonRun(out AErrorMsg: AnsiString): Boolean;
    function DoCallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    function DoCallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    function DoCallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Koces
  TVanKocesDaemon = class(TVanDaemon)
  private
    FDllHandle: THandle;
    // ������ ���� Ȯ�� (���� ����� ���忡�� ���)
    function ExecDownLoadRequest(ATerminalID, ASerial, ABizNo: AnsiString): TCardRecvInfoDM;
    // ���� ȣ��
    function ExecICRequest(ATrdType, AKeyYN: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // ��ī��
    function ExecAppCardRequest(ATrdType: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KSNET
  TVanKsnetDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(ATransGubun: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // JTNET
  TVanJtnetDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecAblity(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function DLLExecAuth(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Nice
  TVanNiceDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecVCat(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Smartro
  TVanSmartroDaemon = class(TVanDaemon)
  private
    SmtSndRcvVCAT: TSmtSndRcvVCAT;
    function SetSendData(const AIndex: Integer; const AValue: AnsiString; out ARetMsg: AnsiString): Boolean;
    function GetRecvData(const AIndex: Integer): AnsiString;
    function GetErrorMsg(ACode: Integer): AnsiString;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KCP
  TVanKcpDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataHeader(AApproval: Boolean; AProcCode, ATerminalID: AnsiString; ADetailSendData: AnsiString): AnsiString;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecTrans(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function DLLExecFunction(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    // ������ �ٿ�ε� (��Ƽ TID �����忡�� �����)
    function DoPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean; override;
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean; override;
  end;

  // DAOU
  TVanDaouDaemon = class(TVanDaemon)
  private
    FReceiveBuff: string;
    function ExecTcpSendData(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    {$IF RTLVersion < 19.00}
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    function SocketSendReceiveData(AClientSocket: TClientSocket; ASendData: string; out ARecvData: string): Boolean;
    {$IFEND}
    function GetErrorMsg(ACode: AnsiString): AnsiString;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KOVAN
  TVanKovanDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function DLLExec(ATCode, ATID, AHalbu, ATAmt, AOriDate, AOriAuthNo, ATranSerial, AIdNo, AAmtFlag, ATaxAmt, ASfeeAmt, AFreeAmt, AFiller: AnsiString;
                     out ARecvTranType, ARecvErrCode, ARecvCardno, ARecvHalbu, ARecvTamt, ARecvTranDate, ARecvTranTime, ARecvAuthNo, ARecvMerNo, ARecvTranSerial,
                     ARecvIssueCard, ARecvPurchaseCard, ARecvSignPath, ARecvMsg1, ARecvMsg2, ARecvMsg3, ARecvMsg4, ARecvFiller: AnsiString): Boolean;
    function DoCallExec(ATCode, AHalbu: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // SPC
  TVanSpcDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function GetErrorMsg(ACode: Integer): AnsiString;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

implementation

uses
  IniFiles, uKisPosAgentForm, uLkJSON;

type
  // KOCESS
  // ���� header �κ�
  TPGFComHead = record
    ApprVer: array[0..1] of AnsiChar;      // �������� "A1"
    SvcType: array[0..1] of AnsiChar;      // �������� ��������ǥ ����
    TrdType: array[0..1] of AnsiChar;      // ���� ����, ��������ǥ ����
    SndType: AnsiChar;                     // ���۱���, 'S': PG->VAN, 'R': VAN->PG
    TermId : array[0..9] of AnsiChar;      // �ܸ����ȣ �͹̳ξ��̵�
    TrdDate: array[0..13] of AnsiChar;     // �ŷ��Ͻ� YYMMDDhhmmss
    TrdNo  : array [0..9] of AnsiChar;     // �ŷ��Ϸù�ȣ (����� ��ȯ)
    MchData: array [0..19] of AnsiChar;    // ������ ����Ÿ (����� ��ȯ)
    AnsCode: array[0..3] of AnsiChar;      // �����ڵ� (��û�ô� �����̽�)
  end;
  // �ſ���� ����
  TPosICResAppr = record
    Header    : TPGFComHead;               // ���� ��� �κ�
    TradeNo   : array[0..11] of AnsiChar;  // Van �� �ο��ϴ� �ŷ� ������ȣ
    AuNo      : array[0..11] of AnsiChar;  // ���ι�ȣ
    TradeDate : array[0..13] of AnsiChar;  // ���νð� 'YYMMDDhhmmss'
    Message   : array[0..31] of AnsiChar;  // ���� �޽���(���� �� ���� Message)
    CardNo    : array[0..39] of AnsiChar;  // ī�� Bin
    CardKind  : array[0..11] of AnsiChar;  // ī��������
    OrdCd     : array[0..3] of AnsiChar;   // �߱޻� �ڵ�
    OrdNm     : array[0..11] of AnsiChar;  // �߱޻� ��
    InpCd     : array[0..3] of AnsiChar;   // ���Ի� �ڵ�
    InpNm     : array[0..7] of AnsiChar;   // ���Ի� ��
    MchNo     : array[0..15] of AnsiChar;  // ��������ȣ
    PtCardCd  : array[0..1] of AnsiChar;   // ����Ʈī�� �ڵ�
    PtCardNm  : array[0..7] of AnsiChar;   // ����Ʈī��� ��
    JukPoint  : array[0..8] of AnsiChar;   // ��������Ʈ
    GayPoint  : array[0..8] of AnsiChar;   // ��������Ʈ
    NujPoint  : array[0..8] of AnsiChar;   // ��������Ʈ
    SaleRate  : array[0..8] of AnsiChar;   // ������
    PtAuNo    : array[0..19] of AnsiChar;  // �������ι�ȣ
    PtMchNo   : array[0..14] of AnsiChar;  // ������������ȣ
    PtAnswerCd: array[0..3] of AnsiChar;   // ���������ڵ�
    PtMessage : array[0..47] of AnsiChar;  // ��������޼���
    DDCYN     : AnsiChar;                  // DDC ����
    EDIYN     : AnsiChar;                  // EDI ����
    CardType  : AnsiChar;                  // ī�屸��  (1:�ſ�, 2:üũ, 3:����Ʈ, 4:����)
    TrdKey    : array[0..11] of AnsiChar;  // �ŷ� ����Ű
    KeyRenewal: array[0..1] of AnsiChar;   // Ű ��������
    Filler    : array [0..49] of AnsiChar; // �����ʵ�
  end;
  // ��ǥ��ȸ ����
  TPGFICBillAppr = record
    Header : TPGFComHead;                  // ���� ��� �κ�
    Message: array[0..39] of AnsiChar;     // ����޼���
    Filler : array[0..19] of AnsiChar;     // Filler
  end;
  // ������ Ȯ��
  TDownResAppr = record
    Header : TPGFComHead;                  // ���� ��� �κ�
    Serial : array[0..19] of AnsiChar;     // �����Ϸù�ȣ
    Message: array[0..39] of AnsiChar;     // ����޼���
    SftVer : array[0..4] of AnsiChar;      // �ܸ��� SW ����
    ShpNm  : array[0..39] of AnsiChar;     // ��������Ī
    BsnNo  : array[0..9] of AnsiChar;      // ����������ڹ�ȣ
    PreNm  : array[0..19] of AnsiChar;     // ��ǥ�ڸ�
    ShpAdr : array[0..49] of AnsiChar;     // �������ּ�
    ShpTel : array[0..14] of AnsiChar;     // ��������ȭ��ȣ
  end;

  // FDIK
  TFDIK_Daemon_Status    = function(): Integer; stdcall;
  TFDIK_Daemon_MKTranId  = function(Buffer: PAnsiChar; BufferLen: Integer): Integer; stdcall;
  TFDIK_Daemon_Init      = function(TranId, MsgCmd, MsgCert: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Input     = function(Key, Value: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Execute   = function(): Integer; stdcall;
  TFDIK_Daemon_Create    = function(Server, Port: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Output    = function(Key, Buffer: pAnsiChar; Len: Integer): Integer; stdcall;
  TFDIK_Daemon_Destroy   = function(): Integer;
  TFDIK_Daemon_Term      = Function(): Integer;

const
  MSG_ERR_DLL_LOAD        = ' ������ �ҷ��� �� �����ϴ�.';
  MSG_ERR_SET_CONFIG_FAIL = '�ش� ������ ���� ������ ��翡���� ����� �� �����ϴ�.' + #13#10 +
                            '(��翡�� �����ϴ� ���α׷����� ���� �����ϰų� ������ ����)';

  STX              = #2;   // Start of Text
  ETX              = #3;   // End of Text
  EOT              = #4;   // End of Transmission
  ENQ              = #5;   // ENQuiry
  ACK              = #6;   // ACKnowledge
  NAK              = #$15; // Negative Acknowledge (#21)
  FS               = #$1C; // Field Separator (#28)
  CR               = #13;  // Carriage Return
  SI               = #15;

  CASH_RCP_AUTO_NUMBER = '0100001234'; // ���ݿ����� ���� �߱� ó�� ��ȣ

  // KSNET
  KSNET_DAEMON_DLL  = 'ksnetcomm.dll';
  KSNET_SOLBIPOS    = 'SOLB'; // ��ü����

  // JTNET
  JTNET_DAEMON_DLL  = 'JTPosSeqDmDll.dll';

  // NICE
  NICE_DAEMON_DLL   = 'NVCAT.dll';

  // KCP
  LIBKCP_SECURE_DLL = 'libKCPSecure.dll';
  KCP_VER_INFO      = 'PSOB'; // �ֺ����� �ID

  // FDIK
  WIN4POS_DLL       = 'Win4POSDll.dll';

  // Koces
  filKOCESIC_DLL      = 'KocesICLib.dll';
  filKOCESIC_DLL_Path = 'C:\Koces\KocesICPos\';
  MSG_SOLBIPOS        = 'Solbipos POS System';

  // DAOU
  TERMINAL_GUBUN1   = '4             ';  // �ܸ�������(�Ϲ�)
  TERMINAL_GUBUN2   = 'Y             ';  // �ܸ�������(���߻����)

  // KOVAN
  KOVAN_DAEMON_DLL  = 'VPos_Client.dll';

  // SPC
  SPC_DAEMON_DLL    = 'SpcnVirtualDll.dll';

{ TVanDaemon }

constructor TVanDaemon.Create;
begin
  Log := TLog.Create;
end;

destructor TVanDaemon.Destroy;
begin
  Log.Free;
  inherited;
end;

{ TVanDaemonModule }

constructor TVanDaemonModule.Create;
begin
  FLog := TLog.Create;
  FLog.Write(ltInfo, ['VanDaemonModul', '2019.01.23.1']);
end;

destructor TVanDaemonModule.Destroy;
begin
  FLog.Write(ltInfo, ['VanDaemonModul', 'Destroy']);
  FLog.Free;
  if MainVan <> nil then
    MainVan.Free;
  inherited;
end;

function TVanDaemonModule.ApplyConfigAll: Boolean;
begin
  FLog.Write(ltInfo, ['VanDaemonModul��ü��������', FVanCode]);
  if MainVan <> nil then
    FreeAndNil(MainVan);

  if FVanCode = VAN_CODE_KFTC then
    MainVan := TVanKftcDaemon.Create
  else if FVanCode = VAN_CODE_KICC then
    MainVan := TVanKiccDaemon.Create
  else if FVanCode = VAN_CODE_KIS then
    MainVan := TVanKisDaemon.Create
  else if FVanCode = VAN_CODE_FDIK then
    MainVan := TVanFdikDaemon.Create
  else if FVanCode = VAN_CODE_KOCES then
    MainVan := TVanKocesDaemon.Create
  else if FVanCode = VAN_CODE_KSNET then
    MainVan := TVanKsnetDaemon.Create
  else if FVanCode = VAN_CODE_JTNET then
    MainVan := TVanJtnetDaemon.Create
  else if FVanCode = VAN_CODE_NICE then
    MainVan := TVanNiceDaemon.Create
  else if FVanCode = VAN_CODE_SMARTRO then
    MainVan := TVanSmartroDaemon.Create
  else if FVanCode = VAN_CODE_KCP then
    MainVan := TVanKcpDaemon.Create
  else if FVanCode = VAN_CODE_DAOU then
    MainVan := TVanDaouDaemon.Create
  else if FVanCode = VAN_CODE_KOVAN then
    MainVan := TVanKovanDaemon.Create
  else if FVanCode = VAN_CODE_SPC then
    MainVan := TVanSpcDaemon.Create;

  if MainVan <> nil then
    MainVan.Log.DebugLog := True;

  Result := MainVan <> nil;
end;

function TVanDaemonModule.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['���ðŷ�DM', FVanCode, '�ܸ����ȣ', ATerminalID, '����ڹ�ȣ', ABizNo]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  try
    Result := MainVan.CallPosDownload(ATerminalID, ABizNo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['���ðŷ�DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['���ðŷ�DM', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanDaemonModule.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['�ſ����DM', FVanCode, '����/���', AInfo.Approval, 'KeyIn', AInfo.KeyInput, 'ī���ȣ', AInfo.CardNo,
                       '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt,
                       '�ŷ�����', AInfo.TrsType, '�����ι�ȣ', AInfo.OrgAgreeNo, '����������', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '�����', AInfo.BizNo, '����ɼ�', AInfo.SignOption,
                       '����1', AInfo.Reserved1, '����2', AInfo.Reserved2, '����3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);
  try
    // �� ���� ��� ȣ��
    Result := MainVan.CallCard(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['�ſ����DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['�ſ���DM', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', Result.AgreeAmt, '���ι�ȣ', Result.AgreeNo, '�����Ͻ�', Result.AgreeDateTime, 'ī���ȣ', Result.CardNo]);
end;

function TVanDaemonModule.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['���ݽ���DM', FVanCode, '����/���', AInfo.Approval, 'KeyIn', AInfo.KeyInput, '����', AInfo.Person, '�ĺ���ȣ', AInfo.CardNo,
                       '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt,
                       '�����ι�ȣ', AInfo.OrgAgreeNo, '����������', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '�����', AInfo.BizNo, '����ɼ�', AInfo.SignOption, '����1', AInfo.Reserved1, '����2', AInfo.Reserved2, '����3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  // ���� �߱� �϶�
  if (AInfo.Person = 3) and (AInfo.CardNo = '') then
    AInfo.CardNo := CASH_RCP_AUTO_NUMBER;
  if AInfo.CardNo = CASH_RCP_AUTO_NUMBER then
    AInfo.Person := 3;

  try
    Result := MainVan.CallCash(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['���ݽ���DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['���ݰ��DM', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', Result.AgreeAmt, '���ι�ȣ', Result.AgreeNo, '�����Ͻ�', Result.AgreeDateTime, 'ī���ȣ', Result.CardNo]);
end;

function TVanDaemonModule.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['����ICDM', FVanCode, '����/���', AInfo.Approval, 'KeyIn', AInfo.KeyInput, 'ī���ȣ', AInfo.CardNo,
                       '�ŷ��ݾ�', AInfo.SaleAmt, '�����', AInfo.SvcAmt, '�ΰ���', AInfo.VatAmt, '�鼼�ݾ�', AInfo.FreeAmt,
                       '�����ι�ȣ', AInfo.OrgAgreeNo, '����������', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '�����', AInfo.BizNo, '����ɼ�', AInfo.SignOption, '����1', AInfo.Reserved1, '����2', AInfo.Reserved2, '����3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  // ��ȣ �����
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);
  try
    // �� ���� ��� ȣ��
    Result := MainVan.CallCashIC(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['����ICDM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['����IC���DM', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '���αݾ�', IntToStr(Result.AgreeAmt), '���ι�ȣ', Result.AgreeNo, '�����Ͻ�', Result.AgreeDateTime, 'ī���ȣ', Result.CardNo]);
end;

function TVanDaemonModule.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['��ǥ��ȸDM', FVanCode, '�ݾ�', AInfo.SaleAmt]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  try
    Result := MainVan.CallCheck(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['��ǥ��ȸDM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['��ǥ��ȸDM', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanDaemonModule.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['���е�DM', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  try
    Result := MainVan.CallPinPad(ASendAmt, ARecvData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['���е�DM', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['���е�DM', ARecvData]);
end;

function TVanDaemonModule.CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  FLog.Write(ltBegin, ['ī������ ��ȸ', FVanCode]);
  if MainVan = nil then
  begin
    Result.Msg := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;

  Result := MainVan.CallCardInfo(AInfo);
end;

function TVanDaemonModule.CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['���Ἲüũ', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  Try
    Result := MainVan.CallICReaderVerify(ATerminalID, ARecvData);
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['���Ἲüũ', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltError, ['���Ἲüũ', ARecvData]);
end;

function TVanDaemonModule.CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARespCode := '';
  ARecvData := '';
  FLog.Write(ltBegin, ['ICī����Կ���üũ', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARespCode := '????';
    ARecvData := 'VAN�簡 �����Ǿ� ���� �ʽ��ϴ�.';
    Exit;
  end;
  try
    Result := MainVan.CallICCardInsertionCheck(ATerminalID, ASamsungPay, ARespCode, ARecvData);
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['ICī����Կ���üũ', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltError, ['ICī����Կ���üũ', ARecvData]);
end;

procedure TVanDaemonModule.SetVanCode(const Value: string);
begin
  FVanCode := Value;
end;

{ TVanKFTCDaemon }

constructor TVanKFTCDaemon.Create;
begin
  inherited;

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

function TVanKFTCDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKFTCDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr, SignData: string;
begin
  Result.Result := False;

  // ���� ����Ÿ�� �����.
  if AInfo.EyCard then
    Gubun := IfThen(AInfo.Approval, 'C1', 'C2')
  else
  begin
    if AInfo.SignOption = 'Y' then
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
                'x' + AInfo.TerminalID // �ܸ����ȣ
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
                'x' + AInfo.TerminalID; // �ܸ����ȣ

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
  Result.AgreeDateTime := '20' + Copy(TempStr, 4, 12);
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
  Result.CardNo := GetStringSearch('q', RecvData);
  //Result.CardNo := Copy(Result.CardNo, 1, 6); //ī�� �� Bin �κи� �����Ѵ�.
  // ��������ȣ
  Result.KamaengNo := GetStringSearch('d', RecvData);
  // ���αݾ�
  Result.AgreeAmt := StrToIntDef(GetStringSearch('B', RecvData), 0);
  // ���αݾ� (���������� ����)
  Result.DCAmt := 0;
  // ���� ����Ÿ
  SignData := GetStringSearch('z', RecvData);
  Result.IsSignOK := Length(SignData) > 0;
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr: string;
begin
  Result.Result := False;

  // ���� ����Ÿ�� �����.
  if AInfo.Person = 2 then
    Gubun := IfThen(AInfo.Approval, 'B7', 'B9')  // ��������
  else
    Gubun := IfThen(AInfo.Approval, 'B6', 'B8'); // �ҵ����

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
                'x' + AInfo.TerminalID // �ܸ��� ��ȣ
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
                'x' + AInfo.TerminalID; // �ܸ��� ��ȣ

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
  Result.AgreeDateTime := '20' + Copy(TempStr, 4, 12);
  // ����޼���
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // ���ι�ȣ
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // ī���ȣ
  Result.CardNo := GetStringSearch('q', RecvData);
  //Result.CardNo := Copy(Result.CardNo, 1, 6); //ī�� �� Bin �κи� �����Ѵ�.
  // ��������
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����';
end;

function TVanKFTCDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData, TempStr: string;
begin
  Result.Result := False;
  // ���� ����Ÿ�� �����.
  SendData := 'I0' + FS + // ��������
              'B' + CurrToStr(AInfo.SaleAmt) + FS + // ��ǥ�ݾ�
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
  // ����޼���
  Result.Msg := GetStringSearch('g', RecvData);
  // ��������
  Result.Result := Result.Code = '000';
end;

//{function TVanKFTCDaemon.CallICReaderVerify(out ARecvData: AnsiString): Boolean;
//var
//  RecvData, TempStr: string;
//begin
//  Result := False;
//  case AWorkGubun of
//    IC_READER_WORK_STATUS :
//      begin
//        if not ExecTcpSendData('R1', RecvData) then
//        begin
//          ARecvData := RecvData;
//          Exit;
//        end;
//        // ���� ����Ÿ�� �����.
//        TempStr := StringSearch(RecvData, FS, 0);
//        // ��������
//        Result := Copy(TempStr, 16, 3) = 'S00';
//        // ����޼���
//        ARecvData := GetStringSearch('g', RecvData);
//      end;
//  end;
//end;}

function TVanKFTCDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����';
end;

{ TVanKiccDaemon }

constructor TVanKiccDaemon.Create;
begin
  inherited;
  FIndy := TIdHTTP.Create(nil);
end;

destructor TVanKiccDaemon.Destroy;
begin
  FreeAndNil(FIndy);
  inherited;
end;

function TVanKiccDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode, SendData, RecvData: AnsiString;
begin
  if AInfo.Approval then
    TranCode := IfThen(AInfo.EyCard, 'U1', 'D1')
  else
    TranCode := IfThen(AInfo.EyCard, 'U4', 'D4');

  SendData := MakeSendData(TranCode, '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode, SendData, RecvData: AnsiString;
begin
  if AInfo.Approval then
  begin
    if AInfo.Person = 3 then
      TranCode := 'B3'
    else
      TranCode := 'B1';
  end
  else
  begin
    if AInfo.Person = 3 then
      TranCode := 'B4'
    else
      TranCode := 'B2';
  end;

  SendData := MakeSendData(TranCode, '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallCashIC(
  AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKiccDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendData('C1', '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

function TVanKiccDaemon.CallPosDownload(ATerminalID,
  ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKiccDaemon.MakeRecvData(ARecvData: AnsiString): TCardRecvInfoDM;
var
  MainJson: TlkJSONobject;
  Pos1, Pos2: Integer;
  JSonText: string;
begin
  Result.Result := False;
  JSonText := ARecvData;
  // JSON ���ڿ� �յڷ� ���� ���ʿ��� ���ڿ� ���� jsonp12345678983543344({'SUC':'01','MSG':'not Found VAN Info '}) euc-kr
  Pos1 := Pos('({', JSonText);
  Pos2 := Pos('})', JSonText);
  JSonText := Copy(JSonText, Pos1+1, Pos2-Pos1);
  JSonText := StringReplace(JSonText, '''', '"', [rfReplaceAll]); // ����ǥ ����
  try
    try
      MainJson := TlkJSON.ParseText(JSonText) as TlkJSONobject;
      if MainJson = nil then
      begin
        Result.Msg := 'JSON �Ľ� Error';
        Exit;
      end;
      Result.Code := MainJson.Field['SUC'].Value;
      Result.Result := Result.Code = '00';
      if Result.Result then
      begin
        Result.Result        := (MainJson.Field['RS04'].Value = '0000');       // ��������
        Result.Code          := VarToStr(MainJson.Field['RS04'].Value);        // �����ڵ�
        Result.CompCode      := VarToStr(MainJson.Field['RS05'].Value);        // ���Ի��ڵ�
        Result.AgreeDateTime := '20' + VarToStr(MainJson.Field['RS07'].Value); // �����Ͻ�(yyyymmddhhnnss)
        Result.TransNo       := VarToStr(MainJson.Field['RS08'].Value);        // �ŷ���ȣ
        Result.AgreeNo       := VarToStr(MainJson.Field['RS09'].Value);        // ���ι�ȣ
        Result.BalgupsaCode  := VarToStr(MainJson.Field['RS11'].Value);        // �߱޻��ڵ�
        Result.BalgupsaName  := VarToStr(MainJson.Field['RS12'].Value);        // �߱޻��
        Result.KamaengNo     := VarToStr(MainJson.Field['RS13'].Value);        // ��������ȣ
        Result.CompName      := VarToStr(MainJson.Field['RS14'].Value);        // ���Ի��
        Result.Msg           := Trim(VarToStr(MainJson.Field['RS16'].Value) +
                                VarToStr(MainJson.Field['RS17'].Value));       // ����޼���
        Result.IsSignOK      := VarToStr(MainJson.Field['RS18'].Value) = 'Y';  // ���ڼ�����
        Result.CardNo        := VarToStr(MainJson.Field['RQ04'].Value);        // ����ŷ�� ī���ȣ
        Result.AgreeAmt      := MainJson.Field['RQ07'].Value;                  // ���αݾ�
        Result.DCAmt         := 0;                                             // ���αݾ�
      end
      else
        Result.Msg := VarToStr(MainJson.Field['MSG'].Value);
    except on E: Exception do
      Result.Msg := E.Message;
    end;
  finally
    MainJson.Free;
  end;
end;

function TVanKiccDaemon.MakeSendData(ATranCode, ASignData: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
var
  TransNo: AnsiString;
begin
  TransNo := GetSeqNoKICC;
  // 1. ��������
  //    D1 : ���� D4 : �������/�������(��ǰȯ��)
  //    B1 : ���ݽ���(����) B2 : �������(����)
  //    B3 : �����߱� B4 : �����߱����
  //    U1 : ���ý��� U4 : ���ô������/�������(��ǰȯ��)
  //    C1 : ��ǥ��ȸ
  Result := ATranCode + '^';
  // 2. ���ݿ����� �ŷ��뵵 [ ���ݿ����� : ��00��: �������� ��01��: ��������� ]
  if (ATranCode = 'B1') or (ATranCode = 'B2') or (ATranCode = 'B4') or (ATranCode = 'B3') then
    Result := Result + IfThen(AInfo.Person = 2, '01', '00') + '^'
  else
    Result := Result + '^';
  // 3. �ݾ�
  Result := Result + CurrToStr(AInfo.SaleAmt) + '^';
  // 4. �Һ�
  //    00: �Ͻú� N : �Һ�N���� ��) �Һ� 3���� : 03
  //    ��ǥ��ȸ : ���� (10����: 13, 30���� : 14, 50���� : 15, 100���� : 16, �ڱ�ռ�ǥ��Ÿ�ݾ� : 19, ���¼�ǥ : 31, �����ǥ : 42)
  //    ���ݿ����� ��� �� : 1: ����� 2: �����߱� 3: ��Ÿ
  if (ATranCode = 'B2') then
    Result := Result + IntToStr(AInfo.CancelReason) + '^'
  else if (ATranCode = 'C1') then
    Result := Result + AInfo.KindCode + '^'
  else if (ATranCode = 'D1') or (ATranCode = 'D4') then
    Result := Result + IntToStr(AInfo.HalbuMonth) + '^'
  else
    Result := Result + '^';
  // 5. ��� ����������  [ YYMMDD ]
  if (ATranCode = 'B2') or (ATranCode = 'B4') or (ATranCode = 'D4') or (ATranCode = 'U4') then
  begin
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(AInfo.OrgAgreeDate, 3, 6) + '^'
  end
  else if (ATranCode = 'C1') then
    Result := Result + Copy(FormatDateTime('yyyymmdd', Now), 3, 6) + '^'
  else
    Result := Result + '^';
  // 6. ��� �����ι�ȣ  [ ���������� RS09�ʵ� ]
  Result := Result + AInfo.OrgAgreeNo + '^';
  // 7. ��ǰ�ڵ�
  Result := Result + '^';
  // 8. �ӽ��ǸŹ�ȣ  [ ���������� ����ϴ� �ŷ�������ȣ ]
  Result := Result + TransNo + '^';
  // 9. �����۸޼���
  Result := Result + '^';
  // 10. ����ī�� �ɼ�
  //   1.KeyIn �ɼ� Y : ����� N : ������
  //   2.0�� �ŷ� �ɼ� Y : ����� N : ������
  //   3.Transaction DB ���� �ɼ� Y : ����� N : ������
  //   4.������ ��ư ��� ���� �ɼ� Y : ����� N : ������
  //   5.��� �ŷ� �� ������ �ɼ� Y : ����� N : ������
  //   6.���� �ŷ� �� ������ �ɼ� Y : ����� N : ������
  //   �������� �ʵ��̹Ƿ� �� �ʵ� ���� �� �־����.
  //   ex) Transaction DB �ɼǱ��� ��� �Ѵٸ� ��NNY�� �� ����
  Result := Result + '^';
  // 11. �ܸ����ȣ(TID)
  //    EasyCard ���α׷����� ��ƼTID �ɼ��� ��� ���� ���� �� : ���� �ܸ����ȣ(TID)
  //    EasyCard ���α׷����� ��ƼTID �ɼ��� ������ ���� ���� ��: �⺻�����δ� ���� ����
  if (ATranCode = 'C1') then
    Result := Result + '^'
  else
    Result := Result + AInfo.TerminalID + '^';
  // 12. Ÿ�Ӿƿ� [ Response Timeout second, ���� ���� �� Default : 0��   (����Kiosk���������� ��밡��)  ]
  Result :=  Result + '60^';
  // 13. �ΰ��� [ ���� �ʿ� ]
  //    A : �ڵ����
  //    M + �ΰ����ݾ� : �����Է� ? ex ) M91 �ΰ��� 91��
  //    F : �鼼
  //    ���� ������ 10% �ڵ����
  Result := Result + 'M' + CurrToStr(AInfo.VatAmt) + '^';
  // 14. �߰��ʵ�      [ ��� �������� ���� + DCC ��û ]
  Result := Result + '^';
  // 15. ���� �ڵ鰪   [ ����ī�� �ǽð� ���°� ���Ž� ���� �ڵ鰪 ���� ]
  Result := Result + '^';
  // 16. �ܸ��� ����   [ ��� �������� ���� ]
  Result := Result + '^';
  // 17. ����/���� ����   [ ���� ���ι��������� ��밡�� ]
  Result := Result + '^';
  // 18. ��й�ȣ         [ ��� �������� ���� ]
  Result := Result + '^';
  // 19. �ŷ�Ȯ��ɼ�     [ ��� �������� ���� ]
  Result := Result + '^';
  // 20. ��� �ŷ�������ȣ  [ DSC�� �ŷ�������ȣ (RS08) | ��ǥ��ȸ �� : ��ǥ��ȣ + �Ϸù�ȣ ]
  if (ATranCode = 'C1') then
    Result := Result + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + '^'
  else
    Result := Result + '^';
  // 21. ���� FLAG  [ SSGPAY : BS | �˸����� : BA | �������� : BW ]
  Result := Result + '^';
  // 22. EzGW ���ڵ��ȣ  [ EzGW ���α׷������� ��� B + ���ڵ��ȣ ]
  Result := Result + '^';
  // 23. �����  [ ��� �������� ����   ]
  //     (3�� �ʵ� ��ü�ݾ׿� ���������� ���� �� Ex. �ݾ�:10,000�� �����: 1,000�� �̸� ���� �ݾ��� 11,000��)
  Result := Result + '^';
  // 24. ���ڼ�  [ EUC-KR / UTF-8 ���� ������ EasyCard�� ���� ������ ������.    ]
  Result := Result + '^';
  // 25. BMP String
  Result := Result + ASignData + '^';
  // 26. VAN  [ ��Ƽ�� ��ҽÿ��� ���� KICC,SMATRO,KIS,KSNET,KOCES ]
  Result := Result + '^';
  // 27. ī���ȣ
  //     EzGW : Ű�� ���� �ŷ� ��û
  //    �Ϲ� �ſ� ���� : @ + ī���ȣ
  //    �����н� �ſ� ���� : @TOKNSKP + ��ū��ȣ
  //    �˸�����, �������� : B + �˸�����, �������� ���ڵ�
  Result := Result + '^';
  // 28. ��ȿ�Ⱓ   [ EzGW : Ű�� ���� �ŷ� ��û ]
  Result := Result + '^';
  // 29. ���ι�� ����  [ EzGW : E:����ī�� G:��������Ʈ ]
  Result := Result + '^';
  // 30. ȭ��ǥ��  [  EasyCardK 1.0.0.24 �̻���� ���� ]
  //     ȭ��ǥ�ø� ���� �������� N ���� (������ �⺻ �� : Y �� ����)
  Result := Result + '^';
  // 31. ���ʽ� ���ι�ȣ [ - EasyCardK 1.0.0.33 �̻���� ���� ]
  //     ��������-�ſ� ��� �ŷ��� RS34(���ʽ� ���ι�ȣ) �� ����
  Result := Result + '^';
end;

function TVanKiccDaemon.ExecHttpSendRecv(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
const
  KICC_HOST_URL = 'http://127.0.0.1:8090/?';
var
  Parameters: TStringStream;
  RecvStream: TMemoryStream;
  {$IF RTLVersion > 19.00}
  RbStr: RawByteString;
  {$ELSE}
  RbStr: AnsiString;
  {$IFEND}
begin
  Result := False;
  ASendData := 'callback=jsonp12345678983543344' + '&REQ=' + ASendData;
  Log.Write(ltInfo, ['��������', ASendData]);
  Parameters := TStringStream.Create(ASendData);
  RecvStream := TMemoryStream.Create;
  try
    try
      FIndy.Request.Clear;
      FIndy.HandleRedirects     := True;
      FIndy.Request.ContentType := 'application/x-www-form-urlencoded';
      FIndy.Post(KICC_HOST_URL, Parameters, RecvStream);
      RbStr := PAnsiChar(RecvStream.Memory);
      {$IF RTLVersion > 19.00}
//      SetCodePage(RbStr, 65001, False);
      {$ELSE}
      {$IFEND}
      ARecvData := RbStr;
      Result := True;
      Log.Write(ltInfo, ['��������', ARecvData]);
    except
      on E: Exception do
      begin
        ARecvData := E.Message;
        Log.Write(ltError, ['ó������', E.Message]);
      end;
    end;
  finally
    Parameters.Free;
    RecvStream.Free;
  end;
end;

function TVanKiccDaemon.GetSeqNoKICC: AnsiString;
var
  AppPath: string;
  SeqNo: Integer;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  // �Ϸù�ȣ (10�ڸ�, ������ ���� ���� ������ �����ؾ� ��)
  with TIniFile.Create(AppPath + 'KiccDaemonSeq.ini') do
    try
      SeqNo := ReadInteger('SEQ', FormatDateTime('mmdd', Now), 0) + 1;
      if SeqNo > 999999 then
        SeqNo := 0;
      WriteInteger('SEQ', FormatDateTime('mmdd', Now), SeqNo);
    finally
      Free;
    end;
  Result := FormatDateTime('mmdd', Now) + FormatFloat('000000', SeqNo);
end;

{ TVanKisDaemon }

constructor TVanKisDaemon.Create;
begin
  inherited;
  KisPosAgent := TKisPosAgent.Create(nil);
end;

destructor TVanKisDaemon.Destroy;
begin
  KisPosAgent.Free;
  inherited;
end;

function TVanKisDaemon.ExecOcx(ATranCode: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  KisPosAgent.Init;
  KisPosAgent.inAgentIP        := '127.0.0.1';              // KIS-AGENT IP
  KisPosAgent.inAgentPort      := 1515;                     // KIS-AGENT PORT
  KisPosAgent.inTranCode       := ATranCode;                // ���������ڵ�
  if (ATranCode = 'D1') or (ATranCode = 'D2') or (ATranCode = 'CU') or (ATranCode = 'CD') then
    KisPosAgent.inTranGubun    := IfThen(AInfo.KeyInput, 'K', '')  // ���������ڵ� (�ſ����)
  else if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inTranGubun    := IfThen(AInfo.KeyInput, '', 'C'); // ���������ڵ� (���ݿ�����)
  KisPosAgent.inReaderType     := 'R';                      // ������Type
  if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inCashAuthId   := AInfo.CardNo;             // ���ݿ����� �߱� ID
  if (ATranCode = 'D1') or (ATranCode = 'D2') or (ATranCode = 'CU') or (ATranCode = 'CD') then
    KisPosAgent.inInstallment  := IntToStr(AInfo.HalbuMonth) // �Һΰ���
  else if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inInstallment  := IfThen(AInfo.Person = 2, '01', '00'); // ����/����� ����
  KisPosAgent.inTranAmt      := CurrToStr(AInfo.SaleAmt);   // �����ݾ� (��ǥ�ݾ�)
  KisPosAgent.inVatAmt         := CurrToStr(AInfo.VatAmt);  // �ΰ�����
  KisPosAgent.inSvcAmt         := CurrToStr(AInfo.SvcAmt);  // �����
  if not AInfo.Approval then
  begin
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    KisPosAgent.inOrgAuthDate  := Copy(AInfo.OrgAgreeDate, 3, 6); // ���ŷ�����
    KisPosAgent.inOrgAuthNo    := AInfo.OrgAgreeNo;               // �����ι�ȣ
  end;
  if AInfo.SignOption = 'Y' then                            // ����ó�� ���� ('Y': ����ŷ� 'N': ����ó������ '': ������ŷ�)
    KisPosAgent.inSignYN       := 'Y'
  else if AInfo.SignOption = 'N' then
    KisPosAgent.inSignYN       := ''
  else if AInfo.SignOption = 'R' then
    KisPosAgent.inSignYN       := 'N';
  KisPosAgent.inSignFileName   := 'sign.bmp';               // �������ϸ�
  KisPosAgent.inCatID          := AInfo.TerminalID;         // �ܸ����ȣ
  KisPosAgent.inCheckNumber    := Format('%-14.14s', [AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode]); // ��ǥ��ȣ
  if Length(AInfo.RegDate) = 6 then                         // ��ǥ��������
    KisPosAgent.inCheckIssueDate := Copy(AInfo.RegDate, 1, 6)
  else
    KisPosAgent.inCheckIssueDate := Copy(AInfo.RegDate, 3, 6);
  KisPosAgent.inCheckType      := AInfo.KindCode;           // ��ǥ�����ڵ�
  KisPosAgent.inCheckAccountNo := AInfo.AccountNo;          // ��ǥ �����Ϸù�ȣ
  KisPosAgent.inOilInfo        := '';                       // ��������
  KisPosAgent.inOilYN          := 'N';                      // ����������뿩��
  KisPosAgent.inVanKeyYN       := 'N';                      // VanKey��뿩��
  KisPosAgent.inVanKey         := '';                       // VanKey
  KisPosAgent.inTicketNumer    := '';                       // ����M����Ʈ ���� Ticket�ż�
  KisPosAgent.inBarCodeNumber  := '';                       // ��ī�� ���ڵ��ȣ
  KisPosAgent.inSKTGoodsCode   := '';                       // SKT ��ǰ�ڵ�

  KisPosAgent.KIS_Approval;
  Log.Write(ltDebug, ['OCX����', KisPosAgent.outRtn, '�����ڵ�', KisPosAgent.outReplyCode, '�޼���', KisPosAgent.outReplyMsg1 + KisPosAgent.outReplyMsg2]);

  Result.Result        := (KisPosAgent.outRtn = 0) and (KisPosAgent.outReplyCode = '0000'); // ��������
  Result.Code          := KisPosAgent.outReplyCode;         // �����ڵ�
  Result.Msg           := KisPosAgent.outReplyMsg1 + KisPosAgent.outReplyMsg2; // ����޼���
  Result.AgreeNo       := KisPosAgent.outAuthNo;            // ���ι�ȣ
  Result.AgreeDateTime := KisPosAgent.outReplyDate + KisPosAgent.outTradeReqTime; // �����Ͻ�(yyyymmddhhnnss)
  Result.TransNo       := KisPosAgent.outTradeNum;          // �ŷ���ȣ
  Result.BalgupsaCode  := KisPosAgent.outIssuerCode;        // �߱޻��ڵ�
  Result.BalgupsaName  := KisPosAgent.outIssuerName;        // �߱޻��
  Result.CompCode      := KisPosAgent.outAccepterCode;      // ���Ի��ڵ�
  Result.CompName      := KisPosAgent.outAccepterName;      // ���Ի��
  Result.KamaengNo     := KisPosAgent.outMerchantRegNo;     // ��������ȣ
  Result.AgreeAmt      := Trunc(AInfo.SaleAmt);             // ���αݾ�
  Result.DCAmt         := 0;                                // ���αݾ�
  Result.CardNo        := KisPosAgent.outCardNo;            // ����ŷ�� ī���ȣ
  Result.IsSignOK      := Trim(KisPosAgent.outTranNo) = 'SN';     // ���ڼ�����
end;

function TVanKisDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKisDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode: AnsiString;
begin
  if AInfo.Approval then
    TranCode := IfThen(AInfo.EyCard, 'CU', 'D1')
  else
    TranCode := IfThen(AInfo.EyCard, 'CD', 'D2');
  Result := ExecOcx(TranCode, AInfo);
end;

function TVanKisDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode: AnsiString;
begin
  if AInfo.Approval then
    TranCode := 'CC'
  else
    TranCode := 'CR';
  Result := ExecOcx(TranCode, AInfo);
end;

function TVanKisDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKisDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result := ExecOcx('C1', AInfo);
end;

function TVanKisDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  KisPosAgentForm := TKisPosAgentForm.Create(Application);
  try
    if KisPosAgentForm.ShowModal = mrOK then
    begin
      ARecvData := KisPosAgentForm.RecvData;
      Log.Write(ltInfo, ['���е�����', ARecvData]);
      Result := True;
    end;
  finally
    KisPosAgentForm.Free;
  end;
end;

{ TVanFDIKDaemon }

constructor TVanFDIKDaemon.Create;
begin
  inherited;
  FDaemonRunCheck := False;
end;

destructor TVanFDIKDaemon.Destroy;
var
  FDIK_Daemon_Destroy: TFDIK_Daemon_Destroy;
begin
  Log.Write(ltInfo, ['Daemon Destroy!!! DLLHandle', FDLLHandle]);
  if FDLLHandle <> 0 then
  begin
    @FDIK_Daemon_Destroy := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Destroy');
    if Assigned(@FDIK_Daemon_Destroy) then
    begin
      if FDIK_Daemon_Destroy() = 0 then
        Log.Write(ltInfo, ['WIN4POS ���� ������']);
    end
    else
      Log.Write(ltError, ['FDK_WIN4POS_Destroy �Լ� ����']);

    FreeLibrary(FDLLHandle);
  end;
  inherited;
end;

function TVanFDIKDaemon.CheckDaemonRun(out AErrorMsg: AnsiString): Boolean;
var
  FDIK_Daemon_Create: TFDIK_Daemon_Create;
  FDIK_Daemon_Status: TFDIK_Daemon_Status;
  Ret: Integer;
begin
  Result := False;
  Log.Write(ltInfo, ['WIN4POS ���� Check', FDaemonRunCheck]);
  if not FDaemonRunCheck then
  begin
    FDllHandle := LoadLibrary(WIN4POS_DLL);
    @FDIK_Daemon_Create := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Create');
    if not Assigned(@FDIK_Daemon_Create) then
    begin
      AErrorMsg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
      Log.Write(ltError, ['WIN4POS Create ȣ�� ����', AErrorMsg]);
      Exit;
    end;

    Ret := FDIK_Daemon_Create('127.0.0.1', '2003');
    if Ret <> 0 then
    begin
      AErrorMsg := 'WIN4POS ���α׷��� �������� ���߽��ϴ�.';
      Log.Write(ltError, ['WIN4POS Create ���䰪', Ret, '�޼���', AErrorMsg]);
      Exit;
    end;
  end;

  @FDIK_Daemon_Status := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Status');
  if not Assigned(@FDIK_Daemon_Status) then
  begin
    AErrorMsg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Log.Write(ltError, ['WIN4POS Status ȣ�� ����', AErrorMsg]);
    Exit;
  end;

  Ret := FDIK_Daemon_Status();
  case Ret of
     0 :
       begin
         AErrorMsg := 'WIN4POS ���� ������';
         FDaemonRunCheck := True;
         Result := True;
       end;
    -1 : AErrorMsg := 'Create ���� ���� �ʰų� Ŀ�ؼ� ���� ����';
    -2 : AErrorMsg := 'INIT �Ǵ� EXECUTE ����';
  else
    AErrorMsg := '��Ÿ ����';
  end;
  Log.Write(ltInfo, ['WIN4POS Status ���䰪', Ret, '�޼���', AErrorMsg]);
end;

function TVanFDIKDaemon.DoCallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
     or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'PAY', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Input('�ŷ�����', PAnsiChar(StrToAnsiStr(IfThen(AInfo.EyCard, 'JCB', 'CRD')))) <> 0 then Exit;
    if FDIK_Daemon_Input('����ڹ�ȣ', PAnsiChar(StrToAnsiStr(Format('%-10.10s', [AInfo.BizNo])))) <> 0 then Exit;
    if FDIK_Daemon_Input('��ǰ�Ϸù�ȣ', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s', [Ainfo.TerminalID]))))) <> 0 then Exit;
    if FDIK_Daemon_Input('��û�ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SaleAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('�����', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SvcAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('����', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.VatAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('�������ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', (AInfo.SaleAmt - AInfo.FreeAmt))))) <> 0 then Exit;
    if FDIK_Daemon_Input('��������ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', AInfo.FreeAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('�Һ�', PAnsiChar(StrToAnsiStr(FormatFloat('00', AInfo.HalbuMonth)))) <> 0 then Exit;
    if AInfo.Approval then
    begin
      if FDIK_Daemon_Input('��ұ���', ' ') <> 0 then Exit;
    end
    else
    begin
      if FDIK_Daemon_Input('��ұ���', 'Y') <> 0 then Exit;
      if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
      if FDIK_Daemon_Input('���ŷ�����', PAnsiChar(StrToAnsiStr(Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])))) <> 0 then Exit;
      if FDIK_Daemon_Input('�����ι�ȣ', PAnsiChar(StrToAnsiStr(Format('%-12.12s', [AInfo.OrgAgreeNo])))) <> 0 then Exit;
    end;
    if AInfo.SignOption = 'N' then
    begin
      if FDIK_Daemon_Input('����������', PAnsiChar(StrToAnsiStr('N'))) <> 0 then Exit;
    end;
    // ���� ȣ��
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    FDIK_Daemon_Output('�����ڵ�', Buff, 1024);
    Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('���ι�ȣ', Buff, 1024);
    Result.AgreeNo := Buff;
//    FDIK_Daemon_Output('��������', Buff, 1024);
//    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('�ŷ��ð�', Buff, 1024);
    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('��������ȣ', Buff, 1024);
    Result.KamaengNo := Buff;
    FDIK_Daemon_Output('����޽���1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('����޽���2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('ī���', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('�߱޻��ڵ�', Buff, 1024);
    Result.BalgupsaCode := Buff;
    FDIK_Daemon_Output('�߱޻��', Buff, 1024);
    Result.BalgupsaName := Buff;
    FDIK_Daemon_Output('���Ի��ڵ�', Buff, 1024);
    Result.CompCode := Buff;
    FDIK_Daemon_Output('���Ի��', Buff, 1024);
    Result.CompName := Buff;
    FDIK_Daemon_Output('����ŷī���ȣ', Buff, 1024);
    Result.CardNo := Buff;
    FDIK_Daemon_Output('������', Buff, 1024);
    Result.IsSignOK := Buff <> '';
    FDIK_Daemon_Output('�ŷ��ݾ�', Buff, 1024);
    Result.AgreeAmt := StrToIntDef(Buff, Trunc(AInfo.SaleAmt));
    Result.DCAmt := 0;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.DoCallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
     or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'PAY', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Input('�ŷ�����', 'CSH') <> 0 then Exit;
    if FDIK_Daemon_Input('����ڹ�ȣ', PAnsiChar(StrToAnsiStr(Format('%-10.10s',[AInfo.BizNo])))) <> 0 then Exit;
    if FDIK_Daemon_Input('��ǰ�Ϸù�ȣ', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s',[AInfo.TerminalID]))))) <> 0 then Exit;
    if FDIK_Daemon_Input('��û�ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SaleAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('�����', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SvcAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('����', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.VatAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('�������ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', (AInfo.SaleAmt - AInfo.FreeAmt))))) <> 0 then Exit;
    if FDIK_Daemon_Input('��������ݾ�', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', AInfo.FreeAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('��뱸��', PAnsiChar(StrToAnsiStr(IfThen(AInfo.Person = 2, '01', '00')))) <> 0 then Exit;
    if FDIK_Daemon_Input('�ĺ���ȣ', PAnsiChar(StrToAnsiStr(Format('%-13.13s', [AInfo.CardNo])))) <> 0 then Exit;
    if AInfo.Approval then
    begin
      if FDIK_Daemon_Input('��ұ���', ' ') <> 0 then Exit;
    end
    else
    begin
      if FDIK_Daemon_Input('��ұ���', 'Y') <> 0 then Exit;
      if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
      if FDIK_Daemon_Input('���ŷ�����', PAnsiChar(StrToAnsiStr(Format('%-6.6s',[Copy(AInfo.OrgAgreeDate, 3, 6)])))) <> 0 then Exit;
      if FDIK_Daemon_Input('�����ι�ȣ', PAnsiChar(StrToAnsiStr(Format('%-12.12s', [AInfo.OrgAgreeNo])))) <> 0 then Exit;
    end;
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    FDIK_Daemon_Output('�����ڵ�', Buff, 1024);
    Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('���ι�ȣ', Buff, 1024);
    Result.AgreeNo:= Buff;
//    FDIK_Daemon_Output('��������', Buff, 1024);
//    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('�ŷ��ð�', Buff, 1024);
    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('����޽���1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('����޽���2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('����ŷī���ȣ', Buff, 1024);
    Result.CardNo := Buff;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.DoCallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term) or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'CHK', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    if (FDIK_Daemon_Output('�����ڵ�', Buff, 1024) = 0) then
      Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('�����Ͻ�', Buff, 1024);
    Result.AgreeDateTime := Buff;
    FDIK_Daemon_Output('����޽���1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('����޽���2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  if CheckDaemonRun(Result.Msg) then
  begin
    @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
    @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
    @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
    @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
    @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
    @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
    if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
       or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
       or not Assigned(@FDIK_Daemon_Execute) then
    begin
      Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
      Exit;
    end;
    try
      if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
      if FDIK_Daemon_Init(Buff, 'MAIN', 'FDK') <> 0 then Exit;

      if FDIK_Daemon_Input('ȭ�鱸��', 'PDN') <> 0 then Exit;
      if FDIK_Daemon_Input('����ڹ�ȣ', PAnsiChar(StrToAnsiStr(Format('%-10.10s',[ABizNo])))) <> 0 then Exit;
      if FDIK_Daemon_Input('��ǰ�Ϸù�ȣ', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s',[ATerminalID]))))) <> 0 then Exit;
      if FDIK_Daemon_Execute() <> 0 then
      begin
        FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
        Result.MSG := Buff;
        Exit;
      end;
      if (FDIK_Daemon_Output('�����ڵ�', Buff, 1024) = 0) then
        Result.Code := Buff;
      if Result.Code = '0000' then
        Result.Result := True;
      FDIK_Daemon_Output('�����Ͻ�', Buff, 1024);
      Result.AgreeDateTime := Buff;
      FDIK_Daemon_Output('����޽���1', Buff, 1024);
      Result.Msg := Buff;
      FDIK_Daemon_Output('����޽���2', Buff, 1024);
      Result.Msg := Result.Msg + Buff;
    finally
      FDIK_Daemon_Term();
    end;
  end;
end;

function TVanFDIKDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCard(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCash(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����';
end;

function TVanFDIKDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCheck(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����';
end;

{ TVanKocesDaemon }

constructor TVanKocesDaemon.Create;
begin
  inherited;
  if FileExists(filKOCESIC_DLL_Path + filKOCESIC_DLL) then
    FDLLHandle := LoadLibrary(filKOCESIC_DLL_Path + filKOCESIC_DLL)
  else
    FDLLHandle := LoadLibrary(filKOCESIC_DLL);
end;

destructor TVanKocesDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKocesDaemon.ExecDownLoadRequest(ATerminalID, ASerial, ABizNo: AnsiString): TCardRecvInfoDM;
type
  TDownLoadRequest = function(out pResAppr: TDownResAppr; pTermID, pMchData, pSftVer, pSerial, pBsnNo: AnsiString): Integer; stdcall;
var
  Exec: TDownLoadRequest;
  RecvData: TDownResAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'DownLoadRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // ���� ȣ��
  Index := Exec(RecvData,                           // ��������
                Format('%-10.10s', [ATerminalID]),  // �ܸ����ȣ
                Format('%-20.20s', [MSG_SOLBIPOS]), // ��������� ����
                Format('%-5.5s', [LeftStr(ATerminalID, 2) + '201']), // �ܸ��� SW ����
                Format('%-20.20s', [ASerial]),      // �ø��� ��ȣ
                Format('%-10.10s', [ABizNo]));      // ����� ��ȣ
  case Index of
    0 :
      begin
        // �����ڵ�
        Result.Code := RecvData.Header.AnsCode;
        // ��������
        Result.Result := Result.Code = '0000';
        // ����޼���
        Result.Msg := RecvData.Message;
      end;
   -1 : Result.Msg := '���ο䱸 ����';
   -2 : Result.Msg := '���ο䱸 Timeout';
   -3 : Result.Msg := 'KocesICPos �̽���';
  else
    Result.Msg := '�� �� ���� �����Դϴ�.';
  end;
  Log.Write(ltInfo, ['�������ٿ�ε�', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg, '�ܸ����ȣ', ATerminalID, '�ø���', ASerial, '����ڹ�ȣ', ABizNo]);
end;

function TVanKocesDaemon.ExecICRequest(ATrdType, AKeyYN: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_ICRequest = function(out pAuthResAppr: TPosICResAppr;
                              pTrdType, pAuData, pMonth, pTrdAmt, pSvcAmt, pTaxAmt, pTaxFreeAmt, pAuNo, pAuDate, pKeyYn, pInsYn,
                              pCashNum, pCancelReason, pPtSvrCd, pPtInsYn, pPtCardCd: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_ICRequest;
  OrgAgreeNoData, OrgSaleDateData: AnsiString;
  RecvData: TPosICResAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'KocesICRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  if AInfo.Approval then
  begin
    OrgAgreeNoData  := '            ';
    OrgSaleDateData := '        ';
  end
  else
  begin
    OrgAgreeNoData := Format('%-12.12s', [AInfo.OrgAgreeNo]);
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    OrgSaleDateData := IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), AInfo.OrgAgreeDate);
  end;
  // ���� ȣ��
  Index := Exec(RecvData,                            // ��������
                ATrdType,                            // ��������(2�ڸ�, �ſ����:F1 �ſ����:F2 ���ý���:C5 �������:C6 ���ݽ���:H3 �������:H4)
                Format('%-20.20s', [MSG_SOLBIPOS]),  // ��������� ����(20�ڸ�)
                FormatFloat('00', AInfo.HalbuMonth), // �ҺαⰣ(2�ڸ�)
                FormatFloat('000000000000', IfThen(AInfo.Approval, AInfo.SaleAmt - AInfo.SvcAmt - AInfo.VatAmt, AInfo.SaleAmt)), // �Ǹűݾ� (12�ڸ�) (���� �ÿ��� �����, ����, �鼼 ���� ��� �ÿ��� ����)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.SvcAmt, 0)),  // ����� (9�ڸ�) (��ҽÿ��� 0��)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.VatAmt, 0)),  // �ΰ��� (9�ڸ�) (��ҽÿ��� 0��)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.FreeAmt, 0)), // ����� (9�ڸ�) (��ҽÿ��� 0��)
                OrgAgreeNoData,                      // �����ι�ȣ (12�ڸ�)
                OrgSaleDateData,                     // ���������� (8�ڸ�)  YYYYMMDD
                AKeyYN,                              // Swipe���� (I:�ſ���� S:���ݿ������� ī��, K:�޴�����ȣ)
                FormatFloat('0', AInfo.Person),      // ���ݿ����� ���� (1:���� 2:���� 3:�����߱� 4:��õ¡��)
                Format('%-13.13s', [AInfo.CardNo]),  // �� �ĺ���ȣ (13�ڸ�)
                IfThen(AInfo.Approval, ' ', FormatFloat('0', AInfo.CancelReason)), // ��һ��� (1:�ŷ���� 2:�����߱�, 3:��Ÿ)
                '  ',                                // ���񽺱��� (01:���� 02:������� 03:��� 04:������ 05:��ȸ 11:����Ʈ ���ο�û 12:����Ʈ ���ο�û ���))
                '  ',                                // �������� (01:����, 02:�ſ�) (�� 01.���ݰŷ��߿��� ����Ʈ �ܵ��� ��쿡�� �ش�
                '  ');                               // ����Ʈ�ڵ� (01:ĳ���� 07:���÷��� 16:�ڿ���)
  case Index of
    0 :
      begin
        // �����ڵ�
        Result.Code := RecvData.Header.AnsCode;
        // ����޼���
        Result.Msg := RecvData.Message;
        // ��������
        Result.Result := Result.Code = '0000';
        if Result.Result then
        begin
          // ���ι�ȣ
          Result.AgreeNo := RecvData.AuNo;
          // �����Ͻ�
          Result.AgreeDateTime := RecvData.TradeDate;
          // �ŷ���ȣ
          Result.TransNo := RecvData.TradeNo;
          // �߱޻��̸�
          Result.BalgupsaCode := RecvData.OrdCd;
          Result.BalgupsaName := RecvData.OrdNm;
          // ���Ի��̸�
          Result.CompCode := RecvData.InpCd;
          Result.CompName := RecvData.InpNm;
          // ��������ȣ
          Result.KamaengNo := RecvData.MchNo;
          // ���αݾ�
          Result.AgreeAmt := Trunc(AInfo.SaleAmt);
          // ���αݾ�
          Result.DCAmt := 0;
          // ī���ȣ
          Result.CardNo := RecvData.CardNo;
          // ���� ���� ����
          Result.IsSignOK := True;
        end;
      end;
    -1 : Result.Msg := '���ο䱸 ����';
    -2 : Result.Msg := '���ο䱸 Timeout';
    -3 : Result.Msg := 'KocesICPos �̽���';
  else
    Result.Msg := '�� �� ���� �����Դϴ�.';
  end;
  Log.Write(ltInfo, ['���ΰŷ�', Result.Result, '�ڵ�', Result.Code, '���ι�ȣ', Result.AgreeNo, 'ī���ȣ', Result.CardNo, '�޼���', Result.Msg]);
end;

function TVanKocesDaemon.ExecAppCardRequest(ATrdType: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_AppCardRequest = function(out pAuthResAppr: TPosICResAppr; pTrdType, pAuData,
                                   pMonth, pTrdAmt, pSvcAmt, pTaxAmt, pTaxFreeAmt,
                                   pAuNo, pAuDate, pPtCardCd: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_AppCardRequest;
  RecvData: TPosICResAppr;
  OrgAgreeNoData, OrgSaleDateData: AnsiString;
  Index: Integer;
begin
  try
    Result.Result := False;
    @Exec := GetProcAddress(FDLLHandle, 'AppCardRequest');
    if not Assigned(@Exec) then
    begin
      Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
      Exit;
    end;
    if AInfo.Approval then
    begin
      OrgAgreeNoData  := '            ';
      OrgSaleDateData := '        ';
    end
    else
    begin
      OrgAgreeNoData := Format('%-12.12s', [AInfo.OrgAgreeNo]);
      if Length(AInfo.OrgAgreeDate) = 6 then
        AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;

      OrgSaleDateData := IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), AInfo.OrgAgreeDate);
    end;
    // ���� ȣ��
    Index := Exec(RecvData,                            // ��������
                  ATrdType,                            // ��������(����: A1, ���: A2)
                  Format('%-20.20s', [MSG_SOLBIPOS]),  // ��������� ����(20�ڸ�)
                  FormatFloat('00', AInfo.HalbuMonth), // �ҺαⰣ(2�ڸ�)
                  // �Ǹűݾ� (12�ڸ�) (���� �ÿ��� �����, ����, �鼼 ���� ��� �ÿ��� ����)
                  FormatFloat('000000000000', IfThen(AInfo.Approval,
                                                     AInfo.SaleAmt - AInfo.SvcAmt - AInfo.VatAmt,
                                                     AInfo.SaleAmt)),
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.SvcAmt, 0)),  // ����� (9�ڸ�) (��ҽÿ��� 0��)
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.VatAmt, 0)),  // �ΰ��� (9�ڸ�) (��ҽÿ��� 0��)
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.FreeAmt, 0)), // ����� (9�ڸ�) (��ҽÿ��� 0��)
                  OrgAgreeNoData,                      // �����ι�ȣ (12�ڸ�)
                  OrgSaleDateData,                     // ���������� (8�ڸ�)  YYYYMMDD
                  Format('%-30.30s', [AInfo.CardNo])); // ��ī�� ���ڵ� ��ȣ
    case Index of
      0 :
        begin
          // �����ڵ�
          Result.Code := RecvData.Header.AnsCode;
          // ����޼���
          Result.Msg := RecvData.Message;
          // ��������
          Result.Result := Result.Code = '0000';
          if Result.Result then
          begin
            // ���ι�ȣ
            Result.AgreeNo := RecvData.AuNo;
            // �����Ͻ�
            Result.AgreeDateTime := RecvData.TradeDate;
            // �ŷ���ȣ
            Result.TransNo := RecvData.TradeNo;
            // �߱޻��̸�
            Result.BalgupsaCode := RecvData.OrdCd;
            Result.BalgupsaName := RecvData.OrdNm;
            // ���Ի��̸�
            Result.CompCode := RecvData.InpCd;
            Result.CompName := RecvData.InpNm;
            // ��������ȣ
            Result.KamaengNo := RecvData.MchNo;
            // ���αݾ�
            Result.AgreeAmt := Trunc(AInfo.SaleAmt);
            // ���αݾ�
            Result.DCAmt := 0;
            // ī���ȣ
            Result.CardNo := RecvData.CardNo;
            // ���� ���� ����
            Result.IsSignOK := True;
          end;
        end;
      -1 : Result.Msg := '���ο䱸 ����';
      -2 : Result.Msg := '���ο䱸 Timeout';
      -3 : Result.Msg := 'KocesICPos �̽���';
    else
      Result.Msg := '�� �� ���� �����Դϴ�.';
  end;
    Log.Write(ltInfo, ['���ΰŷ�', Result.Result, '�ڵ�', Result.Code, '���ι�ȣ', Result.AgreeNo, 'ī���ȣ', Result.CardNo, '�޼���', Result.Msg]);
  finally

  end;
end;

function TVanKocesDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKocesDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TrdType: AnsiString;
begin
  // ���߻���� ������ ���
  if AInfo.Reserved1 <> '' then
  begin
    Result := ExecDownLoadRequest(AInfo.TerminalID, AInfo.Reserved1, AInfo.BizNo);
    if not Result.Result then
      Exit;
  end;

  if AInfo.TrsType = 'A' then
  begin
    TrdType := IfThen(AInfo.Approval, 'A1', 'A2');
    Result := ExecAppCardRequest(TrdType, AInfo);
  end
  else
  begin
    if AInfo.Approval then
      TrdType := IfThen(AInfo.EyCard, 'C5', 'F1')
    else
      TrdType := IfThen(AInfo.EyCard, 'C6', 'F2');
    Result := ExecICRequest(TrdType, 'I', AInfo);
  end;
end;

function TVanKocesDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TrdType: AnsiString;
begin
  // ���߻���� ������ ���
  if AInfo.Reserved1 <> '' then
  begin
    Result := ExecDownLoadRequest(AInfo.TerminalID, AInfo.Reserved1, AInfo.BizNo);
    if not Result.Result then
      Exit;
  end;

  TrdType := IfThen(AInfo.Approval, 'H3', 'H4');
  Result := ExecICRequest(TrdType, IfThen(AInfo.KeyInput, 'K', 'S'), AInfo);
end;

function TVanKocesDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKocesDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_ICBillRequest = function(out pBillAppr: TPGFICBillAppr;
                                  pMchData, pBillType, pBillNo, pBankCd, pBillCd, pBillAmt, pDraftDate, pAccountNo: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_ICBillRequest;
  RecvData: TPGFICBillAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'BillRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // ���� ȣ��
  Index := Exec(RecvData,
                Format('%-20.20s', [MSG_SOLBIPOS]),                    // ��������� ���� (20�ڸ�)
                '4',                                                   // ��ǥ���� (4-�ڱ��, 5-�����ǥ)
                LeftStr(AInfo.CheckNo, 8),                             // ��ǥ��ȣ (8�ڸ�)
                Format('%-6.6s', [AInfo.BankCode + AInfo.BranchCode]), // �������� (6�ڸ�)
                AInfo.KindCode,                                        // ����
                FormatFloat('00000000', AInfo.SaleAmt),                // ��ǥ�ݾ� (8�ڸ�)
                Format('%-6.6s', [AInfo.RegDate]),                     // ��������
                Format('%-14.14s', [AInfo.AccountNo]));                // �����Ϸù�ȣ
  case Index of
    0 :
      begin
        // �����ڵ�
        Result.Code := RecvData.Header.AnsCode;
        // ��������
        Result.Result := Result.Code = '0000';
        // ����޼���
        Result.Msg := RecvData.Message;
      end;
   -1 : Result.Msg := '���ο䱸 ����';
   -2 : Result.Msg := '���ο䱸 Timeout';
   -3 : Result.Msg := 'KocesICPos �̽���';
  else
    Result.Msg := '�� �� ���� �����Դϴ�.';
  end;
  Log.Write(ltInfo, ['��ǥ��ȸ', Result.Result, '�ڵ�', Result.Code, '�޼���', Result.Msg]);
end;

function TVanKocesDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

{ TVanKsnetDaemon }

constructor TVanKsnetDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(KSNET_DAEMON_DLL);
end;

destructor TVanKsnetDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKsnetDaemon.DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKSCATApproval = function(AResponseTelegram: PAnsiChar; AIP: PAnsiChar; APort: Integer; ARequestTelegram: PAnsiChar; ARequestTelegramLength: Integer; AOption: Integer): Integer; stdcall;
var
  Exec: TKSCATApproval;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'KSCATApproval');
  if not Assigned(@Exec) then
  begin
    ARecvData := KSNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(@ARecvData[1], '127.0.0.1', 27015, PAnsiChar(ASendData), Length(ASendData), 0) > 0;
  Log.Write(ltDebug, ['DaemonDLLȣ��', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKsnetDaemon.MakeSendDataCard(ATransGubun: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
var
  Gubun, Track2, Sign: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if ATransGubun = 'IC' then  // �ſ����
    Gubun := FormatFloat('00', AInfo.HalbuMonth)
  else if ATransGubun = 'HK' then // ���ݽ���
    Gubun := IfThen(AInfo.Approval, '0', FormatFloat('0', AInfo.CancelReason)) + IfThen(AInfo.Person = 2, '1', '0')
  else
    Gubun := Space(2);

  if ATransGubun = 'CH' then // ��ǥ��ȸ
  begin
    // Ʈ��2 ��������(6) + ��ǥ��ȣ(8) + �Ǹ�����(2) + �Ǹ�����(4) + �����Ϸù�ȣ(6) + �����ڵ�(2)
    if Length(AInfo.RegDate) = 6 then AInfo.RegDate := '20' + AInfo.RegDate;
    Track2 := Copy(AInfo.RegDate, 3, 6) + Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
                 Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]) + Format('%-2.2s', [AInfo.KindCode]);
    Track2 := Format('%-37.37s', [Track2]);
  end
  else
    Track2 := Space(37);

  // ��������
  if AInfo.SignOption = 'N' then
    Sign := 'X'
  else if AInfo.SignOption = 'R' then
    Sign := 'P'
  else if AInfo.SignOption = 'T' then
    Sign := 'T'
  else
    Sign := 'F';

  Result := STX +                                         // STX
            Format('%-2.2s', [ATransGubun]) +             // �ŷ�����
            '01' +                                        // ��������
            IfThen(AInfo.Approval, '0200', '0420') +      // ��������
            'N' +                                         // �ŷ�����
            Format('%-10.10s', [AInfo.TerminalID]) +      // �ܸ����ȣ
            KSNET_SOLBIPOS +                              // ��ü����
            FormatFloat('000000000000', GetSeqNo) +       // �ŷ��Ϸù�ȣ
            IfThen(AInfo.KeyInput, 'K', ' ') +            // POS Entry Mode
            Space(20) +                                   // �ŷ�������ȣ(KSNET TR)
            Space(20) +                                   // ��ȣȭ ���� ���� ī���ȣ
            ' ' +                                         // ��ȣȭ ���� (9: ��ȣȭ���� ����)
            '################' +                          // SW �� ��ȣ
            '################' +                          // Reader �𵨹�ȣ
            Space(40) +                                   // ��ȣȭ ����
            Track2 +                                      // Track II
            FS +                                          // FS (0x1c)
            Gubun +                                       // �Һΰ����� or �ŷ��ڱ���
            FormatFloat('000000000000', AInfo.SaleAmt) +  // �ѱݾ�
            FormatFloat('000000000000', AInfo.SvcAmt) +   // �����
            FormatFloat('000000000000', AInfo.VatAmt) +   // ����(�ΰ���)
            FormatFloat('000000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.FreeAmt) + // ���ޱݾ�
            FormatFloat('000000000000', AInfo.FreeAmt) +  // �鼼�ݾ�
            'AA' +                                        // ��й�ȣ�� ���� Working Key Index
            '0000000000000000' +                          // ��й�ȣ
            IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // ���ŷ����ι�ȣ
            IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // ���ŷ���������
            Space(13) +                                   // ���������
            Space(2) +                                    // ������ID
            Space(30) +                                   // ����������ʵ�
            Space(4) +                                    // Reserved
            Space(20) +                                   // KSNET_Reserved
            'N' +                                         // ���۱���
            Space(3) +                                    // ��ü����,����籸��,�ſ�ī������
            Space(30) +                                   // Filler
            Space(60) +                                   // DCC ȯ�� ��ȸ Data
            Sign +                                        // ��������
            ETX + CR;                                     // ETX + CR
  Result := FormatFloat('0000', Length(Result)) + Result;
end;

function TVanKsnetDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ��������
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
  // ���ι�ȣ
  Result.AgreeNo := Trim(Copy(ARecvData, 95, 12));
  // �����Ͻ� (yyyymmddhhnn)
  Result.AgreeDateTime := '20' + Copy(ARecvData, 50, 12);
  // �ŷ���ȣ
  Result.TransNo := Trim(Copy(ARecvData, 107, 20));
  // �߱޻��ڵ�
  Result.BalgupsaCode := Trim(Copy(ARecvData, 142, 2));
  // �߱޻��
  Result.BalgupsaName := Trim(Copy(ARecvData, 144, 16));
  // ���Ի��ڵ�
  Result.CompCode := Trim(Copy(ARecvData, 160, 2));
  // ���Ի��
  Result.CompName := Trim(Copy(ARecvData, 162, 16));
  // ��������ȣ
  Result.KamaengNo := Trim(Copy(ARecvData, 127, 15));
  // ���αݾ�
  Result.DCAmt := 0;
  // ����ŷ�� ī���ȣ
  Result.CardNo := Trim(Copy(ARecvData, 337, 30));
  // ���� ���� ����
  Result.IsSignOK := True;
end;

function TVanKsnetDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ��������
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
  // ���ι�ȣ
  Result.AgreeNo := Trim(Copy(ARecvData, 95, 12));
  // �����Ͻ� (yyyymmddhhnn)
  Result.AgreeDateTime := '20' + Copy(ARecvData, 50, 12);
  // ����ŷ�� ī���ȣ
  Result.CardNo := '';
end;

function TVanKsnetDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ��������
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // ����޼���
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
end;

function TVanKsnetDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKsnetDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCard('IC', AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCard('HK', AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKsnetDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  AInfo.Approval := True;
  SendData := MakeSendDataCard('CH', AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

{ TVanJtnetDaemon }

constructor TVanJtnetDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(JTNET_DAEMON_DLL);
end;

destructor TVanJtnetDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanJtnetDaemon.DLLExecAblity(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TFN_JTDMABLITY = function(pReqBuf: PAnsiChar; lReqBufLen: Integer; pResBuf: PAnsiChar; lMinTimeOut: Integer): Integer; stdcall;
var
  Exec: TFN_JTDMABLITY;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'FN_JTDMABLITY');
  if not Assigned(@Exec) then
  begin
    ARecvData := JTNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltDebug, ['DLLȣ��', ASendData]);
  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1], 1) = 1;
  Log.Write(ltDebug, ['DLL����', Result, 'RecvData', ARecvData]);
  // �Ǿ��� ���� 4Byte�� �����ϰ� �����Ѵ�.
  ARecvData := Copy(ARecvData, 5, MAXWORD);
end;

function TVanJtnetDaemon.DLLExecAuth(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TFN_JTDMAUTHREQ = function(pReqBuf: PAnsiChar; lReqBufLen: Integer; pResBuf: PAnsiChar; lMinTimeOut: Integer): Integer; stdcall;
var
  Exec: TFN_JTDMAUTHREQ;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'FN_JTDMAUTHREQ');
  if not Assigned(@Exec) then
  begin
    ARecvData := JTNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltDebug, ['DLLȣ��', ASendData]);
  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1], 1) = 1;
  Log.Write(ltDebug, ['DLL����', Result, 'RecvData', ARecvData]);
  // �Ǿ��� ���� 4Byte�� �����ϰ� �����Ѵ�.
  ARecvData := Copy(ARecvData, 5, MAXWORD);
end;

function TVanJtnetDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
var
  TransCode, OrgAgreeDate: AnsiString;
begin
  // �������� (1010: �ſ����, 1012: ���ý���, 1050: �ſ����, 1052: �������, 5010: ���ݽ���, 5050: �������, 6080: ��ǥ��ȸ)
  if AInfo.EyCard then
    TransCode := IfThen(AInfo.Approval, '1012', '1052')
  else
    TransCode := IfThen(AInfo.Approval, '1010', '1050');
  Result := Format('%-4.4s', [TransCode]);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // ����������ȣ
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // ���� ���� ����
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // WCC Ű�ο���
  Result := Result + IfThen(AInfo.KeyInput, 'K', ' ');
  // Ʈ��2 (����2Byte + ī���ȣ=��ȿ�Ⱓ)
  if Pos('=', AInfo.CardNo) <= 0 then
    AInfo.CardNo := AInfo.CardNo + '=';
  AInfo.CardNo := FormatFloat('00', Length(AInfo.CardNo)) + AInfo.CardNo;
  if AInfo.KeyInput then
    Result := Result + Format('%-100.100s', [AInfo.CardNo])
  else
    Result := Result + Format('%-100.100s', ['']);
  // �ҺαⰣ
  Result := Result + FormatFloat('00', AInfo.HalbuMonth);
  // �Ǹűݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt);
  // �ΰ���
  Result := Result + FormatFloat('000000000', AInfo.VatAmt);
  // �����
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt);
  // ��ȭ�ڵ� KRW
  Result := Result + 'KRW';
  // ������ҽ� ����������(6) + �����ι�ȣ(12)
  if AInfo.Approval then
    Result := Result + Format('%-6.6s', ['']) + Format('%-12.12s', [''])
  else
  begin
    OrgAgreeDate := AInfo.OrgAgreeDate;
    if Length(OrgAgreeDate) = 6 then OrgAgreeDate := '20' + OrgAgreeDate;
    Result := Result + Copy(IfThen(OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), OrgAgreeDate), 3, 6) +
              Format('%-12.12s', [AInfo.OrgAgreeNo]);
  end;
  // ���ŷ�������ȣ
  Result := Result + Format('%-12.12s', ['']);
  // ��������
  Result := Result + Format('%-3.3s', ['Y  ']);
  // �����ڵ�
  Result := Result + '  ';
  // �����ڵ�
  Result := Result + '        ';
  // ������ݾ�
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt);
  // ��й�ȣ
  Result := Result + Format('%-18.18s', ['']);
  // ��������
  Result := Result + Format('%-24.24s', ['']);
  // ��������ڹ�ȣ
  Result := Result + Format('%-10.10s', ['']);
  // POS�ø����ȣ
  Result := Result + Format('%-16.16s', ['JPOS150800011EE3']); // JPTP150800015CB5 -> JPOS150800011EE3
  // �ΰ�����1,2
  Result := Result + Format('%-32.32s', ['']) + Format('%-128.128s', ['']);
  // Reserved
  Result := Result + Format('%-64.64s', ['']);
  // ����ó�� (Y:������, N:����̻��, R:��������)
  Result := Result + Format('%-1.1s', [AInfo.SignOption]);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �������� (1010: �ſ����, 1012: ���ý���, 1050: �ſ����, 1052: �������, 5010: ���ݽ���, 5050: �������, 6080: ��ǥ��ȸ)
  if AInfo.Approval then
    Result := Format('%-4.4s', ['5010'])
  else
    Result := Format('%-4.4s', ['5050']);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // ����������ȣ
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // ���� ���� ����
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // WCC
  Result := Result + IfThen(AInfo.KeyInput, 'K', ' ');
  // Ʈ��2 (����2Byte + ī���ȣ=��ȿ�Ⱓ)
  if Pos('=', AInfo.CardNo) <= 0 then
    AInfo.CardNo := AInfo.CardNo + '=';
  AInfo.CardNo := FormatFloat('00', Length(AInfo.CardNo)) + AInfo.CardNo;
  if AInfo.KeyInput then
    Result := Result + Format('%-100.100s', [AInfo.CardNo])
  else
    Result := Result + Format('%-100.100s', ['']);
  // �Ǹűݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt);
  // �ΰ���
  Result := Result + FormatFloat('000000000', AInfo.VatAmt);
  // �����
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt);
  // �ŷ��ڱ��� (0:�Һ��ڼҵ����, 1:�������������)
  Result := Result + IfThen(AInfo.Person = 2, '1', '0');
  // ���ݿ���������϶� ���ŷ�����(yymmdd,6) + �����ι�ȣ(12) + ��һ���(1)
  if Length(AInfo.OrgAgreeDate) = 6 then
    AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    Result := Result + Format('%-19.19s', [''])
  else
    Result := Result + Copy(AInfo.OrgAgreeDate, 3, 6) + Format('%-12.12s', [AInfo.OrgAgreeNo]) + Format('%-1.1s', [IntToStr(AInfo.CancelReason)]);
  // ������ݾ�
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt);
  // ��������ڹ�ȣ
  Result := Result + Format('%-10.10s', ['']);
  // �ΰ�����1,2,3
  Result := Result + Format('%-176.176s', ['']);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �������� (1010: �ſ����, 1012: ���ý���, 1050: �ſ����, 1052: �������, 5010: ���ݽ���, 5050: �������, 6080: ��ǥ��ȸ)
  Result := Format('%-4.4s', ['6080']);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // ����������ȣ
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // ���� ���� ����
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // ��ǥ��ȣ(8) + �����ڵ�(2) + �����ڵ�(4) + �����ڵ�(2)
  Result := Result + Format('%-16.16s', [Copy(AInfo.CheckNo, 1, 8) + Copy(AInfo.BankCode, 1, 2) + Copy(AInfo.BranchCode, 1, 4) + Copy(AInfo.KindCode, 1, 2)]);
  // ��ǥ�ݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt);
  // ��ǥ��������
  if Length(AInfo.RegDate) = 6 then
    Result := Result + Format('%-6.6s', [Copy(AInfo.RegDate, 1, 6)])
  else
    Result := Result + Format('%-6.6s', [Copy(AInfo.RegDate, 3, 6)]);
  // ���������ڵ�
  Result := Result + Format('%-6.6s', [Copy(AInfo.AccountNo, 1, 6)]);
  // �ΰ�����1
  Result := Result + Format('%-16.16s', ['']);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
var
  GiftCardAmt: AnsiString;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 97, 4));
  // ��������
  Result.Result := Result.Code = '0000';
  if Result.Result then
  begin
    // ���ι�ȣ
    Result.AgreeNo := Trim(Copy(ARecvData, 97+4, 12));
    // �ŷ��Ͻ�
    Result.AgreeDateTime := '20' + Copy(ARecvData, 97+16, 12);
    // �ŷ���ȣ
    Result.TransNo := Trim(Copy(ARecvData, 97+28, 12));
  end;
  // ��������ȣ
  Result.KamaengNo := Trim(Copy(ARecvData, 97+40, 15));
  // �߱޻��ڵ�
  Result.BalgupsaCode := Trim(Copy(ARecvData, 97+55, 4));
  // �߱޻��
  Result.BalgupsaName := Trim(Copy(ARecvData, 97+59, 20));
  // ���Ի��ڵ�
  Result.CompCode := Trim(Copy(ARecvData, 97+79, 4));
  // ���Ի��
  Result.CompName := Trim(Copy(ARecvData, 97+83, 20));
  // ���αݾ�
  //Result.AgreeAmt  := //������ ���αݾ� ����.
  // ���αݾ�
  Result.DCAmt := StrToIntDef(Copy(ARecvData, 97+108, 9), 0);
  // ICī���ȣ
  Result.CardNo := Trim(Copy(ARecvData, 97+430, 20));
  // ���� ���� ����
  Result.IsSignOK := True;
  // ����޼���
  if Result.Result then
  begin
    GiftCardAmt := Trim(Copy(ARecvData, 97+144, 9)); // ����ī�� �ܾ�
    if GiftCardAmt <> '' then
      GiftCardAmt := IntToStr(StrToIntDef(GiftCardAmt, 0));
    Result.Msg := IfThen(GiftCardAmt <> '', '�ܾ�: ' + GiftCardAmt + ' ', '') + Trim(Copy(ARecvData, 97+450, 168));
  end
  else
    Result.Msg :=  Trim(Copy(ARecvData, 97+4, 36));
end;

function TVanJtnetDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // �����ڵ�
  Result.Code := Trim(Copy(ARecvData, 97, 4));
  Result.Result := Result.Code = '0000';
  if Result.Result then
  begin
    // ���ι�ȣ
    Result.AgreeNo := Trim(Copy(ARecvData, 97+4, 12));
    // �����Ͻ�(yymmddhhmmss)
    Result.AgreeDateTime := '20' + Copy(ARecvData, 97+16, 12);
    // ȭ��ǥ�ø޼���
    Result.Msg := Trim(Copy(ARecvData, 97+375, 168));
  end
  else
    // ȭ��ǥ�ø޼���
    Result.Msg := Trim(Copy(ARecvData, 97+4, 36));
  // ī���ȣ
  Result.CardNo := Trim(Copy(ARecvData, 97+355, 20));
end;

function TVanJtnetDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // �����ڵ�
  Result. Code := Trim(Copy(ARecvData, 97, 4));
  // ���
  Result.Result := Result.Code = '0000';
  // �������(���� ����)
  if Result.Result then
    Result.Msg := '�����ǥ'
  else
    Result.Msg := Trim(Copy(ARecvData, 97+4, 36));
end;

function TVanJtnetDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanJtnetDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCard(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCash(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanJtnetDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  AInfo.Approval := True;
  SendData := MakeSendDataCheck(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := 'PC' + FormatFloat('000000000', ASendAmt) + RPadB('�ĺ���ȣ �Է�', 16) + CR;
  // DLL ȣ���Ѵ�.
  if DLLExecAblity(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := True;
    ARecvData := Trim(Copy(RecvData, 3, 49));
  end
  else
  begin
    Result := False;
    ARecvData := Copy(RecvData, 5, MAXWORD);
  end;
end;

{ TVanNiceDaemon }

constructor TVanNiceDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(NICE_DAEMON_DLL);
end;

destructor TVanNiceDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanNiceDaemon.DLLExecVCat(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TNICEVCAT = function(ASendData: PAnsiChar; ARecvData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TNICEVCAT;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'NICEVCAT');
  if not Assigned(@Exec) then
  begin
    ARecvData := NICE_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Ret := Exec(PAnsiChar(ASendData), @ARecvData[1]);
  Result := Ret = 1;
  if not Result then
  begin
    case Ret of
       -1 : ARecvData := 'NVCAT ������ �������� �ƴ�';
       -2 : ARecvData := '�ŷ��ݾ��� �������� ����';
       -3 : ARecvData := 'ȯ������ �б� ����';
       -4 : ARecvData := 'NVCAT �������� ����';
       -5 : ARecvData := '��Ÿ ���䵥���� ����';
       -6 : ARecvData := 'ī�帮�� Ÿ�Ӿƿ�';
       -7 : ARecvData := '����� �� ������ ���';
       -8 : ARecvData := 'FALLBACK �ŷ���û';
       -9 : ARecvData := '��Ÿ����';
      -10 : ARecvData := 'IC �켱�ŷ���û(ICī�� MS������)';
      -11 : ARecvData := 'FALLBACK �ŷ� �ƴ�';
      -12 : ARecvData := '�ŷ��Ұ�ī��';
      -13 : ARecvData := '�����û����';
      -14 : ARecvData := '��û ���� ������ ����';
      -15 : ARecvData := 'ī�帮�� Port���� ����';
      -16 : ARecvData := '�����ŷ� ����ҺҰ�(����������ȣ ����)';
      -17 : ARecvData := '�ߺ���û �Ұ�';
      -18 : ARecvData := '�������� �ʴ� ī��';
      -19 : ARecvData := '����ICī�� �������� ������';
      -20 : ARecvData := 'TIT ī�帮�� ����';
    else
      ARecvData := '�˼� ���� ����';
    end;
  end;
  Log.Write(ltDebug, ['DaemonDLLȣ��', Result, '�Լ����ϰ�', Ret, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanNiceDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �ŷ����� (4�ڸ�, ����:0200 ���:0420)
  if AInfo.Approval then
    Result := '0200' + FS
  else
    Result := '0420' + FS;
  // �ŷ����� (�ſ�:10 ���ݿ�����:21 ����ī��:UP)
  if AInfo.EyCard then
    Result := Result + 'UP' + FS
  else
    Result := Result + '10' + FS;
  // WCC (ī��:C KeyIn:K FALLBACK: F)
  Result := Result + 'C' + FS;
  // �ŷ��ݾ�
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // �ΰ���
  Result := Result + CurrToStr(AInfo.VatAmt) + FS;
  // �����
  Result := Result + CurrToStr(AInfo.SvcAmt) + FS;
  // �ҺαⰣ
  Result := Result + FormatFloat('00', AInfo.HalbuMonth) + FS;
  // �� ���ι�ȣ
  Result := Result + IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo) + FS;
  // �� ��������
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '', Copy(AInfo.OrgAgreeDate, 3, 6)) + FS;
  // ����CATID
  Result := Result + AInfo.TerminalID + FS;
  Result := Result + FS + FS;
  // �ŷ��Ϸù�ȣ (������)
  Result := Result + FS;
  // �鼼�ݾ�
  Result := Result + CurrToStr(AInfo.FreeAmt) + FS;
  // �����ڹ�ȣ ������
  Result := Result + FS;
  // �����ڹ�ȣ Data
  Result := Result + FS;
  // ����������ȣ
  Result := Result + FS;
  // Filler
  Result := Result + FS;
  // �����е� ǥ�� �ݾ�
  Result := Result + FS;
end;

function TVanNiceDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �ŷ����� (4�ڸ�, ����:0200 ���:0420)
  if AInfo.Approval then
    Result := '0200' + FS
  else
    Result := '0420' + FS;
  // �ŷ����� (�ſ�:10 ���ݿ�����:21 ����ī��:UP)
  Result := Result + '21' + FS;
  // WCC (ī��:C KeyIn:K FALLBACK: F)
  if AInfo.KeyInput then
    Result := Result + 'K' + FS
  else
    Result := Result + 'C' + FS;
  // �ŷ��ݾ�
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // �ΰ���
  Result := Result + CurrToStr(AInfo.VatAmt) + FS;
  // �����
  Result := Result + CurrToStr(AInfo.SvcAmt) + FS;
  // ���� (01:�ҵ����, 02:��������, 03:�����߱�)
  Result := Result + FormatFloat('00', AInfo.Person) + FS;
  // �� ���ι�ȣ
  Result := Result + IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo) + FS;
  // �� ��������
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '', Copy(AInfo.OrgAgreeDate, 3, 6)) + FS;
  // ����CATID
  Result := Result + FS;
  Result := Result + FS + FS;
  // �ŷ��Ϸù�ȣ (������)
  Result := Result + FS;
  // �鼼�ݾ�
  Result := Result + CurrToStr(AInfo.FreeAmt) + FS;
  // �����ڹ�ȣ ������
  Result := Result + FS;
  // �����ڹ�ȣ Data
  Result := Result + FS;
  // ����������ȣ
  Result := Result + FS;
  // Filler
  Result := Result + FS;
  // �����е� ǥ�� �ݾ�
  Result := Result + FS;
end;

function TVanNiceDaemon.MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �ŷ�����
  Result := '0200' + FS;
  // �ŷ����� (��ǥ��ȸ:20)
  Result := Result + '20' + FS;
  // WCC (KeyIn:K)
  Result := Result + 'K' + FS;
  // ��ǥ���� (�ڱ�ռ�ǥ:00 �����ǥ:01 ���¼�ǥ:02)
  Result := Result + '00' + FS;
  // ��ǥ����
  Result := Result + Format('%-2.2s', [AInfo.KindCode]) + FS;
  // ��ǥ��ȣ
  Result := Result + Format('%-14.14s', [LeftStr(AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode, 14)]) + FS;
  // ������
  Result := Result + Format('%-6.6s', [AInfo.RegDate]) + FS;
  // �ֹε�Ϲ�ȣ
  Result := Result + '             ' + FS;
  // ��ǥ�ݾ�
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // �����Ϸù�ȣ
  Result := Result + Format('%-6.6s', [AInfo.AccountNo]) + FS;
end;

function TVanNiceDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 2);
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 16);
  // ���ι�ȣ
  Result.AgreeNo := StringSearch(ARecvData, FS, 7);
  // �����Ͻ�(yyyymmddhhnnss)
  Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 8);
  // �ŷ���ȣ
  Result.TransNo := StringSearch(ARecvData, FS, 19);
  // �߱޻��ڵ�
  Result.BalgupsaCode := StringSearch(ARecvData, FS, 9);
  // �߱޻��
  Result.BalgupsaName := StringSearch(ARecvData, FS, 10);
  // ���Ի��ڵ�
  Result.CompCode := StringSearch(ARecvData, FS, 11);
  // ���Ի��
  Result.CompName := StringSearch(ARecvData, FS, 12);
  // ��������ȣ
  Result.KamaengNo := StringSearch(ARecvData, FS, 13);
  // ���αݾ�
  Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 3), 0);
  // ���αݾ�
  Result.DCAmt := 0;
  // ����ŷ�� ī���ȣ
  Result.CardNo := StringSearch(ARecvData, FS, 17);
  // ���� ���� ����
  Result.IsSignOK := True;
  // ��������
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 2);
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 16);
  // ���ι�ȣ
  Result.AgreeNo := StringSearch(ARecvData, FS, 7);
  // �����Ͻ�(yyyymmddhhnnss)
  Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 8);
  // ����ŷ�� ī���ȣ
  Result.CardNo := StringSearch(ARecvData, FS, 17);
  // ��������
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 2);
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 4);
  // ��������
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanNiceDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCard(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCard(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCash(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '��� �̱���';
end;

function TVanNiceDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  SendData := MakeSendDataCheck(AInfo);
  // DLL ȣ���Ѵ�.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // ������ ó���Ѵ�.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

{ TVanSmartroDaemon }

constructor TVanSmartroDaemon.Create;
begin
  inherited;
  SmtSndRcvVCAT := TSmtSndRcvVCAT.Create(nil);
end;

destructor TVanSmartroDaemon.Destroy;
begin
  SmtSndRcvVCAT.Free;
  inherited;
end;

function TVanSmartroDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  TempStr: AnsiString;
begin
  Result.Result := False;
  // �ʱ�ȭ
  SmtSndRcvVCAT.InitData;
  // ���� ���� (0101:�ŷ����� 2101:�ŷ����)
  if not SetSendData(1, IfThen(AInfo.Approval, '0101', '2101'), Result.Msg) then Exit;
  // �ŷ� ���� �ڵ� (01:�ſ� 02:���� 03:����)
  if not SetSendData(2, IfThen(AInfo.EyCard, '03', '01'), Result.Msg) then Exit;
  // �Ǹűݾ�
  if not SetSendData(3, FormatFloat('0000000000', (AInfo.SaleAmt)), Result.Msg) then Exit;
  // �ΰ���
  if not SetSendData(4, FormatFloat('00000000', AInfo.VatAmt), Result.Msg) then Exit;
  // �����
  if not SetSendData(5, FormatFloat('00000000', AInfo.SvcAmt), Result.Msg) then Exit;
  // �Һΰ���
  if not SetSendData(6, FormatFloat('00', AInfo.HalbuMonth), Result.Msg) then Exit;
  if not AInfo.Approval then
  begin
    // ���ι�ȣ
    if not SetSendData(12, AInfo.OrgAgreeNo, Result.Msg) then Exit;
    // �����Ͻ�
    if (Length(AInfo.OrgAgreeDate) = 6) then
       AInfo.OrgAgreeDate := '20' +  AInfo.OrgAgreeDate;
    if not SetSendData(13, AInfo.OrgAgreeDate, Result.Msg) then Exit;
  end;
  // ������ (1:�񼭸� 2:���� 3:�ܸ������)
  if AInfo.SignOption = 'Y' then
    TempStr := '2'
  else if AInfo.SignOption = 'N' then
    TempStr := '1'
  else
    TempStr := '3';
  if not SetSendData(9, TempStr, Result.Msg) then Exit;
  // �����ʵ�1 (��Ƽ����� �ܸ���ID)
  if AInfo.TerminalID <> '' then
  begin
    // TAG(2 Byte) + LENGTH(3 Byte) + DATA
    TempStr := '49' + '010' + Format('%-10.10s', [AInfo.TerminalID]);
    if not SetSendData(10, TempStr, Result.Msg) then Exit;
  end;

  // ���� ȣ��
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // �����ڵ�
    Result.Result := Result.Code = '00';                      // ������
    Result.Msg := GetRecvData(18);                            // ���� �޼���
    Result.CardNo := GetRecvData(3);                          // ī���ȣ
    Result.AgreeAmt := StrToIntDef(GetRecvData(4), 0);        // ���αݾ�
    Result.AgreeNo := GetRecvData(8);                         // ���ι�ȣ
    Result.AgreeDateTime := GetRecvData(9) + GetRecvData(10); // �ŷ��Ͻ�
    Result.TransNo := GetRecvData(11);                        // �ŷ�������ȣ
    Result.KamaengNo := GetRecvData(12);                      // ��������ȣ
    Result.BalgupsaCode := Copy(GetRecvData(14), 1, 4);       // �߱޻��ڵ�
    Result.BalgupsaName := Copy(GetRecvData(14), 5, MAXBYTE); // �߱޻��
    Result.CompCode := Copy(GetRecvData(15), 1, 4);           // ���Ի��ڵ�
    Result.CompName := Copy(GetRecvData(15), 5, MAXBYTE);     // ���Ի��
    Result.IsSignOK := GetRecvData(24) <> '';                 // ����
    Result.DCAmt := 0;
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  TempStr: AnsiString;
begin
  Result.Result := False;
  // �ʱ�ȭ
  SmtSndRcvVCAT.InitData;
  // ���� ���� (0101:�ŷ����� 2101:�ŷ����)
  if not SetSendData(1, IfThen(AInfo.Approval, '0101', '2101'), Result.Msg) then Exit;
  // �ŷ� ���� �ڵ� (01:�ſ� 02:���� 03:����)
  if not SetSendData(2, '02', Result.Msg) then Exit;
  // �Ǹűݾ�
  if not SetSendData(3, FormatFloat('0000000000', (AInfo.SaleAmt)), Result.Msg) then Exit;
  // �ΰ���
  if not SetSendData(4, FormatFloat('00000000', AInfo.VatAmt), Result.Msg) then Exit;
  // �����
  if not SetSendData(5, FormatFloat('00000000', AInfo.SvcAmt), Result.Msg) then Exit;
  // �ŷ��ڱ��� (0:���� 1:�����) + Ȯ���ڱ��� (0:�ſ�ī�� 1:�ֹι�ȣ 2:����� 3:�ڵ��� 4:���ʽ�ī��)
  if AInfo.Person = 1 then
    TempStr := '0' + IfThen(AInfo.KeyInput, '3', '0')
  else
    TempStr := '1' + IfThen(AInfo.KeyInput, '2', '0');
  if not SetSendData(6, TempStr, Result.Msg) then Exit;
  if not AInfo.Approval then
  begin
    // ���ι�ȣ
    if not SetSendData(12, AInfo.OrgAgreeNo, Result.Msg) then Exit;
    // �����Ͻ�
    if (Length(AInfo.OrgAgreeDate) = 6) then
       AInfo.OrgAgreeDate := '20' +  AInfo.OrgAgreeDate;
    if not SetSendData(13, AInfo.OrgAgreeDate, Result.Msg) then Exit;
    // ������һ���
    if not SetSendData(14, FormatFloat('0', AInfo.CancelReason), Result.Msg) then Exit;
  end;
  // ������ (0:�ܸ������, 1:���ݿ�����ī��, 2:���е�)
  if not SetSendData(9, IfThen(AInfo.KeyInput, '2', '1'), Result.Msg) then Exit;
  // �����ʵ�1 (��Ƽ����� �ܸ���ID)
  if AInfo.TerminalID <> '' then
  begin
    // TAG(2 Byte) + LENGTH(3 Byte) + DATA
    TempStr := '49' + '010' + Format('%-10.10s', [AInfo.TerminalID]);
    if not SetSendData(10, TempStr, Result.Msg) then Exit;
  end;

  // ���� ȣ��
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // �����ڵ�
    Result.Result := Result.Code = '00';                      // ������
    Result.Msg := GetRecvData(18);                            // ���� �޼���
    Result.CardNo := GetRecvData(3);                          // ī���ȣ
    Result.AgreeNo := GetRecvData(8);                         // ���ι�ȣ
    Result.AgreeDateTime := GetRecvData(9) + GetRecvData(10); // �����Ͻ�
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanSmartroDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  CheckInfo: AnsiString;
begin
  Result.Result := False;
  // �ʱ�ȭ
  SmtSndRcvVCAT.InitData;
  // ���� ���� (0401:��ǥ��ȸ)
  if not SetSendData(1, '0401', Result.Msg) then Exit;
  // ���� (00:�ڱ�ռ�ǥ)
  if not SetSendData(56, '00', Result.Msg) then Exit;
  // ��ǥ����  ��ǥ��ȣ(8) + �����ڵ�(2) + �����ڵ�(4) + ���¹�ȣ(6)
  CheckInfo := Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
               Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]);
  if not SetSendData(57, CheckInfo, Result.Msg) then Exit;
  // ��ǥ��������
  if not SetSendData(58, Copy(AInfo.RegDate, 3, 6), Result.Msg) then Exit;
  // �����ڵ�
  if not SetSendData(59, AInfo.KindCode, Result.Msg) then Exit;
  // ��ǥ�ݾ�
  if not SetSendData(60, FormatFloat('000000000000', AInfo.SaleAmt), Result.Msg) then Exit;
  // ���� ȣ��
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // �����ڵ�
    Result.Result := Result.Code = '00';                      // ������
    Result.Msg := GetRecvData(18);                            // ���� �޼���
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

function TVanSmartroDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanSmartroDaemon.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
      1 : Result := '�������';
     -1 : Result := '���ο���';
     -3 : Result := '�۽� DATA ������������';
    -40 : Result := 'IP�Է°� ����';
    -30 : Result := '���� ���� ����';
    -31 : Result := 'DATA���� ����';
    -10 : Result := 'NAK����';
    -11 : Result := 'FF����';
    -12 : Result := 'ETX Check Fail';
    -13 : Result := 'STX Check Fail';
     -9 : Result := 'TimerOut';
    -99 : Result := '���ǵ��� ���� ����';
    -98 : Result := '�������䰪 ����';
    -97 : Result := '�������� INDEX ����';
    -96 : Result := '�޸� ȣ�� ����';
    -95 : Result := '�ܸ��� COM, TCP ���ÿ���';
    -94 : Result := '���������� �Է� ����';
  else
    Result := '��Ÿ ����';
  end;
  if ACode <> 0 then
    Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanSmartroDaemon.SetSendData(const AIndex: Integer; const AValue: AnsiString; out ARetMsg: AnsiString): Boolean;
begin
  Result := False;
  if SmtSndRcvVCAT.SetTRData(AIndex, AValue) = 1 then
  begin
    ARetMsg := '����';
    Result := True;
  end
  else
  begin
    case AIndex of
      1  : ARetMsg := '���� ������ �ڵ� �Է¿���';
      2  : ARetMsg := '�ŷ������ڵ� �Է¿���';
      3  : ARetMsg := '���ο�û�ݾ� �Է¿���';
      4  : ARetMsg := '���� �Է¿���';
      5  : ARetMsg := '����� �Է¿���';
      6  : ARetMsg := '���ݽ������� �Է¿���';
      7  : ARetMsg := '��й�ȣ �Է¿���';
      8  : ARetMsg := '��ǥ�� �μ��� ǰ��� �Է¿���';
      9  : ARetMsg := '������ �Է¿���';
      10 : ARetMsg := '�����ʵ�1 �Է¿���';
      11 : ARetMsg := '�����ʵ�2 �Է¿���';
      12 : ARetMsg := '���ι�ȣ �Է¿���';
      13 : ARetMsg := '���ŷ����� �Է¿���';
      14 : ARetMsg := '������ұ��� �Է¿���';
      15 : ARetMsg := '���ʽ������� �Է¿���';
      16 : ARetMsg := '���ʽ� ��뱸�� �Է¿���';
      17 : ARetMsg := '���ʽ� ���ι�ȣ �Է¿���';
      18 : ARetMsg := 'MasterKey Index �Է¿���';
      19 : ARetMsg := 'WorkingKey �Է¿���';
    else
      ARetMsg := '���� ���� ���� �Է¿���';
    end;
  end;
end;

function TVanSmartroDaemon.GetRecvData(const AIndex: Integer): AnsiString;
begin
  Result := SmtSndRcvVCAT.GetResDataCount(1, AIndex);
end;

{ TVanKcpDaemon }

constructor TVanKcpDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(LIBKCP_SECURE_DLL);
end;

destructor TVanKcpDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKcpDaemon.MakeSendDataHeader(AApproval: Boolean; AProcCode, ATerminalID: AnsiString; ADetailSendData: AnsiString): AnsiString;
begin
  if AProcCode = 'C06000' then
    Result := '4100'
  else
    // ��û����
    Result := IfThen(AApproval, '0100', '0420');

  // ��������
  Result := Result + AProcCode;
  // �ܸ���ID (���󿡼� ���߻���ڷ� ���õ� ��� �����.)
  Result := Result + Format('%-10.10s', [ATerminalID]);
  // ��ü�ڵ�
  Result := Result + Format('%-4.4s', [KCP_VER_INFO]);
  // ���� �ø����ȣ
  Result := Result + Format('%-16.16s', ['']);
  // ���� ��ǰ��
  Result := Result + Format('%-12.12s', ['']);
  // ���� S/W����
  Result := Result + Format('%-4.4s', ['']);
  // ����������ȣ
  Result := Result + FormatFloat('000000', GetSeqNo) + FS;
  Result := Result + ADetailSendData;
  Result := STX + FormatFloat('0000', Length(Result)) + Result;
end;

function TVanKcpDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �ŷ����� (���ȸ�����ó��: '99')
  if AInfo.OTCNo = EmptyStr then
    Result := '99' + FS
  else
  begin
    if Length(AInfo.OTCNo) < 30 then
      Result := '80' + FS
    else
      Result := '90' + FS;
  end;
  // �Һΰ�����
  Result := Result + FormatFloat('00', AInfo.HalbuMonth) + FS;
  // �Ѱŷ��ݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt) + FS;
  // �����ݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.FreeAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS;
  // �鼼�ݾ�
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt) + FS;
  // �����
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt) + FS;
  // ����
  Result := Result + FormatFloat('000000000', AInfo.VatAmt) + FS;
  if AInfo.Approval then
  begin
    // ��û����
    Result := Result + FormatDateTime('yymmdd', Now) + FS;
    // �����ι�ȣ
    Result := Result + FS;
  end
  else
  begin
    // ���ŷ�����
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yymmdd', Now), AInfo.OrgAgreeDate), 3, 6) + FS;
    // �����ι�ȣ
    Result := Result + AInfo.OrgAgreeNo + FS;
  end;
  // �鼼������
  Result := Result + FS;
  // �������Ϳ�û
  Result := Result + FS;
  // ��������
  Result := Result + FS;
  // �����, ����Ʈ ����
  Result := Result + FS;
  // ����Ʈ �������� ����
  Result := Result + FS;
  // PG ���� ����
  if AInfo.Reserved1 <> '' then
    Result := Result + 'Y' + FS
  else
    Result := Result + FS;
  // ����� DATA
  if AInfo.Reserved1 <> '' then
    Result := Result + '0002' + SI + SI + SI + SI + SI + '000000000' + SI + '000000000' + FS
  else
    Result := Result + FS;
  // ����Ÿ��
  Result := Result + FS;
  // ��ǥ��ǰ��
  Result := Result + FS;
  // ��ǰ DATA
  Result := Result + FS;
  // Ű����ũ ����
  Result := Result + FS;
  // ����
//  if AInfo.Reserved1 <> '' then
//    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + ETX
//  else
//    Result := Result + ETX;
  if AInfo.Reserved1 <> '' then
    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + FS
  else
    Result := Result + FS;
  // OTC ��ȣ(��ī��)
  Result := Result + AInfo.OTCNo + FS;
  // �ŷ���ȣ(�ŷ���ȣ�� ��ҽ� �ʿ�)
  Result := Result + EmptyStr + FS;
  // ī���ȣ Bin
  Result := Result + Ifthen(AInfo.CardBinNo = EmptyStr, '', Copy(AInfo.CardBinNo, 1, 6));

  Result := Result + ETX;
end;

function TVanKcpDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ETX���� �ڸ���.
  ARecvData := StringSearch(ARecvData, ETX, 0);
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 1);
  Result.Result := Result.Code = '0000';
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 2) + StringSearch(ARecvData, FS, 3) + StringSearch(ARecvData, FS, 4) + StringSearch(ARecvData, FS, 5);
  if Result.Result then
  begin
    // ī��BIN
    Result.CardNo := StringSearch(ARecvData, FS, 6);
    // ���Ի��ڵ�
    Result.CompCode := StringSearch(ARecvData, FS, 7);
    // ���Ի��
    Result.CompName := StringSearch(ARecvData, FS, 8);
    // �߱޻��ڵ�
    Result.BalgupsaCode := StringSearch(ARecvData, FS, 9);
    // �߱޻��
    Result.BalgupsaName := StringSearch(ARecvData, FS, 10);
    // ��������ȣ
    Result.KamaengNo := StringSearch(ARecvData, FS, 11);
    // �ŷ������Ͻ�
    Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 12);
    // �ŷ�������ȣ
    Result.TransNo := StringSearch(ARecvData, FS, 13);
    // �Ѱŷ��ݾ�
    Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 15), 0);
    Result.DCAmt := 0;
    // ���ι�ȣ
    Result.AgreeNo := StringSearch(ARecvData, FS, 21);
    // ���� ���� ����
    Result.IsSignOK := True;
  end;
end;

function TVanKcpDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ETX���� �ڸ���.
  ARecvData := StringSearch(ARecvData, ETX, 0);
  // �����ڵ�
  Result.Code := StringSearch(ARecvData, FS, 1);
  Result.Result := Result.Code = '0000';
  // ����޼���
  Result.Msg := StringSearch(ARecvData, FS, 2) + StringSearch(ARecvData, FS, 3) + StringSearch(ARecvData, FS, 4) + StringSearch(ARecvData, FS, 5);
  if Result.Result then
  begin
    // ī��BIN
    Result.CardNo := StringSearch(ARecvData, FS, 6);
    // �ŷ������Ͻ�
    Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 12);
    // ���ι�ȣ
    Result.AgreeNo := StringSearch(ARecvData, FS, 21);
  end;
end;

function TVanKcpDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // �ŷ����� (���ȸ�����ó��:'99', Key-In:'10')
  Result := IfThen(AInfo.KeyInput, '10', '99') + FS;
  // �ź�����
  Result := Result + AInfo.CardNo + FS;
  // �ŷ��ڱ���
  Result := Result + IfThen(AInfo.Person = 2, '1', '0') + FS;
  // �Ѱŷ��ݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt) + FS;
  // �����ݾ�
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.FreeAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS;
  // �鼼�ݾ�
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt) + FS;
  // �����
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt) + FS;
  // ����
  Result := Result + FormatFloat('000000000', AInfo.VatAmt) + FS;
  if AInfo.Approval then
  begin
    // ��û����
    Result := Result + FormatDateTime('yymmdd', Now) + FS;
    // �����ι�ȣ
    Result := Result + FS;
  end
  else
  begin
    // ���ŷ�����
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yymmdd', Now), AInfo.OrgAgreeDate), 3, 6) + FS;
    // �����ι�ȣ
    Result := Result + AInfo.OrgAgreeNo + FS;
  end;
  // ��һ����ڵ�
  Result := Result + IfThen(AInfo.Approval, '0', IntToStr(AInfo.CancelReason));
  // PG ���� ����
  if AInfo.Reserved1 <> '' then
    Result := Result + 'Y' + FS
  else
    Result := Result + FS;
  // ����� DATA
  if AInfo.Reserved1 <> '' then
    Result := Result + '0002' + SI + SI + SI + SI + SI + '000000000' + SI + '000000000' + FS
  else
    Result := Result + FS;
  // Ű����ũ ����
  Result := Result + FS;
  // ����
  if AInfo.Reserved1 <> '' then
    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + ETX
  else
    Result := Result + ETX;
end;

function TVanKcpDaemon.DLLExecTrans(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKCPDaemonTrans = function(sReqData: PAnsiChar; sReqLen: Integer; sResData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TKCPDaemonTrans;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'KCPDaemonTrans');
  if not Assigned(@Exec) then
  begin
    ARecvData := LIBKCP_SECURE_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1]) > 0;
  Log.Write(ltDebug, ['KcpDaemon�������', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKcpDaemon.DLLExecFunction(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKCPDaemonFunction = function(sReqData: PAnsiChar; sReqLen: Integer; sResData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TKCPDaemonFunction;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'KCPDaemonFunction');
  if not Assigned(@Exec) then
  begin
    ARecvData := LIBKCP_SECURE_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1]) > 0;
  Log.Write(ltDebug, ['KcpDaemon�ΰ����', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKcpDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendDataCard(AInfo);
  if AInfo.EyCard then
    SendData := MakeSendDataHeader(AInfo.Approval, 'A02000', AInfo.TerminalID, SendData)
  else
    SendData := MakeSendDataHeader(AInfo.Approval, 'A01000', AInfo.TerminalID, SendData);

  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCard(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ��û����
  SendData := '0100';
  // ��������
  SendData := SendData + 'R04000';
  // �ܸ���ID (���󿡼� ���߻���ڷ� ���õ� ��� �����.)
  SendData := SendData + Format('%-10.10s', [AInfo.TerminalID]);
  // ��ü�ڵ�
  SendData := SendData + Format('%-4.4s', [KCP_VER_INFO]);
  // ���� �ø����ȣ
  SendData := SendData + Format('%-16.16s', ['']);
  // ���� ��ǰ��
  SendData := SendData + Format('%-12.12s', ['']);
  // ���� S/W����
  SendData := SendData + Format('%-4.4s', ['']);
  // ����������ȣ
  SendData := SendData + FormatFloat('000000', GetSeqNo) + FS;
  SendData := SendData + ETX;
  SendData := STX + FormatFloat('0000', Length(SendData)) + SendData;

  if DLLExecTrans(SendData, RecvData) then
  begin
    RecvData := StringSearch(RecvData, ETX, 0);
    // �����ڵ�
    Result.Result := StringSearch(RecvData, FS, 1) = '0000';
    Result.CardBinNo := StringSearch(RecvData, FS, 6);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  Log.Write(ltInfo, ['ICī�� ���Կ��� ��ȸ ��û', '']);
  ARespCode := '';
  ARecvData := '';
  SendData := IfThen(ASamsungPay, 'Y', 'N') + ETX;
  SendData := MakeSendDataHeader(True, 'R02000', ATerminalID, SendData);
  if DLLExecTrans(SendData, ARecvData) then
  begin
    // ETX���� �ڸ���.
    ARecvData := StringSearch(ARecvData, ETX, 0);
    // ī�� ���Ի��� ���
    ARespCode := StringSearch(ARecvData, FS, 1);
    if (ARespCode = '0000') then
      Result := (StringSearch(ARecvData, FS, 5) = 'Y');
  end;
  ARecvData := Trim(ARecvData);
  Log.Write(ltInfo, ['����', Result]);
end;

function TVanKcpDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendDataCash(AInfo);
  SendData := MakeSendDataHeader(AInfo.Approval, 'C01000', AInfo.TerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCash(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := '0' + FS +
              AInfo.KindCode + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + FS +
              CurrToStr(AInfo.SaleAmt) + FS +
              Copy(AInfo.RegDate, 3, 6) + FS +
              AInfo.AccountNo + FS +
              '' + ETX;
  SendData := MakeSendDataHeader(True, 'C06000', AInfo.TerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCard(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKcpDaemon.CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
var
  SendData, RecvData: AnsiString;
begin
  Result := False;
  Log.Write(ltInfo, ['���Ἲ ���� ��û', '']);
  SendData := ETX;
  SendData := MakeSendDataHeader(True, 'F01000', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX���� �ڸ���.
    RecvData := StringSearch(RecvData, ETX, 0);
    // �����ڵ�
    Result := StringSearch(RecvData, FS, 1) = '0000';
    // ����޼���
    ARecvData := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
    // ���Ἲ���� ���
    if Result then
      Result := StringSearch(RecvData, FS, 6) = '00';
  end
  else
  begin
    Result := False;
    ARecvData := Trim(RecvData);
  end;
  Log.Write(ltInfo, ['����', Result]);
end;

function TVanKcpDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

function TVanKcpDaemon.DoPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := ABizNo + ETX; // ����ڹ�ȣ
  SendData := MakeSendDataHeader(True, 'D01000', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX���� �ڸ���.
    RecvData := StringSearch(RecvData, ETX, 0);
    Result.Code := StringSearch(RecvData, FS, 1); // �����ڵ�
    Result.Result := Result.Code = '0000';
    Result.Msg := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + // ����޼���
                  StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ��ȣ���� (Key�ٿ�ε�)
  SendData := ABizNo + ETX; // ����ڹ�ȣ
  SendData := MakeSendDataHeader(True, 'F01001', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX���� �ڸ���.
    RecvData := StringSearch(RecvData, ETX, 0);
    Result.Code := StringSearch(RecvData, FS, 1); // �����ڵ�
    Result.Result := Result.Code = '0000';
    Result.Msg := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + // ����޼���
                  StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
    // ��ȣ���� ���
    if Result.Result then
      Result.Result := StringSearch(RecvData, FS, 6) = '00';
  end
  else
  begin
    Result.Result := False;
    Result.Code := Trim(RecvData);
  end;
end;

{ TVanDaouDaemon }

constructor TVanDaouDaemon.Create;
begin
  inherited;
end;

destructor TVanDaouDaemon.Destroy;
begin
  inherited;
end;

function TVanDaouDaemon.ExecTcpSendData(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
var
  {$IF RTLVersion > 19.00}
  IdTCPClient: TIdTCPClient;
  ABuff: TIdBytes;
  {$ELSE}
  ClientSocket: TClientSocket;
  ABuff: array[1..2048] of AnsiChar;
  {$IFEND}
begin
  Result := False;
  Log.Write(ltDebug, ['��������', ASendData]);
  try
    try
      {$IF RTLVersion > 19.00}
      IdTCPClient := TIdTCPClient.Create(nil);
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 23738;
      IdTCPClient.ConnectTimeout := 3000;
      IdTCPClient.Connect;

      SetLength(ABuff, 0);
      if IdTCPClient.Connected then
      begin
        if Trim(ASendData) <> '' then
          IdTCPClient.IOHandler.Write(ASendData, IndyTextEncoding_OSDefault);
        IdTCPClient.IOHandler.ReadBytes(ABuff, -1, False);
        ARecvData := BytesToString(ABuff, IndyTextEncoding_OSDefault);
        Result := True;
      end
      else
        ARecvData := '���� ���� ����!!!';
      {$ELSE}
      ClientSocket := TClientSocket.Create(nil);
      ClientSocket.Host := '127.0.0.1';
      ClientSocket.Port := 23738;
      ClientSocket.OnRead := ClientSocketRead;
      ClientSocket.Active := True;
      FReceiveBuff := '';
      Result := SocketSendReceiveData(ClientSocket, ASendData, ARecvData);
      {$IFEND}
    except on E: Exception do
      ARecvData := '������ ����� ���� �߻� ' + E.Message;
    end;
    Log.Write(ltDebug, ['��Ű��', Result, '��������', ARecvData]);
  finally
    {$IF RTLVersion > 19.00}
    IdTCPClient.Free;
    {$ELSE}
    ClientSocket.Free;
    {$IFEND}
  end;
end;

{$IF RTLVersion < 19.00}
procedure TVanDaouDaemon.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  FReceiveBuff := FReceiveBuff + Socket.ReceiveText;
end;

function TVanDaouDaemon.SocketSendReceiveData(AClientSocket: TClientSocket; ASendData: string; out ARecvData: string): Boolean;
const
  RECV_TIME_OUT = 60; // 60��
var
  GetTime: Cardinal;
begin
  Result := False;
  try
    GetTime := GetTickCount;
    // Connect ��� (3��)
    while GetTime + (3 * 1000) > GetTickCount do
    begin
      Application.ProcessMessages;
      if AClientSocket.Socket.Connected then
        Break;
    end;
    if not AClientSocket.Socket.Connected then
    begin
      ARecvData := '���� ���� ����!!!';
      Exit;
    end;

    if Trim(ASendData) <> '' then
      AClientSocket.Socket.SendText(ASendData);
    GetTime := GetTickCount;
    // Ÿ�Ӿƿ� �ð� ���� ������
    while GetTime + (RECV_TIME_OUT * 1000) > GetTickCount do
    begin
      Application.ProcessMessages;
      if FReceiveBuff <> '' then
      begin
        ARecvData := FReceiveBuff;
        Result := True;
        FReceiveBuff := '';
        Exit;
      end;
    end;
  except on E: Exception do
    begin
      Log.Write(ltError, ['SocketSendReceiveData', E.Message]);
      ARecvData := E.Message;
    end;
  end;
end;
{$IFEND}

function TVanDaouDaemon.GetErrorMsg(ACode: AnsiString): AnsiString;
begin
  if Copy(ACode, 1, 1) = '0' then
  begin
    case StrToIntDef(ACode, 0) of
       1: Result := 'POS ��û ���� ���� (POS REQ Msg type error)';
       2: Result := 'VAN ���� ���� ���� (VAN REP Msg type error)';
       3: Result := '��й�ȣ �Է� ��� (��й�ȣ�� �ʿ��� �ŷ���)';
       4: Result := '���ڼ��� �Է� ���';
       9: Result := '��� ���� (EOT recv error (�̿Ϸ�ŷ� ó��))';
      10: Result := 'EOT �̼��� ���� (EOT �̼����� R_tran ó�� �Ϸ�)';
      11: Result := 'EOT �̼��� ���� (EOT �̼����� R_tran ó�� ����)';
      12: Result := 'EOT �̼��� ���� (EOT �̼����� R_tran ���ʿ� �ŷ�)';
      15: Result := '��� ���� (ENQ recv error)';
      16: Result := '��� ���� (ACK recv error)';
      17: Result := '������ ���� ���� (DATA recv error)';
      20: Result := '�ŷ� ���� (�ŷ� ���� ���� �߻�)';
      21: Result := '������ �۽� ���� (send error)';
      22: Result := '��� ���� (Socket select error)';
      23: Result := 'VAN Timeout (Socket select Timeout)';
      24: Result := '��� ���� (Socket Recv error(Sock Close))';
      25: Result := '��� ���� (Socket Recv timeout error)';
      26: Result := '���� ���� ���� (socket error ! (Connect_socket))';
      27: Result := '���� ���� ���� (connect error ! (Connect_socket))';
      28: Result := '���� ���� ���� (Create Socket Class error !)';
      31: Result := '���� ��ȣȭ ���� (RSA_padding error)';
      32: Result := '���� ��ȣȭ ���� (RSA error)';
      33: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (StatPosCfg.ini ���� �������� ����)';
      34: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SvkPosCfg.ini ���ϻ�������)';
      35: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SvkPosCfg.ini ��ȣȭŰ ����)';
      36: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SvkPosCfg.ini ���� ���� ����)';
      37: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SvkPosCfg.ini ���� ������ ����)';
      39: Result := '��Ÿ ����';
      41: Result := 'ComPort Open error (������ ǥ�õ� ComPort�� ���� ����)';
      42: Result := 'Serial ���� ���� (Serial �� ���� ����)';
      43: Result := 'Serial Send ���� (Serial �� ���� ���� ����)';
      44: Result := 'Serial recv ���� (Serial �� ���� ���� ����)';
      45: Result := 'Serial recv data ���� (Serial �� ���� ���� DATA ����)';
      46: Result := 'Serial Recv Timeout (Serial ���� �ð� �ʰ�)';
      47: Result := 'SignPad NAK ���� (Serial Ȯ�� ���)';
      48: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SignPad�� Sign Key�� ���� ��ȣȭŰ ���� �ʿ�)';
      49: Result := 'SignPad Ȯ�� ��� (���ڼ��� ���� ����)';
      51: Result := 'SignPad Ȯ�� ��� (PIN-PAD ����� ���� SignPad�� PIN �ŷ� �Ұ� (V.2.0P �̻� ���� PIN �ŷ� ����))';
      52: Result := '�ܸ��� ���ðŷ��� �ŷ� ��� (SignPad�� PIN-PAD Key�� ���� ��ȣȭŰ ���� �ʿ�)';
      53: Result := 'SignPAD ��й�ȣ �Է� ���';
      54: Result := 'SignPad Ȯ�� ��� (������ �Է� ����� ���� SignPad�� ������ �Է� �Ұ� (V.2.0P �̻� ���� ������ �Է� ����))';
      55: Result := 'Serial Ȯ�� ��� (�ø��� ���� ����)';
      56: Result := 'Serial Ȯ�� ��� (Did not create a serial-class)';
      64: Result := 'ī�帮���� ��Ʈ Ȯ�� ��� (ini������ ������ ��Ʈ��ȣ Ȯ��)';
      65: Result := 'ī�帮���� ��ȣ ���� (�ܸ��� ���ðŷ��� �ŷ� ���)';
      70: Result := 'ICī��ŷ����� (ICī���ε� MS�켱�ŷ��Ѱ��)';
      98: Result := 'Serial Ȯ�� ��� (�ø��� �����)';
    else
      Result := ACode;
    end;
  end
  else
  begin
    if ACode = 'K001' then Result := '������ ����'
    else if ACode = 'K002' then Result := 'IC ī�� �ŷ� �Ұ�'
    else if ACode = 'K003' then Result := 'M/S ī�� �ŷ� �Ұ�'
    else if ACode = 'K004' then Result := 'Fall-Back �ŷ�'
    else if ACode = 'K005' then Result := 'ICī�� ���ԵǾ� ����'
    else if ACode = 'K006' then Result := '2nd Generate AC ����'
    else if ACode = 'K007' then Result := '2nd Generate �������� ī������'
    else if ACode = 'K008' then Result := 'ICī�� ���� �������� ī������'
    else if ACode = 'K011' then Result := '������ KEY �ٿ�ε� ���'
    else if ACode = 'K012' then Result := '������ Tamper ����'
    else if ACode = 'K013' then Result := '��ȣ���� ����'
    else if ACode = 'K014' then Result := '��/��ȣȭ ����'
    else if ACode = 'K015' then Result := '���Ἲ �˻� ����'
    else if ACode = 'K101' then Result := 'Ŀ�ǵ� ���� ����'
    else if ACode = 'K102' then Result := 'ŰƮ�δн� ��� Time Out'
    else if ACode = 'K901' then Result := 'ī��� �Ķ���� ������ ����'
    else if ACode = 'K902' then Result := 'ī��� �Ķ���� �ݿ� �Ұ�'
    else if ACode = 'K990' then Result := '����� ���'
    else if ACode = 'K997' then Result := '������ ������ �̻�'
    else if ACode = 'K998' then Result := 'ī���Է´��ð� �ʰ�'
    else if ACode = 'K999' then Result := '���� ����'
    else if ACode = 'K081' then Result := 'ī���Է¿�û'
    else if ACode = 'K082' then Result := 'ó�� �Ұ� ����'
    else if ACode = 'S000' then Result := '�ܺ� ���� ������ �Է�'
    else if ACode = 'S100' then Result := '�ܺ� ���� ������ �Է� ����'
    else if ACode = 'S001' then Result := '�ܺ� ���� ������ �Է� ����'
    else if ACode = 'S111' then Result := '�ܺ� ���� ������ �Է�'
    else if ACode = 'S002' then Result := '���� ������ �Է� ���'
    else if ACode = 'S052' then Result := '�ſ� ī�� �ŷ� ���'
    else if ACode = 'S053' then Result := '���� ������ �ŷ� ���'
    else if ACode = 'S054' then Result := '���� IC �ŷ� ���'
    else if ACode = 'C001' then Result := 'DaouVP ���� üũ ���� ��'
    else Result := ACode;
  end;
end;

function TVanDaouDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanDaouDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ȭ�� ���� ����� ����ϴ� ���
  if AInfo.SignOption = 'T' then
  begin
    SendData := 'K100' +                               // ������ȣ
                Format('%-8.8s', [AInfo.TerminalID]) + // �ܸ����ȣ
                CurrToStrRPad(AInfo.SaleAmt, 12) +     // �ŷ��ݾ�
                '1';                                   // �Է¿�û����
    if ExecTcpSendData(SendData, RecvData) then
    begin
      // ���� �����̸� ī�� �������� ���� ���
      if RecvData = 'K004' then
      begin
        if not ExecTcpSendData('', RecvData) then
        begin
          Result.Result := False;
          Result.Msg := RecvData;
          Exit;
        end;
      end;
    end
    else
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000') or (Result.Code = 'K110') or (Result.Code = 'S000');
    if not Result.Result then
    begin
      Result.Msg := GetErrorMsg(Result.Code);
      Exit;
    end;
  end;

  // ������ �����.
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);

  SendData := IfThen(AInfo.Approval, '0100', '0400') +                             // ������ȣ
              IfThen(AInfo.EyCard, '17', '10') +                                   // �����ڵ�
              Format('%-8.8s', [AInfo.TerminalID]) +                               // �ܸ����ȣ
              '0000' +                                                             // ��ǥ��ȣ
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // �ܸ�������
              FormatFloat('00', AInfo.HalbuMonth) +                                // �Һΰ���
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // �ŷ��ݾ�
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // �����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // ����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // �����
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // ����������
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // �����ι�ȣ
              Space(42) +                                                          // ����������Ÿ
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // �λ���� TID
  // ���� ����
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // �����ڵ�
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // ����޼���
      Result.Msg := Trim(Copy(RecvData, 171, 67)) + Trim(Copy(RecvData, 270, 1024));
      // ���ι�ȣ
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // �����Ͻ� (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // �ŷ���ȣ
      Result.TransNo := Copy(RecvData, 57, 12);
      // �߱޻��ڵ�
      Result.BalgupsaCode := '';
      // �߱޻��
      Result.BalgupsaName := Trim(Copy(RecvData, 81, 19));
      // ���Ի��ڵ�
      Result.CompCode := Trim(Copy(RecvData, 101, 3));
      // ���Ի��
      Result.CompName := Trim(Copy(RecvData, 104, 16));
      // ��������ȣ
      Result.KamaengNo := Trim(Copy(RecvData, 120, 15));
      // ���αݾ�
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 159, 12)), 0);
      // ���αݾ�
      Result.DCAmt := 0;
      // ����ŷ�� ī���ȣ
      Result.CardNo := Trim(Copy(RecvData, 136, 23));
      // ���� ���� ����
      Result.IsSignOK := True;
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData, Gubun: AnsiString;
begin
  // ���ŷ�����
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);
  // �ŷ�����
  if AInfo.Person = 3 then
    Gubun := IfThen(AInfo.Approval, '3 ', 'E ')
  else if AInfo.Person = 2 then
    Gubun := IfThen(AInfo.Approval, '2 ', 'B ')
  else
    Gubun := IfThen(AInfo.Approval, '1 ', 'A ');

  // ������ �����.
  SendData := IfThen(AInfo.Approval, '0200', '0420') +                             // ������ȣ
              '40' +                                                               // �����ڵ�
              Format('%-8.8s', [AInfo.TerminalID]) +                               // �ܸ����ȣ
              '0000' +                                                             // ��ǥ��ȣ
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // �ܸ�������
              Gubun +                                                              // �ŷ�����
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // �ŷ��ݾ�
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // �����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // ����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // �����
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // ����������
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // �����ι�ȣ
              Format('%-1.1s', [IntToStr(AInfo.CancelReason)]) +                   // ��һ����ڵ�
              IfThen(AInfo.KeyInput, '1', '0') +                                   // KeyIn�ڵ� (0:ī��, 1:�����е�, 2:�����Է�)
              Format('%-30.30s', [AInfo.CardNo]) +                                 // ���������
              Space(42) +                                                          // ����������Ÿ
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // �λ���� TID
  // ���� ����
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // �����ڵ�
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // ����޼���
      Result.Msg := Trim(Copy(RecvData, 188, 67)) + Trim(Copy(RecvData, 287, 1024));
      // ���ι�ȣ
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // �����Ͻ� (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // �ŷ���ȣ
      Result.TransNo := Copy(RecvData, 57, 12);
      // ���αݾ�
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 104, 12)), 0);
      // ���αݾ�
      Result.DCAmt := 0;
      // ����ŷ�� ī���ȣ
      Result.CardNo := Trim(Copy(RecvData, 81, 23));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // ������ �����.
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);

  SendData := IfThen(AInfo.Approval, '0100', '0400') +                             // ������ȣ
              '50' +                                                               // �����ڵ�
              Format('%-8.8s', [AInfo.TerminalID]) +                               // �ܸ����ȣ
              '0000' +                                                             // ��ǥ��ȣ
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // �ܸ�������
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // �ŷ��ݾ�
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // �����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // ����
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // �����
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // ����������
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // �����ι�ȣ
              IfThen(AInfo.Approval, '1', '2') +                                   // ��ȸ����
              ' ' +                                                                // ��ұ���
              Space(42) +                                                          // ����������Ÿ
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // �λ���� TID
  // ���� ����
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // �����ڵ�
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // ����޼���
      Result.Msg := Trim(Copy(RecvData, 182, 67)) + Trim(Copy(RecvData, 281, 1024));
      // ���ι�ȣ
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // �����Ͻ� (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // �ŷ���ȣ
      Result.TransNo := Copy(RecvData, 57, 12);
      // �߱޻��ڵ�
      Result.BalgupsaCode := '';
      // �߱޻��
      Result.BalgupsaName := Trim(Copy(RecvData, 81, 19));
      // ���Ի��ڵ�
      Result.CompCode := Trim(Copy(RecvData, 101, 3));
      // ���Ի��
      Result.CompName := Trim(Copy(RecvData, 104, 16));
      // ��������ȣ
      Result.KamaengNo := Trim(Copy(RecvData, 120, 15));
      // ���αݾ�
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 158, 12)), 0);
      // ���αݾ�
      Result.DCAmt := 0;
      // ����ŷ�� ī���ȣ
      Result.CardNo := Trim(Copy(RecvData, 135, 23));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.RegDate) = 6 then
    AInfo.RegDate := '20' + AInfo.RegDate;

  // ������ �����.
  SendData := '0200' +                                            // ������ȣ
              '15' +                                              // �����ڵ�
              Format('%-8.8s', [AInfo.TerminalID]) +              // �ܸ����ȣ
              '0000' +                                            // ��ǥ��ȣ
              TERMINAL_GUBUN1 +                                   // �ܸ�������
              'K' +                                               // WCC (K:Ű��)
              Format('%-8.8s', [LeftStr(AInfo.CheckNo, 8)]) +     // ��ǥ��ȣ
              Format('%-2.2s', [LeftStr(AInfo.BankCode, 2)]) +    // �����ڵ�
              Format('%-4.4s', [LeftStr(AInfo.BranchCode, 4)]) +  // �������ڵ�
              Format('%-2.2s', [LeftStr(AInfo.KindCode, 2)]) +    // �����ڵ�
              CurrToStrRPad(AInfo.SaleAmt, 12) +                  // ��ǥ�ݾ�
              Format('%-8.8s', [LeftStr(AInfo.RegDate, 8)]) +     // ��������
              Format('%-12.12s', [LeftStr(AInfo.AccountNo, 12)]); // �����Ϸù�ȣ
  // ���� ����
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // �����ڵ�
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // ����޼���
      Result.Msg := Trim(Copy(RecvData, 116, 67));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

{ TVanKovanDaemon }

constructor TVanKovanDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary('C:\KOVAN\' + KOVAN_DAEMON_DLL);
end;

destructor TVanKovanDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKovanDaemon.DLLExec(ATCode, ATID, AHalbu, ATAmt, AOriDate, AOriAuthNo, ATranSerial, AIdNo, AAmtFlag, ATaxAmt, ASfeeAmt, AFreeAmt, AFiller: AnsiString;
                                 out ARecvTranType, ARecvErrCode, ARecvCardno, ARecvHalbu, ARecvTamt, ARecvTranDate, ARecvTranTime, ARecvAuthNo, ARecvMerNo, ARecvTranSerial,
                                 ARecvIssueCard, ARecvPurchaseCard, ARecvSignPath, ARecvMsg1, ARecvMsg2, ARecvMsg3, ARecvMsg4, ARecvFiller: AnsiString): Boolean;
type
  TKovan_Auth = function(tcode, tid, halbu, tamt, ori_date, ori_authno, tran_serial, idno, amt_flag, tax_amt, sfee_amt, free_amt, filler,
                         rTranType, rErrCode, rCardno, rHalbu, rTamt, rTranDate, rTranTime, rAuthNo, rMerNo, rTranSerial,
                         rIssueCard, rPurchaseCard, rSignPath, rMsg1, rMsg2, rMsg3, rMsg4, rFiller: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TKovan_Auth;
begin
  Result := False;

  @Exec := GetProcAddress(FDLLHandle, 'Kovan_Auth');
  if not Assigned(@Exec) then
  begin
    ARecvMsg1 := KOVAN_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  SetLenAndFill(ARecvTranType, 4);
  SetLenAndFill(ARecvErrCode, 4);
  SetLenAndFill(ARecvCardno, 18);
  SetLenAndFill(ARecvHalbu, 2);
  SetLenAndFill(ARecvTamt, 9);
  SetLenAndFill(ARecvTranDate, 6);
  SetLenAndFill(ARecvTranTime, 6);
  SetLenAndFill(ARecvAuthNo, 12);
  SetLenAndFill(ARecvMerNo, 15);
  SetLenAndFill(ARecvTranSerial, 12);
  SetLenAndFill(ARecvIssueCard, 30);
  SetLenAndFill(ARecvPurchaseCard, 30);
  SetLenAndFill(ARecvSignPath, 50);
  SetLenAndFill(ARecvMsg1, 100);
  SetLenAndFill(ARecvMsg2, 100);
  SetLenAndFill(ARecvMsg3, 100);
  SetLenAndFill(ARecvMsg4, 100);
  SetLenAndFill(ARecvFiller, 102);

  Ret := Exec(PAnsiChar(ATCode), PAnsiChar(ATID), PAnsiChar(AHalbu), PAnsiChar(ATAmt), PAnsiChar(AOriDate), PAnsiChar(AOriAuthNo), PAnsiChar(ATranSerial),
              PAnsiChar(AIdNo), PAnsiChar(AAmtFlag), PAnsiChar(ATaxAmt), PAnsiChar(ASfeeAmt), PAnsiChar(AFreeAmt), PAnsiChar(AFiller),
              @ARecvTranType[1], @ARecvErrCode[1], @ARecvCardno[1], @ARecvHalbu[1], @ARecvTamt[1], @ARecvTranDate[1], @ARecvTranTime[1], @ARecvAuthNo[1],
              @ARecvMerNo[1], @ARecvTranSerial[1], @ARecvIssueCard[1], @ARecvPurchaseCard[1], @ARecvSignPath[1], @ARecvMsg1[1], @ARecvMsg2[1],
              @ARecvMsg3[1], @ARecvMsg4[1], @ARecvFiller[1]);
  Result := Ret = 0;
  if not Result then
  begin
    case Ret of
       -2: ARecvMsg1 := '���α׷� ��� ���� ����';
       -3: ARecvMsg1 := '���α׷� ��� ���� ����';
       -4: ARecvMsg1 := '���α׷� ���� �غ� ����';
       -5: ARecvMsg1 := '���α׷� ��� ���� ����';
       -6: ARecvMsg1 := '�ŷ����п���';
       -7: ARecvMsg1 := '�Һΰ�������';
       -8: ARecvMsg1 := '��ҽ� ���ŷ��Ͽ���';
       -9: ARecvMsg1 := '��ҽ� �����ι�ȣ ����';
      -10: ARecvMsg1 := '�ŷ��Ϸù�ȣ ����';
      -11: ARecvMsg1 := '��ǥ��ȸ���� ����';
    else
      ARecvMsg1 := '��Ÿ ����';
    end;
  end;
  Log.Write(ltDebug, ['DaemonDLLȣ��', Result, '���ϰ�', Ret, '���ϸ޼���', ARecvMsg1]);
end;

function TVanKovanDaemon.DoCallExec(ATCode, AHalbu: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  IdNo: AnsiString;
  RecvTranType, RecvHalbu, RecvTamt, RecvTranDate, RecvTranTime, RecvSignPath,
  RecvMsg1, RecvMsg2, RecvMsg3, RecvMsg4, RecvFiller: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // ��ǥ��ȸ��
  if ATCode = '40' then
    IdNo := Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
            Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]) + '00' + Space(11)
  else
    IdNo := '';

  if DLLExec(ATCode,                                       // �ŷ� ����
             Format('%-10.10s', [AInfo.TerminalID]),       // �ܸ����ȣ
             AHalbu,                                       // �ҺαⰣ
             FormatFloat('000000000', AInfo.SaleAmt),      // ���αݾ�
             IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])),  // ���ŷ�����
             IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])),             // ���ŷ����ι�ȣ
             FormatFloat('000000', GetSeqNo) + Space(6),   // �ŷ��Ϸù�ȣ
             Format('%-33.33s', [IdNo]),                   // �ĺ���ȣ
             Space(3),                                     // �̻��
             FormatFloat('000000000', AInfo.VatAmt),       // ����(�ΰ���)
             FormatFloat('000000000', AInfo.SvcAmt),       // �����
             FormatFloat('000000000', AInfo.FreeAmt),      // �����
             Space(21) + IfThen(AInfo.SignOption = 'R', 'ZZ', '  ') + Format('%-10.10s', [AInfo.BizNo]) + Space(67), // filler(��������, ���߻���ڹ�ȣ)
             RecvTranType,                                 // ��������
             Result.Code,                                  // �����ڵ�
             Result.CardNo,                                // ī���ȣ
             RecvHalbu,                                    // �Һΰ���
             RecvTamt,                                     // ���αݾ�
             RecvTranDate,                                 // ��������
             RecvTranTime,                                 // ���νð�
             Result.AgreeNo,                               // ���ι�ȣ
             Result.KamaengNo,                             // ��������ȣ
             Result.TransNo,                               // �ŷ��Ϸù�ȣ
             Result.BalgupsaName,                          // �߱޻��
             Result.CompName,                              // ���Ի��
             RecvSignPath,                                 // ���ΰ��
             RecvMsg1,                                     // �޽���1
             RecvMsg2,                                     // �޽���2
             RecvMsg3,                                     // �޽���3
             RecvMsg4,                                     // �޽���4
             RecvFiller) then                              // Filler
  begin
    // ���ϰ�
    Result.Result := Result.Code = '0000';
    // ����޼���
    Result.Msg := RecvMsg1 + RecvMsg2 + RecvMsg3 + RecvMsg4;
    // �����Ͻ� (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + RecvTranDate + RecvTranTime;
    // �߱޻��ڵ�
    Result.BalgupsaCode := Trim(Copy(RecvFiller, 1, 2));
    // ���Ի��ڵ�
    Result.CompCode := Trim(Copy(RecvFiller, 3, 2));
    // ���αݾ�
    Result.AgreeAmt := StrToIntDef(RecvTamt, 0);
    // ���αݾ�
    Result.DCAmt := 0;
    // ���� ���� ����
    Result.IsSignOK := RecvSignPath <> '';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvMsg1;
  end;
end;

function TVanKovanDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKovanDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TCode: AnsiString;
begin
  if AInfo.EyCard then
    TCode := IfThen(AInfo.Approval, 'E0', 'E1')
  else
    TCode := IfThen(AInfo.Approval, 'S0', 'S1');

  Result := DoCallExec(TCode, FormatFloat('00', AInfo.HalbuMonth), AInfo);
end;

function TVanKovanDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Halbu: AnsiString;
begin
  if AInfo.Approval then
    Halbu := IfThen(AInfo.Person = 1, '00', '01')
  else
    Halbu := FormatFloat('0', AInfo.CancelReason) + IfThen(AInfo.Person = 1, '00', '01');

  Result := DoCallExec(IfThen(AInfo.Approval, '41', '42'), Halbu, AInfo);
end;

function TVanKovanDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '�ش� ��� �������� ����.';
end;

function TVanKovanDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result := DoCallExec('40', AInfo.KindCode, AInfo);
end;

function TVanKovanDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� �������� ����.';
end;

{ TVanSpcDaemon }

constructor TVanSpcDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(SPC_DAEMON_DLL);
end;

destructor TVanSpcDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanSpcDaemon.DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TSpcnVirtualPosS = function(AServerIP: PAnsiChar; AServerPort: Integer; AInputData: PAnsiChar; AOutputData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TSpcnVirtualPosS;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'SpcnVirtualPosS');
  if not Assigned(@Exec) then
  begin
    ARecvData := SPC_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Ret := Exec('127.0.0.1', 19011, PAnsiChar(ASendData), @ARecvData[1]);
  Result := Ret > 0;
  if not Result then
    ARecvData := GetErrorMsg(Ret);
  Log.Write(ltDebug, ['DaemonDLLȣ��', Result, '���ϰ�', Ret, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanSpcDaemon.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    -11 : Result := '��û���� ���� (STX)';
    -12 : Result := '��û���� ���� (ETX)';
    -13 : Result := '��û���� ���� (������ ����)';
    -14 : Result := '���� ��û�������� ����';
    -15 : Result := 'IC������ ��û�������� ����';
    -16 : Result := '�ŷ��ݾ� ����';
    -17 : Result := '����� ���� ���� ���� (IC������)';
    -18 : Result := 'Ű������ ���� ����';
    -19 : Result := 'ī�� ���Ի��� ���� (IC������)';
    -20 : Result := 'ī�� ���� ���� ���� (IC������)';
    -21 : Result := 'ī�� ���� ���� ���� (IC������)';
    -22 : Result := '���ڼ��� ���� ���� (�����е�)';
    -23 : Result := '��й�ȣ ���� ���� (�����е�)';
    -24 : Result := '���� ��û�������� ����';
    -25 : Result := '���� ��û�������� ����';
    -26 : Result := '���� ��û�������� ����';
    -27 : Result := 'ī���ȣ ��ȣȭ ����';
    -28 : Result := 'ī���ȣ ��ȣȭ ����';
    -29 : Result := 'Pos Entry Mode ����';
    -30 : Result := '�ŷ���ü ���� ����';
    -31 : Result := '�ŷ������ڵ� ����';
    -32 : Result := 'Ű������ ���� ����';
    -33 : Result := 'Ű������ �Է� ����';
    -35 : Result := 'VAN ���� ��� ����';
    -36 : Result := '�߱޻� ���� ���� - ����� ó����';
    -37 : Result := '�߱޻� ���� ���� - ����� ó����';
    -39 : Result := '��ȣȭ ������ ��ȣȭ ����';
    -40 : Result := '���ðŷ� ���';
    -41 : Result := '������ �ĺ���ȣ ���� (IC������)';
    -42 : Result := '������ �ĺ���ȣ ���� (RF�ĺ�ī��)';
    -44 : Result := '���ڵ帮���� ������ ���� ����';
    -50 : Result := '���ڵ帮���� ���� ����';
    -51 : Result := '�ſ��û ������ �ڵ� ���� ����';
    -52 : Result := 'ī�� ���� ���� ���� (RF�ĺ�ī��)';
    -53 : Result := '����� ���� ���� ���� (RF�ĺ�ī��)';
    -54 : Result := 'RF�ĺ�ī�� ��뿩�� ���� (ȯ�漳�� ����)';
    -55 : Result := 'RF�ĺ�ī�� ��뿩�� ���� (���Ἲ ����)';
    -56 : Result := 'RF������ ��û�������� ����';
    -57 : Result := 'RF������ ���� ����';
    -61 : Result := '����� ���� ����';
    -62 : Result := '����� ��� �ƴ� (��û���� ����)';
    -63 : Result := '����� ��� �ƴ� (������ΰ� �ƴ�)';
    -64 : Result := '����� �������� ���� ����';
    -65 : Result := '����� ������� (ī��� Ȯ�� ���)';
    -66 : Result := '����� ��û ���� ����';
    -67 : Result := '����� ����';
    -1001 : Result := 'Socket Connect Error (connect)';
    -1002 : Result := 'Socket Connect Error (ioctlsocket)';
    -1003 : Result := 'Socket Connect Error (select)';
    -1004 : Result := 'Socket Connect Error (select)';
    -1005 : Result := 'Socket Recv Error (select)';
    -1006 : Result := 'Socket Recv Error (select)';
    -1007 : Result := 'Socket Recv Error (recv)';
    -1008 : Result := 'Socket Recv Error (recv len)';
    -1009 : Result := 'Socket Recv Error (send)';
    -1010 : Result := '����ܸ��� ���� ����';
    -1011 : Result := '����ܸ��� ���� �޽��� �̼���(ENQ �̼���)';
    -1012 : Result := '����ܸ��� ���� �޽��� ����(ENQ �̼���)';
    -1013 : Result := '����ܸ��� ��û���� �۽� ����';
    -1014 : Result := '����ܸ��� �������� ���� ���� ����';
    -1015 : Result := '����ܸ��� �������� ���� ������ ����';
    -1016 : Result := '����ܸ��� �������� ���� ������ ��ȯ ����';
    -1017 : Result := '����ܸ��� �������� ������ ���� ����';
    -1018 : Result := '����ܸ��� ���� �޽��� ����';
    -1019 : Result := '����ܸ��� EOT �۽� ����';
    -1020 : Result := '����ܸ��� ACK ���� ����';
    -1021 : Result := '����ܸ��� ACK ������ ����';
    -1030 : Result := '����ܸ��� ��û���� ���� ����';
    -1031 : Result := '����ܸ��� ��Ʈ���� ��� ����';
    -1032 : Result := '����ܸ��� ��Ʈ���� ���� ����';
    -1040 : Result := '����ܸ��� ���ڼ��� ������ ���� ����';
    -1042 : Result := '(*) IC������ �ʱ�ȭ ����';
    -1043 : Result := '(*) IC������ Ű�ٿ�ε� ����';
    -1044 : Result := '(*) IC������ ������ ����';
    -1045 : Result := '(*) IC������ �ð����� ����';
    -1046 : Result := '(*) IC������ �����б� ����';
    -1047 : Result := '(*) IC������ ���Ἲ ����';
    -1048 : Result := '(*) IC������ ī��BIN���� ���� ����';
    -1052 : Result := '(*) RF������ �ʱ�ȭ ����';
    -1053 : Result := '(*) RF������ Ű�ٿ�ε� ����';
    -1054 : Result := '(*) RF������ ������ ����';
    -1055 : Result := '(*) RF������ �ð����� ����';
    -1056 : Result := '(*) RF������ �����б� ����';
    -1057 : Result := '(*) RF������ ���Ἲ ����';
    -1058 : Result := '(*) RF������ SAM��� ����';
  else
    Result := '��Ÿ ����';
  end;
end;

function TVanSpcDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 1. ������ �ٿ�ε�(���ðŷ�)�� �Ѵ�.
  SendData := 'DN' +
              Format('%-10.10s', [ATerminalID]) + // �ܸ����ȣ
              Format('%-10.10s', [ABizNo]);       // ����ڹ�ȣ
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;

  // 2. ��ȣ������ �Ѵ�.
  SendData := 'I1' +
              Format('%-10.10s', [ATerminalID]) + // �ܸ����ȣ
              Space(64);
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
  Sign: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // ���� �ɼ�
  if AInfo.SignOption = 'N' then
    Sign := 'C'
  else if AInfo.SignOption = 'R' then
    Sign := 'M'
  else
    Sign := ' ';
  // ������ �����.
  SendData := IfThen(AInfo.Approval, 'S0', 'S1') +          // ����/��� ����
              Format('%-10.10s', [AInfo.TerminalID]) +      // �ܸ����ȣ
              FormatFloat('00', AInfo.HalbuMonth) +         // �ҺαⰣ
              FormatFloat('000000000', AInfo.SaleAmt) +     // ���αݾ�
              FormatFloat('000000000', AInfo.SvcAmt) +      // �����
              FormatFloat('000000000', AInfo.VatAmt) +      // ����(�ΰ���)
              IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // ���ŷ����ι�ȣ
              IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // ���ŷ���������
              IfThen(Trim(AInfo.Reserved1) = '', Space(6), 'MUL#  ') + // ���� ����� ����
              Sign +                                        // ���� �ɼ� (M: ���� ���� ���, C: ���� �̻��, ' ': �⺻����)
              IfThen(AInfo.EyCard, 'Y', ' ') +              // Ư��ī�� ����
              Space(12) +                                   // �߰�����
              Space(8) +                                    // ��ü����
              Space(6) +                                    // ������ȣ
              Space(6) +                                    // ��ǰ�ڵ�
              Space(1) +                                    // ���ڻ�ŷ� ���ȵ��
              Space(13) +                                   // ���������
              Space(40);                                    // ������
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // ����޼���
    Result.Msg := Trim(Copy(RecvData, 114, 128));
    // ���ι�ȣ
    Result.AgreeNo := Trim(Copy(RecvData, 49, 12));
    // �����Ͻ� (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + Copy(RecvData, 39, 10);
    // �ŷ���ȣ
    Result.TransNo := '';
    // �߱޻��ڵ�
    Result.BalgupsaCode := Trim(Copy(RecvData, 77, 2));
    // �߱޻��
    Result.BalgupsaName := Trim(Copy(RecvData, 61, 16));
    // ���Ի��ڵ�
    Result.CompCode := Trim(Copy(RecvData, 95, 2));
    // ���Ի��
    Result.CompName := Trim(Copy(RecvData, 79, 16));
    // ��������ȣ
    Result.KamaengNo := Trim(Copy(RecvData, 97, 15));
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // ���αݾ�
    Result.DCAmt := 0;
    // ����ŷ�� ī���ȣ
    Result.CardNo := Trim(Copy(RecvData, 19, 20));
    // ���� ���� ����
    Result.IsSignOK := True;
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
  Gubun: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Person = 3 then
    Gubun := '02'
  else if AInfo.Person = 2 then
    Gubun := '01'
  else
    Gubun := '00';
  // ������ �����.
  SendData := IfThen(AInfo.Approval, 'C0', 'C1') +          // ����/��� ����
              Format('%-10.10s', [AInfo.TerminalID]) +      // �ܸ����ȣ
              Gubun +                                       // ���ݰŷ�����(�ҵ����,��������,�����߱�)
              FormatFloat('000000000', AInfo.SaleAmt) +     // ���αݾ�
              FormatFloat('000000000', AInfo.SvcAmt) +      // �����
              FormatFloat('000000000', AInfo.VatAmt) +      // ����(�ΰ���)
              IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // ���ŷ����ι�ȣ
              IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // ���ŷ���������
              FormatFloat('0', AInfo.CancelReason) +        // ��һ����ڵ�
              IfThen(Trim(AInfo.Reserved1) = '', Space(67), 'MUL#' + Space(63)) + // ���� ����� ����
              'A' +                                         // KeyIn ���� (A:��� �ŷ� �������� ���� �ܸ��Ⱑ ó����, Y:Ű�ΰŷ�, I:POS�Է�, �׿�:MS�켱�ŷ�)
              Space(12) +                                   // �߰�����
              Space(8) +                                    // ��ü����
              Space(6) +                                    // ������ȣ
              Space(6) +                                    // ��ǰ�ڵ�
              Space(2) +                                    // ���������ID
              Space(30) +                                   // ����������ʵ�
              Space(18);                                    // KeyIn����
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // ����޼���
    Result.Msg := Trim(Copy(RecvData, 61, 128));
    // ���ι�ȣ
    Result.AgreeNo := Trim(Copy(RecvData, 49, 12));
    // �����Ͻ� (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + Copy(RecvData, 39, 10);
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // ����ŷ�� ī���ȣ
    Result.CardNo := Trim(Copy(RecvData, 19, 20));
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // ������ �����.
  SendData := IfThen(AInfo.Approval, 'H0', 'H1') +          // ����/��� ����
              Format('%-10.10s', [AInfo.TerminalID]) +      // �ܸ����ȣ
              FormatFloat('000000000', AInfo.SaleAmt) +     // ���αݾ�
              FormatFloat('000000000', AInfo.SvcAmt) +      // �����
              FormatFloat('000000000', AInfo.VatAmt) +      // ����(�ΰ���)
              IfThen(AInfo.Approval, Space(13), Format('%-13.13s', [AInfo.OrgAgreeNo])) + // ���ŷ����ι�ȣ
              IfThen(AInfo.Approval, Space(8), Format('%-8.8s', [AInfo.OrgAgreeDate])) + // ���ŷ���������
              'N';                                          // ����ȭ �ŷ�����(Y:����ȭ ��й�ȣX, N:�Ϲݰŷ�)
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 1));
    Result.Result := Result.Code = 'O';
    // ����޼���
    Result.Msg := Trim(Copy(RecvData, 120, 64));
    // ���ι�ȣ
    Result.AgreeNo := Trim(Copy(RecvData, 61, 13));
    // �����Ͻ� (yyyymmddhhnn)
    Result.AgreeDateTime := Copy(RecvData, 49, 12);
    // �ŷ���ȣ
    Result.TransNo := '';
    // �߱޻��ڵ�
    Result.BalgupsaCode := Trim(Copy(RecvData, 90, 7));
    // �߱޻��
    Result.BalgupsaName := Trim(Copy(RecvData, 74, 16));
    // ���Ի��ڵ�
    Result.CompCode := Trim(Copy(RecvData, 113, 7));
    // ���Ի��
    Result.CompName := Trim(Copy(RecvData, 97, 16));
    // ��������ȣ
    Result.KamaengNo := Trim(Copy(RecvData, 14, 15));
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // ���αݾ�
    Result.DCAmt := 0;
    // ����ŷ�� ī���ȣ
    Result.CardNo := Trim(Copy(RecvData, 29, 20));
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.RegDate) = 6 then AInfo.RegDate := '20' + AInfo.RegDate;
  // ������ �����.
  SendData := 'DK' +                                          // ��ǥ��ȸ
              Format('%-10.10s', [AInfo.TerminalID]) +        // �ܸ����ȣ
              Format('%-8.8s', [AInfo.CheckNo]) +             // ��ǥ��ȣ
              Format('%-2.2s', [AInfo.BankCode]) +            // ���������ڵ�
              Format('%-4.4s', [AInfo.BranchCode]) +          // ���࿵�����ڵ�
              Format('%-2.2s', [AInfo.KindCode]) +            // �����ڵ�
              FormatFloat('0000000000', AInfo.SaleAmt) +      // ��ǥ�ݾ�
              Format('%-6.6s', [Copy(AInfo.RegDate, 3, 6)]) + // ������
              Format('%-6.6s', [AInfo.AccountNo]);            // �����Ϸù�ȣ
  // DLL ȣ���Ѵ�.
  if DLLExec(SendData, RecvData) then
  begin
    // �����ڵ�
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // ����޼���
    Result.Msg := Trim(Copy(RecvData, 27, 64));
    // ���αݾ�
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '�ش� ��� ��� �Ұ�.';
end;

end.
