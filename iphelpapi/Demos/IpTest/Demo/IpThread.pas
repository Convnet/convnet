{******************************************************************}
{                                                                  }
{       IpTest - IP Helper API Demonstration project               }
{                                                                  }
{ Portions created by Vladimir Vassiliev are                       }
{ Copyright (C) 2000 Vladimir Vassiliev.                           }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: IpThread.pas, released  December 2000.     }
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
unit IpThread;

interface

uses
  Classes,
  Windows,
  Dialogs,
  SysUtils;

type
  TWaitingThread = class(TThread)
  private
    fHandle: THandle;
    fIOHandle: THandle;
    fOverlaped: TOverlapped;
    fShowString: string;
    fTyp: integer;
    procedure ShowLine;
  public
    constructor Create(var IOHandle: THandle; ShowString: string; Typ: integer);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

implementation

uses
  IpUnit1,
  IpFunctions;

{ TWaitingThread }

constructor TWaitingThread.Create(var IOHandle: THandle; ShowString: string; Typ: integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  fHandle := 0;
  fShowString := ShowString;
  fTyp := Typ;
  if  fTyp = 1 then
    VVNotifyAddrChange(fHandle, @fOverlaped)
  else
    VVNotifyRouteChange(fHandle, @fOverlaped);
  if IoHandle = 0 then
  begin
    fIOHandle := CreateIoCompletionPort(fHandle, 0, 0, 0);
    if fIOHandle = 0 then
      RaiseLastWin32Error;
    IOHandle := fIOHandle;
  end
  else
    fIOHandle := IOHandle;
  Resume;
end;

destructor TWaitingThread.Destroy;
begin
  PostMessage(FmIpTest.Handle, wm_ThreadDoneMsg, fTyp, 0);
  inherited;
end;

procedure TWaitingThread.Execute;
var
  Res: BOOL;
  Key, NoOfBytes: Cardinal;
  fLPOverlaped: POverlapped;
begin
  repeat
    fLPOverlaped := @fOverlaped;
    Res := GetQueuedCompletionStatus(fIOHandle, NoOfBytes, Key, fLPOverlaped, 1000);
    if Res then
    begin
      Synchronize(ShowLine);
      if fTyp = 1 then
        VVNotifyAddrChange(fHandle, @fOverlaped)
      else
        VVNotifyRouteChange(fHandle, @fOverlaped);
    end;
  until Terminated;
end;

procedure TWaitingThread.ShowLine;
begin
  FmIpTest.Memo1.Lines.Add(fShowString);
end;

end.
