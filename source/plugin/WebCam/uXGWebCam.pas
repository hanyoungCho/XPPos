(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 웹캠 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGWebCam;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  Graphics,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxGraphics, cxLookAndFeels,
  cxControls, cxLookAndFeelPainters, dxCameraControl,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TdxCameraManagerAccess = class(TdxCameraManager);

  TXGWebCamForm = class(TPluginModule)
    panBody: TPanel;
    lblPluginVersion: TLabel;
    lblMessage: TLabel;
    panFooter: TPanel;
    cbxDeviceList: TcxComboBox;
    cxLabel10: TLabel;
    btnSaveToBmp: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    dccPreview: TdxCameraControl;
    panPreview: TPanel;
    lblFormTitle: TLabel;
    btnClose: TAdvShapeButton;
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxDeviceListPropertiesEditValueChanged(Sender: TObject);
    procedure dccPreviewStateChanged(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveToBmpClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ShowWebCamMirror(const AShow: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGWebCamForm }

constructor TXGWebCamForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  TransparentPanel(panPreview);

  FOwnerID := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnSaveToBmp.Enabled := False;

  cbxDeviceList.Properties.OnEditValueChanged := nil;
  TdxCameraManagerAccess(dxCameraManager).RefreshDeviceList;
  if (TdxCameraManagerAccess(dxCameraManager).Devices.Count > 0)  then
  begin
    cbxDeviceList.Properties.Items := TdxCameraManagerAccess(dxCameraManager).Devices;
    cbxDeviceList.Properties.OnEditValueChanged := cbxDeviceListPropertiesEditValueChanged;
    cbxDeviceList.ItemIndex := 0;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGWebCamForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGWebCamForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGWebCamForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    if dccPreview.Active then
      dccPreview.Active := False;

    ShowWebCamMirror(False);
  finally
    CanClose := True;
  end;
end;

procedure TXGWebCamForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGWebCamForm.PluginModuleShow(Sender: TObject);
begin
  if dxIsCameraAvailable then
  begin
    cbxDeviceList.ItemIndex := 0;
    dccPreview.Active := True;
  end
  else
    XGMsgBox(Self.Handle, mtWarning, '알림', '사용 가능한 카메라 장치가 없습니다!', ['확인'], 5);
end;

procedure TXGWebCamForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TXGWebCamForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGWebCamForm.ShowWebCamMirror(const AShow: Boolean);
var
  PM: TPluginMessage;
  nTop, nLeft: Integer;
//  ptPreview, ptAbsPos: TPoint;
begin
  if not Global.UseWebCamMirror then
    Exit;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_WEBCAM_PREVIEW;
    PM.AddParams(CPP_ACTIVE, AShow);
    if AShow then
    begin
      nTop := Self.Top + panBody.Top + dccPreview.Top;
      nLeft := Self.Left + panBody.Left + dccPreview.Left + (dccPreview.Width div 4);
//      ptPreview.Y := dccPreview.Top;
//      ptPreview.X := dccPreview.Left;
//      ptAbsPos := dccPreview.ClientToScreen(ptPreview);
//      nTop := ptAbsPos.Y;
//      nLeft := ptAbsPos.X;
      PM.AddParams(CPP_RECT_TOP, nTop);
      PM.AddParams(CPP_RECT_LEFT, nLeft);
      PM.AddParams(CPP_RECT_HEIGHT, dccPreview.Height);
      PM.AddParams(CPP_RECT_WIDTH, dccPreview.Width div 2);
    end;
    PM.PluginMessageToID(Global.SubMonitorId)
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGWebCamForm.dccPreviewStateChanged(Sender: TObject);
begin
  btnSaveToBmp.Enabled := False;
  case TdxCameraControl(Sender).State of
    ccsInactive:
      lblMessage.Caption := '카메라 장치가 비활성화 되어 있습니다.';
    ccsNoDevice:
      lblMessage.Caption := '사용 가능한 카메라 장치가 없습니다.';
    ccsDeviceIsBusy:
      lblMessage.Caption := '다른 작업에서 이미 카메라 장치를 사용 중입니다.';
    ccsPaused:
      lblMessage.Caption := '카메라 장치의 사용이 일시 중지 되었습니다.';
    ccsRunning:
      begin
        lblMessage.Caption := '피사체가 화면의 가운데에 위치하도록 카메라 장치의 각도를 조정하십시오.';
        btnSaveToBmp.Enabled := True;
        if Global.UseWebCamMirror and
           (Screen.MonitorCount > 1) then
          ShowWebCamMirror(True);
      end;
  end;
end;

procedure TXGWebCamForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGWebCamForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGWebCamForm.btnSaveToBmpClick(Sender: TObject);
var
  BMP: TBitmap;
begin
  BMP := TBitmap.Create;
  dccPreview.Capture;
  try
    CropBitmap(dccPreview.CapturedBitmap, BMP, dccPreview.Width div 4, 0, dccPreview.Width div 2, dccPreview.Height);
    //BMP.SaveToFile(Global.LogDir + 'Sample.bmp');
    with TPluginMessage.Create(nil) do
    try
      Command := CPC_PHOTO_CAPTURED;
      AddParams(CPP_PHOTO_BITMAP, TObject(BMP));
      PluginMessageToID(FOwnerID);
    finally
      Free;
    end;
    ModalResult := mrOK;
  finally
    BMP.Free;
  end;
end;

procedure TXGWebCamForm.cbxDeviceListPropertiesEditValueChanged(Sender: TObject);
begin
  with TcxComboBox(Sender) do
    if (ItemIndex >= 0) then
      dccPreview.DeviceIndex := ItemIndex;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGWebCamForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.