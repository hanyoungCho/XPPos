unit uXGQuestionForm2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,
  dxGDIPlusClasses,
  AAFont, AACtrls;

type
  TVanQuestionForm2 = class(TForm)
    imgBG: TImage;
    lblMessage: TLabel;
    lblFormTitle: TAALabel;
    btnCancel: TSpeedButton;
    edtScanText: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtScanTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function GetScanText: string;
  public
    { Public declarations }
    FErrMsg: string;
    property ScanText: string read GetScanText;
    property ErrMsg: string read FErrMsg;
  end;

implementation

//uses
//  uSBMsgBox;

{$R *.dfm}

procedure TVanQuestionForm2.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  edtScanText.Text := '';
  FErrMsg := '';
end;

procedure TVanQuestionForm2.FormActivate(Sender: TObject);
begin
  edtScanText.SetFocus;
end;

procedure TVanQuestionForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      if (btnCancel.Visible and btnCancel.Enabled) then
        btnCancel.Click;
  end;
end;

procedure TVanQuestionForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TVanQuestionForm2.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TVanQuestionForm2.GetScanText: string;
begin
  Result := edtScanText.Text;
end;

procedure TVanQuestionForm2.edtScanTextKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (Length(edtScanText.Text) >= 170) then
  begin
    if (Pos('_', edtScanText.Text) > 0) then
    begin
      edtScanText.Text := '';
      FErrMsg := '여권을 다시 읽혀 주시기 바랍니다.';
      ModalResult := mrCancel;
    end
    else
      ModalResult := mrOk;
  end;
end;

end.
