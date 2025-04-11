unit ConfigEditors;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.JSON, ConfigTypes, JSONConfig, INIConfig, System.TypInfo, System.Generics.Collections, 
  ConfigEditorsBase;

type
  // 閰嶇疆缂栬緫鍣ㄥ伐鍘?
  TConfigEditorFactory = class
  private
    class var FEditors: TDictionary<TConfigType, TConfigEditorCreateFunc>;
    class constructor Create;
    class destructor Destroy;
  public
    class procedure RegisterEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
    class function CreateEditor(ConfigType: TConfigType): IConfigEditor;
    class procedure ClearRegistrations;
  end;

// 娉ㄥ唽缂栬緫鍣ㄥ嚱鏁?
procedure RegisterConfigEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);

implementation

// 娉ㄥ唽缂栬緫鍣ㄥ嚱鏁?
procedure RegisterConfigEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
begin
  if Assigned(CreateFunc) then
    TConfigEditorFactory.RegisterEditor(EditorType, CreateFunc);
end;

{ TConfigEditorFactory }

class procedure TConfigEditorFactory.ClearRegistrations;
begin
  FEditors.Clear;
end;

class constructor TConfigEditorFactory.Create;
begin
  FEditors := TDictionary<TConfigType, TConfigEditorCreateFunc>.Create;
end;

class function TConfigEditorFactory.CreateEditor(ConfigType: TConfigType): IConfigEditor;
var
  CreateFunc: TConfigEditorCreateFunc;
begin
  Result := nil;
  
  // 鏌ユ壘娉ㄥ唽鐨勫垱寤哄嚱鏁?
  if FEditors.TryGetValue(ConfigType, CreateFunc) then
  begin
    // 璋冪敤鍒涘缓鍑芥暟
    Result := CreateFunc();
    Exit;
  end;
  
  // 濡傛灉娌℃湁鎵惧埌鍒涘缓鍑芥暟锛岃繑鍥瀗il
  // 鍏蜂綋鐨勭紪杈戝櫒绫诲瀷灏嗛€氳繃RegisterEditor鏂规硶娉ㄥ唽
end;

class destructor TConfigEditorFactory.Destroy;
begin
  FEditors.Free;
end;

class procedure TConfigEditorFactory.RegisterEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
begin
  // 濡傛灉宸插瓨鍦ㄧ浉鍚岀被鍨嬬殑鍒涘缓鍑芥暟锛屽垯鍏堢Щ闄?
  if FEditors.ContainsKey(EditorType) then
    FEditors.Remove(EditorType);
  
  // 娣诲姞鍒涘缓鍑芥暟
  FEditors.Add(EditorType, CreateFunc);
end;

end. 