unit CVN_fSnap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfSnap = class(TForm)
    lInfo: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }

  end;
var fsnap:TfSnap;

implementation

uses clientUI, CVN_FAutoconnection, CVN_CreateGroup,
  CVN_FfindGroup, CVN_Ffinduser, CVN_modifyGroupinfo, CVN_PrivateSetup,
  CVN_PeerOrd, CVN_FConnectionPass, CVN_ViewUserInfo, CVN_faddautouser,
  CVN_regist, CVN_messageWin;

{$R *.dfm}





end.
