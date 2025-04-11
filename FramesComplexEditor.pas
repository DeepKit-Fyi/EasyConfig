unit FramesComplexEditor;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
   ConfigFrameBase, FrameFontEditor, FrameAIAPIEditor,
  FrameDBEditor, FrameListEditor, FrameObjectEditor, FrameArrayEditor, UtilsTypes;

// 前向声明
type
  TTextEditorFrame = class(TFrame);
  TIntegerEditorFrame = class(TFrame);
  TFloatEditorFrame = class(TFrame);
  TBooleanEditorFrame = class(TFrame);
  TColorEditorFrame = class(TFrame);
  // 数据库编辑器等类型不需要前向声明，因为已经在uses中引入

// 创建编辑器框架的工厂函数
function CreateEditorFrame(AOwner: TComponent; EditorType: TConfigType): TFrame;

implementation

{ CreateEditorFrame }

function CreateEditorFrame(AOwner: TComponent; EditorType: TConfigType): TFrame;
begin
  case EditorType of
    ctPlain: Result := TTextEditorFrame.Create(AOwner);
    ctInteger: Result := TIntegerEditorFrame.Create(AOwner);
    ctFloat: Result := TFloatEditorFrame.Create(AOwner);
    ctBoolean: Result := TBooleanEditorFrame.Create(AOwner);
    ctColor: Result := TColorEditorFrame.Create(AOwner);
    ctFont: Result := TFontEditorFrame.Create(AOwner);
    ctDatabase: Result := TFrameDBEditor.Create(AOwner);
    ctList: Result := TFrameListEditor.Create(AOwner);
    ctObject: Result := TFrameObjectEditor.Create(AOwner);
    ctAIAPI: Result := TAIAPIEditorFrame.Create(AOwner);
    ctArray: Result := TFrameArrayEditor.Create(AOwner);
  else
    Result := nil;
  end;
end;

end. 