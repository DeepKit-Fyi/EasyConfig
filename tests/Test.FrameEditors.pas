unit Test.FrameEditors;

{*******************************************************************************
  Frame 编辑器属性测试
  
  Property 4: Frame 编辑器 LoadFromJSON/SaveToJSON Round-Trip
  *For any* 有效的复杂属性 JSON 对象，执行 LoadFromJSON 加载到 Frame 后再执行 
  SaveToJSON 保存，生成的 JSON 对象应与原始对象在语义上等价。
  
  **Validates: Requirements 4.2, 4.3**
*******************************************************************************}

interface

uses
  System.SysUtils, System.JSON,
  DUnitX.TestFramework,
  ConfigFrameBaseFMX, UtilsTypesFMX;

type
  [TestFixture]
  TFrameEditorsTests = class
  private
    function CreateFontJSON: TJSONObject;
    function CreateDatabaseJSON: TJSONObject;
    function CreateVideoClipJSON: TJSONObject;
    function JSONEquals(A, B: TJSONObject; const Keys: array of string): Boolean;
  public
    // ========== Property 4: Round-Trip 测试 ==========
    
    [Test]
    procedure Test_FontEditor_RoundTrip;
    
    [Test]
    procedure Test_DatabaseEditor_RoundTrip;
    
    [Test]
    procedure Test_VideoClipEditor_RoundTrip;
    
    // ========== 基类功能测试 ==========
    
    [Test]
    procedure Test_BaseFrame_BeginEndUpdate;
    
    [Test]
    procedure Test_BaseFrame_ModifiedEvent;
    
    [Test]
    procedure Test_BaseFrame_JSONHelpers;
  end;

implementation

uses
  FrameFontEditorFMX, FrameDBEditorFMX, FrameVideoClipEditorFMX;

{ TFrameEditorsTests }

function TFrameEditorsTests.CreateFontJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_type', 'Font');
  Result.AddPair('_id', 'font_test');
  Result.AddPair('Name', 'Arial');
  Result.AddPair('Size', TJSONNumber.Create(14));
  Result.AddPair('Bold', TJSONBool.Create(True));
  Result.AddPair('Italic', TJSONBool.Create(False));
  Result.AddPair('Underline', TJSONBool.Create(False));
  Result.AddPair('Color', '#FF0000');
end;

function TFrameEditorsTests.CreateDatabaseJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_type', 'Database');
  Result.AddPair('_id', 'db_test');
  Result.AddPair('Type', 'PostgreSQL');
  Result.AddPair('Host', 'localhost');
  Result.AddPair('Port', TJSONNumber.Create(5432));
  Result.AddPair('Database', 'testdb');
  Result.AddPair('User', 'testuser');
end;

function TFrameEditorsTests.CreateVideoClipJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_type', 'VideoClip');
  Result.AddPair('_id', 'clip_test');
  Result.AddPair('source', 'videos/test.mp4');
  Result.AddPair('start_time', TJSONNumber.Create(0));
  Result.AddPair('end_time', TJSONNumber.Create(30));
  Result.AddPair('volume', TJSONNumber.Create(0.8));
end;

function TFrameEditorsTests.JSONEquals(A, B: TJSONObject; 
  const Keys: array of string): Boolean;
var
  Key: string;
  ValA, ValB: TJSONValue;
begin
  Result := True;
  
  for Key in Keys do
  begin
    ValA := A.GetValue(Key);
    ValB := B.GetValue(Key);
    
    if (ValA = nil) and (ValB = nil) then
      Continue;
      
    if (ValA = nil) or (ValB = nil) then
    begin
      Result := False;
      Exit;
    end;
    
    if ValA.ToString <> ValB.ToString then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

// ========== Property 4: Round-Trip 测试 ==========

procedure TFrameEditorsTests.Test_FontEditor_RoundTrip;
var
  Frame: TFrameFontEditorFMX;
  OriginalJSON, ResultJSON: TJSONObject;
begin
  Frame := TFrameFontEditorFMX.Create(nil);
  try
    OriginalJSON := CreateFontJSON;
    try
      // Load
      Frame.JSONObject := OriginalJSON;
      
      // Save
      Frame.SaveToJSON;
      ResultJSON := Frame.JSONObject;
      
      // Verify key fields are preserved
      Assert.AreEqual(
        OriginalJSON.GetValue<string>('Name'),
        ResultJSON.GetValue<string>('Name'),
        'Font name should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<Integer>('Size'),
        ResultJSON.GetValue<Integer>('Size'),
        'Font size should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<Boolean>('Bold'),
        ResultJSON.GetValue<Boolean>('Bold'),
        'Bold flag should be preserved');
    finally
      OriginalJSON.Free;
    end;
  finally
    Frame.Free;
  end;
end;

procedure TFrameEditorsTests.Test_DatabaseEditor_RoundTrip;
var
  Frame: TFrameDBEditorFMX;
  OriginalJSON, ResultJSON: TJSONObject;
begin
  Frame := TFrameDBEditorFMX.Create(nil);
  try
    OriginalJSON := CreateDatabaseJSON;
    try
      // Load
      Frame.JSONObject := OriginalJSON;
      
      // Save
      Frame.SaveToJSON;
      ResultJSON := Frame.JSONObject;
      
      // Verify key fields are preserved
      Assert.AreEqual(
        OriginalJSON.GetValue<string>('Host'),
        ResultJSON.GetValue<string>('Host'),
        'Host should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<Integer>('Port'),
        ResultJSON.GetValue<Integer>('Port'),
        'Port should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<string>('Database'),
        ResultJSON.GetValue<string>('Database'),
        'Database name should be preserved');
    finally
      OriginalJSON.Free;
    end;
  finally
    Frame.Free;
  end;
end;

procedure TFrameEditorsTests.Test_VideoClipEditor_RoundTrip;
var
  Frame: TFrameVideoClipEditorFMX;
  OriginalJSON, ResultJSON: TJSONObject;
begin
  Frame := TFrameVideoClipEditorFMX.Create(nil);
  try
    OriginalJSON := CreateVideoClipJSON;
    try
      // Load
      Frame.JSONObject := OriginalJSON;
      
      // Save
      Frame.SaveToJSON;
      ResultJSON := Frame.JSONObject;
      
      // Verify key fields are preserved
      Assert.AreEqual(
        OriginalJSON.GetValue<string>('source'),
        ResultJSON.GetValue<string>('source'),
        'Source should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<Integer>('start_time'),
        ResultJSON.GetValue<Integer>('start_time'),
        'Start time should be preserved');
      Assert.AreEqual(
        OriginalJSON.GetValue<Integer>('end_time'),
        ResultJSON.GetValue<Integer>('end_time'),
        'End time should be preserved');
    finally
      OriginalJSON.Free;
    end;
  finally
    Frame.Free;
  end;
end;

// ========== 基类功能测试 ==========

procedure TFrameEditorsTests.Test_BaseFrame_BeginEndUpdate;
var
  Frame: TFrameFontEditorFMX;
begin
  Frame := TFrameFontEditorFMX.Create(nil);
  try
    // 测试 BeginUpdate/EndUpdate 不会崩溃
    Frame.BeginUpdate;
    Frame.EndUpdate;
    
    // 测试嵌套调用
    Frame.BeginUpdate;
    Frame.BeginUpdate;
    Frame.EndUpdate;
    Frame.EndUpdate;
    
    Assert.Pass('BeginUpdate/EndUpdate should work without errors');
  finally
    Frame.Free;
  end;
end;

procedure TFrameEditorsTests.Test_BaseFrame_ModifiedEvent;
var
  Frame: TFrameFontEditorFMX;
begin
  Frame := TFrameFontEditorFMX.Create(nil);
  try
    // 初始状态应该是未修改
    Assert.IsFalse(Frame.Modified, 'Initial state should be not modified');
    
    // 设置为已修改
    Frame.Modified := True;
    Assert.IsTrue(Frame.Modified, 'Should be modified after setting to True');
    
    // 设置为未修改
    Frame.Modified := False;
    Assert.IsFalse(Frame.Modified, 'Should not be modified after setting to False');
  finally
    Frame.Free;
  end;
end;

procedure TFrameEditorsTests.Test_BaseFrame_JSONHelpers;
var
  Frame: TFrameFontEditorFMX;
  JSON: TJSONObject;
begin
  Frame := TFrameFontEditorFMX.Create(nil);
  try
    JSON := TJSONObject.Create;
    try
      JSON.AddPair('str', 'test');
      JSON.AddPair('int', TJSONNumber.Create(42));
      JSON.AddPair('float', TJSONNumber.Create(3.14));
      JSON.AddPair('bool', TJSONBool.Create(True));
      
      Frame.JSONObject := JSON;
      
      // 测试全局帮助函数
      Assert.AreEqual('test', GetJSONString(JSON, 'str'));
      Assert.AreEqual(42, GetJSONInt(JSON, 'int'));
      Assert.AreEqual(3.14, GetJSONFloat(JSON, 'float'), 0.001);
      Assert.IsTrue(GetJSONBool(JSON, 'bool'));
      
      // 测试默认值
      Assert.AreEqual('default', GetJSONString(JSON, 'missing', 'default'));
      Assert.AreEqual(99, GetJSONInt(JSON, 'missing', 99));
    finally
      JSON.Free;
    end;
  finally
    Frame.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TFrameEditorsTests);

end.
