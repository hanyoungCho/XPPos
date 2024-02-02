unit uPaycoRevForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, IniFiles, StrUtils, Math, Vcl.ExtCtrls,
  Vcl.OleCtrls, Vcl.Buttons;//, FMX.Forms;

type
  TPaycoRevForm = class(TForm)
    pnSingTitle: TPanel;
    lbMessage: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RevState : Integer;              // ���俩�� ( 0: ������ / 1 : �����Ϸ� / 2: ����Ϸ� )
    RevMsg   : AnsiString;           // ����޼���
    procedure WMCopyData(var Message:TMessage); message WM_CopyData;
  end;

var
  PaycoRevForm: TPaycoRevForm;

implementation

{$R *.dfm}

{ TPaycoRevForm }

procedure TPaycoRevForm.WMCopyData(var Message: TMessage);
var
  stText : String;
  Data :^COPYDATASTRUCT;
begin
  try
    Data:= Ptr(Message.lParam);
    RevMsg:= StrPas(PAnsiChar(Data^.lpData));
    if Data^.dwData = 1000 then               // �����Ϸ� �����ϰ��
     RevState := 1
    else if Data^.dwData = 1003 then          // �����û�� ���
      RevState := 2;
  except
  end;
end;

procedure TPaycoRevForm.FormShow(Sender: TObject);
begin
  RevMsg    := EmptyStr;
  RevState  := 0;
  Self.Width := 1;
  Self.Height := 1;
end;

procedure TPaycoRevForm.btnCancelClick(Sender: TObject);
begin
  RevState := 9;                               // �ӽ� �����ΰ�� 
end;

end.
