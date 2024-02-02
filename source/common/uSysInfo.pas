unit uSysInfo;

interface

uses
  Classes, Windows, SysUtils, Forms, ShlObj, Tlhelp32;

// �ý��ۿ� ���ǵ� ������θ� �����´�. SSIDL_Value�� ShlObj�� ���ǵǾ� ����.
function GetSpecialFolder(CSIDL_VALUE: Integer): string;
function GetSystemPath: String;
function GetProgramPath: String;
function GetWindowsPath: String;
// OS�� ��ġ�� ���� ����̺긦 �����´�. c:\�� Windows�� ��ġ �Ǿ��ٸ� c:\ ��ȯ.
function GetOsRootPath: String;

function GetAppFilePath: String;
// �������ϰ� ������ IniFile Name�� ��ȯ�Ѵ�.gomsun2.exe��� gomsun2.ini ��ȯ
function GetIniFileName: string;
// �������ϰ� ������ IniFile�� ���� ���θ� ��ȯ�Ѵ�.
function ExistsIniFile: Boolean;
// �������ϰ� ������ IniFile�� �����Ѵ�.
procedure CreateIniFile;

// Folder Dialog�� �����Ѵ�.
//Todo: SelectDirectory�� ��������
function BrowseForFolder(
  const initialFolder: String = '';
  const browseTitle: String = '';
  mayCreateNewFolder: Boolean = True): String;

// ���μ����� ������������ ��ȯ�Ѵ�.
function ProcessRun(ProcessName: String): Boolean;
// ProcessName�� ���μ����� ã�� �����Ѵ�.
function ProcessTerminate(ProcessName: string; AllKill: Boolean = TRUE): Boolean;

implementation

var
  lg_StartFolder: String;

// �ý��ۿ� ���ǵ� ������θ� �����´�. SSIDL_Value�� ShlObj�� ���ǵǾ� ����.
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

// ���� - http://www.cryer.co.uk/brian/delphi/howto_browseforfolder.htm
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
