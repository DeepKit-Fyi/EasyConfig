unit ViewMainFormFMX;
{*******************************************************************************
  ConfigBuild 主窗体 (FMX)
  - 左侧: 配置树 / 属性列表
  - 右侧: 属性编辑器
  - 底部: 状态栏
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON, System.IOUtils, System.Actions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.TreeView, FMX.ListBox, FMX.Edit, FMX.Menus, FMX.ActnList,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Memo, FMX.ScrollBox,
  FMX.Grid, FMX.Grid.Style,
  UtilsTypesFMX, ConfigManager, ConfigValidator, UndoRedoManager, 
  ControllerConfigsFMX, FrameSimpleEditorFMX;

type
  TViewMainFormFMX = class(TForm)
    layMain: TLayout;
    splMain: TSplitter;
    layLeft: TLayout;
    layRight: TLayout;
    layStatusBar: TLayout;
    lblStatusFile: TLabel;
    lblStatusValidation: TLabel;
    lblStatusOperation: TLabel;
    tabLeft: TTabControl;
    tabTree: TTabItem;
    tabProperties: TTabItem;
    trvConfig: TTreeView;
    lstProperties: TListBox;
    layEditor: TLayout;
    layEditorHeader: TLayout;
    lblEditorTitle: TLabel;
    btnSaveProperty: TButton;
    btnCancelEdit: TButton;
    layEditorContent: TLayout;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuSep1: TMenuItem;
    mnuExit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    mnuSep2: TMenuItem;
    mnuAddProperty: TMenuItem;
    mnuDeleteProperty: TMenuItem;
    mnuView: TMenuItem;
    mnuRefresh: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    actList: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actExit: TAction;
    actUndo: TAction;
    actRedo: TAction;
    actAddProperty: TAction;
    actDeleteProperty: TAction;
    actRefresh: TAction;
    actAbout: TAction;
    actValidate: TAction;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    // 验证结果展示区域
    splBottom: TSplitter;
    layBottom: TLayout;
    lblValidationTitle: TLabel;
    lstValidationResults: TListBox;
    // 原始文档视图
    tabRight: TTabControl;
    tabEditor: TTabItem;
    tabINIRaw: TTabItem;
    tabJSONRaw: TTabItem;
    mmoINIRaw: TMemo;
    mmoJSONRaw: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actNewExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actAddPropertyExecute(Sender: TObject);
    procedure actDeletePropertyExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actValidateExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure trvConfigChange(Sender: TObject);
    procedure lstValidationResultsDblClick(Sender: TObject);
    procedure tabRightChange(Sender: TObject);
    procedure mmoINIRawChange(Sender: TObject);
    procedure mmoJSONRawChange(Sender: TObject);
    procedure lstPropertiesDblClick(Sender: TObject);
    procedure btnSavePropertyClick(Sender: TObject);
    procedure btnCancelEditClick(Sender: TObject);
  private
    FConfigManager: TConfigManager;
    FConfigValidator: TConfigValidator;
    FUndoRedoManager: TUndoRedoManager;
    FCurrentFilePath: string;
    FModified: Boolean;
    FValidationResults: TArray<TValidationResult>;
    procedure SetModified(AValue: Boolean);
    procedure UpdateTitle;
    procedure UpdateStatusBar;
    procedure LoadConfigToTree;
    procedure LoadPropertiesToList(const ASection: string);
    procedure EditSelectedProperty;
    procedure OnPropertyEditComplete(Sender: TObject);
    procedure ShowValidationResults(const AResults: TArray<TValidationResult>);
    procedure NavigateToValidationItem(const APath: string);
    procedure OnUndoRedoStateChanged(Sender: TObject);
    procedure UpdateUndoRedoActions;
    procedure ExecuteINIValueChange(const ASection, AKey, AOldValue, ANewValue: string);
    procedure LoadRawDocuments;
    procedure SaveRawINI;
    procedure SaveRawJSON;
  public
    property Modified: Boolean read FModified write SetModified;
  end;

var
  ViewMainFormFMX: TViewMainFormFMX;

implementation

{$R *.fmx}

const
  APP_TITLE = 'ConfigBuild';

{ TViewMainFormFMX }

procedure TViewMainFormFMX.FormCreate(Sender: TObject);
begin
  FConfigManager := TConfigManager.Create;
  FConfigValidator := TConfigValidator.Create;
  FUndoRedoManager := TUndoRedoManager.Create(100);
  FUndoRedoManager.OnStateChanged := OnUndoRedoStateChanged;
  FCurrentFilePath := '';
  FModified := False;
  SetLength(FValidationResults, 0);

  // 设置对话框过滤器
  dlgOpen.Filter := 'JSON 配置文件 (*.json)|*.json|INI 配置文件 (*.ini)|*.ini|所有文件 (*.*)|*.*';
  dlgSave.Filter := dlgOpen.Filter;

  // 初始化 ControllerConfigs
  GetControllerConfigsFMX.SetParentLayout(layEditorContent);

  // 初始化界面
  UpdateTitle;
  UpdateStatusBar;

  // 默认隐藏编辑器和验证结果区域
  layEditor.Visible := False;
  layBottom.Visible := False;
end;

procedure TViewMainFormFMX.FormDestroy(Sender: TObject);
begin
  FUndoRedoManager.Free;
  FConfigValidator.Free;
  FConfigManager.Free;
end;

procedure TViewMainFormFMX.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FModified then
  begin
    case MessageDlg('配置已修改，是否保存？',
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], 0) of
      mrYes:
        begin
          actSaveExecute(nil);
          CanClose := not FModified; // 如果保存失败则不关闭
        end;
      mrNo:
        CanClose := True;
      mrCancel:
        CanClose := False;
    end;
  end
  else
    CanClose := True;
end;

procedure TViewMainFormFMX.SetModified(AValue: Boolean);
begin
  if FModified <> AValue then
  begin
    FModified := AValue;
    UpdateTitle;
    UpdateStatusBar;
  end;
end;

procedure TViewMainFormFMX.UpdateTitle;
var
  Title: string;
begin
  Title := APP_TITLE;
  if FCurrentFilePath <> '' then
    Title := Title + ' - ' + ExtractFileName(FCurrentFilePath);
  if FModified then
    Title := Title + ' *';
  Caption := Title;
end;

procedure TViewMainFormFMX.UpdateStatusBar;
begin
  // 文件路径
  if FCurrentFilePath <> '' then
    lblStatusFile.Text := FCurrentFilePath
  else
    lblStatusFile.Text := '未打开文件';

  // 验证状态 (简化版)
  if FCurrentFilePath <> '' then
    lblStatusValidation.Text := '已加载'
  else
    lblStatusValidation.Text := '';

  // 最近操作
  // lblStatusOperation.Text 由各操作更新
end;

procedure TViewMainFormFMX.LoadConfigToTree;
var
  Sections: TArray<string>;
  I: Integer;
  Node, JSONRootNode: TTreeViewItem;
  JSONRoot: TJSONObject;
  
  procedure AddJSONToTree(AParent: TTreeViewItem; AObj: TJSONObject; const APath: string);
  var
    Pair: TJSONPair;
    ChildNode: TTreeViewItem;
    TypeStr, NodeText, ChildPath: string;
    Arr: TJSONArray;
    J: Integer;
    ArrItem: TJSONValue;
  begin
    if AObj = nil then Exit;
    
    for Pair in AObj do
    begin
      ChildNode := TTreeViewItem.Create(trvConfig);
      ChildPath := APath + '/' + Pair.JsonString.Value;
      ChildNode.TagString := ChildPath;
      
      if Pair.JsonValue is TJSONObject then
      begin
        // 检查是否有 _type 字段
        if TJSONObject(Pair.JsonValue).TryGetValue<string>('_type', TypeStr) then
          NodeText := Pair.JsonString.Value + ' [' + TypeStr + ']'
        else
          NodeText := Pair.JsonString.Value;
        ChildNode.Text := NodeText;
        AParent.AddObject(ChildNode);
        // 递归添加子对象
        AddJSONToTree(ChildNode, TJSONObject(Pair.JsonValue), ChildPath);
      end
      else if Pair.JsonValue is TJSONArray then
      begin
        Arr := TJSONArray(Pair.JsonValue);
        ChildNode.Text := Pair.JsonString.Value + ' [' + IntToStr(Arr.Count) + ' 项]';
        AParent.AddObject(ChildNode);
        // 添加数组元素
        for J := 0 to Arr.Count - 1 do
        begin
          ArrItem := Arr.Items[J];
          if ArrItem is TJSONObject then
          begin
            var ItemNode := TTreeViewItem.Create(trvConfig);
            var ItemPath := ChildPath + '[' + IntToStr(J) + ']';
            ItemNode.TagString := ItemPath;
            // 检查数组元素是否有 _type
            if TJSONObject(ArrItem).TryGetValue<string>('_type', TypeStr) then
              ItemNode.Text := '[' + IntToStr(J) + '] ' + TypeStr
            else
              ItemNode.Text := '[' + IntToStr(J) + ']';
            ChildNode.AddObject(ItemNode);
            AddJSONToTree(ItemNode, TJSONObject(ArrItem), ItemPath);
          end;
        end;
      end
      else
      begin
        // 简单值
        ChildNode.Text := Pair.JsonString.Value + ' = ' + Pair.JsonValue.ToString;
        AParent.AddObject(ChildNode);
      end;
    end;
  end;
  
begin
  trvConfig.Clear;

  if FCurrentFilePath = '' then Exit;

  // 添加 INI 节
  Sections := FConfigManager.GetINISections;
  for I := 0 to Length(Sections) - 1 do
  begin
    Node := TTreeViewItem.Create(trvConfig);
    Node.Text := '[INI] ' + Sections[I];
    Node.TagString := 'INI:' + Sections[I];
    trvConfig.AddObject(Node);
  end;
  
  // 添加 JSON 结构
  JSONRoot := FConfigManager.JSONConfig.RootObject;
  if (JSONRoot <> nil) and (JSONRoot.Count > 0) then
  begin
    JSONRootNode := TTreeViewItem.Create(trvConfig);
    JSONRootNode.Text := '[JSON] 配置对象';
    JSONRootNode.TagString := 'JSON:';
    trvConfig.AddObject(JSONRootNode);
    AddJSONToTree(JSONRootNode, JSONRoot, 'JSON:');
  end;
end;

procedure TViewMainFormFMX.LoadPropertiesToList(const ASection: string);
var
  Keys: TArray<string>;
  I: Integer;
  Item: TListBoxItem;
  Value: string;
begin
  lstProperties.Clear;

  if (FCurrentFilePath = '') or (ASection = '') then Exit;

  Keys := FConfigManager.GetINIKeys(ASection);
  for I := 0 to Length(Keys) - 1 do
  begin
    Item := TListBoxItem.Create(lstProperties);
    Value := FConfigManager.GetINIValue(ASection, Keys[I]);
    if Length(Value) > 50 then
      Value := Copy(Value, 1, 47) + '...';
    Item.Text := Keys[I] + ' = ' + Value;
    Item.TagString := ASection + '.' + Keys[I];
    lstProperties.AddObject(Item);
  end;
end;

procedure TViewMainFormFMX.trvConfigChange(Sender: TObject);
var
  Node: TTreeViewItem;
begin
  Node := trvConfig.Selected;
  if Node <> nil then
    LoadPropertiesToList(Node.TagString);
end;

procedure TViewMainFormFMX.lstPropertiesDblClick(Sender: TObject);
begin
  EditSelectedProperty;
end;

procedure TViewMainFormFMX.EditSelectedProperty;
var
  Item: TListBoxItem;
  FullKey, Section, Key, Value: string;
  DotPos: Integer;
  JSONObj: TJSONObject;
  PropType: TComplexPropertyType;
begin
  Item := lstProperties.Selected;
  if Item = nil then Exit;

  FullKey := Item.TagString;
  DotPos := Pos('.', FullKey);
  if DotPos <= 0 then Exit;

  Section := Copy(FullKey, 1, DotPos - 1);
  Key := Copy(FullKey, DotPos + 1, Length(FullKey));

  // 获取 INI 值并尝试解析为 JSON 引用
  Value := FConfigManager.GetINIValue(Section, Key);

  // 检查是否是 JSON 引用 (etXXX.name 格式)
  if Pos('.', Value) > 0 then
  begin
    JSONObj := FConfigManager.FindReferenceObject(Value);
    if JSONObj <> nil then
    begin
      PropType := DetectComplexPropertyType(JSONObj);
      lblEditorTitle.Text := Key;
      layEditor.Visible := True;
      GetControllerConfigsFMX.EditComplexProperty(PropType, Key, JSONObj,
        OnPropertyEditComplete);
      Exit;
    end;
  end;

  // 简单属性 - 直接编辑
  ShowMessage('简单属性编辑功能待实现: ' + Key + ' = ' + Value);
end;

procedure TViewMainFormFMX.OnPropertyEditComplete(Sender: TObject);
begin
  Modified := True;
  lblStatusOperation.Text := '属性已修改';

  // TODO: 将修改保存回 ConfigManager
end;

procedure TViewMainFormFMX.btnSavePropertyClick(Sender: TObject);
begin
  GetControllerConfigsFMX.SaveCurrentProperty;
  layEditor.Visible := False;
end;

procedure TViewMainFormFMX.btnCancelEditClick(Sender: TObject);
begin
  GetControllerConfigsFMX.CancelCurrentEdit;
  layEditor.Visible := False;
end;

// ============================================================================
// Actions
// ============================================================================

procedure TViewMainFormFMX.actNewExecute(Sender: TObject);
begin
  if FModified then
  begin
    if MessageDlg('配置已修改，是否保存？',
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
      actSaveExecute(nil);
  end;

  FCurrentFilePath := '';
  Modified := False;
  LoadConfigToTree;
  lstProperties.Clear;
  UpdateTitle;
  UpdateStatusBar;
  lblStatusOperation.Text := '新建配置';
end;

procedure TViewMainFormFMX.actOpenExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    try
      FConfigManager.LoadFromFile(dlgOpen.FileName);
      FCurrentFilePath := dlgOpen.FileName;
      Modified := False;
      LoadConfigToTree;
      lstProperties.Clear;
      UpdateTitle;
      UpdateStatusBar;
      lblStatusOperation.Text := '已打开: ' + ExtractFileName(FCurrentFilePath);
    except
      on E: Exception do
        ShowMessage('打开文件失败: ' + E.Message);
    end;
  end;
end;

procedure TViewMainFormFMX.actSaveExecute(Sender: TObject);
begin
  if FCurrentFilePath = '' then
    actSaveAsExecute(Sender)
  else
  begin
    try
      FConfigManager.SaveToFile;
      Modified := False;
      UpdateStatusBar;
      lblStatusOperation.Text := '已保存';
    except
      on E: Exception do
        ShowMessage('保存文件失败: ' + E.Message);
    end;
  end;
end;

procedure TViewMainFormFMX.actSaveAsExecute(Sender: TObject);
begin
  if FCurrentFilePath <> '' then
    dlgSave.FileName := FCurrentFilePath;

  if dlgSave.Execute then
  begin
    try
      FConfigManager.SaveAsNewFile(dlgSave.FileName);
      FCurrentFilePath := dlgSave.FileName;
      Modified := False;
      UpdateTitle;
      UpdateStatusBar;
      lblStatusOperation.Text := '已另存为: ' + ExtractFileName(FCurrentFilePath);
    except
      on E: Exception do
        ShowMessage('保存文件失败: ' + E.Message);
    end;
  end;
end;

procedure TViewMainFormFMX.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TViewMainFormFMX.actAddPropertyExecute(Sender: TObject);
var
  Node: TTreeViewItem;
  Section, PropName: string;
begin
  // 获取当前选中的 Section
  Node := trvConfig.Selected;
  if Node = nil then
  begin
    ShowMessage('请先选择一个配置节');
    Exit;
  end;
  Section := Node.TagString;

  // 简单实现: 使用 InputBox 获取属性名
  PropName := InputBox('添加属性', '请输入属性名称:', '');
  if PropName = '' then Exit;

  // 添加到 ConfigManager
  FConfigManager.SetINIValue(Section, PropName, '');
  Modified := True;

  // 刷新列表
  LoadPropertiesToList(Section);
  lblStatusOperation.Text := '已添加属性: ' + PropName;
end;

procedure TViewMainFormFMX.actDeletePropertyExecute(Sender: TObject);
var
  Item: TListBoxItem;
  FullKey, Section, Key: string;
  DotPos: Integer;
begin
  Item := lstProperties.Selected;
  if Item = nil then
  begin
    ShowMessage('请先选择要删除的属性');
    Exit;
  end;

  FullKey := Item.TagString;
  DotPos := Pos('.', FullKey);
  if DotPos <= 0 then Exit;

  Section := Copy(FullKey, 1, DotPos - 1);
  Key := Copy(FullKey, DotPos + 1, Length(FullKey));

  if MessageDlg(Format('确定要删除属性 "%s" 吗？', [Key]),
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
  begin
    FConfigManager.DeleteINIConfigItem(Section, Key);
    Modified := True;
    LoadPropertiesToList(Section);
    lblStatusOperation.Text := '已删除属性: ' + Key;
  end;
end;

procedure TViewMainFormFMX.actRefreshExecute(Sender: TObject);
begin
  LoadConfigToTree;
  lstProperties.Clear;
  lblStatusOperation.Text := '已刷新';
end;

procedure TViewMainFormFMX.actAboutExecute(Sender: TObject);
begin
  ShowMessage('ConfigBuild v1.0' + sLineBreak +
    '跨平台配置文件编辑器' + sLineBreak +
    sLineBreak +
    '支持 INI + JSON 混合配置格式');
end;

procedure TViewMainFormFMX.actUndoExecute(Sender: TObject);
begin
  if FUndoRedoManager.CanUndo then
  begin
    FUndoRedoManager.Undo;
    LoadConfigToTree;
    lblStatusOperation.Text := '已撤销';
  end;
end;

procedure TViewMainFormFMX.actRedoExecute(Sender: TObject);
begin
  if FUndoRedoManager.CanRedo then
  begin
    FUndoRedoManager.Redo;
    LoadConfigToTree;
    lblStatusOperation.Text := '已重做';
  end;
end;

procedure TViewMainFormFMX.actValidateExecute(Sender: TObject);
var
  Results: TArray<TValidationResult>;
  RefResults: TArray<TValidationResult>;
  JSONRoot: TJSONObject;
  ErrorCount, WarningCount: Integer;
  I: Integer;
begin
  if FCurrentFilePath = '' then
  begin
    ShowMessage('请先打开配置文件');
    Exit;
  end;

  // 执行验证
  Results := FConfigValidator.ValidateAll(FConfigManager);
  
  // 验证 JSON 引用
  JSONRoot := FConfigManager.JSONConfig.RootObject;
  if JSONRoot <> nil then
  begin
    RefResults := FConfigValidator.ValidateReferences(JSONRoot);
    // 合并结果
    SetLength(Results, Length(Results) + Length(RefResults));
    for I := 0 to Length(RefResults) - 1 do
      Results[Length(Results) - Length(RefResults) + I] := RefResults[I];
  end;
  
  // 统计错误和警告数量
  ErrorCount := 0;
  WarningCount := 0;
  for I := 0 to Length(Results) - 1 do
  begin
    if Results[I].IsError then
      Inc(ErrorCount)
    else
      Inc(WarningCount);
  end;
  
  // 保存结果并显示
  FValidationResults := Results;
  ShowValidationResults(Results);
  
  // 更新状态栏
  lblStatusValidation.Text := Format('%d 个错误 / %d 个警告', [ErrorCount, WarningCount]);
  lblStatusOperation.Text := '验证完成';
end;

procedure TViewMainFormFMX.ShowValidationResults(const AResults: TArray<TValidationResult>);
var
  I: Integer;
  Item: TListBoxItem;
  Prefix: string;
begin
  lstValidationResults.Clear;
  
  if Length(AResults) = 0 then
  begin
    Item := TListBoxItem.Create(lstValidationResults);
    Item.Text := '✓ 验证通过，没有发现问题';
    Item.TextSettings.FontColor := TAlphaColorRec.Green;
    lstValidationResults.AddObject(Item);
    layBottom.Visible := True;
    Exit;
  end;
  
  for I := 0 to Length(AResults) - 1 do
  begin
    Item := TListBoxItem.Create(lstValidationResults);
    
    if AResults[I].IsError then
    begin
      Prefix := '✗ 错误: ';
      Item.TextSettings.FontColor := TAlphaColorRec.Red;
    end
    else
    begin
      Prefix := '⚠ 警告: ';
      Item.TextSettings.FontColor := TAlphaColorRec.Orange;
    end;
    
    Item.Text := Prefix + AResults[I].PropertyPath + ' - ' + AResults[I].ErrorMessage;
    Item.TagString := AResults[I].PropertyPath;
    Item.Tag := I;
    lstValidationResults.AddObject(Item);
  end;
  
  layBottom.Visible := True;
end;

procedure TViewMainFormFMX.lstValidationResultsDblClick(Sender: TObject);
var
  Item: TListBoxItem;
begin
  Item := lstValidationResults.Selected;
  if (Item <> nil) and (Item.TagString <> '') then
    NavigateToValidationItem(Item.TagString);
end;

procedure TViewMainFormFMX.OnUndoRedoStateChanged(Sender: TObject);
begin
  UpdateUndoRedoActions;
  Modified := FUndoRedoManager.GetUndoCount > 0;
end;

procedure TViewMainFormFMX.UpdateUndoRedoActions;
begin
  actUndo.Enabled := FUndoRedoManager.CanUndo;
  actRedo.Enabled := FUndoRedoManager.CanRedo;
  
  if FUndoRedoManager.CanUndo then
    actUndo.Text := FUndoRedoManager.GetUndoDescription
  else
    actUndo.Text := '撤销';
    
  if FUndoRedoManager.CanRedo then
    actRedo.Text := FUndoRedoManager.GetRedoDescription
  else
    actRedo.Text := '重做';
end;

procedure TViewMainFormFMX.ExecuteINIValueChange(const ASection, AKey, AOldValue, ANewValue: string);
var
  Cmd: TSetINIValueCommand;
begin
  Cmd := TSetINIValueCommand.Create(ASection, AKey, AOldValue, ANewValue,
    procedure(S, K, V: string)
    begin
      FConfigManager.SetINIValue(S, K, V);
    end);
  FUndoRedoManager.ExecuteCommand(Cmd);
end;

procedure TViewMainFormFMX.LoadRawDocuments;
begin
  // 加载 INI 原文
  if (FCurrentFilePath <> '') and TFile.Exists(FCurrentFilePath) then
    mmoINIRaw.Lines.LoadFromFile(FCurrentFilePath, TEncoding.UTF8)
  else
    mmoINIRaw.Lines.Clear;
  
  // 加载 JSON 原文
  if (FConfigManager.GetCurrentJsonPath <> '') and TFile.Exists(FConfigManager.GetCurrentJsonPath) then
    mmoJSONRaw.Lines.LoadFromFile(FConfigManager.GetCurrentJsonPath, TEncoding.UTF8)
  else
    mmoJSONRaw.Lines.Clear;
end;

procedure TViewMainFormFMX.SaveRawINI;
begin
  if FCurrentFilePath = '' then Exit;
  
  try
    mmoINIRaw.Lines.SaveToFile(FCurrentFilePath, TEncoding.UTF8);
    // 重新加载到 ConfigManager
    FConfigManager.CloseProject;
    FConfigManager.OpenProject(FCurrentFilePath);
    LoadConfigToTree;
    lblStatusOperation.Text := 'INI 原文已保存并重新加载';
  except
    on E: Exception do
      ShowMessage('保存 INI 失败: ' + E.Message);
  end;
end;

procedure TViewMainFormFMX.SaveRawJSON;
var
  JSONPath: string;
begin
  JSONPath := FConfigManager.GetCurrentJsonPath;
  if JSONPath = '' then Exit;
  
  try
    mmoJSONRaw.Lines.SaveToFile(JSONPath, TEncoding.UTF8);
    // 重新加载到 ConfigManager
    FConfigManager.CloseProject;
    FConfigManager.OpenProject(FCurrentFilePath);
    LoadConfigToTree;
    lblStatusOperation.Text := 'JSON 原文已保存并重新加载';
  except
    on E: Exception do
      ShowMessage('保存 JSON 失败: ' + E.Message);
  end;
end;

procedure TViewMainFormFMX.tabRightChange(Sender: TObject);
begin
  // 切换到原始文档 Tab 时加载内容
  if (tabRight.ActiveTab = tabINIRaw) or (tabRight.ActiveTab = tabJSONRaw) then
    LoadRawDocuments;
end;

procedure TViewMainFormFMX.mmoINIRawChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TViewMainFormFMX.mmoJSONRawChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TViewMainFormFMX.NavigateToValidationItem(const APath: string);
var
  Parts: TArray<string>;
  Section, Key: string;
  I: Integer;
  Node: TTreeViewItem;
  ListItem: TListBoxItem;
begin
  // 解析路径 (格式: Section/Key 或 JSON路径)
  Parts := APath.Split(['/']);
  if Length(Parts) < 1 then Exit;
  
  Section := Parts[0];
  if Length(Parts) > 1 then
    Key := Parts[1]
  else
    Key := '';
  
  // 在树视图中查找并选中节点
  for I := 0 to trvConfig.Count - 1 do
  begin
    Node := trvConfig.Items[I];
    if Node.TagString = Section then
    begin
      trvConfig.Selected := Node;
      LoadPropertiesToList(Section);
      
      // 如果有 Key，在属性列表中查找并选中
      if Key <> '' then
      begin
        for ListItem in lstProperties.ListItems do
        begin
          if ListItem.TagString.EndsWith('.' + Key) then
          begin
            lstProperties.Selected := ListItem;
            Break;
          end;
        end;
      end;
      
      Break;
    end;
  end;
  
  // 切换到属性 Tab
  tabLeft.ActiveTab := tabProperties;
end;

end.
