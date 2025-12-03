$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak" + (Get-Date -Format "yyyyMMddHHmmss")

# 创建备份
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "Created backup: $backupPath"

try {
    # 读取文件内容
    $content = Get-Content -Path $filePath -Raw
    Write-Host "Read file content"
    
    # 在文件顶部添加编译指令来禁用隐式转换警告
    if (-not ($content -match "{`$WARN IMPLICIT_STRING_CAST OFF}")) {
        $content = "{`$WARN IMPLICIT_STRING_CAST OFF}`r`n" + $content
        Write-Host "Added compiler directive to disable implicit string cast warnings"
    }
    
    # 修复CharInSet警告
    # 这个警告是在第441行: W1050 WideChar reduced to byte char in set expressions. Consider using 'CharInSet' function in 'SysUtils' unit.
    # 我们需要找到对应的代码并修改
    $lines = $content -split "`r`n"
    
    for ($i = 440; $i -lt 442; $i++) {
        if ($i -lt $lines.Count) {
            # 检查是否有类似 if Char in [...] 的代码
            if ($lines[$i] -match "if\s+([^in]+)\s+in\s+\[([^\]]+)\]") {
                $charVar = $matches[1].Trim()
                $charSet = $matches[2].Trim()
                # 替换为 if CharInSet(Char, [...])
                $lines[$i] = $lines[$i] -replace "if\s+$charVar\s+in\s+\[$charSet\]", "if CharInSet($charVar, [$charSet])"
                Write-Host "Fixed CharInSet usage at line $($i+1)"
            }
        }
    }
    
    # 更新内容
    $content = $lines -join "`r`n"
    
    # 写回文件
    $content | Set-Content -Path $filePath -Force
    Write-Host "Saved fixed file"
    
    Write-Host "Fix completed successfully"
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
    # 恢复备份
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "Restored from backup"
} 