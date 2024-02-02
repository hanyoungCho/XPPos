(*******************************************************************************

  Title       : 타석 배정 메인 화면
  Filename    : uXGTeeBoxView.pas
  Author      : 이선우
  Description :
    ...
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2016-10-25   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGTeeBoxViewER;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, Graphics, StdCtrls,
  ExtCtrls, Menus, DB, WinXCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxMemo, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxControls, cxEdit,
  cxContainer, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  cxDBData, cxLabel, cxTextEdit, cxClasses, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxCheckBox, cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView, cxGrid, cxButtons,
  cxGridDBTableView, cxMaskEdit, cxTrackBar, cxSpinEdit, dxScrollbarAnnotations,
  { TMS }
  AdvShapeButton, AdvMenus,
  { SolbiVCL}
  cyBaseSpeedButton, cyAdvSpeedButton, LEDFontNum;

{$I ..\..\common\XGPOS.inc}

const
  LCN_MAX_FLOORS      = 5;
  LCN_QUICK_OF_FLOOR  = 5;
  LCN_FLOOR_PANEL_HEIGHT = 118;
  LCN_TEEBOX_FONT_SIZE   = 9;

type
  TBlinkerThread = class(TThread)
  private
    FRunning: Boolean;
    FLastWorked: TDateTime;
    FInterval: Integer;
    FBlinked: Boolean;
  protected
    procedure Execute; override;
  published
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval default 500;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
  end;

  TTeeBoxFloor = record
    BasePanel: TPanel;
    FlooorNamePanel: TPanel;
  end;

  TTeeBoxPanel = class(TPanel)
    TeeBoxTitle: TPanel;
    MemberLabel: TcxLabel;
    VIPLabel: TcxLabel;
    LRLabel: TcxLabel;
    RemainMinLabel: TcxLabel;
    EndTimeLabel: TcxLabel;
    ReservedLabel: TcxLabel;
  private
    FTeeBoxNo: Integer;
    FTeeBoxIndex: Integer;
    FDeviceId: string;
    FTeeBoxName: string;
    FFloorCode: string;
    FFloorName: string;
    FMemberName: string;
    FMemberNo: string;
    FHpNo: string;

    FCarNo: string;
    FLockerNo: string;
    FSexDiv: Integer;
    FXGolfMember: Boolean;

    FRemainMin: Integer;
    FStartDateTime: TDateTime;
    FEndDateTime: TDateTime;
    FStartTime: string;
    FEndTime: string;
    FReservedCount: Integer;
    FMemo: string;
    FControlYN: Boolean; //Auto Tee-up 타석 여부: 자동(Y), 수동(N)
    FVipYN: Boolean;
    FUseYN: Boolean;
    FZoneCode: string;
    FCurStatus: Integer;
    FErrorCode: Integer;
    FOldStatus: Integer;
    FChecked: Boolean;
    FSelected: Boolean;

    procedure SetTeeBoxNo(const AValue: Integer);
    procedure SetDeviceId(const AValue: string);
    procedure SetTeeBoxName(const AValue: string);
    procedure SetFloorCode(const AValue: string);
    procedure SetRemainMin(const AValue: Integer);
    procedure SetEndTime(const AValue: string);
    procedure SetReservedCount(const AValue: Integer);
    procedure SetControlYN(const AValue: Boolean);
    procedure SetVipYN(const AValue: Boolean);
    procedure SetUseYN(const AValue: Boolean);
    procedure SetCurStatus(const AValue: Integer);
    procedure SetChecked(const AValue: Boolean);
    procedure SetSelected(const AValue: Boolean);
    procedure SetZoneCode(const AValue: string);
    procedure SetFontSizeAdjust(const AValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TeeBoxNo: Integer read FTeeBoxNo write SetTeeBoxNo;
    property TeeBoxIndex: Integer read FTeeBoxIndex write FTeeBoxIndex;
    property DeviceId: string read FDeviceId write SetDeviceId;
    property TeeBoxName: string read FTeeBoxName write SetTeeBoxName;
    property FloorCode: string read FFloorCode write SetFloorCode;
    property FloorName: string read FFloorName write FFloorName;

    property MemberName: string read FMemberName write FMemberName;
    property MemberNo: string read FMemberNo write FMemberNo;
    property HpNo: string read FHpNo write FHpNo;
    property CarNo: string read FCarNo write FCarNo;
    property LockerNo: string read FLockerNo write FLockerNo;
    property SexDiv: Integer read FSexDiv write FSexDiv;
    property XGolfMember: Boolean read FXGolfMember write FXGolfMember;

    property RemainMin: Integer read FRemainMin write SetRemainMin;
    property StartDateTime: TDateTime read FStartDateTime write FStartDateTime;
    property EndDateTime: TDateTime read FEndDateTime write FEndDateTime;
    property StartTime: string read FStartTime write FStartTime;
    property EndTime: string read FEndTime write SetEndTime;
    property ReservedCount: Integer read FReservedCount write SetReservedCount;
    property Memo: string read FMemo write FMemo;
    property ControlYN: Boolean read FControlYN write SetControlYN;
    property VipYN: Boolean read FVipYN write SetVipYN;
    property UseYN: Boolean read FUseYN write SetUseYN;
    property ZoneCode: string read FZoneCode write SetZoneCode;
    property CurStatus: Integer read FCurStatus write SetCurStatus;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
    property OldStatus: Integer read FOldStatus write FOldStatus;
    property Checked: Boolean read FChecked write SetChecked;
    property Selected: Boolean read FSelected write SetSelected;
    property FontSizeAdjust: Integer write SetFontSizeAdjust;
  end;

  TQuickPanel = class(TPanel)
    TitleLabel: TLabel;
    RemainMinLabel: TLabel;
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetQuickInfo(const ATitle: string; const ARemainMin: Integer);
    procedure Clear;
  end;

  TXGTeeBoxViewForm = class(TPluginModule)
    panHeader: TPanel;
    panTeeBoxFloor2: TPanel;
    panTeeBoxFloor3: TPanel;
    panTeeBoxFloor5: TPanel;
    panFloorName2: TPanel;
    panFloorName3: TPanel;
    panFloorName5: TPanel;
    panFooter: TPanel;
    panBody: TPanel;
    panTeeBox1: TPanel;
    _MemberLabel: TcxLabel;
    _RemainMinLabel: TcxLabel;
    _EndTimeLabel: TcxLabel;
    lblReservedCnt1: TcxLabel;
    _TeeBoxButton: TPanel;
    _LRLabel: TcxLabel;
    _VIPLabel: TcxLabel;
    btnTeeBoxChangeReserved: TcyAdvSpeedButton;
    btnTeeBoxPause: TcyAdvSpeedButton;
    btnTeeBoxStoppedAll: TcyAdvSpeedButton;
    btnTeeBoxCancelReserved: TcyAdvSpeedButton;
    btnTeeBoxMove: TcyAdvSpeedButton;
    btnTeeBoxReserve: TcyAdvSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    trbPrepareMin: TcxTrackBar;
    btnTeeBoxClearance: TcyAdvSpeedButton;
    Panel6: TPanel;
    edtPrepareMin: TcxSpinEdit;
    panBasePanel: TPanel;
    Panel9: TPanel;
    ledPlayingCount: TLEDFontNum;
    ledWaitingCount: TLEDFontNum;
    ledReadyCount: TLEDFontNum;
    tmrClock: TTimer;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    lblPOSInfo: TLabel;
    lblPluginVersion: TLabel;
    panReservedInfoContainer: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1calc_play_yn: TcxGridDBBandedColumn;
    V1reserve_root_div: TcxGridDBBandedColumn;
    V1calc_reserve_div: TcxGridDBBandedColumn;
    V1product_nm: TcxGridDBBandedColumn;
    V1floor_cd: TcxGridDBBandedColumn;
    V1teebox_nm: TcxGridDBBandedColumn;
    V1calc_reserve_time: TcxGridDBBandedColumn;
    V1start_time: TcxGridDBBandedColumn;
    V1end_time: TcxGridDBBandedColumn;
    V1prepare_min: TcxGridDBBandedColumn;
    V1assign_min: TcxGridDBBandedColumn;
    V1calc_remain_min: TcxGridDBBandedColumn;
    V1teebox_no: TcxGridDBBandedColumn;
    V1play_yn: TcxGridDBBandedColumn;
    V1receipt_no: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    panReservedTitle: TPanel;
    btnTeeBoxFilterClear: TcxButton;
    btnSaleTeeBoxHoldCancel: TcxButton;
    btnTeeBoxImmediateStart: TcxButton;
    Panel5: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    panTeeBoxQuickView: TPanel;
    TemplateTeeBoxQuickPanel: TPanel;
    TemplateTeeBoxQuickTitleLabel: TLabel;
    TemplateTeeBoxQuickRemainLabel: TLabel;
    Label15: TLabel;
    panTeeBoxFloor1: TPanel;
    panFloorName1: TPanel;
    panTeeBoxFloor4: TPanel;
    panFloorName4: TPanel;
    pmnTeeBoxView: TAdvPopupMenu;
    pmnReserveList: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    mnuTeeBoxReserve: TMenuItem;
    mnuTeeBoxMove: TMenuItem;
    mnuTeeBoxChangeReserved: TMenuItem;
    mnuTeeBoxCancelReserved: TMenuItem;
    mnuTeeBoxPause: TMenuItem;
    mnuTeeBoxStoppedAll: TMenuItem;
    lblTeeBoxQuickTitle: TLabel;
    panHeaderTools: TPanel;
    btnHome: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    panTeeBoxSelectedContainer: TPanel;
    Panel1: TPanel;
    panTeeBoxSelectedGrid: TPanel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    V2teebox_nm: TcxGridDBBandedColumn;
    V2vip_yn: TcxGridDBBandedColumn;
    L2: TcxGridLevel;
    Panel7: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    Panel8: TPanel;
    btnTeeBoxDeleteHold: TcyAdvSpeedButton;
    btnTeeBoxClearHold: TcyAdvSpeedButton;
    trbAssignMin: TcxTrackBar;
    Label7: TLabel;
    Label1: TLabel;
    edtAssignMin: TcxSpinEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    V1TeeBoxmember_nm: TcxGridDBBandedColumn;

    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCloseClick(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure btnTeeBoxReserveClick(Sender: TObject);
    procedure btnTeeBoxMoveClick(Sender: TObject);
    procedure btnTeeBoxCancelReservedClick(Sender: TObject);
    procedure btnTeeBoxStoppedAllClick(Sender: TObject);
    procedure btnTeeBoxPauseClick(Sender: TObject);
    procedure btnTeeBoxChangeReservedClick(Sender: TObject);
    procedure OnGridCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure GridCustomDrawFooterCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure GridCustomDrawPartBackground(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridCellViewInfo; var ADone: Boolean);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTeeBoxFilterClearClick(Sender: TObject);
    procedure trbPrepareMinPropertiesChange(Sender: TObject);
    procedure edtPrepareMinPropertiesChange(Sender: TObject);
    procedure btnTeeBoxClearanceClick(Sender: TObject);
    procedure PluginModuleShow(Sender: TObject);
    procedure btnSaleTeeBoxHoldCancelClick(Sender: TObject);
    procedure btnTeeBoxImmediateStartClick(Sender: TObject);
    procedure pmnReserveListPopup(Sender: TObject);
    procedure pmnReserveListClose(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure btnTeeBoxDeleteHoldClick(Sender: TObject);
    procedure btnTeeBoxClearHoldClick(Sender: TObject);
    procedure edtAssignMinPropertiesChange(Sender: TObject);
    procedure trbAssignMinPropertiesChange(Sender: TObject);
    procedure pmnTeeBoxViewPopup(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIsFirst: Boolean;
    FTimeBlink: Boolean;
    FTeeBoxFloors: TArray<TTeeBoxFloor>;
    FQuickPanels: TArray<TQuickPanel>;
    FCurrentTeeBoxIndex: Integer;
    FStoppedAll: Boolean;
    FCheckedStoppedAll: Boolean;
    FFloorCount: Integer;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure CloseAction(const AEmergencyChanged: Boolean=False);
    procedure RefreshTeeBoxLayout;
    procedure RefreshTeeBoxStatus;
    function IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
    function CheckSelectedTeeBox(const ATitle: string): Boolean;
    procedure ClearTeeBoxSelection(const AUpdateToServer, AClearAll: Boolean);
    procedure SetCurrentTeeBoxIndex(const AIndex: Integer);
    procedure SetStoppedAll(const AStopped: Boolean);
    procedure DoTeeBoxReserve;
    procedure DoTeeBoxMove;
    procedure DoTeeBoxChangeReserved;
    procedure DoTeeBoxCancelReserved;
    procedure DoTeeBoxPause;
    procedure DoTeeBoxClearance;
    procedure DoTeeBoxStoppedAll;
    procedure DoTeeBoxClearHold;
    function DoTeeBoxHoldByIndex(const AUseHold: Boolean; const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;
    procedure DoTeeBoxFilter;
    function GetTeeBoxPanel(const ATeeBoxIndex: Integer): TTeeBoxPanel;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    procedure SelectTeeBoxByIndex(const AIndex: Integer);
    procedure OnTeeBoxHeaderClick(Sender: TObject);
    procedure OnTeeBoxBodyClick(Sender: TObject);
    procedure OnTeeBoxHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnTeeBoxHeaderDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnTeeBoxHeaderDragDrop(Sender, Source: TObject; X, Y: Integer);

    property CurrentTeeBoxIndex: Integer read FCurrentTeeBoxIndex write SetCurrentTeeBoxIndex;
    property StoppedAll: Boolean read FStoppedAll write SetStoppedAll;
    property TeeBoxPanels[const ATeeBoxIndex: Integer]: TTeeBoxPanel read GetTeeBoxPanel;
  end;
var
  XGTeeBoxViewForm: TXGTeeBoxViewForm;

implementation

uses
  { Native }
  Variants, DateUtils,
  { DevExpress }
  dxCore, cxGridCommon,
  { SolbiLib }
  XQuery,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGMemberPopup,
  uXGTeeBoxEmergencyReserve, uXGTeeBoxMoveDragDrop;

var
  FTeeBoxPanels: TArray<TTeeBoxPanel>;
  FBlinkerThread: TBlinkerThread;
  FTeeBoxCount: Integer;

{$R *.dfm}

{ TTeeBoxForm }

constructor TXGTeeBoxViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I, nIndex, nRow, nStart, nEnd, nQuick, nLeft: Integer;
  nRequireWidth, nRangeWidth, nTeeBoxWidth, nTitleWidth, nButtonWidth: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FIsFirst := True;
  FCurrentTeeBoxIndex := -1;

  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';
  btnTeeBoxImmediateStart.Visible := Global.ImmediateTeeBoxAssign;
  edtPrepareMin.Value := Global.PrepareMin;
  trbPrepareMin.Position := Global.PrepareMin;
  panTeeBoxQuickView.Visible := Global.TeeBoxQuickView;

  nButtonWidth := ((Global.ScreenInfo.BaseWidth - 10) div 7) - 5;
  //btnTeeBoxAssign.Width := nButtonWidth;
  btnTeeBoxCancelReserved.Width := nButtonWidth;
  btnTeeBoxMove.Width := nButtonWidth;
  btnTeeBoxChangeReserved.Width := nButtonWidth;
  btnTeeBoxPause.Width := nButtonWidth;
  btnTeeBoxClearance.Width := nButtonWidth;
  btnTeeBoxStoppedAll.Width := nButtonWidth;

  SaleManager.MemberInfo.Clear;
  FTeeBoxCount := 0;
  FFloorCount := Length(Global.TeeBoxFloorInfo);
  SetLength(FTeeBoxFloors, FFloorCount);

  nRequireWidth := (panFloorName1.Width + panTeeBoxFloor1.Margins.Left + panTeeBoxFloor1.Margins.Right);
  nRangeWidth := (Global.ScreenInfo.BaseWidth - nRequireWidth);
  nTeeBoxWidth := (nRangeWidth div Global.TeeBoxMaxCountOfFloors);
  nTitleWidth := panFloorName1.Width + (nRangeWidth - (nTeeBoxWidth * Global.TeeBoxMaxCountOfFloors));

  //층별 객체 생성
  for nRow := 0 to Pred(FFloorCount) do
    with FTeeBoxFloors[nRow] do
    begin
      BasePanel := TPanel(FindComponent('panTeeBoxFloor' + IntToStr(nRow + 1)));
      BasePanel.Height := LCN_FLOOR_PANEL_HEIGHT;
      FlooorNamePanel := TPanel(FindComponent('panFloorName' + IntToStr(nRow + 1)));
      FlooorNamePanel.Margins.Right := 2;
      FlooorNamePanel.Width := nTitleWidth - 2;
      FlooorNamePanel.Hint := IntToStr(FlooorNamePanel.Width);
      FlooorNamePanel.ShowHint := True;
      FlooorNamePanel.Caption := Global.TeeBoxFloorInfo[nRow].FloorName;
      FTeeBoxCount := FTeeBoxCount + Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
    end;

  //사용하지 않는 층 패널 숨기기
  for nRow := 1 to LCN_MAX_FLOORS do
    if (nRow > FFloorCount) then
      TPanel(FindComponent('panTeeBoxFloor' + IntToStr(nRow))).Visible := False;

  //타석별 객체 생성
  nStart := 0;
  nQuick := 0;
  SetLength(FQuickPanels, LCN_QUICK_OF_FLOOR * FFloorCount);
  SetLength(FTeeBoxPanels, FTeeBoxCount);
  for nRow := 0 to Pred(FFloorCount) do
  begin
    nEnd := Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount) + nStart;
    for nIndex := nStart to nEnd do
    begin
      FTeeBoxPanels[nIndex] := TTeeBoxPanel.Create(Self);
      with FTeeBoxPanels[nIndex] do
      begin
        TeeBoxIndex := nIndex;
        Tag := nIndex;
        PopupMenu := pmnTeeBoxView;
        OnClick := OnTeeBoxBodyClick;
        Parent := FTeeBoxFloors[nRow].BasePanel;
        BevelKind := TBevelKind(bkNone);
        BevelOuter := bvNone;
        Left := nTeeBoxWidth;
        Height := 126;
        Width := nTeeBoxWidth - 1;
        Align := alLeft;

        TeeBoxTitle.Tag := nIndex;
        TeeBoxTitle.OnClick := OnTeeBoxHeaderClick;
        TeeBoxTitle.OnMouseDown := OnTeeBoxHeaderMouseDown;
        TeeBoxTitle.OnDragOver := OnTeeBoxHeaderDragOver;
        TeeBoxTitle.OnDragDrop := OnTeeBoxHeaderDragDrop;

        VIPLabel.Tag := nIndex;
        VIPLabel.OnClick := OnTeeBoxHeaderClick;
        VIPLabel.Visible := False;

        LRLabel.Tag := nIndex;
        LRLabel.OnClick := OnTeeBoxHeaderClick;
        LRLabel.Visible := False;

        MemberLabel.Tag := nIndex;
        MemberLabel.OnClick := OnTeeBoxBodyClick;

        RemainMinLabel.Tag := nIndex;
        RemainMinLabel.OnClick := OnTeeBoxBodyClick;

        EndTimeLabel.Tag := nIndex;
        EndTimeLabel.OnClick := OnTeeBoxBodyClick;

        ReservedLabel.Tag := nIndex;
        ReservedLabel.OnClick := OnTeeBoxBodyClick;
      end;
    end;
    nStart := nStart + Global.TeeBoxFloorInfo[nRow].TeeBoxCount;

    if (nRow < LCN_MAX_FLOORS) then
    begin
      nLeft := 0;
      for I := 0 to Pred(LCN_QUICK_OF_FLOOR) do
      begin
        FQuickPanels[nQuick] := TQuickPanel.Create(Self);
        FQuickPanels[nQuick].Visible := Global.TeeBoxQuickView;
        FQuickPanels[nQuick].Parent := panTeeBoxQuickView;
        FQuickPanels[nQuick].Align := alLeft;
        FQuickPanels[nQuick].Left := nLeft; //panTeeBoxQuickView.Width;
        FQuickPanels[nQuick].TitleLabel.Caption := IntToStr(nQuick + 1);
        if (nRow mod 2 <> 0) then
          FQuickPanels[nQuick].TitleLabel.Font.Color := clYellow;

        nLeft := FQuickPanels[nQuick].Left + FQuickPanels[nQuick].Width;
        Inc(nQuick);
      end;
    end;
  end;

  //팝업 메뉴
  mnuTeeBoxReserve.OnClick := btnTeeBoxReserveClick;
  mnuTeeBoxMove.OnClick := btnTeeBoxMoveClick;
  mnuTeeBoxChangeReserved.OnClick := btnTeeBoxChangeReservedClick;
  mnuTeeBoxCancelReserved.OnClick := btnTeeBoxCancelReservedClick;
  mnuTeeBoxPause.OnClick := btnTeeBoxPauseClick;
  mnuTeeBoxStoppedAll.OnClick := btnTeeBoxStoppedAllClick;

  RefreshTeeBoxLayout;
  RefreshTeeBoxStatus;

  //선택 타석 복구
  ClientDM.ImportMemData(ClientDM.MDTeeBoxSelected);
  with ClientDM.MDTeeBoxSelected do
  begin
    Last;
    while not Bof do
    begin
      FTeeBoxPanels[FieldByName('teebox_index').AsInteger].Selected := True;
      First;
    end;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  if not Assigned(FBlinkerThread) then
  begin
    FBlinkerThread := TBlinkerThread.Create;
    FBlinkerThread.FreeOnTerminate := True;
    if not FBlinkerThread.Started then
      FBlinkerThread.Start;
  end;

  //긴급배정 이력 테이블
  ClientDM.TBEmergency.Active := True;

  //회원정보 초기화
  SaleManager.MemberInfo.Clear;

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

destructor TXGTeeBoxViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxViewForm.PluginModuleActivate(Sender: TObject);
begin
  panFooter.SetFocus;
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
  Global.DeviceConfig.RFIDReader.OwnerId := Self.PluginID;
end;

procedure TXGTeeBoxViewForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := 0;
  Global.DeviceConfig.RFIDReader.OwnerId := 0;
end;

procedure TXGTeeBoxViewForm.PluginModuleShow(Sender: TObject);
var
  I, nCount, nWidth: Integer;
begin
  btnV1PageUp.Height := (G1.Height div 4);
  btnV1Up.Height := btnV1PageUp.Height;
  btnV1Down.Height := btnV1PageUp.Height;
  btnV2Up.Height := (G2.Height div 2);

  if Global.TeeBoxQuickView then
  begin
    nCount := (LCN_QUICK_OF_FLOOR * FFloorCount);
    nWidth := (panTeeBoxQuickView.Width - lblTeeBoxQuickTitle.Width) div nCount;
    for I := Pred(nCount) downto 0 do
    begin
      FQuickPanels[I].Left := 0;
      FQuickPanels[I].Align := TAlign.alRight;
      FQuickPanels[I].Width := (nWidth - (FQuickPanels[I].Margins.Left + FQuickPanels[I].Margins.Right));
    end;
    lblTeeBoxQuickTitle.Align := TAlign.alClient;
  end;
end;

procedure TXGTeeBoxViewForm.pmnReserveListClose(Sender: TObject);
begin
  Global.TeeBoxStatusWorking := False;
  ClientDM.MDTeeBoxReserved2.EnableControls;
end;

procedure TXGTeeBoxViewForm.pmnReserveListPopup(Sender: TObject);
begin
  Global.TeeBoxStatusWorking := True;
  ClientDM.MDTeeBoxReserved2.DisableControls;
end;

procedure TXGTeeBoxViewForm.pmnTeeBoxViewPopup(Sender: TObject);
begin
  SelectTeeBoxByIndex(TAdvPopupMenu(Sender).PopupComponent.Tag);
end;

procedure TXGTeeBoxViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FBlinkerThread) then
    FBlinkerThread.Terminate;

  Action := caFree;
end;

procedure TXGTeeBoxViewForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
  if (Global.AdminCallHandle <> 0) then
    SendMessage(Global.AdminCallHandle, WM_CLOSE, 0, 0);
end;

procedure TXGTeeBoxViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not ((ssAlt in Shift) or
          (ssCtrl in Shift) or
          (ssShift in Shift)) then
  begin
    case Key of
      VK_F1:
        //DoTeeBoxReserve;
        btnTeeBoxReserve.Click;
      VK_F8:
        //DoTeeBoxCancelReserved;
        btnTeeBoxCancelReserved.Click;
      VK_F9:
        //DoTeeBoxMove;
        btnTeeBoxMove.Click;
      VK_F10:
        //DoTeeBoxChangeReserved;
        btnTeeBoxChangeReserved.Click;
      VK_F11:
        //DoTeeBoxPause;
        btnTeeBoxPause.Click;
      VK_ESCAPE:
        //DoTeeBoxClearHold;
        btnTeeBoxClearHold.Click;
    end;
  end;
end;

procedure TXGTeeBoxViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxViewForm.ProcessMessages(AMsg: TPluginMessage);
var
  I, nValue: Integer;
begin
  try
    if (AMsg.Command = CPC_INIT) then
    begin
      FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
      lblPOSInfo.Caption := Format('%s / 긴급배정  |', [SaleManager.StoreInfo.StoreCode]);
    end;

    if (AMsg.Command = CPC_CLOSE) then
      CloseAction;

    if (AMsg.Command = CPC_TEEBOX_EMERGENCY) and
       (not AMsg.ParamByBoolean(CPP_ACTIVE)) then
      CloseAction(True);

    if (AMsg.Command = CPC_SET_FOREGROUND) then
    begin
      if (GetForegroundWindow <> Self.Handle) then
        SetForegroundWindow(Self.Handle);
    end;

    if (AMsg.Command = CPC_TEEBOX_LAYOUT) then
      RefreshTeeBoxLayout;

    if (AMsg.Command = CPC_TEEBOX_STATUS) then
      RefreshTeeBoxStatus;

    if (AMsg.Command = CPC_CLEAR_SALE) then
      ClearTeeBoxSelection(False, True);

    if (AMsg.Command = CPC_CLEAR_TEEBOX_SELECTED) then
      ClearTeeBoxSelection(True, True);

    if (AMsg.Command = CPC_TEEBOX_HOLD) then
    begin
      nValue := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
      FTeeBoxPanels[nValue].CurStatus := CTS_TEEBOX_HOLD;
    end;

    if (AMsg.Command = CPC_TEEBOX_HOLD_CANCEL) then
    begin
      nValue := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
      FTeeBoxPanels[nValue].CurStatus := FTeeBoxPanels[nValue].OldStatus;
    end;

    if (AMsg.Command = CPC_TEEBOX_COUNTER) then
    begin
      ledReadyCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_READY_COUNT));
      ledPlayingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_PLAYING_COUNT));
      ledWaitingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_WAITING_COUNT));
    end;

    if (AMsg.Command = CPC_APPLY_CONFIG) then
    begin
      nValue := AMsg.ParamByInteger(CPP_FONT_SIZE_ADJUST);
      for I := 0 to Pred(FTeeBoxCount) do
        FTeeBoxPanels[I].FontSizeAdjust := nValue;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.SetCurrentTeeBoxIndex(const AIndex: Integer);
begin
  FCurrentTeeBoxIndex := AIndex;
end;

procedure TXGTeeBoxViewForm.tmrClockTimer(Sender: TObject);
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
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;

procedure TXGTeeBoxViewForm.trbAssignMinPropertiesChange(Sender: TObject);
begin
  edtAssignMin.Value := TcxTrackBar(Sender).Position;
end;

procedure TXGTeeBoxViewForm.trbPrepareMinPropertiesChange(Sender: TObject);
var
  nMin: Integer;
begin
  nMin := TcxTrackBar(Sender).Position;
  if (Global.PrepareMin <> nMin) then
  begin
    Global.PrepareMin := nMin;
    Global.ConfigLocal.WriteInteger('Config', 'PrepareMin', nMin);
    edtPrepareMin.Value := Global.PrepareMin;
  end;
end;

procedure TXGTeeBoxViewForm.edtAssignMinPropertiesChange(Sender: TObject);
begin
  trbAssignMin.Position := Integer(TcxSpinEdit(Sender).Value);
end;

procedure TXGTeeBoxViewForm.edtPrepareMinPropertiesChange(Sender: TObject);
var
  nMin: Integer;
begin
  nMin := Integer(TcxSpinEdit(Sender).Value);
  if (Global.PrepareMin <> nMin) then
  begin
    Global.PrepareMin := nMin;
    Global.ConfigLocal.WriteInteger('Config', 'PrepareMin', nMin);
    trbPrepareMin.Position := Global.PrepareMin;
  end;
end;

procedure TXGTeeBoxViewForm.V1CustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('play_yn').Index] <> True) then
    ACanvas.Font.Color := $00B6752E;
end;

procedure TXGTeeBoxViewForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  i: Integer;
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
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); //$00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for i := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[i]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[i] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[i].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[i].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[i]).Active);
  end;
  ADone := True;
end;

function TXGTeeBoxViewForm.GetTeeBoxPanel(const ATeeBoxIndex: Integer): TTeeBoxPanel;
begin
  Result := FTeeBoxPanels[ATeeBoxIndex];
end;

procedure TXGTeeBoxViewForm.GridCustomDrawFooterCell(Sender: TcxGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin
  ACanvas.Brush.Color := $00303030; //$00689F0E;
  ACanvas.FillRect(AViewInfo.Bounds);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextAreaBounds, cxAlignRight, True);
  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, [bLeft], 2);
  ADone := True;
end;

procedure TXGTeeBoxViewForm.GridCustomDrawPartBackground(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxCustomGridCellViewInfo; var ADone: Boolean);
var
  ARect: TRect;
  i: Integer;
begin
  if AViewInfo is TcxGridFooterViewInfo then
  begin
    TcxGridFooterViewInfo(AViewInfo).Borders := [];
    ACanvas.FillRect(TcxGridFooterViewInfo(AViewInfo).Bounds, $00303030); //$00689F0E);
    ACanvas.FrameRect(ARect, $00303030); //$00689F0E);
    for i := 0 to Pred(TcxGridFooterViewInfo(AViewInfo).Count) do
    begin
      ARect := TcxGridFooterViewInfo(AViewInfo).Items[i].Bounds;
      ARect.Top := TcxGridFooterViewInfo(AViewInfo).BordersBounds.Top;
      ARect.Bottom := TcxGridFooterViewInfo(AViewInfo).BordersBounds.Bottom;
      ACanvas.DrawComplexFrame(ARect, $00FFFFFF, $00FFFFFF, [bLeft], 2);
    end;
    ADone := True;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxFilter;
begin
  if (CurrentTeeBoxIndex < 0) then
    Exit;

  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    FTeeBoxPanels[CurrentTeeBoxIndex].Checked := True;
    panReservedTitle.Caption := Format(' ≡예약 현황 (선택타석: %s)', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName]);
    btnTeeBoxFilterClear.Enabled := True;
    Filtered := False;
    SaleManager.StoreInfo.SelectedTeeBoxNo := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo;
    Filtered := True;

    if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
      btnSaleTeeBoxHoldCancel.Enabled := False
    else
      btnSaleTeeBoxHoldCancel.Enabled := True;

    Locate('teebox_no', FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo, []);
  finally
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.SelectTeeBoxByIndex(const AIndex: Integer);
var
  nPrevIndex: Integer;
begin
  btnTeeBoxImmediateStart.Enabled := True;
  if (CurrentTeeBoxIndex < 0) then
    nPrevIndex := AIndex
  else
    nPrevIndex := CurrentTeeBoxIndex;

  FTeeBoxPanels[nPrevIndex].Checked := False;
  CurrentTeeBoxIndex := AIndex;
  DoTeeBoxFilter;
end;

procedure TXGTeeBoxViewForm.OnTeeBoxHeaderClick(Sender: TObject);
begin
  SelectTeeBoxByIndex(TWinControl(Sender).Tag);
end;

procedure TXGTeeBoxViewForm.OnTeeBoxBodyClick(Sender: TObject);
var
  nIndex: Integer;
  sErrMsg: string;
  bSelected: Boolean;
begin
  btnSaleTeeBoxHoldCancel.Enabled := False;
  nIndex := TWinControl(Sender).Tag;
  if (FTeeBoxPanels[nIndex].CurStatus in [CTS_TEEBOX_STOP]) or
     ((not Global.TeeBoxForceAssign) and (FTeeBoxPanels[nIndex].CurStatus = CTS_TEEBOX_STOP_ALL)) or
     ((not Global.TeeBoxForceAssignOnError) and (FTeeBoxPanels[nIndex].CurStatus in [CTS_TEEBOX_ERROR])) then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '사용불가 상태인 타석은 사용할 수 없습니다!', ['확인'], 5);
    Exit;
  end;

  bSelected := (not FTeeBoxPanels[nIndex].Selected);
  Screen.Cursor := crHourGlass;
  try
    try
      if bSelected then
      begin
        if not DoTeeBoxHoldByIndex(True, nIndex, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.UpdateTeeBoxSelection(True, FTeeBoxPanels[nIndex].TeeBoxNo, nIndex,
          FTeeBoxPanels[nIndex].FloorCode, FTeeBoxPanels[nIndex].FloorName, FTeeBoxPanels[nIndex].ZoneCode, FTeeBoxPanels[nIndex].VipYN, FTeeBoxPanels[nIndex].TeeBoxName);
        CurrentTeeBoxIndex := nIndex;
      end else
      begin
        if not DoTeeBoxHoldByIndex(False, nIndex, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.UpdateTeeBoxSelection(False, FTeeBoxPanels[nIndex].TeeBoxNo, FTeeBoxPanels[nIndex].FloorCode, FTeeBoxPanels[nIndex].FloorName, FTeeBoxPanels[nIndex].ZoneCode);
        ClientDM.ReloadTeeBoxStatus;
      end;

      FTeeBoxPanels[nIndex].Selected := bSelected;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '임시예약 등록',
        '임시예약 등록 작업이 처리되지 못하였습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.CloseAction(const AEmergencyChanged: Boolean);
begin
  if not AEmergencyChanged then
    if (XGMsgBox(Self.Handle, mtConfirmation, '프로그램 종료', '프로그램을 종료하시겠습니까?', ['확인', '취소']) <> mrOK) then
    begin
      Global.Closing := False;
      Exit;
    end;

  try
    ClientDM.ExportMemData(ClientDM.MDTeeBoxSelected);
    if not AEmergencyChanged then
    begin
      Global.Closing := True;
      SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
    end;
  finally
    Close;
  end;
end;

procedure TXGTeeBoxViewForm.RefreshTeeBoxLayout;
var
  nIndex: Integer;
begin
  with ClientDM.MDTeeBox do
  try
    DisableControls;
    First;
    nIndex := 0;
    while not Eof do
    begin
      if Global.Closing then
        Break;

      if (nIndex < FTeeBoxCount) then
      begin
        FTeeBoxPanels[nIndex].TeeBoxNo   := FieldByName('teebox_no').AsInteger;
        FTeeBoxPanels[nIndex].TeeBoxName := FieldByName('teebox_nm').AsString;
        FTeeBoxPanels[nIndex].FloorCode  := FieldByName('floor_cd').AsString;
        FTeeBoxPanels[nIndex].FloorName  := FieldByName('floor_nm').AsString;
        FTeeBoxPanels[nIndex].DeviceId   := FieldByName('device_id').AsString;
        FTeeBoxPanels[nIndex].VipYN      := FieldByName('vip_yn').AsBoolean;
        FTeeBoxPanels[nIndex].UseYN      := FieldByName('use_yn').AsBoolean;
        FTeeBoxPanels[nIndex].ZoneCode   := FieldByName('zone_cd').AsString;
        FTeeBoxPanels[nIndex].ControlYN  := (FieldByName('control_yn').AsString = CRC_YES);
      end;

      Inc(nIndex);
      Next;
    end;
  finally
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.RefreshTeeBoxStatus;
var
  PM: TPluginMessage;
  BM: TBookmark;
  nIndex, nFloor, nQuick, nTeeBoxNo, nRemainMin: Integer;
  sStartTime, sEndTime, sTeeBoxName, sErrMsg: string;
  bIsFiltered: Boolean;
begin
  if Global.AirConditioner.Enabled and
     (not Global.TeeBoxADInfo.Enabled) then
  try
    Global.AirConditioner.Active := ClientDM.GetAirConStatus(sErrMsg);
    if not Global.AirConditioner.Active then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;

  PM := TPluginMessage.Create(nil);
  try
    with ClientDM.MDTeeBoxStatus2 do
    try
      DisableControls;
      CopyFromDataSet(ClientDM.MDTeeBoxStatus);
      First;
      while not Eof do
      begin
        nTeeBoxNo := FieldByName('teebox_no').AsInteger;
        nIndex := IndexOfTeeBoxNo(nTeeBoxNo);
        if nIndex in [0..Pred(FTeeBoxCount)] then
        begin
          with FTeeBoxPanels[nIndex] do
          begin
            MemberName := FieldByName('member_nm').AsString;
            MemberNo := FieldByName('member_no').AsString;
            RemainMin := FieldByName('remain_min').AsInteger;
            ReservedCount := FieldByName('reserved_count').AsInteger;
            CurStatus := FieldByName('use_status').AsInteger;
            HpNo := FieldByName('hp_no').AsString;
            Memo := FieldByName('memo').AsString;

            if Global.TeeBoxADInfo.Enabled then
              ErrorCode := StrToIntDef(FieldByName('error_cd').AsString, -1);

            sStartTime := FieldByName('start_datetime').AsString;
            sEndTime := FieldByName('end_datetime').AsString;
            if (RemainMin > 0) and
               (not sStartTime.IsEmpty) and
               (not sEndTime.IsEmpty) then
            begin
              StartTime := Copy(sStartTime, 12, 5);
              EndTime := Copy(sEndTime, 12, 5);
              StartDateTime := StrToDateTime(sStartTime, Global.FS);
              EndDateTime := StrToDateTime(sEndTime, Global.FS);
            end
            else
            begin
              StartTime := '';
              EndTime := '';
              StartDateTime := Now;
              EndDateTime := Now;
            end;

            if not FCheckedStoppedAll then
            begin
              StoppedAll := (CurStatus = CTS_TEEBOX_STOP_ALL);
              FCheckedStoppedAll := True;
            end;

            //서브 모니터로 전달
            PM.ClearParams;
            PM.Command := CPC_TEEBOX_SCOREBOARD;
            PM.AddParams(CPP_TEEBOX_INDEX, nIndex);
            PM.AddParams(CPP_REMAIN_MIN, RemainMin);
            PM.AddParams(CPP_TEEBOX_ENDTIME, EndTime);
            PM.AddParams(CPP_WAITING_COUNT, ReservedCount);
            PM.AddParams(CPP_TEEBOX_STATUS, CurStatus);
            PM.PluginMessageToID(Global.SubMonitorId);
          end;
        end;

        Next;
      end;

      with btnTeeBoxStoppedAll do
        if (not Enabled) then
          Enabled := True;
    finally
      EnableControls;
    end;

    if Global.TeeBoxQuickView then
    begin
      nIndex := 0;
      for nFloor := 0 to Pred(FFloorCount) do
      begin
        nQuick := 0;
        with TXQuery.Create(nil) do
        try
          AddDataSet(ClientDM.MDTeeBoxStatus2, 'S');
          AddDataSet(ClientDM.MDTeeBox, 'T');
          SQL.Add(Format('SELECT TOP %d S.teebox_no, S.teebox_nm, S.remain_min FROM S', [LCN_QUICK_OF_FLOOR]));
          SQL.Add('LEFT OUTER JOIN T ON T.teebox_no = S.Teebox_no');
          SQL.Add('WHERE S.floor_cd = :floor_cd AND S.use_status IN (0, 1, 4)');
          SQL.Add('AND T.use_yn = TRUE');
          SQL.Add(Format('AND T.zone_cd NOT IN (%s, %s)', [QuotedStr(CTZ_TRACKMAN), QuotedStr(CTZ_GDR)])); //트랙맨(T), GDR(X) 제외
          SQL.Add('ORDER BY S.remain_min;');
          Params.ParamValues['floor_cd'] := Global.TeeBoxFloorInfo[nFloor].FloorCode;
          Open;
          First;
          while not Eof do
          begin
            sTeeBoxName := FieldByName('teebox_nm').AsString;
            nRemainMin := FieldByName('remain_min').AsInteger;
            FQuickPanels[nIndex].SetQuickInfo(Format('%s-%s', [Global.TeeBoxFloorInfo[nFloor].FloorName, sTeeBoxName]), nRemainMin);

            PM.ClearParams;
            PM.Command := CPC_QUICK_SCOREBOARD;
            PM.AddParams(CPP_FLOOR_INDEX, nFloor);
            PM.AddParams(CPP_QUICK_INDEX, nQuick);
            PM.AddParams(CPP_TEEBOX_NAME, sTeeBoxName);
            PM.AddParams(CPP_REMAIN_MIN, NRemainMin);
            PM.PluginMessageToID(Global.SubMonitorId);

            Inc(nQuick);
            Inc(nIndex);
            Next;
          end;
        finally
          Close;
          Free;
        end;
      end;
    end;
  finally
    FreeAndNil(PM);
  end;

  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    if not Active then
      Open;

    BM := GetBookmark;
    try
      bIsFiltered := Filtered;
      if bIsFiltered then
        Filtered := False;

      CopyFromDataSet(ClientDM.MDTeeBoxReserved);
      if bIsFiltered then
        Filtered := True;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    except
    end;
  finally
    if Assigned(BM) then
      FreeBookmark(BM);
    EnableControls;
  end;
end;

function TXGTeeBoxViewForm.IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
var
  nIndex: Integer;
begin
  Result := -1;
  for nIndex := 0 to Pred(FTeeBoxCount) do
    if (FTeeBoxPanels[nIndex].TeeBoxNo = ATeeBoxNo) then
    begin
      Result := nIndex;
      Break;
    end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxClearHoldClick(Sender: TObject);
begin
  DoTeeBoxClearHold;
end;

procedure TXGTeeBoxViewForm.btnCloseClick(Sender: TObject);
begin
  CloseAction;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxFilterClearClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    if Filtered then
    begin
      panReservedTitle.Caption := ' ≡예약 현황 (전체보기)';
      Filtered := False;
      TcxButton(Sender).Enabled := False;
      btnTeeBoxImmediateStart.Enabled := False;
    end;
  finally
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxDeleteHoldClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
    if (RecordCount > 0) then
      ClearTeeBoxSelection(True, False);
end;

procedure TXGTeeBoxViewForm.btnHomeClick(Sender: TObject);
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_SET_FOREGROUND;
    PluginMessageToID(FOwnerID);
  finally
    Free;
  end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxImmediateStartClick(Sender: TObject);
var
  nTeeBoxNo: Integer;
  sTeeBoxName, sReserveNo, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    try
      if (RecordCount = 0) then
        Exit;

      nTeeBoxNo := FieldByName('teebox_no').AsInteger;
      sTeeBoxName := FieldByName('teebox_nm').AsString;
      sReserveNo := FieldByName('reserve_no').AsString;
      with TxQuery.Create(nil) do
      try
        AddDataSet(ClientDM.MDTeeBoxReserved2, 'R');
        SQL.Add('SELECT R.reserve_no FROM R WHERE R.teebox_no = :teebox_no AND R.play_yn = True;');
        Close;
        Params.ParamValues['teebox_no'] := nTeeBoxNo;
        Open;
        if (RecordCount > 0) then
          raise Exception.Create(Format('%s(번) 타석은 현재 사용 중이므로 즉시 배정이 불가합니다!', [sTeeBoxName]));
      finally
        Close;
        Free;
      end;

      if not ClientDM.ImmediateTeeBoxStart(sReserveNo, sErrMsg) then
        raise Exception.Create(sErrMsg);
    finally
      EnableControls;
    end;

    XGMsgBox(Self.Handle, mtInformation, '즉시 배정', Format('%s번 타석의 즉시 배정이 완료 되었습니다!', [sTeeBoxName]), ['확인'], 5);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '즉시 배정', E.Message, ['확인'], 5);
  end;
end;

function TXGTeeBoxViewForm.CheckSelectedTeeBox(const ATitle: string): Boolean;
begin
  Result := (ClientDM.MDTeeBoxSelected.RecordCount > 0);
  if not Result then
    XGMsgBox(Self.Handle, mtWarning, ATitle, '예약할 타석이 없습니다!', ['확인'], 5);
end;

procedure TXGTeeBoxViewForm.btnTeeBoxChangeReservedClick(Sender: TObject);
begin
  DoTeeBoxChangeReserved;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxStoppedAllClick(Sender: TObject);
begin
  DoTeeBoxStoppedAll;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxHoldCancelClick(Sender: TObject);
var
  sTitle, sErrMsg: string;
begin
  if (CurrentTeeBoxIndex < 0) then
    Exit;

  sTitle := '임시예약 취소';
  if not (FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus in [CTS_TEEBOX_READY, CTS_TEEBOX_HOLD]) then
  begin
    XGMsgBox(Self.Handle, mtWarning, sTitle, '처리할 수 없는 타석입니다!', ['확인'], 5);
    Exit;
  end;

  try
    if (XGMsgBox(Self.Handle, mtConfirmation, sTitle,
        Format('%s(번) 타석의 %s 작업을 진행하시겠습니까?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['예', '아니오']) = mrOK) then
    begin
      if not DoTeeBoxHoldByIndex(False, CurrentTeeBoxIndex, sErrMsg) then
        raise Exception.Create(sErrMsg);

      XGMsgBox(Self.Handle, mtInformation, sTitle, sTitle + ' 작업이 완료 되었습니다!', ['확인'], 5);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, sTitle,
        sTitle + ' 작업이 처리되지 못하였습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxClearanceClick(Sender: TObject);
begin
  DoTeeBoxClearance;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxMoveClick(Sender: TObject);
begin
  DoTeeBoxMove;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxPauseClick(Sender: TObject);
begin
  DoTeeBoxPause;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxCancelReservedClick(Sender: TObject);
begin
  DoTeeBoxCancelReserved;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxReserveClick(Sender: TObject);
begin
  DoTeeBoxReserve;
end;

procedure TXGTeeBoxViewForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGTeeBoxViewForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGTeeBoxViewForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGTeeBoxViewForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGTeeBoxViewForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGTeeBoxViewForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGTeeBoxViewForm.SetStoppedAll(const AStopped: Boolean);
begin
  FStoppedAll := AStopped;
  btnTeeBoxStoppedAll.Caption := '볼 회수' + _CRLF + IIF(AStopped, '종료', '시작');
end;

procedure TXGTeeBoxViewForm.DoTeeBoxClearHold;
begin
  if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
    ClearTeeBoxSelection(True, True);

  ClientDM.ReloadTeeBoxStatus;
end;

function TXGTeeBoxViewForm.DoTeeBoxHoldByIndex(const AUseHold: Boolean; const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;
var
  PM: TPluginMessage;
  nStatus: Integer;
  sSubCmd, sErrMsg: string;
begin
  Result := False;
  if AUseHold then
  begin
    nStatus := CTS_TEEBOX_HOLD;
    sSubCmd := CPC_TEEBOX_HOLD;
  end else
  begin
    nStatus := CTS_TEEBOX_READY;
    sSubCmd := CPC_TEEBOX_HOLD_CANCEL;
  end;

  try
    if not ClientDM.SetTeeBoxHold(FTeeBoxPanels[ATeeBoxIndex].TeeBoxNo, ATeeBoxIndex, AUseHold, sErrMsg) then
      raise Exception.Create(sErrMsg);

    FTeeBoxPanels[ATeeBoxIndex].CurStatus := nStatus;
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := sSubCmd;
      PM.AddParams(CPP_TEEBOX_INDEX, ATeeBoxIndex);
      PM.PluginMessageToID(Global.SubMonitorId);
    finally
      FreeAndNil(PM);
    end;
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

procedure TXGTeeBoxViewForm.ClearTeeBoxSelection(const AUpdateToServer, AClearAll: Boolean);
var
  nIndex: Integer;
  sErrMsg: string;
begin
  with ClientDM.MDTeeBoxSelected do
  try
    DisableControls;
    if AClearAll then
      First;

    while not Eof do
    begin
      nIndex := FieldByName('teebox_index').AsInteger;
      if AUpdateToServer then
        DoTeeBoxHoldByIndex(False, nIndex, sErrMsg);

      FTeeBoxPanels[nIndex].Selected := False;
      with TPluginMessage.Create(nil) do
      try
        Command := CPC_TEEBOX_SELECT;
        AddParams(CPP_TEEBOX_INDEX, nIndex);
        AddParams(CPP_TEEBOX_SELECTED, FTeeBoxPanels[nIndex].Selected);
        PluginMessageToID(Global.SubMonitorId);
      finally
        Free;
      end;

      if (not AClearAll) then
      begin
        Delete;
        Break;
      end;

      Next;
    end;

    if AClearAll then
    begin
      Close;
      Open;
    end;

  finally
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxReserve;
var
  RF: TXGEmergencyReserveForm;
  sErrMsg, sReceiptJson, sReceiptNo: string;
label
  GO_TEEBOX_RETRY;
begin
  if FWorking or (not CheckSelectedTeeBox('긴급배정')) then
    Exit;

  FWorking := True;
  try
    RF := TXGEmergencyReserveForm.Create(nil);
    with ClientDM.MDTeeBoxSelected do
    try
      sReceiptNo := Salemanager.GetNewReceiptNo;
      RF.PrepareMin := Trunc(edtPrepareMin.Value);
      RF.AssignMin := Trunc(edtAssignMin.Value);
      RF.MemberName := '';
      if (RF.ShowModal = mrOK) then
      begin
        //==============
        GO_TEEBOX_RETRY:
        //==============
        if not ClientDM.PostTeeBoxReserveLocal(
                  '', //SaleManager.MemberInfo.MemberNo,
                  RF.MemberName, //SaleManager.MemberInfo.MemberName,
                  '', //SaleManager.MemberInfo.HpNo,
                  sReceiptNo, //SaleManager.ReceiptInfo.ReceiptNo,
                  sErrMsg) then
        begin
          if (XGMsgBox(Self.Handle, mtConfirmation, '알림',
                '장애가 발생하여 타석 배정에 실패하였습니다!' + _CRLF + '(' + sErrMsg + ')' + _CRLF +
                '배정 요청을 재시도 하시겠습니까?', ['예', '아니오']) <> mrOK) then
            raise Exception.Create(sErrMsg);

          goto GO_TEEBOX_RETRY;
        end;

        sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
        try
          if not sErrMsg.IsEmpty then
            raise Exception.Create(sErrMsg);

          Global.ReceiptPrint.IsReturn := False;
          if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, False, False, sErrMsg) then
            raise Exception.Create(sErrMsg);

          ClientDM.ReloadTeeBoxStatus;
          ClearTeeBoxSelection(False, True);
          XGMsgBox(Self.Handle, mtInformation, '알림', '타석 배정이 완료되었습니다!', ['확인'], 5);
        except
          on E: Exception do
            XGMsgBox(Self.Handle, mtError, '알림', '타석 배정표 출력에 장애가 발생했습니다!' + _CRLF + E.Message, ['확인'], 5);
        end;
      end;
    finally
      EnableControls;
      RF.Free;
      FWorking := False;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', '타석 배정에 실패하였습니다!' + _CRLF + E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxMove;
var
  PM: TPluginMessage;
  sReceiptJson, sMemberNo, sTargetTeeBoxName, sTargetFloorCode, sErrMsg: string;
  nRemainMin, nSourceIndex, nTargetTeeBoxNo, nSourceTeeBoxNo: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      with ClientDM.MDTeeBoxReserved2 do
      begin
        if (RecordCount = 0) then
          raise Exception.Create('이동할 예약 내역이 선택되지 않았습니다!');

        sMemberNo := FieldByName('member_no').AsString;
        nSourceTeeBoxNo := FieldByName('teebox_no').AsInteger;
        nRemainMin := FieldByName('assign_min').AsInteger;
        if (nRemainMin <= 1) then
          raise Exception.Create('종료시각이 임박하여 타석 이동이 불가합니다!');

        nSourceIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
        if (FTeeBoxPanels[nSourceIndex].CurStatus = CTS_TEEBOX_STOP_ALL) then
          raise Exception.Create('볼 회수 중인 상태에서는 타석 이동이 불가합니다!');
      end;

      with ClientDM.MDTeeBoxSelected do
      try
        DisableControls;
        if (RecordCount = 0) then
          raise Exception.Create('타석 이동은 1개의 타석만 예약할 수 있습니다!' + _CRLF +
            '1개의 타석만 예약할 타석 목록에 등록하여 주십시오.');

        nTargetTeeBoxNo := FieldByName('teebox_no').AsInteger;
        sTargetTeeBoxName := FieldByName('teebox_nm').AsString;
        sTargetFloorCode := FieldByName('floor_cd').AsString;
        if (nTargetTeeBoxNo = nSourceTeeBoxNo) then
          raise Exception.Create('동일한 타석으로 타석을 이동할 수 없습니다!');

        PM := TPluginMessage.Create(nil);
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, Self.PluginID);
        PM.AddParams(CPP_TEEBOX_NO, nTargetTeeBoxNo);
        PM.AddParams(CPP_TEEBOX_NAME, sTargetTeeBoxName);
        PM.AddParams(CPP_FLOOR_CODE, sTargetFloorCode);
        if (PluginManager.OpenModal('XGTeeBoxMove' + CPL_EXTENSION, PM) = mrOK) then
        begin
          try
            if Global.TeeBoxChangedReIssue then
              sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
          finally
            ClearTeeBoxSelection(True, True);
          end;

          try
            if not sErrMsg.IsEmpty then
              raise Exception.Create(sErrMsg);

            if Global.TeeBoxChangedReIssue then
            begin
              Global.ReceiptPrint.IsReturn := False;
              if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, True, False, sErrMsg) then
                raise Exception.Create(sErrMsg);
            end;
          except
            on E: Exception do
              XGMsgBox(Self.Handle, mtError, '알림', '타석 배정표를 출력할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
          end;

          ClientDM.ReloadTeeBoxStatus;
          XGMsgBox(Self.Handle, mtInformation, '알림', '타석 이동이 완료되었습니다!', ['확인'], 5);
        end;
      finally
        EnableControls;
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '타석 이동', E.Message, ['확인'], 5);
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxChangeReserved;
var
  PM: TPluginMessage;
  nTeeBoxNo, nRemainMin, nPrepareMin: Integer;
  sMemberNo, sReceiptJson, sStartDateTime, sErrMsg: string;
  bIsPlaying: Boolean;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    with ClientDM.MDTeeBoxReserved2 do
    try
      DisableControls;
      try
        if (RecordCount = 0) then
          raise Exception.Create('변경할 예약 내역이 선택되지 않았습니다!');

        sMemberNo := FieldByName('member_no').AsString;
        nTeeBoxNo := FieldByName('teebox_no').AsInteger;
        sStartDateTime := FieldByName('start_datetime').AsString;
        bIsPlaying  := FieldByName('play_yn').AsBoolean;
        nPrepareMin := FieldByName('prepare_min').AsInteger;
        nRemainMin  := FieldByName('assign_min').AsInteger;
        if (nRemainMin <= 1) then
          raise Exception.Create('종료시각이 임박하여 시간 추가가 불가합니다!');

        if bIsPlaying then
        begin
          nPrepareMin := 0;
          nRemainMin  := FieldByName('calc_remain_min').AsInteger;
        end;

        with TXQuery.Create(nil) do
        try
          AddDataSet(ClientDM.MDTeeBoxReserved2, 'R');
          SQL.Add('SELECT * FROM R WHERE R.teebox_no = :teebox_no AND R.start_datetime > :start_datetime;');
          Params.ParamValues['teebox_no'] := nTeeBoxNo;
          Params.ParamValues['start_datetime'] := sStartDateTime;
          Open;
          if (RecordCount > 0) then
          begin
            XGMsgBox(Self.Handle, mtWarning, '알림', '대기 중인 타석이 있습니다.!', ['확인'], 5);
            Exit;
          end;
        finally
          Close;
          Free;
        end;

        PM := TPluginMessage.Create(nil);
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, Self.PluginID);
        PM.AddParams(CPP_PREPARE_MIN, nPrepareMin);
        PM.AddParams(CPP_REMAIN_MIN, nRemainMin);
        PM.AddParams(CPP_PLAY_YN, bIsPlaying);
        if (PluginManager.OpenModal('XGTeeBoxChange' + CPL_EXTENSION, PM) = mrOK) then
        begin
          try
            sErrMsg := '';
            if Global.TeeBoxChangedReIssue then
            begin
              sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
              if not sErrMsg.IsEmpty then
                raise Exception.Create(sErrMsg);

              Global.ReceiptPrint.IsReturn := False;
              if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, True, False, sErrMsg) then
                raise Exception.Create(sErrMsg);
            end;
          except
            on E: Exception do
              XGMsgBox(Self.Handle, mtError, '알림', '타석 배정표를 출력할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
          end;

          ClientDM.ReloadTeeBoxStatus;
          XGMsgBox(Self.Handle, mtInformation, '알림', '타석 예약 변경이 완료되었습니다!', ['확인'], 5);
        end;
      finally
        EnableControls;
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '타석 예약 변경', E.Message, ['확인'], 5);
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxCancelReserved;
var
  sReserveNo, sTeeBoxName, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    if FWorking or (RecordCount = 0) then
      Exit;

    FWorking := True;
    sTeeBoxName := FieldByName('teebox_nm').AsString;
    sReserveNo  := FieldByName('reserve_no').AsString;
    if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
        '예약된 타석 배정 내역을 취소하시겠습니까?' + _CRLF +
        Format('%s번 타석(예약번호: %s)', [sTeeBoxName, sReserveNo]), ['예', '아니오']) <> mrOK) then
      Exit;

    try
      if not ClientDM.CancelTeeBoxReserve(sReserveNo, '', sErrMsg) then
        raise Exception.Create(sErrMsg);

      ClientDM.ReloadTeeBoxStatus;
      XGMsgBox(Self.Handle, mtInformation, '알림', '타석 예약이 취소되었습니다!' + _CRLF +
        Format('%s번 타석(예약번호: %s)', [sTeeBoxName, sReserveNo]), ['확인'], 5);
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxPause;
var
  PM: TPluginMessage;
  MR: TModalResult;
  nNewCmd: Integer;
  sTitle, sSubCmd, sErrMsg: string;
begin
  if FWorking or (CurrentTeeBoxIndex < 0) then
    Exit;

  FWorking := True;
  try
    sTitle := '타석 점검/재가동 등록';
    try
      if (FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus = CTS_TEEBOX_STOP) then
      begin
        nNewCmd := CTS_TEEBOX_READY;
        sSubCmd := CPC_TEEBOX_READY;
        sTitle := '재가동';
        MR := XGMsgBox(Self.Handle, mtConfirmation, sTitle,
                Format('%s(번) 타석을 %s 상태로 변경하시겠습니까?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['예', '아니오']);
      end else
      begin
        nNewCmd := CTS_TEEBOX_STOP;
        sSubCmd := CPC_TEEBOX_STOP;
        sTitle  := '점검중';
        MR := XGMsgBox(Self.Handle, mtConfirmation, sTitle,
                Format('%s(번) 타석을 %s 상태로 변경하시겠습니까?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['예', '아니오']);
      end;

      if (MR in [mrOK, mrYes]) then
      begin
        (*
        // 점검 프로시저로 설정
        if not ClientDM.ProcSetTeeBoxError(FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo, nNewCmd, sErrMsg) then
          raise Exception.Create(sErrMsg);
        *)

        if not ClientDM.SetTeeBoxError(FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo, nNewCmd, sErrMsg) then
          raise Exception.Create(sErrMsg);

        if (nNewCmd = CTS_TEEBOX_STOP) then
        begin
          FTeeBoxPanels[CurrentTeeBoxIndex].OldStatus := FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus;
          FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus := nNewCmd;
        end
        else
          FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus := FTeeBoxPanels[CurrentTeeBoxIndex].OldStatus;

        PM := TPluginMessage.Create(nil);
        try
          PM.Command := sSubCmd;
          //PM.AddParams(CPP_TEEBOX_NO, FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo);
          PM.AddParams(CPP_TEEBOX_INDEX, CurrentTeeBoxIndex);
          PM.AddParams(CPP_TEEBOX_STATUS, FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus);
          PM.PluginMessageToID(Global.SubMonitorId);
        finally
          FreeAndNil(PM);
        end;

        XGMsgBox(Self.Handle, mtInformation, sTitle, Format('%s 상태로 변경이 완료되었습니다.', [sTitle]), ['확인'], 5);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, sTitle,
          sTitle + ' 작업이 처리되지 못하였습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

//타석 정리
procedure TXGTeeBoxViewForm.DoTeeBoxClearance;
var
  bIsPlay: Boolean;
  sReserveNo, sErrMsg: string;
  nTeeBoxNo: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    if (CurrentTeeBoxIndex < 0) or
       (RecordCount = 0) then
      Exit;

    try
      bIsPlay := FieldByName('play_yn').AsBoolean;
      sReserveNo := FieldByName('reserve_no').AsString;
      nTeeBoxNo := FieldByName('teebox_no').AsInteger;
      if not bIsPlay then
      begin
        XGMsgBox(Self.Handle, mtWarning, '타석 정리', '이용 중인 타석이 아닙니다!', ['확인'], 5);
        Exit;
      end;

      if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
            FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName + '(번) 타석을 정리하시겠습니까?' + _CRLF +
            '정리된 타석은 사용종료 상태로 변경됩니다.', ['예', '아니오']) = mrOK) then
      begin
        if not ClientDM.CloseTeeBoxReserve(sReserveNo, nTeeBoxNo, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.ReloadTeeBoxStatus;
        XGMsgBox(Self.Handle, mtInformation, '타석 정리', '타석 정리 작업이 완료되었습니다!', ['확인'], 5);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '타석 정리',
          '장애가 발생하여 작업이 완료되지 못하였습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  finally
    EnableControls;
    FWorking := False;
  end;
end;

//볼 회수
procedure TXGTeeBoxViewForm.DoTeeBoxStoppedAll;
var
  PM: TPluginMessage;
  I, nNewCmd: Integer;
  sTitle, sErrMsg, sSubCmd: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      if not ClientDM.GetTeeBoxStatus(ClientDM.MDTeeboxStatus, sErrMsg) then
        raise Exception.Create(sErrMsg);

      with ClientDM.MDTeeBoxStatus2 do
      try
        DisableControls;
        CopyFromDataSet(ClientDM.MDTeeBoxStatus);
        First;
        while not Eof do
        begin
          if FieldByName('use_status').AsInteger = CTS_TEEBOX_HOLD then
          begin
            raise Exception.Create('임시예약 걸린 타석이 존재 합니다!');
          end;
          Next;
        end;
      finally
        EnableControls;
      end;

      if StoppedAll then
      begin
        nNewCmd := CTS_TEEBOX_READY;
        sTitle  := '볼 회수 종료';
      end else
      begin
        nNewCmd := CTS_TEEBOX_STOP_ALL;
        sTitle := '볼 회수 시작';
      end;

      if (XGMsgBox(Self.Handle, mtConfirmation, sTitle,
        sTitle + ' 작업을 진행하시겠습니까?', ['예', '아니오']) = mrOK) then
      begin
        if not ClientDM.SetTeeBoxError(0, nNewCmd, sErrMsg) then
          raise Exception.Create(sErrMsg);

        StoppedAll := not StoppedAll;
        if StoppedAll then
          sSubCmd := CPC_TEEBOX_STOP_ALL
        else
          sSubCmd := CPC_TEEBOX_READY_ALL;

        for I := 0 to Pred(FTeeBoxCount) do
          if (nNewCmd = CTS_TEEBOX_STOP_ALL) then
          begin
            FTeeBoxPanels[I].OldStatus := FTeeBoxPanels[I].CurStatus;
            FTeeBoxPanels[I].CurStatus := nNewCmd;
          end;

        PM := TPluginMessage.Create(nil);
        try
          PM.Command := sSubCmd;
          PM.PluginMessageToID(Global.SubMonitorId);
        finally
          FreeAndNil(PM);
        end;

        btnTeeBoxStoppedAll.Enabled := False; //타석 상태를 다시 읽을 떄까지 사용 불가 처리
        XGMsgBox(Self.Handle, mtInformation, sTitle, sTitle + ' 작업이 완료되었습니다!', ['확인'], 5);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, sTitle,
          sTitle + ' 작업이 처리되지 못하였습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.OnTeeBoxHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
    TPanel(Sender).BeginDrag(False);
end;

procedure TXGTeeBoxViewForm.OnTeeBoxHeaderDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TPanel);
end;

procedure TXGTeeBoxViewForm.OnTeeBoxHeaderDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  nSource, nSender: Integer;
  sReceiptJson, sErrMsg: string;
begin
  if (Source is TPanel) then
  begin
    nSource := TPanel(Source).Tag; //이동할 현재 타석
    nSender := TPanel(Sender).Tag; //이동할 대상 타석
    try
      if FTeeBoxPanels[nSource].EndTime.IsEmpty then
        raise Exception.Create('이동할 예약 내역이 없습니다!');

      DoTeeBoxClearHold;
      if not FTeeBoxPanels[nSender].Selected then
        if not DoTeeBoxHoldByIndex(True, nSender, sErrMsg) then
          raise Exception.Create(sErrMsg);

      SelectTeeBoxByIndex(nSource);
      with TXGTeeBoxMoveDragDropForm.Create(nil) do
      try
        TargetTeeBoxName := Format('%s층 %s', [FTeeBoxPanels[nSender].FloorCode, FTeeBoxPanels[nSender].TeeBoxName]);
        if (ShowModal = mrOK) then
        begin
          if not ClientDM.PostTeeBoxReserveMove(ReserveNo, FTeeBoxPanels[nSender].TeeBoxNo, RemainMin, PrepareMin, 9999, sErrMsg) then
            raise Exception.Create(sErrMsg);

          try
            try
              if Global.DeviceConfig.ReceiptPrinter.Enabled and
                 Global.TeeBoxChangedReIssue then
                sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
            finally
              ClearTeeBoxSelection(True, True);
            end;

            if not sErrMsg.IsEmpty then
              raise Exception.Create(sErrMsg);

            if Global.DeviceConfig.ReceiptPrinter.Enabled and
               Global.TeeBoxChangedReIssue then
            begin
              Global.ReceiptPrint.IsReturn := False;
              if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, True, False, sErrMsg) then
                raise Exception.Create(sErrMsg);
            end;
          except
            on E: Exception do
              XGMsgBox(Self.Handle, mtInformation, '알림', '타석 배정표를 출력할 수 없습니다!' + _CRLF + E.Message, ['확인'], 5);
          end;

          ClientDM.ReloadTeeBoxStatus;
          SelectTeeBoxByIndex(nSender);
          XGMsgBox(Self.Handle, mtInformation, '알림', '타석 이동이 완료되었습니다!', ['확인'], 5);
        end;
      finally
        Free;
        DoTeeBoxClearHold;
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5)
    end;
  end;
end;

{ TTeeBoxPanel }

constructor TTeeBoxPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOldStatus := CTS_TEEBOX_READY;

  DoubleBuffered := True;
  Caption := '';
  Color := $00FFFFFF;
  Height := 126;
  Width := 54;
  AlignWithMargins := True;
  Margins.Top := 0;
  Margins.Left := 0;
  Margins.Bottom := 0;
  Margins.Right := 1;
  ParentBackground := False;
  ParentColor := False;

  TeeBoxTitle := TPanel.Create(Self);
  with TeeBoxTitle do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Height := 24;
    Width := 47;
    Margins.Top := 1;
    Margins.Left := 1;
    Margins.Bottom := 1;
    Margins.Right := 1;
    AlignWithMargins := True;
    Align := alTop;
    BevelOuter := bvNone;
    Color := GCR_COLOR_READY;
    ParentFont := False;
    ParentColor := False;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := $00FFFFFF;
    Font.Style := [fsBold];
    ParentBackground := False;
    ParentColor := False;
    Cursor := crHandPoint;
  end;

  VIPLabel := TcxLabel.Create(Self);
  with VIPLabel do
  begin
    DoubleBuffered := True;
    Parent := TeeBoxTitle;
    Caption := 'V';
    Height := 24;
    Width := 15;
    Align := alRight;
    AutoSize := False;
    ParentFont := False;
    ParentColor := False;
    Cursor := crHandPoint;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $003300F3;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := 9;
    Style.Font.Color := clWhite;
    Style.Font.Style := [fsBold];
    StyleDisabled.Color := clBtnFace;
  end;

  LRLabel := TcxLabel.Create(Self);
  with LRLabel do
  begin
    DoubleBuffered := True;
    Parent := TeeBoxTitle;
    Caption := 'L';
    Height := 24;
    Width := 15;
    Align := alLeft;
    AutoSize := False;
    ParentFont := False;
    ParentColor := False;
    Cursor := crHandPoint;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00B6752E;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := 9;
    Style.Font.Color := clWhite;
    Style.Font.Style := [fsBold];
    StyleDisabled.Color := clBtnFace;
  end;

  MemberLabel := TcxLabel.Create(Self);
  with MemberLabel do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Height := 24;
    Width := 49;
    Align := alTop;
    ParentFont := False;
    ParentColor := True;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    ShowHint := True;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00EAFFFF;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Style.Font.Color := clBlack;
    Style.Font.Style := [];
    StyleDisabled.Color := clBtnFace;
  end;

  RemainMinLabel := TcxLabel.Create(Self);
  with RemainMinLabel do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Height := 24;
    Width := 49;
    Align := alTop;
    ParentFont := False;
    ParentColor := True;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00FFFFFF;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvKind, lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Style.Font.Color := clBlack;
    Style.Font.Style := [fsBold];
    StyleDisabled.Color := clBtnFace;
  end;

  EndTimeLabel := TcxLabel.Create(Self);
  with EndTimeLabel do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Height := 24;
    Width := 49;
    Align := alTop;
    ParentFont := False;
    ParentColor := True;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00FFFFFF;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvKind, lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Style.Font.Color := clBlack;
    Style.Font.Style := [];
    StyleDisabled.Color := clBtnFace;
  end;

  ReservedLabel := TcxLabel.Create(Self);
  with ReservedLabel do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Height := 24;
    Width := 49;
    Top := EndTimeLabel.Top + 1;
    Align := alClient;
    ParentFont := False;
    ParentColor := True;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00FFFFFF;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvKind, lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Style.Font.Color := clBlack;
    Style.Font.Style := [];
    StyleDisabled.Color := clBtnFace;
  end;
end;

destructor TTeeBoxPanel.Destroy;
begin
  TeeBoxTitle.Free;
  MemberLabel.Free;
  RemainMinLabel.Free;
  EndTimeLabel.Free;
  ReservedLabel.Free;

  inherited;
end;

procedure TTeeBoxPanel.SetChecked(const AValue: Boolean);
begin
  FChecked := AValue;
  if AValue then
    Color := $0050C08B
  else
    Color := $00FFFFFF;
end;

procedure TTeeBoxPanel.SetControlYN(const AValue: Boolean);
begin
  FControlYN := AValue;
  if (not AValue) then
  begin
    VIPLabel.Visible := True;
    VIPLabel.Caption := 'H';
    VIPLabel.Style.Color := $007030A0;
  end;
end;

procedure TTeeBoxPanel.SetSelected(const AValue: Boolean);
begin
  FSelected := AValue;
  if not AValue then
    TeeBoxTitle.Font.Color := $00FFFFFF
  else
    TeeBoxTitle.Color := GCR_COLOR_HOLD_SELF;

  with TPluginMessage.Create(nil) do
  try
    Command := CPC_TEEBOX_SELECT;
//    AddParams(CPP_TEEBOX_INDEX, TeeBoxNo);
    AddParams(CPP_TEEBOX_INDEX, TeeBoxIndex);
    AddParams(CPP_TEEBOX_SELECTED, FSelected);
    PluginMessageToID(Global.SubMonitorId);
  finally
    Free;
  end;
end;

procedure TTeeBoxPanel.SetDeviceId(const AValue: string);
begin
  FDeviceId := AValue;
end;

procedure TTeeBoxPanel.SetEndTime(const AValue: string);
begin
  FEndTime := AValue;
  EndTimeLabel.Caption := AValue;
end;

procedure TTeeBoxPanel.SetReservedCount(const AValue: Integer);
begin
  FReservedCount := AValue;
end;

procedure TTeeBoxPanel.SetFloorCode(const AValue: string);
begin
  FFloorCode := AValue;
end;

procedure TTeeBoxPanel.SetRemainMin(const AValue: Integer);
begin
  FRemainMin := AValue;
end;

procedure TTeeBoxPanel.SetTeeBoxName(const AValue: string);
begin
  FTeeBoxName := AValue;
  TeeBoxTitle.Caption := AValue;
end;

procedure TTeeBoxPanel.SetTeeBoxNo(const AValue: Integer);
begin
  FTeeBoxNo := AValue;
end;

procedure TTeeBoxPanel.SetCurStatus(const AValue: Integer);
var
  sHintVip, sErrMsg: string;
begin
  if (FCurStatus <> AValue) then
    FOldStatus := CurStatus;
  FCurStatus := AValue;

  RemainMinLabel.Caption := '';
  EndTimeLabel.Caption := '';
  ReservedLabel.Caption := '';
  sHintVip := '';

  if VipYN then
    sHintVip := 'VIP' + _CRLF;

  try
    if not UseYN then
    begin
      MemberLabel.Caption := '사용불가';
      TeeBoxTitle.Hint := sHintVip + '사용불가';
      TeeBoxTitle.Color := GCR_COLOR_ERROR;
      Exit;
    end;

    case FCurStatus of
      CTS_TEEBOX_READY:
        begin
          MemberLabel.Caption := '';
          TeeBoxTitle.Hint := sHintVip + '예약가능';
          TeeBoxTitle.Color := GCR_COLOR_READY;
        end;
      CTS_TEEBOX_RESERVED,
      CTS_TEEBOX_USE:
        begin
          if (RemainMin <= Global.GameOverAlarmMin) then
          begin
            TeeBoxTitle.Hint := sHintVip + '사용중' + _CRLF + Format('%d분 이내 종료', [Global.GameOverAlarmMin]);
            TeeBoxTitle.Color := GCR_COLOR_SOON;
          end
          else
          begin
            TeeBoxTitle.Hint := sHintVip + '사용중' + _CRLF + '5분 이상 대기';
            TeeBoxTitle.Color := GCR_COLOR_WAIT;
          end;
          MemberLabel.Caption := MemberName;
          RemainMinLabel.Caption := Format('%d 분', [RemainMin]);
          EndTimeLabel.Caption := Format('%s', [EndTime]);
          if (ReservedCount > 0) then
            ReservedLabel.Caption := Format('%d 명', [ReservedCount]);
        end;
      CTS_TEEBOX_HOLD:
        begin
          MemberLabel.Caption := '임시예약';
          TeeBoxTitle.Hint := sHintVip + '임시예약';
          if Selected then
            TeeBoxTitle.Color := GCR_COLOR_HOLD_SELF
          else
            TeeBoxTitle.Color := GCR_COLOR_HOLD;
        end;
      CTS_TEEBOX_STOP_ALL:
        begin
          MemberLabel.Caption := '볼 회수';
          TeeBoxTitle.Hint := sHintVip + '볼 회수';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
          RemainMinLabel.Caption := Format('%d 분', [RemainMin]);
          EndTimeLabel.Caption := Format('%s', [EndTime]);
          if (ReservedCount > 0) then
            ReservedLabel.Caption := Format('%d 명', [ReservedCount]);
        end;
      CTS_TEEBOX_STOP:
        begin
          MemberLabel.Caption := '점검중';
          TeeBoxTitle.Hint := sHintVip + '점검중';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;
      CTS_TEEBOX_ERROR:
        case ErrorCode of
          CTS_TEEBOXAD_STOP_BALL:
            begin
              MemberLabel.Caption := '볼걸림';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_NO_BALL:
            begin
              MemberLabel.Caption := '볼없음';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_NO_AUTO:
            begin
              MemberLabel.Caption := '수동제어';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_MOTOR:
            begin
              MemberLabel.Caption := '모터이상';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_COM:
            begin
              MemberLabel.Caption := '통신이상';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_COM_ERROR:
            begin
              MemberLabel.Caption := '통신불량';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_CALL:
            begin
              MemberLabel.Caption := 'CALL';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
              ClientDM.DoAdminCall(FCurStatus,
                Format('%s 타석에서 점검을 요청하였습니다.', [TeeBoxTitle.Caption]), '타석기', sErrMsg);
            end;
          CTS_TEEBOXAD_ERROR_11:
            begin
              MemberLabel.Caption := '에러#11';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_ERROR_12:
            begin
              MemberLabel.Caption := '에러#12';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_ERROR_13:
            begin
              MemberLabel.Caption := '에러#13';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_ERROR_14:
            begin
              MemberLabel.Caption := '에러#14';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          CTS_TEEBOXAD_ERROR_15:
            begin
              MemberLabel.Caption := '에러#15';
              TeeBoxTitle.Color := GCR_COLOR_ERROR;
            end;
          else
            MemberLabel.Caption := '기기고장';
            TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;
      else
        MemberLabel.Caption := '사용불가';
        TeeBoxTitle.Hint := sHintVip + '사용불가(' + IntToStr(FCurStatus) + ')';
        TeeBoxTitle.Color := GCR_COLOR_ERROR;
    end;
  finally
    MemberLabel.Hint := MemberLabel.Caption;
  end;
end;

procedure TTeeBoxPanel.SetUseYN(const AValue: Boolean);
begin
  FUseYN := AValue;
  Self.Enabled := FUseYN;
  if not FUseYN then
  begin
    RemainMin := 0;
    EndTime := '';
  end;
end;

procedure TTeeBoxPanel.SetVipYN(const AValue: Boolean);
begin
  FVipYN := AValue;
  VIPLabel.Visible := FVipYN;
end;

procedure TTeeBoxPanel.SetZoneCode(const AValue: string);
begin
  FZoneCode := AValue;
  LRLabel.Visible :=
    (FZoneCode = CTZ_LEFT_RIGHT) or
    (FZoneCode = CTZ_LEFT) or
    (FZoneCode = CTZ_TRACKMAN) or
    (FZoneCode = CTZ_GDR) or
    (FZoneCode = CTZ_INDOOR);

  if LRLabel.Visible then
    if (FZoneCode = CTZ_LEFT_RIGHT) then
      LRLabel.Caption := 'D'
    else if (FZoneCode = CTZ_LEFT) then
      LRLabel.Caption := 'L'
    else if (FZoneCode = CTZ_SWING_ANALYZE) or
            (FZoneCode = CTZ_SWING_ANALYZE_2) then
      LRLabel.Caption := 'A'
    else if (FZoneCode = CTZ_TRACKMAN) then
      LRLabel.Caption := 'T'
    else if (FZoneCode = CTZ_GDR) then
      LRLabel.Caption := 'G'
    else if (FZoneCode = CTZ_INDOOR) then
      LRLabel.Caption := 'I'
    else if (FZoneCode = CTZ_VIP_COUPLE) then
      LRLabel.Caption := 'C'
    else if (FZoneCode = CTZ_SCREEN_INDOOR) or
            (FZoneCode = CTZ_SCREEN_OUTDOOR) then
      LRLabel.Caption := 'S'
    else
      LRLabel.Caption := '?';
end;

procedure TTeeBoxPanel.SetFontSizeAdjust(const AValue: Integer);
var
  nSize: Integer;
begin
  nSize := (LCN_TEEBOX_FONT_SIZE + AValue);
  MemberLabel.Style.Font.Size := nSize;
  RemainMinLabel.Style.Font.Size := nSize;
  EndTimeLabel.Style.Font.Size := nSize;
  ReservedLabel.Style.Font.Size := nSize;
end;

{ TQuickPanel }

constructor TQuickPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  DoubleBuffered := True;
  AutoSize := False;
  AlignWithMargins := True;
  BevelOuter := TBevelCut.bvNone;
  Caption := '';
  Color := clWhite;
  Height := 56;
  Width := 60;
  Margins.Top := 2;
  Margins.Left := 3;
  Margins.Bottom := 0;
  Margins.Right := 0;
  ParentBackground := False;

  TitleLabel := TLabel.Create(Self);
  with TitleLabel do
  begin
    Parent := Self;
    Height := 22;
    Width := 60;
    Align := TAlign.alTop;
    Alignment := TAlignment.taCenter;
    Layout := TTextLayout.tlCenter;
    Color := $00544ED6; //$005C5C5C; $00544ED6; $0045D10E;
    ParentColor := False;
    Transparent := False;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := clWhite; //$00FFFF80, $0080FFFF
  end;

  RemainMinLabel := TLabel.Create(Self);
  with RemainMinLabel do
  begin
    Parent := Self;
    Height := 34;
    Width := 60;
    Align := TAlign.alClient;
    Alignment := TAlignment.taCenter;
    Layout := TTextLayout.tlCenter;
    Color := clWhite;
    ParentColor := False;
    Transparent := False;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 11;
    Font.Color := clBlack;
    Font.Style := [fsBold];
  end;
end;

destructor TQuickPanel.Destroy;
begin

  inherited;
end;

procedure TQuickPanel.SetQuickInfo(const ATitle: string; const ARemainMin: Integer);
begin
  TitleLabel.Caption := ATitle;
  RemainMinLabel.Caption := IntToStr(ARemainMin);
end;

procedure TQuickPanel.Clear;
begin
  TitleLabel.Caption := '';
  RemainMinLabel.Caption := '';
end;

{ TBlinkerThread }

constructor TBlinkerThread.Create;
begin
  inherited Create(True);

  FRunning := False;
  FInterval := 300;
  FLastWorked := Now - 1;
  FBlinked := False;
end;

destructor TBlinkerThread.Destroy;
begin

  inherited;
end;

procedure TBlinkerThread.Execute;
begin
  repeat
    if (not FRunning) and
       (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FRunning := True;
      FLastWorked := Now;
      FBlinked := not FBlinked;
      try
        Synchronize(
          procedure
          var
            I: Integer;
          begin
            for I := 0 to Pred(FTeeBoxCount) do
            begin
              if Global.Closing then
                Break;

              if FTeeBoxPanels[I].Selected then
                FTeeBoxPanels[I].TeeBoxTitle.Font.Color := IIF(FBlinked, clGray, $00FFFFFF);
            end;
          end);
      finally
        FRunning := False;
      end;
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;

end.
