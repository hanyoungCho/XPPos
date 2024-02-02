unit uXGTeeBoxAgentPwd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxButtons,
  AdvShapeButton,
  AdvSmoothPanel;

type
  TPasswordForm = class(TForm)
    imgBack: TImage;
    Label1: TLabel;
    btnNum1: TcxButton;
    btnNum2: TcxButton;
    btnNum3: TcxButton;
    btnNum4: TcxButton;
    btnNum5: TcxButton;
    btnNum6: TcxButton;
    btnNum7: TcxButton;
    btnNum8: TcxButton;
    btnNum9: TcxButton;
    btnNum10: TcxButton;
    btnNum0: TcxButton;
    btnNum11: TcxButton;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    btnClose: TAdvShapeButton;
    panInputValue: TAdvSmoothPanel;
    lblInputValue: TLabel;
    btnAppRestart: TcxButton;
    btnAppClose: TcxButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAppCloseClick(Sender: TObject);
    procedure btnAppRestartClick(Sender: TObject);
  private
    { Private declarations }
    FInputValue: string;

    procedure OnClickNumButton(Sender: TObject);
    procedure OnCxButtonCustomDraw(Sender: TObject; ACanvas: TcxCanvas;
      AViewInfo: TcxButtonViewInfo; var AHandled: Boolean);
  public
    { Public declarations }
    property InputValue: string read FInputValue write FInputValue;
  end;

var
  PasswordForm: TPasswordForm;

implementation

uses
  {Native}
  System.StrUtils,
  {Project}
  uLayeredForm, uXGCommonLib;

const
  LCN_NUMPAD_BTN_COUNT = 12;

var
  LF: TLayeredForm;
  NumButtons: TArray<TcxButton>;

{$R *.dfm}

procedure TPasswordForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  MakeRoundedControl(btnOK);
  MakeRoundedControl(btnCancel);
  btnOK.OnCustomDraw := OnCxButtonCustomDraw;
  btnCancel.OnCustomDraw := OnCxButtonCustomDraw;

  SetLength(NumButtons, LCN_NUMPAD_BTN_COUNT);
  for var I := 0 to Pred(LCN_NUMPAD_BTN_COUNT) do
  begin
    NumButtons[I] := TcxButton(FindComponent('btnNum' + IntToStr(I)));
    NumButtons[I].CanBeFocused := False;
    NumButtons[I].SpeedButtonOptions.CanBeFocused := False;
    NumButtons[I].SpeedButtonOptions.Flat := True;
    NumButtons[I].OnClick := OnClickNumButton;
    NumButtons[I].OnCustomDraw := OnCxButtonCustomDraw;
    MakeRoundedControl(NumButtons[I]);
  end;

  FInputValue := '';
end;

procedure TPasswordForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  LF := nil;
end;

procedure TPasswordForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TPasswordForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPasswordForm.btnAppRestartClick(Sender: TObject);
begin
  ModalResult := mrRetry;
end;

procedure TPasswordForm.btnAppCloseClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

procedure TPasswordForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TPasswordForm.OnClickNumButton(Sender: TObject);
var
  nKey: Integer;
begin
  nKey := TcxButton(Sender).Tag;
  case nKey of
    48 .. 57: // 0..9
      FInputValue := FInputValue + Chr(nKey);
    8: // Backspace
      FInputValue := FInputValue.Substring(0, Pred(FInputValue.Length));
    239: // Clear;
      FInputValue := '';
  end;

  if FInputValue.IsEmpty then
  begin
    lblInputValue.Font.Color := $0082776F;
    lblInputValue.Caption := '<비밀번호 입력>';
  end
  else
  begin
    lblInputValue.Font.Color := $00FF8000;
    lblInputValue.Caption := DupeString('●', FInputValue.Length);
    if (FInputValue.Length = 4) then
      btnOK.Click;
  end;
end;

procedure TPasswordForm.OnCxButtonCustomDraw(Sender: TObject;
  ACanvas: TcxCanvas; AViewInfo: TcxButtonViewInfo; var AHandled: Boolean);
begin
  if (AViewInfo.State in [cxbsNormal, cxbsHot]) then
  begin
    ACanvas.Font := (Sender as TcxButton).Font;
    AViewInfo.Painter.LookAndFeelPainter.DrawButton(ACanvas,
      AViewInfo.ButtonRect, (Sender as TcxButton).Caption, cxbsHot, False,
      (Sender as TcxButton).Colors.Normal, (Sender as TcxButton)
      .Colors.NormalText, (Sender as TcxButton).WordWrap, False);
  end
  else if (AViewInfo.State in [cxbsPressed]) then
  begin
    ACanvas.Font := (Sender as TcxButton).Font;
    AViewInfo.Painter.LookAndFeelPainter.DrawButton(ACanvas,
      AViewInfo.ButtonRect, (Sender as TcxButton).Caption, cxbsPressed, False,
      (Sender as TcxButton).Colors.Pressed, (Sender as TcxButton)
      .Colors.PressedText, (Sender as TcxButton).WordWrap, False);
  end;
  AHandled := True;
end;

end.
