unit FrameConfigEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigIntf, ConfigTypes, ConfigFrameBase, System.UITypes, System.Generics.Collections;

type
  TframeConfigEditor = class(TFrame, IConfigEditor)
    pnlMain: TPanel;
    tabControl: TTabControl;
    pnlEditor: TPanel;
    ButtonPanel: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tabControlChange(Sender: TObject);
  private
    { Private declarations }
    FINIConfig: IINIConfig;
    FJSONConfig: IJSONConfig;
    FCurrentSection: string;
    FCurrentKey: string;
    FCurrentEditor: TFrame;
    FModified: Boolean;
    function CreateEditorForType(EditorType: TConfigType): TFrame;
    procedure UpdateButtonState;
    procedure HandleEditorModified(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    // IConfigEditor接口实现
    procedure SetINIConfig(const Value: IINIConfig);
    procedure SetJSONConfig(const Value: IJSONConfig);
    procedure EditValue(const Section, Key: string);
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    property Modified: Boolean read GetModified write SetModified;
  end;

implementation

uses
  FramesComplexEditor;

{$R *.dfm}

{ TframeConfigEditor }

constructor TframeConfigEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModified := False;
end;

destructor TframeConfigEditor.Destroy;
begin
  if Assigned(FCurrentEditor) then
    FCurrentEditor.Free;
  inherited;
end;

procedure TframeConfigEditor.btnCancelClick(Sender: TObject);
begin
  if Assigned(FCurrentEditor) then
  begin
    FCurrentEditor.Free;
    FCurrentEditor := nil;
  end;
  FModified := False;
  UpdateButtonState;
end;

procedure TframeConfigEditor.btnSaveClick(Sender: TObject);
var
  BaseFrame: TBaseConfigFrame;
  ConfigType: TConfigType;
  JsonValue: TJSONValue;
begin
  if Assigned(FCurrentEditor) and 
     (FCurrentEditor is TBaseConfigFrame) and
     Assigned(FINIConfig) and 
     Assigned(FJSONConfig) then
  begin
    BaseFrame := TBaseConfigFrame(FCurrentEditor);
    
    // 保存到JSON配置
    BaseFrame.SaveToJSON;
    
    // 获取配置类型
    if BaseFrame.JSONObject.FindValue('_type') <> nil then
    begin
      ConfigType := StringToConfigType(BaseFrame.JSONObject.GetValue('_type').Value);
      
      // 保存到INI配置
      case ConfigType of
        ctPlain:
          if BaseFrame.JSONObject.FindValue('value') <> nil then
          begin
            JsonValue := BaseFrame.JSONObject.GetValue('value');
            if JsonValue is TJSONString then
              FINIConfig.WriteString(FCurrentSection, FCurrentKey, TJSONString(JsonValue).Value);
          end;
          
        ctInteger:
          if BaseFrame.JSONObject.FindValue('value') <> nil then
          begin
            JsonValue := BaseFrame.JSONObject.GetValue('value');
            if JsonValue is TJSONNumber then
              FINIConfig.WriteInteger(FCurrentSection, FCurrentKey, TJSONNumber(JsonValue).AsInt);
          end;
          
        ctFloat:
          if BaseFrame.JSONObject.FindValue('value') <> nil then
          begin
            JsonValue := BaseFrame.JSONObject.GetValue('value');
            if JsonValue is TJSONNumber then
              FINIConfig.WriteFloat(FCurrentSection, FCurrentKey, TJSONNumber(JsonValue).AsDouble);
          end;
          
        ctBoolean:
          if BaseFrame.JSONObject.FindValue('value') <> nil then
          begin
            JsonValue := BaseFrame.JSONObject.GetValue('value');
            if JsonValue is TJSONBool then
              FINIConfig.WriteBool(FCurrentSection, FCurrentKey, TJSONBool(JsonValue).AsBoolean);
          end;
          
        ctColor:
          if BaseFrame.JSONObject.FindValue('value') <> nil then
          begin
            JsonValue := BaseFrame.JSONObject.GetValue('value');
            if JsonValue is TJSONString then
              FINIConfig.WriteString(FCurrentSection, FCurrentKey, TJSONString(JsonValue).Value);
          end;
          
        ctFont, ctAIAPI, ctDatabase, ctList, ctObject, ctArray:
          begin
            // 复杂类型，直接使用保存的JSON字符串
            FINIConfig.WriteString(FCurrentSection, FCurrentKey, 
              BaseFrame.JSONObject.ToString);
          end;
      end;
    end;
    
    FModified := False;
    UpdateButtonState;
  end;
end;

function TframeConfigEditor.CreateEditorForType(EditorType: TConfigType): TFrame;
var
  BaseFrame: TBaseConfigFrame;
begin
  Result := CreateEditorFrame(Self, EditorType);
  if (Result is TBaseConfigFrame) and Assigned(FJSONConfig) then
  begin
    BaseFrame := TBaseConfigFrame(Result);
    BaseFrame.JSONObject := FJSONConfig.GetJSONObject(FCurrentSection, FCurrentKey);
    BaseFrame.OnModified := HandleEditorModified;
    // 调用 LoadFromJSON 方法
    // 由于LoadFromJSON是protected，所以不能直接调用
    // 我们可以通过设置JSONObject间接触发LoadFromJSON
    BaseFrame.JSONObject := BaseFrame.JSONObject;
  end;
end;

procedure TframeConfigEditor.HandleEditorModified(Sender: TObject);
begin
  FModified := True;
  UpdateButtonState;
end;

procedure TframeConfigEditor.EditValue(const Section, Key: string);
var
  EditorType: TConfigType;
begin
  FCurrentSection := Section;
  FCurrentKey := Key;
  
  // 清除当前编辑器
  if Assigned(FCurrentEditor) then
  begin
    FCurrentEditor.Free;
    FCurrentEditor := nil;
  end;
  
  if not Assigned(FJSONConfig) then
  begin
    ShowMessage('JSON配置接口未初始化');
    Exit;
  end;
    
  // 获取配置类型
  EditorType := FJSONConfig.GetConfigType(Section, Key);
  
  // 创建相应的编辑器
  FCurrentEditor := CreateEditorForType(EditorType);
  
  if Assigned(FCurrentEditor) then
  begin
    FCurrentEditor.Parent := pnlEditor;
    FCurrentEditor.Align := alClient;
  end;
  
  FModified := False;
  UpdateButtonState;
end;

function TframeConfigEditor.GetModified: Boolean;
begin
  Result := FModified;
end;

procedure TframeConfigEditor.SetINIConfig(const Value: IINIConfig);
begin
  FINIConfig := Value;
end;

procedure TframeConfigEditor.SetJSONConfig(const Value: IJSONConfig);
begin
  FJSONConfig := Value;
end;

procedure TframeConfigEditor.SetModified(const Value: Boolean);
begin
  FModified := Value;
  UpdateButtonState;
end;

procedure TframeConfigEditor.tabControlChange(Sender: TObject);
begin
  // 根据当前选择的标签页更新编辑器
  case tabControl.TabIndex of
    0: begin
         // 编辑器视图
         if Assigned(FCurrentEditor) then
           FCurrentEditor.Visible := True;
       end;
    1: begin
         // 原始数据视图 (JSON)
         if Assigned(FCurrentEditor) then
           FCurrentEditor.Visible := False;
         // 可以添加一个文本编辑器显示JSON数据
       end;
  end;
end;

procedure TframeConfigEditor.UpdateButtonState;
begin
  // 根据修改状态更新按钮状态
  btnSave.Enabled := FModified and Assigned(FCurrentEditor);
  btnCancel.Enabled := Assigned(FCurrentEditor);
end;

{$IFDEF DESIGNTIME}
procedure Register;
begin
  RegisterComponents('Custom', [TframeConfigEditor]);
end;
{$ENDIF}

{$IFDEF DESIGNTIME}
initialization
  // 不要在运行时调用Register
{$ENDIF}

end. 