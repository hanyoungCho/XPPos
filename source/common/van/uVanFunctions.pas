(*******************************************************************************
  �� ��⿡�� ����ϴ� ���� �Լ� ���� ���̺귯��
*******************************************************************************)

unit uVanFunctions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils, ComObj, Math, TlHelp32;

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
  // ������ ����ŭ ���� ���ڿ��� �����ϴ�.
  function Space(ACnt: Integer): AnsiString;
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
  // ���࿩�� üũ
  function processExists(exeFileName: string): Boolean;

type
  // �α� ���� ���� (������, ����, ����׿�, ����, ��)
  TLogType = (ltInfo, ltError, ltDebug, ltBegin, ltEnd);
  // �α� ó��
  TLog = class
  private
    class procedure WriteLogFile(AMessage: AnsiString);
  public
    DebugLog: Boolean;
    constructor Create; virtual;
    destructor Destroy; override;
    class procedure Write(AMessage: AnsiString); overload;
    procedure Write(ALogType: TLogType; AMessage: array of Variant); overload;
    procedure Write(ALogType: TLogType; AMessage: AnsiString); overload;
  end;

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

function Space(ACnt: Integer): AnsiString;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to ACnt do
    Result := Result + ' ';
end;

function RegisterOcx(AClassID: string; AOcxPath: string; ARegister: Boolean): Boolean;
type
  TDllProc = function:
  HResult; stdcall;
var
  hModule: THandle;
  DllProc: TDllProc;
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

{ TLog }

constructor TLog.Create;
begin
  DebugLog := False;
end;

destructor TLog.Destroy;
begin
  inherited;
end;

class procedure TLog.WriteLogFile(AMessage: AnsiString);
const
  LOG_DIRECTORY = 'VanLog';
var
  LogFile: TextFile;
  AFileName: string;
begin
  if not DirectoryExists(LOG_DIRECTORY) then
    CreateDir(LOG_DIRECTORY);
  try
    AFileName := LOG_DIRECTORY + '\' + FormatDateTime('yyyymmdd', Date) + '.log';
    {$i-}
    AssignFile(LogFile, AFileName);
    if FileExists(AFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);
    Writeln(LogFile, AMessage);
  finally
    CloseFile(LogFile);
    {$i+}
  end;
end;

class procedure TLog.Write(AMessage: AnsiString);
var
  LogText: AnsiString;
begin
  LogText := '[' + FormatDateTime('hh:nn:ss.zzz', Time) + ']';
  LogText := LogText + '[  ]' + '[' + AMessage + ']';
  WriteLogFile(LogText);
end;

procedure TLog.Write(ALogType: TLogType; AMessage: array of Variant);
var
  ATitle, AText, Temp: AnsiString;
  Index: Integer;
begin
  // ����� �α� ���� üũ
  if (ALogType = ltDebug) and not DebugLog then Exit;

  case ALogType of
    ltInfo  : ATitle := '[  ]';
    ltError : ATitle := '[ER]';
    ltDebug : ATitle := '[**]';
    ltBegin : ATitle := '[->]';
    ltEnd   : ATitle := '[<-]';
  end;
  for Index := Low(AMessage) to High(AMessage) do
  begin
    if ALogType = ltDebug then
      Temp := VarToStr(AMessage[Index])
    else
      Temp := Trim(VarToStr(AMessage[Index]));
    if (Index mod 2) = 0 then
      AText := AText + Temp + '='
    else
      AText := AText + '<' + Temp + '> ';
  end;
  ATitle := '[' + FormatDateTime('hh:nn:ss.zzz', Time) + ']' + ATitle;
  WriteLogFile(ATitle + '[' + AText + ']');
end;

procedure TLog.Write(ALogType: TLogType; AMessage: AnsiString);
begin
  Write(ALogType, [AMessage]);
end;

function processExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

end.
