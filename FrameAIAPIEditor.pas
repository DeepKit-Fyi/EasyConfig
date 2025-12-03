unit FrameAIAPIEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ConfigFrameBase, System.JSON, JSONHelpers, UtilsTypes;

type
  TAIAPIEditorFrame = class(TBaseConfigFrame)
    pnlMain: TPanel;
    lblProvider: TLabel;
    cboProvider: TComboBox;
    lblApiKey: TLabel;
    edtApiKey: TEdit;
    lblModel: TLabel;
    edtModel: TEdit;
    lblBaseURL: TLabel;
    edtBaseURL: TEdit;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    procedure cboProviderChange(Sender: TObject);
    procedure edtChange(Sender: TObject);
  private
    procedure UpdateProviderFields;
  protected
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TAIAPIEditorFrame }

constructor TAIAPIEditorFrame.Create(AOwner: TComponent);
begin
  inherited;
  CreateControls;
end;

procedure TAIAPIEditorFrame.CreateControls;
begin
  // 主面�?  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  pnlMain.Padding.SetBounds(10, 10, 10, 10);

  // API提供�?  lblProvider := TLabel.Create(Self);
  lblProvider.Parent := pnlMain;
  lblProvider.Top := 15;
  lblProvider.Left := 10;
  lblProvider.Caption := 'API提供�?';

  cboProvider := TComboBox.Create(Self);
  cboProvider.Parent := pnlMain;
  cboProvider.Top := lblProvider.Top;
  cboProvider.Left := 100;
  cboProvider.Width := 200;
  cboProvider.Style := csDropDownList;
  cboProvider.Items.Add('OpenAI');
  cboProvider.Items.Add('Azure OpenAI');
  cboProvider.Items.Add('Anthropic');
  cboProvider.Items.Add('Custom');
  cboProvider.ItemIndex := 0;
  cboProvider.OnChange := cboProviderChange;

  // API密钥
  lblApiKey := TLabel.Create(Self);
  lblApiKey.Parent := pnlMain;
  lblApiKey.Top := lblProvider.Top + 30;
  lblApiKey.Left := 10;
  lblApiKey.Caption := 'API密钥:';

  edtApiKey := TEdit.Create(Self);
  edtApiKey.Parent := pnlMain;
  edtApiKey.Top := lblApiKey.Top;
  edtApiKey.Left := 100;
  edtApiKey.Width := 300;
  edtApiKey.PasswordChar := '*';
  edtApiKey.OnChange := edtChange;

  // 模型名称
  lblModel := TLabel.Create(Self);
  lblModel.Parent := pnlMain;
  lblModel.Top := lblApiKey.Top + 30;
  lblModel.Left := 10;
  lblModel.Caption := '模型名称:';

  edtModel := TEdit.Create(Self);
  edtModel.Parent := pnlMain;
  edtModel.Top := lblModel.Top;
  edtModel.Left := 100;
  edtModel.Width := 300;
  edtModel.Text := 'gpt-4';
  edtModel.OnChange := edtChange;

  // 基础URL
  lblBaseURL := TLabel.Create(Self);
  lblBaseURL.Parent := pnlMain;
  lblBaseURL.Top := lblModel.Top + 30;
  lblBaseURL.Left := 10;
  lblBaseURL.Caption := '基础URL:';
  lblBaseURL.Visible := False;

  edtBaseURL := TEdit.Create(Self);
  edtBaseURL.Parent := pnlMain;
  edtBaseURL.Top := lblBaseURL.Top;
  edtBaseURL.Left := 100;
  edtBaseURL.Width := 300;
  edtBaseURL.Text := 'https://api.openai.com/v1';
  edtBaseURL.Visible := False;
  edtBaseURL.OnChange := edtChange;

  // 超时设置
  lblTimeout := TLabel.Create(Self);
  lblTimeout.Parent := pnlMain;
  lblTimeout.Top := lblBaseURL.Top + 30;
  lblTimeout.Left := 10;
  lblTimeout.Caption := '超时(�?:';

  edtTimeout := TEdit.Create(Self);
  edtTimeout.Parent := pnlMain;
  edtTimeout.Top := lblTimeout.Top;
  edtTimeout.Left := 100;
  edtTimeout.Width := 60;
  edtTimeout.Text := '30';
  edtTimeout.OnChange := edtChange;

  // 初始化界�?  UpdateProviderFields;
end;

procedure TAIAPIEditorFrame.LoadFromJSON;
var
  Value: TJSONValue;
  ProviderStr: string;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 加载API提供�?  Value := JSONObject.GetValue('provider');
  if Assigned(Value) and (Value is TJSONString) then
  begin
    ProviderStr := TJSONString(Value).Value;
    if ProviderStr = 'openai' then
      cboProvider.ItemIndex := 0
    else if ProviderStr = 'azure' then
      cboProvider.ItemIndex := 1
    else if ProviderStr = 'anthropic' then
      cboProvider.ItemIndex := 2
    else if ProviderStr = 'custom' then
      cboProvider.ItemIndex := 3
    else
      cboProvider.ItemIndex := 0;
  end
  else
    cboProvider.ItemIndex := 0;

  // 加载API密钥
  Value := JSONObject.GetValue('api_key');
  if Assigned(Value) and (Value is TJSONString) then
    edtApiKey.Text := TJSONString(Value).Value
  else
    edtApiKey.Text := '';

  // 加载模型名称
  Value := JSONObject.GetValue('model');
  if Assigned(Value) and (Value is TJSONString) then
    edtModel.Text := TJSONString(Value).Value
  else
    edtModel.Text := 'gpt-4';

  // 加载基础URL
  Value := JSONObject.GetValue('base_url');
  if Assigned(Value) and (Value is TJSONString) then
    edtBaseURL.Text := TJSONString(Value).Value
  else
    edtBaseURL.Text := 'https://api.openai.com/v1';

  // 加载超时设置
  Value := JSONObject.GetValue('timeout');
  if Assigned(Value) and (Value is TJSONNumber) then
    edtTimeout.Text := TJSONNumber(Value).ToString
  else
    edtTimeout.Text := '30';

  // 更新界面
  UpdateProviderFields;
end;

procedure TAIAPIEditorFrame.SaveToJSON;
var
  ProviderStr: string;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 保存API类型信息
  if JSONObject.GetValue('_type') = nil then
    JSONObject.AddPair('_type', ConfigTypeToString(ctAIAPI));

  // 确定提供商字符串
  case cboProvider.ItemIndex of
    0: ProviderStr := 'openai';
    1: ProviderStr := 'azure';
    2: ProviderStr := 'anthropic';
    3: ProviderStr := 'custom';
    else ProviderStr := 'openai';
  end;

  // 保存API提供�?  if JSONObject.GetValue('provider') <> nil then
    JSONObject.RemovePair('provider');
  JSONObject.AddPair('provider', ProviderStr);

  // 保存API密钥
  if JSONObject.GetValue('api_key') <> nil then
    JSONObject.RemovePair('api_key');
  JSONObject.AddPair('api_key', edtApiKey.Text);

  // 保存模型名称
  if JSONObject.GetValue('model') <> nil then
    JSONObject.RemovePair('model');
  JSONObject.AddPair('model', edtModel.Text);

  // 保存基础URL
  if JSONObject.GetValue('base_url') <> nil then
    JSONObject.RemovePair('base_url');
  JSONObject.AddPair('base_url', edtBaseURL.Text);

  // 保存超时设置
  if JSONObject.GetValue('timeout') <> nil then
    JSONObject.RemovePair('timeout');
  JSONObject.AddPair('timeout', TJSONNumber.Create(StrToIntDef(edtTimeout.Text, 30)));
end;

procedure TAIAPIEditorFrame.cboProviderChange(Sender: TObject);
begin
  UpdateProviderFields;
  Modified := True;
end;

procedure TAIAPIEditorFrame.edtChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TAIAPIEditorFrame.UpdateProviderFields;
begin
  // 确保界面控件已创�?  if not Assigned(cboProvider) then
    Exit;
    
  // 根据不同的API提供商显示不同的界面元素
  case cboProvider.ItemIndex of
    0: // OpenAI
    begin
      lblBaseURL.Visible := False;
      edtBaseURL.Visible := False;
      edtBaseURL.Text := 'https://api.openai.com/v1';
      lblModel.Caption := '模型名称:';
      edtModel.Text := 'gpt-4';
    end;
    1: // Azure OpenAI
    begin
      lblBaseURL.Visible := True;
      edtBaseURL.Visible := True;
      edtBaseURL.Text := 'https://your-resource-name.openai.azure.com/openai/deployments/your-deployment-name';
      lblModel.Caption := '部署名称:';
      edtModel.Text := 'your-deployment-name';
    end;
    2: // Anthropic
    begin
      lblBaseURL.Visible := False;
      edtBaseURL.Visible := False;
      edtBaseURL.Text := 'https://api.anthropic.com';
      lblModel.Caption := '模型名称:';
      edtModel.Text := 'claude-3-opus-20240229';
    end;
    3: // Custom
    begin
      lblBaseURL.Visible := True;
      edtBaseURL.Visible := True;
      edtBaseURL.Text := 'https://your-custom-api-url.com';
      lblModel.Caption := '模型名称:';
      edtModel.Text := 'custom-model';
    end;
  end;
end;

end. 
