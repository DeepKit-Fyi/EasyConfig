﻿unit ConfigManager;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.JSON, System.Generics.Collections,
  ConfigTypes, INIConfig, JSONConfig;

type
  TConfigManager = class
  private
    FINIConfig: TLegacyINIConfig;
    FJSONConfig: TJSONConfig;
    FINIFilePath: string;
    FJSONFilePath: string;
    FIsModified: Boolean;
    
    function GetJSONPathFromINI(const INIPath: string): string;
    procedure SetIsModified(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    
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
  end;

implementation

{ TConfigManager }

constructor TConfigManager.Create;
begin
  inherited Create;
  FINIConfig := TLegacyINIConfig.Create;
  FJSONConfig := TJSONConfig.Create;
  FIsModified := False;
end;

destructor TConfigManager.Destroy;
begin
  FINIConfig.Free;
  FJSONConfig.Free;
  inherited;
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

function TConfigManager.LoadFromFile(const INIFilePath: string): Boolean;
begin
  Result := False;
  
  if not FileExists(INIFilePath) then
    Exit;
  
  try
    // 加载INI文件
    FINIFilePath := INIFilePath;
    FINIConfig.LoadFromFile(FINIFilePath);
    
    // 根据INI文件获取JSON文件路径
    FJSONFilePath := GetJSONPathFromINI(FINIFilePath);
    
    // 如果JSON路径不是绝对路径，则转换为相对于INI文件的绝对路径
    if not IsPathDelimiter(FJSONFilePath, 1) and (ExtractFileDrive(FJSONFilePath) = '') then
      FJSONFilePath := ExtractFilePath(FINIFilePath) + FJSONFilePath;
    
    // 加载JSON文件
    if FileExists(FJSONFilePath) then
      FJSONConfig.LoadFromFile(FJSONFilePath)
    else
      FJSONConfig.Clear; // 如果JSON文件不存在，创建一个空的
    
    FIsModified := False;
    Result := True;
  except
    on E: Exception do
    begin
      // 处理异常
      Result := False;
    end;
  end;
end;

function TConfigManager.SaveAsNewFile(const NewINIFilePath: string): Boolean;
var
  NewJSONFilePath: string;
begin
  // 设置新的INI文件路径
  FINIFilePath := NewINIFilePath;
  
  // 确定新的JSON文件路径
  NewJSONFilePath := ChangeFileExt(NewINIFilePath, '.json');
  FJSONFilePath := NewJSONFilePath;
  
  // 更新INI文件中的JSON路径
  FINIConfig.WriteString('json_file', 'file_path', ExtractFileName(NewJSONFilePath));
  
  // 保存文件
  Result := SaveToFile;
end;

function TConfigManager.SaveToFile: Boolean;
begin
  Result := False;
  
  try
    // 保存INI文件
    FINIConfig.SaveToFile(FINIFilePath);
    
    // 保存JSON文件
    FJSONConfig.SaveToFile(FJSONFilePath);
    
    FIsModified := False;
    Result := True;
  except
    on E: Exception do
    begin
      // 处理异常
      Result := False;
    end;
  end;
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
