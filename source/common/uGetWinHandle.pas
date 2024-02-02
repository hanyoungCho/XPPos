unit uGetWinHandle;

interface

uses
  Windows, SysUtils, PsAPI, Tlhelp32, Dialogs;

var
  szFileName: array[0..MAX_PATH] of char;
  fSearchFileName: string;

function GetProcessIdByName(const AProcName: string): DWORD;
function EnumWindowProc(AHandle: Cardinal; var lParam: integer): boolean; stdcall;
function HandleFromProcessID(AFileName: string): HWND;

implementation

function GetProcessIdByName(const AProcName: string): DWORD;
var
  P: TProcessEntry32;
  H: THandle;
  Next: BOOL;
begin
  Result := 0;
  P.dwSize := SizeOf(TProcessEntry32);
  H := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    if Process32First(H, P) then
    begin
      repeat
        Next := Process32Next(H, P);
        if AnsiCompareText(P.szExeFile, Trim(AProcName))=0 then
        begin
          Result:=P.th32ProcessID;
          Break;
        end;
      until not Next;
    end;
  finally
    CloseHandle(H);
  end;
end;

function EnumWindowProc(AHandle: Cardinal; var lParam: integer): boolean; stdcall;
var
  ProcId: Cardinal;
  Process32: TProcessEntry32;
  hSnapshot, hProcess: THandle;
begin
  Result := True;
  GetWindowThreadProcessID(AHandle, @ProcId);

  if (AHandle > 0) and
     IsWindowVisible(AHandle) then
  begin
    Process32.dwSize := SizeOf(TProcessEntry32);
    hSnapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    if Process32First(hSnapshot, Process32) then begin
      hProcess := OpenProcess( PROCESS_ALL_ACCESS, False, ProcId);

      GetModuleBaseName(hProcess, 0, @szFileName, MAX_PATH);
      if (StrPas(szFileName) = fSearchFileName) then
      begin
        lParam := AHandle;
        Result := False;
      end;
    end;
  end;
end;

function HandleFromProcessID(AFileName: string): HWND;
var
  lparam: integer;
begin
  fSearchFileName := AFileName;
  EnumWindows(@EnumWindowProc, Cardinal(@lparam));
  Result := lparam;
end;

(*
function IsExeHandle(const aAppName: string; aParent: Cardinal = 0): Cardinal;
var Process32: TProcessEntry32;
    aHandle: THandle;
    Next: Boolean;
    ProcId: DWORD;
    aExeName: string;
    function GetHwndFromProcessID(dwProcessID: DWORD): THandle;
    var hWnd: THandle;
        dwProcessID2: DWORD;
    begin
      Result := 0;
      hWnd := FindWindow(nil, nil);           // 최상위 윈도우 핸들 찾기
      while( hWnd <> 0 ) do begin
        if( aParent = GetParent(hWnd)) then begin   // 최상위 핸들인지 체크
          GetWindowThreadProcessId( hWnd, @dwProcessID2 );
          if( dwProcessID2 = dwProcessID ) then begin
            Result := hWnd;
            Exit;
          end;
        end;
        hWnd := GetWindow(hWnd, GW_HWNDNEXT); // 다음 윈도우 핸들 찾기
      end;
    end;
begin
  Result := 0;
  aExeName := ExtractFileName(aAppName);
  Process32.dwSize := SizeOf(TProcessEntry32);
  aHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(aHandle, Process32) then begin
    repeat
      Next := Process32Next(aHandle, Process32);
      if Next then begin
        GetWindowThreadProcessID(aHandle, @ProcId );
        if UpperCase(Process32.szExeFile) = UpperCase(aExeName) then begin
          Result := GetHwndFromProcessID(Process32.th32ProcessID);
          Exit;
        end;
      end;
    until not Next;
  end;
  CloseHandle(aHandle);
end;
*)

end.
