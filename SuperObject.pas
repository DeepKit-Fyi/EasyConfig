unit SuperObject;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.JSON, System.Generics.Collections;

type
  ISuperObject = interface
    ['{4B86A9E3-E094-4E5A-954A-69048B7B6327}']
    function GetI(const Path: string): Integer;
    function GetD(const Path: string): Double;
    function GetB(const Path: string): Boolean;
    function GetS(const Path: string): string;
    function GetO(const Path: string): ISuperObject;
    function GetA(const Path: string): TArray<ISuperObject>;
    procedure SetI(const Path: string; Value: Integer);
    procedure SetD(const Path: string; Value: Double);
    procedure SetB(const Path: string; Value: Boolean);
    procedure SetS(const Path: string; Value: string);
    function GetPath(const Path: string): ISuperObject;
    procedure SetPath(const Path: string; Value: Variant);
    function AsJSON(Pretty: Boolean): string;
    property I[const Path: string]: Integer read GetI write SetI; default;
    property D[const Path: string]: Double read GetD write SetD;
    property B[const Path: string]: Boolean read GetB write SetB;
    property S[const Path: string]: string read GetS write SetS;
    property O[const Path: string]: ISuperObject read GetO;
    property A[const Path: string]: TArray<ISuperObject> read GetA;
  end;

  TSuperObject = class(TInterfacedObject, ISuperObject)
  private
    FJSONValue: TJSONValue;
    function GetJSONValueByPath(const Path: string; CreateIfMissing: Boolean = False): TJSONValue;
    function EnsurePathExists(const Path: string): TJSONObject;
    function GetI(const Path: string): Integer;
    function GetD(const Path: string): Double;
    function GetB(const Path: string): Boolean;
    function GetS(const Path: string): string;
    function GetO(const Path: string): ISuperObject;
    function GetA(const Path: string): TArray<ISuperObject>;
    procedure SetI(const Path: string; Value: Integer);
    procedure SetD(const Path: string; Value: Double);
    procedure SetB(const Path: string; Value: Boolean);
    procedure SetS(const Path: string; Value: string);
  public
    constructor Create(JSONValue: TJSONValue = nil); overload;
    destructor Destroy; override;
    function GetPath(const Path: string): ISuperObject;
    procedure SetPath(const Path: string; Value: Variant);
    function AsJSON(Pretty: Boolean = False): string;
    class function ParseString(const S: string): ISuperObject;
    class function ParseFile(const FileName: string): ISuperObject;
    class function CreateObject: ISuperObject;
  end;

implementation

{ TSuperObject }

function TSuperObject.AsJSON(Pretty: Boolean): string;
begin
  if not Assigned(FJSONValue) then
    Result := '{}'
  else
  begin
    if Pretty then
      Result := TJSONObject(FJSONValue).Format
    else
      Result := FJSONValue.ToString;
  end;
end;

constructor TSuperObject.Create(JSONValue: TJSONValue);
begin
  if Assigned(JSONValue) then
    FJSONValue := JSONValue
  else
    FJSONValue := TJSONObject.Create;
end;

class function TSuperObject.CreateObject: ISuperObject;
begin
  Result := TSuperObject.Create;
end;

destructor TSuperObject.Destroy;
begin
  FreeAndNil(FJSONValue);
  inherited;
end;

function TSuperObject.EnsurePathExists(const Path: string): TJSONObject;
var
  Segments: TArray<string>;
  Current: TJSONObject;
  i: Integer;
  SegValue: string;
begin
  if not Assigned(FJSONValue) then
    FJSONValue := TJSONObject.Create;
    
  if not (FJSONValue is TJSONObject) then
  begin
    FreeAndNil(FJSONValue);
    FJSONValue := TJSONObject.Create;
  end;
  
  Segments := Path.Split(['.']);
  Current := TJSONObject(FJSONValue);
  
  for i := 0 to Length(Segments) - 2 do
  begin
    SegValue := Segments[i];
    if not Current.TryGetValue<TJSONObject>(SegValue, Result) then
    begin
      Result := TJSONObject.Create;
      Current.AddPair(SegValue, Result);
    end;
    Current := Result;
  end;
  
  Result := Current;
end;

function TSuperObject.GetA(const Path: string): TArray<ISuperObject>;
var
  JArr: TJSONArray;
  Value: TJSONValue;
  i: Integer;
begin
  SetLength(Result, 0);
  
  Value := GetJSONValueByPath(Path, False);
  if Assigned(Value) and (Value is TJSONArray) then
  begin
    JArr := TJSONArray(Value);
    SetLength(Result, JArr.Count);
    
    for i := 0 to JArr.Count - 1 do
      Result[i] := TSuperObject.Create(JArr.Items[i].Clone as TJSONValue);
  end;
end;

function TSuperObject.GetB(const Path: string): Boolean;
var
  Value: TJSONValue;
begin
  Result := False;
  Value := GetJSONValueByPath(Path, False);
  
  if Assigned(Value) then
  begin
    if Value is TJSONBool then
      Result := TJSONBool(Value).AsBoolean
    else
      try
        Result := StrToBool(Value.Value);
      except
        Result := False;
      end;
  end;
end;

function TSuperObject.GetD(const Path: string): Double;
var
  Value: TJSONValue;
begin
  Result := 0;
  Value := GetJSONValueByPath(Path, False);
  
  if Assigned(Value) then
  begin
    if Value is TJSONNumber then
      Result := TJSONNumber(Value).AsDouble
    else
      try
        Result := StrToFloat(Value.Value);
      except
        Result := 0;
      end;
  end;
end;

function TSuperObject.GetI(const Path: string): Integer;
var
  Value: TJSONValue;
begin
  Result := 0;
  Value := GetJSONValueByPath(Path, False);
  
  if Assigned(Value) then
  begin
    if Value is TJSONNumber then
      Result := TJSONNumber(Value).AsInt
    else
      try
        Result := StrToInt(Value.Value);
      except
        Result := 0;
      end;
  end;
end;

function TSuperObject.GetJSONValueByPath(const Path: string; CreateIfMissing: Boolean): TJSONValue;
var
  Segments: TArray<string>;
  i: Integer;
  Current: TJSONObject;
  LastSegment: string;
begin
  Result := nil;
  
  // 澶勭悊绌鸿矾寰?
  if Path = '' then
    Exit(FJSONValue);
    
  if not Assigned(FJSONValue) then
  begin
    if not CreateIfMissing then
      Exit(nil);
      
    FJSONValue := TJSONObject.Create;
  end;
  
  // 濡傛灉涓嶆槸瀵硅薄锛屾棤娉曡幏鍙栬矾寰?
  if not (FJSONValue is TJSONObject) then
    Exit;
    
  Segments := Path.Split(['.']);
  Current := TJSONObject(FJSONValue);
  
  for i := 0 to Length(Segments) - 2 do
  begin
    if not Current.TryGetValue<TJSONObject>(Segments[i], Current) then
    begin
      if not CreateIfMissing then
        Exit;
        
      Current.AddPair(Segments[i], TJSONObject.Create);
      Current := Current.GetValue(Segments[i]) as TJSONObject;
    end;
  end;
  
  LastSegment := Segments[Length(Segments) - 1];
  Result := Current.GetValue(LastSegment);
end;

function TSuperObject.GetO(const Path: string): ISuperObject;
var
  Value: TJSONValue;
begin
  Value := GetJSONValueByPath(Path, False);
  if Assigned(Value) and (Value is TJSONObject) then
    Result := TSuperObject.Create(Value.Clone as TJSONValue)
  else
    Result := nil;
end;

function TSuperObject.GetPath(const Path: string): ISuperObject;
var
  Value: TJSONValue;
begin
  Value := GetJSONValueByPath(Path, False);
  if Assigned(Value) then
    Result := TSuperObject.Create(Value.Clone as TJSONValue)
  else
    Result := nil;
end;

function TSuperObject.GetS(const Path: string): string;
var
  Value: TJSONValue;
begin
  Result := '';
  Value := GetJSONValueByPath(Path, False);
  
  if Assigned(Value) then
  begin
    if Value is TJSONString then
      Result := TJSONString(Value).Value
    else
      Result := Value.Value;
  end;
end;

class function TSuperObject.ParseFile(const FileName: string): ISuperObject;
var
  FileContent: string;
  sl: TStringList;
begin
  if not FileExists(FileName) then
  begin
    Result := TSuperObject.CreateObject;
    Exit;
  end;
  
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FileName);
    FileContent := sl.Text;
    Result := ParseString(FileContent);
  finally
    sl.Free;
  end;
end;

class function TSuperObject.ParseString(const S: string): ISuperObject;
var
  JSONValue: TJSONValue;
begin
  if S = '' then
  begin
    Result := TSuperObject.CreateObject;
    Exit;
  end;
  
  try
    JSONValue := TJSONObject.ParseJSONValue(S);
    if Assigned(JSONValue) then
      Result := TSuperObject.Create(JSONValue)
    else
      Result := TSuperObject.CreateObject;
  except
    Result := TSuperObject.CreateObject;
  end;
end;

procedure TSuperObject.SetB(const Path: string; Value: Boolean);
var
  Parent: TJSONObject;
  LastSegment: string;
  Segments: TArray<string>;
begin
  Segments := Path.Split(['.']);
  LastSegment := Segments[Length(Segments) - 1];
  
  Parent := EnsurePathExists(Path);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(LastSegment);
    Parent.AddPair(LastSegment, TJSONBool.Create(Value));
  end;
end;

procedure TSuperObject.SetD(const Path: string; Value: Double);
var
  Parent: TJSONObject;
  LastSegment: string;
  Segments: TArray<string>;
begin
  Segments := Path.Split(['.']);
  LastSegment := Segments[Length(Segments) - 1];
  
  Parent := EnsurePathExists(Path);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(LastSegment);
    Parent.AddPair(LastSegment, TJSONNumber.Create(Value));
  end;
end;

procedure TSuperObject.SetI(const Path: string; Value: Integer);
var
  Parent: TJSONObject;
  LastSegment: string;
  Segments: TArray<string>;
begin
  Segments := Path.Split(['.']);
  LastSegment := Segments[Length(Segments) - 1];
  
  Parent := EnsurePathExists(Path);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(LastSegment);
    Parent.AddPair(LastSegment, TJSONNumber.Create(Value));
  end;
end;

procedure TSuperObject.SetPath(const Path: string; Value: Variant);
begin
  case VarType(Value) of
    varInteger, varInt64, varShortInt, varSmallint, varByte:
      SetI(Path, Value);
    varDouble, varSingle, varCurrency:
      SetD(Path, Value);
    varBoolean:
      SetB(Path, Value);
    else
      SetS(Path, VarToStr(Value));
  end;
end;

procedure TSuperObject.SetS(const Path: string; Value: string);
var
  Parent: TJSONObject;
  LastSegment: string;
  Segments: TArray<string>;
begin
  Segments := Path.Split(['.']);
  LastSegment := Segments[Length(Segments) - 1];
  
  Parent := EnsurePathExists(Path);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(LastSegment);
    Parent.AddPair(LastSegment, Value);
  end;
end;

end. 