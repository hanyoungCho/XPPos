unit uXGZipCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, mshtml,
  { TMS }
  AdvShapeButton;

type
  TXGZipCodeForm = class(TForm)
    WB: TWebBrowser;
    lblFormTitle: TLabel;
    btnClose: TAdvShapeButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure WBDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
  private
    { Private declarations }
    FSearched: Boolean;
    FSearchValue: string;
    FUseRoadNameAddress: Boolean;
    FZipCodeValue: string;
    FBldgCodeValue: string;
    FRoadAddressValue: string;
    FJibunAddressValue: string;
    FAutoJibunAddressValue: string;
    FSidoValue: string;
    FSigunguValue: string;
    FBldgNameValue: string;
    FRoadNameCodeValue: string;
    FBuildingNameValue: string;
    FBuildingCodeValue: string;

    function GetFormByNumber(ADocument: IHTMLDocument2; AFormNumber: Integer): IHTMLFormElement;
    procedure SetSearchValue(const AValue: string);
    function GetAddressValue: string;
  public
    { Public declarations }
    property UseRoadNameAddress: Boolean read FUseRoadNameAddress write FUseRoadNameAddress;
    property SearchValue: string read FSearchValue write SetSearchValue;
    property ZipCodeValue: string read FZipCodeValue write FZipCodeValue;
    property BldgCodeValue: string read FBldgCodeValue write FBldgCodeValue;
    property AddressValue: string read GetAddressValue;
    property RoadAddressValue: string read FRoadAddressValue write FRoadAddressValue;
    property JibunAddressValue: string read FJibunAddressValue write FJibunAddressValue;
    property AutoJibunAddressValue: string read FAutoJibunAddressValue write FAutoJibunAddressValue;
    property SidoValue: string read FSidoValue write FSidoValue;
    property SigunguValue: string read FSigunguValue write FSigunguValue;
    property BldgNameValue: string read FBldgNameValue write FBldgNameValue;
    property RoadNameCodeValue: string read FRoadNameCodeValue write FRoadNameCodeValue;
    property BuildingNameValue: string read FBuildingNameValue write FBuildingNameValue;
    property BuildingCodeValue: string read FBuildingCodeValue write FBuildingCodeValue;
  end;

var
  ZipCodeForm: TXGZipCodeForm;

implementation

uses
  uXGClientDM, uXGGlobal, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TXGZipCodeForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TXGZipCodeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TXGZipCodeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGZipCodeForm.btnCloseClick(Sender: TObject);
begin
  if FSearched then
    ModalResult := mrOk
  else
    ModalResult := mrCancel;
end;

procedure TXGZipCodeForm.SetSearchValue(const AValue: string);
begin
  FSearchValue := Trim(AValue);
  if (Length(FSearchValue) > 3) then
    WB.Navigate(Format('%s?addr=%s', [GCD_ZIPCODE_HOST, FSearchValue]))
  else
    WB.Navigate(Format('%s', [GCD_ZIPCODE_HOST]));
end;

procedure TXGZipCodeForm.WBDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  AForm: IHTMLFormElement;
begin
  if (Pos('post_result.asp', URL) > 0) then
  begin
    AForm := GetFormByNumber(WB.Document as IHTMLDocument2, 0);
    if Assigned(AForm) then
      with AForm do
      begin
        ZipCodeValue          := (Item('zonecode', '') as IHTMLInputElement).value;
        BldgCodeValue         := (Item('bcode', '') as IHTMLInputElement).value;
        RoadAddressValue      := (Item('roadAddress', '') as IHTMLInputElement).value;
        JibunAddressValue     := (Item('jibunAddress', '') as IHTMLInputElement).value;
        AutoJibunAddressValue := (Item('autoJibunAddress', '') as IHTMLInputElement).value;
        SidoValue             := (Item('sido', '') as IHTMLInputElement).value;
        SigunguValue          := (Item('sigungu', '') as IHTMLInputElement).value;
        BldgNameValue         := (Item('bname', '') as IHTMLInputElement).value;
        RoadNameCodeValue     := (Item('roadnameCode', '') as IHTMLInputElement).value;
        BuildingNameValue     := (Item('buildingName', '') as IHTMLInputElement).value;
        BuildingCodeValue     := (Item('buildingCode', '') as IHTMLInputElement).value;
        FSearched := True;
        ModalResult := mrOk;
      end else
      begin
        ZipCodeValue          := '';
        BldgCodeValue         := '';
        RoadAddressValue      := '';
        JibunAddressValue     := '';
        AutoJibunAddressValue := '';
        SidoValue             := '';
        SigunguValue          := '';
        BldgNameValue         := '';
        RoadNameCodeValue     := '';
        BuildingNameValue     := '';
        BuildingCodeValue     := '';
        FSearched := False;
      end;
  end;
end;

function TXGZipCodeForm.GetAddressValue: string;
begin
  if FUseRoadNameAddress then
  begin
    Result := Trim(RoadAddressValue);
    if Result.IsEmpty then
      Result := JibunAddressValue;
  end
  else
  begin
    Result := Trim(JibunAddressValue);
    if Result.IsEmpty then
      Result := RoadAddressValue;
  end;
end;

function TXGZipCodeForm.GetFormByNumber(ADocument: IHTMLDocument2; AFormNumber: Integer): IHTMLFormElement;
var
  AForms: IHTMLElementCollection;
begin
  Result := nil;
  AForms := ADocument.Forms as IHTMLElementCollection;
  if (AFormNumber < AForms.Length) then
    Result := AForms.Item(AFormNumber, '') as IHTMLFormElement;
end;

end.
