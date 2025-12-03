program ConfigEditor;

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
  FrameVideoEditor in 'FrameVideoEditor.pas' {FrameVideoEditor: TFrame},
  FrameNetConfigEditor in 'FrameNetConfigEditor.pas' {FrameNetConfigEditor: TFrame},
  FrameGeoLocationEditor in 'FrameGeoLocationEditor.pas' {FrameGeoLocationEditor: TFrame},
  FrameEncryptEditor in 'FrameEncryptEditor.pas' {FrameEncryptEditor: TFrame},
  FrameDateTimeRangeEditor in 'FrameDateTimeRangeEditor.pas' {FrameDateTimeRangeEditor: TFrame},
  ConfigValidator in 'ConfigValidator.pas',
  ValidationDialog in 'ValidationDialog.pas' {frmValidation},
  ErrorLogger in 'ErrorLogger.pas',
  ErrorDialog in 'ErrorDialog.pas' {frmErrorDialog},
  ExceptionRecovery in 'ExceptionRecovery.pas',
  LazyLoadManager in 'LazyLoadManager.pas',
  OptimizedJSONTreeView in 'OptimizedJSONTreeView.pas',
  OptimizedINIGrid in 'OptimizedINIGrid.pas',
  MemoryOptimizer in 'MemoryOptimizer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.