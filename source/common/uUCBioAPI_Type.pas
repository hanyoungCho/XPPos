unit uUCBioAPI_Type;

interface

uses
  Windows, classes, SysUtils;

Const
  // Constant for Basic
  UCBioAPI_FALSE = 0;
  UCBioAPI_TRUE = 1;

  // UCBioAPI_MAX_DEVICE
  UCBioAPI_MAX_DEVICE = 254;

  // Constant for Error
  UCBioAPIERROR_NONE = 0;
  UCBioAPIERROR_BASE_GENERAL = 0;
  UCBioAPIERROR_BASE_DEVICE = 256;
  UCBioAPIERROR_BASE_UI = 512;
  UCBioAPIERROR_BASE_NSEARCH = 768;

  UCBioAPIERROR_INVALID_HANDLE = UCBioAPIERROR_BASE_GENERAL + 1;
  UCBioAPIERROR_INVALID_POINTER = UCBioAPIERROR_BASE_GENERAL + 2;
  UCBioAPIERROR_INVALID_TYPE = UCBioAPIERROR_BASE_GENERAL + 3;
  UCBioAPIERROR_FUNCTION_FAIL = UCBioAPIERROR_BASE_GENERAL + 4;
  UCBioAPIERROR_STRUCTTYPE_NOT_MATCHED = UCBioAPIERROR_BASE_GENERAL + 5;
  UCBioAPIERROR_ALREADY_PROCESSED = UCBioAPIERROR_BASE_GENERAL + 6;
  UCBioAPIERROR_EXTRACTION_OPEN_FAIL = UCBioAPIERROR_BASE_GENERAL + 7;
  UCBioAPIERROR_VERIFICATION_OPEN_FAIL = UCBioAPIERROR_BASE_GENERAL + 8;
  UCBioAPIERROR_DATA_PROCESS_FAIL = UCBioAPIERROR_BASE_GENERAL + 9;
  UCBioAPIERROR_MUST_BE_PROCESSED_DATA = UCBioAPIERROR_BASE_GENERAL + 10;
  UCBioAPIERROR_INTERNAL_CHECKSUM_FAIL = UCBioAPIERROR_BASE_GENERAL + 11;
  UCBioAPIERROR_ENCRYPTED_DATA_ERROR = UCBioAPIERROR_BASE_GENERAL + 12;

  UCBioAPIERROR_INIT_MAXFINGER = UCBioAPIERROR_BASE_GENERAL + 100;
  UCBioAPIERROR_INIT_SAMPLESPERFINGER = UCBioAPIERROR_BASE_GENERAL + 101;
  UCBioAPIERROR_INIT_ENROLLQUALITY = UCBioAPIERROR_BASE_GENERAL + 102;
  UCBioAPIERROR_INIT_VERIFYQUALITY = UCBioAPIERROR_BASE_GENERAL + 103;
  UCBioAPIERROR_INIT_IDENTIFYQUALITY = UCBioAPIERROR_BASE_GENERAL + 104;
  UCBioAPIERROR_INIT_SECURITYLEVEL = UCBioAPIERROR_BASE_GENERAL + 105;

  UCBioAPIERROR_DEVICE_OPEN_FAIL = UCBioAPIERROR_BASE_DEVICE;
  UCBioAPIERROR_INVALID_DEVICE_ID = UCBioAPIERROR_BASE_DEVICE + 1;
  UCBioAPIERROR_WRONG_DEVICE_ID = UCBioAPIERROR_BASE_DEVICE + 2;
  UCBioAPIERROR_DEVICE_ALREADY_OPENED = UCBioAPIERROR_BASE_DEVICE + 3;
  UCBioAPIERROR_DEVICE_NOT_OPENED = UCBioAPIERROR_BASE_DEVICE + 4;
  UCBioAPIERROR_DEVICE_BRIGHTNESS = UCBioAPIERROR_BASE_DEVICE + 5;
  UCBioAPIERROR_DEVICE_CONTRAST = UCBioAPIERROR_BASE_DEVICE + 6;
  UCBioAPIERROR_DEVICE_GAIN = UCBioAPIERROR_BASE_DEVICE + 7;

  UCBioAPIERROR_USER_CANCEL = UCBioAPIERROR_BASE_UI + 1;
  UCBioAPIERROR_USER_BACK = UCBioAPIERROR_BASE_UI + 2;
  UCBioAPIERROR_CAPTURE_TIMEOUT = UCBioAPIERROR_BASE_UI + 3;

  UCBioAPIERROR_INIT_MAXCANDIDATE = UCBioAPIERROR_BASE_NSEARCH + 1;
  UCBioAPIERROR_NSEARCH_OPEN_FAIL = UCBioAPIERROR_BASE_NSEARCH + 2;
  UCBioAPIERROR_NSEARCH_INIT_FAIL = UCBioAPIERROR_BASE_NSEARCH + 3;
  UCBioAPIERROR_NSEARCH_MEM_OVERFLOW = UCBioAPIERROR_BASE_NSEARCH + 4;
  UCBioAPIERROR_NSEARCH_SAVE_DB = UCBioAPIERROR_BASE_NSEARCH + 5;
  UCBioAPIERROR_NSEARCH_LOAD_DB = UCBioAPIERROR_BASE_NSEARCH + 6;
  UCBioAPIERROR_NSEARCH_INVALD_TEMPLATE = UCBioAPIERROR_BASE_NSEARCH + 7;
  UCBioAPIERROR_NSEARCH_OVER_LIMIT = UCBioAPIERROR_BASE_NSEARCH + 8;
  UCBioAPIERROR_NSEARCH_IDENTIFY_FAIL = UCBioAPIERROR_BASE_NSEARCH + 9;
  UCBioAPIERROR_NSEARCH_LICENSE_LOAD = UCBioAPIERROR_BASE_NSEARCH + 10;
  UCBioAPIERROR_NSEARCH_LICENSE_KEY = UCBioAPIERROR_BASE_NSEARCH + 11;
  UCBioAPIERROR_NSEARCH_LICENSE_EXPIRED = UCBioAPIERROR_BASE_NSEARCH + 12;
  UCBioAPIERROR_NSEARCH_DUPLICATED_ID = UCBioAPIERROR_BASE_NSEARCH + 13;

  // Constant for Security Level
  UCBioAPI_FIR_SECURITY_LEVEL_LOWEST = 1;
  UCBioAPI_FIR_SECURITY_LEVEL_LOWER = 2;
  UCBioAPI_FIR_SECURITY_LEVEL_LOW = 3;
  UCBioAPI_FIR_SECURITY_LEVEL_BELOW_NORMAL = 4;
  UCBioAPI_FIR_SECURITY_LEVEL_NORMAL = 5;
  UCBioAPI_FIR_SECURITY_LEVEL_ABOVE_NORMAL = 6;
  UCBioAPI_FIR_SECURITY_LEVEL_HIGH = 7;
  UCBioAPI_FIR_SECURITY_LEVEL_HIGHER = 8;
  UCBioAPI_FIR_SECURITY_LEVEL_HIGHEST = 9;

  // Constant for Device Name
  UCBioAPI_DEVICE_NAME_FDP02 = 1;
  UCBioAPI_DEVICE_NAME_FDU01 = 2;
  UCBioAPI_DEVICE_NAME_OSU02 = 3;
  UCBioAPI_DEVICE_NAME_FDU11 = 4;
  UCBioAPI_DEVICE_NAME_FSC01 = 5;
  UCBioAPI_DEVICE_NAME_FDU03 = 6;
  UCBioAPI_DEVICE_NAME_FDU05 = 7;

  // Constant for DeviceID
  UCBioAPI_DEVICE_ID_NONE = 0;
  UCBioAPI_DEVICE_ID_FDP02_0 = 1;
  UCBioAPI_DEVICE_ID_FDU01_0 = 2;
  UCBioAPI_DEVICE_ID_OSU02_0 = 3;
  UCBioAPI_DEVICE_ID_FDU11_0 = 4;
  UCBioAPI_DEVICE_ID_FSC01_0 = 5;
  UCBioAPI_DEVICE_ID_FDU03_0 = 6;
  UCBioAPI_DEVICE_ID_FDU05_0 = 7;
  UCBioAPI_DEVICE_ID_AUTO_DETECT = 255;

  // FIR�� ����
  UCBioAPI_FIR_FORM_HANDLE = 2;
  UCBioAPI_FIR_FORM_FULLFIR = 3;
  UCBioAPI_FIR_FORM_TEXTENCODE = 4;

  //
  UCBioAPI_FIR_PURPOSE_VERIFY = 1;
  UCBioAPI_FIR_PURPOSE_IDENTIFY = 2;
  UCBioAPI_FIR_PURPOSE_ENROLL = 3;
  UCBioAPI_FIR_PURPOSE_ENROLL_FOR_VERIFICATION_ONLY = 4;
  UCBioAPI_FIR_PURPOSE_ENROLL_FOR_IDENTIFICATION_ONLY = 5;
  UCBioAPI_FIR_PURPOSE_AUDIT = 6;
  UCBioAPI_FIR_PURPOSE_UPDATE = 7;

  // OR flag used only in high 2 bytes.
  UCBioAPI_WINDOW_STYLE_POPUP = 0;
  UCBioAPI_WINDOW_STYLE_INVISIBLE = 1; // only for UCBioAPI_Capture()
  UCBioAPI_WINDOW_STYLE_CONTINUOUS = 2;

  UCBioAPI_WINDOW_STYLE_NO_FPIMG = $00010000;
  UCBioAPI_WINDOW_STYLE_TOPMOST = $00020000;
  // default flag and not used after v2.3 (WinCE v1.2)
  UCBioAPI_WINDOW_STYLE_NO_WELCOME = $00040000; // only for enroll
  UCBioAPI_WINDOW_STYLE_NO_TOPMOST = $00080000;
  // additional flag after v2.3 (WinCE v1.2)

type
  UCBioAPI_FIR_PURPOSE = WORD;

  // Callback Parameter 0
  // MyCaptureCallbackFunction
  UCBioAPI_WINDOW_CALLBACK_PARAM_PTR_0 = ^UCBioAPI_WINDOW_CALLBACK_PARAM_0;

  UCBioAPI_WINDOW_CALLBACK_PARAM_0 = record
    dwQuality: DWORD;
    lpImageBuf: array of BYTE;
    lpReserved: Pointer;
  end;

  // Callback Parameter 1
  // MyFinishCallbackFunction
  UCBioAPI_WINDOW_CALLBACK_PARAM_PTR_1 = ^UCBioAPI_WINDOW_CALLBACK_PARAM_1;

  UCBioAPI_WINDOW_CALLBACK_PARAM_1 = record
    dwResult: DWORD;
    lpReserved: Pointer;
  end;

  // UCBioAPI_VERSION
  UCBioAPI_VERSION_PTR = ^UCBioAPI_VERSION;

  UCBioAPI_VERSION = record
    Major: DWORD;
    Minor: DWORD;
  end;

  // UCBioAPI_INIT_INFO_0
  UCBioAPI_INIT_INFO_PTR_0 = ^UCBioAPI_INIT_INFO_0;

  UCBioAPI_INIT_INFO_0 = record
    StructureType: DWORD; // must be 0
    MaxFingersForEnroll: DWORD; // Default = 10
    SamplesPerFinger: DWORD; // Default = 2 : not used
    DefaultTimeout: DWORD; // Default = 10000ms = 10sec
    EnrollImageQuality: DWORD; // Default = 50
    VerifyImageQuality: DWORD; // Default = 30
    IdentifyImageQuality: DWORD; // Default = 50
    SecurityLevel: DWORD; // Default = UCBioAPI_FIR_SECURITY_LEVEL_NORMAL
  end;

  // UCBioAPI_FIR_HEADER
  UCBioAPI_FIR_HEADER_PTR = ^UCBioAPI_FIR_HEADER;

  UCBioAPI_FIR_HEADER = record
    Length: DWORD; // Header Length
    DataLength: DWORD; // Data Length
    Version: WORD;
    DataType: WORD;
    Purpose: WORD;
    Quality: WORD;
    Reserved: DWORD;
  end;

  // UCBioAPI_FIR
  UCBioAPI_FIR_PTR = ^UCBioAPI_FIR;

  UCBioAPI_FIR = record
    Format: DWORD; // NBioBSP_Standard = 1
    Header: UCBioAPI_FIR_HEADER;
    Data: array of BYTE; // UCBioAPI_FIR_DATA --> BYTE
  end;

  // UCBioAPI_FIR_PAYLOAD
  UCBioAPI_FIR_PAYLOAD_PTR = ^UCBioAPI_FIR_PAYLOAD;

  UCBioAPI_FIR_PAYLOAD = record
    Length: DWORD;
    Data: array of ^BYTE;
  end;

  // UCBioAPI_FIR_TEXTENCODE
  UCBioAPI_FIR_TEXTENCODE_PTR = ^UCBioAPI_FIR_TEXTENCODE;

  UCBioAPI_FIR_TEXTENCODE = record
    IsWideChar: BOOL;
    TextFIR: PChar;
  end;

  // InputFir
  InputFir_union = record
    case Integer of
      0: (FIRinBSP: Pointer);
      1: (FIR: UCBioAPI_FIR_PTR);
      2: (TextFIR: UCBioAPI_FIR_TEXTENCODE);
  end;

  // UCBioAPI_INPUT_FIR
  UCBioAPI_INPUT_FIR_PTR = ^UCBioAPI_INPUT_FIR;

  UCBioAPI_INPUT_FIR = record
    Form: BYTE;
    InputFir: InputFir_union;
  end;

  // CallBack Function
  UCBioAPI_WINDOW_CALLBACK = Function(pCallbackParam, pUserParam: Pointer): DWORD; stdcall;

  // UCBioAPI_CALLBACK_INFO
  UCBioAPI_CALLBACK_INFO = record
    CallBackType: DWORD;
    CallBackFunction: UCBioAPI_WINDOW_CALLBACK;
    UserCallBackParam: Pointer;
  end;

  // UCBioAPI_WINDOW_OPTION_2
  UCBioAPI_WINDOW_OPTION_PTR_2 = ^UCBioAPI_WINDOW_OPTION_2;

  UCBioAPI_WINDOW_OPTION_2 = record
    FPForeColor: array [0 .. 2] of BYTE; // Fingerprint RGB color
    FPBackColor: array [0 .. 2] of BYTE; // Background RGB color
    DisableFingerForEnroll: array [0 .. 9] of BYTE; // 0=Enable, 1=Disable / [0]=Right Thumb,..[5]=Left Thumb,..[9]=Left little
    Reserved1: array [0 .. 3] of DWORD;
    Reserved2: Pointer;
  end;

  // UCBioAPI_WINDOW_OPTION
  UCBioAPI_WINDOW_OPTION_PTR = ^UCBioAPI_WINDOW_OPTION;

  UCBioAPI_WINDOW_OPTION = record
    Length: DWORD;
    WindowStyle: DWORD;
    ParentWnd: HWND;
    FingerWnd: HWND;
    CaptureCallBackInfo: UCBioAPI_CALLBACK_INFO;
    FinishCallBackInfo: UCBioAPI_CALLBACK_INFO;
    CaptionMsg: LPSTR;
    CancelMsg: LPSTR;
    Option2: UCBioAPI_WINDOW_OPTION_PTR_2;
  end;

  // UCBioAPI_TEMPLATE_DATA_2
  UCBioAPI_TEMPLATE_DATA_PTR = ^UCBioAPI_TEMPLATE_DATA;

  UCBioAPI_TEMPLATE_DATA = record
    Length: DWORD; // sizeof of structure
    Data: array [0 .. 399] of BYTE;
  end;

  // UCBioAPI_TEMPLATE_DATA_2
  UCBioAPI_TEMPLATE_DATA_PTR_2 = ^UCBioAPI_TEMPLATE_DATA_2;

  UCBioAPI_TEMPLATE_DATA_2 = record
    Length: DWORD; // just length of Data (not sizeof structure)
    Data: Pointer; // variable length of data (UCBioAPI_UINT8*)
  end;

  // UCBioAPI_FINGER_DATA
  UCBioAPI_FINGER_DATA_PTR = ^UCBioAPI_FINGER_DATA;

  UCBioAPI_FINGER_DATA = record
    Length: DWORD; // sizeof of structure
    FingerID: BYTE; // UCBioAPI_FINGER_ID
    Template: UCBioAPI_TEMPLATE_DATA_PTR;
  end;

  // UCBioAPI_FINGER_DATA_2
  UCBioAPI_FINGER_DATA_PTR_2 = ^UCBioAPI_FINGER_DATA_2;

  UCBioAPI_FINGER_DATA_2 = record
    Length: DWORD; // sizeof of structure
    FingerID: BYTE; // UCBioAPI_FINGER_ID
    Template: UCBioAPI_TEMPLATE_DATA_PTR_2;
    // Template = UCBioAPI_TEMPLATE_DATA_2 * SamplesPerFinger
  end;

  // UCBioAPI_EXPORT_DATA
  UCBioAPI_EXPORT_DATA_PTR = ^UCBioAPI_EXPORT_DATA;

  UCBioAPI_EXPORT_DATA = record
    Length: DWORD; // sizeof of structure
    EncryptType: BYTE; // Minutiae type
    FingerNum: BYTE;
    DefaultFingerID: BYTE; // UCBioAPI_FINGER_ID
    SamplesPerFinger: BYTE;
    FingerData: UCBioAPI_FINGER_DATA_PTR; // only used for MINCONV_TYPE_FDP ~ MINCONV_TYPE_OLD_FDA
    FingerData2: UCBioAPI_FINGER_DATA_PTR_2; // used for all type
  end;

  // Get UCBioAPI_VERSION
  TFUCBioAPI_GetVersion = Function(hHandle: DWORD; pVersion: UCBioAPI_VERSION_PTR): DWORD; stdcall;
  // Get UCBioAPI_Infomation
  TFUCBioAPI_GetInitInfo = Function(hHandle: DWORD; nStructureType: BYTE; pInitInfo: UCBioAPI_INIT_INFO_PTR_0): DWORD; stdcall;
  // Set UCBioAPI_Information
  TFUCBioAPI_SetInitInfo = Function(hHandle: DWORD; nStructureType: BYTE; pInitInfo: UCBioAPI_INIT_INFO_PTR_0): DWORD; stdcall;
  // Open Device
  TFUCBioAPI_OpenDevice = Function(hHandle: DWORD; nDeviceID: WORD): DWORD; stdcall;
  // Close Device
  TFUCBioAPI_CloseDevice = Function(hHandle: DWORD; nDeviceID: WORD): DWORD; stdcall;

  TFUCBioAPI_Init = Function(phHandle: Pointer): DWORD; stdcall;

  TFUCBioAPI_Terminate = Function(hHandle: DWORD): DWORD; stdcall;

  // (UCBioAPI_HANDLE hHandle, UCBioAPI_VOID_PTR pFIR)
  TFUCBioAPI_FreeFIR = Function(hHandle: DWORD; pFIR: Pointer): DWORD; stdcall;

  TFUCBioAPI_FreeFIRHandle = Function(hHandle, hFIR: DWORD): DWORD; stdcall;

  // (UCBioAPI_HANDLE hHandle, UCBioAPI_UINT32* pNumDevice, UCBioAPI_DEVICE_ID** ppDeviceID)
  TFUCBioAPI_EnumerateDevice = Function(hHandle: DWORD; pNumDevice: Pointer; ppDeviceID: Pointer): DWORD; stdcall;

  TFUCBioAPI_Enroll = Function(hHandle: DWORD;
    const piStoredTemplate: UCBioAPI_INPUT_FIR_PTR; phNewTemplate: Pointer;
    const pPayload: UCBioAPI_FIR_PAYLOAD_PTR; nTimeout: Integer;
    phAuditData: Pointer; const pWindowOption: UCBioAPI_WINDOW_OPTION_PTR): DWORD; stdcall;

  TFUCBioAPI_Verify = Function(hHandle: DWORD;
    const piStoredTemplate: UCBioAPI_INPUT_FIR_PTR; pbResult: Pointer; // Bool*;
    pPayload: UCBioAPI_FIR_PAYLOAD_PTR; nTimeout: Integer; phAuditData: Pointer; // DWORD*
    const pWindowOption: UCBioAPI_WINDOW_OPTION_PTR): DWORD; stdcall;

  TFUCBioAPI_GetFIRFromHandle = Function(hHandle: DWORD; hFIR: DWORD; pFIR: UCBioAPI_FIR_PTR): DWORD; stdcall;

  TFUCBioAPI_GetHeaderFromHandle = Function(hHandle, hFIR: DWORD; pHeader: UCBioAPI_FIR_HEADER_PTR): DWORD; stdcall;

  TFUCBioAPI_FreeTextFIR = Function(hHandle: DWORD; pTextFIR: UCBioAPI_FIR_TEXTENCODE_PTR): DWORD; stdcall;

  TFUCBioAPI_GetTextFIRFromHandle = Function(hHandle, hFIR: DWORD; pTextFIR: UCBioAPI_FIR_TEXTENCODE_PTR; bIsWide: BOOL): DWORD; stdcall;

  TFUCBioAPI_CheckValidity = Function(szModulePath: LPCTSTR): DWORD; stdcall;

  TFUCBioAPI_SetSkinResource = Function(szResPath: LPCTSTR): Boolean; stdcall;

  TFUCBioAPI_FreePayload = Function(hHandle: DWORD; pPayload: UCBioAPI_FIR_PAYLOAD_PTR): BOOL; stdcall;

  TFUCBioAPI_Capture = Function(hHandle: DWORD; nPurpose: UCBioAPI_FIR_PURPOSE;
    phCapturedFIR: Pointer; // UCBioAPI_FIR_HANDLE_PTR;
    nTimeout: Integer; phAuditData: Pointer; // UCBioAPI_FIR_HANDLE_PTR;
    const pWindowOption: UCBioAPI_WINDOW_OPTION_PTR): DWORD; stdcall;

implementation

end.
