(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 타석 예약 변경
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxChange;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxMemo, cxTextEdit, cxMaskEdit, cxSpinEdit, cxLabel,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxChangeForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panFooter: TPanel;
    panNumPad: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    panBody: TPanel;
    Image1: TImage;
    lblMemberTitle: TcxLabel;
    lblMemberName: TcxLabel;
    lblReserveTitle: TcxLabel;
    lblReserveNo: TcxLabel;
    lblRemainTitle: TcxLabel;
    lblPrepareTitle: TcxLabel;
    lblOldTeeBox: TcxLabel;
    lblReserveTimeLabel: TcxLabel;
    lblReserveTime: TcxLabel;
    lblTeeBoxTitle: TcxLabel;
    lblOldRemainMin: TcxLabel;
    lblOldPrepareMin: TcxLabel;
    edtAdjustAssignMin: TcxSpinEdit;
    edtNewAssignMin: TcxSpinEdit;
    edtNewPrepareMin: TcxSpinEdit;
    Label1: TLabel;
    cxLabel1: TcxLabel;
    mmoMemo: TcxMemo;
    cxLabel2: TcxLabel;
    lblEndTime: TcxLabel;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure OnSpinEditEnter(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PluginModuleActivate(Sender: TObject);
    procedure edtAdjustAssignMinPropertiesChange(Sender: TObject);
    procedure edtNewAssignMinPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FTargetId: Integer;
    FReserveNo: string;
    FOrgEndDateTime: TDateTime;
    FRemainMin: Integer;
    FPrepareMin: Integer;
    FAdjustMin: Integer;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  DateUtils,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxChangeForm }

constructor TXGTeeBoxChangeForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FTargetId := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

destructor TXGTeeBoxChangeForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxChangeForm.PluginModuleActivate(Sender: TObject);
begin
  edtAdjustAssignMin.SetFocus;
end;

procedure TXGTeeBoxChangeForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGTeeBoxChangeForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxChangeForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FTargetId   := AMsg.ParamByInteger(CPP_OWNER_ID);
    FPrepareMin := AMsg.ParamByInteger(CPP_PREPARE_MIN);
    FRemainMin  := AMsg.ParamByInteger(CPP_REMAIN_MIN);
    edtNewPrepareMin.Enabled := (not AMsg.ParamByBoolean(CPP_PLAY_YN));
    edtAdjustAssignMin.Properties.MinValue := -FRemainMin;

    with ClientDM.MDTeeBoxReserved2 do
    begin
      FReserveNo               := FieldByName('reserve_no').AsString;
      FOrgEndDateTime          := StrToDateTime(FieldByName('end_datetime').AsString, Global.FS);
      lblReserveNo.Caption     := FReserveNo;
      lblMemberName.Caption    := FieldByName('member_nm').AsString;
      lblReserveTime.Caption   := Copy(FieldByName('reserve_datetime').AsString, 12, 5);
      lblEndTime.Caption       := Copy(FieldByName('end_datetime').AsString, 12, 5);
      lblOldTeeBox.Caption     := Format('%s층 %s', [StringReplace(FieldByName('floor_nm').AsString, '층', '', [rfReplaceAll]), FieldByName('teebox_nm').AsString]);
      lblOldRemainMin.Caption  := IntToStr(FRemainMin);
      lblOldPrepareMin.Caption := IntToStr(FieldByName('prepare_min').AsInteger);
      edtNewAssignMin.Value    := FRemainMin;
      edtNewPrepareMin.Value   := FPrepareMin;

      if FieldByName('play_yn').AsBoolean then
      begin
        lblRemainTitle.Caption := '잔여(분)';
        edtNewPrepareMin.Enabled := False;
      end;
    end;
  end;
end;

procedure TXGTeeBoxChangeForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGTeeBoxChangeForm.edtAdjustAssignMinPropertiesChange(Sender: TObject);
var
  nDiffMin: Integer;
  dNewEndDateTime: TDateTime;
begin
  with TcxSpinEdit(Sender) do
  begin
    FAdjustMin := Value;
    dNewEndDateTime := IncMinute(FOrgEndDateTime, edtNewPrepareMin.Value + FAdjustMin);
    if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
       (dNewEndDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
    begin
      nDiffMin := MinutesBetween(dNewEndDateTime, SaleManager.StoreInfo.StoreEndDateTime);
      FAdjustMin := (FAdjustMin - nDiffMin);
      Value := FAdjustMin;
      dNewEndDateTime := SaleManager.StoreInfo.StoreEndDateTime;
    end;
    edtNewAssignMin.Value := (FRemainMin + FAdjustMin);
    lblEndTime.Caption := FormatDateTime('hh:nn', dNewEndDateTime);
  end;
end;

procedure TXGTeeBoxChangeForm.edtNewAssignMinPropertiesChange(Sender: TObject);
begin
  with TcxSpinEdit(Sender) do
    edtAdjustAssignMin.Value := (Value - FRemainMin);
end;

procedure TXGTeeBoxChangeForm.OnSpinEditEnter(Sender: TObject);
begin
  with TcxSpinEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGTeeBoxChangeForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxChangeForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxChangeForm.btnOKClick(Sender: TObject);
var
  sMemo, sErrMsg: string;
begin
  if (edtNewAssignMin.Value < 5) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림',
      '배정 시간은 5분 이상 입력되어야 합니다!' + _CRLF + sErrMsg, ['확인'], 5);
    Exit;
  end;

  if FWorking then
    Exit;

  FWorking := True;
  FRemainMin := edtNewAssignMin.Value;
  FPrepareMin := edtNewPrepareMin.Value;
  sMemo := Trim(mmoMemo.Text);

  try
    if ClientDM.PostTeeBoxReserveChange(FReserveNo, FRemainMin, FPrepareMin, 9999, sMemo, sErrMsg) then
      ModalResult := mrOK
    else
      XGMsgBox(Self.Handle, mtError, '알림',
        '타석 변경 작업을 완료하지 못했습니다!' + _CRLF + sErrMsg, ['확인'], 5);
  finally
    FWorking := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxChangeForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.