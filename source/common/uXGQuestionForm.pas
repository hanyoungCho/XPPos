unit uXGQuestionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, dxGDIPlusClasses, AAFont, AACtrls;

type
  TVanQuestionForm = class(TForm)
    imgBG: TImage;
    lblMessage: TLabel;
    btnOk: TSpeedButton;
    btnCancel: TSpeedButton;
    lblFormTitle: TAALabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TVanQuestionForm.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TVanQuestionForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TVanQuestionForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TVanQuestionForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: if btnCancel.Visible and btnCancel.Enabled then btnCancel.Click;
    VK_RETURN: if btnOk.Visible and btnOk.Enabled then btnOk.Click;
  end;
end;

procedure TVanQuestionForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

end.
