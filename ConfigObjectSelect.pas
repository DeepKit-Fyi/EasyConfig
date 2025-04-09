unit ConfigObjectSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList, ConfigTypes, ConfigRegistry;

type
  TfrmConfigObjectSelect = class(TForm)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lvObjectTypes: TListView;
    edtName: TLabeledEdit;
    mmoDescription: TMemo;
    lblDescription: TLabel;
    ilIcons: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure lvObjectTypesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edtNameChange(Sender: TObject);
    procedure lvObjectTypesDblClick(Sender: TObject);
  private
    FRegistry: TConfigObjectRegistry;
    FSelectedType: string;
    FObjectName: string;
    
    procedure LoadObjectTypes;
    procedure UpdateControls;
  public
    // 鍒濆鍖?
    procedure Initialize(ARegistry: TConfigObjectRegistry);
    
    // 鑾峰彇閫夋嫨鐨勭被鍨?
    property SelectedType: string read FSelectedType;
    property ObjectName: string read FObjectName;
  end;

var
  frmConfigObjectSelect: TfrmConfigObjectSelect;

implementation

{$R *.dfm}

procedure TfrmConfigObjectSelect.FormCreate(Sender: TObject);
begin
  FSelectedType := '';
  FObjectName := '';
  UpdateControls;
end;

procedure TfrmConfigObjectSelect.Initialize(ARegistry: TConfigObjectRegistry);
begin
  FRegistry := ARegistry;
  LoadObjectTypes;
end;

procedure TfrmConfigObjectSelect.LoadObjectTypes;
var
  TypeId: string;
  Meta: TConfigObjectMeta;
  Item: TListItem;
  Types: TArray<string>;
  ImageIndex: Integer;
begin
  // 娓呯┖鍒楄〃
  lvObjectTypes.Items.Clear;
  
  if not Assigned(FRegistry) then
    Exit;
    
  // 鑾峰彇鎵€鏈夋敞鍐岀殑绫诲瀷
  Types := FRegistry.GetAllConfigTypes;
  
  // 娣诲姞鍒板垪琛ㄤ腑
  for TypeId in Types do
  begin
    Meta := FRegistry.GetConfigMeta(TypeId);
    if not Assigned(Meta) then
      Continue;
    
    // 鏍规嵁閰嶇疆绫诲瀷閫夋嫨涓嶅悓鐨勫浘鏍?
    case Meta.ConfigType of
      etFont: ImageIndex := 0;
      etDatabase: ImageIndex := 1;
      etBackGround: ImageIndex := 2;
      etImage, etImageOnBG: ImageIndex := 3;
      etTextOnBG: ImageIndex := 4;
      etDrawerOnBG: ImageIndex := 5;
      etSubtitle: ImageIndex := 6;
      etPage: ImageIndex := 7;
      etVideoClip: ImageIndex := 8;
      etAIAPI: ImageIndex := 9;
      else ImageIndex := 10;
    end;
    
    // 鍒涘缓鍒楄〃椤?
    Item := lvObjectTypes.Items.Add;
    Item.Caption := Meta.Name;
    Item.SubItems.Add(Meta.Description);
    Item.Data := Pointer(TypeId);
    Item.ImageIndex := ImageIndex;
  end;
end;

procedure TfrmConfigObjectSelect.lvObjectTypesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  TypeId: string;
  Meta: TConfigObjectMeta;
begin
  if Selected and Assigned(Item) then
  begin
    // 鑾峰彇閫夋嫨鐨勭被鍨?
    TypeId := string(Item.Data);
    FSelectedType := TypeId;
    
    // 鏄剧ず绫诲瀷鎻忚堪
    if Assigned(FRegistry) then
    begin
      Meta := FRegistry.GetConfigMeta(TypeId);
      if Assigned(Meta) then
        mmoDescription.Lines.Text := Meta.Description
      else
        mmoDescription.Lines.Text := '娌℃湁鍙敤鐨勬弿杩?;
    end;
  end
  else
  begin
    FSelectedType := '';
    mmoDescription.Lines.Text := '';
  end;
  
  UpdateControls;
end;

procedure TfrmConfigObjectSelect.lvObjectTypesDblClick(Sender: TObject);
begin
  if (FSelectedType <> '') and (edtName.Text <> '') then
    ModalResult := mrOk;
end;

procedure TfrmConfigObjectSelect.edtNameChange(Sender: TObject);
begin
  FObjectName := edtName.Text;
  UpdateControls;
end;

procedure TfrmConfigObjectSelect.UpdateControls;
begin
  btnOK.Enabled := (FSelectedType <> '') and (FObjectName <> '');
end;

end. 