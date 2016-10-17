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
      tvUserReconn:int64;
      con_AContext:pointer;
      clientDM:pointer;
      conTimer:pointer;
      needpassword:boolean;

      procedure TryConnect; virtual; abstract;    //��������
      procedure TryTransfConnect_start; virtual; abstract;//���Է�����ת��
      procedure RefInfo_whenConnect(ip:string;port:integer;Mac:string); virtual;abstract;
      procedure DissconnectPeer; virtual; abstract;
      procedure SendtoPeer(buffer:pansichar; buflength:integer);virtual;abstract;//overload;
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
      GroupName:string[20];
      GroupDes:string[250];
      NeedPass:boolean;
    end;

var ServerIP:string;
  serverhost:string;
  UserName:string;
  password:String;
  g_MyMac:string;
  
  g_MyPublicIP:string;                                  //�ҵĹ���IP
  g_Userid:integer;                                     //�ҵ�ID
  g_userName:string[40];                                //�û���
  g_NickName:string[40];                                //�ҵ��ǳ�
  g_common:string[40];                                  //�ҵı�ע
  g_AllowPass1:string[40];                              //������ʵ�����1
  g_AllowPass2:string[40];                              //������ʵ�����2
  g_AllowPass3:string[40];                              //������ʵ�����3
  g_AllowPass4:string[40];                              //������ʵ�����4

  g_newmessage:boolean;

  g_ComMessage:widestring;
  g_ComMessageType:integer;

  g_peerRetry:integer;//�ͻ����������ְ�


  //g_rechecknattype_count:integer;                       //���¼�����
  rmouteCommandAllowuserlist:tstringlist;
 


  g_MyPass:string[12];                                  //�ҵ�����
  g_quitCause:string;
  g_UDPserverPortA:integer;
  g_UDPserverPortB:integer;

  g_GroupAll:TList;


  g_AllUserInfo:tlist;
  g_ChatFormsList:TList;
  g_GourpChatFormsList:TList;
  
  g_HasUpnpTCPServer:boolean;
  g_HasUpnpUDPServer:boolean;

  my_upnptcpport:integer;
  my_upnpudpport:integer;


  g_recv:int64;
  g_send:int64;
  g_myIPlists:string;

  g_MyNatType:string;
  g_ServerIP:string;

  g_currentNode:PVirtualNode;                           //��굱ǰ���ڵĽڵ�
  g_currentNodeColumn:integer;                          //��굱ǰ���ڵ���
  //message_str:string;               //ID+','+���͵���Ϣ\
  g_defaultgeteway:string;

  g_HitInfo:tHitInfo;//��갴�µ���Ϣ


  g_MYEtherString:string;

  g_operationingUser:Puserinfo;                          //���ڲ������û�����

  globalport_TCP:integer;
  globalport_UDP:integer;

  g_ResStrlist:Tstringlist;   
  
  function GetCVNIPByUserID(Userid:Integer):string;
  function CatStringAfterStar(str:string):string;
  function IpAddressToString(Addr: DWORD): string;
  function getDefaultGateWay: string;
  
  function ConvertDataToHex(Buffer: pointer; Length: Word): string;
  function formatInttoViewtext(int:int64):string;

  function CVN_GetUserinfo:pansichar;StdCall; external 'cvn_main.dll';
  procedure CVN_SendCmd(str:pchar);StdCall; external 'cvn_main.dll';
 // procedure CVN_ConnectUser(Userid:integer;password:pchar);stdcall;external 'cvn_main.dll';
  procedure CVN_Login(cvnurl,username,password:pchar);stdcall;external 'cvn_main.dll';
  procedure CVN_Logout;stdcall;external 'cvn_main.dll';
  procedure CVN_closefirewall;stdcall;external 'cvn_main.dll';

  procedure CVN_testdissconnect;stdcall;external 'cvn_main.dll';
  procedure CVN_DisConnectUser(Userid:integer);stdcall;  external 'cvn_main.dll';
  procedure CVN_ConnecttoServer(url:pchar);StdCall; external 'cvn_main.dll';
  function CVN_ServerIsConnected:boolean ;StdCall; external 'cvn_main.dll';
  //Procedure synapp(App:TApplication);stdcall; external 'Dll/cvn_main.dll';
  Procedure CVN_Message(Aproc:TfarProc);StdCall; external 'cvn_main.dll';


  function CVN_GetGroupUserByGroupIndex(group:PPeerGroupInfo;groupIndex:integer):TUserInfo;StdCall;external 'cvn_main.dll';
  function CVN_GetGroupByIndex(index:integer):TPeerGroupInfo;StdCall; external 'cvn_main.dll';
  function CVN_GetGroupCount:integer;StdCall; external 'cvn_main.dll';
  function CVN_GetUserGroup:TList;StdCall; external 'cvn_main.dll';
  function CVN_GetGroupList:TList;StdCall; external 'cvn_main.dll';

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
  function getUserByMAC(mac:pchar):Tuserinfo; stdcall; external 'cvn_main.dll';
  function getGroupByID(groupid:integer):TPeerGroupInfo; stdcall; external 'cvn_main.dll';
  function getuFriendByID(userid:integer):Tuserinfo; stdcall; external 'cvn_main.dll';
  function diduserinlist(userid:integer):boolean; stdcall; external 'cvn_main.dll';
  function CVN_GetEtherName():pchar;stdcall;  external 'cvn_main.dll';

  function CVN_GetEthermac():pchar;stdcall; external 'cvn_main.dll';
  function CVN_GetVersion:double; stdCall; external 'cvn_main.dll';

  procedure CVN_GroupChatMsg(groupid:integer;msg:pchar); StdCall;external 'cvn_main.dll';

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
    //ͬ�����ھ��  EXT:CVN_MAIN.DLL,�û�������Ҫ��Ϣ����ľ������Ҫ����
    //synapp(Application);
    //��ʼ�����պ���
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
    var tempid:integer;
             function int2Ip(intIP : Int64) : string;
              var
                n : int64;
              begin
                Result := '';
                n := intIP shr 24;
                intIP := intIP xor (n shl 24);
                Result := IntToStr(n) + '.';

                n := intIP shr 16;
                intIP := intIP xor (n shl 16);
                Result := Result + IntToStr(n) + '.';

                n := intIP shr 8;
                intIP := intIP xor (n shl 8);
                Result := Result + IntToStr(n) + '.';

                n := intIP;
                Result := Result + IntToStr(n);
              end;

    begin

        tempid:=userid-(userid div 254)*254 +1;
        tempid:=tempid + (256 * (userid div 254));
        result:=int2Ip($0A6E0000+tempid);
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

     procedure SetActiveLanguage(form:tform);//���洦��
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
 