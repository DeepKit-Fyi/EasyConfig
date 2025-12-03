unit UIConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  Vcl.Graphics, 
  ConfigTypes, JSONConfig;

type
  // 甯冨眬閰嶇疆
  TLayoutConfig = class(TConfigObject)
  private
    FMainWidth: Integer;
    FMainHeight: Integer;
    FMainMaximized: Boolean;
    FTreeWidth: Integer;
    FPreviewHeight: Integer;
    FShowPreview: Boolean;
    FShowStatusBar: Boolean;
    FShowToolbar: Boolean;
    FToolbarPosition: string;
    FSavedLayouts: TJSONArray;
    
    FJSONConfig: TJSONConfig;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 甯冨眬鎿嶄綔
    procedure SaveCurrentLayout(const Name: string);
    function LoadSavedLayout(const Name: string): Boolean;
    function GetSavedLayouts: TArray<string>;
    
    // 灞炴€ц闂?
    property MainWidth: Integer read FMainWidth write FMainWidth;
    property MainHeight: Integer read FMainHeight write FMainHeight;
    property MainMaximized: Boolean read FMainMaximized write FMainMaximized;
    property TreeWidth: Integer read FTreeWidth write FTreeWidth;
    property PreviewHeight: Integer read FPreviewHeight write FPreviewHeight;
    property ShowPreview: Boolean read FShowPreview write FShowPreview;
    property ShowStatusBar: Boolean read FShowStatusBar write FShowStatusBar;
    property ShowToolbar: Boolean read FShowToolbar write FShowToolbar;
    property ToolbarPosition: string read FToolbarPosition write FToolbarPosition;
  end;
  
  // 涓婚閰嶇疆
  TThemeConfig = class(TConfigObject)
  private
    FThemeName: string;
    FDarkMode: Boolean;
    FPrimaryColor: string;
    FSecondaryColor: string;
    FBackgroundColor: string;
    FTextColor: string;
    FHighlightColor: string;
    FButtonRadius: Integer;
    FEnableShadows: Boolean;
    FCustomColors: TJSONObject;
    
    FJSONConfig: TJSONConfig;
    
    function ConvertColorToString(Color: TColor): string;
    function ConvertStringToColor(const ColorStr: string; Default: TColor): TColor;
  public
    constructor Create(const AID, AName, AFileName, ATypeID: string); override;
    destructor Destroy; override;
    
    // 鍔犺浇涓庝繚瀛?
    function Load: Boolean; override;
    function Save: Boolean; override;
    
    // 涓婚鎿嶄綔
    function ApplyTheme: Boolean;
    function GetColor(const Name: string; Default: TColor): TColor;
    procedure SetColor(const Name: string; Color: TColor);
    
    // 灞炴€ц闂?
    property ThemeName: string read FThemeName write FThemeName;
    property DarkMode: Boolean read FDarkMode write FDarkMode;
    property PrimaryColor: string read FPrimaryColor write FPrimaryColor;
    property SecondaryColor: string read FSecondaryColor write FSecondaryColor;
    property BackgroundColor: string read FBackgroundColor write FBackgroundColor;
    property TextColor: string read FTextColor write FTextColor;
    property HighlightColor: string read FHighlightColor write FHighlightColor;
    property ButtonRadius: Integer read FButtonRadius write FButtonRadius;
    property EnableShadows: Boolean read FEnableShadows write FEnableShadows;
  end;

  // 瀛椾綋閰嶇疆
  TFontConfig = class(TConfigObject)
  private
    FDefaultFontName: string;
    FDefaultFontSize: Integer;
    FTitleFontName: string;
    FTitleFontSize: Integer;
    FMenuFontName: string;
    FMenuFontSize: Integer;
    FButtonFontName: string;
    FButtonFontSize: Integer;
    FMonospaceFontName: string;
    FMonospaceFontSize: Integer;
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
    
    // 灞炴€ц闂?
    property DefaultFontName: string read FDefaultFontName write FDefaultFontName;
    property DefaultFontSize: Integer read FDefaultFontSize write FDefaultFontSize;
    property TitleFontName: string read FTitleFontName write FTitleFontName;
    property TitleFontSize: Integer read FTitleFontSize write FTitleFontSize;
    property MenuFontName: string read FMenuFontName write FMenuFontName;
    property MenuFontSize: Integer read FMenuFontSize write FMenuFontSize;
    property ButtonFontName: string read FButtonFontName write FButtonFontName;
    property ButtonFontSize: Integer read FButtonFontSize write FButtonFontSize;
    property MonospaceFontName: string read FMonospaceFontName write FMonospaceFontName;
    property MonospaceFontSize: Integer read FMonospaceFontSize write FMonospaceFontSize;
  end;

implementation

uses
  System.StrUtils, System.UITypes;

{ TLayoutConfig }

constructor TLayoutConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 榛樿鍊?
  FMainWidth := 1024;
  FMainHeight := 768;
  FMainMaximized := False;
  FTreeWidth := 250;
  FPreviewHeight := 200;
  FShowPreview := True;
  FShowStatusBar := True;
  FShowToolbar := True;
  FToolbarPosition := 'top';
  FSavedLayouts := TJSONArray.Create;
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
end;

destructor TLayoutConfig.Destroy;
begin
  if Assigned(FSavedLayouts) then
    FSavedLayouts.Free;
    
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

function TLayoutConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FMainWidth := FJSONConfig.ReadInteger('MainWindow.Width', FMainWidth);
    FMainHeight := FJSONConfig.ReadInteger('MainWindow.Height', FMainHeight);
    FMainMaximized := FJSONConfig.ReadBool('MainWindow.Maximized', FMainMaximized);
    FTreeWidth := FJSONConfig.ReadInteger('Layout.TreeWidth', FTreeWidth);
    FPreviewHeight := FJSONConfig.ReadInteger('Layout.PreviewHeight', FPreviewHeight);
    FShowPreview := FJSONConfig.ReadBool('Layout.ShowPreview', FShowPreview);
    FShowStatusBar := FJSONConfig.ReadBool('Layout.ShowStatusBar', FShowStatusBar);
    FShowToolbar := FJSONConfig.ReadBool('Layout.ShowToolbar', FShowToolbar);
    FToolbarPosition := FJSONConfig.ReadString('Layout.ToolbarPosition', FToolbarPosition);
    
    // 鍔犺浇淇濆瓨鐨勫竷灞€
    if Assigned(FSavedLayouts) then
      FSavedLayouts.Free;
      
    var JsonValue := FJSONConfig.GetJSONValue('SavedLayouts');
    if Assigned(JsonValue) and (JsonValue is TJSONArray) then
      FSavedLayouts := TJSONArray(JsonValue.Clone) as TJSONArray
    else
      FSavedLayouts := TJSONArray.Create;
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TLayoutConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteInteger('MainWindow.Width', FMainWidth);
    FJSONConfig.WriteInteger('MainWindow.Height', FMainHeight);
    FJSONConfig.WriteBool('MainWindow.Maximized', FMainMaximized);
    FJSONConfig.WriteInteger('Layout.TreeWidth', FTreeWidth);
    FJSONConfig.WriteInteger('Layout.PreviewHeight', FPreviewHeight);
    FJSONConfig.WriteBool('Layout.ShowPreview', FShowPreview);
    FJSONConfig.WriteBool('Layout.ShowStatusBar', FShowStatusBar);
    FJSONConfig.WriteBool('Layout.ShowToolbar', FShowToolbar);
    FJSONConfig.WriteString('Layout.ToolbarPosition', FToolbarPosition);
    
    // 淇濆瓨甯冨眬闆嗗悎
    if Assigned(FSavedLayouts) then
    begin
      // 鍒犻櫎鐜版湁鍊?
      FJSONConfig.RemoveValue('SavedLayouts');
      
      // 娣诲姞鏂板€?
      var Root := FJSONConfig.JSONObject;
      Root.AddPair('SavedLayouts', FSavedLayouts.Clone as TJSONArray);
    end;
    
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

procedure TLayoutConfig.SaveCurrentLayout(const Name: string);
var
  Layout: TJSONObject;
begin
  // 妫€鏌ュ悕绉版槸鍚﹀凡瀛樺湪
  for var i := 0 to FSavedLayouts.Count - 1 do
  begin
    var Item := FSavedLayouts.Items[i] as TJSONObject;
    if Item.GetValue<string>('Name') = Name then
    begin
      // 鍒犻櫎鐜版湁甯冨眬
      FSavedLayouts.Remove(i);
      Break;
    end;
  end;
  
  // 鍒涘缓鏂板竷灞€
  Layout := TJSONObject.Create;
  Layout.AddPair('Name', Name);
  Layout.AddPair('MainWidth', TJSONNumber.Create(FMainWidth));
  Layout.AddPair('MainHeight', TJSONNumber.Create(FMainHeight));
  Layout.AddPair('MainMaximized', TJSONBool.Create(FMainMaximized));
  Layout.AddPair('TreeWidth', TJSONNumber.Create(FTreeWidth));
  Layout.AddPair('PreviewHeight', TJSONNumber.Create(FPreviewHeight));
  Layout.AddPair('ShowPreview', TJSONBool.Create(FShowPreview));
  Layout.AddPair('ShowStatusBar', TJSONBool.Create(FShowStatusBar));
  Layout.AddPair('ShowToolbar', TJSONBool.Create(FShowToolbar));
  Layout.AddPair('ToolbarPosition', FToolbarPosition);
  
  // 娣诲姞鍒板竷灞€闆嗗悎
  FSavedLayouts.Add(Layout);
  
  // 鏍囪涓哄凡淇敼
  FModified := True;
end;

function TLayoutConfig.LoadSavedLayout(const Name: string): Boolean;
begin
  Result := False;
  
  // 鏌ユ壘甯冨眬
  for var i := 0 to FSavedLayouts.Count - 1 do
  begin
    var Item := FSavedLayouts.Items[i] as TJSONObject;
    if Item.GetValue<string>('Name') = Name then
    begin
      // 鍔犺浇甯冨眬
      FMainWidth := Item.GetValue<Integer>('MainWidth');
      FMainHeight := Item.GetValue<Integer>('MainHeight');
      FMainMaximized := Item.GetValue<Boolean>('MainMaximized');
      FTreeWidth := Item.GetValue<Integer>('TreeWidth');
      FPreviewHeight := Item.GetValue<Integer>('PreviewHeight');
      FShowPreview := Item.GetValue<Boolean>('ShowPreview');
      FShowStatusBar := Item.GetValue<Boolean>('ShowStatusBar');
      FShowToolbar := Item.GetValue<Boolean>('ShowToolbar');
      FToolbarPosition := Item.GetValue<string>('ToolbarPosition');
      
      // 鏍囪涓哄凡淇敼
      FModified := True;
      Result := True;
      Break;
    end;
  end;
end;

function TLayoutConfig.GetSavedLayouts: TArray<string>;
var
  Layouts: TList<string>;
begin
  Layouts := TList<string>.Create;
  try
    // 鎻愬彇甯冨眬鍚嶇О
    for var i := 0 to FSavedLayouts.Count - 1 do
    begin
      var Item := FSavedLayouts.Items[i] as TJSONObject;
      Layouts.Add(Item.GetValue<string>('Name'));
    end;
    
    Result := Layouts.ToArray;
  finally
    Layouts.Free;
  end;
end;

{ TThemeConfig }

constructor TThemeConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 榛樿鍊?
  FThemeName := 'Default';
  FDarkMode := False;
  FPrimaryColor := '#3498db';
  FSecondaryColor := '#2ecc71';
  FBackgroundColor := '#ffffff';
  FTextColor := '#333333';
  FHighlightColor := '#e74c3c';
  FButtonRadius := 4;
  FEnableShadows := True;
  FCustomColors := TJSONObject.Create;
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
end;

destructor TThemeConfig.Destroy;
begin
  if Assigned(FCustomColors) then
    FCustomColors.Free;
    
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

function TThemeConfig.ConvertColorToString(Color: TColor): string;
begin
  // 杞崲棰滆壊涓哄崄鍏繘鍒跺瓧绗︿覆
  Result := Format('#%.6x', [Color and $FFFFFF]);
end;

function TThemeConfig.ConvertStringToColor(const ColorStr: string; Default: TColor): TColor;
var
  HexColor: string;
begin
  // 妫€鏌ユ牸寮?
  if (Length(ColorStr) >= 7) and (ColorStr[1] = '#') then
  begin
    HexColor := '$' + Copy(ColorStr, 6, 2) + Copy(ColorStr, 4, 2) + Copy(ColorStr, 2, 2);
    try
      Result := StrToInt(HexColor);
    except
      Result := Default;
    end;
  end
  else
    Result := Default;
end;

function TThemeConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FThemeName := FJSONConfig.ReadString('ThemeName', FThemeName);
    FDarkMode := FJSONConfig.ReadBool('DarkMode', FDarkMode);
    FPrimaryColor := FJSONConfig.ReadString('Colors.Primary', FPrimaryColor);
    FSecondaryColor := FJSONConfig.ReadString('Colors.Secondary', FSecondaryColor);
    FBackgroundColor := FJSONConfig.ReadString('Colors.Background', FBackgroundColor);
    FTextColor := FJSONConfig.ReadString('Colors.Text', FTextColor);
    FHighlightColor := FJSONConfig.ReadString('Colors.Highlight', FHighlightColor);
    FButtonRadius := FJSONConfig.ReadInteger('Style.ButtonRadius', FButtonRadius);
    FEnableShadows := FJSONConfig.ReadBool('Style.EnableShadows', FEnableShadows);
    
    // 鍔犺浇鑷畾涔夐鑹?
    if Assigned(FCustomColors) then
      FCustomColors.Free;
      
    var JsonValue := FJSONConfig.GetJSONValue('CustomColors');
    if Assigned(JsonValue) and (JsonValue is TJSONObject) then
      FCustomColors := TJSONObject(JsonValue.Clone) as TJSONObject
    else
      FCustomColors := TJSONObject.Create;
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TThemeConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteString('ThemeName', FThemeName);
    FJSONConfig.WriteBool('DarkMode', FDarkMode);
    FJSONConfig.WriteString('Colors.Primary', FPrimaryColor);
    FJSONConfig.WriteString('Colors.Secondary', FSecondaryColor);
    FJSONConfig.WriteString('Colors.Background', FBackgroundColor);
    FJSONConfig.WriteString('Colors.Text', FTextColor);
    FJSONConfig.WriteString('Colors.Highlight', FHighlightColor);
    FJSONConfig.WriteInteger('Style.ButtonRadius', FButtonRadius);
    FJSONConfig.WriteBool('Style.EnableShadows', FEnableShadows);
    
    // 淇濆瓨鑷畾涔夐鑹?
    if Assigned(FCustomColors) then
    begin
      // 鍒犻櫎鐜版湁鍊?
      FJSONConfig.RemoveValue('CustomColors');
      
      // 娣诲姞鏂板€?
      var Root := FJSONConfig.JSONObject;
      Root.AddPair('CustomColors', FCustomColors.Clone as TJSONObject);
    end;
    
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

function TThemeConfig.ApplyTheme: Boolean;
begin
  // 瀹為檯搴旂敤涓紝杩欓噷搴旇瀹炵幇灏嗕富棰樺簲鐢ㄥ埌绋嬪簭鐣岄潰鐨勯€昏緫
  // 鍑轰簬婕旂ず鐩殑锛岃繖閲岀洿鎺ヨ繑鍥炴垚鍔?
  Result := True;
end;

function TThemeConfig.GetColor(const Name: string; Default: TColor): TColor;
var
  ColorStr: string;
begin
  // 妫€鏌ラ瀹氫箟棰滆壊
  if SameText(Name, 'Primary') then
    ColorStr := FPrimaryColor
  else if SameText(Name, 'Secondary') then
    ColorStr := FSecondaryColor
  else if SameText(Name, 'Background') then
    ColorStr := FBackgroundColor
  else if SameText(Name, 'Text') then
    ColorStr := FTextColor
  else if SameText(Name, 'Highlight') then
    ColorStr := FHighlightColor
  else
  begin
    // 妫€鏌ヨ嚜瀹氫箟棰滆壊
    var JsonValue: TJSONValue;
    if Assigned(FCustomColors) and FCustomColors.TryGetValue(Name, JsonValue) and
       (JsonValue is TJSONString) then
      ColorStr := TJSONString(JsonValue).Value
    else
      ColorStr := '';
  end;
  
  // 杞崲涓洪鑹?
  if ColorStr <> '' then
    Result := ConvertStringToColor(ColorStr, Default)
  else
    Result := Default;
end;

procedure TThemeConfig.SetColor(const Name: string; Color: TColor);
var
  ColorStr: string;
begin
  // 杞崲涓哄瓧绗︿覆
  ColorStr := ConvertColorToString(Color);
  
  // 璁剧疆棰勫畾涔夐鑹?
  if SameText(Name, 'Primary') then
    FPrimaryColor := ColorStr
  else if SameText(Name, 'Secondary') then
    FSecondaryColor := ColorStr
  else if SameText(Name, 'Background') then
    FBackgroundColor := ColorStr
  else if SameText(Name, 'Text') then
    FTextColor := ColorStr
  else if SameText(Name, 'Highlight') then
    FHighlightColor := ColorStr
  else
  begin
    // 璁剧疆鑷畾涔夐鑹?
    if Assigned(FCustomColors) then
    begin
      // 鍒犻櫎鐜版湁鍊?
      if FCustomColors.TryGetValue(Name, TJSONValue(nil)) then
        FCustomColors.RemovePair(Name);
        
      // 娣诲姞鏂板€?
      FCustomColors.AddPair(Name, ColorStr);
    end;
  end;
  
  // 鏍囪涓哄凡淇敼
  FModified := True;
end;

{ TFontConfig }

constructor TFontConfig.Create(const AID, AName, AFileName, ATypeID: string);
begin
  inherited Create(AID, AName, AFileName, ATypeID);
  
  // 榛樿鍊?
  FDefaultFontName := 'Segoe UI';
  FDefaultFontSize := 9;
  FTitleFontName := 'Segoe UI';
  FTitleFontSize := 12;
  FMenuFontName := 'Segoe UI';
  FMenuFontSize := 9;
  FButtonFontName := 'Segoe UI';
  FButtonFontSize := 9;
  FMonospaceFontName := 'Consolas';
  FMonospaceFontSize := 10;
  
  // 鍒涘缓JSON閰嶇疆
  FJSONConfig := nil;
end;

destructor TFontConfig.Destroy;
begin
  if Assigned(FJSONConfig) then
    FJSONConfig.Free;
    
  inherited;
end;

function TFontConfig.Load: Boolean;
begin
  Result := False;
  
  try
    // 鍒涘缓鎴栬幏鍙朖SON閰嶇疆
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 浠嶫SON鍔犺浇鍊?
    FDefaultFontName := FJSONConfig.ReadString('DefaultFont.Name', FDefaultFontName);
    FDefaultFontSize := FJSONConfig.ReadInteger('DefaultFont.Size', FDefaultFontSize);
    FTitleFontName := FJSONConfig.ReadString('TitleFont.Name', FTitleFontName);
    FTitleFontSize := FJSONConfig.ReadInteger('TitleFont.Size', FTitleFontSize);
    FMenuFontName := FJSONConfig.ReadString('MenuFont.Name', FMenuFontName);
    FMenuFontSize := FJSONConfig.ReadInteger('MenuFont.Size', FMenuFontSize);
    FButtonFontName := FJSONConfig.ReadString('ButtonFont.Name', FButtonFontName);
    FButtonFontSize := FJSONConfig.ReadInteger('ButtonFont.Size', FButtonFontSize);
    FMonospaceFontName := FJSONConfig.ReadString('MonospaceFont.Name', FMonospaceFontName);
    FMonospaceFontSize := FJSONConfig.ReadInteger('MonospaceFont.Size', FMonospaceFontSize);
    
    Result := True;
  except
    on E: Exception do
    begin
      // 璁板綍閿欒
      Result := False;
    end;
  end;
end;

function TFontConfig.Save: Boolean;
begin
  Result := False;
  
  try
    // 纭繚JSON閰嶇疆宸插垱寤?
    if not Assigned(FJSONConfig) then
      FJSONConfig := TJSONConfig.Create(FFileName);
      
    // 淇濆瓨鍊煎埌JSON
    FJSONConfig.WriteString('DefaultFont.Name', FDefaultFontName);
    FJSONConfig.WriteInteger('DefaultFont.Size', FDefaultFontSize);
    FJSONConfig.WriteString('TitleFont.Name', FTitleFontName);
    FJSONConfig.WriteInteger('TitleFont.Size', FTitleFontSize);
    FJSONConfig.WriteString('MenuFont.Name', FMenuFontName);
    FJSONConfig.WriteInteger('MenuFont.Size', FMenuFontSize);
    FJSONConfig.WriteString('ButtonFont.Name', FButtonFontName);
    FJSONConfig.WriteInteger('ButtonFont.Size', FButtonFontSize);
    FJSONConfig.WriteString('MonospaceFont.Name', FMonospaceFontName);
    FJSONConfig.WriteInteger('MonospaceFont.Size', FMonospaceFontSize);
    
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

function TFontConfig.Validate: Boolean;
begin
  Result := Length(GetValidationErrors) = 0;
end;

function TFontConfig.GetValidationErrors: TArray<string>;
var
  Errors: TList<string>;
begin
  Errors := TList<string>.Create;
  try
    // 楠岃瘉瀛椾綋鍚嶇О
    if FDefaultFontName = '' then
      Errors.Add('榛樿瀛椾綋鍚嶇О涓嶈兘涓虹┖');
      
    if FTitleFontName = '' then
      Errors.Add('鏍囬瀛椾綋鍚嶇О涓嶈兘涓虹┖');
      
    if FMenuFontName = '' then
      Errors.Add('鑿滃崟瀛椾綋鍚嶇О涓嶈兘涓虹┖');
      
    if FButtonFontName = '' then
      Errors.Add('鎸夐挳瀛椾綋鍚嶇О涓嶈兘涓虹┖');
      
    if FMonospaceFontName = '' then
      Errors.Add('绛夊瀛椾綋鍚嶇О涓嶈兘涓虹┖');
    
    // 楠岃瘉瀛椾綋澶у皬
    if FDefaultFontSize <= 0 then
      Errors.Add('榛樿瀛椾綋澶у皬蹇呴』澶т簬0');
      
    if FTitleFontSize <= 0 then
      Errors.Add('鏍囬瀛椾綋澶у皬蹇呴』澶т簬0');
      
    if FMenuFontSize <= 0 then
      Errors.Add('鑿滃崟瀛椾綋澶у皬蹇呴』澶т簬0');
      
    if FButtonFontSize <= 0 then
      Errors.Add('鎸夐挳瀛椾綋澶у皬蹇呴』澶т簬0');
      
    if FMonospaceFontSize <= 0 then
      Errors.Add('绛夊瀛椾綋澶у皬蹇呴』澶т簬0');
    
    Result := Errors.ToArray;
  finally
    Errors.Free;
  end;
end;

end. 