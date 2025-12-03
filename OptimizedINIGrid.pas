unit OptimizedINIGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.IniFiles,
  Vcl.Controls, Vcl.Grids, Vcl.Graphics, System.Generics.Collections, ErrorLogger;

type
  TINIItem = class
  private
    FSection: string;
    FKey: string;
    FValue: string;
    FComment: string;
  public
    constructor Create(const ASection, AKey, AValue, AComment: string);
    
    property Section: string read FSection write FSection;
    property Key: string read FKey write FKey;
    property Value: string read FValue write FValue;
    property Comment: string read FComment write FComment;
  end;
  
  TINIItemList = class(TObjectList<TINIItem>)
  private
    FFilterText: string;
    FFilteredItems: TList<Integer>;
    
    function GetFilteredCount: Integer;
    function GetFilteredItem(Index: Integer): TINIItem;
  public
    constructor Create(OwnsObjects: Boolean = True);
    destructor Destroy; override;
    
    procedure SetFilter(const FilterText: string);
    procedure ClearFilter;
    function AddItem(const Section, Key, Value, Comment: string): Integer;
    function FindItem(const Section, Key: string): TINIItem;
    procedure UpdateItem(const Section, Key, Value, Comment: string);
    procedure DeleteItem(const Section, Key: string);
    
    property FilteredCount: Integer read GetFilteredCount;
    property FilteredItems[Index: Integer]: TINIItem read GetFilteredItem; default;
  end;
  
  TOptimizedINIGrid = class(TStringGrid)
  private
    FItems: TINIItemList;
    FFileName: string;
    FModified: Boolean;
    FVirtualMode: Boolean;
    FPageSize: Integer;
    FCurrentPage: Integer;
    
    procedure SetFileName(const Value: string);
    procedure SetVirtualMode(const Value: Boolean);
    procedure SetCurrentPage(const Value: Integer);
    function GetPageCount: Integer;
    
    procedure UpdateGridSize;
    procedure UpdateGridContent;
    procedure UpdatePageControls;
    procedure LoadPage(PageIndex: Integer);
  protected
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string = '');
    procedure LoadFromMemIniFile(MemIni: TMemIniFile);
    procedure SaveToMemIniFile(MemIni: TMemIniFile);
    
    procedure AddItem(const Section, Key, Value, Comment: string);
    procedure UpdateItem(const Section, Key, Value, Comment: string);
    procedure DeleteItem(const Section, Key: string);
    function FindItem(const Section, Key: string): TINIItem;
    
    procedure SetFilter(const FilterText: string);
    procedure ClearFilter;
    
    procedure FirstPage;
    procedure PreviousPage;
    procedure NextPage;
    procedure LastPage;
    
    property FileName: string read FFileName write SetFileName;
    property Modified: Boolean read FModified write FModified;
    property VirtualMode: Boolean read FVirtualMode write SetVirtualMode;
    property PageSize: Integer read FPageSize write FPageSize;
    property CurrentPage: Integer read FCurrentPage write SetCurrentPage;
    property PageCount: Integer read GetPageCount;
    property Items: TINIItemList read FItems;
  end;

implementation

{ TINIItem }

constructor TINIItem.Create(const ASection, AKey, AValue, AComment: string);
begin
  FSection := ASection;
  FKey := AKey;
  FValue := AValue;
  FComment := AComment;
end;

{ TINIItemList }

constructor TINIItemList.Create(OwnsObjects: Boolean);
begin
  inherited Create(OwnsObjects);
  FFilteredItems := TList<Integer>.Create;
  FFilterText := '';
end;

destructor TINIItemList.Destroy;
begin
  FFilteredItems.Free;
  inherited;
end;

function TINIItemList.AddItem(const Section, Key, Value, Comment: string): Integer;
var
  Item: TINIItem;
begin
  Item := TINIItem.Create(Section, Key, Value, Comment);
  Result := Add(Item);
  
  // 如果有过滤，更新过滤列表
  if FFilterText <> '' then
    SetFilter(FFilterText);
end;

procedure TINIItemList.ClearFilter;
begin
  FFilterText := '';
  FFilteredItems.Clear;
end;

procedure TINIItemList.DeleteItem(const Section, Key: string);
var
  i: Integer;
  Item: TINIItem;
begin
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    if (Item.Section = Section) and (Item.Key = Key) then
    begin
      Delete(i);
      
      // 如果有过滤，更新过滤列表
      if FFilterText <> '' then
        SetFilter(FFilterText);
        
      Break;
    end;
  end;
end;

function TINIItemList.FindItem(const Section, Key: string): TINIItem;
var
  i: Integer;
  Item: TINIItem;
begin
  Result := nil;
  
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    if (Item.Section = Section) and (Item.Key = Key) then
    begin
      Result := Item;
      Break;
    end;
  end;
end;

function TINIItemList.GetFilteredCount: Integer;
begin
  if FFilterText = '' then
    Result := Count
  else
    Result := FFilteredItems.Count;
end;

function TINIItemList.GetFilteredItem(Index: Integer): TINIItem;
begin
  if (Index < 0) or (Index >= FilteredCount) then
    raise Exception.Create('索引超出范围');
    
  if FFilterText = '' then
    Result := Items[Index]
  else
    Result := Items[FFilteredItems[Index]];
end;

procedure TINIItemList.SetFilter(const FilterText: string);
var
  i: Integer;
  Item: TINIItem;
  LowerFilter: string;
begin
  FFilterText := FilterText;
  FFilteredItems.Clear;
  
  if FilterText = '' then
    Exit;
    
  LowerFilter := LowerCase(FilterText);
  
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    
    if (Pos(LowerFilter, LowerCase(Item.Section)) > 0) or
       (Pos(LowerFilter, LowerCase(Item.Key)) > 0) or
       (Pos(LowerFilter, LowerCase(Item.Value)) > 0) then
    begin
      FFilteredItems.Add(i);
    end;
  end;
end;

procedure TINIItemList.UpdateItem(const Section, Key, Value, Comment: string);
var
  Item: TINIItem;
begin
  Item := FindItem(Section, Key);
  
  if Assigned(Item) then
  begin
    Item.Value := Value;
    Item.Comment := Comment;
    
    // 如果有过滤，更新过滤列表
    if FFilterText <> '' then
      SetFilter(FFilterText);
  end
  else
    AddItem(Section, Key, Value, Comment);
end;

{ TOptimizedINIGrid }

constructor TOptimizedINIGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FItems := TINIItemList.Create;
  FModified := False;
  FVirtualMode := False;
  FPageSize := 100;
  FCurrentPage := 0;
  
  // 设置网格属性
  FixedCols := 0;
  FixedRows := 1;
  Options := Options + [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, 
                        goRowSelect, goThumbTracking] - [goEditing];
  
  // 设置列标题
  RowCount := 2;
  ColCount := 4;
  Cells[0, 0] := '节';
  Cells[1, 0] := '键';
  Cells[2, 0] := '值';
  Cells[3, 0] := '注释';
  
  // 设置列宽
  ColWidths[0] := 120;
  ColWidths[1] := 150;
  ColWidths[2] := 200;
  ColWidths[3] := 150;
end;

destructor TOptimizedINIGrid.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TOptimizedINIGrid.AddItem(const Section, Key, Value, Comment: string);
begin
  FItems.AddItem(Section, Key, Value, Comment);
  FModified := True;
  
  UpdateGridSize;
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.ClearFilter;
begin
  FItems.ClearFilter;
  FCurrentPage := 0;
  
  UpdateGridSize;
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.DeleteItem(const Section, Key: string);
begin
  FItems.DeleteItem(Section, Key);
  FModified := True;
  
  UpdateGridSize;
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  S: string;
  TextRect: TRect;
  TextFormat: UINT;
begin
  if (ARow = 0) or (ACol >= ColCount) then
  begin
    inherited;
    Exit;
  end;
  
  // 获取单元格文本
  S := Cells[ACol, ARow];
  
  // 清除单元格背景
  Canvas.Brush.Color := Color;
  if gdSelected in AState then
    Canvas.Brush.Color := clHighlight;
  Canvas.FillRect(ARect);
  
  // 设置文本颜色
  if gdSelected in AState then
    Canvas.Font.Color := clHighlightText
  else
    Canvas.Font.Color := Font.Color;
    
  // 绘制文本
  TextRect := ARect;
  InflateRect(TextRect, -2, -2);
  TextFormat := DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS;
  
  DrawText(Canvas.Handle, PChar(S), Length(S), TextRect, TextFormat);
end;

function TOptimizedINIGrid.FindItem(const Section, Key: string): TINIItem;
begin
  Result := FItems.FindItem(Section, Key);
end;

procedure TOptimizedINIGrid.FirstPage;
begin
  CurrentPage := 0;
end;

function TOptimizedINIGrid.GetPageCount: Integer;
begin
  if FItems.FilteredCount = 0 then
    Result := 1
  else
    Result := (FItems.FilteredCount + FPageSize - 1) div FPageSize;
end;

procedure TOptimizedINIGrid.LastPage;
begin
  CurrentPage := PageCount - 1;
end;

procedure TOptimizedINIGrid.LoadFromFile(const FileName: string);
var
  MemIni: TMemIniFile;
begin
  if not FileExists(FileName) then
  begin
    Logger.Log('INI文件不存在: ' + FileName, llWarning);
    Exit;
  end;
  
  try
    MemIni := TMemIniFile.Create(FileName, TEncoding.UTF8);
    try
      LoadFromMemIniFile(MemIni);
      FFileName := FileName;
      FModified := False;
    finally
      MemIni.Free;
    end;
  except
    on E: Exception do
      Logger.Log('加载INI文件时发生错误', E, llError);
  end;
end;

procedure TOptimizedINIGrid.LoadFromMemIniFile(MemIni: TMemIniFile);
var
  Sections: TStringList;
  Keys: TStringList;
  i, j: Integer;
  Section, Key, Value, Comment: string;
begin
  // 清空现有项
  FItems.Clear;
  
  // 创建临时列表
  Sections := TStringList.Create;
  Keys := TStringList.Create;
  
  try
    // 获取所有节
    MemIni.ReadSections(Sections);
    
    // 遍历所有节和键
    for i := 0 to Sections.Count - 1 do
    begin
      Section := Sections[i];
      MemIni.ReadSection(Section, Keys);
      
      for j := 0 to Keys.Count - 1 do
      begin
        Key := Keys[j];
        Value := MemIni.ReadString(Section, Key, '');
        Comment := ''; // MemIniFile不支持读取注释
        
        FItems.AddItem(Section, Key, Value, Comment);
      end;
    end;
  finally
    Keys.Free;
    Sections.Free;
  end;
  
  // 更新网格
  FCurrentPage := 0;
  UpdateGridSize;
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.LoadPage(PageIndex: Integer);
var
  i, StartIndex, EndIndex, RowIndex: Integer;
  Item: TINIItem;
begin
  // 计算页范围
  StartIndex := PageIndex * FPageSize;
  EndIndex := Min(StartIndex + FPageSize - 1, FItems.FilteredCount - 1);
  
  // 清空网格内容（保留标题行）
  for i := 1 to RowCount - 1 do
  begin
    Cells[0, i] := '';
    Cells[1, i] := '';
    Cells[2, i] := '';
    Cells[3, i] := '';
  end;
  
  // 填充网格内容
  for i := StartIndex to EndIndex do
  begin
    RowIndex := i - StartIndex + 1;
    Item := FItems.FilteredItems[i];
    
    Cells[0, RowIndex] := Item.Section;
    Cells[1, RowIndex] := Item.Key;
    Cells[2, RowIndex] := Item.Value;
    Cells[3, RowIndex] := Item.Comment;
  end;
end;

procedure TOptimizedINIGrid.NextPage;
begin
  if CurrentPage < PageCount - 1 then
    CurrentPage := CurrentPage + 1;
end;

procedure TOptimizedINIGrid.PreviousPage;
begin
  if CurrentPage > 0 then
    CurrentPage := CurrentPage - 1;
end;

procedure TOptimizedINIGrid.SaveToFile(const FileName: string);
var
  SaveFileName: string;
  MemIni: TMemIniFile;
begin
  if FileName <> '' then
    SaveFileName := FileName
  else if FFileName <> '' then
    SaveFileName := FFileName
  else
  begin
    Logger.Log('未指定保存文件名', llWarning);
    Exit;
  end;
  
  try
    MemIni := TMemIniFile.Create(SaveFileName, TEncoding.UTF8);
    try
      SaveToMemIniFile(MemIni);
      MemIni.UpdateFile;
      FFileName := SaveFileName;
      FModified := False;
    finally
      MemIni.Free;
    end;
  except
    on E: Exception do
      Logger.Log('保存INI文件时发生错误', E, llError);
  end;
end;

procedure TOptimizedINIGrid.SaveToMemIniFile(MemIni: TMemIniFile);
var
  i: Integer;
  Item: TINIItem;
begin
  // 清空现有内容
  MemIni.Clear;
  
  // 写入所有项
  for i := 0 to FItems.Count - 1 do
  begin
    Item := FItems[i];
    MemIni.WriteString(Item.Section, Item.Key, Item.Value);
  end;
end;

procedure TOptimizedINIGrid.SetCurrentPage(const Value: Integer);
begin
  if (Value >= 0) and (Value < PageCount) and (Value <> FCurrentPage) then
  begin
    FCurrentPage := Value;
    LoadPage(FCurrentPage);
    UpdatePageControls;
  end;
end;

procedure TOptimizedINIGrid.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TOptimizedINIGrid.SetFilter(const FilterText: string);
begin
  FItems.SetFilter(FilterText);
  FCurrentPage := 0;
  
  UpdateGridSize;
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.SetVirtualMode(const Value: Boolean);
begin
  if FVirtualMode <> Value then
  begin
    FVirtualMode := Value;
    UpdateGridSize;
    UpdateGridContent;
  end;
end;

procedure TOptimizedINIGrid.UpdateGridContent;
begin
  if FVirtualMode then
    LoadPage(FCurrentPage)
  else
  begin
    // 非虚拟模式下，加载所有项
    var i: Integer;
    var Item: TINIItem;
    
    for i := 0 to FItems.FilteredCount - 1 do
    begin
      if i + 1 >= RowCount then
        Break;
        
      Item := FItems.FilteredItems[i];
      
      Cells[0, i + 1] := Item.Section;
      Cells[1, i + 1] := Item.Key;
      Cells[2, i + 1] := Item.Value;
      Cells[3, i + 1] := Item.Comment;
    end;
  end;
  
  UpdatePageControls;
  Invalidate;
end;

procedure TOptimizedINIGrid.UpdateGridSize;
begin
  if FVirtualMode then
  begin
    // 虚拟模式下，行数为每页显示的行数加上标题行
    RowCount := Min(FPageSize, FItems.FilteredCount) + 1;
    if RowCount < 2 then
      RowCount := 2;
  end
  else
  begin
    // 非虚拟模式下，行数为项数加上标题行
    RowCount := FItems.FilteredCount + 1;
    if RowCount < 2 then
      RowCount := 2;
  end;
end;

procedure TOptimizedINIGrid.UpdateItem(const Section, Key, Value, Comment: string);
begin
  FItems.UpdateItem(Section, Key, Value, Comment);
  FModified := True;
  
  UpdateGridContent;
end;

procedure TOptimizedINIGrid.UpdatePageControls;
begin
  // 这个方法可以由外部控制分页的UI组件调用
  // 例如更新页码标签、启用/禁用分页按钮等
end;

end.
