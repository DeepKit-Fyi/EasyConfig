program TestRunner1;

{$APPTYPE CONSOLE}

uses
  TestFramework in 'TestFramework.pas',
  MediaConfigTests in 'MediaConfigTests.pas';

begin
  WriteLn('配置管理系统测试运行器');
  WriteLn('-----------------------------------');
  WriteLn('开始执行测试...');
  WriteLn;
  
  RunRegisteredTests;
  
  WriteLn;
  WriteLn('测试完成。');
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 