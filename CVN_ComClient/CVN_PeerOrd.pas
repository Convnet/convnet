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
    CVN_MSG:TcvnMSG;//��Ϣ
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
    //��ȡfMsgwin.CVN_MSG��MSGTYPEΪ1����Ϣ
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
          msgTxt.Caption:='���������['+myMSG.targetGroupName+']��'+myMSG.msgContext;
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
   tmpmsg.msgType:=2;  //ͬ��������
   CVN_FriendConfirm(tmpmsg.senderid);

  end;
  if tmpmsg.msgType=4 then
  begin
    tmpmsg.msgType:=5;  //ͬ�������
    CVN_ConfirmJoinGroup(tmpmsg.senderid,tmpmsg.targetGroupid);
  end;
   if not getLastConfimMSGinfo then close;
end;

procedure TfPeerOrd.bRefusejoinClick(Sender: TObject);
begin
  if tmpmsg.msgType=1 then
  begin
   tmpmsg.msgType:=3;  //�ܾ��������
   CVN_FriendRefuse(tmpmsg.senderid);

  end;
  if tmpmsg.msgType=4 then
  begin
   tmpmsg.msgType:=6;  //�ܾ�����
   CVN_RefuseJoinGroup(tmpmsg.senderid,tmpmsg.targetGroupid);

  end;
  if not getLastConfimMSGinfo then close;
end;

procedure TfPeerOrd.FormShow(Sender: TObject);
begin
  //��ȡ��ʾ��Ϣ���û�������ѵ����룩
  getLastConfimMSGinfo;
end;

procedure TfPeerOrd.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if getLastConfimMSGinfo then
  begin
    if tmpmsg.msgType=1 then
    begin
     tmpmsg.msgType:=3;  //�ܾ��������
     CVN_FriendRefuse(tmpmsg.senderid);
    end;
    if tmpmsg.msgType=4 then
    begin
     tmpmsg.msgType:=6;  //�ܾ�����
     CVN_RefuseJoinGroup(tmpmsg.senderid,tmpmsg.targetGroupid);
    end;
    if getLastConfimMSGinfo then canclose:=false;
  end;
end;

procedure TfPeerOrd.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
