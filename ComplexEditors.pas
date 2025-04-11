unit ComplexEditors;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, System.JSON, Vcl.Grids, Vcl.ValEdit,
  Vcl.Graphics, System.IOUtils, System.UITypes, System.TypInfo;

// 编辑器类型枚举
type
  TEditorType = (
    etPlain, etFont, etColor, etDatabase, etList, etObject, etArray,
    etBackGround, etImage, etTextOnBG, etAIAPI, etImageOnBG, etDrawerOnBG,
    etSubtitle, etPage, etVideoClip, etConnection, etCredential, etLocalization,
    etCustom
  );

// 编辑器类型辅助函数
function EditorTypeToString(EditorType: TEditorType): string;
function StringToEditorType(const TypeStr: string): TEditorType;

// 将ConfigType枚举转换为EditorType枚举
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
// 将EditorType枚举转换为ConfigType枚举
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;

type
  TfrmComplexEditor = class(TForm)
    pnlMain: TPanel;
    pnlButtons: TPanel;
    pnlContent: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblConfigType: TLabel;
    lblConfigID: TLabel;
    edtID: TEdit;
    cbbConfigType: TComboBox;
    grpProperties: TGroupBox;
    PageControl: TPageControl;
    tsBasic: TTabSheet;
    tsAdvanced: TTabSheet;
    tsPreview: TTabSheet;
    pnlBasic: TPanel;
    pnlAdvanced: TPanel;
    pnlPreview: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbConfigTypeChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FConfigType: TEditorType;
    FConfigID: string;
    FJSONObject: TJSONObject;
    FBasicEditor: TValueListEditor;
    FAdvancedEditor: TMemo;
    FPreviewPanel: TPanel;

    procedure SetConfigType(const Value: TEditorType);
    procedure SetConfigID(const Value: string);
    procedure SetJSONObject(const Value: TJSONObject);

    procedure InitializeConfigTypes;
    procedure CreateEditors;
    procedure PopulateEditors;
    procedure UpdatePreview;
    function CreatePreviewControl: TControl;

    // 特殊类型编辑器创建
    procedure CreateFontEditor;
    procedure CreateDatabaseEditor;
    procedure CreateBackgroundEditor;
    procedure CreateImageEditor;
    procedure CreateTextOnBGEditor;
    procedure CreateImageOnBGEditor;
    procedure CreateDrawerOnBGEditor;
    procedure CreateSubtitleEditor;
    procedure CreatePageEditor;
    procedure CreateVideoClipEditor;
    procedure CreateConnectionEditor;
    procedure CreateCredentialEditor;
    procedure CreateLocalizationEditor;
    procedure CreateArrayEditor;
    procedure CreateAIAPIEditor;
    procedure CreateCustomEditor;
  public
    property ConfigType: TEditorType read FConfigType write SetConfigType;
    property ConfigID: string read FConfigID write SetConfigID;
    property JSONObject: TJSONObject read FJSONObject write SetJSONObject;
  end;

var
  frmComplexEditor: TfrmComplexEditor;

implementation

procedure TfrmComplexEditor.FormCreate(Sender: TObject);
begin
  // 初始化配置类型
  InitializeConfigTypes;

  FConfigType := etFont; // 默认类型为字体
  FConfigID := '';
  FJSONObject := TJSONObject.Create;

  CreateEditors;
end;

procedure TfrmComplexEditor.FormShow(Sender: TObject);
begin
  // 更新UI
  edtID.Text := FConfigID;

  // 设置下拉框的选中项
  for var i := 0 to cbbConfigType.Items.Count - 1 do
  begin
    if SameText(cbbConfigType.Items[i], EditorTypeToString(FConfigType)) then
    begin
      cbbConfigType.ItemIndex := i;
      Break;
    end;
  end;

  // 填充编辑器
  PopulateEditors;

  // 更新预览
  UpdatePreview;
end;

procedure TfrmComplexEditor.InitializeConfigTypes;
begin
  cbbConfigType.Items.Clear;

  // 添加支持的配置类型
  cbbConfigType.Items.Add(EditorTypeToString(etFont));
  cbbConfigType.Items.Add(EditorTypeToString(etDatabase));
  cbbConfigType.Items.Add('BackGround');
  cbbConfigType.Items.Add('Image');
  cbbConfigType.Items.Add('TextOnBG');
  cbbConfigType.Items.Add('AIAPI');
  
  // 添加更多复杂配置类型
  cbbConfigType.Items.Add('ImageOnBG');
  cbbConfigType.Items.Add('DrawerOnBG');
  cbbConfigType.Items.Add('Subtitle');
  cbbConfigType.Items.Add('Page');
  cbbConfigType.Items.Add('VideoClip');
  cbbConfigType.Items.Add('Connection');
  cbbConfigType.Items.Add('Credential');
  cbbConfigType.Items.Add('Localization');
  cbbConfigType.Items.Add(EditorTypeToString(etArray));
  cbbConfigType.Items.Add('Custom');

  cbbConfigType.ItemIndex := 0; // 默认选中第一个类型
end;

procedure TfrmComplexEditor.SetConfigType(const Value: TEditorType);
begin
  if FConfigType <> Value then
  begin
    FConfigType := Value;

    // 更新下拉框的选中项
    for var i := 0 to cbbConfigType.Items.Count - 1 do
    begin
      if SameText(cbbConfigType.Items[i], EditorTypeToString(FConfigType)) then
      begin
        cbbConfigType.ItemIndex := i;
        Break;
      end;
    end;

    // 重新创建编辑器
    CreateEditors;
    PopulateEditors;
    UpdatePreview;
  end;
end;

procedure TfrmComplexEditor.SetConfigID(const Value: string);
begin
  FConfigID := Value;
  edtID.Text := Value;
end;

procedure TfrmComplexEditor.SetJSONObject(const Value: TJSONObject);
var
  TypeStr: string;
  EdType: TEditorType;
begin
  if Assigned(FJSONObject) then
    FJSONObject.Free;

  if Assigned(Value) then
    FJSONObject := Value.Clone as TJSONObject
  else
    FJSONObject := TJSONObject.Create;

  // 从JSON对象中获取类型
  var TypeValue := FJSONObject.GetValue('_type');
  if Assigned(TypeValue) and (TypeValue is TJSONString) then
  begin
    TypeStr := TJSONString(TypeValue).Value;
    // 尝试将类型字符串转换为TEditorType枚举
    try
      if TypeStr.StartsWith('et') then
        EdType := TEditorType(GetEnumValue(TypeInfo(TEditorType), TypeStr))
      else if TypeStr.StartsWith('ct') then
      begin
        // 如果是ConfigType格式，则进行映射
        if SameText(TypeStr, 'ctFont') then
          EdType := etFont
        else if SameText(TypeStr, 'ctColor') then
          EdType := etColor
        else if SameText(TypeStr, 'ctDatabase') then
          EdType := etDatabase
        else if SameText(TypeStr, 'ctList') then
          EdType := etList
        else if SameText(TypeStr, 'ctObject') then
          EdType := etObject
        else if SameText(TypeStr, 'ctArray') then
          EdType := etArray
        else
          EdType := etPlain;
      end
      else
        EdType := etPlain;
        
      FConfigType := EdType;
    except
      // 如果转换失败，使用默认类型
      FConfigType := etPlain;
    end;

    // 更新下拉框的选中项
    for var i := 0 to cbbConfigType.Items.Count - 1 do
    begin
      if SameText(cbbConfigType.Items[i], EditorTypeToString(FConfigType)) then
      begin
        cbbConfigType.ItemIndex := i;
        Break;
      end;
    end;
  end;

  // 从JSON对象中获取ID
  var IDValue := FJSONObject.GetValue('_id');
  if Assigned(IDValue) and (IDValue is TJSONString) then
    FConfigID := TJSONString(IDValue).Value;

  // 填充编辑器
  PopulateEditors;

  // 更新预览
  UpdatePreview;
end;

procedure TfrmComplexEditor.cbbConfigTypeChange(Sender: TObject);
var
  TypeStr: string;
begin
  if cbbConfigType.ItemIndex >= 0 then
  begin
    TypeStr := cbbConfigType.Items[cbbConfigType.ItemIndex];
    FConfigType := StringToEditorType(TypeStr);

    // 重新创建编辑器
    CreateEditors;
    PopulateEditors;
    UpdatePreview;
  end;
end;

procedure TfrmComplexEditor.CreateEditors;
begin
  // 清理现有编辑器
  for var i := pnlBasic.ControlCount - 1 downto 0 do
    pnlBasic.Controls[i].Free;
  
  for var i := pnlAdvanced.ControlCount - 1 downto 0 do
    pnlAdvanced.Controls[i].Free;
    
  for var i := pnlPreview.ControlCount - 1 downto 0 do
    pnlPreview.Controls[i].Free;
  
  // 创建基本编辑器（属性编辑器）
  FBasicEditor := TValueListEditor.Create(tsBasic);
  FBasicEditor.Parent := tsBasic;
  FBasicEditor.Align := alClient;
  FBasicEditor.Options := FBasicEditor.Options + [goEditing, goAlwaysShowEditor];
  FBasicEditor.TitleCaptions.Add('键');
  FBasicEditor.TitleCaptions.Add('值');

  // 创建高级编辑器（JSON文本编辑器）
  FAdvancedEditor := TMemo.Create(tsAdvanced);
  FAdvancedEditor.Parent := tsAdvanced;
  FAdvancedEditor.Align := alClient;
  FAdvancedEditor.ScrollBars := ssBoth;
  FAdvancedEditor.WordWrap := False;

  // 创建预览面板
  FPreviewPanel := TPanel.Create(tsPreview);
  FPreviewPanel.Parent := tsPreview;
  FPreviewPanel.Align := alClient;

  // 根据配置类型创建特殊编辑器
  case FConfigType of
    etFont: CreateFontEditor;
    etDatabase: CreateDatabaseEditor;
    etBackGround: CreateBackgroundEditor;
    etImage: CreateImageEditor;
    etTextOnBG: CreateTextOnBGEditor;
    etImageOnBG: CreateImageOnBGEditor;
    etDrawerOnBG: CreateDrawerOnBGEditor;
    etSubtitle: CreateSubtitleEditor;
    etPage: CreatePageEditor;
    etVideoClip: CreateVideoClipEditor;
    etConnection: CreateConnectionEditor;
    etCredential: CreateCredentialEditor;
    etLocalization: CreateLocalizationEditor;
    etArray: CreateArrayEditor;
    etAIAPI: CreateAIAPIEditor;
    etCustom: CreateCustomEditor;
  else
    // 默认处理
    FBasicEditor.Strings.Add('_type=' + EditorTypeToString(FConfigType));
    FBasicEditor.Strings.Add('_id=');
    FBasicEditor.Strings.Add('_description=基本配置');
  end;
end;

procedure TfrmComplexEditor.CreateFontEditor;
begin
  // 添加字体相关配置
  FBasicEditor.Strings.Add('name=默认字体');
  FBasicEditor.Strings.Add('size=12');
  FBasicEditor.Strings.Add('color=#000000');
  FBasicEditor.Strings.Add('bold=false');
  FBasicEditor.Strings.Add('italic=false');
  FBasicEditor.Strings.Add('underline=false');
  FBasicEditor.Strings.Add('strike_out=false');
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etFont));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=字体配置');
end;

procedure TfrmComplexEditor.CreateDatabaseEditor;
begin
  // 添加数据库相关配置
  FBasicEditor.Strings.Add('db_type=sqlite');
  FBasicEditor.Strings.Add('server=');
  FBasicEditor.Strings.Add('port=0');
  FBasicEditor.Strings.Add('database=');
  FBasicEditor.Strings.Add('username=');
  FBasicEditor.Strings.Add('password=');
  FBasicEditor.Strings.Add('connection_string=');
  FBasicEditor.Strings.Add('timeout=30');
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etDatabase));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=数据库连接配置');
end;

procedure TfrmComplexEditor.CreateBackgroundEditor;
begin
  // 添加背景相关配置
  FBasicEditor.Strings.Add('color=#FFFFFF');
  FBasicEditor.Strings.Add('gradient=false');
  FBasicEditor.Strings.Add('gradient_color=#000000');
  FBasicEditor.Strings.Add('gradient_direction=horizontal');
  FBasicEditor.Strings.Add('image_path=');
  FBasicEditor.Strings.Add('image_mode=center'); // center, stretch, tile
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etBackGround));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=背景配置');
end;

procedure TfrmComplexEditor.CreateImageEditor;
begin
  // 添加图像相关配置
  FBasicEditor.Strings.Add('path=');
  FBasicEditor.Strings.Add('width=0');
  FBasicEditor.Strings.Add('height=0');
  FBasicEditor.Strings.Add('transparent=false');
  FBasicEditor.Strings.Add('transparent_color=#FFFFFF');
  FBasicEditor.Strings.Add('format=png'); // png, jpg, bmp, gif
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etImage));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=图像配置');
end;

procedure TfrmComplexEditor.CreateTextOnBGEditor;
begin
  // 添加背景上的文字编辑器
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etTextOnBG));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('text=背景上的文字');
  FBasicEditor.Strings.Add('font._ref=' + EditorTypeToString(etFont) + '.main_font');
  FBasicEditor.Strings.Add('position.x=0');
  FBasicEditor.Strings.Add('position.y=0');
  FBasicEditor.Strings.Add('position.isXcenter=true');
  FBasicEditor.Strings.Add('position.isYcenter=true');
  FBasicEditor.Strings.Add('position.scale=1.0');
  FBasicEditor.Strings.Add('position.z_index=1');
  FBasicEditor.Strings.Add('background._ref=' + EditorTypeToString(etBackGround) + '.main_background');
  FBasicEditor.Strings.Add('_description=背景上的文字配置');
end;

procedure TfrmComplexEditor.CreateImageOnBGEditor;
begin
  // 添加图像背景相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etImageOnBG));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=背景上的图像配置');
  FBasicEditor.Strings.Add('image_path=');
  FBasicEditor.Strings.Add('background._ref=' + EditorTypeToString(etBackGround) + '.main_background');
  FBasicEditor.Strings.Add('position.x=0');
  FBasicEditor.Strings.Add('position.y=0');
  FBasicEditor.Strings.Add('position.isXcenter=false');
  FBasicEditor.Strings.Add('position.isYcenter=false');
  FBasicEditor.Strings.Add('position.scale=1.0');
  FBasicEditor.Strings.Add('position.z_index=0');
  FBasicEditor.Strings.Add('transparency=0');
  FBasicEditor.Strings.Add('rotation=0');
end;

procedure TfrmComplexEditor.CreateDrawerOnBGEditor;
begin
  // 添加背景绘图相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etDrawerOnBG));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=背景上的绘图配置');
  FBasicEditor.Strings.Add('background._ref=' + EditorTypeToString(etBackGround) + '.main_background');
  FBasicEditor.Strings.Add('drawer_type=rect'); // rect, ellipse, line
  FBasicEditor.Strings.Add('position.x=0');
  FBasicEditor.Strings.Add('position.y=0');
  FBasicEditor.Strings.Add('width=100');
  FBasicEditor.Strings.Add('height=100');
  FBasicEditor.Strings.Add('color=#000000');
  FBasicEditor.Strings.Add('line_width=1');
  FBasicEditor.Strings.Add('is_filled=false');
  FBasicEditor.Strings.Add('fill_color=#FFFFFF');
  FBasicEditor.Strings.Add('position.z_index=0');
end;

procedure TfrmComplexEditor.CreateSubtitleEditor;
begin
  // 添加字幕相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etSubtitle));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=字幕配置');
  FBasicEditor.Strings.Add('text=');
  FBasicEditor.Strings.Add('font._ref=' + EditorTypeToString(etFont) + '.main_font');
  FBasicEditor.Strings.Add('start_time=00:00:00.000');
  FBasicEditor.Strings.Add('end_time=00:00:05.000');
  FBasicEditor.Strings.Add('position.x=0');
  FBasicEditor.Strings.Add('position.y=0');
  FBasicEditor.Strings.Add('position.isXcenter=true');
  FBasicEditor.Strings.Add('position.isYcenter=false');
  FBasicEditor.Strings.Add('background_color=#00000000');
  FBasicEditor.Strings.Add('border_color=#00000000');
  FBasicEditor.Strings.Add('border_width=0');
end;

procedure TfrmComplexEditor.CreatePageEditor;
begin
  // 添加页面相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etPage));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=页面配置');
  FBasicEditor.Strings.Add('background._ref=' + EditorTypeToString(etBackGround) + '.main_background');
  FBasicEditor.Strings.Add('width=1920');
  FBasicEditor.Strings.Add('height=1080');
  FBasicEditor.Strings.Add('elements=[]'); // JSON数组，包含页面元素ID
  FBasicEditor.Strings.Add('transition=none'); // none, fade, slide
  FBasicEditor.Strings.Add('transition_duration=1.0');
  FBasicEditor.Strings.Add('audio._ref=');
end;

procedure TfrmComplexEditor.CreateVideoClipEditor;
begin
  // 添加视频片段相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etVideoClip));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=视频片段配置');
  FBasicEditor.Strings.Add('video_path=');
  FBasicEditor.Strings.Add('start_time=00:00:00.000');
  FBasicEditor.Strings.Add('end_time=00:00:10.000');
  FBasicEditor.Strings.Add('volume=1.0');
  FBasicEditor.Strings.Add('speed=1.0');
  FBasicEditor.Strings.Add('position.x=0');
  FBasicEditor.Strings.Add('position.y=0');
  FBasicEditor.Strings.Add('width=1920');
  FBasicEditor.Strings.Add('height=1080');
  FBasicEditor.Strings.Add('position.isXcenter=true');
  FBasicEditor.Strings.Add('position.isYcenter=true');
  FBasicEditor.Strings.Add('position.z_index=0');
end;

procedure TfrmComplexEditor.CreateConnectionEditor;
begin
  // 添加网络连接相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etConnection));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=网络连接配置');
  FBasicEditor.Strings.Add('host=localhost');
  FBasicEditor.Strings.Add('port=80');
  FBasicEditor.Strings.Add('protocol=http'); // http, https, ftp, ssh
  FBasicEditor.Strings.Add('timeout=30');
  FBasicEditor.Strings.Add('retry_count=3');
  FBasicEditor.Strings.Add('use_proxy=false');
  FBasicEditor.Strings.Add('proxy_host=');
  FBasicEditor.Strings.Add('proxy_port=0');
  FBasicEditor.Strings.Add('credential._ref=');
end;

procedure TfrmComplexEditor.CreateCredentialEditor;
begin
  // 添加凭证相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etCredential));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=凭证配置');
  FBasicEditor.Strings.Add('username=');
  FBasicEditor.Strings.Add('password=');
  FBasicEditor.Strings.Add('token=');
  FBasicEditor.Strings.Add('certificate_path=');
  FBasicEditor.Strings.Add('key_path=');
  FBasicEditor.Strings.Add('is_encrypted=false');
  FBasicEditor.Strings.Add('auth_type=basic'); // basic, token, certificate
end;

procedure TfrmComplexEditor.CreateLocalizationEditor;
begin
  // 添加本地化相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etLocalization));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=本地化配置');
  FBasicEditor.Strings.Add('language=zh-CN');
  FBasicEditor.Strings.Add('region=CN');
  FBasicEditor.Strings.Add('timezone=GMT+8');
  FBasicEditor.Strings.Add('date_format=yyyy-MM-dd');
  FBasicEditor.Strings.Add('time_format=HH:mm:ss');
  FBasicEditor.Strings.Add('currency_format=¥#,##0.00');
  FBasicEditor.Strings.Add('number_format=#,##0.00');
end;

procedure TfrmComplexEditor.CreateArrayEditor;
begin
  // 添加数组相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etArray));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=数组配置');
  FBasicEditor.Strings.Add('element_type=string'); // string, number, boolean, object
  FBasicEditor.Strings.Add('min_items=0');
  FBasicEditor.Strings.Add('max_items=100');
  FBasicEditor.Strings.Add('unique_items=false');
  FBasicEditor.Strings.Add('items=[]'); // JSON数组，包含数组元素
end;

procedure TfrmComplexEditor.CreateAIAPIEditor;
begin
  // 添加AI API相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etAIAPI));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=AI大模型API配置');
  FBasicEditor.Strings.Add('provider=openai'); // openai, azure, anthropic
  FBasicEditor.Strings.Add('api_key=');
  FBasicEditor.Strings.Add('endpoint=https://api.openai.com');
  FBasicEditor.Strings.Add('model=gpt-3.5-turbo');
  FBasicEditor.Strings.Add('max_tokens=2048');
  FBasicEditor.Strings.Add('temperature=0.7');
  FBasicEditor.Strings.Add('top_p=1.0');
  FBasicEditor.Strings.Add('timeout=60');
end;

procedure TfrmComplexEditor.CreateCustomEditor;
begin
  // 添加自定义类型相关配置
  FBasicEditor.Strings.Add('_type=' + EditorTypeToString(etCustom));
  FBasicEditor.Strings.Add('_id=');
  FBasicEditor.Strings.Add('_description=自定义类型配置');
  FBasicEditor.Strings.Add('schema={}'); // JSON对象，描述自定义类型的结构
  FBasicEditor.Strings.Add('data={}'); // JSON对象，包含自定义类型的数据
  FBasicEditor.Strings.Add('editor_class=');
  FBasicEditor.Strings.Add('validation_script=');
end;

procedure TfrmComplexEditor.PopulateEditors;
var
  ValueStr: string;
begin
  if not Assigned(FJSONObject) then
    Exit;

  // 填充基本编辑器
  for var i := 0 to FBasicEditor.Strings.Count - 1 do
  begin
    var Key := FBasicEditor.Keys[i];
    var Value := FJSONObject.GetValue(Key);

    if Assigned(Value) then
    begin
      if Value is TJSONString then
        ValueStr := TJSONString(Value).Value
      else if Value is TJSONNumber then
        ValueStr := TJSONNumber(Value).ToString
      else if Value is TJSONBool then
        ValueStr := BoolToStr(TJSONBool(Value).AsBoolean, True)
      else
        ValueStr := Value.ToString;

      FBasicEditor.Strings[i] := Key + '=' + ValueStr;
    end;
  end;

  // 填充高级编辑器
  FAdvancedEditor.Text := FJSONObject.Format(2);
end;

procedure TfrmComplexEditor.UpdatePreview;
var
  PreviewControl: TControl;
begin
  // 清空预览面板
  for var i := FPreviewPanel.ControlCount - 1 downto 0 do
    FPreviewPanel.Controls[i].Free;

  // 创建预览控件
  PreviewControl := CreatePreviewControl;
  if Assigned(PreviewControl) then
  begin
    PreviewControl.Parent := FPreviewPanel;
    PreviewControl.Align := alClient;
  end;
end;

function TfrmComplexEditor.CreatePreviewControl: TControl;
var
  Label1: TLabel;
  Panel1: TPanel;
  Image1: TImage;
begin
  Result := nil;

  case FConfigType of
    etFont:
      begin
        // 创建字体预览
        Label1 := TLabel.Create(FPreviewPanel);
        Label1.Caption := '示例文本 Sample Text 123';
        Label1.Align := alTop;
        Label1.Alignment := taCenter;
        Label1.Layout := tlCenter;
        Label1.Height := 50;

        // 设置字体样式
        try
          Label1.Font.Name := FBasicEditor.Values['name'];
          Label1.Font.Size := StrToIntDef(FBasicEditor.Values['size'], 12);
          Label1.Font.Color := StringToColor(FBasicEditor.Values['color']);

          if SameText(FBasicEditor.Values['bold'], 'true') then
            Label1.Font.Style := Label1.Font.Style + [fsBold];

          if SameText(FBasicEditor.Values['italic'], 'true') then
            Label1.Font.Style := Label1.Font.Style + [fsItalic];

          if SameText(FBasicEditor.Values['underline'], 'true') then
            Label1.Font.Style := Label1.Font.Style + [fsUnderline];

          if SameText(FBasicEditor.Values['strike_out'], 'true') then
            Label1.Font.Style := Label1.Font.Style + [fsStrikeOut];
        except
          // 忽略字体设置错误
        end;

        Result := Label1;
      end;

    etBackGround:
      begin
        // 创建背景预览
        Panel1 := TPanel.Create(FPreviewPanel);
        Panel1.Align := alClient;
        Panel1.BevelOuter := bvNone;

        // 设置背景颜色
        try
          Panel1.Color := StringToColor(FBasicEditor.Values['color']);
        except
          // 忽略颜色设置错误
        end;

        Result := Panel1;
      end;

    etImage:
      begin
        // 创建图片预览
        Image1 := TImage.Create(FPreviewPanel);
        Image1.Align := alClient;
        Image1.Stretch := True;
        Image1.Proportional := True;
        Image1.Center := True;

        // 加载图片
        try
          var ImagePath := FBasicEditor.Values['path'];
          if FileExists(ImagePath) then
            Image1.Picture.LoadFromFile(ImagePath);
        except
          // 忽略图片加载错误
        end;

        Result := Image1;
      end;

    etTextOnBG:
      begin
        // 创建文字在背景上的预览
        Panel1 := TPanel.Create(FPreviewPanel);
        Panel1.Align := alClient;
        Panel1.BevelOuter := bvNone;

        Label1 := TLabel.Create(Panel1);
        Label1.Parent := Panel1;
        Label1.Align := alClient;
        Label1.Alignment := taCenter;
        Label1.Layout := tlCenter;

        // 设置文字和背景样式
        try
          Label1.Caption := FBasicEditor.Values['text'];
          Panel1.Color := clSilver; // 默认背景颜色
        except
          // 忽略设置错误
        end;

        Result := Panel1;
      end;
  end;
end;

procedure TfrmComplexEditor.btnOKClick(Sender: TObject);
var
  NewJSON: TJSONObject;
  Key, Value: string;
begin
  // 验证输入
  if Trim(edtID.Text) = '' then
  begin
    ShowMessage('请输入配置ID');
    edtID.SetFocus;
    Exit;
  end;

  NewJSON := nil; // 初始化为nil以防异常
  try
    // 创建新的JSON对象
    NewJSON := TJSONObject.Create;

    // 添加类型和ID
    NewJSON.AddPair('_type', EditorTypeToString(FConfigType));
    NewJSON.AddPair('_id', edtID.Text);

    // 填充基本编辑器的内容
    for var i := 0 to FBasicEditor.RowCount - 1 do
    begin
      if i = 0 then Continue; // 跳过标题行

      Key := FBasicEditor.Keys[i];
      if (Key = '') or (Key = '_type') or (Key = '_id') then
        Continue;

      Value := FBasicEditor.Values[Key];

      // 根据键值类型添加到JSON
      if (Key.Contains('color')) and Value.StartsWith('#') then
        NewJSON.AddPair(Key, Value)
      else if (Key = 'size') or (Key = 'width') or (Key = 'height') or
              (Key = 'port') or Key.EndsWith('.x') or Key.EndsWith('.y') or
              Key.EndsWith('.z_index') then
        NewJSON.AddPair(Key, TJSONNumber.Create(StrToIntDef(Value, 0)))
      else if Key.EndsWith('.scale') or Key.EndsWith('.opacity') then
        NewJSON.AddPair(Key, TJSONNumber.Create(StrToFloatDef(Value, 0)))
      else if (Key.EndsWith('.isXcenter')) or (Key.EndsWith('.isYcenter')) or
               (Key = 'bold') or (Key = 'italic') or (Key = 'underline') or
               (Key = 'strike_out') then
        NewJSON.AddPair(Key, TJSONBool.Create(SameText(Value, 'true')))
      else if Key.StartsWith('_ref.') then
        NewJSON.AddPair(Key, Value)
      else
        NewJSON.AddPair(Key, Value);
    end;

    // 更新JSON对象
    if Assigned(FJSONObject) then
      FJSONObject.Free;

    FJSONObject := NewJSON;
    FConfigID := edtID.Text;

    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      ShowMessage('发生错误: ' + E.Message);
      if Assigned(NewJSON) then
        NewJSON.Free;
    end;
  end;
end;

procedure TfrmComplexEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function EditorTypeToString(EditorType: TEditorType): string;
begin
  Result := GetEnumName(TypeInfo(TEditorType), Ord(EditorType));
end;

function StringToEditorType(const TypeStr: string): TEditorType;
begin
  try
    Result := TEditorType(GetEnumValue(TypeInfo(TEditorType), TypeStr));
  except
    Result := etPlain;
  end;
end;

// 将ConfigType枚举转换为EditorType枚举
function ConfigTypeToEditorType(ConfigType: TConfigType): TEditorType;
begin
  case ConfigType of
    ctFont: Result := etFont;
    ctColor: Result := etColor;
    ctDatabase: Result := etDatabase;
    ctList: Result := etList;
    ctObject: Result := etObject;
    ctArray: Result := etArray;
    else
      Result := etPlain;
  end;
end;

// 将EditorType枚举转换为ConfigType枚举
function EditorTypeToConfigType(EditorType: TEditorType): TConfigType;
begin
  case EditorType of
    etFont: Result := ctFont;
    etColor: Result := ctColor;
    etDatabase: Result := ctDatabase;
    etList: Result := ctList;
    etObject: Result := ctObject;
    etArray: Result := ctArray;
    else
      Result := ctPlain;
  end;
end;

end.

