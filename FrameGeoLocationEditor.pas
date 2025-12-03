unit FrameGeoLocationEditor;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, System.JSON, ConfigFrameBase, JSONHelpers;

type
  TFrameGeoLocationEditor = class(TBaseConfigFrame)
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromJSON; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

constructor TFrameGeoLocationEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFrameGeoLocationEditor.LoadFromJSON;
begin
  // 空实现
end;

procedure TFrameGeoLocationEditor.SaveToJSON;
begin
  // 空实现
end;

end.
