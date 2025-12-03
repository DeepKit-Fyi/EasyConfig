unit FrameDBEditorFMX;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, FMX.Dialogs, ConfigFrameBaseFMX, UtilsTypesFMX;

type
  TFrameDBEditorFMX = class(TBaseConfigFrameFMX)
    layMain: TLayout;
    layType: TLayout;
    lblType: TLabel;
    cboType: TComboBox;
    layHost: TLayout;
    lblHost: TLabel;
    edtHost: TEdit;
    layPort: TLayout;
    lblPort: TLabel;
    spnPort: TSpinBox;
    layDatabase: TLayout;
    lblDatabase: TLabel;
    edtDatabase: TEdit;
    btnBrowse: TButton;
    layUser: TLayout;
    lblUser: TLabel;
    edtUser: TEdit;
    layPassword: TLayout;
    lblPassword: TLabel;
    edtPassword: TEdit;
    layOptions: TLayout;
    lblOptions: TLabel;
    grpOptions: TGroupBox;
    layJournalMode: TLayout;
    lblJournalMode: TLabel;
    cboJournalMode: TComboBox;
    laySynchronous: TLayout;
    lblSynchronous: TLabel;
    cboSynchronous: TComboBox;
    layTimeout: TLayout;
    lblTimeout: TLabel;
    spnTimeout: TSpinBox;
    layButtons: TLayout;
    btnTest: TButton;
    lblTestResult: TLabel;
    procedure cboTypeChange(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    procedure UpdateUIForDBType;
    function GetDefaultPort: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    function Validate(out ErrorMsg: string): Boolean; override;
    function GetEditorType: TEditorType; override;
    procedure Clear; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.DialogService;

{ TFrameDBEditorFMX }

constructor TFrameDBEditorFMX.Create(AOwner: TComponent);
begin
  inherited;
  
  // 初始化数据库类型列表
  cboType.Items.Clear;
  cboType.Items.Add('SQLite');
  cboType.Items.Add('PostgreSQL');
  cboType.Items.Add('MySQL');
  cboType.Items.Add('MSSQL');
  cboType.ItemIndex := 0;
  
  // 初始化 JournalMode 列表
  cboJournalMode.Items.Clear;
  cboJournalMode.Items.Add('WAL');
  cboJournalMode.Items.Add('DELETE');
  cboJournalMode.Items.Add('TRUNCATE');
  cboJournalMode.Items.Add('PERSIST');
  cboJournalMode.Items.Add('MEMORY');
  cboJournalMode.Items.Add('OFF');
  cboJournalMode.ItemIndex := 0;
  
  // 初始化 Synchronous 列表
  cboSynchronous.Items.Clear;
  cboSynchronous.Items.Add('Normal');
  cboSynchronous.Items.Add('Full');
  cboSynchronous.Items.Add('Off');
  cboSynchronous.ItemIndex := 0;
  
  UpdateUIForDBType;
end;

procedure TFrameDBEditorFMX.LoadFromJSON;
var
  DBType: string;
  OptionsObj: TJSONObject;
  Idx: Integer;
begin
  if not Assigned(JSONObject) then Exit;
  
  // 加载数据库类型
  DBType := GetJSONString('Type', 'SQLite');
  Idx := cboType.Items.IndexOf(DBType);
  if Idx >= 0 then
    cboType.ItemIndex := Idx
  else
    cboType.ItemIndex := 0;
  
  // 加载连接信息
  edtHost.Text := GetJSONString('Host', '');
  spnPort.Value := GetJSONInt('Port', GetDefaultPort);
  edtDatabase.Text := GetJSONString('Database', '');
  edtUser.Text := GetJSONString('User', '');
  edtPassword.Text := GetJSONString('Password', '');
  
  // 加载选项
  if JSONObject.TryGetValue<TJSONObject>('Options', OptionsObj) then
  begin
    if OptionsObj.TryGetValue('JournalMode', DBType) then
    begin
      Idx := cboJournalMode.Items.IndexOf(DBType);
      if Idx >= 0 then
        cboJournalMode.ItemIndex := Idx;
    end;
    
    if OptionsObj.TryGetValue('Synchronous', DBType) then
    begin
      Idx := cboSynchronous.Items.IndexOf(DBType);
      if Idx >= 0 then
        cboSynchronous.ItemIndex := Idx;
    end;
    
    spnTimeout.Value := GetJSONInt('BusyTimeout', 5000);
  end;
  
  UpdateUIForDBType;
end;

procedure TFrameDBEditorFMX.SaveToJSON;
var
  OptionsObj: TJSONObject;
begin
  if cboType.ItemIndex >= 0 then
    SetJSONString('Type', cboType.Items[cboType.ItemIndex])
  else
    SetJSONString('Type', 'SQLite');
    
  SetJSONString('Host', edtHost.Text);
  SetJSONInt('Port', Round(spnPort.Value));
  SetJSONString('Database', edtDatabase.Text);
  SetJSONString('User', edtUser.Text);
  SetJSONString('Password', edtPassword.Text);
  
  // 保存选项
  OptionsObj := TJSONObject.Create;
  if cboJournalMode.ItemIndex >= 0 then
    OptionsObj.AddPair('JournalMode', cboJournalMode.Items[cboJournalMode.ItemIndex]);
  if cboSynchronous.ItemIndex >= 0 then
    OptionsObj.AddPair('Synchronous', cboSynchronous.Items[cboSynchronous.ItemIndex]);
  OptionsObj.AddPair('BusyTimeout', TJSONNumber.Create(Round(spnTimeout.Value)));
  
  if JSONObject.GetValue('Options') <> nil then
    JSONObject.RemovePair('Options');
  JSONObject.AddPair('Options', OptionsObj);
  
  // 设置类型标识
  SetJSONString('$type', 'Database');
end;

function TFrameDBEditorFMX.Validate(out ErrorMsg: string): Boolean;
begin
  Result := True;
  ErrorMsg := '';
  
  if cboType.ItemIndex < 0 then
  begin
    ErrorMsg := '请选择数据库类型';
    Result := False;
    Exit;
  end;
  
  // SQLite 需要数据库路径
  if cboType.Items[cboType.ItemIndex] = 'SQLite' then
  begin
    if Trim(edtDatabase.Text) = '' then
    begin
      ErrorMsg := '请输入数据库文件路径';
      Result := False;
      Exit;
    end;
  end
  else
  begin
    // 其他数据库需要主机和端口
    if Trim(edtHost.Text) = '' then
    begin
      ErrorMsg := '请输入数据库主机地址';
      Result := False;
      Exit;
    end;
    
    if Trim(edtDatabase.Text) = '' then
    begin
      ErrorMsg := '请输入数据库名称';
      Result := False;
      Exit;
    end;
  end;
end;

function TFrameDBEditorFMX.GetEditorType: TEditorType;
begin
  Result := etDatabase;
end;

procedure TFrameDBEditorFMX.Clear;
begin
  inherited;
  cboType.ItemIndex := 0;
  edtHost.Text := '';
  spnPort.Value := 0;
  edtDatabase.Text := '';
  edtUser.Text := '';
  edtPassword.Text := '';
  cboJournalMode.ItemIndex := 0;
  cboSynchronous.ItemIndex := 0;
  spnTimeout.Value := 5000;
  lblTestResult.Text := '';
  UpdateUIForDBType;
end;

procedure TFrameDBEditorFMX.cboTypeChange(Sender: TObject);
begin
  DoModified(Sender);
  spnPort.Value := GetDefaultPort;
  UpdateUIForDBType;
end;

procedure TFrameDBEditorFMX.edtChange(Sender: TObject);
begin
  DoModified(Sender);
end;

procedure TFrameDBEditorFMX.btnBrowseClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Title := '选择数据库文件';
    Dlg.Filter := '数据库文件|*.db;*.sqlite;*.sqlite3;*.mdb;*.accdb|所有文件|*.*';
    if Dlg.Execute then
    begin
      edtDatabase.Text := Dlg.FileName;
      DoModified(nil);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TFrameDBEditorFMX.btnTestClick(Sender: TObject);
begin
  // 简单的连接测试（实际实现需要根据数据库类型进行）
  lblTestResult.Text := '连接测试功能待实现...';
  lblTestResult.TextSettings.FontColor := TAlphaColorRec.Orange;
end;

procedure TFrameDBEditorFMX.UpdateUIForDBType;
var
  IsSQLite: Boolean;
begin
  if cboType.ItemIndex < 0 then Exit;
  
  IsSQLite := cboType.Items[cboType.ItemIndex] = 'SQLite';
  
  // SQLite 不需要主机、端口、用户名、密码
  layHost.Visible := not IsSQLite;
  layPort.Visible := not IsSQLite;
  layUser.Visible := not IsSQLite;
  layPassword.Visible := not IsSQLite;
  
  // SQLite 特有的选项
  grpOptions.Visible := IsSQLite;
  
  // 浏览按钮只在 SQLite 模式下显示
  btnBrowse.Visible := IsSQLite;
  
  // 更新标签文字
  if IsSQLite then
    lblDatabase.Text := '数据库路径:'
  else
    lblDatabase.Text := '数据库名称:';
end;

function TFrameDBEditorFMX.GetDefaultPort: Integer;
begin
  if cboType.ItemIndex < 0 then
    Exit(0);
    
  case cboType.ItemIndex of
    0: Result := 0;      // SQLite
    1: Result := 5432;   // PostgreSQL
    2: Result := 3306;   // MySQL
    3: Result := 1433;   // MSSQL
  else
    Result := 0;
  end;
end;

end.
