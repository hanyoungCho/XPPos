unit Frame.Search.Item.Style;

interface

uses
  Form.Main,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TSearchItemStyle = class(TFrame)
    Rectangle: TRectangle;
    txtName: TText;
    txtType: TText;
    txtTmp: TText;
    procedure RectangleClick(Sender: TObject);
  private
    FEmp: TEmployee;
    { Private declarations }
  public
    { Public declarations }
    procedure Bind(AEmp: TEmployee);
  end;

implementation

uses
  Form.SearchEmployee;

{$R *.fmx}

{ TSearchItemStyle }

procedure TSearchItemStyle.Bind(AEmp: TEmployee);
begin
  FEmp := AEmp;
  txtName.Text := FEmp.Name;
  txtTmp.Text := FEmp.No;
end;

procedure TSearchItemStyle.RectangleClick(Sender: TObject);
begin
  SearchEmployee.EmpClick(Self.Tag, FEmp);
end;

end.
