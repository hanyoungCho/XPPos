(*
»ç¿ë¹ý:
var
  tmpStrings: TStringList;
begin
  try
    tmpStrings := TStringList.Create;
    GetMacAddresses(tmpStrings);
    ShowMessage(tmpStrings.Text);
  finally
    FreeAndNil( tmpStrings);
  end;
end;

*)
unit uMACAddr;

interface

uses Classes, Sysutils, Windows;

type
  time_t = Longint;
  {$EXTERNALSYM time_t}

const
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128; // arb.
  {$EXTERNALSYM MAX_ADAPTER_DESCRIPTION_LENGTH}
  MAX_ADAPTER_NAME_LENGTH        = 256; // arb.
  {$EXTERNALSYM MAX_ADAPTER_NAME_LENGTH}
  MAX_ADAPTER_ADDRESS_LENGTH     = 8; // arb.

type
  { IP address structures }
  PIP_ADDRESS_STRING = ^IP_ADDRESS_STRING;
  IP_ADDRESS_STRING = array[0..15] of char; // IP as string
  PIP_ADDR_STRING = ^IP_ADDR_STRING;

  IP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: IP_ADDRESS_STRING;
    IpMask: IP_ADDRESS_STRING;
    Context: DWORD;
  end;

  { Adaptor Info Structures }
  PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
  IP_ADAPTER_INFO = record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array[1..MAX_ADAPTER_NAME_LENGTH + 4] of char;
    Description: array[1..MAX_ADAPTER_DESCRIPTION_LENGTH + 4] of char;
    AddressLength: UINT;
    Address: array[1..MAX_ADAPTER_ADDRESS_LENGTH] of byte;
    Index: DWORD;
    aType: UINT;
    DHCPEnabled: UINT;
    CurrentIPAddress: PIP_ADDR_STRING;
    IPAddressList: IP_ADDR_STRING;
    GatewayList: IP_ADDR_STRING;
    DHCPServer: IP_ADDR_STRING;
    HaveWINS: BOOL;
    PrimaryWINSServer: IP_ADDR_STRING;
    SecondaryWINSServer: IP_ADDR_STRING;
    LeaseObtained: LongInt;
    LeaseExpires: LongInt;
    SpareStuff: array [1..200] of char;
  end;

  function GetMacAddresses(out AList: TStringList): integer;

implementation

function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO; pOutBufLen: PULONG): DWORD; stdcall; external 'Iphlpapi.dll' name 'GetAdaptersInfo';

function MACToStr(ByteArr: PByte; Len: Integer): string;
begin
  Result := '';
  while (Len > 0) do Begin
    Result := Result+IntToHex(ByteArr^,2)+'-';
    ByteArr := Pointer(Integer(ByteArr)+SizeOf(Byte));
    Dec(Len);
  end;
  SetLength(Result,Length(Result)-1); { remove last dash }
end;

function GetMacAddresses(out AList: TStringList): integer;
const
  AddrLen = 6;
var
  AdapterInfo: array [0..15] of IP_ADAPTER_INFO;
  TmpNext: PIP_ADAPTER_INFO;
  OutBufLen: ulong;
begin
  OutBufLen := SizeOf(AdapterInfo);
  Result := GetAdaptersInfo(@AdapterInfo, @OutBufLen);
  if (Result = ERROR_SUCCESS) then
  begin
    TmpNext := @AdapterInfo;
    repeat
      AList.Add(MACToStr(@TmpNext^.Address, TmpNext^.AddressLength));
      TmpNext:= TmpNext.Next;
    until (TmpNext = nil);
  end;
end;

end.
