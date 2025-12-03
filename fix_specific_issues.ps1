$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak" + (Get-Date -Format "yyyyMMddHHmmss")

# Create backup
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "Created backup: $backupPath"

try {
    # Read file content
    $lines = Get-Content -Path $filePath
    Write-Host "Read file with $($lines.Count) lines"
    
    # Fix missing var keyword at line 735-736
    for ($i = 730; $i -lt 740; $i++) {
        if ($i -lt $lines.Count) {
            if ($lines[$i].Contains("function TConfigValidator.AddPasswordRule")) {
                # Check if 'var' is missing
                if ($i+5 < $lines.Count && $lines[$i+5].Trim().StartsWith("Rule:")) {
                    $lines[$i+5] = "var" + $lines[$i+5]
                    Write-Host "Added missing 'var' keyword at line $($i+5+1)"
                }
                break
            }
        }
    }
    
    # Fix specific strings with encoding issues around line 380
    if ($lines.Count -ge 380) {
        $lines[379] = '      vrtRange: '
        $lines[380] = "        Result := Format('请输入介于 %f 到 %f 之间的值', [FMinValue, FMaxValue]);"
        Write-Host "Fixed line 380"
    }
    
    # Fix specific strings with encoding issues around line 386-387
    if ($lines.Count -ge 387) {
        $lines[385] = '          if FMaxLength > 0 then'
        $lines[386] = "            Result := Format('长度必须介于 %d 到 %d 之间', [FMinLength, FMaxLength])"
        $lines[387] = "          else"
        $lines[388] = "            Result := Format('长度至少需要 %d 个字符', [FMinLength]);"
        Write-Host "Fixed lines 386-388"
    }
    
    # Fix line 389 - vrtRegex
    if ($lines.Count -ge 390) {
        $lines[389] = "        Result := '请输入符合格式要求的值';"
        Write-Host "Fixed line 389"
    }
    
    # Fix lines 400-406 - vrtPassword section
    if ($lines.Count -ge 406) {
        $lines[399] = '      vrtPassword: '
        $lines[400] = '        begin'
        $lines[401] = "          Result := Format('密码至少需要 %d 个字符', [FMinLength]);"
        $lines[402] = "          if FPattern.Contains('upper') then"
        $lines[403] = "            Result := Result + '，包含至少一个大写字母';"
        $lines[404] = "          if FPattern.Contains('digit') then"
        $lines[405] = "            Result := Result + '，包含至少一个数字';"
        $lines[406] = "          if FPattern.Contains('special') then"
        $lines[407] = "            Result := Result + '，包含至少一个特殊字符';"
        Write-Host "Fixed lines 400-407"
    }
    
    # Fix lines 410-420 - Various validation error messages
    if ($lines.Count -ge 420) {
        $lines[410] = '      vrtColorCode: '
        $lines[411] = "        Result := '请输入有效的颜色代码，例如 #FF0000 (红色)';"
        $lines[412] = '      vrtUnique: '
        $lines[413] = "        Result := '请输入唯一的值，该值已被使用';"
        $lines[414] = '      vrtJSON: '
        $lines[415] = "        Result := '请输入有效的JSON格式';"
        $lines[416] = '      vrtXML: '
        $lines[417] = "        Result := '请输入有效的XML格式';"
        $lines[418] = '      vrtCustom: '
        $lines[419] = "        Result := '请根据自定义规则修正此值';"
        Write-Host "Fixed lines 410-419"
    }
    
    # Fix default case at line 421-423
    if ($lines.Count -ge 423) {
        $lines[420] = '    else'
        $lines[421] = "      Result := '请修正此值';"
        $lines[422] = '    end;'
        Write-Host "Fixed lines 421-423"
    }
    
    # Fix line 442 - Default return comment
    if ($lines.Count -ge 442) {
        $lines[441] = "  Result := Value; // 默认返回原值"
        Write-Host "Fixed line 442"
    }
    
    # Fix lines 746-751 - Password rule messages
    if ($lines.Count -ge 751) {
        $lines[745] = '  if ActualErrorMessage = '''' then'
        $lines[746] = '  begin'
        $lines[747] = "    ActualErrorMessage := Format('密码必须至少包含 %d 个字符', [MinLength]);"
        $lines[748] = "    if RequireUpperCase then ActualErrorMessage := ActualErrorMessage + '，至少一个大写字母';"
        $lines[749] = "    if RequireDigit then ActualErrorMessage := ActualErrorMessage + '，至少一个数字';"
        $lines[750] = "    if RequireSpecialChar then ActualErrorMessage := ActualErrorMessage + '，至少一个特殊字符';"
        Write-Host "Fixed lines 746-751"
    }
    
    # Write back to file
    $lines | Set-Content -Path $filePath -Force
    Write-Host "Saved fixed file"
    
    Write-Host "All specific issues fixed successfully!"
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
    # Restore from backup
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "Restored from backup"
} 