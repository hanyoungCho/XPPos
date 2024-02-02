(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 실내골프연습장 타석기 Agent 환경설정 화면
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-08-17   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2021 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxAgentConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.Mask,
  { DevExpress }
  dxGDIPlusClasses, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPC, cxContainer, cxEdit, cxGroupBox, cxRadioGroup,
  { TMS }
  AdvShapeButton,
  { SolbiLib }
  cyEdit, cyEditInteger;

{$I ..\common\XGTeeBoxAgent.inc}

type
  TConfigForm = class(TForm)
    panBody: TPanel;
    imgBack: TImage;
    Label1: TLabel;
    btnClose: TAdvShapeButton;
    pgcConfig: TcxPageControl;
    tabConfigBase: TcxTabSheet;
    tabConfigServer: TcxTabSheet;
    gbxBaseSettings: TGroupBox;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    cbxTeeBoxVendor: TComboBox;
    gbxServer: TGroupBox;
    edtAPIServerClientId: TLabeledEdit;
    edtAPIServerHost: TLabeledEdit;
    edtAPIServerApiKey: TLabeledEdit;
    gbxTeeBoxAD: TGroupBox;
    Label2: TLabel;
    edtTeeBoxADHost: TLabeledEdit;
    edtTeeBoxADPort: TcyEditInteger;
    panFooter: TPanel;
    btnApply: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edtMainLeft: TcyEditInteger;
    edtMainTop: TcyEditInteger;
    edtMainWidth: TcyEditInteger;
    edtMainHeight: TcyEditInteger;
    edtScreenLeft: TcyEditInteger;
    edtScreenTop: TcyEditInteger;
    edtScreenWidth: TcyEditInteger;
    edtScreenHeight: TcyEditInteger;
    btnAPIServerCerfiticate: TButton;
    edtStoreCode: TLabeledEdit;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ckbLogDelete: TCheckBox;
    edtLogDeleteDays: TcyEditInteger;
    btnDeleteLog: TButton;
    Label4: TLabel;
    edtTeeBoxNo: TSpinEdit;
    cbxAPIServerProvider: TComboBox;
    Label18: TLabel;
    ckbTeeBoxDualScreen: TCheckBox;
    tabLauncher: TcxTabSheet;
    lbxExtAppList: TListView;
    Panel1: TPanel;
    edtExtAppName: TLabeledEdit;
    edtExtAppParams: TLabeledEdit;
    Label16: TLabel;
    edtExtAppDelay: TcyEditInteger;
    Panel2: TPanel;
    edtUpdateUrl: TLabeledEdit;
    btnExtAppAdd: TButton;
    btnExtAppDelete: TButton;
    btnExtAppUp: TButton;
    btnExtAppDown: TButton;
    btnExtAppFile: TBitBtn;
    Label19: TLabel;
    edtWatchInterval: TcyEditInteger;
    Label21: TLabel;
    edtTeeBoxADTimeout: TcyEditInteger;
    Label22: TLabel;
    edtAPIServerTimeout: TcyEditInteger;
    edtAgentServerPort: TcyEditInteger;
    Label23: TLabel;
    Label11: TLabel;
    edtMainRemainLeft: TcyEditInteger;
    Label17: TLabel;
    edtMainRemainTop: TcyEditInteger;
    edtScreenRemainLeft: TcyEditInteger;
    edtScreenRemainTop: TcyEditInteger;
    Label20: TLabel;
    Label24: TLabel;
    rdgTeeBoxLeftHanded: TcxRadioGroup;
    Label5: TLabel;
    edtWaitingIdleTime: TcyEditInteger;
    ckbShowMouseCursor: TCheckBox;
    Label25: TLabel;
    edtShutdownTimeout: TSpinEdit;
    Label26: TLabel;
    Label27: TLabel;
    ckbTeeBoxScreenOnOff: TCheckBox;
    edtRunAppName: TLabeledEdit;
    edtRunAppParams: TLabeledEdit;
    Label28: TLabel;
    edtRunAppDelay: TcyEditInteger;
    ckbRebootWhenUpdated: TCheckBox;
    ckbAppAutoStart: TCheckBox;
    ckbHideTaskBar: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAPIServerCerfiticateClick(Sender: TObject);
    procedure cbxAPIServerProviderChange(Sender: TObject);
    procedure edtAPIServerApiKeyDblClick(Sender: TObject);
    procedure btnExtAppAddClick(Sender: TObject);
    procedure btnExtAppDeleteClick(Sender: TObject);
    procedure lbxExtAppListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnExtAppUpClick(Sender: TObject);
    procedure btnExtAppDownClick(Sender: TObject);
    procedure btnExtAppFileClick(Sender: TObject);
  private
    { Private declarations }
    function GetExtAppList: string;
    procedure SetExtAppList(const AValue: string);
  public
    { Public declarations }
    procedure RefreshControl;

    property ExtAppList: string read GetExtAppList write SetExtAppList;
  end;

var
  ConfigForm: TConfigForm;

implementation

uses
  { Native }
  System.StrUtils,
  { Project }
  uXGTeeBoxAgentDM, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TConfigForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  pgcConfig.ActivePageIndex := 0;
end;

procedure TConfigForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  LF := nil;
end;

procedure TConfigForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Close;
end;

procedure TConfigForm.RefreshControl;
var
  bEnabled: Boolean;
begin
  bEnabled := (cbxAPIServerProvider.ItemIndex = SSP_XPARTNERS);
  edtAPIServerApiKey.EditLabel.Caption := IfThen(cbxAPIServerProvider.ItemIndex = SSP_ELOOM, 'API 키', '시크릿');
  btnAPIServerCerfiticate.Enabled := bEnabled;
end;

function TConfigForm.GetExtAppList: string;
var
  I: Integer;
begin
  Result := '';
  with lbxExtAppList do
    for I := 0 to Pred(Items.Count) do
      Result := Result + Format('%s%s,%s,%s', [IfThen(Result.IsEmpty, '', ';'), Items[I].Caption, Items[I].SubItems[0], Items[I].SubItems[1]]);
end;

procedure TConfigForm.SetExtAppList(const AValue: string);
var
  A1, A2: TArray<string>;
  I: Integer;
begin
  lbxExtAppList.Items.Clear;
  A1 := SplitString(AValue, ';');
  for I := 0 to Length(A1) - 1 do
  begin
    A2 := SplitString(A1[I], ',');
    if (Length(A2) = 3) then
      with lbxExtAppList.Items.Add do
      begin
        Caption := A2[0];
        SubItems.Add(A2[1]);
        SubItems.Add(IntToStr(StrToIntDef(A2[2], 0)));
      end;
  end;
end;

procedure TConfigForm.lbxExtAppListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Assigned(lbxExtAppList.Selected) then
    with lbxExtAppList.Selected do
    begin
      edtExtAppName.Text := Caption;
      edtExtAppParams.Text := SubItems[0];
      edtExtAppDelay.Value := StrToIntDef(SubItems[1], 0);
    end;
end;

procedure TConfigForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TConfigForm.btnExtAppAddClick(Sender: TObject);
begin
  if (Trim(edtExtAppName.Text) = '') then
    Exit;

  with lbxExtAppList.Items.Add do
  begin
    Caption := edtExtAppName.Text;
    SubItems.Add(edtExtAppParams.Text);
    SubItems.Add(IntToStr(edtExtAppDelay.Value));
  end;
end;

procedure TConfigForm.btnExtAppDeleteClick(Sender: TObject);
begin
  if Assigned(lbxExtAppList.Selected) then
    lbxExtAppList.DeleteSelected;
end;

procedure TConfigForm.btnExtAppUpClick(Sender: TObject);
begin
  if Assigned(lbxExtAppList.Selected) and (lbxExtAppList.Selected.Index > 0) then
    ExchangeListItems(lbxExtAppList, lbxExtAppList.Selected.Index, lbxExtAppList.Selected.Index - 1);
end;

procedure TConfigForm.btnExtAppDownClick(Sender: TObject);
begin
  if Assigned(lbxExtAppList.Selected) and (lbxExtAppList.Selected.Index < lbxExtAppList.Items.Count - 1) then
    ExchangeListItems(lbxExtAppList, lbxExtAppList.Selected.Index, lbxExtAppList.Selected.Index + 1);
end;

procedure TConfigForm.btnExtAppFileClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  try
    InitialDir := Global.HomeDir;
    Filter := 'Executable files(*.exe)|*.exe|All files(*.*)|*.*';
    if Execute then
      edtExtAppName.Text := FileName;
  finally
    Free;
  end;
end;

procedure TConfigForm.cbxAPIServerProviderChange(Sender: TObject);
begin
  RefreshControl;
end;

procedure TConfigForm.edtAPIServerApiKeyDblClick(Sender: TObject);
begin
  if (Global.APIServer.Provider = SSP_ELOOM) then
    Exit;

  with TLabeledEdit(Sender) do
    if (PasswordChar = #0) then
      PasswordChar := '*'
    else
      PasswordChar := #0;
end;

procedure TConfigForm.btnAPIServerCerfiticateClick(Sender: TObject);
var
  sHost, sClientId, sApiKey, sToken, sErrMsg: string;
begin
  try
    sToken := '';
    sHost := edtAPIServerHost.Text;
    sClientId := edtAPIServerClientId.Text;
    sApiKey := edtAPIServerApiKey.Text;

    if sHost.IsEmpty or
       sClientId.IsEmpty or
       sApiKey.IsEmpty then
      raise Exception.Create('접속 정보가 올바르지 않습니다.');

    Global.APIServer.Host := sHost;
    if not DM.GetToken(sClientId, sApiKey, sToken, sErrMsg) then
      raise Exception.Create(sErrMsg);

    if not DM.CheckToken(sToken, sClientId, sApiKey, sErrMsg) then
      raise Exception.Create(sErrMsg);

    MessageBox(0, PChar('단말기 인증 테스트가 성공하였습니다.'), PChar('알림'), MB_ICONINFORMATION or MB_OK or MB_TOPMOST or MB_APPLMODAL);
  except
    on E: Exception do
      MessageBox(0, PChar('단말기 인증 테스트에 실패하였습니다.' + #13#10 + E.Message), PChar('알림'), MB_ICONERROR or MB_OK or MB_TOPMOST or MB_APPLMODAL);
  end;
end;

procedure TConfigForm.btnApplyClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TConfigForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
