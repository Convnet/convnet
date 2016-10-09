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
    procedure shownewmsg;
  private
    { Private declarations }
    msgisshow:boolean;
  public
    user:Tuserinfo;
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
  //����Ժ���Ҫ�ػ�ؼ�
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
  msgisshow:=true;
end;

procedure Tchatform.shownewmsg;
begin
    if not msgisshow then
        show();
    msgisshow:=true;
end;

procedure Tchatform.bSendChatTextClick(Sender: TObject);
begin
  if bSendChatText.Enabled=false then exit;
  if trim(edit1.Text)='' then
  begin
    StatusBar1.Panels[0].Text:='��ϢΪ��';
    edit1.SetFocus;
    exit;
  end;
  if length(edit1.Text)>400 then
  begin
    StatusBar1.Panels[0].Text:='��Ϣ���ȳ���400�ֽڣ����ܷ���';
    exit;
  end;
    StatusBar1.Panels[0].Text:='';
    //����ӷ��͵���Ϣ
    //chattext.ClearSelection;
    if chattext.Lines.Count<>0 then//����ǵ�һ�оͲ�Ҫ�������
    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clgreen;
    chattext.SelText:=resinfo('SEND_TO')+'['+user.UserName+']��  '+timetostr(now);
    chattext.SelAttributes.Size:=11;
    chattext.SelAttributes.Color:=clblack;
    chattext.Lines.Add('   '+edit1.Text);
  CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(user.UserID)+'*'+edit1.Text);
  edit1.Text:='';
  edit1.SetFocus;
  //���������ϵ�65535���ش�
  SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  bSendChatText.Enabled:=false;
  timer1.Enabled:=true;
end;

procedure Tchatform.addinfo(msg:string;author:integer);
begin

  if not showing then
     msgisshow:=false;

  case author of
  0://ϵͳ
  begin
    if chattext.Lines.Count<>0 then//����ǵ�һ�оͲ�Ҫ�������
    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clred;
    chattext.SelText:=resinfo('MESSAGE_CANT_SENT')+timetostr(now);
    chattext.SelAttributes.Size:=11;
    //chattext.Lines.Add(datetimetostr(now)+'��Ϣ�޷��ʹ�:');
    chattext.SelAttributes.Color:=clblue;
    chattext.Lines.Add(' '+msg+'');
    //���������ϵ�65535���ش�
    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  end;
  1://�Է�
  begin
    if chattext.Lines.Count<>0 then//����ǵ�һ�оͲ�Ҫ�������
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
    //���������ϵ�65535���ش�
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

  if key=#13 then { ���ǰ�ִ�м�}
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
    //���������ϵ�65535���ش�
    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
end;





end.
