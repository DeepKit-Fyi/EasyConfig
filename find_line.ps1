$filePath = "ConfigValidator.pas"
if (Test-Path $filePath) {
    $content = Get-Content $filePath
    if ($content.Count -ge 732) {
        Write-Host "Line 732: $($content[731])"
        # 输出上下文
        Write-Host "Context:"
        for ($i = 727; $i -lt 737; $i++) {
            if ($i -ge 0 -and $i -lt $content.Count) {
                Write-Host "$($i+1): $($content[$i])"
            }
        }
    } else {
        Write-Host "File has less than 732 lines."
    }
} else {
    Write-Host "File not found: $filePath"
} 