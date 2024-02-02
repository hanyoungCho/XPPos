(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 플러그인 템플리트 폼
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGWeather;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.Forms,
  Vcl.Controls, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, cxLabel, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxImage, cxBlobEdit,
  cxCalendar, cxContainer, cxGroupBox, cxRadioGroup, Vcl.Menus, cxButtons;

{$I ..\..\common\XGPOS.inc}

type
  TXGWeatherForm = class(TPluginModule)
    panBody: TPanel;
    lblFormTitle: TLabel;
    G1: TcxGrid;
    ViewWeatherHours: TcxGridDBTableView;
    L1: TcxGridLevel;
    ViewWeatherHoursdatetime: TcxGridDBColumn;
    ViewWeatherHourstemper: TcxGridDBColumn;
    ViewWeatherHoursprecipit: TcxGridDBColumn;
    ViewWeatherHourshumidity: TcxGridDBColumn;
    ViewWeatherHourswind_speed: TcxGridDBColumn;
    ViewWeatherHourscondition: TcxGridDBColumn;
    ViewWeatherHoursicon: TcxGridDBColumn;
    ViewWeatherDays: TcxGridDBTableView;
    ViewWeatherDaysdatetime: TcxGridDBColumn;
    ViewWeatherDaystemper: TcxGridDBColumn;
    ViewWeatherDaysprecipit: TcxGridDBColumn;
    ViewWeatherDayshumidity: TcxGridDBColumn;
    ViewWeatherDayswind_speed: TcxGridDBColumn;
    ViewWeatherDayscondition: TcxGridDBColumn;
    ViewWeatherDaysicon: TcxGridDBColumn;
    rdgWeatherKind: TcxRadioGroup;
    Image1: TImage;
    btnClose: TAdvShapeButton;
    AdvShapeButton1: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure rdgWeatherKindPropertiesChange(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FTargetID: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGWeatherForm }

procedure TXGWeatherForm.btnRefreshClick(Sender: TObject);
begin
  ClientDM.GetWeatherInfo;
end;

constructor TXGWeatherForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  MakeRoundedControl(G1);
  FTargetID := -1;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGWeatherForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGWeatherForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGWeatherForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGWeatherForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FTargetID := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TXGWeatherForm.rdgWeatherKindPropertiesChange(Sender: TObject);
begin
  with TcxRadioGroup(Sender) do
    if (ItemIndex = 0) then
    begin
      lblFormTitle.Caption := '금일 날씨 동향';
      L1.GridView := ViewWeatherHours;
    end
    else
    begin
      lblFormTitle.Caption := '주간 날씨 동향';
      L1.GridView := ViewWeatherDays;
    end;
end;

procedure TXGWeatherForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TXGWeatherForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGWeatherForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.