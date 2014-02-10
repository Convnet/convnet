unit ping;

interface

uses

Windows, SysUtils, Classes,  Controls, Winsock,
StdCtrls;

type
PIPOptionInformation = ^TIPOptionInformation;
TIPOptionInformation = packed record
TTL: Byte;
TOS: Byte;
Flags: Byte;
OptionsSize: Byte;
OptionsData: PChar;
end;

PIcmpEchoReply = ^TIcmpEchoReply;
TIcmpEchoReply = packed record
Address: DWORD;
Status: DWORD;
RTT: DWORD;
DataSize: Word;
Reserved: Word;
Data: Pointer;
Options: TIPOptionInformation;
end;

TIcmpCreateFile = function: THandle; stdcall;
TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall;
TIcmpSendEcho = function(IcmpHandle:THandle;
DestinationAddress: DWORD;
RequestData: Pointer;
RequestSize: Word;
RequestOptions: PIPOptionInformation;
ReplyBuffer: Pointer;
ReplySize: DWord;
Timeout: DWord
): DWord; stdcall;

Tping =class(Tobject)

private
{ Private declarations }
hICMP: THANDLE;
IcmpCreateFile : TIcmpCreateFile;
IcmpCloseHandle: TIcmpCloseHandle;
IcmpSendEcho: TIcmpSendEcho;
public
procedure   pinghost(ip:string;var info:string);
constructor create;
destructor destroy;override;
{ Public declarations }
end;

var
hICMPdll: HMODULE;

implementation

constructor Tping.create;
begin
inherited create;
hICMPdll := LoadLibrary('icmp.dll');
@ICMPCreateFile := GetProcAddress(hICMPdll, 'IcmpCreateFile');
@IcmpCloseHandle := GetProcAddress(hICMPdll,'IcmpCloseHandle');
@IcmpSendEcho := GetProcAddress(hICMPdll, 'IcmpSendEcho');
hICMP := IcmpCreateFile;
end;

destructor Tping.destroy;
begin
FreeLibrary(hIcmpDll);
inherited destroy;
end;


procedure Tping.pinghost(ip:string;var info:string);
var
// IP Options for packet to send
IPOpt:TIPOptionInformation;
FIPAddress:DWORD;
pReqData,pRevData:PChar;
// ICMP Echo reply buffer
pIPE:PIcmpEchoReply;
FSize: DWORD;
MyString:string;
FTimeOut:DWORD;
BufferSize:DWORD;
begin


if ip <> '' then
begin
FIPAddress := inet_addr(PChar(ip));
FSize := 40;
BufferSize := SizeOf(TICMPEchoReply) + FSize;
GetMem(pRevData,FSize);
GetMem(pIPE,BufferSize);
FillChar(pIPE^, SizeOf(pIPE^), 0);
pIPE^.Data := pRevData;
MyString := 'T';
pReqData := PChar(MyString);
FillChar(IPOpt, Sizeof(IPOpt), 0);
IPOpt.TTL := 1;
FTimeOut := 100;
try
IcmpSendEcho(hICMP, FIPAddress, pReqData, Length(MyString),@IPOpt, pIPE, BufferSize, FTimeOut);
if pReqData^ = pIPE^.Options.OptionsData^ then
info:=IntToStr(pIPE^.RTT);
except
info:='Can not find host!';
FreeMem(pRevData);
FreeMem(pIPE);
Exit;
end;
FreeMem(pRevData);
FreeMem(pIPE);
end;

end;

end.
