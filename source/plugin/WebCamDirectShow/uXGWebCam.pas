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
  { Custom }
  uVideoFrames, uVideoSample,
  { Solbi VCL }
  TransparentForm;

{$I ..\..\common\XGPOS.inc}

type
  TXGWebCamForm = class(TPluginModule)
    imgBack: TImage;
    btnClose: TAdvShapeButton;
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    TransparentForm: TTransparentForm;
    shpPreview: TShape;
    pbxPreview: TPaintBox;
    lblMessage: TLabel;
    panFooter: TPanel;
    cbxCaptureDevice: TcxComboBox;
    cxLabel10: TLabel;
    btnStartCapture: TAdvShapeButton;
    btnSaveToBmp: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    cbxCaptureResList: TcxComboBox;
    Label1: TLabel;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnSaveToBmpClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnStartCaptureClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxCaptureResListPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FVideoImage: TVideoImage;
    FVideoBitmap: Graphics.TBitmap;
    FActivated: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure OnNewVideoFrame(Sender: TObject; AWidth, AHeight: Integer; ADataPtr: Pointer);
    procedure OnNewVideoCanvas(Sender: TObject; AWidth, AHeight: Integer; ADataPtr: Pointer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  uXGClientDM, uXGGlobal, uXGCommonLib;

{$R *.dfm}

{ TXGWebCamForm }

constructor TXGWebCamForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  DL: TStringList;
begin
  inherited Create(AOwner, AMsg);

  FOwnerID := -1;
  SetDoubleBuffered(Self, True);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  imgBack.Visible := True;
  panBody.Color := $00FFFFFF;
  btnSaveToBmp.Enabled := False;

  FActivated := False;
  FVideoBitmap := TBitmap.Create;
  FVideoImage := TVideoImage.Create;
  //FVideoImage.SetDisplayCanvas(pbxPreview.Canvas);

  DL := TStringList.Create;
  try
    FVideoImage.GetListOfDevices(DL);
    cbxCaptureDevice.Properties.Items := DL;
    if (DL.Count > 0) then
    begin
      cbxCaptureDevice.ItemIndex := 0;
      btnStartCapture.Click;
      //btnStartCaptureClick(btnStartCapture);
    end else
    begin
      btnStartCapture.Enabled := False;
      cbxCaptureDevice.Text := '카메라 장치를 인식할 수 없습니다!';
    end;
  finally
    DL.Free;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGWebCamForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGWebCamForm.OnNewVideoCanvas(Sender: TObject; AWidth, AHeight: Integer; ADataPtr: Pointer);
begin
  FVideoImage.GetBitmap(FVideoBitmap);
  pbxPreview.Canvas.Draw(0, 0, FVideoBitmap);
end;

procedure TXGWebCamForm.OnNewVideoFrame(Sender: TObject; AWidth, AHeight: Integer; ADataPtr: Pointer);
begin
  FVideoImage.GetBitmap(FVideoBitmap);
end;

procedure TXGWebCamForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  FVideoImage.VideoStop;
  FVideoBitmap.Free;
  FVideoImage.Free;

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

procedure TXGWebCamForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGWebCamForm.btnStartCaptureClick(Sender: TObject);
var
  SL: TStringList;
  sDevice: string;
begin
  with cbxCaptureDevice do
    sDevice := Trim(Properties.Items.Strings[ItemIndex]);

  if FActivated then
  begin
    FActivated := False;
    FVideoImage.VideoStop;
    FVideoImage.OnNewVideoFrame := nil;
    TAdvShapeButton(Sender).Text := '켭처 시작';
    btnSaveToBmp.Enabled := True;
  end else
  begin
    try
      SL := TStringList.Create;
      try
        FVideoImage.VideoStart(sDevice);
        FVideoImage.GetListOfSupportedVideoSizes(SL);
        cbxCaptureResList.Properties.Items := SL;
        cbxCaptureResList.ItemIndex := Pred(SL.Count);
        FVideoImage.SetResolutionByIndex(Pred(SL.Count));
        FVideoImage.GetBitmap(FVideoBitmap);
        FVideoImage.OnNewVideoFrame := OnNewVideoCanvas;
        TAdvShapeButton(Sender).Text := '켭처 중지';
        btnSaveToBmp.Enabled := False;
        FActivated := True;
      finally
        SL.Free;
      end;
    except
      on E: Exception do
      begin
        TAdvShapeButton(Sender).Text := '켭처 시작';
        FActivated := False;
      end;
    end;
  end;
end;

procedure TXGWebCamForm.cbxCaptureResListPropertiesEditValueChanged(Sender: TObject);
begin
  if FActivated then
    FVideoImage.SetResolutionByIndex(TcxComboBox(Sender).ItemIndex);
end;

procedure TXGWebCamForm.btnSaveToBmpClick(Sender: TObject);
var
  BMP: TBitmap;
  DC: HDC;
  Pt: TPoint;
begin
//  if FActivated then
//  begin
    FVideoImage.OnNewVideoFrame := OnNewVideoFrame;
    Pt.X := pbxPreview.Width div 4;
    Pt.Y := 0;
    Pt := pbxPreview.ClientToScreen(Pt);
    BMP := TBitmap.Create;
    try
      BMP.SetSize(pbxPreview.Width div 2, pbxPreview.Height);
      DC := GetDC(0);
      BitBlt(BMP.Canvas.Handle, 0, 0, BMP.Width, BMP.Height, DC, Pt.X, Pt.Y, SRCCOPY);
      ReleaseDC(0, DC);

      with TPluginMessage.Create(nil) do
      try
        Command := CPC_PHOTO_CAPTURED;
        AddParams(CPP_PHOTO_BITMAP, TObject(BMP));
        PluginMessageToID(FOwnerID);
      finally
        Free;
      end;
//      with TJPEGImage.Create do
//      try
//        CompressionQuality := 50;
//        Assign(BMP);
//        SaveToFile(sFileName);
//      finally
//        Free;
//      end;
    finally
      BMP.Free;
    end;

    ModalResult := mrOK;
//  end;
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