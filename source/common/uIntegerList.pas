unit uIntegerList;

interface

uses
  Classes;

type
  TIntegerList = class;
  TIntegerListSortCompare = function(AList: TIntegerList; const Index1, Index2: Integer): Integer;

  TIntegerList = class(TObject)
  private
    FList: TList;
    FDuplicates: TDuplicates;
    FSorted: Boolean;

    function GetItems(const AIndex: Integer): Integer;
    procedure SetItems(const AIndex, AValue: Integer);
    function GetCapacity: Integer;
    function GetCount: Integer;
    procedure SetCapacity(const AValue: Integer);
    procedure SetCount(const AValue: Integer);
    procedure SetSorted(const AValue: Boolean);
  protected
    procedure Sort; virtual;
    procedure QuickSort(ALeft, ARight: Integer; SCompare: TIntegerListSortCompare);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AItem: Integer): Integer;
    procedure Insert(const AIndex, AItem: Integer);
    function First: Integer;
    function Last: Integer;
    procedure Clear;
    procedure Delete(const AIndex: Integer);
    function Find(const AValue: Integer; var AIndex: Integer): Boolean; virtual;
    procedure Exchange(const AIndex1, AIndex2: Integer);
    procedure Move(const ACurIndex, ANewIndex: Integer);
    procedure Pack;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Items[const AIndex: Integer]: Integer read GetItems write SetItems; default;
    property Sorted: Boolean read FSorted write SetSorted;
  end;

implementation

{ TIntegerList }

function IntegerListCompare(AList: TIntegerList; const AIndex1, AIndex2: Integer): Integer;
begin
  if (AList[AIndex1] < AList[AIndex2]) then
    Result := -1
  else if (AList[AIndex1] > AList[AIndex2]) then
    Result := 1
  else
    Result := 0;
end;

function TIntegerList.Add(const AItem: Integer): Integer;
begin
  if not Sorted then
    Result := FList.Add(Pointer(AItem))
  else if Find(AItem, Result) then
    case Duplicates of
      dupIgnore:
        Exit;
      //dupError: Error(@SDuplicateString, 0);
      dupError:
        Exit;
    end;
  Insert(Result, AItem);
end;

procedure TIntegerList.Clear;
begin
  FList.Clear;
end;

constructor TIntegerList.Create;
begin
  inherited;

  FList := TList.Create;
end;

procedure TIntegerList.Delete(const AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

destructor TIntegerList.Destroy;
begin
  FList.Free;

  inherited;
end;

procedure TIntegerList.Exchange(const AIndex1, AIndex2: Integer);
begin
  FList.Exchange(AIndex1, AIndex2);
end;

function TIntegerList.Find(const AValue: Integer; var AIndex: Integer): Boolean;
  function IntegerCompare(const AValue1, AValue2: Integer): Integer;
  begin
    if (AValue1 < AValue2) then
      Result := -1
    else if (AValue1 > AValue2) then
      Result := 1
    else
      Result := 0;
  end;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FList.Count - 1;
  while (L <= H) do
  begin
    I := (L + H) shr 1;
    C := IntegerCompare(Items[I], AValue);
    if (C < 0) then
      L := I + 1
    else
    begin
      H := I - 1;
      if (C = 0) then
      begin
        Result := True;
        if (Duplicates <> dupAccept) then
          L := I;
      end;
    end;
  end;
  AIndex := L;
end;

function TIntegerList.First: Integer;
begin
  Result := Integer(FList.First);
end;

function TIntegerList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TIntegerList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TIntegerList.GetItems(const AIndex: Integer): Integer;
begin
  Result := Integer(FList.Items[AIndex]);
end;

procedure TIntegerList.Insert(const AIndex, AItem: Integer);
begin
  FList.Insert(AIndex, Pointer(AItem));
end;

function TIntegerList.Last(): Integer;
begin
  Result := Integer(FList.Last());
end;

procedure TIntegerList.Move(const ACurIndex, ANewIndex: Integer);
begin
  FList.Move(ACurIndex, ANewIndex);
end;

procedure TIntegerList.Pack;
begin
  FList.Pack;
end;

procedure TIntegerList.QuickSort(ALeft, ARight: Integer; SCompare: TIntegerListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := ALeft;
    J := ARight;
    P := (ALeft + ARight) shr 1;
    repeat
      while (SCompare(Self, I, P) < 0) do
        Inc(I);
      while (SCompare(Self, J, P) > 0) do
        Dec(J);
      if (I <= J) then
      begin
        Exchange(I, J);
        if (P = I) then
          P := J
        else if (P = J) then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until (I > J);
    if (ALeft < J) then
      QuickSort(ALeft, J, SCompare);
    ALeft := I;
  until (I >= ARight);
end;

procedure TIntegerList.SetCapacity(const AValue: Integer);
begin
  FList.Capacity := AValue;
end;

procedure TIntegerList.SetCount(const AValue: Integer);
begin
  FList.Count := AValue;
end;

procedure TIntegerList.SetItems(const AIndex, AValue: Integer);
begin
  FList.Items[AIndex] := Pointer(AValue);
end;

procedure TIntegerList.SetSorted(const AValue: Boolean);
begin
  if (FSorted <> AValue) then
  begin
    if AValue then
      Sort;
    FSorted := AValue;
  end;
end;

procedure TIntegerList.Sort;
begin
  if not Sorted and (FList.Count > 1) then
  begin
    //Changing;
    QuickSort(0, FList.Count - 1, IntegerListCompare);
    //Changed;
  end;
end;

end.
