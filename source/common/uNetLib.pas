unit uNetLib;

interface

uses
  Windows, Classes, SysUtils;

const
  CN_WOL_PORT = 9;

function SendARP(DestIp: DWORD; srcIP: DWORD; pMacAddr: pointer; PhyAddrLen: Pointer): DWORD; stdcall; external 'iphlpapi.dll';

function GetLocalHostName: string;
procedure GetIPAddressList(AIPList: TStrings);
function GetIPAddress: string;
function GetMACAddress(const AIPAddress: string): string;
Function GetPublicIPAddress: string;
function WakeOnLan(const AMACAddress: string): string;
procedure GetNetworkedDrives(AStrings: TStrings);
function VerifyIPAddress(const AIPAddress: string; const AWaitMSec: Integer=1000): Boolean;

implementation

uses
  IdGlobal, IdUDPClient, IdIPAddress, IdStack, IdIcmpClient, IdHTTP, WinSock;

function GetLocalHostName: string;
begin
  TIdStack.IncUsage;
  try
    Result := GStack.HostName;
  finally
    TIdStack.DecUsage;
  end;
end;

procedure GetIPAddressList(AIPList: TStrings);
var
  IPS: TStrings; //TIdStackLocalAddressList;
  IPA: TIdIPAddress;
  IP: string;
  I: integer;
begin
  AIPList.BeginUpdate;
  AIPList.Clear;
  IPS := TStringList.Create;
  try
    GStack.AddLocalAddressesToList(IPS);
    for I := 0 to Pred(IPS.Count) do
    begin
      IPA := TIdIPAddress.MakeAddressObject(IPS[I]);
      try
        IP := IPA.IPv4AsString;
        if not IP.IsEmpty then
          AIPList.Add(IP);
      finally
        IPA.Free;
      end;
    end;
  finally
    AIPList.EndUpdate;
    IPS.Free;
  end;
end;

function GetIPAddress: string;
var
  WSAData: TWSAData;
  sHost, sAddr: string;
begin
  Result := '';
  WSAStartup($0101, WSAData); //WSAStartup(2, WSAData);
  try
    SetLength(sHost, 255);
    GetHostName(PAnsiChar(sHost), 255);
    SetLength(sHost, StrLen(PChar(sHost)));
    with GetHostByName(PAnsiChar(sHost))^ do
      sAddr := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
  finally
    WSACleanup;
  end;
  Result := sAddr;
end;

function GetMACAddress(const AIPAddress: string): string;
var
  WSAData: TWSAData;
  dwMacAddr: array[0..5] of Byte;
  dwMacAddrLen: DWORD;
  dwDestIP: DWORD;
  dwResult: DWORD;
begin
  Result := '';
  WSAStartup($0101, WSAData);
  try
    ZeroMemory(@dwMacAddr, SizeOf(dwMacAddr));
    dwDestIP := Inet_Addr(PAnsiChar(AnsiString(AIPAddress)));
    dwMacAddrLen := SizeOf(dwMacAddr);
    dwResult := SendARP(dwDestIP, 0, @dwMacAddr, @dwMacAddrLen);
    if (dwResult = NO_ERROR) then
      Result := Format('%2.2X-%2.2X-%2.2X-%2.2X-%2.2X-%2.2X', [dwMacAddr[0], dwMacAddr[1], dwMacAddr[2], dwMacAddr[3], dwMacAddr[4], dwMacAddr[5]]);
  finally
    WSACleanup;
  end;
end;

function GetPublicIPAddress: string;
const
  LC_TRY_1 = 'http://dynupdate.no-ip.com/ip.php';
  LC_TRY_2 = 'http://www.networksecuritytoolkit.org/nst/tools/ip.php';
begin
  Result := '';
  with TIdHTTP.Create(nil) do
  try
    try
      Result := Get(LC_TRY_1);
    except
      Result := Get(LC_TRY_2);
    end;
  finally
    Free;
  end;
end;

function WakeOnLan(const AMACAddress: string): string;
var
  lBuffer: TIdBytes;
  sMACAddr: string;
  i, j: Byte;
begin
  Result := '';
  sMACAddr := StringReplace(StringReplace(UpperCase(AMacAddress), '-', '', [rfReplaceAll]), ':', '', [rfReplaceAll]);

  try
    SetLength(lbuffer, 117);
    for i := 1 to 6 do
      lBuffer[i] := StrToIntDef('$' + sMACAddr[(i * 2) - 1] + sMACAddr[i * 2], 0);

    lBuffer[7] := $00;
    lBuffer[8] := $74;
    lBuffer[9] := $FF;
    lBuffer[10] := $FF;
    lBuffer[11] := $FF;
    lBuffer[12] := $FF;
    lBuffer[13] := $FF;
    lBuffer[14] := $FF;

    for i := 1 to 16 do
      for j := 1 to 6 do
        lBuffer[15 + (i - 1) * 6 + (j - 1)] := lBuffer[j];

    lBuffer[116] := $00;
    lBuffer[115] := $40;
    lBuffer[114] := $90;
    lBuffer[113] := $90;
    lBuffer[112] := $00;
    lBuffer[111] := $40;

    with TIdUDPClient.Create(nil) do
    try
      BroadcastEnabled := True;
      Host := '255.255.255.255';
      Port := CN_WOL_PORT;
      SendBuffer(lBuffer);
    finally
      Free;
    end;
  except
    on E: Exception do
      Result := Format('Error: %s'+E.Message+', WakeUp: %s', [E.Message, sMACAddr]);
  end;
end;

procedure GetNetworkedDrives(AStrings: TStrings);
  procedure EnumNetworkDrives(pnr: PNetResource);
  var
    hEnum: THandle;
    i, enumRes, count, BufferSize: DWORD;
    buffer: pointer;
  begin
    BufferSize := $4000; //ie: use a 16kb buffer
    buffer := nil;  //just in case memory allocation fails
    if WNetOpenEnum(RESOURCE_GLOBALNET,
      RESOURCETYPE_DISK, 0, pnr, hEnum) = ERROR_SUCCESS then
    try
      GetMem(buffer, BufferSize);
      while true do
      begin
        count := dword(-1); //ie: get as many items possible
        enumRes := WNetEnumResource(hEnum,
          count, buffer, BufferSize);

        //break if either no more items found or an error occurs...
        if (enumRes <> ERROR_SUCCESS) then break;

        pnr := buffer; //reuse the pnr pointer
        for i := 1 to count do
        begin
          if (pnr.dwDisplayType =
               RESOURCEDISPLAYTYPE_DOMAIN or
               RESOURCEDISPLAYTYPE_SERVER) and
            (pnr.dwType = RESOURCETYPE_DISK) then
              AStrings.Add(pnr.lpRemoteName);
          //recursive function call...
          if (pnr.dwUsage and RESOURCEUSAGE_CONTAINER) > 0 then
            EnumNetworkDrives(pnr);
          inc(longint(pnr),sizeof(TNetResource));
        end;
      end;
    finally
      FreeMem(buffer);
      WNetCloseEnum(hEnum);
    end;
  end;
begin
  if AStrings = nil then
  	Exit;

  EnumNetworkDrives(nil);
end;

function VerifyIPAddress(const AIPAddress: string; const AWaitMSec: Integer): Boolean;
begin
  Result := False;
  with TIdIcmpClient.Create(nil) do
  try
    try
      Host := AIPAddress;
      Ping;
      Sleep(AWaitMSec);
      Result := (ReplyStatus.BytesReceived > 0);
    except
      on E: Exception do;
    end;
  finally
    Free;
  end;
end;

end.
