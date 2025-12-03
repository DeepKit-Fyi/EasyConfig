unit FrameSimpleEditorFMX;
{*******************************************************************************
  简单属性编辑器 Frame (FMX)
  - 支持 String, Integer, Float, Boolean, Color, Path 类型
  - 可嵌入主窗体或作为弹出对话框使用
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.EditBox,
  FMX.SpinBox, FMX.Colors,
  UtilsTypesFMX, ConfigFrameBaseFMX;

type
  TSimpleValueType = (svtString, svtInteger, svtFloat, svtBoolean, svtColor, svtPath);

  TFrameSimpleEditorFMX = class(TFrame)
    layMain: TLayout;
    layName: TLayout;
    lblName: TLabel;
    edtName: TEdit;
    layType: TLayout;
    lblType: TLabel;
    cboType: TComboBox;
    layValue: TLayout;
    lblValue: TLabel;
    layValueEdit: TLayout;
    edtValue: TEdit;
    spnValue: TSpinBox;
    chkValue: TCheckBox;
    cboColor: TColorComboBox;
    layPathValue: TLayout;
    edtPath: TEdit;
    btnBrowse: TButton;
    layButtons: TLayout;
    btnOK: TButton;
    btnCancel: TButton;
    procedure cboTypeChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FValueType: TSimpleValueType;
    FOnOK: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    procedure SetValueType(AType: TSimpleValueType);
    procedure UpdateValueControls;
  public
    constructor Create(AOwner: TComponent); override;

    // 设置/获取属性名
    procedure SetPropertyName(const AName: string);
    function GetPropertyName: string;

    // 设置/获取属性值
    procedure SetValue(const AValue: string);
    function GetValue: string;

    // 设置/获取类型
    property ValueType: TSimpleValueType read FValueType write SetValueType;

    // 事件
    property OnOK: TNotifyEvent read FOnOK write FOnOK;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    
    // 验证
    function ValidateInput: Boolean;
    function GetValidationError: string;
  end;

  // 简单属性验证器
  TSimpleValueValidator = class
  public
    class function ValidateInteger(const AValue: string; out AError: string): Boolean;
    class function ValidateFloat(const AValue: string; out AError: string): Boolean;
    class function ValidateBoolean(const AValue: string; out AError: string): Boolean;
    class function ValidateColor(const AValue: string; out AError: string): Boolean;
    class function ValidatePath(const AValue: string; out AError: string): Boolean;
    class function ValidateValue(AType: TSimpleValueType; const AValue: string; 
      out AError: string): Boolean;
  end;

implementation

{$R *.fmx}

{ TFrameSimpleEditorFMX }

constructor TFrameSimpleEditorFMX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // 初始化类型下拉列表
  cboType.Items.Clear;
  cboType.Items.Add('字符串');
  cboType.Items.Add('整数');
  cboType.Items.Add('浮点数');
  cboType.Items.Add('布尔值');
  cboType.Items.Add('颜色');
  cboType.Items.Add('路径');
  cboType.ItemIndex := 0;

  FValueType := svtString;
  UpdateValueControls;
end;

procedure TFrameSimpleEditorFMX.SetValueType(AType: TSimpleValueType);
begin
  FValueType := AType;
  cboType.ItemIndex := Ord(AType);
  UpdateValueControls;
end;

procedure TFrameSimpleEditorFMX.UpdateValueControls;
begin
  // 隐藏所有编辑控件
  edtValue.Visible := False;
  spnValue.Visible := False;
  chkValue.Visible := False;
  cboColor.Visible := False;
  layPathValue.Visible := False;

  // 根据类型显示对应控件
  case FValueType of
    svtString:
      begin
        edtValue.Visible := True;
        edtValue.Align := TAlignLayout.Client;
      end;
    svtInteger:
      begin
        spnValue.Visible := True;
        spnValue.Align := TAlignLayout.Left;
        spnValue.DecimalDigits := 0;
        spnValue.Min := -MaxInt;
        spnValue.Max := MaxInt;
      end;
    svtFloat:
      begin
        spnValue.Visible := True;
        spnValue.Align := TAlignLayout.Left;
        spnValue.DecimalDigits := 4;
        spnValue.Min := -1e10;
        spnValue.Max := 1e10;
      end;
    svtBoolean:
      begin
        chkValue.Visible := True;
        chkValue.Align := TAlignLayout.Left;
      end;
    svtColor:
      begin
        cboColor.Visible := True;
        cboColor.Align := TAlignLayout.Left;
      end;
    svtPath:
      begin
        layPathValue.Visible := True;
        layPathValue.Align := TAlignLayout.Client;
      end;
  end;
end;

procedure TFrameSimpleEditorFMX.cboTypeChange(Sender: TObject);
begin
  if cboType.ItemIndex >= 0 then
    SetValueType(TSimpleValueType(cboType.ItemIndex));
end;

procedure TFrameSimpleEditorFMX.btnBrowseClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Filter := '所有文件 (*.*)|*.*';
    if edtPath.Text <> '' then
      Dlg.FileName := edtPath.Text;
    if Dlg.Execute then
      edtPath.Text := Dlg.FileName;
  finally
    Dlg.Free;
  end;
end;

procedure TFrameSimpleEditorFMX.btnOKClick(Sender: TObject);
begin
  if Assigned(FOnOK) then
    FOnOK(Self);
end;

procedure TFrameSimpleEditorFMX.btnCancelClick(Sender: TObject);
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

procedure TFrameSimpleEditorFMX.SetPropertyName(const AName: string);
begin
  edtName.Text := AName;
end;

function TFrameSimpleEditorFMX.GetPropertyName: string;
begin
  Result := edtName.Text;
end;

procedure TFrameSimpleEditorFMX.SetValue(const AValue: string);
begin
  case FValueType of
    svtString:
      edtValue.Text := AValue;
    svtInteger:
      spnValue.Value := StrToIntDef(AValue, 0);
    svtFloat:
      spnValue.Value := StrToFloatDef(AValue, 0);
    svtBoolean:
      chkValue.IsChecked := SameText(AValue, 'true') or (AValue = '1');
    svtColor:
      cboColor.Color := StringToAlphaColor(AValue);
    svtPath:
      edtPath.Text := AValue;
  end;
end;

function TFrameSimpleEditorFMX.GetValue: string;
begin
  case FValueType of
    svtString:
      Result := edtValue.Text;
    svtInteger:
      Result := IntToStr(Round(spnValue.Value));
    svtFloat:
      Result := FloatToStr(spnValue.Value);
    svtBoolean:
      if chkValue.IsChecked then
        Result := 'true'
      else
        Result := 'false';
    svtColor:
      Result := AlphaColorToString(cboColor.Color);
    svtPath:
      Result := edtPath.Text;
  else
    Result := '';
  end;
end;

function TFrameSimpleEditorFMX.ValidateInput: Boolean;
var
  ErrorMsg: string;
begin
  Result := TSimpleValueValidator.ValidateValue(FValueType, GetValue, ErrorMsg);
end;

function TFrameSimpleEditorFMX.GetValidationError: string;
begin
  TSimpleValueValidator.ValidateValue(FValueType, GetValue, Result);
end;

{ TSimpleValueValidator }

class function TSimpleValueValidator.ValidateInteger(const AValue: string; 
  out AError: string): Boolean;
var
  IntVal: Integer;
begin
  Result := TryStrToInt(AValue, IntVal);
  if not Result then
    AError := '无效的整数值: ' + AValue
  else
    AError := '';
end;

class function TSimpleValueValidator.ValidateFloat(const AValue: string; 
  out AError: string): Boolean;
var
  FloatVal: Double;
begin
  Result := TryStrToFloat(AValue, FloatVal);
  if not Result then
    AError := '无效的浮点数值: ' + AValue
  else
    AError := '';
end;

class function TSimpleValueValidator.ValidateBoolean(const AValue: string; 
  out AError: string): Boolean;
var
  LowerVal: string;
begin
  LowerVal := LowerCase(AValue);
  Result := (LowerVal = 'true') or (LowerVal = 'false') or 
            (LowerVal = '1') or (LowerVal = '0') or
            (LowerVal = 'yes') or (LowerVal = 'no');
  if not Result then
    AError := '无效的布尔值: ' + AValue + ' (应为 true/false/1/0/yes/no)'
  else
    AError := '';
end;

class function TSimpleValueValidator.ValidateColor(const AValue: string; 
  out AError: string): Boolean;
var
  ColorStr: string;
begin
  Result := True;
  AError := '';
  
  if AValue = '' then
    Exit;
    
  ColorStr := AValue;
  if ColorStr.StartsWith('#') then
    ColorStr := ColorStr.Substring(1);
    
  // 检查是否为有效的十六进制颜色
  if (Length(ColorStr) <> 6) and (Length(ColorStr) <> 3) and (Length(ColorStr) <> 8) then
  begin
    Result := False;
    AError := '无效的颜色格式: ' + AValue + ' (应为 #RRGGBB 或 #RGB)';
  end;
end;

class function TSimpleValueValidator.ValidatePath(const AValue: string; 
  out AError: string): Boolean;
begin
  Result := True;
  AError := '';
  
  // 路径可以为空
  if AValue = '' then
    Exit;
    
  // 检查路径中是否包含非法字符
  if (Pos('<', AValue) > 0) or (Pos('>', AValue) > 0) or
     (Pos('|', AValue) > 0) or (Pos('"', AValue) > 0) then
  begin
    Result := False;
    AError := '路径包含非法字符: < > | "';
  end;
end;

class function TSimpleValueValidator.ValidateValue(AType: TSimpleValueType; 
  const AValue: string; out AError: string): Boolean;
begin
  case AType of
    svtString:
      begin
        Result := True;
        AError := '';
      end;
    svtInteger:
      Result := ValidateInteger(AValue, AError);
    svtFloat:
      Result := ValidateFloat(AValue, AError);
    svtBoolean:
      Result := ValidateBoolean(AValue, AError);
    svtColor:
      Result := ValidateColor(AValue, AError);
    svtPath:
      Result := ValidatePath(AValue, AError);
  else
    Result := True;
    AError := '';
  end;
end;

end.
