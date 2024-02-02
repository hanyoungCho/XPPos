unit uXGInputStartDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Menus,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxButtons, cxTextEdit, cxMaskEdit, cxSpinEdit,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGInputStartDateForm = class(TForm)
    lblFormTitle: TLabel;
    panInput: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    panNumPad: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblProdName: TLabel;
    edtStartYear: TcxSpinEdit;
    edtStartMonth: TcxSpinEdit;
    edtStartDay: TcxSpinEdit;
    btnCalendar: TcxButton;
    btnToday: TcxButton;
    btnClose: TAdvShapeButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCalendarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtStartMonthPropertiesChange(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
  private
    { Private declarations }
    FStartYear: Word;
    FStartMonth: Word;
    FStartDay: Word;
    FSelectedDate: TDateTime;
    FWorking: Boolean;

    procedure SetProdName(const AValue: string);
    function GetStartYear: Word;
    procedure SetStartYear(const AValue: Word);
    function GetStartMonth: Word;
    procedure SetStartMonth(const AValue: Word);
    function GetStartDay: Word;
    procedure SetStartDay(const AValue: Word);
    function GetSelectedDate: TDateTime;
  public
    { Public declarations }
    property ProdName: string write SetProdName;
    property StartYear: Word read GetStartYear write SetStartYear;
    property StartMonth: Word read GetStartMonth write SetStartMonth;
    property StartDay: Word read GetStartDay write SetStartDay;
    property SelectedDate: TDateTime read GetSelectedDate write FSelectedDate;
  end;

var
  XGInputStartDateForm: TXGInputStartDateForm;

implementation

uses
  DateUtils,
  uPluginManager, uPluginMessages, uXGCommonLib, uXGCalendar, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGInputStartDateForm.FormCreate(Sender: TObject);
var
  PM: TPluginMessage;
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  StartYear := YearOf(Now);
  StartMonth := MonthOf(Now);
  StartDay := DayOf(Now);
  SelectedDate := EncodeDate(StartYear, StartMonth, StartDay);
  edtStartDay.Properties.MaxValue := DayOf(EndOfAMonth(StartYear, StartMonth));

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.Handle);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGInputStartDateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGInputStartDateForm.FormActivate(Sender: TObject);
begin
  edtStartYear.SetFocus;
end;

procedure TXGInputStartDateForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F2:
      btnCalendar.Click;
    VK_F3:
      btnToday.Click;
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGInputStartDateForm.btnCalendarClick(Sender: TObject);
begin
  with TXGCalendarForm.Create(nil) do
  try
    if (ShowModal = mrOk) then
    begin
      StartYear := YearOf(Date);
      StartMonth := MonthOf(Date);
      StartDay := DayOf(Date);
    end;
  finally
    Free;
  end;
end;

procedure TXGInputStartDateForm.btnOKClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    ModalResult := mrOK;
  finally
    FWorking := False;
  end;
end;

procedure TXGInputStartDateForm.btnTodayClick(Sender: TObject);
var
  nYear, nMonth, nDay: Word;
begin
  DecodeDate(Now, nYear, nMonth, nDay);
  StartYear := nYear;
  StartMonth := nMonth;
  StartDay := nDay;
end;

procedure TXGInputStartDateForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGInputStartDateForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGInputStartDateForm.edtStartMonthPropertiesChange(Sender: TObject);
begin
  edtStartDay.Properties.MaxValue := DayOf(EndOfAMonth(StartYear, StartMonth));
end;

procedure TXGInputStartDateForm.SetProdName(const AValue: string);
begin
  lblProdName.Caption := AValue;
end;

function TXGInputStartDateForm.GetStartYear: Word;
begin
  Result := Trunc(edtStartYear.Value);
end;

procedure TXGInputStartDateForm.SetStartYear(const AValue: Word);
begin
  FStartYear := AValue;
  edtStartYear.Value := AValue;
end;

function TXGInputStartDateForm.GetStartMonth: Word;
begin
  Result := Trunc(edtStartMonth.Value);
end;

procedure TXGInputStartDateForm.SetStartMonth(const AValue: Word);
begin
  FStartMonth := AValue;
  edtStartMonth.Value := AValue;
end;

function TXGInputStartDateForm.GetStartDay: Word;
begin
  Result := Trunc(edtStartDay.Value);
end;

procedure TXGInputStartDateForm.SetStartDay(const AValue: Word);
begin
  FStartDay := AValue;
  edtStartDay.Value := AValue;
end;

function TXGInputStartDateForm.GetSelectedDate: TDateTime;
begin
  Result := EncodeDate(StartYear, StartMonth, StartDay);
end;

end.
