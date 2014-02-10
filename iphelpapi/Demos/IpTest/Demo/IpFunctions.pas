{******************************************************************}
{                                                                  }
{       IpTest - IP Helper API Demonstration project               }
{                                                                  }
{ Portions created by Vladimir Vassiliev are                       }
{ Copyright (C) 2000 Vladimir Vassiliev.                           }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: IPFunctions.pas, released  December 2000.  }
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

unit IPFunctions;

interface

uses
  Windows, SysUtils, IpHlpApi, IpTypes, IPExport, Iprtrmib;

type
 EIpHlpError = class(Exception);

resourcestring
 sNotImplemented = 'Function %s is not implemented.';
 sInvalidParameter = 'Function %s. Invalid parameter';
 sNoData = 'Function %s. No adapter information exists for the local computer.';
 sNotSupported = 'Function %s is not supported by the operating system.';

procedure VVGetNetworkParams(var p: PfixedInfo; var OutBufLen: Cardinal);
procedure VVGetAdaptersInfo(var p: PIpAdapterInfo; var OutBufLen: Cardinal);
procedure VVGetPerAdapterInfo(IfIndex: Cardinal; var p: PIpPerAdapterInfo;
  var OutBufLen: Cardinal);
function VVGetNumberOfInterfaces:DWORD;
procedure VVGetAdapterIndex(AdapterName: PWideChar; var IfIndex :Cardinal);
procedure VVGetUniDirectionalAdapterInfo(var p: PIpUnidirectionalAdapterAddress;
  var OutBufLen :Cardinal);
procedure VVGetInterfaceInfo(var p: PIpInterfaceInfo; var OutBufLen: Cardinal);
function VVGetFriendlyIfIndex(IfIndex: DWORD):DWORD;
procedure VVGetIfTable(var p: PMibIfTable;    // buffer for interface table
  var dwSize: Cardinal;           // size of buffer
  const bOrder: BOOL                // sort the table by index?
  );
procedure VVGetIfEntry(pIfRow: PMibIfRow     // pointer to interface entry
  );
procedure VVSetIfEntry(IfRow: TMibIfRow     // specifies interface and status
  );
procedure VVGetIpAddrTable(var p: PMibIpAddrTable; var Size: Cardinal;
  const bOrder: BOOL);
procedure VVAddIPAddress(Address: IPAddr; IPMask: IpMask; IfIndex: DWORD;
  var NTEContext: Cardinal; var NTEInstance: Cardinal);
procedure VVDeleteIPAddress(NTEContext: Cardinal);
procedure VVIpReleaseAddress(AdapterInfo: TIpAdapterIndexMap);
procedure VVIpRenewAddress(AdapterInfo: TIpAdapterIndexMap);
procedure VVGetIpNetTable(var p: PMibIpNetTable; // buffer for mapping table
  var Size: Cardinal; // size of buffer
  const bOrder: BOOL //sort by IP address
  );
procedure VVCreateIpNetEntry(ArpEntry: TMibIpNetRow     // pointer to info for new entry
  );
procedure VVDeleteIpNetEntry(ArpEntry: TMibIpNetRow   // info identifying entry to delete
  );
procedure VVFlushIpNetTable(dwIfIndex: DWORD     // delete ARP entries for this interface
  );
procedure VVCreateProxyArpEntry(
  dwAddress,    // IP address for which to act as proxy
  dwMask,       // subnet mask for IP address
  dwIfIndex: DWORD      // interface on which to proxy
  );
procedure VVDeleteProxyArpEntry(
  dwAddress,    // IP address for which to act as proxy
  dwMask,       // subnet mask for IP address
  dwIfIndex: DWORD      // interface on which to proxy
  );
procedure VVSendARP(
  const DestIP,      // destination IP address
  SrcIP: IPAddr;     // IP address of sender
  PMacAddr: PULong;   // returned physical address
  var PhyAddrLen :ULong   // length of returned physical addr.
  );
procedure VVGetIpStatistics(
  var Stats: TMibIpStats     // IP stats
  );
procedure VVGetIcmpStatistics(
  var Stats: TMibIcmp     // ICMP stats
  );
procedure VVSetIpStatistics(
  var IpStats: TMibIpStats     // new forwarding and TTL settings
  );
procedure VVSetIpTTL(
  nTTL: UINT    // new default TTL
  );
procedure VVGetIpForwardTable(
  var pIpForwardTable: PMibIpForwardTable;  // buffer for routing table
  var dwSize: Cardinal;                       // size of buffer
  const bOrder: BOOL                       // sort the table?
  );
procedure VVCreateIpForwardEntry(
  pRoute: PMibIpForwardRow     // pointer to route information
  );
procedure VVDeleteIpForwardEntry(
  Route: TMibIpForwardRow    // pointer to route information
  );
procedure VVSetIpForwardEntry(
  Route: TMibIpForwardRow    // pointer to route information
  );
procedure VVGetBestRoute(
  dwDestAddr,                     // destination IP address
  dwSourceAddr: DWORD;            // local source IP address
  pBestRoute: PMibIpForwardRow   // best route for dest. addr.
  );
procedure VVGetBestInterface(
  dwDestAddr: IPAddr;         // destination IP address
  var dwBestIfIndex: DWORD    // index of interface with the best route
  );
procedure VVGetRTTAndHopCount(
  const DestIpAddress: IPAddr; // destination IP address
  var HopCount: ULONG;         // returned hop count
  const MaxHops: ULONG;        // limit on number of hops to search
  var RTT: ULONG             // round-trip time
  );
procedure VVNotifyAddrChange(var Handle: THandle; Overlapped: POverlapped);
procedure VVNotifyRouteChange(var Handle: THandle; Overlapped: POverlapped);
procedure VVGetTcpStatistics(
  var Stats: TMibTcpStats    // pointer to TCP stats
  );
procedure VVGetUdpStatistics(
  var Stats: TMibUdpStats    // pointer to UDP stats
  );
procedure VVGetTcpTable(
  var pTcpTable: PMibTcpTable;    // buffer for the connection table
  var dwSize: DWORD;          // size of the buffer
  const bOrder: BOOL          // sort the table?
  );
procedure VVGetUdpTable(
  var pUdpTable: PMibUdpTable;    // buffer for the listener table
  var dwSize: DWORD;              // size of buffer
  bOrder: BOOL                // sort the table?
  );
procedure VVSetTcpEntry(
  TcpRow: TMibTcpRow    // pointer to struct. with new state info
  );
procedure VVEnableRouter(
  var Handle: THandle;
  var Overlapped: TOverlapped
  );
procedure VVUnenableRouter(
  var Overlapped: TOverlapped;
  lpdwEnableCount: LPDWORD = Nil
  );

implementation

procedure IpHlpError(const FunctionName: string; ErrorCode: DWORD);
begin
  case ErrorCode of
    ERROR_INVALID_PARAMETER :
      raise EIpHlpError.CreateFmt(sInvalidParameter, [FunctionName]);
    ERROR_NO_DATA :
      raise EIpHlpError.CreateFmt(sNoData, [FunctionName]);
    ERROR_NOT_SUPPORTED :
      raise EIpHlpError.CreateFmt(sNotSupported, [FunctionName]);
  else ;
    RaiseLastWin32Error;
  end;
end;

procedure VVGetNetworkParams(var p: PfixedInfo; var OutBufLen: Cardinal);
var
  Res: DWORD;
begin
  p := Nil;
  OutBufLen := 0;
  if @GetNetworkParams = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetNetworkParams']);
  Res := GetNetworkParams(p, OutBufLen);
  if Res = ERROR_BUFFER_OVERFLOW then
  begin
    Getmem(p, OutBufLen);
// Caller must free this buffer when it is no longer used
    FillChar(p^, OutBufLen, #0);
    Res := GetNetworkParams(p, OutBufLen);
  end;
  if Res <> 0 then
    IpHlpError('GetNetworkParams', Res);
end;

procedure VVGetAdaptersInfo(var p: PIpAdapterInfo; var OutBufLen: Cardinal);
var
  Res:DWORD;
begin
  p := Nil;
  OutBufLen := 0;
  if @GetAdaptersInfo = Nil then
  raise EIpHlpError.CreateFmt(sNotImplemented, ['GetAdaptersInfo']);
 Res := GetAdaptersInfo(p, OutBufLen);
 if Res = ERROR_BUFFER_OVERFLOW then
  begin
  Getmem(p, OutBufLen);
// Caller must free this buffer when it is no longer used
  FillChar(p^, OutBufLen, #0);
  Res := GetAdaptersInfo(p, OutBufLen);
  end;
 if Res <> 0 then
   IpHlpError('GetAdaptersInfo', Res);
end;

procedure VVGetPerAdapterInfo(IfIndex: Cardinal; var p: PIpPerAdapterInfo;
  var OutBufLen: Cardinal);
var
  Res: DWORD;
begin
  p := Nil;
  OutBufLen := 0;
  if @GetPerAdapterInfo = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetPerAdapterInfo']);
  Res := GetPerAdapterInfo(IfIndex,p, OutBufLen);
  if Res = ERROR_BUFFER_OVERFLOW then
  begin
    Getmem(p, OutBufLen);
// Caller must free this buffer when it is no longer used
    FillChar(p^, OutBufLen, #0);
    Res := GetPerAdapterInfo(IfIndex,p, OutBufLen);
  end;
  if Res <> 0 then
    IpHlpError('GetPerAdapterInfo', Res);
end;

function VVGetNumberOfInterfaces: DWORD;
var
  Res: DWORD;
  NumIf: DWORD;
begin
  if @GetNumberOfInterfaces = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetNumberOfInterfaces']);
  Res := GetNumberOfInterfaces(NumIf);
  if Res <> 0 then
    IpHlpError('GetNumberOfInterfaces', Res);
  Result := NumIf;
end;

procedure VVGetAdapterIndex(AdapterName: PWideChar; var IfIndex :Cardinal);
var
  Res: DWORD;
begin
  if @GetAdapterIndex = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetAdapterIndex']);
  Res := GetAdapterIndex(AdapterName, IfIndex);
  if Res <> NO_ERROR then
    IpHlpError('GetAdapterIndex', Res);
end;

procedure VVGetUniDirectionalAdapterInfo(var p: PIpUnidirectionalAdapterAddress;
  var OutBufLen :Cardinal);
var
  Res: DWORD;
begin
  p := Nil;
  OutBufLen := 0;
  if @GetUniDirectionalAdapterInfo = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetUniDirectionalAdapterInfo']);
  Res := GetUniDirectionalAdapterInfo(p, OutBufLen);
  if Res = ERROR_BUFFER_OVERFLOW then
  begin
    Getmem(p, OutBufLen);
// Caller must free this buffer when it is no longer used
    FillChar(p^, OutBufLen, #0);
    Res := GetUniDirectionalAdapterInfo(p, OutBufLen);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetUniDirectionalAdapterInfo', Res);
end;

procedure VVGetInterfaceInfo(var p: PIpInterfaceInfo; var OutBufLen: Cardinal);
var
  Res: DWORD;
begin
  p := Nil;
  OutBufLen := 0;
  if @GetInterfaceInfo = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetInterfaceInfo']);
  Res := GetInterfaceInfo(p, OutBufLen);
  if Res = ERROR_INSUFFICIENT_BUFFER then
  begin
    Getmem(p, OutBufLen);
// Caller must free this buffer when it is no longer used
    FillChar(p^, OutBufLen, #0);
    Res := GetInterfaceInfo(p, OutBufLen);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetInterfaceInfo', Res);
end;

function VVGetFriendlyIfIndex(IfIndex: DWORD):DWORD;
begin
  if @GetFriendlyIfIndex = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetFriendlyIfIndex']);
  Result := GetFriendlyIfIndex(IfIndex);
end;

procedure VVGetIfTable(var p: PMibIfTable; var dwSize: Cardinal;
  const bOrder: BOOL);
var
  Res: DWORD;
begin
  p := Nil;
  dwSize := 0;
  if @GetIfTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIfTable']);
  Res := GetIfTable(p,dwSize,bOrder);
  if Res = ERROR_INSUFFICIENT_BUFFER then
  begin
    Getmem(p,dwSize);
// Caller must free this buffer when it is no longer used
    FillChar(p^,dwSize,#0);
    Res := GetIfTable(p,dwSize,bOrder);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetIfTable', Res);
end;

procedure VVGetIfEntry(pIfRow: PMibIfRow);
var
  Res: DWORD;
begin
  if @GetIfEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIfEntry']);
  Res := GetIfEntry(pIfRow);
  if Res <> NO_ERROR then
    IpHlpError('GetIfEntry', Res);
end;

procedure VVSetIfEntry(IfRow: TMibIfRow);
var
  Res: DWORD;
begin
  if @SetIfEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['SetIfEntry']);
  Res := SetIfEntry(IfRow);      //
  if Res <> NO_ERROR then
    IpHlpError('SetIfEntry', Res);
end;

procedure VVGetIpAddrTable(var p: PMibIpAddrTable; var Size: Cardinal;
  const bOrder: BOOL);
var
  Res: DWORD;
begin
  p := Nil;
  Size := 0;
  if @GetIpAddrTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIpAddrTable']);
  Res := GetIpAddrTable(p,Size,bOrder);
  if Res=ERROR_INSUFFICIENT_BUFFER then
  begin
    Getmem(p,Size);
// Caller must free this buffer when it is no longer used
    FillChar(p^,Size,#0);
    Res := GetIpAddrTable(p,Size,bOrder);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetIpAddrTable', Res);
end;

procedure VVAddIPAddress(Address: IPAddr; IPMask: IpMask; IfIndex: DWORD;
  var NTEContext: Cardinal; var NTEInstance: Cardinal);
var
  Res: DWORD;
begin
  if @AddIPAddress = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['AddIPAddress']);
  Res := AddIPAddress(Address, IpMask, IfIndex, NTEContext, NTEInstance);
  if Res <> NO_ERROR then
    IpHlpError('AddIPAddress', Res);
end;

procedure VVDeleteIPAddress(NTEContext: Cardinal);
var
  Res: DWORD;
begin
  if @DeleteIPAddress = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['DeleteIPAddress']);
  Res := DeleteIPAddress(NTEContext);
  if Res <> NO_ERROR then
    IpHlpError('DeleteIPAddress', Res);
end;

procedure VVIpReleaseAddress(AdapterInfo: TIpAdapterIndexMap);
var
  Res: DWORD;
begin
  if @IpReleaseAddress = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['IpReleaseAddress']);
  Res := IpReleaseAddress(AdapterInfo);  //
  if Res <> NO_ERROR then
    IpHlpError('IpReleaseAddress', Res);
end;

procedure VVIpRenewAddress(AdapterInfo: TIpAdapterIndexMap);
var
  Res: DWORD;
begin
  if @IpRenewAddress = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['IpRenewAddress']);
  Res := IpRenewAddress(AdapterInfo);    //
  if Res <> NO_ERROR then
    IpHlpError('IpRenewAddress', Res);
end;

procedure VVGetIpNetTable(var p: PMibIpNetTable; var Size: Cardinal;
  const bOrder: BOOL);
var
  Res: DWORD;
begin
  p := Nil;
  Size := 0;
  if @GetIpNetTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIpNetTable']);
  Res := GetIpNetTable(p, Size, bOrder);
  if Res = ERROR_INSUFFICIENT_BUFFER then
  begin
    Getmem(p,Size);
// Caller must free this buffer when it is no longer used
    FillChar(p^, Size, #0);
    Res := GetIpNetTable(p, Size, bOrder);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetIpNetTable', Res);
end;

procedure VVCreateIpNetEntry(ArpEntry: TMibIpNetRow);
var
  Res: DWORD;
begin
  if @CreateIpNetEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['CreateIpNetEntry']);
  Res := CreateIpNetEntry(ArpEntry);   //
  if Res <> NO_ERROR then
    IpHlpError('CreateIpNetEntry', Res);
end;

procedure VVDeleteIpNetEntry(ArpEntry: TMibIpNetRow);
var
  Res: DWORD;
begin
  if @DeleteIpNetEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['DeleteIpNetEntry']);
  Res := DeleteIpNetEntry(ArpEntry);    //
  if Res <> NO_ERROR then
    IpHlpError('DeleteIpNetEntry', Res);
end;

procedure VVFlushIpNetTable(dwIfIndex: DWORD);
var
  Res: DWORD;
begin
  if @FlushIpNetTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['FlushIpNetTable']);
  Res := FlushIpNetTable(dwIfIndex);
  if Res <> NO_ERROR then
    IpHlpError('FlushIpNetTable', Res);
end;

procedure VVCreateProxyArpEntry(dwAddress, dwMask, dwIfIndex: DWORD);
var
  Res: DWORD;
begin
  if @CreateProxyArpEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['CreateProxyArpEntry']);
  Res := CreateProxyArpEntry(dwAddress, dwMask, dwIfIndex);
  if Res <> NO_ERROR then
    IpHlpError('CreateProxyArpEntry', Res);
end;

procedure VVDeleteProxyArpEntry(dwAddress, dwMask, dwIfIndex: DWORD);
var
  Res: DWORD;
begin
  if @DeleteProxyArpEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['DeleteProxyArpEntry']);
  Res := DeleteProxyArpEntry(dwAddress, dwMask, dwIfIndex);
  if Res <> NO_ERROR then
    IpHlpError('DeleteProxyArpEntry', Res);
end;

procedure VVSendARP(const DestIP, SrcIP: IPAddr;
          PMacAddr :PULong; var PhyAddrLen: ULong);
var
  Res: DWORD;
begin
  if @SendARP = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['SendARP']);
  Res := SendARP(DestIP, SrcIP, PMacAddr, PhyAddrLen);
  if Res <> NO_ERROR then
    IpHlpError('SendARP', Res);
end;

procedure VVGetIpStatistics(var Stats: TMibIpStats);
var
  Res: DWORD;
begin
  if @GetIpStatistics = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIpStatistics']);
  Res := GetIpStatistics(Stats);         //
  if Res <> NO_ERROR then
    IpHlpError('GetIpStatistics', Res);
end;

procedure VVGetIcmpStatistics(var Stats: TMibIcmp);
var
  Res: DWORD;
begin
  if @GetIcmpStatistics = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIcmpStatistics']);
  Res := GetIcmpStatistics(Stats);       //
  if Res <> NO_ERROR then
    IpHlpError('GetIcmpStatistics', Res);
end;

procedure VVSetIpStatistics(var IpStats: TMibIpStats);
var
  Res: DWORD;
begin
  if @SetIpStatistics = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['SetIpStatistics']);
  Res := SetIpStatistics(IpStats);       //
  if Res <> NO_ERROR then
    IpHlpError('SetIpStatistics', Res);
end;

procedure VVSetIpTTL(nTTL: UINT);
var
  Res: DWORD;
begin
  if @SetIpTTL = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['SetIpTTL']);
  Res := SetIpTTL(nTTL);
  if Res <> NO_ERROR then
    IpHlpError('SetIpTTL', Res);
end;

procedure VVGetIpForwardTable(var pIpForwardTable: PMibIpForwardTable;
  var dwSize: Cardinal; const bOrder: BOOL);
var
  Res: DWORD;
begin
  pIpForwardTable := Nil;
  dwSize := 0;
  if @GetIpForwardTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetIpForwardTable']);
  Res := GetIpForwardTable(pIpForwardTable,dwSize,bOrder);
  if (Res <> NO_ERROR) and (dwSize>0) then
  begin
    Getmem(pIpForwardTable,dwSize);
// Caller must free this buffer when it is no longer used
    FillChar(pIpForwardTable^,dwSize,#0);
    Res := GetIpForwardTable(pIpForwardTable,dwSize,bOrder);
  end;
  if Res <> 0 then
    IpHlpError('GetIpForwardTable', Res);
end;

procedure VVCreateIpForwardEntry(pRoute: PMibIpForwardRow);
var
  Res: DWORD;
begin
  if @CreateIpForwardEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['CreateIpForwardEntry']);
  Res := CreateIpForwardEntry(pRoute^);   //To test
  if Res <> NO_ERROR then
    IpHlpError('CreateIpForwardEntry', Res);
end;

procedure VVDeleteIpForwardEntry(Route: TMibIpForwardRow);
var
  Res: DWORD;
begin
  if @DeleteIpForwardEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['DeleteIpForwardEntry']);
  Res := DeleteIpForwardEntry(Route);   //
  if Res <> NO_ERROR then
    IpHlpError('DeleteIpForwardEntry', Res);
end;

procedure VVSetIpForwardEntry(Route: TMibIpForwardRow);
var
  Res: DWORD;
begin
  if @SetIpForwardEntry = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['SetIpForwardEntry']);
  Res := SetIpForwardEntry(Route);      //
  if Res <> NO_ERROR then
    IpHlpError('SetIpForwardEntry', Res);
end;

procedure VVGetBestRoute(dwDestAddr, dwSourceAddr: DWORD;
  pBestRoute: PMibIpForwardRow);
var
  Res: DWORD;
begin
  if @GetBestRoute = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetBestRoute']);
  Res := GetBestRoute(dwDestAddr, dwSourceAddr, pBestRoute);
  if Res <> NO_ERROR then
    IpHlpError('GetBestRoute', Res);
end;

procedure VVGetBestInterface(dwDestAddr: IPAddr; var dwBestIfIndex: DWORD);
var
  Res: DWORD;
begin
  if @GetBestInterface = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetBestInterface']);
  Res := GetBestInterface(dwDestAddr, dwBestIfIndex);
  if Res <> NO_ERROR then
    IpHlpError('GetBestInterface', Res);
end;

procedure VVGetRTTAndHopCount(const DestIpAddress: IPAddr; var HopCount: ULONG;
  const MaxHops: ULONG; var RTT: ULONG);
var
  Res:BOOL;
begin
  if @GetRTTAndHopCount = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetRTTAndHopCount']);
  Res := GetRTTAndHopCount(DestIpAddress, HopCount, MaxHops, RTT);
  if not Res then
    RaiseLastWin32Error;
end;

procedure VVNotifyAddrChange(var Handle: THandle; Overlapped: POverlapped);
var
  Res: DWORD;
begin
  if @NotifyAddrChange = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['NotifyAddrChange']);
  Res := NotifyAddrChange(Handle, Overlapped);     //
  if Res <> ERROR_IO_PENDING then
    IpHlpError('NotifyAddrChange', Res);
end;

procedure VVNotifyRouteChange(var Handle: THandle; Overlapped: POverlapped);
var
  Res: DWORD;
begin
  if @NotifyRouteChange = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['NotifyRouteChange']);
  Res := NotifyRouteChange(Handle, Overlapped); //
  if Res <> ERROR_IO_PENDING then
    IpHlpError('NotifyRouteChange', Res);
end;

procedure VVGetTcpStatistics(var Stats: TMibTcpStats);
var
  Res: DWORD;
begin
  if @GetTcpStatistics = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetTcpStatistics']);
  Res := GetTcpStatistics(Stats);       //
  if Res <> NO_ERROR then
    IpHlpError('GetTcpStatistics', Res);
end;

procedure VVGetUdpStatistics(var Stats: TMibUdpStats);
var
  Res: DWORD;
begin
  if @GetUdpStatistics = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetUdpStatistics']);
  Res := GetUdpStatistics(Stats);       //
  if Res <> NO_ERROR then
    IpHlpError('GetUdpStatistics', Res);
end;

procedure VVGetTcpTable(var pTcpTable: PMibTcpTable; var dwSize: DWORD;
          const bOrder: BOOL);
var
  Res: DWORD;
begin
  pTcpTable := Nil;
  dwSize := 0;
  if @GetTcpTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetTcpTable']);
  Res := GetTcpTable(pTcpTable, dwSize, bOrder);
  if Res = ERROR_INSUFFICIENT_BUFFER then
  begin
   Getmem(pTcpTable, dwSize);
// Caller must free this buffer when it is no longer used
   FillChar(pTcpTable^, dwSize, #0);
   Res := GetTcpTable(pTcpTable, dwSize, bOrder);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetTcpTable', Res);
end;

procedure VVGetUdpTable(var pUdpTable: PMibUdpTable; var dwSize: DWORD;
  bOrder: BOOL);
var
  Res: DWORD;
begin
  pUdpTable := Nil;
  dwSize := 0;
  if @GetUdpTable = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['GetUdpTable']);
  Res := GetUdpTable(pUdpTable, dwSize, bOrder);
  if Res = ERROR_INSUFFICIENT_BUFFER then
  begin
    Getmem(pUdpTable, dwSize);
// Caller must free this buffer when it is no longer used
    FillChar(pUdpTable^, dwSize, #0);
    Res := GetUdpTable(pUdpTable, dwSize, bOrder);
  end;
  if Res <> NO_ERROR then
    IpHlpError('GetUdpTable', Res);
end;

procedure VVSetTcpEntry(TcpRow: TMibTcpRow);
var
  Res: DWORD;
begin
 if @SetTcpEntry = Nil then
  raise EIpHlpError.CreateFmt(sNotImplemented, ['SetTcpEntry']);
  Res := SetTcpEntry(TcpRow);   //
 if Res <> NO_ERROR then
   IpHlpError('SetTcpEntry', Res);
end;

procedure VVEnableRouter(var Handle: THandle; var Overlapped: TOverlapped);
var
  Res: DWORD;
begin
  if @EnableRouter = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['EnableRouter']);
  Res := EnableRouter(Handle, @Overlapped);     //
  if Res <> ERROR_IO_PENDING then
    RaiseLastWin32Error;
end;

procedure VVUnenableRouter(var Overlapped: TOverlapped;
  lpdwEnableCount: LPDWORD = Nil);
var
  Res: DWORD;
begin
  if @UnEnableRouter = Nil then
    raise EIpHlpError.CreateFmt(sNotImplemented, ['UnEnableRouter']);
  Res := UnEnableRouter(@Overlapped, lpdwEnableCount);            //
  if Res <> NO_ERROR then
    RaiseLastWin32Error;
end;

end.
