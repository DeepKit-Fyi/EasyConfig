unit SystemConfigTests;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  TestFramework, // DUnit娴嬭瘯妗嗘灦
  SystemConfig, INIConfig;

type
  // 鏁版嵁搴撻厤缃祴璇?
  TDatabaseConfigTests = class(TTestCase)
  private
    FDatabaseConfig: TDatabaseConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestConnectionParams;
    procedure TestValidation;
    procedure TestEncryptedPassword;
  end;
  
  // 璺緞閰嶇疆娴嬭瘯
  TPathConfigTests = class(TTestCase)
  private
    FPathConfig: TPathConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestEnsurePaths;
    procedure TestValidation;
  end;
  
  // 鍚姩閰嶇疆娴嬭瘯
  TStartupConfigTests = class(TTestCase)
  private
    FStartupConfig: TStartupConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestDefaultValues;
    procedure TestValidation;
  end;

implementation

{ TDatabaseConfigTests }

procedure TDatabaseConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'DB.connection.test.ini');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\DB.connection.template-001.ini') then
    TFile.Copy('config\DB.connection.template-001.ini', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
      '[Connection]'#13#10 +
      'Server=localhost'#13#10 +
      'Port=1433'#13#10 +
      'Database=TestDB'#13#10 +
      'Username=testuser'#13#10 +
      'Password=ENC(UGFzc3dvcmQxMjM=)'#13#10 +
      #13#10 +
      '[Options]'#13#10 +
      'ConnectionTimeout=30'#13#10 +
      'AutoReconnect=1'#13#10 +
      #13#10 +
      '[Pool]'#13#10 +
      'PoolSize=10'#13#10 +
      'MinPoolSize=5'#13#10 +
      'MaxPoolSize=20'#13#10 +
      'PoolIdleTimeout=60'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FDatabaseConfig := TDatabaseConfig.Create('TEST-DB-001', 'TestDB', FTestFilePath, 'Database');
end;

procedure TDatabaseConfigTests.TearDown;
begin
  // 娓呯悊
  FDatabaseConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TDatabaseConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-DB-001', FDatabaseConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestDB', FDatabaseConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FDatabaseConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('Database', FDatabaseConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals('localhost', FDatabaseConfig.Server, '榛樿鏈嶅姟鍣ㄥ€间笉姝ｇ‘');
  CheckEquals(1433, FDatabaseConfig.Port, '榛樿绔彛鍊间笉姝ｇ‘');
  CheckEquals('TestDB', FDatabaseConfig.DatabaseName, '榛樿鏁版嵁搴撳悕涓嶆纭?);
  CheckEquals('testuser', FDatabaseConfig.Username, '榛樿鐢ㄦ埛鍚嶄笉姝ｇ‘');
  CheckEquals('', FDatabaseConfig.Password, '瀵嗙爜搴旇涓虹┖瀛楃涓诧紝鐩村埌瑙ｅ瘑');
end;

procedure TDatabaseConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FDatabaseConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FDatabaseConfig.Server := 'db.example.com';
  FDatabaseConfig.Port := 5432;
  FDatabaseConfig.DatabaseName := 'NewDB';
  FDatabaseConfig.Username := 'newuser';
  FDatabaseConfig.SetPassword('newpassword');
  FDatabaseConfig.ConnectionTimeout := 60;
  FDatabaseConfig.AutoReconnect := False;
  FDatabaseConfig.PoolSize := 15;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FDatabaseConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TDatabaseConfig.Create('TEST-DB-001', 'TestDB', FTestFilePath, 'Database');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals('db.example.com', NewConfig.Server, '鏈嶅姟鍣ㄥ€间笉鍖归厤');
    CheckEquals(5432, NewConfig.Port, '绔彛鍊间笉鍖归厤');
    CheckEquals('NewDB', NewConfig.DatabaseName, '鏁版嵁搴撳悕涓嶅尮閰?);
    CheckEquals('newuser', NewConfig.Username, '鐢ㄦ埛鍚嶄笉鍖归厤');
    CheckTrue(NewConfig.ValidatePassword('newpassword'), '瀵嗙爜楠岃瘉澶辫触');
    CheckEquals(60, NewConfig.ConnectionTimeout, '杩炴帴瓒呮椂涓嶅尮閰?);
    CheckFalse(NewConfig.AutoReconnect, '鑷姩閲嶈繛鍊间笉鍖归厤');
    CheckEquals(15, NewConfig.PoolSize, '杩炴帴姹犲ぇ灏忎笉鍖归厤');
  finally
    NewConfig.Free;
  end;
end;

procedure TDatabaseConfigTests.TestConnectionParams;
begin
  // 鍔犺浇閰嶇疆
  CheckTrue(FDatabaseConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 娴嬭瘯杩炴帴瀛楃涓茬敓鎴?
  var ConnStr := FDatabaseConfig.GetConnectionString;
  CheckTrue(ConnStr.Contains('Server=localhost'), '杩炴帴瀛楃涓插簲璇ュ寘鍚湇鍔″櫒');
  CheckTrue(ConnStr.Contains('Port=1433'), '杩炴帴瀛楃涓插簲璇ュ寘鍚鍙?);
  CheckTrue(ConnStr.Contains('Database=TestDB'), '杩炴帴瀛楃涓插簲璇ュ寘鍚暟鎹簱鍚?);
  CheckTrue(ConnStr.Contains('User ID=testuser'), '杩炴帴瀛楃涓插簲璇ュ寘鍚敤鎴峰悕');
  CheckTrue(ConnStr.Contains('Password='), '杩炴帴瀛楃涓插簲璇ュ寘鍚瘑鐮佸瓧娈?);
  CheckTrue(ConnStr.Contains('Connection Timeout=30'), '杩炴帴瀛楃涓插簲璇ュ寘鍚秴鏃惰缃?);
  
  // 淇敼鍊煎苟楠岃瘉杩炴帴瀛楃涓插彉鍖?
  FDatabaseConfig.Server := 'newserver';
  FDatabaseConfig.Port := 5555;
  
  ConnStr := FDatabaseConfig.GetConnectionString;
  CheckTrue(ConnStr.Contains('Server=newserver'), '杩炴帴瀛楃涓插簲璇ュ弽鏄犳柊鏈嶅姟鍣?);
  CheckTrue(ConnStr.Contains('Port=5555'), '杩炴帴瀛楃涓插簲璇ュ弽鏄犳柊绔彛');
end;

procedure TDatabaseConfigTests.TestValidation;
begin
  // 鍔犺浇閰嶇疆
  CheckTrue(FDatabaseConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  CheckTrue(FDatabaseConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勬湇鍔″櫒
  FDatabaseConfig.Server := '';
  CheckFalse(FDatabaseConfig.Validate, '绌烘湇鍔″櫒鍚嶅簲璇ュ鑷撮獙璇佸け璐?);
  var Errors := FDatabaseConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  FDatabaseConfig.Server := 'localhost';
  
  // 娴嬭瘯鏃犳晥鐨勭鍙?
  FDatabaseConfig.Port := 0;
  CheckFalse(FDatabaseConfig.Validate, '鏃犳晥绔彛搴旇瀵艰嚧楠岃瘉澶辫触');
  Errors := FDatabaseConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  FDatabaseConfig.Port := 1433;
  
  // 娴嬭瘯鏃犳晥鐨勬暟鎹簱鍚?
  FDatabaseConfig.DatabaseName := '';
  CheckFalse(FDatabaseConfig.Validate, '绌烘暟鎹簱鍚嶅簲璇ュ鑷撮獙璇佸け璐?);
  Errors := FDatabaseConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
end;

procedure TDatabaseConfigTests.TestEncryptedPassword;
const
  TEST_PASSWORD = 'TestPassword123';
begin
  // 娴嬭瘯瀵嗙爜鍔犲瘑鍜岄獙璇?
  FDatabaseConfig.SetPassword(TEST_PASSWORD);
  CheckTrue(FDatabaseConfig.ValidatePassword(TEST_PASSWORD), '瀵嗙爜楠岃瘉搴旇鎴愬姛');
  CheckFalse(FDatabaseConfig.ValidatePassword('WrongPassword'), '閿欒瀵嗙爜楠岃瘉搴旇澶辫触');
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FDatabaseConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TDatabaseConfig.Create('TEST-DB-001', 'TestDB', FTestFilePath, 'Database');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇甯︽湁鍔犲瘑瀵嗙爜鐨勯厤缃簲璇ユ垚鍔?);
    CheckTrue(NewConfig.ValidatePassword(TEST_PASSWORD), '鍔犺浇鍚庡瘑鐮侀獙璇佸簲璇ユ垚鍔?);
  finally
    NewConfig.Free;
  end;
end;

{ TPathConfigTests }

procedure TPathConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'System.paths.test.ini');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\System.paths.template-001.ini') then
    TFile.Copy('config\System.paths.template-001.ini', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
      '[Paths]'#13#10 +
      'LogPath=.\logs'#13#10 +
      'TempPath=.\temp'#13#10 +
      'DataPath=.\data'#13#10 +
      'BackupPath=.\backup'#13#10 +
      'ExportPath=.\export'#13#10 +
      'ResourcePath=.\resources'#13#10 +
      #13#10 +
      '[Options]'#13#10 +
      'CreateIfNotExists=1'#13#10 +
      'ClearTempOnStartup=1'#13#10 +
      'BackupInterval=24'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FPathConfig := TPathConfig.Create('TEST-PATH-001', 'TestPaths', FTestFilePath, 'PathConfig');
end;

procedure TPathConfigTests.TearDown;
begin
  // 娓呯悊
  FPathConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TPathConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-PATH-001', FPathConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestPaths', FPathConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FPathConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('PathConfig', FPathConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals('.\logs', FPathConfig.LogPath, '榛樿鏃ュ織璺緞涓嶆纭?);
  CheckEquals('.\temp', FPathConfig.TempPath, '榛樿涓存椂璺緞涓嶆纭?);
  CheckEquals('.\data', FPathConfig.DataPath, '榛樿鏁版嵁璺緞涓嶆纭?);
  CheckEquals('.\backup', FPathConfig.BackupPath, '榛樿澶囦唤璺緞涓嶆纭?);
  CheckEquals('.\export', FPathConfig.ExportPath, '榛樿瀵煎嚭璺緞涓嶆纭?);
  CheckEquals('.\resources', FPathConfig.ResourcePath, '榛樿璧勬簮璺緞涓嶆纭?);
  CheckTrue(FPathConfig.CreateIfNotExists, '榛樿搴旇鍒涘缓鐩綍');
  CheckTrue(FPathConfig.ClearTempOnStartup, '榛樿搴旇娓呯悊涓存椂鐩綍');
  CheckEquals(24, FPathConfig.BackupInterval, '榛樿澶囦唤闂撮殧涓嶆纭?);
end;

procedure TPathConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FPathConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FPathConfig.LogPath := 'C:\Logs';
  FPathConfig.TempPath := 'C:\Temp';
  FPathConfig.DataPath := 'C:\Data';
  FPathConfig.BackupPath := 'C:\Backup';
  FPathConfig.ExportPath := 'C:\Export';
  FPathConfig.ResourcePath := 'C:\Resources';
  FPathConfig.CreateIfNotExists := False;
  FPathConfig.ClearTempOnStartup := False;
  FPathConfig.BackupInterval := 12;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FPathConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TPathConfig.Create('TEST-PATH-001', 'TestPaths', FTestFilePath, 'PathConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals('C:\Logs', NewConfig.LogPath, '鏃ュ織璺緞涓嶅尮閰?);
    CheckEquals('C:\Temp', NewConfig.TempPath, '涓存椂璺緞涓嶅尮閰?);
    CheckEquals('C:\Data', NewConfig.DataPath, '鏁版嵁璺緞涓嶅尮閰?);
    CheckEquals('C:\Backup', NewConfig.BackupPath, '澶囦唤璺緞涓嶅尮閰?);
    CheckEquals('C:\Export', NewConfig.ExportPath, '瀵煎嚭璺緞涓嶅尮閰?);
    CheckEquals('C:\Resources', NewConfig.ResourcePath, '璧勬簮璺緞涓嶅尮閰?);
    CheckFalse(NewConfig.CreateIfNotExists, '鍒涘缓鐩綍閫夐」涓嶅尮閰?);
    CheckFalse(NewConfig.ClearTempOnStartup, '娓呯悊涓存椂鐩綍閫夐」涓嶅尮閰?);
    CheckEquals(12, NewConfig.BackupInterval, '澶囦唤闂撮殧涓嶅尮閰?);
  finally
    NewConfig.Free;
  end;
end;

procedure TPathConfigTests.TestEnsurePaths;
begin
  // 璁剧疆娴嬭瘯璺緞
  var BasePath := TPath.Combine(TPath.GetTempPath, 'ConfigTest');
  
  try
    // 鍒犻櫎鍙兘瀛樺湪鐨勬祴璇曠洰褰?
    if TDirectory.Exists(BasePath) then
      TDirectory.Delete(BasePath, True);
      
    // 璁剧疆鐩稿璺緞
    FPathConfig.LogPath := TPath.Combine(BasePath, 'logs');
    FPathConfig.TempPath := TPath.Combine(BasePath, 'temp');
    FPathConfig.DataPath := TPath.Combine(BasePath, 'data');
    FPathConfig.BackupPath := TPath.Combine(BasePath, 'backup');
    FPathConfig.ExportPath := TPath.Combine(BasePath, 'export');
    FPathConfig.ResourcePath := TPath.Combine(BasePath, 'resources');
    FPathConfig.CreateIfNotExists := True;
    
    // 纭繚璺緞瀛樺湪
    FPathConfig.EnsurePathsExist;
    
    // 妫€鏌ユ槸鍚﹀垱寤轰簡鐩綍
    CheckTrue(TDirectory.Exists(FPathConfig.LogPath), '搴旇鍒涘缓鏃ュ織鐩綍');
    CheckTrue(TDirectory.Exists(FPathConfig.TempPath), '搴旇鍒涘缓涓存椂鐩綍');
    CheckTrue(TDirectory.Exists(FPathConfig.DataPath), '搴旇鍒涘缓鏁版嵁鐩綍');
    CheckTrue(TDirectory.Exists(FPathConfig.BackupPath), '搴旇鍒涘缓澶囦唤鐩綍');
    CheckTrue(TDirectory.Exists(FPathConfig.ExportPath), '搴旇鍒涘缓瀵煎嚭鐩綍');
    CheckTrue(TDirectory.Exists(FPathConfig.ResourcePath), '搴旇鍒涘缓璧勬簮鐩綍');
    
    // 娴嬭瘯娓呯悊涓存椂鐩綍
    // 鍒涘缓涓€涓复鏃舵枃浠?
    var TempFilePath := TPath.Combine(FPathConfig.TempPath, 'test.tmp');
    TFile.WriteAllText(TempFilePath, 'Test');
    CheckTrue(TFile.Exists(TempFilePath), '娴嬭瘯鏂囦欢搴旇瀛樺湪');
    
    // 娓呯悊涓存椂鐩綍
    FPathConfig.ClearTempDirectory;
    
    // 妫€鏌ユ枃浠舵槸鍚﹁鍒犻櫎
    CheckFalse(TFile.Exists(TempFilePath), '娴嬭瘯鏂囦欢搴旇琚垹闄?);
  finally
    // 娓呯悊
    if TDirectory.Exists(BasePath) then
      TDirectory.Delete(BasePath, True);
  end;
end;

procedure TPathConfigTests.TestValidation;
begin
  // 鍔犺浇閰嶇疆
  CheckTrue(FPathConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  CheckTrue(FPathConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勮矾寰?
  FPathConfig.LogPath := '|invalid|path';
  CheckFalse(FPathConfig.Validate, '鏃犳晥璺緞搴旇瀵艰嚧楠岃瘉澶辫触');
  var Errors := FPathConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  
  // 鎭㈠鏈夋晥璺緞
  FPathConfig.LogPath := '.\logs';
  CheckTrue(FPathConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勫浠介棿闅?
  FPathConfig.BackupInterval := -1;
  CheckFalse(FPathConfig.Validate, '鏃犳晥鐨勫浠介棿闅斿簲璇ュ鑷撮獙璇佸け璐?);
  Errors := FPathConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
end;

{ TStartupConfigTests }

procedure TStartupConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'System.startup.test.ini');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\System.startup.template-001.ini') then
    TFile.Copy('config\System.startup.template-001.ini', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
      '[Application]'#13#10 +
      'AppName=ConfigManager'#13#10 +
      'ShowSplash=1'#13#10 +
      #13#10 +
      '[Security]'#13#10 +
      'AutoLogin=0'#13#10 +
      'DefaultUser='#13#10 +
      'DefaultPassword='#13#10 +
      #13#10 +
      '[Localization]'#13#10 +
      'Language=zh-CN'#13#10 +
      #13#10 +
      '[Logging]'#13#10 +
      'LogLevel=3'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FStartupConfig := TStartupConfig.Create('TEST-STARTUP-001', 'TestStartup', FTestFilePath, 'StartupConfig');
end;

procedure TStartupConfigTests.TearDown;
begin
  // 娓呯悊
  FStartupConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TStartupConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-STARTUP-001', FStartupConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestStartup', FStartupConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FStartupConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('StartupConfig', FStartupConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals('ConfigManager', FStartupConfig.AppName, '榛樿搴旂敤鍚嶇О涓嶆纭?);
  CheckTrue(FStartupConfig.ShowSplash, '榛樿搴旇鏄剧ず鍚姩鐢婚潰');
  CheckFalse(FStartupConfig.AutoLogin, '榛樿涓嶅簲璇ヨ嚜鍔ㄧ櫥褰?);
  CheckEquals('', FStartupConfig.DefaultUser, '榛樿鐢ㄦ埛搴旇涓虹┖');
  CheckEquals('', FStartupConfig.DefaultPassword, '榛樿瀵嗙爜搴旇涓虹┖');
  CheckEquals('zh-CN', FStartupConfig.Language, '榛樿璇█涓嶆纭?);
  CheckEquals(3, FStartupConfig.LogLevel, '榛樿鏃ュ織绾у埆涓嶆纭?);
end;

procedure TStartupConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FStartupConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FStartupConfig.AppName := 'TestApplication';
  FStartupConfig.ShowSplash := False;
  FStartupConfig.AutoLogin := True;
  FStartupConfig.DefaultUser := 'admin';
  FStartupConfig.DefaultPassword := 'encrypted_password';
  FStartupConfig.Language := 'en-US';
  FStartupConfig.LogLevel := 5;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FStartupConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TStartupConfig.Create('TEST-STARTUP-001', 'TestStartup', FTestFilePath, 'StartupConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals('TestApplication', NewConfig.AppName, '搴旂敤鍚嶇О涓嶅尮閰?);
    CheckFalse(NewConfig.ShowSplash, '鏄剧ず鍚姩鐢婚潰閫夐」涓嶅尮閰?);
    CheckTrue(NewConfig.AutoLogin, '鑷姩鐧诲綍閫夐」涓嶅尮閰?);
    CheckEquals('admin', NewConfig.DefaultUser, '榛樿鐢ㄦ埛涓嶅尮閰?);
    CheckEquals('encrypted_password', NewConfig.DefaultPassword, '榛樿瀵嗙爜涓嶅尮閰?);
    CheckEquals('en-US', NewConfig.Language, '璇█涓嶅尮閰?);
    CheckEquals(5, NewConfig.LogLevel, '鏃ュ織绾у埆涓嶅尮閰?);
  finally
    NewConfig.Free;
  end;
end;

procedure TStartupConfigTests.TestDefaultValues;
begin
  // 涓嶅姞杞介厤缃紝娴嬭瘯榛樿鍊?
  var DefaultConfig := TStartupConfig.Create('DEFAULT', 'Default', 'nonexistent.ini', 'StartupConfig');
  try
    // 榛樿鍊煎簲璇ュ湪鏋勯€犲嚱鏁颁腑璁剧疆
    CheckEquals('ConfigManager', DefaultConfig.AppName, '榛樿搴旂敤鍚嶇О涓嶆纭?);
    CheckTrue(DefaultConfig.ShowSplash, '榛樿搴旇鏄剧ず鍚姩鐢婚潰');
    CheckFalse(DefaultConfig.AutoLogin, '榛樿涓嶅簲璇ヨ嚜鍔ㄧ櫥褰?);
    CheckEquals('', DefaultConfig.DefaultUser, '榛樿鐢ㄦ埛搴旇涓虹┖');
    CheckEquals('', DefaultConfig.DefaultPassword, '榛樿瀵嗙爜搴旇涓虹┖');
    CheckEquals('zh-CN', DefaultConfig.Language, '榛樿璇█涓嶆纭?);
    CheckEquals(3, DefaultConfig.LogLevel, '榛樿鏃ュ織绾у埆涓嶆纭?);
  finally
    DefaultConfig.Free;
  end;
end;

procedure TStartupConfigTests.TestValidation;
begin
  // 鍔犺浇閰嶇疆
  CheckTrue(FStartupConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  CheckTrue(FStartupConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勫簲鐢ㄥ悕绉?
  FStartupConfig.AppName := '';
  CheckFalse(FStartupConfig.Validate, '绌哄簲鐢ㄥ悕绉板簲璇ュ鑷撮獙璇佸け璐?);
  var Errors := FStartupConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  
  // 鎭㈠鏈夋晥鐨勫簲鐢ㄥ悕绉?
  FStartupConfig.AppName := 'ConfigManager';
  CheckTrue(FStartupConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勬棩蹇楃骇鍒?
  FStartupConfig.LogLevel := -1;
  CheckFalse(FStartupConfig.Validate, '鏃犳晥鐨勬棩蹇楃骇鍒簲璇ュ鑷撮獙璇佸け璐?);
  Errors := FStartupConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  
  // 鎭㈠鏈夋晥鐨勬棩蹇楃骇鍒?
  FStartupConfig.LogLevel := 3;
  CheckTrue(FStartupConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鑷姩鐧诲綍浣嗙己灏戠敤鎴峰悕
  FStartupConfig.AutoLogin := True;
  FStartupConfig.DefaultUser := '';
  CheckFalse(FStartupConfig.Validate, '鑷姩鐧诲綍浣嗘棤鐢ㄦ埛鍚嶅簲璇ュ鑷撮獙璇佸け璐?);
  Errors := FStartupConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
end;

initialization
  // 娉ㄥ唽娴嬭瘯
  RegisterTest(TDatabaseConfigTests.Suite);
  RegisterTest(TPathConfigTests.Suite);
  RegisterTest(TStartupConfigTests.Suite);
end. 