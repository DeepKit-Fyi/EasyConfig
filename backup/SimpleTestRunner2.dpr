program SimpleTestRunner2;

{$APPTYPE CONSOLE}

uses
  TestFramework in 'TestFramework.pas',
  SimpleMediaConfigTests in 'SimpleMediaConfigTests.pas';

begin
  WriteLn('配置管理系统测试运行器 - 简化版');
  WriteLn('===================================');
  WriteLn('开始执行媒体配置对象测试...');
  WriteLn;
  
  RunRegisteredTests;
  
  WriteLn;
  WriteLn('测试完成。');
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 