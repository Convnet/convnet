unit CVN_PrivateSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzRadGrp, StdCtrls, RzButton, CVN_cSYS;

type
  TfPrivateSetup = class(TForm)
    Panel3: TPanel;
    lPrivateInfo: TLabel;
    Label2: TLabel;
    bSure: TRzBitBtn;
    bCancel: TRzBitBtn;
    lNickname: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    lPrivPass: TLabel;
    lPrivSurePass: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    lPrivDesc: TLabel;
    eDes: TMemo;
    Image2: TImage;
    allowPass1: TEdit;
    lPrivPass1: TLabel;
    lPrivPass2: TLabel;
    allowPass2: TEdit;
    allowPass3: TEdit;
    lPrivPass3: TLabel;
    lPrivDosPass: TLabel;
    allowPass4: TEdit;
    lAlert: TLabel;
    procedure bCancelClick(Sender: TObject);
    procedure bSureClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure eDesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
//     procedure Cvn_Peersuccrenewinfo(var Msg:TMessage); message CVN_SUCCRENEWINFO;
  end;

var
  fPrivateSetup: TfPrivateSetup;

implementation
uses CVN_Protocol, clientUI;
{$R *.dfm}

procedure TfPrivateSetup.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfPrivateSetup.bSureClick(Sender: TObject);
begin
    if edit3.Text<>edit2.Text then
    begin
      label6.Caption:=resinfo('PASS_NOTMACH');
      exit;
    end;
    
    //tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text);
    g_NickName:=formatUnAllowstr(edit1.Text,40);
    g_MyPass:= formatUnAllowstr(edit2.Text,40);
    
    g_common:= formatUnAllowstr(edes.Text,40);
    g_AllowPass1:=formatUnAllowstr(allowPass1.Text,40);
    g_AllowPass2:=formatUnAllowstr(allowPass2.Text,40);
    g_AllowPass3:=formatUnAllowstr(allowPass3.Text,40);
    g_AllowPass4:=formatUnAllowstr(allowPass4.Text,40);
    {if not CheckBox1.Checked then
    begin
      g_AllowPass1:='';
      g_AllowPass2:='';
      g_AllowPass3:='';
      g_AllowPass4:='';
    end;  }
    
    CVN_SendCmdto(protocoltostr(cmdrenewmyinfo)+','+g_NickName+','+g_MyPass+','+g_common+
    ','+g_AllowPass1+','+g_AllowPass2+','+g_AllowPass3+','+g_AllowPass4+'*');
    fclientui.myserverInfo.Caption:=g_common;
    fclientui.currentuser.Caption:=resinfo('USER_TEXT')+g_NickName;
    close;  
end;

procedure TfPrivateSetup.Edit3Change(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;

procedure TfPrivateSetup.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TfPrivateSetup.eDesChange(Sender: TObject);
begin
    edes.Text:=formatUnAllowstr(edes.Text,edes.MaxLength);  
end;

procedure TfPrivateSetup.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
