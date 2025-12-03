# 修复AddPair实现的脚本
# 如果JSONHelpers.pas不存在或不完整，此脚本会创建或更新它

# 设置错误处理偏好
$ErrorActionPreference = "Continue"

# 定义JSONHelpers.pas的文件路径
$jsonHelpersPath = "JSONHelpers.pas"

# 检查文件是否存在
$jsonHelpersExists = Test-Path $jsonHelpersPath
Write-Host "检查JSONHelpers.pas是否存在: $jsonHelpersExists" -ForegroundColor Cyan

# 定义完整的JSONHelpers单元内容
$jsonHelpersContent = @'
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
'@

if (-not $jsonHelpersExists) {
    # 文件不存在，创建新文件
    Write-Host "创建JSONHelpers.pas文件" -ForegroundColor Yellow
    try {
        $jsonHelpersContent | Set-Content -Path $jsonHelpersPath -Force
        Write-Host "成功创建JSONHelpers.pas文件" -ForegroundColor Green
    } catch {
        Write-Host "创建JSONHelpers.pas文件失败: $_" -ForegroundColor Red
        exit 1
    }
} else {
    # 文件存在，检查是否包含所有必要的AddPair实现
    $content = Get-Content -Path $jsonHelpersPath -Raw
    
    # 检查是否包含所有AddPair重载
    $missingImplementations = $false
    
    # 检查声明
    if (-not ($content -match "function AddPair\(const Name: string; const Value: string\): TJSONObject; overload;")) {
        $missingImplementations = $true
    }
    if (-not ($content -match "function AddPair\(const Name: string; const Value: TJSONValue\): TJSONObject; overload;")) {
        $missingImplementations = $true
    }
    if (-not ($content -match "function AddPair\(const Name: string; const Value: Boolean\): TJSONObject; overload;")) {
        $missingImplementations = $true
    }
    if (-not ($content -match "function AddPair\(const Name: string; const Value: Integer\): TJSONObject; overload;")) {
        $missingImplementations = $true
    }
    if (-not ($content -match "function AddPair\(const Name: string; const Value: Double\): TJSONObject; overload;")) {
        $missingImplementations = $true
    }
    
    # 如果缺少任何实现，则更新文件
    if ($missingImplementations) {
        Write-Host "JSONHelpers.pas存在但不完整，正在更新..." -ForegroundColor Yellow
        try {
            $jsonHelpersContent | Set-Content -Path $jsonHelpersPath -Force
            Write-Host "成功更新JSONHelpers.pas文件" -ForegroundColor Green
        } catch {
            Write-Host "更新JSONHelpers.pas文件失败: $_" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "JSONHelpers.pas文件已存在且包含所有必要实现，无需更新" -ForegroundColor Green
    }
}

Write-Host "`n请确保所有使用System.JSON的文件都包含对JSONHelpers的引用" -ForegroundColor Cyan
Write-Host "可以运行fix_addpair.ps1脚本自动修复" -ForegroundColor Cyan 