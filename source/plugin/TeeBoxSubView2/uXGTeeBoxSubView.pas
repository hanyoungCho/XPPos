(*******************************************************************************

  Title       : 보조 모니터 출력 화면
  Filename    : uXGTeeBoxSubView.pas
  Author      : 이선우
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.1.0.0   2020-12-09   빠른 타석 표시 추가
    1.0.0.0   2016-10-25   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGTeeBoxSubView;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.Forms,
  Vcl.Controls, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Graphics, System.ImageList,
  Vcl.ImgList, Vcl.Imaging.pngimage,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics, dxBarBuiltInMenu, cxLookAndFeels, cxLookAndFeelPainters,
  cxPC, cxControls,
  { SolbiVCL}
  RoundPanel, LEDFontNum, ScrCam;

{$I ..\..\common\XGPOS.inc}

const
  LCN_QUICK_OF_FLOOR      = 5;
  LCN_TEEBOX_FONT_SIZE    = 12;

  LCN_IMG_TEEBOX_READY    = 3;
  LCN_IMG_TEEBOX_SOON     = 4;
  LCN_IMG_TEEBOX_ERROR    = 5;
  LCN_IMG_TEEBOX_WAIT     = 6;
  LCN_IMG_TEEBOX_HOLD     = 7;

  LCN_PREVIEW_WEBCAM      = 1;
  LCN_PREVIEW_FINGERPRINT = 2;

type
  TBlinkerThread = class(TThread)
  private
    FWorking: Boolean;
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

  TTopPosInfo = record
    BaseTop: Integer;
    FloorTitleTop: Integer;
  end;

  TTeeBoxPanel = class(TPanel)
    VipImage: TImage;
    ManualImage: TImage;
    LeftRightImage: TImage;
    BodyImage: TImage;
    CheckImage: TImage;
    TeeBoxNoLabel: TLabel;
    RemainMinLabel: TLabel;
    EndTimeLabel: TLabel;
    ReservedCountLabel: TLabel;
  private
    FTeeBoxNo: Integer;
    FDeviceId: string;
    FTeeBoxName: string;
    FFloorCode: string;
    FRemainMin: Integer;
    FEndTime: string;
    FReservedCount: Integer;
    FControlYN: Boolean; //Auto Tee-up 타석 여부: 자동(Y), 수동(N)
    FVipYN: Boolean;
    FUseYN: Boolean;
    FCurStatus: Integer;
    FOldStatus: Integer;
    FSelected: Boolean;
    FZoneCode: string;
    FBodyIndex: Integer;

    procedure SetTeeBoxName(const AValue: string);
    procedure SetEndTime(const AValue: string);
    procedure SetReservedCount(const AValue: Integer);
    procedure SetVipYN(const AValue: Boolean);
    procedure SetUseYN(const AValue: Boolean);
    procedure SetZoneCode(const AValue: string);
    procedure SetCurStatus(const AValue: Integer);
    procedure SetSelected(const AValue: Boolean);
    procedure SetRemainMin(const AValue: Integer);
    procedure SetControlYN(const AValue: Boolean);
    procedure SetBodyIndex(const AValue: Integer);
    procedure SetFontSizeAdjust(const AValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TeeBoxNo: Integer read FTeeBoxNo write FTeeBoxNo default 0;
    property DeviceId: string read FDeviceId write FDeviceId;
    property TeeBoxName: string read FTeeBoxName write SetTeeBoxName;
    property FloorCode: string read FFloorCode write FFloorCode;
    property RemainMin: Integer read FRemainMin write SetRemainMin default 0;
    property EndTime: string read FEndTime write SetEndTime;
    property ReservedCount: Integer read FReservedCount write SetReservedCount default 0;
    property ControlYN: Boolean read FControlYN write SetControlYN default False;
    property VipYN: Boolean read FVipYN write SetVipYN default False;
    property UseYN: Boolean read FUseYN write SetUseYN default False;
    property ZoneCode: string read FZoneCode write SetZoneCode;
    property CurStatus: Integer read FCurStatus write SetCurStatus default CTS_TEEBOX_NOTUSED;
    property OldStatus: Integer read FOldStatus write FOldStatus default CTS_TEEBOX_NOTUSED;
    property Selected: Boolean read FSelected write SetSelected default False;
    property BodyIndex: Integer read FBodyIndex write SetBodyIndex;
    property FontSizeAdjust: Integer write SetFontSizeAdjust;
  end;

  TQuickPanel = class(TRoundPanel)
  private
    TitleLabel: TLabel;
    TeeBoxPanel: array of TPanel;
    TeeBoxHeadLabel: array of TLabel;
    TeeBoxNameLabel: array of TLabel;
    RemainMinLabel: array of TLabel;

    procedure SetBackgroundColor(const AColor: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);

    property BackgroundColor: TColor write SetBackgroundColor;
  end;

  TQuickSidePanel = class(TPanel)
  private
    FBasePanel: array of TPanel;
    FBodyImage: array of TImage;
    FTeeBoxNameLabel: array of TLabel;
    FRemainMinLabel: array of TLabel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
  end;

  TXGTeeBoxSubViewForm = class(TPluginModule)
    panHeader: TPanel;
    imcTeeBoxRes: TcxImageCollection;
    imgTeeBoxReady: TcxImageCollectionItem;
    imgTeeBoxError: TcxImageCollectionItem;
    imgTeeBoxSoon: TcxImageCollectionItem;
    imgVip: TcxImageCollectionItem;
    imgQrCode: TcxImageCollectionItem;
    imgFingerPrint: TcxImageCollectionItem;
    imgCreditCard: TcxImageCollectionItem;
    imgTeeBoxWait: TcxImageCollectionItem;
    imgTeeBoxHold: TcxImageCollectionItem;
    imgChecked: TcxImageCollectionItem;
    imgLeftRight: TcxImageCollectionItem;
    imgFloorLegend: TcxImageCollectionItem;
    imgLeft: TcxImageCollectionItem;
    imgManual: TcxImageCollectionItem;
    pgcBody: TcxPageControl;
    tabScoreboard: TcxTabSheet;
    TemplateFloorTitleLabel: TLabel;
    TemplateFloorLegendImage: TImage;
    TemplateTeeBoxPanel: TPanel;
    TemplateBodyImage: TImage;
    TemplateVipImage: TImage;
    TemplateRemainMinLabel: TLabel;
    TemplateEndTimeLabel: TLabel;
    TemplateCheckImage: TImage;
    TemplateLeftRightImage: TImage;
    TemplateTeeBoxNoLabel: TLabel;
    TemplateReserveCountLabel: TLabel;
    TemplateManualImage: TImage;
    tabBlank: TcxTabSheet;
    panTeeBoxLegend: TPanel;
    lblStatusReady: TLabel;
    lblStatusSoon: TLabel;
    lblStatusReserved: TLabel;
    lblStatusError: TLabel;
    panScoreboard: TPanel;
    ledReadyCount: TLEDFontNum;
    Label8: TLabel;
    ledWaitingCount: TLEDFontNum;
    panHeaderInfo: TPanel;
    lblPluginVersion: TLabel;
    panDateTime: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    ledStoreEndTime: TLEDFontNum;
    tmrClock: TTimer;
    imgTrackMan: TcxImageCollectionItem;
    imgGDR: TcxImageCollectionItem;
    imgLogo: TImage;
    TemplateQuickPanel: TRoundPanel;
    TemplateQuickTeeBoxPanel: TPanel;
    TemplateQuickTeeBoxTitleLabel: TLabel;
    TemplateQuickTeeBoxNameLabel: TLabel;
    TemplateQuickTeeBoxRemainMinLabel: TLabel;
    TemplateQuickTitle: TLabel;
    imgIndoor: TcxImageCollectionItem;
    imgSwingAnal: TcxImageCollectionItem;
    panWeather: TPanel;
    imgWeather: TImage;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTemper: TLabel;
    lblPrecipit: TLabel;
    lblHumidity: TLabel;
    lblWindSpeed: TLabel;
    panQuickSideView: TPanel;
    Panel2: TPanel;
    TemplateQuickSidePanel: TPanel;
    TemplateTeeBoxSidePanel: TPanel;
    ScreenCam: TScreenCamera;
    panWebCamPreview: TPanel;
    imgWebCamPreview: TImage;
    imgWebCam: TImage;
    panFingerPrintPreview: TPanel;
    imgFingerPrintPreview: TImage;
    imgVipCouple: TcxImageCollectionItem;
    TemplateTeeBoxPanel2: TPanel;
    TemplateTeeBoxNoPanel2: TPanel;
    TemplateEndTimeLabel2: TLabel;
    TemplateReserveCountLabel2: TLabel;
    TemplateTeeBoxKindPanel2: TPanel;
    TemplateRemainMinLabel2: TLabel;

    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrClockTimer(Sender: TObject);
    procedure OnPageControlChange(Sender: TObject);
    procedure OnScreenCamPreview(Sender: TObject; APreviewBitmap: TBitmap; const APreview, ARecording: Boolean);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBlinkerThread: TBlinkerThread;
    FQuickPanels: array of TQuickPanel;
    FQuickSidePanels: array of TQuickSidePanel;
    FFloorTitles: array of TLabel;
    FFloorLegends: array of TImage;
    FFloorCount: Integer;
    FTimeBlink: Boolean;
    FPlayList: TStrings;
    FPlayIndex: Integer;
    FPlayInterval: Integer;
    FIsReady: Boolean;
    FIsFirst: Boolean;
    FPreviewMode: Integer;
    FIsTeeBox: Boolean;
    FForceClosing: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ChangeBackgroundColor(const AColor: TColor);
    procedure RefreshTeeBoxLayout;
    procedure RefreshTeeBoxStatus;
    procedure ShowScreenCamPreview(const AEnabled: Boolean; const ATop, ALeft, AHeight, AWidth: Integer);
    function IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
  protected
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property PreviewMode: Integer read FPreviewMode write FPreviewMode default LCN_PREVIEW_WEBCAM;
  end;
var
  FTeeBoxPanels: array of TTeeBoxPanel;
  FImageCollection: TcxImageCollection;
  FTeeBoxCount: Integer;
  FBaseWidth: Integer;

implementation

uses
  { Native }
  System.Math, System.DateUtils,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager;

{$R *.dfm}

{ TTeeBoxSubViewForm }

procedure TXGTeeBoxSubViewForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 0;
end;

constructor TXGTeeBoxSubViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I, nRow, nCol, nStart, nEnd, nTop, nColCnt, nBaseLeft, nPanelWidth, nPanelHeight,
  nPanelGap, nTopGap, nArcGap, nInterval: Integer;
  sPlayList: string;
  aTopPos: array of TTopPosInfo;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FIsFirst := True;
  FIsReady := False;
  FPlayList := TStringList.Create;
  sPlayList := Global.ContentsDir + 'playlist.txt';
  if FileExists(sPlayList) then
    FPlayList.LoadFromFile(sPlayList);
  FPlayIndex := FPlayList.Count;
  FPlayInterval := 0;

  Self.Height := Global.SubMonitor.Height;
  Self.Width := Global.SubMonitor.Width;

  FImageCollection := TcxImageCollection.Create(Self);
  FImageCollection.Items := imcTeeBoxRes.Items;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := '';
  lblClockWeekday.Caption := '';
  lblClockHours.Caption := '';
  lblClockMins.Caption := '';
  lblClockSepa.Caption := '';
  lblStatusSoon.Caption := Format('%d분이내', [Global.GameOverAlarmMin]);
  ledStoreEndTime.Text := IIF(SaleManager.StoreInfo.StoreEndTime.IsEmpty, '--:--', SaleManager.StoreInfo.StoreEndTime);
  MakeRoundedControl(panTeeBoxLegend, 10, 10);

  with pgcBody do
  begin
    for I := 0 to Pred(PageCount) do
    begin
      Pages[I].TabVisible := False;
      if (I = 0) then
        Pages[I].Color := Global.SubMonitor.BackgroundColor;
    end;
    ActivePageIndex := 0;
    OnChange := OnPageControlChange;
  end;

  MakeRoundedControl(panWeather);
  panWeather.Visible := False;

  panWebCamPreview.Top := (Self.Height div 2) - (panWebCamPreview.Height div 2);
  panWebCamPreview.Left := (Self.Width div 2) - (panWebCamPreview.Width div 2);
  MakeRoundedControl(panWebCamPreview);
  panWebCamPreview.Visible := False;

  panFingerPrintPreview.Top := (Self.Height div 2) - (panFingerPrintPreview.Height div 2);
  panFingerPrintPreview.Left := (Self.Width div 2) - (panFingerPrintPreview.Width div 2);
  MakeRoundedControl(panFingerPrintPreview, 40, 40);
  panFingerPrintPreview.Visible := False;

  ScreenCam.ShowPreview := False;
  ScreenCam.ScreenArea.ScreenRegion := TScreenRegion.FixedStable;
  ScreenCam.CurrentMonitor := 1;
  ScreenCam.RecordCursor := False;
  ScreenCam.DrawAreaCapture := False;
  ScreenCam.LineRectClear := False;

  panTeeBoxLegend.Top := (panHeader.Height div 2) - (panTeeBoxLegend.Height div 2);
  panTeeBoxLegend.Left := (panHeader.Width div 2) - (panTeeBoxLegend.Width div 2);
  panQuickSideView.Visible := Global.TeeBoxQuickView and (Global.TeeBoxQuickViewMode = CQM_VERTICAL);

  //프런트POS, 레슨룸(파스텔스튜디오)이 아니면 사용 불가
  FIsTeeBox := (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]);
  if FIsTeeBox then
  begin
    FBaseWidth := tabScoreboard.Width - IIF(panQuickSideView.Visible, panQuickSideView.Width, 0);
    FTeeBoxCount := 0;
    FFloorCount := Length(Global.TeeBoxFloorInfo);
    SetLength(aTopPos, FFloorCount);
    SetLength(FQuickPanels, FFloorCount);
    SetLength(FQuickSidePanels, FFloorCount);
    SetLength(FFloorTitles, FFloorCount);
    SetLength(FFloorLegends, FFloorCount);
    nPanelHeight := 224;
    nPanelGap := 3;
    nPanelWidth := (FBaseWidth - 210) div Global.TeeBoxMaxCountOfFloors;
    nTopGap := (Self.Height - panHeader.Height) div FFloorCount;
    nTop := (Self.Height - nTopGap - panHeader.Height) + 5;
    nInterval := nPanelWidth + nPanelGap;
    nStart := 0;

    for nRow := 0 to Pred(FFloorCount) do
    begin
      FTeeBoxCount := FTeeBoxCount + Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
      aTopPos[nRow].BaseTop := (nTop - (nTopGap * nRow));

      FFloorTitles[nRow] := TLabel.Create(Self);
      with FFloorTitles[nRow] do
      begin
        Parent := tabScoreboard;
        AutoSize := True;
        Caption := Global.TeeBoxFloorInfo[nRow].FloorName;
        Font.Name := 'Noto Sans CJK KR Bold';
        Font.Color := InvertColor2(Global.SubMonitor.BackgroundColor); //$00689F0E;
        Font.Size := 28;
        Font.Style := [fsBold];
        Left := (FBaseWidth div 2) - (((nPanelWidth * Global.TeeBoxFloorInfo[nRow].TeeBoxCount) + (nPanelGap * Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount))) div 2) - 35;
        Transparent := True;
        Visible := False;
      end;

      FFloorLegends[nRow] := TImage.Create(Self);
      with FFloorLegends[nRow] do
      begin
        Parent := tabScoreboard;
        AutoSize := True;
        Picture.Assign(imgFloorLegend.Picture);
        Top := (nTop - (nTopGap * nRow)) + 44;
        Left := (FBaseWidth div 2) -
          (((nPanelWidth * Global.TeeBoxFloorInfo[nRow].TeeBoxCount) +
            (nPanelGap * Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount))) div 2) - 43;
      end;

      FQuickPanels[nRow] := TQuickPanel.Create(Self);
      with FQuickPanels[nRow] do
      begin
        Parent := tabScoreboard;
        AutoSize := True;
        Top := (nTop - (nTopGap * nRow)) + 230;
        Left := ((FBaseWidth div 2) - (Width div 2));
        Visible := Global.TeeBoxQuickView and (Global.TeeBoxQuickViewMode = CQM_HORIZONTAL);
      end;

      FQuickSidePanels[nRow] := TQuickSidePanel.Create(Self);
      with FQuickSidePanels[nRow] do
      begin
        Parent := panQuickSideView;
        Top := (nTop - (nTopGap * nRow)) + 44 + 5;
        Left := 10;
        Visible := Global.TeeBoxQuickView and (Global.TeeBoxQuickViewMode = CQM_VERTICAL);
      end;
    end;

    //타석별 객체 생성
    SetLength(FTeeBoxPanels, FTeeBoxCount);
    LockWindowUpdate(tabScoreboard.Handle);
    try
      for nRow := 0 to Pred(FFloorCount) do
      begin
        nEnd := Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount) + nStart;
        nColCnt := Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
        nBaseLeft := (FBaseWidth div 2) - (((nPanelWidth * nColCnt) + (nPanelGap * Pred(nColCnt))) div 2) + 37;
        nArcGap := (Global.TeeBoxFloorInfo[nRow].TeeBoxCount * 2) div 10;
        nTop := aTopPos[nRow].BaseTop;
        nCol := 0;

        for I := nStart to nEnd do
        begin
          FTeeBoxPanels[I] := TTeeBoxPanel.Create(Self);
          with FTeeBoxPanels[I] do
          begin
            Tag := I;
            Parent := tabScoreboard;
            BevelOuter := bvNone;
            Color := Global.SubMonitor.BackgroundColor; //GCR_COLOR_BACK_PANEL;
            Height := nPanelHeight;
            Width := nPanelWidth;

            if Global.TeeBoxQuickView and (Global.TeeBoxQuickViewMode = CQM_HORIZONTAL) then
              Top := nTop
            else
            begin
              Top := nTop + (nColCnt * nCol div nArcGap);
              Dec(nColCnt);
            end;

            Left := (nBaseLeft + (nInterval * nCol));
            TeeBoxNoLabel.Caption := '';
            VipImage.Picture.Assign(imgVip.Picture);
            ManualImage.Picture.Assign(imgManual.Picture);
            BodyIndex := 3;
            CheckImage.Picture.Assign(imgChecked.Picture);
          end;

          Inc(nCol);
        end;

        FFloorTitles[nRow].Top := FFloorLegends[nRow].Top - FFloorTitles[nRow].Height;
        FFloorTitles[nRow].Visible := True;
        Inc(nStart, Global.TeeBoxFloorInfo[nRow].TeeBoxCount);
      end;
    finally
      LockWindowUpdate(0);
    end;

    if Assigned(AMsg) then
      ProcessMessages(AMsg);

    tmrClock.Interval := 100;
    tmrClock.Enabled := True;
  end;
end;

destructor TXGTeeBoxSubViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxSubViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FBlinkerThread) then
    FBlinkerThread.Terminate;
  FreeAndNil(FPlayList);
  ScreenCam.Free;
  Action := caFree;
end;

procedure TXGTeeBoxSubViewForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing or FForceClosing;
end;

procedure TXGTeeBoxSubViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxSubViewForm.ProcessMessages(AMsg: TPluginMessage);
var
  nValue, nIndex, nFloor, nTop, nLeft, nHeight, nWidth: Integer;
  bShow: Boolean;
begin
  if not FIsReady then
    Exit;

  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_TEEBOX_LAYOUT) then
    RefreshTeeBoxLayout;

  if (AMsg.Command = CPC_TEEBOX_STATUS) then
    if (Global.TeeBoxViewId = 0) then
      RefreshTeeBoxStatus;

  if (AMsg.Command = CPC_TEEBOX_SCOREBOARD) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    if (nIndex in [0..Pred(FTeeBoxCount)]) then
      with FTeeBoxPanels[nIndex] do
      begin
        RemainMin := AMsg.ParamByInteger(CPP_REMAIN_MIN);
        EndTime := AMsg.ParamByString(CPP_TEEBOX_ENDTIME);
        ReservedCount := AMsg.ParamByInteger(CPP_WAITING_COUNT);
        CurStatus := AMsg.ParamByInteger(CPP_TEEBOX_STATUS);
      end;
  end;

  if (AMsg.Command = CPC_QUICK_SCOREBOARD) and
     Global.TeeBoxQuickView then
  begin
    nFloor := AMsg.ParamByInteger(CPP_FLOOR_INDEX);
    if (nFloor in [0..Pred(FFloorCount)]) then
    begin
      nIndex := AMsg.ParamByInteger(CPP_QUICK_INDEX);
      if (nIndex < LCN_QUICK_OF_FLOOR) then
        case Global.TeeBoxQuickViewMode of
          CQM_HORIZONTAL:
            FQuickPanels[nFloor].SetQuickInfo(nIndex, AMsg.ParamByString(CPP_TEEBOX_NAME), AMsg.ParamByInteger(CPP_REMAIN_MIN));
          CQM_VERTICAL:
            FQuickSidePanels[nFloor].SetQuickInfo(nIndex, AMsg.ParamByString(CPP_TEEBOX_NAME), AMsg.ParamByInteger(CPP_REMAIN_MIN));
        end;
    end;
  end;

  if (AMsg.Command = CPC_TEEBOX_SELECT) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    if (nIndex in [0..Pred(FTeeBoxCount)]) then
      FTeeBoxPanels[nIndex].Selected := AMsg.ParamByBoolean(CPP_TEEBOX_SELECTED);
  end;

  if (AMsg.Command = CPC_TEEBOX_HOLD) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_HOLD;
  end;

  if (AMsg.Command = CPC_TEEBOX_HOLD_CANCEL) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;
  end;

  if (AMsg.Command = CPC_TEEBOX_READY_ALL) then
    for nIndex := 0 to Pred(FTeeBoxCount) do
      FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;

  if (AMsg.Command = CPC_TEEBOX_STOP_ALL) then
    for nIndex := 0 to Pred(FTeeBoxCount) do
      FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_STOP_ALL;

  if (AMsg.Command = CPC_TEEBOX_READY) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;
  end;

  if (AMsg.Command = CPC_TEEBOX_STOP) then
  begin
    nIndex := AMsg.ParamByInteger(CPP_TEEBOX_INDEX);
    FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_STOP;
  end;

  if (AMsg.Command = CPC_TEEBOX_COUNTER) then
  begin
    ledReadyCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_READY_COUNT));
    ledWaitingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_WAITING_COUNT));
    ledStoreEndTime.Text := IIF(SaleManager.StoreInfo.StoreEndTime.IsEmpty, '--:--', SaleManager.StoreInfo.StoreEndTime);
  end;

  if (AMsg.Command = CPC_APPLY_CONFIG) then
  begin
    nValue := AMsg.ParamByInteger(CPP_FONT_SIZE_ADJUST);
    for nIndex := 0 to Pred(FTeeBoxCount) do
      FTeeBoxPanels[nIndex].FontSizeAdjust := nValue;

    ChangeBackgroundColor(TColor(AMsg.ParamByInt64(CPP_BACK_COLOR)));
  end;

  if (AMsg.Command = CPC_WEATHER_REFRESH) then
  begin
    panWeather.Visible := Global.WeatherInfo.Enabled;
    if Global.WeatherInfo.Enabled then
    begin
//      ClientDM.imlWeather.GetBitmap(Global.WeatherInfo.IconIndex, imgWeather.Picture.Bitmap);
      imgWeather.Picture.Assign(ClientDM.imcWeather.Items[Global.WeatherInfo.IconIndex].Picture);
      imgWeather.Hint := Global.WeatherInfo.Condition;
      lblTemper.Caption := Global.WeatherInfo.Temper + '℃';
      lblPrecipit.Caption := Global.WeatherInfo.Precipit + '％';
      lblHumidity.Caption := Global.WeatherInfo.Humidity + '％';
      lblWindSpeed.Caption := Global.WeatherInfo.WindSpeed + '㎧';
    end;
  end;

  if (AMsg.Command = CPC_WEBCAM_PREVIEW) then
  begin
    bShow := AMsg.ParamByBoolean(CPP_ACTIVE);
    nTop := AMsg.ParamByInteger(CPP_RECT_TOP);
    nLeft := AMsg.ParamByInteger(CPP_RECT_LEFT);
    nHeight := AMsg.ParamByInteger(CPP_RECT_HEIGHT);
    nWidth := AMsg.ParamByInteger(CPP_RECT_WIDTH);
    Self.PreviewMode := LCN_PREVIEW_WEBCAM;
    ShowScreenCamPreview(bShow, nTop, nLeft, nHeight, nWidth);
  end;

  if (AMsg.Command = CPC_FINGERPRINT_PREVIEW) then
  begin
    bShow := AMsg.ParamByBoolean(CPP_ACTIVE);
    nTop := AMsg.ParamByInteger(CPP_RECT_TOP);
    nLeft := AMsg.ParamByInteger(CPP_RECT_LEFT);
    nHeight := AMsg.ParamByInteger(CPP_RECT_HEIGHT);
    nWidth := AMsg.ParamByInteger(CPP_RECT_WIDTH);
    Self.PreviewMode := LCN_PREVIEW_FINGERPRINT;
    ShowScreenCamPreview(bShow, nTop, nLeft, nHeight, nWidth);
  end;

  (*
  if (AMsg.Command = CPC_PRIVACY_AGREEMENT) then
    if AMsg.ParamByBoolean(CPP_ACTIVE) then
      pgcBody.ActivePage := tabPrivacyAgreement
    else
      pgcBody.ActivePage := tabScoreboard;
  *)
end;

procedure TXGTeeBoxSubViewForm.ShowScreenCamPreview(const AEnabled: Boolean; const ATop, ALeft, AHeight, AWidth: Integer);
begin
  if AEnabled then
  begin
    ScreenCam.ShowPreview := False;
    ScreenCam.ScreenArea.ScreenTop := ATop;
    ScreenCam.ScreenArea.ScreenLeft := ALeft;
    ScreenCam.ScreenArea.ScreenHeight := AHeight;
    ScreenCam.ScreenArea.ScreenWidth := AWidth;
  end;
  pgcBody.ActivePageIndex := IIF(AEnabled, 1, 0);
  if (Self.PreviewMode = LCN_PREVIEW_WEBCAM) then
    panWebCamPreview.Visible := AEnabled
  else
    panFingerPrintPreview.Visible := AEnabled;
  ScreenCam.ShowPreview := AEnabled;
end;

procedure TXGTeeBoxSubViewForm.PluginModuleShow(Sender: TObject);
begin
  if not FIsTeeBox then
  begin
    FForceClosing := True;
    Self.Close;
    Exit;
  end;

  Self.Top  := Global.SubMonitor.Top;
  Self.Left := Global.SubMonitor.Left;
end;

procedure TXGTeeBoxSubViewForm.ChangeBackgroundColor(const AColor: TColor);
var
  I: Integer;
begin
  with pgcBody do
    for I := 0 to Pred(PageCount) do
        Pages[I].Color := AColor;

  for I := 0 to Pred(FTeeBoxCount) do
    FTeeBoxPanels[I].Color := AColor;

  for I := 0 to Pred(FFloorCount) do
  begin
    FFloorTitles[I].Color := AColor;
    FFloorTitles[I].Font.Color := InvertColor2(AColor);
    FQuickPanels[I].BackgroundColor := AColor;
//    FQuickPanels[I].Pen.Color := InvertColor2(AColor);
  end;
end;

procedure TXGTeeBoxSubViewForm.RefreshTeeBoxLayout;
var
  nIndex: Integer;
  sZoneCode: string;
begin
  with ClientDM.MDTeeBox do
  try
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
          FTeeBoxPanels[nIndex].DeviceId   := FieldByName('device_id').AsString;
          FTeeBoxPanels[nIndex].VipYN      := FieldByName('vip_yn').AsBoolean;
          FTeeBoxPanels[nIndex].UseYN      := FieldByName('use_yn').AsBoolean;
          FTeeBoxPanels[nIndex].ControlYN  := (FieldByName('control_yn').AsString = CRC_YES);

          sZoneCode := FieldByName('zone_cd').AsString;
          FTeeBoxPanels[nIndex].ZoneCode := sZoneCode;
          if (sZoneCode = CTZ_LEFT) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgLeft.Picture)
          else if (sZoneCode = CTZ_LEFT_RIGHT) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgLeftRight.Picture)
          else if (sZoneCode = CTZ_SWING_ANALYZE) or
                  (sZoneCode = CTZ_SWING_ANALYZE_2) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgSwingAnal.Picture)
          else if (sZoneCode = CTZ_TRACKMAN) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgTrackMan.Picture)
          else if (sZoneCode = CTZ_GDR) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgGDR.Picture)
          else if (sZoneCode = CTZ_INDOOR) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgIndoor.Picture)
          else if (sZoneCode = CTZ_VIP_COUPLE) then
            FTeeBoxPanels[nIndex].LeftRightImage.Picture.Assign(imgVipCouple.Picture);

          if (Length(FTeeBoxPanels[nIndex].TeeBoxName) > 2) then
            FTeeBoxPanels[nIndex].TeeBoxNoLabel.Font.Size := 20;
        end;

        Inc(nIndex);
        Next;
      end;
    finally
      EnableControls;
    end;
  except
  end;
end;

procedure TXGTeeBoxSubViewForm.RefreshTeeBoxStatus;
var
  nIndex: Integer;
begin
  with ClientDM.MDTeeBoxStatus3 do
  try
    if not Active then
      Open;

    CopyFromDataSet(ClientDM.MDTeeBoxStatus);
    First;
    while not Eof do
    begin
      nIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
      if (nIndex in [0..Pred(FTeeBoxCount)]) then
        with FTeeBoxPanels[nIndex] do
        begin
          RemainMin := FieldByName('remain_min').AsInteger;
          EndTime := '';
          ReservedCount := FieldByName('reserved_count').AsInteger;
          CurStatus := FieldByName('use_status').AsInteger;
          if (RemainMin > 0) then
            EndTime := Copy(FieldByName('end_datetime').AsString, 12, 5);
        end;

      Next;
    end;
  finally
    Close;
  end;
end;

procedure TXGTeeBoxSubViewForm.OnScreenCamPreview(Sender: TObject; APreviewBitmap: TBitmap; const APreview, ARecording: Boolean);
begin
  if Assigned(APreviewBitmap) then
  begin
    if (PreviewMode = LCN_PREVIEW_WEBCAM) then
      imgWebCamPreview.Picture.Assign(APreviewBitmap)
    else
      imgFingerPrintPreview.Picture.Assign(APreviewBitmap);
  end
  else
  begin
    if (PreviewMode = LCN_PREVIEW_WEBCAM) then
      imgWebCamPreview.Picture.Bitmap := nil
    else
      imgFingerPrintPreview.Picture.Bitmap := nil;
  end;
end;

procedure TXGTeeBoxSubViewForm.tmrClockTimer(Sender: TObject);
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
      RefreshTeeBoxLayout;

      if not Assigned(FBlinkerThread) then
      begin
        FBlinkerThread := TBlinkerThread.Create;
        FBlinkerThread.FreeOnTerminate := True;
        if not FBlinkerThread.Started then
          FBlinkerThread.Start;
      end;

      FIsReady := True;
    end;
  finally
    Enabled := True and (not Global.Closing);
  end;
end;

function TXGTeeBoxSubViewForm.IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
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

procedure TXGTeeBoxSubViewForm.OnPageControlChange(Sender: TObject);
begin
  case TcxPageControl(Sender).ActivePageIndex of
    0: //타석 가동 상황
    begin
      panTeeBoxLegend.Visible := True;
      panHeader.Caption := '';
    end;

    1: //웹캠, 지문인식 화면 미러링
    begin
      panTeeBoxLegend.Visible := False;
      if (Self.PreviewMode = LCN_PREVIEW_WEBCAM) then
        panHeader.Caption := '회원 사진 등록 - 카메라를 정면으로 주시하여 주세요.'
      else
        panHeader.Caption := '지문인식기에 사용할 손가락을 올려 주세요.';
    end;
  end;
end;

{ TTeeBoxPanel }

constructor TTeeBoxPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Parent := TWinControl(AOwner);
  DoubleBuffered := True;
  AutoSize := False;

  VipImage := TImage.Create(Self);
  with VipImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Height := 44;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
    Top := 0;
    Left := 0;
    Visible := False;
    Stretch := True;
  end;

  ManualImage := TImage.Create(Self);
  with ManualImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Height := 44;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
    Top := 0;
    Left := 0;
    Visible := False;
    Stretch := True;
  end;

  LeftRightImage := TImage.Create(Self);
  with LeftRightImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Height := 44;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
    Top := 0;
    Left := 0;
    Visible := False;
    Stretch := True;
  end;

  BodyImage := TImage.Create(Self);
  with BodyImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Height := 176;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
    Top := 48;
    Left := 0;
    Stretch := True;
  end;

  TeeBoxNoLabel := TLabel.Create(Self);
  with TeeBoxNoLabel do
  begin
    Parent := Self;
    Top := 48;
    Left := 0;
    Alignment := taCenter;
    AutoSize := False;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 24;
    Font.Color := GCR_COLOR_BACK_LABEL;
    Font.Style := [fsBold];
    Height := 48;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
    Transparent := True;
  end;

  EndTimeLabel := TLabel.Create(Self);
  with EndTimeLabel do
  begin
    Parent := Self;
    Top := 105;
    Left := 0;
    Alignment := taCenter;
    AutoSize := False;
    Color := GCR_COLOR_BACK_LABEL;
    Transparent := False;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Font.Color := clGray;
    Font.Style := [fsBold];
    Height := 25;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
  end;

  RemainMinLabel := TLabel.Create(Self);
  with RemainMinLabel do
  begin
    Parent := Self;
    Top := 135;
    Left := 0;
    Alignment := taCenter;
    AutoSize := False;
    Color := GCR_COLOR_BACK_LABEL;
    Transparent := False;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Font.Color := GCR_COLOR_PLAY;
    Font.Style := [fsBold];
    Height := 50;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
  end;

  ReservedCountLabel := TLabel.Create(Self);
  with ReservedCountLabel do
  begin
    Parent := Self;
    Top := 190;
    Left := 0;
    Alignment := taCenter;
    AutoSize := False;
    Color := GCR_COLOR_BACK_LABEL;
    Transparent := False;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    Font.Color := clGray;
    Font.Style := [fsBold];
    Height := 25;
    Width := (FBaseWidth - 200) div Global.TeeBoxMaxCountOfFloors;
  end;

  CheckImage := TImage.Create(Self);
  with CheckImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Center := True;
    Height := 48;
    Width := 48;
    Top := 170;
    Left := 9;
    Visible := False;
  end;
end;

destructor TTeeBoxPanel.Destroy;
begin
  VipImage.Free;
  LeftRightImage.Free;
  BodyImage.Free;
  CheckImage.Free;
  ManualImage.Free;
  TeeBoxNoLabel.Free;
  RemainMinLabel.Free;
  EndTimeLabel.Free;

  inherited;
end;

procedure TTeeBoxPanel.SetSelected(const AValue: Boolean);
begin
  if (FSelected <> AValue) then
  begin
    FSelected := AValue;
    CheckImage.Visible := AValue;
  end;
end;

procedure TTeeBoxPanel.SetEndTime(const AValue: string);
begin
  if (FEndTime <> AValue) then
  begin
    FEndTime := AValue;
    EndTimeLabel.Caption := AValue;
  end;
end;

procedure TTeeBoxPanel.SetRemainMin(const AValue: Integer);
begin
  if (FRemainMin <> AValue) then
  begin
    FRemainMin := AValue;
    if CurStatus in [CTS_TEEBOX_RESERVED, CTS_TEEBOX_USE] then
      if (FRemainMin <= Global.GameOverAlarmMin) then
        BodyIndex := LCN_IMG_TEEBOX_SOON
      else
        BodyIndex := LCN_IMG_TEEBOX_WAIT;
  end;
end;

procedure TTeeBoxPanel.SetReservedCount(const AValue: Integer);
begin
  if (FReservedCount <> AValue) then
  begin
    FReservedCount := AValue;
    ReservedCountLabel.Caption := IIF(AValue = 0, '', IntToStr(AValue) + '명');
  end;
end;

procedure TTeeBoxPanel.SetTeeBoxName(const AValue: string);
begin
  if (FTeeBoxName <> AValue) then
  begin
    FTeeBoxName := AValue;
    TeeBoxNoLabel.Caption := AValue;
  end;
end;

procedure TTeeBoxPanel.SetBodyIndex(const AValue: Integer);
begin
  if (FBodyIndex <> AValue) then
  begin
    FBodyIndex := AValue;
    BodyImage.Picture.Assign(FImageCollection.Items[FBodyIndex].Picture);
  end;
end;

procedure TTeeBoxPanel.SetControlYN(const AValue: Boolean);
begin
  if (FControlYN <> AValue) then
  begin
    FControlYN := AValue;
    ManualImage.Visible := (not FControlYN);
  end;
end;

procedure TTeeBoxPanel.SetCurStatus(const AValue: Integer);
var
  bIsNewStatus: Boolean;
begin
  bIsNewStatus := (FCurStatus <> AValue);
  if bIsNewStatus then
    FOldStatus := CurStatus;
  FCurStatus := AValue;

  if not UseYN then
    Exit;

  if bIsNewStatus then
  begin
    case FCurStatus of
      CTS_TEEBOX_READY:
        begin
          BodyIndex := LCN_IMG_TEEBOX_READY;
          RemainMinLabel.Font.Color := GCR_COLOR_PLAY;
        end;
      CTS_TEEBOX_RESERVED,
      CTS_TEEBOX_USE:
        begin
          RemainMinLabel.Font.Size := 22; //20;
          if (FRemainMin <= Global.GameOverAlarmMin) then
            BodyIndex := LCN_IMG_TEEBOX_SOON
          else
            BodyIndex := LCN_IMG_TEEBOX_WAIT;
        end;
      CTS_TEEBOX_HOLD:
        begin
          BodyIndex := LCN_IMG_TEEBOX_HOLD;
          RemainMinLabel.Caption := '임시' + _CRLF + '예약';
          RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
          RemainMinLabel.Font.Color := GCR_COLOR_HOLD;
        end;
      CTS_TEEBOX_STOP_ALL:
        begin
          BodyIndex := LCN_IMG_TEEBOX_ERROR;
          RemainMinLabel.Font.Size := 22; //20;
          EndTimeLabel.Caption := '볼회수';
          RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
        end;
      CTS_TEEBOX_STOP:
        begin
          BodyIndex := LCN_IMG_TEEBOX_ERROR;
          RemainMinLabel.Caption := '점검중';
          RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
          RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
        end;
      CTS_TEEBOX_ERROR:
        if Global.SubMonitor.ShowErrorStatus then
        begin
          BodyIndex := LCN_IMG_TEEBOX_ERROR;
          RemainMinLabel.Caption := '기기' + _CRLF + '고장';
          RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
          RemainMinLabel.Font.Color := GCR_COLOR_SOON;
        end;
    end;
  end;

  case FCurStatus of
    CTS_TEEBOX_READY:
      begin
        RemainMinLabel.Caption := '';
        EndTimeLabel.Caption := '';
      end;
    CTS_TEEBOX_RESERVED,
    CTS_TEEBOX_USE:
      begin
        RemainMinLabel.Caption := Format('%d', [RemainMin]);
        EndTimeLabel.Caption := Format('%s', [EndTime]);
        if (RemainMin <= Global.GameOverAlarmMin) then
        begin
          RemainMinLabel.Font.Color := GCR_COLOR_SOON;
        end else
        begin
          RemainMinLabel.Font.Color := GCR_COLOR_PLAY;
        end;
      end;
    CTS_TEEBOX_HOLD:
      EndTimeLabel.Caption := '';
    CTS_TEEBOX_STOP_ALL:
      RemainMinLabel.Caption := Format('%d', [RemainMin]);
    CTS_TEEBOX_STOP:
      EndTimeLabel.Caption := '';
    CTS_TEEBOX_ERROR:
      if Global.SubMonitor.ShowErrorStatus then
        EndTimeLabel.Caption := '';
  end;
end;

procedure TTeeBoxPanel.SetUseYN(const AValue: Boolean);
begin
  FUseYN := AValue;
  if not FUseYN then
  begin
    RemainMin := 0;
    EndTime := '';
    BodyIndex := LCN_IMG_TEEBOX_ERROR;
    RemainMinLabel.Caption := '사용' + _CRLF + '불가';
    RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
  end;
end;

procedure TTeeBoxPanel.SetVipYN(const AValue: Boolean);
begin
  if (FVipYN <> AValue) then
  begin
    FVipYN := AValue;
    VipImage.Visible := FVipYN;
  end;
end;

procedure TTeeBoxPanel.SetZoneCode(const AValue: string);
begin
  if (FZoneCode <> AValue) then
  begin
    FZoneCode := AValue;
    LeftRightImage.Visible :=
      (FZoneCode = CTZ_LEFT_RIGHT) or
      (FZoneCode = CTZ_LEFT) or
      (FZoneCode = CTZ_SWING_ANALYZE) or
      (FZoneCode = CTZ_SWING_ANALYZE_2) or
      (FZoneCode = CTZ_TRACKMAN) or
      (FZoneCode = CTZ_GDR) or
      (FZoneCode = CTZ_INDOOR) or
      (FZoneCode = CTZ_VIP_COUPLE);
  end;
end;

procedure TTeeBoxPanel.SetFontSizeAdjust(const AValue: Integer);
var
  nSize: Integer;
begin
  nSize := (LCN_TEEBOX_FONT_SIZE + AValue);
  RemainMinLabel.Font.Size := nSize;
  EndTimeLabel.Font.Size := nSize;
  ReservedCountLabel.Font.Size := nSize;
end;

{ TQuickPanel }

constructor TQuickPanel.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  with TRoundPanel(Self) do
  begin
    Parent := TWinControl(AOwner);
    Arc := 15;
    Height := 80;
    Width := 820;
    AutoSize := True;
    BackgroundColor := Global.SubMonitor.BackgroundColor;
    Brush.Color := Global.SubMonitor.BackgroundColor;
    ParentColor := True;
    Pen.Color := clWhite; //InvertColor2(Global.SubMonitor.BackgroundColor);
  end;

  TitleLabel := TLabel.Create(Self);
  with TitleLabel do
  begin
    Parent := Self;
    Transparent := False;
    Color := Global.SubMonitor.BackgroundColor; //$00F4F9EA;
    Align := TAlign.alLeft;
    Alignment := taCenter;
    AlignWithMargins := True;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 20;
    Font.Style := [fsBold];
    Font.Color := InvertColor2(Global.SubMonitor.BackgroundColor); //$00404040;
    Caption := '빠른타석';
    Width := 130;
  end;

  SetLength(TeeBoxPanel, LCN_QUICK_OF_FLOOR);
  SetLength(TeeBoxHeadLabel, LCN_QUICK_OF_FLOOR);
  SetLength(TeeBoxNameLabel, LCN_QUICK_OF_FLOOR);
  SetLength(RemainMinLabel, LCN_QUICK_OF_FLOOR);
  for I := 0 to Pred(LCN_QUICK_OF_FLOOR) do
  begin
    TeeBoxPanel[I] := TPanel.Create(Self);
    with TPanel(TeeBoxPanel[I]) do
    begin
      DoubleBuffered := True;
      Width := 132;
      AutoSize := False;
      Align := TAlign.alLeft;
      AlignWithMargins := True;
      Caption := '';
      Color := Global.SubMonitor.BackgroundColor;
      ParentBackground := False;
      ParentColor := False;
      Margins.Top := 5;
      Margins.Left := 0;
      Margins.Right := 5;
      Margins.Bottom := 5;
      BevelOuter := TBevelCut.bvNone;
      Parent := Self;
    end;

    TeeBoxHeadLabel[I] := TLabel.Create(Self);
    with TLabel(TeeBoxHeadLabel[I]) do
    begin
      DoubleBuffered := True;
      Height := 24;
      AutoSize := False;
      Align := TAlign.alTop;
      Alignment := TAlignment.taCenter;
      Caption := '타석 / 남은시간';
      Color := $00544ED6; //$00FF8000;
      Font.Name := 'Noto Sans CJK KR Regular';
      Font.Size := 11;
      Font.Color := clWhite;
      Font.Style := [];
      Layout := TTextLayout.tlCenter;
      Parent := TeeBoxPanel[I];
      Transparent := False;
    end;

    TeeBoxNameLabel[I] := TLabel.Create(Self);
    with TLabel(TeeBoxNameLabel[I]) do
    begin
      DoubleBuffered := True;
      Width := 80;
      AutoSize := False;
      Align := TAlign.alLeft;
      Alignment := TAlignment.taCenter;
      Caption := ''; //'999';
      Color := $0045D10E; //$00544ED6;
      Font.Name := 'Noto Sans CJK KR Bold';
      Font.Size := 26;
      Font.Color := clWhite;
      Font.Style := [fsBold];
      Layout := TTextLayout.tlCenter;
      Parent := TeeBoxPanel[I];
      Transparent := False;
    end;

    RemainMinLabel[I] := TLabel.Create(Self);
    with TLabel(RemainMinLabel[I]) do
    begin
      DoubleBuffered := True;
      AutoSize := False;
      Align := TAlign.alClient;
      Alignment := TAlignment.taCenter;
      Caption := ''; //'999';
      Color := clWhite;
      Font.Name := 'Noto Sans CJK KR Bold';
      Font.Size := 20;
      Font.Color := $00404040;
      Font.Style := [fsBold];
      Layout := TTextLayout.tlCenter;
      Parent := TeeBoxPanel[I];
      Transparent := False;
    end;
  end;

  AutoSize := True;
end;

destructor TQuickPanel.Destroy;
begin

  inherited;
end;

procedure TQuickPanel.SetBackgroundColor(const AColor: TColor);
begin
  with TRoundPanel(Self) do
  begin
    BackgroundColor := AColor;
    Brush.Color := AColor;
  end;
  TitleLabel.Color := AColor;
  TitleLabel.Font.Color := InvertColor2(AColor);
end;

procedure TQuickPanel.SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
begin
  TeeBoxNameLabel[AIndex].Caption := ATeeBoxName;
  RemainMinLabel[AIndex].Caption := Format('%d', [ARemainMin]);
end;

{ TQuickSidePanel }

constructor TQuickSidePanel.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  DoubleBuffered := True;
  Height := 176;
  Width := 350;
  BevelOuter := bvNone;
  Color := $00FFEAD5;

  SetLength(FBasePanel, LCN_QUICK_OF_FLOOR);
  SetLength(FBodyImage, LCN_QUICK_OF_FLOOR);
  SetLength(FTeeBoxNameLabel, LCN_QUICK_OF_FLOOR);
  SetLength(FRemainMinLabel, LCN_QUICK_OF_FLOOR);
  for I := 0 to Pred(LCN_QUICK_OF_FLOOR) do
  begin
    FBasePanel[I] := TPanel.Create(Self);
    with FBasePanel[I] do
    begin
      Parent := Self;
      DoubleBuffered := True;
      Caption := '';
      Top := 0;
      Left := ((66 + 5) * I);
      Height := 176;
      Width := 66;
      BevelOuter := bvNone;
      Color := $00FFEAD5;
    end;

    FBodyImage[I] := TImage.Create(Self);
    with FBodyImage[I] do
    begin
      Parent := FBasePanel[I];
      AutoSize := False;
      Transparent := True;
      Height := 176;
      Width := 66;
      Top := 0;
      Left := 0;
      Picture.Assign(FImageCollection.Items[3].Picture); //imgTeeBoxReady
      Stretch := True;
    end;

    FTeeBoxNameLabel[I] := TLabel.Create(Self);
    with TLabel(FTeeBoxNameLabel[I]) do
    begin
      Parent := FBasePanel[I];
      Caption := '';
      Top := 0;
      Left := 0;
      Alignment := taCenter;
      AutoSize := False;
      Layout := tlCenter;
      Font.Name := 'Noto Sans CJK KR Regular';
      Font.Size := 24;
      Font.Color := GCR_COLOR_BACK_LABEL;
      Font.Style := [fsBold];
      Height := 48;
      Width := 66;
      Transparent := True;
    end;

    FRemainMinLabel[I] := TLabel.Create(Self);
    with TLabel(FRemainMinLabel[I]) do
    begin
      Parent := FBasePanel[I];
      Top := 88;
      Left := 0;
      Alignment := taCenter;
      AutoSize := False;
      Color := GCR_COLOR_BACK_LABEL;
      Transparent := False;
      Layout := tlCenter;
      Font.Name := 'Noto Sans CJK KR Regular';
      Font.Size := 22;
      Font.Color := GCR_COLOR_PLAY;
      Font.Style := [fsBold];
      Height := 50;
      Width := 66;
    end;
  end;
end;

destructor TQuickSidePanel.Destroy;
begin

  inherited;
end;

procedure TQuickSidePanel.SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
begin
  FTeeBoxNameLabel[AIndex].Caption := ATeeBoxName;
  FRemainMinLabel[AIndex].Caption := Format('%d', [ARemainMin]);
end;

{ TBlinkerThread }

constructor TBlinkerThread.Create;
begin
  inherited Create(True);

  FWorking := False;
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
    if (not FWorking) and
       (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FWorking := True;
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
                FTeeBoxPanels[I].CheckImage.Visible := FBlinked;
            end;
          end);
      finally
        FWorking := False;
      end;
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxSubViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;

end.
