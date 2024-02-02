(*******************************************************************************

  Project     : XPartners 실내골프연습장 배정 관리 시스템
  Title       : 모바일 AD 메인 화면
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-08-01   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2021 All rights reserved.

*******************************************************************************)
unit uMobileADMain;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  DB, IniFiles, ComCtrls, Vcl.Mask,
  { Indy }
  IdBaseComponent, IdComponent, IdTCPServer, IdCustomTCPServer, IdAntiFreezeBase, IdAntiFreeze,
  IdContext,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxDBData,
  dxScrollbarAnnotations, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGrid,
  cxGridBandedTableView, cxGridTableView, cxGridDBBandedTableView,
  { TMS }
  AdvWiiProgressBar,
  { SolbiLib }
  cyEdit, cyEditInteger, cyBaseLed, cyLed, cyCheckbox,
  { Custom }
  uCpuUsage, uAesHelper;

{$M+}
{$I ..\common\XGPOS.inc}
{$I ..\common\XGAdminCall.inc}
{$I ..\common\XGMobileAPI.inc}

const
	{ StartUp Registry Key }
  LC_APP_TITLE = 'MobileAD for XPartners GOLF';
  LC_LAUNCHER_TITLE = 'XPartners MobileAD Launcher';
  LC_LAUNCHER_NAME = 'XGLauncher.exe';

	{ Status LED }
  LC_LED_MOBILE_AD  = 1;
  LC_LED_SERVER     = 2;
  LC_LED_TEEBOX_AD  = 3;
  LC_LED_TEEBOX_DB  = 4;
  LC_LED_ADMIN_CALL = 5;

	{ Status Color }
  LC_COLOR_ON     = $0000FF00; //Lime
  LC_COLOR_OFF    = $00C0C0C0; //Silver
  LC_COLOR_ERROR  = $000000FF; //Red
  LC_COLOR_NORMAL = $00FF6600; //SkyBlue

  WM_SERVER_CONNECTED = WM_USER + 3000;

type
  { 서버 접속 쓰레드 }
  TCheckConnectThread = class(TThread)
  private
    FConnected: Boolean;
    FCheckAliveMinutes: Integer; //분
    FCheckAliveLastWorked: TDateTime;
    FCheckConnectInterval: Integer; //밀리초
    FCheckConnectLastWorked: TDateTime;
    FCheckCpuUsageInterval: Integer; //밀리초
    FCheckCpuUsageLastWorked: TDateTime;

//    procedure DoCheckAliveLocalServer;
  protected
    procedure Execute; override;
  published
    constructor Create(const ACreateSuspended: Boolean);
    destructor Destroy; override;

    property Connected: Boolean read FConnected write FConnected;
    property CheckConnectInterval: Integer read FCheckConnectInterval write FCheckConnectInterval;
    property CheckCpuUsageInterval: Integer read FCheckCpuUsageInterval write FCheckCpuUsageInterval;
  end;

  TMainForm = class(TForm)
    TCPServer: TIdTCPServer;
    IndyAntiFreeze: TIdAntiFreeze;
    panFooter: TPanel;
    lblMessage: TLabel;
    panToolbar: TPanel;
    btnSaveConfig: TButton;
    btnLogClear: TButton;
    tmrClock: TTimer;
    pbrTotal: TProgressBar;
    pbrCurrent: TProgressBar;
    pgcMain: TPageControl;
    tabLogView: TTabSheet;
    tabConfig: TTabSheet;
    lbxLogView: TListBox;
    panConfig1: TPanel;
    btnClose: TButton;
    pbrMobileAD: TAdvWiiProgressBar;
    lblClock: TLabel;
    lblTeeBoxAD: TLabel;
    lblAdminCall: TLabel;
    lblServer: TLabel;
    panConfig2: TPanel;
    gbxBaseSettings: TGroupBox;
    Label3: TLabel;
    ckbLogDelete: TCheckBox;
    edtLogDeleteDays: TcyEditInteger;
    ckbAutoRun: TCheckBox;
    edtStoreCode: TLabeledEdit;
    btnServerActive: TButton;
    btnDeleteLog: TButton;
    gbxAdminCall: TGroupBox;
    Label5: TLabel;
    edtAdminCallHost: TLabeledEdit;
    edtAdminCallPort: TcyEditInteger;
    ledServer: TcyLed;
    ledAdminCall: TcyLed;
    ledTeeBoxAD: TcyLed;
    ledMobileAD: TcyLed;
    lblMobileAD: TLabel;
    gbxServer: TGroupBox;
    edtServerHost: TLabeledEdit;
    edtClientId: TLabeledEdit;
    edtClientKey: TLabeledEdit;
    btnGetToken: TButton;
    ledTeeBoxDB: TcyLed;
    lblTeeBoxDB: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edtMobileADPort: TcyEditInteger;
    gbxTeeBoxAD: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtTeeBoxADHost: TLabeledEdit;
    edtTeeBoxADPort: TcyEditInteger;
    edtTeeBoxDBPort: TcyEditInteger;
    edtTeeBoxDBUserId: TLabeledEdit;
    edtTeeBoxDBPwd: TLabeledEdit;
    edtTeeBoxDBCatalog: TLabeledEdit;
    ckbAdminCallActive: TcyCheckBox;
    btnAPITest1001: TButton;
    btnAPITest1003: TButton;
    btnAPITest1002: TButton;
    btnAPITest1004: TButton;
    btnAPITest1005: TButton;
    ckbCheckAlive: TCheckBox;
    imgLogo: TImage;
    Label6: TLabel;
    edtMobileADTimeout: TcyEditInteger;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgcMainChange(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnLogClearClick(Sender: TObject);
    procedure lbxLogViewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure TCPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure TCPServerException(AContext: TIdContext; AException: Exception);
    procedure btnDeleteLogClick(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure edtClientKeyDblClick(Sender: TObject);
    procedure btnServerActiveClick(Sender: TObject);
    procedure btnAPITest1001Click(Sender: TObject);
    procedure btnAPITest1003Click(Sender: TObject);
    procedure btnAPITest1002Click(Sender: TObject);
    procedure btnAPITest1004Click(Sender: TObject);
    procedure btnAPITest1005Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FIsFirst: Boolean;
    FToday: string;
    FActiveServer: Boolean;
    FAppVersion: string;
    FCpuStatus: string;

    function DoInit: Boolean;
    function DoResponse(const AReadBuffer: string; var AWriteBuffer, AErrCode, AErrMsg: string): Boolean;
    procedure DeleteLog;

    procedure SetServerConnected(const AConnected: Boolean);
    procedure SetActiveServer(const AValue: Boolean);
    procedure SetCpuStatus(const AValue: string);
  protected
    procedure WndProc(var AMessage: TMessage); override;
  public
    { Public declarations }
    procedure InitConfig;
    procedure WriteConfig;
    procedure ReadConfig;
    procedure UpdateConfig;

    property ActiveServer: Boolean read FActiveServer write SetActiveServer default False;
    property CpuStatus: string read FCpuStatus write SetCpuStatus;
  end;

var
  MainForm: TMainForm;
  IniFile: TIniFile;
  CheckConnectThread: TCheckConnectThread;
  DBQueryCS: TRTLCriticalSection;
  LogCS: TRTLCriticalSection;
  CipherAES: TCipherAES;
  CpuUsageData: PCpuUsageData;
  CpuCount: Integer;
  CloseAllowed: Boolean=False;

function IsNextDay(const ACheckTime: string): Boolean; //nn:ss
procedure AddLog(const ALogText: string; const AColor: TColor=clBlack; const AWriteToFile: Boolean=True);
procedure UpdateLog(const AFileName, AStr: string; const ALineBreak: Boolean=False);
procedure SetLed(const AKind: Integer; const AIsActive: Boolean; const AIsError: Boolean=False);
procedure DoAdminCall(const AErrorCode: Integer; const AMsgText: string);

implementation

uses
  { Native }
{$IFDEF RELEASE}
  Winapi.ShlObj, System.Win.ComObj, Winapi.ActiveX,
{$ENDIF}
  Dialogs, UITypes, JSON, DateUtils,
  { Indy }
  IdGlobal, IdException, IdTCPConnection, IdTCPClient, IdStack, IdStackConsts,
  { Project }
  uMobileADDM, uXGCommonLib, uWaitMsg, uGetWinHandle, uNetLib;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.WndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_SERVER_CONNECTED:
      SetServerConnected(True);
  end;

  inherited WndProc(AMessage);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
{$IFDEF RELEASE}
  sLinkFile: string;
  hIObject: IUnknown;
  hISLink: IShellLink;
  hIPFile: IPersistFile;
{$ENDIF}
  sFileName: string;
begin
  FIsFirst := True;
  FAppVersion := GetAppVersion(2);
  FToday := FormatDateTime('yyyymmdd', Now);
  with FormatSettings do
  begin
    DateSeparator := '-';
    TimeSeparator := ':';
    ShortDateFormat := 'yyyy-mm-dd';
    ShortTimeFormat := 'hh:nn:ss';
    LongDateFormat := 'yyyy-mm-dd';
    LongTimeFormat := 'hh:nn:ss';
  end;

  Config.AppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  Config.HomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  Config.ConfigDir := Config.HomeDir + 'config\';
  Config.LogDir := Config.HomeDir + 'log\';
  Config.LogFile := Format(Config.LogDir + Config.AppName + '_%s.log', [FToday]);
  ForceDirectories(Config.ConfigDir);
  ForceDirectories(Config.LogDir);

  InitConfig;
  sFileName := Config.ConfigDir + Config.AppName + '.config';
  IniFile := TIniFile.Create(sFileName);
  if not FileExists(sFileName) then
  begin
    WriteToFile(sFileName, ';***** XGMobileAD Congiguration file *****');
    WriteConfig;
  end;
  ReadConfig;

  CpuUsageData := WSCreateCpuUsageCounter(GetProcessIdByName(ExtractFileName(ParamStr(0)))); //CPU Usage Data
  CpuCount := WSGetNumberOfProcessors;
  CpuStatus := '';

  Self.Caption := Format('%s v%s', [LC_APP_TITLE, GetAppVersion(2)]);
  lbxLogView.Style := lbOwnerDrawFixed;
  lblMessage.Caption := '';
  pgcMain.ActivePage := tabLogView;
  pgcMainChange(pgcMain);

{$IFDEF RELEASE}
  sLinkFile := GetSysDir(CSIDL_DESKTOP) + '\엑스파트너스 모바일AD.lnk';
  if not FileExists(sLinkFile) then
  begin
    hIObject := CreateComObject(CLSID_ShellLink);
    hISLink := hIObject as IShellLink;
    hIPFile := hIObject as IPersistFile;
    with hISLink do
    begin
      //SetArguments('/run'); // 실행 파라메터
      //SetWorkingDirectory(PChar(GetSysDir(36))); //실행디렉토리
      SetPath(PChar(Config.HomeDir + LC_LAUNCHER_NAME)); //실행파일이름
      SetWorkingDirectory(PChar(Config.HomeDir)); //실행디렉토리
    end;
    hIPFile.Save(PChar(sLinkFile), False);
  end;
{$ENDIF}

  if Config.LogDelete then
    DeleteLog;
  tmrClock.Enabled := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AddLog('프로그램 종료', LC_COLOR_NORMAL);
  if Assigned(CheckConnectThread) then
    CheckConnectThread.Terminate;

  WSDestroyCpuUsageCounter(CpuUsageData);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TCPServer);
  FreeAndNil(CipherAES);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CloseAllowed;
end;

procedure TMainForm.pgcMainChange(Sender: TObject);
begin
  with (Sender as TPageControl) do
  begin
    btnLogClear.Visible := (ActivePage = tabLogView);
    btnGetToken.Visible := (ActivePage = tabConfig);
    btnSaveConfig.Visible := (ActivePage = tabConfig);
  end;
end;

procedure TMainForm.tmrClockTimer(Sender: TObject);
var
  sNow: string;
begin
  with TTimer(Sender) do
  try
    try
      Enabled := False;
      sNow := FormatDateTime('yyyymmddhhnnss', Now);
      lblClock.Caption := Format('%s-%s-%s %s:%s:%s',
        [sNow.Substring(0, 4), sNow.Substring(4, 2), sNow.Substring(6, 2),
         sNow.Substring(8, 2), sNow.Substring(10, 2), sNow.Substring(12, 2)]);
      if (FToday <> sNow.Substring(0, 8)) then
      begin
        FToday := sNow.Substring(0, 8);
        Config.LogFile := Format(Config.LogDir + Config.AppName + '_%s.log', [FToday]);
        //날짜가 바뀌면 데이터베이스 접속 강제 해제. CheckConnectThread에서 재접속 시도
        if DM.conLocalDB.Connected then
          DM.conLocalDB.Disconnect;
      end;

      if FIsFirst then
      begin
        FIsFirst := False;
        AddLog('프로그램 시작', LC_COLOR_NORMAL);
        DoAdminCall(0, '프로그램 시작');
        Interval := 500;
        DoInit;

        if not Assigned(CheckConnectThread) then
          CheckConnectThread := TCheckConnectThread.Create(True);
        if not CheckConnectThread.Started then
          CheckConnectThread.Start;

//        if FileExists(Config.LogFile) then
//          lbxLogView.Items.LoadFromFile(Config.LogFile);
      end;
    except
      on E: Exception do
        AddLog(E.Message, LC_COLOR_ERROR);
    end;
  finally
    Enabled := True and (not CloseAllowed);
  end;
end;

function TMainForm.DoInit: Boolean;
begin
  Result := False;
  try
    if (not DM.conLocalDB.Connected) and
       (not Config.TeeBoxADHost.IsEmpty) and
       (not Config.TeeBoxDBUserId.IsEmpty) then
    begin
      DM.conLocalDB.Options.LocalFailover := True;
      DM.conLocalDB.Options.DisconnectedMode := True;
      DM.conLocalDB.Open;
    end;

    if not ActiveServer then
      ActiveServer := True;

    Result := True;
  except
    on E: Exception do
      AddLog(Format('DoInit.Exception = %s', [E.Message]), LC_COLOR_ERROR);
  end;
end;

procedure TMainForm.btnAPITest1001Click(Sender: TObject);
var
  JO: TJSONObject;
  sBuffer: string;
begin
  JO := TJSONObject.Create;
  JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_STATUS_ALL)));
  JO.AddPair(TJSONPair.Create('floor_cd', '1'));
  JO.AddPair(TJSONPair.Create('teebox_no', ''));
  with TIdTCPClient.Create(nil) do
  try
    Host := Config.LocalIP;
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    sBuffer := JO.ToString;
//    AddLog(Format('Test(%d).Request = %s', [GC_MAPI_TEEBOX_STATUS_ALL, sBuffer]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(sBuffer), IndyTextEncoding_UTF8);
    sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
//    AddLog(Format('Test(%d).Response = %s', [GC_MAPI_TEEBOX_STATUS_ALL, CipherAES.Decrypt(sBuffer)]));
  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1002Click(Sender: TObject);
var
  JO: TJSONObject;
  sBuffer: string;
begin
  JO := TJSONObject.Create;
  JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_STATUS)));
  JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(1)));
  with TIdTCPClient.Create(nil) do
  try
    Host := Config.LocalIP;
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    sBuffer := JO.ToString;
//    AddLog(Format('Test(%d).Request = %s', [GC_MAPI_TEEBOX_STATUS, sBuffer]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(sBuffer), IndyTextEncoding_UTF8);
    sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
//    AddLog(Format('Test(%d).Response = %s', [GC_MAPI_TEEBOX_STATUS, CipherAES.Decrypt(sBuffer)]));
  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1003Click(Sender: TObject);
var
  JO: TJSONObject;
  sBuffer: string;
begin
  {
    "api_id": 1003,
    "teebox_no": "1",
    "member_no": "0000000000166",
    "member_nm": "황석원",
    "assign_min": 70,
    "prepare_min": 5,
    "purchase_cd": "12417153",
    "product_cd": "20454",
    "product_nm": "정회원/2008 12개월+장갑3,그립1",
    "seat_product_div": "R"
  }
  JO := TJSONObject.Create;
  JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_RESERVE)));
  JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(1)));
  JO.AddPair(TJSONPair.Create('member_no', '0000000000166'));
  JO.AddPair(TJSONPair.Create('member_nm', '황석원'));
  JO.AddPair(TJSONPair.Create('assign_min', TJSONNumber.Create(70)));
  JO.AddPair(TJSONPair.Create('prepare_min', TJSONNumber.Create(5)));
  JO.AddPair(TJSONPair.Create('purchase_cd', '12417153'));
  JO.AddPair(TJSONPair.Create('product_cd', '20454'));
  JO.AddPair(TJSONPair.Create('product_nm', '정회원/2008 12개월+장갑3,그립1'));
  JO.AddPair(TJSONPair.Create('seat_product_div', 'R'));

  with TIdTCPClient.Create(nil) do
  try
    Host := Config.LocalIP;
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    sBuffer := JO.ToString;
//    AddLog(Format('Test(%d).Request = %s', [GC_MAPI_TEEBOX_RESERVE, sBuffer]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(sBuffer), IndyTextEncoding_UTF8);
    sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
//    AddLog(Format('Test(%d).Response = %s', [GC_MAPI_TEEBOX_RESERVE, CipherAES.Decrypt(sBuffer)]));
  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1004Click(Sender: TObject);
var
  JO: TJSONObject;
  sBuffer: string;
begin
  if Config.TestReserveNo.IsEmpty then
  begin
    MessageDlg('테스트에 사용할 예약번호가 없습니다!', mtInformation, [mbOK], 0);
    Exit;
  end;

  JO := TJSONObject.Create;
  JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_MEMBER)));
  JO.AddPair(TJSONPair.Create('reserve_no', Config.TestReserveNo));
  with TIdTCPClient.Create(nil) do
  try
    Host := Config.LocalIP;
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    sBuffer := JO.ToString;
//    AddLog(Format('Test(%d).Request = %s', [GC_MAPI_TEEBOX_MEMBER, sBuffer]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(sBuffer), IndyTextEncoding_UTF8);
    sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
//    AddLog(Format('Test(%d).Response = %s', [GC_MAPI_TEEBOX_MEMBER, CipherAES.Decrypt(sBuffer)]));
  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1005Click(Sender: TObject);
var
  JO: TJSONObject;
  sBuffer: string;
begin
  if Config.TestReserveNo.IsEmpty then
  begin
    MessageDlg('테스트에 사용할 예약번호가 없습니다!', mtInformation, [mbOK], 0);
    Exit;
  end;

  JO := TJSONObject.Create;
  JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_CANCEL)));
  JO.AddPair(TJSONPair.Create('reserve_no', Config.TestReserveNo));
  with TIdTCPClient.Create(nil) do
  try
    Host := Config.LocalIP;
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    sBuffer := JO.ToString;
//    AddLog(Format('Test(%d).Request = %s', [GC_MAPI_TEEBOX_CANCEL, sBuffer]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(sBuffer), IndyTextEncoding_UTF8);
    sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
//    AddLog(Format('Test(%d).Response = %s', [GC_MAPI_TEEBOX_CANCEL, CipherAES.Decrypt(sBuffer)]));
  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  if (MessageDlg('프로그램을 종료하시겠습니까?', mtConfirmation, [mbOK, mbCancel], 0) = mrOk) then
  begin
    CloseAllowed := True;
    Close;
  end;
end;

procedure TMainForm.btnDeleteLogClick(Sender: TObject);
begin
  DeleteLog;
end;

procedure TMainForm.btnGetTokenClick(Sender: TObject);
begin
  Config.ServerHost := edtServerHost.Text;
  Config.ClientId := edtClientId.Text;
  Config.ClientKey := edtClientKey.Text;
  CheckConnectThread.Connected := False;
end;

procedure TMainForm.btnLogClearClick(Sender: TObject);
begin
  lbxLogView.Items.Clear;
end;

procedure TMainForm.btnSaveConfigClick(Sender: TObject);
begin
  UpdateConfig;
  WriteConfig;

  MessageDlg('설정값을 저장하였습니다.' + _CRLF +
    '설정값을 적용하려면 프로그램을 재시작하여 주십시오.', mtInformation, [mbOK], 0);
end;

procedure TMainForm.btnServerActiveClick(Sender: TObject);
begin
  ActiveServer := not ActiveServer;
  Config.ForceServerStop := not ActiveServer;
end;

procedure TMainForm.edtClientKeyDblClick(Sender: TObject);
begin
  with TLabeledEdit(Sender) do
    if (PasswordChar = #0) then
      PasswordChar := '*'
    else
      PasswordChar := #0;
end;

procedure TMainForm.lbxLogViewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  OldColor: TColor;
begin
  with (Control as TListBox).Canvas do
  begin
    OldColor := Font.Color;
    if (odSelected in State) then
    begin
      Brush.Color := $00D77800; //$004080FF;
      Font.Color := clWhite;
    end
    else
    begin
      Brush.Color := clWhite;
      Font.Color := TColor((Control as TListBox).Items.Objects[Index]);
    end;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
    Font.Color := OldColor;
  end;
end;

procedure TMainForm.TCPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  AddLog(Format('ServerStatus : %s', [AStatusText]));
end;

procedure TMainForm.TCPServerConnect(AContext: TIdContext);
begin
  AContext.Connection.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8;
  AContext.Connection.IOHandler.LargeStream := True;
//  AContext.Connection.IOHandler.ConnectTimeout := 30000;
//  AContext.Connection.IOHandler.ReadTimeout := 30000;
  AContext.Connection.IOHandler.ConnectTimeout := Config.MobileADTimeout;
  AContext.Connection.IOHandler.ReadTimeout := Config.MobileADTimeout;
  AContext.Binding.SetSockOpt(Id_SOL_SOCKET, Id_SO_SNDTIMEO, 15000);
end;

procedure TMainForm.TCPServerException(AContext: TIdContext; AException: Exception);
begin
  if (AContext.Connection = nil) or
     (AException is EIdSilentException) or
     (AException is EIdConnClosedGracefully) then
    Exit;

  AddLog(Format('ServerException : %s', [AException.Message]), LC_COLOR_ERROR);
end;

procedure TMainForm.TCPServerExecute(AContext: TIdContext);
var
  sReadBuffer, sWriteBuffer, sErrCode, sErrMsg: string;
begin
  try
    try
      if (AContext.Connection = nil) or
         (not AContext.Connection.Connected) then
        Exit;

      if AContext.Connection.IOHandler.InputBufferIsEmpty then
      begin
        AContext.Connection.IOHandler.CheckForDataOnSource(1000 div TCPServer.Contexts.Count);
        AContext.Connection.IOHandler.CheckForDisconnect(False, True);
        AContext.Connection.CheckForGracefulDisconnect(False);
        if AContext.Connection.IOHandler.InputBufferIsEmpty then
          Exit;
      end;

      AContext.Connection.IOHandler.MaxLineLength := MaxInt;
      sReadBuffer := Trim(AContext.Connection.IOHandler.ReadLn(IndyTextEncoding_UTF8));
      try
        if (Length(sReadBuffer) < 10) then
          raise Exception.Create(Format('Invalid Message Format = %s', [sReadBuffer]));

        sReadBuffer := CipherAES.Decrypt(sReadBuffer);
        if sReadBuffer.IsEmpty then
          raise Exception.Create('Decrypting Error');

        AddLog(Format('ServerExecute.Listen : %s', [sReadBuffer]));
        DoResponse(sReadBuffer, sWriteBuffer, sErrCode, sErrMsg);
        if (sErrCode = '0000') then
          AddLog(Format('DoResponse.Result : Code=%s, Result=%s', [sErrCode, sErrMsg]), LC_COLOR_NORMAL)
        else
          AddLog(Format('DoResponse.Result : Code=%s, Result=%s', [sErrCode, sErrMsg]), LC_COLOR_ERROR);
      except
        on E: Exception do
          sWriteBuffer := Format('{"result_cd":"9999", "result_msg":"잘못된 요청 전문(%s)", "result_data":[]}', [E.Message]);
      end;

      sWriteBuffer := CipherAES.Encrypt(sWriteBuffer);
      AContext.Connection.IOHandler.WriteLn(sWriteBuffer, IndyTextEncoding_UTF8);
    finally
      if (AContext.Connection <> nil) then
      begin
        AContext.Connection.IOHandler.InputBuffer.Clear;
        AContext.Connection.Disconnect;
      end;
    end;
  except
    on E: EIdConnClosedGracefully do;
    on E: EIdSocketError do;
    on E: Exception do
      AddLog(Format('ServerExecute.Exception : %s', [E.Message]), LC_COLOR_ERROR);
  end;
end;

function TMainForm.DoResponse(const AReadBuffer: string; var AWriteBuffer, AErrCode, AErrMsg: string): Boolean;
var
  JO, RO: TJSONObject;
  RA: TJSONArray;
  SS: TStringStream;
  nApiId: Integer;
  sAvailZoneCode, sErrCode, sErrMsg: string;
begin
  Result := False;
  AWriteBuffer := '';
  AErrMsg := '';
  AErrCode := '9999'; //General Error

  SS := nil;
  RO := nil;
  RA := nil;
  JO := TJSONObject.ParseJSONValue(AReadBuffer) as TJSONObject;
  EnterCriticalSection(DBQueryCS);
  try
    try
      nApiId := StrToIntDef(JO.GetValue('api_id').Value, 0);
      case nApiId of
        { 1001: 층별 또는 전체 타석가동상황 조회 }
        GC_MAPI_TEEBOX_STATUS_ALL:
        begin
          var sFloorCode := JO.GetValue('floor_cd').Value;
          var sTeeBoxNo := JO.GetValue('teebox_no').Value;

          if (not sTeeBoxNo.IsEmpty) and (StrToIntDef(sTeeBoxNo, -1) < 0) then
            raise Exception.Create(Format('[%d] 타석가동상황 조회 전문 오류. 층=%s 타석번호=%s', [nApiId, sFloorCode, sTeeBoxNo]));

          Result := DM.GetTeeBoxStatus(AWriteBuffer, sFloorCode, sTeeBoxNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] 타석가동상황 조회 실패. 층=%s 타석번호=%s 에러코드=%s %s', [nApiId, sFloorCode, sTeeBoxNo, AErrCode, AErrMsg]));
        end;

        { 1002: 타석별 타석가동상황 조회 }
        GC_MAPI_TEEBOX_STATUS:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, 0);

          Result := DM.GetTeeBoxStatusDetail(AWriteBuffer, nTeeBoxNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] 타석가동상황 조회 실패. 타석번호=%d 에러코드=%s %s', [nApiId, nTeeBoxNo, AErrCode, AErrMsg]));
        end;

        { 1003: 타석 예약 요청 }
        GC_MAPI_TEEBOX_RESERVE:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1);
          var sMemberNo := JO.GetValue('member_no').Value;
          var sMemberName := JO.GetValue('member_nm').Value;
          var nPrepareMin := StrToIntDef(JO.GetValue('prepare_min').Value, 5);
          var nAssignMin := StrToIntDef(JO.GetValue('assign_min').Value, 60);
          var nAssignBalls := 999;
          var sPurchaseCode := JO.GetValue('purchase_cd').Value;
          var sProdCode := JO.GetValue('product_cd').Value;
          var sProdName := JO.GetValue('product_nm').Value;
          var sTeeBoxProdDiv := JO.GetValue('seat_product_div').Value;
          var sUserId := JO.GetValue('user_id').Value;
          //안양CC에는 사용가능 구역구분 코드를 사용하지 않으므로 예외 처리
          try
            sAvailZoneCode := JO.GetValue('available_zone_cd').Value;
          except
          end;

          if (nTeeBoxNo < 0) or
             sProdCode.IsEmpty or
             sPurchaseCode.IsEmpty then
            raise Exception.Create(Format('[%d] 타석예약 요청 전문 오류. 타석번호=%d 상품코드=%s 구매번호=%s', [nApiId, nTeeBoxNo, sProdCode, sPurchaseCode]));

          Result := DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, True, sUserId, AErrCode, AErrMsg); //임시예약
          if not Result then
            raise Exception.Create(Format('[%d] 타석예약->임시예약 등록 실패. 타석번호=%d 에러코드=%s %s', [nApiId, nTeeBoxNo, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxReserve(AWriteBuffer, nTeeBoxNo, CCT_MOBILE, sMemberNo, sMemberName, sPurchaseCode,
                      sProdCode, sTeeBoxProdDiv, sAvailZoneCode, sProdName, nAssignMin, nPrepareMin, nAssignBalls, sUserId, AErrCode, AErrMsg);
          if not Result then
          begin
            if not DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, False, sUserId, sErrCode, sErrMsg) then //임시예약 취소
              AErrMsg := AErrMsg + _CRLF + Format('[%d] 임시예약 취소 실패. 타석번호=%d 에러코드=%s %s', [nApiId, nTeeBoxNo, sErrCode, sErrMsg]);

            raise Exception.Create(Format('[%d] 타석예약 등록 실패. 타석번호=%d 에러코드=%s %s', [nApiId, nTeeBoxNo, AErrCode, AErrMsg]));
          end;
        end;

        { 1004: 타석 예약 내역 조회 }
        GC_MAPI_TEEBOX_MEMBER:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          Result := DM.GetTeeBoxReservedDetail(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            AErrMsg := Format('[%d] 예약내역 조회 실패. 예약번호=%s 에러코드=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]);
        end;

        { 1005: 타석 예약 취소 요청 }
        GC_MAPI_TEEBOX_CANCEL:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          Result := DM.DoTeeBoxCancel(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            AErrMsg := Format('[%d] 예약취소 등록 실패. 예약번호=%s 에러코드=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]);
        end;

        { 1007: 노쇼 예약(끼워 넣기) 배정 등록 요청 }
        GC_MAPI_TEEBOX_NOSHOW_RESERVE:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, 0);
          var sReserveNo := JO.GetValue('reserve_no').Value;
          var sReserveDateTime := JO.GetValue('reserve_date').Value;
          var sReceiptNo := JO.GetValue('receipt_no').Value;
          var sPurchaseCode := JO.GetValue('purchase_cd').Value;
          var sProdCode := JO.GetValue('product_cd').Value;
          var sProdName := JO.GetValue('product_nm').Value;
          var sProdDiv := JO.GetValue('reserve_div').Value;
          var sReserveDate := JO.GetValue('reserve_date').Value;
          var sReserveRootDiv := JO.GetValue('reserve_root_div').Value;
          var nAssignMin := StrToIntDef(JO.GetValue('assign_min').Value, 0);
          var nAssignBalls := StrToIntDef(JO.GetValue('assign_balls').Value, 0);
          var nPrepareMin := StrToIntDef(JO.GetValue('prepare_min').Value, 0);
          var sMemberNo := JO.GetValue('member_no').Value;
          var sMemberName := JO.GetValue('member_nm').Value;
          var sXGUserKey := JO.GetValue('xg_user_key').Value;
          var sAffiliateCode := JO.GetValue('affiliate_cd').Value;
          var sUserId := JO.GetValue('user_id').Value;
          //안양CC에는 사용가능 구역구분 코드를 사용하지 않으므로 예외 처리
          try
            sAvailZoneCode := JO.GetValue('available_zone_cd').Value;
          except
          end;

          Result := DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, True, sUserId, AErrCode, AErrMsg); //임시예약
          if not Result then
            raise Exception.Create(Format('[%d] 타석예약->노쇼예약 등록 실패. 타석번호=%d 예약번호=%s 에러코드=%s %s', [nApiId, nTeeBoxNo, sReserveNo, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxReserveNoShow(AWriteBuffer, nTeeBoxNo,
            sReserveNo, sReserveDateTime, sReserveRootDiv, sReceiptNo, sPurchaseCode,
            sMemberNo, sMemberName, sXGUserKey, sProdDiv, sProdCode, sProdName, sAvailZoneCode, sAffiliateCode,
            nAssignMin, nPrepareMin, nAssignBalls, sUserId, AErrCode, AErrMsg);
          if not Result then
            AErrMsg := Format('[%d] 노쇼 예약 등록 실패. 타석번호=%d 예약번호=%s 에러코드=%s %s', [nApiId, nTeeBoxNo, sReserveNo, AErrCode, AErrMsg]);
        end;

        { 8007: (실내골프연습장) 시뮬레이터PC 제어(셧다운, 리부팅), 프로그램 업데이트 }
        GC_MAPI_TEEBOX_CONTROL_INDOOR:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1);
          var nMethod := StrToIntDef(JO.GetValue('method').Value, -1);
          var sMethod := '제어';

          case nMethod of
            0: sMethod := '셧다운';
            1: sMethod := '리부팅';
            2: sMethod := '에이전트 업데이트';
          end;

          if (nTeeBoxNo < 0) or
             (nMethod < 0) then
            raise Exception.Create(Format('[%d] 타석기 %s 요청 실패. 타석번호=%d 제어코드=%d', [nApiId, sMethod, nTeeBoxNo, nMethod]));

          Result := DM.DoTeeBoxMachineControl_InDoor(AWriteBuffer, nTeeBoxNo, nMethod, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] 타석기 %s 요청 실패. 타석번호=%d 제어코드=%d 에러코드=%s %s', [nApiId, sMethod, nTeeBoxNo, nMethod, AErrCode, AErrMsg]));
        end;

        { 8008: (실내골프연습장) 장치 원격 제어 }
        GC_MAPI_DEVICE_CONTROL_INDOOR:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1); //0:전체타석
          var nDeviceDiv := StrToIntDef(JO.GetValue('device_div').Value, -1);
          var nControlDiv := StrToIntDef(JO.GetValue('control_div').Value, -1);
          var sCommand := JO.GetValue('command').Value;
          var sDeviceDiv := '';
          var sControlDiv := '';

          case nDeviceDiv of
            GC_MPAI_DEVICE_LBP: sDeviceDiv := '빔 프로젝터';
          end;
          case nControlDiv of
            GC_MPAI_CONTROL_LBP_POWER: sControlDiv := '전원제어';
          end;

          if sDeviceDiv.IsEmpty or
             sControlDiv.IsEmpty or
             (nTeeBoxNo < 0) or
             (nDeviceDiv < 0) or
             (nControlDiv < 0) then
            raise Exception.Create(Format('[%d] %s %s 요청 전문 오류. 타석번호=%d 제어코드=%s', [nApiId, sDeviceDiv, sControlDiv, nTeeBoxNo, sCommand]));

          Result := DM.DoTeeBoxDeviceControl_InDoor(AWriteBuffer, nTeeBoxNo, nDeviceDiv, nControlDiv, sCommand, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] %s %s 요청 실패. 타석번호=%d 제어코드=%s 에러코드=%s %s', [nApiId, sDeviceDiv, sControlDiv, nTeeBoxNo, sCommand, AErrCode, AErrMsg]));
        end;
      else
        AErrCode := '9001';
        AErrMsg := Format('[%d] 잘못된 API 식별자.', [nApiId]);
      end;

      SS := TStringStream.Create(AWriteBuffer, TEncoding.UTF8);
      SS.SaveToFile(Config.LogDir + Format('%s_API_%d.Response.json', [Config.AppName, nApiId]));
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('DoResponse.Exception : %s', [E.Message]), LC_COLOR_ERROR);
      end;
    end;

    if not Result then
    begin
      try
        RO := TJSONObject.Create;
        RA := TJSONArray.Create;
        RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
        RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
        RO.AddPair(TJSONPair.Create('result_data', RA));
        AWriteBuffer := RO.ToString;
      finally
        FreeAndNilJSONObject(RA);
        FreeAndNilJSONObject(RO);
      end;
    end;
  finally
    if Assigned(SS) then
      FreeAndNil(SS);
    LeaveCriticalSection(DBQueryCS);
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.InitConfig;
begin
  with Config do
  begin
    StoreCode := '';
    AutoRun := False;
    LogDelete := True;
    LogDeleteDays := 30;
    TestReserveNo := '';

    MobileADPort := CCD_MOBILE_AD_PORT;
    MobileADTimeout := 5000;

    ServerHost := GCD_API_SERVER_HOST;
    ClientId := '';
    ClientKey := '';
    CheckAlive := False;
    LocalIP := GetIPAddress;

    TeeBoxADHost := CCD_TEEBOX_HOST;
    TeeBoxADPort := CCD_TEEBOX_API_PORT;
    TeeBoxDBPort := CCD_TEEBOX_DB_PORT;
    TeeBoxDBUserId := CCD_TEEBOX_USER;
    TeeBoxDBPwd := CCD_TEEBOX_PWD;
    TeeBoxDBCatalog := CCD_TEEBOX_DB;

    AdminCallEnabled := False;
    AdminCallHost := Config.LocalIP;
    AdminCallPort := CCD_ADMINCALL_PORT;
  end;
end;

procedure TMainForm.ReadConfig;
begin
  with Config do
  begin
    AutoRun := IniFile.ReadBool('Startup', 'AutoRun', AutoRun);
    LogDelete := IniFile.ReadBool('Startup', 'LogDelete', LogDelete);
    LogDeleteDays := IniFile.ReadInteger('Startup', 'LogDeleteDays', LogDeleteDays);

    MobileADPort := IniFile.ReadInteger('MobileAD', 'Port', MobileADPort);
    MobileADTimeout := IniFile.ReadInteger('MobileAD', 'Timeout', MobileADTimeout);

    ServerHost := IniFile.ReadString('Server', 'Host', '');
    ClientId := IniFile.ReadString('Server', 'ClientId', '');
    ClientKey := StrDecrypt(IniFile.ReadString('Server', 'ClientKey', ''));
    CheckAlive := IniFile.ReadBool('Server', 'CheckAlive', CheckAlive);

    TeeBoxADHost := IniFile.ReadString('TeeBoxAD', 'Host', TeeBoxADHost);
    TeeBoxADPort := IniFile.ReadInteger('TeeBoxAD', 'Port', TeeBoxADPort);

    TeeBoxDBPort := IniFile.ReadInteger('TeeBoxDB', 'Port', TeeBoxDBPort);
    TeeBoxDBUserId := IniFile.ReadString('TeeBoxDB', 'UserId', TeeBoxDBUserId);
    TeeBoxDBPwd := StrDecrypt(IniFile.ReadString('TeeBoxDB', 'Pwd', ''));
    TeeBoxDBCatalog := IniFile.ReadString('TeeBoxDB', 'Catalog', TeeBoxDBCatalog);

    AdminCallEnabled := IniFile.ReadBool('AdminCall', 'Enabled', AdminCallEnabled);
    AdminCallHost := IniFile.ReadString('AdminCall', 'Host', AdminCallHost);
    AdminCallPort := IniFile.ReadInteger('AdminCall', 'Port', AdminCallPort);

    ckbAutoRun.Checked := AutoRun;
    ckbLogDelete.Checked := LogDelete;
    edtLogDeleteDays.Value := LogDeleteDays;

    edtMobileADPort.Value := MobileADPort;
    edtServerHost.Text := ServerHost;
    edtClientId.Text := ClientId;
    edtClientKey.Text := ClientKey;
    ckbCheckAlive.Checked := CheckAlive;

    edtTeeBoxADHost.Text := TeeBoxADHost;
    edtTeeBoxADPort.Value := TeeBoxADPort;
    edtTeeBoxDBPort.Value := TeeBoxDBPort;
    edtTeeBoxDBUserId.Text := TeeBoxDBUserId;
    edtTeeBoxDBPwd.Text := TeeBoxDBPwd;
    edtTeeBoxDBCatalog.Text := TeeBoxDBCatalog;

    ckbAdminCallActive.Checked := AdminCallEnabled;
    edtAdminCallHost.Text := AdminCallHost;
    edtAdminCallPort.Value := AdminCallPort;
  end;
end;

procedure TMainForm.UpdateConfig;
begin
  with Config do
  begin
    AutoRun := ckbAutoRun.Checked;
    LogDelete := ckbLogDelete.Checked;
    LogDeleteDays := edtLogDeleteDays.Value;

    MobileADPort := edtMobileADPort.Value;
    MobileADTimeout := edtMobileADTimeout.Value;

    ServerHost := edtServerHost.Text;
    ClientId := edtClientId.Text;
    ClientKey := edtClientKey.Text;
    CheckAlive := ckbCheckAlive.Checked;

    TeeBoxADHost := edtTeeBoxADHost.Text;
    TeeBoxADPort := edtTeeBoxADPort.Value;
    TeeBoxDBPort := Trunc(edtTeeBoxDBPort.Value);
    TeeBoxDBUserId := edtTeeBoxDBUserId.Text;
    TeeBoxDBPwd := edtTeeBoxDBPwd.Text;
    TeeBoxDBCatalog := edtTeeBoxDBCatalog.Text;

    AdminCallEnabled := ckbAdminCallActive.Checked;
    AdminCallHost := edtAdminCallHost.Text;
    AdminCallPort := edtAdminCallPort.Value;
  end;
end;

procedure TMainForm.WriteConfig;
begin
  with Config do
  try
    IniFile.WriteBool('Startup', 'AutoRun', AutoRun);
    IniFile.WriteBool('Startup', 'LogDelete', LogDelete);
    IniFile.WriteInteger('Startup', 'LogDeleteDays', LogDeleteDays);

    IniFile.WriteInteger('MobileAD', 'Port', MobileADPort);
    IniFile.WriteInteger('MobileAD', 'Timeout', MobileADTimeout);

    IniFile.WriteString('Server', 'Host', ServerHost);
    IniFile.WriteString('Server', 'ClientId', ClientId);
    IniFile.WriteString('Server', 'ClientKey', StrEncrypt(ClientKey));
    IniFile.WriteBool('Server', 'CheckAlive', CheckAlive);

    IniFile.WriteString('TeeBoxAD', 'Host', TeeBoxADHost);
    IniFile.WriteInteger('TeeBoxAD', 'Port', TeeBoxADPort);
    IniFile.WriteInteger('TeeBoxDB', 'Port', TeeBoxDBPort);
    IniFile.WriteString('TeeBoxDB', 'UserId', TeeBoxDBUserId);
    IniFile.WriteString('TeeBoxDB', 'Pwd', StrEncrypt(TeeBoxDBPwd));
    IniFile.WriteString('TeeBoxDB', 'Catalog', TeeBoxDBCatalog);

    IniFile.WriteBool('AdminCall', 'Enabled', AdminCallEnabled);
    IniFile.WriteString('AdminCall', 'Host', AdminCallHost);
    IniFile.WriteInteger('AdminCall', 'Port', AdminCallPort);

{$IFDEF RELEASE}
    if AutoRun then
      RunOnWindownStart(LC_LAUNCHER_TITLE, Config.HomeDir + LC_LAUNCHER_NAME, False)
    else
      RemoveFromRunOnWindowStart(LC_LAUNCHER_TITLE);
{$ENDIF}
  except
    on E: Exception do
      AddLog(Format('WriteConfig.Exception : %s', [E.Message]), LC_COLOR_ERROR);
  end;
end;

procedure TMainForm.SetServerConnected(const AConnected: Boolean);
begin
  SetLed(LC_LED_SERVER, AConnected);
  if AConnected then
  begin
    edtStoreCode.Text := Config.StoreCode;
    AddLog('파트너센터 서버에 접속 되었습니다.');
    AddLog(Format('AES256 SecureKey : %s', [CipherAES.SecureKey]), LC_COLOR_NORMAL);
    AddLog(Format('AES256 IV : %s', [CipherAES.InitVector]), LC_COLOR_NORMAL);
  end
  else
    AddLog('파트너센터 서버에 접속할 수 없습니다.', LC_COLOR_ERROR);
end;

procedure TMainForm.SetActiveServer(const AValue: Boolean);
begin
  if (FActiveServer <> AValue) then
  begin
    FActiveServer := AValue;
    if FActiveServer then
      TCPServer.DefaultPort := Config.MobileADPort;

    TCPServer.Active := AValue;
    IndyAntiFreeze.Active := AValue;
    pbrMobileAD.Enabled := AValue;
    SetLed(LC_LED_MOBILE_AD, AValue);
    btnServerActive.Caption := '서버 ' + IIF(AValue, '중지', '시작');
    AddLog(Format('모바일AD 서버가 %s 되었습니다. (IP: %s, Port: %d, Host: %s)', [IIF(AValue, '시작', '중지'), Config.LocalIP, Config.MobileADPort, GetLocalHostName]), clGreen);
  end;
end;

procedure TMainForm.SetCpuStatus(const AValue: string);
begin
  FCpuStatus := AValue;
  Self.Caption := Format('%s v%s %s', [LC_APP_TITLE, FAppVersion, FCpuStatus]);
end;

procedure TMainForm.DeleteLog;
var
  SR: TSearchRec;
  bFound: Boolean;
  sBaseDate, sLogDate: string;
  nResult, nPos: Integer;
begin
  nResult := 0;
  sBaseDate := FormatDateTime('yyyymmdd', IncDay(Now, -Config.LogDeleteDays));
  nPos := Length(Config.AppName) + 2; //XGMobileAD_YYYYMMDD.log
  bFound := (FindFirst(Config.LogDir + Config.AppName + '_*.log', faAnyFile - faDirectory, SR) = 0);
  try
    while bFound do
    begin
      sLogDate := Copy(SR.Name, nPos, 8);
      if (sLogDate >= '20000101') and (sLogDate <= sBaseDate) then
      begin
        DeleteFile(Config.LogDir + SR.Name);
        Inc(nResult);
      end;
      bFound := (FindNext(SR) = 0);
    end;

    if (nResult > 0) then
      AddLog(Format('%d일 이전에 생성된 로그파일 %d개를 삭제하였습니다.', [Config.LogDeleteDays, nResult]));
  finally
    SysUtils.FindClose(SR);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function IsNextDay(const ACheckTime: string): Boolean; //nn:ss
begin
  Result := (Config.StoreStartTime > Config.StoreEndTime) and
            (ACheckTime >= '00:00') and
            (ACheckTime <= Config.StoreEndTime);
end;

procedure AddLog(const ALogText: string; const AColor: TColor; const AWriteToFile: Boolean);
begin
  MainForm.lbxLogView.Items.BeginUpdate;
  try
    MainForm.lbxLogView.Items.AddObject(Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), ALogText]), TObject(AColor));
    MainForm.lbxLogView.ItemIndex := Pred(MainForm.lbxLogView.Items.Count);
    MainForm.lblMessage.Caption := ALogText;
    if AWriteToFile then
      UpdateLog(Config.LogFile, ALogText);
    if (MainForm.lbxLogView.Items.Count > 1024) then
      MainForm.lbxLogView.Items.Delete(0);
  finally
    MainForm.lbxLogView.Items.EndUpdate;
  end;
end;

procedure UpdateLog(const AFileName, AStr: string; const ALineBreak: Boolean=False);
begin
  EnterCriticalSection(LogCS);
  try
    WriteToFile(AFileName, '[' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ']' + IIF(ALineBreak, sLineBreak, ' ') + AStr);
  finally
    LeaveCriticalSection(LogCS);
  end;
end;

procedure SetLed(const AKind: Integer; const AIsActive: Boolean; const AIsError: Boolean);
begin
  case AKind of
    LC_LED_MOBILE_AD:
      begin
        MainForm.ledMobileAD.LedValue := AIsActive;
        MainForm.ledMobileAD.Enabled := not AIsError;
      end;
    LC_LED_SERVER:
      begin
        MainForm.ledServer.LedValue := AIsActive;
        MainForm.ledServer.Enabled := not AIsError;
      end;
    LC_LED_TEEBOX_AD:
      begin
        MainForm.ledTeeBoxAD.LedValue := AIsActive;
        MainForm.ledTeeBoxAD.Enabled := not AIsError;
      end;
    LC_LED_TEEBOX_DB:
      begin
        MainForm.ledTeeBoxDB.LedValue := AIsActive;
        MainForm.ledTeeBoxDB.Enabled := not AIsError;
      end;
    LC_LED_ADMIN_CALL:
      begin
        MainForm.ledAdminCall.LedValue := AIsActive;
        MainForm.ledAdminCall.Enabled := not AIsError;
      end;
  end;
end;

procedure DoAdminCall(const AErrorCode: Integer; const AMsgText: string);
var
  JO: TJSONObject;
begin
  if not Config.AdminCallEnabled then
    Exit;

  try
    JO := TJSONObject.Create;
    with TIdTCPClient.Create(nil) do
    try
      JO.AddPair(TJSONPair.Create('error_cd', FormatFloat('0000', AErrorCode)));
      JO.AddPair(TJSONPair.Create('error_msg', AMsgText));
      JO.AddPair(TJSONPair.Create('sender_id', '모바일AD'));
      Host := Config.AdminCallHost;
      Port := Config.AdminCallPort;
      ConnectTimeout := Config.MobileADTimeout;
      ReadTimeout := Config.MobileADTimeout;
      Connect;
      IOHandler.WriteLn(JO.ToString, IndyTextEncoding_UTF8);
      SetLed(LC_LED_ADMIN_CALL, True);
    finally
      Disconnect;
      Free;
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      SetLed(LC_LED_ADMIN_CALL, False, True);
      AddLog(Format('DoAdminCall.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
  end;
end;

{ TCheckConnectThread }

constructor TCheckConnectThread.Create(const ACreateSuspended: Boolean);
begin
  inherited Create(ACreateSuspended);

  FreeOnTerminate := True;
  FConnected := False;
  FCheckAliveMinutes := 5; //분
  FCheckAliveLastWorked := Now;
  FCheckConnectInterval := 5000; //5초
  FCheckConnectLastworked := (Now - 1);
  FCheckCpuUsageInterval := 60000; //1분
  FCheckCpuUsageLastWorked := (Now - 1);
end;

destructor TCheckConnectThread.Destroy;
begin

  inherited;
end;

procedure TCheckConnectThread.Execute;
begin
  inherited;

  repeat
    Synchronize(
      procedure
      var
        sToken, sSecureKey, sErrMsg: string;
        nUsage: Single;
      begin
        try
          if not Connected then
          begin
            if Config.ClientId.IsEmpty or
               Config.ClientKey.IsEmpty then
              Exit;

            if (MilliSecondsBetween(FCheckConnectLastWorked, Now) > CheckConnectInterval) then
            begin
              FCheckConnectLastWorked := Now;
              Config.Token := '';
              if not DM.GetToken(Config.ClientId, Config.ClientKey, sToken, sErrMsg) then
                raise Exception.Create(sErrMsg);

              Config.Token := sToken;
              if not DM.CheckToken(Config.Token, Config.ClientId, Config.ClientKey, sErrMsg) then
                raise Exception.Create(sErrMsg);

              if not DM.GetTerminalInfo(sErrMsg) then
                raise Exception.Create(sErrMsg);

              if not DM.GetStoreInfo(sErrMsg) then
                raise Exception.Create(sErrMsg);

              if not Assigned(CipherAES) then
              begin
                sSecureKey := StringReplace(Config.ClientKey, '-', '', [rfReplaceAll]);
                CipherAES := TCipherAES.Create(
                  sSecureKey,
                  256,
                  sSecureKey.Substring(0, 16),
                  TEncoding.UTF8,
                  TChainingMode.cmCBC,
                  TPaddingMode.pmPKCS7);
              end;

              //파트너센터 재접속 후엔 반드시 실행
              FCheckAliveLastWorked := Now;
              DM.CheckAlive;

              if not DM.conLocalDB.Connected then
              begin
                DM.conLocalDB.Options.LocalFailover := True;
                DM.conLocalDB.Options.DisconnectedMode := True;
                DM.conLocalDB.Open;
                AddLog('타석기 DB에 접속 되었습니다.');
              end;

              SendMessage(MainForm.Handle, WM_SERVER_CONNECTED, 0, 0);
              Connected := True;
            end;
          end;

          if Connected and
             Config.CheckAlive and
             (MinutesBetween(FCheckAliveLastWorked, Now) >= FCheckAliveMinutes) then
          begin
            FCheckAliveLastWorked := Now;
            DM.CheckAlive;
          end;

          try
            if (MilliSecondsBetween(FCheckCpuUsageLastWorked, Now) > CheckCpuUsageInterval) then
            begin
              FCheckCpuUsageLastWorked := Now;
              nUsage := (WSGetCpuUsage(CpuUsageData) / CpuCount);
              if (nUsage < 0) then
                nUsage := 0;
              MainForm.CpuStatus := Format('| CPU Usage: %f%% (%d Processors, %d Threads)', [nUsage, CpuCount, MainForm.TCPServer.Contexts.Count]);

              if MainForm.ActiveServer and
                 (MainForm.TCPServer.Contexts.Count > 5) and
                 (nUsage > 50) then
                MainForm.ActiveServer := False;

              if (not Config.ForceServerStop) and
                 (not MainForm.ActiveServer) and
                 (nUsage < 10) and
                 (MainForm.TCPServer.Contexts.Count = 0) then
                MainForm.ActiveServer := True;
            end;
          except
          end;
        except
          on E: Exception do
          begin
            AddLog(Format('ServerConnectThread.Exception : %s', [E.Message]), LC_COLOR_ERROR);
            DoAdminCall(ERROR_ADMINCALL, E.Message);
          end;
        end;
      end);

    WaitForSingleObject(Handle, 1000);
  until Terminated and (not CloseAllowed);
end;

(*
procedure TCheckConnectThread.DoCheckAliveLocalServer;
var
  JO: HCkJsonObject;
  sBuffer: string;
begin
  Global.AddLog('로컬 서버 접속 체크');
  JO := CkJsonObject_Create;
  with TCPClient do
  try
    CkJsonObject_AddIntAt(JO, -1, 'api', 9901);
    sBuffer := CkJsonObject__emit(JO);
    try
      Host := Global.LocalServer.Host;
      Port := Global.LocalServer.Port;
      ConnectTimeout := Config.MobileADTimeout;
      ReadTimeout := Config.MobileADTimeout;
      if not Connected then
        Connect;
      IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      sBuffer := IOHandler.ReadLn(IndyTextEncoding_UTF8);
      if sBuffer.IsEmpty then
        raise Exception.Create('로컬 서버로부터의 응답이 없습니다.');
      if not CkJsonObject_Load(JO, PWideChar(sBuffer)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      Global.AddLog('로컬 서버 접속 체크 응답 = ' + sBuffer);
    except
      on E: Exception do
      begin
        Disconnect;
        Global.AddLog('로컬 서버 접속 체크 실패 = ' + E.Message);
      end;
    end;
  finally
    if Assigned(JO) then
      CkJsonObject_Dispose(JO);
  end;
end;
*)

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(DBQueryCS);
  InitializeCriticalSection(LogCS);
finalization
  DeleteCriticalSection(DBQueryCS);
  DeleteCriticalSection(LogCS);
end.
