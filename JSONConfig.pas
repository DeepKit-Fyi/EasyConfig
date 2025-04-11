unit JSONConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils, System.Generics.Collections;

type
  TJSONConfig = class
  private
    FRootObject: TJSONObject;
    FFilePath: string;
    FModified: Boolean;
    
    // 杈呭姪鏂规硶
    function CreateJSONPath(const Path: string): TJSONObject;
    function ExtractJSONObject(JSONValue: TJSONValue): TJSONObject;
    function FindJSONValue(const Path: string): TJSONValue;
  public
    constructor Create;
    destructor Destroy; override;
    
    // 鏂囦欢鎿嶄綔
    procedure LoadFromFile(const FilePath: string);
    procedure SaveToFile(const FilePath: string);
    procedure Clear;
    
    // 璇诲彇鎿嶄綔
    function GetJSONObject(const Path: string): TJSONObject;
    function GetJSONArray(const Path: string): TJSONArray;
    function GetJSONValue(const Path: string): TJSONValue;
    
    // 璺緞鎿嶄綔
    function GetRootKeys: TArray<string>;
    function GetChildKeys(const Path: string): TArray<string>;
    
    // 鍐欏叆鎿嶄綔
    procedure SetJSONObject(const Path: string; JSONObj: TJSONObject);
    procedure SetJSONArray(const Path: string; JSONArray: TJSONArray);
    procedure SetJSONValue(const Path: string; JSONValue: TJSONValue);
    
    // 娣诲姞鍜屽垹闄ゆ搷浣?
    procedure AddJSONObject(const ParentPath, Name: string; JSONObj: TJSONObject);
    procedure DeleteJSONObject(const Path: string);
    
    // 寮曠敤鎿嶄綔
    function FindObjectByID(const ID: string): TJSONObject;
    
    // 灞炴€?
    property RootObject: TJSONObject read FRootObject;
    property FilePath: string read FFilePath;
    property Modified: Boolean read FModified write FModified;
  end;

implementation

{ TJSONConfig }

constructor TJSONConfig.Create;
begin
  inherited Create;
  FRootObject := TJSONObject.Create;
  FModified := False;
end;

destructor TJSONConfig.Destroy;
begin
  if Assigned(FRootObject) then
    FRootObject.Free;
  
  inherited;
end;

procedure TJSONConfig.AddJSONObject(const ParentPath, Name: string; JSONObj: TJSONObject);
var
  ParentObj: TJSONObject;
  NewObj: TJSONObject;
begin
  if (ParentPath = '') or (ParentPath = '/') then
    ParentObj := FRootObject
  else
    ParentObj := GetJSONObject(ParentPath);
  
  if not Assigned(ParentObj) then
    ParentObj := CreateJSONPath(ParentPath);
  
  // 鍒涘缓娣辨嫹璐濋伩鍏嶅閲嶅紩鐢?
  NewObj := TJSONObject(JSONObj.Clone);
  
  // 娣诲姞鎴栨浛鎹㈠璞?
  if ParentObj.FindValue(Name) <> nil then
    ParentObj.RemovePair(Name);
  
  ParentObj.AddPair(Name, NewObj);
  FModified := True;
end;

procedure TJSONConfig.Clear;
begin
  if Assigned(FRootObject) then
    FRootObject.Free;
  
  FRootObject := TJSONObject.Create;
  FModified := True;
end;

function TJSONConfig.CreateJSONPath(const Path: string): TJSONObject;
var
  PathParts: TArray<string>;
  CurrentObj, ChildObj: TJSONObject;
  i: Integer;
begin
  PathParts := Path.Split(['/']);
  CurrentObj := FRootObject;
  
  for i := 0 to Length(PathParts) - 1 do
  begin
    if PathParts[i] = '' then
      Continue;
    
    // 妫€鏌ヨ矾寰勬槸鍚﹀瓨鍦?
    if CurrentObj.FindValue(PathParts[i]) = nil then
    begin
      // 鍒涘缓鏂拌矾寰?
      ChildObj := TJSONObject.Create;
      CurrentObj.AddPair(PathParts[i], ChildObj);
      CurrentObj := ChildObj;
    end
    else
    begin
      // 鑾峰彇鐜版湁璺緞
      CurrentObj := ExtractJSONObject(CurrentObj.FindValue(PathParts[i]));
      if CurrentObj = nil then
      begin
        // 濡傛灉涓嶆槸瀵硅薄锛屽垱寤烘柊瀵硅薄
        ChildObj := TJSONObject.Create;
        CurrentObj.RemovePair(PathParts[i]);
        CurrentObj.AddPair(PathParts[i], ChildObj);
        CurrentObj := ChildObj;
      end;
    end;
  end;
  
  Result := CurrentObj;
end;

procedure TJSONConfig.DeleteJSONObject(const Path: string);
var
  PathParts: TArray<string>;
  ParentPath: string;
  ObjectName: string;
  ParentObj: TJSONObject;
  i: Integer;
begin
  PathParts := Path.Split(['/']);
  
  // 鍒嗙鐖惰矾寰勫拰瀵硅薄鍚?
  if Length(PathParts) <= 1 then
  begin
    // 鏍圭骇瀵硅薄
    if FRootObject.FindValue(Path) <> nil then
      FRootObject.RemovePair(Path);
  end
  else
  begin
    // 宓屽瀵硅薄
    ObjectName := PathParts[Length(PathParts) - 1];
    ParentPath := '';
    
    for i := 0 to Length(PathParts) - 2 do
    begin
      if PathParts[i] <> '' then
      begin
        if ParentPath <> '' then
          ParentPath := ParentPath + '/';
        ParentPath := ParentPath + PathParts[i];
      end;
    end;
    
    ParentObj := GetJSONObject(ParentPath);
    if Assigned(ParentObj) and (ParentObj.FindValue(ObjectName) <> nil) then
      ParentObj.RemovePair(ObjectName);
  end;
  
  FModified := True;
end;

function TJSONConfig.ExtractJSONObject(JSONValue: TJSONValue): TJSONObject;
begin
  Result := nil;
  
  if Assigned(JSONValue) and (JSONValue is TJSONObject) then
    Result := TJSONObject(JSONValue);
end;

function TJSONConfig.FindJSONValue(const Path: string): TJSONValue;
var
  PathParts: TArray<string>;
  CurrentValue: TJSONValue;
  i: Integer;
begin
  Result := nil;
  
  if Path = '' then
    Exit(FRootObject);
  
  PathParts := Path.Split(['/']);
  CurrentValue := FRootObject;
  
  for i := 0 to Length(PathParts) - 1 do
  begin
    if PathParts[i] = '' then
      Continue;
    
    if not (CurrentValue is TJSONObject) then
      Exit;
    
    CurrentValue := TJSONObject(CurrentValue).FindValue(PathParts[i]);
    if not Assigned(CurrentValue) then
      Exit;
  end;
  
  Result := CurrentValue;
end;

function TJSONConfig.FindObjectByID(const ID: string): TJSONObject;

  function FindInObject(Obj: TJSONObject): TJSONObject;
  var
    Pair: TJSONPair;
    Value: TJSONValue;
    ChildObj: TJSONObject;
    i: Integer;
  begin
    Result := nil;
    
    // 妫€鏌ュ綋鍓嶅璞℃槸鍚︽湁ID灞炴€?
    Value := Obj.FindValue('_id');
    if Assigned(Value) and (Value is TJSONString) and ((Value as TJSONString).Value = ID) then
      Exit(Obj);
    
    // 閬嶅巻鎵€鏈夊瓙瀵硅薄
    for i := 0 to Obj.Count - 1 do
    begin
      Pair := Obj.Pairs[i];
      
      if Pair.JsonValue is TJSONObject then
      begin
        ChildObj := FindInObject(TJSONObject(Pair.JsonValue));
        if Assigned(ChildObj) then
          Exit(ChildObj);
      end
      else if Pair.JsonValue is TJSONArray then
      begin
        // 妫€鏌ユ暟缁勪腑鐨勬瘡涓璞?
        var ArrayObj := TJSONArray(Pair.JsonValue);
        for var j := 0 to ArrayObj.Count - 1 do
        begin
          if ArrayObj.Items[j] is TJSONObject then
          begin
            ChildObj := FindInObject(TJSONObject(ArrayObj.Items[j]));
            if Assigned(ChildObj) then
              Exit(ChildObj);
          end;
        end;
      end;
    end;
  end;

begin
  Result := FindInObject(FRootObject);
end;

function TJSONConfig.GetChildKeys(const Path: string): TArray<string>;
var
  Obj: TJSONObject;
  i: Integer;
begin
  Obj := GetJSONObject(Path);
  
  if not Assigned(Obj) then
    Exit(nil);
  
  SetLength(Result, Obj.Count);
  for i := 0 to Obj.Count - 1 do
    Result[i] := Obj.Pairs[i].JsonString.Value;
end;

function TJSONConfig.GetJSONArray(const Path: string): TJSONArray;
var
  Value: TJSONValue;
begin
  Result := nil;
  
  Value := FindJSONValue(Path);
  if Assigned(Value) and (Value is TJSONArray) then
    Result := TJSONArray(Value);
end;

function TJSONConfig.GetJSONObject(const Path: string): TJSONObject;
begin
  Result := ExtractJSONObject(FindJSONValue(Path));
end;

function TJSONConfig.GetJSONValue(const Path: string): TJSONValue;
begin
  Result := FindJSONValue(Path);
end;

function TJSONConfig.GetRootKeys: TArray<string>;
var
  i: Integer;
begin
  SetLength(Result, FRootObject.Count);
  
  for i := 0 to FRootObject.Count - 1 do
    Result[i] := FRootObject.Pairs[i].JsonString.Value;
end;

procedure TJSONConfig.LoadFromFile(const FilePath: string);
var
  JSONStr: string;
  JSONValue: TJSONValue;
begin
  FFilePath := FilePath;
  
  if Assigned(FRootObject) then
    FRootObject.Free;
  
  if FileExists(FilePath) then
  begin
    try
      JSONStr := TFile.ReadAllText(FilePath, TEncoding.UTF8);
      JSONValue := TJSONObject.ParseJSONValue(JSONStr);
      
      if Assigned(JSONValue) and (JSONValue is TJSONObject) then
        FRootObject := TJSONObject(JSONValue)
      else begin
        if Assigned(JSONValue) then
          JSONValue.Free;
        FRootObject := TJSONObject.Create;
      end;
    except
      on E: Exception do
        FRootObject := TJSONObject.Create;
    end;
  end
  else
    FRootObject := TJSONObject.Create;
  
  FModified := False;
end;

procedure TJSONConfig.SaveToFile(const FilePath: string);
var
  JSONStr: string;
begin
  // 鍒涘缓鐩綍锛堝鏋滈渶瑕侊級
  if not TDirectory.Exists(ExtractFilePath(FilePath)) then
    TDirectory.CreateDirectory(ExtractFilePath(FilePath));
  
  // 鏍煎紡鍖朖SON骞朵繚瀛?
  JSONStr := FRootObject.Format(4);
  TFile.WriteAllText(FilePath, JSONStr, TEncoding.UTF8);
  
  FFilePath := FilePath;
  FModified := False;
end;

procedure TJSONConfig.SetJSONArray(const Path: string; JSONArray: TJSONArray);
var
  PathParts: TArray<string>;
  ParentPath: string;
  ObjectName: string;
  ParentObj: TJSONObject;
  NewArray: TJSONArray;
  i: Integer;
begin
  PathParts := Path.Split(['/']);
  
  // 鍒嗙鐖惰矾寰勫拰瀵硅薄鍚?
  if Length(PathParts) <= 1 then
  begin
    // 鏍圭骇瀵硅薄
    ObjectName := Path;
    ParentObj := FRootObject;
  end
  else
  begin
    // 宓屽瀵硅薄
    ObjectName := PathParts[Length(PathParts) - 1];
    ParentPath := '';
    
    for i := 0 to Length(PathParts) - 2 do
    begin
      if PathParts[i] <> '' then
      begin
        if ParentPath <> '' then
          ParentPath := ParentPath + '/';
        ParentPath := ParentPath + PathParts[i];
      end;
    end;
    
    ParentObj := GetJSONObject(ParentPath);
    if not Assigned(ParentObj) then
      ParentObj := CreateJSONPath(ParentPath);
  end;
  
  // 鍒涘缓娣辨嫹璐濋伩鍏嶅閲嶅紩鐢?
  NewArray := TJSONArray(JSONArray.Clone);
  
  // 鏇存柊鏁扮粍
  if ParentObj.FindValue(ObjectName) <> nil then
    ParentObj.RemovePair(ObjectName);
  
  ParentObj.AddPair(ObjectName, NewArray);
  FModified := True;
end;

procedure TJSONConfig.SetJSONObject(const Path: string; JSONObj: TJSONObject);
var
  PathParts: TArray<string>;
  ParentPath: string;
  ObjectName: string;
  ParentObj: TJSONObject;
  NewObj: TJSONObject;
  i: Integer;
begin
  PathParts := Path.Split(['/']);
  
  // 鍒嗙鐖惰矾寰勫拰瀵硅薄鍚?
  if Length(PathParts) <= 1 then
  begin
    // 鏍圭骇瀵硅薄
    ObjectName := Path;
    ParentObj := FRootObject;
  end
  else
  begin
    // 宓屽瀵硅薄
    ObjectName := PathParts[Length(PathParts) - 1];
    ParentPath := '';
    
    for i := 0 to Length(PathParts) - 2 do
    begin
      if PathParts[i] <> '' then
      begin
        if ParentPath <> '' then
          ParentPath := ParentPath + '/';
        ParentPath := ParentPath + PathParts[i];
      end;
    end;
    
    ParentObj := GetJSONObject(ParentPath);
    if not Assigned(ParentObj) then
      ParentObj := CreateJSONPath(ParentPath);
  end;
  
  // 鍒涘缓娣辨嫹璐濋伩鍏嶅閲嶅紩鐢?
  NewObj := TJSONObject(JSONObj.Clone);
  
  // 鏇存柊瀵硅薄
  if ParentObj.FindValue(ObjectName) <> nil then
    ParentObj.RemovePair(ObjectName);
  
  ParentObj.AddPair(ObjectName, NewObj);
  FModified := True;
end;

procedure TJSONConfig.SetJSONValue(const Path: string; JSONValue: TJSONValue);
var
  PathParts: TArray<string>;
  ParentPath: string;
  ValueName: string;
  ParentObj: TJSONObject;
  NewValue: TJSONValue;
  i: Integer;
begin
  PathParts := Path.Split(['/']);
  
  // 鍒嗙鐖惰矾寰勫拰鍊煎悕
  if Length(PathParts) <= 1 then
  begin
    // 鏍圭骇瀵硅薄
    ValueName := Path;
    ParentObj := FRootObject;
  end
  else
  begin
    // 宓屽瀵硅薄
    ValueName := PathParts[Length(PathParts) - 1];
    ParentPath := '';
    
    for i := 0 to Length(PathParts) - 2 do
    begin
      if PathParts[i] <> '' then
      begin
        if ParentPath <> '' then
          ParentPath := ParentPath + '/';
        ParentPath := ParentPath + PathParts[i];
      end;
    end;
    
    ParentObj := GetJSONObject(ParentPath);
    if not Assigned(ParentObj) then
      ParentObj := CreateJSONPath(ParentPath);
  end;
  
  // 鍒涘缓娣辨嫹璐濋伩鍏嶅閲嶅紩鐢?
  NewValue := TJSONValue(JSONValue.Clone);
  
  // 鏇存柊鍊?
  if ParentObj.FindValue(ValueName) <> nil then
    ParentObj.RemovePair(ValueName);
  
  ParentObj.AddPair(ValueName, NewValue);
  FModified := True;
end;

end.