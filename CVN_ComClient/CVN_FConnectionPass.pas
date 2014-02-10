unit CVN_FConnectionPass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzButton, ExtCtrls, ClientStruct,CVN_csys;

type
  TfNeedPass = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    bSure: TRzBitBtn;
    bCancel: TRzBitBtn;
    Panel3: TPanel;
    lNeedpass: TLabel;
    Image2: TImage;
    procedure Edit1Change(Sender: TObject);
    procedure bSureClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure bCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    tmpuser:Tuserinfo;
  end;

var
  fNeedPass: TfNeedPass;

implementation
     uses CVN_Protocol;
{$R *.dfm}

procedure TfNeedPass.Edit1Change(Sender: TObject);
begin
    tedit(sender).Text:=formatUnAllowstr(tedit(sender).Text,tedit(sender).MaxLength);
end;

procedure TfNeedPass.bSureClick(Sender: TObject);
begin
  tmpuser.AhthorPassword:=edit1.Text;
  tmpuser.TryConnect_start;
  //CVN_ConnectUser(tmpuser.UserID,edit1.Text);
  close;
end;

procedure TfNeedPass.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key in [',','*',':','''',' ']) then
        Key := #0;
end;

procedure TfNeedPass.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfNeedPass.FormShow(Sender: TObject);
begin
  edit1.Text:=tmpuser.AhthorPassword;
end;

end.
