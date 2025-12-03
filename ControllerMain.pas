unit ControllerMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms,
  Vcl.Controls, Vcl.ComCtrls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.ValEdit, Vcl.Graphics,
  System.UITypes, System.JSON, JSONHelpers, System.Types, System.IniFiles,
  System.Generics.Collections, ModelConfig, ModelRegistry, HelperForm,
  UtilsLog, ControllerIntf, ViewIntf, ConfigTree, CreateConfigItem,
  FramesComplexEditor;

type
  // 编辑器类型
  TEditorType = (etJSON, etINI, etXML, etText);

  // 扩展配置页面信息 - 基于ControllerIntf的定义
  TExtendedConfigPageInfo = record
    Info: TConfigPageInfo;      // 基础配置信息
    TabSheet: TTabSheet;        // 对应的标签页
    Title: string;              // 显示标题
  end;
  PExtendedConfigPageInfo = ^TExtendedConfigPageInfo;

  // 特殊配置项类型，用于专属编辑器
  TConfigSpecialItem = class
  public
    Name: string;
    Path: string;
    EditorType: string;
    constructor Create;
  end;

  // 主控制器类
  TMainController = class(TInterfacedObject, IMainController)
  private
    FOwner: IMainForm;                   // 主窗口引用
    FConfigList: TStringList;           // 配置列表
    FRecentFiles: TStringList;          // 最近打开的文件列表
    FOpenedPages: TList;                // 已打开的页面列表
    FModifiedPages: TStringList;        // 已修改的页面列表
    FCurrentBasicConfigPath: string;    // 当前基础配置文件路径
    FAvailableThemes: TStringList;      // 可用主题列表

    procedure CleanupOpenedPages;
    function GetCurrentPage: PExtendedConfigPageInfo;
    function GetPageInfo(const TabSheet: TTabSheet): PExtendedConfigPageInfo;
    function CreateEditorFrame(const ConfigPath: string; ConfigType: TEditorType): TFrame;
    function GetPageByConfigPath(const ConfigPath: string): TTabSheet;
    function FindConfigType(const ConfigPath: string): TEditorType;
    procedure LoadRecentFiles;
    procedure SaveRecentFiles;
    procedure AddRecentFile(const Filename: string);
    function CreateNewTabSheet(const Title: string): TTabSheet;
    function FindOpenedPage(const ConfigPath: string): PExtendedConfigPageInfo;
    function CreateConfigEditor(TabSheet: TTabSheet; const ConfigPath, ConfigType: string): Boolean;
    function CloseEditor(PageInfo: PExtendedConfigPageInfo): Boolean;
    procedure CreateNewNode(ParentNode: TTreeNode; const FolderPath: string);
    procedure ShowDebugMessage(const Msg: string);
    procedure SaveValueItems;
    procedure DisposePageInfo(var PageInfo: PExtendedConfigPageInfo);

    // 简单项目创建处理
    procedure HandleSimpleItemCreate(const Item: TConfigItemCreateResult);
    procedure HandleSpecialItemCreate(const Item: TConfigItemCreateResult);
    procedure RefreshIniValueListEditor;
    function CreateConfigPageInfo(const APageName, AConfigPath, AConfigType: string): PExtendedConfigPageInfo;

  public
    constructor Create(AOwner: IMainForm);
    destructor Destroy; override;

    { 值列表编辑器操作 }
    procedure HandleValueListDoubleClick(Sender: TObject);
    procedure DrawValueListCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure ValidateValueListEntry(ACol, ARow: Integer; const KeyName, KeyValue: string);
    procedure ValidateValueListStrings;
    procedure AddValueItem;
    procedure DeleteValueItem;
    procedure RenameValueItem;
    procedure DrawValueList;
    procedure AddSection;

    { 初始化操作 }
    procedure InitLists;
    procedure InitializeTree;
    procedure InitializeConfigTree(TreeView: TTreeView);
    procedure LoadAvailableThemes;

    { 状态栏更新 }
    procedure UpdateStatusBar;

    { 树节点事件处理 }
    procedure HandleTreeNodeChange(Node: TTreeNode);
    procedure HandleTreeNodeDoubleClick;
    procedure OpenSelectedTreeNode;
    procedure CreateNewConfigObject;
    procedure DeleteSelectedTreeNode;
    procedure RenameSelectedTreeNode;
    procedure RefreshTreeView;

    { 配置文件操作 }
    procedure OpenConfigFile;
    procedure OpenSelectedFile(const Filename: string);
    function LoadConfigFile(const Filename: string): Boolean;
    procedure SaveCurrentConfig;
    procedure SaveConfigFileAs;
    procedure ReloadCurrentConfig;
    procedure ValidateCurrentConfig;
    procedure CloseCurrentTab;

    { 标签页事件处理 }
    procedure HandleTabChange;

    { 主题操作 }
    procedure ApplyTheme(const ThemeName: string);

    { 关于对话框 }
    procedure ShowAboutDialog;

    // 创建新配置文件
    procedure CreateNewConfigFile;

    // 打开专属编辑器
    function OpenSpecialEditor(const EditorType, ConfigPath: string): Boolean;
  end;

// 检查数组中是否包含指定文本
function ContainsText(const Arr: TArray<string>; const Value: string): Boolean;

implementation

uses
  ViewMain, ViewConfigEditor, JSONConfig, INIConfig, FrameConfigEditor,
  FrameFontEditor, FrameAIAPIEditor, BaseConfig, ConfigTypes;

{ TConfigSpecialItem }

constructor TConfigSpecialItem.Create;
begin
  inherited;
  Name := '';
  Path := '';
  EditorType := '';
end;

{ TMainController }

// 值列表编辑器双击事件处理
procedure TMainController.HandleValueListDoubleClick(Sender: TObject);
var
  ValueListEditor: TValueListEditor;
begin
  if Sender is TValueListEditor then
  begin
    ValueListEditor := TValueListEditor(Sender);
    ShowDebugMessage('处理值列表双击事件');
    // 这里可以添加对应的值列表双击处理逻辑
    // 例如根据当前行调用编辑项或重命名项等功能
    RenameValueItem;
  end;
end;

// 绘制值列表单元格
procedure TMainController.DrawValueListCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  OldColor: TColor;
  Key, Value: string;
  ValueListEditor: TValueListEditor;
begin
  // 绘制值列表单元格
  if not (Sender is TValueListEditor) then
    Exit;
  
  ValueListEditor := TValueListEditor(Sender);
  
  // 保存原始颜色
  OldColor := ValueListEditor.Canvas.Brush.Color;
  
  try
    // 获取键值
    if ARow < ValueListEditor.RowCount then
    begin
      if ACol = 0 then
      begin
        if ValueListEditor.Keys[ARow] <> '' then
          Key := ValueListEditor.Keys[ARow];
      end
      else
      begin
        if (ValueListEditor.Keys[ARow] <> '') then
          Value := ValueListEditor.Values[ValueListEditor.Keys[ARow]];
      end;
    end;
    
    // 自定义绘制逻辑
    if (ACol = 0) and (ARow > 0) and (Key <> '') and Key.StartsWith('[') and Key.EndsWith(']') then
    begin
      // 节标题使用不同的背景色
      ValueListEditor.Canvas.Brush.Color := clBtnFace;
      ValueListEditor.Canvas.FillRect(Rect);
      ValueListEditor.Canvas.Font.Style := [fsBold];
      ValueListEditor.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Key);
    end
    else if gdSelected in State then
    begin
      // 选中的单元格
      ValueListEditor.Canvas.Brush.Color := clHighlight;
      ValueListEditor.Canvas.Font.Color := clHighlightText;
      ValueListEditor.Canvas.FillRect(Rect);
      
      if ACol = 0 then
        ValueListEditor.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Key)
      else
        ValueListEditor.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Value);
    end
    else
    begin
      // 默认绘制
      ValueListEditor.DefaultDrawCell(ACol, ARow, Rect, State);
    end;
  finally
    // 恢复原始颜色
    ValueListEditor.Canvas.Brush.Color := OldColor;
    ValueListEditor.Canvas.Font.Style := [];
    ValueListEditor.Canvas.Font.Color := clWindowText;
  end;
end;

constructor TMainController.Create(AOwner: IMainForm);
begin
  inherited Create;
  FOwner := AOwner;
  InitLists;
  LoadRecentFiles;
end;

destructor TMainController.Destroy;
begin
  try
    // 清理已打开的页面
    CleanupOpenedPages;

    // 释放分配的内存
    if Assigned(FConfigList) then FConfigList.Free;
    if Assigned(FRecentFiles) then FRecentFiles.Free;
    if Assigned(FOpenedPages) then FOpenedPages.Free;
    if Assigned(FModifiedPages) then FModifiedPages.Free;
    if Assigned(FAvailableThemes) then FAvailableThemes.Free;

    // 确保FOwner被正确释放
    FOwner := nil;
  except
    // 捕获并记录异常信息
    on E: Exception do
    begin
      // 如果FOwner可用，记录错误信息
      if Assigned(@UtilsLog.LogError) then
        UtilsLog.LogError('析构函数中发生错误: ' + E.Message);
    end;
  end;

  inherited;
end;

procedure TMainController.InitLists;
begin
  // 初始化列表
  FConfigList := TStringList.Create;
  FRecentFiles := TStringList.Create;
  FOpenedPages := TList.Create;
  FModifiedPages := TStringList.Create;
  FAvailableThemes := TStringList.Create;
end;

procedure TMainController.CleanupOpenedPages;
var
  i: Integer;
  PageInfo: PExtendedConfigPageInfo;
begin
  // 清理已打开的页面
  if Assigned(FOpenedPages) then
  begin
    try
      for i := 0 to FOpenedPages.Count - 1 do
      begin
        PageInfo := PExtendedConfigPageInfo(FOpenedPages[i]);
        if Assigned(PageInfo) then
        begin
          // 释放页面信息
          DisposePageInfo(PageInfo);
          FOpenedPages[i] := nil;
        end;
      end;
    except
      on E: Exception do
      begin
        // 记录错误信息
        if Assigned(FOwner) then
          FOwner.AddDebugMessage('清理页面时发生错误: ' + E.Message);
      end;
    end;
  end;
end;

// 释放页面信息
procedure TMainController.DisposePageInfo(var PageInfo: PExtendedConfigPageInfo);
begin
  if not Assigned(PageInfo) then
    Exit;

  try
    // 释放TabSheet
    PageInfo^.TabSheet := nil;

    // 清空信息
    PageInfo^.Info.PageName := '';
    PageInfo^.Info.ConfigPath := '';
    PageInfo^.Info.ConfigType := '';
    PageInfo^.Title := '';

    // 释放内存
    Dispose(PageInfo);
    PageInfo := nil;
  except
    on E: Exception do
    begin
      // 记录错误信息
      if Assigned(FOwner) then
        FOwner.AddDebugMessage('释放页面信息时发生错误: ' + E.Message);
    end;
  end;
end;

// 获取当前页面
function TMainController.GetCurrentPage: PExtendedConfigPageInfo;
var
  PageControl: TPageControl;
begin
  Result := nil;
  
  // 获取页面控件
  if Assigned(FOwner) then
  begin
    PageControl := FOwner.GetPageControl;
    if Assigned(PageControl) and (PageControl.PageCount > 0) and
       Assigned(PageControl.ActivePage) then
    begin
      Result := GetPageInfo(PageControl.ActivePage);
    end;
  end;
end;

// 根据TabSheet获取页面信息
function TMainController.GetPageInfo(const TabSheet: TTabSheet): PExtendedConfigPageInfo;
var
  i: Integer;
  PageInfo: PExtendedConfigPageInfo;
begin
  Result := nil;
  
  // 查找页面信息
  if Assigned(FOpenedPages) and Assigned(TabSheet) then
  begin
    for i := 0 to FOpenedPages.Count - 1 do
    begin
      PageInfo := PExtendedConfigPageInfo(FOpenedPages[i]);
      if Assigned(PageInfo) and (PageInfo^.TabSheet = TabSheet) then
      begin
        Result := PageInfo;
        Break;
      end;
    end;
  end;
end;

// 创建新标签页
function TMainController.CreateNewTabSheet(const Title: string): TTabSheet;
var
  PageControl: TPageControl;
begin
  Result := nil;
  
  // 获取页面控件
  if Assigned(FOwner) then
  begin
    PageControl := FOwner.GetPageControl;
    if Assigned(PageControl) then
    begin
      Result := TTabSheet.Create(PageControl);
      Result.PageControl := PageControl;
      Result.Caption := Title;
    end;
  end;
end;

// 查找已打开的页面
function TMainController.FindOpenedPage(const ConfigPath: string): PExtendedConfigPageInfo;
var
  i: Integer;
  PageInfo: PExtendedConfigPageInfo;
begin
  Result := nil;
  
  // 查找页面信息
  if Assigned(FOpenedPages) then
  begin
    for i := 0 to FOpenedPages.Count - 1 do
    begin
      PageInfo := PExtendedConfigPageInfo(FOpenedPages[i]);
      if Assigned(PageInfo) and (PageInfo^.Info.ConfigPath = ConfigPath) then
      begin
        Result := PageInfo;
        Break;
      end;
    end;
  end;
end;

// 显示调试信息
procedure TMainController.ShowDebugMessage(const Msg: string);
begin
  if Assigned(FOwner) then
    FOwner.AddDebugMessage(Msg);
end;

// 检查数组中是否包含指定文本
function ContainsText(const Arr: TArray<string>; const Value: string): Boolean;
var
  Item: string;
begin
  Result := False;
  for Item in Arr do
  begin
    if SameText(Item, Value) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TMainController.CreateConfigPageInfo(const APageName, AConfigPath, AConfigType: string): PExtendedConfigPageInfo;
begin
  New(Result);
  Result^.Info.PageName := APageName;
  Result^.Info.ConfigPath := AConfigPath;
  Result^.Info.ConfigType := AConfigType;
  Result^.TabSheet := nil;
  Result^.Title := APageName;
end;

procedure TMainController.DrawValueList;
var
  ValueListEditor: TValueListEditor;
begin
  // 刷新整个值列表编辑器
  if Assigned(FOwner) then
  begin
    ValueListEditor := FOwner.GetValueListEditor;
    if Assigned(ValueListEditor) then
    begin
      ValueListEditor.Invalidate;
    end;
  end;
end;

procedure TMainController.ValidateValueListEntry(ACol, ARow: Integer; const KeyName, KeyValue: string);
begin
  // 当用户编辑值列表条目时调用
  if Assigned(FOwner) then
  begin
    FOwner.AddDebugMessage(Format('验证值条目: [%s] = [%s]', [KeyName, KeyValue]));
    
    // 在这里可以添加额外的验证逻辑
    
    // 更新UI状态以指示已修改
    FOwner.UpdateUIState(False);
  end;
end;

procedure TMainController.ValidateValueListStrings;
begin
  // 验证所有值列表字符串
  if Assigned(FOwner) then
  begin
    FOwner.AddDebugMessage('验证值列表字符串');
  end;
end;

procedure TMainController.AddValueItem;
begin
  // 在这里实现添加值项的方法
  ShowDebugMessage('添加值项');
end;

procedure TMainController.DeleteValueItem;
begin
  // 在这里实现删除值项的方法
  ShowDebugMessage('删除值项');
end;

procedure TMainController.RenameValueItem;
begin
  // 在这里实现重命名值项的方法
  ShowDebugMessage('重命名值项');
end;

procedure TMainController.AddSection;
begin
  // 在这里实现添加区段的方法
  ShowDebugMessage('添加区段');
end;

procedure TMainController.UpdateStatusBar;
begin
  // 在这里实现更新状态栏的方法
  ShowDebugMessage('更新状态栏');
end;

procedure TMainController.HandleTreeNodeChange(Node: TTreeNode);
begin
  // 在这里实现处理树节点变更的方法
  ShowDebugMessage('处理树节点变更');
end;

procedure TMainController.HandleTreeNodeDoubleClick;
begin
  // 在这里实现处理树节点双击的方法
  ShowDebugMessage('处理树节点双击');
end;

procedure TMainController.OpenSelectedTreeNode;
begin
  // 在这里实现打开选中树节点的方法
  ShowDebugMessage('打开选中树节点');
end;

procedure TMainController.CreateNewConfigObject;
begin
  // 在这里实现创建新配置对象的方法
  ShowDebugMessage('创建新配置对象');
end;

procedure TMainController.DeleteSelectedTreeNode;
begin
  // 在这里实现删除选中树节点的方法
  ShowDebugMessage('删除选中树节点');
end;

procedure TMainController.RenameSelectedTreeNode;
begin
  // 在这里实现重命名选中树节点的方法
  ShowDebugMessage('重命名选中树节点');
end;

procedure TMainController.RefreshTreeView;
begin
  // 在这里实现刷新树视图的方法
  ShowDebugMessage('刷新树视图');
end;

procedure TMainController.OpenConfigFile;
begin
  // 在这里实现打开配置文件的方法
  ShowDebugMessage('打开配置文件');
end;

procedure TMainController.OpenSelectedFile(const Filename: string);
begin
  // 在这里实现打开选中文件的方法
  ShowDebugMessage('打开选中文件: ' + Filename);
end;

procedure TMainController.SaveCurrentConfig;
begin
  // 在这里实现保存当前配置的方法
  ShowDebugMessage('保存当前配置');
end;

procedure TMainController.SaveConfigFileAs;
begin
  // 在这里实现另存为配置文件的方法
  ShowDebugMessage('另存为配置文件');
end;

procedure TMainController.ReloadCurrentConfig;
begin
  // 在这里实现重新加载当前配置的方法
  ShowDebugMessage('重新加载当前配置');
end;

procedure TMainController.ValidateCurrentConfig;
begin
  // 在这里实现验证当前配置的方法
  ShowDebugMessage('验证当前配置');
end;

procedure TMainController.CloseCurrentTab;
begin
  // 在这里实现关闭当前标签页的方法
  ShowDebugMessage('关闭当前标签页');
end;

function TMainController.CreateEditorFrame(const ConfigPath: string; ConfigType: TEditorType): TFrame;
begin
  // 在这里实现创建编辑器Frame的方法
  ShowDebugMessage('创建编辑器Frame');
  Result := nil;
end;

function TMainController.GetPageByConfigPath(const ConfigPath: string): TTabSheet;
begin
  // 在这里实现根据配置路径获取页面的方法
  ShowDebugMessage('根据配置路径获取页面');
  Result := nil;
end;

function TMainController.FindConfigType(const ConfigPath: string): TEditorType;
begin
  // 在这里实现查找配置类型的方法
  ShowDebugMessage('查找配置类型');
  Result := etText;
end;

procedure TMainController.LoadRecentFiles;
begin
  // 在这里实现加载最近文件的方法
  ShowDebugMessage('加载最近文件');
end;

procedure TMainController.SaveRecentFiles;
begin
  // 在这里实现保存最近文件的方法
  ShowDebugMessage('保存最近文件');
end;

procedure TMainController.AddRecentFile(const Filename: string);
begin
  // 在这里实现添加最近文件的方法
  ShowDebugMessage('添加最近文件: ' + Filename);
end;

function TMainController.CreateConfigEditor(TabSheet: TTabSheet; const ConfigPath, ConfigType: string): Boolean;
begin
  // 在这里实现创建配置编辑器的方法
  ShowDebugMessage('创建配置编辑器');
  Result := False;
end;

function TMainController.CloseEditor(PageInfo: PExtendedConfigPageInfo): Boolean;
begin
  // 在这里实现关闭编辑器的方法
  ShowDebugMessage('关闭编辑器');
  Result := False;
end;

procedure TMainController.CreateNewNode(ParentNode: TTreeNode; const FolderPath: string);
begin
  // 在这里实现创建新节点的方法
  ShowDebugMessage('创建新节点');
end;

procedure TMainController.SaveValueItems;
begin
  // 在这里实现保存值项的方法
  ShowDebugMessage('保存值项');
end;

procedure TMainController.HandleSimpleItemCreate(const Item: TConfigItemCreateResult);
begin
  // 在这里实现处理简单项目创建的方法
  ShowDebugMessage('处理简单项目创建');
end;

procedure TMainController.HandleSpecialItemCreate(const Item: TConfigItemCreateResult);
begin
  // 在这里实现处理特殊项目创建的方法
  ShowDebugMessage('处理特殊项目创建');
end;

procedure TMainController.RefreshIniValueListEditor;
begin
  // 在这里实现刷新INI值列表编辑器的方法
  ShowDebugMessage('刷新INI值列表编辑器');
end;

procedure TMainController.HandleTabChange;
begin
  // 在这里实现处理标签页变更的方法
  ShowDebugMessage('处理标签页变更');
end;

procedure TMainController.ApplyTheme(const ThemeName: string);
begin
  // 在这里实现应用主题的方法
  ShowDebugMessage('应用主题: ' + ThemeName);
end;

procedure TMainController.ShowAboutDialog;
begin
  // 在这里实现显示关于对话框的方法
  ShowDebugMessage('显示关于对话框');
end;

procedure TMainController.InitializeTree;
begin
  // 在这里实现初始化树的方法
  ShowDebugMessage('初始化树');
end;

procedure TMainController.InitializeConfigTree(TreeView: TTreeView);
begin
  // 在这里实现初始化配置树的方法
  ShowDebugMessage('初始化配置树');
end;

procedure TMainController.LoadAvailableThemes;
begin
  // 在这里实现加载可用主题的方法
  ShowDebugMessage('加载可用主题');
end;

function TMainController.LoadConfigFile(const Filename: string): Boolean;
begin
  // 在这里实现加载配置文件的方法
  ShowDebugMessage('加载配置文件: ' + Filename);
  Result := False;
end;

procedure TMainController.CreateNewConfigFile;
begin
  // 在这里实现创建新配置文件的方法
  ShowDebugMessage('创建新配置文件');
end;

function TMainController.OpenSpecialEditor(const EditorType, ConfigPath: string): Boolean;
begin
  // 在这里实现打开专属编辑器的方法
  ShowDebugMessage('打开专属编辑器: ' + EditorType + ', ' + ConfigPath);
  Result := False;
end;

end.

