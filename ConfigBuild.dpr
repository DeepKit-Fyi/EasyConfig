program ConfigBuild;

uses
  Vcl.Forms,
  System.SysUtils,
  Vcl.Dialogs,
  ViewBuildConfig in 'ViewBuildConfig.pas' {FrmBuildConfig},
  ConfigIntf in 'ConfigIntf.pas',
  UtilsTypes in 'UtilsTypes.pas',
  JSONHelpers in 'JSONHelpers.pas',
  FrameFontEditor in 'FrameFontEditor.pas',
  FrameAIAPIEditor in 'FrameAIAPIEditor.pas',
  FrameDBEditor in 'FrameDBEditor.pas',
  FrameObjectEditor in 'FrameObjectEditor.pas',
  FrameListEditor in 'FrameListEditor.pas',
  FramesComplexEditor in 'FramesComplexEditor.pas',
  ConfigFrameBase in 'ConfigFrameBase.pas',
  FrameConfigEditor in 'FrameConfigEditor.pas' {frameConfigEditor: TframeConfigEditor},
  FrameArrayEditor in 'FrameArrayEditor.pas',
  FrameKeyValueDictEditor in 'FrameKeyValueDictEditor.pas' {FrameKeyValueDictEditor},
  // FrameNetConfigEditor in 'FrameNetConfigEditor.pas',
  FrameGeoLocationEditor in 'FrameGeoLocationEditor.pas',
  // FrameEncryptEditor in 'FrameEncryptEditor.pas',
  // FrameDateTimeRangeEditor in 'FrameDateTimeRangeEditor.pas',
  ConfigValidator in 'ConfigValidator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmBuildConfig, FrmBuildConfig);
  Application.Run;
end.


