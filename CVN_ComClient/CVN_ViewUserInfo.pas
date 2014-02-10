unit CVN_ViewUserInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CVN_CSYS;

type
  TfUserinfo = class(TForm)
    Panel3: TPanel;
    lUserinfo: TLabel;
    lShowUserName: TLabel;
    lShowIP: TLabel;
    lShowDesc: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fUserinfo: TfUserinfo;

implementation

{$R *.dfm}

procedure TfUserinfo.Button1Click(Sender: TObject);
begin
    close;
end;

procedure TfUserinfo.FormCreate(Sender: TObject);
begin
  SetActiveLanguage(self);
end;

end.
