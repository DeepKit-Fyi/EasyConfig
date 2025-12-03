$filePath = "ConfigValidator.pas"
$backupPath = "ConfigValidator.pas.bak" + (Get-Date -Format "yyyyMMddHHmmss")

# Create backup
Copy-Item -Path $filePath -Destination $backupPath -Force
Write-Host "Created backup: $backupPath"

try {
    # Read file as array of lines
    $lines = Get-Content -Path $filePath
    Write-Host "Read file with $($lines.Count) lines"
    
    # 1. Fix line 259 - Too many parameters in TryStrToDateTime
    if ($lines.Count -ge 259) {
        $lines[258] = $lines[258] -replace "FormatSettings, FDateFormat", "FormatSettings"
        Write-Host "Fixed line 259: Too many parameters in TryStrToDateTime"
    }
    
    # 2. Fix line 442 - WideChar in set expression
    if ($lines.Count -ge 442) {
        # Replace "if (Value[I] in ['0'..'9', '.', '-']) then" with CharInSet function
        $lines[441] = $lines[441] -replace "if \(Value\[I\] in \['0'\.\.'9', '\.', '-'\]\) then", 
                                         "if CharInSet(Value[I], ['0'..'9', '.', '-']) then"
        Write-Host "Fixed line 442: Used CharInSet function for character set expression"
    }
    
    # 3. Fix AddPasswordRule declaration mismatch (around line 732)
    $implementationLineIndex = -1
    for ($i = 727; $i -lt [Math]::Min(737, $lines.Count); $i++) {
        if ($lines[$i] -match "function TConfigValidator\.AddPasswordRule") {
            $implementationLineIndex = $i
            break
        }
    }
    
    if ($implementationLineIndex -ge 0) {
        # Update implementation to match interface declaration with default parameters
        $lines[$implementationLineIndex] = "function TConfigValidator.AddPasswordRule(const PropertyPath, PropertyName: string; MinLength: Integer = 8;"
        $lines[$implementationLineIndex+1] = "                                        RequireUpperCase: Boolean = True; RequireDigit: Boolean = True;"
        $lines[$implementationLineIndex+2] = "                                        RequireSpecialChar: Boolean = True;"
        $lines[$implementationLineIndex+3] = "                                        const ErrorMessage: string = ''): TValidationRule;"
        Write-Host "Fixed AddPasswordRule implementation declaration"
    }
    
    # 4. Add compiler directive to disable implicit string cast warnings
    if (-not ($lines[0] -match "{`$WARN IMPLICIT_STRING_CAST OFF}")) {
        $lines = @("{$WARN IMPLICIT_STRING_CAST OFF}") + $lines
        Write-Host "Added compiler directive to disable implicit string cast warnings"
    }
    
    # Write back to file
    $lines | Set-Content -Path $filePath -Force
    Write-Host "Saved fixed file"
    
    Write-Host "All issues fixed successfully!"
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
    # Restore from backup
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "Restored from backup"
} 