unit ErrorLogger;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.IOUtils,
  Vcl.Dialogs, Vcl.Forms;

type
  TLogLevel = (llDebug, llInfo, llWarning, llError, llFatal);
  
  TErrorLogger = class
  private
    class var FInstance: TErrorLogger;
    
    FLogFile: string;
    FLogStream: TStreamWriter;
    FIsInitialized: Boolean;
    FShowDialogs: Boolean;
    
    constructor Create;
    destructor Destroy; override;
    
    procedure InitializeLogger;
    procedure EnsureLogDirectoryExists;
    function GetLogLevelString(Level: TLogLevel): string;
    procedure WriteToLog(const Msg: string);
  public
    class function GetInstance: TErrorLogger;
    class procedure ReleaseInstance;
    
    procedure Initialize(const LogFile: string = '');
    procedure Log(const Msg: string; Level: TLogLevel = llInfo); overload;
    procedure Log(const Msg: string; E: Exception; Level: TLogLevel = llError); overload;
    procedure LogFormat(const Fmt: string; const Args: array of const; Level: TLogLevel = llInfo);
    
    procedure ShowErrorDialog(const Msg: string; E: Exception = nil);
    procedure ShowWarningDialog(const Msg: string);
    procedure ShowInfoDialog(const Msg: string);
    
    property ShowDialogs: Boolean read FShowDialogs write FShowDialogs;
  end;

// 全局访问函数
function Logger: TErrorLogger;

// 全局异常处理
procedure InstallGlobalExceptionHandler;
procedure UninstallGlobalExceptionHandler;

implementation

var
  PreviousExceptionHandler: TExceptionEvent;

function Logger: TErrorLogger;
begin
  Result := TErrorLogger.GetInstance;
end;

procedure GlobalExceptionHandler(Sender: TObject; E: Exception);
begin
  Logger.Log('未捕获的异常', E, llFatal);
  Logger.ShowErrorDialog('应用程序发生未捕获的异常', E);
  
  // 调用之前的异常处理器（如果有）
  if Assigned(PreviousExceptionHandler) then
    PreviousExceptionHandler(Sender, E);
end;

procedure InstallGlobalExceptionHandler;
begin
  PreviousExceptionHandler := Application.OnException;
  Application.OnException := GlobalExceptionHandler;
end;

procedure UninstallGlobalExceptionHandler;
begin
  Application.OnException := PreviousExceptionHandler;
end;

{ TErrorLogger }

constructor TErrorLogger.Create;
begin
  FIsInitialized := False;
  FShowDialogs := True;
end;

destructor TErrorLogger.Destroy;
begin
  if Assigned(FLogStream) then
  begin
    FLogStream.Flush;
    FLogStream.Free;
  end;
  
  inherited;
end;

procedure TErrorLogger.EnsureLogDirectoryExists;
var
  LogDir: string;
begin
  LogDir := ExtractFilePath(FLogFile);
  if (LogDir <> '') and not DirectoryExists(LogDir) then
    ForceDirectories(LogDir);
end;

class function TErrorLogger.GetInstance: TErrorLogger;
begin
  if not Assigned(FInstance) then
    FInstance := TErrorLogger.Create;
    
  Result := FInstance;
end;

function TErrorLogger.GetLogLevelString(Level: TLogLevel): string;
begin
  case Level of
    llDebug:   Result := 'DEBUG';
    llInfo:    Result := 'INFO';
    llWarning: Result := 'WARNING';
    llError:   Result := 'ERROR';
    llFatal:   Result := 'FATAL';
  else
    Result := 'UNKNOWN';
  end;
end;

procedure TErrorLogger.Initialize(const LogFile: string);
begin
  if LogFile <> '' then
    FLogFile := LogFile
  else
    FLogFile := ChangeFileExt(ParamStr(0), '.log');
    
  InitializeLogger;
end;

procedure TErrorLogger.InitializeLogger;
begin
  if FIsInitialized then Exit;
  
  try
    EnsureLogDirectoryExists;
    
    // 创建或追加到日志文件
    FLogStream := TStreamWriter.Create(FLogFile, True, TEncoding.UTF8);
    FLogStream.AutoFlush := True;
    
    // 写入日志头
    FLogStream.WriteLine('');
    FLogStream.WriteLine('=================================================');
    FLogStream.WriteLine('日志开始: ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
    FLogStream.WriteLine('应用程序: ' + ExtractFileName(ParamStr(0)));
    FLogStream.WriteLine('=================================================');
    FLogStream.WriteLine('');
    
    FIsInitialized := True;
  except
    on E: Exception do
    begin
      if FShowDialogs then
        ShowMessage('初始化日志系统失败: ' + E.Message);
    end;
  end;
end;

class procedure TErrorLogger.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TErrorLogger.Log(const Msg: string; Level: TLogLevel);
var
  LogMsg: string;
begin
  LogMsg := Format('[%s] [%s] %s',
    [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now),
     GetLogLevelString(Level),
     Msg]);
     
  WriteToLog(LogMsg);
end;

procedure TErrorLogger.Log(const Msg: string; E: Exception; Level: TLogLevel);
var
  LogMsg: string;
begin
  if Assigned(E) then
    LogMsg := Format('[%s] [%s] %s - Exception: %s (%s)',
      [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now),
       GetLogLevelString(Level),
       Msg,
       E.ClassName,
       E.Message])
  else
    LogMsg := Format('[%s] [%s] %s',
      [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now),
       GetLogLevelString(Level),
       Msg]);
       
  WriteToLog(LogMsg);
end;

procedure TErrorLogger.LogFormat(const Fmt: string; const Args: array of const; Level: TLogLevel);
begin
  Log(Format(Fmt, Args), Level);
end;

procedure TErrorLogger.ShowErrorDialog(const Msg: string; E: Exception);
var
  ErrorMsg: string;
begin
  if not FShowDialogs then Exit;
  
  if Assigned(E) then
    ErrorMsg := Msg + #13#10 + #13#10 + '错误详情: ' + E.Message
  else
    ErrorMsg := Msg;
    
  MessageDlg(ErrorMsg, mtError, [mbOK], 0);
end;

procedure TErrorLogger.ShowInfoDialog(const Msg: string);
begin
  if not FShowDialogs then Exit;
  
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

procedure TErrorLogger.ShowWarningDialog(const Msg: string);
begin
  if not FShowDialogs then Exit;
  
  MessageDlg(Msg, mtWarning, [mbOK], 0);
end;

procedure TErrorLogger.WriteToLog(const Msg: string);
begin
  if not FIsInitialized then
    InitializeLogger;
    
  try
    if Assigned(FLogStream) then
      FLogStream.WriteLine(Msg);
  except
    // 忽略写入日志时的错误
  end;
end;

initialization
  // 不在这里创建实例，而是在需要时通过GetInstance创建

finalization
  TErrorLogger.ReleaseInstance;

end.
