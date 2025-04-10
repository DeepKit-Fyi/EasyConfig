program ConfigBuild;

uses
  Vcl.Forms,
  ViewBuildConfig in 'ViewBuildConfig.pas' {MainForm},
  ConfigIntf in 'ConfigIntf.pas',
  ConfigTypes in 'ConfigTypes.pas',
  FrameFontEditor in 'FrameFontEditor.pas',
  FrameAIAPIEditor in 'FrameAIAPIEditor.pas',
  FrameDBEditor in 'FrameDBEditor.pas',
  FrameObjectEditor in 'FrameObjectEditor.pas',
  FrameListEditor in 'FrameListEditor.pas',
  FramesComplexEditor in 'FramesComplexEditor.pas',
  ConfigFrameBase in 'ConfigFrameBase.pas',
  FrameConfigEditor in 'FrameConfigEditor.pas' {frameConfigEditor: TframeConfigEditor},
  FrameArrayEditor in 'FrameArrayEditor.pas',
  UtilsTypes in 'UtilsTypes.pas',
  UtilCompat in 'UtilCompat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmBuildConfig, MainForm);
  Application.Run;
end.


