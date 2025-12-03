unit ExceptionRecovery;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.DateUtils,
  Vcl.Forms, Vcl.Dialogs, ErrorLogger, ErrorDialog;

type
  TRecoveryAction = (raIgnore, raSave, raRestore);
  
  TExceptionRecovery = class
  private
    class var FInstance: TExceptionRecovery;
    
    FBackupDirectory: string;
    FMaxBackupFiles: Integer;
    FAutoSaveInterval: Integer;
    FLastAutoSaveTime: TDateTime;
    FIsRecovering: Boolean;
    
    constructor Create;
    destructor Destroy; override;
    
    procedure InitializeBackupDirectory;
    procedure CleanupOldBackups;
    function GetBackupFileName(const OriginalFileName: string): string;
  public
    class function GetInstance: TExceptionRecovery;
    class procedure ReleaseInstance;
    
    procedure Initialize(const BackupDir: string = '');
    function BackupFile(const FileName: string): Boolean;
    function RestoreFile(const FileName: string; out RestoredFileName: string): Boolean;
    procedure AutoSave(const FileName: string);
    
    function HandleException(E: Exception; const FileName: string): TRecoveryAction;
    
    property BackupDirectory: string read FBackupDirectory write FBackupDirectory;
    property MaxBackupFiles: Integer read FMaxBackupFiles write FMaxBackupFiles;
    property AutoSaveInterval: Integer read FAutoSaveInterval write FAutoSaveInterval;
    property IsRecovering: Boolean read FIsRecovering write FIsRecovering;
  end;

// 全局访问函数
function Recovery: TExceptionRecovery;

implementation

function Recovery: TExceptionRecovery;
begin
  Result := TExceptionRecovery.GetInstance;
end;

{ TExceptionRecovery }

function TExceptionRecovery.BackupFile(const FileName: string): Boolean;
var
  BackupFileName: string;
begin
  Result := False;
  
  if not FileExists(FileName) then
  begin
    Logger.Log('备份文件失败：文件不存在 - ' + FileName, llWarning);
    Exit;
  end;
  
  try
    // 确保备份目录存在
    if not DirectoryExists(FBackupDirectory) then
      ForceDirectories(FBackupDirectory);
      
    // 生成备份文件名
    BackupFileName := GetBackupFileName(FileName);
    
    // 复制文件
    TFile.Copy(FileName, BackupFileName, True);
    
    Logger.Log('文件已备份: ' + FileName + ' -> ' + BackupFileName, llInfo);
    Result := True;
    
    // 清理旧备份
    CleanupOldBackups;
  except
    on E: Exception do
    begin
      Logger.Log('备份文件时发生错误', E, llError);
      Result := False;
    end;
  end;
end;

procedure TExceptionRecovery.AutoSave(const FileName: string);
var
  CurrentTime: TDateTime;
begin
  // 检查是否需要自动保存
  CurrentTime := Now;
  if SecondsBetween(CurrentTime, FLastAutoSaveTime) >= FAutoSaveInterval then
  begin
    if BackupFile(FileName) then
      FLastAutoSaveTime := CurrentTime;
  end;
end;

procedure TExceptionRecovery.CleanupOldBackups;
var
  Files: TStringDynArray;
  FileInfo: TSearchRec;
  FilePath: string;
  FileDate: TDateTime;
  FileList: TList<TPair<string, TDateTime>>;
  i: Integer;
begin
  try
    // 获取备份目录中的所有文件
    Files := TDirectory.GetFiles(FBackupDirectory, '*.bak');
    
    // 如果文件数量小于最大备份数，不需要清理
    if Length(Files) <= FMaxBackupFiles then
      Exit;
      
    // 创建文件列表，包含文件路径和修改日期
    FileList := TList<TPair<string, TDateTime>>.Create;
    try
      for FilePath in Files do
      begin
        if FindFirst(FilePath, faAnyFile, FileInfo) = 0 then
        begin
          try
            FileDate := FileDateToDateTime(FileInfo.Time);
            FileList.Add(TPair<string, TDateTime>.Create(FilePath, FileDate));
          finally
            FindClose(FileInfo);
          end;
        end;
      end;
      
      // 按日期排序（最旧的在前）
      FileList.Sort(
        function(const Left, Right: TPair<string, TDateTime>): Integer
        begin
          if Left.Value < Right.Value then
            Result := -1
          else if Left.Value > Right.Value then
            Result := 1
          else
            Result := 0;
        end
      );
      
      // 删除最旧的文件，直到文件数量等于最大备份数
      for i := 0 to FileList.Count - FMaxBackupFiles - 1 do
      begin
        try
          DeleteFile(FileList[i].Key);
          Logger.Log('删除旧备份文件: ' + FileList[i].Key, llInfo);
        except
          on E: Exception do
            Logger.Log('删除旧备份文件时发生错误', E, llWarning);
        end;
      end;
    finally
      FileList.Free;
    end;
  except
    on E: Exception do
      Logger.Log('清理旧备份文件时发生错误', E, llError);
  end;
end;

constructor TExceptionRecovery.Create;
begin
  FMaxBackupFiles := 10;
  FAutoSaveInterval := 300; // 5分钟
  FLastAutoSaveTime := 0;
  FIsRecovering := False;
end;

destructor TExceptionRecovery.Destroy;
begin
  inherited;
end;

function TExceptionRecovery.GetBackupFileName(const OriginalFileName: string): string;
var
  FileName, FileExt: string;
  TimeStamp: string;
begin
  // 提取文件名和扩展名
  FileName := ExtractFileName(OriginalFileName);
  FileExt := ExtractFileExt(FileName);
  FileName := ChangeFileExt(FileName, '');
  
  // 生成时间戳
  TimeStamp := FormatDateTime('yyyymmdd_hhnnss', Now);
  
  // 组合备份文件名
  Result := IncludeTrailingPathDelimiter(FBackupDirectory) + 
            FileName + '_' + TimeStamp + FileExt + '.bak';
end;

class function TExceptionRecovery.GetInstance: TExceptionRecovery;
begin
  if not Assigned(FInstance) then
    FInstance := TExceptionRecovery.Create;
    
  Result := FInstance;
end;

function TExceptionRecovery.HandleException(E: Exception; const FileName: string): TRecoveryAction;
var
  Response: Integer;
  RestoredFileName: string;
begin
  // 默认操作是忽略
  Result := raIgnore;
  
  // 记录异常
  Logger.Log('处理异常', E, llError);
  
  // 如果文件不存在，无法恢复
  if (FileName = '') or not FileExists(FileName) then
  begin
    TfrmErrorDialog.ShowError('发生错误', 
      '在处理文件时发生错误，但无法恢复，因为文件不存在或未指定。', E);
    Exit;
  end;
  
  // 显示恢复选项对话框
  Response := MessageDlg(
    '在处理文件时发生错误。您想要：' + #13#10 + 
    '- 保存当前状态并继续' + #13#10 + 
    '- 尝试恢复上一个备份' + #13#10 + 
    '- 忽略错误并继续',
    mtError, [mbYes, mbNo, mbCancel], 0, mbYes);
    
  case Response of
    mrYes: // 保存
      begin
        if BackupFile(FileName) then
        begin
          TfrmErrorDialog.ShowInfo('备份成功', 
            '当前状态已成功备份。您可以继续工作，或者稍后尝试恢复备份。');
          Result := raSave;
        end
        else
        begin
          TfrmErrorDialog.ShowError('备份失败', 
            '无法备份当前状态。建议手动保存您的工作。', E);
        end;
      end;
      
    mrNo: // 恢复
      begin
        if RestoreFile(FileName, RestoredFileName) then
        begin
          TfrmErrorDialog.ShowInfo('恢复成功', 
            '已成功恢复到上一个备份：' + #13#10 + RestoredFileName);
          Result := raRestore;
        end
        else
        begin
          TfrmErrorDialog.ShowError('恢复失败', 
            '无法恢复到上一个备份。建议手动检查备份文件。', E);
        end;
      end;
      
    mrCancel: // 忽略
      begin
        TfrmErrorDialog.ShowWarning('已忽略错误', 
          '已忽略错误。请注意，这可能导致数据不一致或其他问题。');
        Result := raIgnore;
      end;
  end;
end;

procedure TExceptionRecovery.Initialize(const BackupDir: string);
begin
  if BackupDir <> '' then
    FBackupDirectory := BackupDir
  else
    InitializeBackupDirectory;
    
  // 确保备份目录存在
  if not DirectoryExists(FBackupDirectory) then
    ForceDirectories(FBackupDirectory);
    
  Logger.Log('异常恢复系统已初始化，备份目录: ' + FBackupDirectory, llInfo);
end;

procedure TExceptionRecovery.InitializeBackupDirectory;
begin
  // 默认备份目录在应用程序目录下的Backups文件夹中
  FBackupDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Backups';
end;

class procedure TExceptionRecovery.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

function TExceptionRecovery.RestoreFile(const FileName: string; out RestoredFileName: string): Boolean;
var
  BackupFiles: TStringDynArray;
  BackupFile: string;
  FileInfo: TSearchRec;
  FileDate: TDateTime;
  LatestBackupFile: string;
  LatestBackupDate: TDateTime;
  FileNameOnly: string;
begin
  Result := False;
  RestoredFileName := '';
  
  try
    // 获取文件名（不包含路径）
    FileNameOnly := ExtractFileName(FileName);
    
    // 查找所有与该文件相关的备份
    BackupFiles := TDirectory.GetFiles(FBackupDirectory, ChangeFileExt(FileNameOnly, '') + '_*.bak');
    
    if Length(BackupFiles) = 0 then
    begin
      Logger.Log('没有找到文件的备份: ' + FileName, llWarning);
      Exit;
    end;
    
    // 查找最新的备份
    LatestBackupFile := '';
    LatestBackupDate := 0;
    
    for BackupFile in BackupFiles do
    begin
      if FindFirst(BackupFile, faAnyFile, FileInfo) = 0 then
      begin
        try
          FileDate := FileDateToDateTime(FileInfo.Time);
          if (LatestBackupFile = '') or (FileDate > LatestBackupDate) then
          begin
            LatestBackupFile := BackupFile;
            LatestBackupDate := FileDate;
          end;
        finally
          FindClose(FileInfo);
        end;
      end;
    end;
    
    if LatestBackupFile = '' then
    begin
      Logger.Log('无法确定最新的备份文件: ' + FileName, llWarning);
      Exit;
    end;
    
    // 创建恢复文件名（原文件名加上.restored扩展名）
    RestoredFileName := ChangeFileExt(FileName, '.restored' + ExtractFileExt(FileName));
    
    // 复制备份文件到恢复文件
    TFile.Copy(LatestBackupFile, RestoredFileName, True);
    
    Logger.Log('文件已恢复: ' + LatestBackupFile + ' -> ' + RestoredFileName, llInfo);
    Result := True;
  except
    on E: Exception do
    begin
      Logger.Log('恢复文件时发生错误', E, llError);
      Result := False;
    end;
  end;
end;

initialization
  // 不在这里创建实例，而是在需要时通过GetInstance创建

finalization
  TExceptionRecovery.ReleaseInstance;

end.
