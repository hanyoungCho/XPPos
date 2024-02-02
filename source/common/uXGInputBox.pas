unit uXGInputBox;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  { TMS }
  AdvShapeButton;

type
  TXGInputBoxForm = class(TForm)
    lblTitle: TLabel;
    lblMessage: TLabel;
    panButtonSet: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    edtInputText: TcxTextEdit;
    btnClose: TAdvShapeButton;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtInputTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTitle: string;
    FMessageText: string;
    FPasswordMode: Boolean;

    procedure SetTitle(const AValue: string);
    procedure SetMessageText(const AValue: string);
    procedure SetInputText(const AValue: string);
    procedure SetPasswordMode(const AValue: Boolean);
    function GetInputText: string;
    { Private declarations }
  public
    property Title: string read FTitle write SetTitle;
    property MessageText: string read FMessageText write SetMessageText;
    property InputText: string read GetInputText write SetInputText;
    property PasswordMode: Boolean read FPasswordMode write SetPasswordMode;
  end;

var
  XGInputBox: TXGInputBoxForm;

implementation

uses
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.DFM}

{ TXGInputBoxForm }

procedure TXGInputBoxForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGInputBoxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGInputBoxForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      ModalResult := mrOK;
    VK_ESCAPE:
      ModalResult := mrCancel;
  end;
end;

procedure TXGInputBoxForm.edtInputTextKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Char(VK_RETURN)) then
    btnOK.Click;
end;

procedure TXGInputBoxForm.SetTitle(const AValue: string);
begin
  FTitle := AValue;
  lblTitle.Caption := FTitle;
end;

procedure TXGInputBoxForm.SetMessageText(const AValue: string);
begin
  FMessageText := AValue;
  lblMessage.Caption := FMessageText;
end;

function TXGInputBoxForm.GetInputText: string;
begin
  Result := edtInputText.Text;
end;

procedure TXGInputBoxForm.SetInputText(const AValue: string);
begin
  edtInputText.Text := AValue;
end;

procedure TXGInputBoxForm.SetPasswordMode(const AValue: Boolean);
begin
  FPasswordMode := AValue;
  if FPasswordMode then
    edtInputText.Properties.EchoMode := eemPassword
  else
    edtInputText.Properties.EchoMode := eemNormal;
end;

procedure TXGInputBoxForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TXGInputBoxForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGInputBoxForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

initialization
  XGInputBox := nil;
end.
