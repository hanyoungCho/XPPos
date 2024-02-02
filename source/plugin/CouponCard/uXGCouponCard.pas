(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : (구)쿠폰회원 카드 조회
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGCouponCard;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGCouponCardForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    lblMessage: TLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    imgIcon: TImage;
    lblScanResult: TLabel;
    imcIcons: TcxImageCollection;
    imgMSCard: TcxImageCollectionItem;
    imgQRCode: TcxImageCollectionItem;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FScanMode: Integer;
    FReadBuffer: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoSuccess;
    procedure SetReadBuffer(const AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property ReadBuffer: string read FReadBuffer write SetReadBuffer;
  end;

implementation

uses
  { Native }
  Graphics,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGCouponCardForm }

constructor TXGCouponCardForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerID := -1;
  ReadBuffer := '';
  FScanMode := CMC_MEMBER_MSCARD;
  SetDoubleBuffered(Self, True);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  imgIcon.Picture.Assign(imgMSCard.Picture);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGCouponCardForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGCouponCardForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGCouponCardForm.PluginModuleActivate(Sender: TObject);
begin
  btnOK.SetFocus;
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
end;

procedure TXGCouponCardForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGCouponCardForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    FScanMode := AMsg.ParamByInteger(CPP_SCAN_MODE);
    case FScanMode of
      CMC_MEMBER_MSCARD:
        begin
          lblFormTitle.Caption := '(구)회원 MS카드 조회';
          lblMessage.Caption := 'MSR 또는 바코드 스캐너에' + _CRLF + '회원카드를 인식시켜 주십시오.';
          imgIcon.Picture.Assign(imgMSCard.Picture);
        end;
      CMC_MEMBER_QRCODE:
        begin
          lblFormTitle.Caption := '모바일 예약 QR코드 체크인';
          lblMessage.Caption := '바코드 스캐너에' + _CRLF + '회원 QR코드를 인식시켜 주십시오.';
          imgIcon.Picture.Assign(imgQRCode.Picture);
        end;
    end;
  end;

  if (AMsg.Command = CPC_SEND_SCAN_DATA) and
     (FScanMode = CMC_MEMBER_MSCARD) then
    ReadBuffer := AMsg.ParamByString(CPP_BARCODE);

  if (AMsg.Command = CPC_SEND_QRCODE_MEMBER) and
     (FScanMode = CMC_MEMBER_QRCODE) then
    ReadBuffer := AMsg.ParamByString(CPP_BARCODE);
end;

procedure TXGCouponCardForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    48..57: //0..9
      begin
        if (Length(ReadBuffer) >= 10) then
          ReadBuffer := '';
        ReadBuffer := ReadBuffer + Char(Key);
      end;

    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGCouponCardForm.SetReadBuffer(const AValue: string);
begin
  FReadBuffer := AValue;
  lblScanResult.Caption := FReadBuffer;
end;

procedure TXGCouponCardForm.btnOKClick(Sender: TObject);
begin
  if (Length(ReadBuffer) = 10) then
    DoSuccess;
end;

procedure TXGCouponCardForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGCouponCardForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGCouponCardForm.DoSuccess;
begin
  with TPluginMessage.Create(nil) do
  try
    case FScanMode of
      CMC_MEMBER_MSCARD:
        begin
          Command := CPC_SEND_MSCARD_MEMBER;
          AddParams(CPP_QRCODE, CQT_HEAD_MEMBER + ReadBuffer);
        end;
      CMC_MEMBER_QRCODE:
        begin
          Command := CPC_SEND_QRCODE_CHECKIN;
          AddParams(CPP_QRCODE, ReadBuffer);
        end;
    end;
    PluginMessageToID(FOwnerId);
  finally
    Free;
  end;
  ModalResult := mrOK;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGCouponCardForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.