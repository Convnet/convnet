unit clientUI;
{$define EnableMemoryLeakReporting}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CoolTrayIcon, Menus,
  StdCtrls, ExtCtrls, RzCommon, ImgList, VirtualTrees,
  RzStatus, RzPanel, RzLabel, RzBorder, Mask, RzEdit, RzButton, RzTabs,
  ClientStruct,CVN_ClientChat,CVN_CSYS,
  DateUtils,ComCtrls,Crypt, SyncObjs, Contnrs, Tlhelp32, RzBmpBtn, RzCmboBx,
  winsock, auHTTP, auAutoUpgrader,CVN_ClientMSG,
   StrCOnv, comobj, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, convnet_TLB, idsync;
const
  CVN_Message_all = wm_user +200;


type
  Pmemorystream=^tmemorystream;
  Tfclientui = class(TForm)
    bRegist: TRzBitBtn;
    bLogin: TRzBitBtn;
    cCloseNTFW: TCheckBox;
    checkAutoLogin: TCheckBox;
    RzLEDDisplay1: TRzLEDDisplay;
    maintree: TVirtualStringTree;
    Panel1: TPanel;
    labSend: TRzLabel;
    labRecv: TRzLabel;
    Image5: TImage;
    Image6: TImage;
    labConnections: TRzLabel;
    bAddFriend: TRzBmpButton;
    bJoinGroup: TRzBmpButton;
    bCreateGroup: TRzBmpButton;
    bEditMyProf: TRzBmpButton;
    bLogOut: TRzBmpButton;
    RzStatusBar1: TRzStatusBar;
    RzGlyphStatus1: TRzGlyphStatus;
    RzStatusPane1: TRzStatusPane;
    RzStatusPane2: TRzStatusPane;
    Panel3: TPanel;
    imagepackage: TImageList;
    RzFrameController1: TRzFrameController;
    Userpopup: TPopupMenu;
    N111: TMenuItem;
    N13: TMenuItem;
    N12: TMenuItem;
    N2: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N1: TMenuItem;
    N14: TMenuItem;
    Grouppopup: TPopupMenu;
    N11: TMenuItem;
    GROUPDELETE: TPopupMenu;
    N18: TMenuItem;
    N17: TMenuItem;
    N16: TMenuItem;
    group_user_man: TPopupMenu;
    N8: TMenuItem;
    checketherip: TTimer;
    ImageList1: TImageList;
    refui: TTimer;
    bSetautoconnection: TRzBmpButton;
    Image7: TImage;
    ping1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    currentuser: TRzLabel;
    PopupMenu1: TPopupMenu;
    dasd1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N15: TMenuItem;
    ImageToolBar: TImageList;
    a1: TMenuItem;
    loginPanel: TPanel;
    mainPanel: TPanel;
    Image3: TImage;
    Image2: TImage;
    RzBmpButton1: TRzBmpButton;
    bquit: TRzBmpButton;
    CoolTrayIcon1: TCoolTrayIcon;
    bSetnetwork: TRzBmpButton;
    ServerList: TRzComboBox;
    Label1: TLabel;
    N3: TMenuItem;
    N19: TMenuItem;
    eUserName: TEdit;
    ePassword: TEdit;
    eServerIP: TEdit;
    Panel2: TPanel;
    Image4: TImage;
    myserverInfo: TLabel;
    Timer1: TTimer;
    Image1: TImage;
    labInfomation: TLabel;
    RzBitBtn1: TRzBitBtn;
    procedure bLoginClick(Sender: TObject);
    procedure maintreeBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure maintreeCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure maintreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure maintreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure maintreeFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure maintreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure maintreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure maintreeInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure maintreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure maintreeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure maintreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure bRegistClick(Sender: TObject);
    procedure bLogOutClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure bAddFriendClick(Sender: TObject);
    procedure bJoinGroupClick(Sender: TObject);
    procedure bCreateGroupClick(Sender: TObject);
    procedure bEditMyProfClick(Sender: TObject);
    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CoolTrayIcon1MinimizeToTray(Sender: TObject);
    procedure RzBmpButton1Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure refuiTimer(Sender: TObject);
    procedure checketheripTimer(Sender: TObject);
    procedure loadautoconntioninfo;
    procedure StartAutoConnection;
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure ping1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure bquitClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure CustomClick(Sender: TObject);
    procedure CustomClick2(Sender: TObject);
    procedure UserpopupPopup(Sender: TObject);
    procedure maintreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure onMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    procedure maintreeColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure dasd1Click(Sender: TObject);
    procedure bSetnetworkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bSetautoconnectionMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N19Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure checkAutoLoginClick(Sender: TObject);
    procedure ServerListChange(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    

    procedure WMTIMER(Var msg: TWMTimer); message WM_TIMER;
    procedure WMCVN_Message(var AMsg:TMessage);message CVN_Message_all;//


  public
    { Public declarations }
    comEvents:IcoConvnetEvents;
    procedure startlogin;
    procedure showUI_Logined; 
    //procedure showLogin;
    procedure ShowUI_logout;
    procedure Sortuserlist;
    procedure redrawTree;

    procedure showrenewmyinfosucc;
    procedure cleartree;
    procedure rebuildtree;
    procedure showusermessage(s:string);
    function Getchatform(userinfo:Tuserinfo):tchatform;
    procedure showusermessage_error(s:string);
    procedure createGroupResp(tmpstr:string);
    procedure RefreshNetStatus;
    procedure needpass(tmpstr:string);
    procedure showuserinfo(tmpstr:string);
    procedure disableUI_WhenLostConnection;
    procedure installether;
    procedure WndProc(var nMsg: TMessage); override;
    procedure Commessage;
  end;



  procedure closefirewall(isopen:boolean);
  procedure GetCVNmessage(messagetype:integer;messagestring:string);stdcall;


var
  fclientui: Tfclientui;



implementation
{$R *.dfm}
uses CVN_regist,CVN_Protocol, CVN_modifyGroupinfo,
  CVN_Ffinduser, CVN_FfindGroup, CVN_CreateGroup, CVN_PrivateSetup,
  CVN_MessageWindow, CVN_FConnectionPass,
  IPFunctions, IpRtrMib , CVN_ViewUserInfo, CVN_PeerOrd,
  CVN_FAutoconnection, CVN_faddautouser, NTFireWall, CVN_messageWin,
  shellAPI, CVN_Remotecomm, FrmMainU, coConvnet;

procedure closefirewall(isopen:boolean);
begin
  if not isopen then
    CVN_closefirewall;
end;

procedure Tfclientui.Sortuserlist;
begin
  maintree.SortTree(3,sdAscending,true);
end;

procedure Tfclientui.showUI_Logined;
begin
  //PageControl.ActivePageIndex:=1;
  bLogin.Enabled:=false;//不可以登录
  loginPanel.Visible:=false;
  mainPanel.Visible:=true;
  mainPanel.Align:=alClient;
  bAddFriend.Enabled:=true;
  bJoinGroup.Enabled:=true;
  bCreateGroup.Enabled:=true;
  bSetautoconnection.Enabled:=true;
  bEditMyProf.Enabled:=true;


  currentuser.Caption:=resinfo('USER_TEXT')+g_NickName;
  //CoolTrayIcon1.Hint:='ConVnet ver1.0'+#10+'当前用户:'+g_username+#10+'当前IP:'+GetCVNIPByUserID(g_userid);



  myserverInfo.Caption:=g_common;

  RzLEDDisplay1.Caption:='MYIP:'+GetCVNIPByUserID(g_userid);


  //开始监视用户是否设置了10.8.0的IP地址
  checketherip.Enabled:=true;

  sleep(200);
  loadautoconntioninfo;
  StartAutoConnection;
end;

procedure Tfclientui.startlogin;
begin
  labInfomation.Caption:=resinfo('USER_LOGIN_START');
end;

function ResolveIP(HostName: string): string; {delphi把域名转换成IP}
type
tAddr = array[0..100] of PInAddr;
pAddr = ^tAddr;
var
I: Integer;
WSA: TWSAData;
PHE: PHostEnt;
P: pAddr;
begin
Result := '';

WSAStartUp($101, WSA);
try
PHE := GetHostByName(pChar(HostName));
if (PHE <> nil) then
begin
P := pAddr(PHE^.h_addr_list);
I := 0;
while (P^[I] <> nil) do
begin
Result := (inet_nToa(P^[I]^));
Inc(I);
end;
end;
except
end;
WSACleanUp;
end;


procedure Tfclientui.bLoginClick(Sender: TObject);
var inifile:tstringlist;
begin
    if g_mymac='' then
    begin
       labInfomation.Caption:=resinfo('ETHER_NOT_FOUND');
       exit;
    end;

    if CVN_ServerIsConnected then exit;

    g_peerRetry:=0;

    serverip:=ResolveIP(serverhost); //插件参数需要

    bLogin.Enabled:=false;
    labInfomation.Caption:=resinfo('USER_LOGIN_START');

    CVN_Login(pchar(eServerIP.Text),
                    pchar(FromWideString(936,eUserName.Text)),
                    pchar(FromWideString(936,ePassword.Text)));

    try
      closefirewall(not cCloseNTFW.Checked);
    except
    end;

    g_UserStruct:=CVN_GetUserList;
    g_AllUserInfo:=CVN_AllUserInfo;

    
    inifile:=tstringlist.Create;
    inifile.Add('ServerIP='+eServerIP.Text);
    inifile.Add('UserName='+eUserName.Text);
    inifile.Add('Password='+EncryptString(ePassword.Text));
    inifile.Add('AutoLogin='+booltostr(checkAutoLogin.checked));
    inifile.Add('NeedFireWall='+booltostr(cCloseNTFW.checked));
    //inifile.Add('NeedVnc='+booltostr(needvnc.checked));
    inifile.Add('TCPPort='+inttostr(globalport_TCP));
    inifile.Add('UDPPort='+inttostr(globalport_UDP));

    try
      if not DirectoryExists(ExtractFilePath(Application.ExeName)+'ini') then
        ForceDirectories(ExtractFilePath(Application.ExeName)+'ini');
      inifile.SaveToFile(ExtractFilePath(Application.ExeName) + 'ini\config.ini');
    except
    end;
    refui.Enabled:=true;
    inifile.Free;  
end;

procedure Tfclientui.maintreeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
  var dataGroup:pPeerGroupInfo;
begin
  dataGroup:=sender.GetNodeData(node);
  if not assigned(dataGroup) then exit;

  if Sender.GetNodeLevel(Node)=0 then
    TargetCanvas.Brush.Bitmap:=image3.Picture.Bitmap;

  TargetCanvas.FillRect(CellRect);
end;

procedure Tfclientui.maintreeCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    var datauser1,datauser2:pUserinfo;
      tmps1,tmps2:string;
begin
  //排序时用到的排序比较的事件
  if (Sender.GetNodeLevel(Node1)=1) and (Sender.GetNodeLevel(Node2)=1) then
  begin
    dataUser1:=sender.GetNodeData(node1);
    datauser2:=sender.GetNodeData(node2);
    if dataUser1.ISOnline then
        tmps1:='000000'+dataUser1.UserName
    else
        tmps1:=dataUser1.UserName;
    if dataUser2.ISOnline then
        tmps2:='000000'+dataUser2.UserName
    else
        tmps2:=dataUser2.UserName;
      result:=CompareText(tmps1, tmps2);
  end;
end;

procedure Tfclientui.maintreeGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var Userinfo:puserinfo;
begin
  case Sender.GetNodeLevel(Node) of
      1:
      begin
        userinfo:=sender.GetNodeData(node);
        if userinfo.Connected then
        begin
          HintText:=resinfo('SEND_SIZE')+formatInttoViewtext(userinfo.Con_send)+ #10#13;
          if  userinfo.Con_recv>0 then
          HintText:=HintText+resinfo('RECV_SIZE')+formatInttoViewtext(userinfo.Con_recv)+ #10#13;
          HintText:=HintText+'MAC:'+ userinfo.MacAddress+ #10#13;
          case userinfo.Con_ConnectionType of
            ord(tcpserver):
            begin
              HintText:=HintText+resinfo('SERVER_ALLOCATION_IP')+GetCVNIPByUserID(userinfo.UserID)+#10#13;
              HintText:=HintText+resinfo('CONNECT_TYPE')+'PEER UPNP_TCP IN'+#10#13+resinfo('TUNNELINFO_TEXT')+#10#13;
              HintText:=HintText+resinfo('REMOTE_TUNNELINFO')+userinfo.Con_IP+':'+inttostr(userinfo.Con_port)+#10#13;
              HintText:=HintText+resinfo('LOCAL_TUNNELINFO')+g_MyPublicIP+':'+inttostr(CVN_getTCPc2cport);
            end;
            ord(tcpclient):
            begin
              HintText:=HintText+resinfo('SERVER_ALLOCATION_IP')+GetCVNIPByUserID(userinfo.UserID)+#10#13;
              HintText:=HintText+resinfo('CONNECT_TYPE')+'LOCAL TCP OUT'+#10#13+resinfo('TUNNELINFO_TEXT')+#10#13;
              HintText:=HintText+resinfo('REMOTE_TUNNELINFO')+userinfo.Con_IP+':'+inttostr(userinfo.Con_port);
            end;
            ord(mUdpserver):
            begin
              HintText:=HintText+resinfo('SERVER_ALLOCATION_IP')+GetCVNIPByUserID(userinfo.UserID)+#10#13;
              HintText:=HintText+resinfo('CONNECT_TYPE')+'PEER UPNP_UDP IN'+#10#13+resinfo('TUNNELINFO_TEXT')+#10#13;
              HintText:=HintText+resinfo('REMOTE_TUNNELINFO')+userinfo.Con_IP+':'+inttostr(userinfo.Con_port)+#10#13;
              HintText:=HintText+resinfo('LOCAL_TUNNELINFO')+g_MyPublicIP+':'+inttostr(CVN_getUDPc2cport);
            end;
            ord(mUDPClient):
            begin
              HintText:=HintText+resinfo('SERVER_ALLOCATION_IP')+GetCVNIPByUserID(userinfo.UserID)+#10#13;
              HintText:=HintText+resinfo('CONNECT_TYPE')+'LOCAL UDP OUT'+#10#13+resinfo('TUNNELINFO_TEXT')+#10#13;
              HintText:=HintText+resinfo('REMOTE_TUNNELINFO')+userinfo.Con_IP+':'+inttostr(userinfo.Con_port)+#10#13;
              HintText:=HintText+resinfo('LOCAL_TUNNELINFO')+g_MyPublicIP+':'+inttostr(userinfo.MyPeerPort);
            end;
            ord(ServerTrans):
            begin
              HintText:=HintText+resinfo('SERVER_ALLOCATION_IP')+GetCVNIPByUserID(userinfo.UserID)+#10#13;
              HintText:=HintText+resinfo('SERVERTRANS');
            end;
          end;
        end;
        
        if not userinfo.ISOnline then exit;
        case Column of
          1: HintText:=resinfo('SEND_MESSAGE');
          2: if userinfo.Connected then
               HintText:=resinfo('DISCONNECT')+userinfo.UserName
             else
               HintText:=resinfo('CONNECT')+userinfo.UserName;
          3: if userinfo.Con_RetryTime>0 then
               HintText:=resinfo('TRY_CONNECT')+userinfo.UserName+'：'+inttostr(userinfo.Con_RetryTime)+'/6'
             else
               HintText:='';
        end;
      end;
  end;
end;

procedure Tfclientui.maintreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
  var datauser:puserinfo;
      datagroup:pPeerGroupInfo;
begin
  if Sender.GetNodeLevel(Node)=0 then
  begin
    datagroup:=sender.GetNodeData(node);
    if (datagroup.Creator=g_userid) and(Column=2) then
        ImageIndex:=1;
  end;

  if Sender.GetNodeLevel(Node)=1 then
  begin
    dataUser:=sender.GetNodeData(node);
    //用户不在线

    if (Column=0) and (not datauser.ISOnline) then
        ImageIndex:=0;

    //用户在线
    if (Column=0) and datauser.ISOnline then
        ImageIndex:=1;

    if not datauser.ISOnline then //不在线 ，但是已经连接
    begin
       //2连接/断开
       if dataUser.Connected and (Column = 2) then ImageIndex:=6;
       if (datauser.SenderrorCount>0) and dataUser.Connected then ImageIndex:=8;
       
       if (g_currentNode=node) and (g_currentNodeColumn=Column) then
       begin
         if dataUser.Connected and (Column = 2) then ImageIndex:=4; 
       end;
       exit;
    end;

    if (g_currentNode=node) then
       if Column = 0 then ImageIndex:=10;
    if (g_currentNode=node) and (g_currentNodeColumn=Column) then
    begin
       //鼠标移上去
       //如果已经连接则显示端开的图片
       //1CHAT
       if Column = 1 then ImageIndex:=3;
       //2连接/断开
       if dataUser.Connected and (Column = 2) then ImageIndex:=4;
       //如果没有连接则显示连接的图片
       if (not dataUser.Connected) and (Column = 2) then ImageIndex:=9;
       exit;
    end;

     //1CHAT
     if  Column= 1 then ImageIndex:=2;
     //2连接、断开
     if  (Column= 2) and dataUser.Connected then ImageIndex:=6;
     if  (Column= 2) and (not dataUser.Connected) then ImageIndex:=7;

  end;
end;

procedure Tfclientui.maintreeFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  if maintree.GetNodeLevel(NewNode)= 0 then
    allowed:=false;
end;

procedure Tfclientui.maintreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
   NodeDataSize:=sizeof(TUserInfo);
end;

procedure Tfclientui.maintreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
  var dataGroup:PPeerGroupInfo;
    dataUser:PUserInfo;
    i:integer;
    count:integer;
begin
    CellText:='';
    case  Sender.GetNodeLevel(Node) of
      0:
      begin
         dataGroup:=sender.GetNodeData(node);
         case Column of
          0:
            begin
             CellText:=dataGroup.GroupName;
             count:=0;
             for i:=0 to dataGroup.count-1 do
             begin
                 if tuserinfo(dataGroup.Items[i]).ISOnline then
                  inc(count);
             end;
             if TextType=ttStatic then
             begin
                CellText:='('+inttostr(count)+'/'+inttostr(dataGroup.count)+')';
             end;
            end;

         end;
      end;
      1:
      begin
         dataUser:=sender.GetNodeData(node);
         case Column of
          0: celltext:=dataUser.UserName;
          3: if dataUser.isonline then
              begin
                  if dataUser.connecting then
                    celltext:='T'+inttostr(datauser.Con_RetryTime)
                  else
                    celltext:='';
              end;
         end;
         if TextType=ttStatic then celltext:='';
      end;

    end;
end;

procedure Tfclientui.maintreeInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);

  var dataGroup:pPeerGroupInfo;
begin
   dataGroup:=sender.GetNodeData(node);
   ChildCount:=dataGroup.Count;
end;

procedure Tfclientui.maintreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
    var dataGroup:PPeerGroupInfo;
        dataUser:PUserInfo;
begin

   case Sender.GetNodeLevel(Node) of
     0:
       begin
         dataGroup:=sender.GetNodeData(node);
         dataGroup^:=g_UserStruct.Items[node.index];
         if dataGroup.GroupID=0 then
            node.States:=node.States+[vsExpanded,vsHasChildren]
         else
            node.States:=node.States+[vsHasChildren];
         maintree.NodeHeight[Node] := 28;
       end;
     1:
       begin
         dataUser:=sender.GetNodeData(node);
         dataGroup:=sender.GetNodeData(ParentNode);
         dataUser^:=datagroup.Items[node.index];
//         dataUser:=sender.GetNodeData(node);
         //指出MAINTREE中的结点地址
         //dataUser.treeNode:=node;
         maintree.NodeHeight[Node] := 25;
       end;
  end;
end;

procedure Tfclientui.maintreeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

  var HitInfo:THitInfo;
begin
     maintree.GetHitTestInfoAt(X,Y,true,HitInfo);
//  if maintree.GetNodeLevel(HitInfo.HitNode)=1 then
//  begin
      if maintree.GetNodeLevel(hitinfo.HitNode)=1 then
          maintree.TreeOptions.PaintOptions:=maintree.TreeOptions.PaintOptions+[tohottrack]
      else
          maintree.TreeOptions.PaintOptions:=maintree.TreeOptions.PaintOptions-[tohottrack];
      g_currentNode:=hitinfo.hitnode;
      g_currentNodeColumn:=hitinfo.HitColumn;
      maintree.RepaintNode(hitinfo.hitnode); 
//  end;

end;

procedure Tfclientui.maintreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin

          if sender.GetNodeLevel(node)= 0 then
          begin
            TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
            //组名称的颜色
            TargetCanvas.Font.Color := $00372602;
            TargetCanvas.Font.Size := 9;
          end;
          //用户名的颜色
          if sender.GetNodeLevel(node)=1 then
          begin
             if Puserinfo(sender.GetNodeData(node)).ISOnline then
              TargetCanvas.Font.Color := $00986634
             else
              TargetCanvas.Font.Color := clgray;
              TargetCanvas.Font.Size := 10;
          end;
         
        if texttype=ttStatic then
          begin
            TargetCanvas.Font.Size:=7;
          end; 
end;



procedure Tfclientui.showrenewmyinfosucc;
begin
  FCVNMSG.Label1.Caption:=RESINFO('RENEW_MY_INFO_SUCCESS');
  FCVNMSG.Show;
end;

procedure Tfclientui.cleartree;
begin
  maintree.RootNodeCount:=0;
end;

procedure Tfclientui.rebuildtree;
begin
  maintree.RootNodeCount:=g_UserStruct.Count;
end;

procedure Tfclientui.showusermessage(s:string);
var
    userinfo:Tuserinfo;
    cmdstr:string;
    tmpdm4RmComm:TRmComm;
    filename,filepath,par:string;
    commandstr:string;
    tmpstr:tstringlist;
begin
    //获取消息
    //s:=message_str;
    //截取星号之前，逗号之后的数字（用户ID）
    cmdstr:=Copy(s,0,pos('*',s)-2);
    cmdstr:=Copy(cmdstr,pos(',',cmdstr)+1,length(cmdstr)-pos(',',cmdstr));
    s:=CatStringAfterStar(s);
    try
      userinfo:=getuserByID(strtoint(cmdstr));
    except
    end;
    
    if not assigned(userinfo) then exit;//如果用户不存在则不予理会;

    if copy(s,0,1)='/' then exit;

    if copy(s,0,2)='./' then
    begin
      if getuFriendByID(userinfo.UserID)=nil then
      begin
        CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+RESINFO('RM_SU_NOTALLOW_NOTFRIEND'));
        exit;
      end;

      if g_AllowPass4='' then
      begin
        CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+RESINFO('RM_SU_NOTALLOW'));
        exit;
      end;

      if uppercase(copy(s,3,3))='SU ' then
      begin
        if g_AllowPass4=copy(s,6,length(s)-5) then
        begin
            rmoutecommandallowuserlist.Add(inttostr(userinfo.Userid));
            CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+resinfo('RM_SU_SUCCESS'));
            exit;
        end;
      end;

      if rmoutecommandallowuserlist.IndexOf(inttostr(userinfo.Userid))<0 then
      begin
        CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+resinfo('RM_NEEDSU'));
        exit;
      end;

      if uppercase(copy(s,3,3))='DIR' then
      begin
         tmpdm4RmComm:=TRmComm.Create(nil);
         tmpdm4RmComm.command:=copy(s,3,length(s));
         tmpdm4RmComm.executer:=userinfo.UserID;
         tmpdm4RmComm.Timer1.Enabled:=true;
         exit;
      end;

      if uppercase(copy(s,3,5))='ROUTE' then
      begin
         tmpdm4RmComm:=TRmComm.Create(nil);
         tmpdm4RmComm.command:=copy(s,3,length(s));
         tmpdm4RmComm.executer:=userinfo.UserID;
         tmpdm4RmComm.Timer1.Enabled:=true;
         exit;
      end;

      if uppercase(copy(s,3,3))='NET' then
      begin
         tmpdm4RmComm:=TRmComm.Create(nil);
         tmpdm4RmComm.command:=copy(s,3,length(s));
         tmpdm4RmComm.executer:=userinfo.UserID;
         tmpdm4RmComm.Timer1.Enabled:=true;
         exit;
      end;

      if uppercase(copy(s,3,4))='TYPE' then
      begin
         tmpdm4RmComm:=TRmComm.Create(nil);
         tmpdm4RmComm.command:=copy(s,3,length(s));
         tmpdm4RmComm.executer:=userinfo.UserID;
         tmpdm4RmComm.Timer1.Enabled:=true;
         exit;
      end;

      if uppercase(copy(s,3,4))='EXEC' then
      begin
        commandstr:=copy(s,8,length(s));
        filename:=ExtractFileName(commandstr);//提取出command的文件路径
        tmpstr:=tstringlist.Create;
        
        //获取参数
        try
          tmpstr.Delimiter:=' ';
          tmpstr.CommaText:=filename;
          filename:=tmpstr[0];
          if tmpstr.Count>1 then
          par:=copy(commandstr,pos(filename+' ',commandstr)+length(filename)+1,length(commandstr))
        finally
          tmpstr.Free;
        end;

        filepath:=ExtractFilePath(commandstr);//获取执行路径

        if ShellExecute(handle,nil,pchar(filename),pchar(par),
                            pchar(filepath),sw_shownormal)<32 then
          CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+'*rm: execute failed!')
        else
          CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(userinfo.UserID)+'*rm: execute success.');
        exit;
      end;

    end;


    if copy(s,0,4)='rm: ' then
      Getchatform(userinfo).addsysinfo(s)
    else
      Getchatform(userinfo).addinfo(s,1);
end;

procedure Tfclientui.showusermessage_error(s:string);
var
    userinfo:Tuserinfo;
    cmdstr:string;
begin
    //获取消息
    //s:=message_str;       
    //截取星号之前，逗号之后的数字（用户ID）
    cmdstr:=Copy(s,0,pos('*',s)-2);
    cmdstr:=Copy(cmdstr,pos(',',cmdstr)+1,length(cmdstr)-pos(',',cmdstr));
    s:=CatStringAfterStar(s);
    try
      userinfo:=getuserByID(strtoint(cmdstr));
    except
    end;
    if not assigned(userinfo) then exit;//如果用户不存在则不予理会;
    if copy(s,0,1)='/' then exit;//如果是命令提示符则退出
    Tchatform(Getchatform(userinfo)).addinfo(s,0);
end;


procedure Tfclientui.createGroupResp(tmpstr:string);
begin
  if tmpstr='F' then
  begin
    FCVNMSG.Label1.Caption:=RESINFO('GROUP_NAME_HAS_EXIST');
    FCVNMSG.Show;
    fcreategroup.GroupName.SetFocus;
    fcreategroup.bSure.Enabled:=true;
  end;
  if tmpstr='S' then
  begin
    FCVNMSG.Label1.Caption:=resinfo('GROUP_CREATE_SUCCESS');//'恭喜你，成功创建用户组';
    FCVNMSG.Show;
    //showmessage('恭喜你，成功创建用户组');
    fcreategroup.Close;
    CVN_SendCmdto(ProtocolToStr(cmdGetGroupInfo)+'*');  
  end;   
end;

procedure Tfclientui.bRegistClick(Sender: TObject);
begin
  fRegist.Show;
end;

procedure Tfclientui.bLogOutClick(Sender: TObject);
begin
 if messagedlg(resinfo('MSG_CLOSECVN'),Mtinformation,[mbyes,mbno],0) = mrYes then
 begin
    CVN_Logout;
    ShowUI_logout;
 end;
end;

procedure Tfclientui.N8Click(Sender: TObject);//踢出某用户
var tmpuser:puserinfo;
    tmpgroup:ppeergroupinfo;
begin
   tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
   tmpgroup:=ppeergroupinfo(maintree.GetNodeData(g_currentNode.Parent));
   if messagedlg(resinfo('ARE_YOU_SURE')+tmpgroup.GroupName+resinfo('KNOCK_OUT')+tmpuser.UserName+'?',Mtinformation,[mbyes,mbno],0) = mrYes then
   CVN_SendCmdto(inttostr(ord(cmdKickOut))+','+inttostr(tmpgroup.GroupID)+','+inttostr(tmpuser.userid)+'*');
end;

procedure Tfclientui.N18Click(Sender: TObject);
var tmpgroup:ppeergroupinfo;
begin
    tmpgroup:=ppeergroupinfo(maintree.GetNodeData(g_currentNode));
    FModifyGroup.GroupName.Text:=tmpgroup.GroupName;
    FModifyGroup.groupid:=tmpgroup.groupid;
    FModifyGroup.bSure.Enabled:=true;
    FModifyGroup.show;
end;

procedure Tfclientui.N16Click(Sender: TObject);
var tmpgroup:ppeergroupinfo;
begin
    tmpgroup:=ppeergroupinfo(maintree.GetNodeData(g_currentNode));
    if messagedlg(resinfo('MSG_DISMISS_GROUP')+tmpgroup.GroupName+'?',Mtinformation,[mbyes,mbno],0) = mrYes then
    begin
      CVN_SendCmdto(inttostr(ord(cmdQuitGroup))+','+inttostr(tmpgroup.GroupID)+'*');
    end;
end;

procedure Tfclientui.N111Click(Sender: TObject);
var tmpuser:puserinfo;
begin
  tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
  g_operationingUser:=tmpuser;
  CVN_SendCmdto(protocoltostr(cmdGetUserinfo)+','+inttostr(tmpuser.userid)+'*');
end;

procedure Tfclientui.N2Click(Sender: TObject);
var tmpuser:puserinfo;
begin
    tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
    if not assigned(tmpuser) then exit;
    //CVN_ConnectUser(tmpuser.UserID,tmpuser.AhthorPassword);
    tmpuser.TryConnect_start;
end;

procedure Tfclientui.N9Click(Sender: TObject);
var tmpuser:puserinfo;
begin
   tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
   //CVN_DisConnectUser(tmpuser.UserID);
   tmpuser.DissconnectPeer;
end;

procedure Tfclientui.N1Click(Sender: TObject);
var tmpuser:puserinfo;
begin
   tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
   if messagedlg(resinfo('DELETE_USER_SURE_TEXT')+tmpuser.UserName+'?',Mtinformation,[mbyes,mbno],0) = mrYes then
     CVN_SendCmdto(inttostr(ord(cmdDelFriend))+','+inttostr(tmpuser.userid)+'*');
end;

procedure Tfclientui.bAddFriendClick(Sender: TObject);
begin
//  CVN_testdissconnect;
  finduser.Show;
end;

procedure Tfclientui.bJoinGroupClick(Sender: TObject);
begin
  findgroup.ListView1.Clear;
  findgroup.panel2.Visible:=false;
  findGroup.Show;
end;

procedure Tfclientui.bCreateGroupClick(Sender: TObject);
begin
    fCreateGroup.GroupName.Text:='';
    fCreateGroup.GroupDesc.Text:='';
    fCreateGroup.bSure.Enabled:=true;
    fCreateGroup.show;
end;

procedure Tfclientui.bEditMyProfClick(Sender: TObject);
begin
   {if (g_AllowPass1<>'') or (g_AllowPass2<>'') or (g_AllowPass3<>'') or (g_AllowPass4<>'') then
      fPrivateSetup.CheckBox1.Checked:=true
   else
      fPrivateSetup.CheckBox1.Checked:=false; }
   fPrivateSetup.edit1.Text:=g_NickName; 
   fPrivateSetup.edit2.Text:=g_MyPass;
   fPrivateSetup.edit3.Text:=g_MyPass;
   fPrivateSetup.eDes.Text:=g_common;
   fPrivateSetup.allowPass1.Text := g_AllowPass1;
   fPrivateSetup.allowPass2.Text:= g_AllowPass2;
   fPrivateSetup.allowPass3.Text:= g_AllowPass3;
   fPrivateSetup.allowPass4.Text:= g_AllowPass4;

   fPrivateSetup.Label2.Caption:=eUserName.Text;
   fPrivateSetup.Show;
end;

procedure Tfclientui.Panel3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
      ReleaseCapture;
      Perform(WM_SYSCOMMAND,$f012,0);   
end;

procedure Tfclientui.redrawTree;
begin
  cleartree;
  rebuildtree;
end;

procedure Tfclientui.CoolTrayIcon1MinimizeToTray(Sender: TObject);
begin
  try
    fclientui.Hide;
    CoolTrayIcon1.HideMainForm;
  except
  end;

  //CoolTrayIcon1.ShowBalloonHint('Convnet','点击还原窗口',bitInfo,10);
end;

procedure Tfclientui.RzBmpButton1Click(Sender: TObject);
begin
  CoolTrayIcon1MinimizeToTray(sender);
end;

function Tfclientui.Getchatform(userinfo: Tuserinfo): tchatform;
var chatform:Tchatform;
    i:integer;
begin
   for i:=0 to g_ChatFormsList.Count-1 do
   begin
      if tchatform(g_ChatFormsList.Items[i]).User.UserID=userinfo.UserID then
      begin
          result:=g_ChatFormsList.Items[i];
          tchatform(g_ChatFormsList.Items[i]).Show;
          exit;
      end;
   end;

   chatform:=Tchatform.Create(self);
   chatform.user:=userinfo;
   g_ChatFormsList.Add(chatform);
   chatform.Show;
   result:=chatform;
end;

procedure Tfclientui.N12Click(Sender: TObject);
var tmpuser:puserinfo;
begin
    tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
    if not assigned(tmpuser) then exit;
    Getchatform(tmpuser^);
end;

procedure Tfclientui.RefreshNetStatus;
begin

  if g_HasUpnpTCPServer  then
    RzStatusPane2.Caption:=resinfo('TCP_DIRECT')+inttostr(CVN_getTCPc2cport)+resinfo('PORT')
  else
    RzStatusPane2.Caption:=resinfo('TCP_UPNP_FAIL');
  if g_HasUpnpUDPServer  then
    RzStatusPane1.Caption:=resinfo('UDP_DIRECT')+inttostr(CVN_getUDPc2cport)+resinfo('PORT')
  else
    RzStatusPane1.Caption:=resinfo('UDP_TYPE')+g_myNattype;
  if g_myNattype='UK' then
    RzStatusPane1.Caption:=resinfo('UDP_DISABLED');


    //更新界面显示
    RzGlyphStatus1.ImageIndex:=3;
    if g_MyNatType<>'UK' then RzGlyphStatus1.ImageIndex:=2;
    if g_HasUpnpUDPServer or g_HasUpnpTCPServer then RzGlyphStatus1.ImageIndex:=1;
    if g_HasUpnpUDPServer and g_HasUpnpTCPServer then RzGlyphStatus1.ImageIndex:=0;

    RzGlyphStatus1.Hint:=resinfo('LOCAL_NETWORK')+#10#13 +resinfo('IP_OUTSIDE')+g_MyPublicIP+#10#13;


    if (g_MyNatType='UK') and (not g_HasUpnpUDPServer) then
        RzGlyphStatus1.Hint:=RzGlyphStatus1.Hint+resinfo('UDP_DISABLED')+#10#13;
    if (g_MyNatType<>'UK') and (not g_HasUpnpUDPServer) then
        RzGlyphStatus1.Hint:=RzGlyphStatus1.Hint+resinfo('UDP_TYPE')+g_MyNatType+#10#13;

    if g_HasUpnpUDPServer then
        RzGlyphStatus1.Hint:=RzGlyphStatus1.Hint+'UDP_UPNP start at'+inttostr(CVN_getUDPc2cport)+resinfo('PORT')+#10#13;


    if g_HasUpnpTCPServer then
        RzGlyphStatus1.Hint:=RzGlyphStatus1.Hint+'TCP_UPNP start at'+inttostr(CVN_getTCPc2cport)+resinfo('PORT')
    else
        RzGlyphStatus1.Hint:=RzGlyphStatus1.Hint+'TCP_UPNP fail';

end;

procedure Tfclientui.needpass(tmpstr:string);
var
    tmpuser:Tuserinfo;
begin
 tmpuser:=getuserbyid(strtoint(tmpstr));
 if tmpuser<>nil then
 begin
     tmpuser.Con_RetryTime:=0;
     tmpuser.connecting:=false;
     fNeedPass.tmpuser:=tmpuser;
     fNeedPass.Label1.Caption:=tmpuser.UserName+resinfo('USER_NEED_AUTHORIZE_PASS_TEXT')+#10#13+resinfo('USER_NEED_AUTHORIZE_INPUT');
     fNeedPass.Show;
 end;
end;

procedure Tfclientui.FormCreate(Sender: TObject);
var inifile:tstringlist;

    stringlist:tstringlist;
    i:integer;
    LanguageName:string;

Const
     ENGLISH = (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH;
     CHINESE = (SUBLANG_CHINESE_SIMPLIFIED shl 10) or LANG_CHINESE;
     TCHINESE =(SUBLANG_CHINESE_TRADITIONAL SHL 10) OR LANG_CHINESE;
begin
  
  g_ChatFormsList:=TList.create;
  g_ResStrlist:=tstringlist.Create;

  
  //远程DOS命令用户列表
  rmoutecommandallowuserlist:=tstringlist.Create;

   If SysLocale.DefaultLCID=CHINESE then
     LanguageName:='chinese_s'
   else if SysLocale.DefaultLCID=TCHINESE then
     LanguageName:='chinese_s'
   else
     LanguageName:='english';

  try
    g_ResStrlist.LoadFromFile(ExtractFilePath(ParamStr(0))+LanguageName+'.lng');
  except
    if SysLocale.DefaultLCID=CHINESE then
      showmessage('语言文件丢失')
    else
      showmessage('Lost language file');
  end;

  for i:= 0 to g_ResStrlist.Count-1 do
  begin
     g_ResStrlist[i]:=utf8decode(g_ResStrlist[i]);
  end;

  //ShowUI_logout;
  //auAutoUpgrader1.CheckUpdate;
  g_Logintoservertime:=LOGIN_DELAY_TIME_SEC;
  
  stringlist:=tstringlist.Create;
  try
    if FileExists(ExtractFilePath(Application.ExeName) +'server.ini') then
    begin
      stringlist.LoadFromFile(ExtractFilePath(Application.ExeName) +'server.ini');

      ServerList.Clear;
      ServerList.Text:=resinfo('SERVER_LIST');
      
      for i:=0 to stringlist.Count-1 do
      begin
        if (i mod 3)=0 then
        begin
          ServerList.AddItemValue(utf8decode(stringlist[i]),utf8decode(stringlist[i+1]));
        end;
      end;
    end;
  finally
    stringlist.Free;
  end;

  loginPanel.Visible:=true;
  mainPanel.Visible:=false;
  loginPanel.Align:=alClient;
  width:=260;

  ServerIP:='';
  UserName:='';
  password:='';
  
  inifile:=tstringlist.Create;
  try
    if FileExists(ExtractFilePath(Application.ExeName) + 'ini\config.ini') then
    begin
      inifile.LoadFromFile(ExtractFilePath(Application.ExeName) +'ini\config.ini');
      try
        eServerIP.Text:=inifile.Values['ServerIP'];
        eUserName.Text:=inifile.Values['UserName'];
        ePassword.Text:=DecryptString(inifile.Values['Password']);
        checkAutoLogin.Checked:=strtobool(inifile.Values['AutoLogin']);
        //needvnc.Checked:=strtobool(inifile.Values['needvnc']);
        cCloseNTFW.Checked:=strtobool(inifile.Values['NeedFireWall']);
        globalport_TCP:=0;
        globalport_UDP:=0;
        globalport_TCP:=strtoint(inifile.Values['TCPPort']);//CONVNET的客户端服务端口从80开始尝试
        globalport_UDP:=strtoint(inifile.Values['UDPPort']);//CONVNET的客户端服务端口从80开始尝试
      except
      end;
    end;
  finally
    inifile.Free;
  end;



  Application.HintPause:=0;
  Application.HintHidePause:=20000;
  g_defaultgeteway:=getDefaultGateWay;
  if FileExists(ExtractFilePath(Application.ExeName) + 'ini\ui.ini') then
  begin
    inifile:= tstringlist.Create;
    try
      inifile.LoadFromFile(ExtractFilePath(Application.ExeName) +'ini\ui.ini');
      try
        top:=strtoint(inifile.Values['top']);
        left:=strtoint(inifile.Values['left']);
      except
      end;
    finally
      inifile.Free;
    end;
  end;


    initDll;
    

    while not CVN_InitEther do
    begin
      if MessageDlg(resinfo('MSG_NEEDETHER'),
        mtInformation,[mbYes,mbNo],0) = mryes  then
      begin
        installether;
      end
      else
        exit;
    end;
    
    g_MyMac:=CVN_GetEthermac;
    if g_MyMac='' then
    begin
      showmessage('Ether install error');
      close;
    end;

end;

procedure Tfclientui.refuiTimer(Sender: TObject);
  var i,j:integer;
begin
   //功能2、刷新用户界面
    if self.Visible=false then exit;
    labSend.Caption:=resinfo('SEND_TEXT')+formatInttoViewtext(CVN_CountSend);
    labRecv.Caption:=resinfo('RECV_TEXT')+formatInttoViewtext(CVN_CountRecive);
    j:=0;
    try
      if assigned(g_AllUserInfo) then
      for i:= 0 to g_AllUserInfo.Count-1 do
      begin
         if tuserinfo(g_AllUserInfo[i]).Connected and tuserinfo(g_AllUserInfo[i]).ISOnline then
         begin
          inc(j);
         end;
      end;

      inc(g_peerRetry);
      if g_peerRetry >4 then //12秒一次的客户端重连
      begin
        g_peerRetry :=0; //置空
        try
          //startautoconnection;
        except
        end;
      end;
    except
    end;

    labConnections.Caption:=resinfo('CONNUM_TEXT')+inttostr(j);
end;

procedure Tfclientui.showuserinfo(tmpstr:string);
begin
  fuserinfo.Label5.Caption:=tmpstr;
  fuserinfo.Edit1.Text:= g_operationingUser.UserName;
  fuserinfo.edit2.text:= GetCVNIPByUserID(g_operationingUser.UserID);
  fuserinfo.show;
end;

procedure Tfclientui.ShowUI_logout;
begin
  refui.Enabled:=false;
  bLogin.Enabled:=false;//可以开始登录
  disableUI_WhenLostConnection;
  loginPanel.Visible:=true;
  mainPanel.Visible:=false;
  loginPanel.Align:=alClient;
  checketherip.Enabled:=false;
end;

procedure Tfclientui.checketheripTimer(Sender: TObject);
var
  Size: ULONG;
  p: PMibIpAddrTable;
  i: integer;
  s:string;
  getmyip:boolean;
begin
    if g_userid=0 then exit;
    getmyip:=false;
    VVGetIpAddrTable(p, Size, True);
    if p <> nil then
     try
        for i := 0 to p^.dwNumEntries-1 do
        begin
          s:=IpAddressToString(p^.table[i].dwAddr);
          if (GetCVNIPByUserID(G_userid))=s then
              getmyip:=true;
          if (pos('10.110.',s)=1) and (s<>GetCVNIPByUserID(G_userid)) then
          begin
            fclientui.ShowUI_logout;
            FCVNMSG.Label1.Caption:=resinfo('CONFLICT_ETHERIP_TEXT');
            FCVNMSG.Show;
            {showmessage('您的网络中存在10.110网段的地址:'+s
                        +#10#13+'服务器分配给您的IP是'+GetCVNIPByUserID(G_userid)
                        +#10#13+'这将导致您无法正常使用ConVnet，请进行调整后重新登录'); }
          end;
        end;
        if not getmyip then
        begin
          //CVNMSG.Label1.Caption:=resinfo('DHCP_MESSAGE_ERROR');
          //CVNMSG.Show;
          {showmessage('非常抱歉，由于权限或者其他问题，您的CONVNET网卡自动设置IP地址失败，'+
                      #10#13+'请手动将CONVNET网卡的IP地址为：'+GetCVNIPByUserID(G_userid)+#10#13+'以确保通讯正常');}
        end;

    finally
      FreeMem(p);
    end;
end;

procedure Tfclientui.loadautoconntioninfo;
var s:tstringlist;
    i:integer;
    tmpitem:TListItem;
begin
  s:=tstringlist.Create;
  try
    if fileexists(ExtractFilePath(Application.ExeName)+'ini\profile_'+inttostr(G_Userid)+'.ini') then
    s.LoadFromFile(ExtractFilePath(Application.ExeName) + 'ini\profile_'+inttostr(G_Userid)+'.ini');
    fAutoconnection.ListView1.Items.Clear;
    for i:=0 to s.Count-1 do
    begin
      tmpitem:=fAutoconnection.ListView1.Items.Add;
      tmpitem.Caption:=s.Names[i];
      try
        tmpitem.SubItems.Add(decryptString(s.Values[s.Names[i]]));
      except
      end;
      //tmpitem.SubItems[0]:=decryptString(s.ValueFromIndex[i]);
    end;
  finally
    s.free;
  end;
end;

procedure Tfclientui.StartAutoConnection;
var i:integer;
    tmpuser:tuserinfo;
begin
  for i:=fAutoconnection.ListView1.Items.Count-1 downto 0 do
  begin
    try
      tmpuser:= getuserbyname(pchar(fAutoconnection.ListView1.Items[i].Caption));
      if tmpuser<>nil then
      begin
        tmpuser.AhthorPassword:=fAutoconnection.ListView1.Items[i].SubItems[0];
        if (not tmpuser.Connected) and tmpuser.ISOnline then
        begin
            tmpuser.TryConnect_start;
        end;
          //CVN_ConnectUser(tmpuser.UserID,tmpuser.AhthorPassword);
      end;
    except
    end;
  end;
end;

procedure Tfclientui.disableUI_WhenLostConnection;
begin
  try
    bLogin.Enabled:=true;//可以登录
    //五个按钮的状态改变
    bAddFriend.Enabled:=false;
    bJoinGroup.Enabled:=false;
    bCreateGroup.Enabled:=false;
    bSetautoconnection.Enabled:=false;
    bEditMyProf.Enabled:=false;
    //自动重连按钮

    //所有的窗体全部关闭
    fRegist.close;
    fAutoconnection.Close;
    addautouser.close;
    fcreategroup.close;
    findGroup.close;
    findUser.close;
    FCVNMSG.Close;
    FModifyGroup.close;
    fPrivateSetup.close;
    fMSGWIN.close;
    fPeerOrd.close;
    fNeedPass.close;
    fUserinfo.close;
  except
  end;
end;

procedure Tfclientui.CoolTrayIcon1Click(Sender: TObject);
begin
   CoolTrayIcon1.ShowMainForm;
end;

procedure Tfclientui.ping1Click(Sender: TObject); //ping
var tmpuser:puserinfo;
    tempstr:string;
begin
  tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
  g_operationingUser:=tmpuser;
  //CVN_SendCmdtoto(protocoltostr(cmdGetUserinfo)+','+inttostr(tmpuser.userid)+'*');
  tempstr:='ping '+GetCVNIPByUserID(tmpuser.userid)+' -t';
  WinExec(pchar(tempstr),SW_NORMAL);
end;

procedure Tfclientui.N3Click(Sender: TObject);//vnc connect
//var tmpuser:puserinfo;
  //  tempstr:string;
  var i:integer;
begin
{  tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
  g_operationingUser:=tmpuser;
  //CVN_SendCmdtoto(protocoltostr(cmdGetUserinfo)+','+inttostr(tmpuser.userid)+'*');
  tempstr:='"'+ExtractFilePath(Application.ExeName)+'\batapp\view.bat" '+GetCVNIPByUserID(tmpuser.userid);
  WinExec(pchar(tempstr),SW_HIDE);}
  if mainPanel.Visible=true then
    for i:=0 to g_AllUserInfo.Count-1 do
    begin
        if (not tuserinfo(g_AllUserInfo.Items[i]).Connected) and tuserinfo(g_AllUserInfo.Items[i]).ISOnline then
        begin
          tuserinfo(g_AllUserInfo.Items[i]).TryConnect_start;
        end;
    end;

end;

procedure Tfclientui.N4Click(Sender: TObject);
var tmpuser:puserinfo;
begin
  tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
  g_operationingUser:=tmpuser;
  //CVN_SendCmdtoto(protocoltostr(cmdGetUserinfo)+','+inttostr(tmpuser.userid)+'*');
  //tempstr:='"'+ExtractFilePath(Application.ExeName)+'\batapp\viewfile.bat" '+GetCVNIPByUserID(tmpuser.userid);
  //winexec(pchar('\\'+GetCVNIPByUserID(tmpuser.userid)),SW_shownormal)
  ShellExecute(handle,nil,pchar('\\'+GetCVNIPByUserID(tmpuser.userid)),'','',SW_shownormal);
end;

procedure Tfclientui.N5Click(Sender: TObject);
var tmpuser:puserinfo;
    tempstr:string;
begin
//  showmessage('由于本软件和Windows API冲突所造成的限制，'+#10#13+'您将无法使用Windows系统下正在运行Convnet的用户账号登录');
  tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
  g_operationingUser:=tmpuser;
  tempstr:='mstsc /v:'+GetCVNIPByUserID(tmpuser.userid);
  WinExec(pchar(tempstr),SW_NORMAL);
end;

procedure Tfclientui.bquitClick(Sender: TObject);
begin
  if assigned(g_UserStruct) then
  begin
      if g_UserStruct.Count=0 then
      begin
        close;
        exit;
      end;
  end;
   
 if messagedlg(resinfo('MSG_CLOSECVN'),Mtinformation,[mbyes,mbno],0) = mrYes then
 begin
    close;
 end;
end;

procedure Tfclientui.onDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var  addonspath:string;

  Newbmp:TBitmap;
  s:string;
begin
  addonspath:=ExtractFilePath(Application.ExeName)+'add-ons\';

  
  // set the background color and draw it
  if Selected then
    ACanvas.Brush.Color := clHighlight
  else
    ACanvas.Brush.Color := clMenu;
  
   if Selected then
    ACanvas.Pen.Style := psSolid
   else
    ACanvas.Pen.Style := psClear;
  ACanvas.FillRect (ARect);
  // show the color
  
  InflateRect (ARect, -5, -5);

    
  if fileexists(addonspath+TMenuItem(sender).Name+'\icon.bmp') then
    begin
      Newbmp:=TBitmap.Create;
      try
        Newbmp.LoadFromFile(addonspath+TMenuItem(sender).Name+'\icon.bmp');

        Newbmp.Transparent:=true;
        Newbmp.TransparentColor:=clDefault;

        ACanvas.Draw(ARect.Left,ARect.Top,Newbmp);
      finally
        newbmp.Free;
      end;
    end;
  s:=TMenuItem(sender).Caption;
  s:=replacestr(s,'&','');
  ACanvas.TextOut(ARect.Left+25,ARect.Top+3,s);
  // Change the canvas brush color.
end;



procedure Tfclientui.PopupMenu1Popup(Sender: TObject);
var
    addonspath:string;
    sch:TSearchrec;
    inifile:tstringlist;
    loadtype:string;

    menu:TMenuItem;
begin
  addonspath:=ExtractFilePath(Application.ExeName);
  addonspath:=addonspath+'add-ons\';
  if PopupMenu1.Items.Count>4 then
  begin
    repeat
      PopupMenu1.Items.Items[0].Free;

    until PopupMenu1.Items.Count=4;
  end;

  if DirectoryExists(addonspath) then
  begin
      if FindFirst(addonspath + '*', faDirectory, sch) = 0 then
      begin
          repeat
             if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
             if DirectoryExists(addonspath+sch.Name) then
             begin
               if fileexists(addonspath+sch.Name+'\load.ini') then
               begin
                  inifile:=tstringlist.Create;
                  try
                    inifile.LoadFromFile(addonspath+sch.Name+'\load.ini');
                    loadtype:=inifile.Values['loadtype'];
                    if loadtype='1' then
                    begin
                      menu:=TMenuItem.Create(nil);
                      try
                        menu.Name:=sch.Name;
                      except
                        exit;
                      end;
                      try
                        menu.Caption:=inifile.Values['MenuName'];
                        menu.ImageIndex:=8;
                        menu.OnMeasureItem:=OnMeasureItem;
                        menu.OnDrawItem:=ondrawitem;
                        menu.OnClick:=CustomClick;
                        PopupMenu1.Items.Insert(0,menu);
                      finally
                      end;
                    end;
                  finally
                    inifile.Free;
                  end;
               end;
             end;
          until FindNext(sch) <> 0;
          SysUtils.FindClose(sch);
      end;
  end;
end;

procedure Tfclientui.CustomClick(Sender: TObject);
var inifile:tstringlist;
    addonspath:string;
    command,parms:string;
    resultinfo:cardinal;
begin
  addonspath:=ExtractFilePath(Application.ExeName);
  addonspath:=addonspath+'add-ons\'+tbutton(sender).Name+'\';
  inifile:=tstringlist.Create;
  try
     if fileexists(addonspath+'load.ini') then
     begin
       inifile.LoadFromFile(addonspath+'load.ini');

       //todo
        try
         parms:=inifile.Values['parms'];
         parms:=StringReplace(parms,'$myip',getcvnipbyuserid(g_Userid), [rfReplaceAll]);
         parms:=StringReplace(parms,'$serverurl',serverHost, [rfReplaceAll]);
         parms:=StringReplace(parms,'$mymac',g_MyMac, [rfReplaceAll]);
         parms:=StringReplace(parms,'$mynickname',g_NickName, [rfReplaceAll]);

         command:=inifile.Values['command'];
         command:=StringReplace(command,'$myip',getcvnipbyuserid(g_Userid), [rfReplaceAll]);
         command:=StringReplace(command,'$serverurl',serverHost, [rfReplaceAll]);
         command:=StringReplace(command,'$mymac',g_MyMac, [rfReplaceAll]);
         command:=StringReplace(command,'$mynickname',g_NickName, [rfReplaceAll]);

         resultinfo:=//WinExec(pchar(addonspath+tbutton(sender).Name+'\'+command),SW_NORMAL);
         ShellExecute(handle,nil,pchar(addonspath+command),pchar(parms),
                            pchar(addonspath),sw_shownormal);
                      //shellExecute(handle,nil,pchar(addonspath+tbutton(sender).Name+'\'+command),'',pchar(addonspath+tbutton(sender).Name+'\'),sw_shownormal);
         if resultinfo<32 then
            resultinfo:=ShellExecute(handle,nil,pchar(command),pchar(parms),
                            nil,sw_shownormal);
         if resultinfo<32 then
            showmessage(resinfo('EXECUTE_FAIL_TEXT'));
        except
        end;
       //showmessage(inifile.Values['command']);
     end;
  finally
  end;


end;

procedure Tfclientui.UserpopupPopup(Sender: TObject);
var 
    addonspath:string;
    sch:TSearchrec;
    inifile:tstringlist;
    loadtype:string;
    menu:TMenuItem;
    tmpgroup:pPeerGroupInfo;
begin

  if assigned(g_currentNode) then
  begin
    tmpgroup:=pPeerGroupInfo(maintree.GetNodeData(g_currentNode.Parent));
   // if (tmpgroup.GroupName='FH战队') or (tmpgroup.GroupName='公司内网') or (tmpgroup.GroupName='ygo星火') then
        N19.Visible:=true
    {else
        N19.Visible:=false; }
  end;

  addonspath:=ExtractFilePath(Application.ExeName);
  addonspath:=addonspath+'add-ons\';
  if Userpopup.Items.Count>13 then
  begin
    repeat
      Userpopup.Items.Items[13].Free;
//      Userpopup.Items.Delete(13);
    until Userpopup.Items.Count=13;
  end;

  if DirectoryExists(addonspath) then
  begin
      if FindFirst(addonspath + '*', faDirectory, sch) = 0 then
      begin
          repeat
             if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
             if DirectoryExists(addonspath+sch.Name) then
             begin
               if fileexists(addonspath+sch.Name+'\load.ini') then
               begin
                  inifile:=tstringlist.Create;
                  try
                    inifile.LoadFromFile(addonspath+sch.Name+'\load.ini');
                    
                    loadtype:=inifile.Values['loadtype'];
                    if loadtype='0' then
                    begin
                      menu:=TMenuItem.Create(nil);
                      try
                        menu.Caption:=inifile.Values['MenuName'];
                      
                        if fileexists(addonspath+sch.Name+'\icon.bmp') then
                          menu.Bitmap.LoadFromFile(addonspath+sch.Name+'\icon.bmp')
                        else
                          menu.ImageIndex:=15;

                        try
                          menu.Name:=sch.Name;
                          menu.OnClick:=CustomClick2;
                          menu.OnDrawItem:=OnDrawItem;
                          menu.OnMeasureItem:=OnMeasureItem;
                          Userpopup.Items.Insert(13,menu);
                        except
                          menu.Free;
                        end;
                      finally
                      end;
                    end;
                  finally
                    inifile.Free;
                  end;
               end;
             end;
          until FindNext(sch) <> 0;
          SysUtils.FindClose(sch);
      end;
  end;
end;

procedure Tfclientui.maintreeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var HitInfo:tHitInfo;
      Userinfo:Puserinfo;
begin
  maintree.GetHitTestInfoAt(X,Y,true,HitInfo);

  if assigned(HitInfo.HitNode) then
  case maintree.GetNodeLevel(HitInfo.HitNode) of
    0:
    begin
      //右键点击组，或者左键点击组管理的按钮
      if (Button=mbRight) or (hitinfo.HitColumn=2) then
      begin
        if (pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode)).GroupID>0)
          and (pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode)).Creator<>g_userid) then
             Grouppopup.Popup(mouse.CursorPos.X,mouse.CursorPos.Y);
        if (pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode)).GroupID>0)
          and (pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode)).Creator=g_userid) then
             Groupdelete.Popup(mouse.CursorPos.X,mouse.CursorPos.Y);
        exit;
      end;
      if Button=mbLeft then
      begin
        if X<18 then exit;//点在LOGO前面就不响应了
        maintree.Expanded[hitinfo.hitnode]:=not maintree.Expanded[hitinfo.hitnode];
      end;
    end;
    1:
    begin
      Userinfo:=maintree.GetNodeData(HitInfo.HitNode);
      //右键点击的事件
      if Button=mbRight then
      begin
        //右键点在好友用户组上
        //if not g_Connected then exit;
       
        N1.Visible:=true;
        N1.Caption:=resinfo('DELETE_FRIEND_TEXT');
        N1.OnClick:=N1Click;

        //右键点在可管理的用户组的用户上,隐藏“删除用户的选项”
        N1.Visible:=pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode.Parent)).GroupID=0;
        
        if (pPeerGroupInfo(maintree.GetNodeData(HitInfo.HitNode.Parent)).Creator=G_userid) then
        begin
           N1.Visible:=true;
           N1.Caption:=resinfo('DROP_GROUP_USER');
           N1.OnClick:=N8Click;
        end;
        Userpopup.Popup(mouse.CursorPos.X,mouse.CursorPos.Y);
      end;

      //左键点击的事件
      if button=mbleft then
      begin

        if hitinfo.HitColumn=1 then//点击聊天按钮
        begin
          if not assigned(userinfo) then exit;//如果用户不存在则不予理会;
          if not Userinfo.ISOnline then exit;//如果用户不在线则不予理会;
          //请求主窗体创建(打开)聊天窗口
          getchatform(userinfo^);
        end;

        if hitinfo.HitColumn=2 then//点击连接按钮
        begin
          if not userinfo^.Connected then
            userinfo^.TryConnect_start
          else
          begin         
            { if userinfo.SenderrorCount>0 then
                userinfo.TryConnect_start
             else     }
                userinfo^.DissconnectPeer;
          end;
            //CVN_ConnectUser(userinfo.UserID,userinfo.AhthorPassword)
        end;
      end;//if button
    end;//1
  end;//case
end;

procedure Tfclientui.CustomClick2(Sender: TObject);
var inifile:tstringlist;
    addonspath:string;
    dataUser:puserinfo;
    command,parms:string;
    resultinfo:cardinal;
    p:pchar;
begin
  addonspath:=ExtractFilePath(Application.ExeName);
  addonspath:=addonspath+'add-ons\'+tbutton(sender).Name+'\';
  inifile:=tstringlist.Create;
  try
     if fileexists(addonspath+'load.ini') then
     begin
       inifile.LoadFromFile(addonspath+'load.ini');
       if g_currentNode<>nil then
       begin
        try
         dataUser:=maintree.GetNodeData(g_currentNode);
         if dataUser.UserID=0 then exit;
//todo
         parms:=inifile.Values['parms'];
         parms:=StringReplace(parms,'$userid',inttostr(datauser.userid) , [rfReplaceAll]);
         parms:=StringReplace(parms,'$userip',getcvnipbyuserid(datauser.userid) , [rfReplaceAll]);
         parms:=StringReplace(parms,'$username',datauser.UserName, [rfReplaceAll]);
         parms:=StringReplace(parms,'$myip',getcvnipbyuserid(g_Userid), [rfReplaceAll]);
         parms:=StringReplace(parms,'$serverurl',serverHost, [rfReplaceAll]);
         parms:=StringReplace(parms,'$serverip',serverip, [rfReplaceAll]);
         parms:=StringReplace(parms,'$mymac',g_MyMac, [rfReplaceAll]);
         parms:=StringReplace(parms,'$mynickname',g_NickName, [rfReplaceAll]);
         parms:=StringReplace(parms,'$usercontype',inttostr(ord(datauser.Con_ConnectionType)), [rfReplaceAll]);
         parms:=StringReplace(parms,'$userconip',datauser.Con_IP, [rfReplaceAll]);
         parms:=StringReplace(parms,'$defaultgetway',g_defaultgeteway, [rfReplaceAll]);


         parms:=StringReplace(parms,'$ethername',CVN_GetEtherName(), [rfReplaceAll]);
       



         command:=inifile.Values['command'];
         command:=StringReplace(command,'$userid',inttostr(datauser.userid) , [rfReplaceAll]);
         command:=StringReplace(command,'$userip',getcvnipbyuserid(datauser.userid) , [rfReplaceAll]);
         command:=StringReplace(command,'$username',datauser.UserName, [rfReplaceAll]);
         command:=StringReplace(command,'$myip',getcvnipbyuserid(g_Userid), [rfReplaceAll]);
         command:=StringReplace(command,'$serverurl',serverHost, [rfReplaceAll]);
         command:=StringReplace(command,'$serverip',serverip, [rfReplaceAll]);
         command:=StringReplace(command,'$mymac',g_MyMac, [rfReplaceAll]);
         command:=StringReplace(command,'$mynickname',g_NickName, [rfReplaceAll]);
         command:=StringReplace(command,'$usercontype',inttostr(ord(datauser.Con_ConnectionType)), [rfReplaceAll]);
         command:=StringReplace(command,'$userconip',datauser.Con_IP, [rfReplaceAll]);
         command:=StringReplace(command,'$defaultgetway',g_defaultgeteway, [rfReplaceAll]);


         command:=StringReplace(command,'$ethername',CVN_GetEtherName(), [rfReplaceAll]);
        

         resultinfo:=//WinExec(pchar(addonspath+tbutton(sender).Name+'\'+command),SW_NORMAL);
         ShellExecute(handle,nil,pchar(addonspath+command),pchar(parms),
                            pchar(addonspath),sw_shownormal);
                      //shellExecute(handle,nil,pchar(addonspath+tbutton(sender).Name+'\'+command),'',pchar(addonspath+tbutton(sender).Name+'\'),sw_shownormal);
         if resultinfo<32 then
            resultinfo:=ShellExecute(handle,nil,pchar(command),pchar(parms),
                            nil,sw_shownormal);
         if resultinfo<32 then
            showmessage(resinfo('EXECUTE_FAIL_TEXT'));
        except
        end;
       end;
       //showmessage(inifile.Values['command']);
     end;
  finally
  end;

end;

procedure Tfclientui.onMeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
   width:=150;
   height:=24;
end;

procedure Tfclientui.maintreeColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
    if sender.GetNodeLevel(g_currentNode)= 1 then
    begin
       getchatform(Puserinfo(sender.GetNodeData(g_currentNode))^);
    end;
end;

procedure Tfclientui.WMTIMER(var msg: TWMTimer);
var tmpuser:tuserinfo;
begin
  inherited;
  if msg.TimerID >10000 then
  begin
    tmpuser:=getuserbyid(msg.TimerID-10000);
    if tmpuser<>nil then
    with tmpuser do
    begin
        if connecting then//正在尝试连接
         begin
            if Connected then
            begin
               connecting:=false;
               Con_RetryTime:=0;
            end;

            if Con_RetryTime>6 then
            begin
               connecting:=false;
               Con_RetryTime:=0;
            end;

            if AhthorPassword='' then
              CVN_SendCmdto(ProtocolToStr(cmdCalltoUser)+','+ inttostr(userid) +','+ inttostr(Con_RetryTime) +'*')
            else
              CVN_SendCmdto(ProtocolToStr(cmdCalltoUser)+','+ inttostr(userid) +','+ inttostr(Con_RetryTime) +','+AhthorPassword+'*');
            //发送到TRY,下面交到packageparser 的 ord(cmdCalltoUserResp)事件
            inc(Con_RetryTime);
         end
         else
            killtimer(handle,tmpuser.tvUserReconn);//关闭定时器
     end;
  end;
end;

procedure Tfclientui.dasd1Click(Sender: TObject);
begin
  close;
end;

procedure Tfclientui.bSetnetworkClick(Sender: TObject);
begin
  FrmMain.Show;
end;

procedure Tfclientui.FormShow(Sender: TObject);
begin

  if fclientui.Left<0 then
    fclientui.Left:=0;
  if fclientui.Top<0 then
    fclientui.Top:=0;
    
  if fclientui.Left>screen.Width-self.Width-3 then
    fclientui.Left:=screen.Width-self.Width-3;
  if fclientui.Top>screen.Height-100 then
    fclientui.Top:=10;

  
end;

procedure Tfclientui.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var inifile:tstringlist;
begin

   CanClose:=true;
   ShowUI_logout;

   try
     CVN_Logout;
     CVN_freeres;
   except
   end;
   
    inifile:=tstringlist.Create;
    try
      inifile.Add('top='+inttostr(top));
      inifile.Add('left='+inttostr(left));
      try
        inifile.SaveToFile(ExtractFilePath(Application.ExeName)+'ini\ui.ini');
      except
      end;
    finally
      inifile.Free;
    end;

   rmoutecommandallowuserlist.Free;
   g_ChatFormsList.Free;
   g_ResStrlist.Free;


end;

procedure Tfclientui.bSetautoconnectionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var i:integer;
begin
 if Button=mbLeft then
 begin
    fAutoconnection.show;
 end
 else
 begin
    for i:=0 to g_AllUserInfo.Count-1 do
    begin
      if (tuserinfo(g_AllUserInfo.Items[i]).ISOnline) and (not tuserinfo(g_AllUserInfo.Items[i]).Connected) then
      begin
        tuserinfo(g_AllUserInfo.Items[i]).TryConnect_start;
      end
      else//如果有发送错误的连接，则也尝试重连
      begin
        if (tuserinfo(g_AllUserInfo.Items[i]).ISOnline) and (tuserinfo(g_AllUserInfo.Items[i]).SenderrorCount>0) then
          tuserinfo(g_AllUserInfo.Items[i]).TryConnect_start;
      end;
    end;
 end;

end;

procedure Tfclientui.N19Click(Sender: TObject);
var tmpuser:puserinfo;
begin
    tmpuser:=puserinfo(maintree.GetNodeData(g_currentNode));
    if not assigned(tmpuser) then exit;
    //CVN_ConnectUser(tmpuser.UserID,tmpuser.AhthorPassword);
    tmpuser.TryTransfConnect_start;
end;


procedure GetCVNmessage(messagetype:integer;messagestring:string);
var
    s:widestring;
begin
   s:=ToWideString(GetACP,messagestring);
   if assigned(fclientui.comEvents) then
   begin
     g_ComMessage:=s;
     g_ComMessageType:= messagetype;
     TIdSync.SynchronizeMethod(fclientui.Commessage); //子线程无法触发COM事件，要同步到进程
     //fclientui.comEvents.OnCVNMessage(s,messagetype)
   end;

   sendmessage(fclientui.Handle,CVN_MESSAGE_ALL,integer(@messagestring),messagetype);
end;

procedure Tfclientui.WMCVN_Message(var AMsg: TMessage);
var tmpstr:string;
    strlist:tstringlist;
    auAutoUpgrader:TauAutoUpgrader;
    i:integer;
    mmessagestring:string;
    messagetype:integer;
begin
  mmessagestring:=string(Pointer(AMsg.wParam)^);
  messagetype:=AMsg.LParam;

  case messagetype of
     1900:
      begin
          fclientui.labInfomation.Caption:=resinfo('CANT_CONNECT_TO_SERVER_TEXT');
          bLogin.Enabled:=true;
      end;
     1000://服务器断线
          fclientui.disableUI_WhenLostConnection;
     1002://用户连接成功
          fclientui.Sortuserlist;

     1003://用户连接断开
          fclientui.Sortuserlist;

     1033://用户连接断开
          fclientui.Sortuserlist;

     1004://连接断开
          fclientui.disableUI_WhenLostConnection;
         
     1005://退出登录结束
        begin
           fclientui.myserverInfo.Caption:='';

           for i:=g_ChatFormsList.Count-1 downto 0 do
           begin
              tchatform(g_ChatFormsList.Items[i]).Free;
              g_ChatFormsList.Delete(i);
              g_ChatFormsList.Pack;
           end;
           fclientui.disableUI_WhenLostConnection;
           fclientui.ShowUI_logout;
           //fclientui.labInfomation.Caption:=resinfo('LOGIN_OUT_TEXT');
           fclientui.bLogin.Enabled:=true;
        end;
        
     1006://退出登录开始
        begin
           fclientui.maintree.RootNodeCount:=0;
           fclientui.disableUI_WhenLostConnection;
        end;
     1007://用户重连尝试
        begin
          fclientui.Sortuserlist;
        end;
     1008://断线重连成功
        begin
           fclientui.showUI_Logined;
        end;
     1009://成功登录
        begin//初始化用户信息等数据

           fclientui.bLogin.Enabled:=false;//不可以登录
           strlist:=tstringlist.Create;
           try
             strlist.DelimitedText:=',';
             strlist.CommaText:=mmessagestring;
             g_MyPublicIP:=strlist[2];
             g_userid:=strtoint(strlist[3]);
             g_NickName:=strlist[4];
             g_userName:=strlist[5];
             g_MyPass:=strlist[6];
             if g_MyPass='' then
               g_MyPass:= 'NOTMODIFYED';
             g_common:=strlist[7];
             if strlist.Count>9 then
             begin
               g_AllowPass1:=strlist[8];g_AllowPass2:=strlist[9];g_AllowPass3:=strlist[10];g_AllowPass4:=strlist[11];
             end;
           finally
            strlist.Free;
           end;
           fclientui.labInfomation.Caption:=resinfo('LOGIN_SUCCESS');
        end;
     1010://网络类型确定
     begin

         strlist:=tstringlist.Create;
         try
           strlist.DelimitedText:=',';
           strlist.CommaText:=mmessagestring;
           g_MyNatType:=strlist[0];
           g_HasUpnpUDPServer:=strtobool(strlist[1]);
           g_HasUpnpTCPServer:=strtobool(strlist[2]);
         finally
          strlist.Free;
         end;

        fclientui.labInfomation.Caption:=resinfo('CONFIM_NETWORK_TYPE');
        fclientui.RefreshNetStatus;
     end;
     
     1011://网络检查开始
        begin
          fclientui.labInfomation.Caption:=resinfo('CHECK_NETWORK');
        end;

     1012://网络检查结束
        begin
          fclientui.labInfomation.Caption:=resinfo('CHECK_NETWORK_FINISH');
          fclientui.showUI_Logined;
        end;

     1111://网卡未安装
        fclientui.labInfomation.Caption:=resinfo('ETHER_NOT_FOUND');

     1113:
     begin
        fclientui.labInfomation.Caption:=mmessagestring;
     end;
     
     1116:
     begin
       strlist:=tstringlist.Create;
       try

         strlist.DelimitedText:=',';
         strlist.CommaText:=mmessagestring;
         if strlist.Count<3 then
         begin
            showmessage('客户端与服务器版本不匹配，请确认通讯版本');
            exit;
         end;
         auAutoUpgrader:=tauAutoUpgrader.Create(self);
         auAutoUpgrader.InfoFileURL:=strlist[2];
         auAutoUpgrader.VersionControl:=byNumber;
         auAutoUpgrader.VersionNumber:=label1.Caption;
         auAutoUpgrader.CheckUpdate;
       finally
         strlist.Free;
       end;

     end;

     1222://arp信息
     begin
        winexec(pchar(mmessagestring),sw_hide);
        sleep(10);
     end;

     ord(cmdOffLinetellResp):
        fclientui.Sortuserlist;
        
     ord(cmdLoginresp):
     begin
         if mmessagestring='login fail' then
         begin
            fclientui.labInfomation.Caption:=resinfo('LOGINFAIL_PASSERROR');
            exit;
         end;

          if mmessagestring='knockout ban' then
         begin
           fclientui.ShowUI_logout;
           fclientui.labInfomation.Caption:=resinfo('LOGINFAIL_RELOGIN_BAN');
           checkAutoLogin.Checked:=false;
         end;

        if mmessagestring='server refuse login' then
         begin
           fclientui.ShowUI_logout;
           fclientui.labInfomation.Caption:=resinfo('LOGINFAIL_SERVER_BAN');
           checkAutoLogin.Checked:=false;
         end;

     end;

     ord(cmdGetGroupInfoResp)://用户组更新信息
        begin
           fclientui.maintree.RootNodeCount:=0;

           g_UserStruct:=CVN_GetUserList;
           g_AllUserInfo:=CVN_AllUserInfo;

           fclientui.maintree.RootNodeCount:=g_UserStruct.Count;

           fclientui.Sortuserlist;
           fclientui.StartAutoConnection;
        end;
        
     ord(cmdCreateGroupResp):
        begin
            tmpstr:=mmessagestring;
            if tmpstr='F' then
            begin
              FCVNMSG.Label1.Caption:=resinfo('GROUP_NAME_HAS_EXIST');
              FCVNMSG.Show;
              fcreategroup.GroupName.SetFocus;
              fcreategroup.bSure.Enabled:=true;
            end;
            if tmpstr='S' then
            begin
              FCVNMSG.Label1.Caption:=resinfo('GROUP_CREATE_SUCCESS');
              FCVNMSG.Show;
              fcreategroup.Close;
            end;
            if tmpstr='N' then
            begin
              FCVNMSG.Label1.Caption:=resinfo('GROUP_CREATE_NOPOM');
              FCVNMSG.Show;
              fcreategroup.Close;
            end;

            fclientui.Sortuserlist;
        end;
        
      ord(cmdFindUserResp):
      begin
         //message_str:=mmessagestring;



         finduser.Cvn_FindResult(mmessagestring);

      end;
      
      ord(cmdFindGroupResp):
      begin
         // message_str:=mmessagestring;
          findGroup.findgroupview(mmessagestring);
      end;

      ord(cmdServerSendToClient):
      begin
          FCVNMSG.Label1.Caption:=RESINFO('SERVERMSG')+mmessagestring;
          FCVNMSG.Show;
      end;

      ord (cmdGetUserinfoResp):
       begin

          tmpstr:=mmessagestring;//copy(mmessagestring,0,length(mmessagestring));//去除PCHAR的填充
          tmpstr:=CatStringAfterStar(tmpstr);//截取有用的部分（*号之后的部分）
         // message_str:= tmpstr;
          fclientui.showuserinfo(tmpstr);
       end;

       //用户申请加为好友的信息
       ord(cmdPeerOrdFriendResp):
       begin
         //message_str:=mmessagestring;
         fMsgwin.CVN_OrdPeer(mmessagestring);
         //sendMessage(fMsgwin.Handle,CVN_OrdPeer,Integer(@cmdstr),0);
       end;

       //组备注的返回信息，刷新组的备注信息
       ord(cmdGetGroupDescresp):
       begin
          //g_createGroupResp:=mmessagestring;
          FModifyGroup.renewGroupinfo(mmessagestring);
          //sendMessage(FModifyGroup.Handle,CVN_groupDescReturn,Integer(@cmdstr),0);
       end;

       //好友确认通知
       ord(cmdPeerSureFriendResp):
       begin
           fclientui.maintree.RootNodeCount:=0;
           if not assigned(g_UserStruct) then
           begin
                g_UserStruct:=CVN_GetUserList;
                g_AllUserInfo:=CVN_AllUserInfo;
           end;
           fclientui.maintree.RootNodeCount:=g_UserStruct.Count;
           fclientui.Sortuserlist;
       end;
       
       //修改组返回  刷新组
       ord(cmdmodifyGroupresp):
       begin
          if mmessagestring='F' then
          begin
            FModifyGroup.grouphasexist;
            exit;
          end;
          FCVNMSG.Label1.Caption:=resinfo('GROUP_NAME_MODIFY_SUCCESS');
          FCVNMSG.Show;
       end;

       ord(cmdUserNeedPass):
       begin
           fclientui.needpass(mmessagestring);
       end;

       ord (cmdRenewMYinforesp):
       begin
          fclientui.showrenewmyinfosucc;
       end;


       ord (cmdOnlinetellResp):
       begin
         fclientui.Sortuserlist;
         fclientui.StartAutoConnection;
       end;
       
       ord(cmdSendMsgtoIDResp):
       begin
         //message_str:=mmessagestring;//去除PCHAR的填充
         //g_chatmessage:=CatStringAfterStar(cmdstr);//截取有用的部分（*号之后的部分）
         fclientui.showusermessage(mmessagestring);//通知主线程查看消息
       end;
       //信息不可到达
       ord(cmdMsgcantarrive):
       begin
         //信息未到达，请求主窗口创建（打开）窗体显示
         //message_str:=mmessagestring;//截取有用的部分（*号之后的部分）
         fclientui.showusermessage_error(mmessagestring);//通知主线程查看消息
       end;
       ord(cmdRegistUserresp):
       begin
          if 'regist notallow'= mmessagestring then
             fRegist.registnotacc;
          if 'regist success'= mmessagestring then
             fRegist.registsuc;
          if 'regist fail' = mmessagestring then
             fRegist.registfial;
       end;

       ord(cmdjoingroupresp):
       begin
          //message_str:=mmessagestring;
          findGroup.userjoingroup(mmessagestring);
       end;

       ord (cmdPeerSureJoinGroupresp):
           CVN_SendCmdto(ProtocolToStr(cmdGetGroupInfo)+'*');

       ord (cmdGetFriendInfoResp):
       begin
           fclientui.maintree.RootNodeCount:=0;
           if not assigned(g_UserStruct) then
           begin
                g_UserStruct:=CVN_GetUserList;
                g_AllUserInfo:=CVN_AllUserInfo;
           end;
           fclientui.maintree.RootNodeCount:=g_UserStruct.Count;
           fclientui.Sortuserlist;
       end;
   end;   
end;

procedure Tfclientui.N11Click(Sender: TObject);
var tmpgroup:ppeergroupinfo;
begin
    tmpgroup:=ppeergroupinfo(maintree.GetNodeData(g_currentNode));
    if messagedlg(resinfo('QUIT_SURE')+tmpgroup.GroupName+'？',Mtinformation,[mbyes,mbno],0) = mrYes then
    begin
      CVN_SendCmdto(inttostr(ord(cmdQuitGroup))+','+inttostr(tmpgroup.GroupID)+'*');
    end;
end;

procedure Tfclientui.Timer1Timer(Sender: TObject);
begin
  if checkAutoLogin.Checked and bLogin.Enabled then
  begin
     dec(g_Logintoservertime);
     checkAutoLogin.Caption:=resinfo('RELOGIN_TIME_TEXT')+inttostr( g_Logintoservertime);
     if g_Logintoservertime=0 then
     begin
        g_Logintoservertime:=LOGIN_DELAY_TIME_SEC;
        bLogin.Click;
        //bLoginClick(nil);
        //CVN_Login(pchar(eServerIP.Text),pchar(eUserName.Text),pchar(ePassword.Text));
     end;
  end;
end;

procedure Tfclientui.checkAutoLoginClick(Sender: TObject);
begin
   g_Logintoservertime:=LOGIN_DELAY_TIME_SEC;
end;

procedure Tfclientui.ServerListChange(Sender: TObject);
begin
  eServerIP.Text:=ServerList.Values[Serverlist.Items.IndexOf(serverlist.Text)];
end;

procedure Tfclientui.installether;
var     roomprocess:TProcessInformation;//exe进程信息
  startupInfo :TStartupInfo;
begin

         FillChar(startupInfo,sizeof(StartupInfo),0);
         outputdebugstring(pchar('"'+ExtractFilePath(Application.ExeName)+'tapDriver.exe"'));
          if CreateProcess(Nil,pchar('"'+ExtractFilePath(Application.ExeName)+'tapDriver.exe"'),
                  nil,
                  nil,
                  true,0,Nil,
                  pchar(ExtractFilePath(Application.ExeName)),
                  startupInfo,roomprocess) then
          begin
            WaitForSingleObject(roomprocess.hProcess,INFINITE);
          end;
end;



procedure Tfclientui.WndProc(var nMsg: Tmessage);
begin
  inherited;

end;

procedure Tfclientui.Commessage;
begin

  fclientui.comEvents.OnCVNMessage(g_ComMessage,g_ComMessageType);
end;

procedure Tfclientui.RzBitBtn1Click(Sender: TObject);
var stringlist:tstringlist;
    i,index:integer;
begin

  for i:= 0 to serverlist.Count-1 do
  begin
      if (ServerList.Values[i]=eserverip.Text) then
      begin
        index:=i;
        break;
      end;

  end;


  if (index<0) then exit;
  stringlist:=tstringlist.Create;
  try
    if FileExists(ExtractFilePath(Application.ExeName) +'server.ini') then
    begin
      stringlist.LoadFromFile(ExtractFilePath(Application.ExeName) +'server.ini');
      ShellExecute(Handle,'open',pchar(stringlist[index*3+2]),'','',SW_SHOWNORMAL);

    end;
  finally
    stringlist.Free;
  end;

end;

end.

