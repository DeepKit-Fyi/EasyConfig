program MediaConfigTestRunner;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  TestFramework in 'TestFramework.pas',
  StandaloneMediaTests in 'StandaloneMediaTests.pas',
  MediaConfigFileTests in 'MediaConfigFileTests.pas';

var
  ReportFile: string;
  FailCount: Integer;

begin
  try
    WriteLn('媒体配置系统测试运行器');
    WriteLn('===================================');
    WriteLn('开始执行媒体配置测试...');
    WriteLn;
    
    // 设置测试报告文件名
    ReportFile := 'MediaConfigTestReport.txt';
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