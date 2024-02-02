(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 웹 브라우저 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2020-11-16   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
unit uXGWebView;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,  StdCtrls, ExtCtrls,
  IniFiles,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { WinSoft }
  WebView,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGWebViewForm = class(TPluginModule)
    panHeader: TPanel;
    lblPluginVersion: TLabel;
    lblPOSInfo: TLabel;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    panHeaderTools: TPanel;
    btnBack: TAdvShapeButton;
    btnHome: TAdvShapeButton;
    WebViewControl: TWebView;
    btnStop: TAdvShapeButton;
    btnRefresh: TAdvShapeButton;
    btnForward: TAdvShapeButton;
    btnBackToOpener: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    tmrClock: TTimer;
    btnSettings: TAdvShapeButton;
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WebViewControlActive(Sender: TObject);
    procedure WebViewControlException(Sender: TObject; Exception: Exception);
    procedure WebViewControlNavigationCompleted(Sender: TObject; Success: Boolean; WebError: TWebError; NavigationId: UInt64);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnBackToOpenerClick(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure panHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure panHeaderDblClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure WebViewControlFullScreenChanged(Sender: TObject);
  private
    { Private declarations }
    FOpenerId: Integer;
    FNavigateUri: string;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FTop: Integer;
    FLeft: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FPreviousWindowState: TWindowState;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure UpdateControls;
    procedure WebViewNavigationStarting(Sender: TObject; const Uri: WString; UserInitiated, Redirected: Boolean;
      const RequestHeaders: THeaders; NavigationId: UInt64; var Cancel: Boolean);
    procedure SetNavigateUri(const AValue: string);

    function GetBorderSpace: Integer;
    function IsBorderless: Boolean;
    procedure WM_NCCalcSize(var AMessage: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WM_NCHitTest(var AMessage: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure CreateParams(var AParams: TCreateParams); override;
    procedure Paint; override;
    procedure Resize; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property NavigateUri: string read FNavigateUri write SetNavigateUri;
  end;

var
  XGWebViewForm: TXGWebViewForm;

implementation

uses
  Graphics,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox;

{$R *.dfm}

{ TXGWebViewForm }

procedure TXGWebViewForm.CreateParams(var AParams: TCreateParams);
begin
  BorderStyle := bsNone;

  inherited;

  AParams.ExStyle := AParams.ExStyle or WS_EX_STATICEDGE;
  AParams.Style := AParams.Style or WS_SIZEBOX;
end;

procedure TXGWebViewForm.Paint;
begin
  inherited;

  if (WindowState = wsNormal) and
     (not IsBorderless) then
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width, 0);
  end;
end;

procedure TXGWebViewForm.Resize;
begin
  inherited;

  if (WindowState = wsNormal) and
     (not IsBorderless) then
    Padding.Top := 1
  else
    Padding.Top := 0;
end;

constructor TXGWebViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOpenerId := 0;
  FIsFirst := True;
  FNavigateUri := '';
  FPreviousWindowState := wsNormal;

  SetDoubleBuffered(Self, True);
  BorderStyle := bsSizeable;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  WebViewControl.DataFolder := Global.WebCacheDir;
  WebViewControl.OnNavigationStarting := WebViewNavigationStarting;

  with Global.ConfigLocal do
  begin
    FTop := ReadInteger('WebView', 'Top', 0);
    FLeft := ReadInteger('WebView', 'Left', 0);
    FHeight := ReadInteger('WebView', 'Height', 0);
    FWidth := ReadInteger('WebView', 'Width', 0);
  end;
  Self.Top := FTop;
  Self.Left := (FLeft - GetBorderSpace);
  if (FHeight = 0) then
    Self.ClientHeight := Global.ScreenInfo.BaseHeight
  else
    Self.ClientHeight := FHeight;
  if (FWidth = 0) then
    Self.ClientWidth := Global.ScreenInfo.BaseWidth
  else
    Self.ClientWidth := FWidth;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

destructor TXGWebViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGWebViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGWebViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) or
     (AMsg.Command = CPC_SET_FOREGROUND) then
  begin
    FOpenerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    NavigateUri := AMsg.ParamByString(CPP_NAVIGATE_URL);
    if (GetForegroundWindow <> Self.Handle) then
      SetForegroundWindow(Self.Handle);
  end;

  if (AMsg.Command = CPC_RESTORE_WEB_POS) then
  begin
    Self.Top := 0;
    Self.Left := 0;
    Self.Height := Global.ScreenInfo.BaseHeight;
    Self.Width := Global.ScreenInfo.BaseWidth;
    SetForegroundWindow(Self.Handle);
  end;

  if (AMsg.Command = CPC_CLOSE) then
    btnClose.Click;
end;

procedure TXGWebViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  with Global.ConfigLocal do
  begin
    if (Self.Top <> FTop) then
      WriteInteger('WebView', 'Top', Self.Top);
    if (Self.Left <> FLeft) then
      WriteInteger('WebView', 'Left', Self.Left + GetBorderSpace);
    if (Self.Height <> FHeight) then
      WriteInteger('WebView', 'Height', Self.ClientHeight);
    if (Self.Width <> FWidth) then
      WriteInteger('WebView', 'Width', Self.ClientWidth);
    if Modified then
      UpdateFile;
  end;

  Global.WebViewId := 0;
  WebViewControl.Active := False;
  WebViewControl.Free;
  Action := caFree;
end;

procedure TXGWebViewForm.PluginModuleActivate(Sender: TObject);
begin
  panClock.Visible := True;
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
end;

procedure TXGWebViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F11:
      btnBackToOpener.Click;
    VK_ADD:
      if ssCtrl in Shift then
        WebViewControl.Zoom := WebViewControl.Zoom + 0.1;
    VK_SUBTRACT:
      if ssCtrl in Shift then
        WebViewControl.Zoom := WebViewControl.Zoom - 0.1;
  end;
end;

procedure TXGWebViewForm.SetNavigateUri(const AValue: string);
begin
  if (not AValue.IsEmpty) and
     (FNavigateUri <> AValue) then
  begin
    FNavigateUri := AValue;
    WebViewControl.Uri := FNavigateUri;
    try
      WebViewControl.Active := True;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGWebViewForm.UpdateControls;
begin
  btnBack.Enabled := WebViewControl.CanBack;
  btnForward.Enabled := WebViewControl.CanForward;
  btnRefresh.Enabled := WebViewControl.Active;
end;

procedure TXGWebViewForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    FTimeBlink := (not FTimeBlink);
    lblClockDate.Caption := Global.FormattedCurrentDate;
    lblClockWeekday.Caption := Format('(%s)', [Global.DayOfWeekKR]);
    lblClockHours.Caption := Copy(Global.CurrentTime, 1, 2);
    lblClockMins.Caption := Copy(Global.CurrentTime, 3, 2);
    lblClockSepa.Caption := IIF(FTimeBlink, '', ':');

    if FIsFirst then
    begin
      FIsFirst := False;
      Interval := 500;
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;

procedure TXGWebViewForm.WebViewControlActive(Sender: TObject);
begin
  UpdateControls;
end;

procedure TXGWebViewForm.WebViewControlException(Sender: TObject; Exception: Exception);
begin
  XGMsgBox(Self.Handle, mtError, '알림', Exception.Message, ['확인'], 5);
end;

procedure TXGWebViewForm.WebViewControlFullScreenChanged(Sender: TObject);
begin
  if WebViewControl.FullScreen then
  begin
    FPreviousWindowState := WindowState;
    WindowState := wsNormal;
    SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not (WS_CAPTION or WS_THICKFRAME));
    Self.WindowState := wsMaximized;
    WebViewControl.MoveFocus(frProgrammatic);
  end
  else
  begin
    SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or (WS_CAPTION or WS_THICKFRAME));
    Self.WindowState := FPreviousWindowState;
  end;
end;

procedure TXGWebViewForm.WebViewNavigationStarting(Sender: TObject; const Uri: WString;
  UserInitiated, Redirected: Boolean; const RequestHeaders: THeaders; NavigationId: UInt64;
  var Cancel: Boolean);
begin
  UpdateControls;
  btnStop.Enabled := True;
end;

procedure TXGWebViewForm.WebViewControlNavigationCompleted(Sender: TObject; Success: Boolean; WebError: TWebError; NavigationId: UInt64);
begin
  UpdateControls;
  btnStop.Enabled := False;
  Self.Caption := WebViewControl.Uri;
end;

procedure TXGWebViewForm.btnBackClick(Sender: TObject);
begin
  if WebViewControl.CanBack then
    WebViewControl.Back;
end;

procedure TXGWebViewForm.btnForwardClick(Sender: TObject);
begin
  if WebViewControl.CanForward then
    WebViewControl.Forward;
end;

procedure TXGWebViewForm.btnRefreshClick(Sender: TObject);
begin
  WebViewControl.Refresh;
end;

procedure TXGWebViewForm.btnSettingsClick(Sender: TObject);
begin
  WebViewControl.OpenDevTools;
end;

procedure TXGWebViewForm.btnStopClick(Sender: TObject);
begin
  WebViewControl.Stop;
end;

procedure TXGWebViewForm.btnHomeClick(Sender: TObject);
begin
  WebViewControl.Uri := Global.BackOfficeUrl + '/main';
end;

procedure TXGWebViewForm.btnBackToOpenerClick(Sender: TObject);
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SET_FOREGROUND;
    PluginMessageToID(FOpenerId);
  finally
    Free;
  end;
end;

procedure TXGWebViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGWebViewForm.panHeaderDblClick(Sender: TObject);
begin
  if (WindowState = wsNormal) then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TXGWebViewForm.panHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

function TXGWebViewForm.GetBorderSpace: Integer;
begin
  case BorderStyle of
    bsSingle:
      Result := GetSystemMetrics(SM_CYFIXEDFRAME);
    bsDialog,
    bsToolWindow:
      Result := GetSystemMetrics(SM_CYDLGFRAME);
    bsSizeable,
    bsSizeToolWin:
      Result := GetSystemMetrics(SM_CYSIZEFRAME) + GetSystemMetrics(SM_CXPADDEDBORDER);
    else
      Result := 0;
  end;
end;

function TXGWebViewForm.IsBorderless: Boolean;
begin
  Result := BorderStyle in [bsNone, bsToolWindow, bsSizeToolWin];
end;

procedure TXGWebViewForm.WM_NCCalcSize(var AMessage: TWMNCCalcSize);
var
  nCaptionBarHeight: Integer;
begin
  inherited;
  if (BorderStyle = bsNone) then
    Exit;
  nCaptionBarHeight := GetSystemMetrics(SM_CYCAPTION);
  if (WindowState = wsNormal) then
    Inc(nCaptionBarHeight, GetBorderSpace);
  Dec(AMessage.CalcSize_Params.rgrc[0].Top, nCaptionBarHeight);
end;

procedure TXGWebViewForm.WM_NCHitTest(var AMessage: TWMNCHitTest);
var
  nResizeSpace: Integer;
begin
  inherited;

  nResizeSpace := GetBorderSpace;
  if (WindowState = wsNormal) and
     (BorderStyle in [bsSizeable, bsSizeToolWin]) and
     ((AMessage.YPos - BoundsRect.Top) <= nResizeSpace) then
  begin
    if (AMessage.XPos - BoundsRect.Left) <= (nResizeSpace * 2) then
      AMessage.Result := HTTOPLEFT
    else if (BoundsRect.Right - AMessage.XPos) <= (nResizeSpace * 2) then
      AMessage.Result := HTTOPRIGHT
    else
      AMessage.Result := HTTOP;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGWebViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
