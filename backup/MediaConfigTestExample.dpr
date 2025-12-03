program MediaConfigTestExample;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  TestFramework in 'TestFramework.pas';

type
  { 模拟媒体配置基类 }
  TMediaConfig = class
  private
    FName: string;
    FDuration: Integer;
  public
    constructor Create(const AName: string; ADuration: Integer);
    property Name: string read FName write FName;
    property Duration: Integer read FDuration write FDuration;
  end;

  { 模拟图像背景配置 }
  TImageBackgroundConfig = class(TMediaConfig)
  private
    FFileName: string;
    FTransparency: Integer;
  public
    constructor Create(const AName: string; ADuration: Integer; const AFileName: string);
    property FileName: string read FFileName write FFileName;
    property Transparency: Integer read FTransparency write FTransparency;
  end;

  { 模拟视频片段配置 }
  TVideoClipConfig = class(TMediaConfig)
  private
    FVideoFile: string;
    FStartTime: Integer;
    FEndTime: Integer;
  public
    constructor Create(const AName: string; ADuration: Integer; const AVideoFile: string);
    property VideoFile: string read FVideoFile write FVideoFile;
    property StartTime: Integer read FStartTime write FStartTime;
    property EndTime: Integer read FEndTime write FEndTime;
  end;

  { 媒体配置测试类 }
  TMediaConfigTest = class(TTestCase)
  private
    FImageConfig: TImageBackgroundConfig;
    FVideoConfig: TVideoClipConfig;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestImageConfiguration;
    procedure TestVideoConfiguration;
    procedure TestMediaDuration;
    procedure Run; override;
  end;

{ TMediaConfig }

constructor TMediaConfig.Create(const AName: string; ADuration: Integer);
begin
  FName := AName;
  FDuration := ADuration;
end;

{ TImageBackgroundConfig }

constructor TImageBackgroundConfig.Create(const AName: string; ADuration: Integer; const AFileName: string);
begin
  inherited Create(AName, ADuration);
  FFileName := AFileName;
  FTransparency := 100; // 默认完全不透明
end;

{ TVideoClipConfig }

constructor TVideoClipConfig.Create(const AName: string; ADuration: Integer; const AVideoFile: string);
begin
  inherited Create(AName, ADuration);
  FVideoFile := AVideoFile;
  FStartTime := 0;
  FEndTime := ADuration;
end;

{ TMediaConfigTest }

constructor TMediaConfigTest.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TMediaConfigTest.SetUp;
begin
  WriteLn('设置媒体配置测试环境');
  
  // 创建测试用的配置对象
  FImageConfig := TImageBackgroundConfig.Create('背景图像', 5000, 'background.jpg');
  FVideoConfig := TVideoClipConfig.Create('片头视频', 10000, 'intro.mp4');
  
  // 设置视频片段的开始和结束时间
  FVideoConfig.StartTime := 2000;
  FVideoConfig.EndTime := 8000;
  
  // 设置图像透明度
  FImageConfig.Transparency := 80;
end;

procedure TMediaConfigTest.TearDown;
begin
  WriteLn('清理媒体配置测试环境');
  
  // 释放测试对象
  if Assigned(FImageConfig) then
    FImageConfig.Free;
    
  if Assigned(FVideoConfig) then
    FVideoConfig.Free;
end;

procedure TMediaConfigTest.TestImageConfiguration;
begin
  WriteLn('测试图像配置');
  
  // 检查基本属性
  Check(FImageConfig.Name = '背景图像', '图像名称不正确');
  Check(FImageConfig.Duration = 5000, '图像持续时间不正确');
  
  // 检查特定属性
  Check(FImageConfig.FileName = 'background.jpg', '图像文件名不正确');
  Check(FImageConfig.Transparency = 80, '图像透明度不正确');
  
  WriteLn('  图像名称: ', FImageConfig.Name);
  WriteLn('  图像文件: ', FImageConfig.FileName);
  WriteLn('  持续时间: ', FImageConfig.Duration, 'ms');
  WriteLn('  透明度: ', FImageConfig.Transparency, '%');
end;

procedure TMediaConfigTest.TestVideoConfiguration;
begin
  WriteLn('测试视频配置');
  
  // 检查基本属性
  Check(FVideoConfig.Name = '片头视频', '视频名称不正确');
  Check(FVideoConfig.Duration = 10000, '视频持续时间不正确');
  
  // 检查特定属性
  Check(FVideoConfig.VideoFile = 'intro.mp4', '视频文件名不正确');
  Check(FVideoConfig.StartTime = 2000, '视频开始时间不正确');
  Check(FVideoConfig.EndTime = 8000, '视频结束时间不正确');
  
  WriteLn('  视频名称: ', FVideoConfig.Name);
  WriteLn('  视频文件: ', FVideoConfig.VideoFile);
  WriteLn('  持续时间: ', FVideoConfig.Duration, 'ms');
  WriteLn('  开始时间: ', FVideoConfig.StartTime, 'ms');
  WriteLn('  结束时间: ', FVideoConfig.EndTime, 'ms');
  WriteLn('  实际播放: ', (FVideoConfig.EndTime - FVideoConfig.StartTime), 'ms');
end;

procedure TMediaConfigTest.TestMediaDuration;
var
  TotalDuration: Integer;
begin
  WriteLn('测试媒体总时长');
  
  // 计算总时长
  TotalDuration := FImageConfig.Duration + 
                  (FVideoConfig.EndTime - FVideoConfig.StartTime);
  
  // 检查计算结果
  Check(TotalDuration = 11000, '媒体总时长计算错误');
  
  WriteLn('  图像时长: ', FImageConfig.Duration, 'ms');
  WriteLn('  视频时长: ', (FVideoConfig.EndTime - FVideoConfig.StartTime), 'ms');
  WriteLn('  总时长: ', TotalDuration, 'ms');
end;

procedure TMediaConfigTest.Run;
begin
  SetUp;
  try
    WriteLn('执行媒体配置测试: ', TestName);
    
    // 分别测试每个方法
    WriteLn('--- 测试图像配置 ---');
    try
      TestImageConfiguration;
      WriteLn('  图像测试通过');
    except
      on E: Exception do
        WriteLn('  图像测试异常: ', E.Message);
    end;
    
    WriteLn('--- 测试视频配置 ---');
    try
      TestVideoConfiguration;
      WriteLn('  视频测试通过');
    except
      on E: Exception do
        WriteLn('  视频测试异常: ', E.Message);
    end;
    
    WriteLn('--- 测试媒体时长 ---');
    try
      TestMediaDuration;
      WriteLn('  时长测试通过');
    except
      on E: Exception do
        WriteLn('  时长测试异常: ', E.Message);
    end;
  finally
    TearDown;
  end;
end;

var
  Test: TMediaConfigTest;
  Suite: TTestSuite;
  ReportFile: string;
  FailCount: Integer;

begin
  try
    WriteLn('媒体配置测试示例');
    WriteLn('===================================');
    WriteLn('开始执行媒体配置测试...');
    WriteLn;
    
    // 手动创建测试套件并注册
    Suite := TTestSuite.Create('媒体配置测试套件');
    Test := TMediaConfigTest.Create('媒体配置测试');
    Suite.AddTest(Test);
    RegisterTest(Suite);
    
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
      WriteLn('有 ', IntToStr(FailCount), ' 个测试失败，请查看测试报告了解详情。');
  except
    on E: Exception do
      WriteLn('错误：', E.Message);
  end;
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 