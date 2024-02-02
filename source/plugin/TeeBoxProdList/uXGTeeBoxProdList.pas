(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 타석 상품 조회
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxProdList;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  Menus, DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxDBData, dxScrollbarAnnotations,
  cxLabel, cxCurrencyEdit, cxButtons, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxProdListForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    panGrid: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    V1calc_zone_cd: TcxGridDBColumn;
    V1calc_sex_div: TcxGridDBColumn;
    V1product_nm: TcxGridDBColumn;
    V1product_amt: TcxGridDBColumn;
    V1start_time: TcxGridDBColumn;
    V1end_time: TcxGridDBColumn;
    V1one_use_time: TcxGridDBColumn;
    V1one_use_cnt: TcxGridDBColumn;
    V1use_month: TcxGridDBColumn;
    V1use_cnt: TcxGridDBColumn;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    Label1: TLabel;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure V1DblClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginModuleActivate(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  DateUtils, Graphics,
  { DevExpress }
  dxCore, cxGridCommon,
  { Project }
  uXGGlobal, uXGClientDM, uXGSaleManager, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ XGTeeBoxProdListForm }

constructor TXGTeeBoxProdListForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGTeeBoxProdListForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxProdListForm.PluginModuleActivate(Sender: TObject);
begin
  G1.SetFocus;
end;

procedure TXGTeeBoxProdListForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGTeeBoxProdListForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxProdListForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    lblFormTitle.Caption := AMsg.ParamByString(CPP_FORM_TITLE);
  end;
end;

procedure TXGTeeBoxProdListForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGTeeBoxProdListForm.V1CustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
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

procedure TXGTeeBoxProdListForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxProdListForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxProdListForm.V1DblClick(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TXGTeeBoxProdListForm.btnOKClick(Sender: TObject);
var
  sProdStartTime, sProdEndTime, sTeeBoxStartDateTime, sTeeBoxEndDateTime, sCurTime, sTeeBoxName: string;
  dTeeBoxStartDateTime, dTeeBoxEndDateTime, dProdStartDateTime, dProdEndDateTime: TDateTime;
  nTeeBoxNo, nAssignMin: Integer;
  bAccepted, bAllowedReserve: Boolean;
begin
  bAccepted := True;
  with ClientDM.MDProdTeeBoxFiltered do
  begin
    if (RecordCount = 0) then
      Exit;

    sCurTime := Copy(Global.FormattedCurrentTime, 1, 5); //hh:nn
    sProdStartTime := FieldByName('start_time').AsString;
    sProdEndtime := FieldByName('end_time').AsString;
    nAssignMin := FieldByName('one_use_time').AsInteger;
    if SaleManager.StoreInfo.IsNextDay(sCurTime) then
    begin
      if (sProdStartTime > sProdEndTime) then
        dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedLastDate, sProdStartTime]), Global.FS)
      else
        dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdStartTime]), Global.FS);

      dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdEndtime]), Global.FS);
    end
    else
    begin
      dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdStartTime]), Global.FS);
      if (sProdStartTime > sProdEndTime) then
        dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedNextDate, sProdEndtime]), Global.FS)
      else
        dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdEndtime]), Global.FS);
    end;
  end;

  with ClientDM.MDTeeBoxSelected do
  try
    DisableControls;
    First;
    while not Eof do
    begin
      nTeeBoxNo := FieldByName('teebox_no').AsInteger;
      sTeeBoxName := FieldByName('teebox_nm').AsString;

      if ClientDM.MDTeeBoxStatus2.Locate('teebox_no', nTeeBoxNo, []) then
      begin
        if Global.NoShowInfo.NoShowReserved then
        begin
          sTeeBoxStartDateTime := ClientDM.SPTeeBoxNoShowList.FieldByName('start_datetime').AsString;
          sTeeBoxEndDateTime := ClientDM.SPTeeBoxNoShowList.FieldByName('end_datetime').AsString;
        end
        else
        begin
          sTeeBoxStartDateTime := ClientDM.MDTeeBoxStatus2.FieldByName('start_datetime').AsString;
          sTeeBoxEndDateTime := ClientDM.MDTeeBoxStatus2.FieldByName('end_datetime').AsString;
        end;

        if sTeeBoxEndDateTime.IsEmpty then //빈 타석
        begin
          if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
             (dProdStartDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림',
              '영업시간 내에 사용할 수 없는 상품입니다!' + _CRLF +
              Format('[영업시간] %s ~ %s', [
                FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime),
                FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
              Format('[상품시간] %s ~ %s', [
                FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime),
                FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]),
              ['확인'], 5);
            bAccepted := False;
            Break;
          end;

          if (dProdStartDateTime > Now) or
             (dProdEndDateTime < Now) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림',
              '지금은 사용할 수 없는 상품입니다!' + _CRLF +
              Format('[상품시간] %s ~ %s', [
                FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime),
                FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]) + _CRLF +
              Format('[예약시각] %s', [Global.FormattedCurrentDateTime]),
              ['확인'], 5);
            bAccepted := False;
            Break;
          end;
        end else
        begin
          if Global.NoShowInfo.NoShowReserved then
          begin
            dTeeBoxStartDateTime := StrToDateTime(sTeeBoxStartDateTime, Global.FS);
            dTeeBoxEndDateTime := StrToDateTime(sTeeBoxEndDateTime, Global.FS);
          end
          else
          begin
            dTeeBoxEndDateTime := StrToDateTime(sTeeBoxEndDateTime, Global.FS);
            dTeeBoxStartDateTime := IncMinute(dTeeBoxEndDateTime, Global.PrepareMin);
            dTeeBoxEndDateTime := IncMinute(dTeeBoxStartDateTime, nAssignMin);
          end;

          if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 죵료시각 체크 여부
             ((dTeeBoxStartDateTime < SaleManager.StoreInfo.StoreStartDateTime) or
              (dTeeBoxStartDateTime > SaleManager.StoreInfo.StoreEndDateTime)) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림',
              '영업시간 내에 사용할 수 없는 상품입니다!' + _CRLF +
              Format('[영업시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
              Format('[예약시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
              ['확인'], 5);
            bAccepted := False;
            Break;
          end;

          (*
          if (dTeeBoxStartDateTime < dProdStartDateTime) or
             (dTeeBoxStartDateTime > dProdEndDateTime) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림',
              '사용할 수 없는 시간대의 상품입니다!' + _CRLF +
              Format('[상품시간] %s ~ %s', [
                FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime),
                FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]) + _CRLF +
              Format('[예약시간] %s ~ %s', [
                FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime),
                FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
              ['확인'], 5);
            bAccepted := False;
            Break;
          end;
          *)

          //주문시각 기준으로 타석상품 예약 허용 또는 불가 확인
          bAllowedReserve :=
            (Global.ReserveAllowedOnOrderTime and (dProdStartDateTime < Now) and (dProdEndDateTime > Now)) or
            ((Global.ReserveAllowedOnOrderTime = False) and (dProdStartDateTime < dTeeBoxStartDateTime) and (dProdEndDateTime > dTeeBoxStartDateTime));

          if not bAllowedReserve then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림',
              '사용할 수 없는 시간대의 상품입니다!' + _CRLF +
              '[주문시각 기준 타석예약 허용] ' + IIF(Global.ReserveAllowedOnOrderTime, '예', '아니오') + _CRLF +
              Format('[상품시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]) + _CRLF +
              Format('[예약시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
              ['확인'], 5);
            bAccepted := False;
            Break;
          end;
        end;
      end;

      Next;
    end;
  finally
    EnableControls;
  end;

  if bAccepted then
    ModalResult := mrOK;
end;

procedure TXGTeeBoxProdListForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGTeeBoxProdListForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGTeeBoxProdListForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGTeeBoxProdListForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxProdListForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.