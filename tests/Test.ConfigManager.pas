unit Test.ConfigManager;

{*******************************************************************************
  ConfigManager 属性测试
  
  Property 1: 配置加载/保存 Round-Trip
  *For any* 有效的 INI+JSON 配置对，执行 OpenProject 加载后再执行 SaveProject 保存，
  重新加载后的配置数据应与原始数据完全一致。
  
  **Validates: Requirements 1.1, 1.3, 6.3**
*******************************************************************************}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils,
  DUnitX.TestFramework,
  ConfigManager;

type
  [TestFixture]
  TConfigManagerTests = class
  private
    FTestDir: string;
    FConfigManager: TConfigManager;
    
    function CreateTestINIContent(const JSONFileName: string; 
      const Sections: array of string; const Keys: array of string): string;
    function CreateTestJSONContent(const Objects: array of string): string;
    procedure CreateTestFiles(const INIPath, JSONPath, INIContent, JSONContent: string);
    procedure CleanupTestFiles;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    // ========== Property 1: Round-Trip 测试 ==========
    
    [Test]
    [TestCase('EmptyConfig', '')]
    procedure Test_RoundTrip_EmptyConfig;
    
    [Test]
    procedure Test_RoundTrip_SimpleINIValues;
    
    [Test]
    procedure Test_RoundTrip_JSONObjects;
    
    [Test]
    procedure Test_RoundTrip_ComplexConfig;
    
    // ========== OpenProject 测试 ==========
    
    [Test]
    procedure Test_OpenProject_ParsesJsonFileSection;
    
    [Test]
    procedure Test_OpenProject_CreatesEmptyJSONIfNotExists;
    
    [Test]
    procedure Test_OpenProject_SupportsRelativePath;
    
    [Test]
    procedure Test_OpenProject_SupportsAbsolutePath;
    
    // ========== SaveProject 测试 ==========
    
    [Test]
    procedure Test_SaveProject_CreatesBackup;
    
    [Test]
    procedure Test_SaveProject_WritesJSONBeforeINI;
    
    // ========== NewProject 测试 ==========
    
    [Test]
    procedure Test_NewProject_CreatesEmptyFiles;
    
    [Test]
    procedure Test_NewProject_SetsJsonFileSection;
    
    // ========== Property 7: 修改状态正确性测试 ==========
    
    [Test]
    procedure Test_IsModified_TrueAfterChange;
    
    [Test]
    procedure Test_IsModified_FalseAfterSave;
    
    [Test]
    procedure Test_IsModified_FalseAfterOpen;
  end;

implementation

{ TConfigManagerTests }

procedure TConfigManagerTests.Setup;
begin
  FTestDir := TPath.Combine(TPath.GetTempPath, 'ConfigManagerTests_' + 
    FormatDateTime('yyyymmddhhnnsszzz', Now));
  TDirectory.CreateDirectory(FTestDir);
  FConfigManager := TConfigManager.Create;
end;

procedure TConfigManagerTests.TearDown;
begin
  FConfigManager.Free;
  CleanupTestFiles;
end;

procedure TConfigManagerTests.CleanupTestFiles;
begin
  if TDirectory.Exists(FTestDir) then
    TDirectory.Delete(FTestDir, True);
end;

function TConfigManagerTests.CreateTestINIContent(const JSONFileName: string;
  const Sections: array of string; const Keys: array of string): string;
var
  SB: TStringBuilder;
  I: Integer;
begin
  SB := TStringBuilder.Create;
  try
    // json_file 节
    SB.AppendLine('[json_file]');
    SB.AppendLine('file_path=' + JSONFileName);
    SB.AppendLine;
    
    // 其他节
    for I := 0 to High(Sections) do
    begin
      SB.AppendLine('[' + Sections[I] + ']');
      if I <= High(Keys) then
        SB.AppendLine(Keys[I]);
      SB.AppendLine;
    end;
    
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function TConfigManagerTests.CreateTestJSONContent(const Objects: array of string): string;
var
  SB: TStringBuilder;
  I: Integer;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('{');
    for I := 0 to High(Objects) do
    begin
      if I > 0 then
        SB.Append(',');
      SB.Append(Objects[I]);
    end;
    SB.Append('}');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

procedure TConfigManagerTests.CreateTestFiles(const INIPath, JSONPath, 
  INIContent, JSONContent: string);
begin
  TFile.WriteAllText(INIPath, INIContent, TEncoding.UTF8);
  TFile.WriteAllText(JSONPath, JSONContent, TEncoding.UTF8);
end;

// ========== Property 1: Round-Trip 测试 ==========

procedure TConfigManagerTests.Test_RoundTrip_EmptyConfig;
var
  INIPath, JSONPath: string;
  OriginalINI, OriginalJSON: string;
  LoadedINI, LoadedJSON: string;
begin
  // Arrange: 创建空配置
  INIPath := TPath.Combine(FTestDir, 'empty.ini');
  JSONPath := TPath.Combine(FTestDir, 'empty.json');
  OriginalINI := CreateTestINIContent('empty.json', [], []);
  OriginalJSON := '{}';
  CreateTestFiles(INIPath, JSONPath, OriginalINI, OriginalJSON);
  
  // Act: 加载 -> 保存 -> 重新加载
  Assert.IsTrue(FConfigManager.OpenProject(INIPath), 'OpenProject should succeed');
  Assert.IsTrue(FConfigManager.SaveProject, 'SaveProject should succeed');
  
  // Assert: 文件内容应该保持一致
  LoadedINI := TFile.ReadAllText(INIPath, TEncoding.UTF8);
  LoadedJSON := TFile.ReadAllText(JSONPath, TEncoding.UTF8);
  
  Assert.Contains(LoadedINI, '[json_file]', 'INI should contain json_file section');
  Assert.Contains(LoadedINI, 'file_path=empty.json', 'INI should contain file_path');
end;

procedure TConfigManagerTests.Test_RoundTrip_SimpleINIValues;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'simple.ini');
  JSONPath := TPath.Combine(FTestDir, 'simple.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('simple.json', 
      ['app_settings', 'ui_settings'],
      ['app_name=TestApp' + sLineBreak + 'debug_mode=true', 
       'theme=dark' + sLineBreak + 'language=zh-CN']),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: 验证 INI 值正确加载
  Assert.AreEqual('TestApp', FConfigManager.GetINIValue('app_settings', 'app_name'));
  Assert.AreEqual('true', FConfigManager.GetINIValue('app_settings', 'debug_mode'));
  Assert.AreEqual('dark', FConfigManager.GetINIValue('ui_settings', 'theme'));
  
  // Act: 修改并保存
  FConfigManager.SetINIValue('app_settings', 'app_name', 'ModifiedApp');
  Assert.IsTrue(FConfigManager.SaveProject);
  
  // Act: 重新加载
  FConfigManager.CloseProject;
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: 修改应该被保留
  Assert.AreEqual('ModifiedApp', FConfigManager.GetINIValue('app_settings', 'app_name'));
end;

procedure TConfigManagerTests.Test_RoundTrip_JSONObjects;
var
  INIPath, JSONPath: string;
  JSONObj: TJSONObject;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'json_test.ini');
  JSONPath := TPath.Combine(FTestDir, 'json_test.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('json_test.json', [], []),
    '{"fonts": {"_id": "font_main", "_type": "Font", "family": "Arial", "size": 12}}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: 验证 JSON 对象正确加载
  JSONObj := FConfigManager.GetJSONObject('fonts');
  Assert.IsNotNull(JSONObj, 'fonts object should exist');
  Assert.AreEqual('font_main', JSONObj.GetValue<string>('_id'));
  Assert.AreEqual('Font', JSONObj.GetValue<string>('_type'));
  Assert.AreEqual('Arial', JSONObj.GetValue<string>('family'));
  
  // Act: 保存并重新加载
  Assert.IsTrue(FConfigManager.SaveProject);
  FConfigManager.CloseProject;
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: JSON 数据应该保持一致
  JSONObj := FConfigManager.GetJSONObject('fonts');
  Assert.IsNotNull(JSONObj);
  Assert.AreEqual('font_main', JSONObj.GetValue<string>('_id'));
end;

procedure TConfigManagerTests.Test_RoundTrip_ComplexConfig;
var
  INIPath, JSONPath: string;
  ComplexJSON: string;
begin
  // Arrange: 创建包含多种类型的复杂配置
  INIPath := TPath.Combine(FTestDir, 'complex.ini');
  JSONPath := TPath.Combine(FTestDir, 'complex.json');
  
  ComplexJSON := '{' +
    '"fonts": {"_id": "font_main", "_type": "Font", "family": "Segoe UI", "size": 14},' +
    '"database": {"_id": "db_default", "_type": "Database", "host": "localhost", "port": 5432},' +
    '"videos": [' +
      '{"_id": "clip1", "_type": "VideoClip", "file": "intro.mp4", "start_sec": 0},' +
      '{"_id": "clip2", "_type": "VideoClip", "file": "outro.mp4", "start_sec": 10}' +
    ']' +
  '}';
  
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('complex.json', 
      ['app_settings'], ['version=1.0' + sLineBreak + 'enabled=true']),
    ComplexJSON);
  
  // Act: 加载 -> 保存 -> 重新加载
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  Assert.IsTrue(FConfigManager.SaveProject);
  FConfigManager.CloseProject;
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: 所有数据应该保持一致
  Assert.AreEqual('1.0', FConfigManager.GetINIValue('app_settings', 'version'));
  Assert.IsNotNull(FConfigManager.GetJSONObject('fonts'));
  Assert.IsNotNull(FConfigManager.GetJSONObject('database'));
end;

// ========== OpenProject 测试 ==========

procedure TConfigManagerTests.Test_OpenProject_ParsesJsonFileSection;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'parse_test.ini');
  JSONPath := TPath.Combine(FTestDir, 'custom_name.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('custom_name.json', [], []),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert
  Assert.AreEqual(JSONPath, FConfigManager.GetCurrentJsonPath);
end;

procedure TConfigManagerTests.Test_OpenProject_CreatesEmptyJSONIfNotExists;
var
  INIPath, JSONPath: string;
begin
  // Arrange: 只创建 INI 文件，不创建 JSON
  INIPath := TPath.Combine(FTestDir, 'no_json.ini');
  JSONPath := TPath.Combine(FTestDir, 'no_json.json');
  TFile.WriteAllText(INIPath, CreateTestINIContent('no_json.json', [], []), TEncoding.UTF8);
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert: JSON 文件应该被创建
  Assert.IsTrue(TFile.Exists(JSONPath), 'JSON file should be created');
end;

procedure TConfigManagerTests.Test_OpenProject_SupportsRelativePath;
var
  INIPath, JSONPath: string;
  SubDir: string;
begin
  // Arrange: JSON 文件在子目录中
  SubDir := TPath.Combine(FTestDir, 'subdir');
  TDirectory.CreateDirectory(SubDir);
  
  INIPath := TPath.Combine(FTestDir, 'relative.ini');
  JSONPath := TPath.Combine(SubDir, 'config.json');
  
  TFile.WriteAllText(INIPath, 
    '[json_file]' + sLineBreak + 'file_path=subdir/config.json', TEncoding.UTF8);
  TFile.WriteAllText(JSONPath, '{}', TEncoding.UTF8);
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert
  Assert.AreEqual(JSONPath, FConfigManager.GetCurrentJsonPath);
end;

procedure TConfigManagerTests.Test_OpenProject_SupportsAbsolutePath;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'absolute.ini');
  JSONPath := TPath.Combine(FTestDir, 'absolute_target.json');
  
  TFile.WriteAllText(INIPath, 
    '[json_file]' + sLineBreak + 'file_path=' + JSONPath, TEncoding.UTF8);
  TFile.WriteAllText(JSONPath, '{}', TEncoding.UTF8);
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert
  Assert.AreEqual(JSONPath, FConfigManager.GetCurrentJsonPath);
end;

// ========== SaveProject 测试 ==========

procedure TConfigManagerTests.Test_SaveProject_CreatesBackup;
var
  INIPath, JSONPath, BackupDir: string;
  BackupFiles: TArray<string>;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'backup_test.ini');
  JSONPath := TPath.Combine(FTestDir, 'backup_test.json');
  BackupDir := TPath.Combine(FTestDir, 'backup');
  
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('backup_test.json', [], []),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  FConfigManager.SetINIValue('test', 'key', 'value');
  Assert.IsTrue(FConfigManager.SaveProject);
  
  // Assert: 备份目录应该存在且包含备份文件
  Assert.IsTrue(TDirectory.Exists(BackupDir), 'Backup directory should exist');
  BackupFiles := TDirectory.GetFiles(BackupDir, '*.bak');
  Assert.IsTrue(Length(BackupFiles) >= 1, 'Should have at least one backup file');
end;

procedure TConfigManagerTests.Test_SaveProject_WritesJSONBeforeINI;
var
  INIPath, JSONPath: string;
  INITime, JSONTime: TDateTime;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'order_test.ini');
  JSONPath := TPath.Combine(FTestDir, 'order_test.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('order_test.json', [], []),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  FConfigManager.SetINIValue('test', 'key', 'value');
  Assert.IsTrue(FConfigManager.SaveProject);
  
  // Assert: 两个文件都应该被更新
  Assert.IsTrue(TFile.Exists(INIPath));
  Assert.IsTrue(TFile.Exists(JSONPath));
end;

// ========== NewProject 测试 ==========

procedure TConfigManagerTests.Test_NewProject_CreatesEmptyFiles;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'new_project.ini');
  JSONPath := TPath.Combine(FTestDir, 'new_project.json');
  
  // Act
  Assert.IsTrue(FConfigManager.NewProject(INIPath));
  
  // Assert
  Assert.IsTrue(TFile.Exists(INIPath), 'INI file should be created');
  Assert.IsTrue(TFile.Exists(JSONPath), 'JSON file should be created');
end;

procedure TConfigManagerTests.Test_NewProject_SetsJsonFileSection;
var
  INIPath: string;
  INIContent: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'new_with_section.ini');
  
  // Act
  Assert.IsTrue(FConfigManager.NewProject(INIPath));
  
  // Assert
  INIContent := TFile.ReadAllText(INIPath, TEncoding.UTF8);
  Assert.Contains(INIContent, '[json_file]');
  Assert.Contains(INIContent, 'file_path=new_with_section.json');
end;

// ========== Property 7: 修改状态正确性测试 ==========
// **Validates: Requirements 8.2, 8.3**

procedure TConfigManagerTests.Test_IsModified_TrueAfterChange;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'modified_test.ini');
  JSONPath := TPath.Combine(FTestDir, 'modified_test.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('modified_test.json', ['app'], ['key=value']),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  Assert.IsFalse(FConfigManager.IsModified, 'Should not be modified after open');
  
  FConfigManager.SetINIValue('app', 'key', 'new_value');
  
  // Assert
  Assert.IsTrue(FConfigManager.IsModified, 'Should be modified after change');
end;

procedure TConfigManagerTests.Test_IsModified_FalseAfterSave;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'save_modified.ini');
  JSONPath := TPath.Combine(FTestDir, 'save_modified.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('save_modified.json', ['app'], ['key=value']),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  FConfigManager.SetINIValue('app', 'key', 'new_value');
  Assert.IsTrue(FConfigManager.IsModified, 'Should be modified before save');
  
  Assert.IsTrue(FConfigManager.SaveProject);
  
  // Assert
  Assert.IsFalse(FConfigManager.IsModified, 'Should not be modified after save');
end;

procedure TConfigManagerTests.Test_IsModified_FalseAfterOpen;
var
  INIPath, JSONPath: string;
begin
  // Arrange
  INIPath := TPath.Combine(FTestDir, 'open_modified.ini');
  JSONPath := TPath.Combine(FTestDir, 'open_modified.json');
  CreateTestFiles(INIPath, JSONPath,
    CreateTestINIContent('open_modified.json', ['app'], ['key=value']),
    '{}');
  
  // Act
  Assert.IsTrue(FConfigManager.OpenProject(INIPath));
  
  // Assert
  Assert.IsFalse(FConfigManager.IsModified, 'Should not be modified after open');
end;

initialization
  TDUnitX.RegisterTestFixture(TConfigManagerTests);

end.
