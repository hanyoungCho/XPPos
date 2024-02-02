(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 타석 이동
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxMove;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxLabel,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxMoveForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    Image1: TImage;
    lblMemberTitle: TcxLabel;
    lblMemberName: TcxLabel;
    lblReserveTitle: TcxLabel;
    lblReserveNo: TcxLabel;
    lblRemainTitle: TcxLabel;
    lblPrepareTitle: TcxLabel;
    lblOldTeeBox: TcxLabel;
    lblNewTeeBox: TcxLabel;
    lblReserveTimeLabel: TcxLabel;
    panFooter: TPanel;
    panNumPad: TPanel;
    lblReserveTime: TcxLabel;
    lblTeeBoxTitle: TcxLabel;
    lblOldRemainMin: TcxLabel;
    lblOldPrepareMin: TcxLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    edtAdjustAssignMin: TcxSpinEdit;
    edtNewAssignMin: TcxSpinEdit;
    edtNewPrepareMin: TcxSpinEdit;
    Label1: TLabel;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure OnSpinEditEnter(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtAdjustAssignMinPropertiesChange(Sender: TObject);
    procedure edtNewAssignMinPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FReserveNo: string;
    FTeeBoxNo: Integer;
    FTeeBoxName: string;
    FFloorCode: String;
    FRemainMin: Integer;
    FPrepareMin: Integer;
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
  uXGClientDM, uXGGlobal, uXGSaleManager, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxMoveForm }

constructor TXGTeeBoxMoveForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
  nAssignMin: Integer;
  dEndDateTime: TDateTime;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  with ClientDM.MDTeeBoxReserved2 do
  begin
    FReserveNo  := FieldByName('reserve_no').AsString;
    FPrepareMin := FieldByName('prepare_min').AsInteger;
    nAssignMin  := FieldByName('assign_min').AsInteger;
    FRemainMin  := nAssignMin;
    edtAdjustAssignMin.Properties.MinValue := -FRemainMin;

    if FieldByName('play_yn').AsBoolean then
    begin
      dEndDateTime := StrToDateTime(FieldByName('end_datetime').AsString, Global.FS);
      FRemainMin := MinutesBetween(dEndDateTime, Now);
      lblRemainTitle.Caption := '잔여(분)';
    end;

    lblMemberName.Caption     := FieldByName('member_nm').AsString;
    lblReserveNo.Caption      := FReserveNo;
    lblReserveTime.Caption    := Copy(FieldByName('reserve_datetime').AsString, 12, 5);
    lblOldTeeBox.Caption      := Format('%s층 %s', [StringReplace(FieldByName('floor_nm').AsString, '층', '', [rfReplaceAll]), FieldByName('teebox_nm').AsString]);
    lblOldRemainMin.Caption   := IntToStr(FRemainMin);
    lblOldPrepareMin.Caption  := IntToStr(FPrepareMin);
    edtNewAssignMin.Value     := FRemainMin;
    edtNewPrepareMin.Value    := FPrepareMin;
  end;

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

destructor TXGTeeBoxMoveForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxMoveForm.PluginModuleActivate(Sender: TObject);
begin
  edtAdjustAssignMin.SetFocus;
end;

procedure TXGTeeBoxMoveForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGTeeBoxMoveForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TXGTeeBoxMoveForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxMoveForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId    := AMsg.ParamByInteger(CPP_OWNER_ID);
    FTeeBoxNo   := AMsg.ParamByInteger(CPP_TEEBOX_NO);
    FTeeBoxName := AMsg.ParamByString(CPP_TEEBOX_NAME);
    FFloorCode  := AMsg.ParamByString(CPP_FLOOR_CODE);
    lblNewTeeBox.Caption := Format('%s층 %s', [FFloorCode, FTeeBoxName]);
  end;
end;

procedure TXGTeeBoxMoveForm.edtAdjustAssignMinPropertiesChange(Sender: TObject);
begin
  edtNewAssignMin.Value := (FRemainMin + TcxSpinEdit(Sender).Value);
end;

procedure TXGTeeBoxMoveForm.edtNewAssignMinPropertiesChange(Sender: TObject);
begin
  edtAdjustAssignMin.Value := (TcxSpinEdit(Sender).Value - FRemainMin);
end;

procedure TXGTeeBoxMoveForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxMoveForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxMoveForm.btnOKClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    if (Trunc(edtNewAssignMin.Value) < 5) then
    begin
      XGMsgBox(Self.Handle, mtInformation, '알림', '배정 시간은 5분 이상 입력되어야 합니다!' + _CRLF + sErrMsg, ['확인'], 5);
      Exit;
    end;

    FRemainMin := Trunc(edtNewAssignMin.Value);
    FPrepareMin := Trunc(edtNewPrepareMin.Value);
    if ClientDM.PostTeeBoxReserveMove(FReserveNo, FTeeBoxNo, FRemainMin, FPrepareMin, 9999, sErrMsg) then
      ModalResult := mrOK
    else
      XGMsgBox(Self.Handle, mtError, '알림', '타석 이동 작업을 완료하지 못했습니다!' + _CRLF + sErrMsg, ['확인'], 5);
  finally
    FWorking := False;
  end;
end;

procedure TXGTeeBoxMoveForm.OnSpinEditEnter(Sender: TObject);
begin
  with TcxSpinEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxMoveForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.