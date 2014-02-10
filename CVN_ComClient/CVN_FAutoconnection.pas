unit CVN_FAutoconnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, RzListVw, ImgList, strconv;

type
  TfAutoconnection = class(TForm)
    Panel3: TPanel;
    lSetAutoConCaption: TLabel;
    Image1: TImage;
    bClose: TButton;
    Panel1: TPanel;
    bAddAutoConUser: TButton;
    ListView1: TListView;
    ImageList1: TImageList;
    lSetAutoConCaptionTip: TLabel;
    bDel: TButton;
    procedure bAddAutoConUserClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAutoconnection: TfAutoconnection;

implementation

uses CVN_faddautouser,cvn_Csys;

{$R *.dfm}

procedure TfAutoconnection.bAddAutoConUserClick(Sender: TObject);
begin
  addautouser.show;
  addautouser.pass.Text:='';
end;

procedure TfAutoconnection.bCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfAutoconnection.FormShow(Sender: TObject);
var i:integer;
begin
  for i:=ListView1.Items.Count-1 downto 0 do
    if getuserByName(pchar(ListView1.Items[i].Caption))=nil then
        ListView1.Items[i].Delete;
end;

procedure TfAutoconnection.ListView1DblClick(Sender: TObject);
begin
  if assigned(ListView1.Selected) then
  begin
    addautouser.Show;
    addautouser.ComboBox1.Items.Add(ListView1.Selected.Caption);
    addautouser.ComboBox1.Text:=ListView1.Selected.Caption;
    addautouser.pass.Text:=ListView1.Selected.SubItems[0];
  end;
end;

procedure TfAutoconnection.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key <> 46 then exit;
  if assigned(listview1.Selected) then
  if MessageDlg('确认要删除'+listview1.Selected.Caption+'的自动连接吗？', mtConfirmation,mbOKCancel,0)=1 then
  begin
    listview1.Selected.Delete;
    addautouser.saveautoconninfo;
    listview1.ViewStyle:= vslist;
    listview1.ViewStyle:= vsicon;
  end;
end;

procedure TfAutoconnection.bDelClick(Sender: TObject);
begin
  if assigned(listview1.Selected) then
  if MessageDlg('确认要删除'+listview1.Selected.Caption+'的自动连接吗？', mtConfirmation,mbOKCancel,0)=1 then
  begin
    listview1.Selected.Delete;
    addautouser.saveautoconninfo;
    listview1.ViewStyle:= vslist;
    listview1.ViewStyle:= vsicon;
  end;
end;

procedure TfAutoconnection.FormCreate(Sender: TObject);
begin
   SetActiveLanguage(self);
end;

end.
