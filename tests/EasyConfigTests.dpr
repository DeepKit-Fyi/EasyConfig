program EasyConfigTests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  // 被测试的单元（核心逻辑，无 FMX 依赖）
  ConfigManager in '..\ConfigManager.pas',
  ConfigValidator in '..\ConfigValidator.pas',
  UndoRedoManager in '..\UndoRedoManager.pas',
  UtilsTypesFMX in '..\UtilsTypesFMX.pas',
  INIConfig in '..\INIConfig.pas',
  JSONConfig in '..\JSONConfig.pas',
  JSONHelpers in '..\JSONHelpers.pas',
  // 测试单元（核心逻辑测试）
  Test.ConfigManager in 'Test.ConfigManager.pas',
  Test.UtilsTypesFMX in 'Test.UtilsTypesFMX.pas',
  Test.ConfigValidator in 'Test.ConfigValidator.pas',
  Test.UndoRedoManager in 'Test.UndoRedoManager.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;
{$ENDIF}

begin
  ReportMemoryLeaksOnShutdown := True;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    // 检查命令行参数
    TDUnitX.CheckCommandLine;
    
    // 创建测试运行器
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    runner.FailsOnNoAsserts := False;
    
    // 添加控制台日志
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    
    // 添加 NUnit XML 日志
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    
    // 运行测试
    results := runner.Execute;
    
    // 如果不是在 CI 环境中，等待用户输入
    if TDUnitX.Options.ExitBehavior <> TDUnitXExitBehavior.Continue then
    begin
      System.Write('按回车键退出...');
      System.Readln;
    end;
    
    // 返回退出码
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;
      
  except
    on E: Exception do
    begin
      System.Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := EXIT_ERRORS;
    end;
  end;
{$ENDIF}
end.
