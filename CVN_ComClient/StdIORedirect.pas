unit StdIORedirect;
  {$WARN   SYMBOL_DEPRECATED   OFF}     
interface
    
uses
Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,SyncObjs;
type
TOnText = procedure   (sender   :   TObject;   st   :   string)   of   object;
TStdIORedirect = class(TComponent)
private
fErrorRead:THandle;
fOutputRead:THandle;
fInputWrite:THandle;
fErrorWrite :THandle;                                                  
fOutputWrite:THandle;
fInputRead :THandle;
fProcessInfo:TProcessInformation;
fReturnValue:DWORD;
fOutputLineBuff:string;
fErrorLineBuff:string;
fErrorText:TStrings;
fOutputText:TStrings;
fInputText:TStrings;
fOutputStream :TStream;
fErrorStream :TStream;
fOutputStreamPos :Integer;
fErrorStreamPos :Integer;
fOnErrorText:TOnText;
fOnOutputText:TOnText;
fInputEvent:TEvent;
fRunning:boolean;
fOnTerminate:TNotifyEvent;
procedure CreateHandles;
procedure DestroyHandles;
procedure HandleOutput;
{   Private   declarations   }
protected
property StdOutRead :THandle read fOutputRead;
property StdInWrite :THandle read fInputWrite;
property StdErrRead :THandle read fErrorRead;
procedure PrepareStartupInformation(var info:TStartupInfo);
public

constructor Create(AOwner:TComponent);override;
destructor Destroy;override;
procedure Run(fileName,cmdLine,directory:string);
procedure AddInputText (const st :string);
procedure Terminate;

property ReturnValue:DWORD read fReturnValue;
property OutputText:TStrings read fOutputText;
property ErrorText:TStrings read fErrorText;
property Running : boolean read fRunning;
published
property OnOutputText :TOnText read fOnOutputText write fOnOutputText;
property OnErrorText :TOnText read fOnErrorText write fOnErrorText;
property OnTerminate :TNotifyEvent read fOnTerminate write fOnTerminate;
end;
procedure   Register;
implementation
procedure   Register;
begin
RegisterComponents('Misc   Units',[TStdIORedirect]);
end;
type
TStdIOInputThread = class(TThread)
private
fParent :TStdIORedirect;
protected
procedure Execute;override;
public
constructor Create(AParent:TStdIORedirect);
end;
TStdIOOutputThread = class(TThread)
private
fParent :TStdIORedirect;
protected
procedure Execute;override;
public
constructor Create(AParent:TStdIORedirect);
end;
{   TStdIORedirect   }
procedure TStdIORedirect.AddInputText(const st:string);
begin
fInputText.Add(st);
fInputEvent.SetEvent
end;
constructor TStdIORedirect.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
fOutputText := TStringList.Create;
fErrorText := TStringList.Create;
fInputText := TStringList.Create;
fInputEvent := TEvent.Create(Nil,False,False,'');
end;     
    
procedure   TStdIORedirect.CreateHandles;     
var
sa :TSecurityAttributes;
hOutputReadTmp,hErrorReadTmp,hInputWriteTmp:THandle;
begin
DestroyHandles;
sa.nLength := sizeof(sa);
sa.lpSecurityDescriptor := Nil;
sa.bInheritHandle := True;
if not CreatePipe(hOutputReadTmp,fOutputWrite,@sa,0) then
RaiseLastWin32Error;
if not CreatePipe(hErrorReadTmp,fErrorWrite,@sa,0) then
RaiseLastWin32Error;
if not CreatePipe(fInputRead,hInputWriteTmp,@sa,0) then
RaiseLastWin32Error;
if not DuplicateHandle(GetCurrentProcess,hOutputReadTmp,GetCurrentProcess,@fOutputRead,0,FALSE,DUPLICATE_SAME_ACCESS)   then
RaiseLastWin32Error;
if not DuplicateHandle(GetCurrentProcess,hErrorReadTmp,GetCurrentProcess,@fErrorRead,0,FALSE,DUPLICATE_SAME_ACCESS)   then
RaiseLastWin32Error;
if not DuplicateHandle(GetCurrentProcess,hInputWriteTmp,GetCurrentProcess,@fInputWrite,0,FALSE,DUPLICATE_SAME_ACCESS)   then
RaiseLastWin32Error;
CloseHandle(hOutputReadTmp);
CloseHandle(hErrorReadTmp);
CloseHandle(hInputWriteTmp);
fOutputStream := TMemoryStream.Create;
fErrorStream := TMemoryStream.Create;
fOutputStreamPos := 0;
fErrorStreamPos := 0;
fOutputText.Clear;
fErrorText.Clear;
end;     
destructor TStdIORedirect.Destroy;
begin
DestroyHandles;
fOutputText.Free;
fErrorText.Free;
fInputEvent.Free;
fInputText.Free;
inherited;
end;
  
procedure TStdIORedirect.DestroyHandles;     
begin
if fInputRead <> 0 then
CloseHandle(fInputRead);
if fOutputRead<> 0 then
CloseHandle(fOutputRead);
if fErrorRead <> 0 then
CloseHandle(fErrorRead);
if fInputWrite<> 0 then
CloseHandle(fInputWrite);
if fOutputWrite<>0 then
CloseHandle(fOutputWrite);
if fErrorWrite<>0 then
CloseHandle(fErrorWrite);
fInputRead := 0;
fOutputRead := 0;
fErrorRead := 0;
fInputWrite := 0;
fOutputWrite := 0;
fErrorWrite := 0;
fErrorStream.Free; fErrorStream := Nil;
fOutputStream.Free; fOutputStream := Nil;
end;     
    
procedure TStdIORedirect.HandleOutput;
var
ch:char;
begin
fOutputStream.Position := fOutputStreamPos;
while   fOutputStream.Position < fOutputStream.Size   do
begin
fOutputStream.Read(ch,sizeof(ch));
case ch of
#13:begin
    fOutputText.Add(fOutputLineBuff);
    if Assigned(OnOutputText) then
    OnOutputText(self,fOutputLineBuff);
    fOutputLineBuff := '';
    end;
#0..#12,   #14..#31   :;
else
fOutputLineBuff := fOutputLineBuff + ch
end
end;
fOutputStreamPos := fOutputStream.Position;
fErrorStream.Position := fErrorStreamPos;
while fErrorStream.Position < fErrorStream.Size   do
begin
fErrorStream.Read (ch,sizeof(ch));
case ch of
#13:begin
    fErrorText.Add(fErrorLineBuff);
    if Assigned(OnErrorText) then
    OnErrorText(self,fErrorLineBuff);
    fErrorLineBuff := '';
    end;
#0..#12,   #14..#31   :;
else
fErrorLineBuff := fErrorLineBuff + ch
end
end;
fErrorStreamPos := fErrorStream.Position;
end;
    
procedure TStdIORedirect.PrepareStartupInformation(
var
info:TStartupInfo);
begin
info.cb := sizeof(info);
info.dwFlags := info.dwFlags or STARTF_USESTDHANDLES;
info.hStdInput := fInputRead;
info.hStdOutput := fOutputWrite;
info.hStdError := fErrorWrite;
end;
    
procedure TStdIORedirect.Run(fileName,cmdLine,directory:string);
var
startupInfo :TStartupInfo;
pOK :boolean;
fName,cLine,dir:PChar;
begin
if not Running then
begin
FillChar(startupInfo,sizeof(StartupInfo),0);
CreateHandles;
PrepareStartupInformation (startupInfo);
if fileName<>''then
fName := PChar(fileName)
else
fName := Nil;
if cmdLine <>''then
cLine := PChar(cmdLine)
else
cLine := Nil;
if directory <>''then
dir := PChar(directory)
else
dir := Nil;
pOK := CreateProcess(fName,cLine,Nil,Nil,true,CREATE_NO_WINDOW,Nil,dir,startupInfo,fProcessInfo);
CloseHandle (fOutputWrite);
fOutputWrite := 0;
CloseHandle(fInputRead);
fInputRead := 0;
CloseHandle(fErrorWrite);
fErrorWrite := 0;
if pOK then
begin
fRunning := True;
try
TStdIOInputThread.Create(self);
TStdIOOutputThread.Create(self);
while   MsgWaitForMultipleObjects(1,fProcessInfo.hProcess,False,INFINITE,QS_ALLINPUT)= WAIT_OBJECT_0 + 1 do
application.ProcessMessages;
if   not GetExitCodeProcess (fProcessInfo.hProcess,fReturnValue) then
RaiseLastWin32Error;
finally
  try
    fInputText.Clear;
    CloseHandle(fProcessInfo.hThread);
    CloseHandle(fProcessInfo.hProcess);
    fRunning := False;
    if   Assigned(OnTerminate)   then
    OnTerminate(self);
  except
  end;
end;


end
else
RaiseLastWin32Error
end
end;
    
procedure TStdIORedirect.Terminate;
begin
if Running  then
TerminateProcess(fProcessInfo.hProcess,0);
end;
    
  {   TStdIOInputThread   }     
    
constructor TStdIOInputThread.Create(AParent:   TStdIORedirect);
begin
inherited Create(True);
FreeOnTerminate := True;
fParent := AParent;
Resume
end;
    
function CopyTextToPipe(handle:THandle;text:TStrings):boolean;
var
i :Integer;
st :string;
bytesWritten :DWORD;
p :Integer;
bTerminate :boolean;
begin
bTerminate := False;
for i := 0 to text.Count-1 do
begin
st := text[i];
p := Pos(#26,st);
if p > 0 then
begin
st := Copy(st,1,p - 1);
bTerminate := True;
end
else
st := st + #13#10;
if st<> ''then
if not WriteFile(handle,st[1],Length(st),bytesWritten,Nil)   then
if GetLastError <> ERROR_NO_DATA   then
RaiseLastWin32Error;
end;
result := bTerminate;
text.Clear
end;
    
procedure TStdIOInputThread.Execute;
var
objects :array[0..1]of THandle;
objectNo :DWORD;
begin
if fParent.fInputText.Count > 0 then
fParent.fInputEvent.SetEvent;
objects[0]:= fParent.fProcessInfo.hProcess;
objects [1]:= fParent.fInputEvent.Handle;
while True do
begin
objectNo := WaitForMultipleObjects(2,@objects[0],False,INFINITE);
case objectNo of
WAIT_OBJECT_0 + 1 :
if   CopyTextToPipe (fParent.fInputWrite,fParent.fInputText)   then
begin
CloseHandle (fParent.fInputWrite);
fParent.fInputWrite := 0;
break
end;
else
break;
end
end
end;
    
  {   TStdIOOutputThread   }     

constructor TStdIOOutputThread.Create(AParent:TStdIORedirect);
begin
inherited Create(True);
FreeOnTerminate := True;
fParent := AParent;
Resume
end;

procedure TStdIOOutputThread.Execute;
var
  buffer:array[0..1023]of char;
  bytesRead :DWORD;
begin
  while ReadFile(fParent.fOutputRead,buffer,1024,bytesRead,Nil)and(bytesRead > 0) do
    begin
      fParent.fOutputStream.Seek(0,soFromEnd);
      fParent.fOutputStream.Write(buffer[0],bytesRead);
      Synchronize(fParent.HandleOutput)
    end
  end;
   
end.
