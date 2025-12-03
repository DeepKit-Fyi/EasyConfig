unit FrameDateTimeRangeEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.JSON, System.DateUtils, ConfigFrameBase, UtilsTypes, JSONHelpers;

type
  // 时间范围编辑器Frame
  TFrameDateTimeRangeEditor = class(TBaseConfigFrame)
    pnlMain: TPanel;
    grpDateTimeRange: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    lblName: TLabel;
    lblDescription: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    edtName: TEdit;
    memDescription: TMemo;
    chkUseTime: TCheckBox;
    lblDuration: TLabel;
    edtDuration: TEdit;
    btnCalcDuration: TButton;
    chkRepeat: TCheckBox;
    cbbRepeatType: TComboBox;
    lblRepeatInterval: TLabel;
    edtRepeatInterval: TEdit;
    chkEnableNotification: TCheckBox;
    lblNotifyBefore: TLabel;
    edtNotifyBefore: TEdit;
    cbbNotifyUnit: TComboBox;
    pnlButtons: TPanel;
    btnUpdate: TButton;
    btnCancel: TButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure dtpStartDateChange(Sender: TObject);
    procedure dtpEndDateChange(Sender: TObject);
    procedure btnCalcDurationClick(Sender: TObject);
    procedure chkUseTimeClick(Sender: TObject);
    procedure chkRepeatClick(Sender: TObject);
    procedure chkEnableNotificationClick(Sender: TObject);
  private
    procedure InitControls;
    procedure UpdateDurationDisplay;
    procedure UpdateRepeatControls;
    procedure UpdateNotificationControls;
  protected
    procedure LoadFromJSON; override;
    procedure CreateControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TFrameDateTimeRangeEditor }

constructor TFrameDateTimeRangeEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  InitControls;
end;

destructor TFrameDateTimeRangeEditor.Destroy;
begin
  inherited;
end;

procedure TFrameDateTimeRangeEditor.CreateControls;
begin
  inherited;

  // 如果控件已在DFM文件中设计好，则不需要创建     
  // 如果需要动态创建控件，可以在这里添加代码
end;

procedure TFrameDateTimeRangeEditor.InitControls;
begin
  // 初始化重复类型下拉框
  cbbRepeatType.Items.Clear;
  cbbRepeatType.Items.Add('每天');
  cbbRepeatType.Items.Add('每周');
  cbbRepeatType.Items.Add('每月');
  cbbRepeatType.Items.Add('每年');
  cbbRepeatType.ItemIndex := 0;

  // 初始化通知单位下拉框
  cbbNotifyUnit.Items.Clear;
  cbbNotifyUnit.Items.Add('Minutes');
  cbbNotifyUnit.Items.Add('Hours');
  cbbNotifyUnit.Items.Add('Days');
  cbbNotifyUnit.ItemIndex := 0;

  // 设置默认值
  dtpStartDate.DateTime := Now;
  dtpEndDate.DateTime := Now + 1;

  // 初始化控件状态
  UpdateRepeatControls;
  UpdateNotificationControls;

  // 计算并显示持续时间
  UpdateDurationDisplay;
end;

procedure TFrameDateTimeRangeEditor.LoadFromJSON;
var
  Value: TJSONValue;
  StrValue: string;
  BoolValue: Boolean;
  IntValue: Integer;
begin
  if not Assigned(JSONObject) then
    Exit;

  // 加载基本属性
  Value := JSONObject.GetValue('name');
  if Assigned(Value) then
    edtName.Text := Value.Value;

  Value := JSONObject.GetValue('description');
  if Assigned(Value) then
    memDescription.Text := Value.Value;

  // 加载日期时间设置
  var DateFormat := 'yyyy-mm-dd"T"hh:nn:ss';
  var StartDateStr, EndDateStr: string;

  Value := JSONObject.GetValue('start_date');
  if Assigned(Value) then
    dtpStartDate.DateTime := StrToDateTimeDef(Value.Value, Now);

  Value := JSONObject.GetValue('end_date');
  if Assigned(Value) then
    dtpEndDate.DateTime := StrToDateTimeDef(Value.Value, Now + 1);

  Value := JSONObject.GetValue('use_time');
  if Assigned(Value) then
    chkUseTime.Checked := (Value as TJSONBool).AsBoolean;

  // 加载重复设置
  Value := JSONObject.GetValue('repeat');
  if Assigned(Value) then
    chkRepeat.Checked := (Value as TJSONBool).AsBoolean;

  Value := JSONObject.GetValue('repeat_type');
  if Assigned(Value) then
    cbbRepeatType.ItemIndex := (Value as TJSONNumber).AsInt;

  Value := JSONObject.GetValue('repeat_interval');
  if Assigned(Value) then
    edtRepeatInterval.Text := IntToStr((Value as TJSONNumber).AsInt);

  // 加载通知设置
  Value := JSONObject.GetValue('enable_notification');
  if Assigned(Value) then
    chkEnableNotification.Checked := (Value as TJSONBool).AsBoolean;

  Value := JSONObject.GetValue('notify_before');
  if Assigned(Value) then
    edtNotifyBefore.Text := IntToStr((Value as TJSONNumber).AsInt);

  Value := JSONObject.GetValue('notify_unit');
  if Assigned(Value) then
  begin
    StrValue := Value.Value;
    // 查找并设置通知单位
    for var I := 0 to cbbNotifyUnit.Items.Count - 1 do
    begin
      if SameText(cbbNotifyUnit.Items[I], StrValue) then
      begin
        cbbNotifyUnit.ItemIndex := I;
        Break;
      end;
    end;
  end;

  // 更新控件状态
  chkUseTimeClick(nil);
  chkRepeatClick(nil);
  chkEnableNotificationClick(nil);
  UpdateDurationDisplay;
end;

procedure TFrameDateTimeRangeEditor.SaveToJSON;
var
  JObj: TJSONObject;
  JNotify: TJSONObject;
  JRepeat: TJSONObject;
begin
  if not Assigned(JSONObject) then Exit;

  // 保存基本信息
  JSONObject.RemovePair('name');
  JSONObject.AddPair('name', edtName.Text);

  JSONObject.RemovePair('description');
  JSONObject.AddPair('description', memDescription.Text);

  // 保存日期范围
  JSONObject.RemovePair('start_date');
  JSONObject.AddPair('start_date', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dtpStartDate.DateTime));

  JSONObject.RemovePair('end_date');
  JSONObject.AddPair('end_date', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dtpEndDate.DateTime));

  // 保存通知设置
  JSONObject.RemovePair('enable_notification');
  if chkEnableNotification.Checked then
  begin
    JNotify := TJSONObject.Create;
    JNotify.AddPair('enabled', TJSONBool.Create(true));
    JNotify.AddPair('beforeMinutes', IntToStr(StrToIntDef(edtNotifyBefore.Text, 0)));
    JNotify.AddPair('unit', cbbNotifyUnit.Items[cbbNotifyUnit.ItemIndex]);
    JSONObject.AddPair('enable_notification', JNotify);
  end
  else
  begin
    JNotify := TJSONObject.Create;
    JNotify.AddPair('enabled', TJSONBool.Create(false));
    JSONObject.AddPair('enable_notification', JNotify);
  end;

  // 保存重复设置
  JSONObject.RemovePair('repeat');
  if chkRepeat.Checked then
  begin
    JRepeat := TJSONObject.Create;
    JRepeat.AddPair('enabled', TJSONBool.Create(true));
    JRepeat.AddPair('type', cbbRepeatType.Items[cbbRepeatType.ItemIndex]);
    JRepeat.AddPair('interval', IntToStr(StrToIntDef(edtRepeatInterval.Text, 1)));
    JSONObject.AddPair('repeat', JRepeat);
  end
  else
  begin
    JRepeat := TJSONObject.Create;
    JRepeat.AddPair('enabled', TJSONBool.Create(false));
    JSONObject.AddPair('repeat', JRepeat);
  end;

  // 设置修改标志为false
  Modified := False;
end;

procedure TFrameDateTimeRangeEditor.UpdateDurationDisplay;
var
  Duration: Int64;
  DurationStr: string;
  Days, Hours, Minutes, Seconds: Integer;
begin
  try
    // 计算两个日期之间的秒数
    Duration := SecondsBetween(dtpStartDate.DateTime, dtpEndDate.DateTime);

    if Duration < 0 then
    begin
      edtDuration.Text := 'End date must be after start date';
      Exit;
    end;

    // 转换为天、小时、分钟和秒
    Days := Duration div 86400;
    Duration := Duration mod 86400;
    Hours := Duration div 3600;
    Duration := Duration mod 3600;
    Minutes := Duration div 60;
    Seconds := Duration mod 60;

    // 格式化持续时间字符串
    if Days > 0 then
      DurationStr := Format('%d days %d hours %d minutes', [Days, Hours, Minutes])
    else if Hours > 0 then
      DurationStr := Format('%d hours %d minutes', [Hours, Minutes])
    else
      DurationStr := Format('%d minutes %d seconds', [Minutes, Seconds]);

    // 更新显示
    edtDuration.Text := DurationStr;
  except
    on E: Exception do
      edtDuration.Text := 'Error: ' + E.Message;
  end;
end;

procedure TFrameDateTimeRangeEditor.UpdateNotificationControls;
begin
  lblNotifyBefore.Enabled := chkEnableNotification.Checked;
  edtNotifyBefore.Enabled := chkEnableNotification.Checked;
  cbbNotifyUnit.Enabled := chkEnableNotification.Checked;
end;

procedure TFrameDateTimeRangeEditor.UpdateRepeatControls;
begin
  cbbRepeatType.Enabled := chkRepeat.Checked;
  lblRepeatInterval.Enabled := chkRepeat.Checked;
  edtRepeatInterval.Enabled := chkRepeat.Checked;
end;

procedure TFrameDateTimeRangeEditor.btnCalcDurationClick(Sender: TObject);
begin
  UpdateDurationDisplay;
end;

procedure TFrameDateTimeRangeEditor.btnCancelClick(Sender: TObject);
begin
  if Assigned(Parent) and (Parent is TPanel) then
    TPanel(Parent).Visible := False;
end;

procedure TFrameDateTimeRangeEditor.btnUpdateClick(Sender: TObject);
begin
  // 验证输入
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('Please enter a name');
    edtName.SetFocus;
    Exit;
  end;

  if dtpStartDate.DateTime > dtpEndDate.DateTime then
  begin
    ShowMessage('Start date must be before end date');
    dtpStartDate.SetFocus;
    Exit;
  end;

  // 保存数据
  SaveToJSON;

  // 设置修改标志
  Modified := True;

  // 通知修改
  if Assigned(OnModified) then
    OnModified(Self);
end;

procedure TFrameDateTimeRangeEditor.chkEnableNotificationClick(Sender: TObject);
begin
  UpdateNotificationControls;
  Modified := True;
end;

procedure TFrameDateTimeRangeEditor.chkRepeatClick(Sender: TObject);
begin
  UpdateRepeatControls;
  Modified := True;
end;

procedure TFrameDateTimeRangeEditor.chkUseTimeClick(Sender: TObject);
begin
  dtpStartDate.Kind := TDateTimeKind.dtkDate;
  dtpEndDate.Kind := TDateTimeKind.dtkDate;

  if chkUseTime.Checked then
  begin
    dtpStartDate.Format := 'yyyy-MM-dd HH:mm:ss';
    dtpEndDate.Format := 'yyyy-MM-dd HH:mm:ss';
  end
  else
  begin
    dtpStartDate.Format := 'yyyy-MM-dd';
    dtpEndDate.Format := 'yyyy-MM-dd';
  end;

  Modified := True;
end;

procedure TFrameDateTimeRangeEditor.dtpEndDateChange(Sender: TObject);
begin
  UpdateDurationDisplay;
  Modified := True;
end;

procedure TFrameDateTimeRangeEditor.dtpStartDateChange(Sender: TObject);
begin
  UpdateDurationDisplay;
  Modified := True;
end;

end. 