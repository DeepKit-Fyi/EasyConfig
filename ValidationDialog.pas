unit ValidationDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections, ConfigValidator;

type
  TfrmValidation = class(TForm)
    lvValidation: TListView;
    pnlBottom: TPanel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lvValidationDblClick(Sender: TObject);
  private
    FResults: TList<TValidationResult>;
    FOnSelectProperty: TProc<string, string>;
    
    procedure UpdateList;
  public
    procedure ShowResults(Results: TList<TValidationResult>);
    
    property OnSelectProperty: TProc<string, string> read FOnSelectProperty write FOnSelectProperty;
  end;

var
  frmValidation: TfrmValidation;

implementation

{$R *.dfm}

procedure TfrmValidation.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmValidation.FormCreate(Sender: TObject);
begin
  // 初始化列表视图
  with lvValidation do
  begin
    ViewStyle := vsReport;
    
    // 添加列
    with Columns.Add do
    begin
      Caption := '严重性';
      Width := 80;
    end;
    
    with Columns.Add do
    begin
      Caption := '属性路径';
      Width := 200;
    end;
    
    with Columns.Add do
    begin
      Caption := '属性名称';
      Width := 150;
    end;
    
    with Columns.Add do
    begin
      Caption := '消息';
      Width := 300;
    end;
  end;
end;

procedure TfrmValidation.lvValidationDblClick(Sender: TObject);
var
  Item: TListItem;
begin
  if lvValidation.Selected = nil then Exit;
  
  Item := lvValidation.Selected;
  
  // 触发选择属性事件
  if Assigned(FOnSelectProperty) then
    FOnSelectProperty(Item.SubItems[0], Item.SubItems[1]);
    
  // 关闭对话框
  Close;
end;

procedure TfrmValidation.ShowResults(Results: TList<TValidationResult>);
begin
  FResults := Results;
  UpdateList;
  ShowModal;
end;

procedure TfrmValidation.UpdateList;
var
  i: Integer;
  Result: TValidationResult;
  Item: TListItem;
begin
  // 清空列表
  lvValidation.Items.Clear;
  
  if not Assigned(FResults) then Exit;
  
  // 添加验证结果
  for i := 0 to FResults.Count - 1 do
  begin
    Result := FResults[i];
    
    Item := lvValidation.Items.Add;
    
    // 设置严重性
    case Result.Severity of
      vsInfo: 
        begin
          Item.Caption := '信息';
          Item.ImageIndex := 0;
        end;
      vsWarning: 
        begin
          Item.Caption := '警告';
          Item.ImageIndex := 1;
        end;
      vsError: 
        begin
          Item.Caption := '错误';
          Item.ImageIndex := 2;
        end;
    end;
    
    // 设置属性信息
    Item.SubItems.Add(Result.PropertyPath);
    Item.SubItems.Add(Result.PropertyName);
    Item.SubItems.Add(Result.Message);
  end;
end;

end.
