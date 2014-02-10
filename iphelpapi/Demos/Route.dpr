{******************************************************************}
{                                                                  }
{       Route.dpr - IP Helper API Demonstration project            }
{                                                                  }
{ Portions created by Vladimir Vassiliev are                       }
{ Copyright (C) 2000 Vladimir Vassiliev.                           }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: Route.dpr, released  December 2000.        }
{ The initial developer of the Pascal code is Vladimir Vassiliev   }
{ (voldemarv@hotpop.com).                                          }
{ 								   }
{ Contributor(s): Marcel van Brakel (brakelm@chello.nl)            }
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

program Route;

{$APPTYPE CONSOLE}
{$R-}
{$B-}

uses
  Windows,
  SysUtils,
  Winsock,
  Registry,
  IpExport,
  IpHlpApi,
  IpTypes,
  IpIfConst,
  IpRtrMib;

const
  PersistentKey = 'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes';
  sNotSupported = 'Function %s is not supported by the operating system.';
  sCanNotComplete = 'Can''t complete function %s';
  sRouteNotFound = 'The route specified was not found.';

//------------------------------------------------------------------------------

// Skip additional switches in command line

procedure SkipCmdSwitchs(var Index: Integer);
begin
  while (Index < ParamCount) and (ParamStr(Index +1)[1] in ['-','/']) do
    Inc(Index);
end;

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

// Clears routing table

procedure DoClearTable;
var
  Size: ULONG;
  ForwardTable: PMibIpForwardTable;
  ForwardRow: TMibIpForwardRow;
  I: Integer;
begin
  Size := 0;
  if not GetIpForwardTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  ForwardTable := AllocMem(Size);
  try
    if GetIpForwardTable(ForwardTable, Size, True) = ERROR_SUCCESS then
    begin
      for I := 0 to ForwardTable^.dwNumEntries - 1 do
      begin
        ForwardRow := ForwardTable^.Table[I];
        DeleteIpForwardEntry(ForwardRow);
      end;
    end;
  finally
    FreeMem(ForwardTable);
  end;
end;

//------------------------------------------------------------------------------

// Displays the Interface List

procedure DisplayInterfaceList;
var
  IfTable: PMibIfTable;
  Row: TMibIfRow;
  Size: ULONG;
  I, J: Integer;
  S: string;
begin
  Size := 0;
  if not GetIfTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  IfTable := AllocMem(Size);
  try
    if GetIfTable(IfTable, Size, True) = ERROR_SUCCESS then
    begin
      WriteLn(StringOfChar('=', 75));
      WriteLn('Interface List');
      for I := 0 to IfTable^.dwNumEntries - 1 do
      begin
        Row := IfTable^.Table[I];
        Write(Format('0x%-x ..... ', [Row.dwIndex]));
        S := '';
        for J := 0 to Row.dwDescrLen - 1 do
          S := S + Chr(Row.bDescr[J]);
        WriteLn(S);
      end;
      WriteLn(StringOfChar('=', 75));
    end;
  finally
    FreeMem(IfTable);
  end;
end;

//------------------------------------------------------------------------------

// Find IP address of particular interface

function GetIpAddress(AdapterNo: DWORD): DWORD;
var
  Size: ULONG;
  IpAddrTable: PMibIpAddrTable;
  IpAddrRow: TMibIpAddrRow;
  I: Integer;
begin
  Result := 0;
  Size := 0;
  if not GetIpAddrTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  IpAddrTable := AllocMem(Size);
  try
    if GetIpAddrTable(IpAddrTable, Size, True) = ERROR_SUCCESS then
      for I := 0 to IpAddrTable^.dwNumEntries - 1 do
      begin
        IpAddrRow := IpAddrTable^.Table[I];
        if AdapterNo = IpAddrRow.dwIndex then Result := IpAddrRow.dwAddr;
      end;
  finally
    FreeMem(IpAddrTable);
  end;
end;

//------------------------------------------------------------------------------

// Displays the routing table

procedure DisplayRoutingTable(Destination, GateWay: string);
var
  ForwardTable: PMibIpForwardTable;
  ForwardRow: TMibIpForwardRow;
  Dest: string;
  Gate: string;
  Size: ULONG;
  I: Integer;
begin
  Size := 0;
  if not GetIpForwardTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  ForwardTable := AllocMem(Size);
  try
    if GetIpForwardTable(ForwardTable, Size, True) = ERROR_SUCCESS then
    begin
      WriteLn('Active Routes');
      WriteLn('Network Destination        Netmask          Gateway       Interface  Metric');
      for I := 0 to ForwardTable^.dwNumEntries - 1 do
      begin
        ForwardRow := ForwardTable^.Table[I];
        Dest := IpAddrToString(ForwardRow.dwForwardDest);
        Gate := IpAddrToString(ForwardRow.dwForwardNextHop);
        if ((Destination = '') or (Pos(Destination, Dest) > 0)) and
          ((GateWay = '') or (Pos(GateWay, Dest) > 0)) then
        begin
          Write(Format('%17s', [Dest]));
          Write(Format('%17s', [IpAddrToString(ForwardRow.dwForwardMask)]));
          Write(Format('%17s', [Gate]));
          Write(Format('%17s', [IpAddrToString(GetIpAddress(ForwardRow.dwForwardIfIndex))]));
          Write(Format('%7s', [IntToStr(ForwardRow.dwForwardMetric1)]));
          WriteLn;
        end;
      end;
      WriteLn(StringOfChar('=', 75));
    end;
  finally
    FreeMem(ForwardTable);
  end;
end;

//------------------------------------------------------------------------------

// Saves routing information to registry if needed (-p switch)

procedure SavePersistentRoute(const Route, Name: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(PersistentKey, True) then Reg.WriteString(Route, Name);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------

// Deletes persistent routing information from registry

function DeletePersistentRoute(const Route: string): boolean;
var
  Reg: TRegistry;
begin
  Result:=False;
  Reg := TRegistry.Create;
  with Reg do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(PersistentKey, False) then Result := DeleteValue(Route);
    finally
      CloseKey;
      Free;
    end;
end;

//------------------------------------------------------------------------------

// Creates new route

procedure CreateIpEntry(Destination, Mask, Gateway, Metric, aIfNo: string; Persistent: boolean);
var
  Route: TMibIpForwardRow;
  Res: DWORD;
  IfNo: DWORD; // The interface number
begin
  if Metric = '' then Metric := '1';

  IfNo := DWORD(-1);
  if aIfNo = '' then
  begin
    Res := GetBestInterface(inet_addr(PChar(GateWay)), IfNo);
    case Res of
      ERROR_SUCCESS: ;
      ERROR_NOT_SUPPORTED:
        WriteLn(Format(sNotSupported, ['GetBestInterface']));
      ERROR_CAN_NOT_COMPLETE:
        WriteLn(Format(sCanNotComplete, ['GetBestInterface']));
    else
      WriteLn(SysErrorMessage(GetLastError));
    end;
  end
  else
    IfNo := StrToIntDef(aIfNo, -1);

  if IfNo = DWORD(-1) then
  begin
    WriteLn('Interface is not found.');
    Exit;
  end;

  FillChar(Route, SizeOf(Route), #0);
  with Route do
  begin
    dwForwardDest := inet_addr(PChar(Destination));
    dwForwardMask := inet_addr(PChar(Mask));
    dwForwardPolicy := 0;  // Should be zero from Microsoft Help
    dwForwardNextHop := inet_addr(PChar(Gateway));
    dwForwardIfIndex := IfNo;
    dwForwardType := 3; //The next hop is the final destination (local route).
    dwForwardProto := 3; // PROTO_IP_NETMGMT from Microsoft Help (const in Routprot.h)
    dwForwardAge := 0;
    dwForwardNextHopAS := 0;
    dwForwardMetric1 := StrToIntDef(Metric, 1);
    dwForwardMetric2 := DWORD(-1);
    dwForwardMetric3 := DWORD(-1);
    dwForwardMetric4 := DWORD(-1);
    dwForwardMetric5 := DWORD(-1);
  end;
  Res := CreateIpForwardEntry(Route);
  case Res of
    NO_ERROR:
      if Persistent then
        SavePersistentRoute(Destination + ',' + Mask + ',' + Gateway + ',' + Metric, Chr(10));
    ERROR_INVALID_PARAMETER:
      WriteLn('Invalid parameter');
    ERROR_NOT_SUPPORTED:
      WriteLn('The IP transport is not configured on the local computer.');
  else
    WriteLn(SysErrorMessage(GetLastError));
  end;
end;

//------------------------------------------------------------------------------

// Delete a row from the routing table

function DeleteIpEntry(const Destination, GateWay: string): boolean;
var
  ForwardTable: PMibIpForwardTable;
  ForwardRow: TMibIpForwardRow;
  Dest: string;
  Gate: string;
  Mask: string;
  Size: ULONG;
  I: Integer;
begin
  Size := 0;
  Result:=False;
  if not GetIpForwardTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  ForwardTable := AllocMem(Size);
  try
    if GetIpForwardTable(ForwardTable, Size, True) = ERROR_SUCCESS then
    begin
      for I := 0 to ForwardTable^.dwNumEntries - 1 do
      begin
        ForwardRow := ForwardTable^.Table[I];
        Dest := IpAddrToString(ForwardRow.dwForwardDest);
        Gate := IpAddrToString(ForwardRow.dwForwardNextHop);
        if ((Destination = '') or (Pos(Destination, Dest) > 0)) and
          ((GateWay = '') or (Pos(GateWay, Dest) > 0)) then
        begin
          Result := True;
          Mask := IpAddrToString(ForwardRow.dwForwardMask);
          DeleteIpForwardEntry(ForwardRow);
          DeletePersistentRoute(Dest + ',' + Mask + ',' + Gate + ',' + IntToStr(ForwardRow.dwForwardMetric1));
        end;
      end;
    end;
  finally
    FreeMem(ForwardTable);
  end;
end;

//------------------------------------------------------------------------------

procedure ModifyIpEntry(aDestination, aMask, aGateway, aMetric, aIfNo: string;
  aPersistent: boolean);
var
  ForwardTable: PMibIpForwardTable;
  ForwardRow: TMibIpForwardRow;
  Dest: string;
  Gate: string;
  Mask: string;
  Size: ULONG;
  I: Integer;
  Found: boolean;
begin
  Size := 0;
  Found := False;
  if not GetIpForwardTable(nil, Size, True) = ERROR_BUFFER_OVERFLOW then Exit;
  ForwardTable := AllocMem(Size);
  try
    if GetIpForwardTable(ForwardTable, Size, True) = ERROR_SUCCESS then
      for I := 0 to ForwardTable^.dwNumEntries - 1 do
      begin
        ForwardRow := ForwardTable^.Table[I];
        Dest := IpAddrToString(ForwardRow.dwForwardDest);
        if (Pos(aDestination, Dest) > 0) then
        begin
          Mask := IpAddrToString(ForwardRow.dwForwardMask);
          Gate := IpAddrToString(ForwardRow.dwForwardNextHop);
          Found := True;
          DeleteIpForwardEntry(ForwardRow);
          DeletePersistentRoute(Dest + ',' + Mask + ',' + Gate + ',' + IntToStr(ForwardRow.dwForwardMetric1));
          break;
        end;
      end;
  finally
    FreeMem(ForwardTable);
  end;
  if Found then
    CreateIpEntry(Dest, aMask, aGateway, aMetric, aIfNo, aPersistent)
  else
    WriteLn(sRouteNotFound);
end;

//------------------------------------------------------------------------------

// How is this program to be used by the end user?

procedure Usage;
begin
  WriteLn;
  WriteLn('Manipulates network routing tables.');
  WriteLn;
  WriteLn('ROUTE [-f] [-p] [command [destination]');
  WriteLn('                  [MASK netmask]  [gateway] [METRIC metric]  [IF interface]');
  WriteLn;
  WriteLn('  -f           Clears the routing tables of all gateway entries.  If this is');
  WriteLn('               used in conjunction with one of the commands, the tables are');
  WriteLn('               cleared prior to running the command.');
  WriteLn('  -p           When used with the ADD command, makes a route persistent across');
  WriteLn('               boots of the system. By default, routes are not preserved');
  WriteLn('               when the system is restarted. ');
  WriteLn('               Ignored for all other commands, which always affect the appropriate');
  WriteLn('               persistent routes.');
  WriteLn('  command      One of these:');
  WriteLn('                 PRINT     Prints  a route');
  WriteLn('                 ADD       Adds    a route');
  WriteLn('                 DELETE    Deletes a route');
  WriteLn('                 CHANGE    Modifies an existing route');
  WriteLn('  destination  Specifies the host.');
  WriteLn('  MASK         Specifies that the next parameter is the ''netmask'' value.');
  WriteLn('  netmask      Specifies a subnet mask value for this route entry.');
  WriteLn('               If not specified, it defaults to 255.255.255.255.');
  WriteLn('  gateway      Specifies gateway.');
  WriteLn('  interface    the interface number for the specified route.');
  WriteLn('Displays protocol statistics and current TCP/IP connections.');
  WriteLn('  METRIC       specifies the metric, ie. cost for the destination.');
  WriteLn;
  WriteLn('Diagnostic Notes:');
  WriteLn('    Invalid MASK generates an error, that is when (DEST & MASK) != DEST.');
  WriteLn('    Example> route ADD 157.0.0.0 MASK 155.0.0.0 157.55.80.1 IF 1');
  WriteLn('             The route addition failed: 87');
  WriteLn;
  WriteLn('Examples:');
  WriteLn;
  WriteLn('    > route PRINT');
  WriteLn('    > route ADD 157.0.0.0 MASK 255.0.0.0  157.55.80.1 METRIC 3 IF 2');
  WriteLn('             destination^      ^mask      ^gateway     metric^    ^');
  WriteLn('                                                         Interface^');
  WriteLn('      If IF is not given, it tries to find the best interface for a given');
  WriteLn('      gateway.');
  WriteLn('    > route PRINT');
  WriteLn('    > route PRINT 157*          .... Only prints those matching 157*');
  WriteLn('    > route DELETE 157.0.0.0');
  WriteLn('    > route PRINT');
  WriteLn;
end;

//------------------------------------------------------------------------------

var
  ParamIndexOffset: Integer; // Used to offset access to ParamStr in case -p is used
  ClearTable: Boolean; // -f switch Clear routing table before operation;
  Persistent: Boolean; // -p makes or displays persistent routes
  PrintTable: Boolean; // print routing table
  AddRoute: Boolean;
  DeleteRoute: Boolean;
  ModifyRoute: Boolean;
  Destination: string; // Destination parameter;
  S: string;
  Mask, GateWay, Metric: string;
  IfNo: string; // Number of the interface (input parameter)
begin
  WriteLn('');
  WriteLn('Windows 2000&NT Route');
  WriteLn('Copyright (C) 2000 Vladimir Vassiliev');
  WriteLn('');

  if FindCmdLineSwitch('?', ['/', '-'], True) then
  begin
    Usage;
    Exit;
  end;

  ParamIndexOffset := 0;
  ClearTable := False;
  if FindCmdLineSwitch('f', ['/', '-'], True) then
    ClearTable := True;

  Persistent := False;
  if FindCmdLineSwitch('p', ['/', '-'], True) then
    Persistent := True;

  SkipCmdSwitchs(ParamIndexOffset);

  if (ParamCount <= ParamIndexOffset) then
  begin
    Usage;
    Exit;
  end;

  Inc(ParamIndexOffset);
  S :=LowerCase(ParamStr(ParamIndexOffset));
  PrintTable := (S = 'print');
  AddRoute := (S = 'add');
  DeleteRoute := (S = 'delete');
  ModifyRoute := (S = 'change');

  if not (PrintTable or AddRoute or DeleteRoute or ModifyRoute) then
  begin
    Usage;
    Exit;
  end;

  SkipCmdSwitchs(ParamIndexOffset);

  if (ParamCount > ParamIndexOffset) and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) <> 'mask') and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) <> 'metric') and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) <> 'if') then
  begin
    Inc(ParamIndexOffset);
    Destination := ParamStr(ParamIndexOffset)
  end
  else
    Destination := '';

  SkipCmdSwitchs(ParamIndexOffset);

  Mask := '';
  if (ParamCount > ParamIndexOffset) and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) = 'mask') then
  begin
    Inc(ParamIndexOffset);
    if (ParamCount > ParamIndexOffset) then
    begin
      Inc(ParamIndexOffset);
      Mask := ParamStr(ParamIndexOffset);
    end;
  end;

  SkipCmdSwitchs(ParamIndexOffset);

  GateWay := '';
  if (ParamCount > ParamIndexOffset) and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) <> 'metric') and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) <> 'if') then
  begin
    Inc(ParamIndexOffset);
    GateWay := ParamStr(ParamIndexOffset)
  end;

  SkipCmdSwitchs(ParamIndexOffset);

  Metric := '';
  if (ParamCount > ParamIndexOffset) and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) = 'metric') then
  begin
    Inc(ParamIndexOffset);
    if (ParamCount > ParamIndexOffset) then
    begin
      Inc(ParamIndexOffset);
      Metric := ParamStr(ParamIndexOffset)
    end;
  end;

  SkipCmdSwitchs(ParamIndexOffset);

  IfNo := '';
  if (ParamCount > ParamIndexOffset) and
    (LowerCase(ParamStr(ParamIndexOffset + 1)) = 'if') then
  begin
    Inc(ParamIndexOffset);
    if (ParamCount > ParamIndexOffset) then
    begin
      Inc(ParamIndexOffset);
      IfNo := ParamStr(ParamIndexOffset)
    end;
  end;

  if PrintTable then
  begin
    DisplayInterfaceList;
    DisplayRoutingTable(Destination, GateWay);
    Exit;
  end;

  if AddRoute then
  begin
    if (Destination = '') or (Mask = '') or (GateWay = '') then
    begin
      Usage;
      Exit;
    end;
    if ClearTable then
      DoClearTable;
    CreateIpEntry(Destination, Mask, Gateway, Metric, IfNo, Persistent);
    Exit;
  end;

  if DeleteRoute then
  begin
    if (Destination = '') and (GateWay = '') then
    begin
      Usage;
      Exit;
    end;
    if ClearTable then
      DoClearTable;
    if not DeleteIpEntry(Destination, GateWay) then
      WriteLn(sRouteNotFound);
    Exit;
  end;

  if ModifyRoute then
  begin
    if (Destination = '') or (Mask = '') or (GateWay = '') then
    begin
      Usage;
      Exit;
    end;
    if ClearTable then
      DoClearTable;
    ModifyIpEntry(Destination, Mask, Gateway, Metric, IfNo, Persistent);
    Exit;
  end;

end.
