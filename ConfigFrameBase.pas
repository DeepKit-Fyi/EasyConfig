unit ConfigFrameBase;

interface

uses
  System.SysUtils, System.Classes, System.JSON, JSONHelpers, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  UtilsTypes;

type
  // 基础配置框架类
  TBaseConfigFrame = class(TFrame)
  private
    FJSONObject: TJSONObject;
    FOnModified: TNotifyEvent;
    FModified: Boolean;
    procedure SetModified(const Value: Boolean);
  protected
    procedure CreateControls; virtual;
    procedure EditModified(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; virtual;
    procedure LoadFromJSON; virtual;
    procedure SetJSONObject(const Value: TJSONObject);
    
    property JSONObject: TJSONObject read FJSONObject write SetJSONObject;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property Modified: Boolean read FModified write SetModified;
  end;

implementation

{ TBaseConfigFrame }

constructor TBaseConfigFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJSONObject := nil;
  FModified := False;
end;

destructor TBaseConfigFrame.Destroy;
begin
  inherited;
end;

procedure TBaseConfigFrame.SetJSONObject(const Value: TJSONObject);
begin
  FJSONObject := Value;
  LoadFromJSON;
end;

procedure TBaseConfigFrame.SetModified(const Value: Boolean);
begin
  FModified := Value;
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TBaseConfigFrame.LoadFromJSON;
begin
  // 基类中不实现具体逻辑
end;

procedure TBaseConfigFrame.SaveToJSON;
begin
  // 基类中不实现具体逻辑
end;

procedure TBaseConfigFrame.CreateControls;
begin
  // 基类中不实现具体逻辑
end;

procedure TBaseConfigFrame.EditModified(Sender: TObject);
begin
  // 设置修改标记
  Modified := True;
end;

end. 