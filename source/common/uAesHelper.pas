(*******************************************************************************

  Filename    : uAesHelper.pas
  Author      : ÀÌ¼±¿ì
  Description : AES256 Encryption/Decryption Helper
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2021-09-30   Initial Release.

*******************************************************************************)
unit uAesHelper;

interface

uses
  System.SysUtils, System.NetEncoding;

type
  { AES Encrypt/Decrypt }
  TKeySizeAES = (ksAES128, ksAES256);
  TChainingMode = (cmCBC, cmCFB8bit, cmCFBblock, cmOFB, cmCTR, cmECB);
  TPaddingMode = (pmZeroPadding, pmANSIX923, pmISO10126, pmISO7816, pmPKCS7, pmRandomPadding);
  TCipherAES = class
  private
    FKey: TBytes;
    FInitVector: TBytes;
    FKeySize: Integer;
    FEncoding: TEncoding;
    FChainingMode: TChainingMode;
    FPaddingMode: TPaddingMode;

    procedure EncryptAES(const AData: TBytes; var ACrypt: TBytes); overload;
    procedure DecryptAES(const ACrypt: TBytes; var AData: TBytes); overload;
    procedure BytePadding(var AData: TBytes; ABlockSize: Integer);
    function GetSecureKey: string;
    function GetInitVector: string;
  public
    constructor Create(const AKey: string; const AKeySize: Integer; const AInitVector: string;
      const AEncoding: TEncoding; const AChainingMode: TChainingMode; const APaddingMode: TPaddingMode);
    destructor Destroy; override;

    function Decrypt(const AValue: string): string;
    function Encrypt(const AValue: string): string;

    property SecureKey: string read GetSecureKey;
    property InitVector: string read GetInitVector;
  end;

implementation

uses
  DCPrijndael;

{ TCipherAES }

constructor TCipherAES.Create(const AKey: string; const AKeySize: Integer; const AInitVector: string;
  const AEncoding: TEncoding; const AChainingMode: TChainingMode; const APaddingMode: TPaddingMode);
begin
  inherited Create;

  FKey := AEncoding.GetBytes(AKey);
  FInitVector := AEncoding.GetBytes(AInitVector);
  FKeySize := AKeySize;
  FEncoding := AEncoding;
  FChainingMode := AChainingMode;
  FPaddingMode := APaddingMode;
end;

destructor TCipherAES.Destroy;
begin

  inherited;
end;

function TCipherAES.Decrypt(const AValue: string): string;
var
  Data, Crypt: TBytes;
begin
  Crypt := TNetEncoding.Base64.DecodeStringToBytes(AValue);
  DecryptAES(Crypt, Data);
  Result := StringReplace(FEncoding.GetString(Data), #13#10, '', [rfReplaceAll]);
end;

function TCipherAES.Encrypt(const AValue: string): string;
var
  Data, Crypt: TBytes;
begin
  Data := FEncoding.GetBytes(AValue);
  EncryptAES(Data, Crypt);
  Result := StringReplace(TNetEncoding.Base64.EncodeBytesToString(Crypt), #13#10, '', [rfReplaceAll]);
end;

procedure TCipherAES.DecryptAES(const ACrypt: TBytes; var AData: TBytes);
var
  Cipher: TDCP_rijndael;
  I: integer;
begin
  Cipher := TDCP_rijndael.Create(nil);
  try
    Cipher.Init(FKey[0], FKeySize, @FInitVector[0]);
    AData := Copy(ACrypt, 0, Length(ACrypt));
    case FChainingMode of
      cmCBC: Cipher.DecryptCBC(AData[0], AData[0], Length(AData));
      cmCFB8bit: Cipher.DecryptCFB8bit(AData[0], AData[0], Length(AData));
      cmCFBblock: Cipher.DecryptCFBblock(AData[0], AData[0], Length(AData));
      cmOFB: Cipher.DecryptOFB(AData[0], AData[0], Length(AData));
      cmCTR: Cipher.DecryptCTR(AData[0], AData[0], Length(AData));
      cmECB: Cipher.DecryptECB(AData[0], AData[0]);
    end;

    if (FChainingMode in [cmCBC, cmECB]) then
      case FPaddingMode of
        pmANSIX923, pmISO10126, pmPKCS7:
          SetLength(AData, Length(AData) - AData[Pred(Length(AData))]);
        pmISO7816:
          for I := Pred(Length(AData)) downto 0 do
            if (AData[I] = $80) then
            begin
              SetLength(AData, I);
              Break;
            end;
      end;
  finally
    Cipher.Free;
  end;
end;

procedure TCipherAES.EncryptAES(const AData: TBytes; var ACrypt: TBytes);
var
  Cipher: TDCP_rijndael;
begin
  Cipher := TDCP_rijndael.Create(nil);
  try
    Cipher.Init(FKey[0], FKeySize, @FInitVector[0]);
    ACrypt := Copy(AData, 0, Length(AData));
    if FChainingMode in [cmCBC, cmECB] then
      BytePadding(ACrypt, Cipher.BlockSize);

    case FChainingMode of
      cmCBC: Cipher.EncryptCBC(ACrypt[0], ACrypt[0], Length(ACrypt));
      cmCFB8bit: Cipher.EncryptCFB8bit(ACrypt[0], ACrypt[0], Length(ACrypt));
      cmCFBblock: Cipher.EncryptCFBblock(ACrypt[0], ACrypt[0], Length(ACrypt));
      cmOFB: Cipher.EncryptOFB(ACrypt[0], ACrypt[0], Length(ACrypt));
      cmCTR: Cipher.EncryptCTR(ACrypt[0], ACrypt[0], Length(ACrypt));
      cmECB: Cipher.EncryptECB(ACrypt[0], ACrypt[0]);
    end;
  finally
    Cipher.Free;
  end;
end;

function TCipherAES.GetInitVector: string;
begin
  Result := FEncoding.GetString(FInitVector);
end;

function TCipherAES.GetSecureKey: string;
begin
  Result := FEncoding.GetString(FKey);
end;

procedure TCipherAES.BytePadding(var AData: TBytes; ABlockSize: Integer);
var
  I, nDataBlocks, nDataLength, nPaddingStart, nPaddingCount: Integer;
begin
  ABlockSize := ABlockSize div 8;
  if (FPaddingMode in [pmZeroPadding, pmRandomPadding]) then
    if Length(AData) mod ABlockSize = 0 then
      Exit;

  nDataBlocks := (Length(AData) div ABlockSize) + 1;
  nDataLength := nDataBlocks * ABlockSize;
  nPaddingCount := nDataLength - Length(AData);

  if (FPaddingMode in [pmANSIX923, pmISO10126, pmPKCS7]) then
    if (nPaddingCount > $FF) then
      Exit;

  nPaddingStart := Length(AData);
  SetLength(AData, nDataLength);

  case FPaddingMode of
    pmZeroPadding, pmANSIX923, pmISO7816:
      FillChar(AData[nPaddingStart], nPaddingCount, 0);
    pmPKCS7:
      FillChar(AData[nPaddingStart], nPaddingCount, nPaddingCount);
    pmRandomPadding, pmISO10126:
      for I := nPaddingStart to Pred(nDataLength) do
        AData[I] := Random($FF);
  end;

  case FPaddingMode of
    pmANSIX923, pmISO10126:
      AData[Pred(nDataLength)] := nPaddingCount;
    pmISO7816:
      AData[nPaddingStart] := $80;
  end;
end;

end.
