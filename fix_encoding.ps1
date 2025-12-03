# Simpler approach to fix encoding issues in FrameObjectEditor.pas
$ErrorActionPreference = "Stop"

# Target file with encoding problems
$targetFile = "FrameObjectEditor.pas"

Write-Host "Starting to fix encoding in $targetFile..."

try {
    # Create backup
    Copy-Item -Path $targetFile -Destination "$targetFile.bak" -Force
    Write-Host "Created backup at $targetFile.bak"
    
    # Read file content as string
    $content = Get-Content -Path $targetFile -Raw -Encoding Default
    
    # Fix specific string patterns - using fixed English replacements
    $content = $content -replace 'cmbPropertyType\.Items\.Add\(瀛楃涓\?\);', 'cmbPropertyType.Items.Add("String");'
    $content = $content -replace 'cmbPropertyType\.Items\.Add\(鏁板瓧\);', 'cmbPropertyType.Items.Add("Number");'
    $content = $content -replace 'cmbPropertyType\.Items\.Add\(甯冨皵鍊\?\);', 'cmbPropertyType.Items.Add("Boolean");'
    $content = $content -replace 'cmbPropertyType\.Items\.Add\(瀵硅薄\);', 'cmbPropertyType.Items.Add("Object");'
    $content = $content -replace 'cmbPropertyType\.Items\.Add\(鏁扮粍\);', 'cmbPropertyType.Items.Add("Array");'
    
    # Fix button captions
    $content = $content -replace 'btnAdd\.Caption := ''娣诲姞灞炴€\?'';', 'btnAdd.Caption := ''Add Property'';'
    $content = $content -replace 'btnEdit\.Caption := ''缂栬緫灞炴€\?'';', 'btnEdit.Caption := ''Edit Property'';'
    $content = $content -replace 'btnDelete\.Caption := ''鍒犻櫎灞炴€\?'';', 'btnDelete.Caption := ''Delete Property'';'
    
    # Fix grid cells
    $content = $content -replace 'sgProperties\.Cells\[0, 0\] := ''灞炴€у悕'';', 'sgProperties.Cells[0, 0] := ''Property Name'';'
    $content = $content -replace 'sgProperties\.Cells\[1, 0\] := ''绫诲瀷'';', 'sgProperties.Cells[1, 0] := ''Type'';'
    $content = $content -replace 'sgProperties\.Cells\[2, 0\] := ''鍊\?'';', 'sgProperties.Cells[2, 0] := ''Value'';'
    
    # Fix GetPropertyTypeAsString
    $content = $content -replace 'ptString: Result := ''瀛楃涓\?'';', 'ptString: Result := ''String'';'
    $content = $content -replace 'ptNumber: Result := ''鏁板瓧'';', 'ptNumber: Result := ''Number'';'
    $content = $content -replace 'ptBoolean: Result := ''甯冨皵鍊\?'';', 'ptBoolean: Result := ''Boolean'';'
    $content = $content -replace 'ptObject: Result := ''瀵硅薄'';', 'ptObject: Result := ''Object'';'
    $content = $content -replace 'ptArray: Result := ''鏁扮粍'';', 'ptArray: Result := ''Array'';'
    $content = $content -replace 'else Result := ''瀛楃涓\?'';', 'else Result := ''String'';'
    
    # Fix GetPropertyTypeFromString
    $content = $content -replace 'if TypeStr = ''鏁板瓧''', 'if TypeStr = ''Number'''
    $content = $content -replace 'else if TypeStr = ''甯冨皵鍊\?''', 'else if TypeStr = ''Boolean'''
    $content = $content -replace 'else if TypeStr = ''瀵硅薄''', 'else if TypeStr = ''Object'''
    $content = $content -replace 'else if TypeStr = ''鏁扮粍''', 'else if TypeStr = ''Array'''
    
    # Fix dialog strings in btnAddClick
    $content = $content -replace 'InputQuery\(''娣诲姞灞炴€\?'', ''璇疯緭鍏ュ睘鎬у悕:'', PropertyName\)', 'InputQuery(''Add Property'', ''Enter property name:'', PropertyName)'
    $content = $content -replace 'MessageDlg\(''灞炴€у悕 "'' \+ PropertyName \+ ''" 宸插瓨鍦\?'', mtWarning, \[mbOK\], 0\)', 'MessageDlg(''Property name "'' + PropertyName + ''" already exists'', mtWarning, [mbOK], 0)'
    $content = $content -replace 'InputQuery\(''娣诲姞瀛楃涓插睘鎬\?'', ''璇疯緭鍏ュ瓧绗︿覆鍊\?'', PropertyValue\)', 'InputQuery(''Add String Property'', ''Enter string value:'', PropertyValue)'
    $content = $content -replace 'InputQuery\(''娣诲姞鏁板瓧灞炴€\?'', ''璇疯緭鍏ユ暟瀛楀€\?'', PropertyValue\)', 'InputQuery(''Add Number Property'', ''Enter numeric value:'', PropertyValue)'
    $content = $content -replace 'MessageDlg\(''鏃犳晥鐨勬暟瀛楀€\?'', mtError, \[mbOK\], 0\)', 'MessageDlg(''Invalid numeric value'', mtError, [mbOK], 0)'
    $content = $content -replace 'MessageDlg\(''閫夋嫨甯冨皵鍊\?'', mtConfirmation, \[mbYes, mbNo\], 0\)', 'MessageDlg(''Choose Boolean value'', mtConfirmation, [mbYes, mbNo], 0)'
    
    # Fix dialog strings in btnEditClick
    $content = $content -replace 'InputQuery\(''缂栬緫灞炴€\?'', ''璇风紪杈戝睘鎬у悕:'', PropertyName\)', 'InputQuery(''Edit Property'', ''Edit property name:'', PropertyName)'
    $content = $content -replace 'InputQuery\(''缂栬緫瀛楃涓插睘鎬\?'', ''璇风紪杈戝瓧绗︿覆鍊\?'', PropertyValue\)', 'InputQuery(''Edit String Property'', ''Edit string value:'', PropertyValue)'

    # Save the fixed content
    Set-Content -Path $targetFile -Value $content -Encoding UTF8
    
    Write-Host "Fixed encoding issues in $targetFile"
}
catch {
    Write-Host "Error processing file: $_" -ForegroundColor Red
}
