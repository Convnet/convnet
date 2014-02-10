unit CVN_Protocol;

interface
uses SysUtils;
type
  {用于数据包头的Command字段}
  TP2Ptype=(
        ALL_DATA,          //发送数据
        UDP_S2S,
        UDP_S2SResp,
        UDP_C2S,
        UDP_C2SResp,
        UDP_C2C,
        UDP_C2CResp,
        UDP_GETPORT,
        UDP_P2PResp,
        TCP_C2S,
        TCP_C2SResp,
        TCP_SvrTrans,
        ALL_NOTARRIVE,     //所有方法无法到达
        NOTCONNECT,        //对方无法连接
        DISCONNECT,        //断开连接
        SAMEIP_CALL        //相同IP连接
        );

  TP2PCMD=(
       CMDSERVERTRANS,

       //登录登出
       cmdLogin,
       cmdLoginResp,
       cmdLogout,
       cmdLogoutResp,
       //更新用户状态
       cmdRenewUserStatus,
       //更新用户信息
       cmdRenewMYinfo,
       cmdRenewMYinforesp,
       //获取版本信息
       cmdGetVersionResp,
       //获取服务器信息
       cmdGetServerPort,
       cmdGetServerPortResp,
       //注册
       cmdRegistUser,
       cmdRegistUserResp,
       //用户消息
       cmdSendMsgtoID,
       cmdSendMsgtoIDResp,
       //获取用户、组信息
       cmdGetFriendInfo,
       cmdGetFriendInfoResp,
       cmdGetGroupInfo,
       cmdGetGroupInfoResp,
       cmdGetGroupDesc,
       cmdGetGroupDescresp,
       //获取单独用户信息
       cmdGetUserinfo,
       cmdGetUserinfoResp,
       //上线通知
       cmdOnlinetell,
       cmdOnlinetellResp,
       //下线通知
       cmdOffLinetellResp,
       //加入组
       cmdJoinGroup,
       cmdJoinGroupResp,
       //修改组
       cmdmodifyGroup,
       cmdmodifyGroupresp,

       //消息无法到达
       cmdMsgcantarrive,
       //创建组
       cmdCreateGroup,
       cmdCreateGroupResp,
       //退出组
       cmdQuitGroup,
       cmdQuitGroupResp,
       //踢出用户
       cmdKickOut,
       cmdKickOutResp,
       //添加用户
       cmdAddFriend,
       cmdAddFriendResp,

       //删除用户
       cmdDelFriend,
       cmdDelFriendResp,

       //要求服务器转发数据
       cmdOrdServerTrans,
       cmdOrdServerTransResp,

       //同意添加
       cmdPeerSureFriend,
       cmdPeerSureFriendResp,

       //拒绝添加
       cmdPeerRefusedFriend,
       cmdPeerRefusedFriendResp,

       //同意加入组
       cmdPeerSureJoinGroup,
       cmdPeerSureJoinGroupresp,
       
       //要求添加
       cmdPeerOrdFriend,
       cmdPeerOrdFriendResp,
       //查找用户、组
       cmdFindUser,
       cmdFindUserResp,
       cmdFindGroup,
       cmdFindGroupResp,
       
       //请求连接
       cmdCalltoUser,
       cmdCalltoUserResp,
       cmdCalltoUserNewPort,
       cmdCalltoUserNewPortResp,
       //端开连接
       cmdDissConnUser,
       cmdDissConnUserResp,
       //客户端确认端口
       cmdISClientUDP,
       cmdP2P,      //P2P
       cmdKeeponLine,//心跳包
       cmdUserNeedPass,//用户需要密码
       cmdSameipInfo,//相同IP应答
       cmdSameipInforesp,

       cmdCheckNatType,
       cmdServerSendToClient
       );
    type
    tcmd=record
      cmdhead:string[1];
      cmdcontext:pchar;
    end;


    tquitMode=(
               CVN_NotDefine,
               CVN_ApplicationQuit,
               CVN_ApplicationTerminate,
               CVN_QuitToLogin,
               CVN_ServerBan,
               CVN_RegistDIS
              );
    
    function ProtocolToStr(protocol:tP2pcmd):string; overload;
    function ProtocolToStr(protocol:TP2Ptype):string; overload;
    function FormatUnAllowStr(s:string;len:integer):string;
    function ReplaceStr(S, OldStr, NewStr: string): string;
implementation
uses StrUtils;
    function ProtocolToStr(protocol:tP2pcmd):string;
    begin
        result:=inttostr(ord(protocol));
    end;

    function ProtocolToStr(protocol:TP2Ptype):string; overload;
    begin
        result:=inttostr(ord(protocol));
    end;

    function ReplaceStr(S, OldStr, NewStr: string): string;
    var i,j:integer;
        ss:string;
    begin  //替换字符串
      i:=1;
      ss:='';
      j:=length(OldStr);
      while i<=length(s) do
        begin
          if LowerCase(copy(s,i,j))=LowerCase(OldStr) then
           begin
             ss:=ss+NewStr;
             inc(i,j);
          end
          else
          begin
            ss:=ss+s[ i ];
            inc(i,1);
          end;
      end;
      Result:=ss;
    end;

    function FormatUnAllowStr(s:string;len:integer):string;
    begin
       s:=ReplaceStr(s,'''','');
       s:=ReplaceStr(s,':','');
       s:=ReplaceStr(s,' ','');
       s:=ReplaceStr(s,'*','');
       s:=ReplaceStr(s,',','');
       s:=LeftStr(s,len);
       result:=s;
    end;
end.

