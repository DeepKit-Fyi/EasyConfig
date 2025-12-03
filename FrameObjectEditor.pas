unit FrameObjectEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, System.JSON, ConfigFrameBase, UtilsTypes, System.UITypes,
  JSONHelpers;

type
  TObjectPropertyType = (ptString, ptNumber, ptBoolean, ptObject, ptArray);

  TObjectProperty = record
    Name: string;
    PropertyType: TObjectPropertyType;
    Value: string;
  end;

  TFrameObjectEditor = class(TBaseConfigFrame)
  private
    pnlTitle: TPanel;
    pnlControls: TPanel;
    edtTitle: TEdit;
    sgProperties: TStringGrid;
    cmbPropertyType: TComboBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    
    procedure CreateControls; override;
    procedure InitializeGrid;
    
    procedure sgPropertiesSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

constructor TFrameObjectEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitializeGrid;
end;

destructor TFrameObjectEditor.Destroy;
begin
  inherited;
end;

procedure TFrameObjectEditor.CreateControls;
begin
  // Title panel
  pnlTitle := TPanel.Create(Self);
  pnlTitle.Parent := Self;
  pnlTitle.Align := alTop;
  pnlTitle.Height := 30;
  pnlTitle.BevelOuter := bvNone;
  
  // Title edit
  edtTitle := TEdit.Create(pnlTitle);
  edtTitle.Parent := pnlTitle;
  edtTitle.Align := alClient;
  edtTitle.AlignWithMargins := True;
  edtTitle.Text := 'Object Properties';
  
  // Controls panel
  pnlControls := TPanel.Create(Self);
  pnlControls.Parent := Self;
  pnlControls.Align := alTop;
  pnlControls.Height := 40;
  pnlControls.BevelOuter := bvNone;
  
  // Property type combo
  cmbPropertyType := TComboBox.Create(pnlControls);
  cmbPropertyType.Parent := pnlControls;
  cmbPropertyType.Left := 5;
  cmbPropertyType.Top := 10;
  cmbPropertyType.Width := 120;
  cmbPropertyType.Style := csDropDownList;
  cmbPropertyType.Items.Add('String');
  cmbPropertyType.Items.Add('Number');
  cmbPropertyType.Items.Add('Boolean');
  cmbPropertyType.Items.Add('Object');
  cmbPropertyType.Items.Add('Array');
  cmbPropertyType.ItemIndex := 0;
  
  // Add button
  btnAdd := TButton.Create(pnlControls);
  btnAdd.Parent := pnlControls;
  btnAdd.Left := 130;
  btnAdd.Top := 8;
  btnAdd.Width := 80;
  btnAdd.Caption := 'Add Property';
  btnAdd.OnClick := btnAddClick;
  
  // Edit button
  btnEdit := TButton.Create(pnlControls);
  btnEdit.Parent := pnlControls;
  btnEdit.Left := 215;
  btnEdit.Top := 8;
  btnEdit.Width := 80;
  btnEdit.Caption := 'Edit Property';
  btnEdit.OnClick := btnEditClick;
  btnEdit.Enabled := False;
  
  // Delete button
  btnDelete := TButton.Create(pnlControls);
  btnDelete.Parent := pnlControls;
  btnDelete.Left := 300;
  btnDelete.Top := 8;
  btnDelete.Width := 80;
  btnDelete.Caption := 'Delete Property';
  btnDelete.OnClick := btnDeleteClick;
  btnDelete.Enabled := False;
  
  // Properties grid
  sgProperties := TStringGrid.Create(Self);
  sgProperties.Parent := Self;
  sgProperties.Align := alClient;
  sgProperties.AlignWithMargins := True;
  sgProperties.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect];
  sgProperties.OnSelectCell := sgPropertiesSelectCell;
end;

procedure TFrameObjectEditor.InitializeGrid;
begin
  // Setup grid columns
  sgProperties.ColCount := 3;
  sgProperties.RowCount := 1; // Header row only
  sgProperties.FixedRows := 1;
  sgProperties.ColWidths[0] := 150; // Property name
  sgProperties.ColWidths[1] := 100; // Type
  sgProperties.ColWidths[2] := 250; // Value
  
  // Set column headers
  sgProperties.Cells[0, 0] := 'Property Name';
  sgProperties.Cells[1, 0] := 'Type';
  sgProperties.Cells[2, 0] := 'Value';
end;

procedure TFrameObjectEditor.sgPropertiesSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // Enable edit/delete buttons when a row is selected
  btnEdit.Enabled := ARow > 0;
  btnDelete.Enabled := ARow > 0;
end;

procedure TFrameObjectEditor.btnAddClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  TypeIndex, NewRow: Integer;
begin
  // Simple implementation to add a property
  PropertyName := '';
  if InputQuery('Add Property', 'Enter property name:', PropertyName) then
  begin
    PropertyValue := '';
    TypeIndex := cmbPropertyType.ItemIndex;
    
    case TypeIndex of
      0: // String
        if InputQuery('Add String Property', 'Enter string value:', PropertyValue) then
          // Continue with adding
        else
          Exit;
      1: // Number
        if InputQuery('Add Number Property', 'Enter numeric value:', PropertyValue) then
        begin
          try
            StrToFloat(PropertyValue);
          except
            MessageDlg('Invalid numeric value', mtError, [mbOK], 0);
            Exit;
          end;
        end
        else
          Exit;
      2: // Boolean
        if MessageDlg('Choose Boolean value', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          PropertyValue := 'true'
        else
          PropertyValue := 'false';
      3: // Object
        PropertyValue := '{}';
      4: // Array
        PropertyValue := '[]';
    end;
    
    // Add to grid
    NewRow := sgProperties.RowCount;
    sgProperties.RowCount := NewRow + 1;
    sgProperties.Cells[0, NewRow] := PropertyName;
    sgProperties.Cells[1, NewRow] := cmbPropertyType.Items[TypeIndex];
    sgProperties.Cells[2, NewRow] := PropertyValue;
    
    // Set modified flag
    Modified := True;
  end;
end;

procedure TFrameObjectEditor.btnEditClick(Sender: TObject);
var
  Row: Integer;
  PropertyName, PropertyValue: string;
  TypeIndex: Integer;
begin
  // Simple implementation to edit a property
  Row := sgProperties.Row;
  if Row <= 0 then Exit;
  
  PropertyName := sgProperties.Cells[0, Row];
  if InputQuery('Edit Property', 'Edit property name:', PropertyName) then
  begin
    PropertyValue := sgProperties.Cells[2, Row];
    
    // Get type index from combo
    TypeIndex := -1;
    for var i := 0 to cmbPropertyType.Items.Count - 1 do
      if cmbPropertyType.Items[i] = sgProperties.Cells[1, Row] then
      begin
        TypeIndex := i;
        Break;
      end;
    
    if TypeIndex < 0 then TypeIndex := 0;
    
    case TypeIndex of
      0: // String
        if InputQuery('Edit String Property', 'Edit string value:', PropertyValue) then
          // Continue with editing
        else
          Exit;
      1: // Number
        if InputQuery('Edit Number Property', 'Edit numeric value:', PropertyValue) then
        begin
          try
            StrToFloat(PropertyValue);
          except
            MessageDlg('Invalid numeric value', mtError, [mbOK], 0);
            Exit;
          end;
        end
        else
          Exit;
      2: // Boolean
        if MessageDlg('Choose Boolean value', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          PropertyValue := 'true'
        else
          PropertyValue := 'false';
    end;
    
    // Update grid
    sgProperties.Cells[0, Row] := PropertyName;
    sgProperties.Cells[2, Row] := PropertyValue;
    
    // Set modified flag
    Modified := True;
  end;
end;

procedure TFrameObjectEditor.btnDeleteClick(Sender: TObject);
var
  Row: Integer;
begin
  // Simple implementation to delete a property
  Row := sgProperties.Row;
  if Row <= 0 then Exit;
  
  if MessageDlg('Delete property "' + sgProperties.Cells[0, Row] + '"?', 
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // Remove row (move all rows up)
    for var i := Row to sgProperties.RowCount - 2 do
    begin
      sgProperties.Cells[0, i] := sgProperties.Cells[0, i + 1];
      sgProperties.Cells[1, i] := sgProperties.Cells[1, i + 1];
      sgProperties.Cells[2, i] := sgProperties.Cells[2, i + 1];
    end;
    sgProperties.RowCount := sgProperties.RowCount - 1;
    
    // Set modified flag
    Modified := True;
  end;
end;

procedure TFrameObjectEditor.LoadFromJSON;
var
  Obj: TJSONObject;
  Pair: TJSONPair;
  PropertyType, PropertyValue: string;
  Row: Integer;
begin
  // Clear grid
  sgProperties.RowCount := 1;
  
  if not Assigned(JSONObject) then
    Exit;
    
  // Get object value
  if JSONObject.TryGetValue('value', Obj) and (Obj is TJSONObject) then
  begin
    // Load properties
    for var i := 0 to Obj.Count - 1 do
    begin
      Pair := Obj.Pairs[i];
      
      // Determine property type
      if Pair.JsonValue is TJSONString then
      begin
        PropertyType := 'String';
        PropertyValue := TJSONString(Pair.JsonValue).Value;
      end
      else if Pair.JsonValue is TJSONNumber then
      begin
        PropertyType := 'Number';
        PropertyValue := TJSONNumber(Pair.JsonValue).ToString;
      end
      else if Pair.JsonValue is TJSONBool then
      begin
        PropertyType := 'Boolean';
        PropertyValue := LowerCase(BoolToStr(TJSONBool(Pair.JsonValue).AsBoolean, True));
      end
      else if Pair.JsonValue is TJSONObject then
      begin
        PropertyType := 'Object';
        PropertyValue := '{}';
      end
      else if Pair.JsonValue is TJSONArray then
      begin
        PropertyType := 'Array';
        PropertyValue := '[]';
      end
      else
      begin
        PropertyType := 'String';
        PropertyValue := '';
      end;
      
      // Add to grid
      Row := sgProperties.RowCount;
      sgProperties.RowCount := Row + 1;
      sgProperties.Cells[0, Row] := Pair.JsonString.Value;
      sgProperties.Cells[1, Row] := PropertyType;
      sgProperties.Cells[2, Row] := PropertyValue;
    end;
  end;
  
  // Set title if available
  if JSONObject.TryGetValue('_name', PropertyValue) then
    edtTitle.Text := PropertyValue
  else
    edtTitle.Text := 'Object Properties';
    
  // Reset modified flag
  Modified := False;
end;

procedure TFrameObjectEditor.SaveToJSON;
var
  Obj: TJSONObject;
  TypeStr, PropertyName, PropertyValue: string;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // Create or clear value object
  JSONObject.RemovePair('value');
  Obj := TJSONObject.Create;
  JSONObject.AddPair('_type', 'object');
  JSONObject.AddPair('_name', edtTitle.Text);
  JSONObject.AddPair('value', Obj);
  
  // Add all properties
  for var i := 1 to sgProperties.RowCount - 1 do
  begin
    PropertyName := sgProperties.Cells[0, i];
    TypeStr := sgProperties.Cells[1, i];
    PropertyValue := sgProperties.Cells[2, i];
    
    if PropertyName.Trim = '' then
      Continue;
    
    if TypeStr = 'String' then
      Obj.AddPair(PropertyName, PropertyValue)
    else if TypeStr = 'Number' then
    begin
      try
        Obj.AddPair(PropertyName, TJSONNumber.Create(StrToFloat(PropertyValue)));
      except
        Obj.AddPair(PropertyName, TJSONNumber.Create(0));
      end;
    end
    else if TypeStr = 'Boolean' then
      Obj.AddPair(PropertyName, TJSONBool.Create(LowerCase(PropertyValue) = 'true'))
    else if TypeStr = 'Object' then
      Obj.AddPair(PropertyName, TJSONObject.Create)
    else if TypeStr = 'Array' then
      Obj.AddPair(PropertyName, TJSONArray.Create);
  end;
  
  // Reset modified flag
  Modified := False;
end;

end. 

