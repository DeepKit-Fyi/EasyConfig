program ConfigEditor;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  ConfigManager in 'ConfigManager.pas',
  BaseConfig in 'BaseConfig.pas',
  ConfigTypes in 'ConfigTypes.pas',
  INIConfig in 'INIConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  ConfigRegistry in 'ConfigRegistry.pas',
  FormHelper in 'FormHelper.pas',
  TreeHelper in 'TreeHelper.pas',
  ConfigObjectSelect in 'ConfigObjectSelect.pas' {frmConfigObjectSelect},
  ConfigEditors in 'ConfigEditors.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfigObjectSelect, frmConfigObjectSelect);
  Application.Run;
end. 