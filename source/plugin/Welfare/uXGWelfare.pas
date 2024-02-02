(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 복지카드
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGWelfare;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton, TransparentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCurrencyEdit, cxTextEdit,
  cxLabel, cyBaseSpeedButton, cyAdvSpeedButton, cxGroupBox;

{$I ..\..\common\XGPOS.inc}

type
  TXGWalfareForm = class(TPluginModule)
    imgBack: TImage;
    btnClose: TAdvShapeButton;
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    TransparentForm: TTransparentForm;
    lblNoticeOTC: TLabel;
    Label2: TLabel;
    lblWelfareCode: TcxLabel;
    cxLabel1: TLabel;
    cxLabel2: TLabel;
    lblRemainPoint: TcxLabel;
    imgIdCard: TImage;
    lblWelfareRate: TcxLabel;
    Label5: TLabel;
    gbxPayInfo: TcxGroupBox;
    lblInputAmtTitle: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Shape1: TShape;
    edtPayAmt: TcxCurrencyEdit;
    lblDiscountTotal: TcxLabel;
    lblChargeTotal: TcxLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblEmpName: TcxLabel;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FWelfareCode: string;
    FIsApproval: Boolean;
    FIsSaleMode: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics,
  uXGClientDM, uXGGlobal, uXGSaleManager, uXGCommonLib, uXGMsgBox;

{$R *.dfm}

{ TXGForm }

constructor TXGWalfareForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerId := -1;
  SetDoubleBuffered(Self, True);
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  imgBack.Visible := True;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGWalfareForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGWalfareForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.RFIDReader.OwnerId := Self.PluginID;
end;

procedure TXGWalfareForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TXGWalfareForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGWalfareForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId    := AMsg.ParamByInteger(CPP_OWNER_ID);
    FIsSaleMode := AMsg.ParamByBoolean(CPP_SALEMODE_YN);
    FIsApproval := AMsg.ParamByBoolean(CPP_APPROVAL_YN);

    if FIsSaleMode then
    begin
      if FIsApproval then
      begin
        lblFormTitle.Caption := '복지카드 포인트 결제';
        lblInputAmtTitle.Caption := '최종 결제 금액';
        lblChargeTotal.Caption := FormatFloat('#,##0', SaleManager.ReceiptInfo.ChargeTotal);
        lblDiscountTotal.Caption := FormatFloat('#,##0', 0);
      end else
      begin
        lblFormTitle.Caption := '복지카드 포인트 결제 취소';
        lblInputAmtTitle.Caption := '결제 취소 금액';
        lblChargeTotal.Caption := FormatFloat('#,##0', SaleManager.ReceiptInfo.ChargeTotal);
        lblDiscountTotal.Caption := FormatFloat('#,##0', 0);
      end;
      lblRemainPoint.Caption := FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint);
    end else
    begin
      lblFormTitle.Caption := '복지카드 등록';
      gbxPayInfo.Enabled := False;

//      lblChargeAmtTitle.Enabled := False;
//      lblChargeAmt.Enabled := False;
//      lblRemainPointTitle.Enabled := False;
//      lblRemainPoint.Enabled := False;
    end;
  end;

  if (AMsg.Command = CPC_SEND_WELFARE_CODE) then
  begin
    FWelfareCode := AMsg.ParamByString(CPP_WELFARE_CODE);
    lblWelfareCode.Caption := FWelfareCode;
  end;
end;

procedure TXGWalfareForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGWalfareForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGWalfareForm.btnCancelClick(Sender: TObject);
begin
//
end;

procedure TXGWalfareForm.btnOKClick(Sender: TObject);
begin
  try
    if (FWelfareCode = '') then
      raise Exception.Create('복지카드가 인식되지 않았습니다!');

    if FIsSaleMode then
    begin
      if FIsApproval then
      begin
        if (SaleManager.ReceiptInfo.ChargeTotal > SaleManager.MemberInfo.WelfarePoint) then
          raise Exception.Create('잔액이 부족하여 결제를 진행할 수 없습니다!');
      end;

      SaleManager.MemberInfo.WelfareCode := FWelfareCode;
      SaleManager.ReceiptInfo.CashPayAmt := SaleManager.ReceiptInfo.ChargeTotal;
    end else
    begin
      with TPluginMessage.Create(nil) do
      try
        Command := CPC_SEND_WELFARE_CODE;
        AddParams(CPP_WELFARE_CODE, FWelfareCode);
        PluginMessageToID(FOwnerId);
      finally
        Free;
      end;
    end;

    ModalResult := mrOK;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtInformation, '알림', E.Message, ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGWalfareForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.