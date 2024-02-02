program XGTeeBoxAgent;

uses
  Vcl.Forms,
  Winapi.Windows,
  {$IFDEF RELEASE}
  System.SysUtils,
  Vcl.Dialogs,
  {$ENDIF }
  uXGTeeBoxAgentMain in 'uXGTeeBoxAgentMain.pas' {MainForm},
  uXGTeeBoxAgentScreen in 'uXGTeeBoxAgentScreen.pas' {ScreenForm},
  uXGTeeBoxAgentDM in 'uXGTeeBoxAgentDM.pas' {DM: TDataModule};

{$R *.res}

const
  CO_MUTEX_NAME = 'Global\XPartners TeeBoxAgent';

var
  hMutex: THandle;

begin
{$IFDEF RELEASE}
  if (ParamCount = 0) or (LowerCase(ParamStr(1)) <> '/run') then
  begin
    ShowMessage('��ó ���α׷��� �̿��Ͽ� �����Ͽ� �ֽʽÿ�!');
    Halt(0);
    Exit;
  end;
{$ENDIF}

  //ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  hMutex := CreateMutex(nil, True, CO_MUTEX_NAME);
  try
    if (hMutex <> 0) and
       (ERROR_ALREADY_EXISTS = GetLastError) then
      Exit;

    Application.Initialize;
    Application.Title := 'TeeBoxAgent for XPartners';
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
end.
