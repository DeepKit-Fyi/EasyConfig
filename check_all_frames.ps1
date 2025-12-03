# 检查所有Frame文件并确保它们包含JSONHelpers单元
$ErrorActionPreference = "Continue"
Write-Host "===== 开始检查所有Frame文件 ====="

# 寻找所有Frame文件
$frameFiles = Get-ChildItem -Path "." -Filter "Frame*.pas" -File

Write-Host "找到 $($frameFiles.Count) 个Frame文件"

foreach ($file in $frameFiles) {
    Write-Host "检查文件: $($file.Name)"
    
    try {
        # 读取文件内容
        $content = Get-Content -Path $file.FullName -Raw
        
        # 检查是否包含 System.JSON
        if ($content -match "System\.JSON") {
            Write-Host "  文件使用了 System.JSON" -ForegroundColor Yellow
            
            # 检查是否已包含JSONHelpers
            if ($content -match "JSONHelpers") {
                Write-Host "  文件已包含 JSONHelpers" -ForegroundColor Green
            } else {
                Write-Host "  需要添加 JSONHelpers 到uses列表" -ForegroundColor Red
                
                # 在uses中的System.JSON之后添加JSONHelpers
                if ($content -match "uses\s+([^;]+);") {
                    $usesSection = $matches[1]
                    $newUsesSection = $usesSection -replace "(System\.JSON)", "$1, JSONHelpers"
                    
                    if ($usesSection -ne $newUsesSection) {
                        $content = $content -replace [regex]::Escape($usesSection), $newUsesSection
                        
                        # 写回文件
                        try {
                            $content | Set-Content -Path $file.FullName -Force
                            Write-Host "  已添加 JSONHelpers 到uses列表" -ForegroundColor Green
                        }
                        catch {
                            Write-Host "  无法写入文件: $_" -ForegroundColor Red
                        }
                    }
                }
            }
            
            # 检查是否使用了AddPair方法
            if ($content -match "AddPair\(") {
                Write-Host "  文件使用了 AddPair 方法" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "  处理文件时出错: $_" -ForegroundColor Red
    }
}

Write-Host "===== 检查完成 =====" 