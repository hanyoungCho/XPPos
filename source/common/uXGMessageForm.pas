unit uXGMessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  { DevExpress }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  AAFont, AACtrls;

{$I XGPOS.inc}

type
  TVanMessageForm = class(TForm)
    Panel1: TPanel;
    imgBack: TImage;
    lblMessage: TLabel;
    lblFormTitle: TAALabel;
    btnCancel: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure imgBackMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FTimeOutSeconds: integer;
    FTimer: TTimer;

    procedure CreateParams(var Params : TCreateParams); override;
    procedure SetTimeOut(const ATimeOutSeconds: integer);
    procedure OnTimeOutTimer(Sender: TObject);
  public
    { Public declarations }
    property TimeOutSeconds: integer read FTimeOutSeconds write SetTimeOut default 0;
  protected
    procedure WndProc(var AMsg: TMessage); override;
  end;

implementation

{$R *.dfm}

procedure TVanMessageForm.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_ERASEBKGND:
      AMsg.Result := 1;
    else
      inherited WndProc(AMsg);
  end;
end;

procedure TVanMessageForm.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := (Params.Style or WS_DLGFRAME);
end;

procedure TVanMessageForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TVanMessageForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TVanMessageForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FTimer) then
    FTimer.Free;
end;

procedure TVanMessageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE, VK_END:
      if btnCancel.Visible and btnCancel.Enabled then
        btnCancel.Click;
  end;
end;

procedure TVanMessageForm.imgBackMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TVanMessageForm.SetTimeOut(const ATimeOutSeconds: integer);
begin
  FTimeOutSeconds := ATimeOutSeconds;
  if (FTimeOutSeconds > 0) then
  begin
    if not Assigned(FTimer) then
      FTimer := TTimer.Create(Self);

    FTimer.Enabled := False;
    FTimer.Interval := (FTimeOutSeconds * 1000);
    FTimer.OnTimer := OnTimeOutTimer;
    FTimer.Enabled := True;
  end;
end;

procedure TVanMessageForm.OnTimeOutTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  if btnCancel.Visible and btnCancel.Enabled then
    btnCancel.Click;
end;

end.
