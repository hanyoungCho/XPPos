(*******************************************************************************

  Project     : ELOOM �ǳ����������� ���� ���� �ý���
  Title       : ����� AD ���� ȭ��
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-08-01   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2021 All rights reserved.

  [�������]

  ELOOM API Server: https://api.eloomgolf.com
  ELOOM API Key: owgss0w4008wk0cgks8cog00kok0k0kw40sk4kck

*******************************************************************************)
unit uELMADMain;

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
{$I ..\common\ELOOM.inc}

const
	{ StartUp Registry Key }
  LC_APP_TITLE = 'MobileAD for ELOOM GOLF';
  LC_LAUNCHER_TITLE = 'ELOOM MobileAD Launcher';
  LC_LAUNCHER_NAME = 'XGLauncher.exe';

	{ Status LED }
  LC_LED_MOBILE_AD  = 1;
  LC_LED_SERVER     = 2;
  LC_LED_TEEBOX_AD  = 3;
  LC_LED_TEEBOX_DB  = 4;

	{ Status Color }
  LC_COLOR_ON     = $0000FF00; //Lime
  LC_COLOR_OFF    = $00C0C0C0; //Silver
  LC_COLOR_ERROR  = $000000FF; //Red
  LC_COLOR_NORMAL = $00FF6600; //SkyBlue

  { Windows Messages }
  WM_SERVER_CONNECTED = WM_USER + 3000;

type
  { ���� ���� ������ }
  TServerConnectThread = class(TThread)
  private
    FConnected: Boolean;
    FCheckConnectInterval: Integer; //�и���
    FCheckConnectLastWorked: TDateTime;
    FCheckCPUUsageInterval: Integer; //�и���
    FCheckCPUUsageLastWorked: TDateTime;
  protected
    procedure Execute; override;
  published
    constructor Create(const ACreateSuspended: Boolean);
    destructor Destroy; override;

    property Connected: Boolean read FConnected write FConnected;
    property CheckConnectInterval: Integer read FCheckConnectInterval write FCheckConnectInterval;
    property CheckCPUUsageInterval: Integer read FCheckCPUUsageInterval write FCheckCPUUsageInterval;
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
    ledServer: TcyLed;
    ledTeeBoxAD: TcyLed;
    ledMobileAD: TcyLed;
    lblMobileAD: TLabel;
    gbxServer: TGroupBox;
    edtServerHost: TLabeledEdit;
    edtApiKey: TLabeledEdit;
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
    tabTest: TTabSheet;
    panTestAPI: TPanel;
    btnAPITest1001: TButton;
    btnAPITest1002: TButton;
    btnAPITest1003: TButton;
    btnAPITest1004: TButton;
    btnAPITest1005: TButton;
    btnAPITest8001: TButton;
    panTestCipher: TPanel;
    mmoTestSource: TMemo;
    mmoTestTarget: TMemo;
    panTestToolbar: TPanel;
    btnTestDecrypt: TButton;
    btnTestEncrypt: TButton;
    btnTestSwap: TButton;
    btnTestClear: TButton;
    panTestTitle: TPanel;
    btnAPITest8007: TButton;
    imgLogo: TImage;
    Label6: TLabel;
    edtMobileADTimeout: TcyEditInteger;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pgcMainChange(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnLogClearClick(Sender: TObject);
    procedure lbxLogViewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure TCPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure btnDeleteLogClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnServerActiveClick(Sender: TObject);
    procedure btnAPITest1001Click(Sender: TObject);
    procedure btnAPITest1003Click(Sender: TObject);
    procedure btnAPITest1002Click(Sender: TObject);
    procedure btnAPITest1004Click(Sender: TObject);
    procedure btnAPITest1005Click(Sender: TObject);
    procedure TCPServerException(AContext: TIdContext; AException: Exception);
    procedure btnAPITest8001Click(Sender: TObject);
    procedure btnTestDecryptClick(Sender: TObject);
    procedure btnTestEncryptClick(Sender: TObject);
    procedure btnTestClearClick(Sender: TObject);
    procedure btnTestSwapClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAPITest8007Click(Sender: TObject);
  private
    { Private declarations }
    FIsFirst: Boolean;
    FToday: string;
    FActiveServer: Boolean;
    FAppVersion: string;
    FCpuStatus: string;

    function DoInit: Boolean;
    function DoResponse(const AReadBuffer: string; var AWriteBuffer, AErrCode, AErrMsg: string): Boolean;
    procedure DoTestAPI(const AAPIId: Integer; const ARequest: string);
    procedure DeleteLog;
    procedure SetServerConnected(const AConnected: Boolean);
    procedure SetActiveServer(const AValue: Boolean);
    procedure SetCpuStatus(const AValue: string);
  protected
    { Protected declarations }
    procedure WndProc(var AMsg: TMessage); override;
  public
    { Public declarations }
    procedure InitConfig;
    procedure WriteConfig;
    procedure ReadConfig;
    procedure UpdateConfig;

    property ActiveServer: Boolean read FActiveServer write SetActiveServer;
    property CpuStatus: string read FCpuStatus write SetCpuStatus;
  end;

var
  MainForm: TMainForm;
  IniFile: TIniFile;
  ServerConnectThread: TServerConnectThread;
  DBQueryCS: TRTLCriticalSection;
  LogCS: TRTLCriticalSection;
  CloseAllowed: Boolean=False;
  CpuUsageData: PCpuUsageData;
  CpuCount: Integer;
  CipherAES: TCipherAES;

function IsNextDay(const ACheckTime: string): Boolean; //nn:ss
procedure AddLog(const ALogText: string; const AColor: TColor=clBlack; const AWriteToFile: Boolean=True);
procedure UpdateLog(const AFileName, AStr: string; const ALineBreak: Boolean=False);
procedure SetLed(const AKind: Integer; const AIsActive: Boolean; const AIsError: Boolean=False);

implementation

uses
{$IFDEF RELEASE}
  Winapi.ShlObj, System.Win.ComObj, Winapi.ActiveX,
{$ENDIF}
  Dialogs, UITypes, JSON, DateUtils, StrUtils,
  IdGlobal, IdException, IdTCPConnection, IdTCPClient, IdStack, IdStackConsts,
  uELMADDM, uXGCommonLib, uWaitMsg, uGetWinHandle, uNetLib;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_SERVER_CONNECTED:
      SetServerConnected(True);
  end;

  inherited WndProc(AMsg);
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
  CpuUsageData := WSCreateCpuUsageCounter(GetProcessIdByName(ExtractFileName(ParamStr(0)))); //CPU Usage Data
  CpuCount := WSGetNumberOfProcessors;
  FIsFirst := True;
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
    WriteToFile(sFileName, ';***** ELOOM MobileAD Congiguration file *****');
    WriteConfig;
  end;
  ReadConfig;

  FAppVersion := GetAppVersion(2);
  CpuStatus := '';

	Self.Caption := Format('%s v%s', [LC_APP_TITLE, GetAppVersion(2)]);
  lbxLogView.Style := lbOwnerDrawFixed;
  lblMessage.Caption := '';
  pgcMain.ActivePage := tabLogView;
  pgcMainChange(pgcMain);

{$IFDEF RELEASE}
  sLinkFile := GetSysDir(CSIDL_DESKTOP) + '\�̷���� �����AD.lnk';
  if not FileExists(sLinkFile) then
  begin
    hIObject := CreateComObject(CLSID_ShellLink);
    hISLink := hIObject as IShellLink;
    hIPFile := hIObject as IPersistFile;
    with hISLink do
    begin
      //SetArguments('/run'); // ���� �Ķ����
      //SetWorkingDirectory(PChar(GetSysDir(36))); //������丮
      SetPath(PChar(Config.HomeDir + LC_LAUNCHER_NAME)); //���������̸�
      SetWorkingDirectory(PChar(Config.HomeDir)); //������丮
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
  if Assigned(ServerConnectThread) then
    ServerConnectThread.Terminate;

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
      end;

      if FIsFirst then
      begin
        FIsFirst := False;
        AddLog('���α׷� ����', LC_COLOR_NORMAL);
        Interval := 500;
        DoInit;

        if not Assigned(ServerConnectThread) then
          ServerConnectThread := TServerConnectThread.Create(True);
        if (not ServerConnectThread.Started) then
          ServerConnectThread.Start;

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

procedure TMainForm.DoTestAPI(const AAPIId: Integer; const ARequest: string);
var
  sResponse: string;
begin
  with TIdTCPClient.Create(nil) do
  try
    Host := '127.0.0.1';
    Port := Config.MobileADPort;
    ConnectTimeout := Config.MobileADTimeout;
    ReadTimeout := Config.MobileADTimeout;
    AddLog(Format('DoTestAPI(%d).Request = %s', [AAPIId, ARequest]));
    Connect;
    IOHandler.MaxLineLength := MaxInt;
    IOHandler.WriteLn(CipherAES.Encrypt(ARequest), IndyTextEncoding_UTF8);
    sResponse := IOHandler.ReadLn(IndyTextEncoding_UTF8);
    AddLog(Format('DoTestAPI(%d).Response = %s', [AAPIId, CipherAES.Decrypt(sResponse)]));
  finally
    Disconnect;
    Free;
  end;
end;

procedure TMainForm.btnAPITest1001Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_STATUS_ALL)));
    JO.AddPair(TJSONPair.Create('floor_cd', TJSONNumber.Create(1)));
    JO.AddPair(TJSONPair.Create('teebox_no', ''));
    DoTestAPI(GC_MAPI_TEEBOX_STATUS_ALL, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1002Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_STATUS)));
    JO.AddPair(TJSONPair.Create('teebox_no', '1'));
    DoTestAPI(GC_MAPI_TEEBOX_STATUS, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1003Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  {
    "api_id": 1003,
    "teebox_no": "1",
    "member_no": "0000000000166",
    "member_nm": "ȫ�浿",
    "assign_min": 70,
    "prepare_min": 5,
    "purchase_cd": "12417153",
    "product_cd": "20454",
    "product_nm": "��ȸ��/2008 12����+�尩3,�׸�1",
    "seat_product_div": "R"
  }
  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_RESERVE)));
    JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(1)));
    JO.AddPair(TJSONPair.Create('member_no', '0000000000166'));
    JO.AddPair(TJSONPair.Create('member_nm', 'Ȳ����'));
    JO.AddPair(TJSONPair.Create('assign_min', TJSONNumber.Create(70)));
    JO.AddPair(TJSONPair.Create('prepare_min', TJSONNumber.Create(5)));
    JO.AddPair(TJSONPair.Create('purchase_cd', '12417153'));
    JO.AddPair(TJSONPair.Create('product_cd', '20454'));
    JO.AddPair(TJSONPair.Create('product_nm', '��ȸ��/2008 12����+�尩3,�׸�1'));
    JO.AddPair(TJSONPair.Create('seat_product_div', 'R'));
    DoTestAPI(GC_MAPI_TEEBOX_RESERVE, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1004Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  if Config.TestReserveNo.IsEmpty then
  begin
    MessageDlg('�׽�Ʈ�� ����� �����ȣ�� �����ϴ�!', mtInformation, [mbOK], 0);
    Exit;
  end;

  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_MEMBER)));
    JO.AddPair(TJSONPair.Create('reserve_no', Config.TestReserveNo));
    DoTestAPI(GC_MAPI_TEEBOX_MEMBER, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest1005Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  if Config.TestReserveNo.IsEmpty then
  begin
    MessageDlg('�׽�Ʈ�� ����� �����ȣ�� �����ϴ�!', mtInformation, [mbOK], 0);
    Exit;
  end;

  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_CANCEL)));
    JO.AddPair(TJSONPair.Create('reserve_no', Config.TestReserveNo));
    DoTestAPI(GC_MAPI_TEEBOX_CANCEL, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest8001Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MPAI_TEEBOX_STATUS_ELOOM)));
    JO.AddPair(TJSONPair.Create('floor_cd', TJSONNumber.Create(1)));
    JO.AddPair(TJSONPair.Create('teebox_no', ''));
    DoTestAPI(GC_MPAI_TEEBOX_STATUS_ELOOM, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnAPITest8007Click(Sender: TObject);
var
  JO: TJSONObject;
begin
  JO := TJSONObject.Create;
  try
    JO.AddPair(TJSONPair.Create('api_id', TJSONNumber.Create(GC_MAPI_TEEBOX_CONTROL_INDOOR)));
    JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(0)));
    JO.AddPair(TJSONPair.Create('method', TJSONNumber.Create(0)));
    DoTestAPI(GC_MAPI_TEEBOX_CONTROL_INDOOR, JO.ToString);
  finally
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  if (MessageDlg('���α׷��� �����Ͻðڽ��ϱ�?', mtConfirmation, [mbOK, mbCancel], 0) = mrOk) then
  begin
    CloseAllowed := True;
    Close;
  end;
end;

procedure TMainForm.btnDeleteLogClick(Sender: TObject);
begin
  DeleteLog;
end;

procedure TMainForm.btnLogClearClick(Sender: TObject);
begin
  lbxLogView.Items.Clear;
end;

procedure TMainForm.btnSaveConfigClick(Sender: TObject);
begin
  UpdateConfig;
  WriteConfig;

  MessageDlg('�������� �����Ͽ����ϴ�.' + _CRLF +
    '�������� �����Ϸ��� ���α׷��� ������Ͽ� �ֽʽÿ�.', mtInformation, [mbOK], 0);
end;

procedure TMainForm.btnTestClearClick(Sender: TObject);
begin
  mmoTestSource.Lines.Clear;
  mmoTestTarget.Lines.Clear;
end;

procedure TMainForm.btnTestDecryptClick(Sender: TObject);
begin
  mmoTestTarget.Text := CipherAES.Decrypt(mmoTestSource.Text);
end;

procedure TMainForm.btnTestEncryptClick(Sender: TObject);
begin
  mmoTestTarget.Text := CipherAES.Encrypt(mmoTestSource.Text);
end;

procedure TMainForm.btnTestSwapClick(Sender: TObject);
var
  sSource, sTarget: string;
begin
  sSource := mmoTestSource.Text;
  sTarget := mmoTestTarget.Text;
  mmoTestSource.Text := sTarget;
  mmoTestTarget.Text := sSource;
end;

procedure TMainForm.btnServerActiveClick(Sender: TObject);
begin
  ActiveServer := not ActiveServer;
  Config.ForceServerStop := not ActiveServer;
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
          sWriteBuffer := Format('{"result_cd":"9999", "result_msg":"�߸��� ��û ����(%s)", "result_data":[]}', [E.Message]);
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
  sErrCode, sErrMsg: string;
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
        { 1001: ���� �Ǵ� ��ü Ÿ��������Ȳ ��ȸ }
        GC_MAPI_TEEBOX_STATUS_ALL:
        begin
          var sFloorCode := JO.GetValue('floor_cd').Value;
          var sTeeBoxNoString := JO.GetValue('teebox_no').Value;

          Result := DM.GetTeeBoxStatus(AWriteBuffer, sFloorCode, sTeeBoxNoString, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] ������Ȳ ��ȸ ����. ��=%s Ÿ����ȣ=%s �����ڵ�=%s %s', [nApiId, sFloorCode, sTeeBoxNoString, AErrCode, AErrMsg]));
        end;

        { 1002: Ÿ���� Ÿ��������Ȳ ��ȸ }
        GC_MAPI_TEEBOX_STATUS:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1);

          if (nTeeBoxNo < 1) then
            raise Exception.Create(Format('[%d] Ÿ���� ������Ȳ ��ȸ ��û ���� ����. Ÿ����ȣ=%d', [nApiId, nTeeBoxNo]));

          Result := DM.GetTeeBoxStatusDetail(AWriteBuffer, nTeeBoxNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ���� ������Ȳ ��ȸ ����. Ÿ����ȣ=%d �����ڵ�=%s %s', [nApiId, nTeeBoxNo, AErrCode, AErrMsg]));
        end;

        { 1003: Ÿ�� ���� ��û }
        GC_MAPI_TEEBOX_RESERVE:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1);
          var sMemberNo := JO.GetValue('member_no').Value;
          var sMemberName := JO.GetValue('member_nm').Value;
          var nPrepareMin := StrToIntDef(JO.GetValue('prepare_min').Value, -1);
          var nAssignMin := StrToIntDef(JO.GetValue('assign_min').Value, -1);
          var nAssignBalls := 999;
          var sPurchaseCode := JO.GetValue('purchase_cd').Value;
          var sProdCode := JO.GetValue('product_cd').Value;
          var sProdName := JO.GetValue('product_nm').Value;
          var sTeeBoxProdDiv := JO.GetValue('seat_product_div').Value;
          var sReserveRootDiv := JO.GetValue('reserve_root_div').Value;

          if (nTeeBoxNo < 0) or
             (nPrepareMin < 0) or
             (nAssignMin < 0) or
             sProdCode.IsEmpty or
             sPurchaseCode.IsEmpty then
            raise Exception.Create(Format('[%d] Ÿ������ ��û ���� ����. Ÿ����ȣ=%d ��ǰ�ڵ�=%s ���Ź�ȣ=%s �غ�ð�=%d �����ð�=%d',
              [nApiId, nTeeBoxNo, sProdCode, sPurchaseCode, nPrepareMin, nAssignMin]));

          Result := DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, True, AErrCode, AErrMsg); //�ӽÿ���
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ������->�ӽÿ��� ��� ����. Ÿ����ȣ=%d ��ǰ�ڵ�=%s ���Ź�ȣ=%s �غ�ð�=%d �����ð�=%d �����ڵ�=%s %s',
              [nApiId, nTeeBoxNo, sProdCode, sPurchaseCode, nPrepareMin, nAssignMin, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxReserve(AWriteBuffer, nTeeBoxNo, sReserveRootDiv, sMemberNo, sMemberName, sPurchaseCode, sProdCode, sTeeBoxProdDiv, sProdName, nAssignMin, nPrepareMin, nAssignBalls, AErrCode, AErrMsg);
          if not Result then
          begin
            if not DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, False, sErrCode, sErrMsg) then //�ӽÿ��� ���
              AErrMsg := AErrMsg + _CRLF + Format('[%d] Ÿ������->�ӽÿ��� ��� ����. Ÿ����ȣ=%d �����ڵ�=%s %s', [nApiId, nTeeBoxNo, sErrCode, sErrMsg]);

            raise Exception.Create(Format('[%d] Ÿ������ ��� ����. Ÿ����ȣ=%d ��ǰ�ڵ�=%s ���Ź�ȣ=%s �غ�ð�=%d �����ð�=%d �����ڵ�=%s %s',
              [nApiId, nTeeBoxNo, sProdCode, sPurchaseCode, nPrepareMin, nAssignMin, AErrCode, AErrMsg]));
          end;
        end;

        { 1004: Ÿ�� ���� ���� ��ȸ }
        GC_MAPI_TEEBOX_MEMBER:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          if sReserveNo.IsEmpty then
            raise Exception.Create(Format('[%d] ���೻�� ��ȸ ��û ���� ����. �����ȣ=%s', [nApiId, sReserveNo]));

          Result := DM.GetTeeBoxReservedDetail(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            AErrMsg := Format('[%d] ���೻�� ��ȸ ����. �����ȣ=%s �����ڵ�=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]);
        end;

        { 1005: Ÿ�� ���� ��� ��û }
        GC_MAPI_TEEBOX_CANCEL:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          if sReserveNo.IsEmpty then
            raise Exception.Create(Format('[%d] ������� ��û ���� ����. �����ȣ=%s', [nApiId, sReserveNo]));

          Result := DM.DoTeeBoxCancel(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] ������� ��� ����. �����ȣ=%s �����ڵ�=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]));
        end;

        { 1006: Ÿ�� �ӽÿ��� ���/��� ��û }
        GC_MAPI_TEEBOX_HOLD:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, 0);
          var sHoldYN := JO.GetValue('hold_yn').Value;
          var bHoldYN := (sHoldYN = CRC_YES);
          var sJobName := StrUtils.IfThen(bHoldYN, '���', '���');

          if (nTeeBoxNo < 1) or
             not ((sHoldYN = CRC_YES) or (sHoldYN = CRC_NO)) then
            raise Exception.Create(Format('[%d] �ӽÿ��� %s ��û ���� ����. Ÿ����ȣ=%d', [nApiId, sJobName, nTeeBoxNo]));

          Result := DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, bHoldYN, AErrCode, AErrMsg); //�ӽÿ��� ���/���
          if not Result then
            AErrMsg := Format('[%d] �ӽÿ��� %s ����. Ÿ����ȣ=%s �����ڵ�=%s %s', [nApiId, sJobName, nTeeBoxNo, AErrCode, AErrMsg]);
        end;

        { 8001: (ELOOM) Ÿ�� ���� ��Ȳ ��ȸ }
        GC_MPAI_TEEBOX_STATUS_ELOOM:
        begin
          var sFloorCode := JO.GetValue('floor_cd').Value;
          var sTeeBoxNoString := JO.GetValue('teebox_no').Value;

          Result := DM.GetTeeBoxStatus_ELOOM(AWriteBuffer, sFloorCode, sTeeBoxNoString, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] ������Ȳ ��ȸ ����. ��=%s Ÿ����ȣ=%s �����ڵ�=%s %s', [nApiId, sFloorCode, sTeeBoxNoString, AErrCode, AErrMsg]));
        end;

        { 8002: (ELOOM) Ÿ�� ���� ���� ��û }
        GC_MAPI_TEEBOX_CHANGE_ELOOM:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;
          var nPrepareMin := StrToIntDef(JO.GetValue('prepare_min').Value, -1);
          var nAssignMin := StrToIntDef(JO.GetValue('assign_min').Value, -1);
          var nAssignBalls := StrToIntDef(JO.GetValue('assign_balls').Value, -1);
          var sMemberNo := JO.GetValue('member_no').Value;
          var sMemberName := JO.GetValue('member_nm').Value;
          var sMemo := JO.GetValue('memo').Value;

          if sReserveNo.IsEmpty or
             (nPrepareMin < 0) or
             (nAssignMin < 0) or
             (nAssignBalls < 0) then
            raise Exception.Create(Format('[%d] ���ຯ�� ��û ���� ����. �����ȣ=%s �غ�ð�=%d �����ð�=%d ��������=%d �����ڵ�=%s %s', [nApiId, sReserveNo, nPrepareMin, nAssignMin, nAssignBalls, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxReserveChange_ELOOM(AWriteBuffer, sReserveNo, nPrepareMin, nAssignMin, nAssignBalls, sMemberNo, sMemberName, sMemo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] ���ຯ�� ��� ����. �����ȣ=%s �����ڵ�=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]));
        end;

        { 8003: (ELOOM) Ÿ�� �̿� ���� ��û }
        GC_MAPI_TEEBOX_CLOSE_ELOOM:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          Result := DM.DoTeeBoxReserveClose_ELOOM(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ������ ��� ����. �����ȣ=%s �����ڵ�=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]));
        end;

        { 8004: (ELOOM) Ÿ�� �̵� ��� ��û }
        GC_MAPI_TEEBOX_MOVE_ELOOM:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, 0);
          var nPrepareMin := StrToIntDef(JO.GetValue('prepare_min').Value, -1);
          var nAssignMin := StrToIntDef(JO.GetValue('assign_min').Value, -1);
          var nAssignBalls := StrToIntDef(JO.GetValue('assign_balls').Value, -1);

          if sReserveNo.IsEmpty or
             (nTeeBoxNo < 1) or
             (nPrepareMin < 0) or
             (nAssignMin < 0) or
             (nAssignBalls < 0) then
            raise Exception.Create(Format('[%d] Ÿ���̵� ��û ���� ����. �����ȣ=%s �غ�ð�=%d �����ð�=%d ��������=%d �����ڵ�=%s %s', [nApiId, sReserveNo, nPrepareMin, nAssignMin, nAssignBalls, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, True, AErrCode, AErrMsg); //�ӽÿ���
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ���̵�->�ӽÿ��� ��� ����. �����ȣ=%s Ÿ����ȣ=%d �����ڵ�=%s %s', [nApiId, sReserveNo, nTeeBoxNo, AErrCode, AErrMsg]));

          Result := DM.DoTeeBoxReserveMove_ELOOM(AWriteBuffer, sReserveNo, nTeeBoxNo, nPrepareMin, nAssignMin, nAssignBalls, AErrCode, AErrMsg);
          if not Result then
          begin
            if not DM.DoTeeBoxHold(AWriteBuffer, nTeeBoxNo, False, sErrCode, sErrMsg) then //�ӽÿ��� ���
              AErrMsg := AErrMsg + _CRLF + Format('[%d] Ÿ���̵�->�ӽÿ��� ��� ����. �����ȣ=%s Ÿ����ȣ=%d �����ڵ�=%s %s', [nApiId, sReserveNo, nTeeBoxNo, sErrCode, sErrMsg]);

            raise Exception.Create(Format('[%d] Ÿ���̵� ��� ����. �����ȣ=%s Ÿ����ȣ=%d �����ڵ�=%s %s', [nApiId, sReserveNo, nTeeBoxNo, AErrCode, AErrMsg]));
          end;
        end;

        { 8005: (ELOOM) Ÿ�� ��� ���/���� ��û (error_div = 0:����, 1:������, 2:���Ұ�) }
        GC_MAPI_TEEBOX_ERROR_ELOOM:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, 0);
          var sErrorDiv := JO.GetValue('error_div').Value;

          if (nTeeBoxNo < 1) or
             sErrorDiv.IsEmpty then
            raise Exception.Create(Format('[%d] Ÿ����� ��� ��û ���� ����. Ÿ����ȣ=%d �����ڵ�=%s', [nApiId, nTeeBoxNo, sErrorDiv]));

          Result := DM.SetTeeBoxError_ELOOM(AWriteBuffer, nTeeBoxNo, sErrorDiv, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ����� ��� ����. Ÿ����ȣ=%d �����ڵ�=%s �����ڵ�=%s %s', [nApiId, nTeeBoxNo, sErrorDiv, AErrCode, AErrMsg]));
        end;

        { 8006: ����Ÿ�� ��� ���� }
        GC_MAPI_TEEBOX_IMMEDIATE_ELOOM:
        begin
          var sReserveNo := JO.GetValue('reserve_no').Value;

          if sReserveNo.IsEmpty then
            raise Exception.Create(Format('[%d] ��ù��� ��û ���� ����. �����ȣ=%s', [nApiId, sReserveNo]));

          Result := DM.DoImmediateTeeBoxStart_ELOOM(AWriteBuffer, sReserveNo, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] ��ù��� ��� ����. �����ȣ=%s �����ڵ�=%s %s', [nApiId, sReserveNo, AErrCode, AErrMsg]));
        end;

        { 8007: (�ǳ�����������) �ùķ�����PC ����(�˴ٿ�, ������), ���α׷� ������Ʈ }
        GC_MAPI_TEEBOX_CONTROL_INDOOR:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1); //0:��üŸ��
          var nMethod := StrToIntDef(JO.GetValue('method').Value, -1);
          var sMethod := '����';

          case nMethod of
            0: sMethod := '�˴ٿ�';
            1: sMethod := '������';
            2: sMethod := '������Ʈ ������Ʈ';
          end;

          if (nTeeBoxNo < 0) or
             (nMethod < 0) then
            raise Exception.Create(Format('[%d] Ÿ���� %s ��û ���� ����. Ÿ����ȣ=%d �����ڵ�=%d', [nApiId, sMethod, nTeeBoxNo, nMethod]));

          Result := DM.DoTeeBoxMachineControl_InDoor(AWriteBuffer, nTeeBoxNo, nMethod, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] Ÿ���� %s ��û ����. Ÿ����ȣ=%d �����ڵ�=%d �����ڵ�=%s %s', [nApiId, sMethod, nTeeBoxNo, nMethod, AErrCode, AErrMsg]));
        end;

        { 8008: (�ǳ�����������) ��ġ ���� ���� }
        GC_MAPI_DEVICE_CONTROL_INDOOR:
        begin
          var nTeeBoxNo := StrToIntDef(JO.GetValue('teebox_no').Value, -1); //0:��üŸ��
          var nDeviceDiv := StrToIntDef(JO.GetValue('device_div').Value, -1);
          var nControlDiv := StrToIntDef(JO.GetValue('control_div').Value, -1);
          var sCommand := JO.GetValue('command').Value;
          var sDeviceDiv := '';
          var sControlDiv := '';

          case nDeviceDiv of
            GC_MPAI_DEVICE_LBP: sDeviceDiv := '�� ��������';
          end;
          case nControlDiv of
            GC_MPAI_CONTROL_LBP_POWER: sControlDiv := '��������';
          end;

          if sDeviceDiv.IsEmpty or
             sControlDiv.IsEmpty or
             (nTeeBoxNo < 0) or
             (nDeviceDiv < 0) or
             (nControlDiv < 0) then
            raise Exception.Create(Format('[%d] %s %s ��û ���� ����. Ÿ����ȣ=%d �����ڵ�=%s', [nApiId, sDeviceDiv, sControlDiv, nTeeBoxNo, sCommand]));

          Result := DM.DoTeeBoxDeviceControl_InDoor(AWriteBuffer, nTeeBoxNo, nDeviceDiv, nControlDiv, sCommand, AErrCode, AErrMsg);
          if not Result then
            raise Exception.Create(Format('[%d] %s %s ��û ����. Ÿ����ȣ=%d �����ڵ�=%s �����ڵ�=%s %s', [nApiId, sDeviceDiv, sControlDiv, nTeeBoxNo, sCommand, AErrCode, AErrMsg]));
        end;
      else
        AErrCode := '9001';
        AErrMsg := Format('[%d] �߸��� API �ĺ���.', [nApiId]);
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

    ServerHost := GC_API_SERVER_HOST;
    ApiKey := '';
    ClientId := 'E0000';

    TeeBoxADHost := CCD_TEEBOX_HOST;
    TeeBoxADPort := CCD_TEEBOX_API_PORT;
    TeeBoxDBPort := CCD_TEEBOX_DB_PORT;
    TeeBoxDBUserId := CCD_TEEBOX_USER;
    TeeBoxDBPwd := CCD_TEEBOX_PWD;
    TeeBoxDBCatalog := CCD_TEEBOX_DB;
  end;
end;

procedure TMainForm.ReadConfig;
begin
  with Config do
  begin
    StoreCode := IniFile.ReadString('Config', 'StoreCode', '');
    AutoRun := IniFile.ReadBool('Config', 'AutoRun', AutoRun);
    LogDelete := IniFile.ReadBool('Config', 'LogDelete', LogDelete);
    LogDeleteDays := IniFile.ReadInteger('Config', 'LogDeleteDays', LogDeleteDays);

    MobileADPort := IniFile.ReadInteger('MobileAD', 'Port', MobileADPort);
    MobileADTimeout :=  IniFile.ReadInteger('MobileAD', 'Timeout', MobileADTimeout);

    ServerHost := IniFile.ReadString('Server', 'Host', '');
    if (Copy(ServerHost, Length(ServerHost), 1) = '/') then
      ServerHost := Copy(ServerHost, 1, Length(ServerHost) - 1);
    ApiKey := StrDecrypt(IniFile.ReadString('Server', 'ApiKey', ''));

    TeeBoxADHost := IniFile.ReadString('TeeBoxAD', 'Host', TeeBoxADHost);
    TeeBoxADPort := IniFile.ReadInteger('TeeBoxAD', 'Port', TeeBoxADPort);

    TeeBoxDBPort := IniFile.ReadInteger('TeeBoxDB', 'Port', TeeBoxDBPort);
    TeeBoxDBUserId := IniFile.ReadString('TeeBoxDB', 'UserId', TeeBoxDBUserId);
    TeeBoxDBPwd := StrDecrypt(IniFile.ReadString('TeeBoxDB', 'Pwd', ''));
    TeeBoxDBCatalog := IniFile.ReadString('TeeBoxDB', 'Catalog', TeeBoxDBCatalog);

    edtStoreCode.Text := StoreCode;
    ckbAutoRun.Checked := AutoRun;
    ckbLogDelete.Checked := LogDelete;
    edtLogDeleteDays.Value := LogDeleteDays;

    edtMobileADPort.Value := MobileADPort;

    edtServerHost.Text := ServerHost;
    edtApiKey.Text := ApiKey;

    edtTeeBoxADHost.Text := TeeBoxADHost;
    edtTeeBoxADPort.Value := TeeBoxADPort;
    edtTeeBoxDBPort.Value := TeeBoxDBPort;
    edtTeeBoxDBUserId.Text := TeeBoxDBUserId;
    edtTeeBoxDBPwd.Text := TeeBoxDBPwd;
    edtTeeBoxDBCatalog.Text := TeeBoxDBCatalog;
  end;
end;

procedure TMainForm.UpdateConfig;
begin
  with Config do
  begin
    StoreCode := edtStoreCode.Text;
    AutoRun := ckbAutoRun.Checked;
    LogDelete := ckbLogDelete.Checked;
    LogDeleteDays := edtLogDeleteDays.Value;

    MobileADPort := edtMobileADPort.Value;
    MobileADTimeout := edtMobileADTimeout.Value;

    ServerHost := edtServerHost.Text;
    ApiKey := edtApiKey.Text;

    TeeBoxADHost := edtTeeBoxADHost.Text;
    TeeBoxADPort := edtTeeBoxADPort.Value;
    TeeBoxDBPort := Trunc(edtTeeBoxDBPort.Value);
    TeeBoxDBUserId := edtTeeBoxDBUserId.Text;
    TeeBoxDBPwd := edtTeeBoxDBPwd.Text;
    TeeBoxDBCatalog := edtTeeBoxDBCatalog.Text;
  end;
end;

procedure TMainForm.WriteConfig;
begin
  with Config do
  try
    IniFile.WriteString('Config', 'StoreCode', StoreCode);
    IniFile.WriteBool('Config', 'AutoRun', AutoRun);
    IniFile.WriteBool('Config', 'LogDelete', LogDelete);
    IniFile.WriteInteger('Config', 'LogDeleteDays', LogDeleteDays);

    IniFile.WriteInteger('MobileAD', 'Port', MobileADPort);
    IniFile.WriteInteger('MobileAD', 'Timeout', MobileADTimeout);

    IniFile.WriteString('Server', 'Host', ServerHost);
    IniFile.WriteString('Server', 'ApiKey', StrEncrypt(ApiKey));

    IniFile.WriteString('TeeBoxAD', 'Host', TeeBoxADHost);
    IniFile.WriteInteger('TeeBoxAD', 'Port', TeeBoxADPort);
    IniFile.WriteInteger('TeeBoxDB', 'Port', TeeBoxDBPort);
    IniFile.WriteString('TeeBoxDB', 'UserId', TeeBoxDBUserId);
    IniFile.WriteString('TeeBoxDB', 'Pwd', StrEncrypt(TeeBoxDBPwd));
    IniFile.WriteString('TeeBoxDB', 'Catalog', TeeBoxDBCatalog);

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
    AddLog('ELOOM API ������ ���� �Ǿ����ϴ�.');
    AddLog(Format('AES256 SecureKey : %s', [CipherAES.SecureKey]), LC_COLOR_NORMAL);
    AddLog(Format('AES256 IV : %s', [CipherAES.InitVector]), LC_COLOR_NORMAL);
  end
  else
    AddLog('ELOOM API ������ ������ �� �����ϴ�.', LC_COLOR_ERROR);
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
    btnServerActive.Caption := '���� ' + IIF(AValue, '����', '����');
    AddLog(Format('�����AD ������ %s �Ǿ����ϴ�. (Port: %d)', [IIF(AValue, '����', '����'), Config.MobileADPort]), clGreen);
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
      AddLog(Format('%d�� ������ ������ �α����� %d���� �����Ͽ����ϴ�.', [Config.LogDeleteDays, nResult]));
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
  end;
end;

{ TServerConnectThread }

constructor TServerConnectThread.Create(const ACreateSuspended: Boolean);
begin
  inherited Create(ACreateSuspended);

  FreeOnTerminate := True;
  FConnected := False;
  FCheckConnectInterval := 5000; //5��
  FCheckConnectLastworked := (Now - 1);
  FCheckCpuUsageInterval := 60000; //1��
  FCheckCpuUsageLastWorked := (Now - 1);
end;

destructor TServerConnectThread.Destroy;
begin

  inherited;
end;

procedure TServerConnectThread.Execute;
begin
  inherited;

  repeat
    Synchronize(
      procedure
      var
        sSecureKey, sErrMsg: string;
        nUsage: Single;
      begin
        if not Connected then
        begin
          if Config.ApiKey.IsEmpty then
            Exit;

          if (MilliSecondsBetween(FCheckConnectLastWorked, Now) > FCheckConnectInterval) then
          begin
            FCheckConnectLastWorked := Now;
            try
              if not DM.GetSecureKey(Config.StoreCode, Config.SecureKey, sErrMsg) then
                raise Exception.Create(sErrMsg);

              if not Assigned(CipherAES) then
              begin
                sSecureKey := StringReplace(Config.SecureKey, '-', '', [rfReplaceAll]);
                CipherAES := TCipherAES.Create(
                  sSecureKey,
                  256,
                  sSecureKey.Substring(0, 16),
                  TEncoding.UTF8,
                  TChainingMode.cmCBC,
                  TPaddingMode.pmPKCS7);
              end;

              if not DM.conLocalDB.Connected then
              begin
                DM.conLocalDB.Options.LocalFailover := True;
                DM.conLocalDB.Options.DisconnectedMode := True;
                DM.conLocalDB.Open;
              end;

              SendMessage(MainForm.Handle, WM_SERVER_CONNECTED, 0, 0);
              Connected := True;
            except
              on E: Exception do
                AddLog(Format('ServerConnectThread.Exception : %s', [E.Message]), LC_COLOR_ERROR);
            end;
          end;
        end;

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
      end);

    WaitForSingleObject(Handle, 1000);
  until Terminated and (not CloseAllowed);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(DBQueryCS);
  InitializeCriticalSection(LogCS);
finalization
  DeleteCriticalSection(DBQueryCS);
  DeleteCriticalSection(LogCS);
end.
