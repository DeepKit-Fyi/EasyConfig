unit ViewBuildConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, JSONHelpers, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
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
    FCurrentEditNode: TTreeNode; // 褰撳墠缂栬緫鐨凧SON鑺傜偣
    FCurrentEditor: TFrame;      // 褰撳墠浣跨敤鐨勭紪杈慒rame

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

    // 鏁版嵁搴撶紪杈戝櫒浜嬩欢
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

procedure TFrmBuildConfig.tvJSONChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
  begin
    // 璁剧疆缂栬緫鎸夐挳鐨勫彲鐢ㄦ€?    if Assigned(popupJSON) then
    begin
      if Assigned(MenuItem2) then MenuItem2.Enabled := True;  // 缂栬緫
      if Assigned(MenuItem3) then MenuItem3.Enabled := True;  // 鍒犻櫎
      if Assigned(MenuItem4) then MenuItem4.Enabled := True;  // 娣诲姞
    end;

    // 鏄剧ず缂栬緫妗?    ShowPropertyEditor(Node);
  end
  else
  begin
    // 娌℃湁閫変腑鑺傜偣
    if Assigned(popupJSON) then
    begin
      if Assigned(MenuItem2) then MenuItem2.Enabled := False;
      if Assigned(MenuItem3) then MenuItem3.Enabled := False;
      if Assigned(MenuItem4) then MenuItem4.Enabled := False;
    end;

    // 闅愯棌缂栬緫妗?    HidePropertyEditor;
  end;
end;

procedure TFrmBuildConfig.sgINISelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  // 璁剧疆琛岀紪杈戞寜閽殑鍙敤鎬?  var canEdit := (ARow > 0) and (sgINI.Cells[0, ARow] <> '');
  
  // 璁剧疆閫変腑琛屾寜閽殑鍙敤鎬?  if Assigned(popupINI) then
  begin
    if Assigned(N2) then N2.Enabled := canEdit;  // 缂栬緫
    if Assigned(N3) then N3.Enabled := canEdit;  // 鍒犻櫎
    if Assigned(N4) then N4.Enabled := canEdit;  // 娣诲姞
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
      // 绉诲姩鏁版嵁
      TempSection := sgINI.Cells[0, SourceRow];
      TempKey := sgINI.Cells[1, SourceRow];
      TempValue := sgINI.Cells[2, SourceRow];

      // 绉诲姩
      for var i := SourceRow downto TargetRow + 1 do
      begin
        sgINI.Cells[0, i] := sgINI.Cells[0, i - 1];
        sgINI.Cells[1, i] := sgINI.Cells[1, i - 1];
        sgINI.Cells[2, i] := sgINI.Cells[2, i - 1];
        sgINI.Objects[0, i] := sgINI.Objects[0, i - 1];
      end;

      // 澶嶅埗鏁版嵁
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
      // 鑾峰彇婧愯妭鐐规暟鎹?      PropItem := PConfigPropertyItem(SourceNode.Data);

      // 绉诲姩鑺傜偣
      SourceNode.MoveTo(TargetNode, naAddChild);

      // 鏇存柊璺緞
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
  // 鍒濆鍖?  InitializeFrame;
  InitializeButtons;
  InitializePopupMenus;
  InitializeDragDrop;
end;

procedure TFrmBuildConfig.FormDestroy(Sender: TObject);
begin
  // 娓呴櫎鏁版嵁
  ClearAllData;
end;

procedure TFrmBuildConfig.InitializeFrame;
begin
  // 鍒濆鍖朏rame
  // 杩欓噷涓嶉渶瑕佸垵濮嬪寲锛屽洜涓篎rame鐨勫垵濮嬪寲鍦–reate鏂规硶涓凡缁忓畬鎴?end;

procedure TFrmBuildConfig.InitializeGridColumns;
begin
  // 鍒濆鍖栫綉鏍煎垪
end;

procedure TFrmBuildConfig.InitializeButtons;
begin
  // 鍒濆鍖栨寜閽?end;

procedure TFrmBuildConfig.InitializePopupMenus;
begin
  // 鍒濆鍖栧彸閿彍鍗?end;

procedure TFrmBuildConfig.InitializeDragDrop;
begin
  // 鍒濆鍖栨嫋鏀惧姛鑳?end;

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

  // 鏄剧ず缂栬緫妗?  FCurrentJsonNode := Node;
  FIsEditing := True;
  edtEditing.Text := TTreeNode(Node).Text;
  pnlEditing.Visible := True;
end;

procedure TFrmBuildConfig.HidePropertyEditor;
begin
  // 闅愯棌缂栬緫妗?  FIsEditing := False;
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

  // 鍒濆鍖栫綉鏍?  sgINI.RowCount := 2;  // 鍥哄畾涓?琛岋紝鍥犱负闇€瑕佷繚鐣欐爣棰樿
  sgINI.Cells[0, 1] := '';
  sgINI.Cells[1, 1] := '';
  sgINI.Cells[2, 1] := '';

  // 璇诲彇INI鏂囦欢
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;
  Keys := TStringList.Create;

  try
    // 璇诲彇鎵€鏈夎妭
    IniFile.ReadSections(Sections);

    // 濡傛灉鏈夎妭锛屽垯鍒濆鍖栫綉鏍艰鏁?    if Sections.Count > 0 then
      sgINI.RowCount := 1;

    // 閬嶅巻姣忎釜鑺?    for i := 0 to Sections.Count - 1 do
    begin
      Section := Sections[i];
      Keys.Clear;

      // 璇诲彇鑺備腑鐨勯敭鍊煎
      IniFile.ReadSection(Section, Keys);

      // 閬嶅巻姣忎釜閿€煎
      for j := 0 to Keys.Count - 1 do
      begin
        Key := Keys[j];
        Value := IniFile.ReadString(Section, Key, '');

        // 娣诲姞鍒扮綉鏍?        AddPropertyToGrid(Section, Key, Value);
      end;
    end;

    // 鏇存柊INI鏄剧ず
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
  // 鍒涘缓INI鏂囦欢
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;

  try
    // 璇诲彇鎵€鏈夎妭
    IniFile.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
      IniFile.EraseSection(Sections[i]);

    // 閬嶅巻鎵€鏈夎
    for i := 1 to sgINI.RowCount - 1 do
    begin
      if (sgINI.Cells[0, i] <> '') and (sgINI.Cells[1, i] <> '') then
      begin
        Section := sgINI.Cells[0, i];
        Key := sgINI.Cells[1, i];
        Value := sgINI.Cells[2, i];

        // 鍐欏叆INI鏂囦欢
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

      // 鍒ゆ柇鍊兼槸鍚︿负缂栬緫绫诲瀷
      if Pair.JsonValue is TJSONObject then
        EditorType := etObject
      else if Pair.JsonValue is TJSONArray then
        EditorType := etArray
      else
        EditorType := etPlain;

      // 娣诲姞鑺傜偣
      ChildNode := AddPropertyToTree(Pair.JsonString.Value, Pair.JsonValue.ClassName,
                                     Pair.JsonValue.ToString, EditorType, ParentNode);

      // 閫掑綊澶勭悊瀛愯妭鐐?      if Pair.JsonValue is TJSONObject then
        ProcessJsonObject(TJSONObject(Pair.JsonValue), ChildNode)
      else if Pair.JsonValue is TJSONArray then
      begin
        // 澶勭悊鏁扮粍
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

  // 鍒濆鍖栨爲瑙嗗浘
  tvJSON.Items.Clear;

  // 璇诲彇JSON鏂囦欢
  try
    JsonStr := TFile.ReadAllText(FileName);
    JsonValue := TJSONObject.ParseJSONValue(JsonStr);

    if Assigned(JsonValue) and (JsonValue is TJSONObject) then
    begin
      JsonObject := TJSONObject(JsonValue);

      // 澶勭悊JSON瀵硅薄
      ProcessJsonObject(JsonObject);

      // 灞曞紑鎵€鏈夎妭鐐?      tvJSON.FullExpand;

      // 鏇存柊JSON鏄剧ず
      UpdateJsonMemo;
    end;
  except
    on E: Exception do
      ShowMessage('璇诲彇JSON鏂囦欢澶辫触: ' + E.Message);
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
      // 鍒涘缓瀵硅薄
      JsonObj := TJSONObject.Create;

      // 閬嶅巻瀛愯妭鐐?      ChildNode := Node.getFirstChild;
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
      // 鍒涘缓鏁扮粍
      JsonArray := TJSONArray.Create;

      // 閬嶅巻瀛愯妭鐐?      ChildNode := Node.getFirstChild;
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
      // 鍒涘缓绠€鍗曞€?      try
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
  // 鍒涘缓鏍瑰璞?  RootObject := TJSONObject.Create;

  // 閬嶅巻鎵€鏈夎妭鐐?  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    var JsonValue := BuildJsonObject(RootNode);
    if JsonValue <> nil then
      RootObject.AddPair(RootNode.Text, JsonValue);

    RootNode := RootNode.getNextSibling;
  end;

  try
    // 鏍煎紡鍖朖SON
    JsonStr := RootObject.Format(2);
    TFile.WriteAllText(FileName, JsonStr);
  finally
    RootObject.Free;
  end;
end;

procedure TFrmBuildConfig.UpdateIniMemo;
begin
  // 娓呯┖INI鏄剧ず
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

    // 鐢熸垚缂╄繘瀛楃涓?    IndentStr := StringOfChar(' ', Indent * 2);

    PropItem := PConfigPropertyItem(Node.Data);

    // 澶勭悊鑺傜偣鏁版嵁
    if PropItem^.EditorType = etObject then
    begin
      // 寮€濮?      NodeText := IndentStr + '"' + Node.Text + '": {';
      Memo2.Lines.Add(NodeText);

      // 閬嶅巻瀛愯妭鐐?      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 濡傛灉瀛愯妭鐐逛笉鏄渶鍚庝竴涓紝鍒欐坊鍔犻€楀彿
        if ChildNode.getNextSibling <> nil then
          Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 缁撴潫
      Memo2.Lines.Add(IndentStr + '}');
    end
    else if PropItem^.EditorType = etArray then
    begin
      // 寮€濮?      NodeText := IndentStr + '"' + Node.Text + '": [';
      Memo2.Lines.Add(NodeText);

      // 閬嶅巻瀛愯妭鐐?      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 濡傛灉瀛愯妭鐐逛笉鏄渶鍚庝竴涓紝鍒欐坊鍔犻€楀彿
        if ChildNode.getNextSibling <> nil then
          Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 缁撴潫
      Memo2.Lines.Add(IndentStr + ']');
    end
    else
    begin
      // 鍒涘缓绠€鍗曞€?      NodeText := IndentStr + '"' + Node.Text + '": "' + PropItem^.PropertyValue + '"';
      Memo2.Lines.Add(NodeText);
    end;
  end;

var
  RootNode: TTreeNode;
begin
  // 娓呯┖JSON鏄剧ず
  Memo2.Lines.Clear;

  // 寮€濮婮SON
  Memo2.Lines.Add('{');

  // 閬嶅巻鎵€鏈夎妭鐐?  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    ProcessNode(RootNode, 1);

    // 濡傛灉鑺傜偣涓嶆槸鏈€鍚庝竴涓紝鍒欐坊鍔犻€楀彿
    if RootNode.getNextSibling <> nil then
      Memo2.Lines[Memo2.Lines.Count - 1] := Memo2.Lines[Memo2.Lines.Count - 1] + ',';

    RootNode := RootNode.getNextSibling;
  end;

  // 缁撴潫JSON
  Memo2.Lines.Add('}');
end;

procedure TFrmBuildConfig.ClearAllData;
begin
  // 娓呴櫎鏁版嵁
  sgINI.RowCount := 1;
  tvJSON.Items.Clear;
  Memo1.Clear;
  Memo2.Clear;
end;

function TFrmBuildConfig.GetPropertyInputFromUser(const Caption, Prompt: string; var Value: string): Boolean;
begin
  // 鐢ㄦ埛杈撳叆
  Result := InputQuery(Caption, Prompt, Value);
end;

function TFrmBuildConfig.GetNewPropertyName(const DefaultName: string): string;
var
  NewName: string;
begin
  NewName := DefaultName;
  if GetPropertyInputFromUser('杈撳叆鍚嶇О', '璇疯緭鍏ュ悕绉?', NewName) then
    Result := NewName
  else
    Result := DefaultName;
end;

function TFrmBuildConfig.GetColorValue: string;
begin
  // 鑾峰彇棰滆壊鍊?  Result := '';
  if dlgSelectColor.Execute then
    Result := Format('$%.8x', [dlgSelectColor.Color]);
end;

function TFrmBuildConfig.GetPathValue: string;
begin
  // 鑾峰彇璺緞鍊?  Result := '';
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
  // 娣诲姞鏂囨湰灞炴€?  PropertyName := GetNewPropertyName('Text');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('杈撳叆鏂囨湰', '璇疯緭鍏ユ枃鏈?', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddNumberClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Section: string;
  Value: Double;
begin
  // 娣诲姞鏁板瓧灞炴€?  PropertyName := GetNewPropertyName('Number');
  if PropertyName = '' then Exit;

  PropertyValue := '0';
  if not GetPropertyInputFromUser('杈撳叆鏁板瓧', '璇疯緭鍏ユ暟瀛?', PropertyValue) then Exit;

  // 楠岃瘉鏄惁涓烘湁鏁堟暟瀛?  try
    Value := StrToFloat(PropertyValue);
  except
    on E: Exception do
    begin
      ShowMessage('鏃犳晥鐨勬暟瀛楁牸寮?);
      Exit;
    end;
  end;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddPathClick(Sender: TObject);
var
  PropertyName: string;
  PathValue: string;
  Section: string;
begin
  // 娣诲姞璺緞灞炴€?  PropertyName := GetNewPropertyName('Path');
  if PropertyName = '' then Exit;

  // 鑾峰彇璺緞
  PathValue := GetPathValue;
  if PathValue = '' then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, PathValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddBooleanClick(Sender: TObject);
var
  PropertyName: string;
  BoolValue: Boolean;
  Section: string;
  BoolStr: string;
begin
  // 娣诲姞甯冨皵灞炴€?  PropertyName := GetNewPropertyName('Boolean');
  if PropertyName = '' then Exit;

  // 榛樿鍊间负False
  BoolValue := False;

  // 鏄剧ず閫夋嫨瀵硅瘽妗?  if MessageDlg('閫夋嫨甯冨皵鍊?, mtConfirmation, mbYesNo, 0) = mrYes then
    BoolValue := True;

  // 杞崲涓哄瓧绗︿覆
  if BoolValue then
    BoolStr := 'True'
  else
    BoolStr := 'False';

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, BoolStr);

  // 鏇存柊INI鏄剧ず
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
  // 娣诲姞鏃ユ湡灞炴€?  PropertyName := GetNewPropertyName('Date');
  if PropertyName = '' then Exit;

  // 鏄剧ず鏃ユ湡閫夋嫨瀵硅瘽妗?  DateForm := TForm.Create(Self);
  try
    DateForm.Caption := '閫夋嫨鏃ユ湡';
    DateForm.Position := poScreenCenter;
    DateForm.Width := 300;
    DateForm.Height := 150;
    DateForm.BorderStyle := bsDialog;

    // 娣诲姞鏃ユ湡閫夋嫨鍣?    DatePicker := TDateTimePicker.Create(DateForm);
    DatePicker.Parent := DateForm;
    DatePicker.Left := 20;
    DatePicker.Top := 20;
    DatePicker.Width := 260;
    DatePicker.Date := Now;

    // 娣诲姞鎸夐挳
    BtnOK := TButton.Create(DateForm);
    BtnOK.Parent := DateForm;
    BtnOK.Caption := '纭畾';
    BtnOK.ModalResult := mrOK;
    BtnOK.Left := 120;
    BtnOK.Top := 70;
    BtnOK.Width := 75;

    BtnCancel := TButton.Create(DateForm);
    BtnCancel.Parent := DateForm;
    BtnCancel.Caption := '鍙栨秷';
    BtnCancel.ModalResult := mrCancel;
    BtnCancel.Left := 205;
    BtnCancel.Top := 70;
    BtnCancel.Width := 75;

    // 鏄剧ず瀵硅瘽妗?    if DateForm.ShowModal = mrOK then
    begin
      DateValue := DatePicker.Date;
      DateStr := FormatDateTime('yyyy-mm-dd', DateValue);

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 娣诲姞灞炴€?      AddPropertyToGrid(Section, 'ctPlain.' + PropertyName, DateStr);

      // 鏇存柊INI鏄剧ず
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
  // 娣诲姞棰滆壊灞炴€?  PropertyName := GetNewPropertyName('Color');
  if PropertyName = '' then Exit;

  // 鑾峰彇棰滆壊
  ColorValue := GetColorValue;
  if ColorValue = '' then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'General';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctColor.' + PropertyName, ColorValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddFontClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  FontDialog: TFontDialog;
  FontStr: string;
begin
  // 娣诲姞瀛椾綋灞炴€?  PropertyName := GetNewPropertyName('Font');
  if PropertyName = '' then Exit;

  // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?  FontDialog := TFontDialog.Create(Self);
  try
    // 璁剧疆榛樿瀛椾綋
    FontDialog.Font.Name := 'Arial';
    FontDialog.Font.Size := 10;
    FontDialog.Font.Style := [];

    // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?    if FontDialog.Execute then
    begin
      // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?      FontStr := Format('%s,%d,%s,%s,%s,%s', [
        FontDialog.Font.Name,
        FontDialog.Font.Size,
        BoolToStr(fsBold in FontDialog.Font.Style, True),
        BoolToStr(fsItalic in FontDialog.Font.Style, True),
        BoolToStr(fsUnderline in FontDialog.Font.Style, True),
        ColorToString(FontDialog.Font.Color)
      ]);

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 娣诲姞灞炴€?      AddPropertyToGrid(Section, 'ctFont.' + PropertyName, FontStr);

      // 鏇存柊INI鏄剧ず
      UpdateIniMemo;
    end;
  finally
    FontDialog.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorComplexClick(Sender: TObject);
begin
  // 娣诲姞澶嶆潅棰滆壊灞炴€?end;

procedure TFrmBuildConfig.btnAddDatabaseClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
begin
  // 娣诲姞鏁版嵁搴撳睘鎬?  PropertyName := GetNewPropertyName('Database');
  if PropertyName = '' then Exit;

  // 鍒涘缓鏂拌妭鐐瑰苟娣诲姞灞炴€?  Node := AddPropertyToTree(PropertyName, 'TJSONObject', '{"ConnectionString":""}', etDatabase);
  
  // 閫夋嫨鏂拌妭鐐?  tvJSON.Selected := Node;
  
  // 鍒囨崲鍒扮紪杈戦〉闈?  PageControl1.ActivePage := tsEditor;
  
  // 娓呴櫎缂栬緫鍐呭
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 鏄剧ず缂栬緫妗?  ShowEditorForNode(Node);
  
  // 鏇存柊JSON鏄剧ず
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
  // 娣诲姞鍒楄〃灞炴€?  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  // 鍒涘缓鍒楄〃缂栬緫瀵硅瘽妗?  ListForm := TForm.Create(Self);
  try
    ListForm.Caption := '鍒楄〃缂栬緫';
    ListForm.Position := poScreenCenter;
    ListForm.Width := 400;
    ListForm.Height := 350;
    ListForm.BorderStyle := bsDialog;

    // 鍒涘缓鍒楄〃缂栬緫鍣?    ListEditor := TFrameListEditor.Create(ListForm);
    ListEditor.Parent := ListForm;
    ListEditor.Align := alClient;

    // 鍒涘缓鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ListForm);
    ButtonPanel.Parent := ListForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 鍒涘缓纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 鍒涘缓鍙栨秷鎸夐挳
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '鍙栨秷';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 寮€濮婮SON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etList');
    JSONObj.AddPair('value', TJSONArray.Create);

    // 璁剧疆JSON
    ListEditor.JSONObject := JSONObj;

    // 鏄剧ず瀵硅瘽妗?    if ListForm.ShowModal = mrOK then
    begin
      // 鑾峰彇鍒楄〃JSON
      ListEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 灏嗗垪琛ㄨ浆鎹负瀛楃涓?      var ListStr := '';
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

      // 娣诲姞灞炴€?      AddPropertyToGrid(Section, 'ctList.' + PropertyName, ListStr);

      // 鏇存柊INI鏄剧ず
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
  // 娣诲姞瀵硅薄灞炴€?  PropertyName := GetNewPropertyName('Object');
  if PropertyName = '' then Exit;

  // 鍒涘缓瀵硅薄缂栬緫瀵硅瘽妗?  ObjectForm := TForm.Create(Self);
  try
    ObjectForm.Caption := '瀵硅薄缂栬緫';
    ObjectForm.Position := poScreenCenter;
    ObjectForm.Width := 500;
    ObjectForm.Height := 400;
    ObjectForm.BorderStyle := bsDialog;

    // 鍒涘缓瀵硅薄缂栬緫鍣?    ObjectEditor := TFrameObjectEditor.Create(ObjectForm);
    ObjectEditor.Parent := ObjectForm;
    ObjectEditor.Align := alClient;

    // 鍒涘缓鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ObjectForm);
    ButtonPanel.Parent := ObjectForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 鍒涘缓纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 鍒涘缓鍙栨秷鎸夐挳
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '鍙栨秷';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 寮€濮婮SON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etObject');

    // 璁剧疆JSON
    ObjectEditor.JSONObject := JSONObj;

    // 鏄剧ず瀵硅瘽妗?    if ObjectForm.ShowModal = mrOK then
    begin
      // 鑾峰彇瀵硅薄JSON
      ObjectEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 娣诲姞灞炴€?      AddPropertyToGrid(Section, 'ctObject.' + PropertyName, JSONObj.ToString);

      // 鏇存柊INI鏄剧ず
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
  // 娣诲姞鏁扮粍灞炴€?  PropertyName := GetNewPropertyName('Array');
  if PropertyName = '' then Exit;

  // 鍒涘缓鏁扮粍缂栬緫瀵硅瘽妗?  ArrayForm := TForm.Create(Self);
  try
    ArrayForm.Caption := '鏁扮粍缂栬緫';
    ArrayForm.Position := poScreenCenter;
    ArrayForm.Width := 500;
    ArrayForm.Height := 400;
    ArrayForm.BorderStyle := bsDialog;

    // 鍒涘缓鏁扮粍缂栬緫鍣?    ArrayEditor := TFrameArrayEditor.Create(ArrayForm);
    ArrayEditor.Parent := ArrayForm;
    ArrayEditor.Align := alClient;

    // 鍒涘缓鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ArrayForm);
    ButtonPanel.Parent := ArrayForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 鍒涘缓纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 鍒涘缓鍙栨秷鎸夐挳
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '鍙栨秷';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 寮€濮婮SON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etArray');
    JSONObj.AddPair('itemType', 'string');
    JSONObj.AddPair('items', TJSONArray.Create);

    // 璁剧疆JSON
    ArrayEditor.JSONObject := JSONObj;

    // 鏄剧ず瀵硅瘽妗?    if ArrayForm.ShowModal = mrOK then
    begin
      // 鑾峰彇鏁扮粍JSON
      ArrayEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := sgINI.Cells[0, 1]
      else
        Section := 'General';

      // 娣诲姞灞炴€?      AddPropertyToGrid(Section, 'ctArray.' + PropertyName, JSONObj.ToString);

      // 鏇存柊INI鏄剧ず
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
  // 鑾峰彇褰撳墠琛?  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 鑾峰彇鑺傚悕鍜屽€?  Section := sgINI.Cells[0, Row];
  Key := sgINI.Cells[1, Row];
  PropertyValue := sgINI.Cells[2, Row];

  // 鏍规嵁涓嶅悓鐨勭紪杈戠被鍨嬭繘琛岀紪杈?  if Key.StartsWith('ctFont.') then
  begin
    // 瀛椾綋缂栬緫
    var FontDialog := TFontDialog.Create(Self);
    try
      // 瑙ｆ瀽瀛楃涓?      var FontParts := PropertyValue.Split([',']);
      if Length(FontParts) >= 6 then
      begin
        FontDialog.Font.Name := FontParts[0];
        FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

        // 璁剧疆鏍峰紡
        FontDialog.Font.Style := [];
        if StrToBoolDef(FontParts[2], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsBold];
        if StrToBoolDef(FontParts[3], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsItalic];
        if StrToBoolDef(FontParts[4], False) then
          FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];

        // 璁剧疆棰滆壊
        FontDialog.Font.Color := StringToColor(FontParts[5]);
      end;

      // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?      if FontDialog.Execute then
      begin
        // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?        NewValue := Format('%s,%d,%s,%s,%s,%s', [
          FontDialog.Font.Name,
          FontDialog.Font.Size,
          BoolToStr(fsBold in FontDialog.Font.Style, True),
          BoolToStr(fsItalic in FontDialog.Font.Style, True),
          BoolToStr(fsUnderline in FontDialog.Font.Style, True),
          ColorToString(FontDialog.Font.Color)
        ]);

        // 鏇存柊缃戞牸
        sgINI.Cells[2, Row] := NewValue;

        // 鏇存柊INI鏄剧ず
        UpdateIniMemo;
      end;
    finally
      FontDialog.Free;
    end;
  end
  else if Key.StartsWith('ctColor.') then
  begin
    // 棰滆壊缂栬緫
    var ColorDialog := TColorDialog.Create(Self);
    try
      // 璁剧疆榛樿棰滆壊
      try
        ColorDialog.Color := StringToColor(PropertyValue);
      except
        ColorDialog.Color := clBlack;
      end;

      // 鏄剧ず棰滆壊閫夋嫨瀵硅瘽妗?      if ColorDialog.Execute then
      begin
        // 灏嗛鑹茶浆鎹负瀛楃涓?        NewValue := ColorToString(ColorDialog.Color);

        // 鏇存柊缃戞牸
        sgINI.Cells[2, Row] := NewValue;

        // 鏇存柊INI鏄剧ず
        UpdateIniMemo;
      end;
    finally
      ColorDialog.Free;
    end;
  end
  else if Key.StartsWith('ctPlain.') then
  begin
    // 鏂囨湰缂栬緫
    NewValue := PropertyValue;
    if GetPropertyInputFromUser('缂栬緫鏂囨湰', '璇疯緭鍏ユ枃鏈?', NewValue) then
    begin
      // 鏇存柊缃戞牸
      sgINI.Cells[2, Row] := NewValue;

      // 鏇存柊INI鏄剧ず
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
  // 鑾峰彇褰撳墠琛?  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 鑾峰彇鑺傚悕鍜屽€?  Section := sgINI.Cells[0, Row];
  Key := sgINI.Cells[1, Row];
  Value := sgINI.Cells[2, Row];

  // 鑾峰彇鏂板悕绉?  NewKey := Key;
  if GetPropertyInputFromUser('杈撳叆鏂板悕绉?, '璇疯緭鍏ユ柊鍚嶇О:', NewKey) then
  begin
    // 鏇存柊缃戞牸
    sgINI.Cells[1, Row] := NewKey;

    // 鏇存柊INI鏄剧ず
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteINIPropertyClick(Sender: TObject);
var
  RowIndex, i: Integer;
begin
  // 鑾峰彇褰撳墠琛?  RowIndex := sgINI.Row;
  if (RowIndex <= 0) or (RowIndex >= sgINI.RowCount) then
    Exit;
  
  // 纭鍒犻櫎
  if MessageDlg('纭瑕佸垹闄ゅ悧?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 鍒犻櫎琛?    for i := RowIndex to sgINI.RowCount - 2 do
    begin
      sgINI.Cells[0, i] := sgINI.Cells[0, i + 1];
      sgINI.Cells[1, i] := sgINI.Cells[1, i + 1];
      sgINI.Cells[2, i] := sgINI.Cells[2, i + 1];
      sgINI.Objects[0, i] := sgINI.Objects[0, i + 1];
    end;
    
    // 濡傛灉琛屾暟澶т簬2锛屽垯鍒犻櫎鏈€鍚庝竴琛?    if sgINI.RowCount > 2 then
      sgINI.RowCount := sgINI.RowCount - 1
    else
    begin
      // 濡傛灉鍙湁涓€琛岋紝鍒欐竻绌哄唴瀹?      sgINI.Cells[0, 1] := '';
      sgINI.Cells[1, 1] := '';
      sgINI.Cells[2, 1] := '';
    end;
    
    // 鏇存柊INI鏄剧ず
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.EditJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewValue: string;
begin
  // 鑾峰彇褰撳墠鑺傜偣
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 鏍规嵁涓嶅悓鐨勭紪杈戠被鍨嬭繘琛岀紪杈?  case PropItem^.EditorType of
    etPlain:
      begin
        // 鏂囨湰缂栬緫
        NewValue := PropItem^.PropertyValue;
        if GetPropertyInputFromUser('缂栬緫鏂囨湰', '璇疯緭鍏ユ枃鏈?', NewValue) then
        begin
          // 鏇存柊灞炴€у€?          PropItem^.PropertyValue := NewValue;

          // 鏇存柊JSON鏄剧ず
          UpdateJsonMemo;
        end;
      end;
    etFont:
      begin
        // 瀛椾綋缂栬緫
        var FontDialog := TFontDialog.Create(Self);
        try
          // 瑙ｆ瀽瀛楃涓?          var FontParts := PropItem^.PropertyValue.Split([',']);
          if Length(FontParts) >= 6 then
          begin
            FontDialog.Font.Name := FontParts[0];
            FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

            // 璁剧疆鏍峰紡
            FontDialog.Font.Style := [];
            if StrToBoolDef(FontParts[2], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsBold];
            if StrToBoolDef(FontParts[3], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsItalic];
            if StrToBoolDef(FontParts[4], False) then
              FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];

            // 璁剧疆棰滆壊
            FontDialog.Font.Color := StringToColor(FontParts[5]);
          end;

          // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?          if FontDialog.Execute then
          begin
            // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?            NewValue := Format('%s,%d,%s,%s,%s,%s', [
              FontDialog.Font.Name,
              FontDialog.Font.Size,
              BoolToStr(fsBold in FontDialog.Font.Style, True),
              BoolToStr(fsItalic in FontDialog.Font.Style, True),
              BoolToStr(fsUnderline in FontDialog.Font.Style, True),
              ColorToString(FontDialog.Font.Color)
            ]);

            // 鏇存柊灞炴€у€?            PropItem^.PropertyValue := NewValue;

            // 鏇存柊JSON鏄剧ず
            UpdateJsonMemo;
          end;
        finally
          FontDialog.Free;
        end;
      end;
    etColor:
      begin
        // 棰滆壊缂栬緫
        var ColorDialog := TColorDialog.Create(Self);
        try
          // 璁剧疆榛樿棰滆壊
          try
            ColorDialog.Color := StringToColor(PropItem^.PropertyValue);
          except
            ColorDialog.Color := clBlack;
          end;

          // 鏄剧ず棰滆壊閫夋嫨瀵硅瘽妗?          if ColorDialog.Execute then
          begin
            // 灏嗛鑹茶浆鎹负瀛楃涓?            NewValue := ColorToString(ColorDialog.Color);

            // 鏇存柊灞炴€у€?            PropItem^.PropertyValue := NewValue;

            // 鏇存柊JSON鏄剧ず
            UpdateJsonMemo;
          end;
        finally
          ColorDialog.Free;
        end;
      end;
    etObject, etArray:
      begin
        // 瀵硅薄鍜屾暟缁勯渶瑕佸崟鐙鐞?        ShowMessage('闇€瑕佸崟鐙鐞嗗璞″拰鏁扮粍');
      end;
  end;
end;

procedure TFrmBuildConfig.RenameJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewName: string;
begin
  // 鑾峰彇褰撳墠鑺傜偣
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 鑾峰彇鏂板悕绉?  NewName := Node.Text;
  if GetPropertyInputFromUser('杈撳叆鏂板悕绉?, '璇疯緭鍏ユ柊鍚嶇О:', NewName) then
  begin
    // 鏇存柊鑺傜偣鍚嶇О
    Node.Text := NewName;

    // 鏇存柊璺緞
    PropItem := PConfigPropertyItem(Node.Data);
    if PropItem <> nil then
      PropItem^.PropertyPath := BuildPropertyPath(Node);

    // 鏇存柊JSON鏄剧ず
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  // 鑾峰彇褰撳墠鑺傜偣
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 纭鍒犻櫎
  if MessageDlg('纭瑕佸垹闄ゅ悧?\n娉ㄦ剰锛氳繖灏嗗垹闄ゆ墍鏈夊瓙鑺傜偣鍜屾暟鎹?, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 鍒犻櫎鑺傜偣
    if Node.Data <> nil then
      Dispose(PConfigPropertyItem(Node.Data));

    // 鍒犻櫎鑺傜偣
    Node.Delete;

    // 鏇存柊JSON鏄剧ず
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.btnUpdateClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 妫€鏌ョ紪杈戞寜閽槸鍚﹀彲鐢?  if not FIsEditing then Exit;

  // 鑾峰彇褰撳墠鑺傜偣
  Node := FCurrentJsonNode;
  if Node = nil then Exit;

  // 鑾峰彇灞炴€у€?  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 鏇存柊灞炴€у€?  PropItem^.PropertyValue := edtEditing.Text;

  // 鏇存柊JSON鏄剧ず
  UpdateJsonMemo;

  // 闅愯棌缂栬緫妗?  HidePropertyEditor;
end;

procedure TFrmBuildConfig.btnSaveClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 妫€鏌ヤ繚瀛樻寜閽槸鍚﹀彲鐢?  if (FCurrentIniFile = '') and (edtFileName.Text = '') then
  begin
    // 娌℃湁閫夋嫨鏂囦欢锛屾樉绀烘墦寮€鏂囦欢瀵硅瘽妗?    dlgOpenFile.Filter := 'INI鏂囦欢 (*.ini)|*.ini|All files (*.*)|*.*';
    dlgOpenFile.Title := '閫夋嫨INI鏂囦欢';
    dlgOpenFile.DefaultExt := 'ini';

    if dlgOpenFile.Execute then
    begin
      IniFileName := dlgOpenFile.FileName;
      JsonFileName := ChangeFileExt(IniFileName, '.json');

      // 淇濆瓨INI鏂囦欢
      SaveIniFile(IniFileName);
      SaveJsonFile(JsonFileName);

      // 鏇存柊褰撳墠鏂囦欢鍚?      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;
      edtFileName.Text := IniFileName;

      ShowMessage('鏂囦欢宸蹭繚瀛?);
    end;
  end
  else
  begin
    // 浣跨敤褰撳墠鏂囦欢
    if FCurrentIniFile = '' then
      FCurrentIniFile := edtFileName.Text;

    JsonFileName := ChangeFileExt(FCurrentIniFile, '.json');

    // 淇濆瓨INI鏂囦欢
    SaveIniFile(FCurrentIniFile);
    SaveJsonFile(JsonFileName);

    ShowMessage('鏂囦欢宸蹭繚瀛?);
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
  // 閫夋嫨INI鏂囦欢
  dlgOpenFile.Filter := 'INI鏂囦欢 (*.ini)|*.ini|All files (*.*)|*.*';
  dlgOpenFile.Title := '閫夋嫨INI鏂囦欢';

  if dlgOpenFile.Execute then
  begin
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // 鍔犺浇閰嶇疆鏂囦欢
    LoadConfigFiles(IniFileName, JsonFileName);

    // 鏇存柊鏂囦欢鍚?    edtFileName.Text := IniFileName;
  end;
end;

procedure TFrmBuildConfig.sgINIDblClick(Sender: TObject);
begin
  // INI鍙屽嚮浜嬩欢
  EditINIPropertyClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONDblClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 鑾峰彇褰撳墠鑺傜偣
  Node := tvJSON.Selected;
  if Node = nil then Exit;
  
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;
  
  // 鏍规嵁涓嶅悓鐨勭紪杈戠被鍨嬭繘琛岀紪杈?  if PropItem^.EditorType in [etObject, etArray, etDatabase, etList, etAIAPI] then
  begin
    // 鍒囨崲鍒扮紪杈戦〉闈?    PageControl1.ActivePage := tsEditor;
    
    // 娓呴櫎缂栬緫鍐呭
    while pnlEditorContent.ControlCount > 0 do
      pnlEditorContent.Controls[0].Free;
    
    // 鏄剧ず瀵瑰簲鐨勭紪杈戞
    ShowEditorForNode(Node);
  end
  else
  begin
    // 鐩存帴缂栬緫JSON
    EditJSONPropertyClick(Sender);
  end;
end;

// 鏁版嵁搴撶紪杈戝櫒浜嬩欢
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
  // 娣诲姞鏍硅妭鐐?  PropertyName := '鏍硅妭鐐?;
  
  // 娣诲姞鑺傜偣
  RootNode := AddPropertyToTree(PropertyName, 'TJSONObject', '{}', etObject);
  
  // 灞曞紑鑺傜偣
  if Assigned(RootNode) then
    RootNode.Expand(False);
    
  // 鏇存柊JSON鏄剧ず
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.btnAddININetworkClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Section: string;
begin
  // 娣诲姞缃戠粶灞炴€?  PropertyName := GetNewPropertyName('Network');
  if PropertyName = '' then Exit;

  PropertyValue := '127.0.0.1';
  if not GetPropertyInputFromUser('杈撳叆IP鍦板潃', '璇疯緭鍏P鍦板潃:', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Network';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctNetwork.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINITimeClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 娣诲姞鏃堕棿灞炴€?  PropertyName := GetNewPropertyName('Time');
  if PropertyName = '' then Exit;

  PropertyValue := FormatDateTime('hh:mm:ss', Now);
  if not GetPropertyInputFromUser('杈撳叆鏃堕棿', '璇疯緭鍏ユ椂闂?(hh:mm:ss):', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Time';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctTime.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINITemplateClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 娣诲姞妯℃澘灞炴€?  PropertyName := GetNewPropertyName('Template');
  if PropertyName = '' then Exit;

  PropertyValue := '${variableName}';
  if not GetPropertyInputFromUser('杈撳叆妯℃澘', '璇疯緭鍏ユā鏉?', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Template';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctTemplate.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINIPluginClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 娣诲姞鎻掍欢灞炴€?  PropertyName := GetNewPropertyName('Plugin');
  if PropertyName = '' then Exit;

  PropertyValue := 'plugins/example.dll';
  if not GetPropertyInputFromUser('杈撳叆鎻掍欢璺緞', '璇疯緭鍏ユ彃浠惰矾寰?', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Plugins';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctPlugin.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINILogClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 娣诲姞鏃ュ織灞炴€?  PropertyName := GetNewPropertyName('Log');
  if PropertyName = '' then Exit;

  PropertyValue := 'logs/app.log';
  if not GetPropertyInputFromUser('杈撳叆鏃ュ織璺緞', '璇疯緭鍏ユ棩蹇楄矾寰?', PropertyValue) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
  if sgINI.RowCount > 1 then
    Section := sgINI.Cells[0, 1]
  else
    Section := 'Logging';

  // 娣诲姞灞炴€?  AddPropertyToGrid(Section, 'ctLog.' + PropertyName, PropertyValue);

  // 鏇存柊INI鏄剧ず
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
  // 娣诲姞API灞炴€?  PropertyName := GetNewPropertyName('API');
  if PropertyName = '' then Exit;

  // 鍒涘缓API缂栬緫瀵硅瘽妗?  APIForm := TForm.Create(Self);
  try
    APIForm.Caption := 'API缂栬緫';
    APIForm.Position := poScreenCenter;
    APIForm.Width := 450;
    APIForm.Height := 350;
    APIForm.BorderStyle := bsDialog;

    // 鍒涘缓API缂栬緫鍣?    APIEditor := TAIAPIEditorFrame.Create(APIForm);
    APIEditor.Parent := APIForm;
    APIEditor.Align := alClient;

    // 鍒涘缓鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(APIForm);
    ButtonPanel.Parent := APIForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 鍒涘缓纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 鍒涘缓鍙栨秷鎸夐挳
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '鍙栨秷';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 寮€濮婮SON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('url', 'https://api.example.com');
    JSONObj.AddPair('method', 'GET');

    // 鏄剧ず瀵硅瘽妗?    if APIForm.ShowModal = mrOK then
    begin
      // 鑾峰彇褰撳墠鑺傜偣
      var Node := tvJSON.Selected;
      var PropItem: PConfigPropertyItem;
      
      if Node = nil then
      begin
        // 娌℃湁閫夋嫨鑺傜偣锛屾坊鍔犳柊鑺傜偣
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject);
      end
      else
      begin
        // 閫夋嫨鑺傜偣锛屾坊鍔犲瓙鑺傜偣
        PropItem := PConfigPropertyItem(Node.Data);
        if PropItem^.EditorType = etObject then
          // 娣诲姞瀛愯妭鐐?          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node)
        else
          // 娣诲姞鍚岀骇鑺傜偣
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node.Parent);
      end;
      
      // 鏇存柊JSON鏄剧ず
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
  // 娣诲姞瀹夊叏灞炴€?  PropertyName := GetNewPropertyName('Security');
  if PropertyName = '' then Exit;

  // 鍒涘缓瀹夊叏JSON瀵硅薄
  SecJSON := TJSONObject.Create;
  try
    SecJSON.AddPair('enabled', TJSONBool.Create(True));
    SecJSON.AddPair('encryption', 'AES-256');
    SecJSON.AddPair('ssl', TJSONBool.Create(True));

    // 鑾峰彇褰撳墠鑺傜偣
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 娌℃湁閫夋嫨鑺傜偣锛屾坊鍔犳柊鑺傜偣
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject);
    end
    else
    begin
      // 閫夋嫨鑺傜偣锛屾坊鍔犲瓙鑺傜偣
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 娣诲姞瀛愯妭鐐?        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node)
      else
        // 娣诲姞鍚岀骇鑺傜偣
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node.Parent);
    end;
    
    
    // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
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
  // 锟斤拷锟斤拷AI锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('AI');
  if PropertyName = '' then Exit;

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷
  AIJSON := TJSONObject.Create;
  try
    AIJSON.AddPair('model', 'gpt-4');
    AIJSON.AddPair('temperature', TJSONNumber.Create(0.7));
    AIJSON.AddPair('max_tokens', TJSONNumber.Create(1024));

    // 锟斤拷取锟斤拷前选锟叫的节碉拷
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?      Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject);
    end
    else
    begin
      // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟饺★拷锟斤拷锟?      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node)
      else
        // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node.Parent);
    end;
    
    // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
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
  // 锟斤拷锟斤拷模锟斤拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Module');
  if PropertyName = '' then Exit;

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷
  ModJSON := TJSONObject.Create;
  try
    ModJSON.AddPair('name', PropertyName);
    ModJSON.AddPair('enabled', TJSONBool.Create(True));
    ModJSON.AddPair('version', '1.0.0');
    
    // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    var DepsArray := TJSONArray.Create;
    DepsArray.Add('core');
    DepsArray.Add('logger');
    ModJSON.AddPair('dependencies', DepsArray);

    // 锟斤拷取锟斤拷前选锟叫的节碉拷
    Node := tvJSON.Selected;
    
    if Node = nil then
    begin
      // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?      Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject);
    end
    else
    begin
      // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟饺★拷锟斤拷锟?      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node)
      else
        // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node.Parent);
    end;
    
    // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
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

// 确锟斤拷锟斤拷锟斤拷initialization锟斤拷锟街碉拷锟斤拷Register
{$IFDEF DESIGNTIME}
initialization
  // 锟斤拷要锟斤拷锟斤拷锟斤拷锟斤拷锟絉egister锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷时锟斤拷锟斤拷Register应锟斤拷只锟斤拷锟斤拷锟绞笔癸拷锟?{$ENDIF}

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
  
  // 锟斤拷锟捷节碉拷锟斤拷锟酵达拷锟斤拷锟斤拷应锟侥编辑锟斤拷
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
    Exit; // 锟角革拷锟斤拷锟斤拷锟酵诧拷锟斤拷锟斤拷
  end;
  
  if EditorFrame <> nil then
  begin
    // 锟斤拷锟矫编辑锟斤拷位锟矫猴拷锟斤拷锟斤拷
    EditorFrame.Parent := pnlEditorContent;
    EditorFrame.Align := alClient;
    EditorFrame.Visible := True;
    
    // 为没锟斤拷锟斤拷锟矫憋拷锟斤拷/取锟斤拷锟斤拷钮锟侥编辑锟斤拷锟斤拷锟接帮拷钮锟斤拷锟?    if not (EditorFrame is TFrameDBEditor) then
    begin
      // 锟斤拷锟斤拷锟斤拷钮锟斤拷锟?      ButtonPanel := TPanel.Create(Self);
      ButtonPanel.Parent := pnlEditorContent;
      ButtonPanel.Align := alBottom;
      ButtonPanel.Height := 40;
      ButtonPanel.BevelOuter := bvNone;
      
      // 锟斤拷锟斤拷锟斤拷锟芥按钮
      SaveBtn := TButton.Create(Self);
      SaveBtn.Parent := ButtonPanel;
      SaveBtn.Caption := '锟斤拷锟斤拷';
      SaveBtn.ModalResult := mrOK;
      SaveBtn.Left := ButtonPanel.Width - 170;
      SaveBtn.Top := 8;
      SaveBtn.Width := 75;
      SaveBtn.OnClick := EditorSaveClick;
      
      // 锟斤拷锟斤拷取锟斤拷锟斤拷钮
      CancelBtn := TButton.Create(Self);
      CancelBtn.Parent := ButtonPanel;
      CancelBtn.Caption := '取锟斤拷';
      CancelBtn.ModalResult := mrCancel;
      CancelBtn.Left := ButtonPanel.Width - 85;
      CancelBtn.Top := 8;
      CancelBtn.Width := 75;
      CancelBtn.OnClick := EditorCancelClick;
    end;
    
    // 锟斤拷锟截节碉拷锟斤拷锟捷碉拷锟洁辑锟斤拷
    LoadNodeDataToEditor(Node, EditorFrame);
    
    // 锟斤拷锟芥当前锟斤拷锟节编辑锟侥节碉拷捅嗉拷锟?    FCurrentEditNode := Node;
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
    // 锟斤拷锟皆斤拷锟斤拷JSON锟斤拷锟斤拷
    if PropItem^.PropertyValue <> '' then
    begin
      JSONObj := TJSONObject.ParseJSONValue(PropItem^.PropertyValue) as TJSONObject;
      if JSONObj <> nil then
      begin
        try
          // 锟斤拷锟捷编辑锟斤拷锟斤拷锟酵硷拷锟斤拷锟斤拷锟斤拷
          if EditorFrame is TFrameDBEditor then
          begin
            // 锟斤拷锟斤拷锟斤拷锟捷匡拷锟斤拷锟斤拷锟斤拷息
            if JSONObj.GetValue('ConnectionString') <> nil then
              TFrameDBEditor(EditorFrame).ConnectionString := JSONObj.GetValue('ConnectionString').Value;
          end
          else if EditorFrame is TFrameListEditor then
          begin
            // 锟斤拷锟斤拷锟叫憋拷锟斤拷息
            // TFrameListEditor实锟斤拷...
          end
          else if EditorFrame is TFrameObjectEditor then
          begin
            // 锟斤拷锟截讹拷锟斤拷锟斤拷息
            // TFrameObjectEditor实锟斤拷...
          end
          else if EditorFrame is TFrameArrayEditor then
          begin
            // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷息
            // TFrameArrayEditor实锟斤拷...
          end
          else if EditorFrame is TAIAPIEditorFrame then
          begin
            // 锟斤拷锟斤拷API锟斤拷息
            // TAIAPIEditorFrame实锟斤拷...
          end;
        finally
          JSONObj.Free;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷失锟斤拷: ' + E.Message);
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
    // 锟斤拷锟捷编辑锟斤拷锟斤拷锟酵憋拷锟斤拷锟斤拷锟斤拷
    if FCurrentEditor is TFrameDBEditor then
    begin
      // 锟斤拷锟斤拷锟斤拷锟捷匡拷锟斤拷锟斤拷锟斤拷息
      JSONObj.AddPair('ConnectionString', TFrameDBEditor(FCurrentEditor).ConnectionString);
    end
    else if FCurrentEditor is TFrameListEditor then
    begin
      // 锟斤拷锟斤拷锟叫憋拷锟斤拷息
      // TFrameListEditor实锟斤拷...
    end
    else if FCurrentEditor is TFrameObjectEditor then
    begin
      // 锟斤拷锟斤拷锟斤拷锟斤拷锟较?      // TFrameObjectEditor实锟斤拷...
    end
    else if FCurrentEditor is TFrameArrayEditor then
    begin
      // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷息
      // TFrameArrayEditor实锟斤拷...
    end
    else if FCurrentEditor is TAIAPIEditorFrame then
    begin
      // 锟斤拷锟斤拷API锟斤拷息
      // TAIAPIEditorFrame实锟斤拷...
    end;
    
    // 锟斤拷锟铰节碉拷锟斤拷锟斤拷
    PropItem^.PropertyValue := JSONObj.ToString;
  finally
    JSONObj.Free;
  end;
  
  // 锟斤拷锟斤拷JSON锟斤拷图
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.EditorSaveClick(Sender: TObject);
begin
  // 锟斤拷锟斤拷嗉拷锟斤拷锟斤拷莸锟斤拷诘锟?  SaveEditorDataToNode;
  
  // 锟斤拷锟斤拷嗉拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫碉拷锟斤拷锟叫控硷拷
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 锟斤拷锟矫碉拷前锟洁辑锟斤拷锟酵节碉拷
  FCurrentEditor := nil;
  FCurrentEditNode := nil;
  
  // 锟叫伙拷JSON页
  PageControl1.ActivePage := tsJSON;
end;

procedure TFrmBuildConfig.EditorCancelClick(Sender: TObject);
begin
  // 锟斤拷锟斤拷嗉拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫碉拷锟斤拷锟叫控硷拷
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;
  
  // 锟斤拷锟矫碉拷前锟洁辑锟斤拷锟酵节碉拷
  FCurrentEditor := nil;
  FCurrentEditNode := nil;
  
  // 锟叫伙拷JSON页
  PageControl1.ActivePage := tsJSON;
end;

end.

