unit ConfigRegistry;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  ConfigTypes;

type
  // 閰嶇疆瀵硅薄娉ㄥ唽琛?
  TConfigObjectRegistry = class
  private
    FMetadata: TDictionary<string, TConfigObjectMeta>;
    FConfigTypes: TDictionary<string, TConfigObjectClass>;
    
    function GenerateConfigID(const TypeId: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 娉ㄥ唽閰嶇疆瀵硅薄绫诲瀷
    procedure RegisterConfigType(const TypeId: string; 
                               ConfigClass: TConfigObjectClass;
                               const Meta: TConfigObjectMeta);
    
    // 鑾峰彇閰嶇疆瀵硅薄鍏冩暟鎹?
    function GetConfigMeta(const TypeId: string): TConfigObjectMeta;
    
    // 鍒涘缓閰嶇疆瀵硅薄瀹炰緥
    function CreateConfig(const TypeId, Name: string): TConfigObject;
    
    // 鑾峰彇鎵€鏈夋敞鍐岀殑绫诲瀷
    function GetAllConfigTypes: TArray<string>;
    
    // 妫€鏌ョ被鍨嬫槸鍚﹀凡娉ㄥ唽
    function IsTypeRegistered(const TypeId: string): Boolean;
  end;

implementation

{ TConfigObjectRegistry }

constructor TConfigObjectRegistry.Create;
begin
  inherited Create;
  FMetadata := TDictionary<string, TConfigObjectMeta>.Create;
  FConfigTypes := TDictionary<string, TConfigObjectClass>.Create;
end;

destructor TConfigObjectRegistry.Destroy;
var
  Meta: TConfigObjectMeta;
begin
  // 娓呯悊鍏冩暟鎹璞?
  for Meta in FMetadata.Values do
    Meta.Free;
    
  FMetadata.Free;
  FConfigTypes.Free;
  inherited;
end;

procedure TConfigObjectRegistry.RegisterConfigType(const TypeId: string;
  ConfigClass: TConfigObjectClass; const Meta: TConfigObjectMeta);
begin
  // 妫€鏌ユ槸鍚﹀凡娉ㄥ唽
  if FConfigTypes.ContainsKey(TypeId) then
  begin
    // 鏇存柊鐜版湁绫诲瀷
    if FMetadata.ContainsKey(TypeId) then
      FMetadata[TypeId].Free;
  end;
  
  // 娉ㄥ唽绫诲瀷鍜屽厓鏁版嵁
  FConfigTypes.AddOrSetValue(TypeId, ConfigClass);
  FMetadata.AddOrSetValue(TypeId, Meta);
end;

function TConfigObjectRegistry.GetConfigMeta(const TypeId: string): TConfigObjectMeta;
begin
  if not FMetadata.TryGetValue(TypeId, Result) then
    Result := nil;
end;

function TConfigObjectRegistry.CreateConfig(const TypeId, Name: string): TConfigObject;
var
  ConfigClass: TConfigObjectClass;
  ConfigId: string;
  ConfigName: string;
  Meta: TConfigObjectMeta;
begin
  Result := nil;
  
  // 鏌ユ壘娉ㄥ唽鐨勭被鍨?
  if not FConfigTypes.TryGetValue(TypeId, ConfigClass) then
    Exit;
    
  // 鐢熸垚閰嶇疆ID
  ConfigId := GenerateConfigID(TypeId);
  
  // 纭畾鍚嶇О
  if Name = '' then
    ConfigName := TypeId + '_' + ConfigId
  else
    ConfigName := Name;
    
  // 鑾峰彇鍏冩暟鎹腑鐨凜onfigType
  Meta := GetConfigMeta(TypeId);
  if Meta = nil then
    Exit;
    
  // 鍒涘缓閰嶇疆瀵硅薄
  Result := ConfigClass.Create(ConfigId, ConfigName, '', TypeId, Meta.ConfigType);
end;

function TConfigObjectRegistry.GetAllConfigTypes: TArray<string>;
begin
  Result := FConfigTypes.Keys.ToArray;
end;

function TConfigObjectRegistry.IsTypeRegistered(const TypeId: string): Boolean;
begin
  Result := FConfigTypes.ContainsKey(TypeId);
end;

function TConfigObjectRegistry.GenerateConfigID(const TypeId: string): string;
var
  GUID: TGUID;
begin
  // 鐢熸垚GUID
  CreateGUID(GUID);
  
  // 杞崲涓虹煭瀛楃涓?
  Result := Copy(GUIDToString(GUID).Replace('{', '').Replace('}', '').Replace('-', ''), 1, 12);
end;

end. 