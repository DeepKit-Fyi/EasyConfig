unit FrameVideoClipEditorFMX;
{*******************************************************************************
  视频片段配置编辑器 Frame (FMX)
  - 支持源文件选择
  - 支持起止时间设置
  - 支持效果设置
*******************************************************************************}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.EditBox,
  FMX.SpinBox, FMX.NumberBox,
  ConfigFrameBaseFMX, UtilsTypesFMX;

type
  TFrameVideoClipEditorFMX = class(TBaseConfigFrameFMX)
    layMain: TLayout;
    grpSource: TGroupBox;
    laySource: TLayout;
    lblSource: TLabel;
    edtSource: TEdit;
    btnBrowse: TButton;
    grpTime: TGroupBox;
    layStartTime: TLayout;
    lblStartTime: TLabel;
    spnStartTime: TSpinBox;
    lblStartUnit: TLabel;
    layEndTime: TLayout;
    lblEndTime: TLabel;
    spnEndTime: TSpinBox;
    lblEndUnit: TLabel;
    layDuration: TLayout;
    lblDuration: TLabel;
    lblDurationValue: TLabel;
    grpEffects: TGroupBox;
    layVolume: TLayout;
    lblVolume: TLabel;
    spnVolume: TSpinBox;
    lblVolumePercent: TLabel;
    layFadeIn: TLayout;
    lblFadeIn: TLabel;
    spnFadeIn: TSpinBox;
    lblFadeInUnit: TLabel;
    layFadeOut: TLayout;
    lblFadeOut: TLabel;
    spnFadeOut: TSpinBox;
    lblFadeOutUnit: TLabel;
    chkLoop: TCheckBox;
    procedure btnBrowseClick(Sender: TObject);
    procedure spnTimeChange(Sender: TObject);
    procedure edtChange(Sender: TObject);
  private
    procedure UpdateDuration;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
    function GetEditorType: TEditorType; override;
  end;

implementation

{$R *.fmx}

{ TFrameVideoClipEditorFMX }

constructor TFrameVideoClipEditorFMX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // 初始化默认值
  spnStartTime.Value := 0;
  spnEndTime.Value := 0;
  spnVolume.Value := 100;
  spnFadeIn.Value := 0;
  spnFadeOut.Value := 0;
  chkLoop.IsChecked := False;

  UpdateDuration;
end;

procedure TFrameVideoClipEditorFMX.LoadFromJSON;
var
  EffectsObj: TJSONObject;
begin
  if not Assigned(JSONObject) then Exit;

  BeginUpdate;
  try
    // 源文件
    edtSource.Text := GetJSONString('source', '');

    // 时间
    spnStartTime.Value := GetJSONFloat('start_time', 0);
    spnEndTime.Value := GetJSONFloat('end_time', 0);

    // 效果
    if JSONObject.TryGetValue<TJSONObject>('effects', EffectsObj) then
    begin
      spnVolume.Value := ConfigFrameBaseFMX.GetJSONFloat(EffectsObj, 'volume', 100);
      spnFadeIn.Value := ConfigFrameBaseFMX.GetJSONFloat(EffectsObj, 'fade_in', 0);
      spnFadeOut.Value := ConfigFrameBaseFMX.GetJSONFloat(EffectsObj, 'fade_out', 0);
      chkLoop.IsChecked := ConfigFrameBaseFMX.GetJSONBool(EffectsObj, 'loop', False);
    end
    else
    begin
      spnVolume.Value := 100;
      spnFadeIn.Value := 0;
      spnFadeOut.Value := 0;
      chkLoop.IsChecked := False;
    end;

    UpdateDuration;

  finally
    EndUpdate;
  end;
end;

procedure TFrameVideoClipEditorFMX.SaveToJSON;
var
  EffectsObj: TJSONObject;
begin
  SetJSONString('_type', 'VideoClip');

  // 源文件
  SetJSONString('source', edtSource.Text);

  // 时间
  SetJSONFloat('start_time', spnStartTime.Value);
  SetJSONFloat('end_time', spnEndTime.Value);

  // 效果
  EffectsObj := TJSONObject.Create;
  EffectsObj.AddPair('volume', TJSONNumber.Create(spnVolume.Value));
  EffectsObj.AddPair('fade_in', TJSONNumber.Create(spnFadeIn.Value));
  EffectsObj.AddPair('fade_out', TJSONNumber.Create(spnFadeOut.Value));
  EffectsObj.AddPair('loop', TJSONBool.Create(chkLoop.IsChecked));
  
  if JSONObject.GetValue('effects') <> nil then
    JSONObject.RemovePair('effects');
  JSONObject.AddPair('effects', EffectsObj);
end;

function TFrameVideoClipEditorFMX.GetEditorType: TEditorType;
begin
  Result := etVideoClip;
end;

procedure TFrameVideoClipEditorFMX.UpdateDuration;
var
  Duration: Double;
begin
  Duration := spnEndTime.Value - spnStartTime.Value;
  if Duration < 0 then
    Duration := 0;

  lblDurationValue.Text := Format('%.2f 秒', [Duration]);
end;

procedure TFrameVideoClipEditorFMX.btnBrowseClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Filter := '视频文件 (*.mp4;*.avi;*.mkv;*.mov)|*.mp4;*.avi;*.mkv;*.mov|所有文件 (*.*)|*.*';
    if edtSource.Text <> '' then
      Dlg.FileName := edtSource.Text;
    if Dlg.Execute then
    begin
      edtSource.Text := Dlg.FileName;
      DoModified(Sender);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TFrameVideoClipEditorFMX.spnTimeChange(Sender: TObject);
begin
  UpdateDuration;
  DoModified(Sender);
end;

procedure TFrameVideoClipEditorFMX.edtChange(Sender: TObject);
begin
  DoModified(Sender);
end;

end.
