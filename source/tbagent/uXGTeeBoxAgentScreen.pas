(*******************************************************************************

  Project     : XPartners 골프연습장 POS 시스템
  Title       : 인도어연습장 타석기 에이전트 II 스크린 화면
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    2.0.0.0   2022-10-31   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2022 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxAgentScreen;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.OleCtrls,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxLabel, cxPC, dxBarBuiltInMenu,
  { VideoGrabber }
  VidGrab,
  { SolbiLib }
  PicShow,
  { Custom }
  uMediaPlayThread, cxImage;

//{$I ..\common\XGIndoor.inc}
{$I ..\common\XGTeeBoxAgent.inc}
{$I ..\common\XGLicense.inc}

type
  { 화면 최상위 여부 체크 스레드 }
  TTopMostCheckThread = class(TThread)
  private
    FIntervalMilliSeconds: Integer;
    FLastWorked: TDateTime;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TScreenForm = class(TForm)
    pgcScreen: TcxPageControl;
    PicShow: TPicShow;
    VideoPlayer: TVideoGrabber;
    tabHome: TcxTabSheet;
    tabMedia: TcxTabSheet;
    panRemainTime: TPanel;
    imgHome: TcxImage;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VideoPlayerLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
    procedure VideoPlayerPlayerStateChanged(Sender: TObject; OldPlayerState, NewPlayerState: TPlayerState);
    procedure panRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FMediaPlayThread: TMediaPlayThread;
    FTopMostCheckThread: TTopMostCheckThread;
    FTestMode: Boolean;
    FTeeBoxPlayMode: Integer;
    FLastMainPageIndex: Integer;
    FLastTeeBoxPlayMode: Integer;
    FPrepareSeconds: Integer;
    FRemainSeconds: LongInt;
    FAdminMode: Boolean;

    procedure ShowMediaPlayer(const AShow: Boolean);
    procedure ShowRemainTime(const AShow: Boolean);

    procedure SetScreenContents(const AContents: TList);
    procedure SetTeeBoxPlayMode(const ATeeBoxPlayMode: Integer);
    procedure SetPrepareSeconds(const APrepareSeconds: Integer);
    procedure SetRemainSeconds(const ARemainSeconds: Integer);
    procedure SetActiveMediaPlay(const AValue: Boolean);
    procedure SetAdminMode(const AValue: Boolean);

    function GetRemainLeft: Integer;
    function GetRemainTop: Integer;
    procedure SetRemainLeft(const AValue: Integer);
    procedure SetRemainTop(const AValue: Integer);

    procedure OnChangeActiveMediaThread(Sender: TObject);
    procedure OnChangeContentMediaThread(Sender: TObject);
  protected
    { Protected declarations }
    procedure CreateParams(var AParams: TCreateParams); override;
    procedure WndProc(var AMessage: TMessage); override;
  public
    { Public declarations }
    property Contents: TList write SetScreenContents;
    property TeeBoxPlayMode: Integer read FTeeBoxPlayMode write SetTeeBoxPlayMode default TBS_TEEBOX_IDLE;
    property TestMode: Boolean read FTestMode write FTestMode;
    property PrepareSeconds: Integer read FPrepareSeconds write SetPrepareSeconds default 0;
    property RemainSeconds: Integer read FRemainSeconds write SetRemainSeconds default 0;
    property ActiveMediaPlay: Boolean write SetActiveMediaPlay;
    property AdminMode: Boolean read FAdminMode write SetAdminMode default False;
    property RemainLeft: Integer read GetRemainLeft write SetRemainLeft;
    property RemainTop: Integer read GetRemainTop write SetRemainTop;
  end;

implementation

uses
  { Native }
  System.DateUtils,
  { Project }
  uXGTeeBoxAgentDM, uXGCommonLib;

var
  ScreenForm: TScreenForm;

{$R *.dfm}

{ TScreenForm }

{$IFDEF RELEASE}
procedure TScreenForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.WndParent := 0;
end;
{$ENDIF}

procedure TScreenForm.WndProc(var AMessage: TMessage);
begin
{$IFDEF RELEASE}
  case AMessage.Msg of
    CWM_DO_TOPMOST:
//      SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.ClientWidth, Self.ClientHeight, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
   end;
{$ENDIF}

  inherited WndProc(AMessage);
end;

procedure TScreenForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(panRemainTime);

  VideoPlayer.LicenseString := VG_LICENSE_KEY;
  ScreenForm := Self;
  FAdminMode := False;
  FPrepareSeconds := 0;
  FRemainSeconds := 0;
  FLastMainPageIndex := 0;
  FLastTeeBoxPlayMode := 0;

  PicShow.Proportional := True; //이미지 출력 시 비례항 사용
  with VideoPlayer do
  begin
    DoubleBuffered := True;
    Display_Embedded := True;
    Display_AspectRatio := ar_Stretch; //ar_PanScan; //ar_Box;
    TextOverlay_String := '';
    TextOverlay_Enabled := True;
  end;

  with pgcScreen do
  begin
    for I := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
    Width := Global.ScreenFormInfo.Width;
    Height := Global.ScreenFormInfo.Height;
  end;
  Self.Left := Global.ScreenFormInfo.Left;
  Self.Top := Global.ScreenFormInfo.Top;
  panRemainTime.Top := Global.ScreenFormInfo.RemainTop;
  panRemainTime.Left := Global.ScreenFormInfo.RemainLeft;

  if (not Global.BackgroundImageFile.IsEmpty) and
     FileExists(Global.ContentsDir + Global.BackgroundImageFile) then
    imgHome.Picture.LoadFromFile(Global.ContentsDir + Global.BackgroundImageFile)
  else
  begin
    if (Global.APIServer.Provider = SSP_ELOOM) then
      imgHome.Picture.Assign(DM.iciServiceProvider1.Picture)
    else
      imgHome.Picture.Assign(DM.iciServiceProvider0.Picture);
  end;

  FMediaPlayThread := TMediaPlayThread.Create(True, PicShow, VideoPlayer, Global.ContentsDir);
  FMediaPlayThread.OnChangeActive := OnChangeActiveMediaThread;
  FMediaPlayThread.OnChangeContent := OnChangeContentMediaThread;

  FTopMostCheckThread := TTopMostCheckThread.Create;
end;

procedure TScreenForm.FormShow(Sender: TObject);
begin
  if Assigned(FTopMostCheckThread) and
     (not FTopMostCheckThread.Started) then
  begin
    FTopMostCheckThread.Start;
    AddLog('Screen.TopMostCheckThread.Started');
  end;
end;

procedure TScreenForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Global.Closing;
end;

procedure TScreenForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PicShow.Stop;
  VideoPlayer.StopPlayer;
  VideoPlayer.ClosePlayer;
  if Assigned(FMediaPlayThread) then
    FMediaPlayThread.Terminate;
end;

function TScreenForm.GetRemainLeft: Integer;
begin
  if pgcScreen.Visible then
    Result := panRemainTime.Left
  else
    Result := Self.Left;
end;

function TScreenForm.GetRemainTop: Integer;
begin
  if pgcScreen.Visible then
    Result := panRemainTime.Top
  else
    Result := Self.Top;
end;

procedure TScreenForm.SetRemainLeft(const AValue: Integer);
begin
  if pgcScreen.Visible then
    panRemainTime.Left := AValue
  else
    Self.Left := AValue;
end;

procedure TScreenForm.SetRemainTop(const AValue: Integer);
begin
  if pgcScreen.Visible then
    panRemainTime.Top := AValue
  else
    Self.Top := AValue;
end;

procedure TScreenForm.SetScreenContents(const AContents: TList);
begin
  if Assigned(FMediaPlayThread) then
  begin
    FMediaPlayThread.Contents := AContents;
    if not FMediaPlayThread.Started then
      FMediaPlayThread.Start;
  end;
end;

procedure TScreenForm.SetTeeBoxPlayMode(const ATeeBoxPlayMode: Integer);
begin
  if (FTeeBoxPlayMode <> ATeeBoxPlayMode) then
  begin
    FTeeBoxPlayMode := ATeeBoxPlayMode;
    FMediaPlayThread.Active := False;

    case FTeeBoxPlayMode of
      TBS_TEEBOX_IDLE:
        begin
          ShowMediaPlayer(True);
          ShowRemainTime(False);
          if (not Global.Downloading) and
             (Global.MainContents.Count > 0) then
          begin
            pgcScreen.ActivePage := tabMedia;
            FMediaPlayThread.Active := True;
          end
          else
            pgcScreen.ActivePage := tabHome;
        end;
      TBS_TEEBOX_PREPARE,
      TBS_TEEBOX_START,
      TBS_TEEBOX_CHANGE:
        begin
          ShowMediaPlayer(False);
          ShowRemainTime(True);
        end;
      TBS_TEEBOX_STOP:
        begin
          pgcScreen.ActivePage := tabHome;
          ShowMediaPlayer(True);
          ShowRemainTime(False);
        end
    end;
  end;
end;

procedure TScreenForm.ShowMediaPlayer(const AShow: Boolean);
begin
  if AShow then
  begin
    Self.Top := Global.ScreenFormInfo.Top;
    Self.Left := Global.ScreenFormInfo.Left;
    Self.Width := Global.ScreenFormInfo.Width + 1;
    Self.Height := Global.ScreenFormInfo.Height + 1;
    panRemainTime.Top := Global.ScreenFormInfo.RemainTop;
    panRemainTime.Left := Global.ScreenFormInfo.RemainLeft;
    pgcScreen.Visible := True;
    MakeRoundedControl(Self, 0, 0);
  end
  else
  begin
    Self.Top := Global.ScreenFormInfo.Top + Global.ScreenFormInfo.RemainTop;
    Self.Left := Global.ScreenFormInfo.Left + Global.ScreenFormInfo.RemainLeft;
    Self.Width := panRemainTime.Width;
    Self.Height := panRemainTime.Height;
    panRemainTime.Top := 0;
    panRemainTime.Left := 0;
    pgcScreen.Visible := False;
    MakeRoundedControl(Self);
  end;
end;

procedure TScreenForm.ShowRemainTime(const AShow: Boolean);
begin
  //KAKAO-VX 모델만 잔여시각 표시
  panRemainTime.Visible := (Global.TeeBoxInfo.Vendor = GST_KAKAO_VX) and (AdminMode or AShow);
end;

procedure TScreenForm.SetActiveMediaPlay(const AValue: Boolean);
begin
  if Assigned(FMediaPlayThread) then
    FMediaPlayThread.Active := AValue;
end;

procedure TScreenForm.SetAdminMode(const AValue: Boolean);
begin
  if (FAdminMode <> AValue) then
  begin
    FAdminMode := AValue;
    FMediaPlayThread.Active := (not FAdminMode);
    if FAdminMode then
    begin
      Self.FormStyle := TFormStyle.fsNormal;
      panRemainTime.Color := CCN_COLOR_ADMIN;
      FLastMainPageIndex := pgcScreen.ActivePageIndex;
      FLastTeeBoxPlayMode := TeeBoxPlayMode;
      ShowRemainTime(True);
      ShowCursor(True);
    end
    else
    begin
{$IFDEF RELEASE}
      Self.FormStyle := TFormStyle.fsStayOnTop;
{$ENDIF}
      panRemainTime.Color := CCN_COLOR_NORMAL;
      pgcScreen.ActivePageIndex := FLastMainPageIndex;
      TeeBoxPlayMode := FLastTeeBoxPlayMode;
      ShowCursor(Global.ShowMouseCursor);
    end;
  end;
end;

procedure TScreenForm.SetPrepareSeconds(const APrepareSeconds: Integer);
begin
  if (FPrepareSeconds <> APrepareSeconds) then
  begin
    FPrepareSeconds := APrepareSeconds;
    if (TeeBoxPlayMode = TBS_TEEBOX_PREPARE) then
    begin
      panRemainTime.Font.Color := $0080FFFF;
      try
        panRemainTime.Caption := FormatDateTime('nn:ss', FPrepareSeconds / SecsPerDay);
      except
        on E: Exception do
          AddLog(Format('SetPrepareSeconds: 스크린 준비시간 설정 오류 = %d, SecsPerDay: %d', [FPrepareSeconds, SecsPerDay]));
      end;
    end;
  end;
end;

procedure TScreenForm.SetRemainSeconds(const ARemainSeconds: Integer);
var
  nRemainMin: Integer;
begin
  if (FRemainSeconds <> ARemainSeconds) then
  begin
    FRemainSeconds := ARemainSeconds;
    if (TeeBoxPlayMode = TBS_TEEBOX_STOP) then
    begin
      panRemainTime.Font.Color := $00EEEAEF;
      panRemainTime.Caption := '00:00';
    end
    else if (TeeBoxPlayMode = TBS_TEEBOX_START) then
    begin
      if (FRemainSeconds <= 300) then //5분 이하
        panRemainTime.Font.Color := $000005E9
      else
        panRemainTime.Font.Color := $00EEEAEF;

      try
        nRemainMin := FRemainSeconds div 60;
        if (nRemainMin >= 60) then //1시간 이상이면
          panRemainTime.Caption := Format('%d', [nRemainMin]) + FormatDateTime(':ss', FRemainSeconds / SecsPerDay)
        else
          panRemainTime.Caption := FormatDateTime('nn:ss', FRemainSeconds / SecsPerDay);
      except
        on E: Exception do
          AddLog(Format('SetRemainSeconds: 스크린 잔여시간 설정 오류 = %d, SecsPerDay: %d', [FRemainSeconds, SecsPerDay]));
      end;
    end;
  end;
end;

procedure TScreenForm.OnChangeActiveMediaThread(Sender: TObject);
begin
  with TMediaPlayThread(Sender) do
    AddLog('스크린 콘텐츠 재생 ' + IIF(Active, '시작', '중지'));
end;

procedure TScreenForm.OnChangeContentMediaThread(Sender: TObject);
var
  nIndex: Integer;
begin
  with TMediaPlayThread(Sender) do
  begin
    nIndex := TMediaPlayThread(Sender).ItemIndex;
    if (nIndex >= 0) then
      AddLog(Format('스크린 콘텐츠 변경 = %s (%d Secs.)', [PContentInfo(Contents[nIndex])^.FileName, PContentInfo(Contents[nIndex])^.PlayTime]));
  end;
end;

procedure TScreenForm.panRemainTimeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if AdminMode then
  begin
    ReleaseCapture;
    if pgcScreen.Visible then
      TWinControl(Sender as TObject).Perform(WM_SYSCOMMAND, $F012, 0)
    else
      Self.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TScreenForm.VideoPlayerLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
begin
//  Global.AddLog('Screen.VideoPlayer [' + Severity + '] ' + InfoMsg);
  if (LogType in [TLogType.e_failed, TLogType.e_failed_to_open_player]) then
    FMediaPlayThread.VideoPlaying := False;
end;

procedure TScreenForm.VideoPlayerPlayerStateChanged(Sender: TObject; OldPlayerState, NewPlayerState: TPlayerState);
begin
  if Assigned(FMediaPlayThread) and
     (OldPlayerState = ps_Playing) and ((NewPlayerState = ps_Paused) or (NewPlayerState = ps_Stopped)) then
    FMediaPlayThread.VideoPlaying := False;
end;

{ TTopMostCheckThread }

constructor TTopMostCheckThread.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FIntervalMilliSeconds := 3000;
  FLastWorked := Now;
end;

destructor TTopMostCheckThread.Destroy;
begin

  inherited;
end;

procedure TTopMostCheckThread.Execute;
begin
  inherited;

  repeat
    Synchronize(
      procedure
      begin
        if (not ScreenForm.AdminMode) and
           (MilliSecondsBetween(FLastWorked, Now) > FIntervalMilliSeconds) then
        begin
          FLastWorked := Now;
//          SetWindowPos(ScreenForm.Handle, HWND_TOPMOST, ScreenForm.Left, ScreenForm.Top, ScreenForm.Width, ScreenForm.Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
          SendMessage(ScreenForm.Handle, CWM_DO_TOPMOST, 0, 0);
        end;
      end);

    Sleep(1000);
  until Terminated;
end;

end.
