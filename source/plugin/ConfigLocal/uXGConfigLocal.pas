(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 사용자 환경 설정
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
unit uXGConfigLocal;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls, Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxCore, cxMemo, cxGroupBox, cxRadioGroup, dxGalleryControl, dxColorGallery,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxCheckBox,
  cxPC,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  cyBaseSpeedButton, cySpeedButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGConfigLocalForm = class(TPluginModule)
    lblPluginVersion: TLabel;
    lblFormTitle: TLabel;
    panBody: TPanel;
    panRight: TPanel;
    pgcConfig: TcxPageControl;
    tabLocalPolicy: TcxTabSheet;
    ckbImmediateTeeBoxAssign: TcxCheckBox;
    ckbTeeBoxForceAssign: TcxCheckBox;
    ckbTeeBoxForceAssignOnError: TcxCheckBox;
    ckbTeeBoxChangedReIssue: TcxCheckBox;
    ckbIsSimpleMember: TcxCheckBox;
    ckbTeeBoxQuickView: TcxCheckBox;
    ckbSelfCashReceiptDefault: TcxCheckBox;
    tabPrinter: TcxTabSheet;
    ckbParkingTicket: TcxCheckBox;
    ckbFitnessTicket: TcxCheckBox;
    ckbSaunaTicket: TcxCheckBox;
    tabWakeOnLan: TcxTabSheet;
    lblNoticeRemote: TLabel;
    mmoRemoteMacAddrList: TcxMemo;
    lblPageTitle: TLabel;
    panLeftSide: TPanel;
    btnPage0: TcySpeedButton;
    btnPage2: TcySpeedButton;
    btnPage5: TcySpeedButton;
    btnApply: TcySpeedButton;
    btnCancel: TcySpeedButton;
    btnPage3: TcySpeedButton;
    tabSubMonitor: TcxTabSheet;
    lblTeeBoxQuickViewMode: TLabel;
    cbxTeeBoxQuickViewMode: TcxComboBox;
    Label1: TLabel;
    panScoboardBackColor: TPanel;
    imgScoboardPreview: TImage;
    btnScoboardBackColorDefault: TButton;
    cbxScoboardBackColorSet: TcxComboBox;
    selScoboardBackColor: TdxColorGallery;
    Label57: TLabel;
    edtGameOverAlarmMin: TcxSpinEdit;
    lblNoticeQuickView: TLabel;
    lblNoticeAddonTicket: TLabel;
    ckbPrintAlldayPass: TcxCheckBox;
    ckbAutoRunAdminCall: TcxCheckBox;
    btnPage4: TcySpeedButton;
    tabHeater: TcxTabSheet;
    Label36: TLabel;
    rdgAirConOnOffMode: TcxRadioGroup;
    Label34: TLabel;
    Label35: TLabel;
    ckbUseAirCon: TcxCheckBox;
    edtReceiptCopies: TcxSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtTeeBoxTicketCopies: TcxSpinEdit;
    Label4: TLabel;
    ckbReceiptPreview: TcxCheckBox;
    ckbReserveAllowedOnOrderTime: TcxCheckBox;
    ckbUseWebCamMirror: TcxCheckBox;
    ckbHoldAllowedOnLeftClick: TcxCheckBox;
    edtAirConBaseMinutes: TcxSpinEdit;
    ckbUseTeeBoxTeleReserved: TcxCheckBox;
    Label5: TLabel;
    edtTeeBoxFontSizeAdjust: TcxSpinEdit;
    ckbShowErrorStatus: TcxCheckBox;
    btnPage6: TcySpeedButton;
    tabOpenWeather: TcxTabSheet;
    edtWeatherApiHost: TcxTextEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtWeatherApiLatitude: TcxTextEdit;
    edtWeatherApiLongitude: TcxTextEdit;
    Label9: TLabel;
    edtWeatherApiKey: TcxTextEdit;
    Label10: TLabel;
    btnWeatherSite: TcySpeedButton;
    btnWeatherApiTest: TcySpeedButton;
    btnClose: TAdvShapeButton;
    ckbUseFingerPrintMirror: TcxCheckBox;
    rdgSaunaTicketKind: TcxRadioGroup;
    btnPage1: TcySpeedButton;
    tabTable: TcxTabSheet;
    lblTableUnitName: TLabel;
    edtTableUnitName: TcxTextEdit;
    ckbUseLessonReceipt: TcxCheckBox;
    ckbPrintWithAssignTicket: TcxCheckBox;
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure OnPageButtonClick(Sender: TObject);
    procedure ckbTeeBoxQuickViewPropertiesChange(Sender: TObject);
    procedure btnScoboardBackColorDefaultClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure selScoboardBackColorChange(Sender: TObject);
    procedure cbxScoboardBackColorSetPropertiesChange(Sender: TObject);
    procedure ckbAutoRunAdminCallClick(Sender: TObject);
    procedure edtWeatherApiKeyDblClick(Sender: TObject);
    procedure btnWeatherSiteClick(Sender: TObject);
    procedure btnWeatherApiTestClick(Sender: TObject);
    procedure ckbSaunaTicketPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ReadConfig;
    procedure WriteConfig;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, JSON, ShellApi,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TConfigForm }

constructor TXGConfigLocalForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I: Integer;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  with pgcConfig do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  edtTableUnitName.Enabled := (SaleManager.StoreInfo.POSType in [CPO_SALE_SCREEN_ROOM, CPO_SALE_RESTRAUNT]);
  lblTableUnitName.Enabled := edtTableUnitName.Enabled;

  ReadConfig;
  ckbAutoRunAdminCall.OnClick := ckbAutoRunAdminCallClick;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGConfigLocalForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGConfigLocalForm.edtWeatherApiKeyDblClick(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    if (Properties.EchoMode = eemNormal) then
      Properties.EchoMode := eemPassword
    else
      Properties.EchoMode := eemNormal;
end;

procedure TXGConfigLocalForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGConfigLocalForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGConfigLocalForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg = nil) then
    Exit;

  if (AMsg.Command = CPC_INIT) then
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TXGConfigLocalForm.selScoboardBackColorChange(Sender: TObject);
begin
  panScoboardBackColor.Color := TdxColorGallery(Sender).ColorValue;
end;

procedure TXGConfigLocalForm.btnApplyClick(Sender: TObject);
begin
  WriteConfig;
  ModalResult := mrOK;
end;

procedure TXGConfigLocalForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGConfigLocalForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGConfigLocalForm.btnScoboardBackColorDefaultClick(Sender: TObject);
begin
  selScoboardBackColor.ColorValue := GCR_COLOR_BACK_PANEL;
end;

procedure TXGConfigLocalForm.btnWeatherApiTestClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with Global.WeatherInfo do
  begin
    Host := ExcludeTrailingPathDelimiter(edtWeatherApiHost.Text);
    ApiKey := edtWeatherApiKey.Text;
    Latitude := edtWeatherApiLatitude.Text;
    Longitude := edtWeatherApiLongitude.Text;
    Enabled := not (Host.IsEmpty or Latitude.IsEmpty or Longitude.IsEmpty or ApiKey.IsEmpty);
  end;

  if ClientDM.GetWeatherInfo(sErrMsg) then
    XGMsgBox(Self.Handle, mtInformation, '알림', '날씨 정보 조회 API가 정상적으로 완료되었습니다.' , ['확인'], 5)
  else
    XGMsgBox(Self.Handle, mtError, '알림', sErrMsg, ['확인'], 5);
end;

procedure TXGConfigLocalForm.btnWeatherSiteClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(CCC_WEATHER_URL), nil, nil, SW_SHOW);
end;

procedure TXGConfigLocalForm.cbxScoboardBackColorSetPropertiesChange(Sender: TObject);
begin
  selScoboardBackColor.ColorSet := TdxColorSet(TcxComboBox(Sender).ItemIndex);
end;

procedure TXGConfigLocalForm.ckbAutoRunAdminCallClick(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
    XGMsgBox(Self.Handle, mtConfirmation, '알림',
      '알리미는 사업장 내에서 한 곳에서만 실행 되어야 합니다!' + _CRLF +
      '여러 곳에서 실행하여 모두 동작 되는 건 아니므로' + _CRLF +
      '실행 위치 변경 시에는 반드시 관리자에 문의하여 주십시오.',
      ['확인']);
end;

procedure TXGConfigLocalForm.ckbSaunaTicketPropertiesChange(Sender: TObject);
begin
  rdgSaunaTicketKind.Enabled := TcxCheckBox(Sender).Checked;
end;

procedure TXGConfigLocalForm.ckbTeeBoxQuickViewPropertiesChange(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    cbxTeeBoxQuickViewMode.Enabled := Checked;
    lblTeeBoxQuickViewMode.Enabled := Checked;
  end;
end;

procedure TXGConfigLocalForm.OnPageButtonClick(Sender: TObject);
begin
  with TcySpeedButton(Sender) do
  begin
    lblPageTitle.Caption := Caption;
    pgcConfig.ActivePageIndex := Tag;
  end;
end;

procedure TXGConfigLocalForm.ReadConfig;
begin
  { 로컬 운영 정책 }
  ckbImmediateTeeBoxAssign.Checked := Global.ImmediateTeeBoxAssign;
  ckbTeeBoxForceAssign.Checked := Global.TeeBoxForceAssign;
  ckbTeeBoxForceAssignOnError.Checked := Global.TeeBoxForceAssignOnError;
  ckbTeeBoxChangedReIssue.Checked := Global.TeeBoxChangedReIssue;
  ckbIsSimpleMember.Checked := Global.IsSimpleMember;
  ckbSelfCashReceiptDefault.Checked := Global.SelfCashReceiptDefault;
  ckbReserveAllowedOnOrderTime.Checked := Global.ReserveAllowedOnOrderTime;
  ckbHoldAllowedOnLeftClick.Checked := Global.HoldAllowedOnLeftClick;
  ckbAutoRunAdminCall.Checked := Global.AutoRunAdminCall;
  edtTeeBoxFontSizeAdjust.Value := Global.TeeBoxFontSizeAdjust;
  ckbUseWebCamMirror.Checked := Global.UseWebCamMirror;
  ckbUseFingerPrintMirror.Checked := Global.UseFingerPrintMirror;
  ckbUseTeeBoxTeleReserved.Checked := Global.UseTeeBoxTeleReserved;
  ckbUseLessonReceipt.Checked := Global.UseLessonReceipt;
  edtGameOverAlarmMin.Value := Global.GameOverAlarmMin;
  ckbTeeBoxQuickView.Checked := Global.TeeBoxQuickView;
  cbxTeeBoxQuickViewMode.ItemIndex := Global.TeeBoxQuickViewMode;
  lblTeeBoxQuickViewMode.Enabled := Global.TeeBoxQuickView;
  cbxTeeBoxQuickViewMode.Enabled := Global.TeeBoxQuickView;
  edtTableUnitName.Text := Global.TableInfo.UnitName;

  { 타석 상황 모니터 }
  selScoboardBackColor.ColorValue := Global.SubMonitor.BackgroundColor;
  panScoboardBackColor.Color := Global.SubMonitor.BackgroundColor;
  ckbShowErrorStatus.Checked := Global.SubMonitor.ShowErrorStatus;

  { 프린터 출력 설정 }
  edtReceiptCopies.Value := Global.ReceiptCopies;
  edtTeeBoxTicketCopies.Value := Global.TeeBoxTicketCopies;
  ckbReceiptPreview.Checked := Global.ReceiptPreview;

  { 부대시설 이용권 }
  ckbParkingTicket.Checked := Global.AddOnTicket.ParkingTicket;
  ckbSaunaTicket.Checked := Global.AddOnTicket.SaunaTicket;
  rdgSaunaTicketKind.Enabled := Global.AddOnTicket.SaunaTicket;
  rdgSaunaTicketKind.ItemIndex := Global.AddOnTicket.SaunaTicketKind;
  ckbFitnessTicket.Checked := Global.AddOnTicket.FitnessTicket;
  ckbPrintAlldayPass.Checked := Global.AddOnTicket.PrintAlldayPass;
  ckbPrintWithAssignTicket.Checked := Global.AddOnTicket.PrintWithAssignTicket;

  { 냉/온풍기 }
  ckbUseAirCon.Checked := Global.AirConditioner.Enabled;
  rdgAirConOnOffMode.ItemIndex := Global.AirConditioner.OnOffMode;
  edtAirConBaseMinutes.Value := Global.AirConditioner.BaseMinutes;

  { 원격 시동 설정 }
  if FileExists(Global.WakeupListFileName) then
    mmoRemoteMacAddrList.Lines.LoadFromFile(Global.WakeupListFileName);

  { 날씨 정보 }
  edtWeatherApiHost.Text := Global.WeatherInfo.Host;
  edtWeatherApiLatitude.Text := Global.WeatherInfo.Latitude;
  edtWeatherApiLongitude.Text := Global.WeatherInfo.Longitude;
  edtWeatherApiKey.Text := Global.WeatherInfo.ApiKey;
end;

procedure TXGConfigLocalForm.WriteConfig;
var
  nAdjust: Integer;
begin
  with Global.ConfigLocal do
  begin
    { 로컬 운영 정책 }
    WriteInteger('Config', 'PrepareMin', Global.PrepareMin);
    WriteInteger('Config', 'GameOverAlarmMin', Trunc(edtGameOverAlarmMin.Value));
    WriteBool('Config', 'IsSimpleMember', ckbIsSimpleMember.Checked);
    WriteBool('Config', 'ImmediateTeeBoxAssign', ckbImmediateTeeBoxAssign.Checked);
    WriteBool('Config', 'TeeBoxChangedReIssue', ckbTeeBoxChangedReIssue.Checked);
    WriteBool('Config', 'TeeBoxQuickView', ckbTeeBoxQuickView.Checked);
    WriteInteger('Config', 'TeeBoxQuickViewMode', cbxTeeBoxQuickViewMode.ItemIndex);
    WriteBool('Config', 'TeeBoxForceAssign', ckbTeeBoxForceAssign.Checked);
    WriteBool('Config', 'TeeBoxForceAssignOnError', ckbTeeBoxForceAssignOnError.Checked);
    WriteBool('Config', 'SelfCashReceiptDefault', ckbSelfCashReceiptDefault.Checked);
    WriteBool('Config', 'ReserveAllowedOnOrderTime', ckbReserveAllowedOnOrderTime.Checked);
    WriteBool('Config', 'HoldAllowedOnLeftClick', ckbHoldAllowedOnLeftClick.Checked);
    WriteBool('Config', 'AutoRunAdminCall', ckbAutoRunAdminCall.Checked);
    WriteBool('Config', 'UseWebCamMirror', ckbUseWebCamMirror.Checked);
    WriteBool('Config', 'UseFingerPrintMirror', ckbUseFingerPrintMirror.Checked);
    WriteBool('Config', 'UseLessonReceipt', ckbUseLessonReceipt.Checked);
    WriteBool('Config', 'UseTeeBoxTeleReserved', ckbUseTeeBoxTeleReserved.Checked);

    { 타석 상태 표시 글꼴 크기 }
    nAdjust := Trunc(edtTeeBoxFontSizeAdjust.Value);
    if (Global.TeeBoxFontSizeAdjust <> nAdjust) then
      WriteInteger('Config', 'TeeBoxFontSizeAdjust', nAdjust);

    { 듀얼 모니터(고객측) }
    if (Global.SubMonitor.BackgroundColor <> selScoboardBackColor.ColorValue) then
    begin
      WriteInteger('Scoreboard', 'BackgroundColor', selScoboardBackColor.ColorValue);
      WriteBool('Scoreboard', 'ShowErrorStatus', ckbShowErrorStatus.Checked);
    end;

    if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) and
       ((Global.TeeBoxFontSizeAdjust <> nAdjust) or
        (Global.SubMonitor.BackgroundColor <> selScoboardBackColor.ColorValue)) then
      with TPluginMessage.Create(nil) do
      try
        Command := CPC_APPLY_CONFIG;
        AddParams(CPP_FONT_SIZE_ADJUST, nAdjust);
        AddParams(CPP_BACK_COLOR, Integer(selScoboardBackColor.ColorValue));
        PluginMessageToID(Global.SubMonitorId);
        if Global.TeeBoxEmergencyMode then
          PluginMessageToID(Global.TeeBoxEmergencyId)
        else
          PluginMessageToID(Global.TeeBoxViewId);
      finally
        Free;
      end;

    { 프린터 출력 설정 }
    WriteInteger('Printout', 'ReceiptCopies', Trunc(edtReceiptCopies.Value));
    WriteInteger('Printout', 'TeeBoxTicketCopies', Trunc(edtTeeBoxTicketCopies.Value));
    WriteBool('Printout', 'ReceiptPreview', ckbReceiptPreview.Checked);

    { 부대시설 이용권 }
    WriteBool('AddonTicket', 'ParkingTicket', ckbParkingTicket.Checked);
    WriteBool('AddonTicket', 'SaunaTicket', ckbSaunaTicket.Checked);
    WriteInteger('AddonTicket', 'SaunaTicketKind', rdgSaunaTicketKind.ItemIndex);
    WriteBool('AddonTicket', 'FitnessTicket', ckbFitnessTicket.Checked);
    WriteBool('AddonTicket', 'PrintAlldayPass', ckbPrintAlldayPass.Checked);
    WriteBool('AddonTicket', 'PrintWithAssignTicket', ckbPrintWithAssignTicket.Checked);

    { 냉/온풍기 }
    WriteBool('AirConditioner', 'Enabled', ckbUseAirCon.Checked);
    WriteInteger('AirConditioner', 'OnOffMode', rdgAirConOnOffMode.ItemIndex);
    WriteInteger('AirConditioner', 'BaseMinutes', Trunc(edtAirConBaseMinutes.Value));

    { 날씨 정보 }
    WriteString('Weather', 'Host', edtWeatherApiHost.Text);
    WriteString('Weather', 'Latitude', edtWeatherApiLatitude.Text);
    WriteString('Weather', 'Longitude', edtWeatherApiLongitude.Text);
    WriteString('Weather', 'ApiKey', StrEncrypt(edtWeatherApiKey.Text));

    if Modified then
    begin
      UpdateFile;
      Global.ReadConfigLocal;
    end;
  end;

  { 테이블&룸 설정 }
  with Global.ConfigTable do
  begin
    WriteString('Config', 'UnitName', edtTableUnitName.Text);

    if Modified then
    begin
      UpdateFile;
      Global.ReadConfigTable;
    end;
  end;

  { 원격 시동 설정 }
  if (mmoRemoteMacAddrList.Lines.Count > 0) then
    mmoRemoteMacAddrList.Lines.SaveToFile(Global.WakeupListFileName)
  else
    DeleteFile(Global.WakeupListFileName);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGConfigLocalForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.