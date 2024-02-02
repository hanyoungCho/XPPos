(*******************************************************************************

  Project     : XGOLF ���������� POS �ý���
  Title       : �������� �ٿ�ε�
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGPrepare;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  UbuntuProgress;

{$I ..\..\common\XGPOS.inc}

const
  LCN_PROGRESS_MAX = 20;

type
  TPrepareStatus = record
    IsLocalDB: Boolean;
    IsTerminal: Boolean;
    IsStoreInfo: Boolean;
    IsConfig: Boolean;
    IsCommonCode: Boolean;
    IsTeeBox: Boolean;
    IsLocker: Boolean;
    IsTable: Boolean;
    IsProdTeeBox: Boolean;
    IsProdLesson: Boolean;
    IsProdReserve: Boolean;
    IsProdLocker: Boolean;
    IsProdGeneral: Boolean;
    IsProdFacility: Boolean;
    IsPluList: Boolean;
    IsMember: Boolean;
    IsLessonPro: Boolean;
    IsNotice: Boolean;
    IsICReaderVerify: Boolean;
  end;

  TXGPrepareForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    pgbProgress: TUbuntuProgress;
    lblProgress: TLabel;
    btnCancel: TAdvShapeButton;
    tmrRunOnce: TTimer;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FPrepareStatus: TPrepareStatus;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoPrepare;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TPrepareForm }

constructor TXGPrepareForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  lblPluginVersion.Caption := 'PLUGIN' + _CRLF + Format('Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrRunOnce.Enabled := True;
end;

destructor TXGPrepareForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGPrepareForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGPrepareForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGPrepareForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    Self.Align := TAlign(AMsg.ParamByInteger(CPP_FORM_ALIGN));
  end;
end;

procedure TXGPrepareForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGPrepareForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    DoPrepare;
  finally
    Free;
  end;
end;

procedure TXGPrepareForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGPrepareForm.DoPrepare;
var
  nProgress: Integer;
  sJobTitle, sErrMsg: string;

  procedure ShowProgress(const AMsg: string);
  begin
    pgbProgress.Position := Trunc((nProgress / LCN_PROGRESS_MAX) * 100);
    lblProgress.Caption  := Format('[%d/%d] %s', [nProgress, LCN_PROGRESS_MAX, AMsg]);
    Application.ProcessMessages;
  end;
begin
  while True do
  begin
    try
      Screen.Cursor := crHourGlass;
      nProgress := 1;
      sJobTitle := '�ý��� �غ�';
      ShowProgress(sJobTitle);

      try
        sJobTitle := '���� �����ͺ��̽� ����'; //1
        ShowProgress(sJobTitle);
        if not FPrepareStatus.IsLocalDB then
        begin
          if Global.TeeBoxADInfo.Enabled then
            ClientDM.conTeeBox.Connected := True;

          FPrepareStatus.IsLocalDB := True;
          Inc(nProgress);
        end;

        sJobTitle := '�͹̳� ���� ����'; //2
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsTerminal) then
        begin
          FPrepareStatus.IsTerminal := ClientDM.GetTerminalInfo(sErrMsg);
          if not FPrepareStatus.IsTerminal then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '����� ���� ����'; //3
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsStoreInfo) then
        begin
          FPrepareStatus.IsStoreInfo := ClientDM.GetStoreInfo(sErrMsg);
          if not FPrepareStatus.IsStoreInfo then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := 'ȯ�漳�� ���� ����'; //4
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsConfig) then
        begin
          FPrepareStatus.IsConfig := ClientDM.GetConfigListNew(sErrMsg);
          if not FPrepareStatus.IsConfig then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '�����ڵ� ����'; //5
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsCommonCode) then
        begin
          FPrepareStatus.IsCommonCode := ClientDM.GetCodeInfo(sErrMsg);
          if not FPrepareStatus.IsCommonCode then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
        begin
          sJobTitle := 'Ÿ�� ���� ����'; //6
          ShowProgress(sJobTitle);
          if not FPrepareStatus.IsTeeBox then
          begin
            FPrepareStatus.IsTeeBox := ClientDM.GetTeeBoxList(sErrMsg);
            if not FPrepareStatus.IsTeeBox then
              raise Exception.Create(sErrMsg);
            Inc(nProgress);
          end;

          if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
          begin
            sJobTitle := '��Ŀ ���� ����'; //7
            ShowProgress(sJobTitle);
            if Global.PreparedLocker then
              FPrepareStatus.IsLocker := True;

            if (not FPrepareStatus.IsLocker) then
            begin
              FPrepareStatus.IsLocker := ClientDM.GetLockerList(sErrMsg);
              if not FPrepareStatus.IsLocker then
                raise Exception.Create(sErrMsg);
              Global.PreparedLocker := True;
              Inc(nProgress);
            end;

            sJobTitle := 'Ÿ����ǰ ���� ����'; //8
            ShowProgress(sJobTitle);
            if (not FPrepareStatus.IsProdTeeBox) then
            begin
              FPrepareStatus.IsProdTeeBox := ClientDM.GetProdTeeBoxList(sErrMsg);
              if not FPrepareStatus.IsProdTeeBox then
                raise Exception.Create(sErrMsg);
              Inc(nProgress);
            end;
          end;

          { 2023-01-03 ������ ���� ��û���� �� ���忡 ����/���� ��ǰ ���� ��� }
          sJobTitle := '������ǰ ���� ����'; //9
          ShowProgress(sJobTitle);
          if (not FPrepareStatus.IsProdLesson) then
          begin
            FPrepareStatus.IsProdLesson := ClientDM.GetProdLessonList(sErrMsg);
            if not FPrepareStatus.IsProdLesson then
              raise Exception.Create(sErrMsg);
            Inc(nProgress);
          end;

          sJobTitle := '�����ǰ ���� ����'; //10
          ShowProgress(sJobTitle);
          if (not FPrepareStatus.IsProdReserve) then
          begin
            FPrepareStatus.IsProdReserve := ClientDM.GetProdReserveList(sErrMsg);
            if not FPrepareStatus.IsProdReserve then
              raise Exception.Create(sErrMsg);
            Inc(nProgress);
          end;

          sJobTitle := '��Ŀ��ǰ ���� ����'; //11
          ShowProgress(sJobTitle);
          if (not FPrepareStatus.IsProdLocker) then
          begin
            FPrepareStatus.IsProdLocker := ClientDM.GetProdLockerList(sErrMsg);
            if not FPrepareStatus.IsProdLocker then
              raise Exception.Create(sErrMsg);
            Inc(nProgress);
          end;
        end;

        sJobTitle := '���̺�/�� ���� ����'; //12
        ShowProgress(sJobTitle);
        if (SaleManager.StoreInfo.POSType = CPO_SALE_SCREEN_ROOM) and
           (not FPrepareStatus.IsTable) then
        begin
          FPrepareStatus.IsTable := ClientDM.GetTableList(sErrMsg);
          if not FPrepareStatus.IsTable then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '�Ϲݻ�ǰ ���� ����'; //13
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsProdGeneral) then
        begin
          FPrepareStatus.IsProdGeneral := ClientDM.GetProdGeneralList(sErrMsg);
          if not FPrepareStatus.IsProdGeneral then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '�δ�ü� �̿��ǰ ���� ����'; //14
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsProdFacility) then
        begin
          FPrepareStatus.IsProdFacility := ClientDM.GetProdFacilityList(sErrMsg);
          if not FPrepareStatus.IsProdFacility then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := 'PLU ���� ����'; //15
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsPluList) then
        begin
          FPrepareStatus.IsPluList := ClientDM.GetPluList(sErrMsg);
          if not FPrepareStatus.IsPluList then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := 'ȸ�� ���� ����'; //16
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsMember) then
        begin
          FPrepareStatus.IsMember := ClientDM.GetMemberList(sErrMsg);
          if not FPrepareStatus.IsMember then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '�������� ���� ����'; //17
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsLessonPro) then
        begin
          FPrepareStatus.IsLessonPro := ClientDM.GetLessonProList('', sErrMsg);
          if not FPrepareStatus.IsLessonPro then
            raise Exception.Create(sErrMsg);
          Inc(nProgress);
        end;

        sJobTitle := '�������� ����'; //18
        ShowProgress(sJobTitle);
        if (not FPrepareStatus.IsNotice) then
        begin
          FPrepareStatus.IsNotice := ClientDM.GetNoticeList(Global.CurrentDate, sErrMsg);
          if not FPrepareStatus.IsNotice then
            XGMsgBox(Self.Handle, mtError, '�˸�',
              '��ְ� �߻��Ͽ� ���������� ��ȸ�� �� �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 3);
          Inc(nProgress);
        end;

        sJobTitle := '����IC ī��ܸ��� ���Ἲ üũ'; //19
        ShowProgress(sJobTitle);
        FPrepareStatus.IsICReaderVerify := True;
        if not FPrepareStatus.IsICReaderVerify then
        begin
          FPrepareStatus.IsICReaderVerify := ClientDM.GetICReaderVerify(sErrMsg);
          if not FPrepareStatus.IsICReaderVerify then
            XGMsgBox(Self.Handle, mtWarning, '�˸�', '����IC ī��ܸ��� ���Ἲ üũ�� �����Ͽ����ϴ�!', ['Ȯ��'], 5);
          Inc(nProgress);
        end;

        sJobTitle := '�ý��� �غ� �۾� �Ϸ�';
        ShowProgress(sJobTitle);
        ModalResult := mrOK;
        Exit;
      finally
        Screen.Cursor := crDefault;
      end;
    except
      on E: Exception do
        if (XGMsgBox(Self.Handle, mtError, 'Ȯ��',
            sJobTitle + ' �۾� �� ��ְ� �߻��Ͽ����ϴ�!' + _CRLF + E.Message,
            ['��õ�', '���']) <> mrOK) then
        begin
          ModalResult := mrCancel;
          Exit;
        end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGPrepareForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.