unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, System.UITypes,
  System.IniFiles, ConfigManager, BaseConfig, INIConfig, JSONConfig, ConfigTypes;

type
  PConfigPageInfo = ^TConfigPageInfo;
  TConfigPageInfo = record
    Title: string;
    ConfigType: string;
    ConfigPath: string;
    TabSheet: TTabSheet;
    Modified: Boolean;
  end;

  TfrmMain = class(TForm)
    pnlMain: TPanel;
    splMain: TSplitter;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    tvConfig: TTreeView;
    pcEditors: TPageControl;
    sbMain: TStatusBar;
    pnlButtons: TPanel;
    btnSave: TBitBtn;
    btnReload: TBitBtn;
    btnValidate: TBitBtn;
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
    ilIcons: TImageList;
    pmTree: TPopupMenu;
    pmTreeOpen: TMenuItem;
    pmTreeNew: TMenuItem;
    pmTreeDelete: TMenuItem;
    pmTreeRename: TMenuItem;
    pmEditor: TPopupMenu;
    pmEditorSave: TMenuItem;
    pmEditorClose: TMenuItem;
    pmEditorValidate: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
  private
    { Private declarations }
    FConfigManager: TConfigManager;
    FOpenPages: TList;
    procedure InitializeTree;
    procedure AddCategoryNode(const CategoryName: string; ParentNode: TTreeNode = nil);
    procedure AddConfigNode(const ConfigName, ConfigType, ConfigPath: string; ParentNode: TTreeNode);
    procedure OpenConfigEditor(const ConfigType, ConfigPath: string);
    function FindOpenPage(const ConfigPath: string): Integer;
    procedure CloseConfigPage(Index: Integer);
    procedure SaveCurrentConfig;
    procedure ValidateCurrentConfig;
    procedure UpdateStatusBar;
    procedure SetModified(Index: Integer; Modified: Boolean);
    function GetCurrentPageInfo: TConfigPageInfo;
    procedure LoadConfigFiles;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // 纭繚config鐩綍瀛樺湪
  if not DirectoryExists('config') then
    CreateDir('config');
  
  FOpenPages := TList.Create;
  FConfigManager := TConfigManager.Create;
  
  // 鍒濆鍖栭厤缃鐞嗗櫒
  try
    FConfigManager.Initialize('config\start.ini');
  except
    on E: Exception do
      ShowMessage('鏃犳硶鍒濆鍖栭厤缃鐞嗗櫒: ' + E.Message + '銆傚皢浣跨敤榛樿閰嶇疆銆?);
  end;
  
  InitializeTree;
  UpdateStatusBar;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
  PageInfo: PConfigPageInfo;
begin
  // 閲婃斁鎵€鏈夋墦寮€鐨勯〉闈俊鎭?
  for i := 0 to FOpenPages.Count - 1 do
  begin
    PageInfo := PConfigPageInfo(FOpenPages[i]);
    Dispose(PageInfo);
  end;
  
  FOpenPages.Free;
  FConfigManager.Free;
end;

procedure TfrmMain.InitializeTree;
begin
  tvConfig.Items.Clear;
  
  // 娣诲姞涓昏閰嶇疆绫诲埆
  AddCategoryNode('绯荤粺閰嶇疆');
  AddCategoryNode('鐢ㄦ埛鐣岄潰閰嶇疆');
  AddCategoryNode('濯掍綋閰嶇疆');
  AddCategoryNode('鑷畾涔夐厤缃?);
  
  LoadConfigFiles;
  tvConfig.FullExpand;
end;

procedure TfrmMain.AddCategoryNode(const CategoryName: string; ParentNode: TTreeNode);
var
  Node: TTreeNode;
begin
  if ParentNode = nil then
    Node := tvConfig.Items.AddChild(nil, CategoryName)
  else
    Node := tvConfig.Items.AddChild(ParentNode, CategoryName);
    
  Node.ImageIndex := 0; // 鏂囦欢澶瑰浘鏍?
  Node.SelectedIndex := 1; // 鎵撳紑鐨勬枃浠跺す鍥炬爣
end;

procedure TfrmMain.AddConfigNode(const ConfigName, ConfigType, ConfigPath: string; ParentNode: TTreeNode);
var
  Node: TTreeNode;
  Data: PConfigPageInfo;
begin
  Node := tvConfig.Items.AddChild(ParentNode, ConfigName);
  
  // 璁剧疆鍥炬爣 (2:INI鏂囦欢, 3:JSON鏂囦欢, 4:鍏朵粬绫诲瀷)
  if SameText(ConfigType, 'INI') then
    Node.ImageIndex := 2
  else if SameText(ConfigType, 'JSON') then
    Node.ImageIndex := 3
  else
    Node.ImageIndex := 4;
    
  Node.SelectedIndex := Node.ImageIndex;
  
  // 瀛樺偍閰嶇疆淇℃伅
  New(Data);
  Data^.Title := ConfigName;
  Data^.ConfigType := ConfigType;
  Data^.ConfigPath := ConfigPath;
  Data^.TabSheet := nil;
  Data^.Modified := False;
  
  Node.Data := Data;
end;

procedure TfrmMain.LoadConfigFiles;
var
  ConfigFiles: TStringList;
  i, j: Integer;
  FileName, FileExt, ConfigName, CategoryName: string;
  ParentNode: TTreeNode;
  Parts: TStringList;
begin
  // 杩欓噷搴旇浠庨厤缃鐞嗗櫒鑾峰彇鎵€鏈夊凡鐭ョ殑閰嶇疆鏂囦欢
  ConfigFiles := TStringList.Create;
  Parts := TStringList.Create;
  try
    // 涓存椂娣诲姞涓€浜涚ず渚嬮厤缃枃浠?
    ConfigFiles.Add('绯荤粺閰嶇疆|system.ini|INI|config\system.ini');
    ConfigFiles.Add('鐢ㄦ埛鐣岄潰閰嶇疆|ui_settings.json|JSON|config\ui_settings.json');
    ConfigFiles.Add('濯掍綋閰嶇疆|media.json|JSON|config\media.json');
    
    Parts.Delimiter := '|';
    Parts.StrictDelimiter := True;
    
    for i := 0 to ConfigFiles.Count - 1 do
    begin
      // 鏍煎紡锛氱被鍒珅鍚嶇О|绫诲瀷|璺緞
      Parts.DelimitedText := ConfigFiles[i];
      if Parts.Count >= 4 then
      begin
        CategoryName := Parts[0];
        ConfigName := Parts[1];
        FileExt := Parts[2];
        FileName := Parts[3];
        
        // 鏌ユ壘瀵瑰簲绫诲埆鑺傜偣
        ParentNode := nil;
        for j := 0 to tvConfig.Items.Count - 1 do
        begin
          if (tvConfig.Items[j].Level = 0) and (tvConfig.Items[j].Text = CategoryName) then
          begin
            ParentNode := tvConfig.Items[j];
            Break;
          end;
        end;
        
        if ParentNode <> nil then
          AddConfigNode(ConfigName, FileExt, FileName, ParentNode);
      end;
    end;
  finally
    Parts.Free;
    ConfigFiles.Free;
  end;
end;

procedure TfrmMain.tvConfigChange(Sender: TObject; Node: TTreeNode);
begin
  // 褰撻€夋嫨鐨勮妭鐐规敼鍙樻椂鏇存柊鐘舵€佹爮
  UpdateStatusBar;
end;

procedure TfrmMain.tvConfigDblClick(Sender: TObject);
var
  Node: TTreeNode;
  PageInfo: PConfigPageInfo;
begin
  Node := tvConfig.Selected;
  if (Node <> nil) and (Node.Data <> nil) and (Node.Level > 0) then
  begin
    PageInfo := PConfigPageInfo(Node.Data);
    OpenConfigEditor(PageInfo^.ConfigType, PageInfo^.ConfigPath);
  end;
end;

procedure TfrmMain.OpenConfigEditor(const ConfigType, ConfigPath: string);
var
  Index: Integer;
  PageInfo: PConfigPageInfo;
  TabSheet: TTabSheet;
begin
  // 妫€鏌ユ閰嶇疆鏄惁宸茬粡鎵撳紑
  Index := FindOpenPage(ConfigPath);
  if Index >= 0 then
  begin
    PageInfo := PConfigPageInfo(FOpenPages[Index]);
    pcEditors.ActivePage := PageInfo^.TabSheet;
    Exit;
  end;
  
  // 鍒涘缓鏂扮殑鏍囩椤?
  TabSheet := TTabSheet.Create(pcEditors);
  TabSheet.PageControl := pcEditors;
  TabSheet.Caption := ExtractFileName(ConfigPath);
  
  // 杩欓噷搴旇娣诲姞閫傚悎璇ラ厤缃被鍨嬬殑缂栬緫鍣?
  // ...
  
  // 璁板綍鏂版墦寮€鐨勯〉闈?
  New(PageInfo);
  PageInfo^.Title := ExtractFileName(ConfigPath);
  PageInfo^.ConfigType := ConfigType;
  PageInfo^.ConfigPath := ConfigPath;
  PageInfo^.TabSheet := TabSheet;
  PageInfo^.Modified := False;
  
  FOpenPages.Add(PageInfo);
  pcEditors.ActivePage := TabSheet;
  
  UpdateStatusBar;
end;

function TfrmMain.FindOpenPage(const ConfigPath: string): Integer;
var
  i: Integer;
  PageInfo: PConfigPageInfo;
begin
  Result := -1;
  for i := 0 to FOpenPages.Count - 1 do
  begin
    PageInfo := PConfigPageInfo(FOpenPages[i]);
    if SameText(PageInfo^.ConfigPath, ConfigPath) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TfrmMain.CloseConfigPage(Index: Integer);
var
  PageInfo: PConfigPageInfo;
begin
  if (Index >= 0) and (Index < FOpenPages.Count) then
  begin
    PageInfo := PConfigPageInfo(FOpenPages[Index]);
    
    // 濡傛灉鏈夋湭淇濆瓨鐨勬洿鏀癸紝璇㈤棶鏄惁淇濆瓨
    if PageInfo^.Modified then
    begin
      case MessageDlg('閰嶇疆鏂囦欢 ' + PageInfo^.Title + ' 宸蹭慨鏀广€傛槸鍚︿繚瀛樻洿鏀?', 
        mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
        mrYes: SaveCurrentConfig;
        mrCancel: Exit;
      end;
    end;
    
    // 鍒犻櫎鏍囩椤靛拰鐩稿叧璧勬簮
    PageInfo^.TabSheet.Free;
    FOpenPages.Delete(Index);
    Dispose(PageInfo);
    
    UpdateStatusBar;
  end;
end;

procedure TfrmMain.SaveCurrentConfig;
var
  PageInfo: TConfigPageInfo;
begin
  PageInfo := GetCurrentPageInfo;
  if PageInfo.TabSheet <> nil then
  begin
    // 杩欓噷搴旇瀹炵幇淇濆瓨閰嶇疆鐨勯€昏緫
    // ...
    
    // 鏇存柊淇敼鐘舵€?
    SetModified(pcEditors.ActivePageIndex, False);
    ShowMessage('閰嶇疆宸蹭繚瀛樺埌 ' + PageInfo.ConfigPath);
  end;
end;

procedure TfrmMain.ValidateCurrentConfig;
var
  PageInfo: TConfigPageInfo;
begin
  PageInfo := GetCurrentPageInfo;
  if PageInfo.TabSheet <> nil then
  begin
    // 杩欓噷搴旇瀹炵幇楠岃瘉閰嶇疆鐨勯€昏緫
    // ...
    
    ShowMessage('閰嶇疆楠岃瘉瀹屾垚');
  end;
end;

procedure TfrmMain.UpdateStatusBar;
var
  Node: TTreeNode;
  PageInfo: PConfigPageInfo;
  StatusText: string;
begin
  StatusText := '';
  
  // 鑾峰彇褰撳墠閫変腑鐨勬爲鑺傜偣淇℃伅
  Node := tvConfig.Selected;
  if (Node <> nil) and (Node.Data <> nil) and (Node.Level > 0) then
  begin
    PageInfo := PConfigPageInfo(Node.Data);
    StatusText := '閫変腑: ' + PageInfo^.ConfigPath;
  end;
  
  // 鏇存柊鐘舵€佹爮
  sbMain.Panels[0].Text := StatusText;
  
  // 鏄剧ず鎵撳紑鐨勯厤缃暟閲?
  sbMain.Panels[1].Text := IntToStr(FOpenPages.Count) + ' 涓墦寮€';
end;

procedure TfrmMain.SetModified(Index: Integer; Modified: Boolean);
var
  i: Integer;
  PageInfo: PConfigPageInfo;
begin
  for i := 0 to FOpenPages.Count - 1 do
  begin
    PageInfo := PConfigPageInfo(FOpenPages[i]);
    if PageInfo^.TabSheet = pcEditors.Pages[Index] then
    begin
      PageInfo^.Modified := Modified;
      if Modified then
        pcEditors.Pages[Index].Caption := PageInfo^.Title + ' *'
      else
        pcEditors.Pages[Index].Caption := PageInfo^.Title;
      Break;
    end;
  end;
end;

function TfrmMain.GetCurrentPageInfo: TConfigPageInfo;
var
  i: Integer;
  PageInfo: PConfigPageInfo;
begin
  // 鍒濆鍖栫粨鏋?
  FillChar(Result, SizeOf(Result), 0);
  
  if (pcEditors.PageCount > 0) and (pcEditors.ActivePageIndex >= 0) then
  begin
    for i := 0 to FOpenPages.Count - 1 do
    begin
      PageInfo := PConfigPageInfo(FOpenPages[i]);
      if PageInfo^.TabSheet = pcEditors.ActivePage then
      begin
        Result := PageInfo^;
        Break;
      end;
    end;
  end;
end;

// 浜嬩欢澶勭悊绋嬪簭

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  SaveCurrentConfig;
end;

procedure TfrmMain.btnReloadClick(Sender: TObject);
var
  PageInfo: TConfigPageInfo;
begin
  PageInfo := GetCurrentPageInfo;
  if PageInfo.TabSheet <> nil then
  begin
    if PageInfo.Modified then
    begin
      case MessageDlg('閰嶇疆宸蹭慨鏀广€傞噸鏂板姞杞藉皢涓㈠け鎵€鏈夋湭淇濆瓨鐨勬洿鏀广€傜户缁悧?',
        mtConfirmation, [mbYes, mbNo], 0) of
        mrNo: Exit;
      end;
    end;
    
    // 杩欓噷搴旇瀹炵幇閲嶆柊鍔犺浇閰嶇疆鐨勯€昏緫
    // ...
    
    SetModified(pcEditors.ActivePageIndex, False);
    ShowMessage('閰嶇疆宸查噸鏂板姞杞?);
  end;
end;

procedure TfrmMain.btnValidateClick(Sender: TObject);
begin
  ValidateCurrentConfig;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    // 鏍规嵁鏂囦欢鎵╁睍鍚嶇‘瀹氶厤缃被鍨?
    if SameText(ExtractFileExt(dlgOpen.FileName), '.ini') then
      OpenConfigEditor('INI', dlgOpen.FileName)
    else if SameText(ExtractFileExt(dlgOpen.FileName), '.json') then
      OpenConfigEditor('JSON', dlgOpen.FileName)
    else
      ShowMessage('涓嶆敮鎸佺殑鏂囦欢绫诲瀷');
  end;
end;

procedure TfrmMain.mnuSaveClick(Sender: TObject);
begin
  SaveCurrentConfig;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
var
  PageInfo: TConfigPageInfo;
begin
  PageInfo := GetCurrentPageInfo;
  if PageInfo.TabSheet <> nil then
  begin
    dlgSave.FileName := ExtractFileName(PageInfo.ConfigPath);
    if dlgSave.Execute then
    begin
      // 杩欓噷搴旇瀹炵幇鍙﹀瓨涓哄姛鑳?
      // ...
      
      ShowMessage('閰嶇疆宸蹭繚瀛樺埌 ' + dlgSave.FileName);
    end;
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  ShowMessage('閰嶇疆缂栬緫鍣?v1.0'#13#10'漏 2023 閰嶇疆缂栬緫鍣ㄥ洟闃?);
end;

procedure TfrmMain.pcEditorsChange(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure TfrmMain.pmTreeOpenClick(Sender: TObject);
begin
  tvConfigDblClick(nil);
end;

procedure TfrmMain.pmTreeNewClick(Sender: TObject);
begin
  ShowMessage('鏂板缓閰嶇疆鍔熻兘灏氭湭瀹炵幇');
end;

procedure TfrmMain.pmTreeDeleteClick(Sender: TObject);
begin
  ShowMessage('鍒犻櫎閰嶇疆鍔熻兘灏氭湭瀹炵幇');
end;

procedure TfrmMain.pmTreeRenameClick(Sender: TObject);
begin
  ShowMessage('閲嶅懡鍚嶉厤缃姛鑳藉皻鏈疄鐜?);
end;

procedure TfrmMain.pmEditorSaveClick(Sender: TObject);
begin
  SaveCurrentConfig;
end;

procedure TfrmMain.pmEditorCloseClick(Sender: TObject);
begin
  if pcEditors.PageCount > 0 then
  begin
    CloseConfigPage(pcEditors.ActivePageIndex);
  end;
end;

procedure TfrmMain.pmEditorValidateClick(Sender: TObject);
begin
  ValidateCurrentConfig;
end;

end. 