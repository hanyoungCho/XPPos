unit uSyllabic;

interface

uses
  SysUtils;

const
  CO_CHOSUNG_TBL:  WideString = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  CO_JUNGSUNG_TBL: WideString = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  CO_JONGSUNG_TBL: WideString = ' ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
  CO_UNICODE_HANGEUL_BASE = $AC00;
  CO_UNICODE_HANGEUL_LAST = $D79F;

type
  TSyllable = class
  public
    class function AnsiToUnicode(const ASource: AnsiString): WideString;
    class function ExistsJongsung(const AUnicode: string): Boolean;
    class function SplitSyllabic(const AUnicode: WideChar; var AChoSung, AJungSung, AJongSung: WideChar): boolean; overload;
    class function SplitSyllabic(const ASource: WideString): WideString; overload;
    class function SplitSyllabic(const ASource: WideString; const AChoSungOnly: boolean=False): WideString; overload;
    class function MergeSyllabic(const AChoSung, AJungSung, AJongSung: WideChar): WideChar; //초성, 중성, 종성 자모로 한글 조합: 예) 'ㄱ'+'ㅣ'+'ㅁ' => '김'
  end;

implementation

{ TSyllable }

class function TSyllable.AnsiToUnicode(const ASource: AnsiString): WideString;
begin
  Result := WideString(ASource);
end;

class function TSyllable.ExistsJongsung(const AUnicode: string): boolean;
var
  nCode: Cardinal;
  nValue, nChoIdx, nJungIdx, nJongIdx: integer;
begin
  Result := False;
  if (Length(AUniCode) <> 1) then
    Exit;

  nValue := Integer(AUniCode[1]);
  if (nValue < CO_UNICODE_HANGEUL_BASE) or
     (nValue > CO_UNICODE_HANGEUL_LAST) then
    Exit;

  nCode    := (nValue - CO_UNICODE_HANGEUL_BASE);
  nChoIdx  := nCode div (21 * 28);  //초성 Index
  nCode    := nCode mod (21 * 28);
  nJungIdx := nCode div 28;         //중성 Index
  nJongIdx := nCode mod 28;         //종성 Index
  Result := (Trim(CO_JONGSUNG_TBL[nJongIdx + 1]) <> EmptyStr);
end;

//AUnicode가 한글 음절이면 True
class function TSyllable.SplitSyllabic(const AUnicode: WideChar; var AChoSung, AJungSung, AJongSung: WideChar): boolean;
var
  nCode: Cardinal;
  nValue, nChoIdx, nJungIdx, nJongIdx: Integer;
begin
  Result := True;
  nValue := Integer(AUniCode);
  if (nValue < CO_UNICODE_HANGEUL_BASE) or (nValue > CO_UNICODE_HANGEUL_LAST) then
  begin
    Result := False;
    Exit;
  end;

  nCode     := (nValue - CO_UNICODE_HANGEUL_BASE);
  nChoIdx   := nCode div (21 * 28); //초성 Index
  nCode     := nCode mod (21 * 28);
  nJungIdx  := nCode div 28;        //중성 Index
  nJongIdx  := nCode mod 28;        //종성 Index
  AChoSung  := CO_CHOSUNG_TBL[nChoIdx + 1];
  AJungSung := CO_JUNGSUNG_TBL[nJungIdx + 1];
  AJongSung := CO_JONGSUNG_TBL[nJongIdx + 1];
end;

class function TSyllable.SplitSyllabic(const ASource: WideString): WideString;
begin
  Result := SplitSyllabic(ASource, False);
end;

class function TSyllable.SplitSyllabic(const ASource: WideString; const AChoSungOnly: boolean): WideString;
var
  i: integer;
  cChoSung, cJungSung, cJongSung: WideChar;
begin
  Result := '';
  if (ASource = '') then
    Exit;

  for i := 1 to Length(ASource) do
  begin
    if (not SplitSyllabic(ASource[i], cChoSung, cJungSung, cJongSung)) then
      Result := Result + ASource[i]
    else
    begin
      if AChoSungOnly then
        Result := (Result + cChoSung)
      else
        Result := (Result + cChoSung + cJungSung + cJongSung);
    end;
  end;
end;

class function TSyllable.MergeSyllabic(const AChoSung, AJungSung, AJongSung: WideChar): WideChar;
var
  nCode, nChoIdx, nJungIdx, nJongIdx: Integer;
begin
  Result := #0;
  nChoIdx := Pred(Pos(AChoSung, CO_CHOSUNG_TBL));
  nJungIdx := Pred(Pos(AJungSung, CO_JUNGSUNG_TBL));
  nJongIdx := Pred(Pos(AJongSung, CO_JONGSUNG_TBL));
  if (nChoIdx = -1) and (nJungIdx = -1) and (nJongIdx = -1) then
    Exit;

  nCode := CO_UNICODE_HANGEUL_BASE +(nChoIdx * 21 + nJungIdx) * 28 + nJongIdx;
  Result := WideChar(nCode);
end;

end.
