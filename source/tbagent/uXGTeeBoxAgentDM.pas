(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 실내골프연습장 타석기 Agent II 공용 유닛
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    2.0.0.0   2022-10-31   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2022 All rights reserved.

*******************************************************************************)
{$M+}
unit uXGTeeBoxAgentDM;

interface

uses
  { Native }
  System.Classes, System.IniFiles, Winapi.Windows, Vcl.StdCtrls,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics;

{$I ..\common\XGCommon.inc}
{$I ..\common\XGTeeBoxAgent.inc}

const
  INI_SECTION_CONFIG        = 'Config';
  INI_SECTION_FORM_MAIN     = 'Main';
  INI_SECTION_FORM_SCREEN   = 'Screen';
  INI_SECTION_TEEBOX        = 'TeeBox';
  INI_SECTION_API_SERVER    = 'APIServer';
  INI_SECTION_LOCAL_SERVER  = 'LocalServer';
  INI_SECTION_LAUNCHER      = 'Launcher';

type
  { 런처 설정 정보 }
  TLauncherInfo = record
    UpdateUrl: string;
    RunAppName: string;
    RunAppParams: string;
    RunAppDelay: Integer;
    WatchInterval: Integer;
    RebootWhenUpdated: Boolean;
    ExtAppList: string;
  end;

  { 타석 설정 정보 }
  TTeeBoxInfo = record
    TeeBoxNo: Integer;
    AgentPort: Integer;
    Vendor: Integer;
    LeftHanded: Boolean;
    DualScreen: Boolean;
    ScreenOnOff: Boolean;
    LogoutMacro: string;
  end;

  { 화면 설정 정보 }
  TFormInfo = record
    Top: Integer;
    Left: Integer;
    Height: Integer;
    Width: Integer;
    RemainTop: Integer;
    RemainLeft: Integer;
  end;

  { API서버 설정 정보 }
  TAPIServerInfo = record
    Provider: Integer; //0:엑스파트너스, 1:이룸
    Host: string;
    Port: Integer;
    Timeout: Integer;
    ApiKey: string;
    ClientId: string;
    Token: string;
    Connected: Boolean;
  end;

  { 타석기AD 설정 정보 }
  TTeeBoxADInfo = record
    Connected: Boolean;
    Host: string;
    Port: Integer;
    Timeout: Integer;
  end;

  { 환경 설정 정보 }
  TGlobalInfo = class
  private
    { Private declarations }
    FStoreCode: string;
    FStoreStartTime: string; //영업시작 시각(hh:mm)
    FStoreEndTime: string; //영업종료 시각(hh:mm)
    FShutdownTimeout: Integer; //영업종료 시 PC 자동 셧다운 여부(0: 미사용, 0<: 영업종료 시각 이후 지정한 값(분) 대기 후 자동 셧다운)
    FClosing: Boolean;
    FAppName: string;
    FAppAutoStart: Boolean; //부팅 시 프로그램 자동 실행
    FShowMouseCursor: Boolean;
    FHideTaskBar: Boolean;
    FWaitingIdleTime: Integer;
    FHomeDir: string;
    FConfigDir: string;
    FContentsDir: string;
    FDownloadDir: string;
    FLogDir: string;
    FLogFileName: string;
    FLogDelete: Boolean;
    FLogDeleting: Boolean;
    FLogDeleted: Boolean;
    FLogDeleteDays: Integer;
    FConfigUpdated: string;
    FBackgroundImageFile: string;
    FAgentIniFileName: string;
    FPublicIP: string;
    FLocalIP: string;
    FMacAddr: string;
    FDownloading: Boolean;
    FClosingApp: string;

    FCurrentDate: string;
    FFormattedCurrentDate: string;
    FCurrentDateTime: string;
    FFormattedCurrentDateTime: string;
    FLastDate: string;
    FFormattedLastDate: string;
    FNextDate: string;
    FFormattedNextDate: string;
    FDayOfWeekKR: string;
    FCurrentTime: string;
    FFormattedCurrentTime: string;

    procedure ContentsListClear(AList: TList);
    procedure ContentItemAdd(AList: TList; const AOrderNo, APlayTime: Integer;
      const AFileUrl, AFileName: string; const AStretch: Boolean; const AStartDate, AEndDate, AStartTime, AEndTime: string);
  public
    { Public declarations }
    APIServer: TAPIServerInfo;
    TeeBoxADInfo: TTeeBoxADInfo;
    Launcher: TLauncherInfo;
    TeeBoxInfo: TTeeBoxInfo;
    MainFormInfo: TFormInfo;
    ScreenFormInfo: TFormInfo;
    AgentIniFile: TIniFile;
    LauncherIniFile: TIniFile;
    MainContents: TList;
    ScreenContents: Tlist;
    LogListControl: TListBox;

    constructor Create;
    destructor Destroy; override;

    property StoreCode: string read FStoreCode write FStoreCode;
    property StoreStartTime: string read FStoreStartTime write FStoreStartTime;
    property StoreEndTime: string read FStoreEndTime write FStoreEndTime;
    property ShutdownTimeout: Integer read FShutdownTimeout write FShutdownTimeout default 0;
    property Closing: Boolean read FClosing write FClosing;
    property AppName: string read FAppName write FAppName;
    property AppAutoStart: Boolean read FAppAutoStart write FAppAutoStart;
    property ShowMouseCursor: Boolean read FShowMouseCursor write FShowMouseCursor;
    property HideTaskBar: Boolean read FHideTaskBar write FHideTaskBar;
    property WaitingIdleTime: Integer read FWaitingIdleTime write FWaitingIdleTime default 0;
    property HomeDir: string read FHomeDir write FHomeDir;
    property ConfigDir: string read FConfigDir write FConfigDir;
    property ContentsDir: string read FContentsDir write FContentsDir;
    property DownloadDir: string read FDownloadDir write FDownloadDir;
    property LogDir: string read FLogDir write FLogDir;
    property LogFileName: string read FLogFileName write FLogFileName;
    property LogDelete: Boolean read FLogDelete write FLogDelete;
    property LogDeleting: Boolean read FLogDeleting write FLogDeleting;
    property LogDeleted: Boolean read FLogDeleted write FLogDeleted;
    property LogDeleteDays: Integer read FLogDeleteDays write FLogDeleteDays default 0;
    property ConfigUpdated: string read FConfigUpdated write FConfigUpdated;
    property BackgroundImageFile: string read FBackgroundImageFile write FBackgroundImageFile;
    property AgentIniFileName: string read FAgentIniFileName write FAgentIniFileName;
    property PublicIP: string read FPublicIP write FPublicIP;
    property LocalIP: string read FLocalIP write FLocalIP;
    property MacAddr: string read FMacAddr write FMacAddr;
    property Downloading: Boolean read FDownloading write FDownloading default False;
    property ClosingApp: string read FClosingApp write FClosingApp;

    property CurrentDate: string read FCurrentDate write FCurrentDate;
    property FormattedCurrentDate: string read FFormattedCurrentDate write FFormattedCurrentDate;
    property CurrentDateTime: string read FCurrentDateTime write FCurrentDateTime;
    property FormattedCurrentDateTime: string read FFormattedCurrentDateTime write FFormattedCurrentDateTime;
    property LastDate: string read FLastDate write FLastDate;
    property FormattedLastDate: string read FFormattedLastDate write FFormattedLastDate;
    property NextDate: string read FNextDate write FNextDate;
    property FormattedNextDate: string read FFormattedNextDate write FFormattedNextDate;
    property DayOfWeekKR: string read FDayOfWeekKR write FDayOfWeekKR;
    property CurrentTime: string read FCurrentTime write FCurrentTime;
    property FormattedCurrentTime: string read FFormattedCurrentTime write FFormattedCurrentTime;
  end;

  TDM = class(TDataModule)
    imcServiceVender: TcxImageCollection;
    iciServiceProvider0: TcxImageCollectionItem;
    iciServiceProvider1: TcxImageCollectionItem;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

    function ExecuteServer(const AUrl, AApiName, AMethod: string; const AReqJSON: string; var ARespJSON: string; AErrMsg: string): Boolean;
    function GetToken(const AClientId, AClientKey: string; var AToken, AErrMsg: string): Boolean;
    function CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
    function CheckAlive(var AErrMsg: string): Boolean;
    function GetStoreInfo(var AErrMsg: string): Boolean;
    function GetConfigInfo_ELOOM(var AIniData, AErrMsg: string): Boolean;
    function GetContentsList(var AErrMsg: string): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;
  Global: TGlobalInfo;

procedure AddLog(const ALogStr: string; const AWriteFile: Boolean=True);

implementation

uses
  { Native }
  System.SysUtils,
  { Indy }
  IdGlobal, IdSSLOpenSSL, IdHTTP, IdURI,
  { Chilkat }
  Chilkat.JsonObject, Chilkat.JsonArray,
  { Project }
  uXGCommonLib, uMediaPlayThread;

{$R *.dfm}

procedure AddLog(const ALogStr: string; const AWriteFile: Boolean);
var
  sLogTime: string;
begin
  if Assigned(Global.LogListControl) then
  begin
    if (Global.LogListControl.Count > 1024) then
      Global.LogListControl.Items.Delete(0);

    sLogTime := '[' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + '] ';
    Global.LogListControl.Items.Add(sLogTime + ALogStr);
    Global.LogListControl.ItemIndex := Pred(Global.LogListControl.Items.Count);
  end;

  if AWriteFile and
     (not Global.LogFileName.IsEmpty) then
    WriteToFile(Global.LogFileName, sLogTime + ALogStr);
end;

function CompareList(AItem1, AItem2: Pointer): Integer;
var
  pItem1, pItem2: ^string;
Begin
  pItem1 := AItem1;
  pItem2 := AItem2;
  if (pItem1^ < pItem2^) then
    Result := -1
  else if (pItem1^ = pItem2^) then
    Result := 0
  else
    Result := 1;
end;

{ TGlobalInfo }

constructor TGlobalInfo.Create;
begin
  inherited;

  AppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  HomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  ConfigDir := HomeDir + 'config\';
  ContentsDir := HomeDir + 'contents\';
  DownloadDir := HomeDir + 'download\';
  LogDir := HomeDir + 'log\';
  LogFileName := Format('%s%s_%s.log', [LogDir, AppName, FormatDateTime('yyyymmdd', Now)]);
  AgentIniFileName := ConfigDir + AppName + '.config';
  AgentIniFile := TIniFile.Create(AgentIniFileName);
  LauncherIniFile := TIniFile.Create(ConfigDir + 'XGLauncher.config');

  ForceDirectories(ConfigDir);
  ForceDirectories(ContentsDir);
  ForceDirectories(DownloadDir);
  ForceDirectories(LogDir);

  MainContents := TList.Create;
  ScreenContents := TList.Create;
end;

destructor TGlobalInfo.Destroy;
begin
  FreeAndNil(LauncherIniFile);
  FreeAndNil(AgentIniFile);
  ContentsListClear(ScreenContents);
  ContentsListClear(MainContents);

  inherited;
end;

procedure TGlobalInfo.ContentsListClear(AList: TList);
var
  P: PContentInfo;
  I: Integer;
begin
  with AList do
  try
    for I := Pred(Count) downto 0 do
    begin
      P := Items[I];
      if (P <> nil) then
        Dispose(P);
    end;
  finally
    Clear;
  end;
end;

procedure TGlobalInfo.ContentItemAdd(AList: TList; const AOrderNo, APlayTime: Integer;
  const AFileUrl, AFileName: string; const AStretch: Boolean; const AStartDate, AEndDate, AStartTime, AEndTime: string);
var
  CI: PContentInfo;
begin
  New(CI);
  with CI^ do
  try
    OrderNo := AOrderNo;
    FileUrl := AFileUrl;
    FileName := AFileName;
    PlayTime := APlayTime;
    Stretch := AStretch;
    StartDate := AStartDate;
    EndDate := AEndDate;
    StartTime := AStartTime;
    EndTime := AEndTime;
    AList.Add(CI);
  except
    Dispose(CI);
  end;
end;

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Global := TGlobalInfo.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  Global.Free;
end;

function TDM.GetToken(const AClientId, AClientKey: string; var AToken, AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: HCkJsonObject;
  SS, RS: TStringStream;
  sAuthKey: AnsiString;
  sUrl: string;
begin
  Result := False;
  AToken := '';
  AErrMsg := '';
  Global.APIServer.Token := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    try
      sAuthKey := Base64Encode(AClientId + ':' + AClientKey, True);
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuthKey;
      HC.Request.Method := Id_HTTPMethodPost;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.APIServer.Timeout;
      HC.ReadTimeout := Global.APIServer.Timeout;
      SS.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
      sUrl := Format('%s/oauth/token', [Global.APIServer.Host]);
      HC.Post(sUrl, SS, RS);
      if not CkJsonObject_Load(JO, PWideChar(RS.DataString)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      AToken := CkJsonObject__stringOf(JO, 'access_token');
      AddLog('OAuth 토큰 획득 성공');
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('OAuth 토큰 획득 실패 = %s', [AErrMsg]));
      end;
    end;
  finally
    FreeAndNil(SSL);
    HC.Disconnect;
    HC.Free;
    if Assigned(RS) then
      FreeAndNil(RS);
    if Assigned(SS) then
      FreeAndNil(SS);
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: HCkJsonObject;
  SS, RS: TStringStream;
  sUrl: string;
begin
  Result := False;
  AErrMsg := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + Base64Encode(AClientId + ':' + AClientKey, True);
      HC.Request.Method := Id_HTTPMethodPost;
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.APIServer.Timeout;
      HC.ReadTimeout := Global.APIServer.Timeout;
      SS.WriteString(TIdURI.ParamsEncode('token=' + AToken));
      sUrl := Format('%s/oauth/check_token', [Global.APIServer.Host]);
      HC.Post(sUrl, SS, RS);

      if not CkJsonObject_Load(JO, PWideChar(RS.DataString)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      Result := True;
      AddLog('OAuth 토큰 인증 성공');
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('OAuth 토큰 인증 실패 = %s', [AErrMsg]));
      end;
    end;
  finally
    FreeAndNil(SSL);
    HC.Disconnect;
    HC.Free;
    FreeAndNil(SS);
    FreeAndNil(RS);
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.CheckAlive(var AErrMsg: string): Boolean;
const
  CS_API = 'K107_StartMobileAd';
var
  JO: HCkJsonObject;
  sUrl, sRespJSON, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.APIServer.Host, CS_API, Global.StoreCode]);
      if not ExecuteServer(sUrl, CS_API, Id_HTTPMethodGet, '', sRespJSON, AErrMsg) then
        raise Exception.Create(AErrMsg);

      if not CkJsonObject_Load(JO, PWideChar(sRespJSON)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('result_cd: %s, result_msg: %s', [sResCode, sResMsg]));

      Global.PublicIP := CkJsonObject__stringOf(JO, 'result_data.public_ip');
      AddLog(Format('라이브 체크 성공 = Public IP [%s]', [Global.PublicIP]));
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('라이브 체크 실패 = %s', [AErrMsg]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.GetStoreInfo(var AErrMsg: string): Boolean;
const
  CS_API = 'K203_StoreInfo';
var
  JO: HCkJsonObject;
  sUrl, sRespJSON, sResCode, sResMsg: string;
{$IFDEF RELEASE}
  sSvrTime: string;
  dSvrTime: TDateTime;
{$ENDIF}
begin
  Result := False;
  AErrMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.APIServer.Host, CS_API, Global.StoreCode]);
      if not ExecuteServer(sUrl, CS_API, Id_HTTPMethodGet, '', sRespJSON, AErrMsg) then
        raise Exception.Create(AErrMsg);

      if not CkJsonObject_Load(JO, PWideChar(sRespJSON)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('result_cd: %s, result_msg: %s', [sResCode, sResMsg]));
(*
      if Global.StoreStartTime.IsEmpty then
        Global.StoreStartTime := CkJsonObject__stringOf(JO, 'result_data.start_time');
      if Global.StoreEndTime.IsEmpty then
        Global.StoreEndTime := CkJsonObject__stringOf(JO, 'result_data.end_time');
      if (Global.ShutdownTimeout = 0) then
        Global.ShutdownTimeout := CkJsonObject_IntOf(JO, 'result_data.shutdown_timeout');
*)
{$IFDEF RELEASE}
      sSvrTime := CkJsonObject__stringOf(JO, 'result_data.server_time');
      if (Length(sSvrTime) = 14) then
      begin
        dSvrTime := StrToDateTime(Format('%s-%s-%s %s:%s:%s',
          [Copy(sSvrTime, 1, 4), Copy(sSvrTime, 5, 2), Copy(sSvrTime, 7, 2),
           Copy(sSvrTime, 9, 2), Copy(sSvrTime, 11, 2), Copy(sSvrTime, 13, 2)]), FormatSettings);
        ChangeSystemTime(dSvrTime);
      end;
{$ENDIF}
      Result := True;
      AddLog('사업장 정보 수신 성공');
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('사업장 정보 수신 실패 = %s', [AErrMsg]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.GetConfigInfo_ELOOM(var AIniData, AErrMsg: string): Boolean;
var
  JO: HCkJsonObject;
  sAPI, sUrl, sRespJSON, sResCode, sResMsg: string;
begin
  Result := False;
  AIniData := '';
  AErrMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      sAPI := 'K202_Configlist';
      sUrl := Format('%s/kiosk/%s?store_cd=%s&client_id=%s', [Global.APIServer.Host, sAPI, Global.StoreCode, GLOBAL.APIServer.ClientId]);
      if not ExecuteServer(sUrl, sAPI, Id_HTTPMethodGet, '', sRespJSON, AErrMsg) then
        raise Exception.Create(AErrMsg);

      if not CkJsonObject_Load(JO, PWideChar(sRespJSON)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if not ((sResCode = CRC_SUCCESS) or (sResCode = CRC_NO_SUCH_DATA)) then
        raise Exception.Create(Format('result_cd: %s, result_msg: %s', [sResCode, sResMsg]));

      AIniData := CkJsonObject__stringOf(JO, 'settings');
      Result := True;
      AddLog('환경설정 정보 수신 성공');
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        AddLog(Format('환경설정 정보 수신 실패 = %s', [AErrMsg]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.GetContentsList(var AErrMsg: string): Boolean;
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  sAPI, sUrl, sRespJSON, sResCode, sResMsg, sFileUrl, sFileName, sStartDate, sEndDate: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  JO := CkJsonObject_Create;
  JA := nil;
  try
    try
      if (Global.APIServer.Provider = SSP_ELOOM) then
      begin
        sAPI := 'K215_ScreenSaver';
        sUrl := Format('%s/kiosk/%s?store_cd=%s', [Global.APIServer.Host, sAPI, Global.StoreCode]);
      end
      else
      begin
        sAPI := 'K237_MediaList';
        sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.APIServer.Host, sAPI, Global.StoreCode]);
      end;

      if not ExecuteServer(sUrl, sAPI, Id_HTTPMethodGet, '', sRespJSON, AErrMsg) then
        raise Exception.Create(AErrMsg);

      if not CkJsonObject_Load(JO, PWideChar(sRespJSON)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      sResCode := CkJsonObject__stringOf(JO, 'result_cd');
      sResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if not ((sResCode = CRC_SUCCESS) or (sResCode = CRC_NO_SUCH_DATA)) then
        raise Exception.Create(Format('result_cd: %s, result_msg: %s', [sResCode, sResMsg]));

      Global.ContentsListClear(Global.ScreenContents);
      Global.ContentsListClear(Global.MainContents);

      JA := CkJsonObject_ArrayOf(JO, 'list_main');
      nCount := CkJsonArray_getSize(JA);
      if not CkJsonObject_getLastMethodSuccess(JO) then
        raise Exception.Create(CkJsonArray__lastErrorText(JA));

      for I := 0 to Pred(nCount) do
      begin
        RO := CkJsonArray_ObjectAt(JA, I);
        try
          sFileUrl := CkJsonObject__stringOf(RO, 'filename');
          sFileName := sFileUrl.SubString(LastDelimiter('/', sFileUrl));
          sStartDate := CkJsonObject__stringOf(RO, 'start_date');
          sEndDate := CkJsonObject__stringOf(RO, 'end_date');
          if ((not sStartDate.IsEmpty) and (sStartDate > Global.FormattedCurrentDate)) or
             ((not sEndDate.IsEmpty) and (sEndDate < Global.FormattedCurrentDate)) then
            Continue;

          Global.ContentItemAdd(Global.MainContents,
              CkJsonObject_IntOf(RO, 'order_no'),
              CkJsonObject_IntOf(RO, 'playtime'),
              sFileUrl,
              sFileName,
              False, //Default Stretch
              sStartDate,
              sEndDate,
              CkJsonObject__stringOf(RO, 'start_time'),
              CkJsonObject__stringOf(RO, 'end_time'));
        except
          CkJsonObject_Dispose(RO);
        end;
      end;

      JA := CkJsonObject_ArrayOf(JO, 'list_sub');
      nCount := CkJsonArray_getSize(JA);
      if not CkJsonObject_getLastMethodSuccess(JO) then
        raise Exception.Create(CkJsonArray__lastErrorText(JA));

      for I := 0 to Pred(nCount) do
      begin
        RO := CkJsonArray_ObjectAt(JA, I);
        try
          sFileUrl := CkJsonObject__stringOf(RO, 'filename');
          sFileName := sFileUrl.SubString(LastDelimiter('/', sFileUrl));
          sStartDate := CkJsonObject__stringOf(RO, 'start_date');
          sEndDate := CkJsonObject__stringOf(RO, 'end_date');
          if ((not sStartDate.IsEmpty) and (sStartDate > Global.FormattedCurrentDate)) or
             ((not sEndDate.IsEmpty) and (sEndDate < Global.FormattedCurrentDate)) then
            Continue;

          Global.ContentItemAdd(Global.ScreenContents,
              CkJsonObject_IntOf(RO, 'order_no'),
              CkJsonObject_IntOf(RO, 'playtime'),
              sFileUrl,
              sFileName,
              False, //Default Stretch
              sStartDate,
              sEndDate,
              CkJsonObject__stringOf(RO, 'start_time'),
              CkJsonObject__stringOf(RO, 'end_time'));
        except
          CkJsonObject_Dispose(RO);
        end;
      end;

      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TDM.ExecuteServer(const AUrl, AApiName, AMethod: string; const AReqJSON: string; var ARespJSON: string; AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RS, SS: TStringStream;
begin
  Result := False;
  AErrMsg := '';
  SS := TStringStream.Create(AReqJson, TEncoding.UTF8);
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    try
      AddLog(Format('API 서버 요청 = %s %s', [AMethod, AUrl]));
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.Request.Method := AMethod;
      if (Global.APIServer.Provider = SSP_ELOOM) then
        HC.Request.CustomHeaders.Values['x-api-key'] := Global.APIServer.ApiKey
      else
        HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.APIServer.Token;

      HC.URL.URI := Global.APIServer.Host;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.APIServer.Timeout;
      HC.ReadTimeout := Global.APIServer.Timeout;

      if (AMethod = Id_HTTPMethodGet) then
        HC.Get(AUrl, RS)
      else if (AMethod = Id_HTTPMethodPost) then
      begin
        HC.Request.ContentType := 'application/json';
        HC.Post(AUrl, SS, RS);
      end
      else
        raise Exception.Create('처리할 수 없는 메서드: ' + QuotedStr(AMethod));

      ARespJson := TEncoding.UTF8.GetString(RS.Bytes, 0, RS.Size);
      RS.SaveToFile(Global.LogDir + Format('%s.Response.json', [AApiName]));
      Result := True;
    except
      on E: EIdHTTPProtocolException do
        AErrMsg := E.Message;
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FreeAndNil(SS);
    FreeAndNil(RS);
    FreeAndNil(SSL);
    HC.Disconnect;
    HC.Free;
  end;
end;

end.
