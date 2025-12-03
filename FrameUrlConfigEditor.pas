unit FrameUrlConfigEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.Controls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs, Vcl.Imaging.pngimage, Winapi.ShellAPI, Winapi.Windows,
  ConfigFrameBase, UtilsTypes;

type
  // URL���ñ༭��Frame
  TFrameUrlConfigEditor = class(TBaseConfigFrame)
    pnlMain: TPanel;
    grpUrlConfig: TGroupBox;
    lblName: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    memDescription: TMemo;
    lblBaseUrl: TLabel;
    edtBaseUrl: TEdit;
    lblProtocol: TLabel;
    cbbProtocol: TComboBox;
    chkUseSSL: TCheckBox;
    lblPort: TLabel;
    edtPort: TEdit;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    lblHeaders: TLabel;
    sgHeaders: TStringGrid;
    pnlHeaderButtons: TPanel;
    btnAddHeader: TButton;
    btnDeleteHeader: TButton;
    lblParameters: TLabel;
    sgParameters: TStringGrid;
    pnlParamButtons: TPanel;
    btnAddParam: TButton;
    btnDeleteParam: TButton;
    pnlButtons: TPanel;
    btnUpdate: TButton;
    btnCancel: TButton;
    lblAuthentication: TLabel;
    cbbAuthType: TComboBox;
    lblUsername: TLabel;
    edtUsername: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    lblApiKey: TLabel;
    edtApiKey: TEdit;
    btnTestUrl: TButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddHeaderClick(Sender: TObject);
    procedure btnDeleteHeaderClick(Sender: TObject);
    procedure btnAddParamClick(Sender: TObject);
    procedure btnDeleteParamClick(Sender: TObject);
    procedure cbbAuthTypeChange(Sender: TObject);
    procedure chkUseSSLClick(Sender: TObject);
    procedure cbbProtocolChange(Sender: TObject);
    procedure btnTestUrlClick(Sender: TObject);
  private
    procedure InitControls;
    procedure InitStringGrids;
    procedure UpdateAuthenticationControls;
    function BuildFullUrl: string;
    function ValidateInput: Boolean;
  protected
    procedure LoadFromJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

uses
  System.NetEncoding, System.Net.URLClient, System.Net.HttpClient;

{ TFrameUrlConfigEditor }

constructor TFrameUrlConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitControls;
end;

destructor TFrameUrlConfigEditor.Destroy;
begin
  inherited;
end;

procedure TFrameUrlConfigEditor.CreateControls;
begin
  inherited;
  
  // ����������ڹ��캯���е��ã�����ؼ�����DFM�ļ�����ƺã�����Ҫ���ⴴ��
  // �����Ҫ��̬�����ؼ����������������Ӵ���
end;

procedure TFrameUrlConfigEditor.InitControls;
begin
  // ��ʼ��Э��������
  cbbProtocol.Items.Clear;
  cbbProtocol.Items.Add('http');
  cbbProtocol.Items.Add('https');
  cbbProtocol.Items.Add('ftp');
  cbbProtocol.Items.Add('ftps');
  cbbProtocol.Items.Add('ws');
  cbbProtocol.Items.Add('wss');
  cbbProtocol.ItemIndex := 1; // https
  
  // ��ʼ����֤��ʽ������
  cbbAuthType.Items.Clear;
  cbbAuthType.Items.Add('����֤');
  cbbAuthType.Items.Add('Basic��֤');
  cbbAuthType.Items.Add('API Key');
  cbbAuthType.Items.Add('OAuth');
  cbbAuthType.ItemIndex := 0;
  
  // Ĭ�϶˿�
  edtPort.Text := '443';
  
  // Ĭ�ϳ�ʱ(����)
  edtTimeout.Text := '30000';
  
  // ��ʼ���ַ�������
  InitStringGrids;
  
  // ������֤�ؼ�״̬
  UpdateAuthenticationControls;
end;

procedure TFrameUrlConfigEditor.InitStringGrids;
begin
  // ���ñ�ͷ����
  sgHeaders.Cells[0, 0] := '����';
  sgHeaders.Cells[1, 0] := 'ֵ';
  sgHeaders.ColWidths[0] := 150;
  sgHeaders.ColWidths[1] := 250;
  
  // �����������
  for var I := 1 to sgHeaders.RowCount - 1 do
    for var J := 0 to sgHeaders.ColCount - 1 do
      sgHeaders.Cells[J, I] := '';
  
  // ���ò�������
  sgParameters.Cells[0, 0] := '����';
  sgParameters.Cells[1, 0] := 'ֵ';
  sgParameters.Cells[2, 0] := '����';
  sgParameters.ColWidths[0] := 150;
  sgParameters.ColWidths[1] := 200;
  sgParameters.ColWidths[2] := 50;
  
  // �����������
  for var I := 1 to sgParameters.RowCount - 1 do
    for var J := 0 to sgParameters.ColCount - 1 do
      sgParameters.Cells[J, I] := '';
  
  // ��������
  sgHeaders.RowCount := 2;
  sgParameters.RowCount := 2;
  
  // ����һЩ���ñ�ͷ
  sgHeaders.Cells[0, 1] := 'Content-Type';
  sgHeaders.Cells[1, 1] := 'application/json';
end;

procedure TFrameUrlConfigEditor.LoadFromJSON;
var
  Value: TJSONValue;
  Headers, Parameters: TJSONArray;
  Item: TJSONObject;
  Row: Integer;
begin
  if not Assigned(JSONObject) then
    Exit;
  
  // ���ػ�������
  Value := JSONObject.GetValue('name');
  if Assigned(Value) then
    edtName.Text := Value.Value;
    
  Value := JSONObject.GetValue('description');
  if Assigned(Value) then
    memDescription.Text := Value.Value;
  
  // ����URL����
  Value := JSONObject.GetValue('base_url');
  if Assigned(Value) then
    edtBaseUrl.Text := Value.Value;
  
  Value := JSONObject.GetValue('protocol');
  if Assigned(Value) then
  begin
    var Protocol := Value.Value;
    var ProtocolIndex := cbbProtocol.Items.IndexOf(Protocol);
    if ProtocolIndex >= 0 then
      cbbProtocol.ItemIndex := ProtocolIndex;
  end;
  
  Value := JSONObject.GetValue('use_ssl');
  if Assigned(Value) and (Value is TJSONBool) then
    chkUseSSL.Checked := (Value as TJSONBool).AsBoolean;
  
  Value := JSONObject.GetValue('port');
  if Assigned(Value) and (Value is TJSONNumber) then
    edtPort.Text := IntToStr((Value as TJSONNumber).AsInt);
  
  Value := JSONObject.GetValue('timeout');
  if Assigned(Value) and (Value is TJSONNumber) then
    edtTimeout.Text := IntToStr((Value as TJSONNumber).AsInt);
  
  // ������֤��Ϣ
  Value := JSONObject.GetValue('auth_type');
  if Assigned(Value) then
  begin
    var AuthType := Value.Value;
    if SameText(AuthType, 'none') then
      cbbAuthType.ItemIndex := 0
    else if SameText(AuthType, 'basic') then
      cbbAuthType.ItemIndex := 1
    else if SameText(AuthType, 'apikey') then
      cbbAuthType.ItemIndex := 2
    else if SameText(AuthType, 'oauth') then
      cbbAuthType.ItemIndex := 3;
  end;
  
  Value := JSONObject.GetValue('username');
  if Assigned(Value) then
    edtUsername.Text := Value.Value;
    
  Value := JSONObject.GetValue('password');
  if Assigned(Value) then
    edtPassword.Text := Value.Value;
    
  Value := JSONObject.GetValue('api_key');
  if Assigned(Value) then
    edtApiKey.Text := Value.Value;
  
  // ���ر�ͷ
  Value := JSONObject.GetValue('headers');
  if Assigned(Value) and (Value is TJSONArray) then
  begin
    Headers := Value as TJSONArray;
    
    // �������
    for var I := 1 to sgHeaders.RowCount - 1 do
      for var J := 0 to sgHeaders.ColCount - 1 do
        sgHeaders.Cells[J, I] := '';
    
    // ����б�ͷ����������
    if Headers.Count > 0 then
    begin
      sgHeaders.RowCount := Headers.Count + 1;
      
      // ����ͷ����
      for var I := 0 to Headers.Count - 1 do
      begin
        Row := I + 1;
        Item := Headers.Items[I] as TJSONObject;
        
        var NameValue := Item.GetValue('name');
        if Assigned(NameValue) then
          sgHeaders.Cells[0, Row] := NameValue.Value;
          
        var ValueValue := Item.GetValue('value');
        if Assigned(ValueValue) then
          sgHeaders.Cells[1, Row] := ValueValue.Value;
      end;
    end
    else
      sgHeaders.RowCount := 2;
  end;
  
  // ���ز���
  Value := JSONObject.GetValue('parameters');
  if Assigned(Value) and (Value is TJSONArray) then
  begin
    Parameters := Value as TJSONArray;
    
    // �������
    for var I := 1 to sgParameters.RowCount - 1 do
      for var J := 0 to sgParameters.ColCount - 1 do
        sgParameters.Cells[J, I] := '';
    
    // ����в�������������
    if Parameters.Count > 0 then
    begin
      sgParameters.RowCount := Parameters.Count + 1;
      
      // ����������
      for var I := 0 to Parameters.Count - 1 do
      begin
        Row := I + 1;
        Item := Parameters.Items[I] as TJSONObject;
        
        var NameValue := Item.GetValue('name');
        if Assigned(NameValue) then
          sgParameters.Cells[0, Row] := NameValue.Value;
          
        var ValueValue := Item.GetValue('value');
        if Assigned(ValueValue) then
          sgParameters.Cells[1, Row] := ValueValue.Value;
        
        var RequiredValue := Item.GetValue('required');
        if Assigned(RequiredValue) and (RequiredValue is TJSONBool) then
        begin
          if (RequiredValue as TJSONBool).AsBoolean then
            sgParameters.Cells[2, Row] := 'True'
          else
            sgParameters.Cells[2, Row] := 'False';
        end;
      end;
    end
    else
      sgParameters.RowCount := 2;
  end;
  
  // ������֤�ؼ�״̬
  UpdateAuthenticationControls;
end;

procedure TFrameUrlConfigEditor.SaveToJSON;
var
  Headers, Parameters: TJSONArray;
  Item: TJSONObject;
begin
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
  
  // �����������
  JSONObject.RemovePair('_type');
  JSONObject.AddPair('_type', 'etUrlConfig');
  JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);
  JSONObject.RemovePair('description');
  JSONObject.AddPair('description', memDescription.Text);
  
  // ����URL����
  JSONObject.RemovePair('base_url');
  JSONObject.AddPair('base_url', edtBaseUrl.Text);
  
  if cbbProtocol.ItemIndex >= 0 then
  begin
    JSONObject.RemovePair('protocol');
    JSONObject.AddPair('protocol', cbbProtocol.Items[cbbProtocol.ItemIndex]);
  end;
  
  JSONObject.RemovePair('use_ssl');
  JSONObject.AddPair('use_ssl', TJSONBool.Create(chkUseSSL.Checked));
  
  try
    var Port := StrToIntDef(edtPort.Text, 443);
    JSONObject.RemovePair('port');
    JSONObject.AddPair('port', TJSONNumber.Create(Port));
  except
    JSONObject.RemovePair('port');
    JSONObject.AddPair('port', TJSONNumber.Create(443));
  end;
  
  try
    var Timeout := StrToIntDef(edtTimeout.Text, 30000);
    JSONObject.RemovePair('timeout');
    JSONObject.AddPair('timeout', TJSONNumber.Create(Timeout));
  except
    JSONObject.RemovePair('timeout');
    JSONObject.AddPair('timeout', TJSONNumber.Create(30000));
  end;
  
  // ������֤��Ϣ
  var AuthType := 'none';
  case cbbAuthType.ItemIndex of
    1: AuthType := 'basic';
    2: AuthType := 'apikey';
    3: AuthType := 'oauth';
  end;
  JSONObject.RemovePair('auth_type');
  JSONObject.AddPair('auth_type', AuthType);
  
  JSONObject.RemovePair('username');
  JSONObject.AddPair('username', edtUsername.Text);
  JSONObject.RemovePair('password');
  JSONObject.AddPair('password', edtPassword.Text);
  JSONObject.RemovePair('api_key');
  JSONObject.AddPair('api_key', edtApiKey.Text);
  
  // ������ͷ����
  Headers := TJSONArray.Create;
  
  // ���ӱ�ͷ
  for var I := 1 to sgHeaders.RowCount - 1 do
  begin
    // ��������
    if (sgHeaders.Cells[0, I] = '') and (sgHeaders.Cells[1, I] = '') then
      Continue;
    
    // ������ͷ��
    Item := TJSONObject.Create;
    Item.AddPair('name', sgHeaders.Cells[0, I]);
    Item.AddPair('value', sgHeaders.Cells[1, I]);
    
    // ���ӵ�����
    Headers.AddElement(Item);
  end;
  
  // ����JSON����
  JSONObject.RemovePair('headers');
  JSONObject.AddPair('headers', Headers);
  
  // ������������
  Parameters := TJSONArray.Create;
  
  // ���Ӳ���
  for var I := 1 to sgParameters.RowCount - 1 do
  begin
    // ��������
    if (sgParameters.Cells[0, I] = '') and (sgParameters.Cells[1, I] = '') then
      Continue;
    
    // ����������
    Item := TJSONObject.Create;
    Item.AddPair('name', sgParameters.Cells[0, I]);
    Item.AddPair('value', sgParameters.Cells[1, I]);
    
    // �����־
    var Required := False;
    if SameText(sgParameters.Cells[2, I], 'True') then
      Required := True;
    
    Item.AddPair('required', TJSONBool.Create(Required));
    
    // ���ӵ�����
    Parameters.AddElement(Item);
  end;
  
  // ����JSON����
  JSONObject.RemovePair('parameters');
  JSONObject.AddPair('parameters', Parameters);
  
  // ��������URL������
  var FullUrl := BuildFullUrl;
  JSONObject.RemovePair('full_url');
  JSONObject.AddPair('full_url', FullUrl);
  
  // �����޸ı�־Ϊfalse
  Modified := False;
end;

function TFrameUrlConfigEditor.BuildFullUrl: string;
var
  Protocol, BaseUrl, Port: string;
begin
  // ��ȡЭ��
  if cbbProtocol.ItemIndex >= 0 then
    Protocol := cbbProtocol.Items[cbbProtocol.ItemIndex]
  else
    Protocol := 'https';
  
  // ��ȡ����URL��ȥ����ͷ��http://��https://��
  BaseUrl := edtBaseUrl.Text;
  if BaseUrl.StartsWith('http://', True) then
    BaseUrl := BaseUrl.Substring(7)
  else if BaseUrl.StartsWith('https://', True) then
    BaseUrl := BaseUrl.Substring(8);
  
  // ���BaseUrl�����˿ںţ������Ӷ˿�
  if Pos(':', BaseUrl) = 0 then
  begin
    // ��ȡ�˿�
    Port := edtPort.Text;
    if (Port <> '') and (Port <> '80') and (Port <> '443') then
      BaseUrl := BaseUrl + ':' + Port;
  end;
  
  // ��������URL
  Result := Protocol + '://' + BaseUrl;
  
  // ���Ӳ�ѯ����������У�
  var HasParams := False;
  var QueryString := '';
  
  for var I := 1 to sgParameters.RowCount - 1 do
  begin
    if (sgParameters.Cells[0, I] <> '') and (sgParameters.Cells[1, I] <> '') then
    begin
      if not HasParams then
      begin
        QueryString := '?' + TNetEncoding.URL.Encode(sgParameters.Cells[0, I]) + 
                        '=' + TNetEncoding.URL.Encode(sgParameters.Cells[1, I]);
        HasParams := True;
      end
      else
      begin
        QueryString := QueryString + '&' + TNetEncoding.URL.Encode(sgParameters.Cells[0, I]) + 
                        '=' + TNetEncoding.URL.Encode(sgParameters.Cells[1, I]);
      end;
    end;
  end;
  
  Result := Result + QueryString;
end;

function TFrameUrlConfigEditor.ValidateInput: Boolean;
begin
  Result := True;
  
  // ��֤����
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('����������');
    edtName.SetFocus;
    Result := False;
    Exit;
  end;
  
  // ��֤����URL
  if Trim(edtBaseUrl.Text) = '' then
  begin
    ShowMessage('���������URL');
    edtBaseUrl.SetFocus;
    Result := False;
    Exit;
  end;
  
  // ��֤�˿�
  try
    var Port := StrToInt(edtPort.Text);
    if (Port <= 0) or (Port > 65535) then
    begin
      ShowMessage('�˿ںű�����1-65535֮��');
      edtPort.SetFocus;
      Result := False;
      Exit;
    end;
  except
    ShowMessage('��������Ч�Ķ˿ں�');
    edtPort.SetFocus;
    Result := False;
    Exit;
  end;
  
  // ��֤��ʱ
  try
    var Timeout := StrToInt(edtTimeout.Text);
    if Timeout <= 0 then
    begin
      ShowMessage('��ʱʱ��������0');
      edtTimeout.SetFocus;
      Result := False;
      Exit;
    end;
  except
    ShowMessage('��������Ч�ĳ�ʱʱ��');
    edtTimeout.SetFocus;
    Result := False;
    Exit;
  end;
  
  // ������֤������֤����
  case cbbAuthType.ItemIndex of
    1: // Basic��֤
      begin
        if Trim(edtUsername.Text) = '' then
        begin
          ShowMessage('Basic��֤��Ҫ�����û���');
          edtUsername.SetFocus;
          Result := False;
          Exit;
        end;
      end;
    2: // API Key
      begin
        if Trim(edtApiKey.Text) = '' then
        begin
          ShowMessage('API Key��֤��Ҫ����API Key');
          edtApiKey.SetFocus;
          Result := False;
          Exit;
        end;
      end;
  end;
end;

procedure TFrameUrlConfigEditor.UpdateAuthenticationControls;
begin
  // ������֤������ʾ/������ؿؼ�
  case cbbAuthType.ItemIndex of
    0: // ����֤
      begin
        lblUsername.Enabled := False;
        edtUsername.Enabled := False;
        lblPassword.Enabled := False;
        edtPassword.Enabled := False;
        lblApiKey.Enabled := False;
        edtApiKey.Enabled := False;
      end;
    1: // Basic��֤
      begin
        lblUsername.Enabled := True;
        edtUsername.Enabled := True;
        lblPassword.Enabled := True;
        edtPassword.Enabled := True;
        lblApiKey.Enabled := False;
        edtApiKey.Enabled := False;
      end;
    2: // API Key
      begin
        lblUsername.Enabled := False;
        edtUsername.Enabled := False;
        lblPassword.Enabled := False;
        edtPassword.Enabled := False;
        lblApiKey.Enabled := True;
        edtApiKey.Enabled := True;
      end;
    3: // OAuth
      begin
        lblUsername.Enabled := False;
        edtUsername.Enabled := False;
        lblPassword.Enabled := False;
        edtPassword.Enabled := False;
        lblApiKey.Enabled := False;
        edtApiKey.Enabled := False;
      end;
  end;
end;

procedure TFrameUrlConfigEditor.btnAddHeaderClick(Sender: TObject);
begin
  sgHeaders.RowCount := sgHeaders.RowCount + 1;
  Modified := True;
end;

procedure TFrameUrlConfigEditor.btnAddParamClick(Sender: TObject);
begin
  sgParameters.RowCount := sgParameters.RowCount + 1;
  Modified := True;
end;

procedure TFrameUrlConfigEditor.btnCancelClick(Sender: TObject);
begin
  LoadFromJSON;
  Modified := False;
end;

procedure TFrameUrlConfigEditor.btnDeleteHeaderClick(Sender: TObject);
begin
  if sgHeaders.Row > 0 then
  begin
    for var I := sgHeaders.Row to sgHeaders.RowCount - 2 do
      for var J := 0 to sgHeaders.ColCount - 1 do
        sgHeaders.Cells[J, I] := sgHeaders.Cells[J, I + 1];
    
    sgHeaders.RowCount := sgHeaders.RowCount - 1;
    Modified := True;
  end;
end;

procedure TFrameUrlConfigEditor.btnDeleteParamClick(Sender: TObject);
begin
  if sgParameters.Row > 0 then
  begin
    for var I := sgParameters.Row to sgParameters.RowCount - 2 do
      for var J := 0 to sgParameters.ColCount - 1 do
        sgParameters.Cells[J, I] := sgParameters.Cells[J, I + 1];
    
    sgParameters.RowCount := sgParameters.RowCount - 1;
    Modified := True;
  end;
end;

procedure TFrameUrlConfigEditor.btnTestUrlClick(Sender: TObject);
var
  HttpClient: THttpClient;
  Response: IHTTPResponse;
  FullUrl: string;
begin
  if not ValidateInput then
    Exit;
  
  FullUrl := BuildFullUrl;
  
  HttpClient := THttpClient.Create;
  try
    try
      // ���ó�ʱ
      HttpClient.ConnectionTimeout := StrToIntDef(edtTimeout.Text, 30000);
      
      // ���ӱ�ͷ
      for var I := 1 to sgHeaders.RowCount - 1 do
      begin
        if (sgHeaders.Cells[0, I] <> '') and (sgHeaders.Cells[1, I] <> '') then
          HttpClient.CustomHeaders[sgHeaders.Cells[0, I]] := sgHeaders.Cells[1, I];
      end;
      
      // ������֤����������֤��Ϣ
      case cbbAuthType.ItemIndex of
        1: // Basic��֤
          begin
            if (edtUsername.Text <> '') then
              HttpClient.CustomHeaders['Authorization'] := 'Basic ' + 
                TNetEncoding.Base64.Encode(edtUsername.Text + ':' + edtPassword.Text);
          end;
        2: // API Key
          begin
            if (edtApiKey.Text <> '') then
              HttpClient.CustomHeaders['X-API-Key'] := edtApiKey.Text;
          end;
      end;
      
      // ��������
      Response := HttpClient.Get(FullUrl);
      
      // ��ʾ״̬�����Ӧ
      ShowMessage('״̬��: ' + IntToStr(Response.StatusCode) + #13#10 + 
                 '��Ӧ: ' + Response.ContentAsString);
    except
      on E: Exception do
        ShowMessage('����ʧ��: ' + E.Message);
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TFrameUrlConfigEditor.btnUpdateClick(Sender: TObject);
begin
  if ValidateInput then
  begin
    SaveToJSON;
    Modified := False;
  end;
end;

procedure TFrameUrlConfigEditor.cbbAuthTypeChange(Sender: TObject);
begin
  UpdateAuthenticationControls;
  Modified := True;
end;

procedure TFrameUrlConfigEditor.cbbProtocolChange(Sender: TObject);
begin
  // ����Э����¶˿�
  case cbbProtocol.ItemIndex of
    0: // http
      edtPort.Text := '80';
    1: // https
      edtPort.Text := '443';
    2: // ftp
      edtPort.Text := '21';
    3: // ftps
      edtPort.Text := '990';
    4: // ws
      edtPort.Text := '80';
    5: // wss
      edtPort.Text := '443';
  end;
  
  Modified := True;
end;

procedure TFrameUrlConfigEditor.chkUseSSLClick(Sender: TObject);
begin
  Modified := True;
end;

end.
