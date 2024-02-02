program ELMobileAD;

uses
  Forms,
  Windows,
{$IFDEF RELEASE}
  System.SysUtils,
  Vcl.Dialogs,
{$ENDIF }
  Vcl.Themes,
  Vcl.Styles,
  uELMADMain in 'uELMADMain.pas' {MainForm},
  uELMADDM in 'uELMADDM.pas' {DM: TDataModule};

{$R *.res}

const
  CO_MUTEX_NAME = 'Global\ELOOM MobileAD';

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
  hMutex := CreateMutex(nil, False, CO_MUTEX_NAME);
  if (hMutex <> 0) and
     (ERROR_ALREADY_EXISTS = GetLastError) then
    Exit;

  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Carbon');
    Application.Title := 'MobileAD for ELOOMGOLF';
  Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TDM, DM);
    Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
end.
