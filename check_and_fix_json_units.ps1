# 设置错误处理
$ErrorActionPreference = "Stop"

# 定义搜索路径
$searchPath = "."
Write-Host "开始在 $searchPath 搜索需要修复的Delphi单元文件..."

# 获取所有.pas文件
$files = Get-ChildItem -Path $searchPath -Filter "*.pas" -Recurse

Write-Host "找到 $($files.Count) 个.pas文件"

$fixedCount = 0
$alreadyFixedCount = 0
$errorCount = 0

foreach ($file in $files) {
    try {
        # 读取文件内容
        $content = Get-Content -Path $file.FullName -Raw -Encoding Default
        
        # 检查文件是否使用System.JSON但不使用JSONHelpers
        if ($content -match "uses[\s\S]*System\.JSON[\s\S]*;" -and -not ($content -match "uses[\s\S]*JSONHelpers[\s\S]*;")) {
            Write-Host "修复文件: $($file.FullName)"
            
            # 替换uses部分，在System.JSON后添加JSONHelpers
            $newContent = $content -replace "(uses[\s\S]*System\.JSON)([,\s\S]*;)", "`$1, JSONHelpers`$2"
            
            # 保存修改后的内容
            $newContent | Set-Content -Path $file.FullName -Encoding Default
            
            $fixedCount++
            Write-Host "  已修复" -ForegroundColor Green
        } else if ($content -match "uses[\s\S]*System\.JSON[\s\S]*JSONHelpers[\s\S]*;") {
            Write-Host "文件已正确配置: $($file.FullName)" -ForegroundColor Cyan
            $alreadyFixedCount++
        }
    } catch {
        Write-Host "处理文件 $($file.FullName) 时出错: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n总结:" -ForegroundColor Yellow
Write-Host "已修复的文件: $fixedCount" -ForegroundColor Green
Write-Host "已正确配置的文件: $alreadyFixedCount" -ForegroundColor Cyan
Write-Host "处理出错的文件: $errorCount" -ForegroundColor Red

Write-Host "`n请重新编译项目以验证问题是否已解决。" -ForegroundColor Yellow 