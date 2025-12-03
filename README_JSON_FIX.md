# JSON AddPair 问题修复指南

## 问题说明

在项目编译过程中出现以下错误：

```
[dcc32 Error] FrameDateTimeRangeEditor.pas(208): E2003 Undeclared identifier: 'AddPair'
```

这是因为项目使用了 `System.JSON` 单元中的 `TJSONObject` 类，但是不同版本的 Delphi 中 `TJSONObject` 类的实现可能有差异。在某些 Delphi 版本中，`TJSONObject` 类原生支持 `AddPair` 方法，而在其他版本中则没有这个方法。

为了解决这个问题，我们创建了一个 `JSONHelpers.pas` 单元，它通过类辅助器（Class Helper）为 `TJSONObject` 类添加了 `AddPair` 方法的多个重载版本。

## 解决方案

解决方案包括两个关键步骤：

1. 确保 `JSONHelpers.pas` 文件存在并包含所有必要的 `AddPair` 方法实现
2. 确保所有使用 `System.JSON` 单元的文件也引用了 `JSONHelpers` 单元

为此，我们提供了两个PowerShell脚本：

### 1. fix_addpair_implementation.ps1

这个脚本检查 `JSONHelpers.pas` 文件是否存在并包含所有必要的 `AddPair` 方法实现。如果文件不存在或不完整，脚本将创建或更新该文件。

使用方法：

```powershell
.\fix_addpair_implementation.ps1
```

### 2. fix_addpair.ps1

这个脚本查找项目中所有使用 `System.JSON` 但没有引用 `JSONHelpers` 的文件，并自动添加必要的引用。

使用方法：

```powershell
.\fix_addpair.ps1
```

## 手动修复步骤

如果自动修复脚本不起作用，您可以按照以下步骤手动修复问题：

1. 确保项目中存在 `JSONHelpers.pas` 文件，其内容如下：

```pascal
unit JSONHelpers;

interface

uses
  System.SysUtils, System.Classes, System.JSON;

type
  TJSONObjectHelper = class helper for TJSONObject
  public
    function AddPair(const Name: string; const Value: string): TJSONObject; overload;
    function AddPair(const Name: string; const Value: TJSONValue): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Boolean): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Integer): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Double): TJSONObject; overload;
  end;

implementation

function TJSONObjectHelper.AddPair(const Name: string; const Value: string): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONString.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: TJSONValue): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), Value));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Boolean): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONBool.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Integer): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONNumber.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Double): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONNumber.Create(Value)));
end;

end.
```

2. 在所有使用 `System.JSON` 的文件中，确保 `uses` 语句也包含 `JSONHelpers`，例如：

```pascal
uses
  System.JSON, JSONHelpers;
```

## 验证修复

运行上述修复步骤后，请重新编译项目以验证问题是否已解决。如果仍然存在编译错误，请检查具体错误消息并相应修复。 