{******************************************************************}
{                                                                  }
{       IpTest - IP Helper API Demonstration project               }
{                                                                  }
{ Portions created by Vladimir Vassiliev are                       }
{ Copyright (C) 2000 Vladimir Vassiliev.                           }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: IpUnit1.pas, released  December 2000.      }
{ The initial developer of the Pascal code is Vladimir Vassiliev   }
{ (voldemarv@hotpop.com).                                          }
{ 								   }
{ Contributor(s): Marcel van Brakel (brakelm@bart.nl)              }
{                 John Penman (jcp@craiglockhart.com)              }
{                                                                  }
{ Obtained through:                                                }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org or Vladimir's  }
{ website at http://voldemarv.virtualave.net                       }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/NPL/NPL-1_1Final.html                     }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}

unit IpUnit1;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  WinSock,
  IpThread,
  ExtCtrls;

const
  WM_ThreadDoneMsg = WM_User + 1;

type
  TFmIpTest = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    BtNetworkParams: TButton;
    TabSheet2: TTabSheet;
    BtGetAdaptersInfo: TButton;
    BtGetAdapterIndex: TButton;
    BtGetUniDirAdapterInfo: TButton;
    TabSheet3: TTabSheet;
    BtGetNumberOfInterfaces: TButton;
    BtGetInterfaceInfo: TButton;
    BtGetFriendlyIfIndex: TButton;
    BtGetIfTable: TButton;
    BtGetIfEntry: TButton;
    BtSetIfEntry: TButton;
    TabSheet4: TTabSheet;
    BGetIpAddrTable: TButton;
    BtAddIPAddress: TButton;
    BtDeleteIPAddress: TButton;
    BtIpReleaseAddress: TButton;
    BtIpRenewAddress: TButton;
    TabSheet5: TTabSheet;
    BtGetIpNetTable: TButton;
    BtDeleteProxyArpEntry: TButton;
    BtCreateProxyArpEntry: TButton;
    BtFlushIpNetTable: TButton;
    BtDeleteIpNetEntry: TButton;
    BtCreateIpNetEntry: TButton;
    BtSendARP: TButton;
    TabSheet6: TTabSheet;
    BtGetIpStatistics: TButton;
    BtGetIcmpStatistics: TButton;
    BtSetIpStatistics: TButton;
    BtSetIpTTL: TButton;
    TabSheet7: TTabSheet;
    BtCreateIpForwardEntry: TButton;
    BtDeleteIpForwardEntry: TButton;
    BtSetIpForwardEntry: TButton;
    BtGetIpForwardTable: TButton;
    BtGetBestRoute: TButton;
    BtGetBestInterface: TButton;
    BtGetRTTAndHopCount: TButton;
    TabSheet8: TTabSheet;
    BtNotifyAddrChange: TButton;
    BtNotifyRouteChange: TButton;
    TabSheet9: TTabSheet;
    BtGetTcpStatistics: TButton;
    BtGetUdpStatistics: TButton;
    BtGetTcpTable: TButton;
    BtGetUdpTable: TButton;
    BtSetTcpEntry: TButton;
    TabSheet10: TTabSheet;
    BtEnableRouter: TButton;
    BtUnenableRouter: TButton;
    BtCancelNotifyAddrChange: TButton;
    BtCancelNotifyRouteChange: TButton;
    Splitter1: TSplitter;
    procedure BtNetworkParamsClick(Sender: TObject);
    procedure BtGetAdaptersInfoClick(Sender: TObject);
    procedure BtGetAdapterIndexClick(Sender: TObject);
    procedure BtGetUniDirAdapterInfoClick(Sender: TObject);
    procedure BtGetNumberOfInterfacesClick(Sender: TObject);
    procedure BtGetInterfaceInfoClick(Sender: TObject);
    procedure BtGetFriendlyIfIndexClick(Sender: TObject);
    procedure BtGetIfTableClick(Sender: TObject);
    procedure BtGetIfEntryClick(Sender: TObject);
    procedure BtSetIfEntryClick(Sender: TObject);
    procedure BGetIpAddrTableClick(Sender: TObject);
    procedure BtAddIPAddressClick(Sender: TObject);
    procedure BtDeleteIPAddressClick(Sender: TObject);
    procedure BtIpReleaseAddressClick(Sender: TObject);
    procedure BtIpRenewAddressClick(Sender: TObject);
    procedure BtGetIpNetTableClick(Sender: TObject);
    procedure BtCreateIpNetEntryClick(Sender: TObject);
    procedure BtDeleteIpNetEntryClick(Sender: TObject);
    procedure BtFlushIpNetTableClick(Sender: TObject);
    procedure BtCreateProxyArpEntryClick(Sender: TObject);
    procedure BtDeleteProxyArpEntryClick(Sender: TObject);
    procedure BtSendARPClick(Sender: TObject);
    procedure BtGetIpStatisticsClick(Sender: TObject);
    procedure BtGetIcmpStatisticsClick(Sender: TObject);
    procedure BtSetIpStatisticsClick(Sender: TObject);
    procedure BtSetIpTTLClick(Sender: TObject);
    procedure BtGetIpForwardTableClick(Sender: TObject);
    procedure BtCreateIpForwardEntryClick(Sender: TObject);
    procedure BtDeleteIpForwardEntryClick(Sender: TObject);
    procedure BtSetIpForwardEntryClick(Sender: TObject);
    procedure BtGetBestRouteClick(Sender: TObject);
    procedure BtGetBestInterfaceClick(Sender: TObject);
    procedure BtGetRTTAndHopCountClick(Sender: TObject);
    procedure BtNotifyAddrChangeClick(Sender: TObject);
    procedure BtNotifyRouteChangeClick(Sender: TObject);
    procedure BtGetTcpStatisticsClick(Sender: TObject);
    procedure BtGetUdpStatisticsClick(Sender: TObject);
    procedure BtGetTcpTableClick(Sender: TObject);
    procedure BtGetUdpTableClick(Sender: TObject);
    procedure BtSetTcpEntryClick(Sender: TObject);
    procedure BtEnableRouterClick(Sender: TObject);
    procedure BtUnenableRouterClick(Sender: TObject);
    procedure BtCancelNotifyAddrChangeClick(Sender: TObject);
    procedure BtCancelNotifyRouteChangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ThreadDone(var AMessage : TMessage); message WM_ThreadDoneMsg; // Message to be sent back from thread when its done
  public
    { Public declarations }
  end;

var
  FmIpTest: TFmIpTest;
  IOHandle: THandle;
  RouterHandle: THandle;
  Overlapped: TOverlapped;
  AddressWaitingThread, RouteWaitingThread: TWaitingThread;

implementation

uses
  IPExport,
  IPHlpApi,
  Iprtrmib,
  IpTypes,
  IpFunctions;

{$R *.DFM}

function IpAddressToString(Addr: DWORD): string;
var
  InAddr: TInAddr;
begin
  InAddr.S_addr := Addr;
  Result := inet_ntoa(InAddr);
end;

procedure TFmIpTest.BtNetworkParamsClick(Sender: TObject);
var
  PFixed: PFixedInfo;
  PDnsServer: PIpAddrString;
  OutBufLen: ULONG;
begin
  Memo1.Lines.Add('GetNetworkParams');
  VVGetNetworkParams(PFixed, OutBufLen);
  if PFixed <> nil then
    with PFixed^, Memo1.Lines do
    begin
      Add('HostName:' + HostName);
      Add('DomainName:' + DomainName);
      Add('NodeType:' + IntToStr(NodeType));
      Add('ScopeId:' + ScopeId);
      Add('EnableRouting:' + IntToStr(EnableRouting));
      Add('EnableProxy:' + IntToStr(EnableProxy));
      Add('EnableDns:' + IntToStr(EnableDns));
      if CurrentDnsServer <> nil then
      begin
        Add('CurrentDnsServer Address:' + CurrentDnsServer^.IpAddress.S);
        Add('CurrentDnsServer Mask:' + CurrentDnsServer^.IpMask.S);
      end
      else
        Add('CurrentDnsServer: nil');
      Add('DnsServer Address:' + DnsServerList.IpAddress.S);
      Add('DnsServer Mask:' + DnsServerList.IpMask.S);


      PDnsServer := DnsServerList.Next;
      while PDnsServer <> nil do
      begin
        Add('DnsServer Address:' + PDnsServer^.IpAddress.S);
        Add('DnsServer Mask:' + PDnsServer^.IpMask.S);
        PDnsServer := PDnsServer.Next;
      end;
      Freemem(PFixed, OutBufLen);
    end;
end;

procedure TFmIpTest.BtGetAdaptersInfoClick(Sender: TObject);
var
  PAdapter, PMem: PipAdapterInfo;
  pPerAdapter: PIpPerAdapterInfo;
  PIPAddr: PIpAddrString;
  OutBufLen, OutBufLen2: ULONG;
  s: string;
  i: integer;
begin
  memo1.Lines.Add('---------------------------------------');
  Memo1.Lines.Add('GetAdaptersInfo');
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem := PAdapter;
  try
    while PAdapter <> nil do
      with Memo1.Lines do
      begin
        Add('AdapterName: ' + PAdapter.AdapterName);
        Add('Description: ' + PAdapter.Description);
        s := '';
        for i := 0 to PAdapter.AddressLength do
          s := s + Format('%1d', [PAdapter.Address[i]]);
        Add('Index: ' + IntToStr(PAdapter.Index));
        Add('Type: ' + IntToStr(PAdapter.Type_));
        Add('DhcpEnabled: ' + IntToStr(PAdapter.DhcpEnabled));
        if PAdapter.CurrentIpAddress <> nil then
        begin
          Add('CurrentIpAddress.IpAddress:' + PAdapter.CurrentIpAddress.IpAddress.S);
          Add('CurrentIpAddress.IpMask:' + PAdapter.CurrentIpAddress.IpMask.S);
        end
        else
          Add('CurrentIpAddress: nil');
        PIPAddr := @PAdapter.IpAddressList;
        repeat
          Add('-----------');
          Add('IpAddressList.IpAddress ' + PIPAddr.IpAddress.S);
          Add('IpAddressList.IpMask ' + PIPAddr.IpMask.S);
          PIPAddr := PIPAddr.Next;
        until PIPAddr = nil;
        Add('-----------');
        try
          Memo1.Lines.Add('GetPerAdapterInfo');
          VVGetPerAdapterInfo(PAdapter.Index, pPerAdapter,OutBufLen2);
          if pPerAdapter <> nil then
            try
              Add('AutoconfigEnabled: ' + IntToStr(pPerAdapter.AutoconfigEnabled));
              Add('AutoconfigActive: ' + IntToStr(pPerAdapter.AutoconfigActive));
              PIPAddr := pPerAdapter.CurrentDnsServer;
              if not Assigned(PIPAddr) then
                Add('CurrentDnsServer: nil');
              while Assigned(PIPAddr) do
              begin
                Add('CurrentDnsServer.IpAddress: ' + PIPAddr^.IpAddress.S);
                Add('CurrentDnsServer.IpMask: ' + PIPAddr^.IpMask.S);
                PIPAddr := PIPAddr.Next;
              end;
              PIPAddr := @pPerAdapter.DnsServerList;
              while Assigned(PIPAddr) do
              begin
                Add('DnsServerList.IpAddress: ' + pPerAdapter.DnsServerList.IpAddress.S);
                Add('DnsServerList.IpMask: ' + pPerAdapter.DnsServerList.IpMask.S);
                PIPAddr := PIPAddr.Next;
              end;
            finally
              Freemem(pPerAdapter,OutBufLen2);
            end;
        except
          on E:EIpHlpError do
            ShowMessage(E.Message);
        end;
        PAdapter := PAdapter.Next;
      end;
  finally
    if PAdapter <> nil then
      Freemem(PMem, OutBufLen);
  end;
  Memo1.Lines.Add('--------------------------------------');
end;

procedure TFmIpTest.BtGetAdapterIndexClick(Sender: TObject);
var
  IfIndex: Cardinal;
  s: string;
  p:PwideChar;
begin
  Memo1.Lines.Add('GetAdapterIndex');
  s := InputBox('Query', 'Input the name of adapter', '');
  if s = '' then
    Exit;
  getmem(P, length(s) * 2 + 1);
  StringToWideChar(S, P, length(s) + 1);
  try
    VVGetAdapterIndex(P,IfIndex);
  finally
    Freemem(P);
  end;
  Memo1.Lines.Add('AdapterIndex: ' + IntToStr(IfIndex));
end;

procedure TFmIpTest.BtGetUniDirAdapterInfoClick(Sender: TObject);
var
  p: PIpUnidirectionalAdapterAddress;
  OutBufLen: Cardinal;
begin
  Memo1.Lines.Add('GetUniDirectionalAdapterInfo');
  VVGetUniDirectionalAdapterInfo(p, OutBufLen);
  if p <> nil then
    try
      Memo1.Lines.Add('Number of UniDirectional adapters: ' + IntToStr(p.NumAdapters));
    finally
      Freemem(P);
    end;
end;

procedure TFmIpTest.BtGetNumberOfInterfacesClick(Sender: TObject);
var
  NumIf: DWord;
begin
  Memo1.Lines.Add('GetNumberOfInterfaces');
  NumIf := VVGetNumberOfInterfaces;
  Memo1.Lines.Add('Number Of Interfaces: ' + IntToStr(NumIf));
end;

procedure TFmIpTest.BtGetInterfaceInfoClick(Sender: TObject);
var
  p: PIpInterfaceInfo;
  OutBufLen :Cardinal;
  i: integer;
begin
  Memo1.Lines.Add('GetInterfaceInfo');
  VVGetInterfaceInfo(p, OutBufLen);
  if p <> nil then
    try
      Memo1.Lines.Add('Number of adapters: ' + IntToStr(p.NumAdapters));
      for i := 0 to p^.NumAdapters-1 do
      begin
        Memo1.Lines.Add('Adapter N ' + IntToStr(i + 1));
        Memo1.Lines.Add(' Name: ' + p^.Adapter[i].Name);
        Memo1.Lines.Add(' Index: ' + IntToStr(p^.Adapter[i].Index));
      end;
    finally
      Freemem(P);
    end;
end;

procedure TFmIpTest.BtGetFriendlyIfIndexClick(Sender: TObject);
var
  IfIndex,FriendlyIndex: DWORD;
  s: string;
begin
  Memo1.Lines.Add('GetFriendlyIfIndex');
  s := InputBox('Query', 'Input interface index', '');
  if s='' then
    Exit;
  IfIndex := StrToInt(s);
  FriendlyIndex := VVGetFriendlyIfIndex(IfIndex);
  Memo1.Lines.Add('FriendlyIfIndex: ' + IntToStr(FriendlyIndex));
end;

procedure TFmIpTest.BtGetIfTableClick(Sender: TObject);
var
  p: PMibIfTable;
  Size: Cardinal;
  i,j: integer;
  s: string;
begin
  Memo1.Lines.Add('GetIfTable');
  VVGetIfTable(p,Size,True);
  if p <> nil then
    try
      Memo1.Lines.Add('Number of entries: ' + IntToStr(p^.dwNumEntries));
      for i := 0 to p^.dwNumEntries-1 do
        with p^.table[i] do
        begin
          Memo1.Lines.Add('     Index Type   Mtu      Speed Admin');
          Memo1.Lines.Add(Format('%10d %4d %5d %10d %5d', [dwIndex, dwType, dwMtu,
            dwSpeed, dwAdminStatus]));
          s := '';
          for j := 0 to p^.table[i].dwDescrLen-1 do
            s := s + Chr(p^.table[i].bDescr[j]);
          Memo1.Lines.Add(' Description: ' + s);
        end;
    finally
      FreeMem(p, size);
    end;
end;

procedure TFmIpTest.BtGetIfEntryClick(Sender: TObject);
var
  IfRow: TMibIfRow;
  IfIndex, j: integer;
  s: string;
begin
  FillChar(IfRow,sizeof(IfRow),#0);
  Memo1.Lines.Add('GetIfEntry');
  s := InputBox('Query', 'Input interface index', '');
  if s='' then
    Exit;
  IfIndex := StrToInt(s);
  IfRow.dwIndex := IfIndex;
  VVGetIfEntry(@IfRow);
  with Memo1.Lines, IfRow do
  begin
    Add('     Index Type   Mtu      Speed Admin');
    Add(Format('%10d %4d %5d %10d %5d', [dwIndex, dwType, dwMtu, dwSpeed,
      dwAdminStatus]));
    s := '';
    for j := 0 to dwDescrLen-1 do
      s := s + Chr(bDescr[j]);
    Add(' Description: ' + s);
  end;
end;

procedure TFmIpTest.BtSetIfEntryClick(Sender: TObject);
var
  IfRow: TMibIfRow;
  IfIndex, j: integer;
  s: string;
begin
  FillChar(IfRow,sizeof(IfRow),#0);
  Memo1.Lines.Add('SetIfEntry');
  s := InputBox('Query', 'Input interface index', '');
  if s='' then
    Exit;
  IfIndex := StrToInt(s);
  s := '0';
  s := InputBox('Query', 'Input interface admin status (0 - down, 1- up)', '');
  if s='' then
    Exit;
  IfRow.dwIndex := IfIndex;
  IfRow.dwAdminStatus := StrToInt(s);
  VVSetIfEntry(IfRow);
  VVGetIfEntry(@IfRow);
  with Memo1.Lines, IfRow do
  begin
    Add('     Index Type   Mtu      Speed Admin');
    Add(Format('%10d %4d %5d %10d %5d', [dwIndex, dwType, dwMtu, dwSpeed,
      dwAdminStatus]));
    s := '';
    for j := 0 to dwDescrLen-1 do
      s := s + Chr(bDescr[j]);
    Add(' Description: ' + s);
  end;
end;

procedure TFmIpTest.BGetIpAddrTableClick(Sender: TObject);
var
  Size: ULONG;
  p: PMibIpAddrTable;
  i: integer;
begin
  Memo1.Lines.Add('GetIpAddrTable');
  VVGetIpAddrTable(p, Size, True);
  if p <> nil then
    try
      with p^, Memo1.Lines do
      begin
        Add('NumEntries:' + IntToStr(dwNumEntries));
        Add('Adapter N            Addr            Mask       BCastAddr ReasmSize');
        for i := 0 to dwNumEntries-1 do

          with table[i] do
            Add(Format('%10d %15s %15s %15s %d', [dwIndex,
              IpAddressToString(dwAddr), IpAddressToString(dwMask),
              IpAddressToString(dwBCastAddr), dwReasmSize]));

      end;
    finally
      FreeMem(p);
    end;
end;

procedure TFmIpTest.BtAddIPAddressClick(Sender: TObject);
var
  NTEContext, NTEInstance: ULONG;
  Address: IPAddr;
  Mask: IpMask;
  IfIndex: DWORD;
  s:string;
begin
  Memo1.Lines.Add('AddIPAddress');
  s := InputBox('Query', 'Input adapter index', '');
  if s='' then
    Exit;
  IfIndex := StrToInt(s);
  NTEContext := 0;
  NTEInstance := 0;
  s := InputBox('Query', 'Input new adapter IP address', '');
  if s='' then
    Exit;
  Address := inet_addr(PChar(s));
  s := InputBox('Query', 'Input new adapter IP mask', '');
  if s='' then
    Exit;
  Mask := inet_addr(PChar(s));

  VVAddIPAddress(Address, Mask, IfIndex, NTEContext, NTEInstance);
  Memo1.Lines.Add('NTEContext: ' + IntToStr(NTEContext));
  Memo1.Lines.Add('NTEInstance: ' + IntToStr(NTEInstance));
end;

procedure TFmIpTest.BtDeleteIPAddressClick(Sender: TObject);
var
  NTEContext: ULONG;
  s:string;
begin
  Memo1.Lines.Add('DeleteIPAddress');
  s := InputBox('Query', 'Input NTEContext', '');
  if s='' then
    Exit;
  NTEContext := StrToInt(s);
  VVDeleteIPAddress(NTEContext);
  Memo1.Lines.Add('Delete successful.');
end;

procedure TFmIpTest.BtIpReleaseAddressClick(Sender: TObject);
var
  AdapterInfo: TIpAdapterIndexMap;
  s: string;
  sw: PWideChar;
begin
  Memo1.Lines.Add('IpReleaseAddress');
  s := InputBox('Query', 'Input adapter index', '');
  if s='' then
    Exit;
  AdapterInfo.Index := StrToInt(s);
  FillChar(AdapterInfo.Name, sizeof(AdapterInfo.Name), #0);
  s := InputBox('Query', 'Input adapter name', '');
  GetMem(sw, 2 * length(s) + 1);
  try
    StringToWideChar(S, Sw, length(s) * 2 + 1);
    Move(sw^,AdapterInfo.Name, length(s) * 2 + 1);
  finally
    FreeMem(sw);
  end;
  VVIpReleaseAddress(AdapterInfo);
  Memo1.Lines.Add('Release successful.');
end;

procedure TFmIpTest.BtIpRenewAddressClick(Sender: TObject);
var
  AdapterInfo: TIpAdapterIndexMap;
  s:string;
  sw: PWideChar;
begin
  s := InputBox('Query', 'Input adapter index', '');
  if s='' then
    Exit;
  AdapterInfo.Index := StrToInt(s);
  FillChar(AdapterInfo.Name, sizeof(AdapterInfo.Name), #0);
  s := InputBox('Query', 'Input adapter name', '');
  if s = '' then
    Exit;
  GetMem(sw, 2 * length(s) + 1);
  try
    StringToWideChar(S,Sw,length(s) * 2 + 1);
    Move(sw^,AdapterInfo.Name, length(s) * 2 + 1);
  finally
    FreeMem(sw);
  end;
  VVIpRenewAddress(AdapterInfo);
end;

procedure TFmIpTest.BtGetIpNetTableClick(Sender: TObject);
var
  Size: ULONG;
  p: PMibIpNetTable;
  i,j: integer;
  s: string;
begin
  Memo1.Lines.Add('GetIpNetTable');
  VVGetIpNetTable(p, Size, True);
  if p <> nil then
    try
      with p^,Memo1.Lines do
      begin
        Add('NumEntries:' + IntToStr(dwNumEntries));
        for i := 0 to dwNumEntries-1 do
          with table[i] do
          begin
            Add('Adapter N ' + IntToStr(dwIndex));
            s := '';
            for j := 0 to dwPhysAddrLen-1 do
              s := s + IntToStr(bPhysAddr[j]);
            Add('Phys. address: ' + s);
            Add('Address: ' + IpAddressToString(dwAddr) + ' type: ' +
              IntToStr(dwType));
          end;
      end;
    finally
      FreeMem(p);
    end;
end;

procedure TFmIpTest.BtCreateIpNetEntryClick(Sender: TObject);
var
  Size: ULONG;
  p: PMibIpNetTable;
  NetRow: TMibIpNetRow;
  j: integer;
  s: string;
begin
  VVGetIpNetTable(p, Size, True);
  with NetRow do
  begin
    dwIndex := p^.dwNumEntries + 1;
    dwPhysAddrLen := p^.table[0].dwPhysAddrLen;
    for j := 0 to p^.table[0].dwPhysAddrLen-1 do
      bPhysAddr[j] := p^.table[0].bPhysAddr[j];
      s := InputBox('Query', 'Input adapter IP address', '');
      if s = '' then
        Exit;
      dwAddr := inet_addr(PChar(s));
      dwType := p^.table[0].dwType;
  end;
  VVCreateIpNetEntry(NetRow);
  Memo1.Lines.Add('CreateIpNetEntry successful.');
end;

procedure TFmIpTest.BtDeleteIpNetEntryClick(Sender: TObject);
var
  NetRow: TMibIpNetRow;
  s: string;
begin
  with NetRow do
  begin
    s := InputBox('Query', 'Input adapter index', '');
    if s='' then
      Exit;
    dwIndex := StrToInt(s);
    s := InputBox('Query', 'Input adapter address', '');
    if s='' then
      Exit;
    dwAddr := inet_addr(PChar(s));
  end;
  VVDeleteIpNetEntry(NetRow);
  Memo1.Lines.Add('DeleteIpNetEntry successful.');
end;

procedure TFmIpTest.BtFlushIpNetTableClick(Sender: TObject);
var
  dwIfIndex: DWORD;
  s: string;
begin
  s := InputBox('Query', 'Input adapter index', '');
  if s='' then
    Exit;
  dwIfIndex := StrToInt(s);
  VVFlushIpNetTable(dwIfIndex);
  Memo1.Lines.Add('FlushIpNetTable successful.');
end;

procedure TFmIpTest.BtCreateProxyArpEntryClick(Sender: TObject);
var
  dwAddress, dwMask, dwIfIndex: DWORD;
  s: string;
begin
  Memo1.Lines.Add('CreateProxyArpEntry');
  s := InputBox('Query', 'Input adapter IP address', '');
  if s='' then
    Exit;
  dwAddress := inet_addr(PChar(s));
  s := InputBox('Query', 'Input adapter IP mask', '');
  if s='' then
    Exit;
  dwMask := inet_addr(PChar(s));
  dwIfIndex := 1;
  VVCreateProxyArpEntry(dwAddress, dwMask, dwIfIndex);
end;

procedure TFmIpTest.BtDeleteProxyArpEntryClick(Sender: TObject);
var
 dwAddress, dwMask, dwIfIndex: DWORD;
 s: string;
begin
 Memo1.Lines.Add('DeleteProxyArpEntry');
  s := InputBox('Query', 'Input adapter IP address', '');
  if s='' then
    Exit;
  dwAddress := inet_addr(PChar(s));
  s := InputBox('Query', 'Input adapter IP mask', '');
  if s='' then
    Exit;
  dwMask := inet_addr(PChar(s));
 dwIfIndex := 1;
 VVDeleteProxyArpEntry(dwAddress, dwMask, dwIfIndex);
end;

procedure TFmIpTest.BtSendARPClick(Sender: TObject);
var
  DestIP, SrcIP: IPAddr;
  pMacAddr: PULong;
  AddrLen: ULong;
  MacAddr: array[0..5] of byte;
  p: PByte;
  s: string;
  i: integer;
begin
  Memo1.Lines.Add('SendARP');
  SrcIp := 0;
  s := '';
  InputQuery('Query','Input destination IP',s);
  DestIP := inet_addr(PChar(s));
  pMacAddr := @MacAddr[0];
  AddrLen := SizeOf(MacAddr);
  VVSendARP(DestIP, SrcIP, pMacAddr, AddrLen);
  s := 'MacAddr :';
  p := PByte(pMacAddr);
  if Assigned(p) and (AddrLen>0) then
    for i := 0 to AddrLen-1 do
    begin
      s := s + IntToHex(p^,2) + '-';
      Inc(p);
    end;
  SetLength(s, length(s)-1);
  Memo1.Lines.Add(s);
end;

procedure TFmIpTest.BtGetIpStatisticsClick(Sender: TObject);
var
  Stats: TMibIpStats;
begin
  Memo1.Lines.Add('GetIpStatistics');
  VVGetIpStatistics(Stats);
  with Memo1.Lines, Stats do
  begin
    Add(' dwForwarding: ' + IntToStr(dwForwarding));
    Add(' dwInReceives: ' + IntToStr(dwInReceives));
    Add(' dwDefaultTTL: ' + IntToStr(dwDefaultTTL));
    Add(' dwInReceives: ' + IntToStr(dwInReceives));
    Add(' dwInHdrErrors: ' + IntToStr(dwInHdrErrors));
    Add(' dwInAddrErrors: ' + IntToStr(dwInAddrErrors));
    Add(' dwForwDatagrams: ' + IntToStr(dwForwDatagrams));
    Add(' dwInUnknownProtos: ' + IntToStr(dwInUnknownProtos));
    Add(' dwInDiscards: ' + IntToStr(dwInDiscards));
    Add(' dwInDelivers: ' + IntToStr(dwInDelivers));
    Add(' dwOutRequests: ' + IntToStr(dwOutRequests));
    Add(' dwRoutingDiscards: ' + IntToStr(dwRoutingDiscards));
    Add(' dwOutDiscards: ' + IntToStr(dwOutDiscards));
    Add(' dwOutNoRoutes: ' + IntToStr(dwOutNoRoutes));
    Add(' dwReasmTimeout: ' + IntToStr(dwReasmTimeout));
    Add(' dwReasmReqds: ' + IntToStr(dwReasmReqds));
    Add(' dwReasmOks: ' + IntToStr(dwReasmOks));
    Add(' dwReasmFails: ' + IntToStr(dwReasmFails));
    Add(' dwFragOks: ' + IntToStr(dwFragOks));
    Add(' dwFragFails: ' + IntToStr(dwFragFails));
    Add(' dwFragCreates: ' + IntToStr(dwFragCreates));
    Add(' dwNumIf: ' + IntToStr(dwNumIf));
    Add(' dwNumAddr: ' + IntToStr(dwNumAddr));
    Add(' dwNumRoutes: ' + IntToStr(dwNumRoutes));
  end;
end;

procedure TFmIpTest.BtGetIcmpStatisticsClick(Sender: TObject);
var
  Stats: TMibIcmp;
begin
  Memo1.Lines.Add('GetIcmpStatistics');
  VVGetIcmpStatistics(Stats);
  with Memo1.Lines, Stats.stats do
  begin
    Add(' InStats');
    Add(' dwMsgs: ' + IntToStr(icmpInStats.dwMsgs));
    Add(' dwErrors: ' + IntToStr(icmpInStats.dwErrors));
    Add(' dwDestUnreachs: ' + IntToStr(icmpInStats.dwDestUnreachs));
    Add(' dwTimeExcds: ' + IntToStr(icmpInStats.dwTimeExcds));
    Add(' dwParmProbs: ' + IntToStr(icmpInStats.dwParmProbs));
    Add(' dwSrcQuenchs: ' + IntToStr(icmpInStats.dwSrcQuenchs));
    Add(' dwRedirects: ' + IntToStr(icmpInStats.dwRedirects));
    Add(' dwEchos: ' + IntToStr(icmpInStats.dwEchos));
    Add(' dwEchoReps: ' + IntToStr(icmpInStats.dwEchoReps));
    Add(' dwTimestamps: ' + IntToStr(icmpInStats.dwTimestamps));
    Add(' dwTimestampReps: ' + IntToStr(icmpInStats.dwTimestampReps));
    Add(' dwAddrMasks: ' + IntToStr(icmpInStats.dwAddrMasks));
    Add(' dwAddrMaskReps: ' + IntToStr(icmpInStats.dwAddrMaskReps));
    Add(' OutStats');
    Add(' dwMsgs: ' + IntToStr(icmpOutStats.dwMsgs));
    Add(' dwErrors: ' + IntToStr(icmpOutStats.dwErrors));
    Add(' dwDestUnreachs: ' + IntToStr(icmpOutStats.dwDestUnreachs));
    Add(' dwTimeExcds: ' + IntToStr(icmpOutStats.dwTimeExcds));
    Add(' dwParmProbs: ' + IntToStr(icmpOutStats.dwParmProbs));
    Add(' dwSrcQuenchs: ' + IntToStr(icmpOutStats.dwSrcQuenchs));
    Add(' dwRedirects: ' + IntToStr(icmpOutStats.dwRedirects));
    Add(' dwEchos: ' + IntToStr(icmpOutStats.dwEchos));
    Add(' dwEchoReps: ' + IntToStr(icmpOutStats.dwEchoReps));
    Add(' dwTimestamps: ' + IntToStr(icmpOutStats.dwTimestamps));
    Add(' dwTimestampReps: ' + IntToStr(icmpOutStats.dwTimestampReps));
    Add(' dwAddrMasks: ' + IntToStr(icmpOutStats.dwAddrMasks));
    Add(' dwAddrMaskReps: ' + IntToStr(icmpOutStats.dwAddrMaskReps));
  end;
end;

procedure TFmIpTest.BtSetIpStatisticsClick(Sender: TObject);
var
  IpStats: TMibIpStats;
  s: string;
begin
  Memo1.Lines.Add('GetIpStatistics');
  VVGetIpStatistics(IpStats);
  IpStats.dwForwarding := 2;
  s := InputBox('Query', 'Input new TTL', '');
  if s = '' then
    Exit;
  IpStats.dwDefaultTTL := StrToInt(s);
  Memo1.Lines.Add('SetIpStatistics');
  VVSetIpStatistics(IpStats);
end;

procedure TFmIpTest.BtSetIpTTLClick(Sender: TObject);
var
  nTTL: UINT;
  s: string;
begin
  Memo1.Lines.Add('SetIpTTL');
  s := InputBox('Query', 'Input new TTL', '');
  if s='' then
    Exit;
  nTTL := StrToInt(s);
  VVSetIpTTL(nTTL);
end;

procedure TFmIpTest.BtGetIpForwardTableClick(Sender: TObject);
var
  pIpForwardTable: PMibIpForwardTable;
  Size: Cardinal;
  i: integer;
begin
  Memo1.Lines.Add('GetIpForwardTable');
  VVGetIpForwardTable(pIpForwardTable,Size,True);
  if pIpForwardTable <> nil then
    try
      Memo1.Lines.Add(' dwNumEntries:' + IntToStr(pIpForwardTable^.dwNumEntries));
      Memo1.Lines.Add('     Destination            Mask Policy         Gateway Interface       Age Metric');
      for i := 0 to pIpForwardTable^.dwNumEntries-1 do
      with pIpForwardTable^.table[i], Memo1.Lines do
      begin
        Add(Format(' %15s %15s %6d %15s %9d %10d %2d %2d %2d %2d %2d',
          [IpAddressToString(dwForwardDest),
          IpAddressToString(dwForwardMask), dwForwardPolicy,
          IpAddressToString(dwForwardNextHop), dwForwardIfIndex, dwForwardAge,
          dwForwardMetric1, dwForwardMetric2, dwForwardMetric3, dwForwardMetric4,
          dwForwardMetric5]));
      end;
    finally
      FreeMem(pIpForwardTable,Size);
    end;
end;

procedure TFmIpTest.BtCreateIpForwardEntryClick(Sender: TObject);
var
  Route: TMibIpForwardRow;
  s: string;
begin
  FillChar(Route, SizeOf(Route), #0);
  with Route do
  begin
    if not InputQuery('Query','Input destination address', s) then
      Exit;
    dwForwardDest := inet_addr(pchar(s));
    if not InputQuery('Query','Input Mask', s) then
      Exit;
    dwForwardMask := inet_addr(pchar(s));
    dwForwardPolicy := 0;
    if not InputQuery('Query','Next Hop', s) then
      Exit;
    dwForwardNextHop := inet_addr(pchar(s));
    if not InputQuery('Query','Interface index', s) then
      Exit;
    dwForwardIfIndex := StrToInt(s);
    dwForwardType := 3;
    dwForwardProto := 2;
    dwForwardAge := 0;
    dwForwardNextHopAS := 0;
    dwForwardMetric1 := 1;
    dwForwardMetric2 := DWORD(-1);
    dwForwardMetric3 := DWORD(-1);
    dwForwardMetric4 := DWORD(-1);
    dwForwardMetric5 := DWORD(-1);
  end;
  Memo1.Lines.Add('CreateIpForwardEntry');
  VVCreateIpForwardEntry(@Route);
  Memo1.Lines.Add('Success');
end;

procedure TFmIpTest.BtDeleteIpForwardEntryClick(Sender: TObject);
var
  pIpForwardTable: PMibIpForwardTable;
  N,Size: Cardinal;
  s: string;
begin
  VVGetIpForwardTable(pIpForwardTable,Size,True);
  if pIpForwardTable <> nil then
    try
      s := InputBox('Query', 'Input Row # ', '');
      if s='' then
        Exit;
      N := StrToInt(s);
      if (N>0) and (N<=pIpForwardTable^.dwNumEntries) then
      begin
        Memo1.Lines.Add('DeleteIpForwardEntry');
        VVDeleteIpForwardEntry(pIpForwardTable^.table[N-1]);
        Memo1.Lines.Add('Success');
      end
      else
        ShowMessage('Invalid Row N');
    finally
      FreeMem(pIpForwardTable,Size);
    end;
end;

procedure TFmIpTest.BtSetIpForwardEntryClick(Sender: TObject);
var
  pIpForwardTable: PMibIpForwardTable;
  N, Size: Cardinal;
  s: string;
  Route: TMibIpForwardRow;
begin
  VVGetIpForwardTable(pIpForwardTable, Size, True);
  if pIpForwardTable <> nil then
    try
      s := InputBox('Query', 'Input Row # ', '');
      if s='' then
        Exit;
      N := StrToInt(s);
      if (N>0) and (N<=pIpForwardTable^.dwNumEntries) then
      begin
        Route := pIpForwardTable^.table[N-1];
        Route.dwForwardProto := 3;  //PROTO_IP_NETMGMT;
        Route.dwForwardPolicy := 0;
        Route.dwForwardAge := 1;
        Memo1.Lines.Add('SetIpForwardEntry');
        VVSetIpForwardEntry(Route);
        Memo1.Lines.Add('Success');
      end
      else
        ShowMessage('Invalid Row N');
    finally
      FreeMem(pIpForwardTable,Size);
    end;
end;

procedure TFmIpTest.BtGetBestRouteClick(Sender: TObject);
var
  BestRoute: TMibIpForwardRow;
  dwDestAddr: DWORD;
  s: string;
begin
  Memo1.Lines.Add('GetBestRoute');
  s := InputBox('Query', 'Input Destination Address', '');
  if s='' then
    Exit;
  dwDestAddr := inet_addr(PChar(s));
  VVGetBestRoute(dwDestAddr, 0, @BestRoute);
  with BestRoute, Memo1.Lines do
  begin
    Add(' dwForwardDest:' + IpAddressToString(dwForwardDest));
    Add(' dwForwardMask:' + IpAddressToString(dwForwardMask));
    Add(' dwForwardPolicy:' + IntToStr(dwForwardPolicy));
    Add(' dwForwardNextHop:' + IpAddressToString(dwForwardNextHop));
    Add(' dwForwardIfIndex:' + IntToStr(dwForwardIfIndex));
    Add(' dwForwardType:' + IntToStr(dwForwardType));
    Add(' dwForwardProto:' + IntToStr(dwForwardProto));
    Add(' dwForwardAge:' + IntToStr(dwForwardAge));
    Add(' dwForwardNextHopAS:' + IntToStr(dwForwardNextHopAS));
    Add(' dwForwardMetric1:' + IntToStr(dwForwardMetric1));
    Add(' dwForwardMetric2:' + IntToStr(dwForwardMetric2));
    Add(' dwForwardMetric3:' + IntToStr(dwForwardMetric3));
    Add(' dwForwardMetric4:' + IntToStr(dwForwardMetric4));
    Add(' dwForwardMetric5:' + IntToStr(dwForwardMetric5));
  end;
end;

procedure TFmIpTest.BtGetBestInterfaceClick(Sender: TObject);
var
  dwBestIfIndex: DWORD;
  dwDestAddr:  DWORD;
  s: string;
begin
  Memo1.Lines.Add('GetBestInterface');
  s := InputBox('Query', 'Input Destination Address', '');
  if s = '' then
    Exit;
  dwDestAddr := inet_addr(PChar(s));
  VVGetBestInterface(dwDestAddr, dwBestIfIndex);
  Memo1.Lines.Add('BestIfIndex: ' + IntToStr(dwBestIfIndex));
end;

procedure TFmIpTest.BtGetRTTAndHopCountClick(Sender: TObject);
var
  MaxHops, DestIpAddress, HopCount, RTT:  ULONG;
  s: string;
begin
  Memo1.Lines.Add('GetRTTAndHopCount');
  s := InputBox('Query', 'Input Destination Address', '');
  if s = '' then
    Exit;
  DestIpAddress := inet_addr(PChar(s));
  MaxHops := 15;
  GetRTTAndHopCount(DestIpAddress, HopCount, MaxHops, RTT);
  with Memo1.Lines do
  begin
    Add('HopCount: ' + IntToStr(HopCount));
    Add('RTT: ' + IntToStr(RTT));
  end;
end;

procedure TFmIpTest.BtNotifyAddrChangeClick(Sender: TObject);
begin
  AddressWaitingThread := TWaitingThread.Create(IOHandle, 'AddressChanged',1);
  BtNotifyAddrChange.Enabled := False;
  BtNotifyRouteChange.Enabled := False;
  BtCancelNotifyAddrChange.Enabled := True;
end;

procedure TFmIpTest.BtNotifyRouteChangeClick(Sender: TObject);
begin
  RouteWaitingThread := TWaitingThread.Create(IOHandle, 'RouteChanged',2);
  BtNotifyRouteChange.Enabled := False;
  BtNotifyAddrChange.Enabled := False;
  BtCancelNotifyRouteChange.Enabled := True;
end;

procedure TFmIpTest.BtGetTcpStatisticsClick(Sender: TObject);
var
  Stats: TMibTcpStats;
begin
  Memo1.Lines.Add('GetTcpStatistics');
  VVGetTcpStatistics(Stats);
  with Memo1.Lines, Stats do
  begin
    Add(' dwRtoAlgorithm:' + IntToStr(dwRtoAlgorithm));
    Add(' dwRtoMin:' + IntToStr(dwRtoMin));
    Add(' dwRtoMax:' + IntToStr(dwRtoMax));
    Add(' dwMaxConn:' + IntToStr(dwMaxConn));
    Add(' dwActiveOpens:' + IntToStr(dwActiveOpens));
    Add(' dwPassiveOpens:' + IntToStr(dwPassiveOpens));
    Add(' dwAttemptFails:' + IntToStr(dwAttemptFails));
    Add(' dwEstabResets:' + IntToStr(dwEstabResets));
    Add(' dwCurrEstab:' + IntToStr(dwCurrEstab));
    Add(' dwInSegs:' + IntToStr(dwInSegs));
    Add(' dwOutSegs:' + IntToStr(dwOutSegs));
    Add(' dwRetransSegs:' + IntToStr(dwRetransSegs));
    Add(' dwInErrs:' + IntToStr(dwInErrs));
    Add(' dwOutRsts:' + IntToStr(dwOutRsts));
    Add(' dwNumConns:' + IntToStr(dwNumConns));
  end;
end;

procedure TFmIpTest.BtGetUdpStatisticsClick(Sender: TObject);
var
  Stats: TMibUdpStats;
begin
  Memo1.Lines.Add('GetUdpStatistics');
  VVGetUdpStatistics(Stats);
  with Memo1.Lines, Stats do
  begin
    Add(' dwInDatagrams:' + IntToStr(dwInDatagrams));
    Add(' dwNoPorts:' + IntToStr(dwNoPorts));
    Add(' dwInErrors:' + IntToStr(dwInErrors));
    Add(' dwOutDatagrams:' + IntToStr(dwOutDatagrams));
    Add(' dwNumAddrs:' + IntToStr(dwNumAddrs));
  end;
end;

procedure TFmIpTest.BtGetTcpTableClick(Sender: TObject);
var
  pTcpTable: PMibTcpTable;
  dwSize: DWORD;
  i: integer;
begin
  Memo1.Lines.Add('GetTcpTable');
  VVGetTcpTable(pTcpTable, dwSize, False);
  if pTcpTable <> nil then
  try
    Memo1.Lines.Add(' NumEntries: ' + IntToStr(pTcpTable^.dwNumEntries));
    Memo1.Lines.Add('   Local Address  Port  Remote Address  Port State');
    for i := 0 to pTcpTable^.dwNumEntries do
      with pTcpTable^.table[i], Memo1.Lines do
      begin
        Add(Format(' %15s %5d %15s %5d %5d', [IpAddressToString(dwLocalAddr),
          dwLocalPort, IpAddressToString(dwRemoteAddr), dwRemotePort, dwState]));
      end;
  finally
   Freemem(pTcpTable);
  end;
end;

procedure TFmIpTest.BtGetUdpTableClick(Sender: TObject);
var
  pUdpTable: PMibUdpTable;
  dwSize: DWORD;
  i: integer;
begin
  Memo1.Lines.Add('GetUdpTable');
  VVGetUdpTable(pUdpTable, dwSize, True);
  if pUdpTable <> nil then
    try
     Memo1.Lines.Add(' NumEntries: ' + IntToStr(pUdpTable^.dwNumEntries));
     Memo1.Lines.Add('   Local Address Port');
     for i := 0 to pUdpTable^.dwNumEntries do
       with pUdpTable^.table[i] do
         Memo1.Lines.Add(Format(' %15s %5d',[IpAddressToString(dwLocalAddr) ,dwLocalPort]));
    finally
      Freemem(pUdpTable);
    end;
end;

procedure TFmIpTest.BtSetTcpEntryClick(Sender: TObject);
var
  TcpRow: TMibTcpRow;
  pTcpTable: PMibTcpTable;
  dwSize,N: DWORD;
  s: string;
begin
  VVGetTcpTable(pTcpTable, dwSize, True);
  if pTcpTable <> nil then
    try
      s := InputBox('Query', 'Input Row # ', '');
      if s='' then
        Exit;
      N := StrToInt(s);
      if (N > 0) and (N <= pTcpTable^.dwNumEntries) then
      begin
        TcpRow := pTcpTable^.table[N-1];
        TcpRow.dwState := MIB_TCP_STATE_DELETE_TCB;
        Memo1.Lines.Add('SetTcpEntry');
        VVSetTcpEntry(TcpRow);
        Memo1.Lines.Add('Success');
      end;
    finally
      FreeMem(pTcpTable)
    end;
end;

procedure TFmIpTest.BtEnableRouterClick(Sender: TObject);
begin
  FillChar(Overlapped,sizeof(Overlapped),#0);
  Overlapped.hEvent := CreateEvent(nil, False, False, 'EnableRouter');
  Memo1.Lines.Add('EnableRouter');
  VVEnableRouter(RouterHandle,Overlapped);
  Memo1.Lines.Add('Success');
end;

procedure TFmIpTest.BtUnenableRouterClick(Sender: TObject);
var
  Count: DWORD;
begin
  Memo1.Lines.Add('UnEnableRouter');
  VVUnEnableRouter(Overlapped, @Count);
  CloseHandle(Overlapped.hEvent);
  Memo1.Lines.Add(' Count: ' + IntToStr(Count));
end;

procedure TFmIpTest.BtCancelNotifyAddrChangeClick(Sender: TObject);
begin
  AddressWaitingThread.Terminate;
  BtCancelNotifyAddrChange.Enabled := False;
end;

procedure TFmIpTest.BtCancelNotifyRouteChangeClick(Sender: TObject);
begin
  RouteWaitingThread.Terminate;
  BtCancelNotifyRouteChange.Enabled := False;
end;

procedure TFmIpTest.FormCreate(Sender: TObject);
begin
  {$IFDEF IPHLPAPI_LINKONREQUEST}
  IpHlpApiInitAPI;
  {$ENDIF}
end;

procedure TFmIpTest.FormDestroy(Sender: TObject);
begin
  if AddressWaitingThread <> nil then
  begin
    AddressWaitingThread.Terminate;
    AddressWaitingThread.WaitFor;  // wait for it to terminate
  end;
  if RouteWaitingThread <> nil then
  begin
    RouteWaitingThread.Terminate;
    RouteWaitingThread.WaitFor;  // wait for it to terminate
  end;
  if IOHandle > 0 then
  begin
    CloseHandle(IOHandle);
    IOHandle := 0;
  end;
end;

procedure TFmIpTest.ThreadDone(var AMessage: TMessage);
begin
  if AMessage.WParam = 1 then
  begin
    AddressWaitingThread := nil;
    BtNotifyAddrChange.Enabled := True;
    BtNotifyRouteChange.Enabled := True;
  end
  else
  begin
    RouteWaitingThread := nil;
    BtNotifyAddrChange.Enabled := True;
    BtNotifyRouteChange.Enabled := True;
  end;
end;

end.
