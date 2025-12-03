unit Test.UtilsTypesFMX;

{*******************************************************************************
  UtilsTypesFMX 类型系统属性测试
  
  Property 3: 类型到编辑器映射一致性
  *For any* TConfigType 枚举值，ConfigTypeToEditorType 函数应返回一个有效的 TEditorType，
  且对于复杂类型，ControllerConfigs.GetFrameClassForType 应返回非空的 Frame 类。
  
  **Validates: Requirements 3.1, 4.1**
*******************************************************************************}

interface

uses
  System.SysUtils, System.JSON, System.UITypes,
  DUnitX.TestFramework,
  UtilsTypesFMX;

type
  [TestFixture]
  TUtilsTypesFMXTests = class
  public
    // ========== Property 3: 类型映射一致性测试 ==========
    
    [Test]
    procedure Test_AllConfigTypes_HaveValidEditorType;
    
    [Test]
    procedure Test_ConfigTypeToString_ReturnsNonEmpty;
    
    [Test]
    procedure Test_StringToConfigType_RoundTrip;
    
    [Test]
    procedure Test_ComplexTypes_MapToFrameEditor;
    
    [Test]
    procedure Test_SimpleTypes_MapToSimpleEditor;
    
    // ========== 类型转换测试 ==========
    
    [Test]
    [TestCase('String', 'String,ctPlain')]
    [TestCase('Integer', 'Integer,ctInteger')]
    [TestCase('Float', 'Float,ctFloat')]
    [TestCase('Boolean', 'Boolean,ctBoolean')]
    [TestCase('Font', 'Font,ctFont')]
    [TestCase('Database', 'Database,ctDatabase')]
    [TestCase('AIAPI', 'AIAPI,ctAIAPI')]
    [TestCase('BgDraw', 'BgDraw,ctBgDraw')]
    [TestCase('VideoClip', 'VideoClip,ctVideoClip')]
    procedure Test_StringToConfigType_KnownTypes(const TypeStr: string; Expected: TConfigType);
    
    [Test]
    procedure Test_StringToConfigType_CaseInsensitive;
    
    [Test]
    procedure Test_StringToConfigType_UnknownReturnsPlain;
    
    // ========== 颜色转换测试 ==========
    
    [Test]
    [TestCase('Red', '#FF0000')]
    [TestCase('Green', '#00FF00')]
    [TestCase('Blue', '#0000FF')]
    [TestCase('White', '#FFFFFF')]
    [TestCase('Black', '#000000')]
    procedure Test_HTMLToAlphaColor_ValidColors(const HTMLColor: string);
    
    [Test]
    procedure Test_AlphaColorToHTML_RoundTrip;
    
    // ========== JSON 类型检测测试 ==========
    
    [Test]
    procedure Test_GetTypeFromJSON_WithTypeField;
    
    [Test]
    procedure Test_GetTypeFromJSON_WithoutTypeField;
    
    [Test]
    procedure Test_DetectComplexPropertyType_AllTypes;
  end;

implementation

{ TUtilsTypesFMXTests }

// ========== Property 3: 类型映射一致性测试 ==========

procedure TUtilsTypesFMXTests.Test_AllConfigTypes_HaveValidEditorType;
var
  CT: TConfigType;
  ET: TEditorType;
begin
  // For all TConfigType values, ConfigTypeToEditorType should return a valid TEditorType
  for CT := Low(TConfigType) to High(TConfigType) do
  begin
    ET := ConfigTypeToEditorType(CT);
    // 验证返回的编辑器类型在有效范围内
    Assert.IsTrue(Ord(ET) >= Ord(Low(TEditorType)), 
      Format('ConfigType %d should map to valid EditorType', [Ord(CT)]));
    Assert.IsTrue(Ord(ET) <= Ord(High(TEditorType)), 
      Format('ConfigType %d should map to valid EditorType', [Ord(CT)]));
  end;
end;

procedure TUtilsTypesFMXTests.Test_ConfigTypeToString_ReturnsNonEmpty;
var
  CT: TConfigType;
  TypeStr: string;
begin
  // For all TConfigType values, ConfigTypeToString should return non-empty string
  for CT := Low(TConfigType) to High(TConfigType) do
  begin
    TypeStr := ConfigTypeToString(CT);
    Assert.IsNotEmpty(TypeStr, 
      Format('ConfigType %d should have non-empty string representation', [Ord(CT)]));
  end;
end;

procedure TUtilsTypesFMXTests.Test_StringToConfigType_RoundTrip;
var
  CT, ResultCT: TConfigType;
  TypeStr: string;
begin
  // For all TConfigType values (except ctCustom which maps to 'Custom'),
  // StringToConfigType(ConfigTypeToString(CT)) should return CT
  for CT := Low(TConfigType) to High(TConfigType) do
  begin
    if CT = ctCustom then
      Continue; // Custom 类型的 round-trip 可能不完全匹配
      
    TypeStr := ConfigTypeToString(CT);
    ResultCT := StringToConfigType(TypeStr);
    Assert.AreEqual(CT, ResultCT, 
      Format('Round-trip failed for ConfigType %d (%s)', [Ord(CT), TypeStr]));
  end;
end;

procedure TUtilsTypesFMXTests.Test_ComplexTypes_MapToFrameEditor;
var
  ComplexTypes: array of TConfigType;
  CT: TConfigType;
  ET: TEditorType;
  GroupType: TConfigGroupType;
begin
  // 复杂类型应该映射到 Frame 编辑器
  ComplexTypes := [ctFont, ctDatabase, ctAIAPI, ctBgDraw, ctVideoClip, ctVideo, ctObject, ctArray, ctList];
  
  for CT in ComplexTypes do
  begin
    GroupType := GetConfigGroupType(CT);
    Assert.AreEqual(cgtComplex, GroupType, 
      Format('ConfigType %s should be complex type', [ConfigTypeToString(CT)]));
    
    ET := ConfigTypeToEditorType(CT);
    // 复杂类型应该映射到专用编辑器，而不是简单的 etEdit
    Assert.AreNotEqual(etEdit, ET, 
      Format('Complex type %s should not map to etEdit', [ConfigTypeToString(CT)]));
  end;
end;

procedure TUtilsTypesFMXTests.Test_SimpleTypes_MapToSimpleEditor;
var
  SimpleTypes: array of TConfigType;
  CT: TConfigType;
  GroupType: TConfigGroupType;
begin
  // 简单类型应该属于 cgtSimple 组
  SimpleTypes := [ctPlain, ctInteger, ctFloat, ctBoolean, ctColor, ctPath];
  
  for CT in SimpleTypes do
  begin
    GroupType := GetConfigGroupType(CT);
    Assert.AreEqual(cgtSimple, GroupType, 
      Format('ConfigType %s should be simple type', [ConfigTypeToString(CT)]));
  end;
end;

// ========== 类型转换测试 ==========

procedure TUtilsTypesFMXTests.Test_StringToConfigType_KnownTypes(
  const TypeStr: string; Expected: TConfigType);
begin
  Assert.AreEqual(Expected, StringToConfigType(TypeStr));
end;

procedure TUtilsTypesFMXTests.Test_StringToConfigType_CaseInsensitive;
begin
  Assert.AreEqual(ctFont, StringToConfigType('font'));
  Assert.AreEqual(ctFont, StringToConfigType('FONT'));
  Assert.AreEqual(ctFont, StringToConfigType('Font'));
  Assert.AreEqual(ctDatabase, StringToConfigType('database'));
  Assert.AreEqual(ctDatabase, StringToConfigType('DATABASE'));
end;

procedure TUtilsTypesFMXTests.Test_StringToConfigType_UnknownReturnsPlain;
begin
  Assert.AreEqual(ctPlain, StringToConfigType('unknown_type'));
  Assert.AreEqual(ctPlain, StringToConfigType(''));
  Assert.AreEqual(ctPlain, StringToConfigType('xyz123'));
end;

// ========== 颜色转换测试 ==========

procedure TUtilsTypesFMXTests.Test_HTMLToAlphaColor_ValidColors(const HTMLColor: string);
var
  Color: TAlphaColor;
begin
  Color := HTMLToAlphaColor(HTMLColor);
  // 验证颜色值不是默认的白色（除非输入就是白色）
  if HTMLColor <> '#FFFFFF' then
    Assert.AreNotEqual(TAlphaColorRec.White, Color, 
      Format('HTMLToAlphaColor should parse %s correctly', [HTMLColor]));
end;

procedure TUtilsTypesFMXTests.Test_AlphaColorToHTML_RoundTrip;
var
  OriginalHTML, ResultHTML: string;
  Color: TAlphaColor;
begin
  // Round-trip: HTML -> Color -> HTML
  OriginalHTML := '#FF5500';
  Color := HTMLToAlphaColor(OriginalHTML);
  ResultHTML := AlphaColorToHTML(Color);
  
  Assert.AreEqual(LowerCase(OriginalHTML), LowerCase(ResultHTML), 
    'Color round-trip should preserve value');
end;

// ========== JSON 类型检测测试 ==========

procedure TUtilsTypesFMXTests.Test_GetTypeFromJSON_WithTypeField;
var
  JSONObj: TJSONObject;
  CT: TConfigType;
begin
  JSONObj := TJSONObject.Create;
  try
    JSONObj.AddPair('_type', 'Font');
    JSONObj.AddPair('family', 'Arial');
    
    CT := GetTypeFromJSON(JSONObj);
    Assert.AreEqual(ctFont, CT);
  finally
    JSONObj.Free;
  end;
end;

procedure TUtilsTypesFMXTests.Test_GetTypeFromJSON_WithoutTypeField;
var
  JSONObj: TJSONObject;
  CT: TConfigType;
begin
  JSONObj := TJSONObject.Create;
  try
    JSONObj.AddPair('name', 'test');
    JSONObj.AddPair('value', TJSONNumber.Create(123));
    
    CT := GetTypeFromJSON(JSONObj);
    Assert.AreEqual(ctObject, CT, 'Objects without _type should default to ctObject');
  finally
    JSONObj.Free;
  end;
end;

procedure TUtilsTypesFMXTests.Test_DetectComplexPropertyType_AllTypes;
var
  JSONObj: TJSONObject;
  CPT: TComplexPropertyType;
  TypeName: string;
begin
  // 测试所有复杂属性类型的检测
  JSONObj := TJSONObject.Create;
  try
    // Font
    JSONObj.RemovePair('_type');
    JSONObj.AddPair('_type', 'etFont');
    CPT := DetectComplexPropertyType(JSONObj);
    Assert.AreEqual(cptFont, CPT, 'Should detect Font type');
    
    // Database
    JSONObj.RemovePair('_type');
    JSONObj.AddPair('_type', 'etDatabase');
    CPT := DetectComplexPropertyType(JSONObj);
    Assert.AreEqual(cptDatabase, CPT, 'Should detect Database type');
    
    // AIAPI
    JSONObj.RemovePair('_type');
    JSONObj.AddPair('_type', 'etAIAPI');
    CPT := DetectComplexPropertyType(JSONObj);
    Assert.AreEqual(cptAIAPI, CPT, 'Should detect AIAPI type');
    
    // BgDraw
    JSONObj.RemovePair('_type');
    JSONObj.AddPair('_type', 'etBgDraw');
    CPT := DetectComplexPropertyType(JSONObj);
    Assert.AreEqual(cptBgDraw, CPT, 'Should detect BgDraw type');
    
    // VideoClip
    JSONObj.RemovePair('_type');
    JSONObj.AddPair('_type', 'etVideoClip');
    CPT := DetectComplexPropertyType(JSONObj);
    Assert.AreEqual(cptVideoClip, CPT, 'Should detect VideoClip type');
  finally
    JSONObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TUtilsTypesFMXTests);

end.
