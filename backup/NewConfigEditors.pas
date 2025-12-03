unit NewConfigEditors;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  ConfigTypes, ConfigEditorsBase;

type
  // 閰嶇疆缂栬緫鍣ㄥ伐鍘?
  TConfigEditorFactory = class
  private
    class var FCreators: TDictionary<TConfigType, TConfigEditorCreateFunc>;
    class constructor Create;
    class destructor Destroy;
  public
    // 娉ㄥ唽缂栬緫鍣ㄥ垱寤哄嚱鏁?
    class procedure RegisterEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
    
    // 鍒涘缓缂栬緫鍣ㄥ疄渚?
    class function CreateEditor(EditorType: TConfigType): IConfigEditor;
    
    // 娓呴櫎娉ㄥ唽淇℃伅
    class procedure ClearRegistrations;
  end;

// 娉ㄥ唽缂栬緫鍣ㄥ垱寤哄嚱鏁?
procedure RegisterConfigEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);

implementation

// 娉ㄥ唽缂栬緫鍣ㄥ垱寤哄嚱鏁?
procedure RegisterConfigEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
begin
  if Assigned(CreateFunc) then
    TConfigEditorFactory.RegisterEditor(EditorType, CreateFunc);
end;

{ TConfigEditorFactory }

class procedure TConfigEditorFactory.ClearRegistrations;
begin
  FCreators.Clear;
end;

class constructor TConfigEditorFactory.Create;
begin
  FCreators := TDictionary<TConfigType, TConfigEditorCreateFunc>.Create;
end;

class function TConfigEditorFactory.CreateEditor(EditorType: TConfigType): IConfigEditor;
var
  CreateFunc: TConfigEditorCreateFunc;
begin
  Result := nil;
  
  // 鏌ユ壘娉ㄥ唽鐨勫垱寤哄嚱鏁?
  if FCreators.TryGetValue(EditorType, CreateFunc) then
  begin
    // 璋冪敤鍒涘缓鍑芥暟
    Result := CreateFunc();
    Exit;
  end;
end;

class destructor TConfigEditorFactory.Destroy;
begin
  FCreators.Free;
end;

class procedure TConfigEditorFactory.RegisterEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
begin
  // 濡傛灉宸插瓨鍦ㄧ浉鍚岀被鍨嬬殑鍒涘缓鍑芥暟锛屽垯鍏堢Щ闄?
  if FCreators.ContainsKey(EditorType) then
    FCreators.Remove(EditorType);
  
  // 娣诲姞鍒涘缓鍑芥暟
  FCreators.Add(EditorType, CreateFunc);
end;

end. 