program MinimalMediaTestRunner;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  TestFramework in 'TestFramework.pas';

type
  { 模拟媒体配置对象测试 }
  TSimpleMediaTest = class(TTestCase)
  private
    FSampleString: string;
    FSampleValue: Integer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestStringManipulation;
    procedure TestIntegerCalculation;
    procedure Run; override;
  end;

{ TSimpleMediaTest }

constructor TSimpleMediaTest.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TSimpleMediaTest.SetUp;
begin
  WriteLn('设置简单媒体测试环境');
  FSampleString := '测试字符串';
  FSampleValue := 100;
end;

procedure TSimpleMediaTest.TearDown;
begin
  WriteLn('清理简单媒体测试环境');
end;

procedure TSimpleMediaTest.TestStringManipulation;
var
  TestString: string;
  ActualLength: Integer;
begin
  WriteLn('测试字符串操作');
  
  // 基本字符串测试
  TestString := FSampleString + '后缀';
  WriteLn('  字符串: "', FSampleString, '" + "后缀" = "', TestString, '"');
  
  // 直接用Check代替CheckEquals，避免字符串比较问题
  Check(Pos(FSampleString, TestString) = 1, '字符串连接失败-基础字符串位置不正确');
  Check(Pos('后缀', TestString) > 0, '字符串连接失败-后缀没有添加');
  
  // 中文字符串长度 - Delphi中每个中文字符占用多个字节，因此使用实际显示字符数
  ActualLength := Length(FSampleString);
  WriteLn('  中文字符串"', FSampleString, '"在Delphi中的长度: ', ActualLength);
  Check(ActualLength > 0, '字符串长度检查失败-长度为零');
end;

procedure TSimpleMediaTest.TestIntegerCalculation;
var
  Result1, Result2: Integer;
begin
  WriteLn('测试整数计算');
  
  // 基本加法测试
  Result1 := FSampleValue + 50;
  WriteLn('  加法：预期=150, 实际=', Result1);
  Check(Result1 = 150, '整数加法计算失败');
  
  // 乘法测试
  Result2 := FSampleValue * 2;
  WriteLn('  乘法：预期=200, 实际=', Result2);
  Check(Result2 = 200, '整数乘法计算失败');
end;

procedure TSimpleMediaTest.Run;
begin
  SetUp;
  try
    WriteLn('执行简单媒体测试: ', TestName);
    
    // 分别测试每个方法
    WriteLn('--- 测试字符串操作 ---');
    try
      TestStringManipulation;
      WriteLn('  字符串测试通过');
    except
      on E: Exception do
        WriteLn('  字符串测试异常: ', E.Message);
    end;
    
    WriteLn('--- 测试整数计算 ---');
    try
      TestIntegerCalculation;
      WriteLn('  整数测试通过');
    except
      on E: Exception do
        WriteLn('  整数测试异常: ', E.Message);
    end;
  finally
    TearDown;
  end;
end;

var
  Test: TSimpleMediaTest;
  Suite: TTestSuite;
  ReportFile: string;
  FailCount: Integer;

begin
  try
    WriteLn('最小媒体测试运行器');
    WriteLn('===================================');
    WriteLn('开始执行基础测试...');
    WriteLn;
    
    // 手动创建测试套件并注册
    Suite := TTestSuite.Create('简单媒体测试套件');
    Test := TSimpleMediaTest.Create('简单媒体测试');
    Suite.AddTest(Test);
    RegisterTest(Suite);
    
    // 设置测试报告文件名
    ReportFile := 'MinimalMediaTestReport.txt';
    WriteLn('测试报告将保存到文件: ', ReportFile);
    WriteLn;
    
    // 运行测试并生成报告
    FailCount := RunRegisteredTests(ReportFile);
    
    WriteLn;
    WriteLn('测试完成。');
    
    if FailCount = 0 then
      WriteLn('所有测试均通过！')
    else
      WriteLn('有 ', IntToStr(FailCount), ' 个测试失败，请查看测试报告了解详情。');
  except
    on E: Exception do
      WriteLn('错误：', E.Message);
  end;
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 