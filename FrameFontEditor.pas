unit FrameFontEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigFrameBase, UtilsTypes, JSONHelpers;

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
  // 涓婚潰鏉?  pnlMain := TPanel.Create(Self);
  pnlMain.Parent := Self;
  pnlMain.Align := alClient;
  pnlMain.BevelOuter := bvNone;
  pnlMain.Padding.SetBounds(10, 10, 10, 10);

  // 瀛椾綋鍚嶇О
  lblName := TLabel.Create(Self);
  lblName.Parent := pnlMain;
  lblName.Top := 15;
  lblName.Left := 10;
  lblName.Caption := '瀛椾綋鍚嶇О:';

  edtName := TEdit.Create(Self);
  edtName.Parent := pnlMain;
  edtName.Top := lblName.Top;
  edtName.Left := 100;
  edtName.Width := 200;
  edtName.Text := 'Arial';
  edtName.OnChange := edtNameChange;

  // 瀛椾綋澶у皬
  lblSize := TLabel.Create(Self);
  lblSize.Parent := pnlMain;
  lblSize.Top := lblName.Top + 30;
  lblSize.Left := 10;
  lblSize.Caption := '瀛椾綋澶у皬:';

  edtSize := TEdit.Create(Self);
  edtSize.Parent := pnlMain;
  edtSize.Top := lblSize.Top;
  edtSize.Left := 100;
  edtSize.Width := 50;
  edtSize.Text := '12';
  edtSize.OnChange := edtSizeChange;

  // 瀛椾綋棰滆壊
  lblColor := TLabel.Create(Self);
  lblColor.Parent := pnlMain;
  lblColor.Top := lblSize.Top + 30;
  lblColor.Left := 10;
  lblColor.Caption := '瀛椾綋棰滆壊:';

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
  btnSelectColor.Caption := '閫夋嫨棰滆壊';
  btnSelectColor.OnClick := btnSelectColorClick;

  // 瀛椾綋鏍峰紡
  chkBold := TCheckBox.Create(Self);
  chkBold.Parent := pnlMain;
  chkBold.Top := lblColor.Top + 30;
  chkBold.Left := 10;
  chkBold.Caption := '绮椾綋';
  chkBold.OnClick := chkStyleChange;

  chkItalic := TCheckBox.Create(Self);
  chkItalic.Parent := pnlMain;
  chkItalic.Top := chkBold.Top;
  chkItalic.Left := 100;
  chkItalic.Caption := '鏂滀綋';
  chkItalic.OnClick := chkStyleChange;

  chkUnderline := TCheckBox.Create(Self);
  chkUnderline.Parent := pnlMain;
  chkUnderline.Top := chkBold.Top + 25;
  chkUnderline.Left := 10;
  chkUnderline.Caption := 'Underline';
  chkUnderline.OnClick := chkStyleChange;

  chkStrikeout := TCheckBox.Create(Self);
  chkStrikeout.Parent := pnlMain;
  chkStrikeout.Top := chkBold.Top + 25;
  chkStrikeout.Left := 100;
  chkStrikeout.Caption := 'Strikeout';
  chkStrikeout.OnClick := chkStyleChange;

  // 棰勮鍖哄煙
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
  lblPreview.Caption := 'Sample Text 123';

  // 棰滆壊瀵硅瘽妗?  dlgColor := TColorDialog.Create(Self);
  dlgColor.Color := clBlack;
  
  UpdatePreview;
end;

procedure TFontEditorFrame.LoadFromJSON;
var
  Value: TJSONValue;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 鍔犺浇瀛椾綋鍚嶇О
  Value := JSONObject.GetValue('name');
  if Assigned(Value) and (Value is TJSONString) then
    edtName.Text := TJSONString(Value).Value
  else
    edtName.Text := 'Arial';

  // 鍔犺浇瀛椾綋澶у皬
  Value := JSONObject.GetValue('size');
  if Assigned(Value) and (Value is TJSONNumber) then
    edtSize.Text := TJSONNumber(Value).ToString
  else
    edtSize.Text := '12';

  // 鍔犺浇瀛椾綋棰滆壊
  Value := JSONObject.GetValue('color');
  if Assigned(Value) and (Value is TJSONString) then
    SelectedColor := HTMLToColor(TJSONString(Value).Value)
  else
    SelectedColor := clBlack;

  // 鍔犺浇瀛椾綋鏍峰紡
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

  // 鏇存柊棰勮
  UpdatePreview;
end;

procedure TFontEditorFrame.SaveToJSON;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 淇濆瓨瀛椾綋绫诲瀷淇℃伅
  if JSONObject.GetValue('_type') = nil then
    JSONObject.AddPair('_type', ConfigTypeToString(ctFont));

  // 淇濆瓨鎵€鏈夊瓧浣撳睘鎬?  // 瀛椾綋鍚嶇О
  if JSONObject.GetValue('name') <> nil then
    JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);

  // 瀛椾綋澶у皬
  if JSONObject.GetValue('size') <> nil then
    JSONObject.RemovePair('size');
  JSONObject.AddPair('size', TJSONNumber.Create(StrToIntDef(edtSize.Text, 12)));

  // 瀛椾綋棰滆壊
  if JSONObject.GetValue('color') <> nil then
    JSONObject.RemovePair('color');
  JSONObject.AddPair('color', ColorToHTML(FSelectedColor));

  // 瀛椾綋鏍峰紡
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
  // Ensure interface controls are created
  if not Assigned(lblPreview) then
    Exit;
    
  FontStyle := [];
  if chkBold.Checked then
    FontStyle := FontStyle + [fsBold];
  if chkItalic.Checked then
    FontStyle := FontStyle + [fsItalic];
  if chkUnderline.Checked then
    FontStyle := FontStyle + [fsUnderline];
  if chkStrikeout.Checked then
    FontStyle := FontStyle + [fsStrikeOut];
    
  lblPreview.Font.Name := edtName.Text;
  lblPreview.Font.Size := StrToIntDef(edtSize.Text, 12);
  lblPreview.Font.Color := FSelectedColor;
  lblPreview.Font.Style := FontStyle;
end;

end. 