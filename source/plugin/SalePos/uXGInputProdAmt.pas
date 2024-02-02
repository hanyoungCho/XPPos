unit uXGInputProdAmt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxCurrencyEdit,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGInputProdAmtForm = class(TForm)
    lblFormTitle: TLabel;
    panInput: TPanel;
    Shape1: TShape;
    lblInputAmtTitle: TLabel;
    edtInputAmt: TcxCurrencyEdit;
    Label1: TLabel;
    Panel1: TPanel;
    panNumPad: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    btnClose: TAdvShapeButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure edtProductAmtPropertiesChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtInputAmtEnter(Sender: TObject);
    procedure edtInputAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FInputAmt: Integer;
    FWorking: Boolean;
  public
    { Public declarations }
    property InputAmt: Integer read FInputAmt write FInputAmt default 0;
  end;

var
  XGInputProdAmtForm: TXGInputProdAmtForm;

implementation

uses
  { SolbiLib }
  uPluginManager, uPluginMessages,
  { Project }
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGInputProdAmtForm.FormCreate(Sender: TObject);
var
  PM: TPluginMessage;
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  InputAmt := 0;
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.Handle);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGInputProdAmtForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGInputProdAmtForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGInputProdAmtForm.FormActivate(Sender: TObject);
begin
  edtInputAmt.SetFocus;
end;

procedure TXGInputProdAmtForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGInputProdAmtForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGInputProdAmtForm.btnOKClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
  if (InputAmt > 0) then
    ModalResult := mrOK;
  finally
    FWorking := False;
  end;
end;

procedure TXGInputProdAmtForm.edtInputAmtEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGInputProdAmtForm.edtInputAmtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      TcxCurrencyEdit(Sender).Value := 0;
  end;
end;

procedure TXGInputProdAmtForm.edtProductAmtPropertiesChange(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
  begin
    InputAmt := Trunc(Value);
    Text := FormatCurr('#,##0', InputAmt);
    SelStart := Length(Text) + 1;
  end;
end;

end.
