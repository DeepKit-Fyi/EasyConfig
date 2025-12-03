# Script: Add JSONHelpers to Delphi units using System.JSON
# Sets error handling to stop on errors
$ErrorActionPreference = "Stop"

# Set search path to current directory
$searchPath = "."

Write-Host "Starting fix script..."

try {
    # Get all .pas files
    $files = Get-ChildItem -Path $searchPath -Filter "*.pas" -Recurse -File

    Write-Host "Found $($files.Count) .pas files"

    $fixedCount = 0
    $alreadyFixedCount = 0
    $errorCount = 0

    foreach ($file in $files) {
        try {
            Write-Host "Processing file: $($file.FullName)"
            
            # Read file content using UTF8 encoding
            $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
            
            # Check if file contains System.JSON but not JSONHelpers
            if ($content.Contains("System.JSON") -and -not $content.Contains("JSONHelpers")) {
                # Find uses section
                $index = $content.IndexOf("uses")
                if ($index -ge 0) {
                    # Find semicolon after uses
                    $endIndex = $content.IndexOf(";", $index)
                    if ($endIndex -ge 0) {
                        # Extract uses section
                        $usesPart = $content.Substring($index, $endIndex - $index + 1)
                        
                        # Add JSONHelpers after System.JSON
                        $newUsesPart = $usesPart.Replace("System.JSON", "System.JSON, JSONHelpers")
                        
                        # Avoid duplicate adds
                        if ($newUsesPart -ne $usesPart) {
                            # Replace in content
                            $content = $content.Replace($usesPart, $newUsesPart)
                            
                            # Write back to file
                            [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
                            
                            Write-Host "  - Fixed file by adding JSONHelpers unit" -ForegroundColor Green
                            $fixedCount++
                        } else {
                            Write-Host "  - File already correctly configured" -ForegroundColor Cyan
                            $alreadyFixedCount++
                        }
                    } else {
                        Write-Host "  - Could not find semicolon after uses section" -ForegroundColor Yellow
                        $errorCount++
                    }
                } else {
                    Write-Host "  - Could not find uses section" -ForegroundColor Yellow
                    $errorCount++
                }
            } else {
                if ($content.Contains("System.JSON") -and $content.Contains("JSONHelpers")) {
                    Write-Host "  - File already correctly configured" -ForegroundColor Cyan
                    $alreadyFixedCount++
                } else {
                    Write-Host "  - File does not need fixing" -ForegroundColor Gray
                }
            }
        } catch {
            Write-Host "  - Error processing file: $_" -ForegroundColor Red
            $errorCount++
        }
    }

    Write-Host ""
    Write-Host "Processing complete:"
    Write-Host "  - Fixed files: $fixedCount" -ForegroundColor Green
    Write-Host "  - Already configured files: $alreadyFixedCount" -ForegroundColor Cyan
    Write-Host "  - Files needing manual check: $errorCount" -ForegroundColor Yellow

    Write-Host ""
    Write-Host "Please recompile your project to verify the AddPair errors are resolved." -ForegroundColor Magenta
}
catch {
    Write-Host "Script error: $_" -ForegroundColor Red
} 