//
// -----------------------------------------------------------------------------------------------
//
//   TAutoNAT -- 自动设置路由器端口映射项控件 For delphi 4,5,6,7,2005
//
//             作者： 王国忠     编写日期：2007年10月
//
//             电子邮件：support@quickburro.com   联系电话：0571-69979828
//
// -----------------------------------------------------------------------------------------------
//
unit autoNat;

interface

uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Scktcomp, NMUDP, extctrls;

//
// 定义事件类...
type
TTaskSuccessEvent = procedure (Sender: TObject) of object;              {任务执行成功事件}
TTaskFailEvent = procedure (Sender: TObject) of object;                 {任务执行失败事件}

type
TAutoNAT = class(TComponent)
private
//
// 只读属性...
fTimeout: integer;           {任务超时值}
fTaskType: integer;          {任务列别: 1-搜索 2-取控制页地址 3-增加端口 4-取外网地址 5-删除端口}
fLocalIp: string;            {本机内网IP}
fRouterIp: string;           {路由器内网IP}
fRouterPort: integer;        {路由器控制端口}
fRouterLocation: string;     {路由器设备位置URL}
fRouterName: string;         {路由器设备名称}
fRouterUSN: string;          {路由器设备标识名}
fRouterURL: string;          {路由器URL}
fExternalIp: string;         {路由器外网IP}
fControlURL: string;         {控制页URL}
fServiceType: string;        {服务类型串}
fURLbase: string;            {控制页基地址}
//
// 事件...
FOnTaskSuccess: TNotifyEvent;    {任务执行成功的事件}
FOnTaskFail: TNotifyEvent;       {任务执行失败的事件}
//
// 普通变量...
request: string;              {socket请求数据包}
requested: boolean;           {请求是否已发送}
response: string;             {socket应答数据包}
//
UDP: TNMUDP;                           {UDP对象}
Sock: TClientSocket;                   {Socket对象}
TaskTimer: TTimer;                     {任务定时器}
//
TaskExecuting: boolean;                {当前是否有任务在执行}
Taskfinished: boolean;                 {任务是否已经完成}
Tasksuccess: boolean;                  {任务是否成功}
//
// 其它私有过程...
procedure SetTimeout(Timeout: integer);
procedure SuccessEvent;
procedure FailEvent;
procedure TaskTimerTimer(Sender: TObject);        {超时事件}
procedure UDPInvalidHost(var handled: Boolean);   {主机无效时的事件}
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
// 创建对象...
Constructor Create(AOwner: TComponent); override;           {对象创建时的方法}
//
// 撤消对象...
Destructor Destroy(); override;                             {对象撤消的方法}
//
// 搜索路由器设备（任务1）...
function SearchRouter(): boolean;
//
// 得到路由器控制页{任务2}...
function GetControlURL(): boolean;
//
// 增加端口映射项（任务3）...
function AddNatMapping(NatPortName: string; ExternalPort: integer; LocalIp: string; LocalPort: integer; Protocol: string): boolean;
//
// 取外网IP地址（任务4）...
function GetExternalIp: boolean;
//
// 删除端口映射项（任务5）...
function DeleteNatMapping(ExternalPort: integer; Protocol: string): boolean;
//
published
//
// 控件属性...
property Timeout: integer read fTimeout write settimeout; {任务超时值}
property TaskType: integer read fTaskType;                {任务列别: 1-搜索 2-取控制页地址 3-增加端口 4-取外网地址 5-删除端口}
property LocalIp: string read fLocalIp;                   {本机内网IP}
property RouterIp: string read fRouterIp;                 {路由器内网IP}
property RouterPort: integer read fRouterPort;            {路由器控制端口}
property RouterLocation: string read fRouterLocation;     {路由器设备位置URL}
property RouterName: string read fRouterName;             {路由器设备名称}
property RouterUSN: string read fRouterUSN;               {路由器设备标识名}
property RouterURL: string read fRouterURL;               {路由器URL}
property ExternalIp: string read fExternalIp;             {路由器外网IP}
property ControlURL: string read fControlURL;             {控制页URL}
property ServiceType: string read fServiceType;           {服务类型串}
property URLBase: string read fURLBase;                   {基地址}
//
// 事件...
property OnTaskSuccess: TNotifyEvent read FOnTaskSuccess write FOnTaskSuccess;  {任务执行成功的事件}
property OnTaskFail: TNotifyEvent read FOnTaskFail write FOnTaskFail;           {任务执行失败的事件}
//
end;

procedure Register;

implementation

//
// 控件注册的过程...
procedure Register;
begin
RegisterComponents('AutoNAT', [TAutoNAT]);
end;

//
// 创建对象的过程...
constructor TAutoNAT.Create(AOwner: TComponent);
begin
//
// 调用TComponent的方法，创建...
inherited;
//
// 创建内部变量...
UDP:=TNMUDP.Create(self);                   {UDP对象}
udp.RemoteHost:='239.255.255.250';          {广播地址}
udp.RemotePort:=1900;                       {广播端口}
udp.LocalPort:=1900;

UDP.OnInvalidHost:=UDPInvalidHost;          {主机无效事件}
UDP.OnBufferInvalid:=UDPBufferInvalid;      {缓冲区无效事件}
UDP.OnStreamInvalid:=UDPStreamInvalid;      {流无效事件}
UDP.OnDataReceived:=UDPDataReceived;        {收到应答数据时的事件}
//
sock:=TClientSocket.create(self);           {ClientSocket对象}
sock.ClientType:=ctNonBlocking;             {非阻塞型}
sock.OnWrite:=clientsocketwrite;            {提交请求事件}
sock.OnRead:=clientsocketread;              {应答响应事件}
sock.OnError:=clientsocketerror;            {异常事件}
sock.OnDisconnect:=clientsocketdisconnect;  {断开事件}
//
TaskTimer:=TTimer.Create(self);             {超时定时器}
TaskTimer.Interval:=1000*5;                 {默认5秒超时}
TaskTimer.enabled:=false;                   {不激活定时器}
TaskTimer.OnTimer:=TaskTimerTimer;          {指定超时处理事件}
//
taskexecuting:=false;                       {没有任务在执行}
taskfinished:=false;                        {未完成}
tasksuccess:=false;                         {未成功}
//
fexternalip:='0.0.0.0';                     {外网IP暂时未知}
ftimeout:=5000;                             {默认超时值=5秒}
end;

//
// 撤消对象的过程...
destructor TAutoNAT.Destroy;
begin
//
// 释放对象...
UDP.free;
tasktimer.free;
sock.free;
//
// 调用TComponent的方法，撤消...
inherited;
end;

//
// 设置任务超时值的过程...
procedure TAutoNAT.SetTimeout(Timeout: integer);
begin
if (timeout<1000) or (timeout>30*1000) then
begin
messagebox(0,'对不起，超时值范围1000-30000，重新输入！','提示',mb_ok+mb_iconinformation);
exit;
end;
ftimeout:=timeout;
end;

//
// 激发一个成功事件的过程...
procedure TAutoNAT.SuccessEvent;
begin
tasktimer.enabled:=false;
//
// 设置任务已经完成...
taskexecuting:=false;           {任务不在执行了}
taskfinished:=true;             {任务已经完成}
tasksuccess:=true;              {任务成功}
//
// 激发一个成功事件...
if assigned(fontasksuccess) then
fontasksuccess(self);
end;

//
// 激发一个失败事件的过程...
procedure TAutoNAT.FailEvent;
begin
tasktimer.enabled:=false;
//
// 设置任务已经完成...
taskexecuting:=false;           {任务不在执行了}
taskfinished:=true;             {任务已经完成}
tasksuccess:=false;             {任务失败}
//
// 激发一个失败事件...
if assigned(fontaskfail) then
fontaskfail(self);
end;

//
// UDP的主机无效事件...
procedure TAutoNAT.UDPInvalidHost(var handled: Boolean);
begin
failevent;                      {激发失败事件}
handled:=true;
end;

//
// UDP的缓冲区无效事件...
procedure TAutoNAT.UDPBufferInvalid(var handled: Boolean; var Buff: array of Char; var length: Integer);
begin
failevent;                      {激发失败事件}
handled:=true;
end;

//
// UDP的流无效事件...
procedure TAutoNAT.UDPStreamInvalid(var handled: Boolean; Stream: TStream);
begin
failevent;                      {激发失败事件}
handled:=true;
end;

//
// 数据到达事件（搜索设备的应答）...
procedure TAutoNAT.UDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port: Integer);
var
tmpstr: string;
buffer: array [0..4096] of char;
j: integer;
begin
//
// 无效数据，丢弃...
if (numberbytes<=0) or (numberbytes>4096) then
exit;
//
// 读取数据...
udp.ReadBuffer(buffer,numberbytes);
setlength(tmpstr,numberbytes);
strlcopy(pchar(tmpstr),buffer,numberbytes);
//
// 如果不是有效数据，丢弃...
if uppercase(copy(tmpstr,1,5))<>'HTTP/' then
begin
//
// 激发一个任务失败事件...
if ftasktype=1 then
failevent;                      {激发失败事件}
exit;
end;
//
// 得到Location...
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
// 得到Server...
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
// 得到USN...
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
// 得到路由器IP地址...
tmpstr:=fRouterLocation;
if copy(uppercase(tmpstr),1,7)='HTTP://' then
delete(tmpstr,1,7);
j:=pos(':',tmpstr);
if j<=0 then
begin
//
// 激发一个任务失败事件...
if ftasktype=1 then
failevent;                      {激发失败事件}
exit;
end;
fRouterIp:=copy(tmpstr,1,j-1);
delete(tmpstr,1,j);
//
// 得到路由器端口、控制页URL地址...
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
// 激发一个任务失败事件...
if ftasktype=1 then
failevent;                      {激发失败事件}
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
// 得到默认的URLBase...
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
// 若数据无效...
if (trim(fRouterIp)='') or (fRouterPort<=0) then
begin
//
// 激发一个任务失败事件...
if ftasktype=1 then
failevent;                      {激发失败事件}
end
//
// 若成功...
else
begin
//
// 激发一个任务成功事件...
if ftasktype=1 then
successevent;               {激发成功事件}
end;
end;

//
// 超时时间到的事件...
procedure TAutoNAT.TaskTimerTimer(Sender: TObject);
begin
failevent;
ftasktype:=-1;                  {撤消任务号}
end;

//
// 判定Socket的应答数据是否全部得到的函数...
function TAutoNAT.ResponseFinished(ResponseData: string): boolean;
var
head: string;
contentlength,j,headlength: integer;
begin
result:=false;
//
// 得到头信息...
j:=pos(#13#10#13#10,responsedata);
if j<=0 then
exit;
head:=copy(responsedata,1,j-1);
headlength:=j+3;
//
// 得到内容长度...
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
// 判定是否结束...
if (length(responsedata)-headlength)>=contentlength then
result:=true;
end;

//
// 提交查询请求...
procedure TAutoNAT.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin
//
// 若已经发送请求，不再发送...
if requested then
exit;
//
// 发送前，先停止定时器...
tasktimer.enabled:=false;
//
// 发出请求...
response:='';              {还没有应答数据}
socket.SendBuf(request[1],length(request));
requested:=true;           {已发送}
end;

//
// 得到Socket应答数据时（取控制页信息、增加NAT、删除NAT，以及取外网IP时的应答）...
procedure TAutoNAT.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
tmpstr: string;
j: integer;
begin
//
// 接收数据，放到Response变量中...
j:=socket.ReceiveLength;
setlength(tmpstr,j);
socket.ReceiveBuf(tmpstr[1],j);
response:=response+tmpstr;
//
// 若应答数据未全部得到，等待下个读事件...
if not responsefinished(response) then
exit;
//
// 若已经全部得到，进行结果解析...
case ftasktype of
//
// 取控制页地址时...
2: begin
tmpstr:=response;
//
// 得到基地址...
j:=pos(uppercase('<URLBASE>'),uppercase(tmpstr));
if j>0 then
begin
delete(tmpstr,1,j+length('<URLBASE>')-1);
j:=pos(uppercase('</URLBASE>'),uppercase(tmpstr));
if j>1 then
furlbase:=copy(tmpstr,1,j-1);
end;
//
// 查找设备urn:schemas-upnp-org:device:InternetGatewayDevice:1的描述段...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:InternetGatewayDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:InternetGatewayDevice:1</deviceType>')-1);
//
// 再查找urn:schemas-upnp-org:device:WANDevice:1的描述段...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:WANDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:WANDevice:1</deviceType>')-1);
//
// 再查找urn:schemas-upnp-org:device:WANConnectionDevice:1的描述段...
j:=pos(uppercase('<deviceType>urn:schemas-upnp-org:device:WANConnectionDevice:1</deviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
exit;
end;
delete(tmpstr,1,j+length('<deviceType>urn:schemas-upnp-org:device:WANConnectionDevice:1</deviceType>')-1);
//
// 最后找到服务urn:schemas-upnp-org:service:WANIPConnection:1或urn:schemas-upnp-org:service:WANPPPConnection:1的描述段...
j:=pos(uppercase('<serviceType>urn:schemas-upnp-org:service:WANIPConnection:1</serviceType>'),uppercase(tmpstr));
if j<=0 then
begin
j:=pos(uppercase('<serviceType>urn:schemas-upnp-org:service:WANPPPConnection:1</serviceType>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
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
// 得到ControlURL...
j:=pos(uppercase('<controlURL>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
exit;
end;
delete(tmpstr,1,j+length('<controlURL>')-1);
j:=pos(uppercase('</controlURL>'),uppercase(tmpstr));
if j<=0 then
begin
failevent;
socket.Close;      {关闭套接字}
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
// 激发成功事件...
successevent;
end;
//
// 增加NAT项时...
3: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// 假如成功...
if pos('200 OK',tmpstr)>0 then
successevent
//
// 假如失败...
else
failevent;
end;
//
// 取外网地址时...
4: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// 假如成功...
if pos('200 OK',tmpstr)>0 then
begin
//
// 得到外网IP...
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
// 激发成功事件...
successevent;
end
//
// 假如失败...
else
failevent;
end;
//
// 删除NAT项时...
5: begin
tmpstr:=response;
j:=pos(#13#10,tmpstr);
tmpstr:=uppercase(copy(tmpstr,1,j-1));
//
// 假如成功...
if pos('200 OK',tmpstr)>0 then
successevent
//
// 假如失败...
else
failevent;
end;
end;
//
// 断开...
socket.Close;      {关闭套接字}
end;

//
// 屏蔽可能出现的错误...
procedure TAutoNAT.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var i:integer;
begin
i:=ord(ErrorEvent);
if taskexecuting then
failevent;
errorcode:=0;
end;

//
// 断开时...
procedure TAutoNAT.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
if taskexecuting then
failevent;
end;

//
// 搜索路由器设备（任务1）...
function TAutoNAT.SearchRouter(): boolean;
var
tmpstr: string;
buffer: array [0..4096] of char;
j: integer;
begin
//
// 假如定时器处于开启状态，异常返回...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// 生成路由器搜索请求...
tmpstr:='M-SEARCH * HTTP/1.1'#13#10
+'HOST: 239.255.255.250:1900'#13#10
+'MAN: "ssdp:discover"'#13#10
+'MX: 3'#13#10
+'ST: upnp:rootdevice'#13#10#13#10;
j:=length(tmpstr);
strplcopy(buffer,tmpstr,j);
//
// 设置各标志...
ftasktype:=1;                   {设备搜索任务}
taskexecuting:=true;            {任务在执行}
taskfinished:=false;            {任务未完成}
tasksuccess:=false;             {任务未成功}
requested:=false;               {未提交请求}
//
// 启动延时定时器...
tasktimer.interval:=ftimeout;   {超时值}
tasktimer.enabled:=true;
//
// 发送请求，搜索路由器...
udp.SendBuffer(buffer,j);       {发送设备搜索数据包}
//
// 返回成功...
result:=true;
end;

//
// 得到路由器控制页{任务2}...
function TAutoNAT.GetControlURL(): boolean;
begin
//
// 假如有任务在执行，返回失败...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// 生成请求串...
request:='GET '+frouterurl+' HTTP/1.1'#13#10
+'Host: '+frouterip+':'+inttostr(frouterport)+#13#10#13#10;
//
// 设置各标志...
ftasktype:=2;                   {设备搜索任务}
taskexecuting:=true;            {任务在执行}
taskfinished:=false;            {任务未完成}
tasksuccess:=false;             {任务未成功}
requested:=false;               {未提交请求}
//
// 启动延时定时器...
tasktimer.interval:=ftimeout;   {超时值}
tasktimer.enabled:=true;
//
// 连接路由器...
sock.host:=frouterip;           {路由器IP地址}
sock.port:=frouterport;         {路由器端口号}
sock.active:=true;              {连接路由器}
//
// 返回成功...
result:=true;
end;

//
// 增加端口映射项（任务3）...
function TAutoNAT.AddNatMapping(NatPortName: string; ExternalPort: integer; LocalIp: string; LocalPort: integer; Protocol: string): boolean;
var
url,body: string;
j: integer;
begin
//
// 假如有任务在执行，返回失败...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// 生成请求串...
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
// 设置各标志...
ftasktype:=3;                   {设备搜索任务}
taskexecuting:=true;            {任务在执行}
taskfinished:=false;            {任务未完成}
tasksuccess:=false;             {任务未成功}
requested:=false;               {未提交请求}
//
// 启动延时定时器...
tasktimer.interval:=ftimeout;   {超时值}
tasktimer.enabled:=true;
//
// 连接路由器...
sock.host:=frouterip;           {路由器IP}
sock.port:=frouterport;         {端口}
sock.active:=true;
//
// 返回成功...
result:=true;
end;

//
// 取外网IP地址（任务4）...
function TAutoNAT.GetExternalIp(): boolean;
var
url,body: string;
j: integer;
begin
//
// 假如有任务在执行，返回失败...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// 生成请求串...
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
// 设置各标志...
ftasktype:=4;                   {设备搜索任务}
taskexecuting:=true;            {任务在执行}
taskfinished:=false;            {任务未完成}
tasksuccess:=false;             {任务未成功}
requested:=false;               {未提交请求}
//
// 启动延时定时器...
tasktimer.interval:=ftimeout;   {超时值}
tasktimer.enabled:=true;
//
// 连接路由器...
sock.host:=frouterip;
sock.port:=frouterport;
sock.active:=true;
//
// 返回成功...
result:=true;
end;

//
// 删除端口映射项（任务5）...
function TAutoNAT.DeleteNatMapping(ExternalPort: integer; Protocol: string): boolean;
var
url,body: string;
j: integer;
begin
//
// 假如有任务在执行，返回失败...
if tasktimer.enabled then
begin
result:=false;
exit;
end;
//
// 生成请求串...
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
// 设置各标志...
ftasktype:=5;                   {设备搜索任务}
taskexecuting:=true;            {任务在执行}
taskfinished:=false;            {任务未完成}
tasksuccess:=false;             {任务未成功}
requested:=false;               {未提交请求}
//
// 启动延时定时器...
tasktimer.interval:=ftimeout;    {超时值}
tasktimer.enabled:=true;
//
// 连接路由器...
sock.host:=frouterip;
sock.port:=frouterport;
sock.active:=true;
//
// 返回成功...
result:=true;
end;

end.

