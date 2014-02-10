This package contains interface units for the Microsoft Windows IP Helper API.
You'll find these units in the Pas folder:

IpExport.pas 
IpHlpApi.pas
IpIfConst.pas
IpRtrMib.pas
IpTypes.pas

Three demo projects have been provided which are located in the Demos folder:

Arp.dpr       Clone of the Windows arp.exe utility
NetStats.dpr  Clone of the Windows netstat.exe utility
Route.dpr     Clone of the Windows route utility

All these are meant to demonstrate using the IP Helper API and as such are not
identical to their Windows counterparts and may not be bugfree. For production 
systems you should resort to the Microsoft provided utilities.

One addition project is included:

IpTest.zip    Demo/Test project which demo's all functions

To compile these projects you must ensure that the interface units can be found
by Delphi. You can do this placing them somewhere on your search path (for example
in your $(DELPHI)\Lib directory. Please note that these projects work only with
Delphi 4 or higher.

This package is the combined work of
  
  John C. Penman (jcp@craiglockhart.com)
  Marcel van Brakel (brakelm@chello.nl)       
  Vladimir Vassiliev (voldemarv@hotpop.com)        

For additional information about the IP Helper API please refer to the Platform
SDK documentation and John's two part article series in the Delphi Informant 
Magazine (starting March 2001).

[Known Issues]

The Microsoft Platform SDK documentation states that the SetIpForwardEntry can
be used to modify an existing route entry. This appears not to be the case.
Testing shows that this function always adds a new entry regardless of whether
the entry already existed. The route.dpr demo program show a possible workaround,
namely deleting the entry explicitly first.

The macros in IpRtrMib are not converted to functions mainly because although some 
could be converted doing so would be dangerous and practically useless (they use 
C constructs not available in Object Pascal).

[Conditionals]

The IpHlpApi.pas unit supports dynamic linking through two conditional defines:

  
  IPHLPAPI_DYNLINK

    If defined the unit uses dynamic linking, otherwise it uses static linking.
    If defined the function IpHlpApiInitAPI must be called before using any of
    the functions defined in this unit. This call is automatic unless     IPHLPAPI_LINKONREQUEST is also defined. The API is automatically unloaded. If
    IPHLPAPI_LINKONREQUEST is defined, this conditional is automatically defined
    as well.

  IPHLPAPI_LINKONREQUEST

    If defined the unit does not automatically call IpHlpApiInitApi in the 
    initialisation section of the unit instead you must call it yourself explicitly
    before using any of the functions in this unit. Unloading is still automatic.

[Functions]

The following functions are included in IpHlpApi to support dynamic loading:


  function IpHlpApiInitAPI: Boolean;

    Loads the IP Helper API and imports all functions. If IPHLPAPI_DYNLINK is 
    defined this function must be called before any of the others in this unit.
    If the function is successfull it returns True, otherwise it returns False.

  procedure IpHlpApiFreeAPI;


    Unloads the IP Helper API. After calling this function you can no longer use
    any of the functions defined in this unit. This function is automatically
    called from the units finalization section.

  function IpHlpApiCheckAPI: Boolean;

    Call this function to determine whether or not the IP Helper API was initialized.
 