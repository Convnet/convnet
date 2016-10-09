unit FrmPortDetailsU;

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF Delphi6} Variants, {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmPortDetails = class(TForm)
    lblName: TLabel;
    edtName: TEdit;
    rgrProtocol: TRadioGroup;
    lblAddress: TLabel;
    edtAddress: TEdit;
    Label1: TLabel;
    edtExternalPort: TEdit;
    Label2: TLabel;
    edtInternalPort: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure edtNameChange(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetButtonsState;
    { Private declarations }
  public
    { Public declarations }
    procedure SetReadOnly;
  end;

implementation

{$R *.dfm}

procedure TFrmPortDetails.SetButtonsState;
begin
  btnOk.Enabled := (edtName.Text <> '') and
                   (edtAddress.Text <> '') and
                   (edtExternalPort.Text <> '') and
                   (edtInternalPort.Text <> '');
end;

procedure TFrmPortDetails.edtNameChange(Sender: TObject);
begin
  SetButtonsState;
end;

procedure TFrmPortDetails.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',
          Char(VK_BACK),
          Char(VK_DELETE),
          Char(VK_LEFT),
          Char(VK_RIGHT),
          Char(VK_TAB)
          ]) then Key := #0;
end;

procedure TFrmPortDetails.SetReadOnly;
begin
  edtName.ReadOnly := true;
  edtName.ParentColor := true;
  rgrProtocol.Enabled := false;
  edtAddress.ReadOnly := true;
  edtAddress.ParentColor := true;
  edtExternalPort.ReadOnly := true;
  edtExternalPort.ParentColor := true;
  edtInternalPort.ReadOnly := true;
  edtInternalPort.ParentColor := true;
end;

end.
