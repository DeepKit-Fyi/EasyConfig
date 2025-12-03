unit MediaConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  Vcl.Graphics, 
  ConfigTypes, JSONConfig;

type
  // 鍥剧墖鑳屾櫙閰嶇疆
  TImageBackgroundConfig = class(TConfigObject)
  private
    FImagePath: string;
    FOpacity: Double;
    FFitMode: string;
    FOffsetX: Integer;
    FOffsetY: Integer;
    FRotation: Integer;
    FBlurRadius: Integer;
    
    FJSONConfig: TJSONConfig;
    FImage: TBitmap;
    
    procedure ClearImage;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 楠岃瘉
    function Validate: Boolean; override;
    function GetValidationErrors: TArray<string>; override;
    
    // 鍥惧儚鎿嶄綔
    function GetImage: TBitmap;
    procedure SetImagePath(const Value: string);
    
    // 灞炴€ц闂?
    property ImagePath: string read FImagePath write SetImagePath;
    property Opacity: Double read FOpacity write FOpacity;
    property FitMode: string read FFitMode write FFitMode;
    property OffsetX: Integer read FOffsetX write FOffsetX;
    property OffsetY: Integer read FOffsetY write FOffsetY;
    property Rotation: Integer read FRotation write FRotation;
    property BlurRadius: Integer read FBlurRadius write FBlurRadius;
  end;
  
  // 鏂囨湰鍏冪礌
  TTextElement = class(TObject)
  private
    FText: string;
    FX: Integer;
    FY: Integer;
    FFontName: string;
    FFontSize: Integer;
    FFontColor: string;
    FBold: Boolean;
    FItalic: Boolean;
    FAlignment: Integer;
  public
    constructor Create;
    
    // 搴忓垪鍖栧拰鍙嶅簭鍒楀寲
    function ToJSON: TJSONObject;
    procedure FromJSON(const JSON: TJSONObject);
    
    // 灞炴€ц闂?
    property Text: string read FText write FText;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property FontName: string read FFontName write FFontName;
    property FontSize: Integer read FFontSize write FFontSize;
    property FontColor: string read FFontColor write FFontColor;
    property Bold: Boolean read FBold write FBold;
    property Italic: Boolean read FItalic write FItalic;
    property Alignment: Integer read FAlignment write FAlignment;
  end;
  
  // 鍥惧儚鍏冪礌
  TImageElement = class(TObject)
  private
    FImagePath: string;
    FX: Integer;
    FY: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FOpacity: Double;
    FRotation: Integer;
    
    FImage: TBitmap;
    
    procedure ClearImage;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 搴忓垪鍖栧拰鍙嶅簭鍒楀寲
    function ToJSON: TJSONObject;
    procedure FromJSON(const JSON: TJSONObject);
    
    // 鍥惧儚鎿嶄綔
    function GetImage: TBitmap;
    procedure SetImagePath(const Value: string);
    
    // 灞炴€ц闂?
    property ImagePath: string read FImagePath write SetImagePath;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Opacity: Double read FOpacity write FOpacity;
    property Rotation: Integer read FRotation write FRotation;
  end;
  
  // 鎶藉眽闈㈡澘閰嶇疆
  TDrawerConfig = class(TConfigObject)
  private
    FPosition: string;
    FWidth: Integer;
    FHeight: Integer;
    FSlideSpeed: Double;
    FDampingFactor: Double;
    FMinimizedSize: Integer;
    FBackgroundColor: string;
    FAutoHide: Boolean;
    FNestedDrawers: TObjectList<TDrawerConfig>;
    
    FJSONConfig: TJSONConfig;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 楠岃瘉
    function Validate: Boolean; override;
    function GetValidationErrors: TArray<string>; override;
    
    // 宓屽鎶藉眽鎿嶄綔
    function AddNestedDrawer(Drawer: TDrawerConfig): Integer;
    procedure RemoveNestedDrawer(Index: Integer);
    function GetNestedDrawer(Index: Integer): TDrawerConfig;
    
    // 灞炴€ц闂?
    property Position: string read FPosition write FPosition;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property SlideSpeed: Double read FSlideSpeed write FSlideSpeed;
    property DampingFactor: Double read FDampingFactor write FDampingFactor;
    property MinimizedSize: Integer read FMinimizedSize write FMinimizedSize;
    property BackgroundColor: string read FBackgroundColor write FBackgroundColor;
    property AutoHide: Boolean read FAutoHide write FAutoHide;
    property NestedDrawers: TObjectList<TDrawerConfig> read FNestedDrawers;
  end;
  
  // 瑙嗛鐗囨閰嶇疆
  TVideoClipConfig = class(TConfigObject)
  private
    FBackground: TImageBackgroundConfig;
    FImages: TObjectList<TImageElement>;
    FTexts: TObjectList<TTextElement>;
    FLength: Double;
    FAudioPath: string;
    FAudioVolume: Double;
    FAudioStartTime: Double;
    
    FJSONConfig: TJSONConfig;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 楠岃瘉
    function Validate: Boolean; override;
    function GetValidationErrors: TArray<string>; override;
    
    // 鍏冪礌鎿嶄綔
    function AddImage(Image: TImageElement): Integer;
    procedure RemoveImage(Index: Integer);
    function AddText(Text: TTextElement): Integer;
    procedure RemoveText(Index: Integer);
    
    // 灞炴€ц闂?
    property Background: TImageBackgroundConfig read FBackground;
    property Images: TObjectList<TImageElement> read FImages;
    property Texts: TObjectList<TTextElement> read FTexts;
    property Length: Double read FLength write FLength;
    property AudioPath: string read FAudioPath write FAudioPath;
    property AudioVolume: Double read FAudioVolume write FAudioVolume;
    property AudioStartTime: Double read FAudioStartTime write FAudioStartTime;
  end;

implementation

uses
  System.UITypes, System.IOUtils;

{ TImageBackgroundConfig }

constructor TImageBackgroundConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 榛樿鍊?
  FImagePath := '';
  FOpacity := 1.0;
  FFitMode := 'stretch';
  FOffsetX := 0;
  FOffsetY := 0;
  FRotation := 0;
  FBlurRadius := 0;
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
  FImage := nil;
end;

destructor TImageBackgroundConfig.Destroy;
begin
  ClearImage;
  
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

procedure TImageBackgroundConfig.ClearImage;
begin
  if Assigned(FImage) then
  begin
    FImage.Free;
    FImage := nil;
  end;
end;

function TImageBackgroundConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FImagePath := FJSONConfig.ReadString('ImagePath', FImagePath);
    FOpacity := FJSONConfig.ReadFloat('Opacity', FOpacity);
    FFitMode := FJSONConfig.ReadString('FitMode', FFitMode);
    FOffsetX := FJSONConfig.ReadInteger('OffsetX', FOffsetX);
    FOffsetY := FJSONConfig.ReadInteger('OffsetY', FOffsetY);
    FRotation := FJSONConfig.ReadInteger('Rotation', FRotation);
    FBlurRadius := FJSONConfig.ReadInteger('BlurRadius', FBlurRadius);
    
    // 娓呴櫎缂撳瓨鐨勫浘鍍?
    ClearImage;
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TImageBackgroundConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteString('ImagePath', FImagePath);
    FJSONConfig.WriteFloat('Opacity', FOpacity);
    FJSONConfig.WriteString('FitMode', FFitMode);
    FJSONConfig.WriteInteger('OffsetX', FOffsetX);
    FJSONConfig.WriteInteger('OffsetY', FOffsetY);
    FJSONConfig.WriteInteger('Rotation', FRotation);
    FJSONConfig.WriteInteger('BlurRadius', FBlurRadius);
    
    // 淇濆瓨鏂囦欢
    Result := FJSONConfig.Save;
    
    // 鏇存柊淇敼鐘舵€?
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TImageBackgroundConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TImageBackgroundConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 楠岃瘉鍥惧儚璺緞
    if (FImagePath <> '') and not TFile.Exists(FImagePath) then
      Errors.Add('鍥惧儚鏂囦欢璺緞鏃犳晥鎴栦笉瀛樺湪: ' + FImagePath);
      
    // 楠岃瘉閫忔槑搴?
    if (FOpacity < 0) or (FOpacity > 1) then
      Errors.Add('閫忔槑搴﹀繀椤诲湪0鍒?涔嬮棿');
      
    // 楠岃瘉閫傞厤妯″紡
    if not ((FFitMode = 'stretch') or (FFitMode = 'contain') or (FFitMode = 'cover') or (FFitMode = 'center')) then
      Errors.Add('閫傞厤妯″紡蹇呴』鏄痵tretch銆乧ontain銆乧over鎴朿enter涔嬩竴');
      
    // 楠岃瘉妯＄硦鍗婂緞
    if FBlurRadius < 0 then
      Errors.Add('妯＄硦鍗婂緞涓嶈兘涓鸿礋鏁?);
    
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

function TImageBackgroundConfig.GetImage: TBitmap;
begin
  // 妫€鏌ョ紦瀛樼殑鍥惧儚
  if not Assigned(FImage) and (FImagePath <> '') and TFile.Exists(FImagePath) then
  begin
    try
      FImage := TBitmap.Create;
      FImage.LoadFromFile(FImagePath);
    except
      // 鍔犺浇澶辫触锛屾竻闄ゅ浘鍍?
      ClearImage;
    end;
  end;
  
  Result := FImage;
end;

procedure TImageBackgroundConfig.SetImagePath(const Value: string);
begin
  if FImagePath <> Value then
  begin
    FImagePath := Value;
    ClearImage;
    FModified := True;
  end;
end;

{ TTextElement }

constructor TTextElement.Create;
begin
  inherited Create;
  
  // 榛樿鍊?
  FText := '';
  FX := 0;
  FY := 0;
  FFontName := 'Arial';
  FFontSize := 12;
  FFontColor := '#000000';
  FBold := False;
  FItalic := False;
  FAlignment := 0; // 宸﹀榻?
end;

function TTextElement.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('Text', FText);
  Result.AddPair('X', TJSONNumber.Create(FX));
  Result.AddPair('Y', TJSONNumber.Create(FY));
  Result.AddPair('FontName', FFontName);
  Result.AddPair('FontSize', TJSONNumber.Create(FFontSize));
  Result.AddPair('FontColor', FFontColor);
  Result.AddPair('Bold', TJSONBool.Create(FBold));
  Result.AddPair('Italic', TJSONBool.Create(FItalic));
  Result.AddPair('Alignment', TJSONNumber.Create(FAlignment));
end;

procedure TTextElement.FromJSON(const JSON: TJSONObject);
begin
  if not Assigned(JSON) then
    Exit;
    
  // 璇诲彇JSON灞炴€?
  FText := JSON.GetValue<string>('Text', FText);
  FX := JSON.GetValue<Integer>('X', FX);
  FY := JSON.GetValue<Integer>('Y', FY);
  FFontName := JSON.GetValue<string>('FontName', FFontName);
  FFontSize := JSON.GetValue<Integer>('FontSize', FFontSize);
  FFontColor := JSON.GetValue<string>('FontColor', FFontColor);
  FBold := JSON.GetValue<Boolean>('Bold', FBold);
  FItalic := JSON.GetValue<Boolean>('Italic', FItalic);
  FAlignment := JSON.GetValue<Integer>('Alignment', FAlignment);
end;

{ TImageElement }

constructor TImageElement.Create;
begin
  inherited Create;
  
  // 榛樿鍊?
  FImagePath := '';
  FX := 0;
  FY := 0;
  FWidth := 100;
  FHeight := 100;
  FOpacity := 1.0;
  FRotation := 0;
  
  FImage := nil;
end;

destructor TImageElement.Destroy;
begin
  ClearImage;
  inherited;
end;

procedure TImageElement.ClearImage;
begin
  if Assigned(FImage) then
  begin
    FImage.Free;
    FImage := nil;
  end;
end;

function TImageElement.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('ImagePath', FImagePath);
  Result.AddPair('X', TJSONNumber.Create(FX));
  Result.AddPair('Y', TJSONNumber.Create(FY));
  Result.AddPair('Width', TJSONNumber.Create(FWidth));
  Result.AddPair('Height', TJSONNumber.Create(FHeight));
  Result.AddPair('Opacity', TJSONNumber.Create(FOpacity));
  Result.AddPair('Rotation', TJSONNumber.Create(FRotation));
end;

procedure TImageElement.FromJSON(const JSON: TJSONObject);
begin
  if not Assigned(JSON) then
    Exit;
    
  // 璇诲彇JSON灞炴€?
  FImagePath := JSON.GetValue<string>('ImagePath', FImagePath);
  FX := JSON.GetValue<Integer>('X', FX);
  FY := JSON.GetValue<Integer>('Y', FY);
  FWidth := JSON.GetValue<Integer>('Width', FWidth);
  FHeight := JSON.GetValue<Integer>('Height', FHeight);
  FOpacity := JSON.GetValue<Double>('Opacity', FOpacity);
  FRotation := JSON.GetValue<Integer>('Rotation', FRotation);
  
  // 娓呴櫎缂撳瓨鐨勫浘鍍?
  ClearImage;
end;

function TImageElement.GetImage: TBitmap;
begin
  // 妫€鏌ョ紦瀛樼殑鍥惧儚
  if not Assigned(FImage) and (FImagePath <> '') and TFile.Exists(FImagePath) then
  begin
    try
      FImage := TBitmap.Create;
      FImage.LoadFromFile(FImagePath);
    except
      // 鍔犺浇澶辫触锛屾竻闄ゅ浘鍍?
      ClearImage;
    end;
  end;
  
  Result := FImage;
end;

procedure TImageElement.SetImagePath(const Value: string);
begin
  if FImagePath <> Value then
  begin
    FImagePath := Value;
    ClearImage;
  end;
end;

{ TDrawerConfig }

constructor TDrawerConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 榛樿鍊?
  FPosition := 'left';
  FWidth := 250;
  FHeight := 500;
  FSlideSpeed := 0.3;
  FDampingFactor := 0.8;
  FMinimizedSize := 20;
  FBackgroundColor := '#f0f0f0';
  FAutoHide := False;
  
  // 鍒涘缓宓屽鎶藉眽闆嗗悎
  FNestedDrawers := TObjectList<TDrawerConfig>.Create(True);
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
end;

destructor TDrawerConfig.Destroy;
begin
  if Assigned(FNestedDrawers) then
    FNestedDrawers.Free;
    
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

function TDrawerConfig.Load: Boolean;
var
  NestedArray: TJSONArray;
  i: Integer;
  NestedObject: TJSONObject;
  NestedDrawer: TDrawerConfig;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FPosition := FJSONConfig.ReadString('Position', FPosition);
    FWidth := FJSONConfig.ReadInteger('Width', FWidth);
    FHeight := FJSONConfig.ReadInteger('Height', FHeight);
    FSlideSpeed := FJSONConfig.ReadFloat('SlideSpeed', FSlideSpeed);
    FDampingFactor := FJSONConfig.ReadFloat('DampingFactor', FDampingFactor);
    FMinimizedSize := FJSONConfig.ReadInteger('MinimizedSize', FMinimizedSize);
    FBackgroundColor := FJSONConfig.ReadString('BackgroundColor', FBackgroundColor);
    FAutoHide := FJSONConfig.ReadBool('AutoHide', FAutoHide);
    
    // 鍔犺浇宓屽鎶藉眽
    FNestedDrawers.Clear;
    
    var JsonValue := FJSONConfig.GetJSONValue('NestedDrawers');
    if Assigned(JsonValue) and (JsonValue is TJSONArray) then
    begin
      NestedArray := TJSONArray(JsonValue);
      
      for i := 0 to NestedArray.Count - 1 do
      begin
        if NestedArray.Items[i] is TJSONObject then
        begin
          NestedObject := TJSONObject(NestedArray.Items[i]);
          
          // 鍒涘缓宓屽鎶藉眽
          NestedDrawer := TDrawerConfig.Create('', '', '', '');
          
          // 浠嶫SON瀵硅薄鍔犺浇灞炴€?
          NestedDrawer.Position := NestedObject.GetValue<string>('Position', NestedDrawer.Position);
          NestedDrawer.Width := NestedObject.GetValue<Integer>('Width', NestedDrawer.Width);
          NestedDrawer.Height := NestedObject.GetValue<Integer>('Height', NestedDrawer.Height);
          NestedDrawer.SlideSpeed := NestedObject.GetValue<Double>('SlideSpeed', NestedDrawer.SlideSpeed);
          NestedDrawer.DampingFactor := NestedObject.GetValue<Double>('DampingFactor', NestedDrawer.DampingFactor);
          NestedDrawer.MinimizedSize := NestedObject.GetValue<Integer>('MinimizedSize', NestedDrawer.MinimizedSize);
          NestedDrawer.BackgroundColor := NestedObject.GetValue<string>('BackgroundColor', NestedDrawer.BackgroundColor);
          NestedDrawer.AutoHide := NestedObject.GetValue<Boolean>('AutoHide', NestedDrawer.AutoHide);
          
          // 娣诲姞鍒伴泦鍚?
          FNestedDrawers.Add(NestedDrawer);
        end;
      end;
    end;
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TDrawerConfig.Save: Boolean;
var
  NestedArray: TJSONArray;
  i: Integer;
  NestedObject: TJSONObject;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteString('Position', FPosition);
    FJSONConfig.WriteInteger('Width', FWidth);
    FJSONConfig.WriteInteger('Height', FHeight);
    FJSONConfig.WriteFloat('SlideSpeed', FSlideSpeed);
    FJSONConfig.WriteFloat('DampingFactor', FDampingFactor);
    FJSONConfig.WriteInteger('MinimizedSize', FMinimizedSize);
    FJSONConfig.WriteString('BackgroundColor', FBackgroundColor);
    FJSONConfig.WriteBool('AutoHide', FAutoHide);
    
    // 淇濆瓨宓屽鎶藉眽
    NestedArray := TJSONArray.Create;
    
    for i := 0 to FNestedDrawers.Count - 1 do
    begin
      NestedObject := TJSONObject.Create;
      
      // 娣诲姞灞炴€?
      NestedObject.AddPair('Position', FNestedDrawers[i].Position);
      NestedObject.AddPair('Width', TJSONNumber.Create(FNestedDrawers[i].Width));
      NestedObject.AddPair('Height', TJSONNumber.Create(FNestedDrawers[i].Height));
      NestedObject.AddPair('SlideSpeed', TJSONNumber.Create(FNestedDrawers[i].SlideSpeed));
      NestedObject.AddPair('DampingFactor', TJSONNumber.Create(FNestedDrawers[i].DampingFactor));
      NestedObject.AddPair('MinimizedSize', TJSONNumber.Create(FNestedDrawers[i].MinimizedSize));
      NestedObject.AddPair('BackgroundColor', FNestedDrawers[i].BackgroundColor);
      NestedObject.AddPair('AutoHide', TJSONBool.Create(FNestedDrawers[i].AutoHide));
      
      // 娣诲姞鍒版暟缁?
      NestedArray.Add(NestedObject);
    end;
    
    // 鍒犻櫎鐜版湁鍊?
    FJSONConfig.RemoveValue('NestedDrawers');
    
    // 娣诲姞鏂板€?
    var Root := FJSONConfig.JSONObject;
    Root.AddPair('NestedDrawers', NestedArray);
    
    // 淇濆瓨鏂囦欢
    Result := FJSONConfig.Save;
    
    // 鏇存柊淇敼鐘舵€?
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TDrawerConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TDrawerConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 楠岃瘉浣嶇疆
    if not ((FPosition = 'left') or (FPosition = 'right') or (FPosition = 'top') or (FPosition = 'bottom')) then
      Errors.Add('浣嶇疆蹇呴』鏄痩eft銆乺ight銆乼op鎴朾ottom涔嬩竴');
      
    // 楠岃瘉灏哄
    if FWidth <= 0 then
      Errors.Add('瀹藉害蹇呴』澶т簬0');
      
    if FHeight <= 0 then
      Errors.Add('楂樺害蹇呴』澶т簬0');
      
    // 楠岃瘉婊戝姩閫熷害
    if FSlideSpeed <= 0 then
      Errors.Add('婊戝姩閫熷害蹇呴』澶т簬0');
      
    // 楠岃瘉鍑忛渿鍥犲瓙
    if (FDampingFactor <= 0) or (FDampingFactor > 1) then
      Errors.Add('鍑忛渿鍥犲瓙蹇呴』鍦?鍒?涔嬮棿');
      
    // 楠岃瘉鏈€灏忓寲灏哄
    if FMinimizedSize < 0 then
      Errors.Add('鏈€灏忓寲灏哄涓嶈兘涓鸿礋鏁?);
    
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

function TDrawerConfig.AddNestedDrawer(Drawer: TDrawerConfig): Integer;
begin
  Result := FNestedDrawers.Add(Drawer);
  FModified := True;
end;

procedure TDrawerConfig.RemoveNestedDrawer(Index: Integer);
begin
  if (Index >= 0) and (Index < FNestedDrawers.Count) then
  begin
    FNestedDrawers.Delete(Index);
    FModified := True;
  end;
end;

function TDrawerConfig.GetNestedDrawer(Index: Integer): TDrawerConfig;
begin
  if (Index >= 0) and (Index < FNestedDrawers.Count) then
    Result := FNestedDrawers[Index]
  else
    Result := nil;
end;

{ TVideoClipConfig }

constructor TVideoClipConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 鍒涘缓鑳屾櫙
  FBackground := TImageBackgroundConfig.Create('', 'Background', '', '');
  
  // 鍒涘缓鍏冪礌闆嗗悎
  FImages := TObjectList<TImageElement>.Create(True);
  FTexts := TObjectList<TTextElement>.Create(True);
  
  // 榛樿鍊?
  FLength := 10.0;
  FAudioPath := '';
  FAudioVolume := 1.0;
  FAudioStartTime := 0.0;
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
end;

destructor TVideoClipConfig.Destroy;
begin
  if Assigned(FBackground) then
    FBackground.Free;
    
  if Assigned(FImages) then
    FImages.Free;
    
  if Assigned(FTexts) then
    FTexts.Free;
    
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

function TVideoClipConfig.Load: Boolean;
var
  ImagesArray, TextsArray: TJSONArray;
  i: Integer;
  ImageObj, TextObj: TJSONObject;
  ImageElement: TImageElement;
  TextElement: TTextElement;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FLength := FJSONConfig.ReadFloat('Length', FLength);
    FAudioPath := FJSONConfig.ReadString('AudioPath', FAudioPath);
    FAudioVolume := FJSONConfig.ReadFloat('AudioVolume', FAudioVolume);
    FAudioStartTime := FJSONConfig.ReadFloat('AudioStartTime', FAudioStartTime);
    
    // 鍔犺浇鑳屾櫙
    var BackgroundObj := FJSONConfig.GetJSONValue('Background');
    if Assigned(BackgroundObj) and (BackgroundObj is TJSONObject) then
    begin
      FBackground.ImagePath := TJSONObject(BackgroundObj).GetValue<string>('ImagePath', FBackground.ImagePath);
      FBackground.Opacity := TJSONObject(BackgroundObj).GetValue<Double>('Opacity', FBackground.Opacity);
      FBackground.FitMode := TJSONObject(BackgroundObj).GetValue<string>('FitMode', FBackground.FitMode);
      FBackground.OffsetX := TJSONObject(BackgroundObj).GetValue<Integer>('OffsetX', FBackground.OffsetX);
      FBackground.OffsetY := TJSONObject(BackgroundObj).GetValue<Integer>('OffsetY', FBackground.OffsetY);
      FBackground.Rotation := TJSONObject(BackgroundObj).GetValue<Integer>('Rotation', FBackground.Rotation);
      FBackground.BlurRadius := TJSONObject(BackgroundObj).GetValue<Integer>('BlurRadius', FBackground.BlurRadius);
    end;
    
    // 鍔犺浇鍥惧儚鍏冪礌
    FImages.Clear;
    
    var ImagesValue := FJSONConfig.GetJSONValue('Images');
    if Assigned(ImagesValue) and (ImagesValue is TJSONArray) then
    begin
      ImagesArray := TJSONArray(ImagesValue);
      
      for i := 0 to ImagesArray.Count - 1 do
      begin
        if ImagesArray.Items[i] is TJSONObject then
        begin
          ImageObj := TJSONObject(ImagesArray.Items[i]);
          
          // 鍒涘缓鍥惧儚鍏冪礌
          ImageElement := TImageElement.Create;
          
          // 浠嶫SON瀵硅薄鍔犺浇灞炴€?
          ImageElement.FromJSON(ImageObj);
          
          // 娣诲姞鍒伴泦鍚?
          FImages.Add(ImageElement);
        end;
      end;
    end;
    
    // 鍔犺浇鏂囨湰鍏冪礌
    FTexts.Clear;
    
    var TextsValue := FJSONConfig.GetJSONValue('Texts');
    if Assigned(TextsValue) and (TextsValue is TJSONArray) then
    begin
      TextsArray := TJSONArray(TextsValue);
      
      for i := 0 to TextsArray.Count - 1 do
      begin
        if TextsArray.Items[i] is TJSONObject then
        begin
          TextObj := TJSONObject(TextsArray.Items[i]);
          
          // 鍒涘缓鏂囨湰鍏冪礌
          TextElement := TTextElement.Create;
          
          // 浠嶫SON瀵硅薄鍔犺浇灞炴€?
          TextElement.FromJSON(TextObj);
          
          // 娣诲姞鍒伴泦鍚?
          FTexts.Add(TextElement);
        end;
      end;
    end;
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TVideoClipConfig.Save: Boolean;
var
  ImagesArray, TextsArray: TJSONArray;
  i: Integer;
  BackgroundObj: TJSONObject;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteFloat('Length', FLength);
    FJSONConfig.WriteString('AudioPath', FAudioPath);
    FJSONConfig.WriteFloat('AudioVolume', FAudioVolume);
    FJSONConfig.WriteFloat('AudioStartTime', FAudioStartTime);
    
    // 淇濆瓨鑳屾櫙
    BackgroundObj := TJSONObject.Create;
    BackgroundObj.AddPair('ImagePath', FBackground.ImagePath);
    BackgroundObj.AddPair('Opacity', TJSONNumber.Create(FBackground.Opacity));
    BackgroundObj.AddPair('FitMode', FBackground.FitMode);
    BackgroundObj.AddPair('OffsetX', TJSONNumber.Create(FBackground.OffsetX));
    BackgroundObj.AddPair('OffsetY', TJSONNumber.Create(FBackground.OffsetY));
    BackgroundObj.AddPair('Rotation', TJSONNumber.Create(FBackground.Rotation));
    BackgroundObj.AddPair('BlurRadius', TJSONNumber.Create(FBackground.BlurRadius));
    
    // 鍒犻櫎鐜版湁鍊?
    FJSONConfig.RemoveValue('Background');
    
    // 娣诲姞鏂板€?
    var Root := FJSONConfig.JSONObject;
    Root.AddPair('Background', BackgroundObj);
    
    // 淇濆瓨鍥惧儚鍏冪礌
    ImagesArray := TJSONArray.Create;
    
    for i := 0 to FImages.Count - 1 do
    begin
      // 娣诲姞鍒版暟缁?
      ImagesArray.Add(FImages[i].ToJSON);
    end;
    
    // 鍒犻櫎鐜版湁鍊?
    FJSONConfig.RemoveValue('Images');
    
    // 娣诲姞鏂板€?
    Root.AddPair('Images', ImagesArray);
    
    // 淇濆瓨鏂囨湰鍏冪礌
    TextsArray := TJSONArray.Create;
    
    for i := 0 to FTexts.Count - 1 do
    begin
      // 娣诲姞鍒版暟缁?
      TextsArray.Add(FTexts[i].ToJSON);
    end;
    
    // 鍒犻櫎鐜版湁鍊?
    FJSONConfig.RemoveValue('Texts');
    
    // 娣诲姞鏂板€?
    Root.AddPair('Texts', TextsArray);
    
    // 淇濆瓨鏂囦欢
    Result := FJSONConfig.Save;
    
    // 鏇存柊淇敼鐘舵€?
    if Result then
      FModified := False;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TVideoClipConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TVideoClipConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 楠岃瘉闀垮害
    if FLength <= 0 then
      Errors.Add('鐗囨闀垮害蹇呴』澶т簬0');
      
    // 楠岃瘉闊抽璺緞
    if (FAudioPath <> '') and not TFile.Exists(FAudioPath) then
      Errors.Add('闊抽鏂囦欢璺緞鏃犳晥鎴栦笉瀛樺湪: ' + FAudioPath);
      
    // 楠岃瘉闊抽闊抽噺
    if (FAudioVolume < 0) or (FAudioVolume > 1) then
      Errors.Add('闊抽闊抽噺蹇呴』鍦?鍒?涔嬮棿');
      
    // 楠岃瘉闊抽璧峰鏃堕棿
    if FAudioStartTime < 0 then
      Errors.Add('闊抽璧峰鏃堕棿涓嶈兘涓鸿礋鏁?);
    
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

function TVideoClipConfig.AddImage(Image: TImageElement): Integer;
begin
  Result := FImages.Add(Image);
  FModified := True;
end;

procedure TVideoClipConfig.RemoveImage(Index: Integer);
begin
  if (Index >= 0) and (Index < FImages.Count) then
  begin
    FImages.Delete(Index);
    FModified := True;
  end;
end;

function TVideoClipConfig.AddText(Text: TTextElement): Integer;
begin
  Result := FTexts.Add(Text);
  FModified := True;
end;

procedure TVideoClipConfig.RemoveText(Index: Integer);
begin
  if (Index >= 0) and (Index < FTexts.Count) then
  begin
    FTexts.Delete(Index);
    FModified := True;
  end;
end;

end. 