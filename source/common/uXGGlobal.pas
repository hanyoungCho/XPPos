unit uXGGlobal;

interface

uses
  { Native }
  System.Classes, System.SysUtils, WinApi.Windows, System.IniFiles, System.Win.Registry,
  Vcl.Controls, Vcl.ExtCtrls, Data.DB,
  { WinSoft }
  ComPort,
  { SolbiLib }
  cySpeedButton,
  { Common }
  uXGReceiptPrint, uNBioBSPHelper, uUCBioBSPHelper, uXGSaleTableContainer, uVanDaemonModule,
  uPaycoNewModule;

{$I XGPOS.inc}

const
  VFD_G_DLLName = 'GraphicVFDdll_vb.dll';
  VFD_C_DLLName = 'VFD_DLL.dll';

type
  TDatabaseType = (dtUnknown, dtOracle, dtMSSQL, dtMySQL);

  { �⺻ ������ Ÿ�̸� }
  {$M+}
  TBaseTimerThread = class(TThread)
  private
    FWorking: Boolean;
    FLastWorked: TDateTime;
    FLastWorkedWeather: TDateTime;
    FInterval: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval default 500;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
  end;

  { �÷����� ���� ���� }
  TPluginConfig = class
  private
    FStartModule: string;
    FSubMonitorModule: string;
    FWebViewModule: string;
  public
    constructor Create;
    destructor Destroy; override;

    property StartModule: string read FStartModule write FStartModule;
    property SubMonitorModule: string read FSubMonitorModule write FSubMonitorModule;
    property WebViewModule: string read FWebViewModule write FWebViewModule;
  end;

  { ��Ʈ�ʼ��� ���� }
  TPartnerCenterConfig = record
    Host: string;
  end;

  {  Ŭ���̾�Ʈ ���� ���� }
  TClientConfig = class
  private
    FClientId: string;
    FHost: string;
    FSecretKey: string;
    FUseLocalSetting: Boolean;
    FOAuthToken: string;
    FOAuthSuccess: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property ClientId: string read FClientId write FClientId;
    property Host: string read FHost write FHost;
    property SecretKey: string read FSecretKey write FSecretKey;
    property UseLocalSetting: Boolean read FUseLocalSetting write FUseLocalSetting default False;
    property OAuthToken: string read FOAuthToken write FOAuthToken;
    property OAuthSuccess: Boolean read FOAuthSuccess write FOAuthSuccess default False;
  end;

  { Ÿ����AD ���� ���� }
  TTeeBoxADInfo = record
    Enabled: Boolean;
    Host: string;
    Database: string;
    CharSet: string;
    DBPort: Integer;
    DBUser: string;
    DBPwd: string;
    DBTimeout: Integer;
    APITimeout: Integer;
    APIPort: Integer;
  end;

  { �����AD ���� ���� }
  TMobileADInfo = record
    Enabled: Boolean;
    Host: string;
    Port: Integer;
    SecretKey: string;
  end;

  { �������� ���� }
  TParkingServer = record
    Enabled: Boolean;
    Host: string;
    Database: string;
    CharSet: string;
    DBPort: Integer;
    DBUser: string;
    DBPwd: string;
    DBTimeout: Integer;
    BaseHours: Integer;
    Vendor: Integer;
  end;

  { �δ�ü� �̿�� ���� ���� }
  TAddonTicket = record
    ParkingTicket: Boolean;
    SaunaTicket: Boolean;
    SaunaTicketKind: Shortint;
    FitnessTicket: Boolean;
    PrintAlldayPass: Boolean;
    PrintWithAssignTicket: Boolean;
  end;

  { �������� ���� }
  TNoticeRec = record
    Title: string;
    RegUserName: string;
    RegDateTime: string;
    PageUrl: string;
    PopupYN: Boolean;
  end;

  { �⺻��ġ ���� ���� }
  TBaseDeviceConfig = class
  private
    FComDevice: TComPort;
    FPort: Integer;
    FBaudrate: Integer;
    FDeviceId: Integer;
    FOwnerId: Integer;
    FReadData: AnsiString;
    FEnabled: Boolean;

    procedure SetOwnerId(const AValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    property ComDevice: TComPort read FComDevice write FComDevice;
    property Port: Integer read FPort write FPort default 0;
    property Baudrate: Integer read FBaudrate write FBaudrate default 9600;
    property DeviceId: Integer read FDeviceID write FDeviceID;
    property OwnerId: Integer read FOwnerId write SetOwnerId default 0;
    property ReadData: AnsiString read FReadData write FReadData;
    property Enabled: Boolean read FEnabled write FEnabled default False;
  end;

  { ���� �νı� ���� }
  TFingerPrintScanner = class
  private
    FScanner: TObject;
    FEnabled: Boolean;
    FDeviceType: Integer;
    FAutoDetect: Boolean;
    FFingerPrint1: string;
    FFingerPrint2: string;
    FEnrollQuality: Integer;
    FIdentifyQuality: Integer;
    FVerifyQuality: Integer;
    FSecurityLevel: Integer;
    FDefaultTimeout: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property Scanner: TObject read FScanner write FScanner;
    property Enabled: Boolean read FEnabled write FEnabled default False;
    property DeviceType: Integer read FDeviceType write FDeviceType default CFT_NITGEN;
    property AutoDetect: Boolean read FAutoDetect write FAutoDetect default False;
    property FingerPrint1: string read FFingerPrint1 write FFingerPrint1;
    property FingerPrint2: string read FFingerPrint2 write FFingerPrint2;
    property EnrollQuality: Integer read FEnrollQuality write FEnrollQuality default GSD_FIR_ENROLL_QUALITY;
    property IdentifyQuality: Integer read FIdentifyQuality write FIdentifyQuality default GSD_FIR_IDENTIFY_QUALITY;
    property VerifyQuality: Integer read FVerifyQuality write FVerifyQuality default GSD_FIR_VERIFY_QUALITY;
    property SecurityLevel: Integer read FSecurityLevel write FSecurityLevel default GSD_FIR_SECURITY_LEVEL;
    property DefaultTimeout: Integer read FDefaultTimeout write FDefaultTimeout default GSD_FIR_DEFAULT_TIMEOUT;
  end;

  { ������ ������ ���� ���� }
  TPrinterConfig = class
  private
    FComDevice: TComPort;
    FPort: Integer;
    FBaudrate: Integer;
    FDeviceID: Integer;
    FCopies: Integer;
    FEnabled: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property ComDevice: TComPort read FComDevice write FComDevice;
    property Port: Integer read FPort write FPort default 0;
    property Baudrate: Integer read FBaudrate write FBaudrate default 9600;
    property DeviceId: Integer read FDeviceId write FDeviceId;
    property Copies: Integer read FCopies write FCopies;
    property Enabled: Boolean read FEnabled write FEnabled default False;
  end;

  { ��ġ ���� ���� ���� }
  TDeviceConfig = class
  private
    FFingerPrintScanner: TFingerPrintScanner;
    FReceiptPrinter: TPrinterConfig;
    FICCardReader: TBaseDeviceConfig;
    FSignPad: TBaseDeviceConfig;
    FRFIDReader: TBaseDeviceConfig;
    FWelfareCardReader: TBaseDeviceConfig;
    FBarcodeScanner: TBaseDeviceConfig;
    FVFD: TBaseDeviceConfig;
  public
    constructor Create;
    destructor Destroy; override;

    property FingerPrintScanner: TFingerPrintScanner read FFingerPrintScanner write FFingerPrintScanner;
    property ReceiptPrinter: TPrinterConfig read FReceiptPrinter write FReceiptPrinter;
    property ICCardReader: TBaseDeviceConfig read FICCardReader write FICCardReader;
    property SignPad: TBaseDeviceConfig read FSignPad write FSignPad;
    property RFIDReader: TBaseDeviceConfig read FRFIDReader write FRFIDReader;
    property WelfareCardReader: TBaseDeviceConfig read FWelfareCardReader write FWelfareCardReader;
    property BarcodeScanner: TBaseDeviceConfig read FBarcodeScanner write FBarcodeScanner;
    property VFD: TBaseDeviceConfig read FVFD write FVFD;
  end;

  { ȭ�� ���� }
  TScreenInfo = record
    BaseWidth: Integer;
    BaseHeight: Integer;
  end;

  { ��/��ǳ�� }
  TAirConditioner = record
    Active: Boolean;
    Enabled: Boolean;
    OnOffMode: Integer;
    BaseMinutes: Integer;
  end;

  { ����Ŭ�� }
  TWelbeingClub = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
    SelectEvent: Boolean; //���� ���� ���� ����
  end;

  { ��������Ŭ�� }
  TRefreshClub = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
  end;

  { ������������ }
  TRefreshGolf = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
  end;

  { �������� }
  TIKozen = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    StoreCode: string;
  end;

  { ������������ }
  TRoungeMembers = record
    Enabled: Boolean;
    Host: string;
    Password: string;
    StoreCode: string;
  end;

  { ����ƽ�� }
  TSmartix = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    clientCompSeq: string;
  end;

  { ���� Ÿ���� ���� }
  TTeeBoxFloorItem = record
    FloorCode: string;
    FloorName: string;
    TeeBoxCount: Integer;
  end;

  { ���̺�&�� ���� }
  TTableRec = record
    Container: TXGSaleTableContainer;
    DataSet: TDataSet;
    TableNo: Integer; //���̺�&�� ��ȣ
    TableName: string; //���̺� ��
    GroupNo: Integer; //��ü ��ȣ
    EnteredTime: TDateTime;
    ElapsedMinutes: Integer;
    GuestCount: Integer;
    OrderMemo: string;
    MapButton: TcySpeedButton;
    MapLeft: Integer; //�̴ϸ� ��ư X ��ġ
    MapTop: Integer; //�̴ϸ� ��ư Y ��ġ
    MapWidth: Integer; //�̴ϸ� ��ư ���� ��
    MapHeight: Integer; //�̴ϸ� ��ư ���� ��
  end;

  { ���̺�&�� ��� ���� }
  TTableInfo = record
    UnitName: string; //�������� ��Ī(�⺻��: '���̺�/��')
    Items: TArray<TTableRec>; //���̺�&�� ����
  private
    FActiveTableNo: Integer;
    FActiveTableIndex: Integer;
    FActiveGroupNo: Integer;
    FActiveGroupTableList: TStringList;

    procedure SetActiveTableNo(const ATableNo: Integer);
    function GetDelimitedGroupTableList: string;
  public
    function Count: Integer;
    procedure Reset;
    function GetTableIndex(const ATableNo: Integer): Integer;

    property ActiveTableNo: Integer read FActiveTableNo write SetActiveTableNo;
    property ActiveTableIndex: Integer read FActiveTableIndex;
    property ActiveGroupNo: Integer read FActiveGroupNo write FActiveGroupNo;
    property ActiveGroupTableList: TStringList read FActiveGroupTableList write FActiveGroupTableList;
    property DelimitedGroupTableList: string read GetDelimitedGroupTableList;
  end;

  { ��Ŀ �� ���� }
  TLockerFloorItem = record
    FloorCode: string;
    FloorName: string;
    LockerCount: Integer;
  end;

  { ��Ŀ ���� }
  TLockerItem = record
    LockerNo: Integer;
    LockerName: string;
    FloorIndex: Integer;
    ZoneCode: string;
    SexDiv: Integer;
    UseDiv: Integer;
    UseYN: Boolean;
  end;

  { ��� ���� ���� }
  TNoShowInfo = class
  private
    FNoShowReserved: Boolean;
    FNoShowReserveNo: string;
    FTeeBoxNo: Integer;
    FPrepareMin: Integer;
    FAssignMin: Integer;
    FAssignBalls: Integer;
    FReserveDateTime: string;

    procedure SetNoShowReserved(const AValue: Boolean);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    property NoShowReserved: Boolean read FNoShowReserved write SetNoShowReserved default False;
    property NoShowReserveNo: string read FNoShowReserveNo write FNoShowReserveNo;
    property TeeBoxNo: Integer read FTeeBoxNo write FTeeBoxNo;
    property PrepareMin: Integer read FPrepareMin write FPrepareMin;
    property AssignMin: Integer read FAssignMin write FAssignMin;
    property AssignBalls: Integer read FAssignBalls write FAssignBalls;
    property ReserveDateTime: string read FReserveDateTime write FReserveDateTime;
  end;

  { üũ�� ���� }
  PCheckinItem = ^TCheckinItem;
  TCheckinItem = record
    ReserveNo: string;
    TeeBoxNo: Integer;
  end;
  TCheckinList = class(TList)
  protected
    function GetItem(const AIndex: Integer): PCheckinItem;
    procedure SetItem(const AIndex: Integer; AItem: PCheckinItem);
  public
    constructor Create;
    destructor Destroy; override;

    function AddItem(const AReserveNo: string; const ATeeBoxNo: Integer): Integer;
    procedure InsertItem(const AIndex: Integer; const AReserveNo: string; const ATeeBoxNo: Integer);
    procedure DeleteItem(const AIndex: Integer);
    procedure Clear; override;

    property ItemList[const AIndex: Integer]: PCheckinItem read GetItem write SetItem;
  end;

  { �ڵ� ���� }
  TCodeRec = class
  private
    FCode: string;
    FCodeName: string;
    FMemo: string;
  public
    property Code: string read FCode write FCode;
    property CodeName: string read FCodeName write FCodeName;
    property Memo: string read FMemo write FMemo;
  end;

  { ȸ�� ���� }
  TMemberRec = record
    MemberSeq: Integer;
    MemberName: string;
    MemberNo: string;
    BirthDate: string;
    SexDiv: string;
    HpNo: string;
    CarNo: string;
    Email: string;
    MemberCardUId: string;
    XGolfNo: string;
    WelfareCode: string;
    ZipNo: string;
    Address1: string;
    Address2: string;
    QrCode: string;
    CustomerCode: string;
    GroupCode: string;
    EmployeeNo: string;
    SpecialYN: Boolean;
    SpectrumIntfYN: Boolean;
    SpectrumCustId: string;
    Memo: string;
    FingerPrint1: string;
    FingerPrint2: string;
  public
    procedure Clear;
  end;

  { ���� ���� }
  TCouponRec = record
    QrCode: string;         //�����Ϸù�ȣ
    CouponName: string;     //������
    DcDiv: string;          //���α���(A:��������, R:��������)
    DcCnt: Integer;         //���αݾ�(����) �Ǵ� ������(����)
    ApplyDcAmt: Integer;    //��������ݾ�
    MemberNo: string;       //ȸ����ȣ(���̸� ��ȸ�� ��� ����)
    StartDay: string;       //������
    ExpireDay: string;      //������
    UseCnt: Integer;        //��밡�� Ƚ��
    UsedCnt: Integer;       //����� Ƚ��
    EventName: string;      //�̺�Ʈ��
    DcCondDiv: string;      //�̿�����(1:�ߺ�����, 2:�ܵ�����)
    ProductDiv: string;     //���������ǰ���� (A:��ü��ǰ, S:Ÿ����ǰ, G:�Ϲݻ�ǰ , L:��ī��ǰ)
    TeeBoxProdDiv: string;  //Ÿ����ǰ���� (A:��ü, R:�Ⱓ, C:����, D:��������)
    UseYN: string;          //��뿩�� (Y:���Ϸ�, M:�����, N:�̻��)
    UseStatus: string;      //��뿩�� Description
  public
    procedure Clear;
  end;

  { ��ȯ ��ǰ ���� }
  TChangeProdRec = record
    OldPurchaseCode: string;
    ProductCode: string;
    ProductName: string;
    SaleAmt: Integer;
    StartDate: string;
    EndDate: string;
    UseMonth: Integer;
    CouponCount: Integer;
  public
    procedure Clear;
  end;

  { Ÿ�� ��ǰ ���� }
  TProdTeeBoxRec = class
  private
    FProductCode: string;
    FProductName: string;
    FZoneCode: string;
    FProductDiv: string;
    FUseDiv: string;
    FUseMonth: Integer;
    FUseCnt: Integer;
    FSexDiv: Integer;
    FOneUseTime: Integer;
    FOneUseCount: Integer;
    FProdStartTime: string;
    FProdEndTime: string;
    FExpireDay: Integer;
    FProductAmount: Integer;
    FMemo: string;
  public
    property ProductCode: string read FProductCode write FProductCode;
    property ProductName: string read FProductName write FProductName;
    property ZoneCode: string read FZoneCode write FZoneCode;
    property ProductDiv: string read FProductDiv write FProductDiv;
    property UseDiv: string read FUseDiv write FUseDiv;
    property UseMonth: Integer read FUseMonth write FUseMonth;
    property UseCnt: Integer read FUseCnt write FUseCnt;
    property SexDiv: Integer read FSexDiv write FSexDiv;
    property OneUseTime: Integer read FOneUseTime write FOneUseTime;
    property OneUseCount: Integer read FOneUseCount write FOneUseCount;
    property ProdStartTime: string read FProdStartTime write FProdStartTime;
    property ProdEndTime: string read FProdEndTime write FProdEndTime;
    property ExpireDay: Integer read FExpireDay write FExpireDay;
    property ProductAmount: Integer read FProductAmount write FProductAmount;
    property Memo: string read FMemo write FMemo;
  end;

  { ��Ŀ ���� ���� }
  TLockerRec = record
    LockerNo: Integer;      //��Ŀ��ȣ
    LockerName: string;     //��Ŀ��
    FloorCode: string;      //��
    ProductAmt: Integer;    //��ǰ�ݾ�
    KeepAmt: Integer;       //������
    UseStartDate: string;   //��������
    UseContinue: Boolean;   //�����뿩��
  public
    procedure Clear;
  end;

  { ���޻�(����Ŭ��,��������Ŭ��,��������) ���� ���� }
  TAffiliateRec = record
    Applied: Boolean;
    PartnerCode: string;    //���޻� �����ڵ�
    PartnerName: string;    //���޻��
    MemberCode: string;     //ȸ���ڵ�
    MemberName: string;     //ȸ����
    MemberTelNo: string;    //ȸ����ȭ��ȣ
    ItemCode: string;       //�����ڵ�
    ReadData: string;       //�ĺ�����
    IKozenExecId: string;   //�������� ����
    IKozenExecTime: string; //�������� ����
    ApprovalAmt: Integer;   //���αݾ�
  public
    procedure Clear;
  end;

  { ���� ����: OpenWeatherMap API }
  TWeatherInfo = record
    Enabled: Boolean;
    Host: string;
    ApiKey: string;
    Latitude: string; //����
    Longitude: string; //�浵
    Temper: string; //�µ�
    Precipit: string; //����Ȯ��
    Humidity: string; //����
    WindSpeed: string; //ǳ��
    DayTime: Boolean; //��: True, ��: False
    Condition: string; //��������
    WeatherId: Integer; //��������Id
    IconIndex: Integer; //������
  end;

  { ���� �����(�� �þ�) ���� ���� }
  TSubMonitor = class
  private
    FEnabled: Boolean;
    FTop: Integer;
    FLeft: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FBackgroundColor: LongInt;
    FShowErrorStatus: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: Boolean read FEnabled write FEnabled;
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property BackgroundColor: Integer read FBackgroundColor write FBackgroundColor;
    property ShowErrorStatus: Boolean read FShowErrorStatus write FShowErrorStatus;
  end;

  { ȯ�� ���� ���� }
  TGlobal = class
  private
    FHideTaskBar: Boolean;
    FHideCursor: Boolean;

    FReceiptPrint: TReceiptPrint;

    FClientConfig: TClientConfig;
    FPluginConfig: TPluginConfig;
    FDeviceConfig: TDeviceConfig;
    FSubMonitor: TSubMonitor;

    FProductVersion: string;
    FFileVersion: string;
    FAppName: string;
    FClosing: Boolean;
    FConfigRegistry: TRegistryIniFile;
    FConfig: TIniFile;
    FConfigFileName: string;
    FConfigUpdated: string;
    FConfigLocal: TMemIniFile;
    FConfigLocalFileName: string;
    FConfigTable: TMemIniFile;
    FConfigTableFileName: string;
    FConfigLauncher: TIniFile;
    FConfigLauncherFileName: string;
    FConfigLessonReceipt: TIniFile;
    FConfigLessonReceiptFileName: string;
    FWakeupListFileName: string;
    FLogFile: string;
    FPayLogFile: string;

    FLogDelete: Boolean;
    FLogDeleting: Boolean;
    FLogDeleted: Boolean;
    FLogDeleteDays: Integer;

    FElapTimeFile: string;
    FHomeDir: string;
    FPluginDir: string;
    FDataDir: string;
    FConfigDir: string;
    FContentsDir: string;
    FDownloadDir: string;
    FLogDir: string;
    FMediaDir: string;
    FWebCacheDir: string;

    FBaseTimer: TBaseTimerThread;
    { ���� }
    FCurrentDate: string; //yyyymmdd
    FFormattedCurrentDate: string; //yyyy-mm-dd
    FCurrentTime: string; //hhnnss
    FFormattedCurrentTime: string; //hh:nn:ss
    FCurrentDateTime: string; //yyyymmddhhnnss
    FFormattedCurrentDateTime: string; //yyyy-mm-dd hh:nn:ss
    { ���� }
    FLastDate: string; //yyyymmdd
    FFormattedLastDate: string; //yyyy-mm-dd
    { ���� }
    FNextDate: string; //yyyymmdd
    FFormattedNextDate: string; //yyyy-mm-dd

    FDayOfWeekKR: string; //����
    FCheckAutoReboot: Boolean; //������ Ȯ�� ����
    FIgnoreAutoReboot: Boolean; //������ ���� ����
    FAutoRebootTime: string;
    FPrepareMin: Integer; //Ÿ������ �غ�ð�(��)
    FGameOverAlarmMin: Integer;  //Ÿ������ ���� �ܿ��ð�(��)
    FTeeBoxQuickView: Boolean; //Ÿ�� �������� ȭ�鿡�� ����Ÿ�� ���� ����
    FTeeBoxQuickViewMode: Integer; //����Ÿ�� ǥ�� ���
    FTeeBoxForceAssign: Boolean; //�� ȸ���� Ÿ�� ���� ���
    FTeeBoxForceAssignOnError: Boolean; //Ÿ�� ������ Ÿ�� ���� ���
    FIsSimpleMember: Boolean; //���� ȸ�� ���(�̸��� �Է�)
    FSelfCashReceiptDefault: Boolean; //���ݿ����� �����߱� �⺻ ���� ����
    FReserveAllowedOnOrderTime: Boolean; //�ֹ��ð� �������� Ÿ����ǰ ���� ��� ����
    FHoldAllowedOnLeftClick: Boolean; //���콺 �� Ŭ������ Ÿ�� �ӽÿ��� ��� ����
    FAutoRunAdminCall: Boolean; //�˸��� �ڵ� ���� ����
    FAdminCallHandle: HWND; //�˸��� �ڵ�
    FLastNoticeDate: string; //�������� ���� Ȯ������
    FTeeBoxFontSizeAdjust: Integer; //Ÿ�� ���� ǥ�� �۲� ũ�� ������
    FTeeBoxMaxCountOfFloors: Integer; //���� �ִ� Ÿ�� ��
    FReceiptCopies: Integer; //������ ��� �ż�
    FTeeBoxTicketCopies: Integer; //Ÿ������ǥ ��� �ż�
    FReceiptPreview: Boolean; //������ ��� �̸�����

    FBackOfficeUrl: string;

    FStartModuleId: Integer;
    FTeeBoxViewId: Integer;
    FTeeBoxEmergencyId: Integer;
    FMainFormHandle: HWND;
    FSaleFormId: Integer;
    FSaleTableFormId: Integer;
    FSubMonitorId: Integer;
    FWebViewId: Integer;
    FMsgBoxHandle: Integer;

    FPreparedLocker: Boolean;
    FTeeBoxPlayingCount: Integer;
    FTeeBoxWaitingCount: Integer;
    FTeeBoxReadyCount: Integer;

    FTeeBoxStatusWorking: Boolean; //Ÿ��������Ȳ ������ ����
    FImmediateTeeBoxAssign: Boolean; //��ù��� ��� ����
    FTeeBoxChangedReIssue: Boolean; //Ÿ�� ���� �� ����ǥ ���� ����
    FTeeBoxEmergencyMode: Boolean; //��޹��� ���
    FTeeBoxTeleReserved: Boolean; //��ȭ���� ����
    FUseTeeBoxTeleReserved: Boolean; //��ȭ���� ��� ����
    FUseWebCamMirror: Boolean; //������� ��ķ �̷� ǥ�� ����
    FUseFingerPrintMirror: Boolean; //������� �����ν� ȭ�� �̷� ǥ�� ����
    FUseLessonReceipt: Boolean; //������ ���̿����� ���� ��� ��� ����
    FTeeBoxHoldWorking: Boolean;

    FNoticePopupUrl: string; //�������� �˾�Url

    procedure ResetLogFile;
    procedure SetConfigUpdated(const AValue: string);
  public
    FS: TFormatSettings;
    TeeBoxFloorInfo: TArray<TTeeBoxFloorItem>; //���� Ÿ���� ��ġ ����
    LockerFloorInfo: TArray<TLockerFloorItem>; //��Ŀ �� ����
    LockerInfo: TArray<TLockerItem>; //��Ŀ ����
    NoticeInfo: TArray<TNoticeRec>; //��������
    ScreenInfo: TScreenInfo; //ȭ�� ����
    TableInfo: TTableInfo; //���̺�&�� ����
    PartnerCenter: TPartnerCenterConfig; //��Ʈ�ʼ���
    AirConditioner: TAirConditioner; //��,��ǳ��
    WelbeingClub: TWelbeingClub; //����Ŭ��
    RefreshClub: TRefreshClub; //��������Ŭ��
    RefreshGolf: TRefreshGolf; //������������
    IKozen: TIKozen; //��������
    RoungeMembers: TRoungeMembers; //������������
    Smartix: TSmartix; //����ƽ��-�¶����Ǹ�
    ParkingServer: TParkingServer; //�������� ����
    TeeBoxADInfo: TTeeBoxADInfo; //Ÿ����AD
    AddOnTicket: TAddonTicket; //�δ�ü� �̿�� ���� ����
    NoShowInfo: TNoshowInfo; //��� ���� ����
    WeatherInfo: TWeatherInfo; //���� ����

    constructor Create;
    destructor Destroy; override;

    procedure BarcodeScannerClose;
    procedure BarcodeScannerOpen;
    procedure ComPortRxCharBarcodeScanner(Sender: TObject);
    procedure ComPortRxCharRFIDReader(Sender: TObject);
    procedure ComPortRxCharWelfareCardReader(Sender: TObject);

    procedure CheckRegistry;
    procedure ReadRegistry;
    procedure CheckConfig;
    procedure ReadConfig;
    procedure CheckConfigLocal;
    procedure ReadConfigLocal;
    procedure CheckConfigTable;
    procedure ReadConfigTable;
    procedure DoDeleteLog;

    property ReceiptPrint: TReceiptPrint read FReceiptPrint write FReceiptPrint;

    property Config: TIniFile read FConfig write FConfig;
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    property ConfigUpdated: string read FConfigUpdated write SetConfigUpdated;
    property ConfigLocal: TMemIniFile read FConfigLocal write FConfigLocal;
    property ConfigLocalFileName: string read FConfigLocalFileName write FConfigLocalFileName;
    property ConfigTable: TMemIniFile read FConfigTable write FConfigTable;
    property ConfigTableFileName: string read FConfigTableFileName write FConfigTableFileName;
    property ConfigLauncher: TIniFile read FConfigLauncher write FConfigLauncher;
    property ConfigLauncherFileName: string read FConfigLauncherFileName write FConfigLauncherFileName;
    property ConfigLessonReceipt: TIniFile read FConfigLessonReceipt write FConfigLessonReceipt;
    property ConfigLessonReceiptFileName: string read FConfigLessonReceiptFileName write FConfigLessonReceiptFileName;
    property WakeupListFileName: string read FWakeupListFileName write FWakeupListFileName;
    property ConfigRegistry: TRegistryIniFile read FConfigRegistry write FConfigRegistry;
    property ClientConfig: TClientConfig read FClientConfig write FClientConfig;
    property PluginConfig: TPluginConfig read FPluginConfig write FPluginConfig;
    property SubMonitor: TSubMonitor read FSubMonitor write FSubMonitor;

    property BackOfficeUrl: string read FBackOfficeUrl write FBackOfficeUrl;

    property ProductVersion: string read FProductVersion write FProductVersion;
    property FileVersion: string read FFileVersion write FFileVersion;
    property AppName: string read FAppName write FAppName;
    property Closing: Boolean read FClosing write FClosing;
    property HideTaskBar: Boolean read FHideTaskBar write FHideTaskBar;
    property HideCursor: Boolean read FHideCursor write FHideCursor;
    property LogFile: string read FLogFile write FLogFile;
    property PayLogFile: string read FPayLogFile write FPayLogFile;
    property LogDelete: Boolean read FLogDelete write FLogDelete;
    property LogDeleting: Boolean read FLogDeleting write FLogDeleting;
    property LogDeleted: Boolean read FLogDeleted write FLogDeleted;
    property LogDeleteDays: Integer read FLogDeleteDays write FLogDeleteDays;
    property ElapTimeFile: string read FElapTimeFile write FElapTimeFile;
    property HomeDir: string read FHomeDir write FHomeDir;
    property PluginDir: string read FPluginDir write FPluginDir;
    property DataDir: string read FDataDir write FDataDir;
    property ConfigDir: string read FConfigDir write FConfigDir;
    property DownloadDir: string read FDownloadDir write FDownloadDir;
    property LogDir: string read FLogDir write FLogDir;
    property MediaDir: string read FMediaDir write FMediaDir;
    property ContentsDir: string read FContentsDir write FContentsDir;
    property WebCacheDir: string read FWebCacheDir write FWebCacheDir;

    property CurrentDate: string read FCurrentDate write FCurrentDate;
    property CurrentTime: string read FCurrentTime write FCurrentTime;
    property FormattedCurrentDate: string read FFormattedCurrentDate write FFormattedCurrentDate;
    property FormattedCurrentTime: string read FFormattedCurrentTime write FFormattedCurrentTime;
    property CurrentDateTime: string read FCurrentDateTime write FCurrentDateTime;
    property FormattedCurrentDateTime: string read FFormattedCurrentDateTime write FFormattedCurrentDateTime;

    property LastDate: string read FLastDate write FLastDate;
    property FormattedLastDate: string read FFormattedLastDate write FFormattedLastDate;

    property NextDate: string read FNextDate write FNextDate;
    property FormattedNextDate: string read FFormattedNextDate write FFormattedNextDate;

    property DayOfWeekKR: string read FDayOfWeekKR write FDayOfWeekKR;
    property CheckAutoReboot: Boolean read FCheckAutoReboot write FCheckAutoReboot;
    property IgnoreAutoReboot: Boolean read FIgnoreAutoReboot write FIgnoreAutoReboot;
    property AutoRebootTime: string read FAutoRebootTime write FAutoRebootTime;
    property PrepareMin: Integer read FPrepareMin write FPrepareMin;
    property GameOverAlarmMin: Integer read FGameOverAlarmMin write FGameOverAlarmMin default GCD_GAMEOVER_ALARM_MIN;
    property TeeBoxQuickView: Boolean read FTeeBoxQuickView write FTeeBoxQuickView default False;
    property TeeBoxQuickViewMode: Integer read FTeeBoxQuickViewMode write FTeeBoxQuickViewMode default 0;
    property TeeBoxForceAssign: Boolean read FTeeBoxForceAssign write FTeeBoxForceAssign default False;
    property TeeBoxForceAssignOnError: Boolean read FTeeBoxForceAssignOnError write FTeeBoxForceAssignOnError default False;
    property IsSimpleMember: Boolean read FIsSimpleMember write FIsSimpleMember default False;
    property SelfCashReceiptDefault: Boolean read FSelfCashReceiptDefault write FSelfCashReceiptDefault;
    property ReceiptCopies: Integer read FReceiptCopies write FReceiptCopies;
    property TeeBoxTicketCopies: Integer read FTeeBoxTicketCopies write FTeeBoxTicketCopies;
    property ReceiptPreview: Boolean read FReceiptPreview write FReceiptPreview;
    property ReserveAllowedOnOrderTime: Boolean read FReserveAllowedOnOrderTime write FReserveAllowedOnOrderTime;
    property HoldAllowedOnLeftClick: Boolean read FHoldAllowedOnLeftClick write FHoldAllowedOnLeftClick;
    property AutoRunAdminCall: Boolean read FAutoRunAdminCall write FAutoRunAdminCall;
    property AdminCallHandle: HWND read FAdminCallHandle write FAdminCallHandle default 0;
    property LastNoticeDate: string read FLastNoticeDate write FLastNoticeDate;
    property TeeBoxFontSizeAdjust: Integer read FTeeBoxFontSizeAdjust write FTeeBoxFontSizeAdjust default 0;
    property TeeBoxMaxCountOfFloors: Integer read FTeeBoxMaxCountOfFloors write FTeeBoxMaxCountOfFloors default 0;

    property StartModuleId: Integer read FStartModuleId write FStartModuleId;
    property TeeBoxViewId: Integer read FTeeBoxViewId write FTeeBoxViewId;
    property TeeBoxEmergencyId: Integer read FTeeBoxEmergencyId write FTeeBoxEmergencyId;
    property MainFormHandle: HWND read FMainFormHandle write FMainFormHandle default 0;
    property SaleFormId: Integer read FSaleFormId write FSaleFormId default 0;
    property SaleTableFormId: Integer read FSaleTableFormId write FSaleTableFormId default 0;
    property SubMonitorId: Integer read FSubMonitorId write FSubMonitorId default 0;
    property WebViewId: Integer read FWebViewId write FWebViewId default 0;
    property MsgBoxHandle: Integer read FMsgBoxHandle write FMsgBoxHandle;

    property DeviceConfig: TDeviceConfig read FDeviceConfig write FDeviceConfig;
    property PreparedLocker: Boolean read FPreparedLocker write FPreparedLocker default False;

    property TeeBoxPlayingCount: Integer read FTeeBoxPlayingCount write FTeeBoxPlayingCount default 0;
    property TeeBoxWaitingCount: Integer read FTeeBoxWaitingCount write FTeeBoxWaitingCount default 0;
    property TeeBoxReadyCount: Integer read FTeeBoxReadyCount write FTeeBoxReadyCount default 0;

    property TeeBoxStatusWorking: Boolean read FTeeBoxStatusWorking write FTeeBoxStatusWorking;
    property ImmediateTeeBoxAssign: Boolean read FImmediateTeeBoxAssign write FImmediateTeeBoxAssign;
    property TeeBoxChangedReIssue: Boolean read FTeeBoxChangedReIssue write FTeeBoxChangedReIssue;
    property TeeBoxEmergencyMode: Boolean read FTeeBoxEmergencyMode write FTeeBoxEmergencyMode default False;
    property TeeBoxTeleReserved: Boolean read FTeeBoxTeleReserved write FTeeBoxTeleReserved default False;
    property UseTeeBoxTeleReserved: Boolean read FUseTeeBoxTeleReserved write FUseTeeBoxTeleReserved default False;
    property UseWebCamMirror: Boolean read FUseWebCamMirror write FUseWebCamMirror default False;
    property UseFingerPrintMirror: Boolean read FUseFingerPrintMirror write FUseFingerPrintMirror default False;
    property UseLessonReceipt: Boolean read FUseLessonReceipt write FUseLessonReceipt default False;
    property TeeBoxHoldWorking: Boolean read FTeeBoxHoldWorking write FTeeBoxHoldWorking default False;

    property NoticePopupUrl: string read FNoticePopupUrl write  FNoticePopupUrl;
  end;

var
  Global: TGlobal;
  VanModule: TVanDaemonModule;
  PaycoModule: TPaycoNewModule;
  LogCS: TRTLCriticalSection;
//  ToastMessage: TToastMessage;

procedure UpdateLog(const AFileName, AStr: string; const ALineBreak: Boolean=False);
procedure SendPluginCommand(const ACommand: string; const AOwnerID, ATargetID: Integer);
procedure ShowSalePos(const AOwnerId: Integer; const AProdCode: string='');
procedure ShowSalePosTable(const AOwnerId: Integer);
procedure ShowTeeBoxView(const AOwnerId: Integer);
procedure ShowLockerView(const AOwnerId: Integer);
procedure ShowWebView(const AOwnerId: Integer; const AUrl: string);
procedure ShowWebViewModal(const AOwnerId: Integer; const ATitle, AUrl: string; const AShowNavigator: Boolean; const AShowNoMoreToday: Boolean=False);
procedure ShowPartnerCenter(const AOwnerId: Integer; const ARedirectUri: string);
procedure ShowWeatherInfo;
function GetAffiliateName(const AAffiliateDiv, ADefaultName: string): string;
function GetBaudrate(const ABaudrate: Integer): TBaudRate;
function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
procedure OpenCashDrawer;

//procedure ToastInfo(const ACaption, AMsgText: string);
//procedure ToastSuccess(const ACaption, AMsgText: string);
//procedure ToastError(const ACaption, AMsgText: string);

implementation

uses
  { Native }
  System.Variants, System.StrUtils, System.Math, WinApi.Messages, System.DateUtils,
  { Plugin System }
  uPluginManager, uPluginMessages,
  { Project }
  uXGClientDM, uXGCommonLib, uXGSaleManager;

procedure UpdateLog(const AFileName, AStr: string; const ALineBreak: Boolean=False);
begin
  try
    EnterCriticalSection(LogCS);
    try
      WriteToFile(AFileName,
        '[' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ']' +
        IIF(ALineBreak, sLineBreak, ' ') + AStr);
    except
    end;
  finally
    LeaveCriticalSection(LogCS);
  end;
end;

procedure SendPluginCommand(const ACommand: string; const AOwnerID, ATargetID: Integer);
begin
  with TPluginMessage.Create(nil) do
  try
    Command := ACommand;
    AddParams(CPP_OWNER_ID, AOwnerID);
    PluginMessageToID(ATargetID);
  finally
    Free;
  end;
end;

procedure ShowSalePos(const AOwnerId: Integer; const AProdCode: string);
var
  PM: TPluginMessage;
begin
  if Global.TeeBoxEmergencyMode then
    Exit;

  PM := TPluginMessage.Create(nil);
  try
    PM.AddParams(CPP_OWNER_ID, AOwnerId);
    PM.AddParams(CPP_PRODUCT_CD, AProdCode);
    if (Global.SaleFormId = 0) then
    begin
      PM.Command := CPC_INIT;
      case SaleManager.StoreInfo.POSType of
        CPO_SALE_TEEBOX, //Ÿ������(����Ʈ)
        CPO_SALE_LESSON_ROOM: //������(�Ľ���)
          Global.SaleFormId := PluginManager.Open('XGSalePos' + CPL_EXTENSION, PM).PluginID;
        else
          Global.SaleFormId := PluginManager.Open('XGSalePosCafe' + CPL_EXTENSION, PM).PluginID;
      end;
    end
    else
    begin
      PM.Command := CPC_SET_FOREGROUND;
      PM.PluginMessageToID(Global.SaleFormId);
    end;
 finally
    FreeAndNil(PM);
  end;
end;

procedure ShowSalePosTable(const AOwnerId: Integer);
var
  PM: TPluginMessage;
  sProdCode: string;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.SaleTableFormId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      Global.SaleTableFormId := PluginManager.Open('XGSalePosTable' + CPL_EXTENSION, PM).PluginID;
    end else
    begin
      sProdCode := '';
      if (ClientDM.QRSaleItem.RecordCount > 0) then
        sProdCode := ClientDM.QRSaleItem.FieldByName('product_cd').AsString;
      PM.Command := CPC_SET_FOREGROUND;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_PRODUCT_CD, sProdCode);
      PM.PluginMessageToID(Global.SaleTableFormId);
    end;
 finally
    FreeAndNil(PM);
  end;
end;

procedure ShowTeeBoxView(const AOwnerId: Integer);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if Global.TeeBoxEmergencyMode then
    begin
      if (Global.TeeBoxEmergencyId = 0) then
      begin
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, AOwnerId);
        Global.TeeBoxEmergencyId := PluginManager.Open('XGTeeBoxViewER' + CPL_EXTENSION, PM).PluginID;
      end
      else
      begin
        PM.Command := CPC_SET_FOREGROUND;
        PM.AddParams(CPP_OWNER_ID, AOwnerId);
        PM.PluginMessageToID(Global.TeeBoxEmergencyId);
      end;
    end
    else
    begin
      if (Global.TeeBoxViewId = 0) then
      begin
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, AOwnerId);
        Global.TeeBoxViewId := PluginManager.Open('XGTeeBoxView' + CPL_EXTENSION, PM).PluginID;
      end
      else
      begin
        PM.Command := CPC_SET_FOREGROUND;
        PM.AddParams(CPP_OWNER_ID, AOwnerId);
        PM.PluginMessageToID(Global.TeeBoxViewId);
      end;
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowLockerView(const AOwnerId: Integer);
var
  PM: TPluginMessage;
begin
  if Global.TeeBoxEmergencyMode then
    Exit;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, AOwnerId);
    PluginManager.OpenModal('XGLocker' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowWebView(const AOwnerId: Integer; const AUrl: string);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.WebViewId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_NAVIGATE_URL, AUrl);
      Global.WebViewId := PluginManager.Open(Global.PluginConfig.WebViewModule, PM).PluginId;
    end else
    begin
      PM.Command := CPC_SET_FOREGROUND;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_NAVIGATE_URL, AUrl);
      PM.PluginMessageToID(Global.WebViewId);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowWebViewModal(const AOwnerId: Integer; const ATitle, AUrl: string; const AShowNavigator: Boolean; const AShowNoMoreToday: Boolean);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, AOwnerId);
    PM.AddParams(CPP_FORM_TITLE, ATitle);
    PM.AddParams(CPP_NAVIGATE_URL, AUrl);
    PM.AddParams(CPP_SHOW_NAVIGATOR, AShowNavigator);
    PM.AddParams(CPP_SHOW_NO_MORE, AShowNoMoreToday);
    PluginManager.OpenModal('XGNoticeView' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowPartnerCenter(const AOwnerId: Integer; const ARedirectUri: string);
var
  sUrl: string;
begin
  sUrl := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&redirectUrl=/%s', [
            ExcludeTrailingBackslash(Global.BackOfficeUrl),
            SaleManager.StoreInfo.StoreCode,
            SaleManager.UserInfo.UserId,
            SaleManager.UserInfo.TerminalPwd,
            ARedirectUri
          ]);
  ShowWebView(AOwnerId, sUrl);
end;

procedure ShowWeatherInfo;
var
  PM: TPluginMessage;
begin
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, 0);
      PluginManager.OpenModal('XGWeather' + CPL_EXTENSION, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      UpdateLog(Global.LogFile, Format('ShowWeatherInfo.Exception = %s', [E.Message]));
  end;
end;

function GetAffiliateName(const AAffiliateDiv, ADefaultName: string): string;
begin
  if (AAffiliateDiv = Global.WelbeingClub.PartnerCode) then
    Result := '����Ŭ��'
  else if (AAffiliateDiv = Global.RefreshClub.PartnerCode) then
    Result := '��������/Ŭ��'
  else if (AAffiliateDiv = Global.RefreshGolf.PartnerCode) then
    Result := '��������/����'
  else if (AAffiliateDiv = Global.IKozen.PartnerCode) then
    Result := '��������'
  else if (AAffiliateDiv = Global.Smartix.PartnerCode) then
    Result := '����ƽ��'
  else
    Result := ADefaultName;
end;

function GetBaudrate(const ABaudrate: Integer): TBaudRate;
begin
  case ABaudrate of
    9600:   Result := br9600;
    14400:  Result := br14400;
    19200:  Result := br19200;
    38400:  Result := br38400;
    57600:  Result := br57600;
    115200: Result := br115200;
    128000: Result := br128000;
    256000: Result := br256000;
  else
    Result := br9600;
  end;
end;

function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
var
  hKeyHandle: HKEY;
  nErrCode, nIndex: Integer;
  sValueName, sData: string;
  wValueLen, wDataLen, wValueType: DWORD;
  SL: TStringList;
begin
  Result := False;
  AErrMsg := '';
  nErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ, hKeyHandle);

  try
    if (nErrCode <> ERROR_SUCCESS) then
      raise Exception.Create(Format('COM%d�� ��ϵ��� ���� �����Ʈ�Դϴ�.', [AComNumber]));

    SL := TStringList.Create;
    try
      nIndex := 0;
      repeat
        wValueLen := 256;
        wDataLen := 256;
        SetLength(sValueName, wValueLen);
        SetLength(sData, wDataLen);
        nErrCode := RegEnumValue(
          hKeyHandle,
          nIndex,
          PChar(sValueName),
          Cardinal(wValueLen),
          nil,
          @wValueType,
          PByte(PChar(sData)),
          @wDataLen);

        if (nErrCode = ERROR_SUCCESS) then
        begin
          SetLength(sData, wDataLen - 1);
          SL.Add(sData);
          Inc(nIndex);
        end
        else if (nErrCode <> ERROR_NO_MORE_ITEMS) then
          Break;
      until (nErrCode <> ERROR_SUCCESS);

      SL.Sort;
      for nIndex := 0 to Pred(SL.Count) do
      begin
        Result := (StrToInt(StringReplace(UpperCase(SL[nIndex]), 'COM', '', [rfReplaceAll])) = AComNumber);
        if Result then
          Break;
      end;
    finally
      RegCloseKey(hKeyHandle);
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckEnumComPorts.Exception = %s', [E.Message]));
    end;
  end;
end;

procedure OpenCashDrawer;
var
  sBuffer: string;
begin
  with Global.DeviceConfig.ReceiptPrinter do
    if Enabled and
       Assigned(ComDevice) then
    try
      if not ComDevice.Active then
      begin
        if (Port >= 10) then
          ComDevice.DeviceName := '\\.\COM' + IntToStr(Port)
        else
          ComDevice.DeviceName := 'COM' + IntToStr(Port);
        ComDevice.BaudRate := GetBaudrate(Baudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        ComDevice.Open;
      end;

      sBuffer := #27#112#0#25#250;
      ComDevice.Write(PAnsiChar(sBuffer), Length(sBuffer), False);
    except
      on E: Exception do
        UpdateLog(Global.LogFile, Format('OpenCashDrawer.Exception = %s', [E.Message]));
    end;
end;

(*
procedure ToastInfo(const ACaption, AMsgText: string);
begin
  if Assigned(ToastMessage) then
    ToastMessage.Toast(tpMode.tpSuccess, ACaption, AMsgText);
end;

procedure ToastSuccess(const ACaption, AMsgText: string);
begin
  if Assigned(ToastMessage) then
    ToastMessage.Toast(tpMode.tpInfo, ACaption, AMsgText);
end;

procedure ToastError(const ACaption, AMsgText: string);
begin
  if Assigned(ToastMessage) then
    ToastMessage.Toast(tpMode.tpError, ACaption, AMsgText);
end;
*)

{ TGlobal }

constructor TGlobal.Create;
begin
  inherited;

  FS := TFormatSettings.Create('ko-KR');
  with FS, FormatSettings do
  begin
    DateSeparator := '-';
    TimeSeparator := ':';
    ShortDateFormat := 'yyyy-mm-dd';
    ShortTimeFormat := 'hh:nn:ss';
    LongDateFormat := 'yyyy-mm-dd';
    LongTimeFormat := 'hh:nn:ss';
  end;

  NoShowInfo := TNoShowInfo.Create;
  VanModule := TVanDaemonModule.Create;
  PaycoModule := TPaycoNewModule.Create;
  PaycoModule.SetOpen;

  FClientConfig := TClientConfig.Create;
  FPluginConfig := TPluginConfig.Create;
  FDeviceConfig := TDeviceConfig.Create;
  FSubMonitor := TSubMonitor.Create;
  FCurrentDate := FormatDateTime('yyyymmdd', System.DateUtils.Today);
  FFormattedCurrentDate := FormattedDateString(FCurrentDate);
  FCurrentTime := FormatDateTime('hhnnss', System.DateUtils.Today);
  FFormattedCurrentTime := FormattedTimeString(FCurrentTime);
  FCurrentDateTime := FCurrentDate + FCurrentTime;
  FFormattedCurrentDateTime := FFormattedCurrentDate + ' ' + FFormattedCurrentTime;
  FLastDate := FormatDateTime('yyyymmdd', System.DateUtils.Yesterday);
  FFormattedLastDate := FormattedDateString(FLastDate);
  FNextDate := FormatDateTime('yyyymmdd', System.DateUtils.Tomorrow);
  FFormattedNextDate := FormattedDateString(FNextDate);
  FDayOfWeekKR := DayOfWeekName(Now);

  FAppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  FHomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FConfigDir := FHomeDir + 'config\';
  FPluginDir := FHomeDir + 'plugin\';
  FDataDir := FHomeDir + 'data\';
  FContentsDir := FHomeDir + 'contents\';
  FDownloadDir := FHomeDir + 'download\';
  FMediaDir := FHomeDir + 'media\';
  FWebcacheDir := FHomeDir + 'cache\';
  FLogDir := FHomeDir + 'log\';
  ResetLogFile;

  ForceDirectories(FConfigDir);
  ForceDirectories(FPluginDir);
  ForceDirectories(FDataDir);
  ForceDirectories(FContentsDir);
  ForceDirectories(FDownloadDir);
  ForceDirectories(FMediaDir);
  ForceDirectories(FWebCacheDir);
  ForceDirectories(FLogDir);

  FConfigRegistry := TRegistryIniFile.Create(CCC_XTOUCH_REGISTRY_KEY);
  FConfigFileName := FConfigDir + FAppName + '.config';
  FConfig := TIniFile.Create(FConfigFileName);
  FConfigLocalFileName := FConfigDir + FAppName + 'Local.config';
  FConfigLocal := TMemIniFile.Create(FConfigLocalFileName);
  FConfigTableFileName := FConfigDir + FAppName + 'Table.config';
  FConfigTable := TMemIniFile.Create(FConfigTableFileName);
  FConfigLauncherFileName := FConfigDir + GSD_LAUNCHER_NAME + '.config';
  FConfigLauncher := TIniFile.Create(FConfigLauncherFileName);
  FConfigLessonReceiptFileName := FConfigDir + FAppName + 'LessonReceipt.config';
  FConfigLessonReceipt := TIniFile.Create(FConfigLessonReceiptFileName);
  FWakeupListFileName := FConfigDir + FAppName + 'Wakeup.lst';
  FNoticePopupUrl := '';

  CheckRegistry;
  ReadRegistry;
  CheckConfig;
  ReadConfig;
  CheckConfigLocal;
  ReadConfigLocal;
  CheckConfigTable;
  ReadConfigTable;

  TableInfo.Reset;
  TableInfo.ActiveTableNo := 0;

  FBaseTimer := TBaseTimerThread.Create;
  FBaseTimer.FreeOnTerminate := True;
  if not FBaseTimer.Started then
    FBaseTimer.Start;
end;

destructor TGlobal.Destroy;
begin
  if Assigned(FBaseTimer) then
    FBaseTimer.Terminate;
  FConfigRegistry.Free;
  NoShowInfo.Free;
  VanModule.Free;
  PaycoModule.Free;
  FClientConfig.Free;
  FPluginConfig.Free;
  FDeviceConfig.Free;
  FSubMonitor.Free;
  if Assigned(TableInfo.ActiveGroupTableList) then
    FreeAndNil(TableInfo.ActiveGroupTableList);
  if Assigned(FReceiptPrint) then
    FReceiptPrint.Free;

  inherited Destroy;
end;

procedure TGlobal.CheckRegistry;
begin
  with FConfigRegistry do
  begin
    if not SectionExists('Client') then
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', FConfig.ReadString('APIServer', 'Host', GCD_API_SERVER_HOST));
      WriteString('Client', 'SecretKey', FConfig.ReadString('APIServer', 'ClientKey', ''));
      WriteBool('Client', 'UseLocalSetting', False);
    end;

    if not SectionExists('StoreInfo') then
    begin
      WriteString('StoreInfo', 'CreditTID', '');
      WriteString('StoreInfo', 'PaycoTID', '');
    end;
  end;
end;

procedure TGlobal.ReadRegistry;
begin
  with FConfigRegistry do
  begin
    FClientConfig.Host := ReadString('Client', 'Host', GCD_BACKOFFICE_HOST);
    FClientConfig.ClientId := ReadString('Client', 'ClientId', '0000000000');
    FClientConfig.SecretKey := StrDecrypt(ReadString('Client', 'SecretKey', ''));
    FClientConfig.UseLocalSetting := ReadBool('Client', 'UseLocalSetting', False);
  end;

  BackOfficeUrl := FClientConfig.Host;
end;

procedure TGlobal.CheckConfig;
begin
  //================================================================================================
  // ��ó
  //================================================================================================
  with FConfigLauncher do
  begin
    { ������Ʈ ���� }
    if not SectionExists('Config') then
    begin
      WriteString('Config', 'UpdateURL', 'http://nhncdn.xpartners.co.kr/POS/R1/');
      WriteString('Config', 'RunApp', AppName + '.exe');
      WriteString('Config', 'Params', '');
      WriteBool('Config', 'RebootWhenUpdated', False);
    end;
  end;

  //================================================================================================
  // �ý��� ȯ�� ����
  //================================================================================================
  with FConfig do
  begin
    { Ŭ���̾�Ʈ ���� }
    if not SectionExists('Client') then
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', '');
      WriteString('Client', 'SecretKey', '');
      WriteToFile(FConfigFileName, '');
    end;

    { �Ϲ� ���� }
    if not SectionExists('Config') then
    begin
      WriteString('Config', 'LastUpdated', '');
      WriteInteger('Config', 'BaseWidth', 1366);
      WriteInteger('Config', 'BaseHeight', 768);
      WriteBool('Config', 'HideTaskBar', False);
      WriteBool('Config', 'HideCursor', False);
      WriteString('Config', 'AutoRebootTime', GSD_AUTO_REBOOT_TIME);
      WriteToFile(FConfigFileName, '');
    end;

    { ���� ���� }
    if not SectionExists('StoreInfo') then
    begin
      WriteInteger('StoreInfo', 'POSType', CPO_SALE_TEEBOX);
//      WriteString('StoreInfo', 'VanCode', 'KCP');
//      WriteString('StoreInfo', 'CreditTID', '');
//      WriteString('StoreInfo', 'PaycoTID', '');
      WriteToFile(FConfigFileName, '');
    end;

    { Ÿ����AD }
    if not SectionExists('TeeBoxAD') then
    begin
      WriteBool('TeeBoxAD', 'Enabled', False);
      WriteString('TeeBoxAD', 'Host', CCD_TEEBOX_HOST);
      WriteInteger('TeeBoxAD', 'APIPort', CCD_TEEBOX_API_PORT);
      WriteInteger('TeeBoxAD', 'DBPort', CCD_TEEBOX_DB_PORT);
      WriteString('TeeBoxAD', 'UserId', CCD_TEEBOX_USER);
      WriteString('TeeBoxAD', 'Password', StrEncrypt(CCD_TEEBOX_PWD));
      WriteInteger('TeeBoxAD', 'Timeout', GSD_TCP_DEFAULT_TIMEOUT);
      WriteToFile(FConfigFileName, '');
    end;

    (*
    { ��Ʈ�ʼ��� }
    if not SectionExists('BackOffice') then
    begin
      WriteString('BackOffice', 'Host', GCD_BACKOFFICE_HOST);
      WriteFile(FConfigFileName, '');
    end;
    *)

    { �������� ���� }
    if not SectionExists('ParkingServer') then
    begin
      WriteInteger('ParkingServer', 'Vendor', 0); //0:������ũ�н�
      WriteBool('ParkingServer', 'Enabled', False);
      WriteString('ParkingServer', 'Host', '127.0.0.1');
      WriteInteger('ParkingServer', 'Port', 3306);
      WriteString('ParkingServer', 'Database', '');
      WriteString('ParkingServer', 'CharSet', 'utf8');
      WriteString('ParkingServer', 'UserId', '');
      WriteString('ParkingServer', 'Password', '');
      WriteInteger('ParkingServer', 'BaseHours', 3);
      WriteToFile(FConfigFileName, '');
    end;

    { �÷����� }
    if not SectionExists('Plugin') then
    begin
      WriteString('Plugin', 'StartModule', CPL_START);
      WriteString('Plugin', 'SubMonitorModule', CPL_SUB_MONITOR);
      WriteString('Plugin', 'WebViewModule', CPL_WEBVIEW);
      WriteToFile(FConfigFileName, '');
    end;

    { ��� �����(����) }
    if not SectionExists('SubMonitor') then
    begin
      WriteBool('SubMonitor', 'Enabled', False);
      WriteInteger('SubMonitor', 'Top', 0);
      WriteInteger('SubMonitor', 'Left', 1920);
      WriteInteger('SubMonitor', 'Width', 1920);
      WriteInteger('SubMonitor', 'Height', 1080);
      WriteToFile(FConfigFileName, '');
    end;

    { ������ ������ }
    if not SectionExists('ReceiptPrinter') then
    begin
      WriteBool('ReceiptPrinter', 'Enabled', False);
      WriteInteger('ReceiptPrinter', 'DeviceId', 0);
      WriteInteger('ReceiptPrinter', 'Copies', 1);
      WriteInteger('ReceiptPrinter', 'Port', 0);
      WriteInteger('ReceiptPrinter', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { ����IC ī�� ���� }
    if not SectionExists('CardReader') then
    begin
      WriteBool('CardReader', 'Enabled', False);
      WriteInteger('CardReader', 'DeviceId', 0);
      WriteInteger('CardReader', 'Port', 0);
      WriteInteger('CardReader', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { ���ڼ����е� }
    if not SectionExists('SignPad') then
    begin
      WriteBool('SignPad', 'Enabled', False);
      WriteInteger('SignPad', 'Port', 0);
      WriteInteger('SignPad', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { ����� RFID/NFC ���� }
    if not SectionExists('RFIDReader') then
    begin
      WriteBool('RFIDReader', 'Enabled', False);
      WriteInteger('RFIDReader', 'DeviceId', 0);
      WriteInteger('RFIDReader', 'Port', 0);
      WriteInteger('RFIDReader', 'Baudrate', 115200);
      WriteToFile(FConfigFileName, '');
    end;

    { ����ī�� RFID ���� }
    if not SectionExists('WelfareCardReader') then
    begin
      WriteBool('WelfareCardReader', 'Enabled', False);
      WriteInteger('WelfareCardReader', 'DeviceId', 0);
      WriteInteger('WelfareCardReader', 'Port', 0);
      WriteInteger('WelfareCardReader', 'Baudrate', 9600);
      WriteToFile(FConfigFileName, '');
    end;

    { ���ڵ� ��ĳ�� }
    if not SectionExists('BarcodeScanner') then
    begin
      WriteBool('BarcodeScanner', 'Enabled', False);
      WriteInteger('BarcodeScanner', 'Port', 0);
      WriteInteger('BarcodeScanner', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { ���� �νı� }
    if not SectionExists('FingerPrintScanner') then
    begin
      WriteBool('FingerPrintScanner', 'Enabled', False);
      WriteInteger('FingerPrintScanner', 'DeviceType', CFT_UC);
      WriteBool('FingerPrintScanner', 'AutoDetect', False);
      WriteInteger('FingerPrintScanner', 'EnrollQuality', GSD_FIR_ENROLL_QUALITY);
      WriteInteger('FingerPrintScanner', 'IdentifyQuality', GSD_FIR_IDENTIFY_QUALITY);
      WriteInteger('FingerPrintScanner', 'VerifyQuality', GSD_FIR_VERIFY_QUALITY);
      WriteInteger('FingerPrintScanner', 'SecurityLevel', GSD_FIR_SECURITY_LEVEL);
      WriteInteger('FingerPrintScanner', 'DefaultTimeout', GSD_FIR_DEFAULT_TIMEOUT);
      WriteToFile(FConfigFileName, '');
    end;

    { ��ǥ�ô� }
    if not SectionExists('VFD') then
    begin
      WriteBool('VFD', 'Enabled', False);
      WriteInteger('VFD', 'DeviceId', 0);
      WriteInteger('VFD', 'Port', 0);
      WriteInteger('VFD', 'Baudrate', 9600);
      WriteToFile(FConfigFileName, '');
    end;

    { ����Ŭ�� }
    if not SectionExists('WelbeingClub') then
    begin
      WriteBool('WelbeingClub', 'Enabled', False);
      WriteString('WelbeingClub', 'PartnerCode', GCD_WBCLUB_CODE);
      WriteString('WelbeingClub', 'Host', '');
      WriteString('WelbeingClub', 'ApiToken', '');
      WriteString('WelbeingClub', 'StoreCode', '');
      WriteBool('WelbeingClub', 'SelectEvent', False);
      WriteToFile(FConfigFileName, '');
    end;

    { ��������Ŭ�� }
    if not SectionExists('RefreshClub') then
    begin
      WriteBool('RefreshClub', 'Enabled', False);
      WriteString('RefreshClub', 'PartnerCode', GCD_RFCLUB_CODE);
      WriteString('RefreshClub', 'Host', '');
      WriteString('RefreshClub', 'ApiToken', '');
      WriteString('RefreshClub', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { ������������ }
    if not SectionExists('RefreshGolf') then
    begin
      WriteBool('RefreshGolf', 'Enabled', False);
      WriteString('RefreshGolf', 'PartnerCode', GCD_RFGOLF_CODE);
      WriteString('RefreshGolf', 'Host', '');
      WriteString('RefreshGolf', 'ApiToken', '');
      WriteString('RefreshGolf', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { �������� }
    if not SectionExists('IKozen') then
    begin
      WriteBool('IKozen', 'Enabled', False);
      WriteString('IKozen', 'PartnerCode', GCD_IKOZEN_CODE);
      WriteString('IKozen', 'Host', '');
      WriteString('IKozen', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { ������������ }
    if not SectionExists('RoungeMembers') then
    begin
      WriteBool('RoungeMembers', 'Enabled', False);
      WriteString('RoungeMembers', 'Host', GCD_TRMEMBERS_HOST);
      WriteString('RoungeMembers', 'StoreCode', '');
      WriteString('RoungeMembers', 'Password', '');
      WriteToFile(FConfigFileName, '');
    end;

    { ����ƽ�� }
    if not SectionExists('Smartix') then
    begin
      WriteBool('Smartix', 'Enabled', False);
      WriteString('Smartix', 'PartnerCode', GCD_SMARTIX_CODE);
      WriteString('Smartix', 'Host', '');
      WriteToFile(FConfigFileName, '');
    end;

    { ����Ʈ�� �����м��� }
    if not SectionExists('Spectrum') then
    begin
      WriteString('Spectrum', 'MonitorUrl', 'http://site0000.iptime.org:8080/ABSystem/interfaceIMRhst.jsp');
    end;
  end;
end;

procedure TGlobal.ReadConfig;
begin
  //================================================================================================
  // �ý��� ȯ�� ����
  //================================================================================================
  with FConfig do
  begin
    { �Ϲ� ���� }
    FConfigUpdated := ReadString('Config', 'LastUpdated', '');
    FHideTaskBar := ReadBool('Config', 'HideTaskBar', False);
    FHideCursor := ReadBool('Config', 'HideCursor', False);
    ScreenInfo.BaseWidth := ReadInteger('Config', 'BaseWidth', 1366);
    ScreenInfo.BaseHeight := ReadInteger('Config', 'BaseHeight', 768);

    FAutoRebootTime := ReadString('Config', 'AutoRebootTime', GSD_AUTO_REBOOT_TIME);

    { VAN ���� }
    VanModule.VanCode := ReadString('StoreInfo', 'VanCode', 'KCP');
    VanModule.ApplyConfigAll;

    { Ÿ����AD }
    TeeBoxADInfo.Enabled := ReadBool('TeeBoxAD', 'Enabled', False);
    //TeeBoxADInfo.Host    := ReadString('TeeBoxAD', 'Host', CCD_TEEBOX_HOST);
    TeeBoxADInfo.Host    := '192.168.0.212';
    TeeBoxADInfo.DBPort  := ReadInteger('TeeBoxAD', 'DBPort', CCD_TEEBOX_DB_PORT);
    TeeBoxADInfo.DBUser  := CCD_TEEBOX_USER;
    TeeBoxADInfo.DBPwd   := CCD_TEEBOX_PWD;
    TeeBoxADInfo.DBTimeout := GSD_MYSQL_DEFAULT_TIMEOUT;
    TeeBoxADInfo.APIPort := ReadInteger('TeeBoxAD', 'APIPort', CCD_TEEBOX_API_PORT);
    TeeBoxADInfo.APITimeout := ReadInteger('TeeBoxAD', 'Timeout', GSD_TCP_DEFAULT_TIMEOUT);

//    { ��Ʈ�ʼ��� }
//    BackOfficeUrl := ReadString('BackOffice', 'Host', GCD_BACKOFFICE_HOST);

    { �������� ���� }
    ParkingServer.Vendor := ReadInteger('ParkingServer', 'Vendor', 0); //0:������ũ�н�
    ParkingServer.Enabled := ReadBool('ParkingServer', 'Enabled', False);
    ParkingServer.Host := ReadString('ParkingServer', 'Host', '127.0.0.1');
    ParkingServer.Database := ReadString('ParkingServer', 'Database', '');
    ParkingServer.CharSet := ReadString('ParkingServer', 'CharSet', 'utf8');
    ParkingServer.DBPort := ReadInteger('ParkingServer', 'Port', 0);
    ParkingServer.DBUser := ReadString('ParkingServer', 'UserId', '');
    ParkingServer.DBPwd := StrDecrypt(ReadString('ParkingServer', 'Password', ''));
    ParkingServer.DBTimeout := ReadInteger('ParkingServer', 'Timeout', GSD_MYSQL_DEFAULT_TIMEOUT);
    ParkingServer.BaseHours := ReadInteger('ParkingServer', 'BaseHours', 3);

    { �÷����� }
    PluginConfig.StartModule := ReadString('Plugin', 'StartModule', CPL_START);
    PluginConfig.SubMonitorModule := ReadString('Plugin', 'SubMonitorModule', CPL_SUB_MONITOR);
    PluginConfig.WebViewModule := ReadString('Plugin', 'WebViewModule', CPL_WEBVIEW);

    { ��� �����(����) }
    SubMonitor.Enabled := ReadBool('SubMonitor', 'Enabled', False);
    SubMonitor.Top := ReadInteger('SubMonitor', 'Top', 0);
    SubMonitor.Left := ReadInteger('SubMonitor', 'Left', 1366);
    SubMonitor.Width := ReadInteger('SubMonitor', 'Width', 1920);
    SubMonitor.Height := ReadInteger('SubMonitor', 'Height', 1080);

    { ������ ������ }
    DeviceConfig.ReceiptPrinter.Enabled := ReadBool('ReceiptPrinter', 'Enabled', False);
    DeviceConfig.ReceiptPrinter.DeviceId := ReadInteger('ReceiptPrinter', 'DeviceId', 0);
    DeviceConfig.ReceiptPrinter.Copies := ReadInteger('ReceiptPrinter', 'Copies', 1);
    DeviceConfig.ReceiptPrinter.Port := ReadInteger('ReceiptPrinter', 'Port', 0);
    DeviceConfig.ReceiptPrinter.Baudrate := ReadInteger('ReceiptPrinter', 'Baudrate', 9600);

    { ����IC ī�� ���� }
    DeviceConfig.ICCardReader.Enabled := ReadBool('CardReader', 'Enabled', False);
    DeviceConfig.ICCardReader.DeviceId := ReadInteger('CardReader', 'DeviceId', 0);
    DeviceConfig.ICCardReader.Port := ReadInteger('CardReader', 'Port', 0);
    DeviceConfig.ICCardReader.Baudrate := ReadInteger('CardReader', 'Baudrate', 9600);

    { ���ڼ����е� }
    DeviceConfig.SignPad.Enabled := ReadBool('SignPad', 'Enabled', False);
    DeviceConfig.SignPad.Port := ReadInteger('SignPad', 'Port', 0);
    DeviceConfig.SignPad.Baudrate := ReadInteger('SignPad', 'Baudrate', 9600);

    { �����ī�� RFID/NFC ���� }
    DeviceConfig.RFIDReader.Enabled := ReadBool('RFIDReader', 'Enabled', False);
    DeviceConfig.RFIDReader.DeviceId := ReadInteger('RFIDReader', 'DeviceId', 0);
    DeviceConfig.RFIDReader.Port := ReadInteger('RFIDReader', 'Port', 0);
    DeviceConfig.RFIDReader.Baudrate := ReadInteger('RFIDReader', 'Baudrate', 115200);

    { ����ī�� RFID ���� }
    DeviceConfig.WelfareCardReader.Enabled := ReadBool('WelfareCardReader', 'Enabled', False);
    DeviceConfig.WelfareCardReader.DeviceId := ReadInteger('WelfareCardReader', 'DeviceId', 0);
    DeviceConfig.WelfareCardReader.Port := ReadInteger('WelfareCardReader', 'Port', 0);
    DeviceConfig.WelfareCardReader.Baudrate := ReadInteger('WelfareCardReader', 'Baudrate', 9600);

    { ���ڵ� ��ĳ�� }
    DeviceConfig.BarcodeScanner.Enabled := ReadBool('BarcodeScanner', 'Enabled', False);
    DeviceConfig.BarcodeScanner.Port := ReadInteger('BarcodeScanner', 'Port', 0);
    DeviceConfig.BarcodeScanner.Baudrate := ReadInteger('BarcodeScanner', 'Baudrate', 9600);

    { ���� �νı� }
    DeviceConfig.FingerPrintScanner.Enabled := ReadBool('FingerPrintScanner', 'Enabled', False);
    DeviceConfig.FingerPrintScanner.DeviceType := ReadInteger('FingerPrintScanner', 'DeviceType', CFT_NITGEN);
    DeviceConfig.FingerPrintScanner.AutoDetect := ReadBool('FingerPrintScanner', 'AutoDetect', False);
    DeviceConfig.FingerPrintScanner.EnrollQuality := ReadInteger('FingerPrintScanner', 'EnrollQuality', GSD_FIR_ENROLL_QUALITY);
    DeviceConfig.FingerPrintScanner.IdentifyQuality := ReadInteger('FingerPrintScanner', 'IdentifyQuality', GSD_FIR_IDENTIFY_QUALITY);
    DeviceConfig.FingerPrintScanner.VerifyQuality := ReadInteger('FingerPrintScanner', 'VerifyQuality', GSD_FIR_VERIFY_QUALITY);
    DeviceConfig.FingerPrintScanner.SecurityLevel := ReadInteger('FingerPrintScanner', 'SecurityLevel', GSD_FIR_SECURITY_LEVEL);
    DeviceConfig.FingerPrintScanner.DefaultTimeout := ReadInteger('FingerPrintScanner', 'DefaultTimeout', GSD_FIR_DEFAULT_TIMEOUT);

    { ����Ŭ�� }
    WelbeingClub.Enabled := ReadBool('WelbeingClub', 'Enabled', False);
    WelbeingClub.PartnerCode := ReadString('WelbeingClub', 'PartnerCode', GCD_WBCLUB_CODE);
    WelbeingClub.Host := ReadString('WelbeingClub', 'Host', GCD_WBCLUB_HOST);
    WelbeingClub.ApiToken := ReadString('WelbeingClub', 'ApiToken', '');
    WelbeingClub.StoreCode := ReadString('WelbeingClub', 'StoreCode', '');
    WelbeingClub.SelectEvent := ReadBool('WelbeingClub', 'SelectEvent', False);

    { ��������Ŭ�� }
    RefreshClub.Enabled := ReadBool('RefreshClub', 'Enabled', False);
    RefreshClub.PartnerCode := ReadString('RefreshClub', 'PartnerCode', GCD_RFCLUB_CODE);
    RefreshClub.Host := ReadString('RefreshClub', 'Host', GCD_RFCLUB_HOST);
    RefreshClub.ApiToken := ReadString('RefreshClub', 'ApiToken', '');
    RefreshClub.StoreCode := ReadString('RefreshClub', 'StoreCode', '');

    { ������������ }
    RefreshGolf.Enabled := ReadBool('RefreshGolf', 'Enabled', False);
    RefreshGolf.PartnerCode := ReadString('RefreshGolf', 'PartnerCode', GCD_RFGOLF_CODE);
    RefreshGolf.Host := ReadString('RefreshGolf', 'Host', GCD_RFGOLF_HOST);
    RefreshGolf.ApiToken := ReadString('RefreshGolf', 'ApiToken', '');
    RefreshGolf.StoreCode := ReadString('RefreshGolf', 'StoreCode', '');

    { �������� }
    IKozen.Enabled := ReadBool('IKozen', 'Enabled', False);
    IKozen.PartnerCode := ReadString('IKozen', 'PartnerCode', GCD_IKOZEN_CODE);
    IKozen.Host := ReadString('IKozen', 'Host', '');
    IKozen.StoreCode := ReadString('IKozen', 'StoreCode', '');

    { ������������ }
    RoungeMembers.Enabled := ReadBool('RoungeMembers', 'Enabled', False);
    RoungeMembers.Host := ReadString('RoungeMembers', 'Host', GCD_TRMEMBERS_HOST);
    RoungeMembers.StoreCode := ReadString('RoungeMembers', 'StoreCode', '');
    RoungeMembers.Password := StrDecrypt(ReadString('RoungeMembers', 'Password', ''));

    { ����ƽ�� }
    Smartix.Enabled := ReadBool('Smartix', 'Enabled', False);
    Smartix.PartnerCode := ReadString('Smartix', 'PartnerCode', GCD_SMARTIX_CODE);
    Smartix.Host := ReadString('Smartix', 'Host', '');
    Smartix.clientCompSeq := ReadString('Smartix', 'clientCompSeq', '');
  end;
end;


procedure TGlobal.CheckConfigLocal;
var
  nCopies: Integer;
begin
  //================================================================================================
  // ���� ȯ�� ����
  //================================================================================================
  with FConfigLocal do
  begin
    { Ŭ���̾�Ʈ ���� }
    if not SectionExists('Client') then
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', '');
      WriteString('Client', 'SecretKey', '');
      WriteToFile(FConfigLocalFileName, '');
    end;

    { �Ϲ� ���� }
    if not SectionExists('Config') then
    begin
      //WriteBool('Config', 'EmergencyMode', False);
      WriteInteger('Config', 'PrepareMin', 5);
      WriteInteger('Config', 'GameOverAlarmMin', GCD_GAMEOVER_ALARM_MIN);
      WriteBool('Config', 'IsSimpleMember', False);
      WriteBool('Config', 'ImmediateTeeBoxAssign', True);
      WriteBool('Config', 'TeeBoxChangedReIssue', True);
      WriteBool('Config', 'TeeBoxQuickView', False);
      WriteInteger('Config', 'TeeBoxQuickViewMode', CQM_HORIZONTAL);
      WriteBool('Config', 'TeeBoxForceAssign', False);
      WriteBool('Config', 'TeeBoxForceAssignOnError', False);
      WriteBool('Config', 'SelfCashReceiptDefault', False);
      WriteBool('Config', 'ReserveAllowedOnOrderTime', False);
      WriteBool('Config', 'HoldAllowedOnLeftClick', False);
      WriteBool('Config', 'AutoRunAdminCall', False);
      WriteString('Config', 'LastNoticeDate', '');
      WriteInteger('Config', 'TeeBoxFontSizeAdjust', 0);
      WriteBool('Config', 'UseTeeBoxTeleReserved', False);
      WriteBool('Config', 'UseWebCamMirror', False);
      WriteBool('Config', 'UseFingerPrintMirror', False);
      WriteBool('Config', 'UseLessonReceipt', False);
      WriteBool('Config', 'LogDelete', True);
      WriteInteger('Config', 'LogDeleteDays', 30);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { ����� ���� }
    if not SectionExists('UserInfo') then
    begin
      WriteBool('UserInfo', 'SaveInfo', False);
      WriteString('UserInfo', 'UserId', '');
      WriteString('UserInfo', 'Password', '');
      WriteToFile(FConfigLocalFileName, '');
    end;

    { Ÿ��������Ȳ�� }
    if not SectionExists('Scoreboard') then
    begin
      WriteInteger('Scoreboard', 'BackgroundColor', GCR_COLOR_BACK_PANEL);
      WriteBool('Scoreboard', 'ShowErrorStatus', True);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { ������ ��� ���� }
    if not SectionExists('Printout') then
    begin
      nCopies := FConfig.ReadInteger('ReceiptPrinter', 'Copies', 1);
      WriteInteger('Printout', 'ReceiptCopies', nCopies);
      WriteInteger('Printout', 'TeeBoxTicketCopies', 1);
      WriteBool('Printout', 'ReceiptPreview', False);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { �δ�ü� �̿�� ���� ���� }
    if not SectionExists('AddonTicket') then
    begin
      WriteBool('AddonTicket', 'ParkingTicket', False);
      WriteBool('AddonTicket', 'SaunaTicket', False);
      WriteInteger('AddonTicket', 'SaunaTicketKind', 0);
      WriteBool('AddonTicket', 'FitnessTicket', False);
      WriteBool('AddonTicket', 'PrintAlldayPass', True);
      WriteBool('AddonTicket', 'PrintWithAssignTicket', False );
      WriteToFile(FConfigLocalFileName, '');
    end;

    { ���� �� ������ }
    if not SectionExists('WebView') then
    begin
      WriteInteger('WebView', 'Top', 0);
      WriteInteger('WebView', 'Left', 0);
      WriteInteger('WebView', 'Width', 0);
      WriteInteger('WebView', 'Height', 0);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { ��/��ǳ�� }
    if not SectionExists('AirConditioner') then
    begin
      WriteBool('AirConditioner', 'Enabled', False);
      WriteInteger('AirConditioner', 'OnOffMode', 0); //0:Auto On/Off, 1:Manual-Control
      WriteInteger('AirConditioner', 'BaseMinutes', 70);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { �����Ĵ� ���� �Ĵ� ���� }
    if not SectionExists('MealInfo') then
    begin
      WriteString('MealInfo', 'MealCode', '');
      WriteString('MealInfo', 'MealName', '');
      WriteInteger('MealInfo', 'MealPrice', 0);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { ���� ���� ���� }
    if not SectionExists('Weather') then
    begin
      //37.33,  126.59  : ������ ������ �߽���
      //37.568, 126.978 : OpenWeatherMap.org�� Seoul City �˻� ��ġ
      WriteString('Weather', 'Host', 'https://api.openweathermap.org/data/3.0/');
      WriteString('Weather', 'Latitude', '37.568');
      WriteString('Weather', 'Longitude', '126.978');
      WriteString('Weather', 'ApiKey', '');
      WriteToFile(FConfigLocalFileName, '');
    end;

    if Modified then
      UpdateFile;
  end;
end;

procedure TGlobal.ReadConfigLocal;
begin
  //================================================================================================
  // ���� ȯ�� ����
  //================================================================================================
  with FConfigLocal do
  begin
    { Ŭ���̾�Ʈ ���� }
    if FClientConfig.UseLocalSetting then
    begin
      FClientConfig.ClientId := ReadString('Client', 'ClientId', '');
      FClientConfig.Host := ReadString('Client', 'Host', '');
      FClientConfig.SecretKey := StrDecrypt(ReadString('Client', 'SecretKey', ''));
    end;

    { ���� � ��å }
    FPrepareMin := ReadInteger('Config', 'PrepareMin', 5);
    FGameOverAlarmMin := ReadInteger('Config', 'GameOverAlarmMin', GCD_GAMEOVER_ALARM_MIN);
    FImmediateTeeBoxAssign := ReadBool('Config', 'ImmediateTeeBoxAssign', True);
    FTeeBoxChangedReIssue := ReadBool('Config', 'TeeBoxChangedReIssue', True);
    FTeeBoxQuickView := ReadBool('Config', 'TeeBoxQuickView', False);
    FTeeBoxQuickViewMode := ReadInteger('Config', 'TeeBoxQuickViewMode', CQM_HORIZONTAL);
    FTeeBoxForceAssign := ReadBool('Config', 'TeeBoxForceAssign', False);
    FTeeBoxForceAssignOnError := ReadBool('Config', 'TeeBoxForceAssignOnError', False);
    FIsSimpleMember := ReadBool('Config', 'IsSimpleMember', False);
    FSelfCashReceiptDefault := ReadBool('Config', 'SelfCashReceiptDefault', False);
    FReserveAllowedOnOrderTime := ReadBool('Config', 'ReserveAllowedOnOrderTime', False);
    FHoldAllowedOnLeftClick := ReadBool('Config', 'HoldAllowedOnLeftClick', False);
    FAutoRunAdminCall := ReadBool('Config', 'AutoRunAdminCall', False);
    FLastNoticeDate := ReadString('Config', 'LastNoticeDate', '');
    FTeeBoxFontSizeAdjust := ReadInteger('Config', 'TeeBoxFontSizeAdjust', 0);
    FUseTeeBoxTeleReserved := ReadBool('Config', 'UseTeeBoxTeleReserved', False);
    FUseWebCamMirror := ReadBool('Config', 'UseWebCamMirror', False);
    FUseFingerPrintMirror := ReadBool('Config', 'UseFingerPrintMirror', False);
    FUseLessonReceipt := ReadBool('Config', 'UseLessonReceipt', False);
    FLogDelete := ReadBool('Config', 'LogDelete', True);
    FLogDeleteDays := ReadInteger('Config', 'LogDeleteDays', 30);

    { Ÿ��������Ȳ�� }
    SubMonitor.BackgroundColor := ReadInteger('Scoreboard', 'BackgroundColor', GCR_COLOR_BACK_PANEL);
    SubMonitor.ShowErrorStatus := ReadBool('Scoreboard', 'ShowErrorStatus', True);

    { ������ ��� ���� }
    FReceiptCopies := ReadInteger('Printout', 'ReceiptCopies', 1);
    FTeeBoxTicketCopies := ReadInteger('Printout', 'TeeBoxTicketCopies', 1);
    FReceiptPreview := ReadBool('Printout', 'ReceiptPreview', False);

    { �δ�ü� �̿�� ���� ���� }
    AddonTicket.ParkingTicket := ReadBool('AddonTicket', 'ParkingTicket', False);
    AddonTicket.SaunaTicket := ReadBool('AddonTicket', 'SaunaTicket', False);
    AddonTicket.SaunaTicketKind := ReadInteger('AddonTicket', 'SaunaTicketKind', 0);
    AddonTicket.FitnessTicket := ReadBool('AddonTicket', 'FitnessTicket', False);
    AddonTicket.PrintAlldayPass := ReadBool('AddonTicket', 'PrintAlldayPass', True);
    AddonTicket.PrintWithAssignTicket := ReadBool('AddonTicket', 'PrintWithAssignTicket', False);

    { ���� �� ������ }

    { ��/��ǳ�� }
    AirConditioner.Active := False;
    AirConditioner.Enabled := ReadBool('AirConditioner', 'Enabled', False);
    AirConditioner.OnOffMode := ReadInteger('AirConditioner', 'OnOffMode', 0);
    AirConditioner.BaseMinutes := ReadInteger('AirConditioner', 'BaseMinutes', 70);

    { �����Ĵ� ���� �Ĵ� ���� }

    { ���̺�/�� ���� ���� }

    { ���� ���� ���� }
    WeatherInfo.Host := ReadString('Weather', 'Host', '');
    WeatherInfo.Latitude := ReadString('Weather', 'Latitude', '');
    WeatherInfo.Longitude := ReadString('Weather', 'Longitude', '');
    WeatherInfo.ApiKey := StrDecrypt(ReadString('Weather', 'ApiKey', ''));
    WeatherInfo.Enabled := not (WeatherInfo.Host.IsEmpty or WeatherInfo.Latitude.IsEmpty or WeatherInfo.Longitude.IsEmpty or WeatherInfo.ApiKey.IsEmpty);
  end;
end;

procedure TGlobal.CheckConfigTable;
begin
  { ���̺�/�� ���� ���� }
  with FConfigTable do
  begin
    if not SectionExists('Config') then
    begin
      WriteString('Config', 'UnitName', '���̺�/��');
    end;

    if Modified then
      UpdateFile;
  end;
end;

procedure TGlobal.ReadConfigTable;
begin
  { ���̺�/�� ���� ���� }
  with FConfigTable do
  begin
    TableInfo.UnitName := ReadString('Config', 'UnitName', '���̺�/��');
    if TableInfo.UnitName.IsEmpty then
      TableInfo.UnitName := '���̺�';
  end;
end;

procedure TGlobal.ResetLogFile;
begin
  FLogFile := Format(FLogDir + FAppName + '_%s.log', [FCurrentDate]);
  FElapTimeFile := Format(FLogDir + 'ElapTime_%s.log', [FCurrentDate]);
  FPayLogFile := Format(FLogDir + 'payment_%s.log', [FCurrentDate]);
end;

procedure TGlobal.DoDeleteLog;
var
  SR: TSearchRec;
  bFound: Boolean;
  sBaseDate, sLogDate: string;
  nPos, nYear: Integer;
begin
  if LogDeleting then
    Exit;

  try
    LogDeleting := True;
    { ���α׷� �α� ���� }
    sBaseDate := FormatDateTime('yyyymmdd', IncDay(Now, -Global.LogDeleteDays));
    nPos := Length(AppName) + 2; //XGPOS_yyyymmdd.log
    bFound := (FindFirst(LogDir + AppName + '_*.log', faAnyFile - faDirectory, SR) = 0);
    while bFound do
    begin
      sLogDate := Copy(SR.Name, nPos, 8);
      if (sLogDate >= '20000101') and (sLogDate <= sBaseDate) then
        System.SysUtils.DeleteFile(LogDir + SR.Name);
      bFound := (FindNext(SR) = 0);
    end;

    { ���� �α� ���� (nYear�� �� �͸�) }
    nYear := 1;
    sBaseDate := FormatDateTime('yyyymmdd', IncYear(Now, -nYear));
    nPos := 9;
    bFound := (FindFirst(LogDir + 'payment_*.log', faAnyFile - faDirectory, SR) = 0);
    while bFound do
    begin
      sLogDate := Copy(SR.Name, nPos, 8);
      if (sLogDate >= '20000101') and (sLogDate <= sBaseDate) then
        System.SysUtils.DeleteFile(LogDir + SR.Name);
      bFound := (FindNext(SR) = 0);
    end;
  finally
    System.SysUtils.FindClose(SR);
    LogDeleted := True;
    LogDeleting := False;
  end;
end;

procedure TGlobal.SetConfigUpdated(const AValue: string);
begin
  if (ConfigUpdated <> AValue) then
  begin
    FConfigUpdated := AValue;
    FConfig.WriteString('Config', 'LastUpdated', FConfigUpdated);
  end;
end;

procedure TGlobal.BarcodeScannerClose;
begin
  with DeviceConfig.BarcodeScanner do
  if Enabled and
     Assigned(ComDevice) then
  try
    ComDevice.Close;
  except
  end;
end;

procedure TGlobal.BarcodeScannerOpen;
begin
  with DeviceConfig.BarcodeScanner do
  if Enabled and
     Assigned(ComDevice) then
  try
    ReadData := '';
    ComDevice.Close;
    if (Port >= 10) then
      ComDevice.DeviceName := '\\.\COM' + IntToStr(Port)
    else
      ComDevice.DeviceName := 'COM' + IntToStr(Port);
    ComDevice.BaudRate := GetBaudRate(Baudrate);
    ComDevice.Parity := TParity.paNone;
    ComDevice.DataBits := TDataBits.db8;
    ComDevice.StopBits := TStopBits.sb1;
    ComDevice.OnRxChar := ComPortRxCharBarcodeScanner;
    ComDevice.Open;
  except
  end;
end;

{ ���ڵ� ��ĳ�� }
procedure TGlobal.ComPortRxCharBarcodeScanner(Sender: TObject);
var
  PM: TPluginMessage;
  sBuffer, sReadData: string;
  nBuffer: Integer;
begin
  with TComPort(Sender) do
  begin
    sBuffer := ReadAnsiString;
    nBuffer := Length(sBuffer);
    if (nBuffer = 0) then
      Exit;

    Global.DeviceConfig.BarcodeScanner.ReadData := Global.DeviceConfig.BarcodeScanner.ReadData + sBuffer;
    if (sBuffer[nBuffer] = _CR) then
    begin
      sReadData := StringReplace(Global.DeviceConfig.BarcodeScanner.ReadData, _CR, '', [rfReplaceAll]);
      Global.DeviceConfig.BarcodeScanner.ReadData := '';
      UpdateLog(Global.LogFile, Format('���ڵ� ��ĵ : %s', [sReadData]));

      { PAYCO ���� ���� }
      if SaleManager.ReceiptInfo.PaycoReady then
      begin
        PaycoModule.SetBarcode(sReadData);
        Exit;
      end;

      { PAYCO ���ڵ带 ������ �͵� }
      PM := TPluginMessage.Create(nil);
      try
        { XGOLF ȸ�� QR �ڵ� }
        if (Copy(sReadData, 1, 2) = CQT_HEAD_XGOLF) then
        begin
          sReadData := StringReplace(sReadData, CQT_HEAD_XGOLF, '', [rfReplaceAll]);
          PM.Command := CPC_SEND_QRCODE_XGOLF;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { ������ȸ�� QR�ڵ� : ù ���ڰ� '1'�̰� �� 10�ڸ��� ������ ���ڿ� }
        else if (Copy(sReadData, 1, 1) = CQT_HEAD_MEMBER) and
                (sReadData.Length = 10) and
                (StrToIntDef(sReadData, 0) > 0) then
        begin
          PM.Command := CPC_SEND_QRCODE_MEMBER;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { ���θ�� �������� QR�ڵ� }
        else if (Copy(sReadData, 1, 2) = CQT_HEAD_COUPON) then
        begin
          PM.Command := CPC_SEND_QRCODE_COUPON;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { ������ ���ڵ� }
        else if (Copy(sReadData, 1, 5) = SaleManager.StoreInfo.StoreCode) then
        begin
          PM.Command := CPC_SEND_RECEIPT_NO;
          PM.AddParams(CPP_RECEIPT_NO, sReadData);
        end else
        begin
          PM.Command := CPC_SEND_SCAN_DATA; //���޻� ȸ�� ī���ȣ, ��Ÿ ���ڵ� ��
          PM.AddParams(CPP_BARCODE, sReadData);
        end;

        PM.PluginMessageToID(Global.DeviceConfig.BarcodeScanner.OwnerId);
      finally
        FreeAndNil(PM);
      end;
    end;
  end;
end;

{ RFID/NFC UID(Hexa Decimal Format String) }
procedure TGlobal.ComPortRxCharRFIDReader(Sender: TObject);
var
  PM: TPluginMessage;
  sBuffer: AnsiString;
  sReadData: string;
  nBuffer: Integer;
begin
  with TComPort(Sender) do
  begin
    sBuffer := ReadAnsiString;
    nBuffer := Length(sBuffer);
    if (nBuffer = 0) then
      Exit;

    Global.DeviceConfig.RFIDReader.ReadData := Global.DeviceConfig.RFIDReader.ReadData + sBuffer;
    if (sBuffer[nBuffer] = _CR) then
    begin
      sReadData := StringToHex(Copy(Global.DeviceConfig.RFIDReader.ReadData, 1, Pred(nBuffer)));
      Global.DeviceConfig.RFIDReader.ReadData := '';
      //UpdateLog(Global.LogFile, Format('����� RFID/NFC : %s', [sReadData]));
      if (Length(sReadData) = 8) then //ex) 88043595, C1E3352C
      begin
        PM := TPluginMessage.Create(nil);
        try
          PM.Command := CPC_SEND_RFID_DATA;
          PM.AddParams(CPP_MEMBER_CARD_UID, sReadData);
          PM.PluginMessageToID(Global.DeviceConfig.RFIDReader.OwnerId);
        finally
          FreeAndNil(PM);
        end;
      end;
    end;
  end;
end;

{ ����ī�� }
procedure TGlobal.ComPortRxCharWelfareCardReader(Sender: TObject);
var
  PM: TPluginMessage;
  sBuffer: AnsiString;
  sReadData: string;
  nBuffer, nPos1, nPos2: Integer;
begin
  with TComPort(Sender) do
  begin
    sBuffer := ReadAnsiString;
    nBuffer := Length(sBuffer);
    if (nBuffer = 0) then
      Exit;

    Global.DeviceConfig.WelfareCardReader.ReadData := Global.DeviceConfig.WelfareCardReader.ReadData + sBuffer;
    if (sBuffer[nBuffer] = _ETX) then
    begin
      sReadData := Global.DeviceConfig.WelfareCardReader.ReadData;
      Global.DeviceConfig.WelfareCardReader.ReadData := '';
      nPos1 := Pos(_STX, sReadData);
      nPos2 := Pos(_ETX, sReadData);
      if (nPos1 > 0) and (nPos2 > nPos1) then
      begin
        sReadData := RemoveSpecialChar(Copy(sReadData, nPos1 + 1, nPos2 - 2)); //s12345678e
//        UpdateLog(Global.LogFile, Format('����ī�� RFID : %s', [sReadData]));
        PM := TPluginMessage.Create(nil);
        try
          PM.Command := CPC_SEND_WELFARE_CODE;
          PM.AddParams(CPP_WELFARE_CODE, sReadData);
          PM.PluginMessageToID(Global.DeviceConfig.WelfareCardReader.OwnerId);
        finally
          FreeAndNil(PM);
        end;
      end;
    end;
  end;
end;

{ TClientConfig }

constructor TClientConfig.Create;
begin
  inherited;

end;

destructor TClientConfig.Destroy;
begin

  inherited;
end;

{ TPluginConfig }

constructor TPluginConfig.Create;
begin
  inherited;

end;

destructor TPluginConfig.Destroy;
begin

  inherited;
end;

{ TBaseDeviceConfig }

constructor TBaseDeviceConfig.Create;
begin
  inherited;

  ComDevice := TComPort.Create(nil);
  FReadData := '';
end;

destructor TBaseDeviceConfig.Destroy;
begin
  ComDevice.Close;
  ComDevice.Free;

  inherited;
end;

procedure TBaseDeviceConfig.SetOwnerId(const AValue: Integer);
begin
  if (FOwnerId <> AValue) then
  begin
    FReadData := '';
    FOwnerId := AValue;
  end;
end;

{ TPrinterConfig }

constructor TPrinterConfig.Create;
begin
  inherited;

end;

destructor TPrinterConfig.Destroy;
begin
  if Assigned(ComDevice) then
  begin
    ComDevice.Close;
    ComDevice.Free;
  end;

  inherited;
end;

(*
{ TWebCamConfig }

constructor TWebCamConfig.Create;
begin
  inherited;

  FEnabled := False;
  FMirror := False;
  FDeviceId := -1;
end;

destructor TWebCamConfig.Destroy;
begin

  inherited;
end;
*)

{ TDeviceConfig }

constructor TDeviceConfig.Create;
begin
  inherited;

  ReceiptPrinter := TPrinterConfig.Create;
  ICCardReader := TBaseDeviceConfig.Create;
  SignPad := TBaseDeviceConfig.Create;
  RFIDReader := TBaseDeviceConfig.Create;
  WelfareCardReader := TBaseDeviceConfig.Create;
  BarcodeScanner := TBaseDeviceConfig.Create;
  VFD := TBaseDeviceConfig.Create;
  FingerPrintScanner := TFingerPrintScanner.Create;
end;

destructor TDeviceConfig.Destroy;
begin
  ReceiptPrinter.Free;
  ICCardReader.Free;
  SignPad.Free;
  RFIDReader.Free;
  WelfareCardReader.Free;
  BarcodeScanner.Free;
  VFD.Free;
  FingerPrintScanner.Free;

  inherited;
end;

{ TSubMonitor }

constructor TSubMonitor.Create;
begin
  inherited;

  FEnabled := False;
  FTop := 0;
  FLeft := 1366;
  FWidth := 1920;
  FHeight := 1080;
  FBackgroundColor := GCR_COLOR_BACK_PANEL;
end;

destructor TSubMonitor.Destroy;
begin

  inherited;
end;

{ TFingerPrint }

constructor TFingerPrintScanner.Create;
begin
  inherited;

end;

destructor TFingerPrintScanner.Destroy;
begin

  inherited;
end;

{ TBaseTimerThread }

constructor TBaseTimerThread.Create;
begin
  inherited Create(True);

  FWorking := False;
  FInterval := 500;
  FLastWorked := Now - 1;
  FLastWorkedWeather := FLastWorked;
end;

destructor TBaseTimerThread.Destroy;
begin

  inherited;
end;

procedure TBaseTimerThread.Execute;
begin
  repeat
    if (not FWorking) and
       (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FWorking := True;
      FLastWorked := Now;
      try
        Synchronize(
          procedure
          var
            sDateTime, sCurrDate, sCurrTime: string;
          begin
            sDateTime := FormatDateTime('yyyymmddhhnnss', Now);
            sCurrDate := Copy(sDateTime, 1, 8);
            sCurrTime := Copy(sDateTime, 9, 6);

            if (Global.CurrentDate <> sCurrDate) then
            begin
              Global.LogDeleted := False;
              Global.CurrentDate := sCurrDate;
              Global.FormattedCurrentDate := FormattedDateString(sCurrDate);
              Global.CurrentDateTime := Global.CurrentDate + Global.CurrentTime;
              Global.FormattedCurrentDateTime := Global.FormattedCurrentDate + ' ' + Global.FormattedCurrentTime;
              Global.LastDate := FormatDateTime('yyyymmdd', Yesterday);
              Global.FormattedLastDate := FormattedDateString(Global.LastDate);
              Global.NextDate := FormatDateTime('yyyymmdd', Tomorrow);
              Global.FormattedNextDate := FormattedDateString(Global.NextDate);
              Global.DayOfWeekKR := DayOfWeekName(Now);
              Global.ResetLogFile;
            end;

            if (Global.CurrentTime <> sCurrTime) then
            begin
              Global.CurrentTime := sCurrTime;
              Global.FormattedCurrentTime := FormattedTimeString(sCurrTime);
              Global.CurrentDateTime := Global.CurrentDate + Global.CurrentTime;
              Global.FormattedCurrentDateTime := Global.FormattedCurrentDate + ' ' + Global.FormattedCurrentTime;

              if Global.LogDelete and
                 (not Global.LogDeleted) then
                Global.DoDeleteLog;
            end;

            if (not Global.CheckAutoReboot) and
               (not Global.IgnoreAutoReboot) and
               (Copy(Global.FormattedCurrentTime, 1, 5) = Global.AutoRebootTime) then
            begin
              Global.CheckAutoReboot := True;
              SendPluginCommand(CPC_REBOOT_SYSTEM, 0, Global.StartModuleId);
            end;

            if Global.WeatherInfo.Enabled and
               (MinutesBetween(FLastWorkedWeather, Now) >= 30) then
            begin
              FLastWorkedWeather := Now;
              ClientDM.GetWeatherInfo;
            end;
          end);
      finally
        FWorking := False;
      end;
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

{ TCouponRec }

procedure TCouponRec.Clear;
begin
  QrCode        := '';
  CouponName    := '';
  DcDiv         := '';
  DcCnt         := 0;
  ApplyDcAmt    := 0;
  MemberNo      := '';
  StartDay      := '';
  ExpireDay     := '';
  UseCnt        := 0;
  UsedCnt       := 0;
  EventName     := '';
  DcCondDiv     := '';
  ProductDiv    := '';
  TeeBoxProdDiv := '';
  UseYN         := '';
  UseStatus     := '';
end;

{ TChangeProdRec }

procedure TChangeProdRec.Clear;
begin
  OldPurchaseCode := '';
  ProductCode := '';
  ProductName := '';
  SaleAmt := 0;
  StartDate := '';
  EndDate := '';
  UseMonth := 0;
  CouponCount := 0;
end;

{ TLockerRec }

procedure TLockerRec.Clear;
begin
  LockerNo := 0;
  LockerName := '';
  FloorCode := '';
  ProductAmt := 0;
  KeepAmt := 0;
  UseStartDate := '';
  UseContinue := False;
end;

{ TAffiliateRec }

procedure TAffiliateRec.Clear;
begin
  Applied := False;
  PartnerCode := '';
  PartnerName := '';
  MemberCode := '';
  MemberName := '';
  MemberTelNo := '';
  ReadData := '';
  IKozenExecId := '';
  IKozenExecTime := '';
  ApprovalAmt := 0;
end;

{ TMemberRec }

procedure TMemberRec.Clear;
begin
  MemberSeq := 0;
  MemberName := '';
  MemberNo := '';
  BirthDate := '';
  SexDiv := '';
  HpNo := '';
  CarNo := '';
  Email := '';
  MemberCardUId := '';
  XGolfNo := '';
  WelfareCode := '';
  ZipNo := '';
  Address1 := '';
  Address2 := '';
  QrCode := '';
  CustomerCode := '';
  GroupCode := '';
  EmployeeNo := '';
  SpecialYN := False;
  SpectrumIntfYN := False;
  SpectrumCustId := '';
  Memo := '';
  FingerPrint1 := '';
  FingerPrint2 := '';
end;

{ TTableInfo }

function TTableInfo.Count: Integer;
begin
  Result := Length(Items);
end;

function TTableInfo.GetTableIndex(const ATableNo: Integer): Integer;
begin
  Result := 0;
  for var I := 0 to Pred(Count) do
    if (Items[I].TableNo = ATableNo) then
    begin
      Result := I;
      Break;
    end;
end;

procedure TTableInfo.Reset;
begin
  FActiveTableNo := 0;
  FActiveTableIndex := 0;
  SetLength(Items, 1);
  Items[FActiveTableIndex].TableNo := FActiveTableNo;
  Items[FActiveTableIndex].TableName := '';
  if not Assigned(ActiveGroupTableList) then
  begin
    ActiveGroupTableList := TStringList.Create;
    ActiveGroupTableList.StrictDelimiter := True;
    ActiveGroupTableList.Delimiter := ',';
  end;
  ActiveGroupTableList.Clear;
end;

procedure TTableInfo.SetActiveTableNo(const ATableNo: Integer);
var
  PM: TPluginMessage;
begin
  if (FActiveTableNo <> ATableNo) then
  begin
    FActiveTableNo := ATableNo;
    if (FActiveTableNo = 0) then
      FActiveTableIndex := 0
    else
      for var I := 1 to Pred(Count) do
        if (Items[I].TableNo = FActiveTableNo) then
        begin
          FActiveTableIndex := I;
          Break;
        end;

    ClientDM.RefreshActiveGroupTableList(FActiveTableNo);
    ClientDM.RefreshSaleTables(FActiveTableNo, DelimitedGroupTableList);

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_ACTIVE_TABLE;
      PM.AddParams(CPP_TABLE_INDEX, ActiveTableIndex);
      PM.PluginMessageToID(Global.SaleFormId);
      PM.PluginMessageToID(Global.SaleTableFormId);
    finally
      FreeAndNil(PM);
    end;
  end;
end;

function TTableInfo.GetDelimitedGroupTableList: string;
begin
  Result := ActiveGroupTableList.DelimitedText;
end;

{ TNoShowInfo }

constructor TNoShowInfo.Create;
begin
  inherited;

end;

destructor TNoShowInfo.Destroy;
begin
  FNoShowReserved := False;
  Clear;

  inherited;
end;

procedure TNoShowInfo.SetNoShowReserved(const AValue: Boolean);
begin
  if (AValue <> FNoShowReserved) then
  begin
    FNoShowReserved := AValue;
    if not FNoShowReserved then
      Clear;
  end;
end;

procedure TNoShowInfo.Clear;
begin
  FNoShowReserveNo := '';
  FTeeBoxNo := 0;
  FPrepareMin := 0;
  FAssignMin := 0;
  FAssignBalls := 0;
  FReserveDateTime := '';
//  FNewProductCode := '';
//  FNewProductDiv := '';
//  FNewProductName := '';
end;

{ TCheckinList }

constructor TCheckinList.Create;
begin

end;

destructor TCheckinList.Destroy;
begin
  Clear;

  inherited;
end;

function TCheckinList.AddItem(const AReserveNo: string; const ATeeBoxNo: Integer): Integer;
var
  Item: PCheckinItem;
begin
  Result := -1;
  New(Item);
  if (Item <> nil) then
  try
    Item.ReserveNo := AReserveNo;
    Item.TeeBoxNo := ATeeBoxNo;
    Result := Add(Item);
  except
    Dispose(Item);
  end;
end;

procedure TCheckinList.InsertItem(const AIndex: Integer; const AReserveNo: string; const ATeeBoxNo: Integer);
var
  Item: PCheckinItem;
begin
  New(Item);
  if (Item <> nil) then
  try
    Item.ReserveNo := AReserveNo;
    Item.TeeBoxNo := ATeeBoxNo;
    Insert(AIndex, Item);
  except
    Dispose(Item);
  end;
end;

procedure TCheckinList.DeleteItem(const AIndex: Integer);
var
  Item: PCheckinItem;
begin
  Item := ItemList[AIndex];
  try
    if (Item <> nil) then
      Dispose(Item);
  finally
    Delete(AIndex);
  end;
end;

procedure TCheckinList.Clear;
var
  I: Integer;
  Item: PCheckinItem;
begin
  if (Count > 0) then
    for I := 0 to Pred(Count) do
    begin
      Item := ItemList[I];
      if (Item <> nil) then
        Dispose(Item);
    end;

  inherited Clear;
end;

function TCheckinList.GetItem(const AIndex: Integer): PCheckinItem;
begin
  Result := PCheckinItem(Items[AIndex]);
end;

procedure TCheckinList.SetItem(const AIndex: Integer; AItem: PCheckinItem);
begin
  Items[AIndex] := AItem;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(LogCS);
finalization
  DeleteCriticalSection(LogCS);
end.
