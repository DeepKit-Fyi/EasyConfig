unit ConfigEditorsBase;

interface

uses
  System.SysUtils, System.Classes, System.JSON;

type
  // 閰嶇疆缂栬緫鍣ㄥ熀绫绘帴鍙?
  IConfigEditor = interface
    ['{B2D4F9E1-6A9D-4F98-8C10-E4B4E96F5D32}']
    // 鑾峰彇缂栬緫鍣ㄧ被鍨?
    function GetEditorType: TConfigType;
    
    // 鍔犺浇閰嶇疆瀵硅薄
    procedure Load(const Config: TJSONObject);
    
    // 淇濆瓨鍒伴厤缃璞?
    function Save: TJSONObject;
    
    // 淇敼鐘舵€?
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    
    // 閫氱煡浜嬩欢
    function GetOnModified: TNotifyEvent;
    procedure SetOnModified(const Value: TNotifyEvent);
    
    // 灞炴€?
    property EditorType: TConfigType read GetEditorType;
    property Modified: Boolean read GetModified write SetModified;
    property OnModified: TNotifyEvent read GetOnModified write SetOnModified;
  end;

  // 閰嶇疆缂栬緫鍣ㄥ熀绫?
  TConfigEditorBase = class(TInterfacedObject, IConfigEditor)
  private
    FModified: Boolean;
    FOnModified: TNotifyEvent;
    FConfigType: TConfigType;
    
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    function GetOnModified: TNotifyEvent;
    procedure SetOnModified(const Value: TNotifyEvent);
  protected
    // 閰嶇疆鍙樻洿閫氱煡
    procedure DoModified; virtual;
  public
    constructor Create; virtual;
    
    // IConfigEditor鎺ュ彛瀹炵幇
    function GetEditorType: TConfigType; virtual; abstract;
    procedure Load(const Config: TJSONObject); virtual; abstract;
    function Save: TJSONObject; virtual; abstract;
    
    // 灞炴€?
    property Modified: Boolean read GetModified write SetModified;
    property OnModified: TNotifyEvent read GetOnModified write SetOnModified;
    property ConfigType: TConfigType read FConfigType write FConfigType;
  end;

  // 缂栬緫鍣ㄥ垱寤哄嚱鏁扮被鍨?
  TConfigEditorCreateFunc = function: IConfigEditor;
  
implementation

{ TConfigEditorBase }

constructor TConfigEditorBase.Create;
begin
  inherited Create;
  FModified := False;
end;

procedure TConfigEditorBase.DoModified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

function TConfigEditorBase.GetModified: Boolean;
begin
  Result := FModified;
end;

function TConfigEditorBase.GetOnModified: TNotifyEvent;
begin
  Result := FOnModified;
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

procedure TConfigEditorBase.SetOnModified(const Value: TNotifyEvent);
begin
  FOnModified := Value;
end;

end.