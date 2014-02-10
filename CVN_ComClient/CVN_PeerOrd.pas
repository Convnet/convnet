unit CVN_PeerOrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, RzButton,CVN_ClientMSG;

type
  TfPeerOrd = class(TForm)
    bSureAdd: TRzBitBtn;
    bRefusejoin: TRzBitBtn;
    msgTxt: TRzLabel;
    luserNickname: TRzLabel;
    procedure bSureAddClick(Sender: TObject);
    procedure bRefusejoinClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    tmpmsg: pmyMSG;

    function getLastConfimMSGinfo:boolean;
  public
    { Public declarations }
    CVN_MSG:TcvnMSG;//消息
  end;

var
  fPeerOrd: TfPeerOrd;

implementation
uses CVN_MessageWindow,CVN_Protocol,CVN_csys;
{$R *.dfm}

function TfPeerOrd.getLastConfimMSGinfo: boolean;
var i:integer;
    myMSG:pmyMSG;
begin
    result:=false;
    if not assigned(fPeerOrd.CVN_MSG) then
        exit;
    //提取fMsgwin.CVN_MSG中MSGTYPE为1的信息
    for i:=0 to fPeerOrd.CVN_MSG.Count-1 do
    begin
        myMSG:=pmyMSG(fPeerOrd.CVN_MSG[i]);
        if myMSG.msgType=1 then
        begin
          luserNickname.Caption:=myMSG.senderNickName;
          msgTxt.Caption:=myMSG.msgContext;
          tmpmsg:=myMSG;
          result:=true;
          break;
        end;
        if myMSG.msgType=4 then
        begin
          luserNickname.Caption:=myMSG.senderNickName;
          msgTxt.Caption:='申请加入组['+myMSG.targetGroupName+']：'+myMSG.msgContext;
          tmpmsg:=myMSG;
          result:=true;
          break;
        end;
    end;
end;


procedure TfPeerOrd.bSureAddClick(Sender: TObject);
begin
  if tmpmsg.msgType=1 then
  begin
   tmpmsg.msgType:=2;  //同意加入好友
   CVN_SendCmdto(ProtocolToStr(cmdPeerSureFriend)+','+inttostr(tmpmsg.senderid)+'*');
  end;
  if tmpmsg.msgType=4 then
  begin
    tmpmsg.msgType:=5;  //同意加入组
    CVN_SendCmdto(ProtocolToStr(cmdPeerSureJoinGroup)+',T,'+inttostr(tmpmsg.senderid)+','+inttostr(tmpmsg.targetGroupid)+'*');
  end;
   if not getLastConfimMSGinfo then close;
end;

procedure TfPeerOrd.bRefusejoinClick(Sender: TObject);
begin
  if tmpmsg.msgType=1 then
  begin
   tmpmsg.msgType:=3;  //拒绝加入好友
   CVN_SendCmdto(ProtocolToStr(cmdPeerRefusedFriend)+','+inttostr(tmpmsg.senderid)+'*');
  end;
  if tmpmsg.msgType=4 then
  begin
   tmpmsg.msgType:=6;  //拒绝加组
   CVN_SendCmdto(ProtocolToStr(cmdPeerSureJoinGroup)+',F,'+inttostr(tmpmsg.senderid)+','+inttostr(tmpmsg.targetGroupid)+'*');
  end;
  if not getLastConfimMSGinfo then close;
end;

procedure TfPeerOrd.FormShow(Sender: TObject);
begin
  //获取显示信息（用户加入好友的申请）
  getLastConfimMSGinfo;
end;

procedure TfPeerOrd.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if getLastConfimMSGinfo then
  begin
    if tmpmsg.msgType=1 then
    begin
     tmpmsg.msgType:=3;  //拒绝加入好友
     CVN_SendCmdto(ProtocolToStr(cmdPeerRefusedFriend)+','+inttostr(tmpmsg.senderid)+'*');
    end;
    if tmpmsg.msgType=4 then
    begin
     tmpmsg.msgType:=6;  //拒绝加组
     CVN_SendCmdto(ProtocolToStr(cmdPeerSureJoinGroup)+',F,'+inttostr(tmpmsg.senderid)+','+inttostr(tmpmsg.targetGroupid)+'*');
    end;
    if getLastConfimMSGinfo then canclose:=false;
  end;
end;

procedure TfPeerOrd.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
