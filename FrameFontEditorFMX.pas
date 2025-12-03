unit FrameFontEditorFMX;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.UITypes, System.UIConsts,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.Colors, FMX.Controls.Presentation,
  FMX.Objects, ConfigFrameBaseFMX, UtilsTypesFMX;

type
  TFrameFontEditorFMX = class(TBaseConfigFrameFMX)
    lblFontName: TLabel;
    cboFontName: TComboBox;
    lblFontSize: TLabel;
    spnFontSize: TSpinBox;
    lblFontStyle: TLabel;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    lblFontColor: TLabel;
    clrFontColor: TColorComboBox;
    lblPreview: TLabel;
    rectPreview: TRectangle;
    lblPreviewText: TLabel;
    layMain: TLayout;
    layRow1: TLayout;
    layRow2: TLayout;
    layRow3: TLayout;
    layRow4: TLayout;
    layPreview: TLayout;
    procedure cboFontNameChange(Sender: TObject);
    procedure spnFontSizeChange(Sender: TObject);
    procedure chkStyleChange(Sender: TObject);
    procedure clrFontColorChange(Sender: TObject);
  private
    procedure UpdatePreview;
    procedure LoadFontList;
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
  FMX.Graphics;

{ TFrameFontEditorFMX }

constructor TFrameFontEditorFMX.Create(AOwner: TComponent);
begin
  inherited;
  LoadFontList;
end;

procedure TFrameFontEditorFMX.LoadFontList;
begin
  cboFontName.Items.Clear;
  
  // 添加常用字体
  cboFontName.Items.Add('Microsoft YaHei');
  cboFontName.Items.Add('Microsoft YaHei UI');
  cboFontName.Items.Add('SimSun');
  cboFontName.Items.Add('SimHei');
  cboFontName.Items.Add('KaiTi');
  cboFontName.Items.Add('FangSong');
  cboFontName.Items.Add('Arial');
  cboFontName.Items.Add('Tahoma');
  cboFontName.Items.Add('Verdana');
  cboFontName.Items.Add('Times New Roman');
  cboFontName.Items.Add('Courier New');
  cboFontName.Items.Add('Consolas');
  cboFontName.Items.Add('Segoe UI');
    
  if cboFontName.Items.Count > 0 then
    cboFontName.ItemIndex := 0;
end;

procedure TFrameFontEditorFMX.LoadFromJSON;
var
  FontName: string;
  FontSize: Integer;
  FontColor: string;
  StyleArr: TJSONArray;
  StyleVal: TJSONValue;
  StyleStr: string;
  Idx: Integer;
begin
  if not Assigned(JSONObject) then Exit;
  
  // 加载字体名称
  FontName := GetJSONString('Name', 'Microsoft YaHei');
  Idx := cboFontName.Items.IndexOf(FontName);
  if Idx >= 0 then
    cboFontName.ItemIndex := Idx
  else
  begin
    cboFontName.Items.Insert(0, FontName);
    cboFontName.ItemIndex := 0;
  end;
  
  // 加载字体大小
  FontSize := GetJSONInt('Size', 10);
  spnFontSize.Value := FontSize;
  
  // 加载字体样式
  chkBold.IsChecked := False;
  chkItalic.IsChecked := False;
  chkUnderline.IsChecked := False;
  
  if JSONObject.TryGetValue<TJSONArray>('Style', StyleArr) then
  begin
    for StyleVal in StyleArr do
    begin
      StyleStr := StyleVal.Value;
      if SameText(StyleStr, 'Bold') then
        chkBold.IsChecked := True
      else if SameText(StyleStr, 'Italic') then
        chkItalic.IsChecked := True
      else if SameText(StyleStr, 'Underline') then
        chkUnderline.IsChecked := True;
    end;
  end;
  
  // 加载字体颜色
  FontColor := GetJSONString('Color', '#000000');
  clrFontColor.Color := HTMLToAlphaColor(FontColor);
  
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.SaveToJSON;
var
  StyleArr: TJSONArray;
begin
  if cboFontName.ItemIndex >= 0 then
    SetJSONString('Name', cboFontName.Items[cboFontName.ItemIndex])
  else
    SetJSONString('Name', 'Microsoft YaHei');
    
  SetJSONInt('Size', Round(spnFontSize.Value));
  
  // 保存字体样式
  StyleArr := TJSONArray.Create;
  if chkBold.IsChecked then
    StyleArr.Add('Bold');
  if chkItalic.IsChecked then
    StyleArr.Add('Italic');
  if chkUnderline.IsChecked then
    StyleArr.Add('Underline');
    
  if JSONObject.GetValue('Style') <> nil then
    JSONObject.RemovePair('Style');
  JSONObject.AddPair('Style', StyleArr);
  
  // 保存字体颜色
  SetJSONString('Color', AlphaColorToHTML(clrFontColor.Color));
  
  // 设置类型标识
  SetJSONString('$type', 'Font');
end;

function TFrameFontEditorFMX.Validate(out ErrorMsg: string): Boolean;
begin
  Result := True;
  ErrorMsg := '';
  
  if cboFontName.ItemIndex < 0 then
  begin
    ErrorMsg := '请选择字体';
    Result := False;
    Exit;
  end;
  
  if (spnFontSize.Value < 6) or (spnFontSize.Value > 200) then
  begin
    ErrorMsg := '字体大小必须在 6-200 之间';
    Result := False;
    Exit;
  end;
end;

function TFrameFontEditorFMX.GetEditorType: TEditorType;
begin
  Result := etFont;
end;

procedure TFrameFontEditorFMX.Clear;
begin
  inherited;
  if cboFontName.Items.Count > 0 then
    cboFontName.ItemIndex := 0;
  spnFontSize.Value := 10;
  chkBold.IsChecked := False;
  chkItalic.IsChecked := False;
  chkUnderline.IsChecked := False;
  clrFontColor.Color := TAlphaColorRec.Black;
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.cboFontNameChange(Sender: TObject);
begin
  DoModified(Sender);
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.spnFontSizeChange(Sender: TObject);
begin
  DoModified(Sender);
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.chkStyleChange(Sender: TObject);
begin
  DoModified(Sender);
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.clrFontColorChange(Sender: TObject);
begin
  DoModified(Sender);
  UpdatePreview;
end;

procedure TFrameFontEditorFMX.UpdatePreview;
var
  FontStyle: TFontStyles;
begin
  // 更新预览标签
  if cboFontName.ItemIndex >= 0 then
    lblPreviewText.TextSettings.Font.Family := cboFontName.Items[cboFontName.ItemIndex];
    
  lblPreviewText.TextSettings.Font.Size := spnFontSize.Value;
  
  FontStyle := [];
  if chkBold.IsChecked then
    FontStyle := FontStyle + [TFontStyle.fsBold];
  if chkItalic.IsChecked then
    FontStyle := FontStyle + [TFontStyle.fsItalic];
  if chkUnderline.IsChecked then
    FontStyle := FontStyle + [TFontStyle.fsUnderline];
  lblPreviewText.TextSettings.Font.Style := FontStyle;
  
  lblPreviewText.TextSettings.FontColor := clrFontColor.Color;
end;

end.
