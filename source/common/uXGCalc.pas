unit uXGCalc;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  StdCtrls, ExtCtrls, Menus,
  { DevExpress }
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxControls, cxContainer,
  cxEdit, cxLabel, cxButtons,
  { TMS }
  AdvShapeButton;

{$I XGCommon.inc}
{$I XGPOS.inc}

type
  TCalcStatus = (csFirst, csValid, csError);

  TXGCalcForm = class(TForm)
    btnClear: TcxButton;
    btnSign: TcxButton;
    btnPercent: TcxButton;
    btnDivide: TcxButton;
    btnMulti: TcxButton;
    btnMinus: TcxButton;
    btnPlus: TcxButton;
    btnEqual: TcxButton;
    btn7: TcxButton;
    btn8: TcxButton;
    btn9: TcxButton;
    btn4: TcxButton;
    btn5: TcxButton;
    btn6: TcxButton;
    btn1: TcxButton;
    btn2: TcxButton;
    btn3: TcxButton;
    btn0: TcxButton;
    btn00: TcxButton;
    btnComma: TcxButton;
    panBody: TPanel;
    lblFormTitle: TLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    lblCalcResult: TcxLabel;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure CalcButtonClick(Sender: TObject);
  private
    { Private declarations }
    FCalcResult: Double;
    FCalcStatus: TCalcStatus;
    FOperand: Double;
    FOperator: Char;

    function GetCalcStatus : TCalcStatus;
    procedure SetCalcStatus(const ACalcStatus: TCalcStatus);
    function GetCalcResult: Double;
    procedure SetCalcResult(const AResult: Double);
    function GetDisplayText: string;
    procedure SetDisplayText(const AText: string);

    property CalcStatus: TCalcStatus read GetCalcStatus write SetCalcStatus;
    property DisplayText: string read GetDisplayText write SetDisplayText;
  public
    { Public declarations }
    property CalcResult: Double read GetCalcResult write SetCalcResult;

    procedure Clear;
  end;

var
  XGCalcForm: TXGCalcForm;

function ShowCalculator(var AValue: Double) : Boolean;

implementation

uses
  uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

function ShowCalculator(var AValue: Double): Boolean;
begin
  Result := False;
  with TXGCalcForm.Create(Application) do
  try
    CalcResult := AValue;
    if (ShowModal = MROK) then
    begin
      AValue := CalcResult;
      Result := True;
    end;
  finally
    Free;
  end;
end;

{ TXGCalcForm }

procedure TXGCalcForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
  Clear;
end;

procedure TXGCalcForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGCalcForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    btnClose.Click;
end;

procedure TXGCalcForm.FormKeyPress(Sender: TObject; var Key: Char);
const
  CS_KEY_SIGN    = '#';
  CS_KEY_CLEAR   = 'C';
  CS_KEY_DECIMAL = '.';
  CS_ERROR_MSG   = '에러';
var
  cKey: Char;
begin
  cKey := UpCase(Key);

  if (cKey = FormatSettings.DecimalSeparator) then
    cKey := CS_KEY_DECIMAL;

  if (CalcStatus <> csError) or (cKey = CS_KEY_CLEAR) then
    case cKey of
      '0'..'9':
      begin
        if (CalcStatus = csFirst) or (DisplayText = '0') then
          DisplayText := '';

        CalcStatus := csValid;
        DisplayText := DisplayText + cKey;
      end;

      #8: //BackSpace
      begin
        if (Length(DisplayText) > 0) then begin
          DisplayText := Copy(DisplayText, 1, Length(DisplayText)-1);
          if (Length(DisplayText) = 0) then
            DisplayText := '0';

          CalcStatus := csValid;
        end;
      end;

      CS_KEY_DECIMAL:
      begin
        if (Pos(FormatSettings.DecimalSeparator, DisplayText) = 0) then
          DisplayText := DisplayText + FormatSettings.DecimalSeparator;

        CalcStatus := csValid;
      end;

      '+', '-', '/', '*', '=' :
      begin
        case FOperator of
          '+':
            CalcResult := CalcResult + FOperand;

          '-':
            CalcResult := FOperand - CalcResult;

          '*':
            CalcResult := CalcResult * FOperand;

          '/':
            if (CalcResult = 0) then
              CalcStatus := csError
            else
              CalcResult := FOperand / CalcResult;
        end;

        if (CalcStatus <> csError) then
        begin
          CalcStatus := csFirst;
          FOperand := CalcResult;
          FOperator := cKey;
        end;
      end;

      CS_KEY_SIGN:
        CalcResult := -CalcResult;

      CS_KEY_CLEAR:
        Clear;
    end;

  if (CalcStatus = csError) then
    DisplayText := CS_ERROR_MSG;
end;

procedure TXGCalcForm.SetCalcStatus(const ACalcStatus: TCalcStatus);
begin
  FCalcStatus := ACalcStatus;
end;

function TXGCalcForm.GetCalcStatus: TCalcStatus;
begin
  Result := FCalcStatus;
end;

procedure TXGCalcForm.SetCalcResult(const AResult: Double);
begin
  FCalcResult := AResult;
  DisplayText := FloatToStrF(FCalcResult, ffFixed, 10, 2);
end;

function TXGCalcForm.GetCalcResult: Double;
begin
  Result := StrToFloatDef(DisplayText, 0);
end;

procedure TXGCalcForm.SetDisplayText(const AText: string);
const
  MAX_LEN = 12;
begin
  try
    if (Length(AText) <= MAX_LEN) then
      lblCalcResult.Caption := AText + ' '
  except
    on E: Exception do
      ShowMessage(E.Message + _CRLF + '입력 값: ' + AText);
  end;
end;


function TXGCalcForm.GetDisplayText: string;
begin
  Result := Trim(StringReplace(lblCalcResult.Caption, ',', '', [rfReplaceAll]));
end;

procedure TXGCalcForm.Clear;
begin
  CalcStatus  := csFirst;
  DisplayText := '0';
  FOperand    := 0;
  FOperator   := #0;
end;

procedure TXGCalcForm.CalcButtonClick(Sender: TObject);
var
  I, nRepeat: Integer;
  cKey: Char;
begin
  with TcxButton(Sender) do
  begin
    cKey := Char(Tag);
    nRepeat := IIF(HelpContext = 0, 1, HelpContext);
    for I := 1 to nRepeat do
      FormKeyPress(Sender, cKey);
  end;
end;

procedure TXGCalcForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGCalcForm.btnOKClick(Sender: TObject);
var
  cKey: Char;
begin
  cKey := '=';
  FormKeyPress(Self, cKey);
end;

end.
