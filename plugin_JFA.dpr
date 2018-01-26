program plugin_JFA;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  unit2014 in 'unit2014.pas',
  unit2015 in 'unit2015.pas',
  unitEmperor2015 in 'unitEmperor2015.pas',
  unit2016 in 'unit2016.pas',
  unitEmperor2016 in 'unitEmperor2016.pas',
  unitEastAsia2017 in 'unitEastAsia2017.pas',
  unit2017 in 'unit2017.pas',
  unitHighSchool2015 in 'unitHighSchool2015.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
