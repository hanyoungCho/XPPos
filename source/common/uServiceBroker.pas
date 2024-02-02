unit uServiceBroker;

interface

uses
  SvcMgr, WinSvc;

const
  SS_STOP     = 0;
  SS_START    = 3;
  SS_PAUSE    = 6;
  SS_CONTINUE = 7;

function ServiceStart(const AServiceName: string): boolean;
function ServiceExecute(const AServiceName: string; ACommand: integer): boolean;
function ServiceStatus(const AServiceName: string): TCurrentStatus;
function ServiceStatusToInteger(const AServiceName: string): integer;
function ServiceInfo(const AServiceName: string; out ADispName, APath: string): boolean;

implementation

uses
  Windows;

function ServiceStart(const AServiceName: string): Boolean;
var
  hManager, hService: THandle;
  SS: TServiceStatus;
  lpServiceArgVectors: LPCWSTR;
begin
  SS.dwCurrentState := 0;
  hManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if (hManager > 0) then
  begin
    hService := OpenService(hManager, PChar(AServiceName), SERVICE_START or SERVICE_QUERY_STATUS);
    if (hService > 0) then
    begin
      lpServiceArgVectors := nil;
      StartService(hService, 0, lpServiceArgVectors);
      CloseServiceHandle(hService);
    end;
    CloseServiceHandle(hManager);
  end;
  Result := (SERVICE_RUNNING = SS.dwCurrentState);
end;

function ServiceExecute(const AServiceName: string; ACommand: integer): boolean;
var
  hManager, hService: THandle;
  SS: TServiceStatus;
  lpServiceArgVectors: LPCWSTR;
begin
  Result := False;
  SS.dwCurrentState := 0;
  hManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if (hManager > 0) then
  begin
    hService := OpenService(hManager, PChar(AServiceName),
      SERVICE_START or SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (hService > 0) then
    begin
      QueryServiceStatus(hService, SS);
      case ACommand of
        SS_STOP:
          if (SS.dwCurrentState = SERVICE_RUNNING) then
            Result := ControlService(hService, SERVICE_CONTROL_STOP, SS);

        SS_START:
          if (SS.dwCurrentState = SERVICE_STOPPED) then
          begin
            lpServiceArgVectors := nil;
            Result := StartService(hService, 0, lpServiceArgVectors);
            CloseServiceHandle(hService);
          end;

        SS_PAUSE:
          if (SS.dwCurrentState = SERVICE_RUNNING) then
            Result := ControlService(hService, SERVICE_CONTROL_PAUSE, SS);

        SS_CONTINUE:
          if SS.dwCurrentState = SERVICE_PAUSED then
            Result := ControlService(hService, SERVICE_CONTROL_CONTINUE, SS);
      end;
      CloseServiceHandle(hService);
    end;
    CloseServiceHandle(hManager);
  end;
end;

function ServiceStatus(const AServiceName: string): TCurrentStatus;
var
  hManager, hService: THandle;
  SS: TServiceStatus;
begin
  Result := csStopped;
  SS.dwCurrentState := 0;
  hManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if (hManager > 0) then
  begin
    hService := OpenService(hManager, PChar(AServiceName),
      SERVICE_START or SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (hService > 0) then
    begin
      QueryServiceStatus(hService, SS);
      case SS.dwCurrentState of
        SERVICE_STOPPED:
          Result := csStopped;
        SERVICE_RUNNING:
          Result := csRunning;
        SERVICE_PAUSED:
          Result := csPaused;
      end;
      CloseServiceHandle(hService);
    end;
    CloseServiceHandle(hManager);
  end;
end;

function ServiceStatusToInteger(const AServiceName: string): integer;
begin
  Result := Integer(ServiceStatus(AServiceName));
end;

function ServiceInfo(const AServiceName: string; out ADispName, APath: string): boolean;
var
  hManager, hService: THandle;
  pConfig: Pointer;
  nSize: Cardinal;
begin
  Result := False;
  ADispName := '';
  APath := '';
  hManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if (hManager <> 0) then
  begin
    hService := OpenService(hManager, PChar(AServiceName), SERVICE_QUERY_CONFIG);
    if (hService <> 0) then
    begin
      QueryServiceConfig(hService, nil, 0, nSize);
      pConfig := AllocMem(nSize);
      try
        QueryServiceConfig(hService, pConfig, nSize, nSize);
        ADispName := PQueryServiceConfig(pConfig)^.lpDisplayName;
        APath := PQueryServiceConfig(pConfig)^.lpBinaryPathName;
        Result := True;
      finally
        Dispose(pConfig);
      end;
      CloseServiceHandle(hService);
    end;
    CloseServiceHandle(hManager);
  end;
end;

end.

