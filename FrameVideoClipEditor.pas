unit FrameVideoClipEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtDlgs, System.JSON, System.Generics.Collections,
  UtilsTypes;

type
  TFrameVideoClipEditor = class(TFrame)
    pnlToolbar: TPanel;
    pnlMain: TPanel;
    pnlBackground: TPanel;
    lblBackground: TLabel;
    edtBackground: TEdit;
    btnBrowseBackground: TButton;
    dlgOpenImage: TOpenPictureDialog;
    dlgOpenAudio: TOpenDialog;
    pnlDuration: TPanel;
    lblDuration: TLabel;
    edtDuration: TEdit;
    lblFps: TLabel;
    edtFps: TEdit;
    pnlAudio: TPanel;
    lblAudio: TLabel;
    edtAudio: TEdit;
    btnBrowseAudio: TButton;
    pnlCaptions: TPanel;
    lblCaptions: TLabel;
    lvCaptions: TListView;
    btnAddCaption: TButton;
    btnEditCaption: TButton;
    btnDeleteCaption: TButton;
    btnSave: TButton;
    pnlCaptionEdit: TPanel;
    lblCaptionText: TLabel;
    edtCaptionText: TEdit;
    lblStartTime: TLabel;
    edtStartTime: TEdit;
    lblCaptionDuration: TLabel;
    edtCaptionDuration: TEdit;
    btnFont: TButton;
    btnSaveCaption: TButton;
    btnCancelCaption: TButton;
    dlgFont: TFontDialog;
    procedure btnBrowseBackgroundClick(Sender: TObject);
    procedure btnBrowseAudioClick(Sender: TObject);
    procedure btnAddCaptionClick(Sender: TObject);
    procedure btnEditCaptionClick(Sender: TObject);
    procedure btnDeleteCaptionClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnSaveCaptionClick(Sender: TObject);
    procedure btnCancelCaptionClick(Sender: TObject);
  private
    FCurrentJson: TJSONObject;
    FCaptions: TList<TJSONObject>;
    FCurrentCaption: TJSONObject;
    FCurrentFont: TFont;
    FEditingCaptionIndex: Integer;
    
    // 初始化控件
    procedure InitializeControls;
    
    // 更新字幕列表
    procedure UpdateCaptionList;
    
    // 显示字幕编辑面板
    procedure ShowCaptionEditPanel(Show: Boolean);
    
    // 加载字幕数据到编辑面板
    procedure LoadCaptionToEditor(Caption: TJSONObject);
    
    // 从编辑面板保存字幕数据
    function SaveCaptionFromEditor: TJSONObject;
    
    // 添加字幕到列表
    procedure AddCaptionToList(Caption: TJSONObject);
    
    // 更新列表中的字幕
    procedure UpdateCaptionInList(Index: Integer; Caption: TJSONObject);
    
    // 清理资源
    procedure ClearCaptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    // 从JSON加载数据
    procedure LoadFromJSON(JSON: TJSONObject);
    
    // 保存数据到JSON
    function SaveToJSON: TJSONObject;
  end;

implementation

{$R *.dfm}

{ TFrameVideoClipEditor }

constructor TFrameVideoClipEditor.Create(AOwner: TComponent);
begin
  inherited;
  
  FCaptions := TList<TJSONObject>.Create;
  FCurrentFont := TFont.Create;
  
  InitializeControls;
  ShowCaptionEditPanel(False);
end;

destructor TFrameVideoClipEditor.Destroy;
begin
  ClearCaptions;
  FCaptions.Free;
  FCurrentFont.Free;
  
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
    
  inherited;
end;

procedure TFrameVideoClipEditor.InitializeControls;
begin
  // 设置ListVIew列
  with lvCaptions.Columns.Add do
  begin
    Caption := '文本';
    Width := 200;
  end;
  
  with lvCaptions.Columns.Add do
  begin
    Caption := '开始时间';
    Width := 80;
  end;
  
  with lvCaptions.Columns.Add do
  begin
    Caption := '持续时间';
    Width := 80;
  end;
  
  // 设置对话框
  dlgOpenImage.Filter := '图片文件(*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp';
  dlgOpenAudio.Filter := '音频文件(*.mp3;*.wav;*.ogg)|*.mp3;*.wav;*.ogg';
  
  // 设置默认值
  edtDuration.Text := '10.0';
  edtFps.Text := '30';
end;

procedure TFrameVideoClipEditor.LoadFromJSON(JSON: TJSONObject);
var
  CaptionsArray: TJSONArray;
  I: Integer;
begin
  if JSON = nil then
    Exit;
    
  // 保存当前JSON
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
    
  FCurrentJson := TJSONObject(JSON.Clone);
  
  // 清理现有字幕
  ClearCaptions;
  
  // 加载基本属性
  if JSON.GetValue('background') <> nil then
    edtBackground.Text := JSON.GetValue<string>('background');
    
  if JSON.GetValue('duration') <> nil then
    edtDuration.Text := JSON.GetValue<string>('duration');
    
  if JSON.GetValue('fps') <> nil then
    edtFps.Text := JSON.GetValue<string>('fps');
    
  if JSON.GetValue('audio') <> nil then
    edtAudio.Text := JSON.GetValue<string>('audio');
    
  // 加载字幕
  if JSON.GetValue('captions') <> nil then
  begin
    CaptionsArray := JSON.GetValue<TJSONArray>('captions');
    
    for I := 0 to CaptionsArray.Count - 1 do
    begin
      AddCaptionToList(TJSONObject(CaptionsArray.Items[I].Clone));
    end;
    
    UpdateCaptionList;
  end;
end;

function TFrameVideoClipEditor.SaveToJSON: TJSONObject;
var
  CaptionsArray: TJSONArray;
  I: Integer;
begin
  Result := TJSONObject.Create;
  
  // 保存基本属性
  Result.AddPair('_type', 'etVideoClip');
  Result.AddPair('background', edtBackground.Text);
  Result.AddPair('duration', edtDuration.Text);
  Result.AddPair('fps', edtFps.Text);
  Result.AddPair('audio', edtAudio.Text);
  
  // 保存字幕
  CaptionsArray := TJSONArray.Create;
  
  for I := 0 to FCaptions.Count - 1 do
  begin
    CaptionsArray.Add(TJSONObject(FCaptions[I].Clone));
  end;
  
  Result.AddPair('captions', CaptionsArray);
end;

procedure TFrameVideoClipEditor.ClearCaptions;
begin
  for var Caption in FCaptions do
    Caption.Free;
    
  FCaptions.Clear;
end;

procedure TFrameVideoClipEditor.UpdateCaptionList;
var
  I: Integer;
  Item: TListItem;
  Caption: TJSONObject;
begin
  lvCaptions.Items.Clear;
  
  for I := 0 to FCaptions.Count - 1 do
  begin
    Caption := FCaptions[I];
    Item := lvCaptions.Items.Add;
    
    Item.Caption := Caption.GetValue('text').Value;
    Item.SubItems.Add(Caption.GetValue('start_time').Value);
    Item.SubItems.Add(Caption.GetValue('duration').Value);
    Item.Data := Caption;
  end;
end;

procedure TFrameVideoClipEditor.ShowCaptionEditPanel(Show: Boolean);
begin
  pnlCaptionEdit.Visible := Show;
  pnlCaptions.Enabled := not Show;
  pnlBackground.Enabled := not Show;
  pnlDuration.Enabled := not Show;
  pnlAudio.Enabled := not Show;
  btnSave.Enabled := not Show;
end;

procedure TFrameVideoClipEditor.LoadCaptionToEditor(Caption: TJSONObject);
var
  FontObj: TJSONObject;
begin
  if Caption = nil then
  begin
    edtCaptionText.Text := '';
    edtStartTime.Text := '0.0';
    edtCaptionDuration.Text := '5.0';
    FCurrentFont.Name := 'Arial';
    FCurrentFont.Size := 12;
    FCurrentFont.Color := clBlack;
    FCurrentFont.Style := [];
    Exit;
  end;
  
  if Caption.GetValue('text') <> nil then
    edtCaptionText.Text := Caption.GetValue<string>('text');
    
  if Caption.GetValue('start_time') <> nil then
    edtStartTime.Text := Caption.GetValue<string>('start_time');
    
  if Caption.GetValue('duration') <> nil then
    edtCaptionDuration.Text := Caption.GetValue<string>('duration');
    
  // 加载字体
  if Caption.GetValue('font') <> nil then
  begin
    FontObj := Caption.GetValue<TJSONObject>('font');
    
    if FontObj.GetValue('name') <> nil then
      FCurrentFont.Name := FontObj.GetValue<string>('name');
      
    if FontObj.GetValue('size') <> nil then
      FCurrentFont.Size := FontObj.GetValue<Integer>('size');
      
    if FontObj.GetValue('color') <> nil then
      FCurrentFont.Color := FontObj.GetValue<Integer>('color');
      
    if FontObj.GetValue('style') <> nil then
    begin
      FCurrentFont.Style := [];
      var StyleArray := FontObj.GetValue<TJSONArray>('style');
      
      for var I := 0 to StyleArray.Count - 1 do
      begin
        var StyleStr := StyleArray.Items[I].Value;
        if StyleStr = 'bold' then
          FCurrentFont.Style := FCurrentFont.Style + [fsBold]
        else if StyleStr = 'italic' then
          FCurrentFont.Style := FCurrentFont.Style + [fsItalic]
        else if StyleStr = 'underline' then
          FCurrentFont.Style := FCurrentFont.Style + [fsUnderline]
        else if StyleStr = 'strikeout' then
          FCurrentFont.Style := FCurrentFont.Style + [fsStrikeOut];
      end;
    end;
  end;
end;

function TFrameVideoClipEditor.SaveCaptionFromEditor: TJSONObject;
var
  FontObj: TJSONObject;
  StyleArray: TJSONArray;
begin
  Result := TJSONObject.Create;
  
  // 保存基本属性
  Result.AddPair('text', edtCaptionText.Text);
  Result.AddPair('start_time', edtStartTime.Text);
  Result.AddPair('duration', edtCaptionDuration.Text);
  
  // 保存字体
  FontObj := TJSONObject.Create;
  FontObj.AddPair('name', FCurrentFont.Name);
  FontObj.AddPair('size', TJSONNumber.Create(FCurrentFont.Size));
  FontObj.AddPair('color', TJSONNumber.Create(FCurrentFont.Color));
  
  StyleArray := TJSONArray.Create;
  if fsBold in FCurrentFont.Style then
    StyleArray.Add('bold');
  if fsItalic in FCurrentFont.Style then
    StyleArray.Add('italic');
  if fsUnderline in FCurrentFont.Style then
    StyleArray.Add('underline');
  if fsStrikeOut in FCurrentFont.Style then
    StyleArray.Add('strikeout');
    
  FontObj.AddPair('style', StyleArray);
  Result.AddPair('font', FontObj);
end;

procedure TFrameVideoClipEditor.AddCaptionToList(Caption: TJSONObject);
begin
  FCaptions.Add(Caption);
  UpdateCaptionList;
end;

procedure TFrameVideoClipEditor.UpdateCaptionInList(Index: Integer; Caption: TJSONObject);
begin
  if (Index >= 0) and (Index < FCaptions.Count) then
  begin
    FCaptions[Index].Free;
    FCaptions[Index] := Caption;
    UpdateCaptionList;
  end;
end;

procedure TFrameVideoClipEditor.btnBrowseBackgroundClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
  begin
    edtBackground.Text := dlgOpenImage.FileName;
  end;
end;

procedure TFrameVideoClipEditor.btnBrowseAudioClick(Sender: TObject);
begin
  if dlgOpenAudio.Execute then
  begin
    edtAudio.Text := dlgOpenAudio.FileName;
  end;
end;

procedure TFrameVideoClipEditor.btnAddCaptionClick(Sender: TObject);
begin
  // 准备添加新字幕
  FEditingCaptionIndex := -1;
  LoadCaptionToEditor(nil);
  ShowCaptionEditPanel(True);
end;

procedure TFrameVideoClipEditor.btnEditCaptionClick(Sender: TObject);
begin
  if lvCaptions.Selected = nil then
    Exit;
    
  // 准备编辑字幕
  FEditingCaptionIndex := lvCaptions.Selected.Index;
  LoadCaptionToEditor(FCaptions[FEditingCaptionIndex]);
  ShowCaptionEditPanel(True);
end;

procedure TFrameVideoClipEditor.btnDeleteCaptionClick(Sender: TObject);
begin
  if lvCaptions.Selected = nil then
    Exit;
    
  var Index := lvCaptions.Selected.Index;
  
  if (Index >= 0) and (Index < FCaptions.Count) then
  begin
    FCaptions[Index].Free;
    FCaptions.Delete(Index);
    UpdateCaptionList;
  end;
end;

procedure TFrameVideoClipEditor.btnSaveClick(Sender: TObject);
begin
  // 保存事件 - 在ControllerConfigs中处理
end;

procedure TFrameVideoClipEditor.btnFontClick(Sender: TObject);
begin
  dlgFont.Font.Assign(FCurrentFont);
  
  if dlgFont.Execute then
  begin
    FCurrentFont.Assign(dlgFont.Font);
  end;
end;

procedure TFrameVideoClipEditor.btnSaveCaptionClick(Sender: TObject);
var
  Caption: TJSONObject;
begin
  Caption := SaveCaptionFromEditor;
  
  if FEditingCaptionIndex >= 0 then
    UpdateCaptionInList(FEditingCaptionIndex, Caption)
  else
    AddCaptionToList(Caption);
    
  ShowCaptionEditPanel(False);
end;

procedure TFrameVideoClipEditor.btnCancelCaptionClick(Sender: TObject);
begin
  ShowCaptionEditPanel(False);
end;

end. 