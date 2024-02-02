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
unit uXGNoticeView;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,  StdCtrls, ExtCtrls,
  IniFiles,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox,
  { WinSoft }
  WebView,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGNoticeViewForm = class(TPluginModule)
    panBody: TPanel;
    panHeader: TPanel;
    panWebNavigator: TPanel;
    btnBack: TAdvShapeButton;
    btnHome: TAdvShapeButton;
    btnStop: TAdvShapeButton;
    btnRefresh: TAdvShapeButton;
    btnForward: TAdvShapeButton;
    NoticeView: TWebView;
    lblPluginVersion: TLabel;
    ckbShowNoMoreToday: TcxCheckBox;
    panClose: TPanel;
    btnClose: TAdvShapeButton;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NoticeViewActive(Sender: TObject);
    procedure NoticeViewException(Sender: TObject; Exception: Exception);
    procedure NoticeViewNavigationCompleted(Sender: TObject; Success: Boolean; WebError: TWebError; NavigationId: UInt64);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure ckbShowNoMoreTodayClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FNavigateUri: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure UpdateControls;
    procedure WebViewNavigationStarting(Sender: TObject; const Uri: WString; UserInitiated, Redirected: Boolean;
      const RequestHeaders: THeaders; NavigationId: UInt64; var Cancel: Boolean);
    procedure SetNavigateUri(const AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property NavigateUri: string read FNavigateUri write SetNavigateUri;
  end;

var
  XGNoticeViewForm: TXGNoticeViewForm;

implementation

uses
  { Native }
  Graphics,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGNoticeViewForm }

constructor TXGNoticeViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := 0;
  FNavigateUri := '';
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  ckbShowNoMoreToday.Visible := False;
  NoticeView.DataFolder := Global.WebCacheDir;
  NoticeView.OnNavigationStarting := WebViewNavigationStarting;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

procedure TXGNoticeViewForm.ckbShowNoMoreTodayClick(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
    Global.LastNoticeDate := Global.CurrentDate
  else
    Global.LastNoticeDate := '';

  Global.ConfigLocal.WriteString('Config', 'LastNoticeDate', Global.LastNoticeDate);
  Global.ConfigLocal.UpdateFile;
end;

destructor TXGNoticeViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGNoticeViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  NoticeView.Active := False;
  NoticeView.Free;
  Action := caFree;
end;

procedure TXGNoticeViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGNoticeViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    panHeader.Caption := AMsg.ParamByString(CPP_FORM_TITLE);
    NavigateUri := AMsg.ParamByString(CPP_NAVIGATE_URL);
    panWebNavigator.Visible := AMsg.ParamByBoolean(CPP_SHOW_NAVIGATOR);
    ckbShowNoMoreToday.Visible := AMsg.ParamByBoolean(CPP_SHOW_NO_MORE);
  end;
end;

procedure TXGNoticeViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
    VK_ADD:
      if ssCtrl in Shift then
        NoticeView.Zoom := NoticeView.Zoom + 0.1;
    VK_SUBTRACT:
      if ssCtrl in Shift then
        NoticeView.Zoom := NoticeView.Zoom - 0.1;
  end;
end;

procedure TXGNoticeViewForm.SetNavigateUri(const AValue: string);
begin
  if (not AValue.IsEmpty) and
     (FNavigateUri <> AValue) then
  begin
    FNavigateUri := AValue;
    NoticeView.Uri := FNavigateUri;
    try
      NoticeView.Active := True;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGNoticeViewForm.UpdateControls;
begin
  btnBack.Enabled := NoticeView.CanBack;
  btnForward.Enabled := NoticeView.CanForward;
  btnRefresh.Enabled := NoticeView.Active;
end;

procedure TXGNoticeViewForm.NoticeViewActive(Sender: TObject);
begin
  UpdateControls;
end;

procedure TXGNoticeViewForm.NoticeViewException(Sender: TObject; Exception: Exception);
begin
  XGMsgBox(Self.Handle, mtError, '알림', Exception.Message, ['확인'], 5);
end;

procedure TXGNoticeViewForm.WebViewNavigationStarting(Sender: TObject; const Uri: WString;
  UserInitiated, Redirected: Boolean; const RequestHeaders: THeaders; NavigationId: UInt64;
  var Cancel: Boolean);
begin
  UpdateControls;
  btnStop.Enabled := True;
end;

procedure TXGNoticeViewForm.NoticeViewNavigationCompleted(Sender: TObject; Success: Boolean; WebError: TWebError; NavigationId: UInt64);
begin
  UpdateControls;
  btnStop.Enabled := False;
  Self.Caption := NoticeView.Uri;
end;

procedure TXGNoticeViewForm.btnBackClick(Sender: TObject);
begin
  if NoticeView.CanBack then
    NoticeView.Back;
end;

procedure TXGNoticeViewForm.btnForwardClick(Sender: TObject);
begin
  if NoticeView.CanForward then
    NoticeView.Forward;
end;

procedure TXGNoticeViewForm.btnHomeClick(Sender: TObject);
begin
  NoticeView.Uri := FNavigateUri;
end;

procedure TXGNoticeViewForm.btnRefreshClick(Sender: TObject);
begin
  NoticeView.Refresh;
end;

procedure TXGNoticeViewForm.btnStopClick(Sender: TObject);
begin
  NoticeView.Stop;
end;

procedure TXGNoticeViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGNoticeViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
