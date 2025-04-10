unit ViewBuildConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
  System.DateUtils, System.Generics.Collections, ControllerIntf, ModelConfig,
  ConfigValidator, ValidationDialog, FrameDBEditor, FrameListEditor, FrameObjectEditor,
  FrameArrayEditor, System.IOUtils, ConfigTypes, FrameFontEditor, FrameAIAPIEditor,
  UtilsTypes;

type

  TFrmBuildConfig = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    pnlIni: TPanel;
    pnlJson: TPanel;
    pnlLeft: TPanel;
    pnlRigth: TPanel;
    pnlContent: TPanel;
    PageControl1: TPageControl;
    tsINI: TTabSheet;
    tsJSON: TTabSheet;
    tsEditor: TTabSheet;
    Panel1: TPanel;
    sgINI: TStringGrid;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter5: TSplitter;
    tvJSON: TTreeView;
    pnlEditing: TPanel;
    edtEditing: TEdit;
    btnUpdate: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel4: TPanel;
    btnSave: TButton;
    pnlBottom: TPanel;
    edtFileName: TEdit;
    btnClose: TButton;
    btnOpenConfig: TButton;
    btnAddText: TButton;
    btnAddNumber: TButton;
    btnAddPath: TButton;
    btnAddBoolean: TButton;
    btnAddDate: TButton;
    btnAddColor: TButton;
    btnAddFont: TButton;
    btnAddColorComplex: TButton;
    btnAddDatabase: TButton;
    btnAddList: TButton;
    btnAddObject: TButton;
    btnAddArray: TButton;
    dlgOpenFile: TOpenDialog;
    dlgBrowseDir: TFileOpenDialog;
    dlgSelectColor: TColorDialog;
    popupINI: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    popupJSON: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    pnlEditorContent: TPanel;
    procedure btnAddTextClick(Sender: TObject);
    procedure btnAddNumberClick(Sender: TObject);
    procedure btnAddPathClick(Sender: TObject);
    procedure btnAddBooleanClick(Sender: TObject);
    procedure btnAddDateClick(Sender: TObject);
    procedure btnAddColorClick(Sender: TObject);
    procedure btnAddFontClick(Sender: TObject);
    procedure btnAddColorComplexClick(Sender: TObject);
    procedure btnAddDatabaseClick(Sender: TObject);
    procedure btnAddListClick(Sender: TObject);
    procedure btnAddObjectClick(Sender: TObject);
    procedure btnAddArrayClick(Sender: TObject);
    procedure EditINIPropertyClick(Sender: TObject);
    procedure RenameINIPropertyClick(Sender: TObject);
    procedure DeleteINIPropertyClick(Sender: TObject);
    procedure EditJSONPropertyClick(Sender: TObject);
    procedure RenameJSONPropertyClick(Sender: TObject);
    procedure DeleteJSONPropertyClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenConfigClick(Sender: TObject);
    procedure sgINIDblClick(Sender: TObject);
    procedure tvJSONDblClick(Sender: TObject);
    procedure tvJSONChange(Sender: TObject; Node: TTreeNode);
    procedure sgINISelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgINIDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sgINIDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvJSONDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvJSONDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddRootNodeClick(Sender: TObject);
    procedure btnAddININetworkClick(Sender: TObject);
    procedure btnAddINITimeClick(Sender: TObject);
    procedure btnAddINITemplateClick(Sender: TObject);
    procedure btnAddINIPluginClick(Sender: TObject);
    procedure btnAddINILogClick(Sender: TObject);
    procedure btnAddAPIClick(Sender: TObject);
    procedure btnAddJsonSecurityClick(Sender: TObject);
    procedure btnAddJsonAIClick(Sender: TObject);
    procedure btnAddJsonModuleClick(Sender: TObject);
  private
    FCurrentIniFile: string;
    FCurrentJsonFile: string;
    FIsEditing: Boolean;
    FCurrentJsonNode: TTreeNode;
    FCurrentEditNode: TTreeNode; // 当前正在编辑的JSON节点
    FCurrentEditor: TFrame;      // 当前使用的编辑器Frame

    procedure InitializeFrame;
    procedure InitializeGridColumns;
    procedure InitializeButtons;
    procedure InitializePopupMenus;
    procedure InitializeDragDrop;

    procedure AddPropertyToGrid(const Section, PropertyName, PropertyValue: string);
    function AddPropertyToTree(const PropertyName, PropertyType, PropertyValue: string;
      EditorType: TEditorType; ParentNode: TTreeNode = nil): TTreeNode;

    procedure ShowPropertyEditor(Node: TTreeNode);
    procedure HidePropertyEditor;

    procedure LoadIniFile(const FileName: string);
    procedure SaveIniFile(const FileName: string);
    procedure LoadJsonFile(const FileName: string);
    procedure SaveJsonFile(const FileName: string);

    procedure UpdateIniMemo;
    procedure UpdateJsonMemo;

    procedure ClearAllData;

    function GetPropertyInputFromUser(const Caption, Prompt: string; var Value: string): Boolean;
    function GetNewPropertyName(const DefaultName: string = ''): string;
    function GetColorValue: string;
    function GetPathValue: string;
    function BuildPropertyPath(Node: TTreeNode): string;

    // 数据库编辑器事件处理
    procedure OnDBSave(Sender: TObject);
    procedure OnDBCancel(Sender: TObject);

    procedure ShowEditorForNode(Node: TTreeNode);
    procedure EditorSaveClick(Sender: TObject);
    procedure EditorCancelClick(Sender: TObject);
    procedure LoadNodeDataToEditor(Node: TTreeNode; EditorFrame: TFrame);
    procedure SaveEditorDataToNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadConfigFiles(const IniFileName, JsonFileName: string);
    procedure SaveConfigFiles;
  end;

var
  MainForm: TFrmBuildConfig;

implementation

{$R *.dfm}

// 实现类型转换函数
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
begin
  case EditorType of
    etPlain: Result := ctPlain;
    etFont: Result := ctFont;
    etColor: Result := ctColor;
    etDatabase: Result := ctDatabase;
    etList: Result := ctList;
    etObject: Result := ctObject;
    etArray: Result := ctArray;
  else
    Result := ctPlain; // 默认值
  end;
end;

function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
begin
  case ConfigType of
    ctPlain: Result := etPlain;
    ctFont: Result := etFont;
    ctColor: Result := etColor;
    ctDatabase: Result := etDatabase;
    ctList: Result := etList;
    ctObject: Result := etObject;
    ctArray: Result := etArray;
    ctAIAPI: Result := etObject; // 映射为对象类型
  else
    Result := etPlain; // 默认值
  end;
end;

procedure TFrmBuildConfig.tvJSONChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
  begin
    // 更新弹出菜单项状态
    if Assigned(popupJSON) then
    begin
      if Assigned(MenuItem2) then MenuItem2.Enabled := True;  // 编辑属性
      if Assigned(MenuItem3) then MenuItem3.Enabled := True;  // 重命名属性
      if Assigned(MenuItem4) then MenuItem4.Enabled := True;  // 删除属性
    end;

    // 显示属性编辑器
    ShowPropertyEditor(Node);
  end
  else
  begin
    // 禁用弹出菜单项
    if Assigned(popupJSON) then
    begin
      if Assigned(MenuItem2) then MenuItem2.Enabled := False;
      if Assigned(MenuItem3) then MenuItem3.Enabled := False;
      if Assigned(MenuItem4) then MenuItem4.Enabled := False;
    end;

    // 隐藏属性编辑器
    HidePropertyEditor;
  end;
end;

procedure TFrmBuildConfig.sgINISelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  // 更新按钮状态可用性（通过弹出菜单项实现）
  var canEdit := (ARow > 0) and (sgINI.Cells[0, ARow] <> '');
  
  // 如果菜单项存在，更新其状态
  if Assigned(popupINI) then
  begin
    if Assigned(N2) then N2.Enabled := canEdit;  // 编辑属性
    if Assigned(N3) then N3.Enabled := canEdit;  // 重命名属性
    if Assigned(N4) then N4.Enabled := canEdit;  // 删除属性
  end;
end;

procedure TFrmBuildConfig.sgINIDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SourceRow, TargetRow: Integer;
  TempSection, TempKey, TempValue: string;
  Cell: TGridCoord;
begin
  if Source = Sender then
  begin
    SourceRow := sgINI.Row;
    Cell := sgINI.MouseCoord(X, Y);
    TargetRow := Cell.Y;

    if (SourceRow > 0) and (TargetRow > 0) and (SourceRow <> TargetRow) then
    begin
      // 保存源行数据
      TempSection := sgINI.Cells[0, SourceRow];
      TempKey := sgINI.Cells[1, SourceRow];
      TempValue := sgINI.Cells[2, SourceRow];

      // 移动行
      for var i := SourceRow downto TargetRow + 1 do
      begin
        sgINI.Cells[0, i] := sgINI.Cells[0, i - 1];
        sgINI.Cells[1, i] := sgINI.Cells[1, i - 1];
        sgINI.Cells[2, i] := sgINI.Cells[2, i - 1];
        sgINI.Objects[0, i] := sgINI.Objects[0, i - 1];
      end;

      // 恢复数据到目标行
      sgINI.Cells[0, TargetRow] := TempSection;
      sgINI.Cells[1, TargetRow] := TempKey;
      sgINI.Cells[2, TargetRow] := TempValue;

      UpdateIniMemo;
    end;
  end;
end;

procedure TFrmBuildConfig.sgINIDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = Sender;
end;

procedure TFrmBuildConfig.tvJSONDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SourceNode, TargetNode: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  if Source = Sender then
  begin
    SourceNode := tvJSON.Selected;
    TargetNode := tvJSON.GetNodeAt(X, Y);

    if (SourceNode <> nil) and (TargetNode <> nil) and (SourceNode <> TargetNode) then
    begin
      // 获取源节点数据
      PropItem := PConfigPropertyItem(SourceNode.Data);

      // 移动节点
      SourceNode.MoveTo(TargetNode, naAddChild);

      // 更新属性路径
      if PropItem <> nil then
      begin
        PropItem^.PropertyPath := BuildPropertyPath(SourceNode);
      end;

      UpdateJsonMemo;
    end;
  end;
end;

procedure TFrmBuildConfig.tvJSONDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = Sender;
end;

function TFrmBuildConfig.BuildPropertyPath(Node: TTreeNode): string;
var
  Path: string;
  CurrentNode: TTreeNode;
begin
  Path := '';
  CurrentNode := Node;

  while CurrentNode <> nil do
  begin
    if Path <> '' then
      Path := '.' + Path;
    Path := CurrentNode.Text + Path;
    CurrentNode := CurrentNode.Parent;
  end;

  Result := Path;
end;

constructor TFrmBuildConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeFrame;
  InitializeButtons;
  InitializePopupMenus;
  InitializeDragDrop;
end;

destructor TFrmBuildConfig.Destroy;
begin
  ClearAllData;
  inherited;
end;

procedure TFrmBuildConfig.FormCreate(Sender: TObject);
begin
  // 初始化表单
  InitializeFrame;
  InitializeButtons;
  InitializePopupMenus;
  InitializeDragDrop;
end;

procedure TFrmBuildConfig.FormDestroy(Sender: TObject);
begin
  // 清理资源
  ClearAllData;
end;

procedure TFrmBuildConfig.InitializeFrame;
begin
  // 大部分属性已在设计时设置
  // 此方法可以保留为空，或只保留非设计时可设置的属性
end;

procedure TFrmBuildConfig.InitializeGridColumns;
begin
  // 表格列已在设计时设置
end;

procedure TFrmBuildConfig.InitializeButtons;
begin
  // 按钮属性已在设计时设置
end;

procedure TFrmBuildConfig.InitializePopupMenus;
begin
  // 弹出菜单已在设计时设置
end;

procedure TFrmBuildConfig.InitializeDragDrop;
begin
  // 拖放功能已在设计时设置
end;

procedure TFrmBuildConfig.AddPropertyToGrid(const Section, PropertyName, PropertyValue: string);
var
  Row: Integer;
begin
  Row := sgINI.RowCount;
  sgINI.RowCount := Row + 1;
  sgINI.Cells[0, Row] := Section;
  sgINI.Cells[1, Row] := PropertyName;
  sgINI.Cells[2, Row] := PropertyValue;
end;

function TFrmBuildConfig.AddPropertyToTree(const PropertyName, PropertyType, PropertyValue: string;
  EditorType: TEditorType; ParentNode: TTreeNode = nil): TTreeNode;
var
  PropItem: PConfigPropertyItem;
begin
  New(PropItem);
  PropItem^.PropertyName := PropertyName;
  PropItem^.PropertyType := PropertyType;
  PropItem^.PropertyValue := PropertyValue;
  PropItem^.EditorType := EditorType;

  if ParentNode = nil then
    Result := tvJSON.Items.AddObject(nil, PropertyName, PropItem)
  else
    Result := tvJSON.Items.AddChildObject(ParentNode, PropertyName, PropItem);

  PropItem^.PropertyPath := BuildPropertyPath(Result);
end;

procedure TFrmBuildConfig.ShowPropertyEditor(Node: TTreeNode);
begin
  if Node = nil then Exit;

  // 显示属性编辑器的逻辑
  FCurrentJsonNode := Node;
  FIsEditing := True;
  edtEditing.Text := TTreeNode(Node).Text;
  pnlEditing.Visible := True;
end;

procedure TFrmBuildConfig.HidePropertyEditor;
begin
  // 隐藏属性编辑器的逻辑
  FIsEditing := False;
  pnlEditing.Visible := False;
end;

procedure TFrmBuildConfig.LoadIniFile(const FileName: string);
var
  IniFile: TIniFile;
  Sections, Keys: TStringList;
  i, j: Integer;
  Section, Key, Value: string;
begin
  FCurrentIniFile := FileName;

  // 清除现有数据
  sgINI.RowCount := 2;  // 修改为 2，保留固定行和一个空数据行
  sgINI.Cells[0, 1] := '';
  sgINI.Cells[1, 1] := '';
  sgINI.Cells[2, 1] := '';

  // 加载INI文件
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;
  Keys := TStringList.Create;

  try
    // 获取所有节点
    IniFile.ReadSections(Sections);

    // 如果有数据，则清除初始化的空行
    if Sections.Count > 0 then
      sgINI.RowCount := 1;

    // 遍历每个节点
    for i := 0 to Sections.Count - 1 do
    begin
      Section := Sections[i];
      Keys.Clear;

      // 获取节点下的所有键
      IniFile.ReadSection(Section, Keys);

      // 遍历每个键
      for j := 0 to Keys.Count - 1 do
      begin
        Key := Keys[j];
        Value := IniFile.ReadString(Section, Key, '');

        // 添加到网格
        AddPropertyToGrid(Section, Key, Value);
      end;
    end;

    // 更新INI内容显示
    UpdateIniMemo;
  finally
    Keys.Free;
    Sections.Free;
    IniFile.Free;
  end;
end;

procedure TFrmBuildConfig.SaveIniFile(const FileName: string);
var
  IniFile: TIniFile;
  i: Integer;
  Section, Key, Value: string;
  Sections: TStringList;
begin
  // 创建或清空INI文件
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;

  try
    // 先清除所有节点
    IniFile.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
      IniFile.EraseSection(Sections[i]);

    // 遍历网格中的所有行
    for i := 1 to sgINI.RowCount - 1 do
    begin
      if (sgINI.Cells[0, i] <> '') and (sgINI.Cells[1, i] <> '') then
      begin
        Section := sgINI.Cells[0, i];
        Key := sgINI.Cells[1, i];
        Value := sgINI.Cells[2, i];

        // 写入INI文件
        IniFile.WriteString(Section, Key, Value);
      end;
    end;
  finally
    Sections.Free;
    IniFile.Free;
  end;
end;

procedure TFrmBuildConfig.LoadJsonFile(const FileName: string);
var
  JsonStr: string;
  JsonValue: TJSONValue;
  JsonObject: TJSONObject;

  procedure ProcessJsonObject(Obj: TJSONObject; ParentNode: TTreeNode = nil);
  var
    i: Integer;
    Pair: TJSONPair;
    ChildNode: TTreeNode;
    EditorType: TEditorType;
  begin
    for i := 0 to Obj.Count - 1 do
    begin
      Pair := Obj.Pairs[i];

      // 根据值类型确定编辑器类型
      if Pair.JsonValue is TJSONObject then
        EditorType := etObject
      else if Pair.JsonValue is TJSONArray then
        EditorType := etArray
      else
        EditorType := etPlain;

      // 添加到树中
      ChildNode := AddPropertyToTree(Pair.JsonString.Value, Pair.JsonValue.ClassName,
                                     Pair.JsonValue.ToString, EditorType, ParentNode);

      // 如果是对象或数组，递归处理
      if Pair.JsonValue is TJSONObject then
        ProcessJsonObject(TJSONObject(Pair.JsonValue), ChildNode)
      else if Pair.JsonValue is TJSONArray then
      begin
        // 处理数组
        var JsonArray := TJSONArray(Pair.JsonValue);
        for var j := 0 to JsonArray.Count - 1 do
        begin
          if JsonArray.Items[j] is TJSONObject then
          begin
            var ItemNode := AddPropertyToTree('[' + IntToStr(j) + ']', 'TJSONObject',
                                            JsonArray.Items[j].ToString, etObject, ChildNode);
            ProcessJsonObject(TJSONObject(JsonArray.Items[j]), ItemNode);
          end
          else
          begin
            AddPropertyToTree('[' + IntToStr(j) + ']', JsonArray.Items[j].ClassName,
                            JsonArray.Items[j].ToString, etPlain, ChildNode);
          end;
        end;
      end;
    end;
  end;

begin
  FCurrentJsonFile := FileName;

  // 清除现有数据
  tvJSON.Items.Clear;

  // 加载JSON文件
  try
    JsonStr := TFile.ReadAllText(FileName);
    JsonValue := TJSONObject.ParseJSONValue(JsonStr);

    if Assigned(JsonValue) and (JsonValue is TJSONObject) then
    begin
      JsonObject := TJSONObject(JsonValue);

      // 处理JSON对象
      ProcessJsonObject(JsonObject);

      // 展开所有节点
      tvJSON.FullExpand;

      // 更新JSON内容显示
      UpdateJsonMemo;
    end;
  except
    on E: Exception do
      ShowMessage('加载JSON文件失败: ' + E.Message);
  end;
end;

procedure TFrmBuildConfig.SaveJsonFile(const FileName: string);

  function BuildJsonObject(Node: TTreeNode): TJSONValue;
  var
    PropItem: PConfigPropertyItem;
    ChildNode: TTreeNode;
    JsonObj: TJSONObject;
    JsonArray: TJSONArray;
    JsonValue: TJSONValue;
  begin
    if Node = nil then
      Exit(nil);

    PropItem := PConfigPropertyItem(Node.Data);

    if PropItem^.EditorType = etObject then
    begin
      // 创建对象
      JsonObj := TJSONObject.Create;

      // 遍历子节点
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        JsonValue := BuildJsonObject(ChildNode);
        if JsonValue <> nil then
          JsonObj.AddPair(ChildNode.Text, JsonValue);

        ChildNode := ChildNode.getNextSibling;
      end;

      Result := JsonObj;
    end
    else if PropItem^.EditorType = etArray then
    begin
      // 创建数组
      JsonArray := TJSONArray.Create;

      // 遍历子节点
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        JsonValue := BuildJsonObject(ChildNode);
        if JsonValue <> nil then
          JsonArray.AddElement(JsonValue);

        ChildNode := ChildNode.getNextSibling;
      end;

      Result := JsonArray;
    end
    else
    begin
      // 简单类型
      try
        Result := TJSONString.Create(PropItem^.PropertyValue);
      except
        Result := TJSONString.Create('');
      end;
    end;
  end;

var
  RootNode: TTreeNode;
  RootObject: TJSONObject;
  JsonStr: string;
begin
  // 创建根对象
  RootObject := TJSONObject.Create;

  // 遍历树的根节点
  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    var JsonValue := BuildJsonObject(RootNode);
    if JsonValue <> nil then
      RootObject.AddPair(RootNode.Text, JsonValue);

    RootNode := RootNode.getNextSibling;
  end;

  try
    // 格式化JSON并保存
    JsonStr := RootObject.Format(2);
    TFile.WriteAllText(FileName, JsonStr);
  finally
    RootObject.Free;
  end;
end;

procedure TFrmBuildConfig.UpdateIniMemo;
begin
  // 更新INI备忘录的逻辑
  Memo1.Lines.Clear;
  for var i := 1 to sgINI.RowCount - 1 do
  begin
    if (sgINI.Cells[0, i] <> '') and (sgINI.Cells[1, i] <> '') then
      Memo1.Lines.Add(Format('%s.%s=%s', [sgINI.Cells[0, i], sgINI.Cells[1, i], sgINI.Cells[2, i]]));
  end;
end;

procedure TFrmBuildConfig.UpdateJsonMemo;

  procedure ProcessNode(Node: TTreeNode; Indent: Integer);
  var
    PropItem: PConfigPropertyItem;
    ChildNode: TTreeNode;
    i: Integer;
    IndentStr, NodeText: string;
  begin
    if Node = nil then Exit;

    // 创建缩进字符串
    IndentStr := StringOfChar(' ', Indent * 2);

    PropItem := PConfigPropertyItem(Node.Data);

    // 根据节点类型生成文本
    if PropItem^.EditorType = etObject then
    begin
      // 对象开始
      NodeText := IndentStr + '"' + Node.Text + '": {';
      Memo2.Lines.Add(NodeText);

      // 处理子节点
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 如果不是最后一个子节点，添加逗号
        if ChildNode.getNextSibling <> nil then
          Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 对象结束
      Memo2.Lines.Add(IndentStr + '}');
    end
    else if PropItem^.EditorType = etArray then
    begin
      // 数组开始
      NodeText := IndentStr + '"' + Node.Text + '": [';
      Memo2.Lines.Add(NodeText);

      // 处理子节点
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 如果不是最后一个子节点，添加逗号
        if ChildNode.getNextSibling <> nil then
          Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 数组结束
      Memo2.Lines.Add(IndentStr + ']');
    end
    else
    begin
      // 简单类型
      NodeText := IndentStr + '"' + Node.Text + '": "' + PropItem^.PropertyValue + '"';
      Memo2.Lines.Add(NodeText);
    end;
  end;

var
  RootNode: TTreeNode;
begin
  // 清除备忘录
  Memo2.Lines.Clear;

  // 添加JSON开始标记
  Memo2.Lines.Add('{');

  // 遍历树的根节点
  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    ProcessNode(RootNode, 1);

    // 如果不是最后一个根节点，添加逗号
    if RootNode.getNextSibling <> nil then
      Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

    RootNode := RootNode.getNextSibling;
  end;

  // 添加JSON结束标记
  Memo2.Lines.Add('}');
end;

procedure TFrmBuildConfig.ClearAllData;
begin
  // 清除所有数据的逻辑
  sgINI.RowCount := 1;
  tvJSON.Items.Clear;
  Memo1.Clear;
  Memo2.Clear;
end;

function TFrmBuildConfig.GetPropertyInputFromUser(const Caption, Prompt: string; var Value: string): Boolean;
begin
  // 从用户获取属性输入的逻辑
  Result := InputQuery(Caption, Prompt, Value);
end;

function TFrmBuildConfig.GetNewPropertyName(const DefaultName: string): string;
var
  NewName: string;
begin
  NewName := DefaultName;
  if GetPropertyInputFromUser('新属性', '请输入属性名称:', NewName) then
    Result := NewName
  else
    Result := DefaultName;
end;

function TFrmBuildConfig.GetColorValue: string;
begin
  // 获取颜色值的逻辑
  Result := '';
  if dlgSelectColor.Execute then
    Result := Format('$%.8x', [dlgSelectColor.Color]);
end;

function TFrmBuildConfig.GetPathValue: string;
begin
  // 获取路径值的逻辑
  Result := '';
  if dlgBrowseDir.Execute then
    Result := dlgBrowseDir.FileName;
end;

procedure TFrmBuildConfig.LoadConfigFiles(const IniFileName, JsonFileName: string);
begin
  ClearAllData;
  if FileExists(IniFileName) then
    LoadIniFile(IniFileName);
  if FileExists(JsonFileName) then
    LoadJsonFile(JsonFileName);
end;

procedure TFrmBuildConfig.SaveConfigFiles;
begin
  if FCurrentIniFile <> '' then
    SaveIniFile(FCurrentIniFile);
  if FCurrentJsonFile <> '' then
    SaveJsonFile(FCurrentJsonFile);
end;

procedure TFrmBuildConfig.btnAddTextClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Section: string;
begin
  // 添加文本属性的逻辑
  PropertyName := GetNewPropertyName('Text');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('文本属性', '请输入文本值:', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddNumberClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Section: string;
  Value: Double;
begin
  // 添加数字属性的逻辑
  PropertyName := GetNewPropertyName('Number');
  if PropertyName = '' then Exit;

  PropertyValue := '0';
  if not GetPropertyInputFromUser('数值属性', '请输入数值:', PropertyValue) then Exit;

  // 验证输入是否为有效数字
  try
    Value := StrToFloat(PropertyValue);
  except
    on E: Exception do
    begin
      ShowMessage('请输入有效的数字');
      Exit;
    end;
  end;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddPathClick(Sender: TObject);
var
  PropertyName: string;
  PathValue: string;
  Section: string;
begin
  // 添加路径属性的逻辑
  PropertyName := GetNewPropertyName('Path');
  if PropertyName = '' then Exit;

  // 获取路径
  PathValue := GetPathValue;
  if PathValue = '' then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PathValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddBooleanClick(Sender: TObject);
var
  PropertyName: string;
  BoolValue: Boolean;
  Section: string;
  BoolStr: string;
begin
  // 添加布尔属性的逻辑
  PropertyName := GetNewPropertyName('Boolean');
  if PropertyName = '' then Exit;

  // 默认为False
  BoolValue := False;

  // 显示选择对话框
  if MessageDlg('请选择布尔值', mtConfirmation, mbYesNo, 0) = mrYes then
    BoolValue := True;

  // 转换为字符串
  if BoolValue then
    BoolStr := 'True'
  else
    BoolStr := 'False';

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, BoolStr);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddDateClick(Sender: TObject);
var
  PropertyName: string;
  DateValue: TDateTime;
  Section: string;
  DateStr: string;
  DateForm: TForm;
  DatePicker: TDateTimePicker;
  BtnOK, BtnCancel: TButton;
begin
  // 添加日期属性的逻辑
  PropertyName := GetNewPropertyName('Date');
  if PropertyName = '' then Exit;

  // 创建日期选择对话框
  DateForm := TForm.Create(Self);
  try
    DateForm.Caption := '选择日期';
    DateForm.Position := poScreenCenter;
    DateForm.Width := 300;
    DateForm.Height := 150;
    DateForm.BorderStyle := bsDialog;

    // 创建日期选择控件
    DatePicker := TDateTimePicker.Create(DateForm);
    DatePicker.Parent := DateForm;
    DatePicker.Left := 20;
    DatePicker.Top := 20;
    DatePicker.Width := 260;
    DatePicker.Date := Now;

    // 创建按钮
    BtnOK := TButton.Create(DateForm);
    BtnOK.Parent := DateForm;
    BtnOK.Caption := '确定';
    BtnOK.ModalResult := mrOK;
    BtnOK.Left := 120;
    BtnOK.Top := 70;
    BtnOK.Width := 75;

    BtnCancel := TButton.Create(DateForm);
    BtnCancel.Parent := DateForm;
    BtnCancel.Caption := '取消';
    BtnCancel.ModalResult := mrCancel;
    BtnCancel.Left := 205;
    BtnCancel.Top := 70;
    BtnCancel.Width := 75;

    // 显示对话框
    if DateForm.ShowModal = mrOK then
    begin
      DateValue := DatePicker.Date;
      DateStr := FormatDateTime('yyyy-mm-dd', DateValue);

      // 获取当前选中的节点作为Section
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 添加到网格
      AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, DateStr);

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  finally
    DateForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorClick(Sender: TObject);
var
  PropertyName: string;
  ColorValue: string;
  Section: string;
begin
  // 添加颜色属性的逻辑
  PropertyName := GetNewPropertyName('Color');
  if PropertyName = '' then Exit;

  // 获取颜色
  ColorValue := GetColorValue;
  if ColorValue = '' then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctColor.' + PropertyName, ColorValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddFontClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  FontDialog: TFontDialog;
  FontStr: string;
begin
  // 添加字体属性的逻辑
  PropertyName := GetNewPropertyName('Font');
  if PropertyName = '' then Exit;

  // 创建字体选择对话框
  FontDialog := TFontDialog.Create(Self);
  try
    // 设置默认字体
    FontDialog.Font.Name := 'Arial';
    FontDialog.Font.Size := 10;
    FontDialog.Font.Style := [];

    // 显示字体选择对话框
    if FontDialog.Execute then
    begin
      // 将字体信息转换为字符串
      FontStr := Format('%s,%d,%s,%s,%s,%s', [
        FontDialog.Font.Name,
        FontDialog.Font.Size,
        BoolToStr(fsBold in FontDialog.Font.Style, True),
        BoolToStr(fsItalic in FontDialog.Font.Style, True),
        BoolToStr(fsUnderline in FontDialog.Font.Style, True),
        ColorToString(FontDialog.Font.Color)
      ]);

      // 获取当前选中的节点作为Section
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 添加到网格
      AddPropertyToGrid(Section, 'ctFont.' + PropertyName, FontStr);

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  finally
    FontDialog.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorComplexClick(Sender: TObject);
begin
  // 添加复杂颜色属性的逻辑
end;

procedure TFrmBuildConfig.btnAddDatabaseClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
begin
  // 添加数据库属性的逻辑
  PropertyName := GetNewPropertyName('Database');
  if PropertyName = '' then Exit;

  // 创建新节点并添加到树中
  Node := AddPropertyToTree(PropertyName, 'TJSONObject', '{"ConnectionString":""}', etDatabase);
  
  // 确保节点被选中
  tvJSON.Selected := Node;
  
  // 切换到编辑器页面并创建编辑器
  PageControl1.ActivePage := tsEditor;
  
  // 清除编辑器内容面板中的所有控件
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 显示编辑器
  ShowEditorForNode(Node);
  
  // 更新JSON视图
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.btnAddListClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  ListEditor: TFrameListEditor;
  ListForm: TForm;
  JSONObj: TJSONObject;
  JSONArray: TJSONArray;
  i: Integer;
begin
  // 添加列表属性的逻辑
  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  // 创建列表编辑器对话框
  ListForm := TForm.Create(Self);
  try
    ListForm.Caption := '列表编辑器';
    ListForm.Position := poScreenCenter;
    ListForm.Width := 400;
    ListForm.Height := 350;
    ListForm.BorderStyle := bsDialog;

    // 创建列表编辑器
    ListEditor := TFrameListEditor.Create(ListForm);
    ListEditor.Parent := ListForm;
    ListEditor.Align := alClient;

    // 创建按钮面板
    var ButtonPanel := TPanel.Create(ListForm);
    ButtonPanel.Parent := ListForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 创建确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 创建取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 创建初始JSON对象
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etList');
    JSONObj.AddPair('value', TJSONArray.Create);

    // 设置JSON对象
    ListEditor.JSONObject := JSONObj;

    // 显示对话框
    if ListForm.ShowModal = mrOK then
    begin
      // 保存列表到JSON
      ListEditor.SaveToJSON;

      // 获取当前选中的节点作为Section
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 将列表转换为字符串
      var ListStr := '';
      if JSONObj.GetValue('value') is TJSONArray then
      begin
        JSONArray := TJSONArray(JSONObj.GetValue('value'));
        for i := 0 to JSONArray.Count - 1 do
        begin
          if i > 0 then ListStr := ListStr + ';';
          if JSONArray.Items[i] is TJSONString then
            ListStr := ListStr + TJSONString(JSONArray.Items[i]).Value
          else
            ListStr := ListStr + JSONArray.Items[i].ToString;
        end;
      end;

      // 添加到网格
      AddPropertyToGrid(Section, 'ctList.' + PropertyName, ListStr);

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  finally
    JSONObj.Free;
    ListForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddObjectClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  ObjectEditor: TFrameObjectEditor;
  ObjectForm: TForm;
  JSONObj: TJSONObject;
begin
  // 添加对象属性的逻辑
  PropertyName := GetNewPropertyName('Object');
  if PropertyName = '' then Exit;

  // 创建对象编辑器对话框
  ObjectForm := TForm.Create(Self);
  try
    ObjectForm.Caption := '对象编辑器';
    ObjectForm.Position := poScreenCenter;
    ObjectForm.Width := 500;
    ObjectForm.Height := 400;
    ObjectForm.BorderStyle := bsDialog;

    // 创建对象编辑器
    ObjectEditor := TFrameObjectEditor.Create(ObjectForm);
    ObjectEditor.Parent := ObjectForm;
    ObjectEditor.Align := alClient;

    // 创建按钮面板
    var ButtonPanel := TPanel.Create(ObjectForm);
    ButtonPanel.Parent := ObjectForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 创建确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 创建取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 创建初始JSON对象
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etObject');

    // 设置JSON对象
    ObjectEditor.JSONObject := JSONObj;

    // 显示对话框
    if ObjectForm.ShowModal = mrOK then
    begin
      // 保存对象到JSON
      ObjectEditor.SaveToJSON;

      // 获取当前选中的节点作为Section
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 添加到网格
      AddPropertyToGrid(Section, 'ctObject.' + PropertyName, JSONObj.ToString);

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  finally
    JSONObj.Free;
    ObjectForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddArrayClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  ArrayEditor: TFrameArrayEditor;
  ArrayForm: TForm;
  JSONObj: TJSONObject;
begin
  // 添加数组属性的逻辑
  PropertyName := GetNewPropertyName('Array');
  if PropertyName = '' then Exit;

  // 创建数组编辑器对话框
  ArrayForm := TForm.Create(Self);
  try
    ArrayForm.Caption := '数组编辑器';
    ArrayForm.Position := poScreenCenter;
    ArrayForm.Width := 500;
    ArrayForm.Height := 400;
    ArrayForm.BorderStyle := bsDialog;

    // 创建数组编辑器
    ArrayEditor := TFrameArrayEditor.Create(ArrayForm);
    ArrayEditor.Parent := ArrayForm;
    ArrayEditor.Align := alClient;

    // 创建按钮面板
    var ButtonPanel := TPanel.Create(ArrayForm);
    ButtonPanel.Parent := ArrayForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 创建确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 创建取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 创建初始JSON对象
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etArray');
    JSONObj.AddPair('itemType', 'string');
    JSONObj.AddPair('items', TJSONArray.Create);

    // 设置JSON对象
    ArrayEditor.JSONObject := JSONObj;

    // 显示对话框
    if ArrayForm.ShowModal = mrOK then
    begin
      // 保存数组到JSON
      ArrayEditor.SaveToJSON;

      // 获取当前选中的节点作为Section
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 添加到网格
      AddPropertyToGrid(Section, 'ctArray.' + PropertyName, JSONObj.ToString);

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  finally
    JSONObj.Free;
    ArrayForm.Free;
  end;
end;

procedure TFrmBuildConfig.EditINIPropertyClick(Sender: TObject);
var
  Row: Integer;
  PropertyType, PropertyValue: string;
  NewValue: string;
  Section, Key: string;
begin
  // 获取当前选中的行
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 获取属性类型和值
  Section := sgINI.Cells[0, Row];
  Key := sgINI.Cells[1, Row];
  PropertyValue := sgINI.Cells[2, Row];

  // 根据属性类型显示不同的编辑器
  if Key.StartsWith('ctFont.') then
  begin
    // 字体编辑器
    var FontDialog := TFontDialog.Create(Self);
    try
      // 解析字体字符串
      var FontParts := PropertyValue.Split([',']);
      if Length(FontParts) >= 6 then
      begin
        FontDialog.Font.Name := FontParts[0];
        FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

        // 设置字体样式
        FontDialog.Font.Style := [];
        if StrToBoolDef(FontParts[2], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsBold];
        if StrToBoolDef(FontParts[3], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsItalic];
        if StrToBoolDef(FontParts[4], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];

        // 设置颜色
        FontDialog.Font.Color := StringToColor(FontParts[5]);
      end;

      // 显示字体选择对话框
      if FontDialog.Execute then
      begin
        // 将字体信息转换为字符串
        NewValue := Format('%s,%d,%s,%s,%s,%s', [
          FontDialog.Font.Name,
          FontDialog.Font.Size,
          BoolToStr(fsBold in FontDialog.Font.Style, True),
          BoolToStr(fsItalic in FontDialog.Font.Style, True),
          BoolToStr(fsUnderline in FontDialog.Font.Style, True),
          ColorToString(FontDialog.Font.Color)
        ]);

        // 更新网格
        sgINI.Cells[2, Row] := NewValue;

        // 更新INI内容显示
        UpdateIniMemo;
      end;
    finally
      FontDialog.Free;
    end;
  end
  else if Key.StartsWith('ctColor.') then
  begin
    // 颜色编辑器
    var ColorDialog := TColorDialog.Create(Self);
    try
      // 设置初始颜色
      try
        ColorDialog.Color := StringToColor(PropertyValue);
      except
        ColorDialog.Color := clBlack;
      end;

      // 显示颜色选择对话框
      if ColorDialog.Execute then
      begin
        // 将颜色转换为字符串
        NewValue := ColorToString(ColorDialog.Color);

        // 更新网格
        sgINI.Cells[2, Row] := NewValue;

        // 更新INI内容显示
        UpdateIniMemo;
      end;
    finally
      ColorDialog.Free;
    end;
  end
  else if Key.StartsWith('ctPlain.') then
  begin
    // 简单类型编辑器
    NewValue := PropertyValue;
    if GetPropertyInputFromUser('编辑属性', '请输入新值:', NewValue) then
    begin
      // 更新网格
      sgINI.Cells[2, Row] := NewValue;

      // 更新INI内容显示
      UpdateIniMemo;
    end;
  end;
end;

procedure TFrmBuildConfig.RenameINIPropertyClick(Sender: TObject);
var
  Row: Integer;
  Section, Key, Value: string;
  NewKey: string;
begin
  // 获取当前选中的行
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 获取属性信息
  Section := sgINI.Cells[0, Row];
  Key := sgINI.Cells[1, Row];
  Value := sgINI.Cells[2, Row];

  // 获取新的键名
  NewKey := Key;
  if GetPropertyInputFromUser('重命名属性', '请输入新的属性名:', NewKey) then
  begin
    // 更新网格
    sgINI.Cells[1, Row] := NewKey;

    // 更新INI内容显示
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteINIPropertyClick(Sender: TObject);
var
  RowIndex, i: Integer;
begin
  // 获取当前选中的行
  RowIndex := sgINI.Row;
  if (RowIndex <= 0) or (RowIndex >= sgINI.RowCount) then
    Exit;
  
  // 确认删除
  if MessageDlg('您确定要删除这个属性吗？', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 手动删除行
    for i := RowIndex to sgINI.RowCount - 2 do
    begin
      sgINI.Cells[0, i] := sgINI.Cells[0, i + 1];
      sgINI.Cells[1, i] := sgINI.Cells[1, i + 1];
      sgINI.Cells[2, i] := sgINI.Cells[2, i + 1];
      sgINI.Objects[0, i] := sgINI.Objects[0, i + 1];
    end;
    
    // 减少行数
    if sgINI.RowCount > 2 then
      sgINI.RowCount := sgINI.RowCount - 1
    else
    begin
      // 如果只有一行，清空它
      sgINI.Cells[0, 1] := '';
      sgINI.Cells[1, 1] := '';
      sgINI.Cells[2, 1] := '';
    end;
    
    // 更新INI内容显示
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.EditJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewValue: string;
begin
  // 获取当前选中的节点
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 根据编辑器类型显示不同的编辑器
  case PropItem^.EditorType of
    etPlain:
      begin
        // 简单类型编辑器
        NewValue := PropItem^.PropertyValue;
        if GetPropertyInputFromUser('编辑属性', '请输入新值:', NewValue) then
        begin
          // 更新属性值
          PropItem^.PropertyValue := NewValue;

          // 更新JSON内容显示
          UpdateJsonMemo;
        end;
      end;
    etFont:
      begin
        // 字体编辑器
        var FontDialog := TFontDialog.Create(Self);
        try
          // 解析字体字符串
          var FontParts := PropItem^.PropertyValue.Split([',']);
          if Length(FontParts) >= 6 then
          begin
            FontDialog.Font.Name := FontParts[0];
            FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

            // 设置字体样式
            FontDialog.Font.Style := [];
            if StrToBoolDef(FontParts[2], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsBold];
            if StrToBoolDef(FontParts[3], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsItalic];
            if StrToBoolDef(FontParts[4], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];

            // 设置颜色
            FontDialog.Font.Color := StringToColor(FontParts[5]);
          end;

          // 显示字体选择对话框
          if FontDialog.Execute then
          begin
            // 将字体信息转换为字符串
            NewValue := Format('%s,%d,%s,%s,%s,%s', [
              FontDialog.Font.Name,
              FontDialog.Font.Size,
              BoolToStr(fsBold in FontDialog.Font.Style, True),
              BoolToStr(fsItalic in FontDialog.Font.Style, True),
              BoolToStr(fsUnderline in FontDialog.Font.Style, True),
              ColorToString(FontDialog.Font.Color)
            ]);

            // 更新属性值
            PropItem^.PropertyValue := NewValue;

            // 更新JSON内容显示
            UpdateJsonMemo;
          end;
        finally
          FontDialog.Free;
        end;
      end;
    etColor:
      begin
        // 颜色编辑器
        var ColorDialog := TColorDialog.Create(Self);
        try
          // 设置初始颜色
          try
            ColorDialog.Color := StringToColor(PropItem^.PropertyValue);
          except
            ColorDialog.Color := clBlack;
          end;

          // 显示颜色选择对话框
          if ColorDialog.Execute then
          begin
            // 将颜色转换为字符串
            NewValue := ColorToString(ColorDialog.Color);

            // 更新属性值
            PropItem^.PropertyValue := NewValue;

            // 更新JSON内容显示
            UpdateJsonMemo;
          end;
        finally
          ColorDialog.Free;
        end;
      end;
    etObject, etArray:
      begin
        // 对象和数组类型不能直接编辑
        ShowMessage('对象和数组类型需要编辑其子属性');
      end;
  end;
end;

procedure TFrmBuildConfig.RenameJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewName: string;
begin
  // 获取当前选中的节点
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 获取新的属性名
  NewName := Node.Text;
  if GetPropertyInputFromUser('重命名属性', '请输入新的属性名:', NewName) then
  begin
    // 更新节点文本
    Node.Text := NewName;

    // 更新属性路径
    PropItem := PConfigPropertyItem(Node.Data);
    if PropItem <> nil then
      PropItem^.PropertyPath := BuildPropertyPath(Node);

    // 更新JSON内容显示
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  // 获取当前选中的节点
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 确认删除
  if MessageDlg('您确定要删除这个属性吗？\n注意：如果是对象或数组，将会删除所有子属性。', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 释放节点数据
    if Node.Data <> nil then
      Dispose(PConfigPropertyItem(Node.Data));

    // 删除节点
    Node.Delete;

    // 更新JSON内容显示
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.btnUpdateClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 更新按钮点击事件的逻辑
  if not FIsEditing then Exit;

  // 获取当前选中的节点
  Node := FCurrentJsonNode;
  if Node = nil then Exit;

  // 获取属性项
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 更新属性值
  PropItem^.PropertyValue := edtEditing.Text;

  // 更新JSON内容显示
  UpdateJsonMemo;

  // 隐藏编辑器
  HidePropertyEditor;
end;

procedure TFrmBuildConfig.btnSaveClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 保存按钮点击事件的逻辑
  if (FCurrentIniFile = '') and (edtFileName.Text = '') then
  begin
    // 如果没有指定文件名，显示保存对话框
    dlgOpenFile.Filter := 'INI文件 (*.ini)|*.ini|All files (*.*)|*.*';
    dlgOpenFile.Title := '保存INI配置文件';
    dlgOpenFile.DefaultExt := 'ini';

    if dlgOpenFile.Execute then
    begin
      IniFileName := dlgOpenFile.FileName;
      JsonFileName := ChangeFileExt(IniFileName, '.json');

      // 保存文件
      SaveIniFile(IniFileName);
      SaveJsonFile(JsonFileName);

      // 更新当前文件名
      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;
      edtFileName.Text := IniFileName;

      ShowMessage('配置文件已保存');
    end;
  end
  else
  begin
    // 使用当前文件名保存
    if FCurrentIniFile = '' then
      FCurrentIniFile := edtFileName.Text;

    JsonFileName := ChangeFileExt(FCurrentIniFile, '.json');

    // 保存文件
    SaveIniFile(FCurrentIniFile);
    SaveJsonFile(JsonFileName);

    ShowMessage('配置文件已保存');
  end;
end;

procedure TFrmBuildConfig.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBuildConfig.btnOpenConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 打开配置文件的逻辑
  dlgOpenFile.Filter := 'INI文件 (*.ini)|*.ini|All files (*.*)|*.*';
  dlgOpenFile.Title := '选择INI配置文件';

  if dlgOpenFile.Execute then
  begin
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // 加载配置文件
    LoadConfigFiles(IniFileName, JsonFileName);

    // 更新文件名显示
    edtFileName.Text := IniFileName;
  end;
end;

procedure TFrmBuildConfig.sgINIDblClick(Sender: TObject);
begin
  // INI网格双击事件的逻辑
  EditINIPropertyClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONDblClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 获取当前选中的节点
  Node := tvJSON.Selected;
  if Node = nil then Exit;
  
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;
  
  // 对于复杂类型，切换到编辑器页
  if PropItem^.EditorType in [etObject, etArray, etDatabase, etList, etAIAPI] then
  begin
    // 切换到编辑器标签页
    PageControl1.ActivePage := tsEditor;
    
    // 清除编辑器内容面板中的所有控件
    while pnlEditorContent.ControlCount > 0 do
      pnlEditorContent.Controls[0].Free;
    
    // 创建并显示相应的编辑器
    ShowEditorForNode(Node);
  end
  else
  begin
    // 简单类型直接调用现有的编辑方法
    EditJSONPropertyClick(Sender);
  end;
end;

// 数据库编辑器事件处理
procedure TFrmBuildConfig.OnDBSave(Sender: TObject);
begin
  if Sender is TFrameDBEditor then
  begin
    var DBEditor := TFrameDBEditor(Sender);
    var DBForm := DBEditor.Parent;
    while Assigned(DBForm) and not (DBForm is TForm) do
      DBForm := DBForm.Parent;
      
    if DBForm is TForm then
      TForm(DBForm).ModalResult := mrOK;
  end;
end;

procedure TFrmBuildConfig.OnDBCancel(Sender: TObject);
begin
  if Sender is TFrameDBEditor then
  begin
    var DBEditor := TFrameDBEditor(Sender);
    var DBForm := DBEditor.Parent;
    while Assigned(DBForm) and not (DBForm is TForm) do
      DBForm := DBForm.Parent;
      
    if DBForm is TForm then
      TForm(DBForm).ModalResult := mrCancel;
  end;
end;

procedure TFrmBuildConfig.btnAddRootNodeClick(Sender: TObject);
var
  RootNode: TTreeNode;
  PropertyName: string;
begin
  // 添加根节点
  PropertyName := '所有属性';
  
  // 添加到树中
  RootNode := AddPropertyToTree(PropertyName, 'TJSONObject', '{}', etObject);
  
  // 展开节点
  if Assigned(RootNode) then
    RootNode.Expand(False);
    
  // 更新JSON内容显示
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.btnAddININetworkClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Section: string;
begin
  // 添加网络属性的逻辑
  PropertyName := GetNewPropertyName('Network');
  if PropertyName = '' then Exit;

  PropertyValue := '127.0.0.1';
  if not GetPropertyInputFromUser('网络属性', '请输入IP地址:', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Network';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctNetwork.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINITimeClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 添加时间属性的逻辑
  PropertyName := GetNewPropertyName('Time');
  if PropertyName = '' then Exit;

  PropertyValue := FormatDateTime('hh:mm:ss', Now);
  if not GetPropertyInputFromUser('时间属性', '请输入时间 (hh:mm:ss):', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Time';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctTime.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINITemplateClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 添加模板属性的逻辑
  PropertyName := GetNewPropertyName('Template');
  if PropertyName = '' then Exit;

  PropertyValue := '${variableName}';
  if not GetPropertyInputFromUser('模板属性', '请输入模板:', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Template';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctTemplate.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINIPluginClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 添加插件属性的逻辑
  PropertyName := GetNewPropertyName('Plugin');
  if PropertyName = '' then Exit;

  PropertyValue := 'plugins/example.dll';
  if not GetPropertyInputFromUser('插件属性', '请输入插件路径:', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Plugins';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctPlugin.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINILogClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 添加日志属性的逻辑
  PropertyName := GetNewPropertyName('Log');
  if PropertyName = '' then Exit;

  PropertyValue := 'logs/app.log';
  if not GetPropertyInputFromUser('日志属性', '请输入日志路径:', PropertyValue) then Exit;

  // 获取当前选中的节点作为Section
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Logging';

  // 添加到网格
  AddPropertyToGrid(Section, 'ctLog.' + PropertyName, PropertyValue);

  // 更新INI内容显示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddAPIClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  APIEditor: TAIAPIEditorFrame;
  APIForm: TForm;
  JSONObj: TJSONObject;
begin
  // 添加API属性的逻辑
  PropertyName := GetNewPropertyName('API');
  if PropertyName = '' then Exit;

  // 创建API编辑器对话框
  APIForm := TForm.Create(Self);
  try
    APIForm.Caption := 'API编辑器';
    APIForm.Position := poScreenCenter;
    APIForm.Width := 450;
    APIForm.Height := 350;
    APIForm.BorderStyle := bsDialog;

    // 创建API编辑器
    APIEditor := TAIAPIEditorFrame.Create(APIForm);
    APIEditor.Parent := APIForm;
    APIEditor.Align := alClient;

    // 创建按钮面板
    var ButtonPanel := TPanel.Create(APIForm);
    ButtonPanel.Parent := APIForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 创建确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 创建取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 创建初始JSON对象
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('url', 'https://api.example.com');
    JSONObj.AddPair('method', 'GET');

    // 显示对话框
    if APIForm.ShowModal = mrOK then
    begin
      // 获取当前选中的节点
      var Node := tvJSON.Selected;
      var PropItem: PConfigPropertyItem;
      
      if Node = nil then
      begin
        // 如果没有选中节点，添加到根
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject);
      end
      else
      begin
        // 如果选中了节点，检查类型
        PropItem := PConfigPropertyItem(Node.Data);
        if PropItem^.EditorType = etObject then
          // 添加到选中的对象节点下
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node)
        else
          // 添加到选中节点的同级
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node.Parent);
      end;
      
      // 更新JSON内容显示
      UpdateJsonMemo;
    end;
  finally
    JSONObj.Free;
    APIForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddJsonSecurityClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
  SecJSON: TJSONObject;
begin
  // 添加安全属性的逻辑
  PropertyName := GetNewPropertyName('Security');
  if PropertyName = '' then Exit;

  // 创建JSON对象
  SecJSON := TJSONObject.Create;
  try
    SecJSON.AddPair('enabled', TJSONBool.Create(True));
    SecJSON.AddPair('encryption', 'AES-256');
    SecJSON.AddPair('ssl', TJSONBool.Create(True));

    // 获取当前选中的节点
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 如果没有选中节点，添加到根
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject);
    end
    else
    begin
      // 如果选中了节点，获取类型
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 添加到选中的对象节点下
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node)
      else
        // 添加到选中节点的同级
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node.Parent);
    end;
    
    // 更新JSON内容显示
    UpdateJsonMemo;
  finally
    SecJSON.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddJsonAIClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
  AIJSON: TJSONObject;
begin
  // 添加AI属性的逻辑
  PropertyName := GetNewPropertyName('AI');
  if PropertyName = '' then Exit;

  // 创建JSON对象
  AIJSON := TJSONObject.Create;
  try
    AIJSON.AddPair('model', 'gpt-4');
    AIJSON.AddPair('temperature', TJSONNumber.Create(0.7));
    AIJSON.AddPair('max_tokens', TJSONNumber.Create(1024));

    // 获取当前选中的节点
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 如果没有选中节点，添加到根
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject);
    end
    else
    begin
      // 如果选中了节点，获取类型
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 添加到选中的对象节点下
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node)
      else
        // 添加到选中节点的同级
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node.Parent);
    end;
    
    // 更新JSON内容显示
    UpdateJsonMemo;
  finally
    AIJSON.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddJsonModuleClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
  ModJSON: TJSONObject;
begin
  // 添加模块属性的逻辑
  PropertyName := GetNewPropertyName('Module');
  if PropertyName = '' then Exit;

  // 创建JSON对象
  ModJSON := TJSONObject.Create;
  try
    ModJSON.AddPair('name', PropertyName);
    ModJSON.AddPair('enabled', TJSONBool.Create(True));
    ModJSON.AddPair('version', '1.0.0');
    
    // 添加依赖数组
    var DepsArray := TJSONArray.Create;
    DepsArray.Add('core');
    DepsArray.Add('logger');
    ModJSON.AddPair('dependencies', DepsArray);

    // 获取当前选中的节点
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 如果没有选中节点，添加到根
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject);
    end
    else
    begin
      // 如果选中了节点，获取类型
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 添加到选中的对象节点下
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node)
      else
        // 添加到选中节点的同级
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node.Parent);
    end;
    
    // 更新JSON内容显示
    UpdateJsonMemo;
  finally
    ModJSON.Free;
  end;
end;

{$IFDEF DESIGNTIME}
procedure Register;
begin
  RegisterComponents('Custom', [TFrmBuildConfig]);
end;
{$ENDIF}

// 确保不在initialization部分调用Register
{$IFDEF DESIGNTIME}
initialization
  // 不要在这里调用Register，这是运行时，而Register应该只在设计时使用
{$ENDIF}

procedure TFrmBuildConfig.ShowEditorForNode(Node: TTreeNode);
var
  PropItem: PConfigPropertyItem;
  EditorFrame: TFrame;
  ButtonPanel: TPanel;
  SaveBtn, CancelBtn: TButton;
begin
  if Node = nil then Exit;
  
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;
  
  // 根据节点类型创建相应的编辑器
  case PropItem^.EditorType of
    etDatabase:
      begin
        EditorFrame := TFrameDBEditor.Create(Self);
        TFrameDBEditor(EditorFrame).OnSave := EditorSaveClick;
        TFrameDBEditor(EditorFrame).OnCancel := EditorCancelClick;
      end;
    etList:
      begin
        EditorFrame := TFrameListEditor.Create(Self);
      end;
    etObject:
      begin
        EditorFrame := TFrameObjectEditor.Create(Self);
      end;
    etArray:
      begin
        EditorFrame := TFrameArrayEditor.Create(Self);
      end;
    etAIAPI:
      begin
        EditorFrame := TAIAPIEditorFrame.Create(Self);
      end;
  else
    Exit; // 非复杂类型不处理
  end;
  
  if EditorFrame <> nil then
  begin
    // 设置编辑器位置和属性
    EditorFrame.Parent := pnlEditorContent;
    EditorFrame.Align := alClient;
    EditorFrame.Visible := True;
    
    // 为没有内置保存/取消按钮的编辑器添加按钮面板
    if not (EditorFrame is TFrameDBEditor) then
    begin
      // 创建按钮面板
      ButtonPanel := TPanel.Create(Self);
      ButtonPanel.Parent := pnlEditorContent;
      ButtonPanel.Align := alBottom;
      ButtonPanel.Height := 40;
      ButtonPanel.BevelOuter := bvNone;
      
      // 创建保存按钮
      SaveBtn := TButton.Create(Self);
      SaveBtn.Parent := ButtonPanel;
      SaveBtn.Caption := '保存';
      SaveBtn.ModalResult := mrOK;
      SaveBtn.Left := ButtonPanel.Width - 170;
      SaveBtn.Top := 8;
      SaveBtn.Width := 75;
      SaveBtn.OnClick := EditorSaveClick;
      
      // 创建取消按钮
      CancelBtn := TButton.Create(Self);
      CancelBtn.Parent := ButtonPanel;
      CancelBtn.Caption := '取消';
      CancelBtn.ModalResult := mrCancel;
      CancelBtn.Left := ButtonPanel.Width - 85;
      CancelBtn.Top := 8;
      CancelBtn.Width := 75;
      CancelBtn.OnClick := EditorCancelClick;
    end;
    
    // 加载节点数据到编辑器
    LoadNodeDataToEditor(Node, EditorFrame);
    
    // 保存当前正在编辑的节点和编辑器
    FCurrentEditNode := Node;
    FCurrentEditor := EditorFrame;
  end;
end;

procedure TFrmBuildConfig.LoadNodeDataToEditor(Node: TTreeNode; EditorFrame: TFrame);
var
  PropItem: PConfigPropertyItem;
  JSONObj: TJSONObject;
begin
  if (Node = nil) or (EditorFrame = nil) then Exit;
  
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;
  
  try
    // 尝试解析JSON数据
    if PropItem^.PropertyValue <> '' then
    begin
      JSONObj := TJSONObject.ParseJSONValue(PropItem^.PropertyValue) as TJSONObject;
      if JSONObj <> nil then
      begin
        try
          // 根据编辑器类型加载数据
          if EditorFrame is TFrameDBEditor then
          begin
            // 加载数据库连接信息
            if JSONObj.GetValue('ConnectionString') <> nil then
              TFrameDBEditor(EditorFrame).ConnectionString := JSONObj.GetValue('ConnectionString').Value;
          end
          else if EditorFrame is TFrameListEditor then
          begin
            // 加载列表信息
            // TFrameListEditor实现...
          end
          else if EditorFrame is TFrameObjectEditor then
          begin
            // 加载对象信息
            // TFrameObjectEditor实现...
          end
          else if EditorFrame is TFrameArrayEditor then
          begin
            // 加载数组信息
            // TFrameArrayEditor实现...
          end
          else if EditorFrame is TAIAPIEditorFrame then
          begin
            // 加载API信息
            // TAIAPIEditorFrame实现...
          end;
        finally
          JSONObj.Free;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('加载属性数据失败: ' + E.Message);
  end;
end;

procedure TFrmBuildConfig.SaveEditorDataToNode;
var
  PropItem: PConfigPropertyItem;
  JSONObj: TJSONObject;
begin
  if (FCurrentEditor = nil) or (FCurrentEditNode = nil) then Exit;
  
  PropItem := PConfigPropertyItem(FCurrentEditNode.Data);
  if PropItem = nil then Exit;
  
  JSONObj := TJSONObject.Create;
  try
    // 根据编辑器类型保存数据
    if FCurrentEditor is TFrameDBEditor then
    begin
      // 保存数据库连接信息
      JSONObj.AddPair('ConnectionString', TFrameDBEditor(FCurrentEditor).ConnectionString);
    end
    else if FCurrentEditor is TFrameListEditor then
    begin
      // 保存列表信息
      // TFrameListEditor实现...
    end
    else if FCurrentEditor is TFrameObjectEditor then
    begin
      // 保存对象信息
      // TFrameObjectEditor实现...
    end
    else if FCurrentEditor is TFrameArrayEditor then
    begin
      // 保存数组信息
      // TFrameArrayEditor实现...
    end
    else if FCurrentEditor is TAIAPIEditorFrame then
    begin
      // 保存API信息
      // TAIAPIEditorFrame实现...
    end;
    
    // 更新节点数据
    PropItem^.PropertyValue := JSONObj.ToString;
  finally
    JSONObj.Free;
  end;
  
  // 更新JSON视图
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.EditorSaveClick(Sender: TObject);
begin
  // 保存编辑器数据到节点
  SaveEditorDataToNode;
  
  // 清除编辑器内容面板中的所有控件
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 重置当前编辑器和节点
  FCurrentEditor := nil;
  FCurrentEditNode := nil;
  
  // 切回JSON页
  PageControl1.ActivePage := tsJSON;
end;

procedure TFrmBuildConfig.EditorCancelClick(Sender: TObject);
begin
  // 清除编辑器内容面板中的所有控件
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 重置当前编辑器和节点
  FCurrentEditor := nil;
  FCurrentEditNode := nil;
  
  // 切回JSON页
  PageControl1.ActivePage := tsJSON;
end;

end.
