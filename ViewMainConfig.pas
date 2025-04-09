unit ViewMainConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ViewBuildConfig, FrameConfigEditor, ConfigIntf,
  System.IniFiles, System.JSON, System.IOUtils, ConfigTypes;

type
  TForm1 = class(TForm)
    pnlMain: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FConfigFrame: TViewBuildConfig;
    FConfigEditorFrame: TframeConfigEditor;
    FINIConfig: IINIConfig;
    FJSONConfig: IJSONConfig;
    procedure UpdatePanelCaption(APanel: TPanel; const NewCaption: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  // 简单的 INIConfig 实现
  TSimpleINIConfig = class(TInterfacedObject, IINIConfig)
  private
    FFileName: string;
    FModified: Boolean;
    FIniFile: TIniFile;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;

    // IINIConfig 接口实现
    function Exists: Boolean;
    function CreateFile: Boolean;
    function Reload: Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: string): Boolean;
    
    function ReadString(const Section, Name, DefaultValue: string): string;
    function ReadInteger(const Section, Name: string; DefaultValue: Integer): Integer;
    function ReadFloat(const Section, Name: string; DefaultValue: Double): Double;
    function ReadBool(const Section, Name: string; DefaultValue: Boolean): Boolean;
    function ReadDateTime(const Section, Name: string; DefaultValue: TDateTime): TDateTime;
    
    procedure WriteString(const Section, Name, Value: string);
    procedure WriteInteger(const Section, Name: string; Value: Integer);
    procedure WriteFloat(const Section, Name: string; Value: Double);
    procedure WriteBool(const Section, Name: string; Value: Boolean);
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime);
    
    function SectionExists(const Section: string): Boolean;
    function KeyExists(const Section, Name: string): Boolean;
    procedure DeleteKey(const Section, Name: string);
    procedure DeleteSection(const Section: string);
    function ReadSections: TStrings;
    function ReadSection(const Section: string): TStrings;
    
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
  end;

  // 简单的 JSONConfig 实现
  TSimpleJSONConfig = class(TInterfacedObject, IJSONConfig)
  private
    FFileName: string;
    FModified: Boolean;
    FRoot: TJSONObject;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;

    // IJSONConfig 接口实现
    function Exists: Boolean;
    function CreateFile: Boolean;
    function Reload: Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: string): Boolean;
    
    function ReadString(const Path: string; const DefaultValue: string = ''): string;
    function ReadInteger(const Path: string; DefaultValue: Integer = 0): Integer;
    function ReadFloat(const Path: string; DefaultValue: Double = 0): Double;
    function ReadBoolean(const Path: string; DefaultValue: Boolean = False): Boolean;
    function ReadDateTime(const Path: string; DefaultValue: TDateTime = 0): TDateTime;
    function ReadJSONValue(const Path: string): TJSONValue;
    
    procedure WriteString(const Path, Value: string);
    procedure WriteInteger(const Path: string; Value: Integer);
    procedure WriteFloat(const Path: string; Value: Double);
    procedure WriteBoolean(const Path: string; Value: Boolean);
    procedure WriteDateTime(const Path: string; Value: TDateTime);
    procedure WriteObject(const Path: string; Value: TJSONObject);
    procedure WriteJSONValue(const Path: string; Value: TJSONValue);
    
    function PathExists(const Path: string): Boolean;
    procedure DeletePath(const Path: string);
    
    function GetRoot: TJSONObject;
    
    function GetConfigType(const Section, Key: string): TConfigType;
    function GetJSONObject(const Section, Key: string): TJSONObject;
    
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
  end;

{ TSimpleINIConfig }

constructor TSimpleINIConfig.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FModified := False;
  FIniFile := TIniFile.Create(FFileName);
end;

destructor TSimpleINIConfig.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TSimpleINIConfig.Exists: Boolean;
begin
  Result := FileExists(FFileName);
end;

function TSimpleINIConfig.CreateFile: Boolean;
begin
  Result := True;
  if not FileExists(FFileName) then
  begin
    try
      FIniFile.UpdateFile;
      Result := FileExists(FFileName);
    except
      Result := False;
    end;
  end;
end;

function TSimpleINIConfig.Reload: Boolean;
begin
  Result := True;
  try
    FIniFile.Free;
    FIniFile := TIniFile.Create(FFileName);
  except
    Result := False;
  end;
end;

function TSimpleINIConfig.Save: Boolean;
begin
  Result := True;
  try
    FIniFile.UpdateFile;
    FModified := False;
  except
    Result := False;
  end;
end;

function TSimpleINIConfig.SaveToFile(const FileName: string): Boolean;
begin
  Result := False;
  // 简单实现，实际应用中可以实现文件复制或其他保存逻辑
end;

function TSimpleINIConfig.ReadString(const Section, Name, DefaultValue: string): string;
begin
  Result := FIniFile.ReadString(Section, Name, DefaultValue);
end;

function TSimpleINIConfig.ReadInteger(const Section, Name: string; DefaultValue: Integer): Integer;
begin
  Result := FIniFile.ReadInteger(Section, Name, DefaultValue);
end;

function TSimpleINIConfig.ReadFloat(const Section, Name: string; DefaultValue: Double): Double;
begin
  Result := FIniFile.ReadFloat(Section, Name, DefaultValue);
end;

function TSimpleINIConfig.ReadBool(const Section, Name: string; DefaultValue: Boolean): Boolean;
begin
  Result := FIniFile.ReadBool(Section, Name, DefaultValue);
end;

function TSimpleINIConfig.ReadDateTime(const Section, Name: string; DefaultValue: TDateTime): TDateTime;
begin
  Result := FIniFile.ReadDateTime(Section, Name, DefaultValue);
end;

procedure TSimpleINIConfig.WriteString(const Section, Name, Value: string);
begin
  FIniFile.WriteString(Section, Name, Value);
  FModified := True;
end;

procedure TSimpleINIConfig.WriteInteger(const Section, Name: string; Value: Integer);
begin
  FIniFile.WriteInteger(Section, Name, Value);
  FModified := True;
end;

procedure TSimpleINIConfig.WriteFloat(const Section, Name: string; Value: Double);
begin
  FIniFile.WriteFloat(Section, Name, Value);
  FModified := True;
end;

procedure TSimpleINIConfig.WriteBool(const Section, Name: string; Value: Boolean);
begin
  FIniFile.WriteBool(Section, Name, Value);
  FModified := True;
end;

procedure TSimpleINIConfig.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  FIniFile.WriteDateTime(Section, Name, Value);
  FModified := True;
end;

function TSimpleINIConfig.SectionExists(const Section: string): Boolean;
begin
  Result := FIniFile.SectionExists(Section);
end;

function TSimpleINIConfig.KeyExists(const Section, Name: string): Boolean;
begin
  Result := FIniFile.ValueExists(Section, Name);
end;

procedure TSimpleINIConfig.DeleteKey(const Section, Name: string);
begin
  FIniFile.DeleteKey(Section, Name);
  FModified := True;
end;

procedure TSimpleINIConfig.DeleteSection(const Section: string);
begin
  FIniFile.EraseSection(Section);
  FModified := True;
end;

function TSimpleINIConfig.ReadSections: TStrings;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    FIniFile.ReadSections(Strings);
    Result := Strings;
  except
    Strings.Free;
    Result := nil;
  end;
end;

function TSimpleINIConfig.ReadSection(const Section: string): TStrings;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    FIniFile.ReadSection(Section, Strings);
    Result := Strings;
  except
    Strings.Free;
    Result := nil;
  end;
end;

function TSimpleINIConfig.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TSimpleINIConfig.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    Reload;
  end;
end;

function TSimpleINIConfig.GetModified: Boolean;
begin
  Result := FModified;
end;

procedure TSimpleINIConfig.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

{ TSimpleJSONConfig }

constructor TSimpleJSONConfig.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FModified := False;
  FRoot := TJSONObject.Create;
  
  // 尝试加载文件
  if FileExists(AFileName) then
  begin
    try
      var JsonStr := TFile.ReadAllText(AFileName);
      var JsonValue := TJSONObject.ParseJSONValue(JsonStr);
      if Assigned(JsonValue) and (JsonValue is TJSONObject) then
      begin
        FRoot.Free;
        FRoot := TJSONObject(JsonValue);
      end
      else
        JsonValue.Free;
    except
      // 忽略加载错误
    end;
  end;
end;

destructor TSimpleJSONConfig.Destroy;
begin
  FRoot.Free;
  inherited;
end;

function TSimpleJSONConfig.Exists: Boolean;
begin
  Result := FileExists(FFileName);
end;

function TSimpleJSONConfig.CreateFile: Boolean;
begin
  Result := True;
  if not FileExists(FFileName) then
  begin
    try
      Save;
      Result := FileExists(FFileName);
    except
      Result := False;
    end;
  end;
end;

function TSimpleJSONConfig.Reload: Boolean;
begin
  Result := True;
  try
    FRoot.Free;
    FRoot := TJSONObject.Create;
    if FileExists(FFileName) then
    begin
      var JsonStr := TFile.ReadAllText(FFileName);
      var JsonValue := TJSONObject.ParseJSONValue(JsonStr);
      if Assigned(JsonValue) and (JsonValue is TJSONObject) then
        FRoot := TJSONObject(JsonValue)
      else
        JsonValue.Free;
    end;
  except
    Result := False;
  end;
end;

function TSimpleJSONConfig.Save: Boolean;
begin
  Result := True;
  try
    var JsonStr := FRoot.Format(2);
    TFile.WriteAllText(FFileName, JsonStr);
    FModified := False;
  except
    Result := False;
  end;
end;

function TSimpleJSONConfig.SaveToFile(const FileName: string): Boolean;
begin
  Result := False;
  try
    var JsonStr := FRoot.Format(2);
    TFile.WriteAllText(FileName, JsonStr);
    Result := True;
  except
    // 忽略保存错误
  end;
end;

function TSimpleJSONConfig.ReadString(const Path: string; const DefaultValue: string): string;
begin
  Result := DefaultValue;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

function TSimpleJSONConfig.ReadInteger(const Path: string; DefaultValue: Integer): Integer;
begin
  Result := DefaultValue;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

function TSimpleJSONConfig.ReadFloat(const Path: string; DefaultValue: Double): Double;
begin
  Result := DefaultValue;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

function TSimpleJSONConfig.ReadBoolean(const Path: string; DefaultValue: Boolean): Boolean;
begin
  Result := DefaultValue;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

function TSimpleJSONConfig.ReadDateTime(const Path: string; DefaultValue: TDateTime): TDateTime;
begin
  Result := DefaultValue;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

function TSimpleJSONConfig.ReadJSONValue(const Path: string): TJSONValue;
begin
  Result := nil;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

procedure TSimpleJSONConfig.WriteString(const Path, Value: string);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteInteger(const Path: string; Value: Integer);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteFloat(const Path: string; Value: Double);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteBoolean(const Path: string; Value: Boolean);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteDateTime(const Path: string; Value: TDateTime);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteObject(const Path: string; Value: TJSONObject);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

procedure TSimpleJSONConfig.WriteJSONValue(const Path: string; Value: TJSONValue);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

function TSimpleJSONConfig.PathExists(const Path: string): Boolean;
begin
  Result := False;
  // 简单实现，实际应用中需要实现路径解析逻辑
end;

procedure TSimpleJSONConfig.DeletePath(const Path: string);
begin
  // 简单实现，实际应用中需要实现路径解析逻辑
  FModified := True;
end;

function TSimpleJSONConfig.GetRoot: TJSONObject;
begin
  Result := FRoot;
end;

function TSimpleJSONConfig.GetConfigType(const Section, Key: string): TConfigType;
begin
  // 默认返回文本类型
  Result := ctPlain;
  
  // 简单实现，根据键名前缀判断类型
  if Key.StartsWith('ctFont.') then
    Result := ctFont
  else if Key.StartsWith('ctColor.') then
    Result := ctColor
  else if Key.StartsWith('ctInteger.') then
    Result := ctInteger
  else if Key.StartsWith('ctFloat.') then
    Result := ctFloat
  else if Key.StartsWith('ctBoolean.') then
    Result := ctBoolean
  else if Key.StartsWith('ctDatabase.') then
    Result := ctDatabase
  else if Key.StartsWith('ctList.') then
    Result := ctList
  else if Key.StartsWith('ctObject.') then
    Result := ctObject
  else if Key.StartsWith('ctArray.') then
    Result := ctArray
  else if Key.StartsWith('ctAIAPI.') then
    Result := ctAIAPI;
end;

function TSimpleJSONConfig.GetJSONObject(const Section, Key: string): TJSONObject;
var
  ResultObj: TJSONObject;
begin
  ResultObj := TJSONObject.Create;
  
  // 根据类型创建不同的JSON对象
  case GetConfigType(Section, Key) of
    ctPlain:
      begin
        ResultObj.AddPair('_type', 'ctPlain');
        ResultObj.AddPair('value', '');
      end;
    ctFont:
      begin
        ResultObj.AddPair('_type', 'ctFont');
        ResultObj.AddPair('name', 'Arial');
        ResultObj.AddPair('size', TJSONNumber.Create(10));
        ResultObj.AddPair('bold', TJSONBool.Create(False));
        ResultObj.AddPair('italic', TJSONBool.Create(False));
        ResultObj.AddPair('underline', TJSONBool.Create(False));
        ResultObj.AddPair('color', '#000000');
      end;
    ctColor:
      begin
        ResultObj.AddPair('_type', 'ctColor');
        ResultObj.AddPair('value', '#000000');
      end;
    ctInteger:
      begin
        ResultObj.AddPair('_type', 'ctInteger');
        ResultObj.AddPair('value', TJSONNumber.Create(0));
      end;
    ctFloat:
      begin
        ResultObj.AddPair('_type', 'ctFloat');
        ResultObj.AddPair('value', TJSONNumber.Create(0.0));
      end;
    ctBoolean:
      begin
        ResultObj.AddPair('_type', 'ctBoolean');
        ResultObj.AddPair('value', TJSONBool.Create(False));
      end;
    ctDatabase:
      begin
        ResultObj.AddPair('_type', 'ctDatabase');
        ResultObj.AddPair('connectionString', '');
        ResultObj.AddPair('provider', '');
        ResultObj.AddPair('database', '');
        ResultObj.AddPair('username', '');
        ResultObj.AddPair('password', '');
        ResultObj.AddPair('server', '');
        ResultObj.AddPair('port', TJSONNumber.Create(0));
      end;
    ctList:
      begin
        ResultObj.AddPair('_type', 'ctList');
        ResultObj.AddPair('value', TJSONArray.Create);
      end;
    ctObject:
      begin
        ResultObj.AddPair('_type', 'ctObject');
        ResultObj.AddPair('properties', TJSONObject.Create);
      end;
    ctArray:
      begin
        ResultObj.AddPair('_type', 'ctArray');
        ResultObj.AddPair('itemType', 'string');
        ResultObj.AddPair('items', TJSONArray.Create);
      end;
    ctAIAPI:
      begin
        ResultObj.AddPair('_type', 'ctAIAPI');
        ResultObj.AddPair('apiKey', '');
        ResultObj.AddPair('endpoint', '');
        ResultObj.AddPair('provider', '');
        ResultObj.AddPair('model', '');
      end;
  end;
  
  Result := ResultObj;
end;

function TSimpleJSONConfig.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TSimpleJSONConfig.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    Reload;
  end;
end;

function TSimpleJSONConfig.GetModified: Boolean;
begin
  Result := FModified;
end;

procedure TSimpleJSONConfig.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

procedure TForm1.UpdatePanelCaption(APanel: TPanel; const NewCaption: string);
begin
  // 避免面板标题显示在子控件上
  if APanel <> nil then
    APanel.Caption := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  INIFileName, JSONFileName: string;
begin
  try
    // 设置窗体属性
    Self.Caption := '配置管理工具';
    Self.Width := 900;
    Self.Height := 600;
    
    // 调整面板布局
    if Assigned(pnlMain) then
    begin
      pnlMain.Align := alClient;
      pnlMain.BevelOuter := bvNone;
    end;
    
    if Assigned(Panel3) then
    begin
      Panel3.Align := alBottom;
      Panel3.Height := 40;
      Panel3.BevelOuter := bvNone;
    end;
    
    if Assigned(Panel5) then
    begin
      Panel5.Align := alTop;
      Panel5.Height := 40;
      Panel5.BevelOuter := bvNone;
    end;
    
    if Assigned(Panel4) then
    begin
      Panel4.Align := alLeft;
      Panel4.Width := 250; // 增加左侧面板宽度以便更好显示
      Panel4.BevelOuter := bvNone;
      Panel4.Visible := True; // 确保左侧面板可见
    end;
    
    // 清除面板标题，避免显示在子控件上
    UpdatePanelCaption(pnlMain, '');
    UpdatePanelCaption(Panel3, '');
    UpdatePanelCaption(Panel4, '');
    UpdatePanelCaption(Panel5, '');
    
    // 使用 try-except 处理可能的运行时错误
    try
      // 创建配置框架
      FConfigFrame := TViewBuildConfig.Create(Self);
      if Assigned(FConfigFrame) then
      begin
        FConfigFrame.Parent := pnlMain;
        FConfigFrame.Align := alClient;
        FConfigFrame.Visible := True;
      end;
      
      // 创建配置编辑器框架
      FConfigEditorFrame := TframeConfigEditor.Create(Self);
      if Assigned(FConfigEditorFrame) and Assigned(Panel4) then
      begin
        FConfigEditorFrame.Parent := Panel4;
        FConfigEditorFrame.Align := alClient;
        FConfigEditorFrame.Visible := True;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('创建界面组件时出错: ' + E.Message);
        Exit;
      end;
    end;
    
    // 使用Application.ProcessMessages刷新界面确保正确显示
    Application.ProcessMessages;
    
    // 初始化接口实现
    INIFileName := ExtractFilePath(Application.ExeName) + 'config.ini';
    JSONFileName := ChangeFileExt(INIFileName, '.json');
    
    // 创建接口实现
    try
      // 创建实际的实现类
      FINIConfig := TSimpleINIConfig.Create(INIFileName);
      FJSONConfig := TSimpleJSONConfig.Create(JSONFileName);
      
      // 设置接口给编辑器
      if Assigned(FConfigEditorFrame) then
      begin
        FConfigEditorFrame.SetINIConfig(FINIConfig);
        FConfigEditorFrame.SetJSONConfig(FJSONConfig);
      end;
    except
      on E: Exception do
        ShowMessage('初始化配置接口出错: ' + E.Message);
    end;
    
    // 确保RowCount大于FixedRows
    if Assigned(FConfigFrame) and 
       Assigned(FConfigFrame.sgINI) and 
       (FConfigFrame.sgINI.RowCount <= FConfigFrame.sgINI.FixedRows) then
    begin
      FConfigFrame.sgINI.RowCount := FConfigFrame.sgINI.FixedRows + 1;
      
      // 添加测试数据
      FConfigFrame.sgINI.Cells[0, 1] := '测试节点';
      FConfigFrame.sgINI.Cells[1, 1] := '测试键';
      FConfigFrame.sgINI.Cells[2, 1] := '测试值';
    end;
  except
    on E: Exception do
      ShowMessage('初始化主窗体时出错: ' + E.Message);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // 释放接口引用 - 由于是使用接口引用，设为 nil 会自动释放实现对象
  FINIConfig := nil;
  FJSONConfig := nil;
  
  // 如果这些组件未在其他地方释放，确保释放它们
  if Assigned(FConfigEditorFrame) and not (csDestroying in ComponentState) then
    FConfigEditorFrame.Free;
    
  if Assigned(FConfigFrame) and not (csDestroying in ComponentState) then
    FConfigFrame.Free;
end;

end.
