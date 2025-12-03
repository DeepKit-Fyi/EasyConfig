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
    // 蹇界暐鏃ュ織閿欒
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
    // 蹇界暐鏃ュ織閿欒
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
    // 蹇界暐鏃ュ織閿欒
  end;
end;

procedure ClearLogs;
begin
  if FileExists(LOG_FILE) then
    DeleteFile(LOG_FILE);
end;

initialization
  LogMessage('DebugHelper 鍒濆鍖?);

finalization
  LogMessage('DebugHelper 缁撴潫');

end. 