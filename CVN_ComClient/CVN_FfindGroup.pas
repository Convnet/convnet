unit CVN_FfindGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees, ComCtrls;

type
  TfindGroup = class(TForm)
    Panel3: TPanel;
    lFindGroup: TLabel;
    Panel1: TPanel;
    Button2: TButton;
    bFind: TButton;
    Edit1: TEdit;
    rFindGroupByName: TRadioButton;
    rFindGroupByDesc: TRadioButton;
    Edit3: TEdit;
    Panel2: TPanel;
    bJoinGroup: TButton;
    Edit4: TEdit;
    ListView1: TListView;
    Timer1: TTimer;
    Image1: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure bFindClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure bJoinGroupClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    procedure findgroupview(s:string);
    procedure userjoingroup(tmpstr:string);
  end;

var
  findGroup: TfindGroup;

implementation
uses CVN_Protocol,ClientStruct, cvn_csys,
  CVN_MessageWindow, CVN_PeerOrd, CVN_messageWin;
{$R *.dfm}

procedure TfindGroup.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfindGroup.Edit1Enter(Sender: TObject);
begin
  edit3.Text:='';
  rFindGroupByName.Checked:=true;
end;

procedure TfindGroup.Edit3Enter(Sender: TObject);
begin
  edit1.Text:='';
  rFindGroupByDesc.Checked:=true;
end;

procedure TfindGroup.bFindClick(Sender: TObject);
begin
    if rFindGroupByDesc.Checked then
      CVN_SendCmdto(ProtocolToStr(cmdFindGroup)+',B,'+formatUnAllowStr(edit3.Text,40)+'*')
    else
      CVN_SendCmdto(ProtocolToStr(cmdFindGroup)+',N,'+formatUnAllowStr(edit1.Text,40)+'*');
    bFind.Enabled:=false;
    timer1.Enabled:=true;
end;

procedure TfindGroup.findgroupview(s:string);
var
    tmpstrlist:tstringlist;
    i:integer;
    ListItem:tlistItem;
begin
   //s:=message_str;
   //ListView1.AddItem(s,nil);
   tmpstrlist:=tstringlist.Create;
   ListView1.Clear;
   Panel2.Visible:=false;
   try
     tmpstrlist.CommaText:=s;
     if strtoint(tmpstrlist[1])=0 then begin
         ListView1.AddItem('没有找到组',nil);
         exit;
        end;
     for i:= 0 to strtoint(tmpstrlist[1])-1 do
     begin
          //如果已经加入该组了就不显示
          if getGroupByID(strtoint(tmpstrlist[i*3+2]))<>nil then continue;//不显示已有组

          ListItem:=ListView1.Items.Add;
          ListItem.Caption:= tmpstrlist[i*3+3];
          ListItem.SubItems.Add(tmpstrlist[i*3+4]);
          ListItem.SubItems.Add(tmpstrlist[i*3+2]);
     end;
   finally
     tmpstrlist.free;
   end;
end;

procedure TfindGroup.Timer1Timer(Sender: TObject);
begin
  bFind.Enabled:=true;
  timer1.Enabled:=false;
end;

procedure TfindGroup.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if assigned(ListView1.ItemFocused) then
  begin
   //showmessage(ListView1.ItemFocused.Caption);
   if ListView1.ItemFocused.SubItems.Count>1 then
   begin
     Panel2.Visible:= not (ListView1.ItemFocused.SubItems[1]='');
     edit4.SetFocus;
   end;
  end;
end;

procedure TfindGroup.bJoinGroupClick(Sender: TObject);
begin
  // tmpUserid:=strtoint(ListView1.ItemFocused.SubItems[1]);
        //                  cmd                 groupid
   CVN_SendCmdto(ProtocolToStr(cmdJoinGroup)+','+ ListView1.ItemFocused.SubItems[1] +','
              //              desc                      createid                          groupname
          +formatUnAllowStr(edit4.Text,40)+','+ListView1.ItemFocused.SubItems[0]+','+ListView1.ItemFocused.Caption+'*');
   panel2.Visible:=false;

   FCVNMSG.Label1.Caption:=resinfo('JOINGROUP_ORDER_HAS_BEEN_SENT');
   FCVNMSG.Show;
   close;
end;

procedure TfindGroup.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TfindGroup.Edit1Change(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;


procedure TfindGroup.userjoingroup(tmpstr:string);
var 
    strlist:tstringlist;
begin
  //tmpstr:=message_str;
  strlist:=tstringlist.Create;
  try
    strlist.CommaText:=tmpstr;
    fpeerOrd.CVN_MSG.addGroupinfo(strlist[5],strtoint(strlist[2]),4,strtoint(strlist[3]),strlist[4],strlist[1]);
  finally
    strlist.Free;
  end;
  fpeerord.Show;
end;

procedure TfindGroup.FormCreate(Sender: TObject);
begin
  SetActiveLanguage(self);
  edit4.Text:= resinfo('ORDER_GROUP_TEXT');
end;

end.
