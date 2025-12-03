program TestConfigs;

uses
  Vcl.Forms,
  System.SysUtils,
  FormMain in 'FormMain.pas' {FrmMain},
  ConfigManager in 'ConfigManager.pas',
  ConfigFrameBase in 'ConfigFrameBase.pas',
  ControllerConfigs in 'ControllerConfigs.pas',
  UtilsTypes in 'UtilsTypes.pas',
  INIConfig in 'INIConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  FrameBgDrawEditor in 'FrameBgDrawEditor.pas' {FrameBgDrawEditor: TFrame},
  FrameVideoClipEditor in 'FrameVideoClipEditor.pas' {FrameVideoClipEditor: TFrame},
  FrameVideoEditor in 'FrameVideoEditor.pas' {FrameVideoEditor: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end. 