{******************************************************************}
{                                                                  }
{       IpTest - IP Helper API Demonstration project               }
{                                                                  }
{ Portions created by Vladimir Vassiliev are                       }
{ Copyright (C) 2000 Vladimir Vassiliev.                           }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: IPTest.dpr, released  December 2000.       }
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

program IpTest;

uses
  Forms,
  IpUnit1 in 'IpUnit1.pas' {FmIpTest},
  IpThread in 'IpThread.pas',
  IPFunctions in 'IpFunctions.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFmIpTest, FmIpTest);
  Application.Run;
end.
