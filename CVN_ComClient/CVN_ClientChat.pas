unit CVN_ClientChat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ClientStruct, RzButton,
  RzPanel, RzCommon, RzEdit, CVN_Csys;
type
  Tchatform = class(TForm)
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    Edit1: TRzRichEdit;
    bSendChatText: TRzBitBtn;
    chattext: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure bSendChatTextClick(Sender: TObject);
    procedure addinfo(msg:string;author:integer);
    procedure addsysinfo(msg:string);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }

  public
    user:Tuserinfo;
    group:TPeerGroupInfo;
  end;

//var
//  chatform: Tchatform;

implementation
uses CVN_Protocol;
{$R *.dfm}

procedure Tchatform.FormShow(Sender: TObject);
var i:integer;
begin
  //AnimateWindow(Self.Handle,200,AW_BLEND);
  //完成以后需要重绘控件
 { for i:=0 to self.ComponentCount-1 do
  begin
    try
      if not self.Components[i].ClassNameIs('ttimer') then
      TControl(self.Components[i]).Refresh;
    except
    end;
  end;}
  //Name:='chatform'+inttostr(user.userid);
  Caption:=user.UserName+RESINFO('CHATING');
  SetForegroundWindow(self.handle);
  SetActiveWindow(self.handle);
end;

procedure Tchatform.bSendChatTextClick(Sender: TObject);
begin
  if bSendChatText.Enabled=false then exit;
  if trim(edit1.Text)='' then
  begin
    StatusBar1.Panels[0].Text:='信息为空';
    edit1.SetFocus;
    exit;
  end;
  if length(edit1.Text)>400 then
  begin
    StatusBar1.Panels[0].Text:='信息长度超过400字节，不能发送';
    exit;
  end;
    StatusBar1.Panels[0].Text:='';
    //先添加发送的信息
    //chattext.ClearSelection;
    if chattext.Lines.Count<>0 then//如果是第一行就不要添加行了
    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clgreen;
    chattext.SelText:=resinfo('SEND_TO')+'['+user.UserName+']：  '+timetostr(now);
    chattext.SelAttributes.Size:=11;
    chattext.SelAttributes.Color:=clblack;
    chattext.Lines.Add('   '+edit1.Text);
  CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(user.UserID)+'*'+edit1.Text);
  edit1.Text:='';
  edit1.SetFocus;
  //将滚动条拖到65535像素处
  SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  bSendChatText.Enabled:=false;
  timer1.Enabled:=true;
end;

procedure Tchatform.addinfo(msg:string;author:integer);
begin
  case author of
  0://系统
  begin
    if chattext.Lines.Count<>0 then//如果是第一行就不要添加行了
    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clred;
    chattext.SelText:=resinfo('MESSAGE_CANT_SENT')+timetostr(now);
    chattext.SelAttributes.Size:=11;
    //chattext.Lines.Add(datetimetostr(now)+'信息无法送达:');
    chattext.SelAttributes.Color:=clblue;
    chattext.Lines.Add(' '+msg+'');
    //将滚动条拖到65535像素处
    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  end;
  1://对方
  begin
    if chattext.Lines.Count<>0 then//如果是第一行就不要添加行了
    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clblue;
    chattext.SelText:='['+user.UserName+']'+resinfo('SAY')+':  '+timetostr(now);
    chattext.SelAttributes.Size:=11;
    chattext.SelAttributes.Color:=clblack;
    try
    chattext.Lines.Add('   '+msg);
    except
    end;
    //将滚动条拖到65535像素处
    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  end;
  end; //case
end;

procedure Tchatform.FormCreate(Sender: TObject);
begin
  SetActiveLanguage(self);
  // SetWindowLong(Handle,GWL_EXSTYLE,(GetWindowLong(handle,GWL_EXSTYLE) or WS_EX_APPWINDOW));
end;

procedure Tchatform.Timer1Timer(Sender: TObject);
begin
  bSendChatText.Enabled:=true;
  timer1.Enabled:=false;
end;

procedure Tchatform.Edit1KeyPress(Sender: TObject; var Key: Char);
begin

  if key=#13 then { 判是按执行键}
  begin
    key:=#0;
    bSendChatText.Click;
  end
end;

procedure Tchatform.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    close;
end;

procedure Tchatform.addsysinfo(msg: string);
begin
    try
    chattext.Lines.Add(msg);
    except
    end;
    //将滚动条拖到65535像素处
    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
end;





end.
