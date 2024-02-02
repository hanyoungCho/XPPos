unit uXGReceiptPreview;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  Dialogs,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxMemo, cxRichEdit,
  { TMS }
  AdvShapeButton;

type
  TXGReceiptPreviewForm = class(TForm)
    lblCaption: TLabel;
    panPreview: TPanel;
    btnPrint: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    edtPreview: TcxRichEdit;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetPreviewData(const AValue: string);
  public
    { Public declarations }
    property PreviewData: string write SetPreviewData;
  end;

var
  XGReceiptPreviewForm: TXGReceiptPreviewForm;

implementation

uses
  uXGGlobal, uXGCommonLib, uXGMsgBox, uXGReceiptPrint, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGReceiptPreviewForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGReceiptPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGReceiptPreviewForm.FormShow(Sender: TObject);
begin
  btnPrint.SetFocus;
end;

procedure TXGReceiptPreviewForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnPrint.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGReceiptPreviewForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGReceiptPreviewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGReceiptPreviewForm.btnPrintClick(Sender: TObject);
begin
  if not Global.DeviceConfig.ReceiptPrinter.Enabled then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '영수증 프린터 사용 설정이 되어 있지 않습니다!', ['확인'], 5);
    Exit;
  end;

  ModalResult := mrOK;
end;

procedure TXGReceiptPreviewForm.SetPreviewData(const AValue: string);
begin
  Global.ReceiptPrint.ReceiptDataToRichEdit(AValue, edtPreview);
end;

end.
