@echo off
echo Compiling UTF-8 Converter Tool...
dcc32 ConvertFilesToUTF8.dpr

if %ERRORLEVEL% NEQ 0 (
  echo Compilation failed, press any key to exit...
  pause
  exit /b 1
)

echo Running UTF-8 Converter Tool...
ConvertFilesToUTF8.exe

echo After conversion, replacing old ConfigEditor.dpr file...
copy /y ConfigEditor.dpr.new ConfigEditor.dpr

echo Done! Press any key to exit...
pause
