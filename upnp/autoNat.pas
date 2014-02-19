//
// -----------------------------------------------------------------------------------------------
//
//   TAutoNAT -- �Զ�����·�����˿�ӳ����ؼ� For delphi 4,5,6,7,2005
//
//             ���ߣ� ������     ��д���ڣ�2007��10��
//
//             �����ʼ���support@quickburro.com   ��ϵ�绰��0571-69979828
//
// -----------------------------------------------------------------------------------------------
//
unit autoNat;

interface

uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Scktcomp, NMUDP, extctrls;

//
// �����¼���...
type
TTaskSuccessEvent = procedure (Sender: TObject) of object;              {����ִ�гɹ��¼�}
TTaskFailEvent = procedure (Sender: TObject) of object;                 {����ִ��ʧ���¼�}

type
TAutoNAT = class(TComponent)
private
//
// ֻ������...
fTimeout: integer;           {����ʱֵ}
fTaskType: integer;          {�����б�: 1-���� 2-ȡ����ҳ��ַ 3-���Ӷ˿� 4-ȡ������ַ 5-ɾ���˿�}
fLocalIp: string;            {��������IP}
fRouterIp: string;           {·��������IP}
fRouterPort: integer;        {·�������ƶ˿�}
fRouterLocation: string;     {·�����豸λ��URL}
fRouterName: string;         {·�����豸����}
fRouterUSN: string;          {·�����豸��ʶ��}
fRouterURL: string;          {·����URL}
fExternalIp: string;         {·��������IP}
fControlURL: string;         {����ҳURL}
fServiceType: string;        {�������ʹ�}
fURLbase: string;            {����ҳ����ַ}
//
// �¼�...
FOnTaskSuccess: TNotifyEvent;    {����ִ�гɹ����¼�}
FOnTaskFail: TNotifyEvent;       {����ִ��ʧ�ܵ��¼�}
//
// ��ͨ����...
request: string;              {socket�������ݰ�}
requested: boolean;           {�����Ƿ��ѷ���}
response: string;             {socketӦ�����ݰ�}
//
UDP: TNMUDP;                           {UDP����}
Sock: TClientSocket;                   {Socket����}
TaskTimer: TTimer;                     {����ʱ��}
//
TaskExecuting: boolean;                {��ǰ�Ƿ���������ִ��}
Taskfinished: boolean;                 {�����Ƿ��Ѿ����}
Tasksuccess: boolean;                  {�����Ƿ�ɹ�}
//
// ����˽�й���...
procedure SetTimeout(Timeout: integer);
procedure SuccessEvent;
procedure FailEvent;
procedure TaskTimerTimer(Sender: TObject);        {��ʱ�¼�}
procedure UDPInvalidHost(var handled: Boolean);   {������Чʱ���¼�}
procedure UDPBufferInvalid(var handled: Boolean; var Buff: array of Char; var length: Integer);
procedure UDPStreamInvalid(var handled: Boolean; Stream: TStream);
procedure UDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port: Integer);
procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
function ResponseFinished(ResponseData: string): boolean;
procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
//
protected
{ Protected declarations }

public
//
// ��������...
Constructor Create(AOwner: TComponent); override;           {���󴴽�ʱ�ķ���}
//
// ��������...
Destructor Destroy(); override;                             {�������ķ���}
//
// ����·�����豸������1��...
function SearchRouter(): boolean;
//
// �õ�·��������ҳ{����2}...
function GetControlURL(): boolean;
//
// ���Ӷ˿�ӳ�������3��...
function AddNatMapping(NatPortName: string; ExternalPort: integer; LocalIp: string; LocalPort: integer; Protocol: string): boolean;
//
// ȡ����IP��ַ������4��...
function GetExternalIp: boolean;
//
// ɾ���˿�ӳ�������5��...
function DeleteNatMapping(ExternalPort: integer; Protocol: string): boolean;
//
published
//
// �ؼ�����...
property Timeout: integer read fTimeout write settimeout; {����ʱֵ}
property TaskType: integer read fTaskType;                {�����б�: 1-���� 2-ȡ����ҳ��ַ 3-���Ӷ˿� 4-ȡ������ַ 5-ɾ���˿�}
property LocalIp: string read fLocalIp;                   {��������IP}
property RouterIp: string read fRouterIp;                 {·��������IP}
property RouterPort: integer read fRouterPort;            {·�������ƶ˿�}
property RouterLocation: string read fRouterLocation;     {·�����豸λ��URL}
property RouterName: string read fRouterName;             {·�����豸����}
property RouterUSN: string read fRouterUSN;               {·�����豸��ʶ��}
property RouterURL: string read fRouterURL;               {·����URL}
property ExternalIp: string read fExternalIp;             {·��������IP}
property ControlURL: string read fControlURL;             {����ҳURL}
property ServiceType: string read fServiceType;           {�������ʹ�}
property URLBase: string read fURLBase;                   {����ַ}
//
// �¼�...
property OnTaskSuccess: TNotifyEvent read FOnTaskSuccess write FOnTaskSuccess;  {����ִ�гɹ����¼�}
property OnTaskFail: TNotifyEvent read FOnTaskFail write FOnTaskFail;           {����ִ��ʧ�ܵ��¼�}
//
end;

procedure Register;

implementation

//
// �ؼ�ע��Ĺ���...
procedure Register;
begin
RegisterComponents('AutoNAT', [TAutoNAT]);
end;

//
// ��������Ĺ���...
constructor TAutoNAT.Create(AOwner: TComponent);
begin
//
// ����TComponent�ķ���������...
inherited;
//
// �����ڲ�����...
UDP:=TNMUDP.Create(self);                   {UDP����}
udp.RemoteHost:='239.255.255.250';          {�㲥��ַ}
udp.RemotePort:=1900;                       {�㲥�˿�}
udp.LocalPort:=1900;

UDP.OnInvalidHost:=UDPInvalidHost;          {������Ч�¼�}
UDP.OnBufferInvalid:=UDPBufferInvalid;      {��������Ч�¼�}
UDP.OnStreamInvalid:=UDPStreamInvalid;      {����Ч�¼�}
UDP.OnDataReceived:=UDPDataReceived;        {�յ�Ӧ������ʱ���¼�}
//
sock:=TClientSocket.create(self);           {ClientSocket����}
sock.ClientType:=ctNonBlocking;             {��������}
sock.OnWrite:=clientsocketwrite;            {�ύ�����¼�}
sock.OnRead:=clientsocketread;              {Ӧ����Ӧ�¼�}
sock.OnError:=clientsocketerror;            {�쳣�¼�}
sock.OnDisconnect:=clientsocketdisconnect;  {�Ͽ��¼�}
//
TaskTimer:=TTimer.Create(self);             {��ʱ��ʱ��}
TaskTimer.Interval:=1000*5;                 {Ĭ��5�볬ʱ}
TaskTimer.enabled:=false;                   {�����ʱ��}
TaskTimer.OnTimer:=TaskTimerTimer;          {ָ����ʱ�����¼�}
//
taskexecuting:=false;                       {û��������ִ��}
taskfinished:=false;                        {δ���}
tasksuccess:=false;                         {δ�ɹ�}
//
fexternalip:='0.0.0.0';                     {����IP��ʱδ֪}
ftimeout:=5000;                             {Ĭ�ϳ�ʱֵ=5��}
end;

//
// ��������Ĺ���...
destructor TAutoNAT.Destroy;
begin
//
// �ͷŶ���...
UDP.free;
tasktimer.free;
sock.free;
//
// ����TComponent�ķ���������...
inherited;
end;

//
// ��������ʱֵ�Ĺ���...
procedure TAutoNAT.SetTimeout(Timeout: integer);
begin
if (timeout<1000) or (timeout>30*1000) then
begin
messagebox(0,'�Բ��𣬳�ʱֵ��Χ1000-30000���������룡','��ʾ',mb_ok+mb_iconinformation);
exit;
end;
ftimeout:=timeout;
end;

//
// ����һ���ɹ��¼��Ĺ���...
procedure TAutoNAT.SuccessEvent;
begin
tasktimer.enabled:=false;
//
// ���������Ѿ����...
taskexecuting:=false;           {������ִ����}
taskfinished:=true;             {�����Ѿ����}
tasksuccess:=true;              {����ɹ�}
//
// ����һ���ɹ��¼�...
if assigned(fontasksuccess) then
fontasksuccess(self);
end;

//
// ����һ��ʧ���¼��Ĺ���...
procedure TAutoNAT.FailEvent;
begin
tasktimer.enabled:=false;
//
// ���������Ѿ����...
taskexecuting:=false;           {������ִ����}
taskfinished:=true;             {�����Ѿ����}
tasksuccess:=false;             {����ʧ��}
//
// ����һ��ʧ���¼�...
if assigned(fontaskfail) then
fontaskfail(self);
end;

//
// UDP��������Ч�¼�...
procedure TAutoNAT.UDPInvalidHost(var handled: Boolean);
begin
failevent;                      {����ʧ���¼�}
handled:=true;
end;

//
// UDP�Ļ�������Ч�¼�...
procedure TAutoNAT.UDPBufferInvalid(var handled: Boolean; var Buff: array of Char; var length: Integer);
begin
failevent;                      {����ʧ���¼�}
handled:=true;
end;

//
// UDP������Ч�¼�...
procedure TAutoNAT.UDPStreamInvalid(var handled: Boolean; Stream: TStream);
begin
failevent;                      {����ʧ���¼�}
handled:=true;
end;

//
// ���ݵ����¼��������豸��Ӧ��...
procedure TAutoNAT.UDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port: Integer);
var
tmpstr: string;
buffer: array [0..4096] of char;
j: integer;
begin
//
// ��Ч���ݣ�����...
if (numberbytes<=0) or (numberbytes>4096) then
exit;
//
// ��ȡ����...
udp.ReadBuffer(buffer,numberbytes);
setlength(tmpstr,numberbytes);
strlcopy(pchar(tmpstr),buffer,numberbytes);
//
// ���������Ч���ݣ�����...
if uppercase(copy(tmpstr,1,5))<>'HTTP/' then
begin
//
// ����һ������ʧ���¼�...
if ftasktype=1 then
failevent;                      {����ʧ���¼�}
exit;
end;
//
// �õ�Location...
fRouterLocation:=tmpstr;
j:=pos('LOCATION:',uppercase(fRouterLocation));
if j<0 then
fRouterLocation:=''
else
begin
delete(fRouterLocation,1,j+8);
j:=pos(#13#10,fRouterLocation);
fRouterLocation:=trim(copy(fRouterLocation,1,j-1));
end;
//
// �õ�Server...
fRouterName:=tmpstr;
j:=pos('SERVER:',uppercase(fRouterName));
if j<0 then
fRouterName:=''
else
begin
delete(fRouterName,1,j+6);
j:=pos(#13#10,fRouterName);
fRouterName:=trim(copy(fRouterName,1,j-1));
end;
//
// �õ�USN...
fRouterUSN:=tmpstr;
j:=pos('USN:',uppercase(fRouterUSN));
if j<0 then
fRouterUSN:=''
else
begin
delete(fRouterUSN,1,j+3);
j:=pos(#13#10,fRouterUSN);
fRouterUSN:=trim(copy(fRouterUSN,1,j-1));
end;
//
// �õ�·����IP��ַ...
tmpstr:=fRouterLocation;
if copy(uppercase(tmpstr),1,7)='HTTP://' then
delete(tmpstr,1,7);
j:=pos(':',tmpstr);
if j<=0 then
begin
//
// ����һ������ʧ���¼�...
if ftasktype=1 then
failevent;                      {����ʧ���¼�}
exit;
end;
fRouterIp:=copy(tmpstr,1,j-1);
delete(tmpstr,1,j);
//
// �õ�·�����˿ڡ�����ҳURL��ַ...
j:=pos('/',tmpstr);
if j>1 then
begin
try
fRouterPort:=strtoint(copy(tmpstr,1,j-1));
except
fRouterPort:=-1;
end;
delete(tmpstr,1,j-1);
fRouterURL:=tmpstr;
end
else
begin
j:=pos(#13#10,tmpstr);
if j<=1 then
begin
//
// ����һ������ʧ���¼�...
if ftasktype=1 then
failevent;                      {����ʧ���¼�}
exit;
end;
try
fRouterPort:=strtoint(copy(tmpstr,1,j-1));
except
fRouterPort:=-1;
end;
fRouterURL:='/';
end;
//
// �õ�Ĭ�ϵ�URLBase...
tmpstr:='http://'+frouterip+':'+inttostr(frouterport)+frouterurl;
furlbase:='';
j:=pos('/',tmpstr);
while j>0 do
begin
furlbase:=furlbase+copy(tmpstr,1,j);
delete(tmpstr,1,j);
j:=pos('/',tmpstr);
end;
delete(furlbase,length(furlbase),1);
//
// ��������Ч...
if (trim(fRouterIp)='') or (fRouterPort<=0) then
begin
//
// ����һ������ʧ���¼�...
if ftasktype=1 then
failevent;                      {����ʧ���¼�}
end
//
// ���ɹ�...
else
begin
//
// ����һ������ɹ��¼�...
if ftasktype=1 then
successevent;               {�����ɹ��¼�}
end;
end;

//
// ��ʱʱ�䵽���¼�...
procedure TAutoNAT.TaskTimerTimer(Sender: TObject);
begin
failevent;
ftasktype:=-1;                  {���������}
end;

//
// �ж�Socket��Ӧ�������Ƿ�ȫ���õ��ĺ���...
function TAutoNAT.ResponseFinished(ResponseData: string): boolean;
var
head: string;
contentlength,j,headlength: integer;
begin
result:=false;
//
// �õ�ͷ��Ϣ...
j:=pos(#13#10#13#10,responsedata);
if j<=0 then
exit;
head:=copy(responsedata,1,j-1);
headlength:=j+3;
//
// �õ����ݳ���...
j:=pos('CONTENT-LENGTH:',uppercase(head));
if j<=0 then
begin
result:=true;
exit;
end;
delete(head,1,j+14);
j:=pos(#13#10,head);
try
contentlength:=strtoint(copy(head,1,j-1));
except
contentlength:=9999999;
end;
//
// �ж��Ƿ����...
if (length(responsedata)-headlength)>=contentlength then
result:=true;
end;

//
// �ύ��ѯ����...
procedure TAutoNAT.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin
//
// ���Ѿ��������󣬲��ٷ���...
if requested then
exit;
//
// ����ǰ����ֹͣ��ʱ��...
tasktimer.enabled:=false;
//
// ��������...
response:='';              {��û��Ӧ������}
socket.SendBuf(request[1],length(request));
requested:=true;           {�ѷ���}
end;

//
// �õ�SocketӦ������ʱ��ȡ����ҳ��Ϣ������NAT��ɾ��NAT���Լ�ȡ����IPʱ��Ӧ��...
procedure TAutoNAT.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
tmpstr: string;
j: integer;
begin
//
// �������ݣ��ŵ�Response������...
j:=socket.ReceiveLength;
setlength(tmpstr,j);
socket.ReceiveBuf(tmpstr[1],j);
response:=response+tmpstr;
//
// ��Ӧ������δȫ���õ����ȴ��¸����¼�...
if not responsefinished(response) then
exit;
//
// ���Ѿ�ȫ���õ������н������...
case ftasktype of
//
// ȡ����ҳ��ַʱ...
2: begin
tmpstr:=response;
//
// �õ�����ַ...
j:=pos(uppercase('<URLBASE>'),uppercase(tmpstr));
if j>0 then
begin
delete(tmpstr,1,j+length('<URLBASE>')-1);
j:=pos(uppercase('</URLBASE>'),uppercase(tmpstr));
if j>1 then
furlbase:=copy(tmpstr,1,j-1);
end;
//
// �����豸urn:schemas-upnp-org:device:InternetGatewayDevice:1��������...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:InternetGatewayDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:InternetGatewayDevice:1</deviceType>')-1);
//
// �ٲ���urn:schemas-upnp-org:device:WANDevice:1��������...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:WANDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:WANDevice:1</deviceType>')-1);
//
// �ٲ���urn:schemas-upnp-org:device:WANConnectionDevice:1��������...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:WANConnectionDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:WANConnectionDevice:1</deviceType>')-1);
//
// ����ҵ�����urn:schemas-upnp-org:service:WANIPConnection:1��urn:schemas-upnp-org:service:WANPPPConnection:1��������...
j:=pos(uppercase('<serviceType>urn:schemas-upnp-org:service:WANIPConnection:1</serviceType>'),uppercase(tmpstr));
if j<=0 then
begin
j:=pos(uppercase('<serviceType>urn:schemas-upnp-org:service:WANPPPConnection:1</serviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end
else
begin
delete(tmpstr,1,j+length('<serviceType>urn:schemas-upnp-org:service:WANPPPConnection:1</serviceType>')-1);
fservicetype:='urn:schemas-upnp-org:service:WANPPPConnection:1';
end;
end
else
begin
delete(tmpstr,1,j+length('<serviceType>urn:schemas-upnp-org:service:WANIPConnection:1</serviceType>')-1);
fservicetype:='urn:schemas-upnp-org:service:WANIPConnection:1';
end;
//
// �õ�ControlURL...
j:=pos(uppercase('<controlURL>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end;
delete(tmpstr,1,j+length('<controlURL>')-1);
j:=pos(uppercase('</controlURL>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {�ر��׽���}
exit;
end;
fcontrolurl:=copy(tmpstr,1,j-1);
//
if (copy(urlbase,length(urlbase),1)='/') and (copy(fcontrolurl,1,1)='/') then
delete(fcontrolurl,1,1);
if (copy(urlbase,length(urlbase),1)<>'/') and (copy(fcontrolurl,1,1)<>'/') then
fcontrolurl:='/'+fcontrolurl;
fcontrolurl:=urlbase+fcontrolurl;
//
// �����ɹ��¼�...
successevent;
end;
//
// ����NAT��ʱ...
3: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// ����ɹ�...
if pos('200 OK',tmpstr)>0 then
successevent
//
// ����ʧ��...
else
failevent;
end;
//
// ȡ������ַʱ...
4: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// ����ɹ�...
if pos('200 OK',tmpstr)>0 then
begin
//
// �õ�����IP...
j:=pos(uppercase('<NewExternalIPAddress>'),uppercase(response));
if j<=0 then
fexternalip:='0.0.0.0'
else
begin
fexternalip:=response;
delete(fexternalip,1,j+length('<NewExternalIPAddress>')-1);
j:=pos(uppercase('</NewExternalIPAddress>'),uppercase(fexternalip));
if j<=0 then
fexternalip:='0.0.0.0'
else
fexternalip:=copy(fexternalip,1,j-1);
end;
//
// �����ɹ��¼�...
successevent;
end
//
// ����ʧ��...
else
failevent;
end;
//
// ɾ��NAT��ʱ...
5: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// ����ɹ�...
if pos('200 OK',tmpstr)>0 then
successevent
//
// ����ʧ��...
else
failevent;
end;
end;
//
// �Ͽ�...
socket.Close;      {�ر��׽���}
end;

//
// ���ο��ܳ��ֵĴ���...
procedure TAutoNAT.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var i:integer;
begin
i:=ord(ErrorEvent);
if taskexecuting then
failevent;
errorcode:=0;
end;

//
// �Ͽ�ʱ...
procedure TAutoNAT.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
if taskexecuting then
failevent;
end;

//
// ����·�����豸������1��...
function TAutoNAT.SearchRouter(): boolean;
var
tmpstr: string;
buffer: array [0..4096] of char;
j: integer;
begin
//
// ���綨ʱ�����ڿ���״̬���쳣����...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// ����·������������...
tmpstr:='M-SEARCH * HTTP/1.1'#13#10
+'HOST: 239.255.255.250:1900'#13#10
+'MAN: "ssdp:discover"'#13#10
+'MX: 3'#13#10
+'ST: upnp:rootdevice'#13#10#13#10;
j:=length(tmpstr);
strplcopy(buffer,tmpstr,j);
//
// ���ø���־...
ftasktype:=1;                   {�豸��������}
taskexecuting:=true;            {������ִ��}
taskfinished:=false;            {����δ���}
tasksuccess:=false;             {����δ�ɹ�}
requested:=false;               {δ�ύ����}
//
// ������ʱ��ʱ��...
tasktimer.interval:=ftimeout;   {��ʱֵ}
tasktimer.enabled:=true;
//
// ������������·����...
udp.SendBuffer(buffer,j);       {�����豸�������ݰ�}
//
// ���سɹ�...
result:=true;
end;

//
// �õ�·��������ҳ{����2}...
function TAutoNAT.GetControlURL(): boolean;
begin
//
// ������������ִ�У�����ʧ��...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// ��������...
request:='GET '+frouterurl+' HTTP/1.1'#13#10
+'Host: '+frouterip+':'+inttostr(frouterport)+#13#10#13#10;
//
// ���ø���־...
ftasktype:=2;                   {�豸��������}
taskexecuting:=true;            {������ִ��}
taskfinished:=false;            {����δ���}
tasksuccess:=false;             {����δ�ɹ�}
requested:=false;               {δ�ύ����}
//
// ������ʱ��ʱ��...
tasktimer.interval:=ftimeout;   {��ʱֵ}
tasktimer.enabled:=true;
//
// ����·����...
sock.host:=frouterip;           {·����IP��ַ}
sock.port:=frouterport;         {·�����˿ں�}
sock.active:=true;              {����·����}
//
// ���سɹ�...
result:=true;
end;

//
// ���Ӷ˿�ӳ�������3��...
function TAutoNAT.AddNatMapping(NatPortName: string; ExternalPort: integer; LocalIp: string; LocalPort: integer; Protocol: string): boolean;
var
url,body: string;
j: integer;
begin
//
// ������������ִ�У�����ʧ��...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// ��������...
body:='<?xml version="1.0"?>'#13#10
+'<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"'#13#10
+'s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'#13#10
+'<s:Body>'#13#10
+'<u:AddPortMapping xmlns:u="'+fservicetype+'">'#13#10
+'<NewRemoteHost></NewRemoteHost>'#13#10
+'<NewExternalPort>'+inttostr(externalport)+'</NewExternalPort>'#13#10
+'<NewProtocol>'+protocol+'</NewProtocol>'#13#10
+'<NewInternalPort>'+inttostr(localport)+'</NewInternalPort>'#13#10
+'<NewInternalClient>'+localip+'</NewInternalClient>'#13#10
+'<NewEnabled>1</NewEnabled>'#13#10
+'<NewPortMappingDescription> </NewPortMappingDescription>'#13#10
+'<NewLeaseDuration>0</NewLeaseDuration>'#13#10
+'</u:AddPortMapping>'#13#10
+'</s:Body>'#13#10
+'</s:Envelope>'#13#10;
//
url:=fcontrolurl;
delete(url,1,7);
j:=pos('/',url);
delete(url,1,j-1);
//
request:='POST '+url+' HTTP/1.1'#13#10
+'Host: '+frouterip+':'+inttostr(routerport)+#13#10
+'SoapAction: "'+fservicetype+'#AddPortMapping"'#13#10
+'Content-Type: text/xml; charset="utf-8"'#13#10
+'Content-Length: '+inttostr(length(body))+#13#10#13#10+body;
//
// ���ø���־...
ftasktype:=3;                   {�豸��������}
taskexecuting:=true;            {������ִ��}
taskfinished:=false;            {����δ���}
tasksuccess:=false;             {����δ�ɹ�}
requested:=false;               {δ�ύ����}
//
// ������ʱ��ʱ��...
tasktimer.interval:=ftimeout;   {��ʱֵ}
tasktimer.enabled:=true;
//
// ����·����...
sock.host:=frouterip;           {·����IP}
sock.port:=frouterport;         {�˿�}
sock.active:=true;
//
// ���سɹ�...
result:=true;
end;

//
// ȡ����IP��ַ������4��...
function TAutoNAT.GetExternalIp(): boolean;
var
url,body: string;
j: integer;
begin
//
// ������������ִ�У�����ʧ��...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// ��������...
body:='<?xml version="1.0"?>'#13#10
+'<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'#13#10
+'<s:Body>'#13#10
+'<u:GetExternalIPAddress xmlns:u="'+fservicetype+'">'#13#10
+'</u:GetExternalIPAddress>'#13#10
+'</s:Body>'#13#10
+'</s:Envelope>'#13#10;
//
url:=fcontrolurl;
delete(url,1,7);
j:=pos('/',url);
delete(url,1,j-1);
//
request:='POST '+url+' HTTP/1.0'#13#10
+'Host: '+frouterip+':'+inttostr(frouterport)+#13#10
+'SoapAction: "'+fservicetype+'#GetExternalIPAddress"'#13#10
+'Content-Type: text/xml; charset="utf-8"'#13#10
+'Content-Length: '+inttostr(length(body))+#13#10#13#10+body;
//
// ���ø���־...
ftasktype:=4;                   {�豸��������}
taskexecuting:=true;            {������ִ��}
taskfinished:=false;            {����δ���}
tasksuccess:=false;             {����δ�ɹ�}
requested:=false;               {δ�ύ����}
//
// ������ʱ��ʱ��...
tasktimer.interval:=ftimeout;   {��ʱֵ}
tasktimer.enabled:=true;
//
// ����·����...
sock.host:=frouterip;
sock.port:=frouterport;
sock.active:=true;
//
// ���سɹ�...
result:=true;
end;

//
// ɾ���˿�ӳ�������5��...
function TAutoNAT.DeleteNatMapping(ExternalPort: integer; Protocol: string): boolean;
var
url,body: string;
j: integer;
begin
//
// ������������ִ�У�����ʧ��...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// ��������...
body:='<?xml version="1.0"?>'#13#10
+'<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'#13#10
+'<s:Body>'#13#10
+'<u:DeletePortMapping xmlns:u="'+fservicetype+'">'#13#10
+'<NewRemoteHost></NewRemoteHost>'#13#10
+'<NewExternalPort>'+inttostr(externalport)+'</NewExternalPort>'#13#10
+'<NewProtocol>'+protocol+'</NewProtocol>'#13#10
+'</u:DeletePortMapping>'#13#10
+'</s:Body>'#13#10
+'</s:Envelope>'#13#10;
//
url:=fcontrolurl;
delete(url,1,7);
j:=pos('/',url);
delete(url,1,j-1);
//
request:='POST '+url+' HTTP/1.0'#13#10
+'Host: '+routerip+':'+inttostr(routerport)+#13#10
+'SoapAction: "'+fservicetype+'#DeletePortMapping"'#13#10
+'Content-Type: text/xml; charset="utf-8"'#13#10
+'Content-Length: '+inttostr(length(body))+#13#10#13#10+body;
//
// ���ø���־...
ftasktype:=5;                   {�豸��������}
taskexecuting:=true;            {������ִ��}
taskfinished:=false;            {����δ���}
tasksuccess:=false;             {����δ�ɹ�}
requested:=false;               {δ�ύ����}
//
// ������ʱ��ʱ��...
tasktimer.interval:=ftimeout;    {��ʱֵ}
tasktimer.enabled:=true;
//
// ����·����...
sock.host:=frouterip;
sock.port:=frouterport;
sock.active:=true;
//
// ���سɹ�...
result:=true;
end;

end.

