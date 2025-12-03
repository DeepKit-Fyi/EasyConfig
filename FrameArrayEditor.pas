unit FrameArrayEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.JSON, System.Generics.Collections, System.UITypes,
  ConfigFrameBase, UtilsTypes, JSONHelpers;

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
  // Create main panel
  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  
  // Create type selection panel
  var TypePanel := TPanel.Create(pnlMain);
  TypePanel.Parent := pnlMain;
  TypePanel.Align := alTop;
  TypePanel.Height := 40;
  TypePanel.BevelOuter := bvNone;
  
  // Create type label
  lblItemType := TLabel.Create(TypePanel);
  lblItemType.Parent := TypePanel;
  lblItemType.Left := 10;
  lblItemType.Top := 12;
  lblItemType.Caption := 'Array Item Type:';
  
  // Create type dropdown
  cmbItemType := TComboBox.Create(TypePanel);
  cmbItemType.Parent := TypePanel;
  cmbItemType.Left := 100;
  cmbItemType.Top := 8;
  cmbItemType.Width := 150;
  cmbItemType.Style := csDropDownList;
  cmbItemType.Items.Add('String');
  cmbItemType.Items.Add('Number');
  cmbItemType.Items.Add('Boolean');
  cmbItemType.Items.Add('Object');
  cmbItemType.ItemIndex := 0;
  cmbItemType.OnChange := cmbItemTypeChange;
  
  // Create list control
  lstItems := TListBox.Create(pnlMain);
  lstItems.Parent := pnlMain;
  lstItems.Align := alClient;
  lstItems.AlignWithMargins := True;
  lstItems.Margins.SetBounds(5, 5, 5, 5);
  lstItems.OnClick := lstItemsClick;
  
  // Create control panel
  pnlControls := TPanel.Create(pnlMain);
  pnlControls.Parent := pnlMain;
  pnlControls.Align := alBottom;
  pnlControls.Height := 40;
  pnlControls.BevelOuter := bvNone;
  
  // Add button
  btnAdd := TButton.Create(pnlControls);
  btnAdd.Parent := pnlControls;
  btnAdd.Left := 5;
  btnAdd.Top := 5;
  btnAdd.Width := 60;
  btnAdd.Caption := 'Add';
  btnAdd.OnClick := btnAddClick;
  
  // Edit button
  btnEdit := TButton.Create(pnlControls);
  btnEdit.Parent := pnlControls;
  btnEdit.Left := 70;
  btnEdit.Top := 5;
  btnEdit.Width := 60;
  btnEdit.Caption := 'Edit';
  btnEdit.OnClick := btnEditClick;
  btnEdit.Enabled := False;
  
  // Delete button
  btnDelete := TButton.Create(pnlControls);
  btnDelete.Parent := pnlControls;
  btnDelete.Left := 135;
  btnDelete.Top := 5;
  btnDelete.Width := 60;
  btnDelete.Caption := 'Delete';
  btnDelete.OnClick := btnDeleteClick;
  btnDelete.Enabled := False;
  
  // Move up button
  btnMoveUp := TButton.Create(pnlControls);
  btnMoveUp.Parent := pnlControls;
  btnMoveUp.Left := 200;
  btnMoveUp.Top := 5;
  btnMoveUp.Width := 60;
  btnMoveUp.Caption := 'Move Up';
  btnMoveUp.OnClick := btnMoveUpClick;
  btnMoveUp.Enabled := False;
  
  // Move down button
  btnMoveDown := TButton.Create(pnlControls);
  btnMoveDown.Parent := pnlControls;
  btnMoveDown.Left := 265;
  btnMoveDown.Top := 5;
  btnMoveDown.Width := 60;
  btnMoveDown.Caption := 'Move Down';
  btnMoveDown.OnClick := btnMoveDownClick;
  btnMoveDown.Enabled := False;
end;

procedure TFrameArrayEditor.cmbItemTypeChange(Sender: TObject);
begin
  // Update array item type
  case cmbItemType.ItemIndex of
    0: FItemType := aitString;
    1: FItemType := aitNumber;
    2: FItemType := aitBoolean;
    3: FItemType := aitObject;
  else
    FItemType := aitString;
  end;
  
  // Clear list
  if lstItems.Items.Count > 0 then
  begin
    if MessageDlg('Changing array item type will clear the current list. Continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lstItems.Items.Clear;
      FObjectItems.Clear;
    end
    else
    begin
      // Restore original selection
      case FItemType of
        aitString: cmbItemType.ItemIndex := 0;
        aitNumber: cmbItemType.ItemIndex := 1;
        aitBoolean: cmbItemType.ItemIndex := 2;
        aitObject: cmbItemType.ItemIndex := 3;
      end;
    end;
  end;
  
  // Update button states
  UpdateButtonStates;
  
  // Mark as modified
  Modified := True;
end;

procedure TFrameArrayEditor.UpdateButtonStates;
begin
  // 鏇存柊鎸夐挳鐘舵€?  btnEdit.Enabled := lstItems.ItemIndex >= 0;
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
        // Add string item
        NewItem := '';
        if InputQuery('Add String', 'Please enter a string value:', NewItem) then
        begin
          lstItems.Items.Add(NewItem);
          Modified := True;
        end;
      end;
    aitNumber:
      begin
        // Add number item
        NewItem := '0';
        if InputQuery('Add Number', 'Please enter a numeric value:', NewItem) then
        begin
          try
            Value := StrToFloat(NewItem);
            lstItems.Items.Add(NewItem);
            Modified := True;
          except
            on E: Exception do
              ShowMessage('Please enter a valid number');
          end;
        end;
      end;
    aitBoolean:
      begin
        // Add boolean item
        if MessageDlg('Please select a boolean value', mtConfirmation, mbYesNo, 0) = mrYes then
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
        // Add object item
        JSONObj := TJSONObject.Create;
        FObjectItems.Add(JSONObj);
        lstItems.Items.Add(Format('Object %d', [FObjectItems.Count]));
        Modified := True;
      end;
  end;
  
  // Update button states
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
        // Edit string item
        OldValue := lstItems.Items[SelectedIndex];
        NewValue := OldValue;
        if InputQuery('Edit String', 'Please enter a string value:', NewValue) then
        begin
          lstItems.Items[SelectedIndex] := NewValue;
          Modified := True;
        end;
      end;
    aitNumber:
      begin
        // Edit number item
        OldValue := lstItems.Items[SelectedIndex];
        NewValue := OldValue;
        if InputQuery('Edit Number', 'Please enter a numeric value:', NewValue) then
        begin
          try
            DValue := StrToFloat(NewValue);
            lstItems.Items[SelectedIndex] := NewValue;
            Modified := True;
          except
            on E: Exception do
              ShowMessage('Please enter a valid number');
          end;
        end;
      end;
    aitBoolean:
      begin
        // Edit boolean item
        OldValue := lstItems.Items[SelectedIndex];
        BoolValue := SameText(OldValue, 'True');
        
        if MessageDlg('Edit boolean value', mtConfirmation, mbYesNo, 0) = mrYes then
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
        // Edit object item
        if (SelectedIndex >= 0) and (SelectedIndex < FObjectItems.Count) then
        begin
          JSONObj := FObjectItems[SelectedIndex];
          // Use object editor to edit object
          // Here we should open a dialog for editing the JSON object
          // For simplicity, we just display the object as a string
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
  
  if MessageDlg('Are you sure you want to delete the selected item?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // If it's an object type, also delete the corresponding JSON object
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
    
    // Update button states
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
  
  // Exchange list items
  lstItems.Items.Exchange(SelectedIndex, SelectedIndex - 1);
  
  // If it's an object type, also exchange JSON objects
  if FItemType = aitObject then
  begin
    if (SelectedIndex < FObjectItems.Count) and (SelectedIndex - 1 >= 0) then
    begin
      TempObj := FObjectItems[SelectedIndex];
      FObjectItems[SelectedIndex] := FObjectItems[SelectedIndex - 1];
      FObjectItems[SelectedIndex - 1] := TempObj;
    end;
  end;
  
  // Select the moved item
  lstItems.ItemIndex := SelectedIndex - 1;
  Modified := True;
  
  // Update button states
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
  
  // Exchange list items
  lstItems.Items.Exchange(SelectedIndex, SelectedIndex + 1);
  
  // If it's an object type, also exchange JSON objects
  if FItemType = aitObject then
  begin
    if (SelectedIndex < FObjectItems.Count) and (SelectedIndex + 1 < FObjectItems.Count) then
    begin
      TempObj := FObjectItems[SelectedIndex];
      FObjectItems[SelectedIndex] := FObjectItems[SelectedIndex + 1];
      FObjectItems[SelectedIndex + 1] := TempObj;
    end;
  end;
  
  // Select the moved item
  lstItems.ItemIndex := SelectedIndex + 1;
  Modified := True;
  
  // Update button states
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
  // Clear existing data
  lstItems.Items.Clear;
  for i := 0 to FObjectItems.Count - 1 do
    FObjectItems[i].Free;
  FObjectItems.Clear;
  
  if not Assigned(JSONObject) then
    Exit;
  
  // Try to get array type
  if JSONObject.TryGetValue('item_type', TypeString) then
    FItemType := GetItemTypeFromString(TypeString)
  else
    FItemType := aitString;
  
  // Update type dropdown
  case FItemType of
    aitString: cmbItemType.ItemIndex := 0;
    aitNumber: cmbItemType.ItemIndex := 1;
    aitBoolean: cmbItemType.ItemIndex := 2;
    aitObject: cmbItemType.ItemIndex := 3;
  else
    cmbItemType.ItemIndex := 0;
  end;
  
  // Get array value
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
            lstItems.Items.Add(Format('Object %d', [FObjectItems.Count]));
          end;
      end;
    end;
  end;
  
  // Update button states
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
  // Ensure JSONObject is not nil
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
  
  // Set array item type
  JSONObject.RemovePair('item_type');
  JSONObject.AddPair('item_type', GetItemTypeAsString(FItemType));
  
  // Set config type
  JSONObject.RemovePair('_type');
  JSONObject.AddPair('_type', ConfigTypeToString(ctArray));
  
  // Create array value
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
  
  // Set array value
  JSONObject.RemovePair('value');
  JSONObject.AddPair('value', JSONArray);
  
  Modified := False;
end;

end.
