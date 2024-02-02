(* ******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 대시보드
  Author      : 이선우
  Description :
  History     :
  Version   Date         Remark
  --------  ----------   -----------------------------------------------------
  1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

  ****************************************************************************** *)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGDashboard;

interface

uses
  {Native}
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  OleCtrls, SHDocVw,
  {Plugin System}
  uPluginManager, uPluginModule, uPluginMessages,
  {DevExpress}
  dxGDIPlusClasses, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxCheckBox, cxTextEdit, cxPC,
  {TMS}
  AdvShapeButton,
  {SolbiLib}
  AAFont, AACtrls,
  {Project}
  uXGGlobal, uXGReceiptPrint;

{$I ..\..\common\XGPOS.inc}

type
  TSubMenu = record
    MenuId: Integer;
    Caption: string;
  end;

const
  LCN_SUBMENU_COLS = 14;
  LCA_SUBMENU_1: array [0 .. 3] of TSubMenu = (
    (MenuId: 101; Caption: '판매관리'),
    (MenuId: 102; Caption: '타석' + _CRLF + '배정관리'),
    (MenuId: 103; Caption: '라커관리'),
    (MenuId: 104; Caption: '공지사항'));
  LCA_SUBMENU_2: array [0 .. 4] of TSubMenu = (
    (MenuId: 201; Caption: '파트너센터' + _CRLF + '홈'),
    (MenuId: 202; Caption: '회원검색'),
    (MenuId: 203; Caption: '매출현황'),
    (MenuId: 204; Caption: '스펙트럼' + _CRLF + '연동 확인'),
    (MenuId: 205; Caption: '날씨예보'));
  LCA_SUBMENU_3: array [0 .. 11] of TSubMenu = (
    (MenuId: 301; Caption: '사용자' + _CRLF + '환경 설정'),
    (MenuId: 302; Caption: '시스템' + _CRLF + '환경 설정'),
    (MenuId: 303; Caption: '마스터' + _CRLF + '수신'),
    (MenuId: 304; Caption: '단말기' + _CRLF + '무결성 체크'),
    (MenuId: 305; Caption: '긴급배정' + _CRLF + '시작'),
    (MenuId: 306; Caption: '긴급배정' + _CRLF + '종료'),
    (MenuId: 307; Caption: '긴급배정' + _CRLF + '내역 조회'),
    (MenuId: 308; Caption: '알리미 실행'),
    (MenuId: 309; Caption: '알리미' + _CRLF + '동작 테스트'),
    (MenuId: 310; Caption: '외부기기' + _CRLF + '원격시동'),
    (MenuId: 311; Caption: '웹브라우저' + _CRLF + '업데이트'),
    (MenuId: 312; Caption: '웹브라우저' + _CRLF + '복구'));
  LCA_SUBMENU_4: array [0 .. 3] of TSubMenu = (
    (MenuId: 401; Caption: '프로그램' + _CRLF + '종료'),
    (MenuId: 402; Caption: '로그아웃'),
    (MenuId: 403; Caption: '시스템' + _CRLF + '리부팅'),
    (MenuId: 404; Caption: '시스템' + _CRLF + '셧다운'));

type
  TTeeBoxStatusThread = class(TThread)
  private
    FLastWorked: TDateTime;
    FForceRefresh: Boolean;
    FInterval: Integer;
  protected
    procedure Execute; override;
  published
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
    property ForceRefresh: Boolean read FForceRefresh write FForceRefresh;
  end;

  TXGDashboardForm = class(TPluginModule)
    tmrClock: TTimer;
    panLeftSide: TPanel;
    pgcStartUp: TcxPageControl;
    tabLogin: TcxTabSheet;
    tabSaleStart: TcxTabSheet;
    imgLoginBack: TImage;
    edtUserId: TcxTextEdit;
    edtTerminalPwd: TcxTextEdit;
    panRightSide: TPanel;
    panNumPad: TPanel;
    btnClose: TAdvShapeButton;
    btnSaleStart: TAdvShapeButton;
    panAccountInfo: TPanel;
    lblStoreName: TLabel;
    panUserInfo: TPanel;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    tabPrepare: TcxTabSheet;
    lblPOSName: TLabel;
    lblUserName: TLabel;
    ckbSaveUserInfo: TcxCheckBox;
    panBasePanel: TPanel;
    WB: TWebBrowser;
    panMainMenu: TPanel;
    btnMainSale: TAdvShapeButton;
    btnMainWeb: TAdvShapeButton;
    btnMainConfig: TAdvShapeButton;
    btnMainClose: TAdvShapeButton;
    panSubMenu: TPanel;
    btnSubMenu1: TAdvShapeButton;
    btnSubMenu2: TAdvShapeButton;
    btnSubMenu3: TAdvShapeButton;
    btnSubMenu4: TAdvShapeButton;
    btnSubMenu5: TAdvShapeButton;
    btnSubMenu6: TAdvShapeButton;
    btnSubMenu7: TAdvShapeButton;
    btnSubMenu8: TAdvShapeButton;
    btnSubMenu9: TAdvShapeButton;
    btnSubMenu10: TAdvShapeButton;
    btnSubMenu11: TAdvShapeButton;
    btnSubMenu12: TAdvShapeButton;
    btnSubMenu13: TAdvShapeButton;
    btnSubMenu14: TAdvShapeButton;
    btnSubPrev: TAdvShapeButton;
    btnSubNext: TAdvShapeButton;
    panNoticeList: TPanel;
    imgNotice: TImage;
    astNoticeList: TAAScrollText;
    panVersionInfo: TPanel;
    lblPlatformVersion: TLabel;
    lblPluginVersion: TLabel;
    lblPoweredBy: TLabel;
    imgSolbiPOS: TImage;
    imgNHNKCP: TImage;
    imgTeeBoxEmergency: TImage;
    imgLogo: TImage;
    lblUpdateUrl: TLabel;

    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrClockTimer(Sender: TObject);
    procedure OnTextEditEnter(Sender: TObject);
    procedure edtTerminalPwdKeyPress(Sender: TObject; var Key: Char);
    procedure btnMainMenuClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSubMenuClick(Sender: TObject);
    procedure btnSaleStartClick(Sender: TObject);
    procedure astNoticeListClick(Sender: TObject);
    procedure astNoticeListComplete(Sender: TObject);
    procedure imgNHNKCPClick(Sender: TObject);
    procedure imgSolbiPOSClick(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FUserLogged: Boolean;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FSubMenuButton: array [0 .. Pred(LCN_SUBMENU_COLS)] of TAdvShapeButton;
    FTeeBoxStatusThread: TTeeBoxStatusThread;
    FWebPageFile: string;
    FNoticeIndex: Integer;
    FNoticeUrl: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure StartUp;
    procedure InitDevice;
    procedure BuildSubMenu(const ACategory: Integer; ASubMenu: array of TSubMenu);
    function DoSystemConfig: Boolean;
    function DoLocalConfig: Boolean;
    function DoAuthorize(var AErrMsg: string): Boolean;
    function DoPrepare: Boolean;
    function DoLogin: Boolean;
    procedure DoRefreshNotice;
    procedure DoRemoteWakeup;
    function DoEmergencyReservationStart: Boolean;
    procedure DoEmergencyReservationStop;
    procedure ShowEmergencyReservationList;
    procedure ShowWebView(const ATitle, AUrl: string; const AShowNoMoreToday: Boolean=False);
    procedure AskLogout;
    procedure AskClose;
    procedure AskShutdown(const AReboot: Boolean = False);
    procedure RunAdminCallApp(const AShowErrorMsg: Boolean = False);
    procedure DoRestoreWebBrowserPosition;
    procedure SetPermissions;
    procedure SetUserLogged(const AValue: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage = nil);
      override;
    destructor Destroy; override;

    property UserLogged: Boolean read FUserLogged write SetUserLogged;
  end;

var
  XGDashboardForm: TXGDashboardForm;

implementation

uses
  {Native}
  ComPort, ShellAPI, System.Win.Registry, DateUtils, JSON, IniFiles,
  {Indy}
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdGlobal,
  {Project}
  uXGClientDM, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGInputBox, uNetLib, uNBioBSPHelper,
  uUCBioBSPHelper;

{$R *.dfm}
{ TDashboardForm }

constructor TXGDashboardForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
  sImgName: string;
  I, J: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetPermissions;
  FWebPageFile := ExpandFileName(GetCurrentDir) + '\contents\index.html';

  // 지문인식기 설정
  with Global.DeviceConfig.FingerPrintScanner do
    if Enabled and (not Assigned(Scanner)) then
    begin
      case DeviceType of
        CFT_NITGEN:
          Scanner := TNBioBSPHelper.Create(EnrollQuality, EnrollQuality, IdentifyQuality, VerifyQuality, SecurityLevel, DefaultTimeout);
        CFT_UC:
          Scanner := TUCBioBSPHelper.Create(EnrollQuality, EnrollQuality, IdentifyQuality, VerifyQuality, SecurityLevel, DefaultTimeout,
            AutoDetect);
      end;
    end;

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(panMainMenu);
  MakeRoundedControl(panSubMenu);
  MakeRoundedControl(panNoticeList);
  FOwnerId := 0;
  FIsFirst := True;
  FNoticeIndex := 0;

  sImgName := Global.DataDir + SaleManager.StoreInfo.StoreCode + '_CI2.jpg';
  if FileExists(sImgName) then
    imgLogo.Picture.LoadFromFile(sImgName);
  lblPlatformVersion.Caption := Format('POSWARE Ver.%s', [Global.ProductVersion]);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblUpdateUrl.Caption := Global.ConfigLauncher.ReadString('Config', 'UpdateURL', '');

  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;
  panMainMenu.Left := (panRightSide.Width div 2) - (panMainMenu.Width div 2);
  panMainMenu.Visible := False;
  panSubMenu.Left := (panRightSide.Width div 2) - (panSubMenu.Width div 2);
  panSubMenu.Visible := False;
  panNoticeList.Left := (panRightSide.Width div 2) - (panNoticeList.Width div 2);
  panNoticeList.Visible := False;
  astNoticeList.Text.Lines.Clear;
  imgTeeBoxEmergency.Visible := False;

  btnMainSale.Tag := 100;
  btnMainWeb.Tag := 200;
  btnMainConfig.Tag := 300;
  btnMainClose.Tag := 400;

  for I := 0 to Pred(LCN_SUBMENU_COLS) do
  begin
    J := (I + 1);
    FSubMenuButton[I] := TAdvShapeButton
      (FindComponent('btnSubMenu' + IntToStr(J)));
    FSubMenuButton[I].Text := '';
    FSubMenuButton[I].Tag := J;
    FSubMenuButton[I].Enabled := False;
  end;

  with pgcStartUp do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;

  ckbSaveUserInfo.Checked := SaleManager.UserInfo.SaveInfo;
  if Global.AutoRunAdminCall then
    RunAdminCallApp;

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

destructor TXGDashboardForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGDashboardForm.PluginModuleDeactivate(Sender: TObject);
begin
  try
    astNoticeList.Active := False;
    WB.Navigate('about:blank');
  except
  end;
end;

procedure TXGDashboardForm.PluginModuleActivate(Sender: TObject);
begin
  try
    if UserLogged then
      DoRefreshNotice;
    if FileExists(FWebPageFile) then
      WB.Navigate('file://' + FWebPageFile);
  except
  end;
end;

procedure TXGDashboardForm.PluginModuleShow(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginId;
end;

procedure TXGDashboardForm.PluginModuleCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Global.Closing;
  if CanClose then
  begin
    if (Global.AdminCallHandle <> 0) then
      SendMessage(Global.AdminCallHandle, WM_CLOSE, 0, 0);
    if Global.ConfigLocal.Modified then
      Global.ConfigLocal.UpdateFile;
    if Global.ConfigTable.Modified then
      Global.ConfigTable.UpdateFile;
  end;
end;

procedure TXGDashboardForm.PluginModuleClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FTeeBoxStatusThread) then
    FTeeBoxStatusThread.Terminate;

  Action := caFree;
end;

procedure TXGDashboardForm.PluginModuleMessage(Sender: TObject;
  AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGDashboardForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg = nil) then
    Exit;

  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_REBOOT_SYSTEM) then
    try
      if (XGMsgBox(Self.Handle, mtConfirmation, '알림',
        '시스템 유지보수를 위해 60초 후에 강제 재시동합니다!' + _CRLF +
        '재시동을 원하지 않으시면 [취소] 버튼을 누르십시오.', ['취소'], 60) = mrOk) then
        Global.IgnoreAutoReboot := True
      else
      begin
        SystemShutdown(0, True, True);
        Global.Closing := True;
        Application.Terminate;
        Exit;
      end;
    finally
      Global.CheckAutoReboot := True;
    end;

  if (AMsg.Command = CPC_SET_FOREGROUND) and
     (GetForegroundWindow <> Self.Handle) then
    SetForegroundWindow(Self.Handle);

  if (AMsg.Command = CPC_TEEBOX_GETDATA) then
    FTeeBoxStatusThread.ForceRefresh := True;

  if (AMsg.Command = CPC_NOTICE_REFRESH) then
    DoRefreshNotice;

  if (AMsg.Command = CPC_TEEBOX_EMERGENCY) then
    imgTeeBoxEmergency.Visible := AMsg.ParamByBoolean(CPP_ACTIVE);

  if (AMsg.Command = CPC_CLOSE) then
  begin
    Global.Closing := True;
    Self.Close;
  end;
end;

procedure TXGDashboardForm.PluginModuleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: // Enter
      SelectNext(ActiveControl, True, True);

    239: // CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
  end;
end;

procedure TXGDashboardForm.OnTextEditEnter(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGDashboardForm.edtTerminalPwdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = Char(VK_RETURN)) then
  begin
    if (edtUserId.Text <> '') and (edtTerminalPwd.Text <> '') then
      DoLogin;
  end;
end;

procedure TXGDashboardForm.imgLogoClick(Sender: TObject);
begin
  raise Exception.Create('에러 테스트');
//  UpdateLog(Global.LogFile, Format('StrEncrypted(''%s'').Result = %s', ['solbipos1544', StrEncrypt('solbipos1544')]));
end;

procedure TXGDashboardForm.imgNHNKCPClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(CCC_NHNKCP_URL), nil, nil, SW_SHOW);
end;

procedure TXGDashboardForm.imgSolbiPOSClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(CCC_SOLBIPOS_URL), nil, nil, SW_SHOW);
end;

procedure TXGDashboardForm.btnCloseClick(Sender: TObject);
begin
  AskClose;
end;

procedure TXGDashboardForm.btnMainMenuClick(Sender: TObject);
begin
  with TAdvShapeButton(Sender) do
  begin
    case Tag of
      100: // 영업관리
        begin
          panSubMenu.Visible := UserLogged;
          BuildSubMenu(Tag, LCA_SUBMENU_1);
        end;
      200: // 현황조회
        begin
          panSubMenu.Visible := UserLogged;
          BuildSubMenu(Tag, LCA_SUBMENU_2);
        end;
      300: // 환경설정
        begin
          panSubMenu.Visible := True;
          BuildSubMenu(Tag, LCA_SUBMENU_3);
        end;
      400: // 종료
        begin
          panSubMenu.Visible := True;
          BuildSubMenu(Tag, LCA_SUBMENU_4);
        end;
    end;
  end;
end;

procedure TXGDashboardForm.btnSubMenuClick(Sender: TObject);
var
  nMenuId: Integer;
  sFileName, sErrMsg: string;
begin
  nMenuId := TAdvShapeButton(Sender).Tag;
  case nMenuId of
    101: // 판매관리
      ShowSalePos(Self.PluginId);
    102: // 타석관리
      if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
        btnSaleStart.Click;
    103: // 라커관리
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        ShowLockerView(Self.PluginId);
    104: // 공지사항
      ShowWebView('공지사항', FNoticeUrl);
    201: // 파트너센터-홈
      ShowPartnerCenter(Self.PluginId, 'main');
    202: // 파트너센터-회원검색
      ShowPartnerCenter(Self.PluginId, 'member/memberList');
    203: // 파트너센터-매출현황
      ShowPartnerCenter(Self.PluginId, 'sales/salesList');
    204: // 스펙트럼
      if SaleManager.StoreInfo.SpectrumYN and
         (not SaleManager.StoreInfo.SpectrumHistUrl.IsEmpty) then
        ShowWebView('스펙트럼 연동 확인', SaleManager.StoreInfo.SpectrumHistUrl);
    205: // 날씨예보
      if Global.WeatherInfo.Enabled then
        ShowWeatherInfo;
    301: // 사용자 환경 설정
      DoLocalConfig;
    302: // 시스템 환경 설정
      if DoSystemConfig then
      begin
        XGMsgBox(Self.Handle, mtConfirmation, '알림',
          '변경된 시스템 설정을 적용하려면 프로그램을 재시작하여야 합니다!' + _CRLF +
          '프로그램을 종료하겠습니다.', ['확인']);
        Global.Closing := True;
        Application.Terminate;
      end;
    303: // 마스터 수신
      DoPrepare;
    304: // 단말기 무결성 체크
      if (not ClientDM.GetICReaderVerify(sErrMsg)) then
        XGMsgBox(Self.Handle, mtError, '알림', sErrMsg, ['확인'], 5)
      else
        XGMsgBox(Self.Handle, mtInformation, '알림', '단말기 무결성 체크 성공하였습니다!', ['확인'], 5);
    305: // 긴급배정 시작
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        DoEmergencyReservationStart;
    306: // 긴급배정 종료
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        DoEmergencyReservationStop;
    307: // 긴급배정 조회
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        ShowEmergencyReservationList;
    308: // 알리미 실행
      RunAdminCallApp(True);
    309: // 알리미 동작 테스트
      if not ClientDM.DoAdminCall(9000, 'XTouch 알리미 테스트', 'POS', sErrMsg) then
        XGMsgBox(Self.Handle, mtError, '알림', sErrMsg, ['확인'], 5);
    310: // 외부장치 원격시동
      DoRemoteWakeup;
    311: // 웹브라우저 업데이트
      begin
        sFileName := Global.HomeDir + 'tools\MicrosoftEdgeWebview2Setup.exe';
        if FileExists(sFileName) and
           (XGMsgBox(Self.Handle, mtConfirmation, '웹 브라우저 업데이트',
              '현재 사용 중인 파트너센터 화면을 종료하여 주십시오.' + _CRLF + '업데이트 작업을 진행하시겠습니까?', ['예', '아니오']) = mrOk) then
          ShellExecute(Self.Handle, 'open', PChar(sFileName), nil, nil, SW_SHOW);
      end;
    312: // 웹브라우저 위치복구
      DoRestoreWebBrowserPosition;
    401: // 프로그램 종료
      AskClose;
    402: // 로그아웃
      AskLogout;
    403: // 시스템 재시작
      AskShutdown(True);
    404: // 시스템 종료
      AskShutdown;
  end;
end;

procedure TXGDashboardForm.btnSaleStartClick(Sender: TObject);
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then // 프런트POS, 레슨룸(파스텔)
  begin
    if (ClientDM.MDTeeBox.RecordCount = 0) or (Global.TeeBoxMaxCountOfFloors = 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '타석 또는 층 정보가 없습니다!' + _CRLF +
        '관리자에게 문의하여 주십시오.', ['확인'], 5);
      Exit;
    end;
    ShowTeeBoxView(Self.PluginId);
  end
  else if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) then // 후불POS(스크린, 식당 등)
  begin
    if (Global.TableInfo.Count = 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '테이블/룸 설정 정보가 없습니다!' + _CRLF +
        '관리자에게 문의하여 주십시오.', ['확인'], 5);
      Exit;
    end;
    ShowSalePosTable(Self.PluginId)
  end
  else // 선불POS(카페, 구내식당(쇼골프), 홍보관(캐슬렉스))
    ShowSalePos(Self.PluginId);
end;

procedure TXGDashboardForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
    try
      Enabled := False;
      FTimeBlink := not FTimeBlink;
      lblClockDate.Caption := Global.FormattedCurrentDate;
      lblClockWeekday.Caption := Format('(%s)', [Global.DayOfWeekKR]);
      lblClockHours.Caption := Copy(Global.CurrentTime, 1, 2);
      lblClockMins.Caption := Copy(Global.CurrentTime, 3, 2);
      lblClockSepa.Caption := IIF(FTimeBlink, '', ':');

      if FIsFirst then
      begin
        FIsFirst := False;
        Interval := 500;
        StartUp;
      end;
    finally
      Enabled := True and (not Global.Closing);
    end;
end;

procedure TXGDashboardForm.astNoticeListClick(Sender: TObject);
begin
  try
    ShowWebView('공지사항', Global.NoticeInfo[FNoticeIndex].PageUrl);
  except
  end;
end;

procedure TXGDashboardForm.astNoticeListComplete(Sender: TObject);
begin
  Inc(FNoticeIndex);
  if (FNoticeIndex >= Length(Global.NoticeInfo)) then
    FNoticeIndex := 0;
  DoRefreshNotice;
end;

procedure TXGDashboardForm.SetUserLogged(const AValue: Boolean);
begin
  FUserLogged := AValue;
  btnSaleStart.Enabled := FUserLogged;

  if FUserLogged then
  begin
    pgcStartUp.ActivePage := tabSaleStart;
    lblUserName.Caption := SaleManager.UserInfo.UserName;
    if not ckbSaveUserInfo.Checked then
      edtUserId.Text := '';
    edtTerminalPwd.Text := '';
    btnMainSale.Down := True;
    btnMainSale.Click;
  end
  else
  begin
    pgcStartUp.ActivePage := tabLogin;
    lblUserName.Caption := '';
    btnMainClose.Down := True;
    btnMainClose.Click;
  end;
end;

procedure TXGDashboardForm.StartUp;
var
  MR: TModalResult;
  aFailMenus: array of string;
  sLocalDB, sTemplateDB, sErrMsg: string;
label
  GO_CONFIG, GO_USE_EMERGENCY, GO_FORCE_CLOSE, GO_TEEBOX_AD_RETRY, GO_FINAL;
begin
  aFailMenus := ['환경설정', '시스템 종료'];
  panMainMenu.Visible := True;
  try
    Screen.Cursor := crSQLWait;
    try
      sLocalDB := Global.DataDir + 'XTouch.db';
      if not ClientDM.CheckABSDatabase(sLocalDB, sErrMsg) then
      begin
        UpdateLog(Global.LogFile, Format('로컬 데이터베이스 에러 = %s', [sErrMsg]));
        // 템플리트 파일로 DB 복구 시작
        sTemplateDB := Global.DataDir + 'XTouch_Template.db';
        if not FileExists(sTemplateDB) then
          raise Exception.Create(sTemplateDB + ' 파일을 찾을 수 없습니다.');

        // 이전 파일 백업
        CopyFile(PChar(sLocalDB), PChar(Format(Global.DataDir + 'XTouch_%s.db', [Global.CurrentDate])), False);
        // 템플리트 파일로부터 새 DB 생성
        CopyFile(PChar(sTemplateDB), PChar(sLocalDB), False);
        // 재접속 시도
        if not ClientDM.CheckABSDatabase(sLocalDB, sErrMsg) then
          raise Exception.Create(sErrMsg);

        UpdateLog(Global.LogFile, '로컬 데이터베이스 복구 완료');
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    if (not DoAuthorize(sErrMsg)) or
       Global.ClientConfig.ClientId.IsEmpty or
       Global.ClientConfig.SecretKey.IsEmpty then
    begin
      aFailMenus := ['환경설정', '시스템 종료', '긴급배정'];
      MR := XGMsgBox(Self.Handle, mtConfirmation, '확인',
              '서버로부터 클라이언트 인증을 완료할 수 없습니다!' + _CRLF + '다음 작업을 선택하십시오.', aFailMenus);
      case MR of
        mrOk:
          goto GO_CONFIG;
        mrCancel:
          goto GO_FORCE_CLOSE;
        mrYesToAll:
          begin
            if not DoEmergencyReservationStart then
              goto GO_FORCE_CLOSE;

            goto GO_USE_EMERGENCY;
          end;
      end;
    end;

    if (not Global.ClientConfig.OAuthSuccess) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '클라이언트 인증에 실패하였습니다.' + _CRLF + '프로그램을 종료하겠습니다.', ['확인']);
      goto GO_FORCE_CLOSE;
    end;

    if DoPrepare then
    begin
      lblStoreName.Caption := SaleManager.StoreInfo.StoreName;
      lblPOSName.Caption := SaleManager.StoreInfo.POSName;
      pgcStartUp.ActivePage := tabLogin;
      (*
        if (Global.ParkingServer.Enabled) and (Global.TeeBoxADInfo.Enabled) then
        ClientDM.OldDeleteParking(Global.ParkingServer.Vendor, Global.CurrentDate, sErrMsg);
      *)
    end
    else
    begin
      MR := XGMsgBox(Self.Handle, mtConfirmation, '확인',
        '서버로부터 마스터 수신 작업을 완료할 수 없습니다!' + _CRLF + '다음 작업을 선택하십시오.', aFailMenus);
      case MR of
        mrOk:
          goto GO_CONFIG;
        mrCancel:
          goto GO_FORCE_CLOSE;
        mrYesToAll:
          begin
            if not DoEmergencyReservationStart then
              goto GO_FORCE_CLOSE;

            goto GO_USE_EMERGENCY;
          end;
      end;
    end;

    if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
    begin
      aFailMenus := ['환경설정', '시스템 종료', '재시도'];
      btnSaleStart.Text := _CRLF + _CRLF + _CRLF + _CRLF + '타석배정관리';
      // ==================
      GO_TEEBOX_AD_RETRY:
      // ==================
      if Global.TeeBoxADInfo.Enabled then
      begin
        Screen.Cursor := crSQLWait;
        try
          if not ClientDM.conTeeBox.Connected then
            ClientDM.conTeeBox.Connected := True;
        except
          on E: Exception do
            sErrMsg := E.Message;
        end;

        Screen.Cursor := crDefault;
        if not sErrMsg.IsEmpty then
        begin
          MR := XGMsgBox(Self.Handle, mtConfirmation, '확인', sErrMsg, aFailMenus);
          case MR of
            mrOk:
              goto GO_CONFIG;
            mrCancel:
              goto GO_FORCE_CLOSE;
            mrYesToAll:
              goto GO_TEEBOX_AD_RETRY;
          end;
        end;

        if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and
          (not ClientDM.GetTeeBoxEmergencyMode(sErrMsg)) then
          XGMsgBox(Self.Handle, mtInformation, '알림', '타석기AD 설정에 문제가 있습니다.' + _CRLF +
            '☞ 긴급배정 상태 확인 불가' + _CRLF + sErrMsg, ['확인'], 5);
      end;

      if Global.TeeBoxEmergencyMode then
      begin
        if not ClientDM.GetTeeBoxListEmergency(sErrMsg) then
        begin
          XGMsgBox(Self.Handle, mtError, '알림', '긴급배정을 위한 타석정보를 가져올 수 없습니다!' + _CRLF +
            '시스템 환경설정 정보를 확인하여 주십시오.' + _CRLF + sErrMsg, ['확인'], 5);
          goto GO_CONFIG;
        end;

        goto GO_USE_EMERGENCY;
      end;

      aFailMenus := ['환경설정', '시스템 종료', '긴급배정'];
    end
    else if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) then
    begin
      aFailMenus := ['환경설정', '시스템 종료', '재시도'];
      btnSaleStart.Text := _CRLF + _CRLF + _CRLF + _CRLF + Global.TableInfo.UnitName + ' 주문관리';
    end;

    goto GO_FINAL;

    // ==================
    GO_CONFIG:
    // ==================
    if DoSystemConfig then
      XGMsgBox(Self.Handle, mtConfirmation, '알림',
        '시스템 설정을 적용하려면 프로그램을 재시작하여야 합니다!' + _CRLF + '프로그램을 종료하겠습니다.', ['확인']);
    goto GO_FORCE_CLOSE;

    // ==================
    GO_USE_EMERGENCY:
    // ==================
    if SaleManager.StoreInfo.StoreCode.IsEmpty then
      SaleManager.StoreInfo.StoreCode :=
        Global.ClientConfig.ClientId.Substring(0, 5);

    UserLogged := True;
    lblStoreName.Caption := Format('[긴급배정: %s]', [SaleManager.StoreInfo.StoreCode]);
    XGMsgBox(Self.Handle, mtConfirmation, '주의', '시스템이 긴급배정 상태로 작동 중입니다!' + _CRLF +
      '긴급배정 상태에서는 판매 및 회원정보 연동이 되지 않습니다.' + _CRLF +
      '환경설정 메뉴에서 긴급배정을 종료할 수도 있습니다.', ['확인']);
    UpdateLog(Global.LogFile, '긴급배정 상태로 프로그램이 시작 되었습니다.');
    goto GO_FINAL;

    // ==================
    GO_FORCE_CLOSE:
    // ==================
    Global.Closing := True;
    Application.Terminate;
    Exit;

    // ==================
    GO_FINAL:
    // ==================
    if SaleManager.UserInfo.SaveInfo then
      edtUserId.Text := SaleManager.UserInfo.UserId;

    if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) and
       (not Assigned(FTeeBoxStatusThread)) then
    begin
      FTeeBoxStatusThread := TTeeBoxStatusThread.Create;
      FTeeBoxStatusThread.FreeOnTerminate := True;
      if not FTeeBoxStatusThread.Started then
        FTeeBoxStatusThread.Start;
    end;

    // 고객측 듀얼 모니터 표시
    if Global.SubMonitor.Enabled and (Global.SubMonitorID = 0) then
    begin
      if not FileExists(Global.PluginDir + Global.PluginConfig.SubMonitorModule) then
        XGMsgBox(Self.Handle, mtError, '알림', '프로그램 실행에 필요한 파일이 존재하지 않습니다!' + _CRLF +
          '시스템 관리자에게 문의하여 주십시오.' + _CRLF + Global.PluginConfig.SubMonitorModule, ['확인'])
      else
      begin
        if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then // 프런트POS, 레슨룸(파스텔스튜디오)
        begin
          if (ClientDM.MDTeeBox.RecordCount = 0) or
             (Global.TeeBoxMaxCountOfFloors = 0) then
            XGMsgBox(Self.Handle, mtWarning, '알림', '타석 또는 층 정보가 없어 고객용 화면을 표시할 수 없습니다!' + _CRLF +
              '관리자에게 문의하여 주십시오.', ['확인'], 5)
          else
            Global.SubMonitorID := PluginManager.Open(Global.PluginConfig.SubMonitorModule).PluginId;
        end
        else
          Global.SubMonitorID := PluginManager.Open(Global.PluginConfig.SubMonitorModule).PluginId;
      end;
    end;

    Self.SetFocus;
    InitDevice;
    if not UserLogged then
    begin
      btnMainConfig.Down := True;
      btnMainConfig.Click;
    end;

    if not Global.TeeBoxEmergencyMode then
      if SaleManager.UserInfo.UserId.IsEmpty then
        edtUserId.SetFocus
      else
        edtTerminalPwd.SetFocus;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Dashboard.StartUp.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 프로그램을 시작할 수 없습니다!' + _CRLF + E.Message, ['확인']);
      Global.Closing := True;
      Self.Close;
      SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

procedure TXGDashboardForm.InitDevice;
var
  sDeviceName, sComName, sErrMsg: string;
  nRetry, nComPort, nBaudrate: Integer;
  bIsError: Boolean;
label
  GO_RETRY_1, GO_RETRY_2, GO_RETRY_3, GO_RETRY_4;
begin
  sErrMsg := '';
  nRetry := 0;
  // =========
  GO_RETRY_1:
  // =========
  bIsError := False;
  sDeviceName := 'RFID/NFC 리더';
  sComName := '';
  with Global.DeviceConfig.RFIDReader do
  try
    if not Assigned(ComDevice) then
      ComDevice := TComPort.Create(nil);

    if Enabled then
    begin
      nComPort := Port;
      nBaudrate := Baudrate;
      if not ComDevice.Active then
      begin
        sComName := 'COM' + IntToStr(nComPort);
        if (nComPort >= 10) then
          sComName := '\\.\' + sComName;
        ComDevice.DeviceName := sComName;
        ComDevice.Baudrate := GetBaudRate(nBaudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        if not CheckEnumComPorts(nComPort, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ComDevice.Open;
      end;
      ComDevice.OnRxChar := Global.ComPortRxCharRFIDReader;
    end;
  except
    on E: Exception do
    begin
      Inc(nRetry);
      bIsError := True;
      sErrMsg := E.Message;
    end;
  end;

  if bIsError then
  begin
    if (nRetry < 5) then
    begin
      Sleep(100);
      goto GO_RETRY_1;
    end;

    XGMsgBox(Self.Handle, mtError, '알림', Format('%s 장치[포트: %s]를 사용할 수 없습니다!', [sDeviceName, sComName]), ['확인'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_2:
  // =========
  bIsError := False;
  sDeviceName := '복지카드 RFID 리더';
  sComName := '';
  with Global.DeviceConfig.WelfareCardReader do
  try
    if not Assigned(ComDevice) then
      ComDevice := TComPort.Create(nil);

    if Enabled then
    begin
      nComPort := Port;
      nBaudrate := Baudrate;
      if not ComDevice.Active then
      begin
        sComName := 'COM' + IntToStr(nComPort);
        if (nComPort >= 10) then
          sComName := '\\.\' + sComName;
        ComDevice.DeviceName := sComName;
        ComDevice.Baudrate := GetBaudRate(nBaudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        if not CheckEnumComPorts(nComPort, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ComDevice.Open;
      end;
      ComDevice.OnRxChar := Global.ComPortRxCharWelfareCardReader;
    end;
  except
    on E: Exception do
    begin
      Inc(nRetry);
      bIsError := True;
      sErrMsg := E.Message;
    end;
  end;

  if bIsError then
  begin
    if (nRetry < 5) then
    begin
      Sleep(100);
      goto GO_RETRY_2;
    end;

    XGMsgBox(Self.Handle, mtError, '알림', Format('%s 장치[포트: %s]를 사용할 수 없습니다!', [sDeviceName, sComName]), ['확인'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_3:
  // =========
  bIsError := False;
  sDeviceName := '영수증 프린터';
  sComName := '';
  with Global.DeviceConfig.ReceiptPrinter do
  try
    if not Assigned(ComDevice) then
      ComDevice := TComPort.Create(nil);

    if Enabled then
    begin
      nComPort := Port;
      nBaudrate := Baudrate;
      if not ComDevice.Active then
      begin
        sComName := 'COM' + IntToStr(nComPort);
        if (nComPort >= 10) then
          sComName := '\\.\' + sComName;
        ComDevice.DeviceName := sComName;
        ComDevice.Baudrate := GetBaudRate(nBaudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        if not CheckEnumComPorts(nComPort, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ComDevice.Open;
      end;
    end;

    if not Assigned(Global.ReceiptPrint) then
      Global.ReceiptPrint := TReceiptPrint.Create(dtPos);
  except
    on E: Exception do
    begin
      Inc(nRetry);
      bIsError := True;
      sErrMsg := E.Message;
    end;
  end;

  if bIsError then
  begin
    if (nRetry < 3) then
    begin
      Sleep(100);
      goto GO_RETRY_3;
    end;

    XGMsgBox(Self.Handle, mtError, '알림', Format('%s 장치[포트: %s]를 사용할 수 없습니다!', [sDeviceName, sComName]), ['확인'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_4:
  // =========
  bIsError := False;
  sDeviceName := '바코드 스캐너';
  sComName := '';
  with Global.DeviceConfig.BarcodeScanner do
  try
    if not Assigned(ComDevice) then
      ComDevice := TComPort.Create(nil);

    if Enabled then
    begin
      nComPort := Port;
      nBaudrate := Baudrate;
      if not ComDevice.Active then
      begin
        sComName := 'COM' + IntToStr(nComPort);
        if (nComPort >= 10) then
          sComName := '\\.\' + sComName;
        ComDevice.DeviceName := sComName;
        ComDevice.Baudrate := GetBaudRate(nBaudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        if not CheckEnumComPorts(nComPort, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ComDevice.Open;
      end;
      ComDevice.OnRxChar := Global.ComPortRxCharBarcodeScanner;
    end;
  except
    on E: Exception do
    begin
      Inc(nRetry);
      bIsError := True;
      sErrMsg := E.Message;
    end;
  end;

  if bIsError then
  begin
    if (nRetry < 5) then
    begin
      Sleep(100);
      goto GO_RETRY_4;
    end;

    XGMsgBox(Self.Handle, mtError, '알림', Format('%s 장치[포트: %s]를 사용할 수 없습니다!', [sDeviceName, sComName]), ['확인'], 5);
  end;
end;

procedure TXGDashboardForm.BuildSubMenu(const ACategory: Integer; ASubMenu: array of TSubMenu);
var
  I: Integer;
begin
  for I := 0 to Pred(LCN_SUBMENU_COLS) do
    if (I < Length(ASubMenu)) then
    begin
      FSubMenuButton[I].Enabled := True;
      FSubMenuButton[I].Tag := ACategory + (I + 1);
      FSubMenuButton[I].Text := ASubMenu[I].Caption;
    end
    else
    begin
      FSubMenuButton[I].Tag := 0;
      FSubMenuButton[I].Enabled := False;
      FSubMenuButton[I].Text := '';
    end;
end;

function TXGDashboardForm.DoSystemConfig: Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  with TXGInputBoxForm.Create(nil) do
  try
    Title := '관리자 확인';
    MessageText := '시스템 설정 변경은 관리자 권한입니다!' + _CRLF + '인가된 비밀번호를 입력하여 주십시오.';
    PasswordMode := True;
    if (ShowModal <> mrOk) then
      Exit;
    if (InputText <> Copy(Global.CurrentDate, 5, 4)) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '비밀번호가 일치하지 않습니다!', ['확인'], 5);
      Exit;
    end;
  finally
    Free;
  end;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    Result := (PluginManager.OpenModal('XGConfig' + CPL_EXTENSION, PM) = mrOk);
  finally
    FreeAndNil(PM);
  end;
end;

function TXGDashboardForm.DoLocalConfig: Boolean;
var
  PM: TPluginMessage;
  sErrMsg: string;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    Result := (PluginManager.OpenModal('XGConfigLocal' + CPL_EXTENSION, PM) = mrOk);
    if Result then
    begin
      if Global.AirConditioner.Enabled and
         (not ClientDM.SetAirConOnOff(0, Global.AirConditioner.OnOffMode, sErrMsg)) then
        XGMsgBox(Self.Handle, mtError, '알림', '냉/온풍기 제어 요청을 처리할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);

      XGMsgBox(Self.Handle, mtConfirmation, '알림',
        '변경된 일부 설정값은 프로그램을 재시작 하여야 적용될 수 있습니다!', ['확인'], 5);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

function TXGDashboardForm.DoAuthorize(var AErrMsg: string): Boolean;
var
  sToken: string;
begin
  Result := False;
  sToken := '';
  if ClientDM.GetToken(Global.ClientConfig.ClientId, Global.ClientConfig.SecretKey, sToken, AErrMsg) then
  begin
    Result := ClientDM.CheckToken(sToken, Global.ClientConfig.ClientId, Global.ClientConfig.SecretKey, AErrMsg);
    if Result then
    begin
      Global.ClientConfig.OAuthToken := sToken;
      Global.ClientConfig.OAuthSuccess := True;
    end;
  end
  else
    XGMsgBox(Self.Handle, mtWarning, '인증 실패', '클라이언트 인증에 실패하였습니다!' + _CRLF +
      '터미날ID와 인증키를 확인하여 주십시오.' + _CRLF + '(' + AErrMsg + ')', ['확인']);
end;

function TXGDashboardForm.DoPrepare: Boolean;
begin
  Result := (PluginManager.OpenModal('XGPrepare' + CPL_EXTENSION) = mrOk);
  if Result then
  begin
    Self.Width := Global.ScreenInfo.BaseWidth;
    Self.Height := Global.ScreenInfo.BaseHeight;
    // sSaleTime := Format('영업시간: %s ~ %s',
    // [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime),
    // FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]);
    // ClientDM.DoAdminCall(0, sSaleTime, 'POS', sErrMsg);
  end;
end;

// 긴급배정 시작
function TXGDashboardForm.DoEmergencyReservationStart: Boolean;
var
  sErrMsg: string;
begin
  Result := False;
  if Global.TeeBoxEmergencyMode then
  begin
    XGMsgBox(Self.Handle, mtInformation, '알림', '시스템이 이미 긴급배정 상태로 설정되어 있습니다!',
      ['확인'], 5);
    Exit(True);
  end;

  try
    if (XGMsgBox(Self.Handle, mtConfirmation, '주의', '긴급배정 상태에서는 판매 및 회원정보 연동이 되지 않습니다!' + _CRLF +
          '파트너센터와 접속이 불가한 경우에만 사용하십시오.' + _CRLF + '긴급배정 상태로 시스템을 전환하시겠습니까?',
          ['예', '아니오']) <> mrOk) then
      Exit;

    if not ClientDM.conTeeBox.Connected then
      ClientDM.conTeeBox.Connected := True;

    if (not ClientDM.GetTeeBoxListEmergency(sErrMsg)) or
       (not ClientDM.SetTeeBoxEmergencyMode(True, sErrMsg)) then
      raise Exception.Create(sErrMsg);

    pgcStartUp.ActivePage := tabSaleStart;
    Result := True;
    XGMsgBox(Self.Handle, mtConfirmation, '긴급배정', '시스템이 긴급배정 사용 상태로 전환 되었습니다!' + _CRLF +
      '다른 위치에서 사용 중인 POS 프로그램이 있다면' + _CRLF + '반드시 재실행 하여 주시기 바랍니다.', ['확인']);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Dashboard.DoEmergencyReservationStart.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '알림', '긴급배정 상태로 전환할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  end;
end;

// 긴급배정 종료
procedure TXGDashboardForm.DoEmergencyReservationStop;
var
  sErrMsg: string;
begin
  if not Global.TeeBoxEmergencyMode then
  begin
    XGMsgBox(Self.Handle, mtInformation, '알림', '시스템이 긴급배정 상태가 아닙니다!', ['확인'], 5);
    Exit;
  end;

  try
    (* KCP 요청에 의해 비밀번호 확인 절차 제거(20211213)
      with TXGInputBoxForm.Create(nil) do
      try
      Title := '사용자 확인';
      MessageText := '최근에 접속한 사용자 ID를 입력하여 주십시오.';
      PasswordMode := False;
      if (ShowModal <> mrOK) then
      Exit;

      if (InputText <> SaleManager.UserInfo.UserId) then
      begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '알 수 없는 사용자 ID 입니다!', ['확인'], 5);
      Exit;
      end;
      finally
      Free;
      end;
    *)

    if (XGMsgBox(Self.Handle, mtConfirmation, '주의', '긴급배정 상태를 종료하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;

    if not ClientDM.conTeeBox.Connected then
      ClientDM.conTeeBox.Connected := True;

    if (not ClientDM.SetTeeBoxEmergencyMode(False, sErrMsg)) then
      raise Exception.Create(sErrMsg);

    XGMsgBox(Self.Handle, mtConfirmation, '알림',
      '긴급배정 상태가 종료되어 프로그램을 재시작하여야 합니다!' + _CRLF +
      '다른 위치에서 사용 중인 POS 프로그램이 있다면' + _CRLF +
      '반드시 재실행 하여 주시기 바랍니다.' + _CRLF +
      '프로그램을 종료하겠습니다.', ['확인']);
    Global.Closing := True;
    Application.Terminate;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Dashboard.DoEmergencyReservationStop.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '알림', '긴급배정 상태를 종료할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  end;
end;

// 긴급배정 조회
procedure TXGDashboardForm.ShowEmergencyReservationList;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PM.AddParams(CPP_EMERGENCY_MODE, True);
    PM.AddParams(CPP_TEEBOX_NO, 0);
    PM.AddParams(CPP_TEEBOX_NAME, '');
    PluginManager.OpenModal('XGTeeBoxReserveList' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGDashboardForm.ShowWebView(const ATitle, AUrl: string; const AShowNoMoreToday: Boolean);
begin
  if Global.TeeBoxEmergencyMode then
    Exit;

  if not UserLogged then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '로그인 후에 사용 가능합니다!', ['확인'], 5);
    Exit;
  end;

  ShowWebViewModal(Self.PluginId, ATitle, AUrl, AShowNoMoreToday);
end;

procedure TXGDashboardForm.DoRefreshNotice;
begin
  with astNoticeList do
  begin
    // Active := False;
    Text.Lines.Clear;
    if (Length(Global.NoticeInfo) > 0) then
    begin
      (*
        <Title>공지사항 알림 기능이 추가될 예정입니다.
        <Date>(2021-04-13 12:00:00 시스템운영자)
      *)
      Text.Lines.Add(Format('<Title>%s', [Global.NoticeInfo[FNoticeIndex].Title]));
      Text.Lines.Add(Format('<Date>(%s %s)', [Global.NoticeInfo[FNoticeIndex].RegDateTime, Global.NoticeInfo[FNoticeIndex].RegUserName]));
      Active := True;
    end;
  end;
end;

procedure TXGDashboardForm.DoRemoteWakeup;
var
  SL: TStrings;
  I: Integer;
begin
  try
    if not FileExists(Global.WakeupListFileName) then
      raise Exception.Create('원격시동 대상장치 설정 파일이 존재하지 않습니다!');

    SL := TStringList.Create;
    try
      SL.LoadFromFile(Global.WakeupListFileName);
      if (SL.Count = 0) then
        raise Exception.Create('원격시동 대상장치가 등록되어 있지 않습니다!');

      if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '원격시동 대상장치에 Wake-On-LAN 명령을 전송하시겠습니까?', ['예', '아니오']) = mrOk) then
      begin
        for I := 0 to Pred(SL.Count) do
        begin
          WakeOnLAN(UpperCase(SL.Strings[I]));
          Application.ProcessMessages;
        end;

        XGMsgBox(Self.Handle, mtInformation, '알림', '원격시동 명령 전송을 완료하였습니다!',
          ['확인'], 5);
      end;
    finally
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile,
        Format('Dashboard.DoRemoteWakeup.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '원격시동', E.Message, ['확인'], 5);
    end;
  end;
end;

function TXGDashboardForm.DoLogin: Boolean;
var
  sUserId, sTerminalPwd, sErrMsg: string;
begin
  Result := False;
  Screen.Cursor := crHourGlass;
  sUserId := edtUserId.Text;
  sTerminalPwd := edtTerminalPwd.Text;
  with SaleManager.UserInfo do
  try
    if not Global.ClientConfig.OAuthSuccess then
    begin
      XGMsgBox(Self.Handle, mtWarning, '로그인 실패',
        '클라이언트 인증이 되지 않아 로그인이 불가합니다!', ['확인'], 3);
      Exit;
    end;

    UserLogged := ClientDM.CheckLogin(sUserId, sTerminalPwd, sErrMsg);
    if UserLogged then
    begin
      UserId := sUserId;
      TerminalPwd := sTerminalPwd;
      FNoticeUrl := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&redirectUrl=/%s',
        [ExcludeTrailingBackslash(Global.BackOfficeUrl), SaleManager.StoreInfo.StoreCode, UserId, TerminalPwd, 'system/noticeList']);

      with Global.ConfigLocal do
      begin
        WriteBool('UserInfo', 'SaveInfo', ckbSaveUserInfo.Checked);
        WriteString('UserInfo', 'UserId', IIF(ckbSaveUserInfo.Checked, UserId, ''));
        UpdateFile;
        Result := True;
      end;
      panNoticeList.Visible := True;
      astNoticeList.Active := True;
      if (not Global.NoticePopupUrl.IsEmpty) and
         (Global.LastNoticeDate <> Global.CurrentDate) then
        ShowWebView('공지사항', Global.NoticePopupUrl, True);
    end
    else
    begin
      UserId := '';
      TerminalPwd := '';
      panNoticeList.Visible := False;
      astNoticeList.Active := False;
      XGMsgBox(Self.Handle, mtWarning, '로그인 실패', '사용자 ID 또는 비밀번호가 일치하지 않습니다!', ['확인'], 3);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TXGDashboardForm.AskLogout;
begin
  if UserLogged and (XGMsgBox(Self.Handle, mtConfirmation, '확인', '로그아웃 하시겠습니까?', ['로그아웃', '취소']) = mrOk) then
  begin
    UserLogged := False;
    lblUserName.Caption := '[로그아웃됨]';

    with TPluginMessage.Create(nil) do
    try
      Command := CPC_CLOSE;
      if (Global.WebViewId > 0) then
        PluginMessageToId(Global.WebViewId);
      if (Global.TeeBoxViewId > 0) then
        PluginMessageToId(Global.TeeBoxViewId);
      if (Global.SubMonitorID > 0) then
        PluginMessageToId(Global.SubMonitorID);
      if (Global.SaleFormId > 0) then
        PluginMessageToId(Global.SaleFormId);
      if (Global.SaleTableFormId > 0) then
        PluginMessageToId(Global.SaleTableFormId);
    finally
      Free;
    end;
  end;
end;

procedure TXGDashboardForm.AskClose;
begin
  if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '프로그램을 종료하시겠습니까?', ['종료', '취소']) = mrOk) then
  begin
    Global.Closing := True;
    Self.Close;
    SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TXGDashboardForm.AskShutdown(const AReboot: Boolean);
var
  sMsg: string;
begin
  sMsg := IIF(AReboot, '리부팅', '셧다운');
  if UserLogged and
     (XGMsgBox(Self.Handle, mtConfirmation, '확인',
        '프로그램을 닫고 POS 시스템을 ' + sMsg + ' 하시겠습니까?' + _CRLF +
        '저장하지 않은 데이터가 있으면 처리한 후에 진행하십시오.', [sMsg, '취소']) = mrOk) then
    SystemShutdown(0, True, AReboot);
end;

procedure TXGDashboardForm.RunAdminCallApp(const AShowErrorMsg: Boolean);
var
  sFileName: string;
begin
  Global.AdminCallHandle := FindWindow(PChar('TXGAdminCallForm'), nil);
  if (Global.AdminCallHandle = 0) then
  begin
    sFileName := Global.HomeDir + 'XGAdminCall.exe';
    if not FileExists(sFileName) then
    begin
      if AShowErrorMsg then
        XGMsgBox(Self.Handle, mtError, '알림', '알리미 프로그램이 설치되어 있지 않습니다!' + _CRLF + sFileName, ['확인'], 5);

      Exit;
    end
    else
    begin
      ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
      Application.ProcessMessages;
      Global.AdminCallHandle := FindWindow(PChar('TXGAdminCallForm'), nil);
    end;
  end
  else
  begin
    if AShowErrorMsg then
      XGMsgBox(Self.Handle, mtError, '알림', '알리미 프로그램이 이미 실행 중입니다!' + _CRLF + sFileName, ['확인'], 5);
  end;
end;

procedure TXGDashboardForm.DoRestoreWebBrowserPosition;
begin
  if (not Global.SubMonitor.Enabled) or
     (XGMsgBox(Self.Handle, mtConfirmation, '확인', '웹브라우저를 기본 설정으로 복구하시겠습니까?', ['예', '아니오']) <> mrOk) then
    Exit;

  ShowPartnerCenter(Self.PluginId, 'main');
  with TPluginMessage.Create(nil) do
    try
      Command := CPC_RESTORE_WEB_POS;
      PluginMessageToId(Global.WebViewId);
    finally
      Free;
    end;
end;

procedure TXGDashboardForm.SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation = 'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;
var
  Reg: TRegIniFile;
  sKey: string;
begin
  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
       (not (TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey) = cIE11))) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;
end;

{ TTeeBoxStatusThread }

constructor TTeeBoxStatusThread.Create;
begin
  inherited Create(True);

  FLastWorked := (Now - 1);
  FInterval := 1000 * 10;
  FForceRefresh := False;
end;

destructor TTeeBoxStatusThread.Destroy;
begin

  inherited;
end;

procedure TTeeBoxStatusThread.Execute;
begin
  repeat
    if (not Global.TeeBoxStatusWorking) and
       (ForceRefresh or (MilliSecondsBetween(LastWorked, Now) > FInterval)) then
    begin
      Synchronize(
        procedure
        var
          bSuccess: Boolean;
          sErrMsg: string;
        begin
          Global.TeeBoxStatusWorking := True;
          try
            LastWorked := Now;
            if ForceRefresh then
              ForceRefresh := False;

            bSuccess := ClientDM.GetTeeBoxStatus(ClientDM.MDTeeboxStatus, sErrMsg);
            if not bSuccess then
              UpdateLog(Global.LogFile, 'TeeBoxStatusThread.Exception : ' + sErrMsg);
          finally
            Global.TeeBoxStatusWorking := False;
          end;
        end);
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

/// /////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage = nil): TPluginModule;
begin
  Result := TXGDashboardForm.Create(Application, AMsg);
end;

exports OpenPlugin;

end.
