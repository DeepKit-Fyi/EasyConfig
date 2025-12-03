unit ConfigObjects;

interface

uses
  ConfigObjectDefs, System.SysUtils, System.Classes, System.IniFiles, SuperObject;

type
  { 鏁版嵁搴撻厤缃璞?}
  TDatabaseConfig = class(TINIConfigObject)
  private
    FServer: string;
    FPort: Integer;
    FUsername: string;
    FPassword: string;
    
    function DecryptString(const Value: string): string;
    function EncryptString(const Value: string): string;
  public
    procedure LoadFromFile(const FileName: String); override;
    procedure SaveToFile(const FileName: String); override;
    function Validate(out Errors: TStringList): Boolean; override;

    // 灞炴€ц闂櫒
    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;

  protected
    procedure InternalLoad(Ini: TMemIniFile); override;
    procedure InternalSave(Ini: TMemIniFile); override;
  end;

  { 椤甸潰甯冨眬閰嶇疆瀵硅薄 }
  TLayoutConfig = class(TJSONConfigObject)
  private
    FWindowWidth: Integer;
    FWindowHeight: Integer;
    FBackgroundColor: string;
  public
    procedure LoadFromFile(const FileName: String); override;
    procedure SaveToFile(const FileName: String); override;
    function Validate(out Errors: TStringList): Boolean; override;

    property WindowWidth: Integer read FWindowWidth write FWindowWidth;
    property WindowHeight: Integer read FWindowHeight write FWindowHeight;
    property BackgroundColor: string read FBackgroundColor write FBackgroundColor;

  protected
    procedure InternalLoad(Json: ISuperObject); override;
    procedure InternalSave(Json: ISuperObject); override;
  end;

implementation

{ TDatabaseConfig }

function TDatabaseConfig.DecryptString(const Value: string): string;
begin
  // 绠€鍗曡В瀵嗗疄鐜帮紝瀹為檯椤圭洰涓簲浣跨敤鏇村畨鍏ㄧ殑鍔犲瘑鏂规硶
  if Value.StartsWith('ENC(') and Value.EndsWith(')') then
    Result := Copy(Value, 5, Length(Value) - 5)
  else
    Result := Value;
end;

function TDatabaseConfig.EncryptString(const Value: string): string;
begin
  // 绠€鍗曞姞瀵嗗疄鐜帮紝瀹為檯椤圭洰涓簲浣跨敤鏇村畨鍏ㄧ殑鍔犲瘑鏂规硶
  Result := 'ENC(' + Value + ')';
end;

procedure TDatabaseConfig.InternalLoad(Ini: TMemIniFile);
begin
  FServer := Ini.ReadString('Database', 'Server', 'localhost');
  FPort := Ini.ReadInteger('Database', 'Port', 3306);
  FUsername := Ini.ReadString('Database', 'Username', 'root');
  FPassword := DecryptString(Ini.ReadString('Database', 'Password', ''));
end;

procedure TDatabaseConfig.InternalSave(Ini: TMemIniFile);
begin
  Ini.WriteString('Database', 'Server', FServer);
  Ini.WriteInteger('Database', 'Port', FPort);
  Ini.WriteString('Database', 'Username', FUsername);
  Ini.WriteString('Database', 'Password', EncryptString(FPassword));
end;

function TDatabaseConfig.Validate(out Errors: TStringList): Boolean;
begin
  Errors := TStringList.Create;
  Result := True;
  
  if FServer.IsEmpty then
  begin
    Errors.Add('鏈嶅姟鍣ㄥ湴鍧€涓嶈兘涓虹┖');
    Result := False;
  end;
  
  if (FPort < 1) or (FPort > 65535) then
  begin
    Errors.Add('绔彛鍙锋棤鏁?);
    Result := False;
  end;
end;

procedure TDatabaseConfig.LoadFromFile(const FileName: String);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(FileName, TEncoding.UTF8);
  try
    InternalLoad(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TDatabaseConfig.SaveToFile(const FileName: String);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(FileName, TEncoding.UTF8);
  try
    InternalSave(Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

{ TLayoutConfig }

procedure TLayoutConfig.InternalLoad(Json: ISuperObject);
begin
  FWindowWidth := Json.I['window.width'];
  FWindowHeight := Json.I['window.height'];
  FBackgroundColor := Json.S['style.backgroundColor'];
end;

procedure TLayoutConfig.InternalSave(Json: ISuperObject);
begin
  Json.I['window.width'] := FWindowWidth;
  Json.I['window.height'] := FWindowHeight;
  Json.S['style.backgroundColor'] := FBackgroundColor;
end;

function TLayoutConfig.Validate(out Errors: TStringList): Boolean;
begin
  Errors := TStringList.Create;
  Result := True;
  
  if FWindowWidth < 100 then
  begin
    Errors.Add('绐楀彛瀹藉害涓嶈兘灏忎簬100');
    Result := False;
  end;
  
  if not FBackgroundColor.StartsWith('#') then
  begin
    Errors.Add('棰滆壊鏍煎紡閿欒');
    Result := False;
  end;
end;

procedure TLayoutConfig.LoadFromFile(const FileName: String);
var
  Json: ISuperObject;
begin
  Json := TSuperObject.ParseFile(FileName);
  if Assigned(Json) then
    InternalLoad(Json);
end;

procedure TLayoutConfig.SaveToFile(const FileName: String);
var
  Json: ISuperObject;
  sl: TStringList;
begin
  Json := TSuperObject.Create;
  InternalSave(Json);
  
  sl := TStringList.Create;
  try
    sl.Text := Json.AsJSon(True);
    sl.SaveToFile(FileName, TEncoding.UTF8);
  finally
    sl.Free;
  end;
end;

end.