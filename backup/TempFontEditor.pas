unit TempFontEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.JSON, ConfigTypes;

type
  // 閰嶇疆缂栬緫鍣ㄥ熀绫?
  TConfigEditorBase = class
  private
    FModified: Boolean;
    FOnModified: TNotifyEvent;
    FConfigType: TConfigType;
    
    procedure SetModified(const Value: Boolean);
  protected
    // 閰嶇疆鍙樻洿閫氱煡
    procedure DoModified; virtual;
    
    property Modified: Boolean read FModified write SetModified;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    
    // 鍔犺浇閰嶇疆瀵硅薄
    procedure Load(const Config: TJSONObject); virtual; abstract;
    
    // 淇濆瓨鍒伴厤缃璞?
    function Save: TJSONObject; virtual; abstract;
    
    // 鑾峰彇缂栬緫鍣ㄧ被鍨?
    function GetEditorType: TConfigType; virtual; abstract;
    
    // 浜嬩欢
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property ConfigType: TConfigType read FConfigType write FConfigType;
  end;

  // 瀛椾綋缂栬緫鍣?
  TFontEditor = class(TConfigEditorBase)
  private
    FFont: TFont;
  public
    constructor Create; override;
    destructor Destroy; override;
    
    // 鍔犺浇閰嶇疆瀵硅薄
    procedure Load(const Config: TJSONObject); override;
    
    // 淇濆瓨鍒伴厤缃璞?
    function Save: TJSONObject; override;
    
    // 鑾峰彇缂栬緫鍣ㄧ被鍨?
    function GetEditorType: TConfigType; override;
  end;

implementation

{ TConfigEditorBase }

constructor TConfigEditorBase.Create;
begin
  FModified := False;
end;

destructor TConfigEditorBase.Destroy;
begin
  inherited;
end;

procedure TConfigEditorBase.DoModified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TConfigEditorBase.SetModified(const Value: Boolean);
begin
  if FModified <> Value then
  begin
    FModified := Value;
    
    if FModified then
      DoModified;
  end;
end;

{ TFontEditor }

constructor TFontEditor.Create;
begin
  inherited;
  FFont := TFont.Create;
  FFont.Name := 'Tahoma';
  FFont.Size := 10;
  FFont.Color := clBlack;
  FFont.Style := [];
  ConfigType := etFont;
end;

destructor TFontEditor.Destroy;
begin
  FFont.Free;
  inherited;
end;

function TFontEditor.GetEditorType: TConfigType;
begin
  Result := etFont;
end;

procedure TFontEditor.Load(const Config: TJSONObject);
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

function TFontEditor.Save: TJSONObject;
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