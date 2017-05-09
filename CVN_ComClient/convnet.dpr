program convnet;


uses
  FastMM4,
  Forms,
  windows,
  Dialogs,
  clientUI in 'clientUI.pas' {fclientui},
  CVN_Protocol in '..\ConvnetCommfile\CVN_Protocol.pas',
  ClientStruct in 'ClientStruct.pas',
  CVN_CSYS in 'CVN_CSYS.pas',
  CVN_ClientChat in 'CVN_ClientChat.pas' {FClientChat},
  CVN_regist in 'CVN_regist.pas' {FRegist},
  CVN_CreateGroup in 'CVN_CreateGroup.pas' {Fcreategroup},
  CVN_FfindGroup in 'CVN_FfindGroup.pas' {FfindGroup},
  CVN_Ffinduser in 'CVN_Ffinduser.pas' {FfindUser},
  CVN_modifyGroupinfo in 'CVN_modifyGroupinfo.pas' {FModifyGroup},
  CVN_PrivateSetup in 'CVN_PrivateSetup.pas' {FPrivateSetup},
  CVN_ClientMSG in 'CVN_ClientMSG.pas',
  CVN_PeerOrd in 'CVN_PeerOrd.pas' {FPeerOrd},
  Winsock2 in 'Winsock2.pas',
  CVN_FConnectionPass in 'CVN_FConnectionPass.pas' {FNeedPass},
  CVN_fSnap in 'CVN_fSnap.pas' {FSnap},
  CVN_ViewUserInfo in 'CVN_ViewUserInfo.pas' {fUserinfo},
  CVN_FAutoconnection in 'CVN_FAutoconnection.pas' {FAutoconnection},
  CVN_faddautouser in 'CVN_faddautouser.pas' {Faddautouser},
  Crypt in 'Crypt.pas',
  CVN_messageWin in 'CVN_messageWin.pas' {FCVNMSG},
  StdIORedirect in 'StdIORedirect.pas',
  CVN_Remotecomm in 'CVN_Remotecomm.pas' {RmComm},
  StrConv in '..\ConvnetCommfile\StrConv.pas',
  CVN_MessageWindow in 'CVN_MessageWindow.pas' {fMSGWIN},
  CVN_GroupChat in 'CVN_GroupChat.pas' {groupChatForm},
  convnet_TLB in 'convnet_TLB.pas',
  Cvn_AutomaicServer in 'Cvn_AutomaicServer.pas' {convnetClient: CoClass};

{$R *.TLB}

{$R *.res}
{$R UAC.res }
begin


  if checkrunning then
  begin
    Application.Terminate;
    exit;
  end;

   SetThreadLocale(
    DWORD(Word(SORT_DEFAULT) shl 16) or
    DWORD(Word(SUBLANG_CHINESE_SIMPLIFIED) shl 10) or
    DWORD(Word(LANG_CHINESE))
    );

  Application.Initialize;

  Application.CreateForm(Tfclientui, fclientui);
  SetActiveLanguage(fclientui);

  Application.CreateForm(TfMSGWIN, fMSGWIN);
  Application.CreateForm(TfAutoconnection, fAutoconnection);
  Application.CreateForm(TfRegist, fRegist);
  Application.CreateForm(Tfcreategroup, fcreategroup);
  Application.CreateForm(TfindGroup, findGroup);
  Application.CreateForm(TfindUser, findUser);
  Application.CreateForm(TFModifyGroup, FModifyGroup);
  Application.CreateForm(TfPrivateSetup, fPrivateSetup);

  Application.CreateForm(TfPeerOrd, fPeerOrd);
  fpeerOrd.CVN_MSG:=TcvnMSG.Create;
  
  Application.CreateForm(TfNeedPass, fNeedPass);
  Application.CreateForm(TfUserinfo, fUserinfo);
  Application.CreateForm(Taddautouser, addautouser);
  Application.CreateForm(TFCVNMSG, FCVNMSG);


  //Application.CreateForm(TFrmMain, FrmMain);
  if fclientui.checkAutoLogin.Checked then
  begin
      application.ShowMainForm:=false;
      fclientui.blogin.Click;
  end;

  Application.Run;

  //ÊÍ·Å×ÊÔ´
  if assigned(fpeerOrd.CVN_MSG) then
  fpeerOrd.CVN_MSG.Free;


 
end.
