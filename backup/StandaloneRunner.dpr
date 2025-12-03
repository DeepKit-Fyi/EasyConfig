program StandaloneRunner;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  ConfigManager in 'ConfigManager.pas',
  BaseConfig in 'BaseConfig.pas',
  ConfigTypes in 'ConfigTypes.pas',
  ConfigRegistry in 'ConfigRegistry.pas',
  INIConfig in 'INIConfig.pas',
  JSONConfig in 'JSONConfig.pas',
  TestFramework in 'TestFramework.pas',
  StandaloneMediaTests in 'StandaloneMediaTests.pas',
  ConfigManagerTests in 'ConfigManagerTests.pas';

var
  ReportFile: string;
  FailCount: Integer;

begin
  try
    WriteLn('配置管理系统独立测试运行器');
    WriteLn('===================================');
    WriteLn('开始执行配置管理系统测试...');
    WriteLn;
    
    // 设置测试报告文件名
    ReportFile := 'ConfigManagementTestReport.txt';
    WriteLn('测试报告将保存到文件: ', ReportFile);
    WriteLn;
    
    // 运行测试并生成报告
    FailCount := RunRegisteredTests(ReportFile);
    
    WriteLn;
    WriteLn('测试完成。');
    
    if FailCount = 0 then
      WriteLn('所有测试均通过！')
    else
      WriteLn('有 ', FailCount, ' 个测试失败，请查看测试报告了解详情。');
  except
    on E: Exception do
      WriteLn('错误：', E.Message);
  end;
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 