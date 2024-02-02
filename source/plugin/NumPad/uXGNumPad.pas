(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 숫자 패드
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGNumPad;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGNumPadForm = class(TPluginModule)
    panBody: TPanel;
    btnNum7: TAdvShapeButton;
    btnNum8: TAdvShapeButton;
    btnNum9: TAdvShapeButton;
    btnNumBS: TAdvShapeButton;
    btnNum4: TAdvShapeButton;
    btnNum5: TAdvShapeButton;
    btnNum6: TAdvShapeButton;
    btnNumCL: TAdvShapeButton;
    btnNum1: TAdvShapeButton;
    btnNum2: TAdvShapeButton;
    btnNum3: TAdvShapeButton;
    btnNum0: TAdvShapeButton;
    btnNum00: TAdvShapeButton;
    btnNum000: TAdvShapeButton;
    btnNumCR: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleCreate(Sender: TObject);
    procedure OnPadButtonClick(Sender: TObject);
  private
    { Private declarations }
    FTargetID: integer;
    FUseDotKey: boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  uXGClientDM, uXGGlobal, uXGCommonLib;

{$R *.dfm}

{ TNumPadForm }

constructor TXGNumPadForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FTargetID  := -1;
  FUseDotKey := False;
  SetDoubleBuffered(Self, True);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

procedure TXGNumPadForm.OnPadButtonClick(Sender: TObject);
var
  i, nKey, nRepeat: integer;
begin
  with TAdvShapeButton(Sender) do
  begin
    nKey    := Tag;
    nRepeat := HelpContext;
  end;

  if (nRepeat = 0) then
    nRepeat := 1;

  for i := 1 to nRepeat do
  begin
    SimulateKeyDown(nKey);
    SimulateKeyUp(nKey);
  end;
end;

destructor TXGNumPadForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGNumPadForm.PluginModuleCreate(Sender: TObject);
begin
//  KeybdHookStart;
end;

procedure TXGNumPadForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
//  KeybdHookStop;
  Action := caFree;
end;

procedure TXGNumPadForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FTargetID  := AMsg.ParamByInteger(CPP_OWNER_ID);
    FUseDotKey := AMsg.ParamByBoolean(CPP_USE_DOT_KEY);
    Self.Align := TAlign(AMsg.ParamByInteger(CPP_FORM_ALIGN));

    if FUseDotKey then
    begin
      btnNum000.Text        := '.';
      btnNum000.Tag         := 190;
      btnNum000.HelpContext := 0;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGNumPadForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.