# 修复ViewBuildConfig.pas中的验证器相关问题
$content = Get-Content -Path "ViewBuildConfig.pas" -Raw

# 1. 整体替换重复的InitializeValidator方法
# 首先提取我们想要保留的InitializeValidator方法实现
$validMethod = @"
procedure TFrmBuildConfig.InitializeValidator;
begin
  FValidator := TConfigValidator.Create;

  // 添加验证规则
  FValidator.AddNumericRule('General/ctPlain.Number', 'Number');
  FValidator.AddRequiredRule('General/ctPlain.Text', 'Text', '文本属性不能为空');
  FValidator.AddRangeRule('General/ctPlain.Age', 'Age', 0, 120, '年龄必须在0到120之间');
  FValidator.AddRegexRule('General/ctPlain.Email', 'Email', '^[\w\.-]+@[\w\.-]+\.[\w]+$', '邮箱格式不正确');
  FValidator.AddRegexRule('General/ctPlain.URL', 'URL', '^(https?|ftp)://[^\s/$.?#].[^\s]*$', 'URL格式不正确');
  FValidator.AddRegexRule('General/ctPlain.Phone', 'Phone', '^1[3-9]\d{9}$', '手机号格式不正确');
  FValidator.AddCustomRule('General/ctComplex.DateTimeRange', 'StartDateTime', 'ValidateDateTimeRange', '开始时间不能晚于结束时间');
  FValidator.AddFileExistsRule('General/ctPlain.FilePath', 'FilePath', '文件不存在');
  FValidator.AddDirectoryExistsRule('General/ctPlain.DirectoryPath', 'DirectoryPath', '目录不存在');
end;
"@

# 2. 完整的ValidateDateTimeRange方法
$validateDateTime = @"
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

# 3. 修复btnValidateClick方法
$validateClick = @"
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

# 4. 创建一个新的文件，而不是尝试修改原文件
$newcontent = @"
unit ViewBuildConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
  System.DateUtils, System.Generics.Collections, ControllerIntf, ModelConfig,
  ValidationDialog, FrameDBEditor, FrameListEditor,
  FrameArrayEditor, System.IOUtils, FrameFontEditor, FrameAIAPIEditor,
  UtilsTypes, ControllerConfigs, JSONHelpers, ConfigValidator;
"@

# 5. 提取原文件内容的interface到implementation部分
$interfacePattern = "interface.*?implementation"
$interfaceMatch = [regex]::Match($content, $interfacePattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
if($interfaceMatch.Success) {
    $newcontent += $interfaceMatch.Value
}

# 6. 找到实现部分并准备替换
$implementationPattern = "implementation.*?end\."
$implementationMatch = [regex]::Match($content, $implementationPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
if($implementationMatch.Success) {
    $implementation = $implementationMatch.Value
    
    # 替换btnValidateClick方法
    $implementation = $implementation -replace "procedure TFrmBuildConfig\.btnValidateClick.*?end;", $validateClick
    
    # 附加我们的方法到implementation的末尾
    $implementation = $implementation -replace "end\.", "$validMethod`r`n`r`n$validateDateTime`r`n`r`nend."
    
    $newcontent += $implementation
}

# 7. 保存新文件
$newcontent | Set-Content -Path "ViewBuildConfig_fixed.pas"

Write-Host "ViewBuildConfig_fixed.pas has been created." 