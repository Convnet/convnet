unit CVNRUNASSERVICE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TConvnet2 = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Convnet2: TConvnet2;

implementation

uses clientUI,  CVN_CreateGroup, CVN_FfindGroup,
  CVN_Ffinduser, CVN_modifyGroupinfo, CVN_PrivateSetup, CVN_PeerOrd,
  CVN_FConnectionPass, CVN_ViewUserInfo, CVN_FAutoconnection,CVN_messageWin,
  CVN_faddautouser, CVN_regist, CVN_MessageWindow, CVN_CSYS, CVN_ClientMSG,
  FrmMainU;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Convnet2.Controller(CtrlCode);
end;

function TConvnet2.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TConvnet2.ServiceStart(Sender: TService; var Started: Boolean);
begin

  if checkrunning then
  begin
    Started:=false;
    exit;
  end;
  outputdebugstring('start');
   SetThreadLocale(
    DWORD(Word(SORT_DEFAULT) shl 16) or
    DWORD(Word(SUBLANG_CHINESE_SIMPLIFIED) shl 10) or
    DWORD(Word(LANG_CHINESE))
    );

  Svcmgr.Application.CreateForm(Tfclientui, fclientui);
  SetActiveLanguage(fclientui);
  outputdebugstring('start2');
  Svcmgr.Application.CreateForm(TfMSGWIN, fMSGWIN);
  Svcmgr.Application.CreateForm(TfAutoconnection, fAutoconnection);
  Svcmgr.Application.CreateForm(TfRegist, fRegist);
  Svcmgr.Application.CreateForm(Tfcreategroup, fcreategroup);
  Svcmgr.Application.CreateForm(TfindGroup, findGroup);
  Svcmgr.Application.CreateForm(TfindUser, findUser);
  Svcmgr.Application.CreateForm(TFModifyGroup, FModifyGroup);
  Svcmgr.Application.CreateForm(TfPrivateSetup, fPrivateSetup);

  Svcmgr.Application.CreateForm(TfPeerOrd, fPeerOrd);
  fpeerOrd.CVN_MSG:=TcvnMSG.Create;
    outputdebugstring('start3');

  Svcmgr.Application.CreateForm(TfNeedPass, fNeedPass);
  outputdebugstring('start3.1');

  Svcmgr.Application.CreateForm(TfUserinfo, fUserinfo);
  outputdebugstring('start3.2');

  Svcmgr.Application.CreateForm(Taddautouser, addautouser);
  outputdebugstring('start3.3');

//  Svcmgr.Application.CreateForm(TFCVNMSG, FCVNMSG);
  outputdebugstring('start3.4');

  Svcmgr.Application.CreateForm(TFrmMain, FrmMain);
    outputdebugstring('start4');
  if fclientui.checkAutoLogin.Checked then
  begin
      fclientui.blogin.Click;
  end;
  outputdebugstring('start5');
  Started:=TRUE;
  fclientui.Show;

 { Svcmgr.Application.CreateForm(Tfclientui, fclientui);
  Svcmgr.Application.CreateForm(TfRegist, fRegist);
  Svcmgr.Application.CreateForm(Tfcreategroup, fcreategroup);
  Svcmgr.Application.CreateForm(TfindGroup, findGroup);
  Svcmgr.Application.CreateForm(TfindUser, findUser);
  Svcmgr.Application.CreateForm(TFModifyGroup, FModifyGroup);
  Svcmgr.Application.CreateForm(TfPrivateSetup, fPrivateSetup);
  Svcmgr.Application.CreateForm(TfMSGWIN, fMSGWIN);
  Svcmgr.Application.CreateForm(TfPeerOrd, fPeerOrd);
  Svcmgr.Application.CreateForm(TfNeedPass, fNeedPass);
  Svcmgr.Application.CreateForm(TfUserinfo, fUserinfo);
  Svcmgr.Application.CreateForm(TfAutoconnection, fAutoconnection);
  Svcmgr.Application.CreateForm(Taddautouser, addautouser);
  {fclientui:=Tfclientui.Create(self);
  dm4Server:=Tdm4Server.Create(self);
  dmUpnp:=TdmUpnp.Create(self);
  fRegist:=TfRegist.Create(self);
  fcreategroup:=Tfcreategroup.Create(self);
  findGroup:=TfindGroup.Create(self);
  findUser:=TfindUser.Create(self);
  FModifyGroup:=TFModifyGroup.Create(self);
  fPrivateSetup:=TfPrivateSetup.Create(self);
  fMSGWIN:=TfMSGWIN.Create(self);
  fPeerOrd:=TfPeerOrd.Create(self);
  fNeedPass:=TfNeedPass.Create(self);
  fUserinfo:=TfUserinfo.Create(self);
  fAutoconnection:=TfAutoconnection.Create(self);
  addautouser:=Taddautouser.Create(self);}

end;

procedure TConvnet2.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  fclientui.Close;
  //ÊÍ·Å×ÊÔ´
  fpeerOrd.CVN_MSG.Free;
  stopped:=true;
end;

procedure TConvnet2.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    Sleep(0);
    ServiceThread.ProcessRequests(False);
  end;
end;

end.
