unit ViewIntf;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.ComCtrls, Vcl.Grids, 
  Vcl.Controls, Vcl.Dialogs, System.UITypes, Vcl.StdCtrls;

type
  // 为了兼容性，声明TValueListEditor
  TValueListEditor = class(TCustomDrawGrid)
  end;

  // 主窗口接口
  IMainForm = interface
    ['{5D06F9C4-8B36-4FD3-A2A1-A44A89CC88D8}']
    // 获取主窗口
    function GetFormHandle: TForm;
    
    // 获取页面控件
    function GetPageControl: TPageControl;
    
    // 获取树视图
    function GetTreeView: TTreeView;
    
    // 获取状态栏
    function GetStatusBar: TStatusBar;
    
    // 获取值列表编辑器
    function GetValueListEditor: TValueListEditor;
    
    // 获取编辑器内容面板
    function GetEditorContent: TWinControl;
    
    // 更新UI状态
    procedure UpdateUIState(IsInvalid: Boolean = False);
    
    // 清空编辑器内容
    procedure ClearEditor;
    
    // 显示文件夹信息
    procedure ShowFolderInfo(const Path: string);
    
    // 显示JSON编辑器
    procedure ShowJSONEditor(const Path: string);
    
    // 显示INI编辑器
    procedure ShowINIEditor(const Path: string);
    
    // 显示文本编辑器
    procedure ShowTextEditor(const Path: string);
    
    // 显示错误信息
    procedure ShowError(const ErrorMessage: string);
  end;

// 配置页面信息结构
type
  TConfigPageInfo = record
    PageName: string;      // 页面名称
    ConfigPath: string;    // 配置文件路径
    ConfigType: string;    // 配置类型
  end;

implementation

end. 