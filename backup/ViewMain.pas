unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.ToolWin, Vcl.ImgList, 
  Vcl.Grids, Vcl.ValEdit, System.UITypes, System.Types, Vcl.FileCtrl,
  System.JSON, System.IniFiles, System.Generics.Collections, System.ImageList,
  ControllerIntf, ViewIntf, HelperForm, ModelConfig, UtilsLog, ControllerMain;

type
  TViewMain = class(TForm, IMainForm)
    pnlMain: TPanel;
    pnlLeft: TPanel;
    tvConfig: TTreeView;
    pmTree: TPopupMenu;
    pmEditor: TPopupMenu;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    ilIcons: TImageList;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuSep1: TMenuItem;
    mnuExit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuTools: TMenuItem;
    mnuValidate: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    sbMain: TStatusBar;
    pnlClient: TPanel;
    pcEditors: TPageControl;
    tsWelcome: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    pmTreeOpen: TMenuItem;
    pmTreeNew: TMenuItem;
    pmTreeDelete: TMenuItem;
    pmTreeRename: TMenuItem;
    pmEditorSave: TMenuItem;
    pmEditorClose: TMenuItem;
    pmEditorValidate: TMenuItem;
    pnlTop: TPanel;
    btnOpen: TButton;
    btnSave: TButton;
    btnNew: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnLoadTemplate: TButton;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    TabSheet1: TTabSheet;
    IniValueListEditor: TValueListEditor;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    meoDebug: TMemo;
    splMain: TSplitter;
    Splitter1: TSplitter;
    procedure tvConfigDblClick(Sender: TObject);
    procedure tvConfigChange(Sender: TObject; Node: TTreeNode);
    procedure btnSaveClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure btnValidateClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure pcEditorsChange(Sender: TObject);
    procedure pmTreeOpenClick(Sender: TObject);
    procedure pmTreeNewClick(Sender: TObject);
    procedure pmTreeDeleteClick(Sender: TObject);
    procedure pmTreeRenameClick(Sender: TObject);
    procedure pmEditorSaveClick(Sender: TObject);
    procedure pmEditorCloseClick(Sender: TObject);
    procedure pmEditorValidateClick(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ValueListEditorDblClick(Sender: TObject);
    procedure ValueListEditorValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
    procedure AddValueItemClick(Sender: TObject);
    procedure DeleteValueItemClick(Sender: TObject);
    procedure SaveValueItemsClick(Sender: TObject);
    procedure cbbThemeChange(Sender: TObject);
    procedure RenameValueItemClick(Sender: TObject);
    procedure AddSectionClick(Sender: TObject);
    procedure ValueListEditorDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure btnOpenClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLoadTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBasicInfoTab: TTabSheet;         // 基础信息选项卡
    FValueListEditor: TValueListEditor; // 值列表编辑器
    FCurrentBasicConfigPath: string;   // 当前基础信息配置文件路径
    FMainController: IMainController;  // 使用接口避免循环引用
    FIniTab: TTabSheet;               // INI内容选项卡
    FJsonTab: TTabSheet;              // JSON内容选项卡
    FIniMemo: TMemo;                  // INI内容显示控件
    FJsonMemo: TMemo;                 // JSON内容显示控件
    FDragNode: TTreeNode;             // 被拖拽的节点
    FIsDragging: Boolean;             // 是否正在拖拽中

    procedure InitializeBasicInfoTab;
    procedure InitializeComponents;
    procedure InitializeIniJsonTabs;
    procedure LoadTemplateConfig;
    procedure EnableDragDrop;         // 启用拖放功能
    procedure HandleTreeViewDragDrop(Sender, Source: TObject; X, Y: Integer); // 处理树视图拖放
    procedure HandleTreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); // 处理树视图拖动悬停
    procedure HandleValueListEditorDragDrop(Sender, Source: TObject; X, Y: Integer); // 处理值列表编辑器拖放
    procedure HandleValueListEditorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); // 处理值列表编辑器拖动悬停
    procedure HandleTreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); // 处理树视图鼠标按下
  public
    procedure UpdateIniTabContent(const IniFilePath: string);
    procedure UpdateJsonTabContent(const JsonFilePath: string);
    procedure UpdateStatusBar;
    procedure AddDebugMessage(const Msg: string);
    function GetDebugMemo: TMemo;
    function GetTreeView: TTreeView;
    function GetPageControl: TPageControl;
    function GetStatusBar: TStatusBar;
    function GetFormHandle: TForm;
    function GetValueListEditor: TValueListEditor;
    function GetEditorContent: TWinControl;
    procedure UpdateUIState(IsInvalid: Boolean = False);
    procedure ClearEditor;
    procedure ShowFolderInfo(const Path: string);
    procedure ShowJSONEditor(const Path: string);
    procedure ShowINIEditor(const Path: string);
    procedure ShowTextEditor(const Path: string);
    procedure ShowError(const ErrorMessage: string);
    
    property MainController: IMainController read FMainController;
  end;

var
  FormMain: TViewMain;

implementation

uses
  ViewConfigEditor, ConfigTree;

{$R *.dfm}

// 初始化组件
procedure TViewMain.InitializeComponents;
begin
  // 初始化所有组件
  try
    // 设置FileListBox1只显示config目录下的.ini文件
    if System.SysUtils.DirectoryExists(ExtractFilePath(Application.ExeName) + 'config') then
    begin
      FileListBox1.Directory := ExtractFilePath(Application.ExeName) + 'config';
      FileListBox1.Mask := '*.ini';
      AddDebugMessage('设置FileListBox1目录: ' + FileListBox1.Directory);
    end
    else
    begin
      AddDebugMessage('警告: config目录不存在，将创建它');
      if ForceDirectories(ExtractFilePath(Application.ExeName) + 'config') then
      begin
        FileListBox1.Directory := ExtractFilePath(Application.ExeName) + 'config';
        FileListBox1.Mask := '*.ini';
        AddDebugMessage('已创建config目录并设置FileListBox1目录');
      end
      else
      begin
        AddDebugMessage('错误: 无法创建config目录');
      end;
    end;
    
    // 初始化状态栏
    UpdateStatusBar;

    // 输出初始化完成信息
    AddDebugMessage('组件初始化完成');
  except
    on E: Exception do
      AddDebugMessage('初始化组件失败: ' + E.Message);
  end;
end;

// 初始化基础信息选项卡
procedure TViewMain.InitializeBasicInfoTab;
begin
  try
    // 查找已存在的基本属性选项卡
    for var i := 0 to pcEditors.PageCount - 1 do
    begin
      if pcEditors.Pages[i].Caption = '基本属性' then
      begin
        FBasicInfoTab := pcEditors.Pages[i];
        break;
      end;
    end;
    
    // 如果在现有选项卡中没找到，则创建一个
    if FBasicInfoTab = nil then
    begin
      FBasicInfoTab := TTabSheet.Create(pcEditors);
      FBasicInfoTab.PageControl := pcEditors;
      FBasicInfoTab.Caption := '基本属性';
      
      // 创建值列表编辑器
      FValueListEditor := TValueListEditor.Create(FBasicInfoTab);
      FValueListEditor.Parent := FBasicInfoTab;
      FValueListEditor.Align := alClient;
      // 设置值列表编辑器选项，使用公开属性
      FValueListEditor.FixedCols := 1;
      FValueListEditor.FixedRows := 1;
      FValueListEditor.ColCount := 2;
      FValueListEditor.Strings.Clear();
      // 设置事件处理程序
      FValueListEditor.OnClick := ValueListEditorDblClick;
      FValueListEditor.OnDrawCell := ValueListEditorDrawCell;
    end
    else
    begin
      // 查找已存在的值列表编辑器
      for var i := 0 to FBasicInfoTab.ControlCount - 1 do
      begin
        if FBasicInfoTab.Controls[i] is TValueListEditor then
        begin
          FValueListEditor := TValueListEditor(FBasicInfoTab.Controls[i]);
          break;
        end;
      end;
      
      // 如果没找到，则创建一个
      if FValueListEditor = nil then
      begin
        FValueListEditor := TValueListEditor.Create(FBasicInfoTab);
        FValueListEditor.Parent := FBasicInfoTab;
        FValueListEditor.Align := alClient;
        // 设置值列表编辑器选项，使用公开属性
        FValueListEditor.FixedCols := 1;
        FValueListEditor.FixedRows := 1;
        FValueListEditor.ColCount := 2;
        FValueListEditor.Strings.Clear();
        // 设置事件处理程序
        FValueListEditor.OnClick := ValueListEditorDblClick;
        FValueListEditor.OnDrawCell := ValueListEditorDrawCell;
      end;
    end;
    
    // 添加初始化完成信息
    AddDebugMessage('基本信息选项卡初始化完成');
  except
    on E: Exception do
      AddDebugMessage('初始化基本信息选项卡失败: ' + E.Message);
  end;
end;

// 窗体创建
procedure TViewMain.FormCreate(Sender: TObject);
var
  ConfigDir: string;
  i: Integer;
begin
  // 记录应用程序启动
  AddDebugMessage('应用程序启动 - ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
  
  try
    // 获取配置目录
    ConfigDir := ExtractFilePath(Application.ExeName) + 'config';
    
    // 确保配置目录存在
    if not DirectoryExists(ConfigDir) then
    begin
      AddDebugMessage('创建配置目录: ' + ConfigDir);
      ForceDirectories(ConfigDir);
    end;
    
    // 检查模板文件是否存在
    var TemplateIniPath := ConfigDir + '\template.ini';
    if not FileExists(TemplateIniPath) then
    begin
      AddDebugMessage('警告: 模板INI文件不存在: ' + TemplateIniPath);
      
      // 创建基本的模板INI文件
      var TemplateIni := TStringList.Create;
      try
        TemplateIni.Add('[Paths]');
        TemplateIni.Add('LogPath=.\logs');
        TemplateIni.Add('TempPath=.\temp');
        TemplateIni.Add('DataPath=.\data');
        TemplateIni.Add('');
        TemplateIni.Add('[Options]');
        TemplateIni.Add('CreateIfNotExists=1');
        TemplateIni.Add('ClearTempOnStartup=1');
        
        // 保存模板文件
        try
          TemplateIni.SaveToFile(TemplateIniPath, TEncoding.UTF8);
          AddDebugMessage('创建了默认模板文件: ' + TemplateIniPath);
        except
          on E: Exception do
            AddDebugMessage('无法创建默认模板文件: ' + E.Message);
        end;
      finally
        TemplateIni.Free;
      end;
    end;

    // 初始化设计时创建的TabSheet1为INI设置标签页
    for i := 0 to pcEditors.PageCount - 1 do
    begin
      if pcEditors.Pages[i].Caption = 'INI设置' then
      begin
        AddDebugMessage('找到设计时创建的INI设置标签页');
        // 将设计时创建的TabSheet1赋值给FIniTab
        FIniTab := pcEditors.Pages[i];
        break;
      end;
    end;

    // 如果找到了TabSheet1，则初始化IniValueListEditor
    if Assigned(FIniTab) then
    begin
      AddDebugMessage('初始化INI设置标签页中的ValueListEditor');
      
      // 查找IniValueListEditor控件
      for i := 0 to FIniTab.ControlCount - 1 do
      begin
        if FIniTab.Controls[i] is TValueListEditor then
        begin
          // 将找到的ValueListEditor赋值给类变量以便在其他地方使用
          FValueListEditor := TValueListEditor(FIniTab.Controls[i]);
          AddDebugMessage('找到INI设置标签页中的ValueListEditor');
          break;
        end;
      end;
    end;
    
    // 创建主控制器
    FMainController := TMainController.Create(Self);
    
    // 初始化列表
    FMainController.InitLists;
    
    // 初始化配置树视图
    if Assigned(tvConfig) then
      FMainController.InitializeTree;
    
    // 初始化INI和JSON选项卡
    InitializeIniJsonTabs;
    
    // 启用拖放功能
    EnableDragDrop;
    
    // 应用程序设置加载
    HelperForm.LoadApplicationSettings(Self, meoDebug);
    
    // 显示启动消息
    AddDebugMessage('界面初始化完成');
    
    // 强制处理消息队列
    Application.ProcessMessages;
    
    // 自动加载模板配置，以便初始化树视图和显示内容
    LoadTemplateConfig;
  except
    on E: Exception do
      AddDebugMessage('窗体创建错误: ' + E.Message);
  end;
end;

// UI更新方法
procedure TViewMain.UpdateStatusBar;
begin
  if Assigned(sbMain) then
  begin
    sbMain.Panels[0].Text := '配置编辑器就绪';
    sbMain.Panels[1].Text := '当前版本: 1.0.0';
    sbMain.Panels[2].Text := FormatDateTime('yyyy-mm-dd', Date);
  end;
end;

// Getter方法 - 为控制器提供UI组件
function TViewMain.GetDebugMemo: TMemo;
begin
  Result := meoDebug;
end;

function TViewMain.GetTreeView: TTreeView;
begin
  Result := tvConfig;
end;

function TViewMain.GetPageControl: TPageControl;
begin
  Result := pcEditors;
end;

function TViewMain.GetStatusBar: TStatusBar;
begin
  Result := sbMain;
end;

function TViewMain.GetFormHandle: TForm;
begin
  Result := Self;
end;

function TViewMain.GetValueListEditor: TValueListEditor;
begin
  Result := FValueListEditor;
end;

function TViewMain.GetEditorContent: TWinControl;
begin
  Result := pnlClient;
end;

// 简单事件委托给控制器
procedure TViewMain.tvConfigChange(Sender: TObject; Node: TTreeNode);
begin
  try
    if not Assigned(Node) then
    begin
      AddDebugMessage('tvConfigChange: 节点为nil，退出');
      Exit;
    end;
      
    AddDebugMessage('树节点改变: ' + Node.Text);
    
    // 确保INI和JSON标签页已初始化并可见
    InitializeIniJsonTabs;
    
    // 调用控制器处理树节点变更
    if Assigned(FMainController) then
      FMainController.HandleTreeNodeChange(Node);
    
    // 确保标签页在节点选择后可见
    if Assigned(FIniTab) then
    begin
      FIniTab.TabVisible := True;
      FIniTab.Visible := True;
      if Assigned(FIniMemo) then
        FIniMemo.Visible := True;
    end;
    
    if Assigned(FJsonTab) then
    begin
      FJsonTab.TabVisible := True;
      FJsonTab.Visible := True;
      if Assigned(FJsonMemo) then
        FJsonMemo.Visible := True;
    end;
    
    // 强制更新UI
    Application.ProcessMessages;
  except
    on E: Exception do
      AddDebugMessage('树节点选择错误: ' + E.Message);
  end;
end;

procedure TViewMain.tvConfigDblClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.HandleTreeNodeDoubleClick;
end;

procedure TViewMain.btnReloadClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    TMainController(FMainController).ReloadCurrentConfig;
end;

procedure TViewMain.btnSaveClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.SaveCurrentConfig;
end;

procedure TViewMain.btnValidateClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.ValidateCurrentConfig;
end;

procedure TViewMain.mnuOpenClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.OpenConfigFile;
end;

procedure TViewMain.mnuSaveClick(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

procedure TViewMain.mnuSaveAsClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.SaveConfigFileAs;
end;

procedure TViewMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TViewMain.mnuAboutClick(Sender: TObject);
begin
  ShowMessage('配置编辑器 v1.0.0'#13#10'Copyright © 2024');
end;

procedure TViewMain.pmTreeOpenClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.OpenSelectedTreeNode;
end;

procedure TViewMain.pmTreeNewClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.CreateNewConfigObject;
end;

procedure TViewMain.pmTreeDeleteClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.DeleteSelectedTreeNode;
end;

procedure TViewMain.pmTreeRenameClick(Sender: TObject);
begin
  if Assigned(FMainController) and Assigned(tvConfig.Selected) then
    tvConfig.Selected.EditText;
end;

procedure TViewMain.pmEditorSaveClick(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

procedure TViewMain.pmEditorCloseClick(Sender: TObject);
begin
  if Assigned(FMainController) and (pcEditors.PageCount > 0) then
    FMainController.CloseCurrentTab;
end;

procedure TViewMain.pmEditorValidateClick(Sender: TObject);
begin
  btnValidateClick(Sender);
end;

procedure TViewMain.pcEditorsChange(Sender: TObject);
begin
  try
    AddDebugMessage('选项卡切换到: ' + pcEditors.ActivePage.Caption);
    
    // 修复INI设置标签页的处理
    if (pcEditors.ActivePage = FIniTab) and (pcEditors.ActivePage.Caption = 'INI设置') then
    begin
      AddDebugMessage('激活INI设置标签页');
      
      // 确保IniValueListEditor已初始化
      if not Assigned(FValueListEditor) then
      begin
        for var i := 0 to FIniTab.ControlCount - 1 do
        begin
          if FIniTab.Controls[i] is TValueListEditor then
          begin
            FValueListEditor := TValueListEditor(FIniTab.Controls[i]);
            AddDebugMessage('在选项卡切换中初始化IniValueListEditor');
            break;
          end;
        end;
      end;
    end;
    
    if Assigned(FMainController) then
      TMainController(FMainController).HandleTabChange;
  except
    on E: Exception do
      AddDebugMessage('选项卡切换错误: ' + E.Message);
  end;
end;

procedure TViewMain.FileListBox1DblClick(Sender: TObject);
var
  SelectedFile, FullPath: string;
begin
  try
    if FileListBox1.ItemIndex < 0 then Exit;
    
    SelectedFile := FileListBox1.Items[FileListBox1.ItemIndex];
    AddDebugMessage('已选择文件: ' + SelectedFile);
    
    if ExtractFileExt(SelectedFile) = '' then
    begin
      // 如果是目录，则更新目录列表
      AddDebugMessage('不处理目录项');
      Exit;
    end;
    
    // 获取完整路径
    FullPath := FileListBox1.Directory + '\' + SelectedFile;
    
    AddDebugMessage('加载文件: ' + FullPath);
    
    // 确保首先初始化INI和JSON选项卡
    InitializeIniJsonTabs;
    
    // 使用当前路径加载配置文件
    if Assigned(FMainController) then
    begin
      if FMainController.LoadConfigFile(FullPath) then
      begin
        AddDebugMessage('文件加载成功');
        
        // 根据文件类型显示内容
        if LowerCase(ExtractFileExt(FullPath)) = '.ini' then
        begin
          AddDebugMessage('加载INI内容到标签页');
          UpdateIniTabContent(FullPath);
          
          // 查找关联的JSON文件
          var IniFile := TIniFile.Create(FullPath);
          try
            var JsonFileName := IniFile.ReadString('json_file', 'file_path', '');
            if JsonFileName <> '' then
            begin
              var JsonFilePath := ExtractFilePath(FullPath) + JsonFileName;
              
              if FileExists(JsonFilePath) then
              begin
                AddDebugMessage('加载关联的JSON文件: ' + JsonFilePath);
                UpdateJsonTabContent(JsonFilePath);
              end
              else
              begin
                AddDebugMessage('关联的JSON文件不存在: ' + JsonFilePath);
              end;
            end;
          finally
            IniFile.Free;
          end;
        end
        else if LowerCase(ExtractFileExt(FullPath)) = '.json' then
        begin
          AddDebugMessage('加载JSON内容到标签页');
          UpdateJsonTabContent(FullPath);
        end;
        
        // 手动激活选项卡显示内容
        if (LowerCase(ExtractFileExt(FullPath)) = '.ini') and Assigned(FIniTab) then
        begin
          AddDebugMessage('激活INI标签页');
          pcEditors.ActivePage := FIniTab;
          Application.ProcessMessages;
        end
        else if (LowerCase(ExtractFileExt(FullPath)) = '.json') and Assigned(FJsonTab) then
        begin
          AddDebugMessage('激活JSON标签页');
          pcEditors.ActivePage := FJsonTab;
          Application.ProcessMessages;
        end;
        
        // 更新状态栏
        UpdateStatusBar;
      end
      else
        AddDebugMessage('文件加载失败');
    end;
  except
    on E: Exception do
      AddDebugMessage('文件双击事件出错: ' + E.Message);
  end;
end;

// 值列表编辑器相关事件
procedure TViewMain.ValueListEditorDblClick(Sender: TObject);
var
  KeyName, Value: string;
  RefType, RefPath: string;
  EditorType: string;
  DialogResult: Integer;
  Row, Col: Integer;
begin
  try
    // 安全地从值列表编辑器中获取选中的行和列
    if Sender is TValueListEditor then
    begin
      // 使用 Strings 访问数据
      Row := TValueListEditor(Sender).Row;
      Col := TValueListEditor(Sender).Col;
      
      // 确保有选中的行并且不是标题行
      if (Row > 0) and (Col > 0) then
      begin
        // 安全地获取键名和值
        KeyName := TValueListEditor(Sender).Strings.Names[Row-1];
        Value := TValueListEditor(Sender).Strings.ValueFromIndex[Row-1];
        
        AddDebugMessage('双击值列表编辑器项: 键=' + KeyName + ', 值=' + Value);
        
        // 检查是否为引用项（以_ref:开头）
        if Value.StartsWith('_ref:') then
        begin
          // 解析引用类型和路径
          RefType := '';
          RefPath := '';
          
          // 提取引用类型和路径，格式为 _ref:类型.路径
          if Value.Contains('.') then
          begin
            RefType := Value.Substring(5, Value.IndexOf('.') - 5);
            RefPath := Value.Substring(Value.IndexOf('.') + 1);
            
            AddDebugMessage('解析引用: 类型=' + RefType + ', 路径=' + RefPath);
            
            // 根据引用类型打开相应的专属编辑器
            EditorType := '';
            
            if SameText(RefType, 'Font') then
              EditorType := 'FontEditor'
            else if SameText(RefType, 'Color') or SameText(RefType, 'Background') then
              EditorType := 'ColorEditor'
            else if SameText(RefType, 'Database') then
              EditorType := 'DatabaseEditor'
            else if SameText(RefType, 'Image') then
              EditorType := 'ImageEditor'
            else
              EditorType := 'ReferenceEditor';
            
            // 显示确认对话框
            DialogResult := MessageDlg('是否打开 ' + RefType + ' 类型的专属编辑器？', mtConfirmation, [mbYes, mbNo], 0);
            
            if DialogResult = mrYes then
            begin
              AddDebugMessage('打开专属编辑器: ' + EditorType + ' 用于路径: ' + RefPath);
              
              // 调用控制器打开专属编辑器
              if Assigned(FMainController) then
              begin
                if FMainController.OpenSpecialEditor(EditorType, RefPath) then
                  AddDebugMessage('专属编辑器打开成功')
                else
                  AddDebugMessage('专属编辑器打开失败');
              end;
            end;
          end
          else
          begin
            // 引用格式不正确
            AddDebugMessage('引用格式不正确: ' + Value);
            MessageDlg('引用格式不正确: ' + Value + #13#10 + '正确格式应为: _ref:类型.路径', mtWarning, [mbOK], 0);
          end;
        end
        else
        begin
          // 非引用项，传递给控制器处理普通值编辑
          if Assigned(FMainController) then
            FMainController.HandleValueListDoubleClick(Sender);
        end;
      end;
    end;
  except
    on E: Exception do
      AddDebugMessage('值列表编辑器双击事件出错: ' + E.Message);
  end;
end;

procedure TViewMain.ValueListEditorValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
begin
  if Assigned(FMainController) then
    FMainController.ValidateValueListEntry(ACol, ARow, KeyName, KeyValue);
end;

procedure TViewMain.ValueListEditorDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  // 自定义绘制单元格
  if Assigned(FMainController) then
    FMainController.DrawValueListCell(Sender, ACol, ARow, Rect, State)
  else
  begin
    if (Sender is TValueListEditor) and (ARow > 0) and (ACol = 0) then
    begin
      // 对键列进行自定义绘制
      var Grid := TValueListEditor(Sender);
      var CellText := Grid.Strings.Names[ARow-1];
      
      if CellText.StartsWith('[') and CellText.EndsWith(']') then
      begin
        // 这是一个节名称，使用粗体绘制
        Grid.Canvas.Font.Style := [fsBold];
        Grid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, CellText);
      end;
    end;
  end;
end;

procedure TViewMain.AddValueItemClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.AddValueItem;
end;

procedure TViewMain.DeleteValueItemClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.DeleteValueItem;
end;

procedure TViewMain.SaveValueItemsClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.SaveValueItems;
end;

procedure TViewMain.RenameValueItemClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.RenameValueItem;
end;

procedure TViewMain.AddSectionClick(Sender: TObject);
begin
  if Assigned(FMainController) then
    FMainController.AddSection;
end;

procedure TViewMain.cbbThemeChange(Sender: TObject);
begin
  if Assigned(FMainController) and (Sender is TComboBox) then
    FMainController.ApplyTheme(TComboBox(Sender).Text);
end;

// 添加AddDebugMessage方法实现
procedure TViewMain.AddDebugMessage(const Msg: string);
begin
  if Assigned(meoDebug) then
  begin
    meoDebug.Lines.Add(FormatDateTime('[yyyy-mm-dd hh:nn:ss] ', Now) + Msg);
    meoDebug.SelStart := meoDebug.GetTextLen;
    meoDebug.SelLength := 0;
    SendMessage(meoDebug.Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TViewMain.btnOpenClick(Sender: TObject);
begin
  mnuOpenClick(Sender);
end;

procedure TViewMain.btnNewClick(Sender: TObject);
begin
  pmTreeNewClick(Sender);
end;

procedure TViewMain.btnDeleteClick(Sender: TObject);
begin
  pmTreeDeleteClick(Sender);
end;

procedure TViewMain.btnRefreshClick(Sender: TObject);
begin
  if Assigned(FMainController) then
  begin
    FMainController.RefreshTreeView;
    AddDebugMessage('已刷新配置树');
  end;
end;

procedure TViewMain.btnLoadTemplateClick(Sender: TObject);
begin
  LoadTemplateConfig;
end;

procedure TViewMain.LoadTemplateConfig;
var
  TemplateIniPath, TemplateJsonPath: string;
begin
  try
    // 构建模板文件路径
    TemplateIniPath := ExtractFilePath(Application.ExeName) + 'config\template.ini';
    TemplateJsonPath := ExtractFilePath(Application.ExeName) + 'config\template_json.json';
    
    // 检查文件是否存在
    if not FileExists(TemplateIniPath) then
    begin
      ShowMessage(string('模板INI文件不存在: ') + TemplateIniPath);
      Exit;
    end;
    
    if not FileExists(TemplateJsonPath) then
    begin
      ShowMessage(string('模板JSON文件不存在: ') + TemplateJsonPath);
      Exit;
    end;
    
    // 显示正在加载的消息
    AddDebugMessage(string('正在加载模板配置...'));
    AddDebugMessage(string('INI文件: ') + TemplateIniPath);
    AddDebugMessage(string('JSON文件: ') + TemplateJsonPath);
    
    // 调用控制器方法加载配置
    if Assigned(FMainController) then
    begin
      if FMainController.LoadConfigFile(TemplateIniPath) then
      begin
        // 更新状态栏
        UpdateStatusBar;
        AddDebugMessage(string('模板配置加载成功'));
        
        // 选择树视图的根节点，展开它
        if tvConfig.Items.Count > 0 then
        begin
          tvConfig.Items[0].Selected := True;
          tvConfig.Items[0].Expand(True);
        end;
      end
      else
        AddDebugMessage(string('模板配置加载失败'));
    end
    else
      AddDebugMessage(string('控制器未初始化'));
  except
    on E: Exception do
      AddDebugMessage(string('加载模板配置时出错: ') + E.Message);
  end;
end;

// 窗体销毁
procedure TViewMain.FormDestroy(Sender: TObject);
begin
  try
    // 记录销毁过程开始
    if Assigned(meoDebug) then
      AddDebugMessage('开始销毁主窗体...');
      
    // 禁用所有控件以防止用户操作
    try
      Self.Enabled := False;
    except
      // 忽略任何禁用控件时的错误
    end;
    
    // 保存应用程序设置
    try
      if Assigned(meoDebug) then
        HelperForm.SaveApplicationSettings(Self, meoDebug);
    except
      on E: Exception do
      begin
        // 忽略设置保存错误，确保继续进行销毁过程
        if Assigned(meoDebug) then
          AddDebugMessage('保存设置时出错: ' + E.Message);
      end;
    end;
    
    // 在释放控制器前先关闭所有打开的选项卡
    try
      if Assigned(FMainController) and Assigned(pcEditors) and (pcEditors.PageCount > 0) then
      begin
        // 记录关闭标签页
        if Assigned(meoDebug) then
          AddDebugMessage('关闭所有打开的标签页...');
          
        // 从最后一个开始关闭所有标签页
        while pcEditors.PageCount > 0 do
        begin
          pcEditors.ActivePageIndex := pcEditors.PageCount - 1;
          FMainController.CloseCurrentTab;
        end;
      end;
    except
      on E: Exception do
      begin
        if Assigned(meoDebug) then
          AddDebugMessage('关闭标签页时出错: ' + E.Message);
      end;
    end;
    
    // 清理控件引用，防止在控制器释放后仍然访问它们
    try
      FValueListEditor := nil;
      FBasicInfoTab := nil;
      
      // 清空树视图
      if Assigned(tvConfig) then
      begin
        tvConfig.Items.Clear;
      end;
    except
      on E: Exception do
      begin
        if Assigned(meoDebug) then
          AddDebugMessage('清理控件引用时出错: ' + E.Message);
      end;
    end;
    
    // 清理资源 - 正确释放接口引用
    // 接口变量设为nil会减少引用计数，如果是最后一个引用则会释放对象
    // 为防止引用计数问题，使用try-finally确保变量被设为nil
    try
      // 记录控制器释放开始
      if Assigned(meoDebug) then
        AddDebugMessage('开始释放主控制器...');
    finally
      FMainController := nil;
      
      // 记录控制器释放完成
      try
        if Assigned(meoDebug) then
          AddDebugMessage('主窗体销毁完成');
      except
        // 忽略最后的日志记录错误
      end;
    end;
  except
    on E: Exception do
    begin
      // 捕获所有异常，确保FormDestroy能够完成
      try
        MessageBox(0, PChar('销毁表单时出错: ' + E.Message), '错误', MB_OK or MB_ICONERROR);
      except
        // 如果连显示错误消息都失败，我们无能为力了，但至少不会导致应用崩溃
      end;
    end;
  end;
end;

// 窗体显示
procedure TViewMain.FormShow(Sender: TObject);
begin
  // 窗体显示时的初始化代码
  if Assigned(meoDebug) then
    meoDebug.Lines.Add('窗体显示完成 - ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
  
  // 确保控件正确加载
  Application.ProcessMessages;
end;

procedure TViewMain.InitializeIniJsonTabs;
var
  i: Integer;
  TabFound: Boolean;
begin
  try
    AddDebugMessage('---开始初始化INI和JSON选项卡---');
    
    // 首先检查INI内容选项卡是否已经存在
    TabFound := False;
    for i := 0 to pcEditors.PageCount - 1 do
    begin
      if pcEditors.Pages[i].Caption = 'INI内容' then
      begin
        FIniTab := pcEditors.Pages[i];
        TabFound := True;
        AddDebugMessage('找到已存在的INI内容选项卡');
        
        // 查找已存在的Memo控件
        if FIniTab.ControlCount > 0 then
        begin
          for var j := 0 to FIniTab.ControlCount - 1 do
          begin
            if FIniTab.Controls[j] is TMemo then
            begin
              FIniMemo := TMemo(FIniTab.Controls[j]);
              AddDebugMessage('找到已存在的INI Memo控件');
              Break;
            end;
          end;
        end;
        Break;
      end;
    end;
    
    // 如果INI选项卡不存在，则创建
    if not TabFound then
    begin
      AddDebugMessage('创建INI内容选项卡...');
      
      FIniTab := TTabSheet.Create(pcEditors);
      FIniTab.PageControl := pcEditors;
      FIniTab.Caption := 'INI内容';
      FIniTab.Name := 'tsINIContent';
      
      // 强制处理消息，确保选项卡已正确创建
      Application.ProcessMessages;
      
      // 创建INI内容显示Memo
      FIniMemo := TMemo.Create(FIniTab);
      FIniMemo.Parent := FIniTab;
      FIniMemo.Align := alClient;
      FIniMemo.ScrollBars := ssBoth;
      FIniMemo.ReadOnly := True;  // 设为只读，仅用于显示
      FIniMemo.Font.Name := 'Consolas';  // 使用等宽字体
      FIniMemo.Font.Size := 10;
      FIniMemo.Name := 'memoINIContent';
      FIniMemo.WordWrap := False;  // 禁用自动换行
      FIniMemo.Text := '初始化INI内容显示区域...';  // 添加初始文本
      FIniMemo.Visible := True;    // 确保可见
      
      // 立即更新控件布局
      FIniMemo.BringToFront;
      FIniTab.Realign;
      
      AddDebugMessage('已创建INI内容选项卡和Memo控件');
    end
    else if FIniMemo = nil then
    begin
      // 如果选项卡存在但Memo不存在，则创建Memo
      AddDebugMessage('INI选项卡存在，但需要创建Memo控件');
      
      FIniMemo := TMemo.Create(FIniTab);
      FIniMemo.Parent := FIniTab;
      FIniMemo.Align := alClient;
      FIniMemo.ScrollBars := ssBoth;
      FIniMemo.ReadOnly := True;
      FIniMemo.Font.Name := 'Consolas';
      FIniMemo.Font.Size := 10;
      FIniMemo.Name := 'memoINIContent';
      FIniMemo.WordWrap := False;
      FIniMemo.Text := '初始化INI内容显示区域...';
      FIniMemo.Visible := True;
      
      FIniMemo.BringToFront;
      FIniTab.Realign;
      
      AddDebugMessage('已创建INI Memo控件');
    end;
    
    // 确保INI标签页可见
    FIniTab.TabVisible := True;
    FIniTab.Visible := True;
    AddDebugMessage('设置INI标签页为可见状态');
    
    // 检查JSON内容选项卡是否已经存在
    TabFound := False;
    for i := 0 to pcEditors.PageCount - 1 do
    begin
      if pcEditors.Pages[i].Caption = 'JSON内容' then
      begin
        FJsonTab := pcEditors.Pages[i];
        TabFound := True;
        AddDebugMessage('找到已存在的JSON内容选项卡');
        
        // 查找已存在的Memo控件
        if FJsonTab.ControlCount > 0 then
        begin
          for var j := 0 to FJsonTab.ControlCount - 1 do
          begin
            if FJsonTab.Controls[j] is TMemo then
            begin
              FJsonMemo := TMemo(FJsonTab.Controls[j]);
              AddDebugMessage('找到已存在的JSON Memo控件');
              Break;
            end;
          end;
        end;
        Break;
      end;
    end;
    
    // 如果JSON选项卡不存在，则创建
    if not TabFound then
    begin
      AddDebugMessage('创建JSON内容选项卡...');
      
      FJsonTab := TTabSheet.Create(pcEditors);
      FJsonTab.PageControl := pcEditors;
      FJsonTab.Caption := 'JSON内容';
      FJsonTab.Name := 'tsJSONContent';
      
      // 强制处理消息，确保选项卡已正确创建
      Application.ProcessMessages;
      
      // 创建JSON内容显示Memo
      FJsonMemo := TMemo.Create(FJsonTab);
      FJsonMemo.Parent := FJsonTab;
      FJsonMemo.Align := alClient;
      FJsonMemo.ScrollBars := ssBoth;
      FJsonMemo.ReadOnly := True;  // 设为只读，仅用于显示
      FJsonMemo.Font.Name := 'Consolas';  // 使用等宽字体
      FJsonMemo.Font.Size := 10;
      FJsonMemo.Name := 'memoJSONContent';
      FJsonMemo.WordWrap := False;  // 禁用自动换行
      FJsonMemo.Text := '初始化JSON内容显示区域...';  // 添加初始文本
      FJsonMemo.Visible := True;    // 确保可见
      
      // 立即更新控件布局
      FJsonMemo.BringToFront;
      FJsonTab.Realign;
      
      AddDebugMessage('已创建JSON内容选项卡和Memo控件');
    end
    else if FJsonMemo = nil then
    begin
      // 如果选项卡存在但Memo不存在，则创建Memo
      AddDebugMessage('JSON选项卡存在，但需要创建Memo控件');
      
      FJsonMemo := TMemo.Create(FJsonTab);
      FJsonMemo.Parent := FJsonTab;
      FJsonMemo.Align := alClient;
      FJsonMemo.ScrollBars := ssBoth;
      FJsonMemo.ReadOnly := True;
      FJsonMemo.Font.Name := 'Consolas';
      FJsonMemo.Font.Size := 10;
      FJsonMemo.Name := 'memoJSONContent';
      FJsonMemo.WordWrap := False;
      FJsonMemo.Text := '初始化JSON内容显示区域...';
      FJsonMemo.Visible := True;
      
      FJsonMemo.BringToFront;
      FJsonTab.Realign;
      
      AddDebugMessage('已创建JSON Memo控件');
    end;
    
    // 确保JSON标签页可见
    FJsonTab.TabVisible := True;
    FJsonTab.Visible := True;
    AddDebugMessage('设置JSON标签页为可见状态');
    
    // 强制处理消息队列，确保控件已正确创建和显示
    Application.ProcessMessages;
    
    // 在控制台中显示所有页面
    AddDebugMessage('当前所有标签页:');
    for i := 0 to pcEditors.PageCount - 1 do
      AddDebugMessage('  - 标签页 ' + IntToStr(i) + ': ' + pcEditors.Pages[i].Caption + 
                     ' (Visible=' + BoolToStr(pcEditors.Pages[i].Visible, True) + 
                     ', TabVisible=' + BoolToStr(pcEditors.Pages[i].TabVisible, True) + ')');
    
    // 添加调试消息
    AddDebugMessage('INI和JSON内容选项卡初始化完成');
  except
    on E: Exception do
      AddDebugMessage('初始化INI和JSON选项卡失败: ' + E.Message);
  end;
end;

procedure TViewMain.UpdateIniTabContent(const IniFilePath: string);
var
  Strings: TStrings;
begin
  try
    AddDebugMessage('开始更新INI内容选项卡: ' + IniFilePath);
    
    // 先确保选项卡和Memo已创建
    if not Assigned(FIniTab) or not Assigned(FIniMemo) then
    begin
      AddDebugMessage('INI控件未初始化，正在初始化...');
      InitializeIniJsonTabs;  // 初始化选项卡
      
      // 再次检查是否已成功创建
      if not Assigned(FIniTab) or not Assigned(FIniMemo) then
      begin
        AddDebugMessage('严重错误: 无法初始化INI内容选项卡或Memo控件');
        Exit;
      end;
    end;
    
    // 确保INI标签页可见
    AddDebugMessage('确保INI标签页可见');
    FIniTab.TabVisible := True;
    FIniTab.Visible := True;
    FIniMemo.Visible := True;
    
    // 检查INI文件是否存在
    if not FileExists(IniFilePath) then
    begin
      AddDebugMessage('警告: INI文件不存在: ' + IniFilePath);
      FIniMemo.Lines.Clear;
      FIniMemo.Lines.Add('INI文件不存在: ' + IniFilePath);
      pcEditors.ActivePage := FIniTab;  // 仍然激活选项卡以显示错误
      Application.ProcessMessages;
      Exit;
    end;
    
    // 创建临时字符串列表
    Strings := TStringList.Create;
    try
      // 读取INI文件内容
      AddDebugMessage('正在读取INI文件: ' + IniFilePath);
      try
        Strings.LoadFromFile(IniFilePath, TEncoding.UTF8);
        AddDebugMessage('已读取INI文件内容，行数: ' + IntToStr(Strings.Count));
      except
        on E: Exception do
        begin
          AddDebugMessage('读取INI文件失败: ' + E.Message);
          FIniMemo.Lines.Clear;
          FIniMemo.Lines.Add('无法读取INI文件: ' + E.Message);
          pcEditors.ActivePage := FIniTab;
          Application.ProcessMessages;
          Exit;
        end;
      end;
      
      // 更新Memo内容
      AddDebugMessage('更新INI内容到Memo控件...');
      FIniMemo.Lines.BeginUpdate;
      try
        FIniMemo.Lines.Clear;
        FIniMemo.Lines.AddStrings(Strings);
        AddDebugMessage('INI内容已添加到Memo，行数: ' + IntToStr(FIniMemo.Lines.Count));
      finally
        FIniMemo.Lines.EndUpdate;
      end;
      
      // 确保Memo可见并正确显示
      FIniMemo.SelStart := 0;  // 将光标定位到开头
      FIniMemo.Refresh;  // 刷新显示
      AddDebugMessage('INI Memo已刷新');
      
      // 激活INI选项卡并使其可见
      AddDebugMessage('激活INI选项卡');
      pcEditors.ActivePage := FIniTab;
      FIniTab.TabVisible := True;
      FIniTab.Show;
      
      // 强制更新UI
      Application.ProcessMessages;
      
      // 再次检查是否可见
      if not FIniTab.Visible then
      begin
        AddDebugMessage('警告: INI标签页仍然不可见，尝试强制显示');
        FIniTab.Visible := True;
        pcEditors.ActivePage := FIniTab;
        Application.ProcessMessages;
      end;
      
      // 添加调试消息
      AddDebugMessage('INI内容已更新完成: ' + IniFilePath + '，行数: ' + IntToStr(FIniMemo.Lines.Count));
    finally
      Strings.Free;
    end;
  except
    on E: Exception do
      AddDebugMessage('更新INI内容失败: ' + E.Message);
  end;
end;

procedure TViewMain.UpdateJsonTabContent(const JsonFilePath: string);
var
  Strings: TStrings;
begin
  try
    AddDebugMessage('开始更新JSON内容选项卡: ' + JsonFilePath);
    
    // 先确保选项卡和Memo已创建
    if not Assigned(FJsonTab) or not Assigned(FJsonMemo) then
    begin
      AddDebugMessage('JSON控件未初始化，正在初始化...');
      InitializeIniJsonTabs;  // 初始化选项卡
      
      // 再次检查是否已成功创建
      if not Assigned(FJsonTab) or not Assigned(FJsonMemo) then
      begin
        AddDebugMessage('严重错误: 无法初始化JSON内容选项卡或Memo控件');
        Exit;
      end;
    end;
    
    // 确保JSON标签页可见
    AddDebugMessage('确保JSON标签页可见');
    FJsonTab.TabVisible := True;
    FJsonTab.Visible := True;
    FJsonMemo.Visible := True;
    
    // 检查JSON文件是否存在
    if not FileExists(JsonFilePath) then
    begin
      AddDebugMessage('警告: JSON文件不存在: ' + JsonFilePath);
      FJsonMemo.Lines.Clear;
      FJsonMemo.Lines.Add('JSON文件不存在: ' + JsonFilePath);
      pcEditors.ActivePage := FJsonTab;  // 仍然激活选项卡以显示错误
      Application.ProcessMessages;
      Exit;
    end;
    
    // 创建临时字符串列表
    Strings := TStringList.Create;
    try
      // 读取JSON文件内容
      AddDebugMessage('正在读取JSON文件: ' + JsonFilePath);
      try
        Strings.LoadFromFile(JsonFilePath, TEncoding.UTF8);
        AddDebugMessage('已读取JSON文件内容，行数: ' + IntToStr(Strings.Count));
      except
        on E: Exception do
        begin
          AddDebugMessage('读取JSON文件失败: ' + E.Message);
          FJsonMemo.Lines.Clear;
          FJsonMemo.Lines.Add('无法读取JSON文件: ' + E.Message);
          pcEditors.ActivePage := FJsonTab;
          Application.ProcessMessages;
          Exit;
        end;
      end;
      
      // 更新Memo内容
      AddDebugMessage('更新JSON内容到Memo控件...');
      FJsonMemo.Lines.BeginUpdate;
      try
        FJsonMemo.Lines.Clear;
        FJsonMemo.Lines.AddStrings(Strings);
        AddDebugMessage('JSON内容已添加到Memo，行数: ' + IntToStr(FJsonMemo.Lines.Count));
      finally
        FJsonMemo.Lines.EndUpdate;
      end;
      
      // 确保Memo可见并正确显示
      FJsonMemo.SelStart := 0;  // 将光标定位到开头
      FJsonMemo.Refresh;  // 刷新显示
      AddDebugMessage('JSON Memo已刷新');
      
      // 激活JSON选项卡并使其可见
      AddDebugMessage('激活JSON选项卡');
      pcEditors.ActivePage := FJsonTab;
      FJsonTab.TabVisible := True;
      FJsonTab.Show;
      
      // 强制更新UI
      Application.ProcessMessages;
      
      // 再次检查是否可见
      if not FJsonTab.Visible then
      begin
        AddDebugMessage('警告: JSON标签页仍然不可见，尝试强制显示');
        FJsonTab.Visible := True;
        pcEditors.ActivePage := FJsonTab;
        Application.ProcessMessages;
      end;
      
      // 添加调试消息
      AddDebugMessage('JSON内容已更新完成: ' + JsonFilePath + '，行数: ' + IntToStr(FJsonMemo.Lines.Count));
    finally
      Strings.Free;
    end;
  except
    on E: Exception do
      AddDebugMessage('更新JSON内容失败: ' + E.Message);
  end;
end;

// 启用拖放功能
procedure TViewMain.EnableDragDrop;
begin
  try
    AddDebugMessage('正在启用拖放功能...');
    
    // 初始化拖放相关变量
    FIsDragging := False;
    FDragNode := nil;
    
    // 树视图已经支持拖放，无需强制设置保护属性
    if Assigned(tvConfig) then
    begin
      // 添加新的事件处理器
      tvConfig.OnDragOver := HandleTreeViewDragOver;
      tvConfig.OnDragDrop := HandleTreeViewDragDrop;
      tvConfig.OnMouseDown := HandleTreeViewMouseDown;
      AddDebugMessage('已启用树视图拖放功能');
    end;
    
    // 值列表编辑器也已经支持拖放，无需强制设置保护属性
    if Assigned(FValueListEditor) then
    begin
      // 添加新的事件处理器
      FValueListEditor.OnDragOver := HandleValueListEditorDragOver;
      FValueListEditor.OnDragDrop := HandleValueListEditorDragDrop;
      AddDebugMessage('已启用值列表编辑器拖放功能');
    end;
    
    AddDebugMessage('拖放功能启用完成');
  except
    on E: Exception do
      AddDebugMessage('启用拖放功能时出错: ' + E.Message);
  end;
end;

// 处理树视图鼠标按下事件
procedure TViewMain.HandleTreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HitTests: THitTests;
begin
  if Button = mbLeft then
  begin
    // 获取鼠标点击位置的节点
    FDragNode := tvConfig.GetNodeAt(X, Y);
    
    // 检查是否点击在有效节点上
    if Assigned(FDragNode) then
    begin
      HitTests := tvConfig.GetHitTestInfoAt(X, Y);
      if (htOnItem in HitTests) or (htOnIcon in HitTests) or (htOnLabel in HitTests) then
      begin
        // 开始拖拽操作
        FIsDragging := True;
        AddDebugMessage('开始拖拽节点: ' + FDragNode.Text);
      end;
    end;
  end;
end;

// 处理树视图拖动悬停事件
procedure TViewMain.HandleTreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // 允许从树视图到值列表编辑器的拖拽
  Accept := (Source = tvConfig) and FIsDragging and Assigned(FDragNode);
  
  if Accept then
    AddDebugMessage('拖拽悬停在树视图上: ' + FDragNode.Text);
end;

// 处理树视图拖放事件
procedure TViewMain.HandleTreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source = tvConfig) and FIsDragging and Assigned(FDragNode) then
  begin
    // 这里可以处理树内部的节点重排序等逻辑
    AddDebugMessage('树视图节点已拖放: ' + FDragNode.Text);
    
    // 拖放完成后重置状态
    FIsDragging := False;
    FDragNode := nil;
  end;
end;

// 处理值列表编辑器拖动悬停事件
procedure TViewMain.HandleValueListEditorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // 允许从树视图到值列表编辑器的拖拽
  Accept := (Source = tvConfig) and FIsDragging and Assigned(FDragNode);
  
  if Accept then
    AddDebugMessage('拖拽悬停在值列表编辑器上: ' + FDragNode.Text);
end;

// 处理值列表编辑器拖放事件
procedure TViewMain.HandleValueListEditorDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NodePath: string;
  Section, Key, Value: string;
  Row: Integer;
  Grid: TValueListEditor;
begin
  try
    if (Source = tvConfig) and FIsDragging and Assigned(FDragNode) and (Sender is TValueListEditor) then
    begin
      Grid := TValueListEditor(Sender);
      AddDebugMessage('配置节点拖放到值列表编辑器: ' + FDragNode.Text);
      
      // 获取节点路径，可用于构建完整的配置项标识
      NodePath := FDragNode.Text;
      if Assigned(FDragNode.Parent) then
        NodePath := FDragNode.Parent.Text + '.' + NodePath;
      
      // 确认要添加的配置项
      if MessageDlg('是否将配置项 "' + NodePath + '" 添加到当前列表?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // 示例：将节点添加为新的值条目
        // 实际应用中，可能需要从节点中提取实际的配置值
        Section := '[引用项]';
        Key := NodePath;
        Value := '_ref:' + NodePath;
        
        // 查找或添加节名称行
        Row := -1;
        for var i := 0 to Grid.RowCount - 1 do
        begin
          if i > 0 and Grid.Strings.Names[i-1] = Section then
          begin
            Row := i;
            break;
          end;
        end;
        
        if Row = -1 then
        begin
          // 节不存在，添加节
          Grid.Strings.Add(Section + '=');
          AddDebugMessage('添加新节: ' + Section);
        end;
        
        // 添加配置项
        Grid.Strings.Add(Key + '=' + Value);
        AddDebugMessage('添加配置项: ' + Key + '=' + Value);
        
        // 高亮显示新添加的行
        Grid.Row := Grid.RowCount - 1;
      end;
      
      // 拖放完成后重置状态
      FIsDragging := False;
      FDragNode := nil;
    end;
  except
    on E: Exception do
    begin
      AddDebugMessage('处理拖放操作时出错: ' + E.Message);
      FIsDragging := False;
      FDragNode := nil;
    end;
  end;
end;

procedure TViewMain.UpdateUIState(IsInvalid: Boolean = False);
begin
  // 更新UI状态的具体实现
  // 例如禁用或启用特定按钮
  if IsInvalid then
  begin
    // 如果状态无效，禁用一些功能按钮
    // 使用局部变量以避免编译错误
    var btnReloadLocal: TButton;
    for var i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TButton then
      begin
        if Self.Components[i].Name = 'btnSave' then
          TButton(Self.Components[i]).Enabled := False;
        if Self.Components[i].Name = 'btnReload' then
        begin
          btnReloadLocal := TButton(Self.Components[i]);
          btnReloadLocal.Enabled := False;
        end;
      end;
    end;
  end
  else
  begin
    // 正常状态，启用功能按钮
    var btnReloadLocal: TButton;
    for var i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TButton then
      begin
        if Self.Components[i].Name = 'btnSave' then
          TButton(Self.Components[i]).Enabled := True;
        if Self.Components[i].Name = 'btnReload' then
        begin
          btnReloadLocal := TButton(Self.Components[i]);
          btnReloadLocal.Enabled := True;
        end;
      end;
    end;
  end;
end;

procedure TViewMain.ClearEditor;
begin
  // 清空编辑器内容面板中的所有控件
  for var i := pnlClient.ControlCount - 1 downto 0 do
  begin
    pnlClient.Controls[i].Free;
  end;
end;

procedure TViewMain.ShowFolderInfo(const Path: string);
var
  FolderInfoLabel: TLabel;
begin
  // 清空现有内容
  ClearEditor;
  
  // 创建标签显示文件夹信息
  FolderInfoLabel := TLabel.Create(pnlClient);
  FolderInfoLabel.Parent := pnlClient;
  FolderInfoLabel.Align := alTop;
  FolderInfoLabel.Caption := '文件夹: ' + Path;
  FolderInfoLabel.Font.Size := 12;
  FolderInfoLabel.Font.Style := [fsBold];
  FolderInfoLabel.Margins.Top := 10;
  FolderInfoLabel.Margins.Left := 10;
  FolderInfoLabel.Height := 30;
end;

procedure TViewMain.ShowJSONEditor(const Path: string);
begin
  // 激活JSON编辑标签页
  pcEditors.ActivePage := FJsonTab;
  
  // 加载JSON文件到JSON编辑器
  UpdateJsonTabContent(Path);
end;

procedure TViewMain.ShowINIEditor(const Path: string);
begin
  // 激活INI编辑标签页
  pcEditors.ActivePage := FIniTab;
  
  // 加载INI文件到INI编辑器
  UpdateIniTabContent(Path);
end;

procedure TViewMain.ShowTextEditor(const Path: string);
var
  TextEditor: TMemo;
begin
  // 清空现有内容
  ClearEditor;
  
  // 创建文本编辑器
  TextEditor := TMemo.Create(pnlClient);
  TextEditor.Parent := pnlClient;
  TextEditor.Align := alClient;
  TextEditor.ScrollBars := ssBoth;
  TextEditor.WordWrap := False;
  
  // 加载文件内容
  try
    TextEditor.Lines.LoadFromFile(Path);
  except
    on E: Exception do
    begin
      TextEditor.Lines.Add('无法加载文件: ' + E.Message);
    end;
  end;
end;

procedure TViewMain.ShowError(const ErrorMessage: string);
var
  ErrorLabel: TLabel;
begin
  // 清空现有内容
  ClearEditor;
  
  // 创建错误信息标签
  ErrorLabel := TLabel.Create(pnlClient);
  ErrorLabel.Parent := pnlClient;
  ErrorLabel.Align := alTop;
  ErrorLabel.Caption := '错误: ' + ErrorMessage;
  ErrorLabel.Font.Color := clRed;
  ErrorLabel.Font.Size := 10;
  ErrorLabel.Margins.Top := 10;
  ErrorLabel.Margins.Left := 10;
  ErrorLabel.Height := 20;
end;

end. 