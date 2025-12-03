# Implementation Plan

## Phase 1: 核心基础设施

- [x] 1. 完善 ConfigManager 核心功能
  - [x] 1.1 实现 OpenProject 方法，解析 INI 的 [json_file] 节并加载关联 JSON
    - 解析 INI 文件，读取 file_path 键值
    - 支持相对路径和绝对路径
    - JSON 不存在时创建空文件
    - _Requirements: 1.1, 1.2_
  - [x] 1.2 实现 SaveProject 方法，先写 JSON 再写 INI，生成备份
    - 使用临时文件保证原子性
    - 在 backup 目录生成带时间戳的备份
    - _Requirements: 1.3_
  - [x] 1.3 编写 ConfigManager Round-Trip 属性测试
    - **Property 1: 配置加载/保存 Round-Trip**
    - **Validates: Requirements 1.1, 1.3, 6.3**
  - [x] 1.4 实现 SaveProjectAs 和 NewProject 方法
    - SaveProjectAs 保存到新路径
    - NewProject 创建空白 INI+JSON 对
    - _Requirements: 1.4, 1.5_

- [x] 2. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 2: 类型系统与编辑器映射

- [x] 3. 完善 UtilsTypesFMX 类型系统
  - [x] 3.1 实现 ConfigTypeToEditorType 映射函数
    - 简单类型映射到对应编辑控件
    - 复杂类型映射到 etFrameEditor
    - _Requirements: 3.1_
  - [x] 3.2 实现 StringToConfigType 和 ConfigTypeToString 转换函数
    - 支持 JSON _type 字段与枚举的双向转换
    - _Requirements: 2.3_
  - [x] 3.3 编写类型映射一致性属性测试
    - **Property 3: 类型到编辑器映射一致性**
    - **Validates: Requirements 3.1, 4.1**

- [x] 4. 完善 ControllerConfigsFMX Frame 工厂
  - [x] 4.1 实现 GetFrameClassForType 方法
    - 返回 TConfigType 对应的 Frame 类
    - 支持 Font/Database/AIAPI/BgDraw/VideoClip 类型
    - _Requirements: 4.1_
  - [x] 4.2 实现 CreateFrameForType 方法
    - 根据类型创建 Frame 实例
    - 设置 Parent 和初始化
    - _Requirements: 4.1_
  - [x] 4.3 实现 RegisterFrameClass 扩展机制
    - 允许运行时注册新的类型-Frame 映射
    - _Requirements: 4.1_

- [x] 5. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 3: 简单属性编辑

- [x] 6. 实现简单属性内联编辑
  - [x] 6.1 实现属性列表双击编辑功能
    - 根据属性类型显示对应编辑控件
    - 文本/数值/布尔/颜色/路径
    - _Requirements: 3.1_
  - [x] 6.2 实现属性值修改回写到 ConfigManager
    - 修改后更新内部模型
    - 标记配置为已修改状态
    - _Requirements: 3.2_
  - [x] 6.3 实现输入验证逻辑
    - 类型约束检查
    - 显示验证错误提示
    - 阻止无效输入
    - _Requirements: 3.3_
  - [x] 6.4 编写输入验证属性测试
    - **Property 8: 输入验证拒绝无效值**
    - **Validates: Requirements 3.3**
  - [x] 6.5 实现路径选择器和颜色选择器
    - 路径属性提供浏览按钮
    - 颜色属性提供颜色对话框
    - _Requirements: 3.4, 3.5_

- [x] 7. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 4: 复杂属性编辑器

- [x] 8. 完善 TBaseConfigFrameFMX 基类
  - [x] 8.1 实现 LoadFromJSON/SaveToJSON 抽象方法框架
    - 定义标准接口
    - 实现 BeginUpdate/EndUpdate
    - _Requirements: 4.2, 4.3_
  - [x] 8.2 实现 OnModified 事件机制
    - DoModified 方法触发事件
    - 与主界面通信
    - _Requirements: 4.3_
  - [x] 8.3 编写 Frame 编辑器 Round-Trip 属性测试
    - **Property 4: Frame 编辑器 LoadFromJSON/SaveToJSON Round-Trip**
    - **Validates: Requirements 4.2, 4.3**

- [x] 9. 完善各复杂属性编辑器
  - [x] 9.1 完善 FrameFontEditorFMX
    - 字体家族、大小、样式、颜色选择
    - LoadFromJSON/SaveToJSON 实现
    - _Requirements: 4.4_
  - [x] 9.2 完善 FrameDBEditorFMX
    - 主机、端口、数据库名、用户名配置
    - LoadFromJSON/SaveToJSON 实现
    - _Requirements: 4.5_
  - [x] 9.3 完善 FrameVideoClipEditorFMX
    - 文件路径、起止时间、音量、淡入淡出
    - LoadFromJSON/SaveToJSON 实现
    - _Requirements: 4.6_

- [x] 10. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 5: 配置验证

- [x] 11. 完善 ConfigValidator 验证器
  - [x] 11.1 实现 ValidateAll 方法
    - 遍历所有配置项执行验证规则
    - 返回验证结果列表
    - _Requirements: 5.1_
  - [x] 11.2 实现必填字段验证规则
    - 检查必填字段是否为空
    - 返回 vlError 级别结果
    - _Requirements: 5.2_
  - [x] 11.3 实现数值范围验证规则
    - 检查数值是否在合法范围内
    - 返回 vlWarning 或 vlError 级别结果
    - _Requirements: 5.3_
  - [x] 11.4 实现引用验证规则
    - 检查 _ref 是否指向有效 _id
    - 返回 vlError 级别结果
    - _Requirements: 5.4_
  - [x] 11.5 编写验证规则完整性属性测试
    - **Property 5: 验证规则完整性**
    - **Validates: Requirements 5.2, 5.4**

- [x] 12. 实现验证结果展示
  - [x] 12.1 在底部日志区域显示验证结果
    - 显示错误数/警告数摘要
    - 列表展示每条验证结果
    - _Requirements: 5.5_
  - [x] 12.2 实现双击定位功能
    - 双击验证结果条目定位到配置项
    - _Requirements: 5.6_

- [x] 13. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 6: 树视图与结构浏览

- [x] 14. 完善配置树视图
  - [x] 14.1 实现 INI 节和键的树节点生成
    - 解析 INI 结构生成树节点
    - 支持节点展开/折叠
    - _Requirements: 2.1_
  - [x] 14.2 实现 JSON 对象树的树节点生成
    - 递归解析 JSON 结构
    - 数组元素作为子节点
    - _Requirements: 2.1, 2.4_
  - [x] 14.3 实现类型标签显示
    - 根据 _type 字段显示类型图标或标签
    - _Requirements: 2.3_
  - [x] 14.4 编写树结构正确性属性测试
    - **Property 2: 树结构正确反映配置**
    - **Validates: Requirements 2.1, 2.3, 2.4**
  - [x] 14.5 实现节点选择联动
    - 单击节点显示对应属性列表
    - _Requirements: 2.2_

- [x] 15. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 7: 撤销/重做功能

- [x] 16. 实现 UndoRedoManager
  - [x] 16.1 实现 TConfigCommand 基类
    - Execute/Undo 抽象方法
    - GetDescription 方法
    - _Requirements: 7.1_
  - [x] 16.2 实现 ExecuteCommand 方法
    - 执行命令并记录到撤销栈
    - 清空重做栈
    - _Requirements: 7.1, 7.4_
  - [x] 16.3 实现 Undo/Redo 方法
    - Undo 恢复上一状态，压入重做栈
    - Redo 恢复下一状态
    - _Requirements: 7.2, 7.3_
  - [x] 16.4 编写撤销/重做栈一致性属性测试
    - **Property 6: 撤销/重做栈一致性**
    - **Validates: Requirements 7.1, 7.2, 7.3, 7.4**

- [x] 17. 集成撤销/重做到编辑操作
  - [x] 17.1 为简单属性修改创建 Command
    - TSetValueCommand 封装值修改
    - _Requirements: 7.1_
  - [x] 17.2 为复杂属性修改创建 Command
    - TSetJSONCommand 封装 JSON 修改
    - _Requirements: 7.1_
  - [x] 17.3 绑定 actUndo/actRedo 动作
    - 工具栏按钮和快捷键
    - _Requirements: 7.2, 7.3_

- [x] 18. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 8: 原始文档视图

- [x] 19. 实现原始文档视图
  - [x] 19.1 实现 INI 原文 Tab
    - TMemo 显示 INI 完整内容
    - 支持只读/可编辑模式
    - _Requirements: 6.1_
  - [x] 19.2 实现 JSON 原文 Tab
    - TMemo 显示 JSON 完整内容
    - 支持只读/可编辑模式
    - _Requirements: 6.2_
  - [x] 19.3 实现原文修改同步
    - 修改后重新解析更新模型
    - 解析失败显示错误信息
    - _Requirements: 6.3, 6.4_

- [x] 20. Checkpoint - 确保所有测试通过
  - Ensure all tests pass, ask the user if questions arise.

## Phase 9: 状态栏与 UI 完善

- [x] 21. 实现状态栏
  - [x] 21.1 显示当前文件路径
    - 工程打开后显示 INI 文件路径
    - _Requirements: 8.1_
  - [x] 21.2 显示修改状态
    - 已修改/已保存状态标记
    - _Requirements: 8.2, 8.3_
  - [x] 21.3 编写修改状态正确性属性测试
    - **Property 7: 修改状态正确性**
    - **Validates: Requirements 8.2, 8.3**
  - [x] 21.4 显示验证结果摘要
    - 错误数/警告数
    - _Requirements: 8.4_

- [x] 22. 完善 TAction 动作系统
  - [x] 22.1 实现 actClose 关闭当前工程
    - 检查未保存修改
    - 提示保存确认
    - _Requirements: 1.1_
  - [x] 22.2 实现 actValidate 验证配置
    - 触发 ConfigValidator.ValidateAll
    - 显示验证结果
    - _Requirements: 5.1_
  - [x] 22.3 实现 actAddSimple/actAddComplex 添加属性
    - 添加简单属性到 INI
    - 添加复杂属性到 JSON
    - _Requirements: 3.2, 4.3_

- [x] 23. Final Checkpoint - 确保所有测试通过

  - Ensure all tests pass, ask the user if questions arise.
