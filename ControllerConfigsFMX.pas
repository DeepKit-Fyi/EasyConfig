unit ControllerConfigsFMX;
{*******************************************************************************
  复杂属性控制器 (FMX)
  - 管理复杂属性编辑器 Frame 的创建和生命周期
  - 提供属性编辑的统一入口
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.JSON,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Layouts,
  UtilsTypesFMX, ConfigFrameBaseFMX;

type
  // Frame 类引用类型
  TBaseConfigFrameFMXClass = class of TBaseConfigFrameFMX;
  
  TControllerConfigsFMX = class
  private
    class var FInstance: TControllerConfigsFMX;
    class var FFrameClassRegistry: TDictionary<TComplexPropertyType, TBaseConfigFrameFMXClass>;
  private
    FCurrentPropertyType: TComplexPropertyType;
    FCurrentJSON: TJSONObject;
    FCurrentPropertyName: string;
    FParentLayout: TLayout;
    FCurrentEditorFrame: TFrame;
    FOnEditComplete: TNotifyEvent;

    function CreateEditorFrame(APropertyType: TComplexPropertyType): TFrame;
    procedure LoadJSONToEditor;
    procedure SaveEditorToJSON;
    class procedure InitializeRegistry;
  public
    class function GetInstance: TControllerConfigsFMX;
    class procedure ReleaseInstance;

    constructor Create;
    destructor Destroy; override;

    // 设置编辑器的父容器
    procedure SetParentLayout(ALayout: TLayout);

    // 编辑已有的复杂属性
    procedure EditComplexProperty(APropertyType: TComplexPropertyType;
      const APropertyName: string; AJSON: TJSONObject;
      AOnComplete: TNotifyEvent = nil);

    // 创建新的复杂属性
    function CreateComplexProperty(APropertyType: TComplexPropertyType;
      const APropertyName: string;
      AOnComplete: TNotifyEvent = nil): TJSONObject;

    // 保存当前编辑
    procedure SaveCurrentProperty;

    // 取消当前编辑
    procedure CancelCurrentEdit;

    // 获取当前编辑状态
    property CurrentPropertyType: TComplexPropertyType read FCurrentPropertyType;
    property CurrentJSON: TJSONObject read FCurrentJSON;
    property CurrentPropertyName: string read FCurrentPropertyName;
    
    // ========== 扩展机制 ==========
    /// <summary>注册自定义 Frame 类到指定的复杂属性类型</summary>
    class procedure RegisterFrameClass(APropertyType: TComplexPropertyType; 
      AFrameClass: TBaseConfigFrameFMXClass);
    /// <summary>获取指定类型对应的 Frame 类</summary>
    class function GetFrameClassForType(APropertyType: TComplexPropertyType): TBaseConfigFrameFMXClass;
    /// <summary>检查指定类型是否已注册 Frame 类</summary>
    class function HasFrameClassForType(APropertyType: TComplexPropertyType): Boolean;
  end;

function GetControllerConfigsFMX: TControllerConfigsFMX;

implementation

uses
  FrameFontEditorFMX,
  FrameDBEditorFMX,
  FrameAIAPIEditorFMX,
  FrameBgDrawEditorFMX,
  FrameVideoClipEditorFMX;

var
  FrameList: TList;

function GetControllerConfigsFMX: TControllerConfigsFMX;
begin
  Result := TControllerConfigsFMX.GetInstance;
end;

{ TControllerConfigsFMX }

class procedure TControllerConfigsFMX.InitializeRegistry;
begin
  if FFrameClassRegistry = nil then
  begin
    FFrameClassRegistry := TDictionary<TComplexPropertyType, TBaseConfigFrameFMXClass>.Create;
    // 注册默认的 Frame 类
    FFrameClassRegistry.Add(cptFont, TFrameFontEditorFMX);
    FFrameClassRegistry.Add(cptDatabase, TFrameDBEditorFMX);
    FFrameClassRegistry.Add(cptAIAPI, TFrameAIAPIEditorFMX);
    FFrameClassRegistry.Add(cptBgDraw, TFrameBgDrawEditorFMX);
    FFrameClassRegistry.Add(cptTextOnBg, TFrameBgDrawEditorFMX);
    FFrameClassRegistry.Add(cptImageOnBg, TFrameBgDrawEditorFMX);
    FFrameClassRegistry.Add(cptCaptionOnBg, TFrameBgDrawEditorFMX);
    FFrameClassRegistry.Add(cptVideoClip, TFrameVideoClipEditorFMX);
  end;
end;

class procedure TControllerConfigsFMX.RegisterFrameClass(
  APropertyType: TComplexPropertyType; AFrameClass: TBaseConfigFrameFMXClass);
begin
  InitializeRegistry;
  FFrameClassRegistry.AddOrSetValue(APropertyType, AFrameClass);
end;

class function TControllerConfigsFMX.GetFrameClassForType(
  APropertyType: TComplexPropertyType): TBaseConfigFrameFMXClass;
begin
  InitializeRegistry;
  if not FFrameClassRegistry.TryGetValue(APropertyType, Result) then
    Result := nil;
end;

class function TControllerConfigsFMX.HasFrameClassForType(
  APropertyType: TComplexPropertyType): Boolean;
begin
  InitializeRegistry;
  Result := FFrameClassRegistry.ContainsKey(APropertyType);
end;

class function TControllerConfigsFMX.GetInstance: TControllerConfigsFMX;
begin
  if FInstance = nil then
    FInstance := TControllerConfigsFMX.Create;
  Result := FInstance;
end;

class procedure TControllerConfigsFMX.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

constructor TControllerConfigsFMX.Create;
begin
  inherited Create;
  FCurrentPropertyType := cptFont;
  FCurrentJSON := nil;
  FCurrentPropertyName := '';
  FParentLayout := nil;
  FCurrentEditorFrame := nil;
  FOnEditComplete := nil;
end;

destructor TControllerConfigsFMX.Destroy;
begin
  FreeAndNil(FCurrentJSON);
  FreeAndNil(FCurrentEditorFrame);
  inherited Destroy;
end;

procedure TControllerConfigsFMX.SetParentLayout(ALayout: TLayout);
begin
  FParentLayout := ALayout;
end;

function TControllerConfigsFMX.CreateEditorFrame(APropertyType: TComplexPropertyType): TFrame;
var
  FrameClass: TBaseConfigFrameFMXClass;
begin
  Result := nil;
  
  // 首先尝试从注册表获取 Frame 类
  FrameClass := GetFrameClassForType(APropertyType);
  if FrameClass <> nil then
  begin
    Result := FrameClass.Create(nil);
  end
  else
  begin
    // 未注册的类型，显示提示
    case APropertyType of
      cptVideo:
        ShowMessage('Video 编辑器待实现');
      cptDateTimeRange:
        ShowMessage('DateTimeRange 编辑器待实现');
      cptKeyValueDict:
        ShowMessage('KeyValueDict 编辑器待实现');
      cptUrlConfig:
        ShowMessage('UrlConfig 编辑器待实现');
      cptNetConfig:
        ShowMessage('NetConfig 编辑器待实现');
      cptGeoLocation:
        ShowMessage('GeoLocation 编辑器待实现');
      cptEncrypt:
        ShowMessage('Encrypt 编辑器待实现');
    else
      ShowMessage(Format('未知属性类型: %d', [Ord(APropertyType)]));
    end;
  end;

  // 跟踪 Frame 以便最后释放
  if Result <> nil then
  begin
    if FrameList = nil then
      FrameList := TList.Create;
    FrameList.Add(Result);
  end;
end;

procedure TControllerConfigsFMX.LoadJSONToEditor;
var
  BaseFrame: TBaseConfigFrameFMX;
begin
  if (FCurrentEditorFrame = nil) or (FCurrentJSON = nil) then Exit;

  if FCurrentEditorFrame is TBaseConfigFrameFMX then
  begin
    BaseFrame := TBaseConfigFrameFMX(FCurrentEditorFrame);
    BaseFrame.JSONObject := FCurrentJSON;
  end;
end;

procedure TControllerConfigsFMX.SaveEditorToJSON;
var
  BaseFrame: TBaseConfigFrameFMX;
begin
  if FCurrentEditorFrame = nil then Exit;

  if FCurrentEditorFrame is TBaseConfigFrameFMX then
  begin
    BaseFrame := TBaseConfigFrameFMX(FCurrentEditorFrame);
    BaseFrame.SaveToJSON;
    // JSONObject 已在 BaseFrame 内部更新
  end;
end;

procedure TControllerConfigsFMX.EditComplexProperty(
  APropertyType: TComplexPropertyType;
  const APropertyName: string;
  AJSON: TJSONObject;
  AOnComplete: TNotifyEvent);
begin
  // 保存状态
  FCurrentPropertyType := APropertyType;
  FCurrentPropertyName := APropertyName;
  FOnEditComplete := AOnComplete;

  // 克隆 JSON (避免直接修改原对象)
  FreeAndNil(FCurrentJSON);
  if AJSON <> nil then
    FCurrentJSON := TJSONObject(AJSON.Clone)
  else
    FCurrentJSON := TJSONObject.Create;

  // 释放旧的编辑器
  if FCurrentEditorFrame <> nil then
  begin
    FCurrentEditorFrame.Visible := False;
    FCurrentEditorFrame.Parent := nil;
    // 不立即释放，由 FrameList 统一管理
  end;

  // 创建新的编辑器
  FCurrentEditorFrame := CreateEditorFrame(APropertyType);
  if FCurrentEditorFrame = nil then Exit;

  // 设置父容器并显示
  if FParentLayout <> nil then
  begin
    FCurrentEditorFrame.Parent := FParentLayout;
    FCurrentEditorFrame.Align := TAlignLayout.Client;
  end;

  // 加载数据
  LoadJSONToEditor;

  // 显示
  FCurrentEditorFrame.Visible := True;
end;

function TControllerConfigsFMX.CreateComplexProperty(
  APropertyType: TComplexPropertyType;
  const APropertyName: string;
  AOnComplete: TNotifyEvent): TJSONObject;
begin
  // 创建默认 JSON 结构
  Result := TJSONObject.Create;

  case APropertyType of
    cptFont:
      begin
        Result.AddPair('_type', 'etFont');
        Result.AddPair('_id', 'etFont.' + APropertyName);
        Result.AddPair('Name', 'Microsoft YaHei');
        Result.AddPair('Size', TJSONNumber.Create(10));
        Result.AddPair('Bold', TJSONBool.Create(False));
        Result.AddPair('Italic', TJSONBool.Create(False));
        Result.AddPair('Underline', TJSONBool.Create(False));
        Result.AddPair('Color', '#FF000000');
      end;

    cptDatabase:
      begin
        Result.AddPair('_type', 'etDatabase');
        Result.AddPair('_id', 'etDatabase.' + APropertyName);
        Result.AddPair('Type', 'SQLite');
        Result.AddPair('Host', '');
        Result.AddPair('Port', TJSONNumber.Create(0));
        Result.AddPair('Database', '');
        Result.AddPair('User', '');
        Result.AddPair('Password', '');
        Result.AddPair('Options', TJSONObject.Create);
      end;

    cptAIAPI:
      begin
        Result.AddPair('_type', 'etAIAPI');
        Result.AddPair('_id', 'etAIAPI.' + APropertyName);
        Result.AddPair('Provider', 'OpenAI');
        Result.AddPair('BaseURL', 'https://api.openai.com/v1');
        Result.AddPair('APIKey', '');
        Result.AddPair('Model', 'gpt-4o');
        Result.AddPair('Temperature', TJSONNumber.Create(0.7));
        Result.AddPair('MaxTokens', TJSONNumber.Create(4096));
        Result.AddPair('TopP', TJSONNumber.Create(1.0));
        Result.AddPair('Timeout', TJSONNumber.Create(30));
        Result.AddPair('Advanced', TJSONObject.Create
          .AddPair('SystemPrompt', '')
          .AddPair('Stream', TJSONBool.Create(True)));
      end;

    cptBgDraw, cptTextOnBg, cptImageOnBg, cptCaptionOnBg:
      begin
        Result.AddPair('_type', 'etBgDraw');
        Result.AddPair('_id', 'etBgDraw.' + APropertyName);
        Result.AddPair('background', '');
        Result.AddPair('elements', TJSONArray.Create);
      end;

    cptVideoClip:
      begin
        Result.AddPair('_type', 'etVideoClip');
        Result.AddPair('_id', 'etVideoClip.' + APropertyName);
        Result.AddPair('source', '');
        Result.AddPair('start_time', TJSONNumber.Create(0));
        Result.AddPair('end_time', TJSONNumber.Create(0));
        Result.AddPair('effects', TJSONArray.Create);
      end;

    cptVideo:
      begin
        Result.AddPair('_type', 'etVideo');
        Result.AddPair('_id', 'etVideo.' + APropertyName);
        Result.AddPair('cover', '');
        Result.AddPair('ending', '');
        Result.AddPair('bg_directory', '');
        Result.AddPair('audio_directory', '');
        Result.AddPair('subtitle_file', '');
        Result.AddPair('media_settings', TJSONObject.Create);
        Result.AddPair('clips', TJSONArray.Create);
      end;

    cptDateTimeRange:
      begin
        Result.AddPair('_type', 'etDateTimeRange');
        Result.AddPair('_id', 'etDateTimeRange.' + APropertyName);
        Result.AddPair('start_date', FormatDateTime('yyyy-mm-dd', Now));
        Result.AddPair('end_date', FormatDateTime('yyyy-mm-dd', Now + 7));
        Result.AddPair('use_time', TJSONBool.Create(True));
        Result.AddPair('duration_seconds', TJSONNumber.Create(86400));
      end;

    cptKeyValueDict:
      begin
        Result.AddPair('_type', 'etKeyValueDict');
        Result.AddPair('_id', 'etKeyValueDict.' + APropertyName);
        Result.AddPair('items', TJSONObject.Create);
      end;

    cptUrlConfig:
      begin
        Result.AddPair('_type', 'etUrlConfig');
        Result.AddPair('_id', 'etUrlConfig.' + APropertyName);
        Result.AddPair('url', '');
        Result.AddPair('method', 'GET');
        Result.AddPair('headers', TJSONObject.Create);
        Result.AddPair('params', TJSONObject.Create);
      end;

    cptNetConfig:
      begin
        Result.AddPair('_type', 'etNetConfig');
        Result.AddPair('_id', 'etNetConfig.' + APropertyName);
        Result.AddPair('protocol', 'TCP');
        Result.AddPair('host', '');
        Result.AddPair('port', TJSONNumber.Create(0));
        Result.AddPair('timeout', TJSONNumber.Create(30000));
      end;

    cptGeoLocation:
      begin
        Result.AddPair('_type', 'etGeoLocation');
        Result.AddPair('_id', 'etGeoLocation.' + APropertyName);
        Result.AddPair('latitude', TJSONNumber.Create(0));
        Result.AddPair('longitude', TJSONNumber.Create(0));
        Result.AddPair('address', '');
      end;

    cptEncrypt:
      begin
        Result.AddPair('_type', 'etEncrypt');
        Result.AddPair('_id', 'etEncrypt.' + APropertyName);
        Result.AddPair('algorithm', 'AES');
        Result.AddPair('key_size', '256');
        Result.AddPair('mode', 'CBC');
        Result.AddPair('padding', 'PKCS7');
        Result.AddPair('use_iv', TJSONBool.Create(True));
      end;
  end;

  // 调用编辑
  EditComplexProperty(APropertyType, APropertyName, Result, AOnComplete);
end;

procedure TControllerConfigsFMX.SaveCurrentProperty;
begin
  SaveEditorToJSON;
  if Assigned(FOnEditComplete) then
    FOnEditComplete(Self);
end;

procedure TControllerConfigsFMX.CancelCurrentEdit;
begin
  if FCurrentEditorFrame <> nil then
    FCurrentEditorFrame.Visible := False;
end;

initialization

finalization
  TControllerConfigsFMX.ReleaseInstance;
  if TControllerConfigsFMX.FFrameClassRegistry <> nil then
  begin
    TControllerConfigsFMX.FFrameClassRegistry.Free;
    TControllerConfigsFMX.FFrameClassRegistry := nil;
  end;
  if FrameList <> nil then
  begin
    // Frame 已经被各自的 Owner 或手动释放
    FrameList.Free;
    FrameList := nil;
  end;

end.
