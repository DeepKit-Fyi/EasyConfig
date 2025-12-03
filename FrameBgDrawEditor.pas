unit FrameBgDrawEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtDlgs, System.JSON, System.Generics.Collections,
  UtilsTypes, System.UITypes, ConfigFrameBase, JSONHelpers;

type
  // 缁樺埗鍏冪礌鍩虹被
  TDrawElement = class
  private
    FName: string;
    FX: Integer;
    FY: Integer;
    FVisible: Boolean;
    FSelected: Boolean;
  public
    constructor Create; virtual;
    
    // 缁樺埗鍏冪礌
    procedure Draw(Canvas: TCanvas); virtual; abstract;
    
    // 鍒ゆ柇鐐规槸鍚﹀湪鍏冪礌鍐?
    function ContainsPoint(X, Y: Integer): Boolean; virtual; abstract;
    
    // 绉诲姩鍏冪礌
    procedure Move(DX, DY: Integer); virtual;
    
    // 浠嶫SON鍔犺浇灞炴€?
    procedure LoadFromJSON(JSON: TJSONObject); virtual;
    
    // 淇濆瓨灞炴€у埌JSON
    function SaveToJSON: TJSONObject; virtual;
    
    property Name: string read FName write FName;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Visible: Boolean read FVisible write FVisible;
    property Selected: Boolean read FSelected write FSelected;
  end;

  // 鏂囨湰鍏冪礌
  TTextElement = class(TDrawElement)
  private
    FText: string;
    FFont: TFont;
  public
    constructor Create; override;
    destructor Destroy; override;
    
    procedure Draw(Canvas: TCanvas); override;
    function ContainsPoint(X, Y: Integer): Boolean; override;
    
    procedure LoadFromJSON(JSON: TJSONObject); override;
    function SaveToJSON: TJSONObject; override;
    
    property Text: string read FText write FText;
    property Font: TFont read FFont;
  end;

  // 鍥剧墖鍏冪礌
  TImageElement = class(TDrawElement)
  private
    FImagePath: string;
    FImage: TBitmap;
    FWidth: Integer;
    FHeight: Integer;
    FScale: Double;
    
    procedure LoadImage;
  public
    constructor Create; override;
    destructor Destroy; override;
    
    procedure Draw(Canvas: TCanvas); override;
    function ContainsPoint(X, Y: Integer): Boolean; override;
    
    procedure LoadFromJSON(JSON: TJSONObject); override;
    function SaveToJSON: TJSONObject; override;
    
    property ImagePath: string read FImagePath write FImagePath;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Scale: Double read FScale write FScale;
  end;

  // 瀛楀箷鍏冪礌
  TCaptionElement = class(TTextElement)
  private
    FDuration: Double; // 鏄剧ず鏃堕暱锛堢锛?
    FStartTime: Double; // 寮€濮嬫椂闂寸偣锛堢锛?
  public
    constructor Create; override;
    
    procedure LoadFromJSON(JSON: TJSONObject); override;
    function SaveToJSON: TJSONObject; override;
    
    property Duration: Double read FDuration write FDuration;
    property StartTime: Double read FStartTime write FStartTime;
  end;

  // 鑳屾櫙鐢诲竷缁勪欢
  TBackgroundCanvas = class(TCustomControl)
  private
    FBackground: TBitmap;
    FBackgroundPath: string;
    FElements: TList<TDrawElement>;
    
    FSelectedElement: TDrawElement;
    FDragging: Boolean;
    FDragStartX, FDragStartY: Integer;
    
    procedure LoadBackground;
    procedure AddElement(Element: TDrawElement);
    function FindElementAt(X, Y: Integer): TDrawElement;
    
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    // 娣诲姞鏂囨湰鍏冪礌
    function AddTextElement(const Text: string; X, Y: Integer): TTextElement;
    
    // 娣诲姞鍥剧墖鍏冪礌
    function AddImageElement(const ImagePath: string; X, Y: Integer): TImageElement;
    
    // 娣诲姞瀛楀箷鍏冪礌
    function AddCaptionElement(const Text: string; X, Y: Integer; Duration: Double): TCaptionElement;
    
    // 鍒犻櫎閫変腑鐨勫厓绱?
    procedure DeleteSelectedElement;
    
    // 浠嶫SON鍔犺浇
    procedure LoadFromJSON(JSON: TJSONObject);
    
    // 淇濆瓨鍒癑SON
    function SaveToJSON: TJSONObject;
    
    // 璁剧疆鑳屾櫙鍥剧墖
    procedure SetBackground(const ImagePath: string);
    
    property BackgroundPath: string read FBackgroundPath;
    property SelectedElement: TDrawElement read FSelectedElement;
  end;

  // 鑳屾櫙鍥剧粯鍒剁紪杈戝櫒Frame
  TFrameBgDrawEditor = class(TBaseConfigFrame)
    pnlToolbar: TPanel;
    btnAddText: TButton;
    btnAddImage: TButton;
    btnAddCaption: TButton;
    btnDelete: TButton;
    pnlCanvas: TPanel;
    pnlProperties: TPanel;
    lblElementProperties: TLabel;
    pnlBackground: TPanel;
    btnLoadBackground: TButton;
    dlgOpenImage: TOpenPictureDialog;
    btnSave: TButton;
    splHorizontal: TSplitter;
    pgProperties: TPageControl;
    tsGeneral: TTabSheet;
    tsTextProps: TTabSheet;
    tsImageProps: TTabSheet;
    tsCaptionProps: TTabSheet;
    edtElementName: TEdit;
    lblName: TLabel;
    lblPositionX: TLabel;
    lblPositionY: TLabel;
    edtPositionX: TEdit;
    edtPositionY: TEdit;
    chkVisible: TCheckBox;
    lblText: TLabel;
    edtText: TEdit;
    btnFont: TButton;
    dlgFont: TFontDialog;
    lblImagePath: TLabel;
    edtImagePath: TEdit;
    btnBrowseImage: TButton;
    lblScale: TLabel;
    edtScale: TEdit;
    lblDuration: TLabel;
    edtDuration: TEdit;
    lblStartTime: TLabel;
    edtStartTime: TEdit;
    procedure btnAddTextClick(Sender: TObject);
    procedure btnAddImageClick(Sender: TObject);
    procedure btnAddCaptionClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnLoadBackgroundClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtElementNameChange(Sender: TObject);
    procedure edtPositionXChange(Sender: TObject);
    procedure edtPositionYChange(Sender: TObject);
    procedure chkVisibleClick(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnBrowseImageClick(Sender: TObject);
    procedure edtScaleChange(Sender: TObject);
    procedure edtDurationChange(Sender: TObject);
    procedure edtStartTimeChange(Sender: TObject);
  private
    FCanvas: TBackgroundCanvas;

    // 鏇存柊鐣岄潰涓婄殑灞炴€ф帶浠?
    procedure UpdatePropertyControls;

    // 浠庡睘鎬ф帶浠舵洿鏂板綋鍓嶉€変腑鐨勫厓绱?
    procedure UpdateSelectedElement;

    // 鍒囨崲灞炴€ч〉闈?
    procedure ShowPropertyPage(ElementType: TClass);
    
    procedure CreateControls; override;
  protected
    procedure LoadFromJSON; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // 淇濆瓨鏁版嵁鍒癑SON
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TDrawElement }

constructor TDrawElement.Create;
begin
  FVisible := True;
  FSelected := False;
end;

procedure TDrawElement.Move(DX, DY: Integer);
begin
  FX := FX + DX;
  FY := FY + DY;
end;

procedure TDrawElement.LoadFromJSON(JSON: TJSONObject);
begin
  if JSON = nil then
    Exit;
    
  if JSON.GetValue('name') <> nil then
    FName := JSON.GetValue<string>('name');
    
  if JSON.GetValue('x') <> nil then
    FX := JSON.GetValue<Integer>('x');
    
  if JSON.GetValue('y') <> nil then
    FY := JSON.GetValue<Integer>('y');
    
  if JSON.GetValue('visible') <> nil then
    FVisible := JSON.GetValue<Boolean>('visible');
end;

function TDrawElement.SaveToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('name', FName);
  Result.AddPair('x', TJSONNumber.Create(FX));
  Result.AddPair('y', TJSONNumber.Create(FY));
  Result.AddPair('visible', TJSONBool.Create(FVisible));
end;

{ TTextElement }

constructor TTextElement.Create;
begin
  inherited;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.Size := 12;
  FFont.Color := clBlack;
end;

destructor TTextElement.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TTextElement.Draw(Canvas: TCanvas);
begin
  if not FVisible then
    Exit;
    
  Canvas.Font.Assign(FFont);
  Canvas.Brush.Style := bsClear;
  Canvas.TextOut(FX, FY, FText);
  
  if FSelected then
  begin
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psDot;
    Canvas.Brush.Style := bsClear;
    
    var TextWidth := Canvas.TextWidth(FText);
    var TextHeight := Canvas.TextHeight(FText);
    
    Canvas.Rectangle(FX - 2, FY - 2, FX + TextWidth + 2, FY + TextHeight + 2);
  end;
end;

function TTextElement.ContainsPoint(X, Y: Integer): Boolean;
var
  TextWidth, TextHeight: Integer;
begin
  // 鍒涘缓涓存椂鐢诲竷浠ヨ幏鍙栨枃鏈昂瀵?
  var Bitmap := TBitmap.Create;
  try
    Bitmap.Canvas.Font.Assign(FFont);
    TextWidth := Bitmap.Canvas.TextWidth(FText);
    TextHeight := Bitmap.Canvas.TextHeight(FText);
  finally
    Bitmap.Free;
  end;
  
  Result := (X >= FX) and (X <= FX + TextWidth) and
            (Y >= FY) and (Y <= FY + TextHeight);
end;

procedure TTextElement.LoadFromJSON(JSON: TJSONObject);
var
  FontObj: TJSONObject;
begin
  inherited;
  
  if JSON = nil then
    Exit;
    
  if JSON.GetValue('text') <> nil then
    FText := JSON.GetValue<string>('text');
    
  if JSON.GetValue('font') <> nil then
  begin
    FontObj := JSON.GetValue<TJSONObject>('font');
    
    if FontObj.GetValue('name') <> nil then
      FFont.Name := FontObj.GetValue<string>('name');
      
    if FontObj.GetValue('size') <> nil then
      FFont.Size := FontObj.GetValue<Integer>('size');
      
    if FontObj.GetValue('color') <> nil then
      FFont.Color := FontObj.GetValue<Integer>('color');
      
    if FontObj.GetValue('style') <> nil then
    begin
      FFont.Style := [];
      var StyleArray := FontObj.GetValue<TJSONArray>('style');
      
      for var I := 0 to StyleArray.Count - 1 do
      begin
        var StyleStr := StyleArray.Items[I].Value;
        if StyleStr = 'bold' then
          FFont.Style := FFont.Style + [fsBold]
        else if StyleStr = 'italic' then
          FFont.Style := FFont.Style + [fsItalic]
        else if StyleStr = 'underline' then
          FFont.Style := FFont.Style + [fsUnderline]
        else if StyleStr = 'strikeout' then
          FFont.Style := FFont.Style + [fsStrikeOut];
      end;
    end;
  end;
end;

function TTextElement.SaveToJSON: TJSONObject;
var
  FontObj: TJSONObject;
  StyleArray: TJSONArray;
begin
  Result := inherited;
  
  Result.AddPair('type', 'text');
  Result.AddPair('text', FText);
  
  FontObj := TJSONObject.Create;
  FontObj.AddPair('name', FFont.Name);
  FontObj.AddPair('size', TJSONNumber.Create(FFont.Size));
  FontObj.AddPair('color', TJSONNumber.Create(FFont.Color));
  
  StyleArray := TJSONArray.Create;
  if fsBold in FFont.Style then
    StyleArray.Add('bold');
  if fsItalic in FFont.Style then
    StyleArray.Add('italic');
  if fsUnderline in FFont.Style then
    StyleArray.Add('underline');
  if fsStrikeOut in FFont.Style then
    StyleArray.Add('strikeout');
    
  FontObj.AddPair('style', StyleArray);
  Result.AddPair('font', FontObj);
end;

{ TImageElement }

constructor TImageElement.Create;
begin
  inherited;
  FImage := TBitmap.Create;
  FScale := 1.0;
end;

destructor TImageElement.Destroy;
begin
  FImage.Free;
  inherited;
end;

procedure TImageElement.LoadImage;
begin
  if FImagePath.IsEmpty then
    Exit;
    
  try
    FImage.LoadFromFile(FImagePath);
    FWidth := Round(FImage.Width * FScale);
    FHeight := Round(FImage.Height * FScale);
  except
    on E: Exception do
    begin
      FImage.Width := 50;
      FImage.Height := 50;
      FWidth := 50;
      FHeight := 50;
      
      // 缁樺埗涓€涓敊璇爣璁?
      FImage.Canvas.Brush.Color := clRed;
      FImage.Canvas.FillRect(Rect(0, 0, 50, 50));
      FImage.Canvas.Pen.Color := clBlack;
      FImage.Canvas.MoveTo(0, 0);
      FImage.Canvas.LineTo(50, 50);
      FImage.Canvas.MoveTo(0, 50);
      FImage.Canvas.LineTo(50, 0);
    end;
  end;
end;

procedure TImageElement.Draw(Canvas: TCanvas);
begin
  if not FVisible then
    Exit;
    
  if FImage.Empty then
    LoadImage;
    
  Canvas.StretchDraw(Rect(FX, FY, FX + FWidth, FY + FHeight), FImage);
  
  if FSelected then
  begin
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psDot;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(FX - 2, FY - 2, FX + FWidth + 2, FY + FHeight + 2);
  end;
end;

function TImageElement.ContainsPoint(X, Y: Integer): Boolean;
begin
  Result := (X >= FX) and (X <= FX + FWidth) and
            (Y >= FY) and (Y <= FY + FHeight);
end;

procedure TImageElement.LoadFromJSON(JSON: TJSONObject);
begin
  inherited;
  
  if JSON = nil then
    Exit;
    
  if JSON.GetValue('image_path') <> nil then
  begin
    FImagePath := JSON.GetValue<string>('image_path');
    LoadImage;
  end;
    
  if JSON.GetValue('scale') <> nil then
  begin
    FScale := JSON.GetValue<Double>('scale');
    FWidth := Round(FImage.Width * FScale);
    FHeight := Round(FImage.Height * FScale);
  end;
end;

function TImageElement.SaveToJSON: TJSONObject;
begin
  Result := inherited;
  
  Result.AddPair('type', 'image');
  Result.AddPair('image_path', FImagePath);
  Result.AddPair('scale', TJSONNumber.Create(FScale));
end;

{ TCaptionElement }

constructor TCaptionElement.Create;
begin
  inherited;
  FDuration := 5.0;
  FStartTime := 0.0;
end;

procedure TCaptionElement.LoadFromJSON(JSON: TJSONObject);
begin
  inherited;
  
  if JSON = nil then
    Exit;
    
  if JSON.GetValue('duration') <> nil then
    FDuration := JSON.GetValue<Double>('duration');
    
  if JSON.GetValue('start_time') <> nil then
    FStartTime := JSON.GetValue<Double>('start_time');
end;

function TCaptionElement.SaveToJSON: TJSONObject;
begin
  Result := inherited;
  
  Result.RemovePair('type').Free;
  Result.AddPair('type', 'caption');
  Result.AddPair('duration', TJSONNumber.Create(FDuration));
  Result.AddPair('start_time', TJSONNumber.Create(FStartTime));
end;

{ TBackgroundCanvas }

constructor TBackgroundCanvas.Create(AOwner: TComponent);
begin
  inherited;
  
  FBackground := TBitmap.Create;
  FElements := TList<TDrawElement>.Create;
  
  Width := 800;
  Height := 600;
  
  FSelectedElement := nil;
  FDragging := False;
end;

destructor TBackgroundCanvas.Destroy;
begin
  for var Element in FElements do
    Element.Free;
    
  FElements.Free;
  FBackground.Free;
  
  inherited;
end;

procedure TBackgroundCanvas.Paint;
begin
  inherited;
  
  // 缁樺埗鑳屾櫙
  Canvas.Draw(0, 0, FBackground);
  
  // 缁樺埗鍏冪礌
  for var Element in FElements do
    Element.Draw(Canvas);
end;

procedure TBackgroundCanvas.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  
  if Button = mbLeft then
  begin
    var Element := FindElementAt(X, Y);
    
    if Element <> FSelectedElement then
    begin
      if FSelectedElement <> nil then
        FSelectedElement.Selected := False;
        
      FSelectedElement := Element;
      
      if FSelectedElement <> nil then
        FSelectedElement.Selected := True;
        
      Invalidate;
    end;
    
    if FSelectedElement <> nil then
    begin
      FDragging := True;
      FDragStartX := X;
      FDragStartY := Y;
    end;
  end;
end;

procedure TBackgroundCanvas.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  
  if FDragging and (FSelectedElement <> nil) then
  begin
    FSelectedElement.Move(X - FDragStartX, Y - FDragStartY);
    FDragStartX := X;
    FDragStartY := Y;
    Invalidate;
  end;
end;

procedure TBackgroundCanvas.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  
  if Button = mbLeft then
    FDragging := False;
end;

procedure TBackgroundCanvas.LoadBackground;
begin
  if FBackgroundPath.IsEmpty then
  begin
    FBackground.Width := Width;
    FBackground.Height := Height;
    FBackground.Canvas.Brush.Color := clWhite;
    FBackground.Canvas.FillRect(Rect(0, 0, Width, Height));
    Exit;
  end;
  
  try
    FBackground.LoadFromFile(FBackgroundPath);
    
    // 璋冩暣鎺т欢澶у皬浠ラ€傚簲鑳屾櫙鍥剧墖
    if not (csDesigning in ComponentState) then
    begin
      Width := FBackground.Width;
      Height := FBackground.Height;
    end;
  except
    on E: Exception do
    begin
      FBackground.Width := Width;
      FBackground.Height := Height;
      FBackground.Canvas.Brush.Color := clWhite;
      FBackground.Canvas.FillRect(Rect(0, 0, Width, Height));
      
      FBackground.Canvas.Font.Color := clRed;
      FBackground.Canvas.TextOut(10, 10, '鏃犳硶鍔犺浇鑳屾櫙鍥剧墖: ' + E.Message);
    end;
  end;
end;

procedure TBackgroundCanvas.AddElement(Element: TDrawElement);
begin
  FElements.Add(Element);
  
  if FSelectedElement <> nil then
    FSelectedElement.Selected := False;
    
  FSelectedElement := Element;
  FSelectedElement.Selected := True;
  
  Invalidate;
end;

function TBackgroundCanvas.FindElementAt(X, Y: Integer): TDrawElement;
begin
  Result := nil;
  
  // 浠庡悗鍚戝墠閬嶅巻锛堟樉绀洪『搴忎粠涓婂埌涓嬶級
  for var I := FElements.Count - 1 downto 0 do
  begin
    var Element := FElements[I];
    
    if Element.Visible and Element.ContainsPoint(X, Y) then
    begin
      Result := Element;
      Break;
    end;
  end;
end;

function TBackgroundCanvas.AddTextElement(const Text: string; X, Y: Integer): TTextElement;
begin
  Result := TTextElement.Create;
  Result.Text := Text;
  Result.X := X;
  Result.Y := Y;
  Result.Name := '鏂囨湰_' + IntToStr(FElements.Count + 1);
  
  AddElement(Result);
end;

function TBackgroundCanvas.AddImageElement(const ImagePath: string; X, Y: Integer): TImageElement;
begin
  Result := TImageElement.Create;
  Result.ImagePath := ImagePath;
  Result.X := X;
  Result.Y := Y;
  Result.Name := '鍥剧墖_' + IntToStr(FElements.Count + 1);
  
  AddElement(Result);
end;

function TBackgroundCanvas.AddCaptionElement(const Text: string; X, Y: Integer; Duration: Double): TCaptionElement;
begin
  Result := TCaptionElement.Create;
  Result.Text := Text;
  Result.X := X;
  Result.Y := Y;
  Result.Duration := Duration;
  Result.Name := '瀛楀箷_' + IntToStr(FElements.Count + 1);
  
  AddElement(Result);
end;

procedure TBackgroundCanvas.DeleteSelectedElement;
begin
  if FSelectedElement = nil then
    Exit;
    
  FElements.Remove(FSelectedElement);
  FSelectedElement.Free;
  FSelectedElement := nil;
  
  Invalidate;
end;

procedure TBackgroundCanvas.LoadFromJSON(JSON: TJSONObject);
var
  ElementsArray: TJSONArray;
  ElementObj: TJSONObject;
  Element: TDrawElement;
  ElementType: string;
begin
  // 娓呴櫎鐜版湁鍏冪礌
  for var E in FElements do
    E.Free;
    
  FElements.Clear;
  FSelectedElement := nil;
  
  if JSON = nil then
    Exit;
    
  // 鍔犺浇鑳屾櫙
  if JSON.GetValue('background') <> nil then
  begin
    FBackgroundPath := JSON.GetValue<string>('background');
    LoadBackground;
  end;
  
  // 鍔犺浇鍏冪礌
  if JSON.GetValue('elements') <> nil then
  begin
    ElementsArray := JSON.GetValue<TJSONArray>('elements');
    
    for var I := 0 to ElementsArray.Count - 1 do
    begin
      ElementObj := ElementsArray.Items[I] as TJSONObject;
      ElementType := '';
      
      if ElementObj.GetValue('type') <> nil then
        ElementType := ElementObj.GetValue<string>('type');
        
      if ElementType = 'text' then
        Element := TTextElement.Create
      else if ElementType = 'image' then
        Element := TImageElement.Create
      else if ElementType = 'caption' then
        Element := TCaptionElement.Create
      else
        Continue; // 璺宠繃鏈煡鍏冪礌绫诲瀷
        
      Element.LoadFromJSON(ElementObj);
      FElements.Add(Element);
    end;
  end;
  
  Invalidate;
end;

function TBackgroundCanvas.SaveToJSON: TJSONObject;
var
  ElementsArray: TJSONArray;
begin
  Result := TJSONObject.Create;
  
  // 淇濆瓨鑳屾櫙
  Result.AddPair('background', FBackgroundPath);
  
  // 淇濆瓨鍏冪礌
  ElementsArray := TJSONArray.Create;
  
  for var Element in FElements do
    ElementsArray.Add(Element.SaveToJSON);
    
  Result.AddPair('elements', ElementsArray);
end;

procedure TBackgroundCanvas.SetBackground(const ImagePath: string);
begin
  FBackgroundPath := ImagePath;
  LoadBackground;
  Invalidate;
end;

{ TFrameBgDrawEditor }

constructor TFrameBgDrawEditor.Create(AOwner: TComponent);
begin
  inherited;
  CreateControls;
end;

destructor TFrameBgDrawEditor.Destroy;
begin
  if Assigned(JSONObject) then
    JSONObject.Free;
    
  inherited;
end;

procedure TFrameBgDrawEditor.LoadFromJSON;
begin
  if JSONObject = nil then
    Exit;

  // 加载到画布
  FCanvas.LoadFromJSON(JSONObject);

  // 更新界面
  UpdatePropertyControls;
end;

procedure TFrameBgDrawEditor.SaveToJSON;
begin
  if Assigned(JSONObject) then
    JSONObject.Free;
    
  JSONObject := FCanvas.SaveToJSON;
end;

procedure TFrameBgDrawEditor.CreateControls;
begin
  // 创建画布控件
  FCanvas := TBackgroundCanvas.Create(Self);
  FCanvas.Parent := pnlCanvas;
  FCanvas.Align := alClient;

  // 初始化属性页
  pgProperties.ActivePage := tsGeneral;

  // 初始化对话框
  dlgOpenImage.Filter := '图片文件(*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp';
end;

procedure TFrameBgDrawEditor.UpdatePropertyControls;
var
  Element: TDrawElement;
begin
  Element := FCanvas.SelectedElement;
  
  if Element = nil then
  begin
    pgProperties.Visible := False;
    lblElementProperties.Caption := '鏈€変腑鍏冪礌';
    Exit;
  end;
  
  pgProperties.Visible := True;
  lblElementProperties.Caption := '姝ｅ湪缂栬緫: ' + Element.Name;
  
  // 鏇存柊閫氱敤灞炴€?
  edtElementName.Text := Element.Name;
  edtPositionX.Text := IntToStr(Element.X);
  edtPositionY.Text := IntToStr(Element.Y);
  chkVisible.Checked := Element.Visible;
  
  // 鏍规嵁鍏冪礌绫诲瀷鏄剧ず鐗瑰畾灞炴€ч〉
  ShowPropertyPage(Element.ClassType);
  
  // 鏇存柊鐗瑰畾灞炴€?
  if Element is TTextElement then
  begin
    var TextElement := TTextElement(Element);
    edtText.Text := TextElement.Text;
  end
  else if Element is TImageElement then
  begin
    var ImageElement := TImageElement(Element);
    edtImagePath.Text := ImageElement.ImagePath;
    edtScale.Text := FormatFloat('0.00', ImageElement.Scale);
  end;
  
  if Element is TCaptionElement then
  begin
    var CaptionElement := TCaptionElement(Element);
    edtDuration.Text := FormatFloat('0.00', CaptionElement.Duration);
    edtStartTime.Text := FormatFloat('0.00', CaptionElement.StartTime);
  end;
end;

procedure TFrameBgDrawEditor.UpdateSelectedElement;
var
  Element: TDrawElement;
begin
  Element := FCanvas.SelectedElement;
  
  if Element = nil then
    Exit;
    
  // 鏇存柊閫氱敤灞炴€?
  Element.Name := edtElementName.Text;
  
  try
    Element.X := StrToInt(edtPositionX.Text);
  except
    // 蹇界暐鏃犳晥杈撳叆
  end;
  
  try
    Element.Y := StrToInt(edtPositionY.Text);
  except
    // 蹇界暐鏃犳晥杈撳叆
  end;
  
  Element.Visible := chkVisible.Checked;
  
  // 鏇存柊鐗瑰畾灞炴€?
  if Element is TTextElement then
  begin
    var TextElement := TTextElement(Element);
    TextElement.Text := edtText.Text;
  end
  else if Element is TImageElement then
  begin
    var ImageElement := TImageElement(Element);
    
    try
      ImageElement.Scale := StrToFloat(edtScale.Text);
    except
      // 蹇界暐鏃犳晥杈撳叆
    end;
  end;
  
  if Element is TCaptionElement then
  begin
    var CaptionElement := TCaptionElement(Element);
    
    try
      CaptionElement.Duration := StrToFloat(edtDuration.Text);
    except
      // 蹇界暐鏃犳晥杈撳叆
    end;
    
    try
      CaptionElement.StartTime := StrToFloat(edtStartTime.Text);
    except
      // 蹇界暐鏃犳晥杈撳叆
    end;
  end;
  
  FCanvas.Invalidate;
end;

procedure TFrameBgDrawEditor.ShowPropertyPage(ElementType: TClass);
begin
  // 鍏堟樉绀洪€氱敤灞炴€ч〉
  tsGeneral.TabVisible := True;
  
  // 鏍规嵁鍏冪礌绫诲瀷鏄剧ず鐗瑰畾灞炴€ч〉
  tsTextProps.TabVisible := ElementType.InheritsFrom(TTextElement);
  tsImageProps.TabVisible := ElementType = TImageElement;
  tsCaptionProps.TabVisible := ElementType = TCaptionElement;
  
  // 璁剧疆娲诲姩椤?
  if tsTextProps.TabVisible then
    pgProperties.ActivePage := tsTextProps
  else if tsImageProps.TabVisible then
    pgProperties.ActivePage := tsImageProps
  else if tsCaptionProps.TabVisible then
    pgProperties.ActivePage := tsCaptionProps
  else
    pgProperties.ActivePage := tsGeneral;
end;

procedure TFrameBgDrawEditor.btnAddTextClick(Sender: TObject);
begin
  FCanvas.AddTextElement('新文本', 50, 50);
  UpdatePropertyControls;
end;

procedure TFrameBgDrawEditor.btnAddImageClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
  begin
    FCanvas.AddImageElement(dlgOpenImage.FileName, 50, 50);
    UpdatePropertyControls;
  end;
end;

procedure TFrameBgDrawEditor.btnAddCaptionClick(Sender: TObject);
begin
  FCanvas.AddCaptionElement('新字幕', 50, 50, 5.0);
  UpdatePropertyControls;
end;

procedure TFrameBgDrawEditor.btnDeleteClick(Sender: TObject);
begin
  FCanvas.DeleteSelectedElement;
  UpdatePropertyControls;
end;

procedure TFrameBgDrawEditor.btnLoadBackgroundClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
  begin
    FCanvas.SetBackground(dlgOpenImage.FileName);
  end;
end;

procedure TFrameBgDrawEditor.btnSaveClick(Sender: TObject);
begin
  // 淇濆瓨灞炴€?
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtElementNameChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtPositionXChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtPositionYChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.chkVisibleClick(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtTextChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.btnFontClick(Sender: TObject);
var
  Element: TDrawElement;
begin
  Element := FCanvas.SelectedElement;
  
  if not (Element is TTextElement) then
    Exit;
    
  dlgFont.Font.Assign(TTextElement(Element).Font);
  
  if dlgFont.Execute then
  begin
    TTextElement(Element).Font.Assign(dlgFont.Font);
    FCanvas.Invalidate;
  end;
end;

procedure TFrameBgDrawEditor.btnBrowseImageClick(Sender: TObject);
var
  Element: TDrawElement;
begin
  Element := FCanvas.SelectedElement;
  
  if not (Element is TImageElement) then
    Exit;
    
  if dlgOpenImage.Execute then
  begin
    TImageElement(Element).ImagePath := dlgOpenImage.FileName;
    edtImagePath.Text := dlgOpenImage.FileName;
    UpdateSelectedElement;
  end;
end;

procedure TFrameBgDrawEditor.edtScaleChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtDurationChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

procedure TFrameBgDrawEditor.edtStartTimeChange(Sender: TObject);
begin
  UpdateSelectedElement;
end;

end. 