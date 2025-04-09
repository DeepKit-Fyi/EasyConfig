unit ModelRegistry;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Generics.Defaults,
  ModelConfig;

type
  // 閰嶇疆澶勭悊鍣ㄦ帴鍙?
  IConfigProcessor = interface
    ['{8D5E9F0A-AA64-7D6C-EE15-5F8A9B0C1D2E}']
    function GetName: string;
    function GetDescription: string;
    function GetSupportedExtensions: TArray<string>;
    function GetEditorType: TEditorType;
    
    property Name: string read GetName;
    property Description: string read GetDescription;
    property SupportedExtensions: TArray<string> read GetSupportedExtensions;
    property EditorType: TEditorType read GetEditorType;
    
    function CanProcess(const FilePath: string): Boolean;
    function CreateDocument(const FilePath: string = ''): IConfigDocument;
    function CreateEmpty(const FilePath: string): Boolean;
    function ValidateFile(const FilePath: string): Boolean;
  end;

  // 閰嶇疆澶勭悊鍣ㄥ熀绫?
  TConfigProcessor = class abstract(TInterfacedObject, IConfigProcessor)
  private
    FName: string;
    FDescription: string;
    FSupportedExtensions: TArray<string>;
    FEditorType: TEditorType;
    
    function GetName: string;
    function GetDescription: string;
    function GetSupportedExtensions: TArray<string>;
    function GetEditorType: TEditorType;
  protected
    constructor Create(const AName, ADescription: string; const ASupportedExtensions: TArray<string>; AEditorType: TEditorType);
  public
    property Name: string read GetName;
    property Description: string read GetDescription;
    property SupportedExtensions: TArray<string> read GetSupportedExtensions;
    property EditorType: TEditorType read GetEditorType;
    
    function CanProcess(const FilePath: string): Boolean; virtual;
    function CreateDocument(const FilePath: string = ''): IConfigDocument; virtual; abstract;
    function CreateEmpty(const FilePath: string): Boolean; virtual;
    function ValidateFile(const FilePath: string): Boolean; virtual;
  end;

  // 閰嶇疆娉ㄥ唽琛?- 鍗曚緥妯″紡
  TConfigRegistry = class
  private
    class var FInstance: TConfigRegistry;
    
    FProcessors: TList<IConfigProcessor>;
    FExtensionMap: TDictionary<string, IConfigProcessor>;
    
    constructor Create;
    procedure BuildExtensionMap;
  public
    destructor Destroy; override;
    
    class function GetInstance: TConfigRegistry;
    class procedure ReleaseInstance;
    
    procedure RegisterProcessor(Processor: IConfigProcessor);
    procedure UnregisterProcessor(const ProcessorName: string);
    function FindProcessorByName(const Name: string): IConfigProcessor;
    function FindProcessorByExtension(const Extension: string): IConfigProcessor;
    function FindProcessorByFile(const FilePath: string): IConfigProcessor;
    function GetAllProcessors: TArray<IConfigProcessor>;
    function GetSupportedExtensions: TArray<string>;
    
    function CreateDocument(const FilePath: string): IConfigDocument;
    function CreateEmptyFile(const FilePath: string): Boolean;
    function ValidateFile(const FilePath: string): Boolean;
  end;

  // 閰嶇疆澶勭悊鍣ㄥ伐鍘?
  TConfigProcessorFactory = class
  public
    class procedure RegisterDefaultProcessors;
  end;

implementation

uses
  System.IOUtils, System.StrUtils;

{ TConfigProcessor }

constructor TConfigProcessor.Create(const AName, ADescription: string; const ASupportedExtensions: TArray<string>; AEditorType: TEditorType);
begin
  inherited Create;
  FName := AName;
  FDescription := ADescription;
  FSupportedExtensions := ASupportedExtensions;
  FEditorType := AEditorType;
end;

function TConfigProcessor.GetName: string;
begin
  Result := FName;
end;

function TConfigProcessor.GetDescription: string;
begin
  Result := FDescription;
end;

function TConfigProcessor.GetSupportedExtensions: TArray<string>;
begin
  Result := FSupportedExtensions;
end;

function TConfigProcessor.GetEditorType: TEditorType;
begin
  Result := FEditorType;
end;

function TConfigProcessor.CanProcess(const FilePath: string): Boolean;
var
  Ext: string;
  i: Integer;
begin
  Result := False;
  
  if FilePath = '' then
    Exit;
    
  Ext := LowerCase(ExtractFileExt(FilePath));
  if Ext <> '' then
    Ext := Copy(Ext, 2, Length(Ext)); // 绉婚櫎鐐瑰彿
    
  for i := 0 to Length(FSupportedExtensions) - 1 do
  begin
    if SameText(Ext, FSupportedExtensions[i]) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TConfigProcessor.CreateEmpty(const FilePath: string): Boolean;
var
  Document: IConfigDocument;
begin
  Result := False;
  
  if FilePath = '' then
    Exit;
    
  if not CanProcess(FilePath) then
    Exit;
    
  try
    Document := CreateDocument(FilePath);
    if Document <> nil then
      Result := Document.Save;
  except
    Result := False;
  end;
end;

function TConfigProcessor.ValidateFile(const FilePath: string): Boolean;
var
  Document: IConfigDocument;
begin
  Result := False;
  
  if not FileExists(FilePath) then
    Exit;
    
  if not CanProcess(FilePath) then
    Exit;
    
  try
    Document := CreateDocument(FilePath);
    if Document <> nil then
    begin
      Result := Document.Load and Document.Validate;
    end;
  except
    Result := False;
  end;
end;

{ TConfigRegistry }

constructor TConfigRegistry.Create;
begin
  inherited Create;
  FProcessors := TList<IConfigProcessor>.Create;
  FExtensionMap := TDictionary<string, IConfigProcessor>.Create;
end;

destructor TConfigRegistry.Destroy;
begin
  FExtensionMap.Free;
  FProcessors.Free;
  inherited;
end;

class function TConfigRegistry.GetInstance: TConfigRegistry;
begin
  if FInstance = nil then
    FInstance := TConfigRegistry.Create;
  Result := FInstance;
end;

class procedure TConfigRegistry.ReleaseInstance;
begin
  if FInstance <> nil then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TConfigRegistry.BuildExtensionMap;
var
  i, j: Integer;
  Processor: IConfigProcessor;
  Ext: string;
begin
  FExtensionMap.Clear;
  
  for i := 0 to FProcessors.Count - 1 do
  begin
    Processor := FProcessors[i];
    for j := 0 to Length(Processor.SupportedExtensions) - 1 do
    begin
      Ext := Processor.SupportedExtensions[j];
      if not FExtensionMap.ContainsKey(LowerCase(Ext)) then
        FExtensionMap.Add(LowerCase(Ext), Processor);
    end;
  end;
end;

procedure TConfigRegistry.RegisterProcessor(Processor: IConfigProcessor);
begin
  if Processor = nil then
    Exit;
    
  // 妫€鏌ユ槸鍚﹀凡娉ㄥ唽
  if FindProcessorByName(Processor.Name) <> nil then
    Exit;
    
  FProcessors.Add(Processor);
  BuildExtensionMap;
end;

procedure TConfigRegistry.UnregisterProcessor(const ProcessorName: string);
var
  i: Integer;
begin
  for i := FProcessors.Count - 1 downto 0 do
  begin
    if SameText(FProcessors[i].Name, ProcessorName) then
    begin
      FProcessors.Delete(i);
      Break;
    end;
  end;
  
  BuildExtensionMap;
end;

function TConfigRegistry.FindProcessorByName(const Name: string): IConfigProcessor;
var
  i: Integer;
  Processor: IConfigProcessor;
begin
  Result := nil;
  
  for i := 0 to FProcessors.Count - 1 do
  begin
    Processor := FProcessors[i];
    if SameText(Processor.Name, Name) then
    begin
      Result := Processor;
      Break;
    end;
  end;
end;

function TConfigRegistry.FindProcessorByExtension(const Extension: string): IConfigProcessor;
var
  Ext: string;
begin
  Result := nil;
  
  Ext := LowerCase(Extension);
  if (Ext <> '') and (Ext[1] = '.') then
    Ext := Copy(Ext, 2, Length(Ext)); // 绉婚櫎鐐瑰彿
    
  if FExtensionMap.ContainsKey(Ext) then
    Result := FExtensionMap[Ext];
end;

function TConfigRegistry.FindProcessorByFile(const FilePath: string): IConfigProcessor;
var
  Ext: string;
  i: Integer;
  Processor: IConfigProcessor;
begin
  if FilePath = '' then
  begin
    Result := nil;
    Exit;
  end;
  
  Ext := LowerCase(ExtractFileExt(FilePath));
  if Ext <> '' then
    Ext := Copy(Ext, 2, Length(Ext)); // 绉婚櫎鐐瑰彿
    
  Result := FindProcessorByExtension(Ext);
  
  // 濡傛灉鏈壘鍒板鐞嗗櫒锛屽垯閬嶅巻鎵€鏈夊鐞嗗櫒妫€鏌ユ槸鍚﹀彲浠ュ鐞?
  if Result = nil then
  begin
    for i := 0 to FProcessors.Count - 1 do
    begin
      Processor := FProcessors[i];
      if Processor.CanProcess(FilePath) then
      begin
        Result := Processor;
        Exit;
      end;
    end;
    
    Result := nil;
  end;
end;

function TConfigRegistry.GetAllProcessors: TArray<IConfigProcessor>;
var
  i: Integer;
begin
  SetLength(Result, FProcessors.Count);
  for i := 0 to FProcessors.Count - 1 do
    Result[i] := FProcessors[i];
end;

function TConfigRegistry.GetSupportedExtensions: TArray<string>;
var
  Extensions: TList<string>;
  Processor: IConfigProcessor;
  Ext: string;
  i, j, k: Integer;
begin
  Extensions := TList<string>.Create;
  try
    for i := 0 to FProcessors.Count - 1 do
    begin
      Processor := FProcessors[i];
      for j := 0 to Length(Processor.SupportedExtensions) - 1 do
      begin
        Ext := Processor.SupportedExtensions[j];
        if Extensions.IndexOf(Ext) < 0 then
          Extensions.Add(Ext);
      end;
    end;
    
    SetLength(Result, Extensions.Count);
    for k := 0 to Extensions.Count - 1 do
      Result[k] := Extensions[k];
  finally
    Extensions.Free;
  end;
end;

function TConfigRegistry.CreateDocument(const FilePath: string): IConfigDocument;
var
  Processor: IConfigProcessor;
begin
  Result := nil;
  
  Processor := FindProcessorByFile(FilePath);
  if Processor <> nil then
    Result := Processor.CreateDocument(FilePath);
end;

function TConfigRegistry.CreateEmptyFile(const FilePath: string): Boolean;
var
  Processor: IConfigProcessor;
begin
  Result := False;
  
  Processor := FindProcessorByFile(FilePath);
  if Processor <> nil then
    Result := Processor.CreateEmpty(FilePath);
end;

function TConfigRegistry.ValidateFile(const FilePath: string): Boolean;
var
  Processor: IConfigProcessor;
begin
  Result := False;
  
  if not FileExists(FilePath) then
    Exit;
    
  Processor := FindProcessorByFile(FilePath);
  if Processor <> nil then
    Result := Processor.ValidateFile(FilePath);
end;

{ TConfigProcessorFactory }

class procedure TConfigProcessorFactory.RegisterDefaultProcessors;
begin
  // 姝ゆ柟娉曞皢鍦ㄥ叿浣撳疄鐜颁腑娉ㄥ唽鎵€鏈夐粯璁ょ殑閰嶇疆澶勭悊鍣?
  // 渚嬪JSONConfig, INIConfig, XMLConfig绛?
  // 鍦ㄥ疄闄呭簲鐢ㄧ▼搴忎腑瀹炵幇
end;

initialization
  // 娉ㄥ唽榛樿澶勭悊鍣?
  TConfigProcessorFactory.RegisterDefaultProcessors;

finalization
  // 閲婃斁鍗曚緥瀹炰緥
  TConfigRegistry.ReleaseInstance;

end. 