@echo off
echo 编译UTF-8转换工具...
dcc32 ConvertFilesToUTF8.dpr

if %ERRORLEVEL% NEQ 0 (
  echo 编译失败，按任意键退出...
  pause
  exit /b 1
)

echo 运行UTF-8转换工具...
ConvertFilesToUTF8.exe

echo 转换完成后，将新的ConfigEditor.dpr文件替换旧文件...
copy /y ConfigEditor.dpr.new ConfigEditor.dpr

echo 完成！按任意键退出...
pause
