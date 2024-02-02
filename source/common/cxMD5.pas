unit cxMD5;

interface

uses
  Classes;

const
  MD5_INIT_STATE_0 = $67452301;
  MD5_INIT_STATE_1 = $efcdab89;
  MD5_INIT_STATE_2 = $98badcfe;
  MD5_INIT_STATE_3 = $10325476;

  MD5_S11 = 7;
  MD5_S12 = 12;
  MD5_S13 = 17;
  MD5_S14 = 22;
  MD5_S21 = 5;
  MD5_S22 = 9;
  MD5_S23 = 14;
  MD5_S24 = 20;
  MD5_S31 =  4;
  MD5_S32 = 11;
  MD5_S33 = 16;
  MD5_S34 = 23;
  MD5_S41 = 6;
  MD5_S42 = 10;
  MD5_S43 = 15;
  MD5_S44 = 21;

  MD5_T01 = $d76aa478;
  MD5_T02 = $e8c7b756;
  MD5_T03 = $242070db;
  MD5_T04 = $c1bdceee;
  MD5_T05 = $f57c0faf;
  MD5_T06 = $4787c62a;
  MD5_T07 = $a8304613;
  MD5_T08 = $fd469501;
  MD5_T09 = $698098d8;
  MD5_T10 = $8b44f7af;
  MD5_T11 = $ffff5bb1;
  MD5_T12 = $895cd7be;
  MD5_T13 = $6b901122;
  MD5_T14 = $fd987193;
  MD5_T15 = $a679438e;
  MD5_T16 = $49b40821;

  MD5_T17 = $f61e2562;
  MD5_T18 = $c040b340;
  MD5_T19 = $265e5a51;
  MD5_T20 = $e9b6c7aa;
  MD5_T21 = $d62f105d;
  MD5_T22 = $02441453;
  MD5_T23 = $d8a1e681;
  MD5_T24 = $e7d3fbc8;
  MD5_T25 = $21e1cde6;
  MD5_T26 = $c33707d6;
  MD5_T27 = $f4d50d87;
  MD5_T28 = $455a14ed;
  MD5_T29 = $a9e3e905;
  MD5_T30 = $fcefa3f8;
  MD5_T31 = $676f02d9;
  MD5_T32 = $8d2a4c8a;

  MD5_T33 = $fffa3942;
  MD5_T34 = $8771f681;
  MD5_T35 = $6d9d6122;
  MD5_T36 = $fde5380c;
  MD5_T37 = $a4beea44;
  MD5_T38 = $4bdecfa9;
  MD5_T39 = $f6bb4b60;
  MD5_T40 = $bebfbc70;
  MD5_T41 = $289b7ec6;
  MD5_T42 = $eaa127fa;
  MD5_T43 = $d4ef3085;
  MD5_T44 = $04881d05;
  MD5_T45 = $d9d4d039;
  MD5_T46 = $e6db99e5;
  MD5_T47 = $1fa27cf8;
  MD5_T48 = $c4ac5665;

  MD5_T49 = $f4292244;
  MD5_T50 = $432aff97;
  MD5_T51 = $ab9423a7;
  MD5_T52 = $fc93a039;
  MD5_T53 = $655b59c3;
  MD5_T54 = $8f0ccc92;
  MD5_T55 = $ffeff47d;
  MD5_T56 = $85845dd1;
  MD5_T57 = $6fa87e4f;
  MD5_T58 = $fe2ce6e0;
  MD5_T59 = $a3014314;
  MD5_T60 = $4e0811a1;
  MD5_T61 = $f7537e82;
  MD5_T62 = $bd3af235;
  MD5_T63 = $2ad7d2bb;
  MD5_T64 = $eb86d391;

  PADDING: array [0..63] of byte = (
    $80, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0);

type
  uint4 = longword;
  uchar = byte;
  Puint4 = ^uint4;
  Puchar = ^uchar;

  TMD5Hash = class(TObject)
  private
    m_State: array[0..3] of uint4;
    m_Count: array[0..1] of uint4;
    m_Buffer: array[0..63] of uchar;
    m_Digest: array[0..15] of uchar;
    procedure Transform(block: Puchar);
    procedure Encode(dest: Puchar; src: Puint4; nLength: uint4);
    procedure Decode(dest: Puint4; src: Puchar; nLength: uint4);
    function  RotateLeft(x: uint4; n: uint4): uint4;
    procedure FF(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
    procedure GG(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
    procedure HH(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
    procedure II(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
  public
    constructor Create;
    function  Digest: Puchar;
    procedure Finalize;
    procedure Init;
    procedure Update(chInput: Puchar; nInputLen: uint4);
  end;

  function  MD5String(szString: AnsiString): AnsiString;
  function  MD5File(szFilename: String): AnsiString;
  function  MD5Stream(Stream: TStream): AnsiString;
  procedure MD5Buf(Buf: Pointer; const Len: Integer; Digest: Pointer);
  function  PrintMD5(md5Digest: Puchar): AnsiString;

implementation

uses
  SysUtils;

function Byte2Hex(const b: byte): AnsiString;
var
  H, L: Byte;
  function HexChar(N : Byte) : AnsiChar;
  begin
    if (N < 10) then
      Result := AnsiChar(Chr(Ord('0') + N))
    else
      Result := AnsiChar(Chr(Ord('A') + (N - 10)));
  end;
begin
  SetLength(Result, 2);
  H := (b shr 4) and $f;
  L := b and $f;
  Result[1] := HexChar(H);
  Result[2]:= HexChar(L);
end;

function PrintMD5(md5Digest: Puchar): AnsiString;
var
  nCount: Integer;
  tmp: Puchar;
begin
  Result := '';
  tmp := md5Digest;
  for nCount := 0 to 15 do
  begin
    Result := Result + LowerCase(Byte2Hex(Byte(tmp^)));
    Inc(tmp);
  end;
end;

function MD5String(szString: AnsiString): AnsiString;
var
  nLen: Integer;
  alg: TMD5Hash;
begin
  Result := '';
  alg := TMD5Hash.Create;
  try
    nLen := Length(szString);
    alg.Update(Puchar(szString), nLen);
    alg.Finalize;
    Result := PrintMD5(alg.Digest);
  finally
    alg.Free;
  end;
end;

function MD5Stream(Stream: TStream): AnsiString;
var
  nLen: Integer;
  buf: array [0..255] of AnsiChar;
  alg: TMD5Hash;
  oldpos: Longint;
begin
  Result := '';
  alg := TMD5Hash.Create;
  oldpos := Stream.Position;
  try
    Stream.Position := 0;
    nLen := 256;
    while nLen = 256 do
    begin
      nLen := Stream.Read(buf, nLen);
      alg.Update(@buf, nLen);
    end;
    alg.Finalize;
    Result := PrintMD5(alg.Digest);
  finally
    Stream.Position := oldpos;
    alg.Free;
  end;
end;

function MD5File(szFilename: String): AnsiString;
var
  f: TFileStream;
begin
  Result := '';
  f := TFileStream.Create(szFilename, fmOpenRead + fmShareDenyWrite);
  try
    Result := MD5Stream(f);
  finally
    f.Free
  end;
end;

procedure MD5Buf(Buf: Pointer; const Len: Integer; Digest: Pointer);
var
  md5: TMD5Hash;
  d: Puchar;
begin
  md5 := TMD5Hash.Create;
  try
    md5.Update(Buf, Len);
    md5.Finalize;
    d := md5.Digest;
    Move(d^, digest^, 16);
  finally
    md5.Free;
  end;
end;

{ TMD5Hash }

constructor TMD5Hash.Create;
begin
  Init;
end;

procedure TMD5Hash.Init;
begin
  FillChar(m_Count, 2 * SizeOf(uint4), 0);
  m_State[0] := MD5_INIT_STATE_0;
  m_State[1] := MD5_INIT_STATE_1;
  m_State[2] := MD5_INIT_STATE_2;
  m_State[3] := MD5_INIT_STATE_3;
end;

procedure TMD5Hash.Update(chInput: Puchar; nInputLen: uint4);
var
  i, index, partLen: uint4;
  tmp: Puchar;
begin
  index := (m_Count[0] shr 3) and $3F;
  m_Count[0] := m_Count[0] + (nInputLen shl 3);
  if m_Count[0] < (nInputLen shl 3) then
    m_Count[1] := m_Count[1] + 1;
  m_Count[1] := m_Count[1] + (nInputLen shr 29);
  partLen := 64 - index;
  if nInputLen >= partLen then
  begin
    Move(chInput^, m_Buffer[index], partLen);
    Transform(Puchar(@m_Buffer));
    i := partLen;
    while (i + 63) < nInputLen do
    begin
      tmp := chInput;
      Inc(tmp, i);
      Transform(tmp);
      i := i + 64;
    end;
    index := 0;
  end
  else
    i := 0;
  tmp := chInput;
  Inc(tmp, i);
  Move(tmp^, m_Buffer[index], nInputLen - i);
end;

procedure TMD5Hash.Finalize;
var
  bits: array [0..7] of uchar;
  index, padLen: uint4;
begin
  Encode(Puchar(@bits), Puint4(@m_Count), 8);
  index := (m_Count[0] shr 3) and $3f;
  if index < 56 then
    padLen := 56 - index
  else
    padLen := 120 - index;
  Update(Puchar(@PADDING), padLen);
  Update(Puchar(@bits), 8);
  Encode(Puchar(@m_Digest), Puint4(@m_State), 16);
  FillChar(m_Count, 2 * sizeof(uint4), 0);
  FillChar(m_State, 4 * sizeof(uint4), 0);
  FillChar(m_Buffer, 64 * sizeof(uchar), 0);
end;

function TMD5Hash.Digest: Puchar;
begin
  Result := Puchar(@m_Digest);
end;

procedure TMD5Hash.Transform(block: Puchar);
var
  a, b, c, d: uint4;
  X: array [0..15] of uint4;
begin
  a := m_State[0];
  b := m_State[1];
  c := m_State[2];
  d := m_State[3];

  Decode(Puint4(@X), block, 64);

  FF(a, b, c, d, X[ 0], MD5_S11, MD5_T01);
  FF(d, a, b, c, X[ 1], MD5_S12, MD5_T02);
  FF(c, d, a, b, X[ 2], MD5_S13, MD5_T03);
  FF(b, c, d, a, X[ 3], MD5_S14, MD5_T04);
  FF(a, b, c, d, X[ 4], MD5_S11, MD5_T05);
  FF(d, a, b, c, X[ 5], MD5_S12, MD5_T06);
  FF(c, d, a, b, X[ 6], MD5_S13, MD5_T07);
  FF(b, c, d, a, X[ 7], MD5_S14, MD5_T08);
  FF(a, b, c, d, X[ 8], MD5_S11, MD5_T09);
  FF(d, a, b, c, X[ 9], MD5_S12, MD5_T10);
  FF(c, d, a, b, X[10], MD5_S13, MD5_T11);
  FF(b, c, d, a, X[11], MD5_S14, MD5_T12);
  FF(a, b, c, d, X[12], MD5_S11, MD5_T13);
  FF(d, a, b, c, X[13], MD5_S12, MD5_T14);
  FF(c, d, a, b, X[14], MD5_S13, MD5_T15);
  FF(b, c, d, a, X[15], MD5_S14, MD5_T16);

  GG(a, b, c, d, X[ 1], MD5_S21, MD5_T17);
  GG(d, a, b, c, X[ 6], MD5_S22, MD5_T18);
  GG(c, d, a, b, X[11], MD5_S23, MD5_T19);
  GG(b, c, d, a, X[ 0], MD5_S24, MD5_T20);
  GG(a, b, c, d, X[ 5], MD5_S21, MD5_T21);
  GG(d, a, b, c, X[10], MD5_S22, MD5_T22);
  GG(c, d, a, b, X[15], MD5_S23, MD5_T23);
  GG(b, c, d, a, X[ 4], MD5_S24, MD5_T24);
  GG(a, b, c, d, X[ 9], MD5_S21, MD5_T25);
  GG(d, a, b, c, X[14], MD5_S22, MD5_T26);
  GG(c, d, a, b, X[ 3], MD5_S23, MD5_T27);
  GG(b, c, d, a, X[ 8], MD5_S24, MD5_T28);
  GG(a, b, c, d, X[13], MD5_S21, MD5_T29);
  GG(d, a, b, c, X[ 2], MD5_S22, MD5_T30);
  GG(c, d, a, b, X[ 7], MD5_S23, MD5_T31);
  GG(b, c, d, a, X[12], MD5_S24, MD5_T32);

  HH(a, b, c, d, X[ 5], MD5_S31, MD5_T33);
  HH(d, a, b, c, X[ 8], MD5_S32, MD5_T34);
  HH(c, d, a, b, X[11], MD5_S33, MD5_T35);
  HH(b, c, d, a, X[14], MD5_S34, MD5_T36);
  HH(a, b, c, d, X[ 1], MD5_S31, MD5_T37);
  HH(d, a, b, c, X[ 4], MD5_S32, MD5_T38);
  HH(c, d, a, b, X[ 7], MD5_S33, MD5_T39);
  HH(b, c, d, a, X[10], MD5_S34, MD5_T40);
  HH(a, b, c, d, X[13], MD5_S31, MD5_T41);
  HH(d, a, b, c, X[ 0], MD5_S32, MD5_T42);
  HH(c, d, a, b, X[ 3], MD5_S33, MD5_T43);
  HH(b, c, d, a, X[ 6], MD5_S34, MD5_T44);
  HH(a, b, c, d, X[ 9], MD5_S31, MD5_T45);
  HH(d, a, b, c, X[12], MD5_S32, MD5_T46);
  HH(c, d, a, b, X[15], MD5_S33, MD5_T47);
  HH(b, c, d, a, X[ 2], MD5_S34, MD5_T48);

  II(a, b, c, d, X[ 0], MD5_S41, MD5_T49);
  II(d, a, b, c, X[ 7], MD5_S42, MD5_T50);
  II(c, d, a, b, X[14], MD5_S43, MD5_T51);
  II(b, c, d, a, X[ 5], MD5_S44, MD5_T52);
  II(a, b, c, d, X[12], MD5_S41, MD5_T53);
  II(d, a, b, c, X[ 3], MD5_S42, MD5_T54);
  II(c, d, a, b, X[10], MD5_S43, MD5_T55);
  II(b, c, d, a, X[ 1], MD5_S44, MD5_T56);
  II(a, b, c, d, X[ 8], MD5_S41, MD5_T57);
  II(d, a, b, c, X[15], MD5_S42, MD5_T58);
  II(c, d, a, b, X[ 6], MD5_S43, MD5_T59);
  II(b, c, d, a, X[13], MD5_S44, MD5_T60);
  II(a, b, c, d, X[ 4], MD5_S41, MD5_T61);
  II(d, a, b, c, X[11], MD5_S42, MD5_T62);
  II(c, d, a, b, X[ 2], MD5_S43, MD5_T63);
  II(b, c, d, a, X[ 9], MD5_S44, MD5_T64);

  m_State[0] := m_State[0] + a;
  m_State[1] := m_State[1] + b;
  m_State[2] := m_State[2] + c;
  m_State[3] := m_State[3] + d;
  FillChar(X, sizeof(X), 0);
end;

procedure TMD5Hash.Encode(dest: Puchar; src: Puint4; nLength: uint4);
var
  j: uint4;
  tmp: Puchar;
  tmp2: Puint4;
begin
  j := 0;
  tmp := dest;
  tmp2 := src;
  while j < nLength do
  begin
    tmp^ := uchar(tmp2^ and $ff);
    Inc(tmp);
    tmp^ := uchar((tmp2^ shr 8) and $ff);
    Inc(tmp);
    tmp^ := uchar((tmp2^ shr 16) and $ff);
    Inc(tmp);
    tmp^ := uchar((tmp2^ shr 24) and $ff);
    Inc(tmp);
    Inc(tmp2);
    j := j + 4;
  end;
end;

procedure TMD5Hash.Decode(dest: Puint4; src: Puchar; nLength: uint4);
var
  j: uint4;
  tmp2: Puchar;
  tmp: Puint4;
begin
  j := 0;
  tmp := dest;
  tmp2 := src;
  while j < nLength do
  begin
    tmp^ := uint4(tmp2^);
    Inc(tmp2);
    tmp^ := tmp^ or uint4(tmp2^ shl 8);
    Inc(tmp2);
    tmp^ := tmp^ or uint4(tmp2^ shl 16);
    Inc(tmp2);
    tmp^ := tmp^ or uint4(tmp2^ shl 24);
    Inc(tmp2);
    Inc(tmp);
    j := j + 4;
  end;
end;

function TMD5Hash.RotateLeft(x: uint4; n: uint4): uint4;
begin
  Result := (x shl n) or (x shr (32 - n));
end;

procedure TMD5Hash.FF(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
begin
  a := a + ((b and c) or (not b and d)) + x + ac;
  a := RotateLeft(a, s);
  a := a + b;
end;

procedure TMD5Hash.GG(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
begin
  a := a + ((b and d) or (c and (not d))) + x + ac;
  a := RotateLeft(a, s);
  a := a + b;
end;

procedure TMD5Hash.HH(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
begin
  a := a + (b xor c xor d) + x + ac;
  a := RotateLeft(a, s);
  a := a + b;
end;

procedure TMD5Hash.II(var a: uint4; b: uint4; c: uint4; d: uint4; x: uint4; s: uint4; ac: uint4);
begin
  a := a + (c xor (b or (not d))) + x + ac;
  a := RotateLeft(a, s);
  a := a + b;
end;

end.
