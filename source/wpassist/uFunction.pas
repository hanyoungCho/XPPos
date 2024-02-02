unit uFunction;

interface

uses
  Windows, FMX.Layouts, Classes, IdGlobal, EncdDecd, Vcl.Forms,
  System.SysUtils, JSON, Math, StrUtils, ComPort, Generics.Collections, InIFiles;

  function IfThen(IsTrue: Boolean; AValue, BValue: Variant): Variant;
  function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
  function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
  function SCopy(S: AnsiString; F, L: Integer): string;
  function PadChar(ALength: Integer; APadChar: Char = ' '): string;
  function ByteLen(const AText: string): Integer;
  function DateStrToDateTime(ADateTime: string): TDateTime;

  function GetStringValue(AJsonValue: TJSONValue; AKey: string): string;
  function GetIntegerValue(AJsonValue: TJSONValue; AKey: string): Integer;
  function GetCurrencyValue(AJsonValue: TJSONValue; AKey: string): Currency;
  function GetJsonValue(AJsonValue: TJsonValue; AKey: string): TJSONValue;

  function DateTimeStrToString(const ADateTime: string): string; // 20010101120130 -> 2001-01-01 12:01:30
  function GetCurrStr(AData: Currency): string;

  function NumberMasking(AData: string; ACnt: Integer): string;

  procedure EnumComPorts(Ports: TStrings);
  function GetBaudRate(ABaudRate: Integer): TBaudRate;
  function URLEncode(const psSrc: string): string;
  procedure Split(Input: string; const Delimiter: Char; var Strings: TStringList);

  function DateTimeSetString(ADatetime: string): string;
  function LogReplace(AStr: string): string;

  function WriteMediaCountInIFile(AKey: Variant): Boolean;
  procedure WriteLog(AError: Boolean; AFolder, ASaleDate, AName, AValue: string);
  function GetFileVersion: string;

  function GetWeekDay(ADateTime: TDateTime): string;

  procedure SetServerLocalTime(ATime: string);
  function SetSystemTime(const ADateTime: TDateTime): Boolean;

//  function TListClear(AList: TList<TObject>): Boolean;

implementation

function IfThen(IsTrue: Boolean; AValue, BValue: Variant): Variant;
begin
  if IsTrue then
    Result := AValue
  else
    Result := BValue;
end;

function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), APadChar) + Result;
end;

function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), APadChar);
end;

function SCopy(S: AnsiString; F, L: Integer): string;
var
  ST, ED: Integer;
begin
  ST := 0;
  ED := 0;

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

function PadChar(ALength: Integer; APadChar: Char = ' '): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to ALength do
    Result := Result + APadChar;
end;

function ByteLen(const AText: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 1 to Length(AText) do
    Result := Result + IfThen(AText[Index] <= #$00FF, 1, 2);
end;

function DateStrToDateTime(ADateTime: string): TDateTime;
begin
  Result := 0;
  if Length(ADateTime) = 14 then
  begin
    Result :=
      EncodeDate(StrToIntDef(Copy(ADateTime, 1, 4), 0),
        StrToIntDef(Copy(ADateTime, 5, 2), 0), StrToIntDef(Copy(ADateTime, 7, 2), 0)) +
      EncodeTime(StrToIntDef(Copy(ADateTime, 9, 2), 0),
        StrToIntDef(Copy(ADateTime, 11, 2), 0), StrToIntDef(Copy(ADateTime, 13, 2), 0), 0);
  end;
end;

function GetStringValue(AJsonValue: TJSONValue; AKey: string): string;
begin
  try
    Result := EmptyStr;
    Result := (AJsonValue as TJSONObject).Get(AKey).JsonValue.Value;
  except
    on E: Exception do
      Result := EmptyStr;
  end;
end;

function GetIntegerValue(AJsonValue: TJSONValue; AKey: string): Integer;
begin
  try
    Result := StrToIntDef((AJsonValue as TJSONObject).Get(AKey).JsonValue.Value, 0);
  except
    on E: Exception do
      Result := 0;
  end;
end;

function GetCurrencyValue(AJsonValue: TJSONValue; AKey: string): Currency;
begin
  try
    Result := StrToCurrDef((AJsonValue as TJSONObject).Get(AKey).JsonValue.Value, 0);
  except
    on E: Exception do
      Result := 0;
  end;
end;

function GetJsonValue(AJsonValue: TJsonValue; AKey: string): TJSONValue;
begin
  try
    if Trim(AJsonValue.ToString) <> EmptyStr then
      Result := (AJsonValue as TJSONObject).Get(AKey).JsonValue;
  except
    on E: Exception do
      Result := nil;
  end;
end;

function DateTimeStrToString(const ADateTime: string): string;
begin
  if Length(ADateTime) = 14 then
    Result := Copy(ADateTime, 1, 4) + FormatSettings.DateSeparator + Copy(ADateTime, 5, 2) + FormatSettings.DateSeparator + Copy(ADateTime, 7, 2) + ' ' +
              Copy(ADateTime, 9, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 11, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 13, 2);
end;

function GetCurrStr(AData: Currency): string;
begin
  Result := FormatFloat('#,##0.###', AData);
end;

function NumberMasking(AData: string; ACnt: Integer): string;
begin
  Result := RPadB(Copy(AData, 1, ACnt), Length(AData), '*');
end;

procedure EnumComPorts(Ports: TStrings);
var
  KeyHandle: HKEY;
  ErrCode, Index: Integer;
  ValueName, Data: string;
  ValueLen, DataLen, ValueType: DWORD;
  TmpPorts: TStringList;
begin
  ErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ, KeyHandle);

  if ErrCode <> ERROR_SUCCESS then
  begin
    //raise EComPort.Create(CError_RegError, ErrCode);
    exit;
  end;

  TmpPorts := TStringList.Create;
  try
    Index := 0;
    repeat
      ValueLen := 256;
      DataLen := 256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode := RegEnumValue(
        KeyHandle,
        Index,
        PChar(ValueName),
        {$IFDEF DELPHI_4_OR_HIGHER}
        Cardinal(ValueLen),
        {$ELSE}
        ValueLen,
          {$ENDIF}
        nil,
        @ValueType,
        PByte(PChar(Data)),
        @DataLen);

      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(Data, DataLen - 1);
        TmpPorts.Add(Data);
        Inc(Index);
      end
      else
        if ErrCode <> ERROR_NO_MORE_ITEMS then break;
          //raise EComPort.Create(CError_RegError, ErrCode);

    until (ErrCode <> ERROR_SUCCESS) ;

    TmpPorts.Sort;
    Ports.Assign(TmpPorts);
  finally
    RegCloseKey(KeyHandle);
    TmpPorts.Free;
  end;
end;

function GetBaudRate(ABaudRate: Integer): TBaudRate;
begin
  if ABaudRate = 9600 then
    Result := br9600
  else if ABaudRate = 14400 then
    Result := br14400
  else if ABaudRate = 19200 then
    Result := br19200
  else if ABaudRate = 38400 then
    Result := br38400
  else if ABaudRate = 56000 then
    Result := br56000
  else if ABaudRate = 57600 then
    Result := br57600
  else if ABaudRate = 38400 then
    Result := br38400
  else if ABaudRate = 115200 then
    Result := br115200;
end;

function URLEncode(const psSrc: string): string;
const
 UnsafeChars = ' *#%<>';
var
 i: Integer;
begin
  Result := '';
  for i := 1 to Length(psSrc) do
  begin
    if (IndyPos(psSrc[i], UnsafeChars) > 0) or (psSrc[i] >= #$80) then
    begin
      Result := Result + '%' + IntToHex(Ord(psSrc[i]), 2);
    end
    else
    begin
      Result := Result + psSrc[i];
    end;
  end;
end;

procedure Split(Input: string; const Delimiter: Char; var Strings: TStringList);
begin
  Assert(Assigned(Strings));
  Strings.Clear;
  ExtractStrings([Delimiter], [' '], PChar(Input), Strings);
end;

function DateTimeSetString(ADatetime: string): string;
begin
  Result := EmptyStr;

  if Length(ADatetime) = 8 then
  begin

    Result := Copy(ADatetime, 1, 4) + '-'
            + Copy(ADatetime, 5, 2) + '-'
            + Copy(ADatetime, 7, 2);
  end;
end;

function LogReplace(AStr: string): string;
begin
  try
    try
      Result := EmptyStr;

      Result := StringReplace(AStr, '%', '(ÆÛ¼¾Æ®)', [rfReplaceAll]);
    except
      on E: Exception do
      begin
      end;
    end;
  finally

  end;
end;

function WriteMediaCountInIFile(AKey: Variant): Boolean;
var
  ACnt: Integer;
  AFile: TIniFile;
begin
  Result := False;
  AFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  try
    try
      with AFile do
      begin
        ACnt := ReadInteger('MediaCount', Akey, 0);
        Inc(ACnt);
        WriteInteger('MediaCount', Akey, 0);
      end;
    except
      on E: Exception do
      begin
      end;
    end;
  finally
    AFile.Free;
  end;
end;

function GetFileVersion: string;
var
  dwBufferSize : DWORD;
  dwReserved   : DWORD;
  pBuffer      : pChar;
  lpFixedInfo  : PVSFixedFileInfo;
  nLen         : UINT;
begin
  Result  := '';

//  if not FileExists(Filename) then Exit;
  dwBufferSize := GetFileVersionInfoSize(PChar(Application.ExeName), dwReserved);

  if dwBufferSize > 0 then begin
    GetMem(pBuffer, dwBufferSize);
    try
      if Assigned(pBuffer) then begin
        if not GetFileVersionInfo(PChar(Application.ExeName), dwReserved, dwBufferSize, pBuffer) then Exit;
        if not VerQueryValue(pBuffer, '\', pointer(lpFixedInfo), nLen) then Exit;
        Result  := IntToStr(Word(lpFixedInfo.dwFileVersionMS shr 16));
        Result  := Result + '.'+ IntToStr(Word(lpFixedInfo.dwFileVersionMS and $FFFF));
        Result  := Result + '.'+ IntToStr(Word(lpFixedInfo.dwFileVersionLS shr 16));
        Result  := Result + '.'+ IntToStr(Word(lpFixedInfo.dwFileVersionLS and $FFFF));
      end;
    finally
      FreeMem(pBuffer);
    end;
  end;
end;

procedure WriteLog(AError: Boolean; AFolder, ASaleDate, AName, AValue: string);
var
  AFile: TIniFile;
begin
  AFile := TIniFile.Create(Format('%s\%s\%s', [ExtractFilePath(ParamStr(0))  + '\logs\', AFolder, ASaleDate + '.ini']));
  try
    try
      with AFile do
      begin
        WriteString('Log', FormatDateTime('yyyy-mm-dd hh:nn:ss.zz', now), 'BEGIN');
        if AError then
          WriteString('Log', FormatDateTime('yyyy-mm-dd hh:nn:ss.zz', now), '-------------------------------E R R O R------------------------------');

        WriteString('Log', FormatDateTime('yyyy-mm-dd hh:nn:ss.zz', now), AName);

        WriteString('Log', FormatDateTime('yyyy-mm-dd hh:nn:ss.zz', now), AValue);

        WriteString('Log', FormatDateTime('yyyy-mm-dd hh:nn:ss.zz', now), 'END');
      end;
    except
      on E: Exception do;
    end;
  finally
    AFile.Free;
  end;
end;

//function TListClear(AList: TList<TObject>): Boolean;
//var
//  Loop: Integer;
//begin
//  try
//    for Loop := AList.Count - 1 downto 0 do
//      AList.Delete(Loop);
//  finally
//
//  end;
//
//end;

function GetWeekDay(ADateTime: TDateTime): string;
begin
//  Result := WeekDay[Trunc(DayOfWeek(Now))];
end;

procedure SetServerLocalTime(ATime: string);
var
  dSvrTime: TDateTime;
begin
//...
//sValue := Trim(JO.GetValue('server_time').Value);
  if (Length(ATime) = 14) then
  begin
    dSvrTime := StrToDateTime(Format('%s-%s-%s %s:%s:%s',
                [
                  Copy(ATime, 1, 4),
                  Copy(ATime, 5, 2),
                  Copy(ATime, 7, 2),
                  Copy(ATime, 9, 2),
                  Copy(ATime, 11, 2),
                  Copy(ATime, 13, 2)
                ]));
    SetSystemTime(dSvrTime);
  end;
end;

function SetSystemTime(const ADateTime: TDateTime): Boolean;
var
  dSysTime: TSystemTime;
begin
  Result := False;
  try
    DateTimeToSystemTime(ADateTime, dSysTime);
    SetLocalTime(dSysTime);
    Result := True;
  except
  end;
end;

end.
