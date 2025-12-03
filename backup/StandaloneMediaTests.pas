unit StandaloneMediaTests;

interface

uses
  TestFramework;

type
  { 妯℃嫙濯掍綋閰嶇疆瀵硅薄鍩虹被 }
  TMockConfigObject = class
  private
    FID: string;
    FName: string;
    FFileName: string;
  public
    constructor Create(const AID, AName, AFileName: string);
    
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property FileName: string read FFileName write FFileName;
  end;
  
  { 妯℃嫙鍥剧墖鑳屾櫙閰嶇疆 }
  TMockImageBackground = class(TMockConfigObject)
  private
    FImagePath: string;
    FOpacity: Double;
    FFitMode: string;
  public
    constructor Create(const AID, AName, AFileName: string);
    
    function Validate: Boolean;
    
    property ImagePath: string read FImagePath write FImagePath;
    property Opacity: Double read FOpacity write FOpacity;
    property FitMode: string read FFitMode write FFitMode;
  end;
  
  { 妯℃嫙鎶藉眽闈㈡澘閰嶇疆 }
  TMockDrawerConfig = class(TMockConfigObject)
  private
    FPosition: string;
    FWidth: Integer;
    FHeight: Integer;
  public
    constructor Create(const AID, AName, AFileName: string);
    
    function Validate: Boolean;
    
    property Position: string read FPosition write FPosition;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
  end;
  
  { 妯℃嫙瑙嗛鐗囨閰嶇疆 }
  TMockVideoClipConfig = class(TMockConfigObject)
  private
    FBackground: TMockImageBackground;
    FLength: Double;
    FAudioPath: string;
    FAudioVolume: Double;
  public
    constructor Create(const AID, AName, AFileName: string);
    destructor Destroy; override;
    
    function Validate: Boolean;
    
    property Background: TMockImageBackground read FBackground;
    property Length: Double read FLength write FLength;
    property AudioPath: string read FAudioPath write FAudioPath;
    property AudioVolume: Double read FAudioVolume write FAudioVolume;
  end;
  
  { 鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯 }
  TImageBackgroundTests = class(TTestCase)
  private
    FBackground: TMockImageBackground;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestCreate;
    procedure TestProperties;
    procedure TestValidation;
    procedure Run; override;
  end;
  
  { 鎶藉眽闈㈡澘閰嶇疆娴嬭瘯 }
  TDrawerConfigTests = class(TTestCase)
  private
    FDrawer: TMockDrawerConfig;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestCreate;
    procedure TestProperties;
    procedure TestValidation;
    procedure Run; override;
  end;
  
  { 瑙嗛鐗囨閰嶇疆娴嬭瘯 }
  TVideoClipConfigTests = class(TTestCase)
  private
    FVideoClip: TMockVideoClipConfig;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    procedure TestCreate;
    procedure TestProperties;
    procedure TestValidation;
    procedure Run; override;
  end;

implementation

{ TMockConfigObject }

constructor TMockConfigObject.Create(const AID, AName, AFileName: string);
begin
  inherited Create;
  FID := AID;
  FName := AName;
  FFileName := AFileName;
end;

{ TMockImageBackground }

constructor TMockImageBackground.Create(const AID, AName, AFileName: string);
begin
  inherited Create(AID, AName, AFileName);
  FImagePath := '';
  FOpacity := 1.0;
  FFitMode := 'stretch';
end;

function TMockImageBackground.Validate: Boolean;
begin
  Result := (FImagePath <> '') and (FOpacity >= 0.0) and (FOpacity <= 1.0);
end;

{ TMockDrawerConfig }

constructor TMockDrawerConfig.Create(const AID, AName, AFileName: string);
begin
  inherited Create(AID, AName, AFileName);
  FPosition := 'left';
  FWidth := 300;
  FHeight := 600;
end;

function TMockDrawerConfig.Validate: Boolean;
begin
  Result := (FPosition = 'left') or (FPosition = 'right') or 
            (FPosition = 'top') or (FPosition = 'bottom') and 
            (FWidth > 0) and (FHeight > 0);
end;

{ TMockVideoClipConfig }

constructor TMockVideoClipConfig.Create(const AID, AName, AFileName: string);
begin
  inherited Create(AID, AName, AFileName);
  FBackground := TMockImageBackground.Create('bg-' + AID, '鑳屾櫙', '');
  FLength := 10.0;
  FAudioPath := '';
  FAudioVolume := 1.0;
end;

destructor TMockVideoClipConfig.Destroy;
begin
  FBackground.Free;
  inherited;
end;

function TMockVideoClipConfig.Validate: Boolean;
begin
  Result := FBackground.Validate and 
            (FLength > 0) and
            (FAudioVolume >= 0.0) and (FAudioVolume <= 1.0);
end;

{ TImageBackgroundTests }

constructor TImageBackgroundTests.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TImageBackgroundTests.SetUp;
begin
  WriteLn('璁剧疆鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯鐜');
  FBackground := TMockImageBackground.Create('test-bg', '娴嬭瘯鑳屾櫙', 'test-bg.json');
end;

procedure TImageBackgroundTests.TearDown;
begin
  WriteLn('娓呯悊鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯鐜');
  FBackground.Free;
end;

procedure TImageBackgroundTests.TestCreate;
begin
  WriteLn('娴嬭瘯鍥剧墖鑳屾櫙閰嶇疆鍒涘缓');
  
  CheckNotNull(FBackground, '鍒涘缓鑳屾櫙閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-bg', FBackground.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯鑳屾櫙', FBackground.Name, '鍚嶇О涓嶅尮閰?);
  CheckEquals('test-bg.json', FBackground.FileName, '鏂囦欢鍚嶄笉鍖归厤');
end;

procedure TImageBackgroundTests.TestProperties;
begin
  WriteLn('娴嬭瘯鍥剧墖鑳屾櫙閰嶇疆灞炴€?);
  
  // 娴嬭瘯榛樿鍊?  CheckEquals('stretch', FBackground.FitMode, 'FitMode榛樿鍊间笉鍖归厤');
  CheckEquals(1.0, FBackground.Opacity, 0.001, 'Opacity榛樿鍊间笉鍖归厤');
  CheckEquals('', FBackground.ImagePath, 'ImagePath榛樿鍊间笉鍖归厤');
  
  // 娴嬭瘯璁剧疆灞炴€?  FBackground.ImagePath := 'backgrounds/test.jpg';
  CheckEquals('backgrounds/test.jpg', FBackground.ImagePath, 'ImagePath璁剧疆澶辫触');
  
  FBackground.Opacity := 0.5;
  CheckEquals(0.5, FBackground.Opacity, 0.001, 'Opacity璁剧疆澶辫触');
  
  FBackground.FitMode := 'fill';
  CheckEquals('fill', FBackground.FitMode, 'FitMode璁剧疆澶辫触');
end;

procedure TImageBackgroundTests.TestValidation;
begin
  WriteLn('娴嬭瘯鍥剧墖鑳屾櫙閰嶇疆楠岃瘉');
  
  // 鍒濆鐘舵€佸簲璇ユ棤鏁堬紙娌℃湁璁剧疆鍥剧墖璺緞锛?  CheckFalse(FBackground.Validate, '鍒濆鐘舵€侀獙璇佺粨鏋滈敊璇?);
  
  // 璁剧疆鏈夋晥璺緞鍚庡簲璇ユ湁鏁?  FBackground.ImagePath := 'backgrounds/test.jpg';
  CheckTrue(FBackground.Validate, '璁剧疆鏈夋晥璺緞鍚庨獙璇佸け璐?);
  
  // 璁剧疆鏃犳晥閫忔槑搴﹀悗搴旇鏃犳晥
  FBackground.Opacity := 1.5;  // 瓒呭嚭鑼冨洿
  CheckFalse(FBackground.Validate, '鏃犳晥閫忔槑搴﹂獙璇侀敊璇?);
  
  // 鎭㈠鍒版湁鏁堢姸鎬?  FBackground.Opacity := 0.8;
  CheckTrue(FBackground.Validate, '鎭㈠鏈夋晥鐘舵€佸悗楠岃瘉澶辫触');
end;

procedure TImageBackgroundTests.Run;
begin
  SetUp;
  try
    WriteLn('鎵ц鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯: ', TestName);
    TestCreate;
    TestProperties;
    TestValidation;
  finally
    TearDown;
  end;
end;

{ TDrawerConfigTests }

constructor TDrawerConfigTests.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TDrawerConfigTests.SetUp;
begin
  WriteLn('璁剧疆鎶藉眽闈㈡澘閰嶇疆娴嬭瘯鐜');
  FDrawer := TMockDrawerConfig.Create('test-drawer', '娴嬭瘯鎶藉眽', 'test-drawer.json');
end;

procedure TDrawerConfigTests.TearDown;
begin
  WriteLn('娓呯悊鎶藉眽闈㈡澘閰嶇疆娴嬭瘯鐜');
  FDrawer.Free;
end;

procedure TDrawerConfigTests.TestCreate;
begin
  WriteLn('娴嬭瘯鎶藉眽闈㈡澘閰嶇疆鍒涘缓');
  
  CheckNotNull(FDrawer, '鍒涘缓鎶藉眽閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-drawer', FDrawer.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯鎶藉眽', FDrawer.Name, '鍚嶇О涓嶅尮閰?);
  CheckEquals('test-drawer.json', FDrawer.FileName, '鏂囦欢鍚嶄笉鍖归厤');
end;

procedure TDrawerConfigTests.TestProperties;
begin
  WriteLn('娴嬭瘯鎶藉眽闈㈡澘閰嶇疆灞炴€?);
  
  // 娴嬭瘯榛樿鍊?  CheckEquals('left', FDrawer.Position, 'Position榛樿鍊间笉鍖归厤');
  CheckEquals(300, FDrawer.Width, 'Width榛樿鍊间笉鍖归厤');
  CheckEquals(600, FDrawer.Height, 'Height榛樿鍊间笉鍖归厤');
  
  // 娴嬭瘯璁剧疆灞炴€?  FDrawer.Position := 'right';
  CheckEquals('right', FDrawer.Position, 'Position璁剧疆澶辫触');
  
  FDrawer.Width := 400;
  CheckEquals(400, FDrawer.Width, 'Width璁剧疆澶辫触');
  
  FDrawer.Height := 800;
  CheckEquals(800, FDrawer.Height, 'Height璁剧疆澶辫触');
end;

procedure TDrawerConfigTests.TestValidation;
begin
  WriteLn('娴嬭瘯鎶藉眽闈㈡澘閰嶇疆楠岃瘉');
  
  // 鍒濆鐘舵€佸簲璇ユ湁鏁?  CheckTrue(FDrawer.Validate, '鍒濆鐘舵€侀獙璇佺粨鏋滈敊璇?);
  
  // 璁剧疆鏃犳晥浣嶇疆鍚庡簲璇ユ棤鏁?  FDrawer.Position := 'center';  // 鏃犳晥浣嶇疆
  CheckFalse(FDrawer.Validate, '鏃犳晥浣嶇疆楠岃瘉閿欒');
  
  // 鎭㈠鍒版湁鏁堜綅缃?  FDrawer.Position := 'top';
  CheckTrue(FDrawer.Validate, '鎭㈠鏈夋晥浣嶇疆鍚庨獙璇佸け璐?);
  
  // 璁剧疆鏃犳晥灏哄鍚庡簲璇ユ棤鏁?  FDrawer.Width := -100;  // 璐熷€?  CheckFalse(FDrawer.Validate, '鏃犳晥瀹藉害楠岃瘉閿欒');
  
  // 鎭㈠鍒版湁鏁堢姸鎬?  FDrawer.Width := 200;
  CheckTrue(FDrawer.Validate, '鎭㈠鏈夋晥鐘舵€佸悗楠岃瘉澶辫触');
end;

procedure TDrawerConfigTests.Run;
begin
  SetUp;
  try
    WriteLn('鎵ц鎶藉眽闈㈡澘閰嶇疆娴嬭瘯: ', TestName);
    TestCreate;
    TestProperties;
    TestValidation;
  finally
    TearDown;
  end;
end;

{ TVideoClipConfigTests }

constructor TVideoClipConfigTests.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TVideoClipConfigTests.SetUp;
begin
  WriteLn('璁剧疆瑙嗛鐗囨閰嶇疆娴嬭瘯鐜');
  FVideoClip := TMockVideoClipConfig.Create('test-clip', '娴嬭瘯瑙嗛鐗囨', 'test-clip.json');
end;

procedure TVideoClipConfigTests.TearDown;
begin
  WriteLn('娓呯悊瑙嗛鐗囨閰嶇疆娴嬭瘯鐜');
  FVideoClip.Free;
end;

procedure TVideoClipConfigTests.TestCreate;
begin
  WriteLn('娴嬭瘯瑙嗛鐗囨閰嶇疆鍒涘缓');
  
  CheckNotNull(FVideoClip, '鍒涘缓瑙嗛鐗囨閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-clip', FVideoClip.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯瑙嗛鐗囨', FVideoClip.Name, '鍚嶇О涓嶅尮閰?);
  CheckEquals('test-clip.json', FVideoClip.FileName, '鏂囦欢鍚嶄笉鍖归厤');
  
  // 妫€鏌ヨ儗鏅璞?  CheckNotNull(FVideoClip.Background, '鑳屾櫙瀵硅薄鏈垱寤?);
  CheckEquals('bg-test-clip', FVideoClip.Background.ID, '鑳屾櫙ID涓嶅尮閰?);
end;

procedure TVideoClipConfigTests.TestProperties;
begin
  WriteLn('娴嬭瘯瑙嗛鐗囨閰嶇疆灞炴€?);
  
  // 娴嬭瘯榛樿鍊?  CheckEquals(10.0, FVideoClip.Length, 0.001, 'Length榛樿鍊间笉鍖归厤');
  CheckEquals('', FVideoClip.AudioPath, 'AudioPath榛樿鍊间笉鍖归厤');
  CheckEquals(1.0, FVideoClip.AudioVolume, 0.001, 'AudioVolume榛樿鍊间笉鍖归厤');
  
  // 娴嬭瘯璁剧疆灞炴€?  FVideoClip.Length := 15.5;
  CheckEquals(15.5, FVideoClip.Length, 0.001, 'Length璁剧疆澶辫触');
  
  FVideoClip.AudioPath := 'audio/test.mp3';
  CheckEquals('audio/test.mp3', FVideoClip.AudioPath, 'AudioPath璁剧疆澶辫触');
  
  FVideoClip.AudioVolume := 0.7;
  CheckEquals(0.7, FVideoClip.AudioVolume, 0.001, 'AudioVolume璁剧疆澶辫触');
  
  // 娴嬭瘯鑳屾櫙灞炴€?  FVideoClip.Background.ImagePath := 'backgrounds/clip-bg.jpg';
  CheckEquals('backgrounds/clip-bg.jpg', FVideoClip.Background.ImagePath, 'Background.ImagePath璁剧疆澶辫触');
end;

procedure TVideoClipConfigTests.TestValidation;
begin
  WriteLn('娴嬭瘯瑙嗛鐗囨閰嶇疆楠岃瘉');
  
  // 鍒濆鐘舵€佸簲璇ユ棤鏁堬紙鑳屾櫙娌℃湁璁剧疆鍥剧墖璺緞锛?  CheckFalse(FVideoClip.Validate, '鍒濆鐘舵€侀獙璇佺粨鏋滈敊璇?);
  
  // 璁剧疆鏈夋晥鑳屾櫙鍚庢湁鏁?  FVideoClip.Background.ImagePath := 'backgrounds/clip-bg.jpg';
  CheckTrue(FVideoClip.Validate, '璁剧疆鏈夋晥鑳屾櫙鍚庨獙璇佸け璐?);
  
  // 璁剧疆鏃犳晥闀垮害鍚庢棤鏁?  FVideoClip.Length := -5.0;  // 璐熷€?  CheckFalse(FVideoClip.Validate, '鏃犳晥闀垮害楠岃瘉閿欒');
  
  // 鎭㈠鏈夋晥闀垮害
  FVideoClip.Length := 10.0;
  CheckTrue(FVideoClip.Validate, '鎭㈠鏈夋晥闀垮害鍚庨獙璇佸け璐?);
  
  // 璁剧疆鏃犳晥闊抽噺鍚庢棤鏁?  FVideoClip.AudioVolume := 1.5;  // 瓒呭嚭鑼冨洿
  CheckFalse(FVideoClip.Validate, '鏃犳晥闊抽噺楠岃瘉閿欒');
  
  // 鎭㈠鏈夋晥闊抽噺
  FVideoClip.AudioVolume := 0.8;
  CheckTrue(FVideoClip.Validate, '鎭㈠鏈夋晥闊抽噺鍚庨獙璇佸け璐?);
end;

procedure TVideoClipConfigTests.Run;
begin
  SetUp;
  try
    WriteLn('鎵ц瑙嗛鐗囨閰嶇疆娴嬭瘯: ', TestName);
    TestCreate;
    TestProperties;
    TestValidation;
  finally
    TearDown;
  end;
end;

initialization
  RegisterTestSuite(TImageBackgroundTests, '鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯');
  RegisterTestSuite(TDrawerConfigTests, '鎶藉眽闈㈡澘閰嶇疆娴嬭瘯');
  RegisterTestSuite(TVideoClipConfigTests, '瑙嗛鐗囨閰嶇疆娴嬭瘯');
end. 