unit FrameVideoEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtDlgs, System.JSON, System.Generics.Collections,
  UtilsTypes;

type
  TFrameVideoEditor = class(TFrame)
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
    
    // 在列表中插入视频片段
    procedure InsertClipToList(Index: Integer; Clip: TJSONObject);
    
    // 更新列表中的视频片段
    procedure UpdateClipInList(Index: Integer; Clip: TJSONObject);
    
    // 清理资源
    procedure ClearClips;
    
    // 生成媒体设置JSON
    function CreateMediaSettingsJson: TJSONObject;
    
    // 加载媒体设置
    procedure LoadMediaSettings(Settings: TJSONObject);
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
  // 设置ListVIew列
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

procedure TFrameVideoEditor.LoadFromJSON(JSON: TJSONObject);
var
  ClipsArray: TJSONArray;
  SettingsObj: TJSONObject;
  I: Integer;
begin
  if JSON = nil then
    Exit;
    
  // 保存当前JSON
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
    
  FCurrentJson := TJSONObject(JSON.Clone);
  
  // 清理现有片段
  ClearClips;
  
  // 加载基本属性
  if JSON.GetValue('cover') <> nil then
    edtCover.Text := JSON.GetValue<string>('cover');
    
  if JSON.GetValue('ending') <> nil then
    edtEnding.Text := JSON.GetValue<string>('ending');
    
  if JSON.GetValue('bg_directory') <> nil then
    edtBgDirectory.Text := JSON.GetValue<string>('bg_directory');
    
  if JSON.GetValue('audio_directory') <> nil then
    edtAudioDirectory.Text := JSON.GetValue<string>('audio_directory');
    
  if JSON.GetValue('subtitle_file') <> nil then
    edtSubtitleFile.Text := JSON.GetValue<string>('subtitle_file');
    
  // 加载媒体设置
  if JSON.GetValue('media_settings') <> nil then
    LoadMediaSettings(JSON.GetValue<TJSONObject>('media_settings'));
    
  // 加载片段
  if JSON.GetValue('clips') <> nil then
  begin
    ClipsArray := JSON.GetValue<TJSONArray>('clips');
    
    for I := 0 to ClipsArray.Count - 1 do
    begin
      AddClipToList(TJSONObject(ClipsArray.Items[I].Clone));
    end;
    
    UpdateClipList;
  end;
end;

function TFrameVideoEditor.SaveToJSON: TJSONObject;
var
  ClipsArray: TJSONArray;
  I: Integer;
begin
  Result := TJSONObject.Create;
  
  // 保存基本属性
  Result.AddPair('_type', 'etVideo');
  Result.AddPair('cover', edtCover.Text);
  Result.AddPair('ending', edtEnding.Text);
  Result.AddPair('bg_directory', edtBgDirectory.Text);
  Result.AddPair('audio_directory', edtAudioDirectory.Text);
  Result.AddPair('subtitle_file', edtSubtitleFile.Text);
  
  // 保存媒体设置
  Result.AddPair('media_settings', CreateMediaSettingsJson);
  
  // 保存片段
  ClipsArray := TJSONArray.Create;
  
  for I := 0 to FClips.Count - 1 do
  begin
    ClipsArray.Add(TJSONObject(FClips[I].Clone));
  end;
  
  Result.AddPair('clips', ClipsArray);
end;

procedure TFrameVideoEditor.ClearClips;
begin
  for var Clip in FClips do
    Clip.Free;
    
  FClips.Clear;
end;

procedure TFrameVideoEditor.UpdateClipList;
var
  I: Integer;
  Item: TListItem;
  Clip: TJSONObject;
begin
  lvClips.Items.Clear;
  
  for I := 0 to FClips.Count - 1 do
  begin
    Clip := FClips[I];
    Item := lvClips.Items.Add;
    
    if Clip.GetValue('_id') <> nil then
      Item.Caption := Clip.GetValue('_id').Value
    else
      Item.Caption := '片段_' + IntToStr(I + 1);
    
    if Clip.GetValue('duration') <> nil then
      Item.SubItems.Add(Clip.GetValue('duration').Value)
    else
      Item.SubItems.Add('');
      
    if Clip.GetValue('background') <> nil then
      Item.SubItems.Add(Clip.GetValue('background').Value)
    else
      Item.SubItems.Add('');
      
    if Clip.GetValue('audio') <> nil then
      Item.SubItems.Add(Clip.GetValue('audio').Value)
    else
      Item.SubItems.Add('');
      
    Item.Data := Clip;
  end;
end;

procedure TFrameVideoEditor.AddClipToList(Clip: TJSONObject);
begin
  FClips.Add(Clip);
  UpdateClipList;
end;

procedure TFrameVideoEditor.InsertClipToList(Index: Integer; Clip: TJSONObject);
begin
  if (Index >= 0) and (Index <= FClips.Count) then
  begin
    FClips.Insert(Index, Clip);
    UpdateClipList;
  end;
end;

procedure TFrameVideoEditor.UpdateClipInList(Index: Integer; Clip: TJSONObject);
begin
  if (Index >= 0) and (Index < FClips.Count) then
  begin
    FClips[Index].Free;
    FClips[Index] := Clip;
    UpdateClipList;
  end;
end;

function TFrameVideoEditor.CreateMediaSettingsJson: TJSONObject;
var
  Resolution: string;
  Width, Height: Integer;
begin
  Result := TJSONObject.Create;
  
  // 解析分辨率
  case cmbResolution.ItemIndex of
    0: begin // 1080p
      Width := 1920;
      Height := 1080;
    end;
    1: begin // 720p
      Width := 1280;
      Height := 720;
    end;
    2: begin // 480p
      Width := 854;
      Height := 480;
    end;
    3: begin // 360p
      Width := 640;
      Height := 360;
    end;
  else
    Width := 1280;
    Height := 720;
  end;
  
  // 添加基本设置
  Result.AddPair('width', TJSONNumber.Create(Width));
  Result.AddPair('height', TJSONNumber.Create(Height));
  Result.AddPair('format', cmbFormat.Text);
  Result.AddPair('quality', TJSONNumber.Create(trkQuality.Position));
  Result.AddPair('auto_bitrate', TJSONBool.Create(chkAutoAdjustBitrate.Checked));
  Result.AddPair('bitrate', edtBitrate.Text);
end;

procedure TFrameVideoEditor.LoadMediaSettings(Settings: TJSONObject);
var
  Width, Height: Integer;
begin
  if Settings = nil then
    Exit;
    
  // 加载分辨率
  if (Settings.GetValue('width') <> nil) and (Settings.GetValue('height') <> nil) then
  begin
    Width := Settings.GetValue<Integer>('width');
    Height := Settings.GetValue<Integer>('height');
    
    if (Width = 1920) and (Height = 1080) then
      cmbResolution.ItemIndex := 0
    else if (Width = 1280) and (Height = 720) then
      cmbResolution.ItemIndex := 1
    else if (Width = 854) and (Height = 480) then
      cmbResolution.ItemIndex := 2
    else if (Width = 640) and (Height = 360) then
      cmbResolution.ItemIndex := 3
    else
      cmbResolution.ItemIndex := 0;
  end;
  
  // 加载格式
  if Settings.GetValue('format') <> nil then
  begin
    var Format := Settings.GetValue<string>('format');
    var Index := cmbFormat.Items.IndexOf(Format);
    if Index >= 0 then
      cmbFormat.ItemIndex := Index;
  end;
  
  // 加载质量
  if Settings.GetValue('quality') <> nil then
  begin
    trkQuality.Position := Settings.GetValue<Integer>('quality');
    lblQualityValue.Caption := IntToStr(trkQuality.Position) + '%';
  end;
  
  // 加载比特率设置
  if Settings.GetValue('auto_bitrate') <> nil then
    chkAutoAdjustBitrate.Checked := Settings.GetValue<Boolean>('auto_bitrate');
    
  if Settings.GetValue('bitrate') <> nil then
    edtBitrate.Text := Settings.GetValue<string>('bitrate');
    
  edtBitrate.Enabled := not chkAutoAdjustBitrate.Checked;
end;

procedure TFrameVideoEditor.btnBrowseCoverClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
  begin
    edtCover.Text := dlgOpenImage.FileName;
  end;
end;

procedure TFrameVideoEditor.btnBrowseEndingClick(Sender: TObject);
begin
  if dlgOpenImage.Execute then
  begin
    edtEnding.Text := dlgOpenImage.FileName;
  end;
end;

procedure TFrameVideoEditor.btnBrowseBgDirClick(Sender: TObject);
begin
  if dlgSelectDir.Execute then
  begin
    edtBgDirectory.Text := dlgSelectDir.FileName;
  end;
end;

procedure TFrameVideoEditor.btnBrowseAudioDirClick(Sender: TObject);
begin
  if dlgSelectDir.Execute then
  begin
    edtAudioDirectory.Text := dlgSelectDir.FileName;
  end;
end;

procedure TFrameVideoEditor.btnBrowseSubtitleClick(Sender: TObject);
begin
  if dlgOpenSub.Execute then
  begin
    edtSubtitleFile.Text := dlgOpenSub.FileName;
  end;
end;

procedure TFrameVideoEditor.btnSaveClick(Sender: TObject);
begin
  // 保存事件 - 在ControllerConfigs中处理
end;

procedure TFrameVideoEditor.trkQualityChange(Sender: TObject);
begin
  lblQualityValue.Caption := IntToStr(trkQuality.Position) + '%';
end;

procedure TFrameVideoEditor.chkAutoAdjustBitrateClick(Sender: TObject);
begin
  edtBitrate.Enabled := not chkAutoAdjustBitrate.Checked;
end;

procedure TFrameVideoEditor.btnAddClipClick(Sender: TObject);
var
  ClipJson: TJSONObject;
begin
  // 创建一个简单的Clip JSON对象
  ClipJson := TJSONObject.Create;
  ClipJson.AddPair('_type', 'etVideoClip');
  ClipJson.AddPair('_id', 'etVideoClip.新片段_' + IntToStr(FClips.Count + 1));
  ClipJson.AddPair('background', '');
  ClipJson.AddPair('duration', '10.0');
  ClipJson.AddPair('fps', '30');
  ClipJson.AddPair('audio', '');
  ClipJson.AddPair('captions', TJSONArray.Create);
  
  // 添加到列表
  AddClipToList(ClipJson);
end;

procedure TFrameVideoEditor.btnEditClipClick(Sender: TObject);
begin
  if lvClips.Selected = nil then
    Exit;
    
  // 这里应该调用视频片段编辑器
  // 由于本框架不包含具体实现，此处只显示消息
  ShowMessage('此功能需要在ControllerConfigs中实现，调用视频片段编辑器');
end;

procedure TFrameVideoEditor.btnDeleteClipClick(Sender: TObject);
begin
  if lvClips.Selected = nil then
    Exit;
    
  var Index := lvClips.Selected.Index;
  
  if (Index >= 0) and (Index < FClips.Count) then
  begin
    FClips[Index].Free;
    FClips.Delete(Index);
    UpdateClipList;
  end;
end;

procedure TFrameVideoEditor.btnMoveUpClick(Sender: TObject);
begin
  if lvClips.Selected = nil then
    Exit;
    
  var Index := lvClips.Selected.Index;
  
  if (Index > 0) and (Index < FClips.Count) then
  begin
    FClips.Exchange(Index, Index - 1);
    UpdateClipList;
    lvClips.Items[Index - 1].Selected := True;
  end;
end;

procedure TFrameVideoEditor.btnMoveDownClick(Sender: TObject);
begin
  if lvClips.Selected = nil then
    Exit;
    
  var Index := lvClips.Selected.Index;
  
  if (Index >= 0) and (Index < FClips.Count - 1) then
  begin
    FClips.Exchange(Index, Index + 1);
    UpdateClipList;
    lvClips.Items[Index + 1].Selected := True;
  end;
end;

end. 