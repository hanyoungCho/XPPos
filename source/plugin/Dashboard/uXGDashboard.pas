(* ******************************************************************************

  Project     : XGOLF ���������� POS �ý���
  Title       : ��ú���
  Author      : �̼���
  Description :
  History     :
  Version   Date         Remark
  --------  ----------   -----------------------------------------------------
  1.0.0.0   2019-05-10   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2019 All rights reserved.

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
    (MenuId: 101; Caption: '�ǸŰ���'),
    (MenuId: 102; Caption: 'Ÿ��' + _CRLF + '��������'),
    (MenuId: 103; Caption: '��Ŀ����'),
    (MenuId: 104; Caption: '��������'));
  LCA_SUBMENU_2: array [0 .. 4] of TSubMenu = (
    (MenuId: 201; Caption: '��Ʈ�ʼ���' + _CRLF + 'Ȩ'),
    (MenuId: 202; Caption: 'ȸ���˻�'),
    (MenuId: 203; Caption: '������Ȳ'),
    (MenuId: 204; Caption: '����Ʈ��' + _CRLF + '���� Ȯ��'),
    (MenuId: 205; Caption: '��������'));
  LCA_SUBMENU_3: array [0 .. 11] of TSubMenu = (
    (MenuId: 301; Caption: '�����' + _CRLF + 'ȯ�� ����'),
    (MenuId: 302; Caption: '�ý���' + _CRLF + 'ȯ�� ����'),
    (MenuId: 303; Caption: '������' + _CRLF + '����'),
    (MenuId: 304; Caption: '�ܸ���' + _CRLF + '���Ἲ üũ'),
    (MenuId: 305; Caption: '��޹���' + _CRLF + '����'),
    (MenuId: 306; Caption: '��޹���' + _CRLF + '����'),
    (MenuId: 307; Caption: '��޹���' + _CRLF + '���� ��ȸ'),
    (MenuId: 308; Caption: '�˸��� ����'),
    (MenuId: 309; Caption: '�˸���' + _CRLF + '���� �׽�Ʈ'),
    (MenuId: 310; Caption: '�ܺα��' + _CRLF + '���ݽõ�'),
    (MenuId: 311; Caption: '��������' + _CRLF + '������Ʈ'),
    (MenuId: 312; Caption: '��������' + _CRLF + '����'));
  LCA_SUBMENU_4: array [0 .. 3] of TSubMenu = (
    (MenuId: 401; Caption: '���α׷�' + _CRLF + '����'),
    (MenuId: 402; Caption: '�α׾ƿ�'),
    (MenuId: 403; Caption: '�ý���' + _CRLF + '������'),
    (MenuId: 404; Caption: '�ý���' + _CRLF + '�˴ٿ�'));

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

  // �����νı� ����
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
      if (XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
        '�ý��� ���������� ���� 60�� �Ŀ� ���� ��õ��մϴ�!' + _CRLF +
        '��õ��� ������ �����ø� [���] ��ư�� �����ʽÿ�.', ['���'], 60) = mrOk) then
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
  raise Exception.Create('���� �׽�Ʈ');
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
      100: // ��������
        begin
          panSubMenu.Visible := UserLogged;
          BuildSubMenu(Tag, LCA_SUBMENU_1);
        end;
      200: // ��Ȳ��ȸ
        begin
          panSubMenu.Visible := UserLogged;
          BuildSubMenu(Tag, LCA_SUBMENU_2);
        end;
      300: // ȯ�漳��
        begin
          panSubMenu.Visible := True;
          BuildSubMenu(Tag, LCA_SUBMENU_3);
        end;
      400: // ����
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
    101: // �ǸŰ���
      ShowSalePos(Self.PluginId);
    102: // Ÿ������
      if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
        btnSaleStart.Click;
    103: // ��Ŀ����
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        ShowLockerView(Self.PluginId);
    104: // ��������
      ShowWebView('��������', FNoticeUrl);
    201: // ��Ʈ�ʼ���-Ȩ
      ShowPartnerCenter(Self.PluginId, 'main');
    202: // ��Ʈ�ʼ���-ȸ���˻�
      ShowPartnerCenter(Self.PluginId, 'member/memberList');
    203: // ��Ʈ�ʼ���-������Ȳ
      ShowPartnerCenter(Self.PluginId, 'sales/salesList');
    204: // ����Ʈ��
      if SaleManager.StoreInfo.SpectrumYN and
         (not SaleManager.StoreInfo.SpectrumHistUrl.IsEmpty) then
        ShowWebView('����Ʈ�� ���� Ȯ��', SaleManager.StoreInfo.SpectrumHistUrl);
    205: // ��������
      if Global.WeatherInfo.Enabled then
        ShowWeatherInfo;
    301: // ����� ȯ�� ����
      DoLocalConfig;
    302: // �ý��� ȯ�� ����
      if DoSystemConfig then
      begin
        XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
          '����� �ý��� ������ �����Ϸ��� ���α׷��� ������Ͽ��� �մϴ�!' + _CRLF +
          '���α׷��� �����ϰڽ��ϴ�.', ['Ȯ��']);
        Global.Closing := True;
        Application.Terminate;
      end;
    303: // ������ ����
      DoPrepare;
    304: // �ܸ��� ���Ἲ üũ
      if (not ClientDM.GetICReaderVerify(sErrMsg)) then
        XGMsgBox(Self.Handle, mtError, '�˸�', sErrMsg, ['Ȯ��'], 5)
      else
        XGMsgBox(Self.Handle, mtInformation, '�˸�', '�ܸ��� ���Ἲ üũ �����Ͽ����ϴ�!', ['Ȯ��'], 5);
    305: // ��޹��� ����
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        DoEmergencyReservationStart;
    306: // ��޹��� ����
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        DoEmergencyReservationStop;
    307: // ��޹��� ��ȸ
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        ShowEmergencyReservationList;
    308: // �˸��� ����
      RunAdminCallApp(True);
    309: // �˸��� ���� �׽�Ʈ
      if not ClientDM.DoAdminCall(9000, 'XTouch �˸��� �׽�Ʈ', 'POS', sErrMsg) then
        XGMsgBox(Self.Handle, mtError, '�˸�', sErrMsg, ['Ȯ��'], 5);
    310: // �ܺ���ġ ���ݽõ�
      DoRemoteWakeup;
    311: // �������� ������Ʈ
      begin
        sFileName := Global.HomeDir + 'tools\MicrosoftEdgeWebview2Setup.exe';
        if FileExists(sFileName) and
           (XGMsgBox(Self.Handle, mtConfirmation, '�� ������ ������Ʈ',
              '���� ��� ���� ��Ʈ�ʼ��� ȭ���� �����Ͽ� �ֽʽÿ�.' + _CRLF + '������Ʈ �۾��� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOk) then
          ShellExecute(Self.Handle, 'open', PChar(sFileName), nil, nil, SW_SHOW);
      end;
    312: // �������� ��ġ����
      DoRestoreWebBrowserPosition;
    401: // ���α׷� ����
      AskClose;
    402: // �α׾ƿ�
      AskLogout;
    403: // �ý��� �����
      AskShutdown(True);
    404: // �ý��� ����
      AskShutdown;
  end;
end;

procedure TXGDashboardForm.btnSaleStartClick(Sender: TObject);
begin
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then // ����ƮPOS, ������(�Ľ���)
  begin
    if (ClientDM.MDTeeBox.RecordCount = 0) or (Global.TeeBoxMaxCountOfFloors = 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', 'Ÿ�� �Ǵ� �� ������ �����ϴ�!' + _CRLF +
        '�����ڿ��� �����Ͽ� �ֽʽÿ�.', ['Ȯ��'], 5);
      Exit;
    end;
    ShowTeeBoxView(Self.PluginId);
  end
  else if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) then // �ĺ�POS(��ũ��, �Ĵ� ��)
  begin
    if (Global.TableInfo.Count = 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', '���̺�/�� ���� ������ �����ϴ�!' + _CRLF +
        '�����ڿ��� �����Ͽ� �ֽʽÿ�.', ['Ȯ��'], 5);
      Exit;
    end;
    ShowSalePosTable(Self.PluginId)
  end
  else // ����POS(ī��, �����Ĵ�(�����), ȫ����(ĳ������))
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
    ShowWebView('��������', Global.NoticeInfo[FNoticeIndex].PageUrl);
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
  aFailMenus := ['ȯ�漳��', '�ý��� ����'];
  panMainMenu.Visible := True;
  try
    Screen.Cursor := crSQLWait;
    try
      sLocalDB := Global.DataDir + 'XTouch.db';
      if not ClientDM.CheckABSDatabase(sLocalDB, sErrMsg) then
      begin
        UpdateLog(Global.LogFile, Format('���� �����ͺ��̽� ���� = %s', [sErrMsg]));
        // ���ø�Ʈ ���Ϸ� DB ���� ����
        sTemplateDB := Global.DataDir + 'XTouch_Template.db';
        if not FileExists(sTemplateDB) then
          raise Exception.Create(sTemplateDB + ' ������ ã�� �� �����ϴ�.');

        // ���� ���� ���
        CopyFile(PChar(sLocalDB), PChar(Format(Global.DataDir + 'XTouch_%s.db', [Global.CurrentDate])), False);
        // ���ø�Ʈ ���Ϸκ��� �� DB ����
        CopyFile(PChar(sTemplateDB), PChar(sLocalDB), False);
        // ������ �õ�
        if not ClientDM.CheckABSDatabase(sLocalDB, sErrMsg) then
          raise Exception.Create(sErrMsg);

        UpdateLog(Global.LogFile, '���� �����ͺ��̽� ���� �Ϸ�');
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    if (not DoAuthorize(sErrMsg)) or
       Global.ClientConfig.ClientId.IsEmpty or
       Global.ClientConfig.SecretKey.IsEmpty then
    begin
      aFailMenus := ['ȯ�漳��', '�ý��� ����', '��޹���'];
      MR := XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
              '�����κ��� Ŭ���̾�Ʈ ������ �Ϸ��� �� �����ϴ�!' + _CRLF + '���� �۾��� �����Ͻʽÿ�.', aFailMenus);
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
      XGMsgBox(Self.Handle, mtWarning, '�˸�', 'Ŭ���̾�Ʈ ������ �����Ͽ����ϴ�.' + _CRLF + '���α׷��� �����ϰڽ��ϴ�.', ['Ȯ��']);
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
      MR := XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '�����κ��� ������ ���� �۾��� �Ϸ��� �� �����ϴ�!' + _CRLF + '���� �۾��� �����Ͻʽÿ�.', aFailMenus);
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
      aFailMenus := ['ȯ�漳��', '�ý��� ����', '��õ�'];
      btnSaleStart.Text := _CRLF + _CRLF + _CRLF + _CRLF + 'Ÿ����������';
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
          MR := XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', sErrMsg, aFailMenus);
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
          XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ����AD ������ ������ �ֽ��ϴ�.' + _CRLF +
            '�� ��޹��� ���� Ȯ�� �Ұ�' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      end;

      if Global.TeeBoxEmergencyMode then
      begin
        if not ClientDM.GetTeeBoxListEmergency(sErrMsg) then
        begin
          XGMsgBox(Self.Handle, mtError, '�˸�', '��޹����� ���� Ÿ�������� ������ �� �����ϴ�!' + _CRLF +
            '�ý��� ȯ�漳�� ������ Ȯ���Ͽ� �ֽʽÿ�.' + _CRLF + sErrMsg, ['Ȯ��'], 5);
          goto GO_CONFIG;
        end;

        goto GO_USE_EMERGENCY;
      end;

      aFailMenus := ['ȯ�漳��', '�ý��� ����', '��޹���'];
    end
    else if (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]) then
    begin
      aFailMenus := ['ȯ�漳��', '�ý��� ����', '��õ�'];
      btnSaleStart.Text := _CRLF + _CRLF + _CRLF + _CRLF + Global.TableInfo.UnitName + ' �ֹ�����';
    end;

    goto GO_FINAL;

    // ==================
    GO_CONFIG:
    // ==================
    if DoSystemConfig then
      XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
        '�ý��� ������ �����Ϸ��� ���α׷��� ������Ͽ��� �մϴ�!' + _CRLF + '���α׷��� �����ϰڽ��ϴ�.', ['Ȯ��']);
    goto GO_FORCE_CLOSE;

    // ==================
    GO_USE_EMERGENCY:
    // ==================
    if SaleManager.StoreInfo.StoreCode.IsEmpty then
      SaleManager.StoreInfo.StoreCode :=
        Global.ClientConfig.ClientId.Substring(0, 5);

    UserLogged := True;
    lblStoreName.Caption := Format('[��޹���: %s]', [SaleManager.StoreInfo.StoreCode]);
    XGMsgBox(Self.Handle, mtConfirmation, '����', '�ý����� ��޹��� ���·� �۵� ���Դϴ�!' + _CRLF +
      '��޹��� ���¿����� �Ǹ� �� ȸ������ ������ ���� �ʽ��ϴ�.' + _CRLF +
      'ȯ�漳�� �޴����� ��޹����� ������ ���� �ֽ��ϴ�.', ['Ȯ��']);
    UpdateLog(Global.LogFile, '��޹��� ���·� ���α׷��� ���� �Ǿ����ϴ�.');
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

    // ���� ��� ����� ǥ��
    if Global.SubMonitor.Enabled and (Global.SubMonitorID = 0) then
    begin
      if not FileExists(Global.PluginDir + Global.PluginConfig.SubMonitorModule) then
        XGMsgBox(Self.Handle, mtError, '�˸�', '���α׷� ���࿡ �ʿ��� ������ �������� �ʽ��ϴ�!' + _CRLF +
          '�ý��� �����ڿ��� �����Ͽ� �ֽʽÿ�.' + _CRLF + Global.PluginConfig.SubMonitorModule, ['Ȯ��'])
      else
      begin
        if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then // ����ƮPOS, ������(�Ľ��ڽ�Ʃ���)
        begin
          if (ClientDM.MDTeeBox.RecordCount = 0) or
             (Global.TeeBoxMaxCountOfFloors = 0) then
            XGMsgBox(Self.Handle, mtWarning, '�˸�', 'Ÿ�� �Ǵ� �� ������ ���� ���� ȭ���� ǥ���� �� �����ϴ�!' + _CRLF +
              '�����ڿ��� �����Ͽ� �ֽʽÿ�.', ['Ȯ��'], 5)
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
      XGMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� ���α׷��� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��']);
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
  sDeviceName := 'RFID/NFC ����';
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

    XGMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��ġ[��Ʈ: %s]�� ����� �� �����ϴ�!', [sDeviceName, sComName]), ['Ȯ��'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_2:
  // =========
  bIsError := False;
  sDeviceName := '����ī�� RFID ����';
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

    XGMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��ġ[��Ʈ: %s]�� ����� �� �����ϴ�!', [sDeviceName, sComName]), ['Ȯ��'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_3:
  // =========
  bIsError := False;
  sDeviceName := '������ ������';
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

    XGMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��ġ[��Ʈ: %s]�� ����� �� �����ϴ�!', [sDeviceName, sComName]), ['Ȯ��'], 5);
  end;

  nRetry := 0;
  // =========
  GO_RETRY_4:
  // =========
  bIsError := False;
  sDeviceName := '���ڵ� ��ĳ��';
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

    XGMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��ġ[��Ʈ: %s]�� ����� �� �����ϴ�!', [sDeviceName, sComName]), ['Ȯ��'], 5);
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
    Title := '������ Ȯ��';
    MessageText := '�ý��� ���� ������ ������ �����Դϴ�!' + _CRLF + '�ΰ��� ��й�ȣ�� �Է��Ͽ� �ֽʽÿ�.';
    PasswordMode := True;
    if (ShowModal <> mrOk) then
      Exit;
    if (InputText <> Copy(Global.CurrentDate, 5, 4)) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', '��й�ȣ�� ��ġ���� �ʽ��ϴ�!', ['Ȯ��'], 5);
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
        XGMsgBox(Self.Handle, mtError, '�˸�', '��/��ǳ�� ���� ��û�� ó���� �� �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);

      XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
        '����� �Ϻ� �������� ���α׷��� ����� �Ͽ��� ����� �� �ֽ��ϴ�!', ['Ȯ��'], 5);
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
    XGMsgBox(Self.Handle, mtWarning, '���� ����', 'Ŭ���̾�Ʈ ������ �����Ͽ����ϴ�!' + _CRLF +
      '�͹̳�ID�� ����Ű�� Ȯ���Ͽ� �ֽʽÿ�.' + _CRLF + '(' + AErrMsg + ')', ['Ȯ��']);
end;

function TXGDashboardForm.DoPrepare: Boolean;
begin
  Result := (PluginManager.OpenModal('XGPrepare' + CPL_EXTENSION) = mrOk);
  if Result then
  begin
    Self.Width := Global.ScreenInfo.BaseWidth;
    Self.Height := Global.ScreenInfo.BaseHeight;
    // sSaleTime := Format('�����ð�: %s ~ %s',
    // [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime),
    // FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]);
    // ClientDM.DoAdminCall(0, sSaleTime, 'POS', sErrMsg);
  end;
end;

// ��޹��� ����
function TXGDashboardForm.DoEmergencyReservationStart: Boolean;
var
  sErrMsg: string;
begin
  Result := False;
  if Global.TeeBoxEmergencyMode then
  begin
    XGMsgBox(Self.Handle, mtInformation, '�˸�', '�ý����� �̹� ��޹��� ���·� �����Ǿ� �ֽ��ϴ�!',
      ['Ȯ��'], 5);
    Exit(True);
  end;

  try
    if (XGMsgBox(Self.Handle, mtConfirmation, '����', '��޹��� ���¿����� �Ǹ� �� ȸ������ ������ ���� �ʽ��ϴ�!' + _CRLF +
          '��Ʈ�ʼ��Ϳ� ������ �Ұ��� ��쿡�� ����Ͻʽÿ�.' + _CRLF + '��޹��� ���·� �ý����� ��ȯ�Ͻðڽ��ϱ�?',
          ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    if not ClientDM.conTeeBox.Connected then
      ClientDM.conTeeBox.Connected := True;

    if (not ClientDM.GetTeeBoxListEmergency(sErrMsg)) or
       (not ClientDM.SetTeeBoxEmergencyMode(True, sErrMsg)) then
      raise Exception.Create(sErrMsg);

    pgcStartUp.ActivePage := tabSaleStart;
    Result := True;
    XGMsgBox(Self.Handle, mtConfirmation, '��޹���', '�ý����� ��޹��� ��� ���·� ��ȯ �Ǿ����ϴ�!' + _CRLF +
      '�ٸ� ��ġ���� ��� ���� POS ���α׷��� �ִٸ�' + _CRLF + '�ݵ�� ����� �Ͽ� �ֽñ� �ٶ��ϴ�.', ['Ȯ��']);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Dashboard.DoEmergencyReservationStart.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', '��޹��� ���·� ��ȯ�� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

// ��޹��� ����
procedure TXGDashboardForm.DoEmergencyReservationStop;
var
  sErrMsg: string;
begin
  if not Global.TeeBoxEmergencyMode then
  begin
    XGMsgBox(Self.Handle, mtInformation, '�˸�', '�ý����� ��޹��� ���°� �ƴմϴ�!', ['Ȯ��'], 5);
    Exit;
  end;

  try
    (* KCP ��û�� ���� ��й�ȣ Ȯ�� ���� ����(20211213)
      with TXGInputBoxForm.Create(nil) do
      try
      Title := '����� Ȯ��';
      MessageText := '�ֱٿ� ������ ����� ID�� �Է��Ͽ� �ֽʽÿ�.';
      PasswordMode := False;
      if (ShowModal <> mrOK) then
      Exit;

      if (InputText <> SaleManager.UserInfo.UserId) then
      begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', '�� �� ���� ����� ID �Դϴ�!', ['Ȯ��'], 5);
      Exit;
      end;
      finally
      Free;
      end;
    *)

    if (XGMsgBox(Self.Handle, mtConfirmation, '����', '��޹��� ���¸� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    if not ClientDM.conTeeBox.Connected then
      ClientDM.conTeeBox.Connected := True;

    if (not ClientDM.SetTeeBoxEmergencyMode(False, sErrMsg)) then
      raise Exception.Create(sErrMsg);

    XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
      '��޹��� ���°� ����Ǿ� ���α׷��� ������Ͽ��� �մϴ�!' + _CRLF +
      '�ٸ� ��ġ���� ��� ���� POS ���α׷��� �ִٸ�' + _CRLF +
      '�ݵ�� ����� �Ͽ� �ֽñ� �ٶ��ϴ�.' + _CRLF +
      '���α׷��� �����ϰڽ��ϴ�.', ['Ȯ��']);
    Global.Closing := True;
    Application.Terminate;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Dashboard.DoEmergencyReservationStop.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', '��޹��� ���¸� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

// ��޹��� ��ȸ
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
    XGMsgBox(Self.Handle, mtWarning, '�˸�', '�α��� �Ŀ� ��� �����մϴ�!', ['Ȯ��'], 5);
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
        <Title>�������� �˸� ����� �߰��� �����Դϴ�.
        <Date>(2021-04-13 12:00:00 �ý��ۿ��)
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
      raise Exception.Create('���ݽõ� �����ġ ���� ������ �������� �ʽ��ϴ�!');

    SL := TStringList.Create;
    try
      SL.LoadFromFile(Global.WakeupListFileName);
      if (SL.Count = 0) then
        raise Exception.Create('���ݽõ� �����ġ�� ��ϵǾ� ���� �ʽ��ϴ�!');

      if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '���ݽõ� �����ġ�� Wake-On-LAN ����� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOk) then
      begin
        for I := 0 to Pred(SL.Count) do
        begin
          WakeOnLAN(UpperCase(SL.Strings[I]));
          Application.ProcessMessages;
        end;

        XGMsgBox(Self.Handle, mtInformation, '�˸�', '���ݽõ� ��� ������ �Ϸ��Ͽ����ϴ�!',
          ['Ȯ��'], 5);
      end;
    finally
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile,
        Format('Dashboard.DoRemoteWakeup.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '���ݽõ�', E.Message, ['Ȯ��'], 5);
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
      XGMsgBox(Self.Handle, mtWarning, '�α��� ����',
        'Ŭ���̾�Ʈ ������ ���� �ʾ� �α����� �Ұ��մϴ�!', ['Ȯ��'], 3);
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
        ShowWebView('��������', Global.NoticePopupUrl, True);
    end
    else
    begin
      UserId := '';
      TerminalPwd := '';
      panNoticeList.Visible := False;
      astNoticeList.Active := False;
      XGMsgBox(Self.Handle, mtWarning, '�α��� ����', '����� ID �Ǵ� ��й�ȣ�� ��ġ���� �ʽ��ϴ�!', ['Ȯ��'], 3);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TXGDashboardForm.AskLogout;
begin
  if UserLogged and (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '�α׾ƿ� �Ͻðڽ��ϱ�?', ['�α׾ƿ�', '���']) = mrOk) then
  begin
    UserLogged := False;
    lblUserName.Caption := '[�α׾ƿ���]';

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
  if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '���α׷��� �����Ͻðڽ��ϱ�?', ['����', '���']) = mrOk) then
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
  sMsg := IIF(AReboot, '������', '�˴ٿ�');
  if UserLogged and
     (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '���α׷��� �ݰ� POS �ý����� ' + sMsg + ' �Ͻðڽ��ϱ�?' + _CRLF +
        '�������� ���� �����Ͱ� ������ ó���� �Ŀ� �����Ͻʽÿ�.', [sMsg, '���']) = mrOk) then
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
        XGMsgBox(Self.Handle, mtError, '�˸�', '�˸��� ���α׷��� ��ġ�Ǿ� ���� �ʽ��ϴ�!' + _CRLF + sFileName, ['Ȯ��'], 5);

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
      XGMsgBox(Self.Handle, mtError, '�˸�', '�˸��� ���α׷��� �̹� ���� ���Դϴ�!' + _CRLF + sFileName, ['Ȯ��'], 5);
  end;
end;

procedure TXGDashboardForm.DoRestoreWebBrowserPosition;
begin
  if (not Global.SubMonitor.Enabled) or
     (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '���������� �⺻ �������� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOk) then
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
