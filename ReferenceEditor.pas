unit ReferenceEditor;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, System.JSON, JSONHelpers, Vcl.Grids, Vcl.ValEdit,
  ConfigManager, System.Generics.Collections, ComplexEditors;

type
  TfrmReferenceEditor = class(TForm)
    pnlMain: TPanel;
    pnlButtons: TPanel;
    pnlContent: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblReferenceType: TLabel;
    lblReferenceTo: TLabel;
    cbbReferenceType: TComboBox;
    lblCurrentReference: TLabel;
    edtCurrentReference: TEdit;
    tvReferences: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbReferenceTypeChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tvReferencesChange(Sender: TObject; Node: TTreeNode);
    procedure tvReferencesDblClick(Sender: TObject);
  private
    FConfigManager: TConfigManager;
    FReferenceType: TConfigType;
    FCurrentReference: string;
    
    procedure SetReferenceType(const Value: TConfigType);
    procedure SetCurrentReference(const Value: string);
    
    procedure LoadReferences;
    procedure InitializeReferenceTypes;
    procedure UpdateUI;
  public
    property ReferenceType: TConfigType read FReferenceType write SetReferenceType;
    property CurrentReference: string read FCurrentReference write SetCurrentReference;
  end;

var
  frmReferenceEditor: TfrmReferenceEditor;

implementation

procedure TfrmReferenceEditor.FormCreate(Sender: TObject);
begin
  // 初始化配置引用类型下拉框
  InitializeReferenceTypes;
  
  FConfigManager := TConfigManager.Create;
  FReferenceType := ctFont;  // 默认类型
  FCurrentReference := '';
  
  UpdateUI;
end;

procedure TfrmReferenceEditor.FormShow(Sender: TObject);
begin
  // 更新UI
  edtCurrentReference.Text := FCurrentReference;
  
  // 设置下拉框选中项
  for var i := 0 to cbbReferenceType.Items.Count - 1 do
  begin
    if SameText(cbbReferenceType.Items[i], ConfigTypeToString(FReferenceType)) then
    begin
      cbbReferenceType.ItemIndex := i;
      Break;
    end;
  end;
  
  // 加载引用列表
  LoadReferences;
end;

procedure TfrmReferenceEditor.InitializeReferenceTypes;
begin
  cbbReferenceType.Items.Clear;
  
  // 添加可以被引用的类型
  cbbReferenceType.Items.Add(ConfigTypeToString(ctFont));
  cbbReferenceType.Items.Add(ConfigTypeToString(ctColor));
  cbbReferenceType.Items.Add(ConfigTypeToString(ctList));
  cbbReferenceType.Items.Add(ConfigTypeToString(ctDatabase));
  
  cbbReferenceType.ItemIndex := 0; // 默认选中第一项
end;

procedure TfrmReferenceEditor.SetReferenceType(const Value: TConfigType);
begin
  if FReferenceType <> Value then
  begin
    FReferenceType := Value;
    
    // 更新UI
    for var i := 0 to cbbReferenceType.Items.Count - 1 do
    begin
      if SameText(cbbReferenceType.Items[i], ConfigTypeToString(FReferenceType)) then
      begin
        cbbReferenceType.ItemIndex := i;
        Break;
      end;
    end;
    
    // 重新加载引用列表
    LoadReferences;
  end;
end;

procedure TfrmReferenceEditor.SetCurrentReference(const Value: string);
begin
  FCurrentReference := Value;
  edtCurrentReference.Text := Value;
  
  // 尝试从引用字符串中提取类型
  if Value.StartsWith('_ref:') then
  begin
    var RefString := Copy(Value, 6, Length(Value));
    if RefString.Contains('.') then
    begin
      var TypeStr := Copy(RefString, 1, Pos('.', RefString) - 1);
      FReferenceType := StringToConfigType(TypeStr);
      
      // 更新UI
      for var i := 0 to cbbReferenceType.Items.Count - 1 do
      begin
        if SameText(cbbReferenceType.Items[i], ConfigTypeToString(FReferenceType)) then
        begin
          cbbReferenceType.ItemIndex := i;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmReferenceEditor.cbbReferenceTypeChange(Sender: TObject);
var
  TypeStr: string;
begin
  if cbbReferenceType.ItemIndex >= 0 then
  begin
    TypeStr := cbbReferenceType.Items[cbbReferenceType.ItemIndex];
    FReferenceType := StringToConfigType(TypeStr);
    
    // 重新加载引用列表
    LoadReferences;
  end;
end;

procedure TfrmReferenceEditor.LoadReferences;
var
  RootNode, TypeNode, IdNode: TTreeNode;
  JsonRoot: TJSONObject;
  SelectedNode: TTreeNode;
begin
  tvReferences.Items.Clear;
  SelectedNode := nil; // 初始化为nil避免警告
  
  // 确保配置管理器已初始化
  if not Assigned(FConfigManager) or not Assigned(FConfigManager.JSONConfig) then
    Exit;
    
  // 创建根节点
  RootNode := tvReferences.Items.AddChild(nil, '可用引用');
  
  try
    // 获取JSON配置根对象
    JsonRoot := FConfigManager.JSONConfig.RootObject;
    if not Assigned(JsonRoot) then
      Exit;
      
    // 遍历根对象寻找特定类型的配置项
    for var i := 0 to JsonRoot.Count - 1 do
    begin
      var CategoryName := JsonRoot.Pairs[i].JsonString.Value;
      var CategoryValue := JsonRoot.Pairs[i].JsonValue;
      
      if CategoryValue is TJSONObject then
      begin
        // 添加分类节点
        TypeNode := tvReferences.Items.AddChild(RootNode, CategoryName);
        
        var CategoryObj := TJSONObject(CategoryValue);
        for var j := 0 to CategoryObj.Count - 1 do
        begin
          var ItemName := CategoryObj.Pairs[j].JsonString.Value;
          var ItemValue := CategoryObj.Pairs[j].JsonValue;
          
          if ItemValue is TJSONObject then
          begin
            var ItemObj := TJSONObject(ItemValue);
            var TypeValue := ItemObj.GetValue('_type');
            var IdValue := ItemObj.GetValue('_id');
            
            // 如果是目标类型，添加到树中
            if Assigned(TypeValue) and (TypeValue is TJSONString) and
               SameText(TJSONString(TypeValue).Value, ConfigTypeToString(FReferenceType)) and
               Assigned(IdValue) and (IdValue is TJSONString) then
            begin
              IdNode := tvReferences.Items.AddChild(TypeNode, TJSONString(IdValue).Value);
              
              // 如果当前引用匹配此ID，则选中该节点
              if FCurrentReference.StartsWith('_ref:') and 
                 FCurrentReference.EndsWith(TJSONString(IdValue).Value) then
              begin
                SelectedNode := IdNode;
              end;
            end;
          end;
        end;
      end;
    end;
    
    // 展开根节点
    RootNode.Expand(True);
    
    // 如果找到了匹配节点，选中它
    if Assigned(SelectedNode) then
    begin
      tvReferences.Selected := SelectedNode;
      SelectedNode.MakeVisible;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('加载引用列表时出错: ' + E.Message);
    end;
  end;
end;

procedure TfrmReferenceEditor.UpdateUI;
begin
  // 更新UI元素
  lblCurrentReference.Caption := '当前引用: ' + FCurrentReference;
end;

procedure TfrmReferenceEditor.tvReferencesChange(Sender: TObject; Node: TTreeNode);
begin
  // 当选择的节点改变时，更新当前引用
  if Assigned(Node) and (Node.Level = 2) then
  begin
    // 节点级别为2表示它是ID节点 (根 -> 分类 -> ID)
    FCurrentReference := '_ref:' + ConfigTypeToString(FReferenceType) + '.' + Node.Text;
    edtCurrentReference.Text := FCurrentReference;
  end;
end;

procedure TfrmReferenceEditor.tvReferencesDblClick(Sender: TObject);
begin
  // 双击时，如果选中了有效引用，则确认选择
  if (tvReferences.Selected <> nil) and (tvReferences.Selected.Level = 2) then
    btnOKClick(Sender);
end;

procedure TfrmReferenceEditor.btnOKClick(Sender: TObject);
begin
  // 验证输入
  if Trim(edtCurrentReference.Text) = '' then
  begin
    ShowMessage('请选择或输入引用');
    edtCurrentReference.SetFocus;
    Exit;
  end;
  
  // 更新当前引用
  FCurrentReference := edtCurrentReference.Text;
  
  ModalResult := mrOk;
end;

procedure TfrmReferenceEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end. 

