{$M+}
unit uELMADDM;

interface

uses
  { Native }
  SysUtils, Classes, DB, IniFiles, JSON, Windows,
  { UniDAC }
  Uni, UniProvider, MySQLUniProvider, DBAccess, MemData;

{$I ..\common\XGCommon.inc}
{$I ..\common\XGPOS.inc}

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
    ApiKey: string;
    SecureKey: string;
    PublicIP: string;

    TeeBoxADHost: string;
    TeeBoxADPort: Integer;

    TeeBoxDBPort: Integer;
    TeeBoxDBUserId: string;
    TeeBoxDBPwd: string;
    TeeBoxDBCatalog: string;
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
    function GetSecureKey(const AStoreCode: string; var ASecureKey, AErrMsg: string): Boolean;
    function GetTeeBoxStatus(var ABuffer: string; const AFloorCode, ATeeBoxNoString: string; var AErrCode, AErrMsg: string): Boolean;
    function GetTeeBoxStatusDetail(var ABuffer: string; const ATeeBoxNo: Integer; var AErrCode, AErrMsg: string): Boolean;
    function GetTeeBoxStatus_ELOOM(var ABuffer: string; const AFloorCode, ATeeBoxNoString: string; var AErrCode, AErrMsg: string): Boolean;
    function SetTeeBoxError_ELOOM(var ABuffer: string; const ATeeBoxNo: Integer; const AStatusCode: string; var AErrCode, AErrMsg: string): Boolean;
    function GetTeeBoxReservedDetail(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxHold(var ABuffer: string; const ATeeBoxNo: Integer; const AUseHold: Boolean; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxReserve(var ABuffer: string; const ATeeBoxNo: Integer;
      const AReserveRootDiv, AMemberNo, AMemberName, APurchaseCode, AProductCode, ATeeBoxProductDiv, AProductName: string;
      const AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxCancel(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxMachineControl_InDoor(var ABuffer: string; const ATeeBoxNo, AMethod: Integer; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxDeviceControl_InDoor(var ABuffer: string; const ATeeBoxNo, ADeviceDiv, AControlDiv: Integer; const ACommand: string; var AErrCode, AErrMsg: string): Boolean;

    function DoTeeBoxReserveClose_ELOOM(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxReserveChange_ELOOM(var ABuffer: string; const AReserveNo: string;
      const APrepareMin, AAssignMin, AAssignBalls: Integer; const AMemberNo, AMemberName, AMemo: string; var AErrCode, AErrMsg: string): Boolean;
    function DoTeeBoxReserveMove_ELOOM(var ABuffer: string; const AReserveNo: string;
      const ATeeBoxNo, APrepareMin, AAssignMin, AAssignBalls: Integer; var AErrCode, AErrMsg: string): Boolean;
    function DoImmediateTeeBoxStart_ELOOM(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
  end;

var
  DM: TDM;
  Config: TConfig;

implementation

uses
  { Native }
  System.Generics.Collections, DateUtils, NetEncoding,
  { Indy }
  IdGlobal, IdSSLOpenSSL, IdHTTP, IdURI, IdTCPClient,
  { Project }
  uELMADMain, uXGCommonLib;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.GetSecureKey(const AStoreCode: string; var ASecureKey, AErrMsg: string): Boolean;
const
  CS_API = 'K001_Securekey';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RBS: RawByteString;
  JO: TJSONObject;
  JV: TJSONValue;
  RS: TStringStream;
  sURL, sResCode, sResMsg: string;
begin
  Result := False;
  ASecureKey := '';
  AErrMsg := '';
  try
    JO := nil;
    JV := nil;
    RS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.Request.Method := 'GET';
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['x-api-key'] := Config.ApiKey;
      HC.URL.URI := Config.ServerHost;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Config.MobileADTimeout;
      HC.ReadTimeout := Config.MobileADTimeout;
      sURL := Format('%s/kiosk/%s?store_cd=%s', [Config.ServerHost, CS_API, Config.StoreCode]);
      HC.Get(sURL, RS);
      RS.SaveToFile(Config.LogDir + CS_API + '.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      ASecureKey := StringReplace(JO.GetValue('secure_key').Value, '-', '', [rfReplaceAll]);
      Result := True;
    finally
      HC.Disconnect;
      FreeAndNil(HC);
      FreeAndNil(SSL);
      FreeAndNil(RS);
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      AddLog(Format('GetSecureKey.Exception = %s', [E.Message]), LC_COLOR_ERROR);
    end;
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
  SetLed(LC_LED_TEEBOX_DB, True);
  AddLog('타석기AD 데이터베이스와의 연결이 끊어졌습니다.', LC_COLOR_ERROR);
  RetryMode := TRetryMode.rmReconnectExecute;
end;

procedure TDM.conLocalDBError(Sender: TObject; E: EDAError; var Fail: Boolean);
begin
  SetLed(LC_LED_TEEBOX_DB, False, True);
  AddLog(Format('타석기AD 데이터베이스에서 장애가 발생하였습니다. (Code=%d, Error=%s)', [E.ErrorCode, E.Message]), LC_COLOR_ERROR);
end;

function TDM.GetTeeBoxStatus(var ABuffer: string; const AFloorCode, ATeeBoxNoString: string; var AErrCode, AErrMsg: string): Boolean;
var
  IO, RO: TJSONObject;
  RA: TJSONArray;
  nTeeBoxNo, nRemainMin, nUseStatus: Integer;
  sEndDateTime: string;
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
        Params.CreateParam(ftString, 'p_teebox_no', ptInput).AsString := ATeeBoxNoString;
        Prepared := True;
        Open;
        First;
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nRemainMin := FieldByName('remain_min').AsInteger;
          sEndDateTime := FieldByName('end_date').AsString;
          nUseStatus := StrToIntDef(FieldByName('use_status').AsString, CTS_TEEBOX_ERROR);

          IO := TJSONObject.Create;
          IO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          IO.AddPair(TJSONPair.Create('remain_min', TJSONNumber.Create(nRemainMin)));
          IO.AddPair(TJSONPair.Create('end_datetime', sEndDateTime));
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
  JO := nil;
  RO := TJSONObject.Create;
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

function TDM.GetTeeBoxStatus_ELOOM(var ABuffer: string; const AFloorCode, ATeeBoxNoString: string; var AErrCode, AErrMsg: string): Boolean;
var
  IO, RO: TJSONObject;
  RA: TJSONArray;
  nTeeBoxNo, nRemainMin, nReserveCount, nTotalRemainMin, nUseStatus: Integer;
  sReserveNo, sStartDatetime, sEndDateTime, sTotalEndDatetime, sMemberNo, sMemberName: string;
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
        StoredProcName := 'SP_GET_TEEBOX_STATUS_MOBILE_ELOOM';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := Config.StoreCode;
        Params.CreateParam(ftString, 'p_floor_cd', ptInput).AsString := AFloorCode;
        Params.CreateParam(ftString, 'p_teebox_no', ptInput).AsString := ATeeBoxNoString;
        Prepared := True;
        Open;
        First;
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          sReserveNo := FieldByName('reserve_no').AsString;
          nRemainMin := FieldByName('remain_min').AsInteger;
          sStartDatetime := FieldByName('start_date').AsString;
          sEndDatetime := FieldByName('end_date').AsString;
          sMemberNo := FieldByName('member_no').AsString;
          sMemberName := FieldByName('member_nm').AsString;
          nReserveCount := FieldByName('cnt').AsInteger;
          nTotalRemainMin := FieldByName('total_remain_min').AsInteger;
          sTotalEndDatetime := FieldByName('total_end_date').AsString;
          nUseStatus := StrToIntDef(FieldByName('use_status').AsString, CTS_TEEBOX_ERROR);

          IO := TJSONObject.Create;
          IO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          IO.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
          IO.AddPair(TJSONPair.Create('remain_min', TJSONNumber.Create(nRemainMin)));
          IO.AddPair(TJSONPair.Create('start_datetime', sStartDatetime));
          IO.AddPair(TJSONPair.Create('end_datetime', sEndDatetime));
          IO.AddPair(TJSONPair.Create('member_no', sMemberNo));
          IO.AddPair(TJSONPair.Create('member_nm', sMemberName));
          IO.AddPair(TJSONPair.Create('teebox_reserve_cnt', TJSONNumber.Create(nReserveCount)));
          IO.AddPair(TJSONPair.Create('teebox_remain_min', TJSONNumber.Create(nTotalRemainMin)));
          IO.AddPair(TJSONPair.Create('teebox_end_datetime', sTotalEndDatetime));
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

function TDM.DoTeeBoxReserveChange_ELOOM(var ABuffer: string; const AReserveNo: string; const APrepareMin, AAssignMin, AAssignBalls: Integer; const AMemberNo, AMemberName, AMemo: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K411_TeeBoxReserved';
var
  JO1, JO2, RO: TJSONObject;
  JV2: TJSONValue;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '타석배정 내역이 변경 되었습니다.';

  RO := TJSONObject.Create;
  JO1 := TJSONObject.Create;
  JO2 := nil;
  JV2 := nil;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO1.AddPair(TJSONPair.Create('api', CS_API));
      JO1.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO1.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO1.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
      JO1.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
      JO1.AddPair(TJSONPair.Create('assign_balls', IntToStr(AAssignBalls)));
      JO1.AddPair(TJSONPair.Create('member_no', AMemberNo));
      JO1.AddPair(TJSONPair.Create('member_nm', AMemberName));
      JO1.AddPair(TJSONPair.Create('memo', TIdURI.ParamsEncode(AMemo)));
      sBuffer := JO1.ToString;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
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
    FreeAndNilJSONObject(JV2);
    FreeAndNilJSONObject(JO2);
    FreeAndNilJSONObject(JO1);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.DoTeeBoxReserveClose_ELOOM(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K416_TeeBoxClose';
var
  JO1, JO2, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '타석 종료가 처리 되었습니다.';

  RO := TJSONObject.Create;
  JO1 := TJSONObject.Create;
  JO2 := nil;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO1.AddPair(TJSONPair.Create('api', CS_API));
      JO1.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO1.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      sBuffer := JO1.ToString;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
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
    FreeAndNilJSONObject(JO2);
    FreeAndNilJSONObject(JO1);
    FreeAndNilJSONObject(RO);
  end;
end;

function TDM.DoTeeBoxReserveMove_ELOOM(var ABuffer: string; const AReserveNo: string;
  const ATeeBoxNo, APrepareMin, AAssignMin, AAssignBalls: Integer; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K412_MoveTeeBoxReserved';
var
  JO1, JO2, RO1, RO2: TJSONObject;
  JV2: TJSONValue;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg, sReserveNo, sStartTime: string;
  nRemainMin: Integer;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '타석 이동이 완료 되었습니다.';

  RO1 := TJSONObject.Create;
  RO2 := TJSONObject.Create;
  JO1 := TJSONObject.Create;
  JO2 := nil;
  JV2 := nil;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO1.AddPair(TJSONPair.Create('api', CS_API));
      JO1.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO1.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      JO1.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
      JO1.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
      JO1.AddPair(TJSONPair.Create('assign_balls', IntToStr(AAssignBalls)));
      JO1.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
      sBuffer := JO1.ToString;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      if not (JO2.FindValue('data') is TJSONNull) then
      begin
        JV2 := JO2.GetValue('data');
        if ((JV2 as TJSONArray).Count > 0) then //배열이지만 1건만 수신됨
        begin
          sReserveNo := (JV2 as TJSONArray).Items[0].P['reserve_no'].Value;
          sStartTime := (JV2 as TJSONArray).Items[0].P['start_datetime'].Value; //yyyy-mm-dd hh:nn:ss
          nRemainMin := StrToIntDef((JV2 as TJSONArray).Items[0].P['remain_min'].Value, 0);
          RO2.AddPair(TJSONPair.Create('reserve_no', sReserveNo));
          RO2.AddPair(TJSONPair.Create('start_datetime', sStartTime));
          RO2.AddPair(TJSONPair.Create('remain_min', TJSONNumber.Create(nRemainMin)));
          Result := True;
        end;
      end;
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO1.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO1.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    RO1.AddPair(TJSONPair.Create('result_data', RO2));
    ABuffer := RO1.ToString;
    SetLed(LC_LED_TEEBOX_AD, Result);
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(JO1);
    FreeAndNilJSONObject(JV2);
    FreeAndNilJSONObject(JO2);
    FreeAndNilJSONObject(RO2);
    FreeAndNilJSONObject(RO1);
  end;
end;

function TDM.DoImmediateTeeBoxStart_ELOOM(var ABuffer: string; const AReserveNo: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'A417_TeeBoxStart';
var
  JO1, JO2, RO1: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '즉시배정이 완료 되었습니다.';

  RO1 := TJSONObject.Create;
  JO1 := TJSONObject.Create;
  JO2 := nil;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO1.AddPair(TJSONPair.Create('api', CS_API));
      JO1.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
      JO1.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      sBuffer := JO1.ToString;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));

      Result := True;
    except
      on E: Exception do
      begin
        AErrCode := '9999';
        AErrMsg := E.Message;
      end;
    end;

    RO1.AddPair(TJSONPair.Create('result_cd', AErrCode));
    RO1.AddPair(TJSONPair.Create('result_msg', AErrMsg));
    ABuffer := RO1.ToString;
    SetLed(LC_LED_TEEBOX_AD, Result);
  finally
    TC.Disconnect;
    FreeAndNil(TC);
    FreeAndNilJSONObject(JO1);
    FreeAndNilJSONObject(JO2);
    FreeAndNilJSONObject(RO1);
  end;
end;

function TDM.SetTeeBoxError_ELOOM(var ABuffer: string; const ATeeBoxNo: Integer; const AStatusCode: string; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API_1 = 'K403_TeeBoxError';
  CS_API_2 = 'K404_TeeBoxError';
var
  JO1, JO2, RO: TJSONObject;
  TC: TIdTCPClient;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
  bIsSetError: Boolean;
begin
  Result := False;
  bIsSetError := (AStatusCode <> '0'); //정상
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '타석이 ' + IIF(bIsSetError, '장애', '정상') + ' 상태로 변경 되었습니다.';

  RO := TJSONObject.Create;
  JO1 := TJSONObject.Create;
  JO2 := nil;
  TC := TIdTCPClient.Create(nil);
  try
    try
      JO1.AddPair(TJSONPair.Create('api', String(IIF(bIsSetError, CS_API_1, CS_API_2))));
      JO1.AddPair(TJSONPair.Create('store_cd', Config.StoreCode));
      JO1.AddPair(TJSONPair.Create('user_id', Config.ClientId));
      JO1.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
      JO1.AddPair(TJSONPair.Create('error_div', AStatusCode));
      sBuffer := JO1.ToString;

      TC.Host := Config.TeeBoxADHost;
      TC.Port := Config.TeeBoxADPort;
      TC.ConnectTimeout := Config.MobileADTimeout;
      TC.ReadTimeout := Config.MobileADTimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
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
    FreeAndNilJSONObject(JO2);
    FreeAndNilJSONObject(JO1);
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

function TDM.DoTeeBoxHold(var ABuffer: string; const ATeeBoxNo: Integer; const AUseHold: Boolean; var AErrCode, AErrMsg: string): Boolean;
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
      JO.AddPair(TJSONPair.Create('user_id', Config.ClientId));
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
  const AReserveRootDiv, AMemberNo, AMemberName, APurchaseCode, AProductCode, ATeeBoxProductDiv, AProductName: string;
  const AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K408_TeeBoxReserve2';
var
  JO, IO, RO: TJSONObject;
  IA: TJSONArray;
  JV: TJSONValue;
  TC: TIdTCPClient;
  RBS: RawByteString;
//  RS: TStringStream;
  sBuffer, sReserveNo, sReserveDateTime, sStartDateTime, sEndDateTime: string;
  nCount, nAssignMin: Integer;
begin
  Result := False;
  ABuffer := '';
  AErrCode := '0000';
  AErrMsg := '타석 예약이 처리 되었습니다.';
  RBS := '';

//  RS := TStringStream.Create;
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
        JO.AddPair(TJSONPair.Create('user_id', Config.ClientId));
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
//      RS := TStringStream.Create(RBS, TEncoding.UTF8);
//      RS.SaveToFile(Config.LogDir + CS_API + '.Response.json');
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      RO := TJSONObject.Create;
      AErrCode := JO.GetValue('result_cd').Value;
      AErrMsg := JO.GetValue('result_msg').Value;
      Result := (AErrCode = CRC_SUCCESS);
      if Result then
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
//    RS := TStringStream.Create(ABuffer, TEncoding.UTF8);
//    RS.SaveToFile(Config.LogDir + CS_API + '.Response.json');
  finally
    TC.Disconnect;
    FreeAndNil(TC);
//    FreeAndNil(RS);
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

end.
