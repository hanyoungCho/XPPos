unit uXGInputStartLesson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Menus,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxButtons,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxSpinEdit,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGInputStartLessonForm = class(TForm)
    lblFormTitle: TLabel;
    panInput: TPanel;
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
    Label3: TLabel;
    cbxLessonProCode: TcxComboBox;
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
    procedure cbxLessonProCodePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FStartYear: Word;
    FStartMonth: Word;
    FStartDay: Word;
    FSelectedDate: TDateTime;
    FLessonProCode: string;
    FLessonProName: string;
    FLessonProCodes: TStringList;
    FWorking: Boolean;

    function GetStartYear: Word;
    procedure SetStartYear(const AValue: Word);
    function GetStartMonth: Word;
    procedure SetStartMonth(const AValue: Word);
    function GetStartDay: Word;
    procedure SetStartDay(const AValue: Word);
    function GetSelectedDate: TDateTime;
    procedure SetProdName(const AValue: string);
  public
    { Public declarations }
    property ProdName: string write SetProdName;
    property StartYear: Word read GetStartYear write SetStartYear;
    property StartMonth: Word read GetStartMonth write SetStartMonth;
    property StartDay: Word read GetStartDay write SetStartDay;
    property SelectedDate: TDateTime read GetSelectedDate write FSelectedDate;
    property LessonProCode: string read FLessonProCode write FLessonProCode;
    property LessonProName: string read FLessonProName write FLessonProName;
  end;

var
  XGInputStartLessonForm: TXGInputStartLessonForm;

implementation

uses
  { Native }
  DateUtils,
  { SolbiLib }
  uPluginManager, uPluginMessages,
  { Project }
  uXGGlobal, uXGClientDM, uXGCommonLib, uXGCalendar, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGInputStartLessonForm }

procedure TXGInputStartLessonForm.FormCreate(Sender: TObject);
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

  FLessonProCodes := TStringList.Create;
  FLessonProCode := '';
  FLessonProName := '';
  ClientDM.GetLessonProCodes(FLessonProCodes);
  cbxLessonProCode.Properties.Items := FLessonProCodes;
  cbxLessonProCode.Properties.OnChange := cbxLessonProCodePropertiesChange;
  if (cbxLessonProCode.Properties.Items.Count > 0) then
    cbxLessonProCode.ItemIndex := 0;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.Handle);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGInputStartLessonForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientDM.FreeCodes(FLessonProCodes);
  LF.Close;
  LF.Free;
end;

procedure TXGInputStartLessonForm.FormActivate(Sender: TObject);
begin
  edtStartYear.SetFocus;
end;

procedure TXGInputStartLessonForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TXGInputStartLessonForm.btnCalendarClick(Sender: TObject);
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

procedure TXGInputStartLessonForm.btnOKClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    if (cbxLessonProCode.ItemIndex < 0) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '레슨 프로가 선택되지 않았습니다!', ['확인'], 5);
      Exit;
    end;

    ModalResult := mrOK;
  finally
    FWorking := False;
  end;
end;

procedure TXGInputStartLessonForm.btnTodayClick(Sender: TObject);
var
  nYear, nMonth, nDay: Word;
begin
  DecodeDate(Now, nYear, nMonth, nDay);
  StartYear := nYear;
  StartMonth := nMonth;
  StartDay := nDay;
end;

procedure TXGInputStartLessonForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGInputStartLessonForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGInputStartLessonForm.edtStartMonthPropertiesChange(Sender: TObject);
begin
  edtStartDay.Properties.MaxValue := DayOf(EndOfAMonth(StartYear, StartMonth));
end;

procedure TXGInputStartLessonForm.cbxLessonProCodePropertiesChange(Sender: TObject);
begin
  with TcxComboBox(Sender) do
  begin
    LessonProCode := '';
    LessonProName := '';
    if (ItemIndex >= 0) then
    begin
      LessonProCode := TCodeRec(Properties.Items.Objects[ItemIndex]).Code;
      LessonProName := TCodeRec(Properties.Items.Objects[ItemIndex]).CodeName;
    end;
  end;
end;

procedure TXGInputStartLessonForm.SetProdName(const AValue: string);
begin
  lblProdName.Caption := AValue;
end;

function TXGInputStartLessonForm.GetStartYear: Word;
begin
  Result := Trunc(edtStartYear.Value);
end;

procedure TXGInputStartLessonForm.SetStartYear(const AValue: Word);
begin
  FStartYear := AValue;
  edtStartYear.Value := AValue;
end;

function TXGInputStartLessonForm.GetStartMonth: Word;
begin
  Result := Trunc(edtStartMonth.Value);
end;

procedure TXGInputStartLessonForm.SetStartMonth(const AValue: Word);
begin
  FStartMonth := AValue;
  edtStartMonth.Value := AValue;
end;

function TXGInputStartLessonForm.GetStartDay: Word;
begin
  Result := Trunc(edtStartDay.Value);
end;

procedure TXGInputStartLessonForm.SetStartDay(const AValue: Word);
begin
  FStartDay := AValue;
  edtStartDay.Value := AValue;
end;

function TXGInputStartLessonForm.GetSelectedDate: TDateTime;
begin
  Result := EncodeDate(StartYear, StartMonth, StartDay);
end;

end.
