unit FrameListEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigFrameBase, ConfigTypes, Vcl.Buttons;

type
  TFrameListEditor = class(TBaseConfigFrame)
  private
    pnlMain: TPanel;
    lstItems: TListBox;
    pnlControls: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnMoveUp: TSpeedButton;
    btnMoveDown: TSpeedButton;
    
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure lstItemsClick(Sender: TObject);
    procedure UpdateButtonStates;
  protected
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TFrameListEditor }

constructor TFrameListEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
end;

destructor TFrameListEditor.Destroy;
begin
  // 清理资源
  inherited;
end;

procedure TFrameListEditor.CreateControls;
begin
  // 创建主面板
  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  
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
  btnAdd.Width := 80;
  btnAdd.Caption := '添加';
  btnAdd.OnClick := btnAddClick;
  
  // 编辑按钮
  btnEdit := TButton.Create(pnlControls);
  btnEdit.Parent := pnlControls;
  btnEdit.Left := 90;
  btnEdit.Top := 5;
  btnEdit.Width := 80;
  btnEdit.Caption := '编辑';
  btnEdit.OnClick := btnEditClick;
  btnEdit.Enabled := False;
  
  // 删除按钮
  btnDelete := TButton.Create(pnlControls);
  btnDelete.Parent := pnlControls;
  btnDelete.Left := 175;
  btnDelete.Top := 5;
  btnDelete.Width := 80;
  btnDelete.Caption := '删除';
  btnDelete.OnClick := btnDeleteClick;
  btnDelete.Enabled := False;
  
  // 上移按钮
  btnMoveUp := TSpeedButton.Create(pnlControls);
  btnMoveUp.Parent := pnlControls;
  btnMoveUp.Left := 260;
  btnMoveUp.Top := 5;
  btnMoveUp.Width := 25;
  btnMoveUp.Height := 25;
  btnMoveUp.Caption := '↑';
  btnMoveUp.OnClick := btnMoveUpClick;
  btnMoveUp.Enabled := False;
  
  // 下移按钮
  btnMoveDown := TSpeedButton.Create(pnlControls);
  btnMoveDown.Parent := pnlControls;
  btnMoveDown.Left := 290;
  btnMoveDown.Top := 5;
  btnMoveDown.Width := 25;
  btnMoveDown.Height := 25;
  btnMoveDown.Caption := '↓';
  btnMoveDown.OnClick := btnMoveDownClick;
  btnMoveDown.Enabled := False;
end;

procedure TFrameListEditor.UpdateButtonStates;
begin
  // 更新按钮状态
  btnEdit.Enabled := lstItems.ItemIndex >= 0;
  btnDelete.Enabled := lstItems.ItemIndex >= 0;
  btnMoveUp.Enabled := lstItems.ItemIndex > 0;
  btnMoveDown.Enabled := (lstItems.ItemIndex >= 0) and (lstItems.ItemIndex < lstItems.Items.Count - 1);
end;

procedure TFrameListEditor.lstItemsClick(Sender: TObject);
begin
  UpdateButtonStates;
end;

procedure TFrameListEditor.btnAddClick(Sender: TObject);
var
  NewItem: string;
begin
  // 添加新项目
  if InputQuery('添加列表项', '请输入新的列表项:', NewItem) then
  begin
    lstItems.Items.Add(NewItem);
    lstItems.ItemIndex := lstItems.Items.Count - 1;
    UpdateButtonStates;
    Modified := True;
  end;
end;

procedure TFrameListEditor.btnEditClick(Sender: TObject);
var
  EditItem: string;
begin
  // 编辑选中的项目
  if lstItems.ItemIndex >= 0 then
  begin
    EditItem := lstItems.Items[lstItems.ItemIndex];
    if InputQuery('编辑列表项', '请编辑列表项:', EditItem) then
    begin
      lstItems.Items[lstItems.ItemIndex] := EditItem;
      Modified := True;
    end;
  end;
end;

procedure TFrameListEditor.btnDeleteClick(Sender: TObject);
begin
  // 删除选中的项目
  if lstItems.ItemIndex >= 0 then
  begin
    if MessageDlg('确定要删除选中的列表项吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lstItems.Items.Delete(lstItems.ItemIndex);
      UpdateButtonStates;
      Modified := True;
    end;
  end;
end;

procedure TFrameListEditor.btnMoveUpClick(Sender: TObject);
var
  SelectedIndex: Integer;
  TempItem: string;
begin
  // 上移选中的项目
  SelectedIndex := lstItems.ItemIndex;
  if SelectedIndex > 0 then
  begin
    TempItem := lstItems.Items[SelectedIndex];
    lstItems.Items.Delete(SelectedIndex);
    lstItems.Items.Insert(SelectedIndex - 1, TempItem);
    lstItems.ItemIndex := SelectedIndex - 1;
    UpdateButtonStates;
    Modified := True;
  end;
end;

procedure TFrameListEditor.btnMoveDownClick(Sender: TObject);
var
  SelectedIndex: Integer;
  TempItem: string;
begin
  // 下移选中的项目
  SelectedIndex := lstItems.ItemIndex;
  if (SelectedIndex >= 0) and (SelectedIndex < lstItems.Items.Count - 1) then
  begin
    TempItem := lstItems.Items[SelectedIndex];
    lstItems.Items.Delete(SelectedIndex);
    lstItems.Items.Insert(SelectedIndex + 1, TempItem);
    lstItems.ItemIndex := SelectedIndex + 1;
    UpdateButtonStates;
    Modified := True;
  end;
end;

procedure TFrameListEditor.LoadFromJSON;
var
  Value, Item: TJSONValue;
  Items: TJSONArray;
  i: Integer;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 加载列表信息
  Value := JSONObject.GetValue('value');
  if Assigned(Value) and (Value is TJSONArray) then
  begin
    Items := TJSONArray(Value);
    
    // 清空现有列表
    lstItems.Items.Clear;
    
    // 添加所有项目
    for i := 0 to Items.Count - 1 do
    begin
      Item := Items.Items[i];
      if Item is TJSONString then
        lstItems.Items.Add(TJSONString(Item).Value)
      else if Item <> nil then
        lstItems.Items.Add(Item.ToString);
    end;
    
    // 如果有项目，选中第一个
    if lstItems.Items.Count > 0 then
      lstItems.ItemIndex := 0;
      
    // 更新按钮状态
    UpdateButtonStates;
  end;
end;

procedure TFrameListEditor.SaveToJSON;
var
  i: Integer;
  Items: TJSONArray;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // 保存类型信息
  if JSONObject.GetValue('_type') = nil then
    JSONObject.AddPair('_type', 'etList');
    
  // 创建或清空列表
  if JSONObject.GetValue('value') <> nil then
  begin
    if JSONObject.GetValue('value') is TJSONArray then
      Items := TJSONArray(JSONObject.GetValue('value'))
    else
    begin
      JSONObject.RemovePair('value');
      Items := TJSONArray.Create;
      JSONObject.AddPair('value', Items);
    end;
  end
  else
  begin
    Items := TJSONArray.Create;
    JSONObject.AddPair('value', Items);
  end;
  
  // 清空现有数组
  while Items.Count > 0 do
    Items.Remove(0);
  
  // 添加所有列表项
  for i := 0 to lstItems.Items.Count - 1 do
    Items.Add(lstItems.Items[i]);
end;

end. 