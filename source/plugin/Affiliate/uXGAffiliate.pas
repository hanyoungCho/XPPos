(*******************************************************************************
  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 제휴사 멤버십 연동
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2020-04-06   Initial Release.
  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.
*******************************************************************************)
unit uXGAffiliate;
interface
uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Vcl.Imaging.pngimage,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxCheckBox,
  { TMS }
  AdvShapeButton;
{$I ..\..\common\XGPOS.inc}
type
  TXGAffiliateForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    lblMessage: TLabel;
    imgWelbeingClub: TImage;
    imgRefreshClub: TImage;
    imgIKozen: TImage;
    lblScanResult: TLabel;
    btnCancel: TAdvShapeButton;
    ckbWelbeingClub: TcxCheckBox;
    ckbRefreshClub: TcxCheckBox;
    ckbIKozen: TcxCheckBox;
    btnOK: TAdvShapeButton;
    ckbRefreshGolf: TcxCheckBox;
    btnClose: TAdvShapeButton;
    imgSmartix: TImage;
    ckbSmartix: TcxCheckBox;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ckbWelbeingClubPropertiesChange(Sender: TObject);
    procedure ckbRefreshClubPropertiesChange(Sender: TObject);
    procedure ckbIKozenPropertiesChange(Sender: TObject);
    procedure ckbRefreshGolfPropertiesChange(Sender: TObject);
    procedure ckbSmartixPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBarcodeOwnerId: Integer;
    FIsApproval: Boolean;
    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoApplyCoupon;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;
implementation
uses
  Graphics,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGMsgBox, uLayeredForm;
var
  LF: TLayeredForm;
{$R *.dfm}
{ TXGAffiliateForm }
constructor TXGAffiliateForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
  FOwnerId := -1;
  FIsApproval := True;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  ckbWelbeingClub.Enabled := False;
  ckbRefreshClub.Enabled := False;
  ckbIKozen.Enabled := False;
  if FIsApproval then
  begin
    ckbWelbeingClub.Enabled := Global.WelbeingClub.Enabled;
    ckbRefreshClub.Enabled := Global.RefreshClub.Enabled;
    ckbIKozen.Enabled := Global.IKozen.Enabled;
    ckbSmartix.Enabled := Global.Smartix.Enabled;
  end;
  while True do
  begin
    if Global.WelbeingClub.Enabled then
    begin
      ckbWelbeingClub.Checked := True;
      Break;
    end;
    if Global.RefreshClub.Enabled then
    begin
      ckbRefreshClub.Checked := True;
      Break;
    end;
    if Global.IKozen.Enabled then
      ckbIKozen.Checked := True;
    if Global.Smartix.Enabled then
      ckbSmartix.Checked := True;
    Break; //Must
  end;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;
destructor TXGAffiliateForm.Destroy;
begin
  inherited Destroy;
end;
procedure TXGAffiliateForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;
procedure TXGAffiliateForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;
procedure TXGAffiliateForm.ProcessMessages(AMsg: TPluginMessage);
var
  sReadData, sMemberCode, sPartnerCode, sStoreCode, sExecId, sExecTime, sErrMsg: string;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FIsApproval := AMsg.ParamByBoolean(CPP_APPROVAL_YN);
    sPartnerCode := AMsg.ParamByString(CPP_AFFILIATE_CODE);
    if not sPartnerCode.IsEmpty then
      AffiliateRec.PartnerCode := sPartnerCode;
    Self.Caption := '제휴사 회원 결제 ' + IIF(FIsApproval, '승인', '취소');
  end;
  if (AMsg.Command = CPC_SEND_SCAN_DATA) then
  begin
    sReadData := AMsg.ParamByString(CPP_BARCODE);
    AffiliateRec.ReadData := sReadData;
    AffiliateRec.MemberCode := '';
    AffiliateRec.IKozenExecId := '';
    AffiliateRec.IKozenExecTime := '';
    sPartnerCode := '';
    sMemberCode := '';
    sExecId := '';
    if (AffiliateRec.PartnerCode = GCD_IKOZEN_CODE) then
    begin
      sErrMsg := '';
      if not ClientDM.ExtractIKozenQRCode(sReadData, sMemberCode, sStoreCode, sExecId, sExecTime, sErrMsg) then
      begin
        XGMsgBox(Self.Handle, mtError, '알림', sErrMsg, ['확인'], 5);
        Exit;
      end;
      if (Global.IKozen.StoreCode <> sStoreCode) then
      begin
        XGMsgBox(Self.Handle, mtWarning, '알림', '사용할 수 없는 시설코드 입니다!', ['확인'], 5);
        Exit;
      end;
      AffiliateRec.MemberCode := sMemberCode;
      AffiliateRec.IKozenExecId := sExecId;
      AffiliateRec.IKozenExecTime := sExecTime;
    end
    else
      AffiliateRec.MemberCode := sReadData;
    lblScanResult.Caption := AffiliateRec.MemberCode;
    DoApplyCoupon;
  end;
end;
procedure TXGAffiliateForm.PluginModuleActivate(Sender: TObject);
begin
  FBarcodeOwnerId := Global.DeviceConfig.BarcodeScanner.OwnerId;
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
end;
procedure TXGAffiliateForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := FBarcodeOwnerId;
end;
procedure TXGAffiliateForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;
procedure TXGAffiliateForm.btnOKClick(Sender: TObject);
begin
  DoApplyCoupon;
end;
procedure TXGAffiliateForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
procedure TXGAffiliateForm.ckbWelbeingClubPropertiesChange(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
  begin
    AffiliateRec.PartnerCode := Global.WelbeingClub.PartnerCode;
    ckbRefreshClub.Checked := False;
    ckbRefreshGolf.Checked := False;
    ckbIKozen.Checked := False;
    ckbSmartix.Checked := False;
  end;
end;
procedure TXGAffiliateForm.ckbRefreshClubPropertiesChange(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
  begin
    AffiliateRec.PartnerCode := Global.RefreshClub.PartnerCode;
    ckbWelbeingClub.Checked := False;
    ckbRefreshGolf.Checked := False;
    ckbIKozen.Checked := False;
    ckbSmartix.Checked := False;
  end;
end;
procedure TXGAffiliateForm.ckbRefreshGolfPropertiesChange(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
  begin
    AffiliateRec.PartnerCode := Global.RefreshGolf.PartnerCode;
    ckbWelbeingClub.Checked := False;
    ckbRefreshClub.Checked := False;
    ckbIKozen.Checked := False;
    ckbSmartix.Checked := False;
  end;
end;
procedure TXGAffiliateForm.ckbIKozenPropertiesChange(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
  begin
    AffiliateRec.PartnerCode := Global.IKozen.PartnerCode;
    ckbWelbeingClub.Checked := False;
    ckbRefreshClub.Checked := False;
    ckbRefreshGolf.Checked := False;
    ckbSmartix.Checked := False;
  end;
end;
procedure TXGAffiliateForm.ckbSmartixPropertiesChange(Sender: TObject);
begin
  if TcxCheckBox(Sender).Checked then
  begin
    //AffiliateRec.PartnerCode := Global.IKozen.PartnerCode;
    ckbWelbeingClub.Checked := False;
    ckbRefreshClub.Checked := False;
    ckbRefreshGolf.Checked := False;
    ckbIKozen.Checked := False;
  end;
end;

procedure TXGAffiliateForm.DoApplyCoupon;
begin
  if (not AffiliateRec.PartnerCode.IsEmpty) and
     (not AffiliateRec.MemberCode.IsEmpty) then
    ModalResult := mrOK;
end;
///////////////////////////////////////////////////////////////////////////////
function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGAffiliateForm.Create(Application, AMsg);
end;
exports
  OpenPlugin;
end.