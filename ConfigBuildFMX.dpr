program ConfigBuildFMX;
{*******************************************************************************
  ConfigBuild - 跨平台配置文件编辑器 (FMX)
  支持 INI + JSON 混合配置格式
*******************************************************************************}

uses
  System.StartUpCopy,
  FMX.Forms,
  ViewMainFormFMX in 'ViewMainFormFMX.pas' {ViewMainFormFMX},
  UtilsTypesFMX in 'UtilsTypesFMX.pas',
  ConfigFrameBaseFMX in 'ConfigFrameBaseFMX.pas',
  ControllerConfigsFMX in 'ControllerConfigsFMX.pas',
  FrameFontEditorFMX in 'FrameFontEditorFMX.pas' {FrameFontEditorFMX: TFrame},
  FrameDBEditorFMX in 'FrameDBEditorFMX.pas' {FrameDBEditorFMX: TFrame},
  FrameAIAPIEditorFMX in 'FrameAIAPIEditorFMX.pas' {FrameAIAPIEditorFMX: TFrame},
  FrameSimpleEditorFMX in 'FrameSimpleEditorFMX.pas' {FrameSimpleEditorFMX: TFrame},
  FrameBgDrawEditorFMX in 'FrameBgDrawEditorFMX.pas' {FrameBgDrawEditorFMX: TFrame},
  FrameVideoClipEditorFMX in 'FrameVideoClipEditorFMX.pas' {FrameVideoClipEditorFMX: TFrame},
  ConfigManager in 'ConfigManager.pas',
  INIConfig in 'INIConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  JSONHelpers in 'JSONHelpers.pas',
  ConfigValidator in 'ConfigValidator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewMainFormFMX, ViewMainFormFMX);
  Application.Run;
end.
