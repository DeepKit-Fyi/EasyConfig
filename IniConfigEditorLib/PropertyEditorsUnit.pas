unit PropertyEditorsUnit;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Graphics, Vcl.Dialogs, Vcl.ComCtrls, ConfigItemsUnit, ReusableObjectsUnit;

type
  // 定义一个新的集合类型
  TByteSet = set of 0..7;

  // 基本属性编辑器接口
  IPropertyEditor = interface
    ['{B1C2D3E4-F5A6-4B5C-8D7E-9F0A1B2C3D4E}']
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
    
    property Control: TWinControl read GetControl;
  end;

  // 文本属性编辑器
  TTextPropertyEditor = class(TInterfacedObject, IPropertyEditor)
  private
    FControl: TEdit;
    FItem: IConfigItem;
    
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
  public
    constructor Create(AParent: TComponent; const AName: string);
    destructor Destroy; override;
  end;

  // 目录属性编辑器
  TDirPropertyEditor = class(TInterfacedObject, IPropertyEditor)
  private
    FPanel: TPanel;
    FPathEdit: TEdit;
    FBrowseBtn: TButton;
    FItem: IConfigItem;
    
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
    
    procedure BrowseBtnClick(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // 文件属性编辑器
  TFilePropertyEditor = class(TInterfacedObject, IPropertyEditor)
  private
    FPanel: TPanel;
    FPathEdit: TEdit;
    FBrowseBtn: TButton;
    FFileTypeEdit: TEdit;
    FItem: IConfigItem;
    
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
    
    procedure BrowseBtnClick(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // 输入属性编辑器
  TInputPropertyEditor = class(TInterfacedObject, IPropertyEditor)
  private
    FPanel: TPanel;
    FTextEdit: TEdit;
    FFontRefCombo: TComboBox;
    FItem: IConfigItem;
    
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
    
    procedure PopulateFontRefs;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // 图像属性编辑器
  TImagePropertyEditor = class(TInterfacedObject, IPropertyEditor)
  private
    FPanel: TPanel;
    FFileNameEdit: TEdit;
    FBrowseBtn: TButton;
    FTransparentCheck: TCheckBox;
    FTransparentColorBtn: TButton;
    FWidthEdit: TEdit;
    FHeightEdit: TEdit;
    FKeepAspectCheck: TCheckBox;
    FPreviewImage: TImage;
    FItem: IConfigItem;
    
    function GetControl: TWinControl;
    procedure SetItem(Item: IConfigItem);
    procedure Apply;
    
    procedure BrowseBtnClick(Sender: TObject);
    procedure TransparentColorBtnClick(Sender: TObject);
    procedure UpdatePreview;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // 属性编辑器工厂
  TPropertyEditorFactory = class
  public
    class function CreatePropertyEditor(Item: IConfigItem): IPropertyEditor;
    class function CreatePropertyEditorForProperty(Item: IConfigItem; const PropertyName: string): IPropertyEditor;
  end;

implementation

uses
  ConfigManagerUnit, System.Variants;

{ TTextPropertyEditor }

constructor TTextPropertyEditor.Create(AParent: TComponent; const AName: string);
begin
  inherited Create;
  FControl := TEdit.Create(AParent);
  FControl.Name := AName;
end;

destructor TTextPropertyEditor.Destroy;
begin
  FControl.Free;
  inherited;
end;

function TTextPropertyEditor.GetControl: TWinControl;
begin
  Result := FControl;
end;

procedure TTextPropertyEditor.SetItem(Item: IConfigItem);
begin
  FItem := Item;
  if FItem is TTextConfigItem then
    FControl.Text := TTextConfigItem(FItem).Value;
end;

procedure TTextPropertyEditor.Apply;
begin
  if FItem is TTextConfigItem then
    TTextConfigItem(FItem).Value := FControl.Text;
end;

{ TDirPropertyEditor }

procedure TDirPropertyEditor.Apply;
begin
  if not (FItem is TDirConfigItem) then Exit;
  
  TDirConfigItem(FItem).Path := FPathEdit.Text;
end;

procedure TDirPropertyEditor.BrowseBtnClick(Sender: TObject);
var
  DirDialog: TFileOpenDialog;
begin
  DirDialog := TFileOpenDialog.Create(nil);
  try
    DirDialog.Options := [fdoPickFolders];
    
    if DirDialog.Execute then
      FPathEdit.Text := DirDialog.FileName;
  finally
    DirDialog.Free;
  end;
end;

constructor TDirPropertyEditor.Create;
var
  Label1: TLabel;
begin
  inherited Create;
  
  FPanel := TPanel.Create(nil);
  FPanel.Width := 400;
  FPanel.Height := 100;
  FPanel.BevelOuter := bvNone;
  
  Label1 := TLabel.Create(FPanel);
  Label1.Parent := FPanel;
  Label1.Left := 8;
  Label1.Top := 16;
  Label1.Caption := '目录路径:';
  
  FPathEdit := TEdit.Create(FPanel);
  FPathEdit.Parent := FPanel;
  FPathEdit.Left := 80;
  FPathEdit.Top := 12;
  FPathEdit.Width := 250;
  
  FBrowseBtn := TButton.Create(FPanel);
  FBrowseBtn.Parent := FPanel;
  FBrowseBtn.Left := 340;
  FBrowseBtn.Top := 10;
  FBrowseBtn.Width := 50;
  FBrowseBtn.Caption := '浏览...';
  FBrowseBtn.OnClick := BrowseBtnClick;
end;

destructor TDirPropertyEditor.Destroy;
begin
  FPanel.Free;
  inherited;
end;

function TDirPropertyEditor.GetControl: TWinControl;
begin
  Result := FPanel;
end;

procedure TDirPropertyEditor.SetItem(Item: IConfigItem);
begin
  FItem := Item;
  
  if not (FItem is TDirConfigItem) then Exit;
  
  FPathEdit.Text := TDirConfigItem(FItem).Path;
end;

{ TFilePropertyEditor }

procedure TFilePropertyEditor.Apply;
begin
  if not (FItem is TFileConfigItem) then Exit;
  
  TFileConfigItem(FItem).Path := FPathEdit.Text;
  TFileConfigItem(FItem).FileType := FFileTypeEdit.Text;
end;

procedure TFilePropertyEditor.BrowseBtnClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    if OpenDialog.Execute then
      FPathEdit.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

constructor TFilePropertyEditor.Create;
var
  Label1, Label2: TLabel;
begin
  inherited Create;
  
  FPanel := TPanel.Create(nil);
  FPanel.Width := 400;
  FPanel.Height := 100;
  FPanel.BevelOuter := bvNone;
  
  Label1 := TLabel.Create(FPanel);
  Label1.Parent := FPanel;
  Label1.Left := 8;
  Label1.Top := 16;
  Label1.Caption := '文件路径:';
  
  FPathEdit := TEdit.Create(FPanel);
  FPathEdit.Parent := FPanel;
  FPathEdit.Left := 80;
  FPathEdit.Top := 12;
  FPathEdit.Width := 250;
  
  FBrowseBtn := TButton.Create(FPanel);
  FBrowseBtn.Parent := FPanel;
  FBrowseBtn.Left := 340;
  FBrowseBtn.Top := 10;
  FBrowseBtn.Width := 50;
  FBrowseBtn.Caption := '浏览...';
  FBrowseBtn.OnClick := BrowseBtnClick;
  
  Label2 := TLabel.Create(FPanel);
  Label2.Parent := FPanel;
  Label2.Left := 8;
  Label2.Top := 48;
  Label2.Caption := '文件类型:';
  
  FFileTypeEdit := TEdit.Create(FPanel);
  FFileTypeEdit.Parent := FPanel;
  FFileTypeEdit.Left := 80;
  FFileTypeEdit.Top := 44;
  FFileTypeEdit.Width := 300;
end;

destructor TFilePropertyEditor.Destroy;
begin
  FPanel.Free;
  inherited;
end;

function TFilePropertyEditor.GetControl: TWinControl;
begin
  Result := FPanel;
end;

procedure TFilePropertyEditor.SetItem(Item: IConfigItem);
begin
  FItem := Item;
  
  if not (FItem is TFileConfigItem) then Exit;
  
  FPathEdit.Text := TFileConfigItem(FItem).Path;
  FFileTypeEdit.Text := TFileConfigItem(FItem).FileType;
end;

{ TInputPropertyEditor }

procedure TInputPropertyEditor.Apply;
begin
  if not (FItem is TInputConfigItem) then Exit;
  
  TInputConfigItem(FItem).Text := FTextEdit.Text;
  TInputConfigItem(FItem).FontRef := FFontRefCombo.Text;
end;

constructor TInputPropertyEditor.Create;
var
  Label1, Label2: TLabel;
begin
  inherited Create;
  
  FPanel := TPanel.Create(nil);
  FPanel.Width := 400;
  FPanel.Height := 100;
  FPanel.BevelOuter := bvNone;
  
  Label1 := TLabel.Create(FPanel);
  Label1.Parent := FPanel;
  Label1.Left := 8;
  Label1.Top := 16;
  Label1.Caption := '默认文本:';
  
  FTextEdit := TEdit.Create(FPanel);
  FTextEdit.Parent := FPanel;
  FTextEdit.Left := 80;
  FTextEdit.Top := 12;
  FTextEdit.Width := 300;
  
  Label2 := TLabel.Create(FPanel);
  Label2.Parent := FPanel;
  Label2.Left := 8;
  Label2.Top := 48;
  Label2.Caption := '字体引用:';
  
  FFontRefCombo := TComboBox.Create(FPanel);
  FFontRefCombo.Parent := FPanel;
  FFontRefCombo.Left := 80;
  FFontRefCombo.Top := 44;
  FFontRefCombo.Width := 300;
  FFontRefCombo.Style := csDropDownList;
end;

destructor TInputPropertyEditor.Destroy;
begin
  FPanel.Free;
  inherited;
end;

function TInputPropertyEditor.GetControl: TWinControl;
begin
  Result := FPanel;
end;

procedure TInputPropertyEditor.PopulateFontRefs;
var
  I: Integer;
  Obj: IReusableObject;
begin
  FFontRefCombo.Items.Clear;
  FFontRefCombo.Items.Add('');
  
  // 这里需要从配置管理器获取字体引用
  // 实际实现时需要传入 ConfigManager 参数
end;

procedure TInputPropertyEditor.SetItem(Item: IConfigItem);
begin
  FItem := Item;
  
  if not (FItem is TInputConfigItem) then Exit;
  
  PopulateFontRefs;
  
  FTextEdit.Text := TInputConfigItem(FItem).Text;
  FFontRefCombo.Text := TInputConfigItem(FItem).FontRef;
end;

{ TImagePropertyEditor }

procedure TImagePropertyEditor.Apply;
var
  Scale: TScale;
begin
  if not (FItem is TImageConfigItem) then Exit;
  
  TImageConfigItem(FItem).FileName := FFileNameEdit.Text;
  TImageConfigItem(FItem).Transparent := FTransparentCheck.Checked;
  
  Scale.Width := StrToIntDef(FWidthEdit.Text, 0);
  Scale.Height := StrToIntDef(FHeightEdit.Text, 0);
  Scale.KeepAspectRatio := FKeepAspectCheck.Checked;
  TImageConfigItem(FItem).Scale := Scale;
end;

procedure TImagePropertyEditor.BrowseBtnClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := '图像文件 (*.bmp;*.jpg;*.jpeg;*.png;*.gif)|*.bmp;*.jpg;*.jpeg;*.png;*.gif|所有文件 (*.*)|*.*';
    
    if OpenDialog.Execute then
    begin
      FFileNameEdit.Text := OpenDialog.FileName;
      UpdatePreview;
    end;
  finally
    OpenDialog.Free;
  end;
end;

constructor TImagePropertyEditor.Create;
var
  Label1, Label2, Label3: TLabel;
  PreviewPanel: TPanel;
begin
  inherited Create;
  
  FPanel := TPanel.Create(nil);
  FPanel.Width := 400;
  FPanel.Height := 300;
  FPanel.BevelOuter := bvNone;
  
  Label1 := TLabel.Create(FPanel);
  Label1.Parent := FPanel;
  Label1.Left := 8;
  Label1.Top := 16;
  Label1.Caption := '图像文件:';
  
  FFileNameEdit := TEdit.Create(FPanel);
  FFileNameEdit.Parent := FPanel;
  FFileNameEdit.Left := 80;
  FFileNameEdit.Top := 12;
  FFileNameEdit.Width := 250;
  
  FBrowseBtn := TButton.Create(FPanel);
  FBrowseBtn.Parent := FPanel;
  FBrowseBtn.Left := 340;
  FBrowseBtn.Top := 10;
  FBrowseBtn.Width := 50;
  FBrowseBtn.Caption := '浏览...';
  FBrowseBtn.OnClick := BrowseBtnClick;
  
  FTransparentCheck := TCheckBox.Create(FPanel);
  FTransparentCheck.Parent := FPanel;
  FTransparentCheck.Left := 8;
  FTransparentCheck.Top := 44;
  FTransparentCheck.Width := 100;
  FTransparentCheck.Caption := '透明';
  
  FTransparentColorBtn := TButton.Create(FPanel);
  FTransparentColorBtn.Parent := FPanel;
  FTransparentColorBtn.Left := 120;
  FTransparentColorBtn.Top := 40;
  FTransparentColorBtn.Width := 80;
  FTransparentColorBtn.Caption := '透明色...';
  FTransparentColorBtn.OnClick := TransparentColorBtnClick;
  
  Label2 := TLabel.Create(FPanel);
  Label2.Parent := FPanel;
  Label2.Left := 8;
  Label2.Top := 76;
  Label2.Caption := '宽度:';
  
  FWidthEdit := TEdit.Create(FPanel);
  FWidthEdit.Parent := FPanel;
  FWidthEdit.Left := 80;
  FWidthEdit.Top := 72;
  FWidthEdit.Width := 60;
  
  Label3 := TLabel.Create(FPanel);
  Label3.Parent := FPanel;
  Label3.Left := 150;
  Label3.Top := 76;
  Label3.Caption := '高度:';
  
  FHeightEdit := TEdit.Create(FPanel);
  FHeightEdit.Parent := FPanel;
  FHeightEdit.Left := 200;
  FHeightEdit.Top := 72;
  FHeightEdit.Width := 60;
  
  FKeepAspectCheck := TCheckBox.Create(FPanel);
  FKeepAspectCheck.Parent := FPanel;
  FKeepAspectCheck.Left := 280;
  FKeepAspectCheck.Top := 72;
  FKeepAspectCheck.Width := 120;
  FKeepAspectCheck.Caption := '保持比例';
  
  PreviewPanel := TPanel.Create(FPanel);
  PreviewPanel.Parent := FPanel;
  PreviewPanel.Left := 8;
  PreviewPanel.Top := 100;
  PreviewPanel.Width := 380;
  PreviewPanel.Height := 190;
  PreviewPanel.Caption := '预览';
  
  FPreviewImage := TImage.Create(PreviewPanel);
  FPreviewImage.Parent := PreviewPanel;
  FPreviewImage.Align := alClient;
  FPreviewImage.Stretch := True;
  FPreviewImage.Center := True;
end;

destructor TImagePropertyEditor.Destroy;
begin
  FPanel.Free;
  inherited;
end;

function TImagePropertyEditor.GetControl: TWinControl;
begin
  Result := FPanel;
end;

procedure TImagePropertyEditor.SetItem(Item: IConfigItem);
begin
  FItem := Item;
  
  if not (FItem is TImageConfigItem) then Exit;
  
  FFileNameEdit.Text := TImageConfigItem(FItem).FileName;
  FTransparentCheck.Checked := TImageConfigItem(FItem).Transparent;
  FWidthEdit.Text := IntToStr(TImageConfigItem(FItem).Scale.Width);
  FHeightEdit.Text := IntToStr(TImageConfigItem(FItem).Scale.Height);
  FKeepAspectCheck.Checked := TImageConfigItem(FItem).Scale.KeepAspectRatio;
  
  UpdatePreview;
end;

procedure TImagePropertyEditor.TransparentColorBtnClick(Sender: TObject);
var
  ColorDialog: TColorDialog;
begin
  if not (FItem is TImageConfigItem) then Exit;
  
  ColorDialog := TColorDialog.Create(nil);
  try
    ColorDialog.Color := TImageConfigItem(FItem).TransparentColor;
    
    if ColorDialog.Execute then
      TImageConfigItem(FItem).TransparentColor := ColorDialog.Color;
  finally
    ColorDialog.Free;
  end;
end;

procedure TImagePropertyEditor.UpdatePreview;
begin
  if FileExists(FFileNameEdit.Text) then
  begin
    try
      FPreviewImage.Picture.LoadFromFile(FFileNameEdit.Text);
    except
      // 忽略加载错误
    end;
  end
  else
    FPreviewImage.Picture := nil;
end;

{ TPropertyEditorFactory }

class function TPropertyEditorFactory.CreatePropertyEditor(Item: IConfigItem): IPropertyEditor;
var
  Editor: TTextPropertyEditor;
begin
  if Item is TTextConfigItem then
  begin
    Editor := TTextPropertyEditor.Create(nil, '');
    Editor.SetItem(Item);
    Result := Editor;
  end
  else if Item is TDirConfigItem then
    Result := TDirPropertyEditor.Create
  else if Item is TFileConfigItem then
    Result := TFilePropertyEditor.Create
  else if Item is TInputConfigItem then
    Result := TInputPropertyEditor.Create
  else if Item is TImageConfigItem then
    Result := TImagePropertyEditor.Create
  else
    Result := nil;
end;

class function TPropertyEditorFactory.CreatePropertyEditorForProperty(Item: IConfigItem; const PropertyName: string): IPropertyEditor;
var
  Editor: IPropertyEditor;
begin
  Result := nil;
  
  // 处理布尔属性
  if (PropertyName = '可见') or (PropertyName = 'Visible') then
  begin
    // 这里需要实现布尔属性编辑器
    // 暂时返回nil
  end
  else if (PropertyName = 'X轴居中') or (PropertyName = 'IsCenterX') then
  begin
    // 这里需要实现布尔属性编辑器
    // 暂时返回nil
  end
  else if (PropertyName = 'Y轴居中') or (PropertyName = 'IsCenterY') then
  begin
    // 这里需要实现布尔属性编辑器
    // 暂时返回nil
  end
  else if Item is TImageConfigItem then
  begin
    if (PropertyName = '透明') or (PropertyName = 'Transparent') then
    begin
      // 这里需要实现布尔属性编辑器
      // 暂时返回nil
    end
    else if (PropertyName = '保持比例') or (PropertyName = 'KeepAspectRatio') then
    begin
      // 这里需要实现布尔属性编辑器
      // 暂时返回nil
    end;
  end
  // 处理文本属性
  else if (Item is TTextConfigItem) and ((PropertyName = '文本内容') or (PropertyName = 'Value')) then
  begin
    Editor := TTextPropertyEditor.Create(nil, '');
    Editor.SetItem(Item);
    Result := Editor;
  end;
end;

end.