unit ConfigManagerTests;

interface

uses
  System.SysUtils, System.Classes, TestFramework, 
  ConfigManager, BaseConfig, ConfigTypes, ConfigRegistry;

type
  { 閰嶇疆绠＄悊鍣ㄦ祴璇?}
  TConfigManagerTests = class(TTestCase)
  private
    FConfigManager: TConfigManager;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestCreate;
    procedure TestConfigPath;
    procedure TestConfigRegistration;
    procedure Run; override;
  end;

implementation

{ TConfigManagerTests }

constructor TConfigManagerTests.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TConfigManagerTests.SetUp;
begin
  WriteLn('璁剧疆閰嶇疆绠＄悊鍣ㄦ祴璇曠幆澧?);
  FConfigManager := TConfigManager.Create('test_config');
end;

procedure TConfigManagerTests.TearDown;
begin
  WriteLn('娓呯悊閰嶇疆绠＄悊鍣ㄦ祴璇曠幆澧?);
  FConfigManager.Free;
end;

procedure TConfigManagerTests.TestCreate;
begin
  WriteLn('娴嬭瘯閰嶇疆绠＄悊鍣ㄥ垱寤?);
  
  CheckNotNull(FConfigManager, '鍒涘缓閰嶇疆绠＄悊鍣ㄥけ璐?);
  CheckNotNull(FConfigManager.ConfigRegistry, '閰嶇疆娉ㄥ唽琛ㄦ湭鍒涘缓');
end;

procedure TConfigManagerTests.TestConfigPath;
begin
  WriteLn('娴嬭瘯閰嶇疆璺緞');
  
  CheckEquals('test_config', FConfigManager.ConfigRoot, '閰嶇疆鏍圭洰褰曚笉鍖归厤');
end;

procedure TConfigManagerTests.TestConfigRegistration;
begin
  WriteLn('娴嬭瘯閰嶇疆绫诲瀷娉ㄥ唽');
  
  // 娉ㄥ唽涓€涓祴璇曢厤缃被鍨?
  var Meta: TConfigObjectMeta;
  Meta.Description := '娴嬭瘯閰嶇疆';
  Meta.DefaultFormat := cfJSON;
  FConfigManager.RegisterConfigType('TEST', TConfigObject, Meta);
  
  // 楠岃瘉娉ㄥ唽鎴愬姛
  CheckTrue(FConfigManager.ConfigRegistry.IsTypeRegistered('TEST'), 
            '閰嶇疆绫诲瀷娉ㄥ唽澶辫触');
end;

procedure TConfigManagerTests.Run;
begin
  SetUp;
  try
    WriteLn('鎵ц閰嶇疆绠＄悊鍣ㄦ祴璇? ', TestName);
    TestCreate;
    TestConfigPath;
    TestConfigRegistration;
  finally
    TearDown;
  end;
end;

initialization
  RegisterTestSuite(TConfigManagerTests, '閰嶇疆绠＄悊鍣ㄦ祴璇?);
end. 