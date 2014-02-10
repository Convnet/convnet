program Project1;

uses
  fastmm4,
  FastMM4Messages,

  //sharemem,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  dll in 'dll.pas',
  Crypt in 'Crypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
