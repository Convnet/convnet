unit CVN_regist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzButton;

type
  TfRegist = class(TForm)
    Panel1: TPanel;
    lRegisthint: TLabel;
    ePassword: TEdit;
    eConfPass: TEdit;
    eNickName: TEdit;
    lRegUserName: TLabel;
    lRegPass: TLabel;
    lRegRePass: TLabel;
    lRegNickName: TLabel;
    lRegDesc: TLabel;
    eUsername: TEdit;
    bRegSubmit: TRzBitBtn;
    bCancel: TRzBitBtn;
    eDes: TMemo;
    Label7: TLabel;
    Image1: TImage;
    procedure bCancelClick(Sender: TObject);
    procedure bRegSubmitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure eUsernameChange(Sender: TObject);
    procedure ePasswordChange(Sender: TObject);
    procedure eDesChange(Sender: TObject);
    procedure eUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure registfial;
    procedure registnotacc;
    procedure registsuc;
    procedure FormCreate(Sender: TObject);
  private
  public

  end;

var
  fRegist: TfRegist;

implementation
uses CVN_Protocol,cvn_csys, clientUI;
{$R *.dfm}

procedure TfRegist.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfRegist.bRegSubmitClick(Sender: TObject);
var i:integer;
begin

  if (pos('@',eUsername.Text)=0) or (pos('.',eUsername.Text)=0) then
   if messagedlg(resinfo('MSG_USEMAIL'),mtWarning,[mbyes,mbno],0) = mrno then
    exit;

  //¼ì²éÃÜÂëÆ¥Åä
  if not sametext(epassword.Text,econfpass.Text) then
  begin
     label7.Caption:=resinfo('PASS_NOTMACH');
     exit;
  end;
  //¼ì²éÊäÈëÊÇ·ñÎª¿Õ
  if (length(ePassWord.Text)=0) or (length(eUsername.Text)=0) or (length(eNickName.Text)=0) then
  begin
     label7.Caption:=resinfo('FROM_NOT_FINISH');
     exit;
  end;
  eusername.Text:=FormatUnAllowStr(eusername.Text,40);
  epassword.Text:=FormatUnAllowStr(epassword.Text,40);
  enickname.Text:=FormatUnAllowStr(enickname.Text,40);
  edes.Text:=FormatUnAllowStr(edes.Text,40);

  CVN_ConnecttoServer(pchar(fclientui.eServerIP.text));
  i:=0;
  while not CVN_ServerIsConnected do
  begin
    inc(i);
    sleep(1);
    application.ProcessMessages;
    if i>64000 then
      break;
  end;

  if i<64000 then
    CVN_SendCmdto(ProtocolToStr(cmdRegistUser)+','+eUserName.Text+','+ePassWord.Text+','+eNickName.Text+',¡¡'+edes.Text+'*')
  else
    showmessage('Can''t connect to server');
end;

procedure TfRegist.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  dm4Server.SendCmd(ProtocolToStr(cmdLogout)+'*');
end;

procedure TfRegist.eUsernameChange(Sender: TObject);
var name:string;
begin
  //eNickname.Text:=eUserName.Text;
  name:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
  tedit(sender).Text:=name;
  if pos('@',name)=0 then
    eNickName.Text:=name
  else
    eNickName.Text:=copy(name,0,pos('@',name)-1);

end;

procedure TfRegist.ePasswordChange(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);  
end;

procedure TfRegist.eDesChange(Sender: TObject);
begin
    edes.Text:=formatUnAllowstr(edes.Text,edes.MaxLength);
end;

procedure TfRegist.eUsernameKeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TfRegist.registfial;
begin
  showmessage(RESINFO('USER_NAME_EXIST'));
end;

procedure TfRegist.registsuc;
begin
  showmessage(RESINFO('REG_SUCCESS'));
  fclientui.labInfomation.Caption:=RESINFO('REG_SUCCESS');

  fclientui.eUserName.Text:= eUsername.Text;
  fclientui.ePassword.Text:= epassword.Text;
//  application.ProcessMessages;
  //fclientui.bLogin.Click;
  //Hide;
  //fclientui.bLogin.Click;
end;

procedure TfRegist.registnotacc;
begin
  showmessage('·şÎñÆ÷²»ÔÊĞí×¢²á');
end;

procedure TfRegist.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
