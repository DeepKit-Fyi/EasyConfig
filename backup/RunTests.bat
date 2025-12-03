@echo off
echo 配置编辑器测试运行脚本
echo ===================================

REM 设置Delphi编译器路径 - 根据实际安装位置修改
set DCC32_PATH=dcc32

echo 编译测试运行器...
%DCC32_PATH% TestRunner.dpr

if %ERRORLEVEL% NEQ 0 (
  echo 编译失败! 错误代码: %ERRORLEVEL%
  goto :end
)

echo.
echo 编译成功，开始运行测试...
echo ===================================

REM 使用控制台模式运行测试
TestRunner.exe console

echo.
echo 测试结束。

:end
echo ===================================
pause 