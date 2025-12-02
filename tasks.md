# ConfigBuild 开发任务清单

> 本文档记录 ConfigBuild（通用配置编辑器）的所有开发任务，按优先级和模块分类。

---

## 阶段一：项目初始化

- [ ] 创建 FMX 项目骨架 `ConfigBuildFMX.dpr`
- [ ] 配置项目选项（UTF-8 + BOM、输出目录 `bin/`、DCU 目录 `dcu/`）
- [ ] 添加 UniBase 引用路径（`Core/`、`FMX/`）
- [ ] 创建 `root.txt` 和初始化 `ConfigBuildConfig.db`
- [ ] 实现程序入口的 `UniBase.Initialize` / `Finalize` 调用

---

## 阶段二：核心模块实现

### 2.1 类型系统 (`UtilsTypes.pas`)

- [ ] 定义 `TConfigType` 枚举（ctString, ctInteger, ctBoolean, ctFloat, ctColor, ctPath, ctFont, ctDatabase, ctAIAPI, ctBgDraw, ctVideoClip, ctVideo, ctCustom）
- [ ] 定义 `TEditorType` 枚举（etEdit, etSpinEdit, etCheckBox, etComboBox, etColorPicker, etPathPicker, etFrame）
- [ ] 实现类型与编辑器的映射函数 `GetEditorTypeForConfig`

### 2.2 配置管理器 (`ConfigManager.pas`)

- [ ] 实现 `OpenProject(IniPath)` 方法
  - [ ] 解析 INI 文件
  - [ ] 读取 `[json_file]` 节定位 JSON 路径
  - [ ] 加载并解析 JSON 文件
  - [ ] 构建内部配置模型
- [ ] 实现 `SaveProject` 方法
  - [ ] 备份策略（`.bak` + 时间戳）
  - [ ] 写入 JSON 和 INI 文件
  - [ ] 错误处理和日志记录
- [ ] 实现 `CreateEmptyProject` 方法
- [ ] 实现配置修改追踪（脏标记）

### 2.3 配置验证器 (`ConfigValidator.pas`)

- [ ] 定义验证结果结构 `TValidationResult`（Level, Path, Message, AutoFixable）
- [ ] 实现必填字段验证
- [ ] 实现数值范围验证
- [ ] 实现路径存在性验证
- [ ] 实现 `_ref` 引用有效性验证
- [ ] 实现自动修复建议生成

### 2.4 复杂属性控制器 (`ControllerConfigs.pas`)

- [ ] 定义 `TBaseConfigFrame` 基类
  - [ ] `LoadFromJSON` 抽象方法
  - [ ] `SaveToJSON` 抽象方法
  - [ ] `Validate` 方法
- [ ] 实现类型到 Frame 的注册表
- [ ] 实现 `CreateFrameForType` 工厂方法

---

## 阶段三：View 层实现

### 3.1 主窗体 (`ViewMainForm.pas`)

- [ ] 创建主窗体 FMX 布局
- [ ] 实现顶层 Tab 切换（配置编辑 / 文件浏览）
- [ ] 集成 UniBase.FMX.FormStateHelper 保存窗体状态
- [ ] 实现状态栏
  - [ ] 当前文件路径和修改状态
  - [ ] 验证结果摘要
  - [ ] 最近操作提示

### 3.2 配置编辑 Tab

- [ ] 左侧：工程与配置树 (`TTreeView`)
  - [ ] 显示 INI 节和键
  - [ ] 显示 JSON 对象树
  - [ ] 节点选择事件处理
- [ ] 中间上：属性网格 (`TStringGrid`)
  - [ ] 属性名/类型/值三列显示
  - [ ] 分类折叠（常规/验证/显示/来源）
  - [ ] 单元格编辑支持
- [ ] 中间下：复杂属性编辑器容器
  - [ ] Frame 动态加载
  - [ ] 空状态占位提示
- [ ] 右侧上：属性编辑器面板（Delphi Object Inspector 风格）
  - [ ] 筛选/搜索功能
  - [ ] 分类显示
- [ ] 右侧中：类型工具箱
  - [ ] 可拖拽的类型块（Font, Database, AIAPI, BgDraw, VideoClip, Video）
  - [ ] 拖拽到树或编辑区创建复杂属性
- [ ] 右侧下：验证摘要面板
- [ ] 底部：日志/验证结果列表

### 3.3 原始文档视图

- [ ] INI 原文 Tab（TMemo 只读/可编辑）
- [ ] JSON 原文 Tab（TMemo 只读/可编辑）
- [ ] 原文修改同步到内部模型

### 3.4 文件浏览 Tab

- [ ] 顶部：驱动器选择 + 路径输入 + 导航按钮
- [ ] 左上：目录树
- [ ] 左下：文件列表
  - [ ] INI/JSON/所有 过滤复选框
  - [ ] 文件多选支持
- [ ] 右侧：可编辑预览
  - [ ] TMemo 显示文件内容
  - [ ] 保存按钮写回磁盘
- [ ] 工具栏操作
  - [ ] 作为工程打开
  - [ ] 新建 INI+JSON 对
  - [ ] 删除文件
  - [ ] 在外部打开

---

## 阶段四：复杂属性编辑器 Frame

### 4.1 字体编辑器 (`FrameFontEditor.pas`)

- [ ] 字体家族选择（TComboBox）
- [ ] 字体大小（TSpinBox）
- [ ] 字体样式（Bold/Italic/Underline 复选框）
- [ ] 颜色选择（TColorComboBox）
- [ ] 预览区域

### 4.2 数据库连接编辑器 (`FrameDBEditor.pas`)

- [ ] 数据库类型选择（SQLite/PostgreSQL/MySQL）
- [ ] 主机/端口输入
- [ ] 数据库名/路径输入
- [ ] 用户名/密码输入（密码使用 UniBase.Security）
- [ ] 连接选项（JournalMode, Synchronous 等）
- [ ] 测试连接按钮

### 4.3 AI API 编辑器 (`FrameAIAPIEditor.pas`)

- [ ] Provider 选择（OpenAI/Anthropic/Ollama/LiteLLM）
- [ ] Model 输入/选择
- [ ] Endpoint URL 输入
- [ ] API Key 输入（加密存储）
- [ ] MaxTokens/Temperature 参数
- [ ] Timeout 设置
- [ ] 测试连接按钮

### 4.4 背景布局编辑器 (`FrameBgDrawEditor.pas`) [可选]

- [ ] 背景类型（纯色/渐变/图片）
- [ ] 颜色选择
- [ ] 渐变方向
- [ ] 图片路径和显示模式

### 4.5 视频片段编辑器 (`FrameVideoClipEditor.pas`) [可选]

- [ ] 源文件路径选择
- [ ] 起止时间设置
- [ ] 音量调节
- [ ] 循环/淡入淡出设置

### 4.6 视频播放器配置编辑器 (`FrameVideoEditor.pas`) [可选]

- [ ] 解码器选择
- [ ] 硬件加速开关
- [ ] 编解码器偏好
- [ ] 字幕设置

---

## 阶段五：TAction 统一动作系统

- [ ] `actOpen`：打开配置工程
- [ ] `actSave`：保存配置工程
- [ ] `actSaveAs`：另存为
- [ ] `actClose`：关闭当前工程
- [ ] `actAddSimple`：添加简单属性
- [ ] `actAddComplex`：添加复杂属性（支持拖拽触发）
- [ ] `actDelete`：删除选中属性
- [ ] `actValidate`：验证配置
- [ ] `actUndo`：撤销
- [ ] `actRedo`：重做
- [ ] `actCut`/`actCopy`/`actPaste`：剪切/复制/粘贴

---

## 阶段六：国际化与主题

- [ ] 提取所有用户可见文本到 i18n 资源
- [ ] 创建中文（zh-CN）语言包
- [ ] 创建英文（en-US）语言包
- [ ] 实现语言切换功能
- [ ] 集成 UniBase.FMX.Theme 主题切换

---

## 阶段七：测试与优化

### 7.1 单元测试

- [ ] `Test.UtilsTypes.pas`：类型系统测试
- [ ] `Test.ConfigManager.pas`：配置管理器测试
- [ ] `Test.ConfigValidator.pas`：验证器测试

### 7.2 测试 GUI

- [ ] 创建 `ConfigBuild.TestGUI.dpr` 工程
- [ ] 复用正式 Frame 和 Controller
- [ ] 测试各复杂属性编辑器

### 7.3 性能优化

- [ ] 大型配置文件加载性能测试
- [ ] 树视图虚拟化（如需）
- [ ] 配置缓存策略

---

## 阶段八：UI 增强（待实现）

- [ ] JSON 数组节点拖拽排序
- [ ] 复杂属性区域折叠支持
- [ ] Frame 标题显示当前编辑属性路径（上下文感知）
- [ ] 快捷键配置（集成 UniBase.Hotkeys）
- [ ] 最近文件列表（集成 UniBase.MRU）

---

## 参考文档

- `docs/01.01.产品-通用配置编辑器MVP产品构成-v1.md`
- `docs/02.01.模型-INI与JSON配置结构与约束-v1.0.md`
- `docs/02.02.模型-复杂属性类型与编辑器映射-v1.0.md`
- `docs/03.01.架构-ConfigBuild整体架构与模块划分-v1.0.md`
- `docs/04.01.使用-通用配置编辑器操作手册-v1.0.md`
- `docs/05.02.规范-ConfigBuild技术栈与开发约定-v1.0.md`
- `docs/06.01.测试-ConfigBuild测试策略与回归清单-v1.0.md`

---

*最后更新: 2025-12-02*
