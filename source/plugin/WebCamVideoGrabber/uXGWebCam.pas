(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 플러그인 템플리트 폼
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
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Graphics,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  TransparentForm, VidGrab;

{$I ..\..\common\XGPOS.inc}

type
  TXGWebCamForm = class(TPluginModule)
    imgBack: TImage;
    btnClose: TAdvShapeButton;
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    TransparentForm: TTransparentForm;
    lblMessage: TLabel;
    panFooter: TPanel;
    cbxCaptureDevice: TcxComboBox;
    cxLabel10: TLabel;
    btnStartCapture: TAdvShapeButton;
    btnSaveToBmp: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    cbxCaptureFormat: TcxComboBox;
    Label1: TLabel;
    VG: TVideoGrabber;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnSaveToBmpClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnStartCaptureClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxCaptureDevicePropertiesEditValueChanged(Sender: TObject);
    procedure cbxCaptureFormatPropertiesEditValueChanged(Sender: TObject);
    procedure VGVideoDeviceSelected(Sender: TObject);
    procedure VGDeviceLost(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FActivated: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  uXGClientDM, uXGGlobal, uXGCommonLib;

{$R *.dfm}

procedure AssignListToComboBox(AComboBox: TcxComboBox; const AList: string; const AIndex: Integer);
begin
  AComboBox.Properties.Items.Text := AList;
  if (AComboBox.Properties.Items.Count > 0) and (AIndex >= 0) then
    AComboBox.ItemIndex := AIndex;
end;

{ TXGWebCamForm }

constructor TXGWebCamForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  DL: TStringList;
begin
  inherited Create(AOwner, AMsg);

  FOwnerID := -1;
  FActivated := False;
  SetDoubleBuffered(Self, True);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  imgBack.Visible := True;
  panBody.Color := $00FFFFFF;
  btnSaveToBmp.Enabled := False;

  with VG do
  begin
    Display_AspectRatio := ar_Box; //ar_Stretch; ar_PanScan; ar_Box;
    VideoSource := vs_VideoCaptureDevice;
    AssignListToComboBox(cbxCaptureDevice, VideoDevices, VideoDevice);
    if (VideoDevicesCount > 0) then
    begin
      cbxCaptureDevice.ItemIndex := Pred(VideoDevicesCount);
      //AssignListToComboBox(cbxCaptureFormat, VideoFormats, VideoFormat);
      StartPreview;
    end;
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
  Action := caFree;
end;

procedure TXGWebCamForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGWebCamForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerID  := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TXGWebCamForm.VGDeviceLost(Sender: TObject);
begin
  AssignListToComboBox(cbxCaptureDevice, VG.VideoDevices, VG.VideoDevice);
  AssignListToComboBox(cbxCaptureFormat, VG.VideoFormats, VG.VideoFormat);
end;

procedure TXGWebCamForm.VGVideoDeviceSelected(Sender: TObject);
begin
  AssignListToComboBox(cbxCaptureFormat, VG.VideoFormats, VG.VideoFormat);
end;

procedure TXGWebCamForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGWebCamForm.btnStartCaptureClick(Sender: TObject);
begin
  VG.StartPreview
end;

procedure TXGWebCamForm.cbxCaptureDevicePropertiesEditValueChanged(Sender: TObject);
begin
  VG.VideoDevice := TcxComboBox(Sender).ItemIndex;
  AssignListToComboBox(cbxCaptureFormat, VG.VideoFormats, VG.VideoFormat);
end;

procedure TXGWebCamForm.cbxCaptureFormatPropertiesEditValueChanged(Sender: TObject);
begin
  VG.VideoFormat := TcxComboBox(Sender).ItemIndex;;
end;

procedure TXGWebCamForm.btnSaveToBmpClick(Sender: TObject);
var
  BMP: TBitmap;
begin
  VG.Stop;
  try
    BMP := VG.GetLastFrameAsTBitmap(0, False, 0, 0, 600, 360, 600, 360, 0);
  finally
    if Assigned(BMP) then
      BMP.Free;
  end;
  ModalResult := mrOK;
end;

procedure TXGWebCamForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGWebCamForm.btnCancelClick(Sender: TObject);
begin
  btnClose.Click;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGWebCamForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.