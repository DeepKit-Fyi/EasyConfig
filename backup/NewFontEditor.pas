unit NewFontEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.JSON, ConfigTypes, ConfigEditorsBase;

type
  TNewFontEditor = class(TConfigEditorBase)
  private
    FFont: TFont;
  public
    constructor Create; override;
    destructor Destroy; override;
    
    // IConfigEditor鎺ュ彛瀹炵幇
    function GetEditorType: TConfigType; override;
    procedure Load(const Config: TJSONObject); override;
    function Save: TJSONObject; override;
    
    // 鑾峰彇瀛椾綋瀵硅薄
    property Font: TFont read FFont;
  end;

  // 缂栬緫鍣ㄥ垱寤哄嚱鏁?
  function CreateFontEditor: IConfigEditor;

implementation

function CreateFontEditor: IConfigEditor;
begin
  Result := TNewFontEditor.Create;
end;

{ TNewFontEditor }

constructor TNewFontEditor.Create;
begin
  inherited;
  FFont := TFont.Create;
  FFont.Name := 'Tahoma';
  FFont.Size := 10;
  FFont.Color := clBlack;
  FFont.Style := [];
  ConfigType := etFont;
end;

destructor TNewFontEditor.Destroy;
begin
  FFont.Free;
  inherited;
end;

function TNewFontEditor.GetEditorType: TConfigType;
begin
  Result := etFont;
end;

procedure TNewFontEditor.Load(const Config: TJSONObject);
var
  Value: TJSONValue;
  StyleValue: Integer;
begin
  if Assigned(Config) then
  begin
    // 鍔犺浇瀛椾綋鍚嶇О
    Value := Config.GetValue('Name');
    if Assigned(Value) then
      FFont.Name := Value.Value;
      
    // 鍔犺浇瀛椾綋澶у皬
    Value := Config.GetValue('Size');
    if Assigned(Value) and (Value is TJSONNumber) then
      FFont.Size := TJSONNumber(Value).AsInt;
      
    // 鍔犺浇瀛椾綋鏍峰紡
    Value := Config.GetValue('Style');
    if Assigned(Value) and (Value is TJSONNumber) then
    begin
      StyleValue := TJSONNumber(Value).AsInt;
      FFont.Style := TFontStyles(Byte(StyleValue));
    end;
    
    // 鍔犺浇瀛椾綋棰滆壊
    Value := Config.GetValue('Color');
    if Assigned(Value) and (Value is TJSONNumber) then
      FFont.Color := TColor(TJSONNumber(Value).AsInt);
  end;
end;

function TNewFontEditor.Save: TJSONObject;
begin
  Result := TJSONObject.Create;
  
  // 淇濆瓨瀛椾綋鍚嶇О
  Result.AddPair('Name', FFont.Name);
  
  // 淇濆瓨瀛椾綋澶у皬
  Result.AddPair('Size', TJSONNumber.Create(FFont.Size));
  
  // 淇濆瓨瀛椾綋鏍峰紡
  Result.AddPair('Style', TJSONNumber.Create(Byte(FFont.Style)));
  
  // 淇濆瓨瀛椾綋棰滆壊
  Result.AddPair('Color', TJSONNumber.Create(Integer(FFont.Color)));
end;

end. 