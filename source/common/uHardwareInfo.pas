unit uHardwareInfo;

interface

uses Classes, SysUtils, ActiveX, ComObj, Variants;


type
   TMotherBoardInfo   = (Mb_SerialNumber,Mb_Manufacturer,Mb_Product,Mb_Model);
   TMotherBoardInfoSet= set of TMotherBoardInfo;
   TProcessorInfo     = (Pr_Description,Pr_Manufacturer,Pr_Name,Pr_ProcessorId,Pr_UniqueId);
   TProcessorInfoSet  = set of TProcessorInfo;
   TBIOSInfo          = (Bs_BIOSVersion,Bs_BuildNumber,Bs_Description,Bs_Manufacturer,Bs_Name,Bs_SerialNumber,Bs_Version);
   TBIOSInfoSet       = set of TBIOSInfo;
   TOSInfo            = (Os_BuildNumber,Os_BuildType,Os_Manufacturer,Os_Name,Os_SerialNumber,Os_Version);
   TOSInfoSet         = set of TOSInfo;
   TDiskInfo          = (Dk_DeviceId,Dk_Caption,Dk_VolumeSerialNumber, Dk_FreeSpace);
   TDiskInfoSet       = set of TDiskInfo;
   TCacheInfo         = (Ca_BlockSize, Ca_CacheType, Ca_MaxCacheSize);
   TCacheInfoSet      = set of TCacheInfo;

const //properties names to get the data
   MotherBoardInfoArr: array[TMotherBoardInfo] of AnsiString =
                        ('SerialNumber','Manufacturer','Product','Model');

   OsInfoArr         : array[TOSInfo] of AnsiString =
                        ('BuildNumber','BuildType','Manufacturer','Name','SerialNumber','Version');

   BiosInfoArr       : array[TBIOSInfo] of AnsiString =
                        ('BIOSVersion','BuildNumber','Description','Manufacturer','Name','SerialNumber','Version');

   ProcessorInfoArr  : array[TProcessorInfo] of AnsiString =
                        ('Description','Manufacturer','Name','ProcessorId','UniqueId');

   DiskInfoArr       : array[TDiskInfo] of AnsiString =
                        ('DeviceID', 'Caption', 'VolumeSerialNumber', 'FreeSpace');

   CacheInfoArr      : array[TCacheInfo] of AnsiString =
                        ('BlockSize', 'CacheType', 'MaxCacheSize');

type
   THardwareId  = class
   private
    FOSInfo         : TOSInfoSet;
    FBIOSInfo       : TBIOSInfoSet;
    FProcessorInfo  : TProcessorInfoSet;
    FMotherBoardInfo: TMotherBoardInfoSet;
    FDiskInfo       : TDiskInfoSet;
    FCacheInfo      : TCacheInfoSet;
    FBuffer         : AnsiString;
    function GetHardwareIdHex: AnsiString;
   public
     //Set the properties to  be used in the generation of the hardware id
    property  MotherBoardInfo : TMotherBoardInfoSet read FMotherBoardInfo write FMotherBoardInfo;
    property  ProcessorInfo : TProcessorInfoSet read FProcessorInfo write FProcessorInfo;
    property  BIOSInfo: TBIOSInfoSet read FBIOSInfo write FBIOSInfo;
    property  OSInfo  : TOSInfoSet read FOSInfo write FOSInfo;
    property  DiskInfo : TDiskInfoSet read FDiskInfo write FDiskInfo;
    property  CacheInfo : TCacheInfoSet read FCacheInfo write FcacheInfo;
    property  Buffer : AnsiString read FBuffer; //return the content of the data collected in the system
    property  HardwareIdHex : AnsiString read GetHardwareIdHex; //get a hexadecimal represntation of the data collected
    procedure GenerateHardwareId; //calculate the hardware id
    constructor  Create(Generate:Boolean=True); overload;
    Destructor  Destroy; override;
    //get info about motherboard, os, bios, cpu, all disks, cache
    procedure GetMachineInfo(ASection: string; AResult: TStringList);

   end;

implementation


//filter non-printable chars
function FilterNonPrintableChars(ds_sn: AnsiString): AnsiString;
var
  sTmp: AnsiString;
  iTmp: Integer;
begin
  sTmp:= '';
  for iTmp:= 1 to Length(ds_sn) do
  begin
    if (Ord(ds_sn[iTmp]) in [32..126]) then
      sTmp:= sTmp + ds_sn[iTmp];
  end;
  if (UpperCase(sTmp) = 'NULL') then
    sTmp:= '';
  result:= sTmp;
end;


function VarArrayToStr(const vArray: variant): AnsiString;
  function _VarToStr(const V: variant): AnsiString;
  var
  Vt: integer;
  begin
    Vt := VarType(V);
    case Vt of
      varSmallint,
      varInteger  : Result := AnsiString(IntToStr(integer(V)));
      varSingle,
      varDouble,
      varCurrency : Result := AnsiString(FloatToStr(Double(V)));
      varDate     : Result := AnsiString(VarToStr(V));
      varOleStr   : Result := AnsiString(WideString(V));
      varBoolean  : Result := AnsiString(VarToStr(V));
      varVariant  : Result := AnsiString(VarToStr(Variant(V)));
      varByte     : Result := AnsiChar(byte(V));
      varString   : Result := AnsiString(V);
      varArray    : Result := VarArrayToStr(Variant(V));
    end;
  end;

var
i : integer;
begin
    Result := '[';
    if (VarType(vArray) and VarArray)=0 then
       Result := _VarToStr(vArray)
    else
    for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
     if i=VarArrayLowBound(vArray, 1)  then
      Result := Result+_VarToStr(vArray[i])
     else
      Result := Result+'|'+_VarToStr(vArray[i]);

    Result:=Result+']';
end;

function VarStrNull(const V:OleVariant):AnsiString; //avoid problems with null strings
begin
  Result:='';
  if not VarIsNull(V) then
  begin
    if VarIsArray(V) then
       Result:=VarArrayToStr(V)
    else
    Result:=AnsiString(VarToStr(V));
  end;
end;

{ THardwareId }

constructor THardwareId.Create(Generate:Boolean=True);
begin
   inherited Create;
   CoInitialize(nil);
   FBuffer          :='';
   //Set the propeties to be used in the hardware id generation
   FMotherBoardInfo :=[Mb_SerialNumber,Mb_Manufacturer,Mb_Product,Mb_Model];
   FOSInfo          :=[Os_BuildNumber,Os_BuildType,Os_Manufacturer,Os_Name,Os_SerialNumber,Os_Version];
   FBIOSInfo        :=[Bs_BIOSVersion,Bs_BuildNumber,Bs_Description,Bs_Manufacturer,Bs_Name,Bs_SerialNumber,Bs_Version];
//   FProcessorInfo   :=[];//including the processor info is expensive [Pr_Description,Pr_Manufacturer,Pr_Name,Pr_ProcessorId,Pr_UniqueId];
   FProcessorInfo   :=[Pr_Description,Pr_Manufacturer,Pr_Name,Pr_ProcessorId,Pr_UniqueId];
   FDiskInfo        :=[Dk_DeviceId,Dk_Caption,Dk_VolumeSerialNumber, Dk_FreeSpace];
   FCacheInfo       :=[Ca_BlockSize, Ca_CacheType, Ca_MaxCacheSize];
   if Generate then
     GenerateHardwareId;
end;

destructor THardwareId.Destroy;
begin
  CoUninitialize;
  inherited;
end;

//Main function which collect the system data.
procedure THardwareId.GenerateHardwareId;
var
  objSWbemLocator : OLEVariant;
  objWMIService   : OLEVariant;
  objWbemObjectSet: OLEVariant;
  oWmiObject      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
  SDummy          : AnsiString;
  Mb              : TMotherBoardInfo;
  Os              : TOSInfo;
  Bs              : TBIOSInfo;
  Pr              : TProcessorInfo;
  Dk              : TDiskInfo;
  Ca              : TCacheInfo;
begin;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer('localhost','root\cimv2', '','');

  if FMotherBoardInfo<>[] then //MotherBoard info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_BaseBoard','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Mb := Low(TMotherBoardInfo) to High(TMotherBoardInfo) do
       if Mb in FMotherBoardInfo then
       begin
          SDummy:= VarStrNull(oWmiObject.Properties_.Item(MotherBoardInfoArr[Mb]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;

  if FOSInfo<>[] then//Windows info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_OperatingSystem','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Os := Low(TOSInfo) to High(TOSInfo) do
       if Os in FOSInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(OsInfoArr[Os]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;

  if FBIOSInfo<>[] then//BIOS info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_BIOS','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Bs := Low(TBIOSInfo) to High(TBIOSInfo) do
       if Bs in FBIOSInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(BiosInfoArr[Bs]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;

  if FProcessorInfo<>[] then//CPU info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_Processor','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Pr := Low(TProcessorInfo) to High(TProcessorInfo) do
       if Pr in FProcessorInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(ProcessorInfoArr[Pr]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;

  if FDiskInfo<>[] then//all disks info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_LogicalDisk','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Dk := Low(TDiskInfo) to High(TDiskInfo) do
       if Dk in FDiskInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(DiskInfoArr[Dk]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;

  if FCacheInfo<>[] then//cache info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_CacheMemory','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Ca := Low(TCacheInfo) to High(TCacheInfo) do
       if Ca in FCacheInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(CacheInfoArr[Ca]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          FBuffer:=FBuffer+SDummy;
       end;
       oWmiObject:=Unassigned;
    end;
  end;


end;

function THardwareId.GetHardwareIdHex: AnsiString;
begin
    SetLength(Result,Length(FBuffer)*2);
    BinToHex(PAnsiChar(FBuffer),PAnsiChar(Result),Length(FBuffer));
end;


//get info about motherboard, os, bios, cpu, all disks, cache
procedure THardwareId.GetMachineInfo(ASection: string; AResult: TStringList);
var
  objSWbemLocator : OLEVariant;
  objWMIService   : OLEVariant;
  objWbemObjectSet: OLEVariant;
  oWmiObject      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
  SDummy          : AnsiString;
  Mb              : TMotherBoardInfo;
  Os              : TOSInfo;
  Bs              : TBIOSInfo;
  Pr              : TProcessorInfo;
  Dk              : TDiskInfo;
  Ca              : TCacheInfo;
begin;
  AResult.Clear;

  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer('localhost','root\cimv2', '','');

  if Lowercase(ASection) = 'motherboard' then //MotherBoard info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_BaseBoard','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Mb := Low(TMotherBoardInfo) to High(TMotherBoardInfo) do
       if Mb in FMotherBoardInfo then
       begin
          SDummy := VarStrNull(oWmiObject.Properties_.Item(MotherBoardInfoArr[Mb]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(MotherBoardInfoArr[Mb] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;

  if Lowercase(ASection) = 'windows'  then//Windows info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_OperatingSystem','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Os := Low(TOSInfo) to High(TOSInfo) do
       if Os in FOSInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(OsInfoArr[Os]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(OsInfoArr[Os] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;

  if Lowercase(ASection) = 'bios' then//BIOS info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_BIOS','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Bs := Low(TBIOSInfo) to High(TBIOSInfo) do
       if Bs in FBIOSInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(BiosInfoArr[Bs]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(BiosInfoArr[Bs] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;

  if Lowercase(ASection) = 'cpu' then//CPU info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_Processor','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Pr := Low(TProcessorInfo) to High(TProcessorInfo) do
       if Pr in FProcessorInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(ProcessorInfoArr[Pr]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(ProcessorInfoArr[Pr] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;

  if Lowercase(ASection) = 'disk' then//DISK info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_LogicalDisk','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Dk := Low(TDiskInfo) to High(TDiskInfo) do
       if Dk in FDiskInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(DiskInfoArr[Dk]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(DiskInfoArr[Dk] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;

  if Lowercase(ASection) = 'cache' then//CACHE info
  begin
    objWbemObjectSet:= objWMIService.ExecQuery('SELECT * FROM Win32_CacheMemory','WQL',0);
    oEnum           := IUnknown(objWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, oWmiObject, iValue) = 0 do
    begin
      for Ca := Low(TCacheInfo) to High(TCacheInfo) do
       if Ca in FCacheInfo then
       begin
          SDummy:=VarStrNull(oWmiObject.Properties_.Item(CacheInfoArr[Ca]).Value);
          SDummy := FilterNonPrintableChars(SDummy);
          if SDummy <> '' then
            AResult.Add(CacheInfoArr[Ca] + ': ' + SDummy);
       end;
       oWmiObject:=Unassigned;
    end;
    exit;
  end;






end;




end.
