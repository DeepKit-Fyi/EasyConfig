unit ControllerIntf;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.ComCtrls, Vcl.Grids, 
  Vcl.ValEdit, System.Types;

type
  // 閰嶇疆椤甸潰淇℃伅
  TConfigPageInfo = record
    PageName: string;
    ConfigPath: string;
    ConfigType: string;
    Modified: Boolean;
  end;
  PConfigPageInfo = ^TConfigPageInfo;

  // 鎺у埗鍣ㄦ帴鍙?
  IMainController = interface
    ['{4A1C7D4E-8A5F-4B2D-9E81-F8F4E6A6E9F1}']
    procedure InitLists;
    procedure InitializeTree;
    procedure LoadAvailableThemes;
    procedure UpdateStatusBar;
    procedure HandleTreeNodeChange(Node: TTreeNode);
    procedure HandleTreeNodeDoubleClick;
    procedure OpenSelectedTreeNode;
    procedure CreateNewConfigObject;
    procedure DeleteSelectedTreeNode;
    procedure RenameSelectedTreeNode;
    procedure RefreshTreeView;
    procedure OpenConfigFile;
    procedure OpenSelectedFile(const Filename: string);
    procedure SaveCurrentConfig;
    procedure SaveConfigFileAs;
    procedure ReloadCurrentConfig;
    procedure ValidateCurrentConfig;
    procedure CloseCurrentTab;
    procedure HandleValueListDoubleClick(Sender: TObject);
    procedure ValidateValueListEntry(ACol, ARow: Integer; const KeyName, KeyValue: string);
    procedure ValidateValueListStrings;
    procedure DrawValueListCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure AddValueItem;
    procedure DeleteValueItem;
    procedure RenameValueItem;
    procedure SaveValueItems;
    procedure AddSection;
    procedure HandleTabChange;
    procedure ApplyTheme(const ThemeName: string);
    procedure ShowAboutDialog;
    function LoadConfigFile(const Filename: string): Boolean;
    procedure CreateNewConfigFile;
    function OpenSpecialEditor(const EditorType, ConfigPath: string): Boolean;
  end;

implementation

end. 