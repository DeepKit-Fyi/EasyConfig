unit ViewBuildConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
  System.DateUtils, System.Generics.Collections, ControllerIntf, ModelConfig,
  ValidationDialog, FrameDBEditor, FrameListEditor,
  FrameArrayEditor, System.IOUtils, FrameFontEditor, FrameAIAPIEditor,
  UtilsTypes, ControllerConfigs, JSONHelpers, ConfigValidator;interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.Menus, System.UITypes, System.StrUtils,
  System.JSON, System.IniFiles, Vcl.Buttons, Vcl.ExtDlgs, System.Types,
  System.DateUtils, System.Generics.Collections, ControllerIntf, ModelConfig,
  ValidationDialog, FrameDBEditor, FrameListEditor,
  FrameArrayEditor, System.IOUtils, FrameFontEditor, FrameAIAPIEditor,
  UtilsTypes, ControllerConfigs, JSONHelpers, ConfigValidator;

type
  TSimplePropertyType = (
    sptText,     // 文本
    sptNumber,   // 数字
    sptRelPath,  // 相对路径
    sptBoolean,  // 布尔??
    sptDate,     // 日期
    sptColor,    // 颜色
    sptTime,     // 时间
    sptFileName, // 文件??
    sptFilePath, // 目录+文件
    sptAbsPath,  // 绝对路径
    sptIPAddress // IP地址
  );

  TFrmBuildConfig = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    pnlIni: TPanel;
    pnlJson: TPanel;
    flpIni: TFlowPanel;
    flpJson: TFlowPanel;
    pnlLeft: TPanel;
    pnlRigth: TPanel;
    pnlContent: TPanel;
    PageControl1: TPageControl;
    tsINI: TTabSheet;
    tsJSON: TTabSheet;
    tsEditor: TTabSheet;
    pnlattribute: TPanel;
    pnlEditing: TPanel;
    edtEditing: TEdit;
    btnUpdate: TButton;
    MeoINI: TMemo;
    MeoJSON: TMemo;
    Panel4: TPanel;
    btnSave: TButton;
    pnlBottom: TPanel;
    btnClose: TButton;
    btnOpenConfig: TButton;
    btnValidate: TButton;
    btnAddText: TButton;
    btnAddNumber: TButton;
    btnRootPath: TButton;
    btnAddBoolean: TButton;
    btnAddDate: TButton;
    btnAddColor: TButton;
    btnAddFont: TButton;
    btnAddColorComplex: TButton;
    btnAddDatabase: TButton;
    btnAddList: TButton;
    btnAddObject: TButton;
    btnAddArray: TButton;
    btnAddAPI: TButton;
    btnAddRootNode: TButton;
    btnAddJsonSecurity: TButton;
    btnAddJsonAI: TButton;
    btnAddJsonModule: TButton;
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
    btnAbsPath: TButton;
    btnSection: TButton;
    btnEmptyLine: TButton;
    pcAttribute: TPageControl;
    tsINIGrid: TTabSheet;
    sgINI: TStringGrid;
    tsJSONTree: TTabSheet;
    Splitter5: TSplitter;
    tvJSON: TTreeView;
    btnRePath: TButton;
    btnSaveConfig: TButton;
    cbFileName: TComboBox;
    btnDeleteConfig: TButton;
    btnNewConfig: TButton;
    btnList: TButton;
    btnKey: TButton;
    btnReg: TButton;
    btnEMail: TButton;
    btnUrl: TButton;
    btnAddDateTimeRange: TButton;
    btnAddKeyValueDict: TButton;
    btnAddUrlConfig: TButton;
    btnAddPermission: TButton;
    btnAddNetConfig: TButton;
    btnAddEncrypt: TButton;
    btnAddGeoLocation: TButton;
    btnAddMediaSettings: TButton;
    btnAddChartConfig: TButton;
    btnAddWorkflow: TButton;
    btnAddSchedule: TButton;
    btnAddI18n: TButton;
    btnAddUnitConversion: TButton;
    btnAddVersionControl: TButton;
    btnAddBgDraw: TButton;
    btnAddTextOnBg: TButton;
    btnAddImageOnBg: TButton;
    btnAddCaptionOnBg: TButton;
    btnAddVideoClip: TButton;
    btnAddVideo: TButton;
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
    procedure btnValidateClick(Sender: TObject);
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
    // 添加属性点击事??
    procedure btnAddSectionClick(Sender: TObject);
    // 添加空行点击事件
    procedure btnAddEmptyLineClick(Sender: TObject);
    // 添加根路径按钮点击事??
    procedure btnRootPathClick(Sender: TObject);
    // 添加文件名按钮点击事??
    procedure btnFileNameClick(Sender: TObject);
    // 添加绝对路径按钮点击事件
    procedure btnAbsPathClick(Sender: TObject);
    // 添加相对路径按钮点击事件
    procedure btnRePathClick(Sender: TObject);
    // interface 方法
    procedure pcAttributeChange(Sender: TObject);
    procedure btnEmptyLineClick(Sender: TObject);
    procedure btnReFileNameClick(Sender: TObject);
    procedure btnAbsFilenameClick(Sender: TObject);
    procedure btnSectionClick(Sender: TObject);
    // 添加保存配置按钮点击事件
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnNewConfigClick(Sender: TObject);
    procedure btnDeleteConfigClick(Sender: TObject);
    procedure cbFileNameChange(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    // 添加键值对按钮点击事件
    procedure btnKeyClick(Sender: TObject);
    procedure btnRegClick(Sender: TObject);
    procedure btnEMailClick(Sender: TObject);
    procedure btnUrlClick(Sender: TObject);
    procedure showConfigByTag(Sender: TObject);
  private
    FCurrentIniFile: string;
    FCurrentJsonFile: string;
    FIsEditing: Boolean;
    FCurrentJsonNode: TTreeNode;
    FCurrentEditNode: TTreeNode; // 当前编辑的JSON节点
    FCurrentEditor: TFrame;      // 当前使用的编辑Frame
    FConfigListFile: string;     // 配置列表文件路径

    // 全局的StringGrid单元格数??
    function GetGridCell(ACol, ARow: Integer): string;
    procedure SetGridCell(ACol, ARow: Integer; const Value: string);
    function IsGridCellEmpty(ACol, ARow: Integer): Boolean;

    procedure InitializeFrame;
    procedure InitializeButtons;
    procedure InitializePopupMenus;
    procedure InitializeDragDrop;
    procedure ReorganizeButtons;

    procedure AddPropertyToGrid(const PropertyName, PropertyType, PropertyValue: string);
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

    function ValidateConfig: Boolean;
    function ValidateINIProperty(const Section, Key, Value: string): Boolean;
    procedure ShowValidationResults;

    // 数据库编辑的回调
    procedure OnDBSave(Sender: TObject);
    procedure OnDBCancel(Sender: TObject);

    procedure ShowEditorForNode(Node: TTreeNode);
    procedure EditorSaveClick(Sender: TObject);
    procedure EditorCancelClick(Sender: TObject);
    procedure LoadNodeDataToEditor(Node: TTreeNode; EditorFrame: TFrame);
    procedure SaveEditorDataToNode;

    // 保存配置列表
    procedure SaveConfigList;
    procedure LoadConfigList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadConfigFiles(const IniFileName, JsonFileName: string);
    procedure SaveConfigFiles;
    procedure InitializeGridColumns;
  end;

var
  FrmBuildConfig: TFrmBuildConfig;

implementationimplementation

{$R *.dfm}

constructor TFrmBuildConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeFrame;
  InitializeValidator;
end;

destructor TFrmBuildConfig.Destroy;
begin
  ClearAllData;
  if Assigned(FValidator) then
    FValidator.Free;;
  inherited;
end;

procedure TFrmBuildConfig.FormCreate(Sender: TObject);
begin
  // 初始化框??
  InitializeFrame;

  // 为按钮设置Hint
  btnAddText.Hint := '???????????????';;
  btnAddNumber.Hint := '????????????????';;
  btnRootPath.Hint := '???????????·??';;
  btnAddBoolean.Hint := '添加布尔??(????';
  btnAddDate.Hint := '添加日期';
  btnAddColor.Hint := '添加颜色';
  btnAddFont.Hint := '添加字体';
  btnAddColorComplex.Hint := '添加颜色复杂';
  btnAddDatabase.Hint := '添加数据??;
  btnAddList.Hint := '添加列表';
  btnAddObject.Hint := '添加对象';
  btnAddArray.Hint := '添加数组';
  btnAbsPath.Hint := '添加绝对路径';
  btnRePath.Hint := '添加相对路径';
  btnSection.Hint := '添加分隔??;
  btnEmptyLine.Hint := '添加空行';
  btnSaveConfig.Hint := '保存当前配置文件';
  btnNewConfig.Hint := '新建配置文件';
  btnDeleteConfig.Hint := '删除当前配置文件';

  // 为按钮设置Tag
  btnAddFont.Tag := Integer(cptFont);
  btnAddColorComplex.Tag := Integer(cptColor);
  btnAddDatabase.Tag := Integer(cptDatabase);
  btnAddList.Tag := Integer(cptList);
  btnAddObject.Tag := Integer(cptObject);
  btnAddArray.Tag := Integer(cptArray);
  btnAddAPI.Tag := Integer(cptAPI);
  btnAddRootNode.Tag := Integer(cptRootNode);
  btnAddJsonSecurity.Tag := Integer(cptSecurity);
  btnAddJsonAI.Tag := Integer(cptAI);
  btnAddJsonModule.Tag := Integer(cptModule);

  // 添加按钮的Tag
  btnAddDateTimeRange.Tag := Integer(cptDateTimeRange);
  btnAddKeyValueDict.Tag := Integer(cptKeyValueDict);
  btnAddUrlConfig.Tag := Integer(cptUrlConfig);
  btnAddPermission.Tag := Integer(cptPermission);
  btnAddNetConfig.Tag := Integer(cptNetConfig);
  btnAddEncrypt.Tag := Integer(cptEncrypt);
  btnAddGeoLocation.Tag := Integer(cptGeoLocation);
  btnAddMediaSettings.Tag := Integer(cptMediaSettings);
  btnAddChartConfig.Tag := Integer(cptChartConfig);
  btnAddWorkflow.Tag := Integer(cptWorkflow);
  btnAddSchedule.Tag := Integer(cptSchedule);
  btnAddI18n.Tag := Integer(cptI18n);
  btnAddUnitConversion.Tag := Integer(cptUnitConversion);
  btnAddVersionControl.Tag := Integer(cptVersionControl);

  // 添加按钮的Tag
  btnAddBgDraw.Tag := Integer(cptBgDraw);
  btnAddTextOnBg.Tag := Integer(cptTextOnBg);
  btnAddImageOnBg.Tag := Integer(cptImageOnBg);
  btnAddCaptionOnBg.Tag := Integer(cptCaptionOnBg);
  btnAddVideoClip.Tag := Integer(cptVideoClip);
  btnAddVideo.Tag := Integer(cptVideo);

  // 为按钮设置Hint
  btnAddDateTimeRange.Hint := '添加时间范围';
  btnAddKeyValueDict.Hint := '添加键值对，存储动态??;
  btnAddUrlConfig.Hint := '添加URL，存储动态??;
  btnAddPermission.Hint := '添加权限';
  btnAddNetConfig.Hint := '添加网络配置';
  btnAddEncrypt.Hint := '添加加密';
  btnAddGeoLocation.Hint := '添加地理位置';
  btnAddMediaSettings.Hint := '添加媒体设置';
  btnAddChartConfig.Hint := '添加图表配置';
  btnAddWorkflow.Hint := '添加工作??;
  btnAddSchedule.Hint := '添加调度';
  btnAddI18n.Hint := '添加国际??;
  btnAddUnitConversion.Hint := '添加单位转换';
  btnAddVersionControl.Hint := '添加版本控制';

  // 验证按钮
  btnValidate := TButton.Create(Self);
  pnlButtons := TPanel.Create(Self);\r\npnlButtons.Parent := pnlBottom;\r\npnlButtons.Left := 10;\r\npnlButtons.Top := 10;\r\npnlButtons.Width := 400;\r\npnlButtons.Height := 30;\r\npnlButtons.BevelOuter := bvNone;\r\n\r\nbtnValidate.Parent := pnlButtons;
  btnValidate.Left := btnSave.Left + btnSave.Width + 10;
  btnValidate.Top := btnSave.Top;
  btnValidate.Width := 75;
  btnValidate.Height := 25;
  btnValidate.Caption := '验证';
  btnValidate.Hint := '验证配置是否有效';
  btnValidate.OnClick := btnValidateClick;

  // 为按钮设置Hint
  btnAddBgDraw.Hint := '在图像上绘制元素';
  btnAddTextOnBg.Hint := '在图像上绘制文本';
  btnAddImageOnBg.Hint := '在图像上绘制图像';
  btnAddCaptionOnBg.Hint := '在图像上绘制文本';
  btnAddVideoClip.Hint := '添加视频剪辑';
  btnAddVideo.Hint := '添加视频';

  // 配置列表文件
  FConfigListFile := ExtractFilePath(Application.ExeName) + 'ConfigList.ini';
  LoadConfigList;
end;

procedure TFrmBuildConfig.FormDestroy(Sender: TObject);
begin
  // 保存配置列表
  SaveConfigList;

  // 释放所有数??
  ClearAllData;
end;

procedure TFrmBuildConfig.InitializeFrame;
begin
  // 初始化框??
  // 使用默认值，不使用任何配??
end;

procedure TFrmBuildConfig.InitializeGridColumns;
begin
  // 初始化StringGrid
  if not Assigned(sgINI) then Exit;

  try
    // 初始化StringGrid
    if sgINI.ColCount < 3 then sgINI.ColCount := 3;
    if sgINI.RowCount < 2 then sgINI.RowCount := 2;

    // 设置列标??
    SetGridCell(0, 0, '??????'););
    SetGridCell(1, 0, '????'););
    SetGridCell(2, 0, '?????'););

    // 设置第一行为Json文件??
    SetGridCell(0, 1, 'Json?????'););
    SetGridCell(1, 1, '???'););
    SetGridCell(2, 1, '');

    // 设置列宽??
    sgINI.ColWidths[0] := 150;
    sgINI.ColWidths[1] := 60;
    sgINI.ColWidths[2] := 280;
  except
    on E: Exception do
      OutputDebugString(PChar('Error in InitializeGridColumns: ' + E.Message));
  end;
end;

procedure TFrmBuildConfig.InitializeButtons;
begin
  // 按钮的点击事件需要初始化
end;

procedure TFrmBuildConfig.InitializePopupMenus;
begin
  // 右键菜单的初始化需要通过Object Inspector进行
  // 右键菜单的初始化需要通过Object Inspector进行
end;

procedure TFrmBuildConfig.InitializeDragDrop;
begin
  // 拖放事件的初始化
end;

procedure TFrmBuildConfig.ReorganizeButtons;
begin
  // 重新组织按钮
  // 重新组织按钮
  btnAddText.OnClick := btnAddTextClick;
  btnAddNumber.OnClick := btnAddNumberClick;
  btnRootPath.OnClick := btnRootPathClick;
  btnAddBoolean.OnClick := btnAddBooleanClick;
  btnAddDate.OnClick := btnAddDateClick;
  btnAddColor.OnClick := btnAddColorClick;

  // 重新组织按钮
  btnAddFont.OnClick := btnAddFontClick;
  btnAddColorComplex.OnClick := btnAddColorComplexClick;
  btnAddDatabase.OnClick := btnAddDatabaseClick;
  btnAddList.OnClick := btnAddListClick;
  btnAddObject.OnClick := btnAddObjectClick;
  btnAddArray.OnClick := btnAddArrayClick;

  // 绝对路径按钮
  btnAbsPath.OnClick := btnAbsPathClick;
  btnRePath.OnClick := btnRePathClick;

  // 结构按钮
  btnSection.OnClick := btnSectionClick;
  btnEmptyLine.OnClick := btnEmptyLineClick;

  // 文件按钮
  btnSaveConfig.OnClick := btnSaveConfigClick;
  btnNewConfig.OnClick := btnNewConfigClick;
  btnDeleteConfig.OnClick := btnDeleteConfigClick;

  // 键值对按钮
  btnKey.OnClick := btnKeyClick;
  btnReg.OnClick := btnRegClick;
  btnEMail.OnClick := btnEMailClick;
  btnUrl.OnClick := btnUrlClick;
  btnList.OnClick := btnListClick;
end;

procedure TFrmBuildConfig.AddPropertyToGrid(const PropertyName, PropertyType, PropertyValue: string);
var
  Row: Integer;
begin
  // 确定第一行为"Json文件??
  if sgINI.RowCount <= 1 then
  begin
    sgINI.RowCount := 2; // 确定添加一??
  end;

  // 第一行为固定??Json文件??
  SetGridCell(0, 1, 'Json?????'););
  SetGridCell(1, 1, '???'););

  // 检查是否存在相同的名称
  var found := False;
  var foundRow := -1;

  for var i := 2 to sgINI.RowCount - 1 do
  begin
    if GetGridCell(0, i) = PropertyName then
    begin
      foundRow := i;
      found := True;
      break;
    end;
  end;

  if found then
  begin
    // 找到相同的名??
    Row := foundRow;
  end
  else
  begin
    // 没有找到相同的名??
    Row := sgINI.RowCount;
    sgINI.RowCount := Row + 1;
  end;

  // 设置单元格的??
  SetGridCell(0, Row, PropertyName);
  SetGridCell(1, Row, PropertyType);
  SetGridCell(2, Row, PropertyValue);

  // 更新INI显示
  UpdateIniMemo;
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

  // 显示编辑??
  FCurrentJsonNode := Node;
  FIsEditing := True;
  edtEditing.Text := TTreeNode(Node).Text;
  pnlEditing.Visible := True;
end;

procedure TFrmBuildConfig.HidePropertyEditor;
begin
  // 隐藏编辑??
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

  // 清空INI文件
  SetGridCell(0, 1, 'Json?????'););
  SetGridCell(1, 1, '???'););
  SetGridCell(2, 1, '');
  sgINI.RowCount := 2; // 设置为初始状??

  // 读取INI文件
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;
  Keys := TStringList.Create;

  try
    // 读取所有节
    IniFile.ReadSections(Sections);

    // 如果存在??
    if Sections.Count > 0 then
    begin
      // 清空所有行
      sgINI.RowCount := 1;

      // 遍历每个??
      for i := 0 to Sections.Count - 1 do
      begin
        Section := Sections[i];
        Keys.Clear;

        // 读取节中的键
        IniFile.ReadSection(Section, Keys);

        // 遍历每个??
        for j := 0 to Keys.Count - 1 do
        begin
          Key := Keys[j];
          Value := IniFile.ReadString(Section, Key, '');

          // 添加属??
          AddPropertyToGrid(Section, Key, Value);
        end;
      end;
    end;

    // 更新INI显示
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
  // 保存INI文件
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;

  try
    // 读取所有节
    IniFile.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
      IniFile.EraseSection(Sections[i]);

    // 遍历所有行
    for i := 1 to sgINI.RowCount - 1 do
    begin
      if not IsGridCellEmpty(0, i) and not IsGridCellEmpty(1, i) then
      begin
        Section := GetGridCell(0, i);
        Key := GetGridCell(1, i);
        Value := GetGridCell(2, i);

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

      // 根据值确定编辑类??
      if Pair.JsonValue is TJSONObject then
        EditorType := etObject
      else if Pair.JsonValue is TJSONArray then
        EditorType := etArray
      else
        EditorType := etPlain;

      // 添加属??
      ChildNode := AddPropertyToTree(Pair.JsonString.Value, Pair.JsonValue.ClassName,
                                     Pair.JsonValue.ToString, EditorType, ParentNode);

      // 递归处理子节??
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

  // 清空JSON??
  tvJSON.Items.Clear;

  // 读取JSON文件
  try
    JsonStr := TFile.ReadAllText(FileName);
    JsonValue := TJSONObject.ParseJSONValue(JsonStr);

    if Assigned(JsonValue) and (JsonValue is TJSONObject) then
    begin
      JsonObject := TJSONObject(JsonValue);

      // 处理JSON对象
      ProcessJsonObject(JsonObject);

      // 展开所有节??
      tvJSON.FullExpand;

      // 更新JSON显示
      UpdateJsonMemo;
    end;
  except
    on E: Exception do
      ShowMessage('读取JSON文件失败: ' + E.Message);
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

      // 添加子节??
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

      // 添加子节??
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
      // 创建对象
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
  // 创建根对??
  RootObject := TJSONObject.Create;

  // 获取根节??
  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    var JsonValue := BuildJsonObject(RootNode);
    if JsonValue <> nil then
      RootObject.AddPair(RootNode.Text, JsonValue);

    RootNode := RootNode.getNextSibling;
  end;

  try
    // 格式化JSON
    JsonStr := RootObject.Format(2);
    TFile.WriteAllText(FileName, JsonStr);
  finally
    RootObject.Free;
  end;
end;

procedure TFrmBuildConfig.UpdateIniMemo;
begin
  // 清空INI显示
  MeoINI.Lines.Clear;

  // 添加INI文件头信??
  MeoINI.Lines.Add('[Config]');

  // 遍历所有行
  for var i := 1 to sgINI.RowCount - 1 do
  begin
    if not IsGridCellEmpty(0, i) then
      MeoINI.Lines.Add(Format('%s=%s', [GetGridCell(0, i), GetGridCell(2, i)]));
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

    // 添加缩进
    IndentStr := StringOfChar(' ', Indent * 2);

    PropItem := PConfigPropertyItem(Node.Data);

    // 处理节点文本
    if PropItem^.EditorType = etObject then
    begin
      // 开??
      NodeText := IndentStr + '"' + Node.Text + '": {';
      MeoJSON.Lines.Add(NodeText);

      // 添加子节??
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 如果当前节点有兄弟节点，添加逗号
        if ChildNode.getNextSibling <> nil then
          MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 结束
      MeoJSON.Lines.Add(IndentStr + '}');
    end
    else if PropItem^.EditorType = etArray then
    begin
      // 开??
      NodeText := IndentStr + '"' + Node.Text + '": [';
      MeoJSON.Lines.Add(NodeText);

      // 添加子节??
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 如果当前节点有兄弟节点，添加逗号
        if ChildNode.getNextSibling <> nil then
          MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 结束
      MeoJSON.Lines.Add(IndentStr + ']');
    end
    else
    begin
      // 创建对象
      NodeText := IndentStr + '"' + Node.Text + '": "' + PropItem^.PropertyValue + '"';
      MeoJSON.Lines.Add(NodeText);
    end;
  end;

var
  RootNode: TTreeNode;
begin
  // 清空JSON显示
  MeoJSON.Lines.Clear;

  // 开始JSON
  MeoJSON.Lines.Add('{');

  // 获取根节??
  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    ProcessNode(RootNode, 1);

    // 如果当前节点有兄弟节点，添加逗号
    if RootNode.getNextSibling <> nil then
      MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

    RootNode := RootNode.getNextSibling;
  end;

  // 结束JSON
  MeoJSON.Lines.Add('}');
end;

procedure TFrmBuildConfig.ClearAllData;
var
  i: Integer;
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 清空TreeView中的所有节??
  // 清空所有数??
  if not Assigned(tvJSON) or (tvJSON.Items.Count = 0) then Exit;

  for i := 0 to tvJSON.Items.Count - 1 do
  begin
    Node := tvJSON.Items[i];
    if Assigned(Node.Data) then
    begin
      PropItem := PConfigPropertyItem(Node.Data);
      Dispose(PropItem); // 释放内存
      Node.Data := nil;  // 防止野指??
    end;
  end;

  // 重新设置
  // 重新设置????1列数据，只保留标题行
  sgINI.RowCount := 2;
  SetGridCell(0, 1, 'Json?????'););
  SetGridCell(1, 1, '???'););
  SetGridCell(2, 1, '');

  tvJSON.Items.Clear;
  MeoINI.Clear;
  MeoJSON.Clear;
end;

function TFrmBuildConfig.GetPropertyInputFromUser(const Caption, Prompt: string; var Value: string): Boolean;
begin
  // 用户输入
  Result := InputQuery(Caption, Prompt, Value);
end;

function TFrmBuildConfig.GetNewPropertyName(const DefaultName: string = ''): string;
var
  NewName: string;
begin
  NewName := DefaultName;
  if GetPropertyInputFromUser('名称', '请输入名??', NewName) then
    Result := NewName
  else
    Result := DefaultName;
end;

function TFrmBuildConfig.GetColorValue: string;
begin
  // 获取颜色??
  Result := '';
  if dlgSelectColor.Execute then
    Result := Format('$%.8x', [dlgSelectColor.Color]);
end;

function TFrmBuildConfig.GetPathValue: string;
begin
  // 获取路径??
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
begin
  // 添加文本属??
  PropertyName := GetNewPropertyName('Text');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('文本', '请输入文??', PropertyValue) then Exit;

  // 添加属??
  AddPropertyToGrid(PropertyName, '文本', PropertyValue);
end;

procedure TFrmBuildConfig.showConfigByTag(Sender: TObject);
begin
  GetControllerConfigs.showConfigByTag((Sender as TControl).tag);
end;

procedure TFrmBuildConfig.btnAddNumberClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
  Value: Double;
begin
  // 添加数字属??
  PropertyName := GetNewPropertyName('Number');
  if PropertyName = '' then Exit;

  PropertyValue := '0';
  if not GetPropertyInputFromUser('数字', '请输入数??', PropertyValue) then Exit;

  // 验证是否为有效数??
  try
    Value := StrToFloat(PropertyValue);
  except
    on E: Exception do
    begin
      ShowMessage('无效的数??);
      Exit;
    end;
  end;

  // 添加属??
  AddPropertyToGrid(PropertyName, '数字', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddPathClick(Sender: TObject);
var
  PropertyName: string;
  PathValue: string;
begin
  // 添加路径属??
  PropertyName := GetNewPropertyName('Path');
  if PropertyName = '' then Exit;

  // 获取路径
  PathValue := GetPathValue;
  if PathValue = '' then Exit;

  // 添加属??
  AddPropertyToGrid(PropertyName, '路径', PathValue);
end;

procedure TFrmBuildConfig.btnAddBooleanClick(Sender: TObject);
var
  PropertyName: string;
  BoolStr: string;
begin
  // 添加布尔值属??
  PropertyName := GetNewPropertyName('Boolean');
  if PropertyName = '' then Exit;

  // 用户选择布尔??
  BoolStr := 'True';

  // 添加属??
  AddPropertyToGrid(PropertyName, '布尔??, BoolStr);
end;

procedure TFrmBuildConfig.btnAddDateClick(Sender: TObject);
var
  PropertyName: string;
  DateValue: TDateTime;
  DateStr: string;
  DateForm: TForm;
  DatePicker: TDateTimePicker;
  BtnOK, BtnCancel: TButton;
begin
  // 添加日期属??
  PropertyName := GetNewPropertyName('Date');
  if PropertyName = '' then Exit;

  // 选择日期
  DateForm := TForm.Create(Self);
  try
    DateForm.Caption := '选择日期';
    DateForm.Position := poScreenCenter;
    DateForm.Width := 300;
    DateForm.Height := 150;
    DateForm.BorderStyle := bsDialog;

    // 添加日期选择??
    DatePicker := TDateTimePicker.Create(DateForm);
    DatePicker.Parent := DateForm;
    DatePicker.Left := 20;
    DatePicker.Top := 20;
    DatePicker.Width := 260;
    DatePicker.Date := Now;

    // 添加按钮
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

    // 显示对话??
    if DateForm.ShowModal = mrOK then
    begin
      DateValue := DatePicker.Date;
      DateStr := FormatDateTime('yyyy-mm-dd', DateValue);

      // 添加属??
      AddPropertyToGrid(PropertyName, '日期', DateStr);
    end;
  finally
    DateForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorClick(Sender: TObject);
var
  PropertyName: string;
  ColorValue: string;
begin
  // 添加颜色属??
  PropertyName := GetNewPropertyName('Color');
  if PropertyName = '' then Exit;

  // 获取颜色
  ColorValue := GetColorValue;
  if ColorValue = '' then Exit;

  // 添加属??
  AddPropertyToGrid(PropertyName, '颜色', ColorValue);
end;

procedure TFrmBuildConfig.btnAddFontClick(Sender: TObject);
var
  PropertyName: string;
  FontDialog: TFontDialog;
  FontStr: string;
begin
  // 添加字体属??
  PropertyName := GetNewPropertyName('Font');
  if PropertyName = '' then Exit;

  // 选择字体
  FontDialog := TFontDialog.Create(Self);
  try
    // 使用默认设置
    FontDialog.Font.Name := 'Arial';
    FontDialog.Font.Size := 10;
    FontDialog.Font.Style := [];

    // 显示字体选择对话??
    if FontDialog.Execute then
    begin
      // 将字体信息转换为字符??
      FontStr := Format('%s,%d,%s,%s,%s,%s', [
        FontDialog.Font.Name,
        FontDialog.Font.Size,
        BoolToStr(fsBold in FontDialog.Font.Style, True),
        BoolToStr(fsItalic in FontDialog.Font.Style, True),
        BoolToStr(fsUnderline in FontDialog.Font.Style, True),
        ColorToString(FontDialog.Font.Color)
      ]);

      // 添加属??
      AddPropertyToGrid(PropertyName, '字体', FontStr);
    end;
  finally
    FontDialog.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorComplexClick(Sender: TObject);
begin
  // 添加颜色复杂属??
end;

procedure TFrmBuildConfig.btnAddDatabaseClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
begin
  // 添加数据库属??
  PropertyName := GetNewPropertyName('Database');
  if PropertyName = '' then Exit;

  // 添加子节??
  Node := AddPropertyToTree(PropertyName, 'TJSONObject', '{"ConnectionString":""}', etDatabase);

  // 选择子节??
  tvJSON.Selected := Node;

  // 切换到编辑页??
  PageControl1.ActivePage := tsEditor;

  // 清空编辑内容
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;

  // 显示编辑??
  ShowEditorForNode(Node);

  // 更新JSON显示
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
  // 添加列表属??
  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  // 创建列表编辑??
  ListForm := TForm.Create(Self);
  try
    ListForm.Caption := '列表编辑';
    ListForm.Position := poScreenCenter;
    ListForm.Width := 400;
    ListForm.Height := 350;
    ListForm.BorderStyle := bsDialog;

    // 添加列表编辑??
    ListEditor := TFrameListEditor.Create(ListForm);
    ListEditor.Parent := ListForm;
    ListEditor.Align := alClient;

    // 添加按钮面板
    var ButtonPanel := TPanel.Create(ListForm);
    ButtonPanel.Parent := ListForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 添加确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 添加取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 开始JSON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etList');
    JSONObj.AddPair('value', TJSONArray.Create);

    // 设置JSON
    ListEditor.JSONObject := JSONObj;

    // 显示对话??
    if ListForm.ShowModal = mrOK then
    begin
      // 保存列表JSON
      ListEditor.SaveToJSON;

      // 获取当前选择的Section
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 将列表转换为字符??
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

      // 添加属??- 转换为字符串
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etList))) + '.' + PropertyName, ListStr);

      // 更新INI显示
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
  // ObjectEditor: TFrameObjectEditor;
  ObjectForm: TForm;
  JSONObj: TJSONObject;
begin
  // 不使用FrameObjectEditor，因为这需要使用TFrameObjectEditor单元
  ShowMessage('添加对象属性需要使用TFrameObjectEditor单元');
  Exit;
  
  // 不使用ObjectEditor，因为这需要使用TFrameObjectEditor单元
  {
  // 添加对象属??
  PropertyName := GetNewPropertyName('Object');
  if PropertyName = '' then Exit;

  // 创建对象编辑??
  ObjectForm := TForm.Create(Self);
  try
    ObjectForm.Caption := '对象编辑';
    ObjectForm.Position := poScreenCenter;
    ObjectForm.Width := 500;
    ObjectForm.Height := 400;
    ObjectForm.BorderStyle := bsDialog;

    // 添加对象编辑??
    ObjectEditor := TFrameObjectEditor.Create(ObjectForm);
    ObjectEditor.Parent := ObjectForm;
    ObjectEditor.Align := alClient;

    // 添加按钮面板
    var ButtonPanel := TPanel.Create(ObjectForm);
    ButtonPanel.Parent := ObjectForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 添加确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 添加取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 开始JSON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etObject');

    // 设置JSON
    ObjectEditor.JSONObject := JSONObj;

    // 显示对话??
    if ObjectForm.ShowModal = mrOK then
    begin
      // 保存JSON
      ObjectEditor.SaveToJSON;

      // 获取当前选择的Section
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 添加属??- 转换为字符串
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etObject))) + '.' + PropertyName, JSONObj.ToString);

      // 更新INI显示
      UpdateIniMemo;
    end;
  finally
    JSONObj.Free;
    ObjectForm.Free;
  end;
  }
end;

procedure TFrmBuildConfig.btnAddArrayClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  ArrayEditor: TFrameArrayEditor;
  ArrayForm: TForm;
  JSONObj: TJSONObject;
begin
  // 添加数组属??
  PropertyName := GetNewPropertyName('Array');
  if PropertyName = '' then Exit;

  // 创建数组编辑??
  ArrayForm := TForm.Create(Self);
  try
    ArrayForm.Caption := '数组编辑';
    ArrayForm.Position := poScreenCenter;
    ArrayForm.Width := 500;
    ArrayForm.Height := 400;
    ArrayForm.BorderStyle := bsDialog;

    // 创建数组编辑??
    ArrayEditor := TFrameArrayEditor.Create(ArrayForm);
    ArrayEditor.Parent := ArrayForm;
    ArrayEditor.Align := alClient;

    // 添加按钮面板
    var ButtonPanel := TPanel.Create(ArrayForm);
    ButtonPanel.Parent := ArrayForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 添加确定按钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确定';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 添加取消按钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取消';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 开始JSON
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('_type', 'etArray');
    JSONObj.AddPair('itemType', 'string');
    JSONObj.AddPair('items', TJSONArray.Create);

    // 设置JSON
    ArrayEditor.JSONObject := JSONObj;

    // 显示对话??
    if ArrayForm.ShowModal = mrOK then
    begin
      // 保存JSON
      ArrayEditor.SaveToJSON;

      // 获取当前选择的Section
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 添加属??- 转换为字符串
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etArray))) + '.' + PropertyName, JSONObj.ToString);

      // 更新INI显示
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
  // 获取当前选择的行
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 获取当前选择的节和键
  Section := GetGridCell(0, Row);
  Key := GetGridCell(1, Row);
  PropertyValue := GetGridCell(2, Row);

  // 根据键的前缀进行不同的编??
  if Key.StartsWith('ctFont.') then
  begin
    // 编辑字体
    var FontDialog := TFontDialog.Create(Self);
    try
      // 获取字体信息
      var FontParts := PropertyValue.Split([',']);
      if Length(FontParts) >= 6 then
      begin
        FontDialog.Font.Name := FontParts[0];
        FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

        // 设置样式
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

      // 显示字体选择对话??
      if FontDialog.Execute then
      begin
        // 将字体信息转换为字符??
        NewValue := Format('%s,%d,%s,%s,%s,%s', [
          FontDialog.Font.Name,
          FontDialog.Font.Size,
          BoolToStr(fsBold in FontDialog.Font.Style, True),
          BoolToStr(fsItalic in FontDialog.Font.Style, True),
          BoolToStr(fsUnderline in FontDialog.Font.Style, True),
          ColorToString(FontDialog.Font.Color)
        ]);

        // 设置属??
        SetGridCell(2, Row, NewValue);

        // 更新INI显示
        UpdateIniMemo;
      end;
    finally
      FontDialog.Free;
    end;
  end
  else if Key.StartsWith('ctColor.') then
  begin
    // 编辑颜色
    var ColorDialog := TColorDialog.Create(Self);
    try
      // 设置默认颜色
      try
        ColorDialog.Color := StringToColor(PropertyValue);
      except
        ColorDialog.Color := clBlack;
      end;

      // 显示颜色选择对话??
      if ColorDialog.Execute then
      begin
        // 将颜色转换为字符??
        NewValue := ColorToString(ColorDialog.Color);

        // 设置属??
        SetGridCell(2, Row, NewValue);

        // 更新INI显示
        UpdateIniMemo;
      end;
    finally
      ColorDialog.Free;
    end;
  end
  else if Key.StartsWith('ctPlain.') then
  begin
    // 编辑纯文??
    NewValue := PropertyValue;
    if GetPropertyInputFromUser('编辑文本', '请输入文??', NewValue) then
    begin
      // 设置属??
      SetGridCell(2, Row, NewValue);

      // 更新INI显示
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
  // 获取当前选择的行
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 获取当前的节和键
  Section := GetGridCell(0, Row);
  Key := GetGridCell(1, Row);
  Value := GetGridCell(2, Row);

  // 获取新的??
  NewKey := Key;
  if GetPropertyInputFromUser('修改名称', '请输入新的名??', NewKey) then
  begin
    // 设置新的??
    SetGridCell(1, Row, NewKey);

    // 更新INI显示
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteINIPropertyClick(Sender: TObject);
var
  RowIndex, i: Integer;
  PropertyType, PropertyName: string;
begin
  // 获取当前选择的行
  RowIndex := sgINI.Row;

  // 检查是否为空行或空??
  if (RowIndex <= 1) or (RowIndex >= sgINI.RowCount) then
    Exit;

  // 获取当前选择的类型和名称
  PropertyType := GetGridCell(1, RowIndex);
  PropertyName := GetGridCell(0, RowIndex);

  // 检查是否为分隔??
  if PropertyType = '分隔?? then
  begin
    ShowMessage('分隔符无法删??);
    Exit;
  end;

  // 确认删除
  if MessageDlg('确定要删??"' + PropertyName + '" ??, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 删除??
    for i := RowIndex to sgINI.RowCount - 2 do
    begin
      SetGridCell(0, i, GetGridCell(0, i + 1));
      SetGridCell(1, i, GetGridCell(1, i + 1));
      SetGridCell(2, i, GetGridCell(2, i + 1));
      sgINI.Objects[0, i] := sgINI.Objects[0, i + 1];
    end;

    // 删除最后一??
    if sgINI.RowCount > 2 then
    begin
      SetGridCell(0, sgINI.RowCount - 1, '');
      SetGridCell(1, sgINI.RowCount - 1, '');
      SetGridCell(2, sgINI.RowCount - 1, '');

      // 删除最后一??
      sgINI.RowCount := sgINI.RowCount - 1;
    end;

    // 确认选择
    if RowIndex >= sgINI.RowCount then
      sgINI.Row := sgINI.RowCount - 1;

    // 更新INI显示
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.EditJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewValue: string;
begin
  // 获取当前选择的节??
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 根据编辑类型进行不同的编??
  case PropItem^.EditorType of
    etPlain:
      begin
        // 编辑纯文??
        NewValue := PropItem^.PropertyValue;
        if GetPropertyInputFromUser('编辑文本', '请输入文??', NewValue) then
        begin
          // 设置属性??
          PropItem^.PropertyValue := NewValue;

          // 更新JSON显示
          UpdateJsonMemo;
        end;
      end;
    etFont:
      begin
        // 编辑字体
        var FontDialog := TFontDialog.Create(Self);
        try
          // 获取字体信息
          var FontParts := PropItem^.PropertyValue.Split([',']);
          if Length(FontParts) >= 6 then
          begin
            FontDialog.Font.Name := FontParts[0];
            FontDialog.Font.Size := StrToIntDef(FontParts[1], 10);

            // 设置样式
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

          // 显示字体选择对话??
          if FontDialog.Execute then
          begin
            // 将字体信息转换为字符??
            NewValue := Format('%s,%d,%s,%s,%s,%s', [
              FontDialog.Font.Name,
              FontDialog.Font.Size,
              BoolToStr(fsBold in FontDialog.Font.Style, True),
              BoolToStr(fsItalic in FontDialog.Font.Style, True),
              BoolToStr(fsUnderline in FontDialog.Font.Style, True),
              ColorToString(FontDialog.Font.Color)
            ]);

            // 设置属性??
            PropItem^.PropertyValue := NewValue;

            // 更新JSON显示
            UpdateJsonMemo;
          end;
        finally
          FontDialog.Free;
        end;
      end;
    etColor:
      begin
        // 编辑颜色
        var ColorDialog := TColorDialog.Create(Self);
        try
          // 设置默认颜色
          try
            ColorDialog.Color := StringToColor(PropItem^.PropertyValue);
          except
            ColorDialog.Color := clBlack;
          end;

          // 显示颜色选择对话??
          if ColorDialog.Execute then
          begin
            // 将颜色转换为字符??
            NewValue := ColorToString(ColorDialog.Color);

            // 设置属性??
            PropItem^.PropertyValue := NewValue;

            // 更新JSON显示
            UpdateJsonMemo;
          end;
        finally
          ColorDialog.Free;
        end;
      end;
    etObject, etArray:
      begin
        // 无法直接编辑对象或数??
        ShowMessage('无法直接编辑对象或数??);
      end;
  end;
end;

procedure TFrmBuildConfig.RenameJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewName: string;
begin
  // 获取当前选择的节??
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 获取新的名称
  NewName := Node.Text;
  if GetPropertyInputFromUser('修改名称', '请输入新的名??', NewName) then
  begin
    // 修改节点名称
    Node.Text := NewName;

    // 更新路径
    PropItem := PConfigPropertyItem(Node.Data);
    if PropItem <> nil then
      PropItem^.PropertyPath := BuildPropertyPath(Node);

    // 更新JSON显示
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  // 获取当前选择的节??
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 确认删除
  if MessageDlg('确定要删除吗', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 释放节点数据
    if Node.Data <> nil then
      Dispose(PConfigPropertyItem(Node.Data));

    // 删除节点
    // ??????
    Node.Delete;

    // ????JSON???????
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.btnUpdateClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // ???°??????????????
  if not FIsEditing then Exit;

  // ????????е???
  Node := FCurrentJsonNode;
  if Node = nil then Exit;

  // ?????????
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // ?????????
  PropItem^.PropertyValue := edtEditing.Text;

  // ????JSON???????
  UpdateJsonMemo;

  // ???????
  HidePropertyEditor;
end;

procedure TFrmBuildConfig.btnSaveClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // ???水?????????????
  if (FCurrentIniFile = '') and (cbFileName.Text = '') then
  begin
    // ???????????????????????????
    dlgOpenFile.Filter := 'INI??? (*.ini)|*.ini|All files (*.*)|*.*';
    dlgOpenFile.Title := '????INI???????';
    dlgOpenFile.DefaultExt := 'ini';

    if dlgOpenFile.Execute then
    begin
      IniFileName := dlgOpenFile.FileName;
      JsonFileName := ChangeFileExt(IniFileName, '.json');

      // ???????
      SaveIniFile(IniFileName);
      SaveJsonFile(JsonFileName);

      // ???μ???????
      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;

      // ?????ComboBox
      if cbFileName.Items.IndexOf(IniFileName) < 0 then
      begin
        cbFileName.Items.Add(IniFileName);
        cbFileName.ItemIndex := cbFileName.Items.Count - 1;
      end;

      ShowMessage('????????????');
    end;
  end
  else
  begin
    // ??????????????
    if FCurrentIniFile = '' then
      FCurrentIniFile := cbFileName.Text;

    JsonFileName := ChangeFileExt(FCurrentIniFile, '.json');

    // ???????
    SaveIniFile(FCurrentIniFile);
    SaveJsonFile(JsonFileName);

    ShowMessage('????????????');
  end;
end;

procedure TFrmBuildConfig.btnSectionClick(Sender: TObject);
var
  CurrentRow: Integer;
  SectionName: string;
  i: Integer;
begin
  // ????????е???
  CurrentRow := sgINI.Row;

  // ???δ????л???е???У????????????
  if (CurrentRow <= 1) then
    CurrentRow := sgINI.RowCount;

  // ????????
  SectionName := '';
  if not GetPropertyInputFromUser('?????', '???????????', SectionName) then
    Exit;

  if SectionName = '' then
  begin
    ShowMessage('????????????');
    Exit;
  end;

  // ???????
  if CurrentRow >= sgINI.RowCount then
    sgINI.RowCount := sgINI.RowCount + 1
  else
  begin
    // ????????
    sgINI.RowCount := sgINI.RowCount + 1;

    // ??????м????μ???????????
    for i := sgINI.RowCount - 2 downto CurrentRow do
    begin
      SetGridCell(0, i + 1, GetGridCell(0, i));
      SetGridCell(1, i + 1, GetGridCell(1, i));
      SetGridCell(2, i + 1, GetGridCell(2, i));
    end;
  end;

  // ?????????÷????
  SetGridCell(0, CurrentRow, SectionName);
  SetGridCell(1, CurrentRow, '?????');
  SetGridCell(2, CurrentRow, '--???--');

  // ??????
  sgINI.Row := CurrentRow;

  // ????INI???????
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBuildConfig.btnOpenConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // ??????????????
  dlgOpenFile.Filter := 'INI??? (*.ini)|*.ini|All files (*.*)|*.*';
  dlgOpenFile.Title := '???INI???????';

  if dlgOpenFile.Execute then
  begin
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // ???????????
    LoadConfigFiles(IniFileName, JsonFileName);

    // ????????????????ComboBox
    if cbFileName.Items.IndexOf(IniFileName) < 0 then
    begin
      cbFileName.Items.Add(IniFileName);
      SaveConfigList; // ?????????б?
    end;

    cbFileName.ItemIndex := cbFileName.Items.IndexOf(IniFileName);
    FCurrentIniFile := IniFileName;
    FCurrentJsonFile := JsonFileName;
  end;
end;

procedure TFrmBuildConfig.sgINIDblClick(Sender: TObject);
begin
  // INI???????????????
  EditINIPropertyClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONDblClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  ConfigType: TConfigType;
begin
  // ????????е???
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // ?????????????л????????
  ConfigType := EditorTypeToConfigType(PropItem^.EditorType);
  if (PropItem^.EditorType in [etObject, etArray, etDatabase, etList]) or
     (ConfigType = ctAIAPI) then
  begin
    // ?л???????????
    PageControl1.ActivePage := tsEditor;

    // ???????????????е????п??
    while pnlEditorContent.ControlCount > 0 do
      pnlEditorContent.Controls[0].Free;

    // ?????????????????
    ShowEditorForNode(Node);
  end
  else
  begin
    // ???????????????е??????
    EditJSONPropertyClick(Sender);
  end;
end;

// ????????????????
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
  // ????????
  PropertyName := '????????';

  // ?????????
  RootNode := AddPropertyToTree(PropertyName, 'TJSONObject', '{}', etObject);

  // ??????
  if Assigned(RootNode) then
    RootNode.Expand(False);

  // ????JSON???????
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.btnAddININetworkClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // ????????????????
  PropertyName := GetNewPropertyName('IP???');
  if PropertyName = '' then Exit;

  PropertyValue := '127.0.0.1';
  if not GetPropertyInputFromUser('????????', '??????IP???:', PropertyValue) then Exit;

  // ?????????
  AddPropertyToGrid(PropertyName, 'IP???', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINITimeClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // ???????????????
  PropertyName := GetNewPropertyName('Time');
  if PropertyName = '' then Exit;

  PropertyValue := FormatDateTime('hh:mm:ss', Now);
  if not GetPropertyInputFromUser('???????', '????????? (hh:mm:ss):', PropertyValue) then Exit;

  // ?????????
  AddPropertyToGrid(PropertyName, '???', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINITemplateClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // ???????????????
  PropertyName := GetNewPropertyName('Template');
  if PropertyName = '' then Exit;

  PropertyValue := '${variableName}';
  if not GetPropertyInputFromUser('???????', '?????????:', PropertyValue) then Exit;

  // ????????е??????Section
  if sgINI.RowCount > 1 then
    Section := GetGridCell(0, 1)
  else
    Section := 'Template';

  // ????????? - ???????????????
  AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etPlain))) + '.' + PropertyName, PropertyValue);

  // ????INI???????
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINIPluginClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // ???????????????
  PropertyName := GetNewPropertyName('Plugin');
  if PropertyName = '' then Exit;

  PropertyValue := 'plugins/example.dll';
  if not GetPropertyInputFromUser('????????, '????????·??:', PropertyValue) then Exit;

  // ?????????
  AddPropertyToGrid(PropertyName, '?????', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINILogClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // ???????????????
  PropertyName := GetNewPropertyName('Log');
  if PropertyName = '' then Exit;

  PropertyValue := 'logs/app.log';
  if not GetPropertyInputFromUser('???????', '?????????·??:', PropertyValue) then Exit;

  // ?????????
  AddPropertyToGrid(PropertyName, '???·???, PropertyValue);
end;

procedure TFrmBuildConfig.btnAddAPIClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  APIEditor: TAIAPIEditorFrame;
  APIForm: TForm;
  JSONObj: TJSONObject;
begin
  // ????API????????
  PropertyName := GetNewPropertyName('API');
  if PropertyName = '' then Exit;

  // ????API?????????
  APIForm := TForm.Create(Self);
  try
    APIForm.Caption := 'API????';
    APIForm.Position := poScreenCenter;
    APIForm.Width := 450;
    APIForm.Height := 350;
    APIForm.BorderStyle := bsDialog;

    // ????API????
    APIEditor := TAIAPIEditorFrame.Create(APIForm);
    APIEditor.Parent := APIForm;
    APIEditor.Align := alClient;

    // ???????????
    var ButtonPanel := TPanel.Create(APIForm);
    ButtonPanel.Parent := APIForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // ??????????
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '???';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // ??????????
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '???';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // ???????JSON????
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('url', 'https://api.example.com');
    JSONObj.AddPair('method', 'GET');

    // ????????
    if APIForm.ShowModal = mrOK then
    begin
      // ????????е???
      var Node := tvJSON.Selected;
      var PropItem: PConfigPropertyItem;

      if Node = nil then
      begin
        // ????????н??????????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject);
      end
      else
      begin
        // ?????????????????
        PropItem := PConfigPropertyItem(Node.Data);
        if PropItem^.EditorType = etObject then
          // ???????е?????????
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node)
        else
          // ???????н???????
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node.Parent);
      end;

      // ????JSON???????
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
  // ??????????????
  PropertyName := GetNewPropertyName('Security');
  if PropertyName = '' then Exit;

  // ????JSON????
  SecJSON := TJSONObject.Create;
  try
    SecJSON.AddPair('enabled', TJSONBool.Create(True));
    SecJSON.AddPair('encryption', 'AES-256');
    SecJSON.AddPair('ssl', TJSONBool.Create(True));

    // ????????е???
    Node := tvJSON.Selected;

    if Node = nil then
    begin
      // ????????н??????????
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject);
    end
    else
    begin
      // ??????????????????
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // ???????е?????????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node)
      else
        // ???????н???????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node.Parent);
    end;

    // ????JSON???????
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
  // ????AI????????
  PropertyName := GetNewPropertyName('AI');
  if PropertyName = '' then Exit;

  // ????JSON????
  AIJSON := TJSONObject.Create;
  try
    AIJSON.AddPair('model', 'gpt-4');
    AIJSON.AddPair('temperature', TJSONNumber.Create(0.7));
    AIJSON.AddPair('max_tokens', TJSONNumber.Create(1024));

    // ????????е???
    Node := tvJSON.Selected;

    if Node = nil then
    begin
      // ????????н??????????
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject);
    end
    else
    begin
      // ??????????????????
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // ???????е?????????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node)
      else
        // ???????н???????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node.Parent);
    end;

    // ????JSON???????
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
  // ???????????????
  PropertyName := GetNewPropertyName('Module');
  if PropertyName = '' then Exit;

  // ????JSON????
  ModJSON := TJSONObject.Create;
  try
    ModJSON.AddPair('name', PropertyName);
    ModJSON.AddPair('enabled', TJSONBool.Create(True));
    ModJSON.AddPair('version', '1.0.0');

    // ????????????
    var DepsArray := TJSONArray.Create;
    DepsArray.Add('core');
    DepsArray.Add('logger');
    ModJSON.AddPair('dependencies', DepsArray);

    // ????????е???
    Node := tvJSON.Selected;

    if Node = nil then
    begin
      // ????????н??????????
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject);
    end
    else
    begin
      // ??????????????????
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // ???????е?????????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node)
      else
        // ???????н???????
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node.Parent);
    end;

    // ????JSON???????
    UpdateJsonMemo;
  finally
    ModJSON.Free;
  end;
end;

// ???????????????????
procedure TFrmBuildConfig.btnAddSectionClick(Sender: TObject);
begin
  // ??????????????????????????
  btnSectionClick(Sender);
end;

// ??????????????????
procedure TFrmBuildConfig.btnAddEmptyLineClick(Sender: TObject);
var
  CurrentRow: Integer;
  EmptyName: string;
  i: Integer;
begin
  // ????????е???
  CurrentRow := sgINI.Row;

  // ???δ????л???е???У????????????
  if (CurrentRow <= 1) then
    CurrentRow := sgINI.RowCount;

  // ??????????????????????????????
  EmptyName := 'Empty_' + IntToStr(sgINI.RowCount);

  // ???????
  if CurrentRow >= sgINI.RowCount then
    sgINI.RowCount := sgINI.RowCount + 1
  else
  begin
    // ????????
    sgINI.RowCount := sgINI.RowCount + 1;

    // ??????м????μ???????????
    for i := sgINI.RowCount - 2 downto CurrentRow do
    begin
      SetGridCell(0, i + 1, GetGridCell(0, i));
      SetGridCell(1, i + 1, GetGridCell(1, i));
      SetGridCell(2, i + 1, GetGridCell(2, i));
    end;
  end;

  // ?????????????
  SetGridCell(0, CurrentRow, EmptyName);
  SetGridCell(1, CurrentRow, '????');
  SetGridCell(2, CurrentRow, '');

  // ??????
  sgINI.Row := CurrentRow;

  // ????INI???????
  UpdateIniMemo;
end;

// ?????????????????????????
procedure TFrmBuildConfig.btnRootPathClick(Sender: TObject);
var
  PropertyName: string;
  DirValue: string;
begin
  // ???????????????
  PropertyName := GetNewPropertyName('RootPath');
  if PropertyName = '' then Exit;

  // ?????
  DirValue := '';

  // ?????????????
  dlgBrowseDir.Title := '??????????';
  dlgBrowseDir.Options := [fdoPickFolders];

  if dlgBrowseDir.Execute then
  begin
    DirValue := dlgBrowseDir.FileName;
    if DirValue <> '' then
      AddPropertyToGrid(PropertyName, '???????', DirValue);
  end;
end;

// ??????????????????????????
procedure TFrmBuildConfig.btnFileNameClick(Sender: TObject);
var
  PropertyName: string;
  RootDir, FileName, FullPath: string;
begin
  // ????????????????
  PropertyName := GetNewPropertyName('FileName');
  if PropertyName = '' then Exit;

  // ?????????????????????
  RootDir := '';
  for var i := 2 to sgINI.RowCount - 1 do
  begin
    if GetGridCell(1, i) = '???????' then
    begin
      RootDir := GetGridCell(2, i);
      break;
    end;
  end;

  // ?????????δ??????????????
  if RootDir = '' then
  begin
    dlgBrowseDir.Title := '??????????';
    dlgBrowseDir.Options := [fdoPickFolders];

    if dlgBrowseDir.Execute then
      RootDir := dlgBrowseDir.FileName
    else
      Exit;
  end;

  // ??????
  dlgOpenFile.Title := '??????';
  if RootDir <> '' then
    dlgOpenFile.DefaultExt := RootDir; // ???DefaultExt???ó????
  dlgOpenFile.Filter := '??????? (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FullPath := dlgOpenFile.FileName;
    FileName := ExtractFileName(FullPath);

    // ?????????
    AddPropertyToGrid(PropertyName, '?????????', FileName);
  end;
end;

procedure TFrmBuildConfig.btnListClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // ?????б?????????
  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('?б?????', '???????б?????????????:', PropertyValue) then Exit;

  // ?????????
  AddPropertyToGrid(PropertyName, '?б?', PropertyValue);
end;

// ???????·????????????????
procedure TFrmBuildConfig.btnAbsFilenameClick(Sender: TObject);
var
  PropertyName: string;
  FilePath: string;
begin
  // ?????????·?????????????
  PropertyName := GetNewPropertyName('AbsFileName');
  if PropertyName = '' then Exit;

  // ??????
  dlgOpenFile.Title := '??????';
  dlgOpenFile.Filter := '??????? (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FilePath := dlgOpenFile.FileName;
    if FilePath <> '' then
      AddPropertyToGrid(PropertyName, '???·??', FilePath);
  end;
end;

procedure TFrmBuildConfig.btnAbsPathClick(Sender: TObject);
var
  PropertyName: string;
  FilePath: string;
begin
  // ???????·??????
  PropertyName := GetNewPropertyName('AbsPath');
  if PropertyName = '' then Exit;

  // ??????????
  dlgBrowseDir.Title := '??????????';
  dlgBrowseDir.Options := []; // ??????????????

  if dlgBrowseDir.Execute then
  begin
    FilePath := dlgBrowseDir.FileName;
    if FilePath <> '' then
      AddPropertyToGrid(PropertyName, '????·??', FilePath);
  end;
end;

// ???????????????????????????
procedure TFrmBuildConfig.btnReFileNameClick(Sender: TObject);
var
  PropertyName: string;
  FilePath, FileName: string;
begin
  // ???????·?????????????
  PropertyName := GetNewPropertyName('FileName');
  if PropertyName = '' then Exit;

  // ??????
  dlgOpenFile.Title := '??????';
  dlgOpenFile.Filter := '??????? (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FilePath := dlgOpenFile.FileName;
    if FilePath <> '' then
    begin
      // ??????????????·????
      FileName := ExtractFileName(FilePath);

      // ?????????
      AddPropertyToGrid(PropertyName, '?????', FileName);
    end;
  end;
end;

procedure TFrmBuildConfig.btnRePathClick(Sender: TObject);
var
  PropertyName: string;
  RootDir, SubDir, RelativePath: string;
begin
  // ??????????????
  PropertyName := GetNewPropertyName('RePath');
  if PropertyName = '' then Exit;

  // ?????????????????????
  RootDir := '';
  for var i := 2 to sgINI.RowCount - 1 do
  begin
    if GetGridCell(1, i) = '???????' then
    begin
      RootDir := GetGridCell(2, i);
      break;
    end;
  end;

  // ?????????δ??????????????
  if RootDir = '' then
  begin
    dlgBrowseDir.Title := '??????????';
    dlgBrowseDir.Options := [fdoPickFolders];

    if dlgBrowseDir.Execute then
      RootDir := dlgBrowseDir.FileName
    else
      Exit;

    // ??????????
    AddPropertyToGrid('RootDir', '???????', RootDir);
  end;

  // ???????
  dlgBrowseDir.Title := '???????';
  dlgBrowseDir.Options := [fdoPickFolders];
  dlgBrowseDir.DefaultFolder := RootDir; // ???DefaultFolder????InitialDir

  if dlgBrowseDir.Execute then
  begin
    SubDir := dlgBrowseDir.FileName;

    // ???????·???
    if SubDir.StartsWith(RootDir) then
    begin
      RelativePath := Copy(SubDir, Length(RootDir) + 1, Length(SubDir));
      // ????????б???б??
      if (RelativePath <> '') and ((RelativePath[1] = '/') or (RelativePath[1] = '\')) then
        RelativePath := Copy(RelativePath, 2, Length(RelativePath));

      // ?????????
      AddPropertyToGrid(PropertyName, '??????, RelativePath);
    end
    else
    begin
      ShowMessage('??????????????????????????);
    end;
  end;
end;

{$IFDEF DESIGNTIME}
procedure Register;
begin
  RegisterComponents('Custom', [TFrmBuildConfig]);
end;
{$ENDIF}

// ???????initialization???????Register
{$IFDEF DESIGNTIME}
initialization
  // ????????????Register???????????????Register??????????????
{$ENDIF}

procedure TFrmBuildConfig.ShowEditorForNode(Node: TTreeNode);
var
  PropItem: PConfigPropertyItem;
  EditorFrame: TFrame;
  ButtonPanel: TPanel;
  SaveBtn, CancelBtn: TButton;
  ConfigType: TConfigType;
begin
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // ????????????????????? - ???????????????
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
        // ????????????FrameObjectEditor????б???????
        // EditorFrame := TFrameObjectEditor.Create(Self);
        // ????????????????????
        ShowMessage('???????????????????????????????);
        Exit;
      end;
    etArray:
      begin
        EditorFrame := TFrameArrayEditor.Create(Self);
      end;
    else
      begin
        // ??????????????????AI API
        ConfigType := EditorTypeToConfigType(PropItem^.EditorType);
        if ConfigType = ctAIAPI then
          EditorFrame := TAIAPIEditorFrame.Create(Self)
        else
          Exit; // ??????????????
      end;
  end;

  if EditorFrame <> nil then
  begin
    // ???????λ?ú?????
    EditorFrame.Parent := pnlEditorContent;
    EditorFrame.Align := alClient;
    EditorFrame.Visible := True;

    // ???????????/?????????????????????
    if not (EditorFrame is TFrameDBEditor) then
    begin
      // ???????????
      ButtonPanel := TPanel.Create(Self);
      ButtonPanel.Parent := pnlEditorContent;
      ButtonPanel.Align := alBottom;
      ButtonPanel.Height := 40;
      ButtonPanel.BevelOuter := bvNone;

      // ???????水?
      SaveBtn := TButton.Create(Self);
      SaveBtn.Parent := ButtonPanel;
      SaveBtn.Caption := '????';
      SaveBtn.ModalResult := mrOK;
      SaveBtn.Left := ButtonPanel.Width - 170;
      SaveBtn.Top := 8;
      SaveBtn.Width := 75;
      SaveBtn.OnClick := EditorSaveClick;

      // ??????????
      CancelBtn := TButton.Create(Self);
      CancelBtn.Parent := ButtonPanel;
      CancelBtn.Caption := '???';
      CancelBtn.ModalResult := mrCancel;
      CancelBtn.Left := ButtonPanel.Width - 85;
      CancelBtn.Top := 8;
      CancelBtn.Width := 75;
      CancelBtn.OnClick := EditorCancelClick;
    end;

    // ???????????????
    LoadNodeDataToEditor(Node, EditorFrame);

    // ???浱???????????????
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
    // ???????JSON????
    if PropItem^.PropertyValue <> '' then
    begin
      JSONObj := TJSONObject.ParseJSONValue(PropItem^.PropertyValue) as TJSONObject;
      if JSONObj <> nil then
      begin
        try
          // ??????????????????
          if EditorFrame is TFrameDBEditor then
          begin
            // ????????????????
            if JSONObj.GetValue('ConnectionString') <> nil then
              TFrameDBEditor(EditorFrame).ConnectionString := JSONObj.GetValue('ConnectionString').Value;
          end
          else if EditorFrame is TFrameListEditor then
          begin
            // ?????б????
            // TFrameListEditor???...
          end
          // // else if EditorFrame is TFrameObjectEditor then
          // begin
          //   // ??????????
          //   // TFrameObjectEditor???...
          // end
          else if EditorFrame is TFrameArrayEditor then
          begin
            // ???????????
            // TFrameArrayEditor???...
          end
          else if EditorFrame is TAIAPIEditorFrame then
          begin
            // ????API???
            // TAIAPIEditorFrame???...
          end;
        finally
          JSONObj.Free;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('???????????????: ' + E.Message);
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
    // ??????????????????
    if FCurrentEditor is TFrameDBEditor then
    begin
      // ????????????????
      JSONObj.AddPair('ConnectionString', TFrameDBEditor(FCurrentEditor).ConnectionString);
    end
    else if FCurrentEditor is TFrameListEditor then
    begin
      // ?????б????
      // TFrameListEditor???...
    end
    // else if FCurrentEditor is TFrameObjectEditor then
    begin
      // ???????????
      // TFrameObjectEditor???...
    end
    else if FCurrentEditor is TFrameArrayEditor then
    begin
      // ???????????
      // TFrameArrayEditor???...
    end
    else if FCurrentEditor is TAIAPIEditorFrame then
    begin
      // ????API???
      // TAIAPIEditorFrame???...
    end;

    // ??????????
    PropItem^.PropertyValue := JSONObj.ToString;
  finally
    JSONObj.Free;
  end;

  // ????JSON???
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.EditorSaveClick(Sender: TObject);
begin
  // ????????????????
  SaveEditorDataToNode;

  // ???????????????е????п??
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;

  // ??????????????
  FCurrentEditor := nil;
  FCurrentEditNode := nil;

  // ?л?JSON?
  PageControl1.ActivePage := tsJSON;
end;

procedure TFrmBuildConfig.EditorCancelClick(Sender: TObject);
begin
  // ???????????????е????п??
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;

  // ??????????????
  FCurrentEditor := nil;
  FCurrentEditNode := nil;

  // ?л?JSON?
  PageControl1.ActivePage := tsJSON;
end;

function TFrmBuildConfig.BuildPropertyPath(Node: TTreeNode): string;
var
  Path: string;
  CurrentNode: TTreeNode;
begin
  Path := '';
  CurrentNode := Node;

  // ????????????????·???
  while CurrentNode <> nil do
  begin
    if Path = '' then
      Path := CurrentNode.Text
    else
      Path := CurrentNode.Text + '.' + Path;

    CurrentNode := CurrentNode.Parent;
  end;

  Result := Path;
end;

procedure TFrmBuildConfig.btnEmptyLineClick(Sender: TObject);
begin
  // ??????????????????????????
  btnAddEmptyLineClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONChange(Sender: TObject; Node: TTreeNode);
begin
  // ??JSON??????????????????
  if Node = nil then Exit;

  // ?????????????????????????????
  // ???磺???????????????????
end;

procedure TFrmBuildConfig.sgINISelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // ??INI????????????????
  CanSelect := True; // ???????

  // ???е?????????????
  if ARow > 1 then
  begin
    // ??????????
    sgINI.PopupMenu := popupINI;

    // ?????????????У?????????????
    if (GetGridCell(1, ARow) = '?????') then
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := False; // ???????
        popupINI.Items[0].Enabled := False; // ?????
      end;
    end
    else if (GetGridCell(1, ARow) = '????') then
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := True; // ???????
        popupINI.Items[0].Enabled := False; // ?????
      end;
    end
    else
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := True; // ???????
        popupINI.Items[0].Enabled := True; // ??????
      end;
    end;
  end
  else
  begin
    // ????в???????????
    sgINI.PopupMenu := nil;
  end;

  // ?????????????INI???????
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.sgINIDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DropRow: Integer;
  TempCells: array[0..2] of string;
begin
  // ???????λ????к?
  DropRow := sgINI.MouseCoord(X, Y).Y;

  // ?????????Ч??
  if (DropRow > 0) and (DropRow < sgINI.RowCount) and (sgINI.Row > 0) and (sgINI.Row < sgINI.RowCount) then
  begin
    // ??к?????в???????д???
    if DropRow <> sgINI.Row then
    begin
      // ???汻????е?????
      TempCells[0] := GetGridCell(0, sgINI.Row);
      TempCells[1] := GetGridCell(1, sgINI.Row);
      TempCells[2] := GetGridCell(2, sgINI.Row);

      // ?????????????????У?????????λ??
      if DropRow > sgINI.Row then
      begin
        // ???????
        for var i := sgINI.Row to DropRow - 1 do
        begin
          SetGridCell(0, i, GetGridCell(0, i + 1));
          SetGridCell(1, i, GetGridCell(1, i + 1));
          SetGridCell(2, i, GetGridCell(2, i + 1));
        end;
      end
      else
      begin
        // ???????
        for var i := sgINI.Row downto DropRow + 1 do
        begin
          SetGridCell(0, i, GetGridCell(0, i - 1));
          SetGridCell(1, i, GetGridCell(1, i - 1));
          SetGridCell(2, i, GetGridCell(2, i - 1));
        end;
      end;

      // ?????λ?ò???????
      SetGridCell(0, DropRow, TempCells[0]);
      SetGridCell(1, DropRow, TempCells[1]);
      SetGridCell(2, DropRow, TempCells[2]);

      // ????????
      sgINI.Row := DropRow;

      // ????INI???????
      UpdateIniMemo;
    end;
  end;
end;

procedure TFrmBuildConfig.sgINIDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // INI?????????????????
  Accept := (Source = sgINI) and (Y > sgINI.RowHeights[0]); // ??????????????????????????
end;

procedure TFrmBuildConfig.tvJSONDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SourceNode, TargetNode: TTreeNode;
  SourceData, TargetData: PConfigPropertyItem;
  PointPos: TPoint;
begin
  if Source <> tvJSON then Exit;

  // ????????????????
  SourceNode := tvJSON.Selected;
  if SourceNode = nil then Exit;

  PointPos := tvJSON.ScreenToClient(Point(X, Y));
  TargetNode := tvJSON.GetNodeAt(PointPos.X, PointPos.Y);

  // ?????Ч????????
  if (TargetNode = nil) or (TargetNode = SourceNode) or TargetNode.HasAsParent(SourceNode) then Exit;

  // ??????????
  SourceData := PConfigPropertyItem(SourceNode.Data);
  if TargetNode <> nil then
    TargetData := PConfigPropertyItem(TargetNode.Data)
  else
    TargetData := nil;

  // ????????????????????????????
  if (TargetData <> nil) and (TargetData^.EditorType <> etObject) and (TargetData^.EditorType <> etArray) then Exit;

  // ??????
  SourceNode.MoveTo(TargetNode, naAddChild);

  // ??????·??
  SourceData^.PropertyPath := BuildPropertyPath(SourceNode);

  // ?????????????·???
  for var i := 0 to SourceNode.Count - 1 do
  begin
    var ChildData := PConfigPropertyItem(SourceNode.Item[i].Data);
    if ChildData <> nil then
      ChildData^.PropertyPath := BuildPropertyPath(SourceNode.Item[i]);
  end;

  // ?????????
  if TargetNode <> nil then
    TargetNode.Expand(False);

  // ????JSON???????
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.tvJSONDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  TargetNode: TTreeNode;
  TargetData: PConfigPropertyItem;
  PointPos: TPoint;
begin
  Accept := False;

  // ????????????????
  if Source <> tvJSON then Exit;

  // ??????λ??????
  PointPos := tvJSON.ScreenToClient(Point(X, Y));
  TargetNode := tvJSON.GetNodeAt(PointPos.X, PointPos.Y);

  // ??????????????????????????
  if TargetNode = nil then
  begin
    Accept := True;
    Exit;
  end;

  // ?????????????
  TargetData := PConfigPropertyItem(TargetNode.Data);
  if TargetData = nil then Exit;

  // ???????????????????????????
  Accept := (TargetData^.EditorType = etObject) or (TargetData^.EditorType = etArray);
end;

function TFrmBuildConfig.GetGridCell(ACol, ARow: Integer): string;
begin
  Result := '';
  try
    if Assigned(sgINI) and (ACol >= 0) and (ARow >= 0) and
       (ACol < sgINI.ColCount) and (ARow < sgINI.RowCount) then
      Result := sgINI.Rows[ARow][ACol];
  except
    on E: Exception do
      OutputDebugString(PChar('Error in GetGridCell: ' + E.Message));
  end;
end;

procedure TFrmBuildConfig.SetGridCell(ACol, ARow: Integer; const Value: string);
begin
  try
    if Assigned(sgINI) and (ACol >= 0) and (ARow >= 0) and
       (ACol < sgINI.ColCount) and (ARow < sgINI.RowCount) then
      sgINI.Rows[ARow][ACol] := Value;
  except
    on E: Exception do
      OutputDebugString(PChar('Error in SetGridCell: ' + E.Message));
  end;
end;

function TFrmBuildConfig.IsGridCellEmpty(ACol, ARow: Integer): Boolean;
begin
  Result := True;
  try
    if Assigned(sgINI) and (ACol >= 0) and (ARow >= 0) and
       (ACol < sgINI.ColCount) and (ARow < sgINI.RowCount) then
      Result := sgINI.Rows[ARow][ACol] = '';
  except
    on E: Exception do
      OutputDebugString(PChar('Error in IsGridCellEmpty: ' + E.Message));
  end;
end;

// ??implementation??????????????
procedure TFrmBuildConfig.pcAttributeChange(Sender: TObject);
begin
  // ??????????????????????????????
  if pcAttribute.ActivePage = tsINIGrid then
  begin
    // ??INI?????????????????INI??壬????JSON????
    pnlIni.Visible := True;
    pnlJson.Visible := False;

    // ??????INI??????
    if PageControl1.ActivePage <> tsINI then
      PageControl1.ActivePage := tsINI;
  end
  else if pcAttribute.ActivePage = tsJSONTree then
  begin
    // ??JSON????????????????JSON??壬????INI????
    pnlIni.Visible := False;
    pnlJson.Visible := True;

    // ??????JSON??????
    if PageControl1.ActivePage <> tsJSON then
      PageControl1.ActivePage := tsJSON;
  end;
end;

// ???????????????б??????
procedure TFrmBuildConfig.SaveConfigList;
var
  FileList: TStringList;
  i: Integer;
begin
  // ??????????б?
  FileList := TStringList.Create;
  try
    // ????ComboBox?е????????
    for i := 0 to cbFileName.Items.Count - 1 do
      FileList.Add(cbFileName.Items[i]);

    // ???浽???
    try
      FileList.SaveToFile(FConfigListFile);
    except
      on E: Exception do
        ShowMessage('?????????б????: ' + E.Message);
    end;
  finally
    FileList.Free;
  end;
end;

// ????????????????????б?
procedure TFrmBuildConfig.LoadConfigList;
var
  FileList: TStringList;
begin
  // ??е??????????????
  if not FileExists(FConfigListFile) then
    Exit;

  // ??????????б?
  FileList := TStringList.Create;
  try
    // ?????????
    try
      FileList.LoadFromFile(FConfigListFile);

      // ???????????????????????
      cbFileName.Items.Clear;
      cbFileName.Items.AddStrings(FileList);

      // ?????????????????
      if cbFileName.Items.Count > 0 then
      begin
        cbFileName.ItemIndex := 0;
        cbFileNameChange(nil);
      end;
    except
      on E: Exception do
        ShowMessage('?????????б????: ' + E.Message);
    end;
  finally
    FileList.Free;
  end;
end;

// ??????ComboBox????????????
procedure TFrmBuildConfig.cbFileNameChange(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // ???????е????
  if cbFileName.ItemIndex < 0 then
    Exit;

  // ?????е??????
  IniFileName := cbFileName.Items[cbFileName.ItemIndex];

  // ??????????
  if not FileExists(IniFileName) then
  begin
    ShowMessage('?????????: ' + IniFileName);
    Exit;
  end;

  // ????????JSON?????
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // ???????????
  LoadConfigFiles(IniFileName, JsonFileName);

  // ???μ???????
  FCurrentIniFile := IniFileName;
  FCurrentJsonFile := JsonFileName;
end;

// ?????????????????????
procedure TFrmBuildConfig.btnSaveConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // ???????е????
  if cbFileName.ItemIndex < 0 then
  begin
    ShowMessage('??????????????????????μ????????');
    Exit;
  end;

  // ?????е??????
  IniFileName := cbFileName.Items[cbFileName.ItemIndex];
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // ???????
  try
    SaveIniFile(IniFileName);
    SaveJsonFile(JsonFileName);

    // ???μ???????
    FCurrentIniFile := IniFileName;
    FCurrentJsonFile := JsonFileName;

    ShowMessage('????????浽: ' + IniFileName);
  except
    on E: Exception do
      ShowMessage('???????????: ' + E.Message);
  end;
end;

// ???????????μ????????
procedure TFrmBuildConfig.btnNewConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // ???????????
  dlgOpenFile.Filter := 'INI??? (*.ini)|*.ini|??????? (*.*)|*.*';
  dlgOpenFile.Title := '?????????????';
  dlgOpenFile.DefaultExt := 'ini';
  dlgOpenFile.Options := dlgOpenFile.Options + [ofOverwritePrompt];

  if dlgOpenFile.Execute then
  begin
    // ????????
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // ???????????
    ClearAllData;

    // ??????????????????
    try
      // ????INI????????????????
      with TIniFile.Create(IniFileName) do
      try
        WriteString('General', 'Created', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
      finally
        Free;
      end;

      // ????JSON????????????????
      with TStringList.Create do
      try
        Text := '{}';
        SaveToFile(JsonFileName);
      finally
        Free;
      end;

      // ???μ???????
      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;

      // ???ComboBox?в???????????????????
      if cbFileName.Items.IndexOf(IniFileName) < 0 then
      begin
        cbFileName.Items.Add(IniFileName);
        // ?????????б?
        SaveConfigList;
      end;

      // ?????????????
      cbFileName.ItemIndex := cbFileName.Items.IndexOf(IniFileName);

      // ?????′????????????
      LoadConfigFiles(IniFileName, JsonFileName);

      ShowMessage('??????????????: ' + IniFileName);
    except
      on E: Exception do
        ShowMessage('????????????????: ' + E.Message);
    end;
  end;
end;

// ????????????????
procedure TFrmBuildConfig.btnDeleteConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
  DeleteIndex: Integer;
  DeleteFiles: Boolean;
begin
  // ???????е????
  if cbFileName.ItemIndex < 0 then
  begin
    ShowMessage('?????????????????');
    Exit;
  end;

  // ?????е????????????
  DeleteIndex := cbFileName.ItemIndex;
  IniFileName := cbFileName.Items[DeleteIndex];
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // ?????????????????
  DeleteFiles := MessageDlg('?????????????????' + #13#10 +
                            'INI???: ' + IniFileName + #13#10 +
                            'JSON???: ' + JsonFileName,
                            mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes;

  // ????????????????????
  if MessageDlg('???????б??????????????', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // ??????????????????????
  if DeleteFiles then
  begin
    try
      // ???INI???
      if FileExists(IniFileName) then
        DeleteFile(IniFileName);

      // ???JSON???
      if FileExists(JsonFileName) then
        DeleteFile(JsonFileName);
    except
      on E: Exception do
      begin
        ShowMessage('?????????: ' + E.Message);
        Exit;
      end;
    end;
  end;

  // ??ComboBox????????
  cbFileName.Items.Delete(DeleteIndex);

  // ?????????б?
  SaveConfigList;

  // ???????????
  ClearAllData;
  FCurrentIniFile := '';
  FCurrentJsonFile := '';

  // ???????????????????????
  if cbFileName.Items.Count > 0 then
  begin
    cbFileName.ItemIndex := 0;
    cbFileNameChange(nil);
  end;

  ShowMessage('????????б??????');
end;

procedure TFrmBuildConfig.btnKeyClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // ????????????????
  PropertyName := GetNewPropertyName('Password');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('????????', '?????????????????????洢??:', PropertyValue) then Exit;

  // ?????????????????????
  // ???: PropertyValue := EncryptPassword(PropertyValue);

  // ?????????
  AddPropertyToGrid(PropertyName, '????', PropertyValue);
end;

procedure TFrmBuildConfig.btnRegClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // ?????????????????????
  PropertyName := GetNewPropertyName('RegEx');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('?????????????, '???????????????', PropertyValue) then Exit;

  // ?????????????????????????
  // ???: if not IsValidRegEx(PropertyValue) then ...

  // ?????????
  AddPropertyToGrid(PropertyName, '?????????, PropertyValue);
end;

procedure TFrmBuildConfig.btnEMailClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // ???????????????????
  PropertyName := GetNewPropertyName('Email');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('???????????, '?????????????', PropertyValue) then Exit;

  // ???????????????????????
  // ???: if not IsValidEmail(PropertyValue) then ...

  // ?????????
  AddPropertyToGrid(PropertyName, '???????, PropertyValue);
end;

procedure TFrmBuildConfig.btnUrlClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // ????URL????????
  PropertyName := GetNewPropertyName('URL');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('URL????', '??????URL???:', PropertyValue) then Exit;

  // ???????????URL??????
  // ???: if not IsValidURL(PropertyValue) then ...

  // ?????????
  AddPropertyToGrid(PropertyName, 'URL', PropertyValue);
end;


procedure TFrmBuildConfig.InitializeValidator;
begin
  // ?????????
  FValidator :: TConfigValidator.Create;;

  // ???????????
  // ??????????
  FValidator.AddNumericRule('General/ctPlain.Number', 'Number');

  // ?????????
  FValidator.AddRequiredRule('General/ctPlain.Text', 'Text', '?????????????');

  // ??Χ???
  FValidator.AddRangeRule('General/ctPlain.Age', 'Age', 0, 120, '????????????120???');

  // ????????????
  FValidator.AddRegexRule('General/ctPlain.Email', 'Email', '^[\w\.-]+@[\w\.-]+\.[\w]+$', '????????????);

  // ????????
  FValidator.AddCustomRule('General/ctPlain.Password', 'Password',
    function(const Value: string): Boolean
    begin
      // ???????????8λ
      Result := Length(Value) >= 8;
    end,
    '???????????8λ');
end;

function TFrmBuildConfig.ValidateConfig: Boolean;
var
  JSONObj: TJSONObject;
  i: Integer;
  Section, Key, Value: string;
begin
  // ?????????????
  FValidator.Results.Clear;

  // ???INI????
  for i := 1 to sgINI.RowCount - 1 do
  begin
    if (sgINI.Cells[0, i] <> '') and (sgINI.Cells[1, i] <> '') then
    begin
      Section := sgINI.Cells[0, i];
      Key := sgINI.Cells[1, i];
      Value := sgINI.Cells[2, i];

      ValidateINIProperty(Section, Key, Value);
    end;
  end;

  // ???JSON????
  // ???????????JSON???????????

  // ???????????
  Result := FValidator.Results.Count = 0;;

  // ?????????????????????
  if not Result then
    ShowValidationResults;
end;

function TFrmBuildConfig.ValidateINIProperty(const Section, Key, Value: string): Boolean;
begin
  // ???????????????
  Result := FValidator.ValidateINI(Section, Key, Value);
end;

procedure TFrmBuildConfig.ShowValidationResults;
var
  ValidationForm: TfrmValidation;
begin
  // ????????????????
  ValidationForm := TfrmValidation.Create(Self);
  try
    // ??????????????
    ValidationForm.OnSelectProperty := procedure(const Path, Name: string)
    begin
      // ????????????????????????
      // ???磬???????в??????ж??????
      for var i := 1 to sgINI.RowCount - 1 do
      begin
        if (sgINI.Cells[0, i] + '/' + sgINI.Cells[1, i] = Path) or
           (sgINI.Cells[1, i] = Name) then
        begin
          sgINI.Row := i;
          Break;
        end;
      end;
    end;

    // ??????????
    ValidationForm.ShowResults(FValidator.Results);
  finally
    ValidationForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnValidateClick(Sender: TObject);
begin
  // ???????
  if ValidateConfig then
    ShowMessage('?????????????????????????');
end;

procedure TFrmBuildConfig.InitializeValidator;
begin
  FValidator := TConfigValidator.Create;

  // ??????????
  FValidator.AddNumericRule('General/ctPlain.Number', 'Number');
  FValidator.AddRequiredRule('General/ctPlain.Text', 'Text', '?????????????');
  FValidator.AddRangeRule('General/ctPlain.Age', 'Age', 0, 120, '?????????0??120???');
  FValidator.AddRegexRule('General/ctPlain.Email', 'Email', '^[\w\.-]+@[\w\.-]+\.[\w]+, '???????????');
  FValidator.AddRegexRule('General/ctPlain.URL', 'URL', '^(https?|ftp)://[^\s/$.?#].[^\s]*, 'URL????????');
  FValidator.AddRegexRule('General/ctPlain.Phone', 'Phone', '^1[3-9]\d{9}, '????????????');
  FValidator.AddCustomRule('General/ctComplex.DateTimeRange', 'StartDateTime', 'ValidateDateTimeRange', '??????????????????');
  FValidator.AddFileExistsRule('General/ctPlain.FilePath', 'FilePath', '?????????');
  FValidator.AddDirectoryExistsRule('General/ctPlain.DirectoryPath', 'DirectoryPath', '????????');
end;

function TFrmBuildConfig.ValidateDateTimeRange(const PropertyType, PropertyName: string; Value: TJSONObject): Boolean;
var
  StartDateTime, EndDateTime: TDateTime;
begin
  Result := True;
  if not Value.TryGetValue<TDateTime>('StartDateTime', StartDateTime) then Exit;
  if not Value.TryGetValue<TDateTime>('EndDateTime', EndDateTime) then Exit;
  Result := StartDateTime <= EndDateTime;
end;

procedure TFrmBuildConfig.InitializeValidator;
begin
  FValidator := TConfigValidator.Create;

  // 娣诲姞楠岃瘉瑙勫垯
  FValidator.AddNumericRule('General/ctPlain.Number', 'Number');
  FValidator.AddRequiredRule('General/ctPlain.Text', 'Text', '鏂囨湰灞炴�т笉鑳戒负绌?);
  FValidator.AddRangeRule('General/ctPlain.Age', 'Age', 0, 120, '骞撮緞蹇呴』鍦?鍒?20涔嬮棿');
  FValidator.AddRegexRule('General/ctPlain.Email', 'Email', '^[\w\.-]+@[\w\.-]+\.[\w]+, '閭鏍煎紡涓嶆纭?);
  FValidator.AddRegexRule('General/ctPlain.URL', 'URL', '^(https?|ftp)://[^\s/$.?#].[^\s]*, 'URL鏍煎紡涓嶆纭?);
  FValidator.AddRegexRule('General/ctPlain.Phone', 'Phone', '^1[3-9]\d{9}, '鎵嬫満鍙锋牸寮忎笉姝ｇ‘');
  FValidator.AddCustomRule('General/ctComplex.DateTimeRange', 'StartDateTime', 'ValidateDateTimeRange', '寮�濮嬫椂闂翠笉鑳芥櫄浜庣粨鏉熸椂闂?);
  FValidator.AddFileExistsRule('General/ctPlain.FilePath', 'FilePath', '鏂囦欢涓嶅瓨鍦?);
  FValidator.AddDirectoryExistsRule('General/ctPlain.DirectoryPath', 'DirectoryPath', '鐩綍涓嶅瓨鍦?);
end;

function TFrmBuildConfig.ValidateDateTimeRange(const PropertyType, PropertyName: string; Value: TJSONObject): Boolean;
var
  StartDateTime, EndDateTime: TDateTime;
begin
  Result := True;
  if not Value.TryGetValue<TDateTime>('StartDateTime', StartDateTime) then Exit;
  if not Value.TryGetValue<TDateTime>('EndDateTime', EndDateTime) then Exit;
  Result := StartDateTime <= EndDateTime;
end;

end.
