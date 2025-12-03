unit ConfigManagerUnit;

interface

uses
  System.Classes, System.SysUtils, Vcl.ComCtrls, Vcl.Graphics,
  System.Generics.Collections, ConfigItemsUnit, ReusableObjectsUnit, System.IniFiles;

type
  IConfigManager = interface
    ['{12345678-1234-1234-1234-123456789ABC}']
    // 閰嶇疆椤圭鐞?    function AddItem(Item: IConfigItem): Integer;
    procedure RemoveItem(Item: IConfigItem);
    procedure ClearItems;
    function GetItemCount: Integer;
    function GetItem(Index: Integer): IConfigItem;
    
    // 鍙鐢ㄥ璞＄鐞?    function AddReusableObject(Obj: IReusableObject): Integer;
    procedure RemoveReusableObject(Obj: IReusableObject);
    procedure ClearReusableObjects;
    function GetReusableObjectCount: Integer;
    function GetReusableObject(Index: Integer): IReusableObject;
    
    // 鏂囦欢鎿嶄綔
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const FileName: string);
    procedure Clear;
    
    // TreeView 鎿嶄綔
    procedure PopulateTreeView(TreeView: TTreeView);
    
    function GetIniFileName: string;
    procedure SetIniFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    
    property IniFileName: string read GetIniFileName write SetIniFileName;
    property Modified: Boolean read GetModified write SetModified;
  end;

  TConfigManager = class(TInterfacedObject, IConfigManager)
  private
    FItems: TInterfaceList;
    FReusableObjects: TInterfaceList;
    FIniFileName: string;
    FModified: Boolean;
    FOnTreeChange: TNotifyEvent;

    // 杈呭姪鍑芥暟锛屼粠鑺傚悕涓彁鍙栧瓙瀛楃涓诧紝濡備粠'Text/mytext'涓彁鍙?mytext'
    function ExtractSubstr(const S: string; const Delimiter: string): string;
    
    // IConfigManager鎺ュ彛灞炴€ф柟娉曞疄鐜?    function GetIniFileName: string;
    procedure SetIniFileName(const Value: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    
    // 閰嶇疆椤圭鐞?    function AddItem(Item: IConfigItem): Integer;
    procedure RemoveItem(Item: IConfigItem);
    procedure ClearItems;
    function GetItemCount: Integer;
    function GetItem(Index: Integer): IConfigItem;
    
    // 鍙鐢ㄥ璞＄鐞?    function AddReusableObject(Obj: IReusableObject): Integer;
    procedure RemoveReusableObject(Obj: IReusableObject);
    procedure ClearReusableObjects;
    function GetReusableObjectCount: Integer;
    function GetReusableObject(Index: Integer): IReusableObject;
    
    // 鏂囦欢鎿嶄綔
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const FileName: string);
    procedure Clear;
    
    // TreeView 鎿嶄綔
    procedure PopulateTreeView(TreeView: TTreeView);
    
    property IniFileName: string read FIniFileName write FIniFileName;
    property Modified: Boolean read FModified write FModified;
  end;

implementation

uses
  MainFormUnit;

{ TConfigManager }

constructor TConfigManager.Create;
begin
  inherited Create;
  FItems := TInterfaceList.Create;
  FReusableObjects := TInterfaceList.Create;
  FModified := False;
end;

destructor TConfigManager.Destroy;
begin
  FItems.Free;
  FReusableObjects.Free;
  inherited;
end;

function TConfigManager.AddItem(Item: IConfigItem): Integer;
begin
  Result := FItems.Add(Item);
  FModified := True;
end;

procedure TConfigManager.RemoveItem(Item: IConfigItem);
begin
  FItems.Remove(Item);
  FModified := True;
end;

procedure TConfigManager.ClearItems;
begin
  FItems.Clear;
  FModified := True;
end;

function TConfigManager.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TConfigManager.GetItem(Index: Integer): IConfigItem;
begin
  Result := FItems[Index] as IConfigItem;
end;

function TConfigManager.AddReusableObject(Obj: IReusableObject): Integer;
begin
  Result := FReusableObjects.Add(Obj);
  FModified := True;
end;

procedure TConfigManager.RemoveReusableObject(Obj: IReusableObject);
begin
  FReusableObjects.Remove(Obj);
  FModified := True;
end;

procedure TConfigManager.ClearReusableObjects;
begin
  FReusableObjects.Clear;
  FModified := True;
end;

function TConfigManager.GetReusableObjectCount: Integer;
begin
  Result := FReusableObjects.Count;
end;

function TConfigManager.GetReusableObject(Index: Integer): IReusableObject;
begin
  Result := FReusableObjects[Index] as IReusableObject;
end;

procedure TConfigManager.LoadFromFile(const AFileName: string);
var
  IniFile: TMemIniFile;
  Sections, Keys, TempList: TStringList;
  Section, ItemType: string;
  I, J, TextIndex, ImageIndex, DirIndex, FileIndex, InputIndex, DrawerIndex: Integer;
  Item: IConfigItem;
  TextItems, ImageItems, DirItems, FileItems, InputItems, DrawerItems: TInterfaceList;
  Position: TPosition;
begin
  ClearItems;
  
  if not FileExists(AFileName) then 
  begin
    Exit;
  end;
  
  // 浣跨敤UTF-8缂栫爜鐩存帴鍔犺浇INI鏂囦欢
  TempList := TStringList.Create;
  try
    // 灏濊瘯浠TF-8鏂瑰紡鍔犺浇鏂囦欢
    try
      TempList.LoadFromFile(AFileName, TEncoding.UTF8);
    except
      // 濡傛灉澶辫触锛屽皾璇曚娇鐢ㄩ粯璁ょ紪鐮?      TempList.LoadFromFile(AFileName);
    end;
    
    // 鍒涘缓鍐呭瓨INI鏂囦欢骞惰缃唴瀹?    IniFile := TMemIniFile.Create('');
    try
      IniFile.SetStrings(TempList);
      
      Sections := TStringList.Create;
      TextItems := TInterfaceList.Create;
      ImageItems := TInterfaceList.Create;
      DirItems := TInterfaceList.Create;
      FileItems := TInterfaceList.Create;
      InputItems := TInterfaceList.Create;
      DrawerItems := TInterfaceList.Create;
      try
        IniFile.ReadSections(Sections);
        
        TextIndex := 0;
        ImageIndex := 0;
        DirIndex := 0;
        FileIndex := 0;
        InputIndex := 0;
        DrawerIndex := 0;
        
        // 棣栧厛澶勭悊鎵€鏈夊熀鏈厤缃」
        for I := 0 to Sections.Count - 1 do
        begin
          Section := Sections[I];
          
          // 鍏堝皾璇曚娇鐢ㄦ柊鏍煎紡锛堝甫ItemType瀛楁锛夎В鏋?          Keys := TStringList.Create;
          try
            IniFile.ReadSection(Section, Keys);
            
            // 鍚屾椂鏀寔涓枃閿悕鍜岃嫳鏂囬敭鍚?            if (Keys.IndexOf('ItemType') >= 0) or (Keys.IndexOf('绫诲瀷') >= 0) then
            begin
              // 灏濊瘯浠庝腑鏂囬敭鍚嶈鍙栵紝濡傛灉娌℃湁鍒欎粠鑻辨枃閿悕璇诲彇
              ItemType := IniFile.ReadString(Section, '绫诲瀷', IniFile.ReadString(Section, 'ItemType', ''));
              
              // 鏍规嵁ItemType鍒涘缓鐩稿簲绫诲瀷鐨勯厤缃」
              if (ItemType = 'Text') or (ItemType = '鏂囨湰') then
                Item := TTextConfigItem.Create
              else if (ItemType = 'Image') or (ItemType = '鍥惧儚') then
                Item := TImageConfigItem.Create
              else if (ItemType = 'Directory') or (ItemType = '鐩綍') then
                Item := TDirConfigItem.Create
              else if (ItemType = 'File') or (ItemType = '鏂囦欢') then
                Item := TFileConfigItem.Create
              else if (ItemType = 'Input') or (ItemType = '杈撳叆') then
                Item := TInputConfigItem.Create
              else if (ItemType = 'ImageDrawer') or (ItemType = '缁樺埗鍣?) then
                Item := TImageDrawerConfigItem.Create
              else
                Continue; // 鏈煡绫诲瀷锛岃烦杩?              
              // 浠嶪NI鏂囦欢鍔犺浇閰嶇疆椤癸紝鍚屾椂鏀寔涓枃閿悕鍜岃嫳鏂囬敭鍚?              Item.DisplayName := IniFile.ReadString(Section, '鏄剧ず鍚嶇О', IniFile.ReadString(Section, 'DisplayName', ''));
              Item.Name := IniFile.ReadString(Section, '鍚嶇О', IniFile.ReadString(Section, 'Name', ''));
              
              // 濡傛灉Name灞炴€т负绌猴紝鏍规嵁涓嶅悓绫诲瀷鑷姩鐢熸垚鑻辨枃鍚嶇О
              if Item.Name = '' then
              begin
                if Item is TTextConfigItem then
                  Item.Name := 'text_' + IntToStr(TextIndex)
                else if Item is TImageConfigItem then
                  Item.Name := 'image_' + IntToStr(ImageIndex)
                else if Item is TDirConfigItem then
                  Item.Name := 'dir_' + IntToStr(DirIndex)
                else if Item is TFileConfigItem then
                  Item.Name := 'file_' + IntToStr(FileIndex)
                else if Item is TInputConfigItem then
                  Item.Name := 'input_' + IntToStr(InputIndex)
                else if Item is TImageDrawerConfigItem then
                  Item.Name := 'drawer_' + IntToStr(DrawerIndex);
              end;
              
              Item.Description := IniFile.ReadString(Section, '鎻忚堪', IniFile.ReadString(Section, 'Description', ''));
              Item.ZOrder := IniFile.ReadInteger(Section, 'Z椤哄簭', IniFile.ReadInteger(Section, 'ZOrder', 0));
              Item.Visible := IniFile.ReadBool(Section, '鍙', IniFile.ReadBool(Section, 'Visible', True));
              
              // 璇诲彇浣嶇疆淇℃伅
              Position.X := IniFile.ReadInteger(Section, 'X', 0);
              Position.Y := IniFile.ReadInteger(Section, 'Y', 0);
              Position.IsCenterX := IniFile.ReadBool(Section, 'IsCenterX', False);
              Position.IsCenterY := IniFile.ReadBool(Section, 'IsCenterY', False);
              Item.Position := Position;
              
              // 鏍规嵁涓嶅悓绫诲瀷璇诲彇鐗瑰畾灞炴€?              if Item is TTextConfigItem then
              begin
                TTextConfigItem(Item).Value := IniFile.ReadString(Section, '鏂囨湰鍐呭', IniFile.ReadString(Section, 'Value', ''));
                TTextConfigItem(Item).FontRef := IniFile.ReadString(Section, '瀛椾綋寮曠敤', IniFile.ReadString(Section, 'FontRef', ''));
                TTextConfigItem(Item).FontEffectRef := IniFile.ReadString(Section, '瀛椾綋鐗规晥寮曠敤', IniFile.ReadString(Section, 'FontEffectRef', ''));
              end
              else if Item is TImageConfigItem then
              begin
                TImageConfigItem(Item).FileName := IniFile.ReadString(Section, '鏂囦欢鍚?, IniFile.ReadString(Section, 'FileName', ''));
                TImageConfigItem(Item).Transparent := IniFile.ReadBool(Section, '閫忔槑', IniFile.ReadBool(Section, 'Transparent', False));
                TImageConfigItem(Item).TransparentColor := IniFile.ReadInteger(Section, '閫忔槑棰滆壊', IniFile.ReadInteger(Section, 'TransparentColor', clWhite));
              end
              else if Item is TDirConfigItem then
              begin
                TDirConfigItem(Item).Path := IniFile.ReadString(Section, '璺緞', IniFile.ReadString(Section, 'Path', ''));
              end
              else if Item is TFileConfigItem then
              begin
                TFileConfigItem(Item).Path := IniFile.ReadString(Section, '璺緞', IniFile.ReadString(Section, 'Path', ''));
                TFileConfigItem(Item).FileType := IniFile.ReadString(Section, '鏂囦欢绫诲瀷', IniFile.ReadString(Section, 'FileType', ''));
              end
              else if Item is TInputConfigItem then
              begin
                TInputConfigItem(Item).Text := IniFile.ReadString(Section, '鏂囨湰', IniFile.ReadString(Section, 'Text', ''));
                TInputConfigItem(Item).FontRef := IniFile.ReadString(Section, '瀛椾綋寮曠敤', IniFile.ReadString(Section, 'FontRef', ''));
              end
              else if Item is TImageDrawerConfigItem then
              begin
                TImageDrawerConfigItem(Item).DrawerType := IniFile.ReadString(Section, '缁樺埗鍣ㄧ被鍨?, IniFile.ReadString(Section, 'DrawerType', ''));
                TImageDrawerConfigItem(Item).Opacity := IniFile.ReadInteger(Section, '涓嶉€忔槑搴?, IniFile.ReadInteger(Section, 'Opacity', 255));
                TImageDrawerConfigItem(Item).BlendMode := IniFile.ReadString(Section, '娣峰悎妯″紡', IniFile.ReadString(Section, 'BlendMode', 'Normal'));
              end;
              
              // 娣诲姞鍒伴厤缃」鍒楄〃
              AddItem(Item);
              Continue; // 宸插鐞嗭紝缁х画涓嬩竴涓妭
            end;
          finally
            Keys.Free;
          end;
          
          // 濡傛灉娌℃湁浣跨敤鏂版牸寮忥紝灏濊瘯浣跨敤鏃ф牸寮忚В鏋?          // 澶勭悊鏂囨湰閰嶇疆椤?          if (Pos('Text/', Section) = 1) and (Pos('/Pos', Section) = 0) and (Pos('/Font', Section) = 0) then
          begin
            Item := TTextConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'Text Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 璁剧疆鑻辨枃鍚嶇О
            Item.Name := ExtractSubstr(Section, '/');
            if Item.Name = '' then
              Item.Name := 'text_' + IntToStr(TextIndex);
            
            // 鏂囨湰鐗规湁灞炴€?            TTextConfigItem(Item).Value := IniFile.ReadString(Section, 'Value', '');
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            TextItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(TextIndex);
          end
          // 澶勭悊鍥惧儚閰嶇疆椤?          else if (Pos('Image/', Section) = 1) and (Pos('/Pos', Section) = 0) and (Pos('/Scale', Section) = 0) then
          begin
            Item := TImageConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'Image Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 璁剧疆鑻辨枃鍚嶇О
            Item.Name := ExtractSubstr(Section, '/');
            if Item.Name = '' then
              Item.Name := 'image_' + IntToStr(ImageIndex);
            
            // 鍥惧儚鐗规湁灞炴€?            TImageConfigItem(Item).FileName := IniFile.ReadString(Section, 'FileName', '');
            TImageConfigItem(Item).Transparent := IniFile.ReadBool(Section, 'Transparent', False);
            TImageConfigItem(Item).TransparentColor := IniFile.ReadInteger(Section, 'TransparentColor', clWhite);
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            ImageItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(ImageIndex);
          end
          // 澶勭悊鐩綍閰嶇疆椤?          else if (Pos('Dir/', Section) = 1) and (Pos('/Pos', Section) = 0) then
          begin
            Item := TDirConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'Directory Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 璁剧疆鑻辨枃鍚嶇О
            Item.Name := ExtractSubstr(Section, '/');
            if Item.Name = '' then
              Item.Name := 'dir_' + IntToStr(DirIndex);
            
            // 鐩綍鐗规湁灞炴€?            TDirConfigItem(Item).Path := IniFile.ReadString(Section, 'Path', '');
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            DirItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(DirIndex);
          end
          // 澶勭悊鏂囦欢閰嶇疆椤?          else if (Pos('File/', Section) = 1) and (Pos('/Pos', Section) = 0) then
          begin
            Item := TFileConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'File Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 璁剧疆鑻辨枃鍚嶇О
            Item.Name := ExtractSubstr(Section, '/');
            if Item.Name = '' then
              Item.Name := 'file_' + IntToStr(FileIndex);
            
            // 鏂囦欢鐗规湁灞炴€?            TFileConfigItem(Item).Path := IniFile.ReadString(Section, 'Path', '');
            TFileConfigItem(Item).FileType := IniFile.ReadString(Section, 'FileType', '');
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            FileItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(FileIndex);
          end
          // 澶勭悊杈撳叆閰嶇疆椤?          else if (Pos('Input/', Section) = 1) and (Pos('/Pos', Section) = 0) then
          begin
            Item := TInputConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'Input Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 杈撳叆鐗规湁灞炴€?            TInputConfigItem(Item).Text := IniFile.ReadString(Section, 'Text', '');
            TInputConfigItem(Item).FontRef := IniFile.ReadString(Section, 'FontRef', '');
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            InputItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(InputIndex);
          end
          // 澶勭悊缁樺埗鍣ㄩ厤缃」
          else if (Pos('ImageDrawer/', Section) = 1) and (Pos('/Pos', Section) = 0) and 
                  (Pos('/DrawSettings', Section) = 0) then
          begin
            Item := TImageDrawerConfigItem.Create;
            Item.DisplayName := IniFile.ReadString(Section, 'DisplayName', 'Drawer Item');
            Item.Description := IniFile.ReadString(Section, 'Description', '');
            Item.ZOrder := IniFile.ReadInteger(Section, 'ZOrder', 0);
            Item.Visible := IniFile.ReadBool(Section, 'Visible', True);
            
            // 缁樺埗鍣ㄧ壒鏈夊睘鎬?            TImageDrawerConfigItem(Item).DrawerType := IniFile.ReadString(Section, 'DrawerType', '');
            TImageDrawerConfigItem(Item).Opacity := IniFile.ReadInteger(Section, 'Opacity', 255);
            TImageDrawerConfigItem(Item).BlendMode := IniFile.ReadString(Section, 'BlendMode', 'Normal');
            
            // 瀛樺偍椤圭洰浠ヤ緵鍚庣画澶勭悊
            DrawerItems.Add(Item);
            // 娣诲姞鍒伴厤缃鐞嗗櫒
            AddItem(Item);
            Inc(DrawerIndex);
          end;
        end;

        // 鐒跺悗澶勭悊浣嶇疆鍜屽叾浠栨墿灞曞睘鎬?        for I := 0 to Sections.Count - 1 do
        begin
          Section := Sections[I];
          
          // 澶勭悊浣嶇疆淇℃伅
          if Pos('/Pos', Section) > 0 then
          begin
            Position.X := IniFile.ReadInteger(Section, 'X', 0);
            Position.Y := IniFile.ReadInteger(Section, 'Y', 0);
            Position.IsCenterX := IniFile.ReadBool(Section, 'IsCenterX', False) or
                                   IniFile.ReadBool(Section, 'IsCenterY', False);
            
            // 涓虹浉搴旂殑閰嶇疆椤规洿鏂颁綅缃?            if Pos('Text/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 6, Pos('/Pos', Section) - 6), -1);
              if (J >= 0) and (J < TextItems.Count) then
              begin
                Item := TextItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end
            else if Pos('Image/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 7, Pos('/Pos', Section) - 7), -1);
              if (J >= 0) and (J < ImageItems.Count) then
              begin
                Item := ImageItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end
            else if Pos('Dir/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 5, Pos('/Pos', Section) - 5), -1);
              if (J >= 0) and (J < DirItems.Count) then
              begin
                Item := DirItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end
            else if Pos('File/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 6, Pos('/Pos', Section) - 6), -1);
              if (J >= 0) and (J < FileItems.Count) then
              begin
                Item := FileItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end
            else if Pos('Input/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 7, Pos('/Pos', Section) - 7), -1);
              if (J >= 0) and (J < InputItems.Count) then
              begin
                Item := InputItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end
            else if Pos('ImageDrawer/', Section) = 1 then
            begin
              J := StrToIntDef(Copy(Section, 13, Pos('/Pos', Section) - 13), -1);
              if (J >= 0) and (J < DrawerItems.Count) then
              begin
                Item := DrawerItems[J] as IConfigItem;
                Item.Position := Position;
              end;
            end;
          end;
        end;
      finally
        Sections.Free;
        TextItems.Free;
        ImageItems.Free;
        DirItems.Free;
        FileItems.Free;
        InputItems.Free;
        DrawerItems.Free;
      end;
    finally
      IniFile.Free;
    end;
  finally
    TempList.Free;
  end;
  
  FIniFileName := AFileName;
  FModified := False;
end;

procedure TConfigManager.SaveToFile(const FileName: string);
var
  I: Integer;
  Item: IConfigItem;
  Obj: IReusableObject;
  IniFile: TMemIniFile;
  TempList: TStringList;
  SectionName: string;
begin
  // 鍒涘缓鍐呭瓨INI鏂囦欢
  IniFile := TMemIniFile.Create('');
  try
    // 淇濆瓨閰嶇疆椤?    IniFile.WriteInteger('Config', 'ItemCount', GetItemCount);
    for I := 0 to GetItemCount - 1 do
    begin
      Item := GetItem(I);
      SectionName := 'Config\Items\' + IntToStr(I);
      
      // 浣跨敤鑻辨枃閿悕淇濆瓨鎵€鏈夐厤缃?      IniFile.WriteString(SectionName, 'Type', Item.ItemType);
      IniFile.WriteString(SectionName, 'DisplayName', Item.DisplayName);
      IniFile.WriteString(SectionName, 'Name', Item.Name);
      IniFile.WriteString(SectionName, 'Description', Item.Description);
      IniFile.WriteInteger(SectionName, 'ZOrder', Item.ZOrder);
      IniFile.WriteBool(SectionName, 'Visible', Item.Visible);
      
      // 淇濆瓨浣嶇疆淇℃伅
      IniFile.WriteInteger(SectionName, 'Position.X', Item.Position.X);
      IniFile.WriteInteger(SectionName, 'Position.Y', Item.Position.Y);
      IniFile.WriteBool(SectionName, 'Position.IsCenterX', Item.Position.IsCenterX);
      IniFile.WriteBool(SectionName, 'Position.IsCenterY', Item.Position.IsCenterY);
      
      // 鏍规嵁涓嶅悓鐨勭被鍨嬩繚瀛樼壒瀹氬睘鎬?      if Item is TTextConfigItem then
      begin
        IniFile.WriteString(SectionName, 'Value', TTextConfigItem(Item).Value);
        IniFile.WriteString(SectionName, 'FontRef', TTextConfigItem(Item).FontRef);
        IniFile.WriteString(SectionName, 'FontEffectRef', TTextConfigItem(Item).FontEffectRef);
      end
      else if Item is TImageConfigItem then
      begin
        IniFile.WriteString(SectionName, 'FileName', TImageConfigItem(Item).FileName);
        IniFile.WriteBool(SectionName, 'Transparent', TImageConfigItem(Item).Transparent);
        IniFile.WriteInteger(SectionName, 'TransparentColor', TImageConfigItem(Item).TransparentColor);
        IniFile.WriteInteger(SectionName, 'Scale.Width', TImageConfigItem(Item).Scale.Width);
        IniFile.WriteInteger(SectionName, 'Scale.Height', TImageConfigItem(Item).Scale.Height);
        IniFile.WriteBool(SectionName, 'Scale.KeepAspectRatio', TImageConfigItem(Item).Scale.KeepAspectRatio);
      end
      else if Item is TDirConfigItem then
      begin
        IniFile.WriteString(SectionName, 'Path', TDirConfigItem(Item).Path);
      end
      else if Item is TFileConfigItem then
      begin
        IniFile.WriteString(SectionName, 'Path', TFileConfigItem(Item).Path);
        IniFile.WriteString(SectionName, 'FileType', TFileConfigItem(Item).FileType);
      end
      else if Item is TInputConfigItem then
      begin
        IniFile.WriteString(SectionName, 'Text', TInputConfigItem(Item).Text);
        IniFile.WriteString(SectionName, 'FontRef', TInputConfigItem(Item).FontRef);
      end
      else if Item is TImageDrawerConfigItem then
      begin
        IniFile.WriteString(SectionName, 'DrawerType', TImageDrawerConfigItem(Item).DrawerType);
        IniFile.WriteInteger(SectionName, 'Opacity', TImageDrawerConfigItem(Item).Opacity);
        IniFile.WriteString(SectionName, 'BlendMode', TImageDrawerConfigItem(Item).BlendMode);
      end;
    end;
    
    // 淇濆瓨鍙鐢ㄥ璞?    IniFile.WriteInteger('Config', 'ObjectCount', GetReusableObjectCount);
    for I := 0 to GetReusableObjectCount - 1 do
    begin
      Obj := GetReusableObject(I);
      SectionName := 'Config\Objects\' + IntToStr(I);
      IniFile.WriteString(SectionName, 'Type', Obj.ObjectType);
      // 浣跨敤鑻辨枃閿悕淇濆瓨瀵硅薄灞炴€?      IniFile.WriteString(SectionName, 'Name', Obj.Name);
      IniFile.WriteString(SectionName, 'Description', Obj.Description);
    end;
    
    // 鑾峰彇INI鍐呭骞朵互UTF-8缂栫爜淇濆瓨
    TempList := TStringList.Create;
    try
      // 浣跨敤SaveToFile鐨勭紪鐮佸弬鏁帮紝鑰屼笉鏄缃瓻ncoding灞炴€?      IniFile.GetStrings(TempList);
      
      // 鍐欏叆甯OM鐨刄TF-8鏂囦欢
      TempList.SaveToFile(FileName, TEncoding.UTF8);
    finally
      TempList.Free;
    end;
  finally
    IniFile.Free;
  end;
  
  FIniFileName := FileName;
  FModified := False;
end;

procedure TConfigManager.Clear;
begin
  ClearItems;
  ClearReusableObjects;
  FIniFileName := '';
  FModified := False;
end;

procedure TConfigManager.PopulateTreeView(TreeView: TTreeView);
var
  I: Integer;
  Item: IConfigItem;
begin
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    for I := 0 to GetItemCount - 1 do
    begin
      Item := GetItem(I);
      if Item.Parent = nil then
        Item.CreateTreeNode(TreeView, nil);
    end;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

// 浠庡瓧绗︿覆涓彁鍙栧瓙瀛楃涓诧紙濡?'Text/mytext' 鎻愬彇 'mytext'锛?function TConfigManager.ExtractSubstr(const S: string; const Delimiter: string): string;
var
  DelimPos: Integer;
begin
  Result := '';
  DelimPos := Pos(Delimiter, S);
  if DelimPos > 0 then
    Result := Copy(S, DelimPos + Length(Delimiter), Length(S) - DelimPos - Length(Delimiter) + 1);
end;

function TConfigManager.GetIniFileName: string;
begin
  Result := FIniFileName;
end;

procedure TConfigManager.SetIniFileName(const Value: string);
begin
  FIniFileName := Value;
end;

function TConfigManager.GetModified: Boolean;
begin
  Result := FModified;
end;

procedure TConfigManager.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

end. 