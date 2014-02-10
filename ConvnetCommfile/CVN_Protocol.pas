unit CVN_Protocol;

interface
uses SysUtils;
type
  {�������ݰ�ͷ��Command�ֶ�}
  TP2Ptype=(
        ALL_DATA,          //��������
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
        ALL_NOTARRIVE,     //���з����޷�����
        NOTCONNECT,        //�Է��޷�����
        DISCONNECT,        //�Ͽ�����
        SAMEIP_CALL        //��ͬIP����
        );

  TP2PCMD=(
       CMDSERVERTRANS,

       //��¼�ǳ�
       cmdLogin,
       cmdLoginResp,
       cmdLogout,
       cmdLogoutResp,
       //�����û�״̬
       cmdRenewUserStatus,
       //�����û���Ϣ
       cmdRenewMYinfo,
       cmdRenewMYinforesp,
       //��ȡ�汾��Ϣ
       cmdGetVersionResp,
       //��ȡ��������Ϣ
       cmdGetServerPort,
       cmdGetServerPortResp,
       //ע��
       cmdRegistUser,
       cmdRegistUserResp,
       //�û���Ϣ
       cmdSendMsgtoID,
       cmdSendMsgtoIDResp,
       //��ȡ�û�������Ϣ
       cmdGetFriendInfo,
       cmdGetFriendInfoResp,
       cmdGetGroupInfo,
       cmdGetGroupInfoResp,
       cmdGetGroupDesc,
       cmdGetGroupDescresp,
       //��ȡ�����û���Ϣ
       cmdGetUserinfo,
       cmdGetUserinfoResp,
       //����֪ͨ
       cmdOnlinetell,
       cmdOnlinetellResp,
       //����֪ͨ
       cmdOffLinetellResp,
       //������
       cmdJoinGroup,
       cmdJoinGroupResp,
       //�޸���
       cmdmodifyGroup,
       cmdmodifyGroupresp,

       //��Ϣ�޷�����
       cmdMsgcantarrive,
       //������
       cmdCreateGroup,
       cmdCreateGroupResp,
       //�˳���
       cmdQuitGroup,
       cmdQuitGroupResp,
       //�߳��û�
       cmdKickOut,
       cmdKickOutResp,
       //����û�
       cmdAddFriend,
       cmdAddFriendResp,

       //ɾ���û�
       cmdDelFriend,
       cmdDelFriendResp,

       //Ҫ�������ת������
       cmdOrdServerTrans,
       cmdOrdServerTransResp,

       //ͬ�����
       cmdPeerSureFriend,
       cmdPeerSureFriendResp,

       //�ܾ����
       cmdPeerRefusedFriend,
       cmdPeerRefusedFriendResp,

       //ͬ�������
       cmdPeerSureJoinGroup,
       cmdPeerSureJoinGroupresp,
       
       //Ҫ�����
       cmdPeerOrdFriend,
       cmdPeerOrdFriendResp,
       //�����û�����
       cmdFindUser,
       cmdFindUserResp,
       cmdFindGroup,
       cmdFindGroupResp,
       
       //��������
       cmdCalltoUser,
       cmdCalltoUserResp,
       cmdCalltoUserNewPort,
       cmdCalltoUserNewPortResp,
       //�˿�����
       cmdDissConnUser,
       cmdDissConnUserResp,
       //�ͻ���ȷ�϶˿�
       cmdISClientUDP,
       cmdP2P,      //P2P
       cmdKeeponLine,//������
       cmdUserNeedPass,//�û���Ҫ����
       cmdSameipInfo,//��ͬIPӦ��
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
    begin  //�滻�ַ���
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

