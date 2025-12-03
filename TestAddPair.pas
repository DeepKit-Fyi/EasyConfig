unit TestAddPair;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers;

procedure TestJSON;

implementation

procedure TestJSON;
var
  JSONObject: TJSONObject;
begin
  JSONObject := TJSONObject.Create;
  try
    // 测试 AddPair 方法
    JSONObject.AddPair('test', 'value');
    WriteLn(JSONObject.ToString);
  finally
    JSONObject.Free;
  end;
end;

end. 