unit FontEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.JSON, ConfigTypes, System.UITypes, System.Generics.Collections, ConfigEditors,
  ConfigEditorsBase;

type
  TFontEditor = class(TForm)
    pnlMain: TPanel;
    pnlPreview: TPanel;
    lblPreview: TLabel;
    pnlSettings: TPanel;
    lblFontName: TLabel;
    lblFontSize: TLabel;
    lblFontStyle: TLabel;
    lblFontColor: TLabel;
    edtFontName: TEdit;
    edtFontSize: TEdit;
    pnlColor: TPanel;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    chkStrikeout: TCheckBox;
    btnSelectFont: TButton;
    btnDefault: TButton;
    btnApply: TButton;
    dlgFont: TFontDialog;
    dlgColor: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectFontClick(Sender: TObject);
    procedure pnlColorClick(Sender: TObject);
    procedure chkBoldClick(Sender: TObject);
    procedure chkItalicClick(Sender: TObject);
    procedure chkUnderlineClick(Sender: TObject);
    procedure chkStrikeoutClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
    FFontName: string;
    FFontSize: Integer;
    FFontColor: TColor;
    FFontStyles: TFontStyles;
    FJSONObject: TJSONObject;
    FModified: Boolean;
    procedure SetFontName(const Value: string);
    procedure SetFontSize(const Value: Integer);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontStyles(const Value: TFontStyles);
    procedure UpdatePreview;
    procedure LoadFontFromJSON(AJSONObject: TJSONObject);
    procedure SaveFontToJSON(AJSONObject: TJSONObject);
  public
    { Public declarations }
    property FontName: string read FFontName write SetFontName;
    property FontSize: Integer read FFontSize write SetFontSize;
    property FontColor: TColor read FFontColor write SetFontColor;
    property FontStyles: TFontStyles read FFontStyles write SetFontStyles;
    property JSONObject: TJSONObject read FJSONObject write FJSONObject;
    property Modified: Boolean read FModified write FModified;
    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TFontConfigEditor = class(TConfigEditorBase)
  private
    FFontEditor: TFontEditor;
  public
    constructor Create; override;
    destructor Destroy; override;
    
    // IConfigEditor接口实现
    function GetEditorType: TConfigType; override;
    procedure Load(const Config: TJSONObject); override;
    function Save: TJSONObject; override;
  end;

// 创建字体编辑器的工厂函数
function CreateFontEditor: IConfigEditor;

implementation

{$R *.dfm}

// 工厂函数实现
function CreateFontEditor: IConfigEditor;
begin
  Result := TFontConfigEditor.Create;
end;

{ TFontEditor }

constructor TFontEditor.Create(AOwner: TComponent);
begin
  inherited;
  FModified := False;
  FFontName := 'Tahoma';
  FFontSize := 10;
  FFontColor := clBlack;
  FFontStyles := [];
end;

destructor TFontEditor.Destroy;
begin
  inherited;
end;

procedure TFontEditor.FormCreate(Sender: TObject);
begin
  // 初始化界面
  edtFontName.Text := FFontName;
  edtFontSize.Text := IntToStr(FFontSize);
  pnlColor.Color := FFontColor;
  
  chkBold.Checked := fsBold in FFontStyles;
  chkItalic.Checked := fsItalic in FFontStyles;
  chkUnderline.Checked := fsUnderline in FFontStyles;
  chkStrikeout.Checked := fsStrikeOut in FFontStyles;
  
  UpdatePreview;
end;

procedure TFontEditor.SetFontColor(const Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    pnlColor.Color := Value;
    UpdatePreview;
    FModified := True;
  end;
end;

procedure TFontEditor.SetFontName(const Value: string);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    edtFontName.Text := Value;
    UpdatePreview;
    FModified := True;
  end;
end;

procedure TFontEditor.SetFontSize(const Value: Integer);
begin
  if FFontSize <> Value then
  begin
    FFontSize := Value;
    edtFontSize.Text := IntToStr(Value);
    UpdatePreview;
    FModified := True;
  end;
end;

procedure TFontEditor.SetFontStyles(const Value: TFontStyles);
begin
  if FFontStyles <> Value then
  begin
    FFontStyles := Value;
    chkBold.Checked := fsBold in Value;
    chkItalic.Checked := fsItalic in Value;
    chkUnderline.Checked := fsUnderline in Value;
    chkStrikeout.Checked := fsStrikeOut in Value;
    UpdatePreview;
    FModified := True;
  end;
end;

procedure TFontEditor.UpdatePreview;
begin
  // 更新预览标签的字体设置
  lblPreview.Font.Name := FFontName;
  lblPreview.Font.Size := FFontSize;
  lblPreview.Font.Color := FFontColor;
  lblPreview.Font.Style := FFontStyles;
end;

procedure TFontEditor.btnSelectFontClick(Sender: TObject);
begin
  // 设置字体对话框的初始值
  dlgFont.Font.Name := FFontName;
  dlgFont.Font.Size := FFontSize;
  dlgFont.Font.Color := FFontColor;
  dlgFont.Font.Style := FFontStyles;
  
  if dlgFont.Execute then
  begin
    // 更新字体属性
    SetFontName(dlgFont.Font.Name);
    SetFontSize(dlgFont.Font.Size);
    SetFontColor(dlgFont.Font.Color);
    SetFontStyles(dlgFont.Font.Style);
  end;
end;

procedure TFontEditor.btnDefaultClick(Sender: TObject);
begin
  // 恢复默认设置
  SetFontName('Tahoma');
  SetFontSize(10);
  SetFontColor(clBlack);
  SetFontStyles([]);
end;

procedure TFontEditor.btnApplyClick(Sender: TObject);
begin
  // 应用更改，保存到JSON对象
  if Assigned(FJSONObject) then
  begin
    SaveFontToJSON(FJSONObject);
    Self.ModalResult := mrOk;
  end;
end;

procedure TFontEditor.chkBoldClick(Sender: TObject);
var
  NewStyles: TFontStyles;
begin
  NewStyles := FFontStyles;
  if chkBold.Checked then
    Include(NewStyles, fsBold)
  else
    Exclude(NewStyles, fsBold);
  SetFontStyles(NewStyles);
end;

procedure TFontEditor.chkItalicClick(Sender: TObject);
var
  NewStyles: TFontStyles;
begin
  NewStyles := FFontStyles;
  if chkItalic.Checked then
    Include(NewStyles, fsItalic)
  else
    Exclude(NewStyles, fsItalic);
  SetFontStyles(NewStyles);
end;

procedure TFontEditor.chkStrikeoutClick(Sender: TObject);
var
  NewStyles: TFontStyles;
begin
  NewStyles := FFontStyles;
  if chkStrikeout.Checked then
    Include(NewStyles, fsStrikeOut)
  else
    Exclude(NewStyles, fsStrikeOut);
  SetFontStyles(NewStyles);
end;

procedure TFontEditor.chkUnderlineClick(Sender: TObject);
var
  NewStyles: TFontStyles;
begin
  NewStyles := FFontStyles;
  if chkUnderline.Checked then
    Include(NewStyles, fsUnderline)
  else
    Exclude(NewStyles, fsUnderline);
  SetFontStyles(NewStyles);
end;

procedure TFontEditor.pnlColorClick(Sender: TObject);
begin
  dlgColor.Color := FFontColor;
  if dlgColor.Execute then
  begin
    SetFontColor(dlgColor.Color);
  end;
end;

procedure TFontEditor.LoadFontFromJSON(AJSONObject: TJSONObject);
var
  FontObj: TJSONObject;
  StylesArray: TJSONArray;
  Styles: TFontStyles;
  I: Integer;
  StyleStr: string;
begin
  if not Assigned(AJSONObject) then
    Exit;
    
  try
    // 如果JSON对象中包含字体对象
    if AJSONObject.TryGetValue<TJSONObject>('Font', FontObj) then
    begin
      // 设置字体名称
      if FontObj.TryGetValue<string>('Name', FFontName) then
        edtFontName.Text := FFontName;
        
      // 设置字体大小
      if FontObj.TryGetValue<Integer>('Size', FFontSize) then
        edtFontSize.Text := IntToStr(FFontSize);
        
      // 设置字体颜色
      if FontObj.TryGetValue<Integer>('Color', Integer(FFontColor)) then
        pnlColor.Color := FFontColor;
        
      // 设置字体样式
      Styles := [];
      if FontObj.TryGetValue<TJSONArray>('Styles', StylesArray) then
      begin
        for I := 0 to StylesArray.Count - 1 do
        begin
          StyleStr := StylesArray.Items[I].Value;
          if StyleStr = 'Bold' then
            Include(Styles, fsBold)
          else if StyleStr = 'Italic' then
            Include(Styles, fsItalic)
          else if StyleStr = 'Underline' then
            Include(Styles, fsUnderline)
          else if StyleStr = 'StrikeOut' then
            Include(Styles, fsStrikeOut);
        end;
        FFontStyles := Styles;
      end;
      
      // 更新界面和预览
      chkBold.Checked := fsBold in FFontStyles;
      chkItalic.Checked := fsItalic in FFontStyles;
      chkUnderline.Checked := fsUnderline in FFontStyles;
      chkStrikeout.Checked := fsStrikeOut in FFontStyles;
      UpdatePreview;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('加载字体设置时出错: ' + E.Message);
    end;
  end;
end;

procedure TFontEditor.SaveFontToJSON(AJSONObject: TJSONObject);
var
  FontObj: TJSONObject;
  StylesArray: TJSONArray;
begin
  if not Assigned(AJSONObject) then
    Exit;
    
  try
    // 创建或清空字体对象
    if AJSONObject.TryGetValue<TJSONObject>('Font', FontObj) then
      FontObj.Free;
      
    FontObj := TJSONObject.Create;
    AJSONObject.AddPair('Font', FontObj);
    
    // 添加字体属性
    FontObj.AddPair('Name', FFontName);
    FontObj.AddPair('Size', TJSONNumber.Create(FFontSize));
    FontObj.AddPair('Color', TJSONNumber.Create(Integer(FFontColor)));
    
    // 添加字体样式
    StylesArray := TJSONArray.Create;
    FontObj.AddPair('Styles', StylesArray);
    
    if fsBold in FFontStyles then
      StylesArray.Add('Bold');
    if fsItalic in FFontStyles then
      StylesArray.Add('Italic');
    if fsUnderline in FFontStyles then
      StylesArray.Add('Underline');
    if fsStrikeOut in FFontStyles then
      StylesArray.Add('StrikeOut');
      
    FModified := False;
  except
    on E: Exception do
    begin
      ShowMessage('保存字体设置时出错: ' + E.Message);
    end;
  end;
end;

{ TFontConfigEditor }

constructor TFontConfigEditor.Create;
begin
  inherited;
  FFontEditor := TFontEditor.Create(nil);
  ConfigType := etFont;
end;

destructor TFontConfigEditor.Destroy;
begin
  FFontEditor.Free;
  inherited;
end;

function TFontConfigEditor.GetEditorType: TConfigType;
begin
  Result := etFont;
end;

procedure TFontConfigEditor.Load(const Config: TJSONObject);
begin
  if Assigned(Config) then
  begin
    FFontEditor.JSONObject := Config.Clone as TJSONObject;
    FFontEditor.LoadFontFromJSON(FFontEditor.JSONObject);
  end;
end;

function TFontConfigEditor.Save: TJSONObject;
begin
  Result := TJSONObject.Create;
  
  if Assigned(FFontEditor.JSONObject) then
  begin
    FFontEditor.SaveFontToJSON(FFontEditor.JSONObject);
    // 克隆JSON对象以返回
    Result := FFontEditor.JSONObject.Clone as TJSONObject;
  end
  else
  begin
    // 创建新的JSON对象
    FFontEditor.SaveFontToJSON(Result);
  end;
end;

// 注册编辑器
initialization
  RegisterConfigEditor(etFont, CreateFontEditor);
  
finalization
  // 清理资源

end. 