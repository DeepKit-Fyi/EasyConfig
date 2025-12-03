unit AutoFixDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections, System.IniFiles, System.JSON, JSONHelpers,
  ConfigValidator, ValidationDialog;

type
  TConfigFixDemoForm = class(TForm)
    PageControl1: TPageControl;
    tsINI: TTabSheet;
    tsJSON: TTabSheet;
    pnlINITop: TPanel;
    pnlINIContent: TPanel;
    pnlJSONTop: TPanel;
    pnlJSONContent: TPanel;
    btnValidateINI: TButton;
    sgINI: TStringGrid;
    memJSON: TMemo;
    btnValidateJSON: TButton;
    StatusBar: TStatusBar;
    btnAddSampleData: TButton;
    btnResetINI: TButton;
    btnFixINI: TButton;
    btnResetJSON: TButton;
    btnFixJSON: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnValidateINIClick(Sender: TObject);
    procedure btnValidateJSONClick(Sender: TObject);
    procedure btnAddSampleDataClick(Sender: TObject);
    procedure btnResetINIClick(Sender: TObject);
    procedure btnFixINIClick(Sender: TObject);
    procedure btnResetJSONClick(Sender: TObject);
    procedure btnFixJSONClick(Sender: TObject);
  private
    FValidator: TConfigValidator;
    FValidationDialog: TfrmValidation;
    FINIFile: TMemIniFile;
    FJSONObject: TJSONObject;
    
    procedure InitializeValidator;
    procedure InitializeINIGrid;
    procedure LoadSampleINIData;
    procedure LoadSampleJSONData;
    procedure DisplayValidationResults;
    procedure SelectProperty(const Path, Name: string);
    procedure FixProperty(const Path, Name: string);
    function CreateINIPropertyPath(const Section, Key: string): string;
    procedure UpdateINIGrid;
    procedure UpdateJSONDisplay;
  public
    { Public declarations }
  end;

var
  ConfigFixDemoForm: TConfigFixDemoForm;

implementation

{$R *.dfm}

procedure TConfigFixDemoForm.FormCreate(Sender: TObject);
begin
  // 创建验证器
  FValidator := TConfigValidator.Create;
  InitializeValidator;
  
  // 创建验证对话框
  FValidationDialog := TfrmValidation.Create(Self);
  FValidationDialog.OnSelectProperty := SelectProperty;
  FValidationDialog.OnFixProperty := FixProperty;
  
  // 初始化INI设置
  FINIFile := TMemIniFile.Create('');
  InitializeINIGrid;
  
  // 初始化JSON对象
  FJSONObject := TJSONObject.Create;
  
  // 显示初始状态
  StatusBar.SimpleText := '就绪。点击"添加样例数据"加载测试数据，然后点击"验证"按钮检查配置。';
end;

procedure TConfigFixDemoForm.FormDestroy(Sender: TObject);
begin
  FValidator.Free;
  FValidationDialog.Free;
  FINIFile.Free;
  FJSONObject.Free;
end;

procedure TConfigFixDemoForm.InitializeValidator;
begin
  // 添加INI验证规则
  FValidator.AddRequiredRule('General/Name', 'Name', '名称不能为空');
  FValidator.AddNumericRule('General/Age', 'Age', '年龄必须是数字');
  FValidator.AddRangeRule('General/Age', 'Age', 0, 120, '年龄必须在0到120之间');
  FValidator.AddEmailRule('General/Email', 'Email', '必须是有效的电子邮件地址');
  FValidator.AddURLRule('Network/Website', 'Website', '必须是有效的网站地址');
  FValidator.AddIPAddressRule('Network/IPAddress', 'IPAddress', '必须是有效的IP地址');
  FValidator.AddPasswordRule('Security/Password', 'Password', 8, True, True, True, 
                          '密码至少需要8个字符，且必须包含大写字母、数字和特殊字符');
  FValidator.AddColorCodeRule('UI/BackgroundColor', 'BackgroundColor', '必须是有效的颜色代码(#RRGGBB)');
  FValidator.AddDateTimeRule('Schedule/StartDate', 'StartDate', 'yyyy-mm-dd', '必须是有效的日期(YYYY-MM-DD)');
  
  // 添加JSON验证规则
  FValidator.AddRequiredRule('user/name', 'name', '用户名不能为空');
  FValidator.AddEmailRule('user/email', 'email', '必须是有效的电子邮件地址');
  FValidator.AddJSONRule('user/preferences', 'preferences', '必须是有效的JSON对象');
  FValidator.AddURLRule('links/homepage', 'homepage', '必须是有效的URL');
  FValidator.AddIPAddressRule('network/ip', 'ip', '必须是有效的IP地址');
end;

procedure TConfigFixDemoForm.InitializeINIGrid;
begin
  // 设置INI表格
  with sgINI do
  begin
    ColCount := 4;
    RowCount := 2;
    FixedRows := 1;
    
    // 设置列标题
    Cells[0, 0] := '节';
    Cells[1, 0] := '键';
    Cells[2, 0] := '值';
    Cells[3, 0] := '状态';
    
    // 设置列宽
    ColWidths[0] := 120;
    ColWidths[1] := 120;
    ColWidths[2] := 200;
    ColWidths[3] := 100;
  end;
end;

procedure TConfigFixDemoForm.btnAddSampleDataClick(Sender: TObject);
begin
  // 加载示例数据
  LoadSampleINIData;
  LoadSampleJSONData;
  StatusBar.SimpleText := '已加载样例数据。点击"验证"按钮检查配置。';
end;

procedure TConfigFixDemoForm.LoadSampleINIData;
begin
  // 清空当前数据
  FINIFile.Clear;
  
  // 添加有效数据
  FINIFile.WriteString('General', 'Name', 'John Doe');
  FINIFile.WriteString('General', 'Age', '30');
  FINIFile.WriteString('General', 'Email', 'john.doe@example.com');
  
  // 添加无效数据
  FINIFile.WriteString('Network', 'Website', 'example.com');  // 缺少http://
  FINIFile.WriteString('Network', 'IPAddress', '192.168.1.300');  // IP段值超出范围
  
  FINIFile.WriteString('Security', 'Password', 'password');  // 简单密码
  
  FINIFile.WriteString('UI', 'BackgroundColor', 'FF0000');  // 缺少#
  
  FINIFile.WriteString('Schedule', 'StartDate', '2023-13-01');  // 无效月份
  
  // 更新表格
  UpdateINIGrid;
end;

procedure TConfigFixDemoForm.LoadSampleJSONData;
begin
  // 清空当前数据
  FJSONObject.Free;
  FJSONObject := TJSONObject.Create;
  
  // 添加用户信息
  var User := TJSONObject.Create;
  User.AddPair('name', 'Jane Doe');
  User.AddPair('email', 'not-an-email');  // 无效邮箱
  User.AddPair('preferences', '{color: "blue"}');  // 无效JSON格式
  
  // 添加链接信息
  var Links := TJSONObject.Create;
  Links.AddPair('homepage', 'www.example.com');  // 缺少http://
  
  // 添加网络信息
  var Network := TJSONObject.Create;
  Network.AddPair('ip', '256.0.0.1');  // 无效IP
  
  // 添加到主对象
  FJSONObject.AddPair('user', User);
  FJSONObject.AddPair('links', Links);
  FJSONObject.AddPair('network', Network);
  
  // 更新显示
  UpdateJSONDisplay;
end;

procedure TConfigFixDemoForm.btnResetINIClick(Sender: TObject);
begin
  // 清空INI数据
  FINIFile.Clear;
  UpdateINIGrid;
  StatusBar.SimpleText := 'INI数据已重置。';
end;

procedure TConfigFixDemoForm.btnResetJSONClick(Sender: TObject);
begin
  // 清空JSON数据
  FJSONObject.Free;
  FJSONObject := TJSONObject.Create;
  UpdateJSONDisplay;
  StatusBar.SimpleText := 'JSON数据已重置。';
end;

procedure TConfigFixDemoForm.btnValidateINIClick(Sender: TObject);
var
  Section, Key, Value: string;
  Row: Integer;
  HasErrors: Boolean;
begin
  // 清除验证结果
  FValidator.ClearResults;
  
  // 重置状态列
  for Row := 1 to sgINI.RowCount - 1 do
    sgINI.Cells[3, Row] := '';
  
  // 验证所有INI值
  HasErrors := False;
  
  for Row := 1 to sgINI.RowCount - 1 do
  begin
    if (sgINI.Cells[0, Row] <> '') and (sgINI.Cells[1, Row] <> '') then
    begin
      Section := sgINI.Cells[0, Row];
      Key := sgINI.Cells[1, Row];
      Value := sgINI.Cells[2, Row];
      
      if not FValidator.ValidateINI(Section, Key, Value) then
      begin
        // 标记错误
        sgINI.Cells[3, Row] := '错误';
        HasErrors := True;
      end
      else
      begin
        // 标记正确
        sgINI.Cells[3, Row] := '正确';
      end;
    end;
  end;
  
  // 显示验证结果
  if HasErrors then
  begin
    StatusBar.SimpleText := '验证完成，发现错误。';
    DisplayValidationResults;
  end
  else
  begin
    StatusBar.SimpleText := '验证完成，未发现错误。';
    ShowMessage('所有配置项验证通过！');
  end;
end;

procedure TConfigFixDemoForm.btnValidateJSONClick(Sender: TObject);
var
  JsonStr: string;
  JSONRoot, ChildObj: TJSONObject;
  Pair: TJSONPair;
  I: Integer;
  HasErrors: Boolean;
begin
  // 清除验证结果
  FValidator.ClearResults;
  
  // 从文本框获取JSON
  JsonStr := memJSON.Text;
  
  // 更新FJSONObject
  try
    JSONRoot := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
    if Assigned(JSONRoot) then
    begin
      FJSONObject.Free;
      FJSONObject := JSONRoot;
    end
    else
    begin
      ShowMessage('JSON解析错误');
      Exit;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('JSON解析错误: ' + E.Message);
      Exit;
    end;
  end;
  
  // 验证所有JSON值
  HasErrors := False;
  
  // 递归函数验证JSON对象
  function ValidateJSONObject(const BasePath: string; Obj: TJSONObject): Boolean;
  var
    I: Integer;
    Pair: TJSONPair;
    ChildPath: string;
    Result: Boolean;
  begin
    Result := True;
    
    for I := 0 to Obj.Count - 1 do
    begin
      Pair := Obj.Pairs[I];
      
      if BasePath = '' then
        ChildPath := Pair.JsonString.Value
      else
        ChildPath := BasePath + '/' + Pair.JsonString.Value;
      
      // 如果是子对象，递归验证
      if Pair.JsonValue is TJSONObject then
      begin
        if not ValidateJSONObject(ChildPath, Pair.JsonValue as TJSONObject) then
          Result := False;
      end
      else
      begin
        // 验证值
        var ValueStr := '';
        if Pair.JsonValue is TJSONString then
          ValueStr := TJSONString(Pair.JsonValue).Value
        else
          ValueStr := Pair.JsonValue.ToString;
          
        if not FValidator.ValidateINI(ChildPath, Pair.JsonString.Value, ValueStr) then
          Result := False;
      end;
    end;
    
    Result := Result;
  end;
  
  // 开始验证JSON
  if not ValidateJSONObject('', FJSONObject) then
    HasErrors := True;
  
  // 显示验证结果
  if HasErrors then
  begin
    StatusBar.SimpleText := '验证完成，发现错误。';
    DisplayValidationResults;
  end
  else
  begin
    StatusBar.SimpleText := '验证完成，未发现错误。';
    ShowMessage('所有配置项验证通过！');
  end;
end;

procedure TConfigFixDemoForm.btnFixINIClick(Sender: TObject);
var
  Section, Key, Value, Path, FixedValue: string;
  Row: Integer;
  FixCount: Integer;
begin
  FixCount := 0;
  
  // 尝试修复所有INI值
  for Row := 1 to sgINI.RowCount - 1 do
  begin
    if (sgINI.Cells[0, Row] <> '') and (sgINI.Cells[1, Row] <> '') then
    begin
      Section := sgINI.Cells[0, Row];
      Key := sgINI.Cells[1, Row];
      Value := sgINI.Cells[2, Row];
      Path := CreateINIPropertyPath(Section, Key);
      
      // 尝试自动修复
      if FValidator.TryAutoFix(Path, Key, Value, FixedValue) then
      begin
        // 更新值
        sgINI.Cells[2, Row] := FixedValue;
        FINIFile.WriteString(Section, Key, FixedValue);
        sgINI.Cells[3, Row] := '已修复';
        Inc(FixCount);
      end;
    end;
  end;
  
  // 更新状态
  if FixCount > 0 then
    StatusBar.SimpleText := Format('已自动修复 %d 个配置项。点击"验证"按钮检查结果。', [FixCount])
  else
    StatusBar.SimpleText := '没有配置项可以自动修复。';
end;

procedure TConfigFixDemoForm.btnFixJSONClick(Sender: TObject);
var
  FixCount: Integer;
  
  // 递归函数修复JSON对象
  function FixJSONObject(const BasePath: string; Obj: TJSONObject): Integer;
  var
    I: Integer;
    Pair: TJSONPair;
    ChildPath: string;
    FixedValue: string;
    FixCounter: Integer;
  begin
    FixCounter := 0;
    
    for I := 0 to Obj.Count - 1 do
    begin
      Pair := Obj.Pairs[I];
      
      if BasePath = '' then
        ChildPath := Pair.JsonString.Value
      else
        ChildPath := BasePath + '/' + Pair.JsonString.Value;
      
      // 如果是子对象，递归修复
      if Pair.JsonValue is TJSONObject then
      begin
        FixCounter := FixCounter + FixJSONObject(ChildPath, Pair.JsonValue as TJSONObject);
      end
      else
      begin
        // 尝试自动修复
        var ValueStr := '';
        if Pair.JsonValue is TJSONString then
          ValueStr := TJSONString(Pair.JsonValue).Value
        else
          ValueStr := Pair.JsonValue.ToString;
          
        if FValidator.TryAutoFix(ChildPath, Pair.JsonString.Value, ValueStr, FixedValue) then
        begin
          // 更新值
          if Pair.JsonValue is TJSONString then
          begin
            Obj.RemovePair(Pair.JsonString.Value).Free;
            Obj.AddPair(Pair.JsonString.Value, FixedValue);
          end;
          Inc(FixCounter);
        end;
      end;
    end;
    
    Result := FixCounter;
  end;
  
begin
  // 开始修复JSON
  FixCount := FixJSONObject('', FJSONObject);
  
  // 更新显示
  UpdateJSONDisplay;
  
  // 更新状态
  if FixCount > 0 then
    StatusBar.SimpleText := Format('已自动修复 %d 个配置项。点击"验证"按钮检查结果。', [FixCount])
  else
    StatusBar.SimpleText := '没有配置项可以自动修复。';
end;

procedure TConfigFixDemoForm.DisplayValidationResults;
var
  I: Integer;
  Results: TValidationResultList;
  Result: TValidationResult;
begin
  // 创建验证结果列表
  Results := TValidationResultList.Create;
  
  // 添加验证结果
  for I := 0 to FValidator.Results.Count - 1 do
  begin
    var ValidationResult := FValidator.Results[I];
    var CanFix := False;
    var FixedValue: string;
    
    // 检查是否可以自动修复
    CanFix := FValidator.TryAutoFix(ValidationResult.PropertyPath, ValidationResult.PropertyName, '', FixedValue);
    
    // 添加到结果列表
    Results.AddErrorWithFix(
      ValidationResult.PropertyPath,
      ValidationResult.PropertyName,
      ValidationResult.ErrorMessage,
      ValidationResult.FixSuggestion,
      CanFix
    );
  end;
  
  // 显示验证对话框
  FValidationDialog.ShowResults(Results);
  
  // 清理
  Results.Free;
end;

procedure TConfigFixDemoForm.SelectProperty(const Path, Name: string);
var
  Section, Key: string;
  Row: Integer;
  Pos: Integer;
begin
  // 解析路径
  Pos := Path.IndexOf('/');
  if Pos > 0 then
  begin
    Section := Path.Substring(0, Pos);
    Key := Path.Substring(Pos + 1);
  end
  else
  begin
    Section := Path;
    Key := Name;
  end;
  
  // 对于INI值，在表格中查找并选择
  if PageControl1.ActivePage = tsINI then
  begin
    for Row := 1 to sgINI.RowCount - 1 do
    begin
      if (sgINI.Cells[0, Row] = Section) and (sgINI.Cells[1, Row] = Key) then
      begin
        sgINI.Row := Row;
        Break;
      end;
    end;
  end
  else if PageControl1.ActivePage = tsJSON then
  begin
    // 对于JSON，目前只能提示用户
    StatusBar.SimpleText := Format('请在JSON中查找并修正: %s -> %s', [Path, Name]);
  end;
end;

procedure TConfigFixDemoForm.FixProperty(const Path, Name: string);
var
  Section, Key, Value, FixedValue: string;
  Row: Integer;
  Pos: Integer;
  Fixed: Boolean;
begin
  Fixed := False;
  
  // 解析路径
  Pos := Path.IndexOf('/');
  if Pos > 0 then
  begin
    Section := Path.Substring(0, Pos);
    Key := Path.Substring(Pos + 1);
  end
  else
  begin
    Section := Path;
    Key := Name;
  end;
  
  // 对于INI值，在表格中查找并修复
  if PageControl1.ActivePage = tsINI then
  begin
    for Row := 1 to sgINI.RowCount - 1 do
    begin
      if (sgINI.Cells[0, Row] = Section) and (sgINI.Cells[1, Row] = Key) then
      begin
        Value := sgINI.Cells[2, Row];
        
        // 尝试自动修复
        if FValidator.TryAutoFix(Path, Name, Value, FixedValue) then
        begin
          // 更新值
          sgINI.Cells[2, Row] := FixedValue;
          FINIFile.WriteString(Section, Key, FixedValue);
          sgINI.Cells[3, Row] := '已修复';
          Fixed := True;
        end;
        
        Break;
      end;
    end;
  end
  else if PageControl1.ActivePage = tsJSON then
  begin
    // 对于JSON，尝试查找并修复对应的值
    
    // 递归函数修复JSON对象中的特定值
    function TryFixJSONProperty(const BasePath: string; Obj: TJSONObject; const TargetPath, TargetName: string): Boolean;
    var
      I: Integer;
      Pair: TJSONPair;
      ChildPath: string;
    begin
      Result := False;
      
      for I := 0 to Obj.Count - 1 do
      begin
        Pair := Obj.Pairs[I];
        
        if BasePath = '' then
          ChildPath := Pair.JsonString.Value
        else
          ChildPath := BasePath + '/' + Pair.JsonString.Value;
        
        // 检查是否是目标路径
        if (ChildPath = TargetPath) and (Pair.JsonString.Value = TargetName) then
        begin
          // 找到了目标，尝试修复
          var ValueStr := '';
          if Pair.JsonValue is TJSONString then
            ValueStr := TJSONString(Pair.JsonValue).Value
          else
            ValueStr := Pair.JsonValue.ToString;
            
          if FValidator.TryAutoFix(TargetPath, TargetName, ValueStr, FixedValue) then
          begin
            // 更新值
            if Pair.JsonValue is TJSONString then
            begin
              Obj.RemovePair(Pair.JsonString.Value).Free;
              Obj.AddPair(Pair.JsonString.Value, FixedValue);
              Result := True;
            end;
          end;
          
          Exit;
        end
        
        // 如果是子对象，递归查找
        else if Pair.JsonValue is TJSONObject then
        begin
          if TryFixJSONProperty(ChildPath, Pair.JsonValue as TJSONObject, TargetPath, TargetName) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
    
    // 尝试修复
    if TryFixJSONProperty('', FJSONObject, Path, Name) then
    begin
      // 修复成功，更新显示
      UpdateJSONDisplay;
      Fixed := True;
    end;
  end;
  
  // 更新状态
  if Fixed then
    StatusBar.SimpleText := '已自动修复配置项。点击"验证"按钮检查结果。'
  else
    StatusBar.SimpleText := '无法自动修复该配置项。';
end;

function TConfigFixDemoForm.CreateINIPropertyPath(const Section, Key: string): string;
begin
  Result := Section + '/' + Key;
end;

procedure TConfigFixDemoForm.UpdateINIGrid;
var
  Sections: TStringList;
  Keys: TStringList;
  I, J, Row: Integer;
begin
  // 清空表格数据（保留标题行）
  sgINI.RowCount := 2;
  for I := 0 to sgINI.ColCount - 1 do
    sgINI.Cells[I, 1] := '';
  
  // 获取所有节
  Sections := TStringList.Create;
  try
    FINIFile.ReadSections(Sections);
    
    // 如果没有数据，直接返回
    if Sections.Count = 0 then
      Exit;
    
    // 计算需要的行数
    Row := 1;
    for I := 0 to Sections.Count - 1 do
    begin
      Keys := TStringList.Create;
      try
        FINIFile.ReadSection(Sections[I], Keys);
        Row := Row + Keys.Count;
      finally
        Keys.Free;
      end;
    end;
    
    // 设置行数
    sgINI.RowCount := Row;
    
    // 填充表格
    Row := 1;
    for I := 0 to Sections.Count - 1 do
    begin
      Keys := TStringList.Create;
      try
        FINIFile.ReadSection(Sections[I], Keys);
        
        for J := 0 to Keys.Count - 1 do
        begin
          sgINI.Cells[0, Row] := Sections[I];
          sgINI.Cells[1, Row] := Keys[J];
          sgINI.Cells[2, Row] := FINIFile.ReadString(Sections[I], Keys[J], '');
          sgINI.Cells[3, Row] := '';
          Inc(Row);
        end;
      finally
        Keys.Free;
      end;
    end;
  finally
    Sections.Free;
  end;
end;

procedure TConfigFixDemoForm.UpdateJSONDisplay;
begin
  // 更新JSON显示
  if Assigned(FJSONObject) then
    memJSON.Text := FJSONObject.Format(2)
  else
    memJSON.Text := '';
end;

end. 