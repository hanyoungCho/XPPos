unit uXGPayWelfare;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel,
  { TMS }
  AdvShapeButton;

type
  TXGPayWelfareForm = class(TForm)
    lblFormTitle: TLabel;
    btnClose: TAdvShapeButton;
    panInput: TPanel;
    Shape1: TShape;
    Panel1: TPanel;
    btnApprove: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblEmpName: TcxLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    lblStockPoint: TcxLabel;
    lblChargeAmt: TcxLabel;
    lblWelfareRate: TcxLabel;
    lblPayPoint: TcxLabel;
    lblRemainPoint: TcxLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnApproveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FChargeAmt: Integer;
    FUsePoint: Integer;
    FRemainPoint: Integer;

    procedure SetChargeAmt(const AValue: Integer);
  public
    { Public declarations }
    property ChargeAmt: Integer read FChargeAmt write SetChargeAmt default 0;
    property UsePoint: Integer read FUsePoint write FUsePoint default 0;
  end;

var
  XGPayWelfareForm: TXGPayWelfareForm;

implementation

uses
  uXGSaleManager, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGPayWelfareForm }

procedure TXGPayWelfareForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  lblEmpName.Caption := SaleManager.MemberInfo.MemberName;
  lblStockPoint.Caption := FormatFloat('#,##0', SaleManager.MemberInfo.WelfarePoint);
  lblWelfareRate.Caption := FormatFloat('#,##0.0 %', SaleManager.MemberInfo.WelfareRate);
end;

procedure TXGPayWelfareForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGPayWelfareForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnCancel.Click;
    VK_RETURN:
      btnApprove.Click;
  end;
end;

procedure TXGPayWelfareForm.SetChargeAmt(const AValue: Integer);
var
  nDicountAmt: Integer;
begin
  FChargeAmt   := AValue;
  nDicountAmt  := Trunc(FChargeAmt * (SaleManager.MemberInfo.WelfareRate / 100));
  FUsePoint    := (FChargeAmt - nDicountAmt);
  FRemainPoint := (SaleManager.MemberInfo.WelfarePoint - FUsePoint);

  lblChargeAmt.Caption   := FormatFloat('#,##0', FChargeAmt);
  lblPayPoint.Caption    := FormatFloat('#,##0', FUsePoint);
  lblRemainPoint.Caption := FormatFloat('#,##0', FRemainPoint);
end;

procedure TXGPayWelfareForm.btnApproveClick(Sender: TObject);
begin
  if (FRemainPoint < 0) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '복지포인트 잔액이 부족하여 결제를 진행할 수 없습니다!', ['확인'], 5);
    Exit;
  end;

  ModalResult := mrOK;
end;

procedure TXGPayWelfareForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGPayWelfareForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
