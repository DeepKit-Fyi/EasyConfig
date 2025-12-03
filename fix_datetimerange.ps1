# 修复FrameDateTimeRangeEditor.pas文件
$targetFile = "FrameDateTimeRangeEditor.pas"

if (-not (Test-Path $targetFile)) {
    Write-Host "错误: 找不到文件 $targetFile" -ForegroundColor Red
    exit 1
}

$content = Get-Content -Path $targetFile -Raw

# 检查使用部分
if ($content -match 'uses\s+([^;]+);') {
    $usesSection = $matches[1]
    
    # 检查是否已经包含JSONHelpers
    if ($usesSection -notmatch 'JSONHelpers') {
        Write-Host "添加JSONHelpers到uses部分..." -ForegroundColor Yellow
        
        # 修改uses部分
        $newUsesSection = $usesSection -replace 'System\.JSON', 'System.JSON, JSONHelpers'
        $newContent = $content -replace [regex]::Escape($usesSection), $newUsesSection
        
        # 写回文件
        $newContent | Set-Content -Path $targetFile -Force
        Write-Host "成功添加JSONHelpers到uses部分" -ForegroundColor Green
    } else {
        Write-Host "文件已包含JSONHelpers引用，无需修改" -ForegroundColor Green
    }
} else {
    Write-Host "无法找到uses部分，请手动检查文件" -ForegroundColor Red
}

Write-Host "修复完成，请重新编译项目" -ForegroundColor Cyan 