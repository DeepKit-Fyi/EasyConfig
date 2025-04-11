program ConfigBuild;

uses
  Vcl.Forms,
  System.SysUtils,
  Vcl.Dialogs,
  ViewBuildConfig in 'ViewBuildConfig.pas' {FrmBuildConfig},
  ConfigIntf in 'ConfigIntf.pas',
  UtilsTypes in 'UtilsTypes.pas',
  FrameFontEditor in 'FrameFontEditor.pas',
  FrameAIAPIEditor in 'FrameAIAPIEditor.pas',
  FrameDBEditor in 'FrameDBEditor.pas',
  FrameObjectEditor in 'FrameObjectEditor.pas',
  FrameListEditor in 'FrameListEditor.pas',
  FramesComplexEditor in 'FramesComplexEditor.pas',
  ConfigFrameBase in 'ConfigFrameBase.pas',
  FrameConfigEditor in 'FrameConfigEditor.pas' {frameConfigEditor: TframeConfigEditor},
  FrameArrayEditor in 'FrameArrayEditor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmBuildConfig, FrmBuildConfig);
  Application.Run;
end.


