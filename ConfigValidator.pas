unit ConfigValidator;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  UtilsTypes;

type
  TValidationSeverity = (vsInfo, vsWarning, vsError);
  
  TValidationResult = record
    PropertyPath: string;
    PropertyName: string;
    Message: string;
    Severity: TValidationSeverity;
  end;
  
  TValidationRule = class
  private
    FPropertyPath: string;
    FPropertyName: string;
    FMessage: string;
    FSeverity: TValidationSeverity;
  public
    constructor Create(const APropertyPath, APropertyName, AMessage: string; ASeverity: TValidationSeverity = vsError);
    function Validate(const Value: string): Boolean; virtual; abstract;
    
    property PropertyPath: string read FPropertyPath write FPropertyPath;
    property PropertyName: string read FPropertyName write FPropertyName;
    property Message: string read FMessage write FMessage;
    property Severity: TValidationSeverity read FSeverity write FSeverity;
  end;
  
  TRequiredRule = class(TValidationRule)
  public
    function Validate(const Value: string): Boolean; override;
  end;
  
  TNumericRule = class(TValidationRule)
  public
    function Validate(const Value: string): Boolean; override;
  end;
  
  TRangeRule = class(TValidationRule)
  private
    FMinValue: Double;
    FMaxValue: Double;
  public
    constructor Create(const APropertyPath, APropertyName, AMessage: string; 
                      AMinValue, AMaxValue: Double; ASeverity: TValidationSeverity = vsError);
    function Validate(const Value: string): Boolean; override;
    
    property MinValue: Double read FMinValue write FMinValue;
    property MaxValue: Double read FMaxValue write FMaxValue;
  end;
  
  TRegexRule = class(TValidationRule)
  private
    FPattern: string;
  public
    constructor Create(const APropertyPath, APropertyName, AMessage, APattern: string; 
                      ASeverity: TValidationSeverity = vsError);
    function Validate(const Value: string): Boolean; override;
    
    property Pattern: string read FPattern write FPattern;
  end;
  
  TCustomRule = class(TValidationRule)
  private
    FValidateFunc: TFunc<string, Boolean>;
  public
    constructor Create(const APropertyPath, APropertyName, AMessage: string; 
                      AValidateFunc: TFunc<string, Boolean>; ASeverity: TValidationSeverity = vsError);
    function Validate(const Value: string): Boolean; override;
    
    property ValidateFunc: TFunc<string, Boolean> read FValidateFunc write FValidateFunc;
  end;
  
  TConfigValidator = class
  private
    FRules: TObjectList<TValidationRule>;
    FResults: TList<TValidationResult>;
    
    procedure ClearResults;
    procedure AddResult(const PropertyPath, PropertyName, Message: string; Severity: TValidationSeverity);
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure AddRule(Rule: TValidationRule);
    procedure AddRequiredRule(const PropertyPath, PropertyName: string; const Message: string = '');
    procedure AddNumericRule(const PropertyPath, PropertyName: string; const Message: string = '');
    procedure AddRangeRule(const PropertyPath, PropertyName: string; MinValue, MaxValue: Double; const Message: string = '');
    procedure AddRegexRule(const PropertyPath, PropertyName, Pattern: string; const Message: string = '');
    procedure AddCustomRule(const PropertyPath, PropertyName: string; ValidateFunc: TFunc<string, Boolean>; const Message: string = '');
    
    function Validate(const ConfigData: TJSONObject): Boolean;
    function ValidateINI(const Section, Key, Value: string): Boolean;
    
    property Results: TList<TValidationResult> read FResults;
  end;

implementation

uses
  System.RegularExpressions;

{ TValidationRule }

constructor TValidationRule.Create(const APropertyPath, APropertyName, AMessage: string; ASeverity: TValidationSeverity);
begin
  FPropertyPath := APropertyPath;
  FPropertyName := APropertyName;
  FMessage := AMessage;
  FSeverity := ASeverity;
end;

{ TRequiredRule }

function TRequiredRule.Validate(const Value: string): Boolean;
begin
  Result := Value <> '';
end;

{ TNumericRule }

function TNumericRule.Validate(const Value: string): Boolean;
var
  FloatValue: Double;
begin
  Result := TryStrToFloat(Value, FloatValue);
end;

{ TRangeRule }

constructor TRangeRule.Create(const APropertyPath, APropertyName, AMessage: string; 
                             AMinValue, AMaxValue: Double; ASeverity: TValidationSeverity);
begin
  inherited Create(APropertyPath, APropertyName, AMessage, ASeverity);
  FMinValue := AMinValue;
  FMaxValue := AMaxValue;
end;

function TRangeRule.Validate(const Value: string): Boolean;
var
  FloatValue: Double;
begin
  Result := False;
  
  if TryStrToFloat(Value, FloatValue) then
    Result := (FloatValue >= FMinValue) and (FloatValue <= FMaxValue);
end;

{ TRegexRule }

constructor TRegexRule.Create(const APropertyPath, APropertyName, AMessage, APattern: string; 
                             ASeverity: TValidationSeverity);
begin
  inherited Create(APropertyPath, APropertyName, AMessage, ASeverity);
  FPattern := APattern;
end;

function TRegexRule.Validate(const Value: string): Boolean;
begin
  Result := TRegEx.IsMatch(Value, FPattern);
end;

{ TCustomRule }

constructor TCustomRule.Create(const APropertyPath, APropertyName, AMessage: string; 
                              AValidateFunc: TFunc<string, Boolean>; ASeverity: TValidationSeverity);
begin
  inherited Create(APropertyPath, APropertyName, AMessage, ASeverity);
  FValidateFunc := AValidateFunc;
end;

function TCustomRule.Validate(const Value: string): Boolean;
begin
  if Assigned(FValidateFunc) then
    Result := FValidateFunc(Value)
  else
    Result := True;
end;

{ TConfigValidator }

constructor TConfigValidator.Create;
begin
  FRules := TObjectList<TValidationRule>.Create(True);
  FResults := TList<TValidationResult>.Create;
end;

destructor TConfigValidator.Destroy;
begin
  FRules.Free;
  FResults.Free;
  inherited;
end;

procedure TConfigValidator.AddRule(Rule: TValidationRule);
begin
  FRules.Add(Rule);
end;

procedure TConfigValidator.AddRequiredRule(const PropertyPath, PropertyName, Message: string);
var
  Rule: TRequiredRule;
  Msg: string;
begin
  if Message = '' then
    Msg := Format('属性 %s 不能为空', [PropertyName])
  else
    Msg := Message;
    
  Rule := TRequiredRule.Create(PropertyPath, PropertyName, Msg);
  AddRule(Rule);
end;

procedure TConfigValidator.AddNumericRule(const PropertyPath, PropertyName, Message: string);
var
  Rule: TNumericRule;
  Msg: string;
begin
  if Message = '' then
    Msg := Format('属性 %s 必须是有效的数字', [PropertyName])
  else
    Msg := Message;
    
  Rule := TNumericRule.Create(PropertyPath, PropertyName, Msg);
  AddRule(Rule);
end;

procedure TConfigValidator.AddRangeRule(const PropertyPath, PropertyName: string; MinValue, MaxValue: Double; const Message: string);
var
  Rule: TRangeRule;
  Msg: string;
begin
  if Message = '' then
    Msg := Format('属性 %s 的值必须在 %f 和 %f 之间', [PropertyName, MinValue, MaxValue])
  else
    Msg := Message;
    
  Rule := TRangeRule.Create(PropertyPath, PropertyName, Msg, MinValue, MaxValue);
  AddRule(Rule);
end;

procedure TConfigValidator.AddRegexRule(const PropertyPath, PropertyName, Pattern, Message: string);
var
  Rule: TRegexRule;
  Msg: string;
begin
  if Message = '' then
    Msg := Format('属性 %s 的格式无效', [PropertyName])
  else
    Msg := Message;
    
  Rule := TRegexRule.Create(PropertyPath, PropertyName, Msg, Pattern);
  AddRule(Rule);
end;

procedure TConfigValidator.AddCustomRule(const PropertyPath, PropertyName: string; ValidateFunc: TFunc<string, Boolean>; const Message: string);
var
  Rule: TCustomRule;
  Msg: string;
begin
  if Message = '' then
    Msg := Format('属性 %s 验证失败', [PropertyName])
  else
    Msg := Message;
    
  Rule := TCustomRule.Create(PropertyPath, PropertyName, Msg, ValidateFunc);
  AddRule(Rule);
end;

procedure TConfigValidator.ClearResults;
begin
  FResults.Clear;
end;

procedure TConfigValidator.AddResult(const PropertyPath, PropertyName, Message: string; Severity: TValidationSeverity);
var
  Result: TValidationResult;
begin
  Result.PropertyPath := PropertyPath;
  Result.PropertyName := PropertyName;
  Result.Message := Message;
  Result.Severity := Severity;
  
  FResults.Add(Result);
end;

function TConfigValidator.Validate(const ConfigData: TJSONObject): Boolean;
var
  Rule: TValidationRule;
  Value: TJSONValue;
  ValueStr: string;
  i: Integer;
begin
  ClearResults;
  
  for i := 0 to FRules.Count - 1 do
  begin
    Rule := FRules[i];
    
    // 查找属性值
    Value := ConfigData.FindValue(Rule.PropertyPath);
    if Value <> nil then
    begin
      if Value is TJSONString then
        ValueStr := TJSONString(Value).Value
      else
        ValueStr := Value.ToString;
        
      // 验证规则
      if not Rule.Validate(ValueStr) then
        AddResult(Rule.PropertyPath, Rule.PropertyName, Rule.Message, Rule.Severity);
    end
    else
    begin
      // 如果是必填规则且属性不存在，则添加错误
      if Rule is TRequiredRule then
        AddResult(Rule.PropertyPath, Rule.PropertyName, Rule.Message, Rule.Severity);
    end;
  end;
  
  // 如果没有错误结果，则验证通过
  Result := FResults.Count = 0;
end;

function TConfigValidator.ValidateINI(const Section, Key, Value: string): Boolean;
var
  Rule: TValidationRule;
  PropertyPath: string;
  i: Integer;
begin
  ClearResults;
  
  // 构建属性路径
  PropertyPath := Section + '/' + Key;
  
  for i := 0 to FRules.Count - 1 do
  begin
    Rule := FRules[i];
    
    // 检查规则是否适用于当前属性
    if (Rule.PropertyPath = PropertyPath) or (Rule.PropertyPath = Key) then
    begin
      // 验证规则
      if not Rule.Validate(Value) then
        AddResult(PropertyPath, Rule.PropertyName, Rule.Message, Rule.Severity);
    end;
  end;
  
  // 如果没有错误结果，则验证通过
  Result := FResults.Count = 0;
end;

end.
