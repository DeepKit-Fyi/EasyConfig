unit SystemConfig;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  ConfigTypes, INIConfig;

type
  // 数据库连接配置
  TDatabaseConfig = class(TConfigObject)
  private
    FServer: string;
    FPort: Integer;
    FDatabase: string;
    FUsername: string;
    FPassword: string;
    FConnectionTimeout: Integer;
    FPoolSize: Integer;
    FAutoReconnect: Boolean;
    
    FINIConfig: TINIConfig;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 加载与保存
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 验证
    function Validate: Boolean; override;
    function GetValidationErrors: TArray<string>; override;
    
    // 测试连接
    function TestConnection: Boolean;
    
    // 属性
    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property Database: string read FDatabase write FDatabase;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property ConnectionTimeout: Integer read FConnectionTimeout write FConnectionTimeout;
    property PoolSize: Integer read FPoolSize write FPoolSize;
    property AutoReconnect: Boolean read FAutoReconnect write FAutoReconnect;
  end;
  
  // 路径配置
  TPathConfig = class(TConfigObject)
  private
    FLogPath: string;
    FTempPath: string;
    FDataPath: string;
    FBackupPath: string;
    FExportPath: string;
    FResourcePath: string;
    
    FINIConfig: TINIConfig;
    
    function ExpandPath(const Path: string): string;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 加载与保存
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 验证
    function Validate: Boolean; override;
    function GetValidationErrors: TArray<string>; override;
    
    // 路径操作
    function EnsurePathsExist: Boolean;
    
    // 属性
    property LogPath: string read FLogPath write FLogPath;
    property TempPath: string read FTempPath write FTempPath;
    property DataPath: string read FDataPath write FDataPath;
    property BackupPath: string read FBackupPath write FBackupPath;
    property ExportPath: string read FExportPath write FExportPath;
    property ResourcePath: string read FResourcePath write FResourcePath;
  end;
  
  // 系统启动配置
  TStartupConfig = class(TConfigObject)
  private
    FAppName: string;
    FShowSplash: Boolean;
    FAutoLogin: Boolean;
    FDefaultUser: string;
    FDefaultPassword: string;
    FLanguage: string;
    FLogLevel: Integer;
    
    FINIConfig: TINIConfig;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 加载与保存
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 验证
    function Validate: Boolean; override;
    
    // 属性
    property AppName: string read FAppName write FAppName;
    property ShowSplash: Boolean read FShowSplash write FShowSplash;
    property AutoLogin: Boolean read FAutoLogin write FAutoLogin;
    property DefaultUser: string read FDefaultUser write FDefaultUser;
    property DefaultPassword: string read FDefaultPassword write FDefaultPassword;
    property Language: string read FLanguage write FLanguage;
    property LogLevel: Integer read FLogLevel write FLogLevel;
  end;

implementation

{ TDatabaseConfig }

constructor TDatabaseConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 默认值
  FServer := 'localhost';
  FPort := 1433;
  FDatabase := '';
  FUsername := '';
  FPassword := '';
  FConnectionTimeout := 30;
  FPoolSize := 10;
  FAutoReconnect := True;
  
  // 创建INI配置
  FINIConfig := nil;
end;

destructor TDatabaseConfig.Destroy;
begin
  if Assigned(FINIConfig) then
    FINIConfig.Free;
  inherited;
end;

function TDatabaseConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 创建或获取INI文件
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 从INI加载值
    FServer := FINIConfig.ReadString('Connection', 'Server', FServer);
    FPort := FINIConfig.ReadInteger('Connection', 'Port', FPort);
    FDatabase := FINIConfig.ReadString('Connection', 'Database', FDatabase);
    FUsername := FINIConfig.ReadString('Connection', 'Username', FUsername);
    FPassword := FINIConfig.ReadEncrypted('Connection', 'Password', '');
    FConnectionTimeout := FINIConfig.ReadInteger('Options', 'ConnectionTimeout', FConnectionTimeout);
    FPoolSize := FINIConfig.ReadInteger('Pool', 'PoolSize', FPoolSize);
    FAutoReconnect := FINIConfig.ReadBool('Options', 'AutoReconnect', FAutoReconnect);
    
    Result := True;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TDatabaseConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 确保INI文件已创建
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 保存值到INI
    FINIConfig.WriteString('Connection', 'Server', FServer);
    FINIConfig.WriteInteger('Connection', 'Port', FPort);
    FINIConfig.WriteString('Connection', 'Database', FDatabase);
    FINIConfig.WriteString('Connection', 'Username', FUsername);
    FINIConfig.WriteEncrypted('Connection', 'Password', FPassword);
    FINIConfig.WriteInteger('Options', 'ConnectionTimeout', FConnectionTimeout);
    FINIConfig.WriteInteger('Pool', 'PoolSize', FPoolSize);
    FINIConfig.WriteBool('Options', 'AutoReconnect', FAutoReconnect);
    
    // 保存文件
    Result := FINIConfig.Save;
    
    // 更新修改状态
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TDatabaseConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TDatabaseConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 验证服务器
    if FServer = '' then
      Errors.Add('服务器地址不能为空');
      
    // 验证端口
    if (FPort <= 0) or (FPort > 65535) then
      Errors.Add('端口号必须在1-65535之间');
      
    // 验证数据库名
    if FDatabase = '' then
      Errors.Add('数据库名不能为空');
      
    // 验证超时设置
    if FConnectionTimeout <= 0 then
      Errors.Add('连接超时必须大于0');
      
    // 验证连接池大小
    if FPoolSize <= 0 then
      Errors.Add('连接池大小必须大于0');
      
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

function TDatabaseConfig.TestConnection: Boolean;
begin
  // 在实际应用中，这里应该实现实际的数据库连接测试
  // 出于演示目的，这里直接返回服务器名不为空
  Result := (FServer <> '') and (FDatabase <> '');
end;

{ TPathConfig }

constructor TPathConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 默认值
  FLogPath := '.\logs';
  FTempPath := '.\temp';
  FDataPath := '.\data';
  FBackupPath := '.\backup';
  FExportPath := '.\export';
  FResourcePath := '.\resources';
  
  // 创建INI配置
  FINIConfig := nil;
end;

destructor TPathConfig.Destroy;
begin
  if Assigned(FINIConfig) then
    FINIConfig.Free;
  inherited;
end;

function TPathConfig.ExpandPath(const Path: string): string;
begin
  // 展开相对路径为绝对路径
  if TPath.IsPathRooted(Path) then
    Result := Path
  else
    Result := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)), Path));
end;

function TPathConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 创建或获取INI文件
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 从INI加载值
    FLogPath := FINIConfig.ReadString('Paths', 'LogPath', FLogPath);
    FTempPath := FINIConfig.ReadString('Paths', 'TempPath', FTempPath);
    FDataPath := FINIConfig.ReadString('Paths', 'DataPath', FDataPath);
    FBackupPath := FINIConfig.ReadString('Paths', 'BackupPath', FBackupPath);
    FExportPath := FINIConfig.ReadString('Paths', 'ExportPath', FExportPath);
    FResourcePath := FINIConfig.ReadString('Paths', 'ResourcePath', FResourcePath);
    
    Result := True;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TPathConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 确保INI文件已创建
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 保存值到INI
    FINIConfig.WriteString('Paths', 'LogPath', FLogPath);
    FINIConfig.WriteString('Paths', 'TempPath', FTempPath);
    FINIConfig.WriteString('Paths', 'DataPath', FDataPath);
    FINIConfig.WriteString('Paths', 'BackupPath', FBackupPath);
    FINIConfig.WriteString('Paths', 'ExportPath', FExportPath);
    FINIConfig.WriteString('Paths', 'ResourcePath', FResourcePath);
    
    // 保存文件
    Result := FINIConfig.Save;
    
    // 更新修改状态
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TPathConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TPathConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 验证路径
    if FLogPath = '' then
      Errors.Add('日志路径不能为空');
      
    if FTempPath = '' then
      Errors.Add('临时文件路径不能为空');
      
    if FDataPath = '' then
      Errors.Add('数据文件路径不能为空');
      
    if FBackupPath = '' then
      Errors.Add('备份路径不能为空');
      
    if FExportPath = '' then
      Errors.Add('导出文件路径不能为空');
      
    if FResourcePath = '' then
      Errors.Add('资源文件路径不能为空');
      
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

function TPathConfig.EnsurePathsExist: Boolean;
var
  ExpandedPath: string;
begin
  Result := True;
  
  try
    // 确保所有路径存在
    ExpandedPath := ExpandPath(FLogPath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
      
    ExpandedPath := ExpandPath(FTempPath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
      
    ExpandedPath := ExpandPath(FDataPath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
      
    ExpandedPath := ExpandPath(FBackupPath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
      
    ExpandedPath := ExpandPath(FExportPath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
      
    ExpandedPath := ExpandPath(FResourcePath);
    if not TDirectory.Exists(ExpandedPath) then
      TDirectory.CreateDirectory(ExpandedPath);
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

{ TStartupConfig }

constructor TStartupConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 默认值
  FAppName := 'ConfigManager';
  FShowSplash := True;
  FAutoLogin := False;
  FDefaultUser := '';
  FDefaultPassword := '';
  FLanguage := 'zh-CN';
  FLogLevel := 3; // 信息级别
  
  // 创建INI配置
  FINIConfig := nil;
end;

destructor TStartupConfig.Destroy;
begin
  if Assigned(FINIConfig) then
    FINIConfig.Free;
  inherited;
end;

function TStartupConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 创建或获取INI文件
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 从INI加载值
    FAppName := FINIConfig.ReadString('Application', 'AppName', FAppName);
    FShowSplash := FINIConfig.ReadBool('Application', 'ShowSplash', FShowSplash);
    FAutoLogin := FINIConfig.ReadBool('Security', 'AutoLogin', FAutoLogin);
    FDefaultUser := FINIConfig.ReadString('Security', 'DefaultUser', FDefaultUser);
    FDefaultPassword := FINIConfig.ReadEncrypted('Security', 'DefaultPassword', '');
    FLanguage := FINIConfig.ReadString('Localization', 'Language', FLanguage);
    FLogLevel := FINIConfig.ReadInteger('Logging', 'LogLevel', FLogLevel);
    
    Result := True;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TStartupConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 确保INI文件已创建
    if not Assigned(FINIConfig) then
      FINIConfig := TINIConfig.Create(FFileName);
      
    // 保存值到INI
    FINIConfig.WriteString('Application', 'AppName', FAppName);
    FINIConfig.WriteBool('Application', 'ShowSplash', FShowSplash);
    FINIConfig.WriteBool('Security', 'AutoLogin', FAutoLogin);
    FINIConfig.WriteString('Security', 'DefaultUser', FDefaultUser);
    FINIConfig.WriteEncrypted('Security', 'DefaultPassword', FDefaultPassword);
    FINIConfig.WriteString('Localization', 'Language', FLanguage);
    FINIConfig.WriteInteger('Logging', 'LogLevel', FLogLevel);
    
    // 保存文件
    Result := FINIConfig.Save;
    
    // 更新修改状态
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 记录错误
      Result := False;
    end;
  end;
end;

function TStartupConfig.Validate: Boolean;
begin
  // 简单验证
  Result := (FAppName <> '') and
            (FLanguage <> '') and
            (FLogLevel >= 0) and (FLogLevel <= 5);
end;

end. 