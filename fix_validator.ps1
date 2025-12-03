$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak"

# 创建备份
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "已创建备份: $backupPath"

try {
    # 读取文件内容
    $content = Get-Content -Path $filePath -Raw
    Write-Host "已读取文件内容"
    
    # 1. 修复第259行 TryStrToDateTime 参数过多问题
    # 原来的代码: Result := TryStrToDateTime(Value, DtValue, FormatSettings, FDateFormat);
    # 修改为正确的参数数量
    $pattern1 = "Result := TryStrToDateTime\(Value, DtValue, FormatSettings, FDateFormat\);"
    $replacement1 = "Result := TryStrToDateTime(Value, DtValue, FormatSettings);"
    $content = $content -replace $pattern1, $replacement1
    Write-Host "已修复 TryStrToDateTime 参数过多问题"
    
    # 2. 修复第732行附近 AddPasswordRule 函数声明不一致问题
    # 查找接口声明和实现声明，确保它们一致
    $interfacePattern = "function AddPasswordRule\(const PropertyPath, PropertyName: string; MinLength: Integer = 8;[^;]+;"
    $implementationPattern = "function TConfigValidator.AddPasswordRule\(const PropertyPath, PropertyName: string; MinLength: Integer;[^;]+;"
    
    if ($content -match $interfacePattern) {
        $interfaceDeclaration = $matches[0]
        Write-Host "找到接口声明: $interfaceDeclaration"
        
        # 将实现声明匹配接口声明的参数格式
        $correctedImplementation = $interfaceDeclaration -replace "function AddPasswordRule", "function TConfigValidator.AddPasswordRule"
        $correctedImplementation = $correctedImplementation -replace " = 8;", ";"
        $correctedImplementation = $correctedImplementation -replace " = True;", ";"
        $correctedImplementation = $correctedImplementation -replace " = '';", ";"
        
        # 替换实现部分声明
        $content = $content -replace $implementationPattern, $correctedImplementation
        Write-Host "已修复 AddPasswordRule 函数声明不一致问题"
    } else {
        Write-Host "未找到 AddPasswordRule 接口声明，无法修复"
    }
    
    # 写回文件
    $content | Set-Content -Path $filePath -Force
    Write-Host "已保存修复后的文件"
    
    Write-Host "修复完成"
} catch {
    Write-Host "处理文件时出错: $_" -ForegroundColor Red
    # 恢复备份
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "已从备份恢复文件"
} 