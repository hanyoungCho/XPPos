(*******************************************************************************

  Project     : XPartners 골프연습장 POS 시스템
  Title       : 실내골프연습장 타석기 에이전트 II 메인 화면
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    2.0.0.0   2022-10-31   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2022 All rights reserved.

  [참고사항]

  ELOOM API Server: https://api.eloomgolf.com
  ELOOM API Key: owgss0w4008wk0cgks8cog00kok0k0kw40sk4kck

*******************************************************************************)
unit uXGTeeBoxAgentMain;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.OleCtrls, Vcl.AppEvnts, System.Actions, Vcl.ActnList, System.SyncObjs,
  System.Threading,
  { DevExpress }
  dxGDIPlusClasses, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPC, cxContainer, cxEdit, cxImage,
  { Indy }
  IdComponent, IdBaseComponent, IdContext, IdCustomTCPServer, IdTCPServer, IdAntiFreezeBase,
  IdAntiFreeze, IdTCPConnection, IdTCPClient,
  { VideoGrabber }
  VidGrab,
  { TMS }
  AdvMenus,
  { SolbiLib }
  PicShow, cyBaseLed, cyLed, FxImageButton,
  { Project }
  uMediaPlayThread;

{$I ..\common\XGTeeBoxAgent.inc}
{$I ..\common\XGLicense.inc}

const
  LCN_ADMIN_CHECK_SECONDS = 180; //3분

type
  { 기본 타이머 스레드 }
  TBaseTimerThread = class(TThread)
  private
    FIntervalMilliSeconds: Int64;
    FLastMilliSeconds: TDateTime;
    FIntervalSeconds: Int64;
    FLastSeconds: TDateTime;
    FShutdownWorking: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { 서버 접속 스레드 }
  TCheckConnectThread = class(TThread)
  private
    FInterval: Integer; //밀리초
    FLastWorked: TDateTime;
    FLastServerConnecting: TDateTime;
    FWorking: Boolean;

    function GetAgentConfig: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval;
  end;

  { 로그아웃 매크로 스레드 }
  TLogoutMacroThread = class(TThread)
  private
    FActive: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Active: Boolean read FActive write FActive default False;
  end;

  TMainForm = class(TForm)
    TCPServer: TIdTCPServer;
    AntiFreeze: TIdAntiFreeze;
    pgcMain: TcxPageControl;
    PicShow: TPicShow;
    VideoPlayer: TVideoGrabber;
    tabHome: TcxTabSheet;
    tabMedia: TcxTabSheet;
    tabLog: TcxTabSheet;
    lbxLog: TListBox;
    panLogHeader: TPanel;
    btnLogClose: TButton;
    tmrRunOnce: TTimer;
    AppEvents: TApplicationEvents;
    panRemainTime: TPanel;
    lblRemainTime: TLabel;
    panProgress: TPanel;
    pbrTotal: TProgressBar;
    pbrCurrent: TProgressBar;
    panLedBar: TPanel;
    ledAPIServer: TcyLed;
    ledTeeBoxAD: TcyLed;
    ledTCPServer: TcyLed;
    ledTeeBoxStatus: TcyLed;
    pmnMainMenu: TAdvPopupMenu;
    mniSaveRemainPos: TMenuItem;
    mniLogView: TMenuItem;
    mniConfig: TMenuItem;
    mniBackToGame: TMenuItem;
    mniAppRestart: TMenuItem;
    mniAppClose: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    aclMainMenu: TActionList;
    actSaveRemainPos: TAction;
    actLogView: TAction;
    actConfig: TAction;
    actBackToGame: TAction;
    actAppRestart: TAction;
    actAppClose: TAction;
    mniVersionInfo: TMenuItem;
    imgHome: TcxImage;
    btnTeeBoxMove: TFxImageButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerDisconnect(AContext: TIdContext);
    procedure TCPServerException(AContext: TIdContext; AException: Exception);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure TCPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure VideoPlayerLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
    procedure VideoPlayerPlayerStateChanged(Sender: TObject; OldPlayerState, NewPlayerState: TPlayerState);
    procedure actSaveRemainPosExecute(Sender: TObject);
    procedure actLogViewExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actBackToGameExecute(Sender: TObject);
    procedure actAppRestartExecute(Sender: TObject);
    procedure actAppCloseExecute(Sender: TObject);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure panRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblRemainTimeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnAppRestartClick(Sender: TObject);
    procedure btnLogCloseClick(Sender: TObject);
    procedure btnTeeBoxMoveClick(Sender: TObject);
    procedure lbxLogKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FTestMode: Boolean;
    FBaseTimer: TBaseTimerThread;
    FTeeBoxPlayMode: Integer;
    FLastTeeBoxPlayMode: Integer;
    FTempTeeBoxPlayMode: Integer; //로그아웃 매크로 동작 중에 타석 상태 변경을 비교하기 위한 값
    FReadyStart: TDateTime;
    FReadySeconds: LongInt;
    FPrepareSeconds: LongInt;
    FAssignStart: TDateTime;
    FAssignSeconds: LongInt;
    FRemainSeconds: LongInt;
    FIdleSeconds: LongInt;
    FExtendScreen: Boolean;
    FIsDisplaySwitch: Boolean;
    FPrimaryMonitor: Integer;
    FSecondaryMonitor: Integer;
    FLauncherHandle: NativeInt;

    FDesktopDC: HDC;
    FMainPageVisible: Boolean;
    FLastMainPageIndex: Integer;
    FActiveServer: Boolean;
    FAdminMode: Boolean;
    FAdminCheckMode: Boolean;
    FAdminStart: TDateTime;
    FAdminSeconds: DWord;
    FHitCount: Integer;
    FHitLastWorked: TDateTime;

    function ActivateCkDLL(var AErrMsg: string): Boolean;
    procedure DoInit;
    function DoCheckAdmin: Boolean;
    procedure DoConfig;
    procedure DoLogView;
    procedure DoDownload;
{$IFDEF RELEASE}
    procedure DoLogoutProcess;
{$ENDIF}
    function CallLauncher(var AErrMsg: string): Boolean;
//    function ShowExtendScreen(const AExtendScreen: Boolean; var AErrMsg: string): Boolean;
    procedure DoDeleteLog;

    procedure DoTeeBoxPrepare(const APrepareSeconds: LongInt);
    procedure DoTeeBoxStart(const ARemainSeconds: LongInt);
    procedure DoTeeBoxStop;
    procedure DoTeeBoxIdle;
    procedure ShowMediaPlayer(const AShow: Boolean);

    procedure DoRemainTimeMouseDown(AWinControl: TWinControl);

    procedure GetMonitorsInfo;
    procedure CheckConfig;
    procedure ReadConfig;
    procedure WriteConfig;
    procedure UpdateConfig_ELOOM(const AIniData: string);

    procedure SetActiveServer(const AValue: Boolean);
    procedure SetTeeBoxPlayMode(const ATeeBoxPlayMode: Integer);
    procedure SetPrepareSeconds(const APrepareSeconds: LongInt);
    procedure SetRemainSeconds(const ARemainSeconds: LongInt);
    procedure SetIdleSeconds(const AIdleSeconds: LongInt);
    procedure SetAdminMode(const AValue: Boolean);
    procedure SetExtendScreen(const AValue: Boolean);
    procedure SetTestMode(const ATestMode: Boolean);

    function PostAgentConfig(var AErrMsg: string): Boolean;

    procedure HTTPDownloaderWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure HTTPDownloaderWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure HTTPDownloaderWorkEnd(ASender: TObject; AWorkMode: TWorkMode);

    procedure OnChangeActiveMediaThread(Sender: TObject);
    procedure OnChangeContentMediaThread(Sender: TObject);
  protected
    { Protected declarations }
{$IFDEF RELEASE}
    procedure CreateParams(var AParams: TCreateParams); override;
{$ENDIF}
    procedure WndProc(var AMessage: TMessage); override;
  public
    { Public declarations }
    procedure RequestTeeBoxStatus;

    property ActiveServer: Boolean read FActiveServer write SetActiveServer default False;
    property TeeBoxPlayMode: Integer read FTeeBoxPlayMode write SetTeeBoxPlayMode default TBS_TEEBOX_IDLE;
    property ReadyStart: TDateTime read FReadyStart write FReadyStart;
    property ReadySeconds: LongInt read FReadySeconds write FReadySeconds default 0;
    property PrepareSeconds: LongInt read FPrepareSeconds write SetPrepareSeconds default 0;
    property AssignStart: TDateTime read FAssignStart write FAssignStart;
    property AssignSeconds: LongInt read FAssignSeconds write FAssignSeconds default 0;
    property RemainSeconds: LongInt read FRemainSeconds write SetRemainSeconds default 0;
    property IdleSeconds: LongInt read FIdleSeconds write SetIdleSeconds default 0;
    property AdminMode: Boolean read FAdminMode write SetAdminMode default False;
    property AdminCheckMode: Boolean read FAdminCheckMode write FAdminCheckMode default False;
    property AdminStart: TDateTime read FAdminStart write FAdminStart;
    property AdminSeconds: DWord read FAdminSeconds write FAdminSeconds;
    property ExtendScreen: Boolean read FExtendScreen write SetExtendScreen default False;
    property TestMode: Boolean read FTestMode write SetTestMode default False;
  end;

var
  MainForm: TMainForm;
  MediaPlayThread: TMediaPlayThread;
  CheckConnectThread: TCheckConnectThread;
  ConnectorCS: TCriticalSection;
  LogoutCS: TCriticalSection;

implementation

uses
  { Native }
{$IFDEF RELEASE}
  Winapi.ShlObj, System.Win.ComObj, Winapi.ActiveX,
{$ENDIF}
  System.DateUtils, System.StrUtils, System.IniFiles, WinApi.ShellApi,
  { Indy }
  IdGlobal, IdHTTP, IdStack, IdStackConsts, IdException, //IdTCPConnection,
  { Chilkat }
  Chilkat.Global, Chilkat.JsonObject,
  { Project }
  uXGTeeBoxAgentDM, uXGTeeBoxAgentScreen, uXGTeeBoxAgentConfig, uXGTeeBoxAgentPwd, uXGCommonLib,
  uSBMsgBox, uNetLib;

var
  SF: TScreenForm;
  PF: TPasswordForm;
  CF: TConfigForm;
  FIniDataELOOM: string;

{$R *.dfm}

procedure SimulateMouseLeftClick(const X, Y, ASeconds: Integer);
var
  nRetry: Integer;
  nMSec: LongInt;
  dStart: TDateTime;
begin
  for nRetry := 1 to 2 do
  begin
    if Global.Closing then
      Break;

    if (X >= 0) and (Y >= 0) then
    begin
      SetCursorPos(X, Y);
      Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
      Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    end;

    if (ASeconds >= 0) then
    begin
      nMSec := (ASeconds * 1000);
      dStart := Now;
      while (MilliSecondsBetween(dStart, Now) < nMSec)  do
      begin
        if Global.Closing then
          Break;

        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure TMainForm.AppEventsException(Sender: TObject; E: Exception);
begin
  CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, Format('Application.%s = %s', [E.ClassName, E.Message]));
end;

{$IFDEF RELEASE}
procedure TMainForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.ExStyle := AParams.ExStyle or WS_EX_TOPMOST;
  AParams.WndParent := 0;
end;
{$ENDIF}

procedure TMainForm.WndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    CWM_DO_DOWNLOAD:
      DoDownload;
    CWM_DO_DELETE_LOG:
      DoDeleteLog;
    CWM_DO_UPDATE_LOG:
      begin
        var sLog: string := PChar(PCopyDataStruct(AMessage.LParam)^.lpData);
        AddLog(sLog);
      end;
    CWM_DO_REBOOT:
      begin
        Global.Closing := True;
        SystemShutdown(0, True, True);
      end;
    CWM_DO_SHUTDOWN:
      begin
        Global.Closing := True;
        AddLog(Format('SyetemShutdown = 영업종료(%s)', [Global.StoreEndTime]));
        SystemShutdown(AMessage.WParam, True, False);
      end;
    CWM_DO_TEEBOX_IDLE:
      DoTeeBoxIdle;
{$IFDEF RELEASE}
    CWM_DO_TOPMOST:
//      SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.ClientWidth, Self.ClientHeight, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
{$ENDIF}
    CWM_DO_READ_CONFIG:
      ReadConfig;
    CWM_DO_WRITE_CONFIG:
      WriteConfig;
    CWM_DO_ELOOM_CONFIG:
      begin
        if not FIniDataELOOM.IsEmpty then
          UpdateConfig_ELOOM(FIniDataELOOM);
        RequestTeeBoxStatus;
      end;
    CWM_SET_PREPARE_SECS:
      PrepareSeconds := AMessage.WParam;
    CWM_SET_REMAIN_SECS:
      RemainSeconds := AMessage.WParam;
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
  I: Integer;
begin
{$IFDEF RELEASE}
  Application.NormalizeTopMosts;
  Self.FormStyle := fsStayOnTop;

  FormatSettings.DateSeparator := '-';
  FormatSettings.TimeSeparator := ':';
  FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FormatSettings.ShortTimeFormat := 'hh:nn:ss';
  FormatSettings.LongDateFormat := 'yyyy-mm-dd';
  FormatSettings.LongTimeFormat := 'hh:nn:ss';

  sLinkFile := GetSysDir(CSIDL_DESKTOP) + '\엑스파트너스 타석기 에이전트.lnk';
  if not FileExists(sLinkFile) then
  begin
    hIObject := CreateComObject(CLSID_ShellLink);
    hISLink := hIObject as IShellLink;
    hIPFile := hIObject as IPersistFile;
    with hISLink do
    begin
      //SetArguments('/run'); // 실행 파라메터
      //SetWorkingDirectory(PChar(GetSysDir(36))); //실행 디렉토리
      SetPath(PChar(Global.HomeDir + CCS_LAUNCHER_NAME)); //런처 실행파일명
      SetWorkingDirectory(PChar(Global.HomeDir)); //런처 실행 디렉토리
    end;
    hIPFile.Save(PChar(sLinkFile), False);
  end;
{$ENDIF}

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(panRemainTime);
  NullStrictConvert := False;
  mniVersionInfo.Caption := '엑스파트너스 타석기 에이전트 v' + GetAppVersion(2); //FileVersion
  VideoPlayer.LicenseString := VG_LICENSE_KEY;

  FLauncherHandle := GetProcessHandle(Global.HomeDir + CCS_LAUNCHER_NAME);
  FDesktopDC := GetDC(0);
  FReadyStart := Now;
  FReadySeconds := 0;
  FPrepareSeconds := 0;
  FAssignStart := Now;
  FAssignSeconds := 0;
  FRemainSeconds := 0;
  FIdleSeconds := 0;
  FHitCount := 0;
  FHitLastWorked := (Now - 1);
  FAdminMode := False;
  FAdminCheckMode := False;
  FAdminStart := Now;
  FAdminSeconds := 0;
  FActiveServer := False;
  FMainPageVisible := True;
  FLastMainPageIndex := 0;
  FTeeBoxPlayMode := 0;
  FLastTeeBoxPlayMode := 0;
  FTempTeeBoxPlaymode := 0;
  FExtendScreen := True;

  PicShow.Proportional := True; //이미지 출력 시 비례항 사용
  with VideoPlayer do
  begin
    DoubleBuffered := True;
    Display_Embedded := True;
    Display_AspectRatio := ar_Stretch; //ar_PanScan; //ar_Box;
    TextOverlay_String := '';
    TextOverlay_Enabled := True;
  end;

  Global.LogListControl := lbxLog;
  AddLog('프로그램 시작');
  Global.LocalIP := GetIPAddress;
  Global.MacAddr := GetMACAddress(Global.LocalIP);
  AddLog(Format('IP 주소 : %s (%s)', [Global.LocalIP, Global.MacAddr]));

  CheckConfig;
  ReadConfig;

  //화면보호기 작동 중지
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);
  //작업표시줄 감추기
  if Global.HideTaskBar then
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);

  Self.Left := Global.MainFormInfo.Left;
  Self.Top := Global.MainFormInfo.Top;
  with pgcMain do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
    Width := Global.MainFormInfo.Width + 1;
    Height := Global.MainFormInfo.Height + 1;
  end;
  panRemainTime.Left := Global.MainFormInfo.RemainLeft;
  panRemainTime.Top := Global.MainFormInfo.RemainTop;
  panProgress.Visible := False;

  if (not Global.BackgroundImageFile.IsEmpty) and
     FileExists(Global.ContentsDir + Global.BackgroundImageFile) then
    imgHome.Picture.LoadFromFile(Global.ContentsDir + Global.BackgroundImageFile)
  else
  begin
    if (Global.APIServer.Provider = SSP_ELOOM) then
      imgHome.Picture.Assign(DM.iciServiceProvider1.Picture)
    else
      imgHome.Picture.Assign(DM.iciServiceProvider0.Picture);
  end;

{$IFDEF RELEASE}
  TestMode := (ParamCount > 1) and (LowerCase(ParamStr(2)) = '/test');
{$ELSE}
  TestMode := True;
{$ENDIF}
  tmrRunOnce.Enabled := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AddLog('프로그램 종료');
  Global.Closing := True;
  ShowCursor(True);
  PicShow.Stop;
  VideoPlayer.StopPlayer;
  VideoPlayer.ClosePlayer;
  if TCPServer.Active then
    TCPServer.Active := False;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//var
//  hLauncher: NativeInt;
begin
//  hLauncher := FindWindow(nil, PChar(ChangeFileExt(LCS_LAUNCHER_NAME, '')));
//  if (hLauncher > 0) and
//     (SBMsgBox(Self.Handle, mtConfirmation, '확인', '런처 프로그램이 실행감시 상태로 작동 중입니다.'#13#10 +'런처 프로그램도 중지시키겠습니까?', ['예', '아니오']) = mrOK) then
//    SendMessage(hLauncher, WM_CLOSE, 0, 0);
  CanClose := True;
  if Assigned(SF) then
    SendMessage(SF.Handle, WM_CLOSE, 0, 0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOW);
  ReleaseDC(GetDesktopWindow, FDesktopDC);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F4: //(테스트)준비
      if (ssShift in Shift) then
        DoTeeBoxPrepare(CCN_TEST_PREPARE_SECONDS);
    VK_F5: //(테스트)시작
      if (ssShift in Shift) then
        DoTeeBoxStart(CCN_TEST_ASSIGN_SECONDS);
    VK_F6: //(테스트)종료
      if (ssShift in Shift) then
        DoTeeBoxStop;
  end;
end;

procedure TMainForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    DoInit;
  finally
    Free;
  end;
end;

procedure TMainForm.TCPServerConnect(AContext: TIdContext);
begin
  AContext.Connection.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8;
  AContext.Connection.IOHandler.LargeStream := True;
  AContext.Connection.IOHandler.ConnectTimeout := Global.APIServer.Timeout;
  AContext.Connection.IOHandler.ReadTimeout := Global.APIServer.Timeout;
  AContext.Binding.SetSockOpt(Id_SOL_SOCKET, Id_SO_SNDTIMEO, 15000);
  ledTCPServer.LedValue := True;
end;

procedure TMainForm.TCPServerDisconnect(AContext: TIdContext);
begin
  ledTCPServer.LedValue := False;
end;

procedure TMainForm.TCPServerException(AContext: TIdContext; AException: Exception);
begin
  if (AContext.Connection = nil) or
     (AException is EIdSilentException) or
     (AException is EIdConnClosedGracefully) then
    Exit;

  AddLog(Format('TCPServer.Exception : %s', [AException.Message]));
end;

procedure TMainForm.TCPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  AddLog(Format('TCPServer.Status : %s', [AStatusText]));
end;

procedure TMainForm.TCPServerExecute(AContext: TIdContext);
var
  JO: HCkJsonObject;
  nApiId, nTeeBoxNo, nMinutes, nSeconds, nStatus, nMethod: Integer;
  bNeedTerminate: Boolean;
  sReadBuffer, sWriteBuffer, sReserveNo, sResultCode, sResultMsg: string;
begin
  try
    if (AContext.Connection = nil) or
       (not AContext.Connection.Connected) then
      Exit;

    if AContext.Connection.IOHandler.InputBufferIsEmpty then
    begin
      if (TCPServer.Contexts.Count > 0) then
        AContext.Connection.IOHandler.CheckForDataOnSource(1000 div TCPServer.Contexts.Count);
      AContext.Connection.IOHandler.CheckForDisconnect(False, True);
      AContext.Connection.CheckForGracefulDisconnect(False);
      if AContext.Connection.IOHandler.InputBufferIsEmpty then
        Exit;
    end;

    AContext.Connection.IOHandler.MaxLineLength := MaxInt;
    sReadBuffer := Trim(AContext.Connection.IOHandler.ReadLn(IndyTextEncoding_UTF8));
    if sReadBuffer.IsEmpty then
      Exit;

    JO := CkJsonObject_Create;
    try
      if not CkJsonObject_Load(JO, PWideChar(sReadBuffer)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      nApiId := CkJsonObject_IntOf(JO, 'api_id');
      //쓰레기 데이터 수신은 무시
      if (nApiId = 0) then
        Exit;

      nTeeBoxNo := -1; //0이면 전체 타석 대상으로 처리하기 위함
      sReserveNo := CkJsonObject__stringOf(JO, 'reserve_no');
      if not CkJsonObject_IsNullOf(JO, 'teebox_no') then
        nTeeBoxNo := CkJsonObject_IntOf(JO, 'teebox_no');

      //전체(0) 혹은 설정한 타석일 경우에만 처리
      if (nTeeBoxNo in [0, Global.TeeBoxInfo.TeeBoxNo]) then
      begin
        AddLog('TCPServer.Execute.Request = ' + sReadBuffer);
        sResultCode := CRC_SUCCESS;
        sResultMsg := '정상적으로 처리 되었습니다.';
        nStatus := -1;
        nMethod := -1;
        nMinutes := 0;
        nSeconds := 0;

        sWriteBuffer := Format('{"api_id": "%d", "teebox_no": "%d", "reserve_no": "%s", "result_cd": "%s", "result_msg": "%s"}',
          [nApiId, nTeeBoxNo, sReserveNo, sResultCode, sResultMsg]);
        bNeedTerminate := False;

        //응답 전문 파싱
        case nApiId of
          TBS_TEEBOX_PREPARE:
            begin
              nMinutes := CkJsonObject_IntOf(JO, 'prepare_min');
              nSeconds := CkJsonObject_IntOf(JO, 'prepare_second');
            end;
          TBS_TEEBOX_START,
          TBS_TEEBOX_CHANGE:
            begin
              nMinutes := CkJsonObject_IntOf(JO, 'assign_min');
              nSeconds := CkJsonObject_IntOf(JO, 'assign_second');
            end;
          TBS_TEEBOX_STATUS:
            begin
              sResultCode := CkJsonObject__stringOf(JO, 'result_cd');
              sResultMsg := CkJsonObject__stringOf(JO, 'result_msg');
              if (sResultCode <> CRC_SUCCESS) then
                raise Exception.Create(sResultMsg);

              nStatus := CkJsonObject_IntOf(JO, 'teebox_status');
              nMinutes := CkJsonObject_IntOf(JO, 'remain_min');
              nSeconds := CkJsonObject_IntOf(JO, 'remain_second');
            end;
          TBS_TEEBOX_AGENT:
            begin
              nMethod := CkJsonObject_IntOf(JO, 'method');
              sWriteBuffer := Format('{"api_id": "%d", "teebox_no": "%d", "method": "%d", "result_cd": "%s", "result_msg": "%s"}',
                [nApiId, nTeeBoxNo, nMethod, sResultCode, sResultMsg]);
            end
        end;

        //응답 전문부터 먼저 송신
        AContext.Connection.IOHandler.WriteLn(sWriteBuffer, IndyTextEncoding_UTF8);
        AddLog('TCPServer.Execute.Response = ' + sReadBuffer);

        //명령 수행
        case nApiId of
          TBS_TEEBOX_PREPARE:
            begin
              DoTeeBoxPrepare(nSeconds);
              AddLog(Format('TCPServer.Execute.Accepted = 타석 준비 (#%d, teebox_no:%d, reserve_no:%s, prepare_min:%d [%d secs.])', [nApiId, nTeeBoxNo, sReserveNo, nMinutes, nSeconds]));
            end;
          TBS_TEEBOX_START:
            begin
              DoTeeBoxStart(nSeconds);
              AddLog(Format('TCPServer.Execute.Accepted = 타석 시작 (#%d, teebox_no:%d, reserve_no:%s, assign_min:%d [%d secs.])', [nApiId, nTeeBoxNo, sReserveNo, nMinutes, nSeconds]));
            end;
          TBS_TEEBOX_CHANGE:
            begin
              DoTeeBoxStart(nSeconds);
              AddLog(Format('TCPServer.Execute.Accepted = 타석 이용시간 변경 (#%d, teebox_no:%d, reserve_no:%s, assign_min:%d [%d secs.])', [nApiId, nTeeBoxNo, sReserveNo, nMinutes, nSeconds]));
            end;
          TBS_TEEBOX_STOP:
            begin
              DoTeeBoxStop;
              AddLog(Format('TCPServer.Execute.Accepted = 타석 종료 (#%d, teebox_no:%d, reserve_no:%s)', [nApiId, nTeeBoxNo, sReserveNo]));
            end;
          TBS_TEEBOX_STATUS:
            begin
              AddLog(Format('TCPServer.Execute.Accepted = 타석 상태 조회 (#%d, teebox_no:%d, reserve_no:%s, remain_min:%d [%d secs.])', [nApiId, nTeeBoxNo, sReserveNo, nMinutes, nSeconds]));
              case nStatus of
                0: //유휴 상태
                  TeeBoxPlayMode := TBS_TEEBOX_STOP;
                1: //준비상태
                  DoTeeBoxPrepare(nSeconds);
                2: //이용중
                  DoTeeBoxStart(nSeconds);
                else
                  Exit
              end;
            end;
          TBS_TEEBOX_AGENT:
            begin
              case nMethod of
                CTA_CTRL_SHUTDOWN:
                  begin
                    AddLog(Format('TCPServer.Execute.Accepted = 타석기 끄기 (#%d, method:%d, teebox_no:%d)', [nApiId, nMethod, nTeeBoxNo]));
                    SendMessage(MainForm.Handle, CWM_DO_SHUTDOWN, 0, 0);
                    bNeedTerminate := True;
                  end;
                CTA_CTRL_REBOOT:
                  begin
                    AddLog(Format('TCPServer.Execute.Accepted = 타석기 재시작 (#%d, method:%d, teebox_no:%d)', [nApiId, nMethod, nTeeBoxNo]));
                    SendMessage(MainForm.Handle, CWM_DO_REBOOT, 0, 0);
                    bNeedTerminate := True;
                  end;
                CTA_CTRL_UPDATE: //셀프 업데이트
                  begin
                    AddLog(Format('TCPServer.Execute.Accepted = 프로그램 재실행/업데이트 (#%d, method:%d, teebox_no:%d))', [nApiId, nMethod, nTeeBoxNo]));
                    bNeedTerminate := CallLauncher(sResultMsg);
                  end;
                CTA_CTRL_CLOSE: //종료
                  begin
                    AddLog(Format('TCPServer.Execute.Accepted = 프로그램 종료 (#%d, method:%d, teebox_no:%d))', [nApiId, nMethod, nTeeBoxNo]));
                    bNeedTerminate := True;
                  end;
                CTA_CTRL_LBP_ON,
                CTA_CTRL_LBP_OFF:
                  begin
                    AddLog(Format('TCPServer.Execute.Accepted = 빔 프로젝터 화면 %s (#%d, method:%d, teebox_no:%d))', [IIF(nMethod = CTA_CTRL_LBP_OFF, '끄기', '켜기'), nApiId, nMethod, nTeeBoxNo]));
                    ExtendScreen := (nMethod = CTA_CTRL_LBP_ON);
                  end;
              end;
            end
        end;

        if bNeedTerminate then
        begin
          Global.Closing := True;
          SendMessage(Self.Handle, WM_CLOSE, 0, 0);
        end;
      end;
    finally
      CkJsonObject_Dispose(JO);
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
      AddLog(Format('TCPServer.Execute.Exception = %s', [E.Message]));
  end;
end;

procedure TMainForm.OnChangeActiveMediaThread(Sender: TObject);
begin
  with TMediaPlayThread(Sender) do
    AddLog('메인 콘텐츠 재생 ' + IIF(Active, '시작', '중지'));
end;

procedure TMainForm.OnChangeContentMediaThread(Sender: TObject);
var
  nIndex: Integer;
begin
  with TMediaPlayThread(Sender) do
  begin
    nIndex := TMediaPlayThread(Sender).ItemIndex;
    if (nIndex >= 0) then
      AddLog(Format('메인 콘텐츠 변경 = %s (%d Secs.)', [PContentInfo(Contents[nIndex])^.FileName, PContentInfo(Contents[nIndex])^.PlayTime]));
  end;
end;

procedure TMainForm.DoRemainTimeMouseDown(AWinControl: TWinControl);
begin
  if AdminMode then
  begin
    ReleaseCapture;
    AWinControl.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TMainForm.panRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pgcMain.Visible then
    DoRemainTimeMouseDown(panRemainTime)
  else
    DoRemainTimeMouseDown(Self);
end;

procedure TMainForm.lblRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pgcMain.Visible then
    DoRemainTimeMouseDown(panRemainTime)
  else
    DoRemainTimeMouseDown(Self);
end;

procedure TMainForm.lblRemainTimeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (SecondsBetween(FHitLastWorked, Now) > 10) then
    FHitCount := 0;
  FHitLastWorked := Now;
  Inc(FHitCount);
  if (FHitCount > 4) then
  begin
    FHitCount := 0;
    AdminMode := DoCheckAdmin;
  end;
end;

procedure TMainForm.lbxLogKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    btnLogClose.Click;
end;

procedure TMainForm.VideoPlayerLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
begin
  //Global.AddLog('Screen.VideoPlayer [' + Severity + '] ' + InfoMsg);
  if (LogType in [TLogType.e_failed, TLogType.e_failed_to_open_player]) then
    MediaPlayThread.VideoPlaying := False;
end;

procedure TMainForm.VideoPlayerPlayerStateChanged(Sender: TObject; OldPlayerState, NewPlayerState: TPlayerState);
begin
  if Assigned(MediaPlayThread) and
     (OldPlayerState = ps_Playing) and ((NewPlayerState = ps_Paused) or (NewPlayerState = ps_Stopped)) then
  begin
    TVideoGrabber(Sender).StopPlayer;
    TVideoGrabber(Sender).ClosePlayer;
    MediaPlayThread.VideoPlaying := False;
  end;
end;

procedure TMainForm.btnAppRestartClick(Sender: TObject);
begin
//
end;

procedure TMainForm.btnLogCloseClick(Sender: TObject);
begin
  pgcMain.ActivePageIndex := FLastMainPageIndex;
{$IFDEF RELEASE}
  ShowCursor(Global.ShowMouseCursor);
{$ENDIF}
end;

procedure TMainForm.btnTeeBoxMoveClick(Sender: TObject);
begin
  if AdminMode then
    pmnMainMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TMainForm.actSaveRemainPosExecute(Sender: TObject);
var
  sErrMsg: string;
begin
  Self.FormStyle := TFormStyle.fsNormal;
  if (SBMsgBox(Self.Handle, mtConfirmation, '확인', '잔여시간 표시 위치를 저장하시겠습니까?', ['예', '아니오']) <> mrOK) then
    Exit;

  with Global do
  try
    if pgcMain.Visible then
    begin
      MainFormInfo.RemainLeft := panRemainTime.Left;
      MainFormInfo.RemainTop := panRemainTime.Top;
    end
    else
    begin
      MainFormInfo.RemainLeft := Self.Left;
      MainFormInfo.RemainTop := Self.Top;
    end;

    if Assigned(SF) then
    begin
      ScreenFormInfo.RemainLeft := SF.RemainLeft;
      ScreenFormInfo.RemainTop := SF.RemainTop;
    end;

    WriteConfig;
    if (SBMsgBox(Self.Handle, mtConfirmation, '확인', '타석기AD에도 설정 내역을 전송하시겠습니까?', ['예', '아니오']) = mrOK) then
    begin
      if not PostAgentConfig(sErrMsg) then
        raise Exception.Create(sErrMsg);

      SBMsgBox(Self.Handle, mtInformation, '알림', '타석기AD에 설정 내역 전송을 완료하였습니다.', ['확인'], 3);
    end;
  except
    on E: Exception do
      SBMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 3);
  end;
end;

procedure TMainForm.actLogViewExecute(Sender: TObject);
begin
  DoLogView;
end;

procedure TMainForm.actConfigExecute(Sender: TObject);
begin
  DoConfig;
end;

procedure TMainForm.actBackToGameExecute(Sender: TObject);
begin
  AdminMode := False;
end;

procedure TMainForm.actAppRestartExecute(Sender: TObject);
var
  sErrMsg: string;
begin
  if CallLauncher(sErrMsg) then
  begin
    Global.Closing := True;
    SendMessage(Self.Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TMainForm.actAppCloseExecute(Sender: TObject);
begin
  Self.Close;
end;

function TMainForm.ActivateCkDLL(var AErrMsg: string): Boolean;
var
  CkGlobal: HCkGlobal;
  nStatus: Integer;
begin
  Result := False;
  AErrMsg := '';
  CkGlobal := CkGlobal_Create;
  try
    try
      if not CkGlobal_UnlockBundle(CkGlobal, CK_LICENSE_KEY) then
        raise Exception.Create(CkGlobal__lastErrorText(CkGlobal));

      nStatus := CkGlobal_getUnlockStatus(CkGlobal);
      if (nStatus <> 2) then
        raise Exception.Create(Format('Status=%d', [nStatus]));

      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    CkGlobal_Dispose(CkGlobal);
  end;
end;

procedure TMainForm.DoInit;
var
  sErrMsg: string;
begin
  try
{$IFDEF RELEASE}
    ShowCursor(Global.ShowMouseCursor);
{$ENDIF}
    GetMonitorsInfo;
    if not ActivateCkDLL(sErrMsg) then
      AddLog(Format('ActivateCkDLL.Exception = %s', [sErrMsg]));

    (*
    case Global.TeeBoxInfo.Vendor of
      GST_KAKAO_VX:
        FSimulatorHandle := FindWindow(PWideChar(SIM_KAKAO_VX_CLASS), PWideChar(SIM_KAKAO_VX_WINDOW))
    end;
    Global.AddLog(Format('TR Handle = %d', [FSimulatorHandle]));
    *)

    FIsDisplaySwitch := FileExists(Global.HomeDir + CCS_DSAPP_NAME) or
                        FileExists(IncludeTrailingPathDelimiter(GetSysDir) + CCS_DSAPP_NAME);
    if not FIsDisplaySwitch then
      AddLog(CCS_DSAPP_NAME + ' file does not exists.');
    ExtendScreen := True;

    if not Assigned(FBaseTimer) then
      FBaseTimer := TBaseTimerThread.Create;
    if not FBaseTimer.Started then
      FBaseTimer.Start;

    if not ActiveServer then
      ActiveServer := True;

    if not Assigned(CheckConnectThread) then
      CheckConnectThread := TCheckConnectThread.Create;
    if not CheckConnectThread.Started then
      CheckConnectThread.Start;

    if not Assigned(MediaPlayThread) then
    begin
      MediaPlayThread := TMediaPlayThread.Create(True, PicShow, VideoPlayer, Global.ContentsDir);
      MediaPlayThread.OnChangeActive := OnChangeActiveMediaThread;
      MediaPlayThread.OnChangeContent := OnChangeContentMediaThread;
    end;
    if not MediaPlayThread.Started then
      MediaPlayThread.Start;

    if (not Assigned(SF)) and
       Global.TeeBoxInfo.DualScreen then
    begin
      SF := TScreenForm.Create(nil);
      SF.Show;
    end;

    TeeBoxPlayMode := TBS_TEEBOX_STOP;
  except
    on E: Exception do
      AddLog(Format('DoInit.Exception = %s', [E.Message]));
  end;
end;

function TMainForm.DoCheckAdmin: Boolean;
var
  sErrMsg: string;
begin
  Result := False;
  Self.SetFocus;
  if not Assigned(PF) then
    PF := TPasswordForm.Create(nil);

  try
    PF.Top := (Global.MainFormInfo.Height div 2) - (PF.Height div 2);
    PF.Left := (Global.MainFormInfo.Width div 2) - (PF.Width div 2);
    Self.AdminCheckMode := True;
    Self.FormStyle := TFormStyle.fsNormal;
    ShowCursor(True);
    case PF.ShowModal of
      mrOK:
        begin
          if (PF.InputValue <> FormatDateTime('mmdd', Now)) then
          begin
            SBMsgBox(Self.Handle, mtWarning, '알림', '비밀번호가 일치하지 않습니다!', ['확인'], 3);
            Exit;
          end;
          Result := True;
        end;
      mrRetry: //재실행
        begin
          SBMsgBox(Self.Handle, mtConfirmation, '알림', Format('런처(%d)를 재실행 합니다!', [FLauncherHandle]), ['확인']);
          if not CallLauncher(sErrMsg) then
            SBMsgBox(Self.Handle, mtWarning, '알림', '런처 (재)실행 실패!' + _CRLF + sErrMsg, ['확인'], 3)
          else
          begin
            Global.Closing := True;
            SendMessage(Self.Handle, WM_CLOSE, 0, 0);
          end;
        end;
      mrAbort: //종료
        SendMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;
  finally
    FreeAndNil(PF);
{$IFDEF RELEASE}
    ShowCursor(Global.ShowMouseCursor);
    Self.FormStyle := TFormStyle.fsStayOnTop;
    Self.AdminCheckMode := False;
{$ENDIF}
  end;
end;

procedure TMainForm.DoConfig;
var
  sErrMsg: string;
begin
  if not AdminMode then
    Exit;

  Self.FormStyle := TFormStyle.fsNormal;
  Self.SetFocus;
  ShowCursor(True);

  if not Assigned(CF) then
    CF := TConfigForm.Create(nil);

  try
    with Global do
    try
      CF.Top := (MainFormInfo.Height div 2) - (CF.Height div 2);
      CF.Left := (MainFormInfo.Width div 2) - (CF.Width div 2);

      CF.edtStoreCode.text          := StoreCode;
      CF.ckbAppAutoStart.Checked    := AppAutoStart;
      CF.edtShutdownTimeout.Value   := ShutdownTimeout;
      CF.ckbHideTaskBar.Checked     := HideTaskBar;
      CF.ckbShowMouseCursor.Checked := ShowMouseCursor;
      CF.edtWaitingIdleTime.Value   := WaitingIdleTime;
      CF.ckbLogDelete.Checked       := LogDelete;
      CF.edtLogDeleteDays.Value     := LogDeleteDays;

      CF.cbxTeeBoxVendor.ItemIndex     := TeeBoxInfo.Vendor;
      CF.edtTeeBoxNo.Value             := TeeBoxInfo.TeeBoxNo;
      CF.rdgTeeBoxLeftHanded.ItemIndex := IIF(TeeBoxInfo.LeftHanded, 1, 0);
      CF.ckbTeeBoxDualScreen.Checked   := TeeBoxInfo.DualScreen;
      CF.ckbTeeBoxScreenOnOff.Checked  := TeeBoxInfo.ScreenOnOff;

      CF.edtMainLeft.Value       := MainFormInfo.Left;
      CF.edtMainTop.Value        := MainFormInfo.Top;
      CF.edtMainWidth.Value      := MainFormInfo.Width;
      CF.edtMainHeight.Value     := MainFormInfo.Height;

      if pgcMain.Visible then
      begin
        CF.edtMainRemainLeft.Value := panRemainTime.Left;
        CF.edtMainRemainTop.Value  := panRemainTime.Top;
      end
      else
      begin
        CF.edtMainRemainLeft.Value := Self.Left;
        CF.edtMainRemainTop.Value  := Self.Top;
      end;

      if Assigned(SF) then
      begin
        CF.edtScreenLeft.Value       := ScreenFormInfo.Left;
        CF.edtScreenTop.Value        := ScreenFormInfo.Top;
        CF.edtScreenWidth.Value      := ScreenFormInfo.Width;
        CF.edtScreenHeight.Value     := ScreenFormInfo.Height;
        CF.edtScreenRemainTop.Value  := SF.RemainTop; //현재 위치
        CF.edtScreenRemainLeft.Value := SF.RemainLeft; //현재 위치
      end;

      CF.cbxAPIServerProvider.ItemIndex := APIServer.Provider;
      CF.edtAPIServerHost.Text          := ExcludeTrailingSlash(APIServer.Host);
      CF.edtAPIServerTimeout.Value      := APIServer.Timeout;
      CF.edtAPIServerApiKey.Text        := APIServer.ApiKey;
      CF.edtAPIServerClientId.Text      := APIServer.ClientId;

      CF.edtTeeBoxADHost.Text     := ExcludeTrailingSlash(TeeBoxADInfo.Host);
      CF.edtTeeBoxADPort.Value    := TeeBoxADInfo.Port;
      CF.edtTeeBoxADTimeout.Value := TeeBoxADInfo.Timeout;

      CF.edtUpdateUrl.Text            := Launcher.UpdateUrl;
      CF.ckbRebootWhenUpdated.Checked := Launcher.RebootWhenUpdated;
      CF.edtRunAppName.Text           := Launcher.RunAppName;
      CF.edtRunAppParams.Text         := Launcher.RunAppParams;
      CF.edtRunAppDelay.Value         := Launcher.RunAppDelay;
      CF.edtWatchInterval.Value       := Launcher.WatchInterval;
      CF.ExtAppList                   := Launcher.ExtAppList;
      CF.RefreshControl;

      if (CF.ShowModal = mrOK) then
      begin
        StoreCode       := CF.edtStoreCode.text;
        ShutdownTimeout := CF.edtShutdownTimeout.Value;
        AppAutoStart    := CF.ckbAppAutoStart.Checked;
        HideTaskBar     := CF.ckbHideTaskBar.Checked;
        ShowMouseCursor := CF.ckbShowMouseCursor.Checked;
        LogDelete       := CF.ckbLogDelete.Checked;
        LogDeleteDays   := CF.edtLogDeleteDays.Value;

        TeeBoxInfo.Vendor      := CF.cbxTeeBoxVendor.ItemIndex;
        TeeBoxInfo.TeeBoxNo    := CF.edtTeeBoxNo.Value;
        TeeBoxInfo.LeftHanded  := (CF.rdgTeeBoxLeftHanded.ItemIndex = 1);
        TeeBoxInfo.DualScreen  := CF.ckbTeeBoxDualScreen.Checked;
        TeeBoxInfo.ScreenOnOff := CF.ckbTeeBoxScreenOnOff.Checked;

        MainFormInfo.Left       := CF.edtMainLeft.Value;
        MainFormInfo.Top        := CF.edtMainTop.Value;
        MainFormInfo.Width      := CF.edtMainWidth.Value;
        MainFormInfo.Height     := CF.edtMainHeight.Value;
        MainFormInfo.RemainTop  := CF.edtMainRemainTop.Value;
        MainFormInfo.RemainLeft := CF.edtMainRemainLeft.Value;

        ScreenFormInfo.Left       := CF.edtScreenLeft.Value;
        ScreenFormInfo.Top        := CF.edtScreenTop.Value;
        ScreenFormInfo.Width      := CF.edtScreenWidth.Value;
        ScreenFormInfo.Height     := CF.edtScreenHeight.Value;
        ScreenFormInfo.RemainTop  := CF.edtScreenRemainTop.Value;
        ScreenFormInfo.RemainLeft := CF.edtScreenRemainLeft.Value;

        APIServer.Provider := CF.cbxAPIServerProvider.ItemIndex;
        APIServer.Host     := ExcludeTrailingSlash(CF.edtAPIServerHost.Text);
        APIServer.ApiKey   := CF.edtAPIServerApiKey.Text;
        APIServer.ClientId := CF.edtAPIServerClientId.Text;

        TeeBoxADInfo.Host    := ExcludeTrailingSlash(CF.edtTeeBoxADHost.Text);
        TeeBoxADInfo.Port    := CF.edtTeeBoxADPort.Value;
        TeeBoxADInfo.Timeout := CF.edtTeeBoxADTimeout.Value;

        Launcher.UpdateUrl         := CF.edtUpdateUrl.Text;
        Launcher.RebootWhenUpdated := CF.ckbRebootWhenUpdated.Checked;
        Launcher.RunAppName        := CF.edtRunAppName.Text;
        Launcher.RunAppParams      := CF.edtRunAppParams.Text;
        Launcher.RunAppDelay       := CF.edtRunAppDelay.Value;
        Launcher.WatchInterval     := CF.edtWatchInterval.Value;
        Launcher.ExtAppList        := CF.ExtAppList;

        WriteConfig;
{$IFDEF RELEASE}
        if AppAutoStart then
          RunOnWindownStart(CCS_LAUNCHER_TITLE, Global.HomeDir + CCS_LAUNCHER_NAME, False)
        else
          RemoveFromRunOnWindowStart(CCS_LAUNCHER_TITLE);
{$ENDIF}

        if (SBMsgBox(Self.Handle, mtConfirmation, '확인',
              '설정 내역을 저장하였습니다.' + #13#10 + '타석기AD에도 설정 내역을 전송하시겠습니까?', ['예', '아니오']) = mrOK) then
        begin
          if not PostAgentConfig(sErrMsg) then
            raise Exception.Create(sErrMsg);

          SBMsgBox(Self.Handle, mtInformation, '알림', '타석기AD에 설정값 전송을 완료하였습니다.', ['확인'], 3);
        end;
      end;
    except
      on E: Exception do
        SBMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 3);
    end;
  finally
    FreeAndNil(CF);
{$IFDEF RELEASE}
    ShowCursor(Global.ShowMouseCursor);
    Self.FormStyle := TFormStyle.fsStayOnTop;
{$ENDIF}
  end;
end;

procedure TMainForm.DoLogView;
begin
  if AdminMode and
     (pgcMain.ActivePage <> tabLog) then
  begin
    ShowCursor(True);
    FMainPageVisible := pgcMain.Visible;
    if not FMainPageVisible then
      ShowMediaPlayer(True);
    pgcMain.ActivePage := tabLog;
  end;
end;

procedure TMainForm.DoDownload;
var
  HTTP: TIdHTTP;
  MS: TMemoryStream;
  sFileUrl, sFileName, sFileExt: string;
  I, nTotal, nCount, nWidth, nHeight: Integer;
begin
  if Global.Downloading then
    Exit;

  AddLog('콘텐츠 다운로드 작업 시작');
  Global.Downloading := True;
  MediaPlayThread.Active := False;
  if Assigned(SF) then
    SF.ActiveMediaPlay := False;

  MS := TMemoryStream.Create;
  HTTP := TIdHTTP.Create(nil);
  try
    try
      HTTP.OnWorkBegin := HTTPDownloaderWorkBegin;
      HTTP.OnWork := HTTPDownloaderWork;
      HTTP.OnWorkEnd := HTTPDownloaderWorkEnd;
      nCount := 0;
      nTotal := Global.MainContents.Count + Global.ScreenContents.Count;
      pbrTotal.Max := nTotal;
      panProgress.Visible := (nTotal > 0);
      if panProgress.Visible then
        panProgress.Top := (panLedBar.Top + panLedBar.Height);

      for I := 0 to Pred(Global.MainContents.Count) do
      begin
        sFileUrl := PContentInfo(Global.MainContents.Items[I])^.FileUrl;
        sFileName := PContentInfo(Global.MainContents.Items[I])^.FileName;
        sFileExt := LowerCase(ExtractFileExt(sFileName));
        if (not FileExists(Global.ContentsDir + sFileName)) and
           ((sFileExt = '.jpg') or (sFileExt = '.mp4')) then
        begin
          MS.Clear;
          HTTP.Get(sFileUrl, MS);
          MS.SaveToFile(Global.ContentsDir + sFileName);
          AddLog(Format('콘텐츠 다운로드 = [%d of %d] %s', [nCount, nTotal, sFileName]));
        end;

        if (sFileExt = '.jpg') then
        begin
          GetJpgSize(Global.ContentsDir + sFileName, nWidth, nHeight);
          if (nWidth > PicShow.Width) or
             (nHeight > PicShow.Height) or
             ((nWidth < PicShow.Width) and (nHeight < PicShow.Height)) then
            PContentInfo(Global.MainContents.Items[I])^.Stretch := True;
        end;

        Inc(nCount);
        pbrTotal.Position := nCount;
      end;
      MediaPlayThread.Contents := Global.MainContents;

      pbrTotal.Max := Global.ScreenContents.Count;
      for I := 0 to Pred(Global.ScreenContents.Count) do
      begin
        sFileUrl := PContentInfo(Global.ScreenContents.Items[I])^.FileUrl;
        sFileName := sFileUrl.SubString(LastDelimiter('/', sFileUrl));
        sFileExt := LowerCase(ExtractFileExt(sFileName));
        if (not FileExists(Global.ContentsDir + sFileName)) and
           ((sFileExt = '.jpg') or (sFileExt = '.mp4')) then
        begin
          MS.Clear;
          HTTP.Get(sFileUrl, MS);
          MS.SaveToFile(Global.ContentsDir + sFileName);
          AddLog(Format('콘텐츠 다운로드 = [%d of %d] %s', [nCount, nTotal, sFileName]));
        end;

        if Assigned(SF) and
           (sFileExt = '.jpg') then
        begin
          GetJpgSize(Global.ContentsDir + sFileName, nWidth, nHeight);
          if (nWidth > SF.PicShow.Width) or
              (nHeight > SF.PicShow.Height) or
              ((nWidth < SF.PicShow.Width) and (nHeight < SF.PicShow.Height)) then
            PContentInfo(Global.ScreenContents.Items[I])^.Stretch := True;
        end;

        Inc(nCount);
        pbrTotal.Position := nCount;
      end;

      AddLog(Format('콘텐츠 다운로드 %d 건 완료', [nCount]));
      if Assigned(SF) then
        SF.Contents := Global.ScreenContents;
    except
      on E: Exception do
        if not E.Message.IsEmpty then
          AddLog(Format('콘텐츠 다운로드 실패 = %s', [E.Message]));
    end;
  finally
    pbrTotal.Position := 0;
    panProgress.Visible := False;
    Global.Downloading := False;
    FreeAndNil(MS);
    FreeAndNil(HTTP);
  end;
  AddLog('콘텐츠 다운로드 작업 종료');
end;

{$IFDEF RELEASE}
procedure TMainForm.DoLogoutProcess;
var
  LogoutMacroThread: TLogoutMacroThread;
begin
  AddLog('사용자 로그아웃 시작');
  LogoutMacroThread := TLogoutMacroThread.Create;
  try
    LogoutMacroThread.Active := True;
    LogoutMacroThread.Start;

    while LogoutMacroThread.Active do
      Application.ProcessMessages;
  finally
    LogoutMacroThread.Terminate;
    AddLog('사용자 로그아웃 종료');
  end;
end;
{$ENDIF}

function TMainForm.CallLauncher(var AErrMsg: string): Boolean;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  sAppCmd: string;
begin
  Result := False;
  AErrMsg := '';
  try
    if (FLauncherHandle = 0) then
      raise Exception.Create(CCS_LAUNCHER_NAME + '가 실행 중이지 않습니다.');
    if not KillProcessByHandle(FLauncherHandle) then
      raise Exception.Create(CCS_LAUNCHER_NAME + '를 강제 종료할 수 없습니다.');
    AddLog(Format('런처 강제 종료 성공 = %s', [sAppCmd]));

    sAppCmd := Global.HomeDir + CCS_LAUNCHER_NAME + ' /noextapp';
    FillChar(SI, SizeOf(TStartupInfo), 0);
    SI.cb := SizeOf(TStartupInfo);
    SI.dwFlags := STARTF_USESHOWWINDOW;
    SI.wShowWindow := SW_SHOW;
    if not CreateProcess(nil, PChar(sAppCmd), nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, SI, PI) then
      raise Exception.Create('CreateProcess Error : ' + sAppCmd);

    WaitForInputIdle(PI.hProcess, INFINITE);
    CloseHandle(PI.hThread);
    CloseHandle(PI.hProcess);
    AddLog(Format('런처 재실행 성공 = %s', [sAppCmd]));
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('런처 재실행 실패 = %s', [AErrMsg]));
    end;
  end;
end;

procedure TMainForm.HTTPDownloaderWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  pbrCurrent.Max := AWorkCountMax;
  pbrCurrent.Position := 0;
end;

procedure TMainForm.HTTPDownloaderWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  pbrCurrent.Position := AWorkCount;
end;

procedure TMainForm.HTTPDownloaderWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  pbrCurrent.Max := 100;
  pbrCurrent.Position := 0;
end;

procedure TMainForm.DoTeeBoxPrepare(const APrepareSeconds: Integer);
begin
  AddLog('타석 준비');
  TeeBoxPlayMode := TBS_TEEBOX_PREPARE;
  ReadyStart := Now;
  ReadySeconds := APrepareSeconds;
  PrepareSeconds := APrepareSeconds;
end;

procedure TMainForm.DoTeeBoxStart(const ARemainSeconds: Integer);
begin
  AddLog('타석 시작');
  TeeBoxPlayMode := TBS_TEEBOX_START;
  AssignStart := Now;
  AssignSeconds := ARemainSeconds;
  RemainSeconds := ARemainSeconds;
end;

procedure TMainForm.DoTeeBoxStop;
begin
  AddLog('타석 종료');
  FTempTeeBoxPlayMode := TBS_TEEBOX_STOP;
{$IFDEF RELEASE}
  DoLogoutProcess;
{$ENDIF}
  Application.ProcessMessages;
  //로그아웃 이후의 타석 상태가 로그아웃 이전과 같을 경우에만 종료 상태로 변경 처리
  if (FTempTeeBoxPlayMode = TBS_TEEBOX_STOP) then
    TeeBoxPlayMode := TBS_TEEBOX_STOP;
end;

procedure TMainForm.DoTeeBoxIdle;
begin
  AddLog('대기 화면 시작');
  TeeBoxPlayMode := TBS_TEEBOX_IDLE;
end;

procedure TMainForm.ShowMediaPlayer(const AShow: Boolean);
begin
  if AShow then
  begin
    pgcMain.Visible := True;
    MakeRoundedControl(Self, 0, 0);
    Self.Left := Global.MainFormInfo.Left;
    Self.Top := Global.MainFormInfo.Top;
    panRemainTime.Left := Global.MainFormInfo.RemainLeft;
    panRemainTime.Top := Global.MainFormInfo.RemainTop;
  end
  else
  begin
    MakeRoundedControl(Self);
    panRemainTime.Left := 0;
    panRemainTime.Top := 0;
    pgcMain.Visible := False;
    Self.Left := Global.MainFormInfo.RemainLeft;
    Self.Top := Global.MainFormInfo.RemainTop;
  end;
end;

procedure TMainForm.SetActiveServer(const AValue: Boolean);
begin
  if (FActiveServer <> AValue) then
  begin
    FActiveServer := AValue;
    if FActiveServer then
      TCPServer.DefaultPort := Global.TeeBoxInfo.AgentPort;

    TCPServer.Active := FActiveServer;
    AntiFreeze.Active := FActiveServer;
    ledTCPServer.Enabled := FActiveServer;
    AddLog(Format('에이전트 서버가 %s 되었습니다. (Port: %d)', [IIF(FActiveServer, '시작', '중지'), Global.TeeBoxInfo.AgentPort]));
  end;
end;

procedure TMainForm.SetTeeBoxPlayMode(const ATeeBoxPlayMode: Integer);
begin
  if (FTeeBoxPlayMode <> ATeeBoxPlayMode) then
  begin
    FTeeBoxPlayMode := ATeeBoxPlayMode;
    //로그아웃 이전과 이후의 상태를 비교하기 위한 값
    FTempTeeBoxPlaymode := FTeeBoxPlayMode;
    MediaPlayThread.Active := False;
    IdleSeconds := 0;
    if Assigned(SF) then
      SF.TeeBoxPlayMode := FTeeBoxPlayMode;

    case FTeeBoxPlayMode of
      TBS_TEEBOX_IDLE:
        begin
          ShowMediaPlayer(True);
          ledTeeBoxStatus.Enabled := False;
          if (not Global.Downloading) and
             (Global.MainContents.Count > 0) then
          begin
            pgcMain.ActivePage := tabMedia;
            MediaPlayThread.Active := True;
          end
          else
            pgcMain.ActivePage := tabHome;
        end;
      TBS_TEEBOX_PREPARE:
        begin
          ShowMediaPlayer(False);
          ledTeeBoxStatus.Enabled := True;
          ledTeeBoxStatus.LedValue := False;
          ExtendScreen := True;

          if TestMode then
            PrepareSeconds := CCN_TEST_PREPARE_SECONDS;
        end;
      TBS_TEEBOX_START,
      TBS_TEEBOX_CHANGE:
        begin
          ShowMediaPlayer(False);
          ledTeeBoxStatus.Enabled := True;
          ledTeeBoxStatus.LedValue := True;
          ExtendScreen := True;

          if TestMode then
            RemainSeconds := CCN_TEST_ASSIGN_SECONDS;
        end;
      TBS_TEEBOX_STOP:
        begin
          ShowMediaPlayer(True);
          pgcMain.ActivePage := tabHome;
          ledTeeBoxStatus.Enabled := False;
          PrepareSeconds := 0;
          AssignSeconds := 0;
          RemainSeconds := 0;
          lblRemainTime.Font.Color := $00EEEAEF;
          lblRemainTime.Caption := '00:00';
          ExtendScreen := False;
        end
    end;
  end;
end;

procedure TMainForm.SetTestMode(const ATestMode: Boolean);
begin
  FTestMode := ATestMode;
  if Assigned(SF) then
    SF.TestMode := FTestMode;
end;

procedure TMainForm.SetPrepareSeconds(const APrepareSeconds: LongInt);
begin
  if (FPrepareSeconds <> APrepareSeconds) then
  begin
    FPrepareSeconds := APrepareSeconds;
    if (TeeBoxPlayMode = TBS_TEEBOX_PREPARE) then
    begin
      lblRemainTime.Font.Color := $0080FFFF;
      try
        lblRemainTime.Caption := FormatDateTime('nn:ss', FPrepareSeconds / SecsPerDay);
      except
        on E: Exception do
          AddLog(Format('SetPrepareSeconds: 메인 준비시간 설정 오류 = %d, SecsPerDay: %d', [FPrepareSeconds, SecsPerDay]));
      end;
    end;
    if Assigned(SF) then
      SF.PrepareSeconds := APrepareSeconds;
  end;
end;

procedure TMainForm.SetRemainSeconds(const ARemainSeconds: LongInt);
var
  nRemainMin: Integer;
begin
  if (FRemainSeconds <> ARemainSeconds) then
  begin
    FRemainSeconds := ARemainSeconds;
    if Assigned(SF) then
      SF.RemainSeconds := FRemainSeconds;

    if (TeeBoxPlayMode = TBS_TEEBOX_STOP) then
    begin
      lblRemainTime.Font.Color := $00EEEAEF;
      lblRemainTime.Caption := '00:00';
    end
    else if (TeeBoxPlayMode = TBS_TEEBOX_START) or
            (TeeBoxPlayMode = TBS_TEEBOX_CHANGE) then
    begin
      if (FRemainSeconds <= 300) then //5분 이하면 붉은색으로 표시
        lblRemainTime.Font.Color := $000005E9
      else
        lblRemainTime.Font.Color := $00EEEAEF;

      try
        nRemainMin := FRemainSeconds div 60;
        if (nRemainMin >= 60) then //1시간 이상이면
          lblRemainTime.Caption := Format('%d', [nRemainMin]) + FormatDateTime(':ss', FRemainSeconds / SecsPerDay)
        else
          lblRemainTime.Caption := FormatDateTime('nn:ss', FRemainSeconds / SecsPerDay);
      except
        on E: Exception do
          AddLog(Format('SetRemainSeconds: 메인 잔여시간 설정 오류 = %d, SecsPerDay: %d', [FRemainSeconds, SecsPerDay]));
      end;

      if (FRemainSeconds = 0) then
      begin
        DoTeeBoxStop;
        if Assigned(SF) then
          SF.TeeBoxPlayMode := TBS_TEEBOX_STOP;
      end;
    end;
  end;
end;

procedure TMainForm.SetIdleSeconds(const AIdleSeconds: LongInt);
begin
  if (FIdleSeconds <> AIdleSeconds) then
    FIdleSeconds := AIdleSeconds;
end;

procedure TMainForm.SetAdminMode(const AValue: Boolean);
begin
  if (FAdminMode <> AValue) then
  begin
    FAdminMode := AValue;
    IdleSeconds := 0;
    MediaPlayThread.Active := (not FAdminMode);
    if FAdminMode then
    begin
      Self.FormStyle := TFormStyle.fsNormal;
      AdminStart := Now;
      panRemainTime.Color := CCN_COLOR_ADMIN;
      FLastMainPageIndex := pgcMain.ActivePageIndex;
      FLastTeeBoxPlayMode := TeeBoxPlayMode;
      ShowCursor(True);
    end
    else
    begin
{$IFDEF RELEASE}
      Self.FormStyle := TFormStyle.fsStayOnTop;
{$ENDIF}
      panRemainTime.Color := CCN_COLOR_NORMAL;
      pgcMain.ActivePageIndex := FLastMainPageIndex;
      TeeBoxPlayMode := FLastTeeBoxPlayMode;
      ShowCursor(Global.ShowMouseCursor);
    end;

    if Assigned(SF) then
      SF.AdminMode := FAdminMode;
  end;
end;

procedure TMainForm.SetExtendScreen(const AValue: Boolean);
var
  sParam: string;
begin
  if Global.TeeBoxInfo.ScreenOnOff and
     FIsDisplaySwitch and
     (FExtendScreen <> AValue) then
  begin
    try
      if Global.TeeBoxInfo.DualScreen then
        sParam := IIF(AValue, '/extend', '/internal')
      else
        sParam := IIF(AValue, '/clone', '/internal');

      ShellExecute(0, 'open', PChar(CCS_DSAPP_NAME), PChar(sParam), nil, SW_HIDE);
      FExtendScreen := AValue;
    except
      on E: Exception do
        AddLog(Format('SetExtendScreen(%s).Exception = %s', [AValue.ToString(True), E.Message]));
    end;
  end;
end;

procedure TMainForm.DoDeleteLog;
var
  SR: TSearchRec;
  bFound: Boolean;
  sBaseDate, sLogDate: string;
  nResult, nPos: Integer;
begin
  if Global.LogDeleting then
    Exit;

  try
    Global.LogDeleting := True;
    nResult := 0;
    sBaseDate := FormatDateTime('yyyymmdd', IncDay(Now, -Global.LogDeleteDays));
    nPos := Length(Global.AppName) + 2; //XGMobileAD_YYYYMMDD.log
    bFound := (FindFirst(Global.LogDir + Global.AppName + '_*.log', faAnyFile - faDirectory, SR) = 0);
    while bFound do
    begin
      sLogDate := Copy(SR.Name, nPos, 8);
      if (sLogDate >= '20000101') and (sLogDate <= sBaseDate) then
      begin
        DeleteFile(Global.LogDir + SR.Name);
        Inc(nResult);
      end;
      bFound := (FindNext(SR) = 0);
    end;

    if (nResult > 0) then
      AddLog(Format('%d일 이전에 생성된 로그파일 %d개를 삭제하였습니다.', [Global.LogDeleteDays, nResult]));
  finally
    System.SysUtils.FindClose(SR);
    Global.LogDeleted := True;
    Global.LogDeleting := False;
  end;
end;

function TMainForm.PostAgentConfig(var AErrMsg: string): Boolean;
var
  TC: TIdTCPClient;
  JO: HCkJsonObject;
  SS: TStringStream;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      AddLog(Format('PostAgentConfig.Connect = Host: %s:%d, TeeBoxNo: %d', [Global.TeeBoxADInfo.Host, Global.TeeBoxADInfo.Port, Global.TeeBoxInfo.TeeBoxNo]));
      SS.LoadFromFile(Global.AgentIniFileName);
      CkJsonObject_UpdateInt(JO, 'api_id', TBS_TEEBOX_SET_CONFIG);
      CkJsonObject_UpdateInt(JO, 'teebox_no', Global.TeeBoxInfo.TeeBoxNo);
      CkJsonObject_UpdateInt(JO, 'left_handed', IIF(Global.TeeBoxInfo.LeftHanded, 1, 0));
      CkJsonObject_UpdateString(JO, 'settings', PWideChar(SS.DataString));
      sBuffer := CkJsonObject__emit(JO);
      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + 'PostAgentConfig.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.Port;
      TC.ConnectTimeout := Global.TeeBoxADInfo.Timeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.Timeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      sBuffer := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + 'PostAgentConfig.Response.json');
      if not CkJsonObject_Load(JO, PWideChar(sBuffer)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog('PostAgentConfig.Exception = ' + AErrMsg);
      end;
    end;
  finally
    FreeAndNil(SS);
    CkJsonObject_Dispose(JO);
    TC.Disconnect;
    FreeAndNil(TC);
  end;
end;

procedure TMainForm.RequestTeeBoxStatus;
var
  TC: TIdTCPClient;
  JO: HCkJsonObject;
  SS: TStringStream;
  sBuffer, sResCode, sResMsg: string;
begin
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      AddLog(Format('RequestTeeBoxStatus.Connect = Host: %s:%d, TeeBoxNo: %d', [Global.TeeBoxADInfo.Host, Global.TeeBoxADInfo.Port, Global.TeeBoxInfo.TeeBoxNo]));
      SS.LoadFromFile(Global.AgentIniFileName);
      CkJsonObject_UpdateInt(JO, 'api_id', TBS_TEEBOX_STATUS);
      CkJsonObject_UpdateInt(JO, 'teebox_no', Global.TeeBoxInfo.TeeBoxNo);
      sBuffer := CkJsonObject__emit(JO);
      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + 'RequestTeeBoxStatus.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.Port;
      TC.ConnectTimeout := Global.TeeBoxADInfo.Timeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.Timeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      sBuffer := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + 'RequestTeeBoxStatus.Response.json');
      if not CkJsonObject_Load(JO, PWideChar(sBuffer)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
    except
      on E: Exception do
        AddLog('RequestTeeBoxStatus.Exception = ' + E.Message);
    end;
  finally
    FreeAndNil(SS);
    CkJsonObject_Dispose(JO);
    TC.Disconnect;
    FreeAndNil(TC);
  end;
end;

procedure TMainForm.GetMonitorsInfo;
begin
  FPrimaryMonitor := 0;
  FSecondaryMonitor := 0;
  for var I := 0 to Pred(Screen.MonitorCount) do
  begin
    if Screen.Monitors[I].Primary then
    begin
      FPrimaryMonitor := I;
      for var J := 0 to Pred(Screen.MonitorCount) do
      if (J <> FPrimaryMonitor) then
        FSecondaryMonitor := J;
    end;
  end;
end;

procedure TMainForm.CheckConfig;
begin
  with Global.AgentIniFile do
  begin
    if not SectionExists(INI_SECTION_CONFIG) then
    begin
      WriteString( INI_SECTION_CONFIG, 'StoreCode', '');
      WriteString( INI_SECTION_CONFIG, 'StoreStartTime', '');
      WriteString( INI_SECTION_CONFIG, 'StoreEndTime', '');
      WriteInteger(INI_SECTION_CONFIG, 'ShutdownTimeout', 0);
      WriteBool(   INI_SECTION_CONFIG, 'AppAutoStart', False);
      WriteBool(   INI_SECTION_CONFIG, 'HideTaskBar', True);
      WriteBool(   INI_SECTION_CONFIG, 'ShowMouseCursor', False);
      WriteInteger(INI_SECTION_CONFIG, 'WaitingIdleTime', 10);
      WriteBool(   INI_SECTION_CONFIG, 'LogDelete', True);
      WriteInteger(INI_SECTION_CONFIG, 'LogDeleteDays', 30);
      WriteString( INI_SECTION_CONFIG, 'BackgroundImage', '');
      WriteString( INI_SECTION_CONFIG, 'LastUpdated', '');
      WriteToFile(Global.AgentIniFileName, '');
    end;

    if not SectionExists(INI_SECTION_TEEBOX) then
    begin
      WriteToFile(Global.AgentIniFileName, ';Vendor: 0=KAKAO VX, 1=GDR, 2=GDR PLUS');
      WriteInteger(INI_SECTION_TEEBOX, 'Vendor', GST_GDR_PLUS);
      WriteInteger(INI_SECTION_TEEBOX, 'TeeBoxNo', 0);
      WriteBool(   INI_SECTION_TEEBOX, 'LeftHanded', False);
      WriteBool(   INI_SECTION_TEEBOX, 'DualScreen', False);
      WriteBool(   INI_SECTION_TEEBOX, 'ScreenOnOff', False);
      WriteInteger(INI_SECTION_TEEBOX, 'AgentPort', 9901);
      WriteString( INI_SECTION_TEEBOX, 'LogoutMacro', '');
      WriteToFile(Global.AgentIniFileName, '');
    end;

    if not SectionExists(INI_SECTION_FORM_MAIN) then
    begin
      WriteInteger(INI_SECTION_FORM_MAIN, 'Left', Screen.Monitors[FPrimaryMonitor].Left);
      WriteInteger(INI_SECTION_FORM_MAIN, 'Top', Screen.Monitors[FPrimaryMonitor].Top);
      WriteInteger(INI_SECTION_FORM_MAIN, 'Width', Screen.Monitors[FPrimaryMonitor].Width);
      WriteInteger(INI_SECTION_FORM_MAIN, 'Height', Screen.Monitors[FPrimaryMonitor].Height);
      WriteInteger(INI_SECTION_FORM_MAIN, 'RemainTop', 0);
      WriteInteger(INI_SECTION_FORM_MAIN, 'RemainLeft', 0);
      WriteToFile(Global.AgentIniFileName, '');
    end;

    if not SectionExists(INI_SECTION_FORM_SCREEN) then
    begin
      WriteInteger(INI_SECTION_FORM_SCREEN, 'Left', Screen.Monitors[FSecondaryMonitor].Left);
      WriteInteger(INI_SECTION_FORM_SCREEN, 'Top', Screen.Monitors[FSecondaryMonitor].Top);
      WriteInteger(INI_SECTION_FORM_SCREEN, 'Width', Screen.Monitors[FSecondaryMonitor].Width);
      WriteInteger(INI_SECTION_FORM_SCREEN, 'Height', Screen.Monitors[FSecondaryMonitor].Height);
      WriteInteger(INI_SECTION_FORM_SCREEN, 'RemainTop', 0);
      WriteInteger(INI_SECTION_FORM_SCREEN, 'RemainLeft', 0);
      WriteToFile(Global.AgentIniFileName, '');
    end;

    if not SectionExists(INI_SECTION_API_SERVER) then
    begin
      WriteToFile(Global.AgentIniFileName, ';Provider: 0=XPartners, 1=ELOOM');
      WriteInteger(INI_SECTION_API_SERVER, 'Provider', SSP_XPARTNERS);
      WriteString( INI_SECTION_API_SERVER, 'Host', CCC_XTOUCH_API_URL);
      WriteInteger(INI_SECTION_API_SERVER, 'Port', 0);
      WriteInteger(INI_SECTION_API_SERVER, 'Timeout', 5000);
      WriteString( INI_SECTION_API_SERVER, 'ApiKey', '');
      WriteString( INI_SECTION_API_SERVER, 'ClientId', '');
      WriteToFile(Global.AgentIniFileName, '');
    end;

    if not SectionExists(INI_SECTION_LOCAL_SERVER) then
    begin
      WriteString( INI_SECTION_LOCAL_SERVER, 'Host', '192.168.0.200');
      WriteInteger(INI_SECTION_LOCAL_SERVER, 'Port', 9900);
      WriteInteger(INI_SECTION_LOCAL_SERVER, 'Timeout', 5000);
      WriteToFile(Global.AgentIniFileName, '');
    end;
  end;
end;

procedure TMainForm.ReadConfig;
begin
  with Global, Global.AgentIniFile do
  begin
    StoreCode                 := ReadString( INI_SECTION_CONFIG, 'StoreCode', '');
    AppAutoStart              := ReadBool(   INI_SECTION_CONFIG, 'AppAutoStart', False);
    HideTaskBar               := ReadBool(   INI_SECTION_CONFIG, 'HideTaskBar', True);
    ShowMouseCursor           := ReadBool(   INI_SECTION_CONFIG, 'ShowMouseCursor', False);
    WaitingIdleTime           := ReadInteger(INI_SECTION_CONFIG, 'WaitingIdleTime', 10);
    LogDelete                 := ReadBool(   INI_SECTION_CONFIG, 'LogDelete', False);
    LogDeleteDays             := ReadInteger(INI_SECTION_CONFIG, 'LogDeleteDays', 30);
    BackgroundImageFile       := ReadString( INI_SECTION_CONFIG, 'BackgroundImage', '');
    ConfigUpdated             := ReadString( INI_SECTION_CONFIG, 'LastUpdated', '');
    //타석기AD에서 수신하고 있으므로 설정 파일에서 읽어오는 것은 무시: 20230420
    (*
    StoreStartTime            := ReadString( INI_SECTION_CONFIG, 'StoreStartTime', '');
    StoreEndTime              := ReadString( INI_SECTION_CONFIG, 'StoreEndTime', '');
    ShutdownTimeout           := ReadInteger(INI_SECTION_CONFIG, 'ShutdownTimeout', 0);
    *)

    TeeBoxInfo.TeeBoxNo       := ReadInteger(INI_SECTION_TEEBOX, 'TeeBoxNo', 0);
    TeeBoxInfo.Vendor         := ReadInteger(INI_SECTION_TEEBOX, 'Vendor', GST_GDR_PLUS);
    TeeBoxInfo.LeftHanded     := ReadBool(   INI_SECTION_TEEBOX, 'LeftHanded', False);
    TeeBoxInfo.DualScreen     := ReadBool(   INI_SECTION_TEEBOX, 'DualScreen', False);
    TeeBoxInfo.ScreenOnOff    := ReadBool(   INI_SECTION_TEEBOX, 'ScreenOnOff', False);
    TeeBoxInfo.AgentPort      := ReadInteger(INI_SECTION_TEEBOX, 'AgentPort', 9901);
    TeeBoxInfo.LogoutMacro    := ReadString( INI_SECTION_TEEBOX, 'LogoutMacro', '');

    MainFormInfo.Left         := ReadInteger(INI_SECTION_FORM_MAIN, 'Left', Screen.Monitors[FPrimaryMonitor].Left);
    MainFormInfo.Top          := ReadInteger(INI_SECTION_FORM_MAIN, 'Top', Screen.Monitors[FPrimaryMonitor].Top);
    MainFormInfo.Width        := ReadInteger(INI_SECTION_FORM_MAIN, 'Width', Screen.Monitors[FPrimaryMonitor].Left);
    MainFormInfo.Height       := ReadInteger(INI_SECTION_FORM_MAIN, 'Height', Screen.Monitors[FPrimaryMonitor].Height);
    MainFormInfo.RemainTop    := ReadInteger(INI_SECTION_FORM_MAIN, 'RemainTop', 0);
    MainFormInfo.RemainLeft   := ReadInteger(INI_SECTION_FORM_MAIN, 'RemainLeft', 0);

    ScreenFormInfo.Left       := ReadInteger(INI_SECTION_FORM_SCREEN, 'Left', Screen.Monitors[FSecondaryMonitor].Left);
    ScreenFormInfo.Top        := ReadInteger(INI_SECTION_FORM_SCREEN, 'Top', Screen.Monitors[FSecondaryMonitor].Top);
    ScreenFormInfo.Width      := ReadInteger(INI_SECTION_FORM_SCREEN, 'Width', Screen.Monitors[FSecondaryMonitor].Width);
    ScreenFormInfo.Height     := ReadInteger(INI_SECTION_FORM_SCREEN, 'Height', Screen.Monitors[FSecondaryMonitor].Height);
    ScreenFormInfo.RemainTop  := ReadInteger(INI_SECTION_FORM_SCREEN, 'RemainTop', 0);
    ScreenFormInfo.RemainLeft := ReadInteger(INI_SECTION_FORM_SCREEN, 'RemainLeft', 0);

    APIServer.Provider        := ReadInteger(INI_SECTION_API_SERVER, 'Provider', SSP_XPARTNERS);
    APIServer.Host            := ExcludeTrailingSlash(ReadString(INI_SECTION_API_SERVER, 'Host', ''));
    APIServer.Port            := ReadInteger(INI_SECTION_API_SERVER, 'Port', 0);
    APIServer.Timeout         := ReadInteger(INI_SECTION_API_SERVER, 'Timeout', 5000);
    APIServer.ApiKey          := StrDecrypt(ReadString(INI_SECTION_API_SERVER, 'ApiKey', ''));
    APIServer.ClientId        := ReadString( INI_SECTION_API_SERVER, 'ClientId', '');

    TeeBoxADInfo.Host         := ExcludeTrailingSlash(ReadString(INI_SECTION_LOCAL_SERVER,  'Host', ''));
    TeeBoxADInfo.Port         := ReadInteger(INI_SECTION_LOCAL_SERVER, 'Port', 9900);
    TeeBoxADInfo.Timeout      := ReadInteger(INI_SECTION_LOCAL_SERVER, 'Timeout', 5000);
  end;

  with Global, Global.LauncherIniFile do
  begin
    Launcher.RebootWhenUpdated := ReadBool(   INI_SECTION_CONFIG, 'RebootWhenUpdated', False);
    Launcher.UpdateUrl         := ReadString( INI_SECTION_CONFIG, 'UpdateURL', '');
    Launcher.RunAppName        := ReadString( INI_SECTION_CONFIG, 'RunApp', '');
    Launcher.RunAppParams      := ReadString( INI_SECTION_CONFIG, 'Params', '');
    Launcher.RunAppDelay       := ReadInteger(INI_SECTION_CONFIG, 'Delay', 0);
    Launcher.WatchInterval     := ReadInteger(INI_SECTION_CONFIG, 'WatchInterval', 30); //값이 없으면 강제로 30초 지정(타석기 에이전트 런처 전용)
    Launcher.ExtAppList        := ReadString( INI_SECTION_CONFIG, 'ExtAppList', '');
  end;
end;

procedure TMainForm.WriteConfig;
begin
  with Global, Global.AgentIniFile do
  begin
    WriteString( INI_SECTION_CONFIG, 'StoreCode', StoreCode);
    WriteString( INI_SECTION_CONFIG, 'StoreStartTime', StoreStartTime);
    WriteString( INI_SECTION_CONFIG, 'StoreEndTime', StoreEndTime);
    WriteInteger(INI_SECTION_CONFIG, 'ShutdownTimeout', ShutdownTimeout);
    WriteBool(   INI_SECTION_CONFIG, 'AppAutoStart', AppAutoStart);
    WriteBool(   INI_SECTION_CONFIG, 'HideTaskBar', HideTaskBar);
    WriteBool(   INI_SECTION_CONFIG, 'ShowMouseCursor', ShowMouseCursor);
    WriteInteger(INI_SECTION_CONFIG, 'WaitingIdleTime', WaitingIdleTime);
    WriteBool(   INI_SECTION_CONFIG, 'LogDelete', LogDelete);
    WriteInteger(INI_SECTION_CONFIG, 'LogDeleteDays', LogDeleteDays);
    WriteString( INI_SECTION_CONFIG, 'LastUpdated', Global.CurrentDateTime);

    WriteInteger(INI_SECTION_TEEBOX, 'Vendor', TeeBoxInfo.Vendor);
    WriteInteger(INI_SECTION_TEEBOX, 'TeeBoxNo', TeeBoxInfo.TeeBoxNo);
    WriteBool(   INI_SECTION_TEEBOX, 'LeftHanded', TeeBoxInfo.LeftHanded);
    WriteBool(   INI_SECTION_TEEBOX, 'DualScreen', TeeBoxInfo.DualScreen);
    WriteBool(   INI_SECTION_TEEBOX, 'ScreenOnOff', TeeBoxInfo.ScreenOnOff);
    WriteInteger(INI_SECTION_TEEBOX, 'AgentPort', TeeBoxInfo.AgentPort);
    WriteString( INI_SECTION_TEEBOX, 'LogoutMacro', TeeBoxInfo.LogoutMacro);

    WriteInteger(INI_SECTION_FORM_MAIN, 'Left', MainFormInfo.Left);
    WriteInteger(INI_SECTION_FORM_MAIN, 'Top', MainFormInfo.Top);
    WriteInteger(INI_SECTION_FORM_MAIN, 'Width', MainFormInfo.Width);
    WriteInteger(INI_SECTION_FORM_MAIN, 'Height', MainFormInfo.Height);
    WriteInteger(INI_SECTION_FORM_MAIN, 'RemainTop', MainFormInfo.RemainTop);
    WriteInteger(INI_SECTION_FORM_MAIN, 'RemainLeft', MainFormInfo.RemainLeft);

    WriteInteger(INI_SECTION_FORM_SCREEN, 'Left', ScreenFormInfo.Left);
    WriteInteger(INI_SECTION_FORM_SCREEN, 'Top', ScreenFormInfo.Top);
    WriteInteger(INI_SECTION_FORM_SCREEN, 'Width', ScreenFormInfo.Width);
    WriteInteger(INI_SECTION_FORM_SCREEN, 'Height', ScreenFormInfo.Height);
    WriteInteger(INI_SECTION_FORM_SCREEN, 'RemainTop', ScreenFormInfo.RemainTop);
    WriteInteger(INI_SECTION_FORM_SCREEN, 'RemainLeft', ScreenFormInfo.RemainLeft);

    WriteInteger(INI_SECTION_API_SERVER, 'Provider', APIServer.Provider);
    WriteString( INI_SECTION_API_SERVER, 'Host', APIServer.Host);
    WriteInteger(INI_SECTION_API_SERVER, 'Port', APIServer.Port);
    WriteInteger(INI_SECTION_API_SERVER, 'Timeout', APIServer.Timeout);
    WriteString( INI_SECTION_API_SERVER, 'ClientId', APIServer.ClientID);
    WriteString( INI_SECTION_API_SERVER, 'ApiKey', StrEncrypt(APIServer.ApiKey));

    WriteString( INI_SECTION_LOCAL_SERVER, 'Host', TeeBoxADInfo.Host);
    WriteInteger(INI_SECTION_LOCAL_SERVER, 'Port', TeeBoxADInfo.Port);
    WriteInteger(INI_SECTION_LOCAL_SERVER, 'Timeout', TeeBoxADInfo.Timeout);
  end;

  with Global, Global.LauncherIniFile do
  begin
    WriteString( INI_SECTION_CONFIG, 'UpdateURL', Launcher.UpdateUrl);
    WriteBool(   INI_SECTION_CONFIG, 'RebootWhenUpdated', Launcher.RebootWhenUpdated);
    WriteString( INI_SECTION_CONFIG, 'RunApp', Launcher.RunAppName);
    WriteString( INI_SECTION_CONFIG, 'Params', Launcher.RunAppParams);
    WriteInteger(INI_SECTION_CONFIG, 'Delay', Launcher.RunAppDelay);
    WriteInteger(INI_SECTION_CONFIG, 'WatchInterval', Launcher.WatchInterval); //값이 없으면 강제로 30초 지정(타석기 에이전트 런처 전용)
    WriteString( INI_SECTION_CONFIG, 'ExtAppList', Launcher.ExtAppList);
  end;
end;

procedure TMainForm.UpdateConfig_ELOOM(const AIniData: string);
var
  SS: TStringStream;
  MI: TMemInifile;
begin
  SS := TStringStream.Create(AIniData);
  MI := TMemIniFile.Create(SS, TEncoding.ANSI);
  try
    with Global do
    begin
      Launcher.UpdateUrl         := MI.ReadString( INI_SECTION_LAUNCHER, 'UpdateURL', Launcher.UpdateUrl);
      Launcher.WatchInterval     := MI.ReadInteger(INI_SECTION_LAUNCHER, 'WatchInterval', Launcher.WatchInterval);
      Launcher.RunAppName        := MI.ReadString( INI_SECTION_LAUNCHER, 'RunApp', Launcher.RunAppName);
      Launcher.RunAppParams      := MI.ReadString( INI_SECTION_LAUNCHER, 'Params', Launcher.RunAppParams);
      Launcher.RunAppDelay       := MI.ReadInteger(INI_SECTION_LAUNCHER, 'Delay', Launcher.RunAppDelay);
      Launcher.RebootWhenUpdated := MI.ReadBool(   INI_SECTION_LAUNCHER, 'RebootWhenUpdated', Launcher.RebootWhenUpdated);
      Launcher.ExtAppList        := MI.ReadString( INI_SECTION_LAUNCHER, 'ExtAppList', Launcher.ExtAppList);

      (*
      //매장코드는 변경하지 않음
      StoreCode       := MI.ReadString( INI_SECTION_CONFIG, 'StoreCode', StoreCode);
      *)
      StoreStartTime  := MI.ReadString( INI_SECTION_CONFIG, 'StoreStartTime', StoreStartTime);
      StoreEndTime    := MI.ReadString( INI_SECTION_CONFIG, 'StoreEndTime', StoreEndTime);
      ShutdownTimeout := MI.ReadInteger(INI_SECTION_CONFIG, 'ShutdownTimeout', ShutdownTimeout);
      AppAutoStart    := MI.ReadBool(   INI_SECTION_CONFIG, 'AppAutoStart', AppAutoStart);
      WaitingIdleTime := MI.ReadInteger(INI_SECTION_CONFIG, 'WaitingIdleTime', WaitingIdleTime);
      LogDelete       := MI.ReadBool(   INI_SECTION_CONFIG, 'LogDelete', LogDelete);
      LogDeleteDays   := MI.ReadInteger(INI_SECTION_CONFIG, 'LogDeleteDays', LogDeleteDays);
      HideTaskBar     := MI.ReadBool(   INI_SECTION_CONFIG, 'HideTaskBar', HideTaskBar);
      ShowMouseCursor := MI.ReadBool(   INI_SECTION_CONFIG, 'ShowMouseCursor', ShowMouseCursor);
      ConfigUpdated   := MI.ReadString( INI_SECTION_CONFIG, 'LastUpdated', Global.CurrentDateTime);

      (*
      //타석번호는 변경하지 않음
      TeeBoxInfo.TeeBoxNo    := MI.ReadInteger(INI_SECTION_TEEBOX, 'TeeBoxNo', 0);
      *)
      TeeBoxInfo.Vendor      := MI.ReadInteger(INI_SECTION_TEEBOX, 'Vendor', TeeBoxInfo.Vendor);
      TeeBoxInfo.LeftHanded  := MI.ReadBool(   INI_SECTION_TEEBOX, 'LeftHanded', TeeBoxInfo.LeftHanded);
      TeeBoxInfo.DualScreen  := MI.ReadBool(   INI_SECTION_TEEBOX, 'DualScreen', TeeBoxInfo.DualScreen);
      TeeBoxInfo.ScreenOnOff := MI.ReadBool(   INI_SECTION_TEEBOX, 'ScreenOnOff', TeeBoxInfo.ScreenOnOff);
      TeeBoxInfo.AgentPort   := MI.ReadInteger(INI_SECTION_TEEBOX, 'AgentPort', 9901);
      TeeBoxInfo.LogoutMacro := MI.ReadString( INI_SECTION_TEEBOX, 'LogoutMacro', TeeBoxInfo.LogoutMacro);

      MainFormInfo.Top        := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'Top', MainFormInfo.Top);
      MainFormInfo.Left       := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'Left', MainFormInfo.Left);
      MainFormInfo.Height     := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'Height', MainFormInfo.Height);
      MainFormInfo.Width      := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'Width', MainFormInfo.Width);
      MainFormInfo.RemainTop  := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'RemainTop', 0);
      MainFormInfo.RemainLeft := MI.ReadInteger(INI_SECTION_FORM_MAIN, 'RemainLeft', 0);

      ScreenFormInfo.Top        := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'Top', ScreenFormInfo.Top);
      ScreenFormInfo.Left       := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'Left', ScreenFormInfo.Left);
      ScreenFormInfo.Height     := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'Height', ScreenFormInfo.Height);
      ScreenFormInfo.Width      := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'Width', ScreenFormInfo.Width);
      ScreenFormInfo.RemainTop  := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'RemainTop', 0);
      ScreenFormInfo.RemainLeft := MI.ReadInteger(INI_SECTION_FORM_SCREEN, 'RemainLeft', 0);

      APIServer.Provider := MI.ReadInteger(INI_SECTION_API_SERVER, 'Provider', APIServer.Provider);
      APIServer.Host     := ExcludeTrailingSlash(MI.ReadString(INI_SECTION_API_SERVER, 'Host', APIServer.Host));
      APIServer.Port     := MI.ReadInteger(INI_SECTION_API_SERVER, 'Port', APIServer.Port);
      APIServer.Timeout  := MI.ReadInteger(INI_SECTION_API_SERVER, 'Timeout', APIServer.Timeout);
      (*
      //API Key, ClientID는 변경하지 않음
      APIServer.ApiKey   := StrDecrypt(MI.ReadString(INI_SECTION_API_SERVER, 'ApiKey', APIServer.ApiKey));
      APIServer.ClientId := MI.ReadString( INI_SECTION_API_SERVER, 'ClientId', APIServer.ClientId);
      *)

      TeeBoxADInfo.Host    := ExcludeTrailingSlash(MI.ReadString(INI_SECTION_LOCAL_SERVER,  'Host', TeeBoxADInfo.Host));
      TeeBoxADInfo.Port    := MI.ReadInteger(INI_SECTION_LOCAL_SERVER, 'Port', TeeBoxADInfo.Port);
      TeeBoxADInfo.Timeout := MI.ReadInteger(INI_SECTION_LOCAL_SERVER, 'Timeout', TeeBoxADInfo.Timeout);
    end;
  finally
    WriteConfig;
    FreeAndNil(MI);
    FreeAndNil(SS);
  end;
end;

{ TBaseTimerThread }

constructor TBaseTimerThread.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FIntervalMilliSeconds := 1000;
  FLastMilliSeconds := Now;
  FIntervalSeconds := 60;
  FLastSeconds := Now;
  FShutdownWorking := False;
end;

destructor TBaseTimerThread.Destroy;
begin

  inherited;
end;

procedure TBaseTimerThread.Execute;
begin
  inherited;

  repeat
    Synchronize(
      procedure
      var
        sDateTime, sCurrDate, sCurrTime: string;
        nSecs: Integer;
      begin
        if Global.Closing then
          Exit;

        try
          if (MainForm.AdminMode or MainForm.AdminCheckMode) and
             (SecondsBetween(MainForm.AdminStart, Now) > LCN_ADMIN_CHECK_SECONDS) then
          begin
            MainForm.AdminStart := Now;
            MainForm.AdminMode := False;

            if Assigned(PF) then
              SendMessage(PF.Handle, WM_CLOSE, 0, 0);
            if Assigned(CF) then
              SendMessage(CF.Handle, WM_CLOSE, 0, 0);
          end;

          if (MilliSecondsBetween(FLastMilliSeconds, Now) > FIntervalMilliSeconds) then
          begin
            FLastMilliSeconds := Now;
            if not (MainForm.AdminCheckMode or MainForm.AdminMode) then
              SendMessage(MainForm.Handle, CWM_DO_TOPMOST, 0, 0);

            case MainForm.TeeBoxPlayMode of
              TBS_TEEBOX_PREPARE:
                if (MainForm.PrepareSeconds > 0) then
                begin
                  nSecs := (MainForm.ReadySeconds - SecondsBetween(MainForm.ReadyStart, Now));
                  SendMessage(MainForm.Handle, CWM_SET_PREPARE_SECS, nSecs, 0);
                end;
              TBS_TEEBOX_START,
              TBS_TEEBOX_CHANGE:
                if (MainForm.RemainSeconds > 0) then
                begin
                  nSecs := (MainForm.AssignSeconds - SecondsBetween(MainForm.AssignStart, Now));
                  SendMessage(MainForm.Handle, CWM_SET_REMAIN_SECS, nSecs, 0);
                end;
              TBS_TEEBOX_STOP:
                if (not MainForm.AdminMode) then
                begin
                  MainForm.IdleSeconds := (MainForm.IdleSeconds + 1);
                  if (MainForm.IdleSeconds >= Global.WaitingIdleTime) then
                    SendMessage(MainForm.Handle, CWM_DO_TEEBOX_IDLE, 0, 0);
                end
            end;

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
              Global.LogFileName := Format('%s%s_%s.log', [Global.LogDir, Global.AppName, Global.CurrentDate]);
            end;

            if (Global.CurrentTime <> sCurrTime) then
            begin
              Global.CurrentTime := sCurrTime;
              Global.FormattedCurrentTime := FormattedTimeString(sCurrTime);
              Global.CurrentDateTime := Global.CurrentDate + Global.CurrentTime;
              Global.FormattedCurrentDateTime := Global.FormattedCurrentDate + ' ' + Global.FormattedCurrentTime;

              if Global.LogDelete and
                 (not Global.LogDeleted) then
                SendMessage(MainForm.Handle, CWM_DO_DELETE_LOG, 0, 0);

              if (not FShutdownWorking) and
                 (Global.ShutdownTimeout > 0) and
                 (Global.FormattedCurrentTime.Substring(0, 5) = Global.StoreEndTime) then
              begin
                FShutdownWorking := True;
                SendMessage(MainForm.Handle, CWM_DO_SHUTDOWN, Global.ShutdownTimeout * 60, 0);
                Exit;
              end;
            end;
          end;
        except
        end;
      end);

    Sleep(500);
  until Terminated;
end;

{ TCheckConnectThread }

constructor TCheckConnectThread.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FLastworked := (Now - 1);
  FLastServerConnecting := FLastWorked;
  FInterval := (5 * 1000); //5초
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
        sErrMsg: string;
      begin
        try
          ConnectorCS.Acquire;
          if Global.Closing then
            Exit;

          if (not MainForm.AdminMode) and
             (MilliSecondsBetween(FLastWorked, Now) >= FInterval) then
          begin
            FLastWorked := Now;
            //타석기AD 환경설정 수신
            //엑스파트너스 버전만 해당되며 타석기번호가 0이 아닐 경우에만
            if (Global.APIServer.Provider = SSP_XPARTNERS) and
               (Global.TeeBoxInfo.TeeBoxNo > 0) and
               (not Global.TeeBoxADInfo.Connected) then
            begin
              if GetAgentConfig then
                MainForm.RequestTeeBoxStatus; //최종 타석 상태 조회
            end;

            try
              if (not Global.APIServer.Connected) then
              begin
                MainForm.ledAPIServer.LedValue := False;
                CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, Format('APIServerConnectThread.Connecting = Host: %s, ClientId: %s', [Global.APIServer.Host, Global.APIServer.ClientId]));
                if Global.APIServer.Host.IsEmpty or
                   Global.APIServer.ApiKey.IsEmpty or
                   Global.APIServer.ClientId.IsEmpty then
                  Exit;

                if (Global.APIServer.Provider = SSP_XPARTNERS) then
                begin
                  //엑스파트너스 서버는 30분마다 접속 재시도
                  if (MinutesBetween(FLastServerConnecting, Now) < 30) then
                    Exit;

                  FLastServerConnecting := FLastWorked;
                  if not DM.GetToken(Global.APIServer.ClientId, Global.APIServer.ApiKey, Global.APIServer.Token, sErrMsg) then
                    raise Exception.Create(sErrMsg);

                  if not DM.CheckToken(Global.APIServer.Token, Global.APIServer.ClientId, Global.APIServer.ApiKey, sErrMsg) then
                    raise Exception.Create(sErrMsg);

                  if not DM.GetStoreInfo(sErrMsg) then
                    raise Exception.Create(sErrMsg);
                end
                else if (Global.APIServer.Provider = SSP_ELOOM) then
                begin
                  if not DM.GetConfigInfo_ELOOM(FIniDataELOOM, sErrMsg) then
                    raise Exception.Create(sErrMsg);

                  SendMessage(MainForm.Handle, CWM_DO_ELOOM_CONFIG, 0, 0)
                end;

                Global.APIServer.Connected := True;
                MainForm.ledAPIServer.LedValue := True;
                CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, 'APIServerConnectThread.Connected');

                try
                  if not DM.GetContentsList(sErrMsg) then
                    raise Exception.Create(sErrMsg);

                  SendMessage(MainForm.Handle, CWM_DO_DOWNLOAD, 0, 0);
                except
                  on E: Exception do
                    CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, 'APIServerConnectThread.GetContentsList.Exception = ' + E.Message);
                end;
              end;
            except
              on E: Exception do
                CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, 'APIServerConnectThread.Exception = ' + E.Message);
            end;
          end;
        finally
          ConnectorCS.Release;
        end;
      end);

    Sleep(1000);
  until Terminated;
end;

function TCheckConnectThread.GetAgentConfig: Boolean;
var
  TC: TIdTCPClient;
  JO: HCkJsonObject;
  SS: TStringStream;
  SL, IL: TStringList;
  MI: TMemIniFile;
  sBuffer, sSettings, sSection, sItem, sValue, sResCode, sResMsg: string;
  I, J: Integer;
begin
  Result := False;
  if FWorking then
    Exit;

  FWorking := True;
  CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG,
    Format('GetAgentConfig.Connect = StoreCode: %s, Host: %s:%d, TeeBoxNo: %d, LeftHanded: %s',
      [Global.StoreCode, Global.TeeBoxADInfo.Host, Global.TeeBoxADInfo.Port, Global.TeeBoxInfo.TeeBoxNo, BoolToStr(Global.TeeBoxInfo.LeftHanded)]));
  JO := CkJsonObject_Create;
  TC := TIdTCPClient.Create(nil);
  SS := nil;
  try
    try
      CkJsonObject_UpdateInt(JO, 'api_id', TBS_TEEBOX_GET_CONFIG);
      CkJsonObject_UpdateInt(JO, 'teebox_no', Global.TeeBoxInfo.TeeBoxNo);
      CkJsonObject_UpdateInt(JO, 'left_handed', IIF(Global.TeeBoxInfo.LeftHanded, 1, 0));
      CkJsonObject_UpdateString(JO, 'mac_addr', PWideChar(Global.MacAddr));
      sBuffer := CkJsonObject__emit(JO);
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + 'GetAgentConfig.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.Port;
      TC.ConnectTimeout := Global.TeeBoxADInfo.Timeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.Timeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      sBuffer := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      Global.TeeBoxADInfo.Connected := True;

      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + 'GetAgentConfig.Response.json');
      if not CkJsonObject_Load(JO, PWideChar(sBuffer)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Global.StoreStartTime := CkJsonObject__stringOf(JO, 'start_time');
      Global.StoreEndTime := CkJsonObject__stringOf(JO, 'end_time');
      Global.ShutdownTimeout := CkJsonObject_IntOf(JO, 'shutdown_timeout');
      sSettings := CkJsonObject__stringOf(JO, 'settings');
      if not sSettings.IsEmpty then
      begin
        SS.Clear;
        SS.WriteString(sSettings);
        SL := TStringList.Create;
        IL := TStringList.Create;
        MI := TMemIniFile.Create(SS, TEncoding.ANSI);
        try
          MI.ReadSections(SL);
          for I := 0 to Pred(SL.Count) do
          begin
            sSection := SL[I];
            MI.ReadSection(sSection, IL);
            for J := 0 to Pred(IL.Count) do
            begin
              sItem := IL[J];
              sValue := MI.ReadString(sSection, sItem, Global.AgentIniFile.ReadString(sSection, sItem, ''));
              Global.AgentIniFile.WriteString(sSection, sItem, sValue);
            end;
          end;
          SendMessage(MainForm.Handle, CWM_DO_READ_CONFIG, 0, 0);
          CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, 'GetAgentConfig.Updated');
        finally
          FreeAndNil(IL);
          FreeAndNil(SL);
          FreeAndNil(MI);
        end;
      end;
      Result := True;
    except
      on E: Exception do
        CopyDataString(MainForm.Handle, CWM_DO_UPDATE_LOG, 'GetAgentConfig.Exception = ' + E.Message);
    end;
  finally
    FWorking := False;
    if Assigned(SS) then
      FreeAndNil(SS);
    if Assigned(JO) then
      CkJsonObject_Dispose(JO);
    TC.Disconnect;
    FreeAndNil(TC);
  end;
end;

{ TLogoutMacroThread }

constructor TLogoutMacroThread.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FActive := False;
end;

destructor TLogoutMacroThread.Destroy;
begin

  inherited;
end;

procedure TLogoutMacroThread.Execute;
begin
  inherited;

  repeat
    Synchronize(
      procedure
      var
        A1, A2: TArray<string>;
        I: Integer;
      begin
        try
          LogoutCS.Acquire;
          if Active {and (not FWorking)} then
          try
            EnableWindow(MainForm.Handle, False);
            //0,0,20;1885,40,1;1756,46,1;1827,1008,1;1175,627,1;1577,657,1;1840,1030,1;988,623,1;1344,657,1
            A1 := SplitString(Global.TeeBoxInfo.LogoutMacro, ';');
            for I := 0 to Length(A1) - 1 do
            begin
              A2 := SplitString(A1[I], ',');
              if (Length(A2) = 3) then
                SimulateMouseLeftClick(StrToIntDef(A2[0], -1), StrToIntDef(A2[1], -1), StrToIntDef(A2[2], -1));
            end;
          except
          end;
        finally
          EnableWindow(MainForm.Handle, True);
          LogoutCS.Release;
          Active := False;
        end;
      end);

    Sleep(500);
  until Terminated;
end;

initialization
  ConnectorCS := TCriticalSection.Create;
  LogoutCS := TCriticalSection.Create;
  DM := TDM.Create(nil);
finalization
  DM.Free;
  LogoutCS.Free;
  ConnectorCS.Free;
end.
