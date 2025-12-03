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
  UtilsTypes, ControllerConfigs, JSONHelpers, ConfigValidator;

type
  TSimplePropertyType = (
    sptText,     // 鏂囨湰
    sptNumber,   // 鏁板瓧
    sptRelPath,  // 鐩稿璺緞
    sptBoolean,  // 甯冨皵鍊?
    sptDate,     // 鏃ユ湡
    sptColor,    // 棰滆壊
    sptTime,     // 鏃堕棿
    sptFileName, // 鏂囦欢鍚?
    sptFilePath, // 鐩綍+鏂囦欢
    sptAbsPath,  // 缁濆璺緞
    sptIPAddress // IP鍦板潃
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
    // 娣诲姞灞炴€х偣鍑讳簨浠?
    procedure btnAddSectionClick(Sender: TObject);
    // 娣诲姞绌鸿鐐瑰嚮浜嬩欢
    procedure btnAddEmptyLineClick(Sender: TObject);
    // 娣诲姞鏍硅矾寰勬寜閽偣鍑讳簨浠?
    procedure btnRootPathClick(Sender: TObject);
    // 娣诲姞鏂囦欢鍚嶆寜閽偣鍑讳簨浠?
    procedure btnFileNameClick(Sender: TObject);
    // 娣诲姞缁濆璺緞鎸夐挳鐐瑰嚮浜嬩欢
    procedure btnAbsPathClick(Sender: TObject);
    // 娣诲姞鐩稿璺緞鎸夐挳鐐瑰嚮浜嬩欢
    procedure btnRePathClick(Sender: TObject);
    // interface 鏂规硶
    procedure pcAttributeChange(Sender: TObject);
    procedure btnEmptyLineClick(Sender: TObject);
    procedure btnReFileNameClick(Sender: TObject);
    procedure btnAbsFilenameClick(Sender: TObject);
    procedure btnSectionClick(Sender: TObject);
    // 娣诲姞淇濆瓨閰嶇疆鎸夐挳鐐瑰嚮浜嬩欢
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnNewConfigClick(Sender: TObject);
    procedure btnDeleteConfigClick(Sender: TObject);
    procedure cbFileNameChange(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    // 娣诲姞閿€煎鎸夐挳鐐瑰嚮浜嬩欢
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
    FCurrentEditNode: TTreeNode; // 褰撳墠缂栬緫鐨凧SON鑺傜偣
    FCurrentEditor: TFrame;      // 褰撳墠浣跨敤鐨勭紪杈慒rame
    FConfigListFile: string;     // 閰嶇疆鍒楄〃鏂囦欢璺緞

    // 鍏ㄥ眬鐨凷tringGrid鍗曞厓鏍兼暟鎹?
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

    // 鏁版嵁搴撶紪杈戠殑鍥炶皟
    procedure OnDBSave(Sender: TObject);
    procedure OnDBCancel(Sender: TObject);

    procedure ShowEditorForNode(Node: TTreeNode);
    procedure EditorSaveClick(Sender: TObject);
    procedure EditorCancelClick(Sender: TObject);
    procedure LoadNodeDataToEditor(Node: TTreeNode; EditorFrame: TFrame);
    procedure SaveEditorDataToNode;

    // 淇濆瓨閰嶇疆鍒楄〃
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

implementation

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
    FValidator.Free;
  inherited;
end;

procedure TFrmBuildConfig.FormCreate(Sender: TObject);
begin
  // 鍒濆鍖栨鏋?
  InitializeFrame;

  // 涓烘寜閽缃瓾int
  btnAddText.Hint := '娣诲姞鏂囨湰';
  btnAddNumber.Hint := '娣诲姞鏁板瓧';
  btnRootPath.Hint := '娣诲姞鏍硅矾寰?;
  btnAddBoolean.Hint := '娣诲姞甯冨皵鍊?(鏄?鍚?';
  btnAddDate.Hint := '娣诲姞鏃ユ湡';
  btnAddColor.Hint := '娣诲姞棰滆壊';
  btnAddFont.Hint := '娣诲姞瀛椾綋';
  btnAddColorComplex.Hint := '娣诲姞棰滆壊澶嶆潅';
  btnAddDatabase.Hint := '娣诲姞鏁版嵁搴?;
  btnAddList.Hint := '娣诲姞鍒楄〃';
  btnAddObject.Hint := '娣诲姞瀵硅薄';
  btnAddArray.Hint := '娣诲姞鏁扮粍';
  btnAbsPath.Hint := '娣诲姞缁濆璺緞';
  btnRePath.Hint := '娣诲姞鐩稿璺緞';
  btnSection.Hint := '娣诲姞鍒嗛殧绗?;
  btnEmptyLine.Hint := '娣诲姞绌鸿';
  btnSaveConfig.Hint := '淇濆瓨褰撳墠閰嶇疆鏂囦欢';
  btnNewConfig.Hint := '鏂板缓閰嶇疆鏂囦欢';
  btnDeleteConfig.Hint := '鍒犻櫎褰撳墠閰嶇疆鏂囦欢';

  // 涓烘寜閽缃甌ag
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

  // 娣诲姞鎸夐挳鐨凾ag
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

  // 娣诲姞鎸夐挳鐨凾ag
  btnAddBgDraw.Tag := Integer(cptBgDraw);
  btnAddTextOnBg.Tag := Integer(cptTextOnBg);
  btnAddImageOnBg.Tag := Integer(cptImageOnBg);
  btnAddCaptionOnBg.Tag := Integer(cptCaptionOnBg);
  btnAddVideoClip.Tag := Integer(cptVideoClip);
  btnAddVideo.Tag := Integer(cptVideo);

  // 涓烘寜閽缃瓾int
  btnAddDateTimeRange.Hint := '娣诲姞鏃堕棿鑼冨洿';
  btnAddKeyValueDict.Hint := '娣诲姞閿€煎锛屽瓨鍌ㄥ姩鎬佸€?;
  btnAddUrlConfig.Hint := '娣诲姞URL锛屽瓨鍌ㄥ姩鎬佸€?;
  btnAddPermission.Hint := '娣诲姞鏉冮檺';
  btnAddNetConfig.Hint := '娣诲姞缃戠粶閰嶇疆';
  btnAddEncrypt.Hint := '娣诲姞鍔犲瘑';
  btnAddGeoLocation.Hint := '娣诲姞鍦扮悊浣嶇疆';
  btnAddMediaSettings.Hint := '娣诲姞濯掍綋璁剧疆';
  btnAddChartConfig.Hint := '娣诲姞鍥捐〃閰嶇疆';
  btnAddWorkflow.Hint := '娣诲姞宸ヤ綔娴?;
  btnAddSchedule.Hint := '娣诲姞璋冨害';
  btnAddI18n.Hint := '娣诲姞鍥介檯鍖?;
  btnAddUnitConversion.Hint := '娣诲姞鍗曚綅杞崲';
  btnAddVersionControl.Hint := '娣诲姞鐗堟湰鎺у埗';

  // 楠岃瘉鎸夐挳
  btnValidate := TButton.Create(Self);
  btnValidate.Parent := pnlButtons;
  btnValidate.Left := btnSave.Left + btnSave.Width + 10;
  btnValidate.Top := btnSave.Top;
  btnValidate.Width := 75;
  btnValidate.Height := 25;
  btnValidate.Caption := '楠岃瘉';
  btnValidate.Hint := '楠岃瘉閰嶇疆鏄惁鏈夋晥';
  btnValidate.OnClick := btnValidateClick;

  // 涓烘寜閽缃瓾int
  btnAddBgDraw.Hint := '鍦ㄥ浘鍍忎笂缁樺埗鍏冪礌';
  btnAddTextOnBg.Hint := '鍦ㄥ浘鍍忎笂缁樺埗鏂囨湰';
  btnAddImageOnBg.Hint := '鍦ㄥ浘鍍忎笂缁樺埗鍥惧儚';
  btnAddCaptionOnBg.Hint := '鍦ㄥ浘鍍忎笂缁樺埗鏂囨湰';
  btnAddVideoClip.Hint := '娣诲姞瑙嗛鍓緫';
  btnAddVideo.Hint := '娣诲姞瑙嗛';

  // 閰嶇疆鍒楄〃鏂囦欢
  FConfigListFile := ExtractFilePath(Application.ExeName) + 'ConfigList.ini';
  LoadConfigList;
end;

procedure TFrmBuildConfig.FormDestroy(Sender: TObject);
begin
  // 淇濆瓨閰嶇疆鍒楄〃
  SaveConfigList;

  // 閲婃斁鎵€鏈夋暟鎹?
  ClearAllData;
end;

procedure TFrmBuildConfig.InitializeFrame;
begin
  // 鍒濆鍖栨鏋?
  // 浣跨敤榛樿鍊硷紝涓嶄娇鐢ㄤ换浣曢厤缃?
end;

procedure TFrmBuildConfig.InitializeGridColumns;
begin
  // 鍒濆鍖朣tringGrid
  if not Assigned(sgINI) then Exit;

  try
    // 鍒濆鍖朣tringGrid
    if sgINI.ColCount < 3 then sgINI.ColCount := 3;
    if sgINI.RowCount < 2 then sgINI.RowCount := 2;

    // 璁剧疆鍒楁爣棰?
    SetGridCell(0, 0, '鍚嶇О');
    SetGridCell(1, 0, '绫诲瀷');
    SetGridCell(2, 0, '鍊?);

    // 璁剧疆绗竴琛屼负Json鏂囦欢鍚?
    SetGridCell(0, 1, 'Json鏂囦欢鍚?);
    SetGridCell(1, 1, '鍚嶇О');
    SetGridCell(2, 1, '');

    // 璁剧疆鍒楀搴?
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
  // 鎸夐挳鐨勭偣鍑讳簨浠堕渶瑕佸垵濮嬪寲
end;

procedure TFrmBuildConfig.InitializePopupMenus;
begin
  // 鍙抽敭鑿滃崟鐨勫垵濮嬪寲闇€瑕侀€氳繃Object Inspector杩涜
  // 鍙抽敭鑿滃崟鐨勫垵濮嬪寲闇€瑕侀€氳繃Object Inspector杩涜
end;

procedure TFrmBuildConfig.InitializeDragDrop;
begin
  // 鎷栨斁浜嬩欢鐨勫垵濮嬪寲
end;

procedure TFrmBuildConfig.ReorganizeButtons;
begin
  // 閲嶆柊缁勭粐鎸夐挳
  // 閲嶆柊缁勭粐鎸夐挳
  btnAddText.OnClick := btnAddTextClick;
  btnAddNumber.OnClick := btnAddNumberClick;
  btnRootPath.OnClick := btnRootPathClick;
  btnAddBoolean.OnClick := btnAddBooleanClick;
  btnAddDate.OnClick := btnAddDateClick;
  btnAddColor.OnClick := btnAddColorClick;

  // 閲嶆柊缁勭粐鎸夐挳
  btnAddFont.OnClick := btnAddFontClick;
  btnAddColorComplex.OnClick := btnAddColorComplexClick;
  btnAddDatabase.OnClick := btnAddDatabaseClick;
  btnAddList.OnClick := btnAddListClick;
  btnAddObject.OnClick := btnAddObjectClick;
  btnAddArray.OnClick := btnAddArrayClick;

  // 缁濆璺緞鎸夐挳
  btnAbsPath.OnClick := btnAbsPathClick;
  btnRePath.OnClick := btnRePathClick;

  // 缁撴瀯鎸夐挳
  btnSection.OnClick := btnSectionClick;
  btnEmptyLine.OnClick := btnEmptyLineClick;

  // 鏂囦欢鎸夐挳
  btnSaveConfig.OnClick := btnSaveConfigClick;
  btnNewConfig.OnClick := btnNewConfigClick;
  btnDeleteConfig.OnClick := btnDeleteConfigClick;

  // 閿€煎鎸夐挳
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
  // 纭畾绗竴琛屼负"Json鏂囦欢鍚?
  if sgINI.RowCount <= 1 then
  begin
    sgINI.RowCount := 2; // 纭畾娣诲姞涓€琛?
  end;

  // 绗竴琛屼负鍥哄畾鐨?Json鏂囦欢鍚?
  SetGridCell(0, 1, 'Json鏂囦欢鍚?);
  SetGridCell(1, 1, '鍚嶇О');

  // 妫€鏌ユ槸鍚﹀瓨鍦ㄧ浉鍚岀殑鍚嶇О
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
    // 鎵惧埌鐩稿悓鐨勫悕绉?
    Row := foundRow;
  end
  else
  begin
    // 娌℃湁鎵惧埌鐩稿悓鐨勫悕绉?
    Row := sgINI.RowCount;
    sgINI.RowCount := Row + 1;
  end;

  // 璁剧疆鍗曞厓鏍肩殑鍊?
  SetGridCell(0, Row, PropertyName);
  SetGridCell(1, Row, PropertyType);
  SetGridCell(2, Row, PropertyValue);

  // 鏇存柊INI鏄剧ず
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

  // 鏄剧ず缂栬緫妗?
  FCurrentJsonNode := Node;
  FIsEditing := True;
  edtEditing.Text := TTreeNode(Node).Text;
  pnlEditing.Visible := True;
end;

procedure TFrmBuildConfig.HidePropertyEditor;
begin
  // 闅愯棌缂栬緫妗?
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

  // 娓呯┖INI鏂囦欢
  SetGridCell(0, 1, '');
  SetGridCell(1, 1, '');
  SetGridCell(2, 1, '');
  sgINI.RowCount := 2; // 璁剧疆涓哄垵濮嬬姸鎬?

  // 璇诲彇INI鏂囦欢
  IniFile := TIniFile.Create(FileName);
  Sections := TStringList.Create;
  Keys := TStringList.Create;

  try
    // 璇诲彇鎵€鏈夎妭
    IniFile.ReadSections(Sections);

    // 濡傛灉瀛樺湪鑺?
    if Sections.Count > 0 then
    begin
      // 娓呯┖鎵€鏈夎
      sgINI.RowCount := 1;

      // 閬嶅巻姣忎釜鑺?
      for i := 0 to Sections.Count - 1 do
      begin
        Section := Sections[i];
        Keys.Clear;

        // 璇诲彇鑺備腑鐨勯敭
        IniFile.ReadSection(Section, Keys);

        // 閬嶅巻姣忎釜閿?
        for j := 0 to Keys.Count - 1 do
        begin
          Key := Keys[j];
          Value := IniFile.ReadString(Section, Key, '');

          // 娣诲姞灞炴€?
          AddPropertyToGrid(Section, Key, Value);
        end;
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
  // 淇濆瓨INI鏂囦欢
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
      if not IsGridCellEmpty(0, i) and not IsGridCellEmpty(1, i) then
      begin
        Section := GetGridCell(0, i);
        Key := GetGridCell(1, i);
        Value := GetGridCell(2, i);

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

      // 鏍规嵁鍊肩‘瀹氱紪杈戠被鍨?
      if Pair.JsonValue is TJSONObject then
        EditorType := etObject
      else if Pair.JsonValue is TJSONArray then
        EditorType := etArray
      else
        EditorType := etPlain;

      // 娣诲姞灞炴€?
      ChildNode := AddPropertyToTree(Pair.JsonString.Value, Pair.JsonValue.ClassName,
                                     Pair.JsonValue.ToString, EditorType, ParentNode);

      // 閫掑綊澶勭悊瀛愯妭鐐?
      if Pair.JsonValue is TJSONObject then
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

  // 娓呯┖JSON鏍?
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

      // 灞曞紑鎵€鏈夎妭鐐?
      tvJSON.FullExpand;

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

      // 娣诲姞瀛愯妭鐐?
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
      // 鍒涘缓鏁扮粍
      JsonArray := TJSONArray.Create;

      // 娣诲姞瀛愯妭鐐?
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
      // 鍒涘缓瀵硅薄
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
  // 鍒涘缓鏍瑰璞?
  RootObject := TJSONObject.Create;

  // 鑾峰彇鏍硅妭鐐?
  RootNode := tvJSON.Items.GetFirstNode;
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
  MeoINI.Lines.Clear;

  // 娣诲姞INI鏂囦欢澶翠俊鎭?
  MeoINI.Lines.Add('[Config]');

  // 閬嶅巻鎵€鏈夎
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

    // 娣诲姞缂╄繘
    IndentStr := StringOfChar(' ', Indent * 2);

    PropItem := PConfigPropertyItem(Node.Data);

    // 澶勭悊鑺傜偣鏂囨湰
    if PropItem^.EditorType = etObject then
    begin
      // 寮€濮?
      NodeText := IndentStr + '"' + Node.Text + '": {';
      MeoJSON.Lines.Add(NodeText);

      // 娣诲姞瀛愯妭鐐?
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 濡傛灉褰撳墠鑺傜偣鏈夊厔寮熻妭鐐癸紝娣诲姞閫楀彿
        if ChildNode.getNextSibling <> nil then
          MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 缁撴潫
      MeoJSON.Lines.Add(IndentStr + '}');
    end
    else if PropItem^.EditorType = etArray then
    begin
      // 寮€濮?
      NodeText := IndentStr + '"' + Node.Text + '": [';
      MeoJSON.Lines.Add(NodeText);

      // 娣诲姞瀛愯妭鐐?
      ChildNode := Node.getFirstChild;
      while ChildNode <> nil do
      begin
        ProcessNode(ChildNode, Indent + 1);

        // 濡傛灉褰撳墠鑺傜偣鏈夊厔寮熻妭鐐癸紝娣诲姞閫楀彿
        if ChildNode.getNextSibling <> nil then
          MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

        ChildNode := ChildNode.getNextSibling;
      end;

      // 缁撴潫
      MeoJSON.Lines.Add(IndentStr + ']');
    end
    else
    begin
      // 鍒涘缓瀵硅薄
      NodeText := IndentStr + '"' + Node.Text + '": "' + PropItem^.PropertyValue + '"';
      MeoJSON.Lines.Add(NodeText);
    end;
  end;

var
  RootNode: TTreeNode;
begin
  // 娓呯┖JSON鏄剧ず
  MeoJSON.Lines.Clear;

  // 寮€濮婮SON
  MeoJSON.Lines.Add('{');

  // 鑾峰彇鏍硅妭鐐?
  RootNode := tvJSON.Items.GetFirstNode;
  while RootNode <> nil do
  begin
    ProcessNode(RootNode, 1);

    // 濡傛灉褰撳墠鑺傜偣鏈夊厔寮熻妭鐐癸紝娣诲姞閫楀彿
    if RootNode.getNextSibling <> nil then
      MeoJSON.Lines[MeoJSON.Lines.Count - 1] := MeoJSON.Lines[MeoJSON.Lines.Count - 1] + ',';

    RootNode := RootNode.getNextSibling;
  end;

  // 缁撴潫JSON
  MeoJSON.Lines.Add('}');
end;

procedure TFrmBuildConfig.ClearAllData;
var
  i: Integer;
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 娓呯┖TreeView涓殑鎵€鏈夎妭鐐?
  // 娓呯┖鎵€鏈夋暟鎹?
  if not Assigned(tvJSON) or (tvJSON.Items.Count = 0) then Exit;

  for i := 0 to tvJSON.Items.Count - 1 do
  begin
    Node := tvJSON.Items[i];
    if Assigned(Node.Data) then
    begin
      PropItem := PConfigPropertyItem(Node.Data);
      Dispose(PropItem); // 閲婃斁鍐呭瓨
      Node.Data := nil;  // 闃叉閲庢寚閽?
    end;
  end;

  // 閲嶆柊璁剧疆
  // 閲嶆柊璁剧疆涓?琛?1鍒楁暟鎹紝鍙繚鐣欐爣棰樿
  sgINI.RowCount := 2;
  SetGridCell(0, 1, '');
  SetGridCell(1, 1, '');
  SetGridCell(2, 1, '');

  tvJSON.Items.Clear;
  MeoINI.Clear;
  MeoJSON.Clear;
end;

function TFrmBuildConfig.GetPropertyInputFromUser(const Caption, Prompt: string; var Value: string): Boolean;
begin
  // 鐢ㄦ埛杈撳叆
  Result := InputQuery(Caption, Prompt, Value);
end;

function TFrmBuildConfig.GetNewPropertyName(const DefaultName: string = ''): string;
var
  NewName: string;
begin
  NewName := DefaultName;
  if GetPropertyInputFromUser('鍚嶇О', '璇疯緭鍏ュ悕绉?', NewName) then
    Result := NewName
  else
    Result := DefaultName;
end;

function TFrmBuildConfig.GetColorValue: string;
begin
  // 鑾峰彇棰滆壊鍊?
  Result := '';
  if dlgSelectColor.Execute then
    Result := Format('$%.8x', [dlgSelectColor.Color]);
end;

function TFrmBuildConfig.GetPathValue: string;
begin
  // 鑾峰彇璺緞鍊?
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
  // 娣诲姞鏂囨湰灞炴€?
  PropertyName := GetNewPropertyName('Text');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('鏂囨湰', '璇疯緭鍏ユ枃鏈?', PropertyValue) then Exit;

  // 娣诲姞灞炴€?
  AddPropertyToGrid(PropertyName, '鏂囨湰', PropertyValue);
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
  // 娣诲姞鏁板瓧灞炴€?
  PropertyName := GetNewPropertyName('Number');
  if PropertyName = '' then Exit;

  PropertyValue := '0';
  if not GetPropertyInputFromUser('鏁板瓧', '璇疯緭鍏ユ暟瀛?', PropertyValue) then Exit;

  // 楠岃瘉鏄惁涓烘湁鏁堟暟瀛?
  try
    Value := StrToFloat(PropertyValue);
  except
    on E: Exception do
    begin
      ShowMessage('鏃犳晥鐨勬暟瀛?);
      Exit;
    end;
  end;

  // 娣诲姞灞炴€?
  AddPropertyToGrid(PropertyName, '鏁板瓧', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddPathClick(Sender: TObject);
var
  PropertyName: string;
  PathValue: string;
begin
  // 娣诲姞璺緞灞炴€?
  PropertyName := GetNewPropertyName('Path');
  if PropertyName = '' then Exit;

  // 鑾峰彇璺緞
  PathValue := GetPathValue;
  if PathValue = '' then Exit;

  // 娣诲姞灞炴€?
  AddPropertyToGrid(PropertyName, '璺緞', PathValue);
end;

procedure TFrmBuildConfig.btnAddBooleanClick(Sender: TObject);
var
  PropertyName: string;
  BoolStr: string;
begin
  // 娣诲姞甯冨皵鍊煎睘鎬?
  PropertyName := GetNewPropertyName('Boolean');
  if PropertyName = '' then Exit;

  // 鐢ㄦ埛閫夋嫨甯冨皵鍊?
  BoolStr := 'True';

  // 娣诲姞灞炴€?
  AddPropertyToGrid(PropertyName, '甯冨皵鍊?, BoolStr);
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
  // 娣诲姞鏃ユ湡灞炴€?
  PropertyName := GetNewPropertyName('Date');
  if PropertyName = '' then Exit;

  // 閫夋嫨鏃ユ湡
  DateForm := TForm.Create(Self);
  try
    DateForm.Caption := '閫夋嫨鏃ユ湡';
    DateForm.Position := poScreenCenter;
    DateForm.Width := 300;
    DateForm.Height := 150;
    DateForm.BorderStyle := bsDialog;

    // 娣诲姞鏃ユ湡閫夋嫨鍣?
    DatePicker := TDateTimePicker.Create(DateForm);
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

    // 鏄剧ず瀵硅瘽妗?
    if DateForm.ShowModal = mrOK then
    begin
      DateValue := DatePicker.Date;
      DateStr := FormatDateTime('yyyy-mm-dd', DateValue);

      // 娣诲姞灞炴€?
      AddPropertyToGrid(PropertyName, '鏃ユ湡', DateStr);
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
  // 娣诲姞棰滆壊灞炴€?
  PropertyName := GetNewPropertyName('Color');
  if PropertyName = '' then Exit;

  // 鑾峰彇棰滆壊
  ColorValue := GetColorValue;
  if ColorValue = '' then Exit;

  // 娣诲姞灞炴€?
  AddPropertyToGrid(PropertyName, '棰滆壊', ColorValue);
end;

procedure TFrmBuildConfig.btnAddFontClick(Sender: TObject);
var
  PropertyName: string;
  FontDialog: TFontDialog;
  FontStr: string;
begin
  // 娣诲姞瀛椾綋灞炴€?
  PropertyName := GetNewPropertyName('Font');
  if PropertyName = '' then Exit;

  // 閫夋嫨瀛椾綋
  FontDialog := TFontDialog.Create(Self);
  try
    // 浣跨敤榛樿璁剧疆
    FontDialog.Font.Name := 'Arial';
    FontDialog.Font.Size := 10;
    FontDialog.Font.Style := [];

    // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?
    if FontDialog.Execute then
    begin
      // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?
      FontStr := Format('%s,%d,%s,%s,%s,%s', [
        FontDialog.Font.Name,
        FontDialog.Font.Size,
        BoolToStr(fsBold in FontDialog.Font.Style, True),
        BoolToStr(fsItalic in FontDialog.Font.Style, True),
        BoolToStr(fsUnderline in FontDialog.Font.Style, True),
        ColorToString(FontDialog.Font.Color)
      ]);

      // 娣诲姞灞炴€?
      AddPropertyToGrid(PropertyName, '瀛椾綋', FontStr);
    end;
  finally
    FontDialog.Free;
  end;
end;

procedure TFrmBuildConfig.btnAddColorComplexClick(Sender: TObject);
begin
  // 娣诲姞棰滆壊澶嶆潅灞炴€?
end;

procedure TFrmBuildConfig.btnAddDatabaseClick(Sender: TObject);
var
  PropertyName: string;
  Node: TTreeNode;
begin
  // 娣诲姞鏁版嵁搴撳睘鎬?
  PropertyName := GetNewPropertyName('Database');
  if PropertyName = '' then Exit;

  // 娣诲姞瀛愯妭鐐?
  Node := AddPropertyToTree(PropertyName, 'TJSONObject', '{"ConnectionString":""}', etDatabase);

  // 閫夋嫨瀛愯妭鐐?
  tvJSON.Selected := Node;

  // 鍒囨崲鍒扮紪杈戦〉闈?
  PageControl1.ActivePage := tsEditor;

  // 娓呯┖缂栬緫鍐呭
  while pnlEditorContent.ControlCount > 0 do
    pnlEditorContent.Controls[0].Free;

  // 鏄剧ず缂栬緫妗?
  ShowEditorForNode(Node);

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
  // 娣诲姞鍒楄〃灞炴€?
  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  // 鍒涘缓鍒楄〃缂栬緫妗?
  ListForm := TForm.Create(Self);
  try
    ListForm.Caption := '鍒楄〃缂栬緫';
    ListForm.Position := poScreenCenter;
    ListForm.Width := 400;
    ListForm.Height := 350;
    ListForm.BorderStyle := bsDialog;

    // 娣诲姞鍒楄〃缂栬緫妗?
    ListEditor := TFrameListEditor.Create(ListForm);
    ListEditor.Parent := ListForm;
    ListEditor.Align := alClient;

    // 娣诲姞鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ListForm);
    ButtonPanel.Parent := ListForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 娣诲姞纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 娣诲姞鍙栨秷鎸夐挳
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

    // 鏄剧ず瀵硅瘽妗?
    if ListForm.ShowModal = mrOK then
    begin
      // 淇濆瓨鍒楄〃JSON
      ListEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 灏嗗垪琛ㄨ浆鎹负瀛楃涓?
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

      // 娣诲姞灞炴€?- 杞崲涓哄瓧绗︿覆
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etList))) + '.' + PropertyName, ListStr);

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
  // ObjectEditor: TFrameObjectEditor;
  ObjectForm: TForm;
  JSONObj: TJSONObject;
begin
  // 涓嶄娇鐢‵rameObjectEditor锛屽洜涓鸿繖闇€瑕佷娇鐢═FrameObjectEditor鍗曞厓
  ShowMessage('娣诲姞瀵硅薄灞炴€ч渶瑕佷娇鐢═FrameObjectEditor鍗曞厓');
  Exit;
  
  // 涓嶄娇鐢∣bjectEditor锛屽洜涓鸿繖闇€瑕佷娇鐢═FrameObjectEditor鍗曞厓
  {
  // 娣诲姞瀵硅薄灞炴€?
  PropertyName := GetNewPropertyName('Object');
  if PropertyName = '' then Exit;

  // 鍒涘缓瀵硅薄缂栬緫妗?
  ObjectForm := TForm.Create(Self);
  try
    ObjectForm.Caption := '瀵硅薄缂栬緫';
    ObjectForm.Position := poScreenCenter;
    ObjectForm.Width := 500;
    ObjectForm.Height := 400;
    ObjectForm.BorderStyle := bsDialog;

    // 娣诲姞瀵硅薄缂栬緫妗?
    ObjectEditor := TFrameObjectEditor.Create(ObjectForm);
    ObjectEditor.Parent := ObjectForm;
    ObjectEditor.Align := alClient;

    // 娣诲姞鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ObjectForm);
    ButtonPanel.Parent := ObjectForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 娣诲姞纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 娣诲姞鍙栨秷鎸夐挳
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

    // 鏄剧ず瀵硅瘽妗?
    if ObjectForm.ShowModal = mrOK then
    begin
      // 淇濆瓨JSON
      ObjectEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 娣诲姞灞炴€?- 杞崲涓哄瓧绗︿覆
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etObject))) + '.' + PropertyName, JSONObj.ToString);

      // 鏇存柊INI鏄剧ず
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
  // 娣诲姞鏁扮粍灞炴€?
  PropertyName := GetNewPropertyName('Array');
  if PropertyName = '' then Exit;

  // 鍒涘缓鏁扮粍缂栬緫妗?
  ArrayForm := TForm.Create(Self);
  try
    ArrayForm.Caption := '鏁扮粍缂栬緫';
    ArrayForm.Position := poScreenCenter;
    ArrayForm.Width := 500;
    ArrayForm.Height := 400;
    ArrayForm.BorderStyle := bsDialog;

    // 鍒涘缓鏁扮粍缂栬緫妗?
    ArrayEditor := TFrameArrayEditor.Create(ArrayForm);
    ArrayEditor.Parent := ArrayForm;
    ArrayEditor.Align := alClient;

    // 娣诲姞鎸夐挳闈㈡澘
    var ButtonPanel := TPanel.Create(ArrayForm);
    ButtonPanel.Parent := ArrayForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 娣诲姞纭畾鎸夐挳
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '纭畾';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 娣诲姞鍙栨秷鎸夐挳
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

    // 鏄剧ず瀵硅瘽妗?
    if ArrayForm.ShowModal = mrOK then
    begin
      // 淇濆瓨JSON
      ArrayEditor.SaveToJSON;

      // 鑾峰彇褰撳墠閫夋嫨鐨凷ection
      if sgINI.RowCount > 1 then
        Section := GetGridCell(0, 1)
      else
        Section := 'General';

      // 娣诲姞灞炴€?- 杞崲涓哄瓧绗︿覆
      AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etArray))) + '.' + PropertyName, JSONObj.ToString);

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
  // 鑾峰彇褰撳墠閫夋嫨鐨勮
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨勮妭鍜岄敭
  Section := GetGridCell(0, Row);
  Key := GetGridCell(1, Row);
  PropertyValue := GetGridCell(2, Row);

  // 鏍规嵁閿殑鍓嶇紑杩涜涓嶅悓鐨勭紪杈?
  if Key.StartsWith('ctFont.') then
  begin
    // 缂栬緫瀛椾綋
    var FontDialog := TFontDialog.Create(Self);
    try
      // 鑾峰彇瀛椾綋淇℃伅
      var FontParts := PropertyValue.Split([',']);
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

      // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?
      if FontDialog.Execute then
      begin
        // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?
        NewValue := Format('%s,%d,%s,%s,%s,%s', [
          FontDialog.Font.Name,
          FontDialog.Font.Size,
          BoolToStr(fsBold in FontDialog.Font.Style, True),
          BoolToStr(fsItalic in FontDialog.Font.Style, True),
          BoolToStr(fsUnderline in FontDialog.Font.Style, True),
          ColorToString(FontDialog.Font.Color)
        ]);

        // 璁剧疆灞炴€?
        SetGridCell(2, Row, NewValue);

        // 鏇存柊INI鏄剧ず
        UpdateIniMemo;
      end;
    finally
      FontDialog.Free;
    end;
  end
  else if Key.StartsWith('ctColor.') then
  begin
    // 缂栬緫棰滆壊
    var ColorDialog := TColorDialog.Create(Self);
    try
      // 璁剧疆榛樿棰滆壊
      try
        ColorDialog.Color := StringToColor(PropertyValue);
      except
        ColorDialog.Color := clBlack;
      end;

      // 鏄剧ず棰滆壊閫夋嫨瀵硅瘽妗?
      if ColorDialog.Execute then
      begin
        // 灏嗛鑹茶浆鎹负瀛楃涓?
        NewValue := ColorToString(ColorDialog.Color);

        // 璁剧疆灞炴€?
        SetGridCell(2, Row, NewValue);

        // 鏇存柊INI鏄剧ず
        UpdateIniMemo;
      end;
    finally
      ColorDialog.Free;
    end;
  end
  else if Key.StartsWith('ctPlain.') then
  begin
    // 缂栬緫绾枃鏈?
    NewValue := PropertyValue;
    if GetPropertyInputFromUser('缂栬緫鏂囨湰', '璇疯緭鍏ユ枃鏈?', NewValue) then
    begin
      // 璁剧疆灞炴€?
      SetGridCell(2, Row, NewValue);

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
  // 鑾峰彇褰撳墠閫夋嫨鐨勮
  Row := sgINI.Row;
  if (Row < 1) or (Row >= sgINI.RowCount) then Exit;

  // 鑾峰彇褰撳墠鐨勮妭鍜岄敭
  Section := GetGridCell(0, Row);
  Key := GetGridCell(1, Row);
  Value := GetGridCell(2, Row);

  // 鑾峰彇鏂扮殑閿?
  NewKey := Key;
  if GetPropertyInputFromUser('淇敼鍚嶇О', '璇疯緭鍏ユ柊鐨勫悕绉?', NewKey) then
  begin
    // 璁剧疆鏂扮殑閿?
    SetGridCell(1, Row, NewKey);

    // 鏇存柊INI鏄剧ず
    UpdateIniMemo;
  end;
end;

procedure TFrmBuildConfig.DeleteINIPropertyClick(Sender: TObject);
var
  RowIndex, i: Integer;
  PropertyType, PropertyName: string;
begin
  // 鑾峰彇褰撳墠閫夋嫨鐨勮
  RowIndex := sgINI.Row;

  // 妫€鏌ユ槸鍚︿负绌鸿鎴栫┖鍒?
  if (RowIndex <= 1) or (RowIndex >= sgINI.RowCount) then
    Exit;

  // 鑾峰彇褰撳墠閫夋嫨鐨勭被鍨嬪拰鍚嶇О
  PropertyType := GetGridCell(1, RowIndex);
  PropertyName := GetGridCell(0, RowIndex);

  // 妫€鏌ユ槸鍚︿负鍒嗛殧绗?
  if PropertyType = '鍒嗛殧绗? then
  begin
    ShowMessage('鍒嗛殧绗︽棤娉曞垹闄?);
    Exit;
  end;

  // 纭鍒犻櫎
  if MessageDlg('纭畾瑕佸垹闄?"' + PropertyName + '" 鍚?, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 鍒犻櫎琛?
    for i := RowIndex to sgINI.RowCount - 2 do
    begin
      SetGridCell(0, i, GetGridCell(0, i + 1));
      SetGridCell(1, i, GetGridCell(1, i + 1));
      SetGridCell(2, i, GetGridCell(2, i + 1));
      sgINI.Objects[0, i] := sgINI.Objects[0, i + 1];
    end;

    // 鍒犻櫎鏈€鍚庝竴琛?
    if sgINI.RowCount > 2 then
    begin
      SetGridCell(0, sgINI.RowCount - 1, '');
      SetGridCell(1, sgINI.RowCount - 1, '');
      SetGridCell(2, sgINI.RowCount - 1, '');

      // 鍒犻櫎鏈€鍚庝竴琛?
      sgINI.RowCount := sgINI.RowCount - 1;
    end;

    // 纭閫夋嫨
    if RowIndex >= sgINI.RowCount then
      sgINI.Row := sgINI.RowCount - 1;

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
  // 鑾峰彇褰撳墠閫夋嫨鐨勮妭鐐?
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 鏍规嵁缂栬緫绫诲瀷杩涜涓嶅悓鐨勭紪杈?
  case PropItem^.EditorType of
    etPlain:
      begin
        // 缂栬緫绾枃鏈?
        NewValue := PropItem^.PropertyValue;
        if GetPropertyInputFromUser('缂栬緫鏂囨湰', '璇疯緭鍏ユ枃鏈?', NewValue) then
        begin
          // 璁剧疆灞炴€у€?
          PropItem^.PropertyValue := NewValue;

          // 鏇存柊JSON鏄剧ず
          UpdateJsonMemo;
        end;
      end;
    etFont:
      begin
        // 缂栬緫瀛椾綋
        var FontDialog := TFontDialog.Create(Self);
        try
          // 鑾峰彇瀛椾綋淇℃伅
          var FontParts := PropItem^.PropertyValue.Split([',']);
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

          // 鏄剧ず瀛椾綋閫夋嫨瀵硅瘽妗?
          if FontDialog.Execute then
          begin
            // 灏嗗瓧浣撲俊鎭浆鎹负瀛楃涓?
            NewValue := Format('%s,%d,%s,%s,%s,%s', [
              FontDialog.Font.Name,
              FontDialog.Font.Size,
              BoolToStr(fsBold in FontDialog.Font.Style, True),
              BoolToStr(fsItalic in FontDialog.Font.Style, True),
              BoolToStr(fsUnderline in FontDialog.Font.Style, True),
              ColorToString(FontDialog.Font.Color)
            ]);

            // 璁剧疆灞炴€у€?
            PropItem^.PropertyValue := NewValue;

            // 鏇存柊JSON鏄剧ず
            UpdateJsonMemo;
          end;
        finally
          FontDialog.Free;
        end;
      end;
    etColor:
      begin
        // 缂栬緫棰滆壊
        var ColorDialog := TColorDialog.Create(Self);
        try
          // 璁剧疆榛樿棰滆壊
          try
            ColorDialog.Color := StringToColor(PropItem^.PropertyValue);
          except
            ColorDialog.Color := clBlack;
          end;

          // 鏄剧ず棰滆壊閫夋嫨瀵硅瘽妗?
          if ColorDialog.Execute then
          begin
            // 灏嗛鑹茶浆鎹负瀛楃涓?
            NewValue := ColorToString(ColorDialog.Color);

            // 璁剧疆灞炴€у€?
            PropItem^.PropertyValue := NewValue;

            // 鏇存柊JSON鏄剧ず
            UpdateJsonMemo;
          end;
        finally
          ColorDialog.Free;
        end;
      end;
    etObject, etArray:
      begin
        // 鏃犳硶鐩存帴缂栬緫瀵硅薄鎴栨暟缁?
        ShowMessage('鏃犳硶鐩存帴缂栬緫瀵硅薄鎴栨暟缁?);
      end;
  end;
end;

procedure TFrmBuildConfig.RenameJSONPropertyClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  NewName: string;
begin
  // 鑾峰彇褰撳墠閫夋嫨鐨勮妭鐐?
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 鑾峰彇鏂扮殑鍚嶇О
  NewName := Node.Text;
  if GetPropertyInputFromUser('淇敼鍚嶇О', '璇疯緭鍏ユ柊鐨勫悕绉?', NewName) then
  begin
    // 淇敼鑺傜偣鍚嶇О
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
  // 鑾峰彇褰撳墠閫夋嫨鐨勮妭鐐?
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  // 纭鍒犻櫎
  if MessageDlg('纭畾瑕佸垹闄ゅ悧', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    // 閲婃斁鑺傜偣鏁版嵁
    if Node.Data <> nil then
      Dispose(PConfigPropertyItem(Node.Data));

    // 鍒犻櫎鑺傜偣
    // 删锟斤拷锟节碉拷
    Node.Delete;

    // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
    UpdateJsonMemo;
  end;
end;

procedure TFrmBuildConfig.btnUpdateClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
begin
  // 锟斤拷锟铰帮拷钮锟斤拷锟斤拷录锟斤拷锟斤拷呒锟?
  if not FIsEditing then Exit;

  // 锟斤拷取锟斤拷前选锟叫的节碉拷
  Node := FCurrentJsonNode;
  if Node = nil then Exit;

  // 锟斤拷取锟斤拷锟斤拷锟斤拷
  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷值
  PropItem^.PropertyValue := edtEditing.Text;

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
  UpdateJsonMemo;

  // 锟斤拷锟截编辑锟斤拷
  HidePropertyEditor;
end;

procedure TFrmBuildConfig.btnSaveClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 锟斤拷锟芥按钮锟斤拷锟斤拷录锟斤拷锟斤拷呒锟?
  if (FCurrentIniFile = '') and (cbFileName.Text = '') then
  begin
    // 锟斤拷锟矫伙拷锟街革拷锟斤拷募锟斤拷锟斤拷锟斤拷锟绞撅拷锟斤拷锟皆伙拷锟斤拷
    dlgOpenFile.Filter := 'INI锟侥硷拷 (*.ini)|*.ini|All files (*.*)|*.*';
    dlgOpenFile.Title := '锟斤拷锟斤拷INI锟斤拷锟斤拷锟侥硷拷';
    dlgOpenFile.DefaultExt := 'ini';

    if dlgOpenFile.Execute then
    begin
      IniFileName := dlgOpenFile.FileName;
      JsonFileName := ChangeFileExt(IniFileName, '.json');

      // 锟斤拷锟斤拷锟侥硷拷
      SaveIniFile(IniFileName);
      SaveJsonFile(JsonFileName);

      // 锟斤拷锟铰碉拷前锟侥硷拷锟斤拷
      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;

      // 锟斤拷锟接碉拷ComboBox
      if cbFileName.Items.IndexOf(IniFileName) < 0 then
      begin
        cbFileName.Items.Add(IniFileName);
        cbFileName.ItemIndex := cbFileName.Items.Count - 1;
      end;

      ShowMessage('锟斤拷锟斤拷锟侥硷拷锟窖憋拷锟斤拷');
    end;
  end
  else
  begin
    // 使锟矫碉拷前锟侥硷拷锟斤拷锟斤拷锟斤拷
    if FCurrentIniFile = '' then
      FCurrentIniFile := cbFileName.Text;

    JsonFileName := ChangeFileExt(FCurrentIniFile, '.json');

    // 锟斤拷锟斤拷锟侥硷拷
    SaveIniFile(FCurrentIniFile);
    SaveJsonFile(JsonFileName);

    ShowMessage('锟斤拷锟斤拷锟侥硷拷锟窖憋拷锟斤拷');
  end;
end;

procedure TFrmBuildConfig.btnSectionClick(Sender: TObject);
var
  CurrentRow: Integer;
  SectionName: string;
  i: Integer;
begin
  // 锟斤拷取锟斤拷前选锟叫碉拷锟斤拷
  CurrentRow := sgINI.Row;

  // 锟斤拷锟轿囱★拷锟斤拷谢锟窖★拷械锟揭伙拷校锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
  if (CurrentRow <= 1) then
    CurrentRow := sgINI.RowCount;

  // 锟斤拷取锟街斤拷锟斤拷
  SectionName := '';
  if not GetPropertyInputFromUser('锟街斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷纸锟斤拷锟?', SectionName) then
    Exit;

  if SectionName = '' then
  begin
    ShowMessage('锟街斤拷锟斤拷锟斤拷锟斤拷为锟斤拷');
    Exit;
  end;

  // 锟斤拷锟斤拷一锟斤拷
  if CurrentRow >= sgINI.RowCount then
    sgINI.RowCount := sgINI.RowCount + 1
  else
  begin
    // 锟斤拷锟斤拷锟斤拷锟斤拷
    sgINI.RowCount := sgINI.RowCount + 1;

    // 锟斤拷锟斤拷前锟叫硷拷锟斤拷锟铰碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    for i := sgINI.RowCount - 2 downto CurrentRow do
    begin
      SetGridCell(0, i + 1, GetGridCell(0, i));
      SetGridCell(1, i + 1, GetGridCell(1, i));
      SetGridCell(2, i + 1, GetGridCell(2, i));
    end;
  end;

  // 锟节碉拷前锟斤拷锟斤拷锟矫分斤拷锟斤拷
  SetGridCell(0, CurrentRow, SectionName);
  SetGridCell(1, CurrentRow, '锟街斤拷锟斤拷');
  SetGridCell(2, CurrentRow, '--锟街斤拷--');

  // 选锟斤拷前锟斤拷
  sgINI.Row := CurrentRow;

  // 锟斤拷锟斤拷INI锟斤拷锟斤拷锟斤拷示
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
  // 锟斤拷锟斤拷锟斤拷锟侥硷拷锟斤拷锟竭硷拷
  dlgOpenFile.Filter := 'INI锟侥硷拷 (*.ini)|*.ini|All files (*.*)|*.*';
  dlgOpenFile.Title := '选锟斤拷INI锟斤拷锟斤拷锟侥硷拷';

  if dlgOpenFile.Execute then
  begin
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // 锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷
    LoadConfigFiles(IniFileName, JsonFileName);

    // 锟斤拷锟斤拷锟侥硷拷锟斤拷锟斤拷锟斤拷锟接碉拷ComboBox
    if cbFileName.Items.IndexOf(IniFileName) < 0 then
    begin
      cbFileName.Items.Add(IniFileName);
      SaveConfigList; // 锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷
    end;

    cbFileName.ItemIndex := cbFileName.Items.IndexOf(IniFileName);
    FCurrentIniFile := IniFileName;
    FCurrentJsonFile := JsonFileName;
  end;
end;

procedure TFrmBuildConfig.sgINIDblClick(Sender: TObject);
begin
  // INI锟斤拷锟斤拷双锟斤拷锟铰硷拷锟斤拷锟竭硷拷
  EditINIPropertyClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONDblClick(Sender: TObject);
var
  Node: TTreeNode;
  PropItem: PConfigPropertyItem;
  ConfigType: TConfigType;
begin
  // 锟斤拷取锟斤拷前选锟叫的节碉拷
  Node := tvJSON.Selected;
  if Node = nil then Exit;

  PropItem := PConfigPropertyItem(Node.Data);
  if PropItem = nil then Exit;

  // 锟斤拷锟节革拷锟斤拷锟斤拷锟酵ｏ拷锟叫伙拷锟斤拷锟洁辑锟斤拷页
  ConfigType := EditorTypeToConfigType(PropItem^.EditorType);
  if (PropItem^.EditorType in [etObject, etArray, etDatabase, etList]) or
     (ConfigType = ctAIAPI) then
  begin
    // 锟叫伙拷锟斤拷锟洁辑锟斤拷锟斤拷签页
    PageControl1.ActivePage := tsEditor;

    // 锟斤拷锟斤拷嗉拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫碉拷锟斤拷锟叫控硷拷
    while pnlEditorContent.ControlCount > 0 do
      pnlEditorContent.Controls[0].Free;

    // 锟斤拷锟斤拷锟斤拷锟斤拷示锟斤拷应锟侥编辑锟斤拷
    ShowEditorForNode(Node);
  end
  else
  begin
    // 锟斤拷锟斤拷锟斤拷直锟接碉拷锟斤拷锟斤拷锟叫的编辑锟斤拷锟斤拷
    EditJSONPropertyClick(Sender);
  end;
end;

// 锟斤拷锟捷匡拷嗉拷锟斤拷录锟斤拷锟斤拷锟?
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
  // 锟斤拷锟接革拷锟节碉拷
  PropertyName := '锟斤拷锟斤拷锟斤拷锟斤拷';

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  RootNode := AddPropertyToTree(PropertyName, 'TJSONObject', '{}', etObject);

  // 展锟斤拷锟节碉拷
  if Assigned(RootNode) then
    RootNode.Expand(False);

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.btnAddININetworkClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('IP锟斤拷址');
  if PropertyName = '' then Exit;

  PropertyValue := '127.0.0.1';
  if not GetPropertyInputFromUser('锟斤拷锟斤拷锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷IP锟斤拷址:', PropertyValue) then Exit;

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, 'IP锟斤拷址', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINITimeClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // 锟斤拷锟斤拷时锟斤拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Time');
  if PropertyName = '' then Exit;

  PropertyValue := FormatDateTime('hh:mm:ss', Now);
  if not GetPropertyInputFromUser('时锟斤拷锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷时锟斤拷 (hh:mm:ss):', PropertyValue) then Exit;

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '时锟斤拷', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINITemplateClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
  Section: string;
begin
  // 锟斤拷锟斤拷模锟斤拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Template');
  if PropertyName = '' then Exit;

  PropertyValue := '${variableName}';
  if not GetPropertyInputFromUser('模锟斤拷锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷模锟斤拷:', PropertyValue) then Exit;

  // 锟斤拷取锟斤拷前选锟叫的节碉拷锟斤拷为Section
  if sgINI.RowCount > 1 then
    Section := GetGridCell(0, 1)
  else
    Section := 'Template';

  // 锟斤拷锟接碉拷锟斤拷锟斤拷 - 锟斤拷锟斤拷锟斤拷锟斤拷转锟斤拷锟斤拷锟斤拷
  AddPropertyToGrid(Section, 'ConfigType=' + IntToStr(Ord(EditorTypeToConfigType(etPlain))) + '.' + PropertyName, PropertyValue);

  // 锟斤拷锟斤拷INI锟斤拷锟斤拷锟斤拷示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.btnAddINIPluginClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // 锟斤拷锟接诧拷锟斤拷锟斤拷缘锟斤拷呒锟?
  PropertyName := GetNewPropertyName('Plugin');
  if PropertyName = '' then Exit;

  PropertyValue := 'plugins/example.dll';
  if not GetPropertyInputFromUser('锟斤拷锟斤拷锟斤拷锟?, '锟斤拷锟斤拷锟斤拷锟斤拷路锟斤拷:', PropertyValue) then Exit;

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟侥硷拷锟斤拷', PropertyValue);
end;

procedure TFrmBuildConfig.btnAddINILogClick(Sender: TObject);
var
  PropertyName: string;
  PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷志锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Log');
  if PropertyName = '' then Exit;

  PropertyValue := 'logs/app.log';
  if not GetPropertyInputFromUser('锟斤拷志锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷锟斤拷志路锟斤拷:', PropertyValue) then Exit;

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟斤拷锟铰凤拷锟?, PropertyValue);
end;

procedure TFrmBuildConfig.btnAddAPIClick(Sender: TObject);
var
  PropertyName: string;
  Section: string;
  APIEditor: TAIAPIEditorFrame;
  APIForm: TForm;
  JSONObj: TJSONObject;
begin
  // 锟斤拷锟斤拷API锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('API');
  if PropertyName = '' then Exit;

  // 锟斤拷锟斤拷API锟洁辑锟斤拷锟皆伙拷锟斤拷
  APIForm := TForm.Create(Self);
  try
    APIForm.Caption := 'API锟洁辑锟斤拷';
    APIForm.Position := poScreenCenter;
    APIForm.Width := 450;
    APIForm.Height := 350;
    APIForm.BorderStyle := bsDialog;

    // 锟斤拷锟斤拷API锟洁辑锟斤拷
    APIEditor := TAIAPIEditorFrame.Create(APIForm);
    APIEditor.Parent := APIForm;
    APIEditor.Align := alClient;

    // 锟斤拷锟斤拷锟斤拷钮锟斤拷锟?
    var ButtonPanel := TPanel.Create(APIForm);
    ButtonPanel.Parent := APIForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 40;
    ButtonPanel.BevelOuter := bvNone;

    // 锟斤拷锟斤拷确锟斤拷锟斤拷钮
    var OKButton := TButton.Create(ButtonPanel);
    OKButton.Parent := ButtonPanel;
    OKButton.Caption := '确锟斤拷';
    OKButton.ModalResult := mrOK;
    OKButton.Left := ButtonPanel.Width - 170;
    OKButton.Top := 8;
    OKButton.Width := 75;

    // 锟斤拷锟斤拷取锟斤拷锟斤拷钮
    var CancelButton := TButton.Create(ButtonPanel);
    CancelButton.Parent := ButtonPanel;
    CancelButton.Caption := '取锟斤拷';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Left := ButtonPanel.Width - 85;
    CancelButton.Top := 8;
    CancelButton.Width := 75;

    // 锟斤拷锟斤拷锟斤拷始JSON锟斤拷锟斤拷
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair('url', 'https://api.example.com');
    JSONObj.AddPair('method', 'GET');

    // 锟斤拷示锟皆伙拷锟斤拷
    if APIForm.ShowModal = mrOK then
    begin
      // 锟斤拷取锟斤拷前选锟叫的节碉拷
      var Node := tvJSON.Selected;
      var PropItem: PConfigPropertyItem;

      if Node = nil then
      begin
        // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject);
      end
      else
      begin
        // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟斤拷锟斤拷锟斤拷
        PropItem := PConfigPropertyItem(Node.Data);
        if PropItem^.EditorType = etObject then
          // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node)
        else
          // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?
          Node := AddPropertyToTree(PropertyName, 'TJSONObject', JSONObj.ToString, etObject, Node.Parent);
      end;

      // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
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
  // 锟斤拷锟接帮拷全锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Security');
  if PropertyName = '' then Exit;

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷
  SecJSON := TJSONObject.Create;
  try
    SecJSON.AddPair('enabled', TJSONBool.Create(True));
    SecJSON.AddPair('encryption', 'AES-256');
    SecJSON.AddPair('ssl', TJSONBool.Create(True));

    // 锟斤拷取锟斤拷前选锟叫的节碉拷
    Node := tvJSON.Selected;

    if Node = nil then
    begin
      // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject);
    end
    else
    begin
      // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟饺★拷锟斤拷锟?
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', SecJSON.ToString, etObject, Node)
      else
        // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?
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
      // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject);
    end
    else
    begin
      // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟饺★拷锟斤拷锟?
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node)
      else
        // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', AIJSON.ToString, etObject, Node.Parent);
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
      // 锟斤拷锟矫伙拷锟窖★拷薪诘悖拷锟斤拷拥锟斤拷锟?
      Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject);
    end
    else
    begin
      // 锟斤拷锟窖★拷锟斤拷私诘悖拷锟饺★拷锟斤拷锟?
      var PropItem := PConfigPropertyItem(Node.Data);
      if PropItem^.EditorType = etObject then
        // 锟斤拷锟接碉拷选锟叫的讹拷锟斤拷诘锟斤拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node)
      else
        // 锟斤拷锟接碉拷选锟叫节碉拷锟酵拷锟?
        Node := AddPropertyToTree(PropertyName, 'TJSONObject', ModJSON.ToString, etObject, Node.Parent);
    end;

    // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
    UpdateJsonMemo;
  finally
    ModJSON.Free;
  end;
end;

// 锟斤拷锟接分斤拷锟斤拷锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷
procedure TFrmBuildConfig.btnAddSectionClick(Sender: TObject);
begin
  // 锟斤拷锟斤拷锟斤拷实锟街的凤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷馗锟?
  btnSectionClick(Sender);
end;

// 锟斤拷锟接匡拷锟斤拷锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷
procedure TFrmBuildConfig.btnAddEmptyLineClick(Sender: TObject);
var
  CurrentRow: Integer;
  EmptyName: string;
  i: Integer;
begin
  // 锟斤拷取锟斤拷前选锟叫碉拷锟斤拷
  CurrentRow := sgINI.Row;

  // 锟斤拷锟轿囱★拷锟斤拷谢锟窖★拷械锟揭伙拷校锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
  if (CurrentRow <= 1) then
    CurrentRow := sgINI.RowCount;

  // 锟斤拷取锟斤拷锟斤拷锟斤拷锟狡ｏ拷锟斤拷选锟斤拷也锟斤拷锟斤拷锟皆讹拷锟斤拷锟缴ｏ拷
  EmptyName := 'Empty_' + IntToStr(sgINI.RowCount);

  // 锟斤拷锟斤拷一锟斤拷
  if CurrentRow >= sgINI.RowCount then
    sgINI.RowCount := sgINI.RowCount + 1
  else
  begin
    // 锟斤拷锟斤拷锟斤拷锟斤拷
    sgINI.RowCount := sgINI.RowCount + 1;

    // 锟斤拷锟斤拷前锟叫硷拷锟斤拷锟铰碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    for i := sgINI.RowCount - 2 downto CurrentRow do
    begin
      SetGridCell(0, i + 1, GetGridCell(0, i));
      SetGridCell(1, i + 1, GetGridCell(1, i));
      SetGridCell(2, i + 1, GetGridCell(2, i));
    end;
  end;

  // 锟节碉拷前锟斤拷锟斤拷锟矫匡拷锟斤拷
  SetGridCell(0, CurrentRow, EmptyName);
  SetGridCell(1, CurrentRow, '锟斤拷锟斤拷');
  SetGridCell(2, CurrentRow, '');

  // 选锟斤拷前锟斤拷
  sgINI.Row := CurrentRow;

  // 锟斤拷锟斤拷INI锟斤拷锟斤拷锟斤拷示
  UpdateIniMemo;
end;

// 锟斤拷锟斤拷锟斤拷目锟斤拷目录锟斤拷钮锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷
procedure TFrmBuildConfig.btnRootPathClick(Sender: TObject);
var
  PropertyName: string;
  DirValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷目锟斤拷目录锟斤拷锟斤拷
  PropertyName := GetNewPropertyName('RootPath');
  if PropertyName = '' then Exit;

  // 锟斤拷取目录
  DirValue := '';

  // 锟斤拷示目录选锟斤拷曰锟斤拷锟?
  dlgBrowseDir.Title := '选锟斤拷锟斤拷目锟斤拷目录';
  dlgBrowseDir.Options := [fdoPickFolders];

  if dlgBrowseDir.Execute then
  begin
    DirValue := dlgBrowseDir.FileName;
    if DirValue <> '' then
      AddPropertyToGrid(PropertyName, '锟斤拷目锟斤拷目录', DirValue);
  end;
end;

// 锟斤拷锟接革拷目录锟侥硷拷锟斤拷锟斤拷钮锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷
procedure TFrmBuildConfig.btnFileNameClick(Sender: TObject);
var
  PropertyName: string;
  RootDir, FileName, FullPath: string;
begin
  // 锟斤拷锟接革拷目录锟侥硷拷锟斤拷锟斤拷锟斤拷
  PropertyName := GetNewPropertyName('FileName');
  if PropertyName = '' then Exit;

  // 锟斤拷取锟斤拷目录锟斤拷锟斤拷锟斤拷丫锟斤拷锟斤拷茫锟?
  RootDir := '';
  for var i := 2 to sgINI.RowCount - 1 do
  begin
    if GetGridCell(1, i) = '锟斤拷目锟斤拷目录' then
    begin
      RootDir := GetGridCell(2, i);
      break;
    end;
  end;

  // 锟斤拷锟斤拷锟侥柯硷拷锟轿达拷锟斤拷茫锟斤拷锟斤拷没锟窖★拷锟?
  if RootDir = '' then
  begin
    dlgBrowseDir.Title := '选锟斤拷锟斤拷目锟斤拷目录';
    dlgBrowseDir.Options := [fdoPickFolders];

    if dlgBrowseDir.Execute then
      RootDir := dlgBrowseDir.FileName
    else
      Exit;
  end;

  // 选锟斤拷锟侥硷拷
  dlgOpenFile.Title := '选锟斤拷锟侥硷拷';
  if RootDir <> '' then
    dlgOpenFile.DefaultExt := RootDir; // 使锟斤拷DefaultExt锟斤拷锟矫筹拷始目录
  dlgOpenFile.Filter := '锟斤拷锟斤拷锟侥硷拷 (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FullPath := dlgOpenFile.FileName;
    FileName := ExtractFileName(FullPath);

    // 锟斤拷锟接碉拷锟斤拷锟斤拷
    AddPropertyToGrid(PropertyName, '锟斤拷目录锟侥硷拷锟斤拷', FileName);
  end;
end;

procedure TFrmBuildConfig.btnListClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟叫憋拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('List');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('锟叫憋拷锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷锟叫憋拷值锟斤拷锟矫讹拷锟脚分革拷锟斤拷:', PropertyValue) then Exit;

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟叫憋拷', PropertyValue);
end;

// 锟斤拷锟接撅拷锟斤拷路锟斤拷锟斤拷钮锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷
procedure TFrmBuildConfig.btnAbsFilenameClick(Sender: TObject);
var
  PropertyName: string;
  FilePath: string;
begin
  // 锟斤拷锟接达拷锟斤拷锟斤拷路锟斤拷锟斤拷锟侥硷拷锟斤拷锟斤拷锟斤拷
  PropertyName := GetNewPropertyName('AbsFileName');
  if PropertyName = '' then Exit;

  // 选锟斤拷锟侥硷拷
  dlgOpenFile.Title := '选锟斤拷锟侥硷拷';
  dlgOpenFile.Filter := '锟斤拷锟斤拷锟侥硷拷 (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FilePath := dlgOpenFile.FileName;
    if FilePath <> '' then
      AddPropertyToGrid(PropertyName, '锟侥硷拷路锟斤拷', FilePath);
  end;
end;

procedure TFrmBuildConfig.btnAbsPathClick(Sender: TObject);
var
  PropertyName: string;
  FilePath: string;
begin
  // 锟斤拷锟接撅拷锟斤拷路锟斤拷锟斤拷锟斤拷
  PropertyName := GetNewPropertyName('AbsPath');
  if PropertyName = '' then Exit;

  // 选锟斤拷锟侥硷拷锟斤拷目录
  dlgBrowseDir.Title := '选锟斤拷锟侥硷拷锟斤拷目录';
  dlgBrowseDir.Options := []; // 锟斤拷锟斤拷选锟斤拷锟侥硷拷锟斤拷目录

  if dlgBrowseDir.Execute then
  begin
    FilePath := dlgBrowseDir.FileName;
    if FilePath <> '' then
      AddPropertyToGrid(PropertyName, '锟斤拷锟斤拷路锟斤拷', FilePath);
  end;
end;

// 锟斤拷锟接革拷目录锟斤拷锟侥柯硷拷锟脚ワ拷录锟斤拷锟斤拷锟斤拷锟斤拷锟?
procedure TFrmBuildConfig.btnReFileNameClick(Sender: TObject);
var
  PropertyName: string;
  FilePath, FileName: string;
begin
  // 锟斤拷锟接诧拷锟斤拷路锟斤拷锟斤拷锟侥硷拷锟斤拷锟斤拷锟斤拷
  PropertyName := GetNewPropertyName('FileName');
  if PropertyName = '' then Exit;

  // 选锟斤拷锟侥硷拷
  dlgOpenFile.Title := '选锟斤拷锟侥硷拷';
  dlgOpenFile.Filter := '锟斤拷锟斤拷锟侥硷拷 (*.*)|*.*';

  if dlgOpenFile.Execute then
  begin
    FilePath := dlgOpenFile.FileName;
    if FilePath <> '' then
    begin
      // 锟斤拷取锟侥硷拷锟斤拷锟斤拷锟斤拷锟斤拷路锟斤拷锟斤拷
      FileName := ExtractFileName(FilePath);

      // 锟斤拷锟接碉拷锟斤拷锟斤拷
      AddPropertyToGrid(PropertyName, '锟侥硷拷锟斤拷', FileName);
    end;
  end;
end;

procedure TFrmBuildConfig.btnRePathClick(Sender: TObject);
var
  PropertyName: string;
  RootDir, SubDir, RelativePath: string;
begin
  // 锟斤拷锟斤拷锟斤拷锟侥柯硷拷锟斤拷锟?
  PropertyName := GetNewPropertyName('RePath');
  if PropertyName = '' then Exit;

  // 锟斤拷取锟斤拷目录锟斤拷锟斤拷锟斤拷丫锟斤拷锟斤拷茫锟?
  RootDir := '';
  for var i := 2 to sgINI.RowCount - 1 do
  begin
    if GetGridCell(1, i) = '锟斤拷目锟斤拷目录' then
    begin
      RootDir := GetGridCell(2, i);
      break;
    end;
  end;

  // 锟斤拷锟斤拷锟侥柯硷拷锟轿达拷锟斤拷茫锟斤拷锟斤拷没锟窖★拷锟?
  if RootDir = '' then
  begin
    dlgBrowseDir.Title := '选锟斤拷锟斤拷目锟斤拷目录';
    dlgBrowseDir.Options := [fdoPickFolders];

    if dlgBrowseDir.Execute then
      RootDir := dlgBrowseDir.FileName
    else
      Exit;

    // 锟斤拷锟接革拷目录锟斤拷录
    AddPropertyToGrid('RootDir', '锟斤拷目锟斤拷目录', RootDir);
  end;

  // 选锟斤拷锟斤拷目录
  dlgBrowseDir.Title := '选锟斤拷锟斤拷目录';
  dlgBrowseDir.Options := [fdoPickFolders];
  dlgBrowseDir.DefaultFolder := RootDir; // 使锟斤拷DefaultFolder锟斤拷锟斤拷InitialDir

  if dlgBrowseDir.Execute then
  begin
    SubDir := dlgBrowseDir.FileName;

    // 锟斤拷锟斤拷锟斤拷锟铰凤拷锟?
    if SubDir.StartsWith(RootDir) then
    begin
      RelativePath := Copy(SubDir, Length(RootDir) + 1, Length(SubDir));
      // 去锟斤拷锟斤拷头锟斤拷斜锟杰伙拷斜锟斤拷
      if (RelativePath <> '') and ((RelativePath[1] = '/') or (RelativePath[1] = '\')) then
        RelativePath := Copy(RelativePath, 2, Length(RelativePath));

      // 锟斤拷锟接碉拷锟斤拷锟斤拷
      AddPropertyToGrid(PropertyName, '锟斤拷锟侥柯?, RelativePath);
    end
    else
    begin
      ShowMessage('选锟斤拷锟侥柯硷拷锟斤拷锟斤拷锟侥匡拷锟侥柯硷拷锟斤拷锟侥柯硷拷锟?);
    end;
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
  // 锟斤拷要锟斤拷锟斤拷锟斤拷锟斤拷锟絉egister锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷时锟斤拷锟斤拷Register应锟斤拷只锟斤拷锟斤拷锟绞笔癸拷锟?
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

  // 锟斤拷锟捷节碉拷锟斤拷锟酵达拷锟斤拷锟斤拷应锟侥编辑锟斤拷 - 锟斤拷锟斤拷锟斤拷锟斤拷转锟斤拷锟斤拷锟斤拷
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
        // 锟斤拷时注锟酵碉拷锟斤拷锟斤拷为FrameObjectEditor锟斤拷元锟叫憋拷锟斤拷锟斤拷锟斤拷
        // EditorFrame := TFrameObjectEditor.Create(Self);
        // 锟斤拷锟斤拷锟绞╋拷锟斤拷锟绞撅拷锟较拷锟斤拷顺锟?
        ShowMessage('锟斤拷锟斤拷嗉拷锟斤拷锟斤拷锟斤拷锟绞憋拷锟斤拷锟斤拷茫锟斤拷锟斤拷锟轿拷锟斤拷锟?);
        Exit;
      end;
    etArray:
      begin
        EditorFrame := TFrameArrayEditor.Create(Self);
      end;
    else
      begin
        // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟酵ｏ拷锟截憋拷锟斤拷AI API
        ConfigType := EditorTypeToConfigType(PropItem^.EditorType);
        if ConfigType = ctAIAPI then
          EditorFrame := TAIAPIEditorFrame.Create(Self)
        else
          Exit; // 锟角革拷锟斤拷锟斤拷锟酵诧拷锟斤拷锟斤拷
      end;
  end;

  if EditorFrame <> nil then
  begin
    // 锟斤拷锟矫编辑锟斤拷位锟矫猴拷锟斤拷锟斤拷
    EditorFrame.Parent := pnlEditorContent;
    EditorFrame.Align := alClient;
    EditorFrame.Visible := True;

    // 为没锟斤拷锟斤拷锟矫憋拷锟斤拷/取锟斤拷锟斤拷钮锟侥编辑锟斤拷锟斤拷锟接帮拷钮锟斤拷锟?
    if not (EditorFrame is TFrameDBEditor) then
    begin
      // 锟斤拷锟斤拷锟斤拷钮锟斤拷锟?
      ButtonPanel := TPanel.Create(Self);
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

    // 锟斤拷锟芥当前锟斤拷锟节编辑锟侥节碉拷捅嗉拷锟?
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
          // // else if EditorFrame is TFrameObjectEditor then
          // begin
          //   // 锟斤拷锟截讹拷锟斤拷锟斤拷息
          //   // TFrameObjectEditor实锟斤拷...
          // end
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
    // else if FCurrentEditor is TFrameObjectEditor then
    begin
      // 锟斤拷锟斤拷锟斤拷锟斤拷锟较?
      // TFrameObjectEditor实锟斤拷...
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
  // 锟斤拷锟斤拷嗉拷锟斤拷锟斤拷莸锟斤拷诘锟?
  SaveEditorDataToNode;

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

function TFrmBuildConfig.BuildPropertyPath(Node: TTreeNode): string;
var
  Path: string;
  CurrentNode: TTreeNode;
begin
  Path := '';
  CurrentNode := Node;

  // 锟斤拷锟斤拷锟接革拷锟斤拷锟斤拷前锟节碉拷锟铰凤拷锟?
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
  // 锟斤拷锟斤拷锟斤拷实锟街的凤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷馗锟?
  btnAddEmptyLineClick(Sender);
end;

procedure TFrmBuildConfig.tvJSONChange(Sender: TObject; Node: TTreeNode);
begin
  // 锟斤拷JSON锟斤拷锟斤拷图选锟斤拷锟斤拷锟绞憋拷拇锟斤拷锟?
  if Node = nil then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟接节碉拷选锟斤拷锟斤拷锟侥达拷锟斤拷锟竭硷拷
  // 锟斤拷锟界：锟斤拷示锟节碉拷锟斤拷锟皆★拷锟斤拷锟斤拷状态锟斤拷
end;

procedure TFrmBuildConfig.sgINISelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // 锟斤拷INI锟斤拷锟斤拷元锟斤拷选锟斤拷时锟侥达拷锟斤拷
  CanSelect := True; // 锟斤拷锟斤拷选锟斤拷

  // 为选锟叫碉拷锟斤拷锟斤拷锟斤拷锟揭硷拷锟剿碉拷
  if ARow > 1 then
  begin
    // 锟斤拷锟斤拷锟揭硷拷锟剿碉拷
    sgINI.PopupMenu := popupINI;

    // 锟斤拷锟斤拷欠纸锟斤拷锟斤拷锟斤拷锟叫ｏ拷锟斤拷锟斤拷删锟斤拷锟剿碉拷锟斤拷
    if (GetGridCell(1, ARow) = '锟街斤拷锟斤拷') then
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := False; // 锟斤拷锟斤拷删锟斤拷
        popupINI.Items[0].Enabled := False; // 锟斤拷锟矫编辑
      end;
    end
    else if (GetGridCell(1, ARow) = '锟斤拷锟斤拷') then
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := True; // 锟斤拷锟斤拷删锟斤拷
        popupINI.Items[0].Enabled := False; // 锟斤拷锟矫编辑
      end;
    end
    else
    begin
      if Assigned(popupINI) and (popupINI.Items.Count > 2) then
      begin
        popupINI.Items[2].Enabled := True; // 锟斤拷锟斤拷删锟斤拷
        popupINI.Items[0].Enabled := True; // 锟斤拷锟斤拷锟洁辑
      end;
    end;
  end
  else
  begin
    // 锟斤拷一锟叫诧拷锟斤拷锟斤拷锟揭硷拷锟剿碉拷
    sgINI.PopupMenu := nil;
  end;

  // 每锟斤拷选锟斤拷元锟斤拷锟斤拷锟斤拷INI锟斤拷锟斤拷锟斤拷示
  UpdateIniMemo;
end;

procedure TFrmBuildConfig.sgINIDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DropRow: Integer;
  TempCells: array[0..2] of string;
begin
  // 锟斤拷取锟斤拷锟斤拷位锟矫碉拷锟叫猴拷
  DropRow := sgINI.MouseCoord(X, Y).Y;

  // 确锟斤拷锟较放碉拷锟斤拷效锟斤拷
  if (DropRow > 0) and (DropRow < sgINI.RowCount) and (sgINI.Row > 0) and (sgINI.Row < sgINI.RowCount) then
  begin
    // 源锟叫猴拷目锟斤拷锟叫诧拷同时锟脚斤拷锟叫达拷锟斤拷
    if DropRow <> sgINI.Row then
    begin
      // 锟斤拷锟芥被锟较讹拷锟叫碉拷锟斤拷锟斤拷
      TempCells[0] := GetGridCell(0, sgINI.Row);
      TempCells[1] := GetGridCell(1, sgINI.Row);
      TempCells[2] := GetGridCell(2, sgINI.Row);

      // 锟狡讹拷锟斤拷锟捷ｏ拷锟斤拷删锟斤拷锟较讹拷锟叫ｏ拷锟劫诧拷锟诫到目锟斤拷位锟斤拷
      if DropRow > sgINI.Row then
      begin
        // 锟斤拷锟斤拷锟狡讹拷
        for var i := sgINI.Row to DropRow - 1 do
        begin
          SetGridCell(0, i, GetGridCell(0, i + 1));
          SetGridCell(1, i, GetGridCell(1, i + 1));
          SetGridCell(2, i, GetGridCell(2, i + 1));
        end;
      end
      else
      begin
        // 锟斤拷锟斤拷锟狡讹拷
        for var i := sgINI.Row downto DropRow + 1 do
        begin
          SetGridCell(0, i, GetGridCell(0, i - 1));
          SetGridCell(1, i, GetGridCell(1, i - 1));
          SetGridCell(2, i, GetGridCell(2, i - 1));
        end;
      end;

      // 锟斤拷目锟斤拷位锟矫诧拷锟斤拷锟斤拷锟斤拷
      SetGridCell(0, DropRow, TempCells[0]);
      SetGridCell(1, DropRow, TempCells[1]);
      SetGridCell(2, DropRow, TempCells[2]);

      // 选锟斤拷目锟斤拷锟斤拷
      sgINI.Row := DropRow;

      // 锟斤拷锟斤拷INI锟斤拷锟斤拷锟斤拷示
      UpdateIniMemo;
    end;
  end;
end;

procedure TFrmBuildConfig.sgINIDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  // INI锟斤拷锟斤拷锟较讹拷锟斤拷锟斤拷时锟侥达拷锟斤拷
  Accept := (Source = sgINI) and (Y > sgINI.RowHeights[0]); // 只锟斤拷锟杰达拷锟皆硷拷锟较癸拷锟斤拷锟侥ｏ拷锟揭诧拷锟角憋拷头锟斤拷
end;

procedure TFrmBuildConfig.tvJSONDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SourceNode, TargetNode: TTreeNode;
  SourceData, TargetData: PConfigPropertyItem;
  PointPos: TPoint;
begin
  if Source <> tvJSON then Exit;

  // 锟斤拷取锟较讹拷源锟节碉拷锟侥匡拷锟节碉拷
  SourceNode := tvJSON.Selected;
  if SourceNode = nil then Exit;

  PointPos := tvJSON.ScreenToClient(Point(X, Y));
  TargetNode := tvJSON.GetNodeAt(PointPos.X, PointPos.Y);

  // 确锟斤拷锟斤拷效锟斤拷目锟斤拷诘锟?
  if (TargetNode = nil) or (TargetNode = SourceNode) or TargetNode.HasAsParent(SourceNode) then Exit;

  // 锟斤拷取锟节碉拷锟斤拷锟斤拷
  SourceData := PConfigPropertyItem(SourceNode.Data);
  if TargetNode <> nil then
    TargetData := PConfigPropertyItem(TargetNode.Data)
  else
    TargetData := nil;

  // 只锟斤拷锟斤拷锟斤拷锟节碉拷锟狡讹拷锟斤拷锟斤拷锟斤拷锟斤拷锟酵的节碉拷锟斤拷
  if (TargetData <> nil) and (TargetData^.EditorType <> etObject) and (TargetData^.EditorType <> etArray) then Exit;

  // 锟狡讹拷锟节碉拷
  SourceNode.MoveTo(TargetNode, naAddChild);

  // 锟斤拷锟铰节碉拷路锟斤拷
  SourceData^.PropertyPath := BuildPropertyPath(SourceNode);

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟接节碉拷锟铰凤拷锟?
  for var i := 0 to SourceNode.Count - 1 do
  begin
    var ChildData := PConfigPropertyItem(SourceNode.Item[i].Data);
    if ChildData <> nil then
      ChildData^.PropertyPath := BuildPropertyPath(SourceNode.Item[i]);
  end;

  // 展锟斤拷目锟斤拷诘锟?
  if TargetNode <> nil then
    TargetNode.Expand(False);

  // 锟斤拷锟斤拷JSON锟斤拷锟斤拷锟斤拷示
  UpdateJsonMemo;
end;

procedure TFrmBuildConfig.tvJSONDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  TargetNode: TTreeNode;
  TargetData: PConfigPropertyItem;
  PointPos: TPoint;
begin
  Accept := False;

  // 只锟斤拷锟杰达拷锟皆硷拷锟较癸拷锟斤拷锟斤拷
  if Source <> tvJSON then Exit;

  // 锟斤拷取锟斤拷锟轿伙拷玫慕诘锟?
  PointPos := tvJSON.ScreenToClient(Point(X, Y));
  TargetNode := tvJSON.GetNodeAt(PointPos.X, PointPos.Y);

  // 锟斤拷锟矫伙拷锟侥匡拷锟节点，锟斤拷锟斤拷锟较放ｏ拷锟较碉拷锟斤拷锟斤拷
  if TargetNode = nil then
  begin
    Accept := True;
    Exit;
  end;

  // 锟斤拷取目锟斤拷诘锟斤拷锟斤拷锟?
  TargetData := PConfigPropertyItem(TargetNode.Data);
  if TargetData = nil then Exit;

  // 只锟斤拷锟斤拷锟较放碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷徒诘锟斤拷锟?
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

// 锟斤拷implementation锟斤拷锟斤拷锟斤拷锟接凤拷锟斤拷实锟斤拷
procedure TFrmBuildConfig.pcAttributeChange(Sender: TObject);
begin
  // 锟斤拷锟捷碉拷前锟筋动锟斤拷签页锟斤拷锟斤拷锟斤拷锟缴硷拷锟皆猴拷锟斤拷锟斤拷签页
  if pcAttribute.ActivePage = tsINIGrid then
  begin
    // 锟斤拷INI锟斤拷锟斤拷锟角┮筹拷锟斤拷锟绞憋拷锟斤拷锟绞綢NI锟斤拷澹拷锟斤拷锟絁SON锟斤拷锟?
    pnlIni.Visible := True;
    pnlJson.Visible := False;

    // 同锟斤拷锟斤拷示INI锟斤拷锟斤拷签页
    if PageControl1.ActivePage <> tsINI then
      PageControl1.ActivePage := tsINI;
  end
  else if pcAttribute.ActivePage = tsJSONTree then
  begin
    // 锟斤拷JSON锟斤拷锟斤拷签页锟斤拷锟斤拷时锟斤拷锟斤拷示JSON锟斤拷澹拷锟斤拷锟絀NI锟斤拷锟?
    pnlIni.Visible := False;
    pnlJson.Visible := True;

    // 同锟斤拷锟斤拷示JSON锟斤拷锟斤拷签页
    if PageControl1.ActivePage <> tsJSON then
      PageControl1.ActivePage := tsJSON;
  end;
end;

// 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷锟斤拷锟侥硷拷
procedure TFrmBuildConfig.SaveConfigList;
var
  FileList: TStringList;
  i: Integer;
begin
  // 锟斤拷锟斤拷锟街凤拷锟斤拷锟叫憋拷
  FileList := TStringList.Create;
  try
    // 锟斤拷锟斤拷ComboBox锟叫碉拷锟斤拷锟斤拷锟斤拷目
    for i := 0 to cbFileName.Items.Count - 1 do
      FileList.Add(cbFileName.Items[i]);

    // 锟斤拷锟芥到锟侥硷拷
    try
      FileList.SaveToFile(FConfigListFile);
    except
      on E: Exception do
        ShowMessage('锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷失锟斤拷: ' + E.Message);
    end;
  finally
    FileList.Free;
  end;
end;

// 锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷
procedure TFrmBuildConfig.LoadConfigList;
var
  FileList: TStringList;
begin
  // 只锟叫碉拷锟侥硷拷锟斤拷锟斤拷时锟脚硷拷锟斤拷
  if not FileExists(FConfigListFile) then
    Exit;

  // 锟斤拷锟斤拷锟街凤拷锟斤拷锟叫憋拷
  FileList := TStringList.Create;
  try
    // 锟斤拷锟侥硷拷锟斤拷锟斤拷
    try
      FileList.LoadFromFile(FConfigListFile);

      // 锟斤拷锟斤拷锟角帮拷锟侥匡拷锟斤拷锟斤拷蛹锟斤拷氐锟斤拷锟侥?
      cbFileName.Items.Clear;
      cbFileName.Items.AddStrings(FileList);

      // 锟斤拷锟斤拷锟斤拷锟侥匡拷锟窖★拷锟斤拷一锟斤拷
      if cbFileName.Items.Count > 0 then
      begin
        cbFileName.ItemIndex := 0;
        cbFileNameChange(nil);
      end;
    except
      on E: Exception do
        ShowMessage('锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷失锟斤拷: ' + E.Message);
    end;
  finally
    FileList.Free;
  end;
end;

// 锟斤拷锟斤拷锟斤拷ComboBox锟斤拷目锟侥憋拷时锟侥达拷锟斤拷
procedure TFrmBuildConfig.cbFileNameChange(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 确锟斤拷锟斤拷选锟叫碉拷锟斤拷目
  if cbFileName.ItemIndex < 0 then
    Exit;

  // 锟斤拷取选锟叫碉拷锟侥硷拷锟斤拷
  IniFileName := cbFileName.Items[cbFileName.ItemIndex];

  // 确锟斤拷锟侥硷拷锟斤拷锟斤拷
  if not FileExists(IniFileName) then
  begin
    ShowMessage('锟侥硷拷锟斤拷锟斤拷锟斤拷: ' + IniFileName);
    Exit;
  end;

  // 锟斤拷锟缴讹拷应锟斤拷JSON锟侥硷拷锟斤拷
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷
  LoadConfigFiles(IniFileName, JsonFileName);

  // 锟斤拷锟铰碉拷前锟侥硷拷锟斤拷
  FCurrentIniFile := IniFileName;
  FCurrentJsonFile := JsonFileName;
end;

// 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟矫碉拷选锟斤拷锟侥硷拷
procedure TFrmBuildConfig.btnSaveConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 确锟斤拷锟斤拷选锟叫碉拷锟斤拷目
  if cbFileName.ItemIndex < 0 then
  begin
    ShowMessage('锟斤拷锟斤拷选锟斤拷一锟斤拷锟斤拷锟斤拷锟侥硷拷锟津创斤拷锟铰碉拷锟斤拷锟斤拷锟侥硷拷');
    Exit;
  end;

  // 锟斤拷取选锟叫碉拷锟侥硷拷锟斤拷
  IniFileName := cbFileName.Items[cbFileName.ItemIndex];
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // 锟斤拷锟斤拷锟侥硷拷
  try
    SaveIniFile(IniFileName);
    SaveJsonFile(JsonFileName);

    // 锟斤拷锟铰碉拷前锟侥硷拷锟斤拷
    FCurrentIniFile := IniFileName;
    FCurrentJsonFile := JsonFileName;

    ShowMessage('锟斤拷锟斤拷锟窖憋拷锟芥到: ' + IniFileName);
  except
    on E: Exception do
      ShowMessage('锟斤拷锟斤拷锟斤拷锟斤拷失锟斤拷: ' + E.Message);
  end;
end;

// 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟铰碉拷锟斤拷锟斤拷锟侥硷拷
procedure TFrmBuildConfig.btnNewConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
begin
  // 锟津开憋拷锟斤拷曰锟斤拷锟?
  dlgOpenFile.Filter := 'INI锟侥硷拷 (*.ini)|*.ini|锟斤拷锟斤拷锟侥硷拷 (*.*)|*.*';
  dlgOpenFile.Title := '锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷';
  dlgOpenFile.DefaultExt := 'ini';
  dlgOpenFile.Options := dlgOpenFile.Options + [ofOverwritePrompt];

  if dlgOpenFile.Execute then
  begin
    // 锟斤拷取锟侥硷拷锟斤拷
    IniFileName := dlgOpenFile.FileName;
    JsonFileName := ChangeFileExt(IniFileName, '.json');

    // 锟斤拷锟斤拷锟角帮拷锟斤拷锟?
    ClearAllData;

    // 锟斤拷锟皆达拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷募锟?
    try
      // 锟斤拷锟斤拷INI锟侥硷拷锟斤拷锟斤拷锟斤拷默锟斤拷锟斤拷锟斤拷
      with TIniFile.Create(IniFileName) do
      try
        WriteString('General', 'Created', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
      finally
        Free;
      end;

      // 锟斤拷锟斤拷JSON锟侥硷拷锟斤拷锟斤拷锟斤拷默锟斤拷锟斤拷锟斤拷
      with TStringList.Create do
      try
        Text := '{}';
        SaveToFile(JsonFileName);
      finally
        Free;
      end;

      // 锟斤拷锟铰碉拷前锟侥硷拷锟斤拷
      FCurrentIniFile := IniFileName;
      FCurrentJsonFile := JsonFileName;

      // 锟斤拷锟紺omboBox锟叫诧拷锟斤拷锟节革拷锟侥硷拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
      if cbFileName.Items.IndexOf(IniFileName) < 0 then
      begin
        cbFileName.Items.Add(IniFileName);
        // 锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷
        SaveConfigList;
      end;

      // 锟斤拷锟斤拷为锟斤拷前选锟斤拷锟斤拷
      cbFileName.ItemIndex := cbFileName.Items.IndexOf(IniFileName);

      // 锟斤拷锟斤拷锟铰达拷锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷
      LoadConfigFiles(IniFileName, JsonFileName);

      ShowMessage('锟斤拷锟斤拷锟斤拷锟侥硷拷锟窖达拷锟斤拷: ' + IniFileName);
    except
      on E: Exception do
        ShowMessage('锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟侥硷拷失锟斤拷: ' + E.Message);
    end;
  end;
end;

// 锟斤拷锟斤拷锟斤拷删锟斤拷锟斤拷锟斤拷锟侥硷拷
procedure TFrmBuildConfig.btnDeleteConfigClick(Sender: TObject);
var
  IniFileName, JsonFileName: string;
  DeleteIndex: Integer;
  DeleteFiles: Boolean;
begin
  // 确锟斤拷锟斤拷选锟叫碉拷锟斤拷目
  if cbFileName.ItemIndex < 0 then
  begin
    ShowMessage('锟斤拷锟斤拷选锟斤拷一锟斤拷锟斤拷锟斤拷锟侥硷拷');
    Exit;
  end;

  // 锟斤拷取选锟叫碉拷锟侥硷拷锟斤拷锟斤拷锟斤拷锟斤拷
  DeleteIndex := cbFileName.ItemIndex;
  IniFileName := cbFileName.Items[DeleteIndex];
  JsonFileName := ChangeFileExt(IniFileName, '.json');

  // 询锟斤拷锟角凤拷要删锟斤拷锟斤拷锟斤拷锟侥硷拷
  DeleteFiles := MessageDlg('锟角凤拷同时删锟斤拷锟斤拷锟斤拷锟侥硷拷锟斤拷' + #13#10 +
                            'INI锟侥硷拷: ' + IniFileName + #13#10 +
                            'JSON锟侥硷拷: ' + JsonFileName,
                            mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes;

  // 锟斤拷锟斤拷没锟窖★拷锟饺★拷锟斤拷锟斤拷锟斤拷顺锟?
  if MessageDlg('确锟斤拷要锟斤拷锟叫憋拷锟斤拷删锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // 锟斤拷锟斤拷没锟窖★拷锟酵鄙撅拷锟斤拷锟斤拷锟斤拷募锟?
  if DeleteFiles then
  begin
    try
      // 删锟斤拷INI锟侥硷拷
      if FileExists(IniFileName) then
        DeleteFile(IniFileName);

      // 删锟斤拷JSON锟侥硷拷
      if FileExists(JsonFileName) then
        DeleteFile(JsonFileName);
    except
      on E: Exception do
      begin
        ShowMessage('删锟斤拷锟侥硷拷失锟斤拷: ' + E.Message);
        Exit;
      end;
    end;
  end;

  // 锟斤拷ComboBox锟斤拷删锟斤拷锟斤拷目
  cbFileName.Items.Delete(DeleteIndex);

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟叫憋拷
  SaveConfigList;

  // 锟斤拷锟斤拷锟角帮拷锟斤拷锟?
  ClearAllData;
  FCurrentIniFile := '';
  FCurrentJsonFile := '';

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷茫锟窖★拷锟斤拷一锟斤拷
  if cbFileName.Items.Count > 0 then
  begin
    cbFileName.ItemIndex := 0;
    cbFileNameChange(nil);
  end;

  ShowMessage('锟斤拷锟斤拷锟窖达拷锟叫憋拷锟斤拷删锟斤拷');
end;

procedure TFrmBuildConfig.btnKeyClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('Password');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('锟斤拷锟斤拷锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷值锟斤拷锟斤拷锟斤拷锟斤拷锟杰存储锟斤拷:', PropertyValue) then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟竭硷拷
  // 示锟斤拷: PropertyValue := EncryptPassword(PropertyValue);

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟斤拷锟斤拷', PropertyValue);
end;

procedure TFrmBuildConfig.btnRegClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟绞斤拷锟斤拷缘锟斤拷呒锟?
  PropertyName := GetNewPropertyName('RegEx');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('锟斤拷锟斤拷锟斤拷锟绞斤拷锟斤拷锟?, '锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟绞?', PropertyValue) then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷式锟斤拷证锟竭硷拷
  // 示锟斤拷: if not IsValidRegEx(PropertyValue) then ...

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟斤拷锟斤拷锟斤拷锟绞?, PropertyValue);
end;

procedure TFrmBuildConfig.btnEMailClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // 锟斤拷锟斤拷锟斤拷锟斤拷锟街凤拷锟斤拷缘锟斤拷呒锟?
  PropertyName := GetNewPropertyName('Email');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('锟斤拷锟斤拷锟街凤拷锟斤拷锟?, '锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟街?', PropertyValue) then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷址锟斤拷证锟竭硷拷
  // 示锟斤拷: if not IsValidEmail(PropertyValue) then ...

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, '锟斤拷锟斤拷锟街?, PropertyValue);
end;

procedure TFrmBuildConfig.btnUrlClick(Sender: TObject);
var
  PropertyName, PropertyValue: string;
begin
  // 锟斤拷锟斤拷URL锟斤拷锟皆碉拷锟竭硷拷
  PropertyName := GetNewPropertyName('URL');
  if PropertyName = '' then Exit;

  PropertyValue := '';
  if not GetPropertyInputFromUser('URL锟斤拷锟斤拷', '锟斤拷锟斤拷锟斤拷URL锟斤拷址:', PropertyValue) then Exit;

  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟経RL锟斤拷证锟竭硷拷
  // 示锟斤拷: if not IsValidURL(PropertyValue) then ...

  // 锟斤拷锟接碉拷锟斤拷锟斤拷
  AddPropertyToGrid(PropertyName, 'URL', PropertyValue);
end;


procedure TFrmBuildConfig.InitializeValidator;
begin
  // 锟斤拷锟斤拷锟斤拷证锟斤拷
  FValidator := TConfigValidator.Create;

  // 锟斤拷锟斤拷锟斤拷证锟斤拷锟斤拷
  // 锟斤拷值锟斤拷锟斤拷锟斤拷证
  FValidator.AddNumericRule('General/ctPlain.Number', 'Number');

  // 锟斤拷锟斤拷锟斤拷锟斤拷证
  FValidator.AddRequiredRule('General/ctPlain.Text', 'Text', '锟侥憋拷锟斤拷锟皆诧拷锟斤拷为锟斤拷');

  // 锟斤拷围锟斤拷证
  FValidator.AddRangeRule('General/ctPlain.Age', 'Age', 0, 120, '锟斤拷锟斤拷锟斤拷锟斤拷锟?锟斤拷120之锟斤拷');

  // 锟斤拷锟斤拷锟斤拷锟绞斤拷锟街?
  FValidator.AddRegexRule('General/ctPlain.Email', 'Email', '^[\w\.-]+@[\w\.-]+\.[\w]+$', '锟斤拷锟斤拷锟绞斤拷锟斤拷锟饺?);

  // 锟皆讹拷锟斤拷锟斤拷证
  FValidator.AddCustomRule('General/ctPlain.Password', 'Password',
    function(const Value: string): Boolean
    begin
      // 锟斤拷锟诫长锟斤拷锟斤拷锟斤拷为8位
      Result := Length(Value) >= 8;
    end,
    '锟斤拷锟诫长锟斤拷锟斤拷锟斤拷为8位');
end;

function TFrmBuildConfig.ValidateConfig: Boolean;
var
  JSONObj: TJSONObject;
  i: Integer;
  Section, Key, Value: string;
begin
  // 锟斤拷锟街帮拷锟斤拷锟街わ拷锟斤拷
  FValidator.Results.Clear;

  // 锟斤拷证INI锟斤拷锟斤拷
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

  // 锟斤拷证JSON锟斤拷锟斤拷
  // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟絁SON锟斤拷锟矫碉拷锟斤拷证锟竭硷拷

  // 锟斤拷锟斤拷锟斤拷证锟斤拷锟?
  Result := FValidator.Results.Count = 0;

  // 锟斤拷锟斤拷锟斤拷锟街わ拷锟斤拷锟斤拷锟绞撅拷锟街わ拷锟斤拷
  if not Result then
    ShowValidationResults;
end;

function TFrmBuildConfig.ValidateINIProperty(const Section, Key, Value: string): Boolean;
begin
  // 使锟斤拷锟斤拷证锟斤拷锟斤拷证锟斤拷锟斤拷
  Result := FValidator.ValidateINI(Section, Key, Value);
end;

procedure TFrmBuildConfig.ShowValidationResults;
var
  ValidationForm: TfrmValidation;
begin
  // 锟斤拷锟斤拷锟斤拷证锟斤拷锟斤拷曰锟斤拷锟?
  ValidationForm := TfrmValidation.Create(Self);
  try
    // 锟斤拷锟斤拷选锟斤拷锟斤拷锟斤拷锟铰硷拷
    ValidationForm.OnSelectProperty := procedure(const Path, Name: string)
    begin
      // 锟斤拷锟斤拷锟斤拷锟斤拷锟绞碉拷锟窖★拷锟斤拷锟斤拷缘锟斤拷呒锟?
      // 锟斤拷锟界，锟斤拷锟斤拷锟斤拷锟叫诧拷锟揭诧拷选锟叫讹拷应锟斤拷锟斤拷
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

    // 锟斤拷示锟斤拷证锟斤拷锟?
    ValidationForm.ShowResults(FValidator.Results);
  finally
    ValidationForm.Free;
  end;
end;

procedure TFrmBuildConfig.btnValidateClick(Sender: TObject);
begin
  // 锟斤拷证锟斤拷锟斤拷
  if ValidateConfig then
    ShowMessage('锟斤拷证通锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟筋都锟斤拷锟较癸拷锟斤拷');
end;

end.


