unit ConfigEditors;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.JSON, JSONHelpers, JSONConfig, INIConfig, System.TypInfo, System.Generics.Collections,
  ConfigEditorsBase;

type
  // 配置编辑器工厂
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

// 注册编辑器函数
procedure RegisterConfigEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);

implementation

// 注册编辑器函数
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
  
  // 查找注册的创建函数
  if FEditors.TryGetValue(ConfigType, CreateFunc) then
  begin
    // 调用创建函数
    Result := CreateFunc();
    Exit;
  end;
  
  // 如果没有找到创建函数，返回nil
  // 具体的编辑器类型将通过RegisterEditor方法注册
end;

class destructor TConfigEditorFactory.Destroy;
begin
  FEditors.Free;
end;

class procedure TConfigEditorFactory.RegisterEditor(EditorType: TConfigType; CreateFunc: TConfigEditorCreateFunc);
begin
  // 如果已存在相同类型的创建函数，则先移除
  if FEditors.ContainsKey(EditorType) then
    FEditors.Remove(EditorType);
  
  // 添加创建函数
  FEditors.Add(EditorType, CreateFunc);
end;

end.