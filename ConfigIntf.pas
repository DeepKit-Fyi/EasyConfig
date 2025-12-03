unit ConfigIntf;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, UtilsTypes;

type
  // INI配置接口
  IINIConfig = interface
    ['{BFA9F1B6-A7D4-4A68-9E21-D62C4D953A60}']
    // 文件操作
    function Exists: Boolean;
    function CreateFile: Boolean;
    function Reload: Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: string): Boolean;
    
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
    
    // 节和键操作
    function SectionExists(const Section: string): Boolean;
    function KeyExists(const Section, Name: string): Boolean;
    procedure DeleteKey(const Section, Name: string);
    procedure DeleteSection(const Section: string);
    function ReadSections: TStrings;
    function ReadSection(const Section: string): TStrings;
    
    // 属性
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    
    property FileName: string read GetFileName write SetFileName;
    property Modified: Boolean read GetModified write SetModified;
  end;

  // JSON配置接口
  IJSONConfig = interface
    ['{5EA30D2F-9D73-489C-A7CE-A6D5A44B3E1A}']
    // 文件操作
    function Exists: Boolean;
    function CreateFile: Boolean;
    function Reload: Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: string): Boolean;
    
    // 读取操作
    function ReadString(const Path: string; const DefaultValue: string = ''): string;
    function ReadInteger(const Path: string; DefaultValue: Integer = 0): Integer;
    function ReadFloat(const Path: string; DefaultValue: Double = 0): Double;
    function ReadBoolean(const Path: string; DefaultValue: Boolean = False): Boolean;
    function ReadDateTime(const Path: string; DefaultValue: TDateTime = 0): TDateTime;
    function ReadJSONValue(const Path: string): TJSONValue;
    
    // 写入操作
    procedure WriteString(const Path, Value: string);
    procedure WriteInteger(const Path: string; Value: Integer);
    procedure WriteFloat(const Path: string; Value: Double);
    procedure WriteBoolean(const Path: string; Value: Boolean);
    procedure WriteDateTime(const Path: string; Value: TDateTime);
    procedure WriteObject(const Path: string; Value: TJSONObject);
    procedure WriteJSONValue(const Path: string; Value: TJSONValue);
    
    // 路径操作
    function PathExists(const Path: string): Boolean;
    procedure DeletePath(const Path: string);
    
    // 获取根对象
    function GetRoot: TJSONObject;
    
    // 配置类型操作
    function GetConfigType(const Section, Key: string): TConfigType;
    function GetJSONObject(const Section, Key: string): TJSONObject;
    
    // 属性
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    
    property FileName: string read GetFileName write SetFileName;
    property Modified: Boolean read GetModified write SetModified;
    property Root: TJSONObject read GetRoot;
  end;

  // 配置编辑器接口
  IConfigEditor = interface
    ['{D8F4E2A7-C1B3-40E5-B9D8-F6C58A9DEF3E}']
    procedure SetINIConfig(const Value: IINIConfig);
    procedure SetJSONConfig(const Value: IJSONConfig);
    procedure EditValue(const Section, Key: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    property Modified: Boolean read GetModified write SetModified;
  end;

implementation

end. 