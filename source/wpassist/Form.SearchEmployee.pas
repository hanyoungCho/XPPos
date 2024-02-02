unit Form.SearchEmployee;

interface

uses
  Form.Main,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, Frame.Search.List, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Edit, ComPort;

type
  TSearchEmployee = class(TForm)
    Layout: TLayout;
    Rectangle: TRectangle;
    Image1: TImage;
    FrameSearchList1: TFrameSearchList;
    Rectangle3: TRectangle;
    Text1: TText;
    edtEmpName: TEdit;
    Rectangle5: TRectangle;
    Text4: TText;
    PopupRectangle: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtName: TEdit;
    edtType: TEdit;
    edtDiscount: TEdit;
    edtPoint: TEdit;
    edtCardNo: TEdit;
    Rectangle1: TRectangle;
    Text2: TText;
    Rectangle4: TRectangle;
    Text3: TText;
    edtNo: TEdit;
    Label6: TLabel;
    MSGBGRectangle: TRectangle;
    Text5: TText;
    MSGRectangle: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Text6: TText;
    Text7: TText;
    ComPort: TComPort;
    procedure Image1Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure Rectangle4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject);
    procedure edtEmpNameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure Rectangle7Click(Sender: TObject);
    procedure Rectangle6Click(Sender: TObject);
  private
    { Private declarations }
    FSelectEmp: TEmployee;
    FReadStr: string;
  public
    { Public declarations }
    procedure EmpClick(AIndex: Integer; AEmp: TEmployee);
    procedure Display;
  end;

var
  SearchEmployee: TSearchEmployee;

implementation

{$R *.fmx}

{ TSearchEmployee }

procedure TSearchEmployee.ComPortRxChar(Sender: TObject);
var
  TempBuff: string;
begin
  TempBuff := Comport.ReadString;
  FReadStr := FReadStr + TempBuff;

  if Main.UseSTX then
  begin
    if (Copy(FReadStr, 1, 1) = #02) and (Copy(FReadStr, Length(FReadStr), 1) = #03) then
    begin
      FReadStr := StringReplace(FReadStr, #02, '', [rfReplaceAll]);
      FReadStr := StringReplace(FReadStr, #03, '', [rfReplaceAll]);

      if PopupRectangle.Visible then
        edtCardNo.Text := FReadStr
      else
        FrameSearchList1.Display(FReadStr, 1);

      FReadStr := EmptyStr;
    end;
  end
  else
  begin
    if Length(FReadStr) = 10 then
    begin
      if PopupRectangle.Visible then
        edtCardNo.Text := FReadStr
      else
        FrameSearchList1.Display(FReadStr, 1);

      FReadStr := EmptyStr;
    end;
  end;
end;

procedure TSearchEmployee.Display;
begin
  FrameSearchList1.Display('');
end;

procedure TSearchEmployee.edtEmpNameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    Rectangle5Click(nil);
end;

procedure TSearchEmployee.EmpClick(AIndex: Integer; AEmp: TEmployee);
begin
  FSelectEmp := AEmp;
  FrameSearchList1.SelectEmp(AIndex);
end;

procedure TSearchEmployee.FormShow(Sender: TObject);
  function GetBaudRate(AValue: string): TBaudRate;
  begin
    if AValue = '9600' then
      Result := br9600
    else if AValue = '38400' then
      Result := br38400
    else
      Result := br57600;
  end;
begin
  Display;
  FReadStr := EmptyStr;
  ComPort.DeviceName := 'COM' + Main.Port;
  ComPort.BaudRate := GetBaudRate(Main.BaudRate);

  if Main.Port <> EmptyStr then
    ComPort.Open;

  edtEmpName.SetFocus;
end;

procedure TSearchEmployee.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TSearchEmployee.Rectangle1Click(Sender: TObject);
begin
  PopupRectangle.Visible := False;
end;

procedure TSearchEmployee.Rectangle3Click(Sender: TObject);
begin
  PopupRectangle.Visible := True;
  edtNo.Text := FSelectEmp.No;
  edtName.Text := FSelectEmp.Name;
  edtType.Text := FSelectEmp.EmpType;
  edtDiscount.Text := FSelectEmp.Discount;
  edtPoint.Text := FSelectEmp.Point;
  edtCardNo.Text := FSelectEmp.welfare_cd;
end;

procedure TSearchEmployee.Rectangle4Click(Sender: TObject);
begin
  MSGBGRectangle.Visible := True;
  MSGRectangle.Visible := True;
end;

procedure TSearchEmployee.Rectangle5Click(Sender: TObject);
begin
  FrameSearchList1.Display(edtEmpName.Text);
end;

procedure TSearchEmployee.Rectangle6Click(Sender: TObject);
begin
  FSelectEmp.welfare_cd := edtCardNo.Text;
  if Main.UpdateEmp(FSelectEmp) then
    ShowMessage('저장 성공');
  Close;
end;

procedure TSearchEmployee.Rectangle7Click(Sender: TObject);
begin
  MSGBGRectangle.Visible := False;
  MSGRectangle.Visible := False;
end;

end.
