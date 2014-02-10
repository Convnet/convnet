unit CVN_CreateGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tfcreategroup = class(TForm)
    Panel3: TPanel;
    lCreateGroup: TLabel;
    GroupName: TEdit;
    lGroupName: TLabel;
    lGroupDesc: TLabel;
    bSure: TButton;
    bCancel: TButton;
    GroupDesc: TEdit;
    Image1: TImage;
    lGroupPass: TLabel;
    GroupPass: TEdit;
    LGroupPassdesc: TLabel;
    procedure bSureClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure GroupNameKeyPress(Sender: TObject; var Key: Char);
    procedure GroupDescChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fcreategroup: Tfcreategroup;

implementation
uses CVN_Protocol, CVN_messageWin,CVN_Csys;
{$R *.dfm}

procedure Tfcreategroup.bSureClick(Sender: TObject);
begin
    if GroupName.Text='' then
    begin
      FCVNMSG.Label1.Caption:='组名称必须填写';
      FCVNMSG.Show;
      //showmessage('组名称必须填写');
      exit;
    end;
    if GroupDesc.Text='' then
    begin
      FCVNMSG.Label1.Caption:='组描述必须填写';
      FCVNMSG.Show;
      //showmessage('组描述必须填写');
      exit;
    end;
    GroupName.Text:=FormatUnAllowStr(GroupName.Text,40);
    GroupDesc.Text:=FormatUnAllowStr(GroupDesc.Text,40);
    GroupPass.Text:=FormatUnAllowStr(GroupPass.Text,40);
    CVN_SendCmdto(ProtocolToStr(cmdCreateGroup)+','+GroupName.Text+','+groupdesc.Text+','+GroupPass.Text+'*');
    bSure.Enabled:=false;
end;

procedure Tfcreategroup.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfcreategroup.GroupNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure Tfcreategroup.GroupDescChange(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;


procedure Tfcreategroup.FormCreate(Sender: TObject);
begin
  SetActiveLanguage(self);
end;

end.
