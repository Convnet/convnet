unit CVN_ClientMSG;

interface
uses classes;
type
  pmyMSG=^TmyMSG;
  TmyMsg= packed  record
      msgtime:TDateTime;
      msgContext:string[200];
      msgType:integer;      //0���账�����Ϣ  1�û�����Ӻ���  2�û�ȷ��  3�û��ܾ�  4�û����������   5�û�ȷ�ϼ�����     6�û��ܾ�������
      senderid:integer;
      targetGroupid:integer;
      targetGroupName,
      senderNickName:string[15];
  end;

  TcvnMSG=class(Tlist)
    Procedure addinfo(msgContext:string;msgtype:integer); overload;
    Procedure addinfo(msgContext:string;msgtype,senderid:integer;senderNickname:string);overload;
    procedure addGroupinfo(msgContext:string;senderid,msgtype,targetGroupid:integer;targetgroupname,senderNickname:string);
  end;
  
implementation
{ TMSG }

uses SysUtils;


//���һ���µ���Ϣ
procedure TcvnMSG.addinfo( msgContext: string;
  msgtype: integer);
  var myMSG:pmyMSG;
begin
    New(myMSG);
    myMSG.msgtime:=now;
    myMSG.msgContext:=msgContext;
    myMSG.msgType:=msgType;
    add(myMSG);
end;

procedure  TcvnMSG.addGroupinfo(msgContext:string;senderid,msgtype,targetGroupid:integer;targetgroupname,senderNickname:string);  var myMSG:pmyMSG;
begin
    new(myMSG);
    myMSG.msgType:=msgType;
    myMSG.msgtime:=now;
    myMSG.msgContext:=msgContext;
    mymsg.senderid:=senderid;
    mymsg.senderNickName:=senderNickName;
    mymsg.targetGroupid:=targetGroupid;
    mymsg.targetGroupName:=targetGroupname;
    add(myMSG);
end;

procedure TcvnMSG.addinfo(msgContext: string; msgtype,senderid:integer;
  senderNickname: string);
    var myMSG:pmyMSG;
begin
    New(myMSG);
    myMSG.msgtime:=now;
    myMSG.msgContext:=msgContext;
    myMSG.senderid:=senderid;
    myMSG.senderNickName:=senderNickname;
    myMSG.msgType:=msgType;
    add(myMSG);
end;



end.

