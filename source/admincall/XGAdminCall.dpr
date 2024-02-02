program XGAdminCall;

uses
  Vcl.Forms,
  uAdminCallMain in 'uAdminCallMain.pas' {XGAdminCallForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.Title := 'AdminCaller for XPartners';
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TXGAdminCallForm, XGAdminCallForm);
  Application.Run;
end.
