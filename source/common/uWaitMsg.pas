unit uWaitMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxActivityIndicator, Vcl.ExtCtrls;

type
  TWaitMsgForm = class(TForm)
    lblMessage: TLabel;
    dxActivityIndicator: TdxActivityIndicator;
    shpBorder: TShape;

    procedure OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
  end;

var
  WaitMsgForm: TWaitMsgForm;

procedure ShowWaitMessage(const AMsg: string);
procedure PushWaitMessage;
procedure PopWaitMessage;
procedure HideWaitMessage;

implementation

{$R *.dfm}

procedure ShowWaitMessage(const AMsg: string);
begin
  if not Assigned(WaitMsgForm) then
    WaitMsgForm := TWaitMsgForm.Create(Application);
  WaitMsgForm.lblMessage.Caption := AMsg;
  WaitMsgForm.Show;
  WaitMsgForm.FormStyle := fsStayOnTop;
  WaitMsgForm.dxActivityIndicator.Active := True;
  Application.ProcessMessages;
end;

procedure PushWaitMessage;
begin
  if Assigned(WaitMsgForm) then
  begin
  	WaitMsgForm.Visible := False;
    Application.ProcessMessages;
  end;
end;

procedure PopWaitMessage;
begin
	if Assigned(WaitMsgForm) then
  begin
  	WaitMsgForm.Visible := True;
    Application.ProcessMessages;
  end;
end;

procedure HideWaitMessage;
begin
  WaitMsgForm.dxActivityIndicator.Active := False;
  if Assigned(WaitMsgForm) then
    FreeAndNil(WaitMsgForm);
  Application.ProcessMessages;
end;

{ TWaitMsgForm }

procedure TWaitMsgForm.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

//  Params.Style := Params.Style or WS_POPUPWINDOW or WS_CAPTION or WS_CLIPCHILDREN;
//  Params.Style := Params.Style or WS_POPUPWINDOW or WS_CLIPCHILDREN;
//  Params.Style := Params.Style or WS_DLGFRAME;
end;

procedure TWaitMsgForm.OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

end.
