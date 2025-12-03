unit FrameAIAPIEditorFMX;
{*******************************************************************************
  AI API 配置编辑器 Frame (FMX)
  - 支持多种 AI 供应商 (OpenAI, Claude, Gemini, DeepSeek, Ollama 等)
  - API Key、模型选择、参数配置
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.EditBox,
  FMX.SpinBox, FMX.NumberBox, FMX.Memo, FMX.ScrollBox,
  ConfigFrameBaseFMX;

type
  TFrameAIAPIEditorFMX = class(TConfigFrameBaseFMX)
    layMain: TLayout;
    layProvider: TLayout;
    lblProvider: TLabel;
    cboProvider: TComboBox;
    layBaseURL: TLayout;
    lblBaseURL: TLabel;
    edtBaseURL: TEdit;
    layAPIKey: TLayout;
    lblAPIKey: TLabel;
    edtAPIKey: TEdit;
    btnShowKey: TButton;
    layModel: TLayout;
    lblModel: TLabel;
    cboModel: TComboBox;
    edtModelCustom: TEdit;
    grpParams: TGroupBox;
    layTemperature: TLayout;
    lblTemperature: TLabel;
    trkTemperature: TTrackBar;
    lblTempValue: TLabel;
    layMaxTokens: TLayout;
    lblMaxTokens: TLabel;
    spnMaxTokens: TSpinBox;
    layTopP: TLayout;
    lblTopP: TLabel;
    trkTopP: TTrackBar;
    lblTopPValue: TLabel;
    layTimeout: TLayout;
    lblTimeout: TLabel;
    spnTimeout: TSpinBox;
    grpAdvanced: TGroupBox;
    laySystemPrompt: TLayout;
    lblSystemPrompt: TLabel;
    mmoSystemPrompt: TMemo;
    chkStream: TCheckBox;
    layButtons: TLayout;
    btnTest: TButton;
    lblTestResult: TLabel;
    procedure cboProviderChange(Sender: TObject);
    procedure cboModelChange(Sender: TObject);
    procedure btnShowKeyClick(Sender: TObject);
    procedure trkTemperatureChange(Sender: TObject);
    procedure trkTopPChange(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    FKeyVisible: Boolean;
    FOriginalKey: string;
    procedure UpdateProviderUI;
    procedure UpdateModelList;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromJSON(const AJSON: TJSONObject); override;
    function SaveToJSON: TJSONObject; override;
  end;

implementation

{$R *.fmx}

const
  // 各供应商的默认 BaseURL
  PROVIDER_URLS: array[0..5] of record
    Name: string;
    URL: string;
  end = (
    (Name: 'OpenAI'; URL: 'https://api.openai.com/v1'),
    (Name: 'Claude'; URL: 'https://api.anthropic.com/v1'),
    (Name: 'Gemini'; URL: 'https://generativelanguage.googleapis.com/v1'),
    (Name: 'DeepSeek'; URL: 'https://api.deepseek.com/v1'),
    (Name: 'Ollama'; URL: 'http://localhost:11434/v1'),
    (Name: '自定义'; URL: '')
  );

  // 各供应商的模型列表
  OPENAI_MODELS: array[0..4] of string = ('gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo', 'gpt-4', 'gpt-3.5-turbo');
  CLAUDE_MODELS: array[0..3] of string = ('claude-3-5-sonnet-20241022', 'claude-3-opus-20240229', 'claude-3-sonnet-20240229', 'claude-3-haiku-20240307');
  GEMINI_MODELS: array[0..2] of string = ('gemini-1.5-pro', 'gemini-1.5-flash', 'gemini-1.0-pro');
  DEEPSEEK_MODELS: array[0..1] of string = ('deepseek-chat', 'deepseek-coder');
  OLLAMA_MODELS: array[0..3] of string = ('llama3.1', 'codellama', 'mistral', '自定义');

{ TFrameAIAPIEditorFMX }

constructor TFrameAIAPIEditorFMX.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FKeyVisible := False;
  FOriginalKey := '';

  // 初始化供应商列表
  cboProvider.Items.Clear;
  for I := Low(PROVIDER_URLS) to High(PROVIDER_URLS) do
    cboProvider.Items.Add(PROVIDER_URLS[I].Name);
  cboProvider.ItemIndex := 0;

  // 初始化模型列表
  UpdateModelList;

  // 初始化滑块
  trkTemperature.Value := 0.7;
  trkTopP.Value := 1.0;
  lblTempValue.Text := '0.70';
  lblTopPValue.Text := '1.00';

  // 初始化默认值
  spnMaxTokens.Value := 4096;
  spnTimeout.Value := 30;
  chkStream.IsChecked := True;

  // 自定义模型输入框默认隐藏
  edtModelCustom.Visible := False;
end;

procedure TFrameAIAPIEditorFMX.LoadFromJSON(const AJSON: TJSONObject);
var
  ProviderStr, ModelStr: string;
  I: Integer;
  Found: Boolean;
  AdvObj: TJSONObject;
begin
  if AJSON = nil then Exit;

  BeginUpdate;
  try
    // 读取供应商
    ProviderStr := GetJSONString(AJSON, 'Provider', 'OpenAI');
    Found := False;
    for I := 0 to cboProvider.Items.Count - 1 do
    begin
      if SameText(cboProvider.Items[I], ProviderStr) then
      begin
        cboProvider.ItemIndex := I;
        Found := True;
        Break;
      end;
    end;
    if not Found then
      cboProvider.ItemIndex := cboProvider.Items.Count - 1; // 自定义

    UpdateProviderUI;
    UpdateModelList;

    // BaseURL
    edtBaseURL.Text := GetJSONString(AJSON, 'BaseURL', '');

    // API Key
    FOriginalKey := GetJSONString(AJSON, 'APIKey', '');
    if FOriginalKey <> '' then
      edtAPIKey.Text := StringOfChar('*', 32)
    else
      edtAPIKey.Text := '';

    // 模型
    ModelStr := GetJSONString(AJSON, 'Model', '');
    Found := False;
    for I := 0 to cboModel.Items.Count - 1 do
    begin
      if SameText(cboModel.Items[I], ModelStr) then
      begin
        cboModel.ItemIndex := I;
        Found := True;
        Break;
      end;
    end;
    if not Found and (ModelStr <> '') then
    begin
      // 自定义模型
      if cboModel.Items.IndexOf('自定义') >= 0 then
        cboModel.ItemIndex := cboModel.Items.IndexOf('自定义')
      else
        cboModel.ItemIndex := cboModel.Items.Count - 1;
      edtModelCustom.Visible := True;
      edtModelCustom.Text := ModelStr;
    end;

    // 参数
    trkTemperature.Value := GetJSONFloat(AJSON, 'Temperature', 0.7);
    lblTempValue.Text := FormatFloat('0.00', trkTemperature.Value);
    spnMaxTokens.Value := GetJSONInt(AJSON, 'MaxTokens', 4096);
    trkTopP.Value := GetJSONFloat(AJSON, 'TopP', 1.0);
    lblTopPValue.Text := FormatFloat('0.00', trkTopP.Value);
    spnTimeout.Value := GetJSONInt(AJSON, 'Timeout', 30);

    // 高级选项
    if AJSON.TryGetValue<TJSONObject>('Advanced', AdvObj) then
    begin
      mmoSystemPrompt.Lines.Text := GetJSONString(AdvObj, 'SystemPrompt', '');
      chkStream.IsChecked := GetJSONBool(AdvObj, 'Stream', True);
    end
    else
    begin
      mmoSystemPrompt.Lines.Clear;
      chkStream.IsChecked := True;
    end;

  finally
    EndUpdate;
  end;
end;

function TFrameAIAPIEditorFMX.SaveToJSON: TJSONObject;
var
  AdvObj: TJSONObject;
  ModelStr: string;
begin
  Result := TJSONObject.Create;

  // 供应商
  if cboProvider.ItemIndex >= 0 then
    Result.AddPair('Provider', cboProvider.Items[cboProvider.ItemIndex]);

  // BaseURL
  Result.AddPair('BaseURL', edtBaseURL.Text);

  // API Key - 如果用户修改了才保存新值
  if (edtAPIKey.Text <> '') and (Pos('*', edtAPIKey.Text) = 0) then
    Result.AddPair('APIKey', edtAPIKey.Text)
  else if FOriginalKey <> '' then
    Result.AddPair('APIKey', FOriginalKey);

  // 模型
  if edtModelCustom.Visible and (edtModelCustom.Text <> '') then
    ModelStr := edtModelCustom.Text
  else if (cboModel.ItemIndex >= 0) and (cboModel.Items[cboModel.ItemIndex] <> '自定义') then
    ModelStr := cboModel.Items[cboModel.ItemIndex]
  else
    ModelStr := '';
  Result.AddPair('Model', ModelStr);

  // 参数
  Result.AddPair('Temperature', TJSONNumber.Create(trkTemperature.Value));
  Result.AddPair('MaxTokens', TJSONNumber.Create(Round(spnMaxTokens.Value)));
  Result.AddPair('TopP', TJSONNumber.Create(trkTopP.Value));
  Result.AddPair('Timeout', TJSONNumber.Create(Round(spnTimeout.Value)));

  // 高级选项
  AdvObj := TJSONObject.Create;
  AdvObj.AddPair('SystemPrompt', mmoSystemPrompt.Lines.Text);
  AdvObj.AddPair('Stream', TJSONBool.Create(chkStream.IsChecked));
  Result.AddPair('Advanced', AdvObj);
end;

procedure TFrameAIAPIEditorFMX.UpdateProviderUI;
var
  Idx: Integer;
  IsCustom: Boolean;
begin
  Idx := cboProvider.ItemIndex;
  if Idx < 0 then Exit;

  IsCustom := (Idx = cboProvider.Items.Count - 1);

  // 自定义时可编辑 BaseURL
  edtBaseURL.ReadOnly := not IsCustom;
  if not IsCustom then
    edtBaseURL.Text := PROVIDER_URLS[Idx].URL;
end;

procedure TFrameAIAPIEditorFMX.UpdateModelList;
var
  Idx, I: Integer;
begin
  Idx := cboProvider.ItemIndex;
  if Idx < 0 then Exit;

  cboModel.Items.Clear;

  case Idx of
    0: // OpenAI
      for I := Low(OPENAI_MODELS) to High(OPENAI_MODELS) do
        cboModel.Items.Add(OPENAI_MODELS[I]);
    1: // Claude
      for I := Low(CLAUDE_MODELS) to High(CLAUDE_MODELS) do
        cboModel.Items.Add(CLAUDE_MODELS[I]);
    2: // Gemini
      for I := Low(GEMINI_MODELS) to High(GEMINI_MODELS) do
        cboModel.Items.Add(GEMINI_MODELS[I]);
    3: // DeepSeek
      for I := Low(DEEPSEEK_MODELS) to High(DEEPSEEK_MODELS) do
        cboModel.Items.Add(DEEPSEEK_MODELS[I]);
    4: // Ollama
      for I := Low(OLLAMA_MODELS) to High(OLLAMA_MODELS) do
        cboModel.Items.Add(OLLAMA_MODELS[I]);
  else // 自定义
    cboModel.Items.Add('自定义');
    edtModelCustom.Visible := True;
  end;

  cboModel.Items.Add('自定义');
  if cboModel.Items.Count > 0 then
    cboModel.ItemIndex := 0;
end;

procedure TFrameAIAPIEditorFMX.cboProviderChange(Sender: TObject);
begin
  UpdateProviderUI;
  UpdateModelList;
  DoModified;
end;

procedure TFrameAIAPIEditorFMX.cboModelChange(Sender: TObject);
begin
  // 选择自定义时显示输入框
  edtModelCustom.Visible := (cboModel.ItemIndex >= 0) and
    (cboModel.Items[cboModel.ItemIndex] = '自定义');
  DoModified;
end;

procedure TFrameAIAPIEditorFMX.btnShowKeyClick(Sender: TObject);
begin
  FKeyVisible := not FKeyVisible;
  if FKeyVisible then
  begin
    btnShowKey.Text := '隐藏';
    if (Pos('*', edtAPIKey.Text) > 0) and (FOriginalKey <> '') then
      edtAPIKey.Text := FOriginalKey;
    edtAPIKey.Password := False;
  end
  else
  begin
    btnShowKey.Text := '显示';
    edtAPIKey.Password := True;
  end;
end;

procedure TFrameAIAPIEditorFMX.trkTemperatureChange(Sender: TObject);
begin
  lblTempValue.Text := FormatFloat('0.00', trkTemperature.Value);
  DoModified;
end;

procedure TFrameAIAPIEditorFMX.trkTopPChange(Sender: TObject);
begin
  lblTopPValue.Text := FormatFloat('0.00', trkTopP.Value);
  DoModified;
end;

procedure TFrameAIAPIEditorFMX.edtChange(Sender: TObject);
begin
  DoModified;
end;

procedure TFrameAIAPIEditorFMX.btnTestClick(Sender: TObject);
begin
  // TODO: 实现 API 连接测试
  lblTestResult.Text := '测试功能待实现...';
  lblTestResult.TextSettings.FontColor := TAlphaColorRec.Orange;
end;

end.
