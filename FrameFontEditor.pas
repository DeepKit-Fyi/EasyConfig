unit FrameFontEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigFrameBase, UtilsTypes;

type
  TFontEditorFrame = class(TBaseConfigFrame)
    pnlMain: TPanel;
    lblName: TLabel;
    edtName: TEdit;
    lblSize: TLabel;
    edtSize: TEdit;
    lblColor: TLabel;
    pnlColor: TPanel;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    chkStrikeout: TCheckBox;
    btnSelectColor: TButton;
    pnlPreview: TPanel;
    lblPreview: TLabel;
    dlgColor: TColorDialog;
    procedure btnSelectColorClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure edtSizeChange(Sender: TObject);
    procedure chkStyleChange(Sender: TObject);
  private
    FSelectedColor: TColor;
    procedure SetSelectedColor(const Value: TColor);
    function ColorToHTML(Color: TColor): string;
    function HTMLToColor(const HTML: string): TColor;
    procedure UpdatePreview;
  protected
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
  end;

implementation

{ TFontEditorFrame }

constructor TFontEditorFrame.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedColor := clBlack;
  CreateControls;
end;

procedure TFontEditorFrame.CreateControls;
begin
  // 主面板
  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  pnlMain.Padding.SetBounds(10, 10, 10, 10);

  // 字体名称
  lblName := TLabel.Create(Self);
  lblName.Parent := pnlMain;
  lblName.Top := 15;
  lblName.Left := 10;
  lblName.Caption := '字体名称:';

  edtName := TEdit.Create(Self);
  edtName.Parent := pnlMain;
  edtName.Top := lblName.Top;
  edtName.Left := 100;
  edtName.Width := 200;
  edtName.Text := 'Arial';
  edtName.OnChange := edtNameChange;

  // 字体大小
  lblSize := TLabel.Create(Self);
  lblSize.Parent := pnlMain;
  lblSize.Top := lblName.Top + 30;
  lblSize.Left := 10;
  lblSize.Caption := '字体大小:';

  edtSize := TEdit.Create(Self);
  edtSize.Parent := pnlMain;
  edtSize.Top := lblSize.Top;
  edtSize.Left := 100;
  edtSize.Width := 50;
  edtSize.Text := '12';
  edtSize.OnChange := edtSizeChange;

  // 字体颜色
  lblColor := TLabel.Create(Self);
  lblColor.Parent := pnlMain;
  lblColor.Top := lblSize.Top + 30;
  lblColor.Left := 10;
  lblColor.Caption := '字体颜色:';

  pnlColor := TPanel.Create(Self);
  pnlColor.Parent := pnlMain;
  pnlColor.Top := lblColor.Top;
  pnlColor.Left := 100;
  pnlColor.Width := 50;
  pnlColor.Height := 21;
  pnlColor.BevelOuter := bvLowered;
  pnlColor.Color := clBlack;

  btnSelectColor := TButton.Create(Self);
  btnSelectColor.Parent := pnlMain;
  btnSelectColor.Top := lblColor.Top;
  btnSelectColor.Left := pnlColor.Left + pnlColor.Width + 10;
  btnSelectColor.Width := 80;
  btnSelectColor.Caption := '选择颜色';
  btnSelectColor.OnClick := btnSelectColorClick;

  // 字体样式
  chkBold := TCheckBox.Create(Self);
  chkBold.Parent := pnlMain;
  chkBold.Top := lblColor.Top + 30;
  chkBold.Left := 10;
  chkBold.Caption := '粗体';
  chkBold.OnClick := chkStyleChange;

  chkItalic := TCheckBox.Create(Self);
  chkItalic.Parent := pnlMain;
  chkItalic.Top := chkBold.Top;
  chkItalic.Left := 100;
  chkItalic.Caption := '斜体';
  chkItalic.OnClick := chkStyleChange;

  chkUnderline := TCheckBox.Create(Self);
  chkUnderline.Parent := pnlMain;
  chkUnderline.Top := chkBold.Top + 25;
  chkUnderline.Left := 10;
  chkUnderline.Caption := '下划线';
  chkUnderline.OnClick := chkStyleChange;

  chkStrikeout := TCheckBox.Create(Self);
  chkStrikeout.Parent := pnlMain;
  chkStrikeout.Top := chkBold.Top + 25;
  chkStrikeout.Left := 100;
  chkStrikeout.Caption := '删除线';
  chkStrikeout.OnClick := chkStyleChange;

  // 预览区域
  pnlPreview := TPanel.Create(Self);
  pnlPreview.Parent := pnlMain;
  pnlPreview.Top := chkStrikeout.Top + 40;
  pnlPreview.Left := 10;
  pnlPreview.Width := 290;
  pnlPreview.Height := 100;
  pnlPreview.BevelOuter := bvLowered;
  pnlPreview.Caption := '';

  lblPreview := TLabel.Create(Self);
  lblPreview.Parent := pnlPreview;
  lblPreview.Align := alClient;
  lblPreview.Alignment := taCenter;
  lblPreview.Layout := tlCenter;
  lblPreview.Caption := '示例文本 Sample Text 123';

  // 颜色对话框
  dlgColor := TColorDialog.Create(Self);
  dlgColor.Color := clBlack;
  
  UpdatePreview;
end;

procedure TFontEditorFrame.LoadFromJSON;
var
  Value: TJSONValue;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 加载字体名称
  Value := JSONObject.GetValue('name');
  if Assigned(Value) and (Value is TJSONString) then
    edtName.Text := TJSONString(Value).Value
  else
    edtName.Text := 'Arial';

  // 加载字体大小
  Value := JSONObject.GetValue('size');
  if Assigned(Value) and (Value is TJSONNumber) then
    edtSize.Text := TJSONNumber(Value).ToString
  else
    edtSize.Text := '12';

  // 加载字体颜色
  Value := JSONObject.GetValue('color');
  if Assigned(Value) and (Value is TJSONString) then
    SelectedColor := HTMLToColor(TJSONString(Value).Value)
  else
    SelectedColor := clBlack;

  // 加载字体样式
  Value := JSONObject.GetValue('bold');
  if Assigned(Value) and (Value is TJSONBool) then
    chkBold.Checked := TJSONBool(Value).AsBoolean
  else
    chkBold.Checked := False;

  Value := JSONObject.GetValue('italic');
  if Assigned(Value) and (Value is TJSONBool) then
    chkItalic.Checked := TJSONBool(Value).AsBoolean
  else
    chkItalic.Checked := False;

  Value := JSONObject.GetValue('underline');
  if Assigned(Value) and (Value is TJSONBool) then
    chkUnderline.Checked := TJSONBool(Value).AsBoolean
  else
    chkUnderline.Checked := False;

  Value := JSONObject.GetValue('strike_out');
  if Assigned(Value) and (Value is TJSONBool) then
    chkStrikeout.Checked := TJSONBool(Value).AsBoolean
  else
    chkStrikeout.Checked := False;

  // 更新预览
  UpdatePreview;
end;

procedure TFontEditorFrame.SaveToJSON;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 保存字体类型信息
  if JSONObject.GetValue('_type') = nil then
    JSONObject.AddPair('_type', ConfigTypeToString(ctFont));

  // 保存所有字体属性
  // 字体名称
  if JSONObject.GetValue('name') <> nil then
    JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);

  // 字体大小
  if JSONObject.GetValue('size') <> nil then
    JSONObject.RemovePair('size');
  JSONObject.AddPair('size', TJSONNumber.Create(StrToIntDef(edtSize.Text, 12)));

  // 字体颜色
  if JSONObject.GetValue('color') <> nil then
    JSONObject.RemovePair('color');
  JSONObject.AddPair('color', ColorToHTML(FSelectedColor));

  // 字体样式
  if JSONObject.GetValue('bold') <> nil then
    JSONObject.RemovePair('bold');
  JSONObject.AddPair('bold', TJSONBool.Create(chkBold.Checked));

  if JSONObject.GetValue('italic') <> nil then
    JSONObject.RemovePair('italic');
  JSONObject.AddPair('italic', TJSONBool.Create(chkItalic.Checked));

  if JSONObject.GetValue('underline') <> nil then
    JSONObject.RemovePair('underline');
  JSONObject.AddPair('underline', TJSONBool.Create(chkUnderline.Checked));

  if JSONObject.GetValue('strike_out') <> nil then
    JSONObject.RemovePair('strike_out');
  JSONObject.AddPair('strike_out', TJSONBool.Create(chkStrikeout.Checked));
end;

procedure TFontEditorFrame.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
  pnlColor.Color := Value;
  UpdatePreview;
end;

procedure TFontEditorFrame.btnSelectColorClick(Sender: TObject);
begin
  dlgColor.Color := FSelectedColor;
  if dlgColor.Execute then
  begin
    SelectedColor := dlgColor.Color;
    Modified := True;
  end;
end;

procedure TFontEditorFrame.chkStyleChange(Sender: TObject);
begin
  UpdatePreview;
  Modified := True;
end;

function TFontEditorFrame.ColorToHTML(Color: TColor): string;
begin
  Result := Format('#%.6x', [ColorToRGB(Color) and $FFFFFF]);
end;

function TFontEditorFrame.HTMLToColor(const HTML: string): TColor;
begin
  if (Length(HTML) = 7) and (HTML[1] = '#') then
  begin
    try
      Result := TColor(StrToInt('$' + Copy(HTML, 2, 6)));
    except
      Result := clBlack;
    end;
  end
  else
    Result := clBlack;
end;

procedure TFontEditorFrame.edtNameChange(Sender: TObject);
begin
  UpdatePreview;
  Modified := True;
end;

procedure TFontEditorFrame.edtSizeChange(Sender: TObject);
begin
  UpdatePreview;
  Modified := True;
end;

procedure TFontEditorFrame.UpdatePreview;
var
  FontStyle: TFontStyles;
begin
  // 确保界面控件已创建
  if not Assigned(lblPreview) then
    Exit;

  FontStyle := [];
  if Assigned(chkBold) and chkBold.Checked then
    FontStyle := FontStyle + [fsBold];
  if Assigned(chkItalic) and chkItalic.Checked then
    FontStyle := FontStyle + [fsItalic];
  if Assigned(chkUnderline) and chkUnderline.Checked then
    FontStyle := FontStyle + [fsUnderline];
  if Assigned(chkStrikeout) and chkStrikeout.Checked then
    FontStyle := FontStyle + [fsStrikeOut];

  if Assigned(edtName) then
    lblPreview.Font.Name := edtName.Text;
  if Assigned(edtSize) then
    lblPreview.Font.Size := StrToIntDef(edtSize.Text, 12);
  
  lblPreview.Font.Color := FSelectedColor;
  lblPreview.Font.Style := FontStyle;
end;

end. 