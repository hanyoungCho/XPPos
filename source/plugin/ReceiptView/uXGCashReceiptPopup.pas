unit uXGCashReceiptPopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { DevExpress }
  cxLookAndFeels, cxGraphics, cxControls, cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox,
  cxLabel,
  { TMS }
  AdvShapeButton,
  { SolbiLib }
  cyBaseSpeedButton, cyAdvSpeedButton;

type
  TXGCashReceiptPopup = class(TForm)
    lblCaption: TLabel;
    panBody: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblCashAmount: TcxLabel;
    Label1: TLabel;
    btnIndividual: TcyAdvSpeedButton;
    btnBiz: TcyAdvSpeedButton;
    ckbSelfIssued: TcxCheckBox;
    btmClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FCashAmount: Integer;
    FCreditCardNo: string;
    FApproveNo: string;

    function RequestCashReceipt(var AErrMsg: string): Boolean;
    procedure SetCashAmount(const AValue: Integer);
  public
    { Public declarations }
    property CashAmount: Integer read FCashAmount write SetCashAmount;
    property CreditCardNo: string read FCreditCardNo write FCreditCardNo;
    property ApproveNo: string read FApproveNo write FApproveNo;
  end;

var
  XGCashReceiptPopup: TXGCashReceiptPopup;

implementation

uses
  { VAN }
  uVanDaemonModule,
  { Project }
  uXGClientDM, uXGGlobal, uXGSaleManager, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGCashReceiptPopup }

procedure TXGCashReceiptPopup.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FCreditCardNo := '';
  FApproveNo := '';
  btnIndividual.Down := True;
end;

procedure TXGCashReceiptPopup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGCashReceiptPopup.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGCashReceiptPopup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGCashReceiptPopup.btnOKClick(Sender: TObject);
var
  sErrMsg: string;
begin
  with TAdvShapeButton(Sender) do
  try
    Enabled := False;
    if not RequestCashReceipt(sErrMsg) then
      ShowMessage(sErrMsg)
    else
      ModalResult := mrOK;
  finally
    Enabled := True;
  end;
end;

function TXGCashReceiptPopup.RequestCashReceipt(var AErrMsg: string): Boolean;
var
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  nVatAmt: Integer;
begin
  Result := False;
  try
    try
      if (CashAmount <= 0) then
        raise Exception.Create('결제금액이 입력되지 않았습니다!');

      nVatAmt := (CashAmount - Trunc(CashAmount / 1.1));
      SI.Approval     := True;
      SI.SaleAmt      := CashAmount;
      SI.FreeAmt      := 0;
      SI.SvcAmt       := 0;
      SI.VatAmt       := nVatAmt;
      SI.OrgAgreeNo   := '';
      SI.OrgAgreeDate := '';
      SI.TerminalID   := SaleManager.StoreInfo.CreditTID;
      SI.BizNo        := SaleManager.StoreInfo.BizNo;
      SI.Person       := IIF(btnBiz.Down, 2, 1); //1:개인, 2:사업자
      SI.CardNo       := IIF(ckbSelfIssued.Checked, '0100001234',  '');
      SI.KeyInput     := (SI.CardNo <> '');

      RI := VanModule.CallCash(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg);

      CreditCardNo := RI.CardNo;
      ApproveNo := RI.AgreeNo;
      XGMsgBox(Self.Handle, mtInformation, '알림', '현금영수증이 정상 발급 되었습니다!', ['확인'], 5);
      Result := True;
    finally
    end;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

procedure TXGCashReceiptPopup.SetCashAmount(const AValue: Integer);
begin
  FCashAmount := AValue;
  lblCashAmount.Caption := FormatCurr('#,##0', FCashAmount)
end;

end.
