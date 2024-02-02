program XGRFCardAssist;

uses
  FMX.Forms,
  Form.Main in 'Form.Main.pas' {Main},
  Form.Config in 'Form.Config.pas' {FormConfig},
  Form.SearchEmployee in 'Form.SearchEmployee.pas' {SearchEmployee},
  Frame.Search.List in 'Frame\Frame.Search.List.pas' {FrameSearchList: TFrame},
  Frame.Search.Item.Style in 'Frame\Frame.Search.Item.Style.pas' {SearchItemStyle: TFrame},
  uFunction in 'uFunction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
