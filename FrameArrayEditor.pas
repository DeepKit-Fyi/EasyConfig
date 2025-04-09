unit FrameArrayEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.UITypes, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, 
  Vcl.Dialogs, Vcl.Grids, ConfigFrameBase, ConfigTypes;

type
  TArrayItemType = (aitString, aitNumber, aitBoolean, aitObject);

  TFrameArrayEditor = class(TBaseConfigFrame)
  private
    pnlMain: TPanel;
    lstItems: TListBox;
    pnlControls: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    lblItemType: TLabel;
    cmbItemType: TComboBox;
    
    FItemType: TArrayItemType;
    FObjectItems: TList<TJSONObject>;
    
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure lstItemsClick(Sender: TObject);
    procedure cmbItemTypeChange(Sender: TObject);
    procedure UpdateButtonStates;
    function GetItemTypeAsString(ItemType: TArrayItemType): string;
    function GetItemTypeFromString(const TypeStr: string): TArrayItemType;
  protected
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    property ItemType: TArrayItemType read FItemType write FItemType;
  end;

implementation

{ TFrameArrayEditor }

constructor TFrameArrayEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemType := aitString;
  FObjectItems := TList<TJSONObject>.Create;
  CreateControls;
end;

destructor TFrameArrayEditor.Destroy;
begin
  FObjectItems.Free;
  inherited;
end;

procedure TFrameArrayEditor.CreateControls;
begin
  // 创建主面板
  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  
  // 创建类型选择面板
  var TypePanel := TPanel.Create(pnlMain);
  TypePanel.Parent := pnlMain;
  TypePanel.Align := alTop;
  TypePanel.Height := 40;
  TypePanel.BevelOuter := bvNone;
  
  // 创建类型标签
  lblItemType := TLabel.Create(TypePanel);
  lblItemType.Parent := TypePanel;
  lblItemType.Left := 10;
  lblItemType.Top := 12;
  lblItemType.Caption := '数组项类型:';
  
  // 创建类型下拉框
  cmbItemType := TComboBox.Create(TypePanel);
  cmbItemType.Parent := TypePanel;
  cmbItemType.Left := 100;
  cmbItemType.Top := 8;
  cmbItemType.Width := 150;
  cmbItemType.Style := csDropDownList;
  cmbItemType.Items.Add('字符串');
  cmbItemType.Items.Add('数值');
  cmbItemType.Items.Add('布尔值');
  cmbItemType.Items.Add('对象');
  cmbItemType.ItemIndex := 0;
  cmbItemType.OnChange := cmbItemTypeChange;
  
  // 创建列表控件
  lstItems := TListBox.Create(pnlMain);
  lstItems.Parent := pnlMain;
  lstItems.Align := alClient;
  lstItems.AlignWithMargins := True;
  lstItems.Margins.SetBounds(5, 5, 5, 5);
  lstItems.OnClick := lstItemsClick;
  
  // 创建控制面板
  pnlControls := TPanel.Create(pnlMain);
  pnlControls.Parent := pnlMain;
  pnlControls.Align := alBottom;
  pnlControls.Height := 40;
  pnlControls.BevelOuter := bvNone;
  
  // 添加按钮
  btnAdd := TButton.Create(pnlControls);
  btnAdd.Parent := pnlControls;
  btnAdd.Left := 5;
  btnAdd.Top := 5;
  btnAdd.Width := 60;
  btnAdd.Caption := '添加';
  btnAdd.OnClick := btnAddClick;
  
  // 编辑按钮
  btnEdit := TButton.Create(pnlControls);
  btnEdit.Parent := pnlControls;
  btnEdit.Left := 70;
  btnEdit.Top := 5;
  btnEdit.Width := 60;
  btnEdit.Caption := '编辑';
  btnEdit.OnClick := btnEditClick;
  btnEdit.Enabled := False;
  
  // 删除按钮
  btnDelete := TButton.Create(pnlControls);
  btnDelete.Parent := pnlControls;
  btnDelete.Left := 135;
  btnDelete.Top := 5;
  btnDelete.Width := 60;
  btnDelete.Caption := '删除';
  btnDelete.OnClick := btnDeleteClick;
  btnDelete.Enabled := False;
  
  // 上移按钮
  btnMoveUp := TButton.Create(pnlControls);
  btnMoveUp.Parent := pnlControls;
  btnMoveUp.Left := 200;
  btnMoveUp.Top := 5;
  btnMoveUp.Width := 60;
  btnMoveUp.Caption := '上移';
  btnMoveUp.OnClick := btnMoveUpClick;
  btnMoveUp.Enabled := False;
  
  // 下移按钮
  btnMoveDown := TButton.Create(pnlControls);
  btnMoveDown.Parent := pnlControls;
  btnMoveDown.Left := 265;
  btnMoveDown.Top := 5;
  btnMoveDown.Width := 60;
  btnMoveDown.Caption := '下移';
  btnMoveDown.OnClick := btnMoveDownClick;
  btnMoveDown.Enabled := False;
end;

procedure TFrameArrayEditor.cmbItemTypeChange(Sender: TObject);
begin
  // 更新数组项类型
  case cmbItemType.ItemIndex of
    0: FItemType := aitString;
    1: FItemType := aitNumber;
    2: FItemType := aitBoolean;
    3: FItemType := aitObject;
  else
    FItemType := aitString;
  end;
  
  // 清空列表
  if lstItems.Items.Count > 0 then
  begin
    if MessageDlg('更改数组项类型将清空当前列表，是否继续?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lstItems.Items.Clear;
      FObjectItems.Clear;
    end
    else
    begin
      // 恢复原来的选择
      case FItemType of
        aitString: cmbItemType.ItemIndex := 0;
        aitNumber: cmbItemType.ItemIndex := 1;
        aitBoolean: cmbItemType.ItemIndex := 2;
        aitObject: cmbItemType.ItemIndex := 3;
      end;
    end;
  end;
  
  // 更新按钮状态
  UpdateButtonStates;
  
  // 标记为已修改
  Modified := True;
end;

procedure TFrameArrayEditor.UpdateButtonStates;
begin
  // 更新按钮状态
  btnEdit.Enabled := lstItems.ItemIndex >= 0;
  btnDelete.Enabled := lstItems.ItemIndex >= 0;
  btnMoveUp.Enabled := lstItems.ItemIndex > 0;
  btnMoveDown.Enabled := (lstItems.ItemIndex >= 0) and (lstItems.ItemIndex < lstItems.Items.Count - 1);
end;

procedure TFrameArrayEditor.lstItemsClick(Sender: TObject);
begin
  UpdateButtonStates;
end;

procedure TFrameArrayEditor.btnAddClick(Sender: TObject);
var
  NewItem: string;
  Value: Double;
  JSONObj: TJSONObject;
  BoolValue: Boolean;
begin
  case FItemType of
    aitString:
      begin
        // 添加字符串项
        NewItem := '';
        if InputQuery('添加字符串', '请输入字符串值:', NewItem) then
        begin
          lstItems.Items.Add(NewItem);
          Modified := True;
        end;
      end;
    aitNumber:
      begin
        // 添加数值项
        NewItem := '0';
        if InputQuery('添加数值', '请输入数值:', NewItem) then
        begin
          try
            Value := StrToFloat(NewItem);
            lstItems.Items.Add(NewItem);
            Modified := True;
          except
            on E: Exception do
              ShowMessage('请输入有效的数值');
          end;
        end;
      end;
    aitBoolean:
      begin
        // 添加布尔项
        if MessageDlg('请选择布尔值', mtConfirmation, mbYesNo, 0) = mrYes then
        begin
          BoolValue := True;
          lstItems.Items.Add('True');
        end
        else
        begin
          BoolValue := False;
          lstItems.Items.Add('False');
        end;
        Modified := True;
      end;
    aitObject:
      begin
        // 添加对象项
        JSONObj := TJSONObject.Create;
        FObjectItems.Add(JSONObj);
        lstItems.Items.Add(Format('对象 %d', [FObjectItems.Count]));
        Modified := True;
      end;
  end;
  
  // 更新按钮状态
  UpdateButtonStates;
end;

procedure TFrameArrayEditor.btnEditClick(Sender: TObject);
var
  SelectedIndex: Integer;
  OldValue, NewValue: string;
  JSONObj: TJSONObject;
  DValue: Double;
  BoolValue: Boolean;
begin
  SelectedIndex := lstItems.ItemIndex;
  if SelectedIndex < 0 then
    Exit;
  
  case FItemType of
    aitString:
      begin
        // 编辑字符串项
        OldValue := lstItems.Items[SelectedIndex];
        NewValue := OldValue;
        if InputQuery('编辑字符串', '请输入字符串值:', NewValue) then
        begin
          lstItems.Items[SelectedIndex] := NewValue;
          Modified := True;
        end;
      end;
    aitNumber:
      begin
        // 编辑数值项
        OldValue := lstItems.Items[SelectedIndex];
        NewValue := OldValue;
        if InputQuery('编辑数值', '请输入数值:', NewValue) then
        begin
          try
            DValue := StrToFloat(NewValue);
            lstItems.Items[SelectedIndex] := NewValue;
            Modified := True;
          except
            on E: Exception do
              ShowMessage('请输入有效的数值');
          end;
        end;
      end;
    aitBoolean:
      begin
        // 编辑布尔项
        OldValue := lstItems.Items[SelectedIndex];
        BoolValue := SameText(OldValue, 'True');
        
        if MessageDlg('编辑布尔值', mtConfirmation, mbYesNo, 0) = mrYes then
        begin
          if not BoolValue then
          begin
            lstItems.Items[SelectedIndex] := 'True';
            Modified := True;
          end;
        end
        else
        begin
          if BoolValue then
          begin
            lstItems.Items[SelectedIndex] := 'False';
            Modified := True;
          end;
        end;
      end;
    aitObject:
      begin
        // 编辑对象项
        if (SelectedIndex >= 0) and (SelectedIndex < FObjectItems.Count) then
        begin
          JSONObj := FObjectItems[SelectedIndex];
          // 使用对象编辑器编辑对象
          // 这里应该打开一个对话框让用户编辑JSON对象
          // 简单起见，我们只是将对象转换为字符串显示
          ShowMessage(JSONObj.ToString);
          Modified := True;
        end;
      end;
  end;
end;

procedure TFrameArrayEditor.btnDeleteClick(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  SelectedIndex := lstItems.ItemIndex;
  if SelectedIndex < 0 then
    Exit;
  
  if MessageDlg('确定要删除选定的项目吗?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 如果是对象类型，同时删除对应的JSON对象
    if FItemType = aitObject then
    begin
      if (SelectedIndex >= 0) and (SelectedIndex < FObjectItems.Count) then
      begin
        FObjectItems[SelectedIndex].Free;
        FObjectItems.Delete(SelectedIndex);
      end;
    end;
    
    lstItems.Items.Delete(SelectedIndex);
    Modified := True;
    
    // 更新按钮状态
    UpdateButtonStates;
  end;
end;

procedure TFrameArrayEditor.btnMoveUpClick(Sender: TObject);
var
  SelectedIndex: Integer;
  TempObj: TJSONObject;
begin
  SelectedIndex := lstItems.ItemIndex;
  if (SelectedIndex <= 0) or (SelectedIndex >= lstItems.Items.Count) then
    Exit;
  
  // 交换列表项
  lstItems.Items.Exchange(SelectedIndex, SelectedIndex - 1);
  
  // 如果是对象类型，同时交换JSON对象
  if FItemType = aitObject then
  begin
    if (SelectedIndex < FObjectItems.Count) and (SelectedIndex - 1 >= 0) then
    begin
      TempObj := FObjectItems[SelectedIndex];
      FObjectItems[SelectedIndex] := FObjectItems[SelectedIndex - 1];
      FObjectItems[SelectedIndex - 1] := TempObj;
    end;
  end;
  
  // 选中移动后的项
  lstItems.ItemIndex := SelectedIndex - 1;
  Modified := True;
  
  // 更新按钮状态
  UpdateButtonStates;
end;

procedure TFrameArrayEditor.btnMoveDownClick(Sender: TObject);
var
  SelectedIndex: Integer;
  TempObj: TJSONObject;
begin
  SelectedIndex := lstItems.ItemIndex;
  if (SelectedIndex < 0) or (SelectedIndex >= lstItems.Items.Count - 1) then
    Exit;
  
  // 交换列表项
  lstItems.Items.Exchange(SelectedIndex, SelectedIndex + 1);
  
  // 如果是对象类型，同时交换JSON对象
  if FItemType = aitObject then
  begin
    if (SelectedIndex < FObjectItems.Count) and (SelectedIndex + 1 < FObjectItems.Count) then
    begin
      TempObj := FObjectItems[SelectedIndex];
      FObjectItems[SelectedIndex] := FObjectItems[SelectedIndex + 1];
      FObjectItems[SelectedIndex + 1] := TempObj;
    end;
  end;
  
  // 选中移动后的项
  lstItems.ItemIndex := SelectedIndex + 1;
  Modified := True;
  
  // 更新按钮状态
  UpdateButtonStates;
end;

function TFrameArrayEditor.GetItemTypeAsString(ItemType: TArrayItemType): string;
begin
  case ItemType of
    aitString: Result := 'string';
    aitNumber: Result := 'number';
    aitBoolean: Result := 'boolean';
    aitObject: Result := 'object';
  else
    Result := 'string';
  end;
end;

function TFrameArrayEditor.GetItemTypeFromString(const TypeStr: string): TArrayItemType;
begin
  if SameText(TypeStr, 'string') then
    Result := aitString
  else if SameText(TypeStr, 'number') then
    Result := aitNumber
  else if SameText(TypeStr, 'boolean') then
    Result := aitBoolean
  else if SameText(TypeStr, 'object') then
    Result := aitObject
  else
    Result := aitString;
end;

procedure TFrameArrayEditor.LoadFromJSON;
var
  i: Integer;
  JSONArray: TJSONArray;
  ItemValue: TJSONValue;
  TypeString: string;
  ItemType: TArrayItemType;
  JSONObj: TJSONObject;
begin
  // 清空现有数据
  lstItems.Items.Clear;
  for i := 0 to FObjectItems.Count - 1 do
    FObjectItems[i].Free;
  FObjectItems.Clear;
  
  if not Assigned(JSONObject) then
    Exit;
  
  // 尝试获取数组类型
  if JSONObject.TryGetValue('item_type', TypeString) then
    FItemType := GetItemTypeFromString(TypeString)
  else
    FItemType := aitString;
  
  // 更新类型下拉框
  case FItemType of
    aitString: cmbItemType.ItemIndex := 0;
    aitNumber: cmbItemType.ItemIndex := 1;
    aitBoolean: cmbItemType.ItemIndex := 2;
    aitObject: cmbItemType.ItemIndex := 3;
  else
    cmbItemType.ItemIndex := 0;
  end;
  
  // 获取数组值
  if JSONObject.TryGetValue('value', ItemValue) and (ItemValue is TJSONArray) then
  begin
    JSONArray := TJSONArray(ItemValue);
    
    for i := 0 to JSONArray.Count - 1 do
    begin
      ItemValue := JSONArray.Items[i];
      
      case FItemType of
        aitString:
          if ItemValue is TJSONString then
            lstItems.Items.Add(TJSONString(ItemValue).Value);
        aitNumber:
          if ItemValue is TJSONNumber then
            lstItems.Items.Add(TJSONNumber(ItemValue).ToString);
        aitBoolean:
          if ItemValue is TJSONBool then
            lstItems.Items.Add(BoolToStr(TJSONBool(ItemValue).AsBoolean, True));
        aitObject:
          if ItemValue is TJSONObject then
          begin
            JSONObj := TJSONObject(ItemValue.Clone as TJSONObject);
            FObjectItems.Add(JSONObj);
            lstItems.Items.Add(Format('对象 %d', [FObjectItems.Count]));
          end;
      end;
    end;
  end;
  
  // 更新按钮状态
  UpdateButtonStates;
  Modified := False;
end;

procedure TFrameArrayEditor.SaveToJSON;
var
  i: Integer;
  JSONArray: TJSONArray;
  BValue: Boolean;
  DValue: Double;
begin
  // 确保JSONObject不为空
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
  
  // 设置数组项类型
  JSONObject.RemovePair('item_type');
  JSONObject.AddPair('item_type', GetItemTypeAsString(FItemType));
  
  // 设置配置类型
  JSONObject.RemovePair('_type');
  JSONObject.AddPair('_type', ConfigTypeToString(ctArray));
  
  // 创建数组值
  JSONArray := TJSONArray.Create;
  
  for i := 0 to lstItems.Items.Count - 1 do
  begin
    case FItemType of
      aitString:
        JSONArray.AddElement(TJSONString.Create(lstItems.Items[i]));
      aitNumber:
        begin
          if TryStrToFloat(lstItems.Items[i], DValue) then
            JSONArray.AddElement(TJSONNumber.Create(DValue))
          else
            JSONArray.AddElement(TJSONNumber.Create(0));
        end;
      aitBoolean:
        begin
          BValue := SameText(lstItems.Items[i], 'True');
          JSONArray.AddElement(TJSONBool.Create(BValue));
        end;
      aitObject:
        if (i < FObjectItems.Count) and Assigned(FObjectItems[i]) then
          JSONArray.AddElement(FObjectItems[i].Clone as TJSONObject);
    end;
  end;
  
  // 设置数组值
  JSONObject.RemovePair('value');
  JSONObject.AddPair('value', JSONArray);
  
  Modified := False;
end;

end.
