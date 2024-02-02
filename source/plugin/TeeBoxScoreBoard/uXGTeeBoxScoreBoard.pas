(*******************************************************************************

  Title       : 보조 모니터 출력 화면
  Filename    : uXGTeeBoxScoreBoard.pas
  Author      : 이선우
  Description : 엑스골프(장한평점) 전용
    ...
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2016-10-25   Initial Release.
*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGTeeBoxScoreBoard;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB, Graphics,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics,
  { TMS }
  AdvShapeButton,
  { SolbiVCL}
  LEDFontNum, RoundPanel, Vcl.Imaging.pngimage;

{$I ..\..\common\XGPOS.inc}

const
  LCN_QUICK_OF_FLOOR = 5;
  LCN_TEEBOX_FONT_SIZE = 13;

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

  TPrepareStatus = record
    IsLocalDB: Boolean;
    IsTeeBox: Boolean;
    IsTerminal: Boolean;
  end;

  TTeeBoxStatusThread = class(TThread)
  private
    FWorking: Boolean;
    FLastWorked: TDateTime;
    FInterval: Integer;
  protected
    procedure Execute; override;
  published
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval default 30;
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
    property FontSizeAdjust: Integer write SetFontSizeAdjust;
  end;

  TQuickPanel = class(TRoundPanel)
  private
    TitleLabel: TLabel;
    TeeBoxPanel: TArray<TPanel>;
    TeeBoxHeadLabel: TArray<TLabel>;
    TeeBoxNameLabel: TArray<TLabel>;
    RemainMinLabel: TArray<TLabel>;

    procedure SetBackgroundColor(const AColor: TColor);
    procedure Clear;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);

    property BackgroundColor: TColor write SetBackgroundColor;
  end;

  TQuickSideInfo = record
    TitleLabel: TLabel;
    QuickInfoLabel: array[0..Pred(LCN_QUICK_OF_FLOOR)] of TLabel;
  public
    procedure SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
  end;

  TXGTeeBoxScoreBoardForm = class(TPluginModule)
    panHeader: TPanel;
    panBody: TPanel;
    TemplateTeeBoxPanel: TPanel;
    TemplateBodyImage: TImage;
    TemplateVipImage: TImage;
    TemplateRemainMinLabel: TLabel;
    TemplateEndTimeLabel: TLabel;
    TemplateCheckImage: TImage;
    TemplateFloorTitleLabel: TLabel;
    TemplateLeftRightImage: TImage;
    TemplateTeeBoxNoLabel: TLabel;
    TemplateFloorLegendImage: TImage;
    TemplateReserveCountLabel: TLabel;
    TemplateManualImage: TImage;
    Panel1: TPanel;
    imcTeeBoxRes: TcxImageCollection;
    imgVip: TcxImageCollectionItem;
    imgLeftRight: TcxImageCollectionItem;
    imgChecked: TcxImageCollectionItem;
    imgTeeBoxReady: TcxImageCollectionItem;
    imgTeeBoxSoon: TcxImageCollectionItem;
    imgTeeBoxError: TcxImageCollectionItem;
    imgTeeBoxWait: TcxImageCollectionItem;
    imgTeeBoxHold: TcxImageCollectionItem;
    imgQrCode: TcxImageCollectionItem;
    imgFingerPrint: TcxImageCollectionItem;
    imgCreditCard: TcxImageCollectionItem;
    imgFloorLegend: TcxImageCollectionItem;
    imgLeft: TcxImageCollectionItem;
    imgManual: TcxImageCollectionItem;
    tmrClock: TTimer;
    panClock: TPanel;
    lblClockHours: TLabel;
    lblClockWeekday: TLabel;
    lblClockDate: TLabel;
    lblClockSepa: TLabel;
    lblClockMins: TLabel;
    imgTrackMan: TcxImageCollectionItem;
    panQuickView1: TPanel;
    Panel4: TPanel;
    lblQuickInfo11: TLabel;
    lblQuickInfo12: TLabel;
    lblQuickInfo15: TLabel;
    lblQuickInfo13: TLabel;
    lblQuickInfo14: TLabel;
    lblFloorTitle1: TLabel;
    Panel5: TPanel;
    lblFloorTitle2: TLabel;
    lblQuickInfo21: TLabel;
    lblQuickInfo22: TLabel;
    lblQuickInfo23: TLabel;
    lblQuickInfo24: TLabel;
    lblQuickInfo25: TLabel;
    Panel9: TPanel;
    ledReadyCount: TLEDFontNum;
    Label8: TLabel;
    ledWaitingCount: TLEDFontNum;
    ledStoreEndTime: TLEDFontNum;
    panTeeBoxLegend: TPanel;
    lblStatusReady: TLabel;
    lblStatusSoon: TLabel;
    lblStatusReserved: TLabel;
    lblStatusError: TLabel;
    panHeaderTools: TPanel;
    btnConfig: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    panQuickView2: TPanel;
    Panel3: TPanel;
    lblQuickInfo31: TLabel;
    lblQuickInfo32: TLabel;
    lblQuickInfo35: TLabel;
    lblQuickInfo33: TLabel;
    lblQuickInfo34: TLabel;
    lblFloorTitle3: TLabel;
    Panel6: TPanel;
    lblFloorTitle4: TLabel;
    lblQuickInfo41: TLabel;
    lblQuickInfo42: TLabel;
    lblQuickInfo43: TLabel;
    lblQuickInfo44: TLabel;
    lblQuickInfo45: TLabel;
    imgGDR: TcxImageCollectionItem;
    imgLogo: TImage;
    lblPluginVersion: TLabel;
    RoundPanel1: TRoundPanel;
    TemplateQuickTitle: TLabel;
    TemplateQuickTeeBoxPanel: TPanel;
    TemplateQuickTeeBoxTitleLabel: TLabel;
    Label2: TLabel;
    TemplateQuickTeeBoxRemainMinLabel: TLabel;
    imgIndoor: TcxImageCollectionItem;
    imgSwingAnal: TcxImageCollectionItem;
    imgVipCouple: TcxImageCollectionItem;

    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrClockTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBlinkerThread: TBlinkerThread;
    FQuickPanels: TArray<TQuickPanel>;
    FQuickSideInfo: TArray<TQuickSideInfo>;
    FFloorTitles: TArray<TLabel>;
    FFloorLegends: TArray<TImage>;
    FFloorCount: Integer;
    FTeeBoxCount: Integer;
    FTimeBlink: Boolean;
    FPlayList: TStrings;
    FPlayIndex: Integer;
    FPlayInterval: Integer;
    FIsReady: Boolean;
    FTeeBoxStatusThread: TTeeBoxStatusThread;
    FIsFirst: Boolean;
    FIsTeeBox: Boolean;
    FForceClosing: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshTeeBoxLayout;
    procedure RefreshTeeBoxStatus;
    procedure CloseAction;
    procedure DoInit;
    function DoAuthorize(var AErrMsg: string): Boolean;
    function DoPrepare: Boolean;
    function DoLocalConfig: Boolean;
    function DoSystemConfig: Boolean;
    procedure ChangeBackgroundColor(const AColor: TColor);
    function IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
  protected
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;
var
  XGTeeBoxScoreBoardForm: TXGTeeBoxScoreBoardForm;
  FImageCollection: TcxImageCollection;

implementation

uses
  Math, DateUtils, XQuery,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGMsgBox, uXGSaleManager, uXGInputBox;

var
  FTeeBoxPanels: TArray<TTeeBoxPanel>;

{$R *.dfm}

{ TTeeBoxSubViewForm }

constructor TXGTeeBoxScoreBoardForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  sPlayList: string;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  Global.SubMonitorID := Self.PluginID;
  FOwnerId := 0;
  FIsReady := False;
  FPlayList := TStringList.Create;
  sPlayList := Global.ContentsDir + 'playlist.txt';
  if FileExists(sPlayList) then
    FPlayList.LoadFromFile(sPlayList);
  FPlayIndex := FPlayList.Count;
  FPlayInterval := 0;

  Self.Width := Global.SubMonitor.Width;
  Self.Height := Global.SubMonitor.Height;
  panTeeBoxLegend.Top := (panHeader.Height div 2) - (panTeeBoxLegend.Height div 2);
  panTeeBoxLegend.Left := (panHeader.Width div 2) - (panTeeBoxLegend.Width div 2);

  FImageCollection := TcxImageCollection.Create(Self);
  FImageCollection.Items := imcTeeBoxRes.Items;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblClockDate.Caption := ' ';
  lblClockWeekday.Caption := ' ';
  lblClockHours.Caption := ' ';
  lblClockMins.Caption := ' ';
  lblClockSepa.Caption := ':';
  lblStatusSoon.Caption := Format('%d분이내', [Global.GameOverAlarmMin]);

  //프런트POS, 레슨룸(파스텔스튜디오)이 아니면 사용 불가
  FIsTeeBox := (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]);
  if FIsTeeBox then
  begin
    DoInit;
    if Assigned(AMsg) then
      ProcessMessages(AMsg);

    FIsFirst := True;
    tmrClock.Interval := 100;
    tmrClock.Enabled := True;
  end;
end;

destructor TXGTeeBoxScoreBoardForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxScoreBoardForm.DoInit;
var
  nIdx, nRow, nCol, nStart, nEnd, nTop, nTopCnt, nBaseLeft, nPanelWidth, nPanelHeight,
  nPanelGap, nTopGap, nInterval: Integer;
  sErrMsg: string;
  aTopPos: TArray<TTopPosInfo>;
begin
  if not DoAuthorize(sErrMsg) and
     (XGMsgBox(Self.Handle, mtConfirmation, '확인',
        '시스템 구성 설정이 완료되지 않았습니다!' + _CRLF +
        '환경설정 화면을 사용하시겠습니까?', ['환경설정', '종료']) <> mrOk) then
    Application.Terminate;

  if not DoPrepare then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림',
      '시스템 구성설정이 완료되지 못하였습니다!' + _CRLF + '프로그램을 종료합니다.', ['확인']);
    CloseAction;
    Exit;
  end;

  panBody.Color := Global.SubMonitor.BackgroundColor;
  FTeeBoxCount := 0;
  FFloorCount := Length(Global.TeeBoxFloorInfo);
  SetLength(aTopPos, FFloorCount);
  SetLength(FQuickPanels, FFloorCount);
  SetLength(FQuickSideInfo, FFloorCount);
  SetLength(FFloorTitles, FFloorCount);
  SetLength(FFloorLegends, FFloorCount);

  nPanelHeight := 224;
  nPanelGap := 3;
  nPanelWidth := (Global.SubMonitor.Width - 210) div Global.TeeBoxMaxCountOfFloors;
  nTopGap := (Self.Height - panHeader.Height) div FFloorCount;
  nTop := Self.Height - nTopGap - panHeader.Height;
  nInterval := nPanelWidth + nPanelGap;
  nStart := 0;

  if Global.TeeBoxQuickView and
     (Global.TeeBoxQuickViewMode = CQM_VERTICAL) then
  begin
    with panQuickView1 do
    begin
      Top := 5;
      Left := 5;
      Visible := True;
    end;

    with panQuickView2 do
    begin
      Top := 5;
      Left := panBody.Width - Width - 5;
      Visible := True;
    end;
  end;

  for nRow := 0 to Pred(FFloorCount) do
  begin
    FTeeBoxCount := FTeeBoxCount + Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
    aTopPos[nRow].BaseTop := (nTop - (nTopGap * nRow));

    FFloorTitles[nRow] := TLabel.Create(Self);
    with FFloorTitles[nRow] do
    begin
      Parent := panBody;
      AutoSize := True;
      Caption := Global.TeeBoxFloorInfo[nRow].FloorName;
      Color := Global.SubMonitor.BackgroundColor; //$00F4F9EA;
      Font.Name := 'Noto Sans CJK KR Bold';
      Font.Color := InvertColor2(Global.SubMonitor.BackgroundColor); //$00689F0E;
      Font.Size := 28;
      Font.Style := [fsBold];
      Left := (Self.Width div 2) - (((nPanelWidth * Global.TeeBoxFloorInfo[nRow].TeeBoxCount) + (nPanelGap * Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount))) div 2) - 35;
      Transparent := True;
      Visible := False;
    end;

    FFloorLegends[nRow] := TImage.Create(Self);
    with FFloorLegends[nRow] do
    begin
      Parent := panBody;
      AutoSize := True;
      Picture.Assign(imgFloorLegend.Picture);
      Top := (nTop - (nTopGap * nRow)) + 44;
      Left := (Self.Width div 2) -
        (((nPanelWidth * Global.TeeBoxFloorInfo[nRow].TeeBoxCount) +
          (nPanelGap * Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount))) div 2) - 43;
    end;

    FQuickPanels[nRow] := TQuickPanel.Create(Self);
    with FQuickPanels[nRow] do
    begin
      Parent := panBody;
      AutoSize := True;
      Top := (nTop - (nTopGap * nRow)) + 230;
      Left := ((Self.Width div 2) - (Width div 2));
      Visible := Global.TeeBoxQuickView and (Global.TeeBoxQuickViewMode = CQM_HORIZONTAL);
    end;

    if (nRow < 4) then //4개층까지만 처리
    begin
      FQuickSideInfo[nRow].TitleLabel := TLabel(FindComponent('lblFloorTitle' + IntToStr(nRow + 1)));
      FQuickSideInfo[nRow].TitleLabel.Caption := Global.TeeBoxFloorInfo[nRow].FloorName;
      for nCol := 0 to Pred(LCN_QUICK_OF_FLOOR) do
        FQuickSideInfo[nRow].QuickInfoLabel[nCol] := TLabel(FindComponent('lblQuickInfo' + IntToStr(nRow + 1) + IntToStr(nCol + 1)));
    end;
  end;

  SetLength(FTeeBoxPanels, FTeeBoxCount);
  for nRow := 0 to Pred(FFloorCount) do
  begin
    nEnd := Pred(Global.TeeBoxFloorInfo[nRow].TeeBoxCount) + nStart;
    nTopCnt := Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
    nBaseLeft := (Self.Width div 2) - (((nPanelWidth * nTopCnt) + (nPanelGap * Pred(nTopCnt))) div 2) + 40;
    nTop := aTopPos[nRow].BaseTop;
    nCol := 0;

    for nIdx := nStart to nEnd do
    begin
      FTeeBoxPanels[nIdx] := TTeeBoxPanel.Create(Self);
      with FTeeBoxPanels[nIdx] do
      begin
        Tag := nIdx;
        Parent := panBody;
        BevelOuter := bvNone;
        Color := Global.SubMonitor.BackgroundColor; //GCR_COLOR_BACK_PANEL;
        Height := nPanelHeight;
        Width := nPanelWidth;
        Top := nTop;
        Left := (nBaseLeft + (nInterval * nCol));
        TeeBoxNoLabel.Caption := '';
        VipImage.Picture.Assign(imgVip.Picture);
        ManualImage.Picture.Assign(imgManual.Picture);
        BodyImage.Picture.Assign(imgTeeBoxReady.Picture);
        CheckImage.Picture.Assign(imgChecked.Picture);
      end;

      Inc(nCol);
    end;

    FFloorTitles[nRow].Top := FFloorLegends[nRow].Top - FFloorTitles[nRow].Height;
    FFloorTitles[nRow].Visible := True;
    nStart := nStart + Global.TeeBoxFloorInfo[nRow].TeeBoxCount;
  end;

  ledStoreEndTime.Text := IIF(SaleManager.StoreInfo.StoreEndTime.IsEmpty, '--:--', SaleManager.StoreInfo.StoreEndTime);
end;

function TXGTeeBoxScoreBoardForm.DoAuthorize(var AErrMsg: string): Boolean;
var
  sToken: string;
begin
  Result := False;
  sToken := '';
  if ClientDM.GetToken(Global.ClientConfig.ClientId, Global.ClientConfig.SecretKey, sToken, AErrMsg) then
  begin
    Result := ClientDM.CheckToken(sToken, Global.ClientConfig.ClientId, Global.ClientConfig.SecretKey, AErrMsg);
    if Result then
    begin
      Global.ClientConfig.OAuthToken := sToken;
      Global.ClientConfig.OAuthSuccess := True;
    end;
  end
  else
    XGMsgBox(Self.Handle, mtWarning, '인증 실패',
      '클라이언트 인증에 실패하였습니다!' + _CRLF +
      '터미날ID와 인증키를 확인하여 주십시오.' + _CRLF +
      '(' + AErrMsg + ')', ['확인']);
end;

procedure TXGTeeBoxScoreBoardForm.btnConfigClick(Sender: TObject);
var
  MR: TModalResult;
  sErrMsg: string;
begin
  MR := XGMsgBox(Self.Handle, mtConfirmation, '환경설정 작업 선택',
          '작업을 선택하십시오.', ['사용자' + _CRLF + '설정', '시스템' + _CRLF + '설정']);
  case MR of
    mrOK:
      if DoLocalConfig then
      begin
        if Global.AirConditioner.Enabled then
          if not ClientDM.SetAirConOnOff(0, Global.AirConditioner.OnOffMode, sErrMsg) then
            XGMsgBox(Self.Handle, mtError, '알림',
              '냉/온풍기 제어 요청을 처리할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);

        XGMsgBox(Self.Handle, mtConfirmation, '알림',
          '변경된 일부 설정값은 프로그램을 재시작 하여야 적용될 수 있습니다!', ['확인'], 5);
      end;
    mrCancel:
      if DoSystemConfig then
      begin
        XGMsgBox(Self.Handle, mtConfirmation, '알림',
          '변경된 시스템 설정을 적용하려면 프로그램을 재시작하여야 합니다!' + _CRLF +
          '프로그램을 종료하겠습니다.', ['확인']);
        Global.Closing := True;
        Application.Terminate;
      end;
  end;
end;

procedure TXGTeeBoxScoreBoardForm.CloseAction;
begin
  Global.Closing := True;
  try
    SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
  finally
//    Application.Terminate;
    Close;
  end;
end;

function TXGTeeBoxScoreBoardForm.DoPrepare: Boolean;
var
  sErrMsg, sJobTitle: string;
begin
  Result := False;
  try
    sJobTitle := '로컬 데이터베이스 접속';
    if Global.TeeBoxADInfo.Enabled then
      if not ClientDM.conTeeBox.Connected then
        ClientDM.conTeeBox.Connected := True;

    sJobTitle := '터미널정보 수신';
    if not ClientDM.GetTerminalInfo(sErrMsg) then
      raise Exception.Create(sErrMsg);

    sJobTitle := '사업장정보 수신';
    if not ClientDM.GetStoreInfo(sErrMsg) then
      raise Exception.Create(sErrMsg);

    sJobTitle := '타석정보 수신';
    if not ClientDM.GetTeeBoxList(sErrMsg) then
      raise Exception.Create(sErrMsg);

    Result := True;
  except
    on E: Exception do
    begin
      if (XGMsgBox(Self.Handle, mtError, '확인',
          sJobTitle + '  중 장애가 발생하였습니다!' + _CRLF + E.Message, ['재시도', '종료']) <> mrOK) then
        Application.Terminate;
    end;
  end;
end;

function TXGTeeBoxScoreBoardForm.DoLocalConfig: Boolean;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    Result := (PluginManager.OpenModal('XGConfigLocal' + CPL_EXTENSION, PM) = mrOK);
  finally
    FreeAndNil(PM);
  end;
end;

function TXGTeeBoxScoreBoardForm.DoSystemConfig: Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  with TXGInputBoxForm.Create(nil) do
  try
    Title := '관리자 확인';
    MessageText := '시스템 설정 변경은 관리자 권한입니다!' + _CRLF + '인가된 비밀번호를 입력하여 주십시오.';
    PasswordMode := True;
    if (ShowModal <> mrOK) then
      Exit;
    if (InputText <> Copy(Global.CurrentDate, 5, 4)) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '비밀번호가 일치하지 않습니다!', ['확인'], 5);
      Exit;
    end;
  finally
    Free;
  end;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    Result := (PluginManager.OpenModal('XGConfig' + CPL_EXTENSION, PM) = mrOK);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGTeeBoxScoreBoardForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 0;
end;

procedure TXGTeeBoxScoreBoardForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FBlinkerThread) then
    FBlinkerThread.Terminate;
  if Assigned(FTeeBoxStatusThread) then
    FTeeBoxStatusThread.Terminate;
  FreeAndNil(FPlayList);

  Action := caFree;
end;

procedure TXGTeeBoxScoreBoardForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing or FForceClosing;
end;

procedure TXGTeeBoxScoreBoardForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxScoreBoardForm.ProcessMessages(AMsg: TPluginMessage);
var
  nIndex, nValue: Integer;
begin
  if not FIsReady then
    Exit;

  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);

  if (AMsg.Command = CPC_TEEBOX_LAYOUT) then
    RefreshTeeBoxLayout;

  if (AMsg.Command = CPC_TEEBOX_STATUS) then
    RefreshTeeBoxStatus;

  if (AMsg.Command = CPC_TEEBOX_SELECT) then
  begin
    nIndex := IndexOfTeeBoxNo(AMsg.ParamByInteger(CPP_TEEBOX_INDEX));
    if (nIndex in [0..Pred(FTeeBoxCount)]) then
      FTeeBoxPanels[nIndex].Selected := AMsg.ParamByBoolean(CPP_TEEBOX_SELECTED);
  end;

  if (AMsg.Command = CPC_TEEBOX_HOLD) then
  begin
    nIndex := IndexOfTeeBoxNo(AMsg.ParamByInteger(CPP_TEEBOX_INDEX));
    FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_HOLD;
  end;

  if (AMsg.Command = CPC_TEEBOX_HOLD_CANCEL) then
  begin
    nIndex := IndexOfTeeBoxNo(AMsg.ParamByInteger(CPP_TEEBOX_INDEX));
    FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;
  end;

  if (AMsg.Command = CPC_TEEBOX_READY_ALL) then
    for nIndex := 0 to Pred(Length(FTeeBoxPanels)) do
    begin
      FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;
    end;

  if (AMsg.Command = CPC_TEEBOX_STOP_ALL) then
    for nIndex := 0 to Pred(Length(FTeeBoxPanels)) do
      FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_STOP_ALL;

  if (AMsg.Command = CPC_TEEBOX_READY) then
  begin
    nIndex := IndexOfTeeBoxNo(AMsg.ParamByInteger(CPP_TEEBOX_NO));
    FTeeBoxPanels[nIndex].CurStatus := FTeeBoxPanels[nIndex].OldStatus;
  end;

  if (AMsg.Command = CPC_TEEBOX_COUNTER) then
  begin
    ledReadyCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_READY_COUNT));
    ledWaitingCount.Text := FormatFloat('000', AMsg.ParamByInteger(CPP_WAITING_COUNT));
    ledStoreEndTime.Text := IIF(SaleManager.StoreInfo.StoreEndTime.IsEmpty, '--:--', SaleManager.StoreInfo.StoreEndTime);
  end;

  if (AMsg.Command = CPC_TEEBOX_STOP) then
  begin
    nIndex := IndexOfTeeBoxNo(AMsg.ParamByInteger(CPP_TEEBOX_NO));
    FTeeBoxPanels[nIndex].CurStatus := CTS_TEEBOX_STOP;
  end;

  if (AMsg.Command = CPC_APPLY_CONFIG) then
  begin
    nValue := AMsg.ParamByInteger(CPP_FONT_SIZE_ADJUST);
    for nIndex := 0 to Pred(FTeeBoxCount) do
      FTeeBoxPanels[nIndex].FontSizeAdjust := nValue;

    ChangeBackgroundColor(TColor(AMsg.ParamByInt64(CPP_BACK_COLOR)));
  end;
end;

procedure TXGTeeBoxScoreBoardForm.PluginModuleShow(Sender: TObject);
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

procedure TXGTeeBoxScoreBoardForm.RefreshTeeBoxLayout;
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

procedure TXGTeeBoxScoreBoardForm.RefreshTeeBoxStatus;
var
  nIndex, nFloor, nRemainMin: Integer;
  sTeeBoxName: string;
begin
  with ClientDM.MDTeeBoxStatus3 do
  try
    DisableControls;
    if not Active then
      Open;

    CopyFromDataSet(ClientDM.MDTeeBoxStatus);
    First;
    while not Eof do
    begin
      nIndex := IndexOfTeeBoxNo(FieldByName('teebox_no').AsInteger);
      with FTeeBoxPanels[nIndex] do
      if (nIndex in [0..Pred(Length(FTeeBoxPanels))]) then
      begin
        RemainMin := FieldByName('remain_min').AsInteger;
        EndTime := '';
        ReservedCount := FieldByName('reserved_count').AsInteger;
        CurStatus := FieldByName('use_status').AsInteger;
        if (RemainMin > 0) then
          EndTime := Copy(FieldByName('end_datetime').AsString, 12, 5);

        case CurStatus of
          CTS_TEEBOX_READY:
            begin
              RemainMinLabel.Caption := '';
              RemainMinLabel.Font.Color := GCR_COLOR_PLAY;
              EndTimeLabel.Caption := '';
            end;
          CTS_TEEBOX_RESERVED,
          CTS_TEEBOX_USE:
            begin
              RemainMinLabel.Caption := Format('%d', [RemainMin]);
              RemainMinLabel.Font.Size := 22;
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
            begin
              RemainMinLabel.Caption := '임시' + _CRLF + '예약';
              RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
              RemainMinLabel.Font.Color := GCR_COLOR_HOLD;
              EndTimeLabel.Caption := '';
            end;
          CTS_TEEBOX_STOP_ALL:
            begin
              RemainMinLabel.Caption := '볼회수';
              RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
              RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
              EndTimeLabel.Caption := '';
            end;
          CTS_TEEBOX_STOP:
            begin
              RemainMinLabel.Caption := '점검중';
              RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
              RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
              EndTimeLabel.Caption := '';
            end;
          CTS_TEEBOX_ERROR:
            begin
              RemainMinLabel.Caption := '기기' + _CRLF + '고장';
              RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
              RemainMinLabel.Font.Color := GCR_COLOR_SOON;
              EndTimeLabel.Caption := '';
            end;
          else
            RemainMinLabel.Caption := '';
            RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
            EndTimeLabel.Caption := '';
        end;
      end;

      Next;
    end;
  finally
    EnableControls;
  end;

  if Global.TeeBoxQuickView then
    for nFloor := 0 to Pred(Length(Global.TeeBoxFloorInfo)) do
    begin
      nIndex := 0;
      FQuickPanels[nFloor].Clear;
      with TXQuery.Create(nil) do
      try
        AddDataSet(ClientDM.MDTeeBoxStatus3, 'S');
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
          FQuickPanels[nFloor].SetQuickInfo(nIndex, sTeeBoxName, nRemainMin);
          FQuickSideInfo[nFloor].SetQuickInfo(nIndex, sTeeBoxName, nRemainMin);
          Inc(nIndex);
          Next;
        end;
      finally
        Close;
        Free;
      end;
    end;
end;

procedure TXGTeeBoxScoreBoardForm.btnCloseClick(Sender: TObject);
begin
  if (XGMsgBox(Self.Handle, mtConfirmation, '프로그램 종료',
      '프로그램을 종료하시겠습니까?', ['확인', '취소']) <> mrOK) then
  begin
    Global.Closing := False;
    Exit;
  end;

  Global.Closing := True;
  try
    SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
  finally
//    Application.Terminate;
    Close;
  end;
end;

procedure TXGTeeBoxScoreBoardForm.tmrClockTimer(Sender: TObject);
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

      try
        RefreshTeeBoxLayout;
        if not Assigned(FBlinkerThread) then
        begin
          FBlinkerThread := TBlinkerThread.Create;
          FBlinkerThread.FreeOnTerminate := True;
          if not FBlinkerThread.Started then
            FBlinkerThread.Start;
        end;
        if not Assigned(FTeeBoxStatusThread) then
        begin
          FTeeBoxStatusThread := TTeeBoxStatusThread.Create;
          FTeeBoxStatusThread.FreeOnTerminate := True;
          if not FTeeBoxStatusThread.Started then
            FTeeBoxStatusThread.Start;
        end;
        FIsReady := True;
      except
        on E: Exception do
          UpdateLog(Global.LogFile, Format('', [E.Message]));
      end;
    end;
  finally
    Enabled := True;
  end;
end;

procedure TXGTeeBoxScoreBoardForm.ChangeBackgroundColor(const AColor: TColor);
var
  I: Integer;
begin
  panBody.Color := AColor;
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

function TXGTeeBoxScoreBoardForm.IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
var
  nIndex: Integer;
begin
  Result := -1;
  for nIndex := 0 to Pred(Length(FTeeBoxPanels)) do
    if (FTeeBoxPanels[nIndex].TeeBoxNo = ATeeBoxNo) then
    begin
      Result := nIndex;
      Break;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    Width := (Global.SubMonitor.Width - 200) div Global.TeeBoxMaxCountOfFloors;
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
    case CurStatus of
      CTS_TEEBOX_RESERVED,
      CTS_TEEBOX_USE:
        if (RemainMin <= Global.GameOverAlarmMin) then
          BodyImage.Picture.Assign(FImageCollection.Items[4].Picture)
        else
          BodyImage.Picture.Assign(FImageCollection.Items[6].Picture);
    end;
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

procedure TTeeBoxPanel.SetControlYN(const AValue: Boolean);
begin
  if (FControlYN <> AValue) then
  begin
    FControlYN := AValue;
    ManualImage.Visible := (not FControlYN);
  end;
end;

procedure TTeeBoxPanel.SetCurStatus(const AValue: Integer);
begin
  if (FCurStatus <> AValue) then
    FOldStatus := FCurStatus;
  FCurStatus := AValue;

  if not UseYN then
  begin
    BodyImage.Picture.Assign(FImageCollection.Items[5].Picture);
    RemainMinLabel.Caption := '사용' + _CRLF + '불가';
    RemainMinLabel.Font.Size := LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
    RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
    Exit;
  end;

  case AValue of
    CTS_TEEBOX_READY:
      BodyImage.Picture.Assign(FImageCollection.Items[3].Picture);
    CTS_TEEBOX_RESERVED,
    CTS_TEEBOX_USE:
      if (RemainMin <= Global.GameOverAlarmMin) then
        BodyImage.Picture.Assign(FImageCollection.Items[4].Picture)
      else
        BodyImage.Picture.Assign(FImageCollection.Items[6].Picture);
    CTS_TEEBOX_HOLD:
      BodyImage.Picture.Assign(FImageCollection.Items[7].Picture);
    CTS_TEEBOX_STOP_ALL:
      BodyImage.Picture.Assign(FImageCollection.Items[5].Picture);
    CTS_TEEBOX_STOP:
      BodyImage.Picture.Assign(FImageCollection.Items[5].Picture);
    CTS_TEEBOX_ERROR:
      BodyImage.Picture.Assign(FImageCollection.Items[5].Picture);
    else
      BodyImage.Picture.Assign(FImageCollection.Items[5].Picture);
  end;
end;

procedure TTeeBoxPanel.SetUseYN(const AValue: Boolean);
begin
  if (FUseYN <> AValue) then
  begin
    FUseYN := AValue;
    if not FUseYN then
    begin
      RemainMin := 0;
      EndTime := '';
    end;
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

{ TTeeBoxStatusThread }

constructor TTeeBoxStatusThread.Create;
begin
  inherited Create(True);

  FWorking := False;
  FLastWorked := (Now - 1);
  FInterval := 1000 * 10;
end;

destructor TTeeBoxStatusThread.Destroy;
begin

  inherited;
end;

procedure TTeeBoxStatusThread.Execute;
begin
  repeat
    if (not FWorking) and
       (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FWorking := True;
      FLastWorked := Now;
      try
        Synchronize(
          procedure
          var
            sErrMsg: string;
          begin
            ClientDM.GetTeeBoxStatus(ClientDM.MDTeeboxStatus, sErrMsg);
          end);
      finally
        FWorking := False;
      end;
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

{ TQuickPanel }

constructor TQuickPanel.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  (*
    TitleLabel: TLabel;
    TeeBoxPanel: TArray<TPanel>;
    TeeBoxHeadLabel: TArray<TLabel>;
    TeeBoxNameLabel: TArray<TLabel>;
    RemainMinLabel: TArray<TLabel>;
  *)

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

procedure TQuickPanel.Clear;
var
  I: Integer;
begin
  for I := 0 to Pred(LCN_QUICK_OF_FLOOR) do
  begin
    TeeBoxNameLabel[I].Caption := '';
    RemainMinLabel[I].Caption := '';
  end;
end;

{ TQuickSideInfo }

procedure TQuickSideInfo.SetQuickInfo(const AIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
begin
  QuickInfoLabel[AIndex].Caption := Format('%s (%d)', [ATeeBoxName, ARemainMin]);
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
            for I := 0 to Pred(Length(FTeeBoxPanels)) do
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

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxScoreBoardForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;

end.
