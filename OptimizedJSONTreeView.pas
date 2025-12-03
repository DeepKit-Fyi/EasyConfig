unit OptimizedJSONTreeView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.JSON, JSONHelpers,
  Vcl.Controls, Vcl.ComCtrls, Vcl.Graphics, System.Generics.Collections,
  LazyLoadManager, ErrorLogger;

type
  TJSONNodeType = (jntObject, jntArray, jntProperty, jntValue);
  
  TJSONNodeData = class
  private
    FNodeType: TJSONNodeType;
    FKey: string;
    FValue: string;
    FJSONValue: TJSONValue;
    FIsLoaded: Boolean;
    FHasChildren: Boolean;
  public
    constructor Create(NodeType: TJSONNodeType; const Key, Value: string; JSONValue: TJSONValue);
    destructor Destroy; override;
    
    property NodeType: TJSONNodeType read FNodeType;
    property Key: string read FKey;
    property Value: string read FValue;
    property JSONValue: TJSONValue read FJSONValue;
    property IsLoaded: Boolean read FIsLoaded write FIsLoaded;
    property HasChildren: Boolean read FHasChildren write FHasChildren;
  end;
  
  TJSONTreeView = class(TTreeView)
  private
    FRootJSON: TJSONValue;
    FExpandedNodes: TDictionary<string, Boolean>;
    FMaxInitialNodes: Integer;
    FLazyLoadEnabled: Boolean;
    
    procedure ClearNodeData;
    function AddJSONNode(ParentNode: TTreeNode; JSONValue: TJSONValue; 
                        const Key: string = ''): TTreeNode;
    function AddJSONObjectNode(ParentNode: TTreeNode; JSONObject: TJSONObject; 
                              const Key: string = ''): TTreeNode;
    function AddJSONArrayNode(ParentNode: TTreeNode; JSONArray: TJSONArray; 
                             const Key: string = ''): TTreeNode;
    function GetNodePath(Node: TTreeNode): string;
    procedure ExpandNodeIfNeeded(Node: TTreeNode);
    procedure LoadNodeChildren(Node: TTreeNode; Data: TJSONObject);
    procedure DoLazyLoadChildren(Node: TTreeNode);
  protected
    procedure Expand(Node: TTreeNode); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure LoadJSON(JSONValue: TJSONValue);
    procedure SaveExpandedState;
    procedure RestoreExpandedState;
    procedure ExpandAll;
    procedure CollapseAll;
    
    property RootJSON: TJSONValue read FRootJSON;
    property MaxInitialNodes: Integer read FMaxInitialNodes write FMaxInitialNodes;
    property LazyLoadEnabled: Boolean read FLazyLoadEnabled write FLazyLoadEnabled;
  end;

implementation

{ TJSONNodeData }

constructor TJSONNodeData.Create(NodeType: TJSONNodeType; const Key, Value: string; JSONValue: TJSONValue);
begin
  FNodeType := NodeType;
  FKey := Key;
  FValue := Value;
  FJSONValue := JSONValue;
  FIsLoaded := False;
  
  // 预先判断是否有子节点
  FHasChildren := False;
  
  if Assigned(JSONValue) then
  begin
    if JSONValue is TJSONObject then
      FHasChildren := TJSONObject(JSONValue).Count > 0
    else if JSONValue is TJSONArray then
      FHasChildren := TJSONArray(JSONValue).Count > 0;
  end;
end;

destructor TJSONNodeData.Destroy;
begin
  // 不释放JSONValue，因为它是由外部管理的
  inherited;
end;

{ TJSONTreeView }

constructor TJSONTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FExpandedNodes := TDictionary<string, Boolean>.Create;
  FMaxInitialNodes := 100; // 默认最多初始加载100个节点
  FLazyLoadEnabled := True;
  
  // 设置树视图属性
  ShowRoot := True;
  ReadOnly := True;
  HideSelection := False;
  RowSelect := True;
  ShowLines := True;
  
  // 设置图标
  Images := TImageList.Create(Self);
  Images.Width := 16;
  Images.Height := 16;
  
  // 添加图标（这里只是示例，实际应用中应该加载真实的图标）
  with TBitmap.Create do
  try
    Width := 16;
    Height := 16;
    Canvas.Brush.Color := clBlue;
    Canvas.Ellipse(0, 0, 16, 16);
    Images.Add(Self, nil);
  finally
    Free;
  end;
  
  with TBitmap.Create do
  try
    Width := 16;
    Height := 16;
    Canvas.Brush.Color := clGreen;
    Canvas.Ellipse(0, 0, 16, 16);
    Images.Add(Self, nil);
  finally
    Free;
  end;
  
  with TBitmap.Create do
  try
    Width := 16;
    Height := 16;
    Canvas.Brush.Color := clRed;
    Canvas.Ellipse(0, 0, 16, 16);
    Images.Add(Self, nil);
  finally
    Free;
  end;
end;

destructor TJSONTreeView.Destroy;
begin
  ClearNodeData;
  FExpandedNodes.Free;
  inherited;
end;

procedure TJSONTreeView.ClearNodeData;
var
  i: Integer;
  Node: TTreeNode;
  NodeData: TJSONNodeData;
begin
  for i := 0 to Items.Count - 1 do
  begin
    Node := Items[i];
    if Assigned(Node.Data) then
    begin
      NodeData := TJSONNodeData(Node.Data);
      NodeData.Free;
      Node.Data := nil;
    end;
  end;
end;

procedure TJSONTreeView.Expand(Node: TTreeNode);
begin
  // 如果节点有子节点但尚未加载，则延迟加载子节点
  if Assigned(Node.Data) and FLazyLoadEnabled then
  begin
    DoLazyLoadChildren(Node);
  end;
  
  inherited;
end;

procedure TJSONTreeView.DoLazyLoadChildren(Node: TTreeNode);
var
  NodeData: TJSONNodeData;
begin
  if not Assigned(Node) or not Assigned(Node.Data) then
    Exit;
    
  NodeData := TJSONNodeData(Node.Data);
  
  // 如果节点已加载或没有子节点，则不需要加载
  if NodeData.IsLoaded or not NodeData.HasChildren then
    Exit;
    
  // 如果是对象节点，使用延迟加载管理器加载子节点
  if (NodeData.NodeType = jntObject) and (NodeData.JSONValue is TJSONObject) then
  begin
    LazyLoader.QueueNodeLoad(Node, TJSONObject(NodeData.JSONValue), LoadNodeChildren);
    NodeData.IsLoaded := True;
  end
  // 如果是数组节点，直接加载子节点（数组通常不需要延迟加载）
  else if (NodeData.NodeType = jntArray) and (NodeData.JSONValue is TJSONArray) then
  begin
    // 添加数组元素
    var JSONArray := TJSONArray(NodeData.JSONValue);
    for var i := 0 to JSONArray.Count - 1 do
    begin
      AddJSONNode(Node, JSONArray.Items[i], '[' + IntToStr(i) + ']');
    end;
    NodeData.IsLoaded := True;
  end;
end;

procedure TJSONTreeView.LoadNodeChildren(Node: TTreeNode; Data: TJSONObject);
var
  i: Integer;
  Pair: TJSONPair;
begin
  try
    // 清除现有子节点
    while Node.Count > 0 do
      Node.Item[0].Delete;
      
    // 添加对象属性
    for i := 0 to Data.Count - 1 do
    begin
      Pair := Data.Pairs[i];
      AddJSONNode(Node, Pair.JsonValue, Pair.JsonString.Value);
    end;
  except
    on E: Exception do
      Logger.Log('加载JSON节点子节点时发生错误', E, llError);
  end;
end;

function TJSONTreeView.AddJSONNode(ParentNode: TTreeNode; JSONValue: TJSONValue; const Key: string): TTreeNode;
begin
  Result := nil;
  
  if not Assigned(JSONValue) then
    Exit;
    
  // 根据JSON值类型添加不同类型的节点
  if JSONValue is TJSONObject then
    Result := AddJSONObjectNode(ParentNode, TJSONObject(JSONValue), Key)
  else if JSONValue is TJSONArray then
    Result := AddJSONArrayNode(ParentNode, TJSONArray(JSONValue), Key)
  else
  begin
    // 添加值节点
    var NodeText := '';
    if Key <> '' then
      NodeText := Key + ': ';
      
    if JSONValue is TJSONString then
      NodeText := NodeText + '"' + TJSONString(JSONValue).Value + '"'
    else if JSONValue is TJSONNumber then
      NodeText := NodeText + TJSONNumber(JSONValue).ToString
    else if JSONValue is TJSONBool then
      NodeText := NodeText + BoolToStr(TJSONBool(JSONValue).AsBoolean, True)
    else if JSONValue is TJSONNull then
      NodeText := NodeText + 'null'
    else
      NodeText := NodeText + JSONValue.ToString;
      
    Result := Items.AddChild(ParentNode, NodeText);
    Result.ImageIndex := 2; // 值节点图标
    Result.SelectedIndex := 2;
    
    // 设置节点数据
    Result.Data := TJSONNodeData.Create(jntValue, Key, JSONValue.ToString, JSONValue);
  end;
end;

function TJSONTreeView.AddJSONObjectNode(ParentNode: TTreeNode; JSONObject: TJSONObject; const Key: string): TTreeNode;
var
  NodeText: string;
  NodeData: TJSONNodeData;
  InitialCount, i: Integer;
  Pair: TJSONPair;
begin
  // 创建对象节点
  if Key <> '' then
    NodeText := Key + ': {}'
  else
    NodeText := '{}';
    
  Result := Items.AddChild(ParentNode, NodeText);
  Result.ImageIndex := 0; // 对象节点图标
  Result.SelectedIndex := 0;
  
  // 设置节点数据
  NodeData := TJSONNodeData.Create(jntObject, Key, '{}', JSONObject);
  Result.Data := NodeData;
  
  // 如果启用了延迟加载，并且对象有很多属性，则不立即加载子节点
  if FLazyLoadEnabled and (JSONObject.Count > FMaxInitialNodes) then
  begin
    // 只添加一个占位符子节点，表示有子节点但尚未加载
    var DummyNode := Items.AddChild(Result, '加载中...');
    DummyNode.ImageIndex := -1;
    DummyNode.SelectedIndex := -1;
  end
  else
  begin
    // 直接加载子节点
    InitialCount := Min(JSONObject.Count, FMaxInitialNodes);
    
    for i := 0 to InitialCount - 1 do
    begin
      Pair := JSONObject.Pairs[i];
      AddJSONNode(Result, Pair.JsonValue, Pair.JsonString.Value);
    end;
    
    // 如果有更多子节点，添加一个提示节点
    if JSONObject.Count > InitialCount then
    begin
      var MoreNode := Items.AddChild(Result, Format('...还有%d个属性未显示', [JSONObject.Count - InitialCount]));
      MoreNode.ImageIndex := -1;
      MoreNode.SelectedIndex := -1;
    end;
    
    NodeData.IsLoaded := True;
  end;
end;

function TJSONTreeView.AddJSONArrayNode(ParentNode: TTreeNode; JSONArray: TJSONArray; const Key: string): TTreeNode;
var
  NodeText: string;
  NodeData: TJSONNodeData;
  InitialCount, i: Integer;
begin
  // 创建数组节点
  if Key <> '' then
    NodeText := Key + ': []'
  else
    NodeText := '[]';
    
  Result := Items.AddChild(ParentNode, NodeText);
  Result.ImageIndex := 1; // 数组节点图标
  Result.SelectedIndex := 1;
  
  // 设置节点数据
  NodeData := TJSONNodeData.Create(jntArray, Key, '[]', JSONArray);
  Result.Data := NodeData;
  
  // 如果启用了延迟加载，并且数组有很多元素，则不立即加载子节点
  if FLazyLoadEnabled and (JSONArray.Count > FMaxInitialNodes) then
  begin
    // 只添加一个占位符子节点，表示有子节点但尚未加载
    var DummyNode := Items.AddChild(Result, '加载中...');
    DummyNode.ImageIndex := -1;
    DummyNode.SelectedIndex := -1;
  end
  else
  begin
    // 直接加载子节点
    InitialCount := Min(JSONArray.Count, FMaxInitialNodes);
    
    for i := 0 to InitialCount - 1 do
    begin
      AddJSONNode(Result, JSONArray.Items[i], '[' + IntToStr(i) + ']');
    end;
    
    // 如果有更多子节点，添加一个提示节点
    if JSONArray.Count > InitialCount then
    begin
      var MoreNode := Items.AddChild(Result, Format('...还有%d个元素未显示', [JSONArray.Count - InitialCount]));
      MoreNode.ImageIndex := -1;
      MoreNode.SelectedIndex := -1;
    end;
    
    NodeData.IsLoaded := True;
  end;
end;

procedure TJSONTreeView.ExpandAll;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    Items[i].Expand(False);
end;

procedure TJSONTreeView.CollapseAll;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    Items[i].Collapse(True);
end;

procedure TJSONTreeView.ExpandNodeIfNeeded(Node: TTreeNode);
var
  Path: string;
  IsExpanded: Boolean;
begin
  Path := GetNodePath(Node);
  
  if FExpandedNodes.TryGetValue(Path, IsExpanded) and IsExpanded then
    Node.Expand(False);
end;

function TJSONTreeView.GetNodePath(Node: TTreeNode): string;
var
  NodeData: TJSONNodeData;
  Path: string;
begin
  Path := '';
  
  while Assigned(Node) do
  begin
    if Assigned(Node.Data) then
    begin
      NodeData := TJSONNodeData(Node.Data);
      
      if NodeData.Key <> '' then
      begin
        if Path = '' then
          Path := NodeData.Key
        else
          Path := NodeData.Key + '/' + Path;
      end;
    end;
    
    Node := Node.Parent;
  end;
  
  Result := Path;
end;

procedure TJSONTreeView.Loaded;
begin
  inherited;
  
  // 控件加载完成后，恢复展开状态
  if Assigned(FRootJSON) then
    RestoreExpandedState;
end;

procedure TJSONTreeView.LoadJSON(JSONValue: TJSONValue);
begin
  // 保存当前展开状态
  if Assigned(FRootJSON) then
    SaveExpandedState;
    
  // 清除现有节点
  Items.Clear;
  ClearNodeData;
  
  // 保存新的JSON
  FRootJSON := JSONValue;
  
  if not Assigned(JSONValue) then
    Exit;
    
  // 添加根节点
  if JSONValue is TJSONObject then
    AddJSONObjectNode(nil, TJSONObject(JSONValue))
  else if JSONValue is TJSONArray then
    AddJSONArrayNode(nil, TJSONArray(JSONValue))
  else
    AddJSONNode(nil, JSONValue);
    
  // 恢复展开状态
  RestoreExpandedState;
end;

procedure TJSONTreeView.RestoreExpandedState;
var
  i: Integer;
  Node: TTreeNode;
begin
  if FExpandedNodes.Count = 0 then
    Exit;
    
  for i := 0 to Items.Count - 1 do
  begin
    Node := Items[i];
    ExpandNodeIfNeeded(Node);
  end;
end;

procedure TJSONTreeView.SaveExpandedState;
var
  i: Integer;
  Node: TTreeNode;
  Path: string;
begin
  FExpandedNodes.Clear;
  
  for i := 0 to Items.Count - 1 do
  begin
    Node := Items[i];
    
    if Node.Expanded then
    begin
      Path := GetNodePath(Node);
      if Path <> '' then
        FExpandedNodes.Add(Path, True);
    end;
  end;
end;

end.
