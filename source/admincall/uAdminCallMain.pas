{$M+}
unit uAdminCallMain;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Forms, Graphics, Controls, ExtCtrls, Buttons,
  IniFiles, Vcl.Menus,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics,
  { Indy }
  IdBaseComponent, IdComponent, IdContext, IdCustomTCPServer, IdTCPServer,
  { TMS }
  AdvShapeButton, AdvMenus,
  { SolbiLib }
  TransparentForm, cyBaseSpeedButton, cySpeedButton, MSNPopUp;

const
  WM_NOTIFY_PUSH_POPUP = WM_USER + 3000;

type
  TNotifyStatusThread = class(TThread)
  private
    FNotifyActive: Boolean;
    FLastWorked: TDateTime;
    FInterval: Integer;
    FErrorMode: Boolean;
    FErrorCode: Integer;
    FErrorMsg: string;
    FBlinked: Boolean;

    procedure SetErrorCode(const AValue: Integer);
  protected
    procedure Execute; override;
  published
    constructor Create(const ACreateSuspended: Boolean);
    destructor Destroy; override;

    property NotifyActive: Boolean read FNotifyActive write FNotifyActive;
    property Interval: Integer read FInterval write FInterval default 300;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
    property ErrorCode: Integer read FErrorCode write SetErrorCode;
    property ErrorMsg: string read FErrorMsg write FErrorMsg;
  end;

  TXGAdminCallForm = class(TForm)
    TransparentForm: TTransparentForm;
    imcStatus: TcxImageCollection;
    itmBlinkOn: TcxImageCollectionItem;
    itmBlinkOff: TcxImageCollectionItem;
    tcpServer: TIdTCPServer;
    imgBack: TImage;
    imgNotify: TImage;
    PopupMenu: TPopupMenu;
    mniConfig: TMenuItem;
    mniClose: TMenuItem;
    tmrClock: TTimer;
    itmReady: TcxImageCollectionItem;
    msnPopup: TMSNPopUp;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tcpServerExecute(AContext: TIdContext);
    procedure tmrClockTimer(Sender: TObject);
    procedure imgNotifyDblClick(Sender: TObject);
    procedure mniConfigClick(Sender: TObject);
    procedure mniCloseClick(Sender: TObject);
    procedure imgNotifyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure msnPopupClick(Sender: TObject);
  private
    { Private declarations }
    FClosing: Boolean;
    FIniFile: TIniFile;
    FHomeDir: string;
    FConfigDir: string;
    FIsFirst: Boolean;
    FServerPort: Integer;

    procedure WindowPosChange(var AMessage: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure ShowConfig;
    procedure CheckConfig;
    procedure ReadConfig;
    procedure UpdateConfig;
    procedure UpdateLog(const AValue: string);
  protected
    procedure CreateParams(var AParams: TCreateParams); override;
    procedure WndProc(var AMsg: TMessage); override;
  public
    { Public declarations }
  end;

var
  XGAdminCallForm: TXGAdminCallForm;
  FMediaDir: string;
  FNotifyWithPopup: Boolean;
  FNotifyWithSound: Boolean;
  FNotifyDuration: Integer;
  FNotifyStatusThread: TNotifyStatusThread;
  FLogList: TStrings;
  FLogCS: TRTLCriticalSection;

implementation

uses
  DateUtils, Dialogs, IdGlobal, IdException, IdStack, JSON, MMSystem,
  uConfigForm;

{$R *.dfm}

procedure FreeAndNilJSONObject(AObject: TJSONAncestor);
begin
  try
    if Assigned(AObject) then
    begin
      AObject.Owned := False;
      AObject.Free;
    end;
  except
  end;
end;

function GetAppVersion(const AIndex: integer): string;
const
  VERSION_INFO: array[0..9] of string = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments');
var
  s, Locale: string;
  n, Len: DWORD;
  P: Pointer;
  Buf: PChar;
  Value: PChar;
begin
  Result := '?';
  s := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(s), n);
  if (n > 0) then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(s), 0, n, Buf);
      VerQueryValue(Buf, 'VarFileInfo\Translation', P, Len);
      Locale := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
      if VerQueryValue(Buf, PChar('StringFileInfo\' + Locale + '\' + VERSION_INFO[AIndex]), Pointer(Value), Len) then
        Result := Trim(Value);
    finally
      FreeMem(Buf, n);
    end;
  end;
end;

{ TXGAdminCallForm }

procedure TXGAdminCallForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.WndParent := 0;
end;

procedure TXGAdminCallForm.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_NOTIFY_PUSH_POPUP:
      begin
        msnPopup.Text := FormatDateTime('[yyyy-mm-dd hh:nn:ss]', Now) + #13#10 + FNotifyStatusThread.ErrorMsg;
        msnPopup.TextAlignment := taLeftJustify;
        msnPopup.ShowPopUp;
      end;
  end;

  inherited WndProc(AMsg);
end;

procedure TXGAdminCallForm.WindowPosChange(var AMessage: TWMWindowPosChanging);
begin
  //AMessage.WindowPos.X := Left; //Can't X Position Movable
  AMessage.WindowPos.Y := 0; //Can't Y Position Movable
  AMessage.Result := 0;
end;

procedure TXGAdminCallForm.FormCreate(Sender: TObject);
begin
  imgBack.Visible := True;

  FIsFirst := True;
  FLogList := TStringList.Create;
  FHomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FConfigDir := FHomeDir + 'config\';
  FMediaDir := FHomeDir + 'media\';
  ForceDirectories(FConfigDir);

  Self.Height := imgBack.Height;
  Self.Width := imgBack.Width;
  Self.FormStyle := fsStayOnTop;
  imgNotify.Picture.Assign(XGAdminCallForm.imcStatus.Items[0].Picture);
  imgNotify.Hint := '���콺�� �巡���Ͽ� ��ġ�� ������ �� �ֽ��ϴ�.';

  FIniFile := TIniFile.Create(FConfigDir + ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.config');
  CheckConfig;
  ReadConfig;

  tmrClock.Enabled := True;
end;

procedure TXGAdminCallForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tcpServer.Active := False;
  UpdateConfig;
  FreeAndNil(FLogList);
end;

procedure TXGAdminCallForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FClosing;
end;

procedure TXGAdminCallForm.imgNotifyDblClick(Sender: TObject);
begin
  FNotifyStatusThread.ErrorCode := 0;
  msnPopup.ClosePopUps;
end;

procedure TXGAdminCallForm.imgNotifyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TXGAdminCallForm.msnPopupClick(Sender: TObject);
begin
  msnPopup.ClosePopUps;
end;

procedure TXGAdminCallForm.mniConfigClick(Sender: TObject);
begin
  ShowConfig;
end;

procedure TXGAdminCallForm.mniCloseClick(Sender: TObject);
begin
  FClosing := True;
  Close;
end;

procedure TXGAdminCallForm.tcpServerExecute(AContext: TIdContext);
var
  RBS: RawByteString;
  JO, RO: TJSONObject;
  nErrorCode: Integer;
  sErrorMsg, sPeerIP, sSenderId, sResultCode, sResultMsg: string;
begin
  if (AContext.Connection = nil) or
     (not AContext.Connection.Connected) then
    Exit;

  try
    sResultCode := '9999';
    sResultMsg := '��ְ� �߻��Ͽ� ��û�� ó���� �� �����ϴ�.';
    JO := nil;
    RO := nil;
    try
      AContext.Connection.IOHandler.MaxLineLength := MaxInt;
      sPeerIP := AContext.Connection.Socket.Binding.PeerIP;
      RBS := AContext.Connection.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      try
        JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        RO := TJSONObject.Create;
        if JO.FindValue('error_cd').Null then
        begin
          sResultCode := '9991';
          sResultMsg := '�߸��� ��û ���� = ' + JO.ToString;
          raise Exception.Create('Error Message');
        end;

        nErrorCode := StrToIntDef(JO.GetValue('error_cd').Value, -1);
        sErrorMsg := JO.GetValue('error_msg').Value;
        sSenderId := JO.GetValue('sender_id').Value;
        if (nErrorCode >= 0) then
        begin
          FNotifyStatusThread.ErrorMsg := sErrorMsg;
          FNotifyStatusThread.ErrorCode := nErrorCode;
          if FNotifyWithPopup then
            SendMessage(Self.Handle, WM_NOTIFY_PUSH_POPUP, 0, 0);

          UpdateLog(Format('%s %s %s', [sPeerIP, sSenderId, FNotifyStatusThread.ErrorMsg]));
        end;

        sResultCode := '0000';
        sResultMsg := '���������� ó�� �Ǿ����ϴ�.';
      except
        on E: Exception do
          UpdateLog(Format('ServerExecute.ListenError=%s', [E.Message]));
      end;

      RO.AddPair(TJSONPair.Create('result_cd', sResultCode));
      RO.AddPair(TJSONPair.Create('result_msg', sResultMsg));
      AContext.Connection.IOHandler.WriteLn(RO.ToString, IndyTextEncoding_UTF8);
    finally
      AContext.Connection.Disconnect;
      FreeAndNilJSONObject(JO);
      FreeAndNilJSONObject(RO);
    end;
  except
    on E: EIdConnClosedGracefully do;
    on E: EIdSocketError do;
    on E: Exception do
    begin
      sResultCode := '9999';
      sResultMsg := E.Message;
      UpdateLog(Format('ServerExecute.SocketError=%s', [E.Message]));
    end;
  end;
end;

procedure TXGAdminCallForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    try
      Enabled := False;
      if FIsFirst then
      begin
        FIsFirst := False;
        Interval := 500;

        if not Assigned(FNotifyStatusThread) then
          FNotifyStatusThread := TNotifyStatusThread.Create(True);
        if (not FNotifyStatusThread.Started) then
          FNotifyStatusThread.Start;

        tcpServer.DefaultPort := FServerPort;
        tcpServer.Active := True;

        msnPopup.Title := 'XTouch �˸���';
        msnPopup.Text := '�˸��� ���α׷��� ���� �Ǿ����ϴ�.';
        msnPopup.ShowPopUp;
        UpdateLog('���α׷� ����');
      end;
    finally
      Enabled := True;
    end;
  except
  end;
end;

procedure TXGAdminCallForm.ShowConfig;
var
  CF: TConfigForm;
  nPort: Integer;
begin
  CF := TConfigForm.Create(nil);
  try
    CF.Caption := ' XTouch �˸��� v' + GetAppVersion(2);
    CF.Top := (Self.Top + Self.Height);
    CF.Left := Self.Left;
    CF.edtServerPort.Value := FServerPort;
    CF.edtNotifyDuration.Value := FNotifyDuration;
    CF.ckbNotifyWithPopup.Checked := FNotifyWithPopup;
    CF.ckbNotifyWithSound.Checked := FNotifyWithSound;
    CF.lbxLogView.Items.AddStrings(FLogList);
    if (CF.ShowModal = mrOK) then
    begin
      FNotifyDuration := Trunc(CF.edtNotifyDuration.Value);
      FNotifyWithPopup := CF.ckbNotifyWithPopup.Checked;
      FNotifyWithSound := CF.ckbNotifyWithSound.Checked;
      nPort := Trunc(CF.edtServerPort.Value);
      if (FServerPort <> nPort) then
      begin
        FServerPort := nPort;
        tcpServer.Active := False;
        tcpServer.DefaultPort := FServerPort;
        tcpServer.Active := True;
      end;
      msnPopup.TimeOut := FNotifyDuration;
    end;
  finally
    CF.Close;
  end;
end;

procedure TXGAdminCallForm.CheckConfig;
begin
  with FIniFile do
  begin
    if not SectionExists('Config') then
    begin
      WriteInteger('Config', 'Left', 430);
      WriteInteger('Config', 'ServerPort', 6001);
      WriteInteger('Config', 'NotifyDuration', 0);
      WriteBool('Config', 'NotifyWithPopup', False);
      WriteBool('Config', 'NotifyWithSound', False);
    end;
  end;
end;

procedure TXGAdminCallForm.ReadConfig;
begin
  with FIniFile do
  begin
    Self.Top := 0;
    Self.Left := ReadInteger('Config', 'Left', 430);
    FServerPort := ReadInteger('Config', 'ServerPort', 6001);
    FNotifyWithPopup := ReadBool('Config', 'NotifyWithPopup', False);
    FNotifyWithSound := ReadBool('Config', 'NotifyWithSound', False);
    FNotifyDuration := ReadInteger('Config', 'NotifyDuration', 0);
    msnPopup.TimeOut := FNotifyDuration;
  end;
end;

procedure TXGAdminCallForm.UpdateConfig;
begin
  with FIniFile do
  begin
    if (ReadInteger('Config', 'Left', 430) <> Self.Left) then
      WriteInteger('Config', 'Left', Self.Left);

    if (ReadInteger('Config', 'ServerPort', 6001) <> tcpServer.DefaultPort) then
      WriteInteger('Config', 'ServerPort', tcpServer.DefaultPort);

    if (ReadInteger('Config', 'NotifyDuration', 0) <> FNotifyDuration) then
      WriteInteger('Config', 'NotifyDuration', FNotifyDuration);

    if (ReadBool('Config', 'NotifyWithPopup', False) <> FNotifyWithPopup) then
      WriteBool('Config', 'NotifyWithPopup', FNotifyWithPopup);

    if (ReadBool('Config', 'NotifyWithSound', False) <> FNotifyWithSound) then
      WriteBool('Config', 'NotifyWithSound', FNotifyWithSound);
  end;
end;

procedure TXGAdminCallForm.UpdateLog(const AValue: string);
begin
  with FLogList do
  try
    if (FLogList.Count > 100) then
      FLogList.Delete(0);
    FLogList.Add(Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now), AValue]));
  except
  end;
end;

{ TNotifyStatusThread }

constructor TNotifyStatusThread.Create;
begin
  inherited Create(ACreateSuspended);

  FreeOnTerminate := True;
  FInterval := 300;
  FLastworked := (Now - 1);
  FErrorCode := 0; //0: No Error
end;

destructor TNotifyStatusThread.Destroy;
begin

  inherited;
end;

procedure TNotifyStatusThread.Execute;
begin
  inherited;

  repeat
    if (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FLastWorked := Now;
      Synchronize(
        procedure
        begin
          if FErrorMode then
          begin
            FBlinked := (not FBlinked);
            if FBlinked then
              XGAdminCallForm.imgNotify.Picture.Assign(XGAdminCallForm.imcStatus.Items[1].Picture)
            else
              XGAdminCallForm.imgNotify.Picture.Assign(XGAdminCallForm.imcStatus.Items[2].Picture);
          end;
        end);
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

procedure TNotifyStatusThread.SetErrorCode(const AValue: Integer);
const
  LCS_ERROR = 'popup.wav';
begin
  if (FErrorCode <> AValue) then
  begin
    FErrorCode := AValue;
    FErrorMode := (FErrorCode <> 0);
    if FErrorMode then
    begin
      XGAdminCallForm.imgNotify.Hint := '���콺�� ���� Ŭ���Ͽ� �������� ������ŵ�ϴ�.';
      if FNotifyWithSound and
         FileExists(FMediaDir + LCS_ERROR) then
      begin
        sndPlaySound(PChar(FMediaDir + LCS_ERROR), SND_SYNC);
      end;
    end else
    begin
      XGAdminCallForm.imgNotify.Hint := '';
      XGAdminCallForm.imgNotify.Picture.Assign(XGAdminCallForm.imcStatus.Items[0].Picture);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(FLogCS);
finalization
  DeleteCriticalSection(FLogCS);
end.
