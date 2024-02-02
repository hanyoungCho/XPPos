(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 라커 관리
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGLocker;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, AppEvnts,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels, cxScrollBox,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMemo, cxLabel, cxPC,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

const
  LCN_BASE_TOP        = 8;
  LCN_BASE_LEFT       = 1;
  LCN_BASE_HEIGHT     = 70;
  LCN_BASE_WIDTH      = 50;
  LCN_MAX_COLS        = 20;
  LCN_ROW_INTERVAL    = 76;

  { 라커 상태별 컬러 }
  LCN_LOCKER_EMPTY    = $0045D10E;  //0:빈 라커
  LCN_LOCKER_INUSE    = $00FF901E;  //1:이용중
  LCN_LOCKER_MATURITY = $00544ED6;  //3:만기
  LCN_LOCKER_DISABLED = $00777777;  //9:사용 불가

type
  TFloorInfo = class(TcxTabSheet)
    TabSheet: TcxTabSheet;
    ScrollBox: TcxScrollBox;
  private
    FRow: Integer;
    FCol: Integer;
    procedure OnScrollBoxMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure OnScrollBoxMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Row: Integer read FRow write FRow;
    property Col: Integer read FCol write FCol;
  end;

  TLockerPanel = class(TPanel)
    LockerNameLabel: TLabel;  //라커명
    FloorNameLabel: TLabel;   //층
    ZoneNameLabel: TLabel;    //상하 구분명
  private
    FActive: Boolean;
    FSelected: Boolean;
    FLockerNo: Integer;
    FFloorCode: string;
    FZoneCode: string;
    FUseDiv: Integer;
    FUseYN: Boolean;

    FMemberNo: string;
    FMemberName: string;
    FProductCode: string;
    FProductName: string;
    FTeeBoxProductName: string;
    FHpNo: string;
    FSaleDate: string;
    FStartDay: string;
    FEndDay: string;
    FPurchaseMonth: Integer;
    FPurchaseAmt: Integer;
    FKeepAmt: Integer;
    FDcAmt: Integer;
    FUserName: string;
    FMemo: string;

    procedure SetActive(const AValue: Boolean);
    procedure SetSelected(const AValue: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Selected: Boolean read FSelected write SetSelected default False;
    property LockerNo: Integer read FLockerNo write FLockerNo default 0;
    property FloorCode: string read FFloorCode write FFloorCode;
    property ZoneCode: string read FZoneCode write FZoneCode;
    property UseDiv: Integer read FUseDiv write FUseDiv;
    property UseYN: Boolean read FUseYN write FUseYN;
    property MemberNo: string read FMemberNo write FMemberNo;
    property MemberName: string read FMemberName write FMemberName;
    property ProductCode: string read FProductCode write FProductCode;
    property ProductName: string read FProductName write FProductName;
    property TeeBoxProductName: string read FTeeBoxProductName write FTeeBoxProductName;
    property HpNo: string read FHpNo write FHpNo;
    property SaleDate: string read FSaleDate write FSaleDate;
    property StartDay: string read FStartDay write FStartDay;
    property EndDay: string read FEndDay write FEndDay;
    property PurchaseMonth: Integer read FPurchaseMonth write FPurchaseMonth default 0;
    property PurchaseAmt: Integer read FPurchaseAmt write FPurchaseAmt default 0;
    property KeepAmt: Integer read FKeepAmt write FKeepAmt default 0;
    property DcAmt: Integer read FDcAmt write FDcAmt default 0;
    property UserName: string read FUserName write FUserName;
    property Memo: string read FMemo write FMemo;
  end;

  TXGLockerForm = class(TPluginModule)
    panHeader: TPanel;
    panFooter: TPanel;
    lblPluginVersion: TLabel;
    pgcLockers: TcxPageControl;
    panLockerInfo: TPanel;
    panLockerTitle: TPanel;
    lblLockerNameTitle: TLabel;
    lblLockerName: TcxLabel;
    lblMemberNameTitle: TLabel;
    lblMemberName: TcxLabel;
    lblHpNo: TcxLabel;
    lblHpNoTitle: TLabel;
    lblSaleDate: TcxLabel;
    lblSaleDateTitle: TLabel;
    lblStartDay: TcxLabel;
    lblStartDayTitle: TLabel;
    lblEndDay: TcxLabel;
    lblEndDayTitle: TLabel;
    lblKeepAmt: TcxLabel;
    lblKeepAmtTitle: TLabel;
    lblPurchaseAmt: TcxLabel;
    lblPurchaseAmtTitle: TLabel;
    lblDcAmt: TcxLabel;
    lblDcAmtTitle: TLabel;
    lblProductName: TcxLabel;
    lblProductNameTitle: TLabel;
    lblUserNameTitle: TLabel;
    lblUserName: TcxLabel;
    lblLockerStatusTitle: TLabel;
    lblLockerStatus: TcxLabel;
    panSelectLocker: TPanel;
    lblUseStartDayTitle: TLabel;
    btnPriorDay: TAdvShapeButton;
    btnUseStartDate: TAdvShapeButton;
    btnNextDay: TAdvShapeButton;
    btnSelectLocker: TcyAdvSpeedButton;
    panHeaderTools: TPanel;
    btnClose: TAdvShapeButton;
    panLockerLegend: TPanel;
    lblLegendEmpty: TLabel;
    lblLegendInuse: TLabel;
    lblLegendMaturity: TLabel;
    lblLegendDisabled: TLabel;
    lblTeeBoxProductName: TcxLabel;
    btnRefresh: TcyAdvSpeedButton;
    ApplicationEvents: TApplicationEvents;
    tmrRunOnce: TTimer;
    mmoMemo: TcxMemo;
    btnClearLocker: TcyAdvSpeedButton;
    TemplateLockerPanel: TPanel;
    TemplateFloorNameLabel: TLabel;
    TemplateLockerNameLabel: TLabel;
    TemplateZoneNameLabel: TLabel;
    lblMemberLockerInfo: TLabel;
    lblMemberNo: TcxLabel;
    lblMemberNoTitle: TLabel;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnSelectLockerClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnUseStartDateClick(Sender: TObject);
    procedure btnPriorDayClick(Sender: TObject);
    procedure btnNextDayClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure OnLockerPanelClick(Sender: TObject);
    procedure btnClearLockerClick(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure tmrRunOnceTimer(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FSelectMode: Boolean;
    FSelectZoneCode: string;
    FZoneCodeIgnore: Boolean;
    FSelectMemberNo: string;
    FMemberLockerInfo: string;
    FActiveLockerIndex: Integer;
    FUseStartDate: TDateTime;
    FFloorCount: Integer;
    FFloors: TArray<TFloorInfo>;
    FLockerCount: Integer;
    FLockers: TArray<TLockerPanel>;
    FColInterval: Integer;
    FZoneLabelList: TArray<TLabel>;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ClearLockerInfo;
    procedure ResetLockerPosition;
    procedure OpenLockerStatus;
    procedure SelectLocker(const ALockerIndex: Integer);
    function FindLockerWithMemberNo(const AMemberNo: string): Integer; //Locker Index
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, Variants, DateUtils, XQuery,
  uXGClientDM, uXGGlobal, uXGSaleManager, uXGCommonLib, uXGMsgBox, uXGCalendar;

 {$R *.dfm}

function GetIndexByLockerNo(const ALockerNo: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Length(Global.LockerInfo)) do
    if (Global.LockerInfo[I].LockerNo = ALockerNo) then
    begin
      Result := I;
      Break;
    end;
end;

{ TXGLockerForm }

constructor TXGLockerForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  nFloor, nIndex, nLockerNo, nColWidth: Integer;
  sFloor: string;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := -1;
  FUseStartDate := Now;
  FActiveLockerIndex := -1;
  FZoneCodeIgnore := False;
  FMemberLockerInfo := '';
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnUseStartDate.Text := FormatDateTime('yyyy-mm-dd', FUseStartDate);
  lblMemberLockerInfo.Caption := '';

  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;
  FColInterval := (pgcLockers.Width div LCN_MAX_COLS);
  nColWidth := (FColInterval - 5);

  FFloorCount := Length(Global.LockerFloorInfo);
  SetLength(FZoneLabelList, 0);
  SetLength(FFloors, FFloorCount);
  if (FFloorCount > 0) then
  begin
    for nFloor := 0 to Pred(FFloorCount) do
    begin
      sFloor := IntToStr(nFloor + 1);
      FFloors[nFloor] := TFloorInfo.Create(pgcLockers);
      FFloors[nFloor].TabSheet.Parent := pgcLockers;
      FFloors[nFloor].TabSheet.PageIndex := nFloor;
      FFloors[nFloor].TabSheet.Caption := '    ' + Global.LockerFloorInfo[nFloor].FloorName + '    ';
      FFloors[nFloor].TabSheet.HelpKeyword := Global.LockerFloorInfo[nFloor].FloorCode;
      FFloors[nFloor].TabSheet.Visible := True;
    end;
    pgcLockers.ActivePageIndex := Pred(FFloorCount);
    pgcLockers.ActivePageIndex := 0;
  end;

  FLockerCount := Length(Global.LockerInfo);
  SetLength(FLockers, FLockerCount);
  for nIndex := 0 to Pred(FLockerCount) do
  begin
    nFloor := Global.LockerInfo[nIndex].FloorIndex;
    nLockerNo := Global.LockerInfo[nIndex].LockerNo;

    FLockers[nIndex] := TLockerPanel.Create(nil);
    FLockers[nIndex].Width    := nColWidth;
    FLockers[nIndex].Height   := LCN_BASE_HEIGHT;
    FLockers[nIndex].LockerNo := nLockerNo;
    FLockers[nIndex].Parent   := FFloors[nFloor].ScrollBox;
    FLockers[nIndex].Tag      := nIndex;
    FLockers[nIndex].OnClick  := OnLockerPanelClick;
    FLockers[nIndex].Visible  := False;

    FLockers[nIndex].LockerNameLabel.Caption := Global.LockerInfo[nIndex].LockerName;
    FLockers[nIndex].LockerNameLabel.Color   := LCN_LOCKER_EMPTY;
    FLockers[nIndex].LockerNameLabel.Tag     := nIndex;
    FLockers[nIndex].LockerNameLabel.OnClick := OnLockerPanelClick;

    FLockers[nIndex].FloorNameLabel.Caption  := Global.LockerFloorInfo[nFloor].FloorName;
    FLockers[nIndex].FloorNameLabel.Tag      := nIndex;
    FLockers[nIndex].FloorNameLabel.OnClick  := OnLockerPanelClick;

    FLockers[nIndex].ZoneCode                := Global.LockerInfo[nIndex].ZoneCode;
    if      (FLockers[nIndex].ZoneCode = CLZ_LOCKER_TOP) then
      FLockers[nIndex].ZoneNameLabel.Caption := '상'
    else if (FLockers[nIndex].ZoneCode = CLZ_LOCKER_BOTTOM) then
      FLockers[nIndex].ZoneNameLabel.Caption := '하'
    else if (FLockers[nIndex].ZoneCode = CLZ_LOCKER_MID) then
      FLockers[nIndex].ZoneNameLabel.Caption := '중'
    else if (FLockers[nIndex].ZoneCode = CLZ_LOCKER_A) then
      FLockers[nIndex].ZoneNameLabel.Caption := 'A'
    else if (FLockers[nIndex].ZoneCode = CLZ_LOCKER_B) then
      FLockers[nIndex].ZoneNameLabel.Caption := 'B'
    else if (FLockers[nIndex].ZoneCode = CLZ_LOCKER_ALL) then
      FLockers[nIndex].ZoneNameLabel.Caption := '공통'
    else
      FLockers[nIndex].ZoneNameLabel.Caption := Global.LockerInfo[nIndex].ZoneCode;
    FLockers[nIndex].ZoneNameLabel.Tag       := nIndex;
    FLockers[nIndex].ZoneNameLabel.OnClick   := OnLockerPanelClick;

    if not Global.LockerInfo[nIndex].UseYN then
    begin
      FLockers[nIndex].Visible := False;
      Continue;
    end;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrRunOnce.Enabled := True;
end;

destructor TXGLockerForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGLockerForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  for I := 0 to Pred(FLockerCount) do
    FLockers[I].Free;

  Action := caFree;
end;

procedure TXGLockerForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGLockerForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId          := AMsg.ParamByInteger(CPP_OWNER_ID);
    FSelectMode       := AMsg.ParamByBoolean(CPP_LOCKER_SELECT);
    if FSelectMode then
    begin
      FSelectMemberNo   := AMsg.ParamByString(CPP_MEMBER_NO);
      FMemberLockerInfo := AMsg.ParamByString(CPP_LOCKER_INFO);
      FSelectZoneCode   := AMsg.ParamByString(CPP_ZONE_CODE);
      FZoneCodeIgnore   := (FSelectZoneCode = CZD_ZONE_ALL); //구역구분 코드 무시
    end;
    panSelectLocker.Visible := FSelectMode;
    panHeader.Caption := '라커 ' + IIF(FSelectMode, '선택', '상황 조회');
  end;
end;

procedure TXGLockerForm.ClearLockerInfo;
begin
  FActiveLockerIndex := -1;
  lblLockerName.Style.Color := $00FFFFFF;
  lblLockerName.Caption := '';
  lblLockerStatus.Caption := '';
  lblMemberName.Caption := '';
  lblMemberNo.Caption := '';
  lblProductName.Caption := '';
  lblTeeBoxProductName.Caption := '';
  lblHpNo.Caption := '';
  lblSaleDate.Caption := '';
  lblStartDay.Caption := '';
  lblEndDay.Caption := '';
  lblKeepAmt.Caption := '';
  lblPurchaseAmt.Caption := '';
  lblDcAmt.Caption := '';
  lblUserName.Caption := '';
  mmoMemo.Lines.Clear;
end;

procedure TXGLockerForm.OpenLockerStatus;
var
  nIndex, nLocker: Integer;
  sErrMsg: string;
begin
  ClearLockerInfo;
  if not ClientDM.GetLockerStatus(sErrMsg) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '라커 상태 정보를 가져올 수 없습니다!', ['확인'], 5);
    Exit;
  end;

  with TXQuery.Create(nil) do
  try
    try
      AddDataSet(ClientDM.MDLocker, 'L');
      AddDataSet(ClientDM.MDProdLocker, 'P');
      AddDataSet(ClientDM.MDLockerStatus, 'S');
      SQL.Text :=
        'SELECT L.locker_no, L.locker_nm, L.floor_cd, L.zone_cd, L.zone_nm, L.sex_div, L.use_yn, P.product_nm' +
        ', S.use_div, S.member_no, S.member_nm, S.hp_no, S.product_cd, S.sale_date, S.start_day, S.end_day' +
        ', S.purchase_month, S.purchase_amt, S.dc_amt, S.keep_amt, S.user_nm, S.memo, S.seat_product_nm' +
        ' FROM L' +
        ' LEFT OUTER JOIN S ON L.locker_no = S.locker_no' +
        ' LEFT OUTER JOIN P ON S.product_cd = P.product_cd' +
        ' ORDER BY L.locker_no;';
      Open;
      First;
      while not Eof do
      begin
        nLocker := FieldByName('locker_no').AsInteger;
        nIndex  := GetIndexByLockerNo(nLocker);
        with FLockers[nIndex] do
        begin
          MemberNo          := FieldByName('member_no').AsString;
          LockerNo          := FieldByName('locker_no').AsInteger;
          FloorCode         := FieldByName('floor_cd').AsString;
          ZoneCode          := FieldByName('zone_cd').AsString;
          UseDiv            := FieldByName('use_div').AsInteger;
          UseYN             := FieldByName('use_yn').AsBoolean;
          MemberName        := FieldByName('member_nm').AsString;
          ProductCode       := FieldByName('product_cd').AsString;
          ProductName       := FieldByName('product_nm').AsString;
          TeeBoxProductName := FieldByName('seat_product_nm').AsString;
          HpNo              := FieldByName('hp_no').AsString;
          SaleDate          := FieldByName('sale_date').AsString;
          if not SaleDate.IsEmpty then
            SaleDate := FormattedDateString(SaleDate);
          StartDay          := FieldByName('start_day').AsString;
          EndDay            := FieldByName('end_day').AsString;
          PurchaseMonth     := FieldByName('purchase_month').AsInteger;
          PurchaseAmt       := FieldByName('purchase_amt').AsInteger;
          KeepAmt           := FieldByName('keep_amt').AsInteger;
          DcAmt             := FieldByName('dc_amt').AsInteger;
          UserName          := FieldByName('user_nm').AsString;
          Memo              := FieldByName('memo').AsString;
          if FSelectMode then
            Active := UseYN and (FZoneCodeIgnore or (ZoneCode = FSelectZoneCode))
          else
            Active := UseYN;

          if Active then
            case UseDiv of
              CPS_LOCKER_EMPTY:
                LockerNameLabel.Color := LCN_LOCKER_EMPTY;
              CPS_LOCKER_INUSE:
                LockerNameLabel.Color := LCN_LOCKER_INUSE;
              CPS_LOCKER_MATURITY:
                LockerNameLabel.Color := LCN_LOCKER_MATURITY;
              CPS_LOCKER_DISABLED:
                LockerNameLabel.Color := LCN_LOCKER_DISABLED;
            else
              LockerNameLabel.Color := LCN_LOCKER_DISABLED;
            end
          else
            LockerNameLabel.Color := LCN_LOCKER_DISABLED;
        end;

        Next;
      end;
    except
      on E: Exception do
        UpdateLog(Global.LogFile, Format('OpenLockerStatus.Exception = %s', [E.Message]));
    end;
  finally
    Close;
    Free;
  end;
end;

procedure TXGLockerForm.ResetLockerPosition;
var
  nFloor, nZoneCount, nZoneIndex: Integer;
  sZoneCode, sZoneName: string;
begin
  for var I: Integer := 0 to Pred(Length(FZoneLabelList)) do
    FZoneLabelList[I].Free;
  for var I: Integer := 0 to Pred(FFloorCount) do
  begin
    FFloors[I].Row := 0;
    FFloors[I].Col := 0;
  end;

  nFloor := 0;
  nZoneCount := 0;
  nZoneIndex := 0;
  sZoneCode := '';
  sZoneName := '';
  SetLength(FZoneLabelList, nZoneCount);

  for var I: Integer := 0 to Pred(FLockerCount) do
  begin
    if (Global.LockerInfo[I].FloorIndex <> nFloor) then
    begin
      nFloor := Global.LockerInfo[I].FloorIndex;
      nZoneIndex := 0;
      sZoneCode := '';
    end;

    if (SaleManager.StoreInfo.LockerListOrder = CLO_FLOOR_ZONE_LOCKER) and
       (Global.LockerInfo[I].ZoneCode <> sZoneCode) then
    begin
      if (FFloors[nFloor].Col > 0) then
        FFloors[nFloor].Row := FFloors[nFloor].Row + 1;
      sZoneCode := Global.LockerInfo[I].ZoneCode;
      sZoneName := ClientDM.GetCodeItemName(CCG_LOCKER_ZONE, sZoneCode);
      Inc(nZoneCount);
      SetLength(FZoneLabelList, nZoneCount);
      FZoneLabelList[Pred(nZoneCount)] := TLabel.Create(nil);
      with FZoneLabelList[Pred(nZoneCount)] do
      begin
        Parent := FFloors[nFloor].ScrollBox;
        Align := alNone;
        Alignment := taLeftJustify;
        AlignWithMargins := False;
        AutoSize := True;
        Caption := Format('▶ %s %s', [Global.LockerFloorInfo[nFloor].FloorName, sZoneName]);
        Color := FFloors[nFloor].ScrollBox.Color;
        EllipsisPosition := epEndEllipsis;
        Font.Name := 'Noto Sans CJK KR Regular';
        Font.Size := 11;
        Font.Color := InvertColor2(FFloors[nFloor].ScrollBox.Color); //$00000000;
        Font.Style := [];
        Top := LCN_BASE_TOP + (FFloors[nFloor].Row * LCN_ROW_INTERVAL) + (nZoneIndex * 25);
        Left := 0;
        Height := 20;
        Width := 240;
        Layout := StdCtrls.tlCenter;
        ParentColor := False;
        ParentFont := False;
        Transparent := True;
      end;

      FFloors[nFloor].Col := 0;
      Inc(nZoneIndex);
    end;

    if (FFloors[nFloor].Col = LCN_MAX_COLS) then
    begin
      FFloors[nFloor].Row := FFloors[nFloor].Row + 1;
      FFloors[nFloor].Col := 0;
    end;
    FLockers[I].Top  := LCN_BASE_TOP + (FFloors[nFloor].Row * LCN_ROW_INTERVAL) + (nZoneIndex * 25);
    FLockers[I].Left := LCN_BASE_LEFT + (FFloors[nFloor].Col * FColInterval);
    if FSelectMode and (not FZoneCodeIgnore) and (FLockers[I].ZoneCode <> FSelectZoneCode) then
    begin
      FLockers[I].Visible := False;
      Continue;
    end;

    FLockers[I].Visible := True;
    FFloors[nFloor].Col := FFloors[nFloor].Col + 1;
  end;
end;

procedure TXGLockerForm.ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  Pt: TPoint;
  C: TWinControl;
begin
  if Msg.message = WM_MOUSEWHEEL then
  begin
    Pt.X := SmallInt(Msg.lParam);
    Pt.Y := SmallInt(Msg.lParam shr 16);
    C := FindVCLWindow(Pt);
    if C = nil then
      Handled := True
    else if C.Handle <> Msg.hwnd then
    begin
      Handled := True;
      SendMessage(C.Handle, WM_MOUSEWHEEL, Msg.wParam, Msg.lParam);
    end;
  end;
end;

procedure TXGLockerForm.tmrRunOnceTimer(Sender: TObject);
var
  nLocker: Integer;
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    OpenLockerStatus;
    ResetLockerPosition;

    if FSelectMode and
       (not FSelectMemberNo.IsEmpty) then
    begin
      lblMemberLockerInfo.Caption := FMemberLockerInfo;
      nLocker := FindLockerWithMemberNo(FSelectMemberNo);
      if (nLocker <> -1) then
      begin
        SelectLocker(nLocker);
        pgcLockers.ActivePageIndex := Global.LockerInfo[nLocker].FloorIndex;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TXGLockerForm.btnClearLockerClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if (FActiveLockerIndex < 0) or
     (XGMsgBox(Self.Handle, mtConfirmation, '확인',
        FLockers[FActiveLockerIndex].LockerNameLabel.Caption + ' 라커를 정리하시겠습니까?', ['예', '아니오']) <> mrOK) then
    Exit;

  try
    if not ClientDM.PostLockerClear(FLockers[FActiveLockerIndex].LockerNo, sErrMsg) then
      raise Exception.Create(sErrMsg);

    OpenLockerStatus;
    XGMsgBox(Self.Handle, mtInformation, '알림', '라커 정리가 완료되었습니다!', ['확인'], 5);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 라커를 정리하지 못했습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGLockerForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGLockerForm.btnNextDayClick(Sender: TObject);
begin
  FUseStartDate := (FUseStartDate + 1);
  btnUseStartDate.Text := FormatDateTime('yyyy-mm-dd', FUseStartDate);
end;

procedure TXGLockerForm.btnPriorDayClick(Sender: TObject);
begin
  FUseStartDate := (FUseStartDate - 1);
  btnUseStartDate.Text := FormatDateTime('yyyy-mm-dd', FUseStartDate);
end;

procedure TXGLockerForm.btnRefreshClick(Sender: TObject);
begin
  OpenLockerStatus;
end;

procedure TXGLockerForm.btnSelectLockerClick(Sender: TObject);
var
  bIsContinue: Boolean; //연장여부
begin
  if (FActiveLockerIndex < 0) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '선택한 라커가 없습니다!', ['확인'], 5);
    Exit;
  end;

  bIsContinue := (FLockers[FActiveLockerIndex].MemberNo = FSelectMemberNo) and
                 (FLockers[FActiveLockerIndex].UseDiv in [CPS_LOCKER_INUSE, CPS_LOCKER_MATURITY]);
  if FLockers[FActiveLockerIndex].Active and
     (FActiveLockerIndex >= 0) and
     (bIsContinue or (FLockers[FActiveLockerIndex].UseDiv = CPS_LOCKER_EMPTY)) then
  begin
    if bIsContinue then
    begin
      FUseStartDate := DateUtils.IncDay(StrToDateTime(Format('%s 12:00:00', [FLockers[FActiveLockerIndex].EndDay]), Global.FS));
      btnUseStartDate.Text := FormatDateTime('yyyy-mm-dd', FUseStartDate);
    end;

    with LockerRec do
    begin
      LockerNo     := FLockers[FActiveLockerIndex].LockerNo;
      LockerName   := FLockers[FActiveLockerIndex].LockerNameLabel.Caption;
      FloorCode    := FLockers[FActiveLockerIndex].FloorCode;
      UseStartDate := FormatDateTime('yyyymmdd', FUseStartDate);
      UseContinue  := bIsContinue;
    end;
    ModalResult := mrOK;
  end
  else
    XGMsgBox(Self.Handle, mtWarning, '알림',
      '선택한 라커는 이용이 불가한 라커입니다!' + _CRLF +
      '라커를 다시 선택하여 주십시오.', ['확인'], 5);
end;

procedure TXGLockerForm.btnUseStartDateClick(Sender: TObject);
begin
  with TXGCalendarForm.Create(nil) do
  try
    if (ShowModal = mrOk) then
    begin
      FUseStartDate := Date;
      TAdvShapeButton(Sender).Text := FormatDateTime('yyyy-mm-dd', FUseStartDate);
    end;
  finally
    Free;
  end;
end;

procedure TXGLockerForm.OnLockerPanelClick(Sender: TObject);
begin
  SelectLocker(TWinControl(Sender).Tag);
end;

procedure TXGLockerForm.SelectLocker(const ALockerIndex: Integer);
var
  I: Integer;
begin
  ClearLockerInfo;
  for I := 0 to Pred(FLockerCount) do
    FLockers[I].Selected := False;

  FActiveLockerIndex := ALockerIndex;
  with FLockers[FActiveLockerIndex] do
  begin
    Selected := True;
    lblLockerName.Caption := Format('%s %s (%s)', [FloorNameLabel.Caption, LockerNameLabel.Caption, ZoneNameLabel.Caption]);
    lblMemberName.Caption := MemberName;
    lblMemberNo.Caption := MemberNo;
    lblProductName.Caption := ProductName;
    lblTeeBoxProductName.Caption := TeeBoxProductName;
    lblHpNo.Caption := HpNo;
    lblSaleDate.Caption := SaleDate;
    lblStartDay.Caption := StartDay;
    lblEndDay.Caption := EndDay;
    lblKeepAmt.Caption := FormatCurr('#,##0', KeepAmt);
    lblPurchaseAmt.Caption := FormatCurr('#,##0', PurchaseAmt);
    lblDcAmt.Caption := FormatCurr('#,##0', DcAmt);
    lblUserName.Caption := UserName;
    mmoMemo.Lines.Text := Memo;
    btnClearLocker.Enabled := (UseDiv in [CPS_LOCKER_INUSE, CPS_LOCKER_MATURITY]);

    case UseDiv of
      CPS_LOCKER_EMPTY:
        begin
          lblLockerStatus.Caption := '이용가능';
          lblLockerName.Style.Color := LCN_LOCKER_EMPTY;
        end;
      CPS_LOCKER_INUSE:
        begin
          if (MemberNo = FSelectMemberNo) then
            lblLockerStatus.Caption := '본인이용(연장가능)'
          else
            lblLockerStatus.Caption := '이용중';

          lblLockerName.Style.Color := LCN_LOCKER_INUSE;
        end;
      CPS_LOCKER_MATURITY:
        begin
          lblLockerStatus.Caption := '만기';
          lblLockerName.Style.Color := LCN_LOCKER_MATURITY;
        end;
    else
      lblLockerStatus.Caption := '사용불가';
      lblLockerName.Style.Color := LCN_LOCKER_DISABLED;
    end;
  end;
end;

function TXGLockerForm.FindLockerWithMemberNo(const AMemberNo: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FLockerCount) do
    if FLockers[I].UseYN and
       (FLockers[I].MemberNo = AMemberNo) then
    begin
      Result := I;
      Break;
    end;
end;

{ TFloorInfo }

constructor TFloorInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  TabSheet := TcxTabSheet.Create(AOwner);
  ScrollBox := TcxScrollBox.Create(TabSheet);
  with ScrollBox do
  begin
    Parent := TabSheet;
    Align := alClient;
    BorderStyle := cxcbsNone;
    Color := $00FFDB99; //$00F4F9EA;
    OnMouseWheelDown := OnScrollBoxMouseWheelDown;
    OnMouseWheelUp := OnScrollBoxMouseWheelUp;
  end;
end;

destructor TFloorInfo.Destroy;
begin

  inherited;
end;

procedure TFloorInfo.OnScrollBoxMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  TcxScrollBox(Sender).VertScrollBar.Position := TcxScrollBox(Sender).VertScrollBar.Position + 100;
end;

procedure TFloorInfo.OnScrollBoxMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  TcxScrollBox(Sender).VertScrollBar.Position := TcxScrollBox(Sender).VertScrollBar.Position - 100;
end;

{ TLockerPanel }

constructor TLockerPanel.Create(AOwner: TComponent);
begin
  inherited;

  Self.AutoSize := False;
  Self.BevelOuter := bvNone;
  Self.Color := $00FFFFFF;
  Self.DoubleBuffered := True;
  Self.ParentColor := False;
  Self.ParentFont := False;

  LockerNameLabel := TLabel.Create(Self);
  with LockerNameLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := $00FFFFFF;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := $00FFFFFF;
    Font.Style := [fsBold];
    Height := 30;
    Layout := StdCtrls.tlCenter;
    ParentColor := False;
    ParentFont := False;
    Transparent := False;
  end;

  FloorNameLabel := TLabel.Create(Self);
  with FloorNameLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := $00FFFFFF;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := $00689E0E;
    Font.Style := [];
    Height := 20;
    Layout := StdCtrls.tlCenter;
    ParentColor := False;
    ParentFont := False;
    Transparent := False;
  end;

  ZoneNameLabel := TLabel.Create(Self);
  with ZoneNameLabel do
  begin
    Parent := Self;
    Align := alClient;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := $00FFFFFF;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := $003535C0;
    Font.Style := [];
    Height := 20;
    Layout := StdCtrls.tlCenter;
    ParentColor := False;
    ParentFont := False;
    Transparent := False;
  end;
end;

destructor TLockerPanel.Destroy;
begin
  LockerNameLabel.Free;
  FloorNameLabel.Free;
  ZoneNameLabel.Free;

  inherited;
end;

procedure TLockerPanel.SetActive(const AValue: Boolean);
begin
  FActive := AValue;
  Self.Enabled := FActive;
  FloorNameLabel.Enabled := FActive;
  ZoneNameLabel.Enabled := FActive;
end;

procedure TLockerPanel.SetSelected(const AValue: Boolean);
begin
  if (FSelected <> AValue) then
  begin
    FSelected := AValue;
    if FSelected then
    begin
      FloorNameLabel.Color := $00E2E2E2;
      ZoneNameLabel.Color  := $00E2E2E2;
    end
    else
    begin
      FloorNameLabel.Color := $00FFFFFF;
      ZoneNameLabel.Color  := $00FFFFFF;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGLockerForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
