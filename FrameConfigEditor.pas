unit FrameConfigEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigIntf, ConfigFrameBase, System.UITypes, System.Generics.Collections, UtilsTypes;

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
    
    // IConfigEditor�ӿ�ʵ��
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
    
    // ���浽JSON����
    BaseFrame.SaveToJSON;
    
    // ��ȡ��������
    if BaseFrame.JSONObject.FindValue('_type') <> nil then
    begin
      ConfigType := StringToConfigType(BaseFrame.JSONObject.GetValue('_type').Value);
      
      // ���浽INI����
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
            // �������ͣ�ֱ��ʹ�ñ����JSON�ַ���
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
    // ���� LoadFromJSON ����
    // ����LoadFromJSON��protected�����Բ���ֱ�ӵ���
    // ���ǿ���ͨ������JSONObject��Ӵ���LoadFromJSON
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
  
  // �����ǰ�༭��
  if Assigned(FCurrentEditor) then
  begin
    FCurrentEditor.Free;
    FCurrentEditor := nil;
  end;
  
  if not Assigned(FJSONConfig) then
  begin
    ShowMessage('JSON���ýӿ�δ��ʼ��');
    Exit;
  end;
    
  // ��ȡ��������
  EditorType := FJSONConfig.GetConfigType(Section, Key);
  
  // ������Ӧ�ı༭��
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
  // ���ݵ�ǰѡ��ı�ǩҳ���±༭��
  case tabControl.TabIndex of
    0: begin
         // �༭����ͼ
         if Assigned(FCurrentEditor) then
           FCurrentEditor.Visible := True;
       end;
    1: begin
         // ԭʼ������ͼ (JSON)
         if Assigned(FCurrentEditor) then
           FCurrentEditor.Visible := False;
         // ��������һ���ı��༭����ʾJSON����
       end;
  end;
end;

procedure TframeConfigEditor.UpdateButtonState;
begin
  // �����޸�״̬���°�ť״̬
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
  // ��Ҫ������ʱ����Register
{$ENDIF}

end. 
