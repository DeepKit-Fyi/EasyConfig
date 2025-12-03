unit FrameEncryptEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.JSON, System.NetEncoding, ConfigFrameBase, JSONHelpers;

type
  TFrameEncryptEditor = class(TBaseConfigFrame)
    pnlMain: TPanel;
    grpEncrypt: TGroupBox;
    lblName: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    memDescription: TMemo;
    pcEncrypt: TPageControl;
    tsAlgorithm: TTabSheet;
    pnlAlgorithm: TPanel;
    lblEncryptionType: TLabel;
    cbbEncryptionType: TComboBox;
    lblAlgorithm: TLabel;
    cbbAlgorithm: TComboBox;
    lblKeySize: TLabel;
    cbbKeySize: TComboBox;
    lblMode: TLabel;
    cbbMode: TComboBox;
    lblPadding: TLabel;
    cbbPadding: TComboBox;
    chkUseIV: TCheckBox;
    chkDefaultIV: TCheckBox;
    lblIV: TLabel;
    edtIV: TEdit;
    btnGenerateIV: TButton;
    tsKeys: TTabSheet;
    pnlKeys: TPanel;
    lblKeyFormat: TLabel;
    cbbKeyFormat: TComboBox;
    lblPrivateKey: TLabel;
    edtPrivateKeyFile: TEdit;
    btnBrowsePrivateKey: TButton;
    lblPublicKey: TLabel;
    edtPublicKeyFile: TEdit;
    btnBrowsePublicKey: TButton;
    chkGenerateKeyPair: TCheckBox;
    lblPassword: TLabel;
    edtPassword: TEdit;
    lblSalt: TLabel;
    edtSalt: TEdit;
    btnGenerateSalt: TButton;
    lblKeyDerivation: TLabel;
    cbbKeyDerivation: TComboBox;
    lblIterations: TLabel;
    edtIterations: TEdit;
    rbUseKeyFile: TRadioButton;
    rbUsePassword: TRadioButton;
    tsCertificate: TTabSheet;
    pnlCertificate: TPanel;
    lblCertificateAuthority: TLabel;
    cbbCertificateAuth: TComboBox;
    lblCertificateStore: TLabel;
    cbbCertificateStore: TComboBox;
    rbUseCertFile: TRadioButton;
    rbSelectFromStore: TRadioButton;
    lblCertificateFile: TLabel;
    edtCertificateFile: TEdit;
    btnBrowseCertificate: TButton;
    lblCertificateSubject: TLabel;
    edtCertificateSubject: TEdit;
    pnlButtons: TPanel;
    btnUpdate: TButton;
    btnCancel: TButton;
    dlgOpenKey: TOpenDialog;
    dlgOpenCert: TOpenDialog;
    dlgSaveKey: TSaveDialog;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbbEncryptionTypeChange(Sender: TObject);
    procedure cbbAlgorithmChange(Sender: TObject);
    procedure rbUseKeyFileClick(Sender: TObject);
    procedure rbUsePasswordClick(Sender: TObject);
    procedure btnBrowsePrivateKeyClick(Sender: TObject);
    procedure btnBrowsePublicKeyClick(Sender: TObject);
    procedure btnBrowseCertificateClick(Sender: TObject);
    procedure chkUseIVClick(Sender: TObject);
    procedure chkDefaultIVClick(Sender: TObject);
    procedure chkGenerateKeyPairClick(Sender: TObject);
    procedure btnGenerateSaltClick(Sender: TObject);
    procedure btnGenerateIVClick(Sender: TObject);
    procedure rbUseCertFileClick(Sender: TObject);
    procedure rbSelectFromStoreClick(Sender: TObject);
  private
    procedure InitControls;
    procedure UpdateAlgorithmControls;
    procedure UpdateKeyControls;
    procedure UpdateCertificateControls;
    function GenerateRandomSalt(Size: Integer = 16): string;
    function GenerateRandomString(Length: Integer): string;
    function GenerateRandomHex(Length: Integer): string;
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

{ TFrameEncryptEditor }

constructor TFrameEncryptEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitControls;
end;

destructor TFrameEncryptEditor.Destroy;
begin
  inherited;
end;

procedure TFrameEncryptEditor.CreateControls;
begin
  inherited;
  
  // 此方法会在构造函数中调用，如果控件已在DFM文件中设计好，则不需要额外创建
  // 如果需要动态创建控件，可以在这里添加代码
end;

procedure TFrameEncryptEditor.InitControls;
begin
  // 初始化加密类型下拉列表
  cbbEncryptionType.Items.Clear;
  cbbEncryptionType.Items.Add('对称加密');
  cbbEncryptionType.Items.Add('非对称加密');
  cbbEncryptionType.Items.Add('哈希算法');
  cbbEncryptionType.Items.Add('HMAC');
  cbbEncryptionType.ItemIndex := 0;
  
  // 初始化算法下拉列表（对称加密）
  cbbAlgorithm.Items.Clear;
  cbbAlgorithm.Items.Add('AES');
  cbbAlgorithm.Items.Add('DES');
  cbbAlgorithm.Items.Add('3DES');
  cbbAlgorithm.Items.Add('RC4');
  cbbAlgorithm.Items.Add('Blowfish');
  cbbAlgorithm.ItemIndex := 0;
  
  // 初始化密钥大小下拉列表
  cbbKeySize.Items.Clear;
  cbbKeySize.Items.Add('128 位');
  cbbKeySize.Items.Add('192 位');
  cbbKeySize.Items.Add('256 位');
  cbbKeySize.ItemIndex := 2; // 默认AES-256
  
  // 初始化模式下拉列表
  cbbMode.Items.Clear;
  cbbMode.Items.Add('CBC');
  cbbMode.Items.Add('ECB');
  cbbMode.Items.Add('CFB');
  cbbMode.Items.Add('OFB');
  cbbMode.Items.Add('CTR');
  cbbMode.ItemIndex := 0; // 默认CBC
  
  // 初始化填充方式下拉列表
  cbbPadding.Items.Clear;
  cbbPadding.Items.Add('PKCS7');
  cbbPadding.Items.Add('Zero');
  cbbPadding.Items.Add('ANSI X.923');
  cbbPadding.Items.Add('ISO 10126');
  cbbPadding.Items.Add('No Padding');
  cbbPadding.ItemIndex := 0; // 默认PKCS7
  
  // 初始化密钥格式下拉列表
  cbbKeyFormat.Items.Clear;
  cbbKeyFormat.Items.Add('二进制');
  cbbKeyFormat.Items.Add('Base64');
  cbbKeyFormat.Items.Add('Hex');
  cbbKeyFormat.Items.Add('PEM');
  cbbKeyFormat.ItemIndex := 1; // 默认Base64
  
  // 初始化密钥派生函数下拉列表
  cbbKeyDerivation.Items.Clear;
  cbbKeyDerivation.Items.Add('PBKDF2');
  cbbKeyDerivation.Items.Add('HKDF');
  cbbKeyDerivation.Items.Add('Scrypt');
  cbbKeyDerivation.Items.Add('Argon2');
  cbbKeyDerivation.ItemIndex := 0; // 默认PBKDF2
  
  // 初始化证书颁发机构下拉列表
  cbbCertificateAuth.Items.Clear;
  cbbCertificateAuth.Items.Add('自签名');
  cbbCertificateAuth.Items.Add('商业CA');
  cbbCertificateAuth.Items.Add('企业CA');
  cbbCertificateAuth.Items.Add('Let''s Encrypt');
  cbbCertificateAuth.ItemIndex := 0; // 默认自签名
  
  // 初始化证书存储位置下拉列表
  cbbCertificateStore.Items.Clear;
  cbbCertificateStore.Items.Add('文件系统');
  cbbCertificateStore.Items.Add('Windows证书存储');
  cbbCertificateStore.Items.Add('HSM/智能卡');
  cbbCertificateStore.ItemIndex := 0; // 默认文件系统
  
  // 设置默认迭代次数
  edtIterations.Text := '10000';
  
  // 设置文件对话框过滤器
  dlgOpenKey.Filter := '密钥文件(*.key;*.pem;*.ppk)|*.key;*.pem;*.ppk|所有文件(*.*)|*.*';
  dlgOpenCert.Filter := '证书文件(*.crt;*.cert;*.cer;*.pem)|*.crt;*.cert;*.cer;*.pem|所有文件(*.*)|*.*';
  
  // 选择默认的密钥方式
  if not Assigned(rbUseKeyFile) then
    rbUseKeyFile := TRadioButton.Create(Self);
  if not Assigned(rbUsePassword) then
    rbUsePassword := TRadioButton.Create(Self);
  
  rbUseKeyFile.Checked := False;
  rbUsePassword.Checked := True;
  
  // 选择默认的证书方式
  if not Assigned(rbUseCertFile) then
    rbUseCertFile := TRadioButton.Create(Self);
  if not Assigned(rbSelectFromStore) then
    rbSelectFromStore := TRadioButton.Create(Self);
  
  rbUseCertFile.Checked := True;
  rbSelectFromStore.Checked := False;
  
  // 更新控件状态
  UpdateAlgorithmControls;
  UpdateKeyControls;
  UpdateCertificateControls;
end;

procedure TFrameEncryptEditor.LoadFromJSON;
begin
  if not Assigned(JSONObject) then
    Exit;
  
  // 加载基本属性
  var Value: TJSONValue;
  var StrValue: string;
  
  Value := JSONObject.GetValue('name');
  if Assigned(Value) then
    edtName.Text := Value.Value;
    
  Value := JSONObject.GetValue('description');
  if Assigned(Value) then
    memDescription.Text := Value.Value;
  
  // 加载算法设置
  Value := JSONObject.GetValue('encryption_type');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbEncryptionType.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbEncryptionType.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('algorithm');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbAlgorithm.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbAlgorithm.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('key_size');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbKeySize.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbKeySize.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('mode');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbMode.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbMode.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('padding');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbPadding.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbPadding.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('use_iv');
  if Assigned(Value) and (Value is TJSONBool) then
    chkUseIV.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('default_iv');
  if Assigned(Value) and (Value is TJSONBool) then
    chkDefaultIV.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('iv');
  if Assigned(Value) then
    edtIV.Text := Value.Value;
  
  // 加载密钥设置
  Value := JSONObject.GetValue('key_format');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbKeyFormat.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbKeyFormat.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('use_key_file');
  if Assigned(Value) and (Value is TJSONBool) then
  begin
    if (Value as TJSONBool).AsBoolean then
    begin
      rbUseKeyFile.Checked := True;
      rbUsePassword.Checked := False;
    end
    else
    begin
      rbUseKeyFile.Checked := False;
      rbUsePassword.Checked := True;
    end;
  end;
  
  Value := JSONObject.GetValue('private_key_file');
  if Assigned(Value) then
    edtPrivateKeyFile.Text := Value.Value;
    
  Value := JSONObject.GetValue('public_key_file');
  if Assigned(Value) then
    edtPublicKeyFile.Text := Value.Value;
    
  Value := JSONObject.GetValue('generate_key_pair');
  if Assigned(Value) and (Value is TJSONBool) then
    chkGenerateKeyPair.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('password');
  if Assigned(Value) then
    edtPassword.Text := Value.Value;
    
  Value := JSONObject.GetValue('salt');
  if Assigned(Value) then
    edtSalt.Text := Value.Value;
    
  Value := JSONObject.GetValue('iterations');
  if Assigned(Value) then
    edtIterations.Text := Value.Value;
    
  Value := JSONObject.GetValue('key_derivation');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbKeyDerivation.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbKeyDerivation.ItemIndex := Index;
  end;
  
  // 加载证书设置
  Value := JSONObject.GetValue('use_cert_file');
  if Assigned(Value) and (Value is TJSONBool) then
  begin
    if (Value as TJSONBool).AsBoolean then
    begin
      rbUseCertFile.Checked := True;
      rbSelectFromStore.Checked := False;
    end
    else
    begin
      rbUseCertFile.Checked := False;
      rbSelectFromStore.Checked := True;
    end;
  end;
  
  Value := JSONObject.GetValue('certificate_authority');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbCertificateAuth.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbCertificateAuth.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('certificate_store');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    var Index := cbbCertificateStore.Items.IndexOf(StrValue);
    if Index >= 0 then
      cbbCertificateStore.ItemIndex := Index;
  end;
  
  Value := JSONObject.GetValue('certificate_file');
  if Assigned(Value) then
    edtCertificateFile.Text := Value.Value;
    
  Value := JSONObject.GetValue('certificate_subject');
  if Assigned(Value) then
    edtCertificateSubject.Text := Value.Value;
  
  // 更新控件状态
  cbbEncryptionTypeChange(nil);
  chkUseIVClick(nil);
  rbUseKeyFileClick(nil);
  rbUsePasswordClick(nil);
  
  // 仅当控件已经创建才调用事件处理程序
  if Assigned(rbUseCertFile) then
    rbUseCertFileClick(nil);
  if Assigned(rbSelectFromStore) then
    rbSelectFromStoreClick(nil);
end;

procedure TFrameEncryptEditor.SaveToJSON;
begin
  if not Assigned(JSONObject) then Exit;
  
  // 保存基本信息
  JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);
  
  JSONObject.RemovePair('description');
  JSONObject.AddPair('description', memDescription.Text);
  
  // 保存算法设置
  JSONObject.RemovePair('encryption_type');
  JSONObject.AddPair('encryption_type', cbbEncryptionType.Text);
  
  JSONObject.RemovePair('algorithm');
  JSONObject.AddPair('algorithm', cbbAlgorithm.Text);
  
  JSONObject.RemovePair('key_size');
  JSONObject.AddPair('key_size', cbbKeySize.Text);
  
  JSONObject.RemovePair('mode');
  JSONObject.AddPair('mode', cbbMode.Text);
  
  JSONObject.RemovePair('padding');
  JSONObject.AddPair('padding', cbbPadding.Text);
  
  JSONObject.RemovePair('use_iv');
  JSONObject.AddPair('use_iv', TJSONBool.Create(chkUseIV.Checked));
  
  JSONObject.RemovePair('default_iv');
  JSONObject.AddPair('default_iv', TJSONBool.Create(chkDefaultIV.Checked));
  
  JSONObject.RemovePair('iv');
  JSONObject.AddPair('iv', edtIV.Text);
  
  // 保存密钥设置
  JSONObject.RemovePair('key_format');
  JSONObject.AddPair('key_format', cbbKeyFormat.Text);
  
  JSONObject.RemovePair('use_key_file');
  JSONObject.AddPair('use_key_file', TJSONBool.Create(rbUseKeyFile.Checked));
  
  JSONObject.RemovePair('private_key_file');
  JSONObject.AddPair('private_key_file', edtPrivateKeyFile.Text);
  
  JSONObject.RemovePair('public_key_file');
  JSONObject.AddPair('public_key_file', edtPublicKeyFile.Text);
  
  JSONObject.RemovePair('generate_key_pair');
  JSONObject.AddPair('generate_key_pair', TJSONBool.Create(chkGenerateKeyPair.Checked));
  
  JSONObject.RemovePair('password');
  JSONObject.AddPair('password', edtPassword.Text);
  
  JSONObject.RemovePair('salt');
  JSONObject.AddPair('salt', edtSalt.Text);
  
  JSONObject.RemovePair('key_derivation');
  JSONObject.AddPair('key_derivation', cbbKeyDerivation.Text);
  
  JSONObject.RemovePair('iterations');
  JSONObject.AddPair('iterations', edtIterations.Text);
  
  // 保存证书设置
  JSONObject.RemovePair('use_cert_file');
  JSONObject.AddPair('use_cert_file', TJSONBool.Create(rbUseCertFile.Checked));
  
  JSONObject.RemovePair('certificate_authority');
  JSONObject.AddPair('certificate_authority', cbbCertificateAuth.Text);
  
  JSONObject.RemovePair('certificate_store');
  JSONObject.AddPair('certificate_store', cbbCertificateStore.Text);
  
  JSONObject.RemovePair('certificate_file');
  JSONObject.AddPair('certificate_file', edtCertificateFile.Text);
  
  JSONObject.RemovePair('certificate_subject');
  JSONObject.AddPair('certificate_subject', edtCertificateSubject.Text);
  
  // 设置修改标志为false
  Modified := False;
end;

procedure TFrameEncryptEditor.UpdateAlgorithmControls;
begin
  // 根据加密类型更新算法选项
  case cbbEncryptionType.ItemIndex of
    0: begin // 对称加密
      cbbAlgorithm.Items.Clear;
      cbbAlgorithm.Items.Add('AES');
      cbbAlgorithm.Items.Add('DES');
      cbbAlgorithm.Items.Add('3DES');
      cbbAlgorithm.Items.Add('RC4');
      cbbAlgorithm.Items.Add('Blowfish');
      cbbAlgorithm.ItemIndex := 0;
      
      // 启用模式和填充选项
      cbbMode.Enabled := True;
      cbbPadding.Enabled := True;
      chkUseIV.Enabled := True;
    end;
    1: begin // 非对称加密
      cbbAlgorithm.Items.Clear;
      cbbAlgorithm.Items.Add('RSA');
      cbbAlgorithm.Items.Add('ECC');
      cbbAlgorithm.Items.Add('DSA');
      cbbAlgorithm.Items.Add('ElGamal');
      cbbAlgorithm.ItemIndex := 0;
      
      // 禁用模式和填充选项
      cbbMode.Enabled := False;
      cbbPadding.Enabled := True;
      chkUseIV.Enabled := False;
    end;
    2: begin // 哈希算法
      cbbAlgorithm.Items.Clear;
      cbbAlgorithm.Items.Add('MD5');
      cbbAlgorithm.Items.Add('SHA-1');
      cbbAlgorithm.Items.Add('SHA-256');
      cbbAlgorithm.Items.Add('SHA-512');
      cbbAlgorithm.Items.Add('Blake2');
      cbbAlgorithm.ItemIndex := 2;
      
      // 禁用模式和填充选项
      cbbMode.Enabled := False;
      cbbPadding.Enabled := False;
      chkUseIV.Enabled := False;
    end;
    3: begin // HMAC
      cbbAlgorithm.Items.Clear;
      cbbAlgorithm.Items.Add('HMAC-MD5');
      cbbAlgorithm.Items.Add('HMAC-SHA1');
      cbbAlgorithm.Items.Add('HMAC-SHA256');
      cbbAlgorithm.Items.Add('HMAC-SHA512');
      cbbAlgorithm.ItemIndex := 2;
      
      // 禁用模式和填充选项
      cbbMode.Enabled := False;
      cbbPadding.Enabled := False;
      chkUseIV.Enabled := False;
    end;
  end;
  
  // 更新密钥大小选项
  UpdateKeyControls;
end;

procedure TFrameEncryptEditor.UpdateKeyControls;
begin
  // 根据选择的算法更新密钥大小选项
  if cbbEncryptionType.ItemIndex = 0 then // 对称加密
  begin
    case cbbAlgorithm.ItemIndex of
      0: begin // AES
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('128 位');
        cbbKeySize.Items.Add('192 位');
        cbbKeySize.Items.Add('256 位');
        cbbKeySize.ItemIndex := 2;
      end;
      1: begin // DES
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('56 位');
        cbbKeySize.ItemIndex := 0;
      end;
      2: begin // 3DES
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('112 位');
        cbbKeySize.Items.Add('168 位');
        cbbKeySize.ItemIndex := 1;
      end;
      3: begin // RC4
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('40 位');
        cbbKeySize.Items.Add('128 位');
        cbbKeySize.Items.Add('256 位');
        cbbKeySize.ItemIndex := 1;
      end;
      4: begin // Blowfish
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('128 位');
        cbbKeySize.Items.Add('256 位');
        cbbKeySize.Items.Add('448 位');
        cbbKeySize.ItemIndex := 1;
      end;
    end;
  end
  else if cbbEncryptionType.ItemIndex = 1 then // 非对称加密
  begin
    case cbbAlgorithm.ItemIndex of
      0: begin // RSA
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('1024 位');
        cbbKeySize.Items.Add('2048 位');
        cbbKeySize.Items.Add('4096 位');
        cbbKeySize.ItemIndex := 1;
      end;
      1: begin // ECC
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('256 位');
        cbbKeySize.Items.Add('384 位');
        cbbKeySize.Items.Add('521 位');
        cbbKeySize.ItemIndex := 0;
      end;
      2: begin // DSA
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('1024 位');
        cbbKeySize.Items.Add('2048 位');
        cbbKeySize.Items.Add('3072 位');
        cbbKeySize.ItemIndex := 1;
      end;
      3: begin // ElGamal
        cbbKeySize.Items.Clear;
        cbbKeySize.Items.Add('1024 位');
        cbbKeySize.Items.Add('2048 位');
        cbbKeySize.Items.Add('3072 位');
        cbbKeySize.ItemIndex := 1;
      end;
    end;
  end;
  
  // 更新密钥文件选项的可见性
  if Assigned(rbUseKeyFile) then
  begin
    lblPrivateKey.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    edtPrivateKeyFile.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    btnBrowsePrivateKey.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    
    lblPublicKey.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    edtPublicKeyFile.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    btnBrowsePublicKey.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
    
    chkGenerateKeyPair.Visible := (cbbEncryptionType.ItemIndex = 1) and rbUseKeyFile.Checked;
  end;
  
  // 更新密码选项的可见性
  if Assigned(rbUsePassword) then
  begin
    lblPassword.Visible := rbUsePassword.Checked;
    edtPassword.Visible := rbUsePassword.Checked;
    
    lblSalt.Visible := rbUsePassword.Checked;
    edtSalt.Visible := rbUsePassword.Checked;
    btnGenerateSalt.Visible := rbUsePassword.Checked;
    
    lblKeyDerivation.Visible := rbUsePassword.Checked;
    cbbKeyDerivation.Visible := rbUsePassword.Checked;
    
    lblIterations.Visible := rbUsePassword.Checked;
    edtIterations.Visible := rbUsePassword.Checked;
  end;
end;

procedure TFrameEncryptEditor.UpdateCertificateControls;
begin
  // 更新证书控件的可见性
  if Assigned(rbUseCertFile) and Assigned(rbSelectFromStore) then
  begin
    lblCertificateFile.Visible := rbUseCertFile.Checked;
    edtCertificateFile.Visible := rbUseCertFile.Checked;
    btnBrowseCertificate.Visible := rbUseCertFile.Checked;
    
    lblCertificateSubject.Visible := rbSelectFromStore.Checked;
    edtCertificateSubject.Visible := rbSelectFromStore.Checked;
    
    cbbCertificateStore.Enabled := rbSelectFromStore.Checked;
  end;
end;

function TFrameEncryptEditor.GenerateRandomSalt(Size: Integer): string;
var
  I: Integer;
  SaltBytes: TBytes;
begin
  SetLength(SaltBytes, Size);
  for I := 0 to Size - 1 do
    SaltBytes[I] := Random(256);
    
  Result := TEncoding.UTF8.GetString(TNetEncoding.Base64.Encode(SaltBytes));
end;

function TFrameEncryptEditor.GenerateRandomString(Length: Integer): string;
const
  Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length do
    Result := Result + Chars[Random(System.Length(Chars)) + 1];
end;

function TFrameEncryptEditor.GenerateRandomHex(Length: Integer): string;
const
  HexChars = '0123456789ABCDEF';
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length do
    Result := Result + HexChars[Random(16) + 1];
end;

procedure TFrameEncryptEditor.btnGenerateIVClick(Sender: TObject);
begin
  // 生成随机IV值，通常是16字节（32个十六进制字符）
  edtIV.Text := GenerateRandomHex(32);
  Modified := True;
end;

procedure TFrameEncryptEditor.btnBrowseCertificateClick(Sender: TObject);
begin
  if dlgOpenCert.Execute then
    edtCertificateFile.Text := dlgOpenCert.FileName;
end;

procedure TFrameEncryptEditor.btnBrowsePrivateKeyClick(Sender: TObject);
begin
  if dlgOpenKey.Execute then
    edtPrivateKeyFile.Text := dlgOpenKey.FileName;
end;

procedure TFrameEncryptEditor.btnBrowsePublicKeyClick(Sender: TObject);
begin
  if dlgOpenKey.Execute then
    edtPublicKeyFile.Text := dlgOpenKey.FileName;
end;

procedure TFrameEncryptEditor.btnGenerateSaltClick(Sender: TObject);
begin
  // 生成一个16字节（32个十六进制字符）的随机盐值
  edtSalt.Text := GenerateRandomHex(16);
  Modified := True;
end;

procedure TFrameEncryptEditor.btnUpdateClick(Sender: TObject);
begin
  SaveToJSON;
  Modified := True;
  if Assigned(OnModified) then
    OnModified(Self);
end;

procedure TFrameEncryptEditor.btnCancelClick(Sender: TObject);
begin
  if Assigned(Parent) and (Parent is TPanel) then
    TPanel(Parent).Visible := False;
end;

procedure TFrameEncryptEditor.cbbAlgorithmChange(Sender: TObject);
begin
  UpdateKeyControls;
  Modified := True;
end;

procedure TFrameEncryptEditor.cbbEncryptionTypeChange(Sender: TObject);
begin
  UpdateAlgorithmControls;
  Modified := True;
end;

procedure TFrameEncryptEditor.chkDefaultIVClick(Sender: TObject);
begin
  // 根据是否使用默认IV更新控件状态
  edtIV.Enabled := chkUseIV.Checked and not chkDefaultIV.Checked;
  Modified := True;
end;

procedure TFrameEncryptEditor.chkGenerateKeyPairClick(Sender: TObject);
begin
  Modified := True;
end;

procedure TFrameEncryptEditor.chkUseIVClick(Sender: TObject);
begin
  // 根据是否使用IV更新控件状态
  chkDefaultIV.Enabled := chkUseIV.Checked;
  lblIV.Enabled := chkUseIV.Checked and not chkDefaultIV.Checked;
  edtIV.Enabled := chkUseIV.Checked and not chkDefaultIV.Checked;
  Modified := True;
end;

procedure TFrameEncryptEditor.rbUseKeyFileClick(Sender: TObject);
begin
  UpdateKeyControls;
  Modified := True;
end;

procedure TFrameEncryptEditor.rbUsePasswordClick(Sender: TObject);
begin
  UpdateKeyControls;
  Modified := True;
end;

// 添加类的方法而不是独立过程
procedure TFrameEncryptEditor.rbSelectFromStoreClick(Sender: TObject);
begin
  UpdateCertificateControls;
  Modified := True;
end;

procedure TFrameEncryptEditor.rbUseCertFileClick(Sender: TObject);
begin
  UpdateCertificateControls;
  Modified := True;
end;

end. 