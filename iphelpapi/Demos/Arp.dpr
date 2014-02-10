{******************************************************************}
{                                                                  }
{       Arp.dpr - IP Helper API Demonstration project              }
{                                                                  }
{ Portions created by Marcel van Brakel are                        }
{ Copyright (C) 2000 Marcel van Brakel.                            }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: Arp.dpr, released  December 2000.          }
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

program Arp;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Winsock,
  IpExport, IpHlpApi, IpTypes, IpIfConst, IpRtrMib;

//------------------------------------------------------------------------------

// Convert IP address to dotted decimal

function IpAddrToString(Addr: DWORD): string;
var
  inad: in_addr;
begin
  inad.s_addr := Addr;
  Result := inet_ntoa(inad);
end;

//------------------------------------------------------------------------------

function StringToIpAddr(const Addr: string): DWORD;
begin
  Result := inet_addr(PChar(Addr));
end;

//------------------------------------------------------------------------------

// Converts a physical address to a string. Length is the number of entries in
// the PhysAddr array and PhysAddr itself is the array which contains the
// "encoded" physical address

type
  TPhysAddrByteArray = array [0..MAXLEN_PHYSADDR - 1] of BYTE;

function PhysAddrToString(Length: DWORD; PhysAddr: TPhysAddrByteArray): string;
var
  I: Integer;
begin
  Result := '';
  if Length = 0 then Exit;
  for I := 0 to Length - 1 do
    if I = Integer(Length - 1) then
      Result := Result + Format('%.2x', [PhysAddr[I]])
    else
      Result := Result + (Format('%.2x-', [PhysAddr[I]]));
end;

//------------------------------------------------------------------------------

function CharHex(const C: AnsiChar): Byte;
const
  AnsiDecDigits = ['0'..'9'];
  AnsiHexDigits = ['0'..'9', 'A'..'F', 'a'..'f'];
begin
  Result := $FF;
  if C in AnsiDecDigits then
    Result := Ord(C) - 48
  else if C in AnsiHexDigits then
    Result := Ord(C) - 55;
end;

procedure StringToPhysAddr(PhysAddrString: string; var PhysAddr: TPhysAddrByteArray);
var
  C: Char;
  I, V: Integer;
begin
  Assert(Length(PhysAddrString) = 17);
  Assert(
    (PhysAddrString[3] = '-') and
    (PhysAddrString[6] = '-') and
    (PhysAddrString[9] = '-') and
    (PhysAddrString[12] = '-') and
    (PhysAddrString[15] = '-'));
  PhysAddrString := UpperCase(PhysAddrString);
  for I := 0 to 5 do
  begin
    C := PhysAddrString[I * 3];
    V := CharHex(C) shl 4;
    C := PhysAddrString[(I * 3) + 1];
    V := V + CharHex(C);
    PhysAddr[I] := V;
  end;
end;

//------------------------------------------------------------------------------

// Returns the IP address table. The caller must free the memory.

function GetIpAddrTableWithAlloc: PMibIpAddrTable;
var
  Size: ULONG;
begin
  Size := 0;
  GetIpAddrTable(nil, Size, True);
  Result := AllocMem(Size);
  if GetIpAddrTable(Result, Size, True) <> NO_ERROR then
  begin
    FreeMem(Result);
    Result := nil;
  end;
end;

//------------------------------------------------------------------------------

// Returns the IP address (dotted decimal string representation) of the interface
// with the specified index. IpAddrTable is used for the lookup and must be
// sorted. If IpAddrTable is nil, the returned string is '<unknown>'

function IntfIndexToIpAddress(IpAddrTable: PMibIpAddrTable; Index: DWORD): string;
var
  I: Integer;
begin
  if IpAddrTable = nil then
    Result := '<unknown>'
  else
  begin
    for I := 0 to IpAddrTable^.dwNumEntries - 1 do
    begin
      {$R-}
      if IpAddrTable^.table[I].dwIndex = Index then
      begin
        Result := IpAddrToString(IpAddrTable^.table[I].dwAddr);
        Break;
      end;
      {$R+}
    end;
  end;
end;

//------------------------------------------------------------------------------

// Returns a string representing the ARP entry type

function ArpTypeToString(dwType: DWORD): string;
begin
  case dwType of
    MIB_IPNET_TYPE_OTHER: Result := 'Other';
    MIB_IPNET_TYPE_INVALID: Result := 'Invalid';
    MIB_IPNET_TYPE_DYNAMIC: Result := 'Dynamic';
    MIB_IPNET_TYPE_STATIC: Result := 'Static';
  end;
end;

//------------------------------------------------------------------------------

// Displays the ARP table. Filter specifies an IP address for which to display
// ARP entries. If filter is an empty string, all ARP entries are displayed.

procedure DisplayArpTable(const Filter: string);
var
  Size: ULONG;
  I: Integer;
  NetTable: PMibIpNetTable;      // ARP table
  NetRow: TMibIpNetRow;          // ARP entry from ARP table
  CurrentIndex: DWORD;           // Used for displaying a header in case of multiple interfaces
  IpAddrTable: PMibIpAddrTable;  // Address table used for interface index to IP address mapping 
begin
  Size := 0;
  GetIpNetTable(nil, Size, True);
  NetTable := AllocMem(Size);
  try
    if GetIpNetTable(NetTable, Size, True) = NO_ERROR then
    begin
      // Get the IP address table
      IpAddrTable := GetIpAddrTableWithAlloc;
      try
        // Remember the first interface index and display header
        CurrentIndex := NetTable^.table[0].dwIndex;
        WriteLn(Format('Interface: %s on Interface 0x%u', [IntfIndexToIpAddress(IpAddrTable, CurrentIndex), CurrentIndex]));
        WriteLn('  Internet address     Physical address     Type');
        // For each ARP entry
        for I := 0 to NetTable^.dwNumEntries - 1 do
        begin
          {$R-}NetRow := NetTable^.table[I];{$R+}
          if CurrentIndex <> NetRow.dwIndex then
          begin
            // We're changing interfaces, display a new header
            CurrentIndex := NetRow.dwIndex;
            WriteLn;
            WriteLn(Format('Interface: %s on Interface 0x%u',
              [IntfIndexToIpAddress(IpAddrTable, CurrentIndex), CurrentIndex]));
            WriteLn('  Internet address     Physical address     Type');
          end;
          // Only display the entry if it matches the filter
          if (Filter = '') or (Filter = IpAddrToString(NetRow.dwAddr)) then
            WriteLn(Format('  %-20s %-20s %s', [
              IpAddrToString(NetRow.dwAddr),
              PhysAddrToString(NetRow.dwPhysAddrLen, TPhysAddrByteArray(NetRow.bPhysAddr)),
              ArpTypeToString(NetRow.dwType)]));
        end;
      finally
        FreeMem(IpAddrTable);
      end;
    end
    else
    begin
      // Assume failure of GetIpNetTable means there are no ARP entries. This is
      // usually the case but it could fail for other reasons.
      WriteLn('No ARP entries found.');
    end;
  finally
    FreeMem(NetTable);
  end;
end;

//------------------------------------------------------------------------------

// Deletes Host from the ARP table. Host is either an IP address or '*'. In the
// latter case all hosts are deleted from the ARP table. Intf is the internet
// address (IP address) of the interface for which to delete the applicable
// ARP entries. If empty, Host is deleted from each interface ARP table.

function IpAddressToAdapterIndex(const Intf: string): Integer; overload;
var
  Adapters, Adapter: PIpAdapterInfo;
  Size: ULONG;
  IpAddrString: PIpAddrString;
begin
  Result := -1;
  Size := 0;
  if GetAdaptersInfo(nil, Size) <> ERROR_BUFFER_OVERFLOW then Exit;
  Adapters := AllocMem(Size);
  try
    if GetAdaptersInfo(Adapters, Size) = NO_ERROR then
    begin
      Adapter := Adapters;
      while Adapter <> nil do
      begin
        IpAddrString := @Adapter^.IpAddressList;
        while IpAddrString <> nil do
        begin
          if CompareText(IpAddrString^.IpAddress.S, Intf) = 0 then
          begin
            Result := Adapter^.Index;
            Exit;
          end;
          IpAddrString := IpAddrString^.Next;
        end;
        Adapter := Adapter^.Next;
      end;
    end;
  finally
    FreeMem(Adapters);
  end;
end;

function IpAddressToAdapterIndex(const Intf: DWORD): Integer; overload;
var
  Size: ULONG;
  AddrTable: PMibIpAddrTable;
  AddrRow: TMibIpAddrRow;
  I: Integer;
begin
  Result := -1;
  Size := 0;
  if GetIpAddrTable(nil, Size, True) <> ERROR_INSUFFICIENT_BUFFER then Exit;
  AddrTable := AllocMem(Size);
  try
    if GetIpAddrTable(AddrTable, Size, True) = NO_ERROR then
    begin
      for I := 0 to AddrTable^.dwNumEntries - 1 do
      begin
        {$R-}AddrRow := AddrTable^.Table[I];{$R+}
        if AddrRow.dwAddr = Intf then
        begin
          Result := AddrRow.dwIndex;
          Break;
        end;
      end;
    end;
  finally
    FreeMem(AddrTable);
  end;
end;

procedure DeleteArpEntry(const Host, Intf: string);
var
  Entry: TMibIpNetRow;
  HostAddr, IntfAddr: DWORD;
  Size: ULONG;
  Adapters, Adapter: PIpAdapterInfo;
begin
  FillChar(Entry, SizeOf(Entry), 0);

  HostAddr := 0; // shuts up the compiler
  if Host <> '*' then
  begin
    HostAddr := inet_addr(PChar(Host));
    if HostAddr = DWORD(INADDR_NONE) then Exit;
  end;
  if Intf <> '' then
  begin
    IntfAddr := inet_addr(PChar(Intf));
    if IntfAddr = DWORD(INADDR_NONE) then Exit;
  end;

  { delete address from interface }

  if (Host <> '*') and (Intf <> '') then
  begin
    Entry.dwIndex := IpAddressToAdapterIndex(Intf);
    Entry.dwAddr := HostAddr;
    if DeleteIpNetEntry(Entry) = NO_ERROR then
      WriteLn('Deleted')
    else
      WriteLn('Failed');
    Exit;
  end;

  { delete all addresses from an interface }

  if (Host = '*') and (Intf <> '') then
  begin
    FlushIpNetTable(IpAddressToAdapterIndex(Intf));
    Exit;
  end;


  Size := 0;
  if GetAdaptersInfo(nil, Size) <> ERROR_BUFFER_OVERFLOW then Exit;
  Adapters := AllocMem(Size);
  try
    if GetAdaptersInfo(Adapters, Size) = NO_ERROR then
    begin
      Adapter := Adapters;
      while Adapter <> nil do
      begin

        { delete all addresses from each interface }

        if (Host = '*') and (Intf = '') then
        begin
          FlushIpNetTable(Adapter.Index);
        end;

        { delete address from each interface }

        if (Host <> '*') and (Intf = '') then
        begin
          FillChar(Entry, SizeOf(Entry), 0);
          Entry.dwIndex := Adapter.Index;
          Entry.dwAddr := HostAddr;
          DeleteIpNetEntry(Entry);
        end;

        Adapter := Adapter^.Next;
      end;
    end;
  finally
    FreeMem(Adapters);
  end;

end;

//------------------------------------------------------------------------------

// Returns the interface index of the first ...

function FirstNetworkAdapter(IpAddrTable: PMibIpAddrTable): Integer;
var
  I: Integer;
  IfInfo: TMibIfRow;
begin
  // TODO this is a "stupid" implementation, can be done much easier by using
  // enumerating the interface table directly
  Result := -1;
  for I := 0 to IpAddrTable^.dwNumEntries - 1 do
  begin
    {$R-}IfInfo.dwIndex := IpAddrTable^.table[I].dwIndex;{$R+}
    if GetIfEntry(@IfInfo) = NO_ERROR then
    begin
      if IfInfo.dwType in [MIB_IF_TYPE_ETHERNET, MIB_IF_TYPE_TOKENRING] then
      begin
        Result := IfInfo.dwIndex;
        Break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

// Adds an entry to the ARP table. InetAddr is the IP address to add, EtherAddr
// is the ethernet address to associate with the InetAddr and IntfAddr is the
// index of the adapter to add this ARP entry to. If IntfAddr is an empty string
// the function uses the first network adapter (tokenring or ethernet) it can
// find.

procedure SetArpEntry(const InetAddr, EtherAddr, IntfAddr: string);
var
  Entry: TMibIpNetRow;
  IpAddrTable: PMibIpAddrTable;
begin
  FillChar(Entry, SizeOf(Entry), 0);
  Entry.dwAddr := StringToIpAddr(InetAddr);
  Assert(Entry.dwAddr <> DWORD(INADDR_NONE));
  Entry.dwPhysAddrLen := 6;
  StringToPhysAddr(EtherAddr, TPhysAddrByteArray(Entry.bPhysAddr));
  Entry.dwType := MIB_IPNET_TYPE_STATIC;
  if IntfAddr <> '' then
    Entry.dwIndex := StrToInt(IntfAddr)
  else
  begin
    IpAddrTable := GetIpAddrTableWithAlloc;
    Assert(IpAddrTable <> nil);
    Entry.dwIndex := FirstNetworkAdapter(IpAddrTable);
    FreeMem(IpAddrTable);
  end;
  WriteLn(SysErrorMessage(SetIpNetEntry(Entry)));
end;

//------------------------------------------------------------------------------

// How is this program to be used by the end user?

procedure Usage;
begin
  WriteLn('Displays and modifies the IP-to-Physical address translation table used by');
  WriteLn('the address resolution protocol (ARP).');
  WriteLn;
  WriteLn('ARP -s inet_addr eth_addr [if_addr]');
  WriteLn('ARP -d inet_addr [if_addr]');
  WriteLn('ARP -a inet_addr [-N if_addr]');
  WriteLn;
  WriteLn('  -a         Displays current ARP entries by interrogating the current protocol');
  WriteLn('             data. If inet_addr is specified, the IP and physical addresses for');
  WriteLn('             only the specified computer are displayed. If more than one network');
  WriteLn('             interface uses ARP, entries for each for each ARP table are displayed.');
  WriteLn('  -g         Same as -a');
  WriteLn('  inet_addr  Specifies an internet address.');
  WriteLn('  -N if_addr Displays the ARP entries for the network interface specified by if_addr.');
  WriteLn('  -d         Deletes the host specified by inet_addr. inet_addr may be wildcarded');
  WriteLn('             with * to delete all hosts.');
  WriteLn('  -s         Adds the host and associates the internet address inet_addr with the');
  WriteLn('             physical address eth_addr. The physical address is given as 6');
  WriteLn('             hexadecimal bytes separated by hyphens.  The entry is permanent.');
  WriteLn('  eth_addr   Specifies a physical address.');
  WriteLn('  if_addr    If present, this specifies the index of the interface whose address');
  WriteLn('             translation tables should be modified. If not present the first found');
  WriteLn('             applicable interface will be used.');
  WriteLn('Example:');
  WriteLn('  > arp -s 157.55.85.212 00-aa-00-62-c6-09  .... Adds a static entry');
  WriteLn('  > arp -a                                  .... Displays the ARP table');
  WriteLn('  > arp -d *                                .... Flushes the ARP table'); 
end;

begin

  WriteLn('');
  WriteLn('Windows 2000 Arp');
  WriteLn('Copyright (C) 2000 Marcel van Brakel');
  WriteLn('');

  if (ParamCount = 0) or FindCmdLineSwitch('?', ['/', '-'], True) then
  begin
    Usage;
    Exit;
  end;

  // Case statement (in disquise) on the command line switches which dispatches
  // to the appropriate subroutine for further processing.

  if FindCmdLineSwitch('a', ['/', '-'], True) or FindCmdLineSwitch('g', ['/', '-'], True) then
    DisplayArpTable(ParamStr(2))
  else if FindCmdLineSwitch('d', ['/', '-'], True) then
    DeleteArpEntry(ParamStr(2), ParamStr(3))
  else if FindCmdLineSwitch('s', ['/', '-'], True) then
    SetArpEntry(ParamStr(2), ParamStr(3), ParamStr(4))
  else
    Usage;

end.
