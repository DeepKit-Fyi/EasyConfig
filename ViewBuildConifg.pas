unit ViewBuildConifg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
  System.DateUtils, System.Generics.Collections;

type
  TEditorType = (etPlain, etFont, etColor, etDatabase, etList, etObject, etArray);

  TConfigPropertyItem = record
    PropertyName: string;
    PropertyType: string;
    PropertyValue: string;
    EditorType: TEditorType;
    PropertyPath: string;
  end;
  PConfigPropertyItem = ^TConfigPropertyItem;

  TViewBuildConfig = class(TFrame)
    pnlIni: TPanel;
    pnlJson: TPanel;
    pnlLeft: TPanel;
    pnlRigth: TPanel;
    pnlContent: TPanel;
    pnlBottom: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Panel1: TPanel;
    PageControl1: TPageControl;
    tsINI: TTabSheet;
    tsJSON: TTabSheet;
    sgINI: TStringGrid;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter5: TSplitter;
    tvJSON: TTreeView;
    pnlEditing: TPanel;
    edtEditing: TEdit;
    btnUpdate: TButton;
    tsEditor: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    btnSave: TButton;
    Panel4: TPanel;
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
    btnEditJSONProperty: TButton;
    btnRenameJSONProperty: TButton;
    btnDeleteJSONProperty: TButton;
    btnEditINIProperty: TButton;
    btnRenameINIProperty: TButton;
    btnDeleteINIProperty: TButton;
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
  private
    { Private declarations }
    FCurrentIniFile: string;
    FCurrentJsonFile: string;
    FCurrentEditingItem: TConfigPropertyItem;
    FIsEditing: Boolean;
    FCurrentJsonNode: TTreeNode;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure LoadConfigFiles(const IniFileName, JsonFileName: string);
    procedure SaveConfigFiles;
  end;

implementation

{$R 'ViewBuildConifg.dfm'}

constructor TViewBuildConfig.Create(AOwner: TComponent); 
begin
  inherited;
  // 创建时的初始化代码在这里
end;

destructor TViewBuildConfig.Destroy;
begin
  // 析构时的清理代码在这里
  inherited;
end;

procedure TViewBuildConfig.LoadConfigFiles(const IniFileName, JsonFileName: string);
begin
  // 加载配置文件的实现
end;

procedure TViewBuildConfig.SaveConfigFiles;
begin
  // 保存配置文件的实现
end;

procedure TViewBuildConfig.tvJSONChange(Sender: TObject; Node: TTreeNode);
begin
  // 实现树节点选择变化的处理
end;

procedure TViewBuildConfig.sgINISelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // 实现网格单元格选择的处理
end;

procedure TViewBuildConfig.sgINIDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  // 实现拖放的处理
end;

procedure TViewBuildConfig.sgINIDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // 实现拖放悬停的处理
end;

procedure TViewBuildConfig.tvJSONDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  // 实现树节点拖放的处理
end;

procedure TViewBuildConfig.tvJSONDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // 实现树节点拖放悬停的处理
end;

procedure TViewBuildConfig.btnAddTextClick(Sender: TObject);
begin
  // 添加文本属性的实现
end;

procedure TViewBuildConfig.btnAddNumberClick(Sender: TObject);
begin
  // 添加数字属性的实现
end;

procedure TViewBuildConfig.btnAddPathClick(Sender: TObject);
begin
  // 添加路径属性的实现
end;

procedure TViewBuildConfig.btnAddBooleanClick(Sender: TObject);
begin
  // 添加布尔属性的实现
end;

procedure TViewBuildConfig.btnAddDateClick(Sender: TObject);
begin
  // 添加日期属性的实现
end;

procedure TViewBuildConfig.btnAddColorClick(Sender: TObject);
begin
  // 添加颜色属性的实现
end;

procedure TViewBuildConfig.btnAddFontClick(Sender: TObject);
begin
  // 添加字体属性的实现
end;

procedure TViewBuildConfig.btnAddColorComplexClick(Sender: TObject);
begin
  // 添加复杂颜色属性的实现
end;

procedure TViewBuildConfig.btnAddDatabaseClick(Sender: TObject);
begin
  // 添加数据库属性的实现
end;

procedure TViewBuildConfig.btnAddListClick(Sender: TObject);
begin
  // 添加列表属性的实现
end;

procedure TViewBuildConfig.btnAddObjectClick(Sender: TObject);
begin
  // 添加对象属性的实现
end;

procedure TViewBuildConfig.btnAddArrayClick(Sender: TObject);
begin
  // 添加数组属性的实现
end;

procedure TViewBuildConfig.EditINIPropertyClick(Sender: TObject);
begin
  // 编辑INI属性的实现
end;

procedure TViewBuildConfig.RenameINIPropertyClick(Sender: TObject);
begin
  // 重命名INI属性的实现
end;

procedure TViewBuildConfig.DeleteINIPropertyClick(Sender: TObject);
begin
  // 删除INI属性的实现
end;

procedure TViewBuildConfig.EditJSONPropertyClick(Sender: TObject);
begin
  // 编辑JSON属性的实现
end;

procedure TViewBuildConfig.RenameJSONPropertyClick(Sender: TObject);
begin
  // 重命名JSON属性的实现
end;

procedure TViewBuildConfig.DeleteJSONPropertyClick(Sender: TObject);
begin
  // 删除JSON属性的实现
end;

procedure TViewBuildConfig.btnUpdateClick(Sender: TObject);
begin
  // 更新按钮点击的实现
end;

procedure TViewBuildConfig.btnSaveClick(Sender: TObject);
begin
  // 保存按钮点击的实现
end;

procedure TViewBuildConfig.btnCloseClick(Sender: TObject);
begin
  // 关闭按钮点击的实现
end;

procedure TViewBuildConfig.btnOpenConfigClick(Sender: TObject);
begin
  // 打开配置按钮点击的实现
end;

procedure TViewBuildConfig.sgINIDblClick(Sender: TObject);
begin
  // 处理网格双击事件
end;

procedure TViewBuildConfig.tvJSONDblClick(Sender: TObject);
begin
  // 处理树节点双击事件
end;

end.
