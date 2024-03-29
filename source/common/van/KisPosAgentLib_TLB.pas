unit KisPosAgentLib_TLB;

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
// File generated on 2019-07-01 오전 11:46:04 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files (x86)\KisAgent\KisPosAgent.ocx (1)
// LIBID: {A18CEB87-C381-47F0-91E7-B93ED817E1C4}
// LCID: 0
// Helpfile: C:\Program Files (x86)\KisAgent\KisPosAgent.hlp 
// HelpString: KisPosAgent ActiveX ��Ʈ�� ���
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
  KisPosAgentLibMajorVersion = 1;
  KisPosAgentLibMinorVersion = 0;

  LIBID_KisPosAgentLib: TGUID = '{A18CEB87-C381-47F0-91E7-B93ED817E1C4}';

  DIID__DKisPosAgent: TGUID = '{CCB08D51-0FB8-4E28-8244-B5C22724685A}';
  DIID__DKisPosAgentEvents: TGUID = '{BBCDEB1E-EC7E-4AA6-B709-369068893B90}';
  CLASS_KisPosAgent: TGUID = '{74091A7F-FD8C-4440-96A2-CB2EB8BAD896}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DKisPosAgent = dispinterface;
  _DKisPosAgentEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  KisPosAgent = _DKisPosAgent;


// *********************************************************************//
// DispIntf:  _DKisPosAgent
// Flags:     (4096) Dispatchable
// GUID:      {CCB08D51-0FB8-4E28-8244-B5C22724685A}
// *********************************************************************//
  _DKisPosAgent = dispinterface
    ['{CCB08D51-0FB8-4E28-8244-B5C22724685A}']
    property inAgentIP: WideString dispid 1;
    property inAgentPort: Smallint dispid 2;
    property inTranCode: WideString dispid 3;
    property inInstallment: WideString dispid 4;
    property inTranAmt: WideString dispid 5;
    property inVatAmt: WideString dispid 6;
    property inSvcAmt: WideString dispid 7;
    property inOrgAuthDate: WideString dispid 8;
    property inOrgAuthNo: WideString dispid 9;
    property inTranGubun: WideString dispid 10;
    property outCatId: WideString dispid 11;
    property outReplyCode: WideString dispid 12;
    property outWCC: WideString dispid 13;
    property outCardNo: WideString dispid 14;
    property outInstallment: WideString dispid 15;
    property outTranAmt: WideString dispid 16;
    property outVatAmt: WideString dispid 17;
    property outSvcAmt: WideString dispid 18;
    property outJanAmt: WideString dispid 19;
    property outAuthNo: WideString dispid 20;
    property outReplyDate: WideString dispid 21;
    property outOrgAuthDate: WideString dispid 22;
    property outOrgAuthNo: WideString dispid 23;
    property outAccepterCode: WideString dispid 24;
    property outAccepterName: WideString dispid 25;
    property outIssuerCode: WideString dispid 26;
    property outIssuerName: WideString dispid 27;
    property outMerchantRegNo: WideString dispid 28;
    property outTranNo: WideString dispid 29;
    property outRtn: Smallint dispid 30;
    property outReplyMsg1: WideString dispid 31;
    property outReplyMsg2: WideString dispid 32;
    property inPrintYN: WideString dispid 35;
    property inCashAuthId: WideString dispid 36;
    property inSignYN: WideString dispid 37;
    property inSignFileName: WideString dispid 38;
    property inCatId: WideString dispid 39;
    property inCheckNumber: WideString dispid 40;
    property inCheckIssueDate: WideString dispid 41;
    property inCheckType: WideString dispid 42;
    property inCheckAccountNo: WideString dispid 43;
    property outAddedPoint: WideString dispid 44;
    property outUsablePoint: WideString dispid 45;
    property outTotalPoint: WideString dispid 46;
    property inShinsegaeIP: WideString dispid 48;
    property inShinsegaePort: WideString dispid 49;
    property inShinsegaeSpec: WideString dispid 50;
    property outShinsegaeSpec: WideString dispid 51;
    property outTradeNum: WideString dispid 52;
    property outTradeReqTime: WideString dispid 53;
    property outTradeReqDate: WideString dispid 54;
    property inTradeReqDate: WideString dispid 55;
    property inTradeReqTime: WideString dispid 56;
    property inTradeNum: WideString dispid 57;
    property inOilInfo: WideString dispid 58;
    property inReaderType: WideString dispid 59;
    property inBarCodeNumber: WideString dispid 61;
    property inVanKeyYN: WideString dispid 62;
    property outVanKey: WideString dispid 63;
    property inVanKey: WideString dispid 64;
    property outTranGubun: WideString dispid 65;
    property inOilYN: WideString dispid 66;
    property inDefaultCatIdYN: WideString dispid 67;
    property inCurrencyCode: WideString dispid 68;
    property outBrandGubun: WideString dispid 69;
    property outLocalCode: WideString dispid 70;
    property outLocalCodeNumber: WideString dispid 71;
    property outLocalAmount: WideString dispid 72;
    property outLocalAmountMinor: WideString dispid 73;
    property outExchangeRate: WideString dispid 74;
    property outExchangeRateMinor: WideString dispid 75;
    property outInvertedRate: WideString dispid 76;
    property outInvertedRateMinor: WideString dispid 77;
    property outInvertedRateDisplayUnit: WideString dispid 78;
    property outMarkupPercentage: WideString dispid 79;
    property outMarkupPercentageDisplayUnit: WideString dispid 80;
    property outCommissionPercentage: WideString dispid 81;
    property outCommissionPercentageMinor: WideString dispid 82;
    property outCommissionNumber: WideString dispid 83;
    property outCommissionAmount: WideString dispid 84;
    property outCommissionAmountMinor: WideString dispid 85;
    property outServiceProvider: WideString dispid 86;
    property inInvertedRate: WideString dispid 87;
    property inInvertedRateMinor: WideString dispid 88;
    property inLocalCode: WideString dispid 89;
    property inLocalAmount: WideString dispid 90;
    property inLocalAmountMinor: WideString dispid 91;
    property inInvertedRateDisplayUnit: WideString dispid 92;
    property inLocalCodeNumber: WideString dispid 93;
    property inExchangeRate: WideString dispid 94;
    property inExchangeRateMinor: WideString dispid 95;
    property inMarkupPercentage: WideString dispid 96;
    property inMarkupPercentageDisplayUnit: WideString dispid 97;
    property inServiceProvider: WideString dispid 98;
    property inDCCAuthType: WideString dispid 99;
    property inTicketNumer: WideString dispid 101;
    property inNetCode: WideString dispid 102;
    property inSimpleFlag: WideString dispid 103;
    property outCommissionRate: WideString dispid 104;
    property outAccountNum: WideString dispid 105;
    property outBarCodeNumber: WideString dispid 106;
    property inIssuerName: WideString dispid 107;
    property inAccepterName: WideString dispid 108;
    property outReceiptYN: WideString dispid 109;
    property inLogPath: WideString dispid 111;
    property inAgentData: WideString dispid 113;
    property outAgentData: WideString dispid 114;
    property inUnitTimeOut: WideString dispid 117;
    property inAddressNo1: WideString dispid 118;
    property inAddressNo2: WideString dispid 119;
    property inVanId: WideString dispid 120;
    property inSKTGoodsCode: WideString dispid 121;
    property inFallbackCode: WideString dispid 122;
    property inPinBlock: WideString dispid 123;
    property inTradeType: WideString dispid 124;
    property outAgentCode: WideString dispid 125;
    property outDCCAuthType: WideString dispid 126;
    property inHospitalYN: WideString dispid 127;
    property inHospitalInfo: WideString dispid 128;
    property inUserName: WideString dispid 129;
    property inMobileCode: WideString dispid 130;
    property inMobileNumber: WideString dispid 131;
    property inUserID: WideString dispid 132;
    property inExtraUserID: WideString dispid 133;
    property inGroupCode: WideString dispid 134;
    property inUnitUIMode: WideString dispid 135;
    property inPasswdLength: WideString dispid 136;
    property outCardType: WideString dispid 138;
    property inWorkingKey: WideString dispid 139;
    property outArrivedData: WideString dispid 140;
    property outSignHexData: WideString dispid 141;
    property inUnitLockYN: WideString dispid 142;
    property outIssuerBranchCode: WideString dispid 143;
    property outAccepterBranchCode: WideString dispid 144;
    property outTokenDate: WideString dispid 145;
    property inDiscountType: WideString dispid 147;
    property inInfoPath: WideString dispid 149;
    procedure AboutBox; dispid -552;
    function Init: Smallint; dispid 33;
    function KIS_Approval: Smallint; dispid 34;
    function KIS_Approval_Event: Smallint; dispid 47;
    function KIS_SSGPay: Smallint; dispid 60;
    function KIS_CashIC: Smallint; dispid 100;
    function SetLogPath: Smallint; dispid 110;
    function Agent_Exit: Smallint; dispid 112;
    function KIS_Agent_Stop: Smallint; dispid 115;
    function KIS_Approval_Unit: Smallint; dispid 116;
    function KIS_ICApproval: Smallint; dispid 137;
    function KIS_FileDelete(const inFilePath: WideString): Smallint; dispid 146;
    function SetInfoPath: Smallint; dispid 148;
  end;

// *********************************************************************//
// DispIntf:  _DKisPosAgentEvents
// Flags:     (4096) Dispatchable
// GUID:      {BBCDEB1E-EC7E-4AA6-B709-369068893B90}
// *********************************************************************//
  _DKisPosAgentEvents = dispinterface
    ['{BBCDEB1E-EC7E-4AA6-B709-369068893B90}']
    procedure OnApprovalEnd; dispid 1;
    procedure OnApprovalChanged; dispid 2;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TKisPosAgent
// Help String      : KisPosAgent Control
// Default Interface: _DKisPosAgent
// Def. Intf. DISP? : Yes
// Event   Interface: _DKisPosAgentEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TKisPosAgent = class(TOleControl)
  private
    FOnApprovalEnd: TNotifyEvent;
    FOnApprovalChanged: TNotifyEvent;
    FIntf: _DKisPosAgent;
    function  GetControlInterface: _DKisPosAgent;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    function Init: Smallint;
    function KIS_Approval: Smallint;
    function KIS_Approval_Event: Smallint;
    function KIS_SSGPay: Smallint;
    function KIS_CashIC: Smallint;
    function SetLogPath: Smallint;
    function Agent_Exit: Smallint;
    function KIS_Agent_Stop: Smallint;
    function KIS_Approval_Unit: Smallint;
    function KIS_ICApproval: Smallint;
    function KIS_FileDelete(const inFilePath: WideString): Smallint;
    function SetInfoPath: Smallint;
    property  ControlInterface: _DKisPosAgent read GetControlInterface;
    property  DefaultInterface: _DKisPosAgent read GetControlInterface;
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
    property inAgentIP: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property inAgentPort: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property inTranCode: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property inInstallment: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property inTranAmt: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property inVatAmt: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property inSvcAmt: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property inOrgAuthDate: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property inOrgAuthNo: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property inTranGubun: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property outCatId: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property outReplyCode: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property outWCC: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property outCardNo: WideString index 14 read GetWideStringProp write SetWideStringProp stored False;
    property outInstallment: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property outTranAmt: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property outVatAmt: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property outSvcAmt: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property outJanAmt: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property outAuthNo: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property outReplyDate: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property outOrgAuthDate: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property outOrgAuthNo: WideString index 23 read GetWideStringProp write SetWideStringProp stored False;
    property outAccepterCode: WideString index 24 read GetWideStringProp write SetWideStringProp stored False;
    property outAccepterName: WideString index 25 read GetWideStringProp write SetWideStringProp stored False;
    property outIssuerCode: WideString index 26 read GetWideStringProp write SetWideStringProp stored False;
    property outIssuerName: WideString index 27 read GetWideStringProp write SetWideStringProp stored False;
    property outMerchantRegNo: WideString index 28 read GetWideStringProp write SetWideStringProp stored False;
    property outTranNo: WideString index 29 read GetWideStringProp write SetWideStringProp stored False;
    property outRtn: Smallint index 30 read GetSmallintProp write SetSmallintProp stored False;
    property outReplyMsg1: WideString index 31 read GetWideStringProp write SetWideStringProp stored False;
    property outReplyMsg2: WideString index 32 read GetWideStringProp write SetWideStringProp stored False;
    property inPrintYN: WideString index 35 read GetWideStringProp write SetWideStringProp stored False;
    property inCashAuthId: WideString index 36 read GetWideStringProp write SetWideStringProp stored False;
    property inSignYN: WideString index 37 read GetWideStringProp write SetWideStringProp stored False;
    property inSignFileName: WideString index 38 read GetWideStringProp write SetWideStringProp stored False;
    property inCatId: WideString index 39 read GetWideStringProp write SetWideStringProp stored False;
    property inCheckNumber: WideString index 40 read GetWideStringProp write SetWideStringProp stored False;
    property inCheckIssueDate: WideString index 41 read GetWideStringProp write SetWideStringProp stored False;
    property inCheckType: WideString index 42 read GetWideStringProp write SetWideStringProp stored False;
    property inCheckAccountNo: WideString index 43 read GetWideStringProp write SetWideStringProp stored False;
    property outAddedPoint: WideString index 44 read GetWideStringProp write SetWideStringProp stored False;
    property outUsablePoint: WideString index 45 read GetWideStringProp write SetWideStringProp stored False;
    property outTotalPoint: WideString index 46 read GetWideStringProp write SetWideStringProp stored False;
    property inShinsegaeIP: WideString index 48 read GetWideStringProp write SetWideStringProp stored False;
    property inShinsegaePort: WideString index 49 read GetWideStringProp write SetWideStringProp stored False;
    property inShinsegaeSpec: WideString index 50 read GetWideStringProp write SetWideStringProp stored False;
    property outShinsegaeSpec: WideString index 51 read GetWideStringProp write SetWideStringProp stored False;
    property outTradeNum: WideString index 52 read GetWideStringProp write SetWideStringProp stored False;
    property outTradeReqTime: WideString index 53 read GetWideStringProp write SetWideStringProp stored False;
    property outTradeReqDate: WideString index 54 read GetWideStringProp write SetWideStringProp stored False;
    property inTradeReqDate: WideString index 55 read GetWideStringProp write SetWideStringProp stored False;
    property inTradeReqTime: WideString index 56 read GetWideStringProp write SetWideStringProp stored False;
    property inTradeNum: WideString index 57 read GetWideStringProp write SetWideStringProp stored False;
    property inOilInfo: WideString index 58 read GetWideStringProp write SetWideStringProp stored False;
    property inReaderType: WideString index 59 read GetWideStringProp write SetWideStringProp stored False;
    property inBarCodeNumber: WideString index 61 read GetWideStringProp write SetWideStringProp stored False;
    property inVanKeyYN: WideString index 62 read GetWideStringProp write SetWideStringProp stored False;
    property outVanKey: WideString index 63 read GetWideStringProp write SetWideStringProp stored False;
    property inVanKey: WideString index 64 read GetWideStringProp write SetWideStringProp stored False;
    property outTranGubun: WideString index 65 read GetWideStringProp write SetWideStringProp stored False;
    property inOilYN: WideString index 66 read GetWideStringProp write SetWideStringProp stored False;
    property inDefaultCatIdYN: WideString index 67 read GetWideStringProp write SetWideStringProp stored False;
    property inCurrencyCode: WideString index 68 read GetWideStringProp write SetWideStringProp stored False;
    property outBrandGubun: WideString index 69 read GetWideStringProp write SetWideStringProp stored False;
    property outLocalCode: WideString index 70 read GetWideStringProp write SetWideStringProp stored False;
    property outLocalCodeNumber: WideString index 71 read GetWideStringProp write SetWideStringProp stored False;
    property outLocalAmount: WideString index 72 read GetWideStringProp write SetWideStringProp stored False;
    property outLocalAmountMinor: WideString index 73 read GetWideStringProp write SetWideStringProp stored False;
    property outExchangeRate: WideString index 74 read GetWideStringProp write SetWideStringProp stored False;
    property outExchangeRateMinor: WideString index 75 read GetWideStringProp write SetWideStringProp stored False;
    property outInvertedRate: WideString index 76 read GetWideStringProp write SetWideStringProp stored False;
    property outInvertedRateMinor: WideString index 77 read GetWideStringProp write SetWideStringProp stored False;
    property outInvertedRateDisplayUnit: WideString index 78 read GetWideStringProp write SetWideStringProp stored False;
    property outMarkupPercentage: WideString index 79 read GetWideStringProp write SetWideStringProp stored False;
    property outMarkupPercentageDisplayUnit: WideString index 80 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionPercentage: WideString index 81 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionPercentageMinor: WideString index 82 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionNumber: WideString index 83 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionAmount: WideString index 84 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionAmountMinor: WideString index 85 read GetWideStringProp write SetWideStringProp stored False;
    property outServiceProvider: WideString index 86 read GetWideStringProp write SetWideStringProp stored False;
    property inInvertedRate: WideString index 87 read GetWideStringProp write SetWideStringProp stored False;
    property inInvertedRateMinor: WideString index 88 read GetWideStringProp write SetWideStringProp stored False;
    property inLocalCode: WideString index 89 read GetWideStringProp write SetWideStringProp stored False;
    property inLocalAmount: WideString index 90 read GetWideStringProp write SetWideStringProp stored False;
    property inLocalAmountMinor: WideString index 91 read GetWideStringProp write SetWideStringProp stored False;
    property inInvertedRateDisplayUnit: WideString index 92 read GetWideStringProp write SetWideStringProp stored False;
    property inLocalCodeNumber: WideString index 93 read GetWideStringProp write SetWideStringProp stored False;
    property inExchangeRate: WideString index 94 read GetWideStringProp write SetWideStringProp stored False;
    property inExchangeRateMinor: WideString index 95 read GetWideStringProp write SetWideStringProp stored False;
    property inMarkupPercentage: WideString index 96 read GetWideStringProp write SetWideStringProp stored False;
    property inMarkupPercentageDisplayUnit: WideString index 97 read GetWideStringProp write SetWideStringProp stored False;
    property inServiceProvider: WideString index 98 read GetWideStringProp write SetWideStringProp stored False;
    property inDCCAuthType: WideString index 99 read GetWideStringProp write SetWideStringProp stored False;
    property inTicketNumer: WideString index 101 read GetWideStringProp write SetWideStringProp stored False;
    property inNetCode: WideString index 102 read GetWideStringProp write SetWideStringProp stored False;
    property inSimpleFlag: WideString index 103 read GetWideStringProp write SetWideStringProp stored False;
    property outCommissionRate: WideString index 104 read GetWideStringProp write SetWideStringProp stored False;
    property outAccountNum: WideString index 105 read GetWideStringProp write SetWideStringProp stored False;
    property outBarCodeNumber: WideString index 106 read GetWideStringProp write SetWideStringProp stored False;
    property inIssuerName: WideString index 107 read GetWideStringProp write SetWideStringProp stored False;
    property inAccepterName: WideString index 108 read GetWideStringProp write SetWideStringProp stored False;
    property outReceiptYN: WideString index 109 read GetWideStringProp write SetWideStringProp stored False;
    property inLogPath: WideString index 111 read GetWideStringProp write SetWideStringProp stored False;
    property inAgentData: WideString index 113 read GetWideStringProp write SetWideStringProp stored False;
    property outAgentData: WideString index 114 read GetWideStringProp write SetWideStringProp stored False;
    property inUnitTimeOut: WideString index 117 read GetWideStringProp write SetWideStringProp stored False;
    property inAddressNo1: WideString index 118 read GetWideStringProp write SetWideStringProp stored False;
    property inAddressNo2: WideString index 119 read GetWideStringProp write SetWideStringProp stored False;
    property inVanId: WideString index 120 read GetWideStringProp write SetWideStringProp stored False;
    property inSKTGoodsCode: WideString index 121 read GetWideStringProp write SetWideStringProp stored False;
    property inFallbackCode: WideString index 122 read GetWideStringProp write SetWideStringProp stored False;
    property inPinBlock: WideString index 123 read GetWideStringProp write SetWideStringProp stored False;
    property inTradeType: WideString index 124 read GetWideStringProp write SetWideStringProp stored False;
    property outAgentCode: WideString index 125 read GetWideStringProp write SetWideStringProp stored False;
    property outDCCAuthType: WideString index 126 read GetWideStringProp write SetWideStringProp stored False;
    property inHospitalYN: WideString index 127 read GetWideStringProp write SetWideStringProp stored False;
    property inHospitalInfo: WideString index 128 read GetWideStringProp write SetWideStringProp stored False;
    property inUserName: WideString index 129 read GetWideStringProp write SetWideStringProp stored False;
    property inMobileCode: WideString index 130 read GetWideStringProp write SetWideStringProp stored False;
    property inMobileNumber: WideString index 131 read GetWideStringProp write SetWideStringProp stored False;
    property inUserID: WideString index 132 read GetWideStringProp write SetWideStringProp stored False;
    property inExtraUserID: WideString index 133 read GetWideStringProp write SetWideStringProp stored False;
    property inGroupCode: WideString index 134 read GetWideStringProp write SetWideStringProp stored False;
    property inUnitUIMode: WideString index 135 read GetWideStringProp write SetWideStringProp stored False;
    property inPasswdLength: WideString index 136 read GetWideStringProp write SetWideStringProp stored False;
    property outCardType: WideString index 138 read GetWideStringProp write SetWideStringProp stored False;
    property inWorkingKey: WideString index 139 read GetWideStringProp write SetWideStringProp stored False;
    property outArrivedData: WideString index 140 read GetWideStringProp write SetWideStringProp stored False;
    property outSignHexData: WideString index 141 read GetWideStringProp write SetWideStringProp stored False;
    property inUnitLockYN: WideString index 142 read GetWideStringProp write SetWideStringProp stored False;
    property outIssuerBranchCode: WideString index 143 read GetWideStringProp write SetWideStringProp stored False;
    property outAccepterBranchCode: WideString index 144 read GetWideStringProp write SetWideStringProp stored False;
    property outTokenDate: WideString index 145 read GetWideStringProp write SetWideStringProp stored False;
    property inDiscountType: WideString index 147 read GetWideStringProp write SetWideStringProp stored False;
    property inInfoPath: WideString index 149 read GetWideStringProp write SetWideStringProp stored False;
    property OnApprovalEnd: TNotifyEvent read FOnApprovalEnd write FOnApprovalEnd;
    property OnApprovalChanged: TNotifyEvent read FOnApprovalChanged write FOnApprovalChanged;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

procedure TKisPosAgent.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $00000001, $00000002);
  CControlData: TControlData2 = (
    ClassID:      '{74091A7F-FD8C-4440-96A2-CB2EB8BAD896}';
    EventIID:     '{BBCDEB1E-EC7E-4AA6-B709-369068893B90}';
    EventCount:   2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey:   nil (*HR:$80004005*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := UIntPtr(@@FOnApprovalEnd) - UIntPtr(Self);
end;

procedure TKisPosAgent.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DKisPosAgent;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TKisPosAgent.GetControlInterface: _DKisPosAgent;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TKisPosAgent.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function TKisPosAgent.Init: Smallint;
begin
  Result := DefaultInterface.Init;
end;

function TKisPosAgent.KIS_Approval: Smallint;
begin
  Result := DefaultInterface.KIS_Approval;
end;

function TKisPosAgent.KIS_Approval_Event: Smallint;
begin
  Result := DefaultInterface.KIS_Approval_Event;
end;

function TKisPosAgent.KIS_SSGPay: Smallint;
begin
  Result := DefaultInterface.KIS_SSGPay;
end;

function TKisPosAgent.KIS_CashIC: Smallint;
begin
  Result := DefaultInterface.KIS_CashIC;
end;

function TKisPosAgent.SetLogPath: Smallint;
begin
  Result := DefaultInterface.SetLogPath;
end;

function TKisPosAgent.Agent_Exit: Smallint;
begin
  Result := DefaultInterface.Agent_Exit;
end;

function TKisPosAgent.KIS_Agent_Stop: Smallint;
begin
  Result := DefaultInterface.KIS_Agent_Stop;
end;

function TKisPosAgent.KIS_Approval_Unit: Smallint;
begin
  Result := DefaultInterface.KIS_Approval_Unit;
end;

function TKisPosAgent.KIS_ICApproval: Smallint;
begin
  Result := DefaultInterface.KIS_ICApproval;
end;

function TKisPosAgent.KIS_FileDelete(const inFilePath: WideString): Smallint;
begin
  Result := DefaultInterface.KIS_FileDelete(inFilePath);
end;

function TKisPosAgent.SetInfoPath: Smallint;
begin
  Result := DefaultInterface.SetInfoPath;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TKisPosAgent]);
end;

end.
