unit CVN_GroupChat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, RzEdit, Vcl.StdCtrls,
  Vcl.ComCtrls, CVN_CSYS, Vcl.ExtCtrls;

type
  TgroupChatForm = class(TForm)
    chattext: TRichEdit;
    Edit1: TRzRichEdit;
    bSendChatText: TRzBitBtn;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    procedure bSendChatTextClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    msgisshow:boolean;

  public
    { Public declarations }

    groupinfo:TPeerGroupInfo;
    procedure addinfo(s:string);
    procedure shownewmsg;
  end;

var
  groupChatForm: TgroupChatForm;

implementation

{$R *.dfm}

procedure TgroupChatForm.addinfo(s: string);
begin

    if not showing then
       msgisshow:=false;


    chattext.Lines.Add('');
    chattext.SelAttributes.Size:=9;
    chattext.SelAttributes.Color:=clblue;
    chattext.Lines.Add('----'+datetimetostr(now())+'----');

    chattext.SelAttributes.Size:=11;
    chattext.SelAttributes.Color:=clBlack;
    chattext.Lines.Add(s);



  //将滚动条拖到65535像素处
//  SendMessage(chattext.handle, EM_SCROLLCARET, 0, 0);

    SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);


end;

procedure TgroupChatForm.bSendChatTextClick(Sender: TObject);
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


  CVN_GroupChatMsg(groupinfo.GroupID,pchar(Edit1.Text));

  edit1.Text:='';
  edit1.SetFocus;
  //将滚动条拖到65535像素处
  SendMessage(chattext.Handle,WM_VSCROLL,MAKELONG(SB_THUMBPOSITION,65535),0);
  bSendChatText.Enabled:=false;
  timer1.Enabled:=true;

end;



procedure TgroupChatForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin

  if key=#13 then { 判是按执行键}
  begin
    key:=#0;
    bSendChatText.Click;
  end
end;

procedure TgroupChatForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    close;
end;

procedure TgroupChatForm.FormShow(Sender: TObject);
begin
  Caption:=groupinfo.groupname+'群组对话中';
  SetForegroundWindow(self.handle);
  SetActiveWindow(self.handle);
  msgisshow:=true;
end;

procedure TgroupChatForm.RzBitBtn1Click(Sender: TObject);
begin
    close;
end;

procedure TgroupChatForm.shownewmsg;
begin
    if not msgisshow then
        show();
    msgisshow:=true;
end;

procedure TgroupChatForm.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  bSendChatText.Enabled:=true;
end;

end.
