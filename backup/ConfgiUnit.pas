unit ConfgiUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ConfigManager, ConfigObjects, ConfigObjectDefs, INIConfig, JSONConfig,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    pnlTop: TPanel;
    pnlClient: TPanel;
    pnlBottom: TPanel;
    pnlRigth: TPanel;
    pnlLeft: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;

    Edit1: TEdit;
    btnRead: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ValueListEditor1: TValueListEditor;
    procedure btnReadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FConfigManager: TConfigManager;
    procedure AddLogMessage(const Msg: string);
    procedure LoadConfigObjects;
  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // 锟斤拷始锟斤拷锟斤拷录
  Memo1.Clear;
  Memo2.Clear;
  Edit1.Text := '';
  
  // 锟斤拷锟斤拷锟斤拷锟矫癸拷锟斤拷锟斤拷
  try
    FConfigManager := TConfigManager.Create('config');
    
    // 锟斤拷锟斤拷锟斤拷霉锟斤拷锟斤拷锟斤拷欠翊唇锟斤拷晒锟?
    if not Assigned(FConfigManager) then
    begin
      AddLogMessage('锟斤拷锟斤拷锟睫凤拷锟斤拷锟斤拷锟斤拷锟矫癸拷锟斤拷锟斤拷');
      Exit;
    end;
    
    // 锟斤拷始锟斤拷锟斤拷锟斤拷, 指锟斤拷锟斤拷锟斤拷锟侥硷拷路锟斤拷
    FConfigManager.Initialize('config\start.ini');
    AddLogMessage('锟斤拷锟斤拷锟绞硷拷锟斤拷锟斤拷');
    
    // 锟斤拷锟截可达拷锟斤拷锟斤拷锟斤拷锟矫讹拷锟斤拷
    LoadConfigObjects;
  except
    on E: Exception do
    begin
      AddLogMessage('锟斤拷始锟斤拷锟斤拷锟斤拷: ' + E.Message);
      if Assigned(FConfigManager) then
      begin
        FreeAndNil(FConfigManager);
      end;
    end;
  end;
end;

destructor TForm1.Destroy;
begin
  if Assigned(FConfigManager) then
    FConfigManager.Free;
  inherited;
end;

procedure TForm1.AddLogMessage(const Msg: string);
begin
  Memo2.Lines.Add(Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), Msg]));
end;

procedure TForm1.LoadConfigObjects;
begin
  // 锟斤拷示锟斤拷锟斤拷锟斤拷源锟斤拷锟斤拷锟斤拷锟斤拷荻锟斤拷锟?
  Memo1.Lines.Clear;
  
  // INI锟斤拷锟矫讹拷锟斤拷
  Memo1.Lines.Add('INI锟斤拷锟矫讹拷锟斤拷:');
  Memo1.Lines.Add('- 锟斤拷锟捷匡拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟侥硷拷锟斤拷锟酵癸拷锟斤拷');
  Memo1.Lines.Add('- 路锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟叫诧拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?);
  Memo1.Lines.Add('- 锟斤拷印锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟绞硷拷锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟截伙拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷时锟斤拷锟斤拷锟斤拷锟斤拷');
  
  // JSON锟斤拷锟矫讹拷锟斤拷
  Memo1.Lines.Add('');
  Memo1.Lines.Add('JSON锟斤拷锟矫讹拷锟斤拷:');
  Memo1.Lines.Add('- 页锟芥布锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟矫伙拷权锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷媒锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷态锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷同锟斤拷锟斤拷锟斤拷');
  Memo1.Lines.Add('- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?);
  Memo1.Lines.Add('- API锟斤拷锟斤拷锟斤拷锟斤拷');
  
  AddLogMessage('锟窖硷拷锟斤拷锟斤拷锟矫讹拷锟斤拷锟叫憋拷');
end;

procedure TForm1.btnReadClick(Sender: TObject);
var
  IniConfig: TINIConfig;
  BackupPath: string;
  IniFileName: string;
  FullPath: string;
begin
  try
    if not Assigned(FConfigManager) then
    begin
      AddLogMessage('锟斤拷锟斤拷锟斤拷锟矫癸拷锟斤拷锟斤拷未锟斤拷始锟斤拷');
      Exit;
    end;
    
    // 锟斤拷录锟斤拷志
    AddLogMessage('锟斤拷始锟斤拷取锟斤拷锟斤拷锟侥硷拷');
    
    // 锟斤拷取start.ini锟斤拷锟斤拷锟侥硷拷 (使锟斤拷锟斤拷锟斤拷路锟斤拷)
    IniFileName := 'start.ini'; // 锟斤拷要使锟斤拷config\start.ini锟斤拷锟斤拷为ConfigManager锟斤拷锟皆讹拷锟斤拷锟斤拷ConfigRoot
    AddLogMessage('锟斤拷锟皆凤拷锟斤拷锟斤拷锟斤拷锟侥硷拷: ' + IniFileName);
    
    // 锟斤拷示锟斤拷锟斤拷路锟斤拷锟皆憋拷锟斤拷锟?
    FullPath := FConfigManager.ConfigRoot + '\' + IniFileName;
    AddLogMessage('锟斤拷锟斤拷路锟斤拷: ' + FullPath);
    
    if not FileExists(FullPath) then
    begin
      AddLogMessage('锟斤拷锟芥：锟侥硷拷锟斤拷锟斤拷锟斤拷: ' + FullPath);
    end;
    
    IniConfig := FConfigManager.GetINI(IniFileName);
    if not Assigned(IniConfig) then
    begin
      AddLogMessage('锟斤拷锟斤拷锟睫凤拷锟斤拷取INI锟斤拷锟斤拷');
      Exit;
    end;
    
    // 锟叫筹拷INI锟侥硷拷锟叫碉拷锟斤拷锟斤拷Section锟斤拷锟斤拷锟斤拷锟斤拷
    var Sections := IniConfig.ReadSections;
    AddLogMessage('INI锟侥硷拷锟斤拷锟斤拷锟侥节碉拷锟斤拷锟斤拷: ' + IntToStr(Length(Sections)));
    for var i := 0 to Length(Sections) - 1 do
    begin
      AddLogMessage('锟节碉拷: [' + Sections[i] + ']');
    end;
    
    // 锟斤拷取BackupPath
    BackupPath := IniConfig.ReadString('Paths', 'BackupPath', '默锟斤拷路锟斤拷');
    AddLogMessage('锟斤拷取锟斤拷路锟斤拷值: ' + BackupPath);
    
    // 锟斤拷示锟斤拷Edit锟截硷拷
    Edit1.Text := BackupPath;
    
    AddLogMessage('锟缴癸拷锟斤拷取锟斤拷锟斤拷路锟斤拷: ' + BackupPath);
  except
    on E: Exception do
    begin
      AddLogMessage('锟斤拷取锟斤拷锟斤拷失锟斤拷: ' + E.Message);
      Edit1.Text := '锟斤拷取失锟斤拷';
    end;
  end;
end;

end.
