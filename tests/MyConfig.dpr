program MyConfig;

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF}

uses
  Vcl.Forms,
  ConfigTypes in 'ConfigTypes.pas',
  BaseConfig in 'BaseConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  INIConfig in 'INIConfig.pas',
  FormHelper in 'FormHelper.pas',
  ConfigManager in 'ConfigManager.pas',
  TreeHelper in 'TreeHelper.pas',
  ObjectTree in 'ObjectTree.pas',
  FontEditor in 'FontEditor.pas' {TFontEditor},
  UTF8Converter in 'UTF8Converter.pas' {frmUTF8Converter},
  ConfigObjectSelect in 'ConfigObjectSelect.pas' {ConfigSelector},
  ConfigEditorFrame in 'ConfigEditorFrame.pas' {ConfigEditorFrame: TFrame},
  // MVC重构单元
  ModelConfig in 'ModelConfig.pas',
  ModelRegistry in 'ModelRegistry.pas',
  ViewMain in 'ViewMain.pas' {frmMain},
  ViewConfigEditor in 'ViewConfigEditor.pas',
  ControllerMain in 'ControllerMain.pas',
  UtilsLog in 'UtilsLog.pas',
  UtilsUTF8 in 'UtilsUTF8.pas',
  HelperForm in 'HelperForm.pas',
  HelperTree in 'HelperTree.pas',
  UtilsStrs in 'UtilsStrs.pas',
  ControllerIntf in 'ControllerIntf.pas',
  ConfigEditorUnit in 'ConfigEditorUnit.pas',
  ConfigEditor in 'ConfigEditor.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end. 