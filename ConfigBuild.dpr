program ConfigBuild;

uses
  Vcl.Forms,
  ViewMainConfig in 'ViewMainConfig.pas' {Form1},
  ViewBuildConfig in 'ViewBuildConfig.pas' {ViewBuildConfig: TFrame},
  ConfigIntf in 'ConfigIntf.pas',
  ConfigTypes in 'ConfigTypes.pas',
  FrameFontEditor in 'FrameFontEditor.pas',
  FrameAIAPIEditor in 'FrameAIAPIEditor.pas',
  FrameDBEditor in 'FrameDBEditor.pas',
  FrameObjectEditor in 'FrameObjectEditor.pas',
  FrameListEditor in 'FrameListEditor.pas',
  FramesComplexEditor in 'FramesComplexEditor.pas',
  ConfigFrameBase in 'ConfigFrameBase.pas',
  FrameConfigEditor in 'FrameConfigEditor.pas',
  FrameArrayEditor in 'FrameArrayEditor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
