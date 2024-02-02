unit uDelay;

interface

implementation

procedure DelayConsole(Msecs: Integer);
{Works for applications without the forms unit}
var
  dwFirstTickCount: Dword;
begin
  dwFirstTickCount := GetTickCount;
  repeat
    Sleep(1);
  until ((GetTickCount - dwFirstTickCount) >= dword(Msecs));
end;

procedure DelayApplication(Msecs: Integer);
{Works for applications that include the forms unit}
var
  dwFirstTickCount: Dword;
begin
  dwFirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until ((GetTickCount - dwFirstTickCount) >= DWORD(Msecs));
end;

procedure DelayByThread(Msecs: Integer);
{
Create a new waiting thread probably overkill
but just another way to delay execution of our
main thread
}
  procedure DelayThread(P: Pointer); stdcall;
  begin
    Sleep(DWORD(P));
  end;
var
  dwThrID: DWORD;
  hThr: Longword;
begin
  hThr := CreateThread(nil, 0, @DelayThread, Pointer(Msecs), 0, dwThrID);
  WaitForSingleObject(hthr, INFINITE);
end;

procedure DelayBySleep(Msecs: DWORD);
begin
  Sleep(Msecs);
end;

end.

