unit ErrorDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg,
  System.UITypes;

type
  TfrmErrorDialog = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    imgIcon: TImage;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnDetails: TButton;
    pnlClient: TPanel;
    memMessage: TMemo;
    memDetails: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FExpanded: Boolean;
    FOriginalHeight: Integer;
    
    procedure SetExpanded(const Value: Boolean);
    procedure UpdateDetailsButton;
  public
    class procedure ShowError(const Title, Message: string; E: Exception = nil);
    class procedure ShowWarning(const Title, Message: string);
    class procedure ShowInfo(const Title, Message: string);
    
    property Expanded: Boolean read FExpanded write SetExpanded;
  end;

var
  frmErrorDialog: TfrmErrorDialog;

implementation

{$R *.dfm}

procedure TfrmErrorDialog.btnDetailsClick(Sender: TObject);
begin
  Expanded := not Expanded;
end;

procedure TfrmErrorDialog.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmErrorDialog.FormCreate(Sender: TObject);
begin
  FOriginalHeight := Height;
  memDetails.Visible := False;
  FExpanded := False;
  UpdateDetailsButton;
end;

class procedure TfrmErrorDialog.ShowError(const Title, Message: string; E: Exception);
var
  Dialog: TfrmErrorDialog;
  Details: string;
begin
  Dialog := TfrmErrorDialog.Create(Application);
  try
    Dialog.Caption := '错误';
    Dialog.lblTitle.Caption := Title;
    Dialog.memMessage.Text := Message;
    
    // 设置错误图标
    Dialog.imgIcon.Picture.Bitmap.LoadFromResourceName(HInstance, 'ERROR_ICON');
    
    // 设置详细信息
    if Assigned(E) then
    begin
      Details := '异常类型: ' + E.ClassName + #13#10 +
                 '异常消息: ' + E.Message + #13#10 +
                 '堆栈跟踪: ' + #13#10;
                 
      // 如果有堆栈跟踪信息，添加到详细信息中
      if E is Exception then
        Details := Details + E.StackTrace;
        
      Dialog.memDetails.Text := Details;
      Dialog.btnDetails.Visible := True;
    end
    else
      Dialog.btnDetails.Visible := False;
      
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

class procedure TfrmErrorDialog.ShowInfo(const Title, Message: string);
var
  Dialog: TfrmErrorDialog;
begin
  Dialog := TfrmErrorDialog.Create(Application);
  try
    Dialog.Caption := '信息';
    Dialog.lblTitle.Caption := Title;
    Dialog.memMessage.Text := Message;
    
    // 设置信息图标
    Dialog.imgIcon.Picture.Bitmap.LoadFromResourceName(HInstance, 'INFO_ICON');
    
    Dialog.btnDetails.Visible := False;
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

class procedure TfrmErrorDialog.ShowWarning(const Title, Message: string);
var
  Dialog: TfrmErrorDialog;
begin
  Dialog := TfrmErrorDialog.Create(Application);
  try
    Dialog.Caption := '警告';
    Dialog.lblTitle.Caption := Title;
    Dialog.memMessage.Text := Message;
    
    // 设置警告图标
    Dialog.imgIcon.Picture.Bitmap.LoadFromResourceName(HInstance, 'WARNING_ICON');
    
    Dialog.btnDetails.Visible := False;
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

procedure TfrmErrorDialog.SetExpanded(const Value: Boolean);
begin
  if FExpanded <> Value then
  begin
    FExpanded := Value;
    
    if FExpanded then
    begin
      // 展开详细信息
      Height := FOriginalHeight + 200;
      memDetails.Visible := True;
    end
    else
    begin
      // 收起详细信息
      Height := FOriginalHeight;
      memDetails.Visible := False;
    end;
    
    UpdateDetailsButton;
  end;
end;

procedure TfrmErrorDialog.UpdateDetailsButton;
begin
  if FExpanded then
    btnDetails.Caption := '隐藏详细信息 <<'
  else
    btnDetails.Caption := '显示详细信息 >>';
end;

end.
