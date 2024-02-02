unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, Generics.Collections, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, JSON, EncdDecd, IdURI, InIFiles,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

const
  OAuthURl = '/oauth/token';

type
  TEmployee = record
    UserID: string;
    Seq: string;
    No: string;
    Name: string;
    Sex: string;
    birth: string;
    hp_no: string;
    email: string;
    car_no: string;
    zip_no: string;
    address: string;
    address_desc: string;
    customer_cd: string;
    group_cd: string;
    welfare_cd: string;
    EmpType: string;
    Discount: string;
    qr_cd: string;
    Point: string;
//    CardNo: string;
    photo_encoding: string;
    fingerprint_hash: string;
    xg_user_key: string;
    memo: string;
    del_yn: string;
  end;

  TMain = class(TForm)
    Layout: TLayout;
    Rectangle: TRectangle;
    AddEmp: TRoundRect;
    Config: TRoundRect;
    btnClose: TRoundRect;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Indy: TIdHTTP;
    IndySSL: TIdSSLIOHandlerSocketOpenSSL;
    LoginLayout: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    edtID: TEdit;
    edtPW: TEdit;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Text4: TText;
    Text5: TText;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ConfigClick(Sender: TObject);
    procedure AddEmpClick(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure edtIDKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtPWKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    FKey: string;
    FUrl: string;
    FID: string;
    FPort: string;
    FBaudRate: string;
    FToken: string;
    FEmpList: TList<TEmployee>;
    FAdminID: string;
    FUseSTX: Boolean;

    function OAuth_Certification: Boolean;
    function ByteStringToString(AData: TStringStream): AnsiString;
    function GetEmpList: Boolean;
  public
    { Public declarations }
    function UpdateEmp(AEmp: TEmployee): Boolean;

    property EmpList: TList<TEmployee> read FEmpList write FEmpList;

    property Key: string read FKey write FKey;
    property Url: string read FUrl write FUrl;
    property ID: string read FID write FID;
    property Port: string read FPort write FPort;
    property BaudRate: string read FBaudRate write FBaudRate;
    property Token: string read FToken write FToken;
    property AdminID: string read FAdminID write FAdminID;
    property UseSTX: Boolean read FUseSTX write FUseSTX;
  end;

var
  Main: TMain;

implementation

uses
  uFunction, Form.Config, Form.SearchEmployee, System.NetEncoding;

{$R *.fmx}

procedure TMain.AddEmpClick(Sender: TObject);
begin
  try
    GetEmpList;

    SearchEmployee := TSearchEmployee.Create(nil);

    if SearchEmployee.ShowModal = mrOk then
    begin

    end;
  finally
    SearchEmployee.Free;
  end;
end;

procedure TMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  EmpList := TList<TEmployee>.Create;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  EmpList.Free;
end;

procedure TMain.FormShow(Sender: TObject);
var
  AFile: TIniFile;
begin
  AFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config\XGRFCardAssist.config');
  try
    try
      with AFile do
      begin
        Key := ReadString('Config', 'Key', '1');
        Url := ReadString('Config', 'Url', '');
        ID := ReadString('Config', 'ID', '');
        Port := ReadString('ComPort', 'Port', '');
        BaudRate := ReadString('ComPort', 'BAUDRATE', '');
        UseSTX := ReadBool('ComPort', 'STXUSE', False);
      end;
      AdminID := EmptyStr;
    except
      on E: Exception do;
    end;

    if not OAuth_Certification then
    begin  // 실패
      Exit;
    end;

    LoginLayout.Visible := True;
    Layout.Visible := False;
    edtID.SetFocus;
  finally
    AFile.Free;
  end;
end;

function TMain.GetEmpList: Boolean;
var
  Index: Integer;
  MainJson: TJSONObject;
  SendData: TStringStream;
  RecvData: TStringStream;
  JsonText: AnsiString;
  JsonValue, ItemValue: TJSONValue;
  AEmp: TEmployee;
begin
  Result := False;
  MainJson := TJSONObject.Create;
  SendData := TStringStream.Create;
  RecvData := TStringStream.Create;

  try
    SendData.Clear;
    RecvData.Clear;
    Indy.Request.Clear;
    Indy.URL.URI := URL;
    Indy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Main.Token;
    Indy.Get(URL + '/wix/api/K301_Member?store_cd=' + Copy(ID, 1, 5) + '&emp_yn=Y', RecvData);
    JsonText := ByteStringToString(RecvData);
    JsonValue := MainJson.ParseJSONValue(JsonText);

    if JsonValue.FindValue('result_data') is TJSONNull then
      Exit;

    for Index := EmpList.Count - 1 downto 0 do
      EmpList.Delete(Index);

    JsonValue := GetJsonValue(JsonValue, 'result_data');
    for Index := 0 to (JsonValue as TJSONArray).Count - 1 do
    begin
      ItemValue := (JsonValue as TJSONArray).Items[Index];
      AEmp.UserID           := GetStringValue(ItemValue, 'member_no');
//      AEmp.Seq              := GetStringValue(ItemValue, 'member_nm');
      AEmp.No               := GetStringValue(ItemValue, 'member_no');
      AEmp.Name             := GetStringValue(ItemValue, 'member_nm');
      AEmp.Sex              := GetStringValue(ItemValue, 'sex_div');
      AEmp.birth            := GetStringValue(ItemValue, 'birth_ymd');
      AEmp.hp_no            := GetStringValue(ItemValue, 'hp_no');
      AEmp.email            := GetStringValue(ItemValue, 'email');
      AEmp.car_no           := GetStringValue(ItemValue, 'car_no');
      AEmp.zip_no           := GetStringValue(ItemValue, 'zip_no');
      AEmp.address          := GetStringValue(ItemValue, 'address');
      AEmp.address_desc     := GetStringValue(ItemValue, 'address_desc');
      AEmp.customer_cd      := GetStringValue(ItemValue, 'customer_cd');
      AEmp.group_cd         := GetStringValue(ItemValue, 'group_cd');
      AEmp.welfare_cd       := GetStringValue(ItemValue, 'welfare_cd');
//      AEmp.EmpType          := GetStringValue(ItemValue, 'member_nm');
      AEmp.Discount         := GetStringValue(ItemValue, 'dc_rate');
      AEmp.qr_cd            := GetStringValue(ItemValue, 'qr_cd');
      AEmp.Point            := GetStringValue(ItemValue, 'member_point');
      AEmp.photo_encoding   := GetStringValue(ItemValue, 'photo_encoding');
      AEmp.fingerprint_hash := GetStringValue(ItemValue, 'fingerprint_hash');
      AEmp.xg_user_key      := GetStringValue(ItemValue, 'xg_user_key');
      AEmp.memo             := GetStringValue(ItemValue, 'memo');
      AEmp.del_yn           := GetStringValue(ItemValue, 'del_yn');

      EmpList.Add(AEmp);
    end;
  finally
    MainJson.Free;
  end;
end;

function TMain.OAuth_Certification: Boolean;
var
  SendData: TStringStream;
  RecvData: TStringStream;
  MainJson: TJSONObject;
  BodyJson: TJSONValue;
  ResultStr: string;
  UTF8Str: UTF8String;
  Authorization: AnsiString;
begin
  MainJson := TJSONObject.Create;
  SendData := TStringStream.Create;
  RecvData := TStringStream.Create;
  try
    SendData.Clear;
    RecvData.Clear;
    UTF8Str := UTF8String(ID + ':' + Key);
    Authorization := EncdDecd.EncodeBase64(PAnsiChar(UTF8Str), Length(UTF8Str));

    Indy.Request.CustomHeaders.Clear;
    Indy.Request.ContentType := 'application/x-www-form-urlencoded';
    Indy.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + Authorization;

    SendData.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
    Indy.Post(Url + OAuthURl, SendData, RecvData);
    BodyJson := MainJson.ParseJSONValue(ByteStringToString(RecvData));
    ResultStr := GetStringValue(BodyJson, 'access_token');
    Token := ResultStr;
    Result := True;
  finally
    MainJson.Free;
  end;
end;

procedure TMain.Rectangle1Click(Sender: TObject);
begin
  Close;
end;

procedure TMain.Rectangle2Click(Sender: TObject);
var
  MainJson: TJSONObject;
  SendData: TStringStream;
  RecvData: TStringStream;
  JsonText: AnsiString;
  JsonValue: TJSONValue;
begin
  MainJson := TJSONObject.Create;
  SendData := TStringStream.Create;
  RecvData := TStringStream.Create;

  try
    SendData.Clear;
    RecvData.Clear;
    Indy.Request.Clear;
    Indy.URL.URI := URL;
    Indy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Main.Token;

    Indy.Get(URL + '/wix/api/K103_CheckLogin?account_id=' + edtID.Text +
                                            '&store_cd=' + Copy(ID, 1, 5) +
                                            '&terminal_pwd=' + edtPW.Text, RecvData);

    JsonText := ByteStringToString(RecvData);

    JsonValue := MainJson.ParseJSONValue(JsonText);

    if '0000' = GetStringValue(JsonValue, 'result_cd') then
    begin
      AdminID := edtID.Text;
      GetEmpList;
      Layout.Visible := True;
      LoginLayout.Visible := False;
    end
    else
      ShowMessage('아이디 또는 패스워드를 확인해주세요.')
  finally
    MainJson.Free;
  end;
end;

function TMain.UpdateEmp(AEmp: TEmployee): Boolean;
var
  MainJson: TJSONObject;
  SendData: TStringStream;
  RecvData: TStringStream;
  JsonText: AnsiString;
  JsonValue: TJSONValue;
begin
  Result := False;
  MainJson := TJSONObject.Create;
  SendData := TStringStream.Create;
  RecvData := TStringStream.Create;

  try
    SendData.Clear;
    RecvData.Clear;
    Indy.Request.Clear;
    Indy.URL.URI := URL;
    Indy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Main.Token;
    Indy.Request.ContentType := 'application/json';
    Indy.Request.Accept := '*/*';

    MainJson.AddPair(TJSONPair.Create('store_cd', Copy(ID, 1, 5)));
    MainJson.AddPair(TJSONPair.Create('member_no', AEmp.UserID));
    MainJson.AddPair(TJSONPair.Create('welfare_cd', AEmp.welfare_cd));

    SendData := TStringStream.Create(MainJson.ToString, TEncoding.UTF8);
    Indy.Put(URL + '/wix/api/K304_EditMember', SendData, RecvData);
    JsonText := ByteStringToString(RecvData);

    JsonValue := MainJson.ParseJSONValue(JsonText);

    if '0000' = GetStringValue(JsonValue, 'result_cd') then
      Result := True
    else
      ShowMessage(GetStringValue(JsonValue, 'result_msg'));
  finally
    MainJson.Free;
  end;
end;

function TMain.ByteStringToString(AData: TStringStream): AnsiString;
var
  RecvResultStr: AnsiString;
begin
  try
    RecvResultStr := TEncoding.UTF8.GetString(AData.Bytes, 0, AData.Size);
    Result := RecvResultStr;
  except
    on E: Exception do
    begin

    end;
  end;
end;

procedure TMain.ConfigClick(Sender: TObject);
begin
  try
    FormConfig := TFormConfig.Create(nil);

    FormConfig.ShowModal;
  finally
    FormConfig.Free;
  end;
end;

procedure TMain.edtIDKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = vkReturn then
    edtPW.SetFocus;
end;

procedure TMain.edtPWKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = vkReturn then
    Rectangle2Click(nil);
end;

end.

