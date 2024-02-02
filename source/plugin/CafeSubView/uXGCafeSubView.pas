(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 카페POS 서브 모니터
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2020-08-11   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
unit uXGCafeSubView;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxGrid,
  dxScrollbarAnnotations, cxDBData, cxLabel, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView,
  { SolbiVCL }
  PicShow, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

{$I ..\..\common\XGPOS.inc}

type
  TXGCafeSubViewForm = class(TPluginModule)
    panCashResult: TPanel;
    imgSaleResult: TImage;
    cxLabel1: TLabel;
    lblProductName: TLabel;
    cxLabel2: TLabel;
    lblSellTotal: TLabel;
    cxLabel3: TLabel;
    lblDiscountTotal: TLabel;
    cxLabel4: TLabel;
    lblChargeTotal: TLabel;
    cxLabel5: TLabel;
    lblPaidAmt: TLabel;
    cxLabel6: TLabel;
    lblChangeAmt: TLabel;
    panPicShow: TPanel;
    PicShow: TPicShow;
    tmrContents: TTimer;
    panHeader: TPanel;
    tmrClock: TTimer;
    panHeaderInfo: TPanel;
    lblPluginVersion: TLabel;
    panDateTime: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1calc_category_div: TcxGridDBBandedColumn;
    V1product_nm: TcxGridDBBandedColumn;
    V1order_qty: TcxGridDBBandedColumn;
    V1calc_dc_amt: TcxGridDBBandedColumn;
    V1calc_charge_amt: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    imgLogo: TImage;
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure tmrClockTimer(Sender: TObject);
    procedure tmrContentsTimer(Sender: TObject);
    procedure V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
  private
    { Private declarations }
    FOwnerID: Integer;
    FContentList: TStringList;
    FContentIndex: Integer;
    FIsFirst: Boolean;
    FIdleMode: Boolean;
    FTimeBlink: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure SetIdleMode(const AIdleMode: Boolean);
    procedure PlayContent;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, dxCore, cxGridCommon, Math,
  uXGClientDM, uXGGlobal, uXGCommonLib;

{$R *.dfm}

{ TXGCafeSubViewForm }

constructor TXGCafeSubViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerID := -1;
  FIsFirst := True;
  SetDoubleBuffered(Self, True);
  Self.Width := Global.SubMonitor.Width;
  Self.Height := Global.SubMonitor.Height;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  FContentIndex := 0;
  FContentList := TStringList.Create;
  FContentList.Clear;
  GetFileList(Global.ContentsDir, 'jpg;png', FContentList); //jpeg & png image file only
  if (FContentList.Count > 0) then
  begin
    tmrContents.Interval := 5000;
    tmrContents.Enabled := True;
  end;

  FIdleMode := True;
  SetIdleMode(FIdleMode);
  tmrClock.Interval := 100;
  tmrClock.Enabled := True;

  UpdateLog(Global.LogFile, 'XGCafeSubViewForm.Started');
end;

destructor TXGCafeSubViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGCafeSubViewForm.PluginModuleShow(Sender: TObject);
begin
  Top  := Global.SubMonitor.Top;
  Left := Global.SubMonitor.Left;
end;

procedure TXGCafeSubViewForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
  if Global.Closing then
  begin
    tmrContents.Enabled := False;
    PicShow.Stop;
    FreeAndNil(FContentList);
  end;
end;

procedure TXGCafeSubViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TXGCafeSubViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGCafeSubViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_SALE_RESULT) then
  begin
    if FIdleMode then
    begin
      FIdleMode := False;
      SetIdleMode(FIdleMode);
    end;

    lblProductName.Caption   := AMsg.ParamByString(CPP_PRODUCT_NAME);
    lblSellTotal.Caption     := FormatCurr('\#,##0', AMsg.ParamByInteger(CPP_SELL_AMT));
    lblDiscountTotal.Caption := FormatCurr('\#,##0', AMsg.ParamByInteger(CPP_DISCOUNT_AMT));
    lblChargeTotal.Caption   := FormatCurr('\#,##0', AMsg.ParamByInteger(CPP_CHARGE_AMT));
    lblPaidAmt.Caption       := FormatCurr('\#,##0', AMsg.ParamByInteger(CPP_PAID_AMT));
    lblChangeAmt.Caption     := FormatCurr('\#,##0', AMsg.ParamByInteger(CPP_CHANGE_AMT));
  end;

  if (AMsg.Command = CPC_SET_SUBVIEW) then
  begin
    FIdleMode := AMsg.ParamByBoolean(CPP_IDLE_MODE);
    SetIdleMode(FIdleMode);
  end;
end;

procedure TXGCafeSubViewForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    FTimeBlink := not FTimeBlink;
    lblClockDate.Caption := Global.FormattedCurrentDate;
    lblClockWeekday.Caption := Format('(%s)', [Global.DayOfWeekKR]);
    lblClockHours.Caption := Copy(Global.CurrentTime, 1, 2);
    lblClockMins.Caption := Copy(Global.CurrentTime, 3, 2);
    lblClockSepa.Caption := IIF(FTimeBlink, '', ':');

    if FIsFirst then
    begin
      Interval := 500;
      FIsFirst := False;
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;

procedure TXGCafeSubViewForm.tmrContentsTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    PlayContent;
  finally
  end;
end;

procedure TXGCafeSubViewForm.V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
begin
  AViewInfo.Borders := [];

  if AViewInfo.IsPressed then
  begin
    ACanvas.FillRect(AViewInfo.Bounds, clGreen);
    ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
    ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
    ACanvas.ExcludeClipRect(AViewInfo.Bounds);
  end
  else
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); // $00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[i]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

procedure TXGCafeSubViewForm.SetIdleMode(const AIdleMode: Boolean);
begin
  G1.Visible := (not AIdleMode);
  panCashResult.Visible := (not AIdleMode);
  panPicShow.Top := IIF(AIdleMode, panHeader.Height, 72);
  panPicShow.Left := IIF(AIdleMode, 0, 402);
  panPicShow.Width := IIF(AIdleMode, Self.Width, 390);
  panPicShow.Height := IIF(AIdleMode, Self.Height - panHeader.Height, 260);
end;

procedure TXGCafeSubViewForm.PlayContent;
var
  sContent, sFileExt: string;
  nStyle: shortint;
begin
  if (FContentIndex >= FContentList.Count) then
    FContentIndex := 0;

  try
    sContent := FContentList.Strings[FContentIndex];
    if FileExists(sContent) then
    begin
      sFileExt := LowerCase(ExtractFileExt(sContent));
      if (sFileExt = '.jpg') or (sFileExt = '.png') then
      begin
        Randomize;
        nStyle := RandomRange(1, 172);
        try
          PicShow.Picture.LoadFromFile(sContent);
          PicShow.Style := TShowStyle(nStyle);
          PicShow.Execute;
        finally
          tmrContents.Enabled := True;
        end;
      end;
    end;
  finally
    Inc(FContentIndex);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGCafeSubViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.