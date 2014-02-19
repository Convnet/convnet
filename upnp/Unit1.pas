unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, AutoNAT;

type
  TForm1 = class(TForm)
    RzButton1: TRzButton;
    RzButton2: TRzButton;
    procedure RzButton1Click(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  asd:TAutoNAT;
implementation

{$R *.dfm}

procedure TForm1.RzButton1Click(Sender: TObject);

begin
  asd:=TAutoNAT.Create(self);
  asd.Timeout:=30000;
  if asd.SearchRouter then
  //asd.AddNatMapping('asd',1111,'192.168.1.127',1111,'tcp')
end;

procedure TForm1.RzButton2Click(Sender: TObject);
begin
  showmessage(asd.RouterIp);
end;

end.
