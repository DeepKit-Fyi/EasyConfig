unit HelperForm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Dialogs,
  System.IniFiles, System.TypInfo, System.Rtti, Winapi.Windows, Winapi.Messages, System.UITypes;

// 搴旂敤绋嬪簭璁剧疆淇濆瓨鍜屽姞杞?
procedure SaveApplicationSettings(Form: TForm; MemoDebug: TMemo = nil);
procedure LoadApplicationSettings(Form: TForm; MemoDebug: TMemo = nil);

// 绐椾綋浣嶇疆鍜屽ぇ灏忎繚瀛?鍔犺浇
procedure SaveFormPosition(Form: TForm; const Section: string = '');
procedure LoadFormPosition(Form: TForm; const Section: string = '');

// 璋冭瘯鏂囨湰杈撳嚭
procedure AddDebugText(Memo: TMemo; const Text: string);
procedure ClearDebugText(Memo: TMemo);

// 瀵硅瘽妗嗚緟鍔╁嚱鏁?
function ShowConfirmationDialog(const Msg: string): Boolean;
procedure ShowInformationDialog(const Msg: string);
procedure ShowErrorDialog(const Msg: string);

// 鍏朵粬琛ㄥ崟杈呭姪鍔熻兘
procedure CenterFormOnScreen(Form: TForm);
procedure SetFormOnTop(Form: TForm; OnTop: Boolean);

implementation

uses
  Vcl.Graphics, System.IOUtils, UtilsLog;

const
  DEFAULT_INI_FILENAME = 'ConfigEditor.ini';

// 鑾峰彇搴旂敤绋嬪簭璁剧疆鏂囦欢璺緞
function GetSettingsFilePath: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

// 搴旂敤绋嬪簭璁剧疆淇濆瓨
procedure SaveApplicationSettings(Form: TForm; MemoDebug: TMemo);
begin
  if Form = nil then Exit;
  
  SaveFormPosition(Form);
  
  if MemoDebug <> nil then
    AddDebugText(MemoDebug, 'Application settings saved: ' + DateTimeToStr(Now));
    
  LogInfo('Application settings saved');
end;

// 搴旂敤绋嬪簭璁剧疆鍔犺浇
procedure LoadApplicationSettings(Form: TForm; MemoDebug: TMemo);
begin
  if Form = nil then Exit;
  
  LoadFormPosition(Form);
  
  if MemoDebug <> nil then
    AddDebugText(MemoDebug, 'Application settings loaded: ' + DateTimeToStr(Now));
    
  LogInfo('Application settings loaded');
end;

// 淇濆瓨绐椾綋浣嶇疆
procedure SaveFormPosition(Form: TForm; const Section: string);
var
  IniFile: TIniFile;
  SectionName: string;
begin
  if Form = nil then Exit;
  
  IniFile := TIniFile.Create(GetSettingsFilePath);
  try
    if Section <> '' then
      SectionName := Section
    else
      SectionName := Form.Name;
      
    IniFile.WriteInteger(SectionName, 'Left', Form.Left);
    IniFile.WriteInteger(SectionName, 'Top', Form.Top);
    IniFile.WriteInteger(SectionName, 'Width', Form.Width);
    IniFile.WriteInteger(SectionName, 'Height', Form.Height);
    IniFile.WriteInteger(SectionName, 'WindowState', Ord(Form.WindowState));
  finally
    IniFile.Free;
  end;
end;

// 鍔犺浇绐椾綋浣嶇疆
procedure LoadFormPosition(Form: TForm; const Section: string);
var
  IniFile: TIniFile;
  SectionName: string;
begin
  if Form = nil then Exit;
  
  if not FileExists(GetSettingsFilePath) then
  begin
    // 濡傛灉閰嶇疆鏂囦欢涓嶅瓨鍦紝浣跨敤榛樿灞呬腑鏄剧ず
    CenterFormOnScreen(Form);
    Exit;
  end;
  
  IniFile := TIniFile.Create(GetSettingsFilePath);
  try
    if Section <> '' then
      SectionName := Section
    else
      SectionName := Form.Name;
      
    if IniFile.SectionExists(SectionName) then
    begin
      Form.Left := IniFile.ReadInteger(SectionName, 'Left', Form.Left);
      Form.Top := IniFile.ReadInteger(SectionName, 'Top', Form.Top);
      Form.Width := IniFile.ReadInteger(SectionName, 'Width', Form.Width);
      Form.Height := IniFile.ReadInteger(SectionName, 'Height', Form.Height);
      Form.WindowState := TWindowState(IniFile.ReadInteger(SectionName, 'WindowState', Ord(Form.WindowState)));
    end
    else
    begin
      // 濡傛灉鑺備笉瀛樺湪锛屼娇鐢ㄩ粯璁ゅ眳涓樉绀?
      CenterFormOnScreen(Form);
    end;
  finally
    IniFile.Free;
  end;
end;

// 娣诲姞璋冭瘯鏂囨湰
procedure AddDebugText(Memo: TMemo; const Text: string);
begin
  if Memo = nil then Exit;
  
  Memo.Lines.Add(Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), Text]));
  // 婊氬姩鍒版渶鍚庝竴琛?
  SendMessage(Memo.Handle, EM_SCROLLCARET, 0, 0);
end;

// 娓呴櫎璋冭瘯鏂囨湰
procedure ClearDebugText(Memo: TMemo);
begin
  if Memo = nil then Exit;
  
  Memo.Clear;
end;

// 鏄剧ず纭瀵硅瘽妗?
function ShowConfirmationDialog(const Msg: string): Boolean;
begin
  Result := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

// 鏄剧ず淇℃伅瀵硅瘽妗?
procedure ShowInformationDialog(const Msg: string);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

// 鏄剧ず閿欒瀵硅瘽妗?
procedure ShowErrorDialog(const Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOK], 0);
end;

// 灏嗙獥浣撳眳涓樉绀?
procedure CenterFormOnScreen(Form: TForm);
begin
  if Form = nil then Exit;
  
  Form.Left := (Screen.Width - Form.Width) div 2;
  Form.Top := (Screen.Height - Form.Height) div 2;
end;

// 璁剧疆绐椾綋鏄惁缃《
procedure SetFormOnTop(Form: TForm; OnTop: Boolean);
begin
  if Form = nil then Exit;
  
  if OnTop then
    Form.FormStyle := fsStayOnTop
  else
    Form.FormStyle := fsNormal;
end;

end. 