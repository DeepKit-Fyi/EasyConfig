# 易配 (EasyConfig) Bug修复记录

---

## 2025-12-02 - FMX 版本适配

### 解决的问题

**1. VCL 依赖问题**
- 问题: `UtilsTypes.pas` 使用 `Vcl.Graphics` 的 `TColor` 类型，无法在 FMX 中使用
- 解决: 创建 `UtilsTypesFMX.pas`，使用 `System.UITypes.TAlphaColor` 替代

**2. ConfigManager API 适配**
- 问题: ViewMainFormFMX 调用了不存在的方法 (`IsLoaded`, `GetSections`, `GetKeys`, `GetValue`, `GetJSONValue`, `Clear`)
- 解决: 修改为 ConfigManager 实际 API (`GetINISections`, `GetINIKeys`, `GetINIValue`, `FindReferenceObject`, `SaveAsNewFile`)

**3. 缺少函数**
- 问题: ControllerConfigsFMX 调用了 `GetComplexPropertyTypeName`，ViewMainFormFMX 调用了 `DetectComplexPropertyType`，但这些函数未定义
- 解决: 在 `UtilsTypesFMX.pas` 中添加这两个函数

**4. TComplexPropertyType 枚举不完整**
- 问题: 原枚举缺少 cptTextOnBg, cptImageOnBg, cptCaptionOnBg, cptDateTimeRange 等类型
- 解决: 扩展枚举添加 9 种新类型

**5. JSONHelpers 未加入项目**
- 问题: ConfigManager/INIConfig/JSONConfig 依赖 JSONHelpers，但未加入 dpr
- 解决: 在 ConfigBuildFMX.dpr 中添加 JSONHelpers

**6. dproj 缺失 Frame 引用**
- 问题: `ConfigBuildFMX.dproj` 缺失 FrameSimpleEditorFMX、FrameBgDrawEditorFMX、FrameVideoClipEditorFMX 引用
- 解决: 在 dproj 文件中添加缺失的 DCCReference 条目

**7. ControllerConfigsFMX 基类名称错误**
- 问题: 使用了 `TConfigFrameBaseFMX` 但实际基类名为 `TBaseConfigFrameFMX`
- 解决: 在 ConfigFrameBaseFMX.pas 中添加类型别名 `TConfigFrameBaseFMX = TBaseConfigFrameFMX`

**8. Frame 方法签名不匹配**
- 问题: Frames 的 `LoadFromJSON(AJSON)` 和 `SaveToJSON: TJSONObject` 签名与基类不匹配
- 解决: 在基类中添加重载方法支持两种签名

**9. 缺少 BeginUpdate/EndUpdate 方法**
- 问题: Frame 实现使用了 `BeginUpdate`/`EndUpdate` 但基类未定义
- 解决: 在 TBaseConfigFrameFMX 中添加这些方法

**10. 缺少全局 JSON 帮助函数**
- 问题: Frames 使用 `GetJSONString(JSONObj, Key, Default)` 3 参数版本，但未定义
- 解决: 在 ConfigFrameBaseFMX.pas 中添加全局帮助函数

**11. FrameBgDrawEditorFMX 缺少导入**
- 问题: 使用了 `StringToAlphaColor`/`AlphaColorToString` 但未导入 UtilsTypesFMX
- 解决: 添加 UtilsTypesFMX 到 uses 子句

**12. INIConfig 缺少 TConfigType 定义**
- 问题: `INIConfig.pas` 使用 TConfigType 但未导入任何类型定义模块
- 解决: 添加 UtilsTypesFMX 到 INIConfig.pas 的 uses 子句

---

## 历史修复记录

### 1. ViewBuildConfig.pas 中嵌套过程问题
- **问题描述**：嵌套过程 `HandleDBSave` 和 `HandleDBCancel` 导致代码结构不清晰
- **修复方案**：
  - 将嵌套过程提取为类的私有方法
  - 添加 `OnDBSave` 和 `OnDBCancel` 事件属性
  - 更新 `btnAddDatabaseClick` 中的 DBEditor 初始化代码

### 2. ViewMainConfig.pas 中的重复 uses 问题
- **问题描述**：`uses` 子句中存在重复且拼写错误的单元引用
- **修复方案**：删除重复的 `ViewBuildConifg` 引用，保留正确的 `ViewBuildConfig`

### 3. 运行时错误 217 "非法组件注册"
- **问题描述**：程序启动时出现运行时错误 217
- **修复方案**：
  - 将 `Register` 过程限定在设计时使用（`{$IFDEF DESIGNTIME}`）
  - 移除 `initialization` 节中的 `Register` 调用

### 4. 编译错误：缺少 DesignIntf 单元
- **问题描述**：编译时提示找不到 `DesignIntf` 单元
- **修复方案**：将 `Register` 过程限定为设计时编译，避免运行时依赖设计时单元

### 5. ConfigBuild.exe 文件锁定
- **问题描述**：编译时提示 `Fatal: F2039 Could not create output file 'ConfigBuild.exe'`
- **修复方案**：使用 PowerShell 命令强制终止进程
  ```powershell
  Stop-Process -Name ConfigBuild -Force -ErrorAction SilentlyContinue
  ```

### 6. 结构调整：从 Frame 升级为 Form
- **问题描述**：ViewBuildConfig 作为 Frame 使用时存在生命周期管理问题
- **修复方案**：
  - 将 `TFrame` 更改为 `TForm`
  - 添加 `FormCreate` 和 `FormDestroy` 事件处理
  - 更新 `ConfigBuild.dpr` 中的窗体创建代码
  - 移除 `ViewMainConfig.pas` 相关引用

### 7. 2024-07-11 启动时访问冲突
- **问题描述**：`Exception EAccessViolation in module ConfigBuild.exe at 00261326 ... Read of address 0000330`
- **根本原因**：`ViewBuildConfig.pas` 中的 `ClearAllData` 方法在控件初始化前访问 `tvJSON`
- **修复方案**：
  ```pascal
  if not Assigned(tvJSON) or (tvJSON.Items.Count = 0) then Exit;
  ```
  清理节点数据后再清空树

### 8. 2024-07-11 FrameVideoEditor.pas 编译错误
- **问题描述**：
  - `[dcc32 Error] FrameVideoEditor.pas(318): E2014 Statement expected, but expression of type 'Boolean' found`
  - `[dcc32 Fatal Error] ControllerConfigs.pas(86): F2063 Could not compile used unit 'FrameVideoEditor.pas'`
- **根本原因**：for 循环中缺少 `begin`/`end` 块
- **修复方案**：在 `SaveToJSON` 和 `ClearClips` 的 for 循环中添加 `begin`/`end`

---

*最后更新: 2025-12-02 23:25*
