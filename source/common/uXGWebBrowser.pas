unit uXGWebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, OleCtrls, SHDocVw_EWB,
  { EmbeddedWB }
  EwbCore, EmbeddedWB,
  { TMS }
  AdvShapeButton;

type
  TXGWebBrowserForm = class(TForm)
    panHeader: TPanel;
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    btnClose: TAdvShapeButton;
    btnBackward: TAdvShapeButton;
    btnForward: TAdvShapeButton;
    btnReload: TAdvShapeButton;
    btnStop: TAdvShapeButton;
    btnGoURL: TAdvShapeButton;
    EmbeddedWB: TEmbeddedWB;
    sbrStatus: TStatusBar;
    btnHome: TAdvShapeButton;
    lblPOSInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBackwardClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnGoURLClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure EmbeddedWBStatusTextChange(ASender: TObject; const Text: WideString);
    procedure FormShow(Sender: TObject);
    procedure EmbeddedWBNewWindow2(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure EmbeddedWBNewWindow3(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool; dwFlags: Cardinal; const bstrUrlContext,
      bstrUrl: WideString);
  private
    { Private declarations }
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FHomeURL: string;
    FNaviURL: string;

    procedure SetNaviURL(const AValue: string);
    procedure OpenNewWindow(ASender: TObject; var ppDisp: IDispatch);
    procedure UpdateControls;
  public
    { Public declarations }
    property HomeURL: string read FHomeURL write FHomeURL;
    property NaviURL: string read FNaviURL write SetNaviURL;
  end;

var
  XGWebBrowserForm: TXGWebBrowserForm;

implementation

uses
  uXGGlobal, uXGCommonLib, uXGSaleManager;

{$R *.dfm}

{ TXGWebBrowserForm }

procedure TXGWebBrowserForm.FormCreate(Sender: TObject);
begin
  Global.WebBrowserId := Self.Handle;

  SetDoubleBuffered(Self, True);
  FIsFirst := True;
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
end;

procedure TXGWebBrowserForm.FormShow(Sender: TObject);
begin
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
end;

procedure TXGWebBrowserForm.SetNaviURL(const AValue: string);
begin
  if (FNaviURL <> AValue) then
  begin
    FNaviURL := AValue;
    EmbeddedWB.Go(FNaviURL);
  end;
end;

procedure TXGWebBrowserForm.OpenNewWindow(ASender: TObject; var ppDisp: IDispatch);
var
  NewApp: TXGWebBrowserForm;
begin
  Application.CreateForm(TXGWebBrowserForm, NewApp);
  NewApp.Visible := True;
  NewApp.Left := Left + 50;
  ppdisp := NewApp.EmbeddedWB.Application;
  NewApp.EmbeddedWB.RegisterAsBrowser := True;
end;

procedure TXGWebBrowserForm.UpdateControls;
begin
 if Assigned(EmbeddedWB) then
  if EmbeddedWB.Busy then
    EmbeddedWB.Stop;
end;

procedure TXGWebBrowserForm.btnBackwardClick(Sender: TObject);
begin
  UpdateControls;
  EmbeddedWB.GoBack;
end;

procedure TXGWebBrowserForm.btnCloseClick(Sender: TObject);
begin
  UpdateControls;
  ModalResult := mrOK;
end;

procedure TXGWebBrowserForm.btnForwardClick(Sender: TObject);
begin
  UpdateControls;
  EmbeddedWB.GoForward;
end;

procedure TXGWebBrowserForm.btnGoURLClick(Sender: TObject);
begin
  UpdateControls;
  EmbeddedWB.Go(NaviURL);
end;

procedure TXGWebBrowserForm.btnHomeClick(Sender: TObject);
begin
  UpdateControls;
  EmbeddedWB.Go(HomeURL);
end;

procedure TXGWebBrowserForm.btnReloadClick(Sender: TObject);
begin
  UpdateControls;
  EmbeddedWB.Refresh;
end;

procedure TXGWebBrowserForm.btnStopClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TXGWebBrowserForm.EmbeddedWBNewWindow2(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  OpenNewWindow(ASender, ppDisp);
end;

procedure TXGWebBrowserForm.EmbeddedWBNewWindow3(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool; dwFlags: Cardinal;
  const bstrUrlContext, bstrUrl: WideString);
begin
  OpenNewWindow(ASender, ppDisp);
end;

procedure TXGWebBrowserForm.EmbeddedWBStatusTextChange(ASender: TObject; const Text: WideString);
begin
  sbrStatus.SimpleText := Text;
end;

end.
