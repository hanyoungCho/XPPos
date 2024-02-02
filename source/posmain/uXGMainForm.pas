(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 메인 폼
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGMainForm;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Controls, StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginMessages,
  { DevExpres }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton, Vcl.AppEvnts;

type
  TXGMainForm = class(TForm)
    tmrRunOnce: TTimer;
    btnClose: TAdvShapeButton;
    panOoops: TPanel;
    imgOoops: TImage;
    Label1: TLabel;
    btnBackToHome: TButton;
    imgLogo: TImage;
    AppEvents: TApplicationEvents;

    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBackToHomeClick(Sender: TObject);
    procedure AppEventsException(Sender: TObject; E: Exception);
  private
    { Private declarations }
  protected
    FCanClose: Boolean;
    FClosing: Boolean;
  public
    { Public declarations }
  end;

var
  XGMainForm: TXGMainForm;

implementation

{$R *.dfm}

uses
  Dialogs, ShlObj, ComObj, ActiveX,
  uXGGlobal, uXGCommonLib, uXGClientDM, uXGSaleManager;

procedure TXGMainForm.FormCreate(Sender: TObject);
{$IFDEF RELEASE}
var
  sLinkFile: string;
  hIObject: IUnknown;
  hISLink: IShellLink;
  hIPFile: IPersistFile;
{$ENDIF}
//  RS: TResourceStream;
//  HC: HCURSOR;
begin
//  { Using Animation Type Cursor }
//  RS := TResourceStream.Create(MainInstance, 'XPartners_HourGlass', 'ANICURSOR');
//  try
//    HC := CreateIconFromResourceEx(RS.Memory, RS.Size, False, $30000, 100, 100, LR_DEFAULTCOLOR);
//    Win32Check(HC <> 0);
//    Screen.Cursors[crDrag] := HC;
//  finally
//    RS.Free;
//  end;
  Screen.Cursors[crDrag] := LoadCursor(HInstance,'XPartners_DragDrop');

{$IFDEF RELEASE}
  sLinkFile := GetSysDir(CSIDL_DESKTOP) + '\엑스파트너스 POS.lnk';
  if not FileExists(sLinkFile) then
  begin
    hIObject := CreateComObject(CLSID_ShellLink);
    hISLink := hIObject as IShellLink;
    hIPFile := hIObject as IPersistFile;
    with hISLink do
    begin
      //SetArguments('/run');
      //SetPath(PChar(GetSysDir(36) + '실행파일명'));
      //SetWorkingDirectory(PChar(GetSysDir(36)));
      SetPath(PChar(Global.HomeDir + 'XGLauncher.exe'));
      SetWorkingDirectory(PChar(Global.HomeDir));
    end;
    hIPFile.Save(PChar(sLinkFile), False);
  end;
{$ENDIF}

  SetDoubleBuffered(Self, True);
  Global.ProductVersion := GetAppVersion(2); //8
  Global.FileVersion := GetAppVersion(2);
  Global.MainFormHandle := Self.Handle;

  //화면보호기 중지
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);
  //작업표시줄 감출
  if Global.HideTaskBar then
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);
  //화면 커서 감춤
  if Global.HideCursor then
    ShowCursor(False);

  Self.OnActivate := nil;
  Self.OnDeactivate := nil;
  Self.Top := 0;
  Self.Left := 0;
  Self.Width := Global.ScreenInfo.BaseWidth;
  Self.Height := Global.ScreenInfo.BaseHeight;

  btnClose.Left := (Self.Width - 50);
  panOoops.Top := (Self.Height div 2) - (panOoops.Height div 2);
  panOoops.Left := (Self.Width div 2) - (panOoops.Width div 2);
  panOoops.Visible := False;
  imgLogo.Top := (Self.Height div 2) - (imgLogo.Height div 2);
  imgLogo.Left := (Self.Width div 2) - (imgLogo.Width div 2);
  imgLogo.Visible := False;

  UpdateLog(Global.LogFile, '프로그램 시작');
  tmrRunOnce.Enabled := True;
end;

procedure TXGMainForm.FormActivate(Sender: TObject);
begin
  imgLogo.Visible := False;
  panOoops.Visible := True;
end;

procedure TXGMainForm.FormDeactivate(Sender: TObject);
begin
  panOoops.Visible := False;
  imgLogo.Visible := True;
end;

procedure TXGMainForm.FormDestroy(Sender: TObject);
begin
  UpdateLog(Global.LogFile, '프로그램 종료');

  ShowCursor(True);
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, nil, 0);
  ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOW);
end;

procedure TXGMainForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    try
      Enabled := False;
      Global.StartModuleID := PluginManager.Open(Global.PluginConfig.StartModule).PluginId;
      imgLogo.Visible := True;
    finally
      Self.OnActivate := FormActivate;
      Self.OnDeactivate := FormDeactivate;
      Free;
    end;
  except
    on E: Exception do
    begin
      imgLogo.Visible := False;
      panOoops.Visible := True;
    end;
  end;
end;

procedure TXGMainForm.AppEventsException(Sender: TObject; E: Exception);
begin
  if Assigned(Global) then
    UpdateLog(Global.LogFile, Format('Application.Exception = %s', [E.Message]));
end;

procedure TXGMainForm.btnBackToHomeClick(Sender: TObject);
begin
  if (Global.StartModuleId > 0) then
    with TPluginMessage.Create(nil) do
    try
      Command := CPC_SET_FOREGROUND;
      PluginMessageToID(Global.StartModuleId);
    finally
      Free;
    end;
end;

procedure TXGMainForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
  Global := TGlobal.Create;
  ClientDM := TClientDM.Create(nil);
  SaleManager := TSaleManager.Create;
finalization
  SaleManager.Free;
  ClientDM.Free;
  Global.Free;
  CheckSynchronize;
end.
