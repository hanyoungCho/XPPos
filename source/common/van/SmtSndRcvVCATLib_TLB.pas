unit SmtSndRcvVCATLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 2016-03-10 오후 4:29:57 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Work\Van\Bin\SmtSndRcvVCAT.ocx (1)
// LIBID: {0570C2F5-35A3-41ED-B231-276F8DE34592}
// LCID: 0
// Helpfile: C:\Work\Van\Bin\SmtSndRcvVCAT.hlp 
// HelpString: SmtSndRcvVCAT ActiveX ��Ʈ�� ���
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleCtrls, Vcl.OleServer, Winapi.ActiveX;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SmtSndRcvVCATLibMajorVersion = 1;
  SmtSndRcvVCATLibMinorVersion = 0;

  LIBID_SmtSndRcvVCATLib: TGUID = '{0570C2F5-35A3-41ED-B231-276F8DE34592}';

  DIID__DSmtSndRcvVCAT: TGUID = '{7471834B-C00F-4C7D-9746-E76DE95E7AB6}';
  DIID__DSmtSndRcvVCATEvents: TGUID = '{1056DB33-3262-4300-B741-D48ACF94BDD5}';
  CLASS_SmtSndRcvVCAT: TGUID = '{39404B74-B24B-4445-834D-45A323B02FC1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DSmtSndRcvVCAT = dispinterface;
  _DSmtSndRcvVCATEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SmtSndRcvVCAT = _DSmtSndRcvVCAT;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// DispIntf:  _DSmtSndRcvVCAT
// Flags:     (4096) Dispatchable
// GUID:      {7471834B-C00F-4C7D-9746-E76DE95E7AB6}
// *********************************************************************//
  _DSmtSndRcvVCAT = dispinterface
    ['{7471834B-C00F-4C7D-9746-E76DE95E7AB6}']
    procedure AboutBox; dispid -552;
    function PosToVCATSndRcv(const szIP: WideString; nPort: Integer; iTimeout: Integer): Integer; dispid 1;
    procedure InitData; dispid 2;
    function SetTRData(iIndex: Smallint; const szData: WideString): Integer; dispid 3;
    function GetResDataCount(iCount: Smallint; iType: Smallint): WideString; dispid 4;
    function SendToVCat(const szIP: WideString; nPort: Integer; iTimeout: Integer): Smallint; dispid 5;
    function BmpToEncSign(const ucaWorkKey: WideString; const ucIndex: WideString; 
                          const ucaBmpPath: WideString; const ucpHashData: OleVariant; 
                          const ucpEncSignData: OleVariant): Integer; dispid 6;
    function GetExitErrorCode: Integer; dispid 7;
  end;

// *********************************************************************//
// DispIntf:  _DSmtSndRcvVCATEvents
// Flags:     (4096) Dispatchable
// GUID:      {1056DB33-3262-4300-B741-D48ACF94BDD5}
// *********************************************************************//
  _DSmtSndRcvVCATEvents = dispinterface
    ['{1056DB33-3262-4300-B741-D48ACF94BDD5}']
    procedure OnTermExit; dispid 1;
    procedure OnTermComplete; dispid 2;
    procedure OnRcvState(const szType: OleVariant); dispid 3;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSmtSndRcvVCAT
// Help String      : SmtSndRcvVCAT Control
// Default Interface: _DSmtSndRcvVCAT
// Def. Intf. DISP? : Yes
// Event   Interface: _DSmtSndRcvVCATEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TSmtSndRcvVCATOnRcvState = procedure(ASender: TObject; const szType: OleVariant) of object;

  TSmtSndRcvVCAT = class(TOleControl)
  private
    FOnTermExit: TNotifyEvent;
    FOnTermComplete: TNotifyEvent;
    FOnRcvState: TSmtSndRcvVCATOnRcvState;
    FIntf: _DSmtSndRcvVCAT;
    function  GetControlInterface: _DSmtSndRcvVCAT;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    function PosToVCATSndRcv(const szIP: WideString; nPort: Integer; iTimeout: Integer): Integer;
    procedure InitData;
    function SetTRData(iIndex: Smallint; const szData: WideString): Integer;
    function GetResDataCount(iCount: Smallint; iType: Smallint): WideString;
    function SendToVCat(const szIP: WideString; nPort: Integer; iTimeout: Integer): Smallint;
    function BmpToEncSign(const ucaWorkKey: WideString; const ucIndex: WideString; 
                          const ucaBmpPath: WideString; const ucpHashData: OleVariant; 
                          const ucpEncSignData: OleVariant): Integer;
    function GetExitErrorCode: Integer;
    property  ControlInterface: _DSmtSndRcvVCAT read GetControlInterface;
    property  DefaultInterface: _DSmtSndRcvVCAT read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property OnTermExit: TNotifyEvent read FOnTermExit write FOnTermExit;
    property OnTermComplete: TNotifyEvent read FOnTermComplete write FOnTermComplete;
    property OnRcvState: TSmtSndRcvVCATOnRcvState read FOnRcvState write FOnRcvState;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

procedure TSmtSndRcvVCAT.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID:      '{39404B74-B24B-4445-834D-45A323B02FC1}';
    EventIID:     '{1056DB33-3262-4300-B741-D48ACF94BDD5}';
    EventCount:   3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey:   nil (*HR:$80004005*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := UIntPtr(@@FOnTermExit) - UIntPtr(Self);
end;

procedure TSmtSndRcvVCAT.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DSmtSndRcvVCAT;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSmtSndRcvVCAT.GetControlInterface: _DSmtSndRcvVCAT;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TSmtSndRcvVCAT.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function TSmtSndRcvVCAT.PosToVCATSndRcv(const szIP: WideString; nPort: Integer; iTimeout: Integer): Integer;
begin
  Result := DefaultInterface.PosToVCATSndRcv(szIP, nPort, iTimeout);
end;

procedure TSmtSndRcvVCAT.InitData;
begin
  DefaultInterface.InitData;
end;

function TSmtSndRcvVCAT.SetTRData(iIndex: Smallint; const szData: WideString): Integer;
begin
  Result := DefaultInterface.SetTRData(iIndex, szData);
end;

function TSmtSndRcvVCAT.GetResDataCount(iCount: Smallint; iType: Smallint): WideString;
begin
  Result := DefaultInterface.GetResDataCount(iCount, iType);
end;

function TSmtSndRcvVCAT.SendToVCat(const szIP: WideString; nPort: Integer; iTimeout: Integer): Smallint;
begin
  Result := DefaultInterface.SendToVCat(szIP, nPort, iTimeout);
end;

function TSmtSndRcvVCAT.BmpToEncSign(const ucaWorkKey: WideString; const ucIndex: WideString; 
                                     const ucaBmpPath: WideString; const ucpHashData: OleVariant; 
                                     const ucpEncSignData: OleVariant): Integer;
begin
  Result := DefaultInterface.BmpToEncSign(ucaWorkKey, ucIndex, ucaBmpPath, ucpHashData, 
                                          ucpEncSignData);
end;

function TSmtSndRcvVCAT.GetExitErrorCode: Integer;
begin
  Result := DefaultInterface.GetExitErrorCode;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TSmtSndRcvVCAT]);
end;

end.
