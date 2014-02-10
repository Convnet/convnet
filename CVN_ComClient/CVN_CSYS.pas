unit CVN_CSYS;

interface
uses  VirtualTrees,Windows,Classes,IpTypes,WinSock2 ,
      SyncObjs, Contnrs, Dialogs, activex, forms,
      StdCtrls, Menus, RzButton, RzBmpBtn;
type TWinVersion = (wvUnknown, wvWin95, wvWin98, wvWin98SE, wvWinNT, wvWinME, wvWin2000, wvWinXP, wvWinVista) ;

    Puserinfo =^TUserInfo;

    TUserInfo = class (TObject)
      connecting:boolean;
      UserID:integer;
      UserName,
      AhthorPassword:string[12];
      ISOnline:boolean;
      Connected:boolean;
      SenderrorCount:integer;
      MacAddress:string[12];

      Con_ConnectionType:integer;
      Con_IP:string[15];
      Con_port:integer;
      MyPeerPort:integer;
      Con_RetryTime:integer;
      Con_send:int64;
      Con_recv:int64;
      tvUserReconn:integer;
      con_AContext:pointer;
      clientDM:pointer;

      procedure TryConnect_start; virtual; abstract;    //尝试连接
      procedure TryTransfConnect_start; virtual; abstract;//尝试服务器转发
      procedure RefInfo_whenConnect(ip:string;port:integer;Mac:string); virtual;abstract;
      procedure DissconnectPeer; virtual; abstract;
      procedure SendtoPeer(buffer:pchar; buflength:integer);virtual;abstract;//overload;
      procedure RetryTimer(Sender: TObject); virtual;abstract;
    end;

    tConnectionMode=(
              NULL,
              TCPServer,
              TcpClient,
              mUDPServer,
              mUDPClient,
              ServerTrans
              );

    pPeerGroupInfo = ^TPeerGroupInfo;
    TPeerGroupInfo = class(Tlist)
      GroupID:integer;
      Creator:integer;
      GroupName:string[12];
      GroupDes:string[30];
      NeedPass:boolean;
    end;
   const LOGIN_DELAY_TIME_SEC=7;

var ServerIP:string;
  serverhost:string;
  UserName:string;
  password:String;
  g_MyMac:string;
  
  g_MyPublicIP:string;                                  //我的公网IP
  g_Userid:integer;                                     //我的ID
  g_userName:string[40];                                //用户名
  g_NickName:string[40];                                //我的昵称
  g_common:string[40];                                  //我的备注
  g_AllowPass1:string[40];                              //允许访问的密码1
  g_AllowPass2:string[40];                              //允许访问的密码2
  g_AllowPass3:string[40];                              //允许访问的密码3
  g_AllowPass4:string[40];                              //允许访问的密码4

  g_ComMessage:widestring;
  g_ComMessageType:integer;

  g_peerRetry:integer;//客户端心跳保持包
  
  g_Logintoservertime:integer;

  //g_rechecknattype_count:integer;                       //重新检查计数
  rmoutecommandallowuserlist:tstringlist;
 


  g_MyPass:string[12];                                  //我的密码
  g_quitCause:string;
  g_UDPserverPortA:integer;
  g_UDPserverPortB:integer;

  g_UserStruct:TList;
  g_AllUserInfo:TPeerGroupInfo;
  g_ChatFormsList:TList;
  
  g_HasUpnpTCPServer:boolean;
  g_HasUpnpUDPServer:boolean;

  my_upnptcpport:integer;
  my_upnpudpport:integer;


  g_recv:int64;
  g_send:int64;
  g_myIPlists:string;

  g_MyNatType:string;
  g_ServerIP:string;

  g_currentNode:PVirtualNode;                           //鼠标当前所在的节点
  g_currentNodeColumn:integer;                          //鼠标当前所在的列
  //message_str:string;               //ID+','+发送的消息\
  g_defaultgeteway:string;


  g_MYEtherString:string;

  g_operationingUser:Puserinfo;                          //正在操作的用户对象

  globalport_TCP:integer;
  globalport_UDP:integer;

  g_ResStrlist:Tstringlist;   
  
  function GetCVNIPByUserID(Userid:Integer):string;
  function CatStringAfterStar(str:string):string;
  function IpAddressToString(Addr: DWORD): string;
  function getDefaultGateWay: string;
  
  function ConvertDataToHex(Buffer: pointer; Length: Word): string;
  function formatInttoViewtext(int:int64):string;

  function CVN_GetUserinfo:pchar;StdCall; external 'cvn_main.dll';
  procedure CVN_SendCmd(str:pchar);StdCall; external 'cvn_main.dll';
  procedure CVN_ConnectUser(Userid:integer;password:pchar);stdcall;external 'cvn_main.dll';
  procedure CVN_Login(cvnurl,username,password:pchar);stdcall;external 'cvn_main.dll';
  procedure CVN_Logout;stdcall;external 'cvn_main.dll';
  procedure CVN_closefirewall;stdcall;external 'cvn_main.dll';

  procedure CVN_testdissconnect;stdcall;external 'cvn_main.dll';
  procedure CVN_DisConnectUser(Userid:integer);stdcall;  external 'cvn_main.dll';
  procedure CVN_ConnecttoServer(url:pchar);StdCall; external 'cvn_main.dll';
  function CVN_ServerIsConnected:boolean ;StdCall; external 'cvn_main.dll';
  //Procedure synapp(App:TApplication);stdcall; external 'Dll/cvn_main.dll';
  Procedure CVN_Message(Aproc:TfarProc);StdCall; external 'cvn_main.dll';

  function CVN_AllUserInfo:TPeerGroupInfo;StdCall; external 'cvn_main.dll';
  function CVN_GetUserList:TList;StdCall; external 'cvn_main.dll';

  function CVN_getTCPc2cport:integer;stdcall; external 'cvn_main.dll';
  function CVN_getUDPc2cport:integer;stdcall; external 'cvn_main.dll';
  //function CVN_Getmyinnerip:string;stdcall; external '../cvn_main.dll';
  function CVN_InitEther:boolean;stdcall; external 'cvn_main.dll';
  procedure CVN_FreeRes;stdcall;external 'cvn_main.dll';

  procedure CVN_InitClientServer(tcpport,udpport:integer);stdcall; external 'cvn_main.dll';
  function CVN_CountRecive:int64;Stdcall; external 'cvn_main.dll';
  function CVN_CountSend:int64;Stdcall; external 'cvn_main.dll';
  function getUserByID(userid:integer):Tuserinfo; stdcall;  external 'cvn_main.dll';
  function getuserByName(userName:pchar):Tuserinfo; stdcall; external 'cvn_main.dll';
  function getUserByIDex(userid:integer):Puserinfo; stdcall; external 'cvn_main.dll';
  function getUserByMAC(mac:pchar):Tuserinfo; stdcall; external 'cvn_main.dll';
  function getGroupByID(groupid:integer):TPeerGroupInfo; stdcall; external 'cvn_main.dll';
  function getuFriendByID(userid:integer):Tuserinfo; stdcall; external 'cvn_main.dll';
  function diduserinlist(userid:integer):boolean; stdcall; external 'cvn_main.dll';
  function CVN_GetEtherName():pchar; external 'cvn_main.dll';
  function CVN_GetEthermac():pchar; external 'cvn_main.dll';

  procedure CVN_SendCmdto(cmd:string);

  procedure initDll;
  procedure SetActiveLanguage(form:tform);
  function resinfo(str:string):string;
  function checkrunning:boolean;

implementation
uses SysUtils, clientUI, IpRtrMib, winsock, IPFunctions;

    procedure CVN_SendCmdto(cmd:string);
    begin
         CVN_SendCmd(pchar(cmd));
    end;

    function checkrunning:boolean;
    var    mHandle:hwnd;
    begin
         result:=false;
         mHandle := Windows.CreateMutex(nil, true, pchar(Application.Title));
          if mHandle <> 0 then
          begin
            if GetLastError = Windows.ERROR_ALREADY_EXISTS then
            begin
                showmessage('ConVnet Client Has Running!');
                Windows.ReleaseMutex(mHandle);
                result:=true;
                exit;
            end;
          end;
          Windows.ReleaseMutex(mHandle);
    end;
  procedure initDll;
  begin
    //同步窗口句柄  EXT:CVN_MAIN.DLL,用户重连需要消息窗体的句柄，需要传回
    //synapp(Application);
    //初始化接收函数
    CVN_message(@GetCVNmessage);
    CVN_InitClientServer(globalport_TCP,globalport_UDP); 
  end;

  function CatStringAfterStar(str:string):string;
  var i:integer;
  begin
    i:=pos('*',str);
    result:=Copy(str,i+1,length(str)-i);
  end;

  function formatInttoViewtext(int:int64):string;
  begin
    if int>=1048576 then
    begin
      result:=floattostrf(int/1048576,ffNumber,4,2)+'MB';
      exit;
    end;
    if (int>=1024) and (int<=1048576) then
    begin
      result:=floattostrf(int/1024,ffNumber,4,2)+'KB';
      exit;
    end;
    if (int>=0) and (int<=1024) then
    begin
      result:=floattostr(int)+' byte';
      exit;
    end;
  end;

function GetCVNIPByUserID(Userid:Integer):string;
var ip3,ip4:integer;
begin
   { result:=inttostr(htonl($0A080000+UserID));
    exit;
            }
   if Userid<=65500 then
   begin
     ip3:=userid div 254;
     
     ip4:=userid - (ip3*254) + 1;
     result:='10.110.'+inttostr(ip3)+'.'+inttostr(ip4);
   end else
     result:='';
end;

  function IpAddressToString(Addr: DWORD): string;
  var
    InAddr: TInAddr;
  begin
    InAddr.S_addr := Addr;
    Result := inet_ntoa(InAddr);
  end;

function ConvertDataToHex(Buffer: pointer; Length: Word): string;
var
  Iterator: integer;
  HexBuffer: string;
begin
  HexBuffer := '';
  for Iterator := 0 to Length - 1 do
  begin
    HexBuffer := HexBuffer + IntToHex(Ord(char(pointer(integer(Buffer) + Iterator)^)), 2) + '';
  end;
  Result := HexBuffer;
end;

    function getDefaultGateWay: string;
    var
      BestRoute: TMibIpForwardRow;
      dwDestAddr: DWORD;
    begin
      try
        dwDestAddr := inet_addr('221.226.68.62');
        VVGetBestRoute(dwDestAddr, 0, @BestRoute);
        IpAddressToString(BestRoute.dwForwardNextHop);
        result:=IpAddressToString(BestRoute.dwForwardNextHop);
      except
      end;
    end;

     procedure SetActiveLanguage(form:tform);//界面处理
      var
        frmComponent:TComponent;
        i:Integer;
      begin
        if resinfo(form.Name+'.Caption')<>'' then
          form.Caption:=resinfo(form.Name+'.Caption');
       
          for i:=0 to form.ComponentCount-1 do
          begin
            frmComponent:=form.Components[i];
            if resinfo(frmComponent.Name+'.Caption')='' then continue;
            if frmComponent is Tform then
              (frmComponent as Tform).Caption:=resinfo(frmComponent.Name+'.Caption');


            if frmComponent is TLabel then
              (frmComponent as TLabel).Caption:=resinfo(frmComponent.Name+'.Caption');

            if frmComponent is TRzBmpButton then
              (frmComponent as TRzBmpButton).Hint:=resinfo(frmComponent.Name+'.Caption');

            if frmComponent is TRzBitBtn then
            begin
              (frmComponent as TRzBitBtn).Caption:=resinfo(frmComponent.Name+'.Caption');
              (frmComponent as TRzBitBtn).Hint:=resinfo(frmComponent.Name+'.Caption');
            end;
            if frmComponent is TCheckBox then
              (frmComponent as TCheckBox).Caption:=resinfo(frmComponent.Name+'.Caption');

            if frmComponent is TButton then
            begin
              (frmComponent as TButton).Caption:=resinfo(frmComponent.Name+'.Caption');
              (frmComponent as TButton).Hint:=resinfo(frmComponent.Name+'.Caption');
            end;

            if frmComponent is TRadioButton then
              (frmComponent as TRadioButton).Caption:=resinfo(frmComponent.Name+'.Caption');

            if frmComponent is TMenuItem then
              (frmComponent as TMenuItem).Caption:=resinfo(frmComponent.Name+'.Caption');
         end;

      end;
    function resinfo(str:string):string;
    begin
      result:= g_ResStrlist.Values[str];
    end;

end.
 