unit ModelConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers;

type
  // 缂栬緫鍣ㄧ被鍨嬫灇涓?
  TEditorType = (etText, etJSON, etINI, etXML, etBinary);
  
  // 閰嶇疆鏂囨。鎺ュ彛
  IConfigDocument = interface
    ['{7C4D8E9F-6A53-4B5A-A604-4E7A8B9C0D1E}']
    function GetConfigPath: string;
    procedure SetConfigPath(const Value: string);
    function GetEditorType: TEditorType;
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    
    property ConfigPath: string read GetConfigPath write SetConfigPath;
    property EditorType: TEditorType read GetEditorType;
    property Modified: Boolean read GetModified write SetModified;
    
    function Load: Boolean;
    function Save: Boolean;
    function SaveAs(const FilePath: string): Boolean;
    function Validate: Boolean;
    function GetData: TObject;
  end;
  
  // 鍩虹閰嶇疆鏂囨。
  TConfigDocument = class(TInterfacedObject, IConfigDocument)
  private
    FConfigPath: string;
    FEditorType: TEditorType;
    FModified: Boolean;
    function GetConfigPath: string;
    procedure SetConfigPath(const Value: string);
    function GetEditorType: TEditorType;
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
  protected
    constructor Create(const AConfigPath: string; AEditorType: TEditorType);
  public
    property ConfigPath: string read GetConfigPath write SetConfigPath;
    property EditorType: TEditorType read GetEditorType;
    property Modified: Boolean read GetModified write SetModified;
    
    function Load: Boolean; virtual;
    function Save: Boolean; virtual;
    function SaveAs(const FilePath: string): Boolean; virtual;
    function Validate: Boolean; virtual;
    function GetData: TObject; virtual;
  end;

implementation

{ TConfigDocument }

constructor TConfigDocument.Create(const AConfigPath: string; AEditorType: TEditorType);
begin
  inherited Create;
  FConfigPath := AConfigPath;
  FEditorType := AEditorType;
  FModified := False;
end;

function TConfigDocument.GetConfigPath: string;
begin
  Result := FConfigPath;
end;

procedure TConfigDocument.SetConfigPath(const Value: string);
begin
  if FConfigPath <> Value then
  begin
    FConfigPath := Value;
  end;
end;

function TConfigDocument.GetEditorType: TEditorType;
begin
  Result := FEditorType;
end;

function TConfigDocument.GetModified: Boolean;
begin
  Result := FModified;
end;

procedure TConfigDocument.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

function TConfigDocument.Load: Boolean;
begin
  Result := False;
  // 瀛愮被瀹炵幇
end;

function TConfigDocument.Save: Boolean;
begin
  Result := False;
  if FConfigPath = '' then
    Exit;
    
  // 瀛愮被瀹炵幇
end;

function TConfigDocument.SaveAs(const FilePath: string): Boolean;
begin
  if FilePath = '' then
  begin
    Result := False;
    Exit;
  end;
  
  FConfigPath := FilePath;
  Result := Save;
end;

function TConfigDocument.Validate: Boolean;
begin
  Result := True;
  // 瀛愮被瀹炵幇
end;

function TConfigDocument.GetData: TObject;
begin
  Result := nil;
  // 瀛愮被瀹炵幇
end;

end. 