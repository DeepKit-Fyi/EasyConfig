unit FrameDBEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, ConfigFrameBase, UtilsTypes, System.JSON, JSONHelpers;

type
  TNotifyEventEx = procedure(Sender: TObject) of object;

  TFrameDBEditor = class(TBaseConfigFrame)
    pnlDBEditor: TPanel;
    lblDBType: TLabel;
    cmbDBType: TComboBox;
    lblServer: TLabel;
    edtServer: TEdit;
    lblPort: TLabel;
    edtPort: TEdit;
    lblDatabase: TLabel;
    edtDatabase: TEdit;
    lblUsername: TLabel;
    edtUsername: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    chkIntegratedSecurity: TCheckBox;
    btnTestConnection: TButton;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbDBTypeChange(Sender: TObject);
    procedure chkIntegratedSecurityClick(Sender: TObject);
  private
    FConnectionString: string;
    FDBType: string;
    FServer: string;
    FPort: string;
    FDatabase: string;
    FUsername: string;
    FPassword: string;
    FIntegratedSecurity: Boolean;
    FOnSave: TNotifyEventEx;
    FOnCancel: TNotifyEventEx;
    
    procedure UpdateControls;
    function BuildConnectionString: string;
    function ParseConnectionString(const ConnectionString: string): Boolean;
    function TestConnection: Boolean;
    function LoadJSONObject(const JSONObj: TJSONObject): Boolean;
    function SaveToJSONObject(JSONObj: TJSONObject): Boolean;
  protected
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    property ConnectionString: string read FConnectionString write FConnectionString;
    property OnSave: TNotifyEventEx read FOnSave write FOnSave;
    property OnCancel: TNotifyEventEx read FOnCancel write FOnCancel;
  end;

implementation

{$R *.dfm}

constructor TFrameDBEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  // ��ʼ�����ݿ�����������
  cmbDBType.Items.Clear;
  cmbDBType.Items.Add('MSSQL');
  cmbDBType.Items.Add('MySQL');
  cmbDBType.Items.Add('PostgreSQL');
  cmbDBType.Items.Add('Oracle');
  cmbDBType.Items.Add('SQLite');
  cmbDBType.ItemIndex := 0;
  
  // Ĭ��ֵ
  FDBType := 'MSSQL';
  FServer := 'localhost';
  FPort := '1433';
  FDatabase := '';
  FUsername := '';
  FPassword := '';
  FIntegratedSecurity := True;
  
  UpdateControls;
end;

destructor TFrameDBEditor.Destroy;
begin
  inherited;
end;

function TFrameDBEditor.LoadJSONObject(const JSONObj: TJSONObject): Boolean;
var
  Value: TJSONValue;
begin
  Result := False;
  if not Assigned(JSONObj) then
    Exit;
    
  // ��JSON�����л�ȡ������Ϣ
  Value := JSONObj.GetValue('dbtype');
  if Assigned(Value) and (Value is TJSONString) then
    FDBType := TJSONString(Value).Value
  else
    FDBType := 'MSSQL';
    
  // �������ݿ�����������
  cmbDBType.ItemIndex := cmbDBType.Items.IndexOf(FDBType);
  if cmbDBType.ItemIndex < 0 then
    cmbDBType.ItemIndex := 0;
  
  Value := JSONObj.GetValue('server');
  if Assigned(Value) and (Value is TJSONString) then
    FServer := TJSONString(Value).Value
  else
    FServer := 'localhost';
  edtServer.Text := FServer;
  
  Value := JSONObj.GetValue('port');
  if Assigned(Value) and (Value is TJSONString) then
    FPort := TJSONString(Value).Value
  else
    FPort := '1433';
  edtPort.Text := FPort;
  
  Value := JSONObj.GetValue('database');
  if Assigned(Value) and (Value is TJSONString) then
    FDatabase := TJSONString(Value).Value
  else
    FDatabase := '';
  edtDatabase.Text := FDatabase;
  
  Value := JSONObj.GetValue('integrated_security');
  if Assigned(Value) and (Value is TJSONBool) then
    FIntegratedSecurity := TJSONBool(Value).AsBoolean
  else
    FIntegratedSecurity := True;
  chkIntegratedSecurity.Checked := FIntegratedSecurity;
  
  Value := JSONObj.GetValue('username');
  if Assigned(Value) and (Value is TJSONString) then
    FUsername := TJSONString(Value).Value
  else
    FUsername := '';
  edtUsername.Text := FUsername;
  
  Value := JSONObj.GetValue('password');
  if Assigned(Value) and (Value is TJSONString) then
    FPassword := TJSONString(Value).Value
  else
    FPassword := '';
  edtPassword.Text := FPassword;
  
  // ���½���
  UpdateControls;
  Result := True;
end;

procedure TFrameDBEditor.LoadFromJSON;
begin
  LoadJSONObject(JSONObject);
end;

function TFrameDBEditor.SaveToJSONObject(JSONObj: TJSONObject): Boolean;
begin
  Result := False;
  if not Assigned(JSONObj) then
    Exit;
    
  // �ӽ����ȡ����
  FDBType := cmbDBType.Text;
  FServer := edtServer.Text;
  FPort := edtPort.Text;
  FDatabase := edtDatabase.Text;
  FIntegratedSecurity := chkIntegratedSecurity.Checked;
  FUsername := edtUsername.Text;
  FPassword := edtPassword.Text;
  
  // �������ݿ���������
  if JSONObj.GetValue('_type') = nil then
    JSONObj.AddPair('_type', ConfigTypeToString(ctDatabase));
  
  // ���浽JSON����
  if JSONObj.GetValue('dbtype') <> nil then
    JSONObj.RemovePair('dbtype');
  JSONObj.AddPair('dbtype', FDBType);
  
  if JSONObj.GetValue('server') <> nil then
    JSONObj.RemovePair('server');
  JSONObj.AddPair('server', FServer);
  
  if JSONObj.GetValue('port') <> nil then
    JSONObj.RemovePair('port');
  JSONObj.AddPair('port', FPort);
  
  if JSONObj.GetValue('database') <> nil then
    JSONObj.RemovePair('database');
  JSONObj.AddPair('database', FDatabase);
  
  if JSONObj.GetValue('integrated_security') <> nil then
    JSONObj.RemovePair('integrated_security');
  JSONObj.AddPair('integrated_security', TJSONBool.Create(FIntegratedSecurity));
  
  if JSONObj.GetValue('username') <> nil then
    JSONObj.RemovePair('username');
  JSONObj.AddPair('username', FUsername);
  
  if JSONObj.GetValue('password') <> nil then
    JSONObj.RemovePair('password');
  JSONObj.AddPair('password', FPassword);
  
  // ���������������ַ���
  if JSONObj.GetValue('connection_string') <> nil then
    JSONObj.RemovePair('connection_string');
  JSONObj.AddPair('connection_string', BuildConnectionString);
  
  Result := True;
end;

procedure TFrameDBEditor.SaveToJSON;
begin
  // ȷ��JSONObject��Ϊ��
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
    
  SaveToJSONObject(JSONObject);
  Modified := True;
end;

procedure TFrameDBEditor.btnCancelClick(Sender: TObject);
begin
  // ȡ���༭
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

procedure TFrameDBEditor.btnSaveClick(Sender: TObject);
begin
  // ����������Ϣ
  FDBType := cmbDBType.Text;
  FServer := edtServer.Text;
  FPort := edtPort.Text;
  FDatabase := edtDatabase.Text;
  FIntegratedSecurity := chkIntegratedSecurity.Checked;
  FUsername := edtUsername.Text;
  FPassword := edtPassword.Text;
  
  // ���������ַ���
  FConnectionString := BuildConnectionString;
  
  // ���������¼�
  if Assigned(FOnSave) then
    FOnSave(Self);
end;

procedure TFrameDBEditor.btnTestConnectionClick(Sender: TObject);
begin
  // ��������
  if TestConnection then
    ShowMessage('���ӳɹ���')
  else
    ShowMessage('����ʧ�ܣ�����������Ϣ��');
end;

procedure TFrameDBEditor.chkIntegratedSecurityClick(Sender: TObject);
begin
  // ���¿ؼ�״̬
  UpdateControls;
end;

procedure TFrameDBEditor.cmbDBTypeChange(Sender: TObject);
begin
  // �������ݿ����͸���Ĭ�϶˿�
  FDBType := cmbDBType.Text;
  
  if FDBType = 'MSSQL' then
    edtPort.Text := '1433'
  else if FDBType = 'MySQL' then
    edtPort.Text := '3306'
  else if FDBType = 'PostgreSQL' then
    edtPort.Text := '5432'
  else if FDBType = 'Oracle' then
    edtPort.Text := '1521'
  else if FDBType = 'SQLite' then
    edtPort.Text := '';
  
  // ���¿ؼ�״̬
  UpdateControls;
end;

procedure TFrameDBEditor.UpdateControls;
begin
  // �������ݿ����ͺͼ��ɰ�ȫ�����ÿؼ�״̬
  lblPort.Visible := FDBType <> 'SQLite';
  edtPort.Visible := FDBType <> 'SQLite';
  
  chkIntegratedSecurity.Visible := (FDBType = 'MSSQL');
  
  lblUsername.Enabled := not (chkIntegratedSecurity.Visible and chkIntegratedSecurity.Checked);
  edtUsername.Enabled := lblUsername.Enabled;
  
  lblPassword.Enabled := lblUsername.Enabled;
  edtPassword.Enabled := lblUsername.Enabled;
end;

function TFrameDBEditor.BuildConnectionString: string;
begin
  // �������ݿ����͹��������ַ���
  if FDBType = 'MSSQL' then
  begin
    if FIntegratedSecurity then
      Result := Format('Server=%s,%s;Database=%s;Integrated Security=SSPI;', [FServer, FPort, FDatabase])
    else
      Result := Format('Server=%s,%s;Database=%s;User Id=%s;Password=%s;', [FServer, FPort, FDatabase, FUsername, FPassword]);
  end
  else if FDBType = 'MySQL' then
    Result := Format('Server=%s;Port=%s;Database=%s;Uid=%s;Pwd=%s;', [FServer, FPort, FDatabase, FUsername, FPassword])
  else if FDBType = 'PostgreSQL' then
    Result := Format('Server=%s;Port=%s;Database=%s;User Id=%s;Password=%s;', [FServer, FPort, FDatabase, FUsername, FPassword])
  else if FDBType = 'Oracle' then
    Result := Format('Data Source=%s:%s/%s;User Id=%s;Password=%s;', [FServer, FPort, FDatabase, FUsername, FPassword])
  else if FDBType = 'SQLite' then
    Result := Format('Data Source=%s;Version=3;', [FDatabase]);
end;

function TFrameDBEditor.ParseConnectionString(const ConnectionString: string): Boolean;
var
  Parts: TArray<string>;
  Part: string;
  Key, Value: string;
  i, SepPos: Integer;
begin
  Result := False;
  
  // Ĭ��ֵ
  FDBType := 'MSSQL';
  FServer := 'localhost';
  FPort := '1433';
  FDatabase := '';
  FUsername := '';
  FPassword := '';
  FIntegratedSecurity := False;
  
  // ���������ַ���
  Parts := ConnectionString.Split([';']);
  
  for Part in Parts do
  begin
    if Part = '' then Continue;
    
    SepPos := Pos('=', Part);
    if SepPos > 0 then
    begin
      Key := Trim(Copy(Part, 1, SepPos - 1));
      Value := Trim(Copy(Part, SepPos + 1, Length(Part)));
      
      if SameText(Key, 'Server') then
      begin
        // �����������Ͷ˿�
        i := Pos(',', Value);
        if i > 0 then
        begin
          FServer := Copy(Value, 1, i - 1);
          FPort := Copy(Value, i + 1, Length(Value));
        end
        else
          FServer := Value;
      end
      else if SameText(Key, 'Port') then
        FPort := Value
      else if SameText(Key, 'Database') or SameText(Key, 'Data Source') then
        FDatabase := Value
      else if SameText(Key, 'User Id') or SameText(Key, 'Uid') then
        FUsername := Value
      else if SameText(Key, 'Password') or SameText(Key, 'Pwd') then
        FPassword := Value
      else if SameText(Key, 'Integrated Security') and (Value = 'SSPI') then
        FIntegratedSecurity := True;
    end;
  end;
  
  // ���������ַ����ƶ����ݿ�����
  if Pos('Integrated Security=SSPI', ConnectionString) > 0 then
    FDBType := 'MSSQL'
  else if Pos('Uid=', ConnectionString) > 0 then
    FDBType := 'MySQL'
  else if Pos('Version=3', ConnectionString) > 0 then
    FDBType := 'SQLite';
  
  // ���½���
  cmbDBType.ItemIndex := cmbDBType.Items.IndexOf(FDBType);
  edtServer.Text := FServer;
  edtPort.Text := FPort;
  edtDatabase.Text := FDatabase;
  edtUsername.Text := FUsername;
  edtPassword.Text := FPassword;
  chkIntegratedSecurity.Checked := FIntegratedSecurity;
  
  UpdateControls;
  Result := True;
end;

function TFrameDBEditor.TestConnection: Boolean;
begin
  // ��ʵ��Ӧ���У�����Ӧ�ó��Խ������ݿ�����
  // Ϊ����ʾ������ֻ�Ƿ���һ��ģ��Ľ��
  Result := (FServer <> '') and (FDatabase <> '');
  
  if not Result then
    ShowMessage('�����������ݿ����Ʋ���Ϊ��');
end;

end.

