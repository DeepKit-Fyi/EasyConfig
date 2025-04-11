unit SimpleEditors;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, Vcl.Graphics, Vcl.Grids, Vcl.ValEdit;

type
  TfrmSimpleEditor = class(TForm)
    pnlMain: TPanel;
    pnlButtons: TPanel;
    pnlContent: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblConfigType: TLabel;
    lblConfigName: TLabel;
    edtName: TEdit;
    cbbConfigType: TComboBox;
    grpValue: TGroupBox;
    pnlType: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbConfigTypeChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FConfigType: TConfigType;
    FConfigName: string;
    FConfigValue: string;
    FEditorControl: TControl;

    procedure CreateEditorControl;
    procedure SetConfigType(const Value: TConfigType);
    function GetConfigValue: string;

    procedure InitializeConfigTypes;
    procedure UpdateUI;
  public
    property ConfigType: TConfigType read FConfigType write SetConfigType;
    property ConfigName: string read FConfigName write FConfigName;
    property ConfigValue: string read GetConfigValue write FConfigValue;
  end;

var
  frmSimpleEditor: TfrmSimpleEditor;

implementation

procedure TfrmSimpleEditor.FormCreate(Sender: TObject);
begin
  // 初始化配置类型
  InitializeConfigTypes;

  FConfigType := etText; // 默认类型为文本
  FConfigName := '';
  FConfigValue := '';
  FEditorControl := nil;

  UpdateUI;
end;

procedure TfrmSimpleEditor.FormShow(Sender: TObject);
begin
  // 更新UI
  edtName.Text := FConfigName;

  // 如果配置名称不为空且包含点号，则尝试设置类型
  if (FConfigName <> '') and (Pos('.', FConfigName) > 0) then
  begin
    var TypeStr := Copy(FConfigName, 1, Pos('.', FConfigName) - 1);
    FConfigType := StringToConfigType(TypeStr);

    // 设置类型到下拉框
    for var i := 0 to cbbConfigType.Items.Count - 1 do
    begin
      if SameText(cbbConfigType.Items[i], ConfigTypeToString(FConfigType)) then
      begin
        cbbConfigType.ItemIndex := i;
        Break;
      end;
    end;
  end;

  // 创建编辑控件
  CreateEditorControl;

  // 设置编辑控件的值
  if Assigned(FEditorControl) then
  begin
    if FEditorControl is TEdit then
      TEdit(FEditorControl).Text := FConfigValue
    else if FEditorControl is TCheckBox then
      TCheckBox(FEditorControl).Checked := SameText(FConfigValue, 'true') or SameText(FConfigValue, '1')
    else if FEditorControl is TComboBox then
    begin
      var Combo := TComboBox(FEditorControl);
      var Values := FConfigValue.Split([',']);
      Combo.Items.Clear;
      for var i := 0 to Length(Values) - 1 do
        Combo.Items.Add(Values[i]);

      if Combo.Items.Count > 0 then
        Combo.ItemIndex := 0;
    end
    else if FEditorControl is TColorBox then
      TColorBox(FEditorControl).Selected := StringToColor(FConfigValue)
    else if FEditorControl is TDateTimePicker then
    begin
      if FConfigType = etDateTime then
        TDateTimePicker(FEditorControl).DateTime := StrToDateTimeDef(FConfigValue, Now)
      else // etTimeSpan
        TDateTimePicker(FEditorControl).Time := StrToTimeDef(FConfigValue, 0);
    end
    else if FEditorControl is TMemo then
      TMemo(FEditorControl).Text := FConfigValue;
  end;
end;

procedure TfrmSimpleEditor.InitializeConfigTypes;
begin
  cbbConfigType.Items.Clear;

  // 添加支持的配置类型
  cbbConfigType.Items.Add(ConfigTypeToString(etText));
  cbbConfigType.Items.Add(ConfigTypeToString(etNumber));
  cbbConfigType.Items.Add(ConfigTypeToString(etBoolean));
  cbbConfigType.Items.Add(ConfigTypeToString(etEnum));
  cbbConfigType.Items.Add(ConfigTypeToString(etColor));
  cbbConfigType.Items.Add(ConfigTypeToString(etDateTime));
  cbbConfigType.Items.Add(ConfigTypeToString(etTimeSpan));
  cbbConfigType.Items.Add(ConfigTypeToString(etFile));
  cbbConfigType.Items.Add(ConfigTypeToString(etPath));

  cbbConfigType.ItemIndex := 0; // 默认选中第一个类型
end;

procedure TfrmSimpleEditor.SetConfigType(const Value: TConfigType);
begin
  if FConfigType <> Value then
  begin
    FConfigType := Value;

    // 更新下拉框的选中项
    for var i := 0 to cbbConfigType.Items.Count - 1 do
    begin
      if SameText(cbbConfigType.Items[i], ConfigTypeToString(FConfigType)) then
      begin
        cbbConfigType.ItemIndex := i;
        Break;
      end;
    end;

    CreateEditorControl;
  end;
end;

procedure TfrmSimpleEditor.cbbConfigTypeChange(Sender: TObject);
var
  TypeStr: string;
begin
  if cbbConfigType.ItemIndex >= 0 then
  begin
    TypeStr := cbbConfigType.Items[cbbConfigType.ItemIndex];
    FConfigType := StringToConfigType(TypeStr);

    // 重新创建编辑控件
    CreateEditorControl;
  end;
end;

procedure TfrmSimpleEditor.CreateEditorControl;
begin
  // 释放旧的编辑控件
  if Assigned(FEditorControl) then
  begin
    FEditorControl.Free;
    FEditorControl := nil;
  end;

  // 根据配置类型创建对应的编辑控件
  case FConfigType of
    etText:
      begin
        var Edit := TEdit.Create(pnlType);
        Edit.Parent := pnlType;
        Edit.Align := alClient;
        FEditorControl := Edit;
      end;

    etNumber:
      begin
        var Edit := TEdit.Create(pnlType);
        Edit.Parent := pnlType;
        Edit.Align := alClient;
        Edit.NumbersOnly := True;
        FEditorControl := Edit;
      end;

    etBoolean:
      begin
        var Check := TCheckBox.Create(pnlType);
        Check.Parent := pnlType;
        Check.Align := alClient;
        Check.Caption := '';
        FEditorControl := Check;
      end;

    etEnum:
      begin
        var Combo := TComboBox.Create(pnlType);
        Combo.Parent := pnlType;
        Combo.Align := alClient;
        FEditorControl := Combo;
      end;

    etColor:
      begin
        var ColorBox := TColorBox.Create(pnlType);
        ColorBox.Parent := pnlType;
        ColorBox.Align := alClient;
        FEditorControl := ColorBox;
      end;

    etDateTime:
      begin
        var DatePicker := TDateTimePicker.Create(pnlType);
        DatePicker.Parent := pnlType;
        DatePicker.Align := alClient;
        DatePicker.Kind := dtkDate;
        DatePicker.Width := 120;
        FEditorControl := DatePicker;
      end;

    etTimeSpan:
      begin
        var TimePicker := TDateTimePicker.Create(pnlType);
        TimePicker.Parent := pnlType;
        TimePicker.Align := alClient;
        TimePicker.Kind := dtkTime;
        TimePicker.Width := 120;
        FEditorControl := TimePicker;
      end;

    etFile, etPath:
      begin
        var Panel := TPanel.Create(pnlType);
        Panel.Parent := pnlType;
        Panel.Align := alClient;
        Panel.BevelOuter := bvNone;

        var Edit := TEdit.Create(Panel);
        Edit.Parent := Panel;
        Edit.Align := alClient;

        var Button := TButton.Create(Panel);
        Button.Parent := Panel;
        Button.Align := alRight;
        Button.Width := 25;
        Button.Caption := '...';

        FEditorControl := Panel;
      end;

    else
      begin
        var Memo := TMemo.Create(pnlType);
        Memo.Parent := pnlType;
        Memo.Align := alClient;
        Memo.ScrollBars := ssBoth;
        FEditorControl := Memo;
      end;
  end;
end;

function TfrmSimpleEditor.GetConfigValue: string;
begin
  Result := FConfigValue;

  if not Assigned(FEditorControl) then
    Exit;

  // 根据编辑控件的类型获取值
  if FEditorControl is TEdit then
    Result := TEdit(FEditorControl).Text
  else if FEditorControl is TCheckBox then
    Result := BoolToStr(TCheckBox(FEditorControl).Checked, True)
  else if FEditorControl is TComboBox then
    begin
    var Combo := TComboBox(FEditorControl);
    Result := '';
    for var i := 0 to Combo.Items.Count - 1 do
    begin
      if i > 0 then
        Result := Result + ',';
      Result := Result + Combo.Items[i];
    end;
  end
  else if FEditorControl is TColorBox then
    Result := ColorToString(TColorBox(FEditorControl).Selected)
  else if FEditorControl is TDateTimePicker then
  begin
    if FConfigType = etDateTime then
      Result := DateTimeToStr(TDateTimePicker(FEditorControl).DateTime)
    else // etTimeSpan
      Result := TimeToStr(TDateTimePicker(FEditorControl).Time);
  end
  else if FEditorControl is TPanel then
  begin
    // 遍历面板中的控件
    for var i := 0 to TPanel(FEditorControl).ControlCount - 1 do
    begin
      if TPanel(FEditorControl).Controls[i] is TEdit then
      begin
        Result := TEdit(TPanel(FEditorControl).Controls[i]).Text;
        Break;
      end;
    end;
  end
  else if FEditorControl is TMemo then
    Result := TMemo(FEditorControl).Text;
end;

procedure TfrmSimpleEditor.UpdateUI;
begin
  // 更新标题
  case FConfigType of
    etText: grpValue.Caption := '文本值';
    etNumber: grpValue.Caption := '数值';
    etBoolean: grpValue.Caption := '布尔值';
    etEnum: grpValue.Caption := '枚举值';
    etColor: grpValue.Caption := '颜色';
    etDateTime: grpValue.Caption := '日期时间';
    etTimeSpan: grpValue.Caption := '时间跨度';
    etFile: grpValue.Caption := '文件路径';
    etPath: grpValue.Caption := '目录路径';
    else grpValue.Caption := '值';
  end;
end;

procedure TfrmSimpleEditor.btnOKClick(Sender: TObject);
begin
  // 验证输入
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('请输入配置名称');
    edtName.SetFocus;
    Exit;
  end;

  // 保存值
  FConfigName := edtName.Text;
  FConfigValue := GetConfigValue;

  // 如果名称中没有点号，则自动添加类型前缀
  if Pos('.', FConfigName) = 0 then
    FConfigName := ConfigTypeToString(FConfigType) + '.' + FConfigName;

  ModalResult := mrOk;
end;

procedure TfrmSimpleEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

