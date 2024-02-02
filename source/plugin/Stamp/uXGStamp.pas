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
unit uXGStamp;

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
  TXGStampForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    lblMessage: TLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    edtPhone: TEdit;
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
    FProductCd: String;
    FProductQty: Integer;
    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Graphics,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uLayeredForm, uXGMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGCouponCardForm }

constructor TXGStampForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerID := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGStampForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGStampForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGStampForm.PluginModuleActivate(Sender: TObject);
begin
  //btnOK.SetFocus;
  edtPhone.SetFocus;
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
end;

procedure TXGStampForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGStampForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    FProductCd := AMsg.ParamByString(CPP_PRODUCT_CD);
    FProductQty := AMsg.ParamByInteger(CPP_PRODUCT_QTY);
  end;
end;

procedure TXGStampForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGStampForm.btnOKClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if (Length(edtPhone.Text) <> 11) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '11자리로 입력되어야 합니다!', ['확인'], 5);
    Exit;
  end;

  try
    if ClientDM.PostStampSave(FProductCd, edtPhone.Text, IntToStr(FProductQty), sErrMsg) then
      ModalResult := mrOK
    else
    begin
      XGMsgBox(Self.Handle, mtError, '알림', '스탬프 적립을 완료하지 못했습니다!' + _CRLF + sErrMsg, ['확인'], 5);
      ModalResult := mrCancel;
    end;
  finally
  end;

end;

procedure TXGStampForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGStampForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGStampForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.