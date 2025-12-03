$ErrorActionPreference = "Stop"

# Define search path (current directory)
$searchPath = "."

# Get all .pas files recursively
$files = Get-ChildItem -Path $searchPath -Filter "*.pas" -Recurse

Write-Host "Found $($files.Count) .pas files to check" -ForegroundColor Cyan

# Initialize counters
$fixedCount = 0
$alreadyFixedCount = 0
$errorCount = 0

foreach ($file in $files) {
    try {
        # Read file content
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Check if file uses System.JSON but doesn't use JSONHelpers
        if ($content -match "uses[\s\S]*System\.JSON[\s\S]*;" -and -not ($content -match "uses[\s\S]*JSONHelpers[\s\S]*;")) {
            Write-Host "Fixing file: $($file.FullName)" -ForegroundColor Green
            
            # Replace the uses clause to include JSONHelpers
            $newContent = $content -replace '(uses[\s\S]*)(System\.JSON)([\s\S]*;)', '$1$2, JSONHelpers$3'
            
            # Save the changes
            $newContent | Out-File -FilePath $file.FullName -Encoding UTF8
            
            $fixedCount++
        } elseif ($content -match "uses[\s\S]*JSONHelpers[\s\S]*;") {
            Write-Host "File already correctly configured: $($file.FullName)" -ForegroundColor Gray
            $alreadyFixedCount++
        }
    } catch {
        Write-Host "Error processing file: $($file.FullName)" -ForegroundColor Red
        Write-Host "Error details: $_" -ForegroundColor Red
        $errorCount++
    }
}

# Display summary
Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "Files fixed: $fixedCount" -ForegroundColor Green
Write-Host "Files already correct: $alreadyFixedCount" -ForegroundColor Gray
Write-Host "Files with errors: $errorCount" -ForegroundColor Red

Write-Host "`nPlease recompile your project to verify the issues are resolved." -ForegroundColor Yellow 