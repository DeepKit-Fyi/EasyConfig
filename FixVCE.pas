unit FrameVideoClipEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons,
  System.Generics.Collections, ConfigFrameBase, UtilsTypes, System.UITypes, Vcl.Graphics;

type
  TCaptionInfo = class
  public
    Text: string;
    StartTime: Double;
    Duration: Double;
    FontName: string;
    FontSize: Integer;
    FontColor: string;
    X: Integer;
    Y: Integer;
    constructor Create;
  end;

  TFrameVideoClipEditor = class(TBaseConfigFrame)
    pnlBackground: TPanel;
    lblBackground: TLabel;
    edtBackground: TEdit;
    btnBrowseBackground: TButton;
    pnlAudio: TPanel;
    lblAudio: TLabel;
    edtAudio: TEdit;
    btnBrowseAudio: TButton;
    pnlClipSettings: TPanel;
    lblDuration: TLabel;
    edtDuration: TEdit;
    lblFPS: TLabel;
    edtFPS: TEdit;
    lblCaptions: TLabel;
    lstCaptions: TListBox;
    pnlCaptionButtons: TPanel;
    btnAddCaption: TButton;
    btnEditCaption: TButton;
    btnDeleteCaption: TButton;
    pnlCaptionDetails: TPanel;
    lblCaptionText: TLabel;
    edtCaptionText: TEdit;
    lblStartTime: TLabel;
    edtStartTime: TEdit;
    lblCaptionDuration: TLabel;
    edtCaptionDuration: TEdit;
    lblFontSettings: TLabel;
    edtFontName: TEdit;
    btnSelectFont: TButton;
    lblFontSize: TLabel;
    edtFontSize: TEdit;
    lblFontColor: TLabel;
    pnlFontColor: TPanel;
    lblPosition: TLabel;
    lblCaptionX: TLabel;
    edtCaptionX: TEdit;
    lblCaptionY: TLabel;
    edtCaptionY: TEdit;
    btnSaveCaption: TButton;
    btnCancelCaption: TButton;
    dlgOpenBackground: TOpenDialog;
    dlgOpenAudio: TOpenDialog;
    dlgFont: TFontDialog;
    dlgColor: TColorDialog;
    procedure btnBrowseBackgroundClick(Sender: TObject);
    procedure btnBrowseAudioClick(Sender: TObject);
    procedure btnAddCaptionClick(Sender: TObject);
    procedure btnEditCaptionClick(Sender: TObject);
    procedure btnDeleteCaptionClick(Sender: TObject);
    procedure btnSaveCaptionClick(Sender: TObject);
    procedure btnCancelCaptionClick(Sender: TObject);
    procedure btnSelectFontClick(Sender: TObject);
    procedure pnlFontColorClick(Sender: TObject);
    procedure lstCaptionsClick(Sender: TObject);
  private
    FCaptions: TObjectList<TCaptionInfo>;
    FCurrentCaption: TCaptionInfo;
    
    procedure SetupCaptionPanel(Visible: Boolean);
    procedure ClearCaptionDetails;
    procedure LoadCaptionDetails(Caption: TCaptionInfo);
    procedure UpdateCaptionsList;
    function ValidateCaptionInput: Boolean;
    procedure SaveCaptionDetails;
    function ColorToHex(Color: TColor): string;
    function HexToColor(const Hex: string): TColor;
  protected
    procedure LoadFromJSON; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TCaptionInfo }

constructor TCaptionInfo.Create;
begin
  inherited Create;
  Text := '';
  StartTime := 0.0;
  Duration := 3.0;
  FontName := 'Arial';
  FontSize := 24;
  FontColor := '#FFFFFF';
  X := 10;
  Y := 10;
end;

{ TFrameVideoClipEditor }

constructor TFrameVideoClipEditor.Create(AOwner: TComponent);
begin
  inherited;
  FCaptions := TObjectList<TCaptionInfo>.Create(True);
  FCurrentCaption := nil;
  
  // 鍒濆鍖栧璇濇
  dlgOpenBackground.Filter := '瑙嗛鏂囦欢|*.mp4;*.avi;*.mov;*.wmv|鍥剧墖鏂囦欢|*.jpg;*.jpeg;*.png;*.bmp|鎵€鏈夋枃浠秥*.*';
  dlgOpenAudio.Filter := '闊抽鏂囦欢|*.mp3;*.wav;*.aac;*.m4a|鎵€鏈夋枃浠秥*.*';
  
  // 鍒濆鍖朥I
  pnlFontColor.Color := clWhite;
  SetupCaptionPanel(False);
end;

destructor TFrameVideoClipEditor.Destroy;
begin
  FCaptions.Free;
  inherited;
end;

procedure TFrameVideoClipEditor.LoadFromJSON;
var
  Duration, FPS: Double;
  Background, Audio: string;
  Captions: TJSONArray;
  I: Integer;
  CaptionObj: TJSONObject;
  CaptionInfo: TCaptionInfo;
  FontObj: TJSONObject;
  Value: string;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // 娓呴櫎鐜版湁瀛楀箷
  FCaptions.Clear;
  
  // 鍔犺浇鍩烘湰鍙傛暟
  if JSONObject.TryGetValue<Double>('duration', Duration) then
    edtDuration.Text := FormatFloat('0.00', Duration)
  else
    edtDuration.Text := '10.00';
    
  if JSONObject.TryGetValue<Double>('fps', FPS) then
    edtFPS.Text := FormatFloat('0.00', FPS)
  else
    edtFPS.Text := '30.00';
    
  Background := '';
  JSONObject.TryGetValue('background', Background);
  edtBackground.Text := Background;
    
  Audio := '';
  JSONObject.TryGetValue('audio', Audio);
  edtAudio.Text := Audio;
    
  // 鍔犺浇瀛楀箷鍒楄〃
  if JSONObject.TryGetValue<TJSONArray>('captions', Captions) then
  begin
    for I := 0 to Captions.Count - 1 do
    begin
      if not (Captions.Items[I] is TJSONObject) then
        Continue;
        
      CaptionObj := Captions.Items[I] as TJSONObject;
      CaptionInfo := TCaptionInfo.Create;
      
      // 璁剧疆鍩烘湰灞炴€?
      Value := '';
      CaptionObj.TryGetValue('text', Value);
      CaptionInfo.Text := Value;
      
      Value := '';
      if CaptionObj.TryGetValue('start_time', Value) then
        CaptionInfo.StartTime := StrToFloatDef(Value, 0);
        
      Value := '';
      if CaptionObj.TryGetValue('duration', Value) then
        CaptionInfo.Duration := StrToFloatDef(Value, 3.0);
      
      Value := '';
      if CaptionObj.TryGetValue('x', Value) then
        CaptionInfo.X := StrToIntDef(Value, 10);
        
      Value := '';
      if CaptionObj.TryGetValue('y', Value) then
        CaptionInfo.Y := StrToIntDef(Value, 10);
      
      // 璁剧疆瀛椾綋灞炴€?
      if CaptionObj.TryGetValue<TJSONObject>('font', FontObj) then
      begin
        Value := '';
        FontObj.TryGetValue('name', Value);
        CaptionInfo.FontName := Value;
        
        Value := '';
        if FontObj.TryGetValue('size', Value) then
          CaptionInfo.FontSize := StrToIntDef(Value, 24);
          
        Value := '';
        FontObj.TryGetValue('color', Value);
        CaptionInfo.FontColor := Value;
      end;
      
      // 娣诲姞鍒板垪琛?
      FCaptions.Add(CaptionInfo);
    end;
  end;
  
  // 鏇存柊UI
  UpdateCaptionsList;
end;

procedure TFrameVideoClipEditor.SaveToJSON;
var
  Captions: TJSONArray;
  I: Integer;
  CaptionObj: TJSONObject;
  FontObj: TJSONObject;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  // 淇濆瓨鍩烘湰鍙傛暟
  JSONObject.RemovePair('duration');
  JSONObject.AddPair('duration', TJSONNumber.Create(StrToFloat(edtDuration.Text)));
  
  JSONObject.RemovePair('fps');
  JSONObject.AddPair('fps', TJSONNumber.Create(StrToFloat(edtFPS.Text)));
  
  JSONObject.RemovePair('background');
  JSONObject.AddPair('background', edtBackground.Text);
  
  JSONObject.RemovePair('audio');
  JSONObject.AddPair('audio', edtAudio.Text);
  
  // 鍒涘缓瀛楀箷鏁扮粍
  Captions := TJSONArray.Create;
  for I := 0 to FCaptions.Count - 1 do
  begin
    CaptionObj := TJSONObject.Create;
    
    // 璁剧疆鍩烘湰灞炴€?
    CaptionObj.AddPair('text', FCaptions[I].Text);
    CaptionObj.AddPair('start_time', TJSONNumber.Create(FCaptions[I].StartTime));
    CaptionObj.AddPair('duration', TJSONNumber.Create(FCaptions[I].Duration));
    CaptionObj.AddPair('x', TJSONNumber.Create(FCaptions[I].X));
    CaptionObj.AddPair('y', TJSONNumber.Create(FCaptions[I].Y));
    
    // 鍒涘缓瀛椾綋瀵硅薄
    FontObj := TJSONObject.Create;
    FontObj.AddPair('name', FCaptions[I].FontName);
    FontObj.AddPair('size', TJSONNumber.Create(FCaptions[I].FontSize));
    FontObj.AddPair('color', FCaptions[I].FontColor);
    
    CaptionObj.AddPair('font', FontObj);
    
    Captions.Add(CaptionObj);
  end;
  
  // 鏇存柊JSON瀵硅薄
  JSONObject.RemovePair('captions');
  JSONObject.AddPair('captions', Captions);
  
  // 瑙﹀彂淇敼浜嬩欢
  Modified;
end;

procedure TFrameVideoClipEditor.SetupCaptionPanel(Visible: Boolean);
begin
  pnlCaptionDetails.Visible := Visible;
  
  // 璁剧疆鎸夐挳鐘舵€?
  btnAddCaption.Enabled := not Visible;
  btnEditCaption.Enabled := (not Visible) and (lstCaptions.ItemIndex >= 0);
  btnDeleteCaption.Enabled := (not Visible) and (lstCaptions.ItemIndex >= 0);
end;

procedure TFrameVideoClipEditor.ClearCaptionDetails;
begin
  edtCaptionText.Text := '';
  edtStartTime.Text := '0.00';
  edtCaptionDuration.Text := '3.00';
  edtFontName.Text := 'Arial';
  edtFontSize.Text := '24';
  pnlFontColor.Color := clWhite;
  edtCaptionX.Text := '10';
  edtCaptionY.Text := '10';
end;

procedure TFrameVideoClipEditor.LoadCaptionDetails(Caption: TCaptionInfo);
begin
  if not Assigned(Caption) then
    Exit;
    
  edtCaptionText.Text := Caption.Text;
  edtStartTime.Text := FormatFloat('0.00', Caption.StartTime);
  edtCaptionDuration.Text := FormatFloat('0.00', Caption.Duration);
  edtFontName.Text := Caption.FontName;
  edtFontSize.Text := IntToStr(Caption.FontSize);
  pnlFontColor.Color := HexToColor(Caption.FontColor);
  edtCaptionX.Text := IntToStr(Caption.X);
  edtCaptionY.Text := IntToStr(Caption.Y);
  
  FCurrentCaption := Caption;
end;

procedure TFrameVideoClipEditor.UpdateCaptionsList;
var
  I: Integer;
  SelectedIndex: Integer;
begin
  // 淇濆瓨褰撳墠閫夋嫨
  SelectedIndex := lstCaptions.ItemIndex;
  
  // 鏇存柊鍒楄〃
  lstCaptions.Items.BeginUpdate;
  try
    lstCaptions.Clear;
    for I := 0 to FCaptions.Count - 1 do
      lstCaptions.Items.Add(Format('%s (%.2fs - %.2fs)', 
                           [FCaptions[I].Text, 
                            FCaptions[I].StartTime,
                            FCaptions[I].StartTime + FCaptions[I].Duration]));
  finally
    lstCaptions.Items.EndUpdate;
  end;
  
  // 鎭㈠閫夋嫨
  if (SelectedIndex >= 0) and (SelectedIndex < lstCaptions.Items.Count) then
    lstCaptions.ItemIndex := SelectedIndex;
    
  // 鏇存柊鎸夐挳鐘舵€?
  btnEditCaption.Enabled := lstCaptions.ItemIndex >= 0;
  btnDeleteCaption.Enabled := lstCaptions.ItemIndex >= 0;
end;

function TFrameVideoClipEditor.ValidateCaptionInput: Boolean;
var
  StartTime, Duration: Double;
  X, Y, FontSize: Integer;
begin
  Result := False;
  
  // 楠岃瘉鏂囨湰
  if Trim(edtCaptionText.Text) = '' then
  begin
    ShowMessage('璇疯緭鍏ュ瓧骞曟枃鏈?);
    edtCaptionText.SetFocus;
    Exit;
  end;
  
  // 楠岃瘉寮€濮嬫椂闂?
  if not TryStrToFloat(edtStartTime.Text, StartTime) or (StartTime < 0) then
  begin
    ShowMessage('寮€濮嬫椂闂村繀椤绘槸澶т簬鎴栫瓑浜?鐨勬暟鍊?);
    edtStartTime.SetFocus;
    Exit;
  end;
  
  // 楠岃瘉鏃堕暱
  if not TryStrToFloat(edtCaptionDuration.Text, Duration) or (Duration <= 0) then
  begin
    ShowMessage('鏄剧ず鏃堕暱蹇呴』鏄ぇ浜?鐨勬暟鍊?);
    edtCaptionDuration.SetFocus;
    Exit;
  end;
  
  // 楠岃瘉瀛椾綋澶у皬
  if not TryStrToInt(edtFontSize.Text, FontSize) or (FontSize <= 0) then
  begin
    ShowMessage('瀛椾綋澶у皬蹇呴』鏄ぇ浜?鐨勬暣鏁?);
    edtFontSize.SetFocus;
    Exit;
  end;
  
  // 楠岃瘉X鍧愭爣
  if not TryStrToInt(edtCaptionX.Text, X) then
  begin
    ShowMessage('X鍧愭爣蹇呴』鏄暣鏁?);
    edtCaptionX.SetFocus;
    Exit;
  end;
  
  // 楠岃瘉Y鍧愭爣
  if not TryStrToInt(edtCaptionY.Text, Y) then
  begin
    ShowMessage('Y鍧愭爣蹇呴』鏄暣鏁?);
    edtCaptionY.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

procedure TFrameVideoClipEditor.SaveCaptionDetails;
var
  NewCaption: Boolean;
  Caption: TCaptionInfo;
begin
  if not ValidateCaptionInput then
    Exit;
    
  // 鏄惁鏄柊瀛楀箷
  NewCaption := FCurrentCaption = nil;
  
  // 鍒涘缓瀛楀箷鎴栦娇鐢ㄧ幇鏈夊瓧骞?
  if NewCaption then
    Caption := TCaptionInfo.Create
  else
    Caption := FCurrentCaption;
    
  // 璁剧疆灞炴€?
  Caption.Text := Trim(edtCaptionText.Text);
  Caption.StartTime := StrToFloat(edtStartTime.Text);
  Caption.Duration := StrToFloat(edtCaptionDuration.Text);
  Caption.FontName := edtFontName.Text;
  Caption.FontSize := StrToInt(edtFontSize.Text);
  Caption.FontColor := ColorToHex(pnlFontColor.Color);
  Caption.X := StrToInt(edtCaptionX.Text);
  Caption.Y := StrToInt(edtCaptionY.Text);
  
  // 娣诲姞鍒板垪琛ㄦ垨鏇存柊
  if NewCaption then
    FCaptions.Add(Caption);
    
  // 鏇存柊UI
  UpdateCaptionsList;
  
  // 鍏抽棴闈㈡澘
  SetupCaptionPanel(False);
  
  // 瑙﹀彂淇敼
  Modified;
end;

function TFrameVideoClipEditor.ColorToHex(Color: TColor): string;
begin
  Result := Format('#%.6x', [ColorToRGB(Color) and $FFFFFF]);
end;

function TFrameVideoClipEditor.HexToColor(const Hex: string): TColor;
var
  ColorStr: string;
begin
  ColorStr := Hex;
  if ColorStr.StartsWith('#') then
    ColorStr := ColorStr.Substring(1);
    
  try
    Result := StrToInt('$' + ColorStr);
  except
    Result := clWhite;
  end;
end;

procedure TFrameVideoClipEditor.btnAddCaptionClick(Sender: TObject);
begin
  // 娓呴櫎褰撳墠瀛楀箷
  FCurrentCaption := nil;
  
  // 娓呴櫎璇︽儏闈㈡澘
  ClearCaptionDetails;
  
  // 鏄剧ず璇︽儏闈㈡澘
  SetupCaptionPanel(True);
end;

procedure TFrameVideoClipEditor.btnBrowseAudioClick(Sender: TObject);
begin
  if dlgOpenAudio.Execute then
  begin
    edtAudio.Text := dlgOpenAudio.FileName;
    Modified;
  end;
end;

procedure TFrameVideoClipEditor.btnBrowseBackgroundClick(Sender: TObject);
begin
  if dlgOpenBackground.Execute then
  begin
    edtBackground.Text := dlgOpenBackground.FileName;
    Modified;
  end;
end;

procedure TFrameVideoClipEditor.btnCancelCaptionClick(Sender: TObject);
begin
  SetupCaptionPanel(False);
end;

procedure TFrameVideoClipEditor.btnDeleteCaptionClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := lstCaptions.ItemIndex;
  if (Index < 0) or (Index >= FCaptions.Count) then
    Exit;
    
  if MessageDlg('纭畾鍒犻櫎瀛楀箷 "' + FCaptions[Index].Text + '"?', 
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FCaptions.Delete(Index);
    UpdateCaptionsList;
    Modified;
  end;
end;

procedure TFrameVideoClipEditor.btnEditCaptionClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := lstCaptions.ItemIndex;
  if (Index < 0) or (Index >= FCaptions.Count) then
    Exit;
    
  // 鍔犺浇瀛楀箷璇︽儏
  LoadCaptionDetails(FCaptions[Index]);
  
  // 鏄剧ず璇︽儏闈㈡澘
  SetupCaptionPanel(True);
end;

procedure TFrameVideoClipEditor.btnSaveCaptionClick(Sender: TObject);
begin
  SaveCaptionDetails;
end;

procedure TFrameVideoClipEditor.btnSelectFontClick(Sender: TObject);
begin
  dlgFont.Font.Name := edtFontName.Text;
  dlgFont.Font.Size := StrToIntDef(edtFontSize.Text, 24);
  dlgFont.Font.Color := pnlFontColor.Color;
  
  if dlgFont.Execute then
  begin
    edtFontName.Text := dlgFont.Font.Name;
    edtFontSize.Text := IntToStr(dlgFont.Font.Size);
    pnlFontColor.Color := dlgFont.Font.Color;
  end;
end;

procedure TFrameVideoClipEditor.lstCaptionsClick(Sender: TObject);
begin
  // 鏇存柊鎸夐挳鐘舵€?
  btnEditCaption.Enabled := lstCaptions.ItemIndex >= 0;
  btnDeleteCaption.Enabled := lstCaptions.ItemIndex >= 0;
end;

procedure TFrameVideoClipEditor.pnlFontColorClick(Sender: TObject);
begin
  dlgColor.Color := pnlFontColor.Color;
  if dlgColor.Execute then
    pnlFontColor.Color := dlgColor.Color;
end;

end. 