unit CVN_modifyGroupinfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CVN_cSYS, CVN_Protocol;

type
  TFModifyGroup = class(TForm)
    Panel3: TPanel;
    Label1: TLabel;
    lGroupName: TLabel;
    GroupName: TEdit;
    bSure: TButton;
    bCancel: TButton;
    lGroupDesc: TLabel;
    Groupdesc: TMemo;
    Image1: TImage;
    Label2: TLabel;
    GroupPass: TEdit;
    LGroupPassdesc: TLabel;
    procedure GroupNameChange(Sender: TObject);
    procedure bSureClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupdescChange(Sender: TObject);
    procedure GroupNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    groupid:integer;
    procedure grouphasexist;
    procedure renewGroupinfo(str:string);
  end;

var
  FModifyGroup: TFModifyGroup;

implementation

uses CVN_messageWin;

{$R *.dfm}

procedure TFModifyGroup.GroupNameChange(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;

procedure TFModifyGroup.bSureClick(Sender: TObject);
begin
    if GroupName.Text='' then
    begin
      FCVNMSG.Label1.Caption:='组名称必须填写';
      FCVNMSG.Show;
      //showmessage('组名称必须填写');
      exit;
    end;
    if Groupdesc.Text='' then
    begin
      FCVNMSG.Label1.Caption:='组备注必须填写';
      FCVNMSG.Show;
      //showmessage('组备注必须填写');
      exit;
    end;
    GroupName.Text:=FormatUnAllowStr(GroupName.Text,40);
    Groupdesc.Text:=FormatUnAllowStr(Groupdesc.Text,40);
    GroupPass.Text:=FormatUnAllowStr(GroupPass.Text,40);
    CVN_SendCmdto(ProtocolToStr(cmdmodifyGroup)+','+inttostr(groupid)+','+GroupName.Text+','+Groupdesc.Text+','+GroupPass.Text+'*');
    FCVNMSG.Close;
    bSure.Enabled:=false;
    close;
end;

procedure TFModifyGroup.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFModifyGroup.FormShow(Sender: TObject);
begin
  CVN_SendCmdto(ProtocolToStr(cmdGetGroupDesc)+','+inttostr(groupid)+'*');
end;

procedure TFModifyGroup.GroupdescChange(Sender: TObject);
begin
    Groupdesc.Text:=formatUnAllowstr(Groupdesc.Text,Groupdesc.MaxLength);
end;

procedure TFModifyGroup.GroupNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TFModifyGroup.grouphasexist;
begin
     FCVNMSG.Label1.Caption:='群组名已经存在，修改失败';
     FCVNMSG.Show;
    //showmessage('组名已经存在，修改失败');
end;

procedure TFModifyGroup.renewGroupinfo(str:string);
begin
   Groupdesc.Text:= str;
   Grouppass.Text:='NOCHANGE';
end;

procedure TFModifyGroup.FormCreate(Sender: TObject);
begin
  
  SetActiveLanguage(self);
end;

end.
