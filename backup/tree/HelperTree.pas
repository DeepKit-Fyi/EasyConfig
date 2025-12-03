unit HelperTree;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls, Winapi.Windows, Winapi.Messages,
  System.IOUtils, System.JSON, System.Generics.Collections, Vcl.Graphics;

// TreeView鎵╁睍鍔熻兘
type
  // 鏍戣妭鐐规暟鎹褰?
  TNodeData = record
    FilePath: string;
    FileType: string;
    ObjectType: string;
    Tag: Integer;
    Data: Pointer;
  end;
  PNodeData = ^TNodeData;

// 鍒涘缓鏂拌妭鐐规暟鎹?
function CreateNodeData(const FilePath: string = ''; const FileType: string = ''; 
  const ObjectType: string = ''; Tag: Integer = 0; Data: Pointer = nil): PNodeData;

// 閲婃斁鑺傜偣鏁版嵁
procedure FreeNodeData(Data: PNodeData);

// 閲婃斁TreeView涓墍鏈夎妭鐐规暟鎹?
procedure ClearTreeNodeData(TreeView: TTreeView);

// 鏌ユ壘鎸囧畾璺緞鐨勮妭鐐?
function FindNodeByPath(TreeView: TTreeView; const Path: string): TTreeNode;

// 鏍规嵁鎵╁睍鍚嶈幏鍙栭€傚綋鐨勫浘鍍忕储寮?
function GetImageIndexForFile(const FileName: string; ImageListHasFolder: Boolean = True): Integer;

// 浠庣洰褰曞垱寤烘爲缁撴瀯
procedure BuildTreeFromDirectory(TreeView: TTreeView; const RootDir: string; 
  ShowFiles: Boolean = True; FileMask: string = '*.*');

// 浠庣洰褰曞姞杞芥爲
procedure LoadTreeFromDirectory(TreeView: TTreeView; const RootDir: string);

// 鍔犺浇鐩綍鍐呭
procedure LoadDirectoryContents(TreeView: TTreeView; ParentNode: TTreeNode; const DirPath: string);

// 浠庤妭鐐瑰垱寤鸿矾寰?
function GetNodePath(Node: TTreeNode): string;

// 鎵╁睍鏍戝埌鎸囧畾娣卞害
procedure ExpandTreeToLevel(TreeView: TTreeView; Level: Integer);

// 璁剧疆鑺傜偣瀛椾綋棰滆壊
procedure SetNodeFontColor(Node: TTreeNode; Color: TColor);

// 璁剧疆鑺傜偣鏂囨湰鍔犵矖
procedure SetNodeTextBold(Node: TTreeNode; Bold: Boolean);

// 璁剧疆鑺傜偣鏂囨湰鏂滀綋
procedure SetNodeTextItalic(Node: TTreeNode; Italic: Boolean);

// 璁剧疆鑺傜偣鏂囨湰涓嬪垝绾?
procedure SetNodeTextUnderline(Node: TTreeNode; Underline: Boolean);

// 璁剧疆鑺傜偣瀛椾綋澶у皬
procedure SetNodeFontSize(Node: TTreeNode; Size: Integer);

// 灏員reeView鑺傜偣淇濆瓨鍒癑SON
function TreeViewToJSON(TreeView: TTreeView): TJSONObject;

// 浠嶫SON鍔犺浇TreeView鑺傜偣
procedure JSONToTreeView(TreeView: TTreeView; JSON: TJSONObject);

implementation

// 鍒涘缓鏂拌妭鐐规暟鎹?
function CreateNodeData(const FilePath, FileType, ObjectType: string; Tag: Integer; Data: Pointer): PNodeData;
begin
  New(Result);
  Result^.FilePath := FilePath;
  Result^.FileType := FileType;
  Result^.ObjectType := ObjectType;
  Result^.Tag := Tag;
  Result^.Data := Data;
end;

// 閲婃斁鑺傜偣鏁版嵁
procedure FreeNodeData(Data: PNodeData);
begin
  if Data <> nil then
    Dispose(Data);
end;

// 閲婃斁TreeView涓墍鏈夎妭鐐规暟鎹?
procedure ClearTreeNodeData(TreeView: TTreeView);
var
  i: Integer;
begin
  if not Assigned(TreeView) then
    Exit;
    
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if TreeView.Items[i].Data <> nil then
    begin
      FreeNodeData(PNodeData(TreeView.Items[i].Data));
      TreeView.Items[i].Data := nil;
    end;
  end;
end;

// 鏌ユ壘鎸囧畾璺緞鐨勮妭鐐?
function FindNodeByPath(TreeView: TTreeView; const Path: string): TTreeNode;
var
  i: Integer;
  NodeData: PNodeData;
begin
  Result := nil;
  
  if not Assigned(TreeView) then
    Exit;
    
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if TreeView.Items[i].Data <> nil then
    begin
      NodeData := PNodeData(TreeView.Items[i].Data);
      if SameText(NodeData^.FilePath, Path) then
      begin
        Result := TreeView.Items[i];
        Break;
      end;
    end;
  end;
end;

// 鏍规嵁鎵╁睍鍚嶈幏鍙栭€傚綋鐨勫浘鍍忕储寮?
function GetImageIndexForFile(const FileName: string; ImageListHasFolder: Boolean): Integer;
var
  Ext: string;
begin
  if ImageListHasFolder and (FileName = '') then
  begin
    // 鏍圭洰褰?
    Result := 0;
    Exit;
  end;
  
  if ImageListHasFolder and System.SysUtils.DirectoryExists(FileName) then
  begin
    // 鏂囦欢澶?
    Result := 0; // 鍋囪鏂囦欢澶瑰浘鏍囩储寮曚负0
    Exit;
  end;
  
  // 鏍规嵁鏂囦欢鎵╁睍鍚嶇‘瀹氬浘鏍?
  Ext := LowerCase(ExtractFileExt(FileName));
  
  if Ext = '.json' then
    Result := 1  // 鍋囪JSON鏂囦欢鍥炬爣绱㈠紩涓?
  else if Ext = '.xml' then
    Result := 2  // 鍋囪XML鏂囦欢鍥炬爣绱㈠紩涓?
  else if Ext = '.ini' then
    Result := 3  // 鍋囪INI鏂囦欢鍥炬爣绱㈠紩涓?
  else if Ext = '.txt' then
    Result := 4  // 鍋囪TXT鏂囦欢鍥炬爣绱㈠紩涓?
  else if Ext = '.cfg' then
    Result := 5  // 鍋囪CFG鏂囦欢鍥炬爣绱㈠紩涓?
  else
    Result := 6; // 鍋囪榛樿鏂囦欢鍥炬爣绱㈠紩涓?
end;

// 浠庣洰褰曞垱寤烘爲缁撴瀯
procedure BuildTreeFromDirectory(TreeView: TTreeView; const RootDir: string; 
  ShowFiles: Boolean = True; FileMask: string = '*.*');
begin
  // 鐩存帴璋冪敤鏂扮殑瀹炵幇鏂规硶
  LoadTreeFromDirectory(TreeView, RootDir);
end;

// 浠庣洰褰曞姞杞芥爲
procedure LoadTreeFromDirectory(TreeView: TTreeView; const RootDir: string);
var
  RootNode: TTreeNode;
  RootNodeData: PNodeData;
begin
  if not Assigned(TreeView) or not System.SysUtils.DirectoryExists(RootDir) then
    Exit;
    
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    
    // 鍒涘缓鏍硅妭鐐?
    RootNode := TreeView.Items.Add(nil, ExtractFileName(RootDir));
    
    // 璁剧疆鏍硅妭鐐规暟鎹?
    New(RootNodeData);
    RootNodeData^.FilePath := RootDir;
    RootNodeData^.FileType := 'Directory';
    RootNode.Data := RootNodeData;
    
    // 浣跨敤System.IOUtils涓殑鍑芥暟鍔犺浇鐩綍鍐呭
    LoadDirectoryContents(TreeView, RootNode, RootDir);
    
    // 灞曞紑鏍硅妭鐐?
    RootNode.Expand(False);
  finally
    TreeView.Items.EndUpdate;
  end;
end;

// 鍔犺浇鐩綍鍐呭
procedure LoadDirectoryContents(TreeView: TTreeView; ParentNode: TTreeNode; const DirPath: string);
var
  Files, Directories: TArray<string>;
  FileName: string;
  Node: TTreeNode;
  NodeData: PNodeData;
begin
  try
    // 鑾峰彇鎵€鏈夊瓙鐩綍
    Directories := TDirectory.GetDirectories(DirPath);
    for FileName in Directories do
    begin
      Node := TreeView.Items.AddChild(ParentNode, ExtractFileName(FileName));
      
      New(NodeData);
      NodeData^.FilePath := FileName;
      NodeData^.FileType := 'Directory';
      Node.Data := NodeData;
      
      // 閫掑綊澶勭悊瀛愮洰褰?
      LoadDirectoryContents(TreeView, Node, FileName);
    end;
    
    // 鑾峰彇鎵€鏈夋枃浠?
    Files := TDirectory.GetFiles(DirPath);
    for FileName in Files do
    begin
      Node := TreeView.Items.AddChild(ParentNode, ExtractFileName(FileName));
      
      New(NodeData);
      NodeData^.FilePath := FileName;
      NodeData^.FileType := 'File';
      Node.Data := NodeData;
    end;
  except
    // 鎹曡幏鍙兘鐨勫紓甯革紝濡傝闂潈闄愰敊璇?
    on E: Exception do
    begin
      // 杩欓噷鍙互璁板綍閿欒鎴栨坊鍔犱竴涓敊璇妭鐐?
      Node := TreeView.Items.AddChild(ParentNode, '[Error: ' + E.Message + ']');
    end;
  end;
end;

// 浠庤妭鐐瑰垱寤鸿矾寰?
function GetNodePath(Node: TTreeNode): string;
begin
  Result := '';
  
  if not Assigned(Node) then
    Exit;
    
  if Node.Data <> nil then
    Result := PNodeData(Node.Data)^.FilePath
  else
  begin
    // 濡傛灉鑺傜偣娌℃湁鍏宠仈鏁版嵁锛屽垯鏋勫缓璺緞
    if Assigned(Node.Parent) then
      Result := GetNodePath(Node.Parent) + '\' + Node.Text
    else
      Result := Node.Text;
  end;
end;

// 鎵╁睍鏍戝埌鎸囧畾娣卞害
procedure ExpandTreeToLevel(TreeView: TTreeView; Level: Integer);

  procedure ExpandNode(Node: TTreeNode; CurrentLevel, TargetLevel: Integer);
  var
    i: Integer;
  begin
    if CurrentLevel <= TargetLevel then
    begin
      Node.Expand(False);
      for i := 0 to Node.Count - 1 do
        ExpandNode(Node.Item[i], CurrentLevel + 1, TargetLevel);
    end;
  end;
  
begin
  if not Assigned(TreeView) then
    Exit;
    
  TreeView.Items.BeginUpdate;
  try
    if TreeView.Items.Count > 0 then
    begin
      for var i := 0 to TreeView.Items.Count - 1 do
      begin
        if TreeView.Items[i].Level = 0 then
          ExpandNode(TreeView.Items[i], 0, Level);
      end;
    end;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

// 璁剧疆鑺傜偣瀛椾綋棰滆壊
procedure SetNodeFontColor(Node: TTreeNode; Color: TColor);
var
  TreeView: TTreeView;
begin
  if not Assigned(Node) then 
    Exit;

  TreeView := TTreeView(Node.TreeView);
  if not Assigned(TreeView) then
    Exit;

  // 瀛樺偍棰滆壊淇℃伅鍒拌妭鐐规暟鎹?
  if Node.Data <> nil then
  begin
    // 濡傛灉宸叉湁鏁版嵁锛屾洿鏂伴鑹蹭俊鎭?
    PNodeData(Node.Data)^.Tag := Integer(Color);
  end;
  
  // 寮哄埗閲嶇粯鑺傜偣
  TreeView.Invalidate;
end;

// 璁剧疆鑺傜偣鏂囨湰鍔犵矖
procedure SetNodeTextBold(Node: TTreeNode; Bold: Boolean);
var
  TreeView: TTreeView;
begin
  if not Assigned(Node) then 
    Exit;

  TreeView := TTreeView(Node.TreeView);
  if not Assigned(TreeView) then
    Exit;

  // 鍦∣nCustomDrawItem浜嬩欢涓娇鐢⊿tateIndex鏉ヨ缃瓧浣撴牱寮?
  if Bold then
    Node.StateIndex := 1 // 琛ㄧず绮椾綋
  else
    Node.StateIndex := 0; // 鏅€氭牱寮?
    
  // 寮哄埗閲嶇粯鑺傜偣
  TreeView.Invalidate;
end;

// 璁剧疆鑺傜偣鏂囨湰鏂滀綋
procedure SetNodeTextItalic(Node: TTreeNode; Italic: Boolean);
var
  TreeView: TTreeView;
begin
  if not Assigned(Node) then 
    Exit;

  TreeView := TTreeView(Node.TreeView);
  if not Assigned(TreeView) then
    Exit;

  // 鍦∣nCustomDrawItem浜嬩欢涓娇鐢⊿tateIndex鏉ヨ缃瓧浣撴牱寮?
  if Italic then
    Node.StateIndex := 2 // 琛ㄧず鏂滀綋
  else
    Node.StateIndex := 0; // 鏅€氭牱寮?
    
  // 寮哄埗閲嶇粯鑺傜偣
  TreeView.Invalidate;
end;

// 璁剧疆鑺傜偣鏂囨湰涓嬪垝绾?
procedure SetNodeTextUnderline(Node: TTreeNode; Underline: Boolean);
var
  TreeView: TTreeView;
begin
  if not Assigned(Node) then 
    Exit;

  TreeView := TTreeView(Node.TreeView);
  if not Assigned(TreeView) then
    Exit;

  // 鍦∣nCustomDrawItem浜嬩欢涓娇鐢⊿tateIndex鏉ヨ缃瓧浣撴牱寮?
  if Underline then
    Node.StateIndex := 3 // 琛ㄧず涓嬪垝绾?
  else
    Node.StateIndex := 0; // 鏅€氭牱寮?
    
  // 寮哄埗閲嶇粯鑺傜偣
  TreeView.Invalidate;
end;

// 璁剧疆鑺傜偣瀛椾綋澶у皬
procedure SetNodeFontSize(Node: TTreeNode; Size: Integer);
var
  TreeView: TTreeView;
  NodeData: PNodeData;
begin
  if not Assigned(Node) then
    Exit;
    
  TreeView := TTreeView(Node.TreeView);
  if not Assigned(TreeView) then
    Exit;

  // 纭繚鑺傜偣鏈夋暟鎹?
  if Node.Data = nil then
  begin
    NodeData := CreateNodeData('', '', '', Size);
    Node.Data := NodeData;
  end
  else
  begin
    NodeData := PNodeData(Node.Data);
    // 浣跨敤Tag瀛楁瀛樺偍瀛椾綋澶у皬淇℃伅
    NodeData^.Tag := Size;
  end;
  
  // 寮哄埗閲嶇粯鑺傜偣
  TreeView.Invalidate;
end;

// 灏員reeView鑺傜偣淇濆瓨鍒癑SON
function TreeViewToJSON(TreeView: TTreeView): TJSONObject;

  function NodeToJSON(Node: TTreeNode): TJSONObject;
  var
    NodeArray: TJSONArray;
    i: Integer;
    NodeData: PNodeData;
  begin
    Result := TJSONObject.Create;
    
    Result.AddPair('Text', Node.Text);
    
    if Node.Data <> nil then
    begin
      NodeData := PNodeData(Node.Data);
      Result.AddPair('FilePath', NodeData^.FilePath);
      Result.AddPair('FileType', NodeData^.FileType);
      Result.AddPair('ObjectType', NodeData^.ObjectType);
      Result.AddPair('Tag', TJSONNumber.Create(NodeData^.Tag));
    end;
    
    if Node.Count > 0 then
    begin
      NodeArray := TJSONArray.Create;
      for i := 0 to Node.Count - 1 do
        NodeArray.Add(NodeToJSON(Node.Item[i]));
        
      Result.AddPair('Children', NodeArray);
    end;
  end;
  
var
  RootArray: TJSONArray;
  i: Integer;
begin
  Result := TJSONObject.Create;
  
  if not Assigned(TreeView) or (TreeView.Items.Count = 0) then
    Exit;
    
  RootArray := TJSONArray.Create;
  
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if TreeView.Items[i].Level = 0 then
      RootArray.Add(NodeToJSON(TreeView.Items[i]));
  end;
  
  Result.AddPair('Nodes', RootArray);
end;

// 浠嶫SON鍔犺浇TreeView鑺傜偣
procedure JSONToTreeView(TreeView: TTreeView; JSON: TJSONObject);

  procedure AddChildrenFromJSON(ParentNode: TTreeNode; JSONChildren: TJSONArray);
  var
    i: Integer;
    ChildJSON: TJSONObject;
    ChildNode: TTreeNode;
    NodeData: PNodeData;
    FilePath, FileType, ObjectType: string;
    TagValue: Integer;
  begin
    for i := 0 to JSONChildren.Count - 1 do
    begin
      if not (JSONChildren.Items[i] is TJSONObject) then
        Continue;
        
      ChildJSON := JSONChildren.Items[i] as TJSONObject;
      
      if ChildJSON.TryGetValue<string>('FilePath', FilePath) and 
         ChildJSON.TryGetValue<string>('FileType', FileType) and
         ChildJSON.TryGetValue<string>('ObjectType', ObjectType) then
      begin
        if not ChildJSON.TryGetValue<integer>('Tag', TagValue) then
          TagValue := 0;
          
        ChildNode := TreeView.Items.AddChild(ParentNode, ChildJSON.GetValue<string>('Text'));
        NodeData := CreateNodeData(FilePath, FileType, ObjectType, TagValue);
        ChildNode.Data := NodeData;
        
        if ChildJSON.TryGetValue<TJSONArray>('Children', JSONChildren) then
          AddChildrenFromJSON(ChildNode, JSONChildren);
      end;
    end;
  end;
  
var
  NodesArray: TJSONArray;
begin
  if not Assigned(TreeView) or not Assigned(JSON) then
    Exit;
    
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    
    if JSON.TryGetValue<TJSONArray>('Nodes', NodesArray) then
      AddChildrenFromJSON(nil, NodesArray);
  finally
    TreeView.Items.EndUpdate;
  end;
end;

end. 