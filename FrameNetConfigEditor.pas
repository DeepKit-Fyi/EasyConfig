unit FrameNetConfigEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.JSON.Types, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigFrameBase, UtilsTypes, JSONHelpers;

type
  // 缃戠粶閰嶇疆编栬緫器‵rame
  TFrameNetConfigEditor = class(TBaseConfigFrame)
    pnlMain: TPanel;
    grpNetConfig: TGroupBox;
    lblName: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    memDescription: TMemo;
    pcNetConfig: TPageControl;
    tsBasic: TTabSheet;
    tsAdvanced: TTabSheet;
    tsProxy: TTabSheet;
    tsDNS: TTabSheet;
    pnlBasic: TPanel;
    pnlAdvanced: TPanel;
    pnlProxy: TPanel;
    pnlDNS: TPanel;
    chkDHCP: TCheckBox;
    lblIPAddress: TLabel;
    edtIPAddress: TEdit;
    lblSubnetMask: TLabel;
    edtSubnetMask: TEdit;
    lblGateway: TLabel;
    edtGateway: TEdit;
    lblMacAddress: TLabel;
    edtMacAddress: TEdit;
    chkIPv6: TCheckBox;
    edtIPv6Address: TEdit;
    lblIPv6Prefix: TLabel;
    edtIPv6Prefix: TEdit;
    lblIPv6Gateway: TLabel;
    edtIPv6Gateway: TEdit;
    lblNetworkName: TLabel;
    edtNetworkName: TEdit;
    lblNetworkType: TLabel;
    cbbNetworkType: TComboBox;
    lblMTU: TLabel;
    edtMTU: TEdit;
    chkAutoConnect: TCheckBox;
    chkEnableProxy: TCheckBox;
    lblProxyServer: TLabel;
    edtProxyServer: TEdit;
    lblProxyPort: TLabel;
    edtProxyPort: TEdit;
    lblProxyUsername: TLabel;
    edtProxyUsername: TEdit;
    lblProxyPassword: TLabel;
    edtProxyPassword: TEdit;
    chkProxyHTTP: TCheckBox;
    chkProxyHTTPS: TCheckBox;
    chkProxyFTP: TCheckBox;
    chkProxySOCKS: TCheckBox;
    chkBypassLocal: TCheckBox;
    lblBypassAddresses: TLabel;
    memBypassAddresses: TMemo;
    chkCustomDNS: TCheckBox;
    lblPrimaryDNS: TLabel;
    edtPrimaryDNS: TEdit;
    lblSecondaryDNS: TLabel;
    edtSecondaryDNS: TEdit;
    chkDNSv6: TCheckBox;
    lblPrimaryDNSv6: TLabel;
    edtPrimaryDNSv6: TEdit;
    lblSecondaryDNSv6: TLabel;
    edtSecondaryDNSv6: TEdit;
    lblSearchDomains: TLabel;
    memSearchDomains: TMemo;
    pnlButtons: TPanel;
    btnUpdate: TButton;
    btnCancel: TButton;
    lblIPv6Address: TLabel;
    btnTestConnection: TButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkDHCPClick(Sender: TObject);
    procedure chkIPv6Click(Sender: TObject);
    procedure chkEnableProxyClick(Sender: TObject);
    procedure chkCustomDNSClick(Sender: TObject);
    procedure chkDNSv6Click(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
  private
    procedure InitControls;
    procedure UpdateIPControls;
    procedure UpdateProxyControls;
    procedure UpdateDNSControls;
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

constructor TFrameNetConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitControls;
end;

destructor TFrameNetConfigEditor.Destroy;
begin
  inherited;
end;

procedure TFrameNetConfigEditor.CreateControls;
begin
  inherited;
  
  // 杩欎釜鏂规硶优氬湪鏋勯€犲嚱鏁颁腑调冪敤锛屽鏋滄帶浠跺凡鍦―FM鏂囦欢中璁″ソ锛屽垯中嶉渶要侀大栧垱寤?
  // 如傛灉需€要佸姩鎬佸垱寤烘帶浠讹紝可互鍦ㄨ繖閲屾坊加犱唬鐮?
end;

procedure TFrameNetConfigEditor.InitControls;
begin
  // 创濆化栫綉缁滅被鍨嬩笅鎷夊垪琛?
  cbbNetworkType.Items.Clear;
  cbbNetworkType.Items.Add('未夌嚎缃戠粶');
  cbbNetworkType.Items.Add('时犵嚎缃戠粶');
  cbbNetworkType.Items.Add('VPN');
  cbbNetworkType.Items.Add('钃濈墮');
  cbbNetworkType.Items.Add('称诲姩缃戠粶');
  cbbNetworkType.ItemIndex := 0;
  
  // 璁剧疆榛樿MTU鍊?
  edtMTU.Text := '1500';
  
  // 鏇存柊鎺т欢鐘舵€?
  chkDHCPClick(nil);
  chkIPv6Click(nil);
  chkEnableProxyClick(nil);
  chkCustomDNSClick(nil);
  chkDNSv6Click(nil);
end;

procedure TFrameNetConfigEditor.LoadFromJSON;
begin
  if not Assigned(JSONObject) then
    Exit;
  
  // 加犺浇鍩烘湰灞炴€?
  var Value: TJSONValue;
  
  Value := JSONObject.GetValue('name');
  if Assigned(Value) then
    edtName.Text := Value.Value;
    
  Value := JSONObject.GetValue('description');
  if Assigned(Value) then
    memDescription.Text := Value.Value;
  
  // 加犺浇缃戠粶鍩烘湰璁剧疆
  Value := JSONObject.GetValue('dhcp');
  if Assigned(Value) and (Value is TJSONBool) then
    chkDHCP.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('ip_address');
  if Assigned(Value) then
    edtIPAddress.Text := Value.Value;
    
  Value := JSONObject.GetValue('subnet_mask');
  if Assigned(Value) then
    edtSubnetMask.Text := Value.Value;
    
  Value := JSONObject.GetValue('gateway');
  if Assigned(Value) then
    edtGateway.Text := Value.Value;
    
  Value := JSONObject.GetValue('mac_address');
  if Assigned(Value) then
    edtMacAddress.Text := Value.Value;
    
  Value := JSONObject.GetValue('ipv6');
  if Assigned(Value) and (Value is TJSONBool) then
    chkIPv6.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('ipv6_address');
  if Assigned(Value) then
    edtIPv6Address.Text := Value.Value;
    
  Value := JSONObject.GetValue('ipv6_prefix');
  if Assigned(Value) then
    edtIPv6Prefix.Text := Value.Value;
    
  Value := JSONObject.GetValue('ipv6_gateway');
  if Assigned(Value) then
    edtIPv6Gateway.Text := Value.Value;
    
  Value := JSONObject.GetValue('network_name');
  if Assigned(Value) then
    edtNetworkName.Text := Value.Value;
    
  Value := JSONObject.GetValue('network_type');
  if Assigned(Value) and (Value is TJSONNumber) then
    cbbNetworkType.ItemIndex := (Value as TJSONNumber).AsInt;
    
  Value := JSONObject.GetValue('mtu');
  if Assigned(Value) then
    edtMTU.Text := Value.Value;
    
  Value := JSONObject.GetValue('auto_connect');
  if Assigned(Value) and (Value is TJSONBool) then
    chkAutoConnect.Checked := (Value as TJSONBool).AsBoolean;
  
  // 加犺浇浠ｇ悊璁剧疆
  Value := JSONObject.GetValue('enable_proxy');
  if Assigned(Value) and (Value is TJSONBool) then
    chkEnableProxy.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('proxy_server');
  if Assigned(Value) then
    edtProxyServer.Text := Value.Value;
    
  Value := JSONObject.GetValue('proxy_port');
  if Assigned(Value) then
    edtProxyPort.Text := Value.Value;
    
  Value := JSONObject.GetValue('proxy_username');
  if Assigned(Value) then
    edtProxyUsername.Text := Value.Value;
    
  Value := JSONObject.GetValue('proxy_password');
  if Assigned(Value) then
    edtProxyPassword.Text := Value.Value;
    
  Value := JSONObject.GetValue('proxy_http');
  if Assigned(Value) and (Value is TJSONBool) then
    chkProxyHTTP.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('proxy_https');
  if Assigned(Value) and (Value is TJSONBool) then
    chkProxyHTTPS.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('proxy_ftp');
  if Assigned(Value) and (Value is TJSONBool) then
    chkProxyFTP.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('proxy_socks');
  if Assigned(Value) and (Value is TJSONBool) then
    chkProxySOCKS.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('bypass_local');
  if Assigned(Value) and (Value is TJSONBool) then
    chkBypassLocal.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('bypass_addresses');
  if Assigned(Value) then
    memBypassAddresses.Text := Value.Value;
  
  // 加犺浇DNS璁剧疆
  Value := JSONObject.GetValue('custom_dns');
  if Assigned(Value) and (Value is TJSONBool) then
    chkCustomDNS.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('primary_dns');
  if Assigned(Value) then
    edtPrimaryDNS.Text := Value.Value;
    
  Value := JSONObject.GetValue('secondary_dns');
  if Assigned(Value) then
    edtSecondaryDNS.Text := Value.Value;
    
  Value := JSONObject.GetValue('dnsv6');
  if Assigned(Value) and (Value is TJSONBool) then
    chkDNSv6.Checked := (Value as TJSONBool).AsBoolean;
    
  Value := JSONObject.GetValue('primary_dnsv6');
  if Assigned(Value) then
    edtPrimaryDNSv6.Text := Value.Value;
    
  Value := JSONObject.GetValue('secondary_dnsv6');
  if Assigned(Value) then
    edtSecondaryDNSv6.Text := Value.Value;
    
  Value := JSONObject.GetValue('search_domains');
  if Assigned(Value) then
    memSearchDomains.Text := Value.Value;
  
  // 鏇存柊鎺т欢鐘舵€?
  UpdateIPControls;
  UpdateProxyControls;
  UpdateDNSControls;
end;

procedure TFrameNetConfigEditor.SaveToJSON;
begin
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;
  
  // 修濆瓨鍩烘湰灞炴€?
  JSONObject.RemovePair('_type');
  JSONObject.AddPair('_type', 'etNetConfig');
  JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);
  JSONObject.RemovePair('description');
  JSONObject.AddPair('description', memDescription.Text);
  
  // 修濆瓨缃戠粶鍩烘湰璁剧疆
  JSONObject.RemovePair('dhcp');
  JSONObject.AddPair('dhcp', TJSONBool.Create(chkDHCP.Checked));
  JSONObject.RemovePair('ip_address');
  JSONObject.AddPair('ip_address', edtIPAddress.Text);
  JSONObject.RemovePair('subnet_mask');
  JSONObject.AddPair('subnet_mask', edtSubnetMask.Text);
  JSONObject.RemovePair('gateway');
  JSONObject.AddPair('gateway', edtGateway.Text);
  JSONObject.RemovePair('mac_address');
  JSONObject.AddPair('mac_address', edtMacAddress.Text);
  
  JSONObject.RemovePair('ipv6');
  JSONObject.AddPair('ipv6', TJSONBool.Create(chkIPv6.Checked));
  JSONObject.RemovePair('ipv6_address');
  JSONObject.AddPair('ipv6_address', edtIPv6Address.Text);
  JSONObject.RemovePair('ipv6_prefix');
  JSONObject.AddPair('ipv6_prefix', edtIPv6Prefix.Text);
  JSONObject.RemovePair('ipv6_gateway');
  JSONObject.AddPair('ipv6_gateway', edtIPv6Gateway.Text);
  
  JSONObject.RemovePair('network_name');
  JSONObject.AddPair('network_name', edtNetworkName.Text);
  JSONObject.RemovePair('network_type');
  JSONObject.AddPair('network_type', TJSONNumber.Create(cbbNetworkType.ItemIndex));
  JSONObject.RemovePair('mtu');
  JSONObject.AddPair('mtu', edtMTU.Text);
  JSONObject.RemovePair('auto_connect');
  JSONObject.AddPair('auto_connect', TJSONBool.Create(chkAutoConnect.Checked));
  
  // 修濆瓨浠ｇ悊璁剧疆
  JSONObject.RemovePair('enable_proxy');
  JSONObject.AddPair('enable_proxy', TJSONBool.Create(chkEnableProxy.Checked));
  JSONObject.RemovePair('proxy_server');
  JSONObject.AddPair('proxy_server', edtProxyServer.Text);
  JSONObject.RemovePair('proxy_port');
  JSONObject.AddPair('proxy_port', edtProxyPort.Text);
  JSONObject.RemovePair('proxy_username');
  JSONObject.AddPair('proxy_username', edtProxyUsername.Text);
  JSONObject.RemovePair('proxy_password');
  JSONObject.AddPair('proxy_password', edtProxyPassword.Text);
  
  JSONObject.RemovePair('proxy_http');
  JSONObject.AddPair('proxy_http', TJSONBool.Create(chkProxyHTTP.Checked));
  JSONObject.RemovePair('proxy_https');
  JSONObject.AddPair('proxy_https', TJSONBool.Create(chkProxyHTTPS.Checked));
  JSONObject.RemovePair('proxy_ftp');
  JSONObject.AddPair('proxy_ftp', TJSONBool.Create(chkProxyFTP.Checked));
  JSONObject.RemovePair('proxy_socks');
  JSONObject.AddPair('proxy_socks', TJSONBool.Create(chkProxySOCKS.Checked));
  
  JSONObject.RemovePair('bypass_local');
  JSONObject.AddPair('bypass_local', TJSONBool.Create(chkBypassLocal.Checked));
  JSONObject.RemovePair('bypass_addresses');
  JSONObject.AddPair('bypass_addresses', memBypassAddresses.Text);
  
  // 修濆瓨DNS璁剧疆
  JSONObject.RemovePair('custom_dns');
  JSONObject.AddPair('custom_dns', TJSONBool.Create(chkCustomDNS.Checked));
  JSONObject.RemovePair('primary_dns');
  JSONObject.AddPair('primary_dns', edtPrimaryDNS.Text);
  JSONObject.RemovePair('secondary_dns');
  JSONObject.AddPair('secondary_dns', edtSecondaryDNS.Text);
  
  JSONObject.RemovePair('dnsv6');
  JSONObject.AddPair('dnsv6', TJSONBool.Create(chkDNSv6.Checked));
  JSONObject.RemovePair('primary_dnsv6');
  JSONObject.AddPair('primary_dnsv6', edtPrimaryDNSv6.Text);
  JSONObject.RemovePair('secondary_dnsv6');
  JSONObject.AddPair('secondary_dnsv6', edtSecondaryDNSv6.Text);
  
  JSONObject.RemovePair('search_domains');
  JSONObject.AddPair('search_domains', memSearchDomains.Text);
  
  // 瑙﹀彂修敼浜嬩欢
  Modified := True;
end;

procedure TFrameNetConfigEditor.UpdateIPControls;
begin
  // 鏍规嵁DHCP鐘舵€佹洿鏂癐P鎺т欢
  edtIPAddress.Enabled := not chkDHCP.Checked;
  edtSubnetMask.Enabled := not chkDHCP.Checked;
  edtGateway.Enabled := not chkDHCP.Checked;
  
  // 鏍规嵁IPv6鐘舵€佹洿鏂癐Pv6鎺т欢
  edtIPv6Address.Enabled := chkIPv6.Checked and not chkDHCP.Checked;
  edtIPv6Prefix.Enabled := chkIPv6.Checked and not chkDHCP.Checked;
  edtIPv6Gateway.Enabled := chkIPv6.Checked and not chkDHCP.Checked;
  lblIPv6Address.Enabled := chkIPv6.Checked;
  lblIPv6Prefix.Enabled := chkIPv6.Checked;
  lblIPv6Gateway.Enabled := chkIPv6.Checked;
end;

procedure TFrameNetConfigEditor.UpdateProxyControls;
begin
  // 鏍规嵁浠ｇ悊鍚敤鐘舵€佹洿鏂颁唬鐞嗘帶浠?
  edtProxyServer.Enabled := chkEnableProxy.Checked;
  edtProxyPort.Enabled := chkEnableProxy.Checked;
  edtProxyUsername.Enabled := chkEnableProxy.Checked;
  edtProxyPassword.Enabled := chkEnableProxy.Checked;
  chkProxyHTTP.Enabled := chkEnableProxy.Checked;
  chkProxyHTTPS.Enabled := chkEnableProxy.Checked;
  chkProxyFTP.Enabled := chkEnableProxy.Checked;
  chkProxySOCKS.Enabled := chkEnableProxy.Checked;
  chkBypassLocal.Enabled := chkEnableProxy.Checked;
  memBypassAddresses.Enabled := chkEnableProxy.Checked;
  lblProxyServer.Enabled := chkEnableProxy.Checked;
  lblProxyPort.Enabled := chkEnableProxy.Checked;
  lblProxyUsername.Enabled := chkEnableProxy.Checked;
  lblProxyPassword.Enabled := chkEnableProxy.Checked;
  lblBypassAddresses.Enabled := chkEnableProxy.Checked;
end;

procedure TFrameNetConfigEditor.UpdateDNSControls;
begin
  // 鏍规嵁鑷畾涔塂NS鐘舵€佹洿鏂癉NS鎺т欢
  edtPrimaryDNS.Enabled := chkCustomDNS.Checked;
  edtSecondaryDNS.Enabled := chkCustomDNS.Checked;
  lblPrimaryDNS.Enabled := chkCustomDNS.Checked;
  lblSecondaryDNS.Enabled := chkCustomDNS.Checked;
  
  // 鏍规嵁DNSv6鐘舵€佹洿鏂癉NSv6鎺т欢
  chkDNSv6.Enabled := chkCustomDNS.Checked;
  edtPrimaryDNSv6.Enabled := chkCustomDNS.Checked and chkDNSv6.Checked;
  edtSecondaryDNSv6.Enabled := chkCustomDNS.Checked and chkDNSv6.Checked;
  lblPrimaryDNSv6.Enabled := chkCustomDNS.Checked and chkDNSv6.Checked;
  lblSecondaryDNSv6.Enabled := chkCustomDNS.Checked and chkDNSv6.Checked;
  
  memSearchDomains.Enabled := chkCustomDNS.Checked;
  lblSearchDomains.Enabled := chkCustomDNS.Checked;
end;

procedure TFrameNetConfigEditor.btnCancelClick(Sender: TObject);
begin
  // 閲嶆柊加犺浇JSON鏁版嵁锛屽彇娑堟墍未変慨改?
  LoadFromJSON;
end;

procedure TFrameNetConfigEditor.btnTestConnectionClick(Sender: TObject);
begin
  // 杩欓噷搴旇娣诲姞娴嬭瘯缃戠粶杩炴帴的勪唬鐮?
  // 绠€单曠殑瀹炵幇锛屽彧是樉绀轰竴中秷鎭?
  ShowMessage('缃戠粶杩炴帴娴嬭瘯加熻兘将氭湭瀹炵幇');
end;

procedure TFrameNetConfigEditor.btnUpdateClick(Sender: TObject);
begin
  // 修濆瓨鏁版嵁骞惰Е可戜慨改逛簨浠?
  SaveToJSON;
end;

procedure TFrameNetConfigEditor.chkCustomDNSClick(Sender: TObject);
begin
  UpdateDNSControls;
end;

procedure TFrameNetConfigEditor.chkDHCPClick(Sender: TObject);
begin
  UpdateIPControls;
end;

procedure TFrameNetConfigEditor.chkDNSv6Click(Sender: TObject);
begin
  UpdateDNSControls;
end;

procedure TFrameNetConfigEditor.chkEnableProxyClick(Sender: TObject);
begin
  UpdateProxyControls;
end;

procedure TFrameNetConfigEditor.chkIPv6Click(Sender: TObject);
begin
  UpdateIPControls;
end;

end. 