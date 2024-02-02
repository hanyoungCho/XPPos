unit Form.Config;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, InIFiles;

type
  TFormConfig = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Rectangle1: TRectangle;
    edtUrl: TEdit;
    edtID: TEdit;
    edtKey: TEdit;
    edtPort: TEdit;
    edtBaudRate: TEdit;
    Image1: TImage;
    Layout: TLayout;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Text1: TText;
    cbUseSTX: TCheckBox;
    procedure Image1Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

uses
  Form.Main, uFunction;

{$R *.fmx}

procedure TFormConfig.FormShow(Sender: TObject);
begin
  edtUrl.Text := Main.Url;
  edtID.Text := Main.ID;
  edtKey.Text := Main.Key;
  edtPort.Text := Main.Port;
  edtBaudRate.Text := Main.BaudRate;
  cbUseSTX.IsChecked := Main.UseSTX;
end;

procedure TFormConfig.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormConfig.Rectangle3Click(Sender: TObject);
var
  AFile: TIniFile;
begin
  try
    AFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config\XGRFCardAssist.config');
    with AFile do
    begin
      WriteString('Config', 'Key', edtKey.Text);
      WriteString('Config', 'Url', edtURL.Text);
      WriteString('Config', 'ID', edtID.Text);
      WriteString('ComPort', 'Port', edtPort.Text);
      WriteString('ComPort', 'Baudrate', edtBaudRate.Text);
      WriteBool('ComPort', 'STXUSE', cbUseSTX.IsChecked);
    end;
  finally

  end;
  Close;
end;

end.
