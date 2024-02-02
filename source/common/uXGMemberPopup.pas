unit uXGMemberPopup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms, Controls, StdCtrls, ExtCtrls, Menus, DB,
  Vcl.Imaging.pngimage,
  { DevExpress }
  cxClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxGrid,
  cxStyles, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, dxDateRanges, cxLabel,
  cxGridTableView, dxScrollbarAnnotations, cxButtons, cxGridLevel, cxGridCustomTableView,
  cxGridDBTableView, cxGridCustomView,
  { TMS }
  AdvShapeButton;

type
  TXGMemberPopupForm = class(TForm)
    lblFormTitle: TLabel;
    panBody: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    panGrid: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    V1member_nm: TcxGridDBColumn;
    V1hp_no: TcxGridDBColumn;
    V1car_no: TcxGridDBColumn;
    V1address: TcxGridDBColumn;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    btnClose: TAdvShapeButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure V1DblClick(Sender: TObject);
    procedure V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XGMemberPopupForm: TXGMemberPopupForm;

implementation

uses
  Graphics, dxCore, cxGridCommon,
  uXGClientDM, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGMemberPopup }

procedure TXGMemberPopupForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGMemberPopupForm.FormActivate(Sender: TObject);
begin
  G1.SetFocus;
end;

procedure TXGMemberPopupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGMemberPopupForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGMemberPopupForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGMemberPopupForm.V1CustomDrawColumnHeader(Sender: TcxGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
begin
  AViewInfo.Borders := [];

  if AViewInfo.IsPressed then
  begin
    ACanvas.FillRect(AViewInfo.Bounds, clGreen);
    ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
    ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);

    ACanvas.ExcludeClipRect(AViewInfo.Bounds);
  end
  else
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); //$00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[I]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

procedure TXGMemberPopupForm.V1DblClick(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TXGMemberPopupForm.btnOKClick(Sender: TObject);
begin
  if (V1.DataController.DataSource.DataSet.RecordCount > 0) then
    ModalResult := mrOK;
end;

procedure TXGMemberPopupForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGMemberPopupForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGMemberPopupForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGMemberPopupForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGMemberPopupForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
