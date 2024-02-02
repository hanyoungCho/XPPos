program XGPOS;
uses
  ShareMem,
  Forms,
  Windows,
  Messages,
  Classes,
  SysUtils,
  Dialogs,
  uXGMainForm in 'uXGMainForm.pas' {XGMainForm},
  uXGSplash in '..\common\uXGSplash.pas' {InitSplash};

{$R *.res}
{$R ..\common\XGCursors.resource}

function EnumFontsProcCallBack(lplf: PLogFont; lpntm: PNewTextMetric; FontType: DWORD; Lines: LParam): Integer; stdcall;
begin
  if System.Pos('Noto Sans CJK KR', lplf^.LFFaceName) > 0 then
    TStringList(Lines).Add(lplf.LFFaceName);
  Result := 1;
end;

function IsFontInstalled: Boolean;
var
  DC: HDC;
  FL: TStringList;
begin
  FL := TStringList.Create;
  DC := GetDC(0);
  try
    EnumFontFamilies(DC, nil, @EnumFontsProcCallBack, LongInt(FL));
    Result := (FL.Count > 0);
  finally
    ReleaseDC(0, DC);
    FreeAndNil(FL);
  end;
end;

procedure InstallFonts;
begin
  if IsFontInstalled then
    Exit;

{$IFDEF RELEASE}
  AddFontResource('fonts\NotoSansCJKkr-Black.otf');
  AddFontResource('fonts\NotoSansCJKkr-Bold.otf');
  AddFontResource('fonts\NotoSansCJKkr-DemiLight.otf');
  AddFontResource('fonts\NotoSansCJKkr-Light.otf');
  AddFontResource('fonts\NotoSansCJKkr-Medium.otf');
  AddFontResource('fonts\NotoSansCJKkr-Regular.otf');
  AddFontResource('fonts\NotoSansCJKkr-Thin.otf');
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
{$ENDIF}
end;

procedure UninstallFonts;
begin
  if not IsFontInstalled then
    Exit;

{$IFDEF RELEASE}
  RemoveFontResource('fonts\NotoSansCJKkr-Black.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-Bold.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-DemiLight.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-Light.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-Medium.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-Regular.otf');
  RemoveFontResource('fonts\NotoSansCJKkr-Thin.otf');
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
{$ENDIF}
end;

const
  CO_MUTEX_NAME = 'Global\XPartners POS System';

var
  hMutex: THandle;

begin
{$IFDEF RELEASE}
  if (ParamCount = 0) or (LowerCase(ParamStr(1)) <> '/run') then
  begin
    ShowMessage('런처 프로그램을 이용하여 실행하여 주십시오!');
    Halt(0);
    Exit;
  end;
{$ENDIF}
  //ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  hMutex := CreateMutex(nil, True, CO_MUTEX_NAME);
  try
    if (hMutex <> 0) and
       (ERROR_ALREADY_EXISTS = GetLastError) then
    begin
      ShowMessage('XTouch POS 프로그램이 이미 실행 중입니다!');
      Exit;
    end;

    Application.Initialize;
    Application.Title := 'POS System for XPartners';
    Application.CreateForm(TXGMainForm, XGMainForm);
  InitSplash := TInitSplash.Create(Application);
    InitSplash.LoadSplash(True, True, 225);
    InitSplash.Show;
    Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
end.
