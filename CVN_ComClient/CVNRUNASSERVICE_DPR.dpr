program CVNRUNASSERVICE_DPR;

uses
  ExceptionLog,
  SvcMgr,
  CVNRUNASSERVICE in 'CVNRUNASSERVICE.pas' {Convnet2: TService},
  dm4ServerComm in 'dm4ServerComm.pas' {dm4Server: TDataModule},
  dm4ClientComm in 'dm4ClientComm.pas' {clientStruct: TDataModule},
  clientUI in 'clientUI.pas' {fclientui},
  CVN_Protocol in '..\ConvnetCommfile\CVN_Protocol.pas',
  CVN_ClientStruct in 'CVN_ClientStruct.pas',
  CVN_SYS in 'CVN_SYS.pas',
  CVN_ClientChat in 'CVN_ClientChat.pas' {Form2},
  CVN_regist in 'CVN_regist.pas' {fRegist},
  CVN_CreateGroup in 'CVN_CreateGroup.pas' {fcreategroup},
  CVN_FfindGroup in 'CVN_FfindGroup.pas' {findGroup},
  CVN_Ffinduser in 'CVN_Ffinduser.pas' {findUser},
  CVN_modifyGroupinfo in 'CVN_modifyGroupinfo.pas' {FModifyGroup},
  CVN_PrivateSetup in 'CVN_PrivateSetup.pas' {fPrivateSetup},
  CVN_MessageWindow in 'CVN_MessageWindow.pas' {fMSGWIN},
  CVN_ClientMSG in 'CVN_ClientMSG.pas',
  CVN_PeerOrd in 'CVN_PeerOrd.pas' {fPeerOrd},
  WinSock2 in 'Winsock2.pas',
  dm4upnp in 'dm4upnp.pas' {dmUpnp: TDataModule},
  CVN_FConnectionPass in 'CVN_FConnectionPass.pas' {fNeedPass},
  CVN_EtherControl in 'CVN_EtherControl.pas',
  CVN_Ether in 'CVN_Ether.pas',
  CVN_fSnap in 'CVN_fSnap.pas' {fSnap},
  CVN_ViewUserInfo in 'CVN_ViewUserInfo.pas' {fUserinfo},
  CVN_FAutoconnection in 'CVN_FAutoconnection.pas' {fAutoconnection},
  CVN_faddautouser in 'CVN_faddautouser.pas' {addautouser},
  Crypt in 'Crypt.pas';

{$R *.RES}

begin
  Application.CreateForm(TConvnet2, Convnet2);
  {Application.CreateForm(Tfclientui, fclientui);
  Application.CreateForm(Tdm4Server, dm4Server);
  Application.CreateForm(TdmUpnp, dmUpnp);
  Application.CreateForm(TfRegist, fRegist);
  Application.CreateForm(Tfcreategroup, fcreategroup);
  Application.CreateForm(TfindGroup, findGroup);
  Application.CreateForm(TfindUser, findUser);
  Application.CreateForm(TFModifyGroup, FModifyGroup);
  Application.CreateForm(TfPrivateSetup, fPrivateSetup);
  Application.CreateForm(TfMSGWIN, fMSGWIN);
  Application.CreateForm(TfPeerOrd, fPeerOrd);
  Application.CreateForm(TfNeedPass, fNeedPass);
  Application.CreateForm(TfUserinfo, fUserinfo);
  Application.CreateForm(TfAutoconnection, fAutoconnection);
  Application.CreateForm(Taddautouser, addautouser); }
  Application.Run;
end.
