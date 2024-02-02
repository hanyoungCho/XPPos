unit uXGAddonTicket;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox,
  { TMS }
  AdvShapeButton;

type
  TXGAddonTicketForm = class(TForm)
    lblFormTitle: TLabel;
    Panel1: TPanel;
    btnAllDay: TAdvShapeButton;
    btnHours1: TAdvShapeButton;
    btnHours4: TAdvShapeButton;
    btnHours2: TAdvShapeButton;
    ckbParkingTicket: TcxCheckBox;
    ckbSaunaTicket: TcxCheckBox;
    ckbFitnessTicket: TcxCheckBox;
    btnHours3: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure OnHoursButtonClick(Sender: TObject);
    procedure ckbParkingTicketPropertiesChange(Sender: TObject);
    procedure ckbSaunaTicketPropertiesChange(Sender: TObject);
    procedure ckbFitnessTicketPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FServiceHours: Integer;
    FUseParkingTicket: Boolean;
    FUseSaunaTicket: Boolean;
    FUseFitnessTicket: Boolean;
  public
    { Public declarations }
    property ServiceHours: Integer read FServiceHours write FServiceHours default 0;
    property UseParkingTicket: Boolean read FUseParkingTicket write FUseParkingTicket default False;
    property UseSaunaTicket: Boolean read FUseSaunaTicket write FUseSaunaTicket default False;
    property UseFitnessTicket: Boolean read FUseFitnessTicket write FUseFitnessTicket default False;
  end;

var
  XGAddonTicketForm: TXGAddonTicketForm;

implementation

uses
  uXGGlobal, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGAddonTicketForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  ckbParkingTicket.Enabled := Global.AddOnTicket.ParkingTicket;
  ckbSaunaTicket.Enabled := Global.AddOnTicket.SaunaTicket;
  if (Global.AddOnTicket.SaunaTicketKind = 1) then
    ckbSaunaTicket.Caption := '샤워실 이용권';
  ckbFitnessTicket.Enabled := Global.AddOnTicket.FitnessTicket;

  ckbParkingTicket.Checked := Global.AddOnTicket.ParkingTicket;
  ckbSaunaTicket.Checked := Global.AddOnTicket.SaunaTicket;
  ckbFitnessTicket.Checked := Global.AddOnTicket.FitnessTicket;
end;

procedure TXGAddonTicketForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGAddonTicketForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGAddonTicketForm.OnHoursButtonClick(Sender: TObject);
begin
  if (UseParkingTicket or UseSaunaTicket or UseFitnessTicket) then
  begin
    ServiceHours := TAdvShapeButton(Sender).Tag;
    ModalResult := mrOK;
  end;
end;

procedure TXGAddonTicketForm.ckbParkingTicketPropertiesChange(Sender: TObject);
begin
  UseParkingTicket := TcxCheckBox(Sender).Checked;
end;

procedure TXGAddonTicketForm.ckbSaunaTicketPropertiesChange(Sender: TObject);
begin
  UseSaunaTicket := TcxCheckBox(Sender).Checked;
end;

procedure TXGAddonTicketForm.ckbFitnessTicketPropertiesChange(Sender: TObject);
begin
  UseFitnessTicket := TcxCheckBox(Sender).Checked;
end;

end.
