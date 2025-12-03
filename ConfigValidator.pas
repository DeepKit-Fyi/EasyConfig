{ IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST OFF}
unit ConfigValidator;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Variants, JSONHelpers, 
  System.RegularExpressions, System.IOUtils, System.Generics.Collections;

type
  // 验证结果记录
  TValidationResult = record
    PropertyPath: string;  // 属性路径，�?Section/Key
    PropertyName: string;  // 属性名�?
    ErrorMessage: string;  // 错误消息
    IsError: Boolean;      // 是否为错误（错误或警告）
    FixSuggestion: string; // 修复建议
  end;

  // 验证规则类型
  TValidationRuleType = (
    vrtRequired,    // 必填项验�?
    vrtNumeric,     // 数值验�?
    vrtRange,       // 范围验证
    vrtLength,      // 长度验证
    vrtRegex,       // 正则表达式验�?
    vrtEmail,       // 电子邮件验证
    vrtURL,         // URL验证
    vrtCustom,      // 自定义验�?
    vrtIPAddress,   // IP地址验证
    vrtDateTime,    // 日期时间验证
    vrtPassword,    // 密码强度验证
    vrtColorCode,   // 颜色代码验证
    vrtUnique,      // 唯一性验�?
    vrtJSON,        // JSON格式验证
    vrtXML          // XML格式验证
  );

  // 自定义验证函数类�?
  TCustomValidation = reference to function(const Value: string): Boolean;

  // 可修复性接�?
  IFixable = interface
    ['{A8B7C6D5-E4F3-42A1-B0C9-D8E7F6A5B4C3}']
    function CanFix: Boolean;
    function GetFixSuggestion: string;
    function AutoFix(const Value: string): string;
  end;

  // 验证规则�?
  TValidationRule = class(TInterfacedObject, IFixable)
  private
    FPropertyPath: string;        // 属性路�?
    FPropertyName: string;        // 属性名�?
    FRuleType: TValidationRuleType; // 规则类型
    FErrorMessage: string;        // 错误消息
    FMinValue: Double;            // 最小值（用于范围验证�?
    FMaxValue: Double;            // 最大值（用于范围验证�?
    FMinLength: Integer;          // 最小长度（用于长度验证�?
    FMaxLength: Integer;          // 最大长度（用于长度验证�?
    FPattern: string;             // 正则表达式模�?
    FCustomValidationFunc: TCustomValidation; // 自定义验证函�?
    FUniqueValues: TList<string>; // 唯一性验证的值列�?
    FFixSuggestion: string;       // 修复建议
    FDateFormat: string;          // 日期格式
  public
    constructor Create(const APropertyPath, APropertyName: string; 
                     ARuleType: TValidationRuleType; const AErrorMessage: string);
    destructor Destroy; override;
    function Validate(const Value: string): Boolean;
    
    // IFixable接口实现
    function CanFix: Boolean;
    function GetFixSuggestion: string;
    function AutoFix(const Value: string): string;
    
    property PropertyPath: string read FPropertyPath write FPropertyPath;
    property PropertyName: string read FPropertyName write FPropertyName;
    property RuleType: TValidationRuleType read FRuleType write FRuleType;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property MinValue: Double read FMinValue write FMinValue;
    property MaxValue: Double read FMaxValue write FMaxValue;
    property MinLength: Integer read FMinLength write FMinLength;
    property MaxLength: Integer read FMaxLength write FMaxLength;
    property Pattern: string read FPattern write FPattern;
    property CustomValidationFunc: TCustomValidation read FCustomValidationFunc write FCustomValidationFunc;
    property UniqueValues: TList<string> read FUniqueValues;
    property FixSuggestion: string read FFixSuggestion write FFixSuggestion;
    property DateFormat: string read FDateFormat write FDateFormat;
  end;

  // 验证器类
  TConfigValidator = class
  private
    FRules: TObjectList<TValidationRule>;
    FResults: TList<TValidationResult>;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 添加验证规则
    function AddRequiredRule(const PropertyPath, PropertyName, ErrorMessage: string): TValidationRule;
    function AddNumericRule(const PropertyPath, PropertyName: string; const ErrorMessage: string = ''): TValidationRule;
    function AddRangeRule(const PropertyPath, PropertyName: string; MinValue, MaxValue: Double; 
                       const ErrorMessage: string = ''): TValidationRule;
    function AddLengthRule(const PropertyPath, PropertyName: string; MinLength, MaxLength: Integer; 
                        const ErrorMessage: string = ''): TValidationRule;
    function AddRegexRule(const PropertyPath, PropertyName, Pattern: string; 
                       const ErrorMessage: string = ''): TValidationRule;
    function AddEmailRule(const PropertyPath, PropertyName: string; 
                       const ErrorMessage: string = ''): TValidationRule;
    function AddURLRule(const PropertyPath, PropertyName: string; 
                      const ErrorMessage: string = ''): TValidationRule;
    function AddCustomRule(const PropertyPath, PropertyName: string; 
                        CustomValidationFunc: TCustomValidation; 
                        const ErrorMessage: string = ''): TValidationRule;
    // 新增验证规则
    function AddIPAddressRule(const PropertyPath, PropertyName: string; 
                          const ErrorMessage: string = ''): TValidationRule;
    function AddDateTimeRule(const PropertyPath, PropertyName, DateFormat: string;
                          const ErrorMessage: string = ''): TValidationRule;
    function AddPasswordRule(const PropertyPath, PropertyName: string; MinLength: Integer = 8;
                          RequireUpperCase: Boolean = True; RequireDigit: Boolean = True;
                          RequireSpecialChar: Boolean = True;
                          const ErrorMessage: string = ''): TValidationRule;
    function AddColorCodeRule(const PropertyPath, PropertyName: string;
                          const ErrorMessage: string = ''): TValidationRule;
    function AddUniqueRule(const PropertyPath, PropertyName: string;
                        const ErrorMessage: string = ''): TValidationRule;
    function AddJSONRule(const PropertyPath, PropertyName: string;
                      const ErrorMessage: string = ''): TValidationRule;
    function AddXMLRule(const PropertyPath, PropertyName: string;
                     const ErrorMessage: string = ''): TValidationRule;
    
    // 验证方法
    function ValidateINI(const Section, Key, Value: string): Boolean;
    function ValidateAll(ConfigManager: TObject): TArray<TValidationResult>;
    function ValidateField(const APath: string; const AValue: Variant): TValidationResult;
    
    // 引用验证
    function ValidateReferences(JSONRoot: TJSONObject): TArray<TValidationResult>;
    
    // 自动修复方法
    function TryAutoFix(const PropertyPath, PropertyName, Value: string; out FixedValue: string): Boolean;
    
    // 清除验证结果
    procedure ClearResults;
    
    // 属�?
    property Rules: TObjectList<TValidationRule> read FRules;
    property Results: TList<TValidationResult> read FResults;
  end;

implementation

{ TValidationRule }

constructor TValidationRule.Create(const APropertyPath, APropertyName: string; 
                                ARuleType: TValidationRuleType; 
                                const AErrorMessage: string);
begin
  inherited Create;
  FPropertyPath := APropertyPath;
  FPropertyName := APropertyName;
  FRuleType := ARuleType;
  FErrorMessage := AErrorMessage;
  FMinValue := 0;
  FMaxValue := 0;
  FMinLength := 0;
  FMaxLength := 0;
  FPattern := '';
  FDateFormat := 'yyyy-mm-dd';
  FFixSuggestion := '';
  
  if ARuleType = vrtUnique then
    FUniqueValues := TList<string>.Create;
end;

destructor TValidationRule.Destroy;
begin
  if Assigned(FUniqueValues) then
    FUniqueValues.Free;
  inherited;
end;

function TValidationRule.Validate(const Value: string): Boolean;
var
  NumValue: Double;
  DtValue: TDateTime;
  IP: string;
  IPParts: TArray<string>;
  I, IPValue: Integer;
  HasUpper, HasDigit, HasSpecial: Boolean;
begin
  Result := True;

  case FRuleType of
    vrtRequired:
      Result := Trim(Value) <> '';
      
    vrtNumeric:
      Result := TryStrToFloat(Value, NumValue);
      
    vrtRange:
      begin
        if TryStrToFloat(Value, NumValue) then
          Result := (NumValue >= FMinValue) and (NumValue <= FMaxValue)
        else
          Result := False;
      end;
      
    vrtLength:
      begin
        Result := (Length(Value) >= FMinLength) and 
                 ((FMaxLength = 0) or (Length(Value) <= FMaxLength));
      end;
      
    vrtRegex:
      begin
        try
          Result := TRegEx.IsMatch(Value, FPattern);
        except
          Result := False;
        end;
      end;
      
    vrtEmail:
      begin
        // 电子邮件验证
        Result := TRegEx.IsMatch(Value, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      end;
      
    vrtURL:
      begin
        // URL验证
        Result := TRegEx.IsMatch(Value, '^(http|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$');
      end;
      
    vrtIPAddress:
      begin
        // IP地址验证
        if not TRegEx.IsMatch(Value, '^(\d{1,3}\.){3}\d{1,3}$') then
        begin
          Result := False;
          Exit;
        end;
        
        IPParts := Value.Split(['.']);
        for IP in IPParts do
        begin
          if not TryStrToInt(IP, IPValue) or (IPValue < 0) or (IPValue > 255) then
          begin
            Result := False;
            Exit;
          end;
        end;
      end;
      
    vrtDateTime:
      begin
        // 日期时间验证
        try
          Result := TryStrToDateTime(Value, DtValue);
          if not Result and (FDateFormat <> '') then
            Result := TryStrToDateTime(Value, DtValue, FormatSettings);
        except
          Result := False;
        end;
      end;
      
    vrtPassword:
      begin
        // 密码强度验证
        Result := Length(Value) >= FMinLength;
        
        // 可选：检查是否包含大写字�?
        HasUpper := False;
        // 可选：检查是否包含数�?
        HasDigit := False;
        // 可选：检查是否包含特殊字�?
        HasSpecial := False;
        
        for I := 1 to Length(Value) do
        begin
          if (Value[I] >= 'A') and (Value[I] <= 'Z') then
            HasUpper := True
          else if (Value[I] >= '0') and (Value[I] <= '9') then
            HasDigit := True
          else if not ((Value[I] >= 'a') and (Value[I] <= 'z')) then
            HasSpecial := True;
        end;
        
        if (FPattern <> '') then
        begin
          // 密码模式包含自定义规�?
          if FPattern.Contains('upper') and not HasUpper then
            Result := False
          else if FPattern.Contains('digit') and not HasDigit then
            Result := False
          else if FPattern.Contains('special') and not HasSpecial then
            Result := False;
        end;
      end;
      
    vrtColorCode:
      begin
        // 颜色代码验证 (#RRGGBB �?#RGB)
        Result := TRegEx.IsMatch(Value, '^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
      end;
      
    vrtUnique:
      begin
        // 唯一性验�?
        Result := not Assigned(FUniqueValues) or not FUniqueValues.Contains(Value);
        if Result and Assigned(FUniqueValues) then
          FUniqueValues.Add(Value);
      end;
      
    vrtJSON:
      begin
        // JSON格式验证
        try
          TJSONObject.ParseJSONValue(Value);
          Result := True;
        except
          Result := False;
        end;
      end;
      
    vrtXML:
      begin
        // XML格式验证 - 简单实�?
        Result := Value.Trim.StartsWith('<?xml') or 
                 (Value.Trim.StartsWith('<') and Value.Trim.EndsWith('>'));
      end;
      
    vrtCustom:
      begin
        if Assigned(FCustomValidationFunc) then
          Result := FCustomValidationFunc(Value)
        else
          Result := True;
      end;
  end;
end;

function TValidationRule.CanFix: Boolean;
begin
  // 判断规则是否可以自动修复
  case FRuleType of
    vrtRequired: Result := False; // 必填项不能自动修�?
    vrtNumeric: Result := True;   // 数字可以尝试修复
    vrtRange: Result := True;     // 范围可以尝试修复
    vrtLength: Result := True;    // 长度可以尝试修复
    vrtRegex: Result := False;    // 正则表达式通常难以自动修复
    vrtEmail: Result := False;    // 邮箱难以自动修复
    vrtURL: Result := True;       // URL可以尝试修复
    vrtIPAddress: Result := True; // IP地址可以尝试修复
    vrtDateTime: Result := True;  // 日期时间可以尝试修复
    vrtPassword: Result := False; // 密码不应自动修复
    vrtColorCode: Result := True; // 颜色代码可以修复
    vrtUnique: Result := False;   // 唯一性不能自动修�?
    vrtJSON: Result := False;     // JSON格式难以自动修复
    vrtXML: Result := False;      // XML格式难以自动修复
    vrtCustom: Result := False;   // 自定义验证不能自动修�?
  else
    Result := False;
  end;
end;

function TValidationRule.GetFixSuggestion: string;
begin
  if FFixSuggestion <> '' then
    Result := FFixSuggestion
  else
  begin
    // 为不同的规则类型提供默认修复建议
    case FRuleType of
      vrtRequired: 
        Result := '请输入必填项';
      vrtNumeric: 
        Result := '请输入有效的数字';
      vrtRange: 
        Result := Format('请输入介于 %f 到 %f 之间的值', [FMinValue, FMaxValue]);
      vrtLength: 
        begin
          if FMaxLength > 0 then
            Result := Format('长度必须介于 %d 到 %d 之间', [FMinLength, FMaxLength])
          else
            Result := Format('长度至少需要 %d 个字符', [FMinLength]);
        end;
      vrtRegex: 
        Result := '请输入符合格式要求的值';
      vrtEmail: 
        Result := '请输入有效的电子邮件地址，例如 example@domain.com';
      vrtURL: 
        Result := '请输入有效的URL，例如 https://www.example.com';
      vrtIPAddress: 
        Result := '请输入有效的IP地址，例如 192.168.1.1';
      vrtDateTime: 
        Result := Format('请输入有效的日期时间格式: %s', [FDateFormat]);
      vrtPassword: 
        begin
          Result := Format('密码至少需要 %d 个字符', [FMinLength]);
          if FPattern.Contains('upper') then
            Result := Result + '，包含至少一个大写字母';
          if FPattern.Contains('digit') then
            Result := Result + '，包含至少一个数字';
          if FPattern.Contains('special') then
            Result := Result + '，包含至少一个特殊字符';
        end;
      vrtColorCode: 
        Result := '请输入有效的颜色代码，例如 #FF0000 (红色)';
      vrtUnique: 
        Result := '请输入唯一的值，该值已被使用';
      vrtJSON: 
        Result := '请输入有效的JSON格式';
      vrtXML: 
        Result := '请输入有效的XML格式';
      vrtCustom: 
        Result := '请根据自定义规则修正此值';
    else
      Result := '请修正此值';
    end;
  end;
end;

function TValidationRule.AutoFix(const Value: string): string;
var
  NumValue: Double;
  I: Integer;
  Fixed: string;
  ColorLen: Integer;
begin
  Result := Value; // 默认返回原值
  
  if not CanFix then
    Exit;
    
  case FRuleType of
    vrtNumeric:
      begin
        // 尝试修复数字：去除非数字字符
        Fixed := '';
        for I := 1 to Length(Value) do
        begin
          if CharInSet(Value[I], ['0'..'9', '.', '-']) then
            Fixed := Fixed + Value[I];
        end;
        
        if TryStrToFloat(Fixed, NumValue) then
          Result := Fixed;
      end;
      
    vrtRange:
      begin
        // 尝试修复范围：将值限制在范围内
        if TryStrToFloat(Value, NumValue) then
        begin
          if NumValue < FMinValue then
            Result := FloatToStr(FMinValue)
          else if NumValue > FMaxValue then
            Result := FloatToStr(FMaxValue);
        end;
      end;
      
    vrtLength:
      begin
        // 尝试修复长度：截断过长的值，或填充过短的值
        if Length(Value) < FMinLength then
          Result := Value.PadRight(FMinLength, ' ')
        else if (FMaxLength > 0) and (Length(Value) > FMaxLength) then
          Result := Copy(Value, 1, FMaxLength);
      end;
      
    vrtURL:
      begin
        // 尝试修复URL：添加协议前缀
        if not Value.StartsWith('http://') and not Value.StartsWith('https://') then
          Result := 'https://' + Value;
      end;
      
    vrtIPAddress:
      begin
        // 尝试修复IP地址：对无效部分使用默认值
        if not TRegEx.IsMatch(Value, '^(\d{1,3}\.){3}\d{1,3}$') then
          Result := '127.0.0.1'
        else
        begin
          var IPParts := Value.Split(['.']);
          var ValidIP := '';
          
          for I := 0 to Length(IPParts) - 1 do
          begin
            var IPValue: Integer;
            if TryStrToInt(IPParts[I], IPValue) then
            begin
              if IPValue < 0 then IPValue := 0;
              if IPValue > 255 then IPValue := 255;
              
              if I > 0 then ValidIP := ValidIP + '.';
              ValidIP := ValidIP + IntToStr(IPValue);
            end
            else
            begin
              if I > 0 then ValidIP := ValidIP + '.';
              ValidIP := ValidIP + '0';
            end;
          end;
          
          Result := ValidIP;
        end;
      end;
      
    vrtDateTime:
      begin
        // 尝试修复日期时间：使用当前日期时间
        Result := FormatDateTime(FDateFormat, Now);
      end;
      
    vrtColorCode:
      begin
        // 尝试修复颜色代码
        if not Value.StartsWith('#') then
          Fixed := '#' + Value
        else
          Fixed := Value;
          
        // 检查是否是有效的颜色代码格式
        if TRegEx.IsMatch(Fixed, '^#[A-Fa-f0-9]{3}$') then
        begin
          // 3位转6位
          Result := '#' + Fixed[2] + Fixed[2] + Fixed[3] + Fixed[3] + Fixed[4] + Fixed[4];
        end
        else if not TRegEx.IsMatch(Fixed, '^#[A-Fa-f0-9]{6}$') then
        begin
          // 无效的颜色代码，使用默认黑色
          Result := '#000000';
        end
        else
          Result := Fixed;
      end;
  else
    // 其他类型不提供自动修复
    Result := Value;
  end;
end;

{ TConfigValidator }

constructor TConfigValidator.Create;
begin
  inherited Create;
  FRules := TObjectList<TValidationRule>.Create(True); // 自动释放对象
  FResults := TList<TValidationResult>.Create;
end;

destructor TConfigValidator.Destroy;
begin
  FRules.Free;
  FResults.Free;
  inherited;
end;

function TConfigValidator.AddRequiredRule(const PropertyPath, PropertyName, ErrorMessage: string): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 不能为空';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtRequired, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddNumericRule(const PropertyPath, PropertyName: string; 
                                     const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的数字';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtNumeric, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddRangeRule(const PropertyPath, PropertyName: string; 
                                    MinValue, MaxValue: Double; 
                                    const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := Format('字段 "%s" 的值必须在 %f �?%f 之间', 
                               [PropertyName, MinValue, MaxValue]);
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtRange, ActualErrorMessage);
  Rule.MinValue := MinValue;
  Rule.MaxValue := MaxValue;
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddLengthRule(const PropertyPath, PropertyName: string; 
                                     MinLength, MaxLength: Integer; 
                                     const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
  begin
    if MaxLength > 0 then
      ActualErrorMessage := Format('字段 "%s" 的长度必须在 %d �?%d 之间', 
                                 [PropertyName, MinLength, MaxLength])
    else
      ActualErrorMessage := Format('字段 "%s" 的长度必须至少为 %d', 
                                 [PropertyName, MinLength]);
  end;
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtLength, ActualErrorMessage);
  Rule.MinLength := MinLength;
  Rule.MaxLength := MaxLength;
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddRegexRule(const PropertyPath, PropertyName, Pattern: string; 
                                    const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 不符合指定的格式';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtRegex, ActualErrorMessage);
  Rule.Pattern := Pattern;
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddEmailRule(const PropertyPath, PropertyName: string; 
                                    const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的电子邮件地址';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtEmail, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddURLRule(const PropertyPath, PropertyName: string; 
                                  const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的URL';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtURL, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddCustomRule(const PropertyPath, PropertyName: string; 
                                      CustomValidationFunc: TCustomValidation; 
                                      const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 验证失败';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtCustom, ActualErrorMessage);
  Rule.CustomValidationFunc := CustomValidationFunc;
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddIPAddressRule(const PropertyPath, PropertyName: string; 
                                        const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的IP地址';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtIPAddress, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddDateTimeRule(const PropertyPath, PropertyName, DateFormat: string; 
                                        const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage, FormatDisplay: string;
begin
  FormatDisplay := DateFormat;
  if FormatDisplay = '' then FormatDisplay := 'yyyy-mm-dd';
  
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := Format('字段 "%s" 必须是有效的日期，格式为: %s', 
                               [PropertyName, FormatDisplay]);
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtDateTime, ActualErrorMessage);
  Rule.DateFormat := DateFormat;
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddPasswordRule(const PropertyPath, PropertyName: string; MinLength: Integer = 8;
                                        RequireUpperCase: Boolean = True; RequireDigit: Boolean = True;
                                        RequireSpecialChar: Boolean = True;
                                        const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage, Pattern: string;
begin
  Pattern := '';
  if RequireUpperCase then Pattern := Pattern + 'upper';
  if RequireDigit then Pattern := Pattern + 'digit';
  if RequireSpecialChar then Pattern := Pattern + 'special';
  
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
  begin
    ActualErrorMessage := Format('密码必须至少包含 %d 个字符', [MinLength]);
    if RequireUpperCase then ActualErrorMessage := ActualErrorMessage + '，至少一个大写字母';
    if RequireDigit then ActualErrorMessage := ActualErrorMessage + '，至少一个数字';
    if RequireSpecialChar then ActualErrorMessage := ActualErrorMessage + '，至少一个特殊字符';
  end;
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtPassword, ActualErrorMessage);
  Rule.MinLength := MinLength;
  Rule.Pattern := Pattern; // 使用Pattern字段存储密码要求
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddColorCodeRule(const PropertyPath, PropertyName: string; 
                                        const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的颜色代码 (例如: #FF0000)';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtColorCode, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddUniqueRule(const PropertyPath, PropertyName: string; 
                                      const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是唯一值';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtUnique, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddJSONRule(const PropertyPath, PropertyName: string; 
                                    const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的JSON格式';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtJSON, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.AddXMLRule(const PropertyPath, PropertyName: string; 
                                  const ErrorMessage: string = ''): TValidationRule;
var
  Rule: TValidationRule;
  ActualErrorMessage: string;
begin
  ActualErrorMessage := ErrorMessage;
  if ActualErrorMessage = '' then
    ActualErrorMessage := '字段 "' + PropertyName + '" 必须是有效的XML格式';
    
  Rule := TValidationRule.Create(PropertyPath, PropertyName, vrtXML, ActualErrorMessage);
  FRules.Add(Rule);
  Result := Rule;
end;

function TConfigValidator.ValidateINI(const Section, Key, Value: string): Boolean;
var
  PropertyPath: string;
  Rule: TValidationRule;
  ValidationResult: TValidationResult;
  I: Integer;
begin
  Result := True;
  PropertyPath := Section + '/' + Key;
  
  for I := 0 to FRules.Count - 1 do
  begin
    Rule := FRules[I];
    
    // 检查属性路径是否匹配
    if (Rule.PropertyPath = PropertyPath) or 
       (Rule.PropertyName = Key) then
    begin
      // 执行验证
      if not Rule.Validate(Value) then
      begin
        // 创建验证结果并添加到结果列表
        ValidationResult.PropertyPath := PropertyPath;
        ValidationResult.PropertyName := Key;
        ValidationResult.ErrorMessage := Rule.ErrorMessage;
        ValidationResult.IsError := True;
        ValidationResult.FixSuggestion := Rule.GetFixSuggestion;
        
        FResults.Add(ValidationResult);
        Result := False;
      end;
    end;
  end;
end;

procedure TConfigValidator.ClearResults;
begin
  FResults.Clear;
end;

function TConfigValidator.TryAutoFix(const PropertyPath, PropertyName, Value: string; out FixedValue: string): Boolean;
var
  Rule: TValidationRule;
  I: Integer;
begin
  Result := False;
  FixedValue := Value;
  
  for I := 0 to FRules.Count - 1 do
  begin
    Rule := FRules[I];
    
    // 检查属性路径是否匹配
    if (Rule.PropertyPath = PropertyPath) or 
       (Rule.PropertyName = PropertyName) then
    begin
      // 检查是否可以自动修复（直接调用方法，避免接口转换问题）
      if Rule.CanFix then
      begin
        FixedValue := Rule.AutoFix(Value);
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TConfigValidator.ValidateAll(ConfigManager: TObject): TArray<TValidationResult>;
var
  ResultList: TList<TValidationResult>;
begin
  ResultList := TList<TValidationResult>.Create;
  try
    // 清除之前的结果
    ClearResults;
    
    // 注意：这里需要根据实际的 ConfigManager 类型进行验证
    // 由于循环引用问题，这里只返回当前累积的结果
    
    Result := FResults.ToArray;
  finally
    ResultList.Free;
  end;
end;

function TConfigValidator.ValidateField(const APath: string; const AValue: Variant): TValidationResult;
var
  Rule: TValidationRule;
  I: Integer;
  ValueStr: string;
begin
  Result.PropertyPath := APath;
  Result.PropertyName := ExtractFileName(APath);
  Result.ErrorMessage := '';
  Result.IsError := False;
  Result.FixSuggestion := '';
  
  ValueStr := VarToStr(AValue);
  
  for I := 0 to FRules.Count - 1 do
  begin
    Rule := FRules[I];
    
    if (Rule.PropertyPath = APath) or (Rule.PropertyName = Result.PropertyName) then
    begin
      if not Rule.Validate(ValueStr) then
      begin
        Result.ErrorMessage := Rule.ErrorMessage;
        Result.IsError := True;
        Result.FixSuggestion := Rule.GetFixSuggestion;
        Exit;
      end;
    end;
  end;
end;

function TConfigValidator.ValidateReferences(JSONRoot: TJSONObject): TArray<TValidationResult>;
var
  ResultList: TList<TValidationResult>;
  AllIds: TDictionary<string, Boolean>;
  
  procedure CollectIds(Obj: TJSONObject; const Path: string);
  var
    Pair: TJSONPair;
    IdValue: string;
    I: Integer;
    Arr: TJSONArray;
  begin
    if Obj = nil then Exit;
    
    // 收集 _id
    if Obj.TryGetValue<string>('_id', IdValue) then
      AllIds.AddOrSetValue(IdValue, True);
    
    // 递归处理子对象
    for Pair in Obj do
    begin
      if Pair.JsonValue is TJSONObject then
        CollectIds(TJSONObject(Pair.JsonValue), Path + '/' + Pair.JsonString.Value)
      else if Pair.JsonValue is TJSONArray then
      begin
        Arr := TJSONArray(Pair.JsonValue);
        for I := 0 to Arr.Count - 1 do
        begin
          if Arr.Items[I] is TJSONObject then
            CollectIds(TJSONObject(Arr.Items[I]), Path + '/' + Pair.JsonString.Value + '[' + IntToStr(I) + ']');
        end;
      end;
    end;
  end;
  
  procedure ValidateRefs(Obj: TJSONObject; const Path: string);
  var
    Pair: TJSONPair;
    RefValue: string;
    I: Integer;
    Arr: TJSONArray;
    ValidationResult: TValidationResult;
  begin
    if Obj = nil then Exit;
    
    // 检查 _ref
    if Obj.TryGetValue<string>('_ref', RefValue) then
    begin
      if not AllIds.ContainsKey(RefValue) then
      begin
        ValidationResult.PropertyPath := Path + '/_ref';
        ValidationResult.PropertyName := '_ref';
        ValidationResult.ErrorMessage := Format('引用 "%s" 指向不存在的 _id', [RefValue]);
        ValidationResult.IsError := True;
        ValidationResult.FixSuggestion := '请确保引用的 _id 存在于配置中';
        ResultList.Add(ValidationResult);
      end;
    end;
    
    // 递归处理子对象
    for Pair in Obj do
    begin
      if Pair.JsonValue is TJSONObject then
        ValidateRefs(TJSONObject(Pair.JsonValue), Path + '/' + Pair.JsonString.Value)
      else if Pair.JsonValue is TJSONArray then
      begin
        Arr := TJSONArray(Pair.JsonValue);
        for I := 0 to Arr.Count - 1 do
        begin
          if Arr.Items[I] is TJSONObject then
            ValidateRefs(TJSONObject(Arr.Items[I]), Path + '/' + Pair.JsonString.Value + '[' + IntToStr(I) + ']');
        end;
      end;
    end;
  end;
  
begin
  ResultList := TList<TValidationResult>.Create;
  AllIds := TDictionary<string, Boolean>.Create;
  try
    // 第一遍：收集所有 _id
    CollectIds(JSONRoot, '');
    
    // 第二遍：验证所有 _ref
    ValidateRefs(JSONRoot, '');
    
    Result := ResultList.ToArray;
  finally
    AllIds.Free;
    ResultList.Free;
  end;
end;

end.


