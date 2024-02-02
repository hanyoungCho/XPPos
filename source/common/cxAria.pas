unit cxAria;

interface

uses
  SysUtils, Classes;

type
  PByteArray = ^TByteArray;
  TByteArray = array[0..511] of Byte;

  TAriaBlock = array[0..15] of byte;
  TAriaMasterKey = array[0..31] of byte;
  TAriaRoundKey = array[0..16*17-1] of byte;

  TAriaCrypt = class(TComponent)
  private
    FEncode: Boolean;
    FKey: AnsiString;
    FKeySize: Integer;   // 128, 192, 256
    FMasterKey: TAriaMasterKey;
    procedure DiffusionLayer(i, o: PByteArray; iPos, oPos: Integer);
    procedure DoCrypt(p: TAriaBlock; R: Integer; e: TAriaRoundKey; var c: TAriaBlock);
    function  DecKeySetup(w0: TAriaMasterKey; var e: TAriaRoundKey): Integer;
    function  EncKeySetup(w0: TAriaMasterKey; var e: TAriaRoundKey): Integer;
    procedure RotXOR(s: PByteArray; n: Integer; t: PByteArray; APos: Integer);
    procedure SetKey(const Value: AnsiString);
    procedure SetKeySize(const Value: Integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  Crypt(Value: AnsiString): AnsiString; overload;
    procedure Crypt(InStream, OutStream: TStream); overload;
    function  Decrypt(Value: AnsiString): AnsiString; overload;
    procedure Decrypt(InStream, OutStream: TStream); overload;

    property Encode: Boolean read FEncode write FEncode;
    property Key: AnsiString read FKey write SetKey;
    property KeySize: Integer read FKeySize write SetKeySize default 192;
  end;

  function  CryptAria(AKey: AnsiString; Source: AnsiString): AnsiString; overload;
  procedure CryptAria(AKey: AnsiString; Source, Target: TStream; ABase64: Boolean = False); overload;
  function  DecryptAria(AKey: AnsiString; Source: AnsiString): AnsiString; overload;
  procedure DecryptAria(AKey: AnsiString; Source, Target: TStream; ABase64: Boolean = False); overload;

implementation

uses
  cxMD5, cxBase64;

const
  SBox: array[0..3, 0..255] of Byte = (
	(
    // S-Box Type 1
		$63, $7c, $77, $7b, $f2, $6b, $6f, $c5, $30, $01, $67, $2b, $fe, $d7, $ab, $76,
		$ca, $82, $c9, $7d, $fa, $59, $47, $f0, $ad, $d4, $a2, $af, $9c, $a4, $72, $c0,
		$b7, $fd, $93, $26, $36, $3f, $f7, $cc, $34, $a5, $e5, $f1, $71, $d8, $31, $15,
		$04, $c7, $23, $c3, $18, $96, $05, $9a, $07, $12, $80, $e2, $eb, $27, $b2, $75,
		$09, $83, $2c, $1a, $1b, $6e, $5a, $a0, $52, $3b, $d6, $b3, $29, $e3, $2f, $84,
		$53, $d1, $00, $ed, $20, $fc, $b1, $5b, $6a, $cb, $be, $39, $4a, $4c, $58, $cf,
		$d0, $ef, $aa, $fb, $43, $4d, $33, $85, $45, $f9, $02, $7f, $50, $3c, $9f, $a8,
		$51, $a3, $40, $8f, $92, $9d, $38, $f5, $bc, $b6, $da, $21, $10, $ff, $f3, $d2,
		$cd, $0c, $13, $ec, $5f, $97, $44, $17, $c4, $a7, $7e, $3d, $64, $5d, $19, $73,
		$60, $81, $4f, $dc, $22, $2a, $90, $88, $46, $ee, $b8, $14, $de, $5e, $0b, $db,
		$e0, $32, $3a, $0a, $49, $06, $24, $5c, $c2, $d3, $ac, $62, $91, $95, $e4, $79,
		$e7, $c8, $37, $6d, $8d, $d5, $4e, $a9, $6c, $56, $f4, $ea, $65, $7a, $ae, $08,
		$ba, $78, $25, $2e, $1c, $a6, $b4, $c6, $e8, $dd, $74, $1f, $4b, $bd, $8b, $8a,
		$70, $3e, $b5, $66, $48, $03, $f6, $0e, $61, $35, $57, $b9, $86, $c1, $1d, $9e,
		$e1, $f8, $98, $11, $69, $d9, $8e, $94, $9b, $1e, $87, $e9, $ce, $55, $28, $df,
		$8c, $a1, $89, $0d, $bf, $e6, $42, $68, $41, $99, $2d, $0f, $b0, $54, $bb, $16
  ),
  // S-Box type 2
	(
	  $e2, $4e, $54, $fc, $94, $c2, $4a, $cc, $62, $0d, $6a, $46, $3c, $4d, $8b, $d1,
		$5e, $fa, $64, $cb, $b4, $97, $be, $2b, $bc, $77, $2e, $03, $d3, $19, $59, $c1,
		$1d, $06, $41, $6b, $55, $f0, $99, $69, $ea, $9c, $18, $ae, $63, $df, $e7, $bb,
		$00, $73, $66, $fb, $96, $4c, $85, $e4, $3a, $09, $45, $aa, $0f, $ee, $10, $eb,
		$2d, $7f, $f4, $29, $ac, $cf, $ad, $91, $8d, $78, $c8, $95, $f9, $2f, $ce, $cd,
		$08, $7a, $88, $38, $5c, $83, $2a, $28, $47, $db, $b8, $c7, $93, $a4, $12, $53,
		$ff, $87, $0e, $31, $36, $21, $58, $48, $01, $8e, $37, $74, $32, $ca, $e9, $b1,
		$b7, $ab, $0c, $d7, $c4, $56, $42, $26, $07, $98, $60, $d9, $b6, $b9, $11, $40,
		$ec, $20, $8c, $bd, $a0, $c9, $84, $04, $49, $23, $f1, $4f, $50, $1f, $13, $dc,
		$d8, $c0, $9e, $57, $e3, $c3, $7b, $65, $3b, $02, $8f, $3e, $e8, $25, $92, $e5,
		$15, $dd, $fd, $17, $a9, $bf, $d4, $9a, $7e, $c5, $39, $67, $fe, $76, $9d, $43,
		$a7, $e1, $d0, $f5, $68, $f2, $1b, $34, $70, $05, $a3, $8a, $d5, $79, $86, $a8,
		$30, $c6, $51, $4b, $1e, $a6, $27, $f6, $35, $d2, $6e, $24, $16, $82, $5f, $da,
		$e6, $75, $a2, $ef, $2c, $b2, $1c, $9f, $5d, $6f, $80, $0a, $72, $44, $9b, $6c,
		$90, $0b, $5b, $33, $7d, $5a, $52, $f3, $61, $a1, $f7, $b0, $d6, $3f, $7c, $6d,
		$ed, $14, $e0, $a5, $3d, $22, $b3, $f8, $89, $de, $71, $1a, $af, $ba, $b5, $81
  ),
  // inverse of S-box type 1
	(
		$52, $09, $6a, $d5, $30, $36, $a5, $38, $bf, $40, $a3, $9e, $81, $f3, $d7, $fb,
		$7c, $e3, $39, $82, $9b, $2f, $ff, $87, $34, $8e, $43, $44, $c4, $de, $e9, $cb,
		$54, $7b, $94, $32, $a6, $c2, $23, $3d, $ee, $4c, $95, $0b, $42, $fa, $c3, $4e,
		$08, $2e, $a1, $66, $28, $d9, $24, $b2, $76, $5b, $a2, $49, $6d, $8b, $d1, $25,
		$72, $f8, $f6, $64, $86, $68, $98, $16, $d4, $a4, $5c, $cc, $5d, $65, $b6, $92,
		$6c, $70, $48, $50, $fd, $ed, $b9, $da, $5e, $15, $46, $57, $a7, $8d, $9d, $84,
		$90, $d8, $ab, $00, $8c, $bc, $d3, $0a, $f7, $e4, $58, $05, $b8, $b3, $45, $06,
		$d0, $2c, $1e, $8f, $ca, $3f, $0f, $02, $c1, $af, $bd, $03, $01, $13, $8a, $6b,
		$3a, $91, $11, $41, $4f, $67, $dc, $ea, $97, $f2, $cf, $ce, $f0, $b4, $e6, $73,
		$96, $ac, $74, $22, $e7, $ad, $35, $85, $e2, $f9, $37, $e8, $1c, $75, $df, $6e,
		$47, $f1, $1a, $71, $1d, $29, $c5, $89, $6f, $b7, $62, $0e, $aa, $18, $be, $1b,
		$fc, $56, $3e, $4b, $c6, $d2, $79, $20, $9a, $db, $c0, $fe, $78, $cd, $5a, $f4,
		$1f, $dd, $a8, $33, $88, $07, $c7, $31, $b1, $12, $10, $59, $27, $80, $ec, $5f,
		$60, $51, $7f, $a9, $19, $b5, $4a, $0d, $2d, $e5, $7a, $9f, $93, $c9, $9c, $ef,
		$a0, $e0, $3b, $4d, $ae, $2a, $f5, $b0, $c8, $eb, $bb, $3c, $83, $53, $99, $61,
		$17, $2b, $04, $7e, $ba, $77, $d6, $26, $e1, $69, $14, $63, $55, $21, $0c, $7d
  ),
  // inverse of S-box type 2
	(
		$30, $68, $99, $1b, $87, $b9, $21, $78, $50, $39, $db, $e1, $72, $09, $62, $3c,
		$3e, $7e, $5e, $8e, $f1, $a0, $cc, $a3, $2a, $1d, $fb, $b6, $d6, $20, $c4, $8d,
		$81, $65, $f5, $89, $cb, $9d, $77, $c6, $57, $43, $56, $17, $d4, $40, $1a, $4d,
		$c0, $63, $6c, $e3, $b7, $c8, $64, $6a, $53, $aa, $38, $98, $0c, $f4, $9b, $ed,
		$7f, $22, $76, $af, $dd, $3a, $0b, $58, $67, $88, $06, $c3, $35, $0d, $01, $8b,
		$8c, $c2, $e6, $5f, $02, $24, $75, $93, $66, $1e, $e5, $e2, $54, $d8, $10, $ce,
		$7a, $e8, $08, $2c, $12, $97, $32, $ab, $b4, $27, $0a, $23, $df, $ef, $ca, $d9,
		$b8, $fa, $dc, $31, $6b, $d1, $ad, $19, $49, $bd, $51, $96, $ee, $e4, $a8, $41,
		$da, $ff, $cd, $55, $86, $36, $be, $61, $52, $f8, $bb, $0e, $82, $48, $69, $9a,
		$e0, $47, $9e, $5c, $04, $4b, $34, $15, $79, $26, $a7, $de, $29, $ae, $92, $d7,
		$84, $e9, $d2, $ba, $5d, $f3, $c5, $b0, $bf, $a4, $3b, $71, $44, $46, $2b, $fc,
		$eb, $6f, $d5, $f6, $14, $fe, $7c, $70, $5a, $7d, $fd, $2f, $18, $83, $16, $a5,
		$91, $1f, $05, $95, $74, $a9, $c1, $5b, $4a, $85, $6d, $13, $07, $4f, $4e, $45,
		$b2, $0f, $c9, $1c, $a6, $bc, $ec, $73, $90, $7b, $cf, $59, $8f, $a1, $f9, $2d,
		$f2, $b1, $00, $94, $37, $9f, $d0, $2e, $9c, $6e, $28, $3f, $80, $f0, $3d, $d3,
		$25, $8a, $b5, $e7, $42, $b3, $c7, $ea, $f7, $4c, $11, $33, $03, $a2, $ac, $60)
  );

  KRK: array[0..2, 0..15] of Byte = (
   ($51, $7c, $c1, $b7, $27, $22, $0a, $94, $fe, $13, $ab, $e8, $fa, $9a, $6e, $e0),
	 ($6d, $b1, $4a, $cc, $9e, $21, $c8, $20, $ff, $28, $b1, $d5, $ef, $5d, $e2, $b0),
	 ($db, $92, $37, $1d, $21, $26, $e9, $70, $03, $24, $97, $75, $04, $e8, $c9, $0e)
  );

function CryptAria(AKey: AnsiString; Source: AnsiString): AnsiString;
var
  Aria: TAriaCrypt;
begin
  Aria := TAriaCrypt.Create(nil);
  try
    with Aria do
    begin
      Encode := True;
      Key := AKey;
      Result := Crypt(Source);
    end;
  finally
    Aria.Free;
  end;
end;

procedure CryptAria(AKey: AnsiString; Source, Target: TStream; ABase64: Boolean = False);
var
  Aria: TAriaCrypt;
begin
  Aria := TAriaCrypt.Create(nil);
  try
    with Aria do
    begin
      Encode := ABase64;
      Key := AKey;
      Crypt(Source, Target);
    end;
  finally
    Aria.Free;
  end;
end;

function DecryptAria(AKey: AnsiString; Source: AnsiString): AnsiString;
var
  Aria: TAriaCrypt;
begin
  Aria := TAriaCrypt.Create(nil);
  try
    with Aria do
    begin
      Encode := True;
      Key := AKey;
      Result := Decrypt(Source);
    end;
  finally
    Aria.Free;
  end;
end;

procedure DecryptAria(AKey: AnsiString; Source, Target: TStream; ABase64: Boolean = False);
var
  Aria: TAriaCrypt;
begin
  Aria := TAriaCrypt.Create(nil);
  try
    with Aria do
    begin
      Encode := ABase64;
      Key := AKey;
      Decrypt(Source, Target);
    end;
  finally
    Aria.Free;
  end;
end;

{ TAriaCrypt }

constructor TAriaCrypt.Create(AOwner: TComponent);
begin
  inherited;

  FEncode := True;
  FKey := '';
  FKeySize := 192;
end;

function TAriaCrypt.Crypt(Value: AnsiString): AnsiString;
var
  InBlock: TAriaBlock;
  OutBlock: TAriaBlock;
  RoundNumber: Integer;
  RoundKey: TAriaRoundKey;
  i: Integer;
  Start: Integer;
  EncryptData: AnsiString;
  EncryptSize: Integer;
  CryptData: AnsiString;
  DataSize: Integer;
  ModSize: Integer;
begin
  EncryptSize := Length(Value);
  SetLength(EncryptData, EncryptSize+4);
  Move(EncryptSize, EncryptData[1], 4);         // 길이
  Move(Value[1], EncryptData[5], EncryptSize);  // 데이터

  DataSize := Length(EncryptData);
  ModSize  := DataSize mod 16;
  RoundNumber := EncKeySetup(FMasterKey, RoundKey);
  Start := 1;
  SetLength(CryptData, DataSize + 16 - (Length(EncryptData) mod 16));
  for i := 1 to DataSize div 16 do
  begin
    Move(EncryptData[Start], InBlock, 16);
    DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
    Move(OutBlock, CryptData[Start], 16);
    Inc(Start, 16);
  end;

  if (ModSize <> 0) then
  begin
    FillChar(InBlock, 16, 0);
    Move(EncryptData[Start], InBlock, ModSize);
    DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
    Move(OutBlock, CryptData[Start], 16);
  end;

  if FEncode then
    Result := Base64Encode(CryptData)
  else
    Result := CryptData;
end;

procedure TAriaCrypt.Crypt(InStream, OutStream: TStream);
var
  InBlock: TAriaBlock;
  OutBlock: TAriaBlock;
  RoundNumber: Integer;
  RoundKey: TAriaRoundKey;
  i: Integer;
  DataSize: Integer;
  ModSize: Integer;
  TempStream: TMemoryStream;
begin
  TempStream := TMemoryStream.Create;
  try
    DataSize := InStream.Size;
    TempStream.WriteBuffer(DataSize, 4);
    TempStream.CopyFrom(InStream, 0);
    TempStream.Position := 0;
    DataSize := TempStream.Size;
    ModSize  := DataSize mod 16;
    RoundNumber := EncKeySetup(FMasterKey, RoundKey);

    for i := 1 to DataSize div 16 do
    begin
      TempStream.ReadBuffer(InBlock, 16);
      DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
      OutStream.WriteBuffer(OutBlock, 16);
    end;

    if (ModSize <> 0) then
    begin
      FillChar(InBlock, 16, 0);
      TempStream.ReadBuffer(InBlock, ModSize);
      DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
      OutStream.WriteBuffer(OutBlock, 16);
    end;
  finally
    TempStream.Free;
  end
end;

function TAriaCrypt.DecKeySetup(w0: TAriaMasterKey; var e: TAriaRoundKey): Integer;
var
	i, j, R: Integer;
	t: TAriaBlock;
begin
	R := EncKeySetup(w0, e);

	for j := 0 to 15 do
  begin
		t[j] := e[j];
		e[j] := e[16*R + j];
		e[16*R + j] := t[j];
	end;

	for i := 1 to (R div 2) do
  begin
		DiffusionLayer(@e, @t, i*16, 0);
		DiffusionLayer(@e, @e, (R-i)*16, i*16);
		for j := 0 to 15 do
      e[(R-i)*16 + j] := t[j];
	end;

	Result := R;
end;

function TAriaCrypt.Decrypt(Value: AnsiString): AnsiString;
var
  InBlock: TAriaBlock;
  OutBlock: TAriaBlock;
  RoundNumber: Integer;
  RoundKey: TAriaRoundKey;
  i: Integer;
  Start: Integer;
  CryptData: AnsiString;
  EncryptData: AnsiString;
  EncryptSize: Integer;
  DataSize: Integer;
  ModSize: Integer;
begin
  if FEncode then
    CryptData := Base64Decode(Value)
  else
    CryptData := Value;

  DataSize := Length(CryptData);
  ModSize := DataSize mod 16;
  RoundNumber := DecKeySetup(FMasterKey, RoundKey);
  Start := 1;
  SetLength(EnCryptData, DataSize);
  for i := 1 to DataSize div 16 do
  begin
    Move(CryptData[Start], InBlock, 16);
    DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
    Move(OutBlock, EnCryptData[Start], 16);
    Inc(Start, 16);
  end;

  if (ModSize <> 0) then
  begin
    FillChar(InBlock, 16, 0);
    Move(CryptData[Start], InBlock, ModSize);
    DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
    Move(OutBlock, EnCryptData[Start], 16);
  end;

  Move(EnCryptData[1], EncryptSize, 4);
  Result := Copy(EncryptData, 5, EncryptSize);
end;

procedure TAriaCrypt.Decrypt(InStream, OutStream: TStream);
var
  InBlock: TAriaBlock;
  OutBlock: TAriaBlock;
  RoundNumber: Integer;
  RoundKey: TAriaRoundKey;
  i: Integer;
  EncryptSize: Integer;
  ModSize: Integer;
  DataSize: Integer;
  TempStream: TMemoryStream;
begin
  InStream.Position := 0;
  EncryptSize := InStream.Size;
  ModSize := EncryptSize mod 16;
  RoundNumber := DecKeySetup(FMasterKey, RoundKey);
  TempStream := TMemoryStream.Create;

  try
    for i := 1 to EncryptSize div 16 do
    begin
      InStream.ReadBuffer(InBlock, 16);
      DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
      TempStream.WriteBuffer(OutBlock, 16);
    end;

    if (ModSize <> 0) then
    begin
      FillChar(InBlock, 16, 0);
      InStream.ReadBuffer(InBlock, ModSize);
      DoCrypt(InBlock, RoundNumber, RoundKey, OutBlock);
      TempStream.WriteBuffer(OutBlock, ModSize);
    end;
  finally
    TempStream.Position := 0;
    TempStream.ReadBuffer(DataSize, 4);
    OutStream.CopyFrom(TempStream, DataSize);
    TempStream.Free;
  end;
end;

destructor TAriaCrypt.Destroy;
begin

  inherited;
end;

procedure TAriaCrypt.DiffusionLayer(i, o: PByteArray; iPos, oPos: Integer);
var
  T: Byte;
begin                
	T := i^[iPos + 3] xor i^[iPos + 4] xor i^[iPos + 9] xor i^[iPos +14];
	o^[oPos + 0] := i^[iPos + 6] xor i^[iPos + 8] xor i^[iPos +13] xor T;
	o^[oPos + 5] := i^[iPos + 1] xor i^[iPos +10] xor i^[iPos +15] xor T;
	o^[oPos +11] := i^[iPos + 2] xor i^[iPos + 7] xor i^[iPos +12] xor T;
	o^[oPos +14] := i^[iPos + 0] xor i^[iPos + 5] xor i^[iPos +11] xor T;

	T := i^[iPos + 2] xor i^[iPos + 5] xor i^[iPos + 8] xor i^[iPos +15];
	o^[oPos + 1] := i^[iPos + 7] xor i^[iPos + 9] xor i^[iPos +12] xor T;
	o^[oPos + 4] := i^[iPos + 0] xor i^[iPos +11] xor i^[iPos +14] xor T;
	o^[oPos +10] := i^[iPos + 3] xor i^[iPos + 6] xor i^[iPos +13] xor T;
	o^[oPos +15] := i^[iPos + 1] xor i^[iPos + 4] xor i^[iPos +10] xor T;

	T := i^[iPos + 1] xor i^[iPos + 6] xor i^[iPos +11] xor i^[iPos +12];
	o^[oPos + 2] := i^[iPos + 4] xor i^[iPos +10] xor i^[iPos +15] xor T;
	o^[oPos + 7] := i^[iPos + 3] xor i^[iPos + 8] xor i^[iPos +13] xor T;
	o^[oPos + 9] := i^[iPos + 0] xor i^[iPos + 5] xor i^[iPos +14] xor T;
	o^[oPos +12] := i^[iPos + 2] xor i^[iPos + 7] xor i^[iPos + 9] xor T;

	T := i^[iPos + 0] xor i^[iPos + 7] xor i^[iPos +10] xor i^[iPos +13];
	o^[oPos + 3] := i^[iPos + 5] xor i^[iPos +11] xor i^[iPos +14] xor T;
	o^[oPos + 6] := i^[iPos + 2] xor i^[iPos + 9] xor i^[iPos +12] xor T;
	o^[oPos + 8] := i^[iPos + 1] xor i^[iPos + 4] xor i^[iPos +15] xor T;
	o^[oPos +13] := i^[iPos + 3] xor i^[iPos + 6] xor i^[iPos + 8] xor T;
end;

procedure TAriaCrypt.DoCrypt(p: TAriaBlock; R: Integer; e: TAriaRoundKey; var c: TAriaBlock);
var
	i, j: Integer;
	t: TAriaBlock;
  iPos: Integer;
begin
  iPos := 0;

	for j := 0 to 15 do
    c[j] := p[j];

	for i := 0 to (R div 2) -1 do
	begin
		for j := 0 to 15 do
      t[j] := SBox[j mod 4][e[iPos + j] xor c[j]];
		DiffusionLayer(@t, @c, 0, 0);
    iPos := iPos + 16;

		for j := 0 to 15 do
      t[j] := SBox[(2 + j) mod 4][e[iPos + j] xor c[j]];
		DiffusionLayer(@t, @c, 0, 0);
    iPos := iPos + 16;
	end;

	DiffusionLayer(@c, @t, 0, 0);
	for j := 0 to 15 do
    c[j] := e[iPos + j] xor t[j];
end;

function TAriaCrypt.EncKeySetup(w0: TAriaMasterKey; var e: TAriaRoundKey): Integer;
var
  i, r, q: Integer;
  t, w1, w2, w3: TAriaBlock;
begin
	R := (FKeySize + 256) div 32;
	q := (FKeySize - 128) div 64;

	for i := 0 to 15 do
	begin
		t[i] := SBox[i mod 4][KRK[q][i] xor w0[i]];
	end;

	DiffusionLayer(@t, @w1, 0, 0);
	if (R = 14) then
	begin
		for i := 0 to 7 do
      w1[i] := w1[i] xor w0[16+i];
	end
	else
  if (R = 16) then
	begin
		for i := 0 to 15 do
      w1[i] := w1[i] xor w0[16+i];
	end;

  if q = 2 then
    q := 0
  else
    q := q+1;

	for i := 0 to 15 do
	begin
		t[i] := SBox[(2 + i) mod 4][KRK[q][i] xor w1[i]];
	end;

	DiffusionLayer(@t, @w2, 0, 0);
	for i := 0 to 15 do
	begin
		w2[i] := w2[i] xor w0[i];
	end;

  if q = 2 then
    q := 0
  else
    q := q+1;

	for i := 0 to 15 do
  begin
		t[i] := SBox[i mod 4][KRK[q][i] xor w2[i]];
	end;

	DiffusionLayer(@t, @w3, 0, 0);

	for i := 0 to 15 do
  begin
		w3[i] := w3[1] xor w1[i];
	end;

	for i := 0 to (16*(r+1)-1) do
    e[i] := 0;

	RotXOR(@w0, 0, @e,   0); RotXOR(@w1,  19, @e,   0);
	RotXOR(@w1, 0, @e,  16); RotXOR(@w2,  19, @e,  16);
	RotXOR(@w2, 0, @e,  32); RotXOR(@w3,  19, @e,  32);
	RotXOR(@w3, 0, @e,  48); RotXOR(@w0,  19, @e,  48);
	RotXOR(@w0, 0, @e,  64); RotXOR(@w1,  31, @e,  64);
	RotXOR(@w1, 0, @e,  80); RotXOR(@w2,  31, @e,  80);
	RotXOR(@w2, 0, @e,  96); RotXOR(@w3,  31, @e,  96);
	RotXOR(@w3, 0, @e, 112); RotXOR(@w0,  31, @e, 112);
	RotXOR(@w0, 0, @e, 128); RotXOR(@w1,  67, @e, 128);
	RotXOR(@w1, 0, @e, 144); RotXOR(@w2,  67, @e, 144);
	RotXOR(@w2, 0, @e, 160); RotXOR(@w3,  67, @e, 160);
	RotXOR(@w3, 0, @e, 176); RotXOR(@w0,  67, @e, 176);
	RotXOR(@w0, 0, @e, 192); RotXOR(@w1,  97, @e, 192);

	if (R > 12) then
	begin
		RotXOR(@w1, 0, @e, 208); RotXOR(@w2,  97, @e, 208);
		RotXOR(@w2, 0, @e, 224); RotXOR(@w3,  97, @e, 224);
	end;

	if (R > 14) then
	begin
		RotXOR(@w3, 0, @e, 240); RotXOR(@w0,  97, @e, 240);
		RotXOR(@w0, 0, @e, 256); RotXOR(@w1, 109, @e, 256);
	end;

	Result := r;
end;

procedure TAriaCrypt.RotXOR(s: PByteArray; n: Integer; t: PByteArray; APos: Integer);
var
	i, q: Integer;
begin
	q := n div 8;
  n := n mod 8;
	for i := 0 to 15 do
	begin
		t^[APos + (q+i) mod 16] := t^[APos + (q+i) mod 16] xor (s^[i] shr n);
		if (n <> 0) then
    begin
      t^[APos + (q+i+1) mod 16] := t^[APos + (q+i+1) mod 16] xor (s^[i] shl (8-n));
    end;
	end;
end;

procedure TAriaCrypt.SetKey(const Value: AnsiString);
var
  MD5Hash: AnsiString;
begin
  if (FKey <> Value) then
  begin
    FKey := Value;
    MD5Hash := MD5String(FKey);
    Move(MD5Hash[1], FMasterKey[0], SizeOf(FMasterKey));
  end;
end;

procedure TAriaCrypt.SetKeySize(const Value: Integer);
begin
  if (Value = 128) or (Value = 192) or (Value = 256) then
  begin
    FKeySize := Value;
  end;
end;

end.
