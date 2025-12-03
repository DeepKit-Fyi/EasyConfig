unit VirtualPropertyEditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VirtualTrees, VirtualTrees.Header, VirtualTrees.Types, ConfigItemsUnit;

type
  TVirtualPropertyEditor = class
  private
    FVirtualStringTree: TVirtualStringTree;
    FConfigItem: IConfigItem;
  public
    constructor Create(AOwner: TComponent; AConfigItem: IConfigItem);
    destructor Destroy; override;
    procedure Initialize;
    procedure UpdateProperties;
  end;

implementation

constructor TVirtualPropertyEditor.Create(AOwner: TComponent; AConfigItem: IConfigItem);
begin
  FConfigItem := AConfigItem;
  FVirtualStringTree := TVirtualStringTree.Create(AOwner);
  FVirtualStringTree.NodeDataSize := SizeOf(Pointer);
  FVirtualStringTree.Header.Options := [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible];
  FVirtualStringTree.Header.AutoSizeIndex := 1;
  FVirtualStringTree.Header.DefaultHeight := 20;
  FVirtualStringTree.Header.Height := 20;
  FVirtualStringTree.TreeOptions.PaintOptions := FVirtualStringTree.TreeOptions.PaintOptions + [toShowHorzGridLines, toShowVertGridLines];
  FVirtualStringTree.TreeOptions.SelectionOptions := FVirtualStringTree.TreeOptions.SelectionOptions + [toFullRowSelect];
  FVirtualStringTree.TreeOptions.MiscOptions := FVirtualStringTree.TreeOptions.MiscOptions + [toEditable, toGridExtensions];
  Initialize;
end;

destructor TVirtualPropertyEditor.Destroy;
begin
  FVirtualStringTree.Free;
  inherited;
end;

procedure TVirtualPropertyEditor.Initialize;
begin
  with FVirtualStringTree.Header.Columns.Add do
  begin
    Text := '属性名称';
    Width := 150;
    Options := [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring];
  end;
  with FVirtualStringTree.Header.Columns.Add do
  begin
    Text := '属性值';
    Width := 200;
    Options := [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring];
  end;
  UpdateProperties;
end;

procedure TVirtualPropertyEditor.UpdateProperties;
begin
  // 待后实现属性更新逻辑
end;

end.
