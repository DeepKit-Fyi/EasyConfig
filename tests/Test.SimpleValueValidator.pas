unit Test.SimpleValueValidator;

{*******************************************************************************
  简单属性验证器属性测试
  
  Property 8: 输入验证拒绝无效值
  *For any* 简单属性类型和不符合该类型约束的输入值，编辑器的验证逻辑应返回失败，
  阻止无效值被写入模型。
  
  **Validates: Requirements 3.3**
*******************************************************************************}

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  FrameSimpleEditorFMX;

type
  [TestFixture]
  TSimpleValueValidatorTests = class
  public
    // ========== Property 8: 输入验证拒绝无效值 ==========
    
    [Test]
    procedure Test_ValidateInteger_AcceptsValidIntegers;
    
    [Test]
    procedure Test_ValidateInteger_RejectsInvalidIntegers;
    
    [Test]
    procedure Test_ValidateFloat_AcceptsValidFloats;
    
    [Test]
    procedure Test_ValidateFloat_RejectsInvalidFloats;
    
    [Test]
    procedure Test_ValidateBoolean_AcceptsValidBooleans;
    
    [Test]
    procedure Test_ValidateBoolean_RejectsInvalidBooleans;
    
    [Test]
    procedure Test_ValidateColor_AcceptsValidColors;
    
    [Test]
    procedure Test_ValidateColor_RejectsInvalidColors;
    
    [Test]
    procedure Test_ValidatePath_AcceptsValidPaths;
    
    [Test]
    procedure Test_ValidatePath_RejectsInvalidPaths;
    
    [Test]
    procedure Test_ValidateString_AcceptsAnyString;
    
    // ========== 边界情况测试 ==========
    
    [Test]
    procedure Test_ValidateInteger_HandlesEmptyString;
    
    [Test]
    procedure Test_ValidateInteger_HandlesMaxInt;
    
    [Test]
    procedure Test_ValidateFloat_HandlesScientificNotation;
  end;

implementation

{ TSimpleValueValidatorTests }

// ========== Integer 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidateInteger_AcceptsValidIntegers;
var
  Error: string;
begin
  Assert.IsTrue(TSimpleValueValidator.ValidateInteger('0', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateInteger('123', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateInteger('-456', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateInteger('2147483647', Error)); // MaxInt
  Assert.IsTrue(TSimpleValueValidator.ValidateInteger('-2147483648', Error)); // MinInt
end;

procedure TSimpleValueValidatorTests.Test_ValidateInteger_RejectsInvalidIntegers;
var
  Error: string;
begin
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('abc', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('12.34', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('12abc', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('1,234', Error));
  Assert.IsNotEmpty(Error);
end;

procedure TSimpleValueValidatorTests.Test_ValidateInteger_HandlesEmptyString;
var
  Error: string;
begin
  // 空字符串应该被拒绝
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('', Error));
end;

procedure TSimpleValueValidatorTests.Test_ValidateInteger_HandlesMaxInt;
var
  Error: string;
begin
  // 超出 Integer 范围的值
  Assert.IsFalse(TSimpleValueValidator.ValidateInteger('9999999999999999999', Error));
end;

// ========== Float 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidateFloat_AcceptsValidFloats;
var
  Error: string;
begin
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('0', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('123.456', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('-789.012', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('0.5', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('.5', Error));
end;

procedure TSimpleValueValidatorTests.Test_ValidateFloat_RejectsInvalidFloats;
var
  Error: string;
begin
  Assert.IsFalse(TSimpleValueValidator.ValidateFloat('abc', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateFloat('12.34.56', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateFloat('12abc', Error));
  Assert.IsNotEmpty(Error);
end;

procedure TSimpleValueValidatorTests.Test_ValidateFloat_HandlesScientificNotation;
var
  Error: string;
begin
  // 科学计数法应该被接受
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('1e10', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateFloat('1.5e-3', Error));
end;

// ========== Boolean 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidateBoolean_AcceptsValidBooleans;
var
  Error: string;
begin
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('true', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('false', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('TRUE', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('FALSE', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('True', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('1', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('0', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('yes', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateBoolean('no', Error));
end;

procedure TSimpleValueValidatorTests.Test_ValidateBoolean_RejectsInvalidBooleans;
var
  Error: string;
begin
  Assert.IsFalse(TSimpleValueValidator.ValidateBoolean('abc', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateBoolean('2', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateBoolean('maybe', Error));
  Assert.IsNotEmpty(Error);
end;

// ========== Color 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidateColor_AcceptsValidColors;
var
  Error: string;
begin
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#FF0000', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#00FF00', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#0000FF', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#FFF', Error)); // 短格式
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#FFFFFF', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('#FF000000', Error)); // 带 Alpha
  Assert.IsTrue(TSimpleValueValidator.ValidateColor('', Error)); // 空值允许
end;

procedure TSimpleValueValidatorTests.Test_ValidateColor_RejectsInvalidColors;
var
  Error: string;
begin
  Assert.IsFalse(TSimpleValueValidator.ValidateColor('#GG0000', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateColor('#FF00', Error)); // 长度错误
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidateColor('red', Error)); // 颜色名称不支持
  Assert.IsNotEmpty(Error);
end;

// ========== Path 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidatePath_AcceptsValidPaths;
var
  Error: string;
begin
  Assert.IsTrue(TSimpleValueValidator.ValidatePath('C:\Users\Test\file.txt', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidatePath('/home/user/file.txt', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidatePath('relative/path/file.txt', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidatePath('', Error)); // 空路径允许
end;

procedure TSimpleValueValidatorTests.Test_ValidatePath_RejectsInvalidPaths;
var
  Error: string;
begin
  Assert.IsFalse(TSimpleValueValidator.ValidatePath('path<invalid', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidatePath('path>invalid', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidatePath('path|invalid', Error));
  Assert.IsNotEmpty(Error);
  
  Assert.IsFalse(TSimpleValueValidator.ValidatePath('path"invalid', Error));
  Assert.IsNotEmpty(Error);
end;

// ========== String 验证测试 ==========

procedure TSimpleValueValidatorTests.Test_ValidateString_AcceptsAnyString;
var
  Error: string;
begin
  // 字符串类型应该接受任何值
  Assert.IsTrue(TSimpleValueValidator.ValidateValue(svtString, '', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateValue(svtString, 'hello', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateValue(svtString, '123', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateValue(svtString, '!@#$%^&*()', Error));
  Assert.IsTrue(TSimpleValueValidator.ValidateValue(svtString, '中文测试', Error));
end;

initialization
  TDUnitX.RegisterTestFixture(TSimpleValueValidatorTests);

end.
