unit CVN_faddautouser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CVN_cSYS , ComCtrls ,Crypt,clientUI;

type
  Taddautouser = class(TForm)
    Panel3: TPanel;
    laddAutoHostInfo: TLabel;
    Image1: TImage;
    lSelectAUser: TLabel;
    lSetPassword: TLabel;
    ComboBox1: TComboBox;
    pass: TEdit;
    bSure: TButton;
    bCancel: TButton;
    Panel1: TPanel;
    addautouserTip: TLabel;
    procedure FormShow(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bSureClick(Sender: TObject);
    procedure saveautoconninfo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  addautouser: Taddautouser;


implementation
  uses CVN_FAutoconnection, CVN_messageWin;
{$R *.dfm}

procedure Taddautouser.FormShow(Sender: TObject);
var i:integer;
  function userinlist:boolean;
  var j:integer;
  begin
      result:=false;
      for j:=0 to fAutoconnection.ListView1.Items.Count-1 do
      begin
        if tuserinfo(g_AllUserInfo.Items[i]).UserName=fAutoconnection.ListView1.Items.Item[j].Caption then
          result:=true;
      end;
  end;
begin
   ComboBox1.Items.Clear;

   for i:=0 to g_AllUserInfo.Count-1 do
   begin
      if not userinlist then
      ComboBox1.Items.Add(tuserinfo(g_AllUserInfo.Items[i]).UserName);
   end;
   ComboBox1.ItemIndex:=0;
end;

procedure Taddautouser.bCancelClick(Sender: TObject);
begin
    close;
end;

procedure Taddautouser.bSureClick(Sender: TObject);
var tmpitem:TListItem;
    i:integer;
    hasuser:boolean;
begin
  hasuser:=false;
  for i:=0 to ComboBox1.Items.Count-1 do
  begin
    if ComboBox1.Text=ComboBox1.Items[i] then
    begin
      hasuser:=ComboBox1.Text=ComboBox1.Items[i];
      break;
    end;
  end;

  if not hasuser then
  begin
    FCVNMSG.Label1.Caption:='没有这样的用户，请重新选择';
    FCVNMSG.Show;
    //showmessage('没有这样的用户，请重新选择');
    exit;
  end;

  if ComboBox1.Items.Count=0 then
      exit;
  //已经存在modify
  for i:=0 to fAutoconnection.ListView1.Items.Count-1 do
  begin
    if fAutoconnection.ListView1.Items[i].Caption = ComboBox1.Text then
    begin
        fAutoconnection.ListView1.Items[i].SubItems[0]:=pass.Text;
        saveautoconninfo;
        fclientui.loadautoconntioninfo;
        fclientui.StartAutoConnection;
        close;
        exit;
    end;
  end;
  tmpitem:=fAutoconnection.ListView1.Items.Add;
  tmpitem.Caption:=ComboBox1.Text;
  tmpitem.SubItems.Add(pass.Text);
  saveautoconninfo;
  fclientui.loadautoconntioninfo;
  fclientui.StartAutoConnection;
  close;
end;

procedure Taddautouser.saveautoconninfo;
var i:integer;
    s:tstringlist;
begin
  s:=tstringlist.Create;
  try
    for i:=0 to fAutoconnection.ListView1.Items.Count-1 do
    begin
      s.add(fAutoconnection.ListView1.Items.Item[i].Caption+'='+EncryptString(fAutoconnection.ListView1.Items.Item[i].SubItems[0]));
    end;
    try
      s.SaveToFile(ExtractFilePath(Application.ExeName) + 'ini\profile_'+inttostr(G_Userid)+'.ini');
    except
    end;
  finally
    s.Free;
  end;
end;

procedure Taddautouser.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
