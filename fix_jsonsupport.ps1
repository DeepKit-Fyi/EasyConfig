# 添加System.JSON单元的额外支持脚本
# 此脚本将在FrameDateTimeRangeEditor.pas文件中添加必要的uses引用

$ErrorActionPreference = "Continue"
Write-Host "===== JSON支持修复脚本开始 ====="

$targetFile = "FrameDateTimeRangeEditor.pas"
Write-Host "正在检查文件: $targetFile"

# 检查文件是否存在
if (-not (Test-Path $targetFile)) {
    Write-Host "错误: 找不到文件 $targetFile" -ForegroundColor Red
    exit 1
}

try {
    # 读取文件内容
    $content = Get-Content -Path $targetFile -Raw
    Write-Host "成功读取文件内容"
    
    # 检查uses列表是否包含必要的单元
    if ($content -match "uses\s+([^;]+);") {
        $usesSection = $matches[1]
        Write-Host "找到uses部分: $usesSection"
        
        # 检查是否已包含JSONHelpers
        if ($usesSection -notmatch "JSONHelpers") {
            Write-Host "需要添加JSONHelpers到uses列表" -ForegroundColor Yellow
            
            # 在uses中的System.JSON之后添加JSONHelpers
            $newUsesSection = $usesSection -replace "(System.JSON)", "$1, JSONHelpers"
            $content = $content -replace [regex]::Escape($usesSection), $newUsesSection
            
            # 写回文件
            try {
                $content | Set-Content -Path $targetFile -Force
                Write-Host "已成功添加JSONHelpers到uses列表" -ForegroundColor Green
            }
            catch {
                Write-Host "无法写入文件: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "uses列表已包含JSONHelpers，无需修改" -ForegroundColor Green
        }
    } else {
        Write-Host "无法在文件中找到uses部分，请手动检查" -ForegroundColor Red
    }
}
catch {
    Write-Host "处理文件时出错: $_" -ForegroundColor Red
}

# 检查是否需要创建JSONHelpers单元（如果不存在）
$helperFile = "JSONHelpers.pas"
if (-not (Test-Path $helperFile)) {
    Write-Host "JSONHelpers.pas不存在，创建基本实现..." -ForegroundColor Yellow
    
    $helperContent = @"
unit JSONHelpers;

interface

uses
  System.JSON, System.SysUtils;

type
  // JSON对象辅助扩展
  TJSONObjectHelper = class helper for TJSONObject
  public
    function AddPair(const Name: string; const Value: string): TJSONObject; overload;
    function AddPair(const Name: string; const Value: TJSONValue): TJSONObject; overload;
  end;

implementation

{ TJSONObjectHelper }

function TJSONObjectHelper.AddPair(const Name: string; const Value: string): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(Name, Value));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: TJSONValue): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(Name, Value));
end;

end.
"@

    try {
        $helperContent | Set-Content -Path $helperFile -Force
        Write-Host "已创建JSONHelpers.pas文件，包含AddPair扩展方法" -ForegroundColor Green
    }
    catch {
        Write-Host "创建JSONHelpers.pas文件失败: $_" -ForegroundColor Red
    }
} else {
    Write-Host "JSONHelpers.pas文件已存在" -ForegroundColor Green
}

Write-Host "===== JSON支持修复脚本完成 =====" 