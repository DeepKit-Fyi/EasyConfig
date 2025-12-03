$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak" + (Get-Date -Format "yyyyMMddHHmmss")

# 创建备份
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "Created backup: $backupPath"

try {
    # 读取文件内容为数组
    $lines = Get-Content -Path $filePath
    Write-Host "Read file content with $($lines.Count) lines"
    
    # 定位第441行
    if ($lines.Count -ge 441) {
        # 显示第441行及其上下文
        Write-Host "Line 441: $($lines[440])"
        Write-Host "Line 440: $($lines[439])"
        Write-Host "Line 442: $($lines[441])"
        
        # 根据警告修复第441行
        # W1050 WideChar reduced to byte char in set expressions. Consider using 'CharInSet' function in 'SysUtils' unit
        # 尝试识别字符在集合表达式中的用法并替换为CharInSet
        $line = $lines[440]
        if ($line -match "if\s+(\S+)\s+in\s+\[([^\]]+)\]") {
            $char = $matches[1]
            $set = $matches[2]
            $newLine = $line -replace "if $char in \[$set\]", "if CharInSet($char, [$set])"
            $lines[440] = $newLine
            Write-Host "Fixed line 441 using CharInSet function"
        } else {
            Write-Host "Could not identify 'in' set expression at line 441. Manual fix required."
        }
    } else {
        Write-Host "File has less than 441 lines"
    }
    
    # 写回文件
    $lines | Set-Content -Path $filePath -Force
    Write-Host "Saved fixed file"
    
    Write-Host "Fix completed successfully"
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
    # 恢复备份
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "Restored from backup"
} 