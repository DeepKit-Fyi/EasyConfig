unit ConfigFrameBase;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Vcl.Controls, Vcl.Forms, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  ConfigTypes;

type
  // 基础配置框架类
  TBaseConfigFrame = class(TFrame)
  private
    FJSONObject: TJSONObject;
    FOnModified: TNotifyEvent;
    FModified: Boolean;
    procedure SetJSONObject(const Value: TJSONObject);
    procedure SetModified(const Value: Boolean);
  protected
    procedure LoadFromJSON; virtual;
    procedure CreateControls; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; virtual;
    
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

end. 