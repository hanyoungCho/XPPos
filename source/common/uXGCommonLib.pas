(*******************************************************************************

  Project     : XGOLF ���������� POS �ý���
  Title       : ���� ���̺귯��
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.
    1.1.0.0   2020-05-13   Added GetCurrentUserName()

  Copyright��SolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGCommonLib;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils, System.StrUtils, System.JSON,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms, System.Win.Registry, Vcl.Imaging.Jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, System.NetEncoding, Winapi.TlHelp32, IdIPWatch, nxlsa, DelphiZXIngQRCode;

const
  CONST_WM_SEND_MOUSE = WM_USER + 5000;
  CONST_SINGLE_CHARS = Chr(32) + '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`~!@#$%^&*()-_=+\|[]{},<.>;:''"/?';

  CONST_IF_UNKNOWN  = -1;
  CONST_IF_BITMAP   = 0;
  CONST_IF_JPEG     = 1;
  CONST_IF_PNG      = 2;
  CONST_IF_GIF      = 3;

type
  TArrayOfByte = array of Byte;

  PMSLLHOOKSTRUCT = ^MSLLHOOKSTRUCT;
  MSLLHOOKSTRUCT = packed record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;

  { WM_COPYDATA �޽��� ���� }
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: DWORD;
    cbData: DWORD;
    lpData: Pointer;
  end;

  { �ѿ� IME ��� }
  TImeMode = (imEnglish, imKorean);

  TSkinItem = record
    FileName: string;
    Width: smallint;
    Height: smallint;
    Stretch: Boolean;
  end;

  TSkinData = record
    GroupCode: string;
    Normal: TSkinItem;
    Pressed: TSkinItem;
    Disabled: TSkinItem;
  end;

  TSkinInfo = record
    Version: string;
    Preview: string;
    Background: string;
    Items: array of TSkinData
  end;

  TCondition<V> = class
  public
    class function &if(const ACondition: Boolean; const ATrueValue, AFalseValue: V): V; static;
  end;

//IfThen() ���� �Լ�
function IIF(const AIsTest: Boolean; const ATrueValue, AFalseValue: Variant): variant;
//�ü���� �α����� ����ڸ�
function GetCurrentUserName: string;
//�����������
function GetFileSize(const AFileName: string): Integer;
//MB������ ���� ������ ���ϱ�
function GetFileSizeMB(const AFileName: string): Int64;
//MB������ �̹��� ���� ������ �� Width, Height ���ϱ�
function GetImageFileSizeMB(const AFileName: string; var AWidth: integer; var AHeight: integer): int64;
//������ ���� ���� ���ϸ�� ����
function GetFileList(const APath: string; var AFileList: TStringList): integer; overload;
function GetFileList(const APath: string; AFilters: string; var AFileList: TStringList): integer; overload;
//������ ��Ʈ���� ��Ʈ�� ��ü�� ����
function WinControlToImage(AWinControl: TWinControl; AImage: TGraphic; const APixelFormat: byte=16): integer;
//��ũ�� ������ ������ ��Ʈ���� ��Ʈ�� ��ü�� ����
function WinScrollControlToImage(AWinControl : TScrollingWinControl; ABitmap: TBitmap; const APixelFormat: byte=16): integer;
//��Ʈ���� RTF �������� ��ȯ
function BitmapToRTF(ABitmap: TBitmap): string;
//������ ��Ʈ���� �����ͷ� ���
procedure WinControlToPrint(AParentForm: TForm; AControl: TWinControl; const AIsLandscape: Boolean=False);
//��Ʈ���� ĵ������ ��������
procedure BitmapToCanvas(Canvas: TCanvas; DestRect: TRect; BMP: TBitmap);
//��ũ�� ��ü�� �����ͷ� ���
procedure BitmapToPrint(BMP: TBitmap; const AIsLandscape: Boolean=false);
//��Ʈ�� ��ü�� �̹��� ���Ϸ� ����
//AImageFormat = wifBmp, wifJpeg, wifPng
//APixelFormat = 1, 4, 8, 16, 24, 32 (��, jpeg�� 8�� 24�� ����)
function SaveImageToFile(const AFileName: string; AImage: TGraphic; AImageFormat: TWICImageFormat=wifJpeg; const APixelFormat: byte=16; const AJpegCompressionQuality: integer=70): integer;
//��Ʈ�� ��ü�� Jpeg������ �̹��� ���Ϸ� ����
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic): integer; overload;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: byte=16): integer; overload;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: byte=16; const AJpegCompressionQuality: integer=70): integer; overload;
//��Ʈ�� �ڸ���
procedure CropBitmap(AInputBitmap, AOutputBitMap: TBitmap; const AStartX, AStartY, AWidth, AHeight: Integer);
//��Ʈ�� ��ü�� ������ ũ��� ����
//procedure ResizeBitmap(ABitmap: TBitmap; const ANewWidth, ANewHeight: integer);
procedure ResizeBitmap(ABitmap: TBitmap; const AWidth, AHeight: Integer; ABackgroundColor: TColor);
//������ ��¥�� ���ϴ� ���� ������ ���� ���Ѵ�.
function GetLastDayOfMonth(const ADateTime: TDateTime): shortint;
//���ڿ�(WideSring & AnsiString)�� Bytes ������ ũ�⸦ ���Ѵ�.
function StrLength(const AText: string): integer;
//������ ���̸�ŭ ���ڿ��� ������ ä��
function LeftPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
//������ ���̸�ŭ ���ڿ��� �������� ä��
function RightPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
//���ڿ��� ���� Slash ���� ����
function IncludeTrailingSlash(const AText: string): string;
//���ڿ��� ���� Slash ���� ����
function ExcludeTrailingSlash(AText: string): string;
//���ڿ����� �������� ��ȯ��
function GetNumStr(const AValue: String): string;
//���ϸ� ��ȯ
function DayOfWeekName(const ADate: TDate): string; overload;
function DayOfWeekName(const ADate: TDate; const AHanja: Boolean): string; overload;
//���� �ð� ����
function ChangeSystemTime(const ADateTime: TDateTime): Boolean;
//Bitmap�� �̿��Ͽ� ���ڿ��� Display Width�� Height�� �ȼ� ������ ���Ѵ�.
procedure GetTextPixelSize(const AText: string; AFont: TFont; var AWidth, AHeight: integer);
//Null ó�� �Լ�:ORACLE�� NVL()�� ����
function NVL(const ATestValue, ANewValue: Variant): Variant;
//���ڰ��� null���� Ȯ��
function IsNull(const AValue: Variant): Boolean;
// OleVarian�� Stream���� ��ȯ
function OleVariantToStream (AOleValue: OleVariant): TMemoryStream;
// Stream�� OleVarian�� ��ȯ
function StreamToVariant(AStream: TStream): OleVariant;
//IME �ѱ� �Է¸�� �˻�
function IsHanState: Boolean; //function IsHanState(AForm: TForm): Boolean;
//IME �Է¸�� ���� ���ѱ�:SetIMEMode(imKorean), ����:SetIMEMode(imEnglish)
procedure SetIMEMode(const AImeMode: TImeMode);
//NumLock, CapsLock, ScrollLock ���� �б�
function GetKeybdState(const AKeyCode: integer): Boolean;
//NumLock, CapsLock, ScrollLock ���� ����
procedure SetKeybdState(const AKeyCode: integer; const AIsOn: Boolean);
//���� Ű���� �Է� ó��
procedure SimulateKeyDown(AVirtualKey: Byte);
procedure SimulateKeyUp(AVirtualKey: Byte);
procedure SimulateKeyWithShift(AVirtualKey: Byte); overload;
procedure SimulateKeyWithShift(AVirtualKey, AShiftKey: Byte); overload;
procedure SimulateKey(AVirtualKey: Byte);
//Ű���� ��ŷ
function  KeybdHookHookCallback(ACode: integer; wParam: WPARAM; lParam: LPARAM): NativeInt; stdcall;
procedure KeybdHookStart;
procedure KeybdHookStop;
//���콺 ��ŷ
procedure MouseHookStart(const AHandle: THandle);
procedure MouseHookStop;
function MouseHookHookCallBack(ACode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
//Sleep() ��ü �Լ�
procedure SleepEx(const AMSecs: LongInt);
procedure Delay(const AMSecs: LongInt);
//�ؽ�Ʈ ���� ���� �� ���
procedure WriteToFile(const AFileName, AStr: string; const ANewFile: Boolean=False);
//���ø����̼� ���� ���� ����
function GetAppVersion(const AIndex: Integer): string;
//DLL���� ��� ���� ���� ���� ����
function GetModuleVersion(const AFileName: string): string;
//��� ������ ��� ��Ʈ�ѿ� DoubleBuffered ����
procedure SetDoubleBuffered(AControl: TWinControl; const ADoubleBuffered: Boolean);
//Check Existing File(64bit)
function FileExists64(const AFileName: string): Boolean;
//Check 64bit Windows
function IsWin64: Boolean;

//��ȸ�� �ſ�ī���ȣ
function GetHideCreditCardNo(const ACreditCardNo: string): string;
//������ �߰� �Ŀ� CalcField �� �ٷ� �ݿ����� �ʴ� ���� ��ġ��
procedure RefreshCalcField(ADataSet: TDataSet);
//yyyymmdd ������ ��¥�� yyyy-mm-dd �������� ��ȯ
function FormattedDateString(const ADateString: string): string;
//hhnnss ������ �ð��� hh:nn:ss �������� ��ȯ
function FormattedTimeString(const ATimeString: string): string;
//���н� �ð��� ���ڿ��� ��ȯ
function UnixTimeToString(const AUnixTime: string; const AFormatStr: string): string;
//Ư������ ����
function RemoveSpecialChar(const ASource: string): string;
//������Ʈ������ ���� ���α׷����� ����ϱ�
procedure RunOnWindownStart(const AppTitle, AppFile: string; const ARunOnce: Boolean=False);
//������Ʈ������ ���� ���α׷����� �����ϱ�
function RemoveFromRunOnWindowStart(const AppTitle: string): Boolean;
//������ �ý��� ����
procedure SystemShutdown(const ATimeOut: DWORD; const AForceClose, AReboot: Boolean);
//������ Window�� �ֻ����� ǥ����
procedure SetWindowOnTop(const AHandle: HWND);
procedure SetWindowOnTop2(const AHandle: HWND);
//������ �������� ���α׷� ����
function RunAsAdmin(const AHandle: HWND; const APath, AParams: string): Boolean;
//�ý��� ���͸� ���ϱ�
function GetSysDir: string; overload;
function GetSysDir(const AFloder: Integer): string; overload;
//WM_COPYDATA ���ڿ� ����
procedure CopyDataString(const AHandle: HWND; const AMsg: Cardinal; const AData: string);

(***
//��Ų ���� �Լ�
function GetSkinInfo(const ASkinFile, APassword, ASkinType: string; var ASkinInfo: TSkinInfo;
  var AFileList: TStringList; var AConfig: TStream; var AErrMsg: string): Boolean;
function GetStreamOfSkin(const ASkinFile, APassword, AFileNameInArchive: string;
  var AStream: TStream; var AErrMsg: string): Boolean;
function GetItemInfoOfSkin(AConfig: TStream; const ASkinType, AGroupID, ANodeName: string;
  var ASkinItem: TSkinItem; var AErrMsg: string): Boolean;

//�̹��� ���� �Լ�
function StreamToPicture(AStream: TStream; APicture: TPicture; var AErrMsg: string): Boolean;
function StreamToImageList(AStream: TStream; const AWidth, AHeight: integer;
  AImageList: TcxImageList; var AErrMsg: string): Boolean;
function GetImageFormat(AFileName: string): shortint; overload;
function GetImageFormat(AStream: TStream): shortint; overload;
***)

{ Imported from GlobalFunctions }

//��ȣȭ, ��ȣȭ
function StrEncrypt(const AStr: AnsiString): AnsiString;
function StrDecrypt(const AStr: AnsiString): AnsiString;
const
  C_SEED_KEY1 = 51637; //53761;
  C_SEED_KEY2 = 38126; //32618;
function StrEncryptEx(const ADecrypt: WideString; AKey: Word): string;
function StrDecryptEx(const AEncrypt: string; AKey: Word): string;
//���ڿ� ó��
function LPadB(const AStr: string; ALength: Integer): string;
function RPadB(const AStr: string; ALength: Integer): string;
function PadChar(ALength: Integer; APadChar: Char = ' '): string;
function SCopy(const AText: string; const AByteStart, AByteCount: Integer): string;
function ByteLen(const AText: string): Integer;

function Base64Encode(const AData: string; const AConvertUTF8: Boolean=False): string;
function Base64EncodeA(const AData: string; const AConvertUTF8: Boolean=False): string;
function Base64Decode(const AData: string): string;
function Base64EncodeStream(const AStream: TStream): string;
function Base64DecodeStream(const AStream: TStream): string;
function Base64EncodeGraphic(AImage: TGraphic): string;
function Base64EncodeFile(const AFileName: string): string;

function BCC(const AValue: AnsiString): string;
function LRC(const AValue: AnsiString; const ACheckLen: Integer=0): Byte;
function StringToHex(const AValue: AnsiString): string;
function HexToString(const AValue: string): AnsiString;
function BytesToHex(const ABytes: TBytes): string;
function StringToBytes(const AValue: WideString): TBytes;
function BytesToString(const AValue: TBytes): WideString;
function StringToArrayOfByte(const AValue: AnsiString): TArrayOfByte;
function ArrayOfByteToString(const AValue: TArrayOfByte): AnsiString;

//���޻��� ���ӽð�(��) ���ϱ�
function GetIdleSeconds: DWord;
//����� ��Ʈ��
function MakeRoundedControl(AControl: TWinControl; const AEllipseWidth: Integer=20; const AEllipseHeight: Integer=20): Boolean;
//���� �г�
procedure TransparentPanel(var APanel: TPanel);
//QR���ڵ� ����
function GenerateQRCode(ABitmap: TBitmap; const AText: string; const AScale, AEncodingMethod, AQuietZone: Integer; var AErrMsg: string): Boolean;
//JSON ��ü �޸� ����
procedure FreeAndNilJSONObject(AObject: TJSONAncestor);
//�������ϸ����� ���μ��� ID ���ϱ�
function GetProcessId(const AFilePath: string): NativeInt;
//�������ϸ����� ���μ��� �ڵ� ���ϱ�
function GetProcessHandle(const AFilePath: string): NativeInt;
//���μ��� ���� ����
function KillProcess(const AProcName: string): Boolean;
function KillProcessByHandle(const AHandle: NativeInt): Boolean;
function KillProcessByPID(const AProcessId: NativeInt): Boolean;
//���� ���ϱ�
function InvertColor(const Color: TColor): TColor;
function InvertColor2(const Color: TColor): TColor;
//���� ��� ���� �޸� ũ�� ���ϱ� (FastMM5 ������ �߰��ؾ� �������� ���� ��ȯ��.)
function GetMemoryUsed: UInt64;
//�̹��� ������ ���ϱ�
function ReadMWord(FS: TFileStream): Word;
procedure GetJpgSize(const AFileName: string; var AWidth, AHeight: Integer);
procedure GetPngSize(const AFileName: string; var AWidth, AHeight: Integer);
//ListView ���� �ٲٱ�
procedure ExchangeListItems(AListView: TListView; const AIndex1, AIndex2: Integer);

implementation

uses
  Variants, Printers, PngImage, Imm, DateUtils, ShellAPI, IdCoderMIME, EncdDecd, ShFolder;

var
  SBGlobal_KeybdHook: HHook; //Ű���� ��ŷ
  SBGlobal_MouseHook: HHook; //���콺 ��ŷ
  SBGlobal_MouseThisHandle: THandle;

//LString := TCondition<string>.if(����, '��', '����');
//LInteger := TCondition<Integer>.if(����, 100, 200);
class function TCondition<V>.&if(const ACondition: Boolean; const ATrueValue, AFalseValue: V): V;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

//IfThen() ���� �Լ�
function IIF(const AIsTest: Boolean; const ATrueValue, AFalseValue: Variant): Variant;
begin
  if AIsTest then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

//�ü���� �α����� ����ڸ�
function GetCurrentUserName: string;
var
  pUserName: PChar;
  dwSize: DWORD;
begin
  Result := '';
  dwSize := 250;
  GetMem(pUserName, dwSize);
  try
    GetUserName(pUserName, dwSize);
    Result := StrPas(pUserName);
  finally
    FreeMem(pUserName);
  end;
end;

//GetFileSize
function GetFileSize(const AFileName: string): Integer;
var
  H: THandle;
  WFD: TWin32FindData;
begin
  H := FindFirstFile(pchar(AFileName), WFD); // ������ ������ �д´�
  Result := Round((WFD.nFileSizeHigh * MAXDWORD) + WFD.nFileSizeLow);
  Winapi.Windows.FindClose(H);
end;

//MB������ ���� ������ ���ϱ�
function GetFileSizeMB(const AFileName: string): Int64;
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := FS.Size div 1024000;
  finally
    FreeAndNil(FS);
  end;
end;

//MB������ �̹��� ���� ������ �� Width, Hieght ���ϱ�
function GetImageFileSizeMB(const AFileName: string; var AWidth: integer; var AHeight: integer): int64;
var
  PIC: TPicture;
begin
  PIC := TPicture.Create;
  try
    AWidth := PIC.Width;
    AHeight := PIC.Height;
    Result := GetFileSizeMB(AFileName);
  finally
    FreeAndNil(PIC);
  end;
end;

//������ ���� ���� ���ϸ�� ����
function GetFileList(const APath: string; var AFileList: TStringList): integer;
begin
  Result := GetFileList(APath, '', AFileList);
end;
function GetFileList(const APath: string; AFilters: string; var AFileList: TStringList): integer;
var
  SR: TSearchRec;
  sFileExt: string;
begin
  try
    AFilters := LowerCase(AFilters);
    try
      if (FindFirst(APath + '*.*', faAnyFile - faDirectory, SR) = 0) then
      begin
        repeat
          if (AFilters <> EmptyStr) then
          begin
            sFileExt := LowerCase(StringReplace(ExtractFileExt(SR.Name), '.', '', [rfReplaceAll]));
            if (Pos(sFileExt, AFilters) > 0) then
              AFileList.Add(APath + SR.Name);
          end
          else
            AFileList.Add(APath + SR.Name);
        until FindNext(SR) <> 0;
      end;
      FindClose(SR);
    except
      AFileList.Clear;
      raise;
    end;
  finally
    Result := AFileList.Count;
  end;
end;

//������ ��Ʈ���� ��Ʈ�� ��ü�� ����)
function WinControlToImage(AWinControl: TWinControl; AImage: TGraphic; const APixelFormat: byte): integer;
var
  BMP: TBitmap;
  CDC: HDC;
begin
  if not AWinControl.HandleAllocated then
  begin
    Result := -2; //ĸ���� �� ���� ��ü
    Exit;
  end;

  CDC := GetWindowDC(AWinControl.Handle);
  BMP := TBitmap.Create;
  try
    try
      BMP.SetSize(AWinControl.Width, AWinControl.Height);
      case APixelFormat of
        1: BMP.PixelFormat := pf1bit;
        4: BMP.PixelFormat := pf4bit;
        8: BMP.PixelFormat := pf8bit;
        24: BMP.PixelFormat := pf24bit;
        32: BMP.PixelFormat := pf32bit;
      else
        BMP.PixelFormat := pf16bit; //�⺻��:16��Ʈ
      end;

      BitBlt(BMP.Canvas.Handle, 0, 0, BMP.Width, BMP.Height, CDC, 0, 0, SRCCOPY);
      AImage.Assign(BMP);
      Result := 0; //����
    except
      on e: Exception do
        Result := GetLastError;
    end;
  finally
    FreeAndNil(BMP);
    ReleaseDC(AWinControl.Handle, CDC);
  end;
end;

//��ũ�� ������ ������ ��Ʈ���� ��Ʈ�� ��ü�� ����
function WinScrollControlToImage(AWinControl : TScrollingWinControl; ABitmap: TBitmap; const APixelFormat: byte): integer;
var
  hScrDC, hMemDC: HDC;
  hBMP, hOldBMP: HBITMAP;
  nWidth, nHeight: integer;
  nOldScrollPosHori, nOldScrollPosVert: integer;
  nPosHori, nPosVert: integer;
  nSrcPosX, nSrcPosY: integer;
  nDestPosX, nDestPosY: integer;
begin
  if ((not AWinControl.HandleAllocated) or //ĸ���� �� ���� ��ü
      (AWinControl.Visible = False) or
      (AWinControl.Width = 0) or
      (AWinControl.Height = 0 )) then
  begin
    Result := -2;
    Exit;
  end;

  try
    try
      nOldScrollPosHori := AWinControl.HorzScrollBar.Position;
      nOldScrollPosVert := AWinControl.VertScrollBar.Position;
      hScrDC := GetDC(AWinControl.Handle);
      hMemDC := CreateCompatibleDC(hScrDC);
      hBMP := CreateCompatibleBitmap(hScrDC, AWinControl.HorzScrollBar.Range, AWinControl.VertScrollBar.Range);
      hOldBMP := SelectObject(hMemDC, hBMP);

      nPosVert := 0;
      nSrcPosY := 0;
      nDestPosY := 0;
      nHeight := AWinControl.ClientHeight;
      while (nDestPosY < AWinControl.VertScrollBar.Range) do
      begin
        nPosHori := 0;
        nSrcPosX := 0;
        nDestPosX := 0;
        nWidth := AWinControl.ClientWidth;
        AWinControl.VertScrollBar.Position := nPosVert;

        while (nDestPosX < AWinControl.HorzScrollBar.Range) do
        begin
          AWinControl.HorzScrollBar.Position := nPosHori;
          AWinControl.Repaint;

          BitBlt(hMemDC, nDestPosX, nDestPosY, nWidth, nHeight, hScrDC, nSrcPosX, nSrcPosY, SRCCOPY);

          nDestPosX := (nDestPosX + nWidth);
          if ((AWinControl.HorzScrollBar.Range - nPosHori - AWinControl.ClientWidth) < AWinControl.ClientWidth) then
          begin
            nWidth := (AWinControl.HorzScrollBar.Range  - nPosHori - AWinControl.ClientWidth);
            nSrcPosX := (AWinControl.ClientWidth - nWidth);
            nPosHori := (nPosHori + nWidth);
          end
          else
            nPosHori := (nPosHori + AWinControl.ClientWidth);
        end;

        nDestPosY := (nDestPosY + nHeight);
        if ((AWinControl.VertScrollBar.Range - nPosVert - AWinControl.ClientHeight) < AWinControl.ClientHeight ) then
        begin
          nHeight := (AWinControl.VertScrollBar.Range  - nPosVert - AWinControl.ClientHeight);
          nSrcPosY := (AWinControl.ClientHeight - nHeight);
          nPosVert := (nPosVert + nHeight);
        end
        else
          nPosVert := (nPosVert + AWinControl.ClientHeight);
      end;

      case APixelFormat of
        1: ABitmap.PixelFormat := pf1bit;
        4: ABitmap.PixelFormat := pf4bit;
        8: ABitmap.PixelFormat := pf8bit;
        24: ABitmap.PixelFormat := pf24bit;
        32: ABitmap.PixelFormat := pf32bit;
      else
        ABitmap.PixelFormat := pf16bit; //�⺻��:16��Ʈ
      end;

      ABitmap.Handle := hBMP;
      SelectObject(hMemDC, hOldBMP);

      Result := 0; //����
    finally
      DeleteDC(hMemDC);
      DeleteDC(hScrDC);
      ReleaseDC(AWinControl.Handle, hScrDC);

      AWinControl.HorzScrollBar.Position := nOldScrollPosHori;
      AWinControl.VertScrollBar.Position := nOldScrollPosVert;
    end;
  except
    on E: Exception do
      Result := GetLastError;
  end;
end;

//��Ʈ���� RTF �������� ��ȯ
function BitmapToRTF(ABitmap: TBitmap): string;
var
  sHeader, sBody: AnsiString;
  nHeaderSize, nBodySize: cardinal;
  i: integer;
begin
  GetDIBSizes(ABitmap.Handle, nHeaderSize, nBodySize);
  SetLength(sHeader, nHeaderSize);
  SetLength(sBody, nBodySize);
  GetDIB(ABitmap.Handle, ABitmap.Palette, PAnsiChar(sHeader)^, PAnsiChar(sBody)^);

  for i := 1 to nHeaderSize do
    Result := Result + IntToHex(Integer(sHeader[i]), 2);
  for i := 1 to nBodySize do
    Result := Result + IntToHex(Integer(sBody[i]), 2);
  Result := '\line {\rtf1 {\pict \dibitmap ' + Result + '}}'#13#10;
end;

//������ ��Ʈ���� �����ͷ� ���
procedure WinControlToPrint(AParentForm: TForm; AControl: TWinControl; const AIsLandscape: Boolean);
var
  BMP: TBitmap;
  nFromLeft, nFromTop, nPrnWidth, nPrnHeight: integer;
begin
  if AIsLandscape then
    Printer.Orientation := poLandscape
  else
    Printer.Orientation := poPortrait;

  Printer.BeginDoc;
  try
    BMP := TBitmap.Create;
    try
      BMP.Width := AControl.Width;
      BMP.Height := AControl.Height;
      BMP.PixelFormat := pf24bit;
      BMP.Canvas.CopyRect(
        Rect(0, 0, BMP.Width, BMP.Height), AParentForm.Canvas,
          Rect(AControl.Left, AControl.Top, AControl.Left + AControl.Width, AControl.Top + AControl.Height));

      nPrnWidth  := MulDiv(Printer.PageWidth, 94, 100); //94%
      nPrnHeight := MulDiv(nPrnWidth, BMP.Height, BMP.Width);
      nFromLeft  := MulDiv(Printer.PageWidth, 3, 100);  //3%
      nFromTop   := MulDiv(Printer.PageHeight, 3, 100); //3%

      BitmapToCanvas(Printer.Canvas, Rect(nFromLeft, nFromTop, nFromLeft + nPrnWidth, nFromTop  + nPrnHeight), BMP);
    finally
      BMP.Free;
    end;
  finally
    Printer.EndDoc;
  end;
end;

//��Ʈ���� ĵ������ ��������
procedure BitmapToCanvas(Canvas: TCanvas; DestRect: TRect; BMP: TBitmap);
var
  pBMPHeader: pBitmapInfo;
  pBMPImage: Pointer;
  dHeaderSize: DWORD;
  dImageSize: DWORD;
begin
  GetDIBSizes(BMP.Handle, dHeaderSize, dImageSize);
  GetMem(pBMPHeader, dHeaderSize);
  GetMem(pBMPImage, dImageSize);
  try
    GetDIB(BMP.Handle, BMP.Palette, pBMPHeader^, pBMPImage^);
    StretchDIBits(Canvas.Handle,
      DestRect.Left, DestRect.Top,    // Destination Origin
      DestRect.Right - DestRect.Left, // Destination Width
      DestRect.Bottom - DestRect.Top, // Destination Height
      0, 0,                           // Source Origin
      BMP.Width, BMP.Height,          // Source Width & Height
      pBMPImage, TBitmapInfo(pBMPHeader^), DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(pBMPHeader);
    FreeMem(pBMPImage);
  end
end;

//��ũ�� ��ü�� �����ͷ� ���
procedure BitmapToPrint(BMP: TBitmap; const AIsLandscape: Boolean);
var
  nFromLeft, nFromTop, nPrnWidth, nPrnHeight: integer;
begin
  if AIsLandscape then
    Printer.Orientation := poLandscape
  else
    Printer.Orientation := poPortrait;

  Printer.BeginDoc;
  try
    nPrnWidth  := MulDiv(Printer.PageWidth, 94, 100); //94%
    nPrnHeight := MulDiv(nPrnWidth, BMP.Height, BMP.Width);
    nFromLeft  := MulDiv(Printer.PageWidth, 3, 100);  //3%
    nFromTop   := MulDiv(Printer.PageHeight, 3, 100); //3%

    BitmapToCanvas(Printer.Canvas, Rect(nFromLeft, nFromTop, nFromLeft + nPrnWidth, nFromTop  + nPrnHeight), BMP);
  finally
    Printer.EndDoc;
  end;
end;

//��Ʈ�� ��ü�� �̹��� ���Ϸ� ����
function SaveImageToFile(const AFileName: string; AImage: TGraphic; AImageFormat: TWICImageFormat; const APixelFormat: byte; const AJpegCompressionQuality: integer): integer;
var
  IMG: TGraphic;
begin
  try
    try
      case AImageFormat of
        wifBmp:
        begin
          IMG := TBitmap.Create;
          case APixelFormat of
            1: TBitmap(IMG).PixelFormat := pf1bit;
            4: TBitmap(IMG).PixelFormat := pf4bit;
            8: TBitmap(IMG).PixelFormat := pf8bit;
            24: TBitmap(IMG).PixelFormat := pf24bit;
            32: TBitmap(IMG).PixelFormat := pf32bit;
          else
            TBitmap(IMG).PixelFormat := pf16bit; //�⺻��:16��Ʈ
          end;
        end;

        wifJpeg:
        begin
          IMG := TJpegImage.Create;
          TJpegImage(IMG).CompressionQuality := AJpegCompressionQuality;
          case APixelFormat of
            8: TJpegImage(IMG).PixelFormat := jf8Bit;
          else
            TJpegImage(IMG).PixelFormat := jf24Bit; //�⺻��:24��Ʈ
          end;
        end;

        wifPng:
        begin
          IMG := TPngImage.Create;
          TPngImage(IMG).Header.BitDepth := APixelFormat;
        end;
      else
        Result := -2; //�������� �ʴ� ���� ����
        Exit;
      end;

      IMG.Assign(AImage);
      IMG.SaveToFile(AFileName);
      Result := 0; //����
    except
      on E: Exception do
        Result := GetLastError;
    end;
  finally
    FreeAndNil(IMG);
  end;
end;

//��Ʈ�� ��ü�� Jpeg������ �̹��� ���Ϸ� ����
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, 16, 70);
end;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: Byte): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, APixelFormat, 70);
end;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: Byte; const AJpegCompressionQuality: Integer): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, APixelFormat, AJpegCompressionQuality);
end;

//��Ʈ�� �ڸ���
procedure CropBitmap(AInputBitmap, AOutputBitMap: TBitmap; const AStartX, AStartY, AWidth, AHeight: Integer);
begin
  AOutputBitMap.PixelFormat := AInputBitmap.PixelFormat;
  AOutputBitMap.Width := AWidth;
  AOutputBitMap.Height := AHeight;
  BitBlt(AOutputBitMap.Canvas.Handle, 0, 0, AWidth, AHeight, AInputBitmap.Canvas.Handle, AStartX, AStartY, SRCCOPY);
end;

//��Ʈ�� ��ü�� ������ ũ��� ����
(*
procedure ResizeBitmap(ABitmap: TBitmap; const ANewWidth, ANewHeight: Integer);
begin
  ABitmap.Canvas.StretchDraw(Rect(0, 0, ANewWidth, ANewHeight), ABitmap);
  ABitmap.SetSize(ANewWidth, ANewHeight);
end;
*)
procedure ResizeBitmap(ABitmap: TBitmap; const AWidth, AHeight: Integer; ABackgroundColor: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if not Assigned(ABitmap) then
    Exit;

  B := TBitmap.Create;
  try
    if (ABitmap.Width > ABitmap.Height) then
    begin
      R.Right := AWidth;
      R.Bottom := ((AWidth * ABitmap.Height) div ABitmap.Width);
      X := 0;
      Y := (AHeight div 2) - (R.Bottom div 2);
    end else begin
      R.Right := ((AHeight * ABitmap.Width) div ABitmap.Height);
      R.Bottom := AHeight;
      X := (AWidth div 2) - (R.Right div 2);
      Y := 0;
    end;

    R.Left := 0;
    R.Top := 0;
    B.PixelFormat := ABitmap.PixelFormat;
    B.Width := AWidth;
    B.Height := AHeight;
    B.Canvas.Brush.Color := ABackgroundColor;
    B.Canvas.FillRect(B.Canvas.ClipRect);
    B.Canvas.StretchDraw(R, ABitmap);
    ABitmap.Width := AWidth;
    ABitmap.Height := AHeight;
    ABitmap.Canvas.Brush.Color := ABackgroundColor;
    ABitmap.Canvas.FillRect(ABitmap.Canvas.ClipRect);
    ABitmap.Canvas.Draw(X, Y, B);
  finally
    B.Free;
  end;
end;

//������ ��¥�� ���ϴ� ���� ������ ���� ���Ѵ�.
function GetLastDayOfMonth(const ADateTime: TDateTime): shortint;
begin
  Result := -1;
  try
    Result := DayOf(EndOfTheMonth(ADateTime));
  except
    on E: Exception do {}
  end;
end;

//���ڿ�(WideSring & AnsiString)�� Bytes ������ ũ�⸦ ���Ѵ�.
function StrLength(const AText: string): integer;
var
  i: integer;
  S: string;
begin
  Result := 0;
  for i := 1 to Length(AText) do
  begin
    S := AText[i];
    if (Pos(S, CONST_SINGLE_CHARS) > 0) then
      Result := Result + 1
    else
      Result := Result + 2;
  end;
end;

//������ ���̸�ŭ ���ڿ��� ������ ä��
function LeftPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
var
  nRestLen: integer;
begin
  Result := AText;
  nRestLen := ALength - StrLength(AText);
  if (nRestLen < 1) then
    Exit;
  Result := StringOfChar(AFillChar, nRestLen) + AText;
end;

//������ ���̸�ŭ ���ڿ��� �������� ä��
function RightPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
var
  nRestLen: integer;
begin
  Result := Trim(AText);
  nRestLen := ALength - StrLength(AText);
  if (nRestLen < 1) then
    Exit;
  Result := AText + StringOfChar(AFillChar, nRestLen);
end;

//���ڿ��� ���� Slash ���� ����
function IncludeTrailingSlash(const AText: string): string;
begin
  Result := Trim(AText);
  if (not AText.IsEmpty) and (RightBStr(AText, 1) <> '/') then
    Result := AText + '/';
end;

//���ڿ��� ���� Slash ���� ����
function ExcludeTrailingSlash(AText: string): string;
begin
  Result := AText;
  if (RightBStr(AText, 1) = '/') then
    Result := Copy(AText, 1, Length(AText) - 1);
end;

//���ڿ����� �������� ��ȯ��
function GetNumStr(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
    if System.SysUtils.CharInSet(AValue[I], ['0'..'9']) then
      Result := (Result + AValue[I]);
end;

//���ϸ� ��ȯ
function DayOfWeekName(const ADate: TDate): string;
begin
  Result := DayOfWeekName(ADate, false);
end;
function DayOfWeekName(const ADate: TDate; const AHanja: Boolean): string;
//const
//  LA_DAY_OF_WEEKNAME: array[0..6] of string = ('��', 'ȭ', '��', '��', '��', '��', '��');
var
  Days: array[0..7] of string;
begin
  Days[0] := '  ';
  if AHanja then
  begin
    Days[1] := '��';
    Days[2] := '��';
    Days[3] := '��';
    Days[4] := '�';
    Days[5] := '��';
    Days[6] := '��';
    Days[7] := '��';
  end
  else
  begin
    Days[1] := '��';
    Days[2] := '��';
    Days[3] := 'ȭ';
    Days[4] := '��';
    Days[5] := '��';
    Days[6] := '��';
    Days[7] := '��';
  end;
  Result := Days[DayOfWeek(ADate)];
end;

//���� �ð� ���� (Administrator ���� �ʿ�)
function ChangeSystemTime(const ADateTime: TDateTime): Boolean;
var
  dSysTime: TSystemTime;
  sUserName: string;
begin
  Result := False;
  DateTimeToSystemTime(ADateTime, dSysTime);
  sUserName := GetCurrentUserName;
  try
    try
      AddPrivilege(sUserName, 'SeSystemtimePrivilege');
      SetLocalTime(dSysTime);
      Result := True;
    finally
      RemovePrivilege(sUserName, 'SeSystemtimePrivilege');
    end;
  except
  end;
end;

//Bitmap�� �̿��Ͽ� ���ڿ��� Display Width�� Height�� �ȼ� ������ ���Ѵ�.
procedure GetTextPixelSize(const AText: string; AFont: TFont; var AWidth, AHeight: integer);
var
  BMP: TBitmap;
begin
  BMP := TBitmap.Create;
  try
    BMP.Canvas.Font := AFont;
    AWidth := BMP.Canvas.TextWidth(AText);
    AHeight := BMP.Canvas.TextHeight(AText);
  finally
    FreeAndNil(BMP);
  end;
end;

//Null ó�� �Լ�:ORACLE�� NVL()�� ����
function NVL(const ATestValue, ANewValue: Variant): Variant;
begin
  Result := ATestValue;
  if VarIsNull(ATestValue) or
     VarIsEmpty(ATestValue) or
     (ATestValue = 'null') then
    Result := ANewValue;
end;

//���ڰ��� null���� Ȯ��
function IsNull(const AValue: Variant): Boolean;
begin
  Result := VarIsNull(AValue) or
            VarIsEmpty(AValue) or
            ((VarType(AValue) = varString) and (Trim(AValue) = EmptyStr));
end;

// OleVarian�� Stream���� ��ȯ
function OleVariantToStream(AOleValue: OleVariant): TMemoryStream;
var
  PData: PByteArray;
  nSize: integer;
begin
  Result := TMemoryStream.Create;
  try
    nSize := VarArrayHighBound (AOleValue, 1) - VarArrayLowBound (AOleValue, 1) + 1;
    if (nSize = 0) then
    begin
      if (Result <> nil) then
        Result.Free;
      Result := nil;
      Exit;
    end;

    PData := VarArrayLock(AOleValue);
    try
      Result.Position := 0;
      Result.WriteBuffer(PData^, nSize);
    finally
      VarArrayUnlock(AOleValue);
    end;
  except
    VarArrayUnlock(AOleValue);
    Result.Free;
    Result := nil;
  end;
end;

// Stream�� OleVarian�� ��ȯ
function StreamToVariant(AStream: TStream): OleVariant;
var
  p: Pointer;
begin
  Result := VarArrayCreate ([0, AStream.Size - 1], varByte);
  p := VarArrayLock (Result);
  try
    AStream.Position := 0;
    AStream.Read(p^, AStream.Size);
  finally
    VarArrayUnlock(Result);
  end;
end;

//IME �ѱ� �Է¸�� �˻�
//function IsHanState: Boolean;
//var
//  Mode: HIMC;
//  Conversion, Sentence: DWORD;
//begin
//  Mode := ImmGetContext(Application.Handle);
//  ImmGetConversionStatus(Mode, Conversion, Sentence);
//  Result := (Conversion = IME_CMODE_HANGEUL);
//end;
function IsHanState: Boolean;
var
   dwConversion, dwSentence: DWORD;
   hIMC: THandle;
begin
   HIMC := Imm32GetContext(Application.Handle);
   Imm32GetConversionStatus(hIMC, dwConversion, dwSentence);
   Imm32ReleaseContext(Application.Handle, hIMC);
   Result := (dwConversion = IME_CMODE_HANGEUL);
end;

//IME �Է¸�� ���� ���ѱ�:SetIMEMode(imKorean), ����:SetIMEMode(imEnglish)
procedure SetIMEMode(const AImeMode: TImeMode);
var
   dwConversion, dwSentence: DWORD;
   hIMC: THandle;
begin
   hIMC:= Imm32GetContext(Application.Handle);
   Imm32GetConversionStatus(hIMC, dwConversion, dwSentence);
   Case AImeMode Of
      imEnglish: Imm32SetConversionStatus(hIMC, IME_CMODE_ALPHANUMERIC, dwSentence);
      imKorean : Imm32SetConversionStatus(hIMC, IME_CMODE_NATIVE, dwSentence);
   end; {Case Value Of}
   Imm32ReleaseContext(Application.Handle, hIMC);
end;

//NumLock, CapsLock, ScrollLock ���� �б�
function GetKeybdState(const AKeyCode: integer): Boolean;
var
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Result := (KeyState[AKeyCode] = 1);
end;

//NumLock, CapsLock, ScrollLock ���� ����
procedure SetKeybdState(const AKeyCode: integer; const AIsOn: Boolean);
var
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  if (Byte(Ord(AIsOn)) <> KeyState[AKeyCode]) then
  begin
    Keybd_event(AKeyCode, $3A, KEYEVENTF_EXTENDEDKEY, 0);
    Keybd_event(AKeyCode, $3A, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
    KeyState[AKeyCode] := Ord(AIsOn);
    SetKeyboardState(KeyState);
  end;
end;

//���� Ű���� �Է� ó��
procedure SimulateKeyDown(AVirtualKey: Byte);
begin
  keybd_event(AVirtualKey, MapVirtualkey(AVirtualKey, 0), 0, 0);
end;

procedure SimulateKeyUp(AVirtualKey: Byte);
begin
  keybd_event(AVirtualKey, MapVirtualkey(AVirtualKey, 0), KEYEVENTF_KEYUP, 0);
end;

procedure SimulateKeyWithShift(AVirtualKey: Byte);
begin
  SimulateKeyWithShift(AVirtualKey, VK_SHIFT);
end;

procedure SimulateKeyWithShift(AVirtualKey, AShiftKey: Byte);
begin
  SimulateKeyDown(AShiftKey);
  SimulateKey(AVirtualKey);
  SimulateKeyUp(AShiftKey);
end;

procedure SimulateKey(AVirtualKey: Byte);
begin
  SimulateKeyDown(AVirtualKey);
  SimulateKeyUp(AVirtualKey);
end;

function KeybdHookHookCallback(ACode: integer; wParam: WPARAM; lParam: LPARAM): NativeInt; stdcall;
begin
  if (ACode >= 0) then
    if ((wParam = 229) and (lParam = -2147483647)) or
       ((wParam = 229) and (lParam = -2147483648.0)) then //NT�� (lParam = -2147483648)
    begin
      Result := Integer(True);
      Exit;
    end;

  Result := CallNextHookEx(SBGlobal_KeybdHook, ACode, wParam, lParam);
end;

procedure KeybdHookStart;
begin
  SBGlobal_KeybdHook := SetWindowsHookEx(WH_KEYBOARD, KeybdHookHookCallback, HInstance, GetCurrentThreadID);
end;

procedure KeybdHookStop;
begin
  UnHookWindowsHookEx(SBGlobal_KeybdHook);
end;

function MouseHookHookCallBack(ACode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  LP: Cardinal;
  WindowRect: TRect;
  MousePoint: TPoint;
begin
  if (ACode = HC_ACTION) then
    case wParam of
      WM_LBUTTONUP, WM_RBUTTONUP,
      WM_LBUTTONDOWN, WM_RBUTTONDOWN:
      begin
        GetWindowRect(SBGlobal_MouseThisHandle, WindowRect);
        MousePoint.X := PMSLLHOOKSTRUCT(lParam).pt.x;
        MousePoint.Y := PMSLLHOOKSTRUCT(lParam).pt.y;

        if PtInRect(WindowRect, MousePoint) then
        begin
          PMSLLHOOKSTRUCT(lParam).flags := 0;
          LP := (MousePoint.x shl 16) + MousePoint.y;
          PostMessage(SBGlobal_MouseThisHandle, CONST_WM_SEND_MOUSE, wParam, LP);
          Result := 1;
          Exit;
        end;
      end;
    end;
  Result := CallNextHookEx(SBGlobal_MouseHook, ACode, wParam, lParam);
end;

//���콺 ��ŷ
procedure MouseHookStart(const AHandle: THandle);
begin
  SBGlobal_MouseThisHandle := AHandle;
  SBGlobal_MouseHook := SetWindowsHookEx(WH_MOUSE_LL, @MouseHookHookCallBack, HInstance, GetCurrentThreadID);
end;

procedure MouseHookStop;
begin
  UnhookWindowsHookEx(SBGlobal_MouseHook);
end;

//Sleep() ��ü �Լ�
procedure SleepEx(const AMSecs: LongInt);
const
  _SECOND = -10000;
var
  hTimer: HWND;
  nBusy: LongInt;
  iDueTime: LARGE_INTEGER;
begin
  hTimer := CreateWaitableTimer(nil, True, 'WaitableTimer');
  try
    if (hTimer = 0) then
      Exit;

    iDueTime.QuadPart := _SECOND * AMSecs;
    SetWaitableTimer(hTimer, TLargeInteger(iDueTime), 0, nil, nil, False);
    repeat
      nBusy := MsgWaitForMultipleObjects(1, hTimer, False, INFINITE, QS_ALLINPUT);
      Application.ProcessMessages;
    until (nBusy = WAIT_OBJECT_0);
  finally
    CloseHandle(hTimer);
  end;
end;

procedure Delay(const AMSecs: LongInt);
var
  nTargetTime: LongInt;
  AMsg: TMsg;
begin
  nTargetTime := (GetTickCount + AMSecs);
  while (nTargetTime > GetTickCount) do
  if PeekMessage(AMsg, 0, 0, 0, PM_REMOVE) then
  begin
    if (AMsg.Message = WM_QUIT) then
    begin
      PostQuitMessage(AMsg.wParam);
      Break;
    end;
    TranslateMessage(AMsg);
    DispatchMessage(AMsg);
  end;
end;

//�ؽ�Ʈ ���� ���� �� ���
procedure WriteToFile(const AFileName, AStr: string; const ANewFile: Boolean);
var
  hFile: TextFile;
begin
  if ANewFile then
    DeleteFile(AFileName);

  AssignFile(hFile, AFileName);
  try
    try
      if FileExists(AFileName) then
        Append(hFile)
      else
        Rewrite(hFile);

      WriteLn(hFile, AStr);
    except
    end;
  finally
    CloseFile(hFile);
  end;
end;

//���ø����̼� ���� ���� ����
function GetAppVersion(const AIndex: Integer): string;
const
  VERSION_INFO: array[0..9] of string = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments');
var
  s, Locale: string;
  n, Len: DWORD;
  P: Pointer;
  Buf: PChar;
  Value: PChar;
begin
  Result := '?';
  s := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(s), n);
  if (n > 0) then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(s), 0, n, Buf);
      VerQueryValue(Buf, 'VarFileInfo\Translation', P, Len);
      Locale := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
      if VerQueryValue(Buf, PChar('StringFileInfo\' + Locale + '\' + VERSION_INFO[AIndex]), Pointer(Value), Len) then
        Result := Trim(Value);
    finally
      FreeMem(Buf, n);
    end;
  end;
end;

//DLL���� ��� ���� ���� ���� ����
function GetModuleVersion(const AFileName: string): string;
var
  wInfoSize: DWORD;
  PVerBuff: pointer;
  nVerSize, nWnd: UINT;
  PFFI: PVSFixedFileInfo;
begin
  Result := '';
  wInfoSize := GetFileVersioninfoSize(PChar(AFileName), nWnd);
  if (wInfoSize <> 0) then
  begin
    GetMem(PVerBuff, wInfoSize);
    try
      if GetFileVersionInfo(PChar(AFileName), nWnd, wInfoSize, PVerBuff) then
      begin
        VerQueryValue(PVerBuff, '\', Pointer(PFFI), nVerSize);
        Result := IntToStr(PFFI.dwFileVersionMS div $10000) + '.' +
                  IntToStr(PFFI.dwFileVersionMS and $0FFFF) + '.' +
                  IntToStr(PFFI.dwFileVersionLS div $10000) + '.' +
                  IntToStr(PFFI.dwFileVersionLS and $0FFFF);
      end;
    finally
      FreeMem(PVerBuff);
    end;
  end;
end;

//��� ������ ��� ��Ʈ�ѿ� DoubleBuffered ����
procedure SetDoubleBuffered(AControl: TWinControl; const ADoubleBuffered: Boolean);
var
  I: Integer;
begin
  AControl.DoubleBuffered := ADoubleBuffered;
  if AControl is TPanel then
    TPanel(AControl).FullRepaint := (not ADoubleBuffered);

  for I := 0 to Pred(AControl.ControlCount) do
    if (AControl.Controls[I] is TWinControl) then
      SetDoubleBuffered(TWinControl(AControl.Controls[I]), ADoubleBuffered);
end;
//procedure SetDoubleBuffered(AControl: TWinControl; ADoubleBuffered: Boolean);
//var
//  I: Integer;
//begin
//  AControl.DoubleBuffered := ADoubleBuffered;
//  if ADoubleBuffered then
//  begin
//    AControl.ControlStyle := AControl.ControlStyle + [csOpaque];
//    if AControl is TPanel then
//      TPanel(AControl).FullRepaint := False;
//
//    for I := 0 to Pred(AControl.ControlCount) do
//      if (AControl.Controls[I] is TWinControl) then
//      begin
//        SetDoubleBuffered(TWinControl(AControl.Controls[I]), ADoubleBuffered);
//        TWinControl(AControl.Controls[I]).ControlStyle := TWinControl(AControl.Controls[I]).ControlStyle + [csOpaque];
//      end
//      else if (AControl.Controls[i] is TGraphicControl) or
//         (AControl.Controls[I] is TControl) then
//      begin
//        AControl.Controls[I].ControlStyle := AControl.Controls[I].ControlStyle + [csOpaque];
//      end;
//  end;
//end;

//Check Existing File(64bit)
function FileExists64(const AFileName: string): Boolean;
type
  TWow64DisableWow64FsRedirection = function(var Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
  TWow64EnableWow64FsRedirection  = function(Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
var
  hHandle: THandle;
  Wow64DisableWow64FsRedirection: TWow64DisableWow64FsRedirection;
  Wow64EnableWow64FsRedirection: TWow64EnableWow64FsRedirection;
  Wow64FsEnableRedirection: LongBool;
begin
  hHandle := GetModuleHandle('kernel32.dll');
  @Wow64EnableWow64FsRedirection  := GetProcAddress(hHandle, 'Wow64EnableWow64FsRedirection');
  @Wow64DisableWow64FsRedirection := GetProcAddress(hHandle, 'Wow64DisableWow64FsRedirection');
  if (hHandle <> 0) and
     (@Wow64EnableWow64FsRedirection <> nil) and
     (@Wow64DisableWow64FsRedirection <> nil) then
  begin
    Wow64DisableWow64FsRedirection(Wow64FsEnableRedirection);
    Result := FileExists(AFileName);
    Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection);
  end
  else
    Result:=False;
end;

//Check 64bit Windows
function IsWin64: Boolean;
var
  Kernel32Handle: THandle;
  IsWow64Process: function(AHandle: Winapi.Windows.THandle; var ARes: Winapi.Windows.BOOL): Winapi.Windows.BOOL; stdcall;
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;
  isWoW64: Bool;
  SystemInfo: TSystemInfo;
const
  PROCESSOR_ARCHITECTURE_AMD64 = 9;
  PROCESSOR_ARCHITECTURE_IA64  = 6;
begin
  Kernel32Handle := GetModuleHandle('kernel32.dll');
  if (Kernel32Handle = 0) then
    Kernel32Handle := LoadLibrary('kernel32.dll');
  if (Kernel32Handle <> 0) then
  begin
    IsWOW64Process := GetProcAddress(Kernel32Handle, 'IsWow64Process');
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle, 'GetNativeSystemInfo');
    if Assigned(IsWow64Process) then
    begin
      IsWow64Process(GetCurrentProcess,isWoW64);
      Result := isWoW64 and Assigned(GetNativeSystemInfo);
      if Result then
      begin
        GetNativeSystemInfo(SystemInfo);
        Result := (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) or
                  (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);
      end;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

//��ȸ�� �ſ�ī���ȣ
function GetHideCreditCardNo(const ACreditCardNo: string): string;
begin
  Result := ACreditCardNo;
  if (ACreditCardNo <> EmptyStr) then
    Result := Format('%s-%s-****-%s', [Copy(ACreditCardNo, 1, 4), Copy(ACreditCardNo, 5, 4), Copy(ACreditCardNo, 13, 4)]);
end;

//������ �߰� �Ŀ� CalcField �� �ٷ� �ݿ����� �ʴ� ���� ��ġ��
procedure RefreshCalcField(ADataSet: TDataSet);
var
  BM: TBookmark;
begin
  BM := ADataSet.GetBookmark;
  with ADataset do
  try
    if ADataSet.BookmarkValid(BM) then
      ADataSet.GotoBookmark(BM);
  finally
    ADataSet.FreeBookmark(BM);
  end;
end;

//yyyymmdd ������ ��¥�� yyyy-mm-dd �������� ��ȯ
function FormattedDateString(const ADateString: string): string;
begin
  Result := ADateString;
  if (Pos('-', ADateString) > 0) then
    Exit;
  if (ADateString <> EmptyStr) and (Length(ADateString) = 8) then
    Result := Copy(ADateString, 1, 4) + '-' + Copy(ADateString, 5, 2) + '-' + Copy(ADateString, 7, 2);
end;

//hhnnss ������ �ð��� hh:nn:ss �������� ��ȯ

function FormattedTimeString(const ATimeString: string): string;
begin
  Result := ATimeString;
  if (Pos(':', ATimeString) > 0) then
    Exit;
  if (ATimeString <> EmptyStr) then
    if (Length(ATimeString) = 4) then
      Result := Copy(ATimeString, 1, 2) + ':' + Copy(ATimeString, 3, 2)
    else if (Length(ATimeString) = 6) then
      Result := Copy(ATimeString, 1, 2) + ':' + Copy(ATimeString, 3, 2) + ':' + Copy(ATimeString, 5, 2);
end;

//���н� �ð��� ���ڿ��� ��ȯ
function UnixTimeToString(const AUnixTime: string; const AFormatStr: string): string;
var
  nUnixTime: Int64;
  dDateTime: TDateTime;
begin
  Result := '';
  nUnixTime := StrToInt64Def(AUnixTime, 0) div 1000; //�и��� ����
  try
    if (nUnixTime > 0) then
    begin
      dDateTime := UnixToDateTime(nUnixTime, False); //not UTC(���������: Coordinated Universal Time)
      Result := FormatDateTime(AFormatStr, dDateTime, FormatSettings);
    end;
  except
  end;
end;

//Ư������ ����
function RemoveSpecialChar(const ASource: string): string;
var
  I: Integer;
begin
  for I := 1 to Length(ASource) do
    if CharInSet(ASource[I], ['A'..'Z', 'a'..'z', '0'..'9']) then
      Result := Result + ASource[I];
end;

//������Ʈ���� ���� ���α׷����� ����ϱ�
procedure RunOnWindownStart(const AppTitle, AppFile: string; const ARunOnce: Boolean=False);
var
  Reg: TRegistry;
  TheKey: string;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  TheKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  if ARunOnce then
    TheKey := TheKey + 'Once';
  Reg.OpenKey(TheKey, True);
  Reg.WriteString(AppTitle, AppFile);
  Reg.CloseKey;
  Reg.Free;
end;

//������Ʈ���� ���� ���α׷����� �����ϱ�
function RemoveFromRunOnWindowStart(const AppTitle: string): Boolean;
var
  Reg: TRegistry;
  TheKey: string;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  TheKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  if Reg.OpenKey(TheKey, False) then
    Result := Reg.DeleteValue(AppTitle);
  Reg.CloseKey;
  Reg.Free;
end;

//������ �ý��� ����
procedure SystemShutdown(const ATimeOut: DWORD; const AForceClose, AReboot: Boolean);
var
  PreviosPrivileges: ^TTokenPrivileges;
  TokenPrivileges: TTokenPrivileges;
  hToken: THandle;
  tmpReturnLength: dword;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
    begin
      LookupPrivilegeValue(nil, 'SeShutdownPrivilege', TokenPrivileges.Privileges[0].Luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tmpReturnLength := 0;
      PreviosPrivileges := nil;
      AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, PreviosPrivileges^, tmpReturnLength);
      if InitiateSystemShutdown(nil, nil, ATimeOut, AForceClose, AReboot) then
      begin
        TokenPrivileges.Privileges[0].Attributes := 0;
        AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, PreviosPrivileges^, tmpReturnLength);
      end;
    end ;
  end
  else
    ExitWindowsEx(EWX_FORCE or EWX_SHUTDOWN or EWX_POWEROFF, 0);
end;

//������ Window�� �ֻ����� ǥ����
procedure SetWindowOnTop(const AHandle: HWND);
var
  Inp: TInput;
begin
  ZeroMemory(@Inp, SizeOf(Inp));
  SendInput(1, Inp, SizeOf(Inp));
  SetForegroundWindow(AHandle);
end;
procedure SetWindowOnTop2(const AHandle: HWND);
var
  lpRect: TRect;
begin
  if GetWindowRect(AHandle, lpRect) then
    SetWindowPos(AHandle, HWND_TOPMOST, lpRect.left, lpRect.top, lpRect.Right-lpRect.left, lpRect.Bottom-lpRect.Top, SWP_SHOWWINDOW);
end;

//������ �������� ���α׷� ����
//Example: RunAsAdmin(Handle, 'c:\Windows\system32\cmd.exe', '');
function RunAsAdmin(const AHandle: HWND; const APath, AParams: string): Boolean;
var
  SI: TShellExecuteInfoA;
begin
  FillChar(SI, SizeOf(SI), 0);
  SI.cbSize := SizeOf(SI);
  SI.Wnd := AHandle;
  SI.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  SI.lpVerb := 'runas';
  SI.lpFile := PAnsiChar(APath);
  SI.lpParameters := PAnsiChar(AParams);
  SI.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@SI);
end;

function GetSysDir: string;
var
  ABuffer: array[0..MAX_PATH] of Char;
begin
  GetSystemDirectory(ABuffer, MAX_PATH - 1);
  SetLength(Result, StrLen(ABuffer));
  Result := ABuffer;
end;

function GetSysDir(const AFloder: Integer): string;
var
  PPath: PChar;
begin
  Result := '';
  GetMem(PPath, MAX_PATH);
  try
    SHGetFolderPath(0, AFloder, 0, 0, PPath);
    Result := Copy(PPath, 0, Length(PPath));
  finally
    FreeMem(PPath);
  end;
end;

//��ȣȭ
function StrEncrypt(const AStr: AnsiString): AnsiString;
const
  HexData: array[0..9] of Integer = (186, 165, 20, 188, 61, 85, 171, 61, 244, 164);
var
  I, nKey, nRndCnt: Integer;
  sRet, sTemp: AnsiString;
  PWord: ^AnsiChar;
begin
  Randomize;
  nKey := Random(254);
  nRndCnt := Random(9) + 5;
  sRet := sRet + Format('%.2X', [((nRndCnt xor nKey) xor HexData[5])]);
	nKey := nKey xor HexData[9];
  for I := 1 to nRndCnt do
    sRet := sRet + Format('%.2X', [Random(254) xor nKey]);

	nKey := nKey xor HexData[5];
  I := 0;
  while (I < Length(AStr)) do
  begin
    PWord := Pointer(PAnsiChar(AStr) + I);
    sTemp := Format('%.2X', [(Ord(PWord^) xor nKey) xor HexData[I mod 10]]);
    sRet := sRet + sTemp;
    Inc(I);
  end;

  sTemp := Format('%.2X', [nKey]);
  Result := sTemp + sRet;
end;

//��ȣȭ
function StrDecrypt(const AStr: AnsiString): AnsiString;
const
  HexData: array[0..9] of Integer = (186, 165, 20, 188, 61, 85, 171, 61, 244, 164);
var
  I, nLen, nPos, nKey, nBaseKey, nRndCnt, nTemp: Integer;
  sRet, sTemp: AnsiString;
begin
  Result := '';
  nLen := Length(AStr);
  if (nLen < 6) then
    Exit;

  nBaseKey := StrToInt('$' + Copy(AStr, 1, 2));
	nKey := nBaseKey xor HexData[5];
	nKey := nKey xor HexData[9];
  nRndCnt := ((StrToInt('$' + Copy(AStr, 3, 2)) xor HexData[5]) xor nKey);
	nPos := 4 + nRndCnt * 2 + 1;
	if (nLen <= nPos) then
    Exit;

	nKey := nBaseKey;
  I := 0;
  while (nPos < nLen) do
  begin
    sTemp := '$' + Copy(AStr, nPos, 2);
    nTemp := ((StrToInt(sTemp) xor HexData[i mod 10]) xor nKey);
    sRet := sRet + Chr(nTemp);
    Inc(I);
    nPos := nPos + 2;
  end;
  Result := sRet;
end;

function StrEncryptEx(const ADecrypt: WideString; AKey: Word): string;
var
  I: Integer;
  RStr: RawByteString;
  RStrB: TBytes absolute RStr;
begin
  Result := '';
  RStr := UTF8Encode(ADecrypt);
  for I := 0 to Length(RStr) - 1 do
  begin
    RStrB[I] := RStrB[I] xor (AKey shr 8);
    AKey := (RStrB[I] + AKey) * C_SEED_KEY1 + C_SEED_KEY2;
  end;
  for I := 0 to Length(RStr) - 1 do
    Result := Result + IntToHex(RStrB[I], 2);
end;

function StrDecryptEx(const AEncrypt: string; AKey: Word): string;
var
  I, nTmpKey: Integer;
  RStr: RawByteString;
  RStrB: TBytes absolute RStr;
  sTmpStr: string;
begin
  sTmpStr := UpperCase(AEncrypt);
  SetLength(RStr, Length(sTmpStr) div 2);
  I := 1;
  try
    while (I < Length(sTmpStr)) do
    begin
      RStrB[I div 2] := StrToInt('$' + sTmpStr[I] + sTmpStr[I + 1]);
      Inc(I, 2);
    end;
  except
    Result:= '';
    Exit;
  end;
  for I := 0 to Length(RStr) - 1 do
  begin
    nTmpKey := RStrB[I];
    RStrB[I] := RStrB[i] xor (AKey shr 8);
    AKey := (nTmpKey + AKey) * C_SEED_KEY1 + C_SEED_KEY2;
  end;
  Result := UTF8Decode(RStr);
end;

function LPadB(const AStr: string; ALength: Integer): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), ' ') + Result;
end;

function RPadB(const AStr: string; ALength: Integer): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), ' ');
end;

function PadChar(ALength: Integer; APadChar: Char = ' '): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to ALength do
    Result := Result + APadChar;
end;

function SCopy(const AText: string; const AByteStart, AByteCount: Integer): string;
var
  Index, Start, Cnt: Integer;
begin
  Result := '';
  Start := 1;
  Cnt := 0;
  // ������ġ�� �˾Ƴ���.
  for Index := 1 to Length(AText) do
  begin
    Start := Index;
    // ASCII �ڵ尪 #$00FF ���� ũ�� 2Byte ���ڷ� ����Ѵ�.
    Cnt := Cnt + IIF(AText[Index] <= #$00FF, 1, 2);
    if Cnt >= AByteStart then Break;
  end;
  if AByteStart > Cnt then Exit;
  Cnt := 0;
  // ���̸�ŭ �ڸ���.
  for Index := Start to Length(AText) do
  begin
    Cnt := Cnt + IIF(AText[Index] <= #$00FF, 1, 2);
    if Cnt <= AByteCount then
      Result := Result + AText[Index]
    else
      Break;
  end;
end;

function ByteLen(const AText: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 1 to Length(AText) do
    Result := Result + IIF(AText[Index] <= #$00FF, 1, 2);
end;

function Base64Encode(const AData: string; const AConvertUTF8: Boolean=False): string;
var
  UTF8: UTF8String;
begin
  if AConvertUTF8 then
  begin
    UTF8 := UTF8String(AData);
    Result := EncdDecd.EncodeBase64(PChar(UTF8), Length(UTF8));
  end
  else
    Result := EncdDecd.EncodeBase64(PChar(AData), Length(AData));
end;

function Base64EncodeA(const AData: string; const AConvertUTF8: Boolean=False): string;
var
  UTF8: UTF8String;
begin
  if AConvertUTF8 then
  begin
    UTF8 := UTF8String(AData);
    Result := EncdDecd.EncodeBase64(PAnsiChar(UTF8), Length(UTF8));
  end
  else
    Result := EncdDecd.EncodeBase64(PAnsiChar(AData), Length(AData));
end;

function Base64Decode(const AData: string): string;
var
  Bytes: TBytes;
  UTF8: UTF8String;
begin
  Bytes := EncdDecd.DecodeBase64(AData);
  SetLength(UTF8, Length(Bytes));
  Move(Pointer(Bytes)^, Pointer(UTF8)^, Length(Bytes));
  Result := String(UTF8);
end;

function Base64DecodeStream(const AStream: TStream): string;
var
  MS: TMemoryStream;
  sValue: string;
begin
  Result := '';
  MS := TMemoryStream.Create;
  with TIdEncoderMIME.Create(nil) do
  try
    AStream.Position := 0;
    DecodeStream(AStream, MS);
    SetLength(sValue, MS.Size);
    MS.ReadBuffer(Pointer(sValue)^, MS.Size);
    Result := sValue;
  finally
    MS.Free;
    Free;
  end;
end;

function Base64EncodeStream(const AStream: TStream): string;
begin
  Result := '';
  with TIdEncoderMIME.Create(nil) do
  try
    AStream.Position := 0;
    Result := EncodeStream(AStream);
  finally
    Free;
  end;
end;

function Base64EncodeGraphic(AImage: TGraphic): string;
var
  MS: TMemoryStream;
begin
  Result := '';
  MS := TMemoryStream.Create;
  with TIdEncoderMIME.Create(nil) do
  try
    AImage.SaveToStream(MS);
    MS.Position := 0;
    Result := EncodeStream(MS);
  finally
    MS.Free;
    Free;
  end;
end;

function Base64EncodeFile(const AFileName: string): string;
var
  FS: TFileStream;
begin
  Result := '';
  FS := TFileStream.Create(AFileName, fmOpenRead);
  with TIdEncoderMIME.Create(nil) do
  try
    FS.Position := 0;
    Result := EncodeStream(FS);
  finally
    FS.Free;
    Free;
  end;
end;

function BCC(const AValue: AnsiString): string;
var
  i, nBCC: Integer;
begin
  nBCC := 0;
  for i := 1 to Length(AValue) do
    nBCC := nBCC xor Ord(AValue[i]);
  nBCC := nBCC or $20;
  Result := Char(nBcc);
end;

function LRC(const AValue: AnsiString; const ACheckLen: Integer=0): Byte;
var
  I, nLen: Integer;
begin
  nLen := ACheckLen;
  if (ACheckLen = 0) then
    nLen := Length(AValue);

  Result := 0;
  for I := 1 to nLen do
    Inc(Result, Ord(AValue[I]));

  Result := (Result xor $FF) + 1; //Result := (not Result) + 1;
end;

function StringToHex(const AValue: AnsiString): string;
begin
  SetLength(Result, Length(AValue) * 2);
  BinToHex(PAnsiChar(AValue), PChar(Result), Length(AValue));
end;

function HexToString(const AValue: string): AnsiString;
begin
  SetLength(Result, Length(AValue) div 2);
  HexToBin(PChar(AValue), PAnsiChar(Result), Length(Result));
end;

function BytesToHex(const ABytes: TBytes): string;
var
  I: Integer;
begin
  Result := '';
  for I := Low(ABytes) to High(ABytes) do
    Result := Result + IntToHex(ABytes[I]) + ' ';
end;

function StringToBytes(const AValue: WideString): TBytes;
begin
  SetLength(Result, Length(AValue) * SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(AValue[1], Result[0], Length(Result));
end;

function BytesToString(const AValue: TBytes): WideString;
begin
  SetLength(Result, Length(AValue) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(AValue[0], Result[1], Length(AValue));
end;

function StringToArrayOfByte(const AValue: AnsiString): TArrayOfByte;
var
  I: Integer;
begin
  SetLength(Result, Length(AValue));
  for I := 0 to Length(AValue) - 1 do
    Result[I] := ord(AValue[I + 1]) - 48;
end;

function ArrayOfByteToString(const AValue: TArrayOfByte): AnsiString;
var
  I: Integer;
  C: Char;
  S: string;
begin
  S := '';
  for I := Length(AValue) - 1 downto 0 do
  begin
    C := Chr(AValue[i] + 48);
    S := C + S;
  end;
  Result := S;
end;

function GetIdleSeconds: DWord;
var
  LI: TLastInputInfo;
begin
  LI.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LI);
  Result := (GetTickCount - LI.dwTime) div 1000;
end;

function MakeRoundedControl(AControl: TWinControl; const AEllipseWidth: Integer; const AEllipseHeight: Integer): Boolean;
var
  R: TRect;
  Rgn: HRGN;
begin
  (*
  //TForm
  Form1.BorderStyle := bsNone;
  MakeRoundedControl(Form1);
  //TMemo:
  Memo1.BorderStyle := bsNone;
  MakeRoundedControl(Memo1);
  //TEdit:
  Edit2.BorderStyle := bsNone;
  MakeRoundedControl(Edit2);
  //TPanel:
  MakeRoundedControl(Panel1);
  //TStaticText:
  MakeRoundedControl(StaticText1);
  *)
  Result := False;
  with AControl do
  begin
    R := ClientRect;
    Rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, AEllipseWidth, AEllipseHeight);
    if not VarIsNull(Rgn) then
    begin
      Perform(EM_GETRECT, 0, lParam(@R));
      InflateRect(R, -5, -5);
      Perform(EM_SETRECTNP, 0, lParam(@R));
      SetWindowRgn(Handle, Rgn, True);
      Invalidate;
      Result := True;
    end;
  end;
end;

procedure TransparentPanel(var APanel: TPanel);
var
  I, X, Y : Integer;
  FullRgn, ClientRgn, ControlRgn : THandle;
  Margin, MarginX, MarginY : Integer;
begin
  Margin := (APanel.Width - APanel.ClientWidth) div 2;
  MarginX := Margin;
  MarginY := APanel.Height - APanel.ClientHeight - Margin;
  FullRgn := CreateRectRgn(0, 0, APanel.Width, APanel.Height);
  ClientRgn := CreateRectRgn(MarginX, MarginY, MarginX + APanel.ClientWidth, MarginY + APanel.ClientHeight);
  CombineRgn(FullRgn, FullRgn, ClientRgn, RGN_DIFF);
  for I := 0 to APanel.ControlCount - 1 do
  begin
    X := MarginX + APanel.Controls[I].Left;
    Y := MarginY + APanel.Controls[I].Top;
    ControlRgn := CreateRectRgn(X, Y, X + APanel.Controls[I].Width, Y + APanel.Controls[I].Height);
    CombineRgn(FullRgn, FullRgn, ControlRgn, RGN_OR);
  end;
  SetWindowRgn(APanel.Handle, FullRgn, True);
end;

(*
  AScale = 0 ~
  AEncodingMethod = 0 ~ 5
    0: Auto
    1: Numeric
    2: Alphanumeric
    3: ISO-8859-1
    4: UTF-8 without BOM
    5: UTF-8 without BOM
  AQuietZone = QR�ڵ� �׵θ� ����(pixels))
*)
function GenerateQRCode(ABitmap: TBitmap; const AText: string; const AScale, AEncodingMethod, AQuietZone: Integer; var AErrMsg: string): Boolean;
var
  QRCode: TDelphiZXingQRCode;
  nRow, nCol: Integer;
begin
  Result := False;
  AErrMsg := '';
  QRCode := TDelphiZXingQRCode.Create;
  try
    try
      QRCode.Data := AText;
      QRCode.Encoding := TQRCodeEncoding(AEncodingMethod);
      QRCode.QuietZone := AQuietZone;
      ABitmap.SetSize(QRCode.Rows, QRCode.Columns);
      for nRow := 0 to Pred(QRCode.Rows) do
        for nCol := 0 to Pred(QRCode.Columns) do
          if (QRCode.IsBlack[nRow, nCol]) then
            ABitmap.Canvas.Pixels[nCol, nRow] := clBlack
          else
            ABitmap.Canvas.Pixels[nCol, nRow] := clWhite;
      ResizeBitmap(ABitmap, QRCode.Columns * AScale, QRCode.Rows * AScale, clWhite);
      Result := True;
    finally
      QRCode.Free;
    end;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

procedure FreeAndNilJSONObject(AObject: TJSONAncestor);

begin
  try
    if Assigned(AObject) then
    begin
      AObject.Owned := False;
      AObject.Free;
    end;
  except
  end;
end;

function GetProcessId(const AFilePath: string): NativeInt;
const
  PROCESS_TERMINATE = $0001;
var
  bContinue: BOOL;
  hSnapshot: THandle;
  PE32: TProcessEntry32;
begin
  Result := 0;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  PE32.dwSize := Sizeof(PE32);
  bContinue := Process32First(hSnapshot, PE32);
  while (Integer(bContinue) <> 0) do
  begin
    if ((UpperCase(ExtractFileName(PE32.szExeFile)) = UpperCase(AFilePath)) or
        (UpperCase(PE32.szExeFile) = UpperCase(AFilePath))) then
    begin
      Result := PE32.th32ProcessID;;
      Exit;
    end
    else
      Result:=0;

    bContinue := Process32Next(hSnapshot, PE32);
  end;
  CloseHandle(hSnapshot);
end;

function GetProcessHandle(const AFilePath: string): NativeInt;
var
  PE32: TProcessEntry32;
  hSnapshot: THandle;
  sFileName: string;
begin
  Result := 0;
  sFileName := ExtractFileName(AFilePath);
  PE32.dwSize := SizeOf(TProcessEntry32);
  hSnapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(hSnapshot, PE32) then
  try
    repeat
      if CompareText(PE32.szExeFile, sFileName) = 0 then
      begin
        Result := hSnapshot;
        Break;
      end;
    until not Process32Next(hSnapshot, PE32);
  finally
    CloseHandle(hSnapshot);
  end;
end;

function KillProcess(const AProcName: string): Boolean;
var
  PE32: TProcessEntry32;
  hHandle, hProcess: THandle;
  bIsNext: Boolean;
begin
  Result := False;
  PE32.dwSize := SizeOf(TProcessEntry32);
  PE32.th32ProcessID := 0;
  hHandle :=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    if Process32First(hHandle, PE32) then
      repeat
        bIsNext := Process32Next(hHandle, PE32);
        if (AnsiCompareText(PE32.szExeFile, Trim(AProcName)) = 0) then
          Break;
      until not bIsNext;
  finally
    CloseHandle(hHandle);
  end;

  if (PE32.th32ProcessID <> 0) then
  begin
    hProcess := OpenProcess(PROCESS_TERMINATE, True, PE32.th32ProcessID);
    try
      if (hProcess <> 0) then
        if not TerminateProcess(hProcess, 0) then
          Exit;

      Result := True;
    finally
      CloseHandle(hProcess);
    end;
  end;
end;

function KillProcessByHandle(const AHandle: NativeInt): Boolean;
var
  hPID: Integer;
  PH: HWND;
  DWResult: DWORD;
begin
  Result := False;
  SendMessageTimeout(AHandle, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  if IsWindow(AHandle) then
  begin
    GetWindowThreadProcessId(AHandle, @hPID);
    if (hPID <> 0) then
    begin
      PH := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION, False, hPID);
      if (PH <> 0) then
      begin
        TerminateProcess(PH, 0);
        CloseHandle(PH);
        Result := True;
      end;
    end;
  end;
end;

function KillProcessByPID(const AProcessId: NativeInt): Boolean;
var
  hKiller: THandle;
begin
  hKiller := OpenProcess(PROCESS_TERMINATE, False, AProcessID);
  Result := TerminateProcess(hKiller, 0);
end;

function InvertColor(const Color: TColor): TColor;
begin
  Result := TColor(RGB(255 - GetRValue(Color), 255 - GetGValue(Color), 255 - GetBValue(Color)));
end;

function InvertColor2(const Color: TColor): TColor;
begin
  if ((GetRValue(Color) + GetGValue(Color) + GetBValue(Color)) > 384) then
    Result := clBlack
  else
    Result := clWhite;
end;

function GetMemoryUsed: UInt64;
var
  ST: TMemoryManagerState;
  SB: TSmallBlockTypeState;
begin
  GetMemoryManagerState(ST);
  Result := ST.TotalAllocatedMediumBlockSize + ST.TotalAllocatedLargeBlockSize;
  for SB in ST.SmallBlockTypeStates do
    Result := Result + SB.UseableBlockSize * SB.AllocatedBlockCount;
end;

function ReadMWord(FS: TFileStream): Word;
type
  TMotorolaWord = record
  case byte of
    0: (Value: Word);
    1: (Byte1, Byte2: Byte);
end;
var
  MW: TMotorolaWord;
begin
  FS.Read(MW.Byte2, SizeOf(Byte));
  FS.Read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

procedure GetJpgSize(const AFileName: string; var AWidth, AHeight: Integer);
const
  ValidSig : array[0..1] of Byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  Sig: array[0..1] of byte;
  FS: TFileStream;
  X: Integer;
  Seg: Byte;
  Dummy: array[0..15] of Byte;
  Len: Word;
  ReadLen: LongInt;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    ReadLen := FS.Read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if (Sig[X] <> ValidSig[X]) then
        ReadLen := 0;

    if (ReadLen > 0) then
    begin
      ReadLen := FS.Read(Seg, 1);
      while (Seg = $FF) and (ReadLen > 0) do
      begin
        ReadLen := FS.Read(Seg, 1);
        if (Seg <> $FF) then
        begin
          if (Seg = $C0) or (Seg = $C1) then
          begin
            ReadLen := FS.Read(Dummy[0], 3);
            AHeight := ReadMWord(FS);
            AWidth := ReadMWord(FS);
          end
          else
          begin
            if not (Seg in Parameterless) then
            begin
              Len := ReadMWord(FS);
              FS.Seek(Len - 2, 1);
              FS.Read(Seg, 1);
            end
            else
              Seg := $FF;
          end;
        end;
      end;
    end;
  finally
    FS.Free;
  end;
end;

procedure GetPngSize(const AFileName: string; var AWidth, AHeight: Integer);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137, 80, 78, 71, 13, 10, 26, 10);
var
  Sig: TPNGSig;
  FS: TFileStream;
  X: integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    FS.Read(Sig[0], SizeOf(Sig));
    for X := Low(Sig) to High(Sig) do
      if (Sig[X] <> ValidSig[X]) then
        Exit;

      FS.Seek(18, 0);
      AWidth := ReadMWord(FS);
      FS.Seek(22, 0);
      AHeight := ReadMWord(FS);
  finally
    FS.Free;
  end;
end;

//ListView ���� �ٲٱ�
procedure ExchangeListItems(AListView: TListView; const AIndex1, AIndex2: Integer);
var
  LI: TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    LI := TListItem.Create(AListView.Items);
    LI.Assign(AListView.Items.Item[AIndex1]);
    AListView.Items.Item[AIndex1].Assign(AListView.Items.Item[AIndex2]);
    AListView.Items.Item[AIndex2].Assign(LI);
    AListView.Selected := AListView.Items[AIndex2];
    LI.Free;
  finally
    AListView.Items.EndUpdate;
  end;
end;

procedure CopyDataString(const AHandle: HWND; const AMsg: Cardinal; const AData: string);
var
  CDS: TCopyDataStruct;
begin
  with CDS do
  begin
    cbData := Length(AData) + 1;
    lpData := pChar(AData + #0);
  end;
  SendMessage(AHandle, AMsg, 0, LongInt(@CDS));
end;


(***************************************************************************************************

function GetMyIP: string;

var
  IdIPWatch: TIdIPWatch;
begin
  IdIPWatch := TIdIPWatch.Create(nil);
  try
    Result := IdIPWatch.LocalIP;
  finally
    FreeAndNil(IdIPWatch);
  end;
end;


function MessageDlgEx(const AMsg: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AHelpContext: Integer): Integer;

begin
  Screen.MessageFont.Size := 12;
  Screen.MessageFont.Color := clRed;
  with CreateMessageDialog(AMsg, ADlgType, AButtons) do
  try
    Caption := 'XPartners';
    Color := clWhite;
    Font.Size := 10;
    Font.Color := clBlue;
    Font.Name := 'Noto Sans CJK KR Regular';
//    TButton(FindComponent('Message')).Font.Color := clLime;
//    TButton(FindComponent('Message')).Font.Size := 10;
//    TLabel(FindComponent('Message')).Font.Name := 'Noto Sans CJK KR Regular';
//    TLabel(FindComponent('Message')).Font.Size := 10;
//    TLabel(FindComponent('Message')).Font.Style := [fsBold];
    Result := ShowModal;
  finally
    Free;
  end;
end;

***************************************************************************************************)

end.
