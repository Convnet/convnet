
{*******************************************************}
{                                                       }
{       Windows Sockets API v. 2.20 Header File         }
{                                                       }
{		Prerelease 16.09.96                                 }
{                                                       }
{       Base:	  WinSock2.h from Winsock SDK 1.6 BETA    }
{               Delphi 2 RTL Windows32 API Interface    } 
{                                                       }
{       (c) 1996 by Artur Grajek 'AHS'                  }
{	email: c51725ag@juggernaut.eti.pg.gda.pl              }
{                                                       }
{*******************************************************}
{$MINENUMSIZE 4} { Force 4 bytes enumeration size}

unit WinSock2;

interface

uses Windows;

type
  u_char = Char;
  u_short = Word;
  u_int = Integer;
  u_long = Longint;
  pu_long = ^u_long;
  pu_short = ^u_short;

{ The new type to be used in all
  instances which refer to sockets. }
  TSocket = u_int;

const
  FD_SETSIZE     =   64;

type
  PFDSet = ^TFDSet;
  TFDSet = packed record
    fd_count: u_int;
    fd_array: array[0..FD_SETSIZE-1] of TSocket;
  end;

  PTimeVal = ^TTimeVal;
  TTimeVal = packed record
    tv_sec: Longint;
    tv_usec: Longint;
  end;

const
  IOCPARM_MASK = $7f;
  IOC_VOID     = $20000000;
  IOC_OUT      = $40000000;
  IOC_IN       = $80000000;
  IOC_INOUT    = (IOC_IN or IOC_OUT);

  FIONREAD     = IOC_OUT or { get # bytes to read }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
  FIONBIO      = IOC_IN or { set/clear non-blocking i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;
  FIOASYNC     = IOC_IN or { set/clear async i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 125;


const

{ Protocols }

  IPPROTO_IP     =   0;		{ Dummy					}
  IPPROTO_ICMP   =   1;		{ Internet Control Message Protocol }
  IPPROTO_IGMP   =   2;		{ Internet Group Management Protocol}
  IPPROTO_GGP    =   3;		{ Gateway                           }
  IPPROTO_TCP    =   6;		{ TCP           			}
  IPPROTO_PUP    =   12;	{ PUP					}
  IPPROTO_UDP    =   17;	{ User Datagram Protocol		}
  IPPROTO_IDP    =   22;	{ XNS IDP				}
  IPPROTO_ND     =   77;	{ UNOFFICIAL Net Disk Protocol	}

  IPPROTO_RAW    =   255;
  IPPROTO_MAX    =   256;

{ Port/socket numbers: network standard functions}

  IPPORT_ECHO    =   7;
  IPPORT_DISCARD =   9;
  IPPORT_SYSTAT  =   11;
  IPPORT_DAYTIME =   13;
  IPPORT_NETSTAT =   15;
  IPPORT_FTP     =   21;
  IPPORT_TELNET  =   23;
  IPPORT_SMTP    =   25;
  IPPORT_TIMESERVER  =  37;
  IPPORT_NAMESERVER  =  42;
  IPPORT_WHOIS       =  43;
  IPPORT_MTP         =  57;

{ Port/socket numbers: host specific functions }

  IPPORT_TFTP        =  69;
  IPPORT_RJE         =  77;
  IPPORT_FINGER      =  79;
  IPPORT_TTYLINK     =  87;
  IPPORT_SUPDUP      =  95;

{ UNIX TCP sockets }
  
  IPPORT_EXECSERVER  =  512;
  IPPORT_LOGINSERVER =  513;
  IPPORT_CMDSERVER   =  514;
  IPPORT_EFSSERVER   =  520;
  
{ UNIX UDP sockets }

  IPPORT_BIFFUDP     =  512;
  IPPORT_WHOSERVER   =  513;
  IPPORT_ROUTESERVER =  520;
  
{ Ports < IPPORT_RESERVED are reserved for
  privileged processes (e.g. root). }

  IPPORT_RESERVED    =  1024;
  
{ Link numbers }

  IMPLINK_IP         =  155;
  IMPLINK_LOWEXPER   =  156;
  IMPLINK_HIGHEXPER  =  158;

type
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

  SunW = packed record
    s_w1, s_w2: u_short;
  end;

  PInAddr = ^TInAddr;
  TInAddr = packed record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = packed record
    case Integer of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array[0..13] of Char)
  end;
type
  PHostEnt = ^THostEnt;
  THostEnt = packed record
    h_name: PChar;
    h_aliases: ^PChar;
    h_addrtype: Smallint;
    h_length: Smallint;
    case integer of
     0: (h_addr_list: ^PChar);
     1: (h_addr: ^PInAddr);
  end;

  PNetEnt = ^TNetEnt;
  TNetEnt = packed record
    n_name: PChar;
    n_aliases: ^PChar;
    n_addrtype: Smallint;
    n_net: u_long;
  end;

  PServEnt = ^TServEnt;
  TServEnt = packed record
    s_name: PChar;
    s_aliases: ^PChar;
    s_port: Smallint;
    s_proto: PChar;
  end;

  PProtoEnt = ^TProtoEnt;
  TProtoEnt = packed record
    p_name: PChar;
    p_aliases: ^Pchar;
    p_proto: Smallint;
  end;

const
  INADDR_ANY       = $00000000;
  INADDR_LOOPBACK  = $7F000001;
  INADDR_BROADCAST = $FFFFFFFF;
  INADDR_NONE      = $FFFFFFFF;
  
  ADDR_ANY		 = INADDR_ANY;

const
  WSADESCRIPTION_LEN     =   256;
  WSASYS_STATUS_LEN      =   128;

type
  PWSAData = ^TWSAData;
  TWSAData = packed record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;

  PTransmitFileBuffers = ^TTransmitFileBuffers;
  TTransmitFileBuffers = packed record
      Head: Pointer;
      HeadLength: DWORD;
      Tail: Pointer;
      TailLength: DWORD;
  end;

const

{ Options for use with [gs]etsockopt at the IP level. }

  IP_OPTIONS          = 1;
  IP_MULTICAST_IF     = 2;           { set/get IP multicast interface   }
  IP_MULTICAST_TTL    = 3;           { set/get IP multicast timetolive  }
  IP_MULTICAST_LOOP   = 4;           { set/get IP multicast loopback    }
  IP_ADD_MEMBERSHIP   = 5;           { add  an IP group membership      }
  IP_DROP_MEMBERSHIP  = 6;           { drop an IP group membership      }

  IP_DEFAULT_MULTICAST_TTL   = 1;    { normally limit m'casts to 1 hop  }
  IP_DEFAULT_MULTICAST_LOOP  = 1;    { normally hear sends if a member  }
  IP_MAX_MEMBERSHIPS         = 20;   { per socket; must fit in one mbuf }

{ This is used instead of -1, since the
  TSocket type is unsigned.}

  INVALID_SOCKET		= TSocket(NOT(0));
  SOCKET_ERROR		= -1;

{ The  following  may  be used in place of the address family, socket type, or
  protocol  in  a  call  to WSASocket to indicate that the corresponding value
  should  be taken from the supplied WSAPROTOCOL_INFO structure instead of the
  parameter itself.
 }

  FROM_PROTOCOL_INFO	= -1;

{ Types }

  SOCK_STREAM     = 1;               { stream socket }
  SOCK_DGRAM      = 2;               { datagram socket }
  SOCK_RAW        = 3;               { raw-protocol interface }
  SOCK_RDM        = 4;               { reliably-delivered message }
  SOCK_SEQPACKET  = 5;               { sequenced packet stream }

{ Option flags per-socket. }

  SO_DEBUG        = $0001;          { turn on debugging info recording }
  SO_ACCEPTCONN   = $0002;          { socket has had listen() }
  SO_REUSEADDR    = $0004;          { allow local address reuse }
  SO_KEEPALIVE    = $0008;          { keep connections alive }
  SO_DONTROUTE    = $0010;          { just use interface addresses }
  SO_BROADCAST    = $0020;          { permit sending of broadcast msgs }
  SO_USELOOPBACK  = $0040;          { bypass hardware when possible }
  SO_LINGER       = $0080;          { linger on close if data present }
  SO_OOBINLINE    = $0100;          { leave received OOB data in line }

  SO_DONTLINGER  =   $ff7f;

{ Additional options. }

  SO_SNDBUF       = $1001;          { send buffer size }
  SO_RCVBUF       = $1002;          { receive buffer size }
  SO_SNDLOWAT     = $1003;          { send low-water mark }
  SO_RCVLOWAT     = $1004;          { receive low-water mark }
  SO_SNDTIMEO     = $1005;          { send timeout }
  SO_RCVTIMEO     = $1006;          { receive timeout }
  SO_ERROR        = $1007;          { get error status and clear }
  SO_TYPE         = $1008;          { get socket type }

{ Options for connect and disconnect data and options.  Used only by
  non-TCP/IP transports such as DECNet, OSI TP4, etc. }

  SO_CONNDATA     = $7000;
  SO_CONNOPT      = $7001;
  SO_DISCDATA     = $7002;
  SO_DISCOPT      = $7003;
  SO_CONNDATALEN  = $7004;
  SO_CONNOPTLEN   = $7005;
  SO_DISCDATALEN  = $7006;
  SO_DISCOPTLEN   = $7007;

{ WinSock 2 extension -- new options }
 
  SO_GROUP_ID       = $2001; { ID of a socket group}
  SO_GROUP_PRIORITY = $2002; { the relative priority within a group}
  SO_MAX_MSG_SIZE   = $2003; { maximum message size }
  SO_PROTOCOL_INFOA = $2004; { WSAPROTOCOL_INFOA structure }
  SO_PROTOCOL_INFOW = $2005; { WSAPROTOCOL_INFOW structure }

{$IFDEF UNICODE }
  SO_PROTOCOL_INFO  = SO_PROTOCOL_INFOW;
{$ELSE }
  SO_PROTOCOL_INFO  = SO_PROTOCOL_INFOA;
{$ENDIF UNICODE }
  PVD_CONFIG        = $3001; {configuration info for service provider }

{ Option for opening sockets for synchronous access. }

  SO_OPENTYPE     = $7008;

  SO_SYNCHRONOUS_ALERT    = $10;
  SO_SYNCHRONOUS_NONALERT = $20;

{ Other NT-specific options. }

  SO_MAXDG        = $7009;
  SO_MAXPATHDG    = $700A;

{ TCP options. }

  TCP_NODELAY     = $0001;
  TCP_BSDURGENT   = $7000;

{ Address families. }

  AF_UNSPEC       = 0;               { unspecified }
  AF_UNIX         = 1;               { local to host (pipes, portals) }
  AF_INET         = 2;               { internetwork: UDP, TCP, etc. }
  AF_IMPLINK      = 3;               { arpanet imp addresses }
  AF_PUP          = 4;               { pup protocols: e.g. BSP }
  AF_CHAOS        = 5;               { mit CHAOS protocols }
  AF_IPX          = 6;               { IPX and SPX }
  AF_NS           = 6;               { XEROX NS protocols }
  AF_ISO          = 7;               { ISO protocols }
  AF_OSI          = AF_ISO;          { OSI is ISO }
  AF_ECMA         = 8;               { european computer manufacturers }
  AF_DATAKIT      = 9;               { datakit protocols }
  AF_CCITT        = 10;              { CCITT protocols, X.25 etc }
  AF_SNA          = 11;              { IBM SNA }
  AF_DECnet       = 12;              { DECnet }
  AF_DLI          = 13;              { Direct data link interface }
  AF_LAT          = 14;              { LAT }
  AF_HYLINK       = 15;              { NSC Hyperchannel }
  AF_APPLETALK    = 16;              { AppleTalk }
  AF_NETBIOS      = 17;              { NetBios-style addresses }
  AF_VOICEVIEW    = 18;              { VoiceView }
  AF_FIREFOX      = 19;              { FireFox }
  AF_UNKNOWN1     = 20;              { Somebody is using this! }
  AF_BAN          = 21;              { Banyan }
  AF_ATM          = 22;              { Native ATM Services }
  AF_INET6        = 23;              { Internetwork Version 6 }

  AF_MAX          = 24;

type
  { Structure used by kernel to store most addresses. }

  PSockAddr = ^TSockAddr;
  TSockAddr = TSockAddrIn;

  { Structure used by kernel to pass protocol information in raw sockets. }
  PSockProto = ^TSockProto;
  TSockProto = packed record
    sp_family: u_short;
    sp_protocol: u_short;
  end;

const
{ Protocol families, same as address families for now. }

  PF_UNSPEC       = AF_UNSPEC;
  PF_UNIX         = AF_UNIX;
  PF_INET         = AF_INET;
  PF_IMPLINK      = AF_IMPLINK;
  PF_PUP          = AF_PUP;
  PF_CHAOS        = AF_CHAOS;
  PF_NS           = AF_NS;
  PF_IPX          = AF_IPX;
  PF_ISO          = AF_ISO;
  PF_OSI          = AF_OSI;
  PF_ECMA         = AF_ECMA;
  PF_DATAKIT      = AF_DATAKIT;
  PF_CCITT        = AF_CCITT;
  PF_SNA          = AF_SNA;
  PF_DECnet       = AF_DECnet;
  PF_DLI          = AF_DLI;
  PF_LAT          = AF_LAT;
  PF_HYLINK       = AF_HYLINK;
  PF_APPLETALK    = AF_APPLETALK;
  PF_VOICEVIEW    = AF_VOICEVIEW;
  PF_FIREFOX      = AF_FIREFOX;
  PF_UNKNOWN1     = AF_UNKNOWN1;
  PF_BAN          = AF_BAN;
  PF_ATM          = AF_ATM;
  PF_INET6        = AF_INET6;

  PF_MAX          = AF_MAX;

type
{ Structure used for manipulating linger option. }
  PLinger = ^TLinger;
  TLinger = packed record
    l_onoff: u_short;
    l_linger: u_short;
  end;

const
{ Level number for (get/set)sockopt() to apply to socket itself. }

  SOL_SOCKET      = $ffff;          {options for socket level }

{ Maximum queue length specifiable by listen. }

  SOMAXCONN       = $7fffffff;      { AHS - by³o 5 !?????? }

  MSG_OOB         = $1;             {process out-of-band data }
  MSG_PEEK        = $2;             {peek at incoming message }
  MSG_DONTROUTE   = $4;             {send without using routing tables }

  MSG_MAXIOVLEN   = 16;

  MSG_PARTIAL     = $8000;          {partial send or recv for message xport }

{ WinSock 2 extension -- new flags for WSASend(), WSASendTo(), WSARecv() and
  WSARecvFrom() }

  MSG_INTERRUPT   = $10;            {send/recv in the interrupt context}

{ Define constant based on rfc883, used by gethostbyxxxx() calls. }

  MAXGETHOSTSTRUCT        = 1024;

{ Define flags to be used with the WSAAsyncSelect() call. }

  FD_READ         = $01;
  FD_WRITE        = $02;
  FD_OOB          = $04;
  FD_ACCEPT       = $08;
  FD_CONNECT      = $10;
  FD_CLOSE        = $20;
  FD_QOS          = $40;
  FD_GROUP_QOS    = $80;
  FD_MAX_EVENTS	= 8;
  FD_ALL_EVENTS	= $100; { AHS - trudno powiedzieæ, ile powinno byæ }

{ All Windows Sockets error constants are biased by WSABASEERR from the "normal" }

  WSABASEERR              = 10000;

{ Windows Sockets definitions of regular Microsoft C error constants }

  WSAEINTR                = (WSABASEERR+4);
  WSAEBADF                = (WSABASEERR+9);
  WSAEACCES               = (WSABASEERR+13);
  WSAEFAULT               = (WSABASEERR+14);
  WSAEINVAL               = (WSABASEERR+22);
  WSAEMFILE               = (WSABASEERR+24);

{ Windows Sockets definitions of regular Berkeley error constants }

  WSAEWOULDBLOCK          = (WSABASEERR+35);
  WSAEINPROGRESS          = (WSABASEERR+36);
  WSAEALREADY             = (WSABASEERR+37);
  WSAENOTSOCK             = (WSABASEERR+38);
  WSAEDESTADDRREQ         = (WSABASEERR+39);
  WSAEMSGSIZE             = (WSABASEERR+40);
  WSAEPROTOTYPE           = (WSABASEERR+41);
  WSAENOPROTOOPT          = (WSABASEERR+42);
  WSAEPROTONOSUPPORT      = (WSABASEERR+43);
  WSAESOCKTNOSUPPORT      = (WSABASEERR+44);
  WSAEOPNOTSUPP           = (WSABASEERR+45);
  WSAEPFNOSUPPORT         = (WSABASEERR+46);
  WSAEAFNOSUPPORT         = (WSABASEERR+47);
  WSAEADDRINUSE           = (WSABASEERR+48);
  WSAEADDRNOTAVAIL        = (WSABASEERR+49);
  WSAENETDOWN             = (WSABASEERR+50);
  WSAENETUNREACH          = (WSABASEERR+51);
  WSAENETRESET            = (WSABASEERR+52);
  WSAECONNABORTED         = (WSABASEERR+53);
  WSAECONNRESET           = (WSABASEERR+54);
  WSAENOBUFS              = (WSABASEERR+55);
  WSAEISCONN              = (WSABASEERR+56);
  WSAENOTCONN             = (WSABASEERR+57);
  WSAESHUTDOWN            = (WSABASEERR+58);
  WSAETOOMANYREFS         = (WSABASEERR+59);
  WSAETIMEDOUT            = (WSABASEERR+60);
  WSAECONNREFUSED         = (WSABASEERR+61);
  WSAELOOP                = (WSABASEERR+62);
  WSAENAMETOOLONG         = (WSABASEERR+63);
  WSAEHOSTDOWN            = (WSABASEERR+64);
  WSAEHOSTUNREACH         = (WSABASEERR+65);
  WSAENOTEMPTY            = (WSABASEERR+66);
  WSAEPROCLIM             = (WSABASEERR+67);
  WSAEUSERS               = (WSABASEERR+68);
  WSAEDQUOT               = (WSABASEERR+69);
  WSAESTALE               = (WSABASEERR+70);
  WSAEREMOTE              = (WSABASEERR+71);

{ Extended Windows Sockets error constant definitions }

  WSASYSNOTREADY          = (WSABASEERR+91);
  WSAVERNOTSUPPORTED      = (WSABASEERR+92);
  WSANOTINITIALISED       = (WSABASEERR+93);
  WSAEDISCON              = (WSABASEERR+101);
  WSAENOMORE              = (WSABASEERR+102);
  WSAECANCELLED           = (WSABASEERR+103);
  WSAEEINVALIDPROCTABLE   = (WSABASEERR+104);
  WSAEINVALIDPROVIDER     = (WSABASEERR+105);
  WSAEPROVIDERFAILEDINIT  = (WSABASEERR+106);
  WSASYSCALLFAILURE       = (WSABASEERR+107);
  WSASERVICE_NOT_FOUND    = (WSABASEERR+108);
  WSATYPE_NOT_FOUND       = (WSABASEERR+109);
  WSA_E_NO_MORE           = (WSABASEERR+110);
  WSA_E_CANCELLED         = (WSABASEERR+111);
  WSAEREFUSED             = (WSABASEERR+112);

{ Error return codes from gethostbyname() and gethostbyaddr()
  (when using the resolver). Note that these errors are
  retrieved via WSAGetLastError() and must therefore follow
  the rules for avoiding clashes with error numbers from
  specific implementations or language run-time systems.
  For this reason the codes are based at WSABASEERR+1001.
  Note also that [WSA]NO_ADDRESS is defined only for
  compatibility purposes. }

{ Authoritative Answer: Host not found }

  WSAHOST_NOT_FOUND       = (WSABASEERR+1001);
  HOST_NOT_FOUND          = WSAHOST_NOT_FOUND;

{ Non-Authoritative: Host not found, or SERVERFAIL }

  WSATRY_AGAIN            = (WSABASEERR+1002);
  TRY_AGAIN               = WSATRY_AGAIN;

{ Non recoverable errors, FORMERR, REFUSED, NOTIMP }

  WSANO_RECOVERY          = (WSABASEERR+1003);
  NO_RECOVERY             = WSANO_RECOVERY;

{ Valid name, no data record of requested type }

  WSANO_DATA              = (WSABASEERR+1004);
  NO_DATA                 = WSANO_DATA;

{ no address, look for MX record }

  WSANO_ADDRESS           = WSANO_DATA;
  NO_ADDRESS              = WSANO_ADDRESS;

{ Windows Sockets errors redefined as regular Berkeley error constants.
  These are commented out in Windows NT to avoid conflicts with errno.h.
  Use the WSA constants instead. }

  EWOULDBLOCK        =  WSAEWOULDBLOCK;
  EINPROGRESS        =  WSAEINPROGRESS;
  EALREADY           =  WSAEALREADY;
  ENOTSOCK           =  WSAENOTSOCK;
  EDESTADDRREQ       =  WSAEDESTADDRREQ;
  EMSGSIZE           =  WSAEMSGSIZE;
  EPROTOTYPE         =  WSAEPROTOTYPE;
  ENOPROTOOPT        =  WSAENOPROTOOPT;
  EPROTONOSUPPORT    =  WSAEPROTONOSUPPORT;
  ESOCKTNOSUPPORT    =  WSAESOCKTNOSUPPORT;
  EOPNOTSUPP         =  WSAEOPNOTSUPP;
  EPFNOSUPPORT       =  WSAEPFNOSUPPORT;
  EAFNOSUPPORT       =  WSAEAFNOSUPPORT;
  EADDRINUSE         =  WSAEADDRINUSE;
  EADDRNOTAVAIL      =  WSAEADDRNOTAVAIL;
  ENETDOWN           =  WSAENETDOWN;
  ENETUNREACH        =  WSAENETUNREACH;
  ENETRESET          =  WSAENETRESET;
  ECONNABORTED       =  WSAECONNABORTED;
  ECONNRESET         =  WSAECONNRESET;
  ENOBUFS            =  WSAENOBUFS;
  EISCONN            =  WSAEISCONN;
  ENOTCONN           =  WSAENOTCONN;
  ESHUTDOWN          =  WSAESHUTDOWN;
  ETOOMANYREFS       =  WSAETOOMANYREFS;
  ETIMEDOUT          =  WSAETIMEDOUT;
  ECONNREFUSED       =  WSAECONNREFUSED;
  ELOOP              =  WSAELOOP;
  ENAMETOOLONG       =  WSAENAMETOOLONG;
  EHOSTDOWN          =  WSAEHOSTDOWN;
  EHOSTUNREACH       =  WSAEHOSTUNREACH;
  ENOTEMPTY          =  WSAENOTEMPTY;
  EPROCLIM           =  WSAEPROCLIM;
  EUSERS             =  WSAEUSERS;
  EDQUOT             =  WSAEDQUOT;
  ESTALE             =  WSAESTALE;
  EREMOTE            =  WSAEREMOTE;

{ AHS }
{ WinSock 2 extension -- new error codes and type definition }

type
  WSAEVENT                = THANDLE;
  LPHANDLE                = PHANDLE;
  LPWSAEVENT              = LPHANDLE;
  WSAOVERLAPPED           = TOVERLAPPED;
  LPWSAOVERLAPPED         = POverlapped;

const

  WSA_IO_PENDING          = ERROR_IO_PENDING;
  WSA_IO_INCOMPLETE       = ERROR_IO_INCOMPLETE;
  WSA_INVALID_HANDLE      = ERROR_INVALID_HANDLE;
  WSA_INVALID_PARAMETER   = ERROR_INVALID_PARAMETER;
  WSA_NOT_ENOUGH_MEMORY   = ERROR_NOT_ENOUGH_MEMORY;
  WSA_OPERATION_ABORTED   = ERROR_OPERATION_ABORTED;

  WSA_INVALID_EVENT       = WSAEVENT(NiL);
  WSA_MAXIMUM_WAIT_EVENTS = MAXIMUM_WAIT_OBJECTS;
  WSA_WAIT_FAILED         = DWORD($FFFFFFFF); { ahs }
  WSA_WAIT_EVENT_0        = WAIT_OBJECT_0;
  WSA_WAIT_IO_COMPLETION  = WAIT_IO_COMPLETION;
  WSA_WAIT_TIMEOUT        = WAIT_TIMEOUT;
  WSA_INFINITE            = INFINITE;


{ WinSock 2 extension -- WSABUF and QOS struct }

type

PWSABUF = ^TWSABUF;
TWSABUF = packed record
  len                : u_long;     { the length of the buffer }
  buf                : Pointer; //PChar;     { the pointer to the buffer }
end;

GUARANTEE = (
    BestEffortService,
    ControlledLoadService,
    PredictiveService,
    GuaranteedDelayService,
    GuaranteedService
);

PFlowspec = ^TFlowspec;
TFlowspec = packed record
  TokenRate             : LongInt;        { In Bytes/sec }
  TokenBucketSize       : LongInt;        { In Bytes }
  PeakBandwidth         : LongInt;        { In Bytes/sec }
  Latency               : LongInt;        { In microseconds }
  DelayVariation        : LongInt;        { In microseconds }
  LevelOfGuarantee      : Guarantee;      { Guaranteed, Predictive }
                                          { or Best Effort       }
  CostOfCall            : LongInt;        { Reserved for future use, }
                                          { must be set to 0 now   }
  NetworkAvailability   : LongInt;        { read-only:         }
                                          {   1 if accessible, }
                                          {   0 if not         }
end;

PQOS = ^TQualityOfService;
TQualityOfService = packed record
  SendingFlowspec       :TFlowspec;    { the flow spec for data sending }
  ReceivingFlowspec     :TFlowspec;    { the flow spec for data receiving }
  ProviderSpecific      :TWSABuf;      { additional provider specific stuff }
end;

const

{ WinSock 2 extension -- manifest constants for return values of the
  condition function}

  CF_ACCEPT       = $0000;
  CF_REJECT       = $0001;
  CF_DEFER        = $0002;

{WinSock 2 extension -- manifest constants for shutdown() }

  SD_RECEIVE      = $00;
  SD_SEND         = $01;
  SD_BOTH         = $02;

{ WinSock 2 extension -- data type and manifest constants for socket groups }
type

  TGroup            = u_int;
  PGroup           = ^TGroup;

const
  
  SG_UNCONSTRAINED_GROUP   = $01;
  SG_CONSTRAINED_GROUP     = $02;

{ WinSock 2 extension -- data type for WSAEnumNetworkEvents() }

type

PWSANETWORKEVENTS = ^TWSANETWORKEVENTS;
TWSANETWORKEVENTS = packed record
  lNetworkEvents           :u_long;
  iErrorCode               : array [0..FD_MAX_EVENTS-1] of u_int;
end;

{WinSock 2 extension -- WSAPROTOCOL_INFO structure and associated
 manifest constants}

PGUID = ^TGUID;
TGUID = packed record
  Data1              :u_long;
  Data2              :u_short;
  Data3              :u_short;
  Data4              : array [0..8-1] of u_char;
end;

const

  MAX_PROTOCOL_CHAIN  = 7;

  BASE_PROTOCOL       = 1;
  LAYERED_PROTOCOL    = 0;

type

PWSAPROTOCOLCHAIN = ^TWSAPROTOCOLCHAIN;
TWSAPROTOCOLCHAIN = packed record
  ChainLen        : Integer;            { the length of the chain,     }
                                        { length = 0 means layered protocol, }
                                        { length = 1 means base protocol, }
                                        { length > 1 means protocol chain }
  ChainEntries : array[0..MAX_PROTOCOL_CHAIN-1] of DWORD; { a list of dwCatalogEntryIds }
end;

const

  WSAPROTOCOL_LEN    = 255;

type
  
PWSAPROTOCOL_INFOA = ^TWSAPROTOCOL_INFOA;
TWSAPROTOCOL_INFOA = packed record
  dwServiceFlags1           : DWORD;
  dwServiceFlags2           : DWORD;
  dwServiceFlags3           : DWORD;
  dwServiceFlags4           : DWORD;
  dwProviderFlags           : DWORD;
  ProviderId                : TGUID;
  dwCatalogEntryId          : DWORD;
  ProtocolChain             : TWSAPROTOCOLCHAIN;
  iVersion                  : u_int;
  iAddressFamily            : u_int;
  iMaxSockAddr              : u_int;
  iMinSockAddr              : u_int;
  iSocketType               : u_int;
  iProtocol                 : u_int;
  iProtocolMaxOffset        : u_int;
  iNetworkByteOrder         : u_int;
  iSecurityScheme           : u_int;
  dwMessageSize            : DWORD;
  dwProviderReserved       : DWORD;
  szProtocol               : array [0..WSAPROTOCOL_LEN+1-1] of u_char;
end;

PWSAPROTOCOL_INFOW = ^TWSAPROTOCOL_INFOW;
TWSAPROTOCOL_INFOW = packed record
  dwServiceFlags1           : DWORD;
  dwServiceFlags2           : DWORD;
  dwServiceFlags3           : DWORD;
  dwServiceFlags4           : DWORD;
  dwProviderFlags           : DWORD;
  ProviderId                : TGUID;
  dwCatalogEntryId          : DWORD;
  ProtocolChain             : TWSAPROTOCOLCHAIN;
  iVersion                  : u_int;
  iAddressFamily            : u_int;
  iMaxSockAddr              : u_int;
  iMinSockAddr              : u_int;
  iSocketType               : u_int;
  iProtocol                 : u_int;
  iProtocolMaxOffset        : u_int;
  iNetworkByteOrder         : u_int;
  iSecurityScheme           : u_int;
  dwMessageSize            : DWORD;
  dwProviderReserved       : DWORD;
  szProtocol               : array [0..WSAPROTOCOL_LEN+1-1] of WCHAR;
end;

{$ifdef UNICODE}

TWSAPROTOCOL_INFO   = TWSAPROTOCOL_INFOW ;
PWSAPROTOCOL_INFO =  PWSAPROTOCOL_INFOW ;

{$else}

TWSAPROTOCOL_INFO   = TWSAPROTOCOL_INFOA ;
PWSAPROTOCOL_INFO =  PWSAPROTOCOL_INFOA ;

{$endif UNICODE}

const
{ Flag bit definitions for dwProviderFlags }

  PFL_MULTIPLE_PROTO_ENTRIES          =$00000001;
  PFL_RECOMMENDED_PROTO_ENTRY         =$00000002;
  PFL_HIDDEN                          =$00000004;
  PFL_MATCHES_PROTOCOL_ZERO           =$00000008;

{ Flag bit definitions for dwServiceFlags1 }
  XP1_CONNECTIONLESS                  =$00000001;
  XP1_GUARANTEED_DELIVERY             =$00000002;
  XP1_GUARANTEED_ORDER                =$00000004;
  XP1_MESSAGE_ORIENTED                =$00000008;
  XP1_PSEUDO_STREAM                   =$00000010;
  XP1_GRACEFUL_CLOSE                  =$00000020;
  XP1_EXPEDITED_DATA                  =$00000040;
  XP1_CONNECT_DATA                    =$00000080;
  XP1_DISCONNECT_DATA                 =$00000100;
  XP1_SUPPORT_BROADCAST               =$00000200;
  XP1_SUPPORT_MULTIPOINT              =$00000400;
  XP1_MULTIPOINT_CONTROL_PLANE        =$00000800;
  XP1_MULTIPOINT_DATA_PLANE           =$00001000;
  XP1_QOS_SUPPORTED                   =$00002000;
  XP1_INTERRUPT                       =$00004000;
  XP1_UNI_SEND                        =$00008000;
  XP1_UNI_RECV                        =$00010000;
  XP1_IFS_HANDLES                     =$00020000;
  XP1_PARTIAL_MESSAGE                 =$00040000;

  BIGENDIAN                           =$0000;
  LITTLEENDIAN                        =$0001;

  SECURITY_PROTOCOL_NONE              =$0000;

{ WinSock 2 extension -- manifest constants for WSAJoinLeaf() }

  JL_SENDER_ONLY    =$01;
  JL_RECEIVER_ONLY  =$02;
  JL_BOTH           =$04;

{ WinSock 2 extension -- manifest constants for WSASocket() }

  WSA_FLAG_OVERLAPPED           =$01;
  WSA_FLAG_MULTIPOINT_C_ROOT    =$02;
  WSA_FLAG_MULTIPOINT_C_LEAF    =$04;
  WSA_FLAG_MULTIPOINT_D_ROOT    =$08;
  WSA_FLAG_MULTIPOINT_D_LEAF    =$10;

{ WinSock 2 extension -- manifest constants for WSAIoctl() }

  IOC_UNIX                      =$00000000;
  IOC_WS2                       =$08000000;
  IOC_PROTOCOL                  =$10000000;
  IOC_VENDOR                    =$18000000;

  SIO_ASSOCIATE_HANDLE           = IOC_IN or IOC_WS2 or 1;
  SIO_ENABLE_CIRCULAR_QUEUEING   = IOC_VOID or IOC_WS2 or 2;
  SIO_FIND_ROUTE                 = IOC_OUT or IOC_WS2 or 3;
  SIO_FLUSH                      = IOC_VOID or IOC_WS2 or 4;
  SIO_GET_BROADCAST_ADDRESS      = IOC_OUT or IOC_WS2 or 5;
  SIO_GET_EXTENSION_FUNCTION_POINTER  = IOC_INOUT or IOC_WS2 or 6;
  SIO_GET_QOS                    = IOC_INOUT or IOC_WS2 or 7;
  SIO_GET_GROUP_QOS              = IOC_INOUT or IOC_WS2 or 8;
  SIO_MULTIPOINT_LOOPBACK        = IOC_IN or IOC_WS2 or 9;
  SIO_MULTICAST_SCOPE            = IOC_IN or IOC_WS2 or 10;
  SIO_SET_QOS                    = IOC_IN or IOC_WS2 or 11;
  SIO_SET_GROUP_QOS              = IOC_IN or IOC_WS2 or 12;
  SIO_TRANSLATE_HANDLE           = IOC_INOUT or IOC_WS2 or 13;

{ WinSock 2 extension -- manifest constants for SIO_TRANSLATE_HANDLE ioctl }

  TH_NETDEV        = $00000001;
  TH_TAPI          = $00000002;

{  Microsoft Windows Extended data types required for the functions to
   convert   back  and  forth  between  binary  and  string  forms  of
   addresses. }

type

  SOCKADDR     = TSockAddr; { AHS ?}
{  PSOCKADDR    = PSockaddr;}
  LPSOCKADDR   = PSockaddr;

{ Manifest constants and type definitions related to name resolution and
  registration (RNR) API }

PBLOB = ^TBLOB;
TBLOB = packed record
    cbSize    :ULONG;
    pBlobData :^byte;
end;

{ Service Install Flags }

const

  SERVICE_MULTIPLE       =$00000001;

{ Name Spaces }

  NS_ALL                      = 0;

  NS_SAP                      = 1;
  NS_NDS                      = 2;
  NS_PEER_BROWSE              = 3;

  NS_TCPIP_LOCAL              = 10;
  NS_TCPIP_HOSTS              = 11;
  NS_DNS                      = 12;
  NS_NETBT                    = 13;
  NS_WINS                     = 14;

  NS_NBP                      = 20;

  NS_MS                       = 30;
  NS_STDA                     = 31;
  NS_NTDS                     = 32;

  NS_X500                     = 40;
  NS_NIS                      = 41;
  NS_NISPLUS                  = 42;

  NS_WRQ                      = 50;


{  Resolution flags for WSAGetAddressByName().
   Note these are also used by the 1.1 API GetAddressByName, so
   leave them around. }

  RES_UNUSED_1                =$00000001;
  RES_FLUSH_CACHE             =$00000002;
  RES_SERVICE                 =$00000004;


{ Well known value names for Service Types }

  SERVICE_TYPE_VALUE_IPXPORTA     ='IpxSocket';
  SERVICE_TYPE_VALUE_IPXPORTW     = 'IpxSocket';
  SERVICE_TYPE_VALUE_SAPIDA       = 'SapId';
  SERVICE_TYPE_VALUE_SAPIDW       ='SapId';

  SERVICE_TYPE_VALUE_TCPPORTA     = 'TcpPort';
  SERVICE_TYPE_VALUE_TCPPORTW     ='TcpPort';

  SERVICE_TYPE_VALUE_UDPPORTA     = 'UdpPort';
  SERVICE_TYPE_VALUE_UDPPORTW     ='UdpPort';

  SERVICE_TYPE_VALUE_OBJECTIDA    = 'ObjectId';
  SERVICE_TYPE_VALUE_OBJECTIDW    ='ObjectId';

{$ifdef UNICODE}

  SERVICE_TYPE_VALUE_SAPID        =SERVICE_TYPE_VALUE_SAPIDW;
  SERVICE_TYPE_VALUE_TCPPORT      =SERVICE_TYPE_VALUE_TCPPORTW;
  SERVICE_TYPE_VALUE_UDPPORT      =SERVICE_TYPE_VALUE_UDPPORTW;
  SERVICE_TYPE_VALUE_OBJECTID     =SERVICE_TYPE_VALUE_OBJECTIDW;

{$else} { not UNICODE }

  SERVICE_TYPE_VALUE_SAPID        =SERVICE_TYPE_VALUE_SAPIDA;
  SERVICE_TYPE_VALUE_TCPPORT      =SERVICE_TYPE_VALUE_TCPPORTA;
  SERVICE_TYPE_VALUE_UDPPORT      =SERVICE_TYPE_VALUE_UDPPORTA;
  SERVICE_TYPE_VALUE_OBJECTID     =SERVICE_TYPE_VALUE_OBJECTIDA;

{$endif}

{ SockAddr Information }
type

PSOCKET_ADDRESS = ^TSOCKET_ADDRESS;
TSOCKET_ADDRESS = packed record
    lpSockaddr        :  PSOCKADDR ;
    iSockaddrLength   : u_int;
end;

{ CSAddr Information }

PCSADDR_INFO = ^TCSADDR_INFO;
TCSADDR_INFO = packed record
    LocalAddr         :TSOCKET_ADDRESS;
    RemoteAddr        :TSOCKET_ADDRESS;
    iSocketType       :u_int;
    iProtocol         :u_int;
end;


{ Address Family/Protocol Tuples }

PAFPROTOCOLS = ^TAFPROTOCOLS;
TAFPROTOCOLS = packed record
  iAddressFamily      :u_int;
  iProtocol           :u_int;
end;

{ Client Query API Typedefs }

{ The comparators }

PWSAEcomparator = ^TWSAEcomparator;
TWSAEcomparator = (
    COMP_EQUAL,
    COMP_NOTLESS
);

PWSAVersion = ^TWSAVersion;
TWSAVersion = packed record
    dwVersion        : Dword;
    ecHow            : TWSAEComparator;
end;

PWSAQuerySetA = ^TWSAQuerySetA;
TWSAQuerySetA = packed record
    dwSize                  : DWord;
    lpszServiceInstanceName : PChar;
    lpServiceClassId        : PGUID;
    lpVersion               : PWSAVERSION;
    lpszComment             : PChar;
    dwNameSpace             : DWord;
    lpNSProviderId          : PGUID;
    lpszContext             : PChar;
    dwNumberOfProtocols     : DWORD;
    lpafpProtocols          : PAFPROTOCOLS;
    lpszQueryString         : PChar;
    dwNumberOfCsAddrs       : Dword;
    lpcsaBuffer             : PCSADDR_INFO;
    dwOutputFlags           : DWord;
    lpBlob                  : PBLOB;
end;

PWSAQuerySetW = ^TWSAQuerySetW;
TWSAQuerySetW = packed record
    dwSize                  : DWord;
    lpszServiceInstanceName : PWideChar;                        //MIO, antes WideChar
    lpServiceClassId        : PGUID;
    lpVersion               : PWSAVERSION;
    lpszComment             : PWideChar;                         //MIO, antes WideChar
    dwNameSpace             : DWord;
    lpNSProviderId          : PGUID;
    lpszContext             : PWideChar;                         //MIO, antes WideChar
    dwNumberOfProtocols     : DWORD;
    lpafpProtocols          : PAFPROTOCOLS;
    lpszQueryString         : PWideChar;                        //MIO, antes WideChar
    dwNumberOfCsAddrs       : Dword;
    lpcsaBuffer             : PCSADDR_INFO;
    dwOutputFlags           : DWord;
    lpBlob                  : PBLOB;
end;

{$ifdef UNICODE}

  WSAQUERYSET              = TWSAQUERYSETW;
  PWSAQUERYSET             = PWSAQUERYSETW;

{$else}

  WSAQUERYSET              = TWSAQUERYSETA;
  PWSAQUERYSET             = PWSAQUERYSETA;

{$endif }

const

  LUP_DEEP                = $0001;
  LUP_CONTAINERS          = $0002;
  LUP_NOCONTAINERS        = $0004;
  LUP_NEAREST             = $0008;
  LUP_RETURN_NAME         = $0010;
  LUP_RETURN_TYPE         = $0020;
  LUP_RETURN_VERSION      = $0040;
  LUP_RETURN_COMMENT      = $0080;
  LUP_RETURN_ADDR         = $0100;
  LUP_RETURN_BLOB         = $0200;
  LUP_RETURN_ALIASES      = $0400;
  LUP_RETURN_QUERY_STRING = $0800;
  LUP_RETURN_ALL          = $0FF0;
  LUP_RES_SERVICE         = $8000;

  LUP_FLUSHCACHE       = $1000;
  LUP_FLUSHPREVIOUS    = $2000;


{ Return flags }

  RESULT_IS_ALIAS      = $0001;

{ Service Address Registration and Deregistration Data Types. }

type

PWSAESETSERVICEOP = ^TWSAESETSERVICEOP;
TWSAESETSERVICEOP = (
    RNRSERVICE_REGISTER,
    RNRSERVICE_DEREGISTER,
    RNRSERVICE_DELETE
);

{ Service Installation/Removal Data Types. }

PWSANSClassInfoA = ^TWSANSClassInfoA;
TWSANSClassInfoA = packed record
  lpszName         : PChar;
  dwNameSpace      : Dword;
  dwValueType      : Dword;
  dwValueSize      : Dword;
  lpValue          : Pointer;
 end;

PWSANSClassInfoW = ^TWSANSClassInfoW;
TWSANSClassInfoW = packed record
  lpszName         : WideChar;
  dwNameSpace      : Dword;
  dwValueType      : Dword;
  dwValueSize      : Dword;
  lpValue          : Pointer;
 end;

{$ifdef UNICODE }

  TWSANSCLASSINFO   = TWSANSCLASSINFOW;
  PWSANSCLASSINFO  = PWSANSCLASSINFOW;

{$else}

  TWSANSCLASSINFO   = TWSANSCLASSINFOA;
  PWSANSCLASSINFO  = PWSANSCLASSINFOA;

{$endif  UNICODE}

PWSAServiceClassInfoA = ^TWSAServiceClassInfoA;
TWSAServiceClassInfoA = packed record
    lpServiceClassId      : PGUID;
    lpszServiceClassName  : PChar;
    dwCount               : DWord;
    lpClassInfos          : PWSANSCLASSINFOA;
end;

PWSAServiceClassInfoW = ^TWSAServiceClassInfoW;
TWSAServiceClassInfoW = packed record
    lpServiceClassId      : PGUID;
    lpszServiceClassName  : WideChar;
    dwCount               : DWord;
    lpClassInfos          : PWSANSCLASSINFOW;
end;

{$ifdef UNICODE}

  TWSASERVICECLASSINFO         = TWSASERVICECLASSINFOW;
  PWSASERVICECLASSINFO        = PWSASERVICECLASSINFOW;

{$else}

  TWSASERVICECLASSINFO         = TWSASERVICECLASSINFOA;
  PWSASERVICECLASSINFO        = PWSASERVICECLASSINFOA;

{$endif  UNICODE}

PWSANAMESPACE_INFOA = ^TWSANAMESPACE_INFOA;
TWSANAMESPACE_INFOA = packed record
    NSProviderId      : TGUID;
    dwNameSpace       : DWord;
    fActive           : BOOL;
    dwVersion         : DWord;
    lpszIdentifier    : PChar;
end;

PWSANAMESPACE_INFOW = ^TWSANAMESPACE_INFOW;
TWSANAMESPACE_INFOW = packed record
    NSProviderId      : TGUID;
    dwNameSpace       : DWord;
    fActive           : BOOL;
    dwVersion         : DWord;
    lpszIdentifier    : WideChar;
end;

{$ifdef UNICODE}

  TWSANAMESPACE_INFO     = TWSANAMESPACE_INFOW;
  PWSANAMESPACE_INFO     = PWSANAMESPACE_INFOW;

{$else}

  TWSANAMESPACE_INFO     = TWSANAMESPACE_INFOA;
  PWSANAMESPACE_INFO     = PWSANAMESPACE_INFOA;

{$endif  UNICODE}

{ AHS END }

{ Socket function prototypes }

// Using "var addr:TSockAddr" in accept makes impossible to compile for IPv6
function accept(s: TSocket; addr: PSockAddr; var addrlen: Integer): TSocket; stdcall;
// Using "var addr:TSockAddr" in bind makes impossible to compile for IPv6
function bind(s: TSocket; addr: PSockAddr; namelen: Integer): Integer; stdcall;
function closesocket(s: TSocket): Integer; stdcall;
// Using "var addr:TSockAddr" in connect makes impossible to compile for IPv6
function connect(s: TSocket; name: PSockAddr; namelen: Integer): Integer; stdcall;
function ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer; stdcall;
function getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer; stdcall;
// Using "var addr:TSockAddr" in getsockname makes impossible to compile for IPv6
function getsockname(s: TSocket; name: PSockAddr; var namelen: Integer): Integer; stdcall;
function getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer; stdcall;
function htonl(hostlong: u_long): u_long; stdcall;
function htons(hostshort: u_short): u_short; stdcall;
function inet_addr(cp: PChar): u_long; stdcall; {PInAddr;}  { TInAddr }
function inet_ntoa(inaddr: TInAddr): PChar; stdcall;
function listen(s: TSocket; backlog: Integer): Integer; stdcall;
function ntohl(netlong: u_long): u_long; stdcall;
function ntohs(netshort: u_short): u_short; stdcall;
function recv(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
// Using "var from: TSockAddr" in recvfrom makes impossible to compile for IPv6
function recvfrom(s: TSocket; var Buf; len, flags: Integer;
  from: PSockAddr; var fromlen: Integer): Integer; stdcall;
function select(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
  timeout: PTimeVal): Longint; stdcall;
function send(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
// Using "var addrto: TSockAddr" in sendto makes impossible to compile for IPv6
function sendto(s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddr;
  tolen: Integer): Integer; stdcall;
function setsockopt(s: TSocket; level, optname: Integer; optval: PChar;
  optlen: Integer): Integer; stdcall;
function shutdown(s: TSocket; how: Integer): Integer; stdcall;
function socket(af, struct, protocol: Integer): TSocket; stdcall;
function gethostbyaddr(addr: Pointer; len, struct: Integer): PHostEnt; stdcall;
function gethostbyname(name: PChar): PHostEnt; stdcall;
function gethostname(name: PChar; len: Integer): Integer; stdcall;
function getservbyport(port: Integer; proto: PChar): PServEnt; stdcall;
function getservbyname(name, proto: PChar): PServEnt; stdcall;
function getprotobynumber(proto: Integer): PProtoEnt; stdcall;
function getprotobyname(name: PChar): PProtoEnt; stdcall;
function WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer; stdcall;
function WSACleanup: Integer; stdcall;
procedure WSASetLastError(iError: Integer); stdcall;
function WSAGetLastError: Integer; stdcall;
function WSAIsBlocking: BOOL; stdcall;
function WSAUnhookBlockingHook: Integer; stdcall;
function WSASetBlockingHook(lpBlockFunc: TFarProc): TFarProc; stdcall;
function WSACancelBlockingCall: Integer; stdcall;
function WSAAsyncGetServByName(HWindow: HWND; wMsg: u_int;
  name, proto, buf: PChar; buflen: Integer): THandle; stdcall;
function WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int;
  proto, buf: PChar; buflen: Integer): THandle; stdcall;
function WSAAsyncGetProtoByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle; stdcall;
function WSAAsyncGetProtoByNumber(HWindow: HWND; wMsg: u_int; number: Integer;
  buf: PChar; buflen: Integer): THandle; stdcall;
function WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle; stdcall;
function WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PChar;
  len, struct: Integer; buf: PChar; buflen: Integer): THandle; stdcall;
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer; stdcall;
function WSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;

{ WinSock 2 extensions -- data types for the condition function in
  WSAAccept() and overlapped I/O completion routine. }

type

PCONDITIONPROC = function ( lpCallerId:PWSABUF; lpCallerData:PWSABUF;
    lpSQOS:PQOS; lpGQOS:PQOS; lpCalleeId:PWSABUF;lpCalleeData:PWSABUF;
    g:PGroup; dwCallbackData:DWord) :u_int; stdcall;

PWSAOVERLAPPED_COMPLETION_ROUTINE = procedure ( dwError :Dword;
    cbTransferred: DWORD; lpOverlapped: LPWSAOVERLAPPED; dwFlags: Dword
    ); stdcall;

{ WinSock 2 API new function prototypes }

function WSAAccept( s: TSOCKET; addr: psockaddr; addrlen: PINT;
    lpfnCondition: PCONDITIONPROC; dwCallbackData: DWORD): TSOCKET; stdcall;
function WSACloseEvent( hEvent: WSAEVENT ):BOOL; stdcall;
function WSAConnect(s: TSOCKET; name: psockaddr;namelen: u_int;
    lpCallerData: PWSABUF; lpCalleeData: PWSABUF; lpSQOS: PQOS;
    lpGQOS: PQOS) : u_int; stdcall;
function WSACreateEvent:WSAEVENT; stdcall;

{$IFDEF UNICODE}
function WSADuplicateSocket(s: TSocket; dwProcessId: DWORD;
   lpProtocolInfo: PWSAPROTOCOL_INFOW): u_int; stdcall;
{$ELSE}
function WSADuplicateSocket(s: TSocket; dwProcessId: DWORD;
   lpProtocolInfo: PWSAPROTOCOL_INFOA): u_int; stdcall;
{$ENDIF} {UNICODE}

function WSAEnumNetworkEvents( s: TSocket; hEventObject: WSAEVENT;
   lpNetworkEvents: PWSANETWORKEVENTS): u_int; stdcall;

{$IFDEF UNICODE}
function WSAEnumProtocols( lpiProtocols: PInt;
   lpProtocolBuffer: PWSAPROTOCOL_INFOW; lpdwBufferLength: PDWORD
   ): u_int; stdcall;
{$ELSE}
function WSAEnumProtocols( lpiProtocols: PInt;
   lpProtocolBuffer: PWSAPROTOCOL_INFOA; lpdwBufferLength: PDWORD
   ): u_int; stdcall;
{$ENDIF} {UNICODE}

function WSAEventSelect(s: TSOCKET; hEventObject: WSAEVENT;
    lNetworkEvents: u_long): u_int; stdcall;
function WSAGetOverlappedResult( s: TSocket; lpOverlapped: LPWSAOVERLAPPED;
    lpcbTransfer: PDWORD; fWait: BOOL; lpdwFlags: PDWORD): BOOL; stdcall;
function WSAGetQOSByName( s: TSocket; lpQOSName: PWSABUF;
    lpQOS: PQOS): BOOL; stdcall;
function WSAHtonl( s: TSocket; hostlong: u_long; lpnetlong: pu_long)
    : u_int; stdcall;
function WSAHtons( s: TSocket; hostshort: u_short; lpnetshort: pu_short)
    : u_int; stdcall;
function WSAIoctl( s: TSocket; dwIoControlCode: DWORD; lpvInBuffer: Pointer;
    cbInBuffer: DWORD; lpvOutBuffer: Pointer; cbOutBuffer: DWORD;
    lpcbBytesReturned: PDWORD; lpOverlapped: LPWSAOVERLAPPED;
    lpCompletionRoutine: PWSAOVERLAPPED_COMPLETION_ROUTINE): u_int; stdcall;
function WSAJoinLeaf( s: TSocket; name: psockaddr; namelen: u_int;
    lpCallerData: PWSABUF; lpCalleeData: PWSABUF; lpSQOS: PQOS; lpGQOS: PQOS;
    dwFlags: DWORD): TSocket; stdcall;
function WSANtohl( s: TSocket; netlong: u_long; lphostlong: pu_long)
    : u_int; stdcall;
function WSANtohs( s: TSocket; netshort: u_short; lphostshort: pu_short)
    : u_int; stdcall;
function WSARecv( s: TSocket; lpBuffers: PWSABUF; dwBufferCount: DWORD;
    lpNumberOfBytesRecvd: PDWORD; lpFlags: PDWORD;lpOverlapped: LPWSAOVERLAPPED;
    lpCompletionRoutine: PWSAOVERLAPPED_COMPLETION_ROUTINE): u_int; stdcall;
function WSARecvDisconnect( s: TSocket; lpInboundDisconnectData: PWSABUF)
    : u_int; stdcall;
function WSARecvFrom( s: TSocket; lpBuffers: PWSABUF; dwBufferCount: DWORD;
    lpNumberOfBytesRecvd: PDWORD; lpFlags: PDWORD; lpFrom: psockaddr;
    lpFromlen: PInt; lpOverlapped: LPWSAOVERLAPPED;
    lpCompletionRoutine: PWSAOVERLAPPED_COMPLETION_ROUTINE): u_int; stdcall;
function WSAResetEvent( hEvent: WSAEVENT): BOOL; stdcall;
function WSASend( s: TSocket; lpBuffers: PWSABUF; dwBufferCount: DWORD;
    lpNumberOfBytesSent: PDWORD; dwFlags: DWORD; lpOverlapped: LPWSAOVERLAPPED;
    lpCompletionRoutine: PWSAOVERLAPPED_COMPLETION_ROUTINE): u_int; stdcall;
function WSASendDisconnect( s: TSocket; lpOutboundDisconnectData: PWSABUF)
    : u_int; stdcall;
function WSASendTo(s: TSocket; lpBuffers: PWSABUF; dwBufferCount: DWORD;
    lpNumberOfBytesSent: PDWORD;dwFlags: DWORD; lpTo: psockaddr; iTolen: u_int;
    lpOverlapped: LPWSAOVERLAPPED;
    lpCompletionRoutine: PWSAOVERLAPPED_COMPLETION_ROUTINE): u_int; stdcall;
function WSASetEvent( hEvent: WSAEVENT): BOOL; stdcall;
{$IFDEF UNICODE}
function WSASocket( af: u_int; atype: u_int; protocol: u_int;
    lpProtocolInfo: PWSAPROTOCOL_INFOW; g: TGroup; dwFlags: Dword)
    : TSocket; stdcall;
{$ELSE}
function WSASocket( af: u_int; atype: u_int; protocol: u_int;
    lpProtocolInfo: PWSAPROTOCOL_INFOA; g: TGroup; dwFlags: Dword)
    : TSocket; stdcall;
{$ENDIF} { UNICODE}
function WSAWaitForMultipleEvents( cEvents: DWORD; lphEvents: LPWSAEVENT;
    fWaitAll: BOOL; dwTimeout: DWORD; fAlertable: BOOL): DWORD; stdcall;
{$IFDEF UNICODE}
function WSAAddressToString( lpsaAddress: PSOCKADDR; dwAddressLength: DWORD;
    lpProtocolInfo: PWSAPROTOCOL_INFOW; lpszAddressString: WideChar;
    lpdwAddressStringLength: PDWORD): u_int; stdcall;
{$ELSE}
function WSAAddressToString( lpsaAddress: PSOCKADDR; dwAddressLength: DWORD;
    lpProtocolInfo: PWSAPROTOCOL_INFOA; lpszAddressString: PChar;
    lpdwAddressStringLength: PDWORD): u_int; stdcall;
{$ENDIF} { UNICODE}

{$IFDEF UNICODE}
function WSAStringToAddress( AddressString: WideChar; AddressFamily: u_int;
    lpProtocolInfo: PWSAPROTOCOL_INFOW; lpAddress: PSOCKADDR;
    lpAddressLength: PInt): u_int; stdcall;
{$ELSE}
function WSAStringToAddress( AddressString: PChar; AddressFamily: u_int;
    lpProtocolInfo: PWSAPROTOCOL_INFOA; lpAddress: PSOCKADDR;
    lpAddressLength: PInt): u_int; stdcall;
{$ENDIF} { UNICODE}

{ Registration and Name Resolution API functions }

{$IFDEF UNICODE}
function WSALookupServiceBegin( lpqsRestrictions: PWSAQUERYSETW;
    dwControlFlags: DWORD; lphLookup: LPHANDLE): u_int; stdcall;
{$ELSE}
function WSALookupServiceBegin( lpqsRestrictions: PWSAQUERYSETA;
    dwControlFlags: DWORD; lphLookup: LPHANDLE): u_int; stdcall;
{$ENDIF} { UNICODE}

{$IFDEF UNICODE}
function WSALookupServiceNext( hLookup: THANDLE; dwControlFlags: DWORD;
    lpdwBufferLength: PDWORD; lpqsResults: PWSAQUERYSETW): u_int; stdcall;
{$ELSE}
function WSALookupServiceNext( hLookup: THANDLE; dwControlFlags: DWORD;
    lpdwBufferLength: PDWORD; lpqsResults: PWSAQUERYSETA): LongInt; stdcall;
{$ENDIF} { UNICODE}

function WSALookupServiceEnd( hLookup: THandle): u_int; stdcall;

{$IFDEF UNICODE}
function WSAInstallServiceClass( lpServiceClassInfo: PWSASERVICECLASSINFOW
    ): u_int; stdcall;
{$ELSE}
function WSAInstallServiceClass( lpServiceClassInfo: PWSASERVICECLASSINFOA
    ): u_int; stdcall;
{$ENDIF} { UNICODE}

function WSARemoveServiceClass(lpServiceClassId: PGUID): u_int; stdcall;

{$IFDEF UNICODE}
function WSAGetServiceClassInfo( lpProviderId: PGUID; lpServiceClassId: PGUID;
    lpdwBufSize: PDWORD; lpServiceClassInfo: PWSASERVICECLASSINFOW)
    : u_int; stdcall;
{$ELSE}
function WSAGetServiceClassInfo( lpProviderId: PGUID; lpServiceClassId: PGUID;
    lpdwBufSize: PDWORD; lpServiceClassInfo: PWSASERVICECLASSINFOA)
    : u_int; stdcall;
{$ENDIF} { UNICODE}

{$IFDEF UNICODE}
function WSAEnumNameSpaceProviders( lpdwBufferLength: PDWORD;
    lpnspBuffer: PWSANAMESPACE_INFOW):u_int; stdcall;
{$ELSE}
function WSAEnumNameSpaceProviders( lpdwBufferLength: PDWORD;
    lpnspBuffer: PWSANAMESPACE_INFOA):u_int; stdcall;
{$ENDIF} { UNICODE}

{$IFDEF UNICODE}
function WSAGetServiceClassNameByClassId( lpServiceClassId: PGUID;
    lpszServiceClassName: WideChar; lpdwBufferLength: PDWORD): u_int; stdcall;
{$ELSE}
function WSAGetServiceClassNameByClassId( lpServiceClassId: PGUID;
    lpszServiceClassName: PChar; lpdwBufferLength: PDWORD): u_int; stdcall;
{$ENDIF} { UNICODE}

{$IFDEF UNICODE}
function WSASetService( lpqsRegInfo: PWSAQUERYSETW;
    essoperation: TWSAESETSERVICEOP; dwControlFlags: DWORD):u_int; stdcall;
{$ELSE}
function WSASetService( lpqsRegInfo: PWSAQUERYSETA;
    essoperation: TWSAESETSERVICEOP; dwControlFlags: DWORD):u_int; stdcall;
{$ENDIF} { UNICODE}

function WSARecvEx(s: TSocket; var buf; len: Integer; var flags: Integer): Integer; stdcall;

function TransmitFile(hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
  nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
  lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;

function WSAMakeASyncReply(Buflen, Error: Word): Longint;
function WSAMakeSelectReply(Event, Error: Word): Longint;
function WSAGetAsyncBuflen(Param: Longint): Word;
function WSAGetAsyncError(Param: Longint): Word;
function WSAGetSelectEvent(Param: Longint): Word;
function WSAGetSelectError(Param: Longint): Word;

implementation

const
  winsocket = 'ws2_32.dll';

function WSAMakeASyncReply;
begin
  WSAMakeASyncReply:= MakeLong(Buflen, Error);
end;

function WSAMakeSelectReply;
begin
  WSAMakeSelectReply:= MakeLong(Event, Error);
end;

function WSAGetAsyncBuflen;
begin
  WSAGetAsyncBuflen:= LOWORD(Param);
end;

function WSAGetAsyncError;
begin
  WSAGetAsyncError:= HIWORD(Param);
end;

function WSAGetSelectEvent;
begin
  WSAGetSelectEvent:= LOWORD(Param);
end;

function WSAGetSelectError;
begin
  WSAGetSelectError:= HIWORD(Param);
end;

function accept;
         external    winsocket name 'accept';
function bind;
         external    winsocket name 'bind';
function closesocket;
         external    winsocket name 'closesocket';
function connect;
         external    winsocket name 'connect';
function getpeername;
         external    winsocket name 'getpeername';
function getsockname;
         external    winsocket name 'getsockname';
function getsockopt;
         external    winsocket name 'getsockopt';
function htonl;
         external    winsocket name 'htonl';
function htons;
         external    winsocket name 'htons';
function inet_addr;
         external    winsocket name 'inet_addr';
function inet_ntoa;
         external    winsocket name 'inet_ntoa';
function ioctlsocket;
         external    winsocket name 'ioctlsocket';
function listen;
         external    winsocket name 'listen';
function ntohl;
         external    winsocket name 'ntohl';
function ntohs;
         external    winsocket name 'ntohs';
function recv;
         external    winsocket name 'recv';
function recvfrom;
         external    winsocket name 'recvfrom';
function select;
         external    winsocket name 'select';
function send;
         external    winsocket name 'send';
function sendto;
         external    winsocket name 'sendto';
function setsockopt;
         external    winsocket name 'setsockopt';
function shutdown;
         external    winsocket name 'shutdown';
function socket;
         external    winsocket name 'socket';

function gethostbyaddr;
         external    winsocket name 'gethostbyaddr';
function gethostbyname;
         external    winsocket name 'gethostbyname';
function getprotobyname;
         external    winsocket name 'getprotobyname';
function getprotobynumber;
         external    winsocket name 'getprotobynumber';
function getservbyname;
         external    winsocket name 'getservbyname';
function getservbyport;
         external    winsocket name 'getservbyport';
function gethostname;
         external    winsocket name 'gethostname';

function WSAAsyncSelect;
         external    winsocket name 'WSAAsyncSelect';
function WSARecvEx;
         external    winsocket name 'WSARecvEx';
function WSAAsyncGetHostByAddr;
         external winsocket name 'WSAAsyncGetHostByAddr';
function WSAAsyncGetHostByName;
         external winsocket name 'WSAAsyncGetHostByName';
function WSAAsyncGetProtoByNumber;
         external winsocket name 'WSAAsyncGetProtoByNumber';
function WSAAsyncGetprotoByName;
         external winsocket name 'WSAAsyncGetprotoByName';
function WSAAsyncGetServByPort;
         external winsocket name 'WSAAsyncGetServByPort';
function WSAAsyncGetServByName;
         external winsocket name 'WSAAsyncGetServByName';
function WSACancelAsyncRequest;
         external winsocket name 'WSACancelAsyncRequest';
function WSASetBlockingHook;
         external    winsocket name 'WSASetBlockingHook';
function WSAUnhookBlockingHook;
         external winsocket name 'WSAUnhookBlockingHook';
function WSAGetLastError;
         external    winsocket name 'WSAGetLastError';
procedure WSASetLastError;
         external    winsocket name 'WSASetLastError';
function WSACancelBlockingCall;
         external winsocket name 'WSACancelBlockingCall';
function WSAIsBlocking;
         external     winsocket name 'WSAIsBlocking';
function WSAStartup;
         external     winsocket name 'WSAStartup';
function WSACleanup;
         external     winsocket name 'WSACleanup';

{$IFDEF UNICODE}
function WSASetService;
         external     winsocket name 'WSASetServiceW';
function WSAGetServiceClassNameByClassId;
         external     winsocket name 'WSAGetServiceClassNameByClassIdW';
function WSAEnumNameSpaceProviders;
         external     winsocket name 'WSAEnumNameSpaceProvidersW';
function WSAGetServiceClassInfo;
         external     winsocket name 'WSAGetServiceClassInfoW';
function WSAInstallServiceClass;
         external     winsocket name 'WSAInstallServiceClassW';
function WSALookupServiceNext;
         external     winsocket name 'WSALookupServiceNextW';
function WSALookupServiceBegin;
         external     winsocket name 'WSALookupServiceBeginW';
function WSAStringToAddress;
         external     winsocket name 'WSAStringToAddressW';
function WSAAddressToString;
         external     winsocket name 'WSAAddressToStringW';
function WSASocket;
         external     winsocket name 'WSASocketW';
function WSAEnumProtocols;
         external     winsocket name 'WSAEnumProtocolsW';
function WSADuplicateSocket;
         external     winsocket name 'WSADuplicateSocketW';
{$ELSE}
function WSASetService;
         external     winsocket name 'WSASetServiceA';
function WSAGetServiceClassNameByClassId;
         external     winsocket name 'WSAGetServiceClassNameByClassIdA';
function WSAEnumNameSpaceProviders;
         external     winsocket name 'WSAEnumNameSpaceProvidersA';
function WSAGetServiceClassInfo;
         external     winsocket name 'WSAGetServiceClassInfoA';
function WSAInstallServiceClass;
         external     winsocket name 'WSAInstallServiceClassA';
function WSALookupServiceNext;
         external     winsocket name 'WSALookupServiceNextA';
function WSALookupServiceBegin;
         external     winsocket name 'WSALookupServiceBeginA';
function WSAStringToAddress;
         external     winsocket name 'WSAStringToAddressA';
function WSAAddressToString;
         external     winsocket name 'WSAAddressToStringA';
function WSASocket;
         external     winsocket name 'WSASocketA';
function WSAEnumProtocols;
         external     winsocket name 'WSAEnumProtocolsA';
function WSADuplicateSocket;
         external     winsocket name 'WSADuplicateSocketA';
{$ENDIF} { UNICODE}


function WSALookupServiceEnd;
         external     winsocket name 'WSALookupServiceEnd';
function WSARemoveServiceClass;
         external     winsocket name 'WSARemoveServiceClass';
function WSAWaitForMultipleEvents;
         external     winsocket name 'WSAWaitForMultipleEvents';
function WSASetEvent;
         external     winsocket name 'WSASetEvent';
function WSASendTo;
         external     winsocket name 'WSASendTo';
function WSASendDisconnect;
         external     winsocket name 'WSASendDisconnect';
function WSASend;
         external     winsocket name 'WSASend';
function WSAResetEvent;
         external     winsocket name 'WSAResetEvent';
function WSARecvFrom;
         external     winsocket name 'WSARecvFrom';
function WSARecvDisconnect;
         external     winsocket name 'WSARecvDisconnect';
function WSARecv;
         external     winsocket name 'WSARecv';
function WSAIoctl;
         external     winsocket name 'WSAIoctl';
function WSAJoinLeaf;
         external     winsocket name 'WSAJoinLeaf';
function WSANtohl;
         external     winsocket name 'WSANtohl';
function WSANtohs;
         external     winsocket name 'WSANtohs';
function WSAHtons;
         external     winsocket name 'WSAHtons';
function WSAHtonl;
         external     winsocket name 'WSAHtonl';
function WSAGetQOSByName;
         external     winsocket name 'WSAGetQOSByName';
function WSAGetOverlappedResult;
         external     winsocket name 'WSAGetOverlappedResult';
function WSAEventSelect;
         external     winsocket name 'WSAEventSelect';
function WSAEnumNetworkEvents;
         external     winsocket name 'WSAEnumNetworkEvents';
function WSACreateEvent;
         external     winsocket name 'WSACreateEvent';
function WSAConnect;
         external     winsocket name 'WSAConnect';
function WSACloseEvent;
         external     winsocket name 'WSACloseEvent';
function WSAAccept;
         external     winsocket name 'WSAAccept';

function TransmitFile;
         external     winsocket name 'TransmitFile';

end.
