program ConfigManger;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  ConfigTypes in 'ConfigTypes.pas',
  ConfigRegistry in 'ConfigRegistry.pas',
  BaseConfig in 'BaseConfig.pas',
  INIConfig in 'INIConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  ConfigManager in 'ConfigManager.pas',
  ConfgiUnit in 'ConfgiUnit.pas' {Form1},
  FormHelper in 'FormHelper.pas',
  TreeHelper in 'TreeHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end. 