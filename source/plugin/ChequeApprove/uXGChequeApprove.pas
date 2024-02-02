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
unit uXGChequeApprove;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxContainer, cxEdit, cxTextEdit,
  cxLookAndFeelPainters, cxCurrencyEdit, cxLabel,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  cyBaseSpeedButton, cyAdvSpeedButton, Solbi.BitmapButton;

{$I ..\..\common\XGPOS.inc}

const
  LCN_INPUT_CASH_AMT    = 0;
  LCN_INPUT_IDENT_NO    = 1;
  LCN_INPUT_APPROVE_NO  = 2;

type
  TXGChequeApproveForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    panInput: TPanel;
    panNumPad: TPanel;
    imgChequeSample: TImage;
    Label1: TLabel;
    edtChequeNo: TcxTextEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnChequeAmt1: TSolbiBitmapButton;
    btnChequeAmt3: TSolbiBitmapButton;
    btnChequeAmt4: TSolbiBitmapButton;
    btnChequeAmtEtc: TSolbiBitmapButton;
    Label4: TLabel;
    Label8: TLabel;
    edtBankCode: TcxTextEdit;
    btnChequeAmt2: TSolbiBitmapButton;
    Label9: TLabel;
    edtAccountCode: TcxTextEdit;
    edtAccountNo: TcxTextEdit;
    Label5: TLabel;
    edtBranchCode: TcxTextEdit;
    Label6: TLabel;
    edtIssueYear: TcxTextEdit;
    edtIssueMonth: TcxTextEdit;
    edtIssueDay: TcxTextEdit;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblResultMsg: TcxLabel;
    edtChequeAmt: TcxCurrencyEdit;
    btnCheckCheque: TcyAdvSpeedButton;
    btnApprove: TcyAdvSpeedButton;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCheckChequeClick(Sender: TObject);
    procedure btnApproveClick(Sender: TObject);
    procedure OnCheckAmtButtonClick(Sender: TObject);
    procedure btnChequeAmtEtcClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtChequeAmtPropertiesChange(Sender: TObject);
    procedure OnTextEditEnter(Sender: TObject);
    procedure edtChequeAmtEnter(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FChequeAmt: Integer;
    FKindCode: string;
    FCheckResult: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
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

{ TXGChequeApproveForm }

constructor TXGChequeApproveForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FChequeAmt := 100000;
  FKindCode := '13'; //10만원
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  btnChequeAmt1.HelpKeyword := '13'; //10만원
  btnChequeAmt1.Tag := 100000;
  btnChequeAmt2.HelpKeyword := '14'; //30만원
  btnChequeAmt2.Tag := 300000;
  btnChequeAmt3.HelpKeyword := '15'; //50만원
  btnChequeAmt3.Tag := 500000;
  btnChequeAmt4.HelpKeyword := '16'; //100만원
  btnChequeAmt4.Tag := 1000000;
  btnChequeAmtEtc.HelpKeyword := '19'; //기타금액
  edtIssueYear.Text := Copy(Global.CurrentDate, 1, 4);
  edtIssueMonth.Text := Copy(Global.CurrentDate, 5, 2);
  edtIssueDay.Text := Copy(Global.CurrentDate, 7, 2);

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

destructor TXGChequeApproveForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGChequeApproveForm.PluginModuleActivate(Sender: TObject);
begin
  edtChequeAmt.SetFocus;
end;

procedure TXGChequeApproveForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGChequeApproveForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_RETURN:
      btnApprove.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGChequeApproveForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGChequeApproveForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TXGChequeApproveForm.edtChequeAmtEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGChequeApproveForm.edtChequeAmtPropertiesChange(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
  begin
    FChequeAmt := Trunc(Value);
    Text := FormatCurr('#,##0', FChequeAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TXGChequeApproveForm.OnTextEditEnter(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGChequeApproveForm.btnApproveClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if FCheckResult then
  begin
    PM := TPluginMessage.Create(nil);
    PM.Command := CPC_SEND_CHEQUE_NO;
    PM.AddParams(CPP_CHEQUE_NO, edtChequeNo.Text);
    PM.AddParams(CPP_CHEQUE_AMT, FChequeAmt);
    ModalResult := mrOK;
  end;
end;

procedure TXGChequeApproveForm.OnCheckAmtButtonClick(Sender: TObject);
begin
  with TSolbiBitmapButton(Sender) do
  begin
    FKindCode := HelpKeyword;
    edtChequeAmt.Value := Tag;
  end;
end;

procedure TXGChequeApproveForm.btnChequeAmtEtcClick(Sender: TObject);
begin
  with TSolbiBitmapButton(Sender) do
    FKindCode := HelpKeyword;
  FChequeAmt := 0;
  edtChequeAmt.SetFocus;
end;

procedure TXGChequeApproveForm.btnCheckChequeClick(Sender: TObject);
var
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
begin
  SI.CheckNo    := edtChequeNo.Text; //61958825
  SI.KindCode   := FKindCode;
  SI.SaleAmt    := Trunc(edtChequeAmt.Value); //100000
  SI.RegDate    := FormatFloat('0000', StrToIntDef(edtIssueYear.Text, 0)) +
                   FormatFloat('00', StrToIntDef(edtIssueMonth.Text, 0)) +
                   FormatFloat('00', StrToIntDef(edtIssueDay.Text, 0)); //20150710
  SI.BankCode   := edtBankCode.Text; //84
  SI.BranchCode := edtBranchCode.Text; //2394
  SI.AccountNo  := edtAccountCode.Text + edtAccountNo.Text;

  RI := VanModule.CallCheck(SI);
  lblResultMsg.Caption := RI.Msg;
  FCheckResult := RI.Result;
  if not RI.Result then
    XGMsgBox(Self.Handle, mtWarning, '알림', '사용 불가능한 수표입니다!' + _CRLF + RI.Msg , ['확인'], 5)
  else
  begin
    XGMsgBox(Self.Handle, mtInformation, '알림', '사용 가능한 수표입니다!', ['확인'], 5);
    btnApprove.Click;
  end;
end;

procedure TXGChequeApproveForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGChequeApproveForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.