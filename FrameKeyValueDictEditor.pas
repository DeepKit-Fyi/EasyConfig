unit FrameKeyValueDictEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs, Vcl.Grids,
  ConfigFrameBase, UtilsTypes;

type
  // ֵֵ༭Frame
  TFrameKeyValueDictEditor = class(TBaseConfigFrame)
    pnlMain: TPanel;
    grpKeyValueDict: TGroupBox;
    lblName: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    memDescription: TMemo;
    sg: TStringGrid;
    pnlGridButtons: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnClear: TButton;
    pnlButtons: TPanel;
    btnUpdate: TButton;
    btnCancel: TButton;
    chkKeyValueTypeCheck: TCheckBox;
    cbbValueType: TComboBox;
    lblValueType: TLabel;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure chkKeyValueTypeCheckClick(Sender: TObject);
  private
    // 初始化控件
    procedure InitControls;
    // 初始化字符串网格
    procedure InitStringGrid;
    // 刷新数据
    procedure RefreshData;
    // 验证单元格数据
    function ValidateCell(ACol, ARow: Integer; const Value: string): Boolean;
  protected
    procedure LoadFromJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TFrameKeyValueDictEditor }

constructor TFrameKeyValueDictEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitControls;
end;

destructor TFrameKeyValueDictEditor.Destroy;
begin
  inherited;
end;

procedure TFrameKeyValueDictEditor.CreateControls;
begin
  inherited;
  
  // 在构造函数中使用控件，否则在DFM文件中定义的控件不会被初始化
  // 如果要定义静态控件，请在构造函数中添加
end;

procedure TFrameKeyValueDictEditor.InitControls;
begin
  // 初始化值类型选择
  cbbValueType.Items.Clear;
  cbbValueType.Items.Add('字符串');
  cbbValueType.Items.Add('整数');
  cbbValueType.Items.Add('浮点数');
  cbbValueType.Items.Add('布尔值');
  cbbValueType.Items.Add('日期时间');
  cbbValueType.ItemIndex := 0;
  
  // 初始化字符串网格
  InitStringGrid;
end;

procedure TFrameKeyValueDictEditor.InitStringGrid;
begin
  // 设置网格列标题
  sg.Cells[0, 0] := '键(Key)';
  sg.Cells[1, 0] := '值(Value)';
  sg.Cells[2, 0] := '值类型';
  sg.Cells[3, 0] := '描述';
  
  // 设置网格列宽度
  sg.ColWidths[0] := 120;
  sg.ColWidths[1] := 150;
  sg.ColWidths[2] := 80;
  sg.ColWidths[3] := 180;
  
  // 填充网格数据
  for var I := 1 to sg.RowCount - 1 do
    for var J := 0 to sg.ColCount - 1 do
      sg.Cells[J, I] := '';
  
  // 设置网格行数
  sg.RowCount := 2;
end;

procedure TFrameKeyValueDictEditor.LoadFromJSON;
var
  Items: TJSONArray;
  Item: TJSONObject;
  Row: Integer;
begin
  if not Assigned(JSONObject) then
    Exit;
  
  // 获取根节点
  var Value: TJSONValue;
  
  Value := JSONObject.GetValue('name');
  if Assigned(Value) then
    edtName.Text := Value.Value;
    
  Value := JSONObject.GetValue('description');
  if Assigned(Value) then
    memDescription.Text := Value.Value;
  
  // 是否启用类型检查
  Value := JSONObject.GetValue('enable_type_check');
  if Assigned(Value) and (Value is TJSONBool) then
    chkKeyValueTypeCheck.Checked := (Value as TJSONBool).AsBoolean;
  
  // 默认值类型
  Value := JSONObject.GetValue('default_type');
  if Assigned(Value) then
  begin
    var DefaultType := Value.Value;
    var Index := cbbValueType.Items.IndexOf(DefaultType);
    if Index >= 0 then
      cbbValueType.ItemIndex := Index;
  end;
  
  // 获取值
  Value := JSONObject.GetValue('items');
  if Assigned(Value) and (Value is TJSONArray) then
  begin
    Items := Value as TJSONArray;
    
    // 初始化网格
    InitStringGrid;
    
    if Items.Count > 0 then
    begin
      // 设置网格行数
      sg.RowCount := Items.Count + 1;
      
      // 填充数据
      for var I := 0 to Items.Count - 1 do
      begin
        Row := I + 1;
        Item := Items.Items[I] as TJSONObject;
        
        // 获取值和类型
        var KeyValue := Item.GetValue('key');
        if Assigned(KeyValue) then
          sg.Cells[0, Row] := KeyValue.Value;
        
        var ValueValue := Item.GetValue('value');
        if Assigned(ValueValue) then
          sg.Cells[1, Row] := ValueValue.Value;
        
        var TypeValue := Item.GetValue('type');
        if Assigned(TypeValue) then
          sg.Cells[2, Row] := TypeValue.Value;
        
        var DescValue := Item.GetValue('description');
        if Assigned(DescValue) then
          sg.Cells[3, Row] := DescValue.Value;
      end;
    end;
  end;
  
  // 刷新UI状态
  chkKeyValueTypeCheckClick(nil);
end;

procedure TFrameKeyValueDictEditor.SaveToJSON;
var
  Items: TJSONArray;
  Item: TJSONObject;
begin
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
  
  // 移除旧的类型属性
  JSONObject.RemovePair('_type');
  JSONObject.AddPair('_type', 'etKeyValueDict');
  JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);
  JSONObject.RemovePair('description');
  JSONObject.AddPair('description', memDescription.Text);
  
  // 移除类型检查属性
  JSONObject.RemovePair('enable_type_check');
  JSONObject.AddPair('enable_type_check', TJSONBool.Create(chkKeyValueTypeCheck.Checked));
  
  // 移除默认值属性
  if cbbValueType.ItemIndex >= 0 then
  begin
    JSONObject.RemovePair('default_type');
    JSONObject.AddPair('default_type', cbbValueType.Items[cbbValueType.ItemIndex]);
  end;
  
  // 获取值数组
  Items := TJSONArray.Create;
  
  // 遍历所有数据
  for var I := 1 to sg.RowCount - 1 do
  begin
    // 空行跳过
    if (sg.Cells[0, I] = '') and (sg.Cells[1, I] = '') then
      Continue;
    
    // 创建一个值对象
    Item := TJSONObject.Create;
    Item.AddPair('key', sg.Cells[0, I]);
    Item.AddPair('value', sg.Cells[1, I]);
    Item.AddPair('type', sg.Cells[2, I]);
    Item.AddPair('description', sg.Cells[3, I]);
    
    // 添加到数组
    Items.AddElement(Item);
  end;
  
  // 移除旧的值属性
  JSONObject.RemovePair('items');
  JSONObject.AddPair('items', Items);
  
  // 设置修改标记为false
  Modified := False;
end;

procedure TFrameKeyValueDictEditor.RefreshData;
begin
  // 刷新网格显示
  sg.Refresh;
  // 设置为已修改
  Modified := True;
end;

function TFrameKeyValueDictEditor.ValidateCell(ACol, ARow: Integer; const Value: string): Boolean;
begin
  Result := True;
  
  // 空值
  if (ACol = 0) and (Value = '') then
  begin
    ShowMessage('不能为空');
    Result := False;
    Exit;
  end;
  
  // 类型检查，如果启用，检查值是否符合类型
  if chkKeyValueTypeCheck.Checked and (ACol = 1) and (Value <> '') then
  begin
    // 获取所有值类型
    var TypeStr := sg.Cells[2, ARow];
    if TypeStr = '' then
      TypeStr := cbbValueType.Items[cbbValueType.ItemIndex];
    
    try
      // 类型检查值
      if TypeStr = '整数' then
        StrToInt(Value)
      else if TypeStr = '浮点数' then
        StrToFloat(Value)
      else if TypeStr = '布尔值' then
      begin
        if not ((Value = 'True') or (Value = 'False') or 
               (Value = 'true') or (Value = 'false') or
               (Value = '1') or (Value = '0')) then
          raise Exception.Create('无效的布尔值');
      end
      else if TypeStr = '日期时间' then
        StrToDateTime(Value);
    except
      on E: Exception do
      begin
        ShowMessage('值类型不匹配: ' + E.Message);
        Result := False;
      end;
    end;
  end;
end;

procedure TFrameKeyValueDictEditor.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  // 自动填充所有值
  if (ACol = 2) and (sg.Cells[ACol, ARow] = '') and (cbbValueType.ItemIndex >= 0) then
    sg.Cells[ACol, ARow] := cbbValueType.Items[cbbValueType.ItemIndex];
end;

procedure TFrameKeyValueDictEditor.btnAddClick(Sender: TObject);
begin
  // 添加一行，确保最后一行是空行
  var LastRow := sg.RowCount - 1;
  while (LastRow > 0) and (sg.Cells[0, LastRow] = '') and (sg.Cells[1, LastRow] = '') do
    Dec(LastRow);
  
  // 添加一行，确保最后一行是空行
  if (sg.Cells[0, LastRow] <> '') or (sg.Cells[1, LastRow] <> '') then
  begin
    sg.RowCount := sg.RowCount + 1;
    LastRow := sg.RowCount - 1;
  end;
  
  // 自动填充默认值
  sg.Cells[0, LastRow] := 'key' + IntToStr(LastRow);
  sg.Cells[1, LastRow] := '';
  
  // 自动填充
  if cbbValueType.ItemIndex >= 0 then
    sg.Cells[2, LastRow] := cbbValueType.Items[cbbValueType.ItemIndex]
  else
    sg.Cells[2, LastRow] := '字符串';
  
  sg.Cells[3, LastRow] := '';
  
  // 刷新显示
  RefreshData;
  
  // 选择所有元素
  sg.Row := LastRow;
  sg.Col := 0;
  sg.SetFocus;
end;

procedure TFrameKeyValueDictEditor.btnCancelClick(Sender: TObject);
begin
  if Assigned(Parent) and (Parent is TPanel) then
    TPanel(Parent).Visible := False;
end;

procedure TFrameKeyValueDictEditor.btnClearClick(Sender: TObject);
begin
  // 确认是否清空
  if MessageDlg('确认要清空所有数据吗', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // 清空网格
    InitStringGrid;
    RefreshData;
  end;
end;

procedure TFrameKeyValueDictEditor.btnDeleteClick(Sender: TObject);
var
  Row: Integer;
begin
  Row := sg.Row;
  
  // 选择一行，确保不是空行
  if (Row < 1) or (Row >= sg.RowCount) then
    Exit;
  
  // 删除上一行
  for var I := Row to sg.RowCount - 2 do
    for var J := 0 to sg.ColCount - 1 do
      sg.Cells[J, I] := sg.Cells[J, I + 1];
  
  // 删除最后一行
  for var J := 0 to sg.ColCount - 1 do
    sg.Cells[J, sg.RowCount - 1] := '';
  
  // 确保唯一一行，确保唯一一行
  if sg.RowCount > 2 then
    sg.RowCount := sg.RowCount - 1;
  
  // 刷新显示
  RefreshData;
end;

procedure TFrameKeyValueDictEditor.btnUpdateClick(Sender: TObject);
begin
  // 验证数据
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('不能为空');
    edtName.SetFocus;
    Exit;
  end;
  
  // 验证数据
  for var I := 1 to sg.RowCount - 1 do
  begin
    // 空行跳过
    if (sg.Cells[0, I] = '') and (sg.Cells[1, I] = '') then
      Continue;
    
    // 验证值
    if sg.Cells[0, I] = '' then
    begin
      ShowMessage('第' + IntToStr(I) + '行的键为空');
      sg.Row := I;
      sg.Col := 0;
      sg.SetFocus;
      Exit;
    end;
    
    // 类型检查，确保值是否符合类型
    if chkKeyValueTypeCheck.Checked and (sg.Cells[1, I] <> '') then
    begin
      if not ValidateCell(1, I, sg.Cells[1, I]) then
      begin
        sg.Row := I;
        sg.Col := 1;
        sg.SetFocus;
        Exit;
      end;
    end;
  end;
  
  // 保存数据
  SaveToJSON;
  
  // 设置修改标记
  Modified := True;
  
  // 通知修改
  if Assigned(OnModified) then
    OnModified(Self);
end;

procedure TFrameKeyValueDictEditor.chkKeyValueTypeCheckClick(Sender: TObject);
begin
  // 自动设置类型检查复选框状态
  lblValueType.Enabled := chkKeyValueTypeCheck.Checked;
  cbbValueType.Enabled := chkKeyValueTypeCheck.Checked;
  
  Modified := True;
end;

end.
