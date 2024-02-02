(*******************************************************************************

  Project     : XGOLF ���������� POS �ý���
  Title       : ȯ�漳��
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
unit uXGConfig;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls, Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxCheckBox, cxMemo, cxTextEdit, cxGroupBox, cxPC, cxButtons,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGConfigForm = class(TPluginModule)
    pgcConfig: TcxPageControl;
    tabConfigBase: TcxTabSheet;
    gbxBaseInfo: TcxGroupBox;
    Label2: TLabel;
    edtClientId: TcxTextEdit;
    lblPluginVersion: TLabel;
    lblFormTitle: TLabel;
    panTabBar: TPanel;
    btnConfigBase: TcyAdvSpeedButton;
    btnSaveConfig: TcyAdvSpeedButton;
    btnConfigList: TcyAdvSpeedButton;
    edtSecretKey: TcxTextEdit;
    Label16: TLabel;
    btnCheckOAuth: TcyAdvSpeedButton;
    lblOAuthResult: TLabel;
    edtAPIServerUrl: TcxTextEdit;
    Label81: TLabel;
    Panel2: TPanel;
    tabConfigList: TcxTabSheet;
    Label12: TLabel;
    edtDeployServerUrl: TcxTextEdit;
    gbxStoreInfo: TcxGroupBox;
    Panel5: TPanel;
    mmoStoreInfo: TcxMemo;
    gbxConfigList: TcxGroupBox;
    panConfigListTitle: TPanel;
    mmoConfigList: TcxMemo;
    btnRefreshConfig: TcyAdvSpeedButton;
    panEncrypt: TPanel;
    Label1: TLabel;
    edtEncString: TcxTextEdit;
    ckbApplyToPartnerCenter: TcxCheckBox;
    btnCopyToClipboard: TcxButton;
    ckbUseLocalSetting: TcxCheckBox;
    cxGroupBox1: TcxGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edtCreditTID: TcxTextEdit;
    edtPaycoTID: TcxTextEdit;
    btnClose: TAdvShapeButton;
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCheckOAuthClick(Sender: TObject);
    procedure edtSecretKeyDblClick(Sender: TObject);
    procedure OnConfigPageButtonClick(Sender: TObject);
    procedure btnRefreshConfigClick(Sender: TObject);
    procedure panConfigListTitleDblClick(Sender: TObject);
    procedure btnCopyToClipboardClick(Sender: TObject);
    procedure ckbApplyToPartnerCenterClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ReadConfig;
    procedure WriteConfig;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  ClipBrd,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGConfigForm }

constructor TXGConfigForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I: Integer;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  panEncrypt.Visible := False;

  with pgcConfig do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;

    ActivePageIndex := 0;
  end;

  ReadConfig;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGConfigForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGConfigForm.edtSecretKeyDblClick(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    if (Properties.EchoMode = eemNormal) then
      Properties.EchoMode := eemPassword
    else
      Properties.EchoMode := eemNormal;
end;

procedure TXGConfigForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGConfigForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGConfigForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg = nil) then
    Exit;

  if (AMsg.Command = CPC_INIT) then
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TXGConfigForm.btnCheckOAuthClick(Sender: TObject);
var
  sToken, sErrMsg: string;
begin
  if Global.ClientConfig.OAuthSuccess and
     (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '�̹� ������ �ܸ��� �Դϴ�!' + _CRLF + '�ٽ� ������ �õ��Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
    Exit;

  sToken := '';
  lblOAuthResult.Caption := '���� ��û';
  try
    Global.ClientConfig.Host := edtAPIServerUrl.Text;
    if not ClientDM.GetToken(edtClientId.Text, edtSecretKey.Text, sToken, sErrMsg) then
      raise Exception.Create(sErrMsg);

    if not ClientDM.CheckToken(sToken, edtClientId.Text, edtSecretKey.Text, sErrMsg) then
      raise Exception.Create(sErrMsg);

    Global.ClientConfig.OAuthSuccess := True;
    Global.ClientConfig.OAuthToken := sToken;
    Global.ClientConfig.SecretKey := edtSecretKey.Text;
    lblOAuthResult.Caption := '���� �Ϸ�';
    XGMsgBox(Self.Handle, mtInformation, '�˸�', '�ܸ��� ������ ���������� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
  except
    on E: Exception do
    begin
      lblOAuthResult.Caption := '���� ����';
      XGMsgBox(Self.Handle, mtError, '���� ����',
        '�͹̳�ID�� Ŭ���̾�Ʈ Ű�� Ȯ���Ͽ� �ֽʽÿ�.' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

procedure TXGConfigForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGConfigForm.btnCopyToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := StrEncrypt(edtEncString.Text);
end;

procedure TXGConfigForm.btnRefreshConfigClick(Sender: TObject);
begin
  ReadConfig;
end;

procedure TXGConfigForm.OnConfigPageButtonClick(Sender: TObject);
begin
  pgcConfig.ActivePageIndex := TcyAdvSpeedButton(Sender).Tag;
end;

procedure TXGConfigForm.panConfigListTitleDblClick(Sender: TObject);
begin
  panEncrypt.Visible := (not panEncrypt.Visible);
end;

procedure TXGConfigForm.btnSaveConfigClick(Sender: TObject);
var
  sErrMsg: string;
begin
  WriteConfig;
  if ckbApplyToPartnerCenter.Checked then
    if not ClientDM.PostConfigList(sErrMsg) then
      XGMsgBox(Self.Handle, mtError, '�˸�',
        '��Ʈ�ʼ��Ϳ� ȯ�漳�� ������ �������� ���߽��ϴ�.' + _CRLF + sErrMsg, ['Ȯ��'], 5);

  ModalResult := mrOk;
end;

procedure TXGConfigForm.ckbApplyToPartnerCenterClick(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
    if Checked and
       (XGMsgBox(Self.Handle, mtConfirmation, '����',
          '����� ���� ������ ��Ʈ�ʼ��� �ܸ��� �������� �����Ͻðڽ��ϱ�?' + _CRLF +
          '����� ���� POS ����� �ÿ� �ݿ��� �Ǹ�' + _CRLF +
          '�ý��� �۵� ����� ������ �ݴϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Checked := False;
end;

procedure TXGConfigForm.ReadConfig;
begin
  if Global.ClientConfig.OAuthSuccess then
    lblOAuthResult.Caption := '���� �Ϸ�';

  mmoStoreInfo.Lines.Clear;
  mmoStoreInfo.Lines.Add(Format('�� �����ڵ�: %s', [SaleManager.StoreInfo.StoreCode]));
  mmoStoreInfo.Lines.Add(Format('�� �����: %s', [SaleManager.StoreInfo.StoreName]));
  mmoStoreInfo.Lines.Add(Format('�� ����ڹ�ȣ: %s', [SaleManager.StoreInfo.BizNo]));
  mmoStoreInfo.Lines.Add(Format('�� ����ڸ�: %s', [SaleManager.StoreInfo.Company]));
  mmoStoreInfo.Lines.Add(Format('�� ��ǥ�ڸ�: %s', [SaleManager.StoreInfo.CEO]));
  mmoStoreInfo.Lines.Add(Format('�� �ּ�: %s', [SaleManager.StoreInfo.Address]));
  mmoStoreInfo.Lines.Add(Format('�� ��ǥ��ȭ: %s', [SaleManager.StoreInfo.TelNo]));
  mmoStoreInfo.Lines.Add(Format('�� �����ð�: %s - %s', [SaleManager.StoreInfo.StoreStartTime, SaleManager.StoreInfo.StoreEndTime]));

  ckbUseLocalSetting.Checked := Global.ClientConfig.UseLocalSetting;
  edtClientId.Text := Global.ClientConfig.ClientId;
  edtAPIServerUrl.Text := Global.ClientConfig.Host;
  edtSecretKey.Text := Global.ClientConfig.SecretKey;
  edtDeployServerUrl.Text := Global.ConfigLauncher.ReadString('Config', 'UpdateURL', '');
  edtCreditTID.Text := SaleManager.StoreInfo.CreditTID;
  edtPaycoTID.Text := SaleManager.StoreInfo.PaycoTID;
  mmoConfigList.Lines.LoadFromFile(Global.ConfigFileName);
end;

procedure TXGConfigForm.WriteConfig;
var
  sUpdateUrl, sClientId, sHostUrl, sEncKey: string;
  bUseLocal: Boolean;
begin
  if FileExists(Global.ConfigFileName) then
  begin
    if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '������ ����� ���������� �����մϴ�!' + _CRLF +
        '�����ϰ� �����Ͻðڽ��ϱ�?', ['Ȯ��', '�ƴϿ�']) <> mrOK) then
      Exit;

    //���� ���
    CopyFile(PChar(Global.ConfigFileName), PChar(Global.ConfigFileName + '.' + Global.CurrentDate), False);
  end;

  sClientId := Trim(edtClientId.Text);
  sHostUrl := Trim(edtAPIServerUrl.Text);
  sEncKey := StrEncrypt(Trim(edtSecretKey.Text));
  bUseLocal := ckbUseLocalSetting.Checked;
  sUpdateUrl := Trim(edtDeployServerUrl.Text);

  with Global.ConfigRegistry do
  begin
    WriteString('Client', 'ClientId', sClientId);
    WriteString('Client', 'Host', sHostUrl);
    WriteString('Client', 'SecretKey', sEncKey);
    WriteBool('Client', 'UseLocalSetting', bUseLocal);

    WriteString('StoreInfo', 'CreditTID', Trim(edtCreditTID.Text));
    WriteString('StoreInfo', 'PaycoTID', Trim(edtPaycoTID.Text));
  end;

  Global.ConfigLauncher.WriteString('Config', 'UpdateURL', sUpdateUrl);
  mmoConfigList.Lines.SaveToFile(Global.ConfigFileName);

  with Global.ConfigLocal do
    if bUseLocal then
    begin
      WriteString('Client', 'ClientId', sClientId);
      WriteString('Client', 'Host', sHostUrl);
      WriteString('Client', 'SecretKey', sEncKey);
      Global.Config.WriteString('BackOffice', 'Host', sHostUrl);
    end else
    begin
      WriteString('Client', 'ClientId', '');
      WriteString('Client', 'Host', '');
      WriteString('Client', 'SecretKey', '');
    end;

  XGMsgBox(Self.Handle, mtInformation, '�˸�', '���������� �����Ͽ����ϴ�!', ['Ȯ��'], 5);
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGConfigForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.