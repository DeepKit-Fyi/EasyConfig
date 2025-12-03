unit ConfigItemsUnit;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls,
  System.IniFiles;

type
  TPosition = record
    X: Integer;
    Y: Integer;
    IsCenterX: Boolean;
    IsCenterY: Boolean;
  end;

  TScale = record
    Width: Integer;
    Height: Integer;
    KeepAspectRatio: Boolean;
  end;

  TDrawSettings = record
    // 缁樺埗璁剧疆鐨勫睘鎬?
  end;

  // 閰嶇疆椤规帴鍙?
  IConfigItem = interface
    ['{F8A5D3E1-B7C4-4D2A-9F8E-6A7B5C4D3E2F}']
    function GetDisplayName: string;
    procedure SetDisplayName(const Value: string);
    function GetName: string;
    procedure SetName(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetZOrder: Integer;
    procedure SetZOrder(const Value: Integer);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetPosition: TPosition;
    procedure SetPosition(const Value: TPosition);
    function GetParent: IConfigItem;
    procedure SetParent(const Value: IConfigItem);
    function GetItemType: string;
    
    // 灞炴€?
    property DisplayName: string read GetDisplayName write SetDisplayName;
    property Name: string read GetName write SetName;
    property Description: string read GetDescription write SetDescription;
    property ZOrder: Integer read GetZOrder write SetZOrder;
    property Visible: Boolean read GetVisible write SetVisible;
    property Position: TPosition read GetPosition write SetPosition;
    property Parent: IConfigItem read GetParent write SetParent;
    property ItemType: string read GetItemType;
    
    // 鏂规硶
    function AddChild(Item: IConfigItem): Integer;
    procedure RemoveChild(Item: IConfigItem);
    function GetChildCount: Integer;
    function GetChild(Index: Integer): IConfigItem;
    procedure SaveToIni(const Section: string; IniFile: TObject);
    procedure LoadFromIni(const Section: string; IniFile: TObject);
    function Clone: IConfigItem;
    procedure AssignTo(Dest: IConfigItem);
    function CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode;
  end;

  // 鍩烘湰閰嶇疆椤圭被
  TBaseConfigItem = class(TInterfacedObject, IConfigItem)
  private
    FDisplayName: string;
    FName: string;
    FDescription: string;
    FZOrder: Integer;
    FVisible: Boolean;
    FPosition: TPosition;
    FParent: IConfigItem;
    FChildren: TInterfaceList;
  protected
    function GetDisplayName: string;
    procedure SetDisplayName(const Value: string);
    function GetName: string;
    procedure SetName(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetZOrder: Integer;
    procedure SetZOrder(const Value: Integer);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetPosition: TPosition;
    procedure SetPosition(const Value: TPosition);
    function GetParent: IConfigItem;
    procedure SetParent(const Value: IConfigItem);
    function GetItemType: string; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    
    // IConfigItem 鎺ュ彛瀹炵幇
    function AddChild(Item: IConfigItem): Integer;
    procedure RemoveChild(Item: IConfigItem);
    function GetChildCount: Integer;
    function GetChild(Index: Integer): IConfigItem;
    procedure SaveToIni(const Section: string; IniFile: TObject); virtual;
    procedure LoadFromIni(const Section: string; IniFile: TObject); virtual;
    function Clone: IConfigItem; virtual;
    procedure AssignTo(Dest: IConfigItem); virtual;
    function CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode; virtual;
  end;

  // 鏂囨湰閰嶇疆椤?
  TTextConfigItem = class(TBaseConfigItem)
  private
    FValue: string;
    FFontRef: string;
    FFontEffectRef: string;
    FColor: TColor;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Value: string read FValue write FValue;
    property FontRef: string read FFontRef write FFontRef;
    property FontEffectRef: string read FFontEffectRef write FFontEffectRef;
    property Color: TColor read FColor write FColor;
  end;

  // 鐩綍閰嶇疆椤?
  TDirConfigItem = class(TBaseConfigItem)
  private
    FPath: string;
  protected
    function GetItemType: string; override;
  public
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Path: string read FPath write FPath;
  end;

  // 鏂囦欢閰嶇疆椤?
  TFileConfigItem = class(TBaseConfigItem)
  private
    FPath: string;
    FFileType: string;
  protected
    function GetItemType: string; override;
  public
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Path: string read FPath write FPath;
    property FileType: string read FFileType write FFileType;
  end;

  // 杈撳叆閰嶇疆椤?
  TInputConfigItem = class(TBaseConfigItem)
  private
    FText: string;
    FFontRef: string;
  protected
    function GetItemType: string; override;
  public
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Text: string read FText write FText;
    property FontRef: string read FFontRef write FFontRef;
  end;

  // 鍥惧儚閰嶇疆椤?
  TImageConfigItem = class(TBaseConfigItem)
  private
    FFileName: string;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    FScale: TScale;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property FileName: string read FFileName write FFileName;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: TColor read FTransparentColor write FTransparentColor;
    property Scale: TScale read FScale write FScale;
  end;

  // 鍥惧儚缁樺埗鍣ㄩ厤缃」
  TImageDrawerConfigItem = class(TBaseConfigItem)
  private
    FDrawerType: string;
    FOpacity: Integer;
    FBlendMode: string;
    FDrawSettings: TDrawSettings;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property DrawerType: string read FDrawerType write FDrawerType;
    property Opacity: Integer read FOpacity write FOpacity;
    property BlendMode: string read FBlendMode write FBlendMode;
    property DrawSettings: TDrawSettings read FDrawSettings write FDrawSettings;
  end;

  // 涓嬫媺妗嗛厤缃」
  TComboConfigItem = class(TBaseConfigItem)
  private
    FValues: TStringList;
    FSelectedValue: string;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Values: TStringList read FValues;
    property SelectedValue: string read FSelectedValue write FSelectedValue;
  end;

  // 棰滆壊閰嶇疆椤?
  TColorConfigItem = class(TBaseConfigItem)
  private
    FColor: TColor;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Color: TColor read FColor write FColor;
  end;

  // 瀛椾綋閰嶇疆椤?
  TFontConfigItem = class(TBaseConfigItem)
  private
    FFont: TFont;
  protected
    function GetItemType: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IConfigItem; override;
    procedure AssignTo(Dest: IConfigItem); override;
    
    property Font: TFont read FFont;
  end;

  // 閰嶇疆椤瑰伐鍘?
  TConfigItemFactory = class
  public
    class function CreateConfigItem(const ItemType: string): IConfigItem;
  end;

implementation

uses
  System.TypInfo, MainFormUnit;

{ TBaseConfigItem }

function TBaseConfigItem.AddChild(Item: IConfigItem): Integer;
begin
  Item.Parent := Self;
  Result := FChildren.Add(Item);
end;

procedure TBaseConfigItem.AssignTo(Dest: IConfigItem);
begin
  if Dest = nil then Exit;
  
  Dest.DisplayName := FDisplayName;
  Dest.Name := FName;
  Dest.Description := FDescription;
  Dest.ZOrder := FZOrder;
  Dest.Visible := FVisible;
  Dest.Position := FPosition;
end;

function TBaseConfigItem.Clone: IConfigItem;
begin
  Result := TConfigItemFactory.CreateConfigItem(GetItemType);
  AssignTo(Result);
end;

constructor TBaseConfigItem.Create;
begin
  inherited Create;
  FChildren := TInterfaceList.Create;
  FVisible := True;
  FZOrder := 0;
  FPosition.X := 0;
  FPosition.Y := 0;
  FPosition.IsCenterX := False;
  FPosition.IsCenterY := False;
end;

function TBaseConfigItem.CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode;
var
  I: Integer;
  ChildItem: IConfigItem;
begin
  if ParentNode = nil then
    Result := TreeView.Items.Add(nil, FDisplayName)
  else
    Result := TreeView.Items.AddChild(ParentNode, FDisplayName);
    
  Result.Data := Pointer(Self);
  
  for I := 0 to GetChildCount - 1 do
  begin
    ChildItem := GetChild(I);
    ChildItem.CreateTreeNode(TreeView, Result);
  end;
end;

destructor TBaseConfigItem.Destroy;
begin
  FChildren.Free;
  inherited;
end;

function TBaseConfigItem.GetChild(Index: Integer): IConfigItem;
begin
  Result := FChildren[Index] as IConfigItem;
end;

function TBaseConfigItem.GetChildCount: Integer;
begin
  Result := FChildren.Count;
end;

function TBaseConfigItem.GetDescription: string;
begin
  Result := FDescription;
end;

function TBaseConfigItem.GetDisplayName: string;
begin
  Result := FDisplayName;
end;

function TBaseConfigItem.GetItemType: string;
begin
  Result := 'Base';
end;

function TBaseConfigItem.GetName: string;
begin
  Result := FName;
end;

function TBaseConfigItem.GetParent: IConfigItem;
begin
  Result := FParent;
end;

function TBaseConfigItem.GetPosition: TPosition;
begin
  Result := FPosition;
end;

function TBaseConfigItem.GetVisible: Boolean;
begin
  Result := FVisible;
end;

function TBaseConfigItem.GetZOrder: Integer;
begin
  Result := FZOrder;
end;

procedure TBaseConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  if not (IniFile is TCustomIniFile) then Exit;
  
  FDisplayName := TCustomIniFile(IniFile).ReadString(Section, 'DisplayName', '');
  FName := TCustomIniFile(IniFile).ReadString(Section, 'Name', '');
  FDescription := TCustomIniFile(IniFile).ReadString(Section, 'Description', '');
  FZOrder := TCustomIniFile(IniFile).ReadInteger(Section, 'ZOrder', 0);
  FVisible := TCustomIniFile(IniFile).ReadBool(Section, 'Visible', True);
  FPosition.X := TCustomIniFile(IniFile).ReadInteger(Section, 'Position.X', 0);
  FPosition.Y := TCustomIniFile(IniFile).ReadInteger(Section, 'Position.Y', 0);
  FPosition.IsCenterX := TCustomIniFile(IniFile).ReadBool(Section, 'Position.IsCenterX', False);
  FPosition.IsCenterY := TCustomIniFile(IniFile).ReadBool(Section, 'Position.IsCenterY', False);
end;

procedure TBaseConfigItem.RemoveChild(Item: IConfigItem);
var
  I: Integer;
begin
  for I := 0 to FChildren.Count - 1 do
  begin
    if FChildren[I] = Item then
    begin
      FChildren.Delete(I);
      Break;
    end;
  end;
end;

procedure TBaseConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'DisplayName', FDisplayName);
  TCustomIniFile(IniFile).WriteString(Section, 'Name', FName);
  TCustomIniFile(IniFile).WriteString(Section, 'Description', FDescription);
  TCustomIniFile(IniFile).WriteInteger(Section, 'ZOrder', FZOrder);
  TCustomIniFile(IniFile).WriteBool(Section, 'Visible', FVisible);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Position.X', FPosition.X);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Position.Y', FPosition.Y);
  TCustomIniFile(IniFile).WriteBool(Section, 'Position.IsCenterX', FPosition.IsCenterX);
  TCustomIniFile(IniFile).WriteBool(Section, 'Position.IsCenterY', FPosition.IsCenterY);
end;

procedure TBaseConfigItem.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TBaseConfigItem.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

procedure TBaseConfigItem.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseConfigItem.SetParent(const Value: IConfigItem);
begin
  FParent := Value;
end;

procedure TBaseConfigItem.SetPosition(const Value: TPosition);
begin
  FPosition := Value;
end;

procedure TBaseConfigItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TBaseConfigItem.SetZOrder(const Value: Integer);
begin
  FZOrder := Value;
end;

{ TTextConfigItem }

procedure TTextConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TTextConfigItem then
  begin
    TTextConfigItem(Dest).Value := FValue;
    TTextConfigItem(Dest).FontRef := FFontRef;
    TTextConfigItem(Dest).FontEffectRef := FFontEffectRef;
    TTextConfigItem(Dest).Color := FColor;
  end;
end;

function TTextConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TTextConfigItem.GetItemType: string;
begin
  Result := 'Text';
end;

constructor TTextConfigItem.Create;
begin
  inherited;
  FColor := clBlack;
end;

procedure TTextConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FValue := TCustomIniFile(IniFile).ReadString(Section, 'Value', '');
  FFontRef := TCustomIniFile(IniFile).ReadString(Section, 'FontRef', '');
  FFontEffectRef := TCustomIniFile(IniFile).ReadString(Section, 'FontEffectRef', '');
  
  // 璇诲彇棰滆壊灞炴€?
  try
    FColor := StringToColor(TCustomIniFile(IniFile).ReadString(Section, 'Color', 'clBlack'));
  except
    FColor := clBlack;
  end;
end;

procedure TTextConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'Value', FValue);
  TCustomIniFile(IniFile).WriteString(Section, 'FontRef', FFontRef);
  TCustomIniFile(IniFile).WriteString(Section, 'FontEffectRef', FFontEffectRef);
  
  // 淇濆瓨棰滆壊灞炴€?
  TCustomIniFile(IniFile).WriteString(Section, 'Color', ColorToString(FColor));
end;

{ TDirConfigItem }

procedure TDirConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TDirConfigItem then
  begin
    TDirConfigItem(Dest).Path := FPath;
  end;
end;

function TDirConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TDirConfigItem.GetItemType: string;
begin
  Result := 'Directory';
end;

procedure TDirConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FPath := TCustomIniFile(IniFile).ReadString(Section, 'Path', '');
end;

procedure TDirConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'Path', FPath);
end;

{ TFileConfigItem }

procedure TFileConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TFileConfigItem then
  begin
    TFileConfigItem(Dest).Path := FPath;
    TFileConfigItem(Dest).FileType := FFileType;
  end;
end;

function TFileConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TFileConfigItem.GetItemType: string;
begin
  Result := 'File';
end;

procedure TFileConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FPath := TCustomIniFile(IniFile).ReadString(Section, 'Path', '');
  FFileType := TCustomIniFile(IniFile).ReadString(Section, 'FileType', '');
end;

procedure TFileConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'Path', FPath);
  TCustomIniFile(IniFile).WriteString(Section, 'FileType', FFileType);
end;

{ TInputConfigItem }

procedure TInputConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TInputConfigItem then
  begin
    TInputConfigItem(Dest).Text := FText;
    TInputConfigItem(Dest).FontRef := FFontRef;
  end;
end;

function TInputConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TInputConfigItem.GetItemType: string;
begin
  Result := 'Input';
end;

procedure TInputConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FText := TCustomIniFile(IniFile).ReadString(Section, 'Text', '');
  FFontRef := TCustomIniFile(IniFile).ReadString(Section, 'FontRef', '');
end;

procedure TInputConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'Text', FText);
  TCustomIniFile(IniFile).WriteString(Section, 'FontRef', FFontRef);
end;

{ TImageConfigItem }

procedure TImageConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TImageConfigItem then
  begin
    TImageConfigItem(Dest).FileName := FFileName;
    TImageConfigItem(Dest).Transparent := FTransparent;
    TImageConfigItem(Dest).TransparentColor := FTransparentColor;
    TImageConfigItem(Dest).Scale := FScale;
  end;
end;

function TImageConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

constructor TImageConfigItem.Create;
begin
  inherited;
  FTransparent := False;
  FTransparentColor := clWhite;
  FScale.Width := 0;
  FScale.Height := 0;
  FScale.KeepAspectRatio := True;
end;

function TImageConfigItem.GetItemType: string;
begin
  Result := 'Image';
end;

procedure TImageConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FFileName := TCustomIniFile(IniFile).ReadString(Section, 'FileName', '');
  FTransparent := TCustomIniFile(IniFile).ReadBool(Section, 'Transparent', False);
  FTransparentColor := TCustomIniFile(IniFile).ReadInteger(Section, 'TransparentColor', clWhite);
  FScale.Width := TCustomIniFile(IniFile).ReadInteger(Section, 'Scale.Width', 0);
  FScale.Height := TCustomIniFile(IniFile).ReadInteger(Section, 'Scale.Height', 0);
  FScale.KeepAspectRatio := TCustomIniFile(IniFile).ReadBool(Section, 'Scale.KeepAspectRatio', True);
end;

procedure TImageConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'FileName', FFileName);
  TCustomIniFile(IniFile).WriteBool(Section, 'Transparent', FTransparent);
  TCustomIniFile(IniFile).WriteInteger(Section, 'TransparentColor', FTransparentColor);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Scale.Width', FScale.Width);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Scale.Height', FScale.Height);
  TCustomIniFile(IniFile).WriteBool(Section, 'Scale.KeepAspectRatio', FScale.KeepAspectRatio);
end;

{ TImageDrawerConfigItem }

procedure TImageDrawerConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TImageDrawerConfigItem then
  begin
    TImageDrawerConfigItem(Dest).DrawerType := FDrawerType;
    TImageDrawerConfigItem(Dest).Opacity := FOpacity;
    TImageDrawerConfigItem(Dest).BlendMode := FBlendMode;
    TImageDrawerConfigItem(Dest).DrawSettings := FDrawSettings;
  end;
end;

function TImageDrawerConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

constructor TImageDrawerConfigItem.Create;
begin
  inherited;
  FOpacity := 255;
  FBlendMode := 'Normal';
end;

function TImageDrawerConfigItem.GetItemType: string;
begin
  Result := 'ImageDrawer';
end;

procedure TImageDrawerConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FDrawerType := TCustomIniFile(IniFile).ReadString(Section, 'DrawerType', '');
  FOpacity := TCustomIniFile(IniFile).ReadInteger(Section, 'Opacity', 255);
  FBlendMode := TCustomIniFile(IniFile).ReadString(Section, 'BlendMode', 'Normal');
end;

procedure TImageDrawerConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'DrawerType', FDrawerType);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Opacity', FOpacity);
  TCustomIniFile(IniFile).WriteString(Section, 'BlendMode', FBlendMode);
end;

{ TComboConfigItem }

constructor TComboConfigItem.Create;
begin
  inherited;
  FValues := TStringList.Create;
end;

destructor TComboConfigItem.Destroy;
begin
  FValues.Free;
  inherited;
end;

procedure TComboConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TComboConfigItem then
  begin
    TComboConfigItem(Dest).Values.Assign(FValues);
    TComboConfigItem(Dest).SelectedValue := FSelectedValue;
  end;
end;

function TComboConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TComboConfigItem.GetItemType: string;
begin
  Result := 'Combo';
end;

procedure TComboConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
var
  Count, I: Integer;
  ValueName: string;
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  // 娓呯┖鐜版湁鍊?
  FValues.Clear;
  
  // 璇诲彇鍊肩殑鏁伴噺
  Count := TCustomIniFile(IniFile).ReadInteger(Section, 'Values.Count', 0);
  
  // 閫愪釜璇诲彇鍊?
  for I := 0 to Count - 1 do
  begin
    ValueName := Format('Values.Item%d', [I]);
    FValues.Add(TCustomIniFile(IniFile).ReadString(Section, ValueName, ''));
  end;
  
  FSelectedValue := TCustomIniFile(IniFile).ReadString(Section, 'SelectedValue', '');
end;

procedure TComboConfigItem.SaveToIni(const Section: string; IniFile: TObject);
var
  I: Integer;
  ValueName: string;
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  // 淇濆瓨鍊肩殑鏁伴噺
  TCustomIniFile(IniFile).WriteInteger(Section, 'Values.Count', FValues.Count);
  
  // 閫愪釜淇濆瓨鍊?
  for I := 0 to FValues.Count - 1 do
  begin
    ValueName := Format('Values.Item%d', [I]);
    TCustomIniFile(IniFile).WriteString(Section, ValueName, FValues[I]);
  end;
  
  TCustomIniFile(IniFile).WriteString(Section, 'SelectedValue', FSelectedValue);
end;

{ TColorConfigItem }

constructor TColorConfigItem.Create;
begin
  inherited;
  FColor := clWhite;
end;

procedure TColorConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TColorConfigItem then
  begin
    TColorConfigItem(Dest).Color := FColor;
  end;
end;

function TColorConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TColorConfigItem.GetItemType: string;
begin
  Result := 'Color';
end;

procedure TColorConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  FColor := TCustomIniFile(IniFile).ReadInteger(Section, 'Color', clWhite);
end;

procedure TColorConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteInteger(Section, 'Color', FColor);
end;

{ TFontConfigItem }

constructor TFontConfigItem.Create;
begin
  inherited;
  FFont := TFont.Create;
end;

destructor TFontConfigItem.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TFontConfigItem.AssignTo(Dest: IConfigItem);
begin
  inherited;
  
  if Dest is TFontConfigItem then
  begin
    TFontConfigItem(Dest).Font.Assign(FFont);
  end;
end;

function TFontConfigItem.Clone: IConfigItem;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

function TFontConfigItem.GetItemType: string;
begin
  Result := 'Font';
end;

procedure TFontConfigItem.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  // 浣跨敤鐜版湁鐨凾IniFile鏂规硶璇诲彇瀛椾綋淇℃伅
  FFont.Name := TCustomIniFile(IniFile).ReadString(Section, 'Font.Name', 'Arial');
  FFont.Size := TCustomIniFile(IniFile).ReadInteger(Section, 'Font.Size', 10);
  FFont.Color := TCustomIniFile(IniFile).ReadInteger(Section, 'Font.Color', clBlack);
  FFont.Style := [];
  
  if TCustomIniFile(IniFile).ReadBool(Section, 'Font.Bold', False) then
    FFont.Style := FFont.Style + [fsBold];
  if TCustomIniFile(IniFile).ReadBool(Section, 'Font.Italic', False) then
    FFont.Style := FFont.Style + [fsItalic];
  if TCustomIniFile(IniFile).ReadBool(Section, 'Font.Underline', False) then
    FFont.Style := FFont.Style + [fsUnderline];
  if TCustomIniFile(IniFile).ReadBool(Section, 'Font.StrikeOut', False) then
    FFont.Style := FFont.Style + [fsStrikeOut];
end;

procedure TFontConfigItem.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  if not (IniFile is TCustomIniFile) then Exit;
  
  // 浣跨敤鐜版湁鐨凾IniFile鏂规硶淇濆瓨瀛椾綋淇℃伅
  TCustomIniFile(IniFile).WriteString(Section, 'Font.Name', FFont.Name);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Font.Size', FFont.Size);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Font.Color', FFont.Color);
  
  TCustomIniFile(IniFile).WriteBool(Section, 'Font.Bold', fsBold in FFont.Style);
  TCustomIniFile(IniFile).WriteBool(Section, 'Font.Italic', fsItalic in FFont.Style);
  TCustomIniFile(IniFile).WriteBool(Section, 'Font.Underline', fsUnderline in FFont.Style);
  TCustomIniFile(IniFile).WriteBool(Section, 'Font.StrikeOut', fsStrikeOut in FFont.Style);
end;

{ TConfigItemFactory }

class function TConfigItemFactory.CreateConfigItem(const ItemType: string): IConfigItem;
begin
  if ItemType = 'Text' then
    Result := TTextConfigItem.Create
  else if ItemType = 'Directory' then
    Result := TDirConfigItem.Create
  else if ItemType = 'File' then
    Result := TFileConfigItem.Create
  else if ItemType = 'Input' then
    Result := TInputConfigItem.Create
  else if ItemType = 'Image' then
    Result := TImageConfigItem.Create
  else if ItemType = 'ImageDrawer' then
    Result := TImageDrawerConfigItem.Create
  else if ItemType = 'Combo' then
    Result := TComboConfigItem.Create
  else
    Result := TBaseConfigItem.Create;
end;

end. 
