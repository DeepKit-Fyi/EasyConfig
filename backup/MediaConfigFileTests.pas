unit MediaConfigFileTests;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  TestFramework,
  ConfigManager, ConfigTypes, JSONConfig;

type
  TMediaConfigFileTest = class(TTestCase)
  private
    FConfigManager: TConfigManager;
    FConfigDir: string;
    procedure CreateTestConfigFiles;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(const ATestName: string); override;
    
    // 娴嬭瘯鏂规硶
    procedure TestConfigFilesExist;
    procedure TestLoadImageConfig;
    procedure TestLoadVideoConfig;
    procedure TestSaveConfig;
    
    procedure Run; override;
  end;

implementation

{ TMediaConfigFileTest }

constructor TMediaConfigFileTest.Create(const ATestName: string);
begin
  inherited Create(ATestName);
end;

procedure TMediaConfigFileTest.SetUp;
begin
  WriteLn('璁剧疆濯掍綋閰嶇疆鏂囦欢娴嬭瘯鐜');
  
  // 鍒涘缓娴嬭瘯閰嶇疆鐩綍
  FConfigDir := 'test_media_config';
  if not TDirectory.Exists(FConfigDir) then
    TDirectory.CreateDirectory(FConfigDir);
  
  // 鍒涘缓閰嶇疆绠＄悊鍣?
  FConfigManager := TConfigManager.Create(FConfigDir);
  
  // 鍒涘缓娴嬭瘯閰嶇疆鏂囦欢
  CreateTestConfigFiles;
end;

procedure TMediaConfigFileTest.TearDown;
begin
  WriteLn('娓呯悊濯掍綋閰嶇疆鏂囦欢娴嬭瘯鐜');
  
  // 閲婃斁閰嶇疆绠＄悊鍣?
  FConfigManager.Free;
end;

procedure TMediaConfigFileTest.CreateTestConfigFiles;
var
  ImageConfig: TJSONConfig;
  VideoConfig: TJSONConfig;
begin
  // 鍒涘缓鍥剧墖鑳屾櫙閰嶇疆鏂囦欢
  ImageConfig := TJSONConfig.Create(TPath.Combine(FConfigDir, 'image_background.json'));
  try
    // 娣诲姞鍩烘湰灞炴€?
    ImageConfig.WriteString('id', 'bg-001');
    ImageConfig.WriteString('name', '娴嬭瘯鑳屾櫙');
    ImageConfig.WriteString('type', 'ImageBackground');
    
    // 娣诲姞鍥剧墖鐗规湁灞炴€?
    ImageConfig.WriteString('imagePath', 'assets/images/background.jpg');
    ImageConfig.WriteFloat('opacity', 0.8);
    ImageConfig.WriteString('fitMode', 'fill');
    
    // 淇濆瓨閰嶇疆
    ImageConfig.Save;
  finally
    ImageConfig.Free;
  end;
  
  // 鍒涘缓瑙嗛鐗囨閰嶇疆鏂囦欢
  VideoConfig := TJSONConfig.Create(TPath.Combine(FConfigDir, 'video_clip.json'));
  try
    // 娣诲姞鍩烘湰灞炴€?
    VideoConfig.WriteString('id', 'clip-001');
    VideoConfig.WriteString('name', '娴嬭瘯瑙嗛鐗囨');
    VideoConfig.WriteString('type', 'VideoClip');
    
    // 娣诲姞瑙嗛鐗规湁灞炴€?
    VideoConfig.WriteFloat('length', 15.5);
    VideoConfig.WriteString('audioPath', 'assets/audio/background.mp3');
    VideoConfig.WriteFloat('audioVolume', 0.7);
    
    // 娣诲姞鑳屾櫙瀵硅薄
    VideoConfig.WriteString('background.id', 'bg-clip-001');
    VideoConfig.WriteString('background.name', '瑙嗛鑳屾櫙');
    VideoConfig.WriteString('background.imagePath', 'assets/images/clip_bg.jpg');
    VideoConfig.WriteFloat('background.opacity', 0.9);
    VideoConfig.WriteString('background.fitMode', 'stretch');
    
    // 淇濆瓨閰嶇疆
    VideoConfig.Save;
  finally
    VideoConfig.Free;
  end;
end;

procedure TMediaConfigFileTest.TestConfigFilesExist;
begin
  WriteLn('娴嬭瘯閰嶇疆鏂囦欢鏄惁瀛樺湪');
  
  // 妫€鏌ュ浘鐗囪儗鏅厤缃枃浠?
  CheckTrue(TFile.Exists(TPath.Combine(FConfigDir, 'image_background.json')), 
            '鍥剧墖鑳屾櫙閰嶇疆鏂囦欢涓嶅瓨鍦?);
            
  // 妫€鏌ヨ棰戠墖娈甸厤缃枃浠?
  CheckTrue(TFile.Exists(TPath.Combine(FConfigDir, 'video_clip.json')), 
            '瑙嗛鐗囨閰嶇疆鏂囦欢涓嶅瓨鍦?);
end;

procedure TMediaConfigFileTest.TestLoadImageConfig;
var
  JsonConfig: TJSONConfig;
  ID, Name, Type_, ImagePath, FitMode: string;
  Opacity: Double;
begin
  WriteLn('娴嬭瘯鍔犺浇鍥剧墖鑳屾櫙閰嶇疆');
  
  JsonConfig := FConfigManager.GetJSONFile('image_background.json');
  
  // 妫€鏌ユ槸鍚︽垚鍔熻幏鍙栭厤缃?
  CheckNotNull(JsonConfig, '鏃犳硶鑾峰彇鍥剧墖鑳屾櫙閰嶇疆');
  
  // 璇诲彇骞堕獙璇佸睘鎬?
  ID := JsonConfig.ReadString('id', '');
  Name := JsonConfig.ReadString('name', '');
  Type_ := JsonConfig.ReadString('type', '');
  ImagePath := JsonConfig.ReadString('imagePath', '');
  Opacity := JsonConfig.ReadFloat('opacity', 0);
  FitMode := JsonConfig.ReadString('fitMode', '');
  
  CheckEquals('bg-001', ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯鑳屾櫙', Name, '鍚嶇О涓嶅尮閰?);
  CheckEquals('ImageBackground', Type_, '绫诲瀷涓嶅尮閰?);
  CheckEquals('assets/images/background.jpg', ImagePath, '鍥剧墖璺緞涓嶅尮閰?);
  CheckEquals(0.8, Opacity, 0.001, '閫忔槑搴︿笉鍖归厤');
  CheckEquals('fill', FitMode, '濉厖妯″紡涓嶅尮閰?);
end;

procedure TMediaConfigFileTest.TestLoadVideoConfig;
var
  JsonConfig: TJSONConfig;
  ID, Name, Type_, AudioPath, BgID, BgName, BgImagePath, BgFitMode: string;
  Length, AudioVolume, BgOpacity: Double;
begin
  WriteLn('娴嬭瘯鍔犺浇瑙嗛鐗囨閰嶇疆');
  
  JsonConfig := FConfigManager.GetJSONFile('video_clip.json');
  
  // 妫€鏌ユ槸鍚︽垚鍔熻幏鍙栭厤缃?
  CheckNotNull(JsonConfig, '鏃犳硶鑾峰彇瑙嗛鐗囨閰嶇疆');
  
  // 璇诲彇骞堕獙璇佸睘鎬?
  ID := JsonConfig.ReadString('id', '');
  Name := JsonConfig.ReadString('name', '');
  Type_ := JsonConfig.ReadString('type', '');
  Length := JsonConfig.ReadFloat('length', 0);
  AudioPath := JsonConfig.ReadString('audioPath', '');
  AudioVolume := JsonConfig.ReadFloat('audioVolume', 0);
  
  // 璇诲彇鑳屾櫙瀵硅薄灞炴€?
  BgID := JsonConfig.ReadString('background.id', '');
  BgName := JsonConfig.ReadString('background.name', '');
  BgImagePath := JsonConfig.ReadString('background.imagePath', '');
  BgOpacity := JsonConfig.ReadFloat('background.opacity', 0);
  BgFitMode := JsonConfig.ReadString('background.fitMode', '');
  
  // 楠岃瘉瑙嗛灞炴€?
  CheckEquals('clip-001', ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯瑙嗛鐗囨', Name, '鍚嶇О涓嶅尮閰?);
  CheckEquals('VideoClip', Type_, '绫诲瀷涓嶅尮閰?);
  CheckEquals(15.5, Length, 0.001, '闀垮害涓嶅尮閰?);
  CheckEquals('assets/audio/background.mp3', AudioPath, '闊抽璺緞涓嶅尮閰?);
  CheckEquals(0.7, AudioVolume, 0.001, '闊抽噺涓嶅尮閰?);
  
  // 楠岃瘉鑳屾櫙灞炴€?
  CheckEquals('bg-clip-001', BgID, '鑳屾櫙ID涓嶅尮閰?);
  CheckEquals('瑙嗛鑳屾櫙', BgName, '鑳屾櫙鍚嶇О涓嶅尮閰?);
  CheckEquals('assets/images/clip_bg.jpg', BgImagePath, '鑳屾櫙鍥剧墖璺緞涓嶅尮閰?);
  CheckEquals(0.9, BgOpacity, 0.001, '鑳屾櫙閫忔槑搴︿笉鍖归厤');
  CheckEquals('stretch', BgFitMode, '鑳屾櫙濉厖妯″紡涓嶅尮閰?);
end;

procedure TMediaConfigFileTest.TestSaveConfig;
var
  JsonConfig: TJSONConfig;
  NewName: string;
begin
  WriteLn('娴嬭瘯淇濆瓨閰嶇疆');
  
  // 鑾峰彇鍥剧墖閰嶇疆
  JsonConfig := FConfigManager.GetJSONFile('image_background.json');
  CheckNotNull(JsonConfig, '鏃犳硶鑾峰彇鍥剧墖鑳屾櫙閰嶇疆');
  
  // 淇敼鍚嶇О
  NewName := '淇敼鍚庣殑鑳屾櫙';
  JsonConfig.WriteString('name', NewName);
  
  // 淇濆瓨閰嶇疆
  CheckTrue(JsonConfig.Save, '淇濆瓨閰嶇疆澶辫触');
  
  // 閲嶆柊鍔犺浇骞堕獙璇?
  JsonConfig := TJSONConfig.Create(TPath.Combine(FConfigDir, 'image_background.json'));
  try
    CheckEquals(NewName, JsonConfig.ReadString('name', ''), '閰嶇疆淇濆瓨鍚庡悕绉颁笉鍖归厤');
  finally
    JsonConfig.Free;
  end;
end;

procedure TMediaConfigFileTest.Run;
begin
  SetUp;
  try
    WriteLn('鎵ц濯掍綋閰嶇疆鏂囦欢娴嬭瘯: ', TestName);
    TestConfigFilesExist;
    TestLoadImageConfig;
    TestLoadVideoConfig;
    TestSaveConfig;
  finally
    TearDown;
  end;
end;

initialization
  RegisterTestSuite(TMediaConfigFileTest, '濯掍綋閰嶇疆鏂囦欢娴嬭瘯');
end. 