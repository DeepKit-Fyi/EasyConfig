unit ViewConfigEditor;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, System.JSON, Vcl.Grids, Vcl.ValEdit,
  ModelConfig, System.UITypes, System.Generics.Collections;

type
  // 配置编辑器基类
  TConfigEditorBase = class(TFrame)
  private
    FConfigPath: string;
    FConfigType: TEditorType;
    FModified: Boolean;
    
    procedure SetConfigPath(const Value: string);
    procedure SetConfigType(const Value: TEditorType);
    procedure SetModified(const Value: Boolean);
  protected
    procedure DoModified; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure Initialize; virtual;
    procedure Reset; virtual;
    
    function LoadConfig: Boolean; virtual;
    function SaveConfig: Boolean; virtual;
    function ValidateConfig: Boolean; virtual;
    
    property ConfigPath: string read FConfigPath write SetConfigPath;
    property ConfigType: TEditorType read FConfigType write SetConfigType;
    property Modified: Boolean read FModified write SetModified;
  end;
  
  // 文本编辑器
  TTextConfigEditor = class(TConfigEditorBase)
  private
    FMemo: TMemo;
    procedure MemoChangeHandler(Sender: TObject);
  protected
    procedure CreateMemoControl;
    procedure DoModified; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure Initialize; override;
    procedure Reset; override;
    
    function LoadConfig: Boolean; override;
    function SaveConfig: Boolean; override;
    function ValidateConfig: Boolean; override;
  end;
  
  // JSON编辑器
  TJSONConfigEditor = class(TConfigEditorBase)
  private
    FMemo: TMemo;
    FTreeView: TTreeView;
    FSplitter: TSplitter;
    FJSONObj: TJSONObject;
    
    procedure CreateControls;
    procedure UpdateJSONTreeView;
    procedure PopulateTreeView(ParentNode: TTreeNode; const JSONObj: TJSONObject);
    procedure MemoChange(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
  protected
    procedure DoModified; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure Initialize; override;
    procedure Reset; override;
    
    function LoadConfig: Boolean; override;
    function SaveConfig: Boolean; override;
    function ValidateConfig: Boolean; override;
  end;
  
  // INI编辑器
  TINIConfigEditor = class(TConfigEditorBase)
  private
    FValueListEditor: TValueListEditor;
    FSections: TComboBox;
    FPanelTop: TPanel;
    
    procedure CreateControls;
    procedure LoadSections;
    procedure SectionChange(Sender: TObject);
    procedure ValueListEditorStringsChange(Sender: TObject);
  protected
    procedure DoModified; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure Initialize; override;
    procedure Reset; override;
    
    function LoadConfig: Boolean; override;
    function SaveConfig: Boolean; override;
    function ValidateConfig: Boolean; override;
  end;
  
implementation

uses
  System.IOUtils, System.IniFiles;

{ TConfigEditorBase }

constructor TConfigEditorBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModified := False;
end;

destructor TConfigEditorBase.Destroy;
begin
  inherited;
end;

procedure TConfigEditorBase.SetConfigPath(const Value: string);
begin
  if FConfigPath <> Value then
  begin
    FConfigPath := Value;
  end;
end;

procedure TConfigEditorBase.SetConfigType(const Value: TEditorType);
begin
  if FConfigType <> Value then
  begin
    FConfigType := Value;
  end;
end;

procedure TConfigEditorBase.SetModified(const Value: Boolean);
begin
  if FModified <> Value then
  begin
    FModified := Value;
    if FModified then
      DoModified;
  end;
end;

procedure TConfigEditorBase.DoModified;
begin
  // 基类不执行任何操作，子类可重写
end;

procedure TConfigEditorBase.Initialize;
begin
  // 基类不执行任何操作，子类可重写
end;

procedure TConfigEditorBase.Reset;
begin
  // 基类不执行任何操作，子类可重写
end;

function TConfigEditorBase.LoadConfig: Boolean;
begin
  Result := False;
  // 基类不执行任何操作，子类可重写
end;

function TConfigEditorBase.SaveConfig: Boolean;
begin
  Result := False;
  // 基类不执行任何操作，子类可重写
end;

function TConfigEditorBase.ValidateConfig: Boolean;
begin
  Result := True;
  // 基类不执行任何操作，子类可重写
end;

{ TTextConfigEditor }

constructor TTextConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateMemoControl;
end;

destructor TTextConfigEditor.Destroy;
begin
  inherited;
end;

procedure TTextConfigEditor.CreateMemoControl;
begin
  FMemo := TMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.Align := alClient;
  FMemo.ScrollBars := ssBoth;
  FMemo.WordWrap := False;
  FMemo.WantTabs := True;
  FMemo.OnChange := MemoChangeHandler;
end;

procedure TTextConfigEditor.MemoChangeHandler(Sender: TObject);
begin
  Modified := True;
end;

procedure TTextConfigEditor.Initialize;
begin
  inherited;
  LoadConfig;
end;

procedure TTextConfigEditor.Reset;
begin
  FMemo.Clear;
  Modified := False;
end;

function TTextConfigEditor.LoadConfig: Boolean;
begin
  Result := False;
  
  if (ConfigPath = '') or not FileExists(ConfigPath) then
    Exit;
    
  try
    FMemo.Lines.LoadFromFile(ConfigPath);
    Modified := False;
    Result := True;
  except
    on E: Exception do
    begin
      MessageDlg('加载文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TTextConfigEditor.SaveConfig: Boolean;
begin
  Result := False;
  
  if ConfigPath = '' then
    Exit;
    
  try
    FMemo.Lines.SaveToFile(ConfigPath);
    Modified := False;
    Result := True;
  except
    on E: Exception do
    begin
      MessageDlg('保存文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TTextConfigEditor.ValidateConfig: Boolean;
begin
  // 文本编辑器不执行验证
  Result := True;
end;

procedure TTextConfigEditor.DoModified;
begin
  inherited;
  // 可以通知父窗体修改状态改变
end;

{ TJSONConfigEditor }

constructor TJSONConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJSONObj := nil;
  CreateControls;
end;

destructor TJSONConfigEditor.Destroy;
begin
  if Assigned(FJSONObj) then
    FJSONObj.Free;
  inherited;
end;

procedure TJSONConfigEditor.CreateControls;
begin
  // 创建水平分隔布局
  FSplitter := TSplitter.Create(Self);
  FSplitter.Parent := Self;
  FSplitter.Align := alLeft;
  FSplitter.Width := 5;
  
  // 创建树视图
  FTreeView := TTreeView.Create(Self);
  FTreeView.Parent := Self;
  FTreeView.Align := alLeft;
  FTreeView.Width := 200;
  FTreeView.HideSelection := False;
  FTreeView.ReadOnly := True;
  FTreeView.ShowRoot := True;
  FTreeView.OnChange := TreeViewChange;
  
  // 创建文本编辑区
  FMemo := TMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.Align := alClient;
  FMemo.ScrollBars := ssBoth;
  FMemo.WordWrap := False;
  FMemo.WantTabs := True;
  FMemo.OnChange := MemoChange;
end;

procedure TJSONConfigEditor.Initialize;
begin
  inherited;
  LoadConfig;
end;

procedure TJSONConfigEditor.Reset;
begin
  if Assigned(FJSONObj) then
  begin
    FJSONObj.Free;
    FJSONObj := nil;
  end;
  
  FMemo.Clear;
  FTreeView.Items.Clear;
  Modified := False;
end;

procedure TJSONConfigEditor.MemoChange(Sender: TObject);
begin
  Modified := True;
  // 这里可以添加延迟更新树视图的逻辑
end;

procedure TJSONConfigEditor.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  // 树节点变更逻辑
end;

procedure TJSONConfigEditor.UpdateJSONTreeView;
begin
  FTreeView.Items.Clear;
  
  if not Assigned(FJSONObj) then
    Exit;
    
  FTreeView.Items.BeginUpdate;
  try
    PopulateTreeView(nil, FJSONObj);
  finally
    FTreeView.Items.EndUpdate;
  end;
  
  if FTreeView.Items.Count > 0 then
    FTreeView.FullExpand;
end;

procedure TJSONConfigEditor.PopulateTreeView(ParentNode: TTreeNode; const JSONObj: TJSONObject);
var
  i: Integer;
  Node: TTreeNode;
  Pair: TJSONPair;
  ChildObj: TJSONObject;
  ChildArr: TJSONArray;
  j: Integer;
  ItemValue: string;
begin
  for i := 0 to JSONObj.Count - 1 do
  begin
    Pair := JSONObj.Pairs[i];
    
    if ParentNode = nil then
      Node := FTreeView.Items.AddChild(nil, Pair.JsonString.Value)
    else
      Node := FTreeView.Items.AddChild(ParentNode, Pair.JsonString.Value);
      
    if Pair.JsonValue is TJSONObject then
    begin
      ChildObj := Pair.JsonValue as TJSONObject;
      PopulateTreeView(Node, ChildObj);
    end
    else if Pair.JsonValue is TJSONArray then
    begin
      ChildArr := Pair.JsonValue as TJSONArray;
      for j := 0 to ChildArr.Count - 1 do
      begin
        if ChildArr.Items[j] is TJSONObject then
          PopulateTreeView(Node, ChildArr.Items[j] as TJSONObject)
        else
        begin
          ItemValue := ChildArr.Items[j].ToString;
          FTreeView.Items.AddChild(Node, Format('[%d] %s', [j, ItemValue]));
        end;
      end;
    end
    else
    begin
      ItemValue := Pair.JsonValue.ToString;
      if ItemValue.StartsWith('"') and ItemValue.EndsWith('"') and (Length(ItemValue) >= 2) then
        ItemValue := Copy(ItemValue, 2, Length(ItemValue) - 2);
      
      Node.Text := Format('%s: %s', [Pair.JsonString.Value, ItemValue]);
    end;
  end;
end;

function TJSONConfigEditor.LoadConfig: Boolean;
var
  JsonText: string;
begin
  Result := False;
  
  if (ConfigPath = '') or not FileExists(ConfigPath) then
    Exit;
    
  Reset;
  
  try
    JsonText := TFile.ReadAllText(ConfigPath);
    FMemo.Text := JsonText;
    
    FJSONObj := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
    if FJSONObj <> nil then
    begin
      UpdateJSONTreeView;
      Result := True;
    end
    else
    begin
      FMemo.Text := JsonText;
      MessageDlg('JSON解析失败，以文本方式打开', mtWarning, [mbOK], 0);
    end;
    
    Modified := False;
  except
    on E: Exception do
    begin
      MessageDlg('加载JSON文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TJSONConfigEditor.SaveConfig: Boolean;
var
  JsonText: string;
  ParsedObj: TJSONValue;
begin
  Result := False;
  
  if ConfigPath = '' then
    Exit;
    
  try
    JsonText := FMemo.Text;
    
    // 验证JSON格式
    ParsedObj := TJSONObject.ParseJSONValue(JsonText);
    if ParsedObj = nil then
    begin
      MessageDlg(string('JSON格式无效，保存失败'), mtError, [mbOK], 0);
      Exit;
    end;
    ParsedObj.Free;
    
    TFile.WriteAllText(ConfigPath, JsonText);
    
    // 更新内部JSON对象
    if Assigned(FJSONObj) then
      FJSONObj.Free;
      
    FJSONObj := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
    if FJSONObj <> nil then
      UpdateJSONTreeView;
      
    Modified := False;
    Result := True;
  except
    on E: Exception do
    begin
      MessageDlg('保存JSON文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TJSONConfigEditor.ValidateConfig: Boolean;
var
  JsonText: string;
  ParsedObj: TJSONValue;
begin
  Result := False;
  
  try
    JsonText := FMemo.Text;
    
    // 验证JSON格式
    ParsedObj := TJSONObject.ParseJSONValue(JsonText);
    if ParsedObj <> nil then
    begin
      ParsedObj.Free;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure TJSONConfigEditor.DoModified;
begin
  inherited;
  // 可以通知父窗体修改状态改变
end;

{ TINIConfigEditor }

constructor TINIConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
end;

destructor TINIConfigEditor.Destroy;
begin
  inherited;
end;

procedure TINIConfigEditor.CreateControls;
begin
  // 创建顶部面板
  FPanelTop := TPanel.Create(Self);
  FPanelTop.Parent := Self;
  FPanelTop.Align := alTop;
  FPanelTop.Height := 40;
  FPanelTop.BevelOuter := bvNone;
  
  // 创建节选择下拉框
  FSections := TComboBox.Create(FPanelTop);
  FSections.Parent := FPanelTop;
  FSections.Align := alLeft;
  FSections.Width := 200;
  FSections.Style := csDropDownList;
  FSections.OnChange := SectionChange;
  
  // 创建值列表编辑器
  FValueListEditor := TValueListEditor.Create(Self);
  FValueListEditor.Parent := Self;
  FValueListEditor.Align := alClient;
  FValueListEditor.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor, goThumbTracking];
  FValueListEditor.TitleCaptions.Add(string('名称'));
  FValueListEditor.TitleCaptions.Add(string('值'));
  FValueListEditor.OnStringsChange := ValueListEditorStringsChange;
end;

procedure TINIConfigEditor.Initialize;
begin
  inherited;
  LoadConfig;
end;

procedure TINIConfigEditor.Reset;
begin
  FSections.Items.Clear;
  FValueListEditor.Strings.Clear;
  Modified := False;
end;

procedure TINIConfigEditor.LoadSections;
var
  IniFile: TIniFile;
  Sections: TStringList;
  i: Integer;
begin
  if (ConfigPath = '') or not FileExists(ConfigPath) then
    Exit;
    
  Sections := TStringList.Create;
  try
    IniFile := TIniFile.Create(ConfigPath);
    try
      IniFile.ReadSections(Sections);
      
      FSections.Items.Clear;
      FSections.Items.Add('');
      
      for i := 0 to Sections.Count - 1 do
        FSections.Items.Add(Sections[i]);
        
      if FSections.Items.Count > 0 then
        FSections.ItemIndex := 0;
    finally
      IniFile.Free;
    end;
  finally
    Sections.Free;
  end;
end;

procedure TINIConfigEditor.SectionChange(Sender: TObject);
var
  Section: string;
  IniFile: TIniFile;
  Keys: TStringList;
  Values: TStringList;
  i: Integer;
begin
  if (ConfigPath = '') or not FileExists(ConfigPath) then
    Exit;
    
  FValueListEditor.Strings.Clear;
  
  if FSections.ItemIndex < 0 then
    Exit;
    
  Section := FSections.Items[FSections.ItemIndex];
  
  Keys := TStringList.Create;
  Values := TStringList.Create;
  try
    IniFile := TIniFile.Create(ConfigPath);
    try
      IniFile.ReadSection(Section, Keys);
      
      for i := 0 to Keys.Count - 1 do
        Values.Add(IniFile.ReadString(Section, Keys[i], ''));
        
      for i := 0 to Keys.Count - 1 do
        FValueListEditor.Strings.Add(Keys[i] + '=' + Values[i]);
    finally
      IniFile.Free;
    end;
  finally
    Keys.Free;
    Values.Free;
  end;
end;

procedure TINIConfigEditor.ValueListEditorStringsChange(Sender: TObject);
begin
  Modified := True;
end;

function TINIConfigEditor.LoadConfig: Boolean;
begin
  Result := False;
  
  if (ConfigPath = '') or not FileExists(ConfigPath) then
    Exit;
    
  Reset;
  
  try
    LoadSections;
    Result := True;
    Modified := False;
  except
    on E: Exception do
    begin
      MessageDlg('加载INI文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TINIConfigEditor.SaveConfig: Boolean;
var
  i: Integer;
  Section: string;
  KeyName: string;
  KeyValue: string;
  IniFile: TIniFile;
  Position: Integer;
begin
  Result := False;
  
  if ConfigPath = '' then
    Exit;
    
  try
    Section := '';
    if FSections.ItemIndex >= 0 then
      Section := FSections.Items[FSections.ItemIndex];
      
    IniFile := TIniFile.Create(ConfigPath);
    try
      // 清除节中的所有键
      if Section <> '' then
        IniFile.EraseSection(Section);
        
      // 写入新值
      for i := 0 to FValueListEditor.Strings.Count - 1 do
      begin
        Position := Pos('=', FValueListEditor.Strings[i]);
        if Position > 0 then
        begin
          KeyName := Copy(FValueListEditor.Strings[i], 1, Position - 1);
          KeyValue := Copy(FValueListEditor.Strings[i], Position + 1, Length(FValueListEditor.Strings[i]));
          
          if Section <> '' then
            IniFile.WriteString(Section, KeyName, KeyValue);
        end;
      end;
      
      Result := True;
      Modified := False;
    finally
      IniFile.Free;
    end;
  except
    on E: Exception do
    begin
      MessageDlg('保存INI文件失败: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TINIConfigEditor.ValidateConfig: Boolean;
begin
  // INI编辑器不需要特殊验证
  Result := True;
end;

procedure TINIConfigEditor.DoModified;
begin
  inherited;
  // 可以通知父窗体修改状态改变
end;

end. 