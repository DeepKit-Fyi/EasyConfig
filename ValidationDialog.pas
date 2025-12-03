unit ValidationDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections, Vcl.ImgList, Vcl.Buttons,
  ConfigValidator, System.Math;

type
  // 验证结果严重程度
  TValidationSeverity = (vsInfo, vsWarning, vsError);

  // 验证结果
  TValidationResult = class
  public
    PropertyPath: string;
    PropertyName: string;
    Message: string;
    Severity: TValidationSeverity;
    FixSuggestion: string;
    CanAutoFix: Boolean;
    constructor Create(const APath, AName, AMessage: string; ASeverity: TValidationSeverity; 
                       const AFixSuggestion: string = ''; ACanAutoFix: Boolean = False);
  end;

  TValidationResultList = class(TObjectList<TValidationResult>)
  public
    procedure AddError(const PropertyPath, PropertyName, ErrorMessage: string);
    procedure AddErrorWithFix(const PropertyPath, PropertyName, ErrorMessage, FixSuggestion: string; CanAutoFix: Boolean);
  end;

  TSelectPropertyEvent = procedure(const Path, Name: string) of object;
  TFixPropertyEvent = procedure(const Path, Name: string) of object;

  TfrmValidation = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    pnlBottom: TPanel;
    btnClose: TButton;
    pnlClient: TPanel;
    lvErrors: TListView;
    ImageList: TImageList;
    btnFixAll: TButton;
    btnHelp: TButton;
    splHelp: TSplitter;
    pnlHelp: TPanel;
    memoHelp: TMemo;
    lblFixSuggestion: TLabel;
    btnFixCurrent: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvErrorsDblClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lvErrorsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnFixCurrentClick(Sender: TObject);
    procedure btnFixAllClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FResults: TValidationResultList;
    FOnSelectProperty: TSelectPropertyEvent;
    FOnFixProperty: TFixPropertyEvent;
    
    procedure UpdateList;
    procedure UpdateHelp;
    function HasAutoFixableErrors: Boolean;
  public
    procedure ShowResults(Results: TValidationResultList);
    
    property OnSelectProperty: TSelectPropertyEvent read FOnSelectProperty write FOnSelectProperty;
    property OnFixProperty: TFixPropertyEvent read FOnFixProperty write FOnFixProperty;
  end;

var
  frmValidation: TfrmValidation;

implementation

{$R *.dfm}

{ TValidationResult }

constructor TValidationResult.Create(const APath, AName, AMessage: string; ASeverity: TValidationSeverity;
                                    const AFixSuggestion: string; ACanAutoFix: Boolean);
begin
  PropertyPath := APath;
  PropertyName := AName;
  Message := AMessage;
  Severity := ASeverity;
  FixSuggestion := AFixSuggestion;
  CanAutoFix := ACanAutoFix;
end;

{ TValidationResultList }

procedure TValidationResultList.AddError(const PropertyPath, PropertyName, ErrorMessage: string);
begin
  Add(TValidationResult.Create(PropertyPath, PropertyName, ErrorMessage, vsError));
end;

procedure TValidationResultList.AddErrorWithFix(const PropertyPath, PropertyName, ErrorMessage, FixSuggestion: string; CanAutoFix: Boolean);
begin
  Add(TValidationResult.Create(PropertyPath, PropertyName, ErrorMessage, vsError, FixSuggestion, CanAutoFix));
end;

{ TfrmValidation }

procedure TfrmValidation.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmValidation.btnFixAllClick(Sender: TObject);
var
  I: Integer;
  Item: TValidationResult;
begin
  if not Assigned(FResults) or not Assigned(FOnFixProperty) then
    Exit;
    
  // 尝试修复所有可自动修复的问题
  for I := 0 to FResults.Count - 1 do
  begin
    Item := FResults[I];
    if Item.CanAutoFix then
      FOnFixProperty(Item.PropertyPath, Item.PropertyName);
  end;
  
  // 更新列表
  UpdateList;
  
  ShowMessage('已尝试自动修复所有可修复的错误，请检查结果。');
end;

procedure TfrmValidation.btnFixCurrentClick(Sender: TObject);
var
  SelectedItem: TListItem;
  Item: TValidationResult;
begin
  if (lvErrors.Selected = nil) or not Assigned(FOnFixProperty) then
    Exit;
    
  SelectedItem := lvErrors.Selected;
  Item := TValidationResult(SelectedItem.Data);
  
  // 尝试修复
  if Item.CanAutoFix then
  begin
    FOnFixProperty(Item.PropertyPath, Item.PropertyName);
    ShowMessage('已尝试修复问题，请检查结果。');
  end
  else
    ShowMessage('此问题无法自动修复，请按照修复建议手动修正。');
end;

procedure TfrmValidation.btnHelpClick(Sender: TObject);
begin
  pnlHelp.Visible := not pnlHelp.Visible;
  if pnlHelp.Visible then
    btnHelp.Caption := '隐藏帮助 <<'
  else
    btnHelp.Caption := '显示帮助 >>';
end;

procedure TfrmValidation.FormCreate(Sender: TObject);
begin
  // 初始化ListView
  with lvErrors do
  begin
    ViewStyle := vsReport;
    
    // 添加列
    with Columns.Add do
    begin
      Caption := '严重性';
      Width := 80;
    end;
    
    with Columns.Add do
    begin
      Caption := '属性路径';
      Width := 200;
    end;
    
    with Columns.Add do
    begin
      Caption := '属性名称';
      Width := 150;
    end;
    
    with Columns.Add do
    begin
      Caption := '错误信息';
      Width := 300;
    end;
    
    with Columns.Add do
    begin
      Caption := '可修复';
      Width := 60;
      Alignment := taCenter;
    end;
  end;
  
  // 初始化帮助面板
  pnlHelp.Visible := False;
  btnHelp.Caption := '显示帮助 >>';
  
  // 创建图像列表
  ImageList.Width := 16;
  ImageList.Height := 16;
  // 添加图标 - 实际应用中应加载实际图标
  ImageList.AddIcon(Application.Icon); // 信息图标 - 移除 with...do;
  ImageList.AddIcon(Application.Icon); // 警告图标 - 移除 with...do;
  ImageList.AddIcon(Application.Icon); // 错误图标 - 移除 with...do;
  
  lvErrors.SmallImages := ImageList;
end;

procedure TfrmValidation.lvErrorsDblClick(Sender: TObject);
var
  SelectedItem: TListItem;
  Item: TValidationResult;
begin
  if (lvErrors.Selected = nil) or not Assigned(FOnSelectProperty) then
    Exit;
  
  SelectedItem := lvErrors.Selected;
  Item := TValidationResult(SelectedItem.Data);
  
  // 触发选择属性事件
  FOnSelectProperty(Item.PropertyPath, Item.PropertyName);
    
  // 不立即关闭对话框，允许用户修复多个问题
  // Close;
end;

procedure TfrmValidation.lvErrorsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected then
    UpdateHelp;
end;

procedure TfrmValidation.ShowResults(Results: TValidationResultList);
begin
  FResults := Results;
  UpdateList;
  
  // 初始设置
  btnFixAll.Enabled := HasAutoFixableErrors;
  
  if lvErrors.Items.Count > 0 then
    lvErrors.Selected := lvErrors.Items[0];
  
  UpdateHelp;
  
  ShowModal;
end;

procedure TfrmValidation.UpdateList;
var
  i: Integer;
  Result: TValidationResult;
  Item: TListItem;
begin
  // 清空列表
  lvErrors.Items.Clear;
  
  if not Assigned(FResults) then 
    Exit;
  
  // 添加验证结果
  for i := 0 to FResults.Count - 1 do
  begin
    Result := FResults[i];
    
    Item := lvErrors.Items.Add;
    Item.Data := Result; // 存储引用以便后续访问
    
    // 设置严重性
    case Result.Severity of
      vsInfo: 
      begin
        Item.Caption := '信息';
        Item.ImageIndex := 0;
      end;
      vsWarning: 
      begin
        Item.Caption := '警告';
        Item.ImageIndex := 1;
      end;
      vsError: 
      begin
        Item.Caption := '错误';
        Item.ImageIndex := 2;
      end;
    end;
    
    // 设置属性信息
    Item.SubItems.Add(Result.PropertyPath);
    Item.SubItems.Add(Result.PropertyName);
    Item.SubItems.Add(Result.Message);
    
    // 是否可自动修复
    if Result.CanAutoFix then
      Item.SubItems.Add('是')
    else
      Item.SubItems.Add('否');
  end;
  
  // 更新自动修复按钮状态
  btnFixAll.Enabled := HasAutoFixableErrors;
end;

procedure TfrmValidation.UpdateHelp;
var
  SelectedItem: TListItem;
  Item: TValidationResult;
begin
  // 清空帮助
  memoHelp.Clear;
  lblFixSuggestion.Caption := '';
  btnFixCurrent.Enabled := False;
  
  if lvErrors.Selected = nil then
    Exit;
    
  SelectedItem := lvErrors.Selected;
  Item := TValidationResult(SelectedItem.Data);
  
  // 设置修复建议
  if Item.FixSuggestion <> '' then
  begin
    lblFixSuggestion.Caption := '修复建议: ' + Item.FixSuggestion;
    
    // 添加更多的帮助信息
    memoHelp.Lines.Add('问题详情:');
    memoHelp.Lines.Add('----------');
    memoHelp.Lines.Add('属性路径: ' + Item.PropertyPath);
    memoHelp.Lines.Add('属性名称: ' + Item.PropertyName);
    memoHelp.Lines.Add('错误信息: ' + Item.Message);
    memoHelp.Lines.Add('');
    memoHelp.Lines.Add('修复建议:');
    memoHelp.Lines.Add('----------');
    memoHelp.Lines.Add(Item.FixSuggestion);
    
    if Item.CanAutoFix then
    begin
      memoHelp.Lines.Add('');
      memoHelp.Lines.Add('此问题可以自动修复。点击下方"修复当前问题"按钮尝试自动修复。');
      btnFixCurrent.Enabled := True;
    end
    else
    begin
      memoHelp.Lines.Add('');
      memoHelp.Lines.Add('此问题需要手动修复。请按照上述建议进行更正。');
      btnFixCurrent.Enabled := False;
    end;
  end;
end;

function TfrmValidation.HasAutoFixableErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  
  if not Assigned(FResults) then
    Exit;
    
  for i := 0 to FResults.Count - 1 do
  begin
    if FResults[i].CanAutoFix then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

end.
