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

// PASTLWTR : 1.2
// File generated on 2013-11-30 8:50:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\convnet\Convnet Clinet Com Version\convnet.tlb (1)
// LIBID: {A7819915-E15F-4360-8691-7D51BF2659C7}
// LCID: 0
// Helpfile: 
// HelpString: convnet Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

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

  LIBID_convnet: TGUID = '{A7819915-E15F-4360-8691-7D51BF2659C7}';

  IID_IcoConvnet: TGUID = '{2344224D-6FE1-494E-88C8-7A7785B92EF6}';
  DIID_IcoConvnetEvents: TGUID = '{D4DA9B12-8BC6-4ED7-9FF9-19E13E103DAD}';
  CLASS_coConvnet: TGUID = '{7B6A5FCC-9F50-4FBC-A68D-C7E6D2F4AD6C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IcoConvnet = interface;
  IcoConvnetDisp = dispinterface;
  IcoConvnetEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  coConvnet = IcoConvnet;


// *********************************************************************//
// Interface: IcoConvnet
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2344224D-6FE1-494E-88C8-7A7785B92EF6}
// *********************************************************************//
  IcoConvnet = interface(IDispatch)
    ['{2344224D-6FE1-494E-88C8-7A7785B92EF6}']
    procedure ConnectToServer(const ServerUrl: WideString; const UserName: WideString; 
                              const PassWord: WideString); safecall;
    procedure ApplyForJoinGroup(groupid: SYSINT; const applyinfo: WideString); safecall;
    procedure RegistUser(const ServerUrl: WideString; const UserName: WideString; 
                         const PassWord: WideString; const nick: WideString; 
                         const desc: WideString; const email: WideString); safecall;
    procedure ShowForm; safecall;
    procedure HiddenForm; safecall;
  end;

// *********************************************************************//
// DispIntf:  IcoConvnetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2344224D-6FE1-494E-88C8-7A7785B92EF6}
// *********************************************************************//
  IcoConvnetDisp = dispinterface
    ['{2344224D-6FE1-494E-88C8-7A7785B92EF6}']
    procedure ConnectToServer(const ServerUrl: WideString; const UserName: WideString; 
                              const PassWord: WideString); dispid 201;
    procedure ApplyForJoinGroup(groupid: SYSINT; const applyinfo: WideString); dispid 202;
    procedure RegistUser(const ServerUrl: WideString; const UserName: WideString; 
                         const PassWord: WideString; const nick: WideString; 
                         const desc: WideString; const email: WideString); dispid 203;
    procedure ShowForm; dispid 204;
    procedure HiddenForm; dispid 205;
  end;

// *********************************************************************//
// DispIntf:  IcoConvnetEvents
// Flags:     (4096) Dispatchable
// GUID:      {D4DA9B12-8BC6-4ED7-9FF9-19E13E103DAD}
// *********************************************************************//
  IcoConvnetEvents = dispinterface
    ['{D4DA9B12-8BC6-4ED7-9FF9-19E13E103DAD}']
    procedure OnCVNMessage(const cvnmessage: WideString; cvnmsgtype: SYSINT); dispid 201;
  end;

// *********************************************************************//
// The Class CocoConvnet provides a Create and CreateRemote method to          
// create instances of the default interface IcoConvnet exposed by              
// the CoClass coConvnet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CocoConvnet = class
    class function Create: IcoConvnet;
    class function CreateRemote(const MachineName: string): IcoConvnet;
  end;

implementation

uses ComObj;

class function CocoConvnet.Create: IcoConvnet;
begin
  Result := CreateComObject(CLASS_coConvnet) as IcoConvnet;
end;

class function CocoConvnet.CreateRemote(const MachineName: string): IcoConvnet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_coConvnet) as IcoConvnet;
end;

end.
