unit CreateConfigItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.UITypes;

type
  // 配置项类型枚举
  TConfigItemType = (
    // 简单属性类型
    citSection,    // 节
    citText,       // 文本
    citInteger,    // 整数
    citFloat,      // 小数
    citBoolean,    // 布尔值
    citDateTime,   // 日期时间
    citColor,      // 颜色
    
    // 特殊编辑器类型
    citSpecialBase = 100, // 特殊编辑器基础值
    citFont,       // 字体编辑器
    citPosition,   // 位置编辑器
    citBackground, // 背景编辑器
    citDatabase,   // 数据库连接编辑器
    citPath,       // 路径编辑器
    citSpecialMax = 199  // 特殊编辑器最大值
  );

  // 配置项创建结构
  TConfigItemCreateResult = record
    Success: Boolean;            // 是否成功
    ItemType: TConfigItemType;   // 项目类型
    Name: string;                // 项目名称
    Value: string;               // 项目值(简单类型)
    Section: string;             // 所属节(如适用)
    Description: string;         // 描述信息
    SpecialParams: TStringList;  // 特殊参数(用于专项编辑器)
    
    // 构造和清理
    class function CreateSimple(ItemType: TConfigItemType; const AName, AValue: string; 
      const ASection: string = ''): TConfigItemCreateResult; static;
    class function CreateSpecial(ItemType: TConfigItemType; const AName: string; 
      AParams: TStringList = nil): TConfigItemCreateResult; static;
    
    procedure Clear;
  end;

  TCreateConfigItemForm = class(TForm)
    pgcMain: TPageControl;
    tsSimple: TTabSheet;
    tsSpecial: TTabSheet;
    rgSimpleType: TRadioGroup;
    lblName: TLabel;
    edtName: TEdit;
    lblValue: TLabel;
    edtValue: TEdit;
    lblSection: TLabel;
    edtSection: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    rgSpecialType: TRadioGroup;
    pnlSpecialParams: TPanel;
    lblSpecialName: TLabel;
    edtSpecialName: TEdit;
    pnlButtons: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure rgSimpleTypeClick(Sender: TObject);
    procedure rgSpecialTypeClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FSpecialParams: TStringList;
    
    procedure UpdateControls;
    procedure UpdateSpecialPanel;
    function ValidateInput: Boolean;
    function GetSelectedSimpleType: TConfigItemType;
    function GetSelectedSpecialType: TConfigItemType;
    function GetIsSectionType: Boolean;
  public
    function GetResult: TConfigItemCreateResult;
    
    // 璁剧疆鍒濆鍙傛暟
    procedure SetInitialType(ItemType: TConfigItemType);
    procedure SetSection(const ASection: string);
  end;

var
  CreateConfigItemForm: TCreateConfigItemForm;

implementation

{$R *.dfm}

{ TCreateConfigItemForm }

procedure TCreateConfigItemForm.FormCreate(Sender: TObject);
begin
  // 初始化特殊参数列表
  FSpecialParams := TStringList.Create;
  
  // 初始化无线电组
  rgSimpleType.Items.Clear;
  rgSimpleType.Items.Add(string('节'));
  rgSimpleType.Items.Add(string('文本'));
  rgSimpleType.Items.Add(string('整数'));
  rgSimpleType.Items.Add(string('小数'));
  rgSimpleType.Items.Add(string('布尔值'));
  rgSimpleType.Items.Add(string('日期时间'));
  rgSimpleType.Items.Add(string('颜色'));
  rgSimpleType.ItemIndex := 0;
  
  rgSpecialType.Items.Clear;
  rgSpecialType.Items.Add(string('字体编辑器'));
  rgSpecialType.Items.Add(string('位置编辑器'));
  rgSpecialType.Items.Add(string('背景编辑器'));
  rgSpecialType.Items.Add(string('数据库连接编辑器'));
  rgSpecialType.Items.Add(string('路径编辑器'));
  rgSpecialType.ItemIndex := 0;
  
  // 初始化默认页面为简单属性
  pgcMain.ActivePage := tsSimple;
  
  // 更新控件状态
  UpdateControls;
end;

procedure TCreateConfigItemForm.FormDestroy(Sender: TObject);
begin
  // 释放特殊参数列表
  if Assigned(FSpecialParams) then
    FreeAndNil(FSpecialParams);
end;

procedure TCreateConfigItemForm.FormShow(Sender: TObject);
begin
  // 设置初始焦点
  if GetIsSectionType then
    edtName.SetFocus
  else
  begin
    if pgcMain.ActivePage = tsSimple then
    begin
      if edtSection.Enabled and (edtSection.Text = '') then
        edtSection.SetFocus
      else
        edtName.SetFocus;
    end
    else
    begin
      edtSpecialName.SetFocus;
    end;
  end;
end;

function TCreateConfigItemForm.GetIsSectionType: Boolean;
begin
  Result := (pgcMain.ActivePage = tsSimple) and (rgSimpleType.ItemIndex = 0);
end;

function TCreateConfigItemForm.GetResult: TConfigItemCreateResult;
begin
  if pgcMain.ActivePage = tsSimple then
  begin
    // 创建简单类型结构
    Result := TConfigItemCreateResult.CreateSimple(
      GetSelectedSimpleType,
      edtName.Text,
      edtValue.Text,
      edtSection.Text
    );
    Result.Description := edtDescription.Text;
  end
  else
  begin
    // 创建特殊类型结果
    Result := TConfigItemCreateResult.CreateSpecial(
      GetSelectedSpecialType,
      edtSpecialName.Text,
      FSpecialParams
    );
    Result.Description := edtDescription.Text;
  end;
end;

function TCreateConfigItemForm.GetSelectedSimpleType: TConfigItemType;
begin
  case rgSimpleType.ItemIndex of
    0: Result := citSection;
    1: Result := citText;
    2: Result := citInteger;
    3: Result := citFloat;
    4: Result := citBoolean;
    5: Result := citDateTime;
    6: Result := citColor;
    else Result := citText; // 默认为文本
  end;
end;

function TCreateConfigItemForm.GetSelectedSpecialType: TConfigItemType;
begin
  case rgSpecialType.ItemIndex of
    0: Result := citFont;
    1: Result := citPosition;
    2: Result := citBackground;
    3: Result := citDatabase;
    4: Result := citPath;
    else Result := citFont; // 默认为字体编辑器
  end;
end;

procedure TCreateConfigItemForm.pgcMainChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TCreateConfigItemForm.rgSimpleTypeClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TCreateConfigItemForm.rgSpecialTypeClick(Sender: TObject);
begin
  UpdateSpecialPanel;
end;

procedure TCreateConfigItemForm.SetInitialType(ItemType: TConfigItemType);
begin
  // 根据项目类型设置初始页面和选择
  if ItemType < citSpecialBase then
  begin
    // 简单类型
    pgcMain.ActivePage := tsSimple;
    
    // 设置简单类型的选择
    case ItemType of
      citSection:  rgSimpleType.ItemIndex := 0;
      citText:     rgSimpleType.ItemIndex := 1;
      citInteger:  rgSimpleType.ItemIndex := 2;
      citFloat:    rgSimpleType.ItemIndex := 3;
      citBoolean:  rgSimpleType.ItemIndex := 4;
      citDateTime: rgSimpleType.ItemIndex := 5;
      citColor:    rgSimpleType.ItemIndex := 6;
      else rgSimpleType.ItemIndex := 0;
    end;
  end
  else
  begin
    // 特殊类型
    pgcMain.ActivePage := tsSpecial;
    
    // 设置特殊类型的选择
    case ItemType of
      citFont:      rgSpecialType.ItemIndex := 0;
      citPosition:  rgSpecialType.ItemIndex := 1;
      citBackground:rgSpecialType.ItemIndex := 2;
      citDatabase:  rgSpecialType.ItemIndex := 3;
      citPath:      rgSpecialType.ItemIndex := 4;
      else rgSpecialType.ItemIndex := 0;
    end;
  end;
  
  // 更新控件状态
  UpdateControls;
end;

procedure TCreateConfigItemForm.SetSection(const ASection: string);
begin
  edtSection.Text := ASection;
end;

procedure TCreateConfigItemForm.UpdateControls;
var
  IsSimple: Boolean;
  IsSection: Boolean;
begin
  // 获取当前页面类型
  IsSimple := pgcMain.ActivePage = tsSimple;
  
  // 显示/隐藏简单类型属性控件
  lblName.Visible := IsSimple;
  edtName.Visible := IsSimple;
  lblValue.Visible := IsSimple;
  edtValue.Visible := IsSimple;
  lblSection.Visible := IsSimple;
  edtSection.Visible := IsSimple;
  
  // 显示/隐藏特殊类型属性控件
  lblSpecialName.Visible := not IsSimple;
  edtSpecialName.Visible := not IsSimple;
  pnlSpecialParams.Visible := not IsSimple;
  
  // 如果是简单类型，更新值输入框的状态
  if IsSimple then
  begin
    IsSection := rgSimpleType.ItemIndex = 0; // 是否为节类型
    
    // 节类型不需要值和节名称
    lblValue.Enabled := not IsSection;
    edtValue.Enabled := not IsSection;
    
    // 如果是节，则不需要指定所属节
    lblSection.Enabled := not IsSection;
    edtSection.Enabled := not IsSection;
    
    // 根据类型设置默认值提示
    case rgSimpleType.ItemIndex of
      0: edtValue.TextHint := string(''); // 节不需要值
      1: edtValue.TextHint := string('请输入文本值');
      2: edtValue.TextHint := string('请输入整数值');
      3: edtValue.TextHint := string('请输入小数值');
      4: edtValue.TextHint := string('True 或 False');
      5: edtValue.TextHint := string('YYYY-MM-DD HH:NN:SS');
      6: edtValue.TextHint := string('clRed, #FF0000 或 $00FF0000');
    end;
  end
  else
  begin
    // 更新特殊类型面板
    UpdateSpecialPanel;
  end;
end;

procedure TCreateConfigItemForm.UpdateSpecialPanel;
begin
  // 根据选择的特殊类型更新参数面板
  // 这里可以根据不同的特殊类型动态创建不同的控件
  // 暂时仅显示基本信息
  pnlSpecialParams.Caption := Format('已选择: %s', [rgSpecialType.Items[rgSpecialType.ItemIndex]]);
end;

function TCreateConfigItemForm.ValidateInput: Boolean;
var
  ErrorMsg: string;
  IsSection: Boolean;
  IntValue: Integer;
  FloatValue: Double;
begin
  Result := True;
  ErrorMsg := '';
  
  // 验证简单类型输入
  if pgcMain.ActivePage = tsSimple then
  begin
    IsSection := rgSimpleType.ItemIndex = 0;
    
    // 名称必须填写
    if edtName.Text = '' then
    begin
      ErrorMsg := string('请输入名称');
      edtName.SetFocus;
      Result := False;
    end
    // 如果不是节，且需要值，则验证值
    else if (not IsSection) and (edtValue.Text = '') then
    begin
      ErrorMsg := string('请输入值');
      edtValue.SetFocus;
      Result := False;
    end
    // 如果不是节，则需要指定所属节
    else if (not IsSection) and (edtSection.Text = '') then
    begin
      ErrorMsg := string('请指定所属节');
      edtSection.SetFocus;
      Result := False;
    end
    // 验证数值类型
    else if (rgSimpleType.ItemIndex = 2) and not TryStrToInt(string(edtValue.Text), IntValue) then
    begin
      ErrorMsg := string('请输入有效的整数值');
      edtValue.SetFocus;
      Result := False;
    end
    else if (rgSimpleType.ItemIndex = 3) and not TryStrToFloat(string(edtValue.Text), FloatValue) then
    begin
      ErrorMsg := string('请输入有效的小数值');
      edtValue.SetFocus;
      Result := False;
    end
    else if (rgSimpleType.ItemIndex = 4) and 
            (not SameText(string(edtValue.Text), 'True') and not SameText(string(edtValue.Text), 'False')) then
    begin
      ErrorMsg := string('布尔值必须为 True 或 False');
      edtValue.SetFocus;
      Result := False;
    end;
  end
  else
  begin
    // 验证特殊类型输入
    if edtSpecialName.Text = '' then
    begin
      ErrorMsg := string('请输入名称');
      edtSpecialName.SetFocus;
      Result := False;
    end;
    
    // 这里可以添加特殊类型的其他验证
  end;
  
  // 显示错误消息
  if not Result then
    MessageDlg(ErrorMsg, mtError, [mbOK], 0);
end;

procedure TCreateConfigItemForm.btnOKClick(Sender: TObject);
begin
  // 验证输入
  if ValidateInput then
    ModalResult := mrOk
  else
    ModalResult := mrNone;
end;

{ TConfigItemCreateResult }

class function TConfigItemCreateResult.CreateSimple(ItemType: TConfigItemType; 
  const AName, AValue, ASection: string): TConfigItemCreateResult;
begin
  Result.Success := True;
  Result.ItemType := ItemType;
  Result.Name := AName;
  Result.Value := AValue;
  Result.Section := ASection;
  Result.Description := '';
  Result.SpecialParams := nil;
end;

class function TConfigItemCreateResult.CreateSpecial(ItemType: TConfigItemType; 
  const AName: string; AParams: TStringList): TConfigItemCreateResult;
begin
  Result.Success := True;
  Result.ItemType := ItemType;
  Result.Name := AName;
  Result.Value := '';
  Result.Section := '';
  Result.Description := '';
  
  // 复制特殊参数
  if Assigned(AParams) then
  begin
    Result.SpecialParams := TStringList.Create;
    Result.SpecialParams.Assign(AParams);
  end
  else
    Result.SpecialParams := nil;
end;

procedure TConfigItemCreateResult.Clear;
begin
  Success := False;
  ItemType := citText;
  Name := '';
  Value := '';
  Section := '';
  Description := '';
  
  if Assigned(SpecialParams) then
    FreeAndNil(SpecialParams);
end;

end. 