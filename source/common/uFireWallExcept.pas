unit uFireWallExcept;

interface

uses
  Windows, SysUtils;

implementation

uses
  ComObj;

const
  NET_FW_PROFILE_DOMAIN = 0;
  NET_FW_PROFILE_STANDARD = 1;
  NET_FW_PROFILE2_PRIVATE = 2;
  NET_FW_PROFILE2_PUBLIC  = 4;
  NET_FW_IP_VERSION_ANY = 2;
  NET_FW_IP_PROTOCOL_UDP = 17;
  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_SCOPE_ALL = 0;
  NET_FW_SCOPE_LOCAL_SUBNET = 1;
  NET_FW_ACTION_ALLOW = 1;

function GetXPFirewall(var fwMgr, profile: OleVariant): boolean;
begin
  result := (Win32Platform=VER_PLATFORM_WIN32_NT) and
    (Win32MajorVersion>5) or ((Win32MajorVersion=5) and (Win32MinorVersion>0));
  if result then // need Windows XP at least
  try
    fwMgr := CreateOleObject('HNetCfg.FwMgr');
    profile := fwMgr.LocalPolicy.CurrentProfile;
  except
    on E: Exception do
      result := false;
  end;
end;

function GetVistaSevenFirewall(var fwMgr, rule: OleVariant; const Description: string): boolean;
begin
  result := (Win32Platform=VER_PLATFORM_WIN32_NT) and (Win32MajorVersion>5);
  if result then // need Windows Vista at least
  try
    fwMgr := CreateOleObject('HNetCfg.FwPolicy2');
    rule := CreateOleObject('HNetCfg.FWRule');
    rule.Name := Description;
    rule.Description := Description;
    rule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    rule.Enabled := true;
    rule.Profiles := NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC;
    rule.Action := NET_FW_ACTION_ALLOW;
  except
    on E: Exception do
      result := false;
  end;
end;

procedure AddApplicationToFirewall(const EntryName, ApplicationPathAndExe: string);
var fwMgr, profile, app, rule: OleVariant;
begin
  if Win32MajorVersion<6 then begin
    if GetXPFirewall(fwMgr,profile) and profile.FirewallEnabled then begin
      app := CreateOLEObject('HNetCfg.FwAuthorizedApplication');
      app.ProcessImageFileName := ApplicationPathAndExe;
      app.Name := EntryName;
      app.Scope := NET_FW_SCOPE_ALL;
      app.IpVersion := NET_FW_IP_VERSION_ANY;
      app.Enabled := true;
      profile.AuthorizedApplications.Add(app);
    end;
  end else
    if GetVistaSevenFirewall(fwMgr,rule,EntryName) then begin
      rule.ApplicationName := ApplicationPathAndExe;
      fwMgr.Rules.Add(rule);
    end;
end;

procedure AddPortToFirewall(const EntryName: string; PortNumber: cardinal);
var fwMgr, profile, port, rule: OleVariant;
begin
  if Win32MajorVersion<6 then begin
    if GetXPFirewall(fwMgr,profile) and profile.FirewallEnabled then begin
      port := CreateOLEObject('HNetCfg.FWOpenPort');
      port.Name := EntryName;
      port.Protocol := NET_FW_IP_PROTOCOL_TCP;
      port.Port := PortNumber;
      port.Scope := NET_FW_SCOPE_ALL;
      port.Enabled := true;
      profile.GloballyOpenPorts.Add(port);
    end;
  end else
    if GetVistaSevenFirewall(fwMgr,rule,EntryName) then begin
      rule.LocalPorts := PortNumber;
      fwMgr.Rules.Add(rule);
    end;
end;

end.
