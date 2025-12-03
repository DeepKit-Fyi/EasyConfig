program ReportViewer;

{$APPTYPE CONSOLE}

var
  ReportFile: TextFile;
  FileName, Line: string;

begin
  WriteLn('媒体配置测试报告查看器');
  WriteLn('===================================');
  
  // 设置报告文件名
  FileName := 'MediaConfigTestReport.txt';
  
  // 检查文件是否存在
  if not FileExists(FileName) then
  begin
    WriteLn('错误: 找不到测试报告文件 "', FileName, '"');
    WriteLn('请先运行测试程序生成报告');
    WriteLn;
    WriteLn('按任意键退出...');
    ReadLn;
    Exit;
  end;
  
  // 打开并显示报告内容
  WriteLn('正在显示测试报告: ', FileName);
  WriteLn;
  
  AssignFile(ReportFile, FileName);
  try
    Reset(ReportFile);
    while not Eof(ReportFile) do
    begin
      ReadLn(ReportFile, Line);
      WriteLn(Line);
    end;
  finally
    CloseFile(ReportFile);
  end;
  
  WriteLn;
  WriteLn('报告显示完成。');
  WriteLn('按任意键退出...');
  ReadLn;
end. 