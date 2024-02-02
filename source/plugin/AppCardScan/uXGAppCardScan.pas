(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 앱카드 바코드 스캔
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2020-03-09   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGAppCardScan;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Vcl.Imaging.pngimage,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGAppCardScanForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    imgFinger: TImage;
    lblMessage: TLabel;
    lblScanResult: TLabel;
    btnCancel: TAdvShapeButton;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ComPortRxCharBarcodeScanner(Sender: TObject);
(*
    function BCAppCardQrBinData(AReadData: string): string;
    function BytesToHex(AByte: Byte): string;
*)
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, ComPort, EncdDecd,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGMsgBox, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGAppCardScanForm }

constructor TXGAppCardScanForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  nComPort, nBaudrate: Integer;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  nComPort := 0;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  with Global.DeviceConfig.BarcodeScanner do
  try
    ReadData := '';
    if Enabled then
    begin
      if not Assigned(ComDevice) then
        ComDevice := TComPort.Create(nil);
      ComDevice.Close;
      nComPort := Port;
      nBaudrate := Baudrate;
      if (nComPort >= 10) then
        ComDevice.DeviceName := '\\.\COM' + IntToStr(nComPort)
      else
        ComDevice.DeviceName := 'COM' + IntToStr(nComPort);
      ComDevice.BaudRate := GetBaudRate(nBaudrate);
      ComDevice.Parity := TParity.paNone;
      ComDevice.DataBits := TDataBits.db8;
      ComDevice.StopBits := TStopBits.sb1;
      ComDevice.OnRxChar := ComPortRxCharBarcodeScanner;
      ComDevice.Open;
    end;
  except
    on E: Exception do
    begin
      XGMsgBox(Self.Handle, mtError, '알림',
        Format('바코드 스캐너(port=%d) 장치를 사용할 수 없습니다!', [nComPort]) + _CRLF +
        E.Message, ['확인'], 5);
    end;
  end;
end;

destructor TXGAppCardScanForm.Destroy;
begin

  inherited Destroy;
end;

procedure TXGAppCardScanForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGAppCardScanForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGAppCardScanForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

(*
function TXGAppCardScanForm.BCAppCardQrBinData(AReadData: string): string;
var
  ABytes: TBytes;
begin
  Result := EmptyStr;
  ABytes := EncdDecd.DecodeBase64(AReadData);
  if Length(ABytes) > 30 then
  begin
    if (BytesToHex(ABytes[18]) + BytesToHex(ABytes[19])) = '5713' then
      Result := BytesToHex(ABytes[20]) + BytesToHex(ABytes[21]) + BytesToHex(ABytes[22]);
  end;
end;

function TXGAppCardScanForm.BytesToHex(AByte: Byte): string;
begin
  Result := EmptyStr;
  Result := IntToHex(AByte, 2);
  Result := Trim(Result);
end;

*)

procedure TXGAppCardScanForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGAppCardScanForm.ComPortRxCharBarcodeScanner(Sender: TObject);
var
  PM: TPluginMessage;
  sBuffer, sReadData: string;
  nBuffer: Integer;
begin
  with TComPort(Sender) do
  begin
    sBuffer := ReadAnsiString;
    nBuffer := Length(sBuffer);
    if (nBuffer = 0) then
      Exit;

    Global.DeviceConfig.BarcodeScanner.ReadData := Global.DeviceConfig.BarcodeScanner.ReadData + sBuffer;
    if (sBuffer[nBuffer] = _CR) then
    begin
      sReadData := StringReplace(Global.DeviceConfig.BarcodeScanner.ReadData, _CR, '', [rfReplaceAll]);
      Global.DeviceConfig.BarcodeScanner.ReadData := '';
      lblScanResult.Caption := sReadData;
      UpdateLog(Global.LogFile, Format('바코드(OTC) 스캔 : %s', [sReadData]));

      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_SEND_SCAN_DATA;
        PM.AddParams(CPP_BARCODE, sReadData);
        PM.PluginMessageToID(Global.DeviceConfig.BarcodeScanner.OwnerId);
      finally
        FreeAndNil(PM);
      end;
      ModalResult := mrOK;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGAppCardScanForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.