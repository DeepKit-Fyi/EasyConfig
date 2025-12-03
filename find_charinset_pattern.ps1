$filePath = "ConfigValidator.pas"

try {
    # Read file content as array
    $lines = Get-Content -Path $filePath
    Write-Host "Read file content with $($lines.Count) lines"
    
    # Search for character set expressions
    Write-Host "Searching for character set expressions..."
    
    # Check context around line 441
    $startLine = [Math]::Max(430, 0)
    $endLine = [Math]::Min(450, $lines.Count - 1)
    
    Write-Host "Showing code around line 441:"
    for ($i = $startLine; $i -le $endLine; $i++) {
        $lineNumber = $i + 1
        Write-Host "${lineNumber}: $($lines[$i])"
        
        # Search for possible character set patterns
        if ($lines[$i] -match "\s+in\s+\[" -or 
            $lines[$i] -match "c\s+in\s+" -or 
            $lines[$i] -match "char\s+in\s+" -or
            $lines[$i] -match "\w+\s+in\s+\[['A-Za-z0-9,']+\]") {
            Write-Host "Found possible character set expression at line ${lineNumber}" -ForegroundColor Yellow
        }
    }
    
} catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
} 