unit cxBase64;

interface

uses
  SysUtils;

  function Base64Encode(const Input: AnsiString): AnsiString;
  function Base64Decode(const Input: AnsiString): AnsiString;

implementation

const
  Base64Out: array[0..64] of AnsiChar = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
    );
  Base64In: array[0..127] of Byte = (
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,  54,  55,
     56,  57,  58,  59,  60,  61, 255, 255, 255,  64, 255, 255, 255,
      0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
     13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
    255, 255, 255, 255, 255, 255,  26,  27,  28,  29,  30,  31,  32,
     33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
     46,  47,  48,  49,  50,  51, 255, 255, 255, 255, 255
    );

function Base64Encode(const Input: AnsiString): AnsiString;
var
  Count: Integer;
  Len: Integer;
begin
  Result := '';
  Count := 1;
  Len := Length(Input);
  while Count <= Len do
  begin
    Result := Result + Base64Out[(Byte(Input[Count]) and $FC) shr 2];
    if (Count + 1) <= Len then
    begin
      Result := Result + Base64Out[((Byte(Input[Count]) and $03) shl 4) + ((Byte(Input[Count + 1]) and $F0) shr 4)];
      if (Count + 2) <= Len then
      begin
        Result := Result + Base64Out[((Byte(Input[Count + 1]) and $0F) shl 2) + ((Byte(Input[Count + 2]) and $C0) shr 6)];
        Result := Result + Base64Out[(Byte(Input[Count + 2]) and $3F)];
      end
      else
      begin
        Result := Result + Base64Out[(Byte(Input[Count + 1]) and $0F) shl 2];
        Result := Result + '=';
      end
    end
    else
    begin
      Result := Result + Base64Out[(Byte(Input[Count]) and $03) shl 4];
      Result := Result + '==';
    end;
    Count := Count + 3;
  end;
end;

function Base64Decode(const Input: AnsiString): AnsiString;
var
  Count: Integer;
  Len: Integer;
  DataIn0: Byte;
  DataIn1: Byte;
  DataIn2: Byte;
  DataIn3: Byte;
begin
  Result := '';
  Count := 1;
  Len := Length(Input);
  while Count <= Len do
  begin
    if Byte(Input[Count]) in [13, 10] then
      Inc(Count)
    else
    begin
      DataIn0 := Base64In[Byte(Input[Count])];
      DataIn1 := Base64In[Byte(Input[Count + 1])];
      DataIn2 := Base64In[Byte(Input[Count + 2])];
      DataIn3 := Base64In[Byte(Input[Count + 3])];

      Result := Result + AnsiChar(((DataIn0 and $3F) shl 2) + ((DataIn1 and $30) shr 4));
      if DataIn2 <> $40 then
      begin
        Result := Result + AnsiChar(((DataIn1 and $0F) shl 4) + ((DataIn2 and $3C) shr 2));
        if DataIn3 <> $40 then
          Result := Result + AnsiChar(((DataIn2 and $03) shl 6) + (DataIn3 and $3F));
      end;
      Count := Count + 4;
    end;
  end;
end;

end.
