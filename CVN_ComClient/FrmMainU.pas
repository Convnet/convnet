unit FrmMainU;

interface
{$I define.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList, NTFireWall, ToolWin,
  {$IFDEF Delphi6} Variants, {$ENDIF}
  CheckLst, NetConfigLibTlb, FrmPortDetailsU, NetShell, DetectWinOs,cvn_csys;

type
  TFrmMain = class(TForm)
    pnlList: TPanel;
    lvConnections: TListView;
    ilConnections: TImageList;
    Splitter1: TSplitter;
    Panel1: TPanel;
    NTFireWall1: TNTFireWall;
    ToolBar: TToolBar;
    tlbRefresh: TToolButton;
    ilToolbar: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    pnlProperties: TPanel;
    lblConnection: TLabel;
    lblConnectionValue: TLabel;
    lblDevice: TLabel;
    lblDeviceValue: TLabel;
    lblMedia: TLabel;
    lblMediaValue: TLabel;
    lblStatus: TLabel;
    lblStatusValue: TLabel;
    lblShared: TLabel;
    chbShared: TCheckBox;
    lblFarewall: TLabel;
    chbFirewall: TCheckBox;
    Panel2: TPanel;
    clbIPPorts: TCheckListBox;
    pnlButtons: TPanel;
    pnlButtonsRight: TPanel;
    btnAddPort: TButton;
    btnDeletePort: TButton;
    Panel3: TPanel;
    lNetWork: TLabel;
    Image1: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tlbRefreshClick(Sender: TObject);
    procedure lvConnectionsClick(Sender: TObject);
    procedure clbIPPortsClick(Sender: TObject);
    procedure chbSharedClick(Sender: TObject);
    procedure chbFirewallClick(Sender: TObject);
    procedure lvConnectionsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnAddPortClick(Sender: TObject);
    procedure btnDeletePortClick(Sender: TObject);
    procedure clbIPPortsClickCheck(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure LoadConnections;
    procedure LoadConnectionProperties;
    procedure ClearPropertyPage;
    procedure SetCheckBoxValue(ACheckBox: TCheckBox; AValue: boolean);
    procedure LoadPortMappings;
    procedure SetButtonState;
    procedure AddPort;
    function isIPAddress(AText: string): boolean;
    procedure DeletePort;
    
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

function MediaTypeToString(AType: integer): string;
begin
  case AType of
    NCM_NONE:                 Result := 'None';
    NCM_DIRECT:               Result := 'Direct';
    NCM_ISDN:                 Result := 'ISDN';
    NCM_LAN:                  Result := 'LAN';
    NCM_PHONE:                Result := 'Phone';
    NCM_TUNNEL:               Result := 'Tunnel';
    NCM_PPPOE:                Result := 'Point-to-Point';
    NCM_BRIDGE:               Result := 'Bridge';
    NCM_SHAREDACCESSHOST_LAN: Result := 'Shared access host (LAN)';
    NCM_SHAREDACCESSHOST_RAS: Result := 'Shared access host (Remote access)';
    else Result := 'Unknown';
  end;
end;

function StatusToString(AStatus: integer): string;
begin
  case AStatus of
    NCS_DISCONNECTED:             Result := 'Disconnected';
    NCS_CONNECTING:               Result := 'Connecting';
    NCS_CONNECTED:                Result := 'Connected';
    NCS_DISCONNECTING:            Result := 'Disconnecting';
    NCS_HARDWARE_NOT_PRESENT:     Result := 'Hadware not present';
    NCS_HARDWARE_DISABLED:        Result := 'Hardware disabled';
    NCS_HARDWARE_MALFUNCTION:     Result := 'Hardware malfunction';
    NCS_MEDIA_DISCONNECTED:       Result := 'Media disconnected';
    NCS_AUTHENTICATING:           Result := 'Authenticating';
    NCS_AUTHENTICATION_SUCCEEDED: Result := 'Authentication succeeded';
    NCS_AUTHENTICATION_FAILED:    Result := 'Authentication failed';
    NCS_INVALID_ADDRESS:          Result := 'Invalid addres';
    NCS_CREDENTIALS_REQUIRED:     Result := 'Credentials required';
    else Result := 'Unknown';
  end;  
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  SetActiveLanguage(self);
  if not IsWindowsXPOrHigher then ShowMessage('本模块只能运行于XP或者更高版本的WINDOWS中.');
  LoadConnections;
end;

procedure TFrmMain.LoadConnections;
var
  i: integer;
  vItem: TListItem;
  vWasSelected: integer;
begin
  if lvConnections.Selected <> nil then
    vWasSelected := lvConnections.Selected.Index
    else vWasSelected := -1;

  lvConnections.Items.Clear;
  for i := 0 to NTFireWall1.Connections.Count - 1 do
  begin
    vItem := lvConnections.Items.Add();
    vItem.Caption := NTFireWall1.Connections[i].Name;
  end;

  if (vWasSelected <> - 1) and (vWasSelected < lvConnections.Items.Count) then
    lvConnections.Selected := lvConnections.Items[vWasSelected];

  if (lvConnections.Selected = nil) and (lvConnections.Items.Count > 0) then
    lvConnections.Selected := lvConnections.Items[0];
end;

procedure TFrmMain.ClearPropertyPage;
begin
  try
    lblConnectionValue.Caption := '';
    lblDeviceValue.Caption := '';
    lblMediaValue.Caption := '';
    lblStatusValue.Caption := '';
    SetCheckBoxValue(chbShared, false);
    SetCheckBoxValue(chbFirewall, false);
    clbIPPorts.Items.Clear;
    SetButtonState;
  except
  end;
end;

procedure TFrmMain.SetCheckBoxValue(ACheckBox: TCheckBox; AValue: boolean);
var
  vHandler: TNotifyEvent; 
begin
  vHandler := ACheckBox.OnClick;
  ACheckBox.OnClick := nil;
  try
    ACheckBox.Checked := AValue; 
  finally
    ACheckBox.OnClick := vHandler;
  end;
end;

procedure TFrmMain.LoadConnectionProperties;
var
  vConnection: TNTNetConnection;
begin
  if lvConnections.Selected = nil then
  begin
    ClearPropertyPage;
    Exit;
  end;
  try
  vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
  lblConnectionValue.Caption := vConnection.Name;
  lblDeviceValue.Caption := vConnection.DeviceName;
  lblMediaValue.Caption := MediaTypeToString(vConnection.MediaType);
  lblStatusValue.Caption := StatusToString(vConnection.Status);
  SetCheckBoxValue(chbShared, vConnection.SharingEnabled);
  SetCheckBoxValue(chbFirewall, vConnection.FirewallEnabled);
  LoadPortMappings;
  SetButtonState;
  except
  end;
end;

procedure TFrmMain.LoadPortMappings;
var
  vWasSelected: integer;
  vWasCursor: TCursor;
  vConnection: TNTNetConnection;
  i: integer;
begin
  vWasCursor   := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    vWasSelected := clbIPPorts.ItemIndex;
    clbIPPorts.Items.Clear;
    if lvConnections.Selected = nil then Exit;

    vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
    for i := 0 to vConnection.PortMappings.Count - 1 do
    begin
      clbIPPorts.Items.Add(vConnection.PortMappings[i].Name);
      clbIPPorts.Checked[clbIPPorts.Items.Count - 1] := vConnection.PortMappings[i].Enabled;
    end;

    if vWasSelected < clbIPPorts.Items.Count then clbIPPorts.ItemIndex := vWasSelected;
    if (clbIPPorts.ItemIndex = -1) and (clbIPPorts.Items.Count > 0) then clbIPPorts.ItemIndex := 0;
  finally
    Screen.Cursor := vWasCursor;
  end;

end;

procedure TFrmMain.tlbRefreshClick(Sender: TObject);
begin
  NTFireWall1.Refresh;
  LoadConnections;
  LoadConnectionProperties;
end;

procedure TFrmMain.lvConnectionsClick(Sender: TObject);
begin
  LoadConnectionProperties;
end;

procedure TFrmMain.SetButtonState;
var
  vConnection: TNTNetConnection;
  vPortMapping: TNTPortMapping;
begin
  btnAddPort.Enabled := (lvConnections.Selected <> nil) and chbFirewall.Checked;
//  btnDetails.Enabled := (lvConnections.Selected <> nil) and chbFirewall.Checked and (clbIPPorts.ItemIndex <> -1);
{  if btnDetails.Enabled then
  begin
    vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
    vPortMapping := vConnection.PortMappings[clbIPPorts.ItemIndex];
    btnDeletePort.Enabled := btnDetails.Enabled and (vPortMapping.TargetIPAddress <> '0.0.0.0');
  end;}
end;

procedure TFrmMain.clbIPPortsClick(Sender: TObject);
begin
  SetButtonState;
end;

procedure TFrmMain.chbSharedClick(Sender: TObject);
begin
  if lvConnections.Selected <> nil then
  try
    NTFireWall1.Connections[lvConnections.Selected.Index].SharingEnabled := chbShared.Checked;
  except
    SetCheckBoxValue(chbShared, not chbShared.Checked);
    raise;
  end;
end;

procedure TFrmMain.chbFirewallClick(Sender: TObject);
begin
  if lvConnections.Selected <> nil then
  begin
    NTFireWall1.Connections[lvConnections.Selected.Index].FirewallEnabled := chbFirewall.Checked;
    SetButtonState;
  end;
end;

procedure TFrmMain.lvConnectionsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  LoadConnectionProperties;
end;

procedure TFrmMain.btnAddPortClick(Sender: TObject);
begin
  AddPort;
end;

function TFrmMain.isIPAddress(AText: string): boolean;
var
  CharSet: set of char;
  i: integer;
  vDotCount: integer;
begin
  CharSet := ['0'..'9', '.'];
  vDotCount := 0;
  for i := 1 to Length(AText) do
  begin
    if not (AText[i] in CharSet) then Break;
    if AText[i] = '.' then Inc(vDotCount);
  end;
  Result := vDotCount = 3;
end;

procedure TFrmMain.AddPort;
var
  vForm: TFrmPortDetails;
  vConnection: TNTNetConnection;
  vProtocol: byte;
  vAddressType: cardinal;
begin
  if lvConnections.Selected = nil then Exit;
  vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];

  vForm := TFrmPortDetails.Create(nil);
  vForm.edtAddress.Text := NTFireWall1.LocalComputer;
  try
    while true do
    begin
      if vForm.ShowModal = mrOk then
      begin
        if vForm.rgrProtocol.ItemIndex = 0 then
          vProtocol := NAT_PROTOCOL_TCP else vProtocol := NAT_PROTOCOL_UDP;
        if isIPAddress(vForm.edtAddress.Text) then
          vAddressType := ICSTT_IPADDRESS else vAddressType := ICSTT_NAME;

        vConnection.PortMappings.Add(
             vForm.edtName.Text,
             vProtocol,
             StrToInt(vForm.edtExternalPort.Text),
             StrToInt(vForm.edtInternalPort.Text),
             0,
             vForm.edtAddress.Text,
             vAddressType);

        LoadPortMappings;
        Break;
      end else
      begin
        Break;
      end;
    end;
  finally
    vForm.Free;
  end;
end;

procedure TFrmMain.DeletePort;
var
  vConnection: TNTNetConnection;
  vPortMapping: TNTPortMapping;
  vStr: string;
begin
  if lvConnections.Selected = nil then Exit;
  if clbIPPorts.ItemIndex = -1 then Exit;
  vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
  vPortMapping := vConnection.PortMappings[clbIPPorts.ItemIndex];

  vStr := 'Port mapping "'+ vPortMapping.Name + '" will be deleted. Continue?';
  if Application.MessageBox(PChar(vStr), 'Confirmation', MB_YESNO) = IDYES then
  begin
    vPortMapping.Delete;
    LoadPortMappings;
  end;
end;

procedure TFrmMain.btnDeletePortClick(Sender: TObject);
begin
  DeletePort;
end;

procedure TFrmMain.clbIPPortsClickCheck(Sender: TObject);
var
  vConnection: TNTNetConnection;
  vPortMapping: TNTPortMapping;
begin
  if lvConnections.Selected = nil then Exit;
  if clbIPPorts.ItemIndex = -1 then Exit;
  vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
  vPortMapping := vConnection.PortMappings[clbIPPorts.ItemIndex];
  try
    vPortMapping.Enabled := clbIPPorts.Checked[clbIPPorts.ItemIndex];
  except
    clbIPPorts.Checked[clbIPPorts.ItemIndex] := vPortMapping.Enabled;
    raise;
  end;

end;

procedure TFrmMain.btnDetailsClick(Sender: TObject);
var
  vForm: TFrmPortDetails;
  vConnection: TNTNetConnection;
  vPortMapping: TNTPortMapping;
begin
  if lvConnections.Selected = nil then Exit;
  if clbIPPorts.ItemIndex = -1 then Exit;
  vConnection := NTFireWall1.Connections[lvConnections.Selected.Index];
  vPortMapping := vConnection.PortMappings[clbIPPorts.ItemIndex];

  vForm := TFrmPortDetails.Create(nil);
  try
    vForm.edtName.Text := vPortMapping.Name;
    vForm.edtExternalPort.Text := IntToStr(vPortMapping.ExternalPort);
    vForm.edtInternalPort.Text := IntToStr(vPortMapping.InternalPort);
    vForm.edtAddress.Text := vPortMapping.TargetIPAddress;
    if vPortMapping.IPProtocol = NAT_PROTOCOL_TCP then
      vForm.rgrProtocol.ItemIndex := 0
      else vForm.rgrProtocol.ItemIndex := 1;

    vForm.SetReadOnly;
    vForm.ShowModal;
  finally
    vForm.Free;
  end;

end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  close;
end;

end.
