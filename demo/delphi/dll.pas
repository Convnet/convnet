unit dll;


interface
uses windows,Classes;
    type

    pPeerGroupInfo = ^TPeerGroupInfo;
    TPeerGroupInfo = class(Tlist)
      GroupID:integer;
      Creator:integer;
      GroupName:string[12];
      GroupDes:string[30];
      NeedPass:boolean;
    end;

     Puserinfo =^TUserInfo;


    TUserInfo = class (tobject)
     connecting:boolean;
      UserID:integer;
      UserName,
      AhthorPassword:string[12];
      ISOnline:boolean;
      Connected:boolean;
      MacAddress:string[12];

      Con_ConnectionType:integer;
      Con_IP:string[15];
      Con_port:integer;
      Con_RetryTime:integer;
      Con_send:int64;
      Con_recv:int64;
      tvUserReconn:integer;
      peerport:integer;
      con_AContext:pointer;
      con_Lastrecv:tdatetime;
      clientDM:pointer;
      procedure TryConnect_start; virtual; abstract;
      procedure RefInfo_whenConnect(ip:string;port:integer;Mac:string); virtual; abstract;
      procedure DissconnectPeer; virtual; abstract;
//      procedure sendtopeer(str:string);overload;
      procedure sendtopeer(buffer:pchar; buflength:integer); virtual; abstract;
      procedure RetryTimer(Sender: TObject); virtual; abstract;
    end;

  procedure CVN_SendCmd(str:string);StdCall; external 'cvn_main.dll';
  procedure CVN_ConnectUser(Userid:integer;password:string);stdcall;external 'cvn_main.dll';
  procedure CVN_Login(cvnurl,username,password:pchar);stdcall;external 'cvn_main.dll';
  procedure CVN_Logout;stdcall;external 'cvn_main.dll';

  procedure CVN_DisConnectUser(Userid:integer);stdcall;  external 'cvn_main.dll';
  function CVN_ConnecttoServer(url:string):boolean;StdCall; external 'cvn_main.dll';
  //Procedure synapp(App:TApplication);stdcall; external 'Dll/cvn_main.dll';
  Procedure CVN_Message(Aproc:TfarProc);StdCall; external 'cvn_main.dll';

  function CVN_AllUserInfo:TPeerGroupInfo;StdCall; external 'cvn_main.dll';
  function CVN_GetUserList:TList;StdCall; external 'cvn_main.dll';

  function CVN_getTCPc2cport:integer;stdcall; external 'cvn_main.dll';
  function CVN_getUDPc2cport:integer;stdcall; external 'cvn_main.dll';
  //function CVN_Getmyinnerip:string;stdcall; external '../Dll/cvn_main.dll';
  function CVN_InitEther:boolean;stdcall; external 'cvn_main.dll';
  procedure CVN_FreeRes;stdcall;external 'cvn_main.dll';

  procedure CVN_GetEtherName(p:pchar); external 'cvn_main.dll';
  procedure CVN_InitClientServer(tcpport,udpport:integer);stdcall; external 'cvn_main.dll';
  function CVN_CountRecive:int64;Stdcall; external 'cvn_main.dll';
  function CVN_CountSend:int64;Stdcall; external 'cvn_main.dll';
  function getUserByID(userid:integer):Tuserinfo; stdcall;  external 'cvn_main.dll';
  function getuserByName(userName:string):Tuserinfo; stdcall; external 'cvn_main.dll';
  function getUserByIDex(userid:integer):Puserinfo; stdcall; external 'cvn_main.dll';
  function getUserByMAC(mac:string):Tuserinfo; stdcall; external 'cvn_main.dll';
  function getGroupByID(groupid:integer):TPeerGroupInfo; stdcall; external 'cvn_main.dll';
  function getuFriendByID(userid:integer):Tuserinfo; stdcall; external 'cvn_main.dll';
  function diduserinlist(userid:integer):boolean; stdcall; external 'cvn_main.dll';

implementation

end.
 