unit uXGWaitMsg;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxImage;

type
  TXGWaitMsgForm = class(TForm)
    lblMessage: TLabel;
    imgCircle: TcxImage;
    panCaption: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
//    procedure CreateParams(var Params : TCreateParams); override;
  end;

var
  XGWaitMsg: TXGWaitMsgForm;

procedure ShowWaitMessage(const AMsg: string);
procedure HideWaitMessage;
procedure PushWaitMessage;
procedure PopWaitMessage;

implementation

uses
  { DevExpress }
  dxCore,
  { Project }
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.DFM}

(*
procedure TXGWaitMsgForm.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := (Params.Style or WS_DLGFRAME);
end;
*)

procedure ShowWaitMessage(const AMsg: string);
begin
  if not Assigned(XGWaitMsg) then
    XGWaitMsg := TXGWaitMsgForm.Create(Application);

  with XGWaitMsg do
  begin
    lblMessage.Caption := AMsg;
    Show;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
end;

procedure PushWaitMessage;
begin
  if Assigned(XGWaitMsg) then
  begin
  	XGWaitMsg.Visible := False;
    Application.ProcessMessages;
  end;
end;

procedure PopWaitMessage;
begin
	if Assigned(XGWaitMsg) then
  begin
  	XGWaitMsg.Visible := True;
    Application.ProcessMessages;
  end;
end;

procedure HideWaitMessage;
begin
  if Assigned(XGWaitMsg) then
  begin
    XGWaitMsg.Close;
    XGWaitMsg.Free;
	  XGWaitMsg := nil;
  end;

  Screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

{ TXGWaitMsg }

procedure TXGWaitMsgForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  MakeRoundedControl(panCaption, 10, 10);
  SetDoubleBuffered(Self, True);
  panCaption.Top := -10;
  imgCircle.Visible := True;
  imgCircle.ViewInfo.BorderColor := clWhite;
end;

procedure TXGWaitMsgForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  imgCircle.AnimationOptions.Animation := bFalse;
end;

initialization
  XGWaitMsg := nil;
end.
