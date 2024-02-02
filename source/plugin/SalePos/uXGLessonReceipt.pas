unit uXGLessonReceipt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvShapeButton, Vcl.Mask, Vcl.ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.ComCtrls;

type
  TXGLessonReceiptForm = class(TForm)
    lblFormTitle: TLabel;
    btnClose: TAdvShapeButton;
    edtLessonMemberNo: TLabeledEdit;
    edtLessonCoachName: TLabeledEdit;
    edtLessonName: TLabeledEdit;
    edtLessonProdName: TLabeledEdit;
    edtLessonStoreName: TLabeledEdit;
    lblLessonFee: TLabel;
    edtLessonFee: TcxCurrencyEdit;
    dtpLessonDateTime: TDateTimePicker;
    lblLessonDateTime: TLabel;
    edtLessonIssuerName: TLabeledEdit;
    panToolbar: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblNotice: TLabel;
    edtLessonBuyerName: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XGLessonReceiptForm: TXGLessonReceiptForm;

implementation

uses
  { Project }
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGLessonReceiptForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGLessonReceiptForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGLessonReceiptForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TXGLessonReceiptForm.btnOKClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

procedure TXGLessonReceiptForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

end.
