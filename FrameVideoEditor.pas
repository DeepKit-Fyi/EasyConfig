unit FrameVideoEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtDlgs, System.JSON, System.Generics.Collections,
  ConfigFrameBase, UtilsTypes, System.UITypes, JSONHelpers;

type
  TClipInfo = class
  public
    Name: string;
    BackgroundPath: string;
    Duration: Double;
    AudioPath: string;
    JsonData: TJSONObject;
    constructor Create(const AName: string);
  end;

  TFrameVideoEditor = class(TBaseConfigFrame)
    pnlToolbar: TPanel;
    btnSave: TButton;
    pnlMain: TPanel;
    pnlCover: TPanel;
    lblCover: TLabel;
    edtCover: TEdit;
    btnBrowseCover: TButton;
    pnlEnding: TPanel;
    lblEnding: TLabel;
    edtEnding: TEdit;
    btnBrowseEnding: TButton;
    pnlDirectories: TPanel;
    lblBgDirectory: TLabel;
    edtBgDirectory: TEdit;
    btnBrowseBgDir: TButton;
    lblAudioDirectory: TLabel;
    edtAudioDirectory: TEdit;
    btnBrowseAudioDir: TButton;
    pnlSubtitle: TPanel;
    lblSubtitleFile: TLabel;
    edtSubtitleFile: TEdit;
    btnBrowseSubtitle: TButton;
    pgcMain: TPageControl;
    tabSettings: TTabSheet;
    tabClips: TTabSheet;
    pnlSettings: TPanel;
    lblResolution: TLabel;
    cmbResolution: TComboBox;
    lblFormat: TLabel;
    cmbFormat: TComboBox;
    lblQuality: TLabel;
    trkQuality: TTrackBar;
    lblQualityValue: TLabel;
    chkAutoAdjustBitrate: TCheckBox;
    lblBitrate: TLabel;
    edtBitrate: TEdit;
    pnlClips: TPanel;
    lvClips: TListView;
    btnAddClip: TButton;
    btnEditClip: TButton;
    btnDeleteClip: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    dlgOpenImage: TOpenPictureDialog;
    dlgOpenSub: TOpenDialog;
    dlgSelectDir: TFileOpenDialog;
    procedure btnBrowseCoverClick(Sender: TObject);
    procedure btnBrowseEndingClick(Sender: TObject);
    procedure btnBrowseBgDirClick(Sender: TObject);
    procedure btnBrowseAudioDirClick(Sender: TObject);
    procedure btnBrowseSubtitleClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure trkQualityChange(Sender: TObject);
    procedure chkAutoAdjustBitrateClick(Sender: TObject);
    procedure btnAddClipClick(Sender: TObject);
    procedure btnEditClipClick(Sender: TObject);
    procedure btnDeleteClipClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
  private
    FCurrentJson: TJSONObject;
    FClips: TList<TJSONObject>;
    
    // 初始化控件
    procedure InitializeControls;
    
    // 更新视频片段列表
    procedure UpdateClipList;
    
    // 添加视频片段到列表
    procedure AddClipToList(Clip: TJSONObject);
    
    // 清理资源
    procedure ClearClips;
    
    // 生成媒体设置JSON
    function CreateMediaSettingsJson: TJSONObject;
    
    // 加载媒体设置
    procedure LoadMediaSettings(Settings: TJSONObject);
  protected
    procedure LoadFromJSON; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    // 保存数据到JSON
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TClipInfo }

constructor TClipInfo.Create(const AName: string);
begin
  inherited Create;
  Name := AName;
  BackgroundPath := '';
  Duration := 5.0;
  AudioPath := '';
  JsonData := TJSONObject.Create;
end;

{ TFrameVideoEditor }

constructor TFrameVideoEditor.Create(AOwner: TComponent);
begin
  inherited;
  
  FClips := TList<TJSONObject>.Create;
  
  InitializeControls;
end;

destructor TFrameVideoEditor.Destroy;
begin
  ClearClips;
  FClips.Free;
  
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
    
  inherited;
end;

procedure TFrameVideoEditor.InitializeControls;
begin
  // 设置ListView列
  with lvClips.Columns.Add do
  begin
    Caption := '片段名称';
    Width := 150;
  end;
  
  with lvClips.Columns.Add do
  begin
    Caption := '时长';
    Width := 80;
  end;
  
  with lvClips.Columns.Add do
  begin
    Caption := '背景';
    Width := 250;
  end;
  
  with lvClips.Columns.Add do
  begin
    Caption := '音频';
    Width := 150;
  end;
  
  // 设置对话框
  dlgOpenImage.Filter := '图片文件(*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp';
  dlgOpenSub.Filter := '字幕文件(*.srt;*.ass;*.ssa)|*.srt;*.ass;*.ssa';
  
  // 设置目录选择对话框
  dlgSelectDir.Options := [fdoPickFolders, fdoPathMustExist];
  
  // 填充分辨率下拉列表
  cmbResolution.Items.Add('1920x1080 (1080p)');
  cmbResolution.Items.Add('1280x720 (720p)');
  cmbResolution.Items.Add('854x480 (480p)');
  cmbResolution.Items.Add('640x360 (360p)');
  cmbResolution.ItemIndex := 0;
  
  // 填充格式下拉列表
  cmbFormat.Items.Add('MP4 (H.264)');
  cmbFormat.Items.Add('WebM (VP9)');
  cmbFormat.Items.Add('AVI');
  cmbFormat.Items.Add('MOV');
  cmbFormat.ItemIndex := 0;
  
  // 设置质量滑块
  trkQuality.Position := 80;
  lblQualityValue.Caption := IntToStr(trkQuality.Position) + '%';
  
  // 设置默认比特率
  edtBitrate.Text := '5000';
  chkAutoAdjustBitrate.Checked := True;
  edtBitrate.Enabled := not chkAutoAdjustBitrate.Checked;
end;

procedure TFrameVideoEditor.LoadFromJSON;
var
  ClipsArray: TJSONArray;
  SettingsObj: TJSONObject;
  I: Integer;
  Value: string;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // 清理现有片段
  ClearClips;
  
  // 加载基本属性
  Value := '';
  if JSONObject.TryGetValue('cover', Value) then
    edtCover.Text := Value
  else
    edtCover.Text := '';
    
  Value := '';
  if JSONObject.TryGetValue('ending', Value) then
    edtEnding.Text := Value
  else
    edtEnding.Text := '';
    
  Value := '';
  if JSONObject.TryGetValue('bg_directory', Value) then
    edtBgDirectory.Text := Value
  else
    edtBgDirectory.Text := '';
    
  Value := '';
  if JSONObject.TryGetValue('audio_directory', Value) then
    edtAudioDirectory.Text := Value
  else
    edtAudioDirectory.Text := '';
    
  Value := '';
  if JSONObject.TryGetValue('subtitle_file', Value) then
    edtSubtitleFile.Text := Value
  else
    edtSubtitleFile.Text := '';
    
  // 加载媒体设置
  try
    SettingsObj := JSONObject.GetValue('media_settings') as TJSONObject;
    if Assigned(SettingsObj) then
      LoadMediaSettings(SettingsObj);
  except
    // 忽略错误
  end;
    
  // 加载片段
  try
    ClipsArray := JSONObject.GetValue('clips') as TJSONArray;
    if Assigned(ClipsArray) then
    begin
      for I := 0 to ClipsArray.Count - 1 do
      begin
        if ClipsArray.Items[I] is TJSONObject then
          AddClipToList(TJSONObject(ClipsArray.Items[I].Clone));
      end;
    end;
  except
    // 忽略错误
  end;
  
  // 更新UI
  UpdateClipList;
end;

procedure TFrameVideoEditor.SaveToJSON;
var
  ClipsArray: TJSONArray;
  I: Integer;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // 保存基本属性
  JSONObject.RemovePair('cover');
  JSONObject.AddPair('cover', edtCover.Text);
  
  JSONObject.RemovePair('ending');
  JSONObject.AddPair('ending', edtEnding.Text);
  
  JSONObject.RemovePair('bg_directory');
  JSONObject.AddPair('bg_directory', edtBgDirectory.Text);
  
  JSONObject.RemovePair('audio_directory');
  JSONObject.AddPair('audio_directory', edtAudioDirectory.Text);
  
  JSONObject.RemovePair('subtitle_file');
  JSONObject.AddPair('subtitle_file', edtSubtitleFile.Text);
  
  // 保存媒体设置
  JSONObject.RemovePair('media_settings');
  JSONObject.AddPair('media_settings', CreateMediaSettingsJson);
  
  // 保存片段
  ClipsArray := TJSONArray.Create;
  for I := 0 to FClips.Count - 1 do
  begin
    ClipsArray.Add(TJSONObject(FClips[I].Clone));
  end;
    
  JSONObject.RemovePair('clips');
  JSONObject.AddPair('clips', ClipsArray);
  
  // 触发修改事件
  Modified := True;
end;

procedure TFrameVideoEditor.AddClipToList(Clip: TJSONObject);
var
  Item: TListItem;
  ClipName, Background, Audio, Duration: string;
begin
  // 添加到内部列表
  FClips.Add(Clip);
  
  // 添加到ListView
  Item := lvClips.Items.Add;
  
  // 尝试读取片段属性
  if Clip.TryGetValue<string>('name', ClipName) then
    Item.Caption := ClipName
  else
    Item.Caption := '未命名片段' + IntToStr(lvClips.Items.Count);
    
  if Clip.TryGetValue<string>('duration', Duration) then
    Item.SubItems.Add(Duration + ' 秒')
  else
    Item.SubItems.Add('未知');
    
  if Clip.TryGetValue<string>('background', Background) then
    Item.SubItems.Add(Background)
  else
    Item.SubItems.Add('未设置');
    
  if Clip.TryGetValue<string>('audio', Audio) then
    Item.SubItems.Add(Audio)
  else
    Item.SubItems.Add('未设置');
    
  Item.Data := Clip;
end;

procedure TFrameVideoEditor.UpdateClipList;
begin
  lvClips.Items.BeginUpdate;
  try
    lvClips.Items.Clear;
    
    // 重新添加所有片段
    for var I := 0 to FClips.Count - 1 do
    begin
      var Item := lvClips.Items.Add;
      var Clip := FClips[I];
      var ClipName, Background, Audio, Duration: string;
      
      if Clip.TryGetValue<string>('name', ClipName) then
        Item.Caption := ClipName
      else
        Item.Caption := '未命名片段' + IntToStr(I + 1);
        
      if Clip.TryGetValue<string>('duration', Duration) then
        Item.SubItems.Add(Duration + ' 秒')
      else
        Item.SubItems.Add('未知');
        
      if Clip.TryGetValue<string>('background', Background) then
        Item.SubItems.Add(Background)
      else
        Item.SubItems.Add('未设置');
        
      if Clip.TryGetValue<string>('audio', Audio) then
        Item.SubItems.Add(Audio)
      else
        Item.SubItems.Add('未设置');
        
      Item.Data := Clip;
    end;
  finally
    lvClips.Items.EndUpdate;
  end;
  
  // 更新按钮状态
  btnEditClip.Enabled := lvClips.ItemIndex >= 0;
  btnDeleteClip.Enabled := lvClips.ItemIndex >= 0;
  btnMoveUp.Enabled := (lvClips.ItemIndex > 0);
  btnMoveDown.Enabled := (lvClips.ItemIndex >= 0) and (lvClips.ItemIndex < lvClips.Items.Count - 1);
end;

procedure TFrameVideoEditor.ClearClips;
begin
  // 释放所有片段
  for var I := 0 to FClips.Count - 1 do
  begin
    FClips[I].Free;
  end;
    
  FClips.Clear;
  lvClips.Items.Clear;
end;

function TFrameVideoEditor.CreateMediaSettingsJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  
  // 添加分辨率
  case cmbResolution.ItemIndex of
    0: Result.AddPair('resolution', '1920x1080');
    1: Result.AddPair('resolution', '1280x720');
    2: Result.AddPair('resolution', '854x480');
    3: Result.AddPair('resolution', '640x360');
    else Result.AddPair('resolution', '1280x720');
  end;
  
  // 添加格式
  case cmbFormat.ItemIndex of
    0: Result.AddPair('format', 'mp4');
    1: Result.AddPair('format', 'webm');
    2: Result.AddPair('format', 'avi');
    3: Result.AddPair('format', 'mov');
    else Result.AddPair('format', 'mp4');
  end;
  
  // 添加质量
  Result.AddPair('quality', TJSONNumber.Create(trkQuality.Position));
  
  // 添加自动调整比特率
  Result.AddPair('auto_bitrate', TJSONBool.Create(chkAutoAdjustBitrate.Checked));
  
  // 添加比特率
  try
    Result.AddPair('bitrate', TJSONNumber.Create(StrToInt(edtBitrate.Text)));
  except
    Result.AddPair('bitrate', TJSONNumber.Create(5000));
  end;
end;

procedure TFrameVideoEditor.LoadMediaSettings(Settings: TJSONObject);
var
  Resolution, Format: string;
  Quality, Bitrate: Integer;
  AutoBitrate: Boolean;
begin
  if not Assigned(Settings) then
    Exit;
    
  // 加载分辨率
  Resolution := '';
  if Settings.TryGetValue<string>('resolution', Resolution) then
  begin
    if Resolution = '1920x1080' then
      cmbResolution.ItemIndex := 0
    else if Resolution = '1280x720' then
      cmbResolution.ItemIndex := 1
    else if Resolution = '854x480' then
      cmbResolution.ItemIndex := 2
    else if Resolution = '640x360' then
      cmbResolution.ItemIndex := 3
    else
      cmbResolution.ItemIndex := 1; // 默认720p
  end;
  
  // 加载格式
  Format := '';
  if Settings.TryGetValue<string>('format', Format) then
  begin
    if Format = 'mp4' then
      cmbFormat.ItemIndex := 0
    else if Format = 'webm' then
      cmbFormat.ItemIndex := 1
    else if Format = 'avi' then
      cmbFormat.ItemIndex := 2
    else if Format = 'mov' then
      cmbFormat.ItemIndex := 3
    else
      cmbFormat.ItemIndex := 0; // 默认mp4
  end;
  
  // 加载质量
  Quality := 80;
  if Settings.TryGetValue<Integer>('quality', Quality) then
  begin
    trkQuality.Position := Quality;
    lblQualityValue.Caption := IntToStr(Quality) + '%';
  end;
  
  // 加载自动调整比特率
  AutoBitrate := True;
  if Settings.TryGetValue<Boolean>('auto_bitrate', AutoBitrate) then
    chkAutoAdjustBitrate.Checked := AutoBitrate;
    
  // 加载比特率
  Bitrate := 5000;
  if Settings.TryGetValue<Integer>('bitrate', Bitrate) then
    edtBitrate.Text := IntToStr(Bitrate);
    
  // 更新比特率输入框启用状态
  edtBitrate.Enabled := not chkAutoAdjustBitrate.Checked;
end;

procedure TFrameVideoEditor.trkQualityChange(Sender: TObject);
begin
  lblQualityValue.Caption := IntToStr(trkQuality.Position) + '%';
end;

procedure TFrameVideoEditor.btnSaveClick(Sender: TObject);
begin
  SaveToJSON;
end;

procedure TFrameVideoEditor.btnBrowseCoverClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
    edtCover.Text := dlgOpenImage.FileName;
end;

procedure TFrameVideoEditor.btnBrowseEndingClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
    edtEnding.Text := dlgOpenImage.FileName;
end;

procedure TFrameVideoEditor.btnBrowseBgDirClick(Sender: TObject);
begin
  if dlgSelectDir.Execute then
    edtBgDirectory.Text := dlgSelectDir.FileName;
end;

procedure TFrameVideoEditor.btnBrowseAudioDirClick(Sender: TObject);
begin
  if dlgSelectDir.Execute then
    edtAudioDirectory.Text := dlgSelectDir.FileName;
end;

procedure TFrameVideoEditor.btnBrowseSubtitleClick(Sender: TObject);
begin
  if dlgOpenSub.Execute then
    edtSubtitleFile.Text := dlgOpenSub.FileName;
end;

procedure TFrameVideoEditor.chkAutoAdjustBitrateClick(Sender: TObject);
begin
  edtBitrate.Enabled := not chkAutoAdjustBitrate.Checked;
end;

procedure TFrameVideoEditor.btnAddClipClick(Sender: TObject);
var
  ClipJson: TJSONObject;
  ClipName: string;
begin
  // 获取片段名称
  ClipName := '';
  if not InputQuery('添加视频片段', '请输入片段名称', ClipName) then
    Exit;
    
  if ClipName = '' then
    ClipName := '新片段_' + IntToStr(FClips.Count + 1);
    
  // 创建片段JSON
  ClipJson := TJSONObject.Create;
  ClipJson.AddPair('name', ClipName);
  ClipJson.AddPair('duration', TJSONNumber.Create(5.0));
  ClipJson.AddPair('background', '');
  ClipJson.AddPair('audio', '');
  
  // 添加到列表
  AddClipToList(ClipJson);
  
  // 选中新添加的项
  lvClips.ItemIndex := lvClips.Items.Count - 1;
  
  // 更新按钮状态
  btnEditClip.Enabled := True;
  btnDeleteClip.Enabled := True;
  btnMoveUp.Enabled := lvClips.ItemIndex > 0;
  btnMoveDown.Enabled := lvClips.ItemIndex < lvClips.Items.Count - 1;
end;

procedure TFrameVideoEditor.btnEditClipClick(Sender: TObject);
begin
  // TODO: 实现编辑视频片段的功能
  ShowMessage('此功能尚未实现');
end;

procedure TFrameVideoEditor.btnDeleteClipClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := lvClips.ItemIndex;
  if (Index < 0) or (Index >= FClips.Count) then
    Exit;
    
  if MessageDlg('确定要删除"' + lvClips.Items[Index].Caption + '" 片段吗?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // 释放JSON对象
    FClips[Index].Free;
    
    // 从列表中移除
    FClips.Delete(Index);
    
    // 更新UI
    UpdateClipList;
  end;
end;

procedure TFrameVideoEditor.btnMoveUpClick(Sender: TObject);
var
  Index: Integer;
  Temp: TJSONObject;
begin
  Index := lvClips.ItemIndex;
  if (Index <= 0) or (Index >= FClips.Count) then
    Exit;
    
  // 交换位置
  Temp := FClips[Index];
  FClips[Index] := FClips[Index - 1];
  FClips[Index - 1] := Temp;
  
  // 更新UI
  UpdateClipList;
  
  // 重新选中
  lvClips.ItemIndex := Index - 1;
end;

procedure TFrameVideoEditor.btnMoveDownClick(Sender: TObject);
var
  Index: Integer;
  Temp: TJSONObject;
begin
  Index := lvClips.ItemIndex;
  if (Index < 0) or (Index >= FClips.Count - 1) then
    Exit;
    
  // 交换位置
  Temp := FClips[Index];
  FClips[Index] := FClips[Index + 1];
  FClips[Index + 1] := Temp;
  
  // 更新UI
  UpdateClipList;
  
  // 重新选中
  lvClips.ItemIndex := Index + 1;
end;

end. 