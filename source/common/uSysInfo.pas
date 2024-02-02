unit uSysInfo;

interface

uses
  Classes, Windows, SysUtils, Forms, ShlObj, Tlhelp32;

// 시스템에 정의된 폴더경로를 가져온다. SSIDL_Value는 ShlObj에 정의되어 있음.
function GetSpecialFolder(CSIDL_VALUE: Integer): string;
function GetSystemPath: String;
function GetProgramPath: String;
function GetWindowsPath: String;
// OS가 설치된 메인 드라이브를 가져온다. c:\에 Windows가 설치 되었다면 c:\ 반환.
function GetOsRootPath: String;

function GetAppFilePath: String;
// 실행파일과 동일한 IniFile Name을 반환한다.gomsun2.exe라면 gomsun2.ini 반환
function GetIniFileName: string;
// 실행파일과 동일한 IniFile의 존재 여부를 반환한다.
function ExistsIniFile: Boolean;
// 실행파일과 동일한 IniFile을 생성한다.
procedure CreateIniFile;

// Folder Dialog를 실행한다.
//Todo: SelectDirectory를 연구하자
function BrowseForFolder(
  const initialFolder: String = '';
  const browseTitle: String = '';
  mayCreateNewFolder: Boolean = True): String;

// 프로세스가 실행중인지를 반환한다.
function ProcessRun(ProcessName: String): Boolean;
// ProcessName의 프로세스를 찾아 종료한다.
function ProcessTerminate(ProcessName: string; AllKill: Boolean = TRUE): Boolean;

implementation

var
  lg_StartFolder: String;

// 시스템에 정의된 폴더경로를 가져온다. SSIDL_Value는 ShlObj에 정의되어 있음.
function GetSpecialFolder(CSIDL_Value: Integer): string;
var
  PIDL : PItemIDList;
begin
  SetLength(Result, MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, CSIDL_Value, PIDL);
  SHGetPathFromIDList(PIDL, PChar(Result));
  SetLength (Result, StrLen (PChar(Result)));
  if Copy(Result, Length(Result), 1) <> '\' then Result := Result + '\';
end;

function GetSystemPath: String;
begin
  Result := GetSpecialFolder(CSIDL_SYSTEM);
end;

function GetProgramPath: String;
begin
  Result := GetSpecialFolder(CSIDL_PROGRAMS);
end;

function GetWindowsPath: String;
begin
  Result := GetSpecialFolder(CSIDL_WINDOWS);
end;

function GetOsRootPath: String;
begin
  Result := GetSpecialFolder(CSIDL_WINDOWS);
  Result := Copy(Result, 1, 3);
end;

function GetAppFilePath: String;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function GetIniFileName: string;
begin
  Result := ParamStr(0);
  Result := ExtractFilePath(Result) + ExtractFileName(Result);
  Result := StringReplace(Result, ExtractFileExt(Result), '.ini', [rfReplaceAll, rfIgnoreCase]);
end;

function ExistsIniFile: Boolean;
begin
  Result := FileExists(GetIniFileName);
end;

procedure CreateIniFile;
var
  FileName: String;
begin
  FileName := GetIniFileName;
  with TFileStream.Create(FileName, fmCreate) do Free;
end;

function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam,
lpData: LPARAM): Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd,BFFM_SETSELECTION, 1, Integer(@lg_StartFolder[1]));
  result := 0;
end;

// 원본 - http://www.cryer.co.uk/brian/delphi/howto_browseforfolder.htm
////////////////////////////////////////////////////////////////////////
// This function allows the user to browse for a folder
//
// Arguments:-
//         browseTitle : The title to display on the browse dialog.
//       initialFolder : Optional argument. Use to specify the folder
//                       initially selected when the dialog opens.
//  mayCreateNewFolder : Flag indicating whether the user can create a
//                       new folder.
//
// Returns: The empty string if no folder was selected (i.e. if the user
//          clicked cancel), otherwise the full folder path.
////////////////////////////////////////////////////////////////////////
function BrowseForFolder(
  const initialFolder: String ='';
  const browseTitle: String = '';
  mayCreateNewFolder: Boolean = True): String;
var
  browse_info: TBrowseInfo;
  Folder: array[0..MAX_PATH] of char;
  find_context: PItemIDList;
begin
  //--------------------------
  // Initialise the structure.
  //--------------------------
  FillChar(browse_info,SizeOf(browse_info),#0);
  lg_StartFolder := initialFolder;
  browse_info.pszDisplayName := @Folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  if not mayCreateNewFolder then
    browse_info.ulFlags := browse_info.ulFlags or BIF_NONEWFOLDERBUTTON;

  browse_info.hwndOwner := Application.Handle;
  if initialFolder <> '' then
    browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context,Folder) then
    begin
      result := Folder;
      if Copy(result, Length(result), 1) <> '\' then
      result := result + '\';
    end
    else
      result := '';
    GlobalFreePtr(find_context);
  end
  else
    result := '';
end;

function ProcessRun(ProcessName: String): Boolean;
var
  ProcessEntry: TProcessEntry32;
  AHandle: THandle;
begin
  Result := FALSE;
  ProcessEntry.dwSize := SizeOf(TProcessEntry32);
  AHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    if Process32First(AHandle, ProcessEntry) then
    repeat
     if CompareText(ProcessEntry.szExeFile, ProcessName) = 0 then
      Result := TRUE;
      Break;
     until not Process32Next(AHandle, ProcessEntry);
  finally
    CloseHandle(AHandle);
  end;
end;

function ProcessTerminate(ProcessName: string; AllKill: Boolean = TRUE): Boolean;
var
  ProcessEntry : TProcessEntry32;
  HandleList, HandleProcess : THandle;
begin
  Result := FALSE;
  ProcessEntry.dwSize := SizeOf(TProcessEntry32);
  HandleList := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    if Process32First(HandleList, ProcessEntry) then
      repeat
        if CompareText(ProcessEntry.szExeFile, ProcessName) <> 0 then Continue;
        HandleProcess := OpenProcess(PROCESS_ALL_ACCESS, TRUE, ProcessEntry.th32ProcessID);
        TerminateProcess(HandleProcess, 0);
        Result := TRUE;
        if not AllKill then Break;
      until not Process32Next(HandleList, ProcessEntry);
  finally
    CloseHandle(HandleList);
  end;
end;

end.
