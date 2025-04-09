unit UtilsLog;

interface

uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages;

const
  // Windows娑堟伅甯搁噺
  EM_SCROLLCARET = $00B7;

type
  // 鏃ュ織绾у埆
  TLogLevel = (llDebug, llInfo, llWarning, llError, llFatal);
  
  // 鏃ュ織鎺ュ彛
  ILogger = interface
    ['{A4B5C6D7-E8F9-0A1B-2C3D-4E5F6A7B8C9D}']
    procedure Log(Level: TLogLevel; const Msg: string);
    procedure Debug(const Msg: string);
    procedure Info(const Msg: string);
    procedure Warning(const Msg: string);
    procedure Error(const Msg: string);
    procedure Fatal(const Msg: string);
  end;
  
  // 鏂囦欢鏃ュ織璁板綍鍣?
  TFileLogger = class(TInterfacedObject, ILogger)
  private
    FLogFile: string;
    FLogLevel: TLogLevel;
    FMaxFileSize: Int64;
    FMaxBackupCount: Integer;
    
    procedure CheckFileSize;
    procedure RotateLogFiles;
  public
    constructor Create(const LogFile: string; Level: TLogLevel = llInfo; 
      MaxFileSize: Int64 = 1024 * 1024; MaxBackupCount: Integer = 5);
    
    procedure Log(Level: TLogLevel; const Msg: string); virtual;
    procedure Debug(const Msg: string); virtual;
    procedure Info(const Msg: string); virtual;
    procedure Warning(const Msg: string); virtual;
    procedure Error(const Msg: string); virtual;
    procedure Fatal(const Msg: string); virtual;
  end;
  
  // 鎺у埗鍙版棩蹇楄褰曞櫒
  TMemoLogger = class(TInterfacedObject, ILogger)
  private
    FMemo: TMemo;
    FLogLevel: TLogLevel;
    FMaxLines: Integer;
  public
    constructor Create(Memo: TMemo; Level: TLogLevel = llInfo; MaxLines: Integer = 1000);
    
    procedure Log(Level: TLogLevel; const Msg: string); virtual;
    procedure Debug(const Msg: string); virtual;
    procedure Info(const Msg: string); virtual;
    procedure Warning(const Msg: string); virtual;
    procedure Error(const Msg: string); virtual;
    procedure Fatal(const Msg: string); virtual;
  end;
  
  // 鏃ュ織绠＄悊鍣?
  TLogManager = class
  private
    FLoggers: TList;
    class var FInstance: TLogManager;
    
    constructor Create;
  public
    destructor Destroy; override;
    
    class function GetInstance: TLogManager;
    class procedure ReleaseInstance;
    
    procedure AddLogger(Logger: ILogger);
    procedure RemoveLogger(Logger: ILogger);
    procedure ClearLoggers;
    
    procedure Log(Level: TLogLevel; const Msg: string);
    procedure Debug(const Msg: string);
    procedure Info(const Msg: string);
    procedure Warning(const Msg: string);
    procedure Error(const Msg: string);
    procedure Fatal(const Msg: string);
  end;
  
// 鍏ㄥ眬鏃ュ織鍑芥暟
procedure LogDebug(const Msg: string);
procedure LogInfo(const Msg: string);
procedure LogWarning(const Msg: string);
procedure LogError(const Msg: string);
procedure LogFatal(const Msg: string);

// 鍒濆鍖栨棩蹇楃郴缁?
procedure InitializeLogging(const LogFile: string = ''; const LogLevel: TLogLevel = llInfo);
procedure ShutdownLogging;

implementation

uses
  System.IOUtils, System.DateUtils;

// 鏃ュ織绾у埆瀛楃涓茶〃绀?
function LogLevelToStr(Level: TLogLevel): string;
begin
  case Level of
    llDebug:   Result := 'DEBUG';
    llInfo:    Result := 'INFO';
    llWarning: Result := 'WARNING';
    llError:   Result := 'ERROR';
    llFatal:   Result := 'FATAL';
    else       Result := 'UNKNOWN';
  end;
end;

{ TFileLogger }

constructor TFileLogger.Create(const LogFile: string; Level: TLogLevel;
  MaxFileSize: Int64; MaxBackupCount: Integer);
begin
  inherited Create;
  FLogFile := LogFile;
  FLogLevel := Level;
  FMaxFileSize := MaxFileSize;
  FMaxBackupCount := MaxBackupCount;
  
  // 纭繚鏃ュ織鐩綍瀛樺湪
  ForceDirectories(ExtractFileDir(FLogFile));
end;

procedure TFileLogger.CheckFileSize;
begin
  if (FMaxFileSize > 0) and FileExists(FLogFile) then
  begin
    var FileSize := TFile.GetSize(FLogFile);
    if FileSize > FMaxFileSize then
      RotateLogFiles;
  end;
end;

procedure TFileLogger.RotateLogFiles;
var
  i: Integer;
  BackupFile: string;
begin
  // 鍒犻櫎鏈€鏃х殑澶囦唤
  BackupFile := Format('%s.%d', [FLogFile, FMaxBackupCount]);
  if FileExists(BackupFile) then
    TFile.Delete(BackupFile);
    
  // 绉诲姩鐜版湁澶囦唤
  for i := FMaxBackupCount - 1 downto 1 do
  begin
    var OldFile := Format('%s.%d', [FLogFile, i]);
    var NewFile := Format('%s.%d', [FLogFile, i + 1]);
    
    if FileExists(OldFile) then
      TFile.Move(OldFile, NewFile);
  end;
  
  // 绉诲姩褰撳墠鏃ュ織鏂囦欢
  if FileExists(FLogFile) then
    TFile.Move(FLogFile, FLogFile + '.1');
end;

procedure TFileLogger.Log(Level: TLogLevel; const Msg: string);
begin
  if Level < FLogLevel then
    Exit;
    
  // 妫€鏌ユ枃浠跺ぇ灏?
  CheckFileSize;
  
  // 鍐欏叆鏃ュ織
  var LogStr := Format('[%s] [%s] %s', [
    FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now),
    LogLevelToStr(Level),
    Msg
  ]);
  
  try
    TFile.AppendAllText(FLogFile, LogStr + sLineBreak);
  except
    // 蹇界暐鏂囦欢鍐欏叆閿欒
  end;
end;

procedure TFileLogger.Debug(const Msg: string);
begin
  Log(llDebug, Msg);
end;

procedure TFileLogger.Info(const Msg: string);
begin
  Log(llInfo, Msg);
end;

procedure TFileLogger.Warning(const Msg: string);
begin
  Log(llWarning, Msg);
end;

procedure TFileLogger.Error(const Msg: string);
begin
  Log(llError, Msg);
end;

procedure TFileLogger.Fatal(const Msg: string);
begin
  Log(llFatal, Msg);
end;

{ TMemoLogger }

constructor TMemoLogger.Create(Memo: TMemo; Level: TLogLevel; MaxLines: Integer);
begin
  inherited Create;
  FMemo := Memo;
  FLogLevel := Level;
  FMaxLines := MaxLines;
end;

procedure TMemoLogger.Log(Level: TLogLevel; const Msg: string);
begin
  if Level < FLogLevel then
    Exit;
    
  if not Assigned(FMemo) then
    Exit;
    
  // 娣诲姞鏃ュ織娑堟伅
  var LogStr := Format('[%s] [%s] %s', [
    FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
    LogLevelToStr(Level),
    Msg
  ]);
  
  // 纭繚UI绾跨▼璁块棶
  if Assigned(FMemo) then
  begin
    if TThread.CurrentThread.ThreadID = MainThreadID then
    begin
      FMemo.Lines.Add(LogStr);
      
      // 闄愬埗琛屾暟
      while (FMaxLines > 0) and (FMemo.Lines.Count > FMaxLines) do
        FMemo.Lines.Delete(0);
        
      // 婊氬姩鍒板簳閮?
      SendMessage(FMemo.Handle, EM_SCROLLCARET, 0, 0);
    end
    else
    begin
      // 濡傛灉鏄潪UI绾跨▼锛屼娇鐢ㄥ悓姝ヨ皟鐢?
      TThread.Synchronize(nil, procedure
      begin
        if Assigned(FMemo) then
        begin
          FMemo.Lines.Add(LogStr);
          
          // 闄愬埗琛屾暟
          while (FMaxLines > 0) and (FMemo.Lines.Count > FMaxLines) do
            FMemo.Lines.Delete(0);
            
          // 婊氬姩鍒板簳閮?
          SendMessage(FMemo.Handle, EM_SCROLLCARET, 0, 0);
        end;
      end);
    end;
  end;
end;

procedure TMemoLogger.Debug(const Msg: string);
begin
  Log(llDebug, Msg);
end;

procedure TMemoLogger.Info(const Msg: string);
begin
  Log(llInfo, Msg);
end;

procedure TMemoLogger.Warning(const Msg: string);
begin
  Log(llWarning, Msg);
end;

procedure TMemoLogger.Error(const Msg: string);
begin
  Log(llError, Msg);
end;

procedure TMemoLogger.Fatal(const Msg: string);
begin
  Log(llFatal, Msg);
end;

{ TLogManager }

constructor TLogManager.Create;
begin
  inherited;
  FLoggers := TList.Create;
end;

destructor TLogManager.Destroy;
begin
  ClearLoggers;
  FLoggers.Free;
  inherited;
end;

class function TLogManager.GetInstance: TLogManager;
begin
  if FInstance = nil then
    FInstance := TLogManager.Create;
  Result := FInstance;
end;

class procedure TLogManager.ReleaseInstance;
begin
  if FInstance <> nil then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TLogManager.AddLogger(Logger: ILogger);
begin
  if not Assigned(Logger) then
    Exit;
    
  if FLoggers.IndexOf(Pointer(Logger)) < 0 then
    FLoggers.Add(Pointer(Logger));
end;

procedure TLogManager.RemoveLogger(Logger: ILogger);
var
  Index: Integer;
begin
  if not Assigned(Logger) then
    Exit;
    
  Index := FLoggers.IndexOf(Pointer(Logger));
  if Index >= 0 then
    FLoggers.Delete(Index);
end;

procedure TLogManager.ClearLoggers;
begin
  FLoggers.Clear;
end;

procedure TLogManager.Log(Level: TLogLevel; const Msg: string);
var
  i: Integer;
begin
  for i := 0 to FLoggers.Count - 1 do
    ILogger(FLoggers[i]).Log(Level, Msg);
end;

procedure TLogManager.Debug(const Msg: string);
begin
  Log(llDebug, Msg);
end;

procedure TLogManager.Info(const Msg: string);
begin
  Log(llInfo, Msg);
end;

procedure TLogManager.Warning(const Msg: string);
begin
  Log(llWarning, Msg);
end;

procedure TLogManager.Error(const Msg: string);
begin
  Log(llError, Msg);
end;

procedure TLogManager.Fatal(const Msg: string);
begin
  Log(llFatal, Msg);
end;

// 鍏ㄥ眬鏃ュ織鍑芥暟
procedure LogDebug(const Msg: string);
begin
  TLogManager.GetInstance.Debug(Msg);
end;

procedure LogInfo(const Msg: string);
begin
  TLogManager.GetInstance.Info(Msg);
end;

procedure LogWarning(const Msg: string);
begin
  TLogManager.GetInstance.Warning(Msg);
end;

procedure LogError(const Msg: string);
begin
  TLogManager.GetInstance.Error(Msg);
end;

procedure LogFatal(const Msg: string);
begin
  TLogManager.GetInstance.Fatal(Msg);
end;

// 鍒濆鍖栧拰鍏抽棴鏃ュ織绯荤粺
procedure InitializeLogging(const LogFile: string; const LogLevel: TLogLevel);
begin
  if LogFile <> '' then
  begin
    var FileLogger := TFileLogger.Create(LogFile, LogLevel);
    TLogManager.GetInstance.AddLogger(FileLogger);
  end;
end;

procedure ShutdownLogging;
begin
  TLogManager.ReleaseInstance;
end;

initialization
  // 鍒濆鍖栭粯璁ゆ棩蹇楄褰曞櫒
  InitializeLogging(ChangeFileExt(ParamStr(0), '.log'), llInfo);
  
finalization
  // 鍏抽棴鏃ュ織绯荤粺
  ShutdownLogging;
  
end. 