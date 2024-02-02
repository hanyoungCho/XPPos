(*******************************************************************************

  Project     : ���Ͽ�Ŀ�´�Ƽ �����νı� ���� ����
  Author      : �̼���
  Description :
  Essentials  : �Ʒ� ���ϵ��� ���α׷� ���� ������ �ݵ�� �����Ͽ��� ��.
    - UCBioBSP.dll
    - UCBioBSPCOM.dll --> regsvr32�� ���� ���
    - UCBioBSPSkin_Kor.dll
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.3.0.0   2020-11-26   Added ValueClear.
    1.2.0.0   2020-09-21   Added MatchingValue.
    1.0.0.0   2020-07-06   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
unit uUCBioBSPHelper;

interface

uses
  Classes, SysUtils, ExtCtrls, Windows, DB;

type
  TUCBioBSPOnCaptureEvent = procedure(Sender: TObject; Quality: Integer) of object;

  TUCBioBSPHelper = class
  private
    FUCBioBSP: Variant;
    FDevice: Variant;
    FExtraction: Variant;
    FFPData: Variant;
    FMatching: Variant;
    FFastSearch: Variant;
    FOnCaptureEvent: TUCBioBSPOnCaptureEvent;

    FActive: Boolean;
    FDataSet: TDataSet; //���� �˻��� �����ͼ�
    FFingerFieldName: string; //���� ���� �ʵ��
    FValueFieldName: string; //���� ��Ī �� ��ȯ�� �ʵ��
    FFingerWindow: Integer; //���� �̹��� ��¿� �ܺ� ��Ʈ�� �ڵ�(0�̸� ��� ����)
    FScanQuality: Integer; //���� ��ĵ ǰ�� ����
    FEnrollQuality: Integer; //���� ���� ǰ�� ����
    FIdentifyQuality: Integer; //���� �ν� ǰ�� ����
    FVerifyQuality: Integer; //���� �� ǰ�� ����
    FSecurityLevel: Integer; //���� ���� ���� ����
    FDefaultTimeout: Integer; //���� �ν� Ÿ�Ӿƿ� ����
    FAutoDetectFinger: Boolean; //�ڵ� ���� �ν�
    FFIR: string; //���� �ν� ���ڵ� ��(���̳ʸ�)
    FTextFIR: string; //���� �ν� ���ڵ� ��
    FMatchValue: string; //���� ��Ī �� ��ȯ�� ������ �ʵ� ��
    FSuccess: Boolean; //���� ó�� ���
    FCaptureQuality: Integer; //���� ĸ�� ��� ǰ��
    FLastError: Integer; //���� ���� �ڵ�
    FErrorMessage: string; //���� ���� �޽���

    function InitOption: Boolean;
    procedure ValueClear;
    function GetParentWindow: Integer;
    function GetFingerWindow: Integer;
    procedure SetFingerWindow(const AValue: Integer);
  public
    constructor Create; overload;
    constructor Create(const AScanQuality, AEnrollQuality, AIdentifyQuality, AVerifyQuality,
      ASecurityLevel, ADefaultTimeout: Integer; const AAutoDetectFinger: Boolean=False); overload;
    destructor Destroy; override;

    function Capture: Boolean; overload; //���� ĸ��
    function Capture(const AFingerWindow: HWND; var AErrMsg: string): Boolean; overload; //���� ĸ��
    procedure ClearUserList; //FastSearch ����DB �ʱ�ȭ
    function AddUser(const ATextFIR: string; const AUserId: Integer; var AErrMsg: string): Boolean; //FastSearch ����DB ���� �߰�
    function RemoveUser(const AUserId: Integer; var AErrMsg: string): Boolean; //FastSearch ����DB ���� ����
    function Matching(const ATextFIR: string; var AUserId: Integer; var AErrMsg: string): Boolean; overload; //FastSearch ����DB ��Ī
    function Matching: Boolean; overload; //Dataset ���� ��Ī ��ȸ
    function Matching(const AFingerWindow: HWND; ADataSet: TDataSet; const AFingerField, AValueField: string; var AErrMsg: string): Boolean; overload; //Dataset ���� ��Ī ��ȸ

    property Active: Boolean read FActive write FActive default False;
    property Success: Boolean read FSuccess write FSuccess default False;
    property ParentWindow: Integer read GetParentWindow default 0;
    property FingerWindow: Integer read GetFingerWindow write SetFingerWindow default 0;
    property CaptureQuality: Integer read FScanQuality write FScanQuality default 0;
    property ScanQuality: Integer read FScanQuality write FScanQuality default 0;
    property EnrollQuality: Integer read FEnrollQuality write FEnrollQuality default 90;
    property IdentifyQuality: Integer read FIdentifyQuality write FIdentifyQuality default 90;
    property VerifyQuality: Integer read FVerifyQuality write FVerifyQuality default 50;
    property SecurityLevel: Integer read FSecurityLevel write FSecurityLevel default 9; // (1 < 9)
    property DefaultTimeout: Integer read FDefaultTimeout write FDefaultTimeout default 10000; // 0 for Unlimited
    property AutoDetectFinger: Boolean read FAutoDetectFinger write FAutoDetectFinger default False;
    property FIR: string read FFIR;
    property TextFIR: string read FTextFIR write FTextFIR;
    property MatchValue: string read FMatchValue write FMatchValue;
    property LastError: Integer read FLastError write FLastError;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property FingerFieldName: string read FFingerFieldName write FFingerFieldName;
    property ValueFieldName: string read FValueFieldName write FValueFieldName;
    property OnCaptureEvent: TUCBioBSPOnCaptureEvent read FOnCaptureEvent write FOnCaptureEvent;
  end;

implementation

uses
  ComObj, Variants, Dialogs, uUCBioAPI_Type;

{ TUCBioBSPHelper }

constructor TUCBioBSPHelper.Create;
begin
  FCaptureQuality := 0;
  FScanQuality := 0;
  FEnrollQuality := 90;
  FIdentifyQuality := 90;
  FVerifyQuality := 50;
  FSecurityLevel := 9;
  FDefaultTimeout := 10000;
  FAutoDetectFinger := False;

  Create(FScanQuality, FEnrollQuality, FIdentifyQuality, FVerifyQuality, FSecurityLevel, FDefaultTimeout);
end;

constructor TUCBioBSPHelper.Create(const AScanQuality, AEnrollQuality, AIdentifyQuality, AVerifyQuality,
  ASecurityLevel, ADefaultTimeout: Integer; const AAutoDetectFinger: Boolean);
begin
  inherited Create;

  FUCBioBSP := CreateOleObject('UCBioBSPCOM.UCBioBSP');
  FDevice := FUCBioBSP.Device;
  FExtraction := FUCBioBSP.Extraction;
  FFPData := FUCBioBSP.FPData;
  FMatching := FUCBioBSP.Matching;
  FFastSearch := FUCBioBSP.FastSearch;

  ScanQuality := AScanQuality;
  EnrollQuality := AEnrollQuality;
  IdentifyQuality := AIdentifyQuality;
  VerifyQuality := AVerifyQuality;
  SecurityLevel := ASecurityLevel;
  DefaultTimeout := ADefaultTimeout;
  AutoDetectFinger := AAutoDetectFinger;

  try
    FUCBioBSP.SetSkinResource('UCBioBSPSkin_Kor.dll');
    Active := InitOption;
  except
    on E: Exception do
      ErrorMessage := E.Message;
  end;
end;

destructor TUCBioBSPHelper.Destroy;
begin
  FFastSearch := 0;
  FMatching := 0;
  FExtraction := 0;
  FFPData := 0;
  FDevice := 0;
  FUCBioBSP := 0;

  inherited;
end;

function TUCBioBSPHelper.InitOption: Boolean;
begin
  Result := False;
  ValueClear;

  try
    FUCBioBSP.SecurityLevelForEnroll := SecurityLevel;
    FUCBioBSP.SecurityLevelForVerify := SecurityLevel;
    FUCBioBSP.SecurityLevelForIdentify := SecurityLevel;
    FUCBioBSP.SetCaptureQuality(ScanQuality, EnrollQuality, VerifyQuality, IdentifyQuality);
    FUCBioBSP.DefaultTimeout := DefaultTimeout;
    if AutoDetectFinger then
      FDevice.SetAutoDetect(UCBioAPI_TRUE)
    else
      FDevice.SetAutoDetect(UCBioAPI_FALSE);

    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('���� �ν���ġ �ʱ�ȭ�� �����Ͽ����ϴ�.' + #13#10 + FUCBioBSP.ErrorDescription);

    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      ShowMessage(Format('Error #%d - %s', [LastError, ErrorMessage]));
    end;
  end;
end;

procedure TUCBioBSPHelper.ValueClear;
begin
  Success := False;
  TextFIR := '';
  MatchValue := '';
  ErrorMessage := '';
  LastError := UCBioAPIERROR_NONE;
end;

function TUCBioBSPHelper.GetParentWindow: Integer;
begin
  Result := FUCBioBSP.ParentWnd;
end;

function TUCBioBSPHelper.GetFingerWindow: Integer;
begin
  Result := FUCBioBSP.FingerWnd;
end;

procedure TUCBioBSPHelper.SetFingerWindow(const AValue: Integer);
begin
  FFingerWindow := AValue;
  if (FFingerWindow = 0) then
  begin
    FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_POPUP;
    FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_FPIMG] := UCBioAPI_FALSE;
    FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_WELCOME] := UCBioAPI_TRUE;
  end else
  begin
    FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_INVISIBLE;
    FUCBioBSP.FingerWnd := FFingerWindow;
  end;
end;

function TUCBioBSPHelper.Capture: Boolean;
var
  sErrMsg: string;
begin
  Result := Capture(FingerWindow, sErrMsg);
end;
function TUCBioBSPHelper.Capture(const AFingerWindow: HWND; var AErrMsg: string): Boolean;
begin
  Result := False;
  ValueClear;
  if not Active then
    Exit;

  FingerWindow := AFingerWindow;
  try
    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      LastError := FDevice.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('���� �ν���ġ�� ����� �� �����ϴ�.' + #13#10 + FDevice.ErrorDescription);

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      LastError := FExtraction.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('������ �ν����� ���߽��ϴ�.' + #13#10 + FExtraction.ErrorDescription);

      FTextFIR := FExtraction.TextFIR;
//      FFPData.Export(FTextFIR, 400);
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('������ �������� ���߽��ϴ�.' + #13#10 + FExtraction.ErrorDescription);

      Success := True;
      Result := True;
    finally
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      AErrMsg := ErrorMessage;
    end;
  end;
end;

procedure TUCBioBSPHelper.ClearUserList;
begin
  FFastSearch.ClearDB;
end;

function TUCBioBSPHelper.AddUser(const ATextFIR: string; const AUserId: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    FFastSearch.AddFIR(ATextFIR, AUserId);
    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('FastSearch ���� ��Ͽ� �����Ͽ����ϴ�.' + #13#10 + FUCBioBSP.ErrorDescription);
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TUCBioBSPHelper.RemoveUser(const AUserId: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    FFastSearch.RemoveUser(AUserId);
    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('FastSearch ���� ������ �����Ͽ����ϴ�.' + #13#10 + FUCBioBSP.ErrorDescription);
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TUCBioBSPHelper.Matching(const ATextFIR: string; var AUserId: Integer; var AErrMsg: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  AUserId := -1;
  AErrMsg := '';
  try
    FFastSearch.RemoveUser(AUserId);
    FFastSearch.IdentifyUser(ATextFIR, SecurityLevel);
    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('FastSearch ���� �˻��� �����Ͽ����ϴ�.' + #13#10 + FUCBioBSP.ErrorDescription);

    for I := 0 to FFastSearch.AddedFpCount - 1 do
      FFastSearch.AddedFpInfo[I];

    AUserId := FFastSearch.MatchedFpInfo.UserID;
    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('FastSearch ���� �˻��� �����Ͽ����ϴ�.' + #13#10 + FUCBioBSP.ErrorDescription);

    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TUCBioBSPHelper.Matching: Boolean;
var
  sErrMsg: string;
begin
  Result := Matching(FingerWindow, DataSet, FingerFieldName, ValueFieldName, sErrMsg);
end;

function TUCBioBSPHelper.Matching(const AFingerWindow: HWND; ADataSet: TDataSet; const AFingerField, AValueField: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  ValueClear;
  if not Active then
    Exit;

  FingerWindow := AFingerWindow;
  try
    if not ADataSet.Active then
      raise Exception.Create('���� �����͸� ����� �� �����ϴ�.');
    if (ADataSet.FieldDefs.IndexOf(AFingerField) < 0) then
      raise Exception.Create('���� �����Ϳ��� ����� �� ���� �ʵ���� �����Ǿ����ϴ�.');
    if (ADataSet.RecordCount = 0) then
      raise Exception.Create('�˻� ������ ���� �����Ͱ� �����ϴ�.');

    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      LastError := FDevice.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('���� �ν���ġ�� ����� �� �����ϴ�.');

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      LastError := FExtraction.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('������ �ν����� ���߽��ϴ�.' + #13#10 + FExtraction.ErrorDescription);
    finally
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;

    TextFIR := FExtraction.TextFIR;
    with ADataSet do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        if not FieldByName(AFingerField).AsString.IsEmpty then
        begin
          FMatching.VerifyMatch(TextFIR, FieldByName(AFingerField).AsString);
          if (VarToStr(FMatching.MatchingResult) = IntToStr(UCBioAPI_TRUE)) then
          begin
            if (ADataSet.FieldDefs.IndexOf(AValueField) >= 0) then
              MatchValue := FieldByName(AValueField).AsString;
            Success := True;
            Break;
          end;
        end;

        Next;
      end;

      Result := True;
      if not Success then
        ErrorMessage := '��ġ�ϴ� ������ ã�� �� �����ϴ�.';
    finally
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      AErrMsg := ErrorMessage;
    end;
  end;
end;

end.
