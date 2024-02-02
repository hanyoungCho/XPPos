unit uSBVanFunctions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils,
  ComObj, Math, uSBVanApprove;

  // ���ڿ� ���� �Ҵ� �� �ʱ�ȭ
  procedure SetLenAndFill(var AStr: AnsiString; ALen: Integer);
  // �ش� ���ڿ� ���̸�ŭ 3ȸ ���� �����Ͽ� �����.
  procedure EraseMemory(var ABuff: AnsiString); overload;
  procedure EraseMemory(var ABuff: WideString); overload;
  // ���ڿ� ����Ÿ�� �����Ѵ�.
  procedure CopyStrData(ASource: AnsiString; out ADest: AnsiString);
  // INI ���Ͽ��� ������ �����´�.
  function GetSeqNo(AWrite: Boolean = True): Integer; overload;
  function GetSeqNo(AFileName: string; AWrite: Boolean = True; AMaxNum: Integer = 0): Integer; overload;
  // Ư�����ڸ� �������� ���ڿ��� �Ľ��Ͽ� �����´�.(�����ڿ�, ã������, Skip��)
  function StringSearch(AStr: AnsiString; ASubStr: AnsiString; ASkipCount: Integer): AnsiString;
  // ���ڸ� �����Ѵ�.
  function ExtractNumber(AStr: AnsiString): Integer;
  // String Ÿ���� AnsiString�� ��ȯ
  function StrToAnsiStr(AStr: string): AnsiString;
  // ���ڿ� ä��� ���� �ڸ����� ���� �ʰ� ©���ش�.
  function LPadB(const AStr: AnsiString; ALength: Integer; APadChar: AnsiChar = ' '): AnsiString;
  function RPadB(const AStr: AnsiString; ALength: Integer; APadChar: AnsiChar = ' '): AnsiString;
  // �������� ���� �ڸ����� ä���� ������ �ش�.
  function CurrToStrLPad(AValue: Currency; ALength: Integer): AnsiString;
  function CurrToStrRPad(AValue: Currency; ALength: Integer): AnsiString;
  // ���ڿ� ���� (Byte ����)
  function ByteLen(const AText: string): Integer;
  // �ѱ� �ڸ���
  function SCopy(S: AnsiString; F, L: Integer): string;
  // OCX ��� / ����
  function RegisterOcx(AClassID: string; AOcxPath: string; ARegister: Boolean): Boolean;
  // OCX �� ��ġ�Ǿ� ���� ������ ��ġ�Ѵ�.
  function CheckRegisterOcx(AClassID: string; AOcxPath: string): Boolean;
  // Delay �Լ�
  procedure Delay(dwMilliseconds: Longint);
  // LRC�� ���Ѵ�.
  function GetLRC(AData: AnsiString): AnsiChar;
  // ����Ʈ �ڵ带 ��ȯ�Ѵ�.
  function ReceiptReplaceStringAll(VanType: TVanCompType; APrintData: AnsiString): AnsiString;
  // ����Ʈ �ڵ带 ��ȯ�Ѵ�.
  function ReceiptReplaceString(VanType: TVanCompType; APrintData: AnsiString): AnsiString;
  // ���ڵ� �ڵ带 ��ȯ�Ѵ�.
  function ConvertBarCodeCMD(AData: string): string;

implementation

uses
  IniFiles;

procedure SetLenAndFill(var AStr: AnsiString; ALen: Integer);
begin
  SetLength(AStr, ALen);
  FillChar(AStr[1], ALen, 0);
end;

procedure EraseMemory(var ABuff: AnsiString);
begin
  // 3ȸ �ݺ� ó�� �Ѵ�.
  FillChar(ABuff[1], Length(ABuff), #$AA);
  FillChar(ABuff[1], Length(ABuff), #$FF);
  FillChar(ABuff[1], Length(ABuff), #$0);
end;

procedure EraseMemory(var ABuff: WideString);
begin
  // 3ȸ �ݺ� ó�� �Ѵ�.
  FillChar(ABuff[1], Length(ABuff), #$AA);
  FillChar(ABuff[1], Length(ABuff), #$FF);
  FillChar(ABuff[1], Length(ABuff), #$0);
end;

procedure CopyStrData(ASource: AnsiString; out ADest: AnsiString);
var
  ALen: Integer;
begin
  ALen := Length(ASource);
  SetLenAndFill(ADest, ALen);
  Move(ASource[1], ADest[1], ALen);
end;

function GetSeqNo(AWrite: Boolean): Integer;
var
  ADate: string;
begin
  ADate := FormatDateTime('yyyymmdd', Date);
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'CardSeq.ini') do
    try
      Result := ReadInteger('SEQ', ADate, 0) + 1;
      if AWrite then
        WriteInteger('SEQ', ADate, Result);
    finally
      Free;
    end;
end;

function GetSeqNo(AFileName: string; AWrite: Boolean; AMaxNum: Integer): Integer;
var
  ADate: string;
begin
  ADate := FormatDateTime('yyyymmdd', Date);
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + AFileName) do
    try
      Result := ReadInteger('SEQ', ADate, 0) + 1;
      if (AMaxNum > 0) and (AMaxNum < Result) then
        Result := 0;
      if AWrite then
        WriteInteger('SEQ', ADate, Result);
    finally
      Free;
    end;
end;

function StringSearch(AStr: AnsiString; ASubStr: AnsiString; ASkipCount: Integer): AnsiString;
var
  Index: Integer;
begin
  for Index := 1 to ASkipCount do
    Delete(AStr, 1, Pos(ASubStr, AStr));
  if Pos(ASubStr, AStr) = 0 then
    Result := AStr
  else
    Result := Copy(AStr, 1, Pos(ASubStr, AStr) - 1);
end;

function ExtractNumber(AStr: AnsiString): Integer;
var
  i: Integer;
  Temp: AnsiString;
begin
  Temp := '';
  for i := 1 to Length(AStr) do
    if (AStr[i] in ['0'..'9']) then Temp := Temp + AStr[i];

  TryStrToInt(Temp, Result);
end;

function StrToAnsiStr(AStr: string): AnsiString;
begin
  Result := AStr;
end;

function LPad(const AStr: AnsiString; ALength: Integer; APadChar: AnsiChar): AnsiString;
var
  Index: Integer;
begin
  Result := '';
  for index := 0 to (ALength - Length(AStr)) - 1 do
    Result := Result + AnsiString(APadChar);

  Result := Result + AStr;
end;

function RPad(const AStr: AnsiString; ALength: Integer;
  APadChar: AnsiChar): AnsiString;
var
  Index: Integer;
begin
  Result := AStr;
  if Length(AStr) < ALength then
    for Index := 0 to ALength - Length(AStr) - 1 do
      Result := Result + AnsiString(APadChar);
end;

function ByteLen(const AText: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 1 to Length(AText) do
    Result := Result + IfThen(AText[Index] <= #$00FF, 1, 2);
end;

function SCopy(S: AnsiString; F, L: Integer): string;
var
  ST, ED: Integer;
begin
  if F = 1 then ST := 1
  else
  begin
    case ByteType(S, F) of
      mbSingleByte : ST := F;
      mbLeadByte   : ST := F;
      mbTrailByte  : ST := F - 1;
    end;
  end;

  case ByteType(S, ST+L-1) of
    mbSingleByte : ED := L;
    mbLeadByte   : ED := L - 1;
    mbTrailByte  : ED := L;
  end;

  Result := Copy(S, ST, ED);
end;

function LPadB(const AStr: AnsiString; ALength: Integer;
  APadChar: AnsiChar): AnsiString;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := LPad(Result, ALength, APadChar);
end;

function RPadB(const AStr: AnsiString; ALength: Integer;
  APadChar: AnsiChar): AnsiString;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := RPad(Result, ALength, APadChar);
end;

function CurrToStrLPad(AValue: Currency; ALength: Integer): AnsiString;
begin
  Result := Format('%' + IntToStr(ALength) + '.' + IntToStr(ALength) + 's', [CurrToStr(AValue)]);
end;

function CurrToStrRPad(AValue: Currency; ALength: Integer): AnsiString;
begin
  Result := Format('%-' + IntToStr(ALength) + '.' + IntToStr(ALength) + 's', [CurrToStr(AValue)]);
end;

function RegisterOcx(AClassID: string; AOcxPath: string; ARegister: Boolean): Boolean;
type
  TDllProc = function:
  HResult; stdcall;
var
  hModule: THandle;
  DllProc: TDllProc;
  bRegisterd: Boolean;
begin
  Result := False;

  if ARegister then
  begin
    try
      ClassIDToProgID(StringToGUID(AClassID));
      Result := True;
      Exit;
    except
    end;
  end;

  hModule := LoadLibrary(PChar(AOcxPath));
  try
    if hModule=0 then
      Exit;

    if ARegister then
      @DllProc := GetProcAddress(hModule, 'DllRegisterServer')
    else
      @DllProc := GetProcAddress(hModule, 'DllUnregisterServer');

    if @DllProc = nil then Exit;

    Result := DllProc = S_OK;
  finally
    FreeLibrary(hModule);
  end;
end;

function CheckRegisterOcx(AClassID: string; AOcxPath: string): Boolean;
var
  ChkInst: Boolean;
begin
  ChkInst := False;
  try
    ClassIDToProgID(StringToGUID(AClassID));
    ChkInst := True;
  except
  end;
  if ChkInst then
  begin
    Result := True;
    Exit;
  end;
  try
    RegisterComServer(AOcxPath);
    Result := True;
  except
    Result := False;
  end;
end;

procedure Delay(dwMilliseconds: Longint);
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Sleep(1);
  until (iStop - iStart) >= dwMilliseconds;
end;

function GetLRC(AData: AnsiString): AnsiChar;
var
  Index: Integer;
  ALRC: Byte;
begin
  ALRC := 0;
  for Index := 1 to Length(AData) do
    ALRC := ALRC xor Ord(AData[Index]);
  ALRC := ALRC or Ord(AnsiChar($20));
  Result := AnsiChar(ALRC);
end;

function ReceiptReplaceStringAll(VanType: TVanCompType; APrintData: AnsiString): AnsiString;
begin
  if VanType in [vctKSNET, vctKIS] then
  begin
    if VanType = vctKSNET then
    begin
      APrintData := StringReplace(APrintData, ']{-}{-}{Z}{C}', ']{-}{-}{C}{Z}', [rfReplaceAll]);
      APrintData := StringReplace(APrintData, '{-}{-}{S}{L}', '{-}{-}{L}{S}', [rfReplaceAll]);
      APrintData := StringReplace(APrintData, '{S}{-}{-}{L}', '{S}{-}{-}{L}{S}', [rfReplaceAll]);
      APrintData := StringReplace(APrintData, '{!}{C}{*}{Z}{C}', '{!}{C}{Z}', [rfReplaceAll]);
      APrintData := StringReplace(APrintData, '{S}', #27#33#0, [rfReplaceAll]);
    end
    else
      APrintData := StringReplace(APrintData, '{S}', '', [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{X}', #27#33#32, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Y}', #27#33#16, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Z}', #27#33#48, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{N}', '', [rfReplaceAll]);
  end
  else
  begin
    APrintData := StringReplace(APrintData, '{X}', #29#33#16, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Y}', #29#33#1, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Z}', #29#33#17, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{N}', #27#71#0#29#66#0#27#45#0, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{S}', #29#33#0, [rfReplaceAll]);
  end;
  APrintData := StringReplace(APrintData, '{I}', #29#66#1, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{U}', #27#45#1, [rfReplaceAll]);
  if (VanType = vctKIS) then
    APrintData := StringReplace(APrintData, '{L}', '', [rfReplaceAll])
  else
    APrintData := StringReplace(APrintData, '{L}', #27#97#0, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{R}', #27#97#2, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{C}', #27#97#1, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{B}', #27#71#1, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{3}', #29#33#34, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{4}', #29#33#51, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{!}', #27#64, [rfReplaceAll]);
  if VanType in [vctJTNet, vctKIS] then
    APrintData := StringReplace(APrintData, '{/}', '', [rfReplaceAll])
  else
    APrintData := StringReplace(APrintData, '{/}', #27'i', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{*}', #13#28#112#1#0, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{@}', #13#28#112#2#0, [rfReplaceAll]);
  if VanType in [vctStarVAN] then
    APrintData := StringReplace(APrintData, '{O}', #27#112, [rfReplaceAll])
  else
    APrintData := StringReplace(APrintData, '{O}', #27'p'#0#25#250#13#10, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{=}', #27#51#60, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{&}', #27#51#50, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{\}', #27#51#120, [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{-}', #13#10, [rfReplaceAll]);
  if VanType in [vctSmartro, vctKICC, vctKCP] then
  begin
    APrintData := ConvertBarCodeCMD(APrintData);
  end;
  APrintData := StringReplace(APrintData, '{<}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{[}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{>}', '', [rfReplaceAll]);

  Result := APrintData;
end;

function ReceiptReplaceString(VanType: TVanCompType; APrintData: AnsiString): AnsiString;
begin
  if VanType in [vctKFTC] then
    APrintData := ConvertBarCodeCMD(APrintData)
  else
  begin
    APrintData := StringReplace(APrintData, '{<}', '', [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{>}', '', [rfReplaceAll]);
  end;
  APrintData := StringReplace(APrintData, '{N}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{B}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{I}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{U}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{!}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{*}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{@}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{=}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{&}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{\}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{[}', '', [rfReplaceAll]);

  if VanType = vctKCP then
  begin
    APrintData := StringReplace(APrintData, '{O}', '', [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{-}', '', [rfReplaceAll]);
  end
  else if VanType = vctKFTC then
  begin
    APrintData := StringReplace(APrintData, '{O}', #27'p'#0#25#250#13#10, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{-}', #13#10, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{L}', #27#97#0, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{C}', #27#97#1, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{R}', #27#97#2, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{S}', #29#33#0, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{X}', #29#33#16, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Y}', #29#33#1, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{Z}', #29#33#17, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{3}', #29#33#34, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{4}', #29#33#51, [rfReplaceAll]);
  end
  else
  begin
    APrintData := StringReplace(APrintData, '{O}', #27'p'#0#25#250#13#10, [rfReplaceAll]);
    APrintData := StringReplace(APrintData, '{-}', #13#10, [rfReplaceAll]);
  end;
  APrintData := StringReplace(APrintData, '{L}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{C}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{R}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{S}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{X}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{Y}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{Z}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{3}', '', [rfReplaceAll]);
  APrintData := StringReplace(APrintData, '{4}', '', [rfReplaceAll]);
  if VanType in [vctKOCES, vctKFTC] then
    APrintData := StringReplace(APrintData, '{/}', #27'i', [rfReplaceAll]);

  Result := APrintData;
end;

function ConvertBarCodeCMD(AData: string): string;
const
  BAR_HEIGHT  = #$50; // ���ڵ����
  BAR_CODE39  = #69;
  BAR_ITF     = #70;
  BAR_CODABAR = #71;
  BAR_CODE93  = #72;
  BAR_CODE128 = #$49;//#73;
var
  BeginPos128, BeginPos39, BeginPos, EndPos: Integer;
  ChkBarCode39: Boolean;
  ALen: Char;
  BarCodeOrg, BarCodeToStr: string;
begin
  while Pos('{>}', AData) > 0 do
  begin
    BeginPos128 := Pos('{<}', AData);
    BeginPos39  := Pos('{[}', AData);
    BeginPos := Min(BeginPos128, BeginPos39);
    if BeginPos128 = 0 then BeginPos := BeginPos39;
    if BeginPos39 = 0 then BeginPos := BeginPos128;
    ChkBarCode39 := BeginPos = BeginPos39;
    EndPos := Pos('{>}', AData);

    if BeginPos <= 0 then Break;
    if EndPos <= 0 then Break;
    if BeginPos >= EndPos then Break;

    BarCodeOrg := Copy(AData, BeginPos + 3, EndPos - BeginPos - 3);

    if (VanModul.VanType in [vctKFTC, vctKCP]) and VanModul.CatTerminal then
      ALen := Char(Length(BarCodeOrg)) // 2 �� ���ؾ� ��
    else
      ALen := Char(Length(BarCodeOrg) + 2);
    BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE128 + ALen + #$7B#$42 + BarCodeOrg;
                  //#$1D#$68 +  #$30      + #$1D#$77#$01#$1B#$61#$01 + #$1D#$48#$02 + #$1D#$6B + BAR_CODE128 + #$10 + #$7B#$42 + BarCodeOrg;
    if (VanModul.VanType = vctKFTC) and VanModul.CatTerminal then
      BarCodeToStr := Trim(StringReplace(BarCodeToStr, '{B', '', [rfReplaceAll]));
    AData := StringReplace(AData, '{<}' + BarCodeOrg + '{>}', BarCodeToStr, [rfReplaceAll]);
  end;
  Result := AData;
end;

end.
