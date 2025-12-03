program BasicTestsRunner;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  TestFramework;

type
  TBasicTest = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure Run; override;
    procedure TestSimpleAssertions;
  end;

{ TBasicTest }

constructor TBasicTest.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TBasicTest.SetUp;
begin
  WriteLn('设置测试环境');
end;

procedure TBasicTest.TearDown;
begin
  WriteLn('清理测试环境');
end;

procedure TBasicTest.TestSimpleAssertions;
begin
  WriteLn('测试基本断言');
  
  // 基本断言测试
  CheckTrue(True, '真值检查失败');
  CheckFalse(False, '假值检查失败');
  CheckEquals('test', 'test', '字符串相等检查失败');
  CheckEquals(10, 10, '整数相等检查失败');
  CheckEquals(10.5, 10.5, 0.001, '浮点数相等检查失败');
  CheckNotNull(Self, '非空检查失败');
end;

procedure TBasicTest.Run;
begin
  SetUp;
  try
    WriteLn('执行测试: ', TestName);
    TestSimpleAssertions;
  finally
    TearDown;
  end;
end;

var
  ReportFile: string;
  FailCount: Integer;
  Suite: TTestSuite;
  Test: TBasicTest;

begin
  try
    WriteLn('基本测试运行器');
    WriteLn('===================================');
    
    // 注册测试
    Suite := TTestSuite.Create('基本测试套件');
    Test := TBasicTest.Create('基本测试');
    Suite.AddTest(Test);
    RegisterTest(Suite);
    
    // 设置测试报告文件名
    ReportFile := 'BasicTestReport.txt';
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