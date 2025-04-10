program FixAccess;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, 
  System.Classes, 
  System.IOUtils;

var
  FileContent: TStringList;
  FilePath: string;
  FixedContent: string;
  SourceFile, TargetFile: string;
  BackupFile: string;
  i: Integer;
  ClearAllDataIndex: Integer;
  FoundBegin: Boolean;
  InsertIndex: Integer;

begin
  try
    WriteLn('ConfigBuild 访问违规修复工具');
    WriteLn('------------------------------');
    
    // 检查ViewBuildConfig.pas文件
    SourceFile := 'ViewBuildConfig.pas';
    if not FileExists(SourceFile) then
    begin
      WriteLn('错误: 源文件 ' + SourceFile + ' 不存在');
      Exit;
    end;
    
    // 创建备份
    BackupFile := 'ViewBuildConfig.pas.bak';
    if not FileExists(BackupFile) then
    begin
      TFile.Copy(SourceFile, BackupFile);
      WriteLn('已创建备份: ' + BackupFile);
    end;
    
    // 读取文件内容
    FileContent := TStringList.Create;
    try
      FileContent.LoadFromFile(SourceFile);
      
      // 查找ClearAllData方法并修复
      ClearAllDataIndex := -1;
      for i := 0 to FileContent.Count - 1 do
      begin
        if Pos('procedure TFrmBuildConfig.ClearAllData', FileContent[i]) > 0 then
        begin
          ClearAllDataIndex := i;
          Break;
        end;
      end;
      
      if ClearAllDataIndex >= 0 then
      begin
        // 在循环开始前添加有效性检查
        FoundBegin := False;
        InsertIndex := -1;
        
        for i := ClearAllDataIndex to FileContent.Count - 1 do
        begin
          if (not FoundBegin) and (Pos('begin', FileContent[i]) > 0) then
          begin
            FoundBegin := True;
            continue;
          end;
          
          if FoundBegin and (Pos('for i := 0 to tvJSON.Items.Count - 1 do', FileContent[i]) > 0) then
          begin
            InsertIndex := i;
            Break;
          end;
        end;
        
        if InsertIndex > 0 then
        begin
          // 插入安全检查代码
          FileContent.Insert(InsertIndex, '  // 添加安全检查');
          FileContent.Insert(InsertIndex + 1, '  if not Assigned(tvJSON) or (tvJSON.Items.Count = 0) then Exit;');
          FileContent.Insert(InsertIndex + 2, '');
          
          WriteLn('已修复 ClearAllData 方法');
          
          // 保存修改后的文件
          FileContent.SaveToFile(SourceFile);
          WriteLn('已保存修复后的文件');
        end
        else
        begin
          WriteLn('警告: 无法定位ClearAllData方法中的循环');
        end;
      end
      else
      begin
        WriteLn('警告: 未找到ClearAllData方法');
      end;
      
      WriteLn('完成。请重新编译项目以应用修复。');
    finally
      FileContent.Free;
    end;
    
    WriteLn('按任意键退出...');
    ReadLn;
  except
    on E: Exception do
      WriteLn('错误: ', E.ClassName, ': ', E.Message);
  end;
end. 