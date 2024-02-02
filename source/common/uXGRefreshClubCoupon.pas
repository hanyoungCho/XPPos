unit uXGRefreshClubCoupon;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxLabel, cxButtons, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid,
  { TMS }
  AdvShapeButton;

type
  TXGRefreshClubCouponForm = class(TForm)
    panGrid: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    panBody: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblFormTitle: TLabel;
    V1coupon_id: TcxGridDBColumn;
    V1subtitle: TcxGridDBColumn;
    V1valid_period_end: TcxGridDBColumn;
    V1pass_count: TcxGridDBColumn;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XGRefreshClubCouponForm: TXGRefreshClubCouponForm;

implementation

uses
  uXGClientDM, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGRefreshClubCouponForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGRefreshClubCouponForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGRefreshClubCouponForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGRefreshClubCouponForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGRefreshClubCouponForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGRefreshClubCouponForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGRefreshClubCouponForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGRefreshClubCouponForm.btnOKClick(Sender: TObject);
begin
  if (V1.DataController.DataSource.DataSet.RecordCount > 0) then
    ModalResult := mrOK;
end;

procedure TXGRefreshClubCouponForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
