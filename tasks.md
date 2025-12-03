# 易配 (EasyConfig) 开发任务清单

> 本文档记录 易配 (EasyConfig) 通用配置编辑器的待完成开发任务。
> 已完成任务请参见 `history.md`

---

## 当前优先级：编译测试与功能完善

### P0 - 紧急：编译测试

- [x] 修复 ViewMainFormFMX.pas 中的 API 调用（GetINISections/GetINIKeys 返回 TArray<string>）
- [x] 修复 dproj 文件添加缺失的 Frame 引用（SimpleEditor、BgDraw、VideoClip）
- [x] 修复 ControllerConfigsFMX.pas 使用正确的基类名 TBaseConfigFrameFMX
- [x] 添加 TConfigFrameBaseFMX 类型别名和全局 JSON 帮助函数
- [x] 添加 BeginUpdate/EndUpdate 和 DoModified 方法到基类
- [x] 添加重载的 LoadFromJSON/SaveToJSON 方法支持两种签名
- [x] 添加 UtilsTypesFMX 引用到 FrameBgDrawEditorFMX.pas
- [ ] 在 Delphi IDE 中打开 `ConfigBuildFMX.dproj` 并编译
- [ ] 运行程序测试基本功能

### P1 - 高：简单属性编辑功能

- [ ] 实现简单属性（String/Integer/Boolean/Float）的内联编辑
  - [ ] 在属性列表双击时弹出编辑对话框
  - [ ] 或在右侧显示简单编辑控件
- [ ] 实现属性值修改后回写到 ConfigManager
- [ ] 实现撤销/重做功能 (`actUndo`/`actRedo`)

---

## 阶段三：View 层完善

### 3.2 配置编辑 Tab 增强

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

## 阶段四：复杂属性编辑器 Frame（可选）

### 4.4 背景布局编辑器 (`FrameBgDrawEditorFMX.pas`) ✅

- [x] 背景类型（纯色/渐变/图片）
- [x] 颜色选择
- [x] 图片路径选择
- [x] 元素列表管理（添加/编辑/删除）
- [ ] 元素移动排序（待完善）

### 4.5 视频片段编辑器 (`FrameVideoClipEditorFMX.pas`) ✅

- [x] 源文件路径选择
- [x] 起止时间设置
- [x] 时长自动计算
- [x] 音量调节
- [x] 淡入/淡出设置
- [x] 循环播放开关

### 4.6 视频播放器配置编辑器 (`FrameVideoEditorFMX.pas`)

- [ ] 解码器选择
- [ ] 硬件加速开关
- [ ] 编解码器偏好
- [ ] 字幕设置

### 4.7 其他编辑器

- [ ] `FrameDateTimeRangeEditorFMX.pas` - 日期时间范围
- [ ] `FrameKeyValueDictEditorFMX.pas` - 键值字典
- [ ] `FrameUrlConfigEditorFMX.pas` - URL 配置
- [ ] `FrameNetConfigEditorFMX.pas` - 网络配置
- [ ] `FrameGeoLocationEditorFMX.pas` - 地理位置
- [ ] `FrameEncryptEditorFMX.pas` - 加密配置

---

## 阶段五：TAction 统一动作系统

- [x] `actOpen`：打开配置工程 ✅
- [x] `actSave`：保存配置工程 ✅
- [x] `actSaveAs`：另存为 ✅
- [x] `actNew`：新建工程 ✅
- [x] `actExit`：退出 ✅
- [ ] `actClose`：关闭当前工程
- [ ] `actAddSimple`：添加简单属性
- [ ] `actAddComplex`：添加复杂属性（支持拖拽触发）
- [x] `actAddProperty`：添加属性（框架） ✅
- [x] `actDeleteProperty`：删除选中属性（框架） ✅
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

- [ ] `Test.UtilsTypesFMX.pas`：FMX 类型系统测试
- [ ] `Test.ConfigManager.pas`：配置管理器测试
- [ ] `Test.ConfigValidator.pas`：验证器测试

### 7.2 测试 GUI

- [ ] 创建 `ConfigBuildFMX.TestGUI.dpr` 工程
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

## 实现细节待定

### 数据库连接测试
- [ ] `FrameDBEditorFMX.btnTestClick` 实现实际连接测试
- [ ] SQLite: 检查文件存在性
- [ ] PostgreSQL/MySQL/MSSQL: 尝试连接

### AI API 测试
- [ ] `FrameAIAPIEditorFMX.btnTestClick` 实现 API 调用测试
- [ ] 发送简单请求验证 API Key 有效性
- [ ] 显示模型列表（如可获取）

---

## 参考文档

- `docs/01.01.产品-通用配置编辑器MVP产品构成-v1.md`
- `docs/02.01.模型-INI与JSON配置结构与约束-v1.0.md`
- `docs/02.02.模型-复杂属性类型与编辑器映射-v1.0.md`
- `docs/03.01.架构-ConfigBuild整体架构与模块划分-v1.0.md`
- `docs/04.01.使用-通用配置编辑器操作手册-v1.0.md`
- `docs/05.02.规范-EasyConfig技术栈与开发约定-v1.0.md`
- `docs/06.01.测试-EasyConfig测试策略与回归清单-v1.0.md`
- `history.md` - 已完成任务记录
- `bugfix.md` - Bug 修复记录

---

*最后更新: 2025-12-02 23:20*
