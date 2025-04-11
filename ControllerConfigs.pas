unit ControllerConfigs;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls,
  UtilsTypes, System.JSON;

type
  TControllerConfigsClass = class
  private
    class var FInstance: TControllerConfigsClass;
    
    // 当前选中的复杂属性类型
    FCurrentPropertyType: TComplexPropertyType;
    
    // 当前编辑的JSON对象
    FCurrentJson: TJSONObject;
    
    // 当前编辑的属性名称
    FCurrentPropertyName: string;
    
    // 父容器面板，用于放置编辑器Frame
    FParentPanel: TPanel;
    
    // 当前编辑器Frame
    FCurrentEditorFrame: TFrame;
    
    // 通用属性编辑完成回调
    FOnEditComplete: TNotifyEvent;
    
    // 创建各类型编辑器的方法
    function CreateEditorFrame(PropertyType: TComplexPropertyType): TFrame;
    
    // 加载JSON数据到编辑器
    procedure LoadJsonToEditor(Editor: TFrame; Json: TJSONObject);
    
    // 从编辑器保存数据到JSON
    procedure SaveEditorToJson(Editor: TFrame; var Json: TJSONObject);
    
    constructor Create;
  public
    // 单例访问方法
    class function GetInstance: TControllerConfigsClass;
    
    // 根据Tag显示复杂属性配置界面
    procedure ShowConfigByTag(Tag: Integer);
    
    // 设置父容器面板
    procedure SetParentPanel(Panel: TPanel);
    
    // 编辑复杂属性
    procedure EditComplexProperty(PropertyType: TComplexPropertyType; 
      PropertyName: string; Json: TJSONObject; OnComplete: TNotifyEvent);
    
    // 创建新的复杂属性
    function CreateComplexProperty(PropertyType: TComplexPropertyType; 
      PropertyName: string; OnComplete: TNotifyEvent): TJSONObject;
    
    // 保存当前编辑的属性
    procedure SaveCurrentProperty;
    
    // 取消当前编辑
    procedure CancelCurrentEdit;
    
    // 释放资源
    destructor Destroy; override;
    
    // 属性
    function GetCurrentPropertyType: TComplexPropertyType;
    function GetCurrentJson: TJSONObject;
    function GetCurrentPropertyName: string;
    
    property CurrentPropertyType: TComplexPropertyType read GetCurrentPropertyType;
    property CurrentJson: TJSONObject read GetCurrentJson;
    property CurrentPropertyName: string read GetCurrentPropertyName;
  end;

// 全局访问点
function GetControllerConfigs: TControllerConfigsClass;

implementation

uses
  Vcl.Dialogs, System.Generics.Collections;

var
  // 保存所有创建的Frame，用于后续释放
  FrameList: TList<TFrame>;

function GetControllerConfigs: TControllerConfigsClass;
begin
  Result := TControllerConfigsClass.GetInstance;
end;

{ TControllerConfigsClass }

constructor TControllerConfigsClass.Create;
begin
  inherited;
  FCurrentJson := nil;
  FCurrentEditorFrame := nil;
end;

destructor TControllerConfigsClass.Destroy;
begin
  // 清理资源
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
  
  if Assigned(FCurrentEditorFrame) then
    FCurrentEditorFrame.Free;
  
  inherited;
end;

function TControllerConfigsClass.GetCurrentPropertyType: TComplexPropertyType;
begin
  Result := FCurrentPropertyType;
end;

function TControllerConfigsClass.GetCurrentJson: TJSONObject;
begin
  Result := FCurrentJson;
end;

function TControllerConfigsClass.GetCurrentPropertyName: string;
begin
  Result := FCurrentPropertyName;
end;

class function TControllerConfigsClass.GetInstance: TControllerConfigsClass;
begin
  if not Assigned(FInstance) then
    FInstance := TControllerConfigsClass.Create;
  Result := FInstance;
end;

procedure TControllerConfigsClass.SetParentPanel(Panel: TPanel);
begin
  FParentPanel := Panel;
end;

procedure TControllerConfigsClass.ShowConfigByTag(Tag: Integer);
var
  CPT: TComplexPropertyType;
  PropertyName: string;
  Json: TJSONObject;
begin
  // 转换Tag为复杂属性类型
  CPT := TComplexPropertyType(Tag);
  
  // 获取属性名称（简单实现，实际应用中可能需要用户输入）
  PropertyName := '';
  if not InputQuery('添加复杂属性', '请输入属性名称:', PropertyName) then
    Exit;
  
  if PropertyName = '' then
    Exit;
  
  // 创建新的复杂属性
  Json := CreateComplexProperty(CPT, PropertyName, nil);
  
  // 显示成功消息
  if Assigned(Json) then
    ShowMessage('复杂属性 ' + PropertyName + ' 添加成功！');
end;

function TControllerConfigsClass.CreateEditorFrame(
  PropertyType: TComplexPropertyType): TFrame;
begin
  Result := nil;
  
  // 根据属性类型创建相应的编辑器Frame
  case PropertyType of
    // 优先实现的复杂属性
    cptBgDraw, cptTextOnBg, cptImageOnBg, cptCaptionOnBg:
      begin
        // TODO: 创建背景图元素编辑器Frame
        ShowMessage('背景图元素编辑器尚未实现，请先实现FrameBgDrawEditor');
      end;
    
    cptVideoClip:
      begin
        // TODO: 创建视频片段编辑器Frame
        ShowMessage('视频片段编辑器尚未实现，请先实现FrameVideoClipEditor');
      end;
    
    cptVideo:
      begin
        // TODO: 创建完整视频编辑器Frame
        ShowMessage('完整视频编辑器尚未实现，请先实现FrameVideoEditor');
      end;
    
    // 其他复杂属性
    else
      begin
        ShowMessage('属性类型 ' + IntToStr(Ord(PropertyType)) + ' 的编辑器尚未实现');
      end;
  end;
  
  // 如果创建了Frame，添加到列表中
  if Assigned(Result) and not Assigned(FrameList) then
    FrameList := TList<TFrame>.Create;
  
  if Assigned(Result) and Assigned(FrameList) then
    FrameList.Add(Result);
end;

procedure TControllerConfigsClass.EditComplexProperty(PropertyType: TComplexPropertyType;
  PropertyName: string; Json: TJSONObject; OnComplete: TNotifyEvent);
begin
  // 保存当前状态
  FCurrentPropertyType := PropertyType;
  FCurrentPropertyName := PropertyName;
  
  // 释放之前的JSON对象
  if Assigned(FCurrentJson) then
    FCurrentJson.Free;
  
  // 复制JSON对象
  if Assigned(Json) then
    FCurrentJson := TJSONObject(Json.Clone)
  else
    FCurrentJson := TJSONObject.Create;
  
  // 释放之前的编辑器
  if Assigned(FCurrentEditorFrame) then
  begin
    FCurrentEditorFrame.Free;
    FCurrentEditorFrame := nil;
  end;
  
  // 创建新的编辑器
  FCurrentEditorFrame := CreateEditorFrame(PropertyType);
  
  // 设置回调
  FOnEditComplete := OnComplete;
  
  if Assigned(FCurrentEditorFrame) and Assigned(FParentPanel) then
  begin
    // 设置编辑器Parent
    FCurrentEditorFrame.Parent := FParentPanel;
    FCurrentEditorFrame.Align := alClient;
    
    // 加载数据到编辑器
    LoadJsonToEditor(FCurrentEditorFrame, FCurrentJson);
    
    // 显示编辑器
    FCurrentEditorFrame.Visible := True;
  end;
end;

function TControllerConfigsClass.CreateComplexProperty(PropertyType: TComplexPropertyType;
  PropertyName: string; OnComplete: TNotifyEvent): TJSONObject;
var
  Json: TJSONObject;
begin
  // 创建新的JSON对象
  Json := TJSONObject.Create;
  
  // 根据属性类型填充默认值
  case PropertyType of
    // 优先实现的复杂属性
    cptBgDraw:
      begin
        Json.AddPair('_type', 'etBgDraw');
        Json.AddPair('_id', 'etBgDraw.' + PropertyName);
        Json.AddPair('background', '');
        Json.AddPair('elements', TJSONArray.Create);
      end;
    
    cptTextOnBg:
      begin
        Json.AddPair('_type', 'etTextOnBg');
        Json.AddPair('_id', 'etTextOnBg.' + PropertyName);
        Json.AddPair('text', '文本内容');
        Json.AddPair('x', '0');
        Json.AddPair('y', '0');
        Json.AddPair('font', TJSONObject.Create);
      end;
    
    cptImageOnBg:
      begin
        Json.AddPair('_type', 'etImageOnBg');
        Json.AddPair('_id', 'etImageOnBg.' + PropertyName);
        Json.AddPair('image', '');
        Json.AddPair('x', '0');
        Json.AddPair('y', '0');
        Json.AddPair('scale', '1.0');
      end;
    
    cptCaptionOnBg:
      begin
        Json.AddPair('_type', 'etCaptionOnBg');
        Json.AddPair('_id', 'etCaptionOnBg.' + PropertyName);
        Json.AddPair('text', '字幕文本');
        Json.AddPair('x', '0');
        Json.AddPair('y', '0');
        Json.AddPair('font', TJSONObject.Create);
        Json.AddPair('duration', '5.0');
      end;
    
    cptVideoClip:
      begin
        Json.AddPair('_type', 'etVideoClip');
        Json.AddPair('_id', 'etVideoClip.' + PropertyName);
        Json.AddPair('background', '');
        Json.AddPair('duration', '10.0');
        Json.AddPair('fps', '30');
        Json.AddPair('audio', '');
        Json.AddPair('captions', TJSONArray.Create);
      end;
    
    cptVideo:
      begin
        Json.AddPair('_type', 'etVideo');
        Json.AddPair('_id', 'etVideo.' + PropertyName);
        Json.AddPair('cover', '');
        Json.AddPair('ending', '');
        Json.AddPair('bg_directory', '');
        Json.AddPair('audio_directory', '');
        Json.AddPair('subtitle_file', '');
        Json.AddPair('media_settings', TJSONObject.Create);
        Json.AddPair('clips', TJSONArray.Create);
      end;
    
    // 其他复杂属性
    else
      begin
        Json.AddPair('_type', 'etObject');
        Json.AddPair('_id', 'etObject.' + PropertyName);
        Json.AddPair('name', PropertyName);
      end;
  end;
  
  // 编辑属性
  EditComplexProperty(PropertyType, PropertyName, Json, OnComplete);
  
  Result := Json;
end;

procedure TControllerConfigsClass.LoadJsonToEditor(Editor: TFrame; Json: TJSONObject);
begin
  // 子类需要实现
  ShowMessage('LoadJsonToEditor 需要具体编辑器类型实现');
end;

procedure TControllerConfigsClass.SaveEditorToJson(Editor: TFrame; var Json: TJSONObject);
begin
  // 子类需要实现
  ShowMessage('SaveEditorToJson 需要具体编辑器类型实现');
end;

procedure TControllerConfigsClass.SaveCurrentProperty;
begin
  // 保存当前属性
  if Assigned(FCurrentEditorFrame) and Assigned(FCurrentJson) then
  begin
    SaveEditorToJson(FCurrentEditorFrame, FCurrentJson);
    
    // 调用回调
    if Assigned(FOnEditComplete) then
      FOnEditComplete(Self);
  end;
end;

procedure TControllerConfigsClass.CancelCurrentEdit;
begin
  // 取消当前编辑
  if Assigned(FCurrentEditorFrame) then
  begin
    FCurrentEditorFrame.Visible := False;
    
    // 如果需要，可以在这里释放资源
  end;
end;

initialization

finalization
  // 清理单例实例
  if Assigned(TControllerConfigsClass.FInstance) then
    TControllerConfigsClass.FInstance.Free;
  
  // 清理所有创建的Frame
  if Assigned(FrameList) then
  begin
    for var Frame in FrameList do
      Frame.Free;
    FrameList.Free;
  end;

end. 