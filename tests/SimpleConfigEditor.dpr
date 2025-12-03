program SimpleConfigEditor;

uses
  Vcl.Forms,
  Vcl.Controls,
  Vcl.Dialogs,
  System.SysUtils,
  ViewMain in 'ViewMain.pas' {frmMain};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end. 