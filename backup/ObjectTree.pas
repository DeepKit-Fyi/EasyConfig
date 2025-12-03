unit ObjectTree;

interface

uses
  System.SysUtils, System.Classes, Vcl.ComCtrls, System.Generics.Collections;

type
  // 瀵硅薄鏍戣妭鐐逛俊鎭?
  TObjectNodeInfo = record
    NodePath: string;
    NodeType: string;
    NodeData: Pointer;
  end;
  PObjectNodeInfo = ^TObjectNodeInfo;

  // 瀵硅薄鏍戠鐞嗗櫒
  TObjectTreeManager = class
  private
    FNodeList: TList<PObjectNodeInfo>;
    
    procedure ClearNodes;
    function FindNodeByPath(const Path: string): PObjectNodeInfo;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 鑺傜偣鎿嶄綔
    function AddNode(const Path, NodeType: string; Data: Pointer = nil): PObjectNodeInfo;
    procedure RemoveNode(const Path: string);
    procedure RenameNode(const OldPath, NewPath: string);
    function GetNodeData(const Path: string): Pointer;
    function GetNodeType(const Path: string): string;
    
    // 鏍戣鍥炬搷浣?
    procedure PopulateTreeView(TreeView: TTreeView; const RootPath: string = '');
    function FindTreeNode(TreeView: TTreeView; const Path: string): TTreeNode;
    
    // 鏋勫缓鏍戠粨鏋?
    procedure BuildFromDirectory(const Directory: string; TreeView: TTreeView);
  end;
  
implementation

uses
  System.IOUtils;

{ TObjectTreeManager }

constructor TObjectTreeManager.Create;
begin
  inherited Create;
  FNodeList := TList<PObjectNodeInfo>.Create;
end;

destructor TObjectTreeManager.Destroy;
begin
  ClearNodes;
  FNodeList.Free;
  inherited;
end;

procedure TObjectTreeManager.ClearNodes;
var
  i: Integer;
begin
  for i := 0 to FNodeList.Count - 1 do
    Dispose(FNodeList[i]);
    
  FNodeList.Clear;
end;

function TObjectTreeManager.FindNodeByPath(const Path: string): PObjectNodeInfo;
var
  i: Integer;
begin
  Result := nil;
  
  for i := 0 to FNodeList.Count - 1 do
  begin
    if SameText(FNodeList[i]^.NodePath, Path) then
    begin
      Result := FNodeList[i];
      Break;
    end;
  end;
end;

function TObjectTreeManager.AddNode(const Path, NodeType: string; Data: Pointer): PObjectNodeInfo;
var
  NodeInfo: PObjectNodeInfo;
begin
  // 妫€鏌ヨ妭鐐规槸鍚﹀凡瀛樺湪
  NodeInfo := FindNodeByPath(Path);
  
  if NodeInfo = nil then
  begin
    // 鍒涘缓鏂拌妭鐐?
    New(NodeInfo);
    NodeInfo^.NodePath := Path;
    NodeInfo^.NodeType := NodeType;
    NodeInfo^.NodeData := Data;
    
    FNodeList.Add(NodeInfo);
  end
  else
  begin
    // 鏇存柊鐜版湁鑺傜偣
    NodeInfo^.NodeType := NodeType;
    NodeInfo^.NodeData := Data;
  end;
  
  Result := NodeInfo;
end;

procedure TObjectTreeManager.RemoveNode(const Path: string);
var
  NodeInfo: PObjectNodeInfo;
  Index: Integer;
begin
  NodeInfo := FindNodeByPath(Path);
  
  if NodeInfo <> nil then
  begin
    Index := FNodeList.IndexOf(NodeInfo);
    if Index >= 0 then
    begin
      FNodeList.Delete(Index);
      Dispose(NodeInfo);
    end;
  end;
end;

procedure TObjectTreeManager.RenameNode(const OldPath, NewPath: string);
var
  NodeInfo: PObjectNodeInfo;
begin
  NodeInfo := FindNodeByPath(OldPath);
  
  if NodeInfo <> nil then
    NodeInfo^.NodePath := NewPath;
end;

function TObjectTreeManager.GetNodeData(const Path: string): Pointer;
var
  NodeInfo: PObjectNodeInfo;
begin
  Result := nil;
  
  NodeInfo := FindNodeByPath(Path);
  if NodeInfo <> nil then
    Result := NodeInfo^.NodeData;
end;

function TObjectTreeManager.GetNodeType(const Path: string): string;
var
  NodeInfo: PObjectNodeInfo;
begin
  Result := '';
  
  NodeInfo := FindNodeByPath(Path);
  if NodeInfo <> nil then
    Result := NodeInfo^.NodeType;
end;

procedure TObjectTreeManager.PopulateTreeView(TreeView: TTreeView; const RootPath: string);
var
  i: Integer;
  NodePath: string;
  ParentPath: string;
  ParentNode, Node: TTreeNode;
  j: Integer;
  SkipNode: Boolean;
begin
  if not Assigned(TreeView) then
    Exit;
    
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    
    // 鎸夎矾寰勯暱搴︽帓搴忥紝纭繚鍏堝垱寤虹埗鑺傜偣
    for i := 0 to FNodeList.Count - 1 do
    begin
      NodePath := FNodeList[i]^.NodePath;
      
      // 濡傛灉鎸囧畾浜嗘牴璺緞锛屽垯璺宠繃涓嶅湪璇ヨ矾寰勪笅鐨勮妭鐐?
      if (RootPath <> '') and not NodePath.StartsWith(RootPath) then
        Continue;
        
      // 纭畾鐖惰矾寰?
      ParentPath := ExtractFilePath(NodePath);
      if ParentPath <> '' then
        ParentPath := ExcludeTrailingPathDelimiter(ParentPath);
        
      // 鏌ユ壘鎴栧垱寤虹埗鑺傜偣
      if ParentPath = '' then
        ParentNode := nil
      else
        ParentNode := FindTreeNode(TreeView, ParentPath);
        
      // 妫€鏌ヨ妭鐐规槸鍚﹀凡瀛樺湪
      SkipNode := False;
      for j := 0 to TreeView.Items.Count - 1 do
      begin
        if (TreeView.Items[j].Data <> nil) and 
           (PObjectNodeInfo(TreeView.Items[j].Data)^.NodePath = NodePath) then
        begin
          SkipNode := True;
          Break;
        end;
      end;
      
      if not SkipNode then
      begin
        // 鍒涘缓鑺傜偣
        Node := TreeView.Items.AddChild(ParentNode, ExtractFileName(NodePath));
        Node.Data := FNodeList[i];
        
        // 璁剧疆鑺傜偣鍥炬爣锛堝彲鏍规嵁绫诲瀷璁剧疆涓嶅悓鍥炬爣锛?
        // Node.ImageIndex := ...
      end;
    end;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

function TObjectTreeManager.FindTreeNode(TreeView: TTreeView; const Path: string): TTreeNode;
var
  i: Integer;
begin
  Result := nil;
  
  for i := 0 to TreeView.Items.Count - 1 do
  begin
    if (TreeView.Items[i].Data <> nil) and 
       (PObjectNodeInfo(TreeView.Items[i].Data)^.NodePath = Path) then
    begin
      Result := TreeView.Items[i];
      Break;
    end;
  end;
end;

procedure TObjectTreeManager.BuildFromDirectory(const Directory: string; TreeView: TTreeView);
var
  Files: TArray<string>;
  Dirs: TArray<string>;
  FilePath: string;
  DirPath: string;
  FileExt: string;
  NodeType: string;
begin
  ClearNodes;
  
  // 娣诲姞鏍圭洰褰?
  AddNode(Directory, 'Directory');
  
  // 娣诲姞鎵€鏈夊瓙鐩綍
  Dirs := TDirectory.GetDirectories(Directory, '*', TSearchOption.soAllDirectories);
  for DirPath in Dirs do
    AddNode(DirPath, 'Directory');
    
  // 娣诲姞鎵€鏈夋枃浠?
  Files := TDirectory.GetFiles(Directory, '*.*', TSearchOption.soAllDirectories);
  for FilePath in Files do
  begin
    FileExt := LowerCase(ExtractFileExt(FilePath));
    
    // 鏍规嵁鎵╁睍鍚嶇‘瀹氳妭鐐圭被鍨?
    if FileExt = '.json' then
      NodeType := 'JSON'
    else if FileExt = '.ini' then
      NodeType := 'INI'
    else if FileExt = '.xml' then
      NodeType := 'XML'
    else if FileExt = '.txt' then
      NodeType := 'Text'
    else
      NodeType := 'Unknown';
      
    AddNode(FilePath, NodeType);
  end;
  
  // 鏇存柊鏍戣鍥?
  if Assigned(TreeView) then
    PopulateTreeView(TreeView);
end;

end. 