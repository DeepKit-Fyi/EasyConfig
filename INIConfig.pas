unit INIConfig;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.JSON;

type
  // INI配置文件处理类（旧版本，保留但不使用）
  TLegacyINIConfig = class
  private
    FIniFile: TMemIniFile;
    FFilePath: string;
    FModified: Boolean;
    
    // 辅助方法
    procedure EnsureFileExists;
    function EncryptString(const Value: string): string;
    function DecryptString(const Value: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 加载INI文件
    procedure LoadFromFile(const FilePath: string);
    // 保存INI文件
    procedure SaveToFile(const FilePath: string);
    // 清空INI内容
    procedure Clear;
    
    // 获取所有节名
    function ReadSections: TArray<string>;
    // 获取指定节中的所有键
    function ReadSection(const Section: string): TArray<string>;
    
    // 读取INI值
    function ReadString(const Section, Key, Default: string): string;
    function ReadInteger(const Section, Key: string; Default: Integer): Integer;
    function ReadBool(const Section, Key: string; Default: Boolean): Boolean;
    function ReadFloat(const Section, Key: string; Default: Double): Double;
    function ReadDate(const Section, Key: string; Default: TDateTime): TDateTime;
    function ReadDateTime(const Section, Key: string; Default: TDateTime): TDateTime;
    function ReadTime(const Section, Key: string; Default: TDateTime): TDateTime;
    
    // 写入INI值
    procedure WriteString(const Section, Key, Value: string);
    procedure WriteInteger(const Section, Key: string; Value: Integer);
    procedure WriteBool(const Section, Key: string; Value: Boolean);
    procedure WriteFloat(const Section, Key: string; Value: Double);
    procedure WriteDate(const Section, Key: string; Value: TDateTime);
    procedure WriteDateTime(const Section, Key: string; Value: TDateTime);
    procedure WriteTime(const Section, Key: string; Value: TDateTime);
    
    // 删除操作
    procedure DeleteKey(const Section, Key: string);
    procedure DeleteSection(const Section: string);
    
    // 属性
    property FilePath: string read FFilePath;
    property Modified: Boolean read FModified write FModified;
  end;

type
  // 当前使用的INI配置管理器类
  TINIConfigManager = class
  private
    FIniFile: TIniFile;
    FFileName: string;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    
    function ReadConfig(const Section, Key: string; ConfigType: TConfigType): TJSONValue;
    procedure WriteConfig(const Section, Key: string; ConfigType: TConfigType; Value: TJSONValue);
    function ReadSection(const Section: string): TStringList;
    procedure WriteSection(const Section: string; Values: TStringList);
    function SectionExists(const Section: string): Boolean;
    function KeyExists(const Section, Key: string): Boolean;
    procedure DeleteKey(const Section, Key: string);
    procedure DeleteSection(const Section: string);
  end;

implementation

uses
  System.IOUtils, System.NetEncoding;

{ TLegacyINIConfig }

constructor TLegacyINIConfig.Create;
begin
  inherited Create;
  FIniFile := nil;
  FModified := False;
end;

destructor TLegacyINIConfig.Destroy;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  inherited;
end;

procedure TLegacyINIConfig.Clear;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  
  FIniFile := TMemIniFile.Create('');
  FModified := True;
end;

procedure TLegacyINIConfig.DeleteKey(const Section, Key: string);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.DeleteKey(Section, Key);
  FModified := True;
end;

procedure TLegacyINIConfig.DeleteSection(const Section: string);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.EraseSection(Section);
  FModified := True;
end;

procedure TLegacyINIConfig.LoadFromFile(const FilePath: string);
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  
  FFilePath := FilePath;
  
  if FileExists(FilePath) then
    FIniFile := TMemIniFile.Create(FilePath, TEncoding.UTF8)
  else
    FIniFile := TMemIniFile.Create('');
  
  FModified := False;
end;

function TLegacyINIConfig.ReadBool(const Section, Key: string; Default: Boolean): Boolean;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadBool(Section, Key, Default);
end;

function TLegacyINIConfig.ReadDate(const Section, Key: string; Default: TDateTime): TDateTime;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadDate(Section, Key, Default);
end;

function TLegacyINIConfig.ReadDateTime(const Section, Key: string; Default: TDateTime): TDateTime;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadDateTime(Section, Key, Default);
end;

function TLegacyINIConfig.ReadFloat(const Section, Key: string; Default: Double): Double;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadFloat(Section, Key, Default);
end;

function TLegacyINIConfig.ReadInteger(const Section, Key: string; Default: Integer): Integer;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadInteger(Section, Key, Default);
end;

function TLegacyINIConfig.ReadSection(const Section: string): TArray<string>;
var
  Strings: TStrings;
begin
  if not Assigned(FIniFile) then
    Exit(nil);
  
  Strings := TStringList.Create;
  try
    FIniFile.ReadSection(Section, Strings);
    SetLength(Result, Strings.Count);
    for var I := 0 to Strings.Count - 1 do
      Result[I] := Strings[I];
  finally
    Strings.Free;
  end;
end;

function TLegacyINIConfig.ReadSections: TArray<string>;
var
  Strings: TStrings;
begin
  if not Assigned(FIniFile) then
    Exit(nil);
  
  Strings := TStringList.Create;
  try
    FIniFile.ReadSections(Strings);
    SetLength(Result, Strings.Count);
    for var I := 0 to Strings.Count - 1 do
      Result[I] := Strings[I];
  finally
    Strings.Free;
  end;
end;

function TLegacyINIConfig.ReadString(const Section, Key, Default: string): string;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadString(Section, Key, Default);
end;

function TLegacyINIConfig.ReadTime(const Section, Key: string; Default: TDateTime): TDateTime;
begin
  if not Assigned(FIniFile) then
    Result := Default
  else
    Result := FIniFile.ReadTime(Section, Key, Default);
end;

procedure TLegacyINIConfig.SaveToFile(const FilePath: string);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  // 创建目录（如果不存在）
  ForceDirectories(ExtractFilePath(FilePath));
  
  // 保存文件
  FIniFile.UpdateFile;
  if FFilePath <> FilePath then
  begin
    FIniFile.Rename(FilePath, False);
    FFilePath := FilePath;
  end;
  
  FModified := False;
end;

procedure TLegacyINIConfig.WriteBool(const Section, Key: string; Value: Boolean);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteBool(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteDate(const Section, Key: string; Value: TDateTime);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteDate(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteDateTime(const Section, Key: string; Value: TDateTime);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteDateTime(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteFloat(const Section, Key: string; Value: Double);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteFloat(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteInteger(const Section, Key: string; Value: Integer);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteInteger(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteString(const Section, Key, Value: string);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteString(Section, Key, Value);
  FModified := True;
end;

procedure TLegacyINIConfig.WriteTime(const Section, Key: string; Value: TDateTime);
begin
  if not Assigned(FIniFile) then
    Exit;
  
  FIniFile.WriteTime(Section, Key, Value);
  FModified := True;
end;

function TLegacyINIConfig.EncryptString(const Value: string): string;
begin
  // 简单实现，实际应用中应使用更安全的加密方法
  Result := Value;
  // 此处可添加实际加密算法
end;

function TLegacyINIConfig.DecryptString(const Value: string): string;
begin
  // 简单实现，实际应用中应使用对应的解密方法
  Result := Value;
  // 此处可添加实际解密算法
end;

procedure TLegacyINIConfig.EnsureFileExists;
begin
  // 确保配置文件存在
  if (FFilePath <> '') and not FileExists(FFilePath) then
  begin
    // 创建目录（如果不存在）
    ForceDirectories(ExtractFilePath(FFilePath));
    
    // 创建空文件
    with TStringList.Create do
    try
      SaveToFile(FFilePath, TEncoding.UTF8);
    finally
      Free;
    end;
  end;
end;

{ TINIConfigManager }

constructor TINIConfigManager.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FIniFile := TIniFile.Create(FFileName);
end;

destructor TINIConfigManager.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TINIConfigManager.ReadConfig(const Section, Key: string; ConfigType: TConfigType): TJSONValue;
var
  Value: string;
begin
  Value := FIniFile.ReadString(Section, Key, '');
  case ConfigType of
    ctPlain: Result := TJSONString.Create(Value);
    ctColor: Result := TJSONString.Create(Value);
    ctFont: Result := TJSONString.Create(Value);
    ctDatabase: Result := TJSONString.Create(Value);
    ctList: Result := TJSONString.Create(Value);
    ctObject: Result := TJSONObject.ParseJSONValue(Value);
    ctArray: Result := TJSONArray.ParseJSONValue(Value);
  else
    Result := TJSONString.Create(Value);
  end;
end;

procedure TINIConfigManager.WriteConfig(const Section, Key: string; ConfigType: TConfigType; Value: TJSONValue);
var
  StrValue: string;
begin
  if Value is TJSONString then
    StrValue := TJSONString(Value).Value
  else
    StrValue := Value.ToString;
    
  FIniFile.WriteString(Section, Key, StrValue);
end;

function TINIConfigManager.ReadSection(const Section: string): TStringList;
begin
  Result := TStringList.Create;
  FIniFile.ReadSection(Section, Result);
end;

procedure TINIConfigManager.WriteSection(const Section: string; Values: TStringList);
var
  i: Integer;
begin
  for i := 0 to Values.Count - 1 do
    FIniFile.WriteString(Section, Values.Names[i], Values.ValueFromIndex[i]);
end;

function TINIConfigManager.SectionExists(const Section: string): Boolean;
begin
  Result := FIniFile.SectionExists(Section);
end;

function TINIConfigManager.KeyExists(const Section, Key: string): Boolean;
begin
  Result := FIniFile.ValueExists(Section, Key);
end;

procedure TINIConfigManager.DeleteKey(const Section, Key: string);
begin
  FIniFile.DeleteKey(Section, Key);
end;

procedure TINIConfigManager.DeleteSection(const Section: string);
begin
  FIniFile.EraseSection(Section);
end;

end.