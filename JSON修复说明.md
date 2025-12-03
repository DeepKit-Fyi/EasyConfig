# JSON问题修复说明

## 问题描述

项目编译时出现"未声明标识符：AddPair"错误。这是因为TJSONObject类并不直接提供AddPair方法。

## 修复方案

1. 我们创建并更新了`JSONHelpers.pas`文件，其中包含:
   - 定义了TJSONObjectHelper类扩展TJSONObject
   - 实现了5种重载的AddPair方法:
     - `AddPair(const Name: string; const Value: string): TJSONObject;`
     - `AddPair(const Name: string; const Value: TJSONValue): TJSONObject;`
     - `AddPair(const Name: string; const Value: Boolean): TJSONObject;`
     - `AddPair(const Name: string; const Value: Integer): TJSONObject;`
     - `AddPair(const Name: string; const Value: Double): TJSONObject;`

2. 我们确保所有使用System.JSON的Frame文件都在uses列表中包含了JSONHelpers单元。

3. 创建了检查脚本`check_all_frames.ps1`，用于检查所有Frame文件并自动更新它们的uses列表。

## 受影响的文件

以下是使用AddPair方法的文件已被更新：

- FrameArrayEditor.pas
- FrameBgDrawEditor.pas
- FrameDateTimeRangeEditor.pas
- FrameDBEditor.pas
- FrameEncryptEditor.pas
- FrameFontEditor.pas
- FrameGeoLocationEditor.pas
- FrameKeyValueDictEditor.pas
- FrameListEditor.pas
- FrameNetConfigEditor.pas
- FrameObjectEditor.pas
- FrameUrlConfigEditor.pas
- FrameVideoEditor.pas

## 注意事项

如果今后添加新的Frame文件，需要确保：

1. 如果文件使用System.JSON并调用AddPair方法，必须在uses列表中包含JSONHelpers单元
2. 可以运行`check_all_frames.ps1`脚本自动检查和修复uses列表

## 扩展阅读

- [Delphi类扩展(Class Helpers)文档](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Class_and_Record_Helpers)
- [System.JSON单元文档](https://docwiki.embarcadero.com/Libraries/Alexandria/en/System.JSON) 