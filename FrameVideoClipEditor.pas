unit FrameVideoClipEditor;

interface

uses
  System.SysUtils, System.Classes, JSONHelpers, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes, Vcl.Graphics, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Buttons, System.Generics.Collections, ConfigFrameBase, UtilsTypes;

type
  TCaptionInfo = class
  public
    Text: string;
    constructor Create;
  end;

  TFrameVideoClipEditor = class(TBaseConfigFrame)
    pnlBackground: TPanel;
    lblBackground: TLabel;
    edtBackground: TEdit;
    btnBrowseBackground: TButton;
    pnlAudio: TPanel;
    lblAudio: TLabel;
    edtAudio: TEdit;
    btnBrowseAudio: TButton;
    pnlClipSettings: TPanel;
    lblDuration: TLabel;
    edtDuration: TEdit;
    lblFPS: TLabel;
    edtFPS: TEdit;
    lblCaptions: TLabel;
    lstCaptions: TListBox;
    pnlCaptionButtons: TPanel;
    btnAddCaption: TButton;
    btnEditCaption: TButton;
    btnDeleteCaption: TButton;
    pnlCaptionDetails: TPanel;
    lblCaptionText: TLabel;
    edtCaptionText: TEdit;
    lblStartTime: TLabel;
    edtStartTime: TEdit;
    lblCaptionDuration: TLabel;
    edtCaptionDuration: TEdit;
    lblFontSettings: TLabel;
    edtFontName: TEdit;
    btnSelectFont: TButton;
    lblFontSize: TLabel;
    edtFontSize: TEdit;
    lblFontColor: TLabel;
    pnlFontColor: TPanel;
    lblPosition: TLabel;
    lblCaptionX: TLabel;
    edtCaptionX: TEdit;
    lblCaptionY: TLabel;
    edtCaptionY: TEdit;
    btnSaveCaption: TButton;
    btnCancelCaption: TButton;
    dlgOpenBackground: TOpenDialog;
    dlgOpenAudio: TOpenDialog;
    dlgFont: TFontDialog;
    dlgColor: TColorDialog;
    procedure btnBrowseBackgroundClick(Sender: TObject);
    procedure btnBrowseAudioClick(Sender: TObject);
    procedure btnAddCaptionClick(Sender: TObject);
    procedure btnEditCaptionClick(Sender: TObject);
    procedure btnDeleteCaptionClick(Sender: TObject);
    procedure btnSaveCaptionClick(Sender: TObject);
    procedure btnCancelCaptionClick(Sender: TObject);
    procedure btnSelectFontClick(Sender: TObject);
    procedure pnlFontColorClick(Sender: TObject);
    procedure lstCaptionsClick(Sender: TObject);
  private
    FCaptions: TList<TCaptionInfo>;
    FCurrentCaption: TCaptionInfo;
  protected
    procedure LoadFromJSON; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToJSON; override;
  end;

implementation

{$R *.dfm}

{ TCaptionInfo }

constructor TCaptionInfo.Create;
begin
  inherited Create;
  Text := '';
end;

{ TFrameVideoClipEditor }

constructor TFrameVideoClipEditor.Create(AOwner: TComponent);
begin
  inherited;
  FCaptions := TList<TCaptionInfo>.Create;
  FCurrentCaption := nil;
  
  dlgOpenBackground.Filter := '所有文件|*.*';
  dlgOpenAudio.Filter := '所有文件|*.*';
end;

destructor TFrameVideoClipEditor.Destroy;
begin
  // 释放列表内所有项
  for var I := 0 to FCaptions.Count-1 do
    FCaptions[I].Free;
  
  FCaptions.Free;
  inherited;
end;

procedure TFrameVideoClipEditor.LoadFromJSON;
begin
  if not Assigned(JSONObject) then
    Exit;
    
  edtDuration.Text := '10.00';
  edtFPS.Text := '30.00';
  edtBackground.Text := '';
  edtAudio.Text := '';
end;

procedure TFrameVideoClipEditor.SaveToJSON;
begin
  if not Assigned(JSONObject) then
    Exit;
end;

procedure TFrameVideoClipEditor.btnAddCaptionClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnBrowseAudioClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnBrowseBackgroundClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnCancelCaptionClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnDeleteCaptionClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnEditCaptionClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnSaveCaptionClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.btnSelectFontClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.lstCaptionsClick(Sender: TObject);
begin
  // 空实
end;

procedure TFrameVideoClipEditor.pnlFontColorClick(Sender: TObject);
begin
  // 空实
end;

end. 
