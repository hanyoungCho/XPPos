(*******************************************************************************

  Title       : 타석 가동 상황 (한강골프랜드 전용)
  Filename    : uXGTeeBoxSubView_Hgland.pas
  Author      : 이선우
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-07-15   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2021 All rights reserved.

*******************************************************************************)
{$WARN SYMBOL_PLATFORM OFF}
{$M+}
unit uXGTeeBoxSubView_Hgland;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB, Graphics,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics, dxBarBuiltInMenu, cxLookAndFeels, cxLookAndFeelPainters,
  cxPC, cxControls,
  { SolbiVCL}
  GMPanel, LEDFontNum;

{$I ..\..\common\XGPOS.inc}

const
  LCN_IMG_TEEBOX_READY = 1;
  LCN_IMG_TEEBOX_SOON  = 2;
  LCN_IMG_TEEBOX_ERROR = 3;
  LCN_IMG_TEEBOX_WAIT  = 4;
  LCN_IMG_TEEBOX_HOLD  = 5;

  LCN_MAX_FLOORS = 3;
  LCN_QUICK_OF_FLOOR = 4;
  LCN_TEEBOX_FONT_SIZE = 13;

  LCN_START_LEFT = 4;
  LCN_START_LEFT_2 = 1390;
  LCN_START_TOP = 834;
  LCN_TEEBOX_WIDTH = 63;
  LCN_TEEBOX_HEIGHT = 178;
  LCN_TEEBOX_INTERVAL = 66;

  LCN_FLOOR_INTERVAL = 385;

  LCN_TEEBOX_PER_FLOOR = 29;
  LCN_TEEBOX_SHOLDER_PER_FLOOR = 8;

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

  TQuickViewItem = record
    TeeBoxNameLabel: TLabel;
    RemainMinLabel: TLabel;
  end;

  TTeeBoxPanel = class(TPanel)
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
    FUseYN: Boolean;
    FCurStatus: Integer;
    FOldStatus: Integer;
    FSelected: Boolean;
    FBodyIndex: Integer;

    procedure SetTeeBoxName(const AValue: string);
    procedure SetEndTime(const AValue: string);
    procedure SetReservedCount(const AValue: Integer);
    procedure SetUseYN(const AValue: Boolean);
    procedure SetCurStatus(const AValue: Integer);
    procedure SetSelected(const AValue: Boolean);
    procedure SetRemainMin(const AValue: Integer);
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
    property UseYN: Boolean read FUseYN write SetUseYN default False;
    property CurStatus: Integer read FCurStatus write SetCurStatus default CTS_TEEBOX_NOTUSED;
    property OldStatus: Integer read FOldStatus write FOldStatus default CTS_TEEBOX_NOTUSED;
    property Selected: Boolean read FSelected write SetSelected default False;
    property BodyIndex: Integer read FBodyIndex write SetBodyIndex;
    property FontSizeAdjust: Integer write SetFontSizeAdjust;
  end;

  TXGTeeBoxSubViewHglandForm = class(TPluginModule)
    panHeader: TPanel;
    imcTeeBoxRes: TcxImageCollection;
    imgTeeBoxReady: TcxImageCollectionItem;
    imgTeeBoxError: TcxImageCollectionItem;
    imgTeeBoxSoon: TcxImageCollectionItem;
    imgTeeBoxWait: TcxImageCollectionItem;
    imgTeeBoxHold: TcxImageCollectionItem;
    imgChecked: TcxImageCollectionItem;
    panTeeBoxLegend: TPanel;
    lblStatusReady: TLabel;
    lblStatusSoon: TLabel;
    lblStatusReserved: TLabel;
    lblStatusError: TLabel;
    Panel9: TPanel;
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
    imgLogo: TImage;
    panBody: TPanel;
    lblFloorTitle1: TLabel;
    lblFloorTitle2: TLabel;
    lblFloorTitle3: TLabel;
    TemplateTeeBoxPanel: TPanel;
    TemplateBodyImage: TImage;
    TemplateRemainMinLabel: TLabel;
    TemplateEndTimeLabel: TLabel;
    TemplateCheckImage: TImage;
    TemplateTeeBoxNoLabel: TLabel;
    TemplateReserveCountLabel: TLabel;
    panQuickView: TPanel;
    QuickFloorTitle1: TPanel;
    QuickFloorTitle2: TPanel;
    QuickFloorTitle3: TPanel;
    QuickInfo11: TPanel;
    lblQuickTeeBoxName11: TLabel;
    lblQuickRemainMin11: TLabel;
    QuickInfo12: TPanel;
    lblQuickTeeBoxName12: TLabel;
    lblQuickRemainMin12: TLabel;
    QuickInfo13: TPanel;
    lblQuickTeeBoxName13: TLabel;
    lblQuickRemainMin13: TLabel;
    QuickInfo14: TPanel;
    lblQuickTeeBoxName14: TLabel;
    lblQuickRemainMin14: TLabel;
    QuickInfo21: TPanel;
    lblQuickTeeBoxName21: TLabel;
    lblQuickRemainMin21: TLabel;
    QuickInfo22: TPanel;
    lblQuickTeeBoxName22: TLabel;
    lblQuickRemainMin22: TLabel;
    QuickInfo23: TPanel;
    lblQuickTeeBoxName23: TLabel;
    lblQuickRemainMin23: TLabel;
    QuickInfo24: TPanel;
    lblQuickTeeBoxName24: TLabel;
    lblQuickRemainMin24: TLabel;
    QuickInfo31: TPanel;
    lblQuickTeeBoxName31: TLabel;
    lblQuickRemainMin31: TLabel;
    QuickInfo32: TPanel;
    lblQuickTeeBoxName32: TLabel;
    lblQuickRemainMin32: TLabel;
    QuickInfo33: TPanel;
    lblQuickTeeBoxName33: TLabel;
    lblQuickRemainMin33: TLabel;
    QuickInfo34: TPanel;
    lblQuickTeeBoxName34: TLabel;
    lblQuickRemainMin34: TLabel;
    imgStoreLogo: TImage;

    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrClockTimer(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBlinkerThread: TBlinkerThread;
    FFloorTitles: TArray<TLabel>;
    FFloorCount: Integer;
    FQuickView: array[0..Pred(LCN_MAX_FLOORS)] of array[0..Pred(LCN_QUICK_OF_FLOOR)] of TQuickViewItem;
    FTimeBlink: Boolean;
    FIsReady: Boolean;
    FIsFirst: Boolean;
    FIsTeeBox: Boolean;
    FForceClosing: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure CreateTeeBoxPanel(const ATeeBoxIndex, ATop, ALeft: Integer);
    procedure ChangeBackgroundColor(const AColor: TColor);
    procedure RefreshTeeBoxLayout;
    procedure RefreshTeeBoxStatus;
    procedure SetQuickInfo(const AFloorIndex, ATeeBoxIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
    function IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
  protected
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;
var
  FTeeBoxPanels: TArray<TTeeBoxPanel>;
  FImageCollection: TcxImageCollection;
  FTeeBoxCount: Integer;

implementation

uses
  Math, DateUtils,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager;

{$R *.dfm}

{ TXGTeeBoxSubViewHglandForm }

constructor TXGTeeBoxSubViewHglandForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I, nFloor, nTop, nLeft, nCol, nTeeBoxIndex: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FIsFirst := True;
  FIsReady := False;

  Self.Width := Global.SubMonitor.Width;
  Self.Height := Global.SubMonitor.Height;

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

  panTeeBoxLegend.Top := (panHeader.Height div 2) - (panTeeBoxLegend.Height div 2);
  panTeeBoxLegend.Left := (panHeader.Width div 2) - (panTeeBoxLegend.Width div 2);
  panBody.Color := Global.SubMonitor.BackgroundColor;
  panQuickView.Color := Global.SubMonitor.BackgroundColor;
  panQuickView.Visible := Global.TeeBoxQuickView;

  //프런트POS, 레슨룸(파스텔스튜디오)이 아니면 사용 불가
  FIsTeeBox := (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]);
  if FIsTeeBox then
  begin
    FTeeBoxCount := 0;
    FFloorCount := Length(Global.TeeBoxFloorInfo);
    SetLength(FFloorTitles, FFloorCount);
    for nFloor := 0 to Pred(FFloorCount) do
    begin
      if (nFloor >= LCN_MAX_FLOORS) then
        Break;

      FTeeBoxCount := FTeeBoxCount + Global.TeeBoxFloorInfo[nFloor].TeeBoxCount;
    end;

    SetLength(FTeeBoxPanels, FTeeBoxCount);
    nTeeBoxIndex := 0;
    for nFloor := 0 to Pred(FFloorCount) do
    begin
      if (nFloor >= LCN_MAX_FLOORS) then
        Break;

      if (Global.TeeBoxFloorInfo[nFloor].TeeBoxCount > LCN_TEEBOX_PER_FLOOR) then
      begin
        nCol := 0;
        for I := 0 to Pred(LCN_TEEBOX_SHOLDER_PER_FLOOR) do
        begin
          nTop := LCN_START_TOP - ((LCN_FLOOR_INTERVAL * nFloor) + LCN_TEEBOX_HEIGHT + 3);
          nLeft := LCN_START_LEFT + (LCN_TEEBOX_INTERVAL * nCol);
          CreateTeeBoxPanel(nTeeBoxIndex, nTop, nLeft);
          Inc(nTeeBoxIndex);
          Inc(nCol);
        end;

        nCol := 0;
        for I := 0 to Pred(LCN_TEEBOX_PER_FLOOR) do
        begin
          nTop := LCN_START_TOP - (LCN_FLOOR_INTERVAL * nFloor);
          nLeft := LCN_START_LEFT + (LCN_TEEBOX_INTERVAL * nCol);
          CreateTeeBoxPanel(nTeeBoxIndex, nTop, nLeft);
          Inc(nTeeBoxIndex);
          Inc(nCol);
        end;

        nCol := 0;
        for I := 0 to Pred(LCN_TEEBOX_SHOLDER_PER_FLOOR) do
        begin
          nTop := LCN_START_TOP - ((LCN_FLOOR_INTERVAL * nFloor) + LCN_TEEBOX_HEIGHT + 3);
          nLeft := LCN_START_LEFT_2 + (LCN_TEEBOX_INTERVAL * nCol);
          CreateTeeBoxPanel(nTeeBoxIndex, nTop, nLeft);
          Inc(nTeeBoxIndex);
          Inc(nCol);
        end;
      end
      else
      begin
        nCol := 0;
        for I := 0 to Pred(LCN_TEEBOX_PER_FLOOR) do
        begin
          nTop := LCN_START_TOP - (LCN_FLOOR_INTERVAL * nFloor);
          nLeft := (LCN_START_LEFT + (LCN_TEEBOX_INTERVAL * nCol));
          CreateTeeBoxPanel(nTeeBoxIndex, nTop, nLeft);
          Inc(nTeeBoxIndex);
          Inc(nCol);
        end;
      end;

      FFloorTitles[nFloor] := TLabel(FindComponent('lblFloorTitle' + IntToStr(nFloor + 1)));
      FFloorTitles[nFloor].Top := LCN_START_TOP - ((LCN_FLOOR_INTERVAL * nFloor) + FFloorTitles[nFloor].Height);
      FFloorTitles[nFloor].Visible := True;
      FFloorTitles[nFloor].Font.Color := InvertColor2(Global.SubMonitor.BackgroundColor); //$00689F0E;

      for I := 0 to Pred(LCN_QUICK_OF_FLOOR) do
      begin
        FQuickView[nFloor][I].TeeBoxNameLabel := TLabel(FindComponent('lblQuickTeeBoxName' + IntToStr(nFloor + 1) + IntToStr(I + 1)));
        FQuickView[nFloor][I].RemainMinLabel := TLabel(FindComponent('lblQuickRemainMin' + IntToStr(nFloor + 1) + IntToStr(I + 1)));
        FQuickView[nFloor][I].TeeBoxNameLabel.Caption := '';
        FQuickView[nFloor][I].RemainMinLabel.Caption := '';
      end;
    end;

    if Assigned(AMsg) then
      ProcessMessages(AMsg);

    tmrClock.Interval := 100;
    tmrClock.Enabled := True;
  end;
end;

destructor TXGTeeBoxSubViewHglandForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxSubViewHglandForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 0;
end;

procedure TXGTeeBoxSubViewHglandForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FBlinkerThread) then
    FBlinkerThread.Terminate;

  Action := caFree;
end;

procedure TXGTeeBoxSubViewHglandForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing or FForceClosing;
end;

procedure TXGTeeBoxSubViewHglandForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxSubViewHglandForm.ProcessMessages(AMsg: TPluginMessage);
var
  nFloor, nIndex, nValue: Integer;
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
    if (nFloor in [0..Pred(LCN_MAX_FLOORS)]) then
    begin
      nIndex := AMsg.ParamByInteger(CPP_QUICK_INDEX);
      if (nIndex < LCN_QUICK_OF_FLOOR) then
        SetQuickInfo(nFloor, nIndex, AMsg.ParamByString(CPP_TEEBOX_NAME), AMsg.ParamByInteger(CPP_REMAIN_MIN));
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

  (*
  if (AMsg.Command = CPC_PRIVACY_AGREEMENT) then
    if AMsg.ParamByBoolean(CPP_ACTIVE) then
      pgcBody.ActivePage := tabPrivacyAgreement
    else
      pgcBody.ActivePage := tabScoreboard;
  *)
end;

procedure TXGTeeBoxSubViewHglandForm.PluginModuleShow(Sender: TObject);
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

procedure TXGTeeBoxSubViewHglandForm.CreateTeeBoxPanel(const ATeeBoxIndex, ATop, ALeft: Integer);
begin
  FTeeBoxPanels[ATeeBoxIndex] := TTeeBoxPanel.Create(Self);
  with FTeeBoxPanels[ATeeBoxIndex] do
  begin
    Tag := ATeeBoxIndex;
    Parent := panBody;
    BevelOuter := bvNone;
    Color := Global.SubMonitor.BackgroundColor; //GCR_COLOR_BACK_PANEL;
    Width := LCN_TEEBOX_WIDTH;
    Height := LCN_TEEBOX_HEIGHT;
    Top := ATop;
    Left := ALeft;
    TeeBoxNoLabel.Caption := '';
    BodyIndex := LCN_IMG_TEEBOX_READY;
    CheckImage.Picture.Assign(imgChecked.Picture);
    Visible := True;
  end;
end;

procedure TXGTeeBoxSubViewHglandForm.ChangeBackgroundColor(const AColor: TColor);
var
  I: Integer;
begin
  panBody.Color := AColor;
  panQuickView.Color := AColor;
  for I := 0 to Pred(FTeeBoxCount) do
    FTeeBoxPanels[I].Color := AColor;

  for I := 0 to Pred(FFloorCount) do
  begin
    if (I >= LCN_MAX_FLOORS) then
      Break;

    FFloorTitles[I].Font.Color := InvertColor2(AColor);
  end;
end;

procedure TXGTeeBoxSubViewHglandForm.RefreshTeeBoxLayout;
var
  nIndex: Integer;
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
          FTeeBoxPanels[nIndex].UseYN      := FieldByName('use_yn').AsBoolean;

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

procedure TXGTeeBoxSubViewHglandForm.RefreshTeeBoxStatus;
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

procedure TXGTeeBoxSubViewHglandForm.SetQuickInfo(const AFloorIndex, ATeeBoxIndex: Integer; const ATeeBoxName: string; const ARemainMin: Integer);
begin
  FQuickView[AFloorIndex, ATeeBoxIndex].TeeBoxNameLabel.Caption := ATeeBoxName;
  FQuickView[AFloorIndex, ATeeBoxIndex].RemainMinLabel.Caption := Format('%d', [ARemainMin]);
end;

procedure TXGTeeBoxSubViewHglandForm.tmrClockTimer(Sender: TObject);
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

function TXGTeeBoxSubViewHglandForm.IndexOfTeeBoxNo(const ATeeBoxNo: Integer): Integer;
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

{ TTeeBoxPanel }

constructor TTeeBoxPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Parent := TWinControl(AOwner);
  DoubleBuffered := True;
  AutoSize := False;

  BodyImage := TImage.Create(Self);
  with BodyImage do
  begin
    Parent := Self;
    AutoSize := False;
    Transparent := True;
    Width := LCN_TEEBOX_WIDTH;
    Height := LCN_TEEBOX_HEIGHT;
    Top := 0;
    Left := 0;
    Stretch := True;
  end;

  TeeBoxNoLabel := TLabel.Create(Self);
  with TeeBoxNoLabel do
  begin
    Parent := Self;
    Top := 0;
    Left := 0;
    Alignment := taCenter;
    AutoSize := False;
    Layout := tlCenter;
    Font.Name := 'Noto Sans CJK KR Regular';
    Font.Size := 24;
    Font.Color := GCR_COLOR_BACK_LABEL;
    Font.Style := [fsBold];
    Width := LCN_TEEBOX_WIDTH;
    Height := 48;
    Transparent := True;
  end;

  EndTimeLabel := TLabel.Create(Self);
  with EndTimeLabel do
  begin
    Parent := Self;
    Top := 56;
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
    Width := LCN_TEEBOX_WIDTH;
    Height := 25;
  end;

  RemainMinLabel := TLabel.Create(Self);
  with RemainMinLabel do
  begin
    Parent := Self;
    Top := 87;
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
    Width := LCN_TEEBOX_WIDTH;
    Height := 50;
  end;

  ReservedCountLabel := TLabel.Create(Self);
  with ReservedCountLabel do
  begin
    Parent := Self;
    Top := 143;
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
    Width := LCN_TEEBOX_WIDTH;
    Height := 25;
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
    Top := 126;
    Left := 9;
    Visible := False;
  end;
end;

destructor TTeeBoxPanel.Destroy;
begin
  BodyImage.Free;
  CheckImage.Free;
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
          RemainMinLabel.Font.Size :=LCN_TEEBOX_FONT_SIZE + Global.TeeBoxFontSizeAdjust;
          RemainMinLabel.Font.Color := GCR_COLOR_ERROR;
        end;
      CTS_TEEBOX_ERROR:
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
      begin
        EndTimeLabel.Caption := '';
      end;
    CTS_TEEBOX_STOP_ALL:
      begin
        RemainMinLabel.Caption := Format('%d', [RemainMin]);
      end;
    CTS_TEEBOX_STOP:
      begin
        EndTimeLabel.Caption := '';
      end;
    CTS_TEEBOX_ERROR:
      begin
        EndTimeLabel.Caption := '';
      end;
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

procedure TTeeBoxPanel.SetFontSizeAdjust(const AValue: Integer);
var
  nSize: Integer;
begin
  nSize := (LCN_TEEBOX_FONT_SIZE + AValue);
  RemainMinLabel.Font.Size := nSize;
  EndTimeLabel.Font.Size := nSize;
  ReservedCountLabel.Font.Size := nSize;
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
  Result := TXGTeeBoxSubViewHglandForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;

end.
