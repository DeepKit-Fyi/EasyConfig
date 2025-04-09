unit DebugHelper;

interface

uses
  System.SysUtils, System.Classes;

procedure LogMessage(const AMessage: string);
procedure LogError(const AError: string);
procedure LogDebug(const AModule, AMessage: string);
procedure ClearLogs;

implementation

uses
  System.IOUtils;

const
  LOG_FILE = 'debug.log';

procedure LogMessage(const AMessage: string);
var
  F: TextFile;
begin
  try
    AssignFile(F, LOG_FILE);
    if FileExists(LOG_FILE) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - INFO: ' + AMessage);
    CloseFile(F);
  except
    // 忽略日志错误
  end;
end;

procedure LogError(const AError: string);
var
  F: TextFile;
begin
  try
    AssignFile(F, LOG_FILE);
    if FileExists(LOG_FILE) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ERROR: ' + AError);
    CloseFile(F);
  except
    // 忽略日志错误
  end;
end;

procedure LogDebug(const AModule, AMessage: string);
var
  F: TextFile;
begin
  try
    AssignFile(F, LOG_FILE);
    if FileExists(LOG_FILE) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - DEBUG [' + AModule + ']: ' + AMessage);
    CloseFile(F);
  except
    // 忽略日志错误
  end;
end;

procedure ClearLogs;
begin
  if FileExists(LOG_FILE) then
    DeleteFile(LOG_FILE);
end;

initialization
  LogMessage('DebugHelper 初始化');

finalization
  LogMessage('DebugHelper 结束');

end. 