unit Cvn_AutomaicServer;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, convnet_TLB, StdVcl, clientUI;

type
  TconvnetClient = class(TAutoObject, IconvnetClient)
  protected
    procedure Login(const ServerIP, Username, Password: WideString); safecall;
    procedure GetUserStat(userid: Integer); safecall;
    procedure GetUserStatus(const userid: WideString); safecall;
    function GetUserCount: SYSINT; stdcall;
    function GetUserIDByName: SYSINT; stdcall;
    function GetUserNameByID: WideString; stdcall;
    function Getusers: OleVariant; stdcall;
    procedure Close; safecall;
    procedure Connected; safecall;
    procedure ConnectUserByID; safecall;
    procedure GetUserByIndex; safecall;
    procedure GetUserStatusByID(const userid: WideString); safecall;
    procedure JoinGroup(GroupId: Integer; const OrderStrring: WideString); safecall;
    procedure Logout; safecall;
    procedure Method1; safecall;

  end;

implementation

uses ComServ;

procedure TconvnetClient.Login(const ServerIP, Username, Password: WideString);
begin
   clientUI.fclientui.eServerIP.Text:=ServerIP;
   clientUI.fclientui.ePassword.Text:=Password;
   clientUI.fclientui.eUserName.Text:=username;
   clientUI.fclientui.bLogin.Click;
end;

procedure TconvnetClient.GetUserStat(userid: Integer);
begin

end;

procedure TconvnetClient.GetUserStatus(const userid: WideString);
begin

end;

function TconvnetClient.GetUserCount: SYSINT;
begin

end;

function TconvnetClient.GetUserIDByName: SYSINT;
begin

end;

function TconvnetClient.GetUserNameByID: WideString;
begin

end;

function TconvnetClient.Getusers: OleVariant;
begin

end;

procedure TconvnetClient.Close;
begin

end;

procedure TconvnetClient.Connected;
begin

end;

procedure TconvnetClient.ConnectUserByID;
begin

end;

procedure TconvnetClient.GetUserByIndex;
begin

end;

procedure TconvnetClient.GetUserStatusByID(const userid: WideString);
begin

end;

procedure TconvnetClient.JoinGroup(GroupId: Integer; const OrderStrring: WideString);
begin

end;

procedure TconvnetClient.Logout;
begin

end;

procedure TconvnetClient.Method1;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TconvnetClient, Class_convnetClient,
    ciMultiInstance, tmApartment);
end.
