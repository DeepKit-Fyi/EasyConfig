unit UIConfigTests;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.JSON,
  TestFramework, // DUnit娴嬭瘯妗嗘灦
  UIConfig, JSONConfig;

type
  // 甯冨眬閰嶇疆娴嬭瘯
  TLayoutConfigTests = class(TTestCase)
  private
    FLayoutConfig: TLayoutConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestSavedLayouts;
  end;
  
  // 涓婚閰嶇疆娴嬭瘯
  TThemeConfigTests = class(TTestCase)
  private
    FThemeConfig: TThemeConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestColorManagement;
  end;
  
  // 瀛椾綋閰嶇疆娴嬭瘯
  TFontConfigTests = class(TTestCase)
  private
    FFontConfig: TFontConfig;
    FTestFilePath: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestLoadAndSave;
    procedure TestValidation;
  end;

implementation

uses
  Vcl.Graphics, System.UITypes;

{ TLayoutConfigTests }

procedure TLayoutConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'UI.layout.test.json');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\UI.layout.template-001.json') then
    TFile.Copy('config\UI.layout.template-001.json', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
    '{'#13#10 +
    '  "MainWindow": {'#13#10 +
    '    "Width": 1024,'#13#10 +
    '    "Height": 768,'#13#10 +
    '    "Maximized": false'#13#10 +
    '  },'#13#10 +
    '  "Layout": {'#13#10 +
    '    "TreeWidth": 250,'#13#10 +
    '    "PreviewHeight": 200,'#13#10 +
    '    "ShowPreview": true,'#13#10 +
    '    "ShowStatusBar": true,'#13#10 +
    '    "ShowToolbar": true,'#13#10 +
    '    "ToolbarPosition": "top"'#13#10 +
    '  },'#13#10 +
    '  "SavedLayouts": ['#13#10 +
    '    {'#13#10 +
    '      "Name": "Default",'#13#10 +
    '      "MainWidth": 1024,'#13#10 +
    '      "MainHeight": 768,'#13#10 +
    '      "MainMaximized": false,'#13#10 +
    '      "TreeWidth": 250,'#13#10 +
    '      "PreviewHeight": 200,'#13#10 +
    '      "ShowPreview": true,'#13#10 +
    '      "ShowStatusBar": true,'#13#10 +
    '      "ShowToolbar": true,'#13#10 +
    '      "ToolbarPosition": "top"'#13#10 +
    '    },'#13#10 +
    '    {'#13#10 +
    '      "Name": "Compact",'#13#10 +
    '      "MainWidth": 800,'#13#10 +
    '      "MainHeight": 600,'#13#10 +
    '      "MainMaximized": false,'#13#10 +
    '      "TreeWidth": 200,'#13#10 +
    '      "PreviewHeight": 150,'#13#10 +
    '      "ShowPreview": false,'#13#10 +
    '      "ShowStatusBar": false,'#13#10 +
    '      "ShowToolbar": true,'#13#10 +
    '      "ToolbarPosition": "top"'#13#10 +
    '    }'#13#10 +
    '  ]'#13#10 +
    '}'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FLayoutConfig := TLayoutConfig.Create('TEST-LAYOUT-001', 'TestLayout', FTestFilePath, 'LayoutConfig');
end;

procedure TLayoutConfigTests.TearDown;
begin
  // 娓呯悊
  FLayoutConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TLayoutConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-LAYOUT-001', FLayoutConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestLayout', FLayoutConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FLayoutConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('LayoutConfig', FLayoutConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals(1024, FLayoutConfig.MainWidth, '榛樿涓荤獥鍙ｅ搴︿笉姝ｇ‘');
  CheckEquals(768, FLayoutConfig.MainHeight, '榛樿涓荤獥鍙ｉ珮搴︿笉姝ｇ‘');
  CheckFalse(FLayoutConfig.MainMaximized, '榛樿涓嶅簲璇ユ渶澶у寲');
  CheckEquals(250, FLayoutConfig.TreeWidth, '榛樿鏍戝搴︿笉姝ｇ‘');
  CheckEquals(200, FLayoutConfig.PreviewHeight, '榛樿棰勮楂樺害涓嶆纭?);
  CheckTrue(FLayoutConfig.ShowPreview, '榛樿搴旇鏄剧ず棰勮');
  CheckTrue(FLayoutConfig.ShowStatusBar, '榛樿搴旇鏄剧ず鐘舵€佹爮');
  CheckTrue(FLayoutConfig.ShowToolbar, '榛樿搴旇鏄剧ず宸ュ叿鏍?);
  CheckEquals('top', FLayoutConfig.ToolbarPosition, '榛樿宸ュ叿鏍忎綅缃笉姝ｇ‘');
end;

procedure TLayoutConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FLayoutConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FLayoutConfig.MainWidth := 1200;
  FLayoutConfig.MainHeight := 900;
  FLayoutConfig.MainMaximized := True;
  FLayoutConfig.TreeWidth := 300;
  FLayoutConfig.PreviewHeight := 250;
  FLayoutConfig.ShowPreview := False;
  FLayoutConfig.ShowStatusBar := False;
  FLayoutConfig.ShowToolbar := False;
  FLayoutConfig.ToolbarPosition := 'bottom';
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FLayoutConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TLayoutConfig.Create('TEST-LAYOUT-001', 'TestLayout', FTestFilePath, 'LayoutConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals(1200, NewConfig.MainWidth, '涓荤獥鍙ｅ搴︿笉鍖归厤');
    CheckEquals(900, NewConfig.MainHeight, '涓荤獥鍙ｉ珮搴︿笉鍖归厤');
    CheckTrue(NewConfig.MainMaximized, '鏈€澶у寲璁剧疆涓嶅尮閰?);
    CheckEquals(300, NewConfig.TreeWidth, '鏍戝搴︿笉鍖归厤');
    CheckEquals(250, NewConfig.PreviewHeight, '棰勮楂樺害涓嶅尮閰?);
    CheckFalse(NewConfig.ShowPreview, '鏄剧ず棰勮璁剧疆涓嶅尮閰?);
    CheckFalse(NewConfig.ShowStatusBar, '鏄剧ず鐘舵€佹爮璁剧疆涓嶅尮閰?);
    CheckFalse(NewConfig.ShowToolbar, '鏄剧ず宸ュ叿鏍忚缃笉鍖归厤');
    CheckEquals('bottom', NewConfig.ToolbarPosition, '宸ュ叿鏍忎綅缃笉鍖归厤');
  finally
    NewConfig.Free;
  end;
end;

procedure TLayoutConfigTests.TestSavedLayouts;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FLayoutConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 妫€鏌ュ凡淇濆瓨鐨勫竷灞€
  var Layouts := FLayoutConfig.GetSavedLayouts;
  CheckEquals(2, Length(Layouts), '搴旇鏈?涓凡淇濆瓨鐨勫竷灞€');
  CheckEquals('Default', Layouts[0], '绗竴涓竷灞€鍚嶇О搴旇鏄疍efault');
  CheckEquals('Compact', Layouts[1], '绗簩涓竷灞€鍚嶇О搴旇鏄疌ompact');
  
  // 娴嬭瘯鍔犺浇淇濆瓨鐨勫竷灞€
  FLayoutConfig.LoadSavedLayout('Compact');
  CheckEquals(800, FLayoutConfig.MainWidth, '鍔犺浇甯冨眬鍚庝富绐楀彛瀹藉害涓嶅尮閰?);
  CheckEquals(600, FLayoutConfig.MainHeight, '鍔犺浇甯冨眬鍚庝富绐楀彛楂樺害涓嶅尮閰?);
  CheckEquals(200, FLayoutConfig.TreeWidth, '鍔犺浇甯冨眬鍚庢爲瀹藉害涓嶅尮閰?);
  CheckFalse(FLayoutConfig.ShowPreview, '鍔犺浇甯冨眬鍚庨瑙堣缃笉鍖归厤');
  
  // 娴嬭瘯淇濆瓨鏂板竷灞€
  FLayoutConfig.MainWidth := 1280;
  FLayoutConfig.MainHeight := 1024;
  FLayoutConfig.TreeWidth := 320;
  FLayoutConfig.ShowPreview := True;
  FLayoutConfig.SaveCurrentLayout('HighRes');
  
  // 妫€鏌ユ柊甯冨眬鏄惁琚繚瀛?
  Layouts := FLayoutConfig.GetSavedLayouts;
  CheckEquals(3, Length(Layouts), '鐜板湪搴旇鏈?涓凡淇濆瓨鐨勫竷灞€');
  CheckEquals('HighRes', Layouts[2], '绗笁涓竷灞€鍚嶇О搴旇鏄疕ighRes');
  
  // 閲嶆柊鍔犺浇甯冨眬浠ラ獙璇?
  FLayoutConfig.LoadSavedLayout('HighRes');
  CheckEquals(1280, FLayoutConfig.MainWidth, '鍔犺浇鏂板竷灞€鍚庝富绐楀彛瀹藉害涓嶅尮閰?);
  CheckEquals(1024, FLayoutConfig.MainHeight, '鍔犺浇鏂板竷灞€鍚庝富绐楀彛楂樺害涓嶅尮閰?);
  CheckEquals(320, FLayoutConfig.TreeWidth, '鍔犺浇鏂板竷灞€鍚庢爲瀹藉害涓嶅尮閰?);
  CheckTrue(FLayoutConfig.ShowPreview, '鍔犺浇鏂板竷灞€鍚庨瑙堣缃笉鍖归厤');
  
  // 淇濆瓨閰嶇疆浠ラ獙璇佹寔涔呮€?
  CheckTrue(FLayoutConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TLayoutConfig.Create('TEST-LAYOUT-001', 'TestLayout', FTestFilePath, 'LayoutConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇甯︽湁鏂板竷灞€鐨勯厤缃簲璇ユ垚鍔?);
    
    // 妫€鏌ュ竷灞€鏄惁鎸佷箙鍖?
    Layouts := NewConfig.GetSavedLayouts;
    CheckEquals(3, Length(Layouts), '鍔犺浇鍚庡簲璇ユ湁3涓竷灞€');
    CheckEquals('HighRes', Layouts[2], '绗笁涓竷灞€鍚嶇О搴旇渚濈劧鏄疕ighRes');
    
    // 鍔犺浇骞舵鏌ュ竷灞€
    NewConfig.LoadSavedLayout('HighRes');
    CheckEquals(1280, NewConfig.MainWidth, '閲嶆柊鍔犺浇鍚庝富绐楀彛瀹藉害涓嶅尮閰?);
    CheckEquals(1024, NewConfig.MainHeight, '閲嶆柊鍔犺浇鍚庝富绐楀彛楂樺害涓嶅尮閰?);
  finally
    NewConfig.Free;
  end;
end;

{ TThemeConfigTests }

procedure TThemeConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'UI.theme.test.json');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\UI.theme.template-001.json') then
    TFile.Copy('config\UI.theme.template-001.json', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
    '{'#13#10 +
    '  "ThemeName": "Default",'#13#10 +
    '  "DarkMode": false,'#13#10 +
    '  "Colors": {'#13#10 +
    '    "Primary": "#3498db",'#13#10 +
    '    "Secondary": "#2ecc71",'#13#10 +
    '    "Background": "#ffffff",'#13#10 +
    '    "Text": "#333333",'#13#10 +
    '    "Highlight": "#e74c3c"'#13#10 +
    '  },'#13#10 +
    '  "Style": {'#13#10 +
    '    "ButtonRadius": 4,'#13#10 +
    '    "EnableShadows": true'#13#10 +
    '  },'#13#10 +
    '  "CustomColors": {'#13#10 +
    '    "Warning": "#f39c12",'#13#10 +
    '    "Info": "#3498db",'#13#10 +
    '    "Success": "#2ecc71",'#13#10 +
    '    "Error": "#e74c3c",'#13#10 +
    '    "Muted": "#95a5a6"'#13#10 +
    '  }'#13#10 +
    '}'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FThemeConfig := TThemeConfig.Create('TEST-THEME-001', 'TestTheme', FTestFilePath, 'ThemeConfig');
end;

procedure TThemeConfigTests.TearDown;
begin
  // 娓呯悊
  FThemeConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TThemeConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-THEME-001', FThemeConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestTheme', FThemeConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FThemeConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('ThemeConfig', FThemeConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals('Default', FThemeConfig.ThemeName, '榛樿涓婚鍚嶇О涓嶆纭?);
  CheckFalse(FThemeConfig.DarkMode, '榛樿涓嶅簲璇ユ槸娣辫壊妯″紡');
  CheckEquals('#3498db', FThemeConfig.PrimaryColor, '榛樿涓昏壊璋冧笉姝ｇ‘');
  CheckEquals('#2ecc71', FThemeConfig.SecondaryColor, '榛樿杈呭姪鑹茶皟涓嶆纭?);
  CheckEquals('#ffffff', FThemeConfig.BackgroundColor, '榛樿鑳屾櫙鑹蹭笉姝ｇ‘');
  CheckEquals('#333333', FThemeConfig.TextColor, '榛樿鏂囨湰鑹蹭笉姝ｇ‘');
  CheckEquals('#e74c3c', FThemeConfig.HighlightColor, '榛樿楂樹寒鑹蹭笉姝ｇ‘');
  CheckEquals(4, FThemeConfig.ButtonRadius, '榛樿鎸夐挳鍦嗚涓嶆纭?);
  CheckTrue(FThemeConfig.EnableShadows, '榛樿搴旇鍚敤闃村奖');
end;

procedure TThemeConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FThemeConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FThemeConfig.ThemeName := 'DarkTheme';
  FThemeConfig.DarkMode := True;
  FThemeConfig.PrimaryColor := '#2980b9';
  FThemeConfig.SecondaryColor := '#27ae60';
  FThemeConfig.BackgroundColor := '#222222';
  FThemeConfig.TextColor := '#eeeeee';
  FThemeConfig.HighlightColor := '#c0392b';
  FThemeConfig.ButtonRadius := 8;
  FThemeConfig.EnableShadows := False;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FThemeConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TThemeConfig.Create('TEST-THEME-001', 'TestTheme', FTestFilePath, 'ThemeConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals('DarkTheme', NewConfig.ThemeName, '涓婚鍚嶇О涓嶅尮閰?);
    CheckTrue(NewConfig.DarkMode, '娣辫壊妯″紡璁剧疆涓嶅尮閰?);
    CheckEquals('#2980b9', NewConfig.PrimaryColor, '涓昏壊璋冧笉鍖归厤');
    CheckEquals('#27ae60', NewConfig.SecondaryColor, '杈呭姪鑹茶皟涓嶅尮閰?);
    CheckEquals('#222222', NewConfig.BackgroundColor, '鑳屾櫙鑹蹭笉鍖归厤');
    CheckEquals('#eeeeee', NewConfig.TextColor, '鏂囨湰鑹蹭笉鍖归厤');
    CheckEquals('#c0392b', NewConfig.HighlightColor, '楂樹寒鑹蹭笉鍖归厤');
    CheckEquals(8, NewConfig.ButtonRadius, '鎸夐挳鍦嗚涓嶅尮閰?);
    CheckFalse(NewConfig.EnableShadows, '闃村奖璁剧疆涓嶅尮閰?);
  finally
    NewConfig.Free;
  end;
end;

procedure TThemeConfigTests.TestColorManagement;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FThemeConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 娴嬭瘯鑾峰彇棰勫畾涔夐鑹?
  var PrimaryColor := FThemeConfig.GetColor('Primary', clWhite);
  CheckTrue(PrimaryColor <> clWhite, '搴旇杩斿洖姝ｇ‘鐨勪富鑹?);
  
  var HighlightColor := FThemeConfig.GetColor('Highlight', clWhite);
  CheckTrue(HighlightColor <> clWhite, '搴旇杩斿洖姝ｇ‘鐨勯珮浜壊');
  
  // 娴嬭瘯鑾峰彇鑷畾涔夐鑹?
  var WarningColor := FThemeConfig.GetColor('Warning', clWhite);
  CheckTrue(WarningColor <> clWhite, '搴旇杩斿洖姝ｇ‘鐨勮鍛婅壊');
  
  var MutedColor := FThemeConfig.GetColor('Muted', clWhite);
  CheckTrue(MutedColor <> clWhite, '搴旇杩斿洖姝ｇ‘鐨勬煍鍜岃壊');
  
  // 娴嬭瘯鑾峰彇涓嶅瓨鍦ㄧ殑棰滆壊
  var NonExistentColor := FThemeConfig.GetColor('NonExistent', clRed);
  CheckEquals(clRed, NonExistentColor, '搴旇杩斿洖榛樿棰滆壊');
  
  // 娴嬭瘯璁剧疆棰滆壊
  FThemeConfig.SetColor('Primary', clBlue);
  FThemeConfig.SetColor('CustomTest', clGreen);
  
  // 娴嬭瘯鏂拌缃殑棰滆壊
  var NewPrimaryColor := FThemeConfig.GetColor('Primary', clWhite);
  CheckTrue(NewPrimaryColor <> clWhite, '搴旇杩斿洖鏂拌缃殑涓昏壊');
  
  var CustomTestColor := FThemeConfig.GetColor('CustomTest', clWhite);
  CheckTrue(CustomTestColor <> clWhite, '搴旇杩斿洖鏂拌缃殑鑷畾涔夎壊');
  
  // 淇濆瓨骞堕噸鏂板姞杞戒互楠岃瘉鎸佷箙鎬?
  CheckTrue(FThemeConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TThemeConfig.Create('TEST-THEME-001', 'TestTheme', FTestFilePath, 'ThemeConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ヨ嚜瀹氫箟棰滆壊鏄惁琚纭繚瀛?
    var LoadedCustomColor := NewConfig.GetColor('CustomTest', clWhite);
    CheckTrue(LoadedCustomColor <> clWhite, '搴旇鍔犺浇姝ｇ‘鐨勮嚜瀹氫箟鑹?);
  finally
    NewConfig.Free;
  end;
end;

{ TFontConfigTests }

procedure TFontConfigTests.SetUp;
begin
  // 鍒涘缓涓存椂娴嬭瘯鏂囦欢
  FTestFilePath := TPath.Combine(TPath.GetTempPath, 'UI.fonts.test.json');
  
  // 鎷疯礉妯℃澘鏂囦欢鍒版祴璇曟枃浠?
  if TFile.Exists('config\UI.fonts.template-001.json') then
    TFile.Copy('config\UI.fonts.template-001.json', FTestFilePath, True)
  else
    TFile.WriteAllText(FTestFilePath, 
    '{'#13#10 +
    '  "DefaultFont": {'#13#10 +
    '    "Name": "Segoe UI",'#13#10 +
    '    "Size": 9'#13#10 +
    '  },'#13#10 +
    '  "TitleFont": {'#13#10 +
    '    "Name": "Segoe UI",'#13#10 +
    '    "Size": 12'#13#10 +
    '  },'#13#10 +
    '  "MenuFont": {'#13#10 +
    '    "Name": "Segoe UI",'#13#10 +
    '    "Size": 9'#13#10 +
    '  },'#13#10 +
    '  "ButtonFont": {'#13#10 +
    '    "Name": "Segoe UI",'#13#10 +
    '    "Size": 9'#13#10 +
    '  },'#13#10 +
    '  "MonospaceFont": {'#13#10 +
    '    "Name": "Consolas",'#13#10 +
    '    "Size": 10'#13#10 +
    '  }'#13#10 +
    '}'#13#10);
  
  // 鍒涘缓娴嬭瘯瀵硅薄
  FFontConfig := TFontConfig.Create('TEST-FONT-001', 'TestFont', FTestFilePath, 'FontConfig');
end;

procedure TFontConfigTests.TearDown;
begin
  // 娓呯悊
  FFontConfig.Free;
  
  // 鍒犻櫎娴嬭瘯鏂囦欢
  if TFile.Exists(FTestFilePath) then
    TFile.Delete(FTestFilePath);
end;

procedure TFontConfigTests.TestCreate;
begin
  // 娴嬭瘯鏋勯€犲嚱鏁板拰榛樿鍊?
  CheckEquals('TEST-FONT-001', FFontConfig.ID, '閰嶇疆ID涓嶅尮閰?);
  CheckEquals('TestFont', FFontConfig.Name, '閰嶇疆鍚嶇О涓嶅尮閰?);
  CheckEquals(FTestFilePath, FFontConfig.FileName, '閰嶇疆鏂囦欢鍚嶄笉鍖归厤');
  CheckEquals('FontConfig', FFontConfig.TypeID, '閰嶇疆绫诲瀷涓嶅尮閰?);
  
  // 妫€鏌ラ粯璁ゅ€?
  CheckEquals('Segoe UI', FFontConfig.DefaultFontName, '榛樿瀛椾綋鍚嶇О涓嶆纭?);
  CheckEquals(9, FFontConfig.DefaultFontSize, '榛樿瀛椾綋澶у皬涓嶆纭?);
  CheckEquals('Segoe UI', FFontConfig.TitleFontName, '榛樿鏍囬瀛椾綋鍚嶇О涓嶆纭?);
  CheckEquals(12, FFontConfig.TitleFontSize, '榛樿鏍囬瀛椾綋澶у皬涓嶆纭?);
  CheckEquals('Segoe UI', FFontConfig.MenuFontName, '榛樿鑿滃崟瀛椾綋鍚嶇О涓嶆纭?);
  CheckEquals(9, FFontConfig.MenuFontSize, '榛樿鑿滃崟瀛椾綋澶у皬涓嶆纭?);
  CheckEquals('Segoe UI', FFontConfig.ButtonFontName, '榛樿鎸夐挳瀛椾綋鍚嶇О涓嶆纭?);
  CheckEquals(9, FFontConfig.ButtonFontSize, '榛樿鎸夐挳瀛椾綋澶у皬涓嶆纭?);
  CheckEquals('Consolas', FFontConfig.MonospaceFontName, '榛樿绛夊瀛椾綋鍚嶇О涓嶆纭?);
  CheckEquals(10, FFontConfig.MonospaceFontSize, '榛樿绛夊瀛椾綋澶у皬涓嶆纭?);
end;

procedure TFontConfigTests.TestLoadAndSave;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FFontConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  
  // 淇敼涓€浜涘€?
  FFontConfig.DefaultFontName := 'Arial';
  FFontConfig.DefaultFontSize := 10;
  FFontConfig.TitleFontName := 'Tahoma';
  FFontConfig.TitleFontSize := 14;
  FFontConfig.MenuFontName := 'Arial';
  FFontConfig.MenuFontSize := 10;
  FFontConfig.ButtonFontName := 'Tahoma';
  FFontConfig.ButtonFontSize := 10;
  FFontConfig.MonospaceFontName := 'Courier New';
  FFontConfig.MonospaceFontSize := 11;
  
  // 淇濆瓨閰嶇疆
  CheckTrue(FFontConfig.Save, '淇濆瓨閰嶇疆搴旇鎴愬姛');
  
  // 鍒涘缓鏂板疄渚嬪苟鍔犺浇閰嶇疆
  var NewConfig := TFontConfig.Create('TEST-FONT-001', 'TestFont', FTestFilePath, 'FontConfig');
  try
    CheckTrue(NewConfig.Load, '鍔犺浇淇敼鍚庣殑閰嶇疆搴旇鎴愬姛');
    
    // 妫€鏌ュ€兼槸鍚﹁姝ｇ‘淇濆瓨
    CheckEquals('Arial', NewConfig.DefaultFontName, '榛樿瀛椾綋鍚嶇О涓嶅尮閰?);
    CheckEquals(10, NewConfig.DefaultFontSize, '榛樿瀛椾綋澶у皬涓嶅尮閰?);
    CheckEquals('Tahoma', NewConfig.TitleFontName, '鏍囬瀛椾綋鍚嶇О涓嶅尮閰?);
    CheckEquals(14, NewConfig.TitleFontSize, '鏍囬瀛椾綋澶у皬涓嶅尮閰?);
    CheckEquals('Arial', NewConfig.MenuFontName, '鑿滃崟瀛椾綋鍚嶇О涓嶅尮閰?);
    CheckEquals(10, NewConfig.MenuFontSize, '鑿滃崟瀛椾綋澶у皬涓嶅尮閰?);
    CheckEquals('Tahoma', NewConfig.ButtonFontName, '鎸夐挳瀛椾綋鍚嶇О涓嶅尮閰?);
    CheckEquals(10, NewConfig.ButtonFontSize, '鎸夐挳瀛椾綋澶у皬涓嶅尮閰?);
    CheckEquals('Courier New', NewConfig.MonospaceFontName, '绛夊瀛椾綋鍚嶇О涓嶅尮閰?);
    CheckEquals(11, NewConfig.MonospaceFontSize, '绛夊瀛椾綋澶у皬涓嶅尮閰?);
  finally
    NewConfig.Free;
  end;
end;

procedure TFontConfigTests.TestValidation;
begin
  // 娴嬭瘯鍔犺浇閰嶇疆
  CheckTrue(FFontConfig.Load, '鍔犺浇閰嶇疆搴旇鎴愬姛');
  CheckTrue(FFontConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勫瓧浣撳悕绉?
  FFontConfig.DefaultFontName := '';
  CheckFalse(FFontConfig.Validate, '绌哄瓧浣撳悕绉板簲璇ュ鑷撮獙璇佸け璐?);
  var Errors := FFontConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  
  // 鎭㈠鏈夋晥鐨勫瓧浣撳悕绉?
  FFontConfig.DefaultFontName := 'Segoe UI';
  CheckTrue(FFontConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 娴嬭瘯鏃犳晥鐨勫瓧浣撳ぇ灏?
  FFontConfig.DefaultFontSize := 0;
  CheckFalse(FFontConfig.Validate, '鏃犳晥鐨勫瓧浣撳ぇ灏忓簲璇ュ鑷撮獙璇佸け璐?);
  Errors := FFontConfig.GetValidationErrors;
  CheckTrue(Length(Errors) > 0, '搴旇鏈夐獙璇侀敊璇?);
  
  // 鎭㈠鏈夋晥鐨勫瓧浣撳ぇ灏?
  FFontConfig.DefaultFontSize := 9;
  CheckTrue(FFontConfig.Validate, '鏈夋晥鐨勯厤缃簲璇ラ€氳繃楠岃瘉');
  
  // 澶氫釜閿欒鎯呭喌
  FFontConfig.DefaultFontName := '';
  FFontConfig.DefaultFontSize := 0;
  FFontConfig.TitleFontName := '';
  Errors := FFontConfig.GetValidationErrors;
  CheckEquals(3, Length(Errors), '搴旇鎶ュ憡3涓敊璇?);
end;

initialization
  // 娉ㄥ唽娴嬭瘯
  RegisterTest(TLayoutConfigTests.Suite);
  RegisterTest(TThemeConfigTests.Suite);
  RegisterTest(TFontConfigTests.Suite);
end. 