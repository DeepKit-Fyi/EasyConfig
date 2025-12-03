unit JSONHelpers;

interface

uses
  System.SysUtils, System.Classes, System.JSON;

type
  // TJSONObject扩展
  TJSONObjectHelper = class helper for TJSONObject
  public
    function AddPair(const Name: string; const Value: string): TJSONObject; overload;
    function AddPair(const Name: string; const Value: TJSONValue): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Boolean): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Integer): TJSONObject; overload;
    function AddPair(const Name: string; const Value: Double): TJSONObject; overload;
    function RemovePair(const Name: string): TJSONObject;
  end;

implementation

{ TJSONObjectHelper }

function TJSONObjectHelper.AddPair(const Name: string; const Value: string): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONString.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: TJSONValue): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), Value));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Boolean): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONBool.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Integer): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONNumber.Create(Value)));
end;

function TJSONObjectHelper.AddPair(const Name: string; const Value: Double): TJSONObject;
begin
  Result := Self;
  Self.AddPair(TJSONPair.Create(TJSONString.Create(Name), TJSONNumber.Create(Value)));
end;

function TJSONObjectHelper.RemovePair(const Name: string): TJSONObject;
begin
  Result := Self;
  
  // 删除指定名称的配对
  if Assigned(Self) then
  begin
    // 使用原始类自带的RemovePair方法
    // 我们的这个助手方法只是为了确保它返回Self而不是TJSONPair
    TJSONPair(Self.RemovePair(Name)).Free;
  end;
end;

end. 
