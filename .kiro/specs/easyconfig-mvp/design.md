# Design Document

## Overview

EasyConfig MVP 是一个基于 Delphi + FMX 的通用配置编辑器，采用四层架构设计：View → Controller → Core → Infrastructure。本设计文档描述系统的架构、组件接口、数据模型和正确性属性。

## Architecture

### 整体架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        FMX View Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ ViewMainForm│  │ TreeView    │  │ Frame Editors           │ │
│  │ FMX         │  │ (Config     │  │ (Font/DB/VideoClip/...) │ │
│  │             │  │  Structure) │  │                         │ │
│  └──────┬──────┘  └──────┬──────┘  └───────────┬─────────────┘ │
└─────────┼────────────────┼─────────────────────┼───────────────┘
          │                │                     │
          ▼                ▼                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Controller Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ ControllerMain  │  │ControllerConfigs│  │ UndoRedoManager │ │
│  │ (Action Handler)│  │(Frame Factory)  │  │ (Command Stack) │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │
└───────────┼────────────────────┼────────────────────┼──────────┘
            │                    │                    │
            ▼                    ▼                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Core Layer                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ ConfigManager   │  │ ConfigValidator │  │ UtilsTypes      │ │
│  │ (Load/Save/     │  │ (Validation     │  │ (Type System)   │ │
│  │  Backup)        │  │  Rules)         │  │                 │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │
└───────────┼────────────────────┼────────────────────┼──────────┘
            │                    │                    │
            ▼                    ▼                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Infrastructure Layer                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ UniBase.Config  │  │ UniBase.Logging │  │ UniBase.i18n    │ │
│  │ UniBase.Security│  │ UniBase.FormState│ │ File System     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 数据流设计

采用 **Command 模式** 统一管理配置修改：

```
User Action → Command Object → Execute → Update Model → Notify View
                    ↓
              UndoRedoManager (记录到撤销栈)
```

## Components and Interfaces

### 1. ConfigManager (配置管理器)

```pascal
TConfigManager = class
public
  // 工程管理
  function OpenProject(const AIniPath: string): Boolean;
  function SaveProject: Boolean;
  function SaveProjectAs(const ANewIniPath: string): Boolean;
  function NewProject(const AIniPath: string): Boolean;
  procedure CloseProject;
  
  // 状态查询
  function IsModified: Boolean;
  function GetCurrentIniPath: string;
  function GetCurrentJsonPath: string;
  
  // 数据访问
  function GetINISections: TArray<string>;
  function GetINIKeys(const ASection: string): TArray<string>;
  function GetINIValue(const ASection, AKey: string): string;
  procedure SetINIValue(const ASection, AKey, AValue: string);
  
  function GetJSONRoot: TJSONObject;
  function GetJSONObjectById(const AId: string): TJSONObject;
  
  // 事件
  property OnModified: TNotifyEvent;
  property OnProjectLoaded: TNotifyEvent;
end;
```

### 2. ConfigValidator (配置验证器)

```pascal
TValidationLevel = (vlInfo, vlWarning, vlError);

TValidationResult = record
  Level: TValidationLevel;
  Path: string;        // 配置项路径，如 "database.host"
  Message: string;     // 错误消息
  CanAutoFix: Boolean; // 是否可自动修复
end;

TConfigValidator = class
public
  function ValidateAll: TArray<TValidationResult>;
  function ValidateField(const APath: string; const AValue: Variant): TValidationResult;
  
  // 规则管理
  procedure AddRule(const APath: string; ARule: TValidationRule);
  procedure ClearRules;
end;
```

### 3. ControllerConfigs (Frame 工厂)

```pascal
TControllerConfigs = class
public
  // Frame 创建
  function CreateFrameForType(AType: TComplexPropertyType; 
    AParent: TFmxObject): TBaseConfigFrameFMX;
  procedure DestroyFrame(AFrame: TBaseConfigFrameFMX);
  
  // 类型映射
  function GetFrameClassForType(AType: TComplexPropertyType): TBaseConfigFrameFMXClass;
  procedure RegisterFrameClass(AType: TComplexPropertyType; 
    AFrameClass: TBaseConfigFrameFMXClass);
end;
```

### 4. TBaseConfigFrameFMX (编辑器基类)

```pascal
TBaseConfigFrameFMX = class(TFrame)
protected
  FModified: Boolean;
  procedure DoModified; virtual;
public
  procedure LoadFromJSON(AObject: TJSONObject); virtual; abstract;
  procedure SaveToJSON(AObject: TJSONObject); virtual; abstract;
  
  procedure BeginUpdate;
  procedure EndUpdate;
  
  property Modified: Boolean read FModified;
  property OnModified: TNotifyEvent;
end;
```

### 5. UndoRedoManager (撤销/重做管理器)

```pascal
TConfigCommand = class
public
  procedure Execute; virtual; abstract;
  procedure Undo; virtual; abstract;
  function GetDescription: string; virtual; abstract;
end;

TUndoRedoManager = class
public
  procedure ExecuteCommand(ACommand: TConfigCommand);
  procedure Undo;
  procedure Redo;
  
  function CanUndo: Boolean;
  function CanRedo: Boolean;
  function GetUndoDescription: string;
  function GetRedoDescription: string;
  
  procedure Clear;
end;
```

## Data Models

### INI 文件结构

```ini
[json_file]
file_path=config.json
version=1.0

[app_settings]
app_name=MyApp
debug_mode=false
log_level=2

[ui_settings]
theme=dark
language=zh-CN
```

### JSON 文件结构

```json
{
  "fonts": {
    "_id": "font_main",
    "_type": "Font",
    "family": "Segoe UI",
    "size": 14,
    "style": ["bold"],
    "color": "#333333"
  },
  "database": {
    "_id": "db_default",
    "_type": "Database",
    "host": "127.0.0.1",
    "port": 5432,
    "database": "appdb",
    "user": "appuser"
  },
  "videos": [
    {
      "_id": "clip_intro",
      "_type": "VideoClip",
      "file": "videos/intro.mp4",
      "start_sec": 0,
      "end_sec": 10,
      "volume": 0.8
    }
  ]
}
```

### 类型系统 (UtilsTypes)

```pascal
TConfigType = (
  // 简单类型
  ctString, ctInteger, ctFloat, ctBoolean, ctColor, ctPath, ctEnum,
  // 复杂类型
  ctFont, ctDatabase, ctAIAPI, ctBgDraw, ctVideoClip, ctVideo,
  // 扩展
  ctCustom
);

TEditorType = (
  etTextEdit, etNumberEdit, etCheckBox, etColorPicker, etPathPicker,
  etComboBox, etFrameEditor
);

function ConfigTypeToEditorType(AType: TConfigType): TEditorType;
function StringToConfigType(const ATypeName: string): TConfigType;
function ConfigTypeToString(AType: TConfigType): string;
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: 配置加载/保存 Round-Trip

*For any* 有效的 INI+JSON 配置对，执行 `OpenProject` 加载后再执行 `SaveProject` 保存，重新加载后的配置数据应与原始数据完全一致。

**Validates: Requirements 1.1, 1.3, 6.3**

### Property 2: 树结构正确反映配置

*For any* JSON 对象结构，生成的树节点数量应等于 JSON 中的对象和数组元素总数，且每个包含 `_type` 字段的对象应在树节点上显示正确的类型标签。

**Validates: Requirements 2.1, 2.3, 2.4**

### Property 3: 类型到编辑器映射一致性

*For any* `TConfigType` 枚举值，`ConfigTypeToEditorType` 函数应返回一个有效的 `TEditorType`，且对于复杂类型，`ControllerConfigs.GetFrameClassForType` 应返回非空的 Frame 类。

**Validates: Requirements 3.1, 4.1**

### Property 4: Frame 编辑器 LoadFromJSON/SaveToJSON Round-Trip

*For any* 有效的复杂属性 JSON 对象，执行 `LoadFromJSON` 加载到 Frame 后再执行 `SaveToJSON` 保存，生成的 JSON 对象应与原始对象在语义上等价。

**Validates: Requirements 4.2, 4.3**

### Property 5: 验证规则完整性

*For any* 配置对象，如果必填字段为空，则 `ValidateAll` 返回的结果中应包含至少一个 `vlError` 级别的条目；如果 `_ref` 引用指向不存在的 `_id`，则应返回错误。

**Validates: Requirements 5.2, 5.4**

### Property 6: 撤销/重做栈一致性

*For any* 配置修改操作序列，执行 N 次修改后执行 N 次撤销应恢复到初始状态；执行撤销后执行重做应恢复到撤销前的状态；执行新修改后重做栈应为空。

**Validates: Requirements 7.1, 7.2, 7.3, 7.4**

### Property 7: 修改状态正确性

*For any* 配置修改操作，执行后 `IsModified` 应返回 `True`；执行 `SaveProject` 后 `IsModified` 应返回 `False`。

**Validates: Requirements 8.2, 8.3**

### Property 8: 输入验证拒绝无效值

*For any* 简单属性类型和不符合该类型约束的输入值，编辑器的验证逻辑应返回失败，阻止无效值被写入模型。

**Validates: Requirements 3.3**

## Error Handling

### 错误分级

1. **Fatal**: 无法恢复的错误（如配置文件严重损坏）
   - 记录 Fatal 日志
   - 显示错误对话框
   - 建议用户从备份恢复

2. **Error**: 可恢复的错误（如保存失败）
   - 记录 Error 日志
   - 显示错误提示
   - 保留当前状态，允许重试

3. **Warning**: 非致命问题（如验证警告）
   - 记录 Warning 日志
   - 在状态栏或日志区显示
   - 不阻止操作继续

### 错误恢复策略

```pascal
// 保存时的原子性保证
procedure TConfigManager.SaveProject;
begin
  // 1. 先写入临时文件
  SaveToTempFile(FJsonPath + '.tmp', FJsonData);
  SaveToTempFile(FIniPath + '.tmp', FIniData);
  
  // 2. 创建备份
  CreateBackup(FJsonPath);
  CreateBackup(FIniPath);
  
  // 3. 原子替换
  RenameFile(FJsonPath + '.tmp', FJsonPath);
  RenameFile(FIniPath + '.tmp', FIniPath);
end;
```

## Testing Strategy

### 双重测试方法

本项目采用单元测试和属性测试相结合的策略：

- **单元测试**: 验证具体示例和边界情况
- **属性测试**: 验证通用属性在所有输入上成立

### 属性测试框架

使用 **DUnitX** 配合自定义的属性测试辅助类：

```pascal
TPropertyTest = class
public
  class procedure ForAll<T>(AGenerator: TFunc<T>; 
    AProperty: TFunc<T, Boolean>; AIterations: Integer = 100);
end;
```

### 测试覆盖要求

1. **ConfigManager**: Round-trip 测试、边界情况测试
2. **ConfigValidator**: 各验证规则的正确性测试
3. **ControllerConfigs**: 类型映射完整性测试
4. **UndoRedoManager**: 撤销/重做栈一致性测试
5. **Frame Editors**: LoadFromJSON/SaveToJSON round-trip 测试

### 测试数据生成

```pascal
// JSON 对象生成器
function GenerateRandomJSONObject(AType: TConfigType): TJSONObject;

// INI 内容生成器
function GenerateRandomINIContent(ASectionCount, AKeyCount: Integer): string;

// 配置对生成器
function GenerateRandomConfigPair: TConfigPair;
```
