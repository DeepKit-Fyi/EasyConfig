unit ConfigValidator;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  System.IOUtils,
  ConfigTypes, INIConfig, JSONConfig;

type
  // 閰嶇疆楠岃瘉缁撴灉
  TValidationResult = record
    IsValid: Boolean;
    Errors: TArray<string>;
    Warnings: TArray<string>;
  end;
  
  // 閰嶇疆鏂囦欢楠岃瘉鍣?
  TConfigValidator = class
  private
    FErrorList: TList<string>;
    FWarningList: TList<string>;
    
    // 楠岃瘉INI鏂囦欢
    function ValidateINIFile(const FileName: string): Boolean;
    
    // 楠岃瘉JSON鏂囦欢
    function ValidateJSONFile(const FileName: string): Boolean;
    
    // 楠岃瘉寮曠敤瀹屾暣鎬?
    function ValidateReferences(const FileName: string): Boolean;
    
    // 楠岃瘉鏂囦欢鎵╁睍鍚?
    function ValidateFileExtension(const FileName: string): Boolean;
    
    // 楠岃瘉鍛藉悕瑙勮寖
    function ValidateNamingConvention(const FileName: string): Boolean;
    
    // 娣诲姞閿欒
    procedure AddError(const ErrorMessage: string);
    
    // 娣诲姞璀﹀憡
    procedure AddWarning(const WarningMessage: string);
  public
    constructor Create;
    destructor Destroy; override;
    
    // 楠岃瘉鍗曚釜閰嶇疆鏂囦欢
    function ValidateFile(const FileName: string): TValidationResult;
    
    // 楠岃瘉鐩綍涓殑鎵€鏈夐厤缃枃浠?
    function ValidateDirectory(const DirectoryPath: string): TValidationResult;
    
    // 楠岃瘉鎸囧畾绫诲瀷鐨勯厤缃枃浠?
    function ValidateFilesByPattern(const DirectoryPath, Pattern: string): TValidationResult;
  end;
  
  // 鍏ㄥ眬鍑芥暟
  function ValidateConfigFile(const FileName: string): TValidationResult;
  function ValidateConfigDirectory(const DirectoryPath: string): TValidationResult;

implementation

uses
  System.RegularExpressions;

{ TConfigValidator }

constructor TConfigValidator.Create;
begin
  inherited Create;
  FErrorList := TList<string>.Create;
  FWarningList := TList<string>.Create;
end;

destructor TConfigValidator.Destroy;
begin
  FErrorList.Free;
  FWarningList.Free;
  inherited;
end;

procedure TConfigValidator.AddError(const ErrorMessage: string);
begin
  FErrorList.Add(ErrorMessage);
end;

procedure TConfigValidator.AddWarning(const WarningMessage: string);
begin
  FWarningList.Add(WarningMessage);
end;

function TConfigValidator.ValidateFile(const FileName: string): TValidationResult;
begin
  // 娓呴櫎涔嬪墠鐨勯敊璇拰璀﹀憡
  FErrorList.Clear;
  FWarningList.Clear;
  
  // 妫€鏌ユ枃浠舵槸鍚﹀瓨鍦?
  if not TFile.Exists(FileName) then
  begin
    AddError('鏂囦欢涓嶅瓨鍦? ' + FileName);
    Result.IsValid := False;
    Result.Errors := FErrorList.ToArray;
    Result.Warnings := FWarningList.ToArray;
    Exit;
  end;
  
  // 楠岃瘉鏂囦欢鎵╁睍鍚?
  if not ValidateFileExtension(FileName) then
    AddWarning('鏂囦欢鎵╁睍鍚嶄笉绗﹀悎瑙勮寖: ' + FileName);
  
  // 楠岃瘉鍛藉悕瑙勮寖
  if not ValidateNamingConvention(FileName) then
    AddWarning('鏂囦欢鍛藉悕涓嶇鍚堣鑼? ' + FileName);
  
  // 鏍规嵁鏂囦欢绫诲瀷楠岃瘉鍐呭
  if SameText(ExtractFileExt(FileName), '.ini') then
    ValidateINIFile(FileName)
  else if SameText(ExtractFileExt(FileName), '.json') then
    ValidateJSONFile(FileName);
  
  // 楠岃瘉寮曠敤瀹屾暣鎬?
  ValidateReferences(FileName);
  
  // 杩斿洖楠岃瘉缁撴灉
  Result.IsValid := FErrorList.Count = 0;
  Result.Errors := FErrorList.ToArray;
  Result.Warnings := FWarningList.ToArray;
end;

function TConfigValidator.ValidateDirectory(const DirectoryPath: string): TValidationResult;
var
  Files: TArray<string>;
  FileName: string;
  FileResult: TValidationResult;
begin
  // 娓呴櫎涔嬪墠鐨勯敊璇拰璀﹀憡
  FErrorList.Clear;
  FWarningList.Clear;
  
  // 妫€鏌ョ洰褰曟槸鍚﹀瓨鍦?
  if not TDirectory.Exists(DirectoryPath) then
  begin
    AddError('鐩綍涓嶅瓨鍦? ' + DirectoryPath);
    Result.IsValid := False;
    Result.Errors := FErrorList.ToArray;
    Result.Warnings := FWarningList.ToArray;
    Exit;
  end;
  
  // 鑾峰彇鎵€鏈夐厤缃枃浠?
  Files := TDirectory.GetFiles(DirectoryPath, '*.ini', TSearchOption.soTopDirectoryOnly);
  Files := Files + TDirectory.GetFiles(DirectoryPath, '*.json', TSearchOption.soTopDirectoryOnly);
  
  // 閫愪釜楠岃瘉鏂囦欢
  for FileName in Files do
  begin
    FileResult := ValidateFile(FileName);
    
    // 鍚堝苟閿欒鍜岃鍛?
    if not FileResult.IsValid then
    begin
      for var Error in FileResult.Errors do
        AddError('[' + ExtractFileName(FileName) + '] ' + Error);
      
      for var Warning in FileResult.Warnings do
        AddWarning('[' + ExtractFileName(FileName) + '] ' + Warning);
    end;
  end;
  
  // 杩斿洖楠岃瘉缁撴灉
  Result.IsValid := FErrorList.Count = 0;
  Result.Errors := FErrorList.ToArray;
  Result.Warnings := FWarningList.ToArray;
end;

function TConfigValidator.ValidateFilesByPattern(const DirectoryPath, Pattern: string): TValidationResult;
var
  Files: TArray<string>;
  FileName: string;
  FileResult: TValidationResult;
  Regex: TRegEx;
begin
  // 娓呴櫎涔嬪墠鐨勯敊璇拰璀﹀憡
  FErrorList.Clear;
  FWarningList.Clear;
  
  // 妫€鏌ョ洰褰曟槸鍚﹀瓨鍦?
  if not TDirectory.Exists(DirectoryPath) then
  begin
    AddError('鐩綍涓嶅瓨鍦? ' + DirectoryPath);
    Result.IsValid := False;
    Result.Errors := FErrorList.ToArray;
    Result.Warnings := FWarningList.ToArray;
    Exit;
  end;
  
  // 鑾峰彇鎵€鏈夐厤缃枃浠?
  Files := TDirectory.GetFiles(DirectoryPath, '*.ini', TSearchOption.soTopDirectoryOnly);
  Files := Files + TDirectory.GetFiles(DirectoryPath, '*.json', TSearchOption.soTopDirectoryOnly);
  
  // 鍒涘缓姝ｅ垯琛ㄨ揪寮?
  try
    Regex := TRegEx.Create(Pattern, [roCompiled]);
  except
    AddError('鏃犳晥鐨勬鍒欒〃杈惧紡妯″紡: ' + Pattern);
    Result.IsValid := False;
    Result.Errors := FErrorList.ToArray;
    Result.Warnings := FWarningList.ToArray;
    Exit;
  end;
  
  // 閫愪釜楠岃瘉绗﹀悎妯″紡鐨勬枃浠?
  for FileName in Files do
  begin
    if Regex.IsMatch(ExtractFileName(FileName)) then
    begin
      FileResult := ValidateFile(FileName);
      
      // 鍚堝苟閿欒鍜岃鍛?
      if not FileResult.IsValid then
      begin
        for var Error in FileResult.Errors do
          AddError('[' + ExtractFileName(FileName) + '] ' + Error);
        
        for var Warning in FileResult.Warnings do
          AddWarning('[' + ExtractFileName(FileName) + '] ' + Warning);
      end;
    end;
  end;
  
  // 杩斿洖楠岃瘉缁撴灉
  Result.IsValid := FErrorList.Count = 0;
  Result.Errors := FErrorList.ToArray;
  Result.Warnings := FWarningList.ToArray;
end;

function TConfigValidator.ValidateINIFile(const FileName: string): Boolean;
var
  INIFile: TINIConfig;
begin
  Result := True;
  
  try
    // 灏濊瘯鍔犺浇INI鏂囦欢
    INIFile := TINIConfig.Create(FileName);
    try
      // 妫€鏌ユ槸鍚︽湁鑺?
      if Length(INIFile.ReadSections) = 0 then
      begin
        AddWarning('INI鏂囦欢娌℃湁浠讳綍鑺? ' + FileName);
        Result := False;
      end;
    finally
      INIFile.Free;
    end;
  except
    on E: Exception do
    begin
      AddError('INI鏂囦欢鏍煎紡閿欒: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TConfigValidator.ValidateJSONFile(const FileName: string): Boolean;
var
  JSONFile: TJSONConfig;
  JsonRoot: TJSONObject;
begin
  Result := True;
  
  try
    // 灏濊瘯鍔犺浇JSON鏂囦欢
    JSONFile := TJSONConfig.Create(FileName);
    try
      // 妫€鏌ユ槸鍚︽湁鏍瑰璞?
      JsonRoot := JSONFile.JSONObject;
      if not Assigned(JsonRoot) or (JsonRoot.Count = 0) then
      begin
        AddWarning('JSON鏂囦欢涓虹┖鎴栨病鏈夋湁鏁堢殑灞炴€? ' + FileName);
        Result := False;
      end;
    finally
      JSONFile.Free;
    end;
  except
    on E: Exception do
    begin
      AddError('JSON鏂囦欢鏍煎紡閿欒: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TConfigValidator.ValidateReferences(const FileName: string): Boolean;
var
  FileContent: string;
  RefMatches: TMatchCollection;
  Match: TMatch;
  RefPath: string;
  RefFile: string;
  Regex: TRegEx;
begin
  Result := True;
  
  try
    // 璇诲彇鏂囦欢鍐呭
    FileContent := TFile.ReadAllText(FileName);
    
    // 鎼滅储寮曠敤
    Regex := TRegEx.Create('\$\{([^\}]+)\}', [roCompiled]);
    RefMatches := Regex.Matches(FileContent);
    
    // 妫€鏌ユ瘡涓紩鐢?
    for Match in RefMatches do
    begin
      if Match.Success then
      begin
        RefPath := Match.Groups[1].Value;
        
        // 瑙ｆ瀽寮曠敤绫诲瀷
        if RefPath.StartsWith('INI:') then
        begin
          RefPath := Copy(RefPath, 5, Length(RefPath));
        end
        else if RefPath.StartsWith('JSON:') then
        begin
          RefPath := Copy(RefPath, 6, Length(RefPath));
        end;
        
        // 鎻愬彇寮曠敤鏂囦欢
        var Parts := RefPath.Split(['.']);
        if Length(Parts) >= 1 then
        begin
          if SameText(ExtractFileExt(FileName), '.ini') then
            RefFile := Parts[0] + '.ini'
          else
            RefFile := Parts[0] + '.json';
            
          // 妫€鏌ュ紩鐢ㄦ枃浠舵槸鍚﹀瓨鍦?
          if not TFile.Exists(TPath.Combine(ExtractFilePath(FileName), RefFile)) then
          begin
            AddError('寮曠敤鐨勬枃浠朵笉瀛樺湪: ' + RefFile);
            Result := False;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      AddError('楠岃瘉寮曠敤鏃跺彂鐢熼敊璇? ' + E.Message);
      Result := False;
    end;
  end;
end;

function TConfigValidator.ValidateFileExtension(const FileName: string): Boolean;
var
  Extension: string;
begin
  Extension := ExtractFileExt(FileName);
  Result := SameText(Extension, '.ini') or SameText(Extension, '.json');
  
  if not Result then
    AddError('涓嶆敮鎸佺殑鏂囦欢鎵╁睍鍚? ' + Extension);
end;

function TConfigValidator.ValidateNamingConvention(const FileName: string): Boolean;
var
  BaseName: string;
  Regex: TRegEx;
begin
  BaseName := ExtractFileName(FileName);
  
  // 妫€鏌ュ懡鍚嶈鑼? 鍒嗙被.妯″潡[.瀛愭ā鍧梋.鎵╁睍鍚?
  Regex := TRegEx.Create('^[a-zA-Z]+\.[a-z0-9_]+(\.[a-z0-9_]+)*\.(ini|json)$', [roCompiled, roIgnoreCase]);
  Result := Regex.IsMatch(BaseName);
  
  if not Result then
    AddWarning('鏂囦欢鍛藉悕涓嶇鍚堣鑼冿紙鍒嗙被.妯″潡[.瀛愭ā鍧梋.鎵╁睍鍚嶏級: ' + BaseName);
end;

{ 鍏ㄥ眬鍑芥暟 }

function ValidateConfigFile(const FileName: string): TValidationResult;
var
  Validator: TConfigValidator;
begin
  Validator := TConfigValidator.Create;
  try
    Result := Validator.ValidateFile(FileName);
  finally
    Validator.Free;
  end;
end;

function ValidateConfigDirectory(const DirectoryPath: string): TValidationResult;
var
  Validator: TConfigValidator;
begin
  Validator := TConfigValidator.Create;
  try
    Result := Validator.ValidateDirectory(DirectoryPath);
  finally
    Validator.Free;
  end;
end;

end. 