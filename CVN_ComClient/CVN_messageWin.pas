unit CVN_messageWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Cvn_csys;

type
  TFCVNMSG = class(TForm)
    Label1: TLabel;
    bSure: TButton;
    procedure bSureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCVNMSG: TFCVNMSG;

implementation

{$R *.dfm}

procedure TFCVNMSG.bSureClick(Sender: TObject);
begin
  close;
end;

procedure TFCVNMSG.FormCreate(Sender: TObject);
begin
    SetActiveLanguage(self);
end;

end.
