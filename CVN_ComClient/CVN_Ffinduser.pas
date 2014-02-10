unit CVN_Ffinduser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, CVN_Protocol;


type
  TfindUser = class(TForm)
    Panel1: TPanel;
    rFindUserName: TRadioButton;
    rFindUserNickName: TRadioButton;
    rFindUserDesc: TRadioButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    bFind: TButton;
    Button2: TButton;
    ListView1: TListView;
    Panel3: TPanel;
    lFindUser: TLabel;
    Panel2: TPanel;
    bOrderAddFriend: TButton;
    Edit4: TEdit;
    Timer1: TTimer;
    Image1: TImage;
    procedure bFindClick(Sender: TObject);
    procedure rFindUserNickNameClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure bOrderAddFriendClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Cvn_FindResult(s:string);
  end;

  var finduser:tfinduser;
implementation
uses ClientStruct, CVN_cSYS, CVN_messageWin;
{$R *.dfm}

procedure TfindUser.bFindClick(Sender: TObject);
begin
    if rFindUserName.Checked then
      CVN_SendCmdto(ProtocolToStr(cmdFindUser)+',U,'+ formatUnAllowstr(edit1.Text,40) +'*');
    if rFindUserNickName.Checked then
      CVN_SendCmdto(ProtocolToStr(cmdFindUser)+',N,'+ formatUnAllowstr(edit2.Text,40) +'*');
    if rFindUserDesc.Checked then
      CVN_SendCmdto(ProtocolToStr(cmdFindUser)+',B,'+ formatUnAllowstr(edit3.Text,40) +'*');
    bFind.Enabled:=false;
    timer1.Enabled:=true;
end;


procedure TfindUser.Cvn_FindResult(s:string);
var
    tmpstrlist:tstringlist;
    i:integer;
    ListItem:tlistItem;
begin
   //ListView1.AddItem(s,nil);
   tmpstrlist:=tstringlist.Create;
   ListView1.Clear;
   Panel2.Visible:=false;
   try
     tmpstrlist.CommaText:=s;
     if strtoint(tmpstrlist[1])=0 then begin
         ListView1.AddItem(resinfo('NOT_FOUND_USER'),nil);
         exit;
        end;
     for i:= 0 to strtoint(tmpstrlist[1])-1 do
     begin
          if strtoint(tmpstrlist[i*3+2])=g_UserID then continue;//不显示自己
          if getuFriendByID(strtoint(tmpstrlist[i*3+2]))<>nil then continue;//不显示已有好友

          ListItem:=ListView1.Items.Add;
          ListItem.Caption:= tmpstrlist[i*3+3];
          ListItem.SubItems.Add(tmpstrlist[i*3+4]);
          ListItem.SubItems.Add(tmpstrlist[i*3+2]);
     end;
   finally
     tmpstrlist.free;
   end;
end;

procedure TfindUser.rFindUserNickNameClick(Sender: TObject);
begin
  if rFindUserName.Checked then begin Edit1.SetFocus; edit2.Text:='';edit3.Text:='';end;
  if rFindUserNickName.Checked then begin Edit2.SetFocus; edit1.Text:='';edit3.Text:='';end;
  if rFindUserDesc.Checked then begin Edit3.SetFocus; edit2.Text:='';edit1.Text:='';end;
end;

procedure TfindUser.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TfindUser.Edit1Enter(Sender: TObject);
begin
  if edit1.Focused then begin edit2.Text:='';edit3.Text:=''; rFindUserName.Checked:=true;  end;
  if edit2.Focused then begin edit1.Text:='';edit3.Text:=''; rFindUserNickName.Checked:=true;end;
  if edit3.Focused then begin edit2.Text:='';edit1.Text:=''; rFindUserDesc.Checked:=true;end;
end;

procedure TfindUser.Timer1Timer(Sender: TObject);
begin
  bfind.Enabled:=true;
  timer1.Enabled:=false;
end;

procedure TfindUser.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if assigned(ListView1.ItemFocused) then
  begin
   //showmessage(ListView1.ItemFocused.Caption);
   if ListView1.ItemFocused.SubItems.Count>1 then
   begin
     if strtoint(ListView1.ItemFocused.SubItems[1])=g_Userid then
     begin
         Panel2.Visible:=false;
         exit;
     end;
     Panel2.Visible:= not (ListView1.ItemFocused.SubItems[1]='');
     edit4.SetFocus;
   end;
  end;
end;

procedure TfindUser.FormShow(Sender: TObject);
begin
  if rFindUserName.Checked then begin Edit1.SetFocus; edit2.Text:='';edit3.Text:='';end;
  if rFindUserNickName.Checked then begin Edit2.SetFocus; edit1.Text:='';edit3.Text:='';end;
  if rFindUserDesc.Checked then begin Edit3.SetFocus; edit2.Text:='';edit1.Text:='';end;
end;

procedure TfindUser.bOrderAddFriendClick(Sender: TObject);
//var tmpUserid:integer;
begin
  // tmpUserid:=strtoint(ListView1.ItemFocused.SubItems[1]);

   CVN_SendCmdto(ProtocolToStr(cmdPeerOrdFriend)+','+ ListView1.ItemFocused.SubItems[1] +','+formatUnAllowStr(edit4.Text,40)+'*');
   Panel2.Visible:=false;
   ListView1.Clear;
    FCVNMSG.Label1.Caption:=resinfo('JOINFRIEND_ORDER_HAS_BEEN_SENT');
    FCVNMSG.Show;
    //showmessage('已提出申请');
   close;
end;

procedure TfindUser.Edit2Change(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;

procedure TfindUser.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TfindUser.FormCreate(Sender: TObject);
var tempcol:TListColumn;
begin
  ListView1.Columns.Clear;
  tempcol:=ListView1.Columns.Add;
  tempcol.Caption:=resinfo('USERNAME');
  tempcol.Width:=150;
  tempcol:=ListView1.Columns.Add;
  tempcol.Caption:=resinfo('NICKNAME');
  tempcol.Width:=170;
  Edit4.Text:=resinfo('ORDER_FRIEND_TEXT');
SetActiveLanguage(self);
end;

end.
