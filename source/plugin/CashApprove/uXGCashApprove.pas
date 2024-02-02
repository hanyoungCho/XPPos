(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 현금 결제
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGCashApprove;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox,
  cxCurrencyEdit, cxTextEdit, cxLabel,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

const
  LCN_INPUT_CASH_AMT    = 0;
  LCN_INPUT_IDENT_NO    = 1;
  LCN_INPUT_APPROVE_NO  = 2;

type
  TXGCashApproveForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panInput: TPanel;
    panNumPad: TPanel;
    panBody: TPanel;
    cxLabel1: TLabel;
    lblChargeTotal: TcxLabel;
    Label2: TLabel;
    lblUnpaidTotal: TcxLabel;
    Label3: TLabel;
    lblChangeTotal: TcxLabel;
    Label4: TLabel;
    edtIdentNo: TcxTextEdit;
    edtApproveNo: TcxTextEdit;
    lblInputAmtTitle: TLabel;
    edtCashPayAmt: TcxCurrencyEdit;
    Label5: TLabel;
    Shape1: TShape;
    btnIndividual: TcyAdvSpeedButton;
    btnBiz: TcyAdvSpeedButton;
    lblOrgApproveDate: TLabel;
    lblOrgApproveNo: TLabel;
    btnCashComplete: TcyAdvSpeedButton;
    btnCheckCheque: TcyAdvSpeedButton;
    btnCashReceipt: TcyAdvSpeedButton;
    ckbManualApprove: TcxCheckBox;
    ckbSelfCashIssued: TcxCheckBox;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCashCompleteClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure edtCashPayAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCashReceiptClick(Sender: TObject);
    procedure edtCashPayAmtEnter(Sender: TObject);
    procedure edtCashPayAmtPropertiesChange(Sender: TObject);
    procedure btnCheckChequeClick(Sender: TObject);
    procedure OnTextEditEnter(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ckbSelfCashIssuedPropertiesChange(Sender: TObject);
    procedure ckbManualApprovePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIsApproval: Boolean;
    FIsSaleMode: Boolean;
    FInputAmt: Integer;
    FManualApprove: Boolean;
    FReceiptNo: string;
    FApprovalNo: string;
    FApprovalDate: string;
    FApprovalAmt: Integer;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoCashApprove;
    procedure DoCashComplete;
    procedure SetInputAmt(const AValue: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property InputAmt: Integer read FInputAmt write SetInputAmt default 0;
  end;

implementation

uses
  { Native }
  Graphics, Math,
  { VAN }
  uVanDaemonModule, uPaycoNewModule,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGCashApproveForm }

constructor TXGCashApproveForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FReceiptNo := '';
  FApprovalNo := '';
  FApprovalDate := '';
  FApprovalAmt := 0;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnIndividual.Down := True;
  ckbSelfCashIssued.Checked := Global.SelfCashReceiptDefault;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

destructor TXGCashApproveForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGCashApproveForm.PluginModuleActivate(Sender: TObject);
begin
  with edtCashPayAmt do
  begin
    SelStart := Length(Text) + 1;
    if FIsApproval then
      SetFocus;
    end;
end;

procedure TXGCashApproveForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGCashApproveForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGCashApproveForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FIsApproval := AMsg.ParamByBoolean(CPP_APPROVAL_YN);
    FIsSaleMode := AMsg.ParamByBoolean(CPP_SALEMODE_YN);
    FReceiptNo := AMsg.ParamByString(CPP_RECEIPT_NO);
    FApprovalNo := AMsg.ParamByString(CPP_APPROVAL_NO);
    FApprovalDate := AMsg.ParamByString(CPP_APPROVAL_DATE);
    FApprovalAmt := AMsg.ParamByInteger(CPP_APPROVAL_AMT);

    lblFormTitle.Caption := '현금 결제 ' + IIF(FIsApproval, '승인', '취소');
    btnCashComplete.Caption := IIF(FIsApproval, '현금 결제', '결제 취소');
    InputAmt := FApprovalAmt;

    if FIsApproval then
      edtCashPayAmt.Value := FApprovalAmt
    else
    begin
      ckbSelfCashIssued.Enabled := False;
      ckbManualApprove.Enabled := False;
      btnCheckCheque.Enabled := False;
      edtIdentNo.Enabled := False;
      edtApproveNo.Enabled := False;
      edtCashPayAmt.Enabled := False;
      edtCashPayAmt.Value := InputAmt;

      lblInputAmtTitle.Caption := '승인 취소 금액';
      lblOrgApproveDate.Caption := '원거래일자 : ' + FApprovalDate;
      lblOrgApproveDate.Visible := True;
      lblOrgApproveNo.Caption := '원승인번호 : ' + FApprovalNo;
      lblOrgApproveNo.Visible := True;
      btnCashReceipt.Caption := '현금영수증 승인 취소 요청';
      btnCashComplete.Enabled := False;
      panNumpad.Enabled := False;
    end;
  end;

  if (AMsg.Command = CPC_SEND_CHEQUE_NO) then
  begin
    edtIdentNo.Text := AMsg.ParamByString(CPP_CHEQUE_NO);
    edtCashPayAmt.Value := AMsg.ParamByInteger(CPP_CHEQUE_AMT);
  end;
end;

procedure TXGCashApproveForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      if ckbSelfCashIssued.Checked then
        btnCashReceipt.Click
      else
        btnCashComplete.Click;
    VK_F11:
      ckbSelfCashIssued.Checked := (not ckbSelfCashIssued.Checked);
  end;
end;

procedure TXGCashApproveForm.SetInputAmt(const AValue: Integer);
var
  nUnpaidAmt, nChangeAmt: Integer;
begin
  FInputAmt := AValue;
  with SaleManager.ReceiptInfo do
    if FIsApproval then
    begin
      if (FInputAmt > UnpaidTotal) then
      begin
        nUnpaidAmt := 0;
        nChangeAmt := (FInputAmt - UnpaidTotal);
      end
      else
      begin
        nUnpaidAmt := (UnpaidTotal - FInputAmt);
        nChangeAmt := 0;
      end;

      lblChargeTotal.Caption  := FormatCurr('#,##0', ChargeTotal); //받을금액
      lblUnpaidTotal.Caption  := IIF(nUnpaidAmt > 0, FormatCurr('#,##0', nUnPaidAmt), '0'); //미결제액
      lblChangeTotal.Caption  := IIF(nChangeAmt > 0, FormatCurr('#,##0', nChangeAmt), '0'); //거스름돈
    end;
end;

procedure TXGCashApproveForm.btnCheckChequeClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if FWorking then
    Exit;

  FWorking := True;
  PM := TPluginMessage.Create(nil);
  with TcyAdvSpeedButton(Sender) do
  try
    Enabled := False;
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    if (PluginManager.OpenModal('XGChequeApprove' + CPL_EXTENSION, PM) = mrOK) then
    begin

    end;
  finally
    FreeAndNil(PM);
    Enabled := True;
    FWorking := False;
  end;
end;

procedure TXGCashApproveForm.ckbManualApprovePropertiesChange(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    FManualApprove := Checked;
    edtApproveNo.Enabled := Checked;
    btnCashReceipt.Enabled := (not Checked);
    if Checked then
      ckbSelfCashIssued.Checked := False;
  end;
end;

procedure TXGCashApproveForm.ckbSelfCashIssuedPropertiesChange(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    btnCashComplete.Enabled := (not Checked);
    ckbManualApprove.Enabled := (not Checked);
    if Checked then
    begin
      edtIdentNo.Clear;
      edtApproveNo.Clear;
    end;
  end;
end;

procedure TXGCashApproveForm.OnTextEditEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGCashApproveForm.edtCashPayAmtEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGCashApproveForm.edtCashPayAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      TcxCurrencyEdit(Sender).Value := 0;
  end;
end;

procedure TXGCashApproveForm.edtCashPayAmtPropertiesChange(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
  begin
    InputAmt := Trunc(Value);
    Text := FormatCurr('#,##0', InputAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TXGCashApproveForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGCashApproveForm.btnCashReceiptClick(Sender: TObject);
begin
  DoCashApprove;
end;

procedure TXGCashApproveForm.btnCashCompleteClick(Sender: TObject);
begin
  DoCashComplete;
end;

procedure TXGCashApproveForm.DoCashApprove;
var
  PM: TPluginMessage;
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  nVatAmt: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  btnCashReceipt.Enabled := False;
  edtIdentNo.Text := StringReplace(edtIdentNo.Text, edtIdentNo.Properties.Nullstring, '', [rfReplaceAll]);
  edtApproveNo.Text := StringReplace(edtApproveNo.Text, edtApproveNo.Properties.Nullstring, '', [rfReplaceAll]);

  try
    try
      if (InputAmt <= 0) then
        raise Exception.Create('결제 금액이 입력되지 않았습니다!');
      if (FIsApproval and (InputAmt > SaleManager.ReceiptInfo.ChargeTotal)) then
        raise Exception.Create('받을 금액보다 결제할 금액이 더 많습니다!');

      nVatAmt := (InputAmt - Trunc(InputAmt / 1.1));
      SI.Approval     := FIsApproval;
      SI.SaleAmt      := InputAmt;
      SI.FreeAmt      := 0;
      SI.SvcAmt       := 0;
      SI.VatAmt       := nVatAmt;
      SI.OrgAgreeNo   := FApprovalNo;
      SI.OrgAgreeDate := FApprovalDate;
      SI.TerminalID   := SaleManager.StoreInfo.CreditTID;
      SI.BizNo        := SaleManager.StoreInfo.BizNo;
      SI.Person       := IIF(btnBiz.Down, 2, 1); //1:개인, 2:사업자
      SI.CardNo       := IIF(ckbSelfCashIssued.Checked, '0100001234',  edtIdentNo.Text); //현금영수증 자진발급 여부 결정
      SI.KeyInput     := (SI.CardNo <> '');

      // 취소사유코드 (1:거래취소, 2:오류발급, 3:기타)
      if not FIsApproval then
        SI.CancelReason := 1;

      RI := VanModule.CallCash(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg)
      else
      begin
        if FIsApproval then
        begin
          if FIsSaleMode then
          begin
            SaleManager.PayLog(FIsApproval, FManualApprove, CPM_CASH, RI.CardNo, RI.AgreeNo, InputAmt);
            SaleManager.ReceiptInfo.CashPayAmt := InputAmt;
          end;

          ClientDM.UpdatePayment(
            Global.TableInfo.ActiveTableNo,
            FIsApproval,
            FIsSaleMode,
            False, //ADeleteExists
            CPM_CASH, //APayMethod
            SaleManager.StoreInfo.VANCode, //AVan
            SaleManager.StoreInfo.CreditTID, //ATid
            CRC_YES, //AInternetYN
            RI.CardNo, //ACreditCardNo
            RI.AgreeNo, //AApproveNo
            '', //AOrgApproveNo,
            '', //AOrgApproveDate,
            '', //ATradeNo
            Global.CurrentDate, //ATradeDate
            '', //AIssuerCode
            '', //AISsuerName
            '', //ABuyerDiv
            '', //ABuyerCode
            '', //ABuyerName
            0, //AInstMonth
            InputAmt, //AApproveAmt
            nVatAmt, //AVat
            0, //AServiceAmt
            0, //카드사 프로모션 코드
            0, //카드사 프로모션 할인 금액
            ''); //카드사 프로모션 구분(P: 카드사 즉시할인 등)
        end else
        begin
          if FIsSaleMode then
            SaleManager.ReceiptInfo.CashPayAmt := (SaleManager.ReceiptInfo.CashPayAmt - InputAmt);

          SaleManager.PayLog(FIsApproval, FManualApprove, CPM_CASH, RI.CardNo, RI.AgreeNo, InputAmt, FReceiptNo);
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_CASH_CANCEL;
            PM.AddParams(CPP_APPROVAL_NO, RI.AgreeNo);
            PM.PluginMessageToID(FOwnerId);
          finally
            FreeAndNil(PM);
          end;
        end;

        XGMsgBox(Self.Handle, mtInformation, '알림',
          '현금영수증이 정상 ' + IIF(FIsApproval, '발급', '취소') + ' 되었습니다!', ['확인'], 5);
        ModalResult := mrOK;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('DoCashApprove(%s).Exception = %s', [BoolToStr(FIsApproval), E.Message]));
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
      end;
    end;
  finally
    btnCashReceipt.Enabled := True;
    if (edtIdentNo.Text = '') then
      edtIdentNo.Clear;
    if (edtApproveNo.Text = '') then
      edtApproveNo.Clear;
    FWorking := False;
  end;
end;

procedure TXGCashApproveForm.DoCashComplete;
var
  nVatAmt: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  btnCashComplete.Enabled := False;
  edtIdentNo.Text := StringReplace(edtIdentNo.Text, edtIdentNo.Properties.Nullstring, '', [rfReplaceAll]);
  edtApproveNo.Text := StringReplace(edtApproveNo.Text, edtApproveNo.Properties.Nullstring, '', [rfReplaceAll]);

  try
    try
      if (InputAmt <= 0) then
        raise Exception.Create('결제금액이 입력되지 않았습니다!');
      if (FIsApproval and (InputAmt > SaleManager.ReceiptInfo.ChargeTotal)) then
        raise Exception.Create('받을 금액보다 결제할 금액이 더 많습니다!');
      if FManualApprove and
         ((edtIdentNo.Text = '') or (edtApproveNo.Text = '')) then
        raise Exception.Create('현금영수증 수기등록은 식별번호와 승인번호가 입력되어야 합니다!');

      SaleManager.PayLog(FIsApproval, FManualApprove, CPM_CASH, '', '', InputAmt);
      SaleManager.ReceiptInfo.CashPayAmt := InputAmt;
      nVatAmt := (InputAmt - Trunc(InputAmt / 1.1));
      ClientDM.UpdatePayment(
        Global.TableInfo.ActiveTableNo,
        FIsApproval,
        FIsSaleMode,
        True, //ADeleteExists
        CPM_CASH, //APayMethod
        '', //AVan
        '', //ATid
        IIF(FManualApprove, CRC_NO, CRC_YES), //AInternetYN
        '', //ACreditCardNo
        '', //AApproveNo
        '', //AOrgApproveNo,
        '', //AOrgApproveDate,
        '', //ATradeNo
        Global.CurrentDate, //ATradeDate
        '', //AIssuerCode
        '', //AISsuerName
        '', //ABuyerDiv
        '', //ABuyerCode
        '', //ABuyerName
        0, //AInstMonth
        InputAmt, //AApproveAmt
        nVatAmt, //AVat
        0, //AServiceAmt
        0, //카드사 프로모션 코드
        0, //카드사 프로모션 할인 금액
        ''); //카드사 프로모션 구분(P: 카드사 즉시할인 등)

      ModalResult := mrOK;
    except
      on E: Exception do
      begin
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
      end;
    end;
  finally
    btnCashComplete.Enabled := True;
    if (edtIdentNo.Text = '') then
      edtIdentNo.Clear;
    if (edtApproveNo.Text = '') then
      edtApproveNo.Clear;
    FWorking := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGCashApproveForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.