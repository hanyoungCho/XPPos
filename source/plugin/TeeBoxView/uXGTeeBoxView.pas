(*******************************************************************************

  Title       : Ÿ�� ���� ���� ȭ��
  Filename    : uXGTeeBoxView.pas
  Author      : �̼���
  Description :
    ...
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2016-10-25   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGTeeBoxView;

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
{$I ..\..\common\XGTeeBoxAgent.inc}

const
  LCN_MAX_FLOORS         = 5;
  LCN_QUICK_OF_FLOOR     = 5;
  LCN_FLOOR_PANEL_HEIGHT = 118;
  LCN_TEEBOX_FONT_SIZE   = 9;

type
  TListViewMode = (lvmTeeBox, lvmNoShow, lvmBunker);

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
    ReservedPanel: TPanel;
    LessonProColorLabel: TcxLabel;
    TeeBoxAgentStatusLabel: TcxLabel;
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
    FLessonProName: string;
    FLessonProColor: Integer;

    FRemainMin: Integer;
    FStartDateTime: TDateTime;
    FEndDateTime: TDateTime;
    FStartTime: string;
    FEndTime: string;
    FReservedCount: Integer;
    FMemo: string;
    FAirConYN: Boolean; //�ÿ�ǳ�� �۵� ����
    FControlYN: Boolean; //Auto Tee-up Ÿ�� ����: �ڵ�(Y), ����(N)
    FVipYN: Boolean;
    FUseYN: Boolean;
    FZoneCode: string;
    FTeeBoxAgentStatus: Integer; //�ǳ������� Ÿ���� ������Ʈ ����: Off(0), On(1)
    FCurStatus: Integer;
    FOldStatus: Integer;
    FErrorCode: Integer;
    FChecked: Boolean;
    FSelected: Boolean;

    procedure SetTeeBoxNo(const AValue: Integer);
    procedure SetDeviceId(const AValue: string);
    procedure SetTeeBoxName(const AValue: string);
    procedure SetFloorCode(const AValue: string);
    procedure SetRemainMin(const AValue: Integer);
    procedure SetEndTime(const AValue: string);
    procedure SetReservedCount(const AValue: Integer);
    procedure SetLessonProColor(const AValue: Integer);
    procedure SetLessonProName(const AValue: string);
    procedure SetAirConYN(const AValue: Boolean);
    procedure SetControlYN(const AValue: Boolean);
    procedure SetVipYN(const AValue: Boolean);
    procedure SetUseYN(const AValue: Boolean);
    procedure SetCurStatus(const AValue: Integer);
    procedure SetChecked(const AValue: Boolean);
    procedure SetSelected(const AValue: Boolean);
    procedure SetZoneCode(const AValue: string);
    procedure SetTeeBoxAgentStatus(const AValue: Integer);
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
    property LessonProName: string read FLessonProName write SetLessonProName;
    property LessonProColor: Integer read FLessonProColor write SetLessonProColor;

    property RemainMin: Integer read FRemainMin write SetRemainMin;
    property StartDateTime: TDateTime read FStartDateTime write FStartDateTime;
    property EndDateTime: TDateTime read FEndDateTime write FEndDateTime;
    property StartTime: string read FStartTime write FStartTime;
    property EndTime: string read FEndTime write SetEndTime;
    property ReservedCount: Integer read FReservedCount write SetReservedCount;
    property Memo: string read FMemo write FMemo;
    property AirConYN: Boolean read FAirConYN write SetAirConYN;
    property ControlYN: Boolean read FControlYN write SetControlYN;
    property VipYN: Boolean read FVipYN write SetVipYN;
    property UseYN: Boolean read FUseYN write SetUseYN;
    property ZoneCode: string read FZoneCode write SetZoneCode;
    property TeeBoxAgentStatus: Integer read FTeeBoxAgentStatus write SetTeeBoxAgentStatus;
    property CurStatus: Integer read FCurStatus write SetCurStatus;
    property OldStatus: Integer read FOldStatus write FOldStatus;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
    property Checked: Boolean read FChecked write SetChecked;
    property Selected: Boolean read FSelected write SetSelected;
    property FontSizeAdjust: Integer write SetFontSizeAdjust;
  end;

  TQuickPanel = class(TPanel)
    TeeBoxNoLabel: TLabel;
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
    panTeeBoxSelectedContainer: TPanel;
    imcDevieceStatus: TcxImageCollection;
    iciFingerPrintOn: TcxImageCollectionItem;
    iciFingerPrintOff: TcxImageCollectionItem;
    iciQRCodeOn: TcxImageCollectionItem;
    iciQRCodeOff: TcxImageCollectionItem;
    Panel1: TPanel;
    panTeeBoxSelectedGrid: TPanel;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3teebox_nm: TcxGridDBBandedColumn;
    V3vip_div: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    Panel7: TPanel;
    btnV3Up: TcxButton;
    btnV3Down: TcxButton;
    panMemberInfoContainer: TPanel;
    Panel4: TPanel;
    panTeeBox1: TPanel;
    _MemberLabel: TcxLabel;
    _RemainMinLabel: TcxLabel;
    _EndTimeLabel: TcxLabel;
    lblReservedCnt1: TcxLabel;
    _TeeBoxButton: TPanel;
    _LRLabel: TcxLabel;
    _VIPLabel: TcxLabel;
    btnSaleChangeReserved: TcyAdvSpeedButton;
    btnSaleTeeBoxPauseOrRestart: TcyAdvSpeedButton;
    btnSaleTeeBoxStoppedAll: TcyAdvSpeedButton;
    btnSaleTeeBoxReservedCancel: TcyAdvSpeedButton;
    btnSaleTeeBoxMove: TcyAdvSpeedButton;
    btnSaleLocker: TcyAdvSpeedButton;
    btnSaleMemberSearchAndEdit: TcyAdvSpeedButton;
    btnSaleMemberAdd: TcyAdvSpeedButton;
    btnSaleTicketMember: TcyAdvSpeedButton;
    btnSaleTicketDaily: TcyAdvSpeedButton;
    btnSaleMemberClear: TcyAdvSpeedButton;
    btnShowSalePOS: TcyAdvSpeedButton;
    Label1: TLabel;
    edtMemberName: TcxTextEdit;
    Label2: TLabel;
    edtMemberHpNo: TcxTextEdit;
    Label3: TLabel;
    edtMemberCarNo: TcxTextEdit;
    Label4: TLabel;
    lblMemberLockerList: TcxLabel;
    Label5: TLabel;
    lblMemberSex: TcxLabel;
    ckbMemberXGolf: TcxCheckBox;
    Panel2: TPanel;
    Panel3: TPanel;
    trbPrepareMin: TcxTrackBar;
    btnSaleTeeBoxClearance: TcyAdvSpeedButton;
    Panel6: TPanel;
    Label7: TLabel;
    edtPrepareMin: TcxSpinEdit;
    Panel8: TPanel;
    btnTeeBoxDeleteHold: TcyAdvSpeedButton;
    btnTeeBoxClearHold: TcyAdvSpeedButton;
    panBasePanel: TPanel;
    btnAirConditioner: TAdvShapeButton;
    btnHome: TAdvShapeButton;
    btnPartnerCenter: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    panHeaderTools: TPanel;
    lblMemberLockerExpired: TcxLabel;
    Label9: TLabel;
    Panel9: TPanel;
    ledPlayingCount: TLEDFontNum;
    ledWaitingCount: TLEDFontNum;
    ledReadyCount: TLEDFontNum;
    tmrClock: TTimer;
    ledStoreEndTime: TLEDFontNum;
    panReservedInfoContainer: TPanel;
    panTeeBoxReserveToolbar: TPanel;
    btnTeeBoxFilterClear: TcxButton;
    btnTeeBoxTicketReprint: TcxButton;
    btnTeeBoxHoldForceCancel: TcxButton;
    btnTeeBoxImmediateStart: TcxButton;
    btnTeeBoxReceiptRePrint: TcxButton;
    panTeeBoxQuickView: TPanel;
    TemplateTeeBoxQuickPanel: TPanel;
    TemplateTeeBoxQuickTitleLabel: TLabel;
    TemplateTeeBoxQuickRemainLabel: TLabel;
    spvACS: TSplitView;
    Panel10: TPanel;
    G4: TcxGrid;
    V4: TcxGridDBBandedTableView;
    L4: TcxGridLevel;
    V4recv_hp_no: TcxGridDBBandedColumn;
    V4calc_send_div: TcxGridDBBandedColumn;
    Label15: TLabel;
    Panel11: TPanel;
    btnACSCall: TcxButton;
    btnACSRefresh: TcxButton;
    btnACSConfig: TcxButton;
    btnACSHistory: TcxButton;
    panTeeBoxFloor1: TPanel;
    panFloorName1: TPanel;
    panTeeBoxFloor4: TPanel;
    panFloorName4: TPanel;
    pmnTeeBoxView: TAdvPopupMenu;
    pmnReserveList: TAdvPopupMenu;
    N2: TMenuItem;
    mnuSaleTicketDaily: TMenuItem;
    mnuSaleTicketMember: TMenuItem;
    mnuSaleTeeBoxMove: TMenuItem;
    mnuSaleChangeReserved: TMenuItem;
    mnuSaleTeeBoxReservedCancel: TMenuItem;
    mnuSaleTeeBoxPause: TMenuItem;
    lblTeeBoxQuickTitle: TLabel;
    btnSaleReceiptView: TcyAdvSpeedButton;
    panReserveListTitle: TPanel;
    btnTeeBoxReserveList: TcyAdvSpeedButton;
    btnBunkerList: TcyAdvSpeedButton;
    panBunkerReserveToolbar: TPanel;
    btnBunkerReserveRefresh: TcxButton;
    btnBunkerTicketRePrint: TcxButton;
    btnBunkerReservedCancel: TcxButton;
    btnBunkerReserveChange: TcxButton;
    btnBunkerReceiptRePrint: TcxButton;
    btnACS: TcyAdvSpeedButton;
    Bevel2: TBevel;
    Bevel1: TBevel;
    mnuSaleTeeBoxHold: TMenuItem;
    mnuSaleTeeBoxReserveList: TMenuItem;
    panTeeBoxNoShowListToolbar: TPanel;
    btnNoShowRefreshList: TcxButton;
    btnNoShowTicketMember: TcxButton;
    btnNoShowTicketDaily: TcxButton;
    btnTeeBoxNoShowList: TcyAdvSpeedButton;
    mnuSaleCheckinMobileReserved: TMenuItem;
    mnuSaleTicketMemberTeleReserved: TMenuItem;
    edtSearchName: TcxTextEdit;
    Image1: TImage;
    btnShowMemberInfo: TcxButton;
    btnCouponCard: TcxButton;
    N3: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    btnQRCodeCheckIn: TcxButton;
    btnNoShowTicketMemberTeleReserved: TcxButton;
    N5: TMenuItem;
    mnuTeeBoxAgent: TMenuItem;
    mnuTeeBoxAgentShutdown: TMenuItem;
    mnuTeeBoxAgentReboot: TMenuItem;
    mnuTeeBoxAgentUpdate: TMenuItem;
    mnuTeeBoxAgentClose: TMenuItem;
    G1: TcxGrid;
    V1TeeBox: TcxGridDBBandedTableView;
    V1TeeBoxcalc_play_yn: TcxGridDBBandedColumn;
    V1TeeBoxmember_nm: TcxGridDBBandedColumn;
    V1TeeBoxreserve_root_div: TcxGridDBBandedColumn;
    V1TeeBoxcalc_reserve_div: TcxGridDBBandedColumn;
    V1TeeBoxproduct_nm: TcxGridDBBandedColumn;
    V1TeeBoxfloor_cd: TcxGridDBBandedColumn;
    V1TeeBoxteebox_nm: TcxGridDBBandedColumn;
    V1TeeBoxcalc_reserve_time: TcxGridDBBandedColumn;
    V1TeeBoxcalc_start_time: TcxGridDBBandedColumn;
    V1TeeBoxcalc_end_time: TcxGridDBBandedColumn;
    V1TeeBoxprepare_min: TcxGridDBBandedColumn;
    V1TeeBoxassign_min: TcxGridDBBandedColumn;
    V1TeeBoxcalc_remain_min: TcxGridDBBandedColumn;
    V1TeeBoxhp_no: TcxGridDBBandedColumn;
    V1TeeBoxreserve_move_yn: TcxGridDBBandedColumn;
    V1TeeBoxteebox_no: TcxGridDBBandedColumn;
    V1TeeBoxplay_yn: TcxGridDBBandedColumn;
    V1TeeBoxreceipt_no: TcxGridDBBandedColumn;
    V1Bunker: TcxGridDBBandedTableView;
    V1BunkerColumn1: TcxGridDBBandedColumn;
    V1BunkerColumn2: TcxGridDBBandedColumn;
    V1BunkerColumn3: TcxGridDBBandedColumn;
    V1BunkerColumn4: TcxGridDBBandedColumn;
    V1BunkerColumn5: TcxGridDBBandedColumn;
    V1BunkerColumn6: TcxGridDBBandedColumn;
    V1BunkerColumn7: TcxGridDBBandedColumn;
    V1BunkerColumn8: TcxGridDBBandedColumn;
    V1BunkerColumn9: TcxGridDBBandedColumn;
    V1BunkerColumn10: TcxGridDBBandedColumn;
    V1BunkerColumn11: TcxGridDBBandedColumn;
    V1NoShow: TcxGridDBBandedTableView;
    V1NoShowcalc_reserve_div: TcxGridDBBandedColumn;
    V1NoShowcalc_reserve_root_div: TcxGridDBBandedColumn;
    V1NoShowfloor_cd: TcxGridDBBandedColumn;
    V1NoShowteebox_nm: TcxGridDBBandedColumn;
    V1NoShowproduct_nm: TcxGridDBBandedColumn;
    V1NoShowprepare_min: TcxGridDBBandedColumn;
    V1NoShowassign_min: TcxGridDBBandedColumn;
    V1NoShowcalc_reserve_time: TcxGridDBBandedColumn;
    V1NoShowcalc_start_time: TcxGridDBBandedColumn;
    V1NoShowcalc_end_time: TcxGridDBBandedColumn;
    V1NoShowmember_nm: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    Panel5: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    panHeaderInfo: TPanel;
    lblPluginVersion: TLabel;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    panWeather: TPanel;
    lblPOSInfo: TLabel;
    btnWeather: TAdvShapeButton;
    N6: TMenuItem;
    mnuTeeBoxProjectorOn: TMenuItem;
    mnuTeeBoxProjectorOff: TMenuItem;
    N9: TMenuItem;
    N7: TMenuItem;
    mnuTeeBoxSmartPlugOn: TMenuItem;
    mnuTeeBoxSmartPlugOff: TMenuItem;
    mnuTeeBoxWakeOnLAN: TMenuItem;
    mnuSaleImmediateStart: TMenuItem;
    N8: TMenuItem;
    mmoMemberMemo: TcxMemo;
    pmnNoShowList: TAdvPopupMenu;
    mnuNoShowTicketDaily: TMenuItem;
    mnuNoShowTicketMember: TMenuItem;
    mnuNoShowTicketMemberTeleReserved: TMenuItem;
    MenuItem3: TMenuItem;
    mnuNoShowRefreshList: TMenuItem;

    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnHomeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure btnSaleTicketDailyClick(Sender: TObject);
    procedure btnSaleTicketMemberClick(Sender: TObject);
    procedure btnSaleMemberAddClick(Sender: TObject);
    procedure btnSaleMemberSearchAndEditClick(Sender: TObject);
    procedure btnSaleLockerClick(Sender: TObject);
    procedure btnSaleTeeBoxMoveClick(Sender: TObject);
    procedure btnSaleTeeBoxReservedCancelClick(Sender: TObject);
    procedure btnSaleTeeBoxStoppedAllClick(Sender: TObject);
    procedure btnSaleTeeBoxPauseOrRestartClick(Sender: TObject);
    procedure btnSaleChangeReservedClick(Sender: TObject);
    procedure btnTeeBoxClearHoldClick(Sender: TObject);
    procedure OnGridCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure GridCustomDrawFooterCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure GridCustomDrawPartBackground(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridCellViewInfo; var ADone: Boolean);
    procedure V1TeeBoxCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V3DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure btnSaleMemberClearClick(Sender: TObject);
    procedure btnShowSalePOSClick(Sender: TObject);
    procedure btnTeeBoxDeleteHoldClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure btnPartnerCenterClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTeeBoxFilterClearClick(Sender: TObject);
    procedure trbPrepareMinPropertiesChange(Sender: TObject);
    procedure btnCouponCardClick(Sender: TObject);
    procedure edtPrepareMinPropertiesChange(Sender: TObject);
    procedure btnTeeBoxTicketReprintClick(Sender: TObject);
    procedure btnAirConditionerClick(Sender: TObject);
    procedure btnSaleTeeBoxClearanceClick(Sender: TObject);
    procedure PluginModuleShow(Sender: TObject);
    procedure btnTeeBoxHoldForceCancelClick(Sender: TObject);
    procedure btnTeeBoxImmediateStartClick(Sender: TObject);
    procedure btnTeeBoxReceiptRePrintClick(Sender: TObject);
    procedure btnACSClick(Sender: TObject);
    procedure btnACSCallClick(Sender: TObject);
    procedure btnACSConfigClick(Sender: TObject);
    procedure btnACSRefreshClick(Sender: TObject);
    procedure btnACSHistoryClick(Sender: TObject);
    procedure pmnReserveListPopup(Sender: TObject);
    procedure pmnReserveListClose(Sender: TObject);
    procedure btnSaleReceiptViewClick(Sender: TObject);
    procedure btnTeeBoxReserveListClick(Sender: TObject);
    procedure btnBunkerListClick(Sender: TObject);
    procedure pmnTeeBoxViewPopup(Sender: TObject);
    procedure mnuSaleTeeBoxReserveListClick(Sender: TObject);
    procedure mnuSaleTeeBoxHoldClick(Sender: TObject);
    procedure mnuSaleTicketDailyClick(Sender: TObject);
    procedure mnuSaleTicketMemberClick(Sender: TObject);
    procedure mnuSaleTeeBoxPauseClick(Sender: TObject);
    procedure mnuSaleTeeBoxMoveClick(Sender: TObject);
    procedure mnuSaleChangeReservedClick(Sender: TObject);
    procedure mnuSaleTeeBoxReservedCancelClick(Sender: TObject);
    procedure btnTeeBoxNoShowListClick(Sender: TObject);
    procedure btnNoShowTicketDailyClick(Sender: TObject);
    procedure btnNoShowTicketMemberClick(Sender: TObject);
    procedure btnNoShowRefreshListClick(Sender: TObject);
    procedure btnBunkerReserveChangeClick(Sender: TObject);
    procedure btnBunkerReservedCancelClick(Sender: TObject);
    procedure btnBunkerTicketRePrintClick(Sender: TObject);
    procedure btnBunkerReceiptRePrintClick(Sender: TObject);
    procedure btnBunkerReserveRefreshClick(Sender: TObject);
    procedure mnuNoShowRefreshListClick(Sender: TObject);
    procedure mnuNoShowTicketDailyClick(Sender: TObject);
    procedure mnuNoShowTicketMemberClick(Sender: TObject);
    procedure pmnNoShowListPopup(Sender: TObject);
    procedure pmnNoShowListClose(Sender: TObject);
    procedure mnuSaleCheckinMobileReservedClick(Sender: TObject);
    procedure mnuSaleTicketMemberTeleReservedClick(Sender: TObject);
    procedure mnuNoShowTicketMemberTeleReservedClick(Sender: TObject);
    procedure edtSearchNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtSearchNameEnter(Sender: TObject);
    procedure btnShowMemberInfoClick(Sender: TObject);
    procedure edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberCarNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnQRCodeCheckInClick(Sender: TObject);
    procedure btnNoShowTicketMemberTeleReservedClick(Sender: TObject);
    procedure mnuTeeBoxAgentShutdownClick(Sender: TObject);
    procedure mnuTeeBoxAgentRebootClick(Sender: TObject);
    procedure mnuTeeBoxAgentUpdateClick(Sender: TObject);
    procedure mnuTeeBoxAgentCloseClick(Sender: TObject);
    procedure btnWeatherClick(Sender: TObject);
    procedure mnuTeeBoxProjectorOnClick(Sender: TObject);
    procedure mnuTeeBoxProjectorOffClick(Sender: TObject);
    procedure mnuTeeBoxSmartPlugOnClick(Sender: TObject);
    procedure mnuTeeBoxSmartPlugOffClick(Sender: TObject);
    procedure mnuTeeBoxWakeOnLANClick(Sender: TObject);
    procedure mnuSaleImmediateStartClick(Sender: TObject);
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
    FTeeBoxListViewTitle: string;
    FTeeBoxListViewTitleColor: TColor;
    FListViewMode: TListViewMode;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure CloseAction(const AEmergencyChanged: Boolean=False);
    procedure RefreshTeeBoxLayout;
    procedure RefreshTeeBoxStatus;
    procedure UpdateCurrentWeather;
    function IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
    procedure DispMemberInfo;
    function CheckSelectedTeeBox(const ATitle: string): Boolean;
    procedure ClearTeeBoxSelection(const AUpdateToServer, AClearAll: Boolean);
    procedure SetCurrentTeeBoxIndex(const AIndex: Integer);
    procedure SetStoppedAll(const AStopped: Boolean);
    procedure SetListViewTitle(const AValue: string);
    procedure SetListViewTitleColor(const AColor: TColor);
    procedure DoTeeBoxTicketDaily;
    procedure DoTeeBoxTicketMember(const ATeleReserved: Boolean);
    procedure DoSaleReceiptView;
    procedure DoMemberAdd;
    procedure DoMemberSearchAndEdit;
    procedure DoLockerView;
    procedure DoTeeBoxReservedMove;
    procedure DoTeeBoxReservedChange;
    procedure DoTeeBoxReservedCancel;
    procedure DoTeeBoxPauseorRestart;
    procedure DoTeeBoxClearance;
    procedure DoTeeBoxStoppedAll;
    procedure DoTeeBoxImmediateStart;
    procedure DoRefreshNoShowList;
    procedure DoReserveNoShowTicketDaily;
    procedure DoReserveNoShowTicketMember(const ATeleReserved: Boolean);
    procedure DoCheckinMobileReserved;
    procedure DoCheckinQRCodeMobileReserved(const AMemberQRCode: string);
    function DoTeeBoxTicketReprint(var AErrMsg: string): Boolean;
    procedure DoMemberSearchNew(const AMemberName, AHpNo, ACarNo: string);
    procedure DoTeeBoxClearHold;
    procedure DoTeeBoxReserveMember(const AProductCode, AProductDiv, AProductName, APurchaseCode, AAvailZoneCode: string; const AProductMin: Integer);
    procedure DoTeeBoxFilter;
    procedure DoTeeBoxFilterClear;
    procedure DoTeeBoxReservedListView(const ATeeBoxIndex: Integer);
    function DoTeeBoxHoldByIndex(const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;
    function SetTeeBoxHoldByIndex(const AUseHold: Boolean; const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;

    procedure SetListViewMode(const AValue: TListViewMode);
    procedure DoTeeBoxAgentControl(const AMethod: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    procedure SelectTeeBoxByIndex(const AIndex: Integer);
    procedure OnTeeBoxBodyClick(Sender: TObject);
    procedure OnTeeBoxHeaderClick(Sender: TObject);
    procedure OnTeeBoxHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnTeeBoxHeaderDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnTeeBoxHeaderDragDrop(Sender, Source: TObject; X, Y: Integer);

    property CurrentTeeBoxIndex: Integer read FCurrentTeeBoxIndex write SetCurrentTeeBoxIndex;
    property StoppedAll: Boolean read FStoppedAll write SetStoppedAll;
    property ListViewMode: TListViewMode read FListViewMode write SetListViewMode;
    property ListViewTitle: string write SetListViewTitle;
    property ListViewTitleColor: TColor write SetListViewTitleColor;
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
  uXGTeeBoxMoveDragDrop;

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

  ListViewMode := TListViewMode.lvmTeeBox;
  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';

  btnTeeBoxReserveList.Down := True; //Ÿ��������Ȳ
  btnTeeBoxNoShowList.Enabled := True;
  btnBunkerList.Enabled := False; //�̱���
  panTeeBoxNoShowListToolbar.Visible := False;
  panBunkerReserveToolbar.Visible := False;

  FTeeBoxListViewTitle := panReserveListTitle.Caption;
  FTeeBoxListViewTitleColor := clWhite;

  UpdateCurrentWeather;
  panWeather.Visible := Global.WeatherInfo.Enabled;
  btnAirConditioner.Visible := Global.AirConditioner.Enabled;
  btnTeeBoxImmediateStart.Visible := Global.ImmediateTeeBoxAssign;
  edtPrepareMin.Value := Global.PrepareMin;
  trbPrepareMin.Position := Global.PrepareMin;
  panTeeBoxQuickView.Visible := Global.TeeBoxQuickView;
  ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
  L1.GridView := V1TeeBox;

  spvACS.Visible := SaleManager.StoreInfo.UseAcsYN;
  btnACS.Visible := SaleManager.StoreInfo.UseAcsYN;
  if SaleManager.StoreInfo.UseAcsYN then
    panReservedInfoContainer.Margins.Right := 0;
  if spvACS.Opened then
    spvACS.Close;

  nButtonWidth := (panFooter.Width div 14) - 5;
  btnSaleTicketDaily.Width := nButtonWidth;
  btnSaleTicketMember.Width := nButtonWidth;
  btnSaleReceiptView.Width := nButtonWidth;
  btnSaleMemberAdd.Width := nButtonWidth;
  btnSaleMemberSearchAndEdit.Width := nButtonWidth;
  btnSaleMemberClear.Width := nButtonWidth;
  btnSaleLocker.Width := nButtonWidth;
  btnSaleTeeBoxReservedCancel.Width := nButtonWidth;
  btnSaleTeeBoxMove.Width := nButtonWidth;
  btnSaleChangeReserved.Width := nButtonWidth;
  btnSaleTeeBoxPauseOrRestart.Width := nButtonWidth;
  btnSaleTeeBoxClearance.Width := nButtonWidth;
  btnSaleTeeBoxStoppedAll.Width := nButtonWidth;
  btnShowSalePOS.Width := nButtonWidth;

  btnSaleTicketDaily.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnSaleTicketMember.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnSaleLocker.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnSaleTeeBoxStoppedAll.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnTeeBoxNoShowList.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);
  btnBunkerList.Enabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX);

  with V1TeeBox do
    OptionsBehavior.IncSearchItem := Items[GetColumnByFieldName('member_nm').Index];

  FTeeBoxCount := 0;
  FFloorCount := Length(Global.TeeBoxFloorInfo);
  SetLength(FTeeBoxFloors, FFloorCount);

  nRequireWidth := (panFloorName1.Width + panTeeBoxFloor1.Margins.Left + panTeeBoxFloor1.Margins.Right);
  nRangeWidth := (Global.ScreenInfo.BaseWidth - nRequireWidth);
  nTeeBoxWidth := (nRangeWidth div Global.TeeBoxMaxCountOfFloors);
  nTitleWidth := panFloorName1.Width + (nRangeWidth - (nTeeBoxWidth * Global.TeeBoxMaxCountOfFloors));

  //���� ��ü ����
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

  //������� �ʴ� �� �г� �����
  for nRow := 1 to LCN_MAX_FLOORS do
    if (nRow > FFloorCount) then
      TPanel(FindComponent('panTeeBoxFloor' + IntToStr(nRow))).Visible := False;

  //Ÿ���� ��ü ����
  nStart := 0;
  nQuick := 0;
  SetLength(FQuickPanels, LCN_QUICK_OF_FLOOR * FFloorCount);
  SetLength(FTeeBoxPanels, FTeeBoxCount);

  LockWindowUpdate(Self.Handle);
  try
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

          ReservedPanel.Tag := nIndex;
          ReservedPanel.OnClick := OnTeeBoxBodyClick;
          LessonProColorLabel.Tag := nIndex;
          LessonProColorLabel.OnClick := OnTeeBoxBodyClick;
          TeeBoxAgentStatusLabel.Tag := nIndex;
          TeeBoxAgentStatusLabel.OnClick := OnTeeBoxBodyClick;
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
          FQuickPanels[nQuick].TeeBoxNoLabel.Caption := IntToStr(nQuick + 1);
          if (nRow mod 2 <> 0) then
            FQuickPanels[nQuick].TeeBoxNoLabel.Font.Color := clYellow;

          nLeft := FQuickPanels[nQuick].Left + FQuickPanels[nQuick].Width;
          Inc(nQuick);
        end;
      end;
    end;

    RefreshTeeBoxLayout;
    RefreshTeeBoxStatus;
  finally
    LockWindowUpdate(0);
  end;

  //���� Ÿ�� ����
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

  tmrClock.Interval := 100;
  tmrClock.Enabled := True;
end;

destructor TXGTeeBoxViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxViewForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
  Global.DeviceConfig.RFIDReader.OwnerId := Self.PluginID;
  lblPOSInfo.Caption := Format('|  %s / %s', [SaleManager.StoreInfo.POSName, SaleManager.UserInfo.UserName]);
  panFooter.SetFocus;
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
  btnV3Up.Height := (G3.Height div 2);

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

procedure TXGTeeBoxViewForm.pmnNoShowListClose(Sender: TObject);
begin
  Global.TeeBoxStatusWorking := False;
  ClientDM.SPTeeBoxNoShowList.EnableControls;
end;

procedure TXGTeeBoxViewForm.pmnNoShowListPopup(Sender: TObject);
var
  bEnabled: Boolean;
begin
  Global.TeeBoxStatusWorking := True;
  with ClientDM.SPTeeBoxNoShowList do
  begin
    bEnabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and (RecordCount > 0);
    DisableControls;
    mnuNoShowTicketDaily.Enabled := bEnabled;
    mnuNoShowTicketMember.Enabled := bEnabled;
    mnuNoShowTicketMemberTeleReserved.Enabled := bEnabled and Global.UseTeeBoxTeleReserved;
  end;
end;

procedure TXGTeeBoxViewForm.pmnReserveListClose(Sender: TObject);
begin
  Global.TeeBoxStatusWorking := False;
  ClientDM.MDTeeBoxReserved2.EnableControls;
end;

procedure TXGTeeBoxViewForm.pmnReserveListPopup(Sender: TObject);
var
  bEnabled, bCheckIn: Boolean;
  sReserveDiv: string;
begin
  Global.TeeBoxStatusWorking := True;
  with ClientDM.MDTeeBoxReserved2 do
  begin
    DisableControls;
    bEnabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and (RecordCount > 0);
    bCheckIn := FieldByName('assign_yn').AsBoolean;
    sReserveDiv := FieldByName('reserve_root_div').AsString;
    mnuSaleTeeBoxMove.Enabled := bEnabled;
    mnuSaleChangeReserved.Enabled := bEnabled;
    mnuSaleTeeBoxReservedCancel.Enabled := bEnabled;
    mnuSaleCheckinMobileReserved.Enabled := bEnabled and Global.UseTeeBoxTeleReserved and
      (not bCheckIn) and ((sReserveDiv = CCT_MOBILE) or (sReserveDiv = CCT_TELE_RESERVED));
  end;
end;

procedure TXGTeeBoxViewForm.pmnTeeBoxViewPopup(Sender: TObject);
var
  nIndex: Integer;
  bEnabled: Boolean;
begin
  nIndex := TAdvPopupMenu(Sender).PopupComponent.Tag;
  bEnabled := (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and
              (not Global.TeeBoxHoldWorking);
  mnuSaleImmediateStart.Enabled := (FTeeBoxPanels[nIndex].CurStatus = CTS_TEEBOX_RESERVED);
  mnuSaleTeeBoxHold.Caption := '�ӽ� ����' + IIF(FTeeBoxPanels[nIndex].CurStatus = CTS_TEEBOX_HOLD, ' ���', '');
  mnuSaleTicketDaily.Enabled := bEnabled;
  mnuSaleTicketMember.Enabled := bEnabled;
  mnuSaleTeeBoxHold.Enabled := bEnabled;
  mnuSaleTicketMemberTeleReserved.Enabled := bEnabled and Global.UseTeeBoxTeleReserved;
  mnuTeeBoxAgent.Enabled := (SaleManager.StoreInfo.OutdoorDiv = CGD_INDOOR);
  if bEnabled then
    SelectTeeBoxByIndex(nIndex);
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
  if CanClose then
  begin
    if (Global.AdminCallHandle <> 0) then
      SendMessage(Global.AdminCallHandle, WM_CLOSE, 0, 0);
  end;
end;

procedure TXGTeeBoxViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not ((ssAlt in Shift) or
          (ssCtrl in Shift) or
          (ssShift in Shift)) then
  begin
    case Key of
      VK_F1:
        //DoSaleTicketDaily(False); //����=False
        btnSaleTicketDaily.Click;
      VK_F2:
        //DoSaleTicketMember(False, False); //��ȭ����=False, ����=False
        btnSaleTicketMember.Click;
      VK_F3:
        btnSaleReceiptView.Click;
      VK_F4:
        //DoMemberAdd;
        btnSaleMemberAdd.Click;
      VK_F5:
        //DoMemberSearchAndEdit;
        btnSaleMemberSearchAndEdit.Click;
      VK_F6:
        //ClientDM.ClearMemberInfo;
        //DispMemberInfo;
        btnSaleMemberClear.Click;
      VK_F7:
        //DoLockerView;
        btnSaleLocker.Click;
      VK_F8:
        //DoSaleTeeBoxReservedCancel;
        btnSaleTeeBoxReservedCancel.Click;
      VK_F9:
        //DoSaleTeeBoxMove;
        btnSaleTeeBoxMove.Click;
      VK_F10:
        //DoSaleChangeReserved;
        btnSaleChangeReserved.Click;
      VK_F11:
        //DoSaleTeeBoxPause;
        btnSaleTeeBoxPauseOrRestart.Click;
      VK_F12:
        //ShowSalePos(Self.PluginID);
        btnShowSalePOS.Click;
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
  sValue, sErrMsg: string;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    lblPOSInfo.Caption := Format('%s / %s  |', [AMsg.ParamByString(CPP_POS_NAME), AMsg.ParamByString(CPP_USER_NAME)]);
  end;

  if (AMsg.Command = CPC_CLOSE) then
    CloseAction;

  if (AMsg.Command = CPC_TEEBOX_EMERGENCY) and
     AMsg.ParamByBoolean(CPP_ACTIVE) then
    CloseAction(True);

  if (AMsg.Command = CPC_SET_FOREGROUND) then
    if (GetForegroundWindow <> Self.Handle) then
      SetForegroundWindow(Self.Handle);

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
    ledStoreEndTime.Text := SaleManager.StoreInfo.StoreEndTime;
  end;

  //XGOLF ȸ�� ����
  if (AMsg.Command = CPC_SEND_QRCODE_XGOLF) then
  begin
    if (XGMsgBox(Self.Handle, mtConfirmation, 'XGOLF ȸ�� ����',
          'XGOLF QR�ڵ尡 �νĵǾ����ϴ�!' + _CRLF +
          'XGOLF ȸ�� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
      Exit;

    sValue := AMsg.ParamByString(CPP_QRCODE);
    if not ClientDM.CheckXGolfMemberNew(CVT_XGOLF_QRCODE, sValue, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', 'XGOLF ȸ�� ������ �����Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

    ClientDM.ClearMemberInfo(Global.SaleFormId);
    if not ClientDM.SearchMemberByCode(CMC_XGOLF_QRCODE, sValue, sErrMsg) then
    begin
      if (XGMsgBox(Self.Handle, mtConfirmation, '��ȸ�� XGOLF ����',
          '�νĵ� XGOLF QR�ڵ�� �츮 ������ ȸ���� �ƴմϴ�.' + _CRLF +
          'XGOLF ���� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
        Exit;

      SaleManager.MemberInfo.XGolfMemberNo := sValue;
    end;

    DispMemberInfo;
  end;

  //ȸ�� �˻�
  if (AMsg.Command = CPC_SEND_QRCODE_MEMBER) or
     (AMsg.Command = CPC_SEND_MSCARD_MEMBER) then
  begin
    if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
       (XGMsgBox(Self.Handle, mtConfirmation, 'ȸ�� �˻�',
          'ȸ�� QR�ڵ尡 �νĵǾ����ϴ�!' + _CRLF +
          'ȸ�� ������ ��˻��Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
      Exit;

    sValue := AMsg.ParamByString(CPP_QRCODE);
    if not ClientDM.SearchMemberByCode(CMC_MEMBER_QRCODE, sValue, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', 'XGOLF ȸ�� ������ �����Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

    DispMemberInfo;
  end;

  //����� ī���ȣ�� ȸ�� �˻�
  if (AMsg.Command = CPC_SEND_RFID_DATA) then
  begin
    if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
       (XGMsgBox(Self.Handle, mtConfirmation, 'ȸ�� �˻�',
          '����� ī���ȣ�� �ν� �Ǿ����ϴ�!' + _CRLF +
          'ȸ�� ������ ��˻� �Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
      Exit;

    sValue := AMsg.ParamByString(CPP_MEMBER_CARD_UID);
    if not ClientDM.SearchMemberByCode(CMC_MEMBER_CARD_UID, sValue, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�', '��ġ�ϴ� ȸ�� ������ �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

    DispMemberInfo;
  end;

  if (AMsg.Command = CPC_SEND_MEMBER_NO) or
     (AMsg.Command = CPC_SEND_MEMBER_CLEAR) then
    DispMemberInfo;

  //ȸ�� ������ǰ ��ȸ ȭ�鿡�� ��ǰ�� ������ ���
  if (AMsg.Command = CPC_SEND_TEEBOX_PURCHASE_CD) then
  begin
    if (GetForegroundWindow <> Self.Handle) then
      SetForegroundWindow(Self.Handle);

    if AMsg.ParamByBoolean(CPP_TEEBOX_RESERVED) then
      DoTeeBoxReserveMember(
        AMsg.ParamByString(CPP_PRODUCT_CD),
        AMsg.ParamByString(CPP_PRODUCT_DIV),
        AMsg.ParamByString(CPP_PRODUCT_NAME),
        AMsg.ParamByString(CPP_PURCHASE_CD),
        AMsg.ParamByString(CPP_AVAIL_ZONE_CD),
        AMsg.ParamByInteger(CPP_ASSIGN_MIN));
  end;

  //����� ���� QR�ڵ� üũ��
  if (AMsg.Command = CPC_SEND_QRCODE_CHECKIN) then
  begin
    sValue := AMsg.ParamByString(CPP_QRCODE); //������ ȸ��QR�ڵ�
    DoCheckinQRCodeMobileReserved(sValue);
  end;

  if (AMsg.Command = CPC_APPLY_CONFIG) then
  begin
    nValue := AMsg.ParamByInteger(CPP_FONT_SIZE_ADJUST);
    for I := 0 to Pred(FTeeBoxCount) do
      FTeeBoxPanels[I].FontSizeAdjust := nValue;
  end;

  if (AMsg.Command = CPC_WEATHER_REFRESH) then
    UpdateCurrentWeather;
end;

procedure TXGTeeBoxViewForm.SetCurrentTeeBoxIndex(const AIndex: Integer);
begin
  FCurrentTeeBoxIndex := AIndex;
end;

procedure TXGTeeBoxViewForm.SetListViewMode(const AValue: TListViewMode);
begin
  FListViewMode := AValue;
  case FListViewMode of
    TListViewMode.lvmTeeBox:
    begin
      Global.NoShowInfo.NoShowReserved := False;
      ListViewTitle := FTeeBoxListViewTitle;
      ListViewTitleColor := FTeeBoxListViewTitleColor;
      panTeeBoxNoShowListToolbar.Visible := False;
      panBunkerReserveToolbar.Visible := False;
      panTeeBoxReserveToolbar.Visible := True;
      btnSaleTicketDaily.Enabled := True;
      btnSaleTicketMember.Enabled := True;
      btnSaleTeeBoxReservedCancel.Enabled := True;
      btnSaleTeeBoxMove.Enabled := True;
      btnSaleChangeReserved.Enabled := True;
      L1.GridView := V1TeeBox;
    end;

    TListViewMode.lvmNoShow:
    begin
      Global.NoShowInfo.NoShowReserved := True;
      ListViewTitle := ' �ճ��/��� ��Ȳ';
      ListViewTitleColor := $004080FF;
      panTeeBoxReserveToolbar.Visible := False;
      panBunkerReserveToolbar.Visible := False;
      panTeeBoxNoShowListToolbar.Visible := True;
      btnSaleTicketDaily.Enabled := False;
      btnSaleTicketMember.Enabled := False;
      btnSaleTeeBoxReservedCancel.Enabled := False;
      btnSaleTeeBoxMove.Enabled := False;
      btnSaleChangeReserved.Enabled := False;
      DoRefreshNoShowList;
      L1.GridView := V1NoShow;
    end;

    TListViewMode.lvmBunker:
    begin
      Global.NoShowInfo.NoShowReserved := False;
      ListViewTitle := ' ������/��Ŀ ���� ��Ȳ';
      ListViewTitleColor := $00FFFF80;
      panTeeBoxReserveToolbar.Visible := False;
      panTeeBoxNoShowListToolbar.Visible := False;
      panBunkerReserveToolbar.Visible := True;
      btnSaleTicketDaily.Enabled := False;
      btnSaleTicketMember.Enabled := False;
      btnSaleTeeBoxReservedCancel.Enabled := False;
      btnSaleTeeBoxMove.Enabled := False;
      btnSaleChangeReserved.Enabled := False;
      L1.GridView := V1Bunker;
    end;
  end;
end;

procedure TXGTeeBoxViewForm.SetListViewTitle(const AValue: string);
begin
  panReserveListTitle.Caption := AValue;
  if (ListViewMode = TListViewMode.lvmTeeBox) then
    FTeeBoxListViewTitle := AValue;
end;

procedure TXGTeeBoxViewForm.SetListViewTitleColor(const AColor: TColor);
begin
  panReserveListTitle.Font.Color := AColor;
  if (ListViewMode = TListViewMode.lvmTeeBox) then
    FTeeBoxListViewTitleColor := AColor;
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

procedure TXGTeeBoxViewForm.trbPrepareMinPropertiesChange(Sender: TObject);
var
  nMin: Integer;
begin
  nMin := TcxTrackBar(Sender).Position;
  if (Global.PrepareMin <> nMin) then
  begin
    Global.PrepareMin := nMin;
    edtPrepareMin.Value := nMin;
    Global.ConfigLocal.WriteInteger('Config', 'PrepareMin', nMin);
    Global.ConfigLocal.UpdateFile;
  end;
end;

procedure TXGTeeBoxViewForm.edtMemberCarNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew('', '', edtMemberCarNo.Text);
end;

procedure TXGTeeBoxViewForm.edtMemberHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew('', edtMemberHpNo.Text, '');
end;

procedure TXGTeeBoxViewForm.edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DoMemberSearchNew(edtMemberName.Text, '', '');
end;

procedure TXGTeeBoxViewForm.edtPrepareMinPropertiesChange(Sender: TObject);
var
  nMin: Integer;
begin
  nMin := Integer(TcxSpinEdit(Sender).Value);
  if (Global.PrepareMin <> nMin) then
  begin
    Global.PrepareMin := nMin;
    trbPrepareMin.Position := nMin;
    Global.ConfigLocal.WriteInteger('Config', 'PrepareMin', nMin);
    Global.ConfigLocal.UpdateFile;
  end;
end;

procedure TXGTeeBoxViewForm.edtSearchNameEnter(Sender: TObject);
begin
  TcxTextEdit(Sender).Text := '';
end;

procedure TXGTeeBoxViewForm.edtSearchNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    with TcxTextEdit(Sender) do
      if (Text <> '') then
        V1TeeBox.Controller.IncSearchingText := Text;
end;

procedure TXGTeeBoxViewForm.V1TeeBoxCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('play_yn').Index] <> True) then
    ACanvas.Font.Color := $00B6752E;
end;

procedure TXGTeeBoxViewForm.V3DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V3.DataController.Summary do
    SaleManager.MemberInfo.VIPTeeBoxCount := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V3vip_div)]), 0);
end;

procedure TXGTeeBoxViewForm.OnGridCustomDrawColumnHeader(Sender: TcxGridTableView;
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
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); //$00689F0E;

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

function TXGTeeBoxViewForm.DoTeeBoxHoldByIndex(const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;
var
  bSelected: Boolean;
  dStoreStartTime, dStoreEndTime: TDateTime;
  sErrMsg: string;
label
  GO_HOLD_CANCEL;
begin
  Result := False;
  AErrMsg := '';
  Screen.Cursor := crHourGlass;
  btnTeeBoxHoldForceCancel.Enabled := False;
  bSelected := FTeeBoxPanels[ATeeBoxIndex].Selected;
  try
    try
      if (FTeeBoxPanels[ATeeBoxIndex].CurStatus in [CTS_TEEBOX_STOP]) or
         ((not Global.TeeBoxForceAssign) and (FTeeBoxPanels[ATeeBoxIndex].CurStatus = CTS_TEEBOX_STOP_ALL)) or
         ((not Global.TeeBoxForceAssignOnError) and (FTeeBoxPanels[ATeeBoxIndex].CurStatus in [CTS_TEEBOX_ERROR])) then
        raise Exception.Create('���Ұ� ������ Ÿ���� ����� �� �����ϴ�!');

      if bSelected then
      begin
        if not SetTeeBoxHoldByIndex(False, ATeeBoxIndex, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.UpdateTeeBoxSelection(False, FTeeBoxPanels[ATeeBoxIndex].TeeBoxNo, FTeeBoxPanels[ATeeBoxIndex].FloorCode, FTeeBoxPanels[ATeeBoxIndex].FloorName, FTeeBoxPanels[ATeeBoxIndex].ZoneCode);
        ClientDM.ReloadTeeBoxStatus;
      end else
      begin
        if not SetTeeBoxHoldByIndex(True, ATeeBoxIndex, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.UpdateTeeBoxSelection(True, FTeeBoxPanels[ATeeBoxIndex].TeeBoxNo, ATeeBoxIndex,
          FTeeBoxPanels[ATeeBoxIndex].FloorCode, FTeeBoxPanels[ATeeBoxIndex].FloorName, FTeeBoxPanels[ATeeBoxIndex].ZoneCode, FTeeBoxPanels[ATeeBoxIndex].VipYN, FTeeBoxPanels[ATeeBoxIndex].TeeBoxName);
      end;

      FTeeBoxPanels[ATeeBoxIndex].Selected := not bSelected;
      if FTeeBoxPanels[ATeeBoxIndex].Selected then
      begin
        dStoreEndTime := SaleManager.StoreInfo.StoreEndDateTime;
        if FTeeBoxPanels[ATeeBoxIndex].EndTime.IsEmpty then
          dStoreStartTime := Now
        else
          dStoreStartTime := SaleManager.StoreInfo.StoreStartDateTime;

        //���� ����ð��� üũ�ϴ� ���
        if (not SaleManager.StoreInfo.EndTimeIgnoreYN) then
        begin
          if (IncMinute(dStoreStartTime, 5) >= dStoreEndTime) then
          begin
            Screen.Cursor := crDefault;
            XGMsgBox(Self.Handle, mtWarning, '�˸�',
                '������ Ÿ���� �� �̻� ������ �� �����ϴ�!' + _CRLF +
                Format('(�����ð�: %s ~ %s)', [SaleManager.StoreInfo.StoreStartTime, SaleManager.StoreInfo.StoreEndTime]), ['Ȯ��'], 5);
            Screen.Cursor := crHourGlass;
            goto GO_HOLD_CANCEL;
          end;

          if (IncMinute(dStoreStartTime, 60) > dStoreEndTime) then
          begin
            Screen.Cursor := crDefault;
            if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
                Format('���� ����ð��� [%s] �Դϴ�!',
                  [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
                '���� �ð����� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
            begin
              Screen.Cursor := crHourGlass;
              goto GO_HOLD_CANCEL;
            end;
          end;
        end;

        Exit(True);

        //=============
        GO_HOLD_CANCEL:
        //=============
        if not SetTeeBoxHoldByIndex(False, ATeeBoxIndex, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.UpdateTeeBoxSelection(False, FTeeBoxPanels[ATeeBoxIndex].TeeBoxNo, FTeeBoxPanels[ATeeBoxIndex].FloorCode, FTeeBoxPanels[ATeeBoxIndex].FloorName, FTeeBoxPanels[ATeeBoxIndex].ZoneCode);
        FTeeBoxPanels[ATeeBoxIndex].Selected := False;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxHoldByIndex.Exception = %s', [E.Message]));
      AErrMsg := E.Message;
    end;
  end;
end;

function TXGTeeBoxViewForm.SetTeeBoxHoldByIndex(const AUseHold: Boolean; const ATeeBoxIndex: Integer; var AErrMsg: string): Boolean;
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

procedure TXGTeeBoxViewForm.DoTeeBoxReservedListView(const ATeeBoxIndex: Integer);
var
  PM: TPluginMessage;
begin
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_EMERGENCY_MODE, False);
      PM.AddParams(CPP_TEEBOX_NO, FTeeBoxPanels[ATeeBoxIndex].TeeBoxNo);
      PM.AddParams(CPP_TEEBOX_NAME, FTeeBoxPanels[ATeeBoxIndex].TeeBoxName);
      PluginManager.OpenModal('XGTeeBoxReserveList' + CPL_EXTENSION, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedListView.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

procedure TXGTeeBoxViewForm.SelectTeeBoxByIndex(const AIndex: Integer);
var
  I: Integer;
begin
  if (L1.GridView <> V1TeeBox) then
  begin
    btnTeeBoxReserveList.Down := True;
    btnTeeBoxReserveList.Click;
  end;

  btnTeeBoxImmediateStart.Enabled := True;
  for I := 0 to Pred(FTeeBoxCount) do
    FTeeBoxPanels[I].Checked := (I = AIndex);

  CurrentTeeBoxIndex := AIndex;
  DoTeeBoxFilter;
end;

procedure TXGTeeBoxViewForm.OnTeeBoxBodyClick(Sender: TObject);
var
  nIndex: Integer;
  sErrMsg: string;
begin
  nIndex := TWinControl(Sender).Tag;
  SelectTeeBoxByIndex(nIndex);
  if Global.HoldAllowedOnLeftClick then
    if not DoTeeBoxHoldByIndex(nIndex, sErrMsg) then
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
end;

procedure TXGTeeBoxViewForm.OnTeeBoxHeaderClick(Sender: TObject);
begin
  SelectTeeBoxByIndex(TWinControl(Sender).Tag);
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
    nSource := TPanel(Source).Tag; //�̵��� ���� Ÿ���� �ε���
    nSender := TPanel(Sender).Tag; //�̵��� ��� Ÿ���� �ε���
    try
      if FTeeBoxPanels[nSource].EndTime.IsEmpty then
        raise Exception.Create('�̵��� ���� ������ �����ϴ�!');
      if (nSource = nSender) then
        raise Exception.Create('������ Ÿ������ Ÿ���� �̵��� �� �����ϴ�!');

      DoTeeBoxClearHold;
      if not FTeeBoxPanels[nSender].Selected then
        if not DoTeeBoxHoldByIndex(nSender, sErrMsg) then
          raise Exception.Create(sErrMsg);

      Global.TeeBoxStatusWorking := True;
      SelectTeeBoxByIndex(nSource);
      with TXGTeeBoxMoveDragDropForm.Create(nil) do
      try
        TargetTeeBoxName := Format('%s�� %s', [FTeeBoxPanels[nSender].FloorCode, FTeeBoxPanels[nSender].TeeBoxName]);
        if (ShowModal = mrOK) then
        begin
          if not ClientDM.PostTeeBoxReserveMove(ReserveNo, FTeeBoxPanels[nSender].TeeBoxNo, RemainMin, PrepareMin, 9999, sErrMsg) then
            raise Exception.Create(sErrMsg);

          ClientDM.ClearMemberInfo(Global.SaleFormId);
          DispMemberInfo;
          if (MemberNo <> '') and
             (not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, MemberNo, sErrMsg)) then
            XGMsgBox(Self.Handle, mtInformation, '�˸�', Format('ȸ����ȣ [%s]�� ������ �������� �ʽ��ϴ�!', [MemberNo]) + _CRLF + sErrMsg, ['Ȯ��'], 5);

          try
            try
              if Global.DeviceConfig.ReceiptPrinter.Enabled and
                 Global.TeeBoxChangedReIssue then
                sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
            finally
              ClearTeeBoxSelection(True, True);
              ClientDM.ClearMemberInfo(Global.SaleFormId);
              DispMemberInfo;
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
            begin
              UpdateLog(Global.LogFile, Format('TeeBoxView.OnTeeBoxHeaderDragDrop.ReceiptPrint.Exception = %s', [E.Message]));
              XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� ����ǥ�� ����� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
            end;
          end;

          ClientDM.ReloadTeeBoxStatus;
          SelectTeeBoxByIndex(nSender);
          XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� �̵��� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
        end;
      finally
        Free;
        DoTeeBoxClearHold;
        Global.TeeBoxStatusWorking := False;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.OnTeeBoxHeaderDragDrop.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5)
      end;
    end;
  end;
end;

procedure TXGTeeBoxViewForm.CloseAction(const AEmergencyChanged: Boolean);
begin
  if (not AEmergencyChanged) and
     (XGMsgBox(Self.Handle, mtConfirmation, '���α׷� ����', '���α׷��� �����Ͻðڽ��ϱ�?', ['Ȯ��', '���']) <> mrOK) then
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
    Self.Close;
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
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
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
            LessonProColor := FieldByName('lesson_pro_color').AsInteger;
            LessonProName := FieldByName('lesson_pro_nm').AsString;
            AirConYN := (FieldByName('heat_status').AsInteger = CRC_ON);
            if (SaleManager.StoreInfo.OutdoorDiv = CGD_INDOOR) then
              TeeBoxAgentStatus := FieldByName('agent_status').AsInteger;
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

            //���� ����ͷ� ����
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

      with btnSaleTeeBoxStoppedAll do
        if (not Enabled) then Enabled := True;
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
          SQL.Add(Format('AND T.zone_cd NOT IN (%s, %s)', [QuotedStr(CTZ_TRACKMAN), QuotedStr(CTZ_GDR)])); //Ʈ����(T), GDR(X) ����
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

procedure TXGTeeBoxViewForm.UpdateCurrentWeather;
begin
  if Global.WeatherInfo.Enabled then
  begin
    btnWeather.Picture.Assign(ClientDM.imcWeather.Items[Global.WeatherInfo.IconIndex].Picture);
    btnWeather.Hint := '���糯��: ' + Global.WeatherInfo.Condition + _CRLF +
                       '���: ' + Global.WeatherInfo.Temper + '��' + _CRLF +
                       '����Ȯ��: ' + Global.WeatherInfo.Precipit + '��' + _CRLF +
                       '����: ' + Global.WeatherInfo.Humidity + '��' + _CRLF +
                       'ǳ��: ' + Global.WeatherInfo.WindSpeed + '��';
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

procedure TXGTeeBoxViewForm.mnuTeeBoxWakeOnLANClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_WAKEONLAN); //Ÿ���� PC �ѱ�(Wake-On-LAN)
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxAgentShutdownClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_SHUTDOWN); //Ÿ���� PC ����
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxAgentRebootClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_REBOOT); //Ÿ���� PC ������
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxAgentUpdateClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_UPDATE); //������Ʈ �����(������Ʈ)
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxAgentCloseClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_CLOSE); //������Ʈ ����
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxProjectorOnClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_LBP_ON); //�� �������� �ѱ�
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxProjectorOffClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_LBP_OFF); //�� ������Ʈ ����
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxSmartPlugOffClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_PLUG_ON); //Ÿ���� ����Ʈ�÷��� �ѱ�
end;

procedure TXGTeeBoxViewForm.mnuTeeBoxSmartPlugOnClick(Sender: TObject);
begin
  DoTeeBoxAgentControl(CTA_CTRL_PLUG_OFF); //Ÿ���� ����Ʈ�÷��� ����
end;

procedure TXGTeeBoxViewForm.mnuNoShowRefreshListClick(Sender: TObject);
begin
  DoRefreshNoShowList;
end;

procedure TXGTeeBoxViewForm.mnuNoShowTicketDailyClick(Sender: TObject);
begin
  DoReserveNoShowTicketDaily;
end;

procedure TXGTeeBoxViewForm.mnuNoShowTicketMemberClick(Sender: TObject);
begin
  DoReserveNoShowTicketMember(False); //��ȭ����=False
end;

procedure TXGTeeBoxViewForm.mnuNoShowTicketMemberTeleReservedClick(Sender: TObject);
begin
  DoReserveNoShowTicketMember(True); //��ȭ����=True
end;

procedure TXGTeeBoxViewForm.mnuSaleChangeReservedClick(Sender: TObject);
begin
  DoTeeBoxReservedChange;
end;

procedure TXGTeeBoxViewForm.mnuSaleCheckinMobileReservedClick(Sender: TObject);
var
  sMemberNo, sMemberName, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  begin
    if (RecordCount = 0) then
      Exit;

    sMemberNo := FieldByName('member_no').AsString;
    sMemberName := FieldByName('member_nm').AsString;
    if sMemberNo.IsEmpty then
      Exit;

    if not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '�˸�',
        Format('[ȸ����: %s] �� ȸ�������� �������� �ʽ��ϴ�.', [sMemberName]) + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;
  end;

  DoCheckinMobileReserved;
end;

procedure TXGTeeBoxViewForm.mnuSaleTeeBoxHoldClick(Sender: TObject);
var
  sErrMsg: string;
begin
  if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
    XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
end;

procedure TXGTeeBoxViewForm.mnuSaleTeeBoxMoveClick(Sender: TObject);
begin
  DoTeeBoxReservedMove;
end;

procedure TXGTeeBoxViewForm.mnuSaleTeeBoxPauseClick(Sender: TObject);
begin
  DoTeeBoxPauseOrRestart;
end;

procedure TXGTeeBoxViewForm.mnuSaleTeeBoxReservedCancelClick(Sender: TObject);
begin
  DoTeeBoxReservedCancel;
end;

procedure TXGTeeBoxViewForm.mnuSaleTeeBoxReserveListClick(Sender: TObject);
begin
  DoTeeBoxReservedListView(CurrentTeeBoxIndex);
end;

procedure TXGTeeBoxViewForm.mnuSaleTicketMemberClick(Sender: TObject);
var
  sErrMsg: string;
begin
  ClientDM.ClearMemberInfo(Global.SaleFormId);
  DispMemberInfo;
  DoTeeBoxClearHold;
  if not FTeeBoxPanels[CurrentTeeBoxIndex].Selected then
    if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

  DoTeeBoxTicketMember(False); //��ȭ����=False
end;

procedure TXGTeeBoxViewForm.mnuSaleImmediateStartClick(Sender: TObject);
begin
  if (FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus = CTS_TEEBOX_RESERVED) then
  try
    if (not ClientDM.MDTeeBoxReserved2.Locate('teebox_no', FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo, [])) or
       ClientDM.MDTeeBoxReserved2.FieldByName('play_yn').AsBoolean then
      raise Exception.Create('��� ������ ������ ������ �����ϴ�!');
    DoTeeBoxImmediateStart; //��� ����
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtWarning, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.mnuSaleTicketDailyClick(Sender: TObject);
var
  sErrMsg: string;
begin
  DoTeeBoxClearHold;
  if not FTeeBoxPanels[CurrentTeeBoxIndex].Selected then
    if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

  DoTeeBoxTicketDaily;
end;

procedure TXGTeeBoxViewForm.mnuSaleTicketMemberTeleReservedClick(Sender: TObject);
var
  sErrMsg: string;
begin
  ClientDM.ClearMemberInfo(Global.SaleFormId);
  DispMemberInfo;
  DoTeeBoxClearHold;
  if not FTeeBoxPanels[CurrentTeeBoxIndex].Selected then
    if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
    begin
      XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
      Exit;
    end;

  DoTeeBoxTicketMember(True); //��ȭ����=True
end;

procedure TXGTeeBoxViewForm.btnSaleMemberClearClick(Sender: TObject);
begin
  ClientDM.ClearMemberInfo(Global.SaleFormId);
  DispMemberInfo;
end;

procedure TXGTeeBoxViewForm.btnCloseClick(Sender: TObject);
begin
  CloseAction;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxDeleteHoldClick(Sender: TObject);
begin
  with ClientDM.MDTeeBoxSelected do
    if (RecordCount > 0) then
      ClearTeeBoxSelection(True, False);
end;

procedure TXGTeeBoxViewForm.btnACSCallClick(Sender: TObject);
var
  nSendDiv: Integer;
  sJobName, sTeeBoxName, sAlertAll, sErrMsg: string;
begin
  with ClientDM.MDACSList do
  try
    if (RecordCount = 0) then
      Exit;

    nSendDiv := FieldByName('send_div').AsInteger;
    sJobName := FieldByName('calc_send_div').AsString;
    sTeeBoxName := '';
    sAlertAll := '';
    //Ÿ���� ����� ��� ���Ÿ�� ���� �ʼ�
    if (nSendDiv = CAK_TEEUP_ERROR) then
    begin
      if (CurrentTeeBoxIndex < 0) then
      begin
        XGMsgBox(Self.Handle, mtWarning, '�˸�', '��� Ÿ���� ���õ��� �ʾҽ��ϴ�!', ['Ȯ��'], 5);
        Exit;
      end;
      sTeeBoxName := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName;
      sAlertAll := _CRLF + '����� �������� �˸��� ���۵˴ϴ�.';
    end;

    if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          Format('����ڿ��� [%s] ACS �˸��� �����Ͻðڽ��ϱ�?',
            [IIF(sTeeBoxName.IsEmpty, '', sTeeBoxName + '�� ') + sJobName]) + sAlertAll, ['��', '�ƴϿ�']) = mrOK) then
    begin
      if not ClientDM.SendACS(nSendDiv, sTeeBoxName, sErrMsg) then
        raise Exception.Create(sErrMsg);

      XGMsgBox(Self.Handle, mtInformation, '�˸�', 'ACS ������ ���������� ó���Ǿ����ϴ�!', ['Ȯ��'], 5);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� ACS ���ۿ� �����Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnACSClick(Sender: TObject);
begin
  if spvACS.Opened then
  begin
    spvACS.Margins.Left := 0;
    spvACS.Close;
  end
  else
  begin
    spvACS.Margins.Left := 5;
    spvACS.Open;
  end;
end;

procedure TXGTeeBoxViewForm.btnACSConfigClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'system/acsInfo');
end;

procedure TXGTeeBoxViewForm.btnACSHistoryClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'store/acsSendHist');
end;

procedure TXGTeeBoxViewForm.btnACSRefreshClick(Sender: TObject);
var
  sErrMsg: string;
begin
  try
    if not ClientDM.GetStoreInfo(sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� ACS ����� ��ȸ�� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnAirConditionerClick(Sender: TObject);
var
  I, nTeeBoxNo, nUseCmd: Integer;
  sErrMsg: string;
begin
  try
    if not Global.AirConditioner.Enabled then
      raise Exception.Create('��/��ǳ�� ��� ������ �Ǿ� ���� �ʽ��ϴ�!');

    if (CurrentTeeBoxIndex >= 0) then
    begin
      case XGMsgBox(Self.Handle, mtConfirmation, '����', '��/��ǳ�� ���� ����� �����Ͽ� �ֽʽÿ�.',
              [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName + ' �� Ÿ��'#13#10'����',
               FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName + ' �� Ÿ��'#13#10'����',
               '��ü Ÿ��'#13#10'����', '���']) of
        mrOK: //����Ÿ�� �ѱ�
        begin
          nTeeBoxNo := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo;
          nUseCmd := CRC_ON;
        end;

        mrCancel: //����Ÿ�� ����
        begin
          nTeeBoxNo := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo;
          nUseCmd := CRC_OFF;
        end;

        mrYesToAll: //��üŸ�� ����
        begin
          nTeeBoxNo := -1;
          nUseCmd := CRC_OFF;
        end;
      else
        Exit;
      end;
    end
    else
    begin
      if (XGMsgBox(Self.Handle, mtConfirmation, '����', '��/��ǳ�� ���� ����� �����Ͽ� �ֽʽÿ�.',
            ['��ü Ÿ��'#13#10'����', '���']) <> mrOK) then
        Exit;

      nTeeBoxNo := -1;
      nUseCmd := CRC_OFF;
    end;

    if not ClientDM.SetAirConOnOff(nTeeBoxNo, nUseCmd, sErrMsg) then
      raise Exception.Create(sErrMsg);

    if (nTeeBoxNo <> -1) then
      FTeeBoxPanels[CurrentTeeBoxIndex].AirConYN := (nUseCmd = CRC_ON)
    else
      for I := 0 to Pred(FTeeBoxCount) do
        FTeeBoxPanels[I].AirConYN := (nUseCmd = CRC_ON);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxClearHoldClick(Sender: TObject);
begin
  DoTeeBoxClearHold;
end;

procedure TXGTeeBoxViewForm.btnQRCodeCheckInClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_SCAN_MODE, CMC_MEMBER_QRCODE);
      PluginManager.OpenModal('XGCouponCard' + CPL_EXTENSION, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnCouponCardClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_SCAN_MODE, CMC_MEMBER_MSCARD);
      PluginManager.OpenModal('XGCouponCard' + CPL_EXTENSION, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
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

procedure TXGTeeBoxViewForm.btnNoShowRefreshListClick(Sender: TObject);
begin
  DoRefreshNoShowList;
end;

procedure TXGTeeBoxViewForm.btnNoShowTicketDailyClick(Sender: TObject);
begin
  DoReserveNoShowTicketDaily;
end;

procedure TXGTeeBoxViewForm.btnNoShowTicketMemberClick(Sender: TObject);
begin
  DoReserveNoShowTicketMember(False); //��ȭ����=False
end;

procedure TXGTeeBoxViewForm.btnNoShowTicketMemberTeleReservedClick(Sender: TObject);
begin
  DoReserveNoShowTicketMember(True); //��ȭ����=True
end;

procedure TXGTeeBoxViewForm.btnPartnerCenterClick(Sender: TObject);
begin
  ShowPartnerCenter(Self.PluginID, 'main');
end;

procedure TXGTeeBoxViewForm.btnTeeBoxTicketReprintClick(Sender: TObject);
var
  sMemberNo, sMemberName, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    if not Global.DeviceConfig.ReceiptPrinter.Enabled then
      raise Exception.Create('������ ������ ��� ������ �Ǿ� ���� �ʽ��ϴ�.');

    try
      DisableControls;
      if (RecordCount = 0) then
        Exit;

      ClientDM.ClearMemberInfo(Global.SaleFormId);
      sMemberNo := FieldByName('member_no').AsString;
      sMemberName := FieldByName('member_nm').AsString;
      if not sMemberNo.IsEmpty then
      begin
        if (not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg)) then
          raise Exception.Create(Format('[ȸ����: %s] �� ȸ�������� �������� �ʽ��ϴ�.', [sMemberName]));

        DispMemberInfo;
      end;

      if not DoTeeBoxTicketReprint(sErrMsg) then
        raise Exception.Create(sErrMsg);
    finally
      EnableControls;
      RefreshTeeBoxStatus;
      ClientDM.ClearMemberInfo(Global.SaleFormId);
      DispMemberInfo;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '����ǥ�� ����� �� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnSaleReceiptViewClick(Sender: TObject);
begin
  DoSaleReceiptView;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxReceiptRePrintClick(Sender: TObject);
var
  sReceiptNo, sMemberNo, sMemberName, sMemberHpNo, sReceiptJson, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    try
      if (RecordCount = 0) then
        Exit;

      sReceiptNo  := FieldByName('receipt_no').AsString;
      sMemberNo   := FieldByName('member_no').AsString;
      sMemberName := FieldByName('member_nm').AsString;
      sMemberHpNo := FieldByName('hp_no').AsString;

      if sReceiptNo.IsEmpty then
        raise Exception.Create('������ ����� ����� �ƴմϴ�.');

      if not Global.DeviceConfig.ReceiptPrinter.Enabled then
        raise Exception.Create('������ ������ ��� ������ �Ǿ� ���� �ʽ��ϴ�.');

      if not ClientDM.GetProdSaleDetailNew(sReceiptNo, sErrMsg) then
        raise Exception.Create(sErrMsg);

      sReceiptJson := ClientDM.MakeReIssueReceiptJson(sReceiptNo, sErrMsg);
      if not sErrMsg.IsEmpty then
        raise Exception.Create(sErrMsg);

      if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, True, False, sErrMsg) then
        raise Exception.Create(sErrMsg);
    finally
      EnableControls;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '������� ����� �� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxFilterClearClick(Sender: TObject);
begin
  DoTeeBoxFilterClear;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxReserveListClick(Sender: TObject);
begin
  ListViewMode := TListViewMode.lvmTeeBox;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxNoShowListClick(Sender: TObject);
begin
  ListViewMode := TListViewMode.lvmNoShow;
end;

procedure TXGTeeBoxViewForm.btnBunkerListClick(Sender: TObject);
begin
  ListViewMode := TListViewMode.lvmBunker;
end;

procedure TXGTeeBoxViewForm.btnBunkerReceiptRePrintClick(Sender: TObject);
begin
//
end;

procedure TXGTeeBoxViewForm.btnBunkerReserveChangeClick(Sender: TObject);
begin
//
end;

procedure TXGTeeBoxViewForm.btnBunkerReservedCancelClick(Sender: TObject);
begin
//
end;

procedure TXGTeeBoxViewForm.btnBunkerReserveRefreshClick(Sender: TObject);
begin
//
end;

procedure TXGTeeBoxViewForm.btnBunkerTicketRePrintClick(Sender: TObject);
begin
//
end;

procedure TXGTeeBoxViewForm.btnTeeBoxImmediateStartClick(Sender: TObject);
begin
  DoTeeBoxImmediateStart;
end;

function TXGTeeBoxViewForm.CheckSelectedTeeBox(const ATitle: string): Boolean;
begin
  Result := (ClientDM.MDTeeBoxSelected.RecordCount > 0);
  if not Result then
    XGMsgBox(Self.Handle, mtWarning, ATitle, '������ Ÿ���� �����ϴ�!', ['Ȯ��'], 5);
end;

procedure TXGTeeBoxViewForm.btnSaleLockerClick(Sender: TObject);
begin
  DoLockerView;
end;

procedure TXGTeeBoxViewForm.btnSaleMemberAddClick(Sender: TObject);
begin
  DoMemberAdd;
end;

procedure TXGTeeBoxViewForm.btnSaleMemberSearchAndEditClick(Sender: TObject);
begin
  DoMemberSearchAndEdit;
end;

procedure TXGTeeBoxViewForm.btnSaleChangeReservedClick(Sender: TObject);
begin
  DoTeeBoxReservedChange;
end;

procedure TXGTeeBoxViewForm.btnShowMemberInfoClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_CLOSE;
    PM.PluginMessageToID(Global.WebViewId);
  finally
    FreeAndNil(PM);
  end;

  ShowPartnerCenter(Self.PluginID, Format('member/memberDetail?member_seq=%d', [SaleManager.MemberInfo.MemberSeq]));
end;

procedure TXGTeeBoxViewForm.btnShowSalePOSClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    ShowSalePos(Self.PluginID);
  finally
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxStoppedAllClick(Sender: TObject);
begin
  DoTeeBoxStoppedAll;
end;

procedure TXGTeeBoxViewForm.btnTeeBoxHoldForceCancelClick(Sender: TObject);
var
  bUseHold: Boolean;
  sTitle, sErrMsg: string;
begin
  if (CurrentTeeBoxIndex < 0) then
    Exit;

  sTitle := '�ӽÿ��� ���';
  bUseHold := False;
  if not (FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus in [CTS_TEEBOX_READY, CTS_TEEBOX_HOLD]) then
  begin
    XGMsgBox(Self.Handle, mtWarning, sTitle, 'ó���� �� ���� Ÿ���Դϴ�!', ['Ȯ��'], 5);
    Exit;
  end;

  try
    if (XGMsgBox(Self.Handle, mtConfirmation, sTitle,
        Format('%s(��) Ÿ���� %s �۾��� �����Ͻðڽ��ϱ�?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['��', '�ƴϿ�']) = mrOK) then
    begin
      if not SetTeeBoxHoldByIndex(bUseHold, CurrentTeeBoxIndex, sErrMsg) then
        raise Exception.Create(sErrMsg);

      XGMsgBox(Self.Handle, mtInformation, sTitle, sTitle + ' �۾��� �Ϸ� �Ǿ����ϴ�!', ['Ȯ��'], 5);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, sTitle, sTitle + ' �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxClearanceClick(Sender: TObject);
begin
  DoTeeBoxClearance;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxMoveClick(Sender: TObject);
begin
  DoTeeBoxReservedMove;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxPauseOrRestartClick(Sender: TObject);
begin
  DoTeeBoxPauseOrRestart;
end;

procedure TXGTeeBoxViewForm.btnSaleTeeBoxReservedCancelClick(Sender: TObject);
begin
  DoTeeBoxReservedCancel;
end;

procedure TXGTeeBoxViewForm.btnSaleTicketMemberClick(Sender: TObject);
begin
  DoTeeBoxTicketMember(False); //��ȭ����=False
end;

procedure TXGTeeBoxViewForm.btnSaleTicketDailyClick(Sender: TObject);
begin
  DoTeeBoxTicketDaily;
end;

procedure TXGTeeBoxViewForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(TcxGridDBBandedTableView(L1.GridView));
end;

procedure TXGTeeBoxViewForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(TcxGridDBBandedTableView(L1.GridView));
end;

procedure TXGTeeBoxViewForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(TcxGridDBBandedTableView(L1.GridView));
end;

procedure TXGTeeBoxViewForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(TcxGridDBBandedTableView(L1.GridView));
end;

procedure TXGTeeBoxViewForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V3);
end;

procedure TXGTeeBoxViewForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;

procedure TXGTeeBoxViewForm.btnWeatherClick(Sender: TObject);
begin
  if Global.WeatherInfo.Enabled then
    ShowWeatherInfo;
end;

procedure TXGTeeBoxViewForm.SetStoppedAll(const AStopped: Boolean);
begin
  FStoppedAll := AStopped;
  btnSaleTeeBoxStoppedAll.Caption := '�� ȸ��' + _CRLF + IIF(AStopped, '����', '����');
end;

procedure TXGTeeBoxViewForm.DoMemberSearchNew(const AMemberName, AHpNo, ACarNo: string);
var
  PM: TPluginMessage;
  MR: TModalResult;
  bCouponUseOnly, bMemberSelected, bTeeBoxProdSelected: Boolean;
  sProdCode, sProdDiv, sProdName, sPurchaseCode, sAvailZoneCode, sErrMsg: string;
  nTeeBoxCount, nProdMin, nRemainCount: Integer;
begin
  if FWorking or
     (AMemberName.IsEmpty and AHpNo.IsEmpty and ACarNo.IsEmpty) then
    Exit;

  FWorking := True;
  PM := TPluginMessage.Create(nil);
  try
    try
      if not ClientDM.SearchMember('', AMemberName, AHpNo, ACarNo, True, sErrMsg) then
      begin
        ClientDM.ClearMemberInfo(Global.SaleFormId);
        DispMemberInfo;
        raise Exception.Create(sErrMsg);
      end;

      bMemberSelected := False;
      bTeeBoxProdSelected := False;

      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_MEMBER_NO, Format('ȸ����=%s*, ��ȭ��ȣ=%s*, ������ȣ=%s*', [AMemberName, AHpNo, ACarNo]));
      PM.AddParams(CPP_TEEBOX_RESERVED, ClientDM.MDTeeBoxSelected.RecordCount > 0);
      PM.AddParams(CPP_TEEBOX_PROD_CHANGE, False);
      MR := PluginManager.OpenModal('XGMemberSearchList' + CPL_EXTENSION, PM);
      case MR of
        mrOk: //ȸ�� ����
          bMemberSelected := True;

        mrYes: //ȸ��+Ÿ����ǰ ����
          begin
            bMemberSelected := True;
            bTeeBoxProdSelected := True;
          end;
      else
        ClientDM.ClearMemberInfo(Global.SaleFormId);
        DispMemberInfo;
      end;

      if bMemberSelected then
      begin
        ClientDM.SetMemberInfo(TDataSet(ClientDM.MDMemberSearch));
        PM.ClearParams;
        PM.Command := CPC_SEND_MEMBER_NO;
        PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
        PM.PluginMessageToID(Global.SaleFormId);

        PM.ClearParams;
        PM.Command := CPC_SEND_MEMBER_NO;
        PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
        PM.PluginMessageToID(Global.TeeBoxViewId);
      end;

      if bTeeBoxProdSelected then
      begin
        nTeeBoxCount := ClientDM.MDTeeBoxSelected.RecordCount;
        bCouponUseOnly := (nTeeBoxCount > 1);
        if (ClientDM.QRSaleItem.RecordCount > 0) or
           (ClientDM.QRPayment.RecordCount > 0) or
           (ClientDM.QRCoupon.RecordCount > 0) then
          raise Exception.Create('ó������ ���� �ֹ������� �ֽ��ϴ�!');

        if (nTeeBoxCount = 0) then
          raise Exception.Create('������ Ÿ���� ���õ��� �ʾҽ��ϴ�!');

        with ClientDM.MDTeeBoxProdMember do
        begin
          sProdCode := FieldByName('product_cd').AsString;
          sProdDiv := FieldByName('product_div').AsString;
          sProdName := FieldByName('product_nm').AsString;
          nProdMin := FieldByName('one_use_time').AsInteger;
          nRemainCount := FieldByName('remain_cnt').AsInteger;
          sPurchaseCode := FieldByName('purchase_cd').AsString;
          sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
        end;

        if (sProdDiv = CTP_COUPON) then
        begin
          if (nRemainCount < nTeeBoxCount) then
            raise Exception.Create('�ܿ����� ���� �����Ͽ� ������ ������ �� �����ϴ�!!');
        end else
        begin
          if bCouponUseOnly then
            raise Exception.Create('1�� �̻� Ÿ���� ���� ������ ����ȸ�������θ� �����մϴ�!');
        end;

        if bCouponUseOnly and
           (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
              '������ ��ǰ���� Ÿ���� �����Ͻðڽ��ϱ�?' + _CRLF +
              '��ǰ�� : ' + sProdName + _CRLF +
              '�������� : ' + IntToStr(nTeeBoxCount), ['��', '�ƴϿ�']) <> mrOK) then
          Exit;

        DoTeeBoxReserveMember(sProdCode, sProdDiv, sProdName, sPurchaseCode, sAvailZoneCode, nProdMin);
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoMemberSearchNew.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxClearHold;
begin
  if Global.TeeBoxHoldWorking then
    Exit;

  if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
    ClearTeeBoxSelection(True, True);

  if (L1.GridView <> V1TeeBox) then
  begin
    btnTeeBoxReserveList.Click;
    btnTeeBoxReserveList.Down := True;
  end;

  ClientDM.ReloadTeeBoxStatus;
  DoTeeBoxFilterClear;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxFilter;
begin
  if (CurrentTeeBoxIndex < 0) then
    Exit;

  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    FTeeBoxPanels[CurrentTeeBoxIndex].Checked := True;
    ListViewTitle := Format(' ��Ÿ�� ���� ��Ȳ (����Ÿ��: %s)', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName]);
    ListViewTitleColor := $0000FF80;
    btnTeeBoxFilterClear.Enabled := True;
    Filtered := False;
    SaleManager.StoreInfo.SelectedTeeBoxNo := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo;
    Filtered := True;

    if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
      btnTeeBoxHoldForceCancel.Enabled := False
    else
      btnTeeBoxHoldForceCancel.Enabled := True;

    Locate('teebox_no', FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo, []);
  finally
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxFilterClear;
var
  BM: TBookmark;
begin
  with ClientDM.MDTeeBoxReserved2 do
  begin
    BM := GetBookmark;
    try
      DisableControls;
      if Filtered then
      begin
        ListViewTitle := ' ��Ÿ�� ���� ��Ȳ (��ü����)';
        ListViewTitleColor := clWhite;
        Filtered := False;
        btnTeeBoxFilterClear.Enabled := False;
        btnTeeBoxImmediateStart.Enabled := False;
      end;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  end;
end;

procedure TXGTeeBoxViewForm.ClearTeeBoxSelection(const AUpdateToServer, AClearAll: Boolean);
var
  nIndex, nOrderQty: Integer;
  sProdCode, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxSelected do
  try
    try
      DisableControls;
      if AClearAll then
        First;

      while not Eof do
      begin
        nIndex := FieldByName('teebox_index').AsInteger;
        sProdCode := FieldByName('product_cd').AsString;
        if ClientDM.QRSaleItem.Locate('product_cd', sProdCode, []) then
        begin
          if (ClientDM.QRSaleItem.FieldByName('order_qty').AsInteger > 1) then
          begin
            nOrderQty := (ClientDM.QRSaleItem.FieldByName('order_qty').AsInteger - 1);
            if not ExecuteABSQuery(
                Format('UPDATE TBSaleItem SET order_qty = %d WHERE table_no = %d AND product_cd = %s',
                  [nOrderQty, Global.TableInfo.ActiveTableNo, QuotedStr(sProdCode)]),
                sErrMsg) then
              raise Exception.Create(sErrMsg);
          end
          else
          begin
            //������ �ݾ��� ���� ��쿡�� �����׸� ����
            if (SaleManager.ReceiptInfo.ReceiveTotal = 0) and
               not ExecuteABSQuery(
                  Format('DELETE FROM TBSaleItem WHERE table_no = %d AND product_cd = %s',
                    [Global.TableInfo.ActiveTableNo, QuotedStr(sProdCode)]),
                  sErrMsg) then
              raise Exception.Create(sErrMsg);
          end;
        end;

        if AUpdateToServer then
          SetTeeBoxHoldByIndex(False, nIndex, sErrMsg);

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

        if not AClearAll then
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
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ����� ����� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  finally
    ClientDM.RefreshSaleItemTable(Global.TableInfo.ActiveTableNo, Global.TableInfo.DelimitedGroupTableList);
    EnableControls;
  end;
end;

procedure TXGTeeBoxViewForm.DispMemberInfo;
begin
  edtMemberName.Text             := SaleManager.MemberInfo.MemberName;
  edtMemberHpNo.Text             := SaleManager.MemberInfo.HpNo;
  edtMemberCarNo.Text            := SaleManager.MemberInfo.CarNo;
  lblMemberLockerList.Caption    := SaleManager.MemberInfo.LockerList;
  lblMemberLockerExpired.Caption := FormattedDateString(SaleManager.MemberInfo.ExpireLocker);
  lblMemberSex.Caption           := SaleManager.MemberInfo.GetSexDivDesc;
  lblMemberSex.Style.Font.Color  := IIF(SaleManager.MemberInfo.SexDiv = CSD_SEX_FEMALE, clRed, clBlack);
  ckbMemberXGolf.Checked         := not SaleManager.MemberInfo.XGolfMemberNo.IsEmpty;
  mmoMemberMemo.Lines.Text       := SaleManager.MemberInfo.Memo;
  btnShowMemberInfo.Enabled      := not SaleManager.MemberInfo.MemberNo.IsEmpty;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxReserveMember(const AProductCode, AProductDiv, AProductName, APurchaseCode, AAvailZoneCode: string; const AProductMin: Integer);
var
  nIndex, nPrepareMin, nAssignMin, nAssignBalls: Integer;
  dReserveDateTime, dCurEndDateTime, dNewEndDateTime: TDateTime;
  sErrMsg, sReceiptJson, sDelayMsg: string;
  bTeeBoxSuccess: Boolean;
  SL: TStringList;
label
  GO_TEEBOX_RETRY;
begin
  try
    SL := TStringList.Create;
    try
      if (ClientDM.MDTeeBoxSelected.RecordCount > 0) and
         (not (ClientDM.CheckTeeBoxHoldTime(SL, sErrMsg))) then
      begin
        sDelayMsg := 'Ÿ�� ���� �����ð��� ����Ǿ����ϴ�!' + _CRLF +
                     '����� �ð����� �����Ͻðڽ��ϱ�?' + _CRLF + _CRLF;
        for nIndex := 0 to pred(SL.count) do
          sDelayMsg := sDelayMsg + SL.Strings[nIndex] + _CRLF;

        if (XGMsgBox(Self.Handle, mtConfirmation, '�˸�', sDelayMsg, ['��', '�ƴϿ�']) <> mrOK) then
          raise Exception.Create('Ÿ�� ������ ��ҵǾ����ϴ�!');
      end;
    finally
      SL.Free;
    end;

    with ClientDM.MDTeeBoxSelected do
    try
      DisableControls;
      if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
         (not Global.NoShowInfo.NoShowReserved) then
      begin
        First;
        while not Eof do
        begin
          nIndex := FieldByName('teebox_index').AsInteger;
          dReserveDateTime := IncMinute(FTeeBoxPanels[nIndex].EndDateTime, Global.PrepareMin);
          if (dReserveDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
              FTeeBoxPanels[nIndex].TeeBoxName + '(��) Ÿ���� �����ð� ���Ŀ� ���۵ǹǷ� ������ �Ұ��մϴ�' + _CRLF +
                '[��������] ' + FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime) + _CRLF +
                '[����ð�] ' + FormatDateTime('yyyy-mm-dd hh:nn', dReserveDateTime), ['Ȯ��'], 5);
            Exit;
          end;

          Next;
        end;
      end;

      First;
      while not Eof do
      begin
        if Global.NoShowInfo.NoShowReserved then
        begin
          if (ClientDM.SPTeeBoxNoShowList.RecordCount = 0) then
            raise Exception.Create('���/��� ���� ���� ���õ��� �ʾҽ��ϴ�!');

          nPrepareMin := Global.NoShowInfo.PrepareMin;
          nAssignBalls := Global.NoShowInfo.AssignBalls;
          if (AProductMin > Global.NoShowInfo.AssignMin) and
             (XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
                Format('Ÿ����ǰ �̿�ð�(%d��)���� ���� �̿�ð�(%d��)�� �۽��ϴ�!', [AProductMin, Global.NoShowInfo.AssignMin]) + _CRLF +
                  '����ϸ� ���� �̿�ð� �������� ���� ����� �˴ϴ�.' + _CRLF +
                  'Ÿ�� ������ ��� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
            Exit;

          nAssignMin := IIF(AProductMin > Global.NoShowInfo.AssignMin, Global.NoShowInfo.AssignMin, AProductMin);
          Global.NoShowInfo.AssignMin := nAssignMin;
        end
        else
        begin
          nIndex := FieldByName('teebox_index').AsInteger;
          if not FTeeBoxPanels[nIndex].EndTime.IsEmpty then
            dCurEndDateTime := FTeeBoxPanels[nIndex].EndDateTime
          else
            dCurEndDateTime := Now;

          nPrepareMin := Global.PrepareMin;
          nAssignMin := AProductMin;
          nAssignBalls := 9999;
          dNewEndDateTime := IncMinute(dCurEndDateTime, Global.PrepareMin + nAssignMin);
          if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
             (dNewEndDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
            nAssignMin := (nAssignMin - MinutesBetween(dNewEndDateTime, SaleManager.StoreInfo.StoreEndDateTime));
        end;

        Edit;
        FieldValues['purchase_cd']   := APurchaseCode;
        FieldValues['product_cd']    := AProductCode;
        FieldValues['product_div']   := AProductDiv;
        FieldValues['product_nm']    := AProductName;
        FieldValues['avail_zone_cd'] := AAvailZoneCode;
        FieldValues['prepare_min']   := nPrepareMin;
        FieldValues['assign_min']    := nAssignMin;
        FieldValues['assign_balls']  := nAssignBalls;
        Post;

        //��� �����ֱ�� 1���� Ÿ���� ����
        if Global.NoShowInfo.NoShowReserved then
          Break;

        Next;
      end;
    finally
      EnableControls;
    end;

    //==============
    GO_TEEBOX_RETRY:
    //==============
    if Global.NoShowInfo.NoShowReserved then
      bTeeBoxSuccess := ClientDM.PostTeeBoxNoShowReserve('', '', sErrMsg)
    else
      bTeeBoxSuccess := ClientDM.PostTeeBoxReserve(SaleManager.MemberInfo.MemberNo, SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.HpNo, '', sErrMsg);

    if not bTeeBoxSuccess then
    begin
      if (XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
            '��ְ� �߻��Ͽ� Ÿ�� ������ �����Ͽ����ϴ�!' + _CRLF +
            '(' + sErrMsg + ')' + _CRLF +
            '���� ��û�� ��õ� �Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK) then
        goto GO_TEEBOX_RETRY;

      raise Exception.Create('���� ��û ��õ��� ����Ͽ����ϴ�!');
    end;

    try
      //��ȭ������ ��� ����ǥ ���� ����
      if not Global.TeeBoxTeleReserved then
      try
        sReceiptJson := ClientDM.MakeReceiptJson(bTeeBoxSuccess, sErrMsg);
        if not sErrMsg.IsEmpty then
          raise Exception.Create(sErrMsg);

        Global.ReceiptPrint.IsReturn := False;
        if not Global.ReceiptPrint.ReceiptPrint(sReceiptJson, False, False, sErrMsg) then
          raise Exception.Create(sErrMsg);
      except
        on E: Exception do
        begin
          UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReserveMember.ReceiptPrint.Exception = %s', [E.Message]));
          XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� ����ǥ�� ����� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
        end;
      end;
    finally
      if Global.NoShowInfo.NoShowReserved then
        DoRefreshNoShowList;

      ClientDM.ReloadTeeBoxStatus;
      ClientDM.ClearMemberInfo(Global.SaleFormId);
      DispMemberInfo;
      ClientDM.ClearSaleTables(Global.TableInfo.ActiveTableNo);
      ClearTeeBoxSelection(False, True);
    end;

    XGMsgBox(Self.Handle, mtInformation, '�˸�', SaleManager.MemberInfo.MemberName + ' ȸ���� Ÿ�� ������ �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReserveMember.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', 'Ÿ���� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

//����Ÿ����
procedure TXGTeeBoxViewForm.DoTeeBoxTicketDaily;
var
  PM: TPluginMessage;
  nIndex, nRecCount, nProdMin, nProdAmt, nXGolfDcAmt, nPrepareMin, nAssignMin, nAssignBalls, nSexDiv: Integer;
  sErrMsg, sProdCode, sProdDiv, sProdName, sZoneCode, sAvailZoneCode: string;
  sAffiliateCode, sAffiliateItem: string;
  dCurrentEndDateTime, dTeeBoxEndDateTime: TDateTime;
  bApplyXGolf, bIsAffiliate: Boolean;
begin
  if FWorking or
     (SaleManager.StoreInfo.POSType <> CPO_SALE_TEEBOX) or
     (not CheckSelectedTeeBox('����Ÿ����')) then
    Exit;

  FWorking := True;
  Global.TeeBoxTeleReserved := False;
  try
    try
      sZoneCode := FTeeBoxPanels[CurrentTeeBoxIndex].ZoneCode;
      //����Ÿ���� ������ ��� �������� ���ο��� ���� ���� Ȯ��
      bApplyXGolf := (not SaleManager.MemberInfo.XGolfMemberNo.IsEmpty) and
        (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          'XGOLF ȸ���� ������ �����̹Ƿ� ������ ����� �� �ֽ��ϴ�!' + _CRLF +
          'XGOLF ȸ�� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK);
      if not bApplyXGolf then
      begin
        ClientDM.ClearMemberInfo(Global.SaleFormId);
        DispMemberInfo;
      end;

      if not ClientDM.OpenTeeBoxProdList(CTP_DAILY, sZoneCode, True, nRecCount, sErrMsg) then
        raise Exception.Create(sErrMsg);
      if (nRecCount = 0) then
        raise Exception.Create('��� ������ ��ǰ�� �����ϴ�.');

      if Global.NoShowInfo.NoShowReserved then
        with ClientDM.SPTeeBoxNoShowList do
        begin
          Global.NoShowInfo.NoShowReserveNo := FieldByName('reserve_no').AsString;
          Global.NoShowInfo.TeeBoxNo := FieldByName('teebox_no').AsInteger;
          Global.NoShowInfo.PrepareMin := FieldByName('prepare_min').AsInteger;
          Global.NoShowInfo.AssignMin := FieldByName('assign_min').AsInteger;
          Global.NoShowInfo.AssignBalls := FieldByName('assign_balls').AsInteger;
          Global.NoShowInfo.ReserveDateTime := FieldByName('reserve_datetime').AsString;
        end;

      PM := TPluginMessage.Create(nil);
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_FORM_TITLE, '����Ÿ���� ��ǰ');
      if (PluginManager.OpenModal('XGTeeBoxProdList' + CPL_EXTENSION, PM) = mrOK) then
      begin
        with ClientDM.MDProdTeeBoxFiltered do
        begin
          sProdCode := FieldByName('product_cd').AsString;
          sProdDiv := FieldByName('product_div').AsString;
          sProdName := FieldByName('product_nm').AsString;
          nProdMin := FieldByName('one_use_time').AsInteger;
          nProdAmt := FieldByName('product_amt').AsInteger;
          nXGolfDcAmt := FieldByName('xgolf_dc_amt').AsInteger;
          nSexDiv := FieldByName('sex_div').AsInteger;
          sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
          bIsAffiliate := FieldByName('affiliate_yn').AsBoolean;
          if bIsAffiliate then
          begin
            sAffiliateCode := FieldByName('affiliate_cd').AsString;
            sAffiliateItem := FieldByName('affiliate_item_cd').AsString;
          end;
        end;

        (*
        //��������ð��� �ʰ��ϴ� ���
        if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
           (IncMinute(Now, nProdMin) >= SaleManager.StoreInfo.StoreEndDateTime) and
           (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
              '������ Ÿ���� �������� �ð��� �ʰ��ϹǷ� ���� ����� �� �ֽ��ϴ�!' + _CRLF +
              '�׷��� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
          Exit;
        *)

        //���� ���� Ÿ�� ��ǰ�� ������ ���
        if (not SaleManager.MemberInfo.MemberNo.IsEmpty) and
           (not ((SaleManager.MemberInfo.SexDiv = CSD_SEX_ALL) or
                 (nSexDiv = CSD_SEX_ALL) or
                 ((nSexDiv = CSD_SEX_FEMALE) and (SaleManager.MemberInfo.SexDiv = CSD_SEX_FEMALE)) or
                 ((nSexDiv = CSD_SEX_MALE) and (SaleManager.MemberInfo.SexDiv = CSD_SEX_MALE)))) then
        begin
          XGMsgBox(Self.Handle, mtWarning, '�˸�', 'ȸ���� �����δ� ������ �� ���� ��ǰ�Դϴ�!', ['Ȯ��'], 5);
          Exit;
        end;

        (*
        //VIP Ÿ���� ������ ���
        //�������� ��û���� VIP ��ǰ���� �˻�� �ӽ� ����(2019.12.13)
        with V3.DataController.Summary do
        begin
          nRecCnt := ClientDM.MDProdTeeBoxFilter.RecordCount;
          nVipCnt := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V3vip_yn)]), 0);
          if ((nVipCnt > 0) and (sZoneCd <> CTZ_TEEBOX_VIP)) or
             ((nVipCnt = 0) and (sZoneCd = CTZ_TEEBOX_VIP)) then
          begin
            XGMsgBox(Self.Handle, mtWarning, '�˸�',
              'VIP Ÿ����ǰ�� VIP Ÿ������ ��� �����մϴ�!', ['Ȯ��'], 5);
            Exit;
          end;
        end;
        *)

        with ClientDM.MDTeeBoxSelected do
        try
          DisableControls;
          nRecCount := RecordCount;
          First;
          while not Eof do
          begin
            nIndex := FieldByName('teebox_index').AsInteger;
            if Global.NoShowInfo.NoShowReserved then
            begin
              nPrepareMin := Global.NoShowInfo.PrepareMin;
              nAssignBalls := Global.NoShowInfo.AssignBalls;
              if (nProdMin > Global.NoShowInfo.AssignMin) and
                 (XGMsgBox(Self.Handle, mtConfirmation, '�˸�',
                    Format('Ÿ����ǰ �̿�ð�(%d��)���� ���� �̿�ð�(%d��)�� �۽��ϴ�!', [nProdMin, Global.NoShowInfo.AssignMin]) + _CRLF +
                      '����ϸ� ���� �̿�ð� �������� ���� ����� �˴ϴ�.' + _CRLF +
                      'Ÿ�� ������ ��� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
                Exit;

              nAssignMin := IIF(nProdMin > Global.NoShowInfo.AssignMin, Global.NoShowInfo.AssignMin, nProdMin);
              Global.NoShowInfo.AssignMin := nAssignMin;
            end
            else
            begin
              if (not FTeeBoxPanels[nIndex].EndTime.IsEmpty) then
                dCurrentEndDateTime := FTeeBoxPanels[nIndex].EndDateTime
              else
                dCurrentEndDateTime := Now;

              nPrepareMin := Global.PrepareMin;
              nAssignMin := nProdMin;
              nAssignBalls := 9999;
              dTeeBoxEndDateTime := IncMinute(dCurrentEndDateTime, Global.PrepareMin + nAssignMin);
              if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
                 (dTeeBoxEndDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
                nAssignMin := (nAssignMin - MinutesBetween(dTeeBoxEndDateTime, SaleManager.StoreInfo.StoreEndDateTime));
            end;

            Edit;
            FieldValues['teebox_div']    := CTP_DAILY;
            FieldValues['product_cd']    := sProdCode;
            FieldValues['product_div']   := sProdDiv;
            FieldValues['product_nm']    := sProdName;
            FieldValues['product_div']   := sProdDiv;
            FieldValues['zone_cd']       := sZoneCode;
            FieldValues['avail_zone_cd'] := sAvailZoneCode;
            FieldValues['prepare_min']   := nPrepareMin;
            FieldValues['assign_min']    := nAssignMin;
            FieldValues['assign_balls']  := nAssignBalls;
            Post;

            //��� �����ֱ�� 1���� Ÿ���� ����
            if Global.NoShowInfo.NoShowReserved then
              Break;

            Next;
          end;
        finally
          EnableControls;
        end;

        ShowSalePos(Self.PluginID);
        PM.ClearParams;
        PM.Command := CPC_SEND_TEEBOX_PROD_CD;
        PM.AddParams(CPP_SALE_DIV,        CPD_TEEBOX);
        PM.AddParams(CPP_TEEBOX_PROD_DIV, sProdDiv);
        PM.AddParams(CPP_PRODUCT_CD,      sProdCode);
        PM.AddParams(CPP_PRODUCT_NAME,    sProdName);
        PM.AddParams(CPP_PRODUCT_AMT,     nProdAmt);
        if bApplyXGolf then
          PM.AddParams(CPP_XGOLF_DC_AMT, nXGolfDcAmt * nRecCount)
        else
          PM.AddParams(CPP_XGOLF_DC_AMT, 0);
        PM.AddParams(CPP_PRODUCT_QTY, nRecCount);
        PM.AddParams(CPP_AFFILIATE_YN, bIsAffiliate);
        if bIsAffiliate then
        begin
          PM.AddParams(CPP_AFFILIATE_CODE, sAffiliateCode);
          PM.AddParams(CPP_AFFILIATE_ITEM, sAffiliateItem);
        end;
        PM.PluginMessageToID(Global.SaleFormId);
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxTicketDaily.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', 'Ÿ����ǰ ����� �ҷ��� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

//ȸ���� �߸�
procedure TXGTeeBoxViewForm.DoTeeBoxTicketMember(const ATeleReserved: Boolean);
var
  PM: TPluginMessage;
  nTeeBoxCount, nProdMin, nRemainCount: Integer;
  sProdCode, sProdDiv, sProdName, sPurchaseCode, sAvailZoneCode: string;
  bCouponUseOnly: Boolean;
begin
  if FWorking or
     (SaleManager.StoreInfo.POSType <> CPO_SALE_TEEBOX) or
     (not CheckSelectedTeeBox('��ȸ��/����ȸ����')) then
    Exit;

  FWorking := True;
  Global.TeeBoxTeleReserved := ATeleReserved;
  try
    nTeeBoxCount := ClientDM.MDTeeBoxSelected.RecordCount;
    bCouponUseOnly := (nTeeBoxCount > 1);
    try
      if (ClientDM.QRSaleItem.RecordCount > 0) or
         (ClientDM.QRPayment.RecordCount > 0) or
         (ClientDM.QRCoupon.RecordCount > 0) then
        raise Exception.Create('ó������ ���� �ֹ������� �ֽ��ϴ�!');

      if Global.NoShowInfo.NoShowReserved then
        with ClientDM.SPTeeBoxNoShowList do
        begin
          Global.NoShowInfo.NoShowReserveNo := FieldByName('reserve_no').AsString;
          Global.NoShowInfo.TeeBoxNo := FieldByName('teebox_no').AsInteger;
          Global.NoShowInfo.PrepareMin := FieldByName('prepare_min').AsInteger;
          Global.NoShowInfo.AssignMin := FieldByName('assign_min').AsInteger;
          Global.NoShowInfo.AssignBalls := FieldByName('assign_balls').AsInteger;
          Global.NoShowInfo.ReserveDateTime := FieldByName('reserve_datetime').AsString;
        end;

      if SaleManager.MemberInfo.MemberNo.IsEmpty then
      begin
        PM := TPluginMessage.Create(nil);
        try
          PM.Command := CPC_INIT;
          PM.AddParams(CPP_OWNER_ID, Self.PluginID);
          PluginManager.OpenModal('XGMember' + CPL_EXTENSION, PM);
        finally
          FreeAndNil(PM);
        end;
      end else
      begin
        if (nTeeBoxCount = 0) then
          raise Exception.Create('������ Ÿ���� ���õ��� �ʾҽ��ϴ�!');

        PM := TPluginMessage.Create(nil);
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, Self.PluginID);
        PM.AddParams(CPP_TEEBOX_PROD_CHANGE, False);
        if (PluginManager.OpenModal('XGTeeBoxProdMember' + CPL_EXTENSION, PM) = mrOK) then
          with ClientDM.MDTeeBoxProdMember do
          begin
            sProdCode := FieldByName('product_cd').AsString;
            sProdDiv := FieldByName('product_div').AsString;
            sProdName := FieldByName('product_nm').AsString;
            nProdMin := FieldByName('one_use_time').AsInteger;
            nRemainCount := FieldByName('remain_cnt').AsInteger;
            sPurchaseCode := FieldByName('purchase_cd').AsString;
            sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
            if (sProdDiv = CTP_COUPON) then
            begin
              if (nRemainCount < nTeeBoxCount) then
                raise Exception.Create('�ܿ����� ���� �����Ͽ� ������ ������ �� �����ϴ�!');
            end
            else
            begin
              if bCouponUseOnly then
                raise Exception.Create('1�� �̻� Ÿ���� ���� ������ ����ȸ�������θ� �����մϴ�!');
            end;

            if bCouponUseOnly and
               (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
                  '������ ��ǰ���� Ÿ���� �����Ͻðڽ��ϱ�?' + _CRLF +
                  '��ǰ�� : ' + sProdName + _CRLF +
                  '�������� : ' + IntToStr(nTeeBoxCount), ['��', '�ƴϿ�']) <> mrOK) then
              Exit;

            DoTeeBoxReserveMember(sProdCode, sProdDiv, sProdName, sPurchaseCode, sAvailZoneCode, nProdMin);
          end;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxTicketMember.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

//�ŷ����� ��ȸ
procedure TXGTeeBoxViewForm.DoSaleReceiptView;
var
  PM: TPluginMessage;
begin
  if FWorking then
    Exit;

  FWorking := True;
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('XGReceiptView' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
    Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
    Global.DeviceConfig.RFIDReader.OwnerId := Self.PluginID;
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoMemberAdd;
var
  PM: TPluginMessage;
  sErrMsg: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      if not ClientDM.GetMemberList(sErrMsg) then //ȸ�� ������ ����
        raise Exception.Create(sErrMsg);

      PM := TPluginMessage.Create(nil);
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_DATA_MODE, CDM_NEW_DATA);
      if (PluginManager.OpenModal('XGMember' + CPL_EXTENSION, PM) = mrOK) then
        XGMsgBox(Self.Handle, mtInformation, '�˸�', 'ȸ�������� ��� �Ǿ����ϴ�!', ['Ȯ��'], 5);
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoMemberAdd.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� �۾��� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoMemberSearchAndEdit;
var
  PM: TPluginMessage;
  sErrMsg: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    ClientDM.GetMemberList(sErrMsg); //ȸ�� ������ ����
    PM := TPluginMessage.Create(nil);
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_DATA_MODE, CDM_VIEW_ONLY);
    if not SaleManager.MemberInfo.MemberNo.IsEmpty then
    begin
      ClientDM.ClearMemberInfo(Global.SaleFormId);
      DispMemberInfo;
    end
    else
    begin
      PM.AddParams(CPP_MEMBER_NAME, edtMemberName.Text);
      PM.AddParams(CPP_HP_NO, edtMemberHpNo.Text);
      PM.AddParams(CPP_CAR_NO, edtMemberCarNo.Text);
    end;
    PluginManager.OpenModal('XGMember' + CPL_EXTENSION, PM);
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoLockerView;
var
  PM: TPluginMessage;
begin
  if FWorking or
     (SaleManager.StoreInfo.POSType <> CPO_SALE_TEEBOX) then
    Exit;

  FWorking := True;
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_LOCKER_SELECT, False);
    PluginManager.OpenModal('XGLocker' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxReservedMove;
var
  PM: TPluginMessage;
  sReceiptJson, sMemberNo, sAvailZoneCode, sTargetTeeBoxName, sTargetFloorCode, sTargetZoneCode, sErrMsg: string;
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
          raise Exception.Create('�̵��� ���� ������ ���õ��� �ʾҽ��ϴ�!');

        sMemberNo := FieldByName('member_no').AsString;
        nSourceTeeBoxNo := FieldByName('teebox_no').AsInteger;
        nRemainMin := FieldByName('assign_min').AsInteger;
        sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
        if (nRemainMin <= 1) then
          raise Exception.Create('����ð��� �ӹ��Ͽ� Ÿ�� �̵��� �Ұ��մϴ�!');

        nSourceIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
        if (FTeeBoxPanels[nSourceIndex].CurStatus = CTS_TEEBOX_STOP_ALL) then
          raise Exception.Create('�� ȸ�� ���� ���¿����� Ÿ�� �̵��� �Ұ��մϴ�!');
      end;

      with ClientDM.MDTeeBoxSelected do
      try
        DisableControls;
        if (RecordCount = 0) then
          raise Exception.Create('�̵��� ��� Ÿ���� ���õ��� �ʾҽ��ϴ�!' + _CRLF +
            '�̵��� ��ġ�� Ÿ���� �ӽÿ������� ����Ͽ� �ֽʽÿ�.');
        if (RecordCount > 1) then
          raise Exception.Create('���� Ÿ�������� Ÿ�� �̵��� �Ұ��մϴ�!' + _CRLF +
            '1���� Ÿ���� �ӽÿ������� ��ϵǾ�� �մϴ�.');

        nTargetTeeBoxNo := FieldByName('teebox_no').AsInteger;
        sTargetTeeBoxName := FieldByName('teebox_nm').AsString;
        sTargetFloorCode := FieldByName('floor_cd').AsString;
        sTargetZoneCode := FieldByName('zone_cd').AsString;
        if (nTargetTeeBoxNo = nSourceTeeBoxNo) then
          raise Exception.Create('������ Ÿ������ Ÿ���� �̵��� �� �����ϴ�!');
        if (not sTargetZoneCode.IsEmpty) and
           (Pos(sTargetZoneCode, sAvailZoneCode) = 0) then
          raise Exception.Create(
            Format('%s(��) Ÿ������ �̵��� �� ���� ��ǰ�� �����Դϴ�!', [sTargetTeeBoxName]) + _CRLF +
            '[�̵��� Ÿ�� ����] ' + ClientDM.GetZoneCodeNames(sTargetZoneCode) + _CRLF +
            '[������ ��ǰ ����] ' + ClientDM.GetZoneCodeNames(sAvailZoneCode));

        PM := TPluginMessage.Create(nil);
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, Self.PluginID);
        PM.AddParams(CPP_TEEBOX_NO, nTargetTeeBoxNo);
        PM.AddParams(CPP_TEEBOX_NAME, sTargetTeeBoxName);
        PM.AddParams(CPP_FLOOR_CODE, sTargetFloorCode);
        if (PluginManager.OpenModal('XGTeeBoxMove' + CPL_EXTENSION, PM) = mrOK) then
        begin
          ClientDM.ClearMemberInfo(Global.SaleFormId);
          DispMemberInfo;
          if (not sMemberNo.IsEmpty) and
             (not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg)) then
            XGMsgBox(Self.Handle, mtInformation, '�˸�', Format('ȸ����ȣ [%s]�� ������ �������� �ʽ��ϴ�!', [sMemberNo]) + _CRLF + sErrMsg, ['Ȯ��'], 5);

          try
            if Global.DeviceConfig.ReceiptPrinter.Enabled and
               Global.TeeBoxChangedReIssue then
              sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
          finally
            ClearTeeBoxSelection(True, True);
            ClientDM.ClearMemberInfo(Global.SaleFormId);
            DispMemberInfo;
          end;

          try
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
            begin
              UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedMove.ReceiptPrint.Exception = %s', [E.Message]));
              XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� ����ǥ�� ����� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
            end;
          end;

          ClientDM.ReloadTeeBoxStatus;
          XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� �̵��� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
        end;
      finally
        EnableControls;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedMove.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, 'Ÿ�� �̵�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FWorking := False;
    if Assigned(PM) then
      FreeAndNil(PM);
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxReservedChange;
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
          raise Exception.Create('������ ���� ������ ���õ��� �ʾҽ��ϴ�!');

        sMemberNo := FieldByName('member_no').AsString;
        nTeeBoxNo := FieldByName('teebox_no').AsInteger;
        sStartDateTime := FieldByName('start_datetime').AsString;
        bIsPlaying := FieldByName('play_yn').AsBoolean;
        nPrepareMin := FieldByName('prepare_min').AsInteger;
        nRemainMin := FieldByName('assign_min').AsInteger;
        if (nRemainMin <= 1) then
          raise Exception.Create('����ð��� �ӹ��Ͽ� �ð� �߰��� �Ұ��մϴ�!');

        if bIsPlaying then
        begin
          nPrepareMin := 0;
          nRemainMin := FieldByName('calc_remain_min').AsInteger;
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
            XGMsgBox(Self.Handle, mtWarning, '�˸�', '��� ���� ���������� �־ ������ ������ �� �����ϴ�!', ['Ȯ��'], 5);
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
          ClientDM.ClearMemberInfo(Global.SaleFormId);
          DispMemberInfo;
          if not sMemberNo.IsEmpty then
            if not ClientDM.SearchMemberByCode(CMC_MEMBER_CODE, sMemberNo, sErrMsg) then
              raise Exception.Create(sErrMsg);

          try
            if Global.TeeBoxChangedReIssue then
              sReceiptJson := ClientDM.MakeReceiptJson(True, sErrMsg);
          finally
            ClientDM.ClearMemberInfo(Global.SaleFormId);
            DispMemberInfo;
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
            begin
              UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedChange.ReceiptPrint.Exception = %s', [E.Message]));
              XGMsgBox(Self.Handle, mtWarning, '�˸�', 'Ÿ�� ����ǥ�� ����� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
            end;
          end;

          ClientDM.ReloadTeeBoxStatus;
          XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� ���� ������ �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
        end;
      finally
        EnableControls;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedChange.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, 'Ÿ�� ���� ����', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    if Assigned(PM) then
      FreeAndNil(PM);
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxReservedCancel;
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
    if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '����� Ÿ�� ���� ������ ����Ͻðڽ��ϱ�?' + _CRLF +
        Format('%s�� Ÿ��(�����ȣ: %s)', [sTeeBoxName, sReserveNo]), ['��', '�ƴϿ�']) <> mrOK) then
      Exit;

    try
      if not ClientDM.CancelTeeBoxReserve(sReserveNo, '', sErrMsg) then
        raise Exception.Create(sErrMsg);

      ClientDM.ReloadTeeBoxStatus;
      XGMsgBox(Self.Handle, mtInformation, '�˸�', 'Ÿ�� ������ ��ҵǾ����ϴ�!' + _CRLF +
        Format('%s�� Ÿ��(�����ȣ: %s)', [sTeeBoxName, sReserveNo]), ['Ȯ��'], 5);
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxReservedCancel.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGTeeBoxViewForm.DoTeeBoxPauseOrRestart;
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
    sTitle := 'Ÿ�� ����/�簡�� ���';
    try
      if (FTeeBoxPanels[CurrentTeeBoxIndex].CurStatus = CTS_TEEBOX_STOP) then
      begin
        nNewCmd := CTS_TEEBOX_READY;
        sSubCmd := CPC_TEEBOX_READY;
        sTitle := '�簡��';
        MR := XGMsgBox(Self.Handle, mtConfirmation, sTitle,
                Format('%s(��) Ÿ���� %s ���·� �����Ͻðڽ��ϱ�?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['��', '�ƴϿ�']);
      end else
      begin
        nNewCmd := CTS_TEEBOX_STOP;
        sSubCmd := CPC_TEEBOX_STOP;
        sTitle  := '������';
        MR := XGMsgBox(Self.Handle, mtConfirmation, sTitle,
                Format('%s(��) Ÿ���� %s ���·� �����Ͻðڽ��ϱ�?', [FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName, sTitle]), ['��', '�ƴϿ�']);
      end;

      if (MR in [mrOK, mrYes]) then
      begin
        (*
        // ���� ���ν����� ����
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

        XGMsgBox(Self.Handle, mtInformation, sTitle, Format('%s ���·� ������ �Ϸ�Ǿ����ϴ�.', [sTitle]), ['Ȯ��'], 5);
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxPauseOrRestart.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, sTitle, sTitle + ' �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FWorking := False;
  end;
end;

//Ÿ�� ����
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
    if (CurrentTeeBoxIndex < 0) or
       (RecordCount = 0) then
      Exit;

    try
      bIsPlay := FieldByName('play_yn').AsBoolean;
      sReserveNo := FieldByName('reserve_no').AsString;
      nTeeBoxNo := FieldByName('teebox_no').AsInteger;
      if not bIsPlay then
      begin
        XGMsgBox(Self.Handle, mtWarning, 'Ÿ�� ����', '�̿� ���� Ÿ���� �ƴմϴ�!', ['Ȯ��'], 5);
        Exit;
      end;

      if (XGMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
            FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName + '(��) Ÿ���� �����Ͻðڽ��ϱ�?' + _CRLF +
            '������ Ÿ���� ������� ���·� ����˴ϴ�.', ['��', '�ƴϿ�']) = mrOK) then
      begin
        if not ClientDM.CloseTeeBoxReserve(sReserveNo, nTeeBoxNo, sErrMsg) then
          raise Exception.Create(sErrMsg);

        ClientDM.ReloadTeeBoxStatus;
        XGMsgBox(Self.Handle, mtInformation, 'Ÿ�� ����', 'Ÿ�� ���� �۾��� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxClearance.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, 'Ÿ�� ����', '��ְ� �߻��Ͽ� �۾��� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FWorking := False;
  end;
end;

//�� ȸ��
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
            raise Exception.Create('�ӽÿ����� �� Ÿ���� �����մϴ�!');

          Next;
        end;
      finally
        EnableControls;
      end;

      if StoppedAll then
      begin
        nNewCmd := CTS_TEEBOX_READY;
        sTitle  := '�� ȸ�� ����';
      end else
      begin
        nNewCmd := CTS_TEEBOX_STOP_ALL;
        sTitle := '�� ȸ�� ����';
      end;

      if (XGMsgBox(Self.Handle, mtConfirmation, sTitle,
        sTitle + ' �۾��� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK) then
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

        btnSaleTeeBoxStoppedAll.Enabled := False; //Ÿ�� ���¸� �ٽ� ���� ������ ��� �Ұ� ó��
          XGMsgBox(Self.Handle, mtInformation, sTitle, sTitle + ' �۾��� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxStoppedAll.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, sTitle, sTitle + ' �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FWorking := False;
  end;
end;

//��ù���
procedure TXGTeeBoxViewForm.DoTeeBoxImmediateStart;
var
  nTeeBoxNo: Integer;
  sTeeBoxName, sReserveNo, sReserveDateTime, sErrMsg: string;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    try
      if (RecordCount = 0) then
        Exit;
      if (FieldByName('play_yn').AsBoolean = True) then
        raise Exception.Create(Format('�̹� �����Ǿ� ��� ���� Ÿ���Դϴ�!', [sTeeBoxName]));

      nTeeBoxNo := FieldByName('teebox_no').AsInteger;
      sTeeBoxName := FieldByName('teebox_nm').AsString;
      sReserveNo := FieldByName('reserve_no').AsString;
      sReserveDateTime := FieldByName('reserve_datetime').AsString;
      with TxQuery.Create(nil) do
      try
        AddDataSet(ClientDM.MDTeeBoxReserved2, 'R');
        SQL.Add('SELECT R.reserve_no FROM R WHERE R.teebox_no = :teebox_no AND reserve_datetime < :reserve_datetime;');
        Close;
        Params.ParamValues['teebox_no'] := nTeeBoxNo;
        Params.ParamValues['reserve_datetime'] := sReserveDateTime;
        Open;
        if (RecordCount > 0) then
          raise Exception.Create(Format('������ %s(��) Ÿ���� ������ ��� ������ �Ұ��մϴ�!', [sTeeBoxName]));
      finally
        Close;
        Free;
      end;

      if not ClientDM.ImmediateTeeBoxStart(sReserveNo, sErrMsg) then
        raise Exception.Create(sErrMsg);
    finally
      EnableControls;
    end;

    SendPluginCommand(CPC_TEEBOX_GETDATA, Self.PluginId, Global.StartModuleId);
    XGMsgBox(Self.Handle, mtInformation, '��� ����', Format('%s�� Ÿ���� ��� ������ �Ϸ� �Ǿ����ϴ�!', [sTeeBoxName]), ['Ȯ��'], 5);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxImmediateStart.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '��� ����', '��� ������ �����Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

//��� ��Ȳ ��ȸ
procedure TXGTeeBoxViewForm.DoRefreshNoShowList;
var
  sErrMsg: string;
begin
  try
    if not ClientDM.GetTeeBoxNoShowList(sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoRefreshNoShowList.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '�˸�', '��� ��Ȳ�� ��ȸ�� �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
    end;
  end;
end;

//��� ����Ÿ���� ����
procedure TXGTeeBoxViewForm.DoReserveNoShowTicketDaily;
var
  nTeeBoxIndex: Integer;
  sErrMsg: string;
begin
  if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
    ClearTeeBoxSelection(True, True);

  with ClientDM.SPTeeBoxNoShowList do
  begin
    if (RecordCount = 0) then
      Exit;

    nTeeBoxIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
    if (nTeeBoxIndex < 0) then
      Exit;

    if not FTeeBoxPanels[nTeeBoxIndex].Selected then
    begin
      CurrentTeeBoxIndex := nTeeBoxIndex;
      if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
      begin
        XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
        Exit;
      end;
    end;

    DoTeeBoxTicketDaily;
  end;
end;

//��� ȸ���� ����
procedure TXGTeeBoxViewForm.DoReserveNoShowTicketMember(const ATeleReserved: Boolean);
var
  nTeeBoxIndex: Integer;
  sErrMsg: string;
begin
  ClientDM.ClearMemberInfo(Global.SaleFormId);
  DispMemberInfo;
  if (ClientDM.MDTeeBoxSelected.RecordCount > 0) then
    ClearTeeBoxSelection(True, True);

  with ClientDM.SPTeeBoxNoShowList do
  begin
    if (RecordCount = 0) then
      Exit;

    nTeeBoxIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
    if (nTeeBoxIndex < 0) then
      Exit;

    if not FTeeBoxPanels[nTeeBoxIndex].Selected then
    begin
      CurrentTeeBoxIndex := nTeeBoxIndex;
      if not DoTeeBoxHoldByIndex(CurrentTeeBoxIndex, sErrMsg) then
      begin
        XGMsgBox(Self.Handle, mtError, '�˸�', '�ӽÿ��� ��� �۾��� ó������ ���Ͽ����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
        Exit;
      end;
    end;

    DoTeeBoxTicketMember(ATeleReserved);
  end;
end;

//����� ���� ȸ�� QR�ڵ� üũ��
procedure TXGTeeBoxViewForm.DoCheckinQRCodeMobileReserved(const AMemberQRCode: string);
var
  BM: TBookmark;
  sErrMsg: string;
begin
  if ClientDM.SearchMemberByCode(CMC_MEMBER_QRCODE, AMemberQRCode, sErrMsg) then
  else
    XGMsgBox(Self.Handle, mtWarning, '�˸�',
      Format('[QR�ڵ�: %s] �� ȸ�������� �������� �ʽ��ϴ�.', [AMemberQRCode]) + _CRLF + sErrMsg, ['Ȯ��'], 5);

  with ClientDM.MDTeeBoxReserved2 do
  try
    DisableControls;
    BM := GetBookmark;
    if BookmarkValid(BM) then
      GotoBookmark(BM);

    First;
    while not Eof do
    begin

      Next;
    end;
  finally
    FreeBookmark(BM);
    EnableControls;
  end;
end;

//����� ���� ȸ�� üũ��
procedure TXGTeeBoxViewForm.DoCheckinMobileReserved;
var
  BM: TBookmark;
  CL: TCheckinList;
  sReserveNo, sErrCode, sErrMsg: string;
  bIsSuccess: Boolean;
  I, nTeeBoxNo: Integer;
begin
  with ClientDM.MDTeeBoxReserved2 do
  try
    DispMemberInfo;
    DisableControls;
    BM := GetBookmark;
    CL := TCheckinList.Create;
    try
      if (not ClientDM.PostTeeBoxReserveCheckinServer(SaleManager.MemberInfo.MemberNo, CL, sErrCode, sErrMsg)) then
        if (sErrCode = '9992') then //��Ʈ�ʼ��� �󿡼� �̹� üũ�� �� ���� ������ �ƴϸ�
        begin
          sReserveNo := FieldByName('reserve_no').AsString;
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          CL.Clear;
          CL.AddItem(sReserveNo, nTeeBoxNo);
        end
        else
          raise Exception.Create(sErrMsg);

      bIsSuccess := ClientDM.PostTeeBoxReserveCheckinLocal(CL, sErrMsg);
      if not bIsSuccess then
        raise Exception.Create(sErrMsg);

      try
        for I := 0 to Pred(CL.Count) do
        begin
          sReserveNo := PCheckinItem(CL.ItemList[I])^.ReserveNo;
          nTeeBoxNo := PCheckinItem(CL.ItemList[I])^.TeeBoxNo;
          if not Locate('reserve_no;teebox_no', VarArrayOf([sReserveNo, nTeeBoxNo]), []) then
            Continue;

          if not DoTeeBoxTicketReprint(sErrMsg) then
            raise Exception.Create(sErrMsg);
        end;
      except
        on E: Exception do
        begin
          UpdateLog(Global.LogFile, Format('TeeBoxView.DoCheckinMobileReserved.DoTeeBoxTicketReprint.Exception = %s', [E.Message]));
          XGMsgBox(Self.Handle, mtWarning, '�˸�', '����ǥ�� ������ �� �����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
        end;
      end;

      if BookmarkValid(BM) then
        GotoBookmark(BM);

      if bIsSuccess then
        XGMsgBox(Self.Handle, mtInformation, '�˸�', SaleManager.MemberInfo.MemberName + ' ȸ���� ���� üũ���� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('TeeBoxView.DoCheckinMobileReserved.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '�˸�', SaleManager.MemberInfo.MemberName + ' ȸ���� ���� üũ���� ó������ ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    FreeBookmark(BM);
    EnableControls;
    CL.Free;
    ClientDM.ClearMemberInfo(Global.SaleFormId);
    DispMemberInfo;
  end;
end;

//����ǥ �����
function TXGTeeBoxViewForm.DoTeeBoxTicketReprint(var AErrMsg: string): Boolean;
var
  nPrepareMin: Integer;
  sReserveNo, sTicketJson, sErrMsg: string;
  bTeeBoxMoved: Boolean;
begin
  Result := False;
  AErrMsg := '';
  with ClientDM.MDTeeBoxReserved2 do
  try
//    nUseSeq := FieldByName('use_seq').AsInteger;
    sReserveNo := FieldByName('reserve_no').AsString;
    nPrepareMin := FieldByName('prepare_min').AsInteger;
    bTeeBoxMoved := FieldByName('reserve_move_yn').AsBoolean;

    if not ClientDM.GetTeeBoxTicketInfo(sReserveNo, bTeeBoxMoved, nPrepareMin, sErrMsg) then
      raise Exception.Create(sErrMsg);

    sTicketJson := ClientDM.MakeTeeBoxTicketJson(sErrMsg);
    if not sErrMsg.IsEmpty then
      raise Exception.Create(sErrMsg);

    if not Global.ReceiptPrint.TeeBoxTicketPrint(sTicketJson, True, False, sErrMsg) then
      raise Exception.Create(sErrMsg);

    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxTicketReprint.Exception = %s', [E.Message]));
    end;
  end;
end;

//�ǳ������� Ÿ���� ������Ʈ ����
procedure TXGTeeBoxViewForm.DoTeeBoxAgentControl(const AMethod: Integer);
var
  MR: TModalResult;
  nTeeBoxNo: Integer;
  sTeeBoxName, sMethod, sErrMsg: string;
begin
  try
    case AMethod of
      CTA_CTRL_WAKEONLAN:
        sMethod := mnuTeeBoxWakeOnLAN.Caption;
      CTA_CTRL_SHUTDOWN:
        sMethod := mnuTeeBoxAgentShutdown.Caption;
      CTA_CTRL_REBOOT:
        sMethod := mnuTeeBoxAgentReboot.Caption;
      CTA_CTRL_UPDATE:
        sMethod := mnuTeeBoxAgentUpdate.Caption;
      CTA_CTRL_CLOSE:
        sMethod := mnuTeeBoxAgentClose.Caption;
      CTA_CTRL_LBP_ON:
        sMethod := mnuTeeBoxProjectorOn.Caption;
      CTA_CTRL_LBP_OFF:
        sMethod := mnuTeeBoxProjectorOff.Caption;
    else
      Exit;
    end;

    sTeeBoxName := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxName;
    MR := XGMsgBox(Self.Handle, mtConfirmation, sMethod, '�۾��� ��� Ÿ���� �����Ͽ� �ֽʽÿ�.', [sTeeBoxName, '���', '��ü Ÿ��']);
    case MR of
      mrOK: nTeeBoxNo := FTeeBoxPanels[CurrentTeeBoxIndex].TeeBoxNo; //���� ���õ� Ÿ��
      mrYesToAll: nTeeBoxNo := 0; //��ü Ÿ��
    else
      Exit;
    end;

    if (nTeeBoxNo < 0) then
      raise Exception.Create('�۾��� ��� Ÿ���� �����ϴ�!');
    if not ClientDM.SetTeeBoxAgentControl(nTeeBoxNo, AMethod, sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('TeeBoxView.DoTeeBoxAgentControl.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, sMethod, sMethod + ' ��û�� �����Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
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
    ShowHint := True;
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
    AutoSize := False;
    Height := 23;
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
    AutoSize := False;
    Height := 23;
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
    AutoSize := False;
    Height := 23;
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
    Style.Font.Color := $00FF8000; //clBlack;
    Style.Font.Style := [];
    StyleDisabled.Color := clBtnFace;
  end;

  ReservedPanel := TPanel.Create(Self);
  with ReservedPanel do
  begin
    DoubleBuffered := True;
    Parent := Self;
    Caption := '';
    Height := 24;
    Width := 49;
    Margins.Top := 1;
    Margins.Left := 1;
    Margins.Bottom := 1;
    Margins.Right := 1;
    BorderStyle := bsNone;
    BevelOuter := bvNone;
    Top := EndTimeLabel.Top + 1;
    AlignWithMargins := True;
    Align := alClient;
    ParentFont := False;
    ParentColor := True;
    Color := $00FFFFFF;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Font.Color := clBlack;
    Font.Style := [];
  end;

  LessonProColorLabel := TcxLabel.Create(Self);
  with LessonProColorLabel do
  begin
    DoubleBuffered := True;
    Parent := ReservedPanel;
    Caption := '';
    Height := 24;
    Width := 15;
    Align := alLeft;
    AutoSize := False;
    ParentFont := False;
    ParentColor := False;
    ShowHint := True;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $00FFFFFF;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    StyleDisabled.Color := clBtnFace;
    Visible := False;
  end;

  TeeBoxAgentStatusLabel := TcxLabel.Create(Self);
  with TeeBoxAgentStatusLabel do
  begin
    DoubleBuffered := True;
    Parent := ReservedPanel;
    Caption := 'T';
    Height := 24;
    Width := 15;
    Align := alRight;
    AutoSize := False;
    ParentFont := False;
    ParentColor := False;
    Properties.Alignment.Horz := taCenter;
    Properties.Alignment.Vert := taVCenter;
    ShowHint := True;
    Style.BorderStyle := ebsUltraFlat;
    Style.Color := $005C5C5C;
    Style.Edges := [];
    Style.LookAndFeel.AssignedValues := [lfvNativeStyle];
    Style.LookAndFeel.Kind := lfUltraFlat;
    Style.LookAndFeel.NativeStyle := False;
    Style.Font.Name := 'Noto Sans CJK KR Regular';
    Style.Font.Size := 9;
    Style.Font.Color := clWhite;
    Style.Font.Style := [];
    StyleDisabled.Color := clBtnFace;
    Visible := False;
  end;
end;

destructor TTeeBoxPanel.Destroy;
begin
  TeeBoxTitle.Free;
  MemberLabel.Free;
  RemainMinLabel.Free;
  EndTimeLabel.Free;
  ReservedPanel.Free;

  inherited;
end;

procedure TTeeBoxPanel.SetAirConYN(const AValue: Boolean);
begin
  FAirConYN := AValue;
  if AValue then
  begin
    MemberLabel.Style.Color := $000077EE;
    MemberLabel.Style.Font.Color := $00FFFFFF;
  end else
  begin
    MemberLabel.Style.Color := $00EAFFFF;
    MemberLabel.Style.Font.Color := $00000000;
  end;
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
  if not AValue then
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
    TeeBoxTitle.Font.Color := $00FFFFFF //clWhite
  else
    TeeBoxTitle.Color := GCR_COLOR_HOLD_SELF;

  with TPluginMessage.Create(nil) do
  try
    Command := CPC_TEEBOX_SELECT;
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

procedure TTeeBoxPanel.SetLessonProColor(const AValue: Integer);
begin
  if (FLessonProColor <> AValue) then
  begin
    FLessonProColor := AValue;
    LessonProColorLabel.Style.Color := TColor(FLessonProColor);
  end;
end;

procedure TTeeBoxPanel.SetLessonProName(const AValue: string);
begin
  if (FLessonProName <> AValue) then
  begin
    FLessonProName := AValue;
    LessonProColorLabel.Hint := FLessonProName;
    LessonProColorLabel.Visible := not FLessonProName.IsEmpty;
  end;
end;

procedure TTeeBoxPanel.SetFloorCode(const AValue: string);
begin
  FFloorCode := AValue;
end;

procedure TTeeBoxPanel.SetRemainMin(const AValue: Integer);
begin
  FRemainMin := AValue;
end;

procedure TTeeBoxPanel.SetTeeBoxAgentStatus(const AValue: Integer);
var
  bActive: Boolean;
begin
  if (FTeeBoxAgentStatus <> AValue) then
  begin
    FTeeBoxAgentStatus := AValue;
    bActive := (SaleManager.StoreInfo.OutdoorDiv = CGD_INDOOR) and (FTeeBoxAgentStatus = 0); //0:���, 1:����
    TeeBoxAgentStatusLabel.Visible := bActive;
    TeeBoxAgentStatusLabel.Hint := IIF(bActive, Format('Ÿ���� ������Ʈ ���(%d)', [FTeeBoxAgentStatus]), '');
  end;
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
  ReservedPanel.Caption := '';
  sHintVip := '';

  if VipYN then
    sHintVip := 'VIP' + _CRLF;

  try
    if not UseYN then
    begin
      MemberLabel.Caption := '���Ұ�';
      TeeBoxTitle.Hint := sHintVip + '���Ұ�';
      TeeBoxTitle.Color := GCR_COLOR_ERROR;
      Exit;
    end;

    case FCurStatus of
      CTS_TEEBOX_READY:
      begin
        MemberLabel.Caption := '';
        TeeBoxTitle.Hint := sHintVip + '���డ��';
        TeeBoxTitle.Color := GCR_COLOR_READY;
      end;

      CTS_TEEBOX_RESERVED,
      CTS_TEEBOX_USE:
      begin
        if (RemainMin <= Global.GameOverAlarmMin) then
        begin
          TeeBoxTitle.Hint := sHintVip + '�����' + _CRLF + Format('%d�� �̳� ����', [Global.GameOverAlarmMin]);
          TeeBoxTitle.Color := GCR_COLOR_SOON;
        end
        else
        begin
          TeeBoxTitle.Hint := sHintVip + '�����' + _CRLF + '5�� �̻� ���';
          TeeBoxTitle.Color := GCR_COLOR_WAIT;
        end;
        MemberLabel.Caption := MemberName;
        RemainMinLabel.Caption := Format('%d ��', [RemainMin]);
        EndTimeLabel.Caption := Format('%s', [EndTime]) + IIF(ReservedCount > 0, Format('(%d ��)', [ReservedCount]), '');
        if (ReservedCount > 0) then
          ReservedPanel.Caption := Format('%d ��', [ReservedCount]);
      end;

      CTS_TEEBOX_HOLD:
      begin
        MemberLabel.Caption := '�ӽÿ���';
        TeeBoxTitle.Hint := sHintVip + '�ӽÿ���';
        if Selected then
          TeeBoxTitle.Color := GCR_COLOR_HOLD_SELF
        else
          TeeBoxTitle.Color := GCR_COLOR_HOLD;
      end;

      CTS_TEEBOX_STOP_ALL:
      begin
        MemberLabel.Caption := '�� ȸ��';
        TeeBoxTitle.Hint := sHintVip + '�� ȸ��';
        TeeBoxTitle.Color := GCR_COLOR_ERROR;
        RemainMinLabel.Caption := Format('%d ��', [RemainMin]);
        EndTimeLabel.Caption := Format('%s', [EndTime]) + IIF(ReservedCount > 0, Format('(%d ��)', [ReservedCount]), '');
        if (ReservedCount > 0) then
          ReservedPanel.Caption := Format('%d ��', [ReservedCount]);
      end;

      CTS_TEEBOX_STOP:
      begin
        MemberLabel.Caption := '������';
        TeeBoxTitle.Hint := sHintVip + '������';
        TeeBoxTitle.Color := GCR_COLOR_ERROR;
      end;

      CTS_TEEBOX_ERROR:
      case ErrorCode of
        CTS_TEEBOXAD_STOP_BALL:
        begin
          MemberLabel.Caption := '���ɸ�';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_NO_BALL:
        begin
          MemberLabel.Caption := '������';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_NO_AUTO:
        begin
          MemberLabel.Caption := '��������';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_MOTOR:
        begin
          MemberLabel.Caption := '�����̻�';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_COM:
        begin
          MemberLabel.Caption := '����̻�';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_COM_ERROR:
        begin
          MemberLabel.Caption := '��źҷ�';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_CALL:
        begin
          MemberLabel.Caption := 'CALL';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
          ClientDM.DoAdminCall(FCurStatus, Format('%s Ÿ������ ������ ��û�Ͽ����ϴ�.', [TeeBoxTitle.Caption]), 'Ÿ����', sErrMsg);
        end;

        CTS_TEEBOXAD_ERROR_11:
        begin
          MemberLabel.Caption := '����#11';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_ERROR_12:
        begin
          MemberLabel.Caption := '����#12';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_ERROR_13:
        begin
          MemberLabel.Caption := '����#13';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_ERROR_14:
        begin
          MemberLabel.Caption := '����#14';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end;

        CTS_TEEBOXAD_ERROR_15:
        begin
          MemberLabel.Caption := '����#15';
          TeeBoxTitle.Color := GCR_COLOR_ERROR;
        end
      else
        MemberLabel.Caption := '������';
        TeeBoxTitle.Color := GCR_COLOR_ERROR;
      end
    else
      MemberLabel.Caption := '���Ұ�';
      TeeBoxTitle.Hint := sHintVip + '���Ұ�(' + IntToStr(FCurStatus) + ')';
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
    (FZoneCode = CTZ_SWING_ANALYZE) or
    (FZoneCode = CTZ_SWING_ANALYZE_2) or
    (FZoneCode = CTZ_TRACKMAN) or
    (FZoneCode = CTZ_GDR) or
    (FZoneCode = CTZ_INDOOR) or
    (FZoneCode = CTZ_SCREEN_INDOOR) or
    (FZoneCode = CTZ_SCREEN_OUTDOOR);

  if LRLabel.Visible then
    if (FZoneCode = CTZ_LEFT_RIGHT) then
    begin
      LRLabel.Caption := 'D';
      LRLabel.Hint := '�¿���';
    end
    else if (FZoneCode = CTZ_LEFT) then
    begin
      LRLabel.Caption := 'L';
      LRLabel.Hint := '��Ÿ';
    end
    else if (FZoneCode = CTZ_SWING_ANALYZE) or
            (FZoneCode = CTZ_SWING_ANALYZE_2) then
    begin
      LRLabel.Caption := 'A';
      LRLabel.Hint := '�����м�';
    end
    else if (FZoneCode = CTZ_TRACKMAN) then
    begin
      LRLabel.Caption := 'T';
      LRLabel.Hint := 'Ʈ����';
    end
    else if (FZoneCode = CTZ_GDR) then
    begin
      LRLabel.Caption := 'G';
      LRLabel.Hint := 'GDR';
    end
    else if (FZoneCode = CTZ_INDOOR) then
    begin
      LRLabel.Caption := 'I';
      LRLabel.Hint := '�ǳ�Ÿ��';
    end
    else if (FZoneCode = CTZ_VIP_COUPLE) then
    begin
      LRLabel.Caption := 'C';
      LRLabel.Hint := 'Ŀ��Ÿ��';
    end
    else if (FZoneCode = CTZ_SCREEN_INDOOR) then
    begin
      LRLabel.Caption := 'S';
      LRLabel.Hint := '��ũ��/�ǳ�';
    end
    else if (FZoneCode = CTZ_SCREEN_OUTDOOR) then
    begin
      LRLabel.Caption := 'S';
      LRLabel.Hint := '��ũ��/�߿�';
    end
    else
    begin
      LRLabel.Caption := '';
      LRLabel.Hint := '';
    end;
end;

procedure TTeeBoxPanel.SetFontSizeAdjust(const AValue: Integer);
var
  nSize: Integer;
begin
  nSize := (LCN_TEEBOX_FONT_SIZE + AValue);
  MemberLabel.Style.Font.Size := nSize;
  RemainMinLabel.Style.Font.Size := nSize;
  EndTimeLabel.Style.Font.Size := nSize;
  ReservedPanel.Font.Size := nSize;
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

  TeeBoxNoLabel := TLabel.Create(Self);
  with TeeBoxNoLabel do
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
  TeeBoxNoLabel.Caption := ATitle;
  RemainMinLabel.Caption := IntToStr(ARemainMin);
end;

procedure TQuickPanel.Clear;
begin
  TeeBoxNoLabel.Caption := '';
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

            if Global.AirConditioner.Enabled and
               (not Global.TeeBoxADInfo.Enabled) then
            begin
              with XGTeeBoxViewForm do
                if (not Global.AirConditioner.Active) then
                  btnAirConditioner.Enabled := (not btnAirConditioner.Enabled)
                else
                  btnAirConditioner.Enabled := True;
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
