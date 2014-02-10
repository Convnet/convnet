unit CVN_MessageWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs, VirtualTrees, StdCtrls, RzLabel, RzButton,CVN_ClientMSG,
  ExtCtrls, ImgList ,CVN_csys;

type
  TfMsgWin = class(TForm)
    msgPage: TRzPageControl;
    hisTAB: TRzTabSheet;
    MSGVIEW: TVirtualStringTree;
    TabSheet1: TRzTabSheet;
    debuginfo: TVirtualStringTree;
    imagepackage: TImageList;
    Button1: TButton;
    procedure MSGVIEWGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure MSGVIEWGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure msgTABShow(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public
    
    procedure CVN_OrdPeer(s:string);
    procedure killMSG;
  end;



var
  fMsgwin: TfMSGWIN;

implementation

uses  CVN_PeerOrd;
{$R *.dfm}

procedure TfMSGWIN.MSGVIEWGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
    nodedatasize:=sizeof(TmyMSG);
end;

procedure TfMSGWIN.MSGVIEWGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
  var data:pmyMSG;
begin
   data:=sender.GetNodeData(node);
   if column =0 then
     CellText:=timetostr(data^.msgtime);
   if column =1 then
   begin
    if data^.msgType=0 then
     CellText:=data^.msgContext;
    if data^.msgType=1 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP');
    if data^.msgType=2 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP_SURE');
    if data^.msgType=3 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP_REFUSE');
    if data^.msgType=4 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP')+data^.targetGroupName;
    if data^.msgType=5 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP')+data^.targetGroupName+resinfo('ORDER_SURE');
    if data^.msgType=6 then
     CellText:=data^.senderNickName+resinfo('ORDER_JOIN_USERGROUP')+data^.targetGroupName+resinfo('ORDER_REFUSE');

   end;
end;

procedure TfMSGWIN.msgTABShow(Sender: TObject);
begin
  fMSGWIN.Height:=200;
end;

procedure TfMSGWIN.RzBitBtn1Click(Sender: TObject);
begin
   close;
end;

procedure TfMSGWIN.CVN_OrdPeer(s:string);
var 
    tmpstrlist:tstringlist;
    strstep,i:integer;
begin

  tmpstrlist:=tstringlist.Create;
  try
    tmpstrlist.DelimitedText:=',';
    tmpstrlist.CommaText:=s;
    //消息步长3
    strstep:=3;
    //消息格式：0消息头，1消息长度，2用户ID,3用户昵称，4消息内容
    for i:=0 to ((tmpstrlist.Count-1) div strstep)-1 do
    begin
      fpeerord.CVN_MSG.addinfo(tmpstrlist[i*strstep+4],1,strtoint(tmpstrlist[2]),tmpstrlist[3]);
    end;
    fPeerOrd.show;
  finally
    tmpstrlist.Free;
  end;

end;

procedure TfMSGWIN.killMSG;
begin
  msgview.RootNodeCount:=0;
  debuginfo.RootNodeCount:=0;
  //CVN_MSG.Clear;
end;

procedure TfMsgWin.Button1Click(Sender: TObject);
begin
  close;
end;

end.
