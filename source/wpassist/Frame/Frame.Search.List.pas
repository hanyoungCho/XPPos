unit Frame.Search.List;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, Frame.Search.Item.Style, Generics.Collections;

type
  TFrameSearchList = class(TFrame)
    VertScrollBox: TVertScrollBox;
  private
    { Private declarations }
    FItemList: TList<TSearchItemStyle>;
  public
    { Public declarations }
    procedure Display(ACode: string; AGubun: Integer = 0);
    procedure SelectEmp(AIndex: Integer);
  end;

implementation

uses
    Form.Main;

{$R *.fmx}

{ TFrameSearchList }

procedure TFrameSearchList.Display(ACode: string; AGubun: Integer);
var
  Index, Cnt: Integer;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  ASearchItemStyle: TSearchItemStyle;
begin
  try
    X := 0;
    Y := 0;

    Cnt := 0;

    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    if FItemList = nil then
      FItemList := TList<TSearchItemStyle>.Create
    else
    begin
//      for Index := FItemList.Count - 1 downto 0 do
//        FItemList.Delete(Index);
      FItemList.Clear;
    end;

//    for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
//      VertScrollBox.Content.Children[Index].Free;

    VertScrollBox.Content.DeleteChildren;

    for Index := 0 to Main.EmpList.Count - 1 do
    begin
      if AGubun = 0 then
      begin
        if ACode <> EmptyStr then
        begin
          if not (Pos(ACode, Main.EmpList[Index].Name) > 0) then
            Continue;
        end;
      end
      else
      begin
        if Main.EmpList[Index].welfare_cd <> ACode then
          Continue;
      end;

      ASearchItemStyle := TSearchItemStyle.Create(nil);

      APosition.X := 0;
      APosition.Y := ASearchItemStyle.Height * Cnt;

      ASearchItemStyle.Position := APosition;
      ASearchItemStyle.Parent := VertScrollBox;
      ASearchItemStyle.Bind(Main.EmpList[Index]);
      ASearchItemStyle.Tag := Index;

      Inc(Cnt);
      FItemList.Add(ASearchItemStyle);
    end;

  finally

  end;

end;

procedure TFrameSearchList.SelectEmp(AIndex: Integer);
var
  Index: Integer;
begin
  for Index := 0 to FItemList.Count - 1 do
  begin
    if FItemList[Index].Tag = AIndex then
      FItemList[Index].Rectangle.Fill.Color := TAlphaColorRec.Green
    else
      FItemList[Index].Rectangle.Fill.Color := TAlphaColorRec.White;
  end;
end;

end.
