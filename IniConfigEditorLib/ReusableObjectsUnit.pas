unit ReusableObjectsUnit;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls,
  System.IniFiles;

const
  // 字体样式位常量
  FS_BOLD      = 1;
  FS_ITALIC    = 2;
  FS_UNDERLINE = 4;
  FS_STRIKEOUT = 8;

type
  // 可复用对象接口
  IReusableObject = interface
    ['{A1B2C3D4-E5F6-4A5B-8C7D-9E0F1A2B3C4D}']
    function GetName: string;
    procedure SetName(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetObjectType: string;
    
    // 属性
    property Name: string read GetName write SetName;
    property Description: string read GetDescription write SetDescription;
    property ObjectType: string read GetObjectType;
    
    // 方法
    procedure SaveToIni(const Section: string; IniFile: TObject);
    procedure LoadFromIni(const Section: string; IniFile: TObject);
    function Clone: IReusableObject;
    procedure AssignTo(Dest: IReusableObject);
    function CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode;
  end;

  // 基本可复用对象类
  TBaseReusableObject = class(TInterfacedObject, IReusableObject)
  private
    FName: string;
    FDescription: string;
  protected
    function GetName: string;
    procedure SetName(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetObjectType: string; virtual;
  public
    constructor Create;
    
    // IReusableObject 接口实现
    procedure SaveToIni(const Section: string; IniFile: TObject); virtual;
    procedure LoadFromIni(const Section: string; IniFile: TObject); virtual;
    function Clone: IReusableObject; virtual;
    procedure AssignTo(Dest: IReusableObject); virtual;
    function CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode; virtual;
  end;

  // 字体可复用对象
  TFontReusableObject = class(TBaseReusableObject)
  private
    FName: string;
    FSize: Integer;
    FColor: TColor;
    FStyle: TFontStyles;
  protected
    function GetObjectType: string; override;
  public
    constructor Create;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IReusableObject; override;
    procedure AssignTo(Dest: IReusableObject); override;
    procedure ApplyToFont(Font: TFont);
    
    property FontName: string read FName write FName;
    property Size: Integer read FSize write FSize;
    property Color: TColor read FColor write FColor;
    property Style: TFontStyles read FStyle write FStyle;
  end;

  // 字体特效可复用对象
  TFontEffectReusableObject = class(TBaseReusableObject)
  private
    FBold: Boolean;
    FItalic: Boolean;
    FUnderline: Boolean;
    FStrikeOut: Boolean;
    FShadow: Boolean;
    FShadowColor: TColor;
    FShadowOffsetX: Integer;
    FShadowOffsetY: Integer;
    FOutline: Boolean;
    FOutlineColor: TColor;
    FOutlineWidth: Integer;
  protected
    function GetObjectType: string; override;
  public
    constructor Create;
    procedure SaveToIni(const Section: string; IniFile: TObject); override;
    procedure LoadFromIni(const Section: string; IniFile: TObject); override;
    function Clone: IReusableObject; override;
    procedure AssignTo(Dest: IReusableObject); override;
    
    property Bold: Boolean read FBold write FBold;
    property Italic: Boolean read FItalic write FItalic;
    property Underline: Boolean read FUnderline write FUnderline;
    property StrikeOut: Boolean read FStrikeOut write FStrikeOut;
    property Shadow: Boolean read FShadow write FShadow;
    property ShadowColor: TColor read FShadowColor write FShadowColor;
    property ShadowOffsetX: Integer read FShadowOffsetX write FShadowOffsetX;
    property ShadowOffsetY: Integer read FShadowOffsetY write FShadowOffsetY;
    property Outline: Boolean read FOutline write FOutline;
    property OutlineColor: TColor read FOutlineColor write FOutlineColor;
    property OutlineWidth: Integer read FOutlineWidth write FOutlineWidth;
  end;

  // 可复用对象工厂
  TReusableObjectFactory = class
  public
    class function CreateReusableObject(const ObjectType: string): IReusableObject;
  end;

implementation

uses
  System.TypInfo, MainFormUnit;

{ TBaseReusableObject }

procedure TBaseReusableObject.AssignTo(Dest: IReusableObject);
begin
  if Dest = nil then Exit;
  
  Dest.Name := FName;
  Dest.Description := FDescription;
end;

function TBaseReusableObject.Clone: IReusableObject;
begin
  Result := TReusableObjectFactory.CreateReusableObject(GetObjectType);
  AssignTo(Result);
end;

constructor TBaseReusableObject.Create;
begin
  inherited Create;
end;

function TBaseReusableObject.CreateTreeNode(TreeView: TTreeView; ParentNode: TTreeNode): TTreeNode;
begin
  if ParentNode = nil then
    Result := TreeView.Items.Add(nil, FName)
  else
    Result := TreeView.Items.AddChild(ParentNode, FName);
    
  Result.Data := Pointer(Self);
end;

function TBaseReusableObject.GetDescription: string;
begin
  Result := FDescription;
end;

function TBaseReusableObject.GetName: string;
begin
  Result := FName;
end;

function TBaseReusableObject.GetObjectType: string;
begin
  Result := 'Base';
end;

procedure TBaseReusableObject.LoadFromIni(const Section: string; IniFile: TObject);
begin
  if not (IniFile is TCustomIniFile) then Exit;
  
  FName := TCustomIniFile(IniFile).ReadString(Section, 'Name', '');
  FDescription := TCustomIniFile(IniFile).ReadString(Section, 'Description', '');
end;

procedure TBaseReusableObject.SaveToIni(const Section: string; IniFile: TObject);
begin
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'Name', FName);
  TCustomIniFile(IniFile).WriteString(Section, 'Description', FDescription);
end;

procedure TBaseReusableObject.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TBaseReusableObject.SetName(const Value: string);
begin
  FName := Value;
end;

{ TFontReusableObject }

procedure TFontReusableObject.ApplyToFont(Font: TFont);
begin
  Font.Name := FName;
  Font.Size := FSize;
  Font.Color := FColor;
  Font.Style := FStyle;
end;

procedure TFontReusableObject.AssignTo(Dest: IReusableObject);
begin
  inherited;
  
  if Dest is TFontReusableObject then
  begin
    TFontReusableObject(Dest).FontName := FName;
    TFontReusableObject(Dest).Size := FSize;
    TFontReusableObject(Dest).Color := FColor;
    TFontReusableObject(Dest).Style := FStyle;
  end;
end;

function TFontReusableObject.Clone: IReusableObject;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

constructor TFontReusableObject.Create;
begin
  inherited;
  FName := 'Arial';
  FSize := 10;
  FColor := clBlack;
  FStyle := [];
end;

function TFontReusableObject.GetObjectType: string;
begin
  Result := 'Font';
end;

procedure TFontReusableObject.LoadFromIni(const Section: string; IniFile: TObject);
var
  StyleInt: Integer;
begin
  inherited;
  
  if not (IniFile is TCustomIniFile) then Exit;
  
  FName := TCustomIniFile(IniFile).ReadString(Section, 'FontName', 'Arial');
  FSize := TCustomIniFile(IniFile).ReadInteger(Section, 'Size', 10);
  FColor := TCustomIniFile(IniFile).ReadInteger(Section, 'Color', clBlack);
  StyleInt := TCustomIniFile(IniFile).ReadInteger(Section, 'Style', 0);
  
  if (StyleInt and FS_BOLD) <> 0 then
    FStyle := FStyle + [fsBold];
  if (StyleInt and FS_ITALIC) <> 0 then
    FStyle := FStyle + [fsItalic];
  if (StyleInt and FS_UNDERLINE) <> 0 then
    FStyle := FStyle + [fsUnderline];
  if (StyleInt and FS_STRIKEOUT) <> 0 then
    FStyle := FStyle + [fsStrikeOut];
end;

procedure TFontReusableObject.SaveToIni(const Section: string; IniFile: TObject);
var
  StyleInt: Integer;
begin
  inherited;
  
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteString(Section, 'FontName', FName);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Size', FSize);
  TCustomIniFile(IniFile).WriteInteger(Section, 'Color', FColor);
  
  StyleInt := 0;
  if fsBold in FStyle then
    StyleInt := StyleInt or FS_BOLD;
  if fsItalic in FStyle then
    StyleInt := StyleInt or FS_ITALIC;
  if fsUnderline in FStyle then
    StyleInt := StyleInt or FS_UNDERLINE;
  if fsStrikeOut in FStyle then
    StyleInt := StyleInt or FS_STRIKEOUT;
    
  TCustomIniFile(IniFile).WriteInteger(Section, 'Style', StyleInt);
end;

{ TFontEffectReusableObject }

procedure TFontEffectReusableObject.AssignTo(Dest: IReusableObject);
begin
  inherited;
  
  if Dest is TFontEffectReusableObject then
  begin
    TFontEffectReusableObject(Dest).Bold := FBold;
    TFontEffectReusableObject(Dest).Italic := FItalic;
    TFontEffectReusableObject(Dest).Underline := FUnderline;
    TFontEffectReusableObject(Dest).StrikeOut := FStrikeOut;
    TFontEffectReusableObject(Dest).Shadow := FShadow;
    TFontEffectReusableObject(Dest).ShadowColor := FShadowColor;
    TFontEffectReusableObject(Dest).ShadowOffsetX := FShadowOffsetX;
    TFontEffectReusableObject(Dest).ShadowOffsetY := FShadowOffsetY;
    TFontEffectReusableObject(Dest).Outline := FOutline;
    TFontEffectReusableObject(Dest).OutlineColor := FOutlineColor;
    TFontEffectReusableObject(Dest).OutlineWidth := FOutlineWidth;
  end;
end;

function TFontEffectReusableObject.Clone: IReusableObject;
begin
  Result := inherited Clone;
  AssignTo(Result);
end;

constructor TFontEffectReusableObject.Create;
begin
  inherited;
  FBold := False;
  FItalic := False;
  FUnderline := False;
  FStrikeOut := False;
  FShadow := False;
  FShadowColor := clGray;
  FShadowOffsetX := 1;
  FShadowOffsetY := 1;
  FOutline := False;
  FOutlineColor := clBlack;
  FOutlineWidth := 1;
end;

function TFontEffectReusableObject.GetObjectType: string;
begin
  Result := 'FontEffect';
end;

procedure TFontEffectReusableObject.LoadFromIni(const Section: string; IniFile: TObject);
begin
  inherited;
  
  if not (IniFile is TCustomIniFile) then Exit;
  
  FBold := TCustomIniFile(IniFile).ReadBool(Section, 'Bold', False);
  FItalic := TCustomIniFile(IniFile).ReadBool(Section, 'Italic', False);
  FUnderline := TCustomIniFile(IniFile).ReadBool(Section, 'Underline', False);
  FStrikeOut := TCustomIniFile(IniFile).ReadBool(Section, 'StrikeOut', False);
  FShadow := TCustomIniFile(IniFile).ReadBool(Section, 'Shadow', False);
  FShadowColor := TCustomIniFile(IniFile).ReadInteger(Section, 'ShadowColor', clGray);
  FShadowOffsetX := TCustomIniFile(IniFile).ReadInteger(Section, 'ShadowOffsetX', 1);
  FShadowOffsetY := TCustomIniFile(IniFile).ReadInteger(Section, 'ShadowOffsetY', 1);
  FOutline := TCustomIniFile(IniFile).ReadBool(Section, 'Outline', False);
  FOutlineColor := TCustomIniFile(IniFile).ReadInteger(Section, 'OutlineColor', clBlack);
  FOutlineWidth := TCustomIniFile(IniFile).ReadInteger(Section, 'OutlineWidth', 1);
end;

procedure TFontEffectReusableObject.SaveToIni(const Section: string; IniFile: TObject);
begin
  inherited;
  
  if not (IniFile is TCustomIniFile) then Exit;
  
  TCustomIniFile(IniFile).WriteBool(Section, 'Bold', FBold);
  TCustomIniFile(IniFile).WriteBool(Section, 'Italic', FItalic);
  TCustomIniFile(IniFile).WriteBool(Section, 'Underline', FUnderline);
  TCustomIniFile(IniFile).WriteBool(Section, 'StrikeOut', FStrikeOut);
  TCustomIniFile(IniFile).WriteBool(Section, 'Shadow', FShadow);
  TCustomIniFile(IniFile).WriteInteger(Section, 'ShadowColor', FShadowColor);
  TCustomIniFile(IniFile).WriteInteger(Section, 'ShadowOffsetX', FShadowOffsetX);
  TCustomIniFile(IniFile).WriteInteger(Section, 'ShadowOffsetY', FShadowOffsetY);
  TCustomIniFile(IniFile).WriteBool(Section, 'Outline', FOutline);
  TCustomIniFile(IniFile).WriteInteger(Section, 'OutlineColor', FOutlineColor);
  TCustomIniFile(IniFile).WriteInteger(Section, 'OutlineWidth', FOutlineWidth);
end;

{ TReusableObjectFactory }

class function TReusableObjectFactory.CreateReusableObject(const ObjectType: string): IReusableObject;
begin
  if ObjectType = 'Font' then
    Result := TFontReusableObject.Create
  else if ObjectType = 'FontEffect' then
    Result := TFontEffectReusableObject.Create
  else
    Result := TBaseReusableObject.Create;
end;

end. 