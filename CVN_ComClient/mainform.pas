unit mainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CoolTrayIcon, Menus, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze, RzCommon, ExtCtrls, ImgList, StdCtrls, RzStatus, RzPanel,
  RzBmpBtn, RzLabel, VirtualTrees, RzBorder, RzButton, Mask, RzEdit, RzTabs,
  clientUI, dm4ServerComm;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
begin
  fclientui.Show;
end;

end.
