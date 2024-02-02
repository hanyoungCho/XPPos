unit uXGCalendar;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  ExtCtrls, StdCtrls,
  { TMS }
  AdvShapeButton,
  { SolbiVCL }
  mxCalendar;

type
  TXGCalendarForm = class(TForm)
    lblFormTitle: TLabel;
    panMonthPicker: TPanel;
    btnCurrMonth: TAdvShapeButton;
    btnLastMonth: TAdvShapeButton;
    btnNextMonth: TAdvShapeButton;
    panBody: TPanel;
    maxCalendar: TmxCalendar;
    btnToday: TAdvShapeButton;
    btnOK: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLastMonthClick(Sender: TObject);
    procedure btnNextMonthClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetDate(const ADate: TDateTime);
    function GetDate: TDateTime;
    function GetYear: Word;
    function GetMonth: Word;
    function GetDay: Word;
  public
    { Public declarations }
    property Date: TDateTime read GetDate write SetDate;
    property Year: Word read GetYear;
    property Month: Word read GetMonth;
    property Day: Word read GetDay;
  end;

var
  XGCalendarForm: TXGCalendarForm;

implementation

uses
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGCalendarForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGCalendarForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGCalendarForm.FormShow(Sender: TObject);
begin
  btnCurrMonth.Text := FormatDateTime('yyyy년 mm월', maxCalendar.Date);
end;

procedure TXGCalendarForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGCalendarForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGCalendarForm.btnLastMonthClick(Sender: TObject);
begin
  maxCalendar.Date := IncMonth(maxCalendar.Date, -1);
  btnCurrMonth.Text := FormatDateTime('yyyy년 mm월', maxCalendar.Date);
end;

procedure TXGCalendarForm.btnNextMonthClick(Sender: TObject);
begin
  maxCalendar.Date  := IncMonth(maxCalendar.Date, 1);
  btnCurrMonth.Text := FormatDateTime('yyyy년 mm월', maxCalendar.Date);
end;

procedure TXGCalendarForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TXGCalendarForm.btnTodayClick(Sender: TObject);
begin
  maxCalendar.Date := Now;
  btnCurrMonth.Text := FormatDateTime('yyyy년 mm월', maxCalendar.Date);
  ModalResult := mrOK;
end;

function TXGCalendarForm.GetDate: TDateTime;
begin
  Result := maxCalendar.Date;
end;

function TXGCalendarForm.GetDay: Word;
begin
  Result := maxCalendar.Day;
end;

function TXGCalendarForm.GetMonth: Word;
begin
  Result := maxCalendar.Month;
end;

function TXGCalendarForm.GetYear: Word;
begin
  Result := maxCalendar.Year;
end;

procedure TXGCalendarForm.SetDate(const ADate: TDateTime);
begin
  maxCalendar.Date := ADate;
end;

end.
