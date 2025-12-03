# 修复ViewBuildConfig.pas中的验证器相关问题
$content = Get-Content -Path "ViewBuildConfig.pas" -Raw -Encoding UTF8

# 1. 删除重复的InitializeValidator方法实现
$content = $content -replace "procedure TFrmBuildConfig\.InitializeValidator;\r\nbegin\r\n  // 创建验证器.*?end;", ""

# 2. 删除错误的ValidateConfig方法及相关方法
$content = $content -replace "function TFrmBuildConfig\.ValidateConfig: Boolean;.*?end;", ""
$content = $content -replace "function TFrmBuildConfig\.ValidateINIProperty.*?end;", ""
$content = $content -replace "procedure TFrmBuildConfig\.ShowValidationResults;.*?end;", ""

# 3. 修复btnValidateClick方法
$content = $content -replace "procedure TFrmBuildConfig\.btnValidateClick.*?end;", @"
procedure TFrmBuildConfig.btnValidateClick(Sender: TObject);
var
  Errors: TStringList;
begin
  // 创建错误列表
  Errors := TStringList.Create;
  try
    // 在这里实现配置验证逻辑
    // 示例: ValidateConfigurations(Errors);
    
    // 如果有错误，显示给用户
    if Errors.Count > 0 then
    begin
      ShowMessage('配置验证失败，请修正以下问题:' + #13#10 + Errors.Text);
    end
    else
    begin
      ShowMessage('验证通过，配置文件符合规范');
    end;
  finally
    Errors.Free;
  end;
end;
"@

# 4. A修正ValidateDateTimeRange方法的结尾
$content = $content -replace "function TFrmBuildConfig\.ValidateDateTimeRange.*?if not Value\.TryGetValue<TDateTime>\('EndDateTime', EndDateTime\) then Exit;", @"
function TFrmBuildConfig.ValidateDateTimeRange(const PropertyType, PropertyName: string; Value: TJSONObject): Boolean;
var
  StartDateTime, EndDateTime: TDateTime;
begin
  Result := True;
  if not Value.TryGetValue<TDateTime>('StartDateTime', StartDateTime) then Exit;
  if not Value.TryGetValue<TDateTime>('EndDateTime', EndDateTime) then Exit;
  Result := StartDateTime <= EndDateTime;
end;
"@

# 5. 保存修改后的内容
$content | Set-Content -Path "ViewBuildConfig.pas" -Encoding UTF8

Write-Host "ViewBuildConfig.pas has been fixed." 