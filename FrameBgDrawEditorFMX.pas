unit FrameBgDrawEditorFMX;
{*******************************************************************************
  背景绘制配置编辑器 Frame (FMX)
  - 支持背景设置（图片/颜色/渐变）
  - 支持元素列表管理（文字、图片、字幕等）
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.EditBox,
  FMX.SpinBox, FMX.Colors, FMX.Memo, FMX.ScrollBox,
  UtilsTypesFMX, ConfigFrameBaseFMX;

type
  TFrameBgDrawEditorFMX = class(TConfigFrameBaseFMX)
    layMain: TLayout;
    grpBackground: TGroupBox;
    layBgType: TLayout;
    lblBgType: TLabel;
    cboBgType: TComboBox;
    layBgColor: TLayout;
    lblBgColor: TLabel;
    cboBgColor: TColorComboBox;
    layBgImage: TLayout;
    lblBgImage: TLabel;
    edtBgImage: TEdit;
    btnBrowseBg: TButton;
    grpElements: TGroupBox;
    layElementList: TLayout;
    lstElements: TListBox;
    layElementButtons: TLayout;
    btnAddElement: TButton;
    btnEditElement: TButton;
    btnRemoveElement: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    procedure cboBgTypeChange(Sender: TObject);
    procedure btnBrowseBgClick(Sender: TObject);
    procedure btnAddElementClick(Sender: TObject);
    procedure btnEditElementClick(Sender: TObject);
    procedure btnRemoveElementClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure edtChange(Sender: TObject);
  private
    FElements: TJSONArray;
    procedure UpdateBgControls;
    procedure RefreshElementList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromJSON(const AJSON: TJSONObject); override;
    function SaveToJSON: TJSONObject; override;
  end;

implementation

{$R *.fmx}

{ TFrameBgDrawEditorFMX }

constructor TFrameBgDrawEditorFMX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FElements := TJSONArray.Create;

  // 初始化背景类型
  cboBgType.Items.Clear;
  cboBgType.Items.Add('图片');
  cboBgType.Items.Add('纯色');
  cboBgType.Items.Add('渐变');
  cboBgType.ItemIndex := 0;

  UpdateBgControls;
end;

destructor TFrameBgDrawEditorFMX.Destroy;
begin
  FElements.Free;
  inherited Destroy;
end;

procedure TFrameBgDrawEditorFMX.LoadFromJSON(const AJSON: TJSONObject);
var
  BgValue: TJSONValue;
  BgStr: string;
  ElementsArr: TJSONArray;
begin
  if AJSON = nil then Exit;

  BeginUpdate;
  try
    // 背景
    BgValue := AJSON.GetValue('background');
    if BgValue <> nil then
    begin
      BgStr := BgValue.Value;
      if BgStr.StartsWith('#') then
      begin
        // 颜色
        cboBgType.ItemIndex := 1;
        cboBgColor.Color := StringToAlphaColor(BgStr);
      end
      else if BgStr.Contains('gradient') then
      begin
        // 渐变
        cboBgType.ItemIndex := 2;
      end
      else
      begin
        // 图片路径
        cboBgType.ItemIndex := 0;
        edtBgImage.Text := BgStr;
      end;
    end;

    UpdateBgControls;

    // 元素列表
    FElements.Free;
    if AJSON.TryGetValue<TJSONArray>('elements', ElementsArr) then
      FElements := TJSONArray(ElementsArr.Clone)
    else
      FElements := TJSONArray.Create;

    RefreshElementList;

  finally
    EndUpdate;
  end;
end;

function TFrameBgDrawEditorFMX.SaveToJSON: TJSONObject;
var
  BgStr: string;
begin
  Result := TJSONObject.Create;

  Result.AddPair('_type', 'etBgDraw');

  // 背景
  case cboBgType.ItemIndex of
    0: // 图片
      BgStr := edtBgImage.Text;
    1: // 纯色
      BgStr := AlphaColorToString(cboBgColor.Color);
    2: // 渐变
      BgStr := 'gradient:linear';
  else
    BgStr := '';
  end;
  Result.AddPair('background', BgStr);

  // 元素列表
  Result.AddPair('elements', TJSONArray(FElements.Clone));
end;

procedure TFrameBgDrawEditorFMX.UpdateBgControls;
begin
  // 根据背景类型显示/隐藏控件
  layBgImage.Visible := (cboBgType.ItemIndex = 0);
  layBgColor.Visible := (cboBgType.ItemIndex >= 1);
end;

procedure TFrameBgDrawEditorFMX.RefreshElementList;
var
  I: Integer;
  Elem: TJSONObject;
  ElemType, ElemText: string;
begin
  lstElements.Clear;

  for I := 0 to FElements.Count - 1 do
  begin
    if FElements.Items[I] is TJSONObject then
    begin
      Elem := TJSONObject(FElements.Items[I]);
      ElemType := GetJSONString(Elem, 'type', 'unknown');
      ElemText := GetJSONString(Elem, 'text', GetJSONString(Elem, 'src', ''));
      lstElements.Items.Add(Format('[%s] %s', [ElemType, ElemText]));
    end;
  end;
end;

procedure TFrameBgDrawEditorFMX.cboBgTypeChange(Sender: TObject);
begin
  UpdateBgControls;
  DoModified;
end;

procedure TFrameBgDrawEditorFMX.btnBrowseBgClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Filter := '图片文件 (*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp|所有文件 (*.*)|*.*';
    if edtBgImage.Text <> '' then
      Dlg.FileName := edtBgImage.Text;
    if Dlg.Execute then
    begin
      edtBgImage.Text := Dlg.FileName;
      DoModified;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TFrameBgDrawEditorFMX.btnAddElementClick(Sender: TObject);
var
  ElemType: string;
  NewElem: TJSONObject;
begin
  // 简单实现: 添加文字元素
  ElemType := InputBox('添加元素', '请输入元素类型 (text/image/caption):', 'text');
  if ElemType = '' then Exit;

  NewElem := TJSONObject.Create;
  NewElem.AddPair('type', ElemType);
  if ElemType = 'text' then
    NewElem.AddPair('text', '新文字')
  else if ElemType = 'image' then
    NewElem.AddPair('src', '')
  else if ElemType = 'caption' then
    NewElem.AddPair('text', '字幕文字');

  NewElem.AddPair('x', TJSONNumber.Create(0));
  NewElem.AddPair('y', TJSONNumber.Create(0));

  FElements.AddElement(NewElem);
  RefreshElementList;
  DoModified;
end;

procedure TFrameBgDrawEditorFMX.btnEditElementClick(Sender: TObject);
var
  Idx: Integer;
  Elem: TJSONObject;
  CurrentText, NewText: string;
begin
  Idx := lstElements.ItemIndex;
  if (Idx < 0) or (Idx >= FElements.Count) then
  begin
    ShowMessage('请先选择一个元素');
    Exit;
  end;

  if FElements.Items[Idx] is TJSONObject then
  begin
    Elem := TJSONObject(FElements.Items[Idx]);
    CurrentText := GetJSONString(Elem, 'text', GetJSONString(Elem, 'src', ''));
    NewText := InputBox('编辑元素', '请输入新内容:', CurrentText);
    if NewText <> CurrentText then
    begin
      if Elem.GetValue('text') <> nil then
        SetJSONString(Elem, 'text', NewText)
      else if Elem.GetValue('src') <> nil then
        SetJSONString(Elem, 'src', NewText);
      RefreshElementList;
      DoModified;
    end;
  end;
end;

procedure TFrameBgDrawEditorFMX.btnRemoveElementClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := lstElements.ItemIndex;
  if (Idx < 0) or (Idx >= FElements.Count) then
  begin
    ShowMessage('请先选择一个元素');
    Exit;
  end;

  if MessageDlg('确定要删除此元素吗？', TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
  begin
    FElements.Remove(Idx);
    RefreshElementList;
    DoModified;
  end;
end;

procedure TFrameBgDrawEditorFMX.btnMoveUpClick(Sender: TObject);
var
  Idx: Integer;
  Temp: TJSONValue;
begin
  Idx := lstElements.ItemIndex;
  if Idx <= 0 then Exit;

  // 交换元素
  Temp := FElements.Items[Idx];
  FElements.Remove(Idx);
  // 注意: TJSONArray 没有 Insert 方法，需要重建
  // 简化处理：暂不支持移动
  ShowMessage('移动功能待完善');
end;

procedure TFrameBgDrawEditorFMX.btnMoveDownClick(Sender: TObject);
begin
  ShowMessage('移动功能待完善');
end;

procedure TFrameBgDrawEditorFMX.edtChange(Sender: TObject);
begin
  DoModified;
end;

end.
