program SimpleConfigTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes,
  ConfigManager, BaseConfig, ConfigTypes;

var
  ConfigMgr: TConfigManager;
  Meta: TConfigObjectMeta;
  TestResult: Boolean;

procedure TestConfigManager;
begin
  WriteLn('===== 测试配置管理器 =====');
  
  // 创建配置管理器
  ConfigMgr := TConfigManager.Create('test_config');
  try
    WriteLn('配置管理器创建成功');
    
    // 测试配置路径
    WriteLn('配置路径: ', ConfigMgr.ConfigRoot);
    if ConfigMgr.ConfigRoot = 'test_config' then
      WriteLn('配置路径测试通过')
    else
      WriteLn('配置路径测试失败');
      
    // 测试配置类型注册
    Meta.Description := '测试配置';
    Meta.DefaultFormat := cfJSON;
    ConfigMgr.RegisterConfigType('TEST', TConfigObject, Meta);
    
    // 验证注册成功
    if ConfigMgr.ConfigRegistry.IsTypeRegistered('TEST') then
      WriteLn('配置类型注册测试通过')
    else
      WriteLn('配置类型注册测试失败');
    
    WriteLn('配置管理器测试完成');
  finally
    ConfigMgr.Free;
  end;
end;

begin
  try
    WriteLn('配置管理系统简单测试程序');
    WriteLn('===================================');
    
    TestConfigManager;
    
    WriteLn;
    WriteLn('所有测试完成');
  except
    on E: Exception do
    begin
      WriteLn('测试过程中发生错误: ', E.Message);
      WriteLn('错误类型: ', E.ClassName);
    end;
  end;
  
  WriteLn;
  WriteLn('按任意键退出...');
  ReadLn;
end. 