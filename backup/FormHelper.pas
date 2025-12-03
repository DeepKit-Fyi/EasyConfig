unit FormHelper;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, Vcl.StdCtrls, Vcl.Controls, 
  Vcl.Forms, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.FileCtrl, System.Skia, Vcl.Skia,
  ConfigManager, System.IniFiles, Vcl.Themes, Vcl.Styles, Vcl.Dialogs;

// 初始化配置目录的函数
procedure InitConfigDirectory(DebugMemo: TMemo = nil);

// 初始化SVG按钮图标和提示
procedure InitSvgButtons(Form: TForm);

// 初始化配置管理器
function InitConfigManager(const ConfigPath: string; DebugMemo: TMemo): TConfigManager;

// 初始化文件列表框
procedure InitFileListBox(FileListBox: TFileListBox; const Directory: string);

// 向调试备忘录添加文本，确保正确编码
procedure AddDebugText(DebugMemo: TMemo; const Text: string);

// 加载应用程序设置
procedure LoadApplicationSettings(Form: TForm; DebugMemo: TMemo);

// 创建默认配置文件
procedure CreateDefaultConfigFile(const FileName: string);

// 保存应用程序设置
procedure SaveApplicationSettings(Form: TForm; DebugMemo: TMemo);

// 设置应用程序主题和样式
procedure SetApplicationStyle(const StyleName: string = ''; DebugMemo: TMemo = nil);

implementation

procedure InitConfigDirectory(DebugMemo: TMemo = nil);
begin
  // 确保config目录存在，但不创建新目录
  // 只检查目录是否存在，记录错误
  if not DirectoryExists('config') then
  begin
    if DebugMemo <> nil then
      AddDebugText(DebugMemo, '警告：配置目录不存在：config，请确保该目录存在于应用程序根目录下。');
    ShowMessage('配置目录不存在：config，请确保该目录存在于应用程序根目录下。');
  end;
end;

procedure InitSvgButtons(Form: TForm);
var
  i: Integer;
  Component: TComponent;
  SvgButton: TSkSvg;
  DebugMemo: TMemo;
  SvgContent: string;
  SvgPath: string;
  ExePath, IdePath: string;
begin
  DebugMemo := nil;
  
  // 查找调试备忘录组件
  for i := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i] is TMemo then
    begin
      if Form.Components[i].Name = 'meoDebug' then
      begin
        DebugMemo := TMemo(Form.Components[i]);
        Break;
      end;
    end;
  end;
  
  // 记录调试信息
  if DebugMemo <> nil then
    AddDebugText(DebugMemo, '开始加载SVG图标...');
  
  // 获取可能的路径
  ExePath := ExtractFilePath(ParamStr(0)) + 'assets\';  // 应用程序路径
  IdePath := GetCurrentDir + '\assets\';                // IDE路径
  
  // 选择存在的路径
  if DirectoryExists(ExePath) then
    SvgPath := ExePath
  else if DirectoryExists(IdePath) then
    SvgPath := IdePath
  else
    SvgPath := 'assets\';  // 最后尝试相对路径
  
  // 记录路径信息
  if DebugMemo <> nil then
  begin
    AddDebugText(DebugMemo, '当前目录: ' + GetCurrentDir);
    AddDebugText(DebugMemo, '程序路径: ' + ExePath);
    AddDebugText(DebugMemo, 'IDE路径: ' + IdePath);
    AddDebugText(DebugMemo, '选择的SVG路径: ' + SvgPath);
    
    if DirectoryExists(SvgPath) then
      AddDebugText(DebugMemo, 'SVG目录存在')
    else
      AddDebugText(DebugMemo, '警告: SVG目录不存在!');
  end;
  
  // 遍历窗体中的所有组件
  for i := 0 to Form.ComponentCount - 1 do
  begin
    Component := Form.Components[i];
    
    // 检查是否为TSkSvg类型的组件
    if Component is TSkSvg then
    begin
      SvgButton := TSkSvg(Component);
      
      if DebugMemo <> nil then
        AddDebugText(DebugMemo, '处理SVG按钮: ' + SvgButton.Name);
      
      // 设置提示信息并加载SVG图标
      try
        // 确保设置基本属性
        SvgButton.ShowHint := True;
        
        // 详细记录SVG按钮的属性
        if DebugMemo <> nil then
        begin
          AddDebugText(DebugMemo, '  - 按钮尺寸: ' + IntToStr(SvgButton.Width) + 'x' + IntToStr(SvgButton.Height));
          AddDebugText(DebugMemo, '  - 可见性: ' + BoolToStr(SvgButton.Visible, True));
          AddDebugText(DebugMemo, '  - 启用状态: ' + BoolToStr(SvgButton.Enabled, True));
        end;
        
        // 为每个按钮设置提示并加载SVG
        if SvgButton.Name = 'btnSvgOpen' then
        begin
          SvgButton.Hint := '打开配置文件';
          if FileExists(SvgPath + 'open.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'open.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
            begin
              AddDebugText(DebugMemo, '成功加载open.svg, 大小: ' + IntToStr(Length(SvgContent)));
              AddDebugText(DebugMemo, '  - Svg.Source长度: ' + IntToStr(Length(SvgButton.Svg.Source)));
              AddDebugText(DebugMemo, '  - Svg内容前50字符: ' + Copy(SvgContent, 1, 50) + '...');
            end;
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '错误: 文件不存在 ' + SvgPath + 'open.svg');
        end
        else if SvgButton.Name = 'btnSvgSave' then
        begin
          SvgButton.Hint := '保存配置文件';
          if FileExists(SvgPath + 'save.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'save.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载save.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'save.svg');
        end
        else if SvgButton.Name = 'btnSvgSaveAs' then
        begin
          SvgButton.Hint := '另存为';
          if FileExists(SvgPath + 'saveas.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'saveas.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载saveas.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'saveas.svg');
        end
        else if SvgButton.Name = 'btnSvgDelete' then
        begin
          SvgButton.Hint := '删除配置文件';
          if FileExists(SvgPath + 'delete.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'delete.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载delete.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'delete.svg');
        end
        else if SvgButton.Name = 'btnSvgNewNode' then
        begin
          SvgButton.Hint := '新建节点';
          if FileExists(SvgPath + 'new.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'new.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载new.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'new.svg');
        end
        else if SvgButton.Name = 'btnSvgEditNode' then
        begin
          SvgButton.Hint := '编辑节点';
          if FileExists(SvgPath + 'edit.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'edit.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载edit.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'edit.svg');
        end
        else if SvgButton.Name = 'btnSvgRemoveNode' then
        begin
          SvgButton.Hint := '删除节点';
          if FileExists(SvgPath + 'remove.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'remove.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载remove.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'remove.svg');
        end
        else if SvgButton.Name = 'btnSvgRefresh' then
        begin
          SvgButton.Hint := '刷新';
          if FileExists(SvgPath + 'refresh.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'refresh.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载refresh.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'refresh.svg');
        end
        else if SvgButton.Name = 'btnSvgExit' then
        begin
          SvgButton.Hint := '退出系统';
          if FileExists(SvgPath + 'exit.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'exit.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载exit.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'exit.svg');
        end
        else if SvgButton.Name = 'btnSvgToggle' then
        begin
          SvgButton.Hint := '显示/隐藏空分类';
          if FileExists(SvgPath + 'toggle.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'toggle.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载toggle.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'toggle.svg');
        end
        else if SvgButton.Name = 'btnSvgExpandCollapse' then
        begin
          SvgButton.Hint := '全部展开/收缩';
          if FileExists(SvgPath + 'expand.svg') then
          begin
            SvgContent := TFile.ReadAllText(SvgPath + 'expand.svg');
            SvgButton.Svg.Source := SvgContent;
            
            if DebugMemo <> nil then
              AddDebugText(DebugMemo, '加载expand.svg成功，内容长度: ' + IntToStr(Length(SvgContent)));
          end
          else if DebugMemo <> nil then
            AddDebugText(DebugMemo, '文件不存在: ' + SvgPath + 'expand.svg');
        end;
        
        // 启用提示显示
        SvgButton.ShowHint := True;
      except
        on E: Exception do
        begin
          if DebugMemo <> nil then
            AddDebugText(DebugMemo, '加载SVG图标出错 [' + SvgButton.Name + ']: ' + E.Message);
        end;
      end;
    end;
  end;
  
  if DebugMemo <> nil then
    AddDebugText(DebugMemo, 'SVG图标加载完成.');
end;

function InitConfigManager(const ConfigPath: string; DebugMemo: TMemo): TConfigManager;
begin
  Result := TConfigManager.Create('config');
  
  // 初始化配置管理器
  try
    Result.Initialize(ConfigPath);
    if DebugMemo <> nil then
      AddDebugText(DebugMemo, '配置管理器初始化成功: ' + ConfigPath);
  except
    on E: Exception do
    begin
      if DebugMemo <> nil then
        AddDebugText(DebugMemo, '无法初始化配置管理器: ' + E.Message + '。将使用默认配置。');
    end;
  end;
end;

procedure InitFileListBox(FileListBox: TFileListBox; const Directory: string);
var
  DebugMemo: TMemo;
  i: Integer;
begin
  if FileListBox <> nil then
  begin
    try
      // 查找调试备忘录组件
      DebugMemo := nil;
      for i := 0 to Screen.Forms[0].ComponentCount - 1 do
      begin
        if Screen.Forms[0].Components[i] is TMemo then
        begin
          if Screen.Forms[0].Components[i].Name = 'meoDebug' then
          begin
            DebugMemo := TMemo(Screen.Forms[0].Components[i]);
            Break;
          end;
        end;
      end;
      
      // 确保目录存在
      if not DirectoryExists(Directory) then
      begin
        ForceDirectories(Directory);
        if DebugMemo <> nil then
          AddDebugText(DebugMemo, '创建目录: ' + Directory);
      end;
      
      // 设置目录并更新文件列表
      FileListBox.Directory := Directory;
      FileListBox.Mask := '*.ini;*.json';  // 只显示INI和JSON文件
      FileListBox.Update;
      
      if DebugMemo <> nil then
        AddDebugText(DebugMemo, '文件列表初始化完成: ' + Directory);
    except
      on E: Exception do
      begin
        if DebugMemo <> nil then
          AddDebugText(DebugMemo, '文件列表初始化出错: ' + E.Message);
      end;
    end;
  end;
end;

// 向调试备忘录添加文本，确保正确编码
procedure AddDebugText(DebugMemo: TMemo; const Text: string);
begin
  if DebugMemo <> nil then
  begin
    DebugMemo.Lines.Add(Text);
    // 确保立即更新显示
    DebugMemo.Update;
    Application.ProcessMessages;
  end;
end;

// 加载应用程序设置
procedure LoadApplicationSettings(Form: TForm; DebugMemo: TMemo);
var
  IniFile: TMemIniFile;
  ConfigPath: string;
  i: Integer;
  Component: TComponent;
  Splitter: TSplitter;
  Panel: TPanel;
  TreeView: TTreeView;
  FileListBox: TFileListBox;
  Editor: TMemo;
  StyleName: string;
begin
  if Form = nil then
    Exit;
    
  ConfigPath := GetCurrentDir + '\config\start.ini';
  
  // 确保配置目录存在
  if not DirectoryExists(ExtractFilePath(ConfigPath)) then
    ForceDirectories(ExtractFilePath(ConfigPath));
    
  // 如果配置文件不存在，则创建默认配置文件
  if not FileExists(ConfigPath) then
  begin
    CreateDefaultConfigFile(ConfigPath);
    AddDebugText(DebugMemo, '创建默认配置文件: ' + ConfigPath);
  end;
  
  try
    // 使用TMemIniFile而不是TIniFile，并且设置编码为UTF-8
    IniFile := TMemIniFile.Create(ConfigPath, TEncoding.UTF8);
    try
      AddDebugText(DebugMemo, '正在加载应用程序设置...');
      
      // 读取并应用样式
      StyleName := IniFile.ReadString('General', 'StyleName', 'Windows');
      SetApplicationStyle(StyleName, DebugMemo);
      
      // 读取窗体位置和大小
      case IniFile.ReadInteger('General', 'WindowState', 0) of
        0: Form.WindowState := wsNormal;
        1: Form.WindowState := wsMinimized;
        2: Form.WindowState := wsMaximized;
      end;
      
      if Form.WindowState = wsNormal then
      begin
        Form.Left := IniFile.ReadInteger('General', 'WindowLeft', 100);
        Form.Top := IniFile.ReadInteger('General', 'WindowTop', 100);
        Form.Width := IniFile.ReadInteger('General', 'WindowWidth', 980);
        Form.Height := IniFile.ReadInteger('General', 'WindowHeight', 650);
      end;
      
      // 读取面板设置
      for i := 0 to Form.ComponentCount - 1 do
      begin
        if Form.Components[i] is TPanel then
        begin
          Panel := TPanel(Form.Components[i]);
          
          if Panel.Name = 'pnlLeft' then
            Panel.Width := IniFile.ReadInteger('General', 'LeftPanelWidth', Panel.Width)
          else if Panel.Name = 'pnlRight' then
            Panel.Width := IniFile.ReadInteger('General', 'RightPanelWidth', Panel.Width);
        end;
        
        // 读取FileListBox高度
        if Form.Components[i] is TFileListBox then
        begin
          FileListBox := TFileListBox(Form.Components[i]);
          if FileListBox.Name = 'FileListBox1' then
            FileListBox.Height := IniFile.ReadInteger('General', 'FileListHeight', FileListBox.Height);
        end;
        
        // 读取编辑器设置
        if Form.Components[i] is TMemo then
        begin
          Editor := TMemo(Form.Components[i]);
          
          if Editor.Name = 'meoDebug' then
            Editor.Height := IniFile.ReadInteger('General', 'DebugPanelHeight', Editor.Height)
          else
          begin
            // 一般编辑器设置，应用到所有编辑器
            Editor.Font.Name := IniFile.ReadString('Editor', 'EditorFontName', Editor.Font.Name);
            Editor.Font.Size := IniFile.ReadInteger('Editor', 'EditorFontSize', Editor.Font.Size);
            Editor.WordWrap := IniFile.ReadBool('Editor', 'EditorWordWrap', Editor.WordWrap);
          end;
        end;
      end;
      
      // 读取历史记录
      // 历史记录会在用户操作时管理，这里只是初始化
      
      // 读取备份设置
      if not DirectoryExists(IniFile.ReadString('Backup', 'BackupPath', '.\backup')) then
        ForceDirectories(IniFile.ReadString('Backup', 'BackupPath', '.\backup'));
        
      AddDebugText(DebugMemo, '应用程序设置加载完成');
    finally
      IniFile.Free;
    end;
  except
    on E: Exception do
    begin
      AddDebugText(DebugMemo, '加载设置时出错: ' + E.Message);
    end;
  end;
end;

// 创建默认配置文件
procedure CreateDefaultConfigFile(const FileName: string);
var
  IniFile: TMemIniFile;
  FS: TFileStream;
  Preamble: TBytes;
begin
  // 创建UTF-8 文件流，带BOM
  FS := TFileStream.Create(FileName, fmCreate);
  try
    // 写入UTF-8 BOM
    Preamble := TEncoding.UTF8.GetPreamble;
    if Length(Preamble) > 0 then
      FS.WriteBuffer(Preamble[0], Length(Preamble));
  finally
    FS.Free;
  end;
  
  // 添加默认设置
  IniFile := TMemIniFile.Create(FileName, TEncoding.UTF8);
  try
    // 添加一般设置
    IniFile.WriteString('General', 'Version', '1.0');
    IniFile.WriteString('General', 'Language', 'zh-CN');
    IniFile.WriteString('General', 'StyleName', 'Windows'); // 使用默认Windows样式
    IniFile.WriteInteger('General', 'WindowState', 0);
    IniFile.WriteInteger('General', 'WindowLeft', 100);
    IniFile.WriteInteger('General', 'WindowTop', 100);
    IniFile.WriteInteger('General', 'WindowWidth', 980);
    IniFile.WriteInteger('General', 'WindowHeight', 650);
    IniFile.WriteInteger('General', 'LeftPanelWidth', 250);
    IniFile.WriteInteger('General', 'RightPanelWidth', 240);
    IniFile.WriteInteger('General', 'FileListHeight', 100);
    IniFile.WriteInteger('General', 'DebugPanelHeight', 250);
    
    // 添加编辑器设置
    IniFile.WriteString('Editor', 'EditorFontName', 'Consolas');
    IniFile.WriteInteger('Editor', 'EditorFontSize', 10);
    IniFile.WriteBool('Editor', 'EditorWordWrap', False);
    IniFile.WriteBool('Editor', 'EditorAutoIndent', True);
    
    // 添加备份设置
    IniFile.WriteString('Backup', 'BackupPath', '.\backup');
    IniFile.WriteBool('Backup', 'EnableBackup', True);
    IniFile.WriteInteger('Backup', 'BackupInterval', 5);  // 分钟
    
    // 添加文件设置
    IniFile.WriteBool('File', 'AutoSave', False);
    IniFile.WriteInteger('File', 'AutoSaveInterval', 5);  // 分钟
    IniFile.WriteString('File', 'DefaultFormat', 'ini');  // ini 或 json
    
    // 保存到文件
    IniFile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

// 保存应用程序设置
procedure SaveApplicationSettings(Form: TForm; DebugMemo: TMemo);
var
  IniFile: TMemIniFile;
  ConfigPath: string;
  i, j: Integer;  // 添加j变量用于嵌套循环
  WindowState: Integer;
  Component: TComponent;
  Splitter: TSplitter;
  Panel: TPanel;
  TreeView: TTreeView;
  FileListBox: TFileListBox;
  PageControl: TPageControl;
  RecentFiles: TStringList;
begin
  if Form = nil then
    Exit;
    
  ConfigPath := GetCurrentDir + '\config\start.ini';
  
  try
    // 使用TMemIniFile而不是TIniFile，并且设置编码为UTF-8
    IniFile := TMemIniFile.Create(ConfigPath, TEncoding.UTF8);
    try
      AddDebugText(DebugMemo, '正在保存应用程序设置...');
      
      // 保存[General]部分
      IniFile.WriteString('General', 'Version', '1.0');
      IniFile.WriteString('General', 'Language', 'zh-CN');
      IniFile.WriteString('General', 'DefaultConfigPath', 'config');
      IniFile.WriteBool('General', 'FirstRun', False);
      
      // 保存窗体大小和位置
      WindowState := 0; // wsNormal
      if Form.WindowState = wsMaximized then
        WindowState := 2
      else if Form.WindowState = wsMinimized then
        WindowState := 1;
        
      IniFile.WriteInteger('General', 'WindowState', WindowState);
      
      if Form.WindowState = wsNormal then
      begin
        IniFile.WriteInteger('General', 'WindowLeft', Form.Left);
        IniFile.WriteInteger('General', 'WindowTop', Form.Top);
        IniFile.WriteInteger('General', 'WindowWidth', Form.Width);
        IniFile.WriteInteger('General', 'WindowHeight', Form.Height);
      end;
      
      // 保存左右面板分割比例
      for i := 0 to Form.ComponentCount - 1 do
      begin
        if Form.Components[i] is TPanel then
        begin
          Panel := TPanel(Form.Components[i]);
          
          if Panel.Name = 'pnlLeft' then
            IniFile.WriteInteger('General', 'LeftPanelWidth', Panel.Width)
          else if Panel.Name = 'pnlRight' then
            IniFile.WriteInteger('General', 'RightPanelWidth', Panel.Width);
        end;
        
        // 保存FileListBox高度
        if Form.Components[i] is TFileListBox then
        begin
          FileListBox := TFileListBox(Form.Components[i]);
          if FileListBox.Name = 'FileListBox1' then
            IniFile.WriteInteger('General', 'FileListHeight', FileListBox.Height);
        end;
        
        // 保存调试区域高度
        if Form.Components[i] is TMemo then
        begin
          if Form.Components[i].Name = 'meoDebug' then
            IniFile.WriteInteger('General', 'DebugPanelHeight', TMemo(Form.Components[i]).Height);
        end;
        
        // 保存编辑器设置 - 这里通常在程序中统一设置，而不是针对特定实例保存
        // PageControl可能有多个页面，每个页面都有编辑器
        if Form.Components[i] is TPageControl then
        begin
          PageControl := TPageControl(Form.Components[i]);
          if PageControl.PageCount > 0 then
          begin
            // 保存最后打开的文件信息
            RecentFiles := TStringList.Create;
            try
              // 最多保存5个最近文件
              for j := 0 to PageControl.PageCount - 1 do
              begin
                if j >= 5 then
                  break;
                
                // 这里需要获取页面关联的文件路径
                // 实际代码需要根据您的页面数据结构来获取
                // RecentFiles.Add(...);
              end;
              
              IniFile.WriteInteger('History', 'RecentFiles', RecentFiles.Count);
              for j := 0 to RecentFiles.Count - 1 do
              begin
                IniFile.WriteString('History', 'RecentFile' + IntToStr(j+1), RecentFiles[j]);
              end;
            finally
              RecentFiles.Free;
            end;
          end;
        end;
      end;
      
      // 保存标准的编辑器设置
      IniFile.WriteString('Editor', 'EditorFontName', 'Consolas');
      IniFile.WriteInteger('Editor', 'EditorFontSize', 10);
      IniFile.WriteBool('Editor', 'EditorWordWrap', False);
      IniFile.WriteInteger('Editor', 'TabWidth', 4);
      IniFile.WriteBool('Editor', 'UseSpaces', True);
      IniFile.WriteBool('Editor', 'AutoIndent', True);
      IniFile.WriteBool('Editor', 'SyntaxHighlight', True);
      
      // 保存备份设置
      IniFile.WriteBool('Backup', 'EnableAutoBackup', True);
      IniFile.WriteString('Backup', 'BackupPath', '.\backup');
      IniFile.WriteInteger('Backup', 'BackupInterval', 10);
      IniFile.WriteInteger('Backup', 'MaxBackupFiles', 5);
      IniFile.WriteBool('Backup', 'CreateBackupBeforeEdit', True);
      
      // 保存文件选项
      IniFile.WriteString('FileOptions', 'DefaultFileType', 'INI');
      IniFile.WriteBool('FileOptions', 'OpenFileOnDblClick', True);
      IniFile.WriteBool('FileOptions', 'AutoSave', False);
      IniFile.WriteInteger('FileOptions', 'AutoSaveInterval', 5);
      IniFile.WriteBool('FileOptions', 'AutoReload', False);
      
      // 保存工具栏设置
      IniFile.WriteBool('ToolbarSettings', 'ShowLabels', False);
      IniFile.WriteBool('ToolbarSettings', 'LargeIcons', True);
      IniFile.WriteString('ToolbarSettings', 'ButtonsOrder', 'Refresh,Open,Save,SaveAs,Delete,NewNode,EditNode,RemoveNode,Exit');
      
      // 确保更改写入文件
      IniFile.UpdateFile;
      
      AddDebugText(DebugMemo, '应用程序设置保存完成');
    finally
      IniFile.Free;
    end;
  except
    on E: Exception do
    begin
      AddDebugText(DebugMemo, '保存设置时出错: ' + E.Message);
    end;
  end;
end;

// 设置应用程序主题和样式
procedure SetApplicationStyle(const StyleName: string = ''; DebugMemo: TMemo = nil);
var
  AvailableStyle: string;
  i: Integer;
begin
  // 如果未提供样式名称或样式名称为"Default"，则使用默认样式
  if (StyleName = '') or (StyleName = 'Default') then
  begin
    if Assigned(DebugMemo) then
      AddDebugText(DebugMemo, '使用系统默认样式');
    TStyleManager.TrySetStyle('Windows');
    Exit;
  end;
  
  // 检查请求的样式是否可用
  for i := 0 to High(TStyleManager.StyleNames) do
  begin
    AvailableStyle := TStyleManager.StyleNames[i];
    if SameText(AvailableStyle, StyleName) then
    begin
      try
        if Assigned(DebugMemo) then
          AddDebugText(DebugMemo, '应用样式: ' + StyleName);
        TStyleManager.TrySetStyle(StyleName);
        Exit;
      except
        on E: Exception do
        begin
          if Assigned(DebugMemo) then
            AddDebugText(DebugMemo, '设置样式"' + StyleName + '"出错: ' + E.Message);
          // 使用默认样式
          TStyleManager.TrySetStyle('Windows');
        end;
      end;
    end;
  end;
  
  // 如果请求的样式不可用，记录一条消息并使用默认样式
  if Assigned(DebugMemo) then
  begin
    AddDebugText(DebugMemo, '警告: 请求的样式"' + StyleName + '"不可用');
    AddDebugText(DebugMemo, '可用样式:');
    for i := 0 to High(TStyleManager.StyleNames) do
      AddDebugText(DebugMemo, ' - ' + TStyleManager.StyleNames[i]);
  end;
  
  // 使用默认Windows样式
  TStyleManager.TrySetStyle('Windows');
end;

end. 