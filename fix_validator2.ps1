$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak" + (Get-Date -Format "yyyyMMddHHmmss")

# 创建备份
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "Created backup: $backupPath"

try {
    # 读取文件内容为数组
    $lines = Get-Content -Path $filePath
    Write-Host "Read file content"
    
    # 修复第259行
    if ($lines.Count -ge 259) {
        $lines[258] = $lines[258] -replace "FormatSettings, FDateFormat", "FormatSettings"
        Write-Host "Fixed line 259"
    }
    
    # 寻找AddPasswordRule的实现行
    $implementationLineIndex = -1
    for ($i = 730; $i -lt [Math]::Min(735, $lines.Count); $i++) {
        if ($lines[$i] -match "function TConfigValidator\.AddPasswordRule") {
            $implementationLineIndex = $i
            break
        }
    }
    
    # 如果找到了实现行，修复它
    if ($implementationLineIndex -ge 0) {
        # 修改实现行，使其与接口声明匹配
        $lines[$implementationLineIndex] = "function TConfigValidator.AddPasswordRule(const PropertyPath, PropertyName: string; MinLength: Integer = 8;"
        $lines[$implementationLineIndex+1] = "                                        RequireUpperCase: Boolean = True; RequireDigit: Boolean = True;"
        $lines[$implementationLineIndex+2] = "                                        RequireSpecialChar: Boolean = True;"
        $lines[$implementationLineIndex+3] = "                                        const ErrorMessage: string = ''): TValidationRule;"
        Write-Host "Fixed AddPasswordRule implementation"
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