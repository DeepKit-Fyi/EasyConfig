unit MediaConfigTests;

interface

uses
  TestFramework, Classes, SysUtils, IOUtils, Graphics,
  MediaConfig, ConfigTypes, SuperObject;

type
  // 鍥剧墖鑳屾櫙閰嶇疆娴嬭瘯
  TImageBackgroundConfigTests = class(TTestCase)
  private
    FConfig: TImageBackgroundConfig;
    FConfigPath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadConfig;
    procedure TestSaveConfig;
    procedure TestValidate;
    procedure TestImageProperties;
  end;

  // 鎶藉眽闈㈡澘閰嶇疆娴嬭瘯
  TDrawerConfigTests = class(TTestCase)
  private
    FConfig: TDrawerConfig;
    FConfigPath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadConfig;
    procedure TestSaveConfig;
    procedure TestValidate;
    procedure TestNestedDrawers;
  end;

  // 瑙嗛鐗囨閰嶇疆娴嬭瘯
  TVideoClipConfigTests = class(TTestCase)
  private
    FConfig: TVideoClipConfig;
    FConfigPath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadConfig;
    procedure TestSaveConfig;
    procedure TestValidate;
    procedure TestElementsManagement;
    procedure TestRenderFrame;
  end;

implementation

{ TImageBackgroundConfigTests }

procedure TImageBackgroundConfigTests.SetUp;
begin
  FConfigPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TestConfig');
  ForceDirectories(FConfigPath);
  FConfig := TImageBackgroundConfig.Create('test-bg', '娴嬭瘯鑳屾櫙', 
    TPath.Combine(FConfigPath, 'test-bg.json'));
end;

procedure TImageBackgroundConfigTests.TearDown;
begin
  FConfig.Free;
  if DirectoryExists(FConfigPath) then
    TDirectory.Delete(FConfigPath, True);
end;

procedure TImageBackgroundConfigTests.TestCreate;
begin
  CheckNotNull(FConfig, '鍒涘缓鑳屾櫙閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-bg', FConfig.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯鑳屾櫙', FConfig.Name, '鍚嶇О涓嶅尮閰?);
end;

procedure TImageBackgroundConfigTests.TestLoadConfig;
var
  JsonContent: string;
  JsonFile: TStringList;
begin
  // 鍑嗗娴嬭瘯鏁版嵁
  JsonContent := '{"image_path":"backgrounds/test.jpg","opacity":0.8,'
               + '"fit_mode":"stretch","offset_x":10,"offset_y":20,'
               + '"rotation":45,"blur_radius":5}';
  
  JsonFile := TStringList.Create;
  try
    JsonFile.Text := JsonContent;
    JsonFile.SaveToFile(FConfig.FileName);
    
    // 娴嬭瘯鍔犺浇
    CheckTrue(FConfig.Load, '鍔犺浇閰嶇疆澶辫触');
    
    // 楠岃瘉灞炴€?
    CheckEquals('backgrounds/test.jpg', FConfig.ImagePath, 'ImagePath涓嶅尮閰?);
    CheckEquals(0.8, FConfig.Opacity, 0.001, 'Opacity涓嶅尮閰?);
    CheckEquals('stretch', FConfig.FitMode, 'FitMode涓嶅尮閰?);
    CheckEquals(10, FConfig.OffsetX, 'OffsetX涓嶅尮閰?);
    CheckEquals(20, FConfig.OffsetY, 'OffsetY涓嶅尮閰?);
    CheckEquals(45, FConfig.Rotation, 'Rotation涓嶅尮閰?);
    CheckEquals(5, FConfig.BlurRadius, 'BlurRadius涓嶅尮閰?);
  finally
    JsonFile.Free;
  end;
end;

procedure TImageBackgroundConfigTests.TestSaveConfig;
var
  JsonObj: ISuperObject;
  JsonText: string;
begin
  // 璁剧疆灞炴€?
  FConfig.ImagePath := 'backgrounds/save_test.jpg';
  FConfig.Opacity := 0.75;
  FConfig.FitMode := 'fit';
  FConfig.OffsetX := 15;
  FConfig.OffsetY := 25;
  FConfig.Rotation := 90;
  FConfig.BlurRadius := 10;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FConfig.Save, '淇濆瓨閰嶇疆澶辫触');
  
  // 楠岃瘉淇濆瓨鐨勫唴瀹?
  CheckTrue(FileExists(FConfig.FileName), '閰嶇疆鏂囦欢鏈垱寤?);
  
  JsonText := TFile.ReadAllText(FConfig.FileName);
  JsonObj := SO(JsonText);
  
  CheckEquals('backgrounds/save_test.jpg', JsonObj.S['image_path'], 'ImagePath淇濆瓨閿欒');
  CheckEquals(0.75, JsonObj.D['opacity'], 0.001, 'Opacity淇濆瓨閿欒');
  CheckEquals('fit', JsonObj.S['fit_mode'], 'FitMode淇濆瓨閿欒');
  CheckEquals(15, JsonObj.I['offset_x'], 'OffsetX淇濆瓨閿欒');
  CheckEquals(25, JsonObj.I['offset_y'], 'OffsetY淇濆瓨閿欒');
  CheckEquals(90, JsonObj.I['rotation'], 'Rotation淇濆瓨閿欒');
  CheckEquals(10, JsonObj.I['blur_radius'], 'BlurRadius淇濆瓨閿欒');
end;

procedure TImageBackgroundConfigTests.TestValidate;
begin
  // 鏈夋晥璺緞
  FConfig.ImagePath := 'backgrounds/valid.jpg';
  CheckTrue(FConfig.Validate, '鏈夋晥閰嶇疆楠岃瘉澶辫触');
  
  // 鏃犳晥璺緞
  FConfig.ImagePath := '';
  CheckFalse(FConfig.Validate, '鏃犳晥閰嶇疆楠岃瘉搴旇澶辫触');
  
  // 鏃犳晥閫忔槑搴?
  FConfig.ImagePath := 'backgrounds/valid.jpg';
  FConfig.Opacity := 2.0;  // 瓒呭嚭鑼冨洿
  CheckFalse(FConfig.Validate, '鏃犳晥閫忔槑搴﹂獙璇佸簲璇ュけ璐?);
end;

procedure TImageBackgroundConfigTests.TestImageProperties;
begin
  // 娴嬭瘯灞炴€ц缃笌璇诲彇
  FConfig.ImagePath := 'test/path.jpg';
  CheckEquals('test/path.jpg', FConfig.ImagePath, 'ImagePath灞炴€у瓨鍙栭敊璇?);
  
  FConfig.Opacity := 0.5;
  CheckEquals(0.5, FConfig.Opacity, 0.001, 'Opacity灞炴€у瓨鍙栭敊璇?);
  
  FConfig.FitMode := 'center';
  CheckEquals('center', FConfig.FitMode, 'FitMode灞炴€у瓨鍙栭敊璇?);
  
  FConfig.OffsetX := 100;
  CheckEquals(100, FConfig.OffsetX, 'OffsetX灞炴€у瓨鍙栭敊璇?);
  
  FConfig.OffsetY := 200;
  CheckEquals(200, FConfig.OffsetY, 'OffsetY灞炴€у瓨鍙栭敊璇?);
  
  FConfig.Rotation := 180;
  CheckEquals(180, FConfig.Rotation, 'Rotation灞炴€у瓨鍙栭敊璇?);
  
  FConfig.BlurRadius := 15;
  CheckEquals(15, FConfig.BlurRadius, 'BlurRadius灞炴€у瓨鍙栭敊璇?);
end;

{ TDrawerConfigTests }

procedure TDrawerConfigTests.SetUp;
begin
  FConfigPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TestConfig');
  ForceDirectories(FConfigPath);
  FConfig := TDrawerConfig.Create('test-drawer', '娴嬭瘯鎶藉眽', 
    TPath.Combine(FConfigPath, 'test-drawer.json'));
end;

procedure TDrawerConfigTests.TearDown;
begin
  FConfig.Free;
  if DirectoryExists(FConfigPath) then
    TDirectory.Delete(FConfigPath, True);
end;

procedure TDrawerConfigTests.TestCreate;
begin
  CheckNotNull(FConfig, '鍒涘缓鎶藉眽閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-drawer', FConfig.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯鎶藉眽', FConfig.Name, '鍚嶇О涓嶅尮閰?);
end;

procedure TDrawerConfigTests.TestLoadConfig;
var
  JsonContent: string;
  JsonFile: TStringList;
begin
  // 鍑嗗娴嬭瘯鏁版嵁
  JsonContent := '{'
               + '"position":"left","width":300,"height":600,'
               + '"slide_speed":0.5,"damping_factor":0.3,'
               + '"minimized_size":50,"background_color":"#F0F0F0",'
               + '"auto_hide":true,"nested_drawers":[]'
               + '}';
  
  JsonFile := TStringList.Create;
  try
    JsonFile.Text := JsonContent;
    JsonFile.SaveToFile(FConfig.FileName);
    
    // 娴嬭瘯鍔犺浇
    CheckTrue(FConfig.Load, '鍔犺浇閰嶇疆澶辫触');
    
    // 楠岃瘉灞炴€?
    CheckEquals('left', FConfig.Position, 'Position涓嶅尮閰?);
    CheckEquals(300, FConfig.Width, 'Width涓嶅尮閰?);
    CheckEquals(600, FConfig.Height, 'Height涓嶅尮閰?);
    CheckEquals(0.5, FConfig.SlideSpeed, 0.001, 'SlideSpeed涓嶅尮閰?);
    CheckEquals(0.3, FConfig.DampingFactor, 0.001, 'DampingFactor涓嶅尮閰?);
    CheckEquals(50, FConfig.MinimizedSize, 'MinimizedSize涓嶅尮閰?);
    CheckEquals('#F0F0F0', FConfig.BackgroundColor, 'BackgroundColor涓嶅尮閰?);
    CheckEquals(True, FConfig.AutoHide, 'AutoHide涓嶅尮閰?);
    CheckEquals(0, FConfig.NestedDrawers.Count, 'NestedDrawers鏁伴噺涓嶅尮閰?);
  finally
    JsonFile.Free;
  end;
end;

procedure TDrawerConfigTests.TestSaveConfig;
var
  JsonObj: ISuperObject;
  JsonText: string;
begin
  // 璁剧疆灞炴€?
  FConfig.Position := 'right';
  FConfig.Width := 250;
  FConfig.Height := 500;
  FConfig.SlideSpeed := 0.8;
  FConfig.DampingFactor := 0.4;
  FConfig.MinimizedSize := 40;
  FConfig.BackgroundColor := '#E0E0E0';
  FConfig.AutoHide := False;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FConfig.Save, '淇濆瓨閰嶇疆澶辫触');
  
  // 楠岃瘉淇濆瓨鐨勫唴瀹?
  CheckTrue(FileExists(FConfig.FileName), '閰嶇疆鏂囦欢鏈垱寤?);
  
  JsonText := TFile.ReadAllText(FConfig.FileName);
  JsonObj := SO(JsonText);
  
  CheckEquals('right', JsonObj.S['position'], 'Position淇濆瓨閿欒');
  CheckEquals(250, JsonObj.I['width'], 'Width淇濆瓨閿欒');
  CheckEquals(500, JsonObj.I['height'], 'Height淇濆瓨閿欒');
  CheckEquals(0.8, JsonObj.D['slide_speed'], 0.001, 'SlideSpeed淇濆瓨閿欒');
  CheckEquals(0.4, JsonObj.D['damping_factor'], 0.001, 'DampingFactor淇濆瓨閿欒');
  CheckEquals(40, JsonObj.I['minimized_size'], 'MinimizedSize淇濆瓨閿欒');
  CheckEquals('#E0E0E0', JsonObj.S['background_color'], 'BackgroundColor淇濆瓨閿欒');
  CheckEquals(False, JsonObj.B['auto_hide'], 'AutoHide淇濆瓨閿欒');
end;

procedure TDrawerConfigTests.TestValidate;
begin
  // 鏈夋晥浣嶇疆
  FConfig.Position := 'left';
  FConfig.Width := 200;
  FConfig.Height := 400;
  CheckTrue(FConfig.Validate, '鏈夋晥閰嶇疆楠岃瘉澶辫触');
  
  // 鏃犳晥浣嶇疆
  FConfig.Position := 'invalid';
  CheckFalse(FConfig.Validate, '鏃犳晥浣嶇疆楠岃瘉搴旇澶辫触');
  
  // 鏃犳晥灏哄
  FConfig.Position := 'top';
  FConfig.Width := -10;  // 璐熷€?
  CheckFalse(FConfig.Validate, '鏃犳晥瀹藉害楠岃瘉搴旇澶辫触');
end;

procedure TDrawerConfigTests.TestNestedDrawers;
var
  NestedDrawer: TDrawerConfig;
  Index: Integer;
begin
  // 鍒涘缓宓屽鎶藉眽
  NestedDrawer := TDrawerConfig.Create('nested', '宓屽鎶藉眽', '');
  NestedDrawer.Position := 'bottom';
  NestedDrawer.Width := 200;
  NestedDrawer.Height := 100;
  
  // 娣诲姞宓屽鎶藉眽
  Index := FConfig.AddNestedDrawer(NestedDrawer);
  CheckEquals(0, Index, '宓屽鎶藉眽绱㈠紩閿欒');
  CheckEquals(1, FConfig.NestedDrawers.Count, '宓屽鎶藉眽鏁伴噺閿欒');
  
  // 鑾峰彇宓屽鎶藉眽
  NestedDrawer := FConfig.GetNestedDrawer(0);
  CheckNotNull(NestedDrawer, '鑾峰彇宓屽鎶藉眽澶辫触');
  CheckEquals('nested', NestedDrawer.ID, '宓屽鎶藉眽ID閿欒');
  
  // 鍒犻櫎宓屽鎶藉眽
  FConfig.RemoveNestedDrawer(0);
  CheckEquals(0, FConfig.NestedDrawers.Count, '鍒犻櫎宓屽鎶藉眽鍚庢暟閲忛敊璇?);
end;

{ TVideoClipConfigTests }

procedure TVideoClipConfigTests.SetUp;
begin
  FConfigPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TestConfig');
  ForceDirectories(FConfigPath);
  FConfig := TVideoClipConfig.Create('test-clip', '娴嬭瘯瑙嗛鐗囨', 
    TPath.Combine(FConfigPath, 'test-clip.json'));
end;

procedure TVideoClipConfigTests.TearDown;
begin
  FConfig.Free;
  if DirectoryExists(FConfigPath) then
    TDirectory.Delete(FConfigPath, True);
end;

procedure TVideoClipConfigTests.TestCreate;
begin
  CheckNotNull(FConfig, '鍒涘缓瑙嗛鐗囨閰嶇疆瀵硅薄澶辫触');
  CheckEquals('test-clip', FConfig.ID, 'ID涓嶅尮閰?);
  CheckEquals('娴嬭瘯瑙嗛鐗囨', FConfig.Name, '鍚嶇О涓嶅尮閰?);
  
  // 妫€鏌ュ瓙瀵硅薄
  CheckNotNull(FConfig.Background, '鑳屾櫙瀵硅薄鏈垱寤?);
  CheckNotNull(FConfig.Images, '鍥惧儚鍒楄〃鏈垱寤?);
  CheckNotNull(FConfig.Texts, '鏂囨湰鍒楄〃鏈垱寤?);
  CheckNotNull(FConfig.Drawers, '鎶藉眽鍒楄〃鏈垱寤?);
end;

procedure TVideoClipConfigTests.TestLoadConfig;
var
  JsonContent: string;
  JsonFile: TStringList;
begin
  // 鍑嗗娴嬭瘯鏁版嵁
  JsonContent := '{'
               + '"background":{'
               + '  "image_path":"backgrounds/clip_bg.jpg",'
               + '  "opacity":0.9,'
               + '  "fit_mode":"fill"'
               + '},'
               + '"images":[],'
               + '"texts":[],'
               + '"drawers":[],'
               + '"length":10.5,'
               + '"audio_path":"audio/test.mp3",'
               + '"audio_volume":0.8,'
               + '"audio_start_time":1.0'
               + '}';
  
  JsonFile := TStringList.Create;
  try
    JsonFile.Text := JsonContent;
    JsonFile.SaveToFile(FConfig.FileName);
    
    // 娴嬭瘯鍔犺浇
    CheckTrue(FConfig.Load, '鍔犺浇閰嶇疆澶辫触');
    
    // 楠岃瘉灞炴€?
    CheckEquals('backgrounds/clip_bg.jpg', FConfig.Background.ImagePath, 'Background.ImagePath涓嶅尮閰?);
    CheckEquals(0.9, FConfig.Background.Opacity, 0.001, 'Background.Opacity涓嶅尮閰?);
    CheckEquals(10.5, FConfig.Length, 0.001, 'Length涓嶅尮閰?);
    CheckEquals('audio/test.mp3', FConfig.AudioPath, 'AudioPath涓嶅尮閰?);
    CheckEquals(0.8, FConfig.AudioVolume, 0.001, 'AudioVolume涓嶅尮閰?);
    CheckEquals(1.0, FConfig.AudioStartTime, 0.001, 'AudioStartTime涓嶅尮閰?);
  finally
    JsonFile.Free;
  end;
end;

procedure TVideoClipConfigTests.TestSaveConfig;
var
  JsonObj, BgObj: ISuperObject;
  JsonText: string;
begin
  // 璁剧疆灞炴€?
  FConfig.Background.ImagePath := 'backgrounds/save_clip.jpg';
  FConfig.Background.Opacity := 0.85;
  FConfig.Length := 15.0;
  FConfig.AudioPath := 'audio/save_test.mp3';
  FConfig.AudioVolume := 0.7;
  FConfig.AudioStartTime := 0.5;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FConfig.Save, '淇濆瓨閰嶇疆澶辫触');
  
  // 楠岃瘉淇濆瓨鐨勫唴瀹?
  CheckTrue(FileExists(FConfig.FileName), '閰嶇疆鏂囦欢鏈垱寤?);
  
  JsonText := TFile.ReadAllText(FConfig.FileName);
  JsonObj := SO(JsonText);
  
  BgObj := JsonObj['background'];
  CheckEquals('backgrounds/save_clip.jpg', BgObj.S['image_path'], 'Background.ImagePath淇濆瓨閿欒');
  CheckEquals(0.85, BgObj.D['opacity'], 0.001, 'Background.Opacity淇濆瓨閿欒');
  CheckEquals(15.0, JsonObj.D['length'], 0.001, 'Length淇濆瓨閿欒');
  CheckEquals('audio/save_test.mp3', JsonObj.S['audio_path'], 'AudioPath淇濆瓨閿欒');
  CheckEquals(0.7, JsonObj.D['audio_volume'], 0.001, 'AudioVolume淇濆瓨閿欒');
  CheckEquals(0.5, JsonObj.D['audio_start_time'], 0.001, 'AudioStartTime淇濆瓨閿欒');
end;

procedure TVideoClipConfigTests.TestValidate;
begin
  // 鏈夋晥閰嶇疆
  FConfig.Background.ImagePath := 'backgrounds/valid.jpg';
  FConfig.Length := 5.0;
  CheckTrue(FConfig.Validate, '鏈夋晥閰嶇疆楠岃瘉澶辫触');
  
  // 鏃犳晥闀垮害
  FConfig.Length := -1.0;  // 璐熷€?
  CheckFalse(FConfig.Validate, '鏃犳晥闀垮害楠岃瘉搴旇澶辫触');
  
  // 鏃犳晥闊抽闊抽噺
  FConfig.Length := 5.0;
  FConfig.AudioVolume := 2.0;  // 瓒呭嚭鑼冨洿
  CheckFalse(FConfig.Validate, '鏃犳晥闊抽闊抽噺楠岃瘉搴旇澶辫触');
end;

procedure TVideoClipConfigTests.TestElementsManagement;
var
  TextElement: TTextElement;
  ImageElement: TImageElement;
  Index: Integer;
begin
  // 娣诲姞鏂囨湰鍏冪礌
  TextElement := TTextElement.Create;
  TextElement.Text := '娴嬭瘯鏂囨湰';
  TextElement.FontName := 'Arial';
  TextElement.FontSize := 24;
  
  Index := FConfig.AddText(TextElement);
  CheckEquals(0, Index, '鏂囨湰鍏冪礌绱㈠紩閿欒');
  CheckEquals(1, FConfig.Texts.Count, '鏂囨湰鍏冪礌鏁伴噺閿欒');
  
  // 娣诲姞鍥惧儚鍏冪礌
  ImageElement := TImageElement.Create;
  ImageElement.ImagePath := 'images/test.png';
  ImageElement.Width := 100;
  ImageElement.Height := 100;
  
  Index := FConfig.AddImage(ImageElement);
  CheckEquals(0, Index, '鍥惧儚鍏冪礌绱㈠紩閿欒');
  CheckEquals(1, FConfig.Images.Count, '鍥惧儚鍏冪礌鏁伴噺閿欒');
  
  // 鍒犻櫎鍏冪礌
  FConfig.RemoveText(0);
  CheckEquals(0, FConfig.Texts.Count, '鍒犻櫎鏂囨湰鍏冪礌鍚庢暟閲忛敊璇?);
  
  FConfig.RemoveImage(0);
  CheckEquals(0, FConfig.Images.Count, '鍒犻櫎鍥惧儚鍏冪礌鍚庢暟閲忛敊璇?);
end;

procedure TVideoClipConfigTests.TestRenderFrame;
var
  Bitmap: TBitmap;
begin
  // 璁剧疆鍩烘湰灞炴€?
  FConfig.Background.ImagePath := 'backgrounds/test.jpg';
  FConfig.Length := 10.0;
  
  // 娴嬭瘯娓叉煋甯?
  Bitmap := FConfig.RenderFrame(5.0);
  try
    CheckNotNull(Bitmap, '娓叉煋甯уけ璐?);
    CheckTrue(Bitmap.Width > 0, '娓叉煋甯у搴︽棤鏁?);
    CheckTrue(Bitmap.Height > 0, '娓叉煋甯ч珮搴︽棤鏁?);
  finally
    Bitmap.Free;
  end;
end;

initialization
  RegisterTest(TImageBackgroundConfigTests.Suite);
  RegisterTest(TDrawerConfigTests.Suite);
  RegisterTest(TVideoClipConfigTests.Suite);
end. 