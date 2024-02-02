unit uSBMsgBox;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  { TMS }
  AdvShapeButton;

{$I XGPOS.inc}

type
  TSBMsgBoxForm = class(TForm)
    tmrAutoCloser: TTimer;
    lblTimeOut: TLabel;
    lblMessage: TLabel;
    panButtonSet: TPanel;
    lblCaption: TLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    btnYesToAll: TAdvShapeButton;
    btnNoToAll: TAdvShapeButton;
    btnAll: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnYesToAllClick(Sender: TObject);
    procedure btnNoToAllClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure tmrAutoCloserTimer(Sender: TObject);
  private
    { Private declarations }
    FTimeOutSecs: Integer;
    FTimeOutCount: Integer;

    procedure CMDialogKey(var AMsg: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Public declarations }
  end;

var
  SBMsgBoxForm: TSBMsgBoxForm;
  FWndHook: HHOOK;
  FActiveButtons: Integer=1;

function CallWndProc(AHookCode: Integer; AwParam: WPARAM; AlParam: LPARAM): LRESULT; stdcall;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const APosition: TPosition=poScreenCenter): TModalResult; overload;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const APosition: TPosition=poScreenCenter): TModalResult; overload;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const APosition: TPosition=poScreenCenter): TModalResult; overload;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const ATimeOutSecs: Integer; const APosition: TPosition=poScreenCenter): TModalResult; overload;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const ATimeOutSecs: Integer; const APosition: TPosition=poScreenCenter): TModalResult; overload;

implementation

uses
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function CallWndProc(AHookCode: Integer; AwParam: WPARAM; AlParam: LPARAM): LRESULT; stdcall;
const
  DialogClass = '#32770';
var
  ClassName: array[0..6] of Char;
  Wnd: HWND;
  Rect: TRect;
  X, Y: Integer;
begin
  if (AHookCode = HC_ACTION) and
    (PCWPStruct(AlParam).message = WM_INITDIALOG) then
  begin
    Wnd := PCWPStruct(AlParam).hwnd;
    if Bool(GetClassName(Wnd, @ClassName, SizeOf(ClassName))) and
      (ClassName = DialogClass) then
    begin
      GetWindowRect(Wnd, Rect);

      X := Screen.ActiveForm.Left + (Screen.ActiveForm.Width - (Rect.Right - Rect.Left)) div 2;
      Y := Screen.ActiveForm.Top + (Screen.ActiveForm.Height - (Rect.Bottom - Rect.Top)) div 2;
      if (Y < 0) then Y := 0;
      SetWindowPos(Wnd, 0, X, Y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
    end;
  end;
  Result := CallNextHookEx(FWndHook, AHookCode, AwParam, AlParam);
end;

function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const APosition: TPosition): TModalResult; overload;
begin
  Result := SBMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, [], True, 0, APosition);
end;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const APosition: TPosition): TModalResult; overload;
begin
  Result := SBMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, False, 0, APosition);
end;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const APosition: TPosition): TModalResult; overload;
begin
  Result := SBMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, AStandbyMode, 0, APosition);
end;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const ATimeOutSecs: Integer; const APosition: TPosition): TModalResult; overload;
begin
  Result := SBMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, False, ATimeOutSecs, APosition);
end;
function SBMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const ATimeOutSecs: Integer; const APosition: TPosition): TModalResult; overload;
var
  R: TRect;
  nLeft: Integer;
begin
  FActiveButtons := Length(AButtonCaptions);
  with TSBMsgBoxForm.Create(nil) do
  try
    DoubleBuffered := True;
    lblCaption.Caption := ACaption;
    lblMessage.Caption := AMessage;
    btnCancel.Visible := False;
    btnYesToAll.Visible := False;
    btnNoToAll.Visible := False;
    btnAll.Visible := False;
    Position := APosition;

    nLeft := 49;
    if (not AStandbyMode) then
    begin
      if (FActiveButtons > 0) then
      begin
        btnOK.Visible := True;
        btnOK.Text := AButtonCaptions[0];
        nLeft := 249;
      end;
      if (FActiveButtons > 1) then
      begin
        btnCancel.Visible := True;
        btnCancel.Text := AButtonCaptions[1];
        nLeft := 199;
      end;
      if (FActiveButtons > 2) then
      begin
        btnYesToAll.Visible := True;
        btnYesToAll.Text := AButtonCaptions[2];
        nLeft := 149;
      end;
      if (FActiveButtons > 3) then
      begin
        btnNoToAll.Visible := True;
        btnNoToAll.Text := AButtonCaptions[3];
        nLeft := 99;
      end;
      if (FActiveButtons > 4) then
      begin
        btnAll.Visible := True;
        btnAll.Text := AButtonCaptions[4];
        nLeft := 49;
      end;
    end;

    panButtonSet.AutoSize := True;
    panButtonSet.Left := nLeft;
    FWndHook := SetWindowsHookEx(WH_CALLWNDPROC, CallWndProc, 0, GetCurrentThreadId);

    case AMsgDlgType of
      mtWarning:
        begin
          lblCaption.Color := $00004080;
          MessageBeep(MB_ICONWARNING);
        end;
      mtError:
        begin
          lblCaption.Color := $002C24DA;
          MessageBeep(MB_ICONERROR);
        end;
      mtConfirmation:
        begin
          lblCaption.Color := $000080FF;
          MessageBeep(MB_ICONQUESTION);
        end;
      else
        lblCaption.Color := $00FF8000; //$00689E0E;
        MessageBeep(MB_ICONINFORMATION);
    end;

    FTimeOutSecs := ATimeOutSecs;
    FTimeOutCount := 0;
    lblTimeOut.Visible := (FTimeOutSecs > 0);
    if (FTimeOutSecs > 0) then
    begin
      tmrAutoCloser.Interval := 1000;
      tmrAutoCloserTimer(tmrAutoCloser);
    end;

    if (AParentHandle = 0) then
      GetWindowRect(Application.MainForm.Handle, R)
    else
      GetWindowRect(AParentHandle, R);
    Left := R.Left + ((R.Right - R.Left) div 2) - (Width div 2);
    Top := R.Top + ((R.Bottom - R.Top) div 2) - (Height div 2);

    Application.MainForm.SetFocus;
    Result := ShowModal;
  finally
    if (FWndHook > 0) then
      UnhookWindowsHookEx(fWndHook);
    Free;
  end;
end;

{ TSBMsgBox }

procedure TSBMsgBoxForm.CMDialogKey(var AMsg: TCMDialogKey);
begin
  if (AMsg.CharCode = 32) or
     ((AMsg.CharCode in [VK_UP, VK_LEFT]) and btnOK.Focused) or
     ((AMsg.CharCode in [VK_DOWN, VK_RIGHT]) and
      (((FActiveButtons = 1) and btnOK.Focused) or
       ((FActiveButtons = 2) and btnCancel.Focused) or
       ((FActiveButtons = 3) and btnYesToAll.Focused) or
       ((FActiveButtons = 4) and btnNoToAll.Focused) or
       ((FActiveButtons = 5) and btnAll.Focused))) then
    AMsg.Result := 1
  else
    inherited;
end;

procedure TSBMsgBoxForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
end;

procedure TSBMsgBoxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(LF) then
  begin
    LF.Close;
    LF.Free;
  end;
end;

procedure TSBMsgBoxForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      ModalResult := mrOK;
    VK_ESCAPE:
      ModalResult := mrCancel;
  end;
end;

procedure TSBMsgBoxForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrIgnore;
end;

procedure TSBMsgBoxForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSBMsgBoxForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSBMsgBoxForm.btnYesToAllClick(Sender: TObject);
begin
  ModalResult := mrYesToAll;
end;

procedure TSBMsgBoxForm.btnNoToAllClick(Sender: TObject);
begin
  ModalResult := mrNoToAll;
end;

procedure TSBMsgBoxForm.btnAllClick(Sender: TObject);
begin
  ModalResult := mrAll;
end;

procedure TSBMsgBoxForm.tmrAutoCloserTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;

    lblTimeOut.Caption := Format('(%d초 후 이 메시지 창을 닫음)', [FTimeOutSecs - FTimeOutCount]);
    Inc(FTimeOutCount);
    if (FTimeOutCount > FTimeOutSecs) then
      ModalResult := mrOK;
  finally
    Enabled := True;
  end;
end;

end.
