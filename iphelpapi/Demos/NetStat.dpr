{******************************************************************}
{                                                                  }
{       NetStat.dpr - IP Helper API Demonstration project          }
{                                                                  }
{ Portions created by Marcel van Brakel are                        }
{ Copyright (C) 2000 Marcel van Brakel.                            }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: NetStat.dpr, released  December 2000.      }
{ The initial developer of the Pascal code is Marcel van Brakel    }
{ (brakelm@chello.nl).                                             }
{ 								   }
{ Contributor(s):  Vladimir Vassiliev (voldemarv@hotpop.com)       }
{                  John Penman (jcp@craiglockhart.com)             }
{                                                                  }
{ Obtained through:                                                }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org.               }
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

program NetStat;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Winsock,
  IpExport, IpHlpApi, IpTypes, IpIfConst, IpRtrMib;

//------------------------------------------------------------------------------

function UintToYesNo(U: UINT): string;
begin
  if U = 0 then
    Result := 'No'
  else
    Result := 'Yes';
end;

//------------------------------------------------------------------------------

function BooleanToYesNo(B: Boolean): string;
begin
  if B then
    Result := 'Yes'
  else
    Result := 'No';
end;

//------------------------------------------------------------------------------

// Converts a PIpAddrString to a string which includes both the IP address as
// well as the subnet mask in the form <ip addr>/<subnet mask>

function IpAddrStringToString(IpAddr: PIpAddrString): string;
begin
  Result := '';
  if IpAddr <> nil then
  begin
    Result := IpAddr^.IpAddress.S;
    if IpAddr.IpMask.S <> '' then Result := Result + '/' + IpAddr.IpMask.S
  end;
end;

//------------------------------------------------------------------------------

// Returns the name of the computer in lowercase, used by IpAddrToString. Simpy
// a convenience wrapper which avoids having to deal with buffer management in
// the routines that require the computer name

function GetLocalComputerName: string;
var
  Size: DWORD;
begin
  Size := 1024;
  SetLength(Result, Size);
  GetComputerName(PChar(Result), Size);
  SetLength(Result, StrLen(PChar(Result)));
  Result := LowerCase(Result);
end;

//------------------------------------------------------------------------------

var
  // Determines whether IpAddrToString() resolves IP addresses to names. By
  // default it does but can be set to False using the -n switch
  ResolveNames: Boolean = True;

//------------------------------------------------------------------------------

// Convert IP address to dotted decimal without port or name resolving

function IpAddrToString(Addr: DWORD): string; overload;
var
  inad: in_addr;
begin
  inad.s_addr := Addr;
  Result := inet_ntoa(inad);
end;

//------------------------------------------------------------------------------

// Convert the specified IP address to a dotted decimal string representation
// and suffixes it with the specified port. If ResolveNames is True, the
// function attempts to translate the IP address to a host name and the port to
// a service name. If local is true the IP address is translated to the name of
// the local machine but port is not translated (doesn't work for remote machines)

function IpAddrToString(Addr, Port: DWORD; Local: Boolean): string; overload;
var
  inad: in_addr;
  HostEnt: PHostEnt;
  ServEnt: PServEnt;
begin
  inad.s_addr := Addr;
  Result := inet_ntoa(inad);
  // If user wants names instead of IP addresses
  if ResolveNames then
  begin
    if Local or (Addr = 0) then
    begin
      ServEnt := GetServByPort(Port, nil);
      if ServEnt <> nil then
        Result := GetLocalComputerName + ':' + ServEnt^.s_name + '(' + ServEnt^.s_proto + ')'
      else
        Result := GetLocalComputerName + ':' + IntToStr(htons(Port));
    end
    else
    begin
      HostEnt := GetHostByAddr(PChar(@Addr), SizeOf(DWORD), AF_INET);
      if HostEnt <> nil then
        Result := HostEnt^.h_name + ':' + IntToStr(htons(Port))
      else
        Result := Result + ':' + IntToStr(htons(Port));
    end;
  end;
end;

//------------------------------------------------------------------------------

// Returns a string representation for the specified TCP connection state value

function TcpStateString(State: DWORD): string;
begin
  case State of
    MIB_TCP_STATE_CLOSED:    Result := 'Closed';
    MIB_TCP_STATE_LISTEN:    Result := 'Listening';
    MIB_TCP_STATE_SYN_SENT:  Result := 'Syn sent';
    MIB_TCP_STATE_SYN_RCVD:  Result := 'Syn received';
    MIB_TCP_STATE_ESTAB:     Result := 'Established';
    MIB_TCP_STATE_FIN_WAIT1: Result := 'Fin wait1';
    MIB_TCP_STATE_FIN_WAIT2: Result := 'Fin wait2';
    MIB_TCP_STATE_CLOSE_WAIT:Result := 'Close wait';
    MIB_TCP_STATE_CLOSING:   Result := 'Closing';
    MIB_TCP_STATE_LAST_ACK:  Result := 'Last ack';
    MIB_TCP_STATE_TIME_WAIT: Result := 'Time wait';
    MIB_TCP_STATE_DELETE_TCB:Result := 'Delete TCB';
  else
    Result := 'Unknown';
  end;
end;

//------------------------------------------------------------------------------

// Displays the TCP connection table (TCP connections)

procedure DisplayTcpConnections;
var
  Size: ULONG;
  TcpTable: PMibTcpTable;
  TcpRow: TMibTcpRow;
  I: Integer;
begin
  Size := 0;
  if GetTcpTable(nil, Size, True) <> ERROR_BUFFER_OVERFLOW then Exit;
  TcpTable := AllocMem(Size);
  try
    if GetTcpTable(TcpTable, Size, True) = NO_ERROR then
    begin
      for I := 0 to TcpTable^.dwNumEntries - 1 do
      begin
        {$R-}TcpRow := TcpTable^.Table[I];{$R+}
        WriteLn(Format('  %-5s  %-25s  %-25s  %-s',
         ['TCP',
          IpAddrToString(TcpRow.dwLocalAddr, TcpRow.dwLocalPort, True),
          IpAddrToString(TcpRow.dwRemoteAddr, TcpRow.dwRemotePort, False),
          TcpStateString(TcpRow.dwState)]));
      end;
    end;
  finally
    FreeMem(TcpTable);
  end;
end;

//------------------------------------------------------------------------------

// Displays the UDP listener table (UDP "connections")

procedure DisplayUdpConnections;
var
  Size: ULONG;
  I: Integer;
  UdpTable: PMibUdpTable;
  UdpRow: TMibUdpRow;
begin
  Size := 0;
  if GetUdpTable(nil, Size, True) <> ERROR_BUFFER_OVERFLOW then Exit;
  UdpTable := AllocMem(Size);
  try
    if GetUdpTable(UdpTable, Size, True) = NO_ERROR then
    begin
      for I := 0 to UdpTable.dwNumEntries - 1 do
      begin
        {$R-}UdpRow := UdpTable.Table[I];{$R+}
        WriteLn(Format('  %-5s  %-25s  %-25s  %-s', 
         ['UDP',
          IpAddrToString(UdpRow.dwLocalAddr, UdpRow.dwLocalPort, True),
          '*.*',
          '']));
      end;
    end;
  finally
    FreeMem(UdpTable);
  end;
end;

//------------------------------------------------------------------------------

// Displays active connections for the specified protocol. Protocol can be
// either TCP, UDP or an empty string. In the latter case connections for both
// the protocols are displayed.

procedure DisplayConnections(const Protocol: string);
begin
  WriteLn('Active connections');
  WriteLn;
  WriteLn('  Proto  Local address              Foreign address            State');
  if Protocol = '' then
  begin
    DisplayTcpConnections;
    DisplayUdpConnections;
  end
  else if Protocol = 'TCP' then
    DisplayTcpConnections
  else if Protocol = 'UDP' then
    DisplayUdpConnections;
end;

//------------------------------------------------------------------------------

// Displays statistics for the IP protocol

procedure DisplayIpStatistics;
var
  IpStats: TMibIpStats;
begin
  if GetIpStatistics(IpStats) = NO_ERROR then
  begin
    WriteLn('IP Statistics');
    WriteLn('');
    WriteLn('  IP forwarding enabled. . . . . . . : ' + UintToYesNo(IpStats.dwForwarding));
    WriteLn('  Default TTL. . . . . . . . . . . . : ' + IntToStr(IpStats.dwDefaultTTL));
    WriteLn('  Received datagrams . . . . . . . . : ' + IntToStr(IpStats.dwInReceives));
    WriteLn('  Datagrams with header errors . . . : ' + IntToStr(IpStats.dwInHdrErrors));
    WriteLn('  Datagrams with address errors. . . : ' + IntToStr(IpStats.dwInAddrErrors));
    WriteLn('  Forwarded datagrams. . . . . . . . : ' + IntToStr(IpStats.dwForwDatagrams));
    WriteLn('  Unknown protocol datagrams . . . . : ' + IntToStr(IpStats.dwInUnknownProtos));
    WriteLn('  Discarded datagrams. . . . . . . . : ' + IntToStr(IpStats.dwInDiscards));
    WriteLn('  Delivered datagrams. . . . . . . . : ' + IntToStr(IpStats.dwInDelivers));
    WriteLn('  Outgoing datagram requests . . . . : ' + IntToStr(IpStats.dwOutRequests));
    WriteLn('  Discarded outgoing datagrams . . . : ' + IntToStr(IpStats.dwRoutingDiscards));
    WriteLn('  Discarded outgoing datagrams . . . : ' + IntToStr(IpStats.dwOutDiscards));
    WriteLn('  Discarded due to no route. . . . . : ' + IntToStr(IpStats.dwOutNoRoutes));
    WriteLn('  Reassemby timeout. . . . . . . . . : ' + IntToStr(IpStats.dwReasmTimeout));
    WriteLn('  Reassembly required datagrams. . . : ' + IntToStr(IpStats.dwReasmReqds));
    WriteLn('  Successfully reassembled datagrams : ' + IntToStr(IpStats.dwReasmOks));
    WriteLn('  Failed reassembled datagrams . . . : ' + IntToStr(IpStats.dwReasmFails));
    WriteLn('  Succesfully fragmented datagrams . : ' + IntToStr(IpStats.dwFragOks));
    WriteLn('  Failed fragmented datagrams. . . . : ' + IntToStr(IpStats.dwFragFails));
    WriteLn('  Fragments created. . . . . . . . . : ' + IntToStr(IpStats.dwFragCreates));
    WriteLn('  Number of interfaces . . . . . . . : ' + IntToStr(IpStats.dwNumIf));
    WriteLn('  Number of IP addresses . . . . . . : ' + IntToStr(IpStats.dwNumAddr));
    WriteLn('  Number of routes . . . . . . . . . : ' + IntToStr(IpStats.dwNumRoutes));
    WriteLn('');
  end;
end;

//------------------------------------------------------------------------------

// Displays statistics for the TCP protocol

procedure DisplayTcpStatistics;
var
  TcpStats: TMibTcpStats;
begin
  if GetTcpStatistics(TcpStats) = NO_ERROR then
  begin
    WriteLn('TCP Statistics');
    WriteLn;
    case TcpStats.dwRtoAlgorithm of
      MIB_TCP_RTO_OTHER:  WriteLn('  RTO algorithm. . . . . . . . . . . . : Other');
      MIB_TCP_RTO_CONSTANT: WriteLn('  RTO algorithm. . . . . . . . . . . . : Constant time-out');
      MIB_TCP_RTO_RSRE: WriteLn('  RTO algorithm. . . . . . . . . . . . : MIL-STD-1778 Appendix B');
      MIB_TCP_RTO_VANJ: WriteLn('  RTO algorithm. . . . . . . . . . . . : Van Jacobson''s Algorithm');
    end;
    WriteLn('  Minimum retransmission time-out. . . : ' + IntToStr(TcpStats.dwRtoMin));
    WriteLn('  Maximum retransmission time-out. . . : ' + IntToStr(TcpStats.dwRtoMax));
    WriteLn('  Maximum number of connections. . . . : ' + IntToStr(TcpStats.dwMaxConn));
    WriteLn('  Active opens . . . . . . . . . . . . : ' + IntToStr(TcpStats.dwActiveOpens));
    WriteLn('  Passive opens. . . . . . . . . . . . : ' + IntToStr(TcpStats.dwPassiveOpens));
    WriteLn('  Failed connection attempts . . . . . : ' + IntToStr(TcpStats.dwAttemptFails));
    WriteLn('  Reset established connections. . . . : ' + IntToStr(TcpStats.dwEstabResets));
    WriteLn('  Established connections. . . . . . . : ' + IntToStr(TcpStats.dwCurrEstab));
    WriteLn('  Received segments. . . . . . . . . . : ' + IntToStr(TcpStats.dwInSegs));
    WriteLn('  Transmitted segments . . . . . . . . : ' + IntToStr(TcpStats.dwOutSegs));
    WriteLn('  Retransmitted segments . . . . . . . : ' + IntToStr(TcpStats.dwRetransSegs));
    WriteLn('  Received errors. . . . . . . . . . . : ' + IntToStr(TcpStats.dwInErrs));
    WriteLn('  Transmitted segments with reset flag : ' + IntToStr(TcpStats.dwOutRsts));
    WriteLn('  Cumulative number of connections . . : ' + IntToStr(TcpStats.dwNumConns));
  end;
  WriteLn;
end;

//------------------------------------------------------------------------------

// Displays statistics for the ICMP protocol

procedure DisplayIcmpStatistics;
var
  Icmp: TMibIcmp;

  procedure DisplayStats(const Stats: TMibIcmpStats);
  begin
    WriteLn('  Messages. . . . . . . . : ' + IntToStr(Stats.dwMsgs));
    WriteLn('  Errors. . . . . . . . . : ' + IntToStr(Stats.dwErrors));
    WriteLn('  Destination unreachable : ' + IntToStr(Stats.dwDestUnreachs));
    WriteLn('  Time-to-live exceeded . : ' + IntToStr(Stats.dwTimeExcds));
    WriteLn('  Parameter problems. . . : ' + IntToStr(Stats.dwParmProbs));
    WriteLn('  Source quench . . . . . : ' + IntToStr(Stats.dwSrcQuenchs));
    WriteLn('  Redirection . . . . . . : ' + IntToStr(Stats.dwRedirects));
    WriteLn('  Echo requests . . . . . : ' + IntToStr(Stats.dwEchos));
    WriteLn('  Echo replies. . . . . . : ' + IntToStr(Stats.dwEchoReps));
    WriteLn('  Time-stamp requests . . : ' + IntToStr(Stats.dwTimestamps));
    WriteLn('  Time-stamp replies. . . : ' + IntToStr(Stats.dwTimestampReps));
    WriteLn('  Address-mask requests . : ' + IntToStr(Stats.dwAddrMasks));
    WriteLn('  Address-mask replies. . : ' + IntToStr(Stats.dwAddrMaskReps));
  end;

begin
  if GetIcmpStatistics(Icmp) = NO_ERROR then
  begin
    WriteLn('Incoming ICMP message statistics');
    WriteLn;
    DisplayStats(Icmp.stats.icmpInStats);
    WriteLn;
    WriteLn('Outgoing ICMP message statistics');
    WriteLn;
    DisplayStats(Icmp.stats.icmpOutStats);
    WriteLn;
  end;
end;

//------------------------------------------------------------------------------

// Displays statistics for the UDP protocol

procedure DisplayUdpStatistics;
var
  UdpStats: TMibUdpStats;
begin
  if GetUdpStatistics(UdpStats) = NO_ERROR then
  begin
    WriteLn('UDP Statistics');
    WriteLn;
    WriteLn('  Received datagrams. . . . . . . . . . . : ' + IntToStr(UdpStats.dwInDatagrams));
    WriteLn('  Discarded due to invalid port . . . . . : ' + IntToStr(UdpStats.dwNoPorts));
    WriteLn('  Erroneous datagrams . . . . . . . . . . : ' + IntToStr(UdpStats.dwInErrors));
    WriteLn('  Transmitted datagrams . . . . . . . . . : ' + IntToStr(UdpStats.dwOutDatagrams));
    WriteLn('  Number of entries in UDP listened table : ' + IntToStr(UdpStats.dwNumAddrs));
  end;
  WriteLn;
end;

//------------------------------------------------------------------------------

// Displays statistics for all ethernet adapter type interfaces registered with
// the system

procedure DisplayInterfaceStatistics;
var
  Size: ULONG;
  IntfTable: PMibIfTable;
  I: Integer;
  MibRow: TMibIfRow;
begin
  WriteLn('Interface Statistics');
  WriteLn;
  Size := 0;
  // Thanks to Eran Kampf for pointing out that the line below should check agains
  // ERROR_INSUFFICIENT_BUFFER and not ERROR_BUFFER_OVERFLOW !
  if GetIfTable(nil, Size, True) <> ERROR_INSUFFICIENT_BUFFER then Exit;
  IntfTable := AllocMem(Size);
  try
    if GetIfTable(IntfTable, Size, True) = NO_ERROR then
    begin
      for I := 0 to IntfTable^.dwNumEntries - 1 do
      begin
        {$R-}MibRow := IntfTable.Table[I];{$R+}
        // Ignore everything except ethernet cards
        if MibRow.dwType <> MIB_IF_TYPE_ETHERNET then Continue;
        WriteLn(PChar(@MibRow.bDescr[0]));
        WriteLn(       '                     Received         Send');
        WriteLn;
        WriteLn(Format('Bytes                %10d %10d', [MibRow.dwInOctets, MibRow.dwOutOctets]));
        WriteLn(Format('Unicast packets      %10d %10d', [MibRow.dwInUcastPkts, MibRow.dwOutUcastPkts]));
        WriteLn(Format('Non-unicast packets  %10d %10d', [MibRow.dwInNUcastPkts, MibRow.dwOutNUcastPkts]));
        WriteLn(Format('Discards             %10d %10d', [MibRow.dwInDiscards, MibRow.dwOutDiscards]));
        WriteLn(Format('Errors               %10d %10d', [MibRow.dwInErrors, MibRow.dwOutErrors]));
        WriteLn(Format('Unknown protocols    %10d %10d', [MibRow.dwInUnknownProtos, 0]));
        WriteLn;
      end;
    end;
  finally
    FreeMem(IntfTable);
  end;
end;

//------------------------------------------------------------------------------

// Displays statistics for the specified protocol. Protocol can be TCP, IP, UDP
// of ICMP. If Protocol is an empty string, statistics for all protocols is
// displayed

procedure DisplayProtocolStatistics(const Protocol: string);
begin
  if Protocol = '' then
  begin
    DisplayTcpStatistics;
    DisplayIpStatistics;
    DisplayIcmpStatistics;
    DisplayUdpStatistics;
  end
  else if Protocol = 'TCP' then
    DisplayTcpStatistics
  else if Protocol = 'IP' then
    DisplayIpStatistics
  else if Protocol = 'ICMP' then
    DisplayIcmpStatistics
  else if Protocol = 'UDP' then
    DisplayUdpStatistics;
end;

//------------------------------------------------------------------------------

// Displays the IP forwarding table (routing table)

procedure DisplayRoutingTable;
var
  ForwardTable: PMibIpForwardTable;
  ForwardRow: TMibIpForwardRow;
  Size: ULONG;
  I: Integer;
begin
  Size := 0;
  if GetIpForwardTable(nil, Size, True) <> ERROR_BUFFER_OVERFLOW then Exit;
  ForwardTable := AllocMem(Size);
  try
    if GetIpForwardTable(ForwardTable, Size, True) = ERROR_SUCCESS then
    begin
      WriteLn('Route Table');
      WriteLn('');
      for I := 0 to ForwardTable^.dwNumEntries - 1 do
      begin
        {$R-}ForwardRow := ForwardTable^.Table[I];{$R+}
        WriteLn('Destination IP. . . : ' + IpAddrToString(ForwardRow.dwForwardDest));
        WriteLn('Destination Subnet. : ' + IpAddrToString(ForwardRow.dwForwardMask));
        WriteLn('Forward: Policy . . : ' + IntToStr(ForwardRow.dwForwardPolicy));
        WriteLn('Next hop. . . . . . : ' + IpAddrToString(ForwardRow.dwForwardNextHop));
        WriteLn('Interface index . . : ' + IntToStr(ForwardRow.dwForwardIfIndex));
        case ForwardRow.dwForwardType of
          MIB_IPROUTE_TYPE_OTHER: WriteLn('Route type. . . . . : Other');
          MIB_IPROUTE_TYPE_INVALID: WriteLn('Route type. . . . . : Invalid');
          MIB_IPROUTE_TYPE_DIRECT: WriteLn('Route type. . . . . : Direct (local route, next hop is final destination)');
          MIB_IPROUTE_TYPE_INDIRECT: WriteLn('Route type. . . . . : Indirect (remote route, next hop isn''t final destination)');
        end;
        case ForwardRow.dwForwardProto of
          MIB_IPPROTO_OTHER        : WriteLn('Protocol Type . . . : Unknown');
          MIB_IPPROTO_LOCAL        : WriteLn('Protocol Type . . . : Local generated by the stack');
          MIB_IPPROTO_NETMGMT      : WriteLn('Protocol Type . . . : SNMP');
          MIB_IPPROTO_ICMP         : WriteLn('Protocol Type . . . : ICMP');
          MIB_IPPROTO_EGP          : WriteLn('Protocol Type . . . : EGP');
          MIB_IPPROTO_GGP          : WriteLn('Protocol Type . . . : Gateway Gateway Protocol');
          MIB_IPPROTO_HELLO        : WriteLn('Protocol Type . . . : HELLO');
          MIB_IPPROTO_RIP          : WriteLn('Protocol Type . . . : Routing Information Protocol (RIP)');
          MIB_IPPROTO_IS_IS        : WriteLn('Protocol Type . . . : IP Intermediate System to Intermediate System Protocol');
          MIB_IPPROTO_ES_IS        : WriteLn('Protocol Type . . . : IP End System to Intermediate System Protocol');
          MIB_IPPROTO_CISCO        : WriteLn('Protocol Type . . . : IP Cisco Protocol');
          MIB_IPPROTO_BBN          : WriteLn('Protocol Type . . . : BBN Protocol');
          MIB_IPPROTO_OSPF         : WriteLn('Protocol Type . . . : Open Shortest Path First routing Protocol');
          MIB_IPPROTO_BGP          : WriteLn('Protocol Type . . . : Border Gateway Protocol');
          MIB_IPPROTO_NT_AUTOSTATIC: WriteLn('Protocol Type . . . : Routes originally added by the routing protocol, but not static');
          MIB_IPPROTO_NT_STATIC    : WriteLn('Protocol Type . . . : Routes added by the user or via the Routemon.exe');
        else
          WriteLn('Protocol Type . . . : Unknown');
        end;
        WriteLn('Route age (sec) . . : ' + IntToStr(ForwardRow.dwForwardAge));
        WriteLn('Next hop AS . . . . : ' + IntToStr(ForwardRow.dwForwardNextHopAS));
        WriteLn;
      end;
    end;
  finally
    FreeMem(ForwardTable);
  end;
end;

//------------------------------------------------------------------------------

// How is this program to be used by the end user?

procedure Usage;
begin
  WriteLn('Displays protocol statistics and current TCP/IP connections.');
  WriteLn;
  WriteLn('NETSTAT [-a] [-e] [-n] [-s] [-p proto] [-r] [interval]');
  WriteLn;
  WriteLn('  -a        Displays all connections and listening ports');
  WriteLn('  -e        Displays all ethernet statistics. This may be combined with the -s option');
  WriteLn('  -n        Displays addresses and port numbers in numerical form, must be the first switch');
  WriteLn('  -p proto  Shows connections for the protocol specified by proto; proto may be');
  WriteLn('            TCP or UDP. If used with the -s option to display per-protocol');
  WriteLn('            statistics, proto may be TCP, UDP or IP');
  WriteLn('  -r        Displays the routing table');
  WriteLn('  -s        Displays per protocol statistics. By default, statistics are shown for TCP,');
  WriteLn('            UDP and IP; the -p option may be used to specify a subset of the default');
  WriteLn('  interval  Redisplays selected statistics, pausing interval seconds between each');
  WriteLn('            display. Press CTRL+C to stop redisplaying statistics. If omitted,');
  WriteLn('            netstat will print the current configuration information once. The');
  WriteLn('            interval switch must be the last switch on the command line');
end;

//------------------------------------------------------------------------------

// Extract the repetition interval from the command line. Assumes it's specified
// last and that no other command line switches are numerical

function GetInterval: Integer;
begin
  try
    Result := StrToInt(ParamStr(ParamCount));
  except
    on Exception do Result := 0;
  end;
end;

//------------------------------------------------------------------------------

var
  WsData: TWsaData;          // Must provide this in call to WsaStartup but unused
  WsaInitialized: Boolean;   // Was Winsock properly initialized?
  ParamIndexOffset: Integer; // Used to offset access to ParamStr in case -n is used
  Interval: Integer;         // Interval in seconds to repeat information

//------------------------------------------------------------------------------

// Executed if user specified a repetition interval and presses CTRL+C to break
// out of the loop.

function CtrlHandler(fdwCtrlType: DWORD): BOOL; stdcall;
begin
  Result := False;
  if (fdwCtrlType in [CTRL_C_EVENT, CTRL_BREAK_EVENT]) and WsaInitialized then
  begin
    WsaCleanup;
    WsaInitialized := False;
  end;
end;

//------------------------------------------------------------------------------

begin

  WriteLn('');
  WriteLn('Windows 2000 NetStat');
  WriteLn('Copyright (C) 2000 Marcel van Brakel');
  WriteLn('');

  if FindCmdLineSwitch('?', ['/', '-'], True) then
  begin
    Usage;
    Exit;
  end;

  // Does user want IP address to hostname mapping turned off?

  ParamIndexOffset := 0;
  if FindCmdLineSwitch('n', ['/', '-'], True) then
  begin
    ResolveNames := False;
    ParamIndexOffset := 1;
  end;

  // If so, we need to intialize Winsock because we use GetHostByAddr to do so

  WsaInitialized := False;
  if ResolveNames then
  begin
    // Ask for a low version of Winsock, we don't need new features so this
    // minimizes the chance initialization will fail
    WsaInitialized := WsaStartup($0101, WsData) = 0;
    if not WsaInitialized then
    begin
      WriteLn('Failed to initialize Winsock. IP to name resolution disabled.');
      WriteLn;
      ResolveNames := False;
    end;
  end;

  // Get the repetition interval, if any

  Interval := GetInterval;

  // If non-zero repetition then the loop below runs until CTRL+C or CTRL+BREAK
  // is pressed. In that case the WsaUninitialize is never executed. Therefore
  // we install a control handler routine which calls WsaUninitialize instead.
  // Of course if this happens we are already on our way out and we could live
  // without the WsaUninitialize but I thought this was a nice opportunity to
  // demo it's usage (thanks to Vladimir Vassiliev for pointing out that the
  // call to WsaUninitialize after the loop wouldn't execute without it).

  if Interval <> 0 then
    SetConsoleCtrlHandler(@CtrlHandler, True);

  // Assume the user specified a repetition interval and loop forever

  while True do
  begin

    // The following looks complex but it's really just a case statement in
    // disguise. Don't spend too much time trying to understand it (I'm not even
    // sure I do myself) just trust that it dispatches control to the appropriate
    // subroutine based on the specified command line switches. Note though that
    // even with this complexity, command line checking is minimal...

    if FindCmdLineSwitch('a', ['/', '-'], True) then
      DisplayConnections('')
    else if FindCmdLineSwitch('r', ['/', '-'], True) then
      DisplayRoutingTable
    else
    begin
      if FindCmdLineSwitch('e', ['/', '-'], True) then
      begin
        DisplayInterfaceStatistics;
        if FindCmdLineSwitch('s', ['/', '-'], True) then
        begin
          if FindCmdLineSwitch('p', ['/', '-'], True) then
          begin
            DisplayProtocolStatistics(ParamStr(4 + ParamIndexOffset));
            DisplayConnections(ParamStr(4 + ParamIndexOffset));
          end
          else
            DisplayProtocolStatistics('');
        end
        else if FindCmdLineSwitch('p', ['/', '-'], True) then
          DisplayConnections(ParamStr(3 + ParamIndexOffset));
      end
      else if FindCmdLineSwitch('s', ['/', '-'], True) then
      begin
        if ParamCount = 1 then
          DisplayProtocolStatistics('')
        else if FindCmdLineSwitch('p', ['/', '-'], True) then
        begin
          DisplayProtocolStatistics(ParamStr(3 + ParamIndexOffset));
          DisplayConnections(ParamStr(3 + ParamIndexOffset));
        end
        else
          Usage;
      end
      else if FindCmdLineSwitch('p', ['/', '-'], True) then
        DisplayConnections(ParamStr(2 + ParamIndexOffset))
      else
        Usage;
    end;

    // Either sleep <interval> seconds and display again or break out of the loop

    if Interval = 0 then
      Break
    else
    begin
      WriteLn;
      WriteLn('Press CTRL+C to quit');
      WriteLn;
      Sleep(1000 * Interval); // Sleep() takes milliseconds
    end;

  end; { while True do }

  // If we initialised it, we must clean up as well (see comment above about the
  // control handler)

  if WsaInitialized then
  begin
    WsaCleanup;
    WsaInitialized := False;
  end;

end.
