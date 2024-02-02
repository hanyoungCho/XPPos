(* ******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 판매관리 - 테이블 관리
  Author      : 이선우
  Description :
  History     :
  Version   Date         Remark
  --------  ----------   -----------------------------------------------------
  1.0.0.0   2020-08-12   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

  ****************************************************************************** *)
unit uXGSalePosTable;

interface

uses
  {Native}
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls, DB,
  Menus, Graphics,
  {Plugin System}
  uPluginManager, uPluginModule, uPluginMessages,
  {Absolute Database}
  ABSMain,
  {TMS}
  AdvShapeButton,
  {SolbiVCL}
  WindowDesigner, cyBaseSpeedButton, cySpeedButton, cyAdvSpeedButton, LEDFontNum, DRLabel;

{$I ..\..\common\XGPOS.inc}

const
  LCN_TABLE_INTERVAL: Integer = 5;
  LCN_MAP_INTERVAL: Integer = 5;
  LCN_TABLE_WIDTH: Integer = 260;
  // LCN_TABLE_HEIGHT: Integer   = 344;
  LCN_MAP_WIDTH: Integer = 42;
  LCN_MAP_HEIGHT: Integer = 28;

  LCS_BUTTON_TYPE_TABLE = 'T';
  LCS_BUTTON_TYPE_MINIMAP = 'M';

type
  TXGSaleTableForm = class(TPluginModule)
    panHeader: TPanel;
    lblPluginVersion: TLabel;
    panHeaderTools: TPanel;
    btnHome: TAdvShapeButton;
    panBasePanel: TPanel;
    panRightMenu: TPanel;
    sbxTables: TScrollBox;
    btnSalePos: TcyAdvSpeedButton;
    panTableMap: TPanel;
    btnTableGroup: TcyAdvSpeedButton;
    btnTableClear: TcyAdvSpeedButton;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    WindowDesigner: TWindowDesigner;
    btnClose: TAdvShapeButton;
    panTableMapToolbar: TPanel;
    TemplateMapButton: TcySpeedButton;
    panScoreboard: TPanel;
    ledStoreEndTime: TLEDFontNum;
    Label15: TLabel;
    tmrClock: TTimer;
    lblGroupMode: TDRLabel;
    lbxGroupList: TListBox;
    btnResetTableMap: TcySpeedButton;
    btnEditTableMap: TcySpeedButton;
    btnSaveTableMap: TcySpeedButton;
    btnReceiptView: TcyAdvSpeedButton;
    btnPartnerCenter: TcyAdvSpeedButton;
    lblAlertMsg: TLabel;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrClockTimer(Sender: TObject);
    procedure sbxTablesMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnSalePosClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnResetTableMapClick(Sender: TObject);
    procedure btnEditTableMapClick(Sender: TObject);
    procedure btnSaveTableMapClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTableGroupClick(Sender: TObject);
    procedure btnTableClearClick(Sender: TObject);
    procedure btnReceiptViewClick(Sender: TObject);
    procedure btnPartnerCenterClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FBaseTitle: string;
    FTableWidth: Integer;
    FTableHeight: Integer;
    FTableColumns: Integer;
    FTableRows: Integer;
    FGroupMode: Boolean;
    FGroupColor: TColor;
    FSelectTableList: TStringList;
    FWorkingGroupNo: Integer;
    FMapEditMode: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure FirstTableClick;
    procedure CloseAction;
    procedure LoadTableMap;
    procedure ResetTableMap;
    procedure SaveTableMap;

    procedure OnTableMapButtonClick(Sender: TObject);
    procedure OnTableMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnTableDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnTableDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure OnGridDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnGridDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure RefreshTableInfo(const ATableIndex: Integer);
    procedure RefreshTableReceiveAmt(const ATableIndex: Integer);
    procedure RefreshGroupInfo;
    procedure RefreshTableSaleItemList(const ATableIndex: Integer);
    procedure MoveSaleTable(const ASourceTableNo, ATargetTableNo: Integer);
    procedure MoveSaleItem(const ASourceTableNo, ATargetTableNo: Integer; const ATargetDataSet: TDataSet; const AProdCode: string; const AOrderQty: Integer);
    procedure SelectTable(const ATableIndex: Integer; const ARefresh: Boolean=False);

    procedure AddTableToGroup(const ATableIndex: Integer);
    procedure DeleteTableFromGroup(const ATableIndex: Integer);

    procedure SetTableTitle;
    procedure SetGroupMode(const AGroupMode: Boolean);
    procedure SetMapEditMode(const AValue: Boolean);
    procedure SetAlertMsg(const AMsgText: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage = nil); override;
    destructor Destroy; override;

    procedure TableFocusedCallback(Sender: TObject);
    procedure TableMsgCallback(Sender: TObject; const AMsg: string);

    property GroupMode: Boolean read FGroupMode write SetGroupMode default False;
    property MapEditMode: Boolean read FMapEditMode write SetMapEditMode default False;
    property AlertMsg: string write SetAlertMsg;
  end;

implementation

uses
  {Native}
  System.Math,
  {DevExpress}
  cxControls, cxGridCustomView, cxGridDBBandedTableView,
  {Project}
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGSaleTableContainer;

{$R *.dfm}

function ListSortAsc(AList: TStringList; R1, R2: Integer): Integer;
begin
  if (AList.Strings[R1] > AList.Strings[R2]) then
    Result := 1
  else if (AList.Strings[R1] < AList.Strings[R2]) then
    Result := -1
  else
    Result := 0;
end;

function ListSortDesc(AList: TStringList; R1, R2: Integer): Integer;
begin
  if (AList.Strings[R1] > AList.Strings[R2]) then
    Result := -1
  else if (AList.Strings[R1] < AList.Strings[R2]) then
    Result := 1
  else
    Result := 0;
end;

{ TXGSaleTableForm }

constructor TXGSaleTableForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  nRow, nCol, nTop, nLeft, nBaseWidth: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;
{$IFDEF DEBUG}
  //디버그 모드일 경우 핫키 입력 받지 않음
  Self.KeyPreview := False;
{$ENDIF}
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
  panHeader.Caption := Global.TableInfo.UnitName + ' 관리';
  panHeader.Font.Color := STC_COLOR_FOCUSED;
  btnTableClear.Caption := Global.TableInfo.UnitName + ' ' + btnTableClear.Caption;

  FOwnerId := -1;
  FIsFirst := True;
  FBaseTitle := panHeader.Caption;
  FGroupMode := False;
  nTop := 0;
  nRow := 0;
  nCol := 0;
  FSelectTableList := TStringList.Create;

  nBaseWidth := (Global.ScreenInfo.BaseWidth - panRightMenu.Width) - 20;
  FTableColumns := (nBaseWidth div LCN_TABLE_WIDTH);
  FTableWidth := (nBaseWidth div FTableColumns);
  FTableHeight := ((Global.ScreenInfo.BaseHeight - panHeader.Height - lblAlertMsg.Height) div 2) - 7;
  FTableRows := (Global.TableInfo.Count div FTableColumns);
  if (FTableRows = 2) and ((Global.TableInfo.Count mod FTableColumns) > 0) then
  begin
    Dec(nBaseWidth, 7);
    FTableWidth := (nBaseWidth div FTableColumns);
  end;

  if (FTableWidth < LCN_TABLE_WIDTH) then
  begin
    Dec(FTableColumns);
    FTableWidth := (nBaseWidth div FTableColumns);
  end;

  for var I := 0 to Pred(Global.TableInfo.Count) do
  begin
    if (nCol > Pred(FTableColumns)) then
    begin
      nCol := 0;
      Inc(nRow);
    end;
    nTop := 5 + (nRow * FTableHeight) + (nRow * LCN_TABLE_INTERVAL);
    nLeft := 5 + (nCol * FTableWidth) + (nCol * LCN_TABLE_INTERVAL);

    Global.TableInfo.Items[I].Container := TXGSaleTableContainer.Create(nil);
    Global.TableInfo.Items[I].Container.Parent := sbxTables;
    Global.TableInfo.Items[I].Container.Width := FTableWidth;
    Global.TableInfo.Items[I].Container.Height := FTableHeight;
    Global.TableInfo.Items[I].Container.Top := nTop;
    Global.TableInfo.Items[I].Container.Left := nLeft;

    Global.TableInfo.Items[I].Container.ActiveColor := STC_COLOR_ACTIVE;
    Global.TableInfo.Items[I].Container.InActiveColor := STC_COLOR_INACTIVE;
    Global.TableInfo.Items[I].Container.FocusedColor := STC_COLOR_FOCUSED;

    Global.TableInfo.Items[I].Container.TableIndex := I;
    Global.TableInfo.Items[I].Container.TableNo := Global.TableInfo.Items[I].TableNo;
    Global.TableInfo.Items[I].Container.TableName := Global.TableInfo.Items[I].TableName;
    Global.TableInfo.Items[I].Container.ReceiveAmt := 0;

    Global.TableInfo.Items[I].Container.TableNoPanel.HelpKeyword := LCS_BUTTON_TYPE_TABLE;
    Global.TableInfo.Items[I].Container.TableNoPanel.OnMouseDown := OnTableMouseDown;
    Global.TableInfo.Items[I].Container.TableNoPanel.OnDragOver := OnTableDragOver;
    Global.TableInfo.Items[I].Container.TableNoPanel.OnDragDrop := OnTableDragDrop;

    Global.TableInfo.Items[I].Container.GridView.DragMode := dmAutomatic;
    Global.TableInfo.Items[I].Container.GridView.OnDragOver := OnGridDragOver;
    Global.TableInfo.Items[I].Container.GridView.OnDragDrop := OnGridDragDrop;

    Global.TableInfo.Items[I].MapButton := TcySpeedButton.Create(nil);
    with TcySpeedButton(Global.TableInfo.Items[I].MapButton) do
    begin
      Parent := panTableMap;
      Visible := False;
      OnClick := OnTableMapButtonClick;
      Transparent := False;
      Tag := I;
      HelpKeyword := LCS_BUTTON_TYPE_MINIMAP;
      Caption := IntToStr(Global.TableInfo.Items[I].TableNo);
      Degrade.FromColor := clWhite;
      Degrade.ToColor := STC_COLOR_INACTIVE;
      Degrade.Balance := 0;
    end;

    Global.TableInfo.Items[I].DataSet := TABSQuery.Create(nil);
    with TABSQuery(Global.TableInfo.Items[I].DataSet) do
    begin
      DatabaseName := ClientDM.adbLocal.DatabaseName;
      SQL.Add('SELECT A.product_cd, A.product_nm, A.order_qty, (A.product_amt * A.order_qty) AS calc_charge_amt');
      SQL.Add('FROM TBSaleItem A WHERE A.table_no = :table_no');
    end;
    Global.TableInfo.Items[I].Container.DataSource.DataSet := Global.TableInfo.Items[I].DataSet;
    RefreshTableInfo(I);
    RefreshTableSaleItemList(I);

    Global.TableInfo.Items[I].Container.TableFocusedCallbackProc := TableFocusedCallback;
    Global.TableInfo.Items[I].Container.TableFocused := (I = 0);
    Inc(nCol);
  end;

  LoadTableMap;
  RefreshGroupInfo;

  with TLabel.Create(nil) do
  begin
    Parent := sbxTables;
    Top := (nTop + FTableHeight);
    Left := 0;
    Height := 5;
    Caption := '';
  end;

  if (Global.TableInfo.Count > (FTableColumns * 2)) then
  begin
    panRightMenu.Width := (panRightMenu.Width - 18);
    btnResetTableMap.Width := btnResetTableMap.Width - 4;
    btnEditTableMap.Width := btnEditTableMap.Width - 4;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

destructor TXGSaleTableForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGSaleTableForm.PluginModuleClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FSelectTableList) then
    FreeAndNil(FSelectTableList);
  for var I := 0 to Pred(Global.TableInfo.Count) do
    Global.TableInfo.Items[I].MapButton.Free;

  Action := caFree;
end;

procedure TXGSaleTableForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
end;

procedure TXGSaleTableForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F9: btnTableGroup.Click;
    VK_F10: btnReceiptView.Click;
    VK_F11: btnPartnerCenter.Click;
    VK_F12: btnSalePos.Click;
  end;

  if GroupMode and
     (Key = VK_ESCAPE) then
    btnTableGroup.Click
  else
    inherited;
end;

procedure TXGSaleTableForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGSaleTableForm.ProcessMessages(AMsg: TPluginMessage);
var
  sValue: string;
  nIndex: Integer;
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_CLOSE) then
    CloseAction;

  if (AMsg.Command = CPC_SET_FOREGROUND) then
  begin
    SetTableTitle;
    RefreshTableSaleItemList(Global.TableInfo.ActiveTableIndex);
    sValue := AMsg.ParamByString(CPP_PRODUCT_CD);
    if not sValue.IsEmpty then
      Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].DataSet.Locate('product_cd', sValue, []);
    if (GetForegroundWindow <> Self.Handle) then
      SetForegroundWindow(Self.Handle);
  end;

  if (AMsg.Command = CPC_ACTIVE_TABLE) then
  begin
    SetTableTitle;
    RefreshTableSaleItemList(Global.TableInfo.ActiveTableIndex);
  end;

  if (AMsg.Command = CPC_REFRESH_GROUP_TABLE) then
    for var I := 0 to Pred(Global.TableInfo.ActiveGroupTableList.Count) do
    begin
      nIndex := Global.TableInfo.GetTableIndex(StrToIntDef(Global.TableInfo.ActiveGroupTableList[I], 0));
      if (nIndex >= 0) then
      begin
        RefreshTableInfo(nIndex);
        RefreshTableSaleItemList(nIndex);
      end;
    end;
end;

procedure TXGSaleTableForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    FTimeBlink := (not FTimeBlink);
    lblClockDate.Caption := Global.FormattedCurrentDate;
    lblClockWeekday.Caption := Format('(%s)', [Global.DayOfWeekKR]);
    lblClockHours.Caption := Copy(Global.CurrentTime, 1, 2);
    lblClockMins.Caption := Copy(Global.CurrentTime, 3, 2);
    lblClockSepa.Caption := IIF(FTimeBlink, '', ':');

    if FIsFirst then
    begin
      FIsFirst := False;
      Interval := 500;
      FirstTableClick; // 0번 테이블 강제 선택
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;

procedure TXGSaleTableForm.sbxTablesMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if (WheelDelta >= 0) then
    SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, SB_LINELEFT, 0)
  else
    SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, SB_LINERIGHT, 0);

  Handled := True;
end;

procedure TXGSaleTableForm.btnHomeClick(Sender: TObject);
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SET_FOREGROUND;
    PluginMessageToID(Global.StartModuleId);
  finally
    Free;
  end;
end;

procedure TXGSaleTableForm.btnSalePosClick(Sender: TObject);
var
  sProdCode: string;
begin
  sProdCode := '';
  with Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].DataSet do
  if (RecordCount > 0) then
    sProdCode := FieldByName('product_cd').AsString;

  ShowSalePos(Self.PluginID, sProdCode);
end;

procedure TXGSaleTableForm.btnReceiptViewClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('XGReceiptView' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGSaleTableForm.btnResetTableMapClick(Sender: TObject);
begin
  ResetTableMap;
end;

procedure TXGSaleTableForm.btnEditTableMapClick(Sender: TObject);
begin
  if MapEditMode then
    ResetTableMap;
  MapEditMode := (not MapEditMode);
end;

procedure TXGSaleTableForm.btnCloseClick(Sender: TObject);
begin
  CloseAction;
end;

procedure TXGSaleTableForm.btnSaveTableMapClick(Sender: TObject);
begin
  SaveTableMap;
  MapEditMode := False;
end;

procedure TXGSaleTableForm.btnPartnerCenterClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'main');
end;

procedure TXGSaleTableForm.btnTableClearClick(Sender: TObject);
begin
  try
    if (ClientDM.QRPayment.RecordCount > 0) then
      raise Exception.Create('결제 내역이 남아 있어 정리가 불가합니다!');
    if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
          Format('%s %s을(를) 정리하시겠습니까?',
            [Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].TableName, Global.TableInfo.UnitName]),
          ['예', '아니오']) <> mrOK) then
      Exit;

    ClientDM.ClearSaleTables(Global.TableInfo.ActiveTableNo);
    RefreshTableInfo(Global.TableInfo.ActiveTableIndex);
    RefreshTableSaleItemList(Global.TableInfo.ActiveTableIndex);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s을(를) 정리할 수 없습니다!', [Global.TableInfo.UnitName]) + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGSaleTableForm.btnTableGroupClick(Sender: TObject);
begin
  GroupMode := (not GroupMode);
end;

procedure TXGSaleTableForm.OnTableMapButtonClick(Sender: TObject);
begin
  SelectTable(TcySpeedButton(Sender).Tag, True);
end;

procedure TXGSaleTableForm.OnTableMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
    TPanel(Sender).BeginDrag(False);
end;

procedure TXGSaleTableForm.OnTableDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TPanel);
end;

procedure TXGSaleTableForm.OnTableDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  nSourceIndex, nTargetIndex: Integer;
begin
  AlertMsg := '';
  if (Source is TPanel) then
  begin
    nSourceIndex := TPanel(Source).Tag; // 현재 테이블의 인덱스
    nTargetIndex := TPanel(Sender).Tag; // 대상 테이블의 인덱스
    if (nSourceIndex = nTargetIndex) then
      Exit;

    try
      if (Global.TableInfo.Items[nSourceIndex].DataSet.RecordCount = 0) then
        raise Exception.Create('이동할 주문 내역이 없습니다!');

      if (Global.TableInfo.Items[nTargetIndex].DataSet.RecordCount > 0) then
      begin
        if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
              Format('[ %s → %s ]', [Global.TableInfo.Items[nSourceIndex].TableName, Global.TableInfo.Items[nTargetIndex].TableName]) + _CRLF +
              Format('이동하려는 %s %s에 주문 내역이 존재합니다!', [Global.TableInfo.Items[nTargetIndex].TableName, Global.TableInfo.UnitName]) + _CRLF +
              '주문 내역을 합치시겠습니까?', ['예', '아니오']) <> mrOK) then
          Exit;
      end
      else
      begin
        if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
              Format('[ %s → %s ]', [Global.TableInfo.Items[nSourceIndex].TableName, Global.TableInfo.Items[nTargetIndex].TableName]) + _CRLF +
              Format('%s %s을(를) %s %s로 이동하시겠습니까?',
                [Global.TableInfo.Items[nSourceIndex].TableName, Global.TableInfo.UnitName, Global.TableInfo.Items[nTargetIndex].TableName, Global.TableInfo.UnitName]),
              ['예', '아니오']) <> mrOK) then
          Exit;
      end;

      MoveSaleTable(nSourceIndex, nTargetIndex);
      SelectTable(nTargetIndex);
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtWarning, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGSaleTableForm.OnGridDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TcxDragControlObject) and ((Source as TcxDragControlObject).Control is TcxGridSite);
end;

procedure TXGSaleTableForm.OnGridDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AGridSite: TcxGridSite;
  // AGridView: TcxGridDBBandedTableView;
  ASourceDataSet, ATargetDataSet: TDataSet;
  nSourceIndex, nTargetIndex, nSourceTableNo, nTargetTableNo: Integer;
begin
  if (Source is TcxDragControlObject) and
    ((Source as TcxDragControlObject).Control is TcxGridSite) then
  begin
    AGridSite := (Source as TcxDragControlObject).Control as TcxGridSite;
    // AGridView := ASite.GridView as TcxGridDBBandedTableView;
    nSourceIndex := AGridSite.GridView.Tag; // 현재 테이블의 인덱스
    nTargetIndex := TcxGridSite(Sender).GridView.Tag; // 대상 테이블의 인덱스
    if (nSourceIndex = nTargetIndex) or
       (Global.TableInfo.Items[nSourceIndex].DataSet.RecordCount = 0) then
      Exit;

    nSourceTableNo := Global.TableInfo.Items[nSourceIndex].TableNo;
    nTargetTableNo := Global.TableInfo.Items[nTargetIndex].TableNo;
    ASourceDataSet := Global.TableInfo.Items[nSourceIndex].DataSet;
    ATargetDataSet := Global.TableInfo.Items[nTargetIndex].DataSet;

    if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
          Format('%s(%d) 상품을 이동하시겠습니까?' + _CRLF + '[ %s → %s ]', [
            ASourceDataSet.FieldByName('product_nm').AsString,
            ASourceDataSet.FieldByName('order_qty').AsInteger,
            Global.TableInfo.Items[nSourceIndex].TableName,
            Global.TableInfo.Items[nTargetIndex].TableName]),
          ['예', '아니오']) = mrOK) then
    try
      ASourceDataSet.DisableControls;
      ATargetDataSet.DisableControls;
      try
        if (Global.TableInfo.Items[nTargetIndex].DataSet.RecordCount = 0) then
          SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo; //20230330

        MoveSaleItem(nSourceTableNo, nTargetTableNo, ATargetDataSet, ASourceDataSet.FieldByName('product_cd').AsString, ASourceDataSet.FieldByName('order_qty').AsInteger);
      finally
        RefreshTableInfo(nSourceTableNo);
        RefreshTableSaleItemList(nSourceTableNo);
        if (ASourceDataSet.RecordCount = 0) then
        begin
          ExecuteABSQuery(Format('UPDATE TBPayment SET table_no = %d WHERE table_no = %d', [nTargetTableNo, nSourceTableNo]));
          ExecuteABSQuery(Format('UPDATE TBCoupon SET table_no = %d WHERE table_no = %d', [nTargetTableNo, nSourceTableNo]));
          ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE table_no = %d', [nSourceTableNo]));
          RefreshTableInfo(nSourceTableNo);
          RefreshTableReceiveAmt(nSourceTableNo);
        end;
        RefreshTableInfo(nTargetTableNo);
        RefreshTableSaleItemList(nTargetTableNo);
        ASourceDataSet.EnableControls;
        ATargetDataSet.EnableControls;
        SelectTable(nTargetIndex);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtWarning, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGSaleTableForm.FirstTableClick;
var
  PMousePos: TPoint;
begin
  GetCursorPos(PMousePos);
  try
    SetCursorPos(Self.Left + 100, Self.Top + panHeader.Height + 100);
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  finally
    SetCursorPos(PMousePos.X, PMousePos.Y);
  end;
end;

procedure TXGSaleTableForm.CloseAction;
begin
  if (XGMsgBox(Self.Handle, mtConfirmation, '프로그램 종료', '프로그램을 종료하시겠습니까?', ['예', '아니오']) <> mrOK) then
  begin
    Global.Closing := False;
    Exit;
  end;

  Global.Closing := True;
  SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
end;

procedure TXGSaleTableForm.LoadTableMap;
var
  nMapRow, nMapCol, nMapTop, nMapLeft: Integer;
  sIndex: string;
begin
  nMapRow := 0;
  nMapCol := 0;
  for var I := 0 to Pred(Global.TableInfo.Count) do
  begin
    sIndex := IntToStr(I);
    if (nMapCol > 3) then
    begin
      nMapCol := 0;
      Inc(nMapRow);
    end;

    nMapTop := 5 + (nMapRow * LCN_MAP_HEIGHT) + (nMapRow * LCN_MAP_INTERVAL);
    nMapLeft := 4 + (nMapCol * LCN_MAP_WIDTH) + (nMapCol * LCN_MAP_INTERVAL);
    with Global.ConfigTable, Global.TableInfo.Items[I].MapButton do
    begin
      Top := ReadInteger('Table' + sIndex, 'MapTop', nMapTop);
      Left := ReadInteger('Table' + sIndex, 'MapLeft', nMapLeft);
      Width := ReadInteger('Table' + sIndex, 'MapWidth', LCN_MAP_WIDTH);
      Height := ReadInteger('Table' + sIndex, 'MapHeight', LCN_MAP_HEIGHT);
      Visible := True;
    end;

    Inc(nMapCol);
  end;
end;

procedure TXGSaleTableForm.ResetTableMap;
var
  nMapRow, nMapCol, nMapTop, nMapLeft: Integer;
begin
  nMapRow := 0;
  nMapCol := 0;
  for var I := 0 to Pred(Global.TableInfo.Count) do
  begin
    if (nMapCol > 3) then
    begin
      nMapCol := 0;
      Inc(nMapRow);
    end;

    nMapTop := 5 + (nMapRow * LCN_MAP_HEIGHT) + (nMapRow * LCN_MAP_INTERVAL);
    nMapLeft := 4 + (nMapCol * LCN_MAP_WIDTH) + (nMapCol * LCN_MAP_INTERVAL);
    with Global.TableInfo.Items[I].MapButton do
    begin
      Top := nMapTop;
      Left := nMapLeft;
      Width := LCN_MAP_WIDTH;
      Height := LCN_MAP_HEIGHT;
    end;

    Inc(nMapCol);
  end;
end;

procedure TXGSaleTableForm.SaveTableMap;
var
  sTableIndex: string;
begin
  for var I := 0 to Pred(Global.TableInfo.Count) do
  begin
    sTableIndex := IntToStr(I);
    with Global.ConfigTable do
    begin
      WriteInteger('Table' + sTableIndex, 'MapTop', Global.TableInfo.Items[I].MapButton.Top);
      WriteInteger('Table' + sTableIndex, 'MapLeft', Global.TableInfo.Items[I].MapButton.Left);
      WriteInteger('Table' + sTableIndex, 'MapWidth', Global.TableInfo.Items[I].MapButton.Width);
      WriteInteger('Table' + sTableIndex, 'MapHeight', Global.TableInfo.Items[I].MapButton.Height);
      if Modified then
        UpdateFile;
    end;
  end;
end;

procedure TXGSaleTableForm.RefreshTableInfo(const ATableIndex: Integer);
var
  sEnterTime: string;
begin
  with TABSQuery.Create(nil) do
  try
    DatabaseName := ClientDM.adbLocal.DatabaseName;
    SQL.Text := Format('SELECT * FROM TBReceipt WHERE table_no = %d', [Global.TableInfo.Items[ATableIndex].TableNo]);
    Open;
    if (RecordCount = 0) then
    begin
      Global.TableInfo.Items[ATableIndex].Container.GuestCount := 0;
      Global.TableInfo.Items[ATableIndex].Container.GroupNo := 0;
      Global.TableInfo.Items[ATableIndex].Container.EnteredTime := 0
    end
    else
    begin
      Global.TableInfo.Items[ATableIndex].Container.GuestCount := FieldByName('table_guest_cnt').AsInteger;
      Global.TableInfo.Items[ATableIndex].Container.GroupNo := FieldByName('group_no').AsInteger;
      sEnterTime := FieldByName('table_come_tm').AsString;
      if sEnterTime.IsEmpty then
        Global.TableInfo.Items[ATableIndex].Container.EnteredTime := 0
      else
        Global.TableInfo.Items[ATableIndex].Container.EnteredTime := StrToDateTime(Global.FormattedCurrentDate + ' ' + FormattedTimeString(sEnterTime), Global.FS);
    end;
    RefreshTableReceiveAmt(ATableIndex);
  finally
    Close;
    Free;
  end;
end;

procedure TXGSaleTableForm.RefreshTableReceiveAmt(const ATableIndex: Integer);
var
  nReceiveAmt: Integer;
begin
  nReceiveAmt := 0;
  with TABSQuery.Create(nil) do
    try
      DatabaseName := ClientDM.adbLocal.DatabaseName;
      SQL.Text := Format('SELECT SUM(approve_amt) AS approve_amt FROM TBPayment WHERE table_no = %d', [Global.TableInfo.Items[ATableIndex].TableNo]);
      Open;
      if (RecordCount > 0) then
        nReceiveAmt := FieldByName('approve_amt').AsInteger;
      Global.TableInfo.Items[ATableIndex].Container.ReceiveAmt := nReceiveAmt;
    finally
      Close;
      Free;
    end;
end;

procedure TXGSaleTableForm.RefreshTableSaleItemList(const ATableIndex: Integer);
var
  BM: TBookmark;
begin
  with TABSQuery(Global.TableInfo.Items[ATableIndex].DataSet) do
  begin
    BM := GetBookmark;
    DisableControls;
    try
      Close;
      Params.ParamValues['table_no'] := Global.TableInfo.Items[ATableIndex].TableNo;
      Open;
      if (RecordCount = 0) then
        Global.TableInfo.Items[ATableIndex].Container.EnteredTime := 0
      else
      begin
        if (Global.TableInfo.Items[ATableIndex].EnteredTime = 0) then
          Global.TableInfo.Items[ATableIndex].Container.EnteredTime := Now;
      end;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      EnableControls;
      FreeBookmark(BM);
    end;
  end;
end;

procedure TXGSaleTableForm.MoveSaleItem(const ASourceTableNo, ATargetTableNo: Integer; const ATargetDataSet: TDataSet; const AProdCode: string; const AOrderQty: Integer);
begin
  if ATargetDataSet.Locate('product_cd', AProdCode, []) then
  begin
    ExecuteABSQuery(Format('UPDATE TBSaleItem SET order_qty = (order_qty + %d) WHERE table_no = %d AND product_cd = %s', [AOrderQty, ATargetTableNo, QuotedStr(AProdCode)]));
    ExecuteABSQuery(Format('DELETE FROM TBSaleItem WHERE table_no = %d AND product_cd = %s', [ASourceTableNo, QuotedStr(AProdCode)]));
  end
  else
    ExecuteABSQuery(Format('UPDATE TBSaleItem SET table_no = %d WHERE table_no = %d AND product_cd = %s', [ATargetTableNo, ASourceTableNo, QuotedStr(AProdCode)]));
end;

procedure TXGSaleTableForm.MoveSaleTable(const ASourceTableNo, ATargetTableNo: Integer);
var
  ASourceDataSet, ATargetDataSet: TDataSet;
  ASourceIndex, ATargetIndex: Integer;
begin
  ASourceIndex := Global.TableInfo.GetTableIndex(ASourceTableNo);
  ATargetIndex := Global.TableInfo.GetTableIndex(ATargetTableNo);
  ASourceDataSet := Global.TableInfo.Items[ASourceIndex].DataSet;
  ATargetDataSet := Global.TableInfo.Items[ATargetIndex].DataSet;
  ASourceDataSet.DisableControls;
  ATargetDataSet.DisableControls;
  try
    ASourceDataSet.First;
    while not ASourceDataSet.Eof do
    begin
      MoveSaleItem(ASourceTableNo, ATargetTableNo, ATargetDataSet, ASourceDataSet.FieldByName('product_cd').AsString, ASourceDataSet.FieldByName('order_qty').AsInteger);
      ASourceDataSet.Next;
    end;
    ExecuteABSQuery(Format('UPDATE TBPayment SET table_no = %d WHERE table_no = %d', [ATargetTableNo, ASourceTableNo]));
    ExecuteABSQuery(Format('UPDATE TBCoupon SET table_no = %d WHERE table_no = %d', [ATargetTableNo, ASourceTableNo]));
    ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE table_no = %d', [ASourceTableNo]));
  finally
    RefreshTableInfo(ASourceTableNo);
    RefreshTableInfo(ATargetTableNo);
    RefreshTableSaleItemList(ASourceTableNo);
    RefreshTableSaleItemList(ATargetTableNo);
    ASourceDataSet.EnableControls;
    ATargetDataSet.EnableControls;
  end;
end;

procedure TXGSaleTableForm.RefreshGroupInfo;
var
  AColor: TColor;
  nGroupNo: Integer;
begin
  with TABSQuery.Create(nil) do
  try
    DatabaseName := ClientDM.adbLocal.DatabaseName;
    SQL.Text := 'SELECT group_no FROM TBReceipt WHERE group_no > 0 GROUP BY group_no';
    Open;
    while not Eof do
    begin
      nGroupNo := FieldByName('group_no').AsInteger;
      Randomize;
      AColor := RGB(Random(255), Random(255), Random(255));
      for var J := 0 to Pred(Global.TableInfo.Count) do
        if (Global.TableInfo.Items[J].Container.GroupNo = nGroupNo) then
          Global.TableInfo.Items[J].Container.GroupColor := AColor;

      Next;
    end;
  finally
    Close;
    Free;
  end;
end;

procedure TXGSaleTableForm.AddTableToGroup(const ATableIndex: Integer);
begin
  if (ATableIndex > 0) and
     (Global.TableInfo.Items[ATableIndex].DataSet.RecordCount > 0) then
  try
    ExecuteABSQuery(Format('UPDATE TBReceipt SET group_no = %d WHERE table_no = %d', [FWorkingGroupNo, Global.TableInfo.Items[ATableIndex].TableNo]));
    FSelectTableList.AddObject(Format('[%.2d] %s', [Global.TableInfo.Items[ATableIndex].TableNo, Global.TableInfo.Items[ATableIndex].TableName]),
      TObject(Global.TableInfo.Items[ATableIndex].TableNo));
    FSelectTableList.CustomSort(ListSortAsc);
  finally
    lbxGroupList.Items.Assign(FSelectTableList);
    lbxGroupList.Visible := (FSelectTableList.Count > 0);
    Global.TableInfo.Items[ATableIndex].Container.GroupNo := FWorkingGroupNo;
  end;
end;

procedure TXGSaleTableForm.DeleteTableFromGroup(const ATableIndex: Integer);
begin
  if (ATableIndex > 0) then
  try
    for var I := 0 to Pred(FSelectTableList.Count) do
      if (Integer(FSelectTableList.Objects[I]) = Global.TableInfo.Items[ATableIndex].TableNo) then
      begin
        ExecuteABSQuery(Format('UPDATE TBReceipt SET group_no = 0 WHERE table_no = %d', [Global.TableInfo.Items[ATableIndex].TableNo]));
        Global.TableInfo.Items[ATableIndex].Container.GroupNo := 0;
        FSelectTableList.Delete(I);
      end;
  finally
    lbxGroupList.Items.Assign(FSelectTableList);
    lbxGroupList.Visible := (FSelectTableList.Count > 0);
  end;
end;

procedure TXGSaleTableForm.SelectTable(const ATableIndex: Integer; const ARefresh: Boolean);
var
  nRow: Integer;
begin
  with Global.TableInfo.Items[ATableIndex] do
  begin
    if ARefresh then
    begin
      nRow := (ATableIndex div FTableColumns);
      sbxTables.VertScrollBar.Position := (nRow * (FTableHeight + LCN_TABLE_INTERVAL));
    end;

    Global.TableInfo.ActiveTableNo := TableNo;
    Global.TableInfo.Items[ATableIndex].Container.SetFocus;
  end;
end;

procedure TXGSaleTableForm.SetTableTitle;
begin
  panHeader.Font.Color := STC_COLOR_FOCUSED;
  panHeader.Caption := Format('%s [%.2d] %s %s', [
    FBaseTitle,
    Global.TableInfo.ActiveTableNo,
    Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].TableName,
    IIF(Global.TableInfo.Items[Global.TableInfo.ActiveTableIndex].GroupNo > 0, '(단체)', '')]);
end;

procedure TXGSaleTableForm.SetGroupMode(const AGroupMode: Boolean);
var
  nTableNo, nIndex: Integer;
begin
  if (FGroupMode <> AGroupMode) then
  begin
    FGroupMode := AGroupMode;
    btnTableGroup.Caption := '단체 지정 ' + IIF(FGroupMode, '종료 ', '') + '(F9)';
    if FGroupMode then
    begin
      Randomize;
      FGroupColor := RGB(Random(255), Random(255), Random(255));
      AlertMsg := '단체 지정 또는 해제할 ' + Global.TableInfo.UnitName + '을(를) 선택한 후 종료(F9) 버튼을 누르십시오.';
      lblGroupMode.Blink := blBlink;
      lblGroupMode.Visible := True;
    end
    else
    begin
      AlertMsg := '';
      lblGroupMode.Blink := blNone;
      lblGroupMode.Visible := False;
      lbxGroupList.Visible := False;
      if (FSelectTableList.Count = 1) then
      begin
        nTableNo := Integer(FSelectTableList.Objects[0]);
        nIndex := Global.TableInfo.GetTableIndex(nTableNo);
        ExecuteABSQuery(Format('UPDATE TBReceipt SET group_no = 0 WHERE table_no = %d', [nTableNo]));
        Global.TableInfo.Items[nIndex].Container.GroupNo := 0;
      end;
      FSelectTableList.Clear;
      SelectTable(Global.TableInfo.ActiveTableIndex);
    end;

    btnTableClear.Enabled := (not FGroupMode);
    btnReceiptView.Enabled := (not FGroupMode);
    btnPartnerCenter.Enabled := (not FGroupMode);
    btnPartnerCenter.Enabled := (not FGroupMode);
    btnSalePos.Enabled := (not FGroupMode);
  end;
end;

procedure TXGSaleTableForm.SetMapEditMode(const AValue: Boolean);
begin
  if (FMapEditMode <> AValue) then
  begin
    FMapEditMode := AValue;
    btnResetTableMap.Enabled := FMapEditMode;
    btnSaveTableMap.Enabled := FMapEditMode;
    if FMapEditMode then
    begin
      btnEditTableMap.Caption := '취소';
      WindowDesigner.DesignerCtl := panTableMap;
      panTableMap.Color := $00CCFFFF;
    end
    else
    begin
      btnEditTableMap.Caption := '수정';
      WindowDesigner.DesignerCtl := nil;
      panTableMap.Color := $00F4F9EA;
      LoadTableMap;
    end;
  end;
end;

procedure TXGSaleTableForm.SetAlertMsg(const AMsgText: string);
begin
  lblAlertMsg.Caption := AMsgText;
end;

procedure TXGSaleTableForm.TableFocusedCallback(Sender: TObject);
begin
  with TXGSaleTableContainer(Sender) do
  begin
    if TableFocused then
    begin
      if GroupMode and
         (DataSource.DataSet.RecordCount > 0) and
         (Global.TableInfo.Items[TableIndex].TableNo > 0) then
      begin
        if (GroupNo = 0) then
        begin
          if (FSelectTableList.Count = 0) then
            FWorkingGroupNo := TableNo;
          AddTableToGroup(TableIndex);
          GroupNo := FWorkingGroupNo;
          GroupColor := FGroupColor;
        end
        else
        begin
          DeleteTableFromGroup(TableIndex);
          GroupNo := 0;
        end;
      end;

      Global.TableInfo.ActiveTableNo := Global.TableInfo.Items[TableIndex].TableNo;
      panHeader.Caption := Format('%s [%.2d] %s %s', [
        FBaseTitle,
        Global.TableInfo.Items[TableIndex].TableNo,
        Global.TableInfo.Items[TableIndex].TableName,
        IIF(Global.TableInfo.Items[TableIndex].GroupNo > 0, '(단체)', '')]);
      Global.TableInfo.Items[TableIndex].MapButton.Degrade.ToColor := STC_COLOR_FOCUSED;
    end
    else
      Global.TableInfo.Items[TableIndex].MapButton.Degrade.ToColor := IIF(DataSource.DataSet.RecordCount > 0, STC_COLOR_ACTIVE, STC_COLOR_INACTIVE);
  end;
end;

procedure TXGSaleTableForm.TableMsgCallback(Sender: TObject; const AMsg: string);
begin
  XGMsgBox(Self.Handle, mtInformation, '알림', AMsg, ['확인'], 5);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage = nil): TPluginModule;
begin
  Result := TXGSaleTableForm.Create(Application, AMsg);
end;

exports OpenPlugin;

end.
