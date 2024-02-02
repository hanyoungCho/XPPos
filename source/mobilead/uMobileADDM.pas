{$M+}
unit uMobileADDM;

interface

uses
  { Native }
  SysUtils, Classes, DB, IniFiles, JSON, Windows,
  { DCPCrypt2 }
  DCPrijndael,
  { UniDAC }
  Uni, UniProvider, MySQLUniProvider, DBAccess, MemData;

{$I ..\common\XGCommon.inc}
{$I ..\common\XGPOS.inc}
{$I ..\common\XGMobileAPI.inc}

type
  { 환경설정 }
  TConfig = record
    StoreCode: string;
    AppName: string;
    AutoRun: Boolean;
    MasterDownload: Boolean;
    HomeDir: string;
    ConfigDir: string;
    LogDir: string;
    LogFile: string;
    LogDelete: Boolean;
    LogDeleteDays: Integer;
    TestReserveNo: string;
    ForceServerStop: Boolean;

    StoreStartTime: string;
    StoreEndTime: string;
    CloseStartTime: string;
    CloseEndTime: string;

    MobileADPort: Integer;
    MobileADTimeout: Integer;

    ServerHost: string;
    ClientId: string;
    ClientKey: string;
    CheckAlive: Boolean;
    Token: string;
    LocalIP: string;
    PublicIP: string;

    TeeBoxADHost: string;
    TeeBoxADPort: Integer;

    TeeBoxDBPort: Integer;
    TeeBoxDBUserId: string;
    TeeBoxDBPwd: string;
    TeeBoxDBCatalog: string;

    AdminCallEnabled: Boolean;
    AdminCallHost: string;
    AdminCallPort: Integer;
  end;

  { TDataModule }
  TDM = class(TDataModule)
    conLocalDB: TUniConnection;
    UniMySQLProvider: TMySQLUniProvider;

    procedure conLocalDBAfterConnect(Sender: TObject);
    procedure conLocalDBAfterDisconnect(Sender: TObject);
    procedure conLocalDBBeforeConnect(Sender: TObject);
    procedure conLocalDBConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure conLocalDBError(Sender: TObject; E: EDAError; var Fail: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetToken(const AClientId, AClientKey: string; var AToken: string; var AErrMsg: string): Boolean;
    function CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
    function CheckAlive: Boolean;
    function GetStoreInfo(var AErrMsg: string): Boolean;
    function GetTerminalInfo(var AErrMsg: string): Boolean;
    function GetTeeBoxStatus(var ABuffer: string; const AFloorCode, ATeeBoxNo: string; var AErrCode, AErrMsg: string): Boolean;
    function GetTeeBoxStatusDetail(var ABuffer: string; const ATeeBoxNo: Integer; var AErrCode, AErrMsg: string): Boolean;
    function GetTeeBoxReservedDetail(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxHold(var ABuffer: string; const ATeeBoxNo: Integer; const AUseHold: Boolean; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxReserve(var ABuffer: string; const ATeeBoxNo: Integer;
      const AReserveRootDiv, AMemberNo, AMemberName, APurchaseCode, AProductCode, ATeeBoxProductDiv, AAvailZoneCode, AProductName: string;
      const AAssignMin, APrepareMin, AAssignBalls: Integer; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxReserveNoShow(var ABuffer: string; const ATeeBoxNo: Integer;
      const AReserveNo, AReserveDateTime, AReserveRootDiv, AReceiptNo, APurchaseCode, AMemberNo, AMemberName, AXGUserKey, AProdDiv, AProdCode, AProdName, AAvailZoneCode, AAffiliateCode: string;
      const AAssignMin, APrepareMin, AAssignBalls: Integer; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxCancel(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxMachineControl_InDoor(var ABuffer: string; const ATeeBoxNo, AMethod: Integer; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxDeviceControl_InDoor(var ABuffer: string; const ATeeBoxNo, ADeviceDiv, AControlDiv: Integer; const ACommand: string; var AErrCode, AErrMsg: string): Boolean;
  end;

var
  DM: TDM;
  Config: TConfig;

implementation

uses
  System.Generics.Collections, DateUtils, Variants,
  IdGlobal, IdSSLOpenSSL, IdHTTP, IdURI, IdTCPClient,
  uMobileADMain, uXGCommonLib;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.GetToken(const AClientId, AClientKey: string; var AToken: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  sAuth: Ansistring;
  sURL: string;
begin
  Result := False;
  AToken := '';
  AErrMsg := '';
  try
    JO := nil;
    SS := TStringStream.Create;
    RS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      sAuth := Base64Encode(AClientId + ':' + AClientKey, True);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuth;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      SS.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
      sURL := Format('%s/oauth/token', [Config.ServerHost]);
      HC.Post(sURL, SS, RS);
      JO := TJSONObject.ParseJSONValue(RS.DataString) as TJSONObject;
      AToken := JO.GetValue('access_token').Value;
      Result := True;
      AddLog('GetToken.Success');
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      if Assigned(RS) then
        FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('GetToken.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
  end;
end;

function TDM.CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO: TJSONObject;
  sAuth: Ansistring;
  sURL: string;
begin
  Result := False;
  AErrMsg := '';
  try
    JO := nil;
    SS := TStringStream.Create;
    RS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      sAuth := Base64Encode(AClientId + ':' + AClientKey, True);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuth;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      SS.WriteString(TIdURI.ParamsEncode('token=' + AToken));
      sURL := Format('%s/oauth/check_token', [Config.ServerHost]);
      HC.Post(sURL, SS, RS);
      JO := TJSONObject.ParseJSONValue(RS.DataString) as TJSONObject;
      Result := True;
      AddLog('CheckToken.Success');
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('CheckToken.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
  end;
end;

function TDM.CheckAlive: Boolean;
const
  CS_API = 'K107_StartMobileAd';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  try
    JO := nil;
    RO := nil;
    SS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Config.Token;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Config.ServerHost, CS_API, Config.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Config.LogDir + Format('%s_%s.Response.json', [Config.AppName, CS_API]));
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        RO := JO.GetValue('result_data') as TJSONObject;
        Config.PublicIP := RO.GetValue('public_ip').Value;
        AddLog(Format('CheckAlive.Success : Public IP [%s]', [Config.PublicIP]), LC_COLOR_NORMAL);
      end;
      Result := True;
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      FreeAndNil(SS);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
      AddLog(Format('CheckAlive.Exception = %s', [E.Message]), LC_COLOR_ERROR);
  end;
end;

function TDM.GetStoreInfo(var AErrMsg: string): Boolean;
const
  CS_API = 'K203_StoreInfo';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue: string;
  dSvrTime: TDateTime;
begin
  Result := False;
  AErrMsg := '';
  try
    JO := nil;
    RO := nil;
    SS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Config.Token;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Config.ServerHost, CS_API, Config.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Config.LogDir + Format('%s_%s.Response.json', [Config.AppName, CS_API]));
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        RO := JO.GetValue('result_data') as TJSONObject;
        Config.StoreStartTime := RO.GetValue('start_time').Value;
        Config.StoreEndTime   := RO.GetValue('end_time').Value;
        Config.CloseStartTime := RO.GetValue('close_start_date').Value;
        Config.CloseEndTime   := RO.GetValue('close_end_date').Value;

        sValue := Trim(RO.GetValue('server_time').Value);
        if (Length(sValue) = 14) then
        begin
          dSvrTime := StrToDateTime(Format('%s-%s-%s %s:%s:%s',
            [
              Copy(sValue, 1, 4),
              Copy(sValue, 5, 2),
              Copy(sValue, 7, 2),
              Copy(sValue, 9, 2),
              Copy(sValue, 11, 2),
              Copy(sValue, 13, 2)
            ]), FormatSettings);
          ChangeSystemTime(dSvrTime);
        end;
      end;
      AddLog('GetStoreInfo.Success');
      Result := True;
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('GetStoreInfo.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
  end;
end;

function TDM.GetTerminalInfo(var AErrMsg: string): Boolean;
const
  CS_API = 'K104_Terminal';
var
  JO: TJSONObject;
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RBS: RawByteString;
  SS: TStringStream;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  try
    JO := nil;
    SS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Config.Token;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      sUrl := Format('%s/wix/api/%s?client_id=%s', [Config.ServerHost, CS_API, Config.ClientId]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Config.LogDir + Format('%s_%s.Response.json', [Config.AppName, CS_API]));
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if (JO.FindValue('result_data') is TJSONNull) then
        raise Exception.Create('result_data is null');

      JO := JO.GetValue('result_data') as TJSONObject;
      Config.StoreCode := JO.GetValue('store_cd').Value;
      AddLog('GetTerminalInfo.Success');
      Result := True;
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('GetTerminalInfo.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
  end;
end;

function TDM.GetTeeBoxStatus(var ABuffer: string; const AFloorCode, ATeeBoxNo: string; var AErrCode, AErrMsg: string): Boolean;
var
  IO, RO: TJSONObject;
  RA: TJSONArray;
  nTeeBoxNo, nRemainMin, nUseStatus: Integer;
  sEndDateTime, sCutinTime: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '정상적으로 조회 되었습니다.';

  RO := TJSONObject.Create;
  RA := TJSONArray.Create;
  try
    try
      with TUniStoredProc.Create(nil) do
      try
        Connection := conLocalDB;
        StoredProcName := 'SP_GET_TEEBOX_STATUS_MOBILE';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := Config.StoreCode;
        Params.CreateParam(ftString, 'p_floor_cd', ptInput).AsString := AFloorCode;
        Params.CreateParam(ftString, 'p_teebox_no', ptInput).AsString := ATeeBoxNo;
        Prepared := True;
        Open;
        First;
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nRemainMin := FieldByName('remain_min').AsInteger;
          sEndDateTime := FieldByName('end_date').AsString;
          sCutinTime := FieldByName('cutin_reserve_datetime').AsString;
          nUseStatus := StrToIntDef(FieldByName('use_status').AsString, CTS_TEEBOX_ERROR);

          IO := TJSONObject.Create;
          IO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          IO.AddPair(TJSONPair.Create('remain_min', TJSONNumber.Create(nRemainMin)));
          IO.AddPair(TJSONPair.Create('end_datetime', sEndDateTime));
          IO.AddPair(TJSONPair.Create('cutin_reserve_datetime', sCutinTime));
          IO.AddPair(TJSONPair.Create('use_status', IntToStr(nUseStatus)));
          RA.Add(IO);

          Next;
        end;

        if (RecordCount = 0) then
        begin
          AErrCode := '8000';
          AErrMsg := '조회할 데이터가 없습니다.';
        end;
      finally
        Close;
        Free;
      end;

      Result := True;
      SetLed(LC_LED_TEEBOX_DB, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    RO.AddPair(TJSONPair.Create('result_data', RA));
    ABuffer := RO.ToString;
  finally
    FreeAndNilJSONObject(RA);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.GetTeeBoxStatusDetail(var ABuffer: string; const ATeeBoxNo: Integer; var AErrCode, AErrMsg: string): Boolean;
var
  JO, RO: TJSONObject;
  RA: TJSONArray;
  nTeeBoxNo, nAssignMin, nRemainMin, nUseStatus: Integer;
  sToday, sStartDateTime, sEndDateTime: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '정상적으로 조회 되었습니다.';

  RO := TJSONObject.Create;
  JO := nil;
  RA := TJSONArray.Create;
  try
    try
      with TUniStoredProc.Create(nil) do
      try
        Connection := conLocalDB;
        StoredProcName := 'SP_GET_RESERVED_DETAIL_MOBILE';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := Config.StoreCode;
        Params.CreateParam(ftString, 'p_teebox_no', ptInput).AsInteger := ATeeBoxNo;
        Prepared := True;
        Open;
        First;
        sToday := FormatDateTime('yyyy-mm-dd', Now);
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nAssignMin := FieldByName('assign_min').AsInteger;
          nRemainMin := nAssignMin;
          nUseStatus := StrToIntDef(FieldByName('use_status').AsString, CTS_TEEBOX_ERROR);
          sStartDateTime := FieldByName('start_datetime').AsString; //yyyy-mm-dd hh:nn:ss
          sEndDateTime := FieldByName('end_datetime').AsString; //yyyy-mm-dd hh:nn:ss
          if (nUseStatus = CTS_TEEBOX_USE) then
          begin
            try
              nRemainMin := MinutesBetween(StrToDateTime(sEndDateTime, FormatSettings), Now) + 1;
              if (nRemainMin < 0) then
                nRemainMin := 0;
            except
              nRemainMin := nAssignMin;
            end;
          end;

          JO := TJSONObject.Create;
          JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          JO.AddPair(TJSONPair.Create('remain_min', TJSONNumber.Create(nRemainMin)));
          JO.AddPair(TJSONPair.Create('start_datetime', sStartDateTime));
          JO.AddPair(TJSONPair.Create('use_status', IntToStr(nUseStatus)));
          RA.Add(JO);

          Next;
        end;

        if (RecordCount = 0) then
        begin
          AErrCode := '8000';
          AErrMsg := '조회할 데이터가 없습니다.';
        end;
      finally
        Close;
        Free;
      end;

      Result := True;
      SetLed(LC_LED_TEEBOX_DB, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    RO.AddPair(TJSONPair.Create('result_data', RA));
    ABuffer := RO.ToString;
  finally
    FreeAndNilJSONObject(JO);
    FreeAndNilJSONObject(RA);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.GetTeeBoxReservedDetail(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
var
  JO, RO: TJSONObject;
  nTeeBoxNo, nAssignMin, nAssignBalls, nPrepareMin: Integer;
  sReserveDateTime, sStartDateTime, sEndDateTime, sReserveNo: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '정상적으로 조회 되었습니다.';

  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  try
    try
      with TUniStoredProc.Create(nil) do
      try
        Connection := conLocalDB;
        StoredProcName := 'SP_GET_TEEBOX_RESERVE_MOBILE';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := Config.StoreCode;
        Params.CreateParam(ftString, 'p_reserve_no', ptInput).AsString := AReserveNo;
        Prepared := True;
        Open;
        First;
        if (RecordCount > 0) then
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nAssignMin := FieldByName('assign_min').AsInteger;
          nAssignBalls := FieldByName('assign_balls').AsInteger;
          nPrepareMin := FieldByName('prepare_min').AsInteger;
          sReserveDateTime := FieldByName('reserve_datetime').AsString;
          sStartDateTime := FieldByName('start_datetime').AsString;
          sEndDateTime := FieldByName('end_datetime').AsString;
          sReserveNo := FieldByName('reserve_no').AsString;

          JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          JO.AddPair(TJSONPair.Create('assign_min', TJSONNumber.Create(nAssignMin)));
          JO.AddPair(TJSONPair.Create('assign_balls', TJSONNumber.Create(nAssignBalls)));
          JO.AddPair(TJSONPair.Create('prepare_min', TJSONNumber.Create(nPrepareMin)));
          JO.AddPair(TJSONPair.Create('reserve_datetime', sReserveDateTime));
          JO.AddPair(TJSONPair.Create('start_datetime', sStartDateTime));
          JO.AddPair(TJSONPair.Create('end_datetime', sEndDateTime));
          JO.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
        end
        else
        begin
          AErrCode := '8000';
          AErrMsg := '조회할 데이터가 없습니다.';
        end;
      finally
        Close;
        Free;
      end;

      Result := True;
      SetLed(LC_LED_TEEBOX_DB, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    RO.AddPair(TJSONPair.Create('result_data', JO));
    ABuffer := RO.ToString;
  finally
    FreeAndNilJSONObject(JO);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.DoTeeBoxHold(var ABuffer: string; const ATeeBoxNo: Integer; const AUseHold: Boolean; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
var
  JO, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  if AUseHold then
    AErrMsg := '타석이 임시예약으로 등록 되었습니다.'
  else
    AErrMsg := '타석의 임시예약이 취소 되었습니다.';

  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO.AddPair(TJSONPair.Create('api', String(IIF(AUseHold, 'K405', 'K406') + '_TeeBoxHold')));
      JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO.AddPair(TJSONPair.Create('user_id', AUserId));
      JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO.ToString, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    ABuffer := RO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(JO);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.DoTeeBoxReserve(var ABuffer: string; const ATeeBoxNo: Integer;
  const AReserveRootDiv, AMemberNo, AMemberName, APurchaseCode, AProductCode, ATeeBoxProductDiv, AAvailZoneCode, AProductName: string;
  const AAssignMin, APrepareMin, AAssignBalls: Integer; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K408_TeeBoxReserve2';
var
  JO, IO, RO: TJSONObject;
  IA: TJSONArray;
  JV: TJSONValue;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sReserveNo, sReserveDateTime, sStartDateTime, sEndDateTime: string;
  nCount, nAssignMin: Integer;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '';
  RBS := '';

  TC := TIdTCPClient.Create(nil);
  RO := nil;
  JO := TJSONObject.Create;
  IA := TJSONArray.Create;
  IO := TJSONObject.Create;
  try
    try
      try
        JO.AddPair(TJSONPair.Create('api', CS_API));
        JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
        JO.AddPair(TJSONPair.Create('xg_user_key', AMemberNo));
        JO.AddPair(TJSONPair.Create('member_no', AMemberNo));
        JO.AddPair(TJSONPair.Create('member_nm', AMemberName));
        JO.AddPair(TJSONPair.Create('reserve_root_div', AReserveRootDiv));
        JO.AddPair(TJSONPair.Create('affiliate_cd', '')); //제휴사구분코드(웰빙클럽 등)
        JO.AddPair(TJSONPair.Create('user_id', AUserId));
        JO.AddPair(TJSONPair.Create('receipt_no', ''));
        JO.AddPair(TJSONPair.Create('data', IA));

        IO.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
        IO.AddPair(TJSONPair.Create('purchase_cd', APurchaseCode));
        IO.AddPair(TJSONPair.Create('product_cd', AProductCode));
        IO.AddPair(TJSONPair.Create('product_nm', AProductName));
        IO.AddPair(TJSONPair.Create('reserve_div', ATeeBoxProductDiv));
        IO.AddPair(TJSONPair.Create('assign_balls', TJSONNumber.Create(AAssignBalls)));
        IO.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
        IO.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
        IO.AddPair(TJSONPair.Create('available_zone_cd', AAvailZoneCode));
        IA.Add(IO);
        sBuffer := JO.ToString;
      finally
        FreeAndNilJSONObject(IO);
        FreeAndNilJSONObject(IA);
        FreeAndNilJSONObject(JO);
      end;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      RO := TJSONObject.Create;
      AErrCode := JO.GetValue('result_cd').Value;
      AErrMsg := JO.GetValue('result_msg').Value;
      Result := (AErrCode = CRC_SUCCESS);
      if not Result then
      begin
        sReserveNo := JO.GetValue('reserve_no').Value;
        RO.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
      end
      else
      begin
        AErrMsg := '타석 예약 요청이 정상 처리 되었습니다.';
        if not (JO.FindValue('data') is TJSONNull) then
        begin
          JV := JO.GetValue('data');
          try
            nCount := (JV as TJSONArray).Count;
            if (nCount > 0) then
            begin
              sReserveNo := (JV as TJSONArray).Items[0].P['reserve_no'].Value;
              Config.TestReserveNo := sReserveNo;
              nAssignMin := StrToIntDef((JV as TJSONArray).Items[0].P['remain_min'].Value, 0);
              sStartDateTime := (JV as TJSONArray).Items[0].P['start_datetime'].Value;
              sReserveDateTime := (JV as TJSONArray).Items[0].P['reserve_datetime'].Value;
              sEndDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', IncMinute(StrToDateTime(sStartDateTime, FormatSettings), nAssignMin));

              RO.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
              RO.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
              RO.AddPair(TJSONPair.Create('assign_min', TJSONNumber.Create(nAssignMin)));
              RO.AddPair(TJSONPair.Create('prepare_min', TJSONNumber.Create(APrepareMin)));
              RO.AddPair(TJSONPair.Create('assign_balls', TJSONNumber.Create(9999)));
              RO.AddPair(TJSONPair.Create('reserve_datetime', sReserveDateTime));
              RO.AddPair(TJSONPair.Create('start_datetime', sStartDateTime));
              RO.AddPair(TJSONPair.Create('end_datetime', sEndDateTime));
            end;
          finally
            FreeAndNilJSONObject(JV);
          end;
        end;
      end;

      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    JO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    JO.AddPair(TJSONPair.Create('result_data', RO));
    ABuffer := JO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(RO);
    FreeAndNilJSONObject(JO);
  end;
end;

function TDM.DoTeeBoxReserveNoShow(var ABuffer: string; const ATeeBoxNo: Integer;
  const AReserveNo, AReserveDateTime, AReserveRootDiv, AReceiptNo, APurchaseCode, AMemberNo, AMemberName, AXGUserKey, AProdDiv, AProdCode, AProdName, AAvailZoneCode, AAffiliateCode: string;
  const AAssignMin, APrepareMin, AAssignBalls: Integer; const AUserId: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'A431_TeeboxCutIn';
var
  TC: TIdTCPClient;
  JO, RO: TJSONObject;
  RBS: RawByteString;
  sBuffer, sReserveNo: string;
begin
  Result := False;
  AErrCode := '0000';
  AErrMsg := '';
  RBS := '';
  TC := TIdTCPClient.Create(nil);
  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  try
    try
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
      JO.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
      JO.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
      JO.AddPair(TJSONPair.Create('assign_balls', IntToStr(AAssignBalls)));
      JO.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO.AddPair(TJSONPair.Create('reserve_date', AReserveDateTime));
      JO.AddPair(TJSONPair.Create('reserve_root_div', AReserveRootDiv));
      JO.AddPair(TJSONPair.Create('receipt_no', AReceiptNo));
      JO.AddPair(TJSONPair.Create('purchase_cd', APurchaseCode));
      JO.AddPair(TJSONPair.Create('member_no', AMemberNo));
      JO.AddPair(TJSONPair.Create('member_nm', AMemberName));
      JO.AddPair(TJSONPair.Create('xg_user_key', AXGUserKey));
      JO.AddPair(TJSONPair.Create('reserve_div', AProdDiv));
      JO.AddPair(TJSONPair.Create('product_cd', AProdCode));
      JO.AddPair(TJSONPair.Create('product_nm', UTF8String(AProdName)));
      JO.AddPair(TJSONPair.Create('available_zone_cd', AAvailZoneCode));
      JO.AddPair(TJSONPair.Create('affiliate_cd', AAffiliateCode)); //제휴사구분코드(웰빙클럽 등)
      JO.AddPair(TJSONPair.Create('user_id', AUserId));
      sBuffer := JO.ToString;
      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      AErrCode := JO.GetValue('result_cd').Value;
      AErrMsg := JO.GetValue('result_msg').Value;
      Result := (AErrCode = CRC_SUCCESS);
      if Result then
      begin
        AErrMsg := '노쇼 타석 예약 요청이 정상 처리 되었습니다.';
        if not (JO.FindValue('data') is TJSONNull) then
        begin
          sReserveNo := JO.GetValue('reserve_no').Value;
          Config.TestReserveNo := sReserveNo;
          RO.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
          RO.AddPair(TJSONPair.Create('purchase_cd', JO.GetValue('purchase_cd').Value));
          RO.AddPair(TJSONPair.Create('product_cd', JO.GetValue('product_cd').Value));
          RO.AddPair(TJSONPair.Create('product_nm', JO.GetValue('product_nm').Value));
          RO.AddPair(TJSONPair.Create('product_div', JO.GetValue('product_div').Value));
          RO.AddPair(TJSONPair.Create('floor_nm', JO.GetValue('floor_nm').Value));
          RO.AddPair(TJSONPair.Create('teebox_nm', JO.GetValue('teebox_nm').Value));
          RO.AddPair(TJSONPair.Create('start_datetime', JO.GetValue('start_datetime').Value));
          RO.AddPair(TJSONPair.Create('remain_min', JO.GetValue('remain_min').Value));
          RO.AddPair(TJSONPair.Create('expire_day', JO.GetValue('expire_day').Value));
          RO.AddPair(TJSONPair.Create('access_barcode', JO.GetValue('access_barcode').Value));
          RO.AddPair(TJSONPair.Create('coupon_cnt', JO.GetValue('coupon_cnt').Value));
        end;
      end;

      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    JO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    JO.AddPair(TJSONPair.Create('result_data', RO));
    ABuffer := JO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(RO);
    FreeAndNilJSONObject(JO);
  end;
end;

function TDM.DoTeeBoxCancel(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K410_TeeBoxReserved';
var
  JO, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '예약이 취소 되었습니다.';

  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      JO.AddPair(TJSONPair.Create('receipt_no', ''));

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO.ToString);
      RBS := TC.IOHandler.ReadLn;
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    ABuffer := RO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(RO);
    FreeAndNilJSONObject(JO);
  end;
end;

function TDM.DoTeeBoxMachineControl_InDoor(var ABuffer: string; const ATeeBoxNo, AMethod: Integer; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'A440_AgentSetting';
var
  JO, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '정상적으로 처리 되었습니다.';

  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(ATeeBoxNo)));
      JO.AddPair(TJSONPair.Create('method', TJSONNumber.Create(AMethod)));
      JO.AddPair(TJSONPair.Create('user_id', Config.ClientId));

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO.ToString);
      RBS := TC.IOHandler.ReadLn;
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    ABuffer := RO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(RO);
    FreeAndNilJSONObject(JO);
  end;
end;

function TDM.DoTeeBoxDeviceControl_InDoor(var ABuffer: string; const ATeeBoxNo, ADeviceDiv, AControlDiv: Integer; const ACommand: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K501_DeviceControl';
var
  JO, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '정상적으로 처리 되었습니다.';

  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(ATeeBoxNo)));
      JO.AddPair(TJSONPair.Create('divice_div', TJSONNumber.Create(ADeviceDiv)));
      JO.AddPair(TJSONPair.Create('control_div', TJSONNumber.Create(AControlDiv)));
      JO.AddPair(TJSONPair.Create('command', ACommand));
      JO.AddPair(TJSONPair.Create('user_id', Config.ClientId));

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO.ToString);
      RBS := TC.IOHandler.ReadLn;
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
      SetLed(LC_LED_TEEBOX_AD, True);
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    ABuffer := RO.ToString;
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(RO);
    FreeAndNilJSONObject(JO);
  end;
end;

procedure TDM.conLocalDBAfterConnect(Sender: TObject);
begin
  SetLed(LC_LED_TEEBOX_DB, True);
//  with TUniConnection(Sender) do
//    AddLog(Format('타석기AD 데이터베이스에 연결 되었습니다. (Host=%s Version=%s)', [Server, ServerVersionFull]));
end;

procedure TDM.conLocalDBAfterDisconnect(Sender: TObject);
begin
  SetLed(LC_LED_TEEBOX_DB, False);
end;

procedure TDM.conLocalDBBeforeConnect(Sender: TObject);
begin
  with TUniConnection(Sender) do
  begin
    ProviderName := 'MySQL';
    LoginPrompt := False;
    Database := Config.TeeBoxDBCatalog;
    Server := Format('%s,%d Allow User Variables=True', [Config.TeeBoxADHost, Config.TeeBoxDBPort]);
    Port := Config.TeeBoxDBPort;
    UserName := Config.TeeBoxDBUserId;
    Password := Config.TeeBoxDBPwd;
    SpecificOptions.Clear;
    SpecificOptions.Add('MySQL.CharSet=utf8mb4');
    SpecificOptions.Add('MySQL.UseUniCode=True');
    SpecificOptions.Add('MySQL.ConnectionTimeOut=30');
  end;
end;

procedure TDM.conLocalDBConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
(*
  [ TConnLostCause ]
  clApply           : Connection loss detected during DataSet.ApplyUpdates (Reconnect/Reexecute possible).
  clConnect         : Connection loss detected during connection establishing (Reconnect possible).
  clConnectionApply : Connection loss detected during Connection.ApplyUpdates (Reconnect/Reexecute possible).
  clExecute         : Connection loss detected during SQL execution (Reconnect with exception is possible).
  clOpen            : Connection loss detected during execution of a SELECT statement (Reconnect with exception possible).
  clRefresh         : Connection loss detected during query opening (Reconnect/Reexecute possible).
  clServiceQuery    : Connection loss detected during service information request (Reconnect/Reexecute possible).
  clTransStart      : Connection loss detected during transaction start (Reconnect/Reexecute possible). clTransStart has less priority then clConnectionApply.
  clUnknown         : The connection loss reason is unknown.
*)
  TUniConnection(Sender).Connected := False;
  SetLed(LC_LED_TEEBOX_DB, True);
  AddLog('타석기AD 데이터베이스와의 연결이 끊어졌습니다.', LC_COLOR_ERROR);
  RetryMode := TRetryMode.rmReconnectExecute;
end;

procedure TDM.conLocalDBError(Sender: TObject; E: EDAError; var Fail: Boolean);
begin
  TUniConnection(Sender).Disconnect;
  SetLed(LC_LED_TEEBOX_DB, False, True);
  AddLog(Format('타석기AD 데이터베이스에서 장애가 발생하였습니다. (Code=%d, Error=%s)', [E.ErrorCode, E.Message]), LC_COLOR_ERROR);
end;

end.
