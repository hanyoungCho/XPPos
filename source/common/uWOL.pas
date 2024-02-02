unit uWOL;

interface

uses
  { Native }
  Classes, SysUtils,
  { Indy }
  IdGlobal, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient;

const
  BASE_MAGIC_PACKET = 6;
  MAGIC_PACKET_SIZE = 102;

function SendPacketWOL(const AHost, AMACAddr: string; APort: Word): boolean;

implementation

function SendPacketWOL(const AHost, AMACAddr: string; APort: Word): boolean;
var
  i, nMod: integer;
  HostIP: string;
  UDPClient: TIdUDPClient;
//  MagicPacket: array [0..Pred(MAGIC_PACKET_SIZE)] of Byte;
  MagicPacket: TIdBytes;
  TargetAddr: array [0..Pred(BASE_MAGIC_PACKET)] of Byte;
  SL: TStringList;
begin
  Result := False;
  HostIP := '';
  SL := TStringList.Create;
  try
    ExtractStrings(['.'], [], PChar(AHost), SL);
    if (SL.Count < 4) then Exit;

    SL.Strings[3] := '255';
    for i := 0 to 3 do
    begin
      if (HostIP <> '') then
        HostIP := HostIP + '.';
      HostIP := HostIP + SL.Strings[i];
    end;
  finally
    FreeAndNil(SL);
  end;

  FillChar(MagicPacket, SizeOf(MagicPacket), 0);
  for i := 0 to Pred(BASE_MAGIC_PACKET) do
  begin
    MagicPacket[i] := $FF;
    TargetAddr[i] := StrToInt('$' + Copy(AMacAddr, (i * 3) + 1, 2));
  end;

  for i := BASE_MAGIC_PACKET to Pred(MAGIC_PACKET_SIZE) do
  begin
    nMod := (i mod BASE_MAGIC_PACKET);
    MagicPacket[i] := TargetAddr[nMod];
  end;

  UDPClient := TIdUDPClient.Create(nil);
  with UDPClient do
  try
    BroadcastEnabled := True;
    Host := HostIP;
    Port := APort;
    try
      Active := True;
//      SendBuffer(MagicPacket, SizeOf(MagicPacket));
      SendBuffer(Host, Port, TIdBytes(MagicPacket));
      Result := True;
    except
    end;
  finally
    Active := False;
    Free;
  end;
end;

end.
