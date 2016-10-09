program nettool;

uses
  Forms,
  FrmMainU in 'FrmMainU.pas' {FrmMain},
  FrmPortDetailsU in 'FrmPortDetailsU.pas' {FrmPortDetails};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
