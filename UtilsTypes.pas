unit UtilsTypes;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Graphics, Winapi.Windows;

type
  // 配置格式枚举
  TConfigFormat = (cfINI, cfJSON);

  /// <summary>
  /// 配置项类型枚举
  /// </summary>
  TConfigType = (
    ctPlain,      // 普通文本类型
    ctInteger,    // 整数类型
    ctFloat,      // 浮点数类型
    ctBoolean,    // 布尔类型
    ctFont,       // 字体类型
    ctColor,      // 颜色类型
    ctDatabase,   // 数据库连接类型
    ctList,       // 列表类型
    ctObject,     // 对象类型
    ctAIAPI,      // AI API设置类型
    ctArray       // 数组类型
  );
  
  // 配置类型枚举，对应ini_json_rules.md中定义的类型
  TConfigGroupType = (
    cgtSimple,     // 简单类型（存储在INI文件中）
    cgtComplex     // 复杂类型（存储在JSON文件中）
  );
  
  // 位置属性结构，用于所有需要位置的类型（etTextOnBG、etImageOnBG、etDrawerOnBG等）
  TPositionAttributes = record
    X: Integer;          // X坐标
    Y: Integer;          // Y坐标
    IsXCenter: Boolean;  // X是否居中
    IsYCenter: Boolean;  // Y是否居中
    Scale: Double;       // 缩放比例
    ZIndex: Integer;     // Z序（层叠顺序）
    
    procedure SetDefaults;
  end;
  
  // 配置对象元数据
  TConfigObjectMeta = class
  public
    Name: string;        // 配置类型名称
    Description: string; // 配置类型描述
    Category: Integer;   // 类别索引(用于分组)
    Format: TConfigFormat; // 存储格式
    ConfigType: TConfigType; // 配置类型
    EditorClass: TClass; // 编辑器类
    
    constructor Create(const AName, ADescription: string; 
                       ACategory: Integer; AFormat: TConfigFormat;
                       AConfigType: TConfigType; AEditorClass: TClass);
  end;
  
  // 配置对象基类
  TConfigObject = class abstract
  protected
    FID: string;
    FName: string;
    FFileName: string;
    FTypeID: string;
    FModified: Boolean;
    FConfigType: TConfigType;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string; AConfigType: TConfigType); virtual;
    
    // 加载与保存
    function Load: Boolean; virtual; abstract;
    function Save: Boolean; virtual; abstract;
    
    // 验证
    function Validate: Boolean; virtual;
    function GetValidationErrors: TArray<string>; virtual;
    
    // 属性
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property FileName: string read FFileName write FFileName;
    property TypeID: string read FTypeID;
    property Modified: Boolean read FModified write FModified;
    property ConfigType: TConfigType read FConfigType;
  end;
  
  TConfigObjectClass = class of TConfigObject;

  // 位置信息记录类型
  TPositionInfo = record
    X: Integer;
    Y: Integer;
    IsXCenter: Boolean;
    IsYCenter: Boolean;
    Scale: Double;
    ZIndex: Integer;
  end;

  // 编辑器类型枚举 - 扩展以包含所有复杂属性类型
  TEditorType = (
    etPlain,      // 普通类型
    etFont,       // 字体
    etColor,      // 颜色
    etDatabase,   // 数据库
    etList,       // 列表
    etObject,     // 对象
    etArray,      // 数组
    etAIAPI,      // AI/API配置
    etRootNode,   // 根节点
    etSecurity,   // 安全设置
    etModule,     // 模块
    
    // 新增复杂属性类型
    etDateTimeRange,    // 日期时间范围
    etKeyValueDict,     // 键值对字典
    etUrlConfig,        // URL配置
    etPermission,       // 权限/访问控制
    etNetConfig,        // 网络配置
    etEncrypt,          // 加密/安全设置
    etGeoLocation,      // 地理位置数据
    etMediaSettings,    // 多媒体设置
    etChartConfig,      // 图表/可视化配置
    etWorkflow,         // 工作流/流程定义
    etSchedule,         // 定时任务/调度
    etI18n,             // 国际化/本地化设置
    etUnitConversion,   // 单元/度量转换
    etVersionControl,   // 版本控制设置
    
    // 优先实现的复杂属性
    etBgDraw,           // 背景图上绘制
    etTextOnBg,         // 背景图上的文字
    etImageOnBg,        // 背景图上的图片
    etCaptionOnBg,      // 背景图上的字幕
    etVideoClip,        // 视频片段
    etVideo             // 完整视频
  );

  // 复杂属性枚举 - 用于按钮的Tag属性
  TComplexPropertyType = (
    cptFont = 0,            // 字体
    cptColor = 1,           // 颜色
    cptDatabase = 2,        // 数据库
    cptList = 3,            // 列表
    cptObject = 4,          // 对象
    cptArray = 5,           // 数组
    cptAPI = 6,             // API
    cptRootNode = 7,        // 根节点
    cptSecurity = 8,        // 安全
    cptAI = 9,              // 人工智能
    cptModule = 10,         // 模块
    
    // 新增复杂属性类型
    cptDateTimeRange = 11,  // 日期时间范围
    cptKeyValueDict = 12,   // 键值对字典
    cptUrlConfig = 13,      // URL配置
    cptPermission = 14,     // 权限/访问控制
    cptNetConfig = 15,      // 网络配置
    cptEncrypt = 16,        // 加密/安全设置
    cptGeoLocation = 17,    // 地理位置数据
    cptMediaSettings = 18,  // 多媒体设置
    cptChartConfig = 19,    // 图表/可视化配置
    cptWorkflow = 20,       // 工作流/流程定义
    cptSchedule = 21,       // 定时任务/调度
    cptI18n = 22,           // 国际化/本地化设置
    cptUnitConversion = 23, // 单元/度量转换
    cptVersionControl = 24, // 版本控制设置
    
    // 优先实现的复杂属性
    cptBgDraw = 25,         // 背景图上绘制
    cptTextOnBg = 26,       // 背景图上的文字
    cptImageOnBg = 27,      // 背景图上的图片
    cptCaptionOnBg = 28,    // 背景图上的字幕
    cptVideoClip = 29,      // 视频片段
    cptVideo = 30           // 完整视频
  );

  // 配置属性项记录
  TConfigPropertyItem = record
    PropertyName: string;
    PropertyType: string;
    PropertyValue: string;
    EditorType: TEditorType;
    PropertyPath: string;
  end;
  PConfigPropertyItem = ^TConfigPropertyItem;

// TConfigType常量别名，用于与旧代码兼容
const
  etText = ctPlain;
  etNumber = ctInteger;
  etInteger = ctInteger;
  etFloat = ctFloat;
  etBoolean = ctBoolean;
  etEnum = ctPlain;
  etDateTime = ctPlain;
  etTimeSpan = ctPlain;
  etFile = ctPlain;
  etPath = ctPlain;
  // 注意：这里不要再添加etFont, etColor等常量，因为它们已经作为TEditorType枚举的值存在

// 类型转换函数
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
// 复杂属性类型转换为编辑器类型
function ComplexPropertyTypeToEditorType(CPT: TComplexPropertyType): TEditorType;

// 配置类型转换为字符串
function ConfigTypeToString(ConfigType: TConfigType): string;
// 字符串转换为配置类型
function StringToConfigType(const TypeStr: string): TConfigType;
// 判断配置类型属于哪个组（简单类型或复杂类型）
function GetConfigGroupType(ConfigType: TConfigType): TConfigGroupType;
// 检查配置类型是否为具有位置属性的类型
function HasPositionProperty(ConfigType: TConfigType): Boolean;
// 从JSON对象中获取配置类型
function GetTypeFromJSON(JSONObj: TJSONObject): TConfigType;
// 从INI键名中获取配置类型
function GetTypeFromINIKey(const KeyName: string): TConfigType;
// 字符串转颜色
function StringToColor(const ColorStr: string): TColor;
// 颜色转字符串
function ColorToString(Color: TColor): string;
// HTML颜色格式转TColor
function HTMLToColor(const HTMLColor: string): TColor;
// TColor转HTML颜色格式
function ColorToHTML(Color: TColor): string;

implementation

{ TConfigObjectMeta }

constructor TConfigObjectMeta.Create(const AName, ADescription: string;
  ACategory: Integer; AFormat: TConfigFormat; AConfigType: TConfigType; AEditorClass: TClass);
begin
  Name := AName;
  Description := ADescription;
  Category := ACategory;
  Format := AFormat;
  ConfigType := AConfigType;
  EditorClass := AEditorClass;
end;

{ TConfigObject }

constructor TConfigObject.Create(const AID, AName, AFileName, ATypeID: string; AConfigType: TConfigType);
begin
  inherited Create;
  FID := AID;
  FName := AName;
  FFileName := AFileName;
  FTypeID := ATypeID;
  FConfigType := AConfigType;
  FModified := False;
end;

function TConfigObject.Validate: Boolean;
var
  Errors: TArray<string>;
begin
  Errors := GetValidationErrors;
  Result := Length(Errors) = 0;
end;

function TConfigObject.GetValidationErrors: TArray<string>;
begin
  SetLength(Result, 0);
end;

{ TPositionAttributes }

procedure TPositionAttributes.SetDefaults;
begin
  X := 0;
  Y := 0;
  IsXCenter := False;
  IsYCenter := False;
  Scale := 1.0;
  ZIndex := 0;
end;

// 编辑器类型转换为配置类型
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
begin
  case EditorType of
    etPlain: Result := ctPlain;
    etFont: Result := ctFont;
    etColor: Result := ctColor;
    etDatabase: Result := ctDatabase;
    etList: Result := ctList;
    etObject: Result := ctObject;
    etArray: Result := ctArray;
    etAIAPI: Result := ctAIAPI;
    // 为扩展的编辑器类型添加转换 - 使用适当的配置类型
    etBgDraw,
    etTextOnBg,
    etImageOnBg,
    etCaptionOnBg,
    etVideoClip,
    etVideo: Result := ctObject; // 优先实现的类型暂时映射为对象类型
  else
    Result := ctPlain; // 默认值
  end;
end;

// 配置类型转换为编辑器类型
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
begin
  case ConfigType of
    ctPlain: Result := etPlain;
    ctFont: Result := etFont;
    ctColor: Result := etColor;
    ctDatabase: Result := etDatabase;
    ctList: Result := etList;
    ctObject: Result := etObject;
    ctArray: Result := etArray;
    ctAIAPI: Result := etAIAPI;
  else
    Result := etPlain; // 默认值
  end;
end;

// 复杂属性类型转换为编辑器类型
function ComplexPropertyTypeToEditorType(CPT: TComplexPropertyType): TEditorType;
begin
  case CPT of
    cptFont: Result := etFont;
    cptColor: Result := etColor;
    cptDatabase: Result := etDatabase;
    cptList: Result := etList;
    cptObject: Result := etObject;
    cptArray: Result := etArray;
    cptAPI: Result := etAIAPI;
    cptRootNode: Result := etRootNode;
    cptSecurity: Result := etSecurity;
    cptAI: Result := etAIAPI;
    cptModule: Result := etModule;
    cptDateTimeRange: Result := etDateTimeRange;
    cptKeyValueDict: Result := etKeyValueDict;
    cptUrlConfig: Result := etUrlConfig;
    cptPermission: Result := etPermission;
    cptNetConfig: Result := etNetConfig;
    cptEncrypt: Result := etEncrypt;
    cptGeoLocation: Result := etGeoLocation;
    cptMediaSettings: Result := etMediaSettings;
    cptChartConfig: Result := etChartConfig;
    cptWorkflow: Result := etWorkflow;
    cptSchedule: Result := etSchedule;
    cptI18n: Result := etI18n;
    cptUnitConversion: Result := etUnitConversion;
    cptVersionControl: Result := etVersionControl;
    cptBgDraw: Result := etBgDraw;
    cptTextOnBg: Result := etTextOnBg;
    cptImageOnBg: Result := etImageOnBg;
    cptCaptionOnBg: Result := etCaptionOnBg;
    cptVideoClip: Result := etVideoClip;
    cptVideo: Result := etVideo;
  else
    Result := etPlain; // 默认值
  end;
end;

function ConfigTypeToString(ConfigType: TConfigType): string;
begin
  case ConfigType of
    ctPlain: Result := 'ctPlain';
    ctInteger: Result := 'ctInteger';
    ctFloat: Result := 'ctFloat';
    ctBoolean: Result := 'ctBoolean';
    ctFont: Result := 'ctFont';
    ctColor: Result := 'ctColor';
    ctDatabase: Result := 'ctDatabase';
    ctList: Result := 'ctList';
    ctObject: Result := 'ctObject';
    ctAIAPI: Result := 'ctAIAPI';
    ctArray: Result := 'ctArray';
    else
      Result := 'Unknown';
  end;
end;

function StringToConfigType(const TypeStr: string): TConfigType;
var
  UpperType: string;
begin
  UpperType := UpperCase(TypeStr);
  if UpperType = UpperCase('ctPlain') then Result := ctPlain
  else if UpperType = UpperCase('ctInteger') then Result := ctInteger
  else if UpperType = UpperCase('ctFloat') then Result := ctFloat
  else if UpperType = UpperCase('ctBoolean') then Result := ctBoolean
  else if UpperType = UpperCase('ctFont') then Result := ctFont
  else if UpperType = UpperCase('ctColor') then Result := ctColor
  else if UpperType = UpperCase('ctDatabase') then Result := ctDatabase
  else if UpperType = UpperCase('ctList') then Result := ctList
  else if UpperType = UpperCase('ctObject') then Result := ctObject
  else if UpperType = UpperCase('ctAIAPI') then Result := ctAIAPI
  else if UpperType = UpperCase('ctArray') then Result := ctArray
  else
    Result := ctPlain; // 默认为自定义类型
end;

function GetConfigGroupType(ConfigType: TConfigType): TConfigGroupType;
begin
  case ConfigType of
    ctPlain, ctInteger, ctFloat, ctBoolean, ctFont, ctColor, ctDatabase, ctList:
      Result := cgtSimple;
    ctArray:
      Result := cgtComplex;
    else
      Result := cgtComplex;
  end;
end;

function HasPositionProperty(ConfigType: TConfigType): Boolean;
begin
  Result := (ConfigType in [ctPlain, ctInteger, ctFloat, ctBoolean, ctFont, ctColor, ctDatabase, ctList, ctArray]);
end;

function GetTypeFromJSON(JSONObj: TJSONObject): TConfigType;
var
  TypeStr: string;
begin
  if JSONObj.TryGetValue('Type', TypeStr) then
    Result := StringToConfigType(TypeStr)
  else
    Result := ctObject; // 默认为对象类型
end;

function GetTypeFromINIKey(const KeyName: string): TConfigType;
var
  Prefix: string;
begin
  if Length(KeyName) < 2 then
    Exit(ctPlain);

  Prefix := Copy(KeyName, 1, 2);
  if Prefix = 'S_' then Result := ctPlain
  else if Prefix = 'I_' then Result := ctInteger
  else if Prefix = 'F_' then Result := ctFloat
  else if Prefix = 'B_' then Result := ctBoolean
  else if Prefix = 'D_' then Result := ctDatabase
  else if Prefix = 'L_' then Result := ctList
  else if Prefix = 'O_' then Result := ctObject
  else if Prefix = 'C_' then Result := ctColor
  else if Prefix = 'A_' then Result := ctArray
  else if Prefix = 'FT' then Result := ctFont // 特殊情况：字体类型
  else
    Result := ctPlain; // 默认为纯文本
end;

function StringToColor(const ColorStr: string): TColor;
begin
  if ColorStr.StartsWith('#') then
    Result := HTMLToColor(ColorStr)
  else
    Result := Vcl.Graphics.StringToColor(ColorStr);
end;

function ColorToString(Color: TColor): string;
begin
  Result := ColorToHTML(Color);
end;

function HTMLToColor(const HTMLColor: string): TColor;
var
  ColorStr: string;
begin
  ColorStr := HTMLColor;
  if ColorStr.StartsWith('#') then
    ColorStr := ColorStr.Substring(1);
    
  try
    Result := StrToInt('$' + ColorStr);
  except
    on E: Exception do
      Result := clWhite; // 默认颜色
  end;
end;

function ColorToHTML(Color: TColor): string;
begin
  Result := Format('#%.6x', [Color and $FFFFFF]);
end;

end. 