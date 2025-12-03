unit UtilsTypesFMX;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.UITypes, System.UIConsts;

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
    ctArray,      // 数组类型
    ctPath,       // 路径类型
    ctBgDraw,     // 背景绘制类型
    ctVideoClip,  // 视频片段类型
    ctVideo,      // 视频类型
    ctCustom      // 自定义类型
  );
  
  // 配置类型枚举，对应ini_json_rules.md中定义的类型
  TConfigGroupType = (
    cgtSimple,     // 简单类型（存储在INI文件中）
    cgtComplex     // 复杂类型（存储在JSON文件中）
  );

  // 编辑器类型枚举
  TEditorType = (
    etEdit,           // 文本编辑框
    etSpinEdit,       // 数字编辑框
    etCheckBox,       // 复选框
    etComboBox,       // 下拉框
    etColorPicker,    // 颜色选择器
    etPathPicker,     // 路径选择器
    etFrame,          // 自定义 Frame
    etFont,           // 字体编辑器
    etDatabase,       // 数据库编辑器
    etAIAPI,          // AI API 编辑器
    etBgDraw,         // 背景绘制编辑器
    etVideoClip,      // 视频片段编辑器
    etVideo,          // 视频编辑器
    etObject,         // 对象编辑器
    etArray,          // 数组编辑器
    etList            // 列表编辑器
  );

  // 复杂属性枚举 - 用于按钮的Tag属性
  TComplexPropertyType = (
    cptFont = 0,        // 字体
    cptColor = 1,       // 颜色
    cptDatabase = 2,    // 数据库
    cptList = 3,        // 列表
    cptObject = 4,      // 对象
    cptArray = 5,       // 数组
    cptAIAPI = 6,       // AI API
    cptBgDraw = 7,      // 背景绘制
    cptVideoClip = 8,   // 视频片段
    cptVideo = 9,       // 视频
    cptTextOnBg = 10,   // 文字在背景上
    cptImageOnBg = 11,  // 图片在背景上
    cptCaptionOnBg = 12,// 字幕在背景上
    cptDateTimeRange = 13, // 日期时间范围
    cptKeyValueDict = 14,  // 键值字典
    cptUrlConfig = 15,     // URL 配置
    cptNetConfig = 16,     // 网络配置
    cptGeoLocation = 17,   // 地理位置
    cptEncrypt = 18        // 加密配置
  );

  // 验证结果级别
  TValidationLevel = (vlInfo, vlWarning, vlError);

  // 验证结果记录
  TValidationResult = record
    Level: TValidationLevel;
    Path: string;
    Message: string;
    AutoFixable: Boolean;
    FixSuggestion: string;
  end;

  // 配置属性项记录
  TConfigPropertyItem = record
    PropertyName: string;
    PropertyType: string;
    PropertyValue: string;
    EditorType: TEditorType;
    PropertyPath: string;
    IsModified: Boolean;
  end;
  PConfigPropertyItem = ^TConfigPropertyItem;

// 类型转换函数
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
function ComplexPropertyTypeToEditorType(CPT: TComplexPropertyType): TEditorType;

// 配置类型转换为字符串
function ConfigTypeToString(ConfigType: TConfigType): string;
// 字符串转换为配置类型
function StringToConfigType(const TypeStr: string): TConfigType;
// 判断配置类型属于哪个组（简单类型或复杂类型）
function GetConfigGroupType(ConfigType: TConfigType): TConfigGroupType;
// 从JSON对象中获取配置类型
function GetTypeFromJSON(JSONObj: TJSONObject): TConfigType;

// 颜色转换函数（使用 System.UITypes）
function StringToAlphaColor(const ColorStr: string): TAlphaColor;
function AlphaColorToString(Color: TAlphaColor): string;
function HTMLToAlphaColor(const HTMLColor: string): TAlphaColor;
function AlphaColorToHTML(Color: TAlphaColor): string;

// 获取编辑器类型的显示名称
function GetEditorTypeDisplayName(EditorType: TEditorType): string;

// 从 JSON 对象检测复杂属性类型
function DetectComplexPropertyType(JSONObj: TJSONObject): TComplexPropertyType;

// 获取复杂属性类型名称
function GetComplexPropertyTypeName(PropType: TComplexPropertyType): string;

implementation

function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
begin
  case EditorType of
    etEdit: Result := ctPlain;
    etSpinEdit: Result := ctInteger;
    etCheckBox: Result := ctBoolean;
    etComboBox: Result := ctPlain;
    etColorPicker: Result := ctColor;
    etPathPicker: Result := ctPath;
    etFont: Result := ctFont;
    etDatabase: Result := ctDatabase;
    etAIAPI: Result := ctAIAPI;
    etBgDraw: Result := ctBgDraw;
    etVideoClip: Result := ctVideoClip;
    etVideo: Result := ctVideo;
    etObject: Result := ctObject;
    etArray: Result := ctArray;
    etList: Result := ctList;
  else
    Result := ctPlain;
  end;
end;

function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
begin
  case ConfigType of
    ctPlain: Result := etEdit;
    ctInteger: Result := etSpinEdit;
    ctFloat: Result := etSpinEdit;
    ctBoolean: Result := etCheckBox;
    ctFont: Result := etFont;
    ctColor: Result := etColorPicker;
    ctDatabase: Result := etDatabase;
    ctList: Result := etList;
    ctObject: Result := etObject;
    ctAIAPI: Result := etAIAPI;
    ctArray: Result := etArray;
    ctPath: Result := etPathPicker;
    ctBgDraw: Result := etBgDraw;
    ctVideoClip: Result := etVideoClip;
    ctVideo: Result := etVideo;
  else
    Result := etEdit;
  end;
end;

function ComplexPropertyTypeToEditorType(CPT: TComplexPropertyType): TEditorType;
begin
  case CPT of
    cptFont: Result := etFont;
    cptColor: Result := etColorPicker;
    cptDatabase: Result := etDatabase;
    cptList: Result := etList;
    cptObject: Result := etObject;
    cptArray: Result := etArray;
    cptAIAPI: Result := etAIAPI;
    cptBgDraw: Result := etBgDraw;
    cptVideoClip: Result := etVideoClip;
    cptVideo: Result := etVideo;
  else
    Result := etEdit;
  end;
end;

function ConfigTypeToString(ConfigType: TConfigType): string;
begin
  case ConfigType of
    ctPlain: Result := 'String';
    ctInteger: Result := 'Integer';
    ctFloat: Result := 'Float';
    ctBoolean: Result := 'Boolean';
    ctFont: Result := 'Font';
    ctColor: Result := 'Color';
    ctDatabase: Result := 'Database';
    ctList: Result := 'List';
    ctObject: Result := 'Object';
    ctAIAPI: Result := 'AIAPI';
    ctArray: Result := 'Array';
    ctPath: Result := 'Path';
    ctBgDraw: Result := 'BgDraw';
    ctVideoClip: Result := 'VideoClip';
    ctVideo: Result := 'Video';
    ctCustom: Result := 'Custom';
  else
    Result := 'Unknown';
  end;
end;

function StringToConfigType(const TypeStr: string): TConfigType;
var
  LowerType: string;
begin
  LowerType := LowerCase(TypeStr);
  if LowerType = 'string' then Result := ctPlain
  else if LowerType = 'integer' then Result := ctInteger
  else if LowerType = 'float' then Result := ctFloat
  else if LowerType = 'boolean' then Result := ctBoolean
  else if LowerType = 'font' then Result := ctFont
  else if LowerType = 'color' then Result := ctColor
  else if LowerType = 'database' then Result := ctDatabase
  else if LowerType = 'list' then Result := ctList
  else if LowerType = 'object' then Result := ctObject
  else if LowerType = 'aiapi' then Result := ctAIAPI
  else if LowerType = 'array' then Result := ctArray
  else if LowerType = 'path' then Result := ctPath
  else if LowerType = 'bgdraw' then Result := ctBgDraw
  else if LowerType = 'videoclip' then Result := ctVideoClip
  else if LowerType = 'video' then Result := ctVideo
  else
    Result := ctPlain;
end;

function GetConfigGroupType(ConfigType: TConfigType): TConfigGroupType;
begin
  case ConfigType of
    ctPlain, ctInteger, ctFloat, ctBoolean, ctColor, ctPath:
      Result := cgtSimple;
  else
    Result := cgtComplex;
  end;
end;

function GetTypeFromJSON(JSONObj: TJSONObject): TConfigType;
var
  TypeStr: string;
begin
  if JSONObj.TryGetValue('$type', TypeStr) or JSONObj.TryGetValue('_type', TypeStr) then
    Result := StringToConfigType(TypeStr)
  else
    Result := ctObject;
end;

function StringToAlphaColor(const ColorStr: string): TAlphaColor;
begin
  if ColorStr.StartsWith('#') then
    Result := HTMLToAlphaColor(ColorStr)
  else if ColorStr.StartsWith('$') then
    Result := StrToIntDef(ColorStr, Integer(TAlphaColorRec.White))
  else
    Result := TAlphaColorRec.White;
end;

function AlphaColorToString(Color: TAlphaColor): string;
begin
  Result := AlphaColorToHTML(Color);
end;

function HTMLToAlphaColor(const HTMLColor: string): TAlphaColor;
var
  ColorStr: string;
  R, G, B: Byte;
begin
  ColorStr := HTMLColor;
  if ColorStr.StartsWith('#') then
    ColorStr := ColorStr.Substring(1);
    
  try
    if Length(ColorStr) = 6 then
    begin
      R := StrToInt('$' + Copy(ColorStr, 1, 2));
      G := StrToInt('$' + Copy(ColorStr, 3, 2));
      B := StrToInt('$' + Copy(ColorStr, 5, 2));
      Result := MakeColor(R, G, B);
    end
    else if Length(ColorStr) = 3 then
    begin
      R := StrToInt('$' + ColorStr[1] + ColorStr[1]);
      G := StrToInt('$' + ColorStr[2] + ColorStr[2]);
      B := StrToInt('$' + ColorStr[3] + ColorStr[3]);
      Result := MakeColor(R, G, B);
    end
    else
      Result := TAlphaColorRec.White;
  except
    Result := TAlphaColorRec.White;
  end;
end;

function AlphaColorToHTML(Color: TAlphaColor): string;
var
  Rec: TAlphaColorRec;
begin
  Rec := TAlphaColorRec(Color);
  Result := Format('#%.2x%.2x%.2x', [Rec.R, Rec.G, Rec.B]);
end;

function GetEditorTypeDisplayName(EditorType: TEditorType): string;
begin
  case EditorType of
    etEdit: Result := '文本';
    etSpinEdit: Result := '数字';
    etCheckBox: Result := '布尔';
    etComboBox: Result := '选择';
    etColorPicker: Result := '颜色';
    etPathPicker: Result := '路径';
    etFont: Result := '字体';
    etDatabase: Result := '数据库';
    etAIAPI: Result := 'AI API';
    etBgDraw: Result := '背景';
    etVideoClip: Result := '视频片段';
    etVideo: Result := '视频';
    etObject: Result := '对象';
    etArray: Result := '数组';
    etList: Result := '列表';
  else
    Result := '未知';
  end;
end;

function DetectComplexPropertyType(JSONObj: TJSONObject): TComplexPropertyType;
var
  TypeStr: string;
begin
  Result := cptObject; // 默认

  if JSONObj = nil then Exit;

  // 从 _type 字段检测类型
  if JSONObj.TryGetValue<string>('_type', TypeStr) then
  begin
    TypeStr := LowerCase(TypeStr);
    if TypeStr = 'etfont' then
      Result := cptFont
    else if TypeStr = 'etdatabase' then
      Result := cptDatabase
    else if TypeStr = 'etaiapi' then
      Result := cptAIAPI
    else if TypeStr = 'etbgdraw' then
      Result := cptBgDraw
    else if TypeStr = 'ettextonbg' then
      Result := cptTextOnBg
    else if TypeStr = 'etimageonbg' then
      Result := cptImageOnBg
    else if TypeStr = 'etcaptiononbg' then
      Result := cptCaptionOnBg
    else if TypeStr = 'etvideoclip' then
      Result := cptVideoClip
    else if TypeStr = 'etvideo' then
      Result := cptVideo
    else if TypeStr = 'etdatetimerange' then
      Result := cptDateTimeRange
    else if TypeStr = 'etkeyvaluedict' then
      Result := cptKeyValueDict
    else if TypeStr = 'eturlconfig' then
      Result := cptUrlConfig
    else if TypeStr = 'etnetconfig' then
      Result := cptNetConfig
    else if TypeStr = 'etgeolocation' then
      Result := cptGeoLocation
    else if TypeStr = 'etencrypt' then
      Result := cptEncrypt
    else if TypeStr = 'etcolor' then
      Result := cptColor
    else if TypeStr = 'etlist' then
      Result := cptList
    else if TypeStr = 'etarray' then
      Result := cptArray
    else
      Result := cptObject;
  end;
end;

function GetComplexPropertyTypeName(PropType: TComplexPropertyType): string;
begin
  case PropType of
    cptFont: Result := '字体';
    cptColor: Result := '颜色';
    cptDatabase: Result := '数据库';
    cptList: Result := '列表';
    cptObject: Result := '对象';
    cptArray: Result := '数组';
    cptAIAPI: Result := 'AI API';
    cptBgDraw: Result := '背景绘制';
    cptVideoClip: Result := '视频片段';
    cptVideo: Result := '视频';
    cptTextOnBg: Result := '文字在背景上';
    cptImageOnBg: Result := '图片在背景上';
    cptCaptionOnBg: Result := '字幕在背景上';
    cptDateTimeRange: Result := '日期时间范围';
    cptKeyValueDict: Result := '键值字典';
    cptUrlConfig: Result := 'URL 配置';
    cptNetConfig: Result := '网络配置';
    cptGeoLocation: Result := '地理位置';
    cptEncrypt: Result := '加密配置';
  else
    Result := '未知';
  end;
end;

end.
