unit ConfigManager;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.JSON, JSONHelpers, 
  System.Generics.Collections, System.IOUtils, System.DateUtils,
  INIConfig, JSONConfig, UtilsTypesFMX;

type
  /// <summary>
  /// 配置管理器 - 负责 INI + JSON 双文件配置的加载、保存和一致性维护
  /// </summary>
  TConfigManager = class
  private
    FINIConfig: TLegacyINIConfig;
    FJSONConfig: TJSONConfig;
    FINIFilePath: string;
    FJSONFilePath: string;
    FIsModified: Boolean;
    FOnModified: TNotifyEvent;
    FOnProjectLoaded: TNotifyEvent;
    FBackupDir: string;
    
    function GetJSONPathFromINI(const INIPath: string): string;
    function ResolveJSONPath(const INIPath, JSONRelPath: string): string;
    procedure SetIsModified(const Value: Boolean);
    procedure DoModified;
    procedure DoProjectLoaded;
    function CreateBackup(const FilePath: string): Boolean;
    function SaveToTempAndRename(const FilePath, Content: string): Boolean;
    function EnsureDirectoryExists(const DirPath: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    
    // ========== 工程管理 ==========
    /// <summary>打开配置工程，解析 INI 的 [json_file] 节并加载关联 JSON</summary>
    function OpenProject(const AIniPath: string): Boolean;
    /// <summary>保存配置工程，先写 JSON 再写 INI，生成备份</summary>
    function SaveProject: Boolean;
    /// <summary>另存为新文件</summary>
    function SaveProjectAs(const ANewIniPath: string): Boolean;
    /// <summary>新建工程，创建空白 INI+JSON 对</summary>
    function NewProject(const AIniPath: string): Boolean;
    /// <summary>关闭当前工程</summary>
    procedure CloseProject;
    
    // ========== 状态查询 ==========
    function GetCurrentIniPath: string;
    function GetCurrentJsonPath: string;
    function HasProject: Boolean;
    
    // 加载配置文件
    function LoadFromFile(const INIFilePath: string): Boolean;
    // 保存配置文件
    function SaveToFile: Boolean;
    // 保存为新文件
    function SaveAsNewFile(const NewINIFilePath: string): Boolean;
    
    // 获取INI配置中的所有节
    function GetINISections: TArray<string>;
    // 获取指定节中的所有键
    function GetINIKeys(const Section: string): TArray<string>;
    // 获取INI配置值
    function GetINIValue(const Section, Key: string): string;
    // 设置INI配置值
    procedure SetINIValue(const Section, Key, Value: string);
    
    // 获取JSON配置中的所有顶级键
    function GetJSONRootKeys: TArray<string>;
    // 获取JSON对象的子键
    function GetJSONChildKeys(const JSONPath: string): TArray<string>;
    // 获取JSON对象
    function GetJSONObject(const JSONPath: string): TJSONObject;
    // 创建或更新JSON对象
    procedure SetJSONObject(const JSONPath: string; JSONObj: TJSONObject);
    
    // 添加新的INI配置项
    procedure AddINIConfigItem(const Section, Key, DefaultValue: string; ConfigType: TConfigType);
    // 删除INI配置项
    procedure DeleteINIConfigItem(const Section, Key: string);
    
    // 添加新的JSON配置项
    procedure AddJSONConfigItem(const ParentPath, Name: string; JSONObj: TJSONObject);
    // 删除JSON配置项
    procedure DeleteJSONConfigItem(const JSONPath: string);
    
    // 查找引用的对象
    function FindReferenceObject(const RefID: string): TJSONObject;
    
    property INIFilePath: string read FINIFilePath;
    property JSONFilePath: string read FJSONFilePath;
    property IsModified: Boolean read FIsModified write SetIsModified;
    property INIConfig: TLegacyINIConfig read FINIConfig;
    property JSONConfig: TJSONConfig read FJSONConfig;
    
    // ========== 事件 ==========
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property OnProjectLoaded: TNotifyEvent read FOnProjectLoaded write FOnProjectLoaded;
    property BackupDir: string read FBackupDir write FBackupDir;
  end;

implementation

const
  JSON_FILE_SECTION = 'json_file';
  JSON_FILE_PATH_KEY = 'file_path';
  DEFAULT_BACKUP_SUBDIR = 'backup';

{ TConfigManager }

constructor TConfigManager.Create;
begin
  inherited Create;
  FINIConfig := TLegacyINIConfig.Create;
  FJSONConfig := TJSONConfig.Create;
  FIsModified := False;
  FBackupDir := '';
end;

destructor TConfigManager.Destroy;
begin
  FINIConfig.Free;
  FJSONConfig.Free;
  inherited;
end;

procedure TConfigManager.DoModified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TConfigManager.DoProjectLoaded;
begin
  if Assigned(FOnProjectLoaded) then
    FOnProjectLoaded(Self);
end;

function TConfigManager.GetCurrentIniPath: string;
begin
  Result := FINIFilePath;
end;

function TConfigManager.GetCurrentJsonPath: string;
begin
  Result := FJSONFilePath;
end;

function TConfigManager.HasProject: Boolean;
begin
  Result := (FINIFilePath <> '') and FileExists(FINIFilePath);
end;

function TConfigManager.ResolveJSONPath(const INIPath, JSONRelPath: string): string;
var
  NormalizedPath: string;
begin
  // 规范化路径分隔符
  NormalizedPath := StringReplace(JSONRelPath, '/', PathDelim, [rfReplaceAll]);
  
  // 如果是绝对路径，直接返回
  if TPath.IsPathRooted(NormalizedPath) then
    Result := NormalizedPath
  else
    // 相对路径，基于 INI 文件所在目录解析
    Result := TPath.Combine(ExtractFilePath(INIPath), NormalizedPath);
end;

function TConfigManager.EnsureDirectoryExists(const DirPath: string): Boolean;
begin
  Result := True;
  if not TDirectory.Exists(DirPath) then
  begin
    try
      TDirectory.CreateDirectory(DirPath);
    except
      Result := False;
    end;
  end;
end;

function TConfigManager.CreateBackup(const FilePath: string): Boolean;
var
  BackupPath, BackupFileName, ActualBackupDir: string;
  TimeStamp: string;
begin
  Result := True;
  if not FileExists(FilePath) then
    Exit;
    
  try
    // 确定备份目录
    if FBackupDir <> '' then
      ActualBackupDir := FBackupDir
    else
      ActualBackupDir := TPath.Combine(ExtractFilePath(FilePath), DEFAULT_BACKUP_SUBDIR);
    
    // 确保备份目录存在
    if not EnsureDirectoryExists(ActualBackupDir) then
      Exit(False);
    
    // 生成带时间戳的备份文件名
    TimeStamp := FormatDateTime('yyyymmdd_hhnnss', Now);
    BackupFileName := ChangeFileExt(ExtractFileName(FilePath), '') + 
                      '_' + TimeStamp + ExtractFileExt(FilePath) + '.bak';
    BackupPath := TPath.Combine(ActualBackupDir, BackupFileName);
    
    // 复制文件到备份
    TFile.Copy(FilePath, BackupPath, True);
  except
    Result := False;
  end;
end;

function TConfigManager.SaveToTempAndRename(const FilePath, Content: string): Boolean;
var
  TempPath: string;
begin
  Result := False;
  TempPath := FilePath + '.tmp';
  
  try
    // 写入临时文件
    TFile.WriteAllText(TempPath, Content, TEncoding.UTF8);
    
    // 删除原文件（如果存在）
    if FileExists(FilePath) then
      TFile.Delete(FilePath);
    
    // 重命名临时文件
    TFile.Move(TempPath, FilePath);
    Result := True;
  except
    // 清理临时文件
    if FileExists(TempPath) then
      TFile.Delete(TempPath);
  end;
end;

procedure TConfigManager.CloseProject;
begin
  FINIConfig.Clear;
  FJSONConfig.Clear;
  FINIFilePath := '';
  FJSONFilePath := '';
  FIsModified := False;
end;

function TConfigManager.OpenProject(const AIniPath: string): Boolean;
var
  JSONRelPath: string;
begin
  Result := False;
  
  if not FileExists(AIniPath) then
    Exit;
  
  try
    // 关闭当前工程
    CloseProject;
    
    // 加载 INI 文件
    FINIFilePath := AIniPath;
    FINIConfig.LoadFromFile(FINIFilePath);
    
    // 从 INI 的 [json_file] 节读取 JSON 文件路径
    JSONRelPath := FINIConfig.ReadString(JSON_FILE_SECTION, JSON_FILE_PATH_KEY, '');
    
    // 如果没有指定 JSON 路径，使用默认的同名 .json 文件
    if JSONRelPath = '' then
      JSONRelPath := ChangeFileExt(ExtractFileName(AIniPath), '.json');
    
    // 解析 JSON 文件的完整路径
    FJSONFilePath := ResolveJSONPath(AIniPath, JSONRelPath);
    
    // 加载或创建 JSON 文件
    if FileExists(FJSONFilePath) then
      FJSONConfig.LoadFromFile(FJSONFilePath)
    else
    begin
      // JSON 文件不存在，创建空的 JSON 对象
      FJSONConfig.Clear;
      // 保存空的 JSON 文件
      TFile.WriteAllText(FJSONFilePath, '{}', TEncoding.UTF8);
    end;
    
    FIsModified := False;
    DoProjectLoaded;
    Result := True;
  except
    on E: Exception do
    begin
      CloseProject;
      Result := False;
    end;
  end;
end;

function TConfigManager.NewProject(const AIniPath: string): Boolean;
var
  JSONPath: string;
  INIDir: string;
begin
  Result := False;
  
  try
    // 关闭当前工程
    CloseProject;
    
    // 确保目录存在
    INIDir := ExtractFilePath(AIniPath);
    if (INIDir <> '') and not EnsureDirectoryExists(INIDir) then
      Exit;
    
    // 设置文件路径
    FINIFilePath := AIniPath;
    JSONPath := ChangeFileExt(AIniPath, '.json');
    FJSONFilePath := JSONPath;
    
    // 创建空的 INI 配置
    FINIConfig.Clear;
    FINIConfig.WriteString(JSON_FILE_SECTION, JSON_FILE_PATH_KEY, ExtractFileName(JSONPath));
    
    // 创建空的 JSON 配置
    FJSONConfig.Clear;
    
    // 保存文件
    FINIConfig.SaveToFile(FINIFilePath);
    TFile.WriteAllText(FJSONFilePath, '{}', TEncoding.UTF8);
    
    FIsModified := False;
    DoProjectLoaded;
    Result := True;
  except
    on E: Exception do
    begin
      CloseProject;
      Result := False;
    end;
  end;
end;

procedure TConfigManager.AddINIConfigItem(const Section, Key, DefaultValue: string; ConfigType: TConfigType);
var
  FullKey: string;
begin
  FullKey := ConfigTypeToString(ConfigType) + '.' + Key;
  FINIConfig.WriteString(Section, FullKey, DefaultValue);
  FIsModified := True;
end;

procedure TConfigManager.AddJSONConfigItem(const ParentPath, Name: string; JSONObj: TJSONObject);
begin
  FJSONConfig.AddJSONObject(ParentPath, Name, JSONObj);
  FIsModified := True;
end;

procedure TConfigManager.DeleteINIConfigItem(const Section, Key: string);
begin
  FINIConfig.DeleteKey(Section, Key);
  FIsModified := True;
end;

procedure TConfigManager.DeleteJSONConfigItem(const JSONPath: string);
begin
  FJSONConfig.DeleteJSONObject(JSONPath);
  FIsModified := True;
end;

function TConfigManager.FindReferenceObject(const RefID: string): TJSONObject;
begin
  Result := FJSONConfig.FindObjectByID(RefID);
end;

function TConfigManager.GetINIKeys(const Section: string): TArray<string>;
begin
  Result := FINIConfig.ReadSection(Section);
end;

function TConfigManager.GetINISections: TArray<string>;
begin
  Result := FINIConfig.ReadSections;
end;

function TConfigManager.GetINIValue(const Section, Key: string): string;
begin
  Result := FINIConfig.ReadString(Section, Key, '');
end;

function TConfigManager.GetJSONChildKeys(const JSONPath: string): TArray<string>;
begin
  Result := FJSONConfig.GetChildKeys(JSONPath);
end;

function TConfigManager.GetJSONObject(const JSONPath: string): TJSONObject;
begin
  Result := FJSONConfig.GetJSONObject(JSONPath);
end;

function TConfigManager.GetJSONPathFromINI(const INIPath: string): string;
begin
  Result := FINIConfig.ReadString('json_file', 'file_path', '');
  if Result = '' then
    Result := ChangeFileExt(INIPath, '.json');
end;

function TConfigManager.GetJSONRootKeys: TArray<string>;
begin
  Result := FJSONConfig.GetRootKeys;
end;

// 保留旧方法名作为别名，保持向后兼容
function TConfigManager.LoadFromFile(const INIFilePath: string): Boolean;
begin
  Result := OpenProject(INIFilePath);
end;

function TConfigManager.SaveProjectAs(const ANewIniPath: string): Boolean;
var
  NewJSONPath: string;
  INIDir: string;
begin
  Result := False;
  
  try
    // 确保目录存在
    INIDir := ExtractFilePath(ANewIniPath);
    if (INIDir <> '') and not EnsureDirectoryExists(INIDir) then
      Exit;
    
    // 设置新的文件路径
    FINIFilePath := ANewIniPath;
    NewJSONPath := ChangeFileExt(ANewIniPath, '.json');
    FJSONFilePath := NewJSONPath;
    
    // 更新 INI 文件中的 JSON 路径引用
    FINIConfig.WriteString(JSON_FILE_SECTION, JSON_FILE_PATH_KEY, ExtractFileName(NewJSONPath));
    
    // 保存文件（不创建备份，因为是新文件）
    FJSONConfig.SaveToFile(FJSONFilePath);
    FINIConfig.SaveToFile(FINIFilePath);
    
    FIsModified := False;
    Result := True;
  except
    on E: Exception do
      Result := False;
  end;
end;

function TConfigManager.SaveProject: Boolean;
begin
  Result := False;
  
  if FINIFilePath = '' then
    Exit;
  
  try
    // 1. 创建备份（如果文件已存在）
    CreateBackup(FJSONFilePath);
    CreateBackup(FINIFilePath);
    
    // 2. 先保存 JSON 文件
    FJSONConfig.SaveToFile(FJSONFilePath);
    
    // 3. 再保存 INI 文件
    FINIConfig.SaveToFile(FINIFilePath);
    
    FIsModified := False;
    Result := True;
  except
    on E: Exception do
      Result := False;
  end;
end;

// 保留旧方法名作为别名，保持向后兼容
function TConfigManager.SaveToFile: Boolean;
begin
  Result := SaveProject;
end;

function TConfigManager.SaveAsNewFile(const NewINIFilePath: string): Boolean;
begin
  Result := SaveProjectAs(NewINIFilePath);
end;

procedure TConfigManager.SetINIValue(const Section, Key, Value: string);
begin
  FINIConfig.WriteString(Section, Key, Value);
  FIsModified := True;
end;

procedure TConfigManager.SetIsModified(const Value: Boolean);
begin
  FIsModified := Value;
end;

procedure TConfigManager.SetJSONObject(const JSONPath: string; JSONObj: TJSONObject);
begin
  FJSONConfig.SetJSONObject(JSONPath, JSONObj);
  FIsModified := True;
end;

end.
