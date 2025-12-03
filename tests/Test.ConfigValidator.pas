unit Test.ConfigValidator;

{*******************************************************************************
  ConfigValidator 属性测试
  
  Property 5: 验证规则完整性
  *For any* 配置对象，如果必填字段为空，则 ValidateAll 返回的结果中应包含至少一个 
  vlError 级别的条目；如果 _ref 引用指向不存在的 _id，则应返回错误。
  
  **Validates: Requirements 5.2, 5.4**
*******************************************************************************}

interface

uses
  System.SysUtils, System.JSON,
  DUnitX.TestFramework,
  ConfigValidator;

type
  [TestFixture]
  TConfigValidatorTests = class
  private
    FValidator: TConfigValidator;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    // ========== Property 5: 验证规则完整性测试 ==========
    
    [Test]
    procedure Test_RequiredField_Empty_ReturnsError;
    
    [Test]
    procedure Test_RequiredField_NonEmpty_Passes;
    
    [Test]
    procedure Test_InvalidReference_ReturnsError;
    
    [Test]
    procedure Test_ValidReference_Passes;
    
    // ========== 数值范围验证测试 ==========
    
    [Test]
    procedure Test_RangeRule_InRange_Passes;
    
    [Test]
    procedure Test_RangeRule_OutOfRange_ReturnsError;
    
    // ========== 其他验证规则测试 ==========
    
    [Test]
    procedure Test_EmailRule_ValidEmail_Passes;
    
    [Test]
    procedure Test_EmailRule_InvalidEmail_ReturnsError;
    
    [Test]
    procedure Test_URLRule_ValidURL_Passes;
    
    [Test]
    procedure Test_URLRule_InvalidURL_ReturnsError;
    
    [Test]
    procedure Test_IPAddressRule_ValidIP_Passes;
    
    [Test]
    procedure Test_IPAddressRule_InvalidIP_ReturnsError;
    
    [Test]
    procedure Test_ColorCodeRule_ValidColor_Passes;
    
    [Test]
    procedure Test_ColorCodeRule_InvalidColor_ReturnsError;
    
    // ========== 自动修复测试 ==========
    
    [Test]
    procedure Test_AutoFix_URL_AddsProtocol;
    
    [Test]
    procedure Test_AutoFix_Range_ClipsValue;
    
    [Test]
    procedure Test_AutoFix_ColorCode_AddsHash;
  end;

implementation

{ TConfigValidatorTests }

procedure TConfigValidatorTests.Setup;
begin
  FValidator := TConfigValidator.Create;
end;

procedure TConfigValidatorTests.TearDown;
begin
  FValidator.Free;
end;

// ========== Property 5: 验证规则完整性测试 ==========

procedure TConfigValidatorTests.Test_RequiredField_Empty_ReturnsError;
begin
  // Arrange
  FValidator.AddRequiredRule('app_settings/name', 'name', '名称不能为空');
  
  // Act
  FValidator.ClearResults;
  FValidator.ValidateINI('app_settings', 'name', '');
  
  // Assert
  Assert.AreEqual(1, FValidator.Results.Count, 'Should have one error');
  Assert.IsTrue(FValidator.Results[0].IsError, 'Should be an error');
  Assert.Contains(FValidator.Results[0].ErrorMessage, '名称不能为空');
end;

procedure TConfigValidatorTests.Test_RequiredField_NonEmpty_Passes;
begin
  // Arrange
  FValidator.AddRequiredRule('app_settings/name', 'name', '名称不能为空');
  
  // Act
  FValidator.ClearResults;
  var IsValid := FValidator.ValidateINI('app_settings', 'name', 'MyApp');
  
  // Assert
  Assert.IsTrue(IsValid, 'Validation should pass');
  Assert.AreEqual(0, FValidator.Results.Count, 'Should have no errors');
end;

procedure TConfigValidatorTests.Test_InvalidReference_ReturnsError;
var
  JSONRoot: TJSONObject;
  Results: TArray<TValidationResult>;
begin
  // Arrange: 创建包含无效引用的 JSON
  JSONRoot := TJSONObject.Create;
  try
    JSONRoot.AddPair('fonts', TJSONObject.Create
      .AddPair('_id', 'font_main')
      .AddPair('_type', 'Font'));
    JSONRoot.AddPair('ui', TJSONObject.Create
      .AddPair('_ref', 'font_nonexistent')); // 引用不存在的 ID
    
    // Act
    Results := FValidator.ValidateReferences(JSONRoot);
    
    // Assert
    Assert.AreEqual(1, Length(Results), 'Should have one reference error');
    Assert.IsTrue(Results[0].IsError, 'Should be an error');
    Assert.Contains(Results[0].ErrorMessage, 'font_nonexistent');
  finally
    JSONRoot.Free;
  end;
end;

procedure TConfigValidatorTests.Test_ValidReference_Passes;
var
  JSONRoot: TJSONObject;
  Results: TArray<TValidationResult>;
begin
  // Arrange: 创建包含有效引用的 JSON
  JSONRoot := TJSONObject.Create;
  try
    JSONRoot.AddPair('fonts', TJSONObject.Create
      .AddPair('_id', 'font_main')
      .AddPair('_type', 'Font'));
    JSONRoot.AddPair('ui', TJSONObject.Create
      .AddPair('_ref', 'font_main')); // 引用存在的 ID
    
    // Act
    Results := FValidator.ValidateReferences(JSONRoot);
    
    // Assert
    Assert.AreEqual(0, Length(Results), 'Should have no reference errors');
  finally
    JSONRoot.Free;
  end;
end;

// ========== 数值范围验证测试 ==========

procedure TConfigValidatorTests.Test_RangeRule_InRange_Passes;
begin
  // Arrange
  FValidator.AddRangeRule('settings/volume', 'volume', 0, 100);
  
  // Act
  FValidator.ClearResults;
  var IsValid := FValidator.ValidateINI('settings', 'volume', '50');
  
  // Assert
  Assert.IsTrue(IsValid, 'Value in range should pass');
end;

procedure TConfigValidatorTests.Test_RangeRule_OutOfRange_ReturnsError;
begin
  // Arrange
  FValidator.AddRangeRule('settings/volume', 'volume', 0, 100);
  
  // Act
  FValidator.ClearResults;
  var IsValid := FValidator.ValidateINI('settings', 'volume', '150');
  
  // Assert
  Assert.IsFalse(IsValid, 'Value out of range should fail');
  Assert.AreEqual(1, FValidator.Results.Count, 'Should have one error');
end;

// ========== 其他验证规则测试 ==========

procedure TConfigValidatorTests.Test_EmailRule_ValidEmail_Passes;
begin
  FValidator.AddEmailRule('user/email', 'email');
  FValidator.ClearResults;
  
  Assert.IsTrue(FValidator.ValidateINI('user', 'email', 'test@example.com'));
  Assert.AreEqual(0, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_EmailRule_InvalidEmail_ReturnsError;
begin
  FValidator.AddEmailRule('user/email', 'email');
  FValidator.ClearResults;
  
  Assert.IsFalse(FValidator.ValidateINI('user', 'email', 'invalid-email'));
  Assert.AreEqual(1, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_URLRule_ValidURL_Passes;
begin
  FValidator.AddURLRule('api/endpoint', 'endpoint');
  FValidator.ClearResults;
  
  Assert.IsTrue(FValidator.ValidateINI('api', 'endpoint', 'https://api.example.com'));
  Assert.AreEqual(0, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_URLRule_InvalidURL_ReturnsError;
begin
  FValidator.AddURLRule('api/endpoint', 'endpoint');
  FValidator.ClearResults;
  
  Assert.IsFalse(FValidator.ValidateINI('api', 'endpoint', 'not-a-url'));
  Assert.AreEqual(1, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_IPAddressRule_ValidIP_Passes;
begin
  FValidator.AddIPAddressRule('network/host', 'host');
  FValidator.ClearResults;
  
  Assert.IsTrue(FValidator.ValidateINI('network', 'host', '192.168.1.1'));
  Assert.AreEqual(0, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_IPAddressRule_InvalidIP_ReturnsError;
begin
  FValidator.AddIPAddressRule('network/host', 'host');
  FValidator.ClearResults;
  
  Assert.IsFalse(FValidator.ValidateINI('network', 'host', '999.999.999.999'));
  Assert.AreEqual(1, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_ColorCodeRule_ValidColor_Passes;
begin
  FValidator.AddColorCodeRule('ui/color', 'color');
  FValidator.ClearResults;
  
  Assert.IsTrue(FValidator.ValidateINI('ui', 'color', '#FF0000'));
  Assert.AreEqual(0, FValidator.Results.Count);
end;

procedure TConfigValidatorTests.Test_ColorCodeRule_InvalidColor_ReturnsError;
begin
  FValidator.AddColorCodeRule('ui/color', 'color');
  FValidator.ClearResults;
  
  Assert.IsFalse(FValidator.ValidateINI('ui', 'color', 'red'));
  Assert.AreEqual(1, FValidator.Results.Count);
end;

// ========== 自动修复测试 ==========

procedure TConfigValidatorTests.Test_AutoFix_URL_AddsProtocol;
var
  FixedValue: string;
begin
  FValidator.AddURLRule('api/endpoint', 'endpoint');
  
  var CanFix := FValidator.TryAutoFix('api/endpoint', 'endpoint', 'example.com', FixedValue);
  
  Assert.IsTrue(CanFix, 'URL should be fixable');
  Assert.AreEqual('https://example.com', FixedValue);
end;

procedure TConfigValidatorTests.Test_AutoFix_Range_ClipsValue;
var
  FixedValue: string;
begin
  FValidator.AddRangeRule('settings/volume', 'volume', 0, 100);
  
  var CanFix := FValidator.TryAutoFix('settings/volume', 'volume', '150', FixedValue);
  
  Assert.IsTrue(CanFix, 'Range should be fixable');
  Assert.AreEqual('100', FixedValue);
end;

procedure TConfigValidatorTests.Test_AutoFix_ColorCode_AddsHash;
var
  FixedValue: string;
begin
  FValidator.AddColorCodeRule('ui/color', 'color');
  
  var CanFix := FValidator.TryAutoFix('ui/color', 'color', 'FF0000', FixedValue);
  
  Assert.IsTrue(CanFix, 'Color code should be fixable');
  Assert.AreEqual('#FF0000', FixedValue);
end;

initialization
  TDUnitX.RegisterTestFixture(TConfigValidatorTests);

end.
