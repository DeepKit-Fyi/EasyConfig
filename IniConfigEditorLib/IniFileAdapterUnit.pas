unit IniFileAdapterUnit;

interface

uses
  System.Classes, System.SysUtils, System.IniFiles;

type
  TIniFileAdapter = class
  private
    FIniFile: TMemIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
    
    function ReadString(const Section, Name: string; const Default: string = ''): string;
    procedure WriteString(const Section, Name, Value: string);
    
    function ReadInteger(const Section, Name: string; const Default: Integer = 0): Integer;
    procedure WriteInteger(const Section, Name: string; const Value: Integer);
    
    function ReadBool(const Section, Name: string; const Default: Boolean = False): Boolean;
    procedure WriteBool(const Section, Name: string; const Value: Boolean);
    
    function ReadFloat(const Section, Name: string; const Default: Double = 0): Double;
    procedure WriteFloat(const Section, Name: string; const Value: Double);
    
    procedure ReadSections(Sections: TStrings);
    procedure ReadSection(const Section: string; Strings: TStrings);
    
    procedure EraseSection(const Section: string);
    procedure DeleteKey(const Section, Name: string);
  end;

implementation

{ TIniFileAdapter }

constructor TIniFileAdapter.Create;
begin
  inherited Create;
  FIniFile := nil;
end;

procedure TIniFileAdapter.DeleteKey(const Section, Name: string);
begin
  if Assigned(FIniFile) then
    FIniFile.DeleteKey(Section, Name);
end;

destructor TIniFileAdapter.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

procedure TIniFileAdapter.EraseSection(const Section: string);
begin
  if Assigned(FIniFile) then
    FIniFile.EraseSection(Section);
end;

procedure TIniFileAdapter.LoadFromFile(const FileName: string);
begin
  FreeAndNil(FIniFile);
  if FileExists(FileName) then
    FIniFile := TMemIniFile.Create(FileName, TEncoding.UTF8)
  else
    FIniFile := TMemIniFile.Create(ChangeFileExt(FileName, '.ini'), TEncoding.UTF8);
end;

function TIniFileAdapter.ReadBool(const Section, Name: string; const Default: Boolean): Boolean;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadBool(Section, Name, Default)
  else
    Result := Default;
end;

function TIniFileAdapter.ReadFloat(const Section, Name: string; const Default: Double): Double;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadFloat(Section, Name, Default)
  else
    Result := Default;
end;

function TIniFileAdapter.ReadInteger(const Section, Name: string; const Default: Integer): Integer;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadInteger(Section, Name, Default)
  else
    Result := Default;
end;

procedure TIniFileAdapter.ReadSection(const Section: string; Strings: TStrings);
begin
  if Assigned(FIniFile) then
    FIniFile.ReadSection(Section, Strings);
end;

procedure TIniFileAdapter.ReadSections(Sections: TStrings);
begin
  if Assigned(FIniFile) then
    FIniFile.ReadSections(Sections);
end;

function TIniFileAdapter.ReadString(const Section, Name, Default: string): string;
begin
  if Assigned(FIniFile) then
    Result := FIniFile.ReadString(Section, Name, Default)
  else
    Result := Default;
end;

procedure TIniFileAdapter.SaveToFile(const FileName: string);
begin
  if Assigned(FIniFile) then
  begin
    if FIniFile.FileName <> FileName then
    begin
      FIniFile.Free;
      FIniFile := TMemIniFile.Create(FileName, TEncoding.UTF8);
    end;
    FIniFile.UpdateFile;
  end
  else
    FIniFile := TMemIniFile.Create(FileName, TEncoding.UTF8);
end;

procedure TIniFileAdapter.WriteBool(const Section, Name: string; const Value: Boolean);
begin
  if Assigned(FIniFile) then
    FIniFile.WriteBool(Section, Name, Value);
end;

procedure TIniFileAdapter.WriteFloat(const Section, Name: string; const Value: Double);
begin
  if Assigned(FIniFile) then
    FIniFile.WriteFloat(Section, Name, Value);
end;

procedure TIniFileAdapter.WriteInteger(const Section, Name: string; const Value: Integer);
begin
  if Assigned(FIniFile) then
    FIniFile.WriteInteger(Section, Name, Value);
end;

procedure TIniFileAdapter.WriteString(const Section, Name, Value: string);
begin
  if Assigned(FIniFile) then
    FIniFile.WriteString(Section, Name, Value);
end;

end. 