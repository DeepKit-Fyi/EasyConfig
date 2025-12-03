# Requirements Document

## Introduction

EasyConfig（易配）是一个基于 Delphi + FMX 的通用配置编辑器，用于可视化编辑 INI + JSON 双文件配置。本文档定义 MVP 版本的核心需求，目标是实现"可以安全地编辑一套 INI+JSON 配置，并完成基本验证"。

## Glossary

- **ConfigManager**: 配置管理器，负责 INI + JSON 文件的加载、保存和一致性维护
- **ConfigValidator**: 配置验证器，执行验证规则并输出错误/警告/自动修复建议
- **TConfigType**: 配置项的逻辑类型枚举（简单/复杂）
- **TEditorType**: 编辑器类型枚举（简单编辑控件/复杂 Frame）
- **TBaseConfigFrameFMX**: FMX 复杂属性编辑器的基类
- **配置单元**: 由一对 INI + JSON 文件组成的配置集合
- **简单属性**: 文本、整数、浮点、布尔、颜色、路径等基本类型
- **复杂属性**: 字体、数据库连接、AI API、背景布局、视频片段等结构化类型

## Requirements

### Requirement 1: 配置工程管理

**User Story:** As a 开发者, I want to 打开、保存和管理 INI+JSON 配置工程, so that 我可以安全地维护应用程序的配置文件。

#### Acceptance Criteria

1. WHEN 用户选择打开配置按钮并选择一个 INI 文件 THEN ConfigManager SHALL 解析 INI 的 `[json_file]` 节并自动加载关联的 JSON 文件
2. WHEN INI 文件中指定的 JSON 文件不存在 THEN ConfigManager SHALL 创建一个空的 JSON 文件并显示提示信息
3. WHEN 用户点击保存按钮 THEN ConfigManager SHALL 先写入 JSON 文件再写入 INI 文件，并在 backup 目录生成带时间戳的备份文件
4. WHEN 用户点击另存为按钮 THEN ConfigManager SHALL 允许用户选择新的文件路径并保存 INI+JSON 配置对
5. WHEN 用户点击新建工程按钮 THEN ConfigManager SHALL 创建一对空白的 INI+JSON 文件并在编辑器中打开

### Requirement 2: 配置结构浏览

**User Story:** As a 开发者, I want to 在树形视图中浏览配置结构, so that 我可以快速定位和理解配置的层次关系。

#### Acceptance Criteria

1. WHEN 配置工程加载完成 THEN 左侧树视图 SHALL 展示 INI 的节和键以及 JSON 的对象树结构
2. WHEN 用户单击树节点 THEN 中间区域 SHALL 显示该节点对应的属性列表和值
3. WHEN JSON 对象包含 `_type` 字段 THEN 树节点 SHALL 显示对应的类型图标或标签
4. WHEN JSON 数组包含多个元素 THEN 树视图 SHALL 以子节点形式展示每个数组元素

### Requirement 3: 简单属性编辑

**User Story:** As a 开发者, I want to 直接编辑简单类型的配置属性, so that 我可以快速修改文本、数值、布尔值等基本配置。

#### Acceptance Criteria

1. WHEN 用户双击属性列表中的简单属性 THEN 编辑器 SHALL 显示对应类型的编辑控件（文本框/数值框/复选框/颜色选择器）
2. WHEN 用户修改属性值并确认 THEN ConfigManager SHALL 更新内部模型并标记配置为已修改状态
3. WHEN 用户尝试输入不符合类型约束的值 THEN 编辑器 SHALL 显示验证错误提示并阻止无效输入
4. WHEN 属性类型为路径 THEN 编辑器 SHALL 提供文件/目录浏览按钮
5. WHEN 属性类型为颜色 THEN 编辑器 SHALL 提供颜色选择对话框

### Requirement 4: 复杂属性编辑

**User Story:** As a 开发者, I want to 使用专用编辑器编辑复杂配置类型, so that 我可以方便地配置字体、数据库连接、视频片段等结构化数据。

#### Acceptance Criteria

1. WHEN 用户选中复杂属性并点击编辑按钮 THEN ControllerConfigs SHALL 根据 `_type` 创建对应的 Frame 编辑器
2. WHEN Frame 编辑器加载 THEN 编辑器 SHALL 调用 `LoadFromJSON` 方法填充 JSON 数据到 UI 控件
3. WHEN 用户在 Frame 中修改数据并点击确定 THEN 编辑器 SHALL 调用 `SaveToJSON` 方法将修改写回 JSON 对象
4. WHEN 复杂属性类型为 Font THEN 字体编辑器 SHALL 支持选择字体家族、大小、样式和颜色
5. WHEN 复杂属性类型为 Database THEN 数据库编辑器 SHALL 支持配置主机、端口、数据库名、用户名
6. WHEN 复杂属性类型为 VideoClip THEN 视频片段编辑器 SHALL 支持选择文件路径、设置起止时间、音量和淡入淡出

### Requirement 5: 配置验证

**User Story:** As a 开发者, I want to 验证配置的正确性, so that 我可以在保存前发现并修复配置错误。

#### Acceptance Criteria

1. WHEN 用户点击验证按钮 THEN ConfigValidator SHALL 对当前配置执行所有验证规则
2. WHEN 验证发现必填字段为空 THEN ConfigValidator SHALL 返回错误级别的验证结果
3. WHEN 验证发现数值超出合法范围 THEN ConfigValidator SHALL 返回警告或错误级别的验证结果
4. WHEN 验证发现 `_ref` 引用指向不存在的 `_id` THEN ConfigValidator SHALL 返回错误级别的验证结果
5. WHEN 验证完成 THEN 底部日志区域 SHALL 显示验证结果摘要（错误数/警告数）
6. WHEN 用户双击验证结果条目 THEN 编辑器 SHALL 定位到对应的配置项

### Requirement 6: 原始文档视图

**User Story:** As a 开发者, I want to 查看和编辑原始的 INI/JSON 文本, so that 我可以进行高级编辑或排查格式问题。

#### Acceptance Criteria

1. WHEN 用户切换到原始文档视图 THEN 编辑器 SHALL 在 TMemo 中显示 INI 文件的完整文本内容
2. WHEN 用户切换到 JSON 原文 Tab THEN 编辑器 SHALL 在 TMemo 中显示 JSON 文件的完整文本内容
3. WHEN 用户在原始文档视图中修改文本并保存 THEN ConfigManager SHALL 重新解析文本并更新内部模型
4. IF 原始文档解析失败 THEN ConfigManager SHALL 显示解析错误信息并保留原有模型

### Requirement 7: 撤销/重做功能

**User Story:** As a 开发者, I want to 撤销和重做配置修改, so that 我可以安全地尝试修改并在需要时恢复。

#### Acceptance Criteria

1. WHEN 用户执行任何配置修改操作 THEN 编辑器 SHALL 将操作记录到撤销栈
2. WHEN 用户点击撤销按钮且撤销栈非空 THEN 编辑器 SHALL 恢复到上一个状态并将当前状态压入重做栈
3. WHEN 用户点击重做按钮且重做栈非空 THEN 编辑器 SHALL 恢复到下一个状态
4. WHEN 用户执行新的修改操作 THEN 编辑器 SHALL 清空重做栈

### Requirement 8: 状态栏与反馈

**User Story:** As a 开发者, I want to 在状态栏看到当前操作状态, so that 我可以了解文件修改状态和验证结果。

#### Acceptance Criteria

1. WHEN 配置工程打开 THEN 状态栏 SHALL 显示当前 INI 文件的完整路径
2. WHEN 配置被修改但未保存 THEN 状态栏 SHALL 显示"已修改"标记
3. WHEN 配置保存成功 THEN 状态栏 SHALL 显示"已保存"提示
4. WHEN 验证完成 THEN 状态栏 SHALL 显示验证结果摘要（如"3 个错误 / 2 个警告"）
