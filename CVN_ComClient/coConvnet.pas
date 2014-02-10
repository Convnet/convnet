unit coConvnet;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, convnet_TLB, StdVcl, CVN_CSYS, SysUtils,
  CVN_Protocol;

type
  TcoConvnet = class(TAutoObject, IConnectionPointContainer, IcoConvnet)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IcoConvnetEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    procedure Initialize; override;
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure ConnectToServer(const ServerUrl,  UserName, PassWord: WideString);
      safecall;
    procedure ApplyForJoinGroup(groupid: SYSINT; const applyinfo: WideString);
      safecall;
    procedure RegistUser(const serverurl, username, password, nick, desc,
      email: WideString); safecall;
    procedure ShowForm; safecall;
    procedure HiddenForm; safecall;
  end;

implementation

uses ComServ, clientUI;

procedure TcoConvnet.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IcoConvnetEvents;
  //°ó¶¨µ½´°Ìå
  fclientui.comEvents:=FEvents;
end;

procedure TcoConvnet.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;


procedure TcoConvnet.ConnectToServer(const ServerUrl, UserName, PassWord: WideString);
begin
  fclientui.eServerIP.Text:=string(ServerUrl);
  fclientui.eUserName.Text:=string(UserName);
  fclientui.ePassword.Text:=string(PassWord);
  fclientui.bLogin.Click;
end;

procedure TcoConvnet.ApplyForJoinGroup(groupid: SYSINT;
  const applyinfo: WideString);
begin
  CVN_SendCmdto(ProtocolToStr(cmdJoinGroup)+','+ inttostr(groupid) +','
              + formatUnAllowStr(applyinfo,40)+'*');
end;

procedure TcoConvnet.RegistUser(const serverurl, username, password, nick,
  desc, email: WideString);
  var i:integer;
begin

  CVN_ConnecttoServer(pchar(serverurl));
  i:=0;
  while not CVN_ServerIsConnected do
  begin
    inc(i);
    sleep(1);
    if i>64000 then
      break;
  end;

  if i<64000 then
    CVN_SendCmdto(ProtocolToStr(cmdRegistUser)+','+username+','+password+','+nick+',¡¡'+desc+','+email+'*')
end;

procedure TcoConvnet.ShowForm;
begin
  fclientui.Show;
end;

procedure TcoConvnet.HiddenForm;
begin
  fclientui.CoolTrayIcon1.HideMainForm;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TcoConvnet, Class_coConvnet,
    ciMultiInstance, tmApartment);
  
end.
