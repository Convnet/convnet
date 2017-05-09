unit convnet_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 2017/4/12 14:26:47 from Type Library described below.

// ************************************************************************  //
// Type Lib: F:\convnet\CVN_ComClient - 国家的崛起\convnet (1)
// LIBID: {ED1AFD91-27DB-4AB3-A90F-B13E91AF5ACF}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  convnetMajorVersion = 1;
  convnetMinorVersion = 0;

  LIBID_convnet: TGUID = '{ED1AFD91-27DB-4AB3-A90F-B13E91AF5ACF}';

  IID_IconvnetClient: TGUID = '{43846AEE-D810-4136-82BA-354671CEA723}';
  CLASS_convnetClient: TGUID = '{C0C7E7BB-3FE0-4AD8-851B-AD65C117A9B4}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IconvnetClient = interface;
  IconvnetClientDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  convnetClient = IconvnetClient;


// *********************************************************************//
// Interface: IconvnetClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {43846AEE-D810-4136-82BA-354671CEA723}
// *********************************************************************//
  IconvnetClient = interface(IDispatch)
    ['{43846AEE-D810-4136-82BA-354671CEA723}']
    procedure Login(const ServerIP: WideString; const Username: WideString;
                    const Password: WideString); safecall;
    procedure GetUserStatusByID(const userid: WideString); safecall;
    procedure JoinGroup(GroupId: Integer; const OrderStrring: WideString); safecall;
    function Getusers: OleVariant; stdcall;
    procedure Connected; safecall;
    procedure Logout; safecall;
    procedure Close; safecall;
    procedure ConnectUserByID; safecall;
    function GetUserIDByName: SYSINT; stdcall;
    function GetUserNameByID: WideString; stdcall;
    function GetUserCount: SYSINT; stdcall;
    procedure GetUserByIndex; safecall;
    procedure Method1; safecall;
  end;

// *********************************************************************//
// DispIntf:  IconvnetClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {43846AEE-D810-4136-82BA-354671CEA723}
// *********************************************************************//
  IconvnetClientDisp = dispinterface
    ['{43846AEE-D810-4136-82BA-354671CEA723}']
    procedure Login(const ServerIP: WideString; const Username: WideString;
                    const Password: WideString); dispid 201;
    procedure GetUserStatusByID(const userid: WideString); dispid 202;
    procedure JoinGroup(GroupId: Integer; const OrderStrring: WideString); dispid 203;
    function Getusers: OleVariant; dispid 204;
    procedure Connected; dispid 205;
    procedure Logout; dispid 206;
    procedure Close; dispid 207;
    procedure ConnectUserByID; dispid 208;
    function GetUserIDByName: SYSINT; dispid 209;
    function GetUserNameByID: WideString; dispid 210;
    function GetUserCount: SYSINT; dispid 211;
    procedure GetUserByIndex; dispid 212;
    procedure Method1; dispid 213;
  end;

// *********************************************************************//
// The Class CoconvnetClient provides a Create and CreateRemote method to
// create instances of the default interface IconvnetClient exposed by
// the CoClass convnetClient. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoconvnetClient = class
    class function Create: IconvnetClient;
    class function CreateRemote(const MachineName: string): IconvnetClient;
  end;

implementation

uses System.Win.ComObj;

class function CoconvnetClient.Create: IconvnetClient;
begin
  Result := CreateComObject(CLASS_convnetClient) as IconvnetClient;
end;

class function CoconvnetClient.CreateRemote(const MachineName: string): IconvnetClient;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_convnetClient) as IconvnetClient;
end;

end.

