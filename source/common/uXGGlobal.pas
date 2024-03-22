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

  { 기본 쓰레드 타이머 }
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

  { 플러그인 설정 정보 }
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

  { 파트너센터 정보 }
  TPartnerCenterConfig = record
    Host: string;
  end;

  {  클라이언트 접속 정보 }
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

  { 타석기AD 설정 정보 }
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

  { 모바일AD 설정 정보 }
  TMobileADInfo = record
    Enabled: Boolean;
    Host: string;
    Port: Integer;
    SecretKey: string;
  end;

  { 주차관제 서버 }
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

  { 부대시설 이용권 발행 설정 }
  TAddonTicket = record
    ParkingTicket: Boolean;
    SaunaTicket: Boolean;
    SaunaTicketKind: Shortint;
    FitnessTicket: Boolean;
    PrintAlldayPass: Boolean;
    PrintWithAssignTicket: Boolean;
  end;

  { 공지사항 정보 }
  TNoticeRec = record
    Title: string;
    RegUserName: string;
    RegDateTime: string;
    PageUrl: string;
    PopupYN: Boolean;
  end;

  { 기본장치 설정 정보 }
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

  { 지문 인식기 정보 }
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

  { 영수증 프린터 설정 정보 }
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

  { 장치 통합 설정 정보 }
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

  { 화면 설정 }
  TScreenInfo = record
    BaseWidth: Integer;
    BaseHeight: Integer;
  end;

  { 냉/온풍기 }
  TAirConditioner = record
    Active: Boolean;
    Enabled: Boolean;
    OnOffMode: Integer;
    BaseMinutes: Integer;
  end;

  { 웰빙클럽 }
  TWelbeingClub = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
    SelectEvent: Boolean; //종목 선택 승인 여부
  end;

  { 리프레쉬클럽 }
  TRefreshClub = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
  end;

  { 리프레쉬골프 }
  TRefreshGolf = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    ApiToken: string;
    StoreCode: string;
  end;

  { 아이코젠 }
  TIKozen = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    StoreCode: string;
  end;

  { 더라운지멤버스 }
  TRoungeMembers = record
    Enabled: Boolean;
    Host: string;
    Password: string;
    StoreCode: string;
  end;

  { 스마틱스 }
  TSmartix = record
    Enabled: Boolean;
    PartnerCode: string;
    Host: string;
    clientCompSeq: string;
  end;

  { 층별 타석기 정보 }
  TTeeBoxFloorItem = record
    FloorCode: string;
    FloorName: string;
    TeeBoxCount: Integer;
  end;

  { 테이블&룸 정보 }
  TTableRec = record
    Container: TXGSaleTableContainer;
    DataSet: TDataSet;
    TableNo: Integer; //테이블&룸 번호
    TableName: string; //테이블 명
    GroupNo: Integer; //단체 번호
    EnteredTime: TDateTime;
    ElapsedMinutes: Integer;
    GuestCount: Integer;
    OrderMemo: string;
    MapButton: TcySpeedButton;
    MapLeft: Integer; //미니맵 버튼 X 위치
    MapTop: Integer; //미니맵 버튼 Y 위치
    MapWidth: Integer; //미니맵 버튼 가로 폭
    MapHeight: Integer; //미니맵 버튼 세로 폭
  end;

  { 테이블&룸 목록 정보 }
  TTableInfo = record
    UnitName: string; //단위구역 명칭(기본값: '테이블/룸')
    Items: TArray<TTableRec>; //테이블&룸 정보
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

  { 라커 층 정보 }
  TLockerFloorItem = record
    FloorCode: string;
    FloorName: string;
    LockerCount: Integer;
  end;

  { 라커 정보 }
  TLockerItem = record
    LockerNo: Integer;
    LockerName: string;
    FloorIndex: Integer;
    ZoneCode: string;
    SexDiv: Integer;
    UseDiv: Integer;
    UseYN: Boolean;
  end;

  { 노쇼 예약 정보 }
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

  { 체크인 정보 }
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

  { 코드 정보 }
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

  { 회원 정보 }
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

  { 쿠폰 정보 }
  TCouponRec = record
    QrCode: string;         //쿠폰일련번호
    CouponName: string;     //쿠폰명
    DcDiv: string;          //할인구분(A:정액할인, R:정률할인)
    DcCnt: Integer;         //할인금액(정액) 또는 할인율(정률)
    ApplyDcAmt: Integer;    //할인적용금액
    MemberNo: string;       //회원번호(빈값이면 비회원 사용 가능)
    StartDay: string;       //시작일
    ExpireDay: string;      //만기일
    UseCnt: Integer;        //사용가능 횟수
    UsedCnt: Integer;       //사용한 횟수
    EventName: string;      //이벤트명
    DcCondDiv: string;      //이용조건(1:중복할인, 2:단독할인)
    ProductDiv: string;     //할인적용상품구분 (A:전체상품, S:타석상품, G:일반상품 , L:라카상품)
    TeeBoxProdDiv: string;  //타석상품구분 (A:전체, R:기간, C:쿠폰, D:일일입장)
    UseYN: string;          //사용여부 (Y:사용완료, M:사용중, N:미사용)
    UseStatus: string;      //사용여부 Description
  public
    procedure Clear;
  end;

  { 전환 상품 정보 }
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

  { 타석 상품 정보 }
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

  { 라커 구매 정보 }
  TLockerRec = record
    LockerNo: Integer;      //라커번호
    LockerName: string;     //라커명
    FloorCode: string;      //충
    ProductAmt: Integer;    //상품금액
    KeepAmt: Integer;       //보증금
    UseStartDate: string;   //사용시작일
    UseContinue: Boolean;   //연장사용여부
  public
    procedure Clear;
  end;

  { 제휴사(웰빙클럽,리프레쉬클럽,아이코젠) 할인 정보 }
  TAffiliateRec = record
    Applied: Boolean;
    PartnerCode: string;    //제휴사 구분코드
    PartnerName: string;    //제휴사명
    MemberCode: string;     //회원코드
    MemberName: string;     //회원명
    MemberTelNo: string;    //회원전화번호
    ItemCode: string;       //종목코드
    ReadData: string;       //식별정보
    IKozenExecId: string;   //아이코젠 전용
    IKozenExecTime: string; //아이코젠 전용
    ApprovalAmt: Integer;   //승인금액
  public
    procedure Clear;
  end;

  { 날씨 정보: OpenWeatherMap API }
  TWeatherInfo = record
    Enabled: Boolean;
    Host: string;
    ApiKey: string;
    Latitude: string; //위도
    Longitude: string; //경도
    Temper: string; //온도
    Precipit: string; //강수확률
    Humidity: string; //습도
    WindSpeed: string; //풍속
    DayTime: Boolean; //낮: True, 밤: False
    Condition: string; //날씨상태
    WeatherId: Integer; //날씨상태Id
    IconIndex: Integer; //아이콘
  end;

  { 서브 모니터(고객 시야) 설정 정보 }
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

  { 환경 설정 정보 }
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
    { 금일 }
    FCurrentDate: string; //yyyymmdd
    FFormattedCurrentDate: string; //yyyy-mm-dd
    FCurrentTime: string; //hhnnss
    FFormattedCurrentTime: string; //hh:nn:ss
    FCurrentDateTime: string; //yyyymmddhhnnss
    FFormattedCurrentDateTime: string; //yyyy-mm-dd hh:nn:ss
    { 어제 }
    FLastDate: string; //yyyymmdd
    FFormattedLastDate: string; //yyyy-mm-dd
    { 내일 }
    FNextDate: string; //yyyymmdd
    FFormattedNextDate: string; //yyyy-mm-dd

    FDayOfWeekKR: string; //요일
    FCheckAutoReboot: Boolean; //리부팅 확인 여부
    FIgnoreAutoReboot: Boolean; //리부팅 무시 여부
    FAutoRebootTime: string;
    FPrepareMin: Integer; //타석입장 준비시간(분)
    FGameOverAlarmMin: Integer;  //타석종료 예고 잔여시간(분)
    FTeeBoxQuickView: Boolean; //타석 배정관리 화면에서 빠른타석 노출 여부
    FTeeBoxQuickViewMode: Integer; //빠른타석 표시 방법
    FTeeBoxForceAssign: Boolean; //볼 회수시 타석 배정 허용
    FTeeBoxForceAssignOnError: Boolean; //타석 에러시 타석 배정 허용
    FIsSimpleMember: Boolean; //간편 회원 등록(이름만 입력)
    FSelfCashReceiptDefault: Boolean; //현금영수증 자진발급 기본 선택 여부
    FReserveAllowedOnOrderTime: Boolean; //주문시각 기준으로 타석상품 예약 허용 여부
    FHoldAllowedOnLeftClick: Boolean; //마우스 좌 클릭으로 타석 임시예약 허용 여부
    FAutoRunAdminCall: Boolean; //알리미 자동 실행 여부
    FAdminCallHandle: HWND; //알리미 핸들
    FLastNoticeDate: string; //공지사항 최종 확인일자
    FTeeBoxFontSizeAdjust: Integer; //타석 상태 표시 글꼴 크기 조절값
    FTeeBoxMaxCountOfFloors: Integer; //층별 최대 타석 수
    FReceiptCopies: Integer; //영수증 출력 매수
    FTeeBoxTicketCopies: Integer; //타석배정표 출력 매수
    FReceiptPreview: Boolean; //영수증 출력 미리보기

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

    FTeeBoxStatusWorking: Boolean; //타석가동상황 수신중 여부
    FImmediateTeeBoxAssign: Boolean; //즉시배정 사용 유무
    FTeeBoxChangedReIssue: Boolean; //타석 변경 시 배정표 발행 여부
    FTeeBoxEmergencyMode: Boolean; //긴급배정 모드
    FTeeBoxTeleReserved: Boolean; //전화예약 여부
    FUseTeeBoxTeleReserved: Boolean; //전화예약 사용 여부
    FUseWebCamMirror: Boolean; //고객모니터 웹캠 미러 표시 여부
    FUseFingerPrintMirror: Boolean; //고객모니터 지문인식 화면 미러 표시 여부
    FUseLessonReceipt: Boolean; //강습료 간이영수증 발행 기능 사용 여부
    FTeeBoxHoldWorking: Boolean;

    FNoticePopupUrl: string; //공지사항 팝업Url

    procedure ResetLogFile;
    procedure SetConfigUpdated(const AValue: string);
  public
    FS: TFormatSettings;
    TeeBoxFloorInfo: TArray<TTeeBoxFloorItem>; //층별 타석기 배치 정보
    LockerFloorInfo: TArray<TLockerFloorItem>; //라커 층 정보
    LockerInfo: TArray<TLockerItem>; //라커 정보
    NoticeInfo: TArray<TNoticeRec>; //공지사항
    ScreenInfo: TScreenInfo; //화면 설정
    TableInfo: TTableInfo; //테이블&룸 설정
    PartnerCenter: TPartnerCenterConfig; //파트너센터
    AirConditioner: TAirConditioner; //냉,온풍기
    WelbeingClub: TWelbeingClub; //웰빙클럽
    RefreshClub: TRefreshClub; //리프레쉬클럽
    RefreshGolf: TRefreshGolf; //리프레쉬골프
    IKozen: TIKozen; //아이코젠
    RoungeMembers: TRoungeMembers; //더라운지멤버스
    Smartix: TSmartix; //스마틱스-온라인판매
    ParkingServer: TParkingServer; //주차관제 서버
    TeeBoxADInfo: TTeeBoxADInfo; //타석기AD
    AddOnTicket: TAddonTicket; //부대시설 이용권 발행 설정
    NoShowInfo: TNoshowInfo; //노쇼 예약 정보
    WeatherInfo: TWeatherInfo; //날씨 정보

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
        CPO_SALE_TEEBOX, //타석예약(프런트)
        CPO_SALE_LESSON_ROOM: //레슨룸(파스텔)
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
    Result := '웰빙클럽'
  else if (AAffiliateDiv = Global.RefreshClub.PartnerCode) then
    Result := '리프레쉬/클럽'
  else if (AAffiliateDiv = Global.RefreshGolf.PartnerCode) then
    Result := '리프레쉬/골프'
  else if (AAffiliateDiv = Global.IKozen.PartnerCode) then
    Result := '아이코젠'
  else if (AAffiliateDiv = Global.Smartix.PartnerCode) then
    Result := '스마틱스'
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
      raise Exception.Create(Format('COM%d은 등록되지 않은 통신포트입니다.', [AComNumber]));

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
  // 런처
  //================================================================================================
  with FConfigLauncher do
  begin
    { 업데이트 설정 }
    if not SectionExists('Config') then
    begin
      WriteString('Config', 'UpdateURL', 'http://nhncdn.xpartners.co.kr/POS/R1/');
      WriteString('Config', 'RunApp', AppName + '.exe');
      WriteString('Config', 'Params', '');
      WriteBool('Config', 'RebootWhenUpdated', False);
    end;
  end;

  //================================================================================================
  // 시스템 환경 설정
  //================================================================================================
  with FConfig do
  begin
    { 클라이언트 정보 }
    if not SectionExists('Client') then
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', '');
      WriteString('Client', 'SecretKey', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 일반 설정 }
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

    { 매장 설정 }
    if not SectionExists('StoreInfo') then
    begin
      WriteInteger('StoreInfo', 'POSType', CPO_SALE_TEEBOX);
//      WriteString('StoreInfo', 'VanCode', 'KCP');
//      WriteString('StoreInfo', 'CreditTID', '');
//      WriteString('StoreInfo', 'PaycoTID', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 타석기AD }
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
    { 파트너센터 }
    if not SectionExists('BackOffice') then
    begin
      WriteString('BackOffice', 'Host', GCD_BACKOFFICE_HOST);
      WriteFile(FConfigFileName, '');
    end;
    *)

    { 주차관제 서버 }
    if not SectionExists('ParkingServer') then
    begin
      WriteInteger('ParkingServer', 'Vendor', 0); //0:한일테크닉스
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

    { 플러그인 }
    if not SectionExists('Plugin') then
    begin
      WriteString('Plugin', 'StartModule', CPL_START);
      WriteString('Plugin', 'SubMonitorModule', CPL_SUB_MONITOR);
      WriteString('Plugin', 'WebViewModule', CPL_WEBVIEW);
      WriteToFile(FConfigFileName, '');
    end;

    { 듀얼 모니터(고객측) }
    if not SectionExists('SubMonitor') then
    begin
      WriteBool('SubMonitor', 'Enabled', False);
      WriteInteger('SubMonitor', 'Top', 0);
      WriteInteger('SubMonitor', 'Left', 1920);
      WriteInteger('SubMonitor', 'Width', 1920);
      WriteInteger('SubMonitor', 'Height', 1080);
      WriteToFile(FConfigFileName, '');
    end;

    { 영수증 프린터 }
    if not SectionExists('ReceiptPrinter') then
    begin
      WriteBool('ReceiptPrinter', 'Enabled', False);
      WriteInteger('ReceiptPrinter', 'DeviceId', 0);
      WriteInteger('ReceiptPrinter', 'Copies', 1);
      WriteInteger('ReceiptPrinter', 'Port', 0);
      WriteInteger('ReceiptPrinter', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { 보안IC 카드 리더 }
    if not SectionExists('CardReader') then
    begin
      WriteBool('CardReader', 'Enabled', False);
      WriteInteger('CardReader', 'DeviceId', 0);
      WriteInteger('CardReader', 'Port', 0);
      WriteInteger('CardReader', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { 전자서명패드 }
    if not SectionExists('SignPad') then
    begin
      WriteBool('SignPad', 'Enabled', False);
      WriteInteger('SignPad', 'Port', 0);
      WriteInteger('SignPad', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { 멤버십 RFID/NFC 리더 }
    if not SectionExists('RFIDReader') then
    begin
      WriteBool('RFIDReader', 'Enabled', False);
      WriteInteger('RFIDReader', 'DeviceId', 0);
      WriteInteger('RFIDReader', 'Port', 0);
      WriteInteger('RFIDReader', 'Baudrate', 115200);
      WriteToFile(FConfigFileName, '');
    end;

    { 복지카드 RFID 리더 }
    if not SectionExists('WelfareCardReader') then
    begin
      WriteBool('WelfareCardReader', 'Enabled', False);
      WriteInteger('WelfareCardReader', 'DeviceId', 0);
      WriteInteger('WelfareCardReader', 'Port', 0);
      WriteInteger('WelfareCardReader', 'Baudrate', 9600);
      WriteToFile(FConfigFileName, '');
    end;

    { 바코드 스캐너 }
    if not SectionExists('BarcodeScanner') then
    begin
      WriteBool('BarcodeScanner', 'Enabled', False);
      WriteInteger('BarcodeScanner', 'Port', 0);
      WriteInteger('BarcodeScanner', 'Baudrate', 0);
      WriteToFile(FConfigFileName, '');
    end;

    { 지문 인식기 }
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

    { 고객표시대 }
    if not SectionExists('VFD') then
    begin
      WriteBool('VFD', 'Enabled', False);
      WriteInteger('VFD', 'DeviceId', 0);
      WriteInteger('VFD', 'Port', 0);
      WriteInteger('VFD', 'Baudrate', 9600);
      WriteToFile(FConfigFileName, '');
    end;

    { 웰빙클럽 }
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

    { 리프레쉬클럽 }
    if not SectionExists('RefreshClub') then
    begin
      WriteBool('RefreshClub', 'Enabled', False);
      WriteString('RefreshClub', 'PartnerCode', GCD_RFCLUB_CODE);
      WriteString('RefreshClub', 'Host', '');
      WriteString('RefreshClub', 'ApiToken', '');
      WriteString('RefreshClub', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 리프레쉬골프 }
    if not SectionExists('RefreshGolf') then
    begin
      WriteBool('RefreshGolf', 'Enabled', False);
      WriteString('RefreshGolf', 'PartnerCode', GCD_RFGOLF_CODE);
      WriteString('RefreshGolf', 'Host', '');
      WriteString('RefreshGolf', 'ApiToken', '');
      WriteString('RefreshGolf', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 아이코젠 }
    if not SectionExists('IKozen') then
    begin
      WriteBool('IKozen', 'Enabled', False);
      WriteString('IKozen', 'PartnerCode', GCD_IKOZEN_CODE);
      WriteString('IKozen', 'Host', '');
      WriteString('IKozen', 'StoreCode', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 더라운지멤버스 }
    if not SectionExists('RoungeMembers') then
    begin
      WriteBool('RoungeMembers', 'Enabled', False);
      WriteString('RoungeMembers', 'Host', GCD_TRMEMBERS_HOST);
      WriteString('RoungeMembers', 'StoreCode', '');
      WriteString('RoungeMembers', 'Password', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 스마틱스 }
    if not SectionExists('Smartix') then
    begin
      WriteBool('Smartix', 'Enabled', False);
      WriteString('Smartix', 'PartnerCode', GCD_SMARTIX_CODE);
      WriteString('Smartix', 'Host', '');
      WriteToFile(FConfigFileName, '');
    end;

    { 스펙트럼 스윙분석기 }
    if not SectionExists('Spectrum') then
    begin
      WriteString('Spectrum', 'MonitorUrl', 'http://site0000.iptime.org:8080/ABSystem/interfaceIMRhst.jsp');
    end;
  end;
end;

procedure TGlobal.ReadConfig;
begin
  //================================================================================================
  // 시스템 환경 설정
  //================================================================================================
  with FConfig do
  begin
    { 일반 설정 }
    FConfigUpdated := ReadString('Config', 'LastUpdated', '');
    FHideTaskBar := ReadBool('Config', 'HideTaskBar', False);
    FHideCursor := ReadBool('Config', 'HideCursor', False);
    ScreenInfo.BaseWidth := ReadInteger('Config', 'BaseWidth', 1366);
    ScreenInfo.BaseHeight := ReadInteger('Config', 'BaseHeight', 768);

    FAutoRebootTime := ReadString('Config', 'AutoRebootTime', GSD_AUTO_REBOOT_TIME);

    { VAN 정보 }
    VanModule.VanCode := ReadString('StoreInfo', 'VanCode', 'KCP');
    VanModule.ApplyConfigAll;

    { 타석기AD }
    TeeBoxADInfo.Enabled := ReadBool('TeeBoxAD', 'Enabled', False);
    //TeeBoxADInfo.Host    := ReadString('TeeBoxAD', 'Host', CCD_TEEBOX_HOST);
    TeeBoxADInfo.Host    := '192.168.0.212';
    TeeBoxADInfo.DBPort  := ReadInteger('TeeBoxAD', 'DBPort', CCD_TEEBOX_DB_PORT);
    TeeBoxADInfo.DBUser  := CCD_TEEBOX_USER;
    TeeBoxADInfo.DBPwd   := CCD_TEEBOX_PWD;
    TeeBoxADInfo.DBTimeout := GSD_MYSQL_DEFAULT_TIMEOUT;
    TeeBoxADInfo.APIPort := ReadInteger('TeeBoxAD', 'APIPort', CCD_TEEBOX_API_PORT);
    TeeBoxADInfo.APITimeout := ReadInteger('TeeBoxAD', 'Timeout', GSD_TCP_DEFAULT_TIMEOUT);

//    { 파트너센터 }
//    BackOfficeUrl := ReadString('BackOffice', 'Host', GCD_BACKOFFICE_HOST);

    { 주차관제 서버 }
    ParkingServer.Vendor := ReadInteger('ParkingServer', 'Vendor', 0); //0:한일테크닉스
    ParkingServer.Enabled := ReadBool('ParkingServer', 'Enabled', False);
    ParkingServer.Host := ReadString('ParkingServer', 'Host', '127.0.0.1');
    ParkingServer.Database := ReadString('ParkingServer', 'Database', '');
    ParkingServer.CharSet := ReadString('ParkingServer', 'CharSet', 'utf8');
    ParkingServer.DBPort := ReadInteger('ParkingServer', 'Port', 0);
    ParkingServer.DBUser := ReadString('ParkingServer', 'UserId', '');
    ParkingServer.DBPwd := StrDecrypt(ReadString('ParkingServer', 'Password', ''));
    ParkingServer.DBTimeout := ReadInteger('ParkingServer', 'Timeout', GSD_MYSQL_DEFAULT_TIMEOUT);
    ParkingServer.BaseHours := ReadInteger('ParkingServer', 'BaseHours', 3);

    { 플러그인 }
    PluginConfig.StartModule := ReadString('Plugin', 'StartModule', CPL_START);
    PluginConfig.SubMonitorModule := ReadString('Plugin', 'SubMonitorModule', CPL_SUB_MONITOR);
    PluginConfig.WebViewModule := ReadString('Plugin', 'WebViewModule', CPL_WEBVIEW);

    { 듀얼 모니터(고객측) }
    SubMonitor.Enabled := ReadBool('SubMonitor', 'Enabled', False);
    SubMonitor.Top := ReadInteger('SubMonitor', 'Top', 0);
    SubMonitor.Left := ReadInteger('SubMonitor', 'Left', 1366);
    SubMonitor.Width := ReadInteger('SubMonitor', 'Width', 1920);
    SubMonitor.Height := ReadInteger('SubMonitor', 'Height', 1080);

    { 영수증 프린터 }
    DeviceConfig.ReceiptPrinter.Enabled := ReadBool('ReceiptPrinter', 'Enabled', False);
    DeviceConfig.ReceiptPrinter.DeviceId := ReadInteger('ReceiptPrinter', 'DeviceId', 0);
    DeviceConfig.ReceiptPrinter.Copies := ReadInteger('ReceiptPrinter', 'Copies', 1);
    DeviceConfig.ReceiptPrinter.Port := ReadInteger('ReceiptPrinter', 'Port', 0);
    DeviceConfig.ReceiptPrinter.Baudrate := ReadInteger('ReceiptPrinter', 'Baudrate', 9600);

    { 보안IC 카드 리더 }
    DeviceConfig.ICCardReader.Enabled := ReadBool('CardReader', 'Enabled', False);
    DeviceConfig.ICCardReader.DeviceId := ReadInteger('CardReader', 'DeviceId', 0);
    DeviceConfig.ICCardReader.Port := ReadInteger('CardReader', 'Port', 0);
    DeviceConfig.ICCardReader.Baudrate := ReadInteger('CardReader', 'Baudrate', 9600);

    { 전자서명패드 }
    DeviceConfig.SignPad.Enabled := ReadBool('SignPad', 'Enabled', False);
    DeviceConfig.SignPad.Port := ReadInteger('SignPad', 'Port', 0);
    DeviceConfig.SignPad.Baudrate := ReadInteger('SignPad', 'Baudrate', 9600);

    { 멤버십카드 RFID/NFC 리더 }
    DeviceConfig.RFIDReader.Enabled := ReadBool('RFIDReader', 'Enabled', False);
    DeviceConfig.RFIDReader.DeviceId := ReadInteger('RFIDReader', 'DeviceId', 0);
    DeviceConfig.RFIDReader.Port := ReadInteger('RFIDReader', 'Port', 0);
    DeviceConfig.RFIDReader.Baudrate := ReadInteger('RFIDReader', 'Baudrate', 115200);

    { 복지카드 RFID 리더 }
    DeviceConfig.WelfareCardReader.Enabled := ReadBool('WelfareCardReader', 'Enabled', False);
    DeviceConfig.WelfareCardReader.DeviceId := ReadInteger('WelfareCardReader', 'DeviceId', 0);
    DeviceConfig.WelfareCardReader.Port := ReadInteger('WelfareCardReader', 'Port', 0);
    DeviceConfig.WelfareCardReader.Baudrate := ReadInteger('WelfareCardReader', 'Baudrate', 9600);

    { 바코드 스캐너 }
    DeviceConfig.BarcodeScanner.Enabled := ReadBool('BarcodeScanner', 'Enabled', False);
    DeviceConfig.BarcodeScanner.Port := ReadInteger('BarcodeScanner', 'Port', 0);
    DeviceConfig.BarcodeScanner.Baudrate := ReadInteger('BarcodeScanner', 'Baudrate', 9600);

    { 지문 인식기 }
    DeviceConfig.FingerPrintScanner.Enabled := ReadBool('FingerPrintScanner', 'Enabled', False);
    DeviceConfig.FingerPrintScanner.DeviceType := ReadInteger('FingerPrintScanner', 'DeviceType', CFT_NITGEN);
    DeviceConfig.FingerPrintScanner.AutoDetect := ReadBool('FingerPrintScanner', 'AutoDetect', False);
    DeviceConfig.FingerPrintScanner.EnrollQuality := ReadInteger('FingerPrintScanner', 'EnrollQuality', GSD_FIR_ENROLL_QUALITY);
    DeviceConfig.FingerPrintScanner.IdentifyQuality := ReadInteger('FingerPrintScanner', 'IdentifyQuality', GSD_FIR_IDENTIFY_QUALITY);
    DeviceConfig.FingerPrintScanner.VerifyQuality := ReadInteger('FingerPrintScanner', 'VerifyQuality', GSD_FIR_VERIFY_QUALITY);
    DeviceConfig.FingerPrintScanner.SecurityLevel := ReadInteger('FingerPrintScanner', 'SecurityLevel', GSD_FIR_SECURITY_LEVEL);
    DeviceConfig.FingerPrintScanner.DefaultTimeout := ReadInteger('FingerPrintScanner', 'DefaultTimeout', GSD_FIR_DEFAULT_TIMEOUT);

    { 웰빙클럽 }
    WelbeingClub.Enabled := ReadBool('WelbeingClub', 'Enabled', False);
    WelbeingClub.PartnerCode := ReadString('WelbeingClub', 'PartnerCode', GCD_WBCLUB_CODE);
    WelbeingClub.Host := ReadString('WelbeingClub', 'Host', GCD_WBCLUB_HOST);
    WelbeingClub.ApiToken := ReadString('WelbeingClub', 'ApiToken', '');
    WelbeingClub.StoreCode := ReadString('WelbeingClub', 'StoreCode', '');
    WelbeingClub.SelectEvent := ReadBool('WelbeingClub', 'SelectEvent', False);

    { 리프레쉬클럽 }
    RefreshClub.Enabled := ReadBool('RefreshClub', 'Enabled', False);
    RefreshClub.PartnerCode := ReadString('RefreshClub', 'PartnerCode', GCD_RFCLUB_CODE);
    RefreshClub.Host := ReadString('RefreshClub', 'Host', GCD_RFCLUB_HOST);
    RefreshClub.ApiToken := ReadString('RefreshClub', 'ApiToken', '');
    RefreshClub.StoreCode := ReadString('RefreshClub', 'StoreCode', '');

    { 리프레쉬골프 }
    RefreshGolf.Enabled := ReadBool('RefreshGolf', 'Enabled', False);
    RefreshGolf.PartnerCode := ReadString('RefreshGolf', 'PartnerCode', GCD_RFGOLF_CODE);
    RefreshGolf.Host := ReadString('RefreshGolf', 'Host', GCD_RFGOLF_HOST);
    RefreshGolf.ApiToken := ReadString('RefreshGolf', 'ApiToken', '');
    RefreshGolf.StoreCode := ReadString('RefreshGolf', 'StoreCode', '');

    { 아이코젠 }
    IKozen.Enabled := ReadBool('IKozen', 'Enabled', False);
    IKozen.PartnerCode := ReadString('IKozen', 'PartnerCode', GCD_IKOZEN_CODE);
    IKozen.Host := ReadString('IKozen', 'Host', '');
    IKozen.StoreCode := ReadString('IKozen', 'StoreCode', '');

    { 더라운지멤버스 }
    RoungeMembers.Enabled := ReadBool('RoungeMembers', 'Enabled', False);
    RoungeMembers.Host := ReadString('RoungeMembers', 'Host', GCD_TRMEMBERS_HOST);
    RoungeMembers.StoreCode := ReadString('RoungeMembers', 'StoreCode', '');
    RoungeMembers.Password := StrDecrypt(ReadString('RoungeMembers', 'Password', ''));

    { 스마틱스 }
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
  // 로컬 환경 설정
  //================================================================================================
  with FConfigLocal do
  begin
    { 클라이언트 정보 }
    if not SectionExists('Client') then
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', '');
      WriteString('Client', 'SecretKey', '');
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 일반 설정 }
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

    { 사용자 정보 }
    if not SectionExists('UserInfo') then
    begin
      WriteBool('UserInfo', 'SaveInfo', False);
      WriteString('UserInfo', 'UserId', '');
      WriteString('UserInfo', 'Password', '');
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 타석가동상황판 }
    if not SectionExists('Scoreboard') then
    begin
      WriteInteger('Scoreboard', 'BackgroundColor', GCR_COLOR_BACK_PANEL);
      WriteBool('Scoreboard', 'ShowErrorStatus', True);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 프린터 출력 설정 }
    if not SectionExists('Printout') then
    begin
      nCopies := FConfig.ReadInteger('ReceiptPrinter', 'Copies', 1);
      WriteInteger('Printout', 'ReceiptCopies', nCopies);
      WriteInteger('Printout', 'TeeBoxTicketCopies', 1);
      WriteBool('Printout', 'ReceiptPreview', False);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 부대시설 이용권 발행 설정 }
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

    { 내장 웹 브라우저 }
    if not SectionExists('WebView') then
    begin
      WriteInteger('WebView', 'Top', 0);
      WriteInteger('WebView', 'Left', 0);
      WriteInteger('WebView', 'Width', 0);
      WriteInteger('WebView', 'Height', 0);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 냉/온풍기 }
    if not SectionExists('AirConditioner') then
    begin
      WriteBool('AirConditioner', 'Enabled', False);
      WriteInteger('AirConditioner', 'OnOffMode', 0); //0:Auto On/Off, 1:Manual-Control
      WriteInteger('AirConditioner', 'BaseMinutes', 70);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 구내식당 직원 식대 설정 }
    if not SectionExists('MealInfo') then
    begin
      WriteString('MealInfo', 'MealCode', '');
      WriteString('MealInfo', 'MealName', '');
      WriteInteger('MealInfo', 'MealPrice', 0);
      WriteToFile(FConfigLocalFileName, '');
    end;

    { 날씨 정보 설정 }
    if not SectionExists('Weather') then
    begin
      //37.33,  126.59  : 서울의 지리적 중심점
      //37.568, 126.978 : OpenWeatherMap.org의 Seoul City 검색 위치
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
  // 로컬 환경 설정
  //================================================================================================
  with FConfigLocal do
  begin
    { 클라이언트 정보 }
    if FClientConfig.UseLocalSetting then
    begin
      FClientConfig.ClientId := ReadString('Client', 'ClientId', '');
      FClientConfig.Host := ReadString('Client', 'Host', '');
      FClientConfig.SecretKey := StrDecrypt(ReadString('Client', 'SecretKey', ''));
    end;

    { 로컬 운영 정책 }
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

    { 타석가동상황판 }
    SubMonitor.BackgroundColor := ReadInteger('Scoreboard', 'BackgroundColor', GCR_COLOR_BACK_PANEL);
    SubMonitor.ShowErrorStatus := ReadBool('Scoreboard', 'ShowErrorStatus', True);

    { 프린터 출력 설정 }
    FReceiptCopies := ReadInteger('Printout', 'ReceiptCopies', 1);
    FTeeBoxTicketCopies := ReadInteger('Printout', 'TeeBoxTicketCopies', 1);
    FReceiptPreview := ReadBool('Printout', 'ReceiptPreview', False);

    { 부대시설 이용권 발행 설정 }
    AddonTicket.ParkingTicket := ReadBool('AddonTicket', 'ParkingTicket', False);
    AddonTicket.SaunaTicket := ReadBool('AddonTicket', 'SaunaTicket', False);
    AddonTicket.SaunaTicketKind := ReadInteger('AddonTicket', 'SaunaTicketKind', 0);
    AddonTicket.FitnessTicket := ReadBool('AddonTicket', 'FitnessTicket', False);
    AddonTicket.PrintAlldayPass := ReadBool('AddonTicket', 'PrintAlldayPass', True);
    AddonTicket.PrintWithAssignTicket := ReadBool('AddonTicket', 'PrintWithAssignTicket', False);

    { 내장 웹 브라우저 }

    { 냉/온풍기 }
    AirConditioner.Active := False;
    AirConditioner.Enabled := ReadBool('AirConditioner', 'Enabled', False);
    AirConditioner.OnOffMode := ReadInteger('AirConditioner', 'OnOffMode', 0);
    AirConditioner.BaseMinutes := ReadInteger('AirConditioner', 'BaseMinutes', 70);

    { 구내식당 직원 식대 설정 }

    { 테이블/룸 정보 설정 }

    { 날씨 정보 설정 }
    WeatherInfo.Host := ReadString('Weather', 'Host', '');
    WeatherInfo.Latitude := ReadString('Weather', 'Latitude', '');
    WeatherInfo.Longitude := ReadString('Weather', 'Longitude', '');
    WeatherInfo.ApiKey := StrDecrypt(ReadString('Weather', 'ApiKey', ''));
    WeatherInfo.Enabled := not (WeatherInfo.Host.IsEmpty or WeatherInfo.Latitude.IsEmpty or WeatherInfo.Longitude.IsEmpty or WeatherInfo.ApiKey.IsEmpty);
  end;
end;

procedure TGlobal.CheckConfigTable;
begin
  { 테이블/룸 정보 설정 }
  with FConfigTable do
  begin
    if not SectionExists('Config') then
    begin
      WriteString('Config', 'UnitName', '테이블/룸');
    end;

    if Modified then
      UpdateFile;
  end;
end;

procedure TGlobal.ReadConfigTable;
begin
  { 테이블/룸 정보 설정 }
  with FConfigTable do
  begin
    TableInfo.UnitName := ReadString('Config', 'UnitName', '테이블/룸');
    if TableInfo.UnitName.IsEmpty then
      TableInfo.UnitName := '테이블';
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
    { 프로그램 로그 삭제 }
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

    { 결제 로그 삭제 (nYear년 前 것만) }
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

{ 바코드 스캐너 }
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
      UpdateLog(Global.LogFile, Format('바코드 스캔 : %s', [sReadData]));

      { PAYCO 결제 상태 }
      if SaleManager.ReceiptInfo.PaycoReady then
      begin
        PaycoModule.SetBarcode(sReadData);
        Exit;
      end;

      { PAYCO 바코드를 제외한 것들 }
      PM := TPluginMessage.Create(nil);
      try
        { XGOLF 회원 QR 코드 }
        if (Copy(sReadData, 1, 2) = CQT_HEAD_XGOLF) then
        begin
          sReadData := StringReplace(sReadData, CQT_HEAD_XGOLF, '', [rfReplaceAll]);
          PM.Command := CPC_SEND_QRCODE_XGOLF;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { 연습장회원 QR코드 : 첫 문자가 '1'이고 총 10자리의 숫자형 문자열 }
        else if (Copy(sReadData, 1, 1) = CQT_HEAD_MEMBER) and
                (sReadData.Length = 10) and
                (StrToIntDef(sReadData, 0) > 0) then
        begin
          PM.Command := CPC_SEND_QRCODE_MEMBER;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { 프로모션 할인쿠폰 QR코드 }
        else if (Copy(sReadData, 1, 2) = CQT_HEAD_COUPON) then
        begin
          PM.Command := CPC_SEND_QRCODE_COUPON;
          PM.AddParams(CPP_QRCODE, sReadData);
        end
        { 영수증 바코드 }
        else if (Copy(sReadData, 1, 5) = SaleManager.StoreInfo.StoreCode) then
        begin
          PM.Command := CPC_SEND_RECEIPT_NO;
          PM.AddParams(CPP_RECEIPT_NO, sReadData);
        end else
        begin
          PM.Command := CPC_SEND_SCAN_DATA; //제휴사 회원 카드번호, 기타 바코드 등
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
      //UpdateLog(Global.LogFile, Format('멤버십 RFID/NFC : %s', [sReadData]));
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

{ 복지카드 }
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
//        UpdateLog(Global.LogFile, Format('복지카드 RFID : %s', [sReadData]));
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
