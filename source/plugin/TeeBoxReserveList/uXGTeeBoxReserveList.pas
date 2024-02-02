(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 타석 배정 내역 조회
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-07-02   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2021 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxReserveList;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  Menus, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxControls, cxDataStorage, cxStyles, cxFilter,
  cxCustomData, cxData, cxEdit, cxNavigator, dxScrollbarAnnotations, cxDBData, dxDateRanges,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxGridDBTableView, cxButtons, cxLabel,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxReserveListForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    L1: TcxGridLevel;
    V2: TcxGridDBTableView;
    V1reserve_no: TcxGridDBColumn;
    V1prepare_min: TcxGridDBColumn;
    V1remain_min: TcxGridDBColumn;
    V1member_nm: TcxGridDBColumn;
    V1reserve_date: TcxGridDBColumn;
    V1start_time: TcxGridDBColumn;
    V1end_time: TcxGridDBColumn;
    panToolbar: TPanel;
    Label11: TLabel;
    btnPriorDay: TAdvShapeButton;
    btnSearchDate: TAdvShapeButton;
    btnNextDay: TAdvShapeButton;
    V1calc_use_status: TcxGridDBColumn;
    V1calc_move_status: TcxGridDBColumn;
    V2reserve_no: TcxGridDBColumn;
    V2teebox_nm: TcxGridDBColumn;
    V2prepare_min: TcxGridDBColumn;
    V2assign_min: TcxGridDBColumn;
    V2reserve_datetime: TcxGridDBColumn;
    V2start_time: TcxGridDBColumn;
    V2member_nm: TcxGridDBColumn;
    V2status: TcxGridDBColumn;
    btnRefresh: TcxButton;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnPriorDayClick(Sender: TObject);
    procedure btnNextDayClick(Sender: TObject);
    procedure btnSearchDateClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure OnCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FSearchDate: TDateTime;
    FTeeBoxNo: Integer;
    FEmergencyView: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoQuery;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Graphics,
  { DevExpress }
  dxCore, cxGridCommon,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGCalendar, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxReserveListForm }

constructor TXGTeeBoxReserveListForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerID := -1;
  FSearchDate := Now;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnSearchDate.Text := FormatDateTime('yyyy-mm-dd', FSearchDate);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  DoQuery;
end;

destructor TXGTeeBoxReserveListForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxReserveListForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  TcxGridDBTableView(L1.GridView).DataController.DataSet.Close;
  Action := caFree;
end;

procedure TXGTeeBoxReserveListForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxReserveListForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    FEmergencyView := AMsg.ParamByBoolean(CPP_EMERGENCY_MODE);
    if FEmergencyView then
    begin
      FTeeBoxNo := 0;
      lblFormTitle.Caption := '긴급 배정 내역 조회';
      L1.GridView := V2;
    end
    else
    begin
      FTeeBoxNo := AMsg.ParamByInteger(CPP_TEEBOX_NO);
      lblFormTitle.Caption := AMsg.ParamByString(CPP_TEEBOX_NAME) + '번 타석 배정 내역 조회';
      L1.GridView := V1;
    end;
  end;
end;

procedure TXGTeeBoxReserveListForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxReserveListForm.btnPriorDayClick(Sender: TObject);
begin
  FSearchDate := (FSearchDate - 1);
  btnSearchDate.Text := FormatDateTime('yyyy-mm-dd', FSearchDate);
  DoQuery;
end;

procedure TXGTeeBoxReserveListForm.btnRefreshClick(Sender: TObject);
begin
  DoQuery;
end;

procedure TXGTeeBoxReserveListForm.btnNextDayClick(Sender: TObject);
begin
  FSearchDate := (FSearchDate + 1);
  btnSearchDate.Text := FormatDateTime('yyyy-mm-dd', FSearchDate);
  DoQuery;
end;

procedure TXGTeeBoxReserveListForm.btnSearchDateClick(Sender: TObject);
begin
  with TXGCalendarForm.Create(nil) do
  try
    if (ShowModal = mrOk) then
    begin
      FSearchDate := Date;
      TAdvShapeButton(Sender).Text := FormatDateTime('yyyy-mm-dd', FSearchDate);
      DoQuery;
    end;
  finally
    Free;
  end;
end;

procedure TXGTeeBoxReserveListForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(TcxGridDBTableView(L1.GridView));
end;

procedure TXGTeeBoxReserveListForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(TcxGridDBTableView(L1.GridView));
end;

procedure TXGTeeBoxReserveListForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(TcxGridDBTableView(L1.GridView));
end;

procedure TXGTeeBoxReserveListForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(TcxGridDBTableView(L1.GridView));
end;

procedure TXGTeeBoxReserveListForm.OnCustomDrawColumnHeader(Sender: TcxGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
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
    ACanvas.FillRect(AViewInfo.Bounds, $00689F0E);

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[I]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

procedure TXGTeeBoxReserveListForm.DoQuery;
var
  sErrMsg: string;
begin
  try
    if FEmergencyView then
    begin
      if not ClientDM.GetTeeBoxReserveListEmergency(FormatDateTime('yyyymmdd', FSearchDate), sErrMsg) then
        raise Exception.Create(sErrMsg);
    end
    else
    begin
      if not ClientDM.GetTeeBoxReserveList(FormatDateTime('yyyymmdd', FSearchDate), FTeeBoxNo, sErrMsg) then
        raise Exception.Create(sErrMsg);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '타석 배정 내역을 조회할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxReserveListForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.