unit ConfigTree;

interface

uses
  System.SysUtils, System.Classes, Vcl.ComCtrls, Vcl.Menus, Vcl.Controls,
  System.Generics.Collections, ConfigManager, ConfigTypes, System.IOUtils, System.IniFiles, System.JSON;

type
  // 树节点类型
  TNodeType = (ntCategory, ntProperty, ntPropertyEntity, ntSection);

  // 树节点数据结构
  PNodeData = ^TNodeData;
  TNodeData = record
    NodeType: TNodeType;      // 节点类型
    CategoryName: string;     // 分类名称
    PropertyName: string;     // 属性名称
    SectionName: string;      // 节名称
    ConfigType: string;       // 配置类型
    ConfigPath: string;       // 配置路径
  end;

// 初始化树型视图的分类结构
procedure InitializeTreeCategories(TreeView: TTreeView);

// 添加属性实体到对应的分类中
procedure AddPropertyEntityToCategory(TreeView: TTreeView; 
  const CategoryName, PropertyName, ConfigType, ConfigPath: string);

// 根据配置文件自动添加到相应分类
procedure AddConfigFileToTree(TreeView: TTreeView; 
  const FileName, ConfigType, ConfigPath: string);

// 创建或更新右键菜单
procedure UpdateTreeContextMenu(TreeView: TTreeView; PopupMenu: TPopupMenu);

// 清理树型视图中的数据，防止内存泄漏
procedure CleanupTreeData(TreeView: TTreeView);

// 获取当前选中节点的数据
function GetSelectedNodeData(TreeView: TTreeView): PNodeData;

// 查找指定目录下的所有符合掩码的文件
procedure FindAllFiles(FileList: TStrings; const Directory, FileMask: string; 
  RecursiveSearch: Boolean = False);

// 从配置文件中读取属性实体并添加到树中
procedure LoadPropertiesFromConfigFile(TreeView: TTreeView; const ConfigPath: string);

// 切换显示/隐藏没有子节点的分类
procedure ToggleEmptyCategories(TreeView: TTreeView);

// 添加节到对应的分类中
procedure AddSectionToCategory(TreeView: TTreeView; 
  const CategoryName, SectionName, ConfigType, ConfigPath: string);

// 从JSON文件中读取属性实体
procedure LoadPropertiesFromJSONFile(TreeView: TTreeView; const FilePath: string);

// 查找指定文本的节点
function FindNodeByText(TreeView: TTreeView; const NodeText: string): TTreeNode;

// 查找指定父节点下的特定文本节点
function FindNodeByTextAndParent(TreeView: TTreeView; const NodeText, ParentText: string): TTreeNode;

// 检查节点是否为INI分类或其子节点
function IsIniCategory(Node: TTreeNode): Boolean;

// 检查节点是否为特殊编辑器分类
function IsSpecialEditorCategory(Node: TTreeNode): Boolean;

// 查找或创建分类节点
function FindOrCreateCategoryNode(TreeView: TTreeView; const CategoryName: string): TTreeNode;

implementation

// 默认的分类列表
const
  DEFAULT_CATEGORIES: array[0..16] of string = (
    '基础配置',
    '数据库配置',
    '文件类型管理',
    '路径定义',
    '运行参数',
    '网络基础参数',
    '打印设置',
    '邮件服务配置',
    '本地化设置',
    '报表参数',
    '定时任务配置',
    '页面布局配置',
    '字体属性配置',
    '用户权限树',
    '多媒体内容配置',
    '动态表单配置',
    '工作流配置'
  );

var
  ShowEmptyCategories: Boolean = True; // 全局变量记录当前状态

// 根据文件名推断适合的分类
function GetCategoryByFileName(const FileName: string): string;
var
  LowerName: string;
begin
  LowerName := LowerCase(ExtractFileName(FileName));
  
  // 检查特定文件名，将其放入特定分类
  // Base Config
  if (Pos('base_config', LowerName) > 0) or
     (Pos('settings', LowerName) > 0) or
     (Pos('app', LowerName) > 0) or
     (Pos('start', LowerName) > 0) then
    Result := '基础配置'
  
  // Database
  else if (Pos('db', LowerName) > 0) or 
          (Pos('database', LowerName) > 0) or
          (Pos('sql', LowerName) > 0) then
    Result := '数据库配置'
  else if Pos('file', LowerName) > 0 then
    Result := '文件类型管理'
  else if Pos('path', LowerName) > 0 then
    Result := '路径定义'
  else if Pos('param', LowerName) > 0 then
    Result := '运行参数'
  else if Pos('network', LowerName) > 0 then
    Result := '网络基础参数'
  else if Pos('print', LowerName) > 0 then
    Result := '打印设置'
  else if Pos('mail', LowerName) > 0 then
    Result := '邮件服务配置'
  else if Pos('local', LowerName) > 0 then
    Result := '本地化设置'
  else if Pos('report', LowerName) > 0 then
    Result := '报表参数'
  else if Pos('task', LowerName) > 0 then
    Result := '定时任务配置'
  else if Pos('layout', LowerName) > 0 then
    Result := '页面布局配置'
  else if Pos('font', LowerName) > 0 then
    Result := '字体属性配置'
  else if Pos('permission', LowerName) > 0 then
    Result := '用户权限树'
  else if Pos('media', LowerName) > 0 then
    Result := '多媒体内容配置'
  else if Pos('form', LowerName) > 0 then
    Result := '动态表单配置'
  else if Pos('workflow', LowerName) > 0 then
    Result := '工作流配置'
  else
    Result := '其他配置'; // 默认分类
end;

// 查找指定文本的节点
function FindNodeByText(TreeView: TTreeView; const NodeText: string): TTreeNode;
var
  i: Integer;
begin
  Result := nil;
  
  if not Assigned(TreeView) then
    Exit;
    
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if SameText(TreeView.Items[i].Text, NodeText) then
    begin
      Result := TreeView.Items[i];
      Break;
    end;
  end;
end;

// 查找指定父节点下的特定文本节点
function FindNodeByTextAndParent(TreeView: TTreeView; const NodeText, ParentText: string): TTreeNode;
var
  i: Integer;
  ParentNode: TTreeNode;
begin
  Result := nil;
  
  if not Assigned(TreeView) then
    Exit;
    
  // 先查找父节点
  ParentNode := FindNodeByText(TreeView, ParentText);
  if not Assigned(ParentNode) then
    Exit;
    
  // 在父节点下查找子节点
  for i := 0 to ParentNode.Count - 1 do
  begin
    if SameText(ParentNode.Item[i].Text, NodeText) then
    begin
      Result := ParentNode.Item[i];
      Break;
    end;
  end;
end;

// 查找或创建分类节点
function FindOrCreateCategoryNode(TreeView: TTreeView; const CategoryName: string): TTreeNode;
begin
  // 查找现有节点
  Result := FindNodeByText(TreeView, CategoryName);
  
  // 如果不存在，则创建
  if not Assigned(Result) then
  begin
    Result := TreeView.Items.AddChild(nil, CategoryName);
    Result.ImageIndex := 0;  // 使用文件夹图标
    Result.SelectedIndex := 0;
  end;
end;

// 检查节点是否为INI分类或其子节点
function IsIniCategory(Node: TTreeNode): Boolean;
begin
  Result := False;
  
  if not Assigned(Node) then
    Exit;
    
  // 检查当前节点
  if SameText(Node.Text, 'INI配置') or SameText(Node.Text, '基础配置') then
    Result := True
  // 检查父节点
  else if (Node.Parent <> nil) and 
          (SameText(Node.Parent.Text, 'INI配置') or SameText(Node.Parent.Text, '基础配置')) then
    Result := True;
end;

// 检查节点是否为特殊编辑器分类
function IsSpecialEditorCategory(Node: TTreeNode): Boolean;
begin
  Result := False;
  
  if not Assigned(Node) then
    Exit;
    
  // 检查当前节点是否为特殊编辑器分类
  Result := SameText(Node.Text, '字体配置') or
            SameText(Node.Text, '位置配置') or
            SameText(Node.Text, '背景配置') or
            SameText(Node.Text, '数据库配置') or
            SameText(Node.Text, '路径配置');
            
  // 或者检查父节点是否为特殊编辑器分类
  if (not Result) and (Node.Parent <> nil) then
  begin
    Result := SameText(Node.Parent.Text, '字体配置') or
              SameText(Node.Parent.Text, '位置配置') or
              SameText(Node.Parent.Text, '背景配置') or
              SameText(Node.Parent.Text, '数据库配置') or
              SameText(Node.Parent.Text, '路径配置');
  end;
end;

procedure InitializeTreeCategories(TreeView: TTreeView);
var
  i: Integer;
begin
  // 清空现有节点
  TreeView.Items.BeginUpdate;
  try
    // 添加所有默认分类
    for i := 0 to High(DEFAULT_CATEGORIES) do
      FindOrCreateCategoryNode(TreeView, DEFAULT_CATEGORIES[i]);
  finally
    TreeView.Items.EndUpdate;
  end;
end;

procedure AddPropertyEntityToCategory(TreeView: TTreeView; 
  const CategoryName, PropertyName, ConfigType, ConfigPath: string);
var
  CategoryNode, PropertyNode: TTreeNode;
  NodeData: PNodeData;
begin
  TreeView.Items.BeginUpdate;
  try
    // 查找或创建分类节点
    CategoryNode := FindOrCreateCategoryNode(TreeView, CategoryName);
    
    // 为属性创建子节点
    PropertyNode := TreeView.Items.AddChild(CategoryNode, PropertyName);
    
    // 设置图标索引（假设2是INI文件图标，3是JSON文件图标，4是其他类型图标）
    if SameText(ConfigType, 'INI') then
      PropertyNode.ImageIndex := 2
    else if SameText(ConfigType, 'JSON') then
      PropertyNode.ImageIndex := 3
    else
      PropertyNode.ImageIndex := 4;
    
    PropertyNode.SelectedIndex := PropertyNode.ImageIndex;
    
    // 创建并关联节点数据
    New(NodeData);
    NodeData.NodeType := ntPropertyEntity;
    NodeData.CategoryName := CategoryName;
    NodeData.PropertyName := PropertyName;
    NodeData.ConfigType := ConfigType;
    NodeData.ConfigPath := ConfigPath;
    PropertyNode.Data := NodeData;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

procedure AddConfigFileToTree(TreeView: TTreeView; 
  const FileName, ConfigType, ConfigPath: string);
var
  CategoryName: string;
begin
  // 根据文件名推断适合的分类
  CategoryName := GetCategoryByFileName(FileName);
  
  // 添加属性实体到对应分类
  AddPropertyEntityToCategory(
    TreeView, 
    CategoryName, 
    ExtractFileName(FileName), 
    ConfigType, 
    ConfigPath
  );
end;

procedure UpdateTreeContextMenu(TreeView: TTreeView; PopupMenu: TPopupMenu);
var
  SelectedNode: TTreeNode;
  NodeData: PNodeData;
  CategoryMenu, EntityMenu: Boolean;
begin
  // 获取当前选中节点
  SelectedNode := TreeView.Selected;
  
  if (SelectedNode <> nil) and (SelectedNode.Data <> nil) then
  begin
    NodeData := PNodeData(SelectedNode.Data);
    
    // 根据节点类型确定显示哪种菜单
    CategoryMenu := (NodeData.NodeType = ntCategory);
    EntityMenu := (NodeData.NodeType = ntPropertyEntity);
    
    // 为每个菜单项设置可见性
    for var i := 0 to PopupMenu.Items.Count - 1 do
    begin
      case PopupMenu.Items[i].Tag of
        1: PopupMenu.Items[i].Visible := CategoryMenu or EntityMenu; // 打开
        2: PopupMenu.Items[i].Visible := CategoryMenu;              // 新建
        3: PopupMenu.Items[i].Visible := EntityMenu;                // 删除
        4: PopupMenu.Items[i].Visible := EntityMenu;                // 重命名
      else
        PopupMenu.Items[i].Visible := True;
      end;
    end;
  end;
end;

procedure CleanupTreeData(TreeView: TTreeView);
var
  i: Integer;
begin
  // 释放所有节点关联的数据对象
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if TreeView.Items[i].Data <> nil then
    begin
      Dispose(PNodeData(TreeView.Items[i].Data));
      TreeView.Items[i].Data := nil;
    end;
  end;
end;

function GetSelectedNodeData(TreeView: TTreeView): PNodeData;
var
  SelectedNode: TTreeNode;
begin
  Result := nil;
  SelectedNode := TreeView.Selected;
  
  if (SelectedNode <> nil) and (SelectedNode.Data <> nil) then
    Result := PNodeData(SelectedNode.Data);
end;

procedure FindAllFiles(FileList: TStrings; const Directory, FileMask: string; 
  RecursiveSearch: Boolean = False);
var
  SearchRec: TSearchRec;
  FindResult: Integer;
  Path: string;
begin
  if not Assigned(FileList) then
    Exit;
    
  Path := IncludeTrailingPathDelimiter(Directory);
  
  // 查找符合掩码的文件
  FindResult := FindFirst(Path + FileMask, faAnyFile and not faDirectory, SearchRec);
  try
    while FindResult = 0 do
    begin
      FileList.Add(Path + SearchRec.Name);
      FindResult := FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec);
  end;
  
  // 如果需要递归查找子目录
  if RecursiveSearch then
  begin
    FindResult := FindFirst(Path + '*.*', faDirectory, SearchRec);
    try
      while FindResult = 0 do
      begin
        // 排除 . 和 .. 目录
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
           ((SearchRec.Attr and faDirectory) = faDirectory) then
        begin
          FindAllFiles(FileList, Path + SearchRec.Name, FileMask, RecursiveSearch);
        end;
        FindResult := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec);
    end;
  end;
end;

// 从INI文件中读取属性实体
procedure LoadPropertiesFromINIFile(TreeView: TTreeView; const FilePath: string);
var
  IniFile: TIniFile;
  Sections: TStringList;
  i: Integer;
  FileName, SectionName: string;
  CategoryName: string;
begin
  IniFile := nil;
  Sections := TStringList.Create;
  
  try
    try
      IniFile := TIniFile.Create(FilePath);
      
      // 获取文件中的所有节
      IniFile.ReadSections(Sections);
      
      // 确定分类名称
      FileName := ExtractFileName(FilePath);
      CategoryName := GetCategoryByFileName(FileName);
      
      // 如果找不到合适的分类，则使用基础配置
      if CategoryName = '其他配置' then
        CategoryName := '基础配置';
      
      // 从每个节中读取键值对，作为属性实体添加到树中
      for i := 0 to Sections.Count - 1 do
      begin
        SectionName := Sections[i];
        
        // 跳过注释或空节
        if (SectionName = '') or (SectionName[1] = ';') then
          Continue;
        
        // 将节添加到树中
        AddSectionToCategory(
          TreeView, 
          CategoryName, 
          SectionName, 
          'INI',
          FilePath
        );
      end;
      
      // 如果没有节，添加一个默认节点
      if Sections.Count = 0 then
      begin
        AddSectionToCategory(
          TreeView, 
          CategoryName, 
          'General', 
          'INI',
          FilePath
        );
      end;
    except
      on E: Exception do
      begin
        // 出错时添加错误提示作为属性
        AddPropertyEntityToCategory(
          TreeView, 
          CategoryName, 
          '无法读取：' + ExtractFileName(FilePath) + ' (' + E.Message + ')', 
          'ERR',
          FilePath
        );
      end;
    end;
  finally
    Sections.Free;
    if IniFile <> nil then
      IniFile.Free;
  end;
end;

// 从JSON文件中读取属性实体
procedure LoadPropertiesFromJSONFile(TreeView: TTreeView; const FilePath: string);
var
  JsonString: string;
  JsonValue: TJSONValue;
  Root: TJSONObject;
  FileName: string;
  CategoryName: string;
begin
  try
    // 初始化JsonValue为nil
    JsonValue := nil;
    
    try
      // 读取JSON文件内容
      JsonString := TFile.ReadAllText(FilePath, TEncoding.UTF8);
      JsonValue := TJSONObject.ParseJSONValue(JsonString);
      
      // 确定分类名称
      FileName := ExtractFileName(FilePath);
      CategoryName := GetCategoryByFileName(FileName);
      
      // 如果找不到合适的分类，则使用基础配置
      if CategoryName = '其他配置' then
        CategoryName := '基础配置';
      
      if (JsonValue <> nil) and (JsonValue is TJSONObject) then
      begin
        Root := TJSONObject(JsonValue);
        
        // 对于JSON文件，只添加一个根节点
        AddSectionToCategory(
          TreeView, 
          CategoryName, 
          'JSON根节点', 
          'JSON',
          FilePath
        );
      end;
    finally
      if JsonValue <> nil then
        JsonValue.Free;
    end;
  except
    on E: Exception do
    begin
      // 出错时添加错误提示作为属性
      AddPropertyEntityToCategory(
        TreeView, 
        CategoryName, 
        '无法读取：' + ExtractFileName(FilePath) + ' (' + E.Message + ')', 
        'ERR',
        FilePath
      );
    end;
  end;
end;

procedure LoadPropertiesFromConfigFile(TreeView: TTreeView; const ConfigPath: string);
var
  FileExt: string;
begin
  // 根据文件扩展名调用不同的加载方法
  FileExt := LowerCase(ExtractFileExt(ConfigPath));
  
  if FileExt = '.ini' then
    LoadPropertiesFromINIFile(TreeView, ConfigPath)
  else if FileExt = '.json' then
    LoadPropertiesFromJSONFile(TreeView, ConfigPath);
end;

// 切换显示/隐藏没有子节点的分类
procedure ToggleEmptyCategories(TreeView: TTreeView);
var
  i: Integer;
  NodeData: PNodeData;
  HasChildren: Boolean;
  Node: TTreeNode;
begin
  // 切换状态
  ShowEmptyCategories := not ShowEmptyCategories;
  
  // 遍历所有根节点（分类节点）
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    Node := TreeView.Items[i];
    
    // 只处理根级别的节点（分类节点）
    if (Node.Level = 0) and (Node.Data <> nil) then
    begin
      NodeData := PNodeData(Node.Data);
      
      // 确保这是分类节点
      if NodeData.NodeType = ntCategory then
      begin
        // 检查是否有子节点
        HasChildren := Node.Count > 0;
        
        // 根据ShowEmptyCategories的值和是否有子节点决定显示状态
        if not HasChildren then
        begin
          if ShowEmptyCategories then
            Node.Text := NodeData.CategoryName // 显示节点
          else
            Node.Text := ''; // 隐藏节点内容，让它看起来像隐藏了
        end;
      end;
    end;
  end;
end;

// 添加节到对应的分类中
procedure AddSectionToCategory(TreeView: TTreeView; 
  const CategoryName, SectionName, ConfigType, ConfigPath: string);
var
  CategoryNode, SectionNode: TTreeNode;
  NodeData: PNodeData;
  i: Integer;
begin
  try
    TreeView.Items.BeginUpdate;
    try
      // 找到或创建分类节点
      CategoryNode := FindOrCreateCategoryNode(TreeView, CategoryName);
      
      // 检查该节是否已存在
      SectionNode := nil;
      if CategoryNode.HasChildren then
      begin
        for i := 0 to CategoryNode.Count - 1 do
        begin
          if CategoryNode.Item[i].Data <> nil then
          begin
            var Data := PNodeData(CategoryNode.Item[i].Data);
            if (Data.NodeType = ntSection) and 
               (Data.SectionName = SectionName) and 
               (Data.ConfigPath = ConfigPath) then
            begin
              SectionNode := CategoryNode.Item[i];
              Break;
            end;
          end;
        end;
      end;
      
      // 如果节不存在，则创建
      if SectionNode = nil then
      begin
        // 为节创建子节点，使用系统默认编码
        SectionNode := TreeView.Items.AddChild(CategoryNode, SectionName);
        
        // 设置图标索引
        if SameText(ConfigType, 'INI') then
          SectionNode.ImageIndex := 5
        else if SameText(ConfigType, 'JSON') then
          SectionNode.ImageIndex := 6
        else
          SectionNode.ImageIndex := 7;
        
        SectionNode.SelectedIndex := SectionNode.ImageIndex;
        
        // 创建并关联节点数据
        New(NodeData);
        NodeData.NodeType := ntSection;
        NodeData.CategoryName := CategoryName;
        NodeData.SectionName := SectionName; // 存储节名称
        NodeData.PropertyName := '';
        NodeData.ConfigType := ConfigType;
        NodeData.ConfigPath := ConfigPath;
        SectionNode.Data := NodeData;
      end;
    finally
      TreeView.Items.EndUpdate;
    end;
  except
    on E: Exception do
    begin
      // 可以在这里添加错误处理逻辑
      // 例如，写入日志或显示错误消息
      var ErrorMsg := Format('添加节到分类时出错: 分类=%s, 节=%s, 错误=%s', 
                       [CategoryName, SectionName, E.Message]);
      // 注意：这里不应该直接调用UI相关函数，如ShowMessage，因为这个函数可能在非UI线程中调用
    end;
  end;
end;

end. 