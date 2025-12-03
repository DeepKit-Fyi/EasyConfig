program TestRunner;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Forms,
  // 测试框架
  TestFramework in 'TestFramework.pas',
  TextTestRunner in 'TextTestRunner.pas',
  GUITestRunner in 'GUITestRunner.pas',
  // 配置基础类
  ConfigTypes in 'ConfigTypes.pas',
  // 配置对象类
  SystemConfig in 'SystemConfig.pas',
  UIConfig in 'UIConfig.pas',
  MediaConfig in 'MediaConfig.pas',
  // 配置器和验证器
  ConfigManager in 'ConfigManager.pas',
  ConfigValidator in 'ConfigValidator.pas',
  // 测试单元
  SystemConfigTests in 'SystemConfigTests.pas',
  UIConfigTests in 'UIConfigTests.pas',
  MediaConfigTests in 'MediaConfigTests.pas';

{$R *.res}

var
  ExitCode: Integer;

begin
  try
    Application.Initialize;
    if ParamCount > 0 then
    begin
      // 控制台模式运行测试
      WriteLn('开始执行配置对象测试...');
      WriteLn('----------------------------------------');
      ExitCode := TextTestRunner.RunRegisteredTests;
      WriteLn('----------------------------------------');
      WriteLn(Format('测试完成，退出代码: %d', [ExitCode]));
      Halt(ExitCode);
    end
    else
    begin
      // GUI模式运行测试
      GUITestRunner.RunRegisteredTests;
    end;
  except
    on E: Exception do
    begin
      WriteLn(Format('测试运行器错误: %s', [E.Message]));
      ExitCode := 1;
      Halt(ExitCode);
    end;
  end;
end. 