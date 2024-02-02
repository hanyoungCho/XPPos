unit uXGCardApprove;

(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 신용카드 결제
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, dxmdaset,
  cxCheckBox, cxTextEdit, cxLabel, cxCurrencyEdit,
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
  TXGCardApproveForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    panInput: TPanel;
    panNumPad: TPanel;
    Shape1: TShape;
    lblInputAmtTitle: TLabel;
    edtCardPayAmt: TcxCurrencyEdit;
    Label3: TLabel;
    lblUnpaidTotal: TcxLabel;
    lblChargeTotal: TcxLabel;
    cxLabel1: TLabel;
    Label1: TLabel;
    edtCardNo: TcxTextEdit;
    edtApproveNo: TcxTextEdit;
    Label4: TLabel;
    Label5: TLabel;
    lblOrgApproveDate: TLabel;
    lblOrgApproveNo: TLabel;
    edtInstMonth: TcxTextEdit;
    btnApprove: TcyAdvSpeedButton;
    ckbUseAppCard: TcxCheckBox;
    Label2: TLabel;
    ckbImmediateDiscount: TcxCheckBox;
    MDCardList: TdxMemData;
    MDCardListCode: TStringField;
    MDCardListAcquirer: TStringField;
    MDCardListIssuer: TStringField;
    DSCardList: TDataSource;
    cbxCardList: TcxLookupComboBox;
    ckbManualApprove: TcxCheckBox;
    btnClose: TAdvShapeButton;
    Label7: TLabel;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnApproveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure edtCardPayAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtInstMonthPropertiesChange(Sender: TObject);
    procedure OnCurrencyEditEnter(Sender: TObject);
    procedure edtInstMonthKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCardPayAmtPropertiesChange(Sender: TObject);
    procedure OnTextEditEnter(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ckbImmediateDCPropertiesChange(Sender: TObject);
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
    FAppCardOTC: string;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoCardApprove;
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
  Graphics, Math, DateUtils,
  { VAN }
  uVanDaemonModule,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGCardApproveForm }

constructor TXGCardApproveForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FAppCardOTC := '';
  FReceiptNo := '';
  FApprovalAmt := 0;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  with MDCardList do
  begin
    Active := True;
    AppendRecord([1, '0602', '광주카드', '비씨카드']);
    AppendRecord([2, '0200', '국민카드', '국민카드']);
    AppendRecord([3, '0201', '농협카드', '농협카드']);
    AppendRecord([4, '0902', '롯데카드', '롯데카드']);
    AppendRecord([5, '0900', '롯데아멕스', '롯데카드']);
    AppendRecord([6, '0100', '비씨카드', '비씨카드']);
    AppendRecord([7, '0400', '삼성카드', '삼성카드']);
    AppendRecord([8, '0202', '수협카드', '비씨카드']);
    AppendRecord([9, '0500', '신한카드', '신한카드']);
    AppendRecord([10, '0206', '씨티카드', '비씨카드']);
    AppendRecord([11, '0603', '전북카드', '비씨카드']);
    AppendRecord([12, '0301', '제주카드', '비씨카드']);
    AppendRecord([13, '0300', '하나카드', '하나카드']);
    AppendRecord([14, '0207', '한미카드', '비씨카드']);
    AppendRecord([15, '0800', '현대카드', '현대카드']);
    AppendRecord([16, '0801', '해외다이너스', '현대카드']);
    AppendRecord([17, '0901', '해외아멕스', '해외아멕스']);
  end;

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

destructor TXGCardApproveForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGCardApproveForm.PluginModuleActivate(Sender: TObject);
begin
  with edtCardPayAmt do
  begin
    SelStart := Length(Text) + 1;
    if FIsApproval then
      SetFocus;
  end;
end;

procedure TXGCardApproveForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGCardApproveForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGCardApproveForm.ProcessMessages(AMsg: TPluginMessage);
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

    lblFormTitle.Caption := '신용카드 '+ IIF(FIsApproval, '결제', '승인 취소');
    InputAmt := FApprovalAmt;

    if FIsApproval then
    begin
      edtCardPayAmt.Value := FApprovalAmt;
      ckbImmediateDiscount.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX); //프런트POS만 즉시할인 가능
      ckbUseAppCard.Enabled := False;
    end
    else
    begin
      ckbManualApprove.Enabled := False;
      edtCardNo.Enabled := False;
      edtApproveNo.Enabled := False;
      edtCardPayAmt.Enabled := False;
      edtCardPayAmt.Value := InputAmt;
      edtInstMonth.Enabled := False;
      ckbImmediateDiscount.Enabled := False;
      ckbUseAppCard.Enabled := True;
      lblInputAmtTitle.Caption := '승인 취소 금액';
      lblOrgApproveDate.Caption := '원승인번호 : ' + FApprovalNo;
      lblOrgApproveDate.Visible := True;
      lblOrgApproveNo.Caption := '원거래일자 : ' + FApprovalDate;
      lblOrgApproveNo.Visible := True;
      btnApprove.Caption := '승인 취소 요청';
      panNumpad.Enabled := False;
    end;
  end;

  if (AMsg.Command = CPC_SEND_SCAN_DATA) then
  begin
    FAppCardOTC := AMsg.ParamByString(CPP_BARCODE);
    edtCardNo.Text := Copy(FAppCardOTC, 1, 6);
  end;
end;

procedure TXGCardApproveForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnApprove.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGCardApproveForm.SetInputAmt(const AValue: Integer);
var
  nUnpaidAmt: Integer;
begin
  FInputAmt := AValue;
  with SaleManager.ReceiptInfo do
  begin
    if (FInputAmt > UnpaidTotal) then
      nUnpaidAmt := 0
    else
      nUnpaidAmt := (UnpaidTotal - FInputAmt);

    lblChargeTotal.Caption  := FormatCurr('#,##0', ChargeTotal); //받을금액
    lblUnpaidTotal.Caption  := IIF(nUnpaidAmt > 0, FormatCurr('#,##0', nUnPaidAmt), '0'); //미결제액
  end;
end;

procedure TXGCardApproveForm.OnCurrencyEditEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGCardApproveForm.edtCardPayAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: TcxCurrencyEdit(Sender).Value := 0; //CL
  end;
end;

procedure TXGCardApproveForm.edtCardPayAmtPropertiesChange(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
  begin
    InputAmt := Trunc(Value);
    Text := FormatCurr('#,##0', InputAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TXGCardApproveForm.edtInstMonthKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      TcxCurrencyEdit(Sender).Value := 0;
  end;
end;

procedure TXGCardApproveForm.edtInstMonthPropertiesChange(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
  begin
    Text := IntToStr(StrToIntDef(Text, 0));
    SelStart := Length(Text) + 1;
  end;
end;

procedure TXGCardApproveForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGCardApproveForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGCardApproveForm.ckbImmediateDCPropertiesChange(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    ckbUseAppCard.Enabled := Checked;
    ckbUseAppCard.Checked := False;
  end;
end;

procedure TXGCardApproveForm.ckbManualApprovePropertiesChange(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    FManualApprove := Checked;
    edtCardNo.Enabled := Checked;
    cbxCardList.Enabled := Checked;
    edtApproveNo.Enabled := Checked;
    btnApprove.Caption := IIF(Checked, '결제 등록', '승인 요청');
    ckbImmediateDiscount.Enabled := (not Checked);
    ckbUseAppCard.Enabled := (not Checked);
    if Checked then
    begin
      ckbImmediateDiscount.Checked := False;
      ckbUseAppCard.Checked := False;
      edtCardNo.SetFocus;
    end;
  end;
end;

procedure TXGCardApproveForm.btnApproveClick(Sender: TObject);
begin
  DoCardApprove;
end;

procedure TXGCardApproveForm.OnTextEditEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGCardApproveForm.DoCardApprove;
var
  PM: TPluginMessage;
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  nInputAmt, nVatAmt, nPromoSeq, nPromoDcAmt, nOldOwnerId: Integer;
  sCardBinNo, sTeeBoxProdDiv, sPromoDiv, sErrMsg: string;
  bResult: Boolean;
begin
  if FWorking then
    Exit;

  FWorking := True;
  btnApprove.Enabled := False;
  ckbManualApprove.Enabled := False;
  edtCardNo.Text := StringReplace(edtCardNo.Text, edtCardNo.Properties.Nullstring, '', [rfReplaceAll]);
  edtApproveNo.Text := StringReplace(edtApproveNo.Text, edtApproveNo.Properties.Nullstring, '', [rfReplaceAll]);

  try
    FAppCardOTC := '';
    nInputAmt   := InputAmt;
    nPromoSeq   := 0;
    nPromoDcAmt := 0;
    sPromoDiv   := '';
    sErrMsg     := '';
    sTeeBoxProdDiv := '';

    try
      FManualApprove := ckbManualApprove.Checked;
      //즉시 할인
      if ckbImmediateDiscount.Checked then
      begin
        if (ClientDM.QRSaleItem.RecordCount = 0) or
           (ClientDM.QRSaleItem.RecordCount > 1) then
          raise Exception.Create('즉시할인 적용은 주문상품이 1건일 경우에만 가능합니다!');

        sTeeBoxProdDiv := ClientDM.QRSaleItem.FieldByName('teebox_prod_div').AsString;
        if sTeeBoxProdDiv.IsEmpty then
          raise Exception.Create('즉시할인을 적용할 타석상품이 선택되지 않았습니다!');
      end;
      //앱카드(OTC) 결제
      if ckbUseAppCard.Checked then
      begin
        with Global.DeviceConfig.BarcodeScanner do
        if (not Enabled) or
           (not Assigned(Comdevice)) then
          raise Exception.Create('앱 카드로 결제하려면 바코드 스캐너를 사용할 수 있어야 합니다!');

        //결제 모듈에서 OTC 바코드 결제를 위해 포트 해제
        Global.BarcodeScannerClose;
      end;

      if (nInputAmt <= 0) then
        raise Exception.Create('결제할 금액을 입력하여 주십시오!');
      if (FIsApproval and (nInputAmt > SaleManager.ReceiptInfo.ChargeTotal)) then
        raise Exception.Create('받을 금액보다 결제할 금액이 더 많습니다!');
      if FManualApprove and
         ((Length(edtCardNo.Text) <> 4) or (edtApproveNo.Text = '') or (cbxCardList.ItemIndex < 0)) then
        raise Exception.Create('임의등록은 카드번호의 앞 4자리와' + _CRLF + '신용카드사 및 승인번호가 입력되어야 합니다!');

      nVatAmt := (nInputAmt - Trunc(nInputAmt / 1.1));
      if FManualApprove then
      begin
        RI.CardNo := edtCardNo.Text + StringOfChar('*', 12);
        RI.AgreeNo := edtApproveNo.Text;
        if (cbxCardList.ItemIndex >= 0) then
        begin
          RI.BalgupsaCode := MDCardList.FieldByName('Code').AsString;
          RI.BalgupsaName := MDCardList.FieldByName('Issuer').AsString;
          RI.CompCode := MDCardList.FieldByName('Code').AsString;
          RI.CompName := MDCardList.FieldByName('Acquirer').AsString;
        end;
        bResult := True;
      end
      else
      begin
        SI.Approval     := FIsApproval;
        SI.SaleAmt      := nInputAmt;
        SI.FreeAmt      := 0;
        SI.SvcAmt       := 0;
        SI.VatAmt       := nVatAmt;
        SI.EyCard       := False;
        SI.KeyInput     := False;
        SI.TrsType      := ''; //'A'=바코드 사전 등록 시
        SI.HalbuMonth   := Trunc(StrToIntDef(edtInstMonth.Text, 0));
        SI.TerminalID   := SaleManager.StoreInfo.CreditTID;
        SI.BizNo        := SaleManager.StoreInfo.BizNo;
        SI.SignOption   := CRC_YES;
        SI.CardBinNo    := '';
        SI.OrgAgreeNo   := '';
        SI.OrgAgreeDate := '';

        if ckbUseAppCard.Checked then
        begin
          nOldOwnerId := Global.DeviceConfig.BarcodeScanner.OwnerId;
          Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            if (PluginManager.OpenModal('XGAppCardScan' + CPL_EXTENSION, PM) = mrOK) then
              SI.OTCNo := FAppCardOTC;
          finally
            Global.DeviceConfig.BarcodeScanner.OwnerId := nOldOwnerId;
            FreeAndNil(PM);
          end;
        end;

        if FIsApproval then
        begin
          //타석예약 POS에서만 즉시할인 적용
          if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and
             ckbImmediateDiscount.Checked then
          begin
            RI := VanModule.CallCardInfo(SI);
            if RI.Result then
            begin
              sCardBinNo := Copy(IIF(ckbUseAppCard.Checked, FAppCardOTC, RI.CardBinNo), 1, 6); //'944011';
              SI.CardBinNo := sCardBinNo;
              if ClientDM.GetCardBinDiscount(sCardBinNo, sTeeBoxProdDiv, nInputAmt, nPromoSeq, nPromoDcAmt, sErrMsg) and
                 (XGMsgBox(Self.Handle, mtConfirmation, '확인',
                    '카드사 제휴할인이 적용되는 신용카드입니다!' + _CRLF +
                    '할인금액 ' + FormatFloat('#,##0', nPromoDcAmt) + ' 원을 적용하시겠습니까?', ['예', '아니오']) = mrOK) then
              begin
                sPromoDiv := CDC_CARD_IMMEDIATE;
                nInputAmt := (InputAmt - nPromoDcAmt);
                SI.SaleAmt:= nInputAmt;
              end;
            end;
          end;
        end
        else
        begin
          SI.OrgAgreeNo := FApprovalNo;
          SI.OrgAgreeDate := FApprovalDate;
        end;

        RI := VanModule.CallCard(SI);
        bResult := RI.Result;
        if not bResult then
          raise Exception.Create(RI.Msg);
      end;

      if bResult then
      begin
        if FIsApproval then
        begin
          if FIsSaleMode then
          begin
            SaleManager.PayLog(FIsApproval, FManualApprove, CPM_CARD, RI.CardNo, RI.AgreeNo, nInputAmt);
            SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt + nInputAmt);
          end;

          ClientDM.UpdatePayment(
            Global.TableInfo.ActiveTableNo,
            FIsApproval,
            FIsSaleMode,
            False, //ADeleteExists
            CPM_CARD, //APayMethod
            SaleManager.StoreInfo.VANCode, //AVan
            SaleManager.StoreInfo.CreditTID, //ATid
            IIF(FManualApprove, CRC_NO, CRC_YES), //AInternetYN
            RI.CardNo, //ACreditCardNo
            RI.AgreeNo, //AApproveNo
            '', //AOrgApproveNo,
            '', //AOrgApproveDate,
            RI.TransNo, //ATradeNo
            Global.CurrentDate, //ATradeDate
            RI.BalgupsaCode, //AIssuerCode
            RI.BalgupsaName, //AISsuerName
            '', //ABuyerDiv
            RI.CompCode, //ABuyerCode
            RI.CompName, //ABuyerName
            StrToIntDef(edtInstMonth.Text, 0), //AInstMonth
            nInputAmt, //AApproveAmt
            nVatAmt, //AVat
            0, //AServiceAmt: Integer);
            nPromoSeq,
            nPromoDcAmt,
            sPromoDiv);
        end
        else
        begin
          if FIsSaleMode then
            SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt - nInputAmt);

          SaleManager.PayLog(FIsApproval, FManualApprove, CPM_CARD, RI.CardNo, RI.AgreeNo, nInputAmt, FReceiptNo);
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_CARD_CANCEL;
            PM.AddParams(CPP_APPROVAL_NO, RI.AgreeNo);
            PM.PluginMessageToID(FOwnerId);
          finally
            FreeAndNil(PM);
          end;
        end;

        if not FManualApprove then
          XGMsgBox(Self.Handle, mtInformation, '알림', '신용거래가 정상 ' + IIF(FIsApproval, '승인', '취소') + '되었습니다!', ['확인'], 5);
        ModalResult := mrOK;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('DoCardApprove(%s).Exception = %s', [BoolToStr(FIsApproval), E.Message]));
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
      end;
    end;
  finally
    if (edtCardNo.Text = '') then
      edtCardNo.Clear;
    if (edtApproveNo.Text = '') then
      edtApproveNo.Clear;
    //결제 모듈에서 OTC 바코드 결제를 위해 연결을 해제했던 포트를 재연결
    if ckbUseAppCard.Checked then
      Global.BarcodeScannerOpen;
    ckbManualApprove.Enabled := True;
    btnApprove.Enabled := True;
    FWorking := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGCardApproveForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.