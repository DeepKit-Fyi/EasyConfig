$filePath = "ConfigValidator.pas"

try {
    # 读取文件内容为数组
    $lines = Get-Content -Path $filePath
    Write-Host "Read file content with $($lines.Count) lines"
    
    # 查找所有包含 "in [" 表达式的行
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "\s+in\s+\[") {
            $lineNumber = $i + 1
            Write-Host "Line ${lineNumber}: $($lines[$i])"
        }
    }
    
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
} 