unit StrConv;

interface

uses SysUtils, Windows;

const               
  CP_INVALID  = DWord(-1);
  CP_ANSI     = CP_ACP;
  CP_OEM      = CP_OEMCP;
  CP_SHIFTJIS = 932;

function MinStrConvBufSize(SrcCodepage: DWord; Str: String): DWord; overload;
function MinStrConvBufSize(DestCodepage: DWord; Wide: WideString): DWord; overload;
function ToWideString(SrcCodepage: DWord; Str: String; BufSIze: Integer = -1): WideString;
function FromWideString(DestCodepage: DWord; Str: WideString; BufSIze: Integer = -1): String;

function CharsetToID(Str: String): DWord;
function IdToCharset(ID: DWord; GetDescription: Boolean = False): String;

implementation

function MinStrConvBufSize(SrcCodepage: DWord; Str: String): DWord;
begin
  Result := MultiByteToWideChar(SrcCodepage, 0, PAnsiChar(Str), -1, NIL, 0)
end;

function MinStrConvBufSize(DestCodepage: DWord; Wide: WideString): DWord;
begin
  Result := WideCharToMultiByte(DestCodepage, 0, PWideChar(Wide), -1, NIL, 0, NIL, NIL)
end;

function ToWideString(SrcCodepage: DWord; Str: String; BufSIze: Integer = -1): WideString;
begin
  if BufSize = -1 then
    BufSize := MinStrConvBufSize(SrcCodepage, Str);
  SetLength(Result, BufSIze * 2);
  MultiByteToWideChar(SrcCodepage, 0, PAnsiChar(Str), -1, PWideChar(Result), BufSIze);
  SetLength(Result, BufSize - 1)
end;

function FromWideString(DestCodepage: DWord; Str: WideString; BufSIze: Integer = -1): String;
begin
  if BufSize = -1 then
    BufSize := MinStrConvBufSize(DestCodepage, Str);
  SetLength(Result, BufSIze);
  WideCharToMultiByte(DestCodepage, 0, PWideChar(Str), -1, PAnsiChar(Result), BufSize, NIL, NIL);
  SetLength(Result, BufSize - 1)
end;

function CharsetToID(Str: String): DWord;
var
  Key: HKEY;
  ValueType, BufSize: DWord;
  Alias: String[255];
begin
  Result := CP_INVALID;

  if RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('MIME\Database\Charset\' + LowerCase(Str)), 0, KEY_QUERY_VALUE, Key) = ERROR_SUCCESS then
    try
      BufSize := SizeOf(Result);
      ValueType := REG_DWORD;
      if (RegQueryValueEx(Key, 'InternetEncoding', NIL, @ValueType, @Result, @BufSize) <> ERROR_SUCCESS) or
         (BufSize <> SizeOf(Result)) then
      begin
        BufSize := SizeOf(Alias);     
        ValueType := REG_SZ;
        if RegQueryValueEx(Key, 'AliasForCharset', NIL, @ValueType, @Alias[1], @BufSize) = ERROR_SUCCESS then
          Result := CharsetToID(Copy(Alias, 1, BufSIze - 1 {= last #0}));
      end;
    finally
      RegCloseKey(Key);
    end;
end;

function IdToCharset(ID: DWord; GetDescription: Boolean = False): String;
var
  Key: HKEY;
  ValueType, BufSize: DWord;
  Field: pchar;
begin
  Result := '';

  if RegOpenKeyEx(HKEY_CLASSES_ROOT, pchar('MIME\Database\Codepage\' + IntToStr(ID)), 0, KEY_QUERY_VALUE, Key) = ERROR_SUCCESS then
    try
      SetLength(Result, 4096);
      BufSize := SizeOf(Result);

      if GetDescription then
        Field := 'Description'
        else
          Field := 'BodyCharset';
                                   
      ValueType := REG_SZ;
      if RegQueryValueEx(Key, Field, NIL, @ValueType, @Result[1], @BufSize) = ERROR_SUCCESS then
        SetLength(Result, BufSize - 1)
        else
          Result := '';
    finally
      RegCloseKey(Key);
    end;     
end;

end.
