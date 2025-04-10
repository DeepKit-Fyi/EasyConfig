unit UtilsTypes;

interface

uses
  System.SysUtils, System.Classes, ConfigTypes, Vcl.Graphics;

type
  // 编辑器类型枚举
  TEditorType = (etPlain, etFont, etColor, etDatabase, etList, etObject, etArray);

  // 配置属性项记录
  TConfigPropertyItem = record
    PropertyName: string;
    PropertyType: string;
    PropertyValue: string;
    EditorType: TEditorType;
    PropertyPath: string;
  end;
  PConfigPropertyItem = ^TConfigPropertyItem;

// 类型转换函数
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;

implementation

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
    ctAIAPI: Result := etObject; // 映射为对象类型
  else
    Result := etPlain; // 默认值
  end;
end;

end. 