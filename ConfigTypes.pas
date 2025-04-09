unit ConfigTypes;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Graphics, Winapi.Windows;

type
  // 閰嶇疆鏍煎紡鏋氫妇
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
  
  // 閰嶇疆绫诲瀷鏋氫妇锛屽搴攊ni_json_rules.md涓畾涔夌殑绫诲瀷
  TConfigGroupType = (
    cgtSimple,     // 绠€鍗曠被鍨嬶紙瀛樺偍鍦↖NI鏂囦欢涓級
    cgtComplex     // 澶嶆潅绫诲瀷锛堝瓨鍌ㄥ湪JSON鏂囦欢涓級
  );
  
  // 浣嶇疆灞炴€х粨鏋勶紝鐢ㄤ簬鎵€鏈夐渶瑕佷綅缃殑绫诲瀷锛坋tTextOnBG銆乪tImageOnBG銆乪tDrawerOnBG绛夛級
  TPositionAttributes = record
    X: Integer;          // X鍧愭爣
    Y: Integer;          // Y鍧愭爣
    IsXCenter: Boolean;  // X鏄惁灞呬腑
    IsYCenter: Boolean;  // Y鏄惁灞呬腑
    Scale: Double;       // 缂╂斁姣斾緥
    ZIndex: Integer;     // Z搴忥紙灞傚彔椤哄簭锛?
    
    procedure SetDefaults;
  end;
  
  // 閰嶇疆瀵硅薄鍏冩暟鎹?
  TConfigObjectMeta = class
  public
    Name: string;        // 閰嶇疆绫诲瀷鍚嶇О
    Description: string; // 閰嶇疆绫诲瀷鎻忚堪
    Category: Integer;   // 绫诲埆绱㈠紩(鐢ㄤ簬鍒嗙粍)
    Format: TConfigFormat; // 瀛樺偍鏍煎紡
    ConfigType: TConfigType; // 閰嶇疆绫诲瀷
    EditorClass: TClass; // 缂栬緫鍣ㄧ被
    
    constructor Create(const AName, ADescription: string; 
                       ACategory: Integer; AFormat: TConfigFormat;
                       AConfigType: TConfigType; AEditorClass: TClass);
  end;
  
  // 閰嶇疆瀵硅薄鍩虹被
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
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; virtual; abstract;
    function Save: Boolean; virtual; abstract;
    
    // 楠岃瘉
    function Validate: Boolean; virtual;
    function GetValidationErrors: TArray<string>; virtual;
    
    // 灞炴€?
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property FileName: string read FFileName write FFileName;
    property TypeID: string read FTypeID;
    property Modified: Boolean read FModified write FModified;
    property ConfigType: TConfigType read FConfigType;
  end;
  
  TConfigObjectClass = class of TConfigObject;

  // 浣嶇疆淇℃伅璁板綍绫诲瀷
  TPositionInfo = record
    X: Integer;
    Y: Integer;
    IsXCenter: Boolean;
    IsYCenter: Boolean;
    Scale: Double;
    ZIndex: Integer;
  end;

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
  etFont = ctFont;
  etColor = ctColor;
  etDatabase = ctDatabase;
  etList = ctList;
  etObject = ctObject;
  etAIAPI = ctAIAPI;

// 閰嶇疆绫诲瀷杞崲涓哄瓧绗︿覆
function ConfigTypeToString(ConfigType: TConfigType): string;
// 瀛楃涓茶浆鎹负閰嶇疆绫诲瀷
function StringToConfigType(const TypeStr: string): TConfigType;
// 鍒ゆ柇閰嶇疆绫诲瀷灞炰簬鍝釜缁勶紙绠€鍗曠被鍨嬫垨澶嶆潅绫诲瀷锛?
function GetConfigGroupType(ConfigType: TConfigType): TConfigGroupType;
// 妫€鏌ラ厤缃被鍨嬫槸鍚︿负鍏锋湁浣嶇疆灞炴€х殑绫诲瀷
function HasPositionProperty(ConfigType: TConfigType): Boolean;
// 浠嶫SON瀵硅薄涓幏鍙栭厤缃被鍨?
function GetTypeFromJSON(JSONObj: TJSONObject): TConfigType;
// 浠嶪NI閿悕涓幏鍙栭厤缃被鍨?
function GetTypeFromINIKey(const KeyName: string): TConfigType;
// 瀛楃涓茶浆棰滆壊
function StringToColor(const ColorStr: string): TColor;
// 棰滆壊杞瓧绗︿覆
function ColorToString(Color: TColor): string;
// HTML棰滆壊鏍煎紡杞琓Color
function HTMLToColor(const HTMLColor: string): TColor;
// TColor杞TML棰滆壊鏍煎紡
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
    Result := ctPlain; // 榛樿涓鸿嚜瀹氫箟绫诲瀷
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
  TypeValue: TJSONValue;
begin
  Result := ctPlain; // 榛樿涓鸿嚜瀹氫箟绫诲瀷
  
  if JSONObj <> nil then
  begin
    TypeValue := JSONObj.FindValue('_type');
    if (TypeValue <> nil) and (TypeValue is TJSONString) then
      Result := StringToConfigType(TJSONString(TypeValue).Value);
  end;
end;

function GetTypeFromINIKey(const KeyName: string): TConfigType;
var
  DotPos: Integer;
  TypeStr: string;
begin
  Result := ctPlain; // 榛樿涓鸿嚜瀹氫箟绫诲瀷
  
  DotPos := Pos('.', KeyName);
  if DotPos > 0 then
  begin
    TypeStr := Copy(KeyName, 1, DotPos - 1);
    Result := StringToConfigType(TypeStr);
  end;
end;

function StringToColor(const ColorStr: string): TColor;
begin
  if ColorStr.StartsWith('#') then
    Result := HTMLToColor(ColorStr)
  else if ColorStr.StartsWith('cr') then
    Result := Vcl.Graphics.StringToColor(ColorStr)
  else
    Result := clBlack; // 榛樿棰滆壊
end;

function ColorToString(Color: TColor): string;
begin
  try
    Result := Vcl.Graphics.ColorToString(Color);
  except
    Result := '#000000'; // 榛樿榛戣壊
  end;
end;

function HTMLToColor(const HTMLColor: string): TColor;
var
  ColorValue: Integer;
begin
  if (Length(HTMLColor) = 7) and (HTMLColor[1] = '#') then
  begin
    try
      ColorValue := StrToInt('$' + Copy(HTMLColor, 6, 2) + Copy(HTMLColor, 4, 2) + Copy(HTMLColor, 2, 2));
      Result := TColor(ColorValue);
    except
      Result := clBlack; // 榛樿榛戣壊
    end;
  end
  else
    Result := clBlack; // 榛樿榛戣壊
end;

function ColorToHTML(Color: TColor): string;
begin
  Result := Format('#%.2x%.2x%.2x', [GetRValue(Color), GetGValue(Color), GetBValue(Color)]);
end;

end. 