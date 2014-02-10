unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdSync, ExtCtrls, CoolTrayIcon;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button4: TButton;
    CoolTrayIcon1: TCoolTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;
  procedure GetCVNmessage(messagetype:integer;mmessagestring:string);stdcall;


var
  Form1: TForm1;

implementation
uses dll, Crypt;

{$R *.dfm}

procedure GetCVNmessage(messagetype:integer;mmessagestring:string);
var tmpstr:string;
    strlist:tstringlist;
    i:integer;
begin
  if assigned(form1.Memo1) then
     form1.Memo1.Lines.Add(inttostr(messagetype)+' :'+mmessagestring);
end;


procedure TForm1.Button1Click(Sender: TObject);
var p:pchar;
begin
  CVN_Login('gtmap.cn:822',pchar(edit1.Text),pchar(edit2.Text));
end;

procedure TForm1.Button3Click(Sender: TObject);
  var tmpuser:tuserinfo;
begin
    tmpuser:=getuserByName('服务器1');
      if tmpuser<>nil then
        tmpuser.TryConnect_start;
end;

procedure TForm1.FormCreate(Sender: TObject);
var inifile:tstringlist;
begin
    CVN_message(@GetCVNmessage);   //初始化回调函数
    CVN_InitClientServer(60,50);   //初始化本地服务
    CVN_InitEther;                  //初始化网卡


    inifile:=tstringlist.Create;
  try
    if FileExists(ExtractFilePath(Application.ExeName) + 'ini\config.ini') then
    begin
      inifile.LoadFromFile(ExtractFilePath(Application.ExeName) +'ini\config.ini');
      try
        Edit1.Text:=inifile.Values['UserName'];
        Edit2.Text:=DecryptString(inifile.Values['Password']);
      except
      end;
    end;
  finally
    inifile.Free;
  end;

end;



procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CVN_Logout;
   CVN_FreeRes;
end;

procedure TForm1.Button2Click(Sender: TObject);
  var tmpuser:tuserinfo;
begin
    tmpuser:=getuserByName('qqq');
      if tmpuser<>nil then
        tmpuser.DissconnectPeer;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  CVN_Logout;
end;


procedure TForm1.CoolTrayIcon1Click(Sender: TObject);
begin
  CoolTrayIcon1.ShowMainForm;
end;

end.
