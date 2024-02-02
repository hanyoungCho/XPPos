(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 회원 정보 (조회, 등록, 수정)
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGProductList;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Menus, DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxCurrencyEdit,
  dxScrollbarAnnotations, cxDBData, cxLabel, cxCheckBox, cxContainer, cxTextEdit, cxGridLevel,
  cxButtons, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView,
  cxGrid,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGProductListForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panGrid: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    V1product_nm: TcxGridDBColumn;
    V1product_amt: TcxGridDBColumn;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    panBody: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    edtSearchProdName: TcxTextEdit;
    V1product_cd: TcxGridDBColumn;
    V1tax_type: TcxGridDBColumn;
    V1barcode: TcxGridDBColumn;
    V1refund_yn: TcxGridDBColumn;
    edtSearchBarcode: TcxTextEdit;
    btnClose: TAdvShapeButton;
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtSearchProdNameEnter(Sender: TObject);
    procedure edtSearchProdNameExit(Sender: TObject);
    procedure edtSearchProdNamePropertiesChange(Sender: TObject);
    procedure edtSearchBarcodePropertiesChange(Sender: TObject);
    procedure V1DblClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FReadBuffer: string;
    FIsSearchProdName: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

var
  XGProductListForm: TXGProductListForm;

implementation

uses
  uXGClientDM, uXGCommonLib, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGProductListForm }

constructor TXGProductListForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FReadBuffer := '';
  FIsSearchProdName := False;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGProductListForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGProductListForm.PluginModuleActivate(Sender: TObject);
begin
  edtSearchProdName.SetFocus;
end;

procedure TXGProductListForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGProductListForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGProductListForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TXGProductListForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not FIsSearchProdName then
  begin
    case Key of
      VK_RETURN:
        begin
          edtSearchBarcode.Text := FReadBuffer;
          FReadBuffer := '';
        end;
      48..57, 65..90, 97..122: //(0..9, A..Z, a..z)
        FReadBuffer := FReadBuffer + Chr(Key);
    end;
  end;
end;

procedure TXGProductListForm.edtSearchProdNameEnter(Sender: TObject);
begin
  FIsSearchProdName := True;
end;

procedure TXGProductListForm.edtSearchProdNameExit(Sender: TObject);
begin
  FIsSearchProdName := False;
end;

procedure TXGProductListForm.edtSearchProdNamePropertiesChange(Sender: TObject);
begin
  V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('product_nm').Index];
  V1.Controller.IncSearchingText := TcxTextEdit(Sender).Text;
end;

procedure TXGProductListForm.edtSearchBarcodePropertiesChange(Sender: TObject);
begin
  V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('barcode').Index];
  V1.Controller.IncSearchingText := TcxTextEdit(Sender).Text;
end;

procedure TXGProductListForm.V1DblClick(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TXGProductListForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGProductListForm.btnOKClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  with ClientDM.MDProdGeneral do
  try
    if (RecordCount = 0) then
      Exit;

    PM.Command := CPC_SELECT_PROD_ITEM;
    PM.AddParams(CPP_PRODUCT_DIV, CPD_GENERAL);
    PM.AddParams(CPP_PRODUCT_CD, FieldByName('product_cd').AsString);
    PM.AddParams(CPP_PRODUCT_NAME, FieldByName('product_nm').AsString);
    PM.AddParams(CPP_PRODUCT_AMT, FieldByName('product_amt').AsInteger);
    PM.PluginMessageToID(FOwnerId);
    ModalResult := mrOK;
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGProductListForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGProductListForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGProductListForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGProductListForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGProductListForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGProductListForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.