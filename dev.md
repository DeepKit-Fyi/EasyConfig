# 配置管理系统开发规范

## 项目目标

ConfigEditor的设计目的是为了解决最终用户使用程序时需要进行配置但对配置文件设置不熟悉或容易出错的问题。通过提供一个通用的图形界面，使开发人员和最终用户都能够按照标准化的方法生成和修改配置文件，确保配置的正确性和一致性。

核心设计思路：
- 简单的配置项存储在INI文件中
- 复杂的配置项存储在JSON文件中
- INI文件中指定关联的JSON文件（默认为同名文件）
- 针对不同类型的配置项提供专用的编辑器

## 重要说明

**关于编辑器实现范围**：
- 本软件的核心功能是生成标准化的配置文件，不实现具体的功能逻辑
- 编辑器只需要提供参数的输入和修改界面，不需要实现实时预览功能
- 对于复杂属性，只需要提供相应的参数表单，不需要实现具体的渲染或交互功能

## 一、总体架构设计

### 1. 系统分层结构
- **基础层**：配置存储和访问抽象
- **核心层**：配置对象模型和管理器
- **界面层**：可视化编辑组件

### 2. 核心数据结构
- 配置对象基类 (TConfigObject)
- 配置对象元数据 (TConfigObjectMeta)
- 配置管理器 (TConfigManager)

## 二、文件组织结构

### 1. 核心模块
- `ConfigEditor.dpr`: 项目主文件，定义应用程序入口点
- `ViewMain.pas/dfm`: 主窗体实现，提供UI框架
- `ControllerMain.pas`: 主控制器，协调模型和视图之间的交互
- `ModelConfig.pas`: 配置模型，处理配置数据的核心逻辑

### 2. 配置文件管理
- `ConfigTypes.pas`: 配置数据类型定义
- `ConfigManager.pas`: 配置管理器，负责配置文件的加载和保存
- `ConfigRegistry.pas`: 配置类型注册表，管理不同的配置类型
- `INIConfig.pas`: INI文件的具体实现
- `JSONConfig.pas`: JSON文件的具体实现

### 3. 编辑器实现
- `ConfigEditorFrame.pas/dfm`: 通用编辑器框架
- `SimpleEditors.pas`: 简单类型编辑器实现 (已完成)
- `ComplexEditors.pas`: 复杂类型编辑器实现
- `ControllerConfigs.pas`: 复杂属性编辑器控制器
- 专用编辑器Frame文件:
  - `FrameBgDrawEditor.pas/dfm`: 背景图元素编辑器
  - `FrameVideoClipEditor.pas/dfm`: 视频片段编辑器
  - `FrameVideoEditor.pas/dfm`: 完整视频编辑器

### 4. 辅助工具
- `ConfigTree.pas`: 配置树操作辅助函数
- `HelperForm.pas`: 表单操作辅助函数
- `UtilsLog.pas`: 日志工具
- `UtilsStrs.pas`: 字符串处理工具
- `UtilsTypes.pas`: 类型定义和转换工具
- `UtilsUTF8.pas`: UTF8编码处理工具
- `UTF8Converter.pas/dfm`: UTF8转换工具界面

### 5. 接口定义
- `ViewIntf.pas`: 视图接口定义
- `ControllerIntf.pas`: 控制器接口定义

## 三、配置文件结构

### 1. 双文件结构

ConfigEditor采用INI+JSON的双文件结构：

- **INI文件**：存储简单类型的配置项和关联JSON文件的路径
- **JSON文件**：存储复杂类型的配置项

### 2. INI文件格式示例

```ini
[json_file]
file_path = app_config.json  ; 关联的JSON文件

[app_settings]
etText.app_name = 应用程序示例
etText.version = 1.0.0
etBoolean.debug_mode = true
etNumber.timeout = 30

[ui_settings]
etEnum.theme = dark,light,custom
etColor.primary_color = #0078D7
etBoolean.show_welcome = true
```

### 3. JSON文件格式示例

```json
{
  "fonts": {
    "main_font": {
      "_type": "etFont",
      "_id": "etFont.main_font",
      "name": "微软雅黑",
      "size": 12,
      "color": "#000000",
      "bold": false,
      "italic": false
    }
  },
  "database": {
    "main_connection": {
      "_type": "etDatabase",
      "_id": "etDatabase.main_connection",
      "driver": "mysql",
      "host": "localhost",
      "port": 3306,
      "database": "mydb",
      "username": "user",
      "password": "encrypted:XXXXX"
    }
  },
  "bg_elements": {
    "main_screen": {
      "_type": "etBgDraw",
      "_id": "etBgDraw.main_screen",
      "background": "path/to/background.png",
      "elements": [
        {
          "name": "title_text",
          "type": "text",
          "text": "标题文本",
          "x": 100,
          "y": 50,
          "visible": true,
          "font": {
            "name": "Arial",
            "size": 24,
            "color": 0,
            "style": ["bold"]
          }
        },
        {
          "name": "logo_image",
          "type": "image",
          "image_path": "path/to/logo.png",
          "x": 200,
          "y": 100,
          "visible": true,
          "scale": 1.0
        }
      ]
    }
  }
}
```

### 4. 命名规范

- INI文件中的键名格式：`etType.KeyName`，其中etType指定配置类型
- JSON文件中使用`_type`属性指定配置类型，使用`_id`属性指定唯一标识符
- 配置文件命名建议使用有意义的名称，如`app_config.ini`、`user_settings.ini`等

## 四、复杂属性编辑器实现指南

对于复杂属性编辑器，应遵循以下实现原则：

1. **专注于参数编辑**
   - 每个编辑器只需提供必要的参数输入界面
   - 不需要实现实时预览或复杂交互功能
   - 参数表单应简洁明了，易于用户理解和填写

2. **数据序列化**
   - 提供从JSON加载数据的方法
   - 提供保存数据到JSON的方法
   - 确保所有必要的参数都能正确序列化和反序列化

3. **编辑器组织结构**
   - 每个复杂属性使用单独的Frame实现界面
   - 所有Frame应继承自基本的TFrame类
   - 使用TControllerConfigs统一管理所有复杂属性编辑器

4. **优先实现的复杂属性**
   - 背景图元素编辑器：提供背景图片选择和基本元素属性编辑
   - 视频片段编辑器：提供片段基本属性的编辑
   - 完整视频编辑器：提供视频组合和全局设置的编辑

## 五、技术规范

1. **代码风格**
   - 使用Pascal命名法（PascalCase）命名类、方法和属性
   - 使用匈牙利命名法前缀命名控件（如btn, lbl, edt等）
   - 方法和函数应有明确的注释说明其功能和参数

2. **错误处理**
   - 使用try-except捕获可能的异常
   - 提供友好的错误提示信息
   - 对于关键操作（如保存文件）应进行适当的错误恢复

3. **内存管理**
   - 确保所有创建的对象被正确释放
   - 使用接口或辅助类管理对象生命周期
   - 避免循环引用造成的内存泄漏

4. **文件操作**
   - 所有文件路径应支持相对路径和绝对路径
   - 文件操作前应检查文件是否存在和权限是否足够
   - 保存文件前应创建备份，防止保存失败导致数据丢失

## 六、开发计划

见 [progress.md](progress.md) 文件，该文件包含详细的功能开发进度和计划。
