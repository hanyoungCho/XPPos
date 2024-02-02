unit uCpuUsage;

interface

const
  { minimum amount of time that must have elapsed to calculate CPU usage, miliseconds.
    If time elapsed is less than this, previous result is returned, or zero, if there is no previous result. }
  wsMinMeasurementInterval = 250;

type
  PCPUUsageData = ^TCPUUsageData;
  TCPUUsageData = record
    PID, Handle: Cardinal;
    oldUser, oldKernel: Int64;
    LastUpdateTime: Cardinal;
    LastUsage: Single; // Last result of wsGetCpuUsage is saved here
    Tag: Cardinal; // Use it for anythin you like, not modified by this unit
  end;

function WSCreateCpuUsageCounter(AProcessID: Cardinal): PCPUUsageData;
procedure WSDestroyCpuUsageCounter(ACounter: PCPUUsageData);
function WSGetCpuUsage(ACounter: PCPUUsageData): Single;
function WSGetNumberOfProcessors: Integer;

implementation

uses
  Windows;

function WSCreateCpuUsageCounter(AProcessID: Cardinal): PCPUUsageData;
var
  P: PCPUUsageData;
  H: Cardinal;
  mCreationTime, mExitTime, mKernelTime, mUserTime: _FILETIME;
begin
  Result := nil;
  // We need a handle with PROCESS_QUERY_INFORMATION privileges
  H := OpenProcess(PROCESS_QUERY_INFORMATION, False, AProcessID); //PROCESS_ALL_ACCESS
  if (H = 0) then
    Exit;

  New(P);
  P.PID := AProcessID;
  P.Handle := H;
  P.LastUpdateTime := GetTickCount;
  P.LastUsage := 0;
  if GetProcessTimes(P.Handle, mCreationTime, mExitTime, mKernelTime, mUserTime) then
  begin
    // convert _FILETIME to Int64
    P.oldKernel := Int64(mKernelTime.dwLowDateTime or (mKernelTime.dwHighDateTime shr 32));
    P.oldUser := Int64(mUserTime.dwLowDateTime or (mUserTime.dwHighDateTime shr 32));
    Result := P;
  end
  else
    Dispose(P);
end;

procedure WSDestroyCpuUsageCounter(ACounter: PCPUUsageData);
begin
  CloseHandle(ACounter.Handle);
  Dispose(ACounter);
end;

function WSGetCpuUsage(ACounter: PCPUUsageData): Single;
var
  mCreationTime, mExitTime, mKernelTime, mUserTime: _FILETIME;
  DeltaMs, ThisTime: Cardinal;
  mKernel, mUser, mDelta: Int64;
begin
  Result := ACounter.LastUsage;
  ThisTime := GetTickCount; // Get the time elapsed since last query
  DeltaMs := (ThisTime - ACounter.LastUpdateTime);
  if (DeltaMs < wsMinMeasurementInterval) then
    Exit;

  ACounter.LastUpdateTime := ThisTime;
  GetProcessTimes(ACounter.Handle, mCreationTime, mExitTime, mKernelTime, mUserTime);
  mKernel := Int64(mKernelTime.dwLowDateTime or (mKernelTime.dwHighDateTime shr 32)); // convert _FILETIME to Int64.
  mUser := Int64(mUserTime.dwLowDateTime or (mUserTime.dwHighDateTime shr 32));
  mDelta := (mUser + mKernel - ACounter.oldUser - ACounter.oldKernel); // get the delta

  ACounter.oldUser := mUser;
  ACounter.oldKernel := mKernel;
  Result := (mDelta / DeltaMs) / 100; // mDelta is in units of 100 nanoseconds, so¡¦
  ACounter.LastUsage := Result; // just in case you want to use it later, too
end;

function WSGetNumberOfProcessors: Integer;
var
   SI: TSystemInfo;
begin
   GetSystemInfo(si);
   Result := SI.dwNumberOfProcessors;
end;

end.
