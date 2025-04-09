unit BaseConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IniFiles;

type
  // 配置存储基类
  TBaseConfig = class abstract
  protected
    FFileName: string;
    FModified: Boolean;
  public
    constructor Create(const AFileName: string); virtual;
    destructor Destroy; override;
    
    // 文件操作
    function Exists: Boolean; virtual;
    function CreateFile: Boolean; virtual; abstract;
    function Reload: Boolean; virtual; abstract;
    function Save: Boolean; virtual; abstract;
    function SaveToFile(const FileName: string): Boolean; virtual; abstract;
    
    // 属性
    property FileName: string read FFileName write FFileName;
    property Modified: Boolean read FModified write FModified;
  end;

  // JSON配置类
  TJSONConfig = class(TBaseConfig)
  private
    FRoot: TJSONObject;
  public
    constructor Create(const AFileName: string); override;
    destructor Destroy; override;
    
    // 文件操作
    function CreateFile: Boolean; override;
    function Reload: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile(const FileName: string): Boolean; override;
    
    // 读取操作
    function ReadString(const Path: string; const DefaultValue: string = ''): string;
    function ReadInteger(const Path: string; DefaultValue: Integer = 0): Integer;
    function ReadFloat(const Path: string; DefaultValue: Double = 0): Double;
    function ReadBoolean(const Path: string; DefaultValue: Boolean = False): Boolean;
    function ReadDateTime(const Path: string; DefaultValue: TDateTime = 0): TDateTime;
    
    // 写入操作
    procedure WriteString(const Path, Value: string);
    procedure WriteInteger(const Path: string; Value: Integer);
    procedure WriteFloat(const Path: string; Value: Double);
    procedure WriteBoolean(const Path: string; Value: Boolean);
    procedure WriteDateTime(const Path: string; Value: TDateTime);
    procedure WriteObject(const Path: string; Value: TJSONObject);
    
    // JSON根节点
    property Root: TJSONObject read FRoot;
  end;

  // INI配置类
  TINIConfig = class(TBaseConfig)
  private
    FIniFile: TMemIniFile;
  public
    constructor Create(const AFileName: string); override;
    destructor Destroy; override;
    
    // 文件操作
    function CreateFile: Boolean; override;
    function Reload: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile(const FileName: string): Boolean; override;
    
    // 读取操作
    function ReadString(const Section, Name, DefaultValue: string): string;
    function ReadInteger(const Section, Name: string; DefaultValue: Integer): Integer;
    function ReadFloat(const Section, Name: string; DefaultValue: Double): Double;
    function ReadBool(const Section, Name: string; DefaultValue: Boolean): Boolean;
    function ReadDateTime(const Section, Name: string; DefaultValue: TDateTime): TDateTime;
    
    // 写入操作
    procedure WriteString(const Section, Name, Value: string);
    procedure WriteInteger(const Section, Name: string; Value: Integer);
    procedure WriteFloat(const Section, Name: string; Value: Double);
    procedure WriteBool(const Section, Name: string; Value: Boolean);
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime);
    
    // INI文件访问
    property IniFile: TMemIniFile read FIniFile;
  end;

implementation

uses
  System.IOUtils, System.DateUtils, System.Variants;

{ TBaseConfig }

constructor TBaseConfig.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FModified := False;
end;

destructor TBaseConfig.Destroy;
begin
  if FModified then
    try
      Save;
    except
      // 忽略保存错误
    end;
  inherited;
end;

function TBaseConfig.Exists: Boolean;
begin
  Result := TFile.Exists(FFileName);
end;

{ TJSONConfig }

constructor TJSONConfig.Create(const AFileName: string);
begin
  inherited Create(AFileName);
  FRoot := TJSONObject.Create;
  
  // 如果文件存在，则加载
  if Exists then
    Reload
  else
    CreateFile;
end;

destructor TJSONConfig.Destroy;
begin
  FRoot.Free;
  inherited;
end;

function TJSONConfig.CreateFile: Boolean;
begin
  try
    // 确保目录存在
    TDirectory.CreateDirectory(ExtractFilePath(FFileName));
    
    // 创建一个空的JSON文件
    Save;
    
    Result := True;
  except
    Result := False;
  end;
end;

function TJSONConfig.Reload: Boolean;
var
  FileStream: TFileStream;
  StringStream: TStringStream;
  JSONValue: TJSONValue;
begin
  Result := False;
  
  if not Exists then
    Exit;
    
  try
    // 读取JSON文件内容
    FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
    try
      StringStream := TStringStream.Create('', TEncoding.UTF8);
      try
        StringStream.CopyFrom(FileStream, 0);
        
        // 解析JSON内容
        JSONValue := TJSONObject.ParseJSONValue(StringStream.DataString);
        if Assigned(JSONValue) and (JSONValue is TJSONObject) then
        begin
          // 释放旧的根节点
          FRoot.Free;
          FRoot := JSONValue as TJSONObject;
          Result := True;
        end
        else
        begin
          // 解析失败，创建空的JSON对象
          if Assigned(JSONValue) then
            JSONValue.Free;
          
          FRoot.Free;
          FRoot := TJSONObject.Create;
        end;
      finally
        StringStream.Free;
      end;
    finally
      FileStream.Free;
    end;
  except
    // 读取或解析出错，保持空的JSON对象
    FRoot.Free;
    FRoot := TJSONObject.Create;
  end;
end;

function TJSONConfig.Save: Boolean;
var
  FileStream: TFileStream;
  StringStream: TStringStream;
  JSONString: string;
begin
  Result := False;
  
  try
    // 创建目录（如果不存在）
    TDirectory.CreateDirectory(ExtractFilePath(FFileName));
    
    // 将JSON对象转换为字符串
    JSONString := FRoot.ToString;
    
    // 创建字符串流和文件流
    StringStream := TStringStream.Create(JSONString, TEncoding.UTF8);
    try
      FileStream := TFileStream.Create(FFileName, fmCreate);
      try
        // 写入文件
        FileStream.CopyFrom(StringStream, 0);
        Result := True;
        FModified := False;
      finally
        FileStream.Free;
      end;
    finally
      StringStream.Free;
    end;
  except
    // 写入出错
    Result := False;
  end;
end;

function TJSONConfig.SaveToFile(const FileName: string): Boolean;
var
  OldFileName: string;
begin
  OldFileName := FFileName;
  FFileName := FileName;
  try
    Result := Save;
  finally
    FFileName := OldFileName;
  end;
end;

function TJSONConfig.ReadString(const Path: string; const DefaultValue: string): string;
var
  PathParts: TArray<string>;
  CurrentObj: TJSONObject;
  CurrentValue: TJSONValue;
  I: Integer;
begin
  Result := DefaultValue;
  
  if Path = '' then
    Exit;
    
  // 分割路径
  PathParts := Path.Split(['/']);
  
  // 从根节点开始查找
  CurrentObj := FRoot;
  
  // 遍历路径
  for I := 0 to Length(PathParts) - 2 do
  begin
    CurrentValue := CurrentObj.GetValue(PathParts[I]);
    if not Assigned(CurrentValue) or not (CurrentValue is TJSONObject) then
      Exit;
      
    CurrentObj := CurrentValue as TJSONObject;
  end;
  
  // 获取最终节点的值
  if Length(PathParts) > 0 then
  begin
    CurrentValue := CurrentObj.GetValue(PathParts[Length(PathParts) - 1]);
    if Assigned(CurrentValue) then
    begin
      if CurrentValue is TJSONString then
        Result := (CurrentValue as TJSONString).Value
      else
        Result := CurrentValue.ToString;
    end;
  end;
end;

function TJSONConfig.ReadInteger(const Path: string; DefaultValue: Integer): Integer;
var
  StrValue: string;
begin
  StrValue := ReadString(Path);
  if StrValue = '' then
    Result := DefaultValue
  else
    Result := StrToIntDef(StrValue, DefaultValue);
end;

function TJSONConfig.ReadFloat(const Path: string; DefaultValue: Double): Double;
var
  StrValue: string;
begin
  StrValue := ReadString(Path);
  if StrValue = '' then
    Result := DefaultValue
  else
    Result := StrToFloatDef(StrValue, DefaultValue);
end;

function TJSONConfig.ReadBoolean(const Path: string; DefaultValue: Boolean): Boolean;
var
  StrValue: string;
begin
  StrValue := ReadString(Path);
  if StrValue = '' then
    Result := DefaultValue
  else
    Result := StrToBoolDef(StrValue, DefaultValue);
end;

function TJSONConfig.ReadDateTime(const Path: string; DefaultValue: TDateTime): TDateTime;
var
  StrValue: string;
begin
  StrValue := ReadString(Path);
  if StrValue = '' then
    Result := DefaultValue
  else
    Result := StrToDateTimeDef(StrValue, DefaultValue);
end;

procedure TJSONConfig.WriteString(const Path, Value: string);
var
  PathParts: TArray<string>;
  CurrentObj: TJSONObject;
  CurrentValue: TJSONValue;
  I: Integer;
begin
  if Path = '' then
    Exit;
    
  // 分割路径
  PathParts := Path.Split(['/']);
  
  // 从根节点开始查找
  CurrentObj := FRoot;
  
  // 遍历路径，创建中间节点（如果不存在）
  for I := 0 to Length(PathParts) - 2 do
  begin
    CurrentValue := CurrentObj.GetValue(PathParts[I]);
    
    if not Assigned(CurrentValue) then
    begin
      // 创建新节点
      CurrentValue := TJSONObject.Create;
      CurrentObj.AddPair(PathParts[I], CurrentValue);
    end
    else if not (CurrentValue is TJSONObject) then
    begin
      // 如果存在但不是对象，则替换为对象
      CurrentObj.RemovePair(PathParts[I]);
      CurrentValue := TJSONObject.Create;
      CurrentObj.AddPair(PathParts[I], CurrentValue);
    end;
      
    CurrentObj := CurrentValue as TJSONObject;
  end;
  
  // 设置最终节点的值
  if Length(PathParts) > 0 then
  begin
    CurrentObj.RemovePair(PathParts[Length(PathParts) - 1]);
    CurrentObj.AddPair(PathParts[Length(PathParts) - 1], Value);
    FModified := True;
  end;
end;

procedure TJSONConfig.WriteInteger(const Path: string; Value: Integer);
begin
  WriteString(Path, IntToStr(Value));
end;

procedure TJSONConfig.WriteFloat(const Path: string; Value: Double);
begin
  WriteString(Path, FloatToStr(Value));
end;

procedure TJSONConfig.WriteBoolean(const Path: string; Value: Boolean);
begin
  WriteString(Path, BoolToStr(Value, True));
end;

procedure TJSONConfig.WriteDateTime(const Path: string; Value: TDateTime);
begin
  WriteString(Path, DateTimeToStr(Value));
end;

procedure TJSONConfig.WriteObject(const Path: string; Value: TJSONObject);
var
  PathParts: TArray<string>;
  CurrentObj: TJSONObject;
  CurrentValue: TJSONValue;
  I: Integer;
begin
  if (Path = '') or (Value = nil) then
    Exit;
    
  // 分割路径
  PathParts := Path.Split(['/']);
  
  // 从根节点开始查找
  CurrentObj := FRoot;
  
  // 遍历路径，创建中间节点（如果不存在）
  for I := 0 to Length(PathParts) - 2 do
  begin
    CurrentValue := CurrentObj.GetValue(PathParts[I]);
    
    if not Assigned(CurrentValue) then
    begin
      // 创建新节点
      CurrentValue := TJSONObject.Create;
      CurrentObj.AddPair(PathParts[I], CurrentValue);
    end
    else if not (CurrentValue is TJSONObject) then
    begin
      // 如果存在但不是对象，则替换为对象
      CurrentObj.RemovePair(PathParts[I]);
      CurrentValue := TJSONObject.Create;
      CurrentObj.AddPair(PathParts[I], CurrentValue);
    end;
      
    CurrentObj := CurrentValue as TJSONObject;
  end;
  
  // 设置最终节点的值
  if Length(PathParts) > 0 then
  begin
    CurrentObj.RemovePair(PathParts[Length(PathParts) - 1]);
    CurrentObj.AddPair(PathParts[Length(PathParts) - 1], Value.Clone as TJSONValue);
    FModified := True;
  end;
end;

{ TINIConfig }

constructor TINIConfig.Create(const AFileName: string);
begin
  inherited Create(AFileName);
  
  // 如果文件不存在，则创建
  if not Exists then
    CreateFile;
    
  FIniFile := TMemIniFile.Create(FFileName);
end;

destructor TINIConfig.Destroy;
begin
  if FModified then
    Save;
  
  FIniFile.Free;
  inherited;
end;

function TINIConfig.CreateFile: Boolean;
var
  StringList: TStringList;
begin
  try
    // 确保目录存在
    TDirectory.CreateDirectory(ExtractFilePath(FFileName));
    
    // 创建一个空的INI文件
    StringList := TStringList.Create;
    try
      StringList.SaveToFile(FFileName);
    finally
      StringList.Free;
    end;
    
    Result := True;
  except
    Result := False;
  end;
end;

function TINIConfig.Reload: Boolean;
begin
  try
    if Assigned(FIniFile) then
      FIniFile.Free;
      
    FIniFile := TMemIniFile.Create(FFileName);
    Result := True;
  except
    Result := False;
  end;
end;

function TINIConfig.Save: Boolean;
begin
  try
    if Assigned(FIniFile) then
    begin
      FIniFile.UpdateFile;
      FModified := False;
      Result := True;
    end
    else
      Result := False;
  except
    Result := False;
  end;
end;

function TINIConfig.SaveToFile(const FileName: string): Boolean;
var
  OldFileName: string;
begin
  Result := False; // 设置默认返回值
  
  if not Assigned(FIniFile) then
    Exit;
  
  OldFileName := FFileName;
  try
    FFileName := FileName;
    FIniFile.Rename(FileName, False);
    Result := Save;
  finally
    if not Result then
    begin
      FFileName := OldFileName;
      FIniFile.Rename(OldFileName, False);
    end;
  end;
end;

function TINIConfig.ReadString(const Section, Name, DefaultValue: string): string;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadString(Section, Name, DefaultValue)
  else
    Result := DefaultValue;
end;

function TINIConfig.ReadInteger(const Section, Name: string; DefaultValue: Integer): Integer;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadInteger(Section, Name, DefaultValue)
  else
    Result := DefaultValue;
end;

function TINIConfig.ReadFloat(const Section, Name: string; DefaultValue: Double): Double;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadFloat(Section, Name, DefaultValue)
  else
    Result := DefaultValue;
end;

function TINIConfig.ReadBool(const Section, Name: string; DefaultValue: Boolean): Boolean;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadBool(Section, Name, DefaultValue)
  else
    Result := DefaultValue;
end;

function TINIConfig.ReadDateTime(const Section, Name: string; DefaultValue: TDateTime): TDateTime;
var
  DateStr: string;
begin
  if Assigned(FIniFile) then
  begin
    DateStr := FIniFile.ReadString(Section, Name, '');
    if DateStr <> '' then
      Result := StrToDateTimeDef(DateStr, DefaultValue)
    else
      Result := DefaultValue;
  end
  else
    Result := DefaultValue;
end;

procedure TINIConfig.WriteString(const Section, Name, Value: string);
begin
  if Assigned(FIniFile) then
  begin
    FIniFile.WriteString(Section, Name, Value);
    FModified := True;
  end;
end;

procedure TINIConfig.WriteInteger(const Section, Name: string; Value: Integer);
begin
  if Assigned(FIniFile) then
  begin
    FIniFile.WriteInteger(Section, Name, Value);
    FModified := True;
  end;
end;

procedure TINIConfig.WriteFloat(const Section, Name: string; Value: Double);
begin
  if Assigned(FIniFile) then
  begin
    FIniFile.WriteFloat(Section, Name, Value);
    FModified := True;
  end;
end;

procedure TINIConfig.WriteBool(const Section, Name: string; Value: Boolean);
begin
  if Assigned(FIniFile) then
  begin
    FIniFile.WriteBool(Section, Name, Value);
    FModified := True;
  end;
end;

procedure TINIConfig.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  if Assigned(FIniFile) then
  begin
    FIniFile.WriteString(Section, Name, DateTimeToStr(Value));
    FModified := True;
  end;
end;

end. 