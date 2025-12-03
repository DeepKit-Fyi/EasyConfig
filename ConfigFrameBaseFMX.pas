unit ConfigFrameBaseFMX;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FMX.Types, FMX.Controls,
  FMX.Forms, FMX.StdCtrls, FMX.Layouts, UtilsTypesFMX;

type
  /// <summary>
  /// FMX 配置编辑器 Frame 基类
  /// 所有复杂属性编辑器 Frame 必须继承此类
  /// </summary>
  TBaseConfigFrameFMX = class(TFrame)
  private
    FJSONObject: TJSONObject;
    FOnModified: TNotifyEvent;
    FModified: Boolean;
    FPropertyPath: string;
    FPropertyName: string;
    FUpdateCount: Integer;
    procedure SetModified(const Value: Boolean);
  protected
    /// <summary>
    /// 子类重写此方法以创建控件
    /// </summary>
    procedure CreateControls; virtual;
    /// <summary>
    /// 控件值改变时调用此方法
    /// </summary>
    procedure DoModified(Sender: TObject); virtual;
    /// <summary>
    /// 获取JSON中的字符串值
    /// </summary>
    function GetJSONString(const Key: string; const Default: string = ''): string;
    /// <summary>
    /// 获取JSON中的整数值
    /// </summary>
    function GetJSONInt(const Key: string; Default: Integer = 0): Integer;
    /// <summary>
    /// 获取JSON中的浮点值
    /// </summary>
    function GetJSONFloat(const Key: string; Default: Double = 0): Double;
    /// <summary>
    /// 获取JSON中的布尔值
    /// </summary>
    function GetJSONBool(const Key: string; Default: Boolean = False): Boolean;
    /// <summary>
    /// 设置JSON字符串值
    /// </summary>
    procedure SetJSONString(const Key, Value: string);
    /// <summary>
    /// 设置JSON整数值
    /// </summary>
    procedure SetJSONInt(const Key: string; Value: Integer);
    /// <summary>
    /// 设置JSON浮点值
    /// </summary>
    procedure SetJSONFloat(const Key: string; Value: Double);
    /// <summary>
    /// 设置JSON布尔值
    /// </summary>
    procedure SetJSONBool(const Key: string; Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    /// <summary>
    /// 从 JSON 对象加载数据到控件
    /// 子类必须重写此方法
    /// </summary>
    procedure LoadFromJSON; overload; virtual;
    procedure LoadFromJSON(const AJSON: TJSONObject); overload; virtual;
    /// <summary>
    /// 将控件数据保存到 JSON 对象
    /// 子类必须重写此方法
    /// </summary>
    procedure SaveToJSON; virtual;
    /// <summary>
    /// 将控件数据保存到新的 JSON 对象并返回
    /// </summary>
    function SaveToNewJSON: TJSONObject; virtual;
    /// <summary>
    /// 验证当前编辑的数据
    /// </summary>
    function Validate(out ErrorMsg: string): Boolean; virtual;
    /// <summary>
    /// 设置JSON对象并加载数据
    /// </summary>
    procedure SetJSONObject(const Value: TJSONObject);
    /// <summary>
    /// 获取编辑器类型
    /// 子类必须重写此方法
    /// </summary>
    function GetEditorType: TEditorType; virtual;
    /// <summary>
    /// 获取编辑器显示名称
    /// </summary>
    function GetDisplayName: string; virtual;
    /// <summary>
    /// 清空编辑器
    /// </summary>
    procedure Clear; virtual;
    /// <summary>
    /// 开始批量更新（防止频繁刷新）
    /// </summary>
    procedure BeginUpdate;
    /// <summary>
    /// 结束批量更新
    /// </summary>
    procedure EndUpdate;
    /// <summary>
    /// 标记为已修改（无参数版本）
    /// </summary>
    procedure MarkModified; virtual;
    
    property JSONObject: TJSONObject read FJSONObject write SetJSONObject;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property Modified: Boolean read FModified write SetModified;
    property PropertyPath: string read FPropertyPath write FPropertyPath;
    property PropertyName: string read FPropertyName write FPropertyName;
  end;
  
  TBaseConfigFrameFMXClass = class of TBaseConfigFrameFMX;

  // 别名，便于代码兼容
  TConfigFrameBaseFMX = TBaseConfigFrameFMX;
  TConfigFrameBaseFMXClass = TBaseConfigFrameFMXClass;

// JSON 帮助函数（全局）
function GetJSONString(JSONObj: TJSONObject; const Key: string; const Default: string = ''): string;
function GetJSONInt(JSONObj: TJSONObject; const Key: string; Default: Integer = 0): Integer;
function GetJSONFloat(JSONObj: TJSONObject; const Key: string; Default: Double = 0): Double;
function GetJSONBool(JSONObj: TJSONObject; const Key: string; Default: Boolean = False): Boolean;

implementation

{ TBaseConfigFrameFMX }

constructor TBaseConfigFrameFMX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJSONObject := nil;
  FModified := False;
  FPropertyPath := '';
  FPropertyName := '';
  FUpdateCount := 0;
end;

destructor TBaseConfigFrameFMX.Destroy;
begin
  inherited;
end;

procedure TBaseConfigFrameFMX.SetJSONObject(const Value: TJSONObject);
begin
  FJSONObject := Value;
  FModified := False;
  if Assigned(FJSONObject) then
    LoadFromJSON
  else
    Clear;
end;

procedure TBaseConfigFrameFMX.SetModified(const Value: Boolean);
begin
  if FModified <> Value then
  begin
    FModified := Value;
    if FModified and Assigned(FOnModified) then
      FOnModified(Self);
  end;
end;

procedure TBaseConfigFrameFMX.LoadFromJSON;
begin
  // 无参数版本调用有参数版本
  LoadFromJSON(FJSONObject);
end;

procedure TBaseConfigFrameFMX.LoadFromJSON(const AJSON: TJSONObject);
begin
  // 基类中不实现具体逻辑，子类重写
end;

procedure TBaseConfigFrameFMX.SaveToJSON;
begin
  // 基类中不实现具体逻辑，子类重写
end;

function TBaseConfigFrameFMX.SaveToNewJSON: TJSONObject;
begin
  // 基类返回空对象，子类重写
  Result := TJSONObject.Create;
end;

function TBaseConfigFrameFMX.Validate(out ErrorMsg: string): Boolean;
begin
  // 默认验证通过，子类可重写
  ErrorMsg := '';
  Result := True;
end;

procedure TBaseConfigFrameFMX.CreateControls;
begin
  // 基类中不实现具体逻辑，子类重写
end;

procedure TBaseConfigFrameFMX.DoModified(Sender: TObject);
begin
  Modified := True;
end;

procedure TBaseConfigFrameFMX.Clear;
begin
  // 基类中不实现具体逻辑，子类重写
  FModified := False;
end;

procedure TBaseConfigFrameFMX.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TBaseConfigFrameFMX.EndUpdate;
begin
  if FUpdateCount > 0 then
    Dec(FUpdateCount);
end;

procedure TBaseConfigFrameFMX.MarkModified;
begin
  if FUpdateCount = 0 then
    Modified := True;
end;

function TBaseConfigFrameFMX.GetEditorType: TEditorType;
begin
  Result := etFrame;
end;

function TBaseConfigFrameFMX.GetDisplayName: string;
begin
  Result := GetEditorTypeDisplayName(GetEditorType);
end;

function TBaseConfigFrameFMX.GetJSONString(const Key: string; const Default: string): string;
begin
  Result := Default;
  if Assigned(FJSONObject) then
    FJSONObject.TryGetValue(Key, Result);
end;

function TBaseConfigFrameFMX.GetJSONInt(const Key: string; Default: Integer): Integer;
begin
  Result := Default;
  if Assigned(FJSONObject) then
    FJSONObject.TryGetValue(Key, Result);
end;

function TBaseConfigFrameFMX.GetJSONFloat(const Key: string; Default: Double): Double;
begin
  Result := Default;
  if Assigned(FJSONObject) then
    FJSONObject.TryGetValue(Key, Result);
end;

function TBaseConfigFrameFMX.GetJSONBool(const Key: string; Default: Boolean): Boolean;
begin
  Result := Default;
  if Assigned(FJSONObject) then
    FJSONObject.TryGetValue(Key, Result);
end;

procedure TBaseConfigFrameFMX.SetJSONString(const Key, Value: string);
begin
  if not Assigned(FJSONObject) then
    FJSONObject := TJSONObject.Create;
    
  if FJSONObject.GetValue(Key) <> nil then
    FJSONObject.RemovePair(Key);
  FJSONObject.AddPair(Key, Value);
end;

procedure TBaseConfigFrameFMX.SetJSONInt(const Key: string; Value: Integer);
begin
  if not Assigned(FJSONObject) then
    FJSONObject := TJSONObject.Create;
    
  if FJSONObject.GetValue(Key) <> nil then
    FJSONObject.RemovePair(Key);
  FJSONObject.AddPair(Key, TJSONNumber.Create(Value));
end;

procedure TBaseConfigFrameFMX.SetJSONFloat(const Key: string; Value: Double);
begin
  if not Assigned(FJSONObject) then
    FJSONObject := TJSONObject.Create;
    
  if FJSONObject.GetValue(Key) <> nil then
    FJSONObject.RemovePair(Key);
  FJSONObject.AddPair(Key, TJSONNumber.Create(Value));
end;

procedure TBaseConfigFrameFMX.SetJSONBool(const Key: string; Value: Boolean);
begin
  if not Assigned(FJSONObject) then
    FJSONObject := TJSONObject.Create;
    
  if FJSONObject.GetValue(Key) <> nil then
    FJSONObject.RemovePair(Key);
  FJSONObject.AddPair(Key, TJSONBool.Create(Value));
end;

// ============================================================================
// 全局 JSON 帮助函数实现
// ============================================================================

function GetJSONString(JSONObj: TJSONObject; const Key: string; const Default: string = ''): string;
begin
  Result := Default;
  if Assigned(JSONObj) then
    JSONObj.TryGetValue(Key, Result);
end;

function GetJSONInt(JSONObj: TJSONObject; const Key: string; Default: Integer = 0): Integer;
begin
  Result := Default;
  if Assigned(JSONObj) then
    JSONObj.TryGetValue(Key, Result);
end;

function GetJSONFloat(JSONObj: TJSONObject; const Key: string; Default: Double = 0): Double;
begin
  Result := Default;
  if Assigned(JSONObj) then
    JSONObj.TryGetValue(Key, Result);
end;

function GetJSONBool(JSONObj: TJSONObject; const Key: string; Default: Boolean = False): Boolean;
begin
  Result := Default;
  if Assigned(JSONObj) then
    JSONObj.TryGetValue(Key, Result);
end;

end.
